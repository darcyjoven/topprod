# Prog. Version..: '5.30.06-13.04.09(00010)'     #
#
# Pattern name...: almt620.4gl
# Descriptions...: 儲值卡充值維護作業
# Date & Author..: FUN-870015 2008/08/11 By shiwuying
# Modify.........: FUN-960141 09/07/17 By dongbg 添加審核段邏輯
# Modify.........: No.FUN-960134 09/07/21 By shiwuying 市場移植
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960058 09/10/15 By destiny 修改逻辑
# Modify.........: No.FUN-9B0136 09/11/25 By destiny construct新增字段
# Modify.........: No.FUN-9C0084 09/12/16 By lutingting 重新過但正式區,程序并沒有修改 
# Modify.........: No:FUN-A10060 10/01/14 By shiwuying 權限處理
# Modify.........: No:TQC-A10138 10/01/21 By shiwuying 查詢賦值修改
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:TQC-A30075 10/03/15 By shiwuying 在SQL后加上SQLCA.sqlcode判斷
# Modify.........: No:MOD-A30234 10/03/30 By Smapmin 畫面上增加lpu12的欄位
# Modify.........: No:TQC-A30159 10/04/07 By Smapmin 現金/銀聯卡/支票的動作要寫在Transaction裡
# Modify.........: No:FUN-A70118 10/07/28 By shiwuying 增加lsn08交易門店字段
# Modify.........: No:FUN-A80008 10/08/02 By shiwuying SQL中的to_char改成BDL語法
# Modify.........: No:FUN-A70130 10/08/06 By wangxin 修正取號時及check編號所傳入的模組代碼及單據性質代碼
# Modify.........: No.FUN-A70130 10/08/10 By huangtao 取消lrk_file所有相關資料
# Modify.........: No:FUN-A80148 10/09/02 By lixh1 因為 lma_file 表已不再使用,所以將lma_file改為rtz_file的相應欄位
# Modify.........: No:TQC-B20065 11/02/16 By elva 增加参数
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60231 11/06/21 By baogc 交款時，現金欄位給默認值為交款應收餘額
# Modify.........: No.FUN-BC0112 12/01/05 By zhuhao 增加欄位加值金額及相應邏輯
# Modify.........: No.FUN-BA0068 12/01/30 By pauline mark lsn08 增加lsnlegal,lsnplant
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-C10051 12/02/02 By nanbing 確認時產生出貨單
# Modify.........: No.TQC-C30009 12/03/01 By nanbing 確認產生出貨單，充值金額為0時邏輯處理
# Modify.........: No.TQC-C20565 12/03/01 By zhangweib 出貨應收比率本賦值為0,導致產生應收帳款科目錯誤,現將oga162出貨應收比率的賦值修改為100
# Modify.........: No.MOD-C30209 12/03/12 By xumeimei 卡状态为注销时不可确认
# Modify.........: No.TQC-C30223 12/03/15 By pauline 不論客戶稅率為含稅/未稅,儲值金額皆已含稅價計算 
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改,新增t600sub_y_chk參數
# Modify.........: No:FUN-C40109 12/05/08 By baogc lrq_file添加lrqacti = 'Y'過濾條件
# Modify.........: No.FUN-C50058 12/05/15 By pauline 增加每次儲值最高金額以及總儲值金額判斷
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No:FUN-C60057 12/07/05 By Lori 卡管理-卡積分、折扣、儲值加值規則功能優化
# Modify.........: No:FUN-C70045 12/07/11 By yangxf 单据类型调整
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-C90046 12/09/11 By xumeimei 加值金额通过符合条件的最大充值基准计算
# Modify.........: No:FUN-C90085 12/09/18 By xumeimei 付款方式改为CALL s_pay()
# Modify.........: No:TQC-C90075 12/09/19 By dongsz FOREACH抓取rxy的資料，可新增多筆付款明細資料
# Modify.........: No.FUN-C90070 12/09/25 By xumeimei 添加GR打印功能
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/24 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-C90102 12/11/02 By pauline 將lsn_file檔案類別改為B.基本資料,將lsnplant用lsnstore取代
# Modify.........: No:FUN-CA0152 12/11/07 By xumeimei 添加取消审核逻辑
# Modify.........: No:FUN-CA0160 12/11/08 By baogc 添加POS單號
# Modify.........: No:FUN-CB0011 12/12/14 By Lori 確認前需確認aooi150是否有銷項0%稅別設定才可以確認
# Modify.........: No.FUN-CB0087 12/12/20 By xianghui 庫存理由碼改善
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:TQC-D30031 13/03/11 By wuxj 資料錄入后，儲值后儲值卡餘額欄位顯示
# Modify.........: No:CHI-D20015 13/03/28 By lixh1 整批修改update[確認]/[取消確認]動作時,要一併異動確認異動人員與確認異動日期
# Modify.........: No:FUN-C30177 13/04/02 By Sakura 將取消確認的action拿掉
# Modify.........: No:MOD-D70082 13/07/11 By SunLM 对oga53赋值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_lpu       RECORD LIKE lpu_file.*,
       g_lpu_t     RECORD LIKE lpu_file.*,
       g_lpu01_t   LIKE lpu_file.lpu01,
       g_wc        STRING,
       g_sql       STRING,
       g_oma       RECORD LIKE oma_file.*,     
       g_str       LIKE type_file.chr1000
 
DEFINE g_forupd_sql          STRING
DEFINE g_before_input_done   LIKE type_file.num5
DEFINE g_chr                 LIKE lpu_file.lpuacti
DEFINE g_cnt                 LIKE type_file.num10
DEFINE g_i                   LIKE type_file.num5
DEFINE g_msg                 LIKE type_file.chr1000
DEFINE g_curs_index          LIKE type_file.num10
DEFINE g_row_count           LIKE type_file.num10
DEFINE g_jump                LIKE type_file.num10
DEFINE g_no_ask             LIKE type_file.num5
#DEFINE g_t1                  LIKE lrk_file.lrkslip    #FUN-A70130  mark
DEFINE g_t1                  LIKE oay_file.oayslip    #FUN-A70130
DEFINE g_argv1               LIKE lpu_file.lpu01   #TQC-B20065 add
DEFINE g_oga01             LIKE oga_file.oga01        #FUN-C10051 add
#FUN-C90070----add---str
DEFINE g_wc1             STRING
DEFINE l_table           STRING
TYPE sr1_t RECORD
    lpu01     LIKE lpu_file.lpu01,
    lpuplant  LIKE lpu_file.lpuplant,
    lpu03     LIKE lpu_file.lpu03,
    lpj02     LIKE lpj_file.lpj02,
    lpu04     LIKE lpu_file.lpu04,
    lpu05     LIKE lpu_file.lpu05,
    lpu15     LIKE lpu_file.lpu15,
    lpu071    LIKE lpu_file.lpu071,
    lpu07     LIKE lpu_file.lpu07,
    lpu06     LIKE lpu_file.lpu06,
    lpu12     LIKE lpu_file.lpu12,
    lpu14     LIKE lpu_file.lpu14,
    lpu08     LIKE lpu_file.lpu08,
    lpu09     LIKE lpu_file.lpu09,
    lpu10     LIKE lpu_file.lpu10,
    lpu16     LIKE lpu_file.lpu16,
    lpu11     LIKE lpu_file.lpu11,
    rtz13     LIKE rtz_file.rtz13,
    lph02     LIKE lph_file.lph02,
    total     LIKE lpu_file.lpu04
END RECORD
#FUN-C90070----add---end
 
MAIN
   OPTIONS
        INPUT NO WRAP    #No.FUN-9B0136
    #   FIELD ORDER FORM #No.FUN-9B0136
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ALM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1 = ARG_VAL(1)  #TQC-B20065

   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   INITIALIZE g_lpu.* TO NULL

   #FUN-C90070----add---str
   LET g_pdate = g_today
   LET g_sql ="lpu01.lpu_file.lpu01,",
              "lpuplant.lpu_file.lpuplant,",
              "lpu03.lpu_file.lpu03,",
              "lpj02.lpj_file.lpj02,",
              "lpu04.lpu_file.lpu04,",
              "lpu05.lpu_file.lpu05,",
              "lpu15.lpu_file.lpu15,",
              "lpu071.lpu_file.lpu071,",
              "lpu07.lpu_file.lpu07,",
              "lpu06.lpu_file.lpu06,",
              "lpu12.lpu_file.lpu12,",
              "lpu14.lpu_file.lpu14,",
              "lpu08.lpu_file.lpu08,",
              "lpu09.lpu_file.lpu09,",
              "lpu10.lpu_file.lpu10,",
              "lpu16.lpu_file.lpu16,",
              "lpu11.lpu_file.lpu11,",
              "rtz13.rtz_file.rtz13,",
              "lph02.lph_file.lph02,",
              "total.lpu_file.lpu04"
   LET l_table = cl_prt_temptable('almt620',g_sql) CLIPPED
   IF l_table = -1 THEN
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog, g_time,2) RETURNING g_time
      CALL cl_gre_drop_temptable(l_table)
      EXIT PROGRAM
   END IF
   #FUN-C90070------add-----end 
   LET g_forupd_sql= "SELECT * FROM lpu_file WHERE lpu01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t620_cl CURSOR FROM g_forupd_sql                 # LOCK CURSOR
 
   OPEN WINDOW t620_w WITH FORM "alm/42f/almt620"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_set_comp_visible("lpu13",FALSE)  #FUN-C10051 add        
   CALL cl_set_act_visible("undo_confirm",FALSE) #FUN-C30177 add
   CALL cl_ui_init()
 
   LET g_action_choice = ""
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'
   #TQC-B20065 --begin
   IF NOT cl_null(g_argv1) THEN 
      LET g_action_choice="query"
      IF cl_chk_act_auth() THEN
         CALL t620_q()
      END IF
   END IF
   #TQC-B20065 --end
   CALL t620_menu()
   CLOSE WINDOW t620_w
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
   CALL cl_gre_drop_temptable(l_table)    #FUN-C90070 add
END MAIN
 
FUNCTION t620_curs()
    CLEAR FORM
    INITIALIZE g_lpu.* TO NULL
    #TQC-B20065 --begin
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = " lpu01='",g_argv1,"' AND lpu08='Y' "
    ELSE
    #TQC-B20065 --end
      #FUN-CA0160 Mark&Add Begin ---
      #CONSTRUCT BY NAME g_wc ON lpu01,lpuplant,lpulegal,lpu03,lpu04,lpu05,lpu07,
      #                          lpu09,lpu10,lpu13,lpu16,lpu11,lpu06,lpu12,lpu14,lpu08,   #MOD-A30234 add lpu12 # FUN-C10051 add lpu16
      #                          lpuuser,lpugrup,lpucrat,lpumodu,lpuacti,lpudate,
      #                          lpuorig,lpuoriu               #No.FUN-9B0136
       CONSTRUCT BY NAME g_wc ON lpu01,lpuplant,lpulegal,lpu03,lpu04,lpu05,lpu071,
                                 lpu06,lpu12,lpu15,lpu07,lpu14,lpu08,lpu09,lpu10,
                                 lpu13,lpu16,lpu17,lpu11,lpuuser,lpugrup,lpuoriu,
                                 lpuorig,lpucrat,lpumodu,lpuacti,lpudate
                                 
      #FUN-CA0160 Mark&Add End -----
          BEFORE CONSTRUCT
             CALL cl_qbe_init()
    
          ON ACTION controlp
             CASE
                WHEN INFIELD(lpu01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lpu01"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lpu01
                   NEXT FIELD lpu01
                WHEN INFIELD(lpuplant)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lpuplant"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lpuplant
                   NEXT FIELD lpuplant
                WHEN INFIELD(lpulegal)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lpulegal"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lpulegal
                   NEXT FIELD lpulegal
                WHEN INFIELD(lpu03)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_lpu03"
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO lpu03
                   NEXT FIELD lpu03
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
    END IF  #TQC-B20065
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN
    #            LET g_wc = g_wc clipped," AND lpuuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN
    #        LET g_wc = g_wc clipped," AND lpugrup MATCHES '",
    #                   g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN
    #        LET g_wc = g_wc clipped," AND lpugrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpuuser', 'lpugrup')
    #End:FUN-980030
 
    LET g_sql="SELECT lpu01 FROM lpu_file ",
        " WHERE ",g_wc CLIPPED,
#        "   AND lpuplant IN ",g_auth,
        " ORDER BY lpu01"
    PREPARE t620_prepare FROM g_sql
    DECLARE t620_cs
        SCROLL CURSOR WITH HOLD FOR t620_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM lpu_file ",
        " WHERE ",g_wc CLIPPED
#        "   AND lpuplant IN ",g_auth
    PREPARE t620_precount FROM g_sql
    DECLARE t620_count CURSOR FOR t620_precount
END FUNCTION
 
FUNCTION t620_menu()
   DEFINE l_cmd     LIKE type_file.chr1000
   DEFINE l_msg     LIKE type_file.chr1000
 #  DEFINE l_lrkdmy2 LIKE lrk_file.lrkdmy2   #FUN-A70130  mark
   DEFINE l_oayconf LIKE oay_file.oayconf    #FUN-A70130
   MENU ""
        BEFORE MENU
           CALL cl_navigator_setting(g_curs_index, g_row_count)
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
               CALL t620_a()
               LET g_t1=s_get_doc_no(g_lpu.lpu01)
               #單別設置里有維護單別，則找出是否需要自動審核
               IF NOT cl_null(g_t1) THEN
        #FUN-A70130 ------------------start-------------------------------
        #          SELECT lrkdmy2
        #            INTO l_lrkdmy2
        #            FROM lrk_file
        #           WHERE lrkslip = g_t1
                  #需要自動審核，則調用審核段
        #          IF l_lrkdmy2 = 'Y' THEN
                  SELECT oayconf INTO l_oayconf FROM oay_file
                  WHERE oayslip = g_t1
                  IF l_oayconf = 'Y' THEN
        #FUN-A70130------------------end----------------------------------
                     #自動審核傳2
                     CALL t620_y()
                  END IF
               END IF
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t620_q()
            END IF
        ON ACTION next
            CALL t620_fetch('N')
        ON ACTION previous
            CALL t620_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lpu.lpuplant,g_plant) THEN
                  CALL t620_u("u")
#               END IF
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lpu.lpuplant,g_plant) THEN
                  CALL t620_x()
#               END IF
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lpu.lpuplant,g_plant) THEN
                  CALL t620_r()
#               END IF
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lpu.lpuplant,g_plant) THEN
                  CALL t620_copy()
#               END IF
            END IF
       ON ACTION output
            LET g_action_choice="output"
            IF cl_chk_act_auth()THEN
               CALL t620_out()   #FUN-C90070 remark
            END IF
        ON ACTION confirm
           LET g_action_choice="confirm"
           IF cl_chk_act_auth() THEN
#              IF cl_chk_mach_auth(g_lpu.lpuplant,g_plant) THEN
                 CALL t620_y()
#              END IF
           END IF
#FUN-CA0152-------add------str
        ON ACTION undo_confirm
            LET g_action_choice="undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t620_z()
            END IF
#FUN-CA0152-------add------end

#FUN-C90085------mark---str
#       ON ACTION cash
#           LET g_action_choice="cash"
#           IF cl_chk_act_auth() then
#               IF cl_chk_mach_auth(g_lpu.lpuplant,g_plant) THEN
#                  CALL t620_cash()
#                  #-----MOD-A30234---------
#                  SELECT lpu12 INTO g_lpu.lpu12 FROM lpu_file 
#                     WHERE lpu01 = g_lpu.lpu01
#                  DISPLAY BY NAME g_lpu.lpu12
#                  #-----END MOD-A30234-----
#               END IF
#           END IF
#       ON ACTION card
#           LET g_action_choice="card"
#           IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lpu.lpuplant,g_plant) THEN
#                 IF NOT cl_null(g_lpu.lpu01) THEN
#                    IF g_lpu.lpuacti = 'N' THEN
#                       Call cl_err('','9028',1)
#                    ELSE
#                       LET l_msg = "almt6201  '",g_lpu.lpu01 CLIPPED,"' "
#                       CALL cl_cmdrun_wait(l_msg)
#                       #-----MOD-A30234---------
#                       SELECT lpu12 INTO g_lpu.lpu12 FROM lpu_file 
#                          WHERE lpu01 = g_lpu.lpu01
#                       DISPLAY BY NAME g_lpu.lpu12
#                       #-----END MOD-A30234-----
#                    END IF
#                 ELSE
#                    CALL cl_err('',-400,1)
#                 END IF
#               END IF
#           END IF
#       ON ACTION check
#           LET g_action_choice="check"
#           IF cl_chk_act_auth() THEN
#               IF cl_chk_mach_auth(g_lpu.lpuplant,g_plant) THEN
#                 IF NOT cl_null(g_lpu.lpu01) THEN
#                    IF g_lpu.lpuacti = 'N' THEN
#                       CALL cl_err('','9028',1)
#                    ELSE
#                       LET l_msg = "almt6202  '",g_lpu.lpu01 CLIPPED,"' "
#                       CALL cl_cmdrun_wait(l_msg)
#                       #-----MOD-A30234---------
#                       SELECT lpu12 INTO g_lpu.lpu12 FROM lpu_file 
#                          WHERE lpu01 = g_lpu.lpu01
#                       DISPLAY BY NAME g_lpu.lpu12
#                       #-----END MOD-A30234-----
#                    END IF
#                 ELSE
#                    CALL cl_err('',-400,1)
#                 END IF
#               END IF
#           END IF
#FUN-C90085------mark------end

#FUN-C90085----add----str
        ON ACTION pay
           LET g_action_choice="pay"
           IF cl_chk_act_auth() THEN
              IF cl_null(g_lpu.lpu01) THEN
                 CALL cl_err('',-400,1)
              ELSE
                 CALL s_pay('21',g_lpu.lpu01,g_lpu.lpuplant,g_lpu.lpu06,g_lpu.lpu08)
                 SELECT SUM(rxy05) INTO g_lpu.lpu12
                   FROM rxy_file
                  WHERE rxy00 = '21'
                    AND rxy01 = g_lpu.lpu01
                    AND rxyplant = g_lpu.lpuplant
                 IF cl_null(g_lpu.lpu12) THEN LET g_lpu.lpu12 = 0 END IF
                 DISPLAY BY NAME g_lpu.lpu12
                 UPDATE lpu_file SET lpu12 = g_lpu.lpu12
                  WHERE lpu01 = g_lpu.lpu01
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","lpu_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",1)
                 END IF
              END IF 
           END IF

        ON ACTION money_detail
           LET g_action_choice="money_detail"
           IF cl_chk_act_auth() THEN
              CALL s_pay_detail('21',g_lpu.lpu01,g_lpu.lpuplant,g_lpu.lpu08)
           END IF
#FUN-C90085----add----end
        ON ACTION help
            CALL cl_show_help()
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
        ON ACTION jump
            CALL t620_fetch('/')
        ON ACTION first
            CALL t620_fetch('F')
        ON ACTION last
            CALL t620_fetch('L')
        ON ACTION controlg
            CALL cl_cmdask()
        ON ACTION locale
            CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE MENU
        ON ACTION about
           CALL cl_about()
 
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
           LET INT_FLAG=FALSE
           LET g_action_choice = "exit"
           EXIT MENU
 
        ON ACTION related_document
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
              IF g_lpu.lpu01 IS NOT NULL THEN
                 LET g_doc.column1 = "lpu01"
                 LET g_doc.value1 = g_lpu.lpu01
                 CALL cl_doc()
              END IF
           END IF
 
     END MENU
     CLOSE t620_cs
END FUNCTION
 
FUNCTION t620_a()
 DEFINE l_cnt       LIKE type_file.num5
# DEFINE l_tqa06     LIKE tqa_file.tqa06         
 DEFINE li_result   LIKE type_file.num5
 
#####判斷當前組織機構是否是門店，只能在門店錄資料######
#   SELECT tqa06 INTO l_tqa06 FROM tqa_file
#    WHERE tqa03 = '14'
#      AND tqaacti = 'Y'
#      AND tqa01 IN(SELECT tqb03 FROM tqb_file
#                    WHERE tqbacti = 'Y'
#                      AND tqb09 = '2'
#                      AND tqb01 = g_plant)
#   IF cl_null(l_tqa06) OR l_tqa06 = 'N' THEN
#      CALL cl_err('','alm-600',1)
#      RETURN
#   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM rtz_file    
    WHERE rtz01 = g_plant
      AND rtz28 = 'Y'     #FUN-A80148
   IF l_cnt < 1 THEN
      CALL cl_err('','alm-606',1)
      RETURN
   END IF
######################################################
 
    MESSAGE ""
    CLEAR FORM
    INITIALIZE g_lpu.* LIKE lpu_file.*
    LET g_lpu01_t = NULL
    LET g_lpu_t.* = g_lpu.*
    LET g_wc = NULL
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_lpu.lpulegal =g_legal
        LET g_lpu.lpuplant = g_plant
        LET g_lpu.lpu05 = 0
        LET g_lpu.lpu06 = 0
        LET g_lpu.lpu07 = 0
        LET g_lpu.lpu071 = 100
        LET g_lpu.lpu08 = 'N'
        LET g_lpu.lpuuser = g_user
        LET g_lpu.lpuoriu = g_user #FUN-980030
        LET g_lpu.lpuorig = g_grup #FUN-980030
        LET g_lpu.lpugrup = g_grup
        LET g_lpu.lpuacti = 'Y'
        LET g_lpu.lpucrat = g_today
        LET g_data_plant = g_plant  #No.FUN-A10060

        CALL t620_i("a")
        IF INT_FLAG THEN
            INITIALIZE g_lpu.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_lpu.lpu01 IS NULL THEN
            CONTINUE WHILE
        END IF
 
        BEGIN WORK
        #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
        #CALL s_auto_assign_no("alm",g_lpu.lpu01,g_today,'21',"lpu_file","lpu01","","","") #FUN-A70130
        CALL s_auto_assign_no("alm",g_lpu.lpu01,g_today,'L9',"lpu_file","lpu01","","","") #FUN-A70130
           RETURNING li_result,g_lpu.lpu01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_lpu.lpu01
        LET g_lpu.lpu12 = 0
        #FUN-C10051 STA---
        IF cl_null(g_lpu.lpu15) THEN 
           LET g_lpu.lpu15 = 0
        END IF  
        #FUN-C10051 END---   
        INSERT INTO lpu_file VALUES(g_lpu.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","lpu_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",0)
            ROLLBACK WORK
            CONTINUE WHILE
        ELSE
           COMMIT WORK
           SELECT * INTO g_lpu.* FROM lpu_file
            WHERE lpu01 = g_lpu.lpu01
           CALL t620_show()    #TQC-D30031 add           
        END IF
        EXIT WHILE
    END WHILE
    LET g_wc=' '
END FUNCTION
 
FUNCTION t620_i(p_cmd)
   DEFINE p_cmd        LIKE type_file.chr1,
          l_input      LIKE type_file.chr1,
          l_n          LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5
#No.FUN-BC0112----add------begin--
   DEFINE l_lph40      LIKE lph_file.lph40
   DEFINE l_lph41      LIKE lph_file.lph41
   DEFINE l_lph42      LIKE lph_file.lph42
   DEFINE l_lrp02      LIKE lrp_file.lrp02
   DEFINE l_lrp06      LIKE lrp_file.lrp06   #FUN-C60057 add
   DEFINE l_lrp07      LIKE lrp_file.lrp07   #FUN-C60057 add
   DEFINE l_lpk10      LIKE lpk_file.lpk10
   DEFINE l_lpk13      LIKE lpk_file.lpk13
   DEFINE l_lrq06      LIKE lrq_file.lrq06
   DEFINE l_lrq07      LIKE lrq_file.lrq07
   DEFINE l_lrq08      LIKE lrq_file.lrq08
   DEFINE l_lrq09      LIKE lrq_file.lrq09
   DEFINE l_multiple   LIKE lpu_file.lpu05
   DEFINE l_multiple_1 LIKE type_file.num5
   DEFINE l_value      LIKE lpu_file.lpu05
   DEFINE l_lpj02      LIKE lpj_file.lpj02
   DEFINE l_lrq02      LIKE lrq_file.lrq02
#No.FUN-BC0112----add------end---- 
   DEFINE l_lph43      LIKE lph_file.lph43    #FUN-C50058 add
   DEFINE l_lph44      LIKE lph_file.lph44    #FUN-C50058 add
   DISPLAY BY NAME
      g_lpu.lpu05,g_lpu.lpu06,g_lpu.lpu07,g_lpu.lpu071,g_lpu.lpu14,
      g_lpu.lpu08,g_lpu.lpuuser,g_lpu.lpuacti,g_lpu.lpugrup,
      g_lpu.lpudate,g_lpu.lpucrat,g_lpu.lpuplant,g_lpu.lpulegal
   CALL t620_lpuplant(p_cmd)
 
   INPUT BY NAME g_lpu.lpuoriu,g_lpu.lpuorig,
      g_lpu.lpu01,g_lpu.lpu03,g_lpu.lpu05,g_lpu.lpu071,g_lpu.lpu14,g_lpu.lpu11
      WITHOUT DEFAULTS
 
      BEFORE INPUT
          LET l_input='N'
          LET g_before_input_done = FALSE
          CALL t620_set_entry(p_cmd)
          CALL t620_set_no_entry(p_cmd)
          CALL cl_set_comp_required("lpu05",TRUE)
          LET g_before_input_done = TRUE
          CALL cl_set_docno_format("lpu01")
 
      AFTER FIELD lpu01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_lpu.lpu01) THEN
            #CALL s_check_no("alm",g_lpu.lpu01,g_lpu01_t,'21',"lpu_file","lpu01","") #FUN-A70130
            CALL s_check_no("alm",g_lpu.lpu01,g_lpu01_t,'L9',"lpu_file","lpu01","") #FUN-A70130
                 RETURNING li_result,g_lpu.lpu01
            IF (NOT li_result) THEN
               LET g_lpu.lpu01=g_lpu_t.lpu01
               NEXT FIELD lpu01
            END IF
            DISPLAY BY NAME g_lpu.lpu01
         END IF
 
#      AFTER FIELD lpu01
#         IF g_lpu.lpu01 IS NOT NULL THEN
#            IF p_cmd = "a" OR
#               (p_cmd="u" AND g_lpu.lpu01 != g_lpu01_t)THEN
#               SELECT COUNT(*) INTO l_n FROM lpu_file
#                WHERE lpu01 = g_lpu.lpu01
#               IF l_n > 0 THEN
#                  CALL cl_err('',-239,0)
#                  NEXT FIELD lpu01
#               END IF
#            END IF
#         END IF
 
      AFTER FIELD lpu03
         IF g_lpu.lpu03 IS NOT NULL THEN
            CALL t620_lpu03(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_lpu.lpu03,g_errno,1)
               LET g_lpu.lpu03 = g_lpu_t.lpu03
               NEXT FIELD lpu03
            END IF
            CALL t620_lpu15()  #TQC-C30223 add
         ELSE
            DISPLAY NULL,NULL,NULL,NULL TO lpj02,lph02,lpu04,lpu071
         END IF
 
      AFTER FIELD lpu05
         IF NOT cl_null(g_lpu.lpu05) THEN
            IF g_lpu.lpu05 < 0 THEN
               CALL cl_err('','alm-061',0)
               NEXT FIELD lpu05
            END if
#No.FUN-BC0112---add-----begin--
            SELECT lpj02,lph40,lph41,lph42,lph43,lph44               #FUN-C50058 add lph43,lph44
              INTO l_lpj02,l_lph40,l_lph41,l_lph42,l_lph43,l_lph44   #FUN-C50058 add lph43,lph44
              FROM lpj_file,lph_file
             WHERE lpj03=g_lpu.lpu03 AND lpj02=lph01
               AND lph03 = 'Y'                                       #FUN-C50058 add
           #FUN-C50058 add START
            IF NOT cl_null(l_lph43) AND g_lpu.lpu05 > l_lph43 THEN
               CALL cl_err('','alm-h30',0)
               NEXT FIELD lpu05 
            END IF
           #FUN-C50058 add END
            IF l_lph40='Y' THEN
               SELECT lrp02,lrp06,lrp07 INTO l_lrp02,l_lrp06,l_lrp07     #FUN-C60057 add 
                 FROM lrp_file
                WHERE lrp00='3'
                  AND lrp01=l_lpj02
                  AND g_lpu.lpucrat BETWEEN lrp04 AND lrp05
                  AND lrpplant = g_plant     #FUN-C60057 add
                  AND lrpacti = 'Y'          #FUN-C60057 add
                  AND lrp09 = 'Y'            #FUN-C60057 add
               IF NOT cl_null(l_lrp02) THEN
                  SELECT lpk10,lpk13 INTO l_lpk10,l_lpk13
                    FROM lpk_file INNER JOIN lpj_file
                      ON lpk01=lpj01
                   WHERE lpj03=g_lpu.lpu03
                  IF l_lrp02 = '1' THEN
                     LET l_lrq02=l_lpk10
                  END IF
                  IF l_lrp02 = '2' THEN
                     LET l_lrq02=l_lpk13
                  END IF
                  #FUN-C90046-----add------str
                  SELECT MAX(lrq06) INTO l_lrq06
                    FROM lrq_file
                   WHERE lrq00='3'
                     AND lrq01=l_lpj02
                     AND lrq02=l_lrq02
                     AND ( lrq10 <= g_today
                           AND lrq11  >= g_today)
                     AND lrqacti = 'Y'
                     AND lrq12 = l_lrp06
                     AND lrq13 = l_lrp07
                     AND lrq06 <= g_lpu.lpu05
                     AND lrqplant = g_plant
                  #FUN-C90046-----add------end
                  #SELECT lrq06,lrq07,lrq08,lrq09 INTO l_lrq06,l_lrq07,l_lrq08,l_lrq09       #FUN-C90046 mark
                  SELECT lrq07,lrq08,lrq09 INTO l_lrq07,l_lrq08,l_lrq09                      #FUN-C90046 add
                    FROM lrq_file
                   WHERE lrq00='3'
                     AND lrq01=l_lpj02
                     AND lrq02=l_lrq02
                     AND ( lrq10 <= g_today        #TQC-C30223 add
                           AND lrq11  >= g_today)  #TQC-C30223 add
                     AND lrqacti = 'Y'  #FUN-C40109 Add
                     AND lrq12 = l_lrp06           #FUN-C60057 add
                     AND lrq13 = l_lrp07           #FUN-C60057 add
                     AND lrqplant = g_plant        #FUN-C60057 add
                     AND lrq06 <= g_lpu.lpu05      #FUN-C90046 add
                     AND lrq06 = l_lrq06           #FUN-C90046 add
               ELSE
                  LET l_lrq06 = l_lph41
                  LET l_lrq07 = l_lph42
                  LET l_lrq08 = 100
                  LET l_lrq09 = 'N'
               END IF
            END IF
#No.FUN-BC0112---add-----end----
            IF NOT cl_null(g_lpu.lpu071) THEN
               LET g_lpu.lpu07 = g_lpu.lpu05 * (100-g_lpu.lpu071)/100
               LET g_lpu.lpu06 = g_lpu.lpu05 - g_lpu.lpu07
               DISPLAY BY NAME g_lpu.lpu07,g_lpu.lpu06
               #No.FUN-BC0112---add---begin--
               IF (l_lph40 = 'Y') AND (g_lpu.lpu05 >= l_lrq06) THEN
                  LET l_multiple = g_lpu.lpu05 / l_lrq06
                  IF l_lrq09 = 'Y' THEN
                     LET l_multiple_1 = l_multiple 
                     LET l_multiple = l_multiple_1
                  END IF
                  LET l_value = l_multiple * l_lrq07
                  LET g_lpu.lpu15 = l_value * ( l_lrq08 / 100 )
                  LET g_lpu.lpu07 = g_lpu.lpu07 + g_lpu.lpu15
                 #LET g_lpu.lpu05 = g_lpu.lpu05 + g_lpu.lpu15   #TQC-C30223 mark
                  DISPLAY BY NAME g_lpu.lpu15,g_lpu.lpu07,g_lpu.lpu05
                  DISPLAY g_lpu.lpu05+g_lpu.lpu04+g_lpu.lpu15 TO FORMONLY.total_amt  #TQC-C30223 add
                 #FUN-C50058 add START
                  IF NOT cl_null(l_lph44) AND g_lpu.lpu05+g_lpu.lpu04+g_lpu.lpu15 > l_lph44 THEN
                     CALL cl_err('','alm-h31',0)
                     NEXT FIELD lpu05
                  END IF
                 #FUN-C50058 add END
               END IF
               #No.FUN-BC0112---add---begin--
            END IF
         END IF
      #NO.FUN-960058 
      #AFTER FIELD lpu071
      #   IF g_lpu.lpu071 IS NOT NULL THEN
      #      IF g_lpu.lpu071 < 0 OR g_lpu.lpu071 > 100 THEN
      #         CALL cl_err('','atm-070',0)
      #         NEXT FIELD lpu071
      #      END if
      #      IF NOT cl_null(g_lpu.lpu05) THEN
      #         LET g_lpu.lpu07 = g_lpu.lpu05 * (100-g_lpu.lpu071)/100
      #         LET g_lpu.lpu06 = g_lpu.lpu05 - g_lpu.lpu07
      #         DISPLAY BY NAME g_lpu.lpu07,g_lpu.lpu06
      #      END IF
      #   END IF
      #NO.FUN-960058 
      
      AFTER INPUT
         LET g_lpu.lpuuser = s_get_data_owner("lpu_file") #FUN-C10039
         LET g_lpu.lpugrup = s_get_data_group("lpu_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
 
         IF g_lpu.lpu01 IS NULL THEN
            DISPLAY BY NAME g_lpu.lpu01
            LET l_input='Y'
         END IF
         IF l_input='Y' THEN
            NEXT FIELD lpu01
         END IF
 
      ON ACTION controlp
        CASE
           WHEN INFIELD(lpu01)
              LET g_t1=s_get_doc_no(g_lpu.lpu01)
             # CALL q_lrk(FALSE,FALSE,g_t1,'21','ALM') RETURNING g_t1    #FUN-A70130 mark
             CALL q_oay(FALSE,FALSE,g_t1,'L9','ALM') RETURNING g_t1    #FUN-A70130  add
              LET g_lpu.lpu01 = g_t1
              DISPLAY BY NAME g_lpu.lpu01
              NEXT FIELD lpu01
           #NO.FUN-960058   
           #WHEN INFIELD(lpu03)
           #   CALL cl_init_qry_var()
           #   LET g_qryparam.form="q_lpt"
           #   LET g_qryparam.arg1=g_today
           #   LET g_qryparam.default1 =g_lpu.lpu03
           #   CALL cl_create_qry() RETURNING g_lpu.lpu03
           #   DISPLAY BY NAME g_lpu.lpu03
           #   NEXT FIELD lpu03
           WHEN INFIELD(lpu03)
              CALL cl_init_qry_var()
              LET g_qryparam.form="q_lpj2"
              LET g_qryparam.arg1=g_today
              LET g_qryparam.default1 =g_lpu.lpu03
              CALL cl_create_qry() RETURNING g_lpu.lpu03
              DISPLAY BY NAME g_lpu.lpu03
              NEXT FIELD lpu03              
           #NO.FUN-960058    
           OTHERWISE EXIT CASE
        END CASE
 
      ON ACTION CONTROLO
         IF INFIELD(lpu01) THEN
            LET g_lpu.* = g_lpu_t.*
            CALL t620_show()
            NEXT FIELD lpu01
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
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
 
FUNCTION t620_lpuplant(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_rtz13   LIKE rtz_file.rtz13
   DEFINE l_azt02   LIKE azt_file.azt02
 
   IF p_cmd <> 'u' THEN
      SELECT rtz13 INTO l_rtz13 FROM rtz_file
       WHERE rtz01 = g_lpu.lpuplant
      SELECT azt02 INTO l_azt02 FROM azt_file
       WHERE azt01 = g_lpu.lpulegal
 
      DISPLAY l_rtz13 TO FORMONLY.rtz13
      DISPLAY l_azt02 TO FORMONLY.azt02
   END IF
END FUNCTION
 
FUNCTION t620_lpu03(p_cmd)
   DEFINE l_lps09   LIKE lps_file.lps09
   DEFINE l_lptplant   LIKE lpt_file.lptplant
   DEFINE l_lpt03   LIKE lpt_file.lpt03
   DEFINE l_lpt04   LIKE lpt_file.lpt04
   DEFINE l_lpt05   LIKE lpt_file.lpt05
   DEFINE l_lph01   LIKE lph_file.lph01
   DEFINE l_lph02   LIKE lph_file.lph02
   DEFINE l_lph07   LIKE lph_file.lph07
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_lpsacti LIKE lps_file.lpsacti
   DEFINE l_cnt     LIKE type_file.num5
   #No.FUN-960058--BEGIN
   DEFINE l_lpj02   LIKE lpj_file.lpj02
   DEFINE l_lpj06   LIKE lpj_file.lpj06
   DEFINE l_lpj11   LIKE lpj_file.lpj11
   DEFINE l_lpj05   LIKE lpj_file.lpj05
   DEFINE l_lpj04   LIKE lpj_file.lpj04
   DEFINE l_lpj16   LIKE lpj_file.lpj16
   DEFINE l_lpj09   LIKE lpj_file.lpj09
   #No.FUN-960058--END
   LET g_errno=''
 
   #No.FUN-960058--BEGIN 
   #SELECT lptplant,lpt03,lpt05,lpt04,lps09
   #  INTO l_lptplant,l_lpt03,l_lpt05,l_lpt04,l_lps09
   #  FROM lpt_file,lps_file
   # WHERE lpt02 = g_lpu.lpu03
   #   AND lps01 = lpt01
   #CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-202'
   #                            LET l_lpt03 = NULL
   #                            LET l_lpt05 = NULL
   #     WHEN l_lps09 != 'Y'    LET g_errno = '9029'
   #     WHEN l_lptplant <> g_lpu.lpuplant LET g_errno ='alm-376'
   #     OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   #END CASE
   #IF cl_null(g_errno) AND NOT cl_null(l_lpt04) THEN
   #   IF l_lpt04 < g_today THEN
   #      LET g_errno = 'alm-211'
   #   END IF
   #END IF
   #IF cl_null(g_errno) THEN
   #   SELECT lph02,lph07
   #     INTO l_lph02,l_lph07
   #     FROM lph_file
   #    WHERE lph01 = l_lpt05
   #      AND lph03 = '1'
   #   CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-203'
   #                               LET l_lph02 = NULL
   #                               LET l_lph07 = NULL
   #        WHEN l_lph07!='Y'      LET g_errno='9029'
   #        OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'
   #   END CASE
   #END IF
   #SELECT count(*) INTO l_cnt FROM lpv_file
   # WHERE lpv03 = g_lpu.lpu03
   #IF l_cnt >0 THEN
   #   LET g_errno='alm-253'
   #END IF
   #IF cl_null(g_errno) OR p_cmd= 'd'  then
   #   LET g_lpu.lpu04 = l_lpt03
   #   DISPLAY BY name g_lpu.lpu04
   #   DISPLAY l_lph02 TO lph02
   #   DISPLAY l_lpt05 TO lpt05
   #END IF
   SELECT lpj02,lpj06,lpj11,lpj05,lpj04,lpj16,lpj09,lph07,lph02           
     INTO l_lpj02,l_lpj06,l_lpj11,l_lpj05,l_lpj04,l_lpj16,l_lpj09,l_lph07,l_lph02 
      FROM lpj_file,lph_file                       
     WHERE lpj03 = g_lpu.lpu03  AND lpj02=lph01                                                  
    CASE WHEN SQLCA.sqlcode=100 LET g_errno='alm-202'                      
     WHEN l_lph07 != 'Y'    LET g_errno = 'alm-826'                    
     WHEN l_lpj16 != 'Y'    LET g_errno = 'alm-825'   
     WHEN l_lpj09 != '2'    LET g_errno = 'alm-818'      
     WHEN l_lpj04 >g_today  LET g_errno = 'alm-827'
     WHEN l_lpj05 <g_today  LET g_errno = 'alm-827'                   
     OTHERWISE              LET g_errno=SQLCA.SQLCODE USING '-------'  
   END CASE   
   IF cl_null(g_errno) THEN       #MOD-C30209 add                                                        
      SELECT COUNT(*) INTO l_cnt FROM lpv_file WHERE lpv03=g_lpu.lpu03  
        IF l_cnt>0 THEN 
           LET g_errno='alm-253'
        END IF 
   END IF  #MOD-C30209 add
   IF cl_null(g_errno) OR p_cmd= 'd'  THEN 
      IF p_cmd <> 'd' THEN             #No.TQC-A10138
         LET g_lpu.lpu04 = l_lpj06  
         LET g_lpu.lpu071 = l_lpj11           
         DISPLAY BY name g_lpu.lpu04   
         DISPLAY BY name g_lpu.lpu071      
      END IF                           #No.TQC-A10138
      DISPLAY l_lph02 TO lph02             
      DISPLAY l_lpj02 TO lpj02            
   END IF                                  
   #No.FUN-960058--END 
END FUNCTION
   
FUNCTION t620_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    INITIALIZE g_lpu.* TO NULL
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    DISPLAY '   ' TO FORMONLY.total_amt  #TQC-C30223 add
    CALL t620_curs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN t620_count
    FETCH t620_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t620_cs
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,0)
        INITIALIZE g_lpu.* TO NULL
    ELSE
        CALL t620_fetch('F')
    END IF
END FUNCTION
 
FUNCTION t620_fetch(p_fllpu)
    DEFINE
        p_fllpu         LIKE type_file.chr1
 
    CASE p_fllpu
       WHEN 'N' FETCH NEXT     t620_cs INTO g_lpu.lpu01
       WHEN 'P' FETCH PREVIOUS t620_cs INTO g_lpu.lpu01
       WHEN 'F' FETCH FIRST    t620_cs INTO g_lpu.lpu01
       WHEN 'L' FETCH LAST     t620_cs INTO g_lpu.lpu01
       WHEN '/'
           IF (NOT g_no_ask) THEN
              CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
              LET INT_FLAG = 0
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
              IF INT_FLAG THEN
                  LET INT_FLAG = 0
                  EXIT CASE
              END IF
           END IF
           FETCH ABSOLUTE g_jump t620_cs INTO g_lpu.lpu01
           LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,0)
        INITIALIZE g_lpu.* TO NULL
        RETURN
    ELSE
      CASE p_fllpu
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx
    END IF
 
    SELECT * INTO g_lpu.* FROM lpu_file
       WHERE lpu01 = g_lpu.lpu01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","lpu_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",0)
    ELSE
        LET g_data_owner=g_lpu.lpuuser
        LET g_data_group=g_lpu.lpugrup
        LET g_data_plant = g_lpu.lpuplant #No.FUN-A10060
        CALL t620_show()
    END IF
END FUNCTION
 
FUNCTION t620_show()
    LET g_lpu_t.* = g_lpu.*
    DISPLAY BY NAME g_lpu.lpu01,g_lpu.lpu03,g_lpu.lpu04,g_lpu.lpu05, g_lpu.lpuoriu,g_lpu.lpuorig,
                    g_lpu.lpu15,  #FUN-BC0112
                    g_lpu.lpu06,g_lpu.lpu12,g_lpu.lpu07,g_lpu.lpu071,g_lpu.lpu14,g_lpu.lpu08,   #MOD-A30234   add lpu12
                    g_lpu.lpu09,g_lpu.lpu10,g_lpu.lpu11,g_lpu.lpu13,g_lpu.lpu16,g_lpu.lpu17,  #FUN-C10051 add lpu16 #FUN-CA0160 Add lpu17
                    g_lpu.lpuplant,g_lpu.lpulegal,
                    g_lpu.lpuuser,g_lpu.lpumodu,
                    g_lpu.lpugrup,g_lpu.lpudate,g_lpu.lpuacti,g_lpu.lpucrat
    DISPLAY g_lpu.lpu05+g_lpu.lpu04+g_lpu.lpu15  TO FORMONLY.total_amt  #TQC-C30223 add
    CALL t620_lpu03("d")
    CALL t620_lpuplant('d')
    CALL cl_set_field_pic(g_lpu.lpu08,"","","","",g_lpu.lpuacti)
    CALL cl_show_fld_cont()
END FUNCTION
 
FUNCTION t620_u(p_cmd)
    DEFINE   p_cmd     LIKE type_file.chr1
    DEFINE   l_cnt     LIKE type_file.num5
    IF g_lpu.lpu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_lpu.* FROM lpu_file WHERE lpu01=g_lpu.lpu01
    IF g_lpu.lpuacti = 'N' THEN
       CALL cl_err('',9027,0)
       RETURN
    END IF
    IF g_lpu.lpu08 = 'Y' THEN
       CALL cl_err('','mfg1005',0)
       RETURN
    END IF
 
    IF g_lpu.lpu12 > 0 then
       CALL cl_err('','alm-204',1)
       RETURN
    END IF
 
    SELECT count(*) INTO l_cnt FROM rxz_file
     WHERE rxz00 = '21'
       and rxz01 = g_lpu.lpu01
       and rxzplant = g_lpu.lpuplant
    IF l_cnt > 0 then
       Call cl_err('','alm-204',1)
       return
    END if
 
    select count(*) INTO l_cnt FROM rxy_file
     WHERE rxy00 = '21'
       and rxy01 = g_lpu.lpu01
       and rxyplant = g_lpu.lpuplant
    IF l_cnt > 0 then
       CALL cl_err('','alm-204',1)
       RETURN
    END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_lpu01_t = g_lpu.lpu01
    BEGIN WORK
 
    OPEN t620_cl USING g_lpu.lpu01
    IF STATUS THEN
       CALL cl_err("OPEN t620_cl:", STATUS, 1)
       CLOSE t620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t620_cl INTO g_lpu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,1)
        RETURN
    END IF
    IF p_cmd="u" THEN
       LET g_lpu.lpumodu=g_user
       LET g_lpu.lpudate = g_today
    END IF
    IF p_cmd="c" THEN
       LET g_lpu.lpumodu=NULL
       LET g_lpu.lpudate=NULl
    END IF
    CALL t620_show()
    WHILE TRUE
        CALL t620_i("u")
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_lpu.*=g_lpu_t.*
            CALL t620_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE lpu_file SET lpu_file.* = g_lpu.*
            WHERE lpu01 = g_lpu01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpu_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",0)
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t620_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t620_x()
    DEFINE l_cnt LIKE type_file.num5
    IF g_lpu.lpu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END if
    select * INTO g_lpu.* FROM lpu_file WHERE lpu01 = g_lpu.lpu01
    IF g_lpu.lpu08 = 'Y' THEN
       CALL cl_err('','9023',0)
       RETURN
    END IF
    IF g_lpu.lpu12 > 0 then
       CALL cl_err('','alm-204',1)
       RETURN
    END IF
    select count(*) INTO l_cnt FROM rxz_file
     WHERE rxz00 = '21'
       and rxz01 = g_lpu.lpu01
       and rxzplant = g_lpu.lpuplant
    IF l_cnt > 0 then
       Call cl_err('','alm-204',1)
       return
    END if
 
    select count(*) INTO l_cnt FROM rxy_file
     WHERE rxy00 = '21'
       and rxy01 = g_lpu.lpu01
       and rxyplant = g_lpu.lpuplant
    if l_cnt > 0 then
       Call cl_err('','alm-204',1)
       return
    END if
    BEGIN WORK
 
    OPEN t620_cl USING g_lpu.lpu01
    IF STATUS THEN
       CALL cl_err("OPEN t620_cl:", STATUS, 1)
       CLOSE t620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t620_cl INTO g_lpu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,1)
       RETURN
    END IF
    CALL t620_show()
    IF cl_exp(0,0,g_lpu.lpuacti) THEN
        LET g_chr=g_lpu.lpuacti
        IF g_lpu.lpuacti='Y' THEN
            LET g_lpu.lpuacti='N'
        ELSE
            LET g_lpu.lpuacti='Y'
        END IF
        UPDATE lpu_file
           SET lpuacti=g_lpu.lpuacti,
               lpumodu=g_user,
               lpudate=g_today
         WHERE lpu01=g_lpu.lpu01
        IF SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,0)
           LET g_lpu.lpuacti=g_chr
        ELSE
           LET g_lpu.lpumodu=g_user
           LET g_lpu.lpudate=g_today
           DISPLAY BY NAME g_lpu.lpuacti,g_lpu.lpumodu,g_lpu.lpudate
           CALL cl_set_field_pic("","","","","",g_lpu.lpuacti)
        END IF
    END IF
    CLOSE t620_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t620_r()
    DEFINE l_cnt LIKE type_file.num5
    IF g_lpu.lpu01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END if
    select * INTO g_lpu.* FROM lpu_file WHERE lpu01 = g_lpu.lpu01
    IF g_lpu.lpuacti = 'N' THEN
       CALL cl_err('','mfg1000',0)
       RETURN
    END IF
    IF g_lpu.lpu08 = 'Y' THEN
       CALL cl_err('',9023,0)
       RETURN
    END IF
    IF g_lpu.lpuacti = 'N' THEN
       CALL cl_err(g_lpu.lpu01,'alm-147',1)
       RETURN
    END IF
    IF g_lpu.lpu12 > 0 then
       CALL cl_err('','alm-204',1)
       RETURN
    END IF
    select count(*) INTO l_cnt FROM rxz_file
     WHERE rxz00 = '21'
       and rxz01 = g_lpu.lpu01
       and rxzplant = g_lpu.lpuplant
    IF l_cnt > 0 then
       Call cl_err('','alm-204',1)
       return
    END if
 
    select count(*) INTO l_cnt FROM rxy_file
     WHERE rxy00 = '21'
       and rxy01 = g_lpu.lpu01
       and rxyplant = g_lpu.lpuplant
    if l_cnt > 0 then
       Call cl_err('','alm-204',1)
       return
    END if
    BEGIN WORK
 
    OPEN t620_cl USING g_lpu.lpu01
    IF STATUS THEN
       CALL cl_err("OPEN t620_cl:", STATUS, 0)
       CLOSE t620_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t620_cl INTO g_lpu.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,0)
       RETURN
    END IF
    CALL t620_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "lpu01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_lpu.lpu01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
       DELETE FROM lpu_file WHERE lpu01 = g_lpu.lpu01
       #FUN-C90085----add----str
       CALL undo_pay( '21',g_lpu.lpu01,g_lpu.lpuplant,g_lpu.lpu06,g_lpu.lpu08)
       IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
       END IF
       #FUN-C90085----add----end
       CLEAR FORM
       OPEN t620_count
       #FUN-B50063-add-start--
       IF STATUS THEN
          CLOSE t620_cs
          CLOSE t620_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end-- 
       FETCH t620_count INTO g_row_count
       #FUN-B50063-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t620_cs
          CLOSE t620_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50063-add-end--
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t620_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t620_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET g_no_ask = TRUE
          CALL t620_fetch('/')
       END IF
    END IF
    CLOSE t620_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t620_copy()
 DEFINE l_newno    LIKE lpu_file.lpu01,
        l_oldno    LIKE lpu_file.lpu01,
        p_cmd      LIKE type_file.chr1,
        l_n        LIKE type_file.num5,
        l_input    LIKE type_file.chr1
 DEFINE li_result  LIKE type_file.num5
 
    IF g_lpu.lpu01 IS NULL THEN
       CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET l_input='N'
    LET g_before_input_done = FALSE
    CALL t620_set_entry('a')
    LET g_before_input_done = TRUE
    INPUT l_newno FROM lpu01
        BEFORE INPUT
            CALL cl_set_docno_format("lpu01")
 
        AFTER FIELD lpu01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(l_newno) THEN
            #CALL s_check_no("alm",l_newno,'','21',"lpu_file","lpu01","") #FUN-A70130
            CALL s_check_no("alm",l_newno,'','L9',"lpu_file","lpu01","") #FUN-A70130
                 RETURNING li_result,l_newno
            IF (NOT li_result) THEN
               NEXT FIELD lpu01
            END IF
            DISPLAY l_newno TO lpu01
         END IF
 
#        AFTER FIELD lpu01
#           IF l_newno IS NOT NULL THEN
#              SELECT COUNT(*) INTO l_n FROM lpu_file
#                WHERE lpu01 = l_newno
#               IF l_n > 0 THEN
#                  CALL cl_err('',-239,0)
#                  NEXT FIELD lpu01
#               END IF
#           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(lpu01)
                 LET g_t1=s_get_doc_no(l_newno)
                # CALL q_lrk(FALSE,FALSE,g_t1,'21','ALM') RETURNING g_t1   #FUN-A70130 mark
                  CALL q_oay(FALSE,FALSE,g_t1,'L9','ALM') RETURNING g_t1   #FUN-A70130 add
                 LET l_newno = g_t1
                 DISPLAY l_newno TO lpu01 
                 NEXT FIELD lpu01 
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
        DISPLAY BY NAME g_lpu.lpu01
        RETURN
    END IF
 
    #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
    #CALL s_auto_assign_no("alm",l_newno,g_today,'21',"lpu_file","lpu01","","","") #FUN-A70130
    CALL s_auto_assign_no("alm",l_newno,g_today,'L9',"lpu_file","lpu01","","","") #FUN-A70130
       RETURNING li_result,l_newno
    IF (NOT li_result) THEN
       RETURN
    END IF
    DISPLAY l_newno TO lpu01
 
    DROP TABLE x
    SELECT * FROM lpu_file
        WHERE lpu01=g_lpu.lpu01
        INTO TEMP x
    UPDATE x
        SET lpu01=l_newno,
            lpuplant=g_plant,
            lpu08='N',
            lpu09='',
            lpu10='',
            lpu12=0,
            lpu17='', #FUN-CA0160 Add
            lpuacti='Y',
            lpuuser=g_user,
            lpugrup=g_grup,
            lpumodu=NULL,
            lpudate=NULL,
            lpucrat=g_today
 
    INSERT INTO lpu_file
        SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","lpu_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",0)
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_lpu.lpu01
        LET g_lpu.lpu01 = l_newno
        SELECT lpu_file.* INTO g_lpu.* FROM lpu_file
               WHERE lpu01 = l_newno
        CALL t620_u("c")
        #SELECT lpu_file.* INTO g_lpu.* FROM lpu_file #FUN-C30027
        #       WHERE lpu01 = l_oldno                 #FUN-C30027
    END IF
    #LET g_lpu.lpu01 = l_oldno                        #FUN-C30027
    CALL t620_show()
END FUNCTION
 
FUNCTION t620_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("lpu01",TRUE)
     END IF
END FUNCTION
 
FUNCTION t620_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1
    IF p_cmd = 'u' AND g_chkey = 'N' THEN
       CALL cl_set_comp_entry("lpu01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t620_y()
   DEFINE   l_lpt11     LIKE lpt_file.lpt11
   DEFINE   l_lpt03     LIKE lpt_file.lpt03
   DEFINE   l_rxx04_1   LIKE rxx_file.rxx04
   DEFINE   l_rxx04_2   LIKE rxx_file.rxx04
   DEFINE   l_rxx04_3   LIKE rxx_file.rxx04
   DEFINE   l_flag      LIKE type_file.chr1                
   DEFINE   l_wc_gl     LIKE type_file.chr1000             
   DEFINE   l_oma01     LIKE oma_file.oma01                
   DEFINE   l_cnt       LIKE type_file.num5
   DEFINE   l_ogaconf   LIKE oga_file.ogaconf #FUN-C10051 add
   DEFINE   l_ogapost   LIKE oga_file.ogapost #FUN-C10051 add 
   DEFINE   l_rcj06     LIKE rcj_file.rcj06   #FUN-C10051 add
   DEFINE   l_lpj09     LIKE lpj_file.lpj09   #MOD-C30209 add
   DEFINE l_lpjpos      LIKE lpj_file.lpjpos  #FUN-D30007 add
   DEFINE l_lpjpos_o    LIKE lpj_file.lpjpos  #FUN-D30007 add
   DEFINE l_lpu09       LIKE lpu_file.lpu09   #CHI-D20015
   DEFINE l_lpu10       LIKE lpu_file.lpu10   #CHI-D20015

   IF cl_null(g_lpu.lpu01) THEN
        CALL cl_err('','-400',0)
        RETURN
   END IF
 
   SELECT * INTO g_lpu.* FROM lpu_file
    WHERE lpu01 = g_lpu.lpu01

   LET l_lpu09 = g_lpu.lpu09   #CHI-D20015
   LET l_lpu10 = g_lpu.lpu10   #CHI-D20015

   IF g_lpu.lpuacti='N' THEN
        CALL cl_err('','alm-048',0)
        RETURN
   END IF
 
   IF g_lpu.lpu08='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
   END IF
 
   IF g_lpu.lpu12 ! = g_lpu.lpu06 THEN
        CALL cl_err('','alm-201',0)
        RETURN
   END IF

   #MOD-C30209----add---str---
   SELECT lpj09 INTO l_lpj09
     FROM lpj_file
    WHERE lpj03 = g_lpu.lpu03
   IF l_lpj09 != '2' THEN
      CALL cl_err('','alm-818',0)
      RETURN
   END IF
   #MOD-C30209----add---end---
 
   #FUN-CB0011 add begin---
   SELECT COUNT(*) INTO l_cnt
     FROM gec_file
    WHERE gec011 = '2'
      And gec06 = '3'
      AND gecacti = 'Y'

   IF l_cnt = 0 THEN
      CALL cl_err('','alm2004',1)
      RETURN
   END IF
   #FUN-CB0011 add end-----

   IF NOT cl_confirm('alm-006') THEN
      RETURN
   END IF
#FUN-C10051 Mark START     
#   #FUN-960141 Add
#   DROP TABLE x
#   SELECT * FROM npq_file WHERE 1=2 INTO TEMP x
#   #FUN-960141 End
#FUN-C10051 Mark END   

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lpu.lpu03  
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END

   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t620_cl USING g_lpu.lpu01
   IF STATUS THEN
      CALL cl_err("OPEN t620_cl:", STATUS, 1)
      CLOSE t620_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t620_cl INTO g_lpu.*
      IF SQLCA.sqlcode THEN
      CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,0)
      CLOSE t620_cl
      ROLLBACK WORK
      RETURN
   END IF
      #No.FUN-960058--BEGIN  
      #SELECT lpt03 INTO l_lpt03 FROM lpt_file WHERE lpt02 = g_lpu.lpu03
      #UPDATE lpt_file SET lpt03 = l_lpt03 + g_lpu.lpu05
      #WHERE lpt02 = g_lpu.lpu03
      #IF SQLCA.sqlcode THEN
      #   CALL cl_err3("upd","lpu_file",g_lpu.lpu01,"",STATUS,"","",1)
      #   LET g_success = 'N'
      #ELSE
      #   SELECT count(*) INTO l_cnt 
      #     FROM lpj_file,lph_file
      #    WHERE lpj03 = g_lpu.lpu03
      #      AND lpj09 = '0'
      #      AND lph01 = lpj02
      #      AND lph03 = '1'
      #   IF l_cnt > 0 THEN
      #      UPDATE lpj_file SET lpj06 = l_lpt03 + g_lpu.lpu05
      #       WHERE lpj03 = g_lpu.lpu03
      #      IF SQLCA.sqlcode THEN
      #         CALL cl_err3("upd","lpj_file",g_lpu.lpu03,"",SQLCA.sqlcode,"","",1)
      #         LET g_success = 'N'
      #      END IF
      #   END IF
     #UPDATE lpj_file SET lpj06 = lpj06 + g_lpu.lpu05   #TQC-C30223 mark
      UPDATE lpj_file SET lpj06 = (lpj06+g_lpu.lpu05+g_lpu.lpu15),  #TQC-C30223 add                  
                          lpjpos = l_lpjpos         #FUN-D30007 add
       WHERE lpj03 = g_lpu.lpu03                                            
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                 
         CALL cl_err3("upd","lpj_file",g_lpu.lpu03,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'                                                
      END IF                                                                
#FUN-BA0068 mark START
#     INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsn08) #No.FUN-A70118
#             VALUES (g_lpu.lpu03,'4',g_lpu.lpu01,g_lpu.lpu05,g_today,g_lpu.lpu14,g_lpu.lpu071,g_lpu.lpuplant) #No.FUN-A70118
#FUN-BA0068 mark END
#FUN-BA0068 add START
     #INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsn09,lsnlegal,lsnplant,lsn10)  #TQC-C30223 add lsn09 #FUN-C70045 add lsn10  #FUN-C90102 mark 
      INSERT INTO lsn_file (lsn01,lsn02,lsn03,lsn04,lsn05,lsn06,lsn07,lsn09,lsnlegal,lsnstore,lsn10)   #FUN-C90102 add
             #VALUES (g_lpu.lpu03,'4',g_lpu.lpu01,g_lpu.lpu05,g_today,g_lpu.lpu14,g_lpu.lpu071,g_lpu.lpulegal,g_lpu.lpuplant)  #TQC-C30223 mark 
#             VALUES (g_lpu.lpu03,'4',g_lpu.lpu01,(g_lpu.lpu05+g_lpu.lpu15),g_today,  #TQC-C30223 add    #FUN-C70045 mark
              VALUES (g_lpu.lpu03,'3',g_lpu.lpu01,(g_lpu.lpu05+g_lpu.lpu15),g_today,                     #FUN-C70045 add
                      g_lpu.lpu14,g_lpu.lpu071,g_lpu.lpu15,g_lpu.lpulegal,g_lpu.lpuplant,'1')  #TQC-C30223 add  #FUN-C70045 add '1'
#FUN-BA0068 add END
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                 
         CALL cl_err3("ins","lsn_file",g_lpu.lpu03,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'                                                
      END IF   
      #FUN-C90085-----mark---str
      #No.FUN-960058--BEGIN 
      #  SELECT SUM(COALESCE(rxy05,0)) INTO l_rxx04_1
      #    FROM rxy_file
      #   WHERE rxy01 = g_lpu.lpu01
      #     AND rxy03 = '01'
      #     AND rxy00 = '21'
      #     AND rxyplant = g_lpu.lpuplant
 
      #  SELECT SUM(COALESCE(rxy05,0)) INTO l_rxx04_2
      #    FROM rxy_file
      #   WHERE rxy01 = g_lpu.lpu01
      #     AND rxy03 = '02'
      #     AND rxy00 = '21'
      #     AND rxyplant = g_lpu.lpuplant
 
      #  SELECT SUM(COALESCE(rxy05,0)) INTO l_rxx04_3
      #    FROM rxy_file
      #   WHERE rxy01 = g_lpu.lpu01
      #     AND rxy03 = '03'
      #     AND rxy00 = '21'
      #     AND rxyplant = g_lpu.lpuplant
 
      #  IF NOT cl_null(l_rxx04_1) THEN
      #     INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,
      #                          rxx11,rxxplant,rxxlegal)
      #                   VALUES('21',g_lpu.lpu01,'01','1',l_rxx04_1,
      #                          '','',g_lpu.lpuplant,g_lpu.lpulegal)
      #     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      #        CALL cl_err3("ins","rxx_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",1)
      #        LET g_success = 'N'
      #     END IF
      #  END IF
      #  IF NOT cl_null(l_rxx04_2) THEN
      #     INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,
      #                          rxx11,rxxplant,rxxlegal)
      #                   VALUES('21',g_lpu.lpu01,'02','1',l_rxx04_2,
      #                          '','',g_lpu.lpuplant,g_lpu.lpulegal)
      #     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      #        CALL cl_err3("ins","rxx_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",1)
      #        LET g_success = 'N' 
      #     END IF
      #  END IF
      #  IF NOT cl_null(l_rxx04_3) THEN
      #     INSERT INTO rxx_file(rxx00,rxx01,rxx02,rxx03,rxx04,rxx05,
      #                          rxx11,rxxplant,rxxlegal)
      #                   VALUES('21',g_lpu.lpu01,'03','1',l_rxx04_3,
      #                          '','',g_lpu.lpuplant,g_lpu.lpulegal)
      #     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      #        CALL cl_err3("ins","rxx_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",1)
      #        LET g_success = 'N' 
      #     END IF
      #  END IF
      #END IF
      #FUN-C90085-----mark---end
      IF g_success = 'N' THEN
         ROLLBACK WORK
         RETURN
      END IF
#FUN-C10051 Mark START     
#   #FUN-960141 add
#    CALL s_card_in(g_lpu.lpu01,'2') RETURNING l_flag,l_oma01   
#    IF NOT l_flag  THEN
#       LET g_success = 'N'
#       ROLLBACK WORK
#       RETURN 
#    END IF 
#   #FUN-960141 end
#FUN-C10051 Mark END
  
   UPDATE lpu_file SET lpu08 = 'Y',
                       lpu09 = g_user,
                       lpu10 = g_today
              #         lpu13 = l_oma01, #FUN-C10051 MARK                 
    WHERE lpu01 = g_lpu.lpu01                                                                                                 
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0THEN                                                                                                      
      CALL cl_err3("upd","lpu_file",g_lpu.lpu01,"",STATUS,"","",1)                                                            
     # ROLLBACK WORK  #FUN-C10051 MARK
      LET g_success = 'N'                                                                                                     
   ELSE                                                                                                                       
      LET g_lpu.lpu08 = 'Y'                                                                                                   
      LET g_lpu.lpu09 = g_user                                                                                                
      LET g_lpu.lpu10 = g_today                                                                                               
#      LET g_lpu.lpu13 = l_oma01 #FUN-C10051 MARK
      DISPLAY BY NAME g_lpu.lpu08,g_lpu.lpu09,g_lpu.lpu10#,g_lpu.lpu13 #FUN-C10051 MARK
      CALL cl_set_field_pic(g_lpu.lpu08,"","","","","")                                                                       
      SELECT lpt11 INTO l_lpt11 FROM lpt_file                                                                                 
       WHERE lpt02=g_lpu.lpu03                                                                                              
      IF l_lpt11 < g_lpu.lpu071 THEN                                                                                          
         UPDATE lpt_file SET lpt11 = g_lpu.lpu071                                                                             
          WHERE lpt02 = g_lpu.lpu03
        #No.TQC-A30075 -BEGIN-----
         IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","lpt_file",g_lpu.lpu03,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'  #FUN-C10051  add 
         END IF
        #No.TQC-A30075 -END-------
      END IF
   END IF                                  
   #FUN-960141 add
   #FUN-C10051 add START
   INITIALIZE g_oga01 TO NULL
   SELECT rcj06 INTO l_rcj06 FROM rcj_file
   IF cl_null(l_rcj06) THEN 
      CALL cl_err('','alm1591',0)
      LET g_success = 'N'
   END IF   
   IF g_success = 'Y' THEN 
   #IF g_success = 'Y' AND g_lpu.lpu05 > 0 THEN  #TQC-C30009 add MARK
      CALL t620_insert_oga()  
   END IF    
   #FUN-C10051 add END 
   IF g_success = 'Y' THEN 
      COMMIT WORK
   #FUN-C10051 MARK      
   #   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y' THEN                                                       
   #      SELECT * INTO g_oma.* FROM oma_file where oma01=l_oma01                                                                    
   #      LET l_wc_gl = 'npp01 = "',g_oma.oma01,'" AND npp011 = 1'                                                                   
   #      LET g_str="axrp590 '",l_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",                                                     
   #                 g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooy.ooygslp,"' '",                                                      
   #                 g_oma.oma02,"' 'Y' '0' 'Y' '",g_ooz.ooz02c,"' '",g_ooy.ooygslp1,"'"                                             
   #      CALL cl_cmdrun_wait(g_str)                                                                                                 
   #   END IF 
   #FUN-C10051 MARK
   #FUN-C10051 STA   
   ELSE  
      ROLLBACK WORK 
      LET g_lpu.lpu08 = 'N'
   #CHI-D20015 ----Begin-----
   #  LET g_lpu.lpu09 = ''
   #  LET g_lpu.lpu10 = ''   
      LET g_lpu.lpu09 = l_lpu09
      LET g_lpu.lpu10 = l_lpu10
   #CHI-D20015 ----End-------
      DISPLAY BY NAME g_lpu.lpu08,g_lpu.lpu09,g_lpu.lpu10 
      CALL cl_set_field_pic(g_lpu.lpu08,"","","","","")
   #FUN-C10051 END   
   END IF
   #FUN-960141 end
   #FUN-C10051 STA---
   IF g_success = 'Y' THEN 
   #IF g_success = 'Y' AND g_lpu.lpu05 > 0 THEN  #TQC-C30009 add MARK
      SELECT * INTO g_oaz.* FROM oaz_file WHERE oaz00='0'
      CALL t600sub_y_chk(g_oga01, NULL)	#CHI-C30118---add NULL			
      IF g_success = "Y" THEN				
         CALL t600sub_y_upd(g_oga01, NULL)
         SELECT ogaconf INTO l_ogaconf FROM oga_file WHERE oga01 = g_oga01
         IF l_ogaconf = 'Y' THEN     
            CALL t600sub_s('1', FALSE, g_oga01, FALSE)	
            SELECT ogapost INTO l_ogapost FROM oga_file WHERE oga01 = g_oga01
            IF l_ogapost = 'N' THEN 
               LET g_success = 'N'  
            END IF 
         ELSE
            LET g_success = 'N'
         END IF 
      END IF
      CALL t620_reconfirm()  
   END IF 
   
   #FUN-C10051 END ---
END FUNCTION
#FUN-CA0152--------add-----str
FUNCTION t620_z()
    DEFINE l_cnt        LIKE type_file.num5
    DEFINE l_ogapost    LIKE oga_file.ogapost
    DEFINE l_lpjpos     LIKE lpj_file.lpjpos  #FUN-D30007 add
    DEFINE l_lpjpos_o   LIKE lpj_file.lpjpos  #FUN-D30007 add

    LET g_success = 'Y'
    IF cl_null(g_lpu.lpu01) THEN
       CALL cl_err('','-400',0)
       RETURN
    END IF

    SELECT * INTO g_lpu.* FROM lpu_file WHERE lpu01 = g_lpu.lpu01 #FUN-CA0160 Add
 
    IF g_lpu.lpuacti='N' THEN
       CALL cl_err('','alm-973',0)
       RETURN
    END IF
 
    IF g_lpu.lpu08='N' THEN
       CALL cl_err('','9025',0)
       RETURN
    END IF

   #FUN-CA0160 Add Begin ---
    IF NOT cl_null(g_lpu.lpu17) THEN
       CALL cl_err(g_lpu.lpu17,'alm1638',0)
       RETURN
    END IF
   #FUN-CA0160 Add End -----

    CALL t620_undo_chk()
    IF g_success = 'N' THEN
       RETURN
    END IF
 
    IF NOT cl_confirm('alm-008') THEN
       RETURN
    END IF

    LET g_msg="axmp650 '",g_lpu.lpu16,"'"  CLIPPED      #出货单扣帐还原
    CALL cl_cmdrun_wait(g_msg)
    SELECT ogapost INTO l_ogapost
      FROM oga_file WHERE oga01=g_lpu.lpu16
    IF l_ogapost = 'Y' THEN
       LET g_success = 'N'
       RETURN
    END IF

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lpu.lpu03 
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END
 
    BEGIN WORK
 
    OPEN t620_cl USING g_lpu.lpu01
    IF STATUS THEN
       CALL cl_err("OPEN t620_cl:", STATUS, 1)
       CLOSE t620_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t620_cl INTO g_lpu.*
       IF SQLCA.sqlcode THEN
       CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,0)
       CLOSE t620_cl
       ROLLBACK WORK
       RETURN
    END IF

    DELETE FROM rxc_file
     WHERE rxc00 = '02'
       AND rxc01 = g_lpu.lpu16
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","rxc_file",g_lpu.lpu16,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    DELETE FROM oga_file 
     WHERE oga01 = g_lpu.lpu16
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","oga_file",g_lpu.lpu16,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    DELETE FROM ogb_file
      WHERE ogb01 = g_lpu.lpu16
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","ogb_file",g_lpu.lpu16,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    DELETE FROM ogi_file 
     WHERE ogi01 = g_lpu.lpu16
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","ogi_file",g_lpu.lpu16,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    DELETE FROM ogh_file
     WHERE ogh01 = g_lpu.lpu16
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","ogh_file",g_lpu.lpu16,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    DELETE FROM rxz_file
     WHERE rxz00='02'
       AND rxz01=g_lpu.lpu16
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","rxz_file",g_lpu.lpu16,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    DELETE FROM rxy_file
     WHERE rxy00='02'
       AND rxy01=g_lpu.lpu16
       AND rxy04='1'
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","rxy_file",g_lpu.lpu16,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    DELETE FROM rxx_file 
     WHERE rxx00='02'
       AND rxx01=g_lpu.lpu16
       AND rxx03='1'
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","rxx_file",g_lpu.lpu16,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    UPDATE lpj_file SET lpj06 = g_lpu.lpu04,
                        lpjpos = l_lpjpos   #FUN-D30007 add
     WHERE lpj03 = g_lpu.lpu03
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("upd","lpj_file",g_lpu.lpu03,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
    DELETE FROM lsn_file 
     WHERE lsn01 = g_lpu.lpu03 
       AND lsn02 = '3'
       AND lsn03 = g_lpu.lpu01
       AND lsn10 = '1'
    IF SQLCA.sqlcode THEN
       CALL cl_err3("del","lsn_file",g_lpu.lpu03,"",SQLCA.sqlcode,"","",1)
       LET g_success = 'N'
    END IF
#   UPDATE lpu_file SET lpu08 = 'N',lpu09 = '',lpu10 = '',lpu16 = '',lpumodu=g_user,lpudate=g_today            #CHI-D20015 mark
    UPDATE lpu_file SET lpu08 = 'N',lpu09 = g_user,lpu10 = g_today,lpu16 = '',lpumodu=g_user,lpudate=g_today   #CHI-D20015
     WHERE lpu01 = g_lpu.lpu01
    IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","lpu_file",g_lpu.lpu01,"",STATUS,"","",1)
      LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       LET g_lpu.lpu08 = 'N'
    #CHI-D20015 ---Begin----
    #  LET g_lpu.lpu09 = ''
    #  LET g_lpu.lpu10 = ''
       LET g_lpu.lpu09 = g_user
       LET g_lpu.lpu10 = g_today
    #CHI-D20015 ---End------
       LET g_lpu.lpu16 = ''
       LET g_lpu.lpumodu=g_user
       LET g_lpu.lpudate=g_today
       DISPLAY BY NAME g_lpu.lpu08,g_lpu.lpu09,g_lpu.lpu10,g_lpu.lpu16,g_lpu.lpumodu,g_lpu.lpudate
       CALL cl_set_field_pic(g_lpu.lpu08,"","","","","")
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
END FUNCTION

FUNCTION t620_undo_chk()
   DEFINE l_oga10       LIKE oga_file.oga10
   DEFINE l_lpj09       LIKE lpj_file.lpj09

   LET g_success = 'Y'
   SELECT lpj09 INTO l_lpj09
     FROM lpj_file
    WHERE lpj03 = g_lpu.lpu03
   IF l_lpj09 <> '2' THEN
      CALL cl_err('','alm-818',0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT oga10 INTO l_oga10
     FROM oga_file
    WHERE oga01 = g_lpu.lpu16
   IF NOT cl_null(l_oga10) THEN
      CALL cl_err('','alm1994',0)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
#FUN-CA0152--------add-----end

#FUN-C90085---------mark-----str 
#FUNCTION t620_cash()
#   DEFINE  p_cmd              LIKE type_file.chr1,
#           l_amt              LIKE lps_file.lps05
#   DEFINE l_rxy05             LIKE rxy_file.rxy05
#   DEFINE l_rxy01             LIKE rxy_file.rxy01
#   DEFINE l_rxy02             LIKE rxy_file.rxy02
#   DEFINE l_time              LIKE rxy_file.rxy22 #No.FUN-A80008
#
#   IF g_lpu.lpu01 IS NULL THEN
#      CALL cl_err('',-400,0)
#      RETURN
#   END IF
# 
#   SELECT * INTO g_lpu.* FROM lpu_file WHERE lpu01 = g_lpu.lpu01
#
#   #-----TQC-A30159---------
#    BEGIN WORK
# 
#    OPEN t620_cl USING g_lpu.lpu01
#    IF STATUS THEN
#       CALL cl_err("OPEN t620_cl:", STATUS, 0)
#       CLOSE t620_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    FETCH t620_cl INTO g_lpu.*
#    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_lpu.lpu01,SQLCA.sqlcode,0)
#       CLOSE t620_cl
#       ROLLBACK WORK
#       RETURN
#    END IF
#    CALL t620_show()
#   #-----END TQC-A30159-----
#
#   IF g_lpu.lpuacti = 'N' THEN
#      CALL cl_err('','9028',1)
#      CLOSE t620_cl   #TQC-A30159
#      ROLLBACK WORK   #TQC-A30159
#      RETURN
#   END IF
# 
#   IF g_lpu.lpu06 = g_lpu.lpu12 THEN
#      CALL cl_err('','alm-225',1)
#      CLOSE t620_cl   #TQC-A30159
#      ROLLBACK WORK   #TQC-A30159
#      RETURN
#   END IF
# 
#   OPEN WINDOW t6101_w WITH FORM "alm/42f/almt6101"
#       ATTRIBUTE (STYLE = g_win_style CLIPPED)
#   CALL cl_ui_locale("almt6101")
#   LET l_rxy05 = NULL
#   LET l_rxy01 = g_lpu.lpu01
#   LET l_rxy02 = NULL
# 
#   SELECT *
#     INTO g_lpu.*
#     FROM lpu_file
#    WHERE lpu01=g_lpu.lpu01
#   IF cl_null(g_lpu.lpu12) THEN
#      LET g_lpu.lpu12=0
#   END if
#   IF g_lpu.lpu08='Y' THEN
#        CALL cl_err('','9023',1)
#        CLOSE t620_cl   #TQC-A30159
#        ROLLBACK WORK   #TQC-A30159
#        CLOSE WINDOW t6101_w
#        RETURN
#   END IF
#   LET l_amt=g_lpu.lpu06 - g_lpu.lpu12
#
##TQC-B60231 - ADD - BEGIN -------------------------------
#   LET l_rxy05 = l_amt
#   DISPLAY l_rxy05 TO rxy05
##TQC-B60231 - ADD -  END  -------------------------------
#
#   DISPLAY l_amt TO FORMONLY.amt
##  INPUT l_rxy05 FROM rxy05                  #TQC-B60231 MARK
#   INPUT l_rxy05 WITHOUT DEFAULTS FROM rxy05 #TQC-B60231 ADD
# 
#      AFTER FIELD rxy05
#         IF NOT cl_null(l_rxy05) THEN
#            IF l_rxy05<=0 THEN
#               CALL cl_err('rxy05','alm-192',1)
#               NEXT FIELD rxy05
#            END if
#            IF g_lpu.lpu12 + l_rxy05 > g_lpu.lpu06 THEN
#               CALL cl_err('rxy05','alm-199',1)
#               NEXT FIELD rxy05
#            END IF
#         END IF
# 
#      AFTER INPUT
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0
#            LET l_rxy05=NULL
#            EXIT INPUT
#         END if
# 
#      ON ACTION CONTROLR
#         CALL cl_show_req_fields()
# 
#      ON ACTION CONTROLG
#         CALL cl_cmdask()
# 
#      ON ACTION CONTROLF                        # 欄位說明
#         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
#         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
#   END INPUT
# 
#   IF cl_null(l_rxy05) THEN  #放棄
#      CLOSE t620_cl   #TQC-A30159
#      ROLLBACK WORK   #TQC-A30159
#      CLOSE WINDOW t6101_w
#      RETURN
#   END if
# 
#   SELECT MAX(rxy02) INTO l_rxy02 FROM rxy_file WHERE rxy00='21' AND rxy01= l_rxy01
#   IF l_rxy02 IS NULL THEN
#      LET l_rxy02=0
#   END IF
#   LET l_rxy02=l_rxy02+1
#   LET l_time = TIME #No.FUN-A80008
#   INSERT INTO rxy_file(rxy00,rxy01,rxy02,rxy03,rxy04,rxy05,rxyplant,rxy21,
#                        rxy22,rxylegal)
#     VALUES('21',l_rxy01,l_rxy02,'01','1',l_rxy05,g_lpu.lpuplant,g_today,
#           #to_char(sysdate,'HH24:MI'),g_lpu.lpulegal) #No.FUN-A80008
#            l_time,g_lpu.lpulegal)                    #No.FUN-A80008
#   IF SQLCA.sqlcode THEN
#       CALL cl_err3("ins","rxy_file",l_rxy01,"",SQLCA.sqlcode,"","",0)
#    END if
# 
#    UPDATE lpu_file SET lpu12 = g_lpu.lpu12 + l_rxy05
#                    WHERE lpu01=g_lpu.lpu01
#    IF SQLCA.sqlcode THEN
#       CALL cl_err3("upd","lps_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",1)
#    END IF
#   CLOSE t620_cl   #TQC-A30159
#   COMMIT WORK     #TQC-A30159
#   CLOSE WINDOW t6101_w
#END FUNCTION
#FUN-C90085---------mark-----end
#No.FUN-960134
#FUN-9C0084    
#FUN-C10051 START---
FUNCTION t620_insert_oga()
DEFINE l_oga       RECORD LIKE oga_file.*
DEFINE li_result   LIKE type_file.num10
   #insert into oga_file-----
   LET l_oga.oga00 = '1'                 #出貨別
   LET l_oga.oga02 = g_today             #出貨日期 
   LET l_oga.oga06 = '0'                 #修改版本
   LET l_oga.oga07 = 'N'                 #出貨是否計入未開發票的銷貨待驗收入
   LET l_oga.oga08 = '1'                 #1.內銷 2.外銷  3.視同外銷
   LET l_oga.oga09 = '2'                 #單據別
   LET l_oga.oga161 = 0                  #訂金應收比率
  #LET l_oga.oga162 = 0                  #出貨應收比率     #No.TQC-C20565   Mark
   LET l_oga.oga162 = 100                #出貨應收比率     #No.TQC-C20565   Add
   LET l_oga.oga163 = 0                  #尾款應收比率   
   LET l_oga.oga30 = 'N'                 #包裝單確認碼 
   LET l_oga.oga52 = 0                   #原幣預收訂金轉銷貨收入金額
   LET l_oga.oga53 = 0                   #原幣應開發票未稅金額 
   LET l_oga.oga54 = 0                   #原幣已開發票未稅金額
   LET l_oga.oga55 = '1'                 #狀況碼
   LET l_oga.oga57 = '1'                 #發票性質
   LET l_oga.oga65 = 'N'                 #客戶出貨簽收否
   LET l_oga.oga69 = g_today             #輸入日期
   LET l_oga.oga83 = g_lpu.lpuplant      #銷貨營運中心 
   LET l_oga.oga84 = g_lpu.lpuplant      #取貨營運中心
   LET l_oga.oga85 = '1'                 #結算方式
   LET l_oga.oga903 = 'N'                #信用查核放行否
   LET l_oga.oga94 = 'N'                 #POS銷售否 Y-是,N-否
   LET l_oga.oga95 = '0'                 #本次積分 
   LET l_oga.ogacond = g_today           #審核日期
   LET l_oga.ogaconf = 'N'               #確認否/作廢碼
   LET l_oga.ogagrup = g_user            #資料所有部門 
   LET l_oga.ogalegal = g_lpu.lpulegal   #所屬法人
   LET l_oga.ogaorig = g_grup            #資料建立部門
   LET l_oga.ogaoriu = g_user            #資料建立者
   LET l_oga.ogaplant = g_lpu.lpuplant   #所屬營運中心
   LET l_oga.ogapost = 'N'               #出貨扣帳否
   LET l_oga.ogaprsw = 0                 #列印次數
   LET l_oga.ogauser = g_user            #資料所有者
   LET l_oga.ogaslk02 = '1'

   #出貨單號	自動產生出貨單號, 預設單號抓取 aooi410 的設定
   #FUN-C90050 mark begin---
   #SELECT rye03 INTO l_oga.oga01 FROM rye_file
   # WHERE rye01 = 'axm' AND rye02 = '50'
   #FUN-C90050 mark end-----

   CALL s_get_defslip('axm','50',g_plant,'N') RETURNING l_oga.oga01   #FUN-C90050 add

   CALL s_auto_assign_no("axm",l_oga.oga01,g_today,"","oga_file","oga01","","","") 
     RETURNING li_result,l_oga.oga01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(l_oga.oga01) THEN
      LET g_success='N'
      RETURN
   END IF
   #帳款客戶編號,arti200 門店對應散客代號
   SELECT rtz06 INTO l_oga.oga03 FROM rtz_file
    WHERE rtz01 = g_plant
   IF cl_null(l_oga.oga03) THEN 
      CALL cl_err('','alm1594',0)
      LET g_success = 'N'
      RETURN 
   END IF    
   #帳款客戶簡稱	散客代號對應客戶基本資料檔簡稱
   SELECT occ02 INTO l_oga.oga032 FROM occ_file 
    WHERE occ01 = l_oga.oga03 
   LET l_oga.oga04 = l_oga.oga03         #送貨客戶編號  
   LET l_oga.oga18 = l_oga.oga03         #收款客戶編號
   #取帳款客戶對應客戶主檔預設稅別,幣別,銷售分類一,價格條件,收款條件
   SELECT occ41,occ42,occ43,occ44,occ45 INTO 
     l_oga.oga21,l_oga.oga23,l_oga.oga25,l_oga.oga31,l_oga.oga32
     FROM occ_file
    WHERE occ01 = l_oga.oga03
   #取稅別對應稅率,聯數,含稅否
   SELECT gec04,gec05,gec07 INTO l_oga.oga211,l_oga.oga212,l_oga.oga213
     FROM gec_file
    WHERE gec01 = l_oga.oga21
      AND gec011 = '2'
   #匯率
   CALL s_currm(l_oga.oga23,l_oga.oga02,g_oaz.oaz52,g_plant)
     RETURNING l_oga.oga24
   #insert into ogb---
   CALL t620_insert_ogb(l_oga.oga01,l_oga.oga211,l_oga.oga213,l_oga.oga23)  
   IF g_success = 'N' THEN 
      RETURN
   END IF
   #----
   SELECT SUM(ogb14) INTO l_oga.oga50 FROM ogb_file
    WHERE ogb01 = l_oga.oga01
   SELECT SUM(ogb14t) INTO l_oga.oga51 FROM ogb_file
    WHERE ogb01 = l_oga.oga01 
    #MOD-D70082 add begin-------
    IF g_azw.azw04 = '2' THEN 
       LET l_oga.oga53=l_oga.oga50 * (l_oga.oga162 + l_oga.oga163) / 100
    END IF   
    #MOD-D70082 add end---------     
   INSERT INTO oga_file VALUES l_oga.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN 
   ELSE
      LET g_oga01 = l_oga.oga01
   END IF 
   CALL t620_insert_rx(l_oga.oga01)
   IF g_success = 'N' THEN 
      RETURN
   END IF   
END FUNCTION 
FUNCTION t620_insert_ogb(l_oga01,l_gec04,l_gec07,l_azi01)   
DEFINE l_lpt08 LIKE lpt_file.lpt08
DEFINE l_lpt10 LIKE lpt_file.lpt10
DEFINE l_lpt12 LIKE lpt_file.lpt12
DEFINE l_lpt15 LIKE lpt_file.lpt15
DEFINE l_oga01 LIKE oga_file.oga01
DEFINE l_gec04 LIKE gec_file.gec04
DEFINE l_gec07 LIKE gec_file.gec07
DEFINE l_azi01 LIKE azi_file.azi01
DEFINE t_azi04   LIKE azi_file.azi04
DEFINE l_ogb   RECORD LIKE ogb_file.*
DEFINE l_rxc   RECORD LIKE rxc_file.*
DEFINE l_oga14   LIKE oga_file.oga14  #FUN-CB0087
DEFINE l_oga15   LIKE oga_file.oga15  #FUN-CB0087

   LET l_ogb.ogb01 = l_oga01            #出貨單號
   LET l_ogb.ogb04 = 'MISCCARD'         #產品編號
   LET l_ogb.ogb05 = 'PCS'              #銷售單位
   LET l_ogb.ogb05_fac = 1              #銷售/庫存彙總單位換算率 
   LET l_ogb.ogb08 = g_lpu.lpuplant     #出貨營運中心編號
   LET l_ogb.ogb091 = ' '               #出貨儲位編號
   LET l_ogb.ogb092 = ' '               #出貨批號 
   LET l_ogb.ogb1005 = '1'              #作業方式
   LET l_ogb.ogb1006 = '100'            #折扣率
   LET l_ogb.ogb1012 = 'N'              #搭贈
   LET l_ogb.ogb1014 = 'N'              #保稅已放行否
   LET l_ogb.ogb12 = '1'                #實際出貨數量 
   LET l_ogb.ogb15_fac = 1              #銷售/庫存明細單位換算率
   LET l_ogb.ogb16 = 1                  #數量
   LET l_ogb.ogb17 = 'N'                #多倉儲批出貨否
   LET l_ogb.ogb18 = '0'                #預計出貨數量 
   LET l_ogb.ogb19 = 'N'                #檢驗否
   LET l_ogb.ogb44 = '1'                #經營方式
   LET l_ogb.ogb60 = 0                  #已開發票數量
   LET l_ogb.ogb63 = 0                  #銷退數量
   LET l_ogb.ogb64 = 0                  #銷退數量
   LET l_ogb.ogb916 = 'PCS'             #計價單位
   LET l_ogb.ogb917 = 1                 #計價單位 
   LET l_ogb.ogblegal = g_lpu.lpulegal  #所屬法人
   LET l_ogb.ogbplant = g_lpu.lpuplant  #所屬法人
   #FUN-C90049 mark begin---
   #SELECT rtz07 INTO l_ogb.ogb09 FROM rtz_file
   # WHERE rtz01 = g_plant 
   #FUN-C90049 mark end---
   CALL s_get_coststore(g_plant,l_ogb.ogb04) RETURNING l_ogb.ogb09   #FUN-C90049 add
   SELECT MAX(ogb03)+1 INTO l_ogb.ogb03 FROM ogb_file 
    WHERE ogb01 = l_oga01
   IF l_ogb.ogb03 IS NULL THEN 
      LET l_ogb.ogb03 = 1       #項次
   END IF
   SELECT azi04 INTO t_azi04 FROM azi_file
    WHERE azi01 = l_azi01
   IF g_lpu.lpu07 > 0 THEN 
      LET l_rxc.rxc00 = '02'             #單據別
      LET l_rxc.rxc01 = l_oga01          #單號 
      LET l_rxc.rxc02 = l_ogb.ogb03      #項次 
      LET l_rxc.rxc03 = '20'             #折價方式
      LET l_rxc.rxc04 = g_lpu.lpu01      #來源單號
      LET l_rxc.rxc06 = g_lpu.lpu07      #折價金額
      LET l_rxc.rxc07 = 0                #廠商促銷分攤比例
      LET l_rxc.rxc09 = 0                #返券金額
      LET l_rxc.rxc10 = 0                #廠商返券分攤比例
      LET l_rxc.rxclegal = g_legal       #所屬法人
      LET l_rxc.rxcplant = g_plant       #所屬營運中心 
      LET l_rxc.rxc15 = 0                #數量-參加促銷的數量
      LET l_rxc.rxc11 = 'N'
      INSERT INTO rxc_file VALUES l_rxc.*
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err3("ins","rxc_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF     
   END IF
   #原因碼
   SELECT rcj06 INTO l_ogb.ogb1001 FROM rcj_file
  #LET l_ogb.ogb13 = g_lpu.lpu05 - g_lpu.lpu07    #原幣單價  #TQC-C30223 mark
   LET l_ogb.ogb13 = g_lpu.lpu06  #TQC-C30223 add
  #TQC-C30223 mark START
  #不論客戶是含稅或未稅,皆已含稅價計算
  #IF l_gec07 = 'Y' THEN
  #   LET l_ogb.ogb14 = l_ogb.ogb13 / (1 + l_gec04/100)  #原幣未稅金額
  #   LET l_ogb.ogb14t = l_ogb.ogb13                 #原幣含稅金額
  #   CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14
  #ELSE
  #   LET l_ogb.ogb14 = l_ogb.ogb13
  #   LET l_ogb.ogb14t = l_ogb.ogb13 * (1 + l_gec04/100)
  #   CALL cl_digcut(l_ogb.ogb14t,t_azi04) RETURNING l_ogb.ogb14t
  #END IF 
  #TQC-C30223 mark END
   LET l_ogb.ogb14t = l_ogb.ogb13  #TQC-C30223 add
   LET l_ogb.ogb14 = l_ogb.ogb13   #TQC-C30223 add
  #LET l_ogb.ogb37 = g_lpu.lpu05         #基礎單价    #TQC-C30223 mark
   LET l_ogb.ogb37 = g_lpu.lpu06 + g_lpu.lpu07    #TQC-C30223 ad  #
   LET l_ogb.ogb47 = g_lpu.lpu07         #分攤折價=全部折價欄位值的合計
   #FUN-C50097 ADD BEGIN-----
   IF cl_null(l_ogb.ogb50) THEN 
     LET l_ogb.ogb50 = 0
   END IF 
   IF cl_null(l_ogb.ogb51) THEN 
     LET l_ogb.ogb51 = 0
   END IF 
   IF cl_null(l_ogb.ogb52) THEN 
     LET l_ogb.ogb52 = 0
   END IF                                      
   IF cl_null(l_ogb.ogb53) THEN 
     LET l_ogb.ogb53 = 0
   END IF 
   IF cl_null(l_ogb.ogb54) THEN 
     LET l_ogb.ogb54 = 0
   END IF 
   IF cl_null(l_ogb.ogb55) THEN 
     LET l_ogb.ogb55 = 0
   END IF
   #FUN-C50097 ADD END------- 
   #FUN-CB0087--add--str--
   IF g_aza.aza115 = 'Y' THEN
      SELECT oga14,oga15 INTO l_oga14,l_oga15 FROM oga_file WHERE oga01 = l_ogb.ogb01
      CALL s_reason_code(l_ogb.ogb01,l_ogb.ogb31,'',l_ogb.ogb04,l_ogb.ogb09,l_oga14,l_oga15) RETURNING l_ogb.ogb1001
      IF cl_null(l_ogb.ogb1001) THEN
         CALL cl_err(l_ogb.ogb1001,'aim-425',1)
         LET g_success="N"
         RETURN
      END IF
   END IF
   #FUN-CB0087--add--end--
   INSERT INTO ogb_file VALUES l_ogb.*
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","ogb_file",l_oga01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
      RETURN 
   END IF         
   CALL t620_insert_ogi(l_ogb.ogb01,l_ogb.ogb03,l_gec07,l_ogb.ogb12,l_ogb.ogb13)  #TQC-C30223 add  新增單身稅別明細
   
END FUNCTION 

FUNCTION t620_insert_rx(l_oga01)
DEFINE l_oga01     LIKE oga_file.oga01
DEFINE l_rxy03_01  RECORD LIKE rxy_file.*
DEFINE l_rxy03_02  RECORD LIKE rxy_file.*
DEFINE l_rxy03_03  RECORD LIKE rxy_file.*
DEFINE l_rxx03_01  RECORD LIKE rxx_file.*
DEFINE l_rxx03_02  RECORD LIKE rxx_file.*
DEFINE l_rxx03_03  RECORD LIKE rxx_file.*
DEFINE l_rxz       RECORD LIKE rxz_file.*
DEFINE l_sql       STRING                 #TQC-C90075 add
  #TQC-C90075 mark str---
  #SELECT * INTO l_rxy03_01.*
  #  FROM rxy_file
  # WHERE rxy00 = '21'
  #   AND rxy01 = g_lpu.lpu01
  #   AND rxy03 = '01'
  #   AND rxy04 = '1'
  #TQC-C90075 mark end---
  #TQC-C90075 add str---
   LET l_sql =" SELECT * FROM rxy_file ",
              "  WHERE rxy00 = '21' ",
              "    AND rxy01 = '",g_lpu.lpu01,"' ",
              "    AND rxy03 = '01' ",
              "    AND rxy04 = '1'  "
   PREPARE rxy_pre1 FROM l_sql
   DECLARE rxy_cs1 CURSOR FOR rxy_pre1
   FOREACH rxy_cs1 INTO l_rxy03_01.*
  #TQC-C90075 add end---
  #IF NOT cl_null(l_rxy03_01.rxy00) THEN   #TQC-C90075 mark 
      LET l_rxy03_01.rxy00 = '02'
      LET l_rxy03_01.rxy01 = l_oga01
      INSERT INTO rxy_file VALUES l_rxy03_01.*
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err3("ins","rxy_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF     
   END FOREACH                            #TQC-C90075 add
      SELECT * INTO l_rxx03_01.*
        FROM rxx_file
       WHERE rxx00 = '21'
         AND rxx01 = g_lpu.lpu01
         AND rxx02 = '01'
         AND rxx03 = '1'
      IF NOT cl_null(l_rxx03_01.rxx00) THEN 
         LET l_rxx03_01.rxx00 = '02'
         LET l_rxx03_01.rxx01 = l_oga01 
         INSERT INTO rxx_file VALUES l_rxx03_01.*
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
            CALL cl_err3("ins","rxx_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF 
  #END IF                                #TQC-C90075 mark 

  # ---------
  #TQC-C90075 mark str---
  #SELECT * INTO l_rxy03_02.*
  #  FROM rxy_file
  # WHERE rxy00 = '21'
  #   AND rxy01 = g_lpu.lpu01
  #   AND rxy03 = '02'
  #   AND rxy04 = '1'
  #TQC-C90075 mark end---
  #TQC-C90075 add str---
   LET l_sql = " SELECT * FROM rxy_file ",
               "  WHERE rxy00 = '21' ",
               "    AND rxy01 = '",g_lpu.lpu01,"' ",
               "    AND rxy03 = '02' ",
               "    AND rxy04 = '1' "
   PREPARE rxy_pre2 FROM l_sql
   DECLARE rxy_cs2 CURSOR FOR rxy_pre2
   FOREACH rxy_cs2 INTO l_rxy03_02.*
  #TQC-C90075 add end---
  #IF NOT cl_null(l_rxy03_02.rxy00) THEN     #TQC-C90075 mark
      LET l_rxy03_02.rxy00 = '02'
      LET l_rxy03_02.rxy01 = l_oga01
      INSERT INTO rxy_file VALUES l_rxy03_02.*
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err3("ins","rxy_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF     
   END FOREACH                               #TQC-C90075 add 
      SELECT * INTO l_rxx03_02.*
        FROM rxx_file
       WHERE rxx00 = '21'
         AND rxx01 = g_lpu.lpu01
         AND rxx02 = '02'
         AND rxx03 = '1'
      IF NOT cl_null(l_rxx03_02.rxx00) THEN 
         LET l_rxx03_02.rxx00 = '02'
         LET l_rxx03_02.rxx01 = l_oga01 
         INSERT INTO rxx_file VALUES l_rxx03_02.* 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
            CALL cl_err3("ins","rxx_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF
     #TQC-C90075 mark str---
     #SELECT * INTO l_rxz.*
     #  FROM rxz_file
     # WHERE rxz00 = '21'
     #   AND rxz01 = g_lpu.lpu01
     #TQC-C90075 mark end---
     #TQC-C90075 add str---
      LET l_sql = "SELECT * FROM rxz_file ",
                  " WHERE rxz00 = '21' ",
                  "   AND rxz01 = '",g_lpu.lpu01,"' "
      PREPARE rxz_pre FROM l_sql
      DECLARE rxz_cs CURSOR FOR rxz_pre
      FOREACH rxz_cs INTO l_rxz.*
     #TQC-C90075 add end---
      IF NOT cl_null(l_rxz.rxz00) THEN 
         LET l_rxz.rxz00 = '02'
         LET l_rxz.rxz01 = l_oga01 
         INSERT INTO rxz_file VALUES l_rxz.*
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
            CALL cl_err3("ins","rxz_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF 
      END FOREACH                           #TQC-C90075 add 
  #END IF                                   #TQC-C90075 mark
   #------------
  #TQC-C90075 mark str---
  #SELECT * INTO l_rxy03_03.*
  #  FROM rxy_file
  # WHERE rxy00 = '21'
  #   AND rxy01 = g_lpu.lpu01
  #   AND rxy03 = '03'
  #   AND rxy04 = '1'
  #TQC-C90075 mark end---
  #TQC-C90075 add str---
   LET l_sql = " SELECT * FROM rxy_file ",
               "  WHERE rxy00 = '21' ",
               "    AND rxy01 = '",g_lpu.lpu01,"' ",
               "    AND rxy03 = '03' ",
               "    AND rxy04 = '1' "
   PREPARE rxy_pre3 FROM l_sql
   DECLARE rxy_cs3 CURSOR FOR rxy_pre3
   FOREACH rxy_cs3 INTO l_rxy03_03.*
  #TQC-C90075 add end---
  #IF NOT cl_null(l_rxy03_03.rxy00) THEN    #TQC-C90075 mark 
      LET l_rxy03_03.rxy00 = '02'
      LET l_rxy03_03.rxy01 = l_oga01
      INSERT INTO rxy_file VALUES l_rxy03_03.*
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
         CALL cl_err3("ins","rxy_file",l_oga01,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN 
      END IF    
   END FOREACH                              #TQC-C90075 add
      SELECT * INTO l_rxx03_03.*
        FROM rxx_file
       WHERE rxx00 = '21'
         AND rxx01 = g_lpu.lpu01
         AND rxx02 = '03'
         AND rxx03 = '1'
      IF NOT cl_null(l_rxx03_03.rxx00) THEN 
         LET l_rxx03_03.rxx00 = '02'
         LET l_rxx03_03.rxx01 = l_oga01 
         INSERT INTO rxx_file VALUES l_rxx03_03.*
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0  THEN 
            CALL cl_err3("ins","rxx_file",l_oga01,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF 
  #END IF                                   #TQC-C90075 mark
END FUNCTION 
FUNCTION t620_reconfirm()
DEFINE l_lpj03   LIKE lpj_file.lpj03
DEFINE l_lpj09   LIKE lpj_file.lpj09
DEFINE l_lpjpos    LIKE lpj_file.lpjpos  #FUN-D30007 add
DEFINE l_lpjpos_o  LIKE lpj_file.lpjpos  #FUN-D30007 add

  #FUN-D30007 add START
   SELECT lpjpos INTO l_lpjpos_o FROM lpj_file WHERE lpj03 = g_lpu.lpu03 
   IF l_lpjpos_o <> '1' THEN
      LET l_lpjpos = '2'
   ELSE
      LET l_lpjpos = '1'
   END IF
  #FUN-D30007 add END

   BEGIN WORK 
   IF g_success = 'Y' THEN 
      UPDATE lpu_file SET lpu16 = g_oga01 WHERE lpu01 = g_lpu.lpu01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN 
         LET g_success = 'N'
         CALL cl_err('upd lpu:',SQLCA.SQLCODE,0) 
         LET g_lpu.lpu16 = NULL 
         DISPLAY BY NAME g_lpu.lpu16
      ELSE
         LET g_lpu.lpu16 = g_oga01
         DISPLAY BY NAME g_lpu.lpu16   
      END IF  
   END IF    
      
   IF g_success = 'N' THEN 
      IF NOT cl_null(g_lpu.lpu16) AND g_lpu.lpu08 = 'Y' THEN 
         CALL cl_err('','alm1582',0)
         RETURN 
      END IF 
      DELETE FROM oga_file WHERE oga01 = g_oga01
      DELETE FROM ogb_file WHERE ogb01 = g_oga01
      DELETE FROM ogi_file WHERE ogi01 = g_oga01   #FUN-C90085 add
      DELETE FROM rxc_file WHERE rxc00 = '02' AND rxc01 = g_oga01
                                              AND rxc03 = '20'
      DELETE FROM rxy_file WHERE rxy00 = '02' AND rxy01 = g_oga01
                                              AND rxy03 IN ('01','02','03')
                                              AND rxy04 = '1'  
      DELETE FROM rxx_file WHERE rxx00 = '02' AND rxx01 = g_oga01
                                              AND rxx02 IN ('01','02','03')
                                              AND rxx03 = '1'
      DELETE FROM rxz_file WHERE rxz00 = '02' AND rxz01 = g_oga01

     #DELETE FROM rxx_file WHERE rxx00 = '21' AND rxx01 = g_lpu.lpu01         #FUN-C90085 mark
     #                                        AND rxx02 IN ('01','02','03')   #FUN-C90085 mark
     #                                        AND rxx03 = '1'                 #FUN-C90085 mark


      UPDATE lpj_file
         SET lpj06 = lpj06 - g_lpu.lpu05, 
             lpjpos = l_lpjpos   #FUN-D30007 add
       WHERE lpj03 = g_lpu.lpu03 
    
#     DELETE FROM lsn_file WHERE lsn02 = '4' AND lsn03 = g_lpu.lpu01                      #FUN-C70045 MARK
      DELETE FROM lsn_file WHERE lsn02 = '3' AND lsn10 ='1' AND lsn03 = g_lpu.lpu01       #FUN-C70045 add
      UPDATE lpu_file 
         SET lpu08 = 'N',
             lpu09 = '',
             lpu10 = ''
       WHERE lpu01 = g_lpu.lpu01 
      LET g_lpu.lpu08 = 'N'
      LET g_lpu.lpu09 = ''
      LET g_lpu.lpu10 = ''   
      DISPLAY BY NAME g_lpu.lpu08,g_lpu.lpu09,g_lpu.lpu10 
      CALL cl_set_field_pic(g_lpu.lpu08,"","","","","")
   END IF
   COMMIT WORK 
END FUNCTION  
#FUN-C10051 END ---
#TQC-C30223 add START
FUNCTION t620_lpu15()
   DEFINE l_lph40      LIKE lph_file.lph40
   DEFINE l_lph41      LIKE lph_file.lph41
   DEFINE l_lph42      LIKE lph_file.lph42
   DEFINE l_lrp02      LIKE lrp_file.lrp02
   DEFINE l_lrp06      LIKE lrp_file.lrp06    #FUN-C60057 add
   DEFINE l_lrp07      LIKE lrp_file.lrp07    #FUN-C60057 add
   DEFINE l_lpk10      LIKE lpk_file.lpk10
   DEFINE l_lpk13      LIKE lpk_file.lpk13
   DEFINE l_lrq06      LIKE lrq_file.lrq06
   DEFINE l_lrq07      LIKE lrq_file.lrq07
   DEFINE l_lrq08      LIKE lrq_file.lrq08
   DEFINE l_lrq09      LIKE lrq_file.lrq09
   DEFINE l_multiple   LIKE lpu_file.lpu05
   DEFINE l_multiple_1 LIKE type_file.num5
   DEFINE l_value      LIKE lpu_file.lpu05
   DEFINE l_lpj02      LIKE lpj_file.lpj02
   DEFINE l_lrq02      LIKE lrq_file.lrq02

   IF cl_null(g_lpu.lpu05) OR cl_null(g_lpu.lpu03) THEN RETURN END IF 
   SELECT lpj02,lph40,lph41,lph42
     INTO l_lpj02,l_lph40,l_lph41,l_lph42
     FROM lpj_file,lph_file
    WHERE lpj03=g_lpu.lpu03 AND lpj02=lph01
   IF l_lph40='Y' THEN
      SELECT lrp02,lrp06,lrp07 INTO l_lrp02,l_lrp06,l_lrp07           #FUN-C60057 add lrp06,lrp07  
        FROM lrp_file
       WHERE lrp00='3'
         AND lrp01=l_lpj02
         AND g_lpu.lpucrat BETWEEN lrp04 AND lrp05
         AND lrp09 = 'Y'     #FUN-C60057 add
         AND lrpacti = 'Y'   #FUN-C60057 add
      IF NOT cl_null(l_lrp02) THEN
         SELECT lpk10,lpk13 INTO l_lpk10,l_lpk13
           FROM lpk_file INNER JOIN lpj_file
             ON lpk01=lpj01
          WHERE lpj03=g_lpu.lpu03
         IF l_lrp02 = '1' THEN
            LET l_lrq02=l_lpk10
         END IF
         IF l_lrp02 = '2' THEN
            LET l_lrq02=l_lpk13
         END IF
         #FUN-C90046-----add------str
         SELECT MAX(lrq06) INTO l_lrq06
           FROM lrq_file
          WHERE lrq00='3'
            AND lrq01=l_lpj02
            AND lrq02=l_lrq02
            AND ( lrq10 <= g_today
                  AND lrq11  >= g_today)
            AND lrqacti = 'Y'
            AND lrq12 = l_lrp06
            AND lrq13 = l_lrp07
            AND lrq06 <= g_lpu.lpu05
            AND lrqplant = g_plant
         #FUN-C90046-----add------end
         #SELECT lrq06,lrq07,lrq08,lrq09 INTO l_lrq06,l_lrq07,l_lrq08,l_lrq09        #FUN-C90046 mark
         SELECT lrq07,lrq08,lrq09 INTO l_lrq07,l_lrq08,l_lrq09                       #FUN-C90046 add
           FROM lrq_file
          WHERE lrq00='3'
            AND lrq01=l_lpj02
            AND lrq02=l_lrq02
            AND ( lrq10 <= g_today        #TQC-C30223 add
                  AND lrq11  >= g_today)  #TQC-C30223 add
            AND lrqacti = 'Y'  #FUN-C40109 Add
            AND lrq12 = l_lrp06           #FUN-C60057 add
            AND lrq13 = l_lrp07           #FUN-C60057 add
            AND lrqplant = g_plant        #FUN-C60057 add
            AND lrq06 <= g_lpu.lpu05      #FUN-C90046 add
            AND lrq06 = l_lrq06           #FUN-C90046 add
      ELSE
         LET l_lrq06 = l_lph41
         LET l_lrq07 = l_lph42
         LET l_lrq08 = 100
         LET l_lrq09 = 'N'
      END IF
      IF NOT cl_null(g_lpu.lpu071) THEN
         LET g_lpu.lpu07 = g_lpu.lpu05 * (100-g_lpu.lpu071)/100
         LET g_lpu.lpu06 = g_lpu.lpu05 - g_lpu.lpu07
         DISPLAY BY NAME g_lpu.lpu07,g_lpu.lpu06
         #No.FUN-BC0112---add---begin--
         IF (l_lph40 = 'Y') AND (g_lpu.lpu05 >= l_lrq06) THEN
            LET l_multiple = g_lpu.lpu05 / l_lrq06
            IF l_lrq09 = 'Y' THEN
               LET l_multiple_1 = l_multiple
               LET l_multiple = l_multiple_1
            END IF
            LET l_value = l_multiple * l_lrq07
            LET g_lpu.lpu15 = l_value * ( l_lrq08 / 100 )
            LET g_lpu.lpu07 = g_lpu.lpu07 + g_lpu.lpu15
           #LET g_lpu.lpu05 = g_lpu.lpu05 + g_lpu.lpu15   #TQC-C30223 mark
            DISPLAY BY NAME g_lpu.lpu15,g_lpu.lpu07,g_lpu.lpu05
            DISPLAY g_lpu.lpu05+g_lpu.lpu04+g_lpu.lpu15 TO FORMONLY.total_amt  #TQC-C30223 add
         END IF
         #No.FUN-BC0112---add---begin--
      END IF
   END IF

END FUNCTION

#新增單身稅別明細
FUNCTION t620_insert_ogi(p_ogi01,p_ogi02,p_ogi07,p_ogb12,p_ogb13)
DEFINE p_ogi01             LIKE ogi_file.ogi01  #單號
DEFINE p_ogi02             LIKE ogi_file.ogi02  #項次
DEFINE p_ogi07             LIKE ogi_file.ogi07  #含稅否
DEFINE p_ogb12             LIKE ogb_file.ogb12  #數量
DEFINE p_ogb13             LIKE ogb_file.ogb13  #原幣單價
DEFINE l_ogi    RECORD     LIKE ogi_file.*
DEFINE l_sql               STRING
DEFINE l_rte08             LIKE rte_file.rte08
DEFINE l_rtz04             LIKE rtz_file.rtz04
DEFINE l_rvy05             LIKE rvy_file.rvy05

   LET l_ogi.ogi01 = p_ogi01   #FUN-C90085 add
   LET l_ogi.ogi02 = p_ogi02   #FUN-C90085 add
   SELECT MAX(ogi03) INTO l_ogi.ogi03 FROM ogi_file
      WHERE ogi01 = l_ogi.ogi01
   IF cl_null(l_ogi.ogi03) OR l_ogi.ogi03 = 0 THEN
      LET l_ogi.ogi03 = 1
   ELSE
      LET l_ogi.ogi03 = l_ogi.ogi03 + 1
   END IF

   #LET l_ogi.ogi01 = p_ogi01   #FUN-C90085 mark
   #LET l_ogi.ogi02 = p_ogi02   #FUN-C90085 mark
   SELECT MAX(gec01) INTO l_ogi.ogi04
     FROM gec_file
       WHERE gec06 = '3'
         AND gec011 = '2'
         AND gecacti = 'Y'
   LET l_ogi.ogi05 = 0

   LET l_ogi.ogi06 = 0
   LET l_ogi.ogi08 = 0
   LET l_ogi.ogi07 = p_ogi07

   LET l_ogi.ogi08t = p_ogb12 * p_ogb13
   LET l_ogi.ogi08  = p_ogb12 * p_ogb13

   LET l_ogi.ogi09 = l_ogi.ogi08t - l_ogi.ogi08
   LET l_ogi.ogidate = g_today
   LET l_ogi.ogigrup = g_grup
   LET l_ogi.ogimodu = g_user
   LET l_ogi.ogiuser = g_user
   LET l_ogi.ogioriu = g_user
   LET l_ogi.ogiorig = g_grup
   LET l_ogi.ogiplant = g_plant
   LET l_ogi.ogilegal = g_legal
   INSERT INTO ogi_file VALUES(l_ogi.*)
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','',l_ogi.ogi01,SQLCA.sqlcode,1)
      LET g_success="N"
   END IF
END FUNCTION
#TQC-C30223 add END
#FUN-C90070-------add------str
FUNCTION t620_out()
DEFINE l_sql     LIKE type_file.chr1000, 
       l_rtz13   LIKE rtz_file.rtz13,
       l_lph02   LIKE lph_file.lph02,
       l_total   LIKE lpu_file.lpu04,
       sr        RECORD
                 lpu01     LIKE lpu_file.lpu01,
                 lpuplant  LIKE lpu_file.lpuplant,
                 lpu03     LIKE lpu_file.lpu03,
                 lpj02     LIKE lpj_file.lpj02,
                 lpu04     LIKE lpu_file.lpu04,
                 lpu05     LIKE lpu_file.lpu05,
                 lpu15     LIKE lpu_file.lpu15,
                 lpu071    LIKE lpu_file.lpu071,
                 lpu07     LIKE lpu_file.lpu07,
                 lpu06     LIKE lpu_file.lpu06,
                 lpu12     LIKE lpu_file.lpu12,
                 lpu14     LIKE lpu_file.lpu14,
                 lpu08     LIKE lpu_file.lpu08,
                 lpu09     LIKE lpu_file.lpu09,
                 lpu10     LIKE lpu_file.lpu10,
                 lpu16     LIKE lpu_file.lpu16,
                 lpu11     LIKE lpu_file.lpu11
                 END RECORD
 
     CALL cl_del_data(l_table) 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('lpuuser', 'lpugrup') 
     IF cl_null(g_wc) THEN LET g_wc = " lpu01 = '",g_lpu.lpu01,"'" END IF
     LET l_sql = "SELECT lpu01,lpuplant,lpu03,lpj02,lpu04,lpu05,lpu15,lpu071,lpu07,",
                 "       lpu06,lpu12,lpu14,lpu08,lpu09,lpu10,lpu16,lpu11",
                 "  FROM lpu_file,lpj_file",
                 " WHERE lpu03 = lpj03",
                 "   AND ",g_wc CLIPPED
     PREPARE t620_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time 
        CALL cl_gre_drop_temptable(l_table)   
        EXIT PROGRAM
     END IF
     DECLARE t620_cs1 CURSOR FOR t620_prepare1

     DISPLAY l_table
     FOREACH t620_cs1 INTO sr.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1) EXIT FOREACH
       END IF

       LET l_rtz13 = ' '
       SELECT rtz13 INTO l_rtz13 FROM rtz_file WHERE rtz01 = sr.lpuplant
       LET l_lph02 = ' '
       SELECT lph02 INTO l_lph02 FROM lph_file WHERE lph01 = sr.lpj02
       LET l_total = 0
       LET l_total = sr.lpu05+sr.lpu04+sr.lpu15
       EXECUTE insert_prep USING sr.*,l_rtz13,l_lph02,l_total
     END FOREACH
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     CALL cl_wcchp(g_wc,'lpu01,lpuplant,lpu03,lpj02,lpu04,lpu05,lpu15,lpu071,lpu07,lpu06,lpu12,lpu14,lpu08,lpu09,lpu10,lpu16,lpu11')
          RETURNING g_wc1
     CALL t620_grdata()
END FUNCTION

FUNCTION t620_grdata()
   DEFINE l_sql    STRING
   DEFINE handler  om.SaxDocumentHandler
   DEFINE sr1      sr1_t
   DEFINE l_cnt    LIKE type_file.num10

   LET l_cnt = cl_gre_rowcnt(l_table)
   IF l_cnt <= 0 THEN 
      RETURN 
   END IF

   
   WHILE TRUE
       CALL cl_gre_init_pageheader()            
       LET handler = cl_gre_outnam("almt620")
       IF handler IS NOT NULL THEN
           START REPORT t620_rep TO XML HANDLER handler
           LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                       " ORDER BY lpu01"
           DECLARE t620_datacur1 CURSOR FROM l_sql
           FOREACH t620_datacur1 INTO sr1.*
               OUTPUT TO REPORT t620_rep(sr1.*)
           END FOREACH
           FINISH REPORT t620_rep
       END IF
       IF INT_FLAG = TRUE THEN
           LET INT_FLAG = FALSE
           EXIT WHILE
       END IF
   END WHILE
   CALL cl_gre_close_report()
END FUNCTION

REPORT t620_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno    LIKE type_file.num5
    DEFINE l_lpu08     STRING
    
    ORDER EXTERNAL BY sr1.lpu01
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name 
            PRINTX g_wc1
              
        BEFORE GROUP OF sr1.lpu01
            LET l_lineno = 0
        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno
            LET l_lpu08 = cl_gr_getmsg("gre-302",g_lang,sr1.lpu08)
            PRINTX sr1.*
            PRINTX l_lpu08

        AFTER GROUP OF sr1.lpu01
        
        ON LAST ROW

END REPORT
#FUN-C90070-------add------end

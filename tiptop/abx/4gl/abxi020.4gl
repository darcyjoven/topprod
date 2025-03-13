# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: abxi020.4gl
# Descriptions...: 放行單管制作業
# Input parameter:
# Date & Author..: 95/07/18 By Star
# Modified.......: 97/03/12 By Elaine
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0003 04/11/03 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4B0062 04/11/25 By Carol 加入"匯率計算"功能
# Modify.........: No.FUN-4C0003 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0080 04/12/16 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-530016 05/03/15 By kim (p_per 中,"匯率"欄位 增加 rate(對應幣別))
# Modify.........: No.MOD-530213 05/03/23 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-530066 05/04/14 By Nicola 新增單據號碼開窗
# Modify.........: No.FUN-530046 05/06/13 By Smapmin abxi020單身新增維護(Q,A,U)欄位 bnc11
# Modify.........: NO.MOD-570402 05/08/01 By Yiting 當資料來源為「1.發料單」時，其工單來源若為未過帳之工單則其工單號碼可帶出，已過帳之工單號碼則無法帶出。
# Modify.........: NO.FUN-590024 05/09/07 By Niocla 錯誤訊息修改
# Modify.........: NO.FUN-590025 05/09/07 By Niocla 已銷案不可修改
# Modify.........: NO.TQC-5A0095 05/10/26 By Niocla 單據性質取位修改
# Modify.........: NO.FUN-5A0196 06/01/11 By Sarah s_bnaauno()已不使用,改CALL s_auto_assign_no()
# Modify.........: No.TQC-630070 06/03/07 By Dido 流程訊息通知功能
# Modify.........: No.TQC-610081 06/04/20 By Pengu Review 所有報表程式接收的外部參數是否完整
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-650145 06/05/25 By Sarah 資料來源為3.進料驗退單/4.雜項發料單時，廠商客戶開窗應該是開廠商而不是開客戶挑選
# Modify.........: No.FUN-660052 05/06/12 By ice cl_err3訊息修改
# Modify.........: No.TQC-660072 06/06/15 By Dido 補充TQC-630070
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0007 06/10/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0046 06/10/18 By jamie 1.FUNCTION i020()_q 一開始應清空g_bnb.*的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0058 06/10/19 By hongmei 將g_no_ask改為mi_no_ask
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-6A0007 06/10/30 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0033 06/11/10 By hellen 新增單頭折疊功能
# Modify.........: No.TQC-690045 06/12/08 By pengu 單身的訂單編號欄位，不應以單頭的為主
# Modify.........: No.TQC-6C0060 07/01/08 By alexstar 多語言功能單純化
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840462 08/04/21 By Carol 修改狀態不可改資料來源條件
# Modify.........: No.FUN-840202 08/05/09 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-920165 09/02/12 By Smapmin 單頭僅存保稅否為N時,單身保稅否要能輸入Y/N的資料
# Modify.........: No.MOD-920192 09/02/13 By Smapmin 抓取出貨單時的條件,多加入無訂單出貨oga09='3'
# Modify.........: No.FUN-980001 09/08/06 By TSD.hoho GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990115 09/10/13 By lilingyu 單頭"件數",單身"單價 臺幣金額"沒有控管負數
# Modify.........: No.FUN-9B0098 10/02/24 By tommas delete cl_doc
# Modify.........: No.FUN-A30059 10/03/17 By rainy 單據性質 1.放行單，改成 F.放行單 
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ABX
# Modify.........: No.TQC-A50023 10/05/06 By 新增單據後按"更改"，修改完單頭資料後，單身資料會不見
# Modify.........: No.FUN-AA0059 10/10/25 By vealxu 全系統料號開窗及判斷控卡原則修改
# Modify.........: No.FUN-AA0059 10/10/26 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No.MOD-AC0048 10/12/07 By sabrina 若不做自動編碼時，會有sub-141的錯誤 
# Modify.........: No.MOD-AC0240 10/12/21 By sabrina N i020_put6()段的pmm_file改為OUTER 
# Modify.........: No.MOD-B20056 11/02/15 By sabrina 在AFTER ROW多判斷"IF l_ac <= g_ohb1.getlength THEN"
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No:MOD-B90139 11/09/20 By johung 修正SQL問題
# Modify.........: No.FUN-910088 11/12/31 By chenjing 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/15 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.FUN-C60004 12/08/31 By pauline 將bxa02加入為PK值 
# Modify.........: No.TQC-D10028 13/01/06 By xuxz bnb09 display
# Modify.........: No.CHI-CB0018 13/01/28 By Elise 行單分批放行,控卡數量
# Modify.........: No.FUN-D30011 13/03/25 By Elise 增加狀態頁籤
# Modify.........: No:FUN-D30034 13/04/17 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
        g_bnb          RECORD LIKE bnb_file.*,   #放行單號
        g_bnb_o        RECORD LIKE bnb_file.*,   #放行單號
        g_bnb_t        RECORD LIKE bnb_file.*,   #放行單號
        g_bnb01        LIKE bnb_file.bnb01,      #放行單號
        g_bnb01_o      LIKE bnb_file.bnb01,      #
        g_bnb01_t      LIKE bnb_file.bnb01,      #
        g_bnb03_t      LIKE bnb_file.bnb03,      #FUN-6A0007
    g_bnc           DYNAMIC ARRAY OF RECORD      #程式變數(Program Variables)
        bnc02       LIKE bnc_file.bnc02,         #項次
        bnc11       LIKE bnc_file.bnc11,         #FUN-530046
        bnc011   LIKE bnc_file.bnc011,     #FUN-6A0007
        bnc012   LIKE bnc_file.bnc012,     #FUN-6A0007
        bnc03       LIKE bnc_file.bnc03,
        bnc04       LIKE bnc_file.bnc04,
        ima021      LIKE ima_file.ima021,        #FUN-6A0007
        ima15       LIKE ima_file.ima15,         #FUN-6A0007
        bnc05       LIKE bnc_file.bnc05,
        bnc06       LIKE bnc_file.bnc06,
        bnc07       LIKE bnc_file.bnc07,
        bnc08       LIKE bnc_file.bnc08,
        bnc09       LIKE bnc_file.bnc09,
        bnc10       LIKE bnc_file.bnc10
        #FUN-840202 --start---
       ,bncud01     LIKE bnc_file.bncud01,
        bncud02     LIKE bnc_file.bncud02,
        bncud03     LIKE bnc_file.bncud03,
        bncud04     LIKE bnc_file.bncud04,
        bncud05     LIKE bnc_file.bncud05,
        bncud06     LIKE bnc_file.bncud06,
        bncud07     LIKE bnc_file.bncud07,
        bncud08     LIKE bnc_file.bncud08,
        bncud09     LIKE bnc_file.bncud09,
        bncud10     LIKE bnc_file.bncud10,
        bncud11     LIKE bnc_file.bncud11,
        bncud12     LIKE bnc_file.bncud12,
        bncud13     LIKE bnc_file.bncud13,
        bncud14     LIKE bnc_file.bncud14,
        bncud15     LIKE bnc_file.bncud15
        #FUN-840202 --end--
                    END RECORD,
    g_bnc_t         RECORD                 #程式變數 (舊值)
        bnc02       LIKE bnc_file.bnc02,   #項次
        bnc11       LIKE bnc_file.bnc11,         #FUN-530046
        bnc011   LIKE bnc_file.bnc011,     #FUN-6A0007
        bnc012   LIKE bnc_file.bnc012,     #FUN-6A0007
        bnc03       LIKE bnc_file.bnc03,
        bnc04       LIKE bnc_file.bnc04,
        ima021      LIKE ima_file.ima021,        #FUN-6A0007
        ima15       LIKE ima_file.ima15,         #FUN-6A0007
        bnc05       LIKE bnc_file.bnc05,
        bnc06       LIKE bnc_file.bnc06,
        bnc07       LIKE bnc_file.bnc07,
        bnc08       LIKE bnc_file.bnc08,
        bnc09       LIKE bnc_file.bnc09,
        bnc10       LIKE bnc_file.bnc10
        #FUN-840202 --start---
       ,bncud01     LIKE bnc_file.bncud01,
        bncud02     LIKE bnc_file.bncud02,
        bncud03     LIKE bnc_file.bncud03,
        bncud04     LIKE bnc_file.bncud04,
        bncud05     LIKE bnc_file.bncud05,
        bncud06     LIKE bnc_file.bncud06,
        bncud07     LIKE bnc_file.bncud07,
        bncud08     LIKE bnc_file.bncud08,
        bncud09     LIKE bnc_file.bncud09,
        bncud10     LIKE bnc_file.bncud10,
        bncud11     LIKE bnc_file.bncud11,
        bncud12     LIKE bnc_file.bncud12,
        bncud13     LIKE bnc_file.bncud13,
        bncud14     LIKE bnc_file.bncud14,
        bncud15     LIKE bnc_file.bncud15
        #FUN-840202 --end--
                    END RECORD,
        g_t1        LIKE bnb_file.bnb01,     #No.TQC-5A0095   #No.FUN-680062   VARCHAR(3)
        g_argv1     LIKE bnb_file.bnb01,     #TQC-630070
        g_argv2     STRING ,                 #TQC-630070      #執行功能   
        g_wc,g_wc2,g_sql    STRING,          #No.FUN-580092 HCN
    #FUN-6A0007  (s)
    g_bnc_o         RECORD                 #程式變數 (舊值)
        bnc02       LIKE bnc_file.bnc02,   #項次
        bnc11       LIKE bnc_file.bnc11,      
        bnc011   LIKE bnc_file.bnc011, 
        bnc012   LIKE bnc_file.bnc012, 
        bnc03       LIKE bnc_file.bnc03,
        bnc04       LIKE bnc_file.bnc04,
        ima021      LIKE ima_file.ima021,   
        ima15       LIKE ima_file.ima15,   
        bnc05       LIKE bnc_file.bnc05,
        bnc06       LIKE bnc_file.bnc06,
        bnc07       LIKE bnc_file.bnc07,
        bnc08       LIKE bnc_file.bnc08,
        bnc09       LIKE bnc_file.bnc09,
        bnc10       LIKE bnc_file.bnc10
        #FUN-840202 --start---
       ,bncud01     LIKE bnc_file.bncud01,
        bncud02     LIKE bnc_file.bncud02,
        bncud03     LIKE bnc_file.bncud03,
        bncud04     LIKE bnc_file.bncud04,
        bncud05     LIKE bnc_file.bncud05,
        bncud06     LIKE bnc_file.bncud06,
        bncud07     LIKE bnc_file.bncud07,
        bncud08     LIKE bnc_file.bncud08,
        bncud09     LIKE bnc_file.bncud09,
        bncud10     LIKE bnc_file.bncud10,
        bncud11     LIKE bnc_file.bncud11,
        bncud12     LIKE bnc_file.bncud12,
        bncud13     LIKE bnc_file.bncud13,
        bncud14     LIKE bnc_file.bncud14,
        bncud15     LIKE bnc_file.bncud15
        #FUN-840202 --end--
                    END RECORD,
    #FUN-6A0007  (e)
 
        g_bna06     LIKE bna_file.bna06,
        g_rec_b     LIKE type_file.num5,      #單身筆數               #NO.FUN-680062 SMALLINT
        l_sfb01     LIKE sfb_file.sfb01,      #工單號碼
        l_ac        LIKE type_file.num5,      #目前處理的ARRAY CNT    #NO.FUN-680062 SMALLINT 
        l_n         LIKE type_file.num5       #目前處理的ARRAY CNT    #NO.FUN-680062 SMALLINT 
#       l_time      LIKE type_file.chr8       #No.FUN-6A0062
 
   DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL 
   DEFINE g_before_input_done  LIKE type_file.num5            #NO.FUN-680062  SMALLINT
   DEFINE g_cnt LIKE type_file.num10                          #NO.FUN-680062   INTEGER
   DEFINE g_i   LIKE type_file.num5     #count/index for any purpose  #NO.FUN-680062 SMALLINT 
   DEFINE g_msg          LIKE type_file.chr1000  #NO.FUN-680062  VARCHAR(72)
   DEFINE g_row_count    LIKE type_file.num10    #No.FUN-680062  INTEGER
   DEFINE g_curs_index   LIKE type_file.num10    #NO.FUN-680062  INTEGER
   DEFINE g_jump         LIKE type_file.num10    #NO.FUN-680062  INTEGER
   DEFINE mi_no_ask      LIKE type_file.num5     #NO.FUN-680062  SMALLINT #No.FUN-6A0058 g_no_ask
   DEFINE g_on_change    LIKE type_file.num5     #NO.FUN-680062  SMALLINT
DEFINE g_str             LIKE type_file.chr1000      #FUN-6A0007
   DEFINE g_bnc05_t      LIKE bnc_file.bnc05     #FUN-910088--add--
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1 = ARG_VAL(1)               #TQC-630070
    LET g_argv2 = ARG_VAL(2)   #執行功能   #TQC-630070
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
 
   LET g_forupd_sql = "SELECT * FROM bnb_file WHERE bnb01 =? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i020_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   OPEN WINDOW i020_w WITH FORM "abx/42f/abxi020"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
   CALL cl_ui_init()
 
   #start TQC-630070
   # 先以g_argv2判斷直接執行哪種功能：
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i020_a()
            END IF
         OTHERWISE          #TQC-660072
            CALL i020_q()   #TQC-660072
      END CASE
   END IF
   #end TQC-630070
 
   CALL i020_menu()
   CLOSE WINDOW i020_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
#QBE 查詢資料
FUNCTION i020_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_bnc.clear()
 
   #TQC-630070
   IF cl_null(g_argv1) THEN
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033
   #FUN-6A0007 (s)
   #CONSTRUCT BY NAME  g_wc ON bnb01,bnb02,bnb03,bnb04,bnb16,bnb05,bnb06,bnb07,
   #                           bnb08,bnb09,bnb11,bnb12,bnb13,bnb14,bnb15
   INITIALIZE g_bnb.* TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME  g_wc ON bnb01,bnb02,bnb03,bnb20,bnb04,bnb16,bnb05,
                              bnb06,bnb07,bnb18,
                              bnb08,bnb09,bnb11,bnb22,bnb12,bnb13,bnb14,bnb15,
                              bnb17,bnb19,bnb90 #FUN-6A0007
                              #FUN-840202   ---start---
                              ,bnbud01,bnbud02,bnbud03,bnbud04,bnbud05,
                              bnbud06,bnbud07,bnbud08,bnbud09,bnbud10,
                              bnbud11,bnbud12,bnbud13,bnbud14,bnbud15
                              #FUN-840202    ----end----
                             #bnb17,bnb19          #FUN-6A0007
                              ,bnbuser,bnbgrup,bnbmodu,bnbdate   #FUN-D30011 add
   #FUN-6A0007 (e)
 
       
                   #No.FUN-580031 --start--     HCN
                   BEFORE CONSTRUCT
                      CALL cl_qbe_init()
                   #No.FUN-580031 --end--       HCN
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(bnb01)
                     # CALL q_bna(TRUE,TRUE,g_t1,'*',g_sys) RETURNING g_qryparam.multiret
                     # DISPLAY g_qryparam.multiret TO bnb01
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form =  "q_bnb"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bnb01
                       NEXT FIELD bnb01
                 WHEN INFIELD(bnb05)
                   #IF g_bnb.bnb03 = '1' OR g_bnb.bnb03='5' THEN   #FUN-650145 mark
                    IF g_bnb.bnb03 MATCHES '[1345]' THEN           #FUN-650145 add
#                      CALL q_pmc1(0,0,g_bnb.bnb05) RETURNING g_bnb.bnb05
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form =  "q_pmc1"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bnb05
                    ELSE
#                      CALL q_occ(5,2,g_bnb.bnb05) RETURNING g_bnb.bnb05
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form = "q_occ"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO bnb05
                    END IF
                    NEXT FIELD bnb05
                 WHEN INFIELD(bnb08)
#                   CALL q_azf(5,2,g_bnb.bnb08,'A') RETURNING g_bnb.bnb08
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_azf"
                    LET g_qryparam.arg1     = 'A'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bnb08
                    NEXT FIELD bnb08
            #FUN-6A0007--------------------------------------(S)
             WHEN INFIELD(bnb90)
                CALL cl_init_qry_var()
                LET g_qryparam.state = "c"
                LET g_qryparam.form = "q_bxa01"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO bnb90
                NEXT FIELD bnb90
            #FUN-6A0007--------------------------------------(E)
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
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
       
       IF INT_FLAG THEN
          RETURN
       END IF
       
   #FUN-6A0007 (s)
   #CONSTRUCT g_wc2 ON bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,bnc08,bnc09,bnc10   #FUN-530046
   #CONSTRUCT g_wc2 ON bnc02,bnc11,bnc03,bnc04,bnc05,bnc06,bnc07,bnc08,bnc09,bnc10   #FUN-530046
                #FROM  s_bnc[1].bnc02,s_bnc[1].bnc03,s_bnc[1].bnc04,   #FUN-530046
   #             FROM  s_bnc[1].bnc02,s_bnc[1].bnc11,s_bnc[1].bnc03,s_bnc[1].bnc04,   #FUN-530046
   #                   s_bnc[1].bnc05,s_bnc[1].bnc06,s_bnc[1].bnc07,
   #                   s_bnc[1].bnc08,s_bnc[1].bnc09,s_bnc[1].bnc10
   CONSTRUCT g_wc2 ON bnc02,bnc011,bnc012,bnc11,bnc03,bnc04,bnc05,
                      bnc06,bnc07,bnc08,bnc09,bnc10   
                      #No.FUN-840202 --start--
                      ,bncud01,bncud02,bncud03,bncud04,bncud05
                      ,bncud06,bncud07,bncud08,bncud09,bncud10
                      ,bncud11,bncud12,bncud13,bncud14,bncud15
                      #No.FUN-840202 ---end---
                FROM  s_bnc[1].bnc02,s_bnc[1].bnc011,s_bnc[1].bnc012,
                      s_bnc[1].bnc11,s_bnc[1].bnc03,s_bnc[1].bnc04,   
                      s_bnc[1].bnc05,s_bnc[1].bnc06,s_bnc[1].bnc07,
                      s_bnc[1].bnc08,s_bnc[1].bnc09,s_bnc[1].bnc10
                     #No.FUN-840202 --start--
                     ,s_bnc[1].bncud01,s_bnc[1].bncud02,s_bnc[1].bncud03
                     ,s_bnc[1].bncud04,s_bnc[1].bncud05,s_bnc[1].bncud06
                     ,s_bnc[1].bncud07,s_bnc[1].bncud08,s_bnc[1].bncud09
                     ,s_bnc[1].bncud10,s_bnc[1].bncud11,s_bnc[1].bncud12
                     ,s_bnc[1].bncud13,s_bnc[1].bncud14,s_bnc[1].bncud15
                     #No.FUN-840202 ---end---
   #FUN-6A0007 (e)
       
            	#No.FUN-580031 --start--     HCN
            	BEFORE CONSTRUCT
            	   CALL cl_qbe_display_condition(lc_qbe_sn)
            	#No.FUN-580031 --end--       HCN
           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(bnc03)
#                   CALL q_ima(0,0,g_bnc[1].bnc03) RETURNING g_bnc[1].bnc03
#FUN-AA0059 --Begin--
                 #   CALL cl_init_qry_var()
                 #   LET g_qryparam.state = "c"
                 #   LET g_qryparam.form = "q_ima"
                 #   CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
                    DISPLAY g_qryparam.multiret TO bnc03
                    NEXT FIELD bnc03
                 WHEN INFIELD(bnc05) #單位檔
#                   CALL q_gfe(10,2,g_bnc[1].bnc05) RETURNING g_bnc[1].bnc05
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bnc05
                    NEXT FIELD bnc05
                 WHEN INFIELD(bnc07) #幣別檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form = "q_azi"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO bnc07
                    NEXT FIELD bnc07
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
                        ON ACTION qbe_save
            	       CALL cl_qbe_save()
            	#No.FUN-580031 --end--       HCN
       END CONSTRUCT
       
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          RETURN
       END IF
 
    ELSE 
       LET g_wc=" bnb01='",g_argv1,"'"
    END IF
   #TQC-630070 end
 
 
   IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
      LET g_sql = "SELECT  bnb01 FROM bnb_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY bnb01"
   ELSE                                       # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE bnb_file. bnb01 ",
                  "  FROM bnb_file, bnc_file",
                  " WHERE bnb01 = bnc01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY bnb01"
   END IF
 
 
   PREPARE i020_prepare FROM g_sql
   DECLARE i020_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i020_prepare
 
   IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM bnb_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT bnb01) FROM bnb_file,bnc_file WHERE ",
                "bnc01=bnb01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE i020_cntpre FROM g_sql
   DECLARE i020_count CURSOR FOR i020_cntpre
END FUNCTION
 
FUNCTION i020_menu()
 
   WHILE TRUE
      CALL i020_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i020_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i020_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i020_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i020_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i020_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "charge_off"
            IF cl_chk_act_auth() THEN
               CALL i020_m()
            END IF
         WHEN "prt_release_order"
            IF cl_chk_act_auth() THEN
               CALL i020_o()
            END IF
         WHEN "prt_sub_declaration"
            IF cl_chk_act_auth() THEN
               CALL i020_s()
            END IF
         WHEN "exporttoexcel" #FUN-4B0003
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_bnc),'','')
            END IF
         #No.FUN-6A0046-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_bnb.bnb01 IS NOT NULL THEN
                 LET g_doc.column1 = "bnb01"
                 LET g_doc.value1 = g_bnb.bnb01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-6A0046-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i020_a()
    DEFINE li_result   LIKE type_file.num5         #NO.FUN-680062  SMALLINT 
  #FUN-6A0007--------------------------------------(S)
   DEFINE   l_sfb01      LIKE sfb_file.sfb01,
            l_sfb1001  LIKE sfb_file.sfb1001,
            l_sfb1002  LIKE sfb_file.sfb1002,
            l_sfb08      LIKE sfb_file.sfb08,
            l_cnt        LIKE type_file.num5
  #FUN-6A0007--------------------------------------(E)
   DEFINE l_sfb05        LIKE sfb_file.sfb05      #FUN-C60004 add
 
   MESSAGE ""
   CLEAR FORM
   CALL g_bnc.clear()
   INITIALIZE g_bnb.* TO NULL
   LET g_bnb.bnb01    = ' '
   LET g_bnb_t.bnb01  = ' '
   LET g_bnb01_t  = ''   #FUN-B50026 add
   LET g_bnb_t.* = g_bnb.*  #FUN-6A0007 
   LET g_bnb_o.* = g_bnb.*  #FUN-6A0007 
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_bnb.bnb02 = g_today
      LET g_bnb.bnb03 = '1'
      LET g_bnb.bnb13 = NULL
      LET g_bnb.bnb19 = 'N'   #FUN-6A0007
 
      LET g_bnb.bnbplant = g_plant   #FUN-980001
      LET g_bnb.bnblegal = g_legal   #FUN-980001

      LET g_bnb.bnbuser = g_user  #FUN-D30011 add
      LET g_bnb.bnbgrup = g_grup  #FUN-D30011 add
 
      #TQC-630070 --start--
      IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
         LET g_bnb.bnb01 = g_argv1
      END IF
      #TQC-630070 ---end---
 
      CALL i020_i("a")                #輸入單頭
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      IF g_bnb.bnb01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
 
     #start FUN-5A0196
     #CALL s_bnaauno(g_bnb.bnb01,g_bnb.bnb02) RETURNING g_i,g_bnb.bnb01
     #IF g_i THEN
     #   CONTINUE WHILE
     #END IF
     #CALL s_auto_assign_no("abx",g_t1,g_bnb.bnb02,"","","","","","") #FUN-6A0007 mark
    #FUN-B50026 mod 即使自動編號，也應可以保存已輸入的流水號
    ##MOD-AC0048---add---start---
    # IF g_bna.bna03 = 'N' THEN
    #    LET g_t1 = g_bnb.bnb01
    # ELSE
    ##MOD-AC0048---add---end---
    #    LET g_t1 = s_get_doc_no(g_bnb.bnb01) #FUN-6A0007
    # END IF      #MOD-AC0048 add
    # #CALL s_auto_assign_no("ABX",g_t1,g_bnb.bnb02,"1","bnb_file","bnb01","","","") #FUN-6A0007 #FUN-A30059
    # CALL s_auto_assign_no("ABX",g_t1,g_bnb.bnb02,"F","bnb_file","bnb01","","","") #FUN-6A0007  #FUN-A30059
      CALL s_auto_assign_no("ABX",g_bnb.bnb01,g_bnb.bnb02,"F","bnb_file","bnb01","","","") #FUN-6A0007  #FUN-A30059
    #FUN-B50026 mod--end
           RETURNING li_result,g_bnb.bnb01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
 
      #進行輸入之單號檢查
      CALL s_mfgchno(g_bnb.bnb01) RETURNING g_i,g_bnb.bnb01
      DISPLAY BY NAME g_bnb.bnb01
      IF NOT g_i THEN CONTINUE WHILE END IF
     #end FUN-5A0196
 
      DISPLAY BY NAME g_bnb.bnb01
      INSERT INTO bnb_file VALUES (g_bnb.*)
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
#        CALL cl_err(g_bnb.bnb01,SQLCA.sqlcode,1)     #No.FUN-660052
         CALL cl_err3("ins","bnb_file",g_bnb.bnb01,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
         ROLLBACK WORK
      END IF
 
     #FUN-6A0007-----------------------------------------------------(S)
      IF g_bnb.bnb03 ='1' AND NOT cl_null(g_bnb.bnb16) THEN
         SELECT sfb01,sfb1001,sfb1002,sfb08,sfb05             #FUN-C60004 add sfb05
           INTO l_sfb01,l_sfb1001,l_sfb1002,l_sfb08,l_sfb05   #FUN-C60004 add sfb05  
           FROM sfb_file
          WHERE sfb01 = g_bnb.bnb16
         IF cl_null(l_sfb1002) THEN LET l_sfb1002 = ' ' END IF
         IF NOT cl_null(l_sfb01) AND l_sfb1002 != 'Y' THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM bxa_file
             WHERE bxa01 = l_sfb1001
               AND bxa02 = l_sfb05     #FUN-C60004 add
             #FUN-6A0007 加有效碼=Y --(S)
               AND bxaacti = 'Y'
             #FUN-6A0007 加有效碼=Y --(E)
            IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
            IF l_cnt > 0 THEN
               UPDATE bxa_file SET bxa09 = bxa09 + l_sfb08
                WHERE bxa01 = l_sfb1001
                  AND bxa02 = l_sfb05     #FUN-C60004 add
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err('update bxa09',SQLCA.SQLCODE,0)
                  ROLLBACK WORK
                  CONTINUE WHILE
               END IF
               UPDATE sfb_file SET sfb1002 = 'Y',
                                   sfb1003 = g_bnb.bnb01
                WHERE sfb01 = l_sfb01
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err('update sfb_file',SQLCA.SQLCODE,0)
                  ROLLBACK WORK
                  CONTINUE WHILE
               END IF
            END IF
         END IF
      END IF
     #FUN-6A0007-----------------------------------------------------(E)
 
      COMMIT WORK
      CALL cl_flow_notify(g_bnb.bnb01,'I')
 
      SELECT bnb01 INTO g_bnb.bnb01 FROM bnb_file WHERE bnb01 = g_bnb.bnb01
      LET g_bnb_t.* = g_bnb.*
      LET g_bnb_o.* = g_bnb.*    #FUN-6A0007
      CALL g_bnc.clear()
 
      #---有輸入單據號碼則自動將單身資料帶出---
      IF NOT cl_null(g_bnb.bnb04) THEN
         CASE WHEN g_bnb.bnb03 = '1'
                   CALL i020_put1()
              WHEN g_bnb.bnb03 = '2'
                   CALL i020_put2()
                   CALL i020_up_ogb1014('2','','') #FUN-6A0007
 
              WHEN g_bnb.bnb03 = '3'
                   CALL i020_put3()
              WHEN g_bnb.bnb03 = '4'
                   CALL i020_put4()
              #FUN-6A0007 (s)
              WHEN g_bnb.bnb03 = '6'   
                   CALL i020_put6()
              #FUN-6A0007 (e)
         END CASE
      END IF
 
      LET g_rec_b = 0                    #No.FUN-680064
      CALL i020_b_fill('1=1')
      CALL i020_b()                      #輸入單身
      SELECT bnb01 INTO g_bnb.bnb01 FROM bnb_file WHERE bnb01 = g_bnb.bnb01
      LET g_bnb01_t = g_bnb.bnb01        #保留舊值
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION i020_u()
   DEFINE   l_cnt   LIKE type_file.num5   #FUN-6A0007
 
   IF s_abxshut(0) THEN
      RETURN
   END IF
 
   IF g_bnb.bnb01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #-----No.FUN-590025-----
   IF NOT cl_null(g_bnb.bnb13) THEN
      CALL cl_err(g_bnb.bnb01,'abx-013',0)
      RETURN
   END IF
   #-----No.FUN-590025 END-----
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_bnb01_t = g_bnb.bnb01
   LET g_bnb_o.* = g_bnb.*
   BEGIN WORK
 
   OPEN i020_cl USING g_bnb.bnb01
   IF STATUS THEN
      CALL cl_err("OPEN i020_cl:", STATUS, 1)
      CLOSE i020_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i020_cl INTO g_bnb.*              # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnb.bnb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE i020_cl
      RETURN
   END IF
 
   CALL i020_show()
   WHILE TRUE
      LET g_bnb01_t = g_bnb.bnb01
      LET g_bnb03_t = g_bnb.bnb03           #FUN-6A0007
      LET g_bnb.bnbmodu = g_user   #FUN-D30011 add
      LET g_bnb.bnbdate = g_today  #FUN-D30011 add
      CALL i020_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_bnb.*=g_bnb_t.*
         CALL i020_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_bnb.bnb01 != g_bnb01_t THEN            # 更改單號
         UPDATE bnc_file SET bnc01 = g_bnb.bnb01
          WHERE bnc01 = g_bnb01_t
         IF SQLCA.sqlcode THEN
#           CALL cl_err('bnc',SQLCA.sqlcode,0)    #No.FUN-660052
            CALL cl_err3("upd","bnc_file",g_bnb01_t,"",SQLCA.sqlcode,"","bnc",1)
            CONTINUE WHILE
         END IF
      END IF
 
    #FUN-6A0007...............begin 依資料來源(bnb03),更改ogb1014
    #    1.bnb03由2,改為其他 -> ogb1014 = N
    #    2.bnb03由其他,改為2 -> ogb1014 = Y
 
     ## 有單身,才需要做判斷
     LET l_cnt = 0 
     SELECT COUNT(*) INTO l_cnt FROM bnc_file
      WHERE bnc01 = g_bnb.bnb01
 
     IF (g_bnb.bnb03 != g_bnb03_t) AND l_cnt > 0 THEN
 
        ## 狀況1 -> ogb1014 = N    
        IF g_bnb03_t = '2' THEN
           CALL i020_up_ogb1014('4','','')
           IF g_success = 'N' THEN
              CALL cl_err('','abx-058',1)
              CONTINUE WHILE
           END IF
        END IF
 
        ## 狀況2 -> ogb1014 = Y
        IF g_bnb.bnb03 = '2' THEN
           CALL i020_up_ogb1014('2','','')
           IF g_success = 'N' THEN
              CALL cl_err('','abx-058',1)
              CONTINUE WHILE
           END IF
        END IF
     END IF   
    #FUN-6A0007...............end
 
      UPDATE bnb_file SET bnb_file.* = g_bnb.*
       WHERE bnb01 = g_bnb01_t
      IF SQLCA.sqlcode THEN
#        CALL cl_err(g_bnb.bnb01,SQLCA.sqlcode,0) #No.FUN-660052
         CALL cl_err3("upd","bnb_file",g_bnb01_t,"",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      END IF
 
      EXIT WHILE
   END WHILE
   CLOSE i020_cl
   COMMIT WORK
   CALL cl_flow_notify(g_bnb.bnb01,'U')
END FUNCTION
 
 
FUNCTION i020_i(p_cmd)
DEFINE
    p_cmd LIKE type_file.chr1,   #No.FUN-680062 VARCHAR(1) 
    l_cmd LIKE type_file.chr1000,#No.FUN-680062 VARCHAR(70) 
    l_n   LIKE type_file.num5,   #No.FUN-680062 SMALLINT
    l_desc     LIKE smy_file.smydesc,
    l_pme01    LIKE pme_file.pme01,
    l_bnc01    LIKE bnc_file.bnc01,
    l_bnc02    LIKE bnc_file.bnc02,           #FUN-6A0007
    l_pmn01    LIKE pmn_file.pmn01,
    l_bnb15    LIKE bnb_file.bnb15,
    l_sfp04    LIKE sfp_file.sfp04,
     l_yy       LIKE type_file.chr1,    #No.FUN-680062 VARCHAR(1)
     l_sql      LIKE type_file.chr3,    #No.FUN-680062 VARCHAR(3) 
     l_str      LIKE type_file.chr1000, #No.FUN-680062 VARCHAR(40) 
     li_result  LIKE type_file.num5     #No.FUN-680062 SMALLINT  
 
    CALL cl_set_head_visible("","YES")  #No.FUN-6B0033 
 
    #FUN-6A0007 (s)
    #INPUT BY NAME g_bnb.bnb01,g_bnb.bnb02,g_bnb.bnb03,g_bnb.bnb04,g_bnb.bnb16,
    #              g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07,g_bnb.bnb08,g_bnb.bnb09,
    #              g_bnb.bnb11,g_bnb.bnb12,g_bnb.bnb14,g_bnb.bnb15
    #              WITHOUT DEFAULTS
    INPUT BY NAME g_bnb.bnb01,g_bnb.bnb02,g_bnb.bnb03,g_bnb.bnb20,
                  g_bnb.bnb04,g_bnb.bnb16,
                  g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07,g_bnb.bnb18,
                  g_bnb.bnb08,g_bnb.bnb09,g_bnb.bnb11,g_bnb.bnb22,
                  g_bnb.bnb12,g_bnb.bnb14,g_bnb.bnb15,
                  g_bnb.bnb17,g_bnb.bnb19
                 ,g_bnb.bnb90                   #FUN-6A0007
                  #FUN-840202     ---start---
                 ,g_bnb.bnbud01,g_bnb.bnbud02,g_bnb.bnbud03,g_bnb.bnbud04,
                  g_bnb.bnbud05,g_bnb.bnbud06,g_bnb.bnbud07,g_bnb.bnbud08,
                  g_bnb.bnbud09,g_bnb.bnbud10,g_bnb.bnbud11,g_bnb.bnbud12,
                  g_bnb.bnbud13,g_bnb.bnbud14,g_bnb.bnbud15 
                  #FUN-840202     ----end----
                 ,g_bnb.bnbuser,g_bnb.bnbgrup,g_bnb.bnbmodu,g_bnb.bnbdate  #FUN-D30011 add
                  WITHOUT DEFAULTS
    #FUN-6A0007 (e)
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL i020_set_entry(p_cmd)
           CALL i020_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
           CALL cl_set_docno_format("bnb01")
 
        AFTER FIELD bnb01
           IF NOT cl_null(g_bnb.bnb01) THEN
 #No.MOD-540182 --start--
              #CALL s_check_no(g_sys,g_bnb.bnb01,g_bnb01_t,"1","bnb_file","bnb01","")
#             CALL s_check_no(g_sys,g_bnb.bnb01,g_bnb01_t,"F","bnb_file","bnb01","")  #FUN-A30059
              CALL s_check_no("abx",g_bnb.bnb01,g_bnb01_t,"F","bnb_file","bnb01","")  #FUN-A30059   #No.FUN-A40041
                 RETURNING li_result,g_bnb.bnb01
              DISPLAY BY NAME g_bnb.bnb01
                IF (NOT li_result) THEN
                     NEXT FIELD bnb01
                 END IF
 
#             LET g_t1 = g_bnb.bnb01[1,3]
#             SELECT bna06 INTO g_bna06 FROM bna_file WHERE bna01=g_t1
#             IF STATUS THEN
#                CALL cl_err('err bnb01 ',STATUS ,1)
#                NEXT FIELD bnb01
#             END IF
#             CALL s_abxslip(g_t1,'1',g_sys)          #檢查單別
#             IF NOT cl_null(g_errno)THEN CALL cl_err(g_t1,g_errno,0)
#               NEXT FIELD bnb01
#             END IF
 #No.MOD-540182 --end--
              LET g_bnb_o.bnb01 = g_bnb.bnb01
           END IF
 
        AFTER FIELD bnb02
           IF NOT cl_null(g_bnb.bnb02) THEN
              IF g_bna06 = '1' THEN
                 CALL i020_date()
              END IF
           END IF
 
 #TQC-990115 --begin--
        AFTER FIELD bnb14
           IF NOT cl_null(g_bnb.bnb14) THEN
              IF g_bnb.bnb14 < 0 THEN
                 CALL cl_err('','aec-020',0)
                 NEXT FIELD bnb14
              END IF 
           END IF 
#TQC-990115 --end--
 
        AFTER FIELD bnb03
           IF NOT cl_null(g_bnb.bnb03) THEN
              #FUN-6A0007 (s)
              #IF g_bnb.bnb03 NOT MATCHES '[1-5]' THEN
              IF g_bnb.bnb03 NOT MATCHES '[1-6]' THEN
              #FUN-6A0007 (e)
                 NEXT FIELD bnb03
              END IF
              IF g_bnb.bnb03 = '2' THEN
                 LET g_bnb.bnb12 = NULL
                 DISPLAY BY NAME g_bnb.bnb12
              END IF
              #FUN-6A0007 (s)
              IF cl_null(g_bnb_o.bnb03) OR 
                 (g_bnb_o.bnb03 != g_bnb.bnb03) THEN
                 IF g_bnb.bnb03 = '4' THEN
                    LET g_bnb.bnb20 = '1' 
                    DISPLAY BY NAME g_bnb.bnb20
           END IF
              END IF             
              #FUN-6A0007 (e)
              #FUN-6A0007--------------------------------------------(S)
              IF g_bnb.bnb03 = '1' AND NOT cl_null(g_bnb.bnb16) THEN
                 CALL i020_bnb90_def()
                 #FUN-6A0007 不檢查--(S)
                 #CALL i020_bnb90()
                 #IF NOT cl_null(g_errno) THEN
                 #   LET g_bnb.bnb90 = ''
                 #   DISPLAY BY NAME g_bnb.bnb90
                 #END IF
                 #FUN-6A0007 不檢查--(E)
              END IF
              #FUN-6A0007--------------------------------------------(E)
              LET g_bnb_o.bnb03 = g_bnb.bnb03
           END IF
  
        #FUN-6A0007 (s)
        AFTER FIELD bnb19
          IF NOT cl_null(g_bnb.bnb19) THEN
             IF g_bnb_o.bnb19 != g_bnb.bnb19 THEN
                IF g_bnb.bnb19 = 'Y' THEN
                   LET l_n = 0
                   SELECT COUNT(*) INTO l_n FROM ima_file,bnc_file
                    WHERE bnc01 = g_bnb.bnb01 
                      AND bnc03 = ima01
                      AND ima15 = 'N'
                   IF l_n > 0 THEN
                      CALL cl_err('','abx-059',0)
                      NEXT FIELD bnb19
                   END IF
                END IF
                #-----MOD-920165---------
                ##FUN-6A0007--(S)
                ##        =N時，須卡單身的資料須為非保稅品
                #IF g_bnb.bnb19 = 'N' THEN
                #   LET l_n = 0
                #   SELECT COUNT(*) INTO l_n FROM ima_file,bnc_file
                #    WHERE bnc01 = g_bnb.bnb01 
                #      AND bnc03 = ima01
                #      AND ima15 = 'Y'
                #   IF l_n > 0 THEN
                #      CALL cl_err('','abx-059',0)
                #      NEXT FIELD bnb19
                #   END IF
                #END IF
                ##FUN-6A0007--(E)
                #-----END MOD-920165-----
             END IF
             LET g_bnb_o.bnb19 = g_bnb.bnb19
          END IF
 
        AFTER FIELD bnb20
          IF NOT cl_null(g_bnb.bnb20) THEN
             IF g_bnb.bnb20 NOT MATCHES '[1-3]' THEN
                NEXT FIELD bnb20
             END IF
          END IF
        #FUN-6A0007 (e)
 
        AFTER FIELD bnb04
           IF NOT cl_null(g_bnb.bnb04) THEN
              #FUN-6A0007 (s)
              # 若修改單頭的單據號碼,要Check單身的
              # 異動單據編號
              IF (cl_null(g_bnb_o.bnb04) OR    #原先null改成非null,要與單身一致
                 (g_bnb.bnb04 <> g_bnb_o.bnb04)) AND p_cmd != 'a' THEN
                 LET l_n = 0
                 DECLARE cur_bnc CURSOR FOR
                 SELECT count(*) INTO l_n
                   FROM bnc_file
                  WHERE bnc01 = g_bnb.bnb01
                    AND (bnc011 <> g_bnb.bnb04 OR bnc011 IS NULL)
                 OPEN cur_bnc
                 FETCH cur_bnc INTO l_n
                 IF l_n > 0 THEN
                    CALL cl_err('sel bnc02','abx-060',1)
                    NEXT FIELD bnb04
                 END IF
              END IF
              #FUN-6A0007 (e)
 
              #IF cl_null(l_n) THEN     #FUN-6A0007  
                 LET l_n = 0
              #END IF                   #FUN-6A0007
              CASE
                 WHEN g_bnb.bnb03 = '1'
                    SELECT COUNT(*) INTO l_n FROM sfp_file
                    #WHERE sfp01 = g_bnb.bnb04 AND sfp04!='X'
                     WHERE sfp01 = g_bnb.bnb04 AND sfpconf!='X' #FUN-660106
                    IF l_n =0 THEN
                       CALL cl_err('','abx-001',0)
                       NEXT FIELD bnb04
                    END IF
 
                    SELECT sfp04 INTO l_sfp04 FROM sfp_file
                     WHERE sfp01 = g_bnb.bnb04
 
                    IF l_sfp04 = 'N' THEN    #未扣帳
                       DECLARE i020_cur_b SCROLL CURSOR FOR
                        SELECT sfs03 INTO g_bnb.bnb16 FROM sfs_file
                         WHERE sfs01 = g_bnb.bnb04
                          #AND sfe27='Y'  #MOD-570402 mark
 
                       OPEN i020_cur_b
 
                       FETCH FIRST i020_cur_b INTO g_bnb.bnb16
                    ELSE
                       DECLARE i020_cur_b1 SCROLL CURSOR FOR
                        SELECT sfe01 INTO g_bnb.bnb16 FROM sfe_file
                         WHERE sfe02 = g_bnb.bnb04 
                          #AND sfe27='Y' #FUN-6A0007 mark
 
                       OPEN i020_cur_b1
 
                       FETCH FIRST i020_cur_b1 INTO g_bnb.bnb16
                    END IF
 
                    IF STATUS OR cl_null(g_bnb.bnb16) THEN
                       LET g_bnb.bnb16 = ' '
                    END IF
 
                    CLOSE i020_cur_b
                    CLOSE i020_cur_b1
 
                    SELECT pmn01 INTO l_pmn01 FROM pmn_file
                     WHERE pmn41 = g_bnb.bnb16 AND pmn16 !='9'
 
                    SELECT pmm09,pmc03,pmc091
                      INTO g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07
                      FROM pmm_file ,OUTER pmc_file
                     WHERE pmm01 = l_pmn01 AND pmc_file.pmc01=pmm_file.pmm09 AND pmm18 !='X'
 
                    DISPLAY BY NAME g_bnb.bnb16,g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07
 
                 WHEN g_bnb.bnb03 = '2'
                    LET g_bnb.bnb16=' '
                    SELECT oga03,oga16 INTO g_bnb.bnb05,g_bnb.bnb16
                      FROM oga_file
                     WHERE oga01 = g_bnb.bnb04
                       #AND oga09='2'   #MOD-920192
                       AND (oga09='2' OR oga09='3')  #MOD-920192
                       AND ogaconf = 'Y'
 
                    IF STATUS THEN
#                       CALL cl_err('1','abx-002',0)     #No.FUN-660052
                        CALL cl_err3("sel","oga_file",g_bnb.bnb04,"","abx-002","","1",1)
                        NEXT FIELD bnb04
                    END IF
 
                    SELECT ocd221,ocd222 INTO g_bnb.bnb06,g_bnb.bnb07
                      FROM oga_file,ocd_file
                     WHERE oga04=ocd01 AND oga044=ocd02
                       AND oga01=g_bnb.bnb04
 
                    DISPLAY BY NAME g_bnb.bnb16,g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07
 
                 #FUN-6A0007 (s)
                 {
                 WHEN g_bnb.bnb03 = '3'
                    SELECT COUNT(*) INTO l_n FROM rva_file
                     WHERE rva01=g_bnb.bnb04 AND rvaconf='Y'
                    IF l_n = 0 THEN
                       CALL cl_err('','abx-003',0)
                       NEXT FIELD bnb04
                    END IF
 
                    SELECT rva05,pmc03,pmc091,rvb34
                      INTO g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07,g_bnb.bnb16
                      FROM rva_file,rvb_file,pmc_file
                     WHERE rva01=g_bnb.bnb04 AND rva01=rvb01
                       AND rva05=pmc01 AND rvaconf='Y'
 
                    DISPLAY BY NAME g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07,g_bnb.bnb16
                 }
                 WHEN g_bnb.bnb03 = '3'
                    SELECT rvu04,rvu05,COUNT(*) INTO g_bnb.bnb05,g_bnb.bnb06,l_n
                      FROM rvu_file
                     WHERE rvu00='2' AND rvu01=g_bnb.bnb04
                       AND rvuconf='Y'
                      GROUP BY rvu04,rvu05
                    IF l_n = 0 THEN
                       CALL cl_err('','abx-061',0)
                       NEXT FIELD bnb04
                    END IF
 
                    SELECT pmc091 INTO g_bnb.bnb07
                      FROM pmc_file
                     WHERE pmc01 = g_bnb.bnb05
                     IF STATUS THEN
                        CALL cl_err('sel pmc',STATUS,1)
                        NEXT FIELD bnb04
                     END IF
 
                    DECLARE cur_rvv CURSOR FOR
                     SELECT rvv18 FROM rvv_file
                      WHERE rvv01 =g_bnb.bnb04
                    OPEN  cur_rvv
                    FETCH cur_rvv INTO g_bnb.bnb16
                    IF STATUS THEN LET g_bnb.bnb16='' END IF
 
                    DISPLAY BY NAME g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07,g_bnb.bnb16
                 #FUN-6A0007 (e)
 
                 WHEN g_bnb.bnb03 = '4'
                    SELECT COUNT(*) INTO l_n FROM inb_file
                     WHERE inb01=g_bnb.bnb04
                    IF l_n = 0 THEN
                       CALL cl_err('','abx-004',0)
                       NEXT FIELD bnb04
                    END IF
        
                 #FUN-6A0007 (s)
                 WHEN g_bnb.bnb03 = '6'
                    SELECT rvu04,rvu05,COUNT(*) INTO g_bnb.bnb05,g_bnb.bnb06,l_n
                      FROM rvu_file
                     WHERE rvu00='3' AND rvu01=g_bnb.bnb04
                       AND rvuconf='Y'
                     GROUP BY rvu04,rvu05
                    IF l_n = 0 THEN
                       CALL cl_err('','abx-061',0)
                       NEXT FIELD bnb04
                    END IF
 
                    SELECT pmc091 INTO g_bnb.bnb07
                      FROM pmc_file
                     WHERE pmc01 = g_bnb.bnb05
                    IF STATUS THEN
                       CALL cl_err('sel pmc',STATUS,1)
                       NEXT FIELD bnb04
                    END IF
 
                    DECLARE cur_rvv2 CURSOR FOR
                     SELECT rvv18
                       FROM rvv_file
                      WHERE rvv01 =g_bnb.bnb04
                    OPEN  cur_rvv2
                    FETCH cur_rvv2 INTO g_bnb.bnb16
                    IF STATUS THEN LET g_bnb.bnb16='' END IF
 
                    DISPLAY BY NAME g_bnb.bnb05,g_bnb.bnb06, g_bnb.bnb07,g_bnb.bnb16
                 #FUN-6A0007 (e)
 
              END CASE
              LET g_bnb_o.bnb04 = g_bnb.bnb04  #FUN-6A0007
           END IF
 
        AFTER FIELD bnb16
           IF NOT cl_null(g_bnb.bnb16) THEN
              CASE
                 WHEN g_bnb.bnb03 = '1'
                    SELECT COUNT(*) INTO l_n FROM sfb_file
                     WHERE sfb01 = g_bnb.bnb16 AND sfb87='Y'
                    IF l_n < 1 THEN
                       CALL cl_err('','abx-005',0)
                       NEXT FIELD bnb03
                    END IF
                   #FUN-6A0007-------------------------------(S)
                    CALL i020_bnb90_def()
                    #FUN-6A0007 不檢查--(S)
                    #CALL i020_bnb90()
                    #IF NOT cl_null(g_errno) THEN
                    #   LET g_bnb.bnb90 = ''
                    #   DISPLAY BY NAME g_bnb.bnb90
                    #END IF
                    #FUN-6A0007 不檢查--(E)
                   #FUN-6A0007-------------------------------(E)
 
                 WHEN g_bnb.bnb03 = '2'
                    SELECT COUNT(*) INTO l_n FROM ogb_file
                     WHERE ogb31 = g_bnb.bnb16
                    IF l_n < 1 THEN
                       CALL cl_err('2','abx-002',0)
                       NEXT FIELD bnb03
                    END IF
              END CASE
           END IF
 
        AFTER FIELD bnb05
           IF NOT cl_null(g_bnb.bnb05) THEN
             #FUN-6A0007(S)--------------
             {
              IF g_bnb.bnb03 <>'2' THEN
                 SELECT pmc03,pmc091 INTO g_bnb.bnb06,g_bnb.bnb07
                   FROM pmc_file
                  WHERE pmc01 = g_bnb.bnb05
                 IF STATUS THEN
#                   CALL cl_err('bnb05 err',STATUS,1)    #No.FUN-660052
                    CALL cl_err3("sel","pmc_file",g_bnb.bnb05,"",STATUS,"","bnb05 err",1)
                    NEXT FIELD bnb05
                 ELSE
                    DISPLAY g_bnb.bnb06 TO bnb06
                    DISPLAY g_bnb.bnb07 TO bnb07
                 END IF
              ELSE
                 SELECT occ02,occ231 INTO g_bnb.bnb06,g_bnb.bnb07
                   FROM occ_file
                  WHERE occ01 = g_bnb.bnb05
              END IF
             }
              IF g_bnb.bnb03 = '1' OR g_bnb.bnb03 = '3' OR g_bnb.bnb03='6' OR
                 (g_bnb.bnb03 MATCHES '[45]' AND g_bnb.bnb20='2') THEN
                  SELECT pmc03,pmc091 INTO g_bnb.bnb06,g_bnb.bnb07
                    FROM pmc_file
                   WHERE pmc01 = g_bnb.bnb05
              END IF
              IF g_bnb.bnb03 = '2' OR
                (g_bnb.bnb03 MATCHES '[45]' AND g_bnb.bnb20='1') THEN
                 SELECT occ02,occ241 INTO g_bnb.bnb06,g_bnb.bnb07
                   FROM occ_file
                  WHERE occ01 = g_bnb.bnb05
              END IF
             #FUN-6A0007(E)--------------
 
                 IF STATUS THEN
#                   CALL cl_err('bnb05 err',STATUS,1)    #No.FUN-660052
                    CALL cl_err3("sel","occ_file",g_bnb.bnb05,"",STATUS,"","bnb05 err",1)
                    NEXT FIELD bnb05
                 ELSE
                    DISPLAY g_bnb.bnb06 TO bnb06
                    DISPLAY g_bnb.bnb07 TO bnb07
                 END IF
 
#No.FUN-660052 --Begin
#             IF STATUS THEN
#                CALL cl_err('bnb05 err',STATUS,1)
#                NEXT FIELD bnb05
#             ELSE
#                DISPLAY g_bnb.bnb06 TO bnb06
#                DISPLAY g_bnb.bnb07 TO bnb07
#             END IF
#No.FUN-660052 --End
           END IF
 
         AFTER FIELD bnb08
            IF NOT cl_null(g_bnb.bnb08) THEN
               SELECT azf03 INTO g_bnb.bnb09 FROM azf_file
                WHERE azf01 = g_bnb.bnb08 AND azf02='A'
               IF STATUS THEN
#                 CALL cl_err('err bnb08' , STATUS ,1)   #No.FUN-660052
                  CALL cl_err3("sel","azf_file",g_bnb.bnb08,"",STATUS,"","err bnb08",1)
                  NEXT FIELD bnb08
               END IF
               DISPLAY BY NAME g_bnb.bnb08
               DISPLAY BY NAME g_bnb.bnb09 #TQC-D10028 add 及時顯示bnb09
            END IF
 
        BEFORE FIELD bnb15
           LET l_n = 0
           IF p_cmd = 'a' AND g_bnb.bnb01[1] = 'B' AND g_bnb.bnb08 = '02' THEN
              SELECT COUNT(*) INTO l_n FROM bnb_file
               WHERE bnb16 = g_bnb.bnb16
 
              IF l_n = 0 THEN
                 LET l_bnb15 = ' '
                 IF YEAR(TODAY) >=2000  THEN
                    LET l_yy = YEAR(TODAY)-2000   USING '&&'
                 ELSE
                    LET l_yy = YEAR(TODAY)-1900   USING '&&'
                 END IF
 
                 LET l_sql = l_yy,'*'
                 SELECT bnb01 FROM bnb_file WHERE bnb15 MATCHES l_sql
                 IF SQLCA.sqlcode = 100 THEN
                    LET l_bnb15[1,2] = l_yy
                    LET l_bnb15[3,7] = '00000'
                 ELSE
                    SELECT MAX(bnb15) INTO l_bnb15 FROM bnb_file
                     WHERE bnb15 MATCHES l_sql
                 END IF
 
                 LET g_bnb.bnb15 = l_bnb15[1,2],(l_bnb15[3,7]+1) USING '&&&&&'
              ELSE
                 LET g_bnb.bnb15 = ' '
              END IF
              DISPLAY BY NAME g_bnb.bnb15
           END IF
 
       #FUN-6A0007----------------------------------------------------(S)
        AFTER FIELD bnb90
           IF NOT cl_null(g_bnb.bnb90) THEN
              CALL i020_bnb90()
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_bnb.bnb90,g_errno,0)
                 LET g_bnb.bnb90 = g_bnb_t.bnb90
                 DISPLAY BY NAME g_bnb.bnb90
                 NEXT FIELD bnb90
              END IF
           END IF
       #FUN-6A0007----------------------------------------------------(E)
 
 
        #FUN-840202     ---start---
        AFTER FIELD bnbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bnbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #FUN-840202     ----end----
 
       #FUN-6A0007 (s)
        AFTER INPUT 
           IF INT_FLAG THEN
              RETURN
           END IF 
           IF NOT cl_null(g_bnb.bnb04) THEN
              LET l_n = 0
            
              CASE 
               WHEN g_bnb.bnb03 = '1'
                    SELECT COUNT(*) INTO l_n FROM sfp_file
                    #WHERE sfp01 = g_bnb.bnb04 AND sfp04!='X'      #CHI-CB0018 mark 
                     WHERE sfp01 = g_bnb.bnb04 AND sfpconf!='X'    #CHI-CB0018
               WHEN g_bnb.bnb03 = '2'
                    SELECT COUNT(*) INTO l_n FROM oga_file
                     WHERE oga01 = g_bnb.bnb04
                       #AND oga09='2'   #MOD-920192
                       AND (oga09='2' OR oga09='3')   #MOD-920192
                       AND ogaconf = 'Y'
               WHEN g_bnb.bnb03 = '3'
                    SELECT COUNT(*) INTO l_n FROM rvu_file
                     WHERE rvu01 = g_bnb.bnb04
                       AND rvu00 = '2'
                       AND rvuconf = 'Y'
               WHEN g_bnb.bnb03 = '4'
                    SELECT COUNT(*) INTO l_n FROM inb_file
                     WHERE inb01=g_bnb.bnb04
               WHEN g_bnb.bnb03 = '5'
                    LET l_n = 1
               WHEN g_bnb.bnb03 = '6'
                    SELECT COUNT(*) INTO l_n FROM rvu_file
                     WHERE rvu01 = g_bnb.bnb04
                       AND rvu00 = '3'
                       AND rvuconf = 'Y'
              END CASE 
              IF l_n = 0 THEN
                 CALL cl_err('','abx-062',0)
                 NEXT FIELD bnb03
              END IF
            END IF
       #FUN-6A0007 (e)
 
       ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bnb01)
               # LET g_t1=g_bnb.bnb01[1,3]
                 LET g_t1=s_get_doc_no(g_bnb.bnb01)   #No.TQC-5A0095
               #FUN-6A0007(S)--只能選放行單的單別---
                 #CALL q_bna(FALSE,TRUE,g_t1,'*',g_sys) RETURNING g_t1  #TQC-670008
                 #CALL q_bna(FALSE,TRUE,g_t1,'1','ABX') RETURNING g_t1   #TQC-670008 #FUN-6A0007  #FUN-A30059
                 CALL q_bna(FALSE,TRUE,g_t1,'F','ABX') RETURNING g_t1   #FUN-A30059
                 IF INT_FLAG THEN
                    LET INT_FLAG = 0
                 END IF
               #FUN-6A0007(E)--只能選放行單的單別---
#                 CALL FGL_DIALOG_SETBUFFER( g_t1 )
               # LET g_bnb.bnb01[1,3]=g_t1
                 LET g_bnb.bnb01=g_t1      #No.TQC-5A0095
                 DISPLAY BY NAME g_bnb.bnb01
                 NEXT FIELD bnb01
              WHEN INFIELD(bnb05)
                 #FUN-6A0007 (s)
                 {
                #IF g_bnb.bnb03 = '1' OR g_bnb.bnb03='5' THEN   #FUN-650145 mark
                 IF g_bnb.bnb03 MATCHES '[1345]' THEN           #FUN-650145 add
#                   CALL q_pmc1(0,0,g_bnb.bnb05) RETURNING g_bnb.bnb05
#                   CALL FGL_DIALOG_SETBUFFER( g_bnb.bnb05 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form =  "q_pmc1"
                    LET g_qryparam.default1 = g_bnb.bnb05
                    CALL cl_create_qry() RETURNING g_bnb.bnb05
#                    CALL FGL_DIALOG_SETBUFFER( g_bnb.bnb05 )
                 ELSE
#                   CALL q_occ(5,2,g_bnb.bnb05) RETURNING g_bnb.bnb05
#                   CALL FGL_DIALOG_SETBUFFER( g_bnb.bnb05 )
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.default1 = g_bnb.bnb05
                    CALL cl_create_qry() RETURNING g_bnb.bnb05
#                   CALL FGL_DIALOG_SETBUFFER( g_bnb.bnb05 )
                 END IF
                 }
                 IF g_bnb.bnb03 = '1' OR g_bnb.bnb03 = '3' OR g_bnb.bnb03='6' OR
                    (g_bnb.bnb03 MATCHES '[45]' AND g_bnb.bnb20='2') THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form =  "q_pmc1"
                    LET g_qryparam.default1 = g_bnb.bnb05
                    CALL cl_create_qry() RETURNING g_bnb.bnb05
                 END IF
                 IF g_bnb.bnb03 = '2' OR
                    (g_bnb.bnb03 MATCHES '[45]' AND g_bnb.bnb20='1') THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.default1 = g_bnb.bnb05
                    CALL cl_create_qry() RETURNING g_bnb.bnb05
                 END IF
                 #FUN-6A0007 (e)
                 DISPLAY BY NAME g_bnb.bnb05
                 NEXT FIELD bnb05
              WHEN INFIELD(bnb08)
#                CALL q_azf(5,2,g_bnb.bnb08,'A') RETURNING g_bnb.bnb08
#                CALL FGL_DIALOG_SETBUFFER( g_bnb.bnb08 )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azf"
                 LET g_qryparam.default1 = g_bnb.bnb08
                 LET g_qryparam.arg1     = 'A'
                 CALL cl_create_qry() RETURNING g_bnb.bnb08
#                 CALL FGL_DIALOG_SETBUFFER( g_bnb.bnb08 )
                 DISPLAY BY NAME g_bnb.bnb08
                #TQC-D10028--add--str及時顯示bnb09
                 SELECT azf03 INTO g_bnb.bnb09 FROM azf_file
                  WHERE azf01 = g_bnb.bnb08 AND azf02='A'
                 DISPLAY g_bnb.bnb09 TO bnb09
                #TQC-D10028--add--end
                 NEXT FIELD bnb08
              #-----No.FUN-530066-----
              WHEN INFIELD(bnb04)
                 CASE g_bnb.bnb03
                    WHEN "1"
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_sfp2"
                       LET g_qryparam.default1 = g_bnb.bnb04
                       LET g_qryparam.where =" sfpconf !='X' "  #FUN-660106
                       CALL cl_create_qry() RETURNING g_bnb.bnb04
                       DISPLAY BY NAME g_bnb.bnb04
                       NEXT FIELD bnb04
                    WHEN "2"
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_oga"
                       LET g_qryparam.default1 = g_bnb.bnb04
                       #LET g_qryparam.where =" oga09 = '2' "   #MOD-920192
                       LET g_qryparam.where =" (oga09 = '2' OR oga09 = '3') "   #MOD-920192
                       CALL cl_create_qry() RETURNING g_bnb.bnb04
                       DISPLAY BY NAME g_bnb.bnb04
                       NEXT FIELD bnb04
                    WHEN "3"
                       CALL cl_init_qry_var()
                       #LET g_qryparam.form = "q_rvall"  #FUN-6A0007
                       LET g_qryparam.form = "q_rvu4"  #FUN-6A0007
                       LET g_qryparam.arg1 = '2'         #FUN-6A0007
                       LET g_qryparam.default1 = g_bnb.bnb04
                       CALL cl_create_qry() RETURNING g_bnb.bnb04
                       DISPLAY BY NAME g_bnb.bnb04
                       NEXT FIELD bnb04
                    WHEN "4"
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_inb2"
                       LET g_qryparam.default1 = g_bnb.bnb04
                       CALL cl_create_qry() RETURNING g_bnb.bnb04
                       DISPLAY BY NAME g_bnb.bnb04
                       NEXT FIELD bnb04
                    #FUN-6A0007 (s)
                    WHEN "6"
                       CALL cl_init_qry_var()
                       LET g_qryparam.form = "q_rvu4"  
                       LET g_qryparam.arg1 = '3'       
                       LET g_qryparam.default1 = g_bnb.bnb04
                       CALL cl_create_qry() RETURNING g_bnb.bnb04
                       DISPLAY BY NAME g_bnb.bnb04
                       NEXT FIELD bnb04
                    #FUN-6A0007 (e)
                 END CASE
              #-----No.FUN-530066 END-----
             #FUN-6A0007---------------------------------------(S)
              WHEN INFIELD(bnb90)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_bxa01"
                 LET g_qryparam.default1 = g_bnb.bnb90
                 CALL cl_create_qry() RETURNING g_bnb.bnb90
                 DISPLAY BY NAME g_bnb.bnb90
                 NEXT FIELD bnb90
             #FUN-6A0007---------------------------------------(E)
           END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       #MOD-650015 --start
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #    IF INFIELD(bnb01) THEN
       #       LET g_bnb.* = g_bnb_t.*
       #       DISPLAY BY NAME g_bnb.*
       #       NEXT FIELD bnb01
       #    END IF
       #MOD-650015 --end
 
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
 
END FUNCTION
 
#FUN-6A0007----------------------------------------------------------(S)
#default核准文號
FUNCTION i020_bnb90_def()
   SELECT sfb1001 INTO g_bnb.bnb90 FROM sfb_file
    WHERE sfb01 = g_bnb.bnb16
   DISPLAY BY NAME g_bnb.bnb90
END FUNCTION
 
#判斷核准文號
FUNCTION i020_bnb90()
   DEFINE
    l_sfb08    LIKE sfb_file.sfb08,
    l_sfb81    LIKE sfb_file.sfb81,
    l_bxa06 LIKE bxa_file.bxa06,
    l_bxa07 LIKE bxa_file.bxa07,
    l_bxa08 LIKE bxa_file.bxa08,
    l_bxa09 LIKE bxa_file.bxa09
DEFINE l_sfb05 LIKE sfb_file.sfb05      #FUN-C60004 add
 
   LET g_errno = ''
   LET l_bxa08 = 0
   LET l_bxa09 = 0
   SELECT bxa06,bxa07,bxa08,bxa09
    INTO l_bxa06,l_bxa07,l_bxa08,l_bxa09
    FROM bxa_file
   WHERE bxa01 = g_bnb.bnb90
     AND bxaacti = 'Y'
   IF SQLCA.SQLCODE THEN
      LET g_errno = 'abx-051'
   ELSE
      IF g_bnb.bnb03 = '1' THEN
         IF l_bxa08 IS NULL THEN LET l_bxa08 = 0 END IF
         IF l_bxa09 IS NULL THEN LET l_bxa09 = 0 END IF
         SELECT sfb08,sfb81,sfb05     #FUN-C60004 add sfb05
           INTO l_sfb08,l_sfb81,l_sfb05   #FUN-C60004 sfb05
           FROM sfb_file
          WHERE g_bnb.bnb16 = sfb01
        #FUN-C60004 add START
        #將bxa02加入pk值,所以在判斷核准數量時必須要加入where條件
         LET l_bxa08 = 0
         LET l_bxa09 = 0
         SELECT bxa08,bxa09
          INTO l_bxa08,l_bxa09
          FROM bxa_file
         WHERE bxa01 = g_bnb.bnb90
           AND bxa02 = l_sfb05
           AND bxaacti = 'Y'
         IF l_bxa08 IS NULL THEN LET l_bxa08 = 0 END IF
         IF l_bxa09 IS NULL THEN LET l_bxa09 = 0 END IF
        #FUN-C60004 add END
         IF l_sfb08 > (l_bxa08 - l_bxa09) OR 
           (l_sfb81 < l_bxa06 OR l_sfb81 > l_bxa07) THEN
            LET g_errno = 'abx-052'
         END IF
      END IF
   END IF
END FUNCTION
#FUN-6A0007----------------------------------------------------------(E)
 
FUNCTION i020_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_bnb.* TO NULL               #No.FUN-6A0046
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i020_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_bnb.* TO NULL
      RETURN
   END IF
 
   MESSAGE " SEARCHING ! "
 
   OPEN i020_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_bnb.* TO NULL
   ELSE
      OPEN i020_count
      FETCH i020_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL i020_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
   MESSAGE ""
 
END FUNCTION
 
FUNCTION i020_fetch(p_flag)
DEFINE
    p_flag  LIKE type_file.chr1,           #處理方式    #NO.FUN-680062   VARCHAR(1)
    l_abso  LIKE type_file.num10           #絕對的筆數  #No.FUN-680062   INTEGER   
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i020_cs INTO g_bnb.bnb01
      WHEN 'P' FETCH PREVIOUS i020_cs INTO g_bnb.bnb01
      WHEN 'F' FETCH FIRST    i020_cs INTO g_bnb.bnb01
      WHEN 'L' FETCH LAST     i020_cs INTO g_bnb.bnb01
      WHEN '/'
         IF (NOT mi_no_ask) THEN                #No.FUN-6A0058 g_no_ask
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
#                  CONTINUE PROMPT
 
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
         FETCH ABSOLUTE g_jump i020_cs INTO g_bnb.bnb01
         LET mi_no_ask = FALSE         #No.FUN-6A0058 g_no_ask
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnb.bnb01,SQLCA.sqlcode,0)
      INITIALIZE g_bnb.* TO NULL  #TQC-6B0105
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
 
   SELECT * INTO g_bnb.* FROM bnb_file WHERE bnb01 = g_bnb.bnb01
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_bnb.bnb01,SQLCA.sqlcode,0)   #No.FUN-660052
      CALL cl_err3("sel","bnb_file",g_bnb.bnb01,"",SQLCA.sqlcode,"","",1)
      INITIALIZE g_bnb.* TO NULL
      RETURN
   END IF
 
   CALL i020_show()
 
END FUNCTION
 
FUNCTION i020_show()
 
   LET g_bnb_t.* = g_bnb.*                #保存單頭舊值
   LET g_bnb_o.* = g_bnb.*                #保存單頭舊值 #FUN-6A0007
   DISPLAY BY NAME g_bnb.bnb01,g_bnb.bnb02,g_bnb.bnb03,g_bnb.bnb04,g_bnb.bnb16,
                   g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07,g_bnb.bnb08,g_bnb.bnb09,
                   g_bnb.bnb11,g_bnb.bnb12,g_bnb.bnb13,g_bnb.bnb14,g_bnb.bnb15
                   #FUN-840202     ---start---
                   ,g_bnb.bnbud01,g_bnb.bnbud02,g_bnb.bnbud03,g_bnb.bnbud04,
                   g_bnb.bnbud05,g_bnb.bnbud06,g_bnb.bnbud07,g_bnb.bnbud08,
                   g_bnb.bnbud09,g_bnb.bnbud10,g_bnb.bnbud11,g_bnb.bnbud12,
                   g_bnb.bnbud13,g_bnb.bnbud14,g_bnb.bnbud15 
                   #FUN-840202     ----end----
                   ,g_bnb.bnbuser,g_bnb.bnbgrup,g_bnb.bnbmodu,g_bnb.bnbdate  #FUN-D30011 add
   #FUN-6A0007 (s)
   DISPLAY BY NAME g_bnb.bnb17,g_bnb.bnb18,g_bnb.bnb19,
                   g_bnb.bnb20,g_bnb.bnb22
   #FUN-6A0007 (e)
   DISPLAY BY NAME g_bnb.bnb90   #FUN-6A0007
  #LET g_t1 = g_bnb.bnb01[1,3]
   LET g_t1=s_get_doc_no(g_bnb.bnb01)   #No.TQC-5A0095
   SELECT bna06 INTO g_bna06 FROM bna_file WHERE bna01=g_t1
   CALL i020_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION i020_r()
     DEFINE l_chr  LIKE type_file.chr1       #NO.FUN-680062  VARCHAR(1) 
     DEFINE l_sure LIKE type_file.chr1       #NO.FUN-680062  VARCHAR(1) 
   #FUN-6A0007--------------------------------------(S)
    DEFINE l_sfb01       LIKE sfb_file.sfb01,
           l_sfb08       LIKE sfb_file.sfb08,
           l_sfb1001   LIKE sfb_file.sfb1001,
           l_sfb1002   LIKE sfb_file.sfb1002,
           l_sfb1003   LIKE sfb_file.sfb1003,
           l_cnt         LIKE type_file.num5,
           l_flag        LIKE type_file.chr1
   #FUN-6A0007--------------------------------------(E)
 
 
    IF s_abxshut(0) THEN
       RETURN
    END IF
 
    IF g_bnb.bnb01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    BEGIN WORK
    OPEN i020_cl USING g_bnb.bnb01
    IF STATUS THEN
       CALL cl_err("OPEN i020_cl:", STATUS, 1)
       CLOSE i020_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i020_cl INTO g_bnb.*
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_bnb.bnb01,SQLCA.sqlcode,0)
      RETURN
    END IF
 
    CALL i020_show()
    LET l_flag = 'Y'   #FUN-6A0007
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "bnb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_bnb.bnb01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
 
      #FUN-6A0007 (s)
       LET l_cnt = 0 
       SELECT COUNT(*) INTO l_cnt FROM bnc_file
        WHERE bnc01 = g_bnb.bnb01
 
       IF g_bnb.bnb03 = '2' AND l_cnt > 0 THEN 
           CALL i020_up_ogb1014('4','','')
           IF g_success = 'N' THEN
              CALL cl_err('','abx-058',1)
              LET l_flag = 'N'
           END IF
       END IF
      #FUN-6A0007 (e)
 
       DELETE FROM bnc_file WHERE bnc01 = g_bnb.bnb01
       DELETE FROM bnb_file WHERE bnb01 = g_bnb.bnb01
       IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_bnb.bnb01,SQLCA.sqlcode,0)  #No.FUN-660052
          CALL cl_err3("del","bnb_file",g_bnb.bnb01,"",SQLCA.sqlcode,"","",1)
       ELSE
         #FUN-6A0007-------------------------------------------------(S)
          IF g_bnb.bnb03 ='1' AND NOT cl_null(g_bnb.bnb16) THEN
             SELECT sfb01,sfb08,sfb1001,sfb1002,sfb1003
               INTO l_sfb01,l_sfb08,l_sfb1001,l_sfb1002,l_sfb1003
               FROM sfb_file
              WHERE sfb1003 = g_bnb.bnb01
             IF NOT cl_null(l_sfb1003) AND l_sfb1002 = 'Y' THEN
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM bxa_file
                 WHERE bxa01 = l_sfb1001
                   #FUN-6A0007 加有效碼=Y --(S)
                   AND bxaacti = 'Y'
                   #FUN-6A0007 加有效碼=Y --(E)
                IF l_cnt IS NULL THEN LET l_cnt = 0 END IF
                IF l_cnt > 0 THEN
                   UPDATE bxa_file SET bxa09 = bxa09 - l_sfb08
                    WHERE bxa01 = l_sfb1001
                   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err('update bxa09(r)',SQLCA.SQLCODE,0)
                      LET l_flag = 'N'
                   END IF
                   UPDATE sfb_file SET sfb1002 = 'N',
                                       sfb1003 = ' '
                    WHERE sfb01 = l_sfb01
                   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                      CALL cl_err('update sfb_file(r)',SQLCA.SQLCODE,0)
                      LET l_flag = 'N'
                   END IF
                END IF
             END IF
          END IF
         #FUN-6A0007-------------------------------------------------(E)
 
         IF l_flag = 'Y' THEN   #FUN-6A0007
          CLEAR FORM
          CALL g_bnc.clear()
          INITIALIZE g_bnb.* LIKE bnb_file.*             #DEFAULT 設定
          OPEN i020_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i020_cs
             CLOSE i020_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i020_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i020_cs
             CLOSE i020_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i020_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i020_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE           #No.FUN-6A0058 g_no_ask
             CALL i020_fetch('/')
          END IF
       END IF
       END IF  #FUN-6A0007
    END IF
    CLOSE i020_cl
   #FUN-6A0007-----------------(S)
   #COMMIT WORK
    IF l_flag = 'Y' THEN
    COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
   #FUN-6A0007-----------------(E)
    CALL cl_flow_notify(g_bnb.bnb01,'D')
 
END FUNCTION
 
FUNCTION i020_b()
DEFINE
   l_ac_t LIKE type_file.num5,            #未取消的ARRAY CNT  #NO.FUN-680062   SMALLINT 
   l_n    LIKE type_file.num5,            #檢查重複用         #NO.FUN-680062    SMALLINT
   l_lock_sw LIKE type_file.chr1,         #單身鎖住否         #NO.FUN-680062    VARCHAR(1)
   p_cmd  LIKE  type_file.chr1,           #處理狀態           #NO.FUN-680062    VARCHAR(1)
   l_cmd  LIKE  type_file.chr1000,                            #NO.FUN-680062    VARCHAR(70)  
   #FUN-6A0007 (s)
   l_rvu03         LIKE rvu_file.rvu03,  #異動入期(入庫)
   l_sfp04         LIKE sfp_file.sfp04,  #
   #FUN-6A0007 (e)
 
   l_ima08         LIKE ima_file.ima08,
   l_ima55         LIKE ima_file.ima55,
   l_acti          LIKE sfb_file.sfbacti,
   l_allow_insert  LIKE type_file.num5,    #可新增否           #NO.FUN-680062   SMALLINT 
   l_allow_delete  LIKE type_file.num5,    #可刪除否           #NO.FUN-680062   SMALLINT    
   l_cnt           LIKE type_file.num5,    #FUN-6A0007         #CHI-CB0018 add ,
   l_bnc06         LIKE bnc_file.bnc06,    #CHI-CB0018 add---S
   l_sfe28         LIKE sfe_file.sfe28,
   l_sfe01         LIKE sfe_file.sfe01,
   l_sfe07         LIKE sfe_file.sfe07,
   l_sfe16         LIKE sfe_file.sfe16,
   l_sfe17         LIKE sfe_file.sfe17,
   l_bnc06_qty     LIKE bnc_file.bnc06,
   l_bnc11_chk     LIKE bnc_file.bnc11,
   l_flag          LIKE type_file.chr1     #CHI-CB0018 add---E

#  IF g_bnb.bnb01 IS NULL THEN
#     CALL cl_err('',-400,0)
#     RETURN
#  END IF
 
   IF s_abxshut(0) THEN
      RETURN
   END IF
 
   #--> #FUN-6A0007 (s) 出貨單產生Action,資料來源=2.出貨單,才有
    IF g_bnb.bnb03 = '2' THEN  
       CALL cl_set_act_visible("get_produce",TRUE)
    ELSE
       CALL cl_set_act_visible("get_produce",FALSE)
    END IF
   #--- #FUN-6A0007 (e)
 
   LET g_action_choice = ""
   CALL cl_opmsg('b')
 
   #-----No.FUN-590025-----
   IF NOT cl_null(g_bnb.bnb13) THEN
      CALL cl_err(g_bnb.bnb01,'abx-013',0)
      RETURN
   END IF
   #-----No.FUN-590025 END-----
 
   #LET g_forupd_sql = "SELECT bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,bnc08,",   #FUN-530046
   #FUN-6A0007 (s)
   LET g_forupd_sql = "SELECT bnc02,bnc11,bnc011,bnc012,bnc03,bnc04, ",
                      "       '','',bnc05,bnc06,bnc07,bnc08,",   #FUN-530046
   #FUN-6A0007 (e)
                      "       bnc09,bnc10,",
                      #FUN-840202 --start--
                      "bncud01,bncud02,bncud03,bncud04,bncud05,",
                      "bncud06,bncud07,bncud08,bncud09,bncud10,",
                      "bncud11,bncud12,bncud13,bncud14,bncud15",
                      #FUN-840202 --end--
                      " FROM bnc_file",
                      " WHERE bnc01= ? AND bnc02 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i020_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   CALL i020_set_entry(p_cmd)      #CHI-CB0018 add
   CALL i020_set_no_entry(p_cmd)   #CHI-CB0018 add

   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_bnc WITHOUT DEFAULTS FROM s_bnc.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
       BEFORE INPUT
            IF g_rec_b != 0 THEN
                CALL fgl_set_arr_curr(l_ac)
            END IF
 
       BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          LET g_on_change = TRUE         #FUN-550077
          BEGIN WORK
 
          OPEN i020_cl USING g_bnb.bnb01
          IF STATUS THEN
             CALL cl_err("OPEN i020_cl:", STATUS, 1)
             CLOSE i020_cl
             ROLLBACK WORK
             RETURN
          END IF
 
          FETCH i020_cl INTO g_bnb.*              # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_bnb.bnb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE i020_cl
             RETURN
         #ELSE  #TQC-6C0060 mark
         #   IF g_aza.aza44 = "Y" THEN    #FUN-550077
         #      IF NOT cl_null(g_bnc[l_ac].bnc04) THEN
         #         CALL cl_itemname_modsys("bnc_file","bnc04",g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04) RETURNING g_i
         #      END IF
         #      CALL cl_itemname_by_lang("bnc_file","bnc04",g_bnc[l_ac].bnc03,g_lang,g_bnc[l_ac].bnc04) RETURNING g_bnc[l_ac].bnc04
         #   END IF
          END IF
 
          IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_bnc_t.* = g_bnc[l_ac].*  #BACKUP
              LET g_bnc05_t = g_bnc[l_ac].bnc05     #FUN-910088--add--
              OPEN i020_bcl USING g_bnb.bnb01,g_bnc_t.bnc02
              IF STATUS THEN
                 CALL cl_err("OPEN i020_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
 
              FETCH i020_bcl INTO g_bnc[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_bnc_t.bnc03,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              ELSE
                 #FUN-6A0007(s)
                 SELECT ima021,ima15 INTO g_bnc[l_ac].ima021,g_bnc[l_ac].ima15
                   FROM ima_file
                  WHERE ima01 = g_bnc[l_ac].bnc03
                  IF STATUS THEN
                     LET g_bnc[l_ac].ima021=''
                     LET g_bnc[l_ac].ima15 =''
                  END IF
                  LET g_bnc_o.*=g_bnc[l_ac].*
                  #FUN-6A0007 (e)
                  LET g_bnc_t.*=g_bnc[l_ac].*
              END IF
              #CALL cl_show_rate_comment()   #FUN-530016
              CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
#         NEXT FIELD bnc02
 
       BEFORE INSERT
          LET l_n = ARR_COUNT()
          LET p_cmd='a'
          INITIALIZE g_bnc[l_ac].* TO NULL      #900423
          LET g_bnc[l_ac].bnc011 = g_bnb.bnb04 #FUN-6A0007
          LET g_bnc_t.* = g_bnc[l_ac].*         #新輸入資料
          LET g_bnc_o.* = g_bnc[l_ac].*         #新輸入資料 #FUN-6A0007
          LET g_bnc05_t = NULL                  #FUN-910088--add--
          CALL cl_show_fld_cont()     #FUN-550037(smin)
          NEXT FIELD bnc02
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
          #IF g_aza.aza44 = "Y" THEN #FUN-550077  #TQC-6C0060 mark
          #   CALL cl_itemname_switch(1,"bnc_file","bnc04",g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04) RETURNING g_bnc[l_ac].bnc04
          #END IF
           #FUN-6A0007 (s)
           # add bnc011,bnc012
           INSERT INTO bnc_file(bnc01,bnc02,bnc03,bnc04,bnc05,
                                #bnc06,bnc07,bnc08,bnc09,bnc10)   #FUN-530046
                                bnc06,bnc07,bnc08,bnc09,bnc10,bnc11,
                                bnc011,bnc012   #FUN-530046
                                  #FUN-840202 --start--
                                 ,bncud01,bncud02,bncud03,
                                  bncud04,bncud05,bncud06,
                                  bncud07,bncud08,bncud09,
                                  bncud10,bncud11,bncud12,
                                  bncud13,bncud14,bncud15,
                                  bncplant,bnclegal)   #FUN-980001
                                  #FUN-840202 --end--
                VALUES(g_bnb.bnb01,g_bnc[l_ac].bnc02,g_bnc[l_ac].bnc03,
                       g_bnc[l_ac].bnc04,g_bnc[l_ac].bnc05,g_bnc[l_ac].bnc06,
                       g_bnc[l_ac].bnc07,g_bnc[l_ac].bnc08,g_bnc[l_ac].bnc09,
                       #g_bnc[l_ac].bnc10)   #FUN-530046
                       g_bnc[l_ac].bnc10,g_bnc[l_ac].bnc11,
                       g_bnc[l_ac].bnc011,g_bnc[l_ac].bnc012   #FUN-530046
                       #FUN-840202 --start--
                      ,g_bnc[l_ac].bncud01, g_bnc[l_ac].bncud02,
                       g_bnc[l_ac].bncud03, g_bnc[l_ac].bncud04,
                       g_bnc[l_ac].bncud05, g_bnc[l_ac].bncud06,
                       g_bnc[l_ac].bncud07, g_bnc[l_ac].bncud08,
                       g_bnc[l_ac].bncud09, g_bnc[l_ac].bncud10,
                       g_bnc[l_ac].bncud11, g_bnc[l_ac].bncud12,
                       g_bnc[l_ac].bncud13, g_bnc[l_ac].bncud14,
                       g_bnc[l_ac].bncud15,
                       g_plant,g_legal)   #FUN-980001
                       #FUN-840202 --end--
           #FUN-6A0007 (e)
           IF SQLCA.sqlcode THEN
#              CALL cl_err(g_bnc[l_ac].bnc02,SQLCA.sqlcode,0) #No.FUN-660052
               CALL cl_err3("ins","bnc_file",g_bnb.bnb01,g_bnc[l_ac].bnc02,SQLCA.sqlcode,"","",1)
               CANCEL INSERT
           ELSE
             #IF g_aza.aza44 = "Y" THEN #FUN-550077  #TQC-6C0060 mark
             #   CALL cl_itemname_switch(2,"bnc_file","bnc04",g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04) RETURNING g_bnc[l_ac].bnc04
             #END IF
 
            #FUN-6A0007 (s)
              IF g_bnb.bnb03 = '2' THEN
 
                 ## 出貨單號與項次,均不為null才更新
                 IF NOT cl_null(g_bnc[l_ac].bnc011) AND 
                    NOT cl_null(g_bnc[l_ac].bnc012) THEN
                    CALL i020_up_ogb1014('1',g_bnc[l_ac].bnc011,
                                            g_bnc[l_ac].bnc012)
                    IF g_success = 'N' THEN
                       CALL cl_err('','abx-058',1)
                       ROLLBACK WORK
                       CANCEL INSERT
                    END IF
                 END IF
              END IF
            #FUN-6A0007 (e)
 
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
           END IF
 
       BEFORE FIELD bnc02                        # dgeeault 序號
          IF cl_null(g_bnc[l_ac].bnc02) OR g_bnc[l_ac].bnc02 = 0 THEN
             SELECT max(bnc02)+1 INTO g_bnc[l_ac].bnc02 FROM bnc_file
              WHERE bnc01 = g_bnb.bnb01
             IF cl_null(g_bnc[l_ac].bnc02) THEN
                LET g_bnc[l_ac].bnc02 = 1
             END IF
          END IF
 
       AFTER FIELD bnc02
          IF NOT cl_null(g_bnc[l_ac].bnc02) THEN
             IF g_bnc[l_ac].bnc02 = 0 THEN
                NEXT FIELD bnc02
             END IF
             IF g_bnc[l_ac].bnc02 != g_bnc_t.bnc02 OR
                g_bnc_t.bnc02 IS NULL THEN
                SELECT count(*) INTO l_n
                  FROM bnc_file
                 WHERE bnc01 = g_bnb.bnb01
                   AND g_bnc[l_ac].bnc02 = bnc02
                IF l_n > 0 THEN
                   CALL cl_err('','abx-006',0)
                   LET g_bnc[l_ac].bnc02 = g_bnc_t.bnc02
                   NEXT FIELD bnc02
                END IF
             END IF
          END IF
 
       ON CHANGE bnc04   # FUN-550077
        IF g_aza.aza44 = "Y" THEN
          #CALL cl_itemname_modcurr("bnc_file","bnc04",g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04) RETURNING g_i  #TQC-6C0060 mark
           IF g_zx14 = "Y" AND g_on_change THEN
             #CALL p_itemname_update("bnc_file","bnc04",g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04) RETURNING g_bnc[l_ac].bnc04  #TQC-6C0060 mark
              CALL p_itemname_update("bnc_file","bnc04",g_bnc[l_ac].bnc03) #TQC-6C0060 
             #DISPLAY g_bnc[l_ac].bnc04 TO bnc04  #TQC-6C0060 mark
              CALL cl_show_fld_cont()   #TQC-6C0060 
           END IF
        ELSE
           CALL cl_err(g_bnc[l_ac].bnc03,"lib-151",1)
        END IF
 
#FUN-530046
       BEFORE FIELD bnc11
          IF g_bnc[l_ac].bnc11 IS NULL THEN
             LET g_bnc[l_ac].bnc11 = g_bnb.bnb16
             LET g_bnc_t.bnc11 = g_bnc[l_ac].bnc11
             #------MOD-5A0095 START----------
             DISPLAY BY NAME g_bnc[l_ac].bnc11
             #------MOD-5A0095 END------------
          END IF
 
       AFTER FIELD bnc11
          IF NOT cl_null(g_bnc[l_ac].bnc11) THEN
             CASE
                WHEN g_bnb.bnb03 = '1'
                   SELECT COUNT(*) INTO l_n FROM sfb_file
                    WHERE sfb01 = g_bnc[l_ac].bnc11 AND sfb87='Y'
                   IF l_n < 1 THEN
                      CALL cl_err('','abx-005',0)
                      NEXT FIELD bnc11
                   END IF
 
                WHEN g_bnb.bnb03 = '2'
                   SELECT COUNT(*) INTO l_n FROM ogb_file
                    WHERE ogb31 = g_bnc[l_ac].bnc11
                   IF l_n < 1 THEN
                      CALL cl_err('3','asf-959',0)   #No.FUN-590024
                      NEXT FIELD bnc11
                   END IF
             END CASE
             DISPLAY BY NAME g_bnc[l_ac].bnc11
          END IF
#END FUN-530046
 
#TQC-990115 --begin--
       AFTER FIELD bnc10
          IF NOT cl_null(g_bnc[l_ac].bnc10) THEN
            IF g_bnc[l_ac].bnc10 < 0 THEN
               CALL cl_err('','aec-020',0)
               NEXT FIELD bnc10
            END IF
         END IF  
#TQC-990115 --end--
 
    #FUN-6A0007 (s)-------------------------------------------
       AFTER FIELD bnc011
          IF NOT cl_null(g_bnb.bnb04) THEN
             IF cl_null(g_bnc[l_ac].bnc011) OR
                g_bnb.bnb04 != g_bnc[l_ac].bnc011 THEN
                CALL cl_err('','abx-060',0) 
                NEXT FIELD bnc011
             END IF
          END IF
 
 
       #---CHECK單據號碼是否重覆
       #CHI-CB0018修改為單據號碼可重覆，但會控卡數量
       AFTER FIELD bnc012
          IF NOT cl_null(g_bnc[l_ac].bnc012) THEN
             IF cl_null(g_bnc[l_ac].bnc011) THEN
                NEXT FIELD bnc012
             END IF
          #CHI-CB0018 add-----S
          ELSE
            IF NOT cl_null(g_bnc[l_ac].bnc011) THEN
               CALL cl_err('','sub-522',0)
               NEXT FIELD bnc012
            END IF
          #CHI-CB0018 add-----E
          END IF
          
          IF NOT cl_null(g_bnc[l_ac].bnc011) AND
             NOT cl_null(g_bnc[l_ac].bnc012) THEN
             IF cl_null(g_bnc_t.bnc02) THEN  #新增時
                IF g_bnc[l_ac].bnc012 != g_bnc_t.bnc012 OR g_bnc_t.bnc012 IS NULL THEN   #CHI-CB0018 add
                   SELECT COUNT(*) INTO l_n
                     FROM bnc_file
                    WHERE bnc011 = g_bnc[l_ac].bnc011
                      AND bnc012 = g_bnc[l_ac].bnc012
                      AND bnc01  = g_bnb.bnb01         #CHI-CB0018 add
                    IF l_n > 0 THEN
                       CALL cl_err('','abx-063',1)
                       NEXT FIELD bnc012
                    END IF
                END IF                                 #CHI-CB0018 add
             ELSE
                 IF g_bnc[l_ac].bnc011 != g_bnc_o.bnc011 OR  #修改
                   g_bnc[l_ac].bnc012 != g_bnc_o.bnc012 THEN
                   SELECT COUNT(*) INTO l_n
                     FROM bnc_file
                    WHERE bnc011 = g_bnc[l_ac].bnc011
                      AND bnc012 = g_bnc[l_ac].bnc012
                   IF l_n > 0 THEN
                       CALL cl_err('','abx-063',1)
                       NEXT FIELD bnc012
                   END IF
                END IF
             END IF
             CASE g_bnb.bnb03
                  WHEN '1'     #發料單
                    SELECT sfp04 INTO l_sfp04
                      FROM sfp_file
                     WHERE sfp01 = g_bnc[l_ac].bnc011
                    IF STATUS THEN
                       CALL cl_err('sel ogb',STATUS,1)
                       NEXT FIELD bnc012
                    END IF
                   
                    IF l_sfp04 = 'N' THEN
                      #SELECT sfs04,ima02,sfs05,               #CHI-CB0018 mark
                       SELECT sfs04,ima02,g_bnc[l_ac].bnc06,   #CHI-CB0018
                              sfs06,ima15,ima53
                         INTO g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04,
                              g_bnc[l_ac].bnc06,g_bnc[l_ac].bnc05,
                              g_bnc[l_ac].ima15,g_bnc[l_ac].bnc08  #最近採購單價
                         FROM sfs_file,ima_file
                        WHERE sfs04= ima01
                          AND sfs01= g_bnc[l_ac].bnc011
                          AND sfs02= g_bnc[l_ac].bnc012
                       IF STATUS THEN
                          CALL cl_err('sel sfs','abx-064',1)
                          NEXT FIELD bnc012
                       END IF
                       IF g_bnb.bnb19 = 'Y' THEN
                          IF g_bnc[l_ac].ima15 <> 'Y' THEN
                             CALL cl_err('ima15','afa-060',1)
                             NEXT FIELD bnc012
                          END IF
                       END IF
                       #-----MOD-920165---------
                       ##FUN-6A0007--(S)
                       ##        =N時，須卡單身的資料須為非保稅品
                       #IF g_bnb.bnb19 = 'N' THEN
                       #   IF g_bnc[l_ac].ima15 <> 'N' THEN
                       #      CALL cl_err('ima15','afa-061',1)
                       #      NEXT FIELD bnc012
                       #   END IF
                       #END IF
                       ##FUN-6A0007--(E)
                       #-----END MOD-920165-----
                    ELSE
                      #SELECT sfe07,ima02,sfe16,sfe17,               #CHI-CB0018 mark
                       SELECT sfe07,ima02,g_bnc[l_ac].bnc06,sfe17,   #CHI-CB0018
                              ima15,ima53
                         INTO g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04,
                              g_bnc[l_ac].bnc06,g_bnc[l_ac].bnc05,
                              g_bnc[l_ac].ima15,g_bnc[l_ac].bnc08  #最近採購單價
                         FROM sfe_file,ima_file
                        WHERE sfe07 = ima01
                          AND sfe02 = g_bnc[l_ac].bnc011
                          AND sfe28 = g_bnc[l_ac].bnc012
                       IF STATUS THEN
                          CALL cl_err('sel sfe','abx-064',1)
                          NEXT FIELD bnc012
                       END IF
                       IF g_bnb.bnb19 = 'Y' THEN
                          IF g_bnc[l_ac].ima15 <> 'Y' THEN
                             CALL cl_err('ima15','afa-060',1)
                             NEXT FIELD bnc012
                          END IF
                       END IF
                       #-----MOD-920165---------
                       ##FUN-6A0007--(S)
                       ##        =N時，須卡單身的資料須為非保稅品
                       #IF g_bnb.bnb19 = 'N' THEN
                       #   IF g_bnc[l_ac].ima15 <> 'N' THEN
                       #      CALL cl_err('ima15','afa-061',1)
                       #      NEXT FIELD bnc012
                       #   END IF
                       #END IF
                       ##FUN-6A0007--(E)
                       #-----END MOD-920165-----
                    END IF
                    
                    LET g_bnc[l_ac].bnc07 = g_aza.aza17
                    IF g_bnc[l_ac].bnc08 IS NULL THEN
                       LET g_bnc[l_ac].bnc08=0
                    END IF
                    LET g_bnc[l_ac].bnc08= cl_digcut(g_bnc[l_ac].bnc08,
                                                     t_azi03)
                    LET g_bnc[l_ac].bnc10= g_bnc[l_ac].bnc08 *
                                           g_bnc[l_ac].bnc06 * 1
                    LET g_bnc[l_ac].bnc10= cl_digcut(g_bnc[l_ac].bnc10,
                                                     t_azi04)
                    LET g_bnc[l_ac].bnc09 = 1

                   #CHI-CB0018---add---S 
                   #預帶單號
                    IF l_sfp04 = 'N' THEN
                    ELSE
                       IF NOT cl_null(g_bnc[l_ac].bnc011) AND NOT cl_null(g_bnc[l_ac].bnc012) THEN
                          SELECT sfe01 INTO g_bnc[l_ac].bnc11 FROM sfe_file
                           WHERE sfe02 =g_bnc[l_ac].bnc011
                             AND sfe28 =g_bnc[l_ac].bnc012
                       END IF
                    END IF   
                   #CHI-CB0018---add---E
 
                 WHEN '2'     #出貨單
                   #SELECT ogb04, ogb06, ogb05, ogb12,oga23,              #CHI-CB0018 mark
                    SELECT ogb04, ogb06, ogb05, g_bnc[l_ac].bnc06,oga23,  #CHI-CB0018
#                          ogb13, oga24, ogb12*ogb13*oga24,    #CHI-B70039 mark
                           ogb13, oga24, ogb917*ogb13*oga24,   #CHI-B70039
                           ima021,ima15
                      INTO g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04,
                           g_bnc[l_ac].bnc05,g_bnc[l_ac].bnc06,
                           g_bnc[l_ac].bnc07,g_bnc[l_ac].bnc08,
                           g_bnc[l_ac].bnc09,g_bnc[l_ac].bnc10,
                           g_bnc[l_ac].ima021,g_bnc[l_ac].ima15
                      FROM ogb_file,oga_file,OUTER ima_file
                     WHERE ogb01=g_bnc[l_ac].bnc011
                       AND ogb03=g_bnc[l_ac].bnc012
                       AND ogb01=oga01
                       AND ogb_file.ogb04=ima_file.ima01
                       AND ogaconf='Y'
                       #AND oga09='2'   #MOD-920192
                       AND (oga09='2' OR oga09='3')   #MOD-920192
                    IF STATUS THEN
                       CALL cl_err('sel ogb','abx-064',1)
                       NEXT FIELD bnc012
                    END IF
                    IF g_bnb.bnb19 = 'Y' THEN
                       IF g_bnc[l_ac].ima15 <> 'Y' THEN
                          CALL cl_err('ima15','afa-060',1)
                          NEXT FIELD bnc012
                       END IF
                    END IF
                    #-----MOD-920165---------
                    ##FUN-6A0007--(S)
                    ##        =N時，須卡單身的資料須為非保稅品
                    #IF g_bnb.bnb19 = 'N' THEN
                    #   IF g_bnc[l_ac].ima15 <> 'N' THEN
                    #      CALL cl_err('ima15','afa-061',1)
                    #      NEXT FIELD bnc012
                    #   END IF
                    #END IF
                    ##FUN-6A0007--(E)
                    #-----END MOD-920165-----
                   #CHI-CB0018---add---S
                   #預帶單號
                    IF NOT cl_null(g_bnc[l_ac].bnc011) AND NOT cl_null(g_bnc[l_ac].bnc012) THEN
                       SELECT ogb31 INTO g_bnc[l_ac].bnc11 FROM ogb_file
                        WHERE ogb01 =g_bnc[l_ac].bnc011
                          AND ogb03 =g_bnc[l_ac].bnc012
                    END IF
                   #CHI-CB0018---add---E

                 WHEN '3'     #進料驗退單
                    SELECT rvv31,rvv031,rvv35,
                          #rvv17,pmm22 ,rvv38,                #CHI-CB0018 mark
                           g_bnc[l_ac].bnc06,pmm22 ,rvv38,    #CHI-CB0018
                           ima021,ima15,rvu03
                      INTO g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04,
                           g_bnc[l_ac].bnc05,g_bnc[l_ac].bnc06,
                           g_bnc[l_ac].bnc07,g_bnc[l_ac].bnc08,
                           g_bnc[l_ac].ima021,g_bnc[l_ac].ima15,l_rvu03
                      FROM rvv_file ,rvu_file,pmm_file,ima_file
                     WHERE rvv01= g_bnc[l_ac].bnc011
                       AND rvv02= g_bnc[l_ac].bnc012
                       AND rvv03='2'
                       AND rvv01=rvu01
                       AND rvv36=pmm01
                       AND rvuconf='Y'
                       AND rvv31=ima01
                    IF STATUS THEN
                       CALL cl_err('sel ogb','abx-064',1)
                       NEXT FIELD bnc012
                    END IF
                    IF g_bnb.bnb19 = 'Y' THEN
                       IF g_bnc[l_ac].ima15 <> 'Y' THEN
                          CALL cl_err('ima15','afa-060',1)
                          NEXT FIELD bnc012
                       END IF
                    END IF
                    #-----MOD-920165---------
                    ##FUN-6A0007--(S)
                    ##        =N時，須卡單身的資料須為非保稅品
                    #IF g_bnb.bnb19 = 'N' THEN
                    #   IF g_bnc[l_ac].ima15 <> 'N' THEN
                    #      CALL cl_err('ima15','afa-061',1)
                    #      NEXT FIELD bnc012
                    #   END IF
                    #END IF
                    ##FUN-6A0007--(E)
                    #-----END MOD-920165-----
                    CALL s_curr3(g_bnc[l_ac].bnc07,l_rvu03,'D')
                                 RETURNING g_bnc[l_ac].bnc09
                    LET g_bnc[l_ac].bnc10 = cl_digcut( g_bnc[l_ac].bnc06*
                                                       g_bnc[l_ac].bnc08*
                                                       g_bnc[l_ac].bnc09,
                                                       t_azi04)
                 WHEN '4'     #雜項發料單
                   #SELECT inb04,ima02,inb09,inb08,               #CHI-CB0018 mark
                    SELECT inb04,ima02,g_bnc[l_ac].bnc06,inb08,   #CHI-CB0018
                           ima021,ima15,ima53
                      INTO g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04,
                           g_bnc[l_ac].bnc06,g_bnc[l_ac].bnc05,
                           g_bnc[l_ac].ima021,g_bnc[l_ac].ima15,
                           g_bnc[l_ac].bnc08 #最近採購單價
                      FROM inb_file ,ima_file
                     WHERE inb01= g_bnc[l_ac].bnc011
                       AND inb03= g_bnc[l_ac].bnc012
                       AND inb04=ima01
                    IF STATUS THEN
                       CALL cl_err('sel sfe','abx-064',1)
                       NEXT FIELD bnc012
                    END IF
                    IF g_bnb.bnb19 = 'Y' THEN
                       IF g_bnc[l_ac].ima15 <> 'Y' THEN
                          CALL cl_err('ima15','afa-060',1)
                          NEXT FIELD bnc012
                       END IF
                    END IF
                    #-----MOD-920165---------
                    ##FUN-6A0007--(S)
                    ##        =N時，須卡單身的資料須為非保稅品
                    #IF g_bnb.bnb19 = 'N' THEN
                    #   IF g_bnc[l_ac].ima15 <> 'N' THEN
                    #      CALL cl_err('ima15','afa-061',1)
                    #      NEXT FIELD bnc012
                    #   END IF
                    #END IF
                    ##FUN-6A0007--(E)
                    #-----END MOD-920165-----
                    LET g_bnc[l_ac].bnc07 = g_aza.aza17
                    IF g_bnc[l_ac].bnc08 IS NULL THEN
                       LET g_bnc[l_ac].bnc08=0
                    END IF
                    LET g_bnc[l_ac].bnc08= cl_digcut(g_bnc[l_ac].bnc08,
                                                     t_azi03)
                    LET g_bnc[l_ac].bnc10= g_bnc[l_ac].bnc08 *
                                           g_bnc[l_ac].bnc06 * 1
                    LET g_bnc[l_ac].bnc10= cl_digcut(g_bnc[l_ac].bnc10,
                                                     t_azi04)
                    LET g_bnc[l_ac].bnc09 = 1
                 WHEN '6'     #倉退單
                    #---050831 CJC Modi:有一種情形是無收貨單及採購單
                    SELECT rvv31,rvv031,rvv35,
                          #rvv17,'NTD' ,rvv38,              #CHI-CB0018 mark
                           g_bnc[l_ac].bnc06,'NTD' ,rvv38,  #CHI-CB0018
                           ima021,ima15,rvu03
                      INTO g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04,
                           g_bnc[l_ac].bnc05,g_bnc[l_ac].bnc06,
                           g_bnc[l_ac].bnc07,g_bnc[l_ac].bnc08,
                           g_bnc[l_ac].ima021,g_bnc[l_ac].ima15,l_rvu03
                      FROM rvv_file ,rvu_file,ima_file
                     WHERE rvv01= g_bnc[l_ac].bnc011
                       AND rvv02= g_bnc[l_ac].bnc012
                       AND rvv03='3'
                       AND rvv01=rvu01
                       AND rvuconf='Y'
                       AND rvv31=ima01
                     IF STATUS THEN
                       CALL cl_err('sel rvv','abx-064',1)
                       NEXT FIELD bnc012
                    END IF
                    IF g_bnb.bnb19 = 'Y' THEN
                       IF g_bnc[l_ac].ima15 <> 'Y' THEN
                          CALL cl_err('ima15','afa-060',1)
                          NEXT FIELD bnc012
                       END IF
                    END IF
                    #-----MOD-920165---------
                    ##FUN-6A0007--(S)
                    ##        =N時，須卡單身的資料須為非保稅品
                    #IF g_bnb.bnb19 = 'N' THEN
                    #   IF g_bnc[l_ac].ima15 <> 'N' THEN
                    #      CALL cl_err('ima15','afa-061',1)
                    #      NEXT FIELD bnc012
                    #   END IF
                    #END IF
                    ##FUN-6A0007--(E)
                    #-----END MOD-920165-----
                    CALL s_curr3(g_bnc[l_ac].bnc07,l_rvu03,'D')
                                 RETURNING g_bnc[l_ac].bnc09
                    LET g_bnc[l_ac].bnc10 = cl_digcut( g_bnc[l_ac].bnc06*
                                                       g_bnc[l_ac].bnc08*
                                                       g_bnc[l_ac].bnc09,
                                                       t_azi04)
             END CASE
             LET g_bnc_o.bnc011 = g_bnc[l_ac].bnc011
             LET g_bnc_o.bnc012 = g_bnc[l_ac].bnc012
          END IF 
 
    #FUN-6A0007 (e)-------------------------------------------
 
       AFTER FIELD bnc03
          IF NOT cl_null(g_bnc[l_ac].bnc03) THEN
             #FUN-AA0059 ---------------------------------add start------------------------
             IF NOT s_chk_item_no(g_bnc[l_ac].bnc03,'') THEN
                CALL cl_err('',g_errno,1)
                NEXT FIELD bnc03
             END IF
             #FUN-AA0059 --------------------------------add end------------------------  
             #FUN-6A0007 (s)
             {
             SELECT ima02 INTO g_bnc[l_ac].bnc04 FROM ima_file
              WHERE ima01 = g_bnc[l_ac].bnc03
             IF STATUS THEN
#               CALL cl_err('err bnc03',STATUS,1)  #No.FUN-660052
                CALL cl_err3("sel","ima_file",g_bnc[l_ac].bnc03,"",STATUS,"","err bnc03",1)
                NEXT FIELD bnc03
             END IF
             }
             SELECT ima02,ima15,ima021 
               INTO g_bnc[l_ac].bnc04,g_bnc[l_ac].ima15,g_bnc[l_ac].ima021
               FROM ima_file
              WHERE ima01 = g_bnc[l_ac].bnc03
             IF STATUS THEN
                CALL cl_err('err bnc03',STATUS,1)
                NEXT FIELD bnc03
             END IF
             IF g_bnb.bnb19 = 'Y' THEN  #單身僅存保稅品否
                 IF g_bnc[l_ac].ima15 <> 'Y' THEN
                     CALL cl_err('ima15','afa-060',1)
                     NEXT FIELD bnc03
                 END IF
             END IF
             #FUN-6A0007 (e)
             #-----MOD-920165---------
             ##FUN-6A0007--(S)
             ##        =N時，須卡單身的資料須為非保稅品
             #IF g_bnb.bnb19 = 'N' THEN
             #   IF g_bnc[l_ac].ima15 <> 'N' THEN
             #      CALL cl_err('ima15','afa-061',1)
             #      NEXT FIELD bnc012
             #   END IF
             #END IF
             ##FUN-6A0007--(E)
             #-----END MOD-920165-----
          ELSE
             LET g_bnc[l_ac].bnc04 = ' '
             LET g_bnc[l_ac].ima15  = ' '     #FUN-6A0007
             LET g_bnc[l_ac].ima021 = ' '     #FUN-6A0007
          END IF
          #------MOD-5A0095 START----------
          DISPLAY BY NAME g_bnc[l_ac].bnc04
          DISPLAY BY NAME g_bnc[l_ac].ima15   #FUN-6A0007
          DISPLAY BY NAME g_bnc[l_ac].ima021  #FUN-6A0007
          #------MOD-5A0095 END------------
 
       AFTER FIELD bnc05
          IF NOT cl_null(g_bnc[l_ac].bnc05) THEN
             SELECT gfe01 FROM gfe_file
              WHERE gfe01 = g_bnc[l_ac].bnc05 AND gfeacti IN ('Y','y')
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bnc[l_ac].bnc05,STATUS,0)  #No.FUN-660052
                CALL cl_err3("sel","gfe_file",g_bnc[l_ac].bnc05,"",STATUS,"","",1)
                LET g_bnc[l_ac].bnc05 = g_bnc_t.bnc05
                NEXT FIELD bnc05
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bnc[l_ac].bnc05
                #------MOD-5A0095 END------------
             END IF
         #FUN-910088--add--start--
             IF NOT cl_null(g_bnc[l_ac].bnc06) THEN
                CALL i020_bnc06_check() 
                LET g_bnc05_t = g_bnc[l_ac].bnc05
             END IF
         #FUN-910088--add--end--
          ELSE
             LET g_bnc[l_ac].bnc05 = ' '
          END IF
 
       AFTER FIELD bnc06
          CALL i020_bnc06_check()    #FUN-910088--add--

         #CHI-CB0018---add---S
          #不可輸入負數
          IF g_bnc[l_ac].bnc06 <= 0 THEN
             LET g_bnc[l_ac].bnc06 = 0
             CALL cl_err('','axr-034',1)
             DISPLAY BY NAME g_bnc[l_ac].bnc06
             NEXT FIELD bnc06
          END IF

          #數量控卡
          CALL chk_bnc06_put(g_bnc[l_ac].bnc06,g_bnc[l_ac].bnc011,g_bnc[l_ac].bnc012)
               RETURNING l_flag
          IF l_flag='1' THEN
             CALL cl_err(g_bnc[l_ac].bnc06,'aco-046',1)
             NEXT FIELD bnc06
          END IF
         #CHI-CB0018---add---E

      #FUN-910088--mark--start--
      #   IF cl_null(g_bnc[l_ac].bnc06) THEN
      #      LET g_bnc[l_ac].bnc06=0
      #   END IF
      #   LET g_bnc[l_ac].bnc10 = g_bnc[l_ac].bnc06 * g_bnc[l_ac].bnc08 * g_bnc[l_ac].bnc09
      #   #------MOD-5A0095 START----------
      #   DISPLAY BY NAME g_bnc[l_ac].bnc10
      #   #------MOD-5A0095 END------------
      #   #------MOD-5A0095 START----------
      #   DISPLAY BY NAME g_bnc[l_ac].bnc06
      #   DISPLAY BY NAME g_bnc[l_ac].bnc10
      #   #------MOD-5A0095 END------------
      #FUN-910088--mark--end--
      
       AFTER FIELD bnc07
          IF NOT cl_null(g_bnc[l_ac].bnc07) THEN
             SELECT azi01 FROM azi_file
              WHERE azi01 = g_bnc[l_ac].bnc07
                AND aziacti IN ('Y','y')
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bnc[l_ac].bnc07,STATUS,0)   #No.FUN-660052
                CALL cl_err3("sel","azi_file",g_bnc[l_ac].bnc07,"",STATUS,"","",1)
                LET g_bnc[l_ac].bnc07 = g_bnc_t.bnc07
                NEXT FIELD bnc07
                #------MOD-5A0095 START----------
                DISPLAY BY NAME g_bnc[l_ac].bnc07
                #------MOD-5A0095 END------------
             END IF
             CALL s_curr3(g_bnc[l_ac].bnc07,g_bnb.bnb02,'S')
                  RETURNING g_bnc[l_ac].bnc09
             IF STATUS OR cl_null(g_bnc[l_ac].bnc09) THEN
                LET g_bnc[l_ac].bnc09 = 0
             END IF
             #------MOD-5A0095 START----------
             DISPLAY BY NAME g_bnc[l_ac].bnc09
             #------MOD-5A0095 END------------
          END IF
 
       AFTER FIELD bnc08
#TQC-990115 --begin--
         IF NOT cl_null(g_bnc[l_ac].bnc08) THEN
            IF g_bnc[l_ac].bnc08 < 0 THEN
               CALL cl_err('','aec-020',0)
               NEXT FIELD bnc08
            END IF 
         END IF 
#TQC-990115 --end--       
          IF cl_null(g_bnc[l_ac].bnc08) THEN
             LET g_bnc[l_ac].bnc08=0
          END IF
          LET g_bnc[l_ac].bnc10 = g_bnc[l_ac].bnc06 * g_bnc[l_ac].bnc08 * g_bnc[l_ac].bnc09
          #------MOD-5A0095 START----------
          DISPLAY BY NAME g_bnc[l_ac].bnc08
          DISPLAY BY NAME g_bnc[l_ac].bnc10
          #------MOD-5A0095 END------------
 
       AFTER FIELD bnc09
          IF cl_null(g_bnc[l_ac].bnc09) THEN
             LET g_bnc[l_ac].bnc09 = 0
          END IF
 
          #FUN-4C0080
          IF g_bnc[l_ac].bnc07 =g_aza.aza17 THEN
             LET g_bnc[l_ac].bnc09=1
             DISPLAY BY NAME g_bnc[l_ac].bnc09
          END IF
          #--END
 
          LET g_bnc[l_ac].bnc10 = g_bnc[l_ac].bnc06 * g_bnc[l_ac].bnc08 * g_bnc[l_ac].bnc09
 
        #No.FUN-840202 --start--
        AFTER FIELD bncud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD bncud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        #No.FUN-840202 ---end---
 
       BEFORE DELETE                            #是否取消單身
          IF g_bnc_t.bnc02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN
                CALL cl_err("", -263, 1)
                CANCEL DELETE
             END IF
             DELETE FROM bnc_file
              WHERE bnc01 = g_bnb.bnb01 AND bnc02 = g_bnc_t.bnc02
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bnc_t.bnc02,SQLCA.sqlcode,0)   #No.FUN-660052
                CALL cl_err3("del","bnc_file",g_bnb.bnb01,g_bnc_t.bnc02,SQLCA.sqlcode,"","",1)
                ROLLBACK WORK
                CANCEL DELETE
 
            #--> #FUN-6A0007 update ogb1014 = N 
             ELSE
              IF g_bnb.bnb03 = '2' THEN
                 ## 出貨單號與項次,均不為null才更新
                 IF NOT cl_null(g_bnc[l_ac].bnc011) AND 
                    NOT cl_null(g_bnc[l_ac].bnc012) THEN
                    CALL i020_up_ogb1014('3',g_bnc[l_ac].bnc011,
                                            g_bnc[l_ac].bnc012)
                    IF g_success = 'N' THEN
                       CALL cl_err('','abx-058',1)
                       ROLLBACK WORK
                       CANCEL DELETE
                    END IF
                 END IF
              END IF
            #--- #FUN-6A0007 ------------------------------
 
             END IF
             LET g_rec_b = g_rec_b-1
             DISPLAY g_rec_b TO FORMONLY.cn2
          END IF
          COMMIT WORK
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_bnc[l_ac].* = g_bnc_t.*
             CLOSE i020_bcl
             ROLLBACK WORK
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_bnc[l_ac].bnc02,-263,1)
             LET g_bnc[l_ac].* = g_bnc_t.*
          ELSE
            #IF g_aza.aza44 = "Y" THEN  #FUN-550077  #TQC-6C0060 mark
            #   CALL cl_itemname_switch(1,"bnc_file","bnc04",g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04) RETURNING g_bnc[l_ac].bnc04
            #END IF
             UPDATE bnc_file SET bnc02 = g_bnc[l_ac].bnc02,
                                 bnc03 = g_bnc[l_ac].bnc03,
                                 bnc04 = g_bnc[l_ac].bnc04,
                                 bnc05 = g_bnc[l_ac].bnc05,
                                 bnc06 = g_bnc[l_ac].bnc06,
                                 bnc07 = g_bnc[l_ac].bnc07,
                                 bnc08 = g_bnc[l_ac].bnc08,
                                 bnc09 = g_bnc[l_ac].bnc09,
                                 bnc10 = g_bnc[l_ac].bnc10,
                              #FUN-6A0007 (s)
                              bnc011= g_bnc[l_ac].bnc011,
                              bnc012= g_bnc[l_ac].bnc012,
                              #FUN-6A0007 (e)
                                 bnc11 = g_bnc[l_ac].bnc11   #FUN-530046
                               #FUN-840202 --start--
                              ,bncud01 = g_bnc[l_ac].bncud01,
                               bncud02 = g_bnc[l_ac].bncud02,
                               bncud03 = g_bnc[l_ac].bncud03,
                               bncud04 = g_bnc[l_ac].bncud04,
                               bncud05 = g_bnc[l_ac].bncud05,
                               bncud06 = g_bnc[l_ac].bncud06,
                               bncud07 = g_bnc[l_ac].bncud07,
                               bncud08 = g_bnc[l_ac].bncud08,
                               bncud09 = g_bnc[l_ac].bncud09,
                               bncud10 = g_bnc[l_ac].bncud10,
                               bncud11 = g_bnc[l_ac].bncud11,
                               bncud12 = g_bnc[l_ac].bncud12,
                               bncud13 = g_bnc[l_ac].bncud13,
                               bncud14 = g_bnc[l_ac].bncud14,
                               bncud15 = g_bnc[l_ac].bncud15
                               #FUN-840202 --end-- 
              WHERE bnc01 = g_bnb.bnb01
                #AND bnc02 = g_bnc[l_ac].bnc02  #FUN-6A0007
                AND bnc02 = g_bnc_t.bnc02   #FUN-6A0007
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_bnc[l_ac].bnc02,SQLCA.sqlcode,0) #No.FUN-660052
                CALL cl_err3("upd","bnc_file",g_bnb.bnb01,g_bnc[l_ac].bnc02,SQLCA.sqlcode,"","",1)
                LET g_bnc[l_ac].* = g_bnc_t.*
             ELSE
               #IF g_aza.aza44 = "Y" THEN  #FUN-550077  #TQC-6C0060 mark
               #   CALL cl_itemname_switch(2,"bnc_file","bnc04",g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04) RETURNING g_bnc[l_ac].bnc04
               #END IF
 
                #--> #FUN-6A0007 update 舊值 -> ogb1014 = N 
                #                                     新值 -> ogb1014 = Y
                IF g_bnb.bnb03 = '2' THEN
                  
                    ## 出貨單號與項次,均不為null才更新
                    IF NOT cl_null(g_bnc[l_ac].bnc011) AND 
                       NOT cl_null(g_bnc[l_ac].bnc012) THEN
 
                       ## 新值  upd ogb1014 = Y 
                       CALL i020_up_ogb1014('1',g_bnc[l_ac].bnc011,
                                               g_bnc[l_ac].bnc012)
                       IF g_success = 'N' THEN
                          CALL cl_err('','abx-058',1)
                          ROLLBACK WORK
                       END IF
                    END IF
 
                 
                    ## 出貨單號與項次,均不為null才更新
                    IF NOT cl_null(g_bnc_t.bnc011) AND 
                       NOT cl_null(g_bnc_t.bnc012) THEN
 
                       ## 舊值  upd ogb1014 = N 
                       CALL i020_up_ogb1014('3',g_bnc_t.bnc011,
                                                 g_bnc_t.bnc012)
                       IF g_success = 'N' THEN
                          CALL cl_err('','abx-058',1)
                          ROLLBACK WORK
                       END IF
                    END IF
                END IF
                #--- #FUN-6A0007 ------------------------------
 
                MESSAGE 'UPDATE O.K'
                COMMIT WORK
             END IF
          END IF
 
       AFTER ROW
          LET l_ac = ARR_CURR()
         #LET l_ac_t = l_ac   #FUN-D30034 mark
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             IF p_cmd = 'u' THEN
                 LET g_bnc[l_ac].* = g_bnc_t.*
             #FUN-D30034--add--begin--
             ELSE
                CALL g_bnc.deleteElement(l_ac)
                IF g_rec_b != 0 THEN
                   LET g_action_choice = "detail"
                   LET l_ac = l_ac_t
                END IF
             #FUN-D30034--add--end----
             END IF
             CLOSE i020_bcl
             ROLLBACK WORK
             EXIT INPUT
#TQC-990115 --begin--
          ELSE
            IF l_ac <= g_bnc.getLength() THEN     #MOD-B20056 add
               IF NOT cl_null(g_bnc[l_ac].bnc10) THEN
                  IF g_bnc[l_ac].bnc10 < 0 THEN
                     CALL cl_err('','aec-020',0)
                     NEXT FIELD bnc10
                  END IF
               END IF
               IF NOT cl_null(g_bnc[l_ac].bnc08) THEN
                  IF g_bnc[l_ac].bnc08 < 0 THEN
                     CALL cl_err('','aec-020',0)
                     NEXT FIELD bnc08
                  END IF
               END IF
            END IF           #MOD-B20056 add
#TQC-990115 --end--             
          END IF
         #CHI-CB0018---add---S
         #單據控卡
          CASE g_bnb.bnb03
             WHEN "1"
                   SELECT sfp04 INTO l_sfp04
                     FROM sfp_file
                    WHERE sfp01 = g_bnc[l_ac].bnc011
                   IF l_sfp04 = 'N' THEN
                   ELSE
                      SELECT sfe01 INTO l_bnc11_chk FROM sfe_file
                       WHERE sfe02 = g_bnc[l_ac].bnc011
                         AND sfe28 = g_bnc[l_ac].bnc012
                      IF g_bnc[l_ac].bnc11 <> l_bnc11_chk THEN
                         CALL cl_err('','abx-862',1)
                         NEXT FIELD bnc11
                      END IF
                   END IF
             WHEN "2"
                   SELECT ogb31 INTO l_bnc11_chk FROM ogb_file
                    WHERE ogb01 = g_bnc[l_ac].bnc011
                      AND ogb03 = g_bnc[l_ac].bnc012
                   IF g_bnc[l_ac].bnc11 <> l_bnc11_chk THEN
                      CALL cl_err('','abx-862',1)
                      NEXT FIELD bnc11
                   END IF
             OTHERWISE EXIT CASE
          END CASE

          CALL chk_bnc06_put(g_bnc[l_ac].bnc06,g_bnc[l_ac].bnc011,g_bnc[l_ac].bnc012)
               RETURNING l_flag
          IF l_flag='1' THEN
             CALL cl_err(g_bnc[l_ac].bnc06,'aco-046',1)
             NEXT FIELD bnc06
          END IF
         #CHI-CB0018---add---E
          LET l_ac_t = l_ac   #FUN-D30034 add
          CLOSE i020_bcl
          COMMIT WORK
 
       ON ACTION delete_body_regenerate
          IF INFIELD (bnc02) THEN
 
            #--> #FUN-6A0007 刪除重新產生前,要將ogb1014更改為N
             IF g_bnb.bnb03 = '2' THEN
                LET l_cnt = 0
                SELECT COUNT(*) INTO l_cnt FROM bnc_file
                 WHERE bnc01 = g_bnb.bnb01
                IF l_cnt > 0 THEN
                
                   CALL i020_up_ogb1014('4','','')
                   IF g_success = 'N' THEN
                      CALL cl_err('','abx-058',1)
                      NEXT FIELD bnc02
                   END IF
                END IF 
             END IF
            #--- #FUN-6A0007 -------------------------------------------- 
 
             DELETE FROM bnc_file WHERE bnc01 = g_bnb.bnb01
             IF STATUS THEN
#               CALL cl_err('del bnc',STATUS,0)  #No.FUN-660052
                CALL cl_err3("del","bnc_file",g_bnb.bnb01,"",SQLCA.sqlcode,"","del bnc",1)
                NEXT FIELD bnc02
             END IF
 
             #---有輸入單據號碼則自動將單身資料帶出---
             IF NOT cl_null(g_bnb.bnb04) THEN
                CASE WHEN g_bnb.bnb03 = '1'
                       CALL i020_put1()
                     WHEN g_bnb.bnb03 = '2'
                       CALL i020_put2()
 
                      #--> #FUN-6A0007 upate ogb1014=Y 
                       CALL i020_up_ogb1014('2','','')
                      #--- #FUN-6A0007 ---------------------
 
                     WHEN g_bnb.bnb03 = '3'
                       CALL i020_put3()
                     WHEN g_bnb.bnb03 = '4'
                       CALL i020_put4()
                     #FUN-6A0007 (s)
                     WHEN g_bnb.bnb03 = '6'
                       CALL i020_put6()
                     #FUN-6A0007 (e)
                END CASE
             END IF
 
             CALL i020_b_fill(" 1=1")
             EXIT INPUT
          END IF
 
      #--> #FUN-6A0007 add Action:出貨單產生
       ON ACTION get_produce 
         #IF INFIELD (bnc02) THEN
 
             IF NOT cl_null(g_bnb.bnb04) THEN
                   CALL cl_err('','abx-065',1)
             END IF
 
             #資料來源:2.出貨單 且 單據號碼空白
             IF g_bnb.bnb03 = '2' AND cl_null(g_bnb.bnb04) THEN  
 
                CALL cl_init_qry_var()
                CALL q_advice(TRUE,TRUE,g_bnc[l_ac].bnc11,g_bnb.bnb05,g_bnb.bnb19)
                   RETURNING g_str
 
                IF NOT cl_null(g_str) THEN
                    CALL i020_ins_bnc(g_str)
 
                    ## upd ogb1014=Y
                    IF g_success = 'Y' THEN
                       CALL i020_up_ogb1014('2','','')
                    END IF
                END IF
 
                CALL i020_b_fill(" 1=1")
                EXIT INPUT
             END IF
         #END IF
      #--- #FUN-6A0007 ------------------
 
       ON ACTION CONTROLP
          CASE
             #FUN-6A0007 (s)
             WHEN INFIELD(bnc011)
              CASE g_bnb.bnb03
               WHEN '1'
                  CALL cl_init_qry_var()
                  LET l_sfp04 = NULL
                  SELECT sfp04 INTO l_sfp04 FROM sfp_file
                     WHERE sfp01 = g_bnb.bnb04
                  IF l_sfp04 = 'Y' THEN
                     LET g_qryparam.form ="q_sfe01"
                  ELSE
                     LET g_qryparam.form ="q_sfs01"
                     LET l_sfp04 = 'N'
                  END IF
                  LET g_qryparam.default1 = g_bnc[l_ac].bnc011
                  LET g_qryparam.default2 = g_bnc[l_ac].bnc012
                  LET g_qryparam.where = " 1 = 1 "
                  IF NOT cl_null(g_bnb.bnb04) AND l_sfp04 != 'N' THEN  #單據
                      LET g_qryparam.where = g_qryparam.where.trim(),
                                            " AND sfe02= '",g_bnb.bnb04,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb04) AND l_sfp04 = 'N' THEN  #單據
                      LET g_qryparam.where = g_qryparam.where.trim(),
                                            " AND sfs01= '",g_bnb.bnb04,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb16) AND l_sfp04 != 'N' THEN  #工單
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND sfe01= '",g_bnb.bnb16,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb04) AND l_sfp04 = 'N' THEN  #工單
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND sfs03= '",g_bnb.bnb16,"'"
 
                  END IF
                  IF g_bnb.bnb19 ='Y' THEN      #單身保稅否
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND ima15 = 'Y'"
                  END IF
                  #-----MOD-920165---------
                  ##FUN-6A0007--(S)
                  ##        =N時，須卡單身的資料須為非保稅品
                  #IF g_bnb.bnb19 = 'N' THEN
                  #   LET g_qryparam.where = g_qryparam.where.trim(),
                  #                         " AND ima15 = 'N'"
                  #END IF
                  ##FUN-6A0007--(E)
                  #-----END MOD-920165-----
                  CALL cl_create_qry() RETURNING g_bnc[l_ac].bnc011,
                                                 g_bnc[l_ac].bnc012
                  DISPLAY BY NAME g_bnc[l_ac].bnc011,g_bnc[l_ac].bnc012
               WHEN '2'
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ogb07"
                  LET g_qryparam.default1 = g_bnc[l_ac].bnc011
                  LET g_qryparam.default2 = g_bnc[l_ac].bnc012
                  LET g_qryparam.where = " 1 = 1 "
                  IF NOT cl_null(g_bnb.bnb05) THEN  #客戶代號
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND oga03= '",g_bnb.bnb05,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb04) THEN  #單據
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND oga01= '",g_bnb.bnb04,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb16) THEN  #訂單
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND ogb31= '",g_bnb.bnb16,"'"
                  END IF
                  IF g_bnb.bnb19 ='Y' THEN
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                            " AND ima15 = 'Y'"
                  END IF
                  #-----MOD-920165---------
                  ##FUN-6A0007--(S)
                  ##        =N時，須卡單身的資料須為非保稅品
                  #IF g_bnb.bnb19 = 'N' THEN
                  #   LET g_qryparam.where = g_qryparam.where.trim(),
                  #                         " AND ima15 = 'N'"
                  #END IF
                  ##FUN-6A0007--(E)
                  #-----END MOD-920165-----
                  CALL cl_create_qry() RETURNING g_bnc[l_ac].bnc011,
                                                 g_bnc[l_ac].bnc012
                  DISPLAY BY NAME g_bnc[l_ac].bnc011,g_bnc[l_ac].bnc012
               WHEN '3'
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rvv6"
                  LET g_qryparam.default1 = g_bnc[l_ac].bnc011
                  LET g_qryparam.default2 = g_bnc[l_ac].bnc012
                  LET g_qryparam.where = " 1 = 1 ",
                                         " AND rvu00 = '2' "   #驗退
                  IF NOT cl_null(g_bnb.bnb05) THEN  #
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND rvu04= '",g_bnb.bnb05,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb04) THEN  #單據
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND rvv01= '",g_bnb.bnb04,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb16) THEN  #工單
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND rvv18= '",g_bnb.bnb16,"'"
                  END IF
                  IF g_bnb.bnb19 ='Y' THEN      #單身保稅否
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND ima15 = 'Y'"
                  END IF
                  #-----MOD-920165---------
                  ##FUN-6A0007--(S)
                  ##        =N時，須卡單身的資料須為非保稅品
                  #IF g_bnb.bnb19 = 'N' THEN
                  #   LET g_qryparam.where = g_qryparam.where.trim(),
                  #                         " AND ima15 = 'N'"
                  #END IF
                  ##FUN-6A0007--(E)
                  #-----END MOD-920165-----
                  CALL cl_create_qry() RETURNING g_bnc[l_ac].bnc011,
                                                 g_bnc[l_ac].bnc012
                  DISPLAY BY NAME g_bnc[l_ac].bnc011,g_bnc[l_ac].bnc012
               WHEN '4'
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_inb01"
                  LET g_qryparam.default1 = g_bnc[l_ac].bnc011
                  LET g_qryparam.default2 = g_bnc[l_ac].bnc012
                  LET g_qryparam.where = " 1 = 1 "
                  IF NOT cl_null(g_bnb.bnb04) THEN  #單據
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND inb01= '",g_bnb.bnb04,"'"
                  END IF
                  IF g_bnb.bnb19 ='Y' THEN      #單身保稅否
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND ima15 = 'Y'"
                  END IF
                  #-----MOD-920165---------
                  ##FUN-6A0007--(S)
                  ##        =N時，須卡單身的資料須為非保稅品
                  #IF g_bnb.bnb19 = 'N' THEN
                  #   LET g_qryparam.where = g_qryparam.where.trim(),
                  #                         " AND ima15 = 'N'"
                  #END IF
                  ##FUN-6A0007--(E)
                  #-----END MOD-920165-----
                  CALL cl_create_qry() RETURNING g_bnc[l_ac].bnc011,
                                                 g_bnc[l_ac].bnc012
                  DISPLAY BY NAME g_bnc[l_ac].bnc011,g_bnc[l_ac].bnc012
               WHEN '6'
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_rvv6"
                  LET g_qryparam.default1 = g_bnc[l_ac].bnc011
                  LET g_qryparam.default2 = g_bnc[l_ac].bnc012
                  LET g_qryparam.where = " 1 = 1 ",
                                         " AND rvu00 = '3' "     #倉退
                  IF NOT cl_null(g_bnb.bnb04) THEN  #單據
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND rvv01= '",g_bnb.bnb04,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb05) THEN  #
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                            " AND rvu04= '",g_bnb.bnb05,"'"
                  END IF
                  IF NOT cl_null(g_bnb.bnb16) THEN  #工單
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND rvv18= '",g_bnb.bnb16,"'"
                  END IF
                  IF g_bnb.bnb19 ='Y' THEN      #單身保稅否
                     LET g_qryparam.where = g_qryparam.where.trim(),
                                           " AND ima15 = 'Y'"
                  END IF
                  #-----MOD-920165---------
                  ##FUN-6A0007--(S)
                  ##        =N時，須卡單身的資料須為非保稅品
                  #IF g_bnb.bnb19 = 'N' THEN
                  #   LET g_qryparam.where = g_qryparam.where.trim(),
                  #                         " AND ima15 = 'N'"
                  #END IF
                  ##FUN-6A0007--(E)
                  #-----END MOD-920165-----
                  CALL cl_create_qry() RETURNING g_bnc[l_ac].bnc011,
                                                 g_bnc[l_ac].bnc012
                  DISPLAY BY NAME g_bnc[l_ac].bnc011,g_bnc[l_ac].bnc012
              END CASE
              NEXT FIELD bnc011
             #FUN-6A0007 (e)
             WHEN INFIELD(bnc03)
#               CALL q_ima(0,0,g_bnc[l_ac].bnc03) RETURNING g_bnc[l_ac].bnc03
#               CALL FGL_DIALOG_SETBUFFER( g_bnc[l_ac].bnc03 )
#FUN-AA0059 --Begin--
             #   CALL cl_init_qry_var()
             #   LET g_qryparam.form = "q_ima"
             #   LET g_qryparam.default1 =  g_bnc[l_ac].bnc03
             #   CALL cl_create_qry() RETURNING g_bnc[l_ac].bnc03
                 CALL q_sel_ima(FALSE, "q_ima", "", g_bnc[l_ac].bnc03, "", "", "", "" ,"",'' )  RETURNING g_bnc[l_ac].bnc03 
#FUN-AA0059 --End--
#                CALL FGL_DIALOG_SETBUFFER( g_bnc[l_ac].bnc03 )
                 DISPLAY BY NAME g_bnc[l_ac].bnc03          #No.MOD-490371
                NEXT FIELD bnc03
             WHEN INFIELD(bnc05) #單位檔
#               CALL q_gfe(10,2,g_bnc[l_ac].bnc05) RETURNING g_bnc[l_ac].bnc05
#               CALL FGL_DIALOG_SETBUFFER( g_bnc[l_ac].bnc05 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.default1 = g_bnc[l_ac].bnc05
                CALL cl_create_qry() RETURNING g_bnc[l_ac].bnc05
#                CALL FGL_DIALOG_SETBUFFER( g_bnc[l_ac].bnc05 )
                 DISPLAY BY NAME g_bnc[l_ac].bnc05          #No.MOD-490371
                NEXT FIELD bnc05
             WHEN INFIELD(bnc07) #幣別檔
#               CALL q_azi(10,2,g_bnc[l_ac].bnc07) RETURNING g_bnc[l_ac].bnc07
#               CALL FGL_DIALOG_SETBUFFER( g_bnc[l_ac].bnc07 )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_azi"
                LET g_qryparam.default1 = g_bnc[l_ac].bnc07
                CALL cl_create_qry() RETURNING g_bnc[l_ac].bnc07
#                CALL FGL_DIALOG_SETBUFFER( g_bnc[l_ac].bnc07 )
                 DISPLAY BY NAME g_bnc[l_ac].bnc07          #No.MOD-490371
                NEXT FIELD bnc07
#FUN-4B0062 add
            WHEN INFIELD(bnc09)
               CALL s_rate(g_bnc[l_ac].bnc07,g_bnc[l_ac].bnc09) RETURNING g_bnc[l_ac].bnc09
               DISPLAY BY NAME g_bnc[l_ac].bnc09
               NEXT FIELD bnc09
##
         END CASE
 
       ON ACTION update_item      #FUN-550077
          IF g_aza.aza44 = "Y" THEN
             CALL GET_FLDBUF(bnc04) RETURNING g_bnc[l_ac].bnc04
            #CALL p_itemname_update("bnc_file","bnc04",g_bnc[l_ac].bnc03,g_bnc[l_ac].bnc04) RETURNING g_bnc[l_ac].bnc04  #TQC-6C0060 mark
             CALL p_itemname_update("bnc_file","bnc04",g_bnc[l_ac].bnc03) #TQC-6C0060
             LET g_on_change=FALSE
            #DISPLAY g_bnc[l_ac].bnc04 TO bnc04  #TQC-6C0060 mark
             CALL cl_show_fld_cont()   #TQC-6C0060 
          END IF
          #FUN-550077
 
#      ON ACTION CONTROLN
#         CALL i020_b_askkey()
#         EXIT INPUT
 
       ON ACTION CONTROLO                        #沿用所有欄位
          IF INFIELD(bnc02) AND l_ac > 1 THEN
             LET g_bnc[l_ac].* = g_bnc[l_ac-1].*
             NEXT FIELD bnc02
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
 
   CLOSE i020_bcl
   COMMIT WORK
   CALL i020_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-CB0018---add---S 
FUNCTION chk_bnc06_put(p_bnc06,p_bnc011,p_bnc012)
DEFINE        
    p_bnc06     LIKE bnc_file.bnc06,
    p_bnc011    LIKE bnc_file.bnc011, 
    p_bnc012    LIKE bnc_file.bnc012, 
    l_inb03     LIKE inb_file.inb03,
    l_inb04     LIKE inb_file.inb04,
    l_inb08     LIKE inb_file.inb08, 
    l_inb09     LIKE inb_file.inb09,
    l_bnc06     LIKE bnc_file.bnc06,
    l_flag      LIKE type_file.chr1,
    l_sfe28     LIKE sfe_file.sfe28,
    l_sfe01     LIKE sfe_file.sfe01,
    l_sfe07     LIKE sfe_file.sfe07,
    l_sfe16     LIKE sfe_file.sfe16,
    l_sfe17     LIKE sfe_file.sfe17,  
    l_ogb03     LIKE ogb_file.ogb03,
    l_ogb04     LIKE ogb_file.ogb04,
    l_ogb05     LIKE ogb_file.ogb05, 
    l_ogb12     LIKE ogb_file.ogb12,
    l_ogb31     LIKE ogb_file.ogb31,
    l_rvv02     LIKE rvv_file.rvv02,
    l_rvv31     LIKE rvv_file.rvv31,
    l_rvv17     LIKE rvv_file.rvv17,
    l_rvv35     LIKE rvv_file.rvv35,
    l_bnc06_qty LIKE bnc_file.bnc06

    LET l_flag=''
    CASE g_bnb.bnb03
       WHEN "1"
             #單據申請數量
             SELECT sfe28,sfe01,sfe07,sfe16,sfe17 INTO l_sfe28,l_sfe01,l_sfe07,l_sfe16,l_sfe17
               FROM sfe_file,ima_file
              WHERE sfe07 = ima01
                AND sfe02 = g_bnc[l_ac].bnc011
                AND sfe28 = g_bnc[l_ac].bnc012
              ORDER BY sfe28
             #已存在單身放行數量
             SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
              WHERE bnc011 = g_bnc[l_ac].bnc011
                AND bnc012 = l_sfe28
                AND bnc01 != g_bnb.bnb01
             IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
             #單身數量不可大於 (單據申請數量-已存在單身放行數量)
             LET l_bnc06_qty = l_sfe16-l_bnc06
             IF (g_bnc[l_ac].bnc06 > l_sfe16-l_bnc06) THEN
                LET l_flag='1'
             END IF
       WHEN "2"
             SELECT ogb03,ogb04,ogb05,ogb12,ogb31
               INTO l_ogb03,l_ogb04,l_ogb05,l_ogb12,l_ogb31
               FROM ogb_file,oga_file
              WHERE ogb01 = g_bnc[l_ac].bnc011
                AND ogb03 = g_bnc[l_ac].bnc012
              ORDER BY ogb03
             SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
              WHERE bnc011 = g_bnc[l_ac].bnc011
                AND bnc012 = l_ogb03
                AND bnc01 != g_bnb.bnb01
             IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
             IF (g_bnc[l_ac].bnc06 > l_ogb12-l_bnc06) THEN
                LET l_flag='1'
             END IF
       WHEN "3"
             SELECT rvv02,rvv31,rvv17,rvv35 INTO l_rvv02,l_rvv31,l_rvv17,l_rvv35
               FROM rvv_file,rvu_file
              WHERE rvv01 = g_bnc[l_ac].bnc011
                AND rvv02 = g_bnc[l_ac].bnc012
              ORDER BY rvv02
             SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
              WHERE bnc011 = g_bnc[l_ac].bnc011
                AND bnc012 = l_rvv02
                AND bnc01 != g_bnb.bnb01
             IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
             IF (g_bnc[l_ac].bnc06 > l_rvv17-l_bnc06) THEN
                LET l_flag='1'
             END IF
       WHEN "4"
             SELECT inb03,inb04,inb08,inb09 INTO l_inb03,l_inb04,l_inb08,l_inb09
               FROM inb_file
              WHERE inb01 = g_bnc[l_ac].bnc011
                AND inb03 = g_bnc[l_ac].bnc012
              ORDER BY inb03
             SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
              WHERE bnc011 = g_bnc[l_ac].bnc011
                AND bnc012 = l_inb03
                AND bnc01 != g_bnb.bnb01
             IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
             IF (g_bnc[l_ac].bnc06 > l_inb09-l_bnc06) THEN
                LET l_flag='1'
             END IF
       WHEN "6"
             SELECT rvv02,rvv31,rvv17,rvv35 INTO l_rvv02,l_rvv31,l_rvv17,l_rvv35
               FROM rvv_file,rvu_file
              WHERE rvv01 = g_bnc[l_ac].bnc011
                AND rvv02 = g_bnc[l_ac].bnc012
              ORDER BY rvv02
             SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
              WHERE bnc011 = g_bnc[l_ac].bnc011
                AND bnc012 = l_rvv02
                AND bnc01 != g_bnb.bnb01
             IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
             IF (g_bnc[l_ac].bnc06 > l_rvv17-l_bnc06) THEN
                LET l_flag='1'
             END IF
       OTHERWISE EXIT CASE
    END CASE
    RETURN l_flag
END FUNCTION
#CHI-CB0018---add---S

#CHI-C30002 -------- add -------- begin
FUNCTION i020_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM bnb_file WHERE bnb01 = g_bnb.bnb01
         INITIALIZE g_bnb.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i020_b_askkey()
DEFINE
     l_wc    LIKE type_file.chr1000 #No.FUN-680062  VARCHAR(600)   
 
   #螢幕上取條件
    #CONSTRUCT l_wc ON bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,bnc08,bnc09,bnc10   #FUN-530046
    CONSTRUCT l_wc ON bnc02,bnc11,bnc03,bnc04,bnc05,bnc06,bnc07,bnc08,bnc09,bnc10   #FUN-530046
                #FROM  s_bnc[1].bnc02,s_bnc[1].bnc03,s_bnc[1].bnc04,   #FUN-530046
                FROM  s_bnc[1].bnc02,s_bnc[1].bnc11,s_bnc[1].bnc03,s_bnc[1].bnc04,   #FUN-530046
                      s_bnc[1].bnc05,s_bnc[1].bnc06,s_bnc[1].bnc07,
                      s_bnc[1].bnc08,s_bnc[1].bnc09,s_bnc[1].bnc10
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(bnc03)
#                CALL q_ima(0,0,g_bnc[1].bnc03) RETURNING g_bnc[1].bnc03
#FUN-AA0059 --Begin--
              #   CALL cl_init_qry_var()
              #   LET g_qryparam.state = "c"
              #   LET g_qryparam.form = "q_ima"
              #   LET g_qryparam.default1 =  g_bnc[1].bnc03
              #   CALL cl_create_qry() RETURNING g_bnc[1].bnc03
                  CALL q_sel_ima( TRUE, "q_ima","",g_bnc[1].bnc03,"","","","","",'')  RETURNING g_bnc[1].bnc03 
#FUN-AA0059 --End--
                  DISPLAY g_bnc[1].bnc03 TO   bnc03          #No.MOD-490371
                 NEXT FIELD bnc03
              WHEN INFIELD(bnc05) #單位檔
#                CALL q_gfe(10,2,g_bnc[1].bnc05) RETURNING g_bnc[1].bnc05
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_bnc[1].bnc05
                 CALL cl_create_qry() RETURNING g_bnc[1].bnc05
                  DISPLAY g_bnc[1].bnc05 TO   bnc05          #No.MOD-490371
                 NEXT FIELD bnc05
              WHEN INFIELD(bnc07) #幣別檔
#                CALL q_azi(10,2,g_bnc[1].bnc07) RETURNING g_bnc[1].bnc07
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_bnc[1].bnc07
                 CALL cl_create_qry() RETURNING g_bnc[1].bnc07
                  DISPLAY g_bnc[1].bnc07 TO   bnc07          #No.MOD-490371
                NEXT FIELD bnc07
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
 
    IF INT_FLAG THEN
       RETURN
    END IF
 
    CALL i020_b_fill(l_wc)
 
END FUNCTION
 
FUNCTION i020_b_fill(p_wc2)              #BODY FILL UP
DEFINE
     p_wc2       LIKE type_file.chr1000,   #NO.FUN-680062  VARCHAR(300)   
     l_factoor   LIKE type_file.num26_10,  #NO.FUN-680062 DECIMAL(16,8) 
     l_cnt       LIKE type_file.num5       #NO.FUN-680062 SMALLINT    
 
    #LET g_sql = "SELECT bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,bnc08,bnc09,bnc10 ",   #FUN-530046
    #FUN-6A0007 (s)
    #LET g_sql = "SELECT bnc02,bnc11,bnc03,bnc04,bnc05,bnc06,bnc07,bnc08,bnc09,bnc10 ",   #FUN-530046
   #TQC-A50023---add---start---
    IF cl_null(p_wc2) THEN
       LET p_wc2 = " 1=1 "
    END IF
   #TQC-A50023---add---end---
    LET g_sql = "SELECT bnc02,bnc11,bnc011,bnc012,bnc03,bnc04, ",
                "       '','',bnc05,bnc06,bnc07,bnc08,bnc09,bnc10 ",   
    #FUN-6A0007 (e)
                #No.FUN-840202 --start--
                ",bncud01,bncud02,bncud03,bncud04,bncud05,",
                "bncud06,bncud07,bncud08,bncud09,bncud10,",
                "bncud11,bncud12,bncud13,bncud14,bncud15", 
                #No.FUN-840202 ---end---
                " FROM bnc_file ",
                " WHERE bnc01 = '",g_bnb.bnb01,"'",
                " AND ", p_wc2 CLIPPED ,
                " ORDER BY bnc02"
 
    PREPARE i020_pb FROM g_sql
    DECLARE bnc_curs                       #SCROLL CURSOR
        CURSOR FOR i020_pb
 
    CALL g_bnc.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
 
    LET l_ac = 1   #CHI-CB0018 add
    FOREACH bnc_curs INTO g_bnc[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #FUN-6A0007 (s)
       SELECT ima021,ima15  INTO g_bnc[g_cnt].ima021, g_bnc[g_cnt].ima15
         FROM ima_file
        WHERE ima01 = g_bnc[g_cnt].bnc03
       IF STATUS THEN
          LET g_bnc[g_cnt].ima021=''
          LET g_bnc[g_cnt].ima15 =''
       END IF
       #FUN-6A0007 (e)
 
       LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_bnc.deleteElement(g_cnt)
 
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i020_bp(p_ud)
    DEFINE   p_ud  LIKE type_file.chr1                #NO.FUN-680062   VARCHAR(1) 
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_bnc TO s_bnc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i020_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL i020_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL i020_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i020_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL i020_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 銷案
      ON ACTION charge_off
         LET g_action_choice="charge_off"
         EXIT DISPLAY
#@    ON ACTION output放行單
      ON ACTION prt_release_order
         LET g_action_choice="prt_release_order"
         EXIT DISPLAY
#@    ON ACTION 列印委外加工申報
      ON ACTION prt_sub_declaration
         LET g_action_choice="prt_sub_declaration"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0003
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-6A0046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY       
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
      ON ACTION controls                       #No.FUN-6B0033
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION i020_m()
 
    IF g_bnb.bnb01 IS NULL OR g_bna06 != '1' THEN
       RETURN
    END IF
 
    INPUT BY NAME g_bnb.bnb13 WITHOUT DEFAULTS
 
    IF INT_FLAG THEN
       LET INT_FLAG=0
       RETURN
    END IF
 
    UPDATE bnb_file SET bnb13 = g_bnb.bnb13
     WHERE bnb01 = g_bnb.bnb01
    IF SQLCA.SQLCODE THEN
#      CALL cl_err('update bnb',SQLCA.SQLCODE,0)  #No.FUN-660052
       CALL cl_err3("upd","bnb_file",g_bnb.bnb01,"",SQLCA.SQLCODE,"","update bnb",1)
    END IF
 
END FUNCTION
 
FUNCTION i020_put1()
DEFINE
    l_maxac  LIKE  type_file.num5,                    #NO.FUN-680062   SMALLINT 
    l_n      LIKE  type_file.num5,                     #NO.FUN-680062   SMALLINT   
    l_sql    LIKE  type_file.chr1000,                  #NO.FUN-680062   VARCHAR(300) 
   l_pmn01         LIKE pmn_file.pmn01,         
   l_ima02         LIKE ima_file.ima02,
   l_sfp04         LIKE sfp_file.sfp04,  #
   l_sfs02         LIKE sfs_file.sfs02,  #
   l_sfs03         LIKE sfs_file.sfs03,  #
   l_sfs04         LIKE sfs_file.sfs04,
   l_sfs05         LIKE sfs_file.sfs05,
   l_sfs06         LIKE sfs_file.sfs06,  #CHI-CB0018 add ,
   bnc06_qty       LIKE bnc_file.bnc06,  #CHI-CB0018 add----S
   l_bnc06         LIKE bnc_file.bnc06,
   l_bnc02         LIKE bnc_file.bnc02   #CHI-CB0018 add----E
 
   IF cl_null(l_n) THEN
      LET l_n = 0
   END IF
 
   LET l_sfp04 = ''
 
   SELECT sfp04 INTO l_sfp04 FROM sfp_file WHERE sfp01 = g_bnb.bnb04
		  
#FUN-6A0007...............begin
#  #IF l_sfp04 = 'N' OR l_sfp04 = 'X' THEN     #未扣帳 #FUN-660106
#   IF l_sfp04 = 'N' THEN     #未扣帳  #FUN-660106
#      SELECT COUNT(*) INTO l_n FROM sfs_file WHERE sfs01 = g_bnb.bnb04
#   ELSE
#      SELECT COUNT(*) INTO l_n FROM sfe_file WHERE sfe02 = g_bnb.bnb04
#   END IF
   IF l_sfp04 = 'N' THEN     #未扣帳
      IF g_bnb.bnb19 = 'Y' THEN
         SELECT COUNT(*) INTO l_n
           FROM sfs_file ,ima_file
          WHERE sfs04= ima01
            AND ima15= 'Y'
            AND sfs01 = g_bnb.bnb04
      ELSE
         #-----MOD-920165---------
         #FUN-6A0007--(S)
         #        =N時，須卡單身的資料須為非保稅品
          SELECT COUNT(*) INTO l_n
            FROM sfs_file
           WHERE sfs01 = g_bnb.bnb04
         #SELECT COUNT(*) INTO l_n
         #  FROM sfs_file ,ima_file
         # WHERE sfs04= ima01
         #   AND ima15= 'N'
         #   AND sfs01 = g_bnb.bnb04
         #FUN-6A0007--(E)
         #-----END MOD-920165-----
      END IF
   ELSE
      IF g_bnb.bnb19 = 'Y' THEN
         SELECT COUNT(*) INTO l_n
           FROM sfe_file,ima_file
          WHERE sfe07 = ima01
            AND ima15 = 'Y'
            AND sfe02 = g_bnb.bnb04
      ELSE
         #-----MOD-920165---------
         #FUN-6A0007--(S)
         #        =N時，須卡單身的資料須為非保稅品
          SELECT COUNT(*) INTO l_n
            FROM sfe_file
           WHERE sfe02 = g_bnb.bnb04
         #SELECT COUNT(*) INTO l_n
         #  FROM sfe_file,ima_file
         # WHERE sfe07 = ima01
         #   AND ima15 = 'N'
         #   AND sfe02 = g_bnb.bnb04
         #FUN-6A0007--(E)
         #-----END MOD-920165-----
      END IF
   END IF			  
#FUN-6A0007...............end
 
   IF l_n < 1 THEN
      CALL cl_err('','abx-001',0)
      RETURN
   END IF
 
   #FUN-6A0007 (s)
   {
   IF l_sfp04 = 'N' THEN
      LET l_sql = "SELECT sfs02,sfs03,sfs04,sfs05,sfs06 FROM sfs_file ",
                  " WHERE sfs01='",g_bnb.bnb04,"'",
                  " ORDER BY sfs02"
   ELSE
      LET l_sql = "SELECT sfe28,sfe01,sfe07,sfe16,sfe17 FROM sfe_file ",
                  " WHERE sfe02='",g_bnb.bnb04,"'",
                  " ORDER BY sfe28"
   END IF
   }
   IF l_sfp04 = 'N' THEN
      LET l_sql = "SELECT sfs02,sfs03,sfs04,sfs05,sfs06 ",
                  "  FROM sfs_file,ima_file ",
                  " WHERE sfs04= ima01 ",
                  "   AND sfs01='",g_bnb.bnb04,"'"
      IF g_bnb.bnb19 = 'Y' THEN
         LET l_sql = l_sql CLIPPED , " AND ima15= 'Y' "
      END IF
      #-----MOD-920165---------
      ##FUN-6A0007--(S)
      ##        =N時，須卡單身的資料須為非保稅品
      #IF g_bnb.bnb19 = 'N' THEN
      #   LET l_sql = l_sql CLIPPED , " AND ima15= 'N' "
      #END IF
      ##FUN-6A0007--(E)
      #-----END MOD-920165-----
      LET l_sql = l_sql CLIPPED , " ORDER BY sfs02"
   ELSE
      LET l_sql = "SELECT sfe28,sfe01,sfe07,sfe16,sfe17 ",
                  "  FROM sfe_file,ima_file ",
                  " WHERE sfe07 = ima01 ",
                  "   AND sfe02= '",g_bnb.bnb04,"'"
      IF g_bnb.bnb19 = 'Y' THEN
         LET l_sql = l_sql CLIPPED , " AND ima15= 'Y' "
      END IF
      #-----MOD-920165---------
      ##FUN-6A0007--(S)
      ##        =N時，須卡單身的資料須為非保稅品
      #IF g_bnb.bnb19 = 'N' THEN
      #   LET l_sql = l_sql CLIPPED , " AND ima15= 'N' "
      #END IF
      ##FUN-6A0007--(E)
      #-----END MOD-920165-----
      LET l_sql = l_sql CLIPPED , " ORDER BY sfe28"
   END IF
   #FUN-6A0007 (e)
 
   PREPARE i020_put_pre FROM l_sql
 
   DECLARE i020_put1 CURSOR FOR i020_put_pre
 
   SELECT max(bnc02)+1 INTO l_ac FROM bnc_file WHERE bnc01 = g_bnb.bnb01
 
   IF cl_null(l_ac) THEN
      LET l_ac = 1
   END IF
 
   LET l_bnc02 = 0  #CHI-CB0018 add
   FOREACH i020_put1 INTO l_sfs02,l_sfs03,l_sfs04,l_sfs05,l_sfs06
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #FUN-6A0007 (s)
      LET l_n = 0
      SELECT count(*) INTO l_n FROM bnc_file
       WHERE bnc011 = g_bnb.bnb04
         AND bnc012 = l_sfs02
      #單據號碼已產生過
      IF l_n > 0 THEN
        #CHI-CB0018---add---S
         LET bnc06_qty = 0
         LET l_bnc06 = 0
         #目前數量
         SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
          WHERE bnc011 = g_bnb.bnb04
            AND bnc012 = l_sfs02
         IF cl_null(l_sfs05) THEN LET l_sfs05 = 0 END IF
         IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
         LET bnc06_qty = l_sfs05 - l_bnc06
         IF bnc06_qty > 0 THEN
            LET l_bnc02 = l_bnc02+1
         ELSE
        #CHI-CB0018---add---E
            CONTINUE FOREACH
     #CHI-CB0018---add---S
         END IF
      ELSE
      #單據號碼未產生過
         LET l_bnc02 = l_bnc02+1
     #CHI-CB0018---add---E
      END IF
      #FUN-6A0007 (e)
 
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_sfs04
 
      IF STATUS OR cl_null(l_ima02) THEN
         LET l_ima02 = ' '
      END IF

     #CHI-CB0018---add---S
      IF l_n > 0 THEN
         LET bnc06_qty = bnc06_qty
      ELSE
         LET bnc06_qty = l_sfs05
      END IF
     #CHI-CB0018---add---E

      #FUN-6A0007 (s)
      # add bnc011,bnc012 
       INSERT INTO bnc_file(bnc01,bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,  #No.MOD-470041
                           #bnc08,bnc09,bnc10)   #FUN-530046
                           bnc08,bnc09,bnc10,bnc11,bnc011,bnc012,   #FUN-530046
                           bncplant,bnclegal)   #FUN-980001
          #VALUES(g_bnb.bnb01,l_sfs02,l_sfs04,l_ima02,l_sfs06,l_sfs05,      #CHI-CB0018 mark 
           VALUES(g_bnb.bnb01,l_bnc02,l_sfs04,l_ima02,l_sfs06,bnc06_qty,    #CHI-CB0018
                  #g_aza.aza17,0,0,0)   #FUN-530046
                #------------No.TQC-690045 modify
                 #g_aza.aza17,0,0,0,g_bnb.bnb16,g_bnb.bnb04,l_sfs02)   #FUN-530046
                  g_aza.aza17,0,0,0,l_sfs03,g_bnb.bnb04,l_sfs02,   #FUN-530046
                #------------No.TQC-690045 end
                  g_plant,g_legal)   #FUN-980001
      #FUN-6A0007 (e) 
      IF STATUS = 0 THEN
         LET l_ac = l_ac + 1
      END IF
   END FOREACH
 
   SELECT pmn01 INTO l_pmn01 FROM pmn_file
    WHERE pmn41 = l_sfs03
 
   SELECT pmm09,pmc03,pmc091 INTO g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07
     FROM pmm_file ,OUTER pmc_file
    WHERE pmm01 = l_pmn01
      AND pmc_file.pmc01=pmm_file.pmm09
      AND pmm18 !='X'
 
   DISPLAY BY NAME g_bnb.bnb05,g_bnb.bnb06,g_bnb.bnb07
 
END FUNCTION
 
FUNCTION i020_put2()
DEFINE
   l_maxac         LIKE  type_file.num5,                  #NO.FUN-680062    SMALLINT
   l_total         LIKE ogb_file.ogb13, #MOD-530213
   l_oga03         LIKE oga_file.oga03,
   l_oga23         LIKE oga_file.oga23,
   l_oga24         LIKE oga_file.oga24,
   l_ogb03         LIKE ogb_file.ogb03,
   l_ogb04         LIKE ogb_file.ogb04,
   l_ogb05         LIKE ogb_file.ogb05,
   l_ogb06         LIKE ogb_file.ogb06,
   l_ogb12         LIKE ogb_file.ogb12,
   l_ogb13         LIKE ogb_file.ogb13,
   l_ogb31         LIKE ogb_file.ogb31,      #No.TQC-690045 add
   l_ogb917        LIKE ogb_file.ogb917,     #CHI-B70039 add
   l_sql           STRING,                   #FUN-6A0007  #CHI-CB0018 add ,
   bnc06_qty       LIKE bnc_file.bnc06,      #CHI-CB0018 add---S
   l_bnc06         LIKE bnc_file.bnc06,
   l_bnc02         LIKE bnc_file.bnc02       #CHI-CB0018 add---E
 
   IF cl_null(l_n) THEN
      LET l_n = 0
   END IF
   #FUN-6A0007 (s)
   #SELECT COUNT(*) INTO l_n FROM ogb_file,OUTER oga_file
   # WHERE ogb01=g_bnb.bnb04
   #   AND oga_file.oga01=ogb01
   IF g_bnb.bnb19 = 'Y' THEN
      SELECT COUNT(*) INTO l_n
        FROM ogb_file,oga_file ,ima_file
    WHERE ogb01=g_bnb.bnb04
      AND oga_file.oga01=ogb01
         AND ogb_file.ogb04=ima_file.ima01
         AND ima15='Y'
   ELSE
      #-----MOD-920165---------
      #FUN-6A0007--(S)
      #        =N時，須卡單身的資料須為非保稅品
      SELECT COUNT(*) INTO l_n
        FROM ogb_file,oga_file
       WHERE ogb01=g_bnb.bnb04
         AND oga_file.oga01=ogb01
      #SELECT COUNT(*) INTO l_n
      #  FROM ogb_file,oga_file ,ima_file
      # WHERE ogb01=g_bnb.bnb04
      #   AND oga_file.oga01=ogb01
      #   AND ogb_file.ogb04=ima_file.ima01
      #   AND ima15='N'
      #FUN-6A0007--(E)
      #-----END MOD-920165-----
   END IF
   #FUN-6A0007 (e)
 
   IF l_n < 1 THEN
      CALL cl_err('4','abx-002',0)
      RETURN
   END IF
 
   #FUN-6A0007 (s)
   
   #DECLARE i020_put2 CURSOR FOR
   # SELECT oga23,oga24,ogb03,ogb04,ogb05,ogb06,ogb12,ogb13
   #   FROM ogb_file,OUTER oga_file
   #  WHERE ogb01=g_bnb.bnb04
   #    AND oga_file.oga01=ogb01
   #  ORDER BY oga23
 
  #------------No.TQC-690045 modify
  #LET l_sql = "  SELECT oga23,oga24,ogb03,ogb04,ogb05,ogb06,ogb12,ogb13  ",
   LET l_sql = "  SELECT oga23,oga24,ogb03,ogb04,ogb05,ogb06,ogb12,ogb13,ogb31  ",
  #------------No.TQC-690045 end
               "    ,ogb917 ",   #CHI-B70039 add
               "    FROM ogb_file, oga_file,ima_file ",
               "   WHERE ogb01='",g_bnb.bnb04,"' ",
               "     AND oga_file.oga01=ogb01 ",
               "     AND ogb_file.ogb04=ima_file.ima01 "
   IF g_bnb.bnb19 = 'Y' THEN
      LET l_sql = l_sql CLIPPED, " AND ima15='Y' "
   END IF
   #-----MOD-920165---------
   ##FUN-6A0007--(S)
   ##        =N時，須卡單身的資料須為非保稅品
   #IF g_bnb.bnb19 = 'N' THEN
   #   LET l_sql = l_sql CLIPPED, " AND ima15='N' "
   #END IF
   ##FUN-6A0007--(E)
   #-----END MOD-920165-----
   LET l_sql = l_sql CLIPPED, " ORDER BY oga23 "
 
   PREPARE i020_put2_p FROM l_sql
   DECLARE i020_put2 CURSOR FOR i020_put2_p
 
   #FUN-6A0007 (e)
 
 
   SELECT max(bnc02)+1 INTO l_ac FROM bnc_file WHERE bnc01 = g_bnb.bnb01
 
   IF cl_null(l_ac) THEN
      LET l_ac = 1
   END IF
 
   IF cl_null(l_total) THEN
      LET l_total = 0
   END IF
 
   LET l_bnc02 = 0  #CHI-CB0018 add
   FOREACH i020_put2 INTO l_oga23,l_oga24,l_ogb03,l_ogb04,l_ogb05,
                         l_ogb06,l_ogb12,l_ogb13
                         ,l_ogb31,l_ogb917         #CHI-B70039 add
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
      END IF
      #FUN-6A0007 (s)
      LET l_n = 0
      SELECT count(*) INTO l_n FROM bnc_file
       WHERE bnc011 = g_bnb.bnb04
         AND bnc012 = l_ogb03
      IF l_n > 0 THEN
        #CHI-CB0018---add---S
         LET bnc06_qty = 0
         LET l_bnc06 = 0
         #目前數量
         SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
          WHERE bnc011 = g_bnb.bnb04
            AND bnc012 = l_ogb03
         IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
         IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
         LET bnc06_qty = l_ogb12 - l_bnc06
         IF bnc06_qty > 0 THEN
            LET l_bnc02 = l_bnc02+1
         ELSE
        #CHI-CB0018---add---E
            CONTINUE FOREACH
     #CHI-CB0018---add---S
         END IF
      ELSE
         LET l_bnc02 = l_bnc02+1
     #CHI-CB0018---add---E
      END IF
      #FUN-6A0007 (e)
 
      IF cl_null(l_ogb13) THEN
         LET l_ogb13 = 0
      END IF
 
#     LET l_total = l_ogb12*l_ogb13*l_oga24    #CHI-B70039 mark
      LET l_total = l_ogb917*l_ogb13*l_oga24   #CHI-B70039
 
      IF cl_null(l_total) THEN
         LET l_total = 0
      END IF
 
     #CHI-CB0018---add---S
      IF l_n > 0 THEN
         LET bnc06_qty = bnc06_qty
      ELSE
         LET bnc06_qty = l_ogb12
      END IF
     #CHI-CB0018---add---E

      #FUN-6A0007 (s)
      # add bnc011,bnc012
       INSERT INTO bnc_file(bnc01,bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,  #No.MOD-470041
                           #bnc08,bnc09,bnc10)   #FUN-530046
                           bnc08,bnc09,bnc10,bnc11,bnc011,bnc012,   #FUN-530046
                           bncplant,bnclegal)   #FUN-980001
          #VALUES(g_bnb.bnb01,l_ogb03,l_ogb04,l_ogb06,l_ogb05,l_ogb12,     #CHI-CB0018 mark
           VALUES(g_bnb.bnb01,l_bnc02,l_ogb04,l_ogb06,l_ogb05,bnc06_qty,   #CHI-CB0018
                  #l_oga23,l_ogb13,l_oga24,l_total)   #FUN-530046
                 #----------------No.TQC-690045 modify
                 #l_oga23,l_ogb13,l_oga24,l_total,g_bnb.bnb16,
                  l_oga23,l_ogb13,l_oga24,l_total,l_ogb31,
                 #----------------No.TQC-690045 end
                  g_bnb.bnb04,l_ogb03,   #FUN-530046
                  g_plant,g_legal)   #FUN-980001
      #FUN-6A0007 (e)
      IF STATUS = 0  THEN
         LET l_ac = l_ac + 1
      END IF
   END FOREACH
 
END FUNCTION
 
#FUN-6A0007 (s)
#{
#FUNCTION i020_put3()
#DEFINE
#    l_maxac        LIKE type_file.num5,                  #NO.FUN-680062  SMALLINT   
#   l_ima02         LIKE ima_file.ima02,
#   l_rvh02         LIKE rvh_file.rvh02,  #
#   l_rvh04         LIKE rvh_file.rvh04,  #
#   l_rvh15         LIKE rvh_file.rvh15,  #
#   l_rvh16         LIKE rvh_file.rvh16,  #
#   l_rvh071        LIKE rvh_file.rvh071   #
# 
#   IF cl_null(l_n) THEN
#      LET l_n = 0
#   END IF
# 
#   SELECT COUNT(*) INTO l_n FROM rvh_file
#    WHERE rvh01=g_bnb.bnb04
# 
#   IF l_n < 1 THEN
#      CALL cl_err('','abx-003',0)
#      RETURN
#   END IF
# 
#   DECLARE i020_put3 CURSOR FOR
#    SELECT rvh02,rvh04,rvh15,rvh16,rvh071 FROM rvh_file
#     WHERE rvh01=g_bnb.bnb04
#     ORDER BY rvh02
# 
#   SELECT max(bnc02)+1 INTO l_ac FROM bnc_file WHERE bnc01 = g_bnb.bnb01
# 
#   IF cl_null(l_ac) THEN
#      LET l_ac = 1
#   END IF
# 
#   FOREACH i020_put3 INTO l_rvh02,l_rvh04,l_rvh15,l_rvh16,l_rvh071
#      IF SQLCA.sqlcode THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)
#         LET g_success = 'N'
#         EXIT FOREACH
#      END IF
# 
#      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_rvh04
# 
#      IF STATUS OR cl_null(l_ima02) THEN
#         LET l_ima02 = ' '
#      END IF
# 
#      IF cl_null(l_rvh071) THEN
#         LET l_rvh071 = 0
#      END IF
# 
#       INSERT INTO bnc_file(bnc01,bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,  #No.MOD-470041
#                           #bnc08,bnc09,bnc10)   #FUN-530046
#                           bnc08,bnc09,bnc10,bnc11,   #FUN-530046
#                           bncplant,bnclegal)   #FUN-980001
#           VALUES(g_bnb.bnb01,l_rvh02,l_rvh04,l_ima02,l_rvh16,l_rvh15,
#                  #g_aza.aza17,l_rvh071,1,l_rvh071)   #FUN-530046
#                  g_aza.aza17,l_rvh071,1,l_rvh071,g_bnb.bnb16,   #FUN-530046
#                  g_plant,g_legal)   #FUN-980001
#      IF STATUS = 0  THEN
#         LET l_ac = l_ac + 1
#      END IF
#   END FOREACH
# 
#END FUNCTION
#}

FUNCTION i020_put3()
DEFINE
   l_sql           STRING,
   l_maxac         LIKE type_file.num5,
   l_ima02         LIKE ima_file.ima02,
   l_rvv02         LIKE rvv_file.rvv02,  #項次
   l_rvv31         LIKE rvv_file.rvv31,  #料件編號
   l_rvv17         LIKE rvv_file.rvv17,  #退貨數量
   l_rvv35         LIKE rvv_file.rvv35,  #退貨單位
   l_rvv38         LIKE rvv_file.rvv38,  #退貨扣款原幣單價
   l_pmm22         LIKE pmm_file.pmm22,  #幣別
   l_rvu03         LIKE rvu_file.rvu03,  #異動入期(入庫)
   l_rate          LIKE oha_file.oha24,  #匯率
   l_bnc10         LIKE bnc_file.bnc10,  #CHI-CB0018 add ,
   bnc06_qty       LIKE bnc_file.bnc06,  #CHI-CB0018 add----S
   l_bnc06         LIKE bnc_file.bnc06,
   l_bnc02         LIKE bnc_file.bnc02   #CHI-CB0018 add----E
 
   IF cl_null(l_n) THEN
      LET l_n = 0
   END IF
 
   IF g_bnb.bnb19 = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM rvv_file,ima_file
       WHERE rvv01=g_bnb.bnb04
         AND rvv03='2'
         AND rvv31=ima01
         AND ima15='Y'
   ELSE  
      #-----MOD-920165---------
      #FUN-6A0007--(S)
      #        =N時，須卡單身的資料須為非保稅品
      SELECT COUNT(*) INTO l_n FROM rvv_file
       WHERE rvv01=g_bnb.bnb04
         AND rvv03='2'
      #SELECT COUNT(*) INTO l_n FROM rvv_file,ima_file
      # WHERE rvv01=g_bnb.bnb04
      #   AND rvv03='2'
      #   AND rvv31=ima01
      #   AND ima15='N'
      #FUN-6A0007--(E)
      #-----END MOD-920165-----
   END IF
   IF l_n < 1 THEN CALL cl_err('','abx-061',0) RETURN END IF
 
   LET l_sql = "  SELECT rvv02,rvv31,rvv17,rvv35,rvv38,pmm22,rvu03  ",
               "    FROM rvv_file ,rvu_file,pmm_file,ima_file ",
               "   WHERE rvv01= '",g_bnb.bnb04,"' ",
               "     AND rvv03='2' ",
               "     AND rvv01=rvu01 ",
               "     AND rvv36=pmm01 ",
               "     AND rvuconf='Y' ",
               "     AND rvv31=ima01 "
   IF g_bnb.bnb19 = 'Y' THEN
      LET l_sql = l_sql CLIPPED, " AND ima15='Y' "
   END IF
 
   #-----MOD-920165---------
   ##FUN-6A0007--(S)
   ##        =N時，須卡單身的資料須為非保稅品
   #IF g_bnb.bnb19 = 'N' THEN
   #   LET l_sql = l_sql CLIPPED, " AND ima15='N' "
   #END IF
   ##FUN-6A0007--(E)
   #-----END MOD-920165-----
   LET l_sql = l_sql CLIPPED, " ORDER BY rvv02 "
 
   PREPARE i020_put3_p FROM l_sql
   DECLARE i020_put3 CURSOR FOR i020_put3_p
 
   #放行單單身
   SELECT max(bnc02)+1 INTO l_ac FROM bnc_file WHERE bnc01 = g_bnb.bnb01
   IF cl_null(l_ac) THEN LET l_ac = 1 END IF
 
   LET l_bnc02 = 0  #CHI-CB0018 add
   FOREACH i020_put3 INTO l_rvv02,l_rvv31,l_rvv17,l_rvv35,l_rvv38,
                          l_pmm22,l_rvu03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #FUN-6A0007 (s)
      LET l_n = 0
      SELECT count(*) INTO l_n FROM bnc_file
       WHERE bnc011 = g_bnb.bnb04
         AND bnc012 = l_rvv02
      IF l_n > 0 THEN
        #CHI-CB0018---add---S
         LET bnc06_qty = 0
         LET l_bnc06 = 0
         #目前數量
         SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
          WHERE bnc011 = g_bnb.bnb04
            AND bnc012 = l_rvv02
         IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF
         IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
         LET bnc06_qty = l_rvv17 - l_bnc06
         IF bnc06_qty > 0 THEN
            LET l_bnc02 = l_bnc02+1
         ELSE
        #CHI-CB0018---add---E
            CONTINUE FOREACH
     #CHI-CB0018---add---S
         END IF
      ELSE
         LET l_bnc02 = l_bnc02+1
     #CHI-CB0018---add---E
      END IF
      #FUN-6A0007 (e)
 
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_rvv31
      IF STATUS OR cl_null(l_ima02) THEN LET l_ima02 = ' ' END IF
 
      IF cl_null(l_rvv38) THEN LET l_rvv38 = 0 END IF
 
      CALL s_curr3(l_pmm22,l_rvu03,'D') RETURNING l_rate
      LET l_bnc10 =  cl_digcut(l_rvv38 * l_rate,g_azi04)

     #CHI-CB0018---add---S
      IF l_n > 0 THEN
         LET bnc06_qty = bnc06_qty
      ELSE
         LET bnc06_qty = l_rvv17
      END IF
     #CHI-CB0018---add---E
 
      INSERT INTO bnc_file(bnc01,bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,
                           bnc08,bnc09,bnc10,bnc011,bnc012,
                           bncplant,bnclegal)   #FUN-980001
          #VALUES(g_bnb.bnb01,l_rvv02,l_rvv31,l_ima02,l_rvv35,l_rvv17,     #CHI-CB0018 mark
           VALUES(g_bnb.bnb01,l_bnc02,l_rvv31,l_ima02,l_rvv35,bnc06_qty,   #CHI-CB0018
                  g_aza.aza17,l_rvv38,l_rate,l_bnc10,g_bnb.bnb04,l_rvv02,
                  g_plant,g_legal)   #FUN-980001
      IF STATUS = 0  THEN LET l_ac = l_ac + 1 END IF
   END FOREACH
 
END FUNCTION
 
#FUN-6A0007 (e)
 
FUNCTION i020_put4()
DEFINE
    l_maxac        LIKE type_file.num5,  #No.FUN-680062 SMALLINT
   l_ima02         LIKE ima_file.ima02,
   l_inb03         LIKE inb_file.inb03,  #
   l_inb04         LIKE inb_file.inb04,  #
   l_inb08         LIKE inb_file.inb08,  #
   l_sql           STRING,               #FUN-6A0007
   l_inb09         LIKE inb_file.inb09,  #CHI-CB0018 add ,
   bnc06_qty       LIKE bnc_file.bnc06,  #CHI-CB0018 add----S
   l_bnc06         LIKE bnc_file.bnc06,
   l_bnc02         LIKE bnc_file.bnc02   #CHI-CB0018 add----E
 
   IF cl_null(l_n) THEN
      LET l_n = 0
   END IF
 
   #FUN-6A0007 (s)
   #SELECT COUNT(*) INTO l_n FROM inb_file
   # WHERE inb01=g_bnb.bnb04
 
   IF g_bnb.bnb19 = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM inb_file,ima_file
    WHERE inb01=g_bnb.bnb04
         AND inb04=ima01
         AND ima15='Y'
   ELSE
      #-----MOD-920165---------
      #FUN-6A0007--(S)
      #        =N時，須卡單身的資料須為非保稅品
      SELECT COUNT(*) INTO l_n FROM inb_file
       WHERE inb01=g_bnb.bnb04
      #SELECT COUNT(*) INTO l_n FROM inb_file,ima_file
      # WHERE inb01=g_bnb.bnb04
      #   AND inb04=ima01
      #   AND ima15='N'
      #FUN-6A0007--(E)
      #-----END MOD-920165-----
   END IF
   #FUN-6A0007 (e)
 
   IF l_n < 1 THEN
      CALL cl_err('','abx-004',0)
      RETURN
   END IF
 
   #FUN-6A0007 (s)
   #DECLARE i020_put4 CURSOR FOR
   # SELECT inb03,inb04,inb08,inb09 FROM inb_file
   #  WHERE inb01=g_bnb.bnb04
   #  ORDER BY inb03
 
   LET l_sql = "  SELECT inb03,inb04,inb08,inb09 ",
               "    FROM inb_file ,ima_file ",
               "   WHERE inb01= '",g_bnb.bnb04,"'",
               "     AND inb04=ima01 "
   IF g_bnb.bnb19 = 'Y' THEN
      LET l_sql = l_sql CLIPPED, " AND ima15='Y' "
   END IF
   #-----MOD-920165---------
   ##FUN-6A0007--(S)
   ##        =N時，須卡單身的資料須為非保稅品
   #IF g_bnb.bnb19 = 'N' THEN
   #   LET l_sql = l_sql CLIPPED, " AND ima15='N' "
   #END IF
   ##FUN-6A0007--(E)
   #-----END MOD-920165-----
 
   LET l_sql = l_sql CLIPPED, " ORDER BY inb03 "
 
   PREPARE i020_put4_p FROM l_sql
   DECLARE i020_put4 CURSOR FOR i020_put4_p
   #FUN-6A0007 (e)
 
   SELECT max(bnc02)+1 INTO l_ac FROM bnc_file WHERE bnc01 = g_bnb.bnb01
 
   IF cl_null(l_ac) THEN
      LET l_ac = 1
   END IF

   LET l_bnc02 = 0  #CHI-CB0018 add 
   FOREACH i020_put4 INTO l_inb03,l_inb04,l_inb08,l_inb09
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #FUN-6A0007 (s)
      LET l_n = 0
      SELECT count(*) INTO l_n FROM bnc_file
       WHERE bnc011 = g_bnb.bnb04
         AND bnc012 = l_inb03
      IF l_n > 0 THEN
        #CHI-CB0018---add---S
         LET bnc06_qty = 0
         LET l_bnc06 = 0
         #目前數量
         SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
          WHERE bnc011 = g_bnb.bnb04
            AND bnc012 = l_inb03
         IF cl_null(l_inb09) THEN LET l_inb09 = 0 END IF
         IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
         LET bnc06_qty = l_inb09 - l_bnc06
         IF bnc06_qty > 0 THEN
            LET l_bnc02 = l_bnc02+1
         ELSE
        #CHI-CB0018---add---E
            CONTINUE FOREACH
     #CHI-CB0018---add---S
         END IF
      ELSE
         LET l_bnc02 = l_bnc02+1
     #CHI-CB0018---add---E
      END IF
      #FUN-6A0007 (e)
 
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_inb04
 
      IF STATUS OR cl_null(l_ima02) THEN
         LET l_ima02 = ' '
      END IF
     #CHI-CB0018---add---S
      IF l_n > 0 THEN
         LET bnc06_qty = bnc06_qty
      ELSE
         LET bnc06_qty = l_inb09
      END IF
     #CHI-CB0018---add---E
      #FUN-6A0007 (s)
      # add bnc011,bnc012
       INSERT INTO bnc_file(bnc01,bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,  #No.MOD-470041
                           #bnc08,bnc09,bnc10)   #FUN-530046
                           bnc08,bnc09,bnc10,bnc11,bnc011,bnc012,   #FUN-530046
                           bncplant,bnclegal)   #FUN-980001
          #VALUES(g_bnb.bnb01,l_inb03,l_inb04,l_ima02,l_inb08,l_inb09,    #CHI-CB0018 mark
           VALUES(g_bnb.bnb01,l_bnc02,l_inb04,l_ima02,l_inb08,bnc06_qty,  #CHI-CB0018
                  #g_aza.aza17,0,0,0)   #FUN-530046
                  g_aza.aza17,0,0,0,g_bnb.bnb16,
                  g_bnb.bnb04,l_inb03,   #FUN-530046
                  g_plant,g_legal)   #FUN-980001
      #FUN-6A0007 (e)
      IF STATUS = 0  THEN
         LET l_ac = l_ac + 1
      END IF
   END FOREACH
 
END FUNCTION
 
#FUN-6A0007 (s)
FUNCTION i020_put6()
DEFINE
   l_sql           STRING,
   l_maxac         LIKE type_file.num5,
   l_ima02         LIKE ima_file.ima02,
   l_rvv02         LIKE rvv_file.rvv02,  #項次
   l_rvv31         LIKE rvv_file.rvv31,  #料件編號
   l_rvv17         LIKE rvv_file.rvv17,  #退貨數量
   l_rvv35         LIKE rvv_file.rvv35,  #退貨單位
   l_rvv38         LIKE rvv_file.rvv38,  #退貨扣款原幣單價
   l_pmm22         LIKE pmm_file.pmm22,  #幣別
   l_rvu03         LIKE rvu_file.rvu03,  #異動入期(入庫)
   l_rate          LIKE oha_file.oha24,  #匯率
   l_bnc10         LIKE bnc_file.bnc10,  #CHI-CB0018 add ,
   bnc06_qty       LIKE bnc_file.bnc06,  #CHI-CB0018 add----S
   l_bnc06         LIKE bnc_file.bnc06,
   l_bnc02         LIKE bnc_file.bnc02   #CHI-CB0018 add----E
 
   IF cl_null(l_n) THEN
      LET l_n = 0
   END IF
 
   IF g_bnb.bnb19 = 'Y' THEN
      SELECT COUNT(*) INTO l_n FROM rvv_file,ima_file
       WHERE rvv01=g_bnb.bnb04
         AND rvv03='3'
         AND rvv31=ima01
         AND ima15='Y'
   ELSE
      #-----MOD-920165---------
      #FUN-6A0007--(S)
      #        =N時，須卡單身的資料須為非保稅品
      SELECT COUNT(*) INTO l_n FROM rvv_file
       WHERE rvv01=g_bnb.bnb04
         AND rvv03='3'
      #SELECT COUNT(*) INTO l_n FROM rvv_file,ima_file
      # WHERE rvv01=g_bnb.bnb04
      #   AND rvv03='3'
      #   AND rvv31=ima01
      #   AND ima15='N'
      #FUN-6A0007--(E)
      #-----END MOD-920165-----
   END IF
    
   IF l_n < 1 THEN CALL cl_err('','abx-061',0) RETURN END IF
 
   LET l_sql = "  SELECT rvv02,rvv31,rvv17,rvv35,rvv38,pmm22,rvu03  ",
              #"    FROM rvv_file ,rvu_file,pmm_file,ima_file ",                          #MOD-AC0240 mark     
               "    FROM rvv_file LEFT OUTER JOIN pmm_file ON pmm01 = rvv_file.rvv36 ",   #MOD-AC0240 add
               "         ,rvu_file,ima_file ",                                            #MOD-AC0240 add 
               "   WHERE rvv01= '",g_bnb.bnb04,"' ",
               "     AND rvv03='3' ",
               "     AND rvv01=rvu01 ",
              #"     AND rvv36=pmm01 ",          #MOD-AC0240 mark
               "     AND rvuconf='Y' ",
               "     AND rvv31=ima01 "
   IF g_bnb.bnb19 = 'Y' THEN
      LET l_sql = l_sql CLIPPED, " AND ima15='Y' "
   END IF
 
   #-----MOD-920165---------
   ##FUN-6A0007--(S)
   ##        =N時，須卡單身的資料須為非保稅品
   #IF g_bnb.bnb19 = 'N' THEN
   #   LET l_sql = l_sql CLIPPED, " AND ima15='N' "
   #END IF
   ##FUN-6A0007--(E)
   #-----END MOD-920165-----
 
   LET l_sql = l_sql CLIPPED, " ORDER BY rvv02 "
 
   PREPARE i020_put6_p FROM l_sql
   DECLARE i020_put6 CURSOR FOR i020_put6_p
 
   #放行單單身
   SELECT max(bnc02)+1 INTO l_ac FROM bnc_file WHERE bnc01 = g_bnb.bnb01
   IF cl_null(l_ac) THEN LET l_ac = 1 END IF
 
   LET l_bnc02 = 0  #CHI-CB0018 add
   FOREACH i020_put6 INTO l_rvv02,l_rvv31,l_rvv17,l_rvv35,l_rvv38,
                          l_pmm22,l_rvu03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      #FUN-6A0007 (s)
      LET l_n = 0
      SELECT count(*) INTO l_n FROM bnc_file
       WHERE bnc011 = g_bnb.bnb04
         AND bnc012 = l_rvv02
      IF l_n > 0 THEN
        #CHI-CB0018---add---S
         LET bnc06_qty = 0
         LET l_bnc06 = 0 
         #目前數量
         SELECT SUM(bnc06) INTO l_bnc06 FROM bnc_file
          WHERE bnc011 = g_bnb.bnb04
            AND bnc012 = l_rvv02
         IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF
         IF cl_null(l_bnc06) THEN LET l_bnc06 = 0 END IF
         LET bnc06_qty = l_rvv17 - l_bnc06
         IF bnc06_qty > 0 THEN
            LET l_bnc02 = l_bnc02+1
         ELSE
        #CHI-CB0018---add---E
            CONTINUE FOREACH
     #CHI-CB0018---add---S
         END IF
      ELSE 
         LET l_bnc02 = l_bnc02+1
     #CHI-CB0018---add---E
      END IF
      #FUN-6A0007 (e)
 
      SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_rvv31
      IF STATUS OR cl_null(l_ima02) THEN LET l_ima02 = ' ' END IF
 
      IF cl_null(l_rvv38) THEN LET l_rvv38 = 0 END IF
 
      CALL s_curr3(l_pmm22,l_rvu03,'D') RETURNING l_rate
      LET l_bnc10 =  cl_digcut(l_rvv38 * l_rate,g_azi04)

     #CHI-CB0018---add---S
      IF l_n > 0 THEN
         LET bnc06_qty = bnc06_qty
      ELSE
         LET bnc06_qty = l_rvv17
      END IF
     #CHI-CB0018---add---E
 
      INSERT INTO bnc_file(bnc01,bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,
                           bnc08,bnc09,bnc10,bnc011,bnc012,
                           bncplant,bnclegal)   #FUN-980001
          #VALUES(g_bnb.bnb01,l_rvv02,l_rvv31,l_ima02,l_rvv35,l_rvv17,    #CHI-CB0018 mark
           VALUES(g_bnb.bnb01,l_bnc02,l_rvv31,l_ima02,l_rvv35,bnc06_qty,  #CHI-CB0018
                  g_aza.aza17,l_rvv38,l_rate,l_bnc10,g_bnb.bnb04,l_rvv02,
                  g_plant,g_legal)   #FUN-980001
      IF STATUS = 0  THEN LET l_ac = l_ac + 1 END IF
   END FOREACH
 
END FUNCTION
#FUN-6A0007 (e)
 
#--> #FUN-6A0007 add 
FUNCTION i020_ins_bnc(p_str)
DEFINE p_str  LIKE type_file.chr1000
DEFINE i,j    LIKE type_file.num5
 
   LET i = 0
   SELECT COUNT(*) INTO i 
    FROM bnc_file WHERE bnc01 = g_bnb.bnb01
 
   ## 是否重新產新bnc_file
   IF i > 0 THEN
      IF NOT cl_confirm('axm-122') THEN RETURN END IF
 
      ## 刪除前,先update ogb1014=N
      CALL i020_up_ogb1014('4','','')
      IF g_success = 'N' THEN
         CALL cl_err('','abx-058',1)
         RETURN
      END IF
 
      ## 單身全刪,再重新產生
      DELETE FROM bnc_file WHERE bnc01 = g_bnb.bnb01 
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('del bnc err:',SQLCA.sqlcode,1)
         RETURN
      END IF
   END IF
 
   LET g_success='N'
   LET j=1
   FOR i=1 TO LENGTH(p_str)
     IF p_str[i,i]='|' THEN
        CALL i020_bnc_b1(p_str[j,i-1])
        LET j=i+1
        IF g_success='N' THEN RETURN END IF
     END IF
   END FOR
 
   IF NOT cl_null(p_str[j,length(p_str)]) THEN
      CALL i020_bnc_b1(p_str[j,length(p_str)])
      display p_str[j,length(p_str)]
   END IF
END FUNCTION
 
FUNCTION i020_bnc_b1(p_no)
   DEFINE i,j       LIKE type_file.num5,
          p_no      LIKE type_file.chr1000,
          p_no1     LIKE ogb_file.ogb01,  #出貨單號
          p_no2     LIKE ogb_file.ogb03,  #出貨項次
          l_sql     STRING,             
          l_total   LIKE ogb_file.ogb13, 
          l_oga03   LIKE oga_file.oga03,  #帳款客戶編號
          l_oga23   LIKE oga_file.oga23,  #幣別
          l_oga24   LIKE oga_file.oga24,  #匯率
          l_ogb04   LIKE ogb_file.ogb04,  #產品編號
          l_ogb05   LIKE ogb_file.ogb05,  #銷售單位
          l_ogb06   LIKE ogb_file.ogb06,  #品名
          l_ogb12   LIKE ogb_file.ogb12,  #數量
          l_ogb13   LIKE ogb_file.ogb13,  #原幣單價   #CHI-B70039 add ,
          l_ogb917  LIKE ogb_file.ogb917  #CHI-B70039 add
 
   ## 切割單號與項次
   FOR i=1 TO LENGTH(p_no)
      IF p_no[i,i]=',' THEN
         LET p_no1 = p_no[1,i-1]
         LET p_no2 = p_no[i+1,length(p_no)]
      END IF
   END FOR
 
   LET l_sql = "  SELECT oga23,oga24,ogb04,ogb05,ogb06,ogb12,ogb13",
               "    ,ogb917",                           #CHI-B70039 add
               "    FROM ogb_file,oga_file,ima_file ",
               "   WHERE ogb01= ? ",      #出貨單號
               "     AND ogb03= ? ",      #出貨項次
               "     AND ogaconf = 'Y'",  #己確認
               #"     AND oga09='2'",      #單據別   #MOD-920192
               "     AND (oga09='2' OR oga09='3') ",      #單據別   #MOD-920192
               "     AND oga_file.oga01=ogb01 ",
               "     AND ogb_file.ogb04=ima_file.ima01 "
 
   IF g_bnb.bnb19 = 'Y' THEN
      LET l_sql = l_sql CLIPPED, " AND ima15='Y' "
   #-----MOD-920165---------
   #ELSE
   #   LET l_sql = l_sql CLIPPED, " AND ima15='N' "
   #-----END MOD-920165-----
   END IF
 
   LET l_sql = l_sql CLIPPED, " ORDER BY oga23 "
 
   PREPARE i020_ac_p FROM l_sql
   DECLARE i020_ac CURSOR FOR i020_ac_p
 
   LET l_ac = NULL
   SELECT max(bnc02)+1 INTO l_ac FROM bnc_file WHERE bnc01 = g_bnb.bnb01
 
   IF cl_null(l_ac) THEN
      LET l_ac = 1
   END IF
 
   IF cl_null(l_total) THEN
      LET l_total = 0
   END IF
 
   OPEN i020_ac USING p_no1,p_no2 
      IF SQLCA.sqlcode THEN
          CALL cl_err('i020_ac o:',SQLCA.sqlcode,1)
          LET g_success = 'N'
      END IF
   FETCH i020_ac INTO l_oga23,l_oga24,l_ogb04,l_ogb05,
                      l_ogb06,l_ogb12,l_ogb13
                      ,l_ogb917       #CHI-B70039 add
      IF SQLCA.sqlcode THEN
          CALL cl_err('i020_ac f:',SQLCA.sqlcode,1)
          LET g_success = 'N'
      END IF
 
      IF cl_null(l_ogb13) THEN
         LET l_ogb13 = 0
      END IF
 
#     LET l_total = l_ogb12*l_ogb13*l_oga24    #CHI-B70039 mark
      LET l_total = l_ogb917*l_ogb13*l_oga24   #CHI-B70039
 
      IF cl_null(l_total) THEN
         LET l_total = 0
      END IF
 
      INSERT INTO bnc_file(bnc01,bnc02,bnc03,bnc04,bnc05,bnc06,bnc07,
                           bnc08,bnc09,bnc10,bnc11,bnc011,bnc012,
                           bncplant,bnclegal)   #FUN-980001
           VALUES(g_bnb.bnb01,l_ac,l_ogb04,l_ogb06,l_ogb05,l_ogb12,
                  l_oga23,l_ogb13,l_oga24,l_total,g_bnb.bnb16,p_no1,p_no2,
                  g_plant,g_legal)   #FUN-980001
      IF SQLCA.sqlcode THEN 
         CALL cl_err('ins bnc:',SQLCA.sqlcode,1)
      ELSE
         LET g_success = 'Y'
      END IF
END FUNCTION
 
## update ogb1014(放行否)
## A.資料來源 = 2.出貨單時,才需做以下更新
## B.新增 -> ogb1014 = Y
##   刪除 -> ogb1014 = N
FUNCTION i020_up_ogb1014(p_type,p_no1,p_no2)
   DEFINE   p_type   LIKE type_file.chr1,            #狀態: 1.單身新增 2.整批新增 
                                            #      3.單身刪除 4.整張刪除 
                                            #      單身更改-> 1 + 3
            p_no1    LIKE   bnc_file.bnc011, #出貨單號
            p_no2    LIKE   bnc_file.bnc012, #出貨項次
            l_flag   LIKE type_file.chr1             #Y/N 
 
   LET g_success = 'Y'
 
   IF p_type MATCHES "[12]" THEN
      LET l_flag = 'Y'
   ELSE
      LET l_flag = 'N'
   END IF 
 
   IF p_type MATCHES "[13]" THEN
       UPDATE ogb_file SET ogb1014=l_flag
        WHERE ogb01 = p_no1 
          AND ogb03 = p_no2 
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err('up ogb1014:',STATUS,0)
          LET g_success = 'N'
       END IF
   END IF 
 
   IF p_type MATCHES "[24]" THEN
 
       ## 單身.出貨單號+項次,均不為空白的才更新
       LET g_sql = "SELECT bnc011,bnc012 FROM bnc_file",
                   " WHERE bnc01 = '",g_bnb.bnb01,"'",
                   "   AND (bnc011 IS NOT NULL OR bnc011 !=' ' OR bnc011 !='')",
                  #"   AND (bnc012 IS NOT NULL OR bnc012 !=' ' OR bnc012 !='')"    #MOD-B90139 mark
                   "   AND bnc012 IS NOT NULL"                                     #MOD-B90139
      PREPARE i020_ta_p FROM g_sql
      DECLARE i020_ta_c CURSOR FOR i020_ta_p
 
      LET p_no1 = NULL
      LET p_no2 = NULL
      LET p_type = 'N'
      FOREACH i020_ta_c INTO p_no1,p_no2 
         IF STATUS THEN 
            CALL cl_err('i020_ta:',STATUS,0)
            LET g_success = 'N'
            EXIT FOREACH
         END IF                                
 
         LET p_type = 'Y'
 
         UPDATE ogb_file SET ogb1014=l_flag
          WHERE ogb01 = p_no1 
            AND ogb03 = p_no2 
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err('up ogb1014:',STATUS,0)
            LET p_type = 'N'
            EXIT FOREACH
         END IF
      END FOREACH
      IF p_type = 'N' THEN
         CALL cl_err('up ogb1014:',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF 
END FUNCTION
#--- #FUN-6A0007 ---------------------------------------------------------
 
FUNCTION i020_date()
    DEFINE l_y LIKE type_file.num10,                        #NO.FUN-680062     INTEGER  
           l_m LIKE type_file.num10,                        #NO.FUN-680062     INTEGER 
           l_d LIKE type_file.num10,                        #NO.FUN-680062     INTEGER
           i   LIKE type_file.num10,                        #NO.FUN-680062     INTEGER
           l_bdate LIKE type_file.dat,                      #NO.FUN-680062    DATE 
           l_edate LIKE type_file.dat                       #NO.FUN-680062    DATE   
 
   CALL s_mothck(g_bnb.bnb02) RETURNING l_bdate,l_edate #傳回本日期的第一,最後日
 
   LET l_y = YEAR(g_bnb.bnb02) USING '&&&&'
   LET l_m = MONTH(g_bnb.bnb02)
   LET l_d = DAY(g_bnb.bnb02)
 
   FOR i=1 TO 6
      LET l_m = l_m + 1
      IF l_m > 12 THEN
         LET l_y = l_y + 1
         LET l_m = 1
      END IF
   END FOR
 
   LET g_bnb.bnb12 = MDY(l_m,1,l_y)
 
   IF l_d = DAY(l_edate) THEN
      CALL s_mothck(g_bnb.bnb12) RETURNING l_bdate,l_edate
      LET l_d = DAY(l_edate)
   END IF
 
   LET g_bnb.bnb12 = MDY(l_m,l_d,l_y)
   DISPLAY BY NAME g_bnb.bnb12
 
END FUNCTION
 
FUNCTION i020_o()
 DEFINE  l_wc   LIKE  type_file.chr1000   #No.TQC-610081 add           #NO.FUN-680062 VARCHAR(200)   
   IF NOT cl_null(g_bnb.bnb01) THEN
#--------------------No.TQC-610081 modify
      LET l_wc='bnb01="',g_bnb.bnb01,'"'
      LET g_msg = 'abxr100',
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' ' ' '1' ",
                   " '",l_wc CLIPPED,"'"
     #LET g_msg = "abxr100 '",g_bnb.bnb01,"'"
#--------------------No.TQC-610081 end
      CALL cl_cmdrun(g_msg)
   END IF
 
END FUNCTION
 
FUNCTION i020_s()
 DEFINE  l_wc    LIKE type_file.chr1000    #No.TQC-610081 add       #NO.FUN-680062    VARCHAR(200)
 
   IF NOT cl_null(g_bnb.bnb01) THEN
#--------------------No.TQC-610081 modify
      LET l_wc='bnb01="',g_bnb.bnb01,'"'
      LET g_msg = 'abxr100s',
                   " '",g_today CLIPPED,"' ''",
                   " '",g_lang CLIPPED,"' 'Y' ' ' '1' ",
                   " '",l_wc CLIPPED,"'"
     #LET g_msg = "abxr100s '",g_bnb.bnb01,"'"
#--------------------No.TQC-610081 end
      CALL cl_cmdrun(g_msg)
   END IF
 
END FUNCTION
 
FUNCTION i020_set_entry(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1            #NO.FUN-680062    VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("bnb01",TRUE)
       CALL cl_set_comp_entry("bnb03,bnb20",TRUE)     #MOD-840462-add
    END IF

     CALL cl_set_comp_entry("bnc11",TRUE)  #CHI-CB0018 add
 
END FUNCTION
 
FUNCTION i020_set_no_entry(p_cmd)
  DEFINE p_cmd LIKE type_file.chr1         #NO.FUN-680062   
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("bnb01",FALSE)
    END IF

    #CHI-CB0018---add---S
    #資料來源為1、2、5才可修改單身的工單/訂單號碼
     IF g_bnb.bnb03 MATCHES '[346]' THEN
        CALL cl_set_comp_entry("bnc11",FALSE)
     END IF
    #CHI-CB0018---add---E
 
#MOD-840462-add
    IF p_cmd = 'u' THEN
       CALL cl_set_comp_entry("bnb03,bnb20",FALSE)
    END IF
#MOD-840462-add-end
 
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001,002,003,004,005,006,007,009> #
#Patch....NO.TQC-610035 <001> #

#FUN-910088--add--start--
FUNCTION i020_bnc06_check()
   IF NOT cl_null(g_bnc[l_ac].bnc06) AND NOT cl_null(g_bnc[l_ac].bnc05) THEN
      IF cl_null(g_bnc05_t) OR cl_null(g_bnc_t.bnc06) OR g_bnc05_t != g_bnc[l_ac].bnc05 OR g_bnc_t.bnc06 != g_bnc[l_ac].bnc06 THEN
         LET g_bnc[l_ac].bnc06 = s_digqty(g_bnc[l_ac].bnc06,g_bnc[l_ac].bnc05)
         DISPLAY BY NAME g_bnc[l_ac].bnc06
      END IF
   END IF
   IF cl_null(g_bnc[l_ac].bnc06) THEN
      LET g_bnc[l_ac].bnc06=0
   END IF
   LET g_bnc[l_ac].bnc10 = g_bnc[l_ac].bnc06 * g_bnc[l_ac].bnc08 * g_bnc[l_ac].bnc09
   DISPLAY BY NAME g_bnc[l_ac].bnc10
   DISPLAY BY NAME g_bnc[l_ac].bnc06
   DISPLAY BY NAME g_bnc[l_ac].bnc10
END FUNCTION
#FUN-910088--add--end--


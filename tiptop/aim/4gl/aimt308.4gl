# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimt308.4gl
# Date & Author..: 03/03/02 By Mandy
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: NO.FUN-550029 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-550108 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: NO.MOD-420449 05/07/11 By Yiting key值可修改
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.FUN-580014 05/08/18 By day  報表轉xml
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: No.FUN-660080 06/06/14 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: NO.FUN-660156 06/06/26 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670093 06/07/26 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/12 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-6C0029 06/12/06 By Ray 報表格式修改
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.FUN-710025 07/01/25 By bnlent 錯誤信息匯整
# Modify.........: No.FUN-6B0038 07/02/05 By rainy 庫存扣帳時先跳到扣帳日期輸入
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-750131 07/05/23 By jamie 過帳時,扣帳日default g_today 
# Modify.........: No.MOD-760061 07/06/15 By pengu 若在過帳時將扣帳日期改掉則會無法扣帳還原
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: NO.FUN-840020 08/04/08 By zhaijie 報表輸出改為CR
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.CHI-910012 09/01/07 By claire 新增時 default扣帳日同單據日
# Modify.........: No.CHI-930007 09/03/03 By jan 扣帳時,點退出按鈕后,仍能繼續執行
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40023 10/03/22 By dxfwo ima26x改善
# Modify.........: No.TQC-AC0202 10/12/15 By lixh1 修改INSERT INTO imq_file 的SQL
# Modify.........: No.TQC-AC0353 10/12/24 By zhangll 增加单头借料单号控管
# Modify.........: No.TQC-B10063 11/01/11 By lilingyu 單頭單別欄位未能正確檢查
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70074 11/07/21 By xianghui 添加行業別表的新增於刪除
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:FUN-BB0083 11/12/07 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20048 12/02/09 By fengrui 增加數量欄位小數取位
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:CHI-C70017 12/10/29 By bart 關帳日管控
# Modify.........: No:TQC-CB0012 12/11/06 By xuxz 借料單號單頭開窗添加imopost='Y'條件，單身開窗添加類似條件
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No:FUN-D10081 13/01/18 By qiull 增加資料清單
# Modify.........: No:TQC-D10084 13/01/25 By qiull 資料清單頁簽跳轉問題
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題


DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_imr           RECORD LIKE imr_file.*,#簽核等級 (假單頭)
    g_imr_t         RECORD LIKE imr_file.*,#簽核等級 (舊值)
    g_imr_o         RECORD LIKE imr_file.*,#簽核等級 (舊值)
    b_imq           RECORD LIKE imq_file.*,
    g_imr01_t       LIKE imr_file.imr01,   #簽核等級 (舊值)
    g_imq           DYNAMIC ARRAY OF RECORD#程式變數(Program Variables)
        imq02       LIKE imq_file.imq02,   #項次
        imq03       LIKE imq_file.imq03,   #
        imq04       LIKE imq_file.imq04,   #
        imp03       LIKE imp_file.imp03,   #
        ima02s      LIKE ima_file.ima02,   #
        imp05       LIKE imp_file.imp05,   #
        imp04       LIKE imp_file.imp04,   #
        imq07       LIKE imq_file.imq07,   #
        imp09       LIKE imp_file.imp09,   #
        imq11       LIKE imq_file.imq11,   #
        imq12       LIKE imq_file.imq12,
        imq930      LIKE imq_file.imq930,  #FUN-670093
        gem02c      LIKE gem_file.gem02    #FUN-670093
                    END RECORD,
    g_imq_t         RECORD                 #程式變數 (舊值)
        imq02       LIKE imq_file.imq02,   #項次
        imq03       LIKE imq_file.imq03,   #
        imq04       LIKE imq_file.imq04,   #
        imp03       LIKE imp_file.imp03,   #
        ima02s      LIKE ima_file.ima02,   #
        imp05       LIKE imp_file.imp05,   #
        imp04       LIKE imp_file.imp04,   #
        imq07       LIKE imq_file.imq07,   #
        imp09       LIKE imp_file.imp09,   #
        imq11       LIKE imq_file.imq11,   #
        imq12       LIKE imq_file.imq12,
        imq930      LIKE imq_file.imq930,  #FUN-670093
        gem02c      LIKE gem_file.gem02    #FUN-670093
                    END RECORD,
    g_wc,g_wc2,g_sql  STRING, #TQC-630166
    g_cmd             LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
    g_rec_b           LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    g_void            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_sl              LIKE type_file.num5,    #目前處理的SCREEN LINE  #No.FUN-690026 SMALLINT
    g_t1              LIKE smy_file.smyslip,  #No.FUN-550029 #No.FUN-690026 VARCHAR(05)
    g_flag            LIKE type_file.chr1,    #判斷是否為新增的自動編號  #No.FUN-690026 VARCHAR(1)
    g_ima25           LIKE ima_file.ima25,    #主檔庫存單位
    g_ima25_fac       LIKE img_file.img20,    #收料單位對主檔庫存單位轉換率
   #g_ima86           LIKE ima_file.ima86,    #成本單位 #FUN-560183
    g_ima39           LIKE ima_file.ima39,    #料件所屬會計科目
    g_img10           LIKE img_file.img10,    #庫存數量
    g_img09           LIKE img_file.img09,    #庫存img之單位
    g_img26           LIKE img_file.img26,    #倉庫所屬會計科目
    g_img23           LIKE img_file.img23,    #是否為可用倉儲
    g_img24           LIKE img_file.img24,    #是否為MRP可用倉儲
    g_img21           LIKE img_file.img21,    #庫存單位對料件庫存單位轉換率
    g_img19           LIKE ima_file.ima271,   #最高限量
    g_ima271          LIKE ima_file.ima271,   #最高儲存量
    g_imf05           LIKE imf_file.imf05,    #預設料件庫存量
    h_qty             LIKE ima_file.ima271,
    l_year,l_prd      LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    sn1,sn2           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#    g_ima262          LIKE ima_file.ima262,  #No.FUN-A40023#No.FUN-A40023 #料件庫存可使用量(ima262)
    g_img             RECORD
                      img19 LIKE img_file.img19,  #Class
                      img36 LIKE img_file.img36
                      END RECORD,
    m_imr             RECORD
                      img09_fac LIKE ima_file.ima63_fac,
                      img09     LIKE img_file.img09,
                      ima63     LIKE ima_file.ima63,
                      img10     LIKE img_file.img10,
                      img35_2   LIKE img_file.img35,
                      img27     LIKE img_file.img27,
                      img28     LIKE img_file.img28,
                      ima25_fac LIKE ima_file.ima63_fac,
                     #ima86_fac LIKE ima_file.ima86_fac, #FUN-560183
                      ima25     LIKE ima_file.ima25
                      END RECORD,
    t_img02           LIKE img_file.img02,         #倉庫
    t_img03           LIKE img_file.img03          #儲位
DEFINE p_row,p_col          LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done  LIKE type_file.num5    #NO.MOD-420449  #No.FUN-690026 SMALLINT
 
#主程式開始
DEFINE g_forupd_sql STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i          LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count  LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_argv1      LIKE imp_file.imp01    # 單號  #TQC-imr052 #No.FUN-690026 VARCHAR(16)           
DEFINE g_argv2      STRING                 # 指定執行的功能   #TQC-630052
#NO.FUN-840020---start---
DEFINE l_table        STRING
DEFINE g_str          STRING
#NO.FUN-840020---end----
DEFINE g_imp05_t    LIKE imp_file.imp05    #FUN-BB0083 add
#FUN-D10081---add---str---
DEFINE g_imr_l DYNAMIC ARRAY OF RECORD
               imr01   LIKE imr_file.imr01,
               smydesc LIKE smy_file.smydesc,
               imr02   LIKE imr_file.imr02,
               imr03   LIKE imr_file.imr03,
               gen02   LIKE gen_file.gen02,
               imr04   LIKE imr_file.imr04,
               gem02   LIKE gem_file.gem02,
               imr05   LIKE imr_file.imr05,
               imr06   LIKE imr_file.imr06,
               imr09   LIKE imr_file.imr09,
               imrconf LIKE imr_file.imrconf,
               imrpost LIKE imr_file.imrpost
               END RECORD,
        l_ac4      LIKE type_file.num5,
        g_rec_b4   LIKE type_file.num5,
        g_action_flag  STRING
DEFINE   w     ui.Window
DEFINE   f     ui.Form
DEFINE   page  om.DomNode
#FUN-D10081---add---end---
MAIN
#DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0074
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1=ARG_VAL(1)           #TQC-630052
    LET g_argv2=ARG_VAL(2)           #TQC-630052
 
     CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
   LET p_row = 3 LET p_col = 2
#NO.FUN-840020---start---
   LET g_sql ="imr01.imr_file.imr01,",
              "imr02.imr_file.imr02,",
              "imr03.imr_file.imr03,",
              "imr04.imr_file.imr04,",
              "imr05.imr_file.imr05,",
              "imr06.imr_file.imr06,",
              "gen02.gen_file.gen02,",
              "gem02.gem_file.gem02,",
              "imrpost.imr_file.imrpost,",
              "imq02.imq_file.imq02,",
              "imq03.imq_file.imq03,",
              "imq04.imq_file.imq04,",
              "imq07.imq_file.imq07,",
              "imq11.imq_file.imq11,",
              "imq12.imq_file.imq12,",
              "imp03.imp_file.imp03,",
              "imp04.imp_file.imp04,",
              "imp05.imp_file.imp05,",
              "imp09.imp_file.imp09,",
              "ima02.ima_file.ima02"
   LET l_table = cl_prt_temptable('aimt308',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF
#NO.FUN-840020---end----
   #小數位----------------------------------------------
#NO.CHI-6A0004--BEGIN
#     SELECT azi03,azi04,zai05
#     INTO g_azi03,g_azi04,g_azi05
#     FROM azi_file
#     WHERE azi01=a_azi.azi17
#NO.CHI-6A0004--END
    OPEN WINDOW t308_w AT p_row,p_col             #顯示畫面
        WITH FORM "aim/42f/aimt308"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("imq930,gem02c",g_aaz.aaz90='Y')  #FUN-670093
    #TQC-630052-begin
    # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是單號(imr05)
    # 執行I時，g_argv1是單號(imr05)
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t308_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t308_a()
             END IF
          OTHERWISE
             CALL t308_q()
       END CASE
    END IF
    #TQC-630052-end
 
    CALL t308()
    CLOSE WINDOW t308_w                    #結束畫面
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION t308()
    LET g_forupd_sql =
      " SELECT * FROM imr_file WHERE imr01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t308_cl CURSOR FROM g_forupd_sql
 
    CALL t308_menu()
END FUNCTION
 
#QBE 查詢資料
FUNCTION t308_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                                    #清除畫面
   CALL g_imq.clear()
 
   INITIALIZE g_imr.* TO NULL
 
   IF cl_null(g_argv1) THEN  #TQC-630052
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
        imr01,imr02,imr05,imr09,imr03,imr04,imr06,imrconf, #FUN-660080 add imrconf
        imrpost,imruser,imrgrup,imrmodu,imrdate
               #No.FUN-580031 --start--     HCN
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
               #No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imr01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imr"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imr01
                    NEXT FIELD imr01
               WHEN INFIELD(imr03) #借料人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imr03
                    NEXT FIELD imr03
               WHEN INFIELD(imr04) #部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imr04
                    NEXT FIELD imr04
               WHEN INFIELD(imr05) #借料單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imo"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imr05
                    NEXT FIELD imr05
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
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND imruser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND imrgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND imrgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imruser', 'imrgrup')
    #End:FUN-980030
 
    CALL g_imq.clear()
    CONSTRUCT g_wc2 ON imq02,imq03,imq04,
                       imq07,imq11,imq12,imq930 #FUN-670093
                                            # 螢幕上取單身條件
         FROM s_imq[1].imq02,s_imq[1].imq03,s_imq[1].imq04,
              s_imq[1].imq07,s_imq[1].imq11,s_imq[1].imq12,
              s_imq[1].imq930 #FUN-670093
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imq03) #借料號號-項次
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imp1"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imq03
                    NEXT FIELD imq03
               #FUN-670093...............begin
               WHEN INFIELD(imq930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imq930
                  NEXT FIELD imq930
               #FUN-670093...............end
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
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
  #TQC-630052-begin
   ELSE
      LET g_wc =" imr01 = '",g_argv1,"'"  
      LET g_wc2 =" 1=1"  
   END IF
  #TQC-630052-end
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  imr01 FROM imr_file ",
                   " WHERE ", g_wc CLIPPED,
                   "   AND imr00 = '2' ",#原價償還
                   " ORDER BY imr01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE imr_file. imr01 ",
                   "  FROM imr_file, imq_file ",
                   " WHERE imr01 = imq01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   "   AND imr00 = '2' ",#原價償還
                   " ORDER BY imr01"
    END IF
 
    PREPARE t308_prepare FROM g_sql
    DECLARE t308_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t308_prepare
    DECLARE t308_fill_cs CURSOR WITH HOLD FOR t308_prepare   #FUN-D10081 add
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imr_file WHERE ",g_wc CLIPPED,
                  "   AND imr00 = '2' " #原價償還
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT imr01) ",
                  "  FROM imr_file,imq_file ",
                  " WHERE imq01=imr01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED,
                  "   AND imr00 = '2' "#原價償還
    END IF
    PREPARE t308_precount FROM g_sql
    DECLARE t308_count CURSOR FOR t308_precount
END FUNCTION
 
 
FUNCTION t308_menu()
 
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN      #FUN-D10081 add
         CALL t308_bp("G")
      #FUN-D10081---add---str---
      ELSE 
         CALL t308_list_fill()
         CALL t308_bp2("G")
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT imr_file.* INTO g_imr.*
              FROM imr_file
             WHERE imr01 = g_imr_l[l_ac4].imr01
         END IF 
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET mi_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t308_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("page_main", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("page_main", TRUE)
         END IF
      END IF
      #FUN-D10081---add---end---
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t308_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t308_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t308_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t308_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t308_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t308_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
            
         #FUN-660080...............begin
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t308_y_chk()
               IF g_success = "Y" THEN
                  CALL t308_y_upd()
               END IF
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t308_z()
            END IF
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t308_x()     #CHI-D20010
               CALL t308_x(1)    #CHI-D20010
               IF g_imr.imrconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"")
            END IF
         #FUN-660080...............end
       #CHI-D20010---begin
          WHEN "undo_void"
             IF cl_chk_act_auth() THEN
                CALL t308_x(2)
               IF g_imr.imrconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"")
             END IF
       #CHI-D20010---end
       #@WHEN "過帳"
         WHEN "post"
            IF cl_chk_act_auth() THEN
               CALL t308_s()
               IF g_imr.imrconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") #FUN-660080
            END IF
       #@WHEN "過帳還原"
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
               CALL t308_w()
               IF g_imr.imrconf = 'X' THEN #FUN-660080
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") #FUN-660080
            END IF
         WHEN "exporttoexcel" #FUN-4B0002
            LET w = ui.Window.getCurrent()   #FUN-D10081 add
            LET f = w.getForm()              #FUN-D10081 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-D10081 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")                 #FUN-D10081 add
                  #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imq),'','')  #FUN-D10081 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imq),'','')  #FUN-D10081 add
               END IF
            #FUN-D10081---add---str---
            END IF 
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imr_l),'','')
               END IF
            END IF
            #FUN-D10081---add---end---     
 
         #No.FUN-680046-------add--------str----
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_imr.imr01 IS NOT NULL THEN
                 LET g_doc.column1 = "imr01"
                 LET g_doc.value1 = g_imr.imr01
                 CALL cl_doc()
               END IF
           END IF
         #No.FUN-680046-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t308_a()
DEFINE li_result   LIKE type_file.num5        #No.FUN-550029  #No.FUN-690026 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
   CALL g_imq.clear()
    INITIALIZE g_imr.* LIKE imr_file.*             #DEFAULT 設定
    LET g_imr01_t = NULL
    #預設值及將數值類變數清成零
    LET g_imr_t.* = g_imr.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imr.imr00 = '2' #原價償還
        LET g_imr.imr02 = g_today
        LET g_imr.imrpost='N'
        LET g_imr.imrconf='N' #FUN-660080
        LET g_imr.imruser=g_user
        LET g_imr.imroriu = g_user #FUN-980030
        LET g_imr.imrorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_imr.imrgrup=g_grup
        LET g_imr.imrdate=g_today
        LET g_imr.imr02=g_today         #借料日期為系統日期
        LET g_imr.imr09=g_today         #CHI-910012 add
        LET g_imr.imr03=g_user        
        LET g_imr.imrplant = g_plant #FUN-980004 add
        LET g_imr.imrlegal = g_legal #FUN-980004 add
       #TQC-630052-begin
        IF NOT cl_null(g_argv1) AND (g_argv2 = "insert") THEN
           LET g_imr.imr05 = g_argv1
        END IF
       #TQC-630052-end
 
        CALL t308_i("a")                #輸入單頭
        IF INT_FLAG THEN                #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            INITIALIZE g_imr.* TO NULL
            EXIT WHILE
        END IF
        BEGIN WORK #No:7857
#No.FUN-550029 --start--
        CALL s_auto_assign_no("aim",g_imr.imr01,g_imr.imr02,"C","imr_file","imr01","","","")
             RETURNING li_result,g_imr.imr01
        IF g_imr.imr01 IS NULL THEN
           CONTINUE WHILE
        END IF
 
#        CALL s_smyauno(g_t1,g_imr.imr02) RETURNING g_i,g_imr.imr01
#        IF g_imr.imr01 IS NULL THEN     # KEY 不可空白
#            CONTINUE WHILE
#        END IF
#No.FUN-550029 --end--
	#進行輸入之單號檢查
	CALL s_mfgchno(g_imr.imr01) RETURNING g_i,g_imr.imr01
	DISPLAY BY NAME g_imr.imr01
	IF NOT g_i THEN CONTINUE WHILE END IF
 
        INSERT INTO imr_file VALUES (g_imr.*)
        IF SQLCA.sqlcode THEN           # 置入資料庫不成功
        #   ROLLBACK WORK #No:7857   #FUN-B80070---回滾放在報錯後---
#          CALL cl_err(g_imr.imr01,SQLCA.sqlcode,1) #No.FUN-660156
           CALL cl_err3("ins","imr_file",g_imr.imr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           ROLLBACK WORK    #FUN-B80070--add--
           CONTINUE WHILE
        ELSE
            COMMIT WORK #No:7857
            CALL cl_flow_notify(g_imr.imr01,'I')
        END IF
        SELECT imr01 INTO g_imr.imr01 FROM imr_file
            WHERE imr01 = g_imr.imr01
        LET g_imr01_t = g_imr.imr01        #保留舊值
        LET g_imr_t.* = g_imr.*
        LET g_rec_b = 0                    #No.FUN-680064
        CALL g_imq.clear()
        CALL t308_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t308_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_imr.* FROM imr_file WHERE imr01=g_imr.imr01
    IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_imr.imrconf = 'Y' THEN CALL cl_err('','aap-005',0) RETURN END IF #FUN-660080
    IF g_imr.imrpost='Y' THEN CALL cl_err(g_imr.imr01,'aar-347',0) RETURN END IF
    IF g_imr.imrconf='X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660080
{
    IF g_imr.imracti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_imr.imr01,9027,0)
       RETURN
    END IF
}
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imr01_t = g_imr.imr01
    LET g_imr_o.* = g_imr.*
    BEGIN WORK
 
    OPEN t308_cl USING g_imr.imr01
    IF STATUS THEN
       CALL cl_err("OPEN t308_cl:", STATUS, 1)
       CLOSE t308_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t308_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t308_cl ROLLBACK WORK RETURN
    END IF
    CALL t308_show()
    WHILE TRUE
        LET g_imr01_t = g_imr.imr01
        LET g_imr.imrmodu=g_user
        LET g_imr.imrdate=g_today
        CALL t308_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imr.*=g_imr_t.*
            CALL t308_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_imr.imr01 != g_imr01_t THEN            # 更改單號
            UPDATE imq_file SET imq01 = g_imr.imr01
                WHERE imq01 = g_imr01_t
            IF SQLCA.sqlcode THEN
#              CALL cl_err('imq',SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("upd","imq_file",g_imr01_t,"",SQLCA.sqlcode,"","imq",1)  #No.FUN-660156
               CONTINUE WHILE
            END IF
        END IF
        UPDATE imr_file SET imr_file.* = g_imr.* WHERE imr01 = g_imr01_t
        IF SQLCA.sqlcode THEN
#          CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imr_file",g_imr.imr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
           CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t308_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imr.imr01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t308_i(p_cmd)
DEFINE
    p_cmd       LIKE type_file.chr1,      #No.FUN-690026 VARCHAR(1)
    l_flag      LIKE type_file.chr1,      #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
    l_t1        LIKE smy_file.smyslip,    #No.FUN-550029 #No.FUN-690026 VARCHAR(05)
    li_result   LIKE type_file.num5       #No.FUN-550029 #No.FUN-690026 SMALLINT
DEFINE l_cnt    LIKE type_file.num5       #Add No.TQC-AC0353
 
    DISPLAY BY NAME                              # 顯示單頭值
                    g_imr.imr01,g_imr.imr02,g_imr.imr05,g_imr.imr09,
                    g_imr.imr03,g_imr.imr04,g_imr.imr06,g_imr.imrconf, #FUN-660080 add g_imr.imrconf
                    g_imr.imrpost,g_imr.imruser,
                    g_imr.imrgrup,g_imr.imrmodu,g_imr.imrdate
      CALL cl_set_head_visible("","YES")   #No.FUN-6B0030 
      INPUT BY NAME g_imr.imroriu,g_imr.imrorig,
                    g_imr.imr01,g_imr.imr02,g_imr.imr05,g_imr.imr09,
                    g_imr.imr03,g_imr.imr04,g_imr.imr06,g_imr.imrconf, #FUN-660080 add g_imr.imrconf
                    g_imr.imrpost,g_imr.imruser,
                    g_imr.imrgrup,g_imr.imrmodu,g_imr.imrdate
                   WITHOUT DEFAULTS
 
#No.FUN-550029 --start--
	  BEFORE INPUT
	     CALL cl_set_docno_format("imr01")
	    #CALL cl_set_docno_format("imr05")   #Mark No.TQC-AC0353
	     CALL cl_set_docno_format("imq03")
#No.FUN-550029 ---end---
       #MOD-420449
            LET g_before_input_done = FALSE
            CALL t308_set_entry(p_cmd)
            CALL t308_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
      #--END
 
 
        AFTER FIELD imr02        #還料日期不可空白
	    IF g_imr.imr02 IS NULL THEN
                LET g_imr.imr02=g_today
            END IF
            DISPLAY g_imr.imr02 to imr02
          #CHI-690066 --begin
            #IF  NOT s_daywk(g_imr.imr02) THEN
	    #     CALL cl_err(g_imr.imr02,'mfg3152',0)
	    #     NEXT FIELD imr02
	    #END IF
            LET li_result = 0
            CALL s_daywk(g_imr.imr02) RETURNING li_result
	    IF li_result = 0 THEN #非工作日
               CALL cl_err(g_imr.imr02,'mfg3152',0)
	       NEXT FIELD imr02
	    END IF
	    IF li_result = 2 THEN #未設定
               CALL cl_err(g_imr.imr02,'mfg3153',0)
	       NEXT FIELD imr02
	    END IF
          #CHI-690066--end
          
                      
            CALL s_yp(g_imr.imr02) RETURNING l_year,l_prd
            #---->與目前會計年度,期間比較,如日期大於目前會計年度,期間則不可過
            IF (l_year*12+l_prd) > (g_sma.sma51*12+g_sma.sma52)
               THEN CALL cl_err('','mfg6091',0) NEXT FIELD imr02
            END IF
	    IF g_sma.sma53 IS NOT NULL AND g_imr.imr02 <= g_sma.sma53 THEN
		CALL cl_err('','mfg9999',0)
                NEXT FIELD imr02
	    END IF
 
        AFTER FIELD imr01       #還料單號(不可空白)
#No.FUN-550029 --start--
#            IF NOT cl_null(g_imr.imr01[1,3]) THEN
#            IF NOT cl_null(g_imr.imr01) AND (g_imr.imr01!=g_imr_t.imr01) THEN                #TQC-B10063 
             IF (NOT cl_null(g_imr.imr01) AND p_cmd = 'a') OR (p_cmd= 'u' AND g_imr.imr01!=g_imr_t.imr01) THEN          #TQC-B10063 
               CALL s_check_no("aim",g_imr.imr01,g_imr01_t,"C","imr_file","imr01","")
                  RETURNING li_result,g_imr.imr01
               DISPLAY BY NAME g_imr.imr01
            IF (NOT li_result) THEN
               NEXT FIELD imr01
            END IF
#                LET g_t1=g_imr.imr01[1,3]
#                CALL s_mfgslip(g_t1,'aim','C')          #檢查單別
#               	IF NOT cl_null(g_errno) THEN            #抱歉, 有問題
#                   CALL cl_err(g_t1,g_errno,0)
#                   NEXT FIELD imr01
#               	END IF
                DISPLAY g_smy.smydesc TO FORMONLY.smydesc
#                IF g_smy.smyauno MATCHES '[nN]' THEN
#                   IF cl_null(g_imr.imr01[g_no_sp,g_no_ep]) THEN #No.FUN-550029
#                      CALL cl_err(g_imr.imr01,'mfg6089',0)
#                      NEXT FIELD imr01
#                   END IF
#                   IF NOT cl_chk_data_continue(g_imr.imr01[5,10]) THEN
#                   IF NOT cl_chk_data_continue(g_imr.imr01[g_no_sp,g_no_ep]) THEN
#                      CALL cl_err('','9056',0)
#                      NEXT FIELD imr01
#                   END IF
#                END IF
#No.FUN-550029 ---end--
                #進行輸入之單號檢查
#                CALL s_mfgchno(g_imr.imr01) RETURNING g_i,g_imr.imr01
#                DISPLAY BY NAME g_imr.imr01
#                IF NOT g_i THEN NEXT FIELD imr01 END IF
	    END IF
        AFTER FIELD imr05
            IF NOT cl_null(g_imr.imr05) THEN
               CALL t308_imr05(g_imr.imr05)
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_imr.imr05,g_errno,0)
                   LET g_imr.imr05 = g_imr_t.imr05
                   DISPLAY BY NAME g_imr.imr05
                   NEXT FIELD imr05
               END IF
               #Add No.TQC-AC0353
               IF p_cmd = 'u' THEN
                  SELECT COUNT(*) INTO l_cnt FROM imq_file
                   WHERE imq01 = g_imr.imr01
                     AND imq03 <> g_imr.imr05
                  IF l_cnt > 0 THEN
                     CALL cl_err(g_imr.imr05,'apm-940',0)
                     LET g_imr.imr05 = g_imr_t.imr05
                     DISPLAY BY NAME g_imr.imr05
                     NEXT FIELD imr05
                  END IF        
               END IF
               #End Add No.TQC-AC0353
            END IF
        AFTER FIELD imr03    #還料人員,不可空白
          IF NOT cl_null(g_imr.imr03) THEN
             CALL t308_imr03('a') #檢查員工資料檔
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imr.imr03 = g_imr_t.imr03
                DISPLAY BY NAME g_imr.imr03
                NEXT FIELD imr03
             END IF
          END IF
 
        AFTER FIELD imr04    #部門,不可空白
          IF NOT cl_null(g_imr.imr04) THEN
             CALL t308_imr04('a') #檢查部門
             IF NOT cl_null(g_errno) THEN
                CALL cl_err('',g_errno,0)
                LET g_imr.imr04 = g_imr_t.imr04
                DISPLAY BY NAME g_imr.imr04
                NEXT FIELD imr04
             END IF
          END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_imr.imruser = s_get_data_owner("imr_file") #FUN-C10039
           LET g_imr.imrgrup = s_get_data_group("imr_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_imr.imr01 IS NULL THEN  #還料單號
               LET l_flag='Y'
               DISPLAY BY NAME g_imr.imr01
            END IF
            IF g_imr.imr02 IS NULL THEN  #還料日期
               LET l_flag='Y'
               DISPLAY BY NAME g_imr.imr02
            END IF
            IF g_imr.imr03 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imr.imr03
            END IF
            IF g_imr.imr04 IS NULL THEN
               LET l_flag='Y'
               DISPLAY BY NAME g_imr.imr04
            END IF
 
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD imr01
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imr01) #查詢單据
#                    LET g_t1=g_imr.imr01[1,3]
                    LET g_t1 = s_get_doc_no(g_imr.imr01)       #No.FUN-550029
                    CALL q_smy(FALSE,FALSE,g_t1,'AIM','C') RETURNING g_t1 #TQC-670008
#                    CALL FGL_DIALOG_SETBUFFER( g_t1 )
                   # LET g_imr.imr01[1,3]=g_t1
                    LET g_imr.imr01=g_t1        #No.FUN-550029
                    DISPLAY BY NAME g_imr.imr01
                    NEXT FIELD imr01
               WHEN INFIELD(imr03) #借料人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_imr.imr03
                    CALL cl_create_qry() RETURNING g_imr.imr03
#                    CALL FGL_DIALOG_SETBUFFER( g_imr.imr03 )
                    DISPLAY BY NAME g_imr.imr03
                    NEXT FIELD imr03
               WHEN INFIELD(imr04) #部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_imr.imr04
                    CALL cl_create_qry() RETURNING g_imr.imr04
#                    CALL FGL_DIALOG_SETBUFFER( g_imr.imr04 )
                    DISPLAY BY NAME g_imr.imr04
                    NEXT FIELD imr04
               WHEN INFIELD(imr05) #借料單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imo"
                    LET g_qryparam.default1 = g_imr.imr05
                    LET g_qryparam.where = " imopost = 'Y'"#TQC-CB0012 add
                    CALL cl_create_qry() RETURNING g_imr.imr05
#                    CALL FGL_DIALOG_SETBUFFER( g_imr.imr05 )
                    DISPLAY BY NAME g_imr.imr05
                    NEXT FIELD imr05
               OTHERWISE EXIT CASE
            END CASE
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
 
FUNCTION i010_imr03(p_cmd)
DEFINE
   p_cmd      LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
   l_gen02    LIKE gen_file.gen02,
   l_gen03    LIKE gen_file.gen03,
   l_gen04    LIKE gen_file.gen04,
   l_genacti  LIKE gen_file.genacti,
   l_gem02    LIKE gem_file.gem02
 
   LET g_errno=''
   SELECT gen02,gen03,gen04,genacti
     INTO l_gen02,l_gen03,l_gen04,l_genacti
     FROM gen_file
    WHERE gen01=g_imr.imr03
   CASE
       WHEN SQLCA.sqlcode=100   LET g_errno='aoo-070'
                                LET l_gen02=NULL
                                LET l_gen03=NULL
                                LET l_gen04=NULL
       WHEN l_genacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
 
   IF p_cmd='d' OR cl_null(g_errno)THEN
      DISPLAY l_gen02 TO FORMONLY.gen02
      DISPLAY l_gen03 TO imr04
      SELECT gem02 INTO l_gem02 FROM gem_file
       WHERE gem01=l_gen03
      IF SQLCA.sqlcode THEN LET l_gem02=' ' END IF
      DISPLAY l_gem02 TO gem02
   END IF
END FUNCTION
 
#Query 查詢
FUNCTION t308_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_imq.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t308_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t308_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imr.* TO NULL
    ELSE
        OPEN t308_count
        FETCH t308_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t308_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t308_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t308_cs INTO g_imr.imr01
        WHEN 'P' FETCH PREVIOUS t308_cs INTO g_imr.imr01
        WHEN 'F' FETCH FIRST    t308_cs INTO g_imr.imr01
        WHEN 'L' FETCH LAST     t308_cs INTO g_imr.imr01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                 PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t308_cs INTO g_imr.imr01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)
        INITIALIZE g_imr.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_imr.* FROM imr_file WHERE imr01 = g_imr.imr01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0) #No.FUN-660156
       CALL cl_err3("sel","imr_file",g_imr.imr01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
        INITIALIZE g_imr.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_imr.imruser #FUN-4C0053
        LET g_data_group = g_imr.imrgrup #FUN-4C0053
        LET g_data_plant = g_imr.imrplant #FUN-980030
    END IF
 
    CALL t308_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t308_show()
  DEFINE l_smydesc   LIKE smy_file.smydesc
 
    LET g_imr_t.* = g_imr.*                #保存單頭舊值
    DISPLAY BY NAME g_imr.imroriu,g_imr.imrorig,                              # 顯示單頭值
        g_imr.imr01,g_imr.imr02,g_imr.imr05,g_imr.imr09,
        g_imr.imr03,g_imr.imr04,g_imr.imr06,g_imr.imrconf, #FUN-660080 add g_imr.imrconf
        g_imr.imrpost,g_imr.imruser,g_imr.imrgrup,g_imr.imrmodu,
        g_imr.imrdate
 
#    LET g_t1=g_imr.imr01[1,3]
    LET g_t1 = s_get_doc_no(g_imr.imr01)       #No.FUN-550029
    SELECT smydesc INTO l_smydesc
      FROM smy_file
     WHERE smyslip = g_t1
    DISPLAY l_smydesc TO FORMONLY.smydesc
 
    CALL t308_imr03('d')
    CALL t308_imr04('d')
    IF g_imr.imrconf = 'X' THEN #FUN-660080
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"")
    CALL t308_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t308_r()
   DEFINE l_flag LIKE type_file.chr1  #FUN-B70074
    IF s_shut(0) THEN RETURN END IF
    IF g_imr.imr01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_imr.imrconf = 'Y' THEN #FUN-660080
        CALL cl_err(g_imr.imr01,'9023',0)
        RETURN
    END IF    
    IF g_imr.imrpost = 'Y' THEN
        CALL cl_err(g_imr.imr01,'afa-101',0)
        RETURN
    END IF
    IF g_imr.imrconf = 'X' THEN #FUN-660080
        CALL cl_err(g_imr.imr01,'axr-103',0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t308_cl USING g_imr.imr01
    IF STATUS THEN
       CALL cl_err("OPEN t308_cl:", STATUS, 1)
       CLOSE t308_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t308_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t308_cl ROLLBACK WORK RETURN
    END IF
   #CALL t308_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imr01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imr.imr01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM imr_file WHERE imr01 = g_imr.imr01
         DELETE FROM imq_file WHERE imq01 = g_imr.imr01
         #FUN-B70074-add-str--
         IF NOT s_industry('std') THEN 
            LET l_flag = s_del_imqi(g_imr.imr01,'','')
         END IF
         #FUN-B70074-add-end--
         INITIALIZE g_imr.* TO NULL
         CLEAR FORM
         CALL g_imq.clear()
         OPEN t308_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t308_cl
            CLOSE t308_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t308_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t308_cl
            CLOSE t308_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t308_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t308_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t308_fetch('/')
         END IF
    END IF
    CLOSE t308_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imr.imr01,'D')
END FUNCTION
 
#單身
FUNCTION t308_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_ima02         LIKE ima_file.ima02,    #品名規格
    l_ima05         LIKE ima_file.ima05,    #目前版本
    l_ima08         LIKE ima_file.ima08,    #來源碼
    l_ima25         LIKE ima_file.ima25,    #庫存單位
    l_imq10         LIKE imq_file.imq10,
    l_direct        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_imp04         LIKE imp_file.imp04,
    l_imp08         LIKE imp_file.imp08,
    l_message       LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(80)
    l_digcut        LIKE imq_file.imq07,    #MOD-530179
    l_digcut1       LIKE imq_file.imq07,    #MOD-530179
    l_keyinyes      LIKE imq_file.imq07,    #MOD-530179 #已登打數量
    l_keyinno       LIKE imq_file.imq07,    #MOD-530179 #未登打數量
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-690026 SMALLINT
 DEFINE l_imqi   RECORD LIKE imqi_file.*    #FUN-B70074
 DEFINE l_case      STRING                  #FUN-BB0083 add
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN RETURN END IF
 
    IF cl_null(g_imr.imr01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_imr.imrconf = 'Y' THEN #FUN-660080
        CALL cl_err(g_imr.imr01,'9023',0)
        RETURN
    END IF
    IF g_imr.imrpost = 'Y' THEN
        CALL cl_err(g_imr.imr01,'afa-101',0)
        RETURN
    END IF
    IF g_imr.imrconf = 'X' THEN #FUN-660080
        CALL cl_err(g_imr.imr01,'axr-103',0)
        RETURN
    END IF
 
    CALL t308_b_g()   #自動代出未全數償還之借料單身
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     "  SELECT imq02,imq03,imq04,''   ,''    , ",
     "         ''   ,''   ,imq07,''   ,imq11, ",
     "        imq12,imq930,'' ",  #FUN-670093
     "  FROM imq_file  ",
     "  WHERE imq01 = ? ",
     "    AND imq02 = ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t308_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
 
    LET l_ac_t = 0
 
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_imq WITHOUT DEFAULTS FROM s_imq.*
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
           BEGIN WORK
           OPEN t308_cl USING g_imr.imr01
           IF STATUS THEN
              CALL cl_err("OPEN t308_cl:", STATUS, 1)
              CLOSE t308_cl
              ROLLBACK WORK
              RETURN
           ELSE
              FETCH t308_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                 CLOSE t308_cl
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_imq_t.* = g_imq[l_ac].*  #BACKUP
              LET g_imp05_t = g_imq[l_ac].imp05     #FUN-BB0083 add
 
              OPEN t308_bcl USING g_imr.imr01,g_imq_t.imq02
              DISPLAY g_imr.imr01,g_imq_t.imq02
              IF STATUS THEN
                 CALL cl_err("OPEN t308_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t308_bcl INTO g_imq[l_ac].*
                 IF SQLCA.sqlcode THEN
                     CALL cl_err(g_imq_t.imq02,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                 END IF
                 LET g_imq[l_ac].gem02c=s_costcenter_desc(g_imq[l_ac].imq930) #FUN-670093
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
           CALL t308_imq04('d')
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            INSERT INTO imq_file (imq01,imq02,imq03,imq04,imq05,imq06,imq06_fac,
                                  imq07,imq08,imq09,imq10,imq11,imq12,imq13,
                                # imq14,imq15,imq16,imq17,imq18,imq19,imq20,imq930,imqpalnt,imqlegal) #FUN-670093 #FUN-980004 add imqplant,imqlegal   #TQC-AC0202 mark
                                  imq14,imq15,imq16,imq17,imq18,imq19,imq20,imq930,imqplant,imqlegal) #TQC-AC0202
                 VALUES(g_imr.imr01,g_imq[l_ac].imq02,g_imq[l_ac].imq03,
                        g_imq[l_ac].imq04,NULL,g_imq[l_ac].imp05,1,
                        g_imq[l_ac].imq07,NULL,NULL,NULL,g_imq[l_ac].imq11,
                        g_imq[l_ac].imq12,NULL,NULL,NULL,NULL,NULL,NULL,
                        NULL,NULL,g_imq[l_ac].imq930,g_plant,g_legal) #FUN-670093 #FUN-980004 add g_plant,g_legal
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_imq[l_ac].imq02,SQLCA.sqlcode,0) #No.FUN-660156
               CALL cl_err3("ins","imq_file",g_imq[l_ac].imq02,"",
                             SQLCA.sqlcode,"","",1)  #No.FUN-660156
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_imq[l_ac].* TO NULL      #900423
            LET g_imq[l_ac].imq07 = 0
            LET g_imq[l_ac].imq11 = 0
            LET g_imq[l_ac].imq930 = s_costcenter(g_imr.imr04) #FUN-670093
            LET g_imq[l_ac].gem02c = s_costcenter_desc(g_imq[l_ac].imq930) #FUN-670093
            LET g_imq_t.* = g_imq[l_ac].*         #新輸入資料
            LET g_imp05_t = NULL         #FUN-BB0083 add
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD imq02
 
        BEFORE FIELD imq02                        #default 序號
            IF g_imq[l_ac].imq02 IS NULL OR
               g_imq[l_ac].imq02 = 0 THEN
                SELECT max(imq02)+1
                   INTO g_imq[l_ac].imq02
                   FROM imq_file
                   WHERE imq01 = g_imr.imr01
                IF g_imq[l_ac].imq02 IS NULL THEN
                    LET g_imq[l_ac].imq02 = 1
                END IF
#               DISPLAY g_imq[l_ac].imq02 TO s_imq[l_sl].imq02 #No.FUN-570273預設值不可使用
            END IF
 
        AFTER FIELD imq02                        #check 序號是否重複
            IF g_imq[l_ac].imq02 != g_imq_t.imq02 OR
               g_imq_t.imq02 IS NULL THEN
                SELECT count(*) INTO l_n FROM imq_file
                 WHERE imq01 = g_imr.imr01
                   AND imq02 = g_imq[l_ac].imq02
                IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_imq[l_ac].imq02 = g_imq_t.imq02
                    NEXT FIELD imq02
                END IF
            END IF
 
        AFTER FIELD imq03 #借料編號
            IF NOT cl_null(g_imq[l_ac].imq03) THEN
                IF NOT cl_null(g_imr.imr05) THEN
                    IF g_imq[l_ac].imq03 != g_imr.imr05 THEN
                        #此單身借料單號與單頭的借料單號不同!
                        CALL cl_err(g_imq[l_ac].imq03,'aim-113',0)
                        LET g_imq[l_ac].imq03 = g_imq_t.imq03
                        DISPLAY g_imq[l_ac].imq03 TO s_imq[l_sl].imq03
                        NEXT FIELD imq03
                    END IF
                END IF
                CALL t308_imr05(g_imq[l_ac].imq03)
                IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_imq[l_ac].imq03,g_errno,0)
                    LET g_imq[l_ac].imq03 = g_imq_t.imq03
                    DISPLAY g_imq[l_ac].imq03 TO s_imq[l_sl].imq03
                    NEXT FIELD imq03
                END IF
            END IF
 
        AFTER FIELD imq04 #借料編號-項次
           LET l_case = "" #FUN-C20048 add
           IF NOT cl_null(g_imq[l_ac].imq04)THEN
               CALL t308_imq04('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_imq[l_ac].imq03,g_errno,0)
                   LET g_imq[l_ac].imq03 = g_imq_t.imq03
                   LET g_imq[l_ac].imq04 = g_imq_t.imq04
                   DISPLAY g_imq[l_ac].imq03 TO s_imq[l_sl].imq03
                   DISPLAY g_imq[l_ac].imq04 TO s_imq[l_sl].imq04
                   NEXT FIELD imq03
               #FUN-670093...............begin
               ELSE
                  SELECT imp930 INTO g_imq[l_ac].imq930 FROM imp_file
                                                       WHERE imp01=g_imq[l_ac].imq03
                                                         AND imp02=g_imq[l_ac].imq04
                  LET g_imq[l_ac].gem02c=s_costcenter_desc(g_imq[l_ac].imq930) #FUN-670093
                  DISPLAY g_imq[l_ac].imq930 TO s_imq[l_sl].imq930
                  DISPLAY g_imq[l_ac].gem02c TO s_imq[l_sl].gem02c
               #FUN-670093...............end      
               END IF
           END IF
           SELECT imp04,imp08 INTO l_imp04,l_imp08
             FROM imp_file
            WHERE imp01 = g_imq[l_ac].imq03
              AND imp02 = g_imq[l_ac].imq04
           #還>借
           IF l_imp08 >= l_imp04 THEN
               #借料數量已還清!
               CALL cl_err('','aim-116',0)
               NEXT FIELD imq03
           END IF
           IF p_cmd = 'a' OR g_imq[l_ac].imq03 <> g_imq_t.imq03 OR
                             g_imq[l_ac].imq04 <> g_imq_t.imq04 THEN
                    SELECT SUM(imq07/imq06_fac)
                      INTO l_keyinyes #已登打的數量
                      FROM imq_file,imr_file
                     WHERE imq03 = g_imq[l_ac].imq03
                       AND imq04 = g_imq[l_ac].imq04
                       AND imrconf <> 'X' #作廢的不算  #FUN-660080
                       AND imr01 = imq01
                    IF cl_null(l_keyinyes) THEN
                        LET l_keyinyes = 0
                    END IF
                    #  已登打數量 >= 借料數量
                    IF l_keyinyes >= l_imp04 THEN
                        LET l_message = NULL
                        LET l_message = g_imq[l_ac].imq03,'+',g_imq[l_ac].imq04
                        #未登打數量等於零
                        CALL cl_err(l_message,'aim-118',0)
                        INITIALIZE g_imq[l_ac].* TO NULL
                        DISPLAY g_imq[l_ac].* TO s_imq[l_sl].*
                        NEXT FIELD imq02
                    END IF
           END IF
           #FUN-BB0083---add---str
           IF NOT cl_null(g_imq[l_ac].imq07) AND g_imq[l_ac].imq07<>0 THEN   #FUN-C20048 add
              CALL t308_imq07_check() RETURNING l_case
           END IF  #FUN-C20048 add
           LET g_imp05_t = g_imq[l_ac].imp05
           CASE l_case
              WHEN "imq03"
                 NEXT FIELD imq03
              WHEN "imq07"
                 NEXT FIELD imq07
              OTHERWISE EXIT CASE
           END CASE
           #FUN-BB0083---add---end

        BEFORE FIELD imq07
           #當下那筆還料數量
           LET l_digcut = g_imq[l_ac].imq07
           IF cl_null(l_digcut) THEN
               LET l_digcut = 0
           END IF
 
           #原本的還料數量
           LET l_digcut1 = g_imq_t.imq07
           IF cl_null(l_digcut1) THEN
               LET l_digcut1 = 0
           END IF
 
           SELECT SUM(imq07/imq06_fac)
             INTO l_keyinyes #已登打的數量
             FROM imq_file,imr_file
            WHERE imq03 = g_imq[l_ac].imq03
              AND imq04 = g_imq[l_ac].imq04
              AND imrconf <> 'X' #作廢的不算 #FUN-660080
              AND imr01 = imq01
           IF cl_null(l_keyinyes) THEN
               LET l_keyinyes = 0
           END IF
           LET l_keyinyes = l_keyinyes - l_digcut1 #已登打數量 - 原本的  還料數量
           LET l_keyinyes = l_keyinyes + l_digcut  #已登打數量 + 當下那筆還料數量
           IF l_keyinyes > g_imq[l_ac].imp04 THEN
               LET l_keyinno = 0 #未登打數量
           ELSE
               LET l_keyinno = g_imq[l_ac].imp04 - l_keyinyes #未登打數量
           END IF
           LET l_message = NULL
           LET l_message =   '借料:',g_imq[l_ac].imp04 USING '#######&.&',g_imq[l_ac].imp05,' ',
                           '已登打:',       l_keyinyes USING '#######&.&',g_imq[l_ac].imp05,' ',
                           '未登打:',       l_keyinno  USING '#######&.&',g_imq[l_ac].imp05
           ERROR l_message
        AFTER FIELD imq07
           #FUN-BB0083---add---str
            CALL t308_imq07_check() RETURNING l_case
            CASE l_case
               WHEN "imq03"
                  NEXT FIELD imq03
               WHEN "imq07"
                  NEXT FIELD imq07
               OTHERWISE EXIT CASE
            END CASE
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---str
           #IF g_imq[l_ac].imq07 = 0 THEN
           #    CALL cl_err('','mfg1322',1)
           #    NEXT FIELD imq07
           #END IF
           #IF NOT cl_null(g_imq[l_ac].imq07) THEN
           #    LET g_imq[l_ac].imq12 = g_imq[l_ac].imq07*g_imq[l_ac].imq11
           #    DISPLAY g_imq[l_ac].imq12 TO s_imq[l_sl].imq12
           #    #當下那筆還料數量
           #    LET l_digcut = g_imq[l_ac].imq07
           #    IF cl_null(l_digcut) THEN
           #        LET l_digcut = 0
           #    END IF
           #
           #    #原本的還料數量
           #    LET l_digcut1 = g_imq_t.imq07
           #    IF cl_null(l_digcut1) THEN
           #        LET l_digcut1 = 0
           #    END IF
           # 
           #    SELECT SUM(imq07/imq06_fac)
           #      INTO l_keyinyes #已登打的數量
           #      FROM imq_file,imr_file
           #     WHERE imq03 = g_imq[l_ac].imq03
           #       AND imq04 = g_imq[l_ac].imq04
           #       AND imrconf <> 'X' #作廢的不算 #FUN-660080
           #       AND imr01 = imq01
           #    IF cl_null(l_keyinyes) THEN
           #        LET l_keyinyes = 0
           #    END IF
           #    LET l_keyinyes = l_keyinyes - l_digcut1 #已登打數量 - 原本的  還料數量
           #    LET l_keyinyes = l_keyinyes + l_digcut  #已登打數量 + 當下那筆還料數量
           #    IF l_keyinyes > g_imq[l_ac].imp04 THEN
           #        LET l_keyinno = 0 #未登打數量
           #    ELSE
           #        LET l_keyinno = g_imq[l_ac].imp04 - l_keyinyes #未登打數量
           #    END IF
           #             #借,還
           #    SELECT imp04,imp08 INTO l_imp04,l_imp08
           #      FROM imp_file
           #     WHERE imp01 = g_imq[l_ac].imq03
           #       AND imp02 = g_imq[l_ac].imq04
           #    #還>借
           #    IF l_imp08 >= l_imp04 THEN
           #        #借料數量已還清!
           #        CALL cl_err('','aim-116',1)
           #        NEXT FIELD imq03
           #    END IF
           # 
           #    #  已登打數量 > 借料數量
           #    IF l_keyinyes > l_imp04 THEN
           #        CALL cl_err('','aim-117',1)
           #        LET g_imq[l_ac].imq07 = g_imq_t.imq07
           #        DISPLAY g_imq[l_ac].imq07 TO s_imq[l_sl].imq07
           #        NEXT FIELD imq07
           #    END IF
           #END IF
           #FUN-BB0083---mark---end
    
        AFTER FIELD imq11
           IF cl_null(g_imq[l_ac].imq11) THEN
               LET g_imq[l_ac].imq11 = 0
           END IF
           LET g_imq[l_ac].imq12 = g_imq[l_ac].imq07*g_imq[l_ac].imq11
           DISPLAY g_imq[l_ac].imq12 TO s_imq[l_sl].imq12
        #FUN-670093...............begin
        AFTER FIELD imq930 
           IF NOT s_costcenter_chk(g_imq[l_ac].imq930) THEN
              LET g_imq[l_ac].imq930=g_imq_t.imq930
              LET g_imq[l_ac].gem02c=g_imq_t.gem02c
              DISPLAY BY NAME g_imq[l_ac].imq930,g_imq[l_ac].gem02c
              NEXT FIELD imq930
           ELSE
              LET g_imq[l_ac].gem02c=s_costcenter_desc(g_imq[l_ac].imq930)
              DISPLAY BY NAME g_imq[l_ac].gem02c
           END IF
        #FUN-670093...............end
 
        BEFORE DELETE                            #是否取消單身
            IF g_imq_t.imq02 > 0 AND
               g_imq_t.imq02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM imq_file
                    WHERE imq01 = g_imr.imr01
                      AND imq02 = g_imq_t.imq02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_imq_t.imq02,SQLCA.sqlcode,0) #No.FUN-660156
                   CALL cl_err3("del","imq_file",g_imq_t.imq02,"",
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    ROLLBACK WORK
                    CANCEL DELETE
                #FUN-B70074-add-str--
                ELSE
                   IF NOT s_industry('std') THEN 
                      IF NOT s_del_imqi(g_imr.imr01,g_imq_t.imq02,'')  THEN 
                         ROLLBACK WORK
                         CANCEL DELETE
                      END IF
                   END IF
                #FUN-B70074-add-end--
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imq[l_ac].* = g_imq_t.*
               CLOSE t308_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_imq[l_ac].imq02,-263,1)
                LET g_imq[l_ac].* = g_imq_t.*
            ELSE
                UPDATE imq_file
                   SET imq02=g_imq[l_ac].imq02,
                       imq03=g_imq[l_ac].imq03,
                       imq04=g_imq[l_ac].imq04,
                       imq07=g_imq[l_ac].imq07,
                       imq11=g_imq[l_ac].imq11,
                       imq12=g_imq[l_ac].imq12,
                       imq930=g_imq[l_ac].imq930 #FUN-670093
                 WHERE imq01=g_imr.imr01
                   AND imq02=g_imq_t.imq02
                IF SQLCA.sqlcode THEN
#                  CALL cl_err(g_imq[l_ac].imq02,SQLCA.sqlcode,0) #No.FUN-660156
                   CALL cl_err3("upd","imq_file",g_imr.imr01,g_imq_t.imq02,
                                 SQLCA.sqlcode,"","",1)  #No.FUN-660156
                    LET g_imq[l_ac].* = g_imq_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D40030 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_imq[l_ac].* = g_imq_t.*
              #FUN-D40030--add--str--
              ELSE
                 CALL g_imq.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D40030--add--end--
              END IF
              CLOSE t308_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D40030 Add
           CLOSE t308_bcl
           COMMIT WORK
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imq03) #借料號號-項次
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imp1"
                    LET g_qryparam.default1 = g_imq[l_ac].imq03
                    LET g_qryparam.default2 = g_imq[l_ac].imq04
                    LET g_qryparam.where = " imp01 IN (SELECT imo01 FROM imo_file WHERE imopost = 'Y') "#TQC-CB0012 add
                    CALL cl_create_qry() RETURNING g_imq[l_ac].imq03,g_imq[l_ac].imq04
#                    CALL FGL_DIALOG_SETBUFFER( g_imq[l_ac].imq03 )
#                    CALL FGL_DIALOG_SETBUFFER( g_imq[l_ac].imq04 )
                     DISPLAY BY NAME g_imq[l_ac].imq03,g_imq[l_ac].imq04  #No.MOD-490371
                    NEXT FIELD imq03
               WHEN INFIELD(imq04) #借料號號-項次
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imp1"
                    LET g_qryparam.default1 = g_imq[l_ac].imq03
                    LET g_qryparam.default2 = g_imq[l_ac].imq04
                    LET g_qryparam.where = " imp01 IN (SELECT imo01 FROM imo_file WHERE imopost = 'Y') "#TQC-CB0012 add
                    CALL cl_create_qry() RETURNING g_imq[l_ac].imq03,g_imq[l_ac].imq04
#                    CALL FGL_DIALOG_SETBUFFER( g_imq[l_ac].imq03 )
#                    CALL FGL_DIALOG_SETBUFFER( g_imq[l_ac].imq04 )
                     DISPLAY BY NAME g_imq[l_ac].imq03,g_imq[l_ac].imq04  #No.MOD-490371
                    NEXT FIELD imq04
              #FUN-670093...............begin
              WHEN INFIELD(imq930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_imq[l_ac].imq930
                 DISPLAY BY NAME g_imq[l_ac].imq930
                 NEXT FIELD imq930
              #FUN-670093...............end
              OTHERWISE EXIT CASE
            END CASE
 
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
 
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
    END INPUT
 
   #start FUN-5A0029
    LET g_imr.imrmodu = g_user
    LET g_imr.imrdate = g_today
    UPDATE imr_file SET imrmodu = g_imr.imrmodu,imrdate = g_imr.imrdate
     WHERE imr01 =  g_imr.imr01
    DISPLAY BY NAME g_imr.imrmodu,g_imr.imrdate
   #end FUN-5A0029
 
    CLOSE t308_bcl
    COMMIT WORK
#   CALL t308_delall()  #CHI-C30002 mark
    CALL t308_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t308_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_imr.imr01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM imr_file ",
                  "  WHERE imr01 LIKE '",l_slip,"%' ",
                  "    AND imr01 > '",g_imr.imr01,"'"
      PREPARE t308_pb1 FROM l_sql 
      EXECUTE t308_pb1 INTO l_cnt 
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
        #CALL t308_x()     #CHI-D20010
         CALL t308_x(1)    #CHI-D20010
         IF g_imr.imrconf = 'X' THEN #FUN-660080
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM imr_file WHERE imr01 = g_imr.imr01
         INITIALIZE g_imr.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t308_delall()
#   SELECT COUNT(*) INTO g_cnt FROM imq_file
#       WHERE imq01 = g_imr.imr01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM imr_file WHERE imr01 = g_imr.imr01
#      CLEAR FORM
#  CALL g_imq.clear()
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t308_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON imq02,imq03,imq04,imq05,imq08,imq09,imq10,
                       imq06,imq07
                                            # 螢幕上取單身條件
         FROM s_imq[1].imq02,s_imq[1].imq03,s_imq[1].imq04,
              s_imq[1].imq05,s_imq[1].imq08,s_imq[1].imq09,
              s_imq[1].imq10,s_imq[1].imq06,s_imq[1].imq07
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
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
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t308_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t308_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(500)
 
    IF cl_null(p_wc2) THEN
        LET p_wc2 = " 1=1"
    END IF
    LET g_sql =
        "SELECT imq02,imq03,imq04,imp03,ima02, ",
        "       imp05,imp04,imq07,imp09,imq11,imq12,imq930,'' ", #FUN-670093
        " FROM imq_file, imp_file,imr_file,OUTER ima_file",
        " WHERE imq01 ='",g_imr.imr01,"'", #單頭
        "   AND imq03 = imp01 ",
        "   AND imq04 = imp02 ",
        "   AND ",p_wc2 CLIPPED,           #單身
        "   AND imr00 = '2' ",#原價償還
        "   AND imr01 = imq01",
        "   AND imp_file.imp03 = ima_file.ima01 ",
        " ORDER BY 1,2,3"
    PREPARE t308_pb FROM g_sql
    DECLARE imq_curs                       #CURSOR
        CURSOR FOR t308_pb
 
    CALL g_imq.clear()
    LET g_cnt = 1
    FOREACH imq_curs INTO g_imq[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_imq[g_cnt].gem02c=s_costcenter_desc(g_imq[g_cnt].imq930) #FUN-670093
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_imq.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t308_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_imq TO s_imq.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      #FUN-D10081---add---str---
      ON ACTION page_list 
         LET g_action_flag="page_list"
         EXIT DISPLAY
      #FUN-D10081---add---end---
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
         CALL t308_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t308_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t308_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t308_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t308_fetch('L')
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_imr.imrconf = 'X' THEN #FUN-660080
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") #FUN-660080
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #FUN-660080...............begin
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #FUN-660080...............end
    #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0030------Begin--------------                                                                                             
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
#No.FUN-6B0030-----End------------------  
 
 
      #No.FUN-7C0050 add
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
#--------------------------------------------------------------------#
#更新相關的檔案
#--------------------------------------------------------------------#
FUNCTION t308_imr04(p_cmd)    #
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_gem02     LIKE gem_file.gem02,
         l_gemacti   LIKE gem_file.gemacti
 
  LET g_errno = ' '
  SELECT gem02,gemacti INTO l_gem02,l_gemacti
    FROM gem_file
   WHERE gem01 = g_imr.imr04
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno  = '100'
                                 LET l_gem02  = NULL
                                 LET l_gemacti= NULL
       WHEN l_gemacti='N'        LET g_errno = '9028'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd='d' OR cl_null(g_errno) THEN
     DISPLAY l_gem02  TO FORMONLY.gem02
  END IF
END FUNCTION
 
FUNCTION t308_b_g()   #自動代出未全數償還之借料單身
  DEFINE  l_imp_g         RECORD LIKE imp_file.*,  #產生用,借料資料單身檔
          l_imq_g         RECORD LIKE imq_file.*,  #產生用,還料明細資料檔
          l_n             LIKE type_file.num10,   #No.FUN-690026 INTEGER
          l_imp04_08      LIKE imp_file.imp04,
          l_imq12         LIKE imq_file.imq12,
          l_keyinyes      LIKE imq_file.imq07,#MOD-530179  #已登打數量
          l_keyinno       LIKE imq_file.imq07 #MOD-530179  #未登打數量
   DEFINE l_imqi          RECORD LIKE imqi_file.*   #FUN-B70074
   IF cl_null(g_imr.imr05) THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM imq_file
    WHERE imq01 = g_imr.imr01
   IF l_n > 0 THEN RETURN END IF
   #自動代出未全數償還之借料單身(Y/N)?
   IF NOT cl_confirm('aim-415') THEN RETURN END IF
   DECLARE imp_cur_g CURSOR FOR
    SELECT * FROM imp_file
     WHERE imp01 = g_imr.imr05
       AND imp07 <> 'Y'
   BEGIN WORK
   LET g_success = 'Y'
   LET g_cnt = 1
   FOREACH imp_cur_g INTO l_imp_g.*
       IF SQLCA.sqlcode THEN LET g_success = 'N' EXIT FOREACH END IF
       IF cl_null(l_imp_g.imp09) THEN
           LET l_imp_g.imp09 = 0
       END IF
      #LET l_imp04_08 = l_imp_g.imp04 - l_imp_g.imp08
      #LET l_imp09_c  = l_imp04_08 * l_imp_g.imp09
      #IF l_imp04_08 <=0 THEN
      #    CONTINUE FOREACH
      #END IF
       SELECT SUM(imq07/imq06_fac)
         INTO l_keyinyes #已登打的數量
         FROM imq_file,imr_file
        WHERE imq03 = l_imp_g.imp01
          AND imq04 = l_imp_g.imp02
          AND imrconf <> 'X' #作廢的不算 #FUN-660080
          AND imr01 = imq01
       IF cl_null(l_keyinyes) THEN
           LET l_keyinyes = 0
       END IF
       LET l_keyinno = l_imp_g.imp04 - l_keyinyes #未登打數量
       LET l_keyinno = s_digqty(l_keyinno,l_imp_g.imp05) #FUN-BB0083 add
       IF l_keyinno<=0 THEN
           CONTINUE FOREACH
       END IF
       LET l_imq12 = l_keyinno * l_imp_g.imp09    #實償金額
{
       INSERT INTO imq_file (imq01,    imq02,imq03,imq04,imq05,
                             imq06,imq06_fac,imq07,imq08,imq09,
                             imq10,imq11    ,imq12,imq13,imq14,
                             imq15,imq16    ,imq17,imq18,imq19,
                             imq20)
}
       
        INSERT INTO imq_file (imq01,imq02,imq03,imq04,imq05,imq06,imq06_fac,  #No.MOD-470041
                             imq07,imq08,imq09,imq10,imq11,imq12,imq13,imq14,
                             imq15,imq16,imq17,imq18,imq19,imq20,imq930,imqplant,imqlegal) #FUN-670093 #FUN-980004 add imqplant,imqlegal
            VALUES (g_imr.imr01,g_cnt,l_imp_g.imp01,l_imp_g.imp02,
                    l_imp_g.imp03,l_imp_g.imp05,1,l_keyinno,NULL,NULL,
                    NULL,l_imp_g.imp09,l_imq12,NULL,NULL,NULL,NULL,
                    NULL,NULL,NULL,NULL,l_imp_g.imp930,g_plant,g_legal) #FUN-670093 #FUN-980004 add g_plant,g_legal 
       IF SQLCA.sqlcode THEN
#         CALL cl_err(g_imr.imr05,SQLCA.sqlcode,0) #No.FUN-660156
          CALL cl_err3("ins","imq_file",g_imr.imr01,"",
                        SQLCA.sqlcode,"","",1)  #No.FUN-660156
          LET g_success = 'N'
          EXIT FOREACH
       #FUN-B70074-add-str--
       ELSE
          IF NOT s_industry('std') THEN
             INITIALIZE l_imqi.* TO NULL
             LET l_imqi.imqi01 = g_imr.imr01
             LET l_imqi.imqi02 = g_cnt
             IF NOT s_ins_imqi(l_imqi.*,g_plant) THEN
                LET g_success = 'N'
                EXIT FOREACH
             END IF
       END IF
       #FUN-B70074-add-end--
       END IF
       LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_success = 'Y' THEN
       COMMIT WORK
   ELSE
       ROLLBACK WORK
   END IF
   CALL t308_show()
END FUNCTION
 
FUNCTION t308_imr05(p_imr05)
   DEFINE   l_imo07   LIKE imo_file.imo07,
            l_imoconf LIKE imo_file.imoconf,
            l_imopost LIKE imo_file.imopost,
            p_imr05   LIKE imr_file.imr05
 
       LET g_errno=''
       SELECT imo07,imoconf,imopost
         INTO l_imo07,l_imoconf,l_imopost
         FROM imo_file
        WHERE imo01 = p_imr05
        CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='aim-410' #無此借料單號!
                                     LET l_imo07=NULL
                                     LET l_imoconf=NULL
                                     LET l_imopost=NULL
            WHEN l_imo07='Y'         LET g_errno='aim-411' #此借料單據已結案!
            WHEN l_imoconf='N'       LET g_errno='9029'    #此筆資料尚未確認, 不可使用
            WHEN l_imoconf='X'       LET g_errno='9024'    #此筆資料已作廢
            WHEN l_imopost='N'       LET g_errno='aim-206  #單據尚未過帳!
            OTHERWISE
                 LET g_errno=SQLCA.sqlcode USING '------'
        END CASE
END FUNCTION
 
FUNCTION t308_s() #扣帳
  DEFINE l_imp08   LIKE imp_file.imp08,
         l_imo07   LIKE imo_file.imo07,
         l_imq03   LIKE imq_file.imq03,
         l_imq04   LIKE imq_file.imq04,
         l_sum1    LIKE imq_file.imq07,   #MOD-530179
         l_sum2    LIKE imq_file.imq07,   #MOD-530179
         l_mess    LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(20)
         l_return  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  DEFINE l_imr09   LIKE imr_file.imr09  #FUN-6B0038 add
  DEFINE l_yy,l_mm LIKE type_file.num5  #FUN-6B0038
 
 
    SELECT * INTO g_imr.* FROM imr_file WHERE imr01=g_imr.imr01
    IF cl_null(g_imr.imr01) THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_imr.imrconf='N' THEN CALL cl_err('','aba-100',0) RETURN END IF #FUN-660080
    IF g_imr.imrpost='Y' THEN CALL cl_err(g_imr.imr01,'aar-347',0) RETURN END IF
    IF g_imr.imrconf='X' THEN CALL cl_err('','9024',0) RETURN END IF #已作廢 #FUN-660080
    IF NOT cl_null(g_imr.imr05) THEN
        SELECT imo07 INTO l_imo07
          FROM imo_file
         WHERE imo01 = g_imr.imr05
        IF l_imo07 = 'Y' THEN
            #此借料單據已結案!
            CALL cl_err(g_imr.imr05,'aim-411',0)
            RETURN
        END IF
    ELSE
        SELECT COUNT(*) INTO g_cnt
          FROM imq_file
         WHERE imq01=g_imr.imr01
           AND (imq03 IS NULL OR imq03 = ' ')
        IF g_cnt >=1 THEN
            #單身借料單號欄位不可空白!
            CALL cl_err(g_imr.imr01,'aim-416',0)
            RETURN
        END IF
    END IF
    DECLARE t308_s_cur CURSOR FOR
        SELECT UNIQUE imq03,imq04
          FROM imq_file
        WHERE imq01 = g_imr.imr01
    LET l_return = 'N'
    FOREACH t308_s_cur INTO l_imq03,l_imq04
        SELECT COUNT(*) INTO g_cnt
          FROM imp_file
         WHERE imp01 = l_imq03 #借料單號
           AND imp02 = l_imq04 #借料項次
           AND imp07 = 'Y'
        IF g_cnt > 0 THEN
            LET l_mess=''
            LET l_mess = l_imq03 CLIPPED,'+',l_imq04 CLIPPED
            #此借料單據已結案!
            CALL cl_err(l_mess,'aim-411',1)
            LET l_return = 'Y'
        END IF
        LET l_sum1 = 0
        LET l_sum2 = 0
        SELECT SUM(imq07/imq06_fac)
          INTO l_sum1 #此次要償還的數量
          FROM imq_file
         WHERE imq01 = g_imr.imr01
           AND imq03 = l_imq03
           AND imq04 = l_imq04
        SELECT (imp04-imp08)
          INTO l_sum2 #未償還的數量
          FROM imp_file
         WHERE imp01 = l_imq03
           AND imp02 = l_imq04
        IF l_sum1 > l_sum2 THEN
            LET l_mess=''
            LET l_mess = l_imq03 CLIPPED,'+',l_imq04 CLIPPED
            #此次償還的數量>未償還的數量
            CALL cl_err(l_mess,'aim-418',1)
            LET l_return = 'Y'
        END IF
    END FOREACH
    IF l_return = 'Y' THEN RETURN END IF
    IF NOT cl_sure(21,20) THEN RETURN END IF
 
   #FUN-6B0038 add
    INPUT l_imr09 WITHOUT DEFAULTS FROM imr09
      BEFORE INPUT
       #LET l_imr09 = g_imr.imr09       #TQC-750131 mark
        LET l_imr09 = g_today           #TQC-750131 mod
        DISPLAY l_imr09 TO imr09
  
      AFTER FIELD imr09
        IF NOT cl_null(l_imr09) THEN
           IF g_sma.sma53 IS NOT NULL AND l_imr09 <= g_sma.sma53 THEN
                CALL cl_err('','mfg9999',0) NEXT FIELD imr09
           END IF
            CALL s_yp(l_imr09) RETURNING l_yy,l_mm
  
            IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
                   CALL cl_err('','mfg6090',0)
                   NEXT FIELD imr09
            END IF
         END IF
 
         #-----TQC-860018---------
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         #-----END TQC-860018-----
    END INPUT
   #FUN-6B0038--end
    IF INT_FLAG THEN LET INT_FLAG = 0 LET g_success = 'N' RETURN END IF  #CHI-930007
 
    LET g_success='Y'
    BEGIN WORK
    OPEN t308_cl USING g_imr.imr01
    FETCH t308_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
 
   #-----------No.MOD-760061 add
    IF cl_null(l_imr09) THEN LET l_imr09 = g_today END IF  
    LET g_imr.imr09=l_imr09        
    DISPLAY BY NAME g_imr.imr09    
   #-----------No.MOD-760061 end
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t308_cl ROLLBACK WORK RETURN
    END IF
       DECLARE t308_s_cs CURSOR FOR
         SELECT * FROM imq_file WHERE imq01=g_imr.imr01
 
       CALL s_showmsg_init()      #No.FUN-710025
       FOREACH t308_s_cs INTO b_imq.*
       #No.FUN-710025--Begin--                                                                                                      
         IF g_success='N' THEN                                                                                                        
            LET g_totsuccess='N'                                                                                                      
            LET g_success="Y"                                                                                                         
         END IF                                                                                                                       
       #No.FUN-710025--End-
       # CALL t308_t()
         SELECT imp08 INTO l_imp08
           FROM imp_file
          WHERE imp01 = b_imq.imq03
            AND imp02 = b_imq.imq04
 
         UPDATE imp_file
            SET imp08 = l_imp08 + b_imq.imq07
          WHERE imp01 = b_imq.imq03
            AND imp02 = b_imq.imq04
        #No.FUN-710025--Begin--
        #IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
        #IF g_success='N' THEN EXIT FOREACH END IF
         IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN 
         LET g_showmsg = b_imq.imq03,"/",b_imq.imq04
         CALL s_errmsg('imp01,imp02',g_showmsg,'upd imp',SQLCA.sqlcode,1)
         LET g_success='N' END IF
         IF g_success='N' THEN CONTINUE FOREACH END IF
        #No.FUN-710025--End--
       END FOREACH
       #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
       #No.FUN-710025--End--
 
   #-----------No.MOD-760061 mark
   #IF cl_null(l_imr09) THEN LET l_imr09 = g_today END IF  #FUN-6B0038
   #LET g_imr.imr09=l_imr09        #FUN-6B0038
   #DISPLAY BY NAME g_imr.imr09    #FUN-6B0038
   #-----------No.MOD-760061 end
    MESSAGE ""
    UPDATE imr_file
       #SET imr09 = g_today,    #FUN-6B0038
       SET imr09 = g_imr.imr09, #FUN-6B0038
           imrpost='Y',
           imrmodu=g_user,
           imrdate=g_today
     WHERE imr01=g_imr.imr01
     #No.FUN-710025--Begin--
     #IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
      IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN
      CALL s_errmsg('imr01',g_imr.imr01,'upd imr',SQLCA.sqlcode,1)
      LET g_success='N' 
      END IF
      CALL s_showmsg()
     #No.FUN-710025--End--
    IF g_success = 'Y'
       THEN
       #LET g_imr.imr09=g_today     #FUN-6B0038
       LET g_imr.imrpost='Y'
       LET g_imr.imrmodu=g_user
       LET g_imr.imrdate=g_today
       CALL cl_cmmsg(1) COMMIT WORK
       CALL cl_flow_notify(g_imr.imr01,'S')
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
    DISPLAY BY NAME g_imr.imr09,g_imr.imrpost,g_imr.imrmodu,g_imr.imrdate
END FUNCTION
FUNCTION t308_w()
  DEFINE  l_qty     LIKE img_file.img08,
          l_imp08   LIKE imp_file.imp08,
          l_imo07   LIKE imo_file.imo07,
          l_imq03   LIKE imq_file.imq03,
          l_imq04   LIKE imq_file.imq04,
          l_mess    LIKE type_file.chr1000,#No.FUN-690026 VARCHAR(20)
          l_return  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
  DEFINE  l_yy,l_mm LIKE type_file.num5    #CHI-C70017
  
    SELECT * INTO g_imr.* FROM imr_file WHERE imr01=g_imr.imr01
    IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_imr.imrconf='N' THEN RETURN END IF #FUN-660080
    IF g_imr.imrconf='X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660080
    IF g_imr.imrpost='N' THEN CALL cl_err('','afa-108',1)RETURN END IF #FUN-660080
    IF NOT cl_null(g_imr.imr05) THEN
        SELECT imo07 INTO l_imo07
          FROM imo_file
         WHERE imo01 = g_imr.imr05
        IF l_imo07 = 'Y' THEN
            #此借料單據已結案!
            CALL cl_err(g_imr.imr05,'aim-411',0)
            RETURN
        END IF
    ELSE
        SELECT COUNT(*) INTO g_cnt
          FROM imq_file
         WHERE imq01=g_imr.imr01
           AND (imq03 IS NULL OR imq03 = ' ')
        IF g_cnt >=1 THEN
            #單身借料單號欄位不可空白!
            CALL cl_err(g_imr.imr01,'aim-416',0)
            RETURN
        END IF
    END IF
    #CHI-C70017---begin
    IF g_sma.sma53 IS NOT NULL AND g_imr.imr09 <= g_sma.sma53 THEN
       CALL cl_err('','mfg9999',0)
       RETURN
    END IF
    CALL s_yp(g_imr.imr09) RETURNING l_yy,l_mm
  
    IF ((l_yy*12+l_mm) > (g_sma.sma51*12+g_sma.sma52)) THEN
       CALL cl_err('','mfg6090',0)
       RETURN
    END IF
    #CHI-C70017---end
    
    DECLARE t308_w_cur CURSOR FOR
        SELECT UNIQUE imq03,imq04
          FROM imq_file
        WHERE imq01 = g_imr.imr01
    LET l_return = 'N'
    FOREACH t308_w_cur INTO l_imq03,l_imq04
        SELECT COUNT(*) INTO g_cnt
          FROM imp_file
         WHERE imp01 = l_imq03 #借料單號
           AND imp02 = l_imq04 #借料項次
           AND imp07 = 'Y'
        IF g_cnt > 0 THEN
            LET l_mess=''
            LET l_mess = l_imq03 CLIPPED,'+',l_imq04 CLIPPED
            #此借料單據已結案!
            CALL cl_err(l_mess,'aim-411',1)
            LET l_return = 'Y'
        END IF
    END FOREACH
    IF l_return = 'Y' THEN RETURN END IF
    IF NOT cl_sure(21,20) THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
    OPEN t308_cl USING g_imr.imr01
    FETCH t308_cl INTO g_imr.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t308_cl ROLLBACK WORK RETURN
    END IF
       DECLARE t308_w_cs CURSOR FOR
         SELECT * FROM imq_file WHERE imq01=g_imr.imr01
       CALL s_showmsg_init()  #No.FUN-710025
       FOREACH t308_w_cs INTO b_imq.*
         #No.FUN-710025--Begin--                                                                                                      
          IF g_success='N' THEN                                                                                                        
             LET g_totsuccess='N'                                                                                                      
             LET g_success="Y"                                                                                                         
          END IF                                                                                                                       
         #No.FUN-710025--End-
 
         SELECT imp08 INTO l_imp08
           FROM imp_file
          WHERE imp01 = b_imq.imq03
            AND imp02 = b_imq.imq04
 
         UPDATE imp_file
            SET imp08 = l_imp08-b_imq.imq07
          WHERE imp01 = b_imq.imq03
            AND imp02 = b_imq.imq04
        #No.FUN-710025--Begin--
        #IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
        #IF g_success = 'N' THEN EXIT FOREACH END IF
         IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN 
         LET g_showmsg = b_imq.imq03,"/",b_imq.imq04
         CALL s_errmsg('imp01,imp02',g_showmsg,'upd imp',SQLCA.sqlcode,1)  
         LET g_success='N' 
         END IF
         IF g_success = 'N' THEN CONTINUE FOREACH END IF
        #No.FUN-710025--End--
 
       END FOREACH
        #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
        #No.FUN-710025--End--
 
    UPDATE imr_file
       SET imr09 = NULL,
           imrpost='N',
           imrmodu=g_user,
           imrdate=g_today
     WHERE imr01=g_imr.imr01
     #No.FUN-710025--Begin--
     #IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
      IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN 
      CALL s_errmsg('imr01',g_imr.imr01,'upd imr',SQLCA.sqlcode,1)
      LET g_success='N' 
      END IF
      CALL s_showmsg() 
     #No.FUN-710025--End--
 
    IF g_success = 'Y' THEN
       LET g_imr.imr09=NULL
       LET g_imr.imrpost='N'
       LET g_imr.imrmodu=g_user
       LET g_imr.imrdate=g_today
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       LET g_imr.imrpost='Y'
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
    DISPLAY BY NAME g_imr.imr09,g_imr.imrpost,g_imr.imrmodu,g_imr.imrdate
END FUNCTION
#====>作廢/作廢還原功能
#FUNCTION t308_x()  #CHI-D20010
FUNCTION t308_x(p_type)   #CHI-D20010
DEFINE l_flag LIKE type_file.chr1  #CHI-D20010
DEFINE p_type LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF

   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_imr.imrconf ='X' THEN RETURN END IF
   ELSE
      IF g_imr.imrconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
   LET g_success='Y'
   OPEN t308_cl USING g_imr.imr01
   FETCH t308_cl INTO g_imr.* #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0) #資料被他人LOCK
       CLOSE t308_cl ROLLBACK WORK RETURN
   END IF
   #-->己過帳不可作廢
   IF g_imr.imrpost = 'Y' THEN CALL cl_err(g_imr.imr01,'afa-101',0) RETURN END IF
   IF g_imr.imrconf = 'Y' THEN CALL cl_err(g_imr.imr01,'axr-368',0) RETURN END IF #FUN-660080
   IF g_imr.imrconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_imr.imrconf)   THEN #FUN-660080   #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN #FUN-660080     #CHI-D20010
        LET g_chr=g_imr.imrconf #FUN-660080
       #IF g_imr.imrconf ='N' THEN   #CHI-D20010
        IF p_type = 1 THEN           #CHI-D20010
            LET g_imr.imrconf='X'
        ELSE
            LET g_imr.imrconf='N'
        END IF
        UPDATE imr_file
            SET imrconf=g_imr.imrconf, #FUN-660080
                imrmodu=g_user,
                imrdate=g_today
            WHERE imr01  =g_imr.imr01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err(g_imr.imrconf,SQLCA.sqlcode,0) #No.FUN-660156
           CALL cl_err3("upd","imr_file",g_imr.imr01,"",
                         SQLCA.sqlcode,"","",1)  #No.FUN-660156
            LET g_imr.imrconf = g_chr
        END IF
        DISPLAY BY NAME g_imr.imrconf,g_imr.imrmodu,g_imr.imrdate #FUN-660080
   END IF
   CLOSE t308_cl
   COMMIT WORK
   CALL cl_flow_notify(g_imr.imr01,'V')
END FUNCTION
 
FUNCTION t308_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    sr              RECORD
        imr01       LIKE imr_file.imr01,   #單頭
        imr02       LIKE imr_file.imr02,   #
        imr03       LIKE imr_file.imr03,   #
        imr04       LIKE imr_file.imr04,   #
        imr05       LIKE imr_file.imr05,   #
        imr06       LIKE imr_file.imr06,   #
        gen02       LIKE gen_file.gen02,   #
        gem02       LIKE gem_file.gem02,   #
        imrpost     LIKE imr_file.imrpost, #
        imq02       LIKE imq_file.imq02  , #單身
        imq03       LIKE imq_file.imq03  , #
        imq04       LIKE imq_file.imq04  , #
        imq07       LIKE imq_file.imq07  , #
        imq11       LIKE imq_file.imq11  , #
        imq12       LIKE imq_file.imq12  , #
        imp03       LIKE imp_file.imp03  , #
        imp04       LIKE imp_file.imp04  , #
        imp05       LIKE imp_file.imp05  , #
        imp09       LIKE imp_file.imp09  , #
        ima02       LIKE ima_file.ima02    #
       END RECORD,
    l_name          LIKE type_file.chr20,               #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    l_za05          LIKE za_file.za05               #  #No.FUN-690026 VARCHAR(40)
    CALL cl_del_data(l_table)                       #NO.FUN-840020
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimt308' #NO.FUN-840020
    IF g_imr.imr01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF cl_null(g_wc) THEN
        LET g_wc=" imr01='",g_imr.imr01,"'"
    END IF
    IF cl_null(g_wc2) THEN
        LET g_wc2=" 1=1 "
    END IF
    #改成印當下的那一筆資料內容
#   IF g_wc IS NULL THEN
#      CALL cl_err('','9057',0) RETURN END IF
#       CALL cl_err('',-400,0)
#       RETURN
#   END IF
    CALL cl_wait()
#   LET l_name = 'aimt308.out'
#    CALL cl_outnam('aimt308') RETURNING l_name         #NO.FUN-840020
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    LET g_sql="SELECT imr01,imr02,imr03,imr04,imr05,imr06,gen02,gem02,imrpost, ",    #單頭
              "       imq02,imq03,imq04,imq07,imq11,imq12,imp03,imp04,imp05, ",
              "       imp09,ima02 ",
              "  FROM imr_file,imq_file,imp_file, ",
              " OUTER gen_file,OUTER ima_file,OUTER gem_file ",
              " WHERE imq01 = imr01 ",   #還料單號
              "   AND imq03 = imp01 ",   #借料單號
              "   AND imq04 = imp02 ",   #借料項次
              "   AND gen_file.gen01 = imr_file.imr03 ",
              "   AND gem_file.gem01 = imr_file.imr04 ",
              "   AND ima_file.ima01 = imp_file.imp03 ",
              "   AND imr00 = '2' ",     #原價償還
              "   AND ",g_wc  CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY 1,10,11,12 "
    PREPARE t308_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t308_co                         # CURSOR
        CURSOR FOR t308_p1
 
#    START REPORT t308_rep TO l_name                    #NO.FUN-840020
 
    FOREACH t308_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
#        OUTPUT TO REPORT t308_rep(sr.*)                #NO.FUN-840020
#NO.FUN-840020----start----
        EXECUTE insert_prep USING
          sr.imr01,sr.imr02,sr.imr03,sr.imr04,sr.imr05,sr.imr06,sr.gen02,
          sr.gem02,sr.imrpost,sr.imq02,sr.imq03,sr.imq04,sr.imq07,
          sr.imq11,sr.imq12,sr.imp03,sr.imp04,sr.imp05,sr.imp09,sr.ima02
#NO.FUN-840020----end----
    END FOREACH
 
#    FINISH REPORT t308_rep                             #NO.FUN-840020
#NO.FUN-840020---start----
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'imr01,imr02,imr05,imr09,imr03,imr04,imr06,imrconf,
                            imrpost,imruser,imrgrup,imrmodu,imrdate,imq02,
                            imq03,imq04,imq07,imq11,imq12,imq930,imq05,imq08,
                            imq09,imq10,imq06')
           RETURNING g_wc
     END IF
     LET g_str = g_wc,";",g_azi03,";",g_azi04
     CALL cl_prt_cs3('aimt308','aimt308',g_sql,g_str) 
#NO.FUN-840020---end---- 
    CLOSE t308_co
    ERROR ""
#    CALL cl_prt(l_name,' ','1',g_len)                  #NO.FUN-840020
END FUNCTION
#NO.FUN-840020---start---mark---
#REPORT t308_rep(sr)
#DEFINE
#    l_last_sw       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
#    l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#    sr              RECORD
#        imr01       LIKE imr_file.imr01,   #單頭
#        imr02       LIKE imr_file.imr02,   #
#        imr03       LIKE imr_file.imr03,   #
#        imr04       LIKE imr_file.imr04,   #
#        imr05       LIKE imr_file.imr05,   #
#        imr06       LIKE imr_file.imr06,   #
#        gen02       LIKE gen_file.gen02,   #
#        gem02       LIKE gem_file.gem02,   #
#        imrpost     LIKE imr_file.imrpost, #
#        imq02       LIKE imq_file.imq02  , #單身
#        imq03       LIKE imq_file.imq03  , #
#        imq04       LIKE imq_file.imq04  , #
#        imq07       LIKE imq_file.imq07  , #
#        imq11       LIKE imq_file.imq11  , #
#        imq12       LIKE imq_file.imq12  , #
#        imp03       LIKE imp_file.imp03  , #
#        imp04       LIKE imp_file.imp04  , #
#        imp05       LIKE imp_file.imp05  , #
#        imp09       LIKE imp_file.imp09  , #
#        ima02       LIKE ima_file.ima02    #
#       END RECORD
#
#   OUTPUT
#       TOP MARGIN g_top_margin
#       LEFT MARGIN g_left_margin
#       BOTTOM MARGIN g_bottom_margin
#       PAGE LENGTH g_page_line
#
#    ORDER BY sr.imr01,sr.imq02,sr.imq03,sr.imq04
##No.FUN-580014-begin
#    FORMAT
#        PAGE HEADER
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,g_company CLIPPED
#
#            LET g_pageno = g_pageno + 1
#            LET pageno_total = PAGENO USING '<<<',"/pageno"
#            PRINT g_head CLIPPED,pageno_total
#
#            PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
#            PRINT
#            PRINT g_dash[1,g_len]
#            LET l_last_sw = 'n'
#
#        BEFORE GROUP OF sr.imr01
#           SKIP TO TOP OF PAGE
#           PRINT COLUMN 02,g_x[11] CLIPPED,sr.imr01,
#                 COLUMN 36,g_x[12] CLIPPED,sr.imr03,' ',sr.gen02,
#                 COLUMN 70,g_x[17] CLIPPED,sr.imrpost
#           PRINT COLUMN 02,g_x[13] CLIPPED,sr.imr02,
#                 COLUMN 36,g_x[14] CLIPPED,sr.imr04,' ',sr.gem02
#           PRINT COLUMN 02,g_x[15] CLIPPED,sr.imr05,
#                 COLUMN 36,g_x[16] CLIPPED,sr.imr06
#           PRINT g_dash2[1,g_len]
#           PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
#                          g_x[36],g_x[37],g_x[38]
#           PRINTX name=H2 g_x[42],g_x[39],g_x[43],g_x[40],g_x[41]
#           PRINT g_dash1
#
#        ON EVERY ROW
#           PRINTX name=D1
#                 COLUMN g_c[31],sr.imq02 USING '###&', #FUN-590118
#                 COLUMN g_c[32],sr.imq03 CLIPPED,
##                COLUMN g_c[33],'-',sr.imq04 USING '####',     #No.TQC-6C0029
#                 COLUMN g_c[33],sr.imq04 USING '#####',     #No.TQC-6C0029
#                 COLUMN g_c[34],sr.imp03 CLIPPED,
#                 COLUMN g_c[35],sr.imp05 CLIPPED,
#                 COLUMN g_c[36],cl_numfor(sr.imp04,36,0),
#                 COLUMN g_c[37],cl_numfor(sr.imp09,37,g_azi03),
#                 COLUMN g_c[38],cl_numfor(sr.imq12,38,g_azi04)
#           PRINTX name=D2 COLUMN g_c[39],sr.ima02 CLIPPED,
#                 COLUMN g_c[40],cl_numfor(sr.imq07,40,0),
#                 COLUMN g_c[41],cl_numfor(sr.imq11,41,g_azi03)
##No.FUN-580014-end
#
#        ON LAST ROW
#            PRINT g_dash[1,g_len]
#            IF g_zz05 = 'Y'          # 80:70,140,210      132:120,240
#               THEN
#                    CALL cl_prt_pos_wc(g_wc2) #TQC-630166
#                    PRINT g_dash[1,g_len]
#            END IF
#            LET l_last_sw = 'y'
#            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#
#        PAGE TRAILER
#            IF l_last_sw = 'n' THEN
#                PRINT g_dash[1,g_len]
#                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#            ELSE
#                SKIP 2 LINE
#            END IF
#            PRINT ""
### FUN-550108
#          #  PRINT g_x[30] CLIPPED,' ',g_x[31] CLIPPED,' ',g_x[32] CLIPPED
#          IF l_last_sw = 'n' THEN
#             IF g_memo_pagetrailer THEN
#                 PRINT g_x[30]
#                 PRINT g_memo
#             ELSE
#                 PRINT
#                 PRINT
#             END IF
#          ELSE
#                 PRINT g_x[30]
#                 PRINT g_memo
#          END IF
### END FUN-550108
#
#END REPORT
#NO.FUN-840020---end---mark---
FUNCTION t308_imq04(p_cmd)
   DEFINE   l_imp07   LIKE imp_file.imp07,
            l_imoconf LIKE imo_file.imoconf,
            l_imopost LIKE imo_file.imopost,
            p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
       LET g_errno=''
       SELECT imp03,ima02,imp05,imp04,imp07,imoconf,imopost,imp09
         INTO g_imq[l_ac].imp03,g_imq[l_ac].ima02s,
              g_imq[l_ac].imp05,g_imq[l_ac].imp04,
              l_imp07,l_imoconf,l_imopost,g_imq[l_ac].imp09
         FROM imp_file,imo_file,OUTER ima_file
        WHERE imp01 = g_imq[l_ac].imq03
          AND imp02 = g_imq[l_ac].imq04
         AND imp_file.imp03 = ima_file.ima01
          AND imp01 = imo01
        CASE
            WHEN SQLCA.sqlcode=100   LET g_errno='aim-410' #無此借料單號!
                                     LET g_imq[l_ac].imp03=NULL
                                     LET g_imq[l_ac].ima02s=NULL
                                     LET g_imq[l_ac].imp05=NULL
                                     LET g_imq[l_ac].imp04=NULL
                                     LET l_imp07=NULL
            WHEN l_imp07='Y'         LET g_errno='aim-411' #此借料單據已結案!
            WHEN l_imoconf='N'       LET g_errno='9029'    #此筆資料尚未確認, 不可使用
            WHEN l_imoconf='X'       LET g_errno='9024'    #此筆資料已作廢
            WHEN l_imopost='N'       LET g_errno='aim-206  #單據尚未過帳!
            OTHERWISE
                 LET g_errno=SQLCA.sqlcode USING '------'
        END CASE
        IF p_cmd='d' OR cl_null(g_errno) THEN
            DISPLAY g_imq[l_ac].imp03 TO s_imq[l_sl].imp03
            DISPLAY g_imq[l_ac].ima02s TO s_imq[l_sl].ima02s
            DISPLAY g_imq[l_ac].imp05 TO s_imq[l_sl].imp05
            DISPLAY g_imq[l_ac].imp04 TO s_imq[l_sl].imp04
            DISPLAY g_imq[l_ac].imp09 TO s_imq[l_sl].imp09
        END IF
END FUNCTION
FUNCTION t308_imr03(p_cmd)    #人員
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_gen02     LIKE gen_file.gen02,
         l_gen03     LIKE gen_file.gen03,
         l_gem02     LIKE gem_file.gem02,
         l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT   gen02,      gen03,  gem02,  genacti
    INTO l_gen02,l_gen03,l_gem02,l_genacti
    FROM gen_file, OUTER gem_file WHERE gen01 = g_imr.imr03
                                   AND gen_file.gen03 = gem_file.gem01
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                 LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd='d' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
  IF p_cmd='a' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
     LET g_imr.imr04 = l_gen03
     DISPLAY l_gen03 TO imr04
     DISPLAY l_gem02 TO FORMONLY.gem02
  END IF
END FUNCTION
 
 #MOD-420449
FUNCTION t308_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("imr01",TRUE)
 END IF
END FUNCTION
 
FUNCTION t308_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("imr01",FALSE)
   END IF
END FUNCTION
#--END
 
#FUN-660080
FUNCTION t308_y_chk()
DEFINE l_cnt LIKE type_file.num10   #No.FUN-690026 INTEGER
 
   LET g_success = 'Y'
#CHI-C30107 ----------------- add ---------------------- begin
   IF cl_null(g_imr.imr01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_imr.imrconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF g_imr.imrconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN LET g_success = 'N' RETURN END IF
#CHI-C30107 ----------------- add ---------------------- end
   IF cl_null(g_imr.imr01) THEN 
      CALL cl_err('',-400,0) 
      LET g_success = 'N'
      RETURN 
   END IF
 
   SELECT * INTO g_imr.* FROM imr_file WHERE imr01 = g_imr.imr01
   IF g_imr.imrconf='Y' THEN
      LET g_success = 'N'           
      CALL cl_err('','9023',0)      
      RETURN
   END IF
 
   IF g_imr.imrconf = 'X' THEN
      LET g_success = 'N'   
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM imr_file
      WHERE imr01= g_imr.imr01
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
 
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
#FUN-660080
FUNCTION t308_y_upd()
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t308_cl USING g_imr.imr01
   IF STATUS THEN
      CALL cl_err("OPEN t308_cl:", STATUS, 1)
      CLOSE t308_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t308_cl INTO g_imr.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t308_cl 
       ROLLBACK WORK 
       RETURN
   END IF
   CLOSE t308_cl
   UPDATE imr_file SET imrconf = 'Y' WHERE imr01 = g_imr.imr01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#     CALL cl_err('upd imrconf',STATUS,0) #No.FUN-660156
      CALL cl_err3("upd","imr_file",g_imr.imr01,"",
                    SQLCA.sqlcode,"","upd imrconf",1)  #No.FUN-660156
      LET g_success = 'N'
   END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_imr.imrconf='Y'
      CALL cl_flow_notify(g_imr.imr01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_imr.imrconf='N'
   END IF
   DISPLAY BY NAME g_imr.imrconf
   IF g_imr.imrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_chr,"")
END FUNCTION
 
#FUN-660080
FUNCTION t308_z()
   IF cl_null(g_imr.imr01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_imr.* FROM imr_file WHERE imr01 = g_imr.imr01
   IF g_imr.imrconf='N' THEN RETURN END IF
   IF g_imr.imrconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_imr.imrpost='Y' THEN
      CALL cl_err('imr03=Y:','afa-101',0)
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t308_cl USING g_imr.imr01
   IF STATUS THEN
      CALL cl_err("OPEN t308_cl:", STATUS, 1)
      CLOSE t308_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t308_cl INTO g_imr.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_imr.imr01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t308_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CLOSE t308_cl
   LET g_success = 'Y'
   UPDATE imr_file SET imrconf = 'N' WHERE imr01 = g_imr.imr01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      LET g_imr.imrconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_imr.imrconf
   ELSE
      LET g_imr.imrconf='Y'
      ROLLBACK WORK
   END IF
   IF g_imr.imrconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_chr,"")
END FUNCTION
#Patch....NO.TQC-610036 <> #
#FUN-BB0083---add---str
FUNCTION t308_imq07_check()
#imq07 的單位 imp05  
DEFINE l_digcut        LIKE imq_file.imq07,    #MOD-530179
       l_digcut1       LIKE imq_file.imq07,    #MOD-530179
       l_keyinyes      LIKE imq_file.imq07,    #MOD-530179 #已登打數量
       l_keyinno       LIKE imq_file.imq07,    #MOD-530179 #未登打數量
       l_imp04         LIKE imp_file.imp04,
       l_imp08         LIKE imp_file.imp08 
       
   IF NOT cl_null(g_imq[l_ac].imp05) AND NOT cl_null(g_imq[l_ac].imq07) THEN
      IF cl_null(g_imq_t.imq07) OR cl_null(g_imp05_t) OR g_imq_t.imq07 != g_imq[l_ac].imq07 OR g_imp05_t != g_imq[l_ac].imp05 THEN 
         LET g_imq[l_ac].imq07=s_digqty(g_imq[l_ac].imq07,g_imq[l_ac].imp05)
         DISPLAY BY NAME g_imq[l_ac].imq07  
      END IF  
   END IF
   IF g_imq[l_ac].imq07 = 0 THEN
       CALL cl_err('','mfg1322',1)
       RETURN "imq07"
   END IF
   IF NOT cl_null(g_imq[l_ac].imq07) THEN
      LET g_imq[l_ac].imq12 = g_imq[l_ac].imq07*g_imq[l_ac].imq11
      DISPLAY g_imq[l_ac].imq12 TO s_imq[l_sl].imq12
      #當下那筆還料數量
      LET l_digcut = g_imq[l_ac].imq07
      IF cl_null(l_digcut) THEN
          LET l_digcut = 0
      END IF
 
      #原本的還料數量
      LET l_digcut1 = g_imq_t.imq07
      IF cl_null(l_digcut1) THEN
          LET l_digcut1 = 0
      END IF
 
      SELECT SUM(imq07/imq06_fac)
        INTO l_keyinyes #已登打的數量
        FROM imq_file,imr_file
       WHERE imq03 = g_imq[l_ac].imq03
         AND imq04 = g_imq[l_ac].imq04
         AND imrconf <> 'X' #作廢的不算 #FUN-660080
         AND imr01 = imq01
      IF cl_null(l_keyinyes) THEN
          LET l_keyinyes = 0
      END IF
      LET l_keyinyes = l_keyinyes - l_digcut1 #已登打數量 - 原本的  還料數量
      LET l_keyinyes = l_keyinyes + l_digcut  #已登打數量 + 當下那筆還料數量
      IF l_keyinyes > g_imq[l_ac].imp04 THEN
          LET l_keyinno = 0 #未登打數量
      ELSE
          LET l_keyinno = g_imq[l_ac].imp04 - l_keyinyes #未登打數量
      END IF
               #借,還
      SELECT imp04,imp08 INTO l_imp04,l_imp08
        FROM imp_file
       WHERE imp01 = g_imq[l_ac].imq03
         AND imp02 = g_imq[l_ac].imq04
      #還>借
      IF l_imp08 >= l_imp04 THEN
          #借料數量已還清!
          CALL cl_err('','aim-116',1)
          RETURN "imq03"
      END IF
 
      #  已登打數量 > 借料數量
      IF l_keyinyes > l_imp04 THEN
          CALL cl_err('','aim-117',1)
          LET g_imq[l_ac].imq07 = g_imq_t.imq07
          DISPLAY g_imq[l_ac].imq07 TO s_imq[l_sl].imq07
          RETURN "imq07"
      END IF
   END IF
RETURN ''
END FUNCTION
#FUN-BB0083---add---end
#FUN-D10081---add---str---
FUNCTION t308_list_fill()
  DEFINE l_imr01         LIKE imr_file.imr01
  DEFINE l_i             LIKE type_file.num10

    CALL g_imr_l.clear()
    LET l_i = 1
    FOREACH t308_fill_cs INTO l_imr01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT imr01,'',imr02,imr03,gen02,imr04,gem02,imr05,imr06,
              imr09,imrconf,imrpost
         INTO g_imr_l[l_i].*
         FROM imr_file
              LEFT OUTER JOIN gem_file ON gem01 = imr04
              LEFT OUTER JOIN gen_file ON gen01 = imr03
        WHERE imr01=l_imr01
       LET g_t1=s_get_doc_no(g_imr_l[l_i].imr01)
       SELECT smydesc INTO g_imr_l[l_i].smydesc
         FROM smy_file 
        WHERE smyslip = g_t1

       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b4 = l_i - 1
    DISPLAY ARRAY g_imr_l TO s_imr_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
END FUNCTION

FUNCTION t308_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_imr_l TO s_imr_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
          CALL fgl_set_arr_curr(g_curs_index)
          CALL cl_navigator_setting( g_curs_index, g_row_count )
       BEFORE ROW
          LET l_ac4 = ARR_CURR()
          LET g_curs_index = l_ac4
          CALL cl_show_fld_cont()

      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         IF g_rec_b4 > 0 THEN
             CALL t308_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", TRUE)          
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         CALL t308_fetch('/')  
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_main", TRUE)    
         EXIT DISPLAY

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
         CALL t308_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
           ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL t308_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	  ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL t308_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1) 
           END IF
	ACCEPT DISPLAY                  
 
      ON ACTION next
         CALL t308_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
      ON ACTION last
         CALL t308_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  
           END IF
	ACCEPT DISPLAY                   
 
      #TQC-D10084---mark---str---
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
      #TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
         IF g_imr.imrconf = 'X' THEN 
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imr.imrconf,"",g_imr.imrpost,"",g_void,"") 
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
    #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
        
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end

      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY   
 
      
     #AFTER DISPLAY            #TQC-D10084---mark---
     #   CONTINUE DISPLAY      #TQC-D10084---mark---
                                                                                                  
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        

      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION 
#FUN-D10081---add---end---

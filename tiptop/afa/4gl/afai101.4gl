# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: afai101.4gl
# Descriptions...: 固定資產維護作業
# Date & Author..: 96/05/17 By Sophia
# Modify.........: 02/10/15 BY Maggie   No.A032
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470515 04/07/23 By Nicola 加入"相關文件"功能
# Modify.........: No.MOD-470559 04/07/23 By Nicola fak24開窗無值回傳
# Modify.........: No.MOD-4C0029 04/12/07 By Nicola cl_doc參數傳遞錯誤
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-540117 05/04/22 By Nicola 分攤部門及折舊科目會被清空
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: No.MOD-560088 05/06/28 By day    將序號自動編號改為確定存入時再取號
# Modify.........: No.FUN-570108 05/07/13 By jackie 修正建檔程式key值是否可更改
# Modify.........: No.MOD-590431 05/09/30 By Sarah 1.i101_i()裡的AFTER FIELD fak44應該判斷進貨工廠(fak44),卻判斷 fak22,導至程式無法離開
#                                                  2.AFTER INPUT裡,折舊科目若是在不計提折舊情況下是可以不輸入
# Modify.........: No.MOD-630016 06/03/06 By Smapmin fak24開窗與判斷都應與afai100的faj24相同
# Modify.........: No.MOD-640501 06/04/19 By Smapmin 修改SELECT條件
# Modify.........: No.MOD-640521 06/04/20 By Smapmin g_fab13要重新抓取
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-690024 06/09/19 By jamie 判斷pmcacti
# Modify.........: No.FUN-6A0001 06/10/02 By jamie FUNCTION i101_q()一開始應清空g_fak.*值
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6B0006 06/11/01 By Mandy 當底稿拋轉產生後,分攤部門為空白,此時進入修改.輸入分攤部門(fak24)後,折舊科目會帶不出來.
# Modify.........: No.MOD-690087 06/12/05 By Smapmin 序號必須為數字
# Modify.........: No.TQC-6C0009 06/12/05 By Rayven  錄入資料時，單身‘憑証資料’中‘進貨營運中心’陷入死循環，下不去，必須用鼠標下移
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-710112 07/03/27 By Judy    頁簽一般資料/稅簽資料,數字欄位控管
# Modify.........: No.FUN-740026 07/04/10 By sherry  會計科目加帳套
# Modify.........: No.TQC-740144 07/04/23 By sherry  會計科目加帳套Bug修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770079 07/07/13 By wujie   類型為主件時，“附號”應該不能輸入
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-840006 08/04/02 By hellen  項目管理，去掉預算編號相關欄位
# Modify.........: No.FUN-840119 08/04/21 By Smapmin 增加fak71
# Modify.........: No.MOD-840660 08/04/25 By chenl 增加入賬日期等于關賬日期的錯誤提示。
# Modify.........: No.FUN-850068 08/05/13 By TSD.odyliao 自定欄位功能修改
# Modify.........: No.MOD-840085 08/07/10 By Pengu 1.當入帳日期小於財簽關帳日期時應SHOW警告訊息
#                                                  2.調整i101_fak53()的傳遞引數值
# Modify.........: No.MOD-8C0144 08/12/16 By Sarah fak66應另CALL i101_6668(),依據不同的稅簽折舊方式計算正確的fak66,而非直接帶入fak31
# Modify.........: No.TQC-950203 09/05/31 By Carrier 查詢時，報-201錯誤
# Modify.........: No.FUN-980003 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/12 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.FUN-9C0077 10/01/05 By baofei 程式精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A40016 10/04/02 By destiny fak451,fak461,fak471 有值但画面未显示   
# Modify.........: No.TQC-A40017 10/04/02 By lilingyu 修改AFTER INPUT后的判斷報錯信息 
# Modify.........: No.MOD-A40033 10/04/07 By lilingyu 如果是大陸版,則按調整后資產總成本*殘值率 來計算"調整后的預計殘值"
# Modify.........: No.FUN-9A0036 10/08/06 By vealxu 增加"族群"欄位 (fak93)
# Modify.........: No.MOD-A80174 10/08/24 By Dido 增加相關單據項次查詢 
# Modify.........: No:MOD-AB0040 10/11/04 By 新增與修改 fak43 只允許維護 0取得,4折畢狀態 
# Modify.........: No.FUN-B10053 11/01/25 By yinhy 科目查询自动过滤
# Modify.........: No.FUN-AB0088 11/04/08 By lixiang 固定资料財簽二功能
# Modify.........: No.TQC-B50020 11/05/05 By suncx 財簽二BUG修正   
# Modify.........: No.CHI-B40058 11/05/13 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.TQC-B50091 11/05/20 By chenmoayn 重新計算財簽二的取得成本
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-B70093 11/07/12 By Dido FUNCTION i101_31332 限 faa31 = 'Y' 才可進入 
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:MOD-BA0218 11/11/12 By johung aza31='N'/faa05='N'/faa06='N'，fak90/fak901預設帶入fak02/fak022
# Modify.........: No:TQC-C10113 12/01/30 By wujie 查询时增加oriu，orig栏位 
# Modify.........: No:CHI-BB0005 12/02/02 By ck2yuan 增加控卡財產編號(fak02)不可為空
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20320 12/02/21 by minpp 利息資本化時，按下[拋利息資本資料]在寫入利息資本化資料檔(fcx_file)會有[無法將 null 插入欄的 '欄-名稱']的錯誤訊息
# Modify.........: No:MOD-C30862 12/03/27 By Polly 修改key值欄位後，需重新抓取資料
# Modify.........: No:TQC-C50117 12/05/16 By xuxz afk15"幣種"與aoos010設定的“本國幣種”相同時，fak14等于fak16
# Modify.........: No.CHI-C60010 12/06/14 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No:FUN-C30027 12/08/10 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C90122 12/09/14 By Polly 調整提列日期的計算需和afai100一致

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_fak               RECORD LIKE fak_file.*,
    g_fak_t             RECORD LIKE fak_file.*,
    g_fak_o             RECORD LIKE fak_file.*,
    g_fab23             LIKE fab_file.fab23,         #殘值率 NO.A032
    g_fab13             LIKE fab_file.fab13,
    g_fab232            LIKE fab_file.fab232,     #殘值率 NO.A032   #No:FUN-AB0088
    g_fab131            LIKE fab_file.fab131,        #No.FUN-680028
    g_fak01_t           LIKE fak_file.fak01,
    g_cmd               LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    g_flag              LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
     g_wc,g_sql          string,  #No.FUN-580092 HCN
    g_argv2       LIKE faj_file.faj01,
    aag02_1             LIKE aag_file.aag02,       #afai1011 add       #No.FUN-680070 VARCHAR(20)
    aag02_2             LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
    aag02_3             LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
    aag02_4             LIKE aag_file.aag02,       #afai1011 add       #No.FUN-680070 VARCHAR(20)
    aag02_5             LIKE aag_file.aag02,       #No.FUN-680070 VARCHAR(20)
    aag02_6             LIKE aag_file.aag02        #No.FUN-680070 VARCHAR(20)
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
 
 
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_bookno1      LIKE aza_file.aza81         #No.FUN-740026
DEFINE   g_bookno2      LIKE aza_file.aza82         #No.FUN-740026
DEFINE   g_azi04_1      LIKE azi_file.azi04         #CHI-C60010 add
 
MAIN
    DEFINE p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
    INITIALIZE g_fak.* TO NULL
    INITIALIZE g_fak_t.* TO NULL
    INITIALIZE g_fak_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM fak_file WHERE fak01 = ? AND fak02 = ? AND fak022 = ? FOR UPDATE"
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i101_cl CURSOR  FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 2 LET p_col = 2
    OPEN WINDOW i101_w AT p_row,p_col
         WITH FORM "afa/42f/afai101"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
  # IF g_aza.aza63 = 'Y' THEN
    IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
       CALL cl_set_comp_visible("page07",TRUE)   #No:FUN-AB0088
       CALL cl_set_comp_visible("fak531,fak541,fak551",TRUE)
       CALL cl_set_comp_visible("aag02_4,aag02_5,aag02_6",TRUE)
    ELSE
       CALL cl_set_comp_visible("page07",FALSE)   #No:FUN-AB0088
       CALL cl_set_comp_visible("fak531,fak541,fak551",FALSE)
       CALL cl_set_comp_visible("aag02_4,aag02_5,aag02_6",FALSE)
    END IF
    IF g_aza.aza26 = '2' THEN
       CALL i101_set_comb()
       CALL i101_set_comments()
    END IF
 
 
 
    LET g_action_choice=""
    CALL i101_menu()
 
    CLOSE WINDOW i101_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
END MAIN
 
FUNCTION i101_cs()
    CLEAR FORM
   IF cl_null(g_argv2) THEN
   INITIALIZE g_fak.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        fak00,fak01,fak021,fak02,fak022,fak03,fak93,fak04,fak05,fak09,             #FUN-9A0036 add fak93
        fak10,fak11,fak12,
        fak06,fak061,fak07,fak071,fak08,
        fak18,fak17,fak13,fak14,fak15,fak16,
        fak43,fak91,fak90,fak901,fak19,fak20,fak21,fak22,
        fak23,fak24,fak25,fak26,fak27,fak34,fak35,fak36,
        fak28,fak29,fak30,fak31,fak32,fak33,fak141,
        #-----No:FUN-AB0088-----
        #Asset 2
        fak143, fak144,fak142,
        fak232, fak242,fak262, fak272,
        fak342, fak352,fak362, fak282,fak292, fak302,
        fak312, fak322,fak332, fak1412,
        #-----No:FUN-AB0088 END-----
        fak62,fak71,fak61,fak64,fak65,fak66,fak67,fak68,fak63,   #FUN-840119
        fak92,fak37,fak38,fak39,fak40,fak41,
        fak42,fak421,fak422,fak423,fak56,
        fak53,fak531,fak54,fak541,fak55,fak551,#fak44,     #No.FUN-680028  #No.TQC-950203
       #fak44,fak45,fak46,fak47,fak48,fak49,fak51,fak52,  #No.FUN-840006 去掉fak50字段                        #MOD-A80174 mark
        fak44,fak45,fak451,fak46,fak461,fak47,fak471,fak48,fak49,fak51,fak52,  #No.FUN-840006 去掉fak50字段   #MOD-A80174 
        fakuser,fakgrup,fakoriu,fakorig,fakmodu,fakdate  #No.TQC-C10113 add oriu,orig
        ,fakud01,fakud02,fakud03,fakud04,fakud05,
        fakud06,fakud07,fakud08,fakud09,fakud10,
        fakud11,fakud12,fakud13,fakud14,fakud15
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
        ON ACTION controlp
           CASE
              WHEN INFIELD(fak022)   #財產編號附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_fak"
                 LET g_qryparam.default1 = g_fak.fak02
                 LET g_qryparam.default2 = g_fak.fak022
                 LET g_qryparam.multiret_index = 2
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak022
                 NEXT FIELD fak022
              WHEN INFIELD(fak04)   #資產類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_fab"
                 LET g_qryparam.default1 = g_fak.fak04
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak04
                 NEXT FIELD fak04
              WHEN INFIELD(fak05)   #次要類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_fac"
                 LET g_qryparam.default1 = g_fak.fak05
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak05
                 NEXT FIELD fak05
              WHEN INFIELD(fak10)   #供應廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_fak.fak10
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak10
                 NEXT FIELD fak10
              WHEN INFIELD(fak11)   #製造廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_fak.fak11
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak11
                 NEXT FIELD fak11
              WHEN INFIELD(fak12)   #原產地
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_geb"
                 LET g_qryparam.default1 = g_fak.fak12
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak12
                 NEXT FIELD fak12
              WHEN INFIELD(fak18)   #計量單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_fak.fak18
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak18
                 NEXT FIELD fak18
              WHEN INFIELD(fak15)   #原幣幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_fak.fak15
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak15
                 NEXT FIELD fak15
              WHEN INFIELD(fak19)   #保管人
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fak.fak19
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak19
                 NEXT FIELD fak19
              WHEN INFIELD(fak20)   #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fak.fak20
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak20
                 NEXT FIELD fak20
              WHEN INFIELD(fak21)   #存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = g_fak.fak21
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak21
                 NEXT FIELD fak21
              WHEN INFIELD(fak22)   #存放工廠
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak22
                 NEXT FIELD fak22
              WHEN INFIELD(fak24)   #分攤部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fak.fak24
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak24
                 NEXT FIELD fak24
              #-----No:FUN-AB0088-----
              WHEN INFIELD(fak242)   #分攤部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_gem"
                 #LET g_qryparam.default1 = g_fak.fak242
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak242
                 NEXT FIELD fak242
              #-----No:FUN-AB0088 END-----
              WHEN INFIELD(fak44)   #進貨工廠
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
                 LET g_qryparam.default1 = g_fak.fak44
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak44
                 NEXT FIELD fak44
              WHEN INFIELD(fak53)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak53
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak53
                 NEXT FIELD fak53
              WHEN INFIELD(fak54)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak54
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak54
                 NEXT FIELD fak54
              WHEN INFIELD(fak55)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak55
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak55
                 NEXT FIELD fak55
              WHEN INFIELD(fak531)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak531
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak531
                 NEXT FIELD fak531
              WHEN INFIELD(fak541)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak541
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak541
                 NEXT FIELD fak541
              WHEN INFIELD(fak551)
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.default1 = g_fak.fak551
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak551
                 NEXT FIELD fak551
              ##-----No:FUN-BA0112 add STR-----
              WHEN INFIELD(fak143)   #原幣幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_fak.fak143
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fak143
                 NEXT FIELD fak143
              ##-----No:FUN-BA0112 add END-----                 
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
 
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
  ELSE
    LET g_wc="faj01='",g_argv2,"'"
  END IF
    IF INT_FLAG THEN RETURN END IF

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fakuser', 'fakgrup')
 
    LET g_sql="SELECT fak01,fak02,fak022 FROM fak_file ", # 組合出 SQL 指令
              " WHERE ",g_wc CLIPPED,
              " ORDER BY fak01"
    PREPARE i101_prepare FROM g_sql           # RUNTIME 編譯
        IF STATUS THEN CALL cl_err('prepare:',STATUS,1) RETURN END IF
    DECLARE i101_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i101_prepare
    LET g_sql= "SELECT COUNT(*) FROM fak_file ",
               " WHERE ",g_wc CLIPPED
    PREPARE i101_precount FROM g_sql
    DECLARE i101_count  CURSOR WITH HOLD FOR i101_precount
END FUNCTION
 
FUNCTION i101_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i101_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i101_q()
            END IF
        ON ACTION next
            CALL i101_fetch('N')
        ON ACTION previous
            CALL i101_fetch('P')
 
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i101_u()
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i101_r()
            END IF
       ON ACTION reproduce
            LET g_action_choice="reproduce"
            IF cl_chk_act_auth() THEN
                 CALL i101_copy()
            END IF

        ON ACTION carry_interest_capital
            LET g_action_choice="carry_interest_capital"
            IF cl_chk_act_auth() AND g_fak.fak01 IS NOT NULL THEN
               CALL i101_g()
            END IF
        ON ACTION memo
            LET g_action_choice="memo"
            IF cl_chk_act_auth() THEN
               CALL s_afa_memo('0',g_fak.fak02,' ',g_fak.fak022)
            END IF
        ON ACTION help
            CALL cl_show_help()
        ON ACTION related_document    #No.MOD-470515
          LET g_action_choice="related_document"
          IF cl_chk_act_auth() THEN
             IF g_fak.fak01 IS NOT NULL THEN
                LET g_doc.column1 = "fak01"
                LET g_doc.value1 = g_fak.fak01
                LET g_doc.column2 = "fak02"
                LET g_doc.value2 = g_fak.fak02
                LET g_doc.column3 = "fak022"
                LET g_doc.value3 = g_fak.fak022
                CALL cl_doc()
             END IF
          END IF
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           IF g_aza.aza26 = '2' THEN
              CALL i101_set_comb()
              CALL i101_set_comments()
           END IF
        ON ACTION exit
            LET g_action_choice = "exit"
            EXIT MENU
 
        ON ACTION jump
            CALL i101_fetch('/')
        ON ACTION first
            CALL i101_fetch('F')
        ON ACTION last
            CALL i101_fetch('L')
 
        ON ACTION controlg
            CALL cl_cmdask()
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
            LET g_action_choice = "exit"
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
      &include "qry_string.4gl"
 
    END MENU
    CLOSE i101_cs
END FUNCTION
 
 
FUNCTION i101_a()
DEFINE  l_faa191      LIKE faa_file.faa191,
        l_fak01       LIKE fak_file.fak01
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    INITIALIZE g_fak.* LIKE fak_file.*
    LET g_fak01_t        = NULL
    LET g_fak_t.*        = g_fak.*
    LET g_fak_o.*        = g_fak.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fak.fak021 = '1' LET g_fak.fak03  = '1'
        LET g_fak.fak43  = '0' LET g_fak.fak91='N'
        #-->初始值給零
        LET g_fak.fak13  = 0 LET g_fak.fak14  = 0
        LET g_fak.fak141 = 0 LET g_fak.fak16  = 0
        LET g_fak.fak17  = 0 LET g_fak.fak171 = 0
        LET g_fak.fak26  = g_today      #TQC-740144
        LET g_fak.fak29  = 0 LET g_fak.fak30  = 0
        LET g_fak.fak31  = 0 LET g_fak.fak32  = 0
        LET g_fak.fak33  = 0 LET g_fak.fak35  = 0
        LET g_fak.fak58  = 0 LET g_fak.fak59  = 0
        LET g_fak.fak60  = 0 LET g_fak.fak62  = 0
        LET g_fak.fak71  = 'N'   #FUN-840119
        LET g_fak.fak63  = 0 LET g_fak.fak64  = 0
        LET g_fak.fak65  = 0 LET g_fak.fak66  = 0
        LET g_fak.fak67  = 0 LET g_fak.fak68  = 0
        LET g_fak.fak69  = 0 LET g_fak.fak70  = 0
        LET g_fak.fak92  = 'N'
        LET g_fak.fakuser = g_user               #使用者
        LET g_fak.fakoriu = g_user #FUN-980030
        LET g_fak.fakorig = g_grup #FUN-980030
        LET g_fak.fakmodu = g_user
        LET g_fak.fakgrup = g_grup               #使用者所屬群
        LET g_fak.fakdate = g_today
        #-----No:FUN-AB0088-----
        LET g_fak.fak232  = '1'
        LET g_fak.fak242  = ' '
        LET g_fak.fak282  = '1'
        LET g_fak.fak342  = 'N'
        LET g_fak.fak352  = 0
        LET g_fak.fak142  = 0
        LET g_fak.fak1412 = 0
        LET g_fak.fak292  = 0
        LET g_fak.fak302  = 0
        LET g_fak.fak312  = 0
        LET g_fak.fak322  = 0
        LET g_fak.fak332  = 0
        LET g_fak.fak352  = 0
        SELECT aaa03 INTO g_fak.fak143 FROM aaa_file
         WHERE aaa01 = g_faa.faa02c
        CALL s_curr(g_fak.fak143,g_today) RETURNING g_fak.fak144
        #-----No:FUN-AB0088 END-----
     #CHI-C60010--add--str--
        IF NOT cl_null(g_fak.fak143) THEN
           SELECT azi04 INTO g_azi04_1 FROM azi_file
            WHERE azi01 = g_fak.fak143
        END IF
        LET g_fak.fak144=cl_digcut(g_fak.fak144,g_azi04_1)
     #CHI-C60010--add--end
        CALL i101_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_fak.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
               IF g_faa.faa19 = 'Y' AND cl_null(g_fak_t.fak01)  #自動編號
               THEN
                  SELECT max(fak01) INTO g_faa.faa191 FROM fak_file
                  IF SQLCA.sqlcode OR cl_null(g_faa.faa191) THEN
                     LET g_faa.faa191 = 0
                  END IF
                  LET l_faa191 = g_faa.faa191 + 1
                  LET l_fak01 = l_faa191 USING '&&&&&&&&&&'
                  LET g_fak.fak01 = l_fak01
                  DISPLAY BY NAME g_fak.fak01
               END IF
               IF g_faa.faa06 = 'Y' AND cl_null(g_fak.fak02) THEN
                  LET g_fak.fak02 = g_fak.fak01
                  DISPLAY BY NAME g_fak.fak02
               END IF
               LET g_fak_t.fak01 = g_fak.fak01
 
        IF cl_null(g_fak.fak01)  THEN CONTINUE WHILE       END IF
        IF cl_null(g_fak.fak13)  THEN LET g_fak.fak13 = 0  END IF
        IF cl_null(g_fak.fak141) THEN LET g_fak.fak141 = 0 END IF
        IF cl_null(g_fak.fak92)  THEN LET g_fak.fak92 = 'N' END IF
        IF cl_null(g_fak.fak16)  THEN LET g_fak.fak16 = 0  END IF
        IF cl_null(g_fak.fak17)  THEN LET g_fak.fak17 = 0  END IF
        IF cl_null(g_fak.fak171) THEN LET g_fak.fak171 = 0 END IF
        IF cl_null(g_fak.fak29)  THEN LET g_fak.fak29 = 0  END IF
        IF cl_null(g_fak.fak30)  THEN LET g_fak.fak30 = 0  END IF
        IF cl_null(g_fak.fak33)  THEN LET g_fak.fak33 = 0  END IF
        IF cl_null(g_fak.fak35)  THEN LET g_fak.fak35 = 0  END IF
        IF cl_null(g_fak.fak36)  THEN LET g_fak.fak36 = 0  END IF
        IF cl_null(g_fak.fak421) THEN LET g_fak.fak421 = 0 END IF
        IF cl_null(g_fak.fak422) THEN LET g_fak.fak422 = 0 END IF
        IF cl_null(g_fak.fak423) THEN LET g_fak.fak423 = 0 END IF
        IF cl_null(g_fak.fak451) THEN LET g_fak.fak451 = 0 END IF
        IF cl_null(g_fak.fak461) THEN LET g_fak.fak461 = 0 END IF
        IF cl_null(g_fak.fak471) THEN LET g_fak.fak471 = 0 END IF
        IF cl_null(g_fak.fak57)  THEN LET g_fak.fak57 = 0  END IF
        IF cl_null(g_fak.fak571) THEN LET g_fak.fak571 = 0 END IF
        IF cl_null(g_fak.fak58)  THEN LET g_fak.fak58 = 0  END IF
        IF cl_null(g_fak.fak59)  THEN LET g_fak.fak59 = 0  END IF
        IF cl_null(g_fak.fak60)  THEN LET g_fak.fak60 = 0  END IF
        IF cl_null(g_fak.fak63)  THEN LET g_fak.fak63 = 0  END IF
        IF cl_null(g_fak.fak64)  THEN LET g_fak.fak64 = 0  END IF
        IF cl_null(g_fak.fak65)  THEN LET g_fak.fak65 = 0  END IF
        IF cl_null(g_fak.fak68)  THEN LET g_fak.fak68 = 0  END IF
        IF cl_null(g_fak.fak69)  THEN LET g_fak.fak69 = 0  END IF
        IF cl_null(g_fak.fak70)  THEN LET g_fak.fak70 = 0  END IF
        IF cl_null(g_fak.fak72)  THEN LET g_fak.fak72 = 0  END IF
        IF cl_null(g_fak.fak73)  THEN LET g_fak.fak73 = 0  END IF
        IF cl_null(g_fak.fak022)  THEN LET g_fak.fak022 = ' ' END IF
        LET g_fak.fak91='N'
        #-----No:FUN-AB0088-----
        IF cl_null(g_fak.fak292)  THEN LET g_fak.fak292 = 0    END IF
        IF cl_null(g_fak.fak302)  THEN LET g_fak.fak302 = 0    END IF
        IF cl_null(g_fak.fak332)  THEN LET g_fak.fak332 = 0    END IF
        IF cl_null(g_fak.fak342)  THEN LET g_fak.fak342 = 0    END IF
        IF cl_null(g_fak.fak352)  THEN LET g_fak.fak352 = 0    END IF
        IF cl_null(g_fak.fak362)  THEN LET g_fak.fak362 = 0    END IF
        #-----No:FUN-AB0088 END-----
        INSERT INTO fak_file VALUES(g_fak.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","fak_file",g_fak.fak01,g_fak.fak02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
       #-------- 更新系統參數檔之已用編號 ----------
        UPDATE faa_file SET faa191 = g_fak.fak01
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0 THEN
            CALL cl_err3("upd","faa_file",g_fak.fak01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
         ELSE
            LET g_fak_t.* = g_fak.*                # 保存上筆資料
            SELECT fak01,fak02,fak022 INTO g_fak.fak01,g_fak.fak02,g_fak.fak022 FROM fak_file
             WHERE fak01 = g_fak.fak01
        END IF
        CALL i101_g()
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i101_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
        l_modify_flag   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_lock_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_exit_sw       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_faa191        LIKE faa_file.faa191,        #No.FUN-680070 DEC(10,0)
        l_fak01         LIKE fak_file.fak01,         #No.FUN-680070 VARCHAR(10)
        l_count         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_max_0221,l_max_022 LIKE type_file.chr5,    #No.FUN-680070 VARCHAR(5)
        l_mxno          LIKE fak_file.fak022,
        l_fak27         LIKE fak_file.fak27,
        l_fak272        LIKE fak_file.fak272,   #No:FUN-AB0088
        l_fbi02         LIKE fbi_file.fbi02,
        l_fbi021        LIKE fbi_file.fbi021,        #No.FUN-680028
        l_n             LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_fak24         LIKE fak_file.fak24,         #MOD-630016
        l_fak242        LIKE fak_file.fak242   #No:FUN-AB0088
DEFINE  l_str           STRING,   #MOD-690087
        l_len,i         LIKE type_file.num5  #MOD-690087
   DEFINE l_day           LIKE type_file.chr2          #MOD-C90122
   DEFINE l_year          LIKE type_file.chr4          #MOD-C90122
   DEFINE l_month         LIKE type_file.chr2          #MOD-C90122
   DEFINE l_date          LIKE faj_file.faj26          #MOD-C90122
   DEFINE l_date2         LIKE type_file.chr8          #MOD-C90122
 
 
        INPUT BY NAME g_fak.fakoriu,g_fak.fakorig,
          g_fak.fak00,g_fak.fak01,g_fak.fak021,g_fak.fak02,g_fak.fak022,
          g_fak.fak03,g_fak.fak93,g_fak.fak04,g_fak.fak05,g_fak.fak09,             #FUN-9A0036 add g_fak.fak93
          g_fak.fak10,g_fak.fak11,g_fak.fak12,
          g_fak.fak06,g_fak.fak061,g_fak.fak07,g_fak.fak071,
          g_fak.fak08,
          g_fak.fak18,g_fak.fak17,g_fak.fak13,g_fak.fak14,g_fak.fak15,
          g_fak.fak16,
          g_fak.fak43,g_fak.fak91,g_fak.fak90,g_fak.fak901,
          g_fak.fak19,g_fak.fak20,g_fak.fak21,g_fak.fak22,
          g_fak.fak23,g_fak.fak24,g_fak.fak25,g_fak.fak26,
          g_fak.fak27,g_fak.fak34,g_fak.fak35,g_fak.fak36,
          g_fak.fak28,g_fak.fak29,g_fak.fak30,g_fak.fak31,
          g_fak.fak32,g_fak.fak33,g_fak.fak141,
          #-----No:FUN-AB0088-----
          #Asset 2
          g_fak.fak143,g_fak.fak144,g_fak.fak142,
          g_fak.fak232,g_fak.fak242,g_fak.fak262,g_fak.fak272,
          g_fak.fak342,g_fak.fak352,g_fak.fak362,g_fak.fak282,
          g_fak.fak292,g_fak.fak302,g_fak.fak312,g_fak.fak322,
          g_fak.fak332,g_fak.fak1412,
          #-----No:FUN-AB0088 END-----
          g_fak.fak62,g_fak.fak71,g_fak.fak61,g_fak.fak64,g_fak.fak65,   #FUN-840119
          g_fak.fak66,g_fak.fak67,g_fak.fak68,g_fak.fak63,
          g_fak.fak92,g_fak.fak37,g_fak.fak38,g_fak.fak39,
          g_fak.fak40,g_fak.fak41,
          g_fak.fak42,g_fak.fak421,g_fak.fak422,g_fak.fak423,g_fak.fak56,
          g_fak.fak53,g_fak.fak54,g_fak.fak55,g_fak.fak531,g_fak.fak541,g_fak.fak551,  #g_fak.fak44,     #No.FUN-680028  #No.TQC-6C0009 mark
          g_fak.fak44,g_fak.fak45,g_fak.fak46,g_fak.fak47,
          g_fak.fak48,g_fak.fak49,g_fak.fak51,g_fak.fak52, #No.FUN-840006 去掉g_fak.fak50字段
          g_fak.fakuser,g_fak.fakgrup,g_fak.fakmodu,g_fak.fakdate
         ,g_fak.fakud01,g_fak.fakud02,g_fak.fakud03,g_fak.fakud04,
          g_fak.fakud05,g_fak.fakud06,g_fak.fakud07,g_fak.fakud08,
          g_fak.fakud09,g_fak.fakud10,g_fak.fakud11,g_fak.fakud12,
          g_fak.fakud13,g_fak.fakud14,g_fak.fakud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i101_set_entry(p_cmd)
            CALL i101_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("fak46")
         CALL cl_set_docno_format("fak47")

        AFTER FIELD fak01
            #-->不可空白
            IF g_faa.faa04 = 'N' AND g_faa.faa19 ='N' THEN
               IF cl_null(g_fak.fak01) THEN
                  LET g_fak.fak01 = g_fak_t.fak01
                  DISPLAY BY NAME g_fak.fak01
                  NEXT FIELD fak01
               END IF
            END IF
            LET l_str = g_fak.fak01
            LET l_len = l_str.getlength()
            FOR i = 1 TO l_len
                IF l_str.substring(i,i) NOT MATCHES '[0123456789]' THEN
#                   CALL cl_err(g_fak.fak01,'apy-020',0)   #CHI-B40058
                   CALL cl_err(g_fak.fak01,'afa-205',0)    #CHI-B40058
                   NEXT FIELD fak01
                END IF
            END FOR
 
            IF g_faa.faa06 = 'Y' THEN
               LET g_fak.fak02 = g_fak.fak01
               DISPLAY BY NAME g_fak.fak02
            END IF
            LET g_fak_t.fak01 = g_fak.fak01
 
        AFTER FIELD fak02
            IF g_faa.faa05 = 'N' THEN
               IF cl_null(g_fak.fak02) THEN
                  LET g_fak.fak02 = g_fak_t.fak02
                  DISPLAY BY NAME g_fak.fak02
                  NEXT FIELD fak02
               END IF
            ELSE
               IF cl_null(g_fak.fak02) THEN
                  LET g_fak.fak02 = ' '
               END IF
            END IF
            LET g_fak_o.fak02 = g_fak.fak02
            IF cl_null(g_fak.fak93) THEN           #FUN-9A0036
               LET g_fak.fak93 = g_fak.fak02       #FUN-9A0036 
            END IF                                 #FUN-9A0036
            #MOD-BA0218 -- begin --
            IF g_aza.aza31 = 'N' AND g_faa.faa05 = 'N' AND g_faa.faa06 = 'N' THEN
               IF cl_null(g_fak.fak90) THEN
                  LET g_fak.fak90 = g_fak.fak02
                  DISPLAY BY NAME g_fak.fak90
               END IF
            END IF
            #MOD-BA0218 -- end --
 
        BEFORE FIELD fak021  #型態                                                                                                  
            CALL cl_set_comp_entry('fak022',TRUE)                                                                                   
 
        AFTER FIELD fak021  #型態
            IF cl_null(g_fak.fak022) THEN LET g_fak.fak022 = ' ' END IF
            IF NOT cl_null(g_fak.fak021) THEN
               IF g_fak.fak021 NOT MATCHES '[123]'
               THEN LET g_fak.fak021 = g_fak_t.fak021
                    DISPLAY BY NAME g_fak.fak021
                    NEXT FIELD fak021
               END IF
               #-->財編與序號是否一致
               IF g_faa.faa06 = 'Y' AND g_fak.fak021 matches '[23]'
               THEN CALL cl_err(g_faa.faa06,'afa-304',0)
                    NEXT FIELD fak021
               END IF
               IF g_fak.fak021 = '1' THEN
                 IF g_fak.fak02 != g_fak_t.fak02 OR  #check 編號是否重複
                    (g_fak.fak02 IS NOT NULL AND g_fak_t.fak02 IS NULL) THEN
                     SELECT count(*) INTO l_n FROM fak_file
                      WHERE fak02  = g_fak.fak02
                        AND fak021 = g_fak.fak021
                         IF l_n > 0 THEN
                            CALL cl_err('',-239,0)
                            LET g_fak.fak021 = g_fak_t.fak021
                            NEXT FIELD fak02
                         END IF
               END IF
               DISPLAY BY NAME g_fak.fak02
               #-->檢查財編存在固定資產檔
               #-->檢查財編存在固定資產底稿檔
               IF g_fak.fak02 != g_fak_t.fak02 OR
                    (g_fak.fak02 IS NOT NULL AND g_fak_t.fak02 IS NULL)
               THEN SELECT count(*) INTO l_n FROM faj_file
                                   WHERE faj02  = g_fak.fak02
                                     AND faj022 = g_fak.fak022
                      IF l_n > 0 THEN
                         CALL cl_err(' ',-239,0)
                         LET g_fak.fak022 = g_fak_t.fak022
                         NEXT FIELD fak02
                      END IF
                    SELECT count(*) INTO l_n FROM fak_file
                                   WHERE fak02  = g_fak.fak02
                                     AND fak022 = g_fak.fak022
                      IF l_n > 0 THEN
                         CALL cl_err(' ',-239,0)
                         LET g_fak.fak022 = g_fak_t.fak022
                         NEXT FIELD fak02
                      END IF
               END IF
              ELSE
                 IF g_fak.fak022 = '2' THEN NEXT FIELD fak022 END IF
              END IF
              LET g_fak_o.fak021 = g_fak.fak021
              IF g_fak.fak021 = '1' THEN                                                                                           
                 CALL cl_set_comp_entry('fak022',FALSE)                                                                             
              END IF                                                                                                                
           END IF
 
        BEFORE FIELD fak022
            #-->自動預設附號
            IF g_fak.fak021 matches '[23]' THEN
               CALL s_afamxno(g_fak.fak02,g_fak.fak021) RETURNING l_mxno
               LET g_fak.fak022 = l_mxno
               DISPLAY BY NAME g_fak.fak022
            END IF
 
        AFTER FIELD fak022
            IF g_fak.fak02 != g_fak_t.fak02 OR  #check 編號是否重複
               (g_fak.fak02 IS NOT NULL AND g_fak_t.fak02 IS NULL)
            THEN SELECT count(*) INTO l_n FROM faj_file
                   WHERE faj02  = g_fak.fak02
                     AND faj022 = g_fak.fak022
                      IF l_n > 0 THEN
                         CALL cl_err('',-239,0)
                         LET g_fak.fak022 = g_fak_t.fak022
                         NEXT FIELD fak022
                      END IF
                 #-->底稿不可重複
                 SELECT count(*) INTO l_n FROM fak_file
                   WHERE fak02  = g_fak.fak02
                     AND fak022 = g_fak.fak022
                     AND fak91  = 'N'
                      IF l_n > 0 THEN
                         CALL cl_err(g_fak.fak02,'afa-301',0)
                         LET g_fak.fak022 = g_fak_t.fak022
                         NEXT FIELD fak02
                      END IF
            END IF
            LET l_modify_flag = 'Y'
            IF (l_lock_sw = 'Y') THEN            #已鎖住
                LET l_modify_flag = 'N'
            END IF
            IF (l_modify_flag = 'N') THEN
                LET g_fak.fak022 = g_fak_t.fak022
                DISPLAY BY NAME g_fak.fak022
                NEXT FIELD fak022
            END IF
            #MOD-BA0218 -- begin --
            IF g_aza.aza31 = 'N' AND g_faa.faa05 = 'N' AND g_faa.faa06 = 'N' THEN
               IF cl_null(g_fak.fak901) THEN
                  LET g_fak.fak901 = g_fak.fak022
                  DISPLAY BY NAME g_fak.fak901
               END IF
            END IF
            #MOD-BA0218 -- end --
            LET g_fak_o.fak022 = g_fak.fak022
            DISPLAY BY NAME g_fak.fak022 #
 
         BEFORE FIELD fak43
           CALL i101_set_entry(p_cmd)
 
         AFTER FIELD fak43    #資產狀態
            IF NOT cl_null(g_fak.fak43) THEN
              #-MOD-AB0040-add-
               IF g_fak.fak43 NOT MATCHES '[04]' THEN 
                  CALL cl_err(g_fak.fak43,'afa-127',0)           
                  LET g_fak.fak43 = g_fak_t.fak43
                  DISPLAY BY NAME g_fak.fak43
                  NEXT FIELD fak43
               END IF
              #-MOD-AB0040-end-
               LET g_fak_o.fak43 = g_fak.fak43
               CALL i101_set_no_entry(p_cmd)
            END IF
 
        AFTER FIELD fak04     #主類別
            IF NOT cl_null(g_fak.fak04) THEN
               IF g_fak.fak04 <> g_fak_t.fak04 OR cl_null(g_fak_t.fak04) THEN
                  CALL i101_fak04('a')
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fak.fak04,g_errno,0)
                     LET g_fak.fak04 = g_fak_t.fak04
                     DISPLAY BY NAME g_fak.fak04 #
                     NEXT FIELD fak04
                  END IF
                  #--no:5705 若資產類別修改,故應立即重新計算預留殘值
                  CALL i101_3133()    #財簽
                  CALL i101_31332()    #財簽二   #No:FUN-AB0088

                  CALL i101_6668()    #稅簽
               END IF
               LET g_fak_o.fak04 = g_fak.fak04
            END IF
 
        AFTER FIELD fak05
            IF NOT cl_null(g_fak.fak05) THEN
               CALL i101_fak05('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_fak.fak05,g_errno,0)
                   LET g_fak.fak05 = g_fak_t.fak05
                   DISPLAY BY NAME g_fak.fak05 #
                   NEXT FIELD fak05
                END IF
            END IF
            LET g_fak_o.fak05 = g_fak.fak05
 
        AFTER FIELD fak09
            IF NOT cl_null(g_fak.fak09) THEN
               LET g_fak_o.fak09 = g_fak.fak09
            END IF
 
        AFTER FIELD fak10
            IF NOT cl_null(g_fak.fak10) THEN
               CALL i101_fak10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fak.fak10,g_errno,0)
                  LET g_fak.fak10 = g_fak_t.fak10
                  DISPLAY BY NAME g_fak.fak10 #
                  NEXT FIELD fak10
               END IF
            END IF
            IF cl_null(g_fak.fak11) THEN
               LET g_fak.fak11=g_fak.fak10
               DISPLAY BY NAME g_fak.fak11 #
            END IF
 
        AFTER FIELD fak17
            IF NOT cl_null(g_fak.fak17) THEN
               IF g_fak.fak17 < 0 THEN
                  CALL cl_err(g_fak.fak17,'afa-043',0)
                  NEXT FIELD fak17
               END IF
               IF g_fak.fak17 <>0 AND (g_fak_o.fak17<>g_fak.fak17
                  OR g_fak_o.fak17 IS NULL) THEN
                  LET g_fak.fak14 = g_fak.fak13 * g_fak.fak17
                  CALL cl_digcut(g_fak.fak14,g_azi04) RETURNING g_fak.fak14
               END IF
               DISPLAY BY NAME g_fak.fak14 #
               LET g_fak_o.fak17 = g_fak.fak17
            END IF
 
        AFTER FIELD fak18
            IF NOT cl_null(g_fak.fak18) THEN
               SELECT gfe01 FROM gfe_file WHERE gfe01 = g_fak.fak18
                                              AND gfeacti = 'Y'
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("sel","gfe_file",g_fak.fak18,"","afa-319","","",1)  #No.FUN-660136
                    NEXT FIELD fak18
                 END IF
            END IF
 
        AFTER FIELD fak13
            IF NOT cl_null(g_fak.fak13) THEN
               IF g_fak.fak13 < 0 THEN
                  CALL cl_err(g_fak.fak13,'anm-249',0)
                  NEXT FIELD fak13
               END IF
               IF g_fak.fak13 <>0 AND (g_fak_o.fak13<>g_fak.fak13
                   OR g_fak_o.fak13 IS NULL) THEN
                  LET g_fak.fak14 = g_fak.fak13 * g_fak.fak17
                  CALL cl_digcut(g_fak.fak14,g_azi04) RETURNING g_fak.fak14
                  DISPLAY BY NAME g_fak.fak14 #
               END IF
               LET g_fak_o.fak13 = g_fak.fak13
            END IF
 
        AFTER FIELD fak14
            IF NOT cl_null(g_fak.fak14) THEN
               IF g_fak.fak14 < 0 THEN
                  CALL cl_err(g_fak.fak14,'anm-249',0)
                  NEXT FIELD fak14
               END IF
               #TQC-C50117-add--str
               IF NOT cl_null(g_fak.fak15) AND NOT cl_null(g_fak.fak16) THEN
                  IF g_fak.fak15 = g_aza.aza17 THEN
                     IF g_fak.fak14 != g_fak.fak16 THEN
                        CALL cl_err(' ','afa-420',0)
                        LET g_fak.fak16 = g_fak.fak14
                        DISPLAY BY NAME g_fak.fak16
                     END IF
                  END IF
               END IF
               #TQC-C50117--add--end
               IF g_fak_o.fak14 <> g_fak.fak14 OR cl_null(g_fak.fak16) THEN
                  LET g_fak.fak62 = g_fak.fak14
                  LET g_fak.fak16 = g_fak.fak14
                  LET g_fak.fak142= g_fak.fak14 / g_fak.fak144#TQC-B50091
                  LET g_fak.fak142 = cl_digcut(g_fak.fak142,g_azi04_1) #CHI-C60010 add
                  DISPLAY BY NAME g_fak.fak16,g_fak.fak142    #No:FUN-AB0088   #
               END IF
               #新增時,預設未折減額=本幣成本-累計折舊-預留殘值
               IF (g_fak_o.fak14 != g_fak.fak14) OR
                  (g_fak.fak14 IS NOT NULL AND g_fak_o.fak14 IS NULL) THEN
                  CALL i101_3133()
                  CALL i101_31332()    #財簽二   #No:FUN-AB0088
                  CALL i101_6668()
                  IF cl_null(g_fak.fak32) THEN LET g_fak.fak32 = 0 END IF
                  IF cl_null(g_fak.fak31) THEN LET g_fak.fak31 = 0 END IF
                  IF cl_null(g_fak.fak322) THEN LET g_fak.fak322 = 0 END IF   #No:FUN-AB0088
                  IF cl_null(g_fak.fak312) THEN LET g_fak.fak312 = 0 END IF   #No:FUN-AB0088
                  IF cl_null(g_fak.fak142) THEN LET g_fak.fak142 = 0 END IF   #No:FUN-AB0088
                  IF cl_null(g_fak.fak62) THEN LET g_fak.fak62 = 0 END IF
                  IF cl_null(g_fak.fak67) THEN LET g_fak.fak67 = 0 END IF
                  IF cl_null(g_fak.fak66) THEN LET g_fak.fak66 = 0 END IF
                  DISPLAY BY NAME g_fak.fak33 #
               END IF
               IF g_fak.fak15 = g_aza.aza17 THEN
                  LET g_fak.fak16 = g_fak.fak14
                  DISPLAY BY NAME g_fak.fak16 #
               END IF
               LET g_fak_o.fak14 = g_fak.fak14
            END IF
#TQC-B50091
        AFTER FIELD fak144
            IF cl_null(g_fak_o.fak144) OR g_fak_o.fak144 <> g_fak.fak144 THEN
               LET g_fak.fak144=cl_digcut(g_fak.fak144,g_azi04_1)  #CHI-C60010 add
               LET g_fak.fak142 = g_fak.fak14 / g_fak.fak144
               CALL i101_31332()
               LET g_fak.fak142=cl_digcut(g_fak.fak142,g_azi04_1) #CHI-C60010 add
               DISPLAY BY NAME g_fak.fak142,g_fak.fak144  #CHI-C60010 add fak144
            END IF
#TQC-B50091
#CHI-C60010--add--str--
        AFTER FIELD fak142
           IF NOT cl_null(g_fak.fak142) THEN
             IF g_fak.fak142 < 0 THEN
                CALL cl_err(g_fak.fak142,'anm-249',0)
                NEXT FIELD fajk42
             END IF
             LET g_fak.fak142 = cl_digcut(g_fak.fak142,g_azi04_1)
             DISPLAY BY NAME g_fak.fak142
             LET g_fak_o.fak142 = g_fak.fak142
          END IF
#CHI-C60010--add--end
 
        AFTER FIELD fak16
            IF NOT cl_null(g_fak.fak16) THEN
               IF g_fak.fak16 < 0 THEN
                  CALL cl_err(g_fak.fak16,'anm-249',0)
                  NEXT FIELD fak16
               END IF
               #TQC-C50117-add--str
               IF NOT cl_null(g_fak.fak15) AND NOT cl_null(g_fak.fak14) THEN
                  IF g_fak.fak15 = g_aza.aza17 THEN
                     IF g_fak.fak14 != g_fak.fak16 THEN
                        CALL cl_err(' ','afa-420',1)
                        LET g_fak.fak16 = g_fak.fak14
                        DISPLAY BY NAME g_fak.fak16
                        NEXT FIELD fak16
                     END IF
                  END IF
               END IF
               #TQC-C50117--add-end
               LET g_fak_o.fak16 = g_fak.fak16
            END IF
 
        AFTER FIELD fak15
            IF NOT cl_null(g_fak.fak15) THEN
               CALL i101_fak15('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fak.fak15,g_errno,0)
                    LET g_fak.fak15 = g_fak_t.fak15
                    DISPLAY BY NAME g_fak.fak15 #
                    NEXT FIELD fak15
                 END IF
               LET g_fak_o.fak15 = g_fak.fak15
            END IF
 
        AFTER FIELD fak19
            IF NOT cl_null(g_fak.fak19) THEN
               IF g_fak_t.fak19 IS NULL OR (g_fak_t.fak19 != g_fak.fak19)
               THEN CALL i101_fak19('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_fak.fak19,g_errno,0)
                       LET g_fak.fak19 = g_fak_t.fak19
                       DISPLAY BY NAME g_fak.fak19 #
                       NEXT FIELD fak19
                  END IF
               END IF
            END IF
 
        AFTER FIELD fak20
            IF NOT cl_null(g_fak.fak20) THEN
               IF g_fak_t.fak20 IS NULL OR (g_fak_t.fak20 != g_fak.fak20)
               THEN CALL i101_fak20('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_fak.fak20,g_errno,0)
                       LET g_fak.fak20 = g_fak_t.fak20
                       DISPLAY BY NAME g_fak.fak20 #
                       NEXT FIELD fak20
                    END IF
               END IF
               LET g_fak_o.fak20 = g_fak.fak20
            END IF
 
        AFTER FIELD fak21   #存放位置
            IF not cl_null(g_fak.fak21) THEN
             IF g_fak_t.fak21 IS NULL OR (g_fak_t.fak21 != g_fak.fak21) THEN
               CALL i101_fak21('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_fak.fak21,g_errno,0)
                  LET g_fak.fak21 = g_fak_t.fak21
                  DISPLAY BY NAME g_fak.fak21 #
                  NEXT FIELD fak21
               END IF
             END IF
           END IF
           LET g_fak_o.fak21 = g_fak.fak21
 
        AFTER FIELD fak22  #存放工廠
           IF NOT cl_null(g_fak.fak22) AND g_faa.faa24 = 'Y' THEN
             IF g_fak_t.fak22 IS NULL OR (g_fak_t.fak22 != g_fak.fak22) THEN
                CALL i101_fak22('a')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_fak.fak22,g_errno,0)
                   LET g_fak.fak22 = g_fak_t.fak22
                   DISPLAY BY NAME g_fak.fak22 #
                   NEXT FIELD fak22
                END IF
             END IF
           END IF
           LET g_fak_o.fak22 = g_fak.fak22
 
        AFTER FIELD fak23
           IF NOT cl_null(g_fak.fak23) THEN
              IF g_fak.fak23 NOT MATCHES '[1-2]' THEN
                 LET g_fak.fak23 = g_fak_t.fak23
                 DISPLAY BY NAME g_fak.fak23 #
                 NEXT FIELD fak23
              END IF
              LET g_fak_o.fak23 = g_fak.fak23
           END IF
 
        AFTER FIELD fak92                #add by kitty 99-04-30
           LET g_fak_o.fak92 = g_fak.fak92
 
        BEFORE FIELD fak24
DISPLAY "BEFORE FIELD fak24"
           IF g_fak.fak23 = '1' THEN
              CALL cl_err(' ','afa-047',0)
               IF p_cmd = 'a' AND cl_null(g_fak.fak24) THEN   #No.MOD-540117
                 LET g_fak.fak24 = g_fak.fak20
                 DISPLAY BY NAME g_fak.fak24 #
              END IF
           ELSE
              CALL cl_err(' ','afa-048',0)
           END IF
 
        AFTER FIELD fak24
           IF g_fak.fak23 = '1' THEN
              IF cl_null(g_fak.fak24) THEN
                 NEXT FIELD fak24
              ELSE
                 CALL i101_fak241('a',g_fak.fak24)   #No:FUN-AB0088
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fak.fak24,g_errno,0)
                     LET g_fak.fak24 = g_fak_t.fak24
                     DISPLAY BY NAME g_fak.fak24
                     NEXT FIELD fak24
                  END IF
              END IF
              #--->預設部門會計科目
              IF g_faa.faa20 = '2' THEN
                    LET l_fbi02 = ''   
                   DECLARE i100_fbi
                       CURSOR FOR SELECT fbi02,fbi021 FROM fbi_file
                                        WHERE fbi01= g_fak.fak24  
                                          AND fbi03= g_fak.fak04
                   FOREACH i100_fbi INTO l_fbi02,l_fbi021
                     IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                     IF not cl_null(l_fbi02) THEN EXIT FOREACH END IF
                  #  IF g_aza.aza63 = 'Y' THEN
                     IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
                        IF NOT cl_null(l_fbi021) THEN
                           EXIT FOREACH
                        END IF
                     END IF
                   END FOREACH
                   IF (p_cmd = 'u' AND g_fak.fak24 <> g_fak_t.fak24) OR  
                      (p_cmd = 'u' AND g_fak_t.fak24 IS NULL) OR p_cmd = 'a' THEN
                      IF l_fak24 IS NULL OR g_fak.fak24 <> l_fak24 THEN
                         LET l_fak24 = g_fak.fak24
                         IF cl_null(l_fbi02) AND g_fak.fak28 NOT MATCHES '[0]' THEN 
                            CALL cl_err(g_fak.fak24,'afa-317',1)
                         END IF
                         LET g_fak.fak55 = l_fbi02
                         DISPLAY BY NAME g_fak.fak55
                         IF g_fak.fak55<>' ' AND g_fak.fak55 IS NOT NULL THEN
                            CALL i101_fak53(g_fak.fak55,g_bookno1) RETURNING aag02_3    #No.FUN-740026
                            DISPLAY aag02_3 TO FORMONLY.aag02_3
                         ELSE
                            DISPLAY ' ' TO FORMONLY.aag02_3
                         END IF
                     #   IF g_aza.aza63 = 'Y' THEN
                         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
                            IF cl_null(l_fbi021) AND g_fak.fak28 NOT MATCHES '[0]' THEN 
                               CALL cl_err(g_fak.fak24,'afa-317',1)
                            END IF
                            LET g_fak.fak551 = l_fbi021
                            DISPLAY BY NAME g_fak.fak551
                            IF g_fak.fak551<>' ' AND g_fak.fak551 IS NOT NULL THEN
                            #  CALL i101_fak53(g_fak.fak551,g_bookno2) RETURNING aag02_6    #NO.FUN-AB0088
                               CALL i101_fak53(g_fak.fak551,g_faa.faa02c) RETURNING aag02_6    #NO.FUN-AB0088
                               DISPLAY aag02_6 TO FORMONLY.aag02_6
                            ELSE
                               DISPLAY ' ' TO FORMONLY.aag02_6
                            END IF
                         END IF
                      END IF
                   END IF
              ELSE 
                   SELECT fab13 INTO g_fab13 FROM fab_file    #MOD-640521
                      WHERE fab01 = g_fak.fak04   #MOD-640521
                   IF cl_null(g_fak.fak55) THEN
                      LET g_fak.fak55 = g_fab13
                   END IF
                   IF cl_null(g_fab13) THEN
                     CALL cl_err(g_fak.fak24,'afa-318',1)
                   END IF
                #  IF g_aza.aza63 = 'Y' THEN
                   IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
                      SELECT fab131 INTO g_fab131 FROM fab_file    #MOD-640521
                         WHERE fab01 = g_fak.fak04   #MOD-640521
                      IF cl_null(g_fak.fak551) THEN
                         LET g_fak.fak551 = g_fab131
                      END IF
                      IF cl_null(g_fab131) THEN
                        CALL cl_err(g_fak.fak24,'afa-318',1)
                      END IF
                   END IF
              END IF
           ELSE
              IF cl_null(g_fak.fak24) THEN
                 NEXT FIELD fak24
              ELSE
                 CALL i101_fak242('a',g_fak.fak24,g_fak.fak53)   #No:FUN-AB0088
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fak.fak24,g_errno,1)
                     LET g_fak.fak24 = g_fak_t.fak24
                     DISPLAY BY NAME g_fak.fak24
                     NEXT FIELD fak24
                  END IF
              END IF
           END IF
           LET g_fak_o.fak24 = g_fak.fak24
 

 
        AFTER FIELD fak25
           IF NOT cl_null(g_fak.fak25) THEN
              IF p_cmd = 'a' THEN
                 LET g_fak.fak26 = g_fak.fak25
                 DISPLAY BY NAME g_fak.fak26 #
              END IF
              LET g_fak_o.fak25 = g_fak.fak25
           END IF
 
        AFTER FIELD fak26
           IF NOT cl_null(g_fak.fak26) THEN
              #FUN-B50090 add begin-------------------------
              #重新抓取關帳日期
              SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
              #FUN-B50090 add -end--------------------------
              IF g_fak.fak26 <= g_faa.faa09 THEN
                 CALL cl_err('','afa-517',1)
              END IF
             #------------------------MOD-C90122-----------------------(S)
              LET l_day = DAY(g_fak.fak26)
              CALL s_yp(g_fak.fak26) RETURNING l_year,l_month
              LET l_date2 = l_year USING '&&&&',l_month USING '&&',l_day USING '&&'
              LET l_date  = l_date2
              #CALL s_faj27(l_date,g_faa.faa15) RETURNING l_fak27  #mark by dengsy170301
              #str------ add by dengsy170301
              IF g_fak.fak09='2' THEN 
                 LET l_fak27=l_year USING '&&&&',l_month USING '&&'
              ELSE
                 CALL s_faj27(l_date,g_faa.faa15) RETURNING l_fak27 
              END IF 
              #end------ add by dengsy170301
             #CALL s_faj27(g_fak.fak26,g_faa.faa15) RETURNING l_fak27
             #IF p_cmd = 'a' THEN
             #------------------------MOD-C90122-----------------------(E)
              LET g_fak.fak27 = l_fak27
              DISPLAY BY NAME g_fak.fak27  
             #END IF                                  #MOD-C90122 mark
              LET g_fak_o.fak26 = g_fak.fak26
              CALL s_get_bookno(YEAR(g_fak.fak26))
                   RETURNING g_flag,g_bookno1,
                          #  g_bookno2       #NO.FUN-AB0088
                          #  g_faa.faa02c
                             g_bookno2  #TQC-B50020
              IF g_flag = '1' THEN   #抓不到帳套
                 CALL cl_err(g_fak.fak26,'aoo-081',1)
                 NEXT FIELD fak26
              END IF     
           END IF
 
        BEFORE FIELD fak28
           CALL i101_set_entry(p_cmd)
 
        AFTER FIELD fak28
           IF NOT cl_null(g_fak.fak28) THEN
              IF g_fak.fak28 NOT MATCHES '[0-5]' THEN
                 LET g_fak.fak28 = g_fak_t.fak28
                 DISPLAY BY NAME g_fak.fak28 #
                 NEXT FIELD fak28
              END IF
              IF g_fak.fak28 ='0' THEN   #NO:5153
                  LET  g_fak.fak29=0
                  LET  g_fak.fak30=0
                  LET  g_fak.fak31=0
                  LET  g_fak.fak32=0
                  LET  g_fak.fak33=g_fak.fak14
                  LET  g_fak.fak34='N'
                  LET  g_fak.fak35=0
                  LET  g_fak.fak36=0
                  DISPLAY BY NAME g_fak.fak29 ,g_fak.fak30
                                 ,g_fak.fak31 ,g_fak.fak32
                                 ,g_fak.fak33 ,g_fak.fak34
                                 ,g_fak.fak35 ,g_fak.fak36
              END IF                     #NO:5153
              IF g_fak.fak28 != g_fak_t.fak28 OR g_fak_t.fak28 IS NULL THEN
                 CALL i101_3133()
                 LET g_fak.fak66 = g_fak.fak31
                 LET g_fak.fak68 = g_fak.fak33
              END IF
              IF g_fak.fak64 != g_fak_t.fak64 OR g_fak_t.fak64 IS NULL THEN
                 CALL i101_6668()
              END IF
              LET g_fak_o.fak28 = g_fak.fak28
              CALL i101_set_no_entry(p_cmd)
           END IF
 
        BEFORE FIELD fak29
          #----推出配件/費用之耐用年限
          IF g_fak.fak021 matches '[23]' THEN
             IF p_cmd = 'a' OR (p_cmd='u' AND g_fak_o.fak29 != g_fak.fak29) THEN
                CALL s_afaym(g_fak.fak02,g_fak.fak27,'1') RETURNING g_fak.fak29
                LET g_fak.fak30 = g_fak.fak29
                CALL s_afaym(g_fak.fak02,g_fak.fak27,'2') RETURNING g_fak.fak64
                LET g_fak.fak65 = g_fak.fak64
                DISPLAY BY NAME g_fak.fak29,g_fak.fak30 #
             END IF
          END IF
 
        AFTER FIELD fak29
           IF NOT cl_null(g_fak.fak29) THEN
              IF g_fak.fak29 <0 THEN                                            
                 CALL cl_err(g_fak.fak29,'anm-249',0)                           
                 NEXT FIELD fak29                                               
              END IF                                                            
              #新增時,預設未使用年限為耐用年限
              IF p_cmd = 'a' AND g_fak.fak021 = '1' THEN
                 LET g_fak.fak30 = g_fak.fak29
                 LET g_fak.fak64 = g_fak.fak29
                 LET g_fak.fak65 = g_fak.fak64
                 DISPLAY BY NAME g_fak.fak30 #
              END IF
              IF p_cmd = 'a' AND g_fak.fak29 <> 0 THEN
                 CALL i101_3133()
                 LET g_fak.fak66 = g_fak.fak31
                 LET g_fak.fak68 = g_fak.fak33
              END IF
              IF p_cmd = 'u' AND g_fak_o.fak29 != g_fak.fak29 THEN
                 CALL i101_3133()
                 LET g_fak.fak66 = g_fak.fak31
                 LET g_fak.fak68 = g_fak.fak33
              END IF
              LET g_fak_o.fak29 = g_fak.fak29
           END IF
 
        BEFORE FIELD fak30
          IF g_fak.fak43 = '0' THEN
             LET g_fak.fak30 = g_fak.fak29
             DISPLAY BY NAME g_fak.fak30
          END IF
 
        AFTER FIELD fak30
           IF NOT cl_null(g_fak.fak30) THEN
              IF g_fak.fak30 <0 THEN                                            
                 CALL cl_err(g_fak.fak30,'anm-249',0)                           
                 NEXT FIELD fak30                                               
              END IF                                                            
              IF p_cmd = 'a' THEN
                 LET g_fak.fak65 = g_fak.fak30
              END IF
           END IF
 
        AFTER FIELD fak31
           IF NOT cl_null(g_fak.fak31) THEN
              IF g_fak.fak31 <0 THEN                                            
                 CALL cl_err(g_fak.fak31,'anm-249',0)                           
                 NEXT FIELD fak31                                               
              END IF                                                            
              IF p_cmd = 'a' THEN
                 LET g_fak.fak66 = g_fak.fak31
              END IF
              LET g_fak_o.fak31 = g_fak.fak31
           END IF
 
       AFTER FIELD fak32
          IF (g_fak_o.fak32 != g_fak.fak32 ) OR
             (g_fak.fak32 IS NOT NULL AND g_fak_o.fak32 IS NULL) THEN
              IF g_fak.fak32 <0 THEN                                            
                 CALL cl_err(g_fak.fak32,'anm-249',0)                           
                 NEXT FIELD fak32                                               
              END IF                                                            
             LET g_fak.fak33 = g_fak.fak14 - g_fak.fak32
             LET g_fak.fak68 = g_fak.fak62 - g_fak.fak67
             DISPLAY BY NAME g_fak.fak33 #
          END IF
          LET g_fak_o.fak32 = g_fak.fak32
 
        BEFORE FIELD fak33
          IF p_cmd = 'a' OR p_cmd = 'u' THEN
             LET g_fak.fak33 = g_fak.fak14 - g_fak.fak32
             LET g_fak.fak68 = g_fak.fak33
          END IF
 
        AFTER FIELD fak33
           IF NOT cl_null(g_fak.fak33) THEN                                     
              IF g_fak.fak33 <0 THEN                                            
                 CALL cl_err(g_fak.fak33,'anm-249',0)                           
                 NEXT FIELD fak33                                               
              END IF                                                            
           END IF                                                               
           IF p_cmd = 'a' THEN
              LET g_fak.fak68 = g_fak.fak62 - g_fak.fak67
           END IF
           LET g_fak_o.fak33 = g_fak.fak33
 
        BEFORE FIELD fak34
            CALL i101_set_entry(p_cmd)
 
        AFTER FIELD fak34
           IF NOT cl_null(g_fak.fak34) THEN
              IF g_fak.fak34 = 'Y' THEN
                # NEXT FIELD fak35
              ELSE
                 LET g_fak.fak35 = 0
                 LET g_fak.fak36 = 0
                 DISPLAY BY NAME g_fak.fak35,g_fak.fak36 #
                # NEXT FIELD fak92
              END IF
              LET g_fak_o.fak34 = g_fak.fak34
           END IF
            CALL i101_set_no_entry(p_cmd)
        AFTER FIELD fak35                                                       
          IF NOT cl_null(g_fak.fak35) THEN                                      
             IF g_fak.fak35 <0 THEN                                             
                CALL cl_err(g_fak.fak35,'anm-249',0)                            
                NEXT FIELD fak35                                                
             END IF                                                             
          END IF                                                                
                                                                                
        AFTER FIELD fak36                                                       
          IF NOT cl_null(g_fak.fak36) THEN                                      
             IF g_fak.fak36 <0 THEN                                             
                CALL cl_err(g_fak.fak36,'anm-249',0)                            
                NEXT FIELD fak36                                                
             END IF                                                             
          END IF                                                                
 
      AFTER FIELD fak90
          IF cl_null(g_fak.fak90) THEN LET g_fak.fak90 = ' ' END IF
          LET g_fak_o.fak90 = g_fak.fak90
 
      AFTER FIELD fak901
          IF NOT cl_null(g_fak.fak90) OR NOT cl_null(g_fak.fak901) THEN
             SELECT COUNT(*) INTO g_cnt FROM faj_file
              WHERE faj02  = g_fak.fak90
                AND faj022 = g_fak.fak901
             IF g_cnt > 0 THEN
                CALL cl_err(g_fak.fak90,'afa-118',0)
                LET g_fak.fak90  = g_fak_t.fak90
                LET g_fak.fak901 = g_fak_t.fak901
                DISPLAY BY NAME g_fak.fak90,g_fak.fak901 #
                NEXT FIELD fak90
             END IF
          END IF
          IF cl_null(g_fak.fak901) THEN LET g_fak.fak901 = ' ' END IF
          LET g_fak_o.fak901 = g_fak.fak901
 
      AFTER FIELD fak44   #進貨工廠
          IF NOT cl_null(g_fak.fak44) THEN
             CALL i101_fak44(p_cmd)   #MOD-590431
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_fak.fak44,g_errno,0)
                LET g_fak.fak44 = g_fak_t.fak44
                DISPLAY BY NAME g_fak.fak44 #
                NEXT FIELD fak44
             END IF
          END IF
          IF cl_null(g_fak.fak44) THEN LET g_fak.fak44 = ' ' END IF
          LET g_fak_o.fak44 = g_fak.fak44
 
       BEFORE FIELD fak53
           IF cl_null(g_fak.fak53) THEN
              SELECT fab11 INTO g_fak.fak53
                FROM fab_file
               WHERE fab01 = g_fak.fak04
           END IF
           IF g_fak.fak53<>' ' AND g_fak.fak53 IS NOT NULL THEN
              CALL i101_fak53(g_fak.fak53,g_bookno1) RETURNING aag02_1   #No.FUN-740026
              DISPLAY BY NAME g_fak.fak53
              DISPLAY aag02_1 TO FORMONLY.aag02_1
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_1
           END IF
           IF g_fak.fak54<>' ' AND g_fak.fak54 IS NOT NULL THEN
              CALL i101_fak53(g_fak.fak54,g_bookno1) RETURNING aag02_2    #No.FUN-740026 
              DISPLAY BY NAME g_fak.fak54
              DISPLAY aag02_2 TO FORMONLY.aag02_2
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_2
           END IF
           IF g_fak.fak55<>' ' AND g_fak.fak55 IS NOT NULL THEN
              CALL i101_fak53(g_fak.fak55,g_bookno1) RETURNING aag02_3     #No.FUN-740026
              DISPLAY BY NAME g_fak.fak55
              DISPLAY aag02_3 TO FORMONLY.aag02_3
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_3
           END IF
 
       AFTER FIELD fak53
           IF NOT cl_null(g_fak.fak53) THEN
              CALL i101_fak53(g_fak.fak53,g_bookno1) RETURNING aag02_1   #No.FUN-740026
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_fak.fak53,g_errno,1)
                 CALL cl_err(g_fak.fak53,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak53
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fak.fak53 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak53
                 DISPLAY BY NAME g_fak.fak53
                 #No.FUN-B10053  --End
                 DISPLAY ' ' TO FORMONLY.aag02_1
                 NEXT FIELD fak53
              END IF
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_1
              DISPLAY BY NAME g_fak.fak53
           END IF
 
       AFTER FIELD fak54
           IF NOT cl_null(g_fak.fak54) THEN
              CALL i101_fak53(g_fak.fak54,g_bookno1) RETURNING aag02_2   #No.FUN-740026
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_fak.fak54,g_errno,1)
                 CALL cl_err(g_fak.fak54,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak54
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fak.fak54 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak54
                 DISPLAY BY NAME g_fak.fak54
                 #No.FUN-B10053  --End 
                 DISPLAY ' ' TO FORMONLY.aag02_1
                 NEXT FIELD fak54
              END IF
              DISPLAY aag02_2 TO FORMONLY.aag02_2
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_2
              DISPLAY BY NAME g_fak.fak54
           END IF
 
       AFTER FIELD fak55
           IF NOT cl_null(g_fak.fak55) THEN
              CALL i101_fak53(g_fak.fak55,g_bookno1) RETURNING aag02_3    #No.FUN-740026
              IF NOT cl_null(g_errno) THEN 
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_fak.fak55,g_errno,1)
                 CALL cl_err(g_fak.fak55,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak55
                 LET g_qryparam.arg1 = g_bookno1
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fak.fak55 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak55
                 DISPLAY BY NAME g_fak.fak55
                 #No.FUN-B10053  --End 
                 DISPLAY ' ' TO FORMONLY.aag02_3
                 NEXT FIELD fak55
              END IF
              DISPLAY BY NAME g_fak.fak55
              IF cl_null(g_fak.fak55) THEN
                 DISPLAY ' ' TO FORMONLY.aag02_3
              ELSE
                 DISPLAY aag02_3 TO FORMONLY.aag02_3
              END IF
           END IF
       BEFORE FIELD fak531
        #  IF g_aza.aza63 = 'Y' THEN
           IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
              IF cl_null(g_fak.fak531) THEN
                 SELECT fab111 INTO g_fak.fak531
                   FROM fab_file
                  WHERE fab01 = g_fak.fak04
              END IF
              IF g_fak.fak531<>' ' AND g_fak.fak531 IS NOT NULL THEN
              #  CALL i101_fak53(g_fak.fak531,g_bookno2) RETURNING aag02_4      #No.FUN-740026   #No:FUN-AB0088
                 CALL i101_fak53(g_fak.fak531,g_faa.faa02c) RETURNING aag02_4   #No:FUN-AB0088
                 DISPLAY BY NAME g_fak.fak531
                 DISPLAY aag02_4 TO FORMONLY.aag02_4
              ELSE
                 DISPLAY ' ' TO FORMONLY.aag02_4
              END IF
              IF g_fak.fak541<>' ' AND g_fak.fak541 IS NOT NULL THEN
              #  CALL i101_fak53(g_fak.fak541,g_bookno2) RETURNING aag02_5     #No.FUN-740026     #No:FUN-AB0088
                 CALL i101_fak53(g_fak.fak541,g_faa.faa02c) RETURNING aag02_5   #No:FUN-AB0088
                 DISPLAY BY NAME g_fak.fak541
                 DISPLAY aag02_5 TO FORMONLY.aag02_5
              ELSE
                 DISPLAY ' ' TO FORMONLY.aag02_5
              END IF
              IF g_fak.fak551<>' ' AND g_fak.fak551 IS NOT NULL THEN
              #  CALL i101_fak53(g_fak.fak551,g_bookno2) RETURNING aag02_6     #No.FUN-740026   #No:FUN-AB0088
                 CALL i101_fak53(g_fak.fak551,g_faa.faa02c) RETURNING aag02_6   #No:FUN-AB0088
                 DISPLAY BY NAME g_fak.fak551
                 DISPLAY aag02_6 TO FORMONLY.aag02_6
              ELSE
                 DISPLAY ' ' TO FORMONLY.aag02_6
              END IF
           END IF
 
       AFTER FIELD fak531
           IF NOT cl_null(g_fak.fak531) THEN
           #  CALL i101_fak53(g_fak.fak531,g_bookno2) RETURNING aag02_4      #No.FUN-740026   #No:FUN-AB0088
              CALL i101_fak53(g_fak.fak531,g_faa.faa02c) RETURNING aag02_4    #No:FUN-AB0088
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_fak.fak531,g_errno,1)
                 CALL cl_err(g_fak.fak531,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak531
              #  LET g_qryparam.arg1 = g_bookno2      #No:FUN-AB0088
                 LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fak.fak531 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak531
                 DISPLAY BY NAME g_fak.fak531
                 #No.FUN-B10053  --End 
                 DISPLAY ' ' TO FORMONLY.aag02_4
                 NEXT FIELD fak531
              END IF
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_4
              DISPLAY BY NAME g_fak.fak531
           END IF
 
       AFTER FIELD fak541
           IF NOT cl_null(g_fak.fak541) THEN
           #  CALL i101_fak53(g_fak.fak541,g_bookno2) RETURNING aag02_5   #No.FUN-740026  #No:FUN-AB0088
              CALL i101_fak53(g_fak.fak541,g_faa.faa02c) RETURNING aag02_5   #No:FUN-AB0088
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_fak.fak541,g_errno,1)
                 CALL cl_err(g_fak.fak541,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak541
              #  LET g_qryparam.arg1 = g_bookno2      #No:FUN-AB0088
                 LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fak.fak541 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak541
                 DISPLAY BY NAME g_fak.fak541
                 #No.FUN-B10053  --End 
                 DISPLAY ' ' TO FORMONLY.aag02_5
                 NEXT FIELD fak541
              END IF
              DISPLAY aag02_5 TO FORMONLY.aag02_5
           ELSE
              DISPLAY ' ' TO FORMONLY.aag02_5
              DISPLAY BY NAME g_fak.fak541
           END IF
 
       AFTER FIELD fak551
           IF NOT cl_null(g_fak.fak551) THEN
            # CALL i101_fak53(g_fak.fak551,g_bookno2) RETURNING aag02_6   #No.FUN-740026  #No:FUN-AB0088
              CALL i101_fak53(g_fak.fak551,g_faa.faa02c) RETURNING aag02_6      #No:FUN-AB0088
              IF NOT cl_null(g_errno) THEN
                 #No.FUN-B10053  --Begin
                 #CALL cl_err(g_fak.fak551,g_errno,1)
                 CALL cl_err(g_fak.fak551,g_errno,0)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_fak.fak551
              #  LET g_qryparam.arg1 = g_bookno2      #No:FUN-AB0088
                 LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2' AND aagacti = 'Y' AND aag01 LIKE '",g_fak.fak551 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_fak.fak551
                 DISPLAY BY NAME g_fak.fak551
                 #No.FUN-B10053  --End 
                 DISPLAY ' ' TO FORMONLY.aag02_6
                 NEXT FIELD fak551
              END IF
              DISPLAY BY NAME g_fak.fak551
              IF cl_null(g_fak.fak551) THEN
                 DISPLAY ' ' TO FORMONLY.aag02_6
              ELSE
                 DISPLAY aag02_6 TO FORMONLY.aag02_6
              END IF
           END IF
 
      AFTER FIELD fak61
         IF NOT cl_null(g_fak.fak61) THEN
            IF g_fak.fak61 NOT MATCHES '[0-5]' THEN NEXT FIELD fak61 END IF
            IF g_fak.fak61 != g_fak_t.fak61 OR g_fak_t.fak61 IS NULL THEN
               CALL i101_6668()   #稅簽
            END IF
         END IF
 
      AFTER FIELD fak62                                                         
         IF NOT cl_null(g_fak.fak62) THEN                                        
            IF g_fak.fak62 <0 THEN                                            
               CALL cl_err(g_fak.fak62,'anm-249',0)                           
               NEXT FIELD fak62                                               
            END IF                                                            
            IF (g_fak_t.fak62 != g_fak.fak62) OR
               (g_fak.fak62 IS NOT NULL AND g_fak_t.fak62 IS NULL) THEN
               CALL i101_6668()   #稅簽
            END IF
            CALL cl_digcut(g_fak.fak62,g_azi04) RETURNING g_fak.fak62
            DISPLAY BY NAME g_fak.fak62
         END IF                                                                  
                                                                                
      AFTER FIELD fak63                                                         
         IF NOT cl_null(g_fak.fak63) THEN                                        
            IF g_fak.fak63 < 0 THEN                                              
               CALL cl_err(g_fak.fak63,'anm-249',0)                              
               NEXT FIELD fak63                                                  
            END IF                                                               
         END IF                                                                  
                                                                                
      AFTER FIELD fak64                                                         
         IF NOT cl_null(g_fak.fak64) THEN                                        
            IF g_fak.fak64 < 0 THEN                                              
               CALL cl_err(g_fak.fak64,'anm-249',0)                              
               NEXT FIELD fak64                                                  
            END IF
            IF (p_cmd='a' AND g_fak.fak64<>0) OR
               (p_cmd='u' AND g_fak_o.fak64 != g_fak.fak64) THEN
               CALL i101_6668()   #稅簽
            END IF
         END IF                                                                  
                                                                                
      AFTER FIELD fak65                                                         
         IF NOT cl_null(g_fak.fak65) THEN                                        
            IF g_fak.fak65 < 0 THEN                                              
               CALL cl_err(g_fak.fak65,'anm-249',0)                              
               NEXT FIELD fak65                                                  
            END IF                                                               
         END IF                                                                  
                                                                                
      AFTER FIELD fak66                                                         
         IF NOT cl_null(g_fak.fak66) THEN                                        
            IF g_fak.fak66 < 0 THEN                                              
               CALL cl_err(g_fak.fak66,'anm-249',0)                              
               NEXT FIELD fak66                                                  
            END IF                                                               
         END IF                                                                  
                                                                                
      AFTER FIELD fak67                                                         
         IF NOT cl_null(g_fak.fak67) THEN                                        
            IF g_fak.fak67 < 0 THEN                                              
               CALL cl_err(g_fak.fak67,'anm-249',0)                              
               NEXT FIELD fak67
            END IF                                                               
         END IF                                                                  
                                                                                
      AFTER FIELD fak68                                                         
         IF NOT cl_null(g_fak.fak68) THEN                                        
            IF g_fak.fak68 < 0 THEN                                              
               CALL cl_err(g_fak.fak68,'anm-249',0)                              
               NEXT FIELD fak68                                                  
            END IF                                                               
         END IF                                                                  
      
      #-----No:FUN-AB0088-----
        AFTER FIELD fak232
           IF NOT cl_null(g_fak.fak232) THEN
              IF g_fak.fak232 NOT MATCHES '[1-2]' THEN
                 LET g_fak.fak232 = g_fak_t.fak232
                 DISPLAY BY NAME g_fak.fak232
                 NEXT FIELD fak232
              END IF
              LET g_fak_o.fak232 = g_fak.fak232
           END IF

        BEFORE FIELD fak242
           IF g_fak.fak232 = '1' THEN
              CALL cl_err(' ','afa-047',0)
              IF p_cmd = 'a' AND cl_null(g_fak.fak242) THEN
                 LET g_fak.fak242 = g_fak.fak20
                 DISPLAY BY NAME g_fak.fak242
              END IF
           ELSE
              CALL cl_err(' ','afa-048',0)
           END IF

        AFTER FIELD fak242
           IF g_fak.fak232 = '1' THEN
              IF cl_null(g_fak.fak242) THEN
                 NEXT FIELD fak242
              ELSE
                 CALL i101_fak241('a',g_fak.fak242)   #No:FUN-AB0088
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_fak.fak242,g_errno,0)
                    LET g_fak.fak242 = g_fak_t.fak242
                    DISPLAY BY NAME g_fak.fak242
                    NEXT FIELD fak242
                 END IF
              END IF
              #--->預設部門會計科目
              IF g_faa.faa20 = '2' THEN
                 LET l_fbi02 = ''
                 DECLARE i100_fbi2 CURSOR FOR SELECT fbi02,fbi021 FROM fbi_file
                                              WHERE fbi01= g_fak.fak242
                                                AND fbi03= g_fak.fak04
                 FOREACH i100_fbi2 INTO l_fbi02,l_fbi021
                    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
                    IF NOT cl_null(l_fbi02) THEN EXIT FOREACH END IF
                    IF g_faa.faa31 = 'Y' THEN
                       IF NOT cl_null(l_fbi021) THEN
                          EXIT FOREACH
                       END IF
                    END IF
                 END FOREACH
                 IF (p_cmd = 'u' AND g_fak.fak242 <> g_fak_t.fak242) OR
                    (p_cmd = 'u' AND g_fak_t.fak242 IS NULL) OR p_cmd = 'a' THEN
                    IF l_fak242 IS NULL OR g_fak.fak242 <> l_fak242 THEN
                       LET l_fak242 = g_fak.fak242
                       IF cl_null(l_fbi021) AND g_fak.fak282 NOT MATCHES '[0]' THEN
                          CALL cl_err(g_fak.fak242,'afa-317',1)
                       END IF
                       LET g_fak.fak551 = l_fbi021
                       DISPLAY BY NAME g_fak.fak551
                       IF g_fak.fak551<>' ' AND g_fak.fak551 IS NOT NULL THEN
#                         CALL i101_fak53(g_fak.fak551) RETURNING aag02_6
                          CALL i101_fak53(g_fak.fak551,g_faa.faa02c) RETURNING aag02_6
                          DISPLAY aag02_6 TO FORMONLY.aag02_6
                       ELSE
                          DISPLAY ' ' TO FORMONLY.aag02_6
                       END IF
                    END IF
                 END IF
              ELSE
                 SELECT fab131 INTO g_fab131 FROM fab_file
                  WHERE fab01 = g_fak.fak04
                 IF cl_null(g_fak.fak551) THEN
                    LET g_fak.fak551 = g_fab131
                 END IF
                 IF cl_null(g_fab131) THEN
                   CALL cl_err(g_fak.fak242,'afa-318',1)
                 END IF
              END IF
           ELSE
              IF cl_null(g_fak.fak242) THEN
                 NEXT FIELD fak242
              ELSE
                 CALL i101_fak242('a',g_fak.fak242,g_fak.fak531)   #No:FUN-AB0088
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_fak.fak242,g_errno,1)
                     LET g_fak.fak242 = g_fak_t.fak242
                     DISPLAY BY NAME g_fak.fak242
                     NEXT FIELD fak242
                  END IF
              END IF
           END IF
           LET g_fak_o.fak242 = g_fak.fak242

        AFTER FIELD fak262
           IF NOT cl_null(g_fak.fak262) THEN
              #FUN-B50090 add begin-------------------------
              #重新抓取關帳日期
              SELECT faa09 INTO g_faa.faa09 FROM faa_file WHERE faa00='0'
              #FUN-B50090 add -end--------------------------
              #IF g_fak.fak262 <= g_faa.faa09 THEN
              IF g_fak.fak262 <= g_faa.faa092 THEN  #No:FUN-B60140
                 CALL cl_err('','afa-517',1)
              END IF
              #CALL s_faj27(g_fak.fak262,g_faa.faa15) RETURNING l_fak272
              CALL s_faj27(g_fak.fak262,g_faa.faa152) RETURNING l_fak272  #No:FUN-B60140
              IF p_cmd = 'a' THEN
                 LET g_fak.fak272 = l_fak272
                 DISPLAY BY NAME g_fak.fak272
              END IF
              LET g_fak_o.fak262 = g_fak.fak262
           END IF

        BEFORE FIELD fak282
           CALL i101_set_entry(p_cmd)

        AFTER FIELD fak282
           IF NOT cl_null(g_fak.fak282) THEN
              IF g_fak.fak282 NOT MATCHES '[0-5]' THEN
                 LET g_fak.fak282 = g_fak_t.fak282
                 DISPLAY BY NAME g_fak.fak282
                 NEXT FIELD fak282
              END IF
              IF g_fak.fak282='0' THEN
                 LET g_fak.fak292=0
                 LET g_fak.fak302=0
                 LET g_fak.fak312=0
                 LET g_fak.fak322=0
                 LET g_fak.fak332=g_fak.fak142
                 LET g_fak.fak342='N'
                 LET g_fak.fak352=0
                 LET g_fak.fak362=0
                 DISPLAY BY NAME g_fak.fak292,g_fak.fak302
                                ,g_fak.fak312,g_fak.fak32
                                ,g_fak.fak332,g_fak.fak34
                                ,g_fak.fak352,g_fak.fak36
              END IF
              LET g_fak_o.fak282 = g_fak.fak282
              CALL i101_set_no_entry(p_cmd)
           END IF

        BEFORE FIELD fak292
          #----推出配件/費用之耐用年限
          IF g_fak.fak021 MATCHES '[23]' THEN
             IF p_cmd = 'a' OR (p_cmd='u' AND g_fak_o.fak292 != g_fak.fak292) THEN
                CALL s_afaym(g_fak.fak02,g_fak.fak272,'1') RETURNING g_fak.fak292
                LET g_fak.fak302 = g_fak.fak292
                DISPLAY BY NAME g_fak.fak292,g_fak.fak302
             END IF
          END IF

        AFTER FIELD fak292
           IF NOT cl_null(g_fak.fak292) THEN
              IF g_fak.fak292 <0 THEN
                 CALL cl_err(g_fak.fak292,'anm-249',0)
                 NEXT FIELD fak292
              END IF
              #新增時,預設未使用年限為耐用年限
              IF p_cmd = 'a' AND g_fak.fak021 = '1' THEN
                 LET g_fak.fak302 = g_fak.fak292
                 DISPLAY BY NAME g_fak.fak302
              END IF
              IF p_cmd = 'a' AND g_fak.fak292 <> 0 THEN
                 CALL i101_31332()    #財簽二   #No:FUN-AB0088
              END IF
              IF p_cmd = 'u' AND g_fak_o.fak292 != g_fak.fak292 THEN
                 CALL i101_31332()    #財簽二   #No:FUN-AB0088
              END IF
              LET g_fak_o.fak292 = g_fak.fak292
           END IF

        BEFORE FIELD fak302
          IF g_fak.fak43 = '0' THEN
             LET g_fak.fak302 = g_fak.fak292
             DISPLAY BY NAME g_fak.fak302
          END IF

        AFTER FIELD fak302
           IF NOT cl_null(g_fak.fak302) THEN
              IF g_fak.fak302 <0 THEN
                 CALL cl_err(g_fak.fak302,'anm-249',0)
                 NEXT FIELD fak302
              END IF
           END IF

        AFTER FIELD fak312
           IF NOT cl_null(g_fak.fak312) THEN
              IF g_fak.fak312 <0 THEN
                 CALL cl_err(g_fak.fak312,'anm-249',0)
                 NEXT FIELD fak312
              END IF
              LET g_fak.fak312=cl_digcut(g_fak.fak312,g_azi04_1)  #CHI-C60010 add
              DISPLAY BY NAME g_fak.fak312  #CHI-C60010 add
              LET g_fak_o.fak312 = g_fak.fak312
           END IF

        AFTER FIELD fak322
           IF (g_fak_o.fak322 != g_fak.fak322 ) OR
              (g_fak.fak322 IS NOT NULL AND g_fak_o.fak322 IS NULL) THEN
              IF g_fak.fak322 <0 THEN
                 CALL cl_err(g_fak.fak322,'anm-249',0)
                 NEXT FIELD fak322
              END IF
              LET g_fak.fak322=cl_digcut(g_fak.fak322,g_azi04_1) #CHI-C60010 add
              LET g_fak.fak332 = g_fak.fak142 - g_fak.fak322
              LET g_fak.fak332 =cl_digcut(g_fak.fak332,g_azi04_1) #CHI-C60010 add
              DISPLAY BY NAME g_fak.fak332,g_fak.fak322  #CHI-C60010 add g_fak.fak322
           END IF
           LET g_fak_o.fak322 = g_fak.fak322

        BEFORE FIELD fak332
          IF p_cmd = 'a' OR p_cmd = 'u' THEN
             LET g_fak.fak332 = g_fak.fak142 - g_fak.fak322
          END IF

        AFTER FIELD fak332
           IF NOT cl_null(g_fak.fak332) THEN
              IF g_fak.fak332 <0 THEN
                 CALL cl_err(g_fak.fak332,'anm-249',0)
                 NEXT FIELD fak332
              END IF
              LET g_fak.fak332=cl_digcut(g_fak.fak332,g_azi04_1) #CHI-C60010 add
              DISPLAY BY NAME g_fak.fak332   #CHI-C60010 add
           END IF
           LET g_fak_o.fak332 = g_fak.fak332

        BEFORE FIELD fak342
           CALL i101_set_entry(p_cmd)

        AFTER FIELD fak342
           IF NOT cl_null(g_fak.fak342) THEN
              IF g_fak.fak342 = 'Y' THEN
              ELSE
                 LET g_fak.fak352 = 0
                 LET g_fak.fak362 = 0
                 DISPLAY BY NAME g_fak.fak352,g_fak.fak362
              END IF
              LET g_fak_o.fak342 = g_fak.fak342
           END IF
            CALL i101_set_no_entry(p_cmd)

        AFTER FIELD fak352
          IF NOT cl_null(g_fak.fak352) THEN
             IF g_fak.fak352 <0 THEN
                CALL cl_err(g_fak.fak352,'anm-249',0)
                NEXT FIELD fak352
             END IF
             LET g_fak.fak352=cl_digcut(g_fak.fak352,g_azi04_1) #CHI-C60010 add
             DISPLAY BY NAME g_fak.fak352   #CHI-C60010 add
          END IF

        AFTER FIELD fak362
          IF NOT cl_null(g_fak.fak362) THEN
             IF g_fak.fak362 <0 THEN
                CALL cl_err(g_fak.fak362,'anm-249',0)
                NEXT FIELD fak362
             END IF
          END IF
        #-----No:FUN-AB0088 END-----
        AFTER FIELD fakud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD fakud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INPUT
         LET g_fak.fakuser = s_get_data_owner("fak_file") #FUN-C10039
         LET g_fak.fakgrup = s_get_data_group("fak_file") #FUN-C10039
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF g_fak.fak02<>g_fak_t.fak02 or g_fak.fak022 <> g_fak_t.fak022 THEN
            SELECT fak01,fak02,fak022 FROM fak_file
             WHERE fak02=g_fak.fak02 and
                   fak022=g_fak.fak022
             IF sqlca.sqlcode=100 THEN
                SELECT faj01,faj02,faj022 FROM faj_file
                 WHERE faj02 = g_fak.fak02
                   AND faj022 = g_fak.fak022
                IF sqlca.sqlcode=0 THEN
        #          error "財編重覆..."
                   CALL cl_err('','afa-195',0)               #TQC-A40017 add
                   NEXT FIELD fak02
                END IF
             ELSE
        #        error "財編重覆..."
                  CALL cl_err('','afa-195',0)         #TQC-A40017 add
                NEXT FIELD fak02
             END IF
         END IF

         IF cl_null(g_fak.fak23) THEN
            CALL cl_err(g_fak.fak23,'afa-124',0)
            NEXT FIELD fak23
         END IF
         IF cl_null(g_fak.fak24) THEN
            CALL cl_err(g_fak.fak24,'afa-083',0)
            NEXT FIELD fak24
         END IF
         #-----No:FUN-AB0088-----
         IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
            IF cl_null(g_fak.fak232) THEN
               CALL cl_err(g_fak.fak232,'afa-124',0)
               NEXT FIELD fak232
            END IF
            IF cl_null(g_fak.fak242) THEN
               CALL cl_err(g_fak.fak242,'afa-083',0)
               NEXT FIELD fak242
            END IF
         END IF
         #-----No:FUN-AB0088 END-----
         IF g_fak.fak28 != 0 THEN    #MOD-590431 若不提折舊時可不設定折舊科目
            IF cl_null(g_fak.fak55) THEN
               CALL cl_err(g_fak.fak55,'afa-091',0)
               NEXT FIELD fak55
            END IF
         END IF   #MOD-590431
         IF cl_null(g_fak.fak37) THEN
            CALL cl_err(g_fak.fak37,'afa-086',0)
            NEXT FIELD fak37
         END IF
         IF cl_null(g_fak.fak38) THEN
            CALL cl_err(g_fak.fak38,'afa-087',0)
            NEXT FIELD fak38
         END IF
         IF cl_null(g_fak.fak39) THEN
            CALL cl_err(g_fak.fak39,'afa-088',0)
            NEXT FIELD fak39
         END IF
         IF cl_null(g_fak.fak40) THEN
            CALL cl_err(g_fak.fak40,'afa-090',0)
            NEXT FIELD fak40
         END IF
         IF cl_null(g_fak.fak41) THEN
            CALL cl_err(g_fak.fak41,'afa-089',0)
            NEXT FIELD fak41
         END IF
         IF cl_null(g_fak.fak42) THEN
            CALL cl_err(g_fak.fak42,'afa-090',0)
            NEXT FIELD fak42
         END IF

 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fak022)   #財產編號附號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fak"
                 LET g_qryparam.default1 = g_fak.fak02
                 LET g_qryparam.default2 = g_fak.fak022
                 CALL cl_create_qry() RETURNING g_fak.fak02,g_fak.fak022

                 DISPLAY BY NAME g_fak.fak02,g_fak.fak022
                 NEXT FIELD fak022
              WHEN INFIELD(fak04)   #資產類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fab"
                 LET g_qryparam.default1 = g_fak.fak04
                 CALL cl_create_qry() RETURNING g_fak.fak04

                 DISPLAY BY NAME g_fak.fak04 #
                 NEXT FIELD fak04
              WHEN INFIELD(fak05)   #次要類別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_fac"
                 LET g_qryparam.default1 = g_fak.fak05
                 CALL cl_create_qry() RETURNING g_fak.fak05

                 DISPLAY BY NAME g_fak.fak05 #
                 NEXT FIELD fak05
              WHEN INFIELD(fak10)   #供應廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_fak.fak10
                 CALL cl_create_qry() RETURNING g_fak.fak10

                 DISPLAY BY NAME g_fak.fak10 #
                 NEXT FIELD fak10
              WHEN INFIELD(fak11)   #製造廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_fak.fak11
                 CALL cl_create_qry() RETURNING g_fak.fak11

                 DISPLAY BY NAME g_fak.fak11 #
                 NEXT FIELD fak11
              WHEN INFIELD(fak12)   #原產地
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_geb"
                 LET g_qryparam.default1 = g_fak.fak12
                 CALL cl_create_qry() RETURNING g_fak.fak12

                 DISPLAY BY NAME g_fak.fak12 #
                 NEXT FIELD fak12
              WHEN INFIELD(fak18)   #計量單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 LET g_qryparam.default1 = g_fak.fak18
                 CALL cl_create_qry() RETURNING g_fak.fak18

                 DISPLAY BY NAME g_fak.fak18 #
                 NEXT FIELD fak18
              WHEN INFIELD(fak15)   #原幣幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_fak.fak15
                 CALL cl_create_qry() RETURNING g_fak.fak15

                 DISPLAY BY NAME g_fak.fak15 #
                 NEXT FIELD fak15
              WHEN INFIELD(fak19)   #保管人
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gen"
                 LET g_qryparam.default1 = g_fak.fak19
                 CALL cl_create_qry() RETURNING g_fak.fak19

                 DISPLAY BY NAME g_fak.fak19 #
                 NEXT FIELD fak19
              WHEN INFIELD(fak20)   #保管部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gem"
                 LET g_qryparam.default1 = g_fak.fak20
                 CALL cl_create_qry() RETURNING g_fak.fak20

                 DISPLAY BY NAME g_fak.fak20 #
                 NEXT FIELD fak20
              WHEN INFIELD(fak21)   #存放位置
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faf"
                 LET g_qryparam.default1 = g_fak.fak21
                 CALL cl_create_qry() RETURNING g_fak.fak21

                 DISPLAY BY NAME g_fak.fak21 #
                 NEXT FIELD fak21
              WHEN INFIELD(fak22)   #存放工廠
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
                 LET g_qryparam.default1 = g_fak.fak22
                 CALL cl_create_qry() RETURNING g_fak.fak22
                 DISPLAY BY NAME g_fak.fak22
                 NEXT FIELD fak22
              WHEN INFIELD(fak24)   #分攤部門
                 IF g_fak.fak23='1' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_fak.fak24
                    CALL cl_create_qry() RETURNING g_fak.fak24
                    DISPLAY BY NAME g_fak.fak24
                    NEXT FIELD fak24
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ='q_fad'
                    LET g_qryparam.default1 =g_fak.fak24
                    CALL cl_create_qry() RETURNING g_fak.fak53,g_fak.fak24
                    DISPLAY BY NAME g_fak.fak24
                    DISPLAY BY NAME g_fak.fak53
                    NEXT FIELD fak24
                 END IF
              #-----No:FUN-AB0088-----
              WHEN INFIELD(fak242)   #分攤部門
                 IF g_fak.fak232='1' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.default1 = g_fak.fak242
                    CALL cl_create_qry() RETURNING g_fak.fak242
                    DISPLAY BY NAME g_fak.fak242
                    NEXT FIELD fak242
                 ELSE
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ='q_fad'
                    LET g_qryparam.default1 =g_fak.fak242
                    CALL cl_create_qry() RETURNING g_fak.fak531,g_fak.fak242
                    DISPLAY BY NAME g_fak.fak242
                    DISPLAY BY NAME g_fak.fak531
                    NEXT FIELD fak242
                 END IF
              #-----No:FUN-AB0088 END-----
 
              WHEN INFIELD(fak44)   #進貨工廠
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_azp"    #FUN-990031 mark
                 LET g_qryparam.form = "q_azw"     #FUN-990031 add                                                                  
                 LET g_qryparam.where = "azw02 = '",g_legal,"' "    #FUN-990031 add
                 LET g_qryparam.default1 = g_fak.fak44
                 CALL cl_create_qry() RETURNING g_fak.fak44

                 DISPLAY BY NAME g_fak.fak44 #
                 NEXT FIELD fak44
              WHEN INFIELD(fak53)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.arg1 = g_bookno1    #No.FUN-740026
                 LET g_qryparam.default1 = g_fak.fak53
                 CALL cl_create_qry() RETURNING g_fak.fak53
                 DISPLAY BY NAME g_fak.fak53
                 NEXT FIELD fak53
              WHEN INFIELD(fak54)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.arg1 = g_bookno1    #No.FUN-740026
                 LET g_qryparam.default1 = g_fak.fak54
                 CALL cl_create_qry() RETURNING g_fak.fak54
                 DISPLAY BY NAME g_fak.fak54
                 NEXT FIELD fak54
              WHEN INFIELD(fak55)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
                 LET g_qryparam.arg1 = g_bookno1     #No.FUN-740026
                 LET g_qryparam.default1 = g_fak.fak55
                 CALL cl_create_qry() RETURNING g_fak.fak55
                 DISPLAY BY NAME g_fak.fak55
                 NEXT FIELD fak55
              WHEN INFIELD(fak531)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
             #   LET g_qryparam.arg1 = g_bookno2     #No.FUN-740026
                 LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088 
                 LET g_qryparam.default1 = g_fak.fak531
                 CALL cl_create_qry() RETURNING g_fak.fak531
                 DISPLAY BY NAME g_fak.fak531
                 NEXT FIELD fak531
              WHEN INFIELD(fak541)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
             #   LET g_qryparam.arg1 = g_bookno2     #No.FUN-740026
                 LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088 
                 LET g_qryparam.default1 = g_fak.fak541
                 CALL cl_create_qry() RETURNING g_fak.fak541
                 DISPLAY BY NAME g_fak.fak541
                 NEXT FIELD fak541
              WHEN INFIELD(fak551)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_aag"
                 LET g_qryparam.where = "aag07 IN ('2','3') AND aag03 ='2'"
             #   LET g_qryparam.arg1 = g_bookno2     #No.FUN-740026
                 LET g_qryparam.arg1 = g_faa.faa02c   #No:FUN-AB0088 
                 LET g_qryparam.default1 = g_fak.fak551
                 CALL cl_create_qry() RETURNING g_fak.fak551
                 DISPLAY BY NAME g_fak.fak551
                 NEXT FIELD fak551
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION main_category
                  CALL cl_cmdrun('afai010')
 
        ON ACTION sub_category
                  CALL cl_cmdrun('afai020')
 
        ON ACTION multi_dept_depr
                  CALL cl_cmdrun('afai030' CLIPPED)
 
       ON ACTION qry_mul_dept_appor  #分攤部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_fad"
                  LET g_qryparam.default1 = g_fak.fak24
                  CALL cl_create_qry() RETURNING g_fak.fak24,g_fak.fak53
                  DISPLAY BY NAME g_fak.fak24 #
                  NEXT FIELD fak24
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
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
END FUNCTION
 
#-------- 輸入資產類別後,自動帶出該類別之相關欄位 ---------
FUNCTION i101_fak04(p_cmd)
DEFINE
      p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_fabacti    LIKE fab_file.fabacti
 
     LET g_errno = ' '
     IF p_cmd = 'a'  THEN
     SELECT fab03,fab04,fab05,fab06,fab07,
            fab08,fab10,fab11,fab12,
            fab13,fab14,fab15,fab16,fab17,
            fab18,fab19,fab20,fab21,fab22,fabacti
       INTO g_fak.fak09,g_fak.fak28,g_fak.fak29,g_fak.fak61,g_fak.fak64,
            g_fak.fak34,g_fak.fak36,g_fak.fak53,g_fak.fak54,
            g_fab13,g_fak.fak37,g_fak.fak38,g_fak.fak39,g_fak.fak40,
            g_fak.fak41,g_fak.fak42,g_fak.fak421,g_fak.fak422,g_fak.fak423,
            l_fabacti
       FROM fab_file
      WHERE fab01 = g_fak.fak04
   # IF g_aza.aza63 = 'Y' THEN
     IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
        SELECT fab111,fab121,fab131,fab042,fab052,fab082   #No:FUN-AB0088 
          INTO g_fak.fak531,g_fak.fak541,g_fab131,
               g_fak.fak282,g_fak.fak292,g_fak.fak342      #No:FUN-AB0088
          FROM fab_file
         WHERE fab01 = g_fak.fak04
     END IF
     CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-045'
            LET g_fak.fak09 = NULL
            LET g_fak.fak28 = NULL   LET g_fak.fak37 = NULL
            LET g_fak.fak29 = NULL   LET g_fak.fak38 = NULL
            LET g_fak.fak61 = NULL   LET g_fak.fak39 = NULL
            LET g_fak.fak64 = NULL   LET g_fak.fak40 = NULL
            LET g_fak.fak34 = NULL   LET g_fak.fak41 = NULL
            LET g_fak.fak35 = NULL   LET g_fak.fak42 = NULL
            LET g_fak.fak36 = NULL   LET g_fak.fak421 = NULL
            LET g_fak.fak53 = NULL   LET g_fak.fak422 = NULL
            LET g_fak.fak54 = NULL   LET g_fak.fak423 = NULL
            LET l_fabacti = NULL
        #   IF g_aza.aza63 = 'Y' THEN
            IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
               LET g_fak.fak531 = NULL
               LET g_fak.fak541 = NULL
               #-----No:FUN-AB0088-----
               LET g_fak.fak551 = NULL
               LET g_fak.fak282 = NULL
               LET g_fak.fak292 = NULL
               LET g_fak.fak342 = NULL
               #-----No:FUN-AB0088 END-----
            END IF
         WHEN l_fabacti = 'N'  LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
     LET g_fak.fak55 = g_fab13        #No.FUN-680028
     LET g_fak.fak551 =  g_fab131     #No.FUN-680028
     #-->附件或附加費用
     IF g_fak.fak021 matches '[23]' THEN
        LET g_fak.fak29 = ' '  LET g_fak.fak30 = ' '
        LET g_fak.fak292= ' '  LET g_fak.fak302= ' '   #No:FUN-AB0088
     END IF
     DISPLAY BY NAME g_fak.fak09,g_fak.fak28,g_fak.fak29,g_fak.fak34,
                     g_fak.fak35,g_fak.fak36,#
                     g_fak.fak53,g_fak.fak54,g_fak.fak55     #No.FUN-680028
     IF g_fak.fak53<>' ' AND g_fak.fak53 IS NOT NULL THEN
        CALL i101_fak53(g_fak.fak53,g_aza.aza81) RETURNING aag02_1   #No.FUN-740026
        DISPLAY BY NAME g_fak.fak53
        DISPLAY aag02_1 TO FORMONLY.aag02_1
     ELSE
        DISPLAY ' ' TO FORMONLY.aag02_1
     END IF
     IF g_fak.fak54<>' ' AND g_fak.fak54 IS NOT NULL THEN
        CALL i101_fak53(g_fak.fak54,g_aza.aza81) RETURNING aag02_2    #No.FUN-740026 
        DISPLAY BY NAME g_fak.fak54
        DISPLAY aag02_2 TO FORMONLY.aag02_2
     ELSE
        DISPLAY ' ' TO FORMONLY.aag02_2
     END IF
     IF g_fak.fak55<>' ' AND g_fak.fak55 IS NOT NULL THEN
        CALL i101_fak53(g_fak.fak55,g_aza.aza81) RETURNING aag02_3     #No.FUN-740026 
        DISPLAY BY NAME g_fak.fak55
        DISPLAY aag02_3 TO FORMONLY.aag02_3
     ELSE
        DISPLAY ' ' TO FORMONLY.aag02_3
     END IF
   # IF g_aza.aza63 = 'Y' THEN
     IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
        DISPLAY BY NAME g_fak.fak531,g_fak.fak541,g_fak.fak551
        DISPLAY BY NAME g_fak.fak282,g_fak.fak292,g_fak.fak342   #No:FUN-AB0088
     END IF
     IF g_fak.fak531<>' ' AND g_fak.fak531 IS NOT NULL THEN
      # CALL i101_fak53(g_fak.fak531,g_aza.aza82) RETURNING aag02_4      #No.FUN-740026
        CALL i101_fak53(g_fak.fak531,g_faa.faa02c) RETURNING aag02_4    #No:FUN-AB0088 
        DISPLAY BY NAME g_fak.fak531
        DISPLAY aag02_4 TO FORMONLY.aag02_4
     ELSE
        DISPLAY ' ' TO FORMONLY.aag02_4
     END IF
     IF g_fak.fak541<>' ' AND g_fak.fak541 IS NOT NULL THEN
      # CALL i101_fak53(g_fak.fak541,g_aza.aza82) RETURNING aag02_5      #No.FUN-740026
      # CALL i101_fak53(g_fak.fak531,g_faa.faa02c) RETURNING aag02_5     #No:FUN-AB0088 #No:FUN-BA0112 mark
        CALL i101_fak53(g_fak.fak541,g_faa.faa02c) RETURNING aag02_5     #No:FUN-BA0112 add
        DISPLAY BY NAME g_fak.fak541
        DISPLAY aag02_5 TO FORMONLY.aag02_5
     ELSE
        DISPLAY ' ' TO FORMONLY.aag02_5
     END IF
     IF g_fak.fak551<>' ' AND g_fak.fak551 IS NOT NULL THEN
      # CALL i101_fak53(g_fak.fak551,g_aza.aza82) RETURNING aag02_6     #No.FUN-740026
      # CALL i101_fak53(g_fak.fak531,g_faa.faa02c) RETURNING aag02_6    #No:FUN-AB0088 #No:FUN-BA0112 mark
        CALL i101_fak53(g_fak.fak551,g_faa.faa02c) RETURNING aag02_6    #No:FUN-BA0112 add
        DISPLAY BY NAME g_fak.fak551
        DISPLAY aag02_6 TO FORMONLY.aag02_6
     ELSE
        DISPLAY ' ' TO FORMONLY.aag02_6
     END IF
     END IF
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
        DISPLAY BY NAME g_fak.fak09,g_fak.fak28,g_fak.fak29,g_fak.fak34,
                        g_fak.fak35,g_fak.fak36
     END IF
END FUNCTION
 
FUNCTION i101_fak05(p_cmd)
DEFINE  p_cmd     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_fac01   LIKE fac_file.fac01,
        l_facacti LIKE fac_file.facacti
 
     LET g_errno = ' '
     SELECT fac01,facacti INTO l_fac01,l_facacti
       FROM fac_file
      WHERE fac01 = g_fak.fak05
     CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-046'
                                  LET l_fac01 = NULL
                                  LET l_facacti = NULL
         WHEN l_facacti = 'N' LET g_errno = '9028'
         OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION
 
FUNCTION i101_fak10(p_cmd)
    DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    DEFINE l_pmc03   LIKE pmc_file.pmc03
    DEFINE l_pmcacti LIKE pmc_file.pmcacti
 
    SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti
           FROM pmc_file WHERE pmc01 = g_fak.fak10
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'aap-031'
         WHEN l_pmcacti = 'N'     LET g_errno = '9028'
         WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_pmc03 TO FORMONLY.pmc03 #
    END IF
END FUNCTION
 
FUNCTION i101_fak15(p_cmd)
DEFINE
      p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_azi01      LIKE azi_file.azi01,
      l_aziacti    LIKE azi_file.aziacti
 
      LET g_errno = ' '
      SELECT azi01,aziacti INTO l_azi01,l_aziacti
        FROM azi_file
        WHERE azi01 = g_fak.fak15
      CASE
          WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-050'
          WHEN l_aziacti = 'N' LET g_errno = '9028'
          OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
      END CASE
END FUNCTION
 
FUNCTION i101_fak19(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_gen02    LIKE gen_file.gen02,
       l_gen03    LIKE gen_file.gen03,
       l_genacti  LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,gen03,genacti INTO l_gen02,l_gen03,l_genacti
      FROM gen_file
     WHERE gen01 = g_fak.fak19
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg1312'
                                LET l_gen02 = NULL
                                LET l_genacti = NULL
       WHEN l_genacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF p_cmd = 'a' THEN
       LET g_fak.fak20 = l_gen03
       DISPLAY BY NAME g_fak.fak20 #
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd'
    THEN DISPLAY l_gen02 TO FORMONLY.gen02 #
    END IF
END FUNCTION
 
FUNCTION i101_fak20(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem01,gemacti INTO l_gem01,l_gemacti
      FROM gem_file
     WHERE gem01 = g_fak.fak20
    CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i101_fak21(p_cmd)
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_faf01    LIKE faf_file.faf01,
      l_faf03    LIKE faf_file.faf03,
      l_fafacti  LIKE faf_file.fafacti
 
     LET g_errno = ' '
     SELECT faf01,faf03,fafacti INTO l_faf01,l_faf03,l_fafacti
       FROM faf_file
      WHERE faf01 = g_fak.fak21
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-039'
                                LET l_faf01 = NULL
                                LET l_faf03 = NULL
                                LET l_fafacti = NULL
       WHEN l_fafacti = 'N'  LET g_errno = '9028'
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    LET g_fak.fak22 = l_faf03
    DISPLAY BY NAME g_fak.fak22 #
END FUNCTION
 
FUNCTION i101_fak22(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_azp01    LIKE azp_file.azp01
 
     IF g_faa.faa24 = 'N' THEN RETURN END IF
     LET g_errno = ' '
 
     SELECT * FROM azw_file                                                                                                         
      WHERE azw01 = g_fak.fak22  AND azw02 = g_legal                                                                                
     CASE
       WHEN SQLCA.SQLCODE = 100 #LET g_errno = 'afa-044'   #FUN-990031 mark
                                LET g_errno = 'agl-171'    #FUN-990031 add
                                LET l_azp01 = NULL
       OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i101_fak44(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       l_azp01    LIKE azp_file.azp01
 
   IF g_faa.faa24 = 'N' THEN RETURN END IF
   LET g_errno = ' '

   SELECT * FROM azw_file                                                                                                         
      WHERE azw01 = g_fak.fak44  AND azw02 = g_legal                                                                                
   CASE
     WHEN SQLCA.SQLCODE = 100 #LET g_errno = 'afa-044'     #FUN-990031 mark
                              LET g_errno = 'agl-171'      #FUN-990031 add
                              LET l_azp01 = NULL
     OTHERWISE             LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION i101_fak241(p_cmd,l_fak24)           #No:FUN-AB0088
DEFINE
      p_cmd      LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_gem01    LIKE gem_file.gem01,
      l_gemacti  LIKE gem_file.gemacti
DEFINE l_fak24   LIKE fak_file.fak24   #No:FUN-AB0088 
     LET g_errno = ' '
     SELECT gem01,gemacti INTO l_gem01,l_gemacti
       FROM gem_file
    #  WHERE gem01 = g_fak.fak24
       WHERE gem01 = l_fak24   #No:FUN-AB0088
     CASE
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-038'
                                LET l_gem01 = NULL
                                LET l_gemacti = NULL
       WHEN l_gemacti = 'N' LET g_errno = '9028'
       OTHERWISE            LET g_errno = SQLCA.SQLCODE USING '-------'
     END CASE
END FUNCTION
 
FUNCTION i101_fak242(p_cmd,l_fak24,l_fak53)   #No:FUN-AB0088
DEFINE
      p_cmd        LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
      l_cnt        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
      l_fak53      LIKE fak_file.fak53
DEFINE l_fak24   LIKE fak_file.fak24   #No:FUN-AB0088 
      LET g_errno = ' '
      IF cl_null(g_fak.fak53) THEN
         CALL cl_err(' ',STATUS,0)
      ELSE

       SELECT COUNT(*) INTO l_cnt FROM fad_file
            WHERE fad04 = g_fak.fak24
              AND fad03 = g_fak.fak53
              AND fadacti = 'Y'
       IF l_cnt = 0 THEN LET g_errno = 100 END IF
      END IF
END FUNCTION
 
FUNCTION i101_3133()
 
   IF g_aza.aza26 = '2' THEN
      SELECT fab23 INTO g_fab23 FROM fab_file WHERE fab01 = g_fak.fak04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","fab_file",g_fak.fak04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
         LET g_success = 'N' RETURN
      END IF
      IF g_fak.fak28 MATCHES '[05]' THEN
         LET g_fak.fak31 = 0
      ELSE
#         LET g_fak.fak31 = (g_fak.fak14-g_fak.fak32)*g_fab23/100  #MOD-A40033 mark
          LET g_fak.fak31 = g_fak.fak14*g_fab23/100  #MOD-A40033 
      END IF
   ELSE
      CASE g_fak.fak28
        WHEN '0'   LET g_fak.fak31 = 0
        WHEN '1'   LET g_fak.fak31 =
                       (g_fak.fak14-g_fak.fak32)/(g_fak.fak29 + 12)*12
        WHEN '2'   LET g_fak.fak31 = 0
        WHEN '3'   LET g_fak.fak31 = (g_fak.fak14-g_fak.fak32)/10
        WHEN '4'   LET g_fak.fak31 = 0
        WHEN '5'   LET g_fak.fak31 = 0
        OTHERWISE EXIT CASE
       END CASE
   END IF
   CALL cl_digcut(g_fak.fak31,g_azi04) RETURNING g_fak.fak31
   LET g_fak.fak33 = g_fak.fak14 - g_fak.fak32
   CALL cl_digcut(g_fak.fak33,g_azi04) RETURNING g_fak.fak33   #MOD-8C0144 add
   DISPLAY BY NAME g_fak.fak31,g_fak.fak33
END FUNCTION
 
#-----No:FUN-AB0088-----
FUNCTION i101_31332()     #財簽二

  #-MOD-B70093-add-
   IF g_faa.faa31 <> 'Y' THEN    
      RETURN
   END IF
  #-MOD-B70093-end-
   IF g_aza.aza26 = '2' THEN
      SELECT fab232 INTO g_fab232 FROM fab_file WHERE fab01 = g_fak.fak04
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","fab_file",g_fak.fak04,"",SQLCA.sqlcode,"","",1)
         LET g_success = 'N'
         RETURN
      END IF

      IF g_fak.fak282 MATCHES '[05]' THEN
         LET g_fak.fak312 = 0
      ELSE
          LET g_fak.fak312 = g_fak.fak142*g_fab232/100
      END IF
   ELSE
      CASE g_fak.fak282
        WHEN '0'   LET g_fak.fak312 = 0
        WHEN '1'   LET g_fak.fak312 = (g_fak.fak142-g_fak.fak322)/(g_fak.fak292 + 12)*12
        WHEN '2'   LET g_fak.fak312 = 0
        WHEN '3'   LET g_fak.fak312 = (g_fak.fak142-g_fak.fak322)/10
        WHEN '4'   LET g_fak.fak312 = 0
        WHEN '5'   LET g_fak.fak312 = 0
        OTHERWISE EXIT CASE
       END CASE
   END IF

  #CALL cl_digcut(g_fak.fak312,g_azi04) RETURNING g_fak.fak312    #CHI-C60010 mark
   CALL cl_digcut(g_fak.fak312,g_azi04_1) RETURNING g_fak.fak312  #CHI-C60010 add
   LET g_fak.fak332 = g_fak.fak142 - g_fak.fak322
  #CALL cl_digcut(g_fak.fak332,g_azi04) RETURNING g_fak.fak332 #  CHI-C60010 mark
   CALL cl_digcut(g_fak.fak332,g_azi04_1) RETURNING g_fak.fak332  #CHI-C60010 add
   DISPLAY BY NAME g_fak.fak312,g_fak.fak332

END FUNCTION
#-----No:FUN-AB0088 END-----

FUNCTION i101_6668()
 
   IF g_aza.aza26 = '2' THEN
      SELECT fab23 INTO g_fab23 FROM fab_file WHERE fab01 = g_fak.fak04   #MOD-640501
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","fab_file",g_fak.fak04,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
         LET g_success = 'N' RETURN
      END IF
      IF g_fak.fak61 MATCHES '[05]' THEN
         LET g_fak.fak66 = 0
      ELSE
#         LET g_fak.fak66 = (g_fak.fak62-g_fak.fak67)*g_fab23/100  #MOD-A40033 mark
          LET g_fak.fak66 = g_fak.fak62*g_fab23/100  #MOD-A40033 
      END IF
   ELSE
      CASE g_fak.fak61
        WHEN '0'   LET g_fak.fak66 = 0
        WHEN '1'   LET g_fak.fak66 =
                   (g_fak.fak62-g_fak.fak67)/(g_fak.fak64 + 12)* 12
        WHEN '2'   LET g_fak.fak66 = 0
        WHEN '3'   LET g_fak.fak66 = (g_fak.fak62-g_fak.fak67)/10
        WHEN '4'   LET g_fak.fak66 = 0
        WHEN '5'   LET g_fak.fak66 = 0
        OTHERWISE EXIT CASE
      END CASE
   END IF
   CALL cl_digcut(g_fak.fak66,g_azi04) RETURNING g_fak.fak66
   LET g_fak.fak68 = g_fak.fak62 - g_fak.fak67
   CALL cl_digcut(g_fak.fak68,g_azi04) RETURNING g_fak.fak68   #MOD-8C0144 add
   DISPLAY BY NAME g_fak.fak66,g_fak.fak68                     #MOD-8C0144 add
END FUNCTION
 
FUNCTION i101_q()          #查詢
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fak.* TO NULL             #No.FUN-6A0001    
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i101_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    OPEN i101_count
    FETCH i101_count INTO g_row_count #CKP
    DISPLAY g_row_count TO FORMONLY.cnt #CKP
    OPEN i101_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fak.fak01,SQLCA.sqlcode,0)
        INITIALIZE g_fak.* TO NULL
    ELSE
       CALL i101_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
END FUNCTION
 
FUNCTION i101_fetch(p_flfak)
    DEFINE
        p_flfak          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
        l_abso          LIKE type_file.num10        #No.FUN-680070 INTEGER
 
    CASE p_flfak
        WHEN 'N' FETCH NEXT     i101_cs INTO g_fak.fak01,g_fak.fak02,g_fak.fak022
        WHEN 'P' FETCH PREVIOUS i101_cs INTO g_fak.fak01,g_fak.fak02,g_fak.fak022
        WHEN 'F' FETCH FIRST    i101_cs INTO g_fak.fak01,g_fak.fak02,g_fak.fak022
        WHEN 'L' FETCH LAST     i101_cs INTO g_fak.fak01,g_fak.fak02,g_fak.fak022
        WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump #CKP3
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
         FETCH ABSOLUTE g_jump i101_cs INTO g_fak.fak01,g_fak.fak02,g_fak.fak022
         LET mi_no_ask = FALSE
    END CASE
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fak.fak01,SQLCA.sqlcode,0)
        INITIALIZE g_fak.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flfak
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump #CKP3
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_fak.* FROM fak_file        # 重讀DB,因TEMP有不被更新特性
       WHERE  fak01 = g_fak.fak01 AND fak02 = g_fak.fak02 AND fak022 = g_fak.fak022
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fak_file",g_fak.fak01,g_fak.fak02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        LET g_data_owner = g_fak.fakuser    #FUN-4C0059
        LET g_data_group = g_fak.fakgrup    #FUN-4C0059
        CALL s_get_bookno(YEAR(g_fak.fak26))
             RETURNING g_flag,g_bookno1,
                   #   g_bookno2             #NO.FUN-AB0088
                   #   g_faa.faa02c          #NO.FUN-AB0088
                       g_bookno2    #TQC-B50020
        IF g_flag = '1' THEN   #抓不到帳套
           CALL cl_err(g_fak.fak26,'aoo-081',1)
        END IF     
        CALL i101_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i101_show()
    LET g_fak_t.* = g_fak.*
    LET g_fak_o.*=g_fak.*
    DISPLAY BY NAME g_fak.fakoriu,g_fak.fakorig,
          g_fak.fak00,g_fak.fak01,g_fak.fak021,g_fak.fak02,g_fak.fak022,
          g_fak.fak03,g_fak.fak93,g_fak.fak04,g_fak.fak05,g_fak.fak09,             #FUN-9A0036 add g_fak.fak93
          g_fak.fak06,g_fak.fak061,g_fak.fak07,g_fak.fak071,
          g_fak.fak08,g_fak.fak10,g_fak.fak11,g_fak.fak12,
          g_fak.fak18,g_fak.fak17,g_fak.fak13,g_fak.fak14,g_fak.fak15,
          g_fak.fak16,g_fak.fak19,g_fak.fak20,g_fak.fak21,g_fak.fak22,
          g_fak.fak43,g_fak.fak91,g_fak.fak90,g_fak.fak901,
          g_fak.fak23,g_fak.fak24,g_fak.fak25,g_fak.fak26,
          g_fak.fak27,g_fak.fak34,g_fak.fak35,g_fak.fak36,
          g_fak.fak28,g_fak.fak29,g_fak.fak30,g_fak.fak31,
          g_fak.fak32,g_fak.fak33,g_fak.fak141,
          #-----No:FUN-AB0088-----
          g_fak.fak143,g_fak.fak144,g_fak.fak142,
          g_fak.fak232,g_fak.fak242,g_fak.fak262,
          g_fak.fak272,g_fak.fak342,g_fak.fak352,g_fak.fak362,
          g_fak.fak282,g_fak.fak292,g_fak.fak302,g_fak.fak312,
          g_fak.fak322,g_fak.fak332,g_fak.fak1412,
          #-----No:FUN-AB0088 END-----
          g_fak.fak62,g_fak.fak71,g_fak.fak61,g_fak.fak64,g_fak.fak65,   #FUN-840119
          g_fak.fak66,g_fak.fak67,g_fak.fak68,g_fak.fak63,
          g_fak.fak92,g_fak.fak37,g_fak.fak38,g_fak.fak39,
          g_fak.fak40,g_fak.fak41,
          g_fak.fak42,g_fak.fak421,g_fak.fak422,g_fak.fak423,g_fak.fak56,
          g_fak.fak53,g_fak.fak54,g_fak.fak55,  #g_fak.fak44, #No.TQC-6C0009 mark
          g_fak.fak531,g_fak.fak541,g_fak.fak551,             #No.FUN-680028
          g_fak.fak44,g_fak.fak45,g_fak.fak451,g_fak.fak46,g_fak.fak461,g_fak.fak47,g_fak.fak471,   #NO.TQC-A40016
          g_fak.fak48,g_fak.fak49,g_fak.fak51,g_fak.fak52,    #No.FUN-840006 去掉g_fak.fak50字段
          g_fak.fakuser,g_fak.fakgrup,g_fak.fakmodu,g_fak.fakdate
          ,g_fak.fakud01,g_fak.fakud02,g_fak.fakud03,g_fak.fakud04,
           g_fak.fakud05,g_fak.fakud06,g_fak.fakud07,g_fak.fakud08,
           g_fak.fakud09,g_fak.fakud10,g_fak.fakud11,g_fak.fakud12,
           g_fak.fakud13,g_fak.fakud14,g_fak.fakud15 
    CALL i101_fak19('d')
    CALL i101_fak10('d')

    CALL i101_fak53(g_fak.fak53,g_bookno1) RETURNING aag02_1
    CALL i101_fak53(g_fak.fak54,g_bookno1) RETURNING aag02_2
    CALL i101_fak53(g_fak.fak55,g_bookno1) RETURNING aag02_3
    DISPLAY aag02_1 TO FORMONLY.aag02_1
    DISPLAY aag02_2 TO FORMONLY.aag02_2
    DISPLAY aag02_3 TO FORMONLY.aag02_3
  # IF g_aza.aza63 = 'Y' THEN
    IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088 
    #  CALL i101_fak53(g_fak.fak531,g_bookno2) RETURNING aag02_4    #No.TQC-740144
    #  CALL i101_fak53(g_fak.fak541,g_bookno2) RETURNING aag02_5    #No.TQC-740144
    #  CALL i101_fak53(g_fak.fak551,g_bookno2) RETURNING aag02_6    #No.TQC-740144
       CALL i101_fak53(g_fak.fak531,g_faa.faa02c) RETURNING aag02_4   #No:FUN-AB0088    #No:TQC-740144
       CALL i101_fak53(g_fak.fak541,g_faa.faa02c) RETURNING aag02_5   #No:FUN-AB0088    #No:TQC-740144
       CALL i101_fak53(g_fak.fak551,g_faa.faa02c) RETURNING aag02_6   #No:FUN-AB0088    #No.TQC-740144
       DISPLAY aag02_4 TO FORMONLY.aag02_4
       DISPLAY aag02_5 TO FORMONLY.aag02_5
       DISPLAY aag02_6 TO FORMONLY.aag02_6
    END IF
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i101_u()          #更改
    DEFINE l_zz13           LIKE zz_file.zz13     #MOD-C30862 add

    IF s_shut(0) THEN RETURN END IF
    IF g_fak.fak01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
   #------------------------MOD-C30862---------------------(s)
    SELECT zz13 INTO l_zz13 FROM zz_file
     WHERE zz01 = g_prog
   #------------------------MOD-C30862---------------------(e)
    IF g_fak.fak91 = 'Y' THEN CALL cl_err('','afa-123',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fak_t.*=g_fak.*
    BEGIN WORK
 
    OPEN i101_cl USING g_fak.fak01,g_fak.fak02,g_fak.fak022
 
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_fak.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fak.fak01,SQLCA.sqlcode,0)
        CLOSE i101_cl                                 #MOD-C30862 add
        ROLLBACK WORK                                 #MOD-C30862 add
        RETURN
    END IF
    LET g_fak.fakmodu=g_user                     #修改者
    LET g_fak.fakdate = g_today                  #修改日期
    CALL i101_show()                             # 顯示最新資料
    WHILE TRUE
    #CHI-C60010--add--str--
       SELECT aaa03 INTO g_fak.fak143 FROM aaa_file
        WHERE aaa01 = g_faa.faa02c
       IF NOT cl_null(g_fak.fak143) THEN
          SELECT azi04 INTO g_azi04_1 FROM azi_file
           WHERE azi01 = g_fak.fak143
       END IF
    #CHI-C60010--add--end
        CALL i101_i("u")                         # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_fak.*=g_fak_t.*
            CALL i101_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE fak_file SET fak_file.* = g_fak.*    # 更新DB
            WHERE fak01 = g_fak_t.fak01 AND fak02 = g_fak_t.fak02 AND fak022 = g_fak_t.fak022               # COLAUTH?
       #IF SQLCA.sqlcode THEN                                                  #MOD-C30862 mark
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN                          #MOD-C30862 add
            CALL cl_err3("upd","fak_file",g_fak01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        ELSE                                                #MOD-C30862 add
           IF l_zz13 = 'Y' THEN                             #MOD-C30862 add
              CLOSE i101_cl                                 #MOD-C30862 add
              COMMIT WORK                                   #MOD-C30862 add
           END IF                                           #MOD-C30862 add
        END IF
        CALL i101_g()
        EXIT WHILE
    END WHILE
    CLOSE i101_cl
    COMMIT WORK
   #-------------------MOD-C30862-----(s)
    IF l_zz13 = 'Y' THEN
       OPEN i101_cs
       LET g_jump = g_curs_index
       LET mi_no_ask = TRUE
       CALL i101_fetch('/')
    END IF
   #-------------------MOD-C30862-----(e)
END FUNCTION
 
FUNCTION i101_r()        #取消
    DEFINE
        l_chr LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fak.fak01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fak.fak91 = 'Y' THEN CALL cl_err('','afa-123',0) RETURN END IF
    BEGIN WORK
 
    OPEN i101_cl USING g_fak.fak01,g_fak.fak02,g_fak.fak022
 
    IF STATUS THEN
       CALL cl_err("OPEN i101_cl:", STATUS, 1)
       CLOSE i101_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i101_cl INTO g_fak.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fak.fak01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL i101_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL           #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fak01"          #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fak.fak01       #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "fak02"          #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_fak.fak02       #No.FUN-9B0098 10/02/24
        LET g_doc.column3 = "fak022"         #No.FUN-9B0098 10/02/24
        LET g_doc.value3 = g_fak.fak022      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                          #No.FUN-9B0098 10/02/24
       DELETE FROM fak_file WHERE
                              fak00 = g_fak.fak00 and
                              fak01 = g_fak.fak01 and
                              fak02 = g_fak.fak02 and
                              fak022 = g_fak.fak022
       IF SQLCA.SQLCODE<>0 OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","fak_file",g_fak.fak01,g_fak.fak02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
       ELSE CLEAR FORM
         OPEN i101_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i101_cs
             CLOSE i101_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         FETCH i101_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i101_cs
             CLOSE i101_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN i101_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i101_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL i101_fetch('/')
         END IF
       END IF
    END IF
    CLOSE i101_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i101_copy()         #複製
   DEFINE l_fak           RECORD LIKE fak_file.*,
          l_oldno1,l_newno1 LIKE fak_file.fak01,
          l_oldno2,l_newno2 LIKE fak_file.fak02,
          l_fak01         LIKE fak_file.fak01,
          l_faa191        LIKE faa_file.faa191
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fak.fak01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE
    CALL i101_set_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno1,l_newno2 FROM fak01,fak02
 
        BEFORE FIELD fak01
            IF g_faa.faa19 = 'Y' THEN         #自動編號
               SELECT faa191 INTO l_faa191 FROM faa_file
               LET l_faa191 = l_faa191 + 1
               LET l_newno1 = l_faa191 USING '&&&&&&&&&&'
               LET g_fak.fak01 = l_newno1
               DISPLAY BY NAME g_fak.fak01 #
            END IF
 
        AFTER FIELD fak01
            IF g_faa.faa04 = 'N' THEN
               IF cl_null(l_newno1) THEN      #不可空白
                  NEXT FIELD fak01
               END IF
            END IF
            SELECT count(*) INTO g_cnt FROM fak_file
             WHERE fak01 = l_newno1
               AND fak02 = l_newno2
            IF g_cnt > 0 THEN
               LET g_msg = l_newno1,l_newno2 CLIPPED
               CALL cl_err(g_msg,-239,0)
               NEXT FIELD fak01
            END IF
 
        AFTER FIELD fak02
            IF NOT cl_null(l_newno2) THEN
               SELECT count(*) INTO g_cnt FROM fak_file
                WHERE fak01 = l_newno1
                  AND fak02 = l_newno2
               IF g_cnt > 0 THEN
                  LET g_msg = l_newno1,l_newno2 CLIPPED
                  CALL cl_err(g_msg,-239,0)
                  NEXT FIELD fak01
               END IF
            END IF

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
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        DISPLAY BY NAME g_fak.fak01,g_fak.fak02 #
        RETURN
    END IF
    LET l_fak.* = g_fak.*
    LET l_fak.fak01  =l_newno1  #資料鍵值
    LET l_fak.fak02  =l_newno2
    LET l_fak.fakuser=g_user    #資料所有者
    LET l_fak.fakgrup=g_grup    #資料所有者所屬群
    LET l_fak.fakmodu=NULL      #資料修改日期
    LET l_fak.fakdate=g_today   #資料建立日期
    LET l_fak.fak91='N'
    IF l_fak.fak022 IS NULL THEN LET l_fak.fak022 = ' ' END IF
    LET l_fak.fakoriu = g_user      #No.FUN-980030 10/01/04
    LET l_fak.fakorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO fak_file VALUES (l_fak.*)
        LET g_msg = l_newno1,l_newno2 CLIPPED
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","fak_file",l_fak.fak01,l_fak.fak02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
    ELSE
        MESSAGE 'ROW(',g_msg,') O.K'
        LET l_oldno1 = g_fak.fak01
        LET l_oldno2 = g_fak.fak02
        LET g_fak.fak01 = l_newno1
        LET g_fak.fak02 = l_newno2
  SELECT fak_file.* INTO g_fak.* FROM fak_file
                       WHERE fak01 = l_newno1
                         AND fak02 = l_newno2
        CALL i101_u()
  #FUN-C30027---begin
  #SELECT fak_file.* INTO g_fak.* FROM fak_file
  #                     WHERE fak01 = l_oldno1
  #                       AND fak02 = l_lodno2
  #FUN-C30027---end
    END IF
    #-------- 更新系統參數檔之已用編號 ----------
    UPDATE faa_file SET faa191 = l_newno1
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]= 0 THEN
        CALL cl_err3("upd","faa_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660136
     END IF
    CALL i101_show()
END FUNCTION
 
FUNCTION i101_g()
  DEFINE l_yy,l_mm   LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_fbz15     LIKE fbz_file.fbz15
  DEFINE l_fcx05     LIKE fcx_file.fcx05
#TQC-C20320--ADD--STR
  IF cl_null(g_fak.fak25) THEN
     CALL cl_err('','afa-518',0) RETURN 
  END IF 
#TQC-C20320--ADD--END
   IF cl_null(g_fak.fak02)  THEN               #CHI-BB0005 add
      CALL cl_err('','afa-036',0) RETURN       #CHI-BB0005 add
   END IF                                      #CHI-BB0005 add
 
    LET l_yy=YEAR(g_fak.fak25)
    LET l_mm=MONTH(g_fak.fak25)
 
   IF g_fak.fak91 = 'Y' THEN RETURN END IF
   IF g_fak.fak92 = 'N' OR cl_null(g_fak.fak92) THEN RETURN END IF
 
   IF NOT cl_confirm('afa-905') THEN RETURN END IF
 
   SELECT * INTO g_fak.* FROM fak_file WHERE fak02 = g_fak.fak02
                                         AND fak022= g_fak.fak022
 
   SELECT COUNT(*) INTO g_cnt FROM fcx_file
    WHERE fcx01=g_fak.fak02
      AND fcx011=g_fak.fak022
      AND fcx02=l_yy
      AND fcx03=l_mm
   IF g_cnt > 0 THEN CALL cl_err('','afa-904',0) RETURN END IF
 
   BEGIN WORK
   LET g_success = 'Y'
   CALL i101_ins_fcx()
 
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CALL cl_end(0,0)
 
 
END FUNCTION
 
FUNCTION i101_ins_fcx()
  DEFINE l_yy,l_mm   LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_fbz15     LIKE fbz_file.fbz15
  DEFINE l_fbz151    LIKE fbz_file.fbz151     #No.FUN-680028
  DEFINE p_type      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET l_yy=YEAR(g_fak.fak25)
    LET l_mm=MONTH(g_fak.fak25)
    SELECT fbz15,fbz151 INTO l_fbz15,l_fbz151 FROM fbz_file WHERE fbz00='0'     #No.FUN-680028
    IF STATUS THEN 
       LET l_fbz15='' 
       LET l_fbz151=''      #No.FUN-680028
    END IF
 
     INSERT INTO fcx_file (fcx01,fcx011,fcx02,fcx03,fcx04,fcx05,fcx06,fcx07, #No.MOD-470041
                          fcx08,fcx09,fcx091,fcx10,fcx101,fcx11,fcx12,fcx13,fcxacti,     #No.FUN-680028
                          fcxuser,fcxgrup,fcxmodu,fcxdate,fcxlegal,fcxoriu,fcxorig) #FUN-980003 add fcxlegal
         VALUES(g_fak.fak02,g_fak.fak022,l_yy,l_mm,0,g_fak.fak14,0,0,0,
                g_fak.fak53,g_fak.fak531,l_fbz15,l_fbz151,'','',null,'Y',g_user,g_grup,g_user,g_today,g_legal, g_user, g_grup)     #No.FUN-680028 #FUN-980003 add g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("ins","fcx_file",g_fak.fak02,g_fak.fak022,SQLCA.sqlcode,"","",1)  #No.FUN-660136
       LET g_success='N' 
    END IF
END FUNCTION
 
FUNCTION i101_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fak01",TRUE)
   END IF
   IF INFIELD(fak43) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fak24,fak27,fak28,fak29,fak30,fak31,fak32,fak33",TRUE)
      CALL cl_set_comp_entry("fak242,fak272,fak282,fak292,fak302,fak312,fak322,fak332",TRUE)     #No:FUN-AB0088
   END IF
   IF INFIELD(fak34) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fak35,fak36",TRUE)
   END IF
   IF INFIELD(fak28) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fak29,fak30,fak31,fak32,fak203,fak33,fak34",TRUE)
   END IF
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
     CALL cl_set_comp_entry("fak02,fak022",TRUE)
   END IF

   #-----No:FUN-AB0088-----
   IF INFIELD(fak342) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fak352,fak362",TRUE)
   END IF
   IF INFIELD(fak282) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("fak292,fak302,fak312,fak322,fak332,fak342",TRUE)
   END IF
   #-----No:FUN-AB0088 END-----

END FUNCTION
 
FUNCTION i101_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)

   IF INFIELD(fak43) OR (NOT g_before_input_done) THEN
      IF g_fak.fak43 = '2' AND p_cmd = 'u' THEN
         CALL cl_set_comp_entry("fak24,fak27,fak28,fak29,fak30,fak31,fak32,fak33",FALSE)
         CALL cl_set_comp_entry("fak242,fak272,fak282,fak292,fak302,fak312,fak322,fak332",FALSE)   #No:FUN-AB0088
      END IF
   END IF
   IF INFIELD(fak34) OR (NOT g_before_input_done) THEN
      IF g_fak.fak34 != 'Y' THEN
         CALL cl_set_comp_entry("fak35,fak36",FALSE)
      END IF
   END IF
   IF INFIELD(fak28) OR (NOT g_before_input_done) THEN
      IF g_fak.fak28 ='0' THEN   #NO:5153
         CALL cl_set_comp_entry("fak29,fak30,fak31,fak32,fak203,fak33,fak34",FALSE)
      END IF
   END IF
   IF p_cmd = 'u' AND ( NOT g_before_input_done ) AND g_chkey='N' THEN
     CALL cl_set_comp_entry("fak01,fak02,fak022",FALSE)
   END IF

   #-----No:FUN-AB0088-----
   IF INFIELD(fak342) OR (NOT g_before_input_done) THEN
      IF g_fak.fak342 != 'Y' THEN
         CALL cl_set_comp_entry("fak352,fak362",FALSE)
      END IF
   END IF
   IF INFIELD(fak282) OR (NOT g_before_input_done) THEN
      IF g_fak.fak282 ='0' THEN
         CALL cl_set_comp_entry("fak292,fak302,fak312,fak322,fak332,fak342",FALSE)
      END IF
   END IF
   #-----No:FUN-AB0088 END-----
END FUNCTION
 
FUNCTION i101_fak53(p_char,p_bookno1)   #No.FUN-740026
DEFINE
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag03    LIKE aag_file.aag03,
      l_aag07    LIKE aag_file.aag07,
      p_char     LIKE fak_file.fak53,
      p_bookno1  LIKE aag_file.aag00,   #No.FUN-740026
      p_cmd      LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    LET g_errno = " "
    #SELECT aag02,aagacti INTO l_aag02,l_aagacti                             #No.FUN-B10053
    SELECT aag02,aag07,aag03,aagacti INTO l_aag02,l_aag07,l_aag03,l_aagacti  #No.FUN-B10053
      FROM aag_file
     WHERE aag01=p_char
       AND aag00=p_bookno1    #No.FUN-740026
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aag07  = '1'      LET g_errno = 'agl-015'    #No.FUN-B10053
         WHEN l_aag03 != '2'      LET g_errno = 'agl-201'    #No.FUN-B10053
         WHEN l_aagacti='N'       LET g_errno = '9028'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    RETURN(l_aag02)
END FUNCTION
 
FUNCTION i101_set_comb()
  DEFINE comb_value STRING
  DEFINE comb_item  STRING
 
    LET comb_value = '0,1,2,3,4,5'
    CALL cl_getmsg('afa-392',g_lang) RETURNING comb_item
 
    CALL cl_set_combo_items('fak28',comb_value,comb_item)
    CALL cl_set_combo_items('fak282',comb_value,comb_item)   #No:FUN-AB0088
    CALL cl_set_combo_items('fak61',comb_value,comb_item)
END FUNCTION
 
FUNCTION i101_set_comments()
  DEFINE comm_value STRING
 
    CALL cl_getmsg('afa-391',g_lang) RETURNING comm_value
    CALL cl_set_comments('fak28',comm_value)
    CALL cl_set_comments('fak282',comm_value)   #No:FUN-AB0088
    CALL cl_set_comments('fak61',comm_value)
END FUNCTION
#No.FUN-9C0077 程式精簡 


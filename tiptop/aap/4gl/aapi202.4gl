# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aapi202.4gl
# Descriptions...: 應付帳款系統-部門預設科目維護作業
# Date & Author..: 92/12/22 By Yen
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: NO.FUN-5C0033 06/02/07 by Yiting 游標移動時, 可自動在訊息列, 自動顯示該科目之科目名稱
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660192 06/07/04 By Smapmin 新增aps57,aps58二個欄位
# Modify.........: No.FUN-680029 06/08/15 By Rayven 兩套帳修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0016 06/11/11 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.MOD-690082 06/09/12 By Smapmin aps40,aps44,aps45,aps46輸入後沒CHECK科目是否正確
# Modify.........: No.MOD-6C0002 06/12/1 By dxfwo  更改錯誤訊息
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730064 07/03/29 By sherry 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770051 07/05/22 By Rayven 報表FROM:XXX,頁次格式有誤
# Modify.........: No.FUN-770012 07/07/26 By johnray 修改報表功能，使用CR打印報表
# Modify.........: No.TQC-940053 09/04/22 By Cockroach 當資料有效碼（apsacti)='N'時，不可刪除資料 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9A0192 09/10/29 By Sarah l_table請定義為STRING
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A50192 10/05/28 by Dido BEFIELD FIELD 前增加錯誤顯示 
# Modify.........: No.FUN-A80111 10/08/31 by wujie 增加溢退科目
# Modify.........: No:FUN-B20059 11/02/24 By wujie  科目自动开窗hard code修改
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting
# Modify.........: No:FUN-B40004 11/04/13 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No:TQC-B50041 11/05/10 By yinhy 狀態頁簽的“資料建立者”和“資料建立部門”無法下查詢條件查詢資料。
# Modify.........: No.FUN-B50062 11/05/13 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.MOD-BC0149 11/12/19 By Polly 增加條件當apz13為'Y'，才需要做部門允許或拒絕部門檢查
# Modify.........: No.FUN-BB0047 11/12/31 By fengrui  調整時間函數問題
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C30027 12/08/09 By bart 複製後停在新料號畫面
# Modify........: No.FUN-CB0056 13/02/21 By minpp 增加aps02（暂估税种），aps03（预付税种）
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_aps   RECORD LIKE aps_file.*,
    g_aps_t RECORD LIKE aps_file.*,
    g_aps_o RECORD LIKE aps_file.*,
    g_before_input_done LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    g_aps01_t LIKE aps_file.aps01,
   #g_wc,g_sql          LIKE type_file.chr1000           #No.FUN-690028 VARCHAR(300)
    g_wc,g_sql          STRING             #TQC-630166
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
#No.FUN-770012 -- begin --
DEFINE g_sql1     STRING
DEFINE l_table    STRING   #MOD-9A0192 mod chr20->STRING
DEFINE g_str      STRING
#No.FUN-770012 -- end --
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8              #No.FUN-6A0055
   DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF
 
   # CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055 #FUN-BB0047
    INITIALIZE g_aps.* TO NULL
    INITIALIZE g_aps_t.* TO NULL
    INITIALIZE g_aps_o.* TO NULL
#No.FUN-770012 -- begin --
    LET g_sql1 = "aps01.aps_file.aps01,gem02.gem_file.gem02,",
                 "aps02.aps_file.aps02,aps03.aps_file.aps03,",   #FUN-CB0056
                 "aps11.aps_file.aps11,aps12.aps_file.aps12,",
                 "aps13.aps_file.aps13,aps14.aps_file.aps14,",
                 "aps40.aps_file.aps40,aps41.aps_file.aps41,",
                 "aps42.aps_file.aps42,aps43.aps_file.aps43,",
                 "aps44.aps_file.aps44,aps45.aps_file.aps45,",
                 "aps46.aps_file.aps46,aps57.aps_file.aps57,",
                 "aps21.aps_file.aps21,aps22.aps_file.aps22,",
                 "aps23.aps_file.aps23,aps231.aps_file.aps231,",
                 "aps232.aps_file.aps232,aps233.aps_file.aps233,",
                 "aps234.aps_file.aps234,aps24.aps_file.aps24,",
                 "aps25.aps_file.aps25,aps56.aps_file.aps56,",
                 "aps47.aps_file.aps47,aps58.aps_file.aps58,",
                 "aps111.aps_file.aps111,aps121.aps_file.aps121,",
                 "aps131.aps_file.aps131,aps141.aps_file.aps141,",
                 "aps401.aps_file.aps401,aps411.aps_file.aps411,",
                 "aps421.aps_file.aps421,aps431.aps_file.aps431,",
                 "aps441.aps_file.aps441,aps451.aps_file.aps451,",
                 "aps461.aps_file.aps461,aps571.aps_file.aps571,",
                 "aps211.aps_file.aps211,aps221.aps_file.aps221,",
                 "aps235.aps_file.aps235,aps236.aps_file.aps236,",
                 "aps237.aps_file.aps237,aps238.aps_file.aps238,",
                 "aps239.aps_file.aps239,aps241.aps_file.aps241,",
                 "aps251.aps_file.aps251,aps561.aps_file.aps561,",
                 "aps471.aps_file.aps471,aps581.aps_file.aps581,",
                 "aag02_11.aag_file.aag02,aag02_12.aag_file.aag02,",
                 "aag02_13.aag_file.aag02,aag02_14.aag_file.aag02,",
                 "aag02_40.aag_file.aag02,aag02_41.aag_file.aag02,",
                 "aag02_42.aag_file.aag02,aag02_43.aag_file.aag02,",
                 "aag02_44.aag_file.aag02,aag02_45.aag_file.aag02,",
                 "aag02_46.aag_file.aag02,aag02_57.aag_file.aag02,",
                 "aag02_21.aag_file.aag02,aag02_22.aag_file.aag02,",
                 "aag02_23.aag_file.aag02,aag02_231.aag_file.aag02,",
                 "aag02_232.aag_file.aag02,aag02_233.aag_file.aag02,",
                 "aag02_234.aag_file.aag02,aag02_24.aag_file.aag02,",
                 "aag02_25.aag_file.aag02,aag02_56.aag_file.aag02,",
                 "aag02_47.aag_file.aag02,aag02_58.aag_file.aag02,",
                 "aag02_111.aag_file.aag02,aag02_121.aag_file.aag02,",
                 "aag02_131.aag_file.aag02,aag02_141.aag_file.aag02,",
                 "aag02_401.aag_file.aag02,aag02_411.aag_file.aag02,",
                 "aag02_421.aag_file.aag02,aag02_431.aag_file.aag02,",
                 "aag02_441.aag_file.aag02,aag02_451.aag_file.aag02,",
                 "aag02_461.aag_file.aag02,aag02_571.aag_file.aag02,",
                 "aag02_211.aag_file.aag02,aag02_221.aag_file.aag02,",
                 "aag02_235.aag_file.aag02,aag02_236.aag_file.aag02,",
                 "aag02_237.aag_file.aag02,aag02_238.aag_file.aag02,",
                 "aag02_239.aag_file.aag02,aag02_241.aag_file.aag02,",
                 "aag02_251.aag_file.aag02,aag02_561.aag_file.aag02,",
                 "aag02_471.aag_file.aag02,aag02_581.aag_file.aag02,",
                 "apsacti.aps_file.apsacti"
    LET l_table = cl_prt_temptable('aapi202',g_sql1) CLIPPED
    IF l_table = -1 THEN 
       EXIT PROGRAM 
    END IF
#No.FUN-770012 -- end --
    CALL cl_used(g_prog,g_time,1) RETURNING g_time  #FUN-BB0047 add
    LET g_forupd_sql = " SELECT * FROM aps_file WHERE aps01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i202_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    LET p_row = 3 LET p_col = 16
 
    OPEN WINDOW i202_w AT p_row,p_col WITH FORM "aap/42f/aapi202"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    #No.FUN-680029 --start--
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("page02",FALSE)
    END IF
    #No.FUN-680029 --end--

    #FUN-CB0056---add----str
    IF g_aza.aza26<>'2' THEN
       CALL cl_set_comp_visible("Page1",FALSE)
    ELSE
       CALL cl_set_comp_visible("Page1",TRUE)
    END IF
    #FUN-CB0056---add--end
 
    IF g_apz.apz13 = 'N' THEN
       CALL cl_err('','aap-135',0)
    END IF
 
#   WHILE TRUE
      LET g_action_choice=""
      CALL i202_menu()
#     IF g_action_choice="exit" THEN EXIT WHILE END IF
#   END WHILE
 
    CLOSE WINDOW i202_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0055
END MAIN
 
FUNCTION i202_cs()
   DEFINE  l_aps02_wc   LIKE type_file.chr1000          #FUN-CB0056
   DEFINE  l_aps03_wc   LIKE type_file.chr1000          #FUN-CB0056

    CLEAR FORM
   INITIALIZE g_aps.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
        aps01,aps11,aps12,aps13,aps14,
        #aps40,aps41,aps42,aps43,aps44,aps45,aps46,   #FUN-660192
        #aps21,aps22,aps23,aps231,aps232,aps233,aps234,aps24,aps25,aps56,aps47,   #FUN-660192
#       aps40,aps41,aps42,aps43,aps44,aps45,aps46,aps57,   #FUN-660192
        aps40,aps41,aps42,aps43,aps44,aps45,aps46,aps57,aps61,   #FUN-660192   #No.FUN-A80111
        aps21,aps22,aps23,aps231,aps232,aps233,aps234,aps24,aps25,aps56,aps47,aps58,   #FUN-660192  
        #No.FUN-680029 --start--
        aps111,aps121,aps131,aps141,aps401,aps411,aps421,aps431,aps441,aps451,
#       aps461,aps571,aps211,aps221,aps235,aps236,aps237,aps238,aps239,aps241,
        aps461,aps571,aps611,aps211,aps221,aps235,aps236,aps237,aps238,aps239,aps241,   #No.FUN-A80111
        aps251,aps561,aps471,aps581,aps02,aps03,                                        #FUN-CB0056 add--aps02,aps03
        #No.FUN-680029 --end--
        apsuser,apsgrup,apsmodu,apsdate,apsacti,
        apsoriu,apsorig                              #No.TQC-B50041
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 

    #FUN-CB0056----add---str
    AFTER FIELD aps02,aps03
       CALL GET_FLDBUF(aps02) RETURNING l_aps02_wc
       LET l_aps02_wc = cl_replace_str(l_aps02_wc,"|","','")
       LET l_aps02_wc = "'",l_aps02_wc CLIPPED,"'"

       CALL GET_FLDBUF(aps03) RETURNING l_aps03_wc
       LET l_aps03_wc = cl_replace_str(l_aps03_wc,"|","','")
       LET l_aps03_wc = "'",l_aps03_wc CLIPPED,"'"
    #FUN-CB0056---add---end 
    ON ACTION controlp
       CASE
          WHEN INFIELD(aps01) #部門編號
#            CALL q_gem(10,3,g_aps.aps01) RETURNING g_aps.aps01
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             LET g_qryparam.form ="q_gem"
             LET g_qryparam.default1 = g_aps.aps01
             #CALL cl_create_qry() RETURNING g_aps.aps01
             #DISPLAY BY NAME g_aps.aps01
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps01
             CALL i202_aps01('d',g_aps.aps01)
             NEXT FIELD aps01
          WHEN INFIELD(aps11) #現金科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps11)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps11,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps11
             NEXT FIELD aps11
          WHEN INFIELD(aps12) #預付帳款科目
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps12,g_aza.aza81)    #No.FUN-730064
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps12)    #No:8727
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps12
             NEXT FIELD aps12
          WHEN INFIELD(aps13) #暫付帳款科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps13)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps13,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps13
             NEXT FIELD aps13
          WHEN INFIELD(aps14) #預付購料款
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps14)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps14,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps14
             NEXT FIELD aps14
          WHEN INFIELD(aps21) #未開發票應付
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps21)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps21,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps21
             NEXT FIELD aps21
          WHEN INFIELD(aps22) #應付帳款科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps22)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps22,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps22
             NEXT FIELD aps22
          WHEN INFIELD(aps23) #應付費用科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps23)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps23,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps23
             NEXT FIELD aps23
          WHEN INFIELD(aps231) #應付保險費
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps231)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps231,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps231
             NEXT FIELD aps231
          WHEN INFIELD(aps232) #應付報關雜費
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps232)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps232,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps232
             NEXT FIELD aps232
          WHEN INFIELD(aps233) #應付關稅科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps233)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps233,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps233
             NEXT FIELD aps233
          WHEN INFIELD(aps234) #應付運費科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps234)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps234,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps234
             NEXT FIELD aps234
          WHEN INFIELD(aps24) #應付票據科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps24)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps24,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps24
             NEXT FIELD aps24
          WHEN INFIELD(aps25) #短期借款科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps25)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps25,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps25
             NEXT FIELD aps25
          WHEN INFIELD(aps56) #代付匯票科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps56)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps56,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps56
             NEXT FIELD aps56
          WHEN INFIELD(aps47) #
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps47)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps47,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps47
             NEXT FIELD aps47
 
          #-----FUN-660192---------
          WHEN INFIELD(aps58)
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps58)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps58,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps58
             NEXT FIELD aps58
          #-----END FUN-660192-----
          WHEN INFIELD(aps40) #進貨折讓科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps40)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps40,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps40
             NEXT FIELD aps40
          WHEN INFIELD(aps41) #進貨折讓科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps41)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps41,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps41
             NEXT FIELD aps41
          WHEN INFIELD(aps42) #匯兌損失科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps42)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps42,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps42
             NEXT FIELD aps42
          WHEN INFIELD(aps43) #匯兌收益科目
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps43)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps43,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps43
             NEXT FIELD aps43
          WHEN INFIELD(aps44) #difference
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps44)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps44,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps44
             NEXT FIELD aps44
          WHEN INFIELD(aps45) #difference
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps45)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps45,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps45
             NEXT FIELD aps45
          WHEN INFIELD(aps46)
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps46)    #No:8727
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps46,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps46
             NEXT FIELD aps46
 
          #-----FUN-660192---------
          WHEN INFIELD(aps57)
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps57)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps57,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps57
             NEXT FIELD aps57
          #-----END FUN-660192-----
#No.FUN-A80111 --begin 
          WHEN INFIELD(aps61)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps61,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps61
             NEXT FIELD aps61
          WHEN INFIELD(aps611)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps611,g_aza.aza81)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps611
             NEXT FIELD aps611
#No.FUN-A80111 --begin 
          #No.FUN-680029 --start--
          WHEN INFIELD(aps111) #現金科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps111)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps111,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps111
             NEXT FIELD aps111
          WHEN INFIELD(aps121) #預付帳款科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps121)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps121,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps121
             NEXT FIELD aps121
          WHEN INFIELD(aps131) #暫付帳款科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps131)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps131,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps131
             NEXT FIELD aps131
          WHEN INFIELD(aps141) #預付購料款二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps141)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps141,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps141
             NEXT FIELD aps141
          WHEN INFIELD(aps211) #未開發票應付二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps211)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps211,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps211
             NEXT FIELD aps211
          WHEN INFIELD(aps221) #應付帳款科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps221)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps221,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps221
             NEXT FIELD aps221
          WHEN INFIELD(aps235) #應付費用科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps235)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps235,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps235
             NEXT FIELD aps235
          WHEN INFIELD(aps236) #應付保險費二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps236)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps236,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps236
             NEXT FIELD aps236
          WHEN INFIELD(aps237) #應付報關雜費二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps237)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps237,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps237
             NEXT FIELD aps237
          WHEN INFIELD(aps238) #應付關稅科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps238)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps238,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps238
             NEXT FIELD aps238
          WHEN INFIELD(aps239) #應付運費科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps239)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps239,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps239
             NEXT FIELD aps239
          WHEN INFIELD(aps241) #應付票據科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps241)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps241,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps241
             NEXT FIELD aps241
          WHEN INFIELD(aps251) #短期借款科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps251)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps251,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps251
             NEXT FIELD aps251
          WHEN INFIELD(aps561) #代付匯票科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps561)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps561,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps561
             NEXT FIELD aps561
          WHEN INFIELD(aps471)
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps471)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps471,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps471
             NEXT FIELD aps471
          WHEN INFIELD(aps581)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps581,g_aza.aza82)    #No.FUN-730064
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps581)
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps581
             NEXT FIELD aps581
          WHEN INFIELD(aps401) #進貨折讓科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps401)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps401,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps401
             NEXT FIELD aps401
          WHEN INFIELD(aps411) #進貨折讓科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps411)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps411,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps411
             NEXT FIELD aps411
          WHEN INFIELD(aps421) #匯兌損失科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps421)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps421,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps421
             NEXT FIELD aps421
          WHEN INFIELD(aps431) #匯兌收益科目二
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps431)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps431,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps431
             NEXT FIELD aps431
          WHEN INFIELD(aps441)
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps441)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps441,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps441
             NEXT FIELD aps441
          WHEN INFIELD(aps451)
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps451)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps451,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps451
             NEXT FIELD aps451
          WHEN INFIELD(aps461)
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps461)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps461,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps461
             NEXT FIELD aps461
          WHEN INFIELD(aps571)
#            CALL q_aapact(TRUE,TRUE,'2',g_aps.aps571)
             CALL q_aapact(TRUE,TRUE,'2',g_aps.aps571,g_aza.aza82)    #No.FUN-730064
                  RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps571
             NEXT FIELD aps571
          #No.FUN-680029 --end--

          #FUN-CB0056---add---str
          WHEN INFIELD(aps02) #暂估税种
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             IF g_aza.aza26 = '2' THEN
                LET g_qryparam.form ="q_gec8_1"
             ELSE
                LET g_qryparam.form ="q_gec8"
             END IF
             LET g_qryparam.arg1 = '1'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps02
          WHEN INFIELD(aps03) # 预付税种
             CALL cl_init_qry_var()
             LET g_qryparam.state = "c"
             IF g_aza.aza26 = '2' THEN
                LET g_qryparam.form ="q_gec8_1"
             ELSE
                LET g_qryparam.form ="q_gec8"
             END IF
             LET g_qryparam.arg1 = '1'
             CALL cl_create_qry() RETURNING g_qryparam.multiret
             DISPLAY g_qryparam.multiret TO aps03
          #FUN-CB0056---add--end
 
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
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
     END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND apsuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND apsgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND apsgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('apsuser', 'apsgrup')
    #End:FUN-980030
 
    LET g_sql="SELECT aps01 FROM aps_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED
         IF g_apz.apz13 = 'N'
            THEN LET g_sql= g_sql CLIPPED," AND aps01 = ' '"
            ELSE LET g_sql= g_sql CLIPPED," AND aps01 != ' '"
         END IF
        LET g_sql= g_sql CLIPPED," ORDER BY aps01"
    PREPARE i202_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE i202_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i202_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM aps_file WHERE ",g_wc CLIPPED
         IF g_apz.apz13 = 'N'
            THEN LET g_sql= g_sql CLIPPED," AND aps01 = ' '"
            ELSE LET g_sql= g_sql CLIPPED," AND aps01 != ' '"
         END IF
    PREPARE i202_precount FROM g_sql
    DECLARE i202_count CURSOR FOR i202_precount
END FUNCTION
 
FUNCTION i202_menu()
    MENU ""
 
        BEFORE MENU
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
            LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL i202_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL i202_q()
            END IF
        ON ACTION next
            CALL i202_fetch('N')
        ON ACTION previous
            CALL i202_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL i202_u()
            END IF
        ON ACTION invalid
            LET g_action_choice="invalid"
            IF cl_chk_act_auth() THEN
                 CALL i202_x()
                 CALL cl_set_field_pic("","","","","",g_aps.apsacti)
            END IF
        ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL i202_r()
            END IF
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
               CALL i202_copy()
           END IF
        ON ACTION output
           LET g_action_choice="output"
           IF cl_chk_act_auth()
               THEN CALL i202_out()
           END IF
        ON ACTION help
           CALL cl_show_help()
        ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           CALL cl_set_field_pic("","","","","",g_aps.apsacti)
        ON ACTION exit
           LET g_action_choice = "exit"
           EXIT MENU
        ON ACTION jump
           CALL i202_fetch('/')
        ON ACTION first
           CALL i202_fetch('F')
        ON ACTION last
           CALL i202_fetch('L')
        ON ACTION CONTROLG
           CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        #No.FUN-6A0016--------add----------str----
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_aps.aps01 IS NOT NULL THEN
                  LET g_doc.column1 = "aps01"
                  LET g_doc.value1 = g_aps.aps01
                  CALL cl_doc()
               END IF
           END IF
        #No.FUN-6A0016--------add----------end----
            LET g_action_choice = "exit"
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
    END MENU
    CLOSE i202_cs
END FUNCTION
 
 
FUNCTION i202_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    # 是否依部門區分預設會計科目" 設為 'N'
    IF g_apz.apz13 = 'N' THEN
         SELECT count(*) INTO g_cnt FROM aps_file
             WHERE (aps01 = ' ' OR aps01 IS NULL)
         IF g_cnt > 0 THEN                  # Duplicated
            CALL cl_err(g_aps.aps01,'aap-248',1) #No..MOD-6C0002
             LET g_aps.aps01 = g_aps01_t
             DISPLAY BY NAME g_aps.aps01
             RETURN
         END IF
    END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    INITIALIZE g_aps.* LIKE aps_file.*
    LET g_aps_t.* = g_aps.*
    LET g_aps01_t = NULL
#%  LET g_aps.xxxx = 0				# DEFAULT
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_aps.apsacti ='Y'                   #有效的資料
        LET g_aps.apsuser = g_user
        LET g_aps.apsoriu = g_user #FUN-980030
        LET g_aps.apsorig = g_grup #FUN-980030
        LET g_aps.apsgrup = g_grup               #使用者所屬群
        LET g_aps.apsdate = g_today
        CALL i202_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_aps.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        IF g_apz.apz13 = 'N' THEN
           LET g_aps.aps01 = ' '
        ELSE
           IF cl_null(g_aps.aps01) THEN             # KEY 不可空白
               CONTINUE WHILE
           END IF
        END IF
        INSERT INTO aps_file VALUES(g_aps.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("ins","aps_file",g_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        ELSE
            LET g_aps_t.* = g_aps.*                # 保存上筆資料
            SELECT aps01 INTO g_aps.aps01 FROM aps_file
                WHERE aps01 = g_aps.aps01
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i202_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
        l_aag02         LIKE aag_file.aag02,   #No:8147
        l_dir           LIKE type_file.chr1,   # No.FUN-690028 VARCHAR(1),               #判斷是否
        l_n             LIKE type_file.num5,   #No.FUN-690028 SMALLINT
        l_cnt           LIKE type_file.num5    #FUN-CB0056
    DEFINE  l_aag05     LIKE aag_file.aag05    #No.FUN-B40004
    INPUT BY NAME g_aps.apsoriu,g_aps.apsorig,
        g_aps.aps01,g_aps.aps11,g_aps.aps12, g_aps.aps13,g_aps.aps14,
        g_aps.aps40,g_aps.aps41,g_aps.aps42, g_aps.aps43,
        #g_aps.aps44,g_aps.aps45,g_aps.aps46,   #FUN-660192
        g_aps.aps44,g_aps.aps45,g_aps.aps46,g_aps.aps57,g_aps.aps61,   #FUN-660192  #No.FUN-A80111 add aps61
        g_aps.aps21,g_aps.aps22, g_aps.aps23,
        g_aps.aps231,g_aps.aps232,g_aps.aps233,g_aps.aps234,
        #g_aps.aps24,g_aps.aps25,g_aps.aps56,g_aps.aps47,   #FUN-660192
        g_aps.aps24,g_aps.aps25,g_aps.aps56,g_aps.aps47,g_aps.aps58,        #FUN-660192 
        #No.FUN-680029 --start--
        g_aps.aps111,g_aps.aps121,g_aps.aps131,g_aps.aps141,g_aps.aps401,
        g_aps.aps411,g_aps.aps421,g_aps.aps431,g_aps.aps441,g_aps.aps451,
        g_aps.aps461,g_aps.aps571,g_aps.aps611,g_aps.aps211,g_aps.aps221,g_aps.aps235,  #No.FUN-A80111 add aps611
        g_aps.aps236,g_aps.aps237,g_aps.aps238,g_aps.aps239,g_aps.aps241,
        g_aps.aps251,g_aps.aps561,g_aps.aps471,g_aps.aps581,
        #No.FUN-680029 --end--
        g_aps.aps02,g_aps.aps03,                              #FUN-CB0056
        g_aps.apsuser,g_aps.apsgrup,g_aps.apsmodu,g_aps.apsdate,g_aps.apsacti
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i202_set_entry(p_cmd)
         CALL i202_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
 
 
        AFTER FIELD aps01            #部門編號
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND g_aps.aps01 != g_aps01_t) THEN
                SELECT count(*) INTO l_n FROM aps_file
                    WHERE aps01 = g_aps.aps01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_aps.aps01,-239,0)
                    LET g_aps.aps01 = g_aps01_t
                    DISPLAY BY NAME g_aps.aps01
                    NEXT FIELD aps01
                END IF
                IF NOT cl_null(g_aps.aps01) THEN
                   CALL i202_aps01('a',g_aps.aps01)
                   IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps01,g_errno,0)
                       LET g_aps.aps01 = g_aps_o.aps01
                       DISPLAY BY NAME g_aps.aps01
                       CALL i202_aps01('a',g_aps.aps01)
                       NEXT FIELD aps01
                   END IF
                END IF
            END IF
            LET g_aps_o.aps01 = g_aps.aps01
     #FUN-CB0056---add---str
      AFTER FIELD aps02            #暂估税种
         IF NOT cl_null(g_aps.aps02) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_aps.aps02 != g_aps_t.aps02 OR cl_null(g_aps_t.aps02))) THEN
               LET l_cnt=0
               SELECT count(*) INTO l_cnt FROM gec_file WHERE gec01=g_aps.aps02
               IF l_cnt<1 THEN
                  CALL cl_err('','mfg3044',0)
                  NEXT FIELD aps02
               END IF
            END IF
         END IF
         LET g_aps_o.aps02 = g_aps.aps02

       AFTER FIELD aps03            #预付税种
         IF NOT cl_null(g_aps.aps03) THEN
            IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_aps.aps03 != g_aps_t.aps03 OR cl_null(g_aps_t.aps03))) THEN
               LET l_cnt=0
               SELECT count(*) INTO l_cnt FROM gec_file WHERE gec01=g_aps.aps03
               IF l_cnt<1 THEN
                  CALL cl_err('','mfg3044',0)
                  NEXT FIELD aps03
               END IF
            END IF
         END IF
         LET g_aps_o.aps03 = g_aps.aps03
      #FUN-CB0056---add--end   
#--FUN-5C0033 start--
        BEFORE FIELD aps11
          MESSAGE ''
          IF NOT cl_null(g_aps.aps11) THEN
#            CALL s_aapact('2',g_aps.aps11) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps11) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps11		#現金科目
            IF NOT cl_null(g_aps.aps11) THEN
              #IF cl_null(g_aps_o.aps11) OR (g_aps.aps11 != g_aps_o.aps11)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps11) RETURNING l_aag02    #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps11) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps11,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps11 = g_aps_o.aps11
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps11,g_aza.aza81)   #No.FUN-730064
                             RETURNING g_aps.aps11
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps11
                        NEXT FIELD aps11
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps11
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps11,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps11,g_errno,0)
                       DISPLAY BY NAME g_aps.aps11
                       NEXT FIELD aps11
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps11 = g_aps.aps11
 
#--FUN-5C0033 start--
        BEFORE FIELD aps12
          MESSAGE ''
          IF NOT cl_null(g_aps.aps12) THEN
#            CALL s_aapact('2',g_aps.aps12) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps12) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps12		#預付帳款科目
            IF NOT cl_null(g_aps.aps12) THEN
              #IF cl_null(g_aps_o.aps12) OR (g_aps.aps12 != g_aps_o.aps12)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps12) RETURNING l_aag02  #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps12) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps12,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps12 = g_aps_o.aps12
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps12,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps12
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps12
                        NEXT FIELD aps12
                    END IF
              #END IF     
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps12
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps12,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps12,g_errno,0)
                       DISPLAY BY NAME g_aps.aps12
                       NEXT FIELD aps12
                    END IF
                    #No.FUN-B40004  --End                                                    #MOD-A50192 mark
            END IF
            LET g_aps_o.aps12 = g_aps.aps12
 
#--FUN-5C0033 start--
        BEFORE FIELD aps13
          MESSAGE ''
          IF NOT cl_null(g_aps.aps13) THEN
#            CALL s_aapact('2',g_aps.aps13) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps13) RETURNING l_aag02   #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps13		#暫付帳款科目
            IF NOT cl_null(g_aps.aps13) THEN
              #IF cl_null(g_aps_o.aps13) OR (g_aps.aps13 != g_aps_o.aps13)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps13) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps13) RETURNING l_aag02   #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps13,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps13 = g_aps_o.aps13
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps13,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps13
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps13
                        NEXT FIELD aps13
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps13
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps13,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps13,g_errno,0)
                       DISPLAY BY NAME g_aps.aps13
                       NEXT FIELD aps13
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps13 = g_aps.aps13
 
#--FUN-5C0033 start--
        BEFORE FIELD aps14
          MESSAGE ''
          IF NOT cl_null(g_aps.aps14) THEN
#            CALL s_aapact('2',g_aps.aps14) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps14) RETURNING l_aag02   #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps14		#預付購料款
            IF NOT cl_null(g_aps.aps14) THEN
              #IF cl_null(g_aps_o.aps14) OR (g_aps.aps14 != g_aps_o.aps14)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps14) RETURNING l_aag02    #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps14) RETURNING l_aag02   #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps14,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps14 = g_aps_o.aps14
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps14,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps14
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps14
                        NEXT FIELD aps14
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps14
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps14,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps14,g_errno,0)
                       DISPLAY BY NAME g_aps.aps14
                       NEXT FIELD aps14
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps14 = g_aps.aps14
 
#--FUN-5C0033 start--
        BEFORE FIELD aps21
          MESSAGE ''
          IF NOT cl_null(g_aps.aps21) THEN
#            CALL s_aapact('2',g_aps.aps21) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps21) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps21		#未開發票應付
            IF NOT cl_null(g_aps.aps21) THEN
              #IF cl_null(g_aps_o.aps21) OR (g_aps.aps21 != g_aps_o.aps21)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps21) RETURNING l_aag02    #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps21) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps21,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps21 = g_aps_o.aps21
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps21,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps21
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps21
                        NEXT FIELD aps21
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps21
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps21,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps21,g_errno,0)
                       DISPLAY BY NAME g_aps.aps21
                       NEXT FIELD aps21
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps21 = g_aps.aps21
#--FUN-5C0033 start--
        BEFORE FIELD aps22
          MESSAGE ''
          IF NOT cl_null(g_aps.aps22) THEN
#            CALL s_aapact('2',g_aps.aps22) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps22) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps22		#應付帳款科目
            IF NOT cl_null(g_aps.aps22) THEN
              #IF cl_null(g_aps_o.aps22) OR (g_aps.aps22 != g_aps_o.aps22)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps22) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps22) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps22,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps22 = g_aps_o.aps22
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps22,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps22
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps22
                        NEXT FIELD aps22
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps22
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps22,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps22,g_errno,0)
                       DISPLAY BY NAME g_aps.aps22
                       NEXT FIELD aps22
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                         #MOD-A50192 mark
            END IF
            LET g_aps_o.aps22 = g_aps.aps22
 
#--FUN-5C0033 start--
        BEFORE FIELD aps23
          MESSAGE ''
          IF NOT cl_null(g_aps.aps23) THEN
#            CALL s_aapact('2',g_aps.aps23) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps23) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps23		#應付費用科目
            IF NOT cl_null(g_aps.aps23) THEN
              #IF cl_null(g_aps_o.aps23) OR (g_aps.aps23 != g_aps_o.aps23)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps23) RETURNING l_aag02  #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps23) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps23,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps23 = g_aps_o.aps23
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps23,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps23
#No.FUN-B20059 --end

                        DISPLAY BY NAME g_aps.aps23
                        NEXT FIELD aps23
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps23
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps23,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps23,g_errno,0)
                       DISPLAY BY NAME g_aps.aps23
                       NEXT FIELD aps23
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps23 = g_aps.aps23
 
#--FUN-5C0033 start--
        BEFORE FIELD aps231
          MESSAGE ''
          IF NOT cl_null(g_aps.aps231) THEN
#            CALL s_aapact('2',g_aps.aps231) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps231) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps231		#應付保險費
            IF NOT cl_null(g_aps.aps231) THEN
              #IF cl_null(g_aps_o.aps231) OR (g_aps.aps231 != g_aps_o.aps231)    #MOD-A50192 mark
              #   THEN                                                           #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps231) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps231) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps231,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps231 = g_aps_o.aps231
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps231,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps231
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps231
                        NEXT FIELD aps231
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps231
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps231,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps231,g_errno,0)
                       DISPLAY BY NAME g_aps.aps231
                       NEXT FIELD aps231
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                             #MOD-A50192 mark
            END IF
            LET g_aps_o.aps231 = g_aps.aps231
 
#--FUN-5C0033 start--
        BEFORE FIELD aps232
          MESSAGE ''
          IF NOT cl_null(g_aps.aps232) THEN
#            CALL s_aapact('2',g_aps.aps232) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps232) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps232		#應付報關雜費
            IF NOT cl_null(g_aps.aps232) THEN
              #IF cl_null(g_aps_o.aps232) OR (g_aps.aps232 != g_aps_o.aps232)   #MOD-A50192 mark
              #   THEN                                                          #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps232) RETURNING l_aag02  #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps232) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps232,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps232 = g_aps_o.aps232
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps232,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps232
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps232
                        NEXT FIELD aps232
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps232
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps232,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps232,g_errno,0)
                       DISPLAY BY NAME g_aps.aps232
                       NEXT FIELD aps232
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                           #MOD-A50192 mark
            END IF
            LET g_aps_o.aps232 = g_aps.aps232
 
#--FUN-5C0033 start--
        BEFORE FIELD aps233
          MESSAGE ''
          IF NOT cl_null(g_aps.aps233) THEN
#            CALL s_aapact('2',g_aps.aps233) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps233) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps233		#應付關稅科目
            IF NOT cl_null(g_aps.aps233) THEN
              #IF cl_null(g_aps_o.aps233) OR (g_aps.aps233 != g_aps_o.aps233)   #MOD-A50192 mark
              #   THEN                                                          #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps233) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps233) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps233,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps233 = g_aps_o.aps233
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps233,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps233
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps233
                        NEXT FIELD aps233
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps233
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps233,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps233,g_errno,0)
                       DISPLAY BY NAME g_aps.aps233
                       NEXT FIELD aps233
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                           #MOD-A50192 mark
            END IF
            LET g_aps_o.aps233 = g_aps.aps233
 
#--FUN-5C0033 start--
        BEFORE FIELD aps234
          MESSAGE ''
          IF NOT cl_null(g_aps.aps234) THEN
#            CALL s_aapact('2',g_aps.aps234) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps234) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps234		#應付運費科目
            IF NOT cl_null(g_aps.aps234) THEN
              #IF cl_null(g_aps_o.aps234) OR (g_aps.aps234 != g_aps_o.aps234)   #MOD-A50192 mark
              #   THEN                                                          #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps234) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps234) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps234,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps234 = g_aps_o.aps234
                         CALL q_aapact(FALSE,FALSE,'2',g_aps.aps234,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps234
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps234
                        NEXT FIELD aps234
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps234
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps234,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps234,g_errno,0)
                       DISPLAY BY NAME g_aps.aps234
                       NEXT FIELD aps234
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                           #MOD-A50192 mark
            END IF
            LET g_aps_o.aps234 = g_aps.aps234
 
#--FUN-5C0033 start--
        BEFORE FIELD aps24
          MESSAGE ''
          IF NOT cl_null(g_aps.aps24) THEN
#            CALL s_aapact('2',g_aps.aps24) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps24) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps24		#應付票據科目
            IF NOT cl_null(g_aps.aps24) THEN
              #IF cl_null(g_aps_o.aps24) OR (g_aps.aps24 != g_aps_o.aps24)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps24) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps24) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps24,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps24 = g_aps_o.aps24
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps24,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps24
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps24
                        NEXT FIELD aps24
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps24
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps24,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps24,g_errno,0)
                       DISPLAY BY NAME g_aps.aps24
                       NEXT FIELD aps24
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps24 = g_aps.aps24
 
#--FUN-5C0033 start--
        BEFORE FIELD aps25
          MESSAGE ''
          IF NOT cl_null(g_aps.aps25) THEN
#            CALL s_aapact('2',g_aps.aps25) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps25) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps25		#短期借款科目
            IF NOT cl_null(g_aps.aps25) THEN
              #IF cl_null(g_aps_o.aps25) OR (g_aps.aps25 != g_aps_o.aps25)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps25) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps25) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps25,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps25 = g_aps_o.aps25
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps25,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps25
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps25
                        NEXT FIELD aps25
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps25
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps25,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps25,g_errno,0)
                       DISPLAY BY NAME g_aps.aps25
                       NEXT FIELD aps25
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps25 = g_aps.aps25
 
#--FUN-5C0033 start--
        BEFORE FIELD aps56
          MESSAGE ''
          IF NOT cl_null(g_aps.aps56) THEN
#            CALL s_aapact('2',g_aps.aps56) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps56) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps56		#代付匯票科目
            IF NOT cl_null(g_aps.aps56) THEN
              #IF cl_null(g_aps_o.aps56) OR (g_aps.aps56 != g_aps_o.aps56)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps56) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps56) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps56,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps56 = g_aps_o.aps56
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps56,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps56
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps56
                        NEXT FIELD aps56
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps56
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps56,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps56,g_errno,0)
                       DISPLAY BY NAME g_aps.aps56
                       NEXT FIELD aps56
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps56 = g_aps.aps56
 
#--FUN-5C0033 start--
        BEFORE FIELD aps47
          MESSAGE ''
          IF NOT cl_null(g_aps.aps47) THEN
#            CALL s_aapact('2',g_aps.aps47) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps47) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps47		#郵資
            IF NOT cl_null(g_aps.aps47) THEN
              #IF cl_null(g_aps_o.aps47) OR (g_aps.aps47 != g_aps_o.aps47)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                    CALL s_aapact('2',g_aps.aps47) RETURNING l_aag02   #No:8147 #No.MOD-480289
                     CALL s_aapact('2',g_aza.aza81,g_aps.aps47) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps47,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps47 = g_aps_o.aps47
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps47,g_aza.aza81)   #No.FUN-730064
                               RETURNING g_aps.aps47
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps47
                        NEXT FIELD aps47
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps47
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps47,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps47,g_errno,0)
                       DISPLAY BY NAME g_aps.aps47
                       NEXT FIELD aps47
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps47 = g_aps.aps47
 
#--FUN-5C0033 start--
        BEFORE FIELD aps41
          MESSAGE ''
          IF NOT cl_null(g_aps.aps41) THEN
#            CALL s_aapact('2',g_aps.aps41) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps41) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps41		#進貨折讓科目
            IF NOT cl_null(g_aps.aps41) THEN
              #IF cl_null(g_aps_o.aps41) OR (g_aps.aps41 != g_aps_o.aps41)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps41) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps41) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps41,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps41 = g_aps_o.aps41
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps41,g_aza.aza81)   #No.FUN-730064
                             RETURNING g_aps.aps41
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps41
                        NEXT FIELD aps41
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps41
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps41,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps41,g_errno,0)
                       DISPLAY BY NAME g_aps.aps41
                       NEXT FIELD aps41
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps41 = g_aps.aps41
 
#--FUN-5C0033 start--
        BEFORE FIELD aps42
          MESSAGE ''
          IF NOT cl_null(g_aps.aps42) THEN
#            CALL s_aapact('2',g_aps.aps42) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps42) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps42		#匯兌損失科目
            IF NOT cl_null(g_aps.aps42) THEN
              #IF cl_null(g_aps_o.aps42) OR (g_aps.aps42 != g_aps_o.aps42)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps42) RETURNING l_aag02   #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps42) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps42,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps42 = g_aps_o.aps42
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps42,g_aza.aza81)   #No.FUN-730064
                             RETURNING g_aps.aps42
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps42
                        NEXT FIELD aps42
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps42
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps42,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps42,g_errno,0)
                       DISPLAY BY NAME g_aps.aps42
                       NEXT FIELD aps42
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps42 = g_aps.aps42
 
#--FUN-5C0033 start--
        BEFORE FIELD aps43
          MESSAGE ''
          IF NOT cl_null(g_aps.aps43) THEN
#            CALL s_aapact('2',g_aps.aps43) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza81,g_aps.aps43) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
#--FUN-5C0033 end----
 
        AFTER FIELD aps43		#匯兌收益科目
            IF NOT cl_null(g_aps.aps43) THEN
              #IF cl_null(g_aps_o.aps43) OR (g_aps.aps43 != g_aps_o.aps43)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps43) RETURNING l_aag02    #No:8147
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps43) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps43,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps43 = g_aps_o.aps43
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps43,g_aza.aza81)   #No.FUN-730064
                             RETURNING g_aps.aps43
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps43
                        NEXT FIELD aps43
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps43
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps43,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps43,g_errno,0)
                       DISPLAY BY NAME g_aps.aps43
                       NEXT FIELD aps43
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps43 = g_aps.aps43
 
        #-----MOD-690082---------
        AFTER FIELD aps40               #購貨退回科目
            IF NOT cl_null(g_aps.aps40) THEN
              #IF cl_null(g_aps_o.aps40) OR (g_aps.aps40 != g_aps_o.aps40)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps40) RETURNING l_aag02
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps40) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps40,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps40 = g_aps_o.aps40
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps40,g_aza.aza81)   #No.FUN-730064
                             RETURNING g_aps.aps40
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps40
                        NEXT FIELD aps40
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps40
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps40,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps40,g_errno,0)
                       DISPLAY BY NAME g_aps.aps40
                       NEXT FIELD aps40
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps40 = g_aps.aps40
        AFTER FIELD aps44               #價格差異科目
            IF NOT cl_null(g_aps.aps44) THEN
              #IF cl_null(g_aps_o.aps44) OR (g_aps.aps44 != g_aps_o.aps44)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps44) RETURNING l_aag02
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps44) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps44,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps44 = g_aps_o.aps44
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps44,g_aza.aza81)   #No.FUN-730064
                             RETURNING g_aps.aps44
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps44
                        NEXT FIELD aps44
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps44
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps44,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps44,g_errno,0)
                       DISPLAY BY NAME g_aps.aps44
                       NEXT FIELD aps44
                    END IF
                    #No.FUN-B40004  --End
              #END IF                        
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps44 = g_aps.aps44
        AFTER FIELD aps45               #存貨科目
            IF NOT cl_null(g_aps.aps45) THEN
              #IF cl_null(g_aps_o.aps45) OR (g_aps.aps45 != g_aps_o.aps45)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps45) RETURNING l_aag02
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps45) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps45,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps45 = g_aps_o.aps45
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps45,g_aza.aza81)   #No.FUN-730064
                             RETURNING g_aps.aps45
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps45
                        NEXT FIELD aps45
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps45
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps45,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps45,g_errno,0)
                       DISPLAY BY NAME g_aps.aps45
                       NEXT FIELD aps45
                    END IF
                    #No.FUN-B40004  --End
              #END IF                        
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps45 = g_aps.aps45
        AFTER FIELD aps46               #手續費科目
            IF NOT cl_null(g_aps.aps46) THEN
              #IF cl_null(g_aps_o.aps46) OR (g_aps.aps46 != g_aps_o.aps46)   #MOD-A50192 mark
              #   THEN                                                       #MOD-A50192 mark
                    LET g_errno = ' '
#                   CALL s_aapact('2',g_aps.aps46) RETURNING l_aag02
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps46) RETURNING l_aag02  #No.FUN-730064
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps46,g_errno,0)
#No.FUN-B20059 --begin
#                        LET g_aps.aps46 = g_aps_o.aps46
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps46,g_aza.aza81)   #No.FUN-730064
                             RETURNING g_aps.aps46
#No.FUN-B20059 --end
                        DISPLAY BY NAME g_aps.aps46
                        NEXT FIELD aps46
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps46
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps46,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps46,g_errno,0)
                       DISPLAY BY NAME g_aps.aps46
                       NEXT FIELD aps46
                    END IF
                    #No.FUN-B40004  --End
              #END IF                        
              #END IF                                                        #MOD-A50192 mark
            END IF
            LET g_aps_o.aps46 = g_aps.aps46
        #-----END MOD-690082-----
#No.FUN-B20059 --begin
        AFTER FIELD aps58             
            IF NOT cl_null(g_aps.aps58) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps58) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps58,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps58,g_aza.aza81)  
                             RETURNING g_aps.aps58
                        DISPLAY BY NAME g_aps.aps58
                        NEXT FIELD aps58
                    END IF 
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps58
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps58,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps58,g_errno,0)
                       DISPLAY BY NAME g_aps.aps58
                       NEXT FIELD aps58
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                          
            END IF
            LET g_aps_o.aps58 = g_aps.aps58
        AFTER FIELD aps57             
            IF NOT cl_null(g_aps.aps57) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps57) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps57,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps57,g_aza.aza81)  
                             RETURNING g_aps.aps57
                        DISPLAY BY NAME g_aps.aps57
                        NEXT FIELD aps57
                    END IF 
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps57
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps57,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps57,g_errno,0)
                       DISPLAY BY NAME g_aps.aps57
                       NEXT FIELD aps57
                    END IF
                    #No.FUN-B40004  --End                                                  
            END IF
            LET g_aps_o.aps57 = g_aps.aps57
        AFTER FIELD aps61             
            IF NOT cl_null(g_aps.aps61) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza81,g_aps.aps61) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps61,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps61,g_aza.aza81)  
                             RETURNING g_aps.aps61
                        DISPLAY BY NAME g_aps.aps61
                        NEXT FIELD aps61
                    END IF  
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps61
                       AND aag00 = g_aza.aza81
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps61,g_aps.aps01,g_aza.aza81)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps61,g_errno,0)
                       DISPLAY BY NAME g_aps.aps61
                       NEXT FIELD aps61
                    END IF
                    #No.FUN-B40004  --End                                                 
            END IF
            LET g_aps_o.aps61 = g_aps.aps61
#No.FUN-B20059 --end 
 
        #No.FUN-680029 --start--
        BEFORE FIELD aps111
          MESSAGE ''
          IF NOT cl_null(g_aps.aps111) THEN
#            CALL s_aapact('2',g_aps.aps111) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps111) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps111		#現金科目二
            IF NOT cl_null(g_aps.aps111) THEN
              #IF cl_null(g_aps_o.aps111) OR (g_aps.aps111 != g_aps_o.aps111) THEN   #MOD-A50192 mark
                  LET g_errno = ' '                                                  #MOD-A50192 mark
#                 CALL s_aapact('2',g_aps.aps111) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps111) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_aps.aps111,g_errno,0)
#No.FUN-B20059 --begin
#                     LET g_aps.aps111 = g_aps_o.aps111
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps111,g_aza.aza82)   #No.FUN-730064
                               RETURNING g_aps.aps111
#No.FUN-B20059 --end
                     DISPLAY BY NAME g_aps.aps111
                     NEXT FIELD aps111
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps111
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps111,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps111,g_errno,0)
                       DISPLAY BY NAME g_aps.aps111
                       NEXT FIELD aps111
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                               #MOD-A50192 mark
            END IF
            LET g_aps_o.aps111 = g_aps.aps111
 
        BEFORE FIELD aps121
          MESSAGE ''
          IF NOT cl_null(g_aps.aps121) THEN
#            CALL s_aapact('2',g_aps.aps121) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps121) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps121		#預付帳款科目二
            IF NOT cl_null(g_aps.aps121) THEN
              #IF cl_null(g_aps_o.aps121) OR (g_aps.aps121 != g_aps_o.aps121) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps121) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps121) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps121,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps121 = g_aps_o.aps121
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps121,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps121
#No.FUN-B20059 --end
                      DISPLAY BY NAME g_aps.aps121
                      NEXT FIELD aps121
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps121
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps121,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps121,g_errno,0)
                       DISPLAY BY NAME g_aps.aps121
                       NEXT FIELD aps121
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                               #MOD-A50192 mark
            END IF
            LET g_aps_o.aps121 = g_aps.aps121
 
        BEFORE FIELD aps131
          MESSAGE ''
          IF NOT cl_null(g_aps.aps131) THEN
#            CALL s_aapact('2',g_aps.aps131) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps131) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps131		#暫付帳款科目二
            IF NOT cl_null(g_aps.aps131) THEN
              #IF cl_null(g_aps_o.aps131) OR (g_aps.aps131 != g_aps_o.aps131) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps131) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps131) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps131,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps131 = g_aps_o.aps131
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps131,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps131
#No.FUN-B20059 --end
                      DISPLAY BY NAME g_aps.aps131
                      NEXT FIELD aps131
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps131
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps131,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps131,g_errno,0)
                       DISPLAY BY NAME g_aps.aps131
                       NEXT FIELD aps131
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps131 = g_aps.aps131
 
        BEFORE FIELD aps141
          MESSAGE ''
          IF NOT cl_null(g_aps.aps141) THEN
#            CALL s_aapact('2',g_aps.aps141) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps141) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps141		#預付購料款二
            IF NOT cl_null(g_aps.aps141) THEN
              #IF cl_null(g_aps_o.aps141) OR (g_aps.aps141 != g_aps_o.aps141) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps141) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps141) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps141,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps141 = g_aps_o.aps141
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps141,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps141
#No.FUN-B20059 --end
                      DISPLAY BY NAME g_aps.aps141
                      NEXT FIELD aps141
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps141
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps141,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps141,g_errno,0)
                       DISPLAY BY NAME g_aps.aps141
                       NEXT FIELD aps141
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps141 = g_aps.aps141
 
        BEFORE FIELD aps211
          MESSAGE ''
          IF NOT cl_null(g_aps.aps211) THEN
#            CALL s_aapact('2',g_aps.aps211) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps211) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps211		#未開發票應付二
            IF NOT cl_null(g_aps.aps211) THEN
              #IF cl_null(g_aps_o.aps211) OR (g_aps.aps211 != g_aps_o.aps211) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps211) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps211) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps211,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps211 = g_aps_o.aps211
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps211,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps211
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps211
                      NEXT FIELD aps211
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps211
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps211,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps211,g_errno,0)
                       DISPLAY BY NAME g_aps.aps211
                       NEXT FIELD aps211
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps211 = g_aps.aps211
 
        BEFORE FIELD aps221
          MESSAGE ''
          IF NOT cl_null(g_aps.aps221) THEN
#            CALL s_aapact('2',g_aps.aps221) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps221) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps221		#應付帳款科目二
            IF NOT cl_null(g_aps.aps221) THEN
              #IF cl_null(g_aps_o.aps221) OR (g_aps.aps221 != g_aps_o.aps221) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps221) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps221) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps221,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps221 = g_aps_o.aps221
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps221,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps221
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps221
                      NEXT FIELD aps221
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps221
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps221,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps221,g_errno,0)
                       DISPLAY BY NAME g_aps.aps221
                       NEXT FIELD aps221
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps221 = g_aps.aps221
 
        BEFORE FIELD aps235
          MESSAGE ''
          IF NOT cl_null(g_aps.aps235) THEN
#            CALL s_aapact('2',g_aps.aps235) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps235) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps235		#應付費用科目二
            IF NOT cl_null(g_aps.aps235) THEN
              #IF cl_null(g_aps_o.aps235) OR (g_aps.aps235 != g_aps_o.aps235) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps235) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps235) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps235,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps235 = g_aps_o.aps235
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps235,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps235
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps235
                      NEXT FIELD aps235
                  END IF
              #END IF    
              #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps235
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps235,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps235,g_errno,0)
                       DISPLAY BY NAME g_aps.aps235
                       NEXT FIELD aps235
                    END IF
                    #No.FUN-B40004  --End                                                            #MOD-A50192 mark
            END IF
            LET g_aps_o.aps235 = g_aps.aps235
 
        BEFORE FIELD aps236
          MESSAGE ''
          IF NOT cl_null(g_aps.aps236) THEN
#            CALL s_aapact('2',g_aps.aps236) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps236) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps236		#應付保險費二
            IF NOT cl_null(g_aps.aps236) THEN
              #IF cl_null(g_aps_o.aps236) OR (g_aps.aps236 != g_aps_o.aps236) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps236) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps236) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps236,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps236 = g_aps_o.aps236
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps236,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps236
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps236
                      NEXT FIELD aps236
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps236
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps236,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps236,g_errno,0)
                       DISPLAY BY NAME g_aps.aps236
                       NEXT FIELD aps236
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                 #MOD-A50192 mark
            END IF
            LET g_aps_o.aps236 = g_aps.aps236
 
        BEFORE FIELD aps237
          MESSAGE ''
          IF NOT cl_null(g_aps.aps237) THEN
#            CALL s_aapact('2',g_aps.aps237) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps237) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps237		#應付報關雜費二
            IF NOT cl_null(g_aps.aps237) THEN
              #IF cl_null(g_aps_o.aps237) OR (g_aps.aps237 != g_aps_o.aps237) THEN    #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps237) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps237) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps237,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps237 = g_aps_o.aps237
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps237,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps237
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps237
                      NEXT FIELD aps237
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps237
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps237,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps237,g_errno,0)
                       DISPLAY BY NAME g_aps.aps237
                       NEXT FIELD aps237
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                 #MOD-A50192 mark
            END IF
            LET g_aps_o.aps237 = g_aps.aps237
 
        BEFORE FIELD aps238
          MESSAGE ''
          IF NOT cl_null(g_aps.aps238) THEN
#            CALL s_aapact('2',g_aps.aps238) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps238) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps238		#應付關稅科目二
            IF NOT cl_null(g_aps.aps238) THEN
              #IF cl_null(g_aps_o.aps238) OR (g_aps.aps238 != g_aps_o.aps238) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps238) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps238) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps238,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps238 = g_aps_o.aps238
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps238,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps238
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps238
                      NEXT FIELD aps238
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps238
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps238,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps238,g_errno,0)
                       DISPLAY BY NAME g_aps.aps238
                       NEXT FIELD aps238
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps238 = g_aps.aps238
 
        BEFORE FIELD aps239
          MESSAGE ''
          IF NOT cl_null(g_aps.aps239) THEN
#            CALL s_aapact('2',g_aps.aps239) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps239) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps239		#應付運費科目二
            IF NOT cl_null(g_aps.aps239) THEN
              #IF cl_null(g_aps_o.aps239) OR (g_aps.aps239 != g_aps_o.aps239) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps239) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps239) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps239,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps239 = g_aps_o.aps239
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps239,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps239
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps239
                      NEXT FIELD aps239
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps239
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps239,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps239,g_errno,0)
                       DISPLAY BY NAME g_aps.aps239
                       NEXT FIELD aps239
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps239 = g_aps.aps239
 
        BEFORE FIELD aps241
          MESSAGE ''
          IF NOT cl_null(g_aps.aps241) THEN
#            CALL s_aapact('2',g_aps.aps241) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps241) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps241		#應付票據科目二
            IF NOT cl_null(g_aps.aps241) THEN
              #IF cl_null(g_aps_o.aps241) OR (g_aps.aps241 != g_aps_o.aps241) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps241) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps241) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps241,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps241 = g_aps_o.aps241
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps241,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps241
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps241
                      NEXT FIELD aps241
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps241
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps241,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps241,g_errno,0)
                       DISPLAY BY NAME g_aps.aps241
                       NEXT FIELD aps241
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps241 = g_aps.aps241
 
        BEFORE FIELD aps251
          MESSAGE ''
          IF NOT cl_null(g_aps.aps251) THEN
#            CALL s_aapact('2',g_aps.aps251) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps251) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps251		#短期借款科目二
            IF NOT cl_null(g_aps.aps251) THEN
              #IF cl_null(g_aps_o.aps251) OR (g_aps.aps251 != g_aps_o.aps251) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps251) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps251) RETURNING l_aag02  #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps251,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps251 = g_aps_o.aps251
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps251,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps251
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps251
                      NEXT FIELD aps251
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps251
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps251,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps251,g_errno,0)
                       DISPLAY BY NAME g_aps.aps251
                       NEXT FIELD aps251
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps251 = g_aps.aps251
 
        BEFORE FIELD aps561
          MESSAGE ''
          IF NOT cl_null(g_aps.aps561) THEN
#            CALL s_aapact('2',g_aps.aps561) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps561) RETURNING l_aag02   #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps561		#代付匯票科目二
            IF NOT cl_null(g_aps.aps561) THEN
              #IF cl_null(g_aps_o.aps561) OR (g_aps.aps561 != g_aps_o.aps561) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps561) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps561) RETURNING l_aag02   #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps561,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps561 = g_aps_o.aps561
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps561,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps561
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps561
                      NEXT FIELD aps561
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps561
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps561,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps561,g_errno,0)
                       DISPLAY BY NAME g_aps.aps561
                       NEXT FIELD aps561
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps561 = g_aps.aps561
 
        BEFORE FIELD aps471
          MESSAGE ''
          IF NOT cl_null(g_aps.aps471) THEN
#            CALL s_aapact('2',g_aps.aps471) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps471) RETURNING l_aag02    #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps471		#郵資科目二
            IF NOT cl_null(g_aps.aps471) THEN
              #IF cl_null(g_aps_o.aps471) OR (g_aps.aps471 != g_aps_o.aps471) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps471) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps471) RETURNING l_aag02    #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps471,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps471 = g_aps_o.aps471
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps471,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps471
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps471
                      NEXT FIELD aps471
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps471
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps471,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps471,g_errno,0)
                       DISPLAY BY NAME g_aps.aps471
                       NEXT FIELD aps471
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                               #MOD-A50192 mark
            END IF
            LET g_aps_o.aps471 = g_aps.aps471
 
        BEFORE FIELD aps411
          MESSAGE ''
          IF NOT cl_null(g_aps.aps411) THEN
#            CALL s_aapact('2',g_aps.aps411) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps411) RETURNING l_aag02   #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps411		#進貨折讓科目二
            IF NOT cl_null(g_aps.aps411) THEN
              #IF cl_null(g_aps_o.aps411) OR (g_aps.aps411 != g_aps_o.aps411) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps411) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps411) RETURNING l_aag02   #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps411,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps411 = g_aps_o.aps411
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps441,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps411
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps411
                      NEXT FIELD aps411
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps411
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps411,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps411,g_errno,0)
                       DISPLAY BY NAME g_aps.aps411
                       NEXT FIELD aps411
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps411 = g_aps.aps411
 
        BEFORE FIELD aps421
          MESSAGE ''
          IF NOT cl_null(g_aps.aps421) THEN
#            CALL s_aapact('2',g_aps.aps421) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps421) RETURNING l_aag02   #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps421		#匯兌損失科目二
            IF NOT cl_null(g_aps.aps421) THEN
              #IF cl_null(g_aps_o.aps421) OR (g_aps.aps421 != g_aps_o.aps421) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps421) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps421) RETURNING l_aag02   #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps421,g_errno,0)

#No.FUN-B20059 --begin
#                      LET g_aps.aps421 = g_aps_o.aps421
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps421,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps421
#No.FUN-B20059 --end
                      DISPLAY BY NAME g_aps.aps421
                      NEXT FIELD aps421
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps421
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps421,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps421,g_errno,0)
                       DISPLAY BY NAME g_aps.aps421
                       NEXT FIELD aps421
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps421 = g_aps.aps421
 
        BEFORE FIELD aps431
          MESSAGE ''
          IF NOT cl_null(g_aps.aps431) THEN
#            CALL s_aapact('2',g_aps.aps431) RETURNING l_aag02
             CALL s_aapact('2',g_aza.aza82,g_aps.aps431) RETURNING l_aag02  #No.FUN-730064
             MESSAGE l_aag02 CLIPPED
          END IF
 
        AFTER FIELD aps431		#匯兌收益科目二
            IF NOT cl_null(g_aps.aps431) THEN
              #IF cl_null(g_aps_o.aps431) OR (g_aps.aps431 != g_aps_o.aps431) THEN   #MOD-A50192 mark
                  LET g_errno = ' '
#                 CALL s_aapact('2',g_aps.aps431) RETURNING l_aag02
                  CALL s_aapact('2',g_aza.aza82,g_aps.aps431) RETURNING l_aag02    #No.FUN-730064
                  IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_aps.aps431,g_errno,0)
#No.FUN-B20059 --begin
#                      LET g_aps.aps431 = g_aps_o.aps431
                        CALL q_aapact(FALSE,FALSE,'2',g_aps.aps431,g_aza.aza82)   #No.FUN-730064
                             RETURNING g_aps.aps431
#No.FUN-B20059 --end

                      DISPLAY BY NAME g_aps.aps431
                      NEXT FIELD aps431
                  END IF
                  #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps431
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps431,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps431,g_errno,0)
                       DISPLAY BY NAME g_aps.aps431
                       NEXT FIELD aps431
                    END IF
                    #No.FUN-B40004  --End
              #END IF                                                                #MOD-A50192 mark
            END IF
            LET g_aps_o.aps431 = g_aps.aps431
        #No.FUN-680029 --end--
#No.FUN-B20059 --begin
        AFTER FIELD aps441             
            IF NOT cl_null(g_aps.aps441) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza82,g_aps.aps441) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps441,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps441,g_aza.aza82)  
                             RETURNING g_aps.aps441
                        DISPLAY BY NAME g_aps.aps441
                        NEXT FIELD aps441
                    END IF
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps441
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps441,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps441,g_errno,0)
                       DISPLAY BY NAME g_aps.aps441
                       NEXT FIELD aps441
                    END IF
                    #No.FUN-B40004  --End                                                   
            END IF
            LET g_aps_o.aps441 = g_aps.aps441
        AFTER FIELD aps451             
            IF NOT cl_null(g_aps.aps451) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza82,g_aps.aps451) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps451,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps451,g_aza.aza82)  
                             RETURNING g_aps.aps451
                        DISPLAY BY NAME g_aps.aps451
                        NEXT FIELD aps451
                    END IF  
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps451
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps451,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps451,g_errno,0)
                       DISPLAY BY NAME g_aps.aps451
                       NEXT FIELD aps451
                    END IF
                    #No.FUN-B40004  --End                                                 
            END IF
            LET g_aps_o.aps451 = g_aps.aps451
        AFTER FIELD aps461             
            IF NOT cl_null(g_aps.aps461) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza82,g_aps.aps461) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps461,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps461,g_aza.aza82)  
                             RETURNING g_aps.aps461
                        DISPLAY BY NAME g_aps.aps461
                        NEXT FIELD aps461
                    END IF  
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps461
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps461,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps461,g_errno,0)
                       DISPLAY BY NAME g_aps.aps461
                       NEXT FIELD aps461
                    END IF
                    #No.FUN-B40004  --End                                                 
            END IF
            LET g_aps_o.aps461 = g_aps.aps461
        AFTER FIELD aps581             
            IF NOT cl_null(g_aps.aps581) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza82,g_aps.aps581) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps581,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps581,g_aza.aza82)  
                             RETURNING g_aps.aps581
                        DISPLAY BY NAME g_aps.aps581
                        NEXT FIELD aps581
                    END IF 
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps581
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps581,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps581,g_errno,0)
                       DISPLAY BY NAME g_aps.aps581
                       NEXT FIELD aps581
                    END IF
                    #No.FUN-B40004  --End                                                  
            END IF
            LET g_aps_o.aps581 = g_aps.aps581
        AFTER FIELD aps571             
            IF NOT cl_null(g_aps.aps571) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza82,g_aps.aps571) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps571,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps571,g_aza.aza82)  
                             RETURNING g_aps.aps571
                        DISPLAY BY NAME g_aps.aps571
                        NEXT FIELD aps571
                    END IF  
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps571
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps571,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps571,g_errno,0)
                       DISPLAY BY NAME g_aps.aps571
                       NEXT FIELD aps571
                    END IF
                    #No.FUN-B40004  --End                                                 
            END IF
            LET g_aps_o.aps571 = g_aps.aps571
        AFTER FIELD aps611             
            IF NOT cl_null(g_aps.aps611) THEN 
                    LET g_errno = ' '
                    CALL s_aapact('2',g_aza.aza82,g_aps.aps611) RETURNING l_aag02  
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_aps.aps611,g_errno,0)
                          CALL q_aapact(FALSE,FALSE,'2',g_aps.aps611,g_aza.aza82)  
                             RETURNING g_aps.aps611
                        DISPLAY BY NAME g_aps.aps611
                        NEXT FIELD aps611
                    END IF 
                    #No.FUN-B40004  --Begin
                    LET l_aag05=''
                    SELECT aag05 INTO l_aag05 FROM aag_file
                     WHERE aag01 = g_aps.aps611
                       AND aag00 = g_aza.aza82
                   #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
                    IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                       #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                       IF g_aaz.aaz90 !='Y' THEN
                          LET g_errno = ' '
                          CALL s_chkdept(g_aaz.aaz72,g_aps.aps611,g_aps.aps01,g_aza.aza82)
                               RETURNING g_errno
                       END IF
                    END IF
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_aps.aps611,g_errno,0)
                       DISPLAY BY NAME g_aps.aps611
                       NEXT FIELD aps611
                    END IF
                    #No.FUN-B40004  --End                                                  
            END IF
            LET g_aps_o.aps611 = g_aps.aps611
#No.FUN-B20059 --end 
        
        #No.FUN-B40004  --Begin
        BEFORE FIELD aps401
          MESSAGE ''
          IF NOT cl_null(g_aps.aps401) THEN
             CALL s_aapact('2',g_aza.aza82,g_aps.aps401) RETURNING l_aag02
             MESSAGE l_aag02 CLIPPED
          END IF
               
        AFTER FIELD aps401		#購貨退回科目二
            IF NOT cl_null(g_aps.aps401) THEN          
               LET g_errno = ' '
               CALL s_aapact('2',g_aza.aza82,g_aps.aps401) RETURNING l_aag02
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_aps.aps401,g_errno,0)
                   CALL q_aapact(FALSE,FALSE,'2',g_aps.aps401,g_aza.aza82)
                          RETURNING g_aps.aps401
                   DISPLAY BY NAME g_aps.aps401
                   NEXT FIELD aps401
               END IF
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_aps.aps401
                  AND aag00 = g_aza.aza82
              #IF l_aag05 = 'Y' THEN                             #MOD-BC0149 mark
               IF l_aag05 = 'Y' AND g_apz.apz13 = 'Y' THEN       #MOD-BC0149 add
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_aps.aps401,g_aps.aps01,g_aza.aza82)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_aps.aps401,g_errno,0)
                  DISPLAY BY NAME g_aps.aps401
                  NEXT FIELD aps401
               END IF                                                 
            END IF
            LET g_aps_o.aps401 = g_aps.aps401
            #No.FUN-B40004  --End
            
            
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aps.apsuser = s_get_data_owner("aps_file") #FUN-C10039
           LET g_aps.apsgrup = s_get_data_group("aps_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_apz.apz13 = 'Y' THEN
               IF cl_null(g_aps.aps01) THEN
                   LET l_flag='Y'
                   DISPLAY BY NAME g_aps.aps01
               END IF
            END IF
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD aps01
            END IF
 
        #-----FUN-630081---------
        #ON ACTION CONTROLO                        # 沿用所有欄位
        #    IF INFIELD(aps01) THEN
        #        LET g_aps.* = g_aps_t.*
        #        DISPLAY BY NAME g_aps.*
        #        NEXT FIELD aps01
        #    END IF
        #-----END FUN-630081-----
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aps01) #部門編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_aps.aps01
                 CALL cl_create_qry() RETURNING g_aps.aps01
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps01 )
                 DISPLAY BY NAME g_aps.aps01
                 CALL i202_aps01('d',g_aps.aps01)
                 NEXT FIELD aps01
              #FUN-CB0056---add---str
              WHEN INFIELD(aps02)   # 暂估税种
                 CALL cl_init_qry_var()
                 IF g_aza.aza26 = '2' THEN
                    LET g_qryparam.form = "q_gec7_1"
                 ELSE
                    LET g_qryparam.form = "q_gec7"
                 END IF
                 LET g_qryparam.default1 = g_aps.aps02
                 LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING g_aps.aps02
                 DISPLAY BY NAME g_aps.aps02

              WHEN INFIELD(aps03)   # 预付税种
                 CALL cl_init_qry_var()
                 IF g_aza.aza26 = '2' THEN
                    LET g_qryparam.form = "q_gec8_1"
                 ELSE
                    LET g_qryparam.form = "q_gec8"
                 END IF
                 LET g_qryparam.default1 = g_aps.aps03
                 LET g_qryparam.arg1 = '1'
                 CALL cl_create_qry() RETURNING g_aps.aps03
                 DISPLAY BY NAME g_aps.aps03

              #FUN-CB0056---add---end
              WHEN INFIELD(aps11) #現金科目
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps11)   #No:8727
#                       RETURNING g_aps.aps11
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps11,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps11
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps11 )
                 DISPLAY BY NAME g_aps.aps11
                 NEXT FIELD aps11
              WHEN INFIELD(aps12) #預付帳款科目
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps12)   #No:8727
#                     RETURNING g_aps.aps12
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps12,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps12
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps12 )
                 DISPLAY BY NAME g_aps.aps12
                 NEXT FIELD aps12
              WHEN INFIELD(aps13) #暫付帳款科目
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps13)   #No:8727
#                     RETURNING g_aps.aps13
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps13,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps13
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps13 )
                 DISPLAY BY NAME g_aps.aps13
                 NEXT FIELD aps13
              WHEN INFIELD(aps14) #預付購料款
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps14)   #No:8727
#                     RETURNING g_aps.aps14
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps14,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps14
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps14 )
                 DISPLAY BY NAME g_aps.aps14
                 NEXT FIELD aps14
              WHEN INFIELD(aps21) #未開發票應付
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps21)   #No:8727
#                     RETURNING g_aps.aps21
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps21,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps21
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps21 )
                 DISPLAY BY NAME g_aps.aps21
                 NEXT FIELD aps21
              WHEN INFIELD(aps22) #應付帳款科目
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps22)   #No:8727
#                     RETURNING g_aps.aps22
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps22,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps22
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps22 )
                 DISPLAY BY NAME g_aps.aps22
                 NEXT FIELD aps22
              WHEN INFIELD(aps23) #應付費用科目
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps23)   #No:8727
#                     RETURNING g_aps.aps23
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps23,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps23
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps23 )
                 DISPLAY BY NAME g_aps.aps23
                 NEXT FIELD aps23
              WHEN INFIELD(aps231) #應付保險費
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps231)   #No:8727
#                     RETURNING g_aps.aps231
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps231,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps231
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps231 )
                 DISPLAY BY NAME g_aps.aps231
                 NEXT FIELD aps231
              WHEN INFIELD(aps232) #應付報關雜費
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps232)   #No:8727
#                     RETURNING g_aps.aps232
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps232,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps232
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps232 )
                 DISPLAY BY NAME g_aps.aps232
                 NEXT FIELD aps232
              WHEN INFIELD(aps233) #應付關稅科目
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps233)   #No:8727
#                     RETURNING g_aps.aps233
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps233,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps233
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps233 )
                 DISPLAY BY NAME g_aps.aps233
                 NEXT FIELD aps233
              WHEN INFIELD(aps234) #應付運費科目
#                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps234)   #No:8727
#                      RETURNING g_aps.aps234
                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps234,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps234
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps234 )
                 DISPLAY BY NAME g_aps.aps234
                 NEXT FIELD aps234
              WHEN INFIELD(aps24) #應付票據科目
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps24)   #No:8727
#                       RETURNING g_aps.aps24
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps24,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps24
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps24 )
                 DISPLAY BY NAME g_aps.aps24
                 NEXT FIELD aps24
              WHEN INFIELD(aps25) #短期借款科目
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps25)   #No:8727
#                     RETURNING g_aps.aps25
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps25,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps25
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps25 )
                 DISPLAY BY NAME g_aps.aps25
                 NEXT FIELD aps25
              WHEN INFIELD(aps56) #代付匯票科目
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps56)   #No:8727
#                       RETURNING g_aps.aps56
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps56,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps56
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps56 )
                 DISPLAY BY NAME g_aps.aps56
                 NEXT FIELD aps56
              WHEN INFIELD(aps47) #
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps47)   #No:8727
#                     RETURNING g_aps.aps47
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps47,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps47
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps47 )
                 DISPLAY BY NAME g_aps.aps47
                 NEXT FIELD aps47
 
              #-----FUN-660192---------
              WHEN INFIELD(aps58)
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps58)
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps58,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps58
                   DISPLAY BY NAME g_aps.aps58
                   NEXT FIELD aps58
              #-----END FUN-660192-----
              WHEN INFIELD(aps40) #進貨折讓科目
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps40)   #No:8727
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps40,g_aza.aza81)   #No.FUN-730064
                      RETURNING g_aps.aps40
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps40 )
                 DISPLAY BY NAME g_aps.aps40
                 NEXT FIELD aps40
              WHEN INFIELD(aps41) #進貨折讓科目
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps41)   #No:8727
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps41,g_aza.aza81)   #No.FUN-730064
                      RETURNING g_aps.aps41
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps41 )
                 DISPLAY BY NAME g_aps.aps41
                 NEXT FIELD aps41
              WHEN INFIELD(aps42) #匯兌損失科目
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps42)   #No:8727
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps42,g_aza.aza81)   #No.FUN-730064
                      RETURNING g_aps.aps42
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps42 )
                 DISPLAY BY NAME g_aps.aps42
                 NEXT FIELD aps42
              WHEN INFIELD(aps43) #匯兌收益科目
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps43)   #No:8727
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps43,g_aza.aza81)   #No.FUN-730064
                      RETURNING g_aps.aps43
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps43 )
                 DISPLAY BY NAME g_aps.aps43
                 NEXT FIELD aps43
              WHEN INFIELD(aps44) #difference
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps44)   #No:8727
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps44,g_aza.aza81)   #No.FUN-730064
                      RETURNING g_aps.aps44
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps44 )
                 DISPLAY BY NAME g_aps.aps44
                 NEXT FIELD aps44
              WHEN INFIELD(aps45) #difference
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps45)   #No:8727
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps45,g_aza.aza81)   #No.FUN-730064
                      RETURNING g_aps.aps45
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps45 )
                 DISPLAY BY NAME g_aps.aps45
                 NEXT FIELD aps45
              WHEN INFIELD(aps46)
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps46)   #No:8727
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps46,g_aza.aza81)   #No.FUN-730064
                      RETURNING g_aps.aps46
#                 CALL FGL_DIALOG_SETBUFFER( g_aps.aps46 )
                 DISPLAY BY NAME g_aps.aps46
                 NEXT FIELD aps46
              #-----FUN-660192---------
              WHEN INFIELD(aps57)
#                  CALL q_aapact(FALSE,TRUE,'2',g_aps.aps57)
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps57,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps57
                   DISPLAY BY NAME g_aps.aps57
                   NEXT FIELD aps57
              #-----END FUN-660192-----
#No.FUN-A80111 --begin
              WHEN INFIELD(aps61)
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps61,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps61
                   DISPLAY BY NAME g_aps.aps61
                   NEXT FIELD aps61
              WHEN INFIELD(aps611)
                   CALL q_aapact(FALSE,TRUE,'2',g_aps.aps611,g_aza.aza81)   #No.FUN-730064
                        RETURNING g_aps.aps611
                   DISPLAY BY NAME g_aps.aps611
                   NEXT FIELD aps611
#No.FUN-A80111 --end
              #No.FUN-680029 --start--
              WHEN INFIELD(aps111) #現金科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps111)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps111,g_aza.aza82)   #No.FUN-730064
                        RETURNING g_aps.aps111
                 DISPLAY BY NAME g_aps.aps111
                 NEXT FIELD aps11
              WHEN INFIELD(aps121) #預付帳款科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps121)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps121,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps121
                 DISPLAY BY NAME g_aps.aps121
                 NEXT FIELD aps121
              WHEN INFIELD(aps131) #暫付帳款科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps131)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps131,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps131
                 DISPLAY BY NAME g_aps.aps131
                 NEXT FIELD aps131
              WHEN INFIELD(aps141) #預付購料款二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps141)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps141,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps141
                 DISPLAY BY NAME g_aps.aps141
                 NEXT FIELD aps141
              WHEN INFIELD(aps211) #未開發票應付二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps211)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps211,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps211
                 DISPLAY BY NAME g_aps.aps211
                 NEXT FIELD aps211
              WHEN INFIELD(aps221) #應付帳款科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps221)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps221,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps221
                 DISPLAY BY NAME g_aps.aps221
                 NEXT FIELD aps221
              WHEN INFIELD(aps235) #應付費用科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps235)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps235,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps235
                 DISPLAY BY NAME g_aps.aps235
                 NEXT FIELD aps235
              WHEN INFIELD(aps236) #應付保險費二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps236)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps236,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps236
                 DISPLAY BY NAME g_aps.aps236
                 NEXT FIELD aps236
              WHEN INFIELD(aps237) #應付報關雜費二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps237)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps237,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps237
                 DISPLAY BY NAME g_aps.aps237
                 NEXT FIELD aps237
              WHEN INFIELD(aps238) #應付關稅科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps238)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps238,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps238
                 DISPLAY BY NAME g_aps.aps238
                 NEXT FIELD aps238
              WHEN INFIELD(aps239) #應付運費科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps238)
#                     RETURNING g_aps.aps238
#                DISPLAY BY NAME g_aps.aps238
#                NEXT FIELD aps238
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps239,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps239
                 DISPLAY BY NAME g_aps.aps239
                 NEXT FIELD aps239
              WHEN INFIELD(aps241) #應付票據科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps241)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps241,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps241
                 DISPLAY BY NAME g_aps.aps241
                 NEXT FIELD aps241
              WHEN INFIELD(aps251) #短期借款科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps251)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps251,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps251
                 DISPLAY BY NAME g_aps.aps251
                 NEXT FIELD aps251
              WHEN INFIELD(aps561) #代付匯票科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps561)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps561,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps561
                 DISPLAY BY NAME g_aps.aps561
                 NEXT FIELD aps561
              WHEN INFIELD(aps471)
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps471)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps471,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps471
                 DISPLAY BY NAME g_aps.aps471
                 NEXT FIELD aps471
              WHEN INFIELD(aps581)
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps581)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps581,g_aza.aza82)   #No.FUN-730064
                        RETURNING g_aps.aps581
                   DISPLAY BY NAME g_aps.aps581
                   NEXT FIELD aps581
              WHEN INFIELD(aps401) #進貨折讓科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps401)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps401,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps401
                 DISPLAY BY NAME g_aps.aps401
                 NEXT FIELD aps401
              WHEN INFIELD(aps411) #進貨折讓科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps411)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps441,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps411
                 DISPLAY BY NAME g_aps.aps411
                 NEXT FIELD aps411
              WHEN INFIELD(aps421) #匯兌損失科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps421)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps421,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps421
                 DISPLAY BY NAME g_aps.aps421
                 NEXT FIELD aps421
              WHEN INFIELD(aps431) #匯兌收益科目二
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps431)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps431,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps431
                 DISPLAY BY NAME g_aps.aps431
                 NEXT FIELD aps431
              WHEN INFIELD(aps441)
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps441)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps441,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps441
                 DISPLAY BY NAME g_aps.aps441
                 NEXT FIELD aps441
              WHEN INFIELD(aps451)
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps451)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps451,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps451
                 DISPLAY BY NAME g_aps.aps451
                 NEXT FIELD aps451
              WHEN INFIELD(aps461)
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps461)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps461,g_aza.aza82)   #No.FUN-730064
                      RETURNING g_aps.aps461
                 DISPLAY BY NAME g_aps.aps461
                 NEXT FIELD aps461
              WHEN INFIELD(aps571)
#                CALL q_aapact(FALSE,TRUE,'2',g_aps.aps571)
                 CALL q_aapact(FALSE,TRUE,'2',g_aps.aps571,g_aza.aza82)   #No.FUN-730064
                        RETURNING g_aps.aps571
                   DISPLAY BY NAME g_aps.aps571
                   NEXT FIELD aps571
              #No.FUN-680029 --end--
              OTHERWISE EXIT CASE
            END CASE
 
 
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
 
FUNCTION i202_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("aps01",TRUE)
   END IF
 
#   IF INFIELD(apm00) OR (NOT g_before_input_done) THEN
#      CALL cl_set_comp_entry("apm03",TRUE)
#   END IF
END FUNCTION
 
FUNCTION i202_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey matches'[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("aps01",FALSE)
   END IF
 
#   IF INFIELD(apm00) OR (NOT g_before_input_done) THEN
#      IF g_aag05<>'Y' THEN
#         CALL cl_set_comp_entry("apm03",FALSE)
#      END IF
#   END IF
   IF g_apz.apz13 = 'N' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("aps01",FALSE)
      LET g_aps.aps01=' '
   END IF
END FUNCTION
 
FUNCTION i202_aps01(p_cmd,p_key)  #部門編號
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
           p_key   LIKE aps_file.aps01,
           l_gem02 LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    SELECT gem02,gemacti
           INTO l_gem02,l_gemacti
           FROM gem_file WHERE gem01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-063'
                            LET l_gem02 = NULL
         WHEN l_gemacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
     IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
END FUNCTION
 
FUNCTION i202_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aps.* TO NULL              #No.FUN-6A0016
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL i202_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN i202_count
    FETCH i202_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN i202_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)
        INITIALIZE g_aps.* TO NULL
    ELSE
        CALL i202_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i202_fetch(p_flaps)
    DEFINE
        p_flaps          LIKE type_file.chr1   # No.FUN-690028 VARCHAR(1)
 
    CASE p_flaps
        WHEN 'N' FETCH NEXT     i202_cs INTO g_aps.aps01
        WHEN 'P' FETCH PREVIOUS i202_cs INTO g_aps.aps01
        WHEN 'F' FETCH FIRST    i202_cs INTO g_aps.aps01
        WHEN 'L' FETCH LAST     i202_cs INTO g_aps.aps01
        WHEN '/'
            IF NOT mi_no_ask THEN
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
            FETCH ABSOLUTE g_jump i202_cs INTO g_aps.aps01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)
        INITIALIZE g_aps.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flaps
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_aps.* FROM aps_file            # 重讀DB,因TEMP有不被更新特性
       WHERE aps01 = g_aps.aps01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
       CALL cl_err3("sel","aps_file",g_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
       LET g_data_owner = g_aps.apsuser     #No.FUN-4C0047
       LET g_data_group = g_aps.apsgrup     #No.FUN-4C0047
       CALL i202_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i202_show()
    LET g_aps_t.* = g_aps.*
    DISPLAY BY NAME g_aps.apsoriu,g_aps.apsorig,
        g_aps.aps01,g_aps.aps11,g_aps.aps12, g_aps.aps13,g_aps.aps14,
        g_aps.aps40,g_aps.aps41,g_aps.aps42, g_aps.aps43,
        #g_aps.aps44,g_aps.aps45,g_aps.aps46,   #FUN-660192
        g_aps.aps44,g_aps.aps45,g_aps.aps46,g_aps.aps57,g_aps.aps61,   #FUN-660192  #No.FUN-A80111 add aps61
        g_aps.aps21,g_aps.aps22, g_aps.aps23,
        g_aps.aps231,g_aps.aps232,g_aps.aps233,g_aps.aps234,
        #g_aps.aps24,g_aps.aps25,g_aps.aps56,g_aps.aps47,   #FUN-660192
        g_aps.aps24,g_aps.aps25,g_aps.aps56,g_aps.aps47,g_aps.aps58,   #FUN-660192
        #No.FUN-680029 --start--
        g_aps.aps111,g_aps.aps121,g_aps.aps131,g_aps.aps141,g_aps.aps401,
        g_aps.aps411,g_aps.aps421,g_aps.aps431,g_aps.aps441,g_aps.aps451,
        g_aps.aps461,g_aps.aps571,g_aps.aps611,g_aps.aps211,g_aps.aps221,g_aps.aps235,  #No.FUN-A80111
        g_aps.aps236,g_aps.aps237,g_aps.aps238,g_aps.aps239,g_aps.aps241,
        g_aps.aps251,g_aps.aps561,g_aps.aps471,g_aps.aps581,
        #No.FUN-680029 --end--
        g_aps.aps02,g_aps.aps03,                                   #FUN-CB0056
        g_aps.apsuser,g_aps.apsgrup,g_aps.apsmodu,g_aps.apsdate,g_aps.apsacti
    CALL i202_aps01('d',g_aps.aps01)
    CALL cl_set_field_pic("","","","","",g_aps.apsacti)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i202_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_aps.aps01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_aps.* FROM aps_file
      WHERE aps01=g_aps.aps01
    IF g_aps.apsacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_aps.aps01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN i202_cl USING g_aps.aps01
    IF STATUS THEN
       CALL cl_err("OPEN i202_cl:", STATUS, 1)
       CLOSE i202_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i202_cl INTO g_aps.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_aps01_t = g_aps.aps01
    LET g_aps_o.*=g_aps.*
    LET g_aps.apsmodu=g_user                     #修改者
    LET g_aps.apsdate = g_today                  #修改日期
    CALL i202_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i202_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_aps.*=g_aps_t.*
            CALL i202_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE aps_file SET aps_file.* = g_aps.*    # 更新DB
            WHERE aps01 = g_aps01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","aps_file",g_aps01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE i202_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i202_x()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
	IF g_aps.aps01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
	BEGIN WORK
 
    OPEN i202_cl USING g_aps.aps01
    IF STATUS THEN
       CALL cl_err("OPEN i202_cl:", STATUS, 1)
       CLOSE i202_cl
       ROLLBACK WORK
       RETURN
    END IF
	FETCH i202_cl INTO g_aps.*
	IF SQLCA.sqlcode THEN CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0) RETURN END IF
	CALL i202_show()
	IF cl_exp(15,21,g_aps.apsacti) THEN
        LET g_chr=g_aps.apsacti
        IF g_aps.apsacti='Y'
           THEN LET g_aps.apsacti='N'
           ELSE LET g_aps.apsacti='Y'
        END IF
        UPDATE aps_file
            SET apsacti=g_aps.apsacti,
               apsmodu=g_user, apsdate=g_today
            WHERE aps01 = g_aps.aps01
        IF SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
            CALL cl_err3("upd","aps_file",g_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            LET g_aps.apsacti=g_chr
        END IF
        DISPLAY BY NAME g_aps.apsacti
    END IF
    CLOSE i202_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i202_r()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_aps.aps01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
 
#NO.TQC-940053 ADD BEGIN--                               
    IF g_aps.apsacti = 'N' THEN                                  
       CALL cl_err('','abm-950',0)                               
       RETURN                                                                            
    END IF                                               
#NO.TQC-940053 ADD END--             
    BEGIN WORK
 
    OPEN i202_cl USING g_aps.aps01
    IF STATUS THEN
       CALL cl_err("OPEN i202_cl:", STATUS, 1)
       CLOSE i202_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i202_cl INTO g_aps.*
    IF SQLCA.sqlcode THEN CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0) RETURN END IF
    CALL i202_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "aps01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_aps.aps01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
        DELETE FROM aps_file WHERE aps01 = g_aps.aps01
        IF SQLCA.SQLERRD[3]=0 THEN
#            CALL cl_err(g_aps.aps01,SQLCA.sqlcode,0)   #No.FUN-660122
             CALL cl_err3("del","aps_file",g_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
        ELSE CLEAR FORM
             INITIALIZE g_aps.* TO NULL
             OPEN i202_count
             #FUN-B50062-add-start--
             IF STATUS THEN
                CLOSE i202_cl
                CLOSE i202_count
                COMMIT WORK
                RETURN
             END IF
             #FUN-B50062-add-end--
             FETCH i202_count INTO g_row_count
             #FUN-B50062-add-start--
             IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
                CLOSE i202_cl
                CLOSE i202_count
                COMMIT WORK
                RETURN
             END IF
             #FUN-B50062-add-end--
             DISPLAY g_row_count TO FORMONLY.cnt
             OPEN i202_cs
             IF g_curs_index = g_row_count + 1 THEN
                LET g_jump = g_row_count
                CALL i202_fetch('L')
             ELSE
                LET g_jump = g_curs_index
                LET mi_no_ask = TRUE
                CALL i202_fetch('/')
             END IF
        END IF
    END IF
    CLOSE i202_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i202_copy()
   DEFINE l_aps           RECORD LIKE aps_file.*,
          l_oldno,l_newno LIKE aps_file.aps01,
          l_n             LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_apz.apz13 = 'N' THEN
         CALL cl_err('','aap-088',0)
         RETURN
    END IF
    IF g_aps.aps01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
 
    LET g_before_input_done = FALSE
    CALL i202_set_entry('a')
    CALL i202_set_no_entry('a')
    LET g_before_input_done = TRUE
 
    INPUT l_newno FROM aps01
        AFTER FIELD aps01             #部門編號
            IF cl_null(l_newno) IS NULL THEN
                CALL cl_err('','aap-099',0)
                NEXT FIELD aps01
            END IF
            CALL i202_aps01('a',l_newno)
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(l_newno,g_errno,0)
                    NEXT FIELD aps01
                 END IF
 
        AFTER INPUT  #判斷
            IF INT_FLAG THEN
                LET INT_FLAG = 0
                EXIT INPUT
            END IF
            SELECT count(*) INTO l_n FROM aps_file
                WHERE aps01 = l_newno
           IF l_n > 0 THEN                  # Duplicated
               CALL cl_err(l_newno,-239,0)
               NEXT FIELD aps01
           END IF
        ON ACTION controlp
            CASE WHEN INFIELD(aps01) #部門編號
#                CALL q_gem(10,3,l_newno) RETURNING l_newno
#                CALL FGL_DIALOG_SETBUFFER( l_newno )
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem"
                 LET g_qryparam.default1 = g_aps.aps01
                 CALL cl_create_qry() RETURNING l_newno
#                 CALL FGL_DIALOG_SETBUFFER( l_newno )
                 DISPLAY l_newno TO aps01
                 CALL i202_aps01('d',l_newno)
                 NEXT FIELD aps01
            END CASE
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
        DISPLAY BY NAME g_aps.aps01
        RETURN
    END IF
    LET l_aps.* = g_aps.*
    LET l_aps.aps01  =l_newno   #資料鍵值
    LET l_aps.apsuser=g_user    #資料所有者
    LET l_aps.apsgrup=g_grup    #資料所有者所屬群
    LET l_aps.apsmodu=NULL      #資料修改日期
    LET l_aps.apsdate=g_today   #資料建立日期
    LET l_aps.apsacti='Y'       #有效資料
    LET l_aps.apsoriu = g_user      #No.FUN-980030 10/01/04
    LET l_aps.apsorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO aps_file VALUES (l_aps.*)
    IF SQLCA.sqlcode THEN
#       CALL cl_err(l_newno,SQLCA.sqlcode,0)   #No.FUN-660122
        CALL cl_err3("ins","aps_file",l_aps.aps01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K'
        LET l_oldno = g_aps.aps01
        SELECT aps_file.* INTO g_aps.* FROM aps_file
                       WHERE aps01 = l_newno
        CALL i202_u()
        #FUN-C30027---begin
        #SELECT aps_file.* INTO g_aps.* FROM aps_file
        #               WHERE aps01 = l_oldno
        #FUN-C30027---end
    END IF
    CALL i202_show()
END FUNCTION
 
FUNCTION i202_out()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
        l_aps   RECORD LIKE aps_file.*,
        l_gem02 LIKE gem_file.gem02,
        l_apr02 LIKE apr_file.apr02,
        l_za05          LIKE type_file.chr1000,               #  #No.FUN-690028 VARCHAR(40)
        l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
#No.FUN-770012 -- begin --
    DEFINE l_aag02 RECORD
                   aag02_11   LIKE aag_file.aag02,
                   aag02_12   LIKE aag_file.aag02,
                   aag02_13   LIKE aag_file.aag02,
                   aag02_14   LIKE aag_file.aag02,
                   aag02_40   LIKE aag_file.aag02,
                   aag02_41   LIKE aag_file.aag02,
                   aag02_42   LIKE aag_file.aag02,
                   aag02_43   LIKE aag_file.aag02,
                   aag02_44   LIKE aag_file.aag02,
                   aag02_45   LIKE aag_file.aag02,
                   aag02_46   LIKE aag_file.aag02,
                   aag02_57   LIKE aag_file.aag02,
                   aag02_21   LIKE aag_file.aag02,
                   aag02_22   LIKE aag_file.aag02,
                   aag02_23   LIKE aag_file.aag02,
                   aag02_231  LIKE aag_file.aag02,
                   aag02_232  LIKE aag_file.aag02,
                   aag02_233  LIKE aag_file.aag02,
                   aag02_234  LIKE aag_file.aag02,
                   aag02_24   LIKE aag_file.aag02,
                   aag02_25   LIKE aag_file.aag02,
                   aag02_56   LIKE aag_file.aag02,
                   aag02_47   LIKE aag_file.aag02,
                   aag02_58   LIKE aag_file.aag02,
                   aag02_111  LIKE aag_file.aag02,
                   aag02_121   LIKE aag_file.aag02,
                   aag02_131   LIKE aag_file.aag02,
                   aag02_141   LIKE aag_file.aag02,
                   aag02_401   LIKE aag_file.aag02,
                   aag02_411   LIKE aag_file.aag02,
                   aag02_421   LIKE aag_file.aag02,
                   aag02_431   LIKE aag_file.aag02,
                   aag02_441   LIKE aag_file.aag02,
                   aag02_451   LIKE aag_file.aag02,
                   aag02_461   LIKE aag_file.aag02,
                   aag02_571   LIKE aag_file.aag02,
                   aag02_211   LIKE aag_file.aag02,
                   aag02_221   LIKE aag_file.aag02,
                   aag02_235   LIKE aag_file.aag02,
                   aag02_236   LIKE aag_file.aag02,
                   aag02_237   LIKE aag_file.aag02,
                   aag02_238   LIKE aag_file.aag02,
                   aag02_239   LIKE aag_file.aag02,
                   aag02_241   LIKE aag_file.aag02,
                   aag02_251   LIKE aag_file.aag02,
                   aag02_561   LIKE aag_file.aag02,
                   aag02_471   LIKE aag_file.aag02,
                   aag02_581   LIKE aag_file.aag02
                   END RECORD
    DEFINE l_str   STRING
#No.FUN-770012 -- end --
 
    IF g_wc IS NULL THEN
#       CALL cl_err('',-400,0)
        CALL cl_err('','9057',0)
        RETURN
    END IF
    CALL cl_wait()
#   LET l_name = 'aapi202.out'
#No.FUN-770012 -- begin --
#    CALL cl_outnam('aapi202') RETURNING l_name
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'aapi202'
#    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80 END IF
#    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    CALL cl_del_data(l_table)     #No.FUN-770012
    LET g_sql1 = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                 " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                 "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?)"   #FUN-CB0056 add-2? 
    PREPARE insert_prep FROM g_sql1
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1)
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time   #NO:FUN-B30211
       EXIT PROGRAM
    END IF
#No.FUN-770012 -- end --
    LET g_sql="SELECT aps_file.*,gem02",   # 組合出 SQL 指令
              " FROM aps_file LEFT OUTER JOIN gem_file ON aps_file.aps01 = gem_file.gem01 AND gem_file.gemacti = 'Y'",
              " WHERE ",g_wc CLIPPED
 
    IF g_apz.apz13 = 'N' THEN
       LET g_sql= g_sql CLIPPED," AND aps01 = ' '"
    ELSE
       LET g_sql= g_sql CLIPPED," AND aps01 != ' '"
    END IF
 
    PREPARE i202_p1 FROM g_sql              # RUNTIME 編譯
    DECLARE i202_co CURSOR FOR i202_p1
#    #FUN-680029   --Begin--
#    IF g_aza.aza63= 'Y' THEN
#       LET g_zaa[44].zaa06 = 'N'
#       LET g_zaa[45].zaa06 = 'N'
#       LET g_zaa[46].zaa06 = 'N'
#       LET g_zaa[47].zaa06 = 'N'
#       LET g_zaa[48].zaa06 = 'N'
#       LET g_zaa[49].zaa06 = 'N'
#       LET g_zaa[50].zaa06 = 'N'
#       LET g_zaa[51].zaa06 = 'N'
#       LET g_zaa[52].zaa06 = 'N'
#       LET g_zaa[53].zaa06 = 'N'
#       LET g_zaa[54].zaa06 = 'N'
#       LET g_zaa[55].zaa06 = 'N'
#       LET g_zaa[56].zaa06 = 'N'
#       LET g_zaa[57].zaa06 = 'N'
#       LET g_zaa[58].zaa06 = 'N'
#       LET g_zaa[59].zaa06 = 'N'
#       LET g_zaa[60].zaa06 = 'N'
#       LET g_zaa[61].zaa06 = 'N'
#       LET g_zaa[62].zaa06 = 'N'
#       LET g_zaa[63].zaa06 = 'N'
#    ELSE
#       LET g_zaa[44].zaa06 = 'Y'
#       LET g_zaa[45].zaa06 = 'Y'
#       LET g_zaa[46].zaa06 = 'Y'
#       LET g_zaa[47].zaa06 = 'Y'
#       LET g_zaa[48].zaa06 = 'Y'
#       LET g_zaa[49].zaa06 = 'Y'
#       LET g_zaa[50].zaa06 = 'Y'
#       LET g_zaa[51].zaa06 = 'Y'
#       LET g_zaa[52].zaa06 = 'Y'
#       LET g_zaa[53].zaa06 = 'Y'
#       LET g_zaa[54].zaa06 = 'Y'
#       LET g_zaa[55].zaa06 = 'Y'
#       LET g_zaa[56].zaa06 = 'Y'
#       LET g_zaa[57].zaa06 = 'Y'
#       LET g_zaa[58].zaa06 = 'Y'
#       LET g_zaa[59].zaa06 = 'Y'
#       LET g_zaa[60].zaa06 = 'Y'
#       LET g_zaa[61].zaa06 = 'Y'
#       LET g_zaa[62].zaa06 = 'Y'
#       LET g_zaa[63].zaa06 = 'Y'
#    #FUN-680029   --End--
 
#    START REPORT i202_rep TO l_name    #No.FUN-770012
    FOREACH i202_co INTO l_aps.*,l_gem02
        IF SQLCA.sqlcode THEN
           CALL cl_err('Foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
#No.FUN-770012 -- begin --
#        OUTPUT TO REPORT i202_rep(l_aps.*,l_gem02)
        INITIALIZE l_aag02.* TO NULL
        CALL s_aapact('2',g_aza.aza81,l_aps.aps11) RETURNING l_aag02.aag02_11
        CALL s_aapact('2',g_aza.aza81,l_aps.aps12) RETURNING l_aag02.aag02_12
        CALL s_aapact('2',g_aza.aza81,l_aps.aps13) RETURNING l_aag02.aag02_13
        CALL s_aapact('2',g_aza.aza81,l_aps.aps14) RETURNING l_aag02.aag02_14
        CALL s_aapact('2',g_aza.aza81,l_aps.aps40) RETURNING l_aag02.aag02_40
        CALL s_aapact('2',g_aza.aza81,l_aps.aps41) RETURNING l_aag02.aag02_41
        CALL s_aapact('2',g_aza.aza81,l_aps.aps42) RETURNING l_aag02.aag02_42
        CALL s_aapact('2',g_aza.aza81,l_aps.aps43) RETURNING l_aag02.aag02_43
        CALL s_aapact('2',g_aza.aza81,l_aps.aps44) RETURNING l_aag02.aag02_44
        CALL s_aapact('2',g_aza.aza81,l_aps.aps45) RETURNING l_aag02.aag02_45
        CALL s_aapact('2',g_aza.aza81,l_aps.aps46) RETURNING l_aag02.aag02_46
        CALL s_aapact('2',g_aza.aza81,l_aps.aps57) RETURNING l_aag02.aag02_57
        CALL s_aapact('2',g_aza.aza81,l_aps.aps21) RETURNING l_aag02.aag02_21
        CALL s_aapact('2',g_aza.aza81,l_aps.aps22) RETURNING l_aag02.aag02_22
        CALL s_aapact('2',g_aza.aza81,l_aps.aps23) RETURNING l_aag02.aag02_23
        CALL s_aapact('2',g_aza.aza81,l_aps.aps231) RETURNING l_aag02.aag02_231
        CALL s_aapact('2',g_aza.aza81,l_aps.aps232) RETURNING l_aag02.aag02_231
        CALL s_aapact('2',g_aza.aza81,l_aps.aps233) RETURNING l_aag02.aag02_233
        CALL s_aapact('2',g_aza.aza81,l_aps.aps234) RETURNING l_aag02.aag02_234
        CALL s_aapact('2',g_aza.aza81,l_aps.aps24) RETURNING l_aag02.aag02_24
        CALL s_aapact('2',g_aza.aza81,l_aps.aps25) RETURNING l_aag02.aag02_25
        CALL s_aapact('2',g_aza.aza81,l_aps.aps56) RETURNING l_aag02.aag02_56
        CALL s_aapact('2',g_aza.aza81,l_aps.aps47) RETURNING l_aag02.aag02_47
        CALL s_aapact('2',g_aza.aza81,l_aps.aps58) RETURNING l_aag02.aag02_58
        CALL s_aapact('2',g_aza.aza81,l_aps.aps111) RETURNING l_aag02.aag02_111
        CALL s_aapact('2',g_aza.aza81,l_aps.aps121) RETURNING l_aag02.aag02_121
        CALL s_aapact('2',g_aza.aza81,l_aps.aps131) RETURNING l_aag02.aag02_131
        CALL s_aapact('2',g_aza.aza81,l_aps.aps141) RETURNING l_aag02.aag02_141
        CALL s_aapact('2',g_aza.aza81,l_aps.aps401) RETURNING l_aag02.aag02_401
        CALL s_aapact('2',g_aza.aza81,l_aps.aps411) RETURNING l_aag02.aag02_411
        CALL s_aapact('2',g_aza.aza81,l_aps.aps421) RETURNING l_aag02.aag02_421
        CALL s_aapact('2',g_aza.aza81,l_aps.aps431) RETURNING l_aag02.aag02_431
        CALL s_aapact('2',g_aza.aza81,l_aps.aps441) RETURNING l_aag02.aag02_441
        CALL s_aapact('2',g_aza.aza81,l_aps.aps451) RETURNING l_aag02.aag02_451
        CALL s_aapact('2',g_aza.aza81,l_aps.aps461) RETURNING l_aag02.aag02_461
        CALL s_aapact('2',g_aza.aza81,l_aps.aps571) RETURNING l_aag02.aag02_571
        CALL s_aapact('2',g_aza.aza81,l_aps.aps211) RETURNING l_aag02.aag02_211
        CALL s_aapact('2',g_aza.aza81,l_aps.aps221) RETURNING l_aag02.aag02_221
        CALL s_aapact('2',g_aza.aza81,l_aps.aps235) RETURNING l_aag02.aag02_235
        CALL s_aapact('2',g_aza.aza81,l_aps.aps236) RETURNING l_aag02.aag02_236
        CALL s_aapact('2',g_aza.aza81,l_aps.aps237) RETURNING l_aag02.aag02_237
        CALL s_aapact('2',g_aza.aza81,l_aps.aps238) RETURNING l_aag02.aag02_238
        CALL s_aapact('2',g_aza.aza81,l_aps.aps239) RETURNING l_aag02.aag02_239
        CALL s_aapact('2',g_aza.aza81,l_aps.aps241) RETURNING l_aag02.aag02_241
        CALL s_aapact('2',g_aza.aza81,l_aps.aps251) RETURNING l_aag02.aag02_251
        CALL s_aapact('2',g_aza.aza81,l_aps.aps561) RETURNING l_aag02.aag02_561
        CALL s_aapact('2',g_aza.aza81,l_aps.aps471) RETURNING l_aag02.aag02_471
        CALL s_aapact('2',g_aza.aza81,l_aps.aps581) RETURNING l_aag02.aag02_581
 
        EXECUTE insert_prep USING l_aps.aps01,l_gem02,l_aps.aps11,l_aps.aps12,l_aps.aps13,l_aps.aps14,
                                  l_aps.aps40,l_aps.aps41,l_aps.aps42,l_aps.aps43,l_aps.aps44,
                                  l_aps.aps45,l_aps.aps46,l_aps.aps57,l_aps.aps21,l_aps.aps22,
                                  l_aps.aps23,l_aps.aps231,l_aps.aps232,l_aps.aps233,l_aps.aps234,
                                  l_aps.aps24,l_aps.aps25,l_aps.aps56,l_aps.aps47,l_aps.aps58,
                                  l_aps.aps111,l_aps.aps121,l_aps.aps131,l_aps.aps141,l_aps.aps401,
                                  l_aps.aps411,l_aps.aps421,l_aps.aps431,l_aps.aps441,l_aps.aps451,
                                  l_aps.aps461,l_aps.aps571,l_aps.aps211,l_aps.aps221,l_aps.aps235,
                                  l_aps.aps236,l_aps.aps237,l_aps.aps238,l_aps.aps239,l_aps.aps241,
                                  l_aps.aps251,l_aps.aps561,l_aps.aps471,l_aps.aps581,l_aag02.*,       
                                  l_aps.apsacti
        IF STATUS THEN
           CALL cl_err("execute insert_prep:",STATUS,1)
           EXIT FOREACH
        END IF
#No.FUN-770012 -- end --
    END FOREACH
 
#    FINISH REPORT i202_rep  #No.FUN-770012
 
    CLOSE i202_co
    ERROR ""
#No.FUN-770012 -- begin --
#    CALL cl_prt(l_name,' ','1',g_len)
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     LET l_str = "aps01,aps11,aps12,aps13,aps14,aps40,aps41,aps42,aps43,aps44,aps45,",
                 "aps46,aps57,aps21,aps22,aps23,aps231,aps232,aps233,aps234,aps24,",
                 "aps25,aps56,aps47,aps58,aps111,aps121,aps131,aps141,aps401,aps411,",          
                 "aps421,aps431,aps441,aps451,aps461,aps571,aps211,aps221,aps235,",
                 "aps236,aps237,aps238,aps239,aps241,aps251,aps561,aps471,aps581"             
     CALL cl_wcchp(g_wc,l_str) RETURNING g_wc
     LET g_str = g_wc,";",g_zz05,";",g_aza.aza63
     LET g_sql1 = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     CALL cl_prt_cs3('aapi202','aapi202',g_sql1,g_str)
#No.FUN-770012 -- end --
END FUNCTION
 
REPORT i202_rep(sr,l_gem02)
   DEFINE
        l_trailer_sw    LIKE type_file.chr1,    #No.FUN-690028 VARCHAR(1)
        sr RECORD LIKE aps_file.*,
        l_gem02 LIKE gem_file.gem02,
        l_aag02 LIKE aag_file.aag02,    #No:8147
        l_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   OUTPUT
       TOP MARGIN g_top_margin
       LEFT MARGIN g_left_margin
       BOTTOM MARGIN g_bottom_margin
       PAGE LENGTH g_page_line
 
    ORDER BY sr.aps01
 
    FORMAT
        PAGE HEADER
            PRINT (g_len-FGL_WIDTH(g_company CLIPPED))/2 SPACES,g_company CLIPPED
#           PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED #No.TQC-770051 mark
            PRINT #No.TQC-770051
            PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1]
#           PRINT ' '    #No.TQC-770051 mark
            PRINT g_x[2] CLIPPED,g_today,' ',TIME,
                 COLUMN (g_len-FGL_WIDTH(g_user)-16),'FROM:',g_user CLIPPED, #No.TQC-770051
                 COLUMN g_len-10,g_x[3] CLIPPED,PAGENO USING '<<<'
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'y'
 
        BEFORE GROUP OF sr.aps01
            IF sr.apsacti = 'N' THEN PRINT '*'; END IF
            PRINT COLUMN 3,g_x[11] CLIPPED,COLUMN 12,sr.aps01,' ',l_gem02
 
        ON EVERY ROW
            LET l_aag02 = ' '
{現金}   #  CALL s_aapact('2',sr.aps11) RETURNING l_aag02
{現金}      CALL s_aapact('2',g_aza.aza81,sr.aps11) RETURNING l_aag02            #No.FUN-730064
 
            PRINT COLUMN 7,g_x[12] CLIPPED,
                  COLUMN 28,sr.aps11 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{預付貨款}# CALL s_aapact('2',sr.aps12) RETURNING l_aag02
{預付貨款}  CALL s_aapact('2',g_aza.aza81,sr.aps12) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[13] CLIPPED,
                  COLUMN 28,sr.aps12 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{暫付}    # CALL s_aapact('2',sr.aps13) RETURNING l_aag02
{暫付}      CALL s_aapact('2',g_aza.aza81,sr.aps13) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[14] CLIPPED,
                  COLUMN 28,sr.aps13 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{預付購料}# CALL s_aapact('2',sr.aps14) RETURNING l_aag02
{預付購料}  CALL s_aapact('2',g_aza.aza81,sr.aps14) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[15] CLIPPED,
                  COLUMN 28,sr.aps14 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{進貨折讓}# CALL s_aapact('2',sr.aps41) RETURNING l_aag02
{進貨折讓}  CALL s_aapact('2',g_aza.aza81,sr.aps41) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[25] CLIPPED,
                  COLUMN 28,sr.aps41 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{匯兌損失}# CALL s_aapact('2',sr.aps42) RETURNING l_aag02
{匯兌損失}  CALL s_aapact('2',g_aza.aza81,sr.aps42) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[26] CLIPPED,
                  COLUMN 28,sr.aps42 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{匯兌收益}# CALL s_aapact('2',sr.aps43) RETURNING l_aag02
{匯兌收益}  CALL s_aapact('2',g_aza.aza81,sr.aps43) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[27] CLIPPED,
                  COLUMN 28,sr.aps43 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{價格差異}# CALL s_aapact('2',sr.aps44) RETURNING l_aag02
{價格差異}  CALL s_aapact('2',g_aza.aza81,sr.aps44) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[29] CLIPPED,
                  COLUMN 28,sr.aps44 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{存貨}    # CALL s_aapact('2',sr.aps45) RETURNING l_aag02
{存貨}      CALL s_aapact('2',g_aza.aza81,sr.aps45) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[31] CLIPPED,
                  COLUMN 28,sr.aps45 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
          # CALL s_aapact('2',sr.aps21) RETURNING l_aag02
            CALL s_aapact('2',g_aza.aza81,sr.aps21) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[16] CLIPPED,
                  COLUMN 28,sr.aps21 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付帳款}# CALL s_aapact('2',sr.aps22) RETURNING l_aag02
{應付帳款}  CALL s_aapact('2',g_aza.aza81,sr.aps22) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[17] CLIPPED,
                  COLUMN 28,sr.aps22 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付費用}# CALL s_aapact('2',sr.aps23) RETURNING l_aag02
{應付費用}  CALL s_aapact('2',g_aza.aza81,sr.aps23) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[18] CLIPPED,
                  COLUMN 28,sr.aps23 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付保費}# CALL s_aapact('2',sr.aps231) RETURNING l_aag02
{應付保費}  CALL s_aapact('2',g_aza.aza81,sr.aps231) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[19] CLIPPED,
                  COLUMN 28,sr.aps231 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付報關}# CALL s_aapact('2',sr.aps232) RETURNING l_aag02
{應付報關}  CALL s_aapact('2',g_aza.aza81,sr.aps232) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[20] CLIPPED,
                  COLUMN 28,sr.aps232 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{代付費用}# CALL s_aapact('2',sr.aps233) RETURNING l_aag02
{代付費用}  CALL s_aapact('2',g_aza.aza81,sr.aps233) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[21] CLIPPED,
                  COLUMN 28,sr.aps233 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{在途存貨}# CALL s_aapact('2',sr.aps234) RETURNING l_aag02
{在途存貨}  CALL s_aapact('2',g_aza.aza81,sr.aps234) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[22] CLIPPED,
                  COLUMN 28,sr.aps234 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付票據}# CALL s_aapact('2',sr.aps24) RETURNING l_aag02
{應付票據}  CALL s_aapact('2',g_aza.aza81,sr.aps24) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[23] CLIPPED,
                  COLUMN 28,sr.aps24 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{短期借款}# CALL s_aapact('2',sr.aps25) RETURNING l_aag02
{短期借款}  CALL s_aapact('2',g_aza.aza81,sr.aps25) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[24] CLIPPED,
                  COLUMN 28,sr.aps25 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{代付匯票}# CALL s_aapact('2',sr.aps56) RETURNING l_aag02
{代付匯票}  CALL s_aapact('2',g_aza.aza81,sr.aps56) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[32] CLIPPED,
                  COLUMN 28,sr.aps56 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{郵資}    # CALL s_aapact('2',sr.aps47) RETURNING l_aag02
{郵資}      CALL s_aapact('2',g_aza.aza81,sr.aps47) RETURNING l_aag02            #No.FUN-730064
            PRINT COLUMN 7,g_x[30] CLIPPED,
                  COLUMN 28,sr.aps47 CLIPPED,COLUMN 53,l_aag02 CLIPPED
#FUN-680029   --Begin--
         IF g_aza.aza63='Y' THEN
            LET l_aag02 = ' '
{現金}    # CALL s_aapact('2',sr.aps111) RETURNING l_aag02
{現金}      CALL s_aapact('2',g_aza.aza82,sr.aps111) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[44] CLIPPED,
                  COLUMN 28,sr.aps111 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{預付貨款}# CALL s_aapact('2',sr.aps121) RETURNING l_aag02
{預付貨款}  CALL s_aapact('2',g_aza.aza82,sr.aps121) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[45] CLIPPED,
                  COLUMN 28,sr.aps121 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{暫付}    # CALL s_aapact('2',sr.aps131) RETURNING l_aag02
{暫付}      CALL s_aapact('2',g_aza.aza82,sr.aps131) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[46] CLIPPED,
                  COLUMN 28,sr.aps131 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{預付購料}# CALL s_aapact('2',sr.aps141) RETURNING l_aag02
{預付購料}  CALL s_aapact('2',g_aza.aza82,sr.aps141) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[47] CLIPPED,
                  COLUMN 28,sr.aps141 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{進貨折讓}# CALL s_aapact('2',sr.aps411) RETURNING l_aag02
{進貨折讓}  CALL s_aapact('2',g_aza.aza82,sr.aps411) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[48] CLIPPED,
                  COLUMN 28,sr.aps411 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{匯兌損失}# CALL s_aapact('2',sr.aps421) RETURNING l_aag02
{匯兌損失}  CALL s_aapact('2',g_aza.aza82,sr.aps421) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[49] CLIPPED,
                  COLUMN 28,sr.aps421 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{匯兌收益}# CALL s_aapact('2',sr.aps431) RETURNING l_aag02
{匯兌收益}  CALL s_aapact('2',g_aza.aza82,sr.aps431) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[50] CLIPPED,
                  COLUMN 28,sr.aps431 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{價格差異}# CALL s_aapact('2',sr.aps441) RETURNING l_aag02
{價格差異}  CALL s_aapact('2',g_aza.aza82,sr.aps441) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[51] CLIPPED,
                  COLUMN 28,sr.aps441 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{存貨}    # CALL s_aapact('2',sr.aps451) RETURNING l_aag02
{存貨}      CALL s_aapact('2',g_aza.aza82,sr.aps451) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[52] CLIPPED,
                  COLUMN 28,sr.aps451 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
          # CALL s_aapact('2',sr.aps211) RETURNING l_aag02
            CALL s_aapact('2',g_aza.aza82,sr.aps211) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[53] CLIPPED,
                  COLUMN 28,sr.aps21 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付帳款}# CALL s_aapact('2',sr.aps221) RETURNING l_aag02
{應付帳款}  CALL s_aapact('2',g_aza.aza82,sr.aps221) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[54] CLIPPED,
                  COLUMN 28,sr.aps221 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付費用}# CALL s_aapact('2',sr.aps231) RETURNING l_aag02
{應付費用}  CALL s_aapact('2',g_aza.aza82,sr.aps231) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[55] CLIPPED,
                  COLUMN 28,sr.aps231 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付保費}# CALL s_aapact('2',sr.aps236) RETURNING l_aag02
{應付保費}  CALL s_aapact('2',g_aza.aza82,sr.aps236) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[56] CLIPPED,
                  COLUMN 28,sr.aps236 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付報關}# CALL s_aapact('2',sr.aps237) RETURNING l_aag02
{應付報關}  CALL s_aapact('2',g_aza.aza82,sr.aps237) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[57] CLIPPED,
                  COLUMN 28,sr.aps237 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{代付費用}# CALL s_aapact('2',sr.aps238) RETURNING l_aag02
{代付費用}  CALL s_aapact('2',g_aza.aza82,sr.aps238) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[58] CLIPPED,
                  COLUMN 28,sr.aps238 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{在途存貨}# CALL s_aapact('2',sr.aps239) RETURNING l_aag02
{在途存貨}  CALL s_aapact('2',g_aza.aza82,sr.aps239) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[59] CLIPPED,
                  COLUMN 28,sr.aps239 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{應付票據}# CALL s_aapact('2',sr.aps241) RETURNING l_aag02
{應付票據}  CALL s_aapact('2',g_aza.aza82,sr.aps241) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[60] CLIPPED,
                  COLUMN 28,sr.aps241 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{短期借款}# CALL s_aapact('2',sr.aps251) RETURNING l_aag02
{短期借款}  CALL s_aapact('2',g_aza.aza82,sr.aps251) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[61] CLIPPED,
                  COLUMN 28,sr.aps251 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{代付匯票}# CALL s_aapact('2',sr.aps561) RETURNING l_aag02
{代付匯票}  CALL s_aapact('2',g_aza.aza82,sr.aps561) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[62] CLIPPED,
                  COLUMN 28,sr.aps561 CLIPPED,COLUMN 53,l_aag02 CLIPPED
            LET l_aag02 = ' '
{郵資}    # CALL s_aapact('2',sr.aps471) RETURNING l_aag02
{郵資}      CALL s_aapact('2',g_aza.aza82,sr.aps471) RETURNING l_aag02           #No.FUN-730064
            PRINT COLUMN 7,g_x[63] CLIPPED,
                  COLUMN 28,sr.aps471 CLIPPED,COLUMN 53,l_aag02 CLIPPED
         END IF
#FUN-680029  --End--
 
        AFTER GROUP OF sr.aps01
            SKIP 1 LINE
 
        ON LAST ROW
            IF g_zz05 = 'Y' THEN     # 80:70,140,210      132:120,240
               CALL cl_wcchp(g_wc,'aps01,aps11,aps21,aps41')
                    RETURNING g_sql
               PRINT g_dash[1,g_len]
               #TQC-630166
               #IF g_sql[001,080] > ' ' THEN
               #        PRINT g_x[8] CLIPPED,g_sql[001,070] CLIPPED END IF
               #IF g_sql[071,140] > ' ' THEN
               #        PRINT COLUMN 10,     g_sql[071,140] CLIPPED END IF
               #IF g_sql[141,210] > ' ' THEN
               #        PRINT COLUMN 10,     g_sql[141,210] CLIPPED END IF
                CALL cl_prt_pos_wc(g_sql)
               #END TQC-630166
            END IF
            PRINT g_dash[1,g_len]
            LET l_trailer_sw = 'n'
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
        PAGE TRAILER
            IF l_trailer_sw = 'y' THEN
                PRINT g_dash[1,g_len]
                PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
            ELSE
                SKIP 2 LINE
            END IF
END REPORT
 
#Patch....NO.TQC-610035 <001> #


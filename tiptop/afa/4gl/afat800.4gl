# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat800.4gl
# Descriptions...: 資產免稅申請作業
# Date & Author..: 96/05/24  BY Star
# Modify.........: No:8141 03/09/08 By Wiky fci07/fci071 oracle中不可給 '         '
# Modify.........: No:8345 03/09/25 By Apple t800_fci07整段不要
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-4A0021 04/10/04 By Kitty  輸完財編無帶出相關資料
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/02 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0059 04/12/10 By Smapmin 加入權限控管
# Modify.........: No.MOD-510160 05/01/28 By Kitty 語言別無作用
# Modify.........: No.FUN-540057 05/05/09 By ice 發票號碼加大到16位
# Modify.........: NO.FUN-550034 05/05/20 By jackie 單據編號加大
# Modify.........: No.FUN-560146 05/06/21 By Nicola 不需套用單據編號規則
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/12 By jamie FUNCTION t800_q() 一開始應清空g_fch.*的值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-750075 07/05/16 By Smapmin 若附號欄位為NULL,則設為' '
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-770093 07/07/18 By wujie   已審核的資料刪除時應報錯提示
# Modify.........: No.TQC-770108 07/07/24 By Rayven 單身"廠商""單位"欄位應可開窗
# Modify.........: No.MOD-7C0204 07/12/27 By Smapmin 輸入完附號後,未正確default出後續欄位
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.FUN-850068 08/05/14 By TSD.hoho 自定欄位功能修改
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-940087 09/04/11 By Sarah 輸入單身時需檢查財產+附號不可存在fcc_file
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980109 09/08/20 By mike function  t800_putb() 中的 INSERT 有問題  
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-B30136 11/03/11 By Sarah 1.單身由財產編號帶出的相關欄位請改為Noentry
#                                                  2.要以財編+附號來考慮資產是否免稅
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/14 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.MOD-C70265 12/07/27 By Polly 資產不存在時,將 afa-093 改用訊息 afa-134
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/07 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fch           RECORD LIKE fch_file.*,       #投資抵減單 (假單頭)
    g_fch_t         RECORD LIKE fch_file.*,       #投資抵減單 (舊值)
    g_fch_o         RECORD LIKE fch_file.*,       #投資抵減單 (舊值)
    g_fch01_t       LIKE fch_file.fch01,          #投資抵減單 (舊值)
    g_fch03_t       LIKE fch_file.fch03,
    g_fci04_t       LIKE fci_file.fci04,
    g_fci05_t       LIKE fci_file.fci05,
    g_feature       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
    g_fci           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fci02       LIKE fci_file.fci02,   #項次
        fci03       LIKE fci_file.fci03,   #財產編號
        fci031      LIKE fci_file.fci031,  #附號
        fci04       LIKE fci_file.fci04,   #中文名稱
        fci05       LIKE fci_file.fci05,   #英文名稱
        fci06       LIKE fci_file.fci06,   #規格型號
        fci07       LIKE fci_file.fci07,   #合併編號
        fci071      LIKE fci_file.fci071,  #附號
        fci08       LIKE fci_file.fci08,   #廠商
        fci09       LIKE fci_file.fci09,   #數量
        fci10       LIKE fci_file.fci10,   #數量
        fci11       LIKE fci_file.fci11,   #發票號碼
        fci12       LIKE fci_file.fci12,   #進口編號
        fci13       LIKE fci_file.fci13,   #採購單號
        fci14       LIKE fci_file.fci14,   #進口報單
        fci15       LIKE fci_file.fci15,   #成本
        fci16       LIKE fci_file.fci16,   #用途
        fci17       LIKE fci_file.fci17,   #購進日期
        fci18       LIKE fci_file.fci18,   #類別
        fci19       LIKE fci_file.fci19,   #核准狀態
        #FUN-850068 --start---
        fciud01     LIKE fci_file.fciud01,
        fciud02     LIKE fci_file.fciud02,
        fciud03     LIKE fci_file.fciud03,
        fciud04     LIKE fci_file.fciud04,
        fciud05     LIKE fci_file.fciud05,
        fciud06     LIKE fci_file.fciud06,
        fciud07     LIKE fci_file.fciud07,
        fciud08     LIKE fci_file.fciud08,
        fciud09     LIKE fci_file.fciud09,
        fciud10     LIKE fci_file.fciud10,
        fciud11     LIKE fci_file.fciud11,
        fciud12     LIKE fci_file.fciud12,
        fciud13     LIKE fci_file.fciud13,
        fciud14     LIKE fci_file.fciud14,
        fciud15     LIKE fci_file.fciud15
        #FUN-850068 --end--
                    END RECORD,
    g_fci_t         RECORD                 #程式變數 (舊值)
        fci02       LIKE fci_file.fci02,   #項次
        fci03       LIKE fci_file.fci03,   #財產編號
        fci031      LIKE fci_file.fci031,  #附號
        fci04       LIKE fci_file.fci04,   #中文名稱
        fci05       LIKE fci_file.fci05,   #英文名稱
        fci06       LIKE fci_file.fci06,   #規格型號
        fci07       LIKE fci_file.fci07,   #合併編號
        fci071      LIKE fci_file.fci071,  #附號
        fci08       LIKE fci_file.fci08,   #廠商
        fci09       LIKE fci_file.fci09,   #數量
        fci10       LIKE fci_file.fci10,   #數量
        fci11       LIKE fci_file.fci11,   #發票號碼
        fci12       LIKE fci_file.fci12,   #進口編號
        fci13       LIKE fci_file.fci13,   #採購單號
        fci14       LIKE fci_file.fci14,   #進口報單
        fci15       LIKE fci_file.fci15,   #成本
        fci16       LIKE fci_file.fci16,   #用途
        fci17       LIKE fci_file.fci17,   #購進日期
        fci18       LIKE fci_file.fci18,   #類別
        fci19       LIKE fci_file.fci19,   #核准狀態
        #FUN-850068 --start---
        fciud01     LIKE fci_file.fciud01,
        fciud02     LIKE fci_file.fciud02,
        fciud03     LIKE fci_file.fciud03,
        fciud04     LIKE fci_file.fciud04,
        fciud05     LIKE fci_file.fciud05,
        fciud06     LIKE fci_file.fciud06,
        fciud07     LIKE fci_file.fciud07,
        fciud08     LIKE fci_file.fciud08,
        fciud09     LIKE fci_file.fciud09,
        fciud10     LIKE fci_file.fciud10,
        fciud11     LIKE fci_file.fciud11,
        fciud12     LIKE fci_file.fciud12,
        fciud13     LIKE fci_file.fciud13,
        fciud14     LIKE fci_file.fciud14,
        fciud15     LIKE fci_file.fciud15
        #FUN-850068 --end--
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    g_faj17_faj58   LIKE faj_file.faj17,
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
    l_faj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fajyn       LIKE type_file.chr1,                 #是否要投入 fci_file       #No.FUN-680070 VARCHAR(1)
        faj02       LIKE faj_file.faj02,   #財產編號
        faj022      LIKE faj_file.faj022,  #附號
        faj26       LIKE faj_file.faj26,   #入帳日期
        faj51       LIKE faj_file.faj51,   #發票號碼
        faj17       LIKE faj_file.faj17,   #數量
        faj18       LIKE faj_file.faj18,   #單位
        faj14       LIKE faj_file.faj14,   #成本
        faj06       LIKE faj_file.faj06,   #中文名稱
        faj07       LIKE faj_file.faj07    #英文名稱
                    END RECORD,
    l_faj_t         RECORD                 #程式變數(Program Variables)
        fajyn       LIKE type_file.chr1,                 #是否要投入 fci_file       #No.FUN-680070 VARCHAR(1)
        faj02       LIKE faj_file.faj02,   #財產編號
        faj022      LIKE faj_file.faj022,  #附號
        faj26       LIKE faj_file.faj26,   #入帳日期
        faj51       LIKE faj_file.faj51,   #發票號碼
        faj17       LIKE faj_file.faj17,   #數量
        faj18       LIKE faj_file.faj18,   #單位
        faj14       LIKE faj_file.faj14,   #成本
        faj06       LIKE faj_file.faj06,   #中文名稱
        faj07       LIKE faj_file.faj07    #英文名稱
                    END RECORD
 
   DEFINE   l_priv2         LIKE zy_file.zy04      #使用者資料權限
   DEFINE   l_priv3         LIKE zy_file.zy05      #使用部門資料權限
   DEFINE   g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
   DEFINE   g_before_input_done   LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
   DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE   mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
 
#主程式開始
MAIN
#   DEFINE l_time        LIKE type_file.chr8                    #計算被使用時間       #No.FUN-680070 VARCHAR(8)#NO.FUN-6A0069
   DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                                           #NO.FUN-6A0069
 
    LET g_forupd_sql = " SELECT * FROM fch_file WHERE fch01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t800_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 5
    OPEN WINDOW t800_w AT p_row,p_col              #顯示畫面
        WITH FORM "afa/42f/afat800"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()

    CALL cl_set_comp_entry("fci04,fci05,fci06,fci08,fci09,fci10,fci11,fci12,fci13,fci14,fci15,fci16,fci17,fci18,fci19",FALSE)  #MOD-B30136 add

    CALL t800_menu()
    CLOSE WINDOW t800_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0069
        RETURNING g_time                #NO.FUN-6A0069
END MAIN
 
#QBE 查詢資料
FUNCTION t800_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_fci.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fch.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        fch01,fch02,fch03,fch04,fch05,fch06,fch07,fch08,fchconf,
        fchuser,fchgrup,fchmodu,fchdate,fch09,
        #FUN-850068   ---start---
        fchud01,fchud02,fchud03,fchud04,fchud05,
        fchud06,fchud07,fchud08,fchud09,fchud10,
        fchud11,fchud12,fchud13,fchud14,fchud15
        #FUN-850068    ----end----
 
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
  END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                           #只能使用自己的資料
    #        LET g_wc = g_wc clipped," AND fchuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                           #只能使用相同群的資料
    #        LET g_wc = g_wc clipped," AND fchgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_wc = g_wc clipped," AND fchgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fchuser', 'fchgrup')
    #End:FUN-980030
 
    # 螢幕上取單身條件
    CONSTRUCT g_wc2 ON fci02,fci03,fci031,fci04,fci05,fci06,fci07,fci071,
                       fci08,fci09,fci10,fci11,fci12,fci13,fci14,fci15,fci16,
                       fci17,fci18,fci19,
                       #No.FUN-850068 --start--
                       fciud01,fciud02,fciud03,fciud04,fciud05,
                       fciud06,fciud07,fciud08,fciud09,fciud10,
                       fciud11,fciud12,fciud13,fciud14,fciud15
                       #No.FUN-850068 ---end---
 
                 FROM  s_fci[1].fci02,s_fci[1].fci03,
                       s_fci[1].fci031,s_fci[1].fci04,
                       s_fci[1].fci05,s_fci[1].fci06,
                       s_fci[1].fci07,s_fci[1].fci071,
                       s_fci[1].fci08,s_fci[1].fci09,
                       s_fci[1].fci10,s_fci[1].fci11,
                       s_fci[1].fci12,s_fci[1].fci13,
                       s_fci[1].fci14,s_fci[1].fci15,
                       s_fci[1].fci16,s_fci[1].fci17,
                       s_fci[1].fci18,s_fci[1].fci19,
                       #No.FUN-850068 --start--
                       s_fci[1].fciud01,s_fci[1].fciud02,s_fci[1].fciud03,
                       s_fci[1].fciud04,s_fci[1].fciud05,s_fci[1].fciud06,
                       s_fci[1].fciud07,s_fci[1].fciud08,s_fci[1].fciud09,
                       s_fci[1].fciud10,s_fci[1].fciud11,s_fci[1].fciud12,
                       s_fci[1].fciud13,s_fci[1].fciud14,s_fci[1].fciud15
                       #No.FUN-850068 ---end---
 
 
		#No.FUN-580031 --start--     HCN
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
		#No.FUN-580031 --end--       HCN
        ON ACTION controlp
           CASE
              WHEN INFIELD(fci03)    #查詢資產資料
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj1"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fci03
                 NEXT FIELD fci03
              #No.TQC-770108 --start--
              WHEN INFIELD(fci08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_pmc1"
                 LET g_qryparam.state    = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fci08
                 NEXT FIELD fci08
              WHEN INFIELD(fci10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gfe"
                 LET g_qryparam.state    = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fci10
                 NEXT FIELD fci10
              #No.TQC-770108 --end--
              OTHERWISE
                 EXIT CASE
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
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT fch01 FROM fch_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fch01 ",
                   "  FROM fch_file, fci_file",
                   " WHERE fch01 = fci01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t800_prepare FROM g_sql
    DECLARE t800_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t800_prepare
 
    IF g_wc2 = " 1=1 " THEN                     # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fch_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fch01) FROM fch_file,fci_file WHERE ",
                  "fci01=fch01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t800_prepare1 FROM g_sql
    declare t800_count scroll cursor with hold for t800_prepare1
END FUNCTION
 
FUNCTION t800_menu()
 
   WHILE TRUE
      CALL t800_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t800_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t800_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t800_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t800_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t800_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t800_x()             #FUN-D20035
               CALL t800_x(1)            #FUN-D20035
            END IF

         #FUN-D20035---add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t800_x(2)
            END IF
         #FUN-D20035---add---end
 
         WHEN "batch_generate"
            IF cl_chk_act_auth() THEN
               CALL t800_g(3,5)
               CALL t800_b()    #MOD-B30136 add
            END IF
 
         WHEN "re_sort"
            IF cl_chk_act_auth() THEN
               CALL t800_t()
            END IF
         WHEN "chosen_year"
            IF cl_chk_act_auth() THEN
               CALL t800_s()
            END IF
         WHEN "confirm"
            IF cl_chk_act_auth()
               THEN   CALL t800_sure('Y')
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth()
               THEN CALL t800_sure('N')
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fch.fch01 IS NOT NULL THEN
                  LET g_doc.column1 = "fch01"
                  LET g_doc.value1 = g_fch.fch01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fci),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t800_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fci.clear()
    INITIALIZE g_fch.* TO NULL
    LET g_fch01_t = NULL
    LET g_fch_o.* = g_fch.*
    LET g_fch_t.* = g_fch.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fch.fch02  =g_today
        LET g_fch.fchconf='N'              #確認碼無效
        LET g_fch.fchprsw=0                #列印次數
        LET g_fch.fchuser=g_user
        LET g_fch.fchoriu = g_user #FUN-980030
        LET g_fch.fchorig = g_grup #FUN-980030
        LET g_fch.fchgrup=g_grup
        LET g_fch.fchdate=g_today
        LET g_fch.fchlegal=g_legal         #FUN-980003 add
        CALL t800_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            INITIALIZE g_fch.* TO NULL
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fch.fch01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        INSERT INTO fch_file VALUES (g_fch.*)
        IF SQLCA.sqlcode THEN                           #置入資料庫不成功
#           CALL cl_err(g_fch.fch01,SQLCA.sqlcode,1)   #No.FUN-660136
            CALL cl_err3("ins","fch_file",g_fch.fch01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        LET g_fch_t.* = g_fch.*
        SELECT fch01 INTO g_fch.fch01 FROM fch_file
         WHERE fch01 = g_fch.fch01
       #end MOD-B30136 add
        IF cl_confirm('afa-103') THEN 
           CALL t800_g(3,5)
        END IF 
       #end MOD-B30136 add
       #LET g_rec_b=0   #MOD-B30136 mark
        CALL t800_b()                   #輸入單身
        LET g_fch01_t = g_fch.fch01        #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t800_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fch.fch01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fch.fchconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
 
    SELECT * INTO g_fch.* FROM fch_file WHERE fch01 = g_fch.fch01
    IF g_fch.fchconf = 'Y' THEN RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fch01_t = g_fch.fch01
    LET g_fch_o.* = g_fch.*
    BEGIN WORK
 
    OPEN t800_cl USING g_fch.fch01
    IF STATUS THEN
       CALL cl_err("OPEN t800_cl:", STATUS, 1)
       CLOSE t800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t800_cl INTO g_fch.*              # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t800_cl ROLLBACK WORK RETURN
    END IF
    CALL t800_show()
    WHILE TRUE
        LET g_fch01_t = g_fch.fch01
        LET g_fch.fchmodu=g_user
        LET g_fch.fchdate=g_today
        CALL t800_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_fch.*=g_fch_t.*
           CALL t800_show()
            CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        IF g_fch.fch01 != g_fch01_t THEN            # 更改單號
            UPDATE fci_file SET fci01 = g_fch.fch01
                WHERE fci01 = g_fch01_t
            IF SQLCA.sqlcode THEN
#               CALL cl_err('fci',SQLCA.sqlcode,0)    #No.FUN-660136
                CALL cl_err3("upd","fci_file",g_fch01_t,"",SQLCA.sqlcode,"","fci",1)  #No.FUN-660136
                CONTINUE WHILE
            END IF
        END IF
        UPDATE fch_file SET fch_file.* = g_fch.*
            WHERE fch01 = g_fch.fch01
        IF SQLCA.sqlcode THEN
#           CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)   #No.FUN-660136
            CALL cl_err3("upd","fch_file",g_fch01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t800_cl
    COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t800_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
    l_n1            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
 
    DISPLAY BY NAME g_fch.fch01,g_fch.fch02,g_fch.fch03,g_fch.fch04,
                    g_fch.fch05,g_fch.fch06,g_fch.fch07,g_fch.fch08,
                    g_fch.fch09,
                    g_fch.fchuser,g_fch.fchmodu,g_fch.fchgrup,
                    g_fch.fchdate,g_fch.fchconf,
                    #FUN-850068     ---start---
                    g_fch.fchud01,g_fch.fchud02,g_fch.fchud03,g_fch.fchud04,
                    g_fch.fchud05,g_fch.fchud06,g_fch.fchud07,g_fch.fchud08,
                    g_fch.fchud09,g_fch.fchud10,g_fch.fchud11,g_fch.fchud12,
                    g_fch.fchud13,g_fch.fchud14,g_fch.fchud15
                    #FUN-850068     ----end----
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029  
    INPUT BY NAME g_fch.fchoriu,g_fch.fchorig,
        g_fch.fch01,g_fch.fch02,g_fch.fch03,
        #FUN-850068     ---start---
        g_fch.fchud01,g_fch.fchud02,g_fch.fchud03,g_fch.fchud04,
        g_fch.fchud05,g_fch.fchud06,g_fch.fchud07,g_fch.fchud08,
        g_fch.fchud09,g_fch.fchud10,g_fch.fchud11,g_fch.fchud12,
        g_fch.fchud13,g_fch.fchud14,g_fch.fchud15
        #FUN-850068     ----end----
        WITHOUT DEFAULTS
 
       ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()   #FUN-550037(smin)
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t800_set_entry(p_cmd)
           CALL t800_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
#No.FUN-550034 --start--
        #CALL cl_set_docno_format("fch01")   #No.FUN-560146 Mark
#No.FUN-550034 ---end---
 
        AFTER FIELD fch01
           IF NOT cl_null(g_fch.fch01) THEN
              IF p_cmd='a' OR (p_cmd='u' AND g_fch.fch01!=g_fch01_t) THEN
                 SELECT count(*) INTO g_cnt FROM fch_file
                  WHERE fch01 = g_fch.fch01
                  IF g_cnt > 0 THEN   #資料重複
                      CALL cl_err(g_fch.fch01,-239,0)
                      LET g_fch.fch01 = g_fch01_t
                      DISPLAY BY NAME g_fch.fch01
                      NEXT FIELD fch01
                  END IF
              END IF
           END IF
           LET g_fch_o.fch01 = g_fch.fch01
 
       #FUN-850068     ---start---
       AFTER FIELD fchud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fchud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #FUN-850068     ----end----
 
 
        AFTER INPUT   #97/05/22 modify
           LET g_fch.fchuser = s_get_data_owner("fch_file") #FUN-C10039
           LET g_fch.fchgrup = s_get_data_group("fch_file") #FUN-C10039
          IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        #MOD-650015 --start 
       # ON ACTION CONTROLO                        # 沿用所有欄位
       #     IF INFIELD(fch01) THEN
       #         LET g_fch.* = g_fch_t.*
       #         DISPLAY BY NAME g_fch.*
       #         NEXT FIELD fch01
       #     END IF
        #MOD-650015 --end
 
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
FUNCTION t800_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fch01",TRUE)
    END IF
END FUNCTION
 
FUNCTION t800_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("fch01",FALSE)
    END IF
END FUNCTION
 
#Query 查詢
FUNCTION t800_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fch.* TO NULL              #No.FUN-6A0001 
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t800_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fch.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t800_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fch.* TO NULL
    ELSE
        OPEN t800_count
        FETCH t800_count INTO g_row_count
        DISPLAY  g_row_count TO FORMONLY.cnt
        CALL t800_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t800_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t800_cs INTO g_fch.fch01
        WHEN 'P' FETCH PREVIOUS t800_cs INTO g_fch.fch01
        WHEN 'F' FETCH FIRST    t800_cs INTO g_fch.fch01
        WHEN 'L' FETCH LAST     t800_cs INTO g_fch.fch01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
#                      CONTINUE PROMPT
 
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
            FETCH ABSOLUTE g_jump t800_cs INTO g_fch.fch01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)
        INITIALIZE g_fch.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fch.* FROM fch_file WHERE fch01 = g_fch.fch01
    IF SQLCA.sqlcode THEN
#       CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)   #No.FUN-660136
        CALL cl_err3("sel","fch_file",g_fch.fch01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fch.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_fch.fchuser   #FUN-4C0059
    LET g_data_group = g_fch.fchgrup   #FUN-4C0059
    CALL t800_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t800_show()
    LET g_fch_t.* = g_fch.*                #保存單頭舊值
    DISPLAY BY NAME g_fch.fchoriu,g_fch.fchorig,                              # 顯示單頭值
 
 
        g_fch.fch01,g_fch.fch02,g_fch.fch03,
        g_fch.fch04,g_fch.fch05,g_fch.fch06,
        g_fch.fch07,g_fch.fch08,g_fch.fch09,
        g_fch.fchuser,g_fch.fchgrup,g_fch.fchmodu,
        g_fch.fchdate,g_fch.fchconf,
        #FUN-850068     ---start---
        g_fch.fchud01,g_fch.fchud02,g_fch.fchud03,g_fch.fchud04,
        g_fch.fchud05,g_fch.fchud06,g_fch.fchud07,g_fch.fchud08,
        g_fch.fchud09,g_fch.fchud10,g_fch.fchud11,g_fch.fchud12,
        g_fch.fchud13,g_fch.fchud14,g_fch.fchud15
        #FUN-850068     ----end----
 
    #CKP
    IF g_fch.fchconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_fch.fchconf,"","","",g_chr,"")
    CALL t800_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t800_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fch.fch01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_fch.fchconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    SELECT * INTO g_fch.* FROM fch_file WHERE fch01 = g_fch.fch01
    IF g_fch.fchconf = 'Y' THEN CALL cl_err('','anm-105',1) RETURN END IF     #No.TQC-770093
    BEGIN WORK
 
    OPEN t800_cl USING g_fch.fch01
    IF STATUS THEN
       CALL cl_err("OPEN t800_cl:", STATUS, 1)
       CLOSE t800_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t800_cl INTO g_fch.*
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)
      CLOSE t800_cl ROLLBACK WORK RETURN
    END IF
    CALL t800_show()
    IF cl_delh(20,16)  THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fch01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fch.fch01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
        DELETE FROM fch_file WHERE fch01 = g_fch.fch01
        IF SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)   #No.FUN-660136
          CALL cl_err3("del","fch_file",g_fch.fch01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                ROLLBACK WORK RETURN
        END IF
        DELETE FROM fci_file WHERE fci01 = g_fch.fch01
        CLEAR FORM
        CALL g_fci.clear()
        INITIALIZE g_fch.* TO NULL
        OPEN t800_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE t800_cs
             CLOSE t800_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        FETCH t800_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t800_cs
             CLOSE t800_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t800_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t800_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t800_fetch('/')
        END IF
 
    END IF
    CLOSE t800_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t800_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_modify_flag   LIKE type_file.chr1,                 #單身更改否       #No.FUN-680070 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,                 #Esc結束INPUT ARRAY 否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fch.fch01 IS NULL  THEN RETURN END IF
    IF g_fch.fchconf = 'Y' THEN RETURN END IF
    IF g_fch.fchconf = 'X' THEN
        CALL cl_err('','9024',0) RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fci02,fci03,fci031,fci04,fci05,fci06,fci07,fci071,fci08,fci09,fci10, ",
                       " fci11,fci12,fci13,fci14,fci15,fci16,fci17,fci18,fci19, ",
                       #No.FUN-850068 --start--
                       "       fciud01,fciud02,fciud03,fciud04,fciud05,",
                       "       fciud06,fciud07,fciud08,fciud09,fciud10,",
                       "       fciud11,fciud12,fciud13,fciud14,fciud15 ",
                       #No.FUN-850068 ---end---
                       " FROM fci_file ",
                       " WHERE fci01=? ",
                       " AND fci03=? ",
                       " AND fci031=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t800_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_row  = 12
        LET l_col  = 15
        LET l_ac_t =  0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   #CKP2
   IF g_rec_b=0 THEN CALL g_fci.clear() END IF
 
 
        INPUT ARRAY g_fci  WITHOUT DEFAULTS FROM s_fci.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
          IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()       #目前筆數
           #LET g_fci_t.* = g_fci[l_ac].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()                #目前的array共有幾筆
            BEGIN WORK
 
            OPEN t800_cl USING g_fch.fch01
            IF STATUS THEN
               CALL cl_err("OPEN t800_cl:", STATUS, 1)
               CLOSE t800_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t800_cl INTO g_fch.*              # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t800_cl ROLLBACK WORK RETURN
            END IF
           #IF g_fci_t.fci02 IS NOT NULL THEN
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fci_t.* = g_fci[l_ac].*  #BACKUP
 
                OPEN t800_bcl USING g_fch.fch01, g_fci_t.fci03, g_fci_t.fci031
                IF STATUS THEN
                   CALL cl_err("OPEN t800_bcl:", STATUS, 1)
                   CLOSE t800_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t800_bcl INTO g_fci[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fci_t.fci02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            #NEXT FIELD fci02
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CKP2
              INITIALIZE g_fci[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_fci[l_ac].* TO s_fci.*
              CALL g_fci.deleteElement(l_ac)
              ROLLBACK WORK
              EXIT INPUT
             #CANCEL INSERT
            END IF
             INSERT INTO fci_file (fci01,fci02,fci03,fci031,fci04,fci05,   #No.MOD-470041
                                  fci06,fci07,fci071,fci08,fci09,fci10,
                                  fci11,fci12,fci13,fci14,fci15,fci16,
                                  fci17,fci18,fci19,fci20,fci21,fci22,
                                  #FUN-850068 --start--
                                  fciud01,fciud02,fciud03,
                                  fciud04,fciud05,fciud06,
                                  fciud07,fciud08,fciud09,
                                  fciud10,fciud11,fciud12,
                                  fciud13,fciud14,fciud15,
                                 #FUN-850068 --end--
                                  fcilegal) #FUN-980003 add 
                 VALUES(g_fch.fch01,g_fci[l_ac].fci02,g_fci[l_ac].fci03,
                        g_fci[l_ac].fci031,g_fci[l_ac].fci04,g_fci[l_ac].fci05,
                        g_fci[l_ac].fci06,g_fci[l_ac].fci07,g_fci[l_ac].fci071,
                        g_fci[l_ac].fci08,g_fci[l_ac].fci09,g_fci[l_ac].fci10,
                        g_fci[l_ac].fci11,g_fci[l_ac].fci12,g_fci[l_ac].fci13,
                        g_fci[l_ac].fci14,g_fci[l_ac].fci15,g_fci[l_ac].fci16,
                        g_fci[l_ac].fci17,g_fci[l_ac].fci18,g_fci[l_ac].fci19,
                        g_fci[l_ac].fci09,g_fci[l_ac].fci10,g_fci[l_ac].fci15,
                        #FUN-850068 --start--
                        g_fci[l_ac].fciud01,
                        g_fci[l_ac].fciud02,
                        g_fci[l_ac].fciud03,
                        g_fci[l_ac].fciud04,
                        g_fci[l_ac].fciud05,
                        g_fci[l_ac].fciud06,
                        g_fci[l_ac].fciud07,
                        g_fci[l_ac].fciud08,
                        g_fci[l_ac].fciud09,
                        g_fci[l_ac].fciud10,
                        g_fci[l_ac].fciud11,
                        g_fci[l_ac].fciud12,
                        g_fci[l_ac].fciud13,
                        g_fci[l_ac].fciud14,
                        g_fci[l_ac].fciud15,
                        #FUN-850068 --end--
                        g_legal) #FUN-980003 add 
 
            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fci[l_ac].fci02,SQLCA.sqlcode,0)   #No.FUN-660136
                CALL cl_err3("ins","fci_file",g_fch.fch01,g_fci[l_ac].fci02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
               #LET g_fci[l_ac].* = g_fci_t.*
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                LET g_feature = ' '
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
                INITIALIZE g_fci[l_ac].* TO NULL      #900423
                LET g_fci[l_ac].fci18 = '1'
                LET g_fci[l_ac].fci19 = '1'
            LET g_fci_t.* = g_fci[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fci02
 
        BEFORE FIELD fci02                            #default 序號
            IF g_fci[l_ac].fci02 IS NULL OR
               g_fci[l_ac].fci02 = 0 THEN
               SELECT max(fci02)+1
                 INTO g_fci[l_ac].fci02
                 FROM fci_file
                WHERE fci01 = g_fch.fch01
                IF g_fci[l_ac].fci02 IS NULL THEN
                   LET g_fci[l_ac].fci02 = 1
                END IF
            END IF
 
        AFTER FIELD fci03                        #財產編號
            IF NOT cl_null(g_fci[l_ac].fci03) THEN
                #No.MOD-4A0021
               IF cl_null(g_fci[l_ac].fci031) THEN
                  LET g_fci[l_ac].fci031=' '
               END IF
               #--end
               IF g_fci[l_ac].fci03 != g_fci_t.fci03 OR
                  g_fci_t.fci03 IS NULL THEN
                  #該財產編號需為免稅
                  SELECT COUNT(*) INTO l_n FROM faj_file
                   WHERE faj02 = g_fci[l_ac].fci03 AND faj40 = '1'
                  IF l_n < 1  THEN
                     CALL cl_err('','afa-120',0)
                     LET g_fci[l_ac].fci03 = g_fci_t.fci03
                     NEXT FIELD fci03
                  END IF
      # 若該財產編號在資產基本資料檔[faj_file]只有一筆資料時(無附件)
      # . 不可輸入「財產附號」欄位。 ..直接跳至合併編號
                  IF l_n = 1 THEN
                     SELECT faj022 INTO g_fci[l_ac].fci031  FROM faj_file
                      WHERE faj02 = g_fci[l_ac].fci03
                     IF cl_null(g_fci[l_ac].fci031) THEN
                        #LET g_fci[l_ac].fci031 = '    '   #MOD-750075
                        LET g_fci[l_ac].fci031 = ' '   #MOD-750075
                        SELECT COUNT(*) INTO l_cnt FROM fci_file
                         WHERE fci03 = g_fci[l_ac].fci03
                           AND fci031= g_fci[l_ac].fci031
                        IF l_cnt > 0 THEN
                           CALL cl_err('','afa-121',0)
                           LET g_fci[l_ac].fci03 = g_fci_t.fci03
                           NEXT FIELD fci03
                        END IF
                       #str MOD-940087 add
                       #該財產編號+附號須不存在投資抵減單身檔[fcc_file]中。
                        LET l_cnt = 0
                        SELECT COUNT(*) INTO l_cnt FROM fcc_file
                         WHERE fcc03 = g_fci[l_ac].fci03
                           AND fcc031= g_fci[l_ac].fci031
                        IF l_cnt > 0 THEN
                           CALL cl_err('','afa-158',0)
                           LET g_fci[l_ac].fci03 = g_fci_t.fci03
                           NEXT FIELD fci03
                        END IF
                       #end MOD-940087 add
                       #str MOD-B30136 add
                        #該財產編號需為免稅
                        SELECT COUNT(*) INTO l_n FROM faj_file
                         WHERE faj02 = g_fci[l_ac].fci03
                           AND faj022= g_fci[l_ac].fci031
                           AND faj40 = '1'
                        IF l_n < 1  THEN
                           CALL cl_err('','afa-120',0)
                           LET g_fci[l_ac].fci03 = g_fci_t.fci03
                           NEXT FIELD fci03
                        END IF
                       #end MOD-B30136 add
                        CALL t800_showfaj() # 預設中文名稱[faj06].......
                        NEXT FIELD fci07
                     END IF
                  END IF
               END IF
            END IF
 
        AFTER FIELD fci031                       #財產附號
             #No.MOD-4A0021
            IF cl_null(g_fci[l_ac].fci031) THEN
               LET g_fci[l_ac].fci031=' '
            END IF
            #--end
            IF g_fci[l_ac].fci031 != g_fci_t.fci031 OR
               g_fci_t.fci031 IS NULL THEN
               IF g_fci[l_ac].fci031 IS NULL THEN
                  LET g_fci[l_ac].fci031 = ' '
               END IF
               # 該財產編號+附號須不存在投資抵減單身檔[fci_file]中。
               SELECT COUNT(*) INTO l_n FROM fci_file
                WHERE fci03 = g_fci[l_ac].fci03
                  AND fci031= g_fci[l_ac].fci031
               IF l_n > 0 THEN
                  CALL cl_err('','afa-121',0)
                  LET g_fci[l_ac].fci031 = g_fci_t.fci031
                  NEXT FIELD fci03
               END IF
              #str MOD-940087 add
              #該財產編號+附號須不存在投資抵減單身檔[fcc_file]中。
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM fcc_file
                WHERE fcc03 = g_fci[l_ac].fci03
                  AND fcc031= g_fci[l_ac].fci031
               IF l_cnt > 0 THEN
                  CALL cl_err('','afa-158',0)
                  LET g_fci[l_ac].fci031 = g_fci_t.fci031
                  NEXT FIELD fci031
               END IF
              #end MOD-940087 add
               # 該財產編號+附號須存在固定資產資料檔[faj_file]中。
               SELECT COUNT(*) INTO l_n FROM faj_file
                WHERE faj02 = g_fci[l_ac].fci03
                  AND faj022= g_fci[l_ac].fci031
               IF l_n =0  THEN
                 #CALL cl_err('','afa-093',0)                  #MOD-C70265 mark
                  CALL cl_err('','afa-134',0)                  #MOD-C70265 add
                  LET g_fci[l_ac].fci031 = g_fci_t.fci031
                  NEXT FIELD fci03
               END IF
              #str MOD-B30136 add
               #該財產編號需為免稅
               SELECT COUNT(*) INTO l_n FROM faj_file
                WHERE faj02 = g_fci[l_ac].fci03 AND faj022 = g_fci[l_ac].fci031 AND faj40 = '1'
               IF l_n < 1  THEN
                  CALL cl_err('','afa-120',0)
                  LET g_fci[l_ac].fci031 = g_fci_t.fci031
                  NEXT FIELD fci031
               END IF
              #end MOD-B30136 add
               CALL t800_showfaj() # 預設中文名稱[faj06].......
            END IF
 
        AFTER FIELD fci07                        #合併編號
            IF NOT cl_null(g_fci[l_ac].fci07) THEN
               SELECT COUNT(*) INTO l_n
                 FROM fci_file
                WHERE fci01 = g_fch.fch01
                AND   fci03 = g_fci[l_ac].fci07
                IF l_n < 1  THEN
                    CALL cl_err(g_fci[l_ac].fci07,'afa-166',0)
                    LET g_fci[l_ac].fci07 = g_fci_t.fci07
                    NEXT FIELD fci07
                END IF
               SELECT COUNT(*) INTO l_n
                 FROM faj_file
                WHERE faj02 = g_fci[l_ac].fci07
      # 若該財產編號在資產基本資料檔[faj_file]只有一筆資料時(無附件)
      # . 不可輸入「財產附號」欄位。 ..直接跳至發票號碼
                IF l_n = 1 THEN
                  #LET g_fci[l_ac].fci071 = '    '
                  #LET g_fci[l_ac].fci071 = ''      #No:8141   #MOD-750075
                   LET g_fci[l_ac].fci071 = ' '      #No:8141   #MOD-750075
                  #str MOD-B30136 add
                   #該財產編號需為免稅
                   SELECT COUNT(*) INTO l_n FROM faj_file
                    WHERE faj02 = g_fci[l_ac].fci07
                      AND faj022= g_fci[l_ac].fci071
                      AND faj40 = '1'
                   IF l_n < 1  THEN
                      CALL cl_err('','afa-120',0)
                      LET g_fci[l_ac].fci07 = g_fci_t.fci07
                      NEXT FIELD fci07
                   END IF
                  #end MOD-B30136 add
                 # CALL t800_fci07() #若合併編號+附號之合併前...  No:8345
                   NEXT FIELD fci11
                END IF
            ELSE
                LET g_fci[l_ac].fci07 = ''         #No:8141
            END IF
 
        AFTER FIELD fci071                       #合併附號
            IF NOT cl_null(g_fci[l_ac].fci071) THEN
               SELECT COUNT(*)
                 INTO l_n
                 FROM fci_file
                WHERE fci03 = g_fci[l_ac].fci07
                  AND fci031= g_fci[l_ac].fci071
                IF l_n < 1  THEN
                    CALL cl_err(g_fci[l_ac].fci071,'afa-166',0)
                    LET g_fci[l_ac].fci071 = g_fci_t.fci071
                    NEXT FIELD fci071
                END IF
               SELECT COUNT(*)
                 INTO l_n
                 FROM faj_file
                WHERE faj02 = g_fci[l_ac].fci07
                  AND faj022= g_fci[l_ac].fci071
                  AND faj40 = '1'
                IF l_n < 0  THEN
                    CALL cl_err(g_fci[l_ac].fci071,'afa-167',0)
                    LET g_fci[l_ac].fci071 = g_fci_t.fci071
                    NEXT FIELD fci07
                END IF
               #str MOD-B30136 add
                #該財產編號需為免稅
                SELECT COUNT(*) INTO l_n FROM faj_file
                 WHERE faj02 = g_fci[l_ac].fci07
                   AND faj022= g_fci[l_ac].fci071
                   AND faj40 = '1'
                IF l_n < 1  THEN
                   CALL cl_err('','afa-120',0)
                   LET g_fci[l_ac].fci071 = g_fci_t.fci071
                   NEXT FIELD fci071
                END IF
               #end MOD-B30136 add
      # 若該財產編號在資產基本資料檔[faj_file]只有一筆資料時(無附件)
      # . 不可輸入「財產附號」欄位。 ..直接跳至合併編號
            ELSE
                #LET g_fci[l_ac].fci071 = ''       #No:8141   #MOD-750075
                LET g_fci[l_ac].fci071 = ' '       #No:8141   #MOD-750075
            END IF
          #No:8345
          # IF NOT cl_null(g_fci[l_ac].fci07) THEN
          #     CALL t800_fci07() #若合併編號+附號之合併前...
          # END IF
 
 
        AFTER FIELD fci15            #成本
          IF g_fci[l_ac].fci15 IS NULL THEN
             LET g_fci[l_ac].fci15 = 0
          END IF
          #No.TQC-770108 --start--
          IF g_fci[l_ac].fci15 < 0 THEN
             CALL cl_err('','mfg4012',0)
             NEXT FIELD fci15
          END IF
          #No.TQC-770108 --end--
 
        AFTER FIELD fci09            #數量
          IF g_fci[l_ac].fci09 IS NULL THEN
             LET g_fci[l_ac].fci09 = 0
          END IF
          #No.TQC-770108 --start--
          IF g_fci[l_ac].fci09 < 0 THEN
             CALL cl_err('','mfg4012',0)
             NEXT FIELD fci09
          END IF
          #No.TQC-770108 --end--
          IF NOT cl_null(g_fci[l_ac].fci09) THEN
              IF cl_null(g_fci[l_ac].fci031) THEN        #No.MOD-4A0021
                LET g_fci[l_ac].fci031=' '
             END If
             SELECT (faj17-faj58) INTO g_faj17_faj58    # 未銷帳數量
               FROM faj_file
              WHERE faj02 = g_fci[l_ac].fci03
                AND faj022= g_fci[l_ac].fci031
             IF g_fci[l_ac].fci09>g_faj17_faj58
                THEN
                CALL cl_err(g_faj17_faj58,'afa-352',0)
                NEXT FIELD fci09
             END IF
          END IF
 
 
## No:2492 modify 1998/10/06 get 購進日期(發票日期/進口日期)------
        BEFORE FIELD fci17
          IF cl_null(g_fci[l_ac].fci17)
             THEN
             LET g_fci[l_ac].fci17=t800_get_fci17(g_fci[l_ac].fci03,
                                                  g_fci[l_ac].fci031)
             #------MOD-5A0095 START----------
             DISPLAY BY NAME g_fci[l_ac].fci17
             #------MOD-5A0095 END------------
          END IF
## ----------------------------------------------------
        AFTER FIELD fci14
          IF NOT cl_null(g_fci[l_ac].fci14 ) THEN
             LET g_fci[l_ac].fci14 = t800_get_fai(g_fci[l_ac].fci14)
          END IF
          DISPLAY g_fci[l_ac].fci14 TO fci14
 
        AFTER FIELD fci16
          IF NOT cl_null(g_fci[l_ac].fci14 ) THEN
             LET g_fci[l_ac].fci16 = t800_get_fai(g_fci[l_ac].fci16)
          END IF
          DISPLAY g_fci[l_ac].fci16 TO fci16
 
        AFTER FIELD fci18            #狀態
           IF NOT cl_null(g_fci[l_ac].fci18) THEN
              IF g_fci[l_ac].fci18 NOT MATCHES '[1-2]' THEN
                 NEXT FIELD fci18
              END IF
           END IF
 
       #No.FUN-850068 --start--
       AFTER FIELD fciud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fciud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       #No.FUN-850068 ---end---
 
 
        BEFORE DELETE                            #是否取消單身
            IF g_fci_t.fci02 > 0 AND
               g_fci_t.fci02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM fci_file
                 WHERE fci01 = g_fch.fch01
                   AND fci02 = g_fci_t.fci02
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_fci_t.fci02,SQLCA.sqlcode,0)   #No.FUN-660136
                    CALL cl_err3("del","fci_file",g_fch.fch01,g_fci_t.fci02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_fci[l_ac].* = g_fci_t.*
               CLOSE t800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fci[l_ac].fci02,-263,1)
               LET g_fci[l_ac].* = g_fci_t.*
            ELSE
               UPDATE fci_file
               SET
                  fci02=g_fci[l_ac].fci02,fci03=g_fci[l_ac].fci03,
                  fci031=g_fci[l_ac].fci031,fci04=g_fci[l_ac].fci04,
                  fci05=g_fci[l_ac].fci05,fci06=g_fci[l_ac].fci06,
                  fci07=g_fci[l_ac].fci07,fci071=g_fci[l_ac].fci071,
                  fci08=g_fci[l_ac].fci08,fci09=g_fci[l_ac].fci09,
                  fci10=g_fci[l_ac].fci10,fci11=g_fci[l_ac].fci11,
                  fci12=g_fci[l_ac].fci12,fci13=g_fci[l_ac].fci13,
                  fci14=g_fci[l_ac].fci14,fci15=g_fci[l_ac].fci15,
                  fci16=g_fci[l_ac].fci16,fci17=g_fci[l_ac].fci17,
                  fci18=g_fci[l_ac].fci18,fci19=g_fci[l_ac].fci19,
                  #FUN-850068 --start--
                  fciud01 = g_fci[l_ac].fciud01,
                  fciud02 = g_fci[l_ac].fciud02,
                  fciud03 = g_fci[l_ac].fciud03,
                  fciud04 = g_fci[l_ac].fciud04,
                  fciud05 = g_fci[l_ac].fciud05,
                  fciud06 = g_fci[l_ac].fciud06,
                  fciud07 = g_fci[l_ac].fciud07,
                  fciud08 = g_fci[l_ac].fciud08,
                  fciud09 = g_fci[l_ac].fciud09,
                  fciud10 = g_fci[l_ac].fciud10,
                  fciud11 = g_fci[l_ac].fciud11,
                  fciud12 = g_fci[l_ac].fciud12,
                  fciud13 = g_fci[l_ac].fciud13,
                  fciud14 = g_fci[l_ac].fciud14,
                  fciud15 = g_fci[l_ac].fciud15
                  #FUN-850068 --end--
 
                WHERE fci01=g_fch.fch01
                  AND fci03 =g_fci_t.fci03
                  AND fci031=g_fci_t.fci031
                IF NOT cl_null(g_fci[l_ac].fci07) THEN
                   UPDATE fci_file
                    SET
                    fci20=g_fci[l_ac].fci09,fci21=g_fci[l_ac].fci10,
                    fci22=g_fci[l_ac].fci15
                    WHERE fci01=g_fch.fch01
                      AND fci03 =g_fci_t.fci03
                      AND fci031=g_fci_t.fci031
                   #---- jeffery update 85/11/20 ----#
                   ELSE IF NOT cl_null(g_fci_t.fci07)
                           THEN #-- 主件成本重算---#
                   UPDATE fci_file
                      SET (fci15) =(fci15-g_fci[l_ac].fci15)
                    WHERE fci01=g_fch.fch01
                      AND fci03 =g_fci_t.fci07
                      AND fci031=g_fci_t.fci071
                        END IF
                END IF
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_fci[l_ac].fci02,SQLCA.sqlcode,0)
                    LET g_fci[l_ac].* = g_fci_t.*
                ELSE
                    MESSAGE 'UPDATE O.K'
                    COMMIT WORK
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac    #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fci[l_ac].* = g_fci_t.*
            #FUN-D30032--add--str--
               ELSE
                  CALL g_fci.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
            #FUN-D30032--add--end--
               END IF
               LET l_ac_t = l_ac  #FUN-D30032 add
               CLOSE t800_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            #LET g_fci_t.* = g_fci[l_ac].*
            CLOSE t800_bcl
            COMMIT WORK
              #CKP2
              CALL g_fci.deleteElement(g_rec_b+1)
 
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fci03)    #查詢資產資料
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj1"
                 LET g_qryparam.default1 = g_fci[l_ac].fci03
                 LET g_qryparam.default2 = g_fci[l_ac].fci031
                 CALL cl_create_qry() RETURNING g_fci[l_ac].fci03,g_fci[l_ac].fci031
#                 CALL FGL_DIALOG_SETBUFFER( g_fci[l_ac].fci03 )
#                 CALL FGL_DIALOG_SETBUFFER( g_fci[l_ac].fci031 )
                 DISPLAY g_fci[l_ac].fci03 TO fci03
                 DISPLAY g_fci[l_ac].fci031 TO fci031
                 NEXT FIELD fci03
              #No.TQC-770108 --start--
              WHEN INFIELD(fci08)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_pmc1"
                 CALL cl_create_qry() RETURNING g_fci[l_ac].fci08
                 DISPLAY g_fci[l_ac].fci08 TO fci08
                 NEXT FIELD fci08
              WHEN INFIELD(fci10)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form     = "q_gfe"
                 CALL cl_create_qry() RETURNING g_fci[l_ac].fci10
                 DISPLAY g_fci[l_ac].fci10 TO fci10
                 NEXT FIELD fci10
              #No.TQC-770108 --end--
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fci02) AND l_ac > 1 THEN
                LET g_fci[l_ac].* = g_fci[l_ac-1].*
                LET g_fci[l_ac].fci02 = NULL   #TQC-620018
                NEXT FIELD fci02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
    # #@ON ACTION 整批產生
    # ON ACTION batch_generate
    #       CALL t800_g(3,5)
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
 
    END INPUT
 
   #start FUN-5A0029
    LET g_fch.fchmodu = g_user
    LET g_fch.fchdate = g_today
    UPDATE fch_file SET fchmodu = g_fch.fchmodu,fchdate = g_fch.fchdate
     WHERE fch01 = g_fch.fch01
    DISPLAY BY NAME g_fch.fchmodu,g_fch.fchdate
   #end FUN-5A0029
 
    CALL t800_add()       #  將原幣成本[fci05],本幣成本[fci06],
                          #    抵減金額[fci09]累加至主件
    CLOSE t800_cl
    CLOSE t800_bcl
    COMMIT WORK
#   CALL t800_delall()   #CHI-C30002 mark
    CALL t800_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t800_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fch.fch01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fch_file ",
                  "  WHERE fch01 LIKE '",l_slip,"%' ",
                  "    AND fch01 > '",g_fch.fch01,"'"
      PREPARE t800_pb1 FROM l_sql 
      EXECUTE t800_pb1 INTO l_cnt 
      
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
        #CALL t800_x()          #FUN-D20035 
         CALL t800_x(1)         #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fch_file WHERE fch01 = g_fch.fch01
         INITIALIZE g_fch.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t800_delall()
#   SELECT COUNT(*) INTO g_cnt FROM fci_file
#       WHERE fci01=g_fch.fch01
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM fch_file WHERE fch01 = g_fch.fch01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t800_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON fci02,fci03
            FROM s_fci[1].fci02,s_fci[1].fci03
 
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
    CALL t800_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t800_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(300)
    LET g_sql =
        "SELECT fci02,fci03,fci031,fci04,fci05,fci06,fci07,fci071,fci08,",
        " fci09,fci10,fci11,fci12,fci13,fci14,fci15,fci16, ",
        " fci17,fci18,fci19, ",
        #No.FUN-850068 --start--
        "       fciud01,fciud02,fciud03,fciud04,fciud05,",
        "       fciud06,fciud07,fciud08,fciud09,fciud10,",
        "       fciud11,fciud12,fciud13,fciud14,fciud15 ",
        #No.FUN-850068 ---end---
        " FROM fci_file",
        " WHERE fci01 ='",g_fch.fch01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,            #單身
        " ORDER BY 1 "
 
    PREPARE t800_pb FROM g_sql
    DECLARE fci_curs                       #SCROLL CURSOR
        CURSOR FOR t800_pb
 
    CALL g_fci.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fci_curs INTO g_fci[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fci.deleteElement(g_cnt)   #取消 Array Element
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t800_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fci TO s_fci.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t800_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION previous
         CALL t800_fetch('P')
         EXIT DISPLAY
      ON ACTION jump
         CALL t800_fetch('/')
         EXIT DISPLAY
      ON ACTION next
         CALL t800_fetch('N')
         EXIT DISPLAY
      ON ACTION last
         CALL t800_fetch('L')
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add--end
 
      #@ON ACTION 整批產生
      ON ACTION batch_generate
         LET g_action_choice="batch_generate"
         EXIT DISPLAY
 
      #@ON ACTION 項次重排
      ON ACTION re_sort
         LET g_action_choice="re_sort"
         EXIT DISPLAY
      #@ON ACTION 選定年度
      ON ACTION chosen_year
         LET g_action_choice="chosen_year"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
#@    ON ACTION 相關文件
       ON ACTION related_document  #No.MOD-470515
         LET g_action_choice="related_document"
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
       #No.MOD-510160
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end 
      #FUN-810046
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t800_sure(l_chr)
DEFINE l_chr     LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE l_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    #bugno:7341 add......................................................
    IF l_chr='Y' THEN
        SELECT COUNT(*) INTO l_cnt FROM fci_file
         WHERE fci01= g_fch.fch01
        IF l_cnt = 0 THEN
           CALL cl_err('','mfg-009',0)
           RETURN
        END IF
    END IF
    #bugno:7341 end......................................................
    IF g_fch.fchconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    SELECT * INTO g_fch.* FROM fch_file WHERE fch01 = g_fch.fch01
IF l_chr='Y' THEN
    IF g_fch.fchconf='Y' THEN RETURN END IF
    IF cl_sure(0,0) THEN                   #確認一下
#CHI-C30107 ---------------- add -------------- begin
       SELECT * INTO g_fch.* FROM fch_file WHERE fch01 = g_fch.fch01
       IF g_fch.fchconf = 'X' THEN
          CALL cl_err('','9024',0) RETURN
       END IF
       IF g_fch.fchconf='Y' THEN RETURN END IF
#CHI-C30107 ---------------- add -------------- end
       BEGIN WORK
 
       OPEN t800_cl USING g_fch.fch01
       IF STATUS THEN
          CALL cl_err("OPEN t800_cl:", STATUS, 1)
          CLOSE t800_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t800_cl INTO g_fch.*              # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)      # 資料被他人LOCK
          CLOSE t800_cl ROLLBACK WORK RETURN
       END IF
       LET g_success = 'Y'
       CALL t800_surey()                   #更新資產基本資料檔
       CLOSE t800_cl
       IF g_success = 'Y' THEN
          LET g_fch.fchconf='Y' COMMIT WORK
          DISPLAY BY NAME g_fch.fchconf
       ELSE LET g_fch.fchconf='N' ROLLBACK WORK
       END IF
    END IF
ELSE
    IF g_fch.fchconf='N' OR NOT cl_null(g_fch.fch04) OR
       NOT cl_null(g_fch.fch06) THEN RETURN END IF
    IF cl_sure(0,0) THEN                   #確認一下
       BEGIN WORK
 
       OPEN t800_cl USING g_fch.fch01
       IF STATUS THEN
          CALL cl_err("OPEN t800_cl:", STATUS, 1)
          CLOSE t800_cl
          ROLLBACK WORK
          RETURN
       END IF
       FETCH t800_cl INTO g_fch.*              # 鎖住將被更改或取消的資料
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)      # 資料被他人LOCK
          CLOSE t800_cl ROLLBACK WORK RETURN
       END IF
       LET g_success = 'Y'
       CALL t800_suren()                   #更新資產基本資料檔
       CLOSE t800_cl
       IF g_success = 'Y' THEN LET g_fch.fchconf='N' COMMIT WORK
          DISPLAY BY NAME g_fch.fchconf
       ELSE LET g_fch.fchconf='Y' ROLLBACK WORK
       END IF
    END IF
END IF
         #CKP
         IF g_fch.fchconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_fch.fchconf,"","","",g_chr,"")
END FUNCTION
 
FUNCTION t800_surey()
DEFINE s_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
       LET s_cnt = 1
       UPDATE fch_file SET fchconf='Y' WHERE fch01=g_fch.fch01
       FOR s_cnt = 1 TO g_rec_b            #更新資產基本資料檔
     # え單身每筆資料, 更新對應資產基本資料檔[faj_file]
     #  faj40 免稅碼     = '2'(申請中)
           UPDATE faj_file SET faj40 = '2'
                         WHERE faj02 = g_fci[s_cnt].fci03
                           AND faj022= g_fci[s_cnt].fci031
           IF SQLCA.sqlcode THEN EXIT FOR END IF
       END FOR
END FUNCTION
 
FUNCTION t800_suren()
DEFINE s_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
LET s_cnt = 1
    # え更新免稅單頭檔之確認碼為「N」。
       UPDATE fch_file SET fchconf='N' WHERE fch01=g_fch.fch01
       FOR s_cnt = 1 TO g_rec_b            #更新資產基本資料檔
    # ぉ單身每筆資料, 更新對應資產基本資料檔[faj_file]
    #   faj40 免稅碼     = '1'(可免稅)
           UPDATE faj_file SET faj40 = '1'
                         WHERE faj02 = g_fci[s_cnt].fci03
                           AND faj022= g_fci[s_cnt].fci031
           IF SQLCA.sqlcode THEN EXIT FOR END IF
       END FOR
END FUNCTION
 
FUNCTION t800_add()
DEFINE
    add       RECORD     fci07       LIKE fci_file.fci07,
                         fci071      LIKE fci_file.fci071,
                    #    fci09       LIKE fci_file.fci09,
                         fci15       LIKE fci_file.fci15
              END RECORD
 
     IF g_fch.fchconf = 'X' THEN
        CALL cl_err('','9024',0) RETURN
     END IF
     DECLARE afat800_cursad CURSOR FOR
  #----- jeffery update 85/11/19 ----#
  #   SELECT fci07,fci071,SUM(fci09),SUM(fci15)
      SELECT fci07,fci071,SUM(fci15)
        FROM fci_file
       WHERE fci01 = g_fch.fch01
         AND not ( fci07 =" " or fci07 is null )
    GROUP BY fci07,fci071
    FOREACH afat800_cursad INTO add.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)  
          EXIT FOREACH
       END IF
       #IF add.fci071 IS NULL THEN LET add.fci071 = '    ' END IF   #MOD-750075
       IF add.fci071 IS NULL THEN LET add.fci071 = ' ' END IF   #MOD-750075
       IF add.fci15  IS NULL THEN LET add.fci15 = 0 END IF
  #    IF add.fci09  IS NULL THEN LET add.fci09 = 0 END IF
   #----- jeffery update ----#
   #   UPDATE fci_file SET fci09 = fci20 + add.fci09,
       UPDATE fci_file SET fci15 = fci22 + add.fci15
                     WHERE fci01 = g_fch.fch01
                       AND fci03 = add.fci07
                       AND fci031= add.fci071
    END FOREACH
   #●免稅金額 [fch09] (DEC15,2)(D): ㄧ單身成本之加總, 不可修改。
    SELECT SUM(fci15) INTO g_fch.fch09 FROM fci_file
     WHERE fci01 = g_fch.fch01 AND ( fci07 = ' ' or fci07 is null )
    IF NOT STATUS THEN
       #no.A010依幣別取位
       LET g_fch.fch09 = cl_digcut(g_fch.fch09,g_azi04)
       #(end)
       UPDATE fch_file SET fch09 = g_fch.fch09 WHERE fch01 = g_fch.fch01
       DISPLAY BY NAME g_fch.fch09
    END IF
    CALL t800_b_fill('1=1')       # 將累加後的結果顯示在螢幕上
END FUNCTION
 
FUNCTION t800_g(p_row,p_col)             # G. 自動產生..單身資料
 DEFINE p_row      LIKE type_file.num5,     #No.FUN-680070 SMALLINT
        p_col      LIKE type_file.num5,     #No.FUN-680070 SMALLINT
        l_ax       LIKE type_file.num5,     #No.FUN-680070 SMALLINT
        l_maxac    LIKE type_file.num5,     #No.FUN-680070 SMALLINT
        l_wc       LIKE type_file.chr1000,  #No.FUN-680070 VARCHAR(200)
        l_sql      LIKE type_file.chr1000,  #No.FUN-680070 VARCHAR(400)
        l_num      LIKE type_file.num5,     #No.FUN-680070 SMALLINT
        l_faj_t    RECORD                   #程式變數(Program Variables)
        fajyn       LIKE type_file.chr1,    #是否要投入 fci_file       #No.FUN-680070 VARCHAR(1)
        faj02       LIKE faj_file.faj02,    #財產編號
        faj022      LIKE faj_file.faj022,   #附號
        faj26       LIKE faj_file.faj26,    #入帳日期
        faj51       LIKE faj_file.faj51,    #發票號碼
        faj17       LIKE faj_file.faj17,    #數量
        faj18       LIKE faj_file.faj18,    #單位
        faj14       LIKE faj_file.faj14,    #成本
        faj06       LIKE faj_file.faj06,    #中文名稱
        faj07       LIKE faj_file.faj07     #英文名稱
                   END RECORD
 DEFINE ch char
 DEFINE ls_tmp STRING

##Modify:2621
   IF cl_null(g_fch.fch01) THEN RETURN END IF   #MOD-B30136 add
   IF g_fch.fchconf ='Y' THEN
      CALL cl_err('','afa-364',0) RETURN
   END IF
   IF g_fch.fchconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
   END IF
   LET l_ac = ARR_CURR()
   LET p_row = 5 LET p_col = 25
   OPEN WINDOW t800_g AT p_row,p_col
        WITH FORM "afa/42f/afat800s"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("afat800s")
 
   IF INT_FLAG THEN CLOSE WINDOW t800_g RETURN END IF   #MOD-B30136 mod
      CALL cl_opmsg('q')
      #資料權限的檢查
      CONSTRUCT BY NAME l_wc ON faj04,faj05,faj02,faj26,faj47     # 螢幕上取自動產生條件
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
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW t800_g RETURN END IF   #MOD-B30136 mod
      LET l_sql ="SELECT '',faj02,faj022,faj26,faj51,faj17,faj18,",
                 "       faj14,faj06,faj07 ",
                 "  FROM faj_file ",
                 " WHERE faj40 = '1' ",
                 "   AND faj14 > 0   ",
                 "   AND ",l_wc CLIPPED,
                 " ORDER BY faj02,faj022 "
      PREPARE t800_g FROM l_sql
      DECLARE t800_g_curs CURSOR FOR t800_g
      CALL t800_create_temp1()   #建立一temp file 儲存預投入單身之資料
      FOREACH t800_g_curs INTO l_faj_t.*
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
        #TQC-980109   ---start
        #SELECT fch01 FROM fci_file
        #       WHERE fci03=l_faj_t.faj02
        #         AND fci031=l_faj_t.faj022
        #IF SQLCA.SQLCODE
        #   THEN EXIT FOREACH
        #END IF
        #TQC-980109   ---end     
         INSERT INTO faj_temp
         VALUES('Y',l_faj_t.faj02,l_faj_t.faj022,l_faj_t.faj26,
                l_faj_t.faj51,l_faj_t.faj17,l_faj_t.faj18,
                l_faj_t.faj14,l_faj_t.faj06,l_faj_t.faj07)
      END FOREACH
      IF INT_FLAG THEN LET INT_FLAG = 0 END IF
      CLOSE WINDOW t800_g
 
      LET p_row = 10 LET p_col =15
      OPEN WINDOW t800_a AT p_row,p_col WITH FORM "afa/42f/afat800a"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
      CALL cl_ui_locale("afat800a")
 
      IF INT_FLAG THEN RETURN END IF
      CALL t800_b_fillx()       # 單身  # 底稿放入選擇array
     #CALL t800_bpx("D")
      CALL t800_bx()
      CALL t800_putb()  # 將[Y] 者新增至單身中
      #資料權限的檢查
      CLOSE WINDOW t800_a
      CALL t800_b_fill('1=1')       # 單身
END FUNCTION
 
FUNCTION t800_t()             # T. 項次重排..單身資料
    DEFINE
        l_num       LIKE type_file.num5,         #No.FUN-680070 SMALLINT
        l_fci02     LIKE fci_file.fci02,   #項次
        l_fci_t     RECORD                 #程式變數 (舊值)
        fci03       LIKE fci_file.fci03,   #財產編號
        fci031      LIKE fci_file.fci031,  #附號
        fci07       LIKE fci_file.fci07,   #合併編號
        fci071      LIKE fci_file.fci071,  #附號
        fci18       LIKE fci_file.fci18    #類別
                    END RECORD
    DEFINE l_flag   LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF g_fch.fchconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    DECLARE t800_t1 CURSOR FOR      # LOCK CURSOR
        SELECT fci03,fci031,fci07,fci071,fci18 FROM fci_file
         WHERE fci01 = g_fch.fch01
           AND (fci07 = '' OR fci07 IS NULL)
         ORDER BY fci18,fci03,fci031
    LET l_num = 1
 #No.MOD-580325-begin
    CALL cl_err('','afa-998',0)
#   MESSAGE '進行項次重排中 .....'
 #No.MOD-580325-end
    let l_flag = false
    FOREACH t800_t1 INTO l_fci_t.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)   
          EXIT FOREACH
       END IF
       IF l_fci_t.fci18 = '2' and l_flag = false
          THEN LET l_num = 1
               let l_flag = true
       END IF
       UPDATE fci_file SET fci02 = l_num
        WHERE fci03 = l_fci_t.fci03 AND fci031 = l_fci_t.fci031
       LET l_num = l_num + 1
    END FOREACH
 
    DECLARE t800_t CURSOR FOR      # LOCK CURSOR
        SELECT fci03,fci031,fci07,fci071,fci18 FROM fci_file
         WHERE fci01 = g_fch.fch01
           AND fci07 <> ''
         ORDER BY fci18,fci03,fci031
    FOREACH t800_t INTO l_fci_t.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)   
          EXIT FOREACH
       END IF
       SELECT fci02 INTO l_fci02 FROM fci_file
        WHERE fci03 = l_fci_t.fci07
          AND fci031= l_fci_t.fci071
       IF STATUS = 0 THEN
          UPDATE fci_file SET fci02 = l_fci02
           WHERE fci03 = l_fci_t.fci03 AND fci031 = l_fci_t.fci031
       END IF
    END FOREACH
 #No.MOD-580325-begin
    CALL cl_err('','afa-997',0)
#   MESSAGE '項次重排已完成 !!'
 #No.MOD-580325-end
    CALL t800_b_fill('1=1')       # 單身
    MESSAGE ''
END FUNCTION
 
FUNCTION t800_s()
    IF g_fch.fchconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    BEGIN WORK LET g_success = 'Y'
       INPUT BY NAME g_fch.fch03 WITHOUT DEFAULTS
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
       END INPUT
       #-----END TQC-860018-----
       UPDATE fch_file SET fch03 = g_fch.fch03 WHERE fch01=g_fch.fch01
       IF SQLCA.sqlcode THEN LET g_success = 'N' END IF
       IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
#No:8345 整段mark
#FUNCTION t800_fci07()
 # 若合併編號+附號之合併前本幣成本欄位[fci22]<=0, 則將合併編號+附號之
 # 數量移至合併前數量[fci20]、單位移至合併前單位[fci21]、成本移至合併前
 # 成本[fci22]欄位。
#---- jeffery update ----#
 {
   #--- 若此主件金額=原主件成本 or =0 則 重新計算 -----#
   DEFINE l_fci22      LIKE fci_file.fci22
   SELECT fci22 INTO l_fci22 FROM fci_file WHERE fci01 = g_fch.fch01
      AND fci03=g_fci[l_ac].fci07 AND fci031 = g_fci[l_ac].fci071
   IF l_fci22 IS NULL THEN LET l_fci22 = 0 END IF
   IF l_fci22 <= 0 THEN
      UPDATE fci_file SET fci20 = fci09, fci21 = fci10, fci22 = fci15
       WHERE fci01 = g_fch.fch01 AND fci03=g_fci[l_ac].fci07
         AND fci031 = g_fci[l_ac].fci071
   END IF
 }
#---- jeffery update ----#
 # 預設核准狀態[faj19]為「0.合併」。
{
   UPDATE faj_file SET faj19 = '0' WHERE faj02 = g_fci[l_ac].fci07
      AND faj022 = g_fci[l_ac].fci071
}
#END FUNCTION
 
FUNCTION t800_create_temp1()
   DELETE FROM faj_temp
IF STATUS THEN
#No.FUN-680070  -- begin --
#   CREATE TABLE faj_temp(                                                       
#     fajyn  VARCHAR(1),
#     faj02  VARCHAR(10),
#     faj022 VARCHAR(4),
#     faj26  DATE,                                                               
#     faj51  VARCHAR(10),    #No.FUN-540057
#     faj17  SMALLINT,                                                           
#     faj18  VARCHAR(4),
#     faj14  DEC(20,6),   #No.FUN-4C0008                                         
#     faj06  VARCHAR(25),
#     faj07  VARCHAR(30));
   CREATE TEMP TABLE faj_temp(
     fajyn  LIKE type_file.chr1,  
     faj02  LIKE faj_file.faj02,
     faj022 LIKE faj_file.faj022,
     faj26  LIKE faj_file.faj26,
     faj51  LIKE faj_file.faj51,
     faj17  LIKE faj_file.faj17,
     faj18  LIKE faj_file.faj18,
     faj14  LIKE faj_file.faj14,
     faj06  LIKE faj_file.faj06,
     faj07  LIKE faj_file.faj07);
#No.FUN-680070  -- end --
END IF
END FUNCTION
 
FUNCTION t800_showfaj()
        # 預設中文名稱[faj06]、英文名稱[faj07]、規格型號[faj08]、廠商[faj10]
        # 、數量[faj17]、單位[faj18]、發票號碼[faj51]、進口編號[faj49]
        # 、採購單號[faj47]、進口報單[faj48]、本幣成本[faj14]、購進日期[faj511]
               SELECT faj06,faj07,faj08,faj10,faj17,faj18,faj51,faj49,faj47,
                      faj48,faj14,faj511
                 INTO g_fci[l_ac].fci04, g_fci[l_ac].fci05, g_fci[l_ac].fci06,
                      g_fci[l_ac].fci08, g_fci[l_ac].fci09, g_fci[l_ac].fci10,
                      g_fci[l_ac].fci11, g_fci[l_ac].fci12, g_fci[l_ac].fci13,
                      g_fci[l_ac].fci14, g_fci[l_ac].fci15, g_fci[l_ac].fci17
                 FROM faj_file
                WHERE faj02 = g_fci[l_ac].fci03
                 AND faj022= g_fci[l_ac].fci031   #MOD-7C0204 取消原先的mark
               #display 'fci03:',g_fci[l_ac].fci03
               #display 'fci031:',g_fci[l_ac].fci031
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
                 DISPLAY BY NAME g_fci[l_ac].*   #No.MOD-4A0021
END FUNCTION
 
FUNCTION t800_bx()
DEFINE
    l_ax            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    LET g_action_choice = ""
    IF g_fch.fch01 IS NULL THEN RETURN END IF
    LET l_faj_t.* = l_faj[1].*
 
  #  LET g_forupd_sql = " SELECT * FROM faj_temp ",
  #                     " WHERE faj02 = l_faj_t.faj02  ",
  #                     " AND faj022= l_faj_t.faj022 ",
  #                     " FOR UPDATE "
  #  DECLARE t800_bclx CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t =  0
  #  LET l_allow_insert = cl_detail_input_auth("insert")
  #  LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY l_faj WITHOUT DEFAULTS FROM s_faj.*
          ATTRIBUTE(COUNT=g_rec_b,INSERT ROW=FALSE ,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ac)
 
       # BEFORE ROW
       #     LET l_ax = ARR_CURR()          #目前筆數
       #                                    #cursor 實際上停留在all data 中的
       #                                    #第幾筆
       #     LET l_faj_t.* = l_faj[l_ax].*  #BACKUP
       #     LET l_lock_sw = 'N'            #DEFAULT
       #     LET l_n  = ARR_COUNT()         #目前的array共有幾筆
       #     BEGIN WORK
 
#            OPEN t800_cl USING g_fch.fch01
#            IF STATUS THEN
#               CALL cl_err("OPEN t800_cl:", STATUS, 1)
#               CLOSE t800_cl
#               ROLLBACK WORK
#               RETURN
#            END IF
#            FETCH t800_cl INTO g_fch.*              # 鎖住將被更改或取消的資料
#            IF SQLCA.sqlcode THEN
#               CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)      # 資料被他人LOCK
#               CLOSE t800_cl ROLLBACK WORK RETURN
#            END IF
#            #IF l_faj_t.faj02 IS NOT NULL THEN
#            IF g_rec_b>=l_ax THEN
#                LET p_cmd='u'
 
#               OPEN t800_bclx USING l_faj_t.faj02,l_faj_t.faj022
#               IF STATUS THEN
#                  CALL cl_err("OPEN t800_bcl:", STATUS, 1)
#                  CLOSE t800_bclx
#                  ROLLBACK WORK
#                  RETURN
#               ELSE
#                  FETCH t800_bclx INTO l_faj[l_ax].*
#                  IF SQLCA.sqlcode THEN
#                     CALL cl_err(l_faj[l_ax].faj02,SQLCA.sqlcode,1)
#                     LET l_lock_sw = "Y"
#                  END IF
#               END IF
#           END IF
#           NEXT FIELD fajyn
 
          ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET l_faj[l_ax].* = l_faj_t.*
#                CLOSE t800_bclx
#                ROLLBACK WORK
                 EXIT INPUT
              END IF
         #    IF l_lock_sw = 'Y' THEN
         #       CALL cl_err(l_faj[l_ax].faj02,-263,1)
         #       LET l_faj[l_ax].* = l_faj_t.*
         #    ELSE
                 IF l_faj[l_ax].faj02 IS NOT NULL THEN
                    UPDATE faj_temp SET fajyn = l_faj[l_ax].fajyn
                     WHERE faj02 = l_faj[l_ax].faj02
                       AND faj022 = l_faj[l_ax].faj022
                    IF SQLCA.sqlcode THEN
#                       CALL cl_err(l_faj[l_ax].faj02,SQLCA.sqlcode,0)   #No.FUN-660136
                        CALL cl_err3("upd","faj_temp",l_faj[l_ax].faj02,l_faj[l_ax].faj022,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                        LET l_faj[l_ax].* = l_faj_t.*
                    ELSE
                        MESSAGE 'UPDATE O.K'
                     #   COMMIT WORK
                    END IF
                 END IF
         #    END IF
 
     #    AFTER ROW
     #        LET l_ax = ARR_CURR()
     #        IF INT_FLAG THEN
     #           CALL cl_err('',9001,0)
     #           LET INT_FLAG = 0
     #           LET l_faj[l_ax].* = l_faj_t.*
     #           CLOSE t800_bclx
     #           ROLLBACK WORK
     #           EXIT INPUT
     #        END IF
     #        LET l_faj_t.* = l_faj[l_ax].*
     #        CLOSE t800_bclx
     #        COMMIT WORK
 
         #ON ACTION select_cancel
         #   IF l_faj[l_ax].fajyn = 'Y' THEN
         #      LET l_faj[l_ax].fajyn = 'N'
         #   ELSE
         #      LET l_faj[l_ax].fajyn = 'Y'
         #   END IF
         #   NEXT FIELD fajyn
 
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
   #     CLOSE t800_cl
   #     CLOSE t800_bclx
   #     COMMIT WORK
   #str MOD-B30136 add
    IF INT_FLAG THEN
       LET INT_FLAG=0 
       DELETE FROM faj_temp
    END IF
   #end MOD-B30136 add
 
END FUNCTION
 
FUNCTION t800_putb()             # 將 faj_temp 中[Y] 者新增至單身檔中
DEFINE
    l_maxac         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    p_faj           RECORD    #程式變數(Program Variables)
        faj02       LIKE faj_file.faj02,   #財產編號
        faj022      LIKE faj_file.faj022,  #附號
        faj26       LIKE faj_file.faj26,   #入帳日期
        faj51       LIKE faj_file.faj51,   #發票號碼
        faj17       LIKE faj_file.faj17,   #數量
        faj18       LIKE faj_file.faj18,   #單位
        faj14       LIKE faj_file.faj14,   #成本
        faj06       LIKE faj_file.faj06,   #中文名稱
        faj07       LIKE faj_file.faj07    #英文名稱
                    END RECORD
   DEFINE l_faj0    RECORD
        faj08  like faj_file.faj08,
        faj10  like faj_file.faj10, #TQC-980109
        faj11  like faj_file.faj11,
        faj47  like faj_file.faj47,
        faj49  like faj_file.faj49,
        faj15 like faj_file.faj15,
        faj491 like faj_file.faj491,
        faj511 like faj_file.faj511
                    END RECORD
  DEFINE l_buy_date LIKE type_file.dat          #No.FUN-680070 date
  DEFINE ch char
 
    DECLARE t800_putb CURSOR FOR
     SELECT faj02,faj022,faj26,faj51,faj17,faj18,faj14,faj06,faj07
       FROM faj_temp
      WHERE fajyn  = 'Y'
 
    SELECT max(fci02)+1 INTO l_ac FROM fci_file
    WHERE fci01 = g_fch.fch01
 IF l_ac IS NULL THEN LET l_ac = 1 END IF
 FOREACH t800_putb INTO p_faj.*
    IF SQLCA.sqlcode THEN
       CALL cl_err('foreach:',SQLCA.sqlcode,1)
       EXIT FOREACH
     END IF
     SELECT faj08,faj10,faj11,faj47,faj49,faj15,faj491,faj511 into l_faj0.* #TQC-980109 add faj10
            from faj_file
     WHERE faj02=p_faj.faj02 and
           faj022=p_faj.faj022
     IF l_faj0.faj15="NTD"
        then let l_buy_date =l_faj0.faj511
        else let l_buy_date =l_faj0.faj491
     END IF
     IF l_buy_date IS NOT NULL
        then let p_faj.faj26 = l_buy_date
     END IF
        IF p_faj.faj17 IS NULL THEN LET p_faj.faj17 = 0 END IF
        IF p_faj.faj14 IS NULL THEN LET p_faj.faj14 = 0 END IF
       INSERT INTO fci_file(fci01,fci02,fci03,fci031,fci17,fci11,fci09,
                            fci10,fci15,fci04,fci05,fci18,fci19,fci07,fci071,
                            #---- jeffery add on 96/10/22 ----#
                            fci06,fci08,fci13,fci12,fci20,fci21,fci22,fcilegal) #FUN-980003 add
                            #---- jeffery add on 96/10/22 ----#
            VALUES(g_fch.fch01,l_ac,p_faj.*,'1','1','','',
                        #l_faj0.faj08 thru l_faj0.faj49,p_faj.faj17, #TQC-980109                                                    
                         l_faj0.faj08,l_faj0.faj10,l_faj0.faj47,l_faj0.faj49,p_faj.faj17, #TQC-980109   
                         p_faj.faj18,p_faj.faj14,g_legal) #FUN-980003 add
        IF sqlca.sqlcode = 0  THEN
           LET l_ac = l_ac + 1
        END IF
     END FOREACH
     LET l_maxac = l_ac - 1
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
END FUNCTION
 
FUNCTION t800_bpx(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_faj TO s_faj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ac = ARR_CURR()
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
     #ON ACTION insert
     #   LET g_action_choice="insert"
     #   EXIT DISPLAY
     #ON ACTION query
     #   LET g_action_choice="query"
     #   EXIT DISPLAY
     #ON ACTION delete
     #   LET g_action_choice="delete"
     #   EXIT DISPLAY
     #ON ACTION modify
     #   LET g_action_choice="modify"
     #   EXIT DISPLAY
      ON ACTION first
            CALL t800_fetch('F')
         LET g_action_choice="first"
         EXIT DISPLAY
      ON ACTION previous
      ON ACTION jump
         LET g_action_choice="jump"
         EXIT DISPLAY
      ON ACTION next
      ON ACTION last
         LET g_action_choice="last"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t800_b_fillx()              #BODY FILL UP 將暫存檔中的資料顯示出來
    DECLARE faj_curs CURSOR FOR SELECT * FROM faj_temp #SCROLL CURSOR
 
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH faj_curs INTO l_faj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    LET g_rec_b = g_cnt -1
END FUNCTION
 
function t800_get_fai(p_code)
  define p_code LIKE fai_file.fai01         #No.FUN-680070 VARCHAR(20)
  define aa LIKE fai_file.fai02             #No.FUN-680070 VARCHAR(30)
  select fai02 into aa from fai_file
         where fai01=p_code and
               faiacti="Y"
  if sqlca.sqlcode <>0
     then let aa = p_code
  end if
  return aa
end function
# --------------------------------------------------------------
FUNCTION t800_get_fci17(p_faj02,p_faj022)
DEFINE p_faj02  LIKE faj_file.faj02,
       p_faj022 LIKE faj_file.faj022,
       l_faj15  LIKE faj_file.faj15 ,
       l_faj491 LIKE faj_file.faj491,
       l_faj511 LIKE faj_file.faj511,
       l_buy_date LIKE type_file.dat          #No.FUN-680070 date
 
     SELECT faj15,faj491,faj511 into l_faj15,l_faj491,l_faj511
            from faj_file
     WHERE faj02=p_faj02 and
           faj022=p_faj022
     IF l_faj15="NTD"
        then let l_buy_date =l_faj511
        else let l_buy_date =l_faj491
     END IF
     IF l_buy_date is not null
        THEN RETURN l_buy_date
     ELSE
        RETURN ''
     END IF
END FUNCTION
 
#FUNCTION t800_x()                       #FUN-D20035
FUNCTION t800_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fch.* FROM fch_file WHERE fch01=g_fch.fch01
   IF g_fch.fch01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fch.fchconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_fch.fchconf ='X' THEN RETURN END IF
   ELSE
      IF g_fch.fchconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t800_cl USING g_fch.fch01
   IF STATUS THEN
      CALL cl_err("OPEN t800_cl:", STATUS, 1)
      CLOSE t800_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t800_cl INTO g_fch.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fch.fch01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t800_cl ROLLBACK WORK RETURN
   END IF
  #-->作廢轉換01/08/02
  #IF cl_void(0,0,g_fch.fchconf)   THEN                                #FUN-D20035
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
   IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
        LET g_chr=g_fch.fchconf
       #IF g_fch.fchconf ='N' THEN                                     #FUN-D20035
        IF p_type = 1 THEN                                             #FUN-D20035 
            LET g_fch.fchconf='X'
        ELSE
            LET g_fch.fchconf='N'
        END IF
   UPDATE fch_file SET fchconf = g_fch.fchconf,fchmodu=g_user,fchdate=TODAY
          WHERE fch01 = g_fch.fch01
   IF STATUS THEN CALL cl_err('upd fchconf:',STATUS,1) LET g_success='N' END IF
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
 
   SELECT fchconf INTO g_fch.fchconf FROM fch_file
    WHERE fch01 = g_fch.fch01
   DISPLAY BY NAME g_fch.fchconf
  END IF
  #CKP
  IF g_fch.fchconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  CALL cl_set_field_pic(g_fch.fchconf,"","","",g_chr,"")
END FUNCTION
 
#Patch....NO.MOD-5A0095 <001> #


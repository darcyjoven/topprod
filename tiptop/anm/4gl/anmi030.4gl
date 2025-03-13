# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: anmi030.4gl
# Descriptions...: 銀行帳戶建立作業
# Date & Author..: 92/05/01 By Lin
#                : 96/06/10 By Lynn  銀行編號由6碼改為11碼
#                : 96/06/14 By Lynn  輸入銀行帳戶資料後,
# Modify.........: 00/05/11 By Kammy 支票簿號相關資料輸入改多欄式。
# Modify.........: 04/07/20 By Wiky  NO.MOD-470446 單身新增輸入有錯
# Modify.........: No.FUN-4B0008 04/11/02 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0098 04/12/21 By pengu  報表轉XML
# Modify.........: No.MOD-510122 05/03/09 By Kitty 無法連續複製
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-590459 05/09/29 By Smapmin 存款幣別列印有誤
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.TQC-610136 06/03/06 By Smapmin 支票號碼放大到15
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/15 By ice 兩套帳功能修改 
# Modify.........: No.FUN-680107 06/09/07 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0011 06/10/04 By jamie 1.FUNCTION i030_q() 一開始應清空g_nma.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-690090 06/10/17 By hongme 內部帳戶功能新增 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modify.........: No.MOD-690073 06/12/01 By Smapmin 列印出來的資料長度依照資料庫定義的大小
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730032 07/03/22 By chenl   網絡銀行功能，此程序新增nma39-nma43，nmt02共6個字段。
# Modify.........: No.FUN-730020 07/04/02 By chenl   會計科目加帳套
# Modify.........: No.TQC-740024 07/04/06 By Judy 單身無法復制
# Modify.........: No.MOD-750037 07/05/14 By Smapmin 增加與anmi101的同步控管
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-770151 07/08/06 By Smapmin 修改entry/no entry控管
# Modify.........: No.CHI-7C0024 07/12/19 By Smapmin 後幾位連續位數必須小於長度
# Modify.........: No.FUN-7C0043 07/12/27 By Cockroach 報表改為p_query實現
# Modify.........: No.FUN-7C0050 08/01/15 By Johnray 增加接收參數段for串查 
# Modify.........: No.FUN-850038 08/05/13 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.MOD-840696 08/05/19 By Sarah 複製功能不複製單身
# Modify.........: No.FUN-870067 08/07/15 By douzh 新增匯豐銀行接口
# Modify.........: NO.FUN-870037 08/09/23 by Yiting 網銀欄位增加 
# Modify.........: No.FUN-8B0123 08/12/01 By hongmei 修改單身顯示問題
# Modify.........: No.TQC-940051 09/04/22 By Cockroach 當資料有效碼（nmaaacti)='N'時，不可刪除資料！ 
# Modify.........: No.MOD-960180 09/06/16 By baofei 刪除時增加提示信息‘anm-130’ 
# Modify.........: No.FUN-960141 09/06/26 By dongbg GP5.2修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.TQC-9A0018 09/10/09 By wujie nma45,nma46預設為N
# Modify.........: No.TQC-970256 09/10/10 By baofei 單身'后幾位連續編號'不可大于'長度' 
# Modify.........: No:MOD-9A0171 09/10/27 By mike Anmi030应检查有无nme_file,或anmt100 的资料若已存在资料(非作废)则不可修改存款币别．
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-970077 10/03/04 By chenmoyan add action
# Modify.........: No:FUN-A20010 10/03/04 By chenmoyan mark action
# Modify.........: No:FUN-A30030 10/03/15 By Cockroach err_msg:aim-944-->art-648
# Modify.........: No:TQC-A90141 10/09/28 By xiaofeizhu 複製處修改BUG
# Modify.........: No:FUN-B20004 11/02/09 By destiny 科目查询自动过滤
# Modify.........: No:FUN-B30213 11/04/06 By lixia 增加接口銀行編碼和名稱
# Modify.........: No:FUN-B50042 11/05/03 by jason 已傳POS否狀態調整
# Modify.........: No:MOD-B50198 11/05/23 by jason nma45預設值為1,不可NULL
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60073 11/06/15 By zhangweib 給nna06默認值'N'
# Modify.........: No.TQC-B60074 11/06/15 By zhangweib 下次打印票號的長度要和單身設置的長度一致,更新報錯信息
# Modify.........: No.TQC-B80030 11/08/03 By lixia 複製時存款類型欄位未檢查正確性
# Modify.........: No.TQC-B80034 11/08/03 By lixia 銀行帳號控管唯一性
# Modify.........: No.MOD-BA0073 11/10/12 By Dido 銀行帳號控管限定地區別 
# Modify.........: No.MOD-BB0143 11/11/11 By yinhy 用于POS結款單時下傳銀行用，目前系統沒有做此功能，暫時無條件隱藏
# Modify.........: No.TQC-BB0245 11/11/29 By yinhy 字段nma41"原幣期初餘額"、nma42“本幣期初餘額”可以輸入負數，增加控管
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:TQC-C20251 12/03/05 By yinhy 狀態頁簽的“資料建立者”“資料建立部門”無法下查詢條件查詢
# Modify.........: No.MOD-C30412 12/03/12 By wangrr ann03欄位加控管
# Modify.........: No:MOD-C30685 12/03/30 By Polly 增加控卡，當anmt302已有使用到銀行編號，則anmi030不可刪除
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C50166 12/05/30 By xuxz nma43開啟時機調整
# Modify.........: No:FUN-C80018 12/08/06 By minpp 大陸版時如果anmi030沒有維護單身時，anmt100單頭的簿號和支票號碼可以手動輸入
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-CB0076 12/11/23 By xuxz 顯示存款類型名稱
# Modify.........: No:FUN-CB0012 13/01/04 By apo 顯示會計科目名稱
# Modify.........: No:MOD-D30272 13/04/01 By Alberti 錯誤訊息 anm-252 條件增加取票日期 nmd54 = g_nna_t.nna021
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nma   RECORD LIKE nma_file.*,
    g_nmb02 LIKE nmb_file.nmb02,#TQC-CB0076 add
    g_nma_t RECORD LIKE nma_file.*,
    g_nma_o RECORD LIKE nma_file.*,
    g_nna           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        nna06       LIKE nna_file.nna06,       #
        nna021      LIKE nna_file.nna021,      #
        nna02       LIKE nna_file.nna02,       #
        nna04       LIKE nna_file.nna04,       #
        nna03       LIKE nna_file.nna03,       #
        nna05       LIKE nna_file.nna05        #
                    END RECORD,
    g_nna_t        RECORD                      #程式變數(Program Variables)
        nna06       LIKE nna_file.nna06,       #
        nna021      LIKE nna_file.nna021,      #
        nna02       LIKE nna_file.nna02,       #
        nna04       LIKE nna_file.nna04,       #
        nna03       LIKE nna_file.nna03,       #
        nna05       LIKE nna_file.nna05        #
                    END RECORD,
    g_nma01_t LIKE nma_file.nma01,             #供應廠商編號
    g_dbs_gl        LIKE type_file.chr21,      #No.FUN-680107 VARCHAR(21)
    g_plant_gl      LIKE type_file.chr10,      #No.FUN-980025 VARCHAR(10)
    g_wc,g_sql,g_wc2       STRING              #TQC-630166
 
DEFINE g_forupd_sql        STRING              #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5   #No.FUN-680107 SMALLINT
DEFINE g_chr        LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
DEFINE g_cnt        LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_i          LIKE type_file.num5        #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg        LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(72)
DEFINE g_rec_b      LIKE type_file.num10       #No.FUN-680107 INTEGER
#DEFINE g_rec_b1     LIKE type_file.num10      #No.FUN-970077 #FUN-A20010 mark
#DEFINE g_rec_b2     LIKE type_file.num10      #No.FUN-970077 #FUN-A20010 mark
#DEFINE g_row_count1  LIKE type_file.num10      #No.FUN-970077 #FUN-A20010 mark
#DEFINE g_curs_index1 LIKE type_file.num10      #No.FUN-970077 #FUN-A20010 mar7
#DEFINE g_jump1       LIKE type_file.num10      #No.FUN-970077 #FUN-A20010 mar7
DEFINE l_ac         LIKE type_file.num5        #No.FUN-680107 SMALLINT
DEFINE g_row_count  LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_curs_index LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE g_jump       LIKE type_file.num10       #No.FUN-680107 INTEGER
DEFINE mi_no_ask    LIKE type_file.num5        #No.FUN-680107 SMALLINT
DEFINE g_cnt2       LIKE type_file.num10   #MOD-750037
DEFINE g_argv1     LIKE nma_file.nma01     #FUN-7C0050
DEFINE g_argv2     STRING                  #FUN-7C0050      #執行功能
DEFINE g_aag02      LIKE aag_file.aag02        #FUN-CB0012
#FUN-A20010 --Begin
#FUN-970077---Begin
#DEFINE
#    g_nnc01         LIKE nnc_file.nnc01,
#    g_nnc01_t       LIKE nnc_file.nnc01,
#    g_nnc           DYNAMIC ARRAY OF RECORD
#        nnc02       LIKE nnc_file.nnc02,
#        nnc03       LIKE nnc_file.nnc03
#                    END RECORD,
#    g_nnc_t         RECORD
#        nnc02       LIKE nnc_file.nnc02,
#        nnc03       LIKE nnc_file.nnc03
#                    END RECORD
#DEFINE g_flag       LIKE type_file.chr1
#DEFINE g_wc3        STRING
##FUN-970077---End
#FUN-A20010 --END mark
MAIN
DEFINE p_row,p_col  LIKE type_file.num5        #No.FUN-680107 SMALLINT
 
   OPTIONS                                     #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                             #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   LET g_argv1=ARG_VAL(1)   #           #FUN-7C0050
   LET g_argv2=ARG_VAL(2)   #執行功能   #FUN-7C0050
   INITIALIZE g_nma.* TO NULL
   INITIALIZE g_nma_t.* TO NULL
   INITIALIZE g_nna_t.* TO NULL
   INITIALIZE g_nma_o.* TO NULL
   LET g_plant_new = g_nmz.nmz02p
   LET g_plant_gl  = g_nmz.nmz02p  #No.FUN-980025
   DISPLAY "g_plant_new",g_plant_new
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
 
   LET g_forupd_sql = "SELECT * FROM nma_file WHERE nma01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i030_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 3 LET p_col = 6
   OPEN WINDOW i030_w AT p_row,p_col
     WITH FORM "anm/42f/anmi030"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("nma051",g_aza.aza63='Y')
    #CALL cl_set_comp_visible("nma45",g_aza.aza88='Y') #NO.FUN-B50042
    CALL cl_set_comp_visible("nma45",FALSE)            #NO.FUN-B50042
    #CALL cl_set_comp_visible("nma46",g_aza.aza88='Y') #NO.MOD-BB0143
    CALL cl_set_comp_visible("nma46",FALSE)            #No.MOD-BB0143
 
 
   IF g_aza.aza26 <> '2' THEN  
       CALL cl_set_comp_visible("nma40,nma41,nma42,nma43",FALSE)
   END IF
 
   IF g_aza.aza26 = '2' AND g_aza.aza73 = 'Y' THEN 
       CALL cl_set_act_visible("balance",TRUE) 
   ELSE
       CALL cl_set_act_visible("balance",FALSE) 
   END IF
   
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i030_a()
            END IF
         OTHERWISE        
            CALL i030_q() 
      END CASE
   END IF
 
   CALL i030_menu()
   CLOSE WINDOW i030_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION i030_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_nna.clear()
   LET g_wc =''
   LET g_wc2=''
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INITIALIZE g_nma.* TO NULL    #No.FUN-750051
   IF g_argv1<>' ' THEN                     #FUN-7C0050
      LET g_wc=" nma01='",g_argv1,"'"       #FUN-7C0050
      LET g_wc2=" 1=1"                      #FUN-7C0050
   ELSE
   CONSTRUCT BY NAME g_wc ON nma01,nma02,nma03,nma061,nma07,nma08,
                             nma21,nma46,nma09,nma10,nma28,nma05,nma051, #FUN-960141 #NO.FUN-B50042
                             nma12,nma37,nma38,  #No.FUN-680034 #No.FUN-690090
                             nma39,nma04,nma44,nma40,nma41,nma42,nma43,nma47,#FUN-B30213 #No.FUN-730032   #FUN-870037
                             nmauser,nmagrup,nmamodu,nmadate,nmaacti,
                             nmaoriu,nmaorig,                            #TQC-C20251
                             nmaud01,nmaud02,nmaud03,nmaud04,nmaud05,
                             nmaud06,nmaud07,nmaud08,nmaud09,nmaud10,
                             nmaud11,nmaud12,nmaud13,nmaud14,nmaud15
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
      ON ACTION controlp
         CASE
            WHEN INFIELD(nma05) # Act code
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nma.nma05,'23',g_aza.aza81) #No.FUN-980025
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nma05
              #FUN-CB0012--add--str
               LET g_nma.nma05 = g_qryparam.multiret
               SELECT aag02 INTO g_aag02 FROM aag_file 
                WHERE aag01 = g_nma.nma05 AND aag00 = g_aza.aza81
               IF SQLCA.SQLCODE THEN LET g_aag02 = ' ' END IF
               DISPLAY g_aag02 TO aag02
              #FUN-CB0012--add--end
               NEXT FIELD nma05
 
            WHEN INFIELD(nma051) # Act code
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nma.nma051,'23',g_aza.aza82)  #No.FUN-980025
                    RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nma051
               
               NEXT FIELD nma051
 
            WHEN INFIELD(nma09) #查詢存款類別
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_nmb"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nma09
               NEXT FIELD nma09
            WHEN INFIELD(nma10) #查詢存款幣別
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form = "q_azi"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nma10
               NEXT FIELD nma10
            WHEN INFIELD (nma39)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_nmt"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING  g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO num39
               NEXT FIELD nma39
            #FUN-B30213--add--str--
            WHEN INFIELD (nma47)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_noc"
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING  g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO nma47
               NEXT FIELD nma47
            #FUN-B30213--add--end--
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
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
   END CONSTRUCT
 
    IF INT_FLAG THEN RETURN END IF
display 'g_wc:',g_wc
   LET g_nna[1].nna06 = ''
    CONSTRUCT g_wc2 ON nna06,nna021,nna02,nna03,nna04,nna05
         FROM s_nna[1].nna06,s_nna[1].nna021,s_nna[1].nna02,
              s_nna[1].nna03,s_nna[1].nna04,s_nna[1].nna05
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
display 'g_wc2:',g_wc2
 
   IF INT_FLAG THEN
      RETURN
   END IF
  END IF  #FUN-7C0050
 
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
 
 
   IF g_wc2=" 1=1" THEN
      LET g_sql="SELECT nma01 FROM nma_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY nma01"
   ELSE
      LET g_sql="SELECT UNIQUE nma01",
                "  FROM nma_file,nna_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED,
                "   AND nma01 = nna01 ",
                " ORDER BY nma01"
   END IF
 
   PREPARE i030_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i030_cs                           # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i030_prepare
 
   IF g_wc2=" 1=1" THEN
      LET g_sql = "SELECT COUNT(DISTINCT nma01) FROM nma_file WHERE ",
                   g_wc CLIPPED
   ELSE
      LET g_sql = "SELECT COUNT(DISTINCT nma01) FROM nma_file,nna_file ",
                  " WHERE nma01 = nna01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
   END IF
   PREPARE i030_recount FROM g_sql
   DECLARE i030_count CURSOR FOR i030_recount
 
END FUNCTION
 
FUNCTION i030_menu()
   DEFINE   l_cmd   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(30)
 
   WHILE TRUE
      CALL i030_nna_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i030_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i030_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i030_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i030_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i030_x()
            END IF
            CALL cl_set_field_pic("","","","","",g_nma.nmaacti)
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i030_copy()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i030_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i030_nna_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nna),'','')
            END IF
#FUN-A20010 --Begin mark
#        #FUN-970077---Begin
#        WHEN "remitting_type"
#           IF cl_chk_act_auth() THEN
#              IF NOT cl_null(g_nma.nma01) THEN
#                 CALL i030_1()
#              END IF
#           END IF
#        #FUN-970077---End
#FUN-A20010 --End mark
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_nma.nma01 IS NOT NULL THEN
                 LET g_doc.column1 = "nma01"
                 LET g_doc.value1 = g_nma.nma01
                 CALL cl_doc()
               END IF
           END IF
         WHEN "balance"
           IF cl_chk_act_auth() THEN 
              IF NOT cl_null(g_nma.nma01) THEN 
                 LET l_cmd = "anmq301 '",g_nma.nma01,"' '",g_nma.nma39,"' "      #No.FUN-870067
                 CALL cl_cmdrun(l_cmd CLIPPED)
              END IF 
           END IF 
      END CASE
   END WHILE
   CLOSE i030_cs
END FUNCTION
 
FUNCTION i030_a()
 DEFINE l_n LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN
      RETURN
   END IF                #檢查權限
 
   MESSAGE ""
   CLEAR FORM                                  # 清螢幕欄位內容
   CALL g_nna.clear()
   INITIALIZE g_nma.* LIKE nma_file.*
   LET g_nma01_t = NULL
   LET g_nma.nma10=g_aza.aza17
   LET g_nma.nma22=0
   LET g_nma.nma23=0
   LET g_nma.nma27=0
   LET g_nma.nma24=0
   LET g_nma.nma25=0
   LET g_nma.nma37=1                              #No.FUN-690090   
   LET g_nma.nma43='N'                            #No.FUN-730032
   #LET g_nma.nma45='N'                           #No.FUN-960141 #NO.FUN-B50042
   LET g_nma.nma45='1'                            #No.MOD-B50198   
   LET g_nma.nma46='N'                            #No.FUN-960141
   LET g_nma_o.* = g_nma.*                        # 保留舊值
   LET g_nma_t.* = g_nma.*                        # 保留舊值
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_nma.nmaacti = 'Y'                 # 有效的資料
      LET g_nma.nmauser = g_user                # 使用者
      LET g_nma.nmaoriu = g_user #FUN-980030
      LET g_nma.nmaorig = g_grup #FUN-980030
      LET g_nma.nmagrup = g_grup              # 使用者所屬群
      LET g_nma.nmadate = g_today                # 更改日期
 
      CALL i030_i("a")                     # 各欄位輸入
 
      IF INT_FLAG THEN                        # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_nma.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_nna.clear()
         EXIT WHILE
      END IF
 
      IF g_nma.nma01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #LET g_nma.nma45 ='N' #NO.FUN-B50042
      LET g_nma.nma45 ='1'  #No.MOD-B50198
      LET g_nma.nma46 ='N'
      INSERT INTO nma_file VALUES(g_nma.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","nma_file",g_nma.nma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      ELSE
         LET g_nma_t.* = g_nma.*              # 保存上筆資料
         SELECT nma01 INTO g_nma.nma01 FROM nma_file
          WHERE nma01 = g_nma.nma01 AND  g_nma.nma37 <> 2 
      END IF
 
      IF g_nma.nma28 = '1' THEN
         LET g_rec_b=0
         CALL i030_nna_b()
         SELECT COUNT(*) INTO l_n FROM nna_file
          WHERE nna01=g_nma.nma01
         #IF l_n = 0 THEN                            #FUN-C80018
          IF l_n = 0 AND g_aza.aza26!='2' THEN       #FUN-C80018
            CALL cl_err(g_nma.nma01,'anm-953',1)
          END IF
      END IF
      
      EXIT WHILE
   END WHILE
   LET g_wc=' '
 
END FUNCTION
 
FUNCTION i030_i(p_cmd)
DEFINE
   p_cmd           LIKE type_file.chr1,    #狀態  #No.FUN-680107 VARCHAR(1)
   l_flag          LIKE type_file.chr1,    #是否必要欄位有輸入  #No.FUN-680107 VARCHAR(1)
   l_direct        LIKE type_file.chr1,    #INPUT的方向 #No.FUN-680107 VARCHAR(1)
   l_cmd           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(30)
   l_sql           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(300)
   l_nmw03         LIKE nmw_file.nmw03,
   l_nmw04         LIKE nmw_file.nmw04,
   l_nmw05         LIKE nmw_file.nmw04,
   g_msg           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(80)
   l_n,l_cnt,l_n_min,l_n_max  LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE    l_nmt09  LIKE nmt_file.nmt09     #No.FUN-730032      
DEFINE    l_nmt12  LIKE nmt_file.nmt12     #No.FUN-730032
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   INPUT BY NAME g_nma.nma01,g_nma.nma02,g_nma.nma03,g_nma.nma061, g_nma.nmaoriu,g_nma.nmaorig,
                 g_nma.nma07,g_nma.nma08,
                 #g_nma.nma04,   #FUN-870037 mark
                 g_nma.nma09,g_nma.nma10,g_nma.nma28,
                 g_nma.nma05,g_nma.nma051,g_nma.nma12, g_nma.nma21,
                 g_nma.nma46,   #FUN-960141 add #NO.FUN-B50042
                 g_nma.nma37,g_nma.nma38,   #No.FUN-680034 #No.FUN-690090
                 g_nma.nma43,g_nma.nma40,
                 g_nma.nma39, 
                 g_nma.nma04,  #FUN-870037 
                 g_nma.nma44,  #FUN-870037
                 g_nma.nma41,g_nma.nma42,g_nma.nma47,  #FUN-B30213  #No.FUN-730032
                 g_nma.nmauser,   #No.FUN-680034 #No.FUN-690090
                 g_nma.nmagrup,g_nma.nmamodu,g_nma.nmadate,g_nma.nmaacti,
                 g_nma.nmaud01,g_nma.nmaud02,g_nma.nmaud03,g_nma.nmaud04,
                 g_nma.nmaud05,g_nma.nmaud06,g_nma.nmaud07,g_nma.nmaud08,
                 g_nma.nmaud09,g_nma.nmaud10,g_nma.nmaud11,g_nma.nmaud12,
                 g_nma.nmaud13,g_nma.nmaud14,g_nma.nmaud15
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i030_set_entry(p_cmd)
         CALL i030_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
          #TQC-C50166--add--str
         IF g_aza.aza73 = 'N' THEN
            CALL cl_set_comp_entry("nma43,nma39,nma40,nma41,nma42,nma47",FALSE)
         ELSE
            CALL cl_set_comp_entry("nma43",TRUE)
         END IF
        #TQC-C50166--add--end
 
      AFTER FIELD nma01
         IF NOT cl_null(g_nma.nma01) THEN          #銀行編號
            IF p_cmd = "a" OR (p_cmd = "u" AND g_nma.nma01 != g_nma01_t) THEN
               SELECT COUNT(*) INTO l_n FROM nma_file
                WHERE nma01 = g_nma.nma01
               IF l_n > 0 THEN
                  CALL cl_err(g_nma.nma01,-239,0)
                  LET g_nma.nma01 = g_nma01_t
                  DISPLAY BY NAME g_nma.nma01
                  NEXT FIELD nma01
               END IF
            END IF
         END IF
 
      BEFORE FIELD nma03  #default 全名=簡稱
         IF (g_nma.nma03) IS NULL AND g_nma.nma02 IS NOT NULL THEN
            LET g_nma.nma03=g_nma.nma02
            DISPLAY BY NAME g_nma.nma03
         END IF
 
      AFTER FIELD nma03 
         IF NOT cl_null(g_nma.nma03) AND g_nma_t.nma03 <> g_nma.nma03 THEN
             IF cl_null(g_nma.nma44) THEN
                 LET g_nma.nma44 = g_nma.nma03
                 DISPLAY BY NAME g_nma.nma44
             END IF
         END IF

      #TQC-B80034--add--str--
      AFTER FIELD nma04
        IF NOT cl_null(g_nma.nma04) THEN
           IF (g_nma_o.nma04 IS NULL) OR (g_nma.nma04 != g_nma_o.nma04) THEN
              CALL i030_nma04('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nma.nma04,g_errno,0)
                 LET g_nma.nma04 = g_nma_o.nma04
                 DISPLAY BY NAME g_nma.nma04
                 NEXT FIELD nma04
              END IF
           END IF
           LET g_nma_o.nma04=g_nma.nma04
         END IF
      #TQC-B80034--add--end--
 
      AFTER FIELD nma05    #會計科目
         IF g_nmz.nmz02 = 'Y' THEN
            CALL s_m_aag(g_nmz.nmz02p,g_nma.nma05,g_aza.aza81) RETURNING g_msg   #FUN-990069  
            IF NOT cl_null(g_errno) THEN
              #CALL cl_err(g_nma.nma05,g_errno,0)  #FUN-CB0012 mark
               #FUN-B20004--begin
               IF NOT cl_null(g_nma.nma05) THEN   
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nma.nma05,'23',g_aza.aza81)  
                    RETURNING g_nma.nma05       
               END If         
               CALL cl_err(g_nma.nma05,g_errno,0)  #FUN-CB0012
               #LET g_nma.nma05 = g_nma_o.nma05
               #FUN-B20004--end
              #FUN-CB0012--add--str 
               SELECT aag02 INTO g_aag02 FROM aag_file
                WHERE aag01 = g_nma.nma05 AND aag00 = g_aza.aza81
               IF SQLCA.SQLCODE THEN LET g_aag02 = ' ' END IF
               DISPLAY g_aag02 TO aag02
              #FUN-CB0012--add--end
               DISPLAY BY NAME g_nma.nma05
               NEXT FIELD nma05
            END IF
            ERROR g_msg
         END IF
         LET g_nma_o.nma05=g_nma.nma05
        #FUN-CB0012--add--str 
         SELECT aag02 INTO g_aag02 FROM aag_file 
          WHERE aag01 = g_nma.nma05 AND aag00 = g_aza.aza81
         IF SQLCA.SQLCODE THEN LET g_aag02 = ' ' END IF
         DISPLAY g_aag02 TO aag02
        #FUN-CB0012--add--end
 
      AFTER FIELD nma051   #會計科目
         IF g_nmz.nmz02 = 'Y' THEN
            CALL s_m_aag(g_nmz.nmz02p,g_nma.nma051,g_aza.aza82) RETURNING g_msg   #FUN-990069 
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nma.nma051,g_errno,0)
               #FUN-B20004--begin
               IF NOT cl_null(g_nma.nma051) THEN   
                  CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nma.nma051,'23',g_aza.aza82)  
                    RETURNING g_nma.nma051       
               END IF         
               #LET g_nma.nma051 = g_nma_o.nma051
               #FUN-B20004--end               
               DISPLAY BY NAME g_nma.nma051
               NEXT FIELD nma051
            END IF
            ERROR g_msg
         END IF
         LET g_nma_o.nma051=g_nma.nma051
 
      AFTER FIELD nma09    #存款類別
         IF NOT cl_null(g_nma.nma09) THEN
            IF (g_nma_o.nma09 IS NULL) OR (g_nma.nma09 != g_nma_o.nma09) THEN
               CALL i030_nma09('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nma.nma09,g_errno,0)
                  LET g_nma.nma09 = g_nma_o.nma09
                  DISPLAY BY NAME g_nma.nma09
                 #TQC-CB0076--add--str
                  SELECT nmb02 INTO g_nmb02 FROM nmb_file WHERE nmb01 = g_nma.nma09
                  IF SQLCA.SQLCODE THEN LET g_nmb02 = ' ' END IF
                  DISPLAY g_nmb02 TO nmb02
                 #TQC-CB0076--add--end
                  NEXT FIELD nma09
               END IF
            END IF
            LET g_nma_o.nma09=g_nma.nma09
            #TQC-CB0076--add--str
            SELECT nmb02 INTO g_nmb02 FROM nmb_file WHERE nmb01 = g_nma.nma09
            IF SQLCA.SQLCODE THEN LET g_nmb02 = ' ' END IF
            DISPLAY g_nmb02 TO nmb02
           #TQC-CB0076--add--end
         END IF
 
      AFTER FIELD nma10    #存款幣別
         IF NOT cl_null(g_nma.nma10) THEN
            IF (g_nma_o.nma10 IS NULL) OR (g_nma.nma10 != g_nma_o.nma10) THEN
               LET l_cnt=0                                                                                                          
               SELECT COUNT(*) INTO l_cnt FROM nme_file WHERE nme01=g_nma.nma01                                                     
               IF l_cnt=0 THEN                                                                                                      
                  SELECT COUNT(*) INTO l_cnt FROM nmd_file WHERE nmd03=g_nma.nma01 AND nmd30!='X'                                   
                  IF l_cnt<>0 THEN                                                                                                  
                     CALL cl_err(g_nma.nma01,'anm-712',0)                                                                           
                     LET g_nma.nma10 = g_nma_o.nma10                                                                                
                     DISPLAY BY NAME g_nma.nma10                                                                                    
                     NEXT FIELD nma10                                                                                               
                  END IF                                                                                                            
               ELSE                                                                                                                 
                  CALL cl_err(g_nma.nma01,'anm-712',0)                                                                              
                  LET g_nma.nma10 = g_nma_o.nma10                                                                                   
                  DISPLAY BY NAME g_nma.nma10                                                                                       
                  NEXT FIELD nma10                                                                                                  
               END IF                                                                                                               
               CALL i030_nma10('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nma.nma10,g_errno,0)
                  LET g_nma.nma10 = g_nma_o.nma10
                  DISPLAY BY NAME g_nma.nma10
                  NEXT FIELD nma10
               END IF
            END IF
            LET g_nma_o.nma10=g_nma.nma10
         END IF
 
      AFTER FIELD nma38            
         IF NOT  cl_null(g_nma.nma38) THEN
            CALL i030_nma38('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nma.nma38,g_errno,0)
               LET g_nma.nma38 = g_nma_o.nma38
               DISPLAY BY NAME g_nma.nma38
               NEXT FIELD nma38
            END IF
         END IF 
 
      AFTER FIELD nma39
         IF NOT cl_null(g_nma.nma39) THEN 
            CALL i030_nma39('a')
            IF NOT cl_null(g_errno) THEN 
               CALL cl_err(g_nma.nma39,g_errno,1)
               LET g_nma.nma39 = g_nma_t.nma39
               DISPLAY BY NAME g_nma.nma39
               NEXT FIELD nma39
            END IF 
         END IF  

      #FUN-B30213--add--str--
      AFTER FIELD nma47
         IF NOT cl_null(g_nma.nma47) THEN
            CALL i030_nma47('a')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nma.nma47,g_errno,1)
               LET g_nma.nma47 = g_nma_t.nma47
               DISPLAY BY NAME g_nma.nma47
               NEXT FIELD nma47
            END IF
         END IF
      #FUN-B30213--add--end--

      #No.TQC-BB0245  --Begin
      AFTER FIELD nma41
        IF NOT cl_null(g_nma.nma41) THEN
           IF g_nma.nma41 < 0 THEN
              CALL cl_err(g_nma.nma41,'axr-029',0)
              LET g_nma.nma41 = g_nma_t.nma41
              NEXT FIELD nma41
           END IF
        END IF
      AFTER FIELD nma42
        IF NOT cl_null(g_nma.nma42) THEN
           IF g_nma.nma42 < 0 THEN
              CALL cl_err(g_nma.nma42,'axr-029',0)
              LET g_nma.nma42 = g_nma_t.nma42
              NEXT FIELD nma42
           END IF
        END IF
      #No.TQC-BB0245  --End 

      ON CHANGE nma43
         IF g_aza.aza26 = '2' AND g_aza.aza73 = 'Y' THEN      #FUN-870037 add
             IF g_nma.nma43 = 'Y' THEN 
                 CALL cl_set_comp_required("nma03,nma39,nma40,nma41,nma42,nma47",TRUE)  #FUN-B30213 add nma47
                 CALL cl_set_comp_entry("nma39,nma40,nma41,nma42,nma47",TRUE)   #FUN-B30213 add nma47
             ELSE
                CALL cl_set_comp_required("nma03,nma39,nma40,nma41,nma42,nma47",FALSE)  #FUN-B30213 add nma47
                CALL cl_set_comp_entry("nma39,nma40,nma41,nma42,nma47",FALSE)    #FUN-B30213 add nma47
             END IF
         END IF               #NO.FUN-870037 add
         
                   
 
        AFTER FIELD nmaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD nmaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
      AFTER INPUT
         LET g_nma.nmauser = s_get_data_owner("nma_file") #FUN-C10039
         LET g_nma.nmagrup = s_get_data_group("nma_file") #FUN-C10039
         IF INT_FLAG THEN EXIT INPUT  END IF
         IF g_aza.aza26 = '2' AND g_aza.aza73 = 'Y' THEN      #FUN-870037  add
             IF g_nma.nma43='Y' THEN
                 IF g_nma.nma04 != g_nma_t.nma04 OR g_nma.nma39 != g_nma_t.nma39 THEN
                     LET l_n = 0 
                     SELECT COUNT(nma04) INTO l_n FROM nma_file,nmt_file
                      WHERE nma39=nmt01
                        AND nma39=g_nma.nma39 
                        AND nma04=g_nma.nma04
                     IF l_n > 0 THEN 
                        CALL cl_err('','anm-314',1)
                        LET g_nma.nma04 = g_nma_t.nma04
                        LET g_nma.nma39 = g_nma_t.nma39
                        NEXT FIELD nma04
                     END IF
                 END IF
             END IF
         END IF                         #FUN-870037 add
         #TQC-B80030--add--str--
         IF p_cmd = 'u' THEN
            CALL i030_nma09('u')
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_nma.nma09,g_errno,0)
               NEXT FIELD nma09
            END IF
         END IF
         #TQC-B80030--add--end--
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(nma05) # Act code
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nma.nma05,'23',g_aza.aza81)  #No.FUN-980025
                    RETURNING g_nma.nma05
              #FUN-CB0012--add--str
               SELECT aag02 INTO g_aag02 FROM aag_file 
                WHERE aag01 = g_nma.nma05 AND aag00 = g_aza.aza81
               IF SQLCA.SQLCODE THEN LET g_aag02 = ' ' END IF
               DISPLAY g_aag02 TO aag02
              #FUN-CB0012--add--end
               DISPLAY BY NAME g_nma.nma05 NEXT FIELD nma05
 
            WHEN INFIELD(nma051) # Act code
               CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nma.nma051,'23',g_aza.aza82)  #No.FUN-980025
                    RETURNING g_nma.nma051
               DISPLAY BY NAME g_nma.nma051 NEXT FIELD nma051
 
            WHEN INFIELD(nma09) #查詢存款類別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmb"
               LET g_qryparam.default1 = g_nma.nma09
               CALL cl_create_qry() RETURNING g_nma.nma09
               DISPLAY BY NAME g_nma.nma09
              #TQC-CB0076--add--str
               SELECT nmb02 INTO g_nmb02 FROM nmb_file WHERE nmb01 = g_nma.nma09
               IF SQLCA.SQLCODE THEN LET g_nmb02 = ' ' END IF
               DISPLAY g_nmb02 TO nmb02
              #TQC-CB0076--add--end
               NEXT FIELD nma09
            WHEN INFIELD(nma10) #查詢存款幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = g_nma.nma10
               CALL cl_create_qry() RETURNING g_nma.nma10
               DISPLAY BY NAME g_nma.nma10
               NEXT FIELD nma10
            WHEN INFIELD (nma39)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_nmt"
               LET g_qryparam.default1 = g_nma.nma39
               CALL cl_create_qry() RETURNING  g_nma.nma39
               DISPLAY BY NAME g_nma.nma39 
               NEXT FIELD nma39
            #FUN-B30213--add--str--
            WHEN INFIELD (nma47)
               CALL cl_init_qry_var()
               LET g_qryparam.form  = "q_noc"
               LET g_qryparam.default1 = g_nma.nma47
               CALL cl_create_qry() RETURNING  g_nma.nma47
               DISPLAY BY NAME g_nma.nma47
               NEXT FIELD nma47
            #FUN-B30213--add--end--
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION create_cash_in_bank_category
               CALL cl_cmdrun("anmi031")
 
      ON ACTION create_currency
               CALL cl_cmdrun("aooi050")
 
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
 
FUNCTION i030_nma09(p_cmd)  #存款類別
    DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_nmb02      LIKE nmb_file.nmb02,
           l_nmbacti    LIKE nmb_file.nmbacti
 
    LET g_errno = ' '
    SELECT nmb02,nmbacti
           INTO l_nmb02,l_nmbacti
           FROM nmb_file WHERE nmb01 = g_nma.nma09
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-006'
                            LET l_nmb02 = NULL
         WHEN l_nmbacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION i030_nma10(p_cmd)  #存款幣別
    DEFINE p_cmd        LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_azi02 LIKE azi_file.azi02,
           l_aziacti LIKE azi_file.aziacti
 
    LET g_errno = ' '
    SELECT azi02,aziacti
           INTO l_azi02,l_aziacti
           FROM azi_file WHERE azi01 = g_nma.nma10
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-007'
                            LET l_azi02 = NULL
         WHEN l_aziacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i030_nma38(p_cmd) #內部銀行所在結算中心
    DEFINE p_cmd   LIKE type_file.chr1,
           l_azp02 LIKE azp_file.azp02
    LET g_errno = ' '
    SELECT azp02 INTO l_azp02 FROM azp_file
       WHERE azp01 = g_nma.nma38
    CASE 
       WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-38'
                                LET l_azp02 = NULL
       OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    DISPLAY l_azp02 TO azp02
 
END FUNCTION
 
FUNCTION i030_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nma.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
 
   CALL i030_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_nna.clear()
      RETURN
   END IF
 
   OPEN i030_count
   FETCH i030_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
 
   OPEN i030_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
      INITIALIZE g_nma.* TO NULL
   ELSE
      CALL i030_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i030_fetch(p_flnma)
   DEFINE
       p_flnma         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flnma
      WHEN 'N' FETCH NEXT     i030_cs INTO g_nma.nma01
      WHEN 'P' FETCH PREVIOUS i030_cs INTO g_nma.nma01
      WHEN 'F' FETCH FIRST    i030_cs INTO g_nma.nma01
      WHEN 'L' FETCH LAST     i030_cs INTO g_nma.nma01
      WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump i030_cs INTO g_nma.nma01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
      INITIALIZE g_nma.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flnma
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_nma.* FROM nma_file          # 重讀DB,因TEMP有不被更新特性
    WHERE nma01 = g_nma.nma01
 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nma_file",g_nma.nma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_nma.nmauser     #No.FUN-4C0063
      LET g_data_group = g_nma.nmagrup     #No.FUN-4C0063
      CALL i030_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i030_show()
 
    LET g_nma_t.* = g_nma.*
 
    DISPLAY BY NAME g_nma.nma01,g_nma.nma02,g_nma.nma03,g_nma.nma061, g_nma.nmaoriu,g_nma.nmaorig,
                    g_nma.nma05,g_nma.nma051,g_nma.nma09,g_nma.nma10,g_nma.nma28,g_nma.nma04,   #No.FUN-680034
                    g_nma.nma07,g_nma.nma08,g_nma.nma12,g_nma.nma21,
                    g_nma.nma46,   #FUN-960141 add #NO.FUN-B50042
                    g_nma.nma37,g_nma.nma38,    #No.FUN-690090
                    g_nma.nma39,g_nma.nma40,g_nma.nma41,g_nma.nma42,g_nma.nma43,                #No.FUN-730032
                    g_nma.nma44,g_nma.nma47, #FUN-B30213     #FUN-870037 add
                    g_nma.nmauser,   #No.FUN-690090
                    g_nma.nmagrup,g_nma.nmamodu,g_nma.nmadate,g_nma.nmaacti,
                    g_nma.nmaud01,g_nma.nmaud02,g_nma.nmaud03,g_nma.nmaud04,
                    g_nma.nmaud05,g_nma.nmaud06,g_nma.nmaud07,g_nma.nmaud08,
                    g_nma.nmaud09,g_nma.nmaud10,g_nma.nmaud11,g_nma.nmaud12,
                    g_nma.nmaud13,g_nma.nmaud14,g_nma.nmaud15
    CALL cl_set_field_pic("","","","","",g_nma.nmaacti)
   #TQC-CB0076--add--str
    SELECT nmb02 INTO g_nmb02 FROM nmb_file WHERE nmb01 = g_nma.nma09
    IF SQLCA.SQLCODE THEN LET g_nmb02 = ' ' END IF
    DISPLAY g_nmb02 TO nmb02
   #TQC-CB0076--add--end
   #FUN-CB0012--add--str
    SELECT aag02 INTO g_aag02 FROM aag_file
     WHERE aag01 = g_nma.nma05 AND aag00 = g_aza.aza81
    IF SQLCA.SQLCODE THEN LET g_aag02 = ' ' END IF
    DISPLAY g_aag02 TO aag02
   #FUN-CB0012--add--end
    CALL i030_nna_b_fill(g_wc2)
    CALL i030_nma38('a')
    CALL i030_nma39('a')                      #No.FUN-730032
    CALL i030_nma47('a')                      #FUN-B30213
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i030_u()
   CALL cl_set_comp_entry("nma37",FALSE) #FUN-690090
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nma.nma01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
  
#  IF g_nma.nma37 = "0" THEN        #FUN-690090                      #TQC-A90141 Mark
   IF g_nma.nma37 = "0" AND g_action_choice != "reproduce" THEN      #TQC-A90141 Add                           
      CALL cl_err(g_nma.nma37,'nma02',0)                                                   
      RETURN                                                                    
   END IF                                            
 
   IF g_nma.nmaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_nma.nma01,'9027',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_nma01_t = g_nma.nma01
   LET g_nma_o.*=g_nma.*
   BEGIN WORK
 
   OPEN i030_cl USING g_nma.nma01
   IF STATUS THEN
      CALL cl_err("OPEN i030_cl:", STATUS, 1)
      CLOSE i030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i030_cl INTO g_nma.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
      CLOSE i030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_nma.nmamodu = g_user                   #修改者
   LET g_nma.nmadate = g_today                  #修改日期    
   #LET g_nma.nma45 = 'N'                       #傳POS否 #FUN-960141 #NO.FUN-B50042
   LET g_nma.nma45 = '1'                        #No:MOD-B50198
   CALL i030_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i030_i("u")                      # 欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_nma.* = g_nma_t.*
         CALL i030_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      UPDATE nma_file SET nma_file.* = g_nma.*    # 更新DB
       WHERE nma01 = g_nma.nma01               # COLAUTH?
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","nma_file",g_nma01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i030_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i030_x()
    DEFINE l_chr LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN
       RETURN
    END IF
 
    IF g_nma.nma01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN i030_cl USING g_nma.nma01
    IF STATUS THEN
       CALL cl_err("OPEN i030_cl:", STATUS, 1)
       CLOSE i030_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH i030_cl INTO g_nma.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
       CLOSE i030_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    CALL i030_show()
 
    IF cl_exp(15,22,g_nma.nmaacti) THEN
       LET g_chr=g_nma.nmaacti
       IF g_nma.nmaacti='Y' THEN
          LET g_nma.nmaacti='N'
       ELSE
          LET g_nma.nmaacti='Y'
       END IF
 
       UPDATE nma_file SET nmaacti=g_nma.nmaacti,
                           nmamodu=g_user,nmadate=g_today
                          #,nma45 = '1'    #FUN-960141 add  #NO.FUN-B50042 
        WHERE nma01 = g_nma.nma01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","nma_file",g_nma.nma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
          LET g_nma.nmaacti=g_chr
       END IF
       DISPLAY BY NAME g_nma.nmaacti
       #DISPLAY BY NAME g_nma.nma45  #FUN-960141 #NO.FUN-B50042
    END IF
 
    CLOSE i030_cl
    COMMIT WORK
 
END FUNCTION
 
FUNCTION i030_r()
   DEFINE l_chr LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_cnt LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN
      RETURN
   END IF
 
   IF g_nma.nma01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
    IF g_nma.nmaacti = 'N' THEN                                                                                                     
       CALL cl_err('','abm-950',0)                                                                                                  
       RETURN                                                                                                                       
    END IF                                                                                                                          
   IF g_nma.nma37= "0" THEN        #FUN-690090                                          
      CALL cl_err(g_nma.nma37,'nma01',0)                                                    
      RETURN                                                                    
   END IF          
 
  #IF g_aza.aza88 = 'Y' AND g_nma.nma46 = 'Y' THEN    #MOD-C30685 mark
     #FUN-B50042 --START--
     #IF g_nma.nmaacti='Y' OR g_nma.nma45= 'N' THEN
     #   CALL cl_err('','aim-944',0)
     #   CALL cl_err('','art-648',0)        #FUN-A30030 ADD         
     #   RETURN
     #END IF      
     #FUN-B50042 --END--
  #END IF                                              #MOD-C30685 mark
  #------------------MOD-C30685----------------start
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM nmg_file,npk_file
    WHERE nmg00 = npk00
      AND npk04 = g_nma.nma01
      AND nmgconf <> 'X'
   IF l_cnt > 0 THEN
      CALL cl_err(g_nma.nma01,'anm-993',0)
      RETURN
   END IF
  #------------------MOD-C30685------------------end      
             
   BEGIN WORK
 
   OPEN i030_cl USING g_nma.nma01
   IF STATUS THEN
      CALL cl_err("OPEN i030_cl:", STATUS, 1)
      CLOSE i030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i030_cl INTO g_nma.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
      CLOSE i030_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i030_show()
   #-->己開票則不可刪除
   SELECT COUNT(*) INTO l_cnt  FROM nmd_file
    WHERE nmd03 = g_nma.nma01    #銀行
 
   IF l_cnt > 0 THEN
      CALL cl_err('','anm-252',0)
      RETURN
   END IF
 
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nma01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nma.nma01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      CALL cl_err('','anm-130',1)  #MOD-960180 
      DELETE FROM nma_file WHERE nma01 = g_nma.nma01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","nma_file",g_nma.nma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
      END IF
 
      DELETE FROM nna_file WHERE nna01=g_nma.nma01
 
      LET g_cnt2 = 0 
      SELECT COUNT(*) INTO g_cnt2 FROM nmw_file
        WHERE nmw01 = g_nma.nma01
      IF g_cnt2 > 0 THEN 
         DELETE FROM nmw_file WHERE nmw01=g_nma.nma01   
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("del","nmw_file",g_nma.nma01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660148
         END IF
      END IF
 
      CLEAR FORM
      CALL g_nna.clear()
      OPEN i030_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE i030_cs
         CLOSE i030_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH i030_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i030_cs
         CLOSE i030_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i030_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i030_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i030_fetch('/')
      END IF
   END IF
 
   CLOSE i030_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i030_copy()
    DEFINE
        l_n             LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        l_nma           RECORD LIKE nma_file.*,
        l_newno,l_oldno LIKE nma_file.nma01
 
    IF s_anmshut(0) THEN
       RETURN
    END IF
 
    IF g_nma.nma01 IS NULL THEN
       CALL cl_err('',-400,0)
       RETURN
    END IF
 
    LET l_nma.*=g_nma.*
    LET g_before_input_done = FALSE
    CALL i030_set_entry('a')
    LET g_before_input_done = TRUE
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM nma01
 
       AFTER FIELD nma01
          IF l_newno IS NULL THEN
             NEXT FIELD nma01
          END IF
          SELECT COUNT(*) INTO g_cnt FROM nma_file
           WHERE nma01 = l_newno
          IF g_cnt > 0 THEN
             CALL cl_err(l_newno,-239,0)
             NEXT FIELD nma01
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
       DISPLAY BY NAME g_nma.nma01
       RETURN
    END IF
 
    LET l_nma.nma01=l_newno     #資料鍵值
    LET l_nma.nmauser=g_user    #資料所有者
    LET l_nma.nmagrup=g_grup    #資料所有者所屬群
    LET l_nma.nmamodu=NULL      #資料修改日期
    LET l_nma.nmadate=g_today   #資料建立日期
    LET l_nma.nmaacti='Y'       #有效資料
    #LET l_nma.nma45='N'        #未傳POS #NO.FUN-B50042 
    LET l_nma.nma45='1'         #No:MOD-B50198   
    LET l_nma.nma46 ='N'
    LET l_nma.nma04=NULL        #TQC-B80034
 
    LET l_nma.nmaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_nma.nmaorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO nma_file VALUES(l_nma.*)
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","nma_file",l_nma.nma01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    END IF                                                                      
     
   #使用複製功能時,不可複製單身
    COMMIT WORK                                                                 
       MESSAGE 'ROW(',l_newno,') O.K'
       LET l_oldno = g_nma.nma01
       SELECT nma_file.* INTO g_nma.* FROM nma_file
        WHERE nma01 = l_newno
 
       CALL i030_u()
       CALL i030_nna_b()  #TQC-740024
       #SELECT nma_file.* INTO g_nma.* FROM nma_file  #FUN-C80046
       # WHERE nma01 = l_oldno                        #FUN-C80046
 
    CALL i030_show()
 
END FUNCTION
 
FUNCTION i030_nna_b()
DEFINE
   l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
   l_n             LIKE type_file.num5,    #檢查重複用  #No.FUN-680107 SMALLINT
   l_cnt           LIKE type_file.num5,    #No.FUN-680107 SMALLINT
   l_lock_sw       LIKE type_file.chr1,    #單身鎖住否 #No.FUN-680107 VARCHAR(1)
   p_cmd           LIKE type_file.chr1,    #處理狀態 #No.FUN-680107 VARCHAR(1)
   l_cmd           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(30)
   l_sql           LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(300)
   l_nmw03         LIKE nmw_file.nmw03,
   l_nmw04         LIKE nmw_file.nmw04,
   l_nmw05         LIKE nmw_file.nmw04,
   l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680107 SMALLINT
   l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-680107 SMALLINT
  
 
 
   LET g_action_choice=" "
   IF g_nma.nma01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_nma.* FROM nma_file WHERE nma01=g_nma.nma01
 
   IF g_nma.nma28 != '1' THEN
      CALL cl_err(g_nma.nma01,'anm-952',0)
      RETURN
   END IF
 
   MESSAGE ""
 
   LET g_forupd_sql = "SELECT nna06,nna021,nna02,nna04,nna03,nna05",
                      "  FROM nna_file",
                      "   WHERE nna01 = ? AND nna02 = ?",
                      "   AND nna021 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i030_nna_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_nna WITHOUT DEFAULTS FROM s_nna.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd=''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         OPEN i030_cl USING g_nma.nma01
         IF STATUS THEN
            CALL cl_err("OPEN i030_cl:", STATUS, 1)
            CLOSE i030_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH i030_cl INTO g_nma.*
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_nma.nma01,SQLCA.sqlcode,0)
            CLOSE i030_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_nna_t.* = g_nna[l_ac].*  #BACKUP
            OPEN i030_nna_bcl USING g_nma.nma01,g_nna_t.nna02,g_nna_t.nna021
            IF STATUS THEN
               CALL cl_err("OPEN i030_nna_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i030_nna_bcl INTO g_nna[l_ac].*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_nna_t.nna02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            LET g_before_input_done = FALSE
            CALL i030_set_entry_b(p_cmd)
            CALL i030_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd='a'
         INITIALIZE g_nna[l_ac].* TO NULL      #900423
         LET g_nna_t.* = g_nna[l_ac].*         #新輸入資料
         LET g_nna[l_ac].nna06 = 'N'   #TQC-B60073  Add
         CALL i030_set_entry_b(p_cmd)   #MOD-770151
         CALL i030_set_no_entry_b(p_cmd)   #MOD-770151
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD nna06
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
         INSERT INTO nna_file(nna01,nna021,nna02,nna03,nna04,nna05,nna06)
                VALUES(g_nma.nma01,g_nna[l_ac].nna021,g_nna[l_ac].nna02,
                       g_nna[l_ac].nna03,g_nna[l_ac].nna04,
                       g_nna[l_ac].nna05,g_nna[l_ac].nna06)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","nna_file",g_nma.nma01,g_nna[l_ac].nna021,SQLCA.sqlcode,"","",1)  #No.FUN-660148
            CANCEL INSERT
         ELSE
            MESSAGE 'INSERT O.K'
            LET g_rec_b=g_rec_b+1
            COMMIT WORK
            DISPLAY g_rec_b TO FORMONLY.cn2
         END IF
 
      BEFORE FIELD nna02
         IF NOT cl_null(g_nna[l_ac].nna02) THEN
            IF g_nna[l_ac].nna02 = 0 THEN
               SELECT MAX(nna02)+1 INTO g_nna[l_ac].nna02 FROM nna_file
                WHERE nna01=g_nma.nma01
                  AND nna021=g_nna[l_ac].nna021
               IF cl_null(g_nna[l_ac].nna02) THEN
                  LET g_nna[l_ac].nna02 = 1
               END IF
            END IF
         END IF
 
      AFTER FIELD nna04                       #支票號碼位數
         IF NOT cl_null(g_nna[l_ac].nna04) THEN
            IF g_nna[l_ac].nna04 < 1 OR g_nna[l_ac].nna04 > 15 THEN   #TQC-610136
               LET g_nna[l_ac].nna04=g_nna_t.nna04
               DISPLAY BY NAME g_nna[l_ac].nna04
               CALL cl_err(g_nna[l_ac].nna04,'anm-005',0)
               NEXT FIELD nna04
            END IF
         IF g_nna[l_ac].nna05 > g_nna[l_ac].nna04   THEN                                                                            
            CALL cl_err('','anm-099',0)                                                                                             
            NEXT FIELD nna04                                                                                                        
         END IF                                                                                                                     
            LET g_nna_t.nna04=g_nna[l_ac].nna04
         END IF
 
      AFTER FIELD nna03                       #下次列印支票號
         IF g_nna[l_ac].nna06 = 'Y' AND cl_null(g_nna[l_ac].nna03)  THEN
            LET g_nna[l_ac].nna03=g_nna_t.nna03
            DISPLAY BY NAME g_nna[l_ac].nna03
            CALL cl_err(g_nna[l_ac].nna03,'anm-003',0)
            NEXT FIELD nna03
         END IF
         #當輸入之票號大於支票號碼位數時,顯示警告訊息
        #IF LENGTH(g_nna[l_ac].nna03 CLIPPED) > g_nna[l_ac].nna04 THEN  #TQC-B60074   Mark 
         IF LENGTH(g_nna[l_ac].nna03 CLIPPED) != g_nna[l_ac].nna04 THEN #TQC-B60074   Add  
            CALL cl_err(g_nna[l_ac].nna03,'anm-351',0)    #TQC-B60074   MOD  anm-039 --> anm351
            NEXT FIELD nna03   #MOD-C30412
         END IF
         IF p_cmd = 'u'  THEN   #check 是否存在支票簿中
            SELECT COUNT(*) INTO g_cnt FROM nmw_file
             WHERE nmw01 = g_nma.nma01
               AND nmw06 = g_nna[l_ac].nna02
               AND nmw03 = g_nna[l_ac].nna021
               AND nmwacti = 'Y'
            IF g_cnt > 0 THEN
               LET l_sql="SELECT nmw04,nmw05  FROM nmw_file ",
                         " WHERE nmw01='",g_nma.nma01 CLIPPED, "' AND ",
                         " nmw06 = ",g_nna[l_ac].nna02," AND ",
                         " nmw03 = '",g_nna[l_ac].nna021,"' AND ",
                         " nmwacti = 'Y'"
               PREPARE i030_i_p FROM l_sql             # RUNTIME 編譯
               DECLARE i030_i_cs CURSOR FOR i030_i_p
               FOREACH i030_i_cs INTO l_nmw04,l_nmw05 END FOREACH
               IF ( cl_null(l_nmw04) OR cl_null(l_nmw05) ) THEN
                  CALL cl_err(g_nna[l_ac].nna03,'anm-647',1)
                  NEXT FIELD nna03
               END IF
               IF g_nna[l_ac].nna03 < l_nmw04 OR g_nna[l_ac].nna03 > l_nmw05 THEN
                  CALL cl_err(g_nna[l_ac].nna03,'anm-647',1)
                  NEXT FIELD nna03
               END IF
            END IF
         END IF
         LET g_nna_t.nna03 = g_nna[l_ac].nna03
 
      AFTER FIELD nna05                       #後幾位為連續編號
         IF NOT cl_null(g_nna[l_ac].nna05) THEN
            IF g_nna[l_ac].nna05 < 1 OR g_nna[l_ac].nna05 > 15 THEN   #TQC-610136
               LET g_nna[l_ac].nna05 = g_nna_t.nna05
               DISPLAY BY NAME g_nna[l_ac].nna05
               CALL cl_err(g_nna[l_ac].nna05,'anm-005',0)
               NEXT FIELD nna05
            END IF
            LET g_nna_t.nna05 = g_nna[l_ac].nna05
            IF g_nna[l_ac].nna05 >= g_nna[l_ac].nna04 THEN
               CALL cl_err('','anm-099',0)
               NEXT FIELD nna05
            END IF 
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_nna_t.nna02 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            #-->已存在anmi101則不可刪除 
            LET g_cnt2 = 0 
            SELECT COUNT(*) INTO g_cnt2 FROM nmw_file
              WHERE nmw01 = g_nma.nma01
                AND nmw06 = g_nna_t.nna02
                AND nmw03 = g_nna_t.nna021
            IF g_cnt2 > 0 THEN 
               CALL cl_err('','anm-402',0)
               CANCEL DELETE
            END IF
            #-->己開票則不可刪除
            SELECT COUNT(*) INTO l_cnt  FROM nmd_file
             WHERE nmd03 = g_nma.nma01    #銀行
               AND nmd31 = g_nna_t.nna02  #簿號
               AND nmd54 = g_nna_t.nna021 #取票日期   #MOD-D30272 
            IF l_cnt > 0  THEN    
               CALL cl_err('','anm-252',0)
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM nna_file
             WHERE nna01 = g_nma.nma01
               AND nna02 = g_nna_t.nna02
               AND nna021= g_nna_t.nna021
            IF SQLCA.sqlcode THEN
               CALL cl_err3("del","nna_file",g_nma.nma01,g_nna_t.nna02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
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
            LET g_nna[l_ac].* = g_nna_t.*
            CLOSE i030_nna_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_nna[l_ac].nna02,-263,1)
            LET g_nna[l_ac].* = g_nna_t.*
         ELSE
            UPDATE nna_file SET nna02 = g_nna[l_ac].nna02,
                                nna021 = g_nna[l_ac].nna021,
                                nna03 = g_nna[l_ac].nna03,
                                nna04 = g_nna[l_ac].nna04,
                                nna05 = g_nna[l_ac].nna05,
                                nna06 = g_nna[l_ac].nna06
             WHERE nna01 = g_nma.nma01
               AND nna02 = g_nna_t.nna02
               AND nna021= g_nna_t.nna021
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","nna_file",g_nma.nma01,g_nna_t.nna02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
               LET g_nna[l_ac].* = g_nna_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
        #LET l_ac_t = l_ac     #FUN-D30032 Mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_nna[l_ac].* = g_nna_t.*
            #FUN-D30032--add--str--
            ELSE
               CALL g_nna.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30032--add--end-- 
            END IF
            CLOSE i030_nna_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac     #FUN-D30032 Add
         CLOSE i030_nna_bcl
         COMMIT WORK
 
      ON ACTION CONTROLO                        #沿用所有欄位
         IF INFIELD(nna02) AND l_ac > 1 THEN
            LET g_nna[l_ac].* = g_nna[l_ac-1].*
            NEXT FIELD nna02
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
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END INPUT
 
   LET g_nma.nmamodu = g_user
   LET g_nma.nmadate = g_today
   UPDATE nma_file SET nmamodu = g_nma.nmamodu,nmadate = g_nma.nmadate
    WHERE nma01 =  g_nma.nma01
   DISPLAY BY NAME g_nma.nmamodu,g_nma.nmadate
 
   SELECT COUNT(*) INTO g_cnt FROM nna_file
    WHERE nna01=g_nma.nma01
      AND nna06='Y'
 
   IF g_cnt > 0 AND cl_null(g_nma.nma12) THEN
      DISPLAY BY NAME g_nma.nma12
      CALL cl_err('','anm-956',1)
      CALL i030_u()
       CALL i030_nna_b_fill('1=1')   #No.MOD-470046
   END IF
 
   CLOSE i030_nna_bcl
   COMMIT WORK
   CALL i030_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION i030_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM nma_file WHERE nma01 =  g_nma.nma01
         INITIALIZE g_nma.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION i030_nna_b_fill(p_wc)   #BODY FILL UP
DEFINE
   p_wc   LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(600)
 
   LET g_sql = "SELECT nna06,nna021,nna02,nna04,nna03,nna05 ",
               "  FROM nna_file ",
               " WHERE nna01 = '",g_nma.nma01,"'"
   IF NOT cl_null(p_wc) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc CLIPPED 
   END IF 
   LET g_sql=g_sql CLIPPED," ORDER BY nna06" 
   DISPLAY g_sql
   
   PREPARE i030_nna_prepare2 FROM g_sql      #預備一下
   DECLARE nna_curs CURSOR FOR i030_nna_prepare2
 
   CALL g_nna.clear()
   LET g_cnt = 1
   LET g_rec_b = 0
 
   MESSAGE " Wait "
 
   FOREACH nna_curs INTO g_nna[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_nna.deleteElement(g_cnt)   #取消 Array Element
 
   MESSAGE ""
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION i030_nna_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nna TO s_nna.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
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
         CALL i030_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i030_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i030_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL i030_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL i030_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
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
          CALL cl_set_field_pic("","","","","",g_nma.nmaacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      #支票簿號設定
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

#FUN-A20010 --Begin mark
#    #FUN-970077---Begin
#    ON ACTION remitting_type
#       LET g_action_choice="remitting_type"
#       EXIT DISPLAY
#    #FUN-970077---End
#FUN-A20010 --End mark
 
     ON ACTION related_document                #No.FUN-6A0011  相關文件
        LET g_action_choice="related_document"          
        EXIT DISPLAY   
        
     ON ACTION balance
        LET g_action_choice="balance"
        EXIT DISPLAY 
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
 
FUNCTION i030_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nma01",TRUE)
   END IF
   
   IF p_cmd = 'a' AND ( NOT g_before_input_done )  THEN           #No.FUN-690090
      CALL cl_set_comp_entry("nma37",FALSE)                                     
   END IF 
 
 
END FUNCTION
 
FUNCTION i030_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nma01",FALSE)
   END IF
   
   IF p_cmd NOT MATCHES '[AaUu]'   THEN        
      CALL cl_set_comp_entry("nma37",TRUE)                #No.FUN-690090                        
   END IF 
 
 
END FUNCTION
 
FUNCTION i030_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND NOT g_before_input_done THEN
      SELECT COUNT(*) INTO g_cnt FROM nmd_file
       WHERE nmd03 = g_nma.nma01 AND nmd31 = g_nna[l_ac].nna02
         AND nmd30 <> 'X'
      IF g_cnt > 0 THEN
         CALL cl_set_comp_entry("nna03",FALSE)
      END IF
   END IF
 
   LET g_cnt2 = 0 
   SELECT COUNT(*) INTO g_cnt2 FROM nmw_file
     WHERE nmw01 = g_nma.nma01 
       AND nmw06 = g_nna[l_ac].nna02 
       AND nmw03 = g_nna[l_ac].nna021
   IF g_cnt2 > 0 THEN
      CALL cl_set_comp_entry("nna02,nna021,nna03,nna04,nna05",FALSE)   
      CALL cl_err('','anm-402',0)
   END IF
 
END FUNCTION
 
FUNCTION i030_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF NOT g_before_input_done THEN
      CALL cl_set_comp_entry("nna03",TRUE)
   END IF
 
   CALL cl_set_comp_entry("nna02,nna021,nna03,nna04,nna05",TRUE)   #MOD-750037
END FUNCTION
 
FUNCTION i030_out()
 DEFINE l_cmd           LIKE type_file.chr1000         #No.FUN-7C0043                                                               
    IF cl_null(g_wc) AND NOT cl_null(g_nma.nma01) THEN                                                                              
       LET g_wc=" nma01='",g_nma.nma01,"'"                                                                                          
    END IF                                                                                                                          
    IF cl_null(g_wc) THEN                                                                                                           
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    IF g_wc2 IS NULL THEN                                                                                                           
       LET g_wc2 = " 1=1"                                                                                                           
    END IF                                                                                                                          
    IF g_aza.aza73='N' THEN                                                                                                         
       LET l_cmd = 'p_query "anmi030_1" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                     
       CALL cl_cmdrun(l_cmd)                                                                                                        
    ELSE                                                                                                                            
       LET l_cmd = 'p_query "anmi030" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                                       
       CALL cl_cmdrun(l_cmd)                                                                                                        
    END IF                                                                                                                          
    RETURN  
 
 
 
END FUNCTION
 
 
FUNCTION i030_nma39(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_nmt02    LIKE nmt_file.nmt02
DEFINE l_nmt09    LIKE nmt_file.nmt09
DEFINE l_nmt12    LIKE nmt_file.nmt12
DEFINE l_nmtacti  LIKE nmt_file.nmtacti
DEFINE l_n        LIKE type_file.num5
 
    LET g_errno = ''
    LET l_n = 0
 
    SELECT nmt02,nmt09,nmt12,nmtacti INTO l_nmt02,l_nmt09,l_nmt12,l_nmtacti FROM nmt_file 
     WHERE nmt01 = g_nma.nma39
    CASE 
      WHEN SQLCA.sqlcode = 100  LET g_errno = 'aap-007'
                                LET l_nmt02 = NULL
      WHEN l_nmtacti = 'N'      LET g_errno = 'mfg0301'
      OTHERWISE 
           LET g_errno = SQLCA.sqlcode USING '-----'
    END CASE 
 
    DISPLAY l_nmt02 TO FORMONLY.nmt02
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14
#FUN-A20010 --Begin mark
#FUN-970077---Begin
#FUNCTION i030_1()
#  LET g_nnc01 = NULL
#  LET g_nnc01_t = NULL
#  OPEN WINDOW i030_1_w WITH FORM "anm/42f/anmi030_1"
#     ATTRIBUTE (STYLE = g_win_style CLIPPED)
#
#  CALL cl_ui_init()
#
#  LET g_flag = 'Y'
#  CALL i030_1_q()
#  LET g_flag = 'N'
#  CALL i030_1_menu()
#  CLOSE WINDOW i030_1_w
#END FUNCTION
#FUN-A20010 --End mark

#FUN-B30213--add--str--
FUNCTION i030_nma47(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1
DEFINE l_noc02    LIKE noc_file.noc02
DEFINE l_nocacti  LIKE noc_file.nocacti
DEFINE l_n        LIKE type_file.num5

    LET g_errno = ''
    LET l_n = 0

    SELECT noc02,nocacti INTO l_noc02,l_nocacti  FROM noc_file
     WHERE noc01 = g_nma.nma47 
    CASE
      WHEN SQLCA.sqlcode = 100  LET g_errno = 'anm1036'
                                LET l_noc02 = NULL
      WHEN l_nocacti = 'N'      LET g_errno = '9028'
                                LET l_noc02 = NULL
      OTHERWISE
           LET g_errno = SQLCA.sqlcode USING '-----'
    END CASE

    DISPLAY l_noc02 TO FORMONLY.noc02
END FUNCTION
#FUN-B30213--add--end--

#TQC-B80034--add--str--
FUNCTION i030_nma04(p_cmd)  #銀行帳號
    DEFINE p_cmd        LIKE type_file.chr1
    DEFINE l_n          LIKE type_file.num5

    LET g_errno = ' '
    LET l_n = 0
    SELECT COUNT(*) INTO l_n FROM nma_file
     WHERE nma04 = g_nma.nma04
   #IF l_n > 0 THEN                        #MOD-BA0073 mark
    IF l_n > 0 AND g_aza.aza26 = '2' THEN  #MOD-BA0073
       LET g_errno = 'anm1042'
    END IF
END FUNCTION
#TQC-B80034--add--end--


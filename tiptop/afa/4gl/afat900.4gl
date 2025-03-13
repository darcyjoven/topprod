# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: afat900.4gl
# Descriptions...: 固定資產抵押作業
# Date & Author..: 96/06/07  BY Star
# Modify.........: No:8141 03/09/08 By Wiky p_wc2 如果為null設 " 1=1 "
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-470515 04/10/05 By Nicola 加入"相關文件"功能
# Modify.........: No.FUN-4B0019 04/11/03 By Nicola 加入"轉EXCEL"功能
# Modify.........: No.FUN-4C0008 04/12/02 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-510160 05/01/28 By Kitty 語言別無作用
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: No.FUN-560146 05/06/21 By Nicola 不需套用單據編號規則
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-650099 06/05/24 By Smapmin 單據刪除後抵押狀態應恢復成1.未申請
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0001 06/10/12 By jamie FUNCTION t900()_q 一開始應清空g_fcd.*值
# Modify.........: No.FUN-6A0069 06/10/30 By yjkhero l_time轉g_time 
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-710028 07/02/03 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-740047 07/04/17 By Smapmin 財產編號輸入後不應自動帶附號
# Modify.........: No.MOD-740450 07/04/24 By rainy 整合測試
# Modify.........: No.MOD-750047 07/05/11 By Smapmin 查無資料時,不可按設定/取消設定的ACTION
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-760105 07/06/23 By Smapmin 設定/取消設定加嚴控管
# Modify.........: No.TQC-770108 07/07/24 By Rayven 單頭鑒定金額應大于0
# Modify.........: No.FUN-810046 08/01/15 By Johnray 增加串查段
# Modify.........: No.MOD-850024 08/05/05 By chenl  修正資產編號開窗查詢代碼為q_faj01
# Modify.........: No.FUN-850068 08/05/14 By TSD.hoho 自定欄位功能修改
# Modify.........: No.MOD-890087 08/09/11 By Sarah afa-921設定為警告,不控卡
# Modify.........: No.MOD-960163 09/06/12 By mike 輸入完資產附號(fce031)后,需檢查fce03+fce031須存在faj_file且faj43不可為056X,若不符>
# Modify.........: No.TQC-980030 09/08/05 By sherry 扺押狀態為'1'的才可以申請扺押    
# Modify.........: No.TQC-980016 09/08/07 By liuxqa 非負控管。
# Modify.........: No.TQC-980023 09/08/07 By liuxqa 非負控管。
# Modify.......... No.TQC-980054 09/08/07 By liuxqa 當fce06合并財產編號為空時，才應該去update合并前的數量.成本等值。合并等值，合并后才不去更新合并前的值。
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
                          
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0077 10/01/07 By baofei 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-AB0198 10/11/29 By lixia 取消設定時清空銀行簡稱
# Modify.........: No.TQC-B20170 11/02/24 By yinhy 狀態頁簽的“資料建立者”“資料建立部門”欄位未帶出相應的數據。
# Modify.........: No.MOD-B30362 11/03/17 By lixia fce20 fce031增加管控
# Modify.........: No.MOD-C40014 12/04/03 By Polly 畫面afat900b開啟後放棄時，應將 g_success = 'N'
# Modify.........: No.FUN-B50062 11/05/23 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.CHI-C30002 12/05/17 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/14 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70159 12/07/24 By lujh 財編已經做過抵押申請，將抵押申請作廢，或者抵押已經做了afap910解除抵押，第二次抵押申請輸入相同財編時會
#                                                 報錯" aec-009 資料已存在，請重新錄入"，不符合邏輯
# Modify.........: No.TQC-C70177 12/07/25 By lujh 已錄入抵押申請財產編號的抵押申請單作廢，則輸入完單頭，自動產生單身的afat900s、afat900a界面應不需要過濾掉
#                                                 此財產編號，應能帶出顯示于畫面，提供選擇。 
# Modify.........: No.TQC-C70175 12/07/25 By lujh 已經有解除抵押資料的抵押申請單應該不可以再取消設置，目前可以取消設置和取消審核並刪除掉原抵押申請資料。
# Modify.........: No.TQC-C70173 12/07/25 By lujh 審核時，afai100中fai41的狀態應該為2：申請中，鑑價後分別對應“3:部份設置”和設置抵押資料對應“4：全部設置
# Modify.........: No.CHI-C80041 12/11/26 By bart 取消單頭資料控制
# Modify.........: No:FUN-D20035 13/02/22 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/08 by lixiang 修正單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_fcd           RECORD LIKE fcd_file.*,       #投資抵減單 (假單頭)
    g_fcd_t         RECORD LIKE fcd_file.*,       #投資抵減單 (舊值)
    g_fcd_o         RECORD LIKE fcd_file.*,       #投資抵減單 (舊值)
    g_fcd01_t       LIKE fcd_file.fcd01,          #投資抵減單 (舊值)
    g_feature       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
    g_fce           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fce02       LIKE fce_file.fce02,   #項次
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        faj06       LIKE faj_file.faj06,   #中文名稱
        faj04       LIKE faj_file.faj04,   #資產類別
        faj25       LIKE faj_file.faj25,   #取得日期
        faj49       LIKE faj_file.faj49,   #進口編號
        fce06       LIKE fce_file.fce06,   #合併編號
        fce061      LIKE fce_file.fce061,  #附號
        fce20       LIKE fce_file.fce20,   #數量
        fce21       LIKE fce_file.fce21,   #單位
        fce05       LIKE fce_file.fce05,   #抵押金額
        fce24       LIKE fce_file.fce24,   #成本
        fce04       LIKE fce_file.fce04,   #帳面價值
        fce07       LIKE fce_file.fce07,   #狀態
        fceud01     LIKE fce_file.fceud01,
        fceud02     LIKE fce_file.fceud02,
        fceud03     LIKE fce_file.fceud03,
        fceud04     LIKE fce_file.fceud04,
        fceud05     LIKE fce_file.fceud05,
        fceud06     LIKE fce_file.fceud06,
        fceud07     LIKE fce_file.fceud07,
        fceud08     LIKE fce_file.fceud08,
        fceud09     LIKE fce_file.fceud09,
        fceud10     LIKE fce_file.fceud10,
        fceud11     LIKE fce_file.fceud11,
        fceud12     LIKE fce_file.fceud12,
        fceud13     LIKE fce_file.fceud13,
        fceud14     LIKE fce_file.fceud14,
        fceud15     LIKE fce_file.fceud15
 
                    END RECORD,
    g_fce_t         RECORD                 #程式變數 (舊值)
        fce02       LIKE fce_file.fce02,   #項次
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        faj06       LIKE faj_file.faj06,   #中文名稱
        faj04       LIKE faj_file.faj04,   #資產類別
        faj25       LIKE faj_file.faj25,   #取得日期
        faj49       LIKE faj_file.faj49,   #進口編號
        fce06       LIKE fce_file.fce06,   #合併編號
        fce061      LIKE fce_file.fce061,  #附號
        fce20       LIKE fce_file.fce20,   #數量
        fce21       LIKE fce_file.fce21,   #單位
        fce05       LIKE fce_file.fce05,   #抵押金額
        fce24       LIKE fce_file.fce24,   #成本
        fce04       LIKE fce_file.fce04,   #帳面價值
        fce07       LIKE fce_file.fce07,   #狀態
        fceud01     LIKE fce_file.fceud01,
        fceud02     LIKE fce_file.fceud02,
        fceud03     LIKE fce_file.fceud03,
        fceud04     LIKE fce_file.fceud04,
        fceud05     LIKE fce_file.fceud05,
        fceud06     LIKE fce_file.fceud06,
        fceud07     LIKE fce_file.fceud07,
        fceud08     LIKE fce_file.fceud08,
        fceud09     LIKE fce_file.fceud09,
        fceud10     LIKE fce_file.fceud10,
        fceud11     LIKE fce_file.fceud11,
        fceud12     LIKE fce_file.fceud12,
        fceud13     LIKE fce_file.fceud13,
        fceud14     LIKE fce_file.fceud14,
        fceud15     LIKE fce_file.fceud15
                    END RECORD,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_rec_b         LIKE type_file.num5,                #單身筆數       #No.FUN-680070 SMALLINT
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_ax            LIKE type_file.num5,                #目前處理的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(200)
    l_fce           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fceyn       LIKE type_file.chr1,                #是否要投入 fce_file       #No.FUN-680070 VARCHAR(01)
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        faj04       LIKE faj_file.faj04,   #取得日期
        faj25       LIKE faj_file.faj25,   #數量
        fce04       LIKE fce_file.fce04,   #帳面價值
        fce05       LIKE fce_file.fce05,   #抵押金額
        fce06       LIKE fce_file.fce06,   #合併財產編號
        fce061      LIKE fce_file.fce061   #合併財產附號
                    END RECORD,
    l_fce_t         RECORD                 #程式變數(Program Variables)
        fceyn       LIKE type_file.chr1,                #是否要投入 fce_file       #No.FUN-680070 VARCHAR(01)
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        faj04       LIKE faj_file.faj04,   #取得日期
        faj25       LIKE faj_file.faj25,   #數量
        fce04       LIKE fce_file.fce04,   #帳面價值
        fce05       LIKE fce_file.fce05,   #抵押金額
        fce06       LIKE fce_file.fce06,   #合併財產編號
        fce061      LIKE fce_file.fce061   #合併財產附號
                    END RECORD,
    m_fce           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        fceyn       LIKE type_file.chr1,                #財產編號       #No.FUN-680070 VARCHAR(01)
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        faj04       LIKE faj_file.faj04,   #類別
        faj25       LIKE faj_file.faj25,   #取得日期
        fce05       LIKE fce_file.fce05,   #抵減金額
        fce06       LIKE fce_file.fce06,   #合併財產編號
        fce061      LIKE fce_file.fce061   #合併財產附號
                    END RECORD,
    m_fce_t         RECORD    #程式變數(Program Variables)
        fceyn       LIKE type_file.chr1,                #財產編號       #No.FUN-680070 VARCHAR(01)
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        faj04       LIKE faj_file.faj04,   #類別
        faj25       LIKE faj_file.faj25,   #取得日期
        fce05       LIKE fce_file.fce05,   #抵減金額
        fce06       LIKE fce_file.fce06,   #合併財產編號
        fce061      LIKE fce_file.fce061   #合併財產附號
                    END RECORD
 
   DEFINE l_priv2           LIKE zy_file.zy04    # 使用者資料權限
   DEFINE l_priv3           LIKE zy_file.zy05    # 使用部門資料權限
   DEFINE g_alg02           LIKE alg_file.alg02
   DEFINE g_fcf04           LIKE fcf_file.fcf04
   DEFINE p_row,p_col       LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE g_forupd_sql      STRING   #SELECT ... FOR UPDATE SQL
   DEFINE g_before_input_done LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE g_cnt           LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
   DEFINE g_row_count    LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE g_curs_index   LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE g_jump         LIKE type_file.num10        #No.FUN-680070 INTEGER
   DEFINE mi_no_ask       LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
 
#主程式開始
MAIN
 
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
 
    LET g_forupd_sql = " SELECT * FROM fcd_file WHERE fcd01 =?  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_cl CURSOR FROM g_forupd_sql
 
    LET p_row = 3 LET p_col = 7
    OPEN WINDOW t900_w AT p_row,p_col              #顯示畫面
      WITH FORM "afa/42f/afat900"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL t900_create_temp1()   #建立一temp file 儲存預投入單身之資料
    CALL t900_menu()
    CLOSE WINDOW t900_w                 #結束畫面
      CALL cl_used(g_prog,g_time,2)    #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #NO.FUN-6A0069
        RETURNING g_time                                   #NO.FUN-6A0069
END MAIN
 
#QBE 查詢資料
FUNCTION t900_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
 
    CLEAR FORM                             #清除畫面
    CALL g_fce.clear()
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
 
   INITIALIZE g_fcd.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON             # 螢幕上取單頭條件
        fcd01,fcd02,fcd03,fcd12,fcd05,fcd06,fcd07,fcd09,fcd08,
        fcdconf,fcd10,fcd11,fcd04,fcduser,fcdgrup,fcdmodu,fcddate,
        fcdud01,fcdud02,fcdud03,fcdud04,fcdud05,
        fcdud06,fcdud07,fcdud08,fcdud09,fcdud10,
        fcdud11,fcdud12,fcdud13,fcdud14,fcdud15,
        fcdoriu,fcdorig                              #TQC-B20170
 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp    #ok              #欄位說明
           CASE
              WHEN INFIELD(fcd05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_alg"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fcd05
                 NEXT FIELD fcd05
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

    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fcduser', 'fcdgrup')
 
    # 螢幕上取單身條件
    CONSTRUCT g_wc2 ON fce02,fce03,fce031,fce06,fce061,fce20,fce21,
                       fce05,fce24,fce04,fce07,
                       fceud01,fceud02,fceud03,fceud04,fceud05,
                       fceud06,fceud07,fceud08,fceud09,fceud10,
                       fceud11,fceud12,fceud13,fceud14,fceud15
                 FROM  s_fce[1].fce02,s_fce[1].fce03,s_fce[1].fce031,
                       s_fce[1].fce06,s_fce[1].fce061,s_fce[1].fce20,
                       s_fce[1].fce21,s_fce[1].fce05,s_fce[1].fce24,
                       s_fce[1].fce04,s_fce[1].fce07,
                       s_fce[1].fceud01,s_fce[1].fceud02,s_fce[1].fceud03,
                       s_fce[1].fceud04,s_fce[1].fceud05,s_fce[1].fceud06,
                       s_fce[1].fceud07,s_fce[1].fceud08,s_fce[1].fceud09,
                       s_fce[1].fceud10,s_fce[1].fceud11,s_fce[1].fceud12,
                       s_fce[1].fceud13,s_fce[1].fceud14,s_fce[1].fceud15
 
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE
              WHEN INFIELD(fce03)    #查詢資產資料
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj01"   #No.MOD-850024 modify q_faj1 -> q_faj01
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO fce03
                 NEXT FIELD fce03
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
 
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
       LET g_sql = "SELECT fcd01 FROM fcd_file",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY 1"
     ELSE                                       # 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE fcd01 ",
                   "  FROM fcd_file, fce_file",
                   " WHERE fcd01 = fce01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t900_prepare FROM g_sql
    DECLARE t900_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t900_prepare
 
    IF g_wc2 = " 1=1 " THEN                     # 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM fcd_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT fcd01) FROM fcd_file,fce_file WHERE ",
                  "fce01=fcd01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t900_count_pre FROM g_sql
    DECLARE t900_count CURSOR WITH HOLD  FOR t900_count_pre
END FUNCTION
 
#中文的MENU
FUNCTION t900_menu()
 
   WHILE TRUE
      CALL t900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t900_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t900_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t900_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t900_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t900_sure('Y')
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t900_sure('N')
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t900_x()              #FUN-D20035
               CALL t900_x(1)           #FUN-D20035
            END IF
  
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t900_x(2)
            END IF
         #FUN-D20035---add---end

         WHEN "re_costing"
            IF cl_chk_act_auth() THEN
               CALL t900_m()
            END IF
         WHEN "assess"
            IF cl_chk_act_auth() THEN
               CALL t900_1()
            END IF
         WHEN "setting"
            IF cl_chk_act_auth() THEN
               CALL t900_2()
            END IF
         WHEN "undo_setting"
            IF cl_chk_act_auth() THEN
               CALL t900_3()
            END IF
          WHEN "related_document"  #No.MOD-470515
            IF cl_chk_act_auth() THEN
               IF g_fcd.fcd01 IS NOT NULL THEN
                  LET g_doc.column1 = "fcd01"
                  LET g_doc.value1 = g_fcd.fcd01
                  CALL cl_doc()
               END IF
            END IF
         WHEN "exporttoexcel"   #No.FUN-4B0019
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_fce),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t900_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_fce.clear()
    CALL l_fce.clear()
    CALL m_fce.clear()
    INITIALIZE g_fcd.* TO NULL
    LET g_fcd01_t = NULL
    LET g_fcd_o.* = g_fcd.*
    LET g_fcd_t.* = g_fcd.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_fcd.fcd02  =g_today
        LET g_fcd.fcdconf='N'              #確認碼無效
        LET g_fcd.fcdprsw=0                #列印次數
        LET g_fcd.fcduser=g_user
        LET g_fcd.fcdgrup=g_grup
        LET g_fcd.fcddate=g_today
        LET g_fcd.fcdlegal=g_legal         #FUN-980003 add
        LET g_fcd.fcdoriu=g_user           #TQC-B20170 add
        LET g_fcd.fcdorig=g_grup           #TQC-B20170 add
        CALL t900_i("a")                   #輸入單頭
        IF INT_FLAG THEN                   #使用者不玩了
            LET INT_FLAG = 0
            INITIALIZE g_fcd.* TO NULL
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        IF g_fcd.fcd01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_fcd.fcdoriu = g_user      #No.FUN-980030 10/01/04
        LET g_fcd.fcdorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO fcd_file VALUES (g_fcd.*)
        IF SQLCA.sqlcode THEN                           #置入資料庫不成功
            CALL cl_err3("ins","fcd_file",g_fcd.fcd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        LET g_fcd_t.* = g_fcd.*
        SELECT fcd01 INTO g_fcd.fcd01 FROM fcd_file
         WHERE fcd01 = g_fcd.fcd01
        LET g_rec_b=0
        CALL t900_g()                   #自動開窗選擇抵押資料
        CALL t900_b()                   #輸入單身
        CALL t900_b_fill('1=1')                 #單身
        LET g_fcd01_t = g_fcd.fcd01        #保留舊值
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t900_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_fcd.fcd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    SELECT * INTO g_fcd.* FROM fcd_file WHERE fcd01 = g_fcd.fcd01
    IF g_fcd.fcdconf = 'Y' THEN RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_fcd01_t = g_fcd.fcd01
    LET g_fcd_o.* = g_fcd.*
    BEGIN WORK
 
    OPEN t900_cl USING g_fcd.fcd01
    IF STATUS THEN
       CALL cl_err("OPEN t900_cl:", STATUS, 1)
       CLOSE t900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t900_cl INTO g_fcd.*              # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t900_cl ROLLBACK WORK RETURN
    END IF
    CALL t900_show()
    WHILE TRUE
        LET g_fcd01_t = g_fcd.fcd01
        LET g_fcd.fcdmodu=g_user
        LET g_fcd.fcddate=g_today
        CALL t900_i("u")                      #欄位更改
        IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_fcd.*=g_fcd_t.*
           CALL t900_show()
            CALL cl_err('','9001',0)
           EXIT WHILE
        END IF
        IF g_fcd.fcd01 != g_fcd01_t THEN            # 更改單號
            UPDATE fce_file SET fce01 = g_fcd.fcd01
                WHERE fce01 = g_fcd01_t
            IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","fce_file",g_fcd01_t,"",SQLCA.sqlcode,"","fce",1)  #No.FUN-660136
                CONTINUE WHILE
            END IF
        END IF
        UPDATE fcd_file SET fcd_file.* = g_fcd.*
            WHERE fcd01 = g_fcd.fcd01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","fcd_file",g_fcd01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t900_cl
        COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t900_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入       #No.FUN-680070 VARCHAR(1)
    l_n1            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    p_cmd           LIKE type_file.chr1                  #a:輸入 u:更改       #No.FUN-680070 VARCHAR(1)
 
    DISPLAY BY NAME g_fcd.fcd01,g_fcd.fcd02,g_fcd.fcd03,g_fcd.fcd12,
                    g_fcd.fcd05,g_fcd.fcd06,g_fcd.fcd07,g_fcd.fcd08,
                    g_fcd.fcd09,g_fcd.fcd10,g_fcd.fcd11,g_fcd.fcd04,
                    g_fcd.fcduser,g_fcd.fcdmodu,g_fcd.fcdgrup,
                    g_fcd.fcdoriu,g_fcd.fcdorig,                                #TQC-B20170
                    g_fcd.fcddate,g_fcd.fcdconf,
                    g_fcd.fcdud01,g_fcd.fcdud02,g_fcd.fcdud03,g_fcd.fcdud04,
                    g_fcd.fcdud05,g_fcd.fcdud06,g_fcd.fcdud07,g_fcd.fcdud08,
                    g_fcd.fcdud09,g_fcd.fcdud10,g_fcd.fcdud11,g_fcd.fcdud12,
                    g_fcd.fcdud13,g_fcd.fcdud14,g_fcd.fcdud15
 
    CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
 
    INPUT BY NAME
        g_fcd.fcd01,g_fcd.fcd02,
        g_fcd.fcdud01,g_fcd.fcdud02,g_fcd.fcdud03,g_fcd.fcdud04,
        g_fcd.fcdud05,g_fcd.fcdud06,g_fcd.fcdud07,g_fcd.fcdud08,
        g_fcd.fcdud09,g_fcd.fcdud10,g_fcd.fcdud11,g_fcd.fcdud12,
        g_fcd.fcdud13,g_fcd.fcdud14,g_fcd.fcdud15
        WITHOUT DEFAULTS
 
 
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t900_set_entry(p_cmd)
           CALL t900_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
 
        AFTER FIELD fcd01
          IF NOT cl_null(g_fcd.fcd01) THEN
            IF p_cmd='a' OR (p_cmd='u' AND g_fcd.fcd01!=g_fcd01_t) THEN
               SELECT count(*) INTO g_cnt FROM fcd_file
                WHERE fcd01 = g_fcd.fcd01
                IF g_cnt > 0 THEN   #資料重複
                    CALL cl_err(g_fcd.fcd01,-239,0)
                    LET g_fcd.fcd01 = g_fcd01_t
                    DISPLAY BY NAME g_fcd.fcd01
                    NEXT FIELD fcd01
                END IF
            END IF
         END IF
         LET g_fcd_o.fcd01 = g_fcd.fcd01
       AFTER FIELD fcdud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fcdud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION CONTROLF                  #欄位說明
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
FUNCTION t900_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fcd01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t900_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("fcd01",FALSE)
    END IF
 
END FUNCTION
#Query 查詢
FUNCTION t900_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_fcd.* TO NULL             #No.FUN-6A0001
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t900_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_fcd.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t900_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_fcd.* TO NULL
    ELSE
        OPEN t900_count
        FETCH t900_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t900_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t900_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式       #No.FUN-680070 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數       #No.FUN-680070 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t900_cs INTO g_fcd.fcd01
        WHEN 'P' FETCH PREVIOUS t900_cs INTO g_fcd.fcd01
        WHEN 'F' FETCH FIRST    t900_cs INTO g_fcd.fcd01
        WHEN 'L' FETCH LAST     t900_cs INTO g_fcd.fcd01
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
            FETCH ABSOLUTE g_jump t900_cs INTO g_fcd.fcd01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)
        INITIALIZE g_fcd.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_fcd.* FROM fcd_file WHERE fcd01 = g_fcd.fcd01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","fcd_file",g_fcd.fcd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
        INITIALIZE g_fcd.* TO NULL
        RETURN
    END IF
    CALL t900_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t900_show()
    LET g_fcd_t.* = g_fcd.*                #保存單頭舊值
    DISPLAY BY NAME                              # 顯示單頭值
 
        g_fcd.fcd01,g_fcd.fcd02,g_fcd.fcd03,
        g_fcd.fcd04,g_fcd.fcd05,g_fcd.fcd06,
        g_fcd.fcd07,g_fcd.fcd08,g_fcd.fcd09,
        g_fcd.fcd10,g_fcd.fcd11,g_fcd.fcd12,
        g_fcd.fcduser,g_fcd.fcdgrup,g_fcd.fcdmodu,
        g_fcd.fcdoriu,g_fcd.fcdorig,                  #TQC-B20170
        g_fcd.fcddate,g_fcd.fcdconf,
        g_fcd.fcdud01,g_fcd.fcdud02,g_fcd.fcdud03,g_fcd.fcdud04,
        g_fcd.fcdud05,g_fcd.fcdud06,g_fcd.fcdud07,g_fcd.fcdud08,
        g_fcd.fcdud09,g_fcd.fcdud10,g_fcd.fcdud11,g_fcd.fcdud12,
        g_fcd.fcdud13,g_fcd.fcdud14,g_fcd.fcdud15
 
 
    IF g_fcd.fcdconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_fcd.fcdconf,"","","",g_chr,"")
    LET g_alg02=''
    SELECT alg02 INTO g_alg02 FROM alg_file WHERE alg01=g_fcd.fcd05
    DISPLAY g_alg02 TO alg02
    LET g_fcf04 = 0
    SELECT SUM(fcf04) INTO g_fcf04 FROM fcf_file WHERE fcf03 = g_fcd.fcd01
                                                   AND fcfconf = 'Y'
    DISPLAY g_fcf04 TO fcf04
    CALL t900_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t900_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
    DEFINE l_fce03     LIKE fce_file.fce03,   #MOD-650099
           l_fce031    LIKE fce_file.fce031   #MOD-650099
 
    IF s_shut(0) THEN RETURN END IF
    IF g_fcd.fcd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    SELECT * INTO g_fcd.* FROM fcd_file WHERE fcd01 = g_fcd.fcd01
    IF g_fcd.fcdconf = 'Y' THEN RETURN END IF
    BEGIN WORK
 
    OPEN t900_cl USING g_fcd.fcd01
    IF STATUS THEN
       CALL cl_err("OPEN t900_cl:", STATUS, 1)
       CLOSE t900_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t900_cl INTO g_fcd.*
    IF SQLCA.sqlcode THEN
      CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)
      CLOSE t900_cl ROLLBACK WORK RETURN
    END IF
    CALL t900_show()
    IF cl_delh(20,16)  THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "fcd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_fcd.fcd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                             #No.FUN-9B0098 10/02/24
        DECLARE fce_c CURSOR FOR
         SELECT fce03,fce031 FROM fce_file
          WHERE fce01=g_fcd.fcd01
        FOREACH fce_c INTO l_fce03,l_fce031
          UPDATE faj_file SET faj41 = '1' #未抵押
                        WHERE faj02 = l_fce03
                          AND faj022= l_fce031
          IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","faj_file",l_fce03,l_fce031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
              ROLLBACK WORK
              RETURN
          END IF
        END FOREACH
        DELETE FROM fcd_file WHERE fcd01 = g_fcd.fcd01
        IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","fcd_file",g_fcd.fcd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                ROLLBACK WORK RETURN
        END IF
        DELETE FROM fce_file WHERE fce01 = g_fcd.fcd01
    END IF
    CLEAR FORM
    CALL g_fce.clear()
    CALL l_fce.clear()
    CALL m_fce.clear()
    INITIALIZE g_fcd.* TO NULL
    OPEN t900_count
    #FUN-B50062-add-start--
    IF STATUS THEN
       CLOSE t900_cs
       CLOSE t900_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50062-add-end--
    FETCH t900_count INTO g_row_count
    #FUN-B50062-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE t900_cs
       CLOSE t900_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50062-add-end--
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t900_cs
    IF g_curs_index = g_row_count + 1 THEN
       LET g_jump = g_row_count
       CALL t900_fetch('L')
    ELSE
       LET g_jump = g_curs_index
       LET mi_no_ask = TRUE
       CALL t900_fetch('/')
    END IF
    CLOSE t900_cl
    COMMIT WORK
END FUNCTION
 
#單身
FUNCTION t900_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_total         LIKE type_file.num20_6,  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
DEFINE l_faj41      LIKE faj_file.faj41    #MOD-B30362
DEFINE l_faj17      LIKE faj_file.faj17    #MOD-B30362
 
    LET g_action_choice = ""
    IF g_fcd.fcd01 IS NULL  THEN RETURN END IF
    IF g_fcd.fcdconf  = 'Y' THEN RETURN END IF
    IF g_fcd.fcdconf = 'X' THEN
         CALL cl_err('','9024',0) RETURN
    END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT fce02,fce03,fce031,'','','','',fce06,fce061, ",
                       " fce20,fce21,fce05,fce24,fce04,fce07, ",
                       "       fceud01,fceud02,fceud03,fceud04,fceud05,",
                       "       fceud06,fceud07,fceud08,fceud09,fceud10,",
                       "       fceud11,fceud12,fceud13,fceud14,fceud15 ",
                       " FROM fce_file ",
                       " WHERE fce01= ? ",
                       " AND fce03= ? ",
                       " AND fce031=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
        LET l_ac_t =  0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
   IF g_rec_b=0 THEN CALL g_fce.clear() END IF
 
 
        INPUT ARRAY g_fce WITHOUT DEFAULTS FROM s_fce.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
          IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
          END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()       #目前筆數
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()                #目前的array共有幾筆
            BEGIN WORK
 
            OPEN t900_cl USING g_fcd.fcd01
            IF STATUS THEN
               CALL cl_err("OPEN t900_cl:", STATUS, 1)
               CLOSE t900_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t900_cl INTO g_fcd.*              # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t900_cl ROLLBACK WORK RETURN
            END IF
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_fce_t.* = g_fce[l_ac].*  #BACKUP
 
                OPEN t900_bcl USING g_fcd.fcd01,g_fce_t.fce03,g_fce_t.fce031
                IF STATUS THEN
                   CALL cl_err("OPEN t900_bcl:", STATUS, 1)
                   CLOSE t900_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t900_bcl INTO g_fce[l_ac].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(g_fce_t.fce02,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                IF l_ac <= l_n then                   #DISPLAY NEWEST
                    CALL t900_showfaj()               #將此筆財產之資料帶入
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            IF cl_null(g_fce[l_ac].fce031) THEN
               LET g_fce[l_ac].fce031 = ' '
            END IF
             INSERT INTO fce_file (fce01,fce02,fce03,fce031,fce04,fce05,  #No:BUG-470041 #No.MOD-470565
                                   fce06,fce061,fce07,fce08,fce09,fce10,  #No.MOD-470565
                                  fce11,fce12,fce20,fce21,fce22,fce23,
                                  fce24,fce25,
                                  fceud01,fceud02,fceud03,
                                  fceud04,fceud05,fceud06,
                                  fceud07,fceud08,fceud09,
                                  fceud10,fceud11,fceud12,
                                  fceud13,fceud14,fceud15,
                                  fcelegal) #FUN-980003 add
                 VALUES(g_fcd.fcd01,g_fce[l_ac].fce02,g_fce[l_ac].fce03,
                        g_fce[l_ac].fce031,g_fce[l_ac].fce04,g_fce[l_ac].fce05,
                        g_fce[l_ac].fce06,g_fce[l_ac].fce061,g_fce[l_ac].fce07,'',
                        g_fce[l_ac].fce04,g_fce[l_ac].fce05,g_fce[l_ac].fce20,
                        g_fce[l_ac].fce21,g_fce[l_ac].fce20,g_fce[l_ac].fce21,
                        '','',g_fce[l_ac].fce24,g_fce[l_ac].fce24,
                        g_fce[l_ac].fceud01,
                        g_fce[l_ac].fceud02,
                        g_fce[l_ac].fceud03,
                        g_fce[l_ac].fceud04,
                        g_fce[l_ac].fceud05,
                        g_fce[l_ac].fceud06,
                        g_fce[l_ac].fceud07,
                        g_fce[l_ac].fceud08,
                        g_fce[l_ac].fceud09,
                        g_fce[l_ac].fceud10,
                        g_fce[l_ac].fceud11,
                        g_fce[l_ac].fceud12,
                        g_fce[l_ac].fceud13,
                        g_fce[l_ac].fceud14,
                        g_fce[l_ac].fceud15,
                        g_legal) #FUN-980003 add
 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","fce_file",g_fcd.fcd01,g_fce[l_ac].fce02,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_feature = ' '
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
                IF g_fce[l_ac].fce05 != g_fce_t.fce05 THEN
                    #  將帳面價值[fce04],抵減金額[fce05]累加至主件
                    SELECT SUM(fce05) INTO l_total FROM fce_file
                     WHERE fce01 = g_fcd.fcd01
                       AND fce06 = '          '
                     UPDATE fcd_file SET fcd03 = l_total
                      WHERE fcd01 = g_fcd.fcd01
                    LET g_fcd.fcd03 = l_total
                    DISPLAY g_fcd.fcd03 TO fcd03
                    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
                END IF
                CALL t900_add()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_fce[l_ac].* TO NULL      #900423
            LET g_fce[l_ac].fce07 = '1'
            LET g_fce_t.* = g_fce[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD fce02
 
        BEFORE FIELD fce02                            #default 序號
            IF g_fce[l_ac].fce02 IS NULL OR
               g_fce[l_ac].fce02 = 0 THEN
               SELECT max(fce02)+1
                 INTO g_fce[l_ac].fce02
                 FROM fce_file
                WHERE fce01 = g_fcd.fcd01
                IF g_fce[l_ac].fce02 IS NULL THEN
                   LET g_fce[l_ac].fce02 = 1
                END IF
            END IF
 
        AFTER FIELD fce02                        #check 序號是否重複
            IF NOT cl_null(g_fce[l_ac].fce02) THEN
               IF g_fce[l_ac].fce02 != g_fce_t.fce02 OR
                  g_fce_t.fce02 IS NULL THEN
                  SELECT count(*) INTO l_n FROM fce_file
                   WHERE fce01 = g_fcd.fcd01
                     AND fce02 = g_fce[l_ac].fce02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_fce[l_ac].fce02 = g_fce_t.fce02
                       NEXT FIELD fce02
                   END IF
               END IF
            END IF
 
        AFTER FIELD fce03                        #財產編號
            IF NOT cl_null(g_fce[l_ac].fce03) THEN
               IF g_fce[l_ac].fce03 != g_fce_t.fce03 OR g_fce_t.fce03 IS NULL
               THEN
                  #該財產編號必須存在資產基本資料檔faj_file中。
                  SELECT COUNT(*) INTO l_n FROM faj_file
                   WHERE faj02 = g_fce[l_ac].fce03
                   IF l_n < 1  THEN
                       CALL cl_err('','afa-041',0)
                       LET g_fce[l_ac].fce03 = g_fce_t.fce03
                       NEXT FIELD fce03
                   END IF
               END IF
            END IF
 
        AFTER FIELD fce031                       #財產附號
            IF g_fce[l_ac].fce031 != g_fce_t.fce031 OR
               g_fce_t.fce031 IS NULL
            THEN
                 IF cl_null(g_fce[l_ac].fce031) THEN 
                    LET g_fce[l_ac].fce031 = ' ' 
                 END IF  
                 #-->該財產編號+附號須存在固定資產資料檔[faj_file]中。
                 SELECT COUNT(*) INTO l_n FROM faj_file
                  WHERE faj02 = g_fce[l_ac].fce03
                    AND faj022= g_fce[l_ac].fce031
                  IF l_n < 1 THEN
                     CALL cl_err('','afa-041',0)
                     LET g_fce[l_ac].fce031 = g_fce_t.fce031
                     NEXT FIELD fce03
                  END IF
                 #必須存在固定資產基本資料檔已確認且資產狀態不為[056X]!                                                             
                  SELECT COUNT(*) INTO l_n FROM faj_file                                                                            
                   WHERE faj02  = g_fce[l_ac].fce03                                                                                 
                     AND faj022 = g_fce[l_ac].fce031                                                                                
                     AND fajconf='Y'                                                                                                
                     AND faj43 NOT IN ('0','5','6','X')                                                                                 
                  IF l_n < 1 THEN                                                                                                   
                     CALL cl_err('','afa-093',0)                                                                                    
                     LET g_fce[l_ac].fce031 = g_fce_t.fce031                                                                        
                     NEXT FIELD fce03                                                                                               
                  END IF                                                                                                            
                  #MOD-B30362--add--str--
                  SELECT faj41 INTO l_faj41 FROM faj_file
                   WHERE faj02 = g_fce[l_ac].fce03
                     AND faj022= g_fce[l_ac].fce031
                  IF l_faj41 <> '1' THEN
                     CALL cl_err('','afa-133',0)
                     LET g_fce[l_ac].fce031 = g_fce_t.fce031
                     NEXT FIELD fce03
                  END IF
                  #TQC-C70159--add--str--
                  LET g_fcf04 = 0
                  SELECT SUM(fcf04) INTO g_fcf04 FROM fcf_file WHERE fcf03 = g_fcd.fcd01
                                                                 AND fcfconf = 'Y'
                  IF cl_null(g_fcf04) THEN
                     LET g_fcf04 = 0
                  END IF
                  #TQC-C70159--add--str--
                  SELECT COUNT(*) INTO l_n FROM fce_file,fcd_file,fcf_file    #TQC-C70159  add fcd_file,fcf_file
                   WHERE fce03 = g_fce[l_ac].fce03
                     AND fce01 <> g_fcd.fcd01
                     AND fce031= g_fce[l_ac].fce031
                     #TQC-C70159--add--str--
                     AND fce01 = fcd01  
                     AND fce01 = fcf03
                     AND fcdconf = 'Y'
                     AND fcd07  != g_fcf04
                     #TQC-C70159--add--end--
                  IF l_n > 0 THEN
                     CALL cl_err('','aec-009',0)
                     LET g_fce[l_ac].fce031 = g_fce_t.fce031
                     NEXT FIELD fce03
                  END IF
                  #MOD-B30362--add--end--
                  CALL t900_showfaj() # 預設資產分類
                  #-->預設帳面價值(faj33) 抵押金額 (faj33)
                  SELECT faj33,faj33,faj17-faj58,faj18,
                         faj14+faj141-faj59
                  INTO g_fce[l_ac].fce04,g_fce[l_ac].fce05,
                       g_fce[l_ac].fce20,g_fce[l_ac].fce21,
                       g_fce[l_ac].fce24
                  FROM faj_file
                  WHERE faj02 = g_fce[l_ac].fce03
                    AND faj022= g_fce[l_ac].fce031
            END IF
 
        AFTER FIELD fce06                        #合併編號
            IF NOT cl_null(g_fce[l_ac].fce06) THEN
               SELECT COUNT(*) INTO l_n FROM fce_file
                WHERE fce01 = g_fcd.fcd01
                  AND fce03 = g_fce[l_ac].fce06
                IF l_n < 1  THEN
                    CALL cl_err(g_fce[l_ac].fce06,'afa-166',0)
                    LET g_fce[l_ac].fce06 = g_fce_t.fce06
                    DISPLAY BY NAME g_fce[l_ac].fce06
                    NEXT FIELD fce06
                END IF
                SELECT COUNT(*) INTO l_n FROM faj_file
                 WHERE faj02 = g_fce[l_ac].fce06
                # 若該財產編號在資產基本資料檔[faj_file]只有一筆資料時(無附件)
                # . 不可輸入「財產附號」欄位。 ..直接跳至發票號碼
                IF l_n = 1 THEN
                   LET g_fce[l_ac].fce061 = '    '
                   NEXT FIELD fce07
                END IF
            ELSE
                LET g_fce[l_ac].fce06 = ' '
            END IF
 
        AFTER FIELD fce061                       #合併附號
            IF NOT cl_null(g_fce[l_ac].fce061) THEN
               SELECT COUNT(*)
                 INTO l_n
                 FROM fce_file
                WHERE fce03 = g_fce[l_ac].fce06
                  AND fce031= g_fce[l_ac].fce061
                IF l_n < 1  THEN
                    CALL cl_err(g_fce[l_ac].fce061,'afa-166',0)
                    LET g_fce[l_ac].fce061 = g_fce_t.fce061
                    NEXT FIELD fce061
                END IF
               SELECT COUNT(*)
                 INTO l_n
                 FROM faj_file
                WHERE faj02 = g_fce[l_ac].fce06
                  AND faj022= g_fce[l_ac].fce061
                IF l_n < 0  THEN
                    CALL cl_err(g_fce[l_ac].fce061,'afa-167',0)
                    LET g_fce[l_ac].fce061 = g_fce_t.fce061
                    DISPLAY BY NAME g_fce[l_ac].fce061
                    DISPLAY BY NAME g_fce[l_ac].fce061
                    NEXT FIELD fce06
                END IF
            ELSE
                LET g_fce[l_ac].fce061 = '    '
            END IF
        AFTER FIELD fce20
            IF NOT cl_null(g_fce[l_ac].fce20) THEN
               IF g_fce[l_ac].fce20 < 0 THEN
                  CALL cl_err(g_fce[l_ac].fce20,'axm-179',0)
                  NEXT FIELD fce20
               END IF
               #MOD-B30362--add--str--
               SELECT faj17 INTO l_faj17 FROM faj_file
                WHERE faj02 = g_fce[l_ac].fce03
                  AND faj022= g_fce[l_ac].fce031
               IF g_fce[l_ac].fce20 > l_faj17 THEN
                  CALL cl_err('','afa1004',0)
                  LET g_fce[l_ac].fce20 = g_fce_t.fce20
                  NEXT FIELD fce20
               END IF                  
               #MOD-B30362--add--end--
            END IF
 
        AFTER FIELD fce05
            IF NOT cl_null(g_fce[l_ac].fce05) THEN
               IF g_fce[l_ac].fce05 > g_fce[l_ac].fce04 THEN
                  CALL cl_err('','afa-921',0)
               END IF
               IF g_fce[l_ac].fce05 < 0 THEN
                  CALL cl_err(g_fce[l_ac].fce05,'axm-179',0)
                  NEXT FIELD fce05
               END IF
            END IF
       AFTER FIELD fceud01
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud02
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud03
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud04
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud05
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud06
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud07
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud08
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud09
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud10
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud11
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud12
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud13
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud14
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
       AFTER FIELD fceud15
          IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_fce_t.fce02 > 0 AND
               g_fce_t.fce02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                UPDATE faj_file SET faj41 = '1' #未抵押
                              WHERE faj02 = g_fce_t.fce03
                                AND faj022= g_fce_t.fce031
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","faj_file",g_fce_t.fce03,g_fce_t.fce031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                DELETE FROM fce_file
                 WHERE fce01 = g_fcd.fcd01
                   AND fce03 = g_fce_t.fce03
                   AND fce031 = g_fce_t.fce031
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","fce_file",g_fcd.fcd01,g_fce_t.fce03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
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
               LET g_fce[l_ac].* = g_fce_t.*
               CLOSE t900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_fce[l_ac].fce02,-263,1)
               LET g_fce[l_ac].* = g_fce_t.*
            ELSE
               IF cl_null(g_fce[l_ac].fce031) THEN
                   LET g_fce[l_ac].fce031 = ' '
               END IF
               UPDATE fce_file SET
                fce02=g_fce[l_ac].fce02,fce03=g_fce[l_ac].fce03,
                fce031=g_fce[l_ac].fce031,fce04=g_fce[l_ac].fce04,
                fce05=g_fce[l_ac].fce05,fce06=g_fce[l_ac].fce06,
                fce061=g_fce[l_ac].fce061,fce07=g_fce[l_ac].fce07,
                fce10=g_fce[l_ac].fce05,fce20=g_fce[l_ac].fce20,
                fce21=g_fce[l_ac].fce21,fce24=g_fce[l_ac].fce24,
                fceud01 = g_fce[l_ac].fceud01,
                fceud02 = g_fce[l_ac].fceud02,
                fceud03 = g_fce[l_ac].fceud03,
                fceud04 = g_fce[l_ac].fceud04,
                fceud05 = g_fce[l_ac].fceud05,
                fceud06 = g_fce[l_ac].fceud06,
                fceud07 = g_fce[l_ac].fceud07,
                fceud08 = g_fce[l_ac].fceud08,
                fceud09 = g_fce[l_ac].fceud09,
                fceud10 = g_fce[l_ac].fceud10,
                fceud11 = g_fce[l_ac].fceud11,
                fceud12 = g_fce[l_ac].fceud12,
                fceud13 = g_fce[l_ac].fceud13,
                fceud14 = g_fce[l_ac].fceud14,
                fceud15 = g_fce[l_ac].fceud15
 
                WHERE fce01=g_fcd.fcd01
                  AND fce03 =g_fce_t.fce03
                  AND fce031=g_fce_t.fce031
               IF cl_null(g_fce[l_ac].fce06) THEN       #No.TQC-980054 mod
                   UPDATE fce_file SET
                          fce09=g_fce[l_ac].fce04,fce10=g_fce[l_ac].fce05,
                          fce11=g_fce[l_ac].fce20,fce12=g_fce[l_ac].fce21,
                          fce25=g_fce[l_ac].fce24
                    WHERE fce01=g_fcd.fcd01
                      AND fce03 =g_fce_t.fce03
                      AND fce031=g_fce_t.fce031
               END IF
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","fce_file",g_fcd.fcd01,g_fce_t.fce03,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                   LET g_fce[l_ac].* = g_fce_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
               IF g_fce[l_ac].fce05 != g_fce_t.fce05 THEN
                    #  將帳面價值[fce04],抵減金額[fce05]累加至主件
                    SELECT SUM(fce05) INTO l_total FROM fce_file
                     WHERE fce01 = g_fcd.fcd01
                       AND fce06 = '          '
                     UPDATE fcd_file SET fcd03 = l_total
                      WHERE fcd01 = g_fcd.fcd01
                    LET g_fcd.fcd03 = l_total
                    DISPLAY g_fcd.fcd03 TO fcd03
                    IF STATUS THEN CALL cl_err('',STATUS,0) END IF
                END IF
                CALL t900_add()
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac  #FUN-D30032 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_fce[l_ac].* = g_fce_t.*
               #FUN-D30032--add--begin--
               ELSE
                  CALL g_fce.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end----
               END IF
               CLOSE t900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 add
            CLOSE t900_bcl
            COMMIT WORK
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(fce03)    #查詢資產資料
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_faj01"    #No.MOD-850024 modify q_faj1 -> q_faj01
                 LET g_qryparam.default1 = g_fce[l_ac].fce03
                 LET g_qryparam.default2 = g_fce[l_ac].fce031
                 CALL cl_create_qry() RETURNING
                      g_fce[l_ac].fce03,g_fce[l_ac].fce031
                 DISPLAY g_fce[l_ac].fce03 TO fce03
                 DISPLAY g_fce[l_ac].fce031 TO fce031
                 NEXT FIELD fce03
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(fce02) AND l_ac > 1 THEN
                LET g_fce[l_ac].* = g_fce[l_ac-1].*
                NEXT FIELD fce02
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
 
    LET g_fcd.fcdmodu = g_user
    LET g_fcd.fcddate = g_today
    UPDATE fcd_file SET fcdmodu = g_fcd.fcdmodu,fcddate = g_fcd.fcddate
     WHERE fcd01 = g_fcd.fcd01
    DISPLAY BY NAME g_fcd.fcdmodu,g_fcd.fcddate
 
    CLOSE t900_cl
    CLOSE t900_bcl
    COMMIT WORK
    CALL t900_delHeader()     #CHI-C30002 add
#   CALL t900_delall()        #CHI-C30002 mark
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t900_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_fcd.fcd01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM fcd_file ",
                  "  WHERE fcd01 LIKE '",l_slip,"%' ",
                  "    AND fcd01 > '",g_fcd.fcd01,"'"
      PREPARE t900_pb1 FROM l_sql 
      EXECUTE t900_pb1 INTO l_cnt 
      
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
        #CALL t900_x()              #FUN-D20035
         CALL t900_x(1)             #FUN-D20035
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM fcd_file WHERE fcd01 = g_fcd.fcd01
         INITIALIZE g_fcd.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t900_delall()
#   SELECT COUNT(*) INTO g_cnt FROM fce_file
#       WHERE fce01=g_fcd.fcd01
#   IF g_cnt = 0 THEN                   # 未輸入單身資料, 則取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM fcd_file WHERE fcd01 = g_fcd.fcd01
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t900_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(200)
 
    # 螢幕上取單身條件
    CONSTRUCT g_wc2 ON fce02,fce03,fce031,fce06,fce061,fce24,fce07,
                       fce20,fce21,fce04,fce05
                 FROM  s_fce[1].fce02,s_fce[1].fce03,s_fce[1].fce031,
                       s_fce[1].fce06,s_fce[1].fce061,s_fce[1].fce24,
                       s_fce[1].fce07,s_fce[1].fce20,s_fce[1].fce21,
                       s_fce[1].fce04,s_fce[1].fce05
 
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
    CALL t900_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t900_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(300)
    l_total         LIKE type_file.num20_6  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
 
    IF cl_null(p_wc2) THEN LET p_wc2=" 1=1 "  END IF  #No:8141
    LET g_sql =
        "SELECT fce02,fce03,fce031,faj06,faj04,faj25,faj49,fce06,fce061,",
        "       fce20,fce21,fce05,fce24,fce04,fce07,",
        "       fceud01,fceud02,fceud03,fceud04,fceud05,",
        "       fceud06,fceud07,fceud08,fceud09,fceud10,",
        "       fceud11,fceud12,fceud13,fceud14,fceud15 ",
        " FROM fce_file LEFT JOIN faj_file ON fce03 = faj02 AND fce031 = faj022 ",
        " WHERE fce01 ='",g_fcd.fcd01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE t900_pb FROM g_sql
    DECLARE fce_curs                       #SCROLL CURSOR
        CURSOR FOR t900_pb
 
    CALL g_fce.clear()	
    LET l_total = 0
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fce_curs INTO g_fce[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF g_fce[g_cnt].fce06 = '          ' THEN
           LET l_total = l_total + g_fce[g_cnt].fce05
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_fce.deleteElement(g_cnt)   #取消 Array Element
    LET g_rec_b = g_cnt -1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
    UPDATE fcd_file SET fcd03 = l_total WHERE fcd01 = g_fcd.fcd01
    IF STATUS THEN 
       CALL cl_err3("upd","fcd_file",g_fcd.fcd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
    END IF
    LET g_fcd.fcd03 = l_total
    DISPLAY g_fcd.fcd03 TO fcd03
END FUNCTION
 
FUNCTION t900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_fce TO s_fce.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
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
         CALL t900_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION previous
         CALL t900_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION jump
         CALL t900_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION next
         CALL t900_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
      ON ACTION last
         CALL t900_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
 
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
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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

      #@ON ACTION 重新計算成本
      ON ACTION re_costing
         LET g_action_choice="re_costing"
         EXIT DISPLAY
      #@ON ACTION 鑑價
      ON ACTION assess
         LET g_action_choice="assess"
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029 
         EXIT DISPLAY
      #@ON ACTION 設定
      ON ACTION setting
         LET g_action_choice="setting"
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
         EXIT DISPLAY
      #@ON ACTION 取消設定
      ON ACTION undo_setting
         LET g_action_choice="undo_setting"
      CALL cl_set_head_visible("","YES")    #No.FUN-6B0029
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
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
FUNCTION t900_sure(l_chr)
DEFINE l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       l_cnt     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    IF l_chr='Y' THEN
        SELECT COUNT(*) INTO l_cnt FROM fce_file
         WHERE fce01= g_fcd.fcd01
        IF l_cnt = 0 THEN
           CALL cl_err('','mfg-009',0)
           RETURN
        END IF
    END IF
    SELECT * INTO g_fcd.* FROM fcd_file WHERE fcd01 = g_fcd.fcd01
    IF l_chr='Y' THEN
       IF g_fcd.fcdconf='Y' THEN 
          CALL cl_err('','9023',0)   #MOD-740450
          RETURN
       END IF
       IF cl_sure(0,0) THEN                   #確認一下
#CHI-C30107 ------------ add ------------ begin
          SELECT * INTO g_fcd.* FROM fcd_file WHERE fcd01 = g_fcd.fcd01
          IF g_fcd.fcdconf = 'X' THEN
             CALL cl_err('','9024',0) RETURN
          END IF
          IF g_fcd.fcdconf='Y' THEN
             CALL cl_err('','9023',0)   #MOD-740450
             RETURN
          END IF
#CHI-C30107 ------------ add ------------ end
          BEGIN WORK
 
          OPEN t900_cl USING g_fcd.fcd01
          IF STATUS THEN
             CALL cl_err("OPEN t900_cl:", STATUS, 1)
             CLOSE t900_cl
             ROLLBACK WORK
             RETURN
          END IF
          FETCH t900_cl INTO g_fcd.*              # 鎖住將被更改或取消的資料
          IF SQLCA.sqlcode THEN
             CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)      # 資料被他人LOCK
             CLOSE t900_cl ROLLBACK WORK RETURN
          END IF
          LET g_success = 'Y'
          CALL t900_surey()        #更新資產基本資料檔
          CLOSE t900_cl
          IF g_success = 'Y' THEN LET g_fcd.fcdconf='Y' COMMIT WORK
          ELSE LET g_fcd.fcdconf='N' ROLLBACK WORK END IF
          DISPLAY BY NAME g_fcd.fcdconf
       END IF
    ELSE
       SELECT COUNT(*) INTO s_cnt FROM fce_file
         WHERE fce07 = '1'
           AND fce01 = g_fcd.fcd01
         IF s_cnt != g_rec_b  THEN
            CALL cl_err('','afa-511',0)
            RETURN 
         END IF
         IF g_fcd.fcdconf='N' THEN 
            CALL cl_err('','9025',0) 
            RETURN 
         END IF
         IF cl_sure(0,0) THEN                   #確認一下
            BEGIN WORK
 
            OPEN t900_cl USING g_fcd.fcd01
            IF STATUS THEN
               CALL cl_err("OPEN t900_cl:", STATUS, 1)
               CLOSE t900_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t900_cl INTO g_fcd.*              # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t900_cl ROLLBACK WORK RETURN
            END IF
            LET g_success = 'Y'
            CALL t900_suren()        #更新資產基本資料檔
            CLOSE t900_cl
            IF g_success = 'Y' THEN LET g_fcd.fcdconf='N' COMMIT WORK
            ELSE LET g_fcd.fcdconf='Y' ROLLBACK WORK END IF
            DISPLAY BY NAME g_fcd.fcdconf
         END IF
    END IF
    IF g_fcd.fcdconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_fcd.fcdconf,"","","",g_chr,"")
END FUNCTION
 
FUNCTION t900_surey()
         DEFINE s_cnt      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
                l_sql        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
                l_fce10    LIKE    fce_file.fce10,
    s_fce_t         RECORD    #程式變數(Program Variables)
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        faj04       LIKE faj_file.faj04,   #類別
        faj25       LIKE faj_file.faj25,   #取得日期
        fce04       LIKE fce_file.fce04,   #帳面價值
        fce05       LIKE fce_file.fce04,   #抵減金額
        fce06       LIKE fce_file.fce06,   #合併財產編號
        fce061      LIKE fce_file.fce061,  #合併財產附號
        fce09       LIKE fce_file.fce09,   #合併前帳面價值
        fce10       LIKE fce_file.fce10,   #合併前抵減金額
        fce20       LIKE fce_file.fce20,   #數量
        fce21       LIKE fce_file.fce21,   #單位
        fce11       LIKE fce_file.fce11,   #合併前數量
        fce12       LIKE fce_file.fce12    #合併前單位
                    END RECORD
   DEFINE ls_tmp STRING
 
   LET l_ac = ARR_CURR()
 
    LET l_sql ="SELECT fce03,fce031,faj04,faj25,fce04,fce05,fce06,fce061, ",
        " fce09,fce10,fce20,fce21,fce11,fce12 ",
        " FROM fce_file,faj_file ",
        " WHERE fce01 ='",g_fcd.fcd01,"'",  #單頭
        "   AND fce03 = faj02 ",
        "   AND fce031= faj022 "
 
     PREPARE t900_sure FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('PREPARE t900_sure',SQLCA.sqlcode,1)
        RETURN
     END IF
     DECLARE t900_s_curs CURSOR FOR t900_sure
     DELETE FROM fce_temp
     FOREACH t900_s_curs INTO s_fce_t.*
 
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)                   
           EXIT FOREACH
        END IF
        INSERT INTO fce_temp
           VALUES('Y',s_fce_t.fce03,s_fce_t.fce031,s_fce_t.faj04,
                  s_fce_t.faj25,s_fce_t.fce04,s_fce_t.fce05,s_fce_t.fce06,
                  s_fce_t.fce061,s_fce_t.fce09,s_fce_t.fce10,
                  s_fce_t.fce20,s_fce_t.fce21,s_fce_t.fce11,
                  s_fce_t.fce12)
     END FOREACH
     LET p_row = 5 LET p_col = 14
     OPEN WINDOW t900_b AT p_row,p_col
          WITH FORM "afa/42f/afat900b"
           ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat900b")
 
   IF INT_FLAG THEN RETURN END IF
   CALL t900_b_filly()       # 單身
   CALL t900_bpy("D")
   CALL t900_by()
   IF g_success = 'N' THEN       #MOD-C40014 add
      CLOSE WINDOW t900_b        #MOD-C40014 add
      RETURN                     #MOD-C40014 add
   END IF                        #MOD-C40014 add
     DELETE FROM fce_file WHERE fce01 = g_fcd.fcd01 #--將原來的單身刪除
     CALL t900_putb()  # 將[Y] 者新增至單身中
     CLOSE WINDOW t900_b
     CALL t900_b_fill('1=1')       # 單身
     UPDATE fcd_file SET fcdconf='Y' WHERE fcd01=g_fcd.fcd01
     FOR s_cnt = 1 TO g_rec_b
 
         SELECT fce10 INTO l_fce10 FROM fce_file
          WHERE fce03 = g_fce[s_cnt].fce03 AND fce031= g_fce[s_cnt].fce031
         IF STATUS OR l_fce10 IS NULL THEN LET l_fce10 = 0 END IF
         #UPDATE faj_file SET faj41 = '4' ,             #抵押否   #TQC-C70173   mark
         UPDATE faj_file SET faj41 = '2',                         #TQC-C70173   add  
                             faj86 = faj86 + l_fce10   #申請底押金額
          WHERE faj02 = g_fce[s_cnt].fce03
            AND faj022= g_fce[s_cnt].fce031
     END FOR
END FUNCTION
 
FUNCTION t900_suren()
DEFINE s_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
                l_faj86      LIKE     faj_file.faj86,
                l_faj87      LIKE     faj_file.faj87,
                l_fce10      LIKE     fce_file.fce10
       LET s_cnt = 1
       UPDATE fcd_file SET fcdconf='N' WHERE fcd01=g_fcd.fcd01
       FOR s_cnt = 1 TO g_rec_b            #更新資產基本資料檔
           SELECT fce10 INTO l_fce10 FROM fce_file
            WHERE fce03 = g_fce[s_cnt].fce03 AND fce031= g_fce[s_cnt].fce031
           IF STATUS OR l_fce10 IS NULL THEN LET l_fce10 = 0 END IF
           UPDATE faj_file SET faj86 = faj86 - l_fce10
           WHERE faj02 = g_fce[s_cnt].fce03 AND faj022= g_fce[s_cnt].fce031
 
            SELECT faj86,faj87 INTO l_faj86,l_faj87 FROM faj_file
             WHERE faj02 = g_fce[s_cnt].fce03 AND faj022= g_fce[s_cnt].fce031
            IF l_faj86 + l_faj87 = 0 THEN
               UPDATE faj_file SET faj41 = '2' #申請中
                             WHERE faj02 = g_fce[s_cnt].fce03
                               AND faj022= g_fce[s_cnt].fce031
            END IF
            IF l_faj86 > 0 THEN
               UPDATE faj_file SET faj41 = '4' #全部設定
                             WHERE faj02 = g_fce[s_cnt].fce03
                               AND faj022= g_fce[s_cnt].fce031
            END IF
            IF l_faj87 > 0 THEN
               UPDATE faj_file SET faj41 = '1' #未抵押
                             WHERE faj02 = g_fce[s_cnt].fce03
                               AND faj022= g_fce[s_cnt].fce031
            END IF
            IF SQLCA.sqlcode THEN LET g_success = 'N' EXIT FOR END IF
       END FOR
END FUNCTION
 
FUNCTION t900_1()
   DEFINE s_cnt      LIKE type_file.num5    #TQC-C70173  add
    IF g_fcd.fcdconf != 'Y' THEN
        CALL cl_err('','anm-960',0)  #MOD-740450
        RETURN 
    END IF
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    BEGIN WORK
       LET g_success = 'Y'
       LET g_fcd_t.fcd04 = g_fcd.fcd04  #No.TQC-770108
       INPUT BY NAME g_fcd.fcd12,g_fcd.fcd04 WITHOUT DEFAULTS
          AFTER FIELD fcd12
            IF cl_null(g_fcd.fcd12) THEN NEXT FIELD fcd12 END IF
 
          AFTER FIELD fcd04
            IF cl_null(g_fcd.fcd04) THEN NEXT FIELD fcd04 END IF
            IF g_fcd.fcd04 <= 0 THEN
               CALL cl_err('','afa-949',0)
               LET g_fcd.fcd04 = g_fcd_t.fcd04
               DISPLAY BY NAME g_fcd.fcd04
               NEXT FIELD fcd04
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
          RETURN
       END IF
 
       #TQC-C70173--add--str--
       CALL t900_b_fill('1=1')       # 單身
       FOR s_cnt = 1 TO g_rec_b
         UPDATE faj_file SET faj41 = '3'  
          WHERE faj02 = g_fce[s_cnt].fce03
            AND faj022= g_fce[s_cnt].fce031
       END FOR
       #TQC-C70173--add--end--

       UPDATE fcd_file SET fcd04 = g_fcd.fcd04 ,fcd12=g_fcd.fcd12
        WHERE fcd01=g_fcd.fcd01
       IF SQLCA.sqlcode THEN LET g_success = 'N' END IF
       IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t900_2()
    DEFINE  s_cnt  LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_fce10  LIKE fce_file.fce10
 
    IF g_fcd.fcd01 IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF   
 
    IF g_fcd.fcd05 IS NOT NULL THEN
       CALL cl_err('','afa-250',0)
       RETURN
    END IF
 
 
    IF g_fcd.fcdconf != 'Y' THEN 
       CALL cl_err('','anm-960',0)  #MOD-740450
       RETURN 
    END IF
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    BEGIN WORK LET g_success = 'Y'
       INPUT BY NAME g_fcd.fcd05,g_fcd.fcd06,g_fcd.fcd07,
                     g_fcd.fcd09,g_fcd.fcd08,g_fcd.fcd10,g_fcd.fcd11
       WITHOUT DEFAULTS
 
        AFTER FIELD fcd05
          IF NOT cl_null(g_fcd.fcd05) THEN
             SELECT alg02 INTO g_alg02 FROM alg_file
              WHERE alg01=g_fcd.fcd05
               IF STATUS THEN
                  CALL cl_err3("sel","alg_file",g_fcd.fcd05,"",SQLCA.sqlcode,"","",1)  #No.FUN-660136
                  LET g_alg02=' '
                  DISPLAY g_alg02 TO alg02
                  NEXT FIELD fcd05
               END IF
               DISPLAY g_alg02 TO alg02
          END IF
 
        AFTER FIELD fcd10
          IF NOT cl_null(g_fcd.fcd10) THEN
          # 根據扺押日期, 推算其清償日期 97.05.09
             CALL t900_date(g_fcd.fcd09,g_fcd.fcd10) RETURNING g_fcd.fcd11
          END IF
          DISPLAY BY NAME g_fcd.fcd11
 
        AFTER INPUT
          IF INT_FLAG THEN 
             LET INT_FLAG = 0
             EXIT INPUT  
          END IF   
          IF cl_null(g_fcd.fcd05) THEN NEXT FIELD fcd05 END IF
          IF cl_null(g_fcd.fcd06) THEN NEXT FIELD fcd06 END IF
          IF cl_null(g_fcd.fcd07) THEN NEXT FIELD fcd07 END IF
          IF cl_null(g_fcd.fcd08) THEN NEXT FIELD fcd08 END IF
          IF cl_null(g_fcd.fcd09) THEN NEXT FIELD fcd09 END IF
          IF cl_null(g_fcd.fcd10) THEN NEXT FIELD fcd10 END IF
          IF cl_null(g_fcd.fcd11) THEN NEXT FIELD fcd11 END IF
 
        ON ACTION controlp    #ok              #欄位說明
           CASE
              WHEN INFIELD(fcd05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_alg"
                 LET g_qryparam.default1 = g_fcd.fcd05
                 CALL cl_create_qry() RETURNING g_fcd.fcd05
                 DISPLAY BY NAME g_fcd.fcd05
                 SELECT alg02 INTO g_alg02 FROM alg_file
                  WHERE alg01=g_fcd.fcd05
                 IF STATUS THEN   LET g_alg02=' '   END IF
                 DISPLAY g_alg02 TO alg02
                 NEXT FIELD fcd05
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
 
      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT INPUT
       END INPUT
    IF INT_FLAG THEN  #MOD-740450 add
       LET INT_FLAG = 0
       LET g_success = 'N'
    ELSE
       UPDATE fcd_file SET fcd05 = g_fcd.fcd05 ,fcd06=g_fcd.fcd06,
                           fcd07 = g_fcd.fcd07 ,fcd08=g_fcd.fcd08,
                           fcd09 = g_fcd.fcd09 ,fcd10=g_fcd.fcd10,
                           fcd11 = g_fcd.fcd11 WHERE fcd01=g_fcd.fcd01
       FOR s_cnt = 1 TO g_rec_b
           SELECT fce10 INTO l_fce10 FROM fce_file
            WHERE fce03 = g_fce[s_cnt].fce03 AND fce031= g_fce[s_cnt].fce031
           IF STATUS OR l_fce10 IS NULL THEN LET l_fce10 = 0 END IF
           UPDATE faj_file SET faj41 = '4' ,
                               faj86 = faj86 - l_fce10,
                               faj87 = faj87 + l_fce10,
                               faj88 = g_fcd.fcd09,
                               faj89 = g_fcd.fcd06,
                               faj90 = g_fcd.fcd05,
                               faj91 = ''
            WHERE faj02 = g_fce[s_cnt].fce03 AND faj022= g_fce[s_cnt].fce031
 
            UPDATE fce_file SET fce07 = '2'
            WHERE fce01=g_fcd.fcd01 AND
                  fce03 = g_fce[s_cnt].fce03 AND fce031= g_fce[s_cnt].fce031
            LET g_fce[s_cnt].fce07 = '2'
            DISPLAY BY NAME g_fce[s_cnt].fce07
       END FOR
       IF SQLCA.sqlcode THEN LET g_success = 'N' END IF
    END IF
       IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t900_3()
    DEFINE  s_cnt  LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_fce10  LIKE fce_file.fce10,
            l_n      LIKE type_file.num5        #TQC-C70175 add

    IF g_fcd.fcd01 IS NULL THEN 
       CALL cl_err('',-400,0) 
       RETURN 
    END IF   
 
    IF g_fcd.fcd05 IS NULL THEN
       CALL cl_err('','afa-251',0)
       RETURN
    END IF

    #TQC-C70175--add--str--
    SELECT COUNT(*) INTO l_n FROM fcf_file WHERE fcf03 = g_fcd.fcd01 AND fcfconf = 'Y'
    IF l_n > 0 THEN  
       CALL cl_err('','afa-374',0)
       RETURN
    END IF 
    #TQC-C70175--add--end--
 
    IF g_fcd.fcdconf != 'Y' THEN RETURN END IF
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    BEGIN WORK LET g_success = 'Y'
   
      LET g_fcd.fcd05 = ''
      LET g_fcd.fcd06 = ''
      LET g_fcd.fcd07 = ''
      LET g_fcd.fcd08 = ''
      LET g_fcd.fcd09 = ''
      LET g_fcd.fcd10 = ''
      LET g_fcd.fcd11 = ''
      LET g_alg02 = ''   #TQC-AB0198
    IF INT_FLAG THEN  #MOD-740450 add
       LET INT_FLAG = 0
       LET g_success = 'N'
    ELSE
       UPDATE fcd_file SET fcd05 = g_fcd.fcd05 ,fcd06=g_fcd.fcd06,
                           fcd07 = g_fcd.fcd07 ,fcd08=g_fcd.fcd08,
                           fcd09 = g_fcd.fcd09 ,fcd10=g_fcd.fcd10,
                           fcd11 = g_fcd.fcd11 WHERE fcd01=g_fcd.fcd01
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
          CALL cl_err3("upd","fcd_file",g_fcd.fcd01,"",SQLCA.sqlcode,"","upd fcd_file",1)  #No.FUN-660136
          LET g_success = 'N'
       ELSE
          DISPLAY BY NAME g_fcd.fcd05,g_fcd.fcd06,g_fcd.fcd07,
                          g_fcd.fcd08,g_fcd.fcd09,g_fcd.fcd10,
                          g_fcd.fcd11
          DISPLAY g_alg02 TO alg02    #TQC-AB0198
       END IF
       FOR s_cnt = 1 TO g_rec_b
           IF g_success='N' THEN                                                                                                         
              LET g_totsuccess='N'                                                                                                       
              LET g_success="Y"                                                                                                          
           END IF                                                                                                                        
 
           SELECT fce10 INTO l_fce10 FROM fce_file
            WHERE fce03 = g_fce[s_cnt].fce03 AND fce031= g_fce[s_cnt].fce031
           IF STATUS OR l_fce10 IS NULL THEN LET l_fce10 = 0 END IF
 
           UPDATE faj_file SET faj41 = '2' , faj86 = faj86 + l_fce10,
                               faj87 = faj87 - l_fce10,
                               faj88 = '' ,
                               faj89 = g_fcd.fcd06,
                               faj90 = g_fcd.fcd05,
                               faj91 = ''
                         WHERE faj02 = g_fce[s_cnt].fce03
                           AND faj022= g_fce[s_cnt].fce031
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               LET g_showmsg = g_fce[s_cnt].fce03,"/",g_fce[s_cnt].fce031        #No.FUN-710028
               CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj_file',STATUS,1)   #No.FUN-710028
               LET g_success = 'N'
            END IF
            UPDATE fce_file SET fce07 = '1'
                           WHERE fce01=g_fcd.fcd01
                             AND fce03 = g_fce[s_cnt].fce03
                             AND fce031= g_fce[s_cnt].fce031
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               LET g_showmsg = g_fcd.fcd01,"/",g_fce[s_cnt].fce03,"/",g_fce[s_cnt].fce031   #No.FUN-710028
               CALL s_errmsg('fce01,fce03,fce031',g_showmsg,'upd fce_file',STATUS,1)        #No.FUN-710028
               LET g_success = 'N'
            END IF
            LET g_fce[s_cnt].fce07 = '1'
            DISPLAY BY NAME g_fce[s_cnt].fce07
       END FOR
       IF g_totsuccess="N" THEN                                                                                                        
          LET g_success="N"                                                                                                            
       END IF                                                                                                                          
 
       IF SQLCA.sqlcode THEN LET g_success = 'N' END IF
       CALL s_showmsg()   #No.FUN-710028
    END IF   #MOD-740450
       IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t900_add()
DEFINE
    add       RECORD     fce06       LIKE fce_file.fce06,
                         fce061      LIKE fce_file.fce061,
                         fce04       LIKE fce_file.fce04,
                         fce05       LIKE fce_file.fce05,
                         fce20       LIKE fce_file.fce20,
                         fce24       LIKE fce_file.fce24
              END RECORD
 
     IF g_fcd.fcdconf = 'X' THEN
       CALL s_errmsg('','','','9024',0) RETURN  #No.FUN-710028
     END IF
     DECLARE afat900_cursad CURSOR FOR
      SELECT fce06,fce061,SUM(fce04),SUM(fce05),SUM(fce20),SUM(fce24)
        FROM fce_file
       WHERE fce01 = g_fcd.fcd01 AND (fce06 is not null AND fce06 != ' ')
    GROUP BY fce06,fce061
    FOREACH afat900_cursad INTO add.*
       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,0)  #No.FUN-710028
          EXIT FOREACH
       END IF
       IF add.fce061 IS NULL THEN LET add.fce061 = '    ' END IF
       IF add.fce04  IS NULL THEN LET add.fce04 = 0 END IF
       IF add.fce05  IS NULL THEN LET add.fce05 = 0 END IF
       IF add.fce20  IS NULL THEN LET add.fce20 = 0 END IF
       IF add.fce24  IS NULL THEN LET add.fce24 = 0 END IF
       UPDATE fce_file SET fce04 = fce09 + add.fce04,
                           fce05 = fce10 + add.fce05,
                           fce20 = fce11 + add.fce20,
                           fce24 = fce25 + add.fce24  #成本
                     WHERE fce01 = g_fcd.fcd01
                       AND fce03 = add.fce06
                       AND fce031= add.fce061
    END FOREACH
    # ●申請抵押金額 [fcd03] (DEC11,0)(D): －單身抵押金額之加總, 不可修改。
    SELECT SUM(fce05) INTO g_fcd.fcd03 FROM fce_file
     WHERE fce01 = g_fcd.fcd01 AND fce06 = '          '
    IF NOT STATUS THEN
       UPDATE fcd_file SET fcd03 = g_fcd.fcd03 WHERE fcd01 = g_fcd.fcd01
       DISPLAY BY NAME g_fcd.fcd03
    END IF
END FUNCTION
 
FUNCTION t900_showfaj()                 #將進口編號、發票號碼、保管部門放至單身
 
    SELECT faj04,faj25,faj06,faj49
      INTO g_fce[l_ac].faj04,g_fce[l_ac].faj25,
           g_fce[l_ac].faj06,g_fce[l_ac].faj49
      FROM faj_file
     WHERE faj02 = g_fce[l_ac].fce03
       AND faj022= g_fce[l_ac].fce031
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION t900_g( )             # G. 自動產生..單身資料
DEFINE ls_tmp STRING
DEFINE          l_maxac LIKE type_file.num5,         #No.FUN-680070 SMALLINT
                l_faj86      LIKE     faj_file.faj86,
                l_sql        LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(600)
                l_num        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
                tm  RECORD                # Print condition RECORD
                    wc      LIKE type_file.chr1000,       # Where condition       #No.FUN-680070 VARCHAR(500)
                    b       LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
                    c       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
                END RECORD,
    l_fce_t         RECORD    #程式變數(Program Variables)
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        faj04       LIKE faj_file.faj04,   #類別
        faj25       LIKE faj_file.faj25,   #取得日期
        fce04       LIKE fce_file.fce04,   #帳面價值
        fce05       LIKE fce_file.fce05,   #抵押金額
        fce06       LIKE fce_file.fce06,   #合併財產編號
        fce061      LIKE fce_file.fce061,  #合併財產附號
        faj17       LIKE faj_file.faj17,   #數量
        faj18       LIKE faj_file.faj18    #單位
                    END RECORD
 
   IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
   END IF
   LET l_ac = ARR_CURR()
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW t900_g AT p_row,p_col
        WITH FORM "afa/42f/afat900s"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat900s")
 
   IF INT_FLAG THEN RETURN END IF
     CALL cl_opmsg('q')
    #資料權限的檢查
    CONSTRUCT BY NAME tm.wc ON                     # 螢幕上取自動產生條件
        faj04,faj05,faj02,faj021,faj33,faj25,faj47,faj53
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
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW t900_g RETURN
   END IF
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   DISPLAY tm.b TO b
   DISPLAY tm.c TO c
   INPUT BY NAME tm.b,tm.c WITHOUT DEFAULTS
      AFTER FIELD b
         IF NOT cl_null(tm.b) THEN
            IF tm.b NOT MATCHES '[YN]' THEN
               NEXT FIELD b
            END IF
         END IF
      AFTER FIELD c
         IF NOT cl_null(tm.c) THEN
            IF tm.c NOT MATCHES '[YN]' THEN
               NEXT FIELD c
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
      LET INT_FLAG = 0 CLOSE WINDOW t900_g RETURN
   END IF
    LET l_sql ="SELECT faj02,faj022,faj04,faj25,faj33-faj86-faj87, ",
               "       faj33-faj86-faj87,'','',faj17-faj58,faj18 ",
               "  FROM faj_file ",
               " WHERE faj43 NOT IN ('0','5','6','X')",
               "   AND (faj33-faj86-faj87) >0  ",
               "   AND faj41 = '1' ",    #TQC-980030 add         
               "   AND ",tm.wc CLIPPED,
               #"   AND faj02 NOT IN ",                    #TQC-C70177  mark
               #"(SELECT fce03 FROM fce_file ",            #TQC-C70177  mark  
               #"WHERE fce03=faj02 AND fce031=faj022 AND fajconf='Y' ) ",      #TQC-C70177  mark
               " ORDER BY faj02,faj022 "
 
     PREPARE t900_g FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('PREPARE t900_g',SQLCA.sqlcode,1)
        RETURN
     END IF
     DECLARE t900_g_curs CURSOR FOR t900_g
     CALL t900_create_temp1()   #建立一temp file 儲存預投入單身之資料
     DELETE FROM fce_temp     #MOD-740450
     FOREACH t900_g_curs INTO l_fce_t.*
        IF SQLCA.sqlcode != 0 THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        #------主件已抵押者附件是否產生----
        LET l_faj86 = 0
        IF tm.b = 'N' THEN
           IF NOT cl_null(l_fce_t.fce031) THEN
              SELECT faj86+faj87 INTO l_faj86 FROM faj_file
               WHERE faj02 = l_fce_t.fce03 AND faj021 = '1'
              IF l_faj86>0  THEN CONTINUE FOREACH END IF
           END IF
        END IF
        IF tm.c = 'Y' AND l_fce_t.fce031<>' ' THEN
           LET l_fce_t.fce06=l_fce_t.fce03
        END IF
        INSERT INTO fce_temp
           VALUES('Y',l_fce_t.fce03,l_fce_t.fce031,l_fce_t.faj04,
                  l_fce_t.faj25,l_fce_t.fce04,l_fce_t.fce05,l_fce_t.fce06,
                  l_fce_t.fce061,l_fce_t.fce04,l_fce_t.fce05,
                  l_fce_t.faj17,l_fce_t.faj18,l_fce_t.faj17,
                  l_fce_t.faj18)
     END FOREACH
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
     CLOSE WINDOW t900_g
 
     LET p_row = 5 LET p_col = 14
     OPEN WINDOW t900_a AT p_row,p_col
        WITH FORM "afa/42f/afat900a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat900a")
 
 
   IF INT_FLAG THEN RETURN END IF
     CALL t900_b_fillx()       # 單身
     DISPLAY ARRAY l_fce TO s_fce.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
        BEFORE DISPLAY
          EXIT DISPLAY
     END DISPLAY
     CALL t900_bx()
     CALL t900_putb()  # 將[Y] 者新增至單身中
    #資料權限的檢查
    CLOSE WINDOW t900_a
    CALL t900_b_fill('1=1')       # 單身
END FUNCTION
 
FUNCTION t900_create_temp1()
   DROP TABLE fce_tempa

   CREATE TEMP TABLE fce_temp(
     fceyn  LIKE type_file.chr1,  
     fce03  LIKE fce_file.fce03,
     fce031 LIKE fce_file.fce031,
     faj04  LIKE faj_file.faj04,
     faj25  LIKE faj_file.faj25,
     fce04  LIKE fce_file.fce04,
     fce05  LIKE fce_file.fce05,
     fce06  LIKE fce_file.fce06,
     fce061 LIKE fce_file.fce061,
     fce09  LIKE fce_file.fce09,
     fce10  LIKE fce_file.fce10,
     faj17  LIKE faj_file.faj17,
     faj18  LIKE faj_file.faj18,
     fce11  LIKE fce_file.fce11,
     fce12  LIKE fce_file.fce12)
END FUNCTION
 
FUNCTION t900_bx()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_total         LIKE type_file.num20_6,  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
 
    LET g_action_choice = ""
    IF g_fcd.fcd01 IS NULL THEN RETURN END IF
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    LET l_fce_t.* = l_fce[1].*
 
 
    INPUT ARRAY l_fce WITHOUT DEFAULTS FROM s_fce.*
          ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED, INSERT ROW=FALSE ,DELETE ROW=FALSE,APPEND ROW=FALSE )
 
       BEFORE ROW
          LET l_ax = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
       AFTER FIELD fce06                        #合併編號
           IF NOT cl_null(l_fce[l_ax].fce06) THEN
              SELECT COUNT(*)
                INTO l_n
                FROM fce_temp
               WHERE fce03 = l_fce[l_ax].fce06
                 AND fceyn = 'Y'
               IF l_n < 1  THEN
                   CALL cl_err(l_fce[l_ax].fce06,'afa-166',0)
                   LET l_fce[l_ax].fce06 = l_fce_t.fce06
                   NEXT FIELD fce06
               END IF
           ELSE
               LET l_fce[l_ax].fce06 = '          '
           END IF
 
      AFTER FIELD fce061                       #合併附號
          IF NOT cl_null(l_fce[l_ax].fce061) THEN
             SELECT COUNT(*)
               INTO l_n
               FROM fce_temp
              WHERE fce03 = l_fce[l_ax].fce06
                AND fce031= l_fce[l_ax].fce061
                AND fceyn ='Y'
              IF l_n < 1 THEN
                  CALL cl_err(l_fce[l_ax].fce061,'afa-166',0)
                  LET l_fce[l_ax].fce061 = l_fce_t.fce061
                  DISPLAY BY NAME l_fce[l_ac].fce061
                  NEXT FIELD fce061
              END IF
             SELECT COUNT(*)
               INTO l_n
               FROM faj_file
              WHERE faj02 = l_fce[l_ax].fce06
                AND faj022= l_fce[l_ax].fce061
              IF l_n < 0  THEN
                  LET l_fce[l_ax].fce061 = l_fce_t.fce061
                  DISPLAY BY NAME l_fce[l_ac].fce061
                  NEXT FIELD fce06
              END IF
          ELSE
              LET l_fce[l_ax].fce061 = '    '
          END IF
 
        AFTER FIELD fce05
            IF NOT cl_null(l_fce[l_ax].fce05) THEN
               IF l_fce[l_ax].fce05 > l_fce[l_ax].fce04 THEN
                  CALL cl_err('','afa-922',0)
               END IF
            END IF
 
       ON ROW CHANGE
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET l_fce[l_ax].* = l_fce_t.*
             EXIT INPUT
          END IF
          UPDATE fce_temp SET fceyn = l_fce[l_ax].fceyn,
                              fce05 = l_fce[l_ax].fce05,
                              fce06 = l_fce[l_ax].fce06,
                              fce061= l_fce[l_ax].fce061,
                              fce10 = l_fce[l_ax].fce05    #MOD-C40014 add
           WHERE fce03 = l_fce[l_ax].fce03
             AND fce031 = l_fce[l_ax].fce031
          IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","fce_temp",l_fce[l_ax].fce03,l_fce[l_ax].fce031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
              LET l_fce[l_ax].* = l_fce_t.*
          ELSE
              MESSAGE 'UPDATE O.K'
              COMMIT WORK
          END IF

          AFTER ROW
             IF INT_FLAG THEN                 #900423
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 EXIT INPUT
             END IF
             SELECT SUM(fce05) INTO l_total  FROM fce_temp
             WHERE fceyn = 'Y'
             DISPLAY l_total TO tot
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
      ON ACTION select_all
         CALL t900_fce_sel('Y')
      ON ACTION select_non
         CALL t900_fce_sel('N')
 
        END INPUT

END FUNCTION
 
FUNCTION t900_fce_sel(p_sel)
  DEFINE  p_sel   LIKE type_file.chr1
  DEFINE  l_i     LIKE type_file.num5
 
  FOR l_i = 1 TO g_rec_b 
    LET l_fce[l_i].fceyn = p_sel 
    DISPLAY BY NAME l_fce[l_i].fceyn
    UPDATE fce_temp SET fceyn = l_fce[l_i].fceyn
     WHERE fce03 = l_fce[l_i].fce03
       AND fce031 = l_fce[l_i].fce031
  END FOR
END FUNCTION
 
 
FUNCTION t900_by()
DEFINE
    l_ax            LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT       #No.FUN-680070 SMALLINT
    l_row,l_col     LIKE type_file.num5,                #分段輸入之行,列數       #No.FUN-680070 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,                #檢查重複用       #No.FUN-680070 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否       #No.FUN-680070 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態       #No.FUN-680070 VARCHAR(1)
    g_cmd           LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
    l_flag          LIKE type_file.num10,        #No.FUN-680070 INTEGER
    l_total         LIKE type_file.num20_6,  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    l_allow_insert  LIKE type_file.num5,                #可新增否       #No.FUN-680070 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否       #No.FUN-680070 SMALLINT
 
    IF g_fcd.fcd01 IS NULL THEN RETURN END IF
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    LET m_fce_t.* = m_fce[1].*
 
    LET g_forupd_sql = " SELECT fceyn,fce03,fce031,faj04,faj25,fce05,fce06,fce061 ",
                       " FROM fce_temp ",
                       " WHERE fce03 = ? ",
                       " AND fce031= ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_bcly CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_row  = 12
    LET l_col  = 15
    LET l_ac_t =  0
       LET l_allow_insert = cl_detail_input_auth("insert")
       LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY m_fce WITHOUT DEFAULTS  FROM s_fceb.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            CALL fgl_set_arr_curr(l_ax)
 
        BEFORE ROW
            LET l_ax = ARR_CURR()       #目前筆數
            LET m_fce_t.* = m_fce[l_ax].*  #BACKUP
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()                #目前的array共有幾筆
           #BEGIN WORK                            #MOD-C40014 mark
 
            OPEN t900_cl USING g_fcd.fcd01
            IF STATUS THEN
               CALL cl_err("OPEN t900_cl:", STATUS, 1)  
               CLOSE t900_cl
               LET g_success = 'N'              #MOD-C40014 add
              #ROLLBACK WORK                    #MOD-C40014 mark
               RETURN
            END IF
            FETCH t900_cl INTO g_fcd.*              # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)      # 資料被他人LOCK
               CLOSE t900_cl 
               LET g_success = 'N'              #MOD-C40014 add
              #ROLLBACK WORK                    #MOD-C40014 mark
               RETURN
            END IF
            IF g_rec_b>=l_ax THEN
                LET p_cmd='u'
 
                OPEN t900_bcly USING m_fce_t.fce03,m_fce_t.fce031
                IF STATUS THEN
                   CALL cl_err("OPEN t900_bcl:", STATUS, 1)
                   CLOSE t900_bcly
                   LET g_success = 'N'              #MOD-C40014 add
                  #ROLLBACK WORK                    #MOD-C40014 mark
                   RETURN
                ELSE
                   FETCH t900_bcly INTO m_fce[l_ax].*
                   IF SQLCA.sqlcode THEN
                      CALL cl_err(m_fce[l_ax].fce03,SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
            NEXT FIELD fceyn
 
          ON ROW CHANGE
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET m_fce[l_ax].* = m_fce_t.*
                 CLOSE t900_bcly
                 LET g_success = 'N'              #MOD-C40014 add
                #ROLLBACK WORK                    #MOD-C40014 mark
                 EXIT INPUT
              END IF
              IF l_lock_sw = 'Y' THEN
                 CALL cl_err(m_fce[l_ax].fceyn,-263,1)
                 LET m_fce[l_ax].* = m_fce_t.*
              ELSE
                 UPDATE fce_temp SET fceyn = m_fce[l_ax].fceyn
                  WHERE fce03 = m_fce[l_ax].fce03
                    AND fce031 = m_fce[l_ax].fce031
                 IF SQLCA.sqlcode THEN
                     CALL cl_err3("upd","fce_temp",m_fce[l_ax].fce03,m_fce[l_ax].fce031,SQLCA.sqlcode,"","",1)  #No.FUN-660136
                     LET m_fce[l_ax].* = m_fce_t.*
                 ELSE
                     MESSAGE 'UPDATE O.K'
                    #COMMIT WORK                   #MOD-C40014 mark
                 END IF
              END IF
 
          AFTER ROW
             LET l_ac = ARR_CURR()
             IF INT_FLAG THEN                 #900423
                 CALL cl_err('',9001,0)
                 LET INT_FLAG = 0
                 LET m_fce[l_ax].* = m_fce_t.*
                 CLOSE t900_bcly
                 LET g_success = 'N'              #MOD-C40014 add
                #ROLLBACK WORK                    #MOD-C40014 mark
                 EXIT INPUT
             END IF
             IF m_fce[l_ax].fce03 IS  NULL THEN
                LET m_fce[l_ax].fceyn = ' '
             END IF
             SELECT SUM(fce05) INTO l_total  FROM fce_temp
              WHERE fceyn = 'Y'
                AND fce06 = '          '
             DISPLAY l_total TO tot
             LET m_fce_t.* = m_fce[l_ax].*          # 900423
             CLOSE t900_bcly
            #COMMIT WORK                           #MOD-C40014 mark
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
       #CLOSE t900_cl        #MOD-C40014 mark
       #CLOSE t900_bcly      #MOD-C40014 mark
       #COMMIT WORK          #MOD-C40014 mark
 
END FUNCTION
 
FUNCTION t900_putb()             # 將 fce_temp 中[Y] 者新增至單身檔中
DEFINE
    l_maxac         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
    l_fce24         LIKE  fce_file.fce24,
    p_fce           RECORD                 #程式變數(Program Variables)
        fce03       LIKE fce_file.fce03,   #財產編號
        fce031      LIKE fce_file.fce031,  #附號
        fce04       LIKE fce_file.fce04,   #帳面價值
        fce05       LIKE fce_file.fce05,   #抵押金額
        fce06       LIKE fce_file.fce06,   #合併財產編號
        fce061      LIKE fce_file.fce061,  #合併財產附號
        fce09       LIKE fce_file.fce09,   #合併前帳面價值
        fce10       LIKE fce_file.fce10,   #合併前抵押金額
        fce20       LIKE fce_file.fce20,   #數量
        fce21       LIKE fce_file.fce21,   #單位
        fce11       LIKE fce_file.fce11,   #合併前數量
        fce12       LIKE fce_file.fce12    #合併前單位
                    END RECORD
 
    DECLARE t900_putb CURSOR FOR
     SELECT fce03,fce031,fce04,fce05,fce06,fce061,fce09,fce10,
            faj17,faj18,fce11,fce12
       FROM fce_temp
      WHERE fceyn  = 'Y'
    SELECT max(fce02)+1 INTO l_ac FROM fce_file WHERE fce01 = g_fcd.fcd01
    IF l_ac IS NULL THEN LET l_ac = 1 END IF
    FOREACH t900_putb INTO p_fce.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        IF cl_null(p_fce.fce04)  THEN LET p_fce.fce04 = 0 END IF
        IF cl_null(p_fce.fce05)  THEN LET p_fce.fce05 = 0 END IF
        IF cl_null(p_fce.fce06)  THEN LET p_fce.fce06 = '          ' END IF
        IF cl_null(p_fce.fce061) THEN LET p_fce.fce061= '    '       END IF
        IF cl_null(p_fce.fce09)  THEN LET p_fce.fce09 = 0 END IF
        IF cl_null(p_fce.fce10)  THEN LET p_fce.fce10 = 0 END IF
        IF cl_null(p_fce.fce20)  THEN LET p_fce.fce20 = 0            END IF
        IF cl_null(p_fce.fce21)  THEN LET p_fce.fce21 = '    '       END IF
        IF cl_null(p_fce.fce11)  THEN LET p_fce.fce11 = 0            END IF
        IF cl_null(p_fce.fce12)  THEN LET p_fce.fce12 = '    '       END IF
 
        LET l_fce24 = 0
        SELECT faj14+faj141-faj59 INTO l_fce24 FROM faj_file
         WHERE faj02=p_fce.fce03 AND faj022=p_fce.fce031
 
       INSERT INTO fce_file(fce01,fce02,fce03,fce031,fce04,fce05,fce06,fce061,
                            fce09,fce10,fce20,fce21,fce11,fce12,fce07,fce08,
                            fce24,fce25,fcelegal) #FUN-980003 add
                   VALUES(g_fcd.fcd01,l_ac,p_fce.*,'1','',l_fce24,l_fce24,g_legal) #FUN-980003 add
        IF NOT STATUS THEN
           LET l_ac = l_ac + 1
        END IF
     END FOREACH
     LET l_maxac = l_ac - 1
     CALL t900_add()
     IF INT_FLAG THEN LET INT_FLAG = 0 END IF
END FUNCTION
 
FUNCTION t900_b_fillx()              #BODY FILL UP 將暫存檔中的資料顯示出來
    DEFINE total LIKE type_file.num20_6  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    LET total = 0
    DECLARE fce_curx CURSOR FOR
     SELECT fceyn,fce03,fce031,faj04,faj25,fce04,fce05,fce06,fce061
       FROM fce_temp
    CALL l_fce.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fce_curx INTO l_fce[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
        END IF
        IF l_fce[g_cnt].fceyn = 'Y' THEN
        LET total = total + l_fce[g_cnt].fce05 END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    DISPLAY total TO tot
END FUNCTION
 
FUNCTION t900_bpx(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY l_fce TO s_fce.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET l_ax = ARR_CURR()
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ax = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
   ON ACTION accept
      LET g_action_choice="detail"
      LET l_ax = ARR_CURR()
      EXIT DISPLAY
 
   ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
      LET g_action_choice="exit"
      EXIT DISPLAY
 
      ON IDLE g_idle_seconds
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t900_b_filly()              #BODY FILL UP 將暫存檔中的資料顯示出來
    DEFINE total LIKE type_file.num20_6  #No.FUN-4C0008       #No.FUN-680070 DEC(20,6)
    LET total = 0
    DECLARE fce_cury CURSOR FOR
     SELECT fceyn,fce03,fce031,faj04,faj25,fce05,fce06,fce061
     FROM fce_temp                    #SCROLL CURSOR
    CALL m_fce.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH fce_cury INTO m_fce[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
        END IF
        IF m_fce[g_cnt].fceyn = 'Y' AND m_fce[g_cnt].fce06='          ' THEN
        LET total = total + m_fce[g_cnt].fce05 END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    DISPLAY total TO tot
    LET g_rec_b = g_cnt -1
END FUNCTION
 
FUNCTION t900_bpy(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY m_fce TO s_fceb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     #FUN-550037(smin)
 
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
            CALL t900_fetch('F')
         LET g_action_choice="first"
         EXIT DISPLAY
      ON ACTION previous
         LET g_action_choice="previous"
         EXIT DISPLAY
      ON ACTION jump
      ON ACTION next
         LET g_action_choice="next"
         EXIT DISPLAY
      ON ACTION last
         LET g_action_choice="last"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ax = 1
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t900_date(l_date,l_month)
    DEFINE l_date     LIKE type_file.dat,        #傳入的扺押日期       #No.FUN-680070 DATE
           l_date1    LIKE type_file.dat,          #No.FUN-680070 DATE
           l_year     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_year1    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_month    LIKE type_file.num5,   #傳入的設定月份       #No.FUN-680070 SMALLINT
           l_month1   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_day1     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
           l_day2     LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
    # 應加n 年
    LET l_year = l_month / 12
    IF cl_null(l_year) THEN LET l_year = 0 END IF
 
    # 應加 n 月
    LET l_month1 = l_month MOD 12
    IF cl_null(l_month) THEN LET l_month = 0 END IF
 
    LET l_day1 = cl_days(YEAR(l_date),MONTH(l_month))
    LET l_year1 = YEAR(l_date) + l_year  USING '&&&&'
    LET l_month = MONTH(l_date) + l_month1
 
    IF l_day1 = DAY(l_date) THEN  # 若是月底了
       LET l_day2 = cl_days(l_year1,l_month)  # 找出清償日期的月底日子
    ELSE
       LET l_day2 = DAY(l_date)
    END IF
 
    LET l_date1 = MDY(l_month,l_day2,l_year1)
 
    RETURN l_date1
END FUNCTION
 
FUNCTION t900_m()
 DEFINE  ls_tmp STRING
 DEFINE  l_sql       LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(400)
         l_fce01 LIKE fce_file.fce01, # saki 20070821 rowid chr18 -> num10 
         l_fan14     LIKE  fan_file.fan14,  #成本
         tm  RECORD
                   yy      LIKE type_file.num5,         #No.FUN-680070 SMALLINT
                   mm      LIKE type_file.num5         #No.FUN-680070 SMALLINT
              END RECORD,
         l_fce03     LIKE fce_file.fce03,
         l_fce031    LIKE fce_file.fce031,
         l_fce24     LIKE fce_file.fce24,
         l_cost,l_accd,l_curr LIKE fce_file.fce24
 
    IF cl_null(g_fcd.fcd01) THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_fcd.fcdconf = 'X' THEN
       CALL cl_err('','9024',0) RETURN
    END IF
    LET tm.yy = YEAR(g_fcd.fcd12) LET tm.mm = MONTH(g_fcd.fcd12)
    LET p_row = 6 LET p_col = 20
    OPEN WINDOW t900_m AT p_row,p_col
         WITH FORM "afa/42f/afat9001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("afat9001")
 
 
       INPUT BY NAME tm.* WITHOUT DEFAULTS
 
             AFTER FIELD mm
               IF NOT cl_null(tm.mm) THEN
                  IF tm.mm > 12 OR tm.mm < 1 THEN
                     NEXT FIELD mm
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
 
    CLOSE WINDOW t900_m
    LET l_sql = "SELECT fce01,fce03,fce031 FROM fce_file",
                " WHERE fce01 = '",g_fcd.fcd01,"'"
    PREPARE t900_prcm FROM l_sql
    DECLARE t900_cm CURSOR WITH HOLD FOR t900_prcm
 
    LET g_success = 'Y'
    BEGIN WORK
    CALL s_showmsg_init()    #No.FUN-710028
    FOREACH t900_cm  INTO l_fce01,l_fce03,l_fce031
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
 
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('fce01',g_fcd.fcd01,'foreach:',STATUS,0) EXIT FOREACH  #No.FUN-710028
       END IF
       message l_fce03,' ',l_fce031
       LET l_fan14 = 0
       SELECT fan14 INTO l_fan14 FROM fan_file
        WHERE fan01 = l_fce03 AND fan02 = l_fce031
          AND fan03 = tm.yy    AND fan04 = tm.mm
          AND fan041 = '1'
          AND fan05 = '2'
       IF STATUS THEN
          LET g_showmsg = l_fce03,"/",l_fce031,"/",tm.yy,"/",tm.mm,"/",'1',"/",'2'              #No.FUN-710028
          CALL s_errmsg('fan01,fan02,fan03,fan04,fan041,fan05',g_showmsg,'afa-349',STATUS,0)    #No.FUN-710028
          CONTINUE FOREACH
       END IF
       UPDATE fce_file SET fce24 = l_fan14,      #本幣成本
                           fce25 = l_fan14       #本幣成本[合併前]
                       WHERE fce01 = l_fce01 AND fce03 = l_fce03 AND fce031 = l_fce031 
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('fce01,fce03,fce031',l_fce01,'upd fce_file:',STATUS,1)    #No.FUN-710028
            LET g_success = 'N'
            CONTINUE FOREACH     #No.FUN-710028
         END IF
    END FOREACH
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
 
    CALL t900_add()
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
#FUNCTION t900_x()                           #FUN-D20035
FUNCTION t900_x(p_type)                      #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1      #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1      #FUN-D20035
   DEFINE l_fce03     LIKE fce_file.fce03,   #TQC-C70159
          l_fce031    LIKE fce_file.fce031   #TQC-C70159
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_fcd.* FROM fcd_file WHERE fcd01=g_fcd.fcd01
   IF g_fcd.fcd01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_fcd.fcdconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_fcd.fcdconf ='X' THEN RETURN END IF
   ELSE
      IF g_fcd.fcdconf <>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t900_cl USING g_fcd.fcd01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_fcd.*#鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_fcd.fcd01,SQLCA.sqlcode,0)#資料被他人LOCK
      CLOSE t900_cl ROLLBACK WORK RETURN
   END IF
  #-->作廢轉換01/08/03
 #IF cl_void(0,0,g_fcd.fcdconf)   THEN                                #FUN-D20035
  IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
  IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
     LET g_chr=g_fcd.fcdconf
      #IF g_fcd.fcdconf ='N' THEN                                 #FUN-D20035
        IF p_type = 1 THEN                                              #FUN-D20035
            LET g_fcd.fcdconf='X'
        ELSE
            LET g_fcd.fcdconf='N'
        END IF

        #TQC-C70159--add--str--
        DECLARE fce_c1 CURSOR FOR
         SELECT fce03,fce031 FROM fce_file
          WHERE fce01=g_fcd.fcd01
        FOREACH fce_c1 INTO l_fce03,l_fce031
          UPDATE faj_file SET faj41 = '1' #未抵押
                        WHERE faj02 = l_fce03
                          AND faj022= l_fce031
          IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","faj_file",l_fce03,l_fce031,SQLCA.sqlcode,"","",1)  
              LET g_success='N'
          END IF
        END FOREACH
        #TQC-C70159--add--end--

        UPDATE fcd_file SET fcdconf = g_fcd.fcdconf,fcdmodu=g_user,fcddate=TODAY
          WHERE fcd01 = g_fcd.fcd01
   IF STATUS THEN 
      CALL cl_err3("upd","fcd_file",g_fcd.fcd01,"",SQLCA.sqlcode,"","upd fcdconf:",1)  #No.FUN-660136
      LET g_success='N' 
   END IF
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
 
   SELECT fcdconf INTO g_fcd.fcdconf FROM fcd_file
    WHERE fcd01 = g_fcd.fcd01
   DISPLAY BY NAME g_fcd.fcdconf
  END IF
 
  IF g_fcd.fcdconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  CALL cl_set_field_pic(g_fcd.fcdconf,"","","",g_chr,"")
END FUNCTION
 
 
FUNCTION t900_bpx_refresh()
   DISPLAY ARRAY l_fce TO s_fce.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END DISPLAY
END FUNCTION
#No.FUN-9C0077 程式精簡

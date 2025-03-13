# Prog. Version..: '5.30.06-13.04.16(00010)'     #
#
# Pattern name...: aimp800.4gl
# Descriptions...: 盤點標簽產生作業(執行本作業時MFG 系統必須shutdown)
# Date & Author..: 93/05/14 By Apple
# Modify.........: 97/07/24 By Melody 1.新增可開窗挑選產生範圍
#                                     2.改為可重複產生
#
# Modify.........: MOD-470049 04/07/16 By Mandy 做在製工單盤點標籤時會出現FOREACH p800_cs1
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC()方式的改成用LIKE方式
# Modify.........: No.MOD-550042 05/05/09 By kim mark AFTER FIELD wip 段之EXIT INPUT
# Modify.........: No.FUN-570082 05/07/18 By Carrier 多單位內容修改
# Modify.........: No.MOD-560201 05/08/04 By pengu 排序方式變更
# Modify.........: No.MOD-570322 05/08/04 By pengu checkbox-"產生現有庫存盤點資料"的控制錯誤
# Modify.........: No.MOD-570301 05/08/04 By pengu 做欄位 可輸/不可輸 控管
# Modify.........: No.MOD-570388 05/08/03 By pengu 執行aimp800後,無法同時再執行aimt800和aimi800
# Modify.........: No.MOD-580058 05/09/06 By Nicola 畫面中無order1的欄位，卻在AFTER FIELD stk 時，去DISPLAY裡面的值，產生錯誤
# Modify.........: NO.MOD-590417 05/11/02 BY yiting 畫面條件輸入完後執行產生資料出現 -1349的 error message
# Modify.........: NO.FUN-5B0137 05/11/30 BY kim 空白標籤的起始序號不應該是必要輸入
# Modify.........: NO.FUN-5C0040 05/12/09 BY Claire 做在製工單盤點標籤時會出現FOREACH p800_cs
# Modify.........: NO.FUN-5C0001 06/01/06 BY yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: NO.FUN-570122 06/02/16 BY yiting 背景作業
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: NO.TQC-660091 06/06/20 BY Elva 盤點標簽生成時check是否存在tlf檔，若已存在則不能生成 
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-670093 06/07/27 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0057 06/11/14 By Ray 修正語言別切換無效
# Modify.........: No.FUN-710025 07/01/24 By bnlent 錯誤信息匯整
# Modify.........: No.MOD-6C0008 07/03/07 By pengu 修改在製盤點單SQL語法
# Modify.........: No.MOD-760096 07/06/22 By pengu 當工單有替代料時產生在製盤點資料有誤
# Modify.........: No.MOD-770090 07/07/18 By pengu 當QBE條件大於10 碼時，若再重新開QBE窗時期原本下的QBE條件會被截掉
# Modify.........: No.MOD-770016 07/07/18 By pengu 若工單有替代料時其在製量會異常
# Modify.........: No.MOD-7C0127 07/12/18 By Pengu 勾選在製標籤列印時，會出現prepare: 發生語法錯誤.
# Modify.........: No.MOD-7C0138 07/12/20 By Pengu 調整FUN-710025"錯誤信息匯整"的寫法
# Modify.........: No.MOD-7C0193 07/12/25 By Pengu 調整盤點單流水號調整為10碼
# Modify.........: No.MOD-810134 08/01/17 By Smapmin 不default 'STK' 以及 'WIP'
# Modify.........: No.MOD-810009 08/03/04 By Pengu 若工單有取替代料時，則在算再製盤點量會出現負數
# Modify.........: No.MOD-840313 08/04/28 By Pengu 無法產生在製標籤，按下確定後，程式會關掉
# Modify.........: No.MOD-850266 08/05/27 By claire 作業編號(key)塞值不可給null
# Modify.........: No.FUN-860001 08/06/02 By Sherry 批序號-盤點
# Modify.........: No.MOD-860139 08/06/13 By claire 加判斷倉儲批
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-860218 08/07/16 By Pengu 在製盤點標籤產生,程式會掛掉
# Modify.........: No.FUN-8A0035 08/10/28 By jan 流水號依參數aza42編碼  
# Modify.........: No.MOD-910031 09/01/06 By chenyu 盤點標簽生成時，應該先以作業編號排序
# Modify.........: No.MOD-910033 09/01/06 By claire 若產生標籤失敗,選擇繼續執行INPUT時會有LOOP狀況
# Modify.........: No.TQC-930124 09/03/18 By douzh 修改單倉時,MOD-860139增加倉儲批時未定義的pia03~pia05
# Modify.........: No.FUN-930122 09/04/08 By xiaofeizhu 在畫面(現有庫存)"使用標簽別"欄位下面新增選項:底稿類別產生方式
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0028 09/11/04 By wujie 5.2SQL转标准语法
# Modify.........: No.CHI-960065 09/11/09 By jan 盤點資料生成時編碼方式采用自動編碼
# Modify.........: No.TQC-9B0231 09/11/30 BY Carrier SQL STANDARDIZE
# Modify.........: No:MOD-9C0035 09/12/22 By sabrina 若輸入條件不存在，程式執行後會變成無窮迴圈，無法繼續往下做 
# Modify.........: No:TQC-A10079 10/01/08 By liingyu 程式過單
# Modify.........: No:MOD-A10008 10/01/13 By Pengu 產生盤點標籤時應排除無效料
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20037 10/03/02 By lilingyu 取替代碼中添加'8''Z'的條件
# Modify.........: No.FUN-A20044 10/03/26 By vealxu  ima26x 調整
# Modify.........: No.TQC-A40028 10/04/06 By lilingyu修正FUN-9B0028外聯條件的錯誤
# Modify.........: No:MOD-A40036 10/04/09 By Sarah 當使用多單位時,也應產生多單位的空白盤點標簽資料(piaa_file)
# Modify.........: No:MOD-A50159 10/05/24 By Sarah 若盤點單號選擇5碼時,要寫入pic06/pic15/pic26/pic36時只取前5碼寫入
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/07/02 By vealxu 製造功能優化-平行制程
# Modify.........: No.FUN-A60095 10/07/13 By kim GP5.25 平行工藝
# Modify.........: No.FUN-A70131 10/07/29 By destiny 平行工藝
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-9C0397 10/11/25 By sabrina 盤點資料大時程式會擋掉
# Modify.........: No.TQC-AB0157 10/12/04 By vealxu 執行後失敗,詢問"執行失敗,是否繼續執行?",選擇是卻一直停在詢問視窗,無法重新輸入
# Modify.........: No:TQC-AC0391 10/12/29 By zhangll aimi800->asmi300
# Modify.........: No:MOD-B10064 11/01/10 By sabrina 在製品盤點會重複產生資料
# Modify.........: No.TQC-B10177 11/01/19 By vealxu input時，"底稿類別產生方式"default="使用標籤別"的smy78
# Modify.........: No:MOD-AC0078 11/01/25 By Summer 執行在製品盤點時,會出現成功的訊息內容,按確定後會出現失敗無法回到QBE畫面
# Modify.........: No:MOD-B20012 11/02/08 By sabrina 重工委外工單應納入
# Modify.........: No.FUN-B30211 11/04/01By yangtingting   1、離開MAIN時沒有cl_used(1)和cl_used(2)
#                                                           2、未加離開前得cl_used(2)
# Modify.........: No:FUN-B40082 11/06/08 By kim 修正檢查備料檔作業編號未考慮製程序的問題
# Modify.........: No:TQC-B60287 11/06/22 By jan aimp800在計算已轉出數量時，未考慮ecm的組成用量和底數
# Modify.........: No:MOD-B70069 11/07/08 By JoHung 移動piaa_file資料insert g_paper1累加位置
# Modify.........: No.FUN-B70032 11/08/08 By jason ICD刻號/BIN-盤點新增piad_file檔
# Modify.........: No.CHI-B90001 11/09/02 By jason 拿掉盤點數=帳面數選項
# Modify.........: No.FUN-BA0029 11/11/03 By jason 資料排序應該都要可以選空白，選空白表示該欄位不做排序
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.CHI-B90052 12/01/12 By ck2yuan 盤點工單的張數與bar數字不符
# Modify.........: No:FUN-BB0086 11/12/15 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-BA0015 12/01/17 By pauline 少傳參數報錯, 
# Modify.........: No.FUN-910088 12/01/18 By chenjing 增加數量欄位小數取位
# Modify.........: No:MOD-C20038 12/02/04 By ck2yuan 產生空白標籤時p800_pciaa傳入參數個數有問題
# Modify.........: No:CHI-C30068 12/06/15 By bart aimp800產生時,pia931應該要是空白值
# Modify.........: No:TQC-C70126 12/07/19 By lixh1 增加QBE欄位開窗
# Modify.........: No:MOD-C80184 12/08/28 By Elise 已發數量大於0，sfb04不包含2,3
# Modify.........: No:MOD-CA0129 12/10/29 By Elise exit foreach才呼叫cl_close_progress_bar()
# Modify.........: No:MOD-CB0268 12/11/30 By zhangll 多單位參考單位時，應只產生參考單位的piaa資料
# Modify.........: No:MOD-CC0261 13/01/08 By Elise 修改sql條件
# Modify.........: No.FUN-C30315 13/01/09 By Nina 只要程式有UPDATE ima_file 的任何一個欄位時,多加imadate=g_today
# Modify.........: No:CHI-B70010 13/01/21 By Alberti 產生在製盤點標籤時，排除"消耗性料件"(sfa11<>'E')
# Modify.........: No:MOD-D40103 13/04/16 By bart 最後判斷批次作業是否失敗時，不應在CALL cl_close_progress_bar

DATABASE ds
 
GLOBALS "../../config/top.global"
  
DEFINE tm  RECORD                           # Print condition RECORD
           stk      LIKE pic_file.pic05,    #stock tag (Y/N)  #No.FUN-690026 VARCHAR(1)
           tag1     LIKE pia_file.pia01,    #CHI-960065
           noinv1   LIKE pic_file.pic08,    #No.FUN-690026 VARCHAR(1)
           spcg1    LIKE pic_file.pic14,    #No.FUN-690026 VARCHAR(1)
           spc1     LIKE pia_file.pia01,    #CHI-960065 
           qty1     LIKE pic_file.pic17,    #No.FUN-690026 INTEGER
           order1   LIKE pic_file.pic21,    #No.FUN-690026 VARCHAR(10)
           class1   LIKE pic_file.pic22,    #No.FUN-690026 VARCHAR(1)
           wip      LIKE pic_file.pic25,    #wo tab (Y/N)  #No.FUN-690026 VARCHAR(1)
           tag2     LIKE pid_file.pid01,    #CHI-960065
           spcg2    LIKE pic_file.pic14,    #No.FUN-690026 #CHI-960065VARCHAR(1)
           sw       LIKE type_file.chr1,    #NO.FUN-5C0001 #No.FUN-690026 VARCHAR(1)
           spc2     LIKE pid_file.pid01,    #CHI-960065
           qty2     LIKE pic_file.pic37,    #No.FUN-690026 INTEGER
           order2   LIKE pic_file.pic41,    #No.FUN-690026 VARCHAR(10)
           exedate  LIKE type_file.dat,     #No.FUN-690026 DATE
           type     LIKE type_file.chr10    #No.FUN-930122
           #icdcnt   LIKE type_file.chr1     #FUN-B70032   #CHI-B90001 mark
           END RECORD,
       tm3 RECORD    #for UI
           a1,a2,a3,a4,a5,a6   LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(20)
           k1,k2,k3,k4,k5,k6   LIKE type_file.chr20   #No.FUN-690026 VARCHAR(20)
           END RECORD,
       tm_tag1_o           LIKE pia_file.pia01,
       tm_spc1_o           LIKE pia_file.pia01,
       tm_tag2_o           LIKE pid_file.pid01,
       tm_spc2_o           LIKE pid_file.pid01,
       g_bstk,g_estk       LIKE pia_file.pia01,    #CHI-960065  
       g_bwip,g_ewip       LIKE pia_file.pia01,    #CHI-960065    
       g_bspcstk,g_espcstk LIKE pid_file.pid01,  #CHI-960065
       g_bspcwip,g_espcwip LIKE pid_file.pid01,  #CHI-960065
       g_spcstk,g_spcwip   LIKE pic_file.pic20,
       g_bstk1,g_bwip1     LIKE pia_file.pia01,  #CHI-960065 記錄截止單號
       g_bspcstk1          LIKE pid_file.pid01,  #CHI-960065 記錄截止單號
       g_bspcwip1          LIKE pid_file.pid01,  #CHI-960065 記錄截止單號
       g_paperipcnt        LIKE type_file.num10,   #No.FUN-690026 INTEGER
       g_paper1,g_paper2   LIKE pic_file.pic13,
       g_stkcnt,g_wipcnt   LIKE type_file.num10,   #No.FUN-690026 INTEGER
       g_date              LIKE type_file.dat,     #No.FUN-690026 DATE
       g_zero,l_n          LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       g_program           LIKE zz_file.zz01,      #No.FUN-690026 VARCHAR(10)
       g_cmd               LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
       g_null_date         LIKE type_file.dat,     #放null  #No.FUN-690026 DATE
       g_null_char         LIKE type_file.chr1,    #放null  #No.FUN-690026 VARCHAR(1)
       g_null_dec          LIKE pia_file.pia08,    #放null #MOD-530179
       g_space             LIKE type_file.chr1,    #放' '  #No.FUN-690026 VARCHAR(1)
       l_sw,ecm_flg        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       g_wc1,g_wc2         string,                 #No.FUN-580092 HCN
       g_sql               LIKE type_file.chr1000, #NO.FUN-5C0001  #No.FUN-690026 VARCHAR(2000)
       g_sw                LIKE type_file.num5,    #FUN-5C0001 add #No.FUN-690026 SMALLINT
       g_count             LIKE type_file.num5     #FUN-5C0001 ADD #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_cnt1              LIKE type_file.num10   #No.MOD-9C0035 add
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
 
DEFINE   g_ima23         STRING
DEFINE   g_ima06         STRING
DEFINE   g_img02         STRING
DEFINE   g_img03         STRING
DEFINE   g_img04         STRING
DEFINE   g_img01         STRING
DEFINE   g_sfa01         STRING
DEFINE   g_sfb82         STRING
DEFINE g_change_lang       LIKE type_file.chr1    #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE g_pia930            LIKE pia_file.pia930   #FUN-670093
DEFINE g_pia931            LIKE pia_file.pia931   #FUN-930122
DEFINE g_t1                LIKE oay_file.oayslip  #CHI-960065 
MAIN
DEFINE l_flag  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE ls_date STRING                 #FUN-570122
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                                   # Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc1 = ARG_VAL(1)
   LET g_wc2 = ARG_VAL(2)
   LET tm.stk = ARG_VAL(3)
   LET tm.tag1 = ARG_VAL(4)
   LET tm.noinv1 = ARG_VAL(5)
   LET tm.spcg1 = ARG_VAL(6)
   LET tm.spc1 = ARG_VAL(7)
   LET tm.qty1 = ARG_VAL(8)
   LET tm.order1 = ARG_VAL(9)
   LET tm.class1 = ARG_VAL(10)
   LET tm.wip = ARG_VAL(11)
   LET tm.tag2 = ARG_VAL(12)
   LET tm.spcg2 = ARG_VAL(13)
   LET tm.spc2 = ARG_VAL(14)
   LET tm.qty2 = ARG_VAL(15)
   LET tm.order2 = ARG_VAL(16)
   LET ls_date = ARG_VAL(17)
   LET tm.exedate = cl_batch_bg_date_convert(ls_date)
   LET tm3.a1 = ARG_VAL(18)
   LET tm3.a2 = ARG_VAL(19)
   LET tm3.a3 = ARG_VAL(20)
   LET tm3.a4 = ARG_VAL(21)
   LET tm3.a5 = ARG_VAL(22)
   LET tm3.a6 = ARG_VAL(23)
   LET tm3.k1 = ARG_VAL(24)
   LET tm3.k2 = ARG_VAL(25)
   LET tm3.k3 = ARG_VAL(26)
   LET tm3.k4 = ARG_VAL(27)
   LET tm3.k5 = ARG_VAL(28)
   LET tm3.k6 = ARG_VAL(29)
   LET g_bgjob = ARG_VAL(30)
   LET tm.type = ARG_VAL(31)    #FUN-930122
   #LET tm.icdcnt = ARG_VAL(32)  #FUN-B70032   #CHI-B90001 mark   
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211 
WHILE TRUE
   LET g_success = 'Y'
   IF g_bgjob = "N" THEN
       BEGIN WORK
       LET g_success = 'Y'
       CALL p800_tm()# Input print condition
       IF INT_FLAG THEN EXIT PROGRAM END IF
       IF (tm.stk matches'[Yy]' OR tm.wip matches'[Yy]') THEN
           IF cl_sure(21,20) THEN
               CALL cl_wait()
               CALL s_showmsg_init()       #No.MOD-860218 add
               #---->是否為多倉管理
               IF g_sma.sma12 MATCHES '[yY]' THEN
                   CALL p800_cur()
                   IF g_success = 'Y' THEN
                       CALL p800_1()
                   END IF
               ELSE
                   CALL p800_cur2()
                   IF g_success = 'Y' THEN
                       CALL p800_2()
                   END IF
               END IF
               IF g_success = 'Y' THEN
                   CALL p800_udpic()
                   #-->盤點成本重計作叢
                   ERROR ""
                   UNLOCK TABLE pib_file
               END IF
               CALL s_showmsg()   #No.FUN-710025
               IF g_success='Y' THEN
                   IF tm.sw = 'N' AND g_cnt1 = 0 THEN CALL cl_close_progress_bar() END IF  #MOD-9C0035 add
                   COMMIT WORK
                   CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
               ELSE
                  #IF tm.sw = 'N' AND g_cnt1 = 0 THEN CALL cl_close_progress_bar() END IF  #MOD-9C0035 add  #TQC-AB0157 
                   #IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF  #TQC-AB0157   #MOD-D40103 
                   ROLLBACK WORK
                   CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
               END IF
               IF l_flag THEN
                   CONTINUE WHILE
               ELSE
                   EXIT WHILE
               END IF
           END IF
       ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
           IF l_flag THEN
               CONTINUE WHILE
           ELSE
               EXIT WHILE
           END IF
       END IF
   ELSE
       BEGIN WORK
       LOCK TABLE pib_file IN EXCLUSIVE MODE
       IF SQLCA.sqlcode THEN
            CALL cl_err(SQLCA.sqlcode,'mfg0111',0)
            ROLLBACK WORK
            EXIT PROGRAM
       END IF
            IF (tm.stk matches'[Yy]' OR tm.wip matches'[Yy]') THEN
                #---->是否為多倉管理
                IF g_sma.sma12 MATCHES '[yY]' THEN
                    CALL p800_cur()
                    IF g_success = 'Y' THEN
                        CALL p800_1()
                    END IF
                ELSE
                    CALL p800_cur2()
                    IF g_success = 'Y' THEN
                        CALL p800_2()
                    END IF
                END IF
                IF g_success = 'Y' THEN
                    CALL p800_udpic()
                    #-->盤點成本重計作叢
                    ERROR ""
                    UNLOCK TABLE pib_file
                END IF
                IF g_success = "Y" THEN
                    COMMIT WORK
                ELSE
                    ROLLBACK WORK
                END IF
                CALL cl_batch_bg_javamail(g_success)
                EXIT WHILE
           END IF
   END IF
END WHILE
CLOSE WINDOW p800_w
CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
END MAIN
 
FUNCTION p800_tm()
   DEFINE l_pib03,l_pib03_2 LIKE pib_file.pib03,
          l_cmd             LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
   DEFINE lc_cmd            LIKE type_file.chr1000 #No.FUN-570122 #No.FUN-690026 VARCHAR(500)
   DEFINE l_t2         LIKE type_file.num5    #FUN-8A0035
   DEFINE l_t3         STRING                 #FUN-8A0035
   DEFINE li_result    LIKE type_file.num5    #CHI-960065
   DEFINE l_smydesc    LIKE smy_file.smydesc  #CHI-960065
   DEFINE l_spc1       STRING                 #CHI-960065 
   DEFINE l_spc2       STRING                 #CHI-960065 
   DEFINE l_smy78      LIKE smy_file.smy78    #TQC-B10177
 
   LET p_row = 2 LET p_col = 20
 
   OPEN WINDOW p800_w AT p_row,p_col WITH FORM "aim/42f/aimp800"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   LET g_date  = g_today
   LET g_program = 'aimp800'
   #因為PUT xxx FROM '','' 在ORA版本會有問題,
   #所以設以下三個變數放NULL
   LET g_null_date = NULL  #放null
   LET g_null_char = NULL  #放null
   LET g_null_dec  = NULL  #放null
   LET g_space     = ' '   #放' '
 
   #執行前檢查
   INITIALIZE tm.* TO NULL                      # Default condition
   LET tm.stk = 'N'
   LET tm.wip = 'N'
   LET tm.class1 = '0'
   LET tm.noinv1 = 'Y'
   LET tm.spcg1 = 'N'
   LET tm.spcg2 = 'N'
   LET tm.sw    = 'N'  #NO.FUN-5C0001
   LET tm3.a1 = '1'
   LET tm3.a2 = '2'
   LET tm3.a3 = '3'
   LET tm3.a4 = '4'
   LET tm3.a5 = '5'
   LET tm3.a6 = '6'
   LET tm3.k1 = '1'
   LET tm3.k2 = '2'
   LET tm3.k3 = '3'
   LET tm3.k4 = '4'
   LET tm3.k5 = '5'
   LET tm3.k6 = '6'
   LET g_bgjob = 'N'   #FUN-570122
   LET g_ima23= ''
   LET g_img02= ''
   LET g_img03= ''
   LET g_img04= ''
   LET g_img01= ''
   LET g_ima06= ''
   LET g_sfa01= ''
   LET g_sfb82= ''
   #LET tm.icdcnt = 'N' #FUN-B70032 #CHI-B90001 mark  
 # LET tm.type = '1'   #FUN-930122    #TQC-B10177 mark
    CALL p800_control() #MOD-570301
 WHILE TRUE
   LET tm.exedate = g_today
   DISPLAY BY NAME tm.exedate
   INPUT BY NAME tm.stk,tm.tag1,tm.type,tm.noinv1,tm.spcg1,  #FUN-930122 #CHI-960065 #CHI-B90001 del tm.icdcnt
                 tm.spc1,tm.qty1,   #CHI-96006拿掉tm.spnol
                 tm3.a1,tm3.a2,tm3.a3,tm3.a4,tm3.a5,tm3.a6,
                 tm.class1,
                 tm.wip,tm.tag2,tm.spcg2,tm.sw,  #NO.FUN-5C0001 #CHI-96006拿掉tm.seno2
                 g_bgjob,     #FUN-570122
                 tm.spc2,tm.qty2,  #CHI-96006拿掉tm.spno2
                 tm3.k1,tm3.k2,tm3.k3,tm3.k4,tm3.k5,tm3.k6                 
                 WITHOUT DEFAULTS
   BEFORE INPUT
     CALL cl_set_docno_format("tag1")
     CALL cl_set_docno_format("spc1")
     CALL cl_set_docno_format("tag2")
     CALL cl_set_docno_format("spc2")
 
 
       ON CHANGE stk #MOD-570301
          CALL p800_control() #MOD-570301
         IF tm.stk matches'[Nn]' THEN
              LET tm.tag1   = ' '  #LET tm.seno1 = ' '  #CHI-960065
               LET tm.noinv1 = 'N'   LET tm.spcg1 ='N'    #MOD-570301
              LET tm.spc1   = ' '  #LET tm.spno1 = ' '  #CHI-960065
              LET tm.qty1   = ' '   LET tm.order1= ' '
              LET tm.class1 = ' '
              DISPLAY BY NAME tm.tag1,tm.noinv1,tm.spcg1,                     #CHI-960065 mod
                              tm.spc1,tm.qty1,tm.class1   #No.MOD-580058 Mark #CHI-960065 mod
         ELSE
              IF tm.noinv1 IS NULL OR tm.noinv1 = ' ' THEN
                 LET tm.noinv1 = 'Y'
              END IF
              IF tm.spcg1 IS NULL OR tm.spcg1 = ' ' THEN
                 LET tm.spcg1  = 'N'
              END IF
              IF tm.order1 IS NULL OR tm.order1 = ' ' THEN
                 LET tm.order1 = '123456'
              END IF
              IF tm.class1 IS NULL OR tm.order1 = ' ' THEN
                 LET tm.class1 = '0'
              END IF
              DISPLAY BY NAME tm.tag1,tm.noinv1,tm.spcg1,
                              tm.class1
                  #tm3.a1,tm3.a2,tm3.a3,tm3.a4,tm3.a5,tm3.a6  #MOD-570301
         END IF
 
      AFTER FIELD tag1
         IF NOT cl_null(tm.tag1) THEN
            CALL s_check_no("aim",tm.tag1,tm_tag1_o,"5","pia_file","pia01","") 
            RETURNING li_result,tm.tag1
            DISPLAY BY NAME tm.tag1
            IF (NOT li_result) THEN
                NEXT FIELD tag1
            END IF
            LET l_smydesc = s_get_doc_no(tm.tag1)
            SELECT smydesc,smy78 INTO l_smydesc,l_smy78 FROM smy_file WHERE smyslip = l_smydesc     #TQC-B10177 add smy78
            LET tm.type = l_smy78              #TQC-B10177 add
            DISPLAY l_smydesc TO smydesc1 LET l_smydesc = NULL
            DISPLAY tm.type TO type            #TQC-B10177 add              
         END IF
         LET tm_tag1_o = tm.tag1
 
      ON CHANGE spcg1
         CALL p800_control()
      
      AFTER FIELD type
        IF NOT cl_null(tm.type) THEN
           IF tm.type NOT MATCHES '[123456]' THEN
              NEXT FIELD type
           END IF
        END IF   
 
      AFTER FIELD spcg1
         IF tm.spcg1 MATCHES'[Yy]'
            AND (tm.spc1 IS NULL OR tm.spc1 = ' ')
         THEN LET tm.spc1 = tm.tag1
              DISPLAY BY NAME tm.spc1
         END IF
         IF tm.spcg1 MATCHES '[Nn]' THEN
            IF not cl_null(tm.spc1) THEN
               LET tm.spc1 = ' '
               DISPLAY BY NAME tm.spc1
            END IF
            IF not cl_null(tm.qty1) THEN
               LET tm.qty1 = ' '
               DISPLAY BY NAME tm.qty1
            END IF
         END IF
 
      AFTER FIELD spc1
             IF NOT cl_null(tm.spc1) THEN
                LET l_spc1 = tm.spc1
                IF l_spc1.getlength() > 6 THEN
                   IF tm.spc1 = tm.tag1 THEN
                     NEXT FIELD spc1
                  END IF
                END IF
                CALL s_check_no("aim",tm.spc1,tm_spc1_o,"5","pia_file","pia01","") 
                RETURNING li_result,tm.spc1
                  DISPLAY BY NAME tm.spc1
                IF (NOT li_result) THEN
                    NEXT FIELD spc1
             END IF
                LET l_smydesc = s_get_doc_no(tm.spc1)
                SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
                DISPLAY l_smydesc TO smydesc2 LET l_smydesc = NULL
            END IF
             LET tm_spc1_o = tm.spc1
 
      AFTER FIELD qty1
          IF tm.spcg1='Y' THEN #MOD-570301
            IF tm.qty1 IS NULL OR tm.qty1 = ' ' OR tm.qty1 <=0
            THEN NEXT FIELD qty1
            END IF
         END IF
 
      ON CHANGE wip
          CALL p800_control() #MOD-570301
         IF tm.wip matches'[Nn]' THEN
              LET tm.tag2   = ' '  #LET tm.seno2 = ' '  #CHI-960065
               LET tm.spcg2   = 'N'   #MOD-570301
              LET tm.spc2   = ' '  #LET tm.spno2 = ' '  #CHI-960065
              LET tm.qty2   = ' '   LET tm.order2= ' '
              DISPLAY BY NAME tm.tag2,tm.spcg2,          #CHI-960065
                             tm.spc2,tm.qty2             #CHI-960065
         ELSE
              IF tm.spcg2 IS NULL OR tm.spcg2 = ' ' THEN
                 LET tm.spcg2  = 'N'
              END IF
              IF tm.order2 IS NULL OR tm.order2 = ' ' THEN
                 LET tm.order2 = '54'
              END IF
              DISPLAY BY NAME tm.tag2,tm.spcg2
         END IF
 
      AFTER FIELD tag2
         IF NOT cl_null(tm.tag2) THEN
            CALL s_check_no("aim",tm.tag2,tm_tag2_o,"I","pid_file","pid01","") 
            RETURNING li_result,tm.tag2
            DISPLAY BY NAME tm.tag2
            IF (NOT li_result) THEN
                NEXT FIELD tag2
         END IF
            LET l_smydesc = s_get_doc_no(tm.tag2)
            SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
            DISPLAY l_smydesc TO smydesc3 LET l_smydesc = NULL
         END IF
         LET tm_tag2_o = tm.tag2
 
      ON CHANGE spcg2
         CALL p800_control()
 
      AFTER FIELD spcg2      #空白標籤產生否
         IF tm.spcg2 MATCHES'[Yy]' AND
            (tm.spc2 IS NULL OR tm.spc2 = ' ') THEN
              LET tm.spc2 = tm.tag2
              DISPLAY BY NAME tm.spc2
         END IF
         IF tm.spcg2 matches'[Nn]' THEN
            IF not cl_null(tm.spc2) THEN
               LET tm.spc2 = ' '
               DISPLAY BY NAME tm.spc2
            END IF
            IF not cl_null(tm.qty2) THEN
               LET tm.qty2 = ' '
               DISPLAY BY NAME tm.qty2
            END IF
         END IF
 
      AFTER FIELD spc2
         IF NOT cl_null(tm.spc2) THEN
            LET l_spc2 = tm.spc2
            IF l_spc2.getlength() > 6 THEN
               IF tm.spc2 = tm.tag2 THEN
                  NEXT FIELD spc2
         END IF
            END IF
            CALL s_check_no("aim",tm.spc2,tm_spc2_o,"I","pid_file","pid01","") 
            RETURNING li_result,tm.spc2
            DISPLAY BY NAME tm.spc2
            IF (NOT li_result) THEN
                NEXT FIELD spc2
            END IF
            LET l_smydesc = s_get_doc_no(tm.spc2)
            SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
            DISPLAY l_smydesc TO smydesc4 LET l_smydesc = NULL
         END IF
         LET tm_spc2_o = tm.spc2
 
      AFTER FIELD qty2
         IF tm.qty2 IS NULL OR tm.qty2 = ' ' OR tm.qty2 <=0 THEN
             CALL cl_err('','aim-813',0) #MOD-570301
            NEXT FIELD qty2
         END IF
 
       ON CHANGE g_bgjob
            IF g_bgjob = "Y" THEN
               LET tm.sw = "N"
               DISPLAY BY NAME tm.sw
               CALL cl_set_comp_entry("sw",FALSE)
            ELSE
               CALL cl_set_comp_entry("sw",TRUE)
            END IF
 
      AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD g_bgjob
          END IF
 
      AFTER INPUT
         LET tm.order1 = tm3.a1[1,1],tm3.a2[1,1],tm3.a3[1,1],
                         tm3.a4[1,1],tm3.a5[1,1],tm3.a6[1,1]
         LET tm.order2 = tm3.k1[1,1],tm3.k2[1,1],tm3.k3[1,1],
                         tm3.k4[1,1],tm3.k5[1,1],tm3.k6[1,1]
 
      ON ACTION stk_qbe
         IF tm.stk = 'Y' THEN
             CALL p800_stk()
         END IF
      ON ACTION wip_qbe
         IF tm.wip = 'Y' THEN
             CALL p800_wip()
         END IF
 
      ON ACTION CONTROLP
          CASE WHEN INFIELD(tag1) 
                  LET g_t1 = s_get_doc_no(tm.tag1)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
                  LET tm.tag1=g_t1
                  DISPLAY BY NAME tm.tag1
                  NEXT FIELD tag1
               WHEN INFIELD(spc1)
                  LET g_t1 = s_get_doc_no(tm.spc1)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
                  LET tm.spc1=g_t1
                  DISPLAY BY NAME tm.spc1
                  NEXT FIELD spc1
               WHEN INFIELD(tag2)
                  LET g_t1 = s_get_doc_no(tm.tag2)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t1
                  LET tm.tag2=g_t1
                  DISPLAY BY NAME tm.tag2
                  NEXT FIELD tag2
               WHEN INFIELD(spc2)
                  LET g_t1 = s_get_doc_no(tm.spc2)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t1
                  LET tm.spc2=g_t1
                  DISPLAY BY NAME tm.spc2
                  NEXT FIELD spc2
               OTHERWISE EXIT CASE
            END CASE
 
      ON ACTION mntn_tag
        #CALL cl_cmdrun('aimi800' )
         CALL cl_cmdrun('asmi300' )   #Mod No:TQC-AC0391
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()        # Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION locale
           LET g_change_lang = TRUE
         EXIT INPUT
 
      ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
       CLOSE WINDOW p800_w
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "aimp800"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('aimp800','9031',1)
      ELSE
         LET g_wc1=cl_replace_str(g_wc1, "'", "\"")
         LET g_wc2=cl_replace_str(g_wc2, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc1 CLIPPED,"'",
                      " '",g_wc2 CLIPPED,"'",
                      " '",tm.stk CLIPPED,"'",
                      " '",tm.tag1 CLIPPED,"'",
                      " '",tm.noinv1 CLIPPED,"'",
                      " '",tm.spcg1 CLIPPED,"'",
                      " '",tm.spc1 CLIPPED,"'",
                      " '",tm.qty1 CLIPPED,"'",
                      " '",tm.order1 CLIPPED,"'",
                      " '",tm.class1 CLIPPED,"'",
                      " '",tm.wip CLIPPED,"'",
                      " '",tm.tag2 CLIPPED,"'",
                      " '",tm.spcg2 CLIPPED,"'",
                      " '",tm.spc2 CLIPPED,"'",
                      " '",tm.qty2 CLIPPED,"'",
                      " '",tm.order2 CLIPPED,"'",
                      " '",tm.exedate CLIPPED,"'",
                      " '",tm3.a1 CLIPPED,"'",
                      " '",tm3.a2 CLIPPED,"'",
                      " '",tm3.a3 CLIPPED,"'",
                      " '",tm3.a4 CLIPPED,"'",
                      " '",tm3.a5 CLIPPED,"'",
                      " '",tm3.a6 CLIPPED,"'",
                      " '",tm3.k1 CLIPPED,"'",
                      " '",tm3.k2 CLIPPED,"'",
                      " '",tm3.k3 CLIPPED,"'",
                      " '",tm3.k4 CLIPPED,"'",
                      " '",tm3.k5 CLIPPED,"'",
                      " '",tm3.k6 CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",tm.type CLIPPED,"'"
                      #" '",tm.icdcnt CLIPPED, "'"   #FUN-B70032 #CHI-B90001 mark
         CALL cl_cmdat('aimp800',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p800_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p800_cur()
 DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
   LET l_cmd = " INSERT INTO pia_file (pia01,pia02,pia03,pia04,pia05,pia06,",
                                     " pia07,pia08,pia09,pia10,pia11,pia12,",
                                     " pia13,pia14,pia15,pia16,pia19,pia30,pia930,",  #FUN-670093 #FUN-B70032 add pia30
                                     " pia931,piaplant,pialegal)", #FUN-930122 add pia931 #FUN-980004 add piaplant,pialegal
              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"  #FUN-670093  #FUN-930122 add ? #FUN-980004 add ?,? #FUN-B70032 add ?
   PREPARE p800_pia FROM l_cmd
   DECLARE p800_cpia CURSOR WITH HOLD FOR p800_pia
   IF SQLCA.sqlcode THEN
      CALL cl_err('DECLARE p800_cpia:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_cmd = " INSERT INTO piaa_file (piaa00,piaa01,piaa02,piaa03,piaa04,",
                                      " piaa05,piaa06,piaa07,piaa08,piaa09,",
                                      " piaa10,piaa11,piaa12,piaa13,piaa14,",
                                      " piaa15,piaa16,piaa19,piaa30,piaa930,piaa931,", #FUN-670093  #FUN-930122 add piaa931 #FUN-B70032 add pia30
                                      " piaaplant,piaalegal)",   #FUN-980004 add piaaplant,piaalegal
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? ,?)"  #FUN-670093 #FUN-930122 add ? #FUN-980004 add ?,?
   PREPARE p800_piaa FROM l_cmd
   DECLARE p800_cpiaa CURSOR WITH HOLD FOR p800_piaa
   IF SQLCA.sqlcode THEN
      CALL cl_err('DECLARE p800_cpiaa:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_cmd = " SELECT * FROM imgg_file ",
               "  WHERE imgg01=?",
               "    AND imgg02=?",
               "    AND imgg03=?",
               "    AND imgg04=?"
   PREPARE p800_imgg FROM l_cmd
   DECLARE p800_cimgg CURSOR FOR p800_imgg
   IF SQLCA.sqlcode THEN
      CALL cl_err('DECLARE p800_cimgg:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_cmd = " INSERT INTO pias_file ( ",
               " pias01,pias02,pias03,pias04,pias05,",
               " pias06,pias07,pias08,pias09,pias10,",
               " pias11,pias12,pias13,pias19,pias30,",   #FUN-B70032 add pias30
               " piasplant,piaslegal) ", #FUN-980004 add piasplant,piaslegal
               " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"  #FUN-980004 add ?,? #FUN-B70032 add ?
   PREPARE p800_pias FROM l_cmd
   DECLARE p800_cpias CURSOR WITH HOLD FOR p800_pias
   IF SQLCA.sqlcode THEN
      CALL cl_err('DECLARE p800_cpias:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   LET l_cmd = " SELECT * FROM imgs_file ",
               "  WHERE imgs01=?",
               "    AND imgs02=?",
               "    AND imgs03=?",
               "    AND imgs04=?"
   PREPARE p800_imgs FROM l_cmd
   DECLARE p800_cimgs CURSOR FOR p800_imgs
   IF SQLCA.sqlcode THEN
      CALL cl_err('DECLARE p800_cimgs:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   #FUN-B70032 --START--
   IF s_industry('icd') THEN
      LET l_cmd = " INSERT INTO piad_file ( ",
                  " piad01,piad02,piad03,piad04,piad05,",
                  " piad06,piad07,piad08,piad09,piad10,",
                  " piad11,piad12,piad13,piad19,piad30,",
                  " piadplant,piadlegal) ", 
                  " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?)"  
      PREPARE p800_piad FROM l_cmd
      DECLARE p800_cpiad CURSOR WITH HOLD FOR p800_piad
      IF SQLCA.sqlcode THEN
         CALL cl_err('DECLARE p800_cpiad:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF

      LET l_cmd = " SELECT * FROM idc_file ",
                  "  WHERE idc01=?",
                  "    AND idc02=?",
                  "    AND idc03=?",
                  "    AND idc04=?"
      PREPARE p800_idc FROM l_cmd
      DECLARE p800_cidc CURSOR FOR p800_idc
      IF SQLCA.sqlcode THEN
         CALL cl_err('DECLARE p800_cidc:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF      
   END IF    
   #FUN-B70032 --END--
 
   LET l_cmd=" INSERT INTO pid_file(pid01,pid02,pid021,pid022,pid023,pid03,",
                                  " pid04,pid05,pid06,pid07,pid08,pid09,",
                                  " pid10,pid11,pid12,pid13,",
                                  " pid14,pid15,pid17,pid18,pidplant,pidlegal,", #FUN-980004 add pidplant,pidlegal
                                  " pid012)",  #FUN-A60095
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?, ?)" #FUN-980004 add ?,? #FUN-A60095
   PREPARE p800_pid FROM l_cmd
   DECLARE p800_cpid CURSOR WITH HOLD FOR p800_pid
   IF SQLCA.sqlcode THEN
      CALL cl_err('DECLARE p800_cpid:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   LET l_cmd = "INSERT INTO pie_file(pie01,pie02,pie03,",
                                   " pie04,pie05,pie06,pie07,",
                                   " pie11,pie12,pie13,pie14,",
                                   " pie15,pie151,pie152,pie153,pie16,pie900,pieplant,pielegal,", #FUN-980004 add pieplant,pielegal
                                   " pie012,pie013)",  #FUN-A60095
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?, ?,?) " #FUN-980004 add ?,?  #FUN-A60095
   PREPARE p800_pie FROM l_cmd
   DECLARE p800_cpie CURSOR WITH HOLD FOR p800_pie
   IF SQLCA.sqlcode THEN
      CALL cl_err('DECLARE p800_cpie:',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   OPEN p800_cpia
   OPEN p800_cpiaa   #No.FUN-570082
   OPEN p800_cpias   #No.FUN-860001
   IF s_industry('icd') THEN OPEN p800_cpiad END IF    #No.FUN-B70032
   OPEN p800_cpid
   OPEN p800_cpie
END FUNCTION
 
 
#多倉時的處理
FUNCTION p800_1()
   DEFINE l_name    LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
          l_sql     LIKE type_file.chr1000, #RDSQL STATEMENT  #No.FUN-690026 VARCHAR(2000)
          l_za05    LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(40)
          l_wc      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
          g_pia     RECORD
                    pia01  LIKE pia_file.pia01,    #標籤編號
                    pia02  LIKE pia_file.pia02,    #料件編號
                    pia03  LIKE pia_file.pia03,    #倉庫別
                    pia04  LIKE pia_file.pia04,    #存放位置
                    pia05  LIKE pia_file.pia05,    #批號
                    pia06  LIKE pia_file.pia06,    #庫存等級
                    pia07  LIKE pia_file.pia07,    #倉儲會計科目
                    pia08  LIKE pia_file.pia08,    #庫存數量
                    pia09  LIKE pia_file.pia09,    #庫存單位
                    pia10  LIKE pia_file.pia10,    #庫存/料件單位轉換率
                    ima06  LIKE ima_file.ima06,    #分群碼
                    ima09  LIKE ima_file.ima09,    #其它分群碼(1)
                    ima10  LIKE ima_file.ima10,    #其它分群碼(2)
                    ima11  LIKE ima_file.ima11,    #其它分群碼(3)
                    ima12  LIKE ima_file.ima12,    #其它分群碼(4)
                    ima23  LIKE ima_file.ima23     #倉管員
                    END RECORD,
          l_imgg      RECORD LIKE imgg_file.*,       #No.FUN-570082
          l_ima906    LIKE ima_file.ima906,          #No.FUN-570082
          l_ima907    LIKE ima_file.ima907,          #MOD-CB0268 add
          l_imgs      RECORD LIKE imgs_file.*,       #No.FUN-860001
          l_ima918    LIKE ima_file.ima918,          #No.FUN-860001
          l_ima921    LIKE ima_file.ima921,          #No.FUN-860001
          l_sfb01     LIKE sfb_file.sfb01,
          l_sfb01_old LIKE sfb_file.sfb01,
          l_sfa08_old LIKE sfa_file.sfa08,
          l_pmm09_old LIKE pmm_file.pmm09,
          l_ecm012_old LIKE ecm_file.ecm012,         #FUN-A60095
          l_ecm03_old  LIKE ecm_file.ecm03,          #FUN-A60095
          l_sfb02     LIKE sfb_file.sfb02,
          l_sfb04     LIKE sfb_file.sfb04,
          l_sfb05     LIKE sfb_file.sfb05,
          l_sfb08     LIKE sfb_file.sfb08,
          l_sfb09     LIKE sfb_file.sfb09,
          l_sfb10     LIKE sfb_file.sfb10,
          l_sfb11     LIKE sfb_file.sfb11,
          l_sfb12     LIKE sfb_file.sfb12,
          l_sfb15     LIKE sfb_file.sfb15,
          l_sfb82     LIKE sfb_file.sfb82,
          l_sfa03     LIKE sfa_file.sfa03,
          l_sfa05     LIKE sfa_file.sfa05,
          l_sfa06     LIKE sfa_file.sfa06,
          l_sfa062    LIKE sfa_file.sfa062,
          l_sfa063    LIKE sfa_file.sfa063,
          l_sfa065    LIKE sfa_file.sfa065,
          l_sfa13     LIKE sfa_file.sfa13,
          l_sfa08     LIKE sfa_file.sfa08,
          l_sfa11     LIKE sfa_file.sfa11,
          l_sfa12     LIKE sfa_file.sfa12,
          l_sfa161    LIKE sfa_file.sfa161,
          l_work      LIKE ecm_file.ecm06,
          l_ima55     LIKE ima_file.ima55,
          l_ecm52     LIKE ecm_file.ecm52,   #委外否
          l_pmm09     LIKE pmm_file.pmm09,
          l_ecm03     LIKE ecm_file.ecm03,   #作業序 99.12.19
          l_sfa26     LIKE sfa_file.sfa26,   #取替代 99.12.22
          l_sfa27     LIKE sfa_file.sfa27,   #原取替代料 99.12.22
          l_sfa28     LIKE sfa_file.sfa28,   #取替代率 99.12.22
          l_sfb93     LIKE sfb_file.sfb93,   #製程否
          l_pid01     LIKE pid_file.pid01,
          l_actuse    LIKE pie_file.pie153,
          l_uninv     LIKE pie_file.pie153,
          l_tmp_actuse   LIKE pie_file.pie153,    #No.MOD-770016 add
          l_item      LIKE type_file.num5,   #No.FUN-690026 SMALLINT
          l_sw        LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE    l_MINecm03  LIKE ecm_file.ecm03,
          l_MAXecm03  LIKE ecm_file.ecm03,
          ll_ecm301   LIKE ecm_file.ecm301,
          ll_ecm302   LIKE ecm_file.ecm302,
          ll_ecm303   LIKE ecm_file.ecm303,
          ll_ecm311   LIKE ecm_file.ecm311,
          ll_ecm312   LIKE ecm_file.ecm312,
          ll_ecm313   LIKE ecm_file.ecm313,
          ll_ecm314   LIKE ecm_file.ecm314,
          ll_ecm316   LIKE ecm_file.ecm316,
          ll_ecm321   LIKE ecm_file.ecm321,
          ll_ecm322   LIKE ecm_File.ecm322,
          ll_ecm62    LIKE ecm_File.ecm62,   #TQC-B60287
          ll_ecm63    LIKE ecm_File.ecm63,   #TQC-B60287
          ll_sfa161   LIKE sfa_file.sfa161,
          ll_pmn20    LIKE pmn_file.pmn20,
          ll_shb111   LIKE shb_file.shb111,
          ll_shb112   LIKE shb_file.shb112,
          ll_sfe161   LIKE sfe_file.sfe16,
          ll_sfe162   LIKE sfe_file.sfe16,
          l_sub       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
          l_subno     LIKE pid_file.pid01
 
DEFINE lll_pie12      LIKE pie_file.pie12 ,
       lll_pie14      LIKE pie_file.pie14 ,
       lll_miuse      LIKE pie_file.pie12
DEFINE l_sfa100       LIKE sfa_file.sfa100,  #NO:7474
       l_minp         LIKE pie_file.pie153,  #MOD-530179 #NO:7474
       l_sw_cnt1      LIKE type_file.num10,  #NO.FUN-5C0001 ADD #No.FUN-690026 SMALLINT,  #No:MOD-9C0397 modify
       l_sw_cnt2      LIKE type_file.num10,  #NO.FUN-5C0001 ADD #No.FUN-690026 SMALLINT,  #No:MOD-9C0397 modify
       l_sw_tot       LIKE type_file.num10,  #NO.FUN-5C0001 ADD #No.FUN-690026 SMALLINT,  #No:MOD-9C0397 modify
       l_cnt1         LIKE type_file.num10,  #NO.FUN-5C0001 ADD #No.FUN-690026 SMALLINT   #No:MOD-9C0397 modify
       l_cnt2         LIKE type_file.num10,  #NO.FUN-5C0001 ADD #No.FUN-690026 SMALLINT   #No:MOD-9C0397 modify
       l_sfb01_t      LIKE sfb_file.sfb01,   #NO.MOD-640357  
       l_sfb01_o      LIKE sfb_file.sfb01,   #MOD-AC0078 add  
       l_cnt_t        LIKE type_file.num5,   #NO.MOD-640357 #No.FUN-690026 SMALLINT,                 
       l_cnt_t1       LIKE type_file.num5    #NO.MOD-640357 #No.FUN-690026 SMALLINT                  
DEFINE l_cnt          LIKE type_file.num5    #TQC-660091    #No.FUN-690026 SMALLINT
DEFINE li_result      LIKE type_file.num5    #CHI-960065
DEFINE l_pia01        LIKE pia_file.pia01    #CHI-960065 存放截止單號
DEFINE l_tag1         STRING                 #CHI-960065   
DEFINE l_tag2         STRING                 #CHI-960065   
DEFINE l_spc1         STRING                 #CHI-960065   
DEFINE l_spc2         STRING                 #CHI-960065   
DEFINE l_n3           LIKE type_file.num5    #CHI-960065 
DEFINE l_ecm012       LIKE ecm_file.ecm012   #FUN-A60095
DEFINE l_MINecm012    LIKE ecm_file.ecm012   #FUN-A60095
DEFINE l_MAXecm012    LIKE ecm_file.ecm012   #FUN-A60095
DEFINE l_ecm_where    STRING                 #FUN-B40082
#DEFINE l_imaicd08     LIKE imaicd_file.imaicd08 #FUN-B70032   #FUN-BA0051 mark
DEFINE l_idc   RECORD LIKE idc_file.*           #FUN-B70032
DEFINE l_pia30        LIKE pia_file.pia30       #FUN-B70032
DEFINE l_pias30       LIKE pias_file.pias30     #FUN-B70032
DEFINE l_piad30       LIKE piad_file.piad30     #FUN-B70032
DEFINE l_flag         LIKE type_file.chr1       #MOD-CA0129 add

  CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
 
  #---->產生現有庫存狀況
  IF cl_null(g_wc1) THEN
      LET g_wc1 = " 1=1 "
  END IF
 
  #FUN-B40082(S)
  IF g_sma.sma542='Y' THEN
     LET l_ecm_where = " AND ecm03=sfa013 AND ecm012=sfa012 "
  ELSE
     LET l_ecm_where = " "
  END IF
  #FUN-B40082(E)
  
  IF tm.sw = 'N' THEN
     LET g_count = 1
     LET g_sql = "SELECT COUNT(*) ",
                  " FROM img_file,ima_file ",
                  " WHERE img01=ima01 AND ",g_wc1 CLIPPED
     LET g_sql = g_sql CLIPPED ," AND imaacti <> 'N' "     #No:MOD-A10008 add
     IF tm.noinv1 = 'N' THEN
        LET g_sql = g_sql clipped ," AND img10 != 0 "
     END IF
     PREPARE p800_sw_p1 FROM g_sql
     DECLARE p800_sw_c1 CURSOR WITH HOLD FOR p800_sw_p1
     OPEN p800_sw_c1
     FETCH p800_sw_c1 INTO l_sw_cnt1
     LET ecm_flg='N'
     #---->在製工單盤點資料產生作業
     IF cl_null(g_wc2) THEN
         LET g_wc2 = " 1=1 "
     END IF
     IF tm.wip = 'Y' THEN
       #不使用製程，則無法取得工作中心
       IF g_sma.sma54 ='N' THEN
         LET l_sql = "SELECT sfb01",
                    #" FROM sfb_file,sfa_file LEFT OUTER JOIN ima_file ON sfb05 = ima01",   #No.FUN-9B0028   #TQC-A40028
                     " FROM sfa_file,sfb_file LEFT OUTER JOIN ima_file ON sfb05 = ima01",   #TQC-A40028
                     " WHERE sfb01 = sfa01 ",
                     "   AND sfb02 <> 13 AND sfb87 <> 'X' ", #NO:7473
                     "   AND sfb04 IN ('4','5','6','7')",  #FUN-5C0040 BETWEEN 4 AND 7 ",
                     "   AND sfa11!= 'E'",                                     #CHI-B70010 add
                     "   AND ",g_wc2 CLIPPED
      ELSE
         #工單生產製程追蹤設定( '1':不使用)
         IF g_sma.sma26 = '1'  THEN
            LET l_sql = "SELECT sfb01",
                        " FROM sfa_file,sfb_file LEFT OUTER JOIN ecb_file ON ecb01 = sfb05 AND ecb02 = sfb06 AND ecb03 = sfb17 ",  #No.TQC-9B0231
                        "      LEFT OUTER JOIN ima_file ON sfb05 = ima01 ",
                        " WHERE sfb01 = sfa01 ",
                        "   AND sfb04 IN ('4','5','6','7')",  #FUN-5C0040 BETWEEN 4 AND 7 ",
                        "   AND sfb02 <> 13 AND sfb87 <> 'X' ", #NO:7473
                        "   AND sfa11!= 'E'",                                     #CHI-B70010 add
                        "   AND ",g_wc2 CLIPPED   #98/06/12 modify
        ELSE
            LET ecm_flg='Y'
            IF cl_db_get_database_type() = 'ORA' THEN
               LET l_sql = "SELECT sfb01 ",
                           " FROM sfb_file ",  #FUN-A60095
                           " LEFT OUTER JOIN ima_file ON ima01=sfb05 ",  #FUN-A60095
                           " ,sfa_file ",  #FUN-A60095
                          #"      (SELECT DISTINCT pmn41,pmn46,pmm09,pmn43,pmn012 ",  #FUN-A60095 #FUN-A60095
                          #"          FROM pmn_file,pmm_file ",                                   #FUN-A60095
                          #"          WHERE pmn01=pmm01) tmp ",                                   #FUN-A60095
                           " LEFT OUTER JOIN ecm_file ON ecm01 = sfa01  AND ecm04 = sfa08 ",  #FUN-A60095
                          #"  AND ecm03 = sfa013 AND ecm012= sfa012 ",                        #FUN-A60095   #FUN-B40082
                           l_ecm_where ,  #FUN-B40082
                           " LEFT OUTER JOIN pmn_file ",  #FUN-A60095
                           " LEFT OUTER JOIN pmm_file ON pmm01 = pmn01 ",  #FUN-A60095
                           "   ON pmn41 = sfa01  AND pmn43  = sfa013  AND pmn012 = sfa012 ",  #FUN-A60095                          
                           " WHERE sfb01 = sfa01 ",
                          #" AND sfb_file.sfb05 = ima_file.ima01 ", #FUN-A60095
                           " AND sfb87!='X' ",  #CHI-960065
                          #" AND sfb04 IN ('2','3','4','5','6','7') ",   #MOD-C80184 mark
                           " AND sfb04 IN ('4','5','6','7') ",           #MOD-C80184
                           " AND (sfb02=1 OR sfb02=5 OR sfb02=7 OR sfb02=8) ",     #MOD-B20012 add sfb02=8
                          #" AND ecm01 = sfa01 ",  #FUN-A60095
                          #" AND ecm04 = sfa08 ",  #FUN-A60095
                           " AND sfa06 > 0 ",
                          #" AND tmp.pmn41 = sfb_file.sfb01 ",  #FUN-A60095
                           "   AND ",g_wc2 CLIPPED
            ELSE  
               LET l_sql = "SELECT sfb01 ",    #No.MOD-7C0127 modify
                           " FROM sfb_file",
                           "      LEFT OUTER JOIN ima_file ON ima01 = sfb05 ,",
                           "      sfa_file",
                           "      LEFT OUTER JOIN ecm_file ON sfa01 = ecm01 AND sfa08 = ecm04 ",  #FUN-A60095
                          #"                              AND sfa012 = ecm012 AND sfa013 = ecm03, ",  #FUN-A60095  #FUN-B40082
                           l_ecm_where ,  #FUN-B40082
                           "      LEFT OUTER JOIN TABLE(multiset",
                           "      (SELECT DISTINCT pmn41,pmn46,pmm09,pmn43,pmn012 ",  #FUN-A60095
                           "       FROM pmn_file,pmm_file ",
                           "       WHERE pmn01=pmm01)) ON pmn41 = sfa01 ",  #FUN-A60095
                           "         AND pmn43=sfa013 AND pmn012= sfa012 ", #FUN-A60095 
                           " WHERE sfb01 = sfa01 ",
                           " AND sfb87!='X' ",
                          #" AND sfb04 MATCHES '[234567]'",    #MOD-C80184 mark
                           " AND sfb04 MATCHES '[4567]'",      #MOD-C80184
                           " AND (sfb02=1 OR sfb02=5 OR sfb02=7 OR sfb02=8) ",     #MOD-B20012 add sfb02=8
                           " AND sfa06 > 0 ",
                           "   AND ",g_wc2 CLIPPED
           END IF
        END IF
     END IF
     IF cl_null(g_wc2) THEN
        LET l_sql = l_sql clipped," sfa05 > 0 "
     ELSE
        LET l_sql = l_sql clipped," AND sfa05 > 0 "
     END IF
     PREPARE p800_sw_p2 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF  #NO.FUN-5C0001
         RETURN
     END IF
     DECLARE p800_sw_c2 CURSOR WITH HOLD FOR p800_sw_p2
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('DECLARE p800_cs1:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF  #NO.FUN-5C0001
         RETURN
     END IF
    #LET l_sfb01_o=' '   #MOD-AC0078 add #CHI-B90052 mark
     FOREACH p800_sw_c2 INTO l_sfb01_t
       #IF l_sfb01_t != l_sfb01_o THEN   #MOD-AC0078 add  #CHI-B90052 mark
           LET l_cnt_t = l_cnt_t + 1
       #END IF                           #MOD-AC0078 add  #CHI-B90052 mark
       #LET l_sfb01_o=l_sfb01_t          #MOD-AC0078 add  #CHI-B90052 mark
     END FOREACH
   END IF
 
       CASE
          WHEN tm.stk = 'Y' AND tm.wip = 'Y'
              LET l_sw_tot = l_sw_cnt1 + l_cnt_t
              LET g_cnt1 = l_sw_tot                           #MOD-9C0035 add
                  CALL cl_progress_bar(l_sw_tot)
          WHEN tm.stk = 'Y' AND tm.wip = 'N'
                  LET g_cnt1 = l_sw_cnt1                      #MOD-9C0035 add
                  CALL cl_progress_bar(l_sw_cnt1)
          WHEN tm.stk = 'N' AND tm.wip = 'Y'
                  LET g_cnt1 = l_cnt_t                        #MOD-9C0035 add
                  CALL cl_progress_bar(l_cnt_t)
       END CASE
  END IF
 
  IF tm.stk = 'Y' THEN
      LET l_sql = "SELECT '',img01,img02,img03,img04, img19,img26,",
                  " img10,img09,img21,",
                  " ima06,ima09,ima10,ima11,ima12,ima23",
                  " FROM img_file,ima_file ",
                  " WHERE img01=ima01 AND ",g_wc1 CLIPPED
 
     LET l_sql = l_sql CLIPPED , " AND imaacti <> 'N' "    #No:MOD-A10008 add
     IF tm.noinv1 = 'N' THEN
        LET l_sql = l_sql clipped ," AND img10 != 0 " #BugNo:4485
     END IF
     LET l_sw='N'
     FOR g_i = 1 TO 6       #資料產生順序
        CASE tm.order1[g_i,g_i]
                   WHEN '1' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY ima23' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,ima23'
                    END IF
           WHEN '2' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY img02' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,img02'
                    END IF
           WHEN '3' IF l_sw='N' THEN
                     LET l_wc=' ORDER BY img03' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,img03'
                    END IF
           WHEN '4' IF l_sw='N' THEN
                        LET l_wc=' ORDER BY img04' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,img04'
                    END IF
           WHEN '5' IF l_sw='N' THEN
                                 LET l_wc=' ORDER BY img01' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,img01'
                    END IF
           WHEN '6'
                     IF l_sw='N' THEN  LET l_sw='Y'
                                        CASE tm.class1
                                          WHEN '0' LET l_wc=' ORDER BY ima06 '
                                          WHEN '1' LET l_wc=' ORDER BY ima09 '
                                          WHEN '2' LET l_wc=' ORDER BY ima10 '
                                  WHEN '3' LET l_wc=' ORDER BY ima11 '
                                          WHEN '4' LET l_wc=' ORDER BY ima12 '
                                          OTHERWISE EXIT CASE
                    END CASE
                 ELSE
                                        CASE tm.class1
                                  WHEN '0' LET l_wc=l_wc CLIPPED,' ,ima06'
                                  WHEN '1' LET l_wc=l_wc CLIPPED,' ,ima09'
                                  WHEN '2' LET l_wc=l_wc CLIPPED,' ,ima10'
                                  WHEN '3' LET l_wc=l_wc CLIPPED,' ,ima11'
                                  WHEN '4' LET l_wc=l_wc CLIPPED,' ,ima12'
                                          OTHERWISE EXIT CASE
                    END CASE
                 END IF
           OTHERWISE LET l_wc = l_wc  CLIPPED
        END CASE
     END FOR
     LET l_sql =l_sql CLIPPED,l_wc CLIPPED
    #UPDATE ima_file SET ima23=' ' WHERE ima23 IS NULL                    #FUN-C30315 mark
     UPDATE ima_file SET ima23=' ',imadate = g_today WHERE ima23 IS NULL  #FUN-C30315 add
 
     PREPARE p800_prepare12 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF #NO.FUN-5C0001
         RETURN
     END IF
     DECLARE p800_cs12 CURSOR WITH HOLD FOR p800_prepare12
     IF SQLCA.sqlcode THEN
         CALL cl_err('DECLARE p800_cs12:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF #NO.FUN-5C0001
         RETURN
     END IF
 
  #---->現有庫存起始流水號
     LET g_paper1 = 0
     LET l_pia01 = ''  #CHI-960065
     CALL s_showmsg_init()     #No.FUN-710025
     FOREACH p800_cs12 INTO g_pia.*
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
         #IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF #NO.FUN-5C0001  #MOD-CA0129 mark
          LET l_flag ='1'  #MOD-CA0129 add
          EXIT FOREACH
       END IF
       SELECT COUNT(*) INTO l_n FROM pia_file
          WHERE pia02=g_pia.pia02 AND pia03=g_pia.pia03
            AND pia04=g_pia.pia04 AND pia05=g_pia.pia05 AND pia19='N'
       IF l_n>0 THEN
          IF tm.sw = 'N' THEN
             CALL cl_progressing(" ")
          END IF
          CONTINUE FOREACH
       END IF
        IF g_pia.pia02 is null THEN
            CALL cl_progressing(" ")
            CONTINUE FOREACH
        END IF
        LET g_paper1 = g_paper1 + 1
        CALL s_auto_assign_no("aim",tm.tag1,tm.exedate,"5","pia_file","pia01","","","")
             RETURNING li_result,g_pia.pia01
        IF (NOT li_result) THEN
            LET g_success = 'N'
            LET l_flag ='1'  #MOD-CA0129 add
            EXIT FOREACH
        END IF
        LET l_pia01 = g_pia.pia01
        IF g_paper1 = 1 THEN
           LET g_bstk = g_pia.pia01
           LET l_tag1 = tm.tag1
           IF l_tag1.getlength() > 6 THEN
              LET tm.tag1 =  s_get_doc_no(tm.tag1)
           END IF
        END IF
 
        IF g_pia.pia03 IS NULL THEN LET g_pia.pia03 = ' ' END IF
        IF g_pia.pia04 IS NULL THEN LET g_pia.pia04 = ' ' END IF
        IF g_pia.pia05 IS NULL THEN LET g_pia.pia05 = ' ' END IF
        IF g_pia.pia08 IS NULL THEN LET g_pia.pia08 = 0   END IF
        IF g_pia.pia10 IS NULL THEN LET g_pia.pia10 = 1   END IF
        #FUN-B70032 --START-- #CHI-B90001 mark
        #IF tm.icdcnt = 'Y' THEN
        #   LET l_pia30 = g_pia.pia08
        #ELSE            
        #   LET l_pia30 = 0
        #END IF 
        #FUN-B70032 --END-- #CHI-B90001 mark
        message g_pia.pia01
        CALL ui.Interface.refresh()
        SELECT COUNT(*) INTO l_cnt FROM tlf_file                                                                                    
         WHERE tlf905=g_pia.pia01                                                                                                   
           AND tlf13  = 'aimp880'
           AND tlf01  = g_pia.pia02
           AND tlf902 = g_pia.pia03
           AND tlf903 = g_pia.pia04
           AND tlf904 = g_pia.pia05
        IF l_cnt > 0 THEN                                                                                                           
           CALL s_errmsg('tlf905',g_pia.pia01,g_pia.pia01,'aim-124',1)                                                                                     
           LET g_success = 'N'                                                                                                      
           CALL cl_progressing(" ")   #CHI-B90052 add
           CONTINUE FOREACH    #No.FUN-710025                                                                                                                   
        END IF                                                                                                                      
        LET g_pia930=p800_set_pia930(g_pia.pia02) #FUN-670093
        CASE tm.type                              #FUN-930122
             WHEN '1'  LET g_pia931=g_pia.ima06   #FUN-930122
             WHEN '2'  LET g_pia931=g_pia.ima23   #FUN-930122
             WHEN '3'  LET g_pia931=g_pia.ima09   #FUN-930122
             WHEN '4'  LET g_pia931=g_pia.ima10   #FUN-930122
             WHEN '5'  LET g_pia931=g_pia.ima11   #FUN-930122
             WHEN '6'  LET g_pia931=g_pia.ima12   #FUN-930122
        END CASE                                  #FUN-930122
        PUT p800_cpia  FROM g_pia.pia01,g_pia.pia02,g_pia.pia03,
                            g_pia.pia04,g_pia.pia05,g_pia.pia06,
                            g_pia.pia07,g_pia.pia08,g_pia.pia09,
                            g_pia.pia10,
                            g_user,g_today,g_null_date,g_null_date,g_zero,'N','N',l_pia30, #FUN-B70032 add l_pia30                    
                            g_pia930,g_pia931,g_plant,g_legal #FUN-670093 #FUN-930122 add g_pia931 #FUN-980004 add g_plant,g_legal
        IF SQLCA.sqlcode THEN
             CALL s_errmsg('','','ckp#1',SQLCA.sqlcode,1)
             LET g_success = 'N'
             CALL cl_progressing(" ")   #CHI-B90052 add
             CONTINUE FOREACH    #No.FUN-710025                                                                                                                   
        END IF
 
        #piaa_file資料insert
        IF g_sma.sma115 ='Y' THEN
           SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file  #MOD-CB0268 add ima907
            WHERE ima01=g_pia.pia02
           IF l_ima906 MATCHES '[23]' THEN
              FOREACH p800_cimgg USING g_pia.pia02,g_pia.pia03,
                                       g_pia.pia04,g_pia.pia05 INTO l_imgg.*
                  IF SQLCA.sqlcode != 0 THEN
                     CALL s_errmsg('','','foreach imgg:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
#                 LET g_paper1 = g_paper1 + 1   #MOD-B70069 mark
                  SELECT COUNT(*) INTO l_n FROM piaa_file
                   WHERE piaa02=l_imgg.imgg01 AND piaa03=l_imgg.imgg02
                     AND piaa04=l_imgg.imgg03 AND piaa05=l_imgg.imgg04
                     AND piaa09=l_imgg.imgg09 AND piaa19='N'
                  IF l_n>0 THEN
                     CONTINUE FOREACH
                  END IF
                  #MOD-CB0268 add
                  IF l_ima906 = '3' AND l_imgg.imgg09!=l_ima907 THEN
                     CONTINUE FOREACH
                  END IF
                  #MOD-CB0268 add--end
                  IF tm.noinv1 = 'N' THEN
                     IF l_imgg.imgg10 = 0 THEN
                        CONTINUE FOREACH
                     END IF
                  END IF
                  CALL ui.Interface.refresh()
                  LET g_paper1 = g_paper1 + 1   #MOD-B70069
                  LET g_pia930=p800_set_pia930(g_pia.pia02) #FUN-670093
                  LET l_pia30 = s_digqty(l_pia30,l_imgg.imgg09)   #No.FUN-BB0086
                  PUT p800_cpiaa  FROM l_imgg.imgg00,g_pia.pia01, g_pia.pia02,
                                       g_pia.pia03,  g_pia.pia04, g_pia.pia05,
                                       g_pia.pia06,  g_pia.pia07, l_imgg.imgg10,
                                       l_imgg.imgg09,l_imgg.imgg21,g_user,g_today,
                                       g_null_date,g_null_date,g_zero,'N','N',l_pia30, #FUN-B70032 add l_pia30
                                       g_pia930,g_pia931,g_plant,g_legal  #FUN-670093 #FUN-930122 ADD g_pia931 #FUN-980004 add g_plant,g_legal
                  IF SQLCA.sqlcode THEN
                       CALL s_errmsg('','','ckp#1.1',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       EXIT FOREACH
                  END IF
              END FOREACH
           END IF
        END IF
 
        #pias_file資料insert
        LET l_ima918=''
        LET l_ima921=''
        SELECT ima918,ima921 INTO l_ima918,l_ima921 FROM ima_file
         WHERE ima01=g_pia.pia02
        IF l_ima918='Y' OR l_ima921='Y' THEN
              FOREACH p800_cimgs USING g_pia.pia02,g_pia.pia03,
                                       g_pia.pia04,g_pia.pia05 
                 INTO l_imgs.*
                  IF SQLCA.sqlcode != 0 THEN
                     CALL s_errmsg('','','foreach imgs:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     EXIT FOREACH
                  END IF
                  IF l_imgs.imgs05 IS NULL THEN LET l_imgs.imgs05=' ' END IF
                  IF l_imgs.imgs06 IS NULL THEN LET l_imgs.imgs06=' ' END IF
                  #FUN-B70032 --START-- #CHI-B90001 mark                   
                  #IF tm.icdcnt = 'Y' THEN
                  #   LET l_pias30 = l_imgs.imgs10 
                  #ELSE                   
                  #   LET l_pias30 = 0 
                  #END IF
                  #FUN-B70032 --END-- #CHI-B90001 mark 
                  SELECT COUNT(*) INTO l_n FROM pias_file
                   WHERE pias02=l_imgs.imgs01 AND pias03=l_imgs.imgs02
                     AND pias04=l_imgs.imgs03 AND pias05=l_imgs.imgs04
                     AND pias06=l_imgs.imgs05 
                     AND pias07=l_imgs.imgs06 
                     AND pias19='N'
                  IF l_n>0 THEN
                     CONTINUE FOREACH
                  END IF
                  IF tm.noinv1 = 'N' THEN
                     IF l_imgs.imgs08 = 0 THEN
                        CONTINUE FOREACH
                     END IF
                  END IF
                  CALL ui.Interface.refresh()
                  PUT p800_cpias  FROM 
                     g_pia.pia01, 
                     g_pia.pia02,g_pia.pia03, g_pia.pia04, g_pia.pia05,
                     l_imgs.imgs05,l_imgs.imgs06,'',
                     l_imgs.imgs08,l_imgs.imgs07,g_user,g_today,g_null_date,'N',
                     l_pias30,g_plant,g_legal  #FUN-980004 add g_plant,g_legal #FUN-B70032 add l_pias30
                  IF SQLCA.sqlcode THEN
                       CALL s_errmsg('','','ckp#1.1-ins pias_file',SQLCA.sqlcode,1)
                       LET g_success = 'N'
                       EXIT FOREACH
                  END IF
              END FOREACH
        END IF
 
        #FUN-B70032 --START--
        IF s_industry('icd') THEN
           #FUN-BA0051 --START mark--
           #LET l_imaicd08=''           
           #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
           # WHERE imaicd00 = g_pia.pia02
           #IF l_imaicd08 = 'Y' THEN
           #FUN-BA0051 --END mark--
           IF s_icdbin(g_pia.pia02) THEN   #FUN-BA0051
              FOREACH p800_cidc USING g_pia.pia02,g_pia.pia03,g_pia.pia04,g_pia.pia05 INTO l_idc.*
                 IF SQLCA.sqlcode != 0 THEN
                    CALL s_errmsg('','','foreach idc:',SQLCA.sqlcode,1)
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
                 IF NOT cl_null(l_idc.idc05) AND NOT cl_null(l_idc.idc06) THEN
                    SELECT COUNT(*) INTO l_n FROM piad_file
                     WHERE piad02=l_idc.idc01 AND piad03=l_idc.idc02
                       AND piad04=l_idc.idc03 AND piad05=l_idc.idc04
                       AND piad06=l_idc.idc05 
                       AND piad07=l_idc.idc06 
                       AND piad19='N'
                    IF l_n>0 THEN
                       CONTINUE FOREACH
                    END IF
                    IF tm.noinv1 = 'N' THEN
                       IF l_idc.idc08 = 0 THEN
                          CONTINUE FOREACH
                       END IF
                    END IF
                    CALL ui.Interface.refresh()                                       
                    #FUN-B70032 --START-- #CHI-B90001 mark
                    #IF tm.icdcnt = 'Y' THEN
                    #   LET l_piad30 = l_idc.idc08
                    #ELSE                   
                    #   LET l_piad30 = 0
                    #END IF                    
                    #FUN-B70032 --END-- #CHI-B90001 mark
                    PUT p800_cpiad  FROM 
                       g_pia.pia01, 
                       g_pia.pia02,g_pia.pia03, g_pia.pia04, g_pia.pia05,
                       l_idc.idc05,l_idc.idc06,'',
                       l_idc.idc08,l_idc.idc07,g_user,g_today,g_null_date,'N',
                       l_piad30,g_plant,g_legal  
                    IF SQLCA.sqlcode THEN
                         CALL s_errmsg('','','ckp#1.1-ins piad_file',SQLCA.sqlcode,1)
                         LET g_success = 'N'
                         EXIT FOREACH
                    END IF
                 END IF    
              END FOREACH
           END IF
        END IF    
        #FUN-B70032 --END--
 
      IF tm.sw = 'N' THEN
          CALL cl_progressing(" ")
      END IF
 
      END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
      IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','FOREACH p800_cs12:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF  #NO.FUN-5C0001
          RETURN
      END IF
      IF g_success = 'N' AND l_flag ='1' THEN   #MOD-CA0129 add l_flag
          IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF  #NO.FUN-5C0001
          RETURN
      END IF
      LET g_bstk1 = l_pia01   #CHI-980065記錄截止單號
   END IF
 
   LET ecm_flg='N'
   DROP TABLE sub_tmp
   CREATE TEMP TABLE sub_tmp
   (a         LIKE sfb_file.sfb01,
    b         LIKE sfb_file.sfb05,
    c         LIKE sfb_file.sfb08);
   #---->在製工單盤點資料產生作業
   IF cl_null(g_wc2) THEN
       LET g_wc2 = " 1=1 "
   END IF
   IF tm.wip = 'Y' THEN
      #不使用製程，則無法取得工作中心
      IF g_sma.sma54 ='N' THEN
         LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09,",
                     "sfb10,sfb11,sfb12,sfb15,",
                     "sfa03,sfa05,sfa06,sfa062,sfa161,sfa063,",
                     "sfa065,sfa13,sfa08,sfa11,sfa12,'',sfb82,ima55,'','','',",
                     "sfa26,sfa27,sfa28,sfb93,sfa100,sfa012", #NO:7474   #No.MOD-810009 modify  #FUN-A60095
                #    " FROM sfb_file,sfa_file LEFT OUTER JOIN ima_file ON ima01 = sfb05",   #No.FUN-9B0028  #TQC-A40028
                     " FROM sfa_file,sfb_file LEFT OUTER JOIN ima_file ON ima01 = sfb05",   #TQC-A40028
                     " WHERE sfb01 = sfa01 ",
                     "   AND sfb02 <> 13 AND sfb87 <> 'X' ", #NO:7473
                     "   AND sfb04 IN ('4','5','6','7')",  #FUN-5C0040 BETWEEN 4 AND 7 ",
                     "   AND sfa11!= 'E'",                                     #CHI-B70010 add
                     "   AND ",g_wc2 CLIPPED
      ELSE
         #工單生產製程追蹤設定( '1':不使用)
         IF g_sma.sma26 = '1'  THEN
            LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09,",
                        "sfb10,sfb11,sfb12,sfb15,",
                        "sfa03,sfa05,sfa06,sfa062,sfa161,sfa063,",
                        "sfa065,sfa13,sfa08,sfa11,sfa12,ecb08,sfb82,ima55,",
                        " '','','',sfa26,sfa27,sfa28,sfb93,sfa100,sfa012", #NO:7474   #No.MOD-810009 modify #FUN-A60095
                        " FROM sfa_file,sfb_file",
                        "      LEFT OUTER JOIN ecb_file ON ecb01 = sfb05 AND ecb02 = sfb06 AND ecb03=sfb17",    #FUN-A60027 mod
                        "      LEFT OUTER JOIN ima_file ON ima01 = sfb05",
                        " WHERE sfb01 = sfa01 ",
                        "   AND sfb04 IN ('4','5','6','7')",  #FUN-5C0040 BETWEEN 4 AND 7 ",
                        "   AND sfb02 <> 13 AND sfb87 <> 'X' ", #NO:7473
                        "   AND sfa11!= 'E'",                                     #CHI-B70010 add  
                        "   AND ",g_wc2 CLIPPED   #98/06/12 modify
        ELSE
            LET ecm_flg='Y'
            IF cl_db_get_database_type() = 'ORA' THEN
               LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09,sfb10,",
                           "sfb11,sfb12,sfb15,",
                           "sfa03,sfa05,sfa06,sfa062,sfa161,sfa063,",
                           "sfa065,sfa13,sfa08,sfa11,sfa12,ecm06,sfb82,ima55,",
                           "ecm52,pmm09,ecm03,sfa26,sfa27,sfa28,",
                           "sfb93,sfa100,ecm012 ",   #FUN-A60095 
                           " FROM sfb_file ",  #FUN-A60095
                           " LEFT OUTER JOIN ima_file ON ima01=sfb05 ",  #FUN-A60095
                           " ,sfa_file ",  #FUN-A60095
                          #"      (SELECT DISTINCT pmn41,pmn46,pmm09,pmn43,pmn012 ",  #FUN-A60095 #FUN-A60095
                          #"          FROM pmn_file,pmm_file ",                                   #FUN-A60095
                          #"          WHERE pmn01=pmm01) tmp ",                                   #FUN-A60095
                           " LEFT OUTER JOIN ecm_file ON ecm01 = sfa01  AND ecm04 = sfa08 ",  #FUN-A60095
                          #"  AND ecm03 = sfa013 AND ecm012= sfa012 ",                        #FUN-A60095   #FUN-B40082
                           l_ecm_where,  #FUN-B40082
                           " LEFT OUTER JOIN pmn_file ",  #FUN-A60095
                           " LEFT OUTER JOIN pmm_file ON pmm01 = pmn01 ",  #FUN-A60095
                           "   ON pmn41 = sfa01  AND pmn43  = sfa013  AND pmn012 = sfa012 ",  #FUN-A60095                          
                           " WHERE sfb01 = sfa01 ",
                          #" AND sfb_file.sfb05 = ima_file.ima01 ", #FUN-A60095
                           " AND sfb87!='X' ",  #CHI-960065
                          #" AND sfb04 IN ('2','3','4','5','6','7') ",   #MOD-C80184 mark
                           " AND sfb04 IN ('4','5','6','7') ",           #MOD-C80184
                           " AND (sfb02=1 OR sfb02=5 OR sfb02=7 OR sfb02=8) ",     #MOD-B20012 add sfb02=8
                          #" AND ecm01 = sfa01 ",  #FUN-A60095
                          #" AND ecm04 = sfa08 ",  #FUN-A60095
                           " AND sfa06 > 0 ",
                          #" AND tmp.pmn41 = sfb_file.sfb01 ",  #FUN-A60095
                           "   AND ",g_wc2 CLIPPED
            ELSE
               LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09,sfb10,",
                           "sfb11,sfb12,sfb15,",
                           "sfa03,sfa05,sfa06,sfa062,sfa161,sfa063,",
                           "sfa065,sfa13,sfa08,sfa11,sfa12,ecm06,sfb82,ima55,",
                           "ecm52,pmm09,ecm03,sfa26,sfa27,sfa28,",
                           "sfb93,sfa100,ecm012 ", #NO:7474  #FUN-A60095 
#No.FUN-9B0028 --begin
                           " FROM sfb_file",
                           "      LEFT OUTER JOIN ima_file ON ima01 = sfb05,",
                           "      sfa_file",
                          #"      LEFT OUTER JOIN ecm_file ON ecm01 = sfa01 AND ecm04 = sfa08 AND ecm012 = sfa012 AND ecm013 = ecm013,",   #FUN-A60027 add ecm012,ecm013  #FUN-A60076 mark
                           "      LEFT OUTER JOIN ecm_file ON ecm01 = sfa01 AND ecm04 = sfa08 ",  #FUN-B40082
                          #" AND ecm012 = sfa012 AND ecm03 = sfa013,",    #FUN-A60076  #FUN-B40082
                           l_ecm_where ,  #FUN-B40082
                           "      LEFT OUTER JOIN TABLE(multiset", 
                           "       (SELECT DISTINCT pmn41,pmn46,pmm09 ",
                           "          FROM pmn_file,pmm_file ",
                           "          WHERE pmn01=pmm01)) ON pmn41 = sfa01 ",  #FUN-A60095
                           "            AND pmn43=sfa013 AND pmn012= sfa012 ", #FUN-A60095 
                           " WHERE sfb01 = sfa01 ",
                           " AND sfb87!='X' ",
                          #" AND sfb04 MATCHES '[234567]'",  #MOD-C80184 mark
                           " AND sfb04 MATCHES '[4567]'",    #MOD-C80184
                           " AND (sfb02=1 OR sfb02=5 OR sfb02=7 OR sfb02=8) ",     #MOD-B20012 add sfb02=8
                           " AND sfa06 > 0 ",
                           "   AND ",g_wc2 CLIPPED
           END IF
        END IF
     END IF
     IF cl_null(g_wc2) THEN
        LET l_sql = l_sql clipped," sfa05 > 0 "
     ELSE
        LET l_sql = l_sql clipped," AND sfa05 > 0 "
     END IF
     LET l_sw='N'
     FOR g_i = 1 TO 6       #資料產生順序
        CASE tm.order2[g_i,g_i]
	   WHEN '1' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY sfb05' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb05'
                    END IF
           WHEN '2' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY sfb15' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb15'
                    END IF
           WHEN '3' IF l_sw='N' THEN
                     LET l_wc=' ORDER BY sfb04' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb04'
                    END IF
           WHEN '4' IF l_sw='N' THEN
                        LET l_wc=' ORDER BY sfb02' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb02'
                    END IF
           WHEN '5' IF l_sw='N' THEN
	 	                 LET l_wc=' ORDER BY sfb01' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb01'
                    END IF
           WHEN '6' IF l_sw='N' THEN
	 	                 LET l_wc=' ORDER BY sfb82' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,sfb82'
                    END IF
           OTHERWISE LET l_wc = l_wc  CLIPPED
        END CASE
     END FOR
        IF cl_null(l_wc) THEN
           LET l_wc = l_wc clipped," ORDER BY sfa08,sfa27,sfa26,sfa012,sfa013,sfa03"    #No.MOD-770016 modify #No.MOD-910031 add  #FUN-A60095
        ELSE
           LET l_wc = l_wc clipped,",sfa08,sfa27,sfa26,sfa012,sfa013,sfa03"             #No.MOD-770016 modify #No.MOD-910031 add  #FUN-A60095
        END IF
     LET l_sql =l_sql CLIPPED,l_wc CLIPPED
     PREPARE p800_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF  #NO.FUN-5C0001
         RETURN
     END IF
     DECLARE p800_cs1 CURSOR WITH HOLD FOR p800_prepare1
     IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('','','DECLARE p800_cs1:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF  #NO.FUN-5C0001
         RETURN
     END IF
 
     LET g_paper2 = 0
     LET l_pia01 = ''  #CHI-960065
     LET l_sfb01_old ='!@$$%^&*()'
     LET l_sfa08_old ='!@$$%^&*()'
     LET l_pmm09_old ='!@$$%^&*()'
     LET l_ecm012_old =' ' #FUN-A60095
     LET l_ecm03_old =0    #FUN-A60095
     LET l_n3 = 0 
     LET l_tag2 = tm.tag2
     IF l_tag2.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pid_file
         WHERE pid01 = tm.tag2
        IF l_n3 > 0 THEN
           LET tm.tag2 = s_get_doc_no(tm.tag2)
        END IF
     END IF
    #LET l_sfb01_o=' '   #MOD-AC0078 add    #CHI-B90052 mark
     FOREACH p800_cs1 INTO l_sfb01, l_sfb02, l_sfb04, l_sfb05,
                           l_sfb08, l_sfb09, l_sfb10, l_sfb11,
                           l_sfb12, l_sfb15, l_sfa03,
                           l_sfa05, l_sfa06, l_sfa062,l_sfa161,
                           l_sfa063,l_sfa065,l_sfa13, l_sfa08,
                           l_sfa11, l_sfa12, l_work , l_sfb82,
                           l_ima55,l_ecm52,l_pmm09, l_ecm03,
                           l_sfa26,l_sfa27,l_sfa28,l_sfb93,l_sfa100, #NO:7474
                           l_ecm012   #FUN-A60095
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF  #NO.FUN-5C0001
          EXIT FOREACH
       END IF
       LET l_cnt_t1 = l_cnt_t1 + 1
       IF l_sfb93='N' THEN
          SELECT COUNT(*) INTO l_n FROM pid_file,pie_file
           WHERE pid01=pie01 AND pid02=l_sfb01 AND pie16='N'#BugNo:6111
            #AND (pid022 IS NULL OR pid022='')          #MOD-B10064 mark
             AND (pid022 IS NULL OR pid022=' ')         #MOD-B10064 add
             AND pie02=l_sfa03
             AND pie900=l_sfa27  #MOD-CC0261 add
          IF l_n>0 THEN
             IF tm.sw = 'N' THEN CALL cl_progressing(" ") END IF #NO.FUN-5C0001
             CONTINUE FOREACH
          END IF
 
          IF l_sfb01 != l_sfb01_old THEN
             LET l_work=NULL
             LET l_ecm03=0          #作業序
             LET l_sub ='N'
             LET l_subno=NULL
             CALL s_auto_assign_no("aim",tm.tag2,tm.exedate,"I","pid_file","pid01","","","")
             RETURNING li_result,l_pid01
             IF (NOT li_result) THEN
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_pia01 = l_pid01
             IF g_paper2 = 0 THEN
                LET g_bwip = l_pid01
                LET l_tag2 = tm.tag2
                IF l_tag2.getlength() > 6 THEN
                   LET tm.tag2 =  s_get_doc_no(tm.tag2)
                END IF
             END IF
             #產生[在製工單]盤點標籤檔
             message l_pid01
             CALL ui.Interface.refresh()
             #將值放置pid_file中
             #No.FUN-A70131--begin
             IF cl_null(l_ecm012) THEN 
                LET l_ecm012=' '
             END IF 
             IF cl_null(l_ecm03) THEN 
                LET l_ecm03=0
             END IF 
             #No.FUN-A70131--end                
             PUT p800_cpid  FROM l_pid01,l_sfb01,l_ecm03,' ',l_sfb82,          #MOD-850266
                                 l_sfb05,l_sfb08,l_ima55,'N','N',
                                 g_user,g_today,g_null_date,g_null_date,g_zero,
                                 l_sfb09,l_sfb10,l_sfb11,l_sfb12,l_sfb82,g_plant,g_legal,       #BugNo:6110 #FUN-980004 add g_plant,g_legal
                                 l_ecm012   #FUN-A60095
             IF SQLCA.sqlcode THEN
                CALL cl_err('ckp#3',SQLCA.sqlcode,1)
                CALL s_errmsg('','','ckp#3',SQLCA.sqlcode,1)
                LET g_success = 'N'
                CALL cl_progressing(" ")   #CHI-B90052 add
                CONTINUE FOREACH
             END IF
             LET g_paper2 = g_paper2 + 1   #實際產生張數
             LET l_item   = 0
          END IF
       ELSE
          #盤點卡號,工單號,料號,廠商,作業編號
          SELECT COUNT(*) INTO l_n FROM pid_file,pie_file
           WHERE pid01=pie01 AND pid02=l_sfb01 AND pie16='N'
             AND pie02=l_sfa03  #98/06/12 modify
             AND pid023=l_pmm09
             AND pid022=l_sfa08
             AND pid021=l_ecm03
             AND pid012=l_ecm012   #FUN-A60095
          IF l_n>0 THEN
             IF tm.sw = 'N' THEN CALL cl_progressing(" ") END IF #NO.FUN-5C0001
             CONTINUE FOREACH
          END IF
 
          #---->有使用製程但無法取得工作中心
          IF g_sma.sma54 ='Y' THEN
             IF l_work IS NULL OR l_work = ' ' THEN
                LET l_work = l_sfa08   #作業編號
             END IF
          END IF
          #================> 產生單頭盤點卡號 pid_file
          #盤點卡依工號,作業編號,廠商不同而有盤點卡
          IF (l_sfb01!=l_sfb01_old) OR
             (l_sfa08 !=l_sfa08_old) OR (l_pmm09 !=l_pmm09_old) OR
             (l_ecm012 !=l_ecm012_old) OR (l_ecm03 !=l_ecm03_old) THEN   #FUN-A60095
             CALL s_auto_assign_no("aim",tm.tag2,tm.exedate,"I","pid_file","pid01","","","")
             RETURNING li_result,l_pid01
             IF (NOT li_result) THEN
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_pia01 = l_pid01
             IF g_paper2 = 0 THEN
                LET g_bwip = l_pid01
                LET l_tag2 = tm.tag2
                IF l_tag2.getlength() > 6 THEN
                   LET tm.tag2 =  s_get_doc_no(tm.tag2)
                END IF
             END IF
             #產生[在製工單]盤點標籤檔
             message l_pid01
             CALL ui.Interface.refresh()
             IF (l_sfb01!=l_sfb01_old) OR (l_sfa08 !=l_sfa08_old) OR
                (l_ecm012 !=l_ecm012_old) OR (l_ecm03 !=l_ecm03_old) THEN   #FUN-A60095
               #FUN-A60095(S)
               #SELECT MIN(ecm03) INTO l_MINecm03 FROM ecm_file
               # WHERE ecm01=l_sfb01 AND ecm012=l_ecm012  #FUN-A60095
               #IF STATUS THEN    #在製程檔中找不到最小序號
               #   CALL s_errmsg('ecm01',l_sfb01,'chk#9901',STATUS,1)
               #   LET g_success = 'N'
               #   CONTINUE FOREACH   #No.FUN-710025
               #END IF
               #SELECT MAX(ecm03) INTO l_MAXecm03 FROM ecm_file
               # WHERE ecm01=l_sfb01 AND ecm012=l_ecm012  #FUN-A60095
               #IF STATUS THEN #在製程檔中找不到最大序號
               #   CALL s_errmsg('ecm01',l_sfb01,'chk#9902',STATUS,1) 
               #   LET g_success = 'N'
               #   CONTINUE FOREACH   #No.FUN-710025
               #END IF
               CALL s_schdat_min_ecm03(l_sfb01) RETURNING l_MINecm012,l_MINecm03
               IF l_MINecm03=0 OR l_MINecm03 IS NULL THEN    #在製程檔中找不到最小序號
                  CALL s_errmsg('ecm01',l_sfb01,'chk#9901',STATUS,1)
                  LET g_success = 'N'
                  CALL cl_progressing(" ")   #CHI-B90052 add
                  CONTINUE FOREACH   #No.FUN-710025
               END IF
               CALL s_schdat_max_ecm03(l_sfb01) RETURNING l_MAXecm012,l_MAXecm03
               IF l_MAXecm03=0 OR l_MAXecm03 IS NULL THEN #在製程檔中找不到最大序號
                  CALL s_errmsg('ecm01',l_sfb01,'chk#9902',STATUS,1) 
                  LET g_success = 'N'
                  CALL cl_progressing(" ")   #CHI-B90052 add
                  CONTINUE FOREACH   #No.FUN-710025
               END IF
               #FUN-A60095(E)
             END IF
 
             #如果此站為第一站則 WIP 量為"0"
             #ANN01
             #===========================================================
             # PART I
             # 當作業編號不同時要重抓在製量
             #------------------------------------------------
             IF (l_sfb01!=l_sfb01_old) OR (l_sfa08 != l_sfa08_old) OR
                (l_ecm012 !=l_ecm012_old) OR (l_ecm03 !=l_ecm03_old) THEN   #FUN-A60095
                LET l_sub='N'
                LET l_subno=NULL
 
                   SELECT ecm301,ecm302,ecm303,ecm311,ecm312,ecm313,ecm314,ecm316,
                          ecm321,ecm322,ecm57,ecm62,ecm63   #TQC-B60287
                     INTO ll_ecm301,ll_ecm302,ll_ecm303,ll_ecm311,ll_ecm312,
                          ll_ecm313,ll_ecm314,ll_ecm316,ll_ecm321,ll_ecm322,l_ima55,
                          ll_ecm62,ll_ecm63    #TQC-B60287
                     FROM ecm_File
                    WHERE ecm01=l_sfb01
                      AND ecm03=l_ecm03
                      AND ecm04=l_sfa08
                      AND ecm012=l_ecm012  #FUN-A60095
                IF STATUS THEN #在製程檔中找不到相對應的數據
                   #此工單備料檔中含有不存在在製程檔中的作業編號!
                   LET g_showmsg = l_sfb01,"/",l_ecm03,"/",l_sfa08,"/",l_ecm012  #FUN-A60095
                   CALL s_errmsg('ecm01,ecm03,ecm04,ecm012',g_showmsg,l_sfb01,'aim-801',1)  #FUN-A60095
                   LET g_success = 'N'
                   CALL cl_progressing(" ")   #CHI-B90052 add
                   CONTINUE FOREACH    #No.FUN-710025
                END IF
             END IF
             #------------------------------------------------
             #PART II
             #屬委外站
             #1.找出此站的總委外量
             #當委外廠商不相同時要重抓委外量(委外WIP量)
             #PS.一定要有報工才算數,即使有入庫也不行
             #99.12.25 重新定義
             #不管委外量,委外量抓總量
             #------------------------------------------------
             IF l_ecm03=l_MINecm03 AND l_ecm012=l_MINecm012 THEN  #FUN-A60095
                #第一站套數給0
                LET l_sfb08 = 0
             ELSE
                #不是第一站則需算出本站的 WIP 量
                #正常值為轉入量-轉出量-報廢量-盤點量  ????注意平行站的算法
                #(含BONUS)
                IF cl_null(ll_ecm301) THEN LET ll_ecm301 = 0 END IF
                IF cl_null(ll_ecm302) THEN LET ll_ecm302 = 0 END IF
                IF cl_null(ll_ecm303) THEN LET ll_ecm303 = 0 END IF
                IF cl_null(ll_ecm311) THEN LET ll_ecm311 = 0 END IF
                IF cl_null(ll_ecm312) THEN LET ll_ecm312 = 0 END IF
                IF cl_null(ll_ecm313) THEN LET ll_ecm313 = 0 END IF
                IF cl_null(ll_ecm314) THEN LET ll_ecm314 = 0 END IF
                IF cl_null(ll_ecm316) THEN LET ll_ecm316 = 0 END IF
                IF cl_null(ll_ecm62) OR ll_ecm62=0 THEN LET ll_ecm62 = 1 END IF  #TQC-B60287
                IF cl_null(ll_ecm63) OR ll_ecm63=0 THEN LET ll_ecm63 = 1 END IF  #TQC-B60287
                IF l_ecm52='N' THEN  #不屬於委外站
                   #最後一站則需判斷完工入庫量
                   #轉入量-完工入庫量-重工轉出量-報廢量-當站下線量
                   IF l_ecm03=l_MAXecm03 AND l_ecm012=l_MAXecm012 THEN  #FUN-A60095
                      LET l_sfb08=ll_ecm301+ll_ecm302+ll_ecm303-l_sfb09-
                                  ll_ecm312-ll_ecm313-ll_ecm314-ll_ecm316
                   ELSE
                      LET l_sfb08=ll_ecm301+ll_ecm302+ll_ecm303-ll_ecm311-
                                  ll_ecm312-ll_ecm313-ll_ecm314-ll_ecm316
                   END IF
                ELSE
                   LET l_sfb08=ll_ecm301+ll_ecm302+ll_ecm303-ll_ecm311-
                               ll_ecm312-ll_ecm313-ll_ecm314-ll_ecm316-
                               ll_ecm321+ll_ecm322
                END IF
             END IF
             IF l_ecm52='Y' AND (NOT cl_null(l_pmm09)) THEN
                IF ll_ecm301 > ll_ecm321 THEN
                   SELECT count(*) INTO g_cnt FROM pid_file
                    WHERE pid02=l_sfb01  AND pid021=l_ecm03
                      AND pid022=l_sfa03 AND pid023=l_sfb82
                      AND pid012=l_ecm012  #FUN-A60095
                   IF g_cnt=0 THEN
                      #No.FUN-A70131--begin
                      IF cl_null(l_ecm012) THEN 
                         LET l_ecm012=' '
                      END IF 
                      #No.FUN-A70131--end
                      INSERT INTO pid_file(pid01,pid02,pid021,pid022,pid023,
                                           pid03,pid04,pid05,pid06,pid07,pid08,
                                           pid09,pid10,pid11,pid12,pid13,pid14,
                                           pid15,pid17,pid18,pidplant,pidlegal,pid012)  #FUN-A60095
                           VALUES(l_pid01,l_sfb01,l_ecm03,l_sfa08,l_sfb82,
                                  l_sfb05,l_sfb08,l_ima55,'N','N',g_user,
                                  g_today,'','',g_zero,l_sfb09,l_sfb10,
                                  l_sfb11,l_sfb12,l_sfb82,g_plant,g_legal,l_ecm012)  #FUN-A60095
                      IF SQLCA.sqlcode THEN
                         CALL s_errmsg('','',l_sfb01,SQLCA.sqlcode,1)
                         LET g_success = 'N'
                         CALL cl_progressing(" ")   #CHI-B90052 add
                         CONTINUE FOREACH    #No.FUN-710025
                      END IF
                      LET l_sub='Y'
                      LET l_subno=l_pid01
                      LET g_paper2 = g_paper2 + 1   #實際產生張數
                      CALL s_auto_assign_no("aim",tm.tag2,tm.exedate,"I","pid_file","pid01","","","")
                      RETURNING li_result,l_pid01
                      IF (NOT li_result) THEN
                         LET g_success = 'N'
                         EXIT FOREACH
                      END IF
                      LET l_tag2 = tm.tag2
                      IF l_tag2.getlength() > 6 THEN
                         LET tm.tag2 =  s_get_doc_no(tm.tag2)
                      END IF
                      #產生[在製工單]盤點標籤檔
                      message l_pid01
                      CALL ui.Interface.refresh()
                   END IF
                END IF
             END IF
             #將值放置pid_file中
             IF l_ecm52='Y' THEN
                   SELECT SUM(pmn20-pmn53) INTO l_sfb08 FROM pmn_file,pmm_file
                      WHERE pmm01=pmn01 AND pmn41=l_sfb01 AND pmm18 !='X'
                        AND pmn46=l_ecm03 AND pmm09=l_pmm09
                        AND pmn012=l_ecm012  #FUN-A60095
                   IF STATUS OR cl_null(l_sfb08) THEN LET l_sfb08=0 END IF
             END IF
             #No.FUN-A70131--begin
             IF cl_null(l_ecm012) THEN 
                LET l_ecm012=' '
             END IF 
             IF cl_null(l_ecm03) THEN 
                LET l_ecm03=0
             END IF 
             #No.FUN-A70131--end                
             PUT p800_cpid  FROM l_pid01,l_sfb01,l_ecm03    ,l_sfa08    ,l_pmm09,
                                 l_sfb05,l_sfb08,l_ima55    ,'N'        ,'N'    ,
                                 g_user ,g_today,g_null_date,g_null_date,g_zero ,
                                 l_sfb09,l_sfb10,l_sfb11    ,l_sfb12    , l_sfb82,g_plant,g_legal, #BugNo:6110 #FUN-980004 add g_plant,g_legal
                                 l_ecm012    #FUN-A60095
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','ckp#3',SQLCA.sqlcode,1)
                LET g_success = 'N'
                CALL cl_progressing(" ")   #CHI-B90052 add
                CONTINUE FOREACH    #No.FUN-710025
             END IF
             LET g_paper2 = g_paper2 + 1   #實際產生張數
             LET l_item   = 0
         END IF
      END IF
      #--->產生盤點標籤明細[在製工單](下階用料)資料檔
      LET l_item = l_item + 1
      #===================================================================
      #--->計算未入庫數量
      #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢
      #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
      #====================================================================
      #99.12.19 無委外廠的計算公式(一)
      #99.12.19 實際已用量=((轉出量ecm311+重工轉出ecm312+報廢ecm313)*
      #                      QPA) + 下階報廢
      #         應盤數量  = 已發數量+超領數量-實際已用量
      #99.12.19 委外廠計算公式(二)
      #         實際已用量= 此廠商委製單總量[pmn20]-此廠商已報工量[shb111]
      #         應盤數量  = 此廠商已發數量+此廠商超領數量-實際已用量
      IF cl_null(l_sfb09) THEN LET l_sfb09 = 0 END IF     #完工量
      IF cl_null(l_sfb12) THEN LET l_sfb12 = 0 END IF     #報廢量
      IF cl_null(l_sfa06) THEN LET l_sfa06 = 0 END IF     #已發
      IF cl_null(l_sfa062) THEN LET l_sfa062 = 0 END IF   #超領
      IF cl_null(l_sfa063) THEN LET l_sfa063 = 0 END IF   #報廢量
      IF cl_null(l_sfa161) THEN LET l_sfa161 = 0 END IF
      IF l_ecm012 IS NULL THEN LET l_ecm012=' ' END IF  #FUN-A60095
      IF l_ecm03  IS NULL THEN LET l_ecm03 =0   END IF  #FUN-A60095
      IF l_sfb93='N' THEN
         LET l_work=l_sfa08               #bugno:7111 add 'T'
         IF l_sfa26='4' OR l_sfa26='3' OR l_sfa26='U' OR l_sfa26='S' OR l_sfa26 = 'T' 
                        OR l_sfa26='8' OR l_sfa26='Z'  #FUN-A20037 add
                              THEN
             IF g_sma.sma542='Y' THEN  #FUN-B40082(S)
                SELECT sfa161 INTO ll_sfa161 FROM sfa_file
                 WHERE sfa01=l_sfb01
                   AND sfa03=l_sfa27
                   AND sfa012=l_ecm012  #FUN-A60095
                   AND sfa013=l_ecm03   #FUN-A60095
             #FUN-B40082(S)
             ELSE
                SELECT sfa161 INTO ll_sfa161 FROM sfa_file
                 WHERE sfa01=l_sfb01
                   AND sfa03=l_sfa27
             END IF
             #FUN-B40082(E)
             IF STATUS THEN LET ll_sfa161=0 END IF
             LET l_actuse = ((l_sfb09 + l_sfb12) * (ll_sfa161*l_sfa28)) +
                              l_sfa063
             LET l_sfa161=ll_sfa161
             SELECT SUM(c) INTO l_tmp_actuse FROM sub_tmp
                 WHERE a = l_sfb01
                   AND b = l_sfa27
 
             IF cl_null(l_tmp_actuse) THEN LET l_tmp_actuse = 0 END IF
             LET l_tmp_actuse = l_tmp_actuse * (l_sfa161*l_sfa28)
             LET l_actuse = l_actuse - l_tmp_actuse
             IF l_actuse <= 0 THEN LET l_actuse = 0 END IF
             IF cl_null(l_actuse) THEN LET l_actuse = 0 END IF
             IF (l_sfa06 + l_sfa062) > l_actuse THEN
                LET l_uninv = (l_sfa06 + l_sfa062) - l_actuse
                LET l_uninv = s_digqty(l_uninv,l_sfa12)    #FUN-910088--add--
                INSERT INTO sub_tmp
                  VALUES(l_sfb01,l_sfa27,l_actuse/(l_sfa161*l_sfa28))
             ELSE
                LET l_uninv = 0
                INSERT INTO sub_tmp
                  VALUES(l_sfb01,l_sfa27,((l_sfa06 + l_sfa062)/(l_sfa161*l_sfa28)))
             END IF
             IF cl_null(l_uninv) THEN LET l_uninv = 0 END IF
         ELSE
             LET l_actuse = ((l_sfb09 + l_sfb12) * l_sfa161) + l_sfa063
             IF cl_null(l_actuse) THEN LET l_actuse = 0 END IF
             LET l_uninv = (l_sfa06 + l_sfa062) - l_actuse
             LET l_uninv = s_digqty(l_uninv,l_sfa12)    #FUN-910088--add--
             IF cl_null(l_uninv) THEN LET l_uninv = 0 END IF
         END IF
         IF l_uninv < 0 THEN
             IF cl_null(l_sfa100) THEN LET l_sfa100=0 END IF
             IF l_sfa100=100 THEN
                LET l_uninv=0
             ELSE
                LET l_minp=(l_sfa06+l_sfa062) * (1+l_sfa100/100)
                IF l_minp > l_actuse THEN
                   LET l_uninv=0
                ELSE
                   LET l_uninv=l_minp - l_actuse
                   LET l_uninv = s_digqty(l_uninv,l_sfa12)    #FUN-910088--add--
                END IF
             END IF
          END IF
 
         PUT p800_cpie  FROM l_pid01,l_sfa03,l_sfa08,
                             l_sfa12,l_work,l_sfa11,l_item,
                             l_sfa05,l_sfa06,l_sfa062,l_sfa161,
                             l_sfa063,l_sfa065,l_sfa13,l_uninv,'N',
                             l_sfa27,g_plant,g_legal,l_ecm012,l_ecm03  #FUN-980004 add g_plant,g_legal  #FUN-A60095
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','',l_sfb01,SQLCA.sqlcode,1)
            LET g_success = 'N'
            CALL cl_progressing(" ")   #CHI-B90052 add
            CONTINUE FOREACH  #No.FUN-710025
         END IF
      ELSE
         IF cl_null(ll_ecm311) THEN LET ll_ecm311 = 0 END IF #轉出量
         IF cl_null(ll_ecm312) THEN LET ll_ecm312 = 0 END IF #重工轉出
         IF cl_null(ll_ecm313) THEN LET ll_ecm313 = 0 END IF #報廢
         IF cl_null(ll_ecm316) THEN LET ll_ecm316 = 0 END IF
         IF cl_null(ll_ecm62) OR ll_ecm62=0 THEN LET ll_ecm62 = 1 END IF  #TQC-B60287
         IF cl_null(ll_ecm63) OR ll_ecm63=0 THEN LET ll_ecm63 = 1 END IF  #TQC-B60287
            IF l_sfa26='4' OR l_sfa26='3' OR l_sfa26='U' OR l_sfa26='S' OR l_sfa26 = 'T' 
                           OR l_sfa26='8' OR l_sfa26='Z'   #FUN-A20037 add
                           THEN
               IF g_sma.sma542='Y' THEN  #FUN-B40082(S)
                 SELECT sfa161 INTO ll_sfa161 FROM sfa_file
                  WHERE sfa01=l_sfb01
                    AND sfa03=l_sfa27
                    AND sfa012=l_ecm012  #FUN-A60095
                    AND sfa013=l_ecm03   #FUN-A60095
               #FUN-B40082(S)
               ELSE
                  SELECT sfa161 INTO ll_sfa161 FROM sfa_file
                   WHERE sfa01=l_sfb01
                     AND sfa03=l_sfa27
               END IF
               #FUN-B40082(E)
               IF STATUS THEN LET ll_sfa161=0 END IF
               LET l_sfa161=ll_sfa161
               SELECT pie12,pie14 INTO lll_pie12,lll_pie14
                 FROM pie_file,pid_file
                WHERE pie01=pid01
                  AND pid02=l_sfb01
                  AND pid021=l_ecm03
                  AND pid022=l_sfa08
                  AND pie02=l_sfa27
                  AND pid012=l_ecm012  #FUN-A60095
               IF STATUS THEN LET lll_pie12=0 LET lll_pie14=0 END IF
               IF cl_null(lll_pie12) THEN LET lll_pie12=0 END IF
               IF cl_null(lll_pie14) THEN LET lll_pie14=0 END IF
               LET lll_miuse=lll_pie12/lll_pie14
               IF cl_null(lll_miuse) THEN LET lll_miuse=0 END IF
              #LET l_actuse = ((ll_ecm311+ll_ecm312+ll_ecm313)*(ll_sfa161*l_sfa28))                    #TQC-B60287
               LET l_actuse = ((ll_ecm311+ll_ecm312+ll_ecm313)/ll_ecm62*ll_ecm63*(ll_sfa161*l_sfa28))  #TQC-B60287
            ELSE
              #LET l_actuse = ((ll_ecm311+ll_ecm312+ll_ecm313)*l_sfa161)   #TQC-B60287
               LET l_actuse = ((ll_ecm311+ll_ecm312+ll_ecm313)/ll_ecm62*ll_ecm63*l_sfa161)   #TQC-B60287
            END IF
            IF cl_null(l_actuse) THEN LET l_actuse = 0 END IF
            LET l_uninv = (l_sfa06 + l_sfa062) - l_actuse
            LET l_uninv = s_digqty(l_uninv,l_sfa12)    #FUN-910088--add--
            IF cl_null(l_uninv) THEN LET l_uninv=0 END IF
            IF l_sfa26!='0' THEN
               IF (l_uninv < 0 OR l_actuse<0) AND (l_sfa05=l_sfa06) THEN
                  LET l_uninv= 0
               END IF
            END IF
          IF NOT cl_null(l_subno) THEN
             #No.FUN-A70131--begin
             IF cl_null(l_ecm012) THEN 
                LET l_ecm012=' '
             END IF 
             IF cl_null(l_ecm03) THEN 
                LET l_ecm03=' '
             END IF 
             #No.FUN-A70131--end   
             INSERT INTO pie_file (pie01,pie02,pie03,pie04,pie05,pie06,pie07,
                                   pie11,pie12,pie13,pie14,pie15,pie151,pie152,
                                   pie153,pie16,pie900,pieplant,pielegal,pie012,pie013)  #FUN-A60095
                  VALUES (l_subno,l_sfa03,l_sfa08,l_sfa12,l_work,l_sfa11,l_item,
                          l_sfa05,l_sfa06,l_sfa062,l_sfa161,l_sfa063,l_sfa065,
                          l_sfa13,l_uninv,'N',l_sfa27,g_plant,g_legal,l_ecm012,l_ecm03)  #FUN-A60095
             IF SQLCA.sqlcode THEN
                CALL s_errmsg('','','ckp#4.1',SQLCA.sqlcode,1)
                LET g_success = 'N'
                CALL cl_progressing(" ")   #CHI-B90052 add
                CONTINUE FOREACH   #No.FUN-710025
             END IF
          END IF
          IF l_sub='Y' AND (NOT cl_null(l_subno)) THEN
             SELECT SUM(pmn20-pmn53) INTO l_uninv FROM pmn_file,pmm_file
                WHERE pmm01=pmn01 AND pmn41=l_sfb01 AND pmm18 !='X'
                  AND pmn46=l_ecm03 AND pmm09=l_pmm09
                  AND pmn012=l_ecm012  #FUN-A60095
             IF STATUS OR cl_null(l_uninv) THEN LET l_uninv=0 END IF
          END IF
          PUT p800_cpie  FROM l_pid01,l_sfa03,l_sfa08,
                              l_sfa12,l_work,l_sfa11,l_item,
                               l_sfa05,l_sfa06,l_sfa062,l_sfa161,
                               l_sfa063,l_sfa065,l_sfa13,l_uninv,'N',
                               l_sfa27,g_plant,g_legal,l_ecm012,l_ecm03 #FUN-980004 add g_plant,g_legal  #FUN-A60095
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('','',l_sfb01,SQLCA.sqlcode,1)
             LET g_success = 'N'
             CALL cl_progressing(" ")   #CHI-B90052 add
             CONTINUE FOREACH  #No.FUN-710025
          END IF
      END IF
      LET l_sfb01_old = l_sfb01
      LET l_sfa08_old = l_sfa08 #99.12.16
      LET l_pmm09_old = l_pmm09
      LET l_ecm012_old = l_ecm012  #FUN-A60095
      LET l_ecm03_old = l_ecm03   #FUN-A60095
      IF tm.sw = 'N' THEN
        #IF l_sfb01 != l_sfb01_o THEN     #MOD-AC0078 add   #CHI-B90052 mark  
            CALL cl_progressing(" ")
        #END IF                           #MOD-AC0078 add   #CHI-B90052 mark
        #LET l_sfb01_o=l_sfb01            #MOD-AC0078 add   #CHI-B90052 mark
      END IF 
    END FOREACH
    IF g_totsuccess="N" THEN                                                                                                         
        LET g_success="N"                                                                                                             
    END IF                                                                                                                           
 
    IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','FOREACH p800_cs1:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
    END IF
    IF g_success = 'N' THEN
        RETURN
    END IF
    LET g_bwip1 = l_pia01   #CHI-960065 #記錄截止單號
  END IF
 
  #---->現有庫存空白標籤產生
  IF tm.spcg1 = 'Y' THEN
     LET g_spcstk = 0
     LET l_pia01 = '' #CHI-960065
     LET l_n3 = 0
     LET l_spc1 = tm.spc1
     IF l_spc1.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pia_file
         WHERE pia01 = tm.spc1
        IF l_n3 > 0 THEN
           LET tm.spc1=s_get_doc_no(tm.spc1)
        END IF
     END IF
     FOR g_cnt=1 TO tm.qty1
         CALL s_auto_assign_no("aim",tm.spc1,tm.exedate,"5","pia_file","pia01","","","")
              RETURNING li_result,g_pia.pia01
         IF (NOT li_result) THEN
             LET g_success = 'N'
             EXIT FOR
         END IF
         LET l_pia01 = g_pia.pia01
         IF g_spcstk = 0 THEN
            LET g_bspcstk = g_pia.pia01
            LET l_spc1 = tm.spc1
            IF l_spc1.getlength() > 6 THEN
               LET tm.spc1 =  s_get_doc_no(tm.spc1)
            END IF
         END IF
        message g_pia.pia01
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
        CALL ui.Interface.refresh()
        SELECT COUNT(*) INTO l_cnt FROM tlf_file                                                                                    
         WHERE tlf905=g_pia.pia01                                                                                                   
           AND tlf13  = 'aimp880'
           AND tlf01  = g_pia.pia02
           AND tlf902 = g_pia.pia03
           AND tlf903 = g_pia.pia04
           AND tlf904 = g_pia.pia05
        IF l_cnt > 0 THEN                                                                                                           
           CALL cl_err(g_pia.pia01,'aim-124',1)                                                                                     
           LET g_success = 'N'                                                                                                      
           IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF                                                                  
           RETURN                                                                                                                   
        END IF   
        LET g_pia931 = ''  #CHI-C30068         
        PUT p800_cpia  FROM
            g_pia.pia01,g_null_char,g_null_char,g_null_char,g_null_char,
            g_null_char,g_null_char,g_null_dec ,g_null_char,g_null_dec ,
            g_user     ,g_today    ,g_null_date,g_null_date,g_zero     ,
            'Y'        ,'N',g_zero ,g_null_char,g_pia931,g_plant    ,g_legal   #FUN-670093 #FUN-980004 add g_plant,g_legal#CHI-960065 add pia931  #FUN-BA0015 add g_zero
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','ckp#6',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CONTINUE FOR
        END IF
        LET g_spcstk = g_spcstk + 1  #CHI-960065 記錄空白標簽生成張數
       #str MOD-A40036 add
        #piaa_file資料insert
        IF g_sma.sma115 ='Y' THEN
           PUT p800_cpiaa  FROM
               '1'        ,g_pia.pia01,g_null_char,g_null_char,g_null_char,
               g_null_char,g_null_char,g_null_char,g_null_dec ,' ',
               g_null_dec ,g_user     ,g_today    ,g_null_date,g_null_date,
              #g_zero     ,'Y'        ,'N'        ,g_null_char,g_pia931,               #MOD-C20038 mark
               g_zero     ,'Y'        ,'N'        ,g_null_dec ,g_null_char,g_pia931,   #MOD-C20038 add  g_null_dec
               g_plant    ,g_legal
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('','','ckp#6.1',SQLCA.sqlcode,1)
              LET g_success = 'N'
              CONTINUE FOR
           END IF
        END IF
       #end MOD-A40036 add
     END FOR
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
    LET g_bspcstk1 = l_pia01   #CHI-960065
  END IF
 
  IF tm.spcg2 = 'Y' THEN
     LET l_n3 = 0
     LET l_spc2 = tm.spc2
     IF l_spc2.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pid_file
         WHERE pid01 = tm.spc2
        IF l_n3 > 0 THEN
           LET tm.spc2=s_get_doc_no(tm.spc2)
        END IF
     END IF
    LET g_spcwip  = 0
    LET l_pia01 = '' #CHI-960065
        FOR g_cnt=1 TO tm.qty2
       CALL s_auto_assign_no("aim",tm.spc2,tm.exedate,"I","pid_file","pid01","","","")
       RETURNING li_result,l_pid01
       IF (NOT li_result) THEN
           LET g_success = 'N'
           EXIT FOR
       END IF
       LET l_pia01 = l_pid01
       IF g_spcwip = 0 THEN
          LET g_bspcwip = l_pid01  #記錄開始單號
          LET l_spc2 = tm.spc2
          IF l_spc2.getlength() > 6 THEN
             LET tm.spc2 =  s_get_doc_no(tm.spc2)
          END IF
       END IF
       message l_pid01
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
       CALL ui.Interface.refresh()
        #No.FUN-A70131--begin
        IF cl_null(l_ecm012) THEN 
           LET l_ecm012=' '
        END IF 
        IF cl_null(l_ecm03) THEN 
           LET l_ecm03=0
        END IF 
        #No.FUN-A70131--end    
       PUT p800_cpid  FROM
                  l_pid01    ,g_space    ,g_zero,     #g_null_dec ,  #FUN-A60095
                  g_null_char,g_null_char,
                  g_space    ,g_null_dec ,g_null_char,'Y'        ,'N'        ,
                  g_user     ,g_today    ,g_null_date,g_null_date,g_zero     ,
                  g_zero     ,g_zero     ,g_zero     ,g_zero     ,g_null_char, #BugNo:6110
                  g_plant    ,g_legal    ,g_space  #FUN-980004 add g_plant,g_legal  #FUN-A60095
       IF SQLCA.sqlcode THEN
          CALL s_errmsg('','','ckp#8',SQLCA.sqlcode,0)
          RETURN
       END IF
       LET g_spcwip = g_spcwip + 1  #CHI-960065 記錄空白標簽生成張數
    END FOR
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
   LET g_bspcwip1 = l_pia01  #CHI-960065 記錄截止單號
  END IF
  FLUSH p800_cpia
  FLUSH p800_cpiaa   #No.FUN-570082
  FLUSH p800_cpias   #No.FUN-860001
  IF s_industry('icd') THEN FLUSH p800_cpiad END IF  #No.FUN-B70032
  FLUSH p800_cpid
  FLUSH p800_cpie
END FUNCTION
 
FUNCTION p800_cur2()
 DEFINE l_cmd  LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(600)
 
   LET l_cmd = " INSERT INTO pia_file (pia01,pia02,pia08,pia09,pia10,",
                                     " pia11,pia12,pia13,pia14,pia15,",
                                     " pia16,pia19,pia930)", #FUN-670093
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)"  #FUN-670093
   PREPARE p800_pia2 FROM l_cmd
   DECLARE p800_cpia2 CURSOR WITH HOLD FOR p800_pia2
   IF SQLCA.sqlcode THEN
       CALL cl_err('DECLARE p800_cpia2:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF
 
   LET l_cmd = " INSERT INTO pid_file(pid01,pid02,pid021,pid022,pid023,pid03,",
                                    " pid04,pid05,",
                                    " pid06,pid07,pid08,pid09,",
                                    " pid10,pid11,pid12,pid13,",
                                    " pid14,pid15,pid17,pid18,pid012)",  #FUN-A60095
           " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?)"  #FUN-A60095
 
   PREPARE p800_pid2 FROM l_cmd
   DECLARE p800_cpid2 CURSOR WITH HOLD FOR p800_pid2
   IF SQLCA.sqlcode THEN
       CALL cl_err('DECLARE p800_cpid2:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF
 
   LET l_cmd = "INSERT INTO pie_file(pie01,pie02,pie03,pie04,",
                                   " pie05,pie06,pie07,pie11,",
                                   " pie12,pie13,pie14,pie15,",
                                   " pie151,pie152,pie153,pie16,pie900,pie012,pie013)",  #FUN-A60095
               " VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?, ?, ?, ?,? ,?,?) "  #FUN-A60095
   PREPARE p800_pie2 FROM l_cmd
   DECLARE p800_cpie2 CURSOR WITH HOLD FOR p800_pie2
   IF SQLCA.sqlcode THEN
       CALL cl_err('DECLARE p800_cpie2:',SQLCA.sqlcode,1)
       LET g_success = 'N'
       RETURN
   END IF
 
   OPEN p800_cpia2
   OPEN p800_cpid2
   OPEN p800_cpie2
END FUNCTION
 
#---->單倉處理
FUNCTION p800_2()
   DEFINE l_name    LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-690026 VARCHAR(20)
          l_sql     LIKE type_file.chr1000, # RDSQL STATEMENT  #No.FUN-690026 VARCHAR(600)
          l_za05    LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(40)
          l_wc      LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
          g_pia     RECORD
                    pia01  LIKE pia_file.pia01,    #標籤編號
                    pia02  LIKE pia_file.pia02,    #料件編號
                    pia03  LIKE pia_file.pia03,    #倉庫別         #TQC-930124
                    pia04  LIKE pia_file.pia04,    #存放位置       #TQC-930124
                    pia05  LIKE pia_file.pia05,    #批號           #TQC-930124
                    pia08  LIKE pia_file.pia08,    #庫存數量
                    pia09  LIKE pia_file.pia09,    #庫存單位
                    ima06  LIKE ima_file.ima06,    #分群碼
                    ima09  LIKE ima_file.ima09,    #其它分群碼(1)
                    ima10  LIKE ima_file.ima10,    #其它分群碼(2)
                    ima11  LIKE ima_file.ima11,    #其它分群碼(3)
                    ima12  LIKE ima_file.ima12,    #其它分群碼(4)
                    ima23  LIKE ima_file.ima23     #倉管員
                    END RECORD,
          l_sfb01   LIKE sfb_file.sfb01,
          l_sfb01_old LIKE sfb_file.sfb01,
          l_sfa08_old LIKE sfa_file.sfa08,   #99.12.16
          l_pmm09_old LIKE pmm_file.pmm09,
          l_sfb02   LIKE sfb_file.sfb02,
          l_sfb04   LIKE sfb_file.sfb04,
          l_sfb05   LIKE sfb_file.sfb05,
          l_sfb08   LIKE sfb_file.sfb08,
          l_sfb09   LIKE sfb_file.sfb09,
          l_sfb10   LIKE sfb_file.sfb10,
          l_sfb11   LIKE sfb_file.sfb11,
          l_sfb12   LIKE sfb_file.sfb12,
          l_sfb15   LIKE sfb_file.sfb15,
          l_sfb82   LIKE sfb_file.sfb82,
          l_sfa03   LIKE sfa_file.sfa03,
          l_sfa05   LIKE sfa_file.sfa05,
          l_sfa06   LIKE sfa_file.sfa06,
          l_sfa062  LIKE sfa_file.sfa062,
          l_sfa063  LIKE sfa_file.sfa063,
          l_sfa065  LIKE sfa_file.sfa065,
          l_sfa13   LIKE sfa_file.sfa13,
          l_sfa08   LIKE sfa_file.sfa08,
          l_sfa11   LIKE sfa_file.sfa11,
          l_sfa12   LIKE sfa_file.sfa12,
          l_sfa161  LIKE sfa_file.sfa161,
          l_ima55   LIKE ima_file.ima55,
          l_ecm52   LIKE ecm_file.ecm52,   #委外否
          l_pmm09   LIKE pmm_file.pmm09,
          l_ecm03   LIKE ecm_file.ecm03,   #作業序991219
          l_sfa26   LIKE sfa_file.sfa26,   #取替代 99.12.22
          l_sfa27   LIKE sfa_file.sfa27,
          l_sfa28   LIKE sfa_file.sfa28,
          l_sfb93   LIKE sfb_file.sfb93,   #製程否
          l_work    LIKE ecm_file.ecm06,
          l_pid01   LIKE pid_file.pid01,
          l_actuse  LIKE pie_file.pie153,
          l_uninv   LIKE pie_file.pie153,
          l_item    LIKE type_file.num5,     #No.FUN-690026 SMALLINT
          l_sw      LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
          l_sfa100  LIKE sfa_file.sfa100     #NO.MOD-590417
DEFINE    l_cnt     LIKE type_file.num5      #TQC-660091    #No.FUN-690026 SMALLINT
DEFINE    li_result LIKE type_file.num5      #CHI-960065
DEFINE    l_pia01   LIKE pia_file.pia01      #CHI-960065
DEFINE l_tag1         STRING                 #CHI-960065   
DEFINE l_tag2         STRING                 #CHI-960065   
DEFINE l_spc1         STRING                 #CHI-960065   
DEFINE l_spc2         STRING                 #CHI-960065   
DEFINE l_n3           LIKE type_file.num5    #CGI-960065 
DEFINE l_avl_stk_mpsmrp  LIKE type_file.num15_3,  #FUN-A20044
       l_unavl_stk       LIKE type_file.num15_3,  #FUN-A20044
       l_avl_stk         LIKE type_file.num15_3   #FUN-A20044
DEFINE l_ecm012       LIKE ecm_file.ecm012   #FUN-A60095

     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
  #---->產生再有庫存狀況
  IF tm.stk = 'Y' THEN
#    LET l_sql = "SELECT ' ',ima01,ima35,ima36,' ',ima262,ima25,",      #TQC-930124 add ima35,ima36,' '   #FUN-A20044
     LET l_sql = "SELECT ' ',ima01,ima35,ima36,' ',' ',ima25,",         #FUN-A20044
                  " ima06,ima09,ima10,ima11,ima12,ima23",
                  " FROM ima_file ",                        
                  " WHERE ima08 NOT IN ('C','D','A') "
 
     IF tm.noinv1 = 'N' THEN
#       LET l_sql = l_sql clipped ," AND ima262 > 0 "                   #FUN-A20044
        LET l_sql = l_sql clipped                                       #FUN-A20044  
     END IF
 
     LET l_sw='N'
     FOR g_i = 1 TO 6       #資料產生順序
        CASE tm.order1[g_i,g_i]
                   WHEN '1' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY ima23' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,ima23'
                    END IF
           WHEN '5' IF l_sw='N' THEN
                         LET l_wc=' ORDER BY ima01' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,ima01'
                    END IF
           WHEN '6'
                     IF l_sw='N' THEN  LET l_sw='Y'
                                        CASE tm.class1
                                          WHEN '0' LET l_wc=' ORDER BY ima06 '
                                          WHEN '1' LET l_wc=' ORDER BY ima09 '
                                          WHEN '2' LET l_wc=' ORDER BY ima10 '
                                  WHEN '3' LET l_wc=' ORDER BY ima11 '
                                          WHEN '4' LET l_wc=' ORDER BY ima12 '
                                          OTHERWISE EXIT CASE
                    END CASE
                 ELSE
                                        CASE tm.class1
                                  WHEN '0' LET l_wc=l_wc CLIPPED,' ,ima06'
                                  WHEN '1' LET l_wc=l_wc CLIPPED,' ,ima09'
                                  WHEN '2' LET l_wc=l_wc CLIPPED,' ,ima10'
                                  WHEN '3' LET l_wc=l_wc CLIPPED,' ,ima11'
                                  WHEN '4' LET l_wc=l_wc CLIPPED,' ,ima12'
                                  OTHERWISE EXIT CASE
                    END CASE
                 END IF
           OTHERWISE LET l_wc = l_wc  CLIPPED
        END CASE
     END FOR
     LET l_sql =l_sql CLIPPED,l_wc CLIPPED
 
     PREPARE p800_prepare21 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
     END IF
     DECLARE p800_cs21 CURSOR WITH HOLD FOR p800_prepare21
     IF SQLCA.sqlcode THEN
         CALL cl_err('DECLARE p800_cs21:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
     END IF
 
     #現有庫存起始流水號
     LET g_paper1 = 0
     LET l_pia01 = ''  #CHI-960065
     FOREACH p800_cs21 INTO g_pia.*
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
       IF SQLCA.sqlcode != 0 THEN CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       IF g_pia.pia02 is null THEN CONTINUE FOREACH END IF

#No.FUN-A20044 ---start---
      CALL s_getstock(g_pia.pia02,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
      IF tm.noinv1 = 'N' THEN
         IF l_avl_stk <= 0 THEN
            CONTINUE FOREACH
         END IF 
      END IF 
      LET g_pia.pia08 = l_avl_stk 
#No.FUN-A20044 ---end--- 

       LET g_paper1 = g_paper1 + 1
           CALL s_auto_assign_no("aim",tm.tag1,tm.exedate,"5","pia_file","pia01","","","")
           RETURNING li_result,g_pia.pia01
           IF (NOT li_result) THEN
              LET g_success = 'N'
              EXIT FOREACH
           END IF
           LET l_pia01 = g_pia.pia01
           IF g_paper1 = 1 THEN
              LET g_bstk = g_pia.pia01
              LET l_tag1 = tm.tag1
              IF l_tag1.getlength() > 6 THEN
                 LET tm.tag1 =  s_get_doc_no(tm.tag1)
              END IF
           END IF
       message g_pia.pia01
       CALL ui.Interface.refresh()
       SELECT COUNT(*) INTO l_cnt FROM tlf_file                                                                                     
        WHERE tlf905=g_pia.pia01                                                                                                    
           AND tlf13  = 'aimp880'
           AND tlf01  = g_pia.pia02
           AND tlf902 = g_pia.pia03
           AND tlf903 = g_pia.pia04
           AND tlf904 = g_pia.pia05
       IF l_cnt > 0 THEN                                                                                                            
          CALL cl_err(g_pia.pia01,'aim-124',1)                                                                                      
          LET g_success = 'N'                                                                                                       
          IF tm.sw = 'N' THEN CALL cl_close_progress_bar() END IF                                                                   
          RETURN                                                                                                                    
       END IF                                                                                                                       
       LET g_pia930=p800_set_pia930(g_pia.pia02) #FUN-670093
       PUT p800_cpia2 FROM g_pia.pia01,g_pia.pia02,g_pia.pia08,
                           g_pia.pia09,'1',g_user,g_today,
                           g_null_date,g_null_date,g_zero,'N','N',g_pia930,g_plant,g_legal #FUN-670093 #FUN-980004 add g_plant,g_legal
       IF SQLCA.sqlcode THEN
            CALL s_errmsg('','',g_pia.pia01,SQLCA.sqlcode,0)
            LET g_success = 'N'
            CONTINUE FOREACH
       END IF
     END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
     IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','FOREACH p800_cs21:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
     END IF
     IF g_success = 'N' THEN
         RETURN
     END IF
 
     LET g_bstk1 = l_pia01  #CHI-960065 記錄截止單號
  END IF
 
  #在製工單盤點資料產生作業
  IF tm.wip = 'Y' THEN
     #不使用製程，則無法取得工作中心
     IF g_sma.sma54 ='N' THEN
        LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09,",
                    " sfb10,sfb11,sfb12,sfb15,sfb82,",
                    " sfa03,sfa05,sfa06,sfa062,sfa161,sfa063,",
                    " sfa065,sfa13,sfa08,sfa11,sfa12,'',ima55,'','','',",
                    "sfa26,sfa27,sfa28,sfb93",
                 #  " FROM sfb_file,sfa_file LEFT OUTER JOIN ima_file ON ima01 = sfb05",    #No.FUN-9B0028  #TQC-A40028
                    " FROM sfa_file,sfb_file LEFT OUTER JOIN ima_file ON ima01 = sfb05",    #TQC-A40028
                    " WHERE sfb01 = sfa01 ",
                    "   AND sfb02 < 3  AND sfb87!='X' ",
                    "   AND sfa11!= 'E'",                                     #CHI-B70010 add
                    "   AND sfb04 MATCHES '[4567]'"  #FUN-5C0040 BETWEEN 4 AND 7 "
     ELSE
        #工單生產製程追蹤設定( '1':不使用)
        IF g_sma.sma26 = '1'  THEN
           LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09",
                       " sfb10,sfb11,sfb12,sfb15,sfb82,",
                       " sfa03,sfa05,sfa06,sfa062,sfa161,sfa063,",
                       " sfa065,sfa13,sfa08,sfa11,sfa12,ecb08,ima55,'','','',",
                       "sfa26,sfa27,sfa28,sfb93",
                       " FROM sfb_file",
                       "      LEFT OUTER JOIN ecb_file ON ecb01 = sfb05 AND ecb02 = sfb06",
                       "      LEFT OUTER JOIN ima_file ON ima01 = sfb05, ",
                       "      sfa_file", 
                       "      LEFT OUTER JOIN ecb_file ON ecb02 = sfa08 ",
                       " WHERE sfb01 = sfa01 ",
                       "   AND sfb02 < 3  AND sfb87!='X' ",
                       "   AND sfb04 IN ('4','5','6','7')",  #FUN-5C0040 BETWEEN 4 AND 7 ",
                       "   AND sfa11!= 'E'",                                     #CHI-B70010 add
                       "   AND ecbacti='Y' "
       ELSE
           IF cl_db_get_database_type() = 'ORA' THEN
              LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09",
                          " sfb10,sfb11,sfb12,sfb15,sfb82,",
                          " sfa03,sfa05,sfa06,sfa062,sfa161,sfa63,",
                          " sfa065,sfa13,sfa08,sfa11,sfa12,ecm06,ima55,",
                          "ecm52,pmm09,ecm03,sfa26,sfa27,sfa28,sfb93", 
                          " FROM sfb_file,sfa_file,ecm_file,ima_file,",
                           "      (SELECT DISTINCT pmn41,pmn46,pmm09,pmn43,pmn012 ",  #FUN-A60095
                           "         FROM pmn_file,pmm_file ",
                           "         WHERE pmn01=pmm01) tmp ",
                          " WHERE sfb01 = sfa01 ",
                          " AND sfb_file.sfb05 = ima_file.ima01 ", #CHI-960065
                          " AND sfb02 < 3  AND sfb87!='X' ",
                          " AND sfb04 IN ('4','5','6','7') ", 
                          " AND ecm01= sfa01 ",
                          " AND ecm04=sfa08 ",    
                         #" AND ecm012 = sfa012 AND ecm013 = sfa013 ",     #FUN-A60027   #FUN-A60076
                          " AND ecm012 = sfa012 AND ecm03 = sfa013 ",      #FUN-A60076 
                          " AND sfa06 > 0 ",
                           " AND tmp.pmn41 = sfb_file.sfb01 ",
                           " AND sfa11!= 'E'",                                      #CHI-B70010 add
                           " AND tmp.pmn43  = sfa_file.sfa013 ",                    #FUN-A60095
                           " AND tmp.pmn012 = sfa_file.sfa012 "                     #FUN-A60095
           ELSE
              LET l_sql = "SELECT sfb01,sfb02,sfb04,sfb05,sfb08,sfb09",
                          " sfb10,sfb11,sfb12,sfb15,sfb82,",
                          " sfa03,sfa05,sfa06,sfa062,sfa161,sfa63,",
                          " sfa065,sfa13,sfa08,sfa11,sfa12,ecm06,ima55,",
                          "ecm52,pmm09,ecm03,sfa26,sfa27,sfa28,sfb93", #FUN-5C0040
                          " FROM sfb_file,sfa_file,OUTER ecm_file,",
                          "      OUTER ima_file, ",
                           "     OUTER TABLE(multiset",
                           "       (SELECT DISTINCT pmn41,pmn46,pmm09,pmn43,pmn012 ",  #FUN-A60095
                           "          FROM pmn_file,pmm_file ",
                           "          WHERE pmn01=pmm01))",
                          " WHERE sfb01 = sfa01 ",
                          " AND sfb_file.sfb05 = ima_file.ima01 ",
                          " AND sfb02 < 3  AND sfb87!='X' ",
                          " AND sfb04 MATCHES '[4567]'", 
                          " AND ecm_file.ecm01 = sfa_file.sfa01 ",
                          " AND ecm_file.ecm04 = sfa_file.sfa08 ",   
                         #" AND ecm_file.ecm012 = sfa_file.sfa012 AND ecm_file.ecm013 = sfa_file.sfa013 ",    #FUN-A60027 #FUN-A60076 mark 
                          " AND ecm_file.ecm012 = sfa_file.sfa012 AND ecm_file.ecm03 = sfa_file.sfa013 ",     #FUN-A60076   
                          " AND sfa06 > 0 ",
                          " AND sfa11!= 'E'",                                      #CHI-B70010 add
                           " AND pmn_file.pmn41 = sfb_file.sfb01 ",
                           " AND pmn_file.pmn43  = sfa_file.sfa013 ",                    #FUN-A60095
                           " AND pmn_file.pmn012 = sfa_file.sfa012 "                     #FUN-A60095
           END IF
       END IF
     END IF
     #-->應發數量> 0
     LET l_sql = l_sql clipped," AND sfa05 > 0 "
     LET l_sw='N'
     LET l_wc= ' ORDER BY sfb01,ecm03,sfa08,pmm09,sfa27,sfa26,sfa03'
     LET l_sw='Y'
     LET l_sql =l_sql CLIPPED,l_wc CLIPPED
     PREPARE p800_prepare22 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
     END IF
     DECLARE p800_cs22 CURSOR WITH HOLD FOR p800_prepare22
     IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','DECLARE p800_cs22:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
     END IF
 
     LET g_paper2 = 0
     LET l_pia01 = '' #CHI-960065
     LET l_sfb01_old ='!@$$%^&*()'
     LET l_sfa08_old ='!@$$%^&*()'
     LET l_pmm09_old ='!@$$%^&*()'
     LET l_n3 = 0
     LET l_tag2 = tm.tag2
     IF l_tag2.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pid_file
         WHERE pid01 = tm.tag2
        IF l_n3 > 0 THEN
           LET tm.tag2=s_get_doc_no(tm.tag2)
        END IF
     END IF
     FOREACH p800_cs22 INTO l_sfb01, l_sfb02, l_sfb04, l_sfb05,
                            l_sfb08, l_sfb09, l_sfb10, l_sfb11,
                            l_sfb12, l_sfb15, l_sfb82,
                            l_sfa03, l_sfa05, l_sfa06, l_sfa062,
                            l_sfa161, l_sfa063,l_sfa065,l_sfa13,
                            l_sfa08, l_sfa11, l_sfa12, l_work,
                            l_ima55,l_ecm52,l_pmm09,l_ecm03,
                            l_sfa26,l_sfa27,l_sfa28,l_sfb93,l_sfa100 #NO.MOD-590417
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
       IF SQLCA.sqlcode != 0 THEN
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1)
          LET g_success = 'N'
          EXIT FOREACH
       END IF
       #有使用製程但無法取得工作中心
       IF g_sma.sma54 ='Y' THEN
          IF l_work IS NULL OR l_work = ' ' THEN
             LET l_work=l_sfa08
          END IF
       END IF
       IF (l_sfb01!=l_sfb01_old) OR (l_sfa08 != l_sfa08_old)
          OR (l_pmm09 !=l_pmm09_old) THEN
             CALL s_auto_assign_no("aim",tm.tag2,tm.exedate,"I","pid_file","pid01","","","")
             RETURNING li_result,l_pid01
             IF (NOT li_result) THEN
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             LET l_pia01 = l_pid01
             IF g_paper2 = 0 THEN
                LET g_bwip = l_pid01
                LET l_tag2 = tm.tag2
                IF l_tag2.getlength() > 6 THEN
                   LET tm.tag2 =  s_get_doc_no(tm.tag2)
                END IF
             END IF
          #產生[在製工單]盤點標籤檔
          message l_pid01
          CALL ui.Interface.refresh()
          #No.FUN-A70131--begin
          IF cl_null(l_ecm012) THEN 
             LET l_ecm012=' '
          END IF 
          IF cl_null(l_ecm03) THEN 
             LET l_ecm03=0
          END IF 
          #No.FUN-A70131--end   
          PUT p800_cpid2  FROM l_pid01,l_sfb01,l_ecm03,l_sfa08,l_pmm09,l_sfb05,
                               l_sfb08,l_ima55,
                               'N','N',g_user,g_today,g_null_date,g_null_date,g_zero,
                               l_sfb09,l_sfb10,l_sfb11,l_sfb12,
                               l_sfb82,g_plant,g_legal,l_ecm012   #FUN-980004 add g_plant,g_legal  #FUN-A60095
          IF SQLCA.sqlcode THEN
             CALL s_errmsg('','','ckp#3',SQLCA.sqlcode,1)
             LET g_success = 'N'
             CONTINUE FOREACH
          END IF
          LET g_paper2 = g_paper2 + 1
          LET l_item   = 0
       END IF
       #--->產生盤點標籤明細[在製工單](下階用料)資料檔
       LET l_item = l_item + 1
       #--->計算未入庫數量
       #    實際已用量=((完工入庫量 + 報廢數量) * qpa ) + 下階報廢
       #    應盤數量  = 已發數量 + 超領數量 - 實際已用量
        LET l_actuse = ((l_sfb09 + l_sfb12) * l_sfa161) + l_sfa063
        #含超領
        LET l_uninv = (l_sfa06 + l_sfa062) - l_actuse
        LET l_uninv = s_digqty(l_uninv,l_sfa12)    #FUN-910088--add--
        #No.FUN-A70131--begin
        IF cl_null(l_ecm012) THEN 
           LET l_ecm012=' '
        END IF 
        IF cl_null(l_ecm03) THEN 
           LET l_ecm03=0
        END IF 
        #No.FUN-A70131--end           
        PUT p800_cpie2  FROM l_pid01,l_sfa03,l_sfa08,
                             l_sfa12,l_work,l_sfa11,l_item,
                             l_sfa05,l_sfa06,l_sfa062,l_sfa161,
                             l_sfa063,l_sfa065,l_sfa13,l_uninv,'N',
                             l_sfa27,g_plant,g_legal,l_ecm012,l_ecm03  #FUN-980004 add g_plant,g_legal  #FUN-A60095
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','ckp#4',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CONTINUE FOREACH
        END IF
        LET l_sfb01_old = l_sfb01
        LET l_sfa08_old = l_sfa08 #99.12.16
        LET l_pmm09_old = l_pmm09
     END FOREACH
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
     IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','FOREACH p800_cs22:',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
     END IF
    LET g_bwip1 = l_pia01   #CHI-960065
  END IF
 
  #---->現有庫存空白標籤產生
  IF tm.spcg1 = 'Y' THEN
     LET g_spcstk = 0
     LET l_pia01 = ''  #CHI-960065
     LET l_n3 = 0
     LET l_spc1 = tm.spc1
     IF l_spc1.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pia_file
         WHERE pia01 = tm.spc1
        IF l_n3 > 0 THEN
           LET tm.spc1=s_get_doc_no(tm.spc1)
        END IF
     END IF
     FOR g_cnt=1 TO tm.qty1
         CALL s_auto_assign_no("aim",tm.spc1,tm.exedate,"5","pia_file","pia01","","","")
              RETURNING li_result,g_pia.pia01
         IF (NOT li_result) THEN
             LET g_success = 'N'
             EXIT FOR
         END IF
         LET l_pia01 = g_pia.pia01
         IF g_spcstk = 0 THEN
            LET g_bspcstk = g_pia.pia01
            LET l_spc1 = tm.spc1
            IF l_spc1.getlength() > 6 THEN
               LET tm.spc1 =  s_get_doc_no(tm.spc1)
            END IF
         END IF
        message g_pia.pia01
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
        CALL ui.Interface.refresh()
        PUT p800_cpia2  FROM g_pia.pia01,g_null_char,g_null_dec,g_null_char,
                             g_null_dec,g_user,g_today,g_null_date,g_null_date,g_zero,'Y','N',g_null_char,g_plant,g_legal #FUN-670093 #FUN-980004 add g_plant,g_legal 
        IF SQLCA.sqlcode THEN
           CALL s_errmsg('','','ckp#6',SQLCA.sqlcode,1)
           LET g_success = 'N'
           CONTINUE FOR
        END IF
       LET g_spcstk = g_spcstk + 1   #CHI-960065 記錄空白標簽生成張數
     END FOR
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
    LET g_bspcstk1 = l_pia01  #CHI-960065 記錄截止單號
  END IF
 
  #---->在製工單空白標籤列印
  IF tm.spcg2 = 'Y' THEN
    LET g_spcwip  = 0
    LET l_pia01 =  ''  #CHI-960065
     LET l_n3 = 0
     LET l_spc2 = tm.spc2
     IF l_spc2.getlength() > 6 THEN
        SELECT COUNT(*) INTO l_n3 FROM pid_file
         WHERE pid01 = tm.spc2
        IF l_n3 > 0 THEN
           LET tm.spc2=s_get_doc_no(tm.spc2)
        END IF
     END IF
        FOR g_cnt=1 TO tm.qty2
       CALL s_auto_assign_no("aim",tm.spc2,tm.exedate,"I","pid_file","pid01","","","")
       RETURNING li_result,l_pid01
       IF (NOT li_result) THEN
           LET g_success = 'N'
           EXIT FOR
       END IF
       LET l_pia01 = l_pid01
       IF g_spcwip = 0 THEN
          LET g_bspcwip = l_pid01
          LET l_spc2 = tm.spc2
          IF l_spc2.getlength() > 6 THEN
             LET tm.spc2 =  s_get_doc_no(tm.spc2)
          END IF
       END IF
       message l_pid01
       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                                                                                                                       
 
       CALL ui.Interface.refresh()
       SELECT COUNT(*) INTO l_cnt FROM tlf_file                                                                                    
        WHERE tlf905=g_pia.pia01                                                                                                   
           AND tlf13  = 'aimp880'
           AND tlf01  = g_pia.pia02
           AND tlf902 = g_pia.pia03
           AND tlf903 = g_pia.pia04
           AND tlf904 = g_pia.pia05
       IF l_cnt > 0 THEN       
          CALL s_errmsg('tlf905',g_pia.pia01,'','aim-124',1)
          LET g_success = 'N'                                                                                                      
          CONTINUE FOR   #No.FUN-710025
       END IF           
        #No.FUN-A70131--begin
        IF cl_null(l_ecm012) THEN 
           LET l_ecm012=' '
        END IF 
        #No.FUN-A70131--end                                                                                                        
       PUT p800_cpid2  FROM l_pid01,g_space,g_null_dec,g_space,
                            g_null_char,g_null_char,g_null_dec,g_space,
                           'Y','N',g_user,g_today,g_null_date,g_null_date,g_zero,
                           g_zero,g_zero,g_zero,g_zero,' ',g_plant,g_legal,l_ecm012   #FUN-980004 add g_plant,g_legal #FUN-A60095
       IF SQLCA.sqlcode THEN 
          CALL s_errmsg('','','ckp#8',SQLCA.sqlcode,0)
          LET g_success = 'N'
          CONTINUE FOR
       END IF
       LET g_spcwip = g_spcwip + 1  #CHI-960065 記錄空白標簽生成張數
    END FOR
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
 
   LET g_bspcwip1 = l_pia01 #CHI-960065
  END IF
 
  FLUSH p800_cpia2
  FLUSH p800_cpid2
  FLUSH p800_cpie2
END FUNCTION
 
#---->檢查是否有任何盤點資料存在
FUNCTION p800_pro()
 DEFINE  l_chr               LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_cnt               LIKE type_file.num10,   #No.FUN-690026 INTEGER
         l_desc,l_str,l_str2 LIKE ze_file.ze03  #No.FUN-690026 VARCHAR(70)
 
   LET l_str = ' '   LET l_str2 = ' '   LET l_desc =''
   CALL cl_getmsg('mfg0119',g_lang) RETURNING l_str
   SELECT COUNT(*) INTO g_stkcnt FROM pia_file
   IF g_stkcnt > 0 THEN
        CALL cl_getmsg('mfg0120',g_lang) RETURNING l_desc
        LET l_str2 = l_str2 clipped,l_desc clipped
   END IF
   SELECT COUNT(*) INTO g_wipcnt FROM pid_file
   IF g_wipcnt > 0 THEN
      LET l_desc =''
      CALL cl_getmsg('mfg0121',g_lang) RETURNING l_desc
      LET l_str2 = l_str2 clipped,' ',l_desc clipped
   END IF
   IF g_stkcnt = 0 AND g_wipcnt = 0 THEN
      CALL cl_getmsg('mfg0122',g_lang) RETURNING l_str2
   END IF
   IF g_stkcnt > 0 AND g_wipcnt > 0 THEN
      LET l_str2 = l_str2 clipped,'  無法執行 !' clipped
   END IF
   CALL cl_msgany(0,0,l_str2)
   IF g_stkcnt > 0 AND g_wipcnt > 0 THEN
       LET g_success = 'N'
       RETURN
   END IF
   IF g_stkcnt > 0 OR g_wipcnt >0 THEN
      IF g_bgjob = 'N' THEN           #FUN-570122
          OPEN WINDOW p800_pro_w AT 10,20 WITH 6 ROWS, 40 COLUMNS
      
          WHILE l_chr IS NULL OR l_chr NOT MATCHES'[ABCabc]'
           CASE
             WHEN g_lang = '0'
               DISPLAY"(A).查明是否全部已過帳 (歷史性資料)" AT 2,2
               DISPLAY"(B).開始輸入作業選擇" AT 3,2
               DISPLAY"(C).放棄處理        " AT 4,2
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT "     請選擇 : " FOR CHAR l_chr
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                  
                  ON ACTION about         
                     CALL cl_about()      
                  
                  ON ACTION help          
                     CALL cl_show_help()  
                  
                  ON ACTION controlg      
                     CALL cl_cmdask()     
               END PROMPT
            WHEN g_lang = '2'
               DISPLAY"(A).查明是否全部已過帳 (歷史性資料)" AT 2,2
               DISPLAY"(B).開始輸入作業選擇" AT 3,2
               DISPLAY"(C).放棄處理        " AT 4,2
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT "     請選擇 : " FOR CHAR l_chr
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
                  
                  ON ACTION about         
                     CALL cl_about()      
                  
                  ON ACTION help          
                     CALL cl_show_help()  
                  
                  ON ACTION controlg      
                     CALL cl_cmdask()     
               END PROMPT
            OTHERWISE
              #CHI-A70049---mark---start---   
              #DISPLAY"(A).Check if all posted(History data)" AT 2,2
              #DISPLAY"(B).Begin Input Choice" AT 3,2
              #DISPLAY"(C).Quit Process    " AT 4,2
              #CHI-A70049---mark---end---
               LET INT_FLAG = 0  ######add for prompt bug
               PROMPT "     Option : " FOR CHAR l_chr
                  ON IDLE g_idle_seconds
                      CALL cl_on_idle()
     
                  ON ACTION about         #MOD-4C0121
                     CALL cl_about()      #MOD-4C0121
                  
                  ON ACTION help          #MOD-4C0121
                     CALL cl_show_help()  #MOD-4C0121
                  
                  ON ACTION controlg      #MOD-4C0121
                     CALL cl_cmdask()     #MOD-4C0121
 
               END PROMPT
          END CASE
          IF l_chr NOT MATCHES'[ABCabc]' THEN CONTINUE WHILE END IF
          IF INT_FLAG THEN LET INT_FLAG = 0 LET l_chr = "C" END IF
        END WHILE
      END IF    #FUN-570122
 
      IF l_chr matches'[Cc]' THEN
          LET g_success = 'N'
          RETURN
      END IF
      IF l_chr matches'[Aa]' THEN
         SELECT COUNT(*) INTO l_cnt FROM pia_file
                        WHERE (pia19 != 'Y' OR pia19 IS NULL)
                          AND pia02 is not null
         IF l_cnt > 0 THEN
            CALL cl_err('','mfg0103',2)
            LET g_success = 'N'
            RETURN
         END IF
         SELECT COUNT(*) INTO l_cnt FROM pie_file
                        WHERE (pie16 != 'Y' OR pie16 IS NULL)
                          AND pie02 is not null
         IF l_cnt > 0 THEN
            CALL cl_err('','mfg0104',2)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      CLOSE WINDOW p800_pro_w
   END IF
END FUNCTION
 
FUNCTION p800_udpic()
    DEFINE l_time  LIKE type_file.chr8      #No.FUN-6A0074
    DEFINE l_pic06 LIKE pic_file.pic06      #MOD-A50159 add
    DEFINE l_pic15 LIKE pic_file.pic15      #MOD-A50159 add
    DEFINE l_pic26 LIKE pic_file.pic26      #MOD-A50159 add
    DEFINE l_pic35 LIKE pic_file.pic35      #MOD-A50159 add

    LET l_time = TIME
    LET l_pic06=tm.tag1[1,5]   #MOD-A50159 add
    LET l_pic15=tm.spc1[1,5]   #MOD-A50159 add
    LET l_pic26=tm.tag2[1,5]   #MOD-A50159 add
    LET l_pic35=tm.spc2[1,5]   #MOD-A50159 add
    INSERT INTO pic_file (pic01,pic02,pic03,pic04,pic05,pic06,pic07,  #No.MOD-0470041
                         pic08,pic09,pic10,pic11,pic12,pic13,pic14,
                         pic15,pic16,pic17,pic18,pic19,pic20,pic21,
                         pic22,pic23,pic24,pic25,pic26,pic27,pic28,
                         pic29,pic30,pic31,pic32,pic33,pic34,pic35,
                         pic36,pic37,pic38,pic39,pic40,pic41,pic42,pic43)
    VALUES(g_date,l_time,g_program,g_user,tm.stk,l_pic06,'',   #CHI-960065 tm.seno1-->''  #MOD-A50159 tm.tag1->l_pic06
           tm.noinv1,' ',' ',g_bstk,g_bstk1,g_paper1,tm.spcg1,l_pic15, #CHI-960065 g_estk--g_bstk1 #MOD-A50159 tm.spc1->l_pic15
           '',tm.qty1,g_bspcstk,g_bspcstk1,g_spcstk,tm.order1,  #CHI-960065
           tm.class1,' ',' ',tm.wip,l_pic26,'',' ',' ',' ', #CHI-960065 tm.seno2-->''  #MOD-A50159 tm.tag2->l_pic26
           g_bwip,g_bwip1,g_paper2,tm.spcg2,l_pic35,'',tm.qty2,      #CHI-960065  #MOD-A50159 tm.spc2->l_pic35
           g_bspcwip,g_bspcwip1,g_spcwip,tm.order2,' ',' ') #CHI-960065 espcwip-->bspcwip1
     IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","pic_file",g_date,"",SQLCA.sqlcode,"","insert",1)   #NO.FUN-640266 #No.FUN-660156
         LET g_success = 'N'
         RETURN
     END IF
END FUNCTION
 
FUNCTION p800_stk()
 
    OPEN WINDOW p800_wstk AT 2,2 WITH FORM "aim/42f/aimt8001"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt8001")
 
    CONSTRUCT BY NAME g_wc1 ON ima23,img02,img03,img04,img01,ima06
       BEFORE CONSTRUCT
          DISPLAY g_ima23,g_img02,g_img03,g_img04,g_img01,g_ima06 TO
                    ima23,  img02,  img03,  img04,  img01,  ima06
       AFTER FIELD ima23
          LET g_ima23 = GET_FLDBUF(ima23)
       AFTER FIELD img02
          LET g_img02 = GET_FLDBUF(img02)
       AFTER FIELD img03
          LET g_img03 = GET_FLDBUF(img03)
       AFTER FIELD img04
          LET g_img04 = GET_FLDBUF(img04)
       AFTER FIELD img01
          LET g_img01 = GET_FLDBUF(img01)
       AFTER FIELD ima06
          LET g_ima06 = GET_FLDBUF(ima06)

#TQC-C70126 ---------------Begin--------------
       ON ACTION controlp
          CASE 
             WHEN INFIELD(img01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ima"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO img01
                  NEXT FIELD img01
             WHEN INFIELD(img02)      #倉庫別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_imd"
                  LET g_qryparam.arg1 = 'SW'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO img02
                  NEXT FIELD img02
             WHEN INFIELD(img03)      #儲位
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.arg2 = 'SW'
                  LET g_qryparam.form = "q_ime"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO img03
                  NEXT FIELD img03
             WHEN INFIELD(img04)      #批號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_img"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO img04
                  NEXT FIELD img04
             WHEN INFIELD(ima06) 
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_imz"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima06
                  NEXT FIELD ima06
             WHEN INFIELD(ima23)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state= "c"
                  LET g_qryparam.form = "q_gen"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO ima23
                  NEXT FIELD ima23
             OTHERWISE EXIT CASE
         END CASE
#TQC-C70126 ---------------End----------------

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END CONSTRUCT
    LET g_wc1 = g_wc1 CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
    IF INT_FLAG THEN
        LET INT_FLAG = 0
    END IF
    CLOSE WINDOW p800_wstk
END FUNCTION
 
FUNCTION p800_wip()
    OPEN WINDOW p800_wwip AT 2,2 WITH FORM "aim/42f/aimt8002"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aimt8002")
 
    CONSTRUCT BY NAME g_wc2 ON sfa01,sfb82
       BEFORE CONSTRUCT
          DISPLAY g_sfa01,g_sfb82 TO
                    sfa01,  sfb82
       AFTER FIELD sfa01
          LET g_sfa01 = GET_FLDBUF(sfa01)
       AFTER FIELD sfb82
          LET g_sfb82 = GET_FLDBUF(sfb82)

#TQC-C70126 -------------Begin-------------
       ON ACTION controlp
          CASE
             WHEN INFIELD(sfa01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sfa10"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfa01
                  NEXT FIELD sfa01
             WHEN INFIELD(sfb82)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sfb82"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sfb82
                  NEXT FIELD sfb82
                 OTHERWISE EXIT CASE
             END CASE
#TQC-C70126 -------------End---------------

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
    END CONSTRUCT
    IF INT_FLAG THEN
        LET INT_FLAG = 0
    END IF
    CLOSE WINDOW p800_wwip
END FUNCTION
 
FUNCTION p800_control()
    IF tm.stk='Y' THEN
       CALL cl_set_comp_entry("tag1,noinv1,spcg1,     #CHI-960065 拿掉seno1        
       a1,a2,a3,a4,a5,a6,class1,type",TRUE)                             #FUN-930122 add type #FUN-B70032 add icdcnt #CHI-B90001 del icdcnt 
       #FUN-BA0029 --START mark--
       #CALL cl_set_comp_required("tag1,noinv1,spcg1,                           #CHI-960065 拿掉seno1
       #a1,a2,a3,a4,a5,a6,class1,type",TRUE)                             #FUN-930122 add type #FUN-B70032 add icdcnt #CHI-B90001 del icdcnt
       #FUN-BA0029 --END mark--
       CALL cl_set_comp_required("tag1,noinv1,spcg1,class1,type",TRUE)   #FUN-BA0029                             
    ELSE
       LET tm.noinv1='N'
       LET tm.spcg1='N'
       LET tm.tag1=''
       #LET tm.icdcnt = 'N' #FUN-B70032 #CHI-B90001 mark
       CALL cl_set_comp_entry("tag1,noinv1,spcg1,  #CHI-960065 拿掉seno1          
       a1,a2,a3,a4,a5,a6,class1,type",FALSE)                            #FUN-930122 add type #FUN-B70032 add icdcnt #CHI-B90001 del icdcnt
       #FUN-BA0029 --START mark--
       #CALL cl_set_comp_required("tag1,noinv1,spcg1,                           #CHI-960065 拿掉seno1
       #a1,a2,a3,a4,a5,a6,class1,type",FALSE)                            #FUN-930122 add type #FUN-B70032 add icdcnt #CHI-B90001 del icdcnt
       #FUN-BA0029 --END mark--
       CALL cl_set_comp_required("tag1,noinv1,spcg1,class1,type",FALSE)   #FUN-BA0029 
       DISPLAY BY NAME tm.noinv1,tm.spcg1,tm.tag1                       #CHI-960065 拿掉seno1 #FUN-B70032 add icdcnt #CHI-B90001 del icdcnt
    END IF
 
    IF tm.spcg1='Y' THEN
        CALL cl_set_comp_entry("spc1,qty1",TRUE)       #CHI-960065
        CALL cl_set_comp_required("spc1,qty1",TRUE) #FUN-5B0137
    ELSE
      CALL cl_set_comp_entry("spc1,qty1",FALSE)        #CHI-960065
      CALL cl_set_comp_required("spc1,qty1",FALSE) #FUN-5B0137
      LET tm.spc1=''
      LET tm.qty1=''
      DISPLAY BY NAME tm.spc1,tm.qty1 #CHI-960065 拿掉spno1
    END IF
    IF tm.wip='Y' THEN
        CALL cl_set_comp_entry("tag2,spcg2,              #CHI-960065 拿掉seno2
                                k1,k2,k3,k4,k5,k6",TRUE)
        #FUN-BA0029 --START mark--                                
        #CALL cl_set_comp_required("tag2,spcg2,           #CHI-960065 拿掉seno2   
        #                        k1,k2,k3,k4,k5,k6",TRUE)
        #FUN-BA0029 --END mark--                        
        CALL cl_set_comp_required("tag2,spcg2",TRUE)   #FUN-BA0029 
    ELSE
        LET tm.spcg2='N'
        LET tm.tag2=''
        CALL cl_set_comp_entry("tag2,spcg2,     #CHI-960065 拿掉seno2
                                k1,k2,k3,k4,k5,k6",FALSE)
        #FUN-BA0029 --START mark--                         
        #CALL cl_set_comp_required("tag2,spcg2,  #CHI-960065 拿掉seno2
        #                        k1,k2,k3,k4,k5,k6",FALSE)
        #FUN-BA0029 --END mark--
        CALL cl_set_comp_required("tag2,spcg2",FALSE)   #FUN-BA0029        
        DISPLAY BY NAME tm.spcg2,tm.tag2        #CHI-960065 拿掉seno2
    END IF
    IF tm.spcg2='Y' THEN
      CALL cl_set_comp_entry("spc2,qty2",TRUE)    #CHI-960065 拿掉spno2
      CALL cl_set_comp_required("spc2,qty2",TRUE) #FUN-5B0137
    ELSE
      LET tm.spc2=''
      LET tm.qty2=''
      CALL cl_set_comp_entry("spc2,qty2",FALSE)  #CHI-960065 拿掉spno2
      CALL cl_set_comp_required("spc2,qty2",FALSE) #FUN-5B0137
      DISPLAY BY NAME tm.spc2,tm.qty2    #CHI-960065 拿掉spno2
    END IF
END FUNCTION
 
FUNCTION p800_set_pia930(p_pia02)
DEFINE p_pia02 LIKE pia_file.pia02  #TQC-A10079 
DEFINE l_ima23 LIKE ima_file.ima23
DEFINE l_gen03 LIKE gen_file.gen03
   SELECT gen03 INTO l_gen03 FROM gen_file,ima_file 
                            WHERE ima01=p_pia02
                              AND gen01=ima23
   RETURN s_costcenter(l_gen03)
END FUNCTION
#No.FUN-9C0072 精簡程式碼

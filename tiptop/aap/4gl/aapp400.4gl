# Prog. Version..: '5.30.06-13.04.18(00010)'     #
#
# Descriptions...: AP系統傳票拋轉總帳
# Date & Author..: 97/04/21 By Roger
# Modify.........: No.8657 03/11/05 By Kitty 當aaz85='N'時,aba19為會null
# Modify.........: No.9469 04/04/15 By Kitty 廠商改為用單據上的廠商而不用底稿的
# Modify.........: No.MOD-4A0282 04/10/21 By ching 成本分攤確認碼是aqaconf
# Modify.........: No.MOD-4B0193 04/11/18 By ching INT_FLAG歸0
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.MOD-510051 05/01/10 By Kitty gl_no_b/gl_no_e的欄位變數未清除, 導致連續執行時, 傳票列印錯誤
# Modify ........: No.FUN-560190 05/06/28 By wujie 單據編號修改
# Modify ........: No.FUN-570090 05/07/27 By will 增加取得傳票缺號號碼的功能
# MOdify.........: No.FUN-590005 05/09/08 By Smapmin 單號開窗
# Modify.........: No.TQC-5B0166 05/11/21 By wujie 傳票缺號挑選視窗修改
# Modify.........: No.MOD-5C0079 05/12/14 By Smapmin 總帳傳票單別要可以輸入完整的單號
# Modify.........: No.FUN-5C0015 060102 BY GILL 多 INSERT 異動碼5~10, 關係人
# Modify.........: No.FUN-570112 06/02/23 By yiting 批次背景執行
# Modify.........: No.MOD-640202 06/04/10 By Echo 新增至 aglt110 時須帶申請人預設值,並減何該單別是否需要簽核
# Modify.........: No.MOD-640404 06/04/11 By Smapmin 傳票拋轉時,UPDATE該付款單號之異動記錄的傳票單號與日期
# Modify.........: No.MOD-640509 06/04/19 By Smapmin 放大g_aba01t大小
# Modify.........: No.FUN-650088 06/05/17 By Smapmin 修改開啟的查詢視窗
# Modify.........: No.FUN-660032 06/06/12 By rainy   拋轉摘要預設為"Y"
# Modify.........: No.FUN-660117 06/06/16 By Rainy Char改為 Like
# Modify.........: No.FUN-660122 06/06/27 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660141 06/07/07 By day  帳別權限修改
# Modify.........: No.FUN-670039 06/07/11 By Carrier 帳別擴充為5碼
# Modify.........: No.FUN-680029 06/08/21 By Rayven 新增多帳套功能
# Modify.........: No.FUN-670068 06/08/28 By Rayven 傳票缺號修改
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0055 06/10/25 By douzh l_time轉g_time
# Modify.........: No.MOD-6B0112 06/11/27 By Smapmin 單號開窗有誤
# Modify.........: No.FUN-680059 06/11/28 By Smapmin 總帳傳票日期空白者,依原分錄日期產生
# Modify.........: No.FUN-710014 07/01/15 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-730064 07/03/29 By mike  會計科目加帳套
# Modify.........: No.MOD-730142 07/03/30 By Smapmin modify FUN-680059
# Modify.........: No.MOD-740480 07/04/26 By Smapmin 分錄底稿日期若跨月,當傳票日期的條件為空白時,產生的傳票所屬的會計期別會有問題
# Modify.........: No.MOD-760009 07/06/04 By Smapmin 開窗單別有誤
# Modify.........: No.TQC-750011 07/06/22 By rainy npp_file,npq_file 加 npp00 = npq00
# Modify.........: No.MOD-760129 07/06/28 By Smapmin 拋轉傳票程式應依異動碼做group的動作再放到傳票單身
# Modify.........: No.MOD-770020 07/07/04 By Smapmin 放大l_remark長度
# Modify.........: No.MOD-770101 07/08/07 By Smapmin 需簽核單別不可自動確認
# Modify.........: No.MOD-790046 07/09/12 By Smapmin 請款拋轉傳票時判斷是否有產生請款折讓
# Modify.........: No.MOD-7A0128 07/10/23 By Smapmin 修改錯誤訊息以及錯誤訊息顯示方式
# Modify.........: No.MOD-7B0022 07/11/05 By Smapmin 修改MOD-790046
# Modify.........: No.MOD-7B0087 07/11/09 By Smapmin 連續拋轉時,拋轉後自動確認的功能異常
# Modify.........: No.TQC-7B0086 07/11/15 By xufeng  憑証自動審核時,審核人欄位沒有值
# Modify.........: No.FUN-810069 08/02/26 By lynn 項目預算取消abb15的管控
# Modify.........: No.MOD-820107 08/03/05 By Smapmin EXIT PROGRAM的當下應該要先刪除tmn_file
# Modify.........: No.MOD-830249 08/04/01 By Smapmin 修改transaction架構.
# Modify.........: No.MOD-840107 08/04/14 By Smapmin 檢核傳票編號是否有重複時,參數帶錯
# Modify.........: No.MOD-840389 08/04/25 By Carrier 總帳傳票日期為空白,應按分錄日期不同切成多張傳票
# Modify.........: No.MOD-850303 08/06/02 By Sarah 附予g_flag正確的值
# Modify.........: No.FUN-850140 08/06/09 By Sarah 當多角序號apa99<>null時,增加s_chknpq()功能
# Modify.........: No.FUN-840125 08/06/18 By sherry q_m_aac.4gl傳入參數時，傳入帳轉性質aac03= "0.轉帳轉票"
# Modify.........: No.FUN-840211 08/07/23 By sherry 拋轉的同時要產生總號(aba11)
# Modify.........: No.MOD-920295 09/02/23 By Dido 增加檢核 npq05 為空白問題
# Modify.........: No.MOD-930242 09/03/26 By Sarah aapp400會回寫nmf_file,也皆需同步回寫nmd_file
# Modify.........: No.MOD-930194 09/04/07 By liuxqa 若是背景作業，則應在執行之前先判斷賬款日期是否小于關帳日期，若是則退出。
# Modify.........: No.MOD-940093 09/04/07 By chenl 加強對拋轉的管控，若更新拋轉憑証為0筆，則應報錯。停止更新。
# Modify.........: No.MOD-860206 09/05/26 By wujie  拋轉時備注欄位會有多余的空格
# Modify.........: No.FUN-980001 09/08/04 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980196 09/08/24 By mike 若單別不為3碼,透過aapp400拋轉時,傳票日期空白,會檢核不出傳票日期<關帳日
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980094 09/09/10 By TSD.hoho GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980059 09/09/14 By arman  GP5.2架構,修改SUB相關傳入參數
# Modify.........: No.FUN-990069 09/09/25 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-8A0027 09/09/30 By mike 當gl_summary='Y'時,依照原標准版程式做法->OUTPUT TO REPORT aapp400_rep(),
#                                                 當gl_summary='N'時,則在產生傳票時,相同科目、部門、異動碼...的科目資料不需合并,獨立
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No.FUN-990031 09/10/23 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
# Modify.........: No.TQC-9B0039 09/11/10 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No:MOD-9C0208 09/12/18 by sabrina 輸入使用者範圍預設為0-z 
# Modify.........: No:MOD-9C0299 09/12/21 By baofei abaoriu,abaorig給值
# Modify.........: No:MOD-9C0103 09/12/23 By sabrina 寫入afb_file時，npq05/npq08/npq35若為NULL則給預設值'' 
# Modify.........: No.FUN-9C0077 10/01/04 By baofei 程式精簡
# Modify.........: No:FUN-A10006 10/01/13 By wujie  增加插入npp08的值，对应aba21
# Modify.........: No:FUN-A10089 10/01/19 By wujie  增加显示选取的缺号结果
# Modify.........: NO.FUN-9C0127 10/01/19 BY yiting 傳票項次排序方式改為:分借貸>依帳款單號排序>依分錄底稿項次排序
# Modify.........: NOMOD-A302497 10/03/31 BY wujie  g_flag预设值提前赋值
# Modify.........: NO:MOD-A50100 10/05/17 BY Dido REPORT FUNCTION 取消 EXTERNAL 
# Modify.........: No.FUN-A50102 10/06/01 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.MOD-A80017 10/08/03 BY xiaofeizhu 附件張數匯總
# Modify.........: NO:MOD-A80059 10/05/17 BY Dido 排序調整 
# Modify.........: NO:MOD-A80107 10/08/13 BY Dido 調整開窗對應檔 
# Modify.........: NO.TQC-AB0347 10/12/03 By chenying 拋轉時考慮科目控管
# Modify.........: NO.CHI-AC0010 10/12/16 By sabrina 調整temptable名稱，改成agl_tmp_file
# Modify.........: NO.TQC-AC0285 10/12/18 By lixia 會科檢查方式修改
# Modify.........: No:MOD-B10041 11/01/06 By Dido 調整背景接收參數位置 
# Modify.........: No:MOD-B10214 11/01/26 By Dido 增加系統條件與訊息提示調整
# Modify.........: No:TQC-B30084 11/03/07 By yinhy 已經審核的借支單拋轉憑證后系統報錯無符合條件的資料
# Modify.........: No:FUN-B30211 11/03/30 By yangtingting 未加離開前的 cl_used(2)
# Modify.........: No:TQC-B60175 11/06/21 By zhangweib 抓npq03時加入npqtype = l_npptype條件
# Modify.........: No:TQC-B70021 11/07/12 By wujie 抛转时自动产生tic资料 
# Modify.........: No:MOD-B80305 11/08/26 By yinhy 拋轉時附件張數錯誤
# Modify.........: No:MOD-BB0078 11/11/07 By Polly 調整拋轉傳票時，會科合併ORDER BY取消 npp01
# Modify.........: No:TQC-C30323 12/03/29 By zhangll 修正報錯但提示運行成功的問題
# Modify.........: No:MOD-C50093 12/05/17 By Polly 如為背景呼叫aapp400，所產生的傳票編號改用匯總方式呈現
# Modify.........: No:MOD-C70047 12/07/09 By Polly 增加"依會計科目彙總"判調整ON EVERY ROW或AFTER GROUP
# Modify.........: No:FUN-C70093 12/07/23 By minpp 成本分摊抛转时，若aqa00='2'，抛转完成后回写ccbglno
# Modify.........: No:TQC-C70193 12/07/27 By lujh 依會計科目匯總勾選時,aglt110里沒有匯總
# Modify.........: No:MOD-C80058 12/08/09 By Polly 台灣版依所勾選的匯總方式來做排序，如依單據編號匯總時仍需先以單據編號，而不是依科目優先
# Modify.........: No:TQC-C80086 12/08/14 By lujh 將程式中MOD-B80305修改的部分進行調整，不可以放在order by 中,在程式中進行調整
# Modify.........: No:MOD-C80106 12/08/14 By Polly 調整累加值變數預設，已正確的補到缺號。
# Modify.........: No:MOD-CA0080 12/10/12 By Polly q_apa7開窗增加條件判斷
# Modify.........: No:CHI-CB0004 12/11/09 By Belle 修改總號計算方式
# Modify.........: No:MOD-CB0026 12/12/21 By yinhy 背景作業拋轉憑證時先檢查營運中心是否在當前法人下
# Modify.........: No:MOD-CC0074 12/12/21 By yinhy 默認g_j初始值為0
# Modify.........: No.CHI-C80041 12/12/22 By bart 排除作廢
# Modify.........: No:MOD-CB0134 12/11/16 By Polly q_apa7開窗調整條件判斷
# Modify.........: No.FUN-CB0096 13/01/10 by zhangweib 增加log檔記錄程序運行過程
# Modify.........: No:MOD-C90027 13/04/08 By apo 改用期別概念抓取 s_yp 函式 
# Modify.........: No.MOD-D40121 13/04/18 By Polly 增加紀錄原始應付單別長度
# Modify.........: No.yinhy131115 13/11/15 By yinhy 用戶預設10個z

IMPORT os   #No.FUN-9C0009  add by dxfwo
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_aba            RECORD LIKE aba_file.*
DEFINE g_aac            RECORD LIKE aac_file.*
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
DEFINE g_dbs_gl         LIKE type_file.chr21  # No.FUN-690028 VARCHAR(21)
DEFINE g_plant_gl       LIKE type_file.chr21  # No.FUN-690028 VARCHAR(21)#No.FUN-980059
DEFINE gl_no		LIKE aba_file.aba01 # 傳票單號     #No.FUN-560190 #FUN-660117
DEFINE gl_no1           LIKE aba_file.aba01                #No.FUN-680029
DEFINE gl_no_b          LIKE aba_file.aba01,                                      #FUN-660117
        gl_no_e	        LIKE aba_file.aba01# Generated 傳票單號  #No.FUN-560190   #FUN-660117
DEFINE gl_no_b1,gl_no_e1 LIKE aba_file.aba01    #No.FUN-680029
DEFINE p_plant          LIKE apz_file.apz02p 	#FUN-660117
DEFINE l_plant_old      LIKE apz_file.apz02p    #FUN-660117
DEFINE p_bookno         LIKE apz_file.apz02b	#FUN-660117
DEFINE p_bookno1        LIKE apz_file.apz02c    #No.FUN-680029
DEFINE gl_date		LIKE type_file.dat     #No.FUN-690028 DATE
DEFINE gl_tran		LIKE type_file.chr1    # No.FUN-690028 VARCHAR(1)
DEFINE gl_summary       LIKE type_file.chr1    #FUN-8A0027
DEFINE g_t1		LIKE oay_file.oayslip        #NO:6842  #No.FUN-560190  #No.FUN-690028 VARCHAR(05)
DEFINE gl_seq           LIKE type_file.chr1    # No.FUN-690028 VARCHAR(1)         # 傳票區分項目
DEFINE b_user           LIKE aba_file.abauser,  #FUN-660117
       e_user	        LIKE aba_file.abauser   #FUN-660117
DEFINE g_yy,g_mm	LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE g_aba01t         LIKE aac_file.aac01     #FUN-660117
DEFINE g_system         LIKE aba_file.aba06     #FUN-660117
DEFINE g_zero           LIKE type_file.num20_6  # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_zero1          LIKE type_file.chr1     # No.FUN-690028 VARCHAR(1)          #No:8657
DEFINE g_N              LIKE type_file.chr1     # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1     # No.FUN-690028 VARCHAR(1)
DEFINE g_aaz85          LIKE aaz_file.aaz85 #傳票是否自動確認 no.3432
DEFINE g_change_lang    LIKE type_file.chr1          #是否有做語言切換 No.FUN-570112  #No.FUN-690028 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10      #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_j             SMALLINT   #No.FUN-570090  --add
DEFINE   g_flag          LIKE type_file.chr1   #MOD-730142   畫面上日期為空否
#No.FUN-CB0096 ---start--- Add
DEFINE g_id     LIKE azu_file.azu00
DEFINE l_id     STRING
DEFINE l_time   LIKE type_file.chr8
DEFINE t_no     LIKE aba_file.aba01
#No.FUN-CB0096 ---end  --- Add
DEFINE g_len           LIKE type_file.num5       #MOD-D40121 add 

MAIN
DEFINE l_flag          LIKE type_file.chr1       #->No.FUN-570112  #No.FUN-690028 VARCHAR(1)
DEFINE ls_date         STRING       #->No.FUN-570112

     OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET b_user   = ARG_VAL(2)             #資料來源營運中心
   LET e_user   = ARG_VAL(3)             #資料來源
   LET p_plant  = ARG_VAL(4)             #總帳營運中心編號
   LET p_bookno = ARG_VAL(5)             #總帳帳別編號
   LET gl_no    = ARG_VAL(6)             #總帳傳票單別
   LET ls_date  = ARG_VAL(7)
   LET gl_date  = cl_batch_bg_date_convert(ls_date)   #總帳傳票日期
   LET gl_tran  = ARG_VAL(8)             #拋轉摘要
   LET gl_seq   = ARG_VAL(9)             #傳票匯總方式
   LET g_bgjob = ARG_VAL(10)    #背景作業
   LET p_bookno1 = ARG_VAL(11)  #No.FUN-680029
   LET gl_no1    = ARG_VAL(12)  #No.FUN-680029
   LET gl_summary = ARG_VAL(13)           #MOD-B10041
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("AAP")) THEN
      EXIT PROGRAM
   END IF

   #No.FUN-CB0096 ---start--- Add
    LET l_time = TIME
    LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
    LET l_id = g_plant CLIPPED , g_prog CLIPPED , '100' , g_user CLIPPED , g_today USING 'YYYYMMDD' , l_time
    LET g_sql = "SELECT azu00 + 1 FROM azu_file ",
                " WHERE azu00 LIKE '",l_id,"%' "
    PREPARE aglt110_sel_azu FROM g_sql
    EXECUTE aglt110_sel_azu INTO g_id
    IF cl_null(g_id) THEN
       LET g_id = l_id,'000000'
    ELSE
       LET g_id = g_id + 1
    END IF
    CALL s_log_data('I','100',g_id,'1',l_time,'','')
   #No.FUN-CB0096 ---end  --- Add

   DROP TABLE agl_tmp_file

   CREATE TEMP TABLE agl_tmp_file(
    tc_tmp00     LIKE type_file.chr1 NOT NULL,
    tc_tmp01     LIKE type_file.num5,
    tc_tmp02     LIKE type_file.chr20,
    tc_tmp03     LIKE apz_file.apz02b)

   IF STATUS THEN CALL cl_err('create tmp',STATUS,0) EXIT PROGRAM END IF
   CREATE UNIQUE INDEX tc_tmp_01 on agl_tmp_file (tc_tmp02,tc_tmp03)  #No.FUN-680029  add tc_tmp03 ---end---
   IF STATUS THEN
      CALL cl_err('create index',STATUS,0)
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      EXIT PROGRAM
   END IF

   CALL  cl_used(g_prog,g_time,1) RETURNING g_time

   DECLARE tmn_del CURSOR FOR
       SELECT tc_tmp02,tc_tmp03 FROM agl_tmp_file WHERE tc_tmp00 = 'Y'
   LET g_len = g_doc_len                                                    #MOD-D40121 add
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p400_ask()               # Ask for first_flag, data range or exist
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            CALL p400_create_tmp()
            LET g_apz.apz02b = p_bookno  # 得帳別
            LET g_apz.apz02c = p_bookno1 #No.FUN-680029
            LET g_j = 0     #MOD-CC0074
            BEGIN WORK
            CALL p400_t('0')  #No.FUN-680029 add '0'
            CALL s_showmsg()  #No.FUN-710014
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL p400_t('1')
               CALL s_showmsg()        #No.FUN-710014
            END IF
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_m_prtgl(g_plant_gl,g_apz.apz02b,gl_no_b,gl_no_e)   #FUN-990069
               IF g_aza.aza63 = 'Y' THEN
                  CALL s_m_prtgl(g_plant_gl,g_apz.apz02c,gl_no_b1,gl_no_e1)  #FUN-990069
               END IF
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p400
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p400_create_tmp()
         LET g_apz.apz02b = p_bookno     # 得帳別
         LET g_apz.apz02c = p_bookno1    #No.FUN-680029
         LET g_plant_new= p_plant        # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new CLIPPED  # 得資料庫名稱
         SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
         #No.MOD-CB0026  --Begin
         SELECT * FROM azw_file WHERE azw01 = p_plant
            AND azw02 = g_legal
         IF STATUS <> 0 THEN
            LET g_success = 'N'
            CALL cl_err('sel_azw','agl-171',1)
            RETURN
         END IF
         #No.MOD-CB0026  --End
         BEGIN WORK
         CALL p400_t('0')  #No.FUN-680029 add '0'
         CALL s_showmsg()           #No.FUN-710014
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL p400_t('1')
            CALL s_showmsg()        #No.FUN-710014
         END IF
         IF g_success = "Y" THEN
            COMMIT WORK
            IF g_bgjob = 'N' THEN                                           #MOD-C50093 add
               CALL s_m_prtgl(g_plant_gl,g_apz.apz02b,gl_no_b,gl_no_e)    #FUN-990069
               CALL s_showmsg()        #No.FUN-710014
               IF g_aza.aza63 = 'Y' THEN
                  CALL s_m_prtgl(g_plant_gl,g_apz.apz02c,gl_no_b1,gl_no_e1) #FUN-990069
                  CALL s_showmsg()        #No.FUN-710014
               END IF
            END IF                                                          #MOD-C50093 add
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL p400_tmn_del()
  #No.FUN-CB0096 ---start--- add
   LET l_time = TIME
   LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
   CALL s_log_data('U','100',g_id,'1',l_time,'','')
  #No.FUN-CB0096 ---end  --- add

   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN



FUNCTION p400_ask()
   DEFINE l_chk_bookno  SMALLINT   #No.FUN-660141
   DEFINE l_chk_bookno1 SMALLINT   #No.FUN-680029
   DEFINE li_result   LIKE type_file.num5          #No.FUN-560190  #No.FUN-690028 SMALLINT
   DEFINE   l_aaa07   LIKE aaa_file.aaa07
   DEFINE   l_flag    LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE   l_cnt     LIKE type_file.num5    #No.FUN-570090  -add   #No.FUN-690028 SMALLINT
   DEFINE   l_npp00   LIKE type_file.chr1    # No.FUN-690028 VARCHAR(1)   #FUN-590005
   DEFINE   lc_cmd    LIKE type_file.chr1000,# No.FUN-690028 VARCHAR(500),        #No.FUN-570112
            l_sql     STRING  #FUN-660141
   DEFINE  l_aac03    LIKE aac_file.aac03          #No.FUN-840125
   DEFINE  l_aac03_1  LIKE aac_file.aac03          #No.FUN-840125
   DEFINE  l_no       LIKE type_file.chr3          #No.FUN-840125
   DEFINE  l_no1      LIKE type_file.chr3          #No.FUN-840125
#No.FUN-A10089 --begin
   DEFINE   l_chr1         LIKE type_file.chr20
   DEFINE   l_chr2         STRING
#No.FUN-A10089 --end

   OPEN WINDOW p400 WITH FORM "aap/42f/aapp400"
        ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()

   CALL cl_opmsg('z')

   IF g_aza.aza63 = 'N' THEN
      CALL cl_set_comp_visible("p_bookno1,gl_no1",FALSE)
   END IF

WHILE TRUE
#No.FUN-A10089 --begin
   LET l_chr2 =' '  
   DISPLAY ' ' TO chr2   
#No.FUN-A10089 --end

   CONSTRUCT BY NAME g_wc ON npp00,npp01,npp011,npp02

      AFTER FIELD npp00
           CALL FGL_DIALOG_GETBUFFER() RETURNING l_npp00

         BEFORE CONSTRUCT
             CALL cl_qbe_init()

        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(npp01) #查詢單號
                  IF l_npp00 IS NULL THEN NEXT FIELD npp00 END IF
                  IF l_npp00 = '1' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.state = "c"
                     LET g_qryparam.arg1 = g_doc_len   #MOD-6B0112
                    #LET g_qryparam.form ="q_apa6"                          #MOD-A80107 mark
                     LET g_qryparam.form ="q_apa7"                          #MOD-A80107
                    #LET g_qryparam.where = " apa00 NOT LIKE '2%' "          #MOD-CA0080 add #MOD-CB0134 mark
                     LET g_qryparam.where = " apa00 NOT IN ('23','24') "     #MOD-CB0134 add
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO npp01
                     NEXT FIELD npp01
                  END IF
                 IF l_npp00 = '3' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = g_doc_len   #MOD-760009
                    LET g_qryparam.form ="q_apf2"   #FUN-650088
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO npp01
                    NEXT FIELD npp01
                 END IF
                 IF l_npp00 = '4' THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = g_doc_len   #MOD-760009
                    LET g_qryparam.form ="q_aqa"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO npp01
                    NEXT FIELD npp01
                 END IF
            END CASE

     ON ACTION locale
        LET g_change_lang = TRUE       #->No.FUN-570112
        EXIT CONSTRUCT

      ON ACTION cancel  #MOD-4B0193
        LET INT_FLAG = 1
        EXIT CONSTRUCT

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

   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030


   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CALL p400_tmn_del()   #MOD-820107
      CLOSE WINDOW p400
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM
   END IF

   LET p_plant = g_apz.apz02p
   LET l_plant_old = p_plant      #No.FUN-570090  --add
   LET p_bookno   = g_apz.apz02b
   LET p_bookno1  = g_apz.apz02c
   LET gl_no_b1 = ''
   LET gl_no_e1 = ''
   LET b_user  = '0'  #MOD-9C0208 g_user modify 0 
   #LET e_user  = 'z'  #MOD-9C0208 g_user modify z
   LET e_user  = 'zzzzzzzzzz'   #yinhy131115 
   LET gl_date = g_today
   SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
   LET gl_tran = 'Y'   #FUN-660032
   LET gl_summary = 'Y' #FUN-8A0027
   LET gl_seq  = '0'
   LET g_bgjob = "N"
   INPUT BY NAME b_user,e_user,p_plant,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,gl_tran,gl_summary,gl_seq,g_bgjob #NO.FUN-570112 #No.FUN-680029 add p_bookno1,gl_no1 #FUN-8A0027 add gl_summary
      WITHOUT DEFAULTS ATTRIBUTE(UNBUFFERED)   #No.FUN-570090  --add UNBUFFERED

      AFTER FIELD p_plant
         SELECT * FROM azw_file WHERE azw01 = p_plant
            AND azw02 = g_legal
         IF STATUS <> 0 THEN
            CALL cl_err('sel_azw','agl-171',0)   #FUN-990031
            NEXT FIELD p_plant
         END IF
        # 得出總帳 database name
         LET g_plant_new= p_plant        # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new CLIPPED  # 得資料庫名稱

         IF l_plant_old != p_plant THEN

         CALL p400_tmn_del()

            DELETE FROM agl_tmp_file
            LET l_plant_old = g_plant_new
         END IF

      AFTER FIELD p_bookno
         IF p_bookno IS NOT NULL THEN
             CALL s_check_bookno(p_bookno,g_user,p_plant)
                  RETURNING l_chk_bookno
             IF (NOT l_chk_bookno) THEN
                NEXT FIELD p_bookno
             END IF
             IF p_bookno1 = p_bookno THEN
                CALL cl_err('','aap-987',1)
                NEXT FIELD p_bookno
             END IF
            #LET g_plant_new= p_plant  # 工廠編號   #FUN-A50102
            #CALL s_getdbs()                        #FUN-A50102
             LET l_sql = "SELECT COUNT(*) ",
                        #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",   #FUN-A50102
                         "  FROM ",cl_get_target_table(p_plant,'aaa_file'),   #FUN-A50102
                         " WHERE aaa01 = '",p_bookno,"' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A50102
             PREPARE a400_pre2 FROM l_sql
             DECLARE a400_cur2 CURSOR FOR a400_pre2
             OPEN a400_cur2
             FETCH a400_cur2 INTO g_cnt
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno
            END IF
         END IF

      AFTER FIELD e_user
         IF e_user IS NOT NULL THEN
            IF e_user = 'Z' THEN
               LET e_user='z'
               DISPLAY BY NAME e_user
            END IF
         END IF

      AFTER FIELD gl_no
        CALL s_check_no("agl",gl_no,"","1","aba_file","aba01",p_plant)
              RETURNING li_result,gl_no
        IF (NOT li_result) THEN
           NEXT FIELD gl_no
        END IF
        LET l_no = gl_no
        SELECT aac03 INTO l_aac03 FROM aac_file WHERE aac01= l_no
        IF l_aac03 != '0' THEN
           CALL cl_err(gl_no,'agl-991',0)
           NEXT FIELD gl_no
        END IF
        LET g_flag ='N'    #No.MOD-A30249

      AFTER FIELD p_bookno1
         IF p_bookno1 IS NOT NULL THEN
            CALL s_check_bookno(p_bookno1,g_user,p_plant)
                 RETURNING l_chk_bookno1
            IF (NOT l_chk_bookno1) THEN
               NEXT FIELD p_bookno1
            END IF
            IF p_bookno1 = p_bookno THEN
               CALL cl_err('','aap-987',1)
               NEXT FIELD p_bookno1
            END IF
           #LET g_plant_new= p_plant  # 工廠編號   #FUN-A50102
           #CALL s_getdbs()                        #FUN-A50102
            LET l_sql = "SELECT COUNT(*) ",
                       #"  FROM ",g_dbs_new CLIPPED,"aaa_file ",   #FUN-A50102
                        "  FROM ",cl_get_target_table(p_plant,'aaa_file'),#FUN-A50102
                        " WHERE aaa01 = '",p_bookno1,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,p_plant)   RETURNING l_sql   #FUN-A50102
            PREPARE a400_pre3 FROM l_sql
            DECLARE a400_cur3 CURSOR FOR a400_pre3
            OPEN a400_cur3
            FETCH a400_cur3 INTO g_cnt
            IF g_cnt=0 THEN
               CALL cl_err('sel aaa',100,0)
               NEXT FIELD p_bookno1
            END IF
         END IF

      AFTER FIELD gl_no1
 
         CALL s_check_no("agl",gl_no1,"","1","aba_file","aba01",p_plant)
              RETURNING li_result,gl_no1
         IF (NOT li_result) THEN
            NEXT FIELD gl_no1
         END IF
         LET l_no1 = gl_no1
         SELECT aac03 INTO l_aac03_1 FROM aac_file WHERE aac01= l_no1
         IF l_aac03_1 != '0' THEN
            CALL cl_err(gl_no1,'agl-991',0)
            NEXT FIELD gl_no1
         END IF

      AFTER FIELD gl_date
         IF gl_date IS NOT NULL THEN
            LET g_flag = 'N'   #MOD-850303 add
            SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01 = p_bookno
            IF gl_date <= l_aaa07 THEN
               CALL cl_err('','axm-164',0)
               NEXT FIELD gl_date
            END IF
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
            IF STATUS THEN
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn",0)   #No.FUN-660122
               NEXT FIELD gl_date
            END IF
         ELSE
            CALL chk_date()
            IF g_success = 'N' THEN
               LET g_flag = 'N'   #MOD-850303 add
               NEXT FIELD gl_date
            ELSE   #MOD-730142
               LET g_flag = 'Y'   #MOD-730142
            END IF
         END IF

      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(p_plant)    THEN
            LET l_flag='Y'
         END IF
         IF cl_null(p_bookno)   THEN
            LET l_flag='Y'
         END IF
         IF gl_no[1,g_doc_len] IS NULL or gl_no[1,g_doc_len] = ' ' THEN  #FUN-560190
            LET l_flag='Y'
         END IF

         IF cl_null(gl_date) THEN
            LET g_flag='Y'
         END IF
         IF cl_null(gl_tran)    THEN
            LET l_flag='Y'
         END IF
         IF cl_null(gl_summary) THEN  #FUN-8A0027
            LET l_flag='Y'            #FUN-8A0027
         END IF                       #FUN-8A0027
         IF cl_null(gl_seq)     THEN
            LET l_flag='Y'
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD p_plant
         END IF
        # 得出總帳 database name
         LET g_plant_new= p_plant  # 工廠編號
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new CLIPPED
         IF NOT cl_null(gl_date) THEN   #FUN-680059
            SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01 = gl_date
            IF STATUS THEN
               CALL cl_err3("sel","azn_file",gl_date,"",SQLCA.sqlcode,"","read azn",0)   #No.FUN-660122
               NEXT FIELD gl_date
            END IF
         END IF   #FUN-680059

      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()

         ON ACTION CONTROLP
            IF INFIELD(gl_no) THEN
         CALL s_getdbs()
         LET g_dbs_gl=g_dbs_new CLIPPED
         LET g_plant_gl = p_plant CLIPPED   #No.FUN-980059
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no,'1','0',' ','AGL')  #No.FUN-840125  #No.FUN-980059
                          RETURNING gl_no  #NO:6842
               DISPLAY BY NAME gl_no
               NEXT FIELD gl_no
            END IF
            IF INFIELD(gl_no1) THEN
               CALL s_getdbs()
               LET g_dbs_gl=g_dbs_new CLIPPED
               CALL q_m_aac(FALSE,TRUE,g_plant_gl,gl_no1,'1','0',' ','AGL')   #No.FUN-840125 #No.FUN-980059
                          RETURNING gl_no1
               DISPLAY BY NAME gl_no1
               NEXT FIELD gl_no1
            END IF
      ON ACTION locale
         LET g_change_lang = TRUE        #->No.FUN-570112
         EXIT INPUT

      ON ACTION get_missing_voucher_no
         IF cl_null(gl_no) AND cl_null(gl_no1) THEN  #No.FUN-670068 add AND cl_null(gl_no1)
            NEXT FIELD gl_no
         END IF
         IF cl_null(gl_date) THEN
            NEXT FIELD gl_date
         END IF

         CALL p400_tmn_del()
 

         DELETE FROM agl_tmp_file


         CALL s_agl_missingno(p_plant,g_dbs_gl,p_bookno,gl_no,p_bookno1,gl_no1,gl_date,0) #No.FUN-670068

         SELECT COUNT(*) INTO l_cnt FROM agl_tmp_file
          WHERE tc_tmp00='Y'
         IF l_cnt > 0 THEN
            CALL cl_err(l_cnt,'aap-501',0)
#No.FUN-A10089 --begin
            LET l_sql = " SELECT tc_tmp02 FROM agl_tmp_file ",
                        "  WHERE tc_tmp00 ='Y'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            PREPARE sel_tmp_pre   FROM l_sql
            DECLARE sel_tmp  CURSOR FOR sel_tmp_pre
            LET l_chr2 =' '  
            FOREACH sel_tmp INTO l_chr1
              IF cl_null(l_chr2) THEN
                 LET l_chr2 =l_chr1
              ELSE
                 LET l_chr2 =l_chr2 CLIPPED,'|',l_chr1
              END IF
            END FOREACH
            DISPLAY l_chr2 TO chr2
#No.FUN-A10089 --end
         ELSE
            CALL cl_err('','aap-502',0)
         END IF

       ON ACTION cancel #MOD-4B0193
         LET INT_FLAG = 1
         EXIT INPUT

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121

      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121


         ON ACTION qbe_save
            CALL cl_qbe_save()

   END INPUT

   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CALL p400_tmn_del()   #MOD-820107
      CLOSE WINDOW p400
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "aapp400"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('aapp400','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",b_user CLIPPED,"'",
                      " '",e_user CLIPPED,"'",
                      " '",p_plant CLIPPED,"'",
                      " '",p_bookno CLIPPED,"'",
                      " '",gl_no CLIPPED,"'",
                      " '",gl_date CLIPPED,"'",
                      " '",gl_tran CLIPPED,"'",
                     #" '",gl_summary CLIPPED,"'", #FUN-8A0027   #MOD-B10041 mark
                      " '",gl_seq CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'",
                      " '",p_bookno1 CLIPPED,"'",                #MOD-B10041
                      " '",gl_no1 CLIPPED,"'",                   #MOD-B10041
                      " '",gl_summary CLIPPED,"'"                #MOD-B10041
         CALL cl_cmdat('aapp400',g_time,lc_cmd CLIPPED)
      END IF
      CALL p400_tmn_del()   #MOD-820107
      CLOSE WINDOW p400
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION

FUNCTION p400_t(l_npptype)  #No.FUN-680029 add l_npptype
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_dorder      LIKE npp_file.npp02    #No.MOD-840389
   DEFINE l_order2      LIKE npq_file.npq02    #FUN-8A0027 add
   DEFINE l_order       LIKE npp_file.npp01    # No.FUN-690028 VARCHAR(30)
   DEFINE l_remark      LIKE type_file.chr1000   #MOD-770020
   DEFINE l_name	LIKE type_file.chr20   #No.FUN-690028 VARCHAR(20)
   DEFINE l_cmd         LIKE type_file.chr1000  #No.+366 010705 by plum  #No.FUN-690028 VARCHAR(30)
   DEFINE l_vender      LIKE apa_file.apa05           #No:9469
   DEFINE ap_date	LIKE type_file.dat     #No.FUN-690028 DATE
   DEFINE ap_glno	LIKE apa_file.apa44           #FUN-660117
   DEFINE ap_conf	LIKE apa_file.apa41           #FUN-660117
   DEFINE ap_user	LIKE apa_file.apauser         #FUN-660117
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_yy,l_mm     LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_msg         LIKE ze_file.ze03      # No.FUN-690028 VARCHAR(80)
   DEFINE l_npptype     LIKE npp_file.npptype         #No.FUN-680029
   DEFINE g_cnt1        LIKE type_file.num10       #No.FUN-680029  #No.FUN-690028 INTEGER
   DEFINE l_apa00       LIKE apa_file.apa00   #MOD-790046
   DEFINE l_apa01       LIKE apa_file.apa01   #MOD-790046
   DEFINE l_apa56       LIKE apa_file.apa56   #MOD-790046
   DEFINE l_apa33       LIKE apa_file.apa33   #MOD-790046
   DEFINE l_apa99       LIKE apa_file.apa99   #FUN-850140 add
   DEFINE l_cnt         LIKE type_file.num5   #MOD-7A0128
   DEFINE l_aba11       LIKE aba_file.aba11   #FUN-840211
   DEFINE l_aaa07       LIKE aaa_file.aaa07   #No.MOD-930194 add
   DEFINE l_npp02b      LIKE npp_file.npp02   #CHI-9A0021 add
   DEFINE l_npp02e      LIKE npp_file.npp02   #CHI-9A0021 add
   DEFINE l_correct     LIKE type_file.chr1   #CHI-9A0021 add
   DEFINE l_n           LIKE type_file.num5   #TQC-AB0347
   DEFINE l_npq03       LIKE npq_file.npq03   #TQC-AB0347
   DEFINE l_npp01       LIKE npp_file.npp01   #MOD-B80305

   DEFINE l_yy1         LIKE type_file.num5    #CHI-CB0004
   DEFINE l_mm1         LIKE type_file.num5    #CHI-CB0004 
   DEFINE l_year        LIKE type_file.num5   #MOD-C90027
   DEFINE l_month       LIKE type_file.num5   #MOD-C90027


   LET g_doc_len = g_len      #MOD-D40121 add
   DELETE FROM p400_tmp;
   IF l_npptype = '0' THEN    #No.FUN-680029
      LET gl_no_b=''
      LET gl_no_e=''
   ELSE
      LET gl_no_b1=''
      LET gl_no_e1=''
   END IF

   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
        #LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",   #FUN-A50102
         LET g_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(p_plant,'aznn_file'),   #FUN-A50102
                     "  WHERE aznn01 = '",gl_date,"'",
                     "    AND aznn00 = '",p_bookno,"'"
      ELSE
        #LET g_sql = " SELECT aznn02,aznn04 FROM ",g_dbs_gl,"aznn_file",   #FUN-A50102
         LET g_sql = " SELECT aznn02,aznn04 FROM ",cl_get_target_table(p_plant,'aznn_file'),   #FUN-A50102
                     "  WHERE aznn01 = '",gl_date,"'",
                     "    AND aznn00 = '",p_bookno1,"'"
      END IF
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p400_p1 FROM g_sql
      DECLARE p400_c1 CURSOR FOR p400_p1
      OPEN p400_c1
      FETCH p400_c1 INTO g_yy,g_mm
   ELSE
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
       WHERE azn01 = gl_date
   END IF

  #check 所選的資料中其分錄日期不可和總帳傳票日期有不同年月
   IF NOT cl_null(gl_date) THEN   #FUN-680059
     #判斷是否小于關帳日期
      IF l_npptype = '0' THEN
         SELECT aaa07 INTO l_aaa07 FROM aaa_file
                WHERE aaa01 = p_bookno
      ELSE
         SELECT aaa07 INTO l_aaa07 FROM aaa_file
                WHERE aaa01 = p_bookno1
      END IF
      IF gl_date <= l_aaa07 THEN
         IF g_bgjob = 'Y' THEN
            CALL s_errmsg('','','','axr-164',1)
         ELSE
            CALL cl_err('','axr-164',0)
         END IF
         LET g_success = 'N'
         RETURN
      END IF

      LET l_year = NULL      #MOD-C90027
      LET l_month = NULL     #MOD-C90027
     #當月起始日與截止日
      CALL s_yp(gl_date) RETURNING l_year,l_month                                    #MOD-C90027
     #CALL s_azm(YEAR(gl_date),MONTH(gl_date)) RETURNING l_correct,l_npp02b,l_npp02e   #CHI-9A0021 add #MOD-C90027
      CALL s_azm(l_year,l_month) RETURNING l_correct,l_npp02b,l_npp02e               #MOD-C90027 

      LET g_sql="SELECT UNIQUE YEAR(npp02),MONTH(npp02) ",
                "  FROM npp_file,apy_file",
                " WHERE nppsys= 'AP' AND nppglno IS NULL",
                "   AND npp02 NOT BETWEEN '",l_npp02b,"' AND '",l_npp02e,"'",
                "   AND npptype = '",l_npptype,"'",  #No.FUN-680029
                "   AND ",g_wc CLIPPED,
                "   AND npp01 like ltrim(rtrim(apyslip)) || '-%' AND apydmy3='Y'"  #FUN-560190
      PREPARE p400_0_p0 FROM g_sql
      IF STATUS THEN
         CALL cl_err('p400_0_p0',STATUS,1)
         LET g_success = 'N'  #TQC-C30323 add
         RETURN
      END IF
      DECLARE p400_0_c0 CURSOR WITH HOLD FOR p400_0_p0
      LET l_flag='N'
      FOREACH p400_0_c0 INTO l_yy,l_mm
         LET l_flag='Y'
         EXIT FOREACH
      END FOREACH
      IF l_flag ='Y' THEN
         CALL cl_err('err:','axr-061',1)
         LET g_success = 'N'  #TQC-C30323 add
         RETURN
      END IF
   END IF   #FUN-680059
  IF g_aaz.aaz81 = 'Y' THEN
     LET l_yy1 = YEAR(gl_date)    #CHI-CB0004
     LET l_mm1 = MONTH(gl_date)   #CHI-CB0004
     IF g_aza.aza63 = 'Y' THEN
        IF l_npptype = '0' THEN
          #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",   #FUN-A50102
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
                       " WHERE aba00 =  '",p_bookno,"'"
                      ,"   AND aba19 <> 'X' " #CHI-C80041
                      ,"   AND YEAR(aba02) =" ,l_yy1," AND MONTH(aba02) =", l_mm1  #CHI-CB0004
        ELSE
          #LET g_sql = "SELECT MAX(aba11)+1 FROM ",g_dbs_gl,"aba_file",  #FUN-A50102
           LET g_sql = "SELECT MAX(aba11)+1 FROM ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102
                       " WHERE aba00 =  '",p_bookno1,"'"
                      ,"   AND aba19 <> 'X' " #CHI-C80041
                      ,"   AND YEAR(aba02) =" ,l_yy1," AND MONTH(aba02) =", l_mm1  #CHI-CB0004
        END IF

 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
        PREPARE aba11_pre FROM g_sql
        EXECUTE aba11_pre INTO l_aba11
     ELSE
       SELECT MAX(aba11)+1 INTO l_aba11 FROM aba_file
         WHERE aba00 = p_bookno
           AND YEAR(aba02) = l_yy1 AND MONTH(aba02) = l_mm1  #CHI-CB0004
           AND aba19 <> 'X'  #CHI-C80041
     END IF
    #CHI-CB0004--(B)
     IF cl_null(l_aba11) OR l_aba11 = 1 THEN
        LET l_aba11 = l_yy1*1000000+l_mm1*10000+1
     END IF
    #CHI-CB0004--(E)
    #IF cl_null(l_aba11) THEN LET l_aba11 = 1 END IF  #CHI-CB0004
     LET g_aba.aba11 = l_aba11
  ELSE
     LET g_aba.aba11 = ' '

  END IF


   #no.3432 (是否自動傳票確認)
  #LET g_sql = "SELECT aaz85 FROM ",g_dbs_gl CLIPPED,"aaz_file",  #FUN-A50102 
   LET g_sql = "SELECT aaz85 FROM ",cl_get_target_table(p_plant,'aaz_file'),   #FUN-A50102
               " WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102
   PREPARE aaz85_pre FROM g_sql
   DECLARE aaz85_cs CURSOR FOR aaz85_pre
   OPEN aaz85_cs
   FETCH aaz85_cs INTO g_aaz85
   IF STATUS THEN
      CALL cl_err('sel aaz85',STATUS,1)
      LET g_success = 'N'  #TQC-C30323 add
      RETURN
   END IF

   LET g_sql="SELECT npp_file.*,npq_file.* ",
             "  FROM npp_file,npq_file,apy_file",
             " WHERE nppsys= 'AP' AND nppglno IS NULL",
             "   AND npp01 = npq01 AND npp011=npq011",
             "   AND npp00 = npq00 ",     #TQC-750011 add
             "   AND ",g_wc CLIPPED,
             "   AND npp01 like ltrim(rtrim(apyslip)) || '-%' AND apydmy3='Y'",
             "   AND nppsys=npqsys ",
             "   AND npptype ='",l_npptype,"'",
             "   AND npqtype=npptype"
   PREPARE p400_1_p0 FROM g_sql
   IF STATUS THEN
       CALL cl_err('p400_1_p0',STATUS,1)
       CALL cl_batch_bg_javamail("N")  #NO.FUN-570112
       CALL p400_tmn_del()   #MOD-820107
      #No.FUN-CB0096 ---start--- add
       LET l_time = TIME
       LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
       CALL s_log_data('U','100',g_id,'1',l_time,'','')
      #No.FUN-CB0096 ---end  --- add
       CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
       EXIT PROGRAM
   END IF
   DECLARE p400_1_c0 CURSOR WITH HOLD FOR p400_1_p0
   CALL cl_outnam('aapp400') RETURNING l_name
   IF l_npptype = '0' THEN  #No.FUN-680029
      START REPORT aapp400_rep TO l_name
   ELSE
      START REPORT aapp400_1_rep TO l_name
   END IF
   LET g_cnt1 = 0     #No.FUN-680029
   LET g_j = 0        #MOD-C80106 add
   WHILE TRUE
      CALL s_showmsg_init()   #No.FUN-710014
      FOREACH p400_1_c0 INTO l_npp.*,l_npq.*
         IF STATUS THEN
             CALL s_errmsg('','','foreach:',STATUS,1)       #No.FUN-710014
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF
         SELECT apa00,apa01,apa56,apa33,apa99              #FUN-850140 add apa99
           INTO l_apa00,l_apa01,l_apa56,l_apa33,l_apa99    #FUN-850140 add l_apa99
            FROM apa_file WHERE apa01 = l_npp.npp01
         IF l_apa00='11' AND l_apa56='3' AND l_apa33 <> 0 THEN
            LET l_cnt = 0
            SELECT COUNT(*) INTO l_cnt FROM apk_file
              WHERE apk26=l_apa01
            IF l_cnt = 0 THEN
               CALL s_errmsg('','',l_apa01,'aap-206',1)    #MOD-830249
               LET g_success='N'
            END IF

         END IF

#TQC-AB0347-----------add--------str---------------------
     #科目控管
      LET g_sql = " SELECT UNIQUE(npq03) FROM npq_file ",
                  "    WHERE npq01 = '",l_npp.npp01,"'",
                  #"      AND nppsys = 'AP'"               #MOD-B10214  #TQC-B30084 mark
                  "      AND npqsys = 'AP'"                #TQC-B30084
                 ,"      AND npqtype = '",l_npptype,"'"    #TQC-B60175   Add
      PREPARE p400_npq03  FROM g_sql
      IF STATUS THEN
         CALL cl_err('p400_npq03',STATUS,1)
         LET g_success = 'N' 
      END IF
      DECLARE p400_npq03_cus CURSOR WITH HOLD FOR p400_npq03
      FOREACH p400_npq03_cus INTO l_npq03
         IF NOT cl_null(l_npq03) THEN
#TQC-AC0285---modify--str--
            #SELECT  COUNT(*) INTO l_n  FROM apw_file
            #    WHERE apw03 = l_npq03
            IF l_npptype = '0' THEN
               SELECT  COUNT(*) INTO l_n  FROM aag_file
                WHERE aag00 = p_bookno
                  AND aag01 = l_npq03
            ELSE
               SELECT  COUNT(*) INTO l_n  FROM aag_file
                WHERE aag00 = p_bookno1
                  AND aag01 = l_npq03
            END IF
#TQC-AC0285---modify--end--
            IF l_n = 0 THEN
              #CALL cl_err('','mfg1603',1)                            #MOD-B10214 mark
               CALL s_errmsg('npq03',l_npp.npp01,l_npq03,'mfg1603',1) #MOD-B10214
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
     END FOREACH
#TQC-AB0347-----------add--------end---------------------

        #當多角序號apa99<>null時,增加s_chknpq()功能
         IF NOT cl_null(l_apa99) THEN
            CALL s_chknpq(l_npp.npp01,l_npp.nppsys,1,'0',p_bookno)
            IF g_aza.aza63 ='Y' THEN
               CALL s_chknpq(l_npp.npp01,l_npp.nppsys,1,'1',p_bookno1)
            END IF
         END IF

         CASE WHEN l_npp.nppsys='AP' AND (l_npp.npp00=1 OR l_npp.npp00=2)
                   SELECT apa02,apa44,apa41,apauser,apa05        #No:9469
                     INTO ap_date,ap_glno,ap_conf,ap_user,l_vender    #No:9469
                     FROM apa_file WHERE apa01=l_npp.npp01
                   IF STATUS THEN
                       CALL s_errmsg('apa01',l_npp.npp01,'sel apa',STATUS,1)                                 #No.FUN-710014
                      LET g_success='N'
                   END IF
              WHEN l_npp.nppsys='AP' AND l_npp.npp00=3
                   SELECT apf02,apf44,apf41,apfuser,apf03     #No:9469
                     INTO ap_date,ap_glno,ap_conf,ap_user,l_vender   #No:9469
                     FROM apf_file WHERE apf01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('apf01',l_npp.npp01,'sel apf',STATUS,1)                                  #No.FUN-710014
                      LET g_success='N'
                   END IF
              #no.7277 成本分攤(aapt900)
              WHEN l_npp.nppsys='AP' AND l_npp.npp00=4
                    SELECT aqa02,aqa05,aqaconf,aqauser  #MOD-4A0282
                     INTO ap_date,ap_glno,ap_conf,ap_user
                     FROM aqa_file WHERE aqa01=l_npp.npp01
                   IF STATUS THEN
                      CALL s_errmsg('aqa01',l_npp.npp01,'sel aqa',STATUS,1)                                  #No.FUN-710014
                      LET g_success='N'
                   END IF
              OTHERWISE CONTINUE FOREACH
         END CASE
         IF ap_conf='N' THEN CONTINUE FOREACH END IF
         IF ap_conf='X' THEN CONTINUE FOREACH END IF #若作廢(modi 01/08/09)
         IF ap_user<b_user OR ap_user>e_user THEN CONTINUE FOREACH END IF
         IF l_npptype ='0' THEN
            IF NOT cl_null(ap_glno) THEN CONTINUE FOREACH END IF
         END IF
         IF l_npp.npp011=1 AND ap_date<>l_npp.npp02 THEN
            LET l_msg= "Date differ:",ap_date,'-',l_npp.npp02,
                       "  * Press any key to continue ..."
            CALL cl_msgany(19,4,l_msg)
            LET INT_FLAG = 0  ######add for prompt bug
         END IF
         IF l_npq.npq04 = ' ' THEN LET l_npq.npq04 = NULL END IF
         IF l_npq.npq05 = ' ' THEN LET l_npq.npq05 = NULL END IF #MOD-920295
         IF gl_tran = 'N' THEN
              LET l_npq.npq04 = NULL
              LET l_remark = l_npq.npq11 clipped,l_npq.npq12 clipped,
                             l_npq.npq13 clipped,l_npq.npq14 clipped,
                             l_npq.npq31 clipped,l_npq.npq32 clipped,
                             l_npq.npq33 clipped,l_npq.npq34 clipped,
                             l_npq.npq35 clipped,l_npq.npq36 clipped,
                             l_npq.npq37 clipped,
                             l_npq.npq15 clipped,l_npq.npq08 clipped
         ELSE
              LET l_remark = l_npq.npq04 clipped,l_npq.npq11 clipped,
                             l_npq.npq12 clipped,l_npq.npq13 clipped,
                             l_npq.npq14 clipped,
                             l_npq.npq31 clipped,l_npq.npq32 clipped,
                             l_npq.npq33 clipped,l_npq.npq34 clipped,
                             l_npq.npq35 clipped,l_npq.npq36 clipped,
                             l_npq.npq37 clipped,
                             l_npq.npq15 clipped,
                             l_npq.npq08 clipped
         END IF
          IF cl_null(l_vender) THEN LET l_vender=l_npq.npq21 END IF      #No:9469
         CASE WHEN gl_seq = '0' LET l_order = ' '         # 傳票區分項目
              WHEN gl_seq = '1' LET l_order = l_npp.npp01 # 依單號
              WHEN gl_seq = '2' LET l_order = l_npp.npp02 USING 'yyyymmdd'
              WHEN gl_seq = '3' LET l_order = l_vender    # No:9469
              OTHERWISE         LET l_order = ' '
         END CASE
         IF g_flag = 'N' THEN
            LET l_dorder = gl_date
         ELSE
            LET l_dorder = l_npp.npp02
         END IF
         IF gl_summary='Y' THEN
            LET l_order2 = 0
         ELSE
            LET l_order2 = l_npq.npq02
         END IF
         #資料丟入temp file 排序
         INSERT INTO p400_tmp VALUES(l_dorder,l_order,l_order2,l_npp.*,l_npq.*,l_remark)  #No.MOD-840389 #FUN-8A0027 add l_order2
         IF STATUS THEN
             CALL s_errmsg('','','ins tmp',STATUS,1)
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         LET g_cnt1 = g_cnt1 + 1        #No.FUN-680029
      END FOREACH

  IF g_totsuccess="N" THEN
           LET g_success="N"
  END IF

     #-MOD-A80059-mark-
     #DECLARE p400_tmpcs CURSOR FOR
     #   SELECT * FROM p400_tmp 
     #    #ORDER BY dorder,order1,order2,npq06,npq03,npq05,  #No.MOD-840389  #FUN-8A0027 add order2  #FUN-9C0127  mark
     #    #         npq24,npq25,remark,npq01                                                         #FUN-9C0127  mark
     #     ORDER BY dorder,order1,npq06,npq01,order2,npq03,npq05,npq24,npq25,remark   #FUN-9C0127
     #-MOD-A80059-end-
     #-MOD-A80059-add-
      IF gl_summary='Y' THEN
         IF g_aza.aza26='2' THEN                                                      #MOD-BB0078 add
           #依據會科合併時,如有多張帳款需要合併時,應先以科目為優先排序,帳款單號於最後再排序
            LET g_sql = "SELECT * FROM p400_tmp",
                       #"  ORDER BY dorder,order1,order2,npq06,npq03,npq05, ", 
                       #"  ORDER BY dorder,order1,order2,npp01,npq06,npq03,npq05, ",   #MOD-B80305 #TQC-C70193 mark  
                       #"  ORDER BY npq03,dorder,order1,order2,npp01,npq06,npq05, ",   #TQC-C70193 add #TQC-C80086 mark     
                       #"  ORDER BY npq03,dorder,order1,order2,npq06,npq05, ",         #TQC-C80086 add #MOD-C80058 mark
                        "  ORDER BY dorder,order1,order2,npq03,npq06,npq05, ",         #MOD-C80058 add
                        "           npq24,npq25,remark                    "      
         ELSE                                                                          #MOD-BB0078 add
            LET g_sql = "SELECT * FROM p400_tmp",                                      #MOD-BB0078 add
                       #"  ORDER BY dorder,order1,order2,npq06,npq03,npq05, ",         #MOD-BB0078 add #TQC-C70193  mark    
                       #"  ORDER BY npq03,dorder,order1,order2,npq06,npq05, ",         #TQC-C70193 add #MOD-C80058 mark  
                        "  ORDER BY dorder,order1,order2,npq03,npq06,npq05, ",         #MOD-C80058 add
                        "           npq24,npq25,remark,npq01                "          #MOD-BB0078 add   
        END IF                                                                         #MOD-BB0078 add                        "           npq24,npq25,remark,npq01                "                                                    #FUN-9C0127  mark
      ELSE
         IF g_aza.aza26='2' THEN                                                            #MOD-BB0078 add
            LET g_sql = "SELECT * FROM p400_tmp",
                       #"  ORDER BY dorder,order1,npq06,npq01,order2,npq03, ",
                       # "  ORDER BY dorder,order1,npp01,npq06,npq01,order2,npq03, ",   #MOD-B80305   #TQC-C80086 mark
                        "  ORDER BY dorder,order1,npq06,npq01,order2,npq03, ",          #TQC-C80086  add
                        "           npq05,npq24,npq25,remark                "
         ELSE                                                                         #MOD-BB0078 add
            LET g_sql = "SELECT * FROM p400_tmp",                                     #MOD-BB0078 add
                        "  ORDER BY dorder,order1,npq06,order2,npq03, ",              #MOD-BB0078 add
                        "           npq05,npq24,npq25,remark                "         #MOD-BB0078 add
         END IF                                                                       #MOD-BB0078 add
      END IF
      PREPARE p400_tmpp FROM g_sql
      DECLARE p400_tmpcs CURSOR WITH HOLD FOR p400_tmpp
      LET l_npp01 = NULL   #B80305 add
     #-MOD-A80059-end-
      FOREACH p400_tmpcs INTO l_dorder,l_order,l_order2,l_npp.*,l_npq.*,l_remark  #No.MOD-840389 #FUN-8A0027 add l_order2
         IF STATUS THEN
             CALL s_errmsg('','','for tmp:',STATUS,1)     #No.FUN-710014
            LET g_success='N'
            EXIT FOREACH
         END IF
         IF g_success='N' THEN
            LET g_totsuccess='N'
            LET g_success="Y"
         END IF

         #MOD-B80305  --Begin
         IF NOT cl_null(l_npp01) AND l_npp01 = l_npp.npp01 THEN
            LET l_npp.npp08 = 0
         END IF
         LET l_npp01 = l_npp.npp01
         #MOD-B80305  --End 

         LET l_order =l_order CLIPPED    #No.MOD-860206
         IF l_npp.npptype = '0' AND l_npptype ='0' THEN  #No.FUN-680029
            OUTPUT TO REPORT aapp400_rep(l_dorder,l_order,l_order2,l_npp.*,l_npq.*,l_remark)  #No.MOD-8403889 #FUN-8A0027 add l_order2
         END IF
         IF l_npp.npptype = '1' AND l_npptype ='1' THEN  #No.FUN-680029
            OUTPUT TO REPORT aapp400_1_rep(l_dorder,l_order,l_order2,l_npp.*,l_npq.*,l_remark)  #No.MOD-8403889 #FUN-8A0027 add l_order2
         END IF
      END FOREACH

      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF

      EXIT WHILE
   END WHILE
   IF l_npptype = '0' THEN  #No.FUN-680029
      FINISH REPORT aapp400_rep
   ELSE
      FINISH REPORT aapp400_1_rep
   END IF

   IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009  add by dxfwo

   IF g_cnt1 = 0  THEN
       CALL s_errmsg('','','','aap-129',1)         #No.FUN-710014
      LET g_success = 'N'
   END IF

END FUNCTION

REPORT aapp400_rep(l_dorder,l_order,l_order2,l_npp,l_npq,l_remark)  #No.MOD-840389 #FUN-8A0027 add l_order2
  DEFINE li_result      LIKE type_file.num5       #No.FUN-560190  #No.FUN-690028 SMALLINT
  DEFINE l_dorder       LIKE npp_file.npp02       #No.MOD-840389
  DEFINE l_order        LIKE npp_file.npp01       #No.FUN-690028 VARCHAR(30)
  DEFINE l_order2       LIKE npq_file.npq02       #FUN-8A0027 add
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_n,l_n1,l_n2,l_n3  LIKE type_file.num5       #No.FUN-690028 SMALLINT  #FUN-C70093 add--l_n3
  DEFINE l_seq		LIKE type_file.num5       #No.FUN-690028 SMALLINT	# 傳票項次
  DEFINE l_credit       LIKE type_file.num20_6    #No.FUN-690028 DEC(20,6)  #FUN-4B0079
  DEFINE l_debit        LIKE type_file.num20_6    #No.FUN-690028 DEC(20,6)  #FUN-4B0079
  DEFINE l_amt          LIKE type_file.num20_6    #No.FUN-690028 DEC(20,6)  #FUN-4B0079
  DEFINE l_amtf         LIKE type_file.num20_6    #No.FUN-690028 DEC(20,6)  #FUN-4B0079
  DEFINE l_remark       LIKE type_file.chr1000    #MOD-770020
  DEFINE l_missingno    LIKE aba_file.aba01       #No.FUN-570090  --add
  DEFINE l_flag1        LIKE type_file.chr1       #No.FUN-570090  --add    #No.FUN-690028 VARCHAR(1)
  DEFINE l_cnt          LIKE type_file.num5       #MOD-640404   #No.FUN-690028 SMALLINT
  DEFINE l_nmf01        LIKE nmf_file.nmf01       #MOD-930242 add
  DEFINE l_legal        LIKE azw_file.azw02       #FUN-980001 add
  DEFINE l_npp08        LIKE npp_file.npp08       #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5       #No.TQC-B70021 
  DEFINE l_aqa00        LIKE aqa_file.aqa00       #FUN-C70093
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER EXTERNAL BY l_dorder,l_order,l_order2,  #FUN-8A0027 add l_order2     #MOD-A50100 mark   #MOD-A80059 reamrk
 #ORDER BY          l_dorder,l_order,l_order2,  #FUN-8A0027 add l_order2     #MOD-A50100        #MOD-A80059 mark
                    l_npq.npq06,l_npq.npq03,l_npq.npq05,  #No.MOD-840389                        
                    l_npq.npq24,l_npq.npq25,l_remark,l_npq.npq01                                 
  FORMAT
   BEFORE GROUP OF l_order
   IF g_flag = 'Y' THEN
      LET gl_date = l_npp.npp02
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=gl_date   #MOD-740480
   END IF  #MOD-730142
   #缺號使用
   LET l_flag1='N'
   LET l_missingno = NULL
   LET g_j=g_j+1
   SELECT tc_tmp02 INTO l_missingno
     FROM agl_tmp_file
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'
      AND tc_tmp03 = p_bookno  #No.FUN-680029
   IF NOT cl_null(l_missingno) THEN
      LET l_flag1='Y'
      LET gl_no=l_missingno
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no
                                AND tc_tmp03 = p_bookno  #No.FUN-680029
   END IF

   #缺號使用完，再在流水號最大的編號上增加
   IF l_flag1='N' THEN
     #No.FUN-CB0096 ---start--- Add
      LET t_no = Null
      CALL s_log_check(l_order) RETURNING t_no
      IF NOT cl_null(t_no) THEN
         LET gl_no = t_no
         LET li_result = '1'
      ELSE
     #No.FUN-CB0096 ---start--- Add
         CALL s_auto_assign_no("agl",gl_no,gl_date,"","","",p_plant,"",p_bookno)
            RETURNING li_result,gl_no
         IF (NOT li_result) THEN
            LET g_success = 'N'
         END IF
      END IF   #No.FUN-CB0096   Add

     IF g_bgjob = 'N' THEN                         #FUN-570112
         DISPLAY "Insert G/L voucher no:",gl_no AT 1,1
     END IF  #NO.FUN-570112
     PRINT "Insert aba:",p_bookno,' ',gl_no,' From:',l_order  #No.FUN-680029 g_apz.apz02b -> p_bookno
   END IF  #No.FUN-570090  -add
    #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",    #FUN-A50102
     LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
                   "(aba00,aba01,aba02,aba03,aba04,aba05,",
                   " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",   #No:8657
                   " abaprno,abaacti,abauser,abagrup,abadate,abaoriu,abaorig,",    #MOD-9C0299
                   " abasign,abadays,abaprit,abasmax,abasseq,aba24,aba11,abalegal,aba21)",     #FUN-840211                          #MOD-640202 #FUN-980001 add   #FUN-A10006 add aba21
            " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?)"  #MOD-9C0299 add ?,? #FUN-840211        #No:8657  #MOD-640202 #FUN-980001 add ?  #FUN-A10006 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
     PREPARE p400_1_p4 FROM g_sql
     #自動賦予簽核等級
     LET g_aba.aba01=gl_no
     LET g_aba01t = gl_no[1,g_doc_len]   #FUN-560190
     SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
       INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
            g_aba.abaprit,g_aba.abasign
       FROM aac_file WHERE aac01 = g_aba01t
     IF g_aba.abamksg MATCHES  '[Yy]'
        THEN
        IF g_aac.aacatsg matches'[Yy]'   #自動付予
           THEN
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        SELECT COUNT(*) INTO g_aba.abasmax
            FROM azc_file
            WHERE azc01=g_aba.abasign
     END IF
     LET g_system = 'AP'
     LET g_zero   = 0
     LET g_zero1  = 0      #No:8657
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     CALL s_getlegal(g_plant_new) RETURNING l_legal #FUN-980001
     LET g_aba.abalegal = l_legal #FUN-980001 add
     EXECUTE p400_1_p4 USING p_bookno,gl_no,gl_date,g_yy,g_mm,g_today,  #No.FUN-680029 g_apz.apz02b -> p_bookno
                             g_system,l_order,g_zero,g_zero,g_N,g_N,g_zero1,    #No:8657
                             g_aba.abamksg,g_N,
                             g_zero,g_Y,g_user,g_grup,g_today,
                             g_user,g_grup,       #MOD-9C0299
                             g_aba.abasign,g_aba.abadays,
                             g_aba.abaprit,g_aba.abasmax,g_zero,g_user,g_aba.aba11 #No.FUN-840211 add aba11 #MOD-640202
                            ,g_aba.abalegal,l_npp.npp08 #FUN-980001 add  #FUN-A10006 add npp08
 
     IF SQLCA.sqlcode THEN
         CALL cl_err('ins aba:',SQLCA.sqlcode,1)
         LET g_success = 'N'
     ELSE
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no  #No.FUN-570090  --add
                            AND tmn06 = p_bookno  #No.FUN-680029
     END IF
     IF gl_no_b IS NULL THEN LET gl_no_b = gl_no END IF
     LET gl_no_e = gl_no
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   AFTER GROUP OF l_npq.npq01
     IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF  #FUN-680059
     LET l_n1 = 0   LET l_n2 = 0 LET l_n = 0 LET l_n3=0         #FUN-C70093 add--n3
     CASE WHEN l_npp.nppsys='AP' AND (l_npp.npp00=1 OR l_npp.npp00=2)
               UPDATE apa_file SET apa43 = gl_date,
                                   apa44 = gl_no
                WHERE apa01 = l_npq.npq01
               IF SQLCA.sqlerrd[3] !=0 THEN LET l_n1 = SQLCA.sqlerrd[3] END IF
               UPDATE apf_file SET apf43 = gl_date,
                                   apf44 = gl_no
                WHERE apf01 = l_npq.npq01
               IF SQLCA.sqlerrd[3] !=0 THEN LET l_n2 = SQLCA.sqlerrd[3] END IF
                SELECT COUNT(*) INTO l_cnt FROM nmf_file
                   WHERE nmf12 = l_npq.npq01
                IF l_cnt > 0 THEN
                   UPDATE nmf_file SET nmf11=gl_no,nmf13=gl_date
                     WHERE nmf12 = l_npq.npq01
                   IF STATUS THEN
                      CALL cl_err3("upd","nmf_file",l_npq.npq01,"",STATUS,"","upd nmf_file",1)   #No.FUN-660122
                      LET g_success='N'
                   END IF
                   LET l_nmf01 = ''
                   SELECT nmf01 INTO l_nmf01 FROM nmf_file
                    WHERE nmf12 = l_npq.npq01 AND nmf05 = '0'
                   LET l_cnt = 0
                   SELECT COUNT(*) INTO l_cnt FROM nmd_file
                    WHERE nmd01 = l_nmf01
                   IF l_cnt > 0 THEN
                      UPDATE nmd_file SET nmd27=gl_no,nmd28=gl_date
                       WHERE nmd01 = l_nmf01
                      IF STATUS THEN
                         CALL cl_err3("upd","nmd_file",l_nmf01,"",STATUS,"","upd nmd_file",1)
                         LET g_success='N'
                      END IF
                   END IF
                END IF
          WHEN l_npp.nppsys='AP' AND l_npp.npp00=3
               UPDATE apf_file SET apf43 = gl_date,
                                   apf44 = gl_no
                WHERE apf01 = l_npq.npq01
               IF SQLCA.sqlerrd[3] !=0 THEN LET l_n1 = SQLCA.sqlerrd[3] END IF
               SELECT COUNT(*) INTO l_cnt FROM nmf_file
                  WHERE nmf12 = l_npq.npq01
               IF l_cnt > 0 THEN
                  UPDATE nmf_file SET nmf11=gl_no,nmf13=gl_date
                    WHERE nmf12 = l_npq.npq01
                  IF STATUS THEN
                     CALL cl_err3("upd","nmf_file",l_npq.npq01,"",STATUS,"","upd nmf_file",1)   #No.FUN-660122
                     LET g_success='N'
                  END IF
                  LET l_nmf01 = ''
                  SELECT nmf01 INTO l_nmf01 FROM nmf_file
                   WHERE nmf12 = l_npq.npq01 AND nmf05 = '0'
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM nmd_file
                   WHERE nmd01 = l_nmf01
                  IF l_cnt > 0 THEN
                     UPDATE nmd_file SET nmd27=gl_no,nmd28=gl_date
                      WHERE nmd01 = l_nmf01
                     IF STATUS THEN
                        CALL cl_err3("upd","nmd_file",l_nmf01,"",STATUS,"","upd nmd_file",1)
                        LET g_success='N'
                     END IF
                  END IF
               END IF
          #no.7277 成本分攤
          WHEN l_npp.nppsys='AP' AND l_npp.npp00=4
               UPDATE aqa_file SET aqa05 = gl_no
                WHERE aqa01 = l_npp.npp01
               IF SQLCA.sqlerrd[3] !=0 THEN LET l_n1 = SQLCA.sqlerrd[3] END IF
               #FUN-C70093--ADD--STR
               SELECT aqa00 INTO l_aqa00 FROM aqa_file WHERE aqa01=l_npp.npp01
               IF l_aqa00='2' THEN
                  UPDATE ccb_file SET ccbglno = gl_no
                   WHERE ccb04=l_npp.npp01
                  IF SQLCA.sqlerrd[3] !=0 THEN LET l_n3 = SQLCA.sqlerrd[3] END IF
               END IF
               #FUN-C70093--ADD--END
     END CASE
     LET l_n = l_n1 + l_n2+l_n3
     IF SQLCA.sqlcode OR l_n = 0 THEN
        CALL cl_err('upd gl_no/gl_date:',SQLCA.sqlcode,1) LET g_success = 'N'
     END IF
     UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no,
                         npp06= p_plant,npp07=p_bookno
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND nppsys= l_npp.nppsys
         AND npptype = '0'  #No.FUN-680029
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno",1)   #No.FUN-660122
        LET g_success = 'N'
     #若無更新資料，同樣需要報錯，并停止拋轉。
     ELSE
        IF SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,'axr-198',"","upd npp03/glno",1)
           LET g_success = 'N'
        END IF
     END IF
   AFTER GROUP OF l_remark
     IF gl_summary = 'Y' THEN                                     #MOD-C70047 add
        LET l_seq = l_seq + 1
        IF g_bgjob = 'N' THEN
            DISPLAY "Seq:",l_seq AT 2,1
        END IF
       #LET g_sql = "INSERT INTO ",g_dbs_gl CLIPPED,"abb_file",   #FUN-A50102
        LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'abb_file'),   #FUN-A50102
                           "(abb00,abb01,abb02,abb03,abb04,",
                           " abb05,abb06,abb07f,abb07,",
                           " abb08,abb11,abb12,abb13,abb14,",                     #FUN-810069
                           " abb24,abb25,",
                           "abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal", #FUN-980001 add abblegal
       
                           " )",
                    " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,? ,?",                 #FUN-810069
                    "       ,?,?,?,?,?,?,? ,?)" #FUN-5C0015 BY GILL #FUN-980001 add ?
        LET l_amt = GROUP SUM(l_npq.npq07)
        LET l_amtf= GROUP SUM(l_npq.npq07f)
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
        CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
        PREPARE p400_1_p5 FROM g_sql
        IF cl_null(l_npq.npq05) THEN LET l_npq.npq05= ' ' END IF 
        IF cl_null(l_npq.npq08) THEN LET l_npq.npq08= ' ' END IF
        IF cl_null(l_npq.npq35) THEN LET l_npq.npq35= ' ' END IF
        CALL s_getlegal(g_plant_new) RETURNING l_legal
        EXECUTE p400_1_p5 USING
                   p_bookno,gl_no,l_seq,l_npq.npq03,l_npq.npq04,  #No.FUN-680029 g_apz.apz02b -> p_bookno
                   l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                   l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                   l_npq.npq14,l_npq.npq24,l_npq.npq25,                           #FUN-810069
                   l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                   l_npq.npq35,l_npq.npq36,l_npq.npq37,l_legal  #FUN-980001 add l_legal
       
        IF SQLCA.sqlcode THEN
           CALL cl_err('ins abb:',SQLCA.sqlcode,1) LET g_success = 'N'
        END IF
        IF l_npq.npq06 = '1'
           THEN LET l_debit  = l_debit  + l_amt
           ELSE LET l_credit = l_credit + l_amt
        END IF
     END IF                                                        #MOD-C70047 add
  #-------------------------------------MOD-C70047-------------------------------(S)
   ON EVERY ROW
      IF gl_summary = 'N' THEN
         LET l_seq = l_seq + 1
         IF g_bgjob = 'N' THEN
            DISPLAY "Seq:",l_seq AT 2,1
         END IF
         LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'abb_file'),
                     "(abb00,abb01,abb02,abb03,abb04,",
                     " abb05,abb06,abb07f,abb07,abb08,",
                     " abb11,abb12,abb13,abb14,abb24,",
                     " abb25,abb31,abb32,abb33,abb34,",
                     " abb35,abb36,abb37,abblegal)",
                     " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,",
                     "        ?,?,?,?,?, ?,?,?,?)"
         LET l_amt = l_npq.npq07
         LET l_amtf= l_npq.npq07f
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql
         PREPARE p400_1_p11 FROM g_sql
         IF cl_null(l_npq.npq05) THEN LET l_npq.npq05= ' ' END IF
         IF cl_null(l_npq.npq08) THEN LET l_npq.npq08= ' ' END IF
         IF cl_null(l_npq.npq35) THEN LET l_npq.npq35= ' ' END IF
         CALL s_getlegal(g_plant_new) RETURNING l_legal
         EXECUTE p400_1_p11 USING
                    p_bookno,gl_no,l_seq,l_npq.npq03,l_npq.npq04,
                    l_npq.npq05,l_npq.npq06,l_amtf,l_amt,l_npq.npq08,
                    l_npq.npq11,l_npq.npq12,l_npq.npq13,l_npq.npq14,l_npq.npq24,
                    l_npq.npq25,l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                    l_npq.npq35,l_npq.npq36,l_npq.npq37,l_legal

         IF SQLCA.sqlcode THEN
            CALL cl_err('ins abb:',SQLCA.sqlcode,1) LET g_success = 'N'
         END IF
         IF l_npq.npq06 = '1'
            THEN LET l_debit  = l_debit  + l_amt
            ELSE LET l_credit = l_credit + l_amt
         END IF
      END IF
  #-------------------------------------MOD-C70047-------------------------------(E)
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no
     #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08 = ?,aba09 = ? ",   #FUN-A50102
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102
                  "   SET aba08 = ?,aba09 = ? ",      #FUN-A50102
                  "      ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
      PREPARE p400_1_p6 FROM g_sql
      EXECUTE p400_1_p6 USING l_debit,l_credit,l_npp08,gl_no,p_bookno  #No.FUN-680029 g_apz.apz02b -> p_bookno #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      PRINT
     CALL s_flows('2',p_bookno,gl_no,gl_date,g_N,'',TRUE)   #No.TQC-B70021
#no.3432 自動確認
IF g_aaz85 = 'Y' THEN
      #若有立沖帳管理就不做自動確認
     #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",   #FUN-A50102
      LET g_sql = "SELECT COUNT(*) ",   #FUN-A50102
                  "  FROM ",cl_get_target_table(p_plant,'abb_file'),",aag_file ",   #FUN-A50102
                  " WHERE abb01 = '",gl_no,"'",
                  "   AND abb00 = '",p_bookno,"'",  #No.FUN-680029 g_apz.apz02b -> p_bookno
                  "   AND abb03 = aag01  ",
                  "   AND abb00 = aag00  ",             #No.FUN-730064
                  "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE count_pre FROM g_sql
      DECLARE count_cs CURSOR FOR count_pre
      OPEN count_cs
      FETCH count_cs INTO g_cnt
      CLOSE count_cs
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
         IF g_aba.abamksg='N' THEN   #MOD-7B0087
            LET g_aba.aba20='1'
            LET g_aba.aba19 = 'Y'
#No.TQC-B70021 --begin 
            CALL s_chktic (p_bookno,gl_no) RETURNING l_success  
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end                
           #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",   #FUN-A50102
            LET g_sql = " UPDATE ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102 
                        "    SET abamksg = ? ,",
                               " abasign = ? ,",
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ? ,",
                               " aba37   = ?  ",   #No.TQC-7B0086
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
            PREPARE upd_aba19 FROM g_sql
            EXECUTE upd_aba19 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user,     #No.TQC-7B0086
                                    gl_no        ,p_bookno  #No.FUN-680029 g_apz.apz02b -> p_bookno
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
            END IF
         END IF   #MOD-770101
      END IF
END IF
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,gl_no,l_order)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
      LET gl_no[g_no_sp-1,g_no_ep]=''     #No.FUN-560190
END REPORT

REPORT aapp400_1_rep(l_dorder,l_order,l_order2,l_npp,l_npq,l_remark)  #No.MOD-840389 #FUN-8A0027 add l_order2
  DEFINE li_result      LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE l_dorder       LIKE npp_file.npp02     #No.MOD-840389
  DEFINE l_order        LIKE npp_file.npp01     # No.FUN-690028 VARCHAR(30)
  DEFINE l_order2       LIKE npq_file.npq02     #FUN-8A0027 add
  DEFINE l_npp		RECORD LIKE npp_file.*
  DEFINE l_npq		RECORD LIKE npq_file.*
  DEFINE l_n,l_n1,l_n2,l_n3  LIKE type_file.num5    #No.FUN-690028 SMALLINT #FUN-C70093 add--l_n3
  DEFINE l_seq		LIKE type_file.num5    # No.FUN-690028 SMALLINT	# 傳票項次
  DEFINE l_credit,l_debit,l_amt,l_amtf  LIKE type_file.num20_6 #No.FUN-690028 DEC(20,6)
  DEFINE l_remark       LIKE type_file.chr1000   #MOD-770020
  DEFINE l_missingno    LIKE aba_file.aba01
  DEFINE l_flag1        LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
  DEFINE l_cnt          LIKE type_file.num5    #No.FUN-690028 SMALLINT
  DEFINE l_legal        LIKE azw_file.azw02    #FUN-980001 add
  DEFINE l_npp08        LIKE npp_file.npp08    #MOD-A80017 Add
  DEFINE l_success      LIKE type_file.num5    #No.TQC-B70021     
  
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
 #ORDER EXTERNAL BY l_dorder,l_order,l_order2,  #FUN-8A0027 add l_order2     #MOD-A50100 mark
  ORDER BY          l_dorder,l_order,l_order2,  #FUN-8A0027 add l_order2     #MOD-A50100
           l_npq.npq06,l_npq.npq03,l_npq.npq05,  #No.MOD-840389
           l_npq.npq24,l_npq.npq25,
           l_remark,l_npq.npq01
  FORMAT
   BEFORE GROUP OF l_order
   IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF  #FUN-680059
   #缺號使用
   LET l_flag1='N'
   LET l_missingno = NULL
   LET g_j=g_j+1
   SELECT tc_tmp02 INTO l_missingno
     FROM agl_tmp_file
    WHERE tc_tmp01=g_j AND tc_tmp00 = 'Y'
      AND tc_tmp03 = p_bookno1
   IF NOT cl_null(l_missingno) THEN
      LET l_flag1='Y'
      LET gl_no1 =l_missingno
      DELETE FROM agl_tmp_file WHERE tc_tmp02 = gl_no1
                                AND tc_tmp03 = p_bookno1
   END IF

   #缺號使用完，再在流水號最大的編號上增加
   IF l_flag1='N' THEN
     #No.FUN-CB0096 ---start--- Add
      LET t_no = Null
      CALL s_log_check(l_order) RETURNING t_no
      IF NOT cl_null(t_no) THEN
         LET gl_no1 = t_no
         LET li_result = '1'
      ELSE
     #No.FUN-CB0096 ---start--- Add
         CALL s_auto_assign_no("agl",gl_no1,gl_date,"","","",p_plant,"",p_bookno1)
            RETURNING li_result,gl_no1
         IF (NOT li_result) THEN
            LET g_success = 'N'
         END IF
      END IF   #No.FUN-CB0096   Add

      IF g_bgjob = 'N' THEN
         DISPLAY "Insert G/L voucher no:",gl_no1 AT 1,1
      END IF

      PRINT "Insert aba:",p_bookno1,' ',gl_no1,' From:',l_order
   END IF

  #LET g_sql="INSERT INTO ",g_dbs_gl,"aba_file",   #FUN-A50102
   LET g_sql="INSERT INTO ",cl_get_target_table(p_plant,'aba_file'),    #FUN-A50102 
             "(aba00,aba01,aba02,aba03,aba04,aba05,",
             " aba06,aba07,aba08,aba09,aba12,aba19,aba20,abamksg,abapost,",
             " abaprno,abaacti,abauser,abagrup,abadate,abaoriu,abaorig,",  #MOD-9C0299
             " abasign,abadays,abaprit,abasmax,abasseq,aba24,aba11,abalegal,aba21)", #FUN-840211 add aba11  #FUN-980001 add FUN-A10006 add aba21
             " VALUES(?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?)" #FUN-840211 add aba11 #FUN-980001 add ? #MOD-9C0299 add ?? FUN-A10006 add ?
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
     PREPARE p400_1_p7 FROM g_sql

     #自動賦予簽核等級
     LET g_aba.aba01=gl_no1
     LET g_aba01t = gl_no1[1,g_doc_len]
     SELECT aac08,aacatsg,aacdays,aacprit,aacsign  #簽核處理 (Y/N)
       INTO g_aba.abamksg,g_aac.aacatsg,g_aba.abadays,
            g_aba.abaprit,g_aba.abasign
       FROM aac_file WHERE aac01 = g_aba01t
     IF g_aba.abamksg MATCHES  '[Yy]'
        THEN
        IF g_aac.aacatsg matches'[Yy]'   #自動付予
           THEN
           CALL s_sign(g_aba.aba01,4,'aba01','aba_file')
                RETURNING g_aba.abasign
        END IF
        SELECT COUNT(*) INTO g_aba.abasmax
            FROM azc_file
            WHERE azc01=g_aba.abasign
     END IF

     LET g_system = 'AP'
     LET g_zero   = 0
     LET g_zero1  = 0
     LET g_N      = 'N'
     LET g_Y      = 'Y'
     CALL s_getlegal(g_plant_new) RETURNING l_legal
     LET g_aba.abalegal = l_legal #FUN-980001 add
     EXECUTE p400_1_p7 USING p_bookno1,gl_no1,gl_date,g_yy,g_mm,g_today,
                             g_system,l_order,g_zero,g_zero,g_N,g_N,g_zero1,
                             g_aba.abamksg,g_N,
                             g_zero,g_Y,g_user,g_grup,g_today,
                             g_user,g_grup,         #MOD-9C0299
                             g_aba.abasign,g_aba.abadays,
                             g_aba.abaprit,g_aba.abasmax,g_zero,g_user,g_aba.aba11 #No.FUN-840211 add aba11 #MOD-640202
                            ,g_aba.abalegal,l_npp.npp08 #FUN-980001 add  FUN-A10006 add npp08
     IF SQLCA.sqlcode THEN
         CALL cl_err('ins aba:',SQLCA.sqlcode,1)
         LET g_success = 'N'
     ELSE
     DELETE FROM tmn_file WHERE tmn01 = p_plant AND tmn02 = gl_no1
                            AND tmn06 = p_bookno1
     END IF
     IF gl_no_b1 IS NULL THEN LET gl_no_b1 = gl_no1 END IF
     LET gl_no_e1 = gl_no1
     LET l_credit = 0 LET l_debit  = 0
     LET l_seq = 0
   AFTER GROUP OF l_npq.npq01
     IF cl_null(gl_date) THEN LET gl_date = l_npp.npp02 END IF  #FUN-680059
     UPDATE npp_file SET npp03 = gl_date,nppglno=gl_no1,
                         npp06= p_plant,npp07=p_bookno1
       WHERE npp01 = l_npp.npp01
         AND npp011= l_npp.npp011
         AND npp00 = l_npp.npp00
         AND nppsys= l_npp.nppsys
         AND npptype = '1'
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,SQLCA.sqlcode,"","upd npp03/glno1",1)
        LET g_success = 'N'
     #若無更新資料，同樣需要報錯，并停止拋轉。
     ELSE
        IF SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err3("upd","npp_file",l_npp.npp01,l_npp.npp011,'axr-198',"","upd npp03/glno",1)
           LET g_success = 'N'
        END IF
     END IF
   AFTER GROUP OF l_remark
     LET l_seq = l_seq + 1

     IF g_bgjob = 'N' THEN
         DISPLAY "Seq:",l_seq AT 2,1
     END IF

    #LET g_sql = "INSERT INTO ",g_dbs_gl CLIPPED,"abb_file",   #FUN-A50102
     LET g_sql = "INSERT INTO ",cl_get_target_table(p_plant,'abb_file'),   #FUN-A50102
                        "(abb00,abb01,abb02,abb03,abb04,",
                        " abb05,abb06,abb07f,abb07,",
                        " abb08,abb11,abb12,abb13,abb14,",                       #FUN-810069
                        " abb24,abb25,",
                        "abb31,abb32,abb33,abb34,abb35,abb36,abb37,abblegal", #FUN-980001 add
                        " )",
                 " VALUES(?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,? ,?",                   #FUN-810069
                 "       ,?,?,?,?,?,?,?,?)" #FUN-980001 add
     LET l_amt = GROUP SUM(l_npq.npq07)
     LET l_amtf= GROUP SUM(l_npq.npq07f)
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql    #FUN-A50102
     CALL s_getlegal(g_plant_new) RETURNING l_legal  #FUN-980001 add
     PREPARE p400_1_p8 FROM g_sql
     IF cl_null(l_npq.npq05) THEN LET l_npq.npq05= ' ' END IF 
     IF cl_null(l_npq.npq08) THEN LET l_npq.npq08= ' ' END IF
     IF cl_null(l_npq.npq35) THEN LET l_npq.npq35= ' ' END IF
     EXECUTE p400_1_p8 USING
                p_bookno1,gl_no1,l_seq,l_npq.npq03,l_npq.npq04,
                l_npq.npq05,l_npq.npq06,l_amtf,l_amt,
                l_npq.npq08,l_npq.npq11,l_npq.npq12,l_npq.npq13,
                l_npq.npq14,l_npq.npq24,l_npq.npq25,                             #FUN-810069
                l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34,
                l_npq.npq35,l_npq.npq36,l_npq.npq37,l_legal #FUN-980001 add

     IF SQLCA.sqlcode THEN
        CALL cl_err('ins abb:',SQLCA.sqlcode,1) LET g_success = 'N'
     END IF
     IF l_npq.npq06 = '1'
        THEN LET l_debit  = l_debit  + l_amt
        ELSE LET l_credit = l_credit + l_amt
     END IF
   AFTER GROUP OF l_order
      LET l_npp08 = GROUP SUM(l_npp.npp08)                           #MOD-A80017 Add
      PRINT "update debit&credit:",l_debit,' ',l_credit," For:",gl_no1
     #FUN-A50102--mod--str--
     #LET g_sql = "UPDATE ",g_dbs_gl,"aba_file SET aba08 = ?,aba09 = ? ",
      LET g_sql = "UPDATE ",cl_get_target_table(p_plant,'aba_file'),
                  "   SET aba08 = ?,aba09 = ? ", 
     #FUN-A50102--mod--end
                  "    ,aba21=? ",                                 #MOD-A80017 Add
                  " WHERE aba01 = ? AND aba00 = ?"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE p400_1_p9 FROM g_sql
      EXECUTE p400_1_p9 USING l_debit,l_credit,l_npp08,gl_no1,p_bookno1  #MOD-A80017 Add l_npp08
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err('upd aba08/09:',SQLCA.sqlcode,1) LET g_success = 'N'
      END IF
      PRINT
     CALL s_flows('2',p_bookno1,gl_no1,gl_date,g_N,'',TRUE)   #No.TQC-B70021
   IF g_aaz85 = 'Y' THEN
      #若有立沖帳管理就不做自動確認
     #FUN-A50102--mod--str--
     #LET g_sql = "SELECT COUNT(*) FROM ",g_dbs_gl CLIPPED," abb_file,aag_file",
      LET g_sql = "SELECT COUNT(*) ",
                  "  FROM ",cl_get_target_table(p_plant,'abb_file'),",aag_file",
     #FUN-A50102--mod--end
                  " WHERE abb01 = '",gl_no1,"'",
                  "   AND abb00 = '",p_bookno1,"'",
                  "   AND abb03 = aag01  ",
                  "   AND abb00 = aag00   ",      #No.FUN-730064
                  "   AND aag20 = 'Y' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
      CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
      PREPARE count_pre1 FROM g_sql
      DECLARE count_cs1 CURSOR FOR count_pre1
      OPEN count_cs1
      FETCH count_cs1 INTO g_cnt
      CLOSE count_cs1
      IF g_cnt = 0 THEN
         IF cl_null(g_aba.aba18) THEN LET g_aba.aba18='0' END IF
         IF g_aba.abamksg='N' THEN   #MOD-7B0087
            LET g_aba.aba20='1'
            LET g_aba.aba19 = 'Y'
#No.TQC-B70021 --begin 
            CALL s_chktic (p_bookno1,gl_no1) RETURNING l_success 
            IF NOT l_success THEN  
               LET g_aba.aba20 ='0' 
               LET g_aba.aba19 ='N' 
            END IF   
#No.TQC-B70021 --end 
           #LET g_sql = " UPDATE ",g_dbs_gl CLIPPED,"aba_file",   #FUN-A50102
            LET g_sql = " UPDATE ",cl_get_target_table(p_plant,'aba_file'),   #FUN-A50102 
                        "    SET abamksg = ? ,",
                               " abasign = ? ,",
                               " aba18   = ? ,",
                               " aba19   = ? ,",
                               " aba20   = ? ,",
                               " aba37   = ?  ",   #No.TQC-7B0086
                         " WHERE aba01 = ? AND aba00 = ? "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
            CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql   #FUN-A50102
            PREPARE upd_aba19_1 FROM g_sql
            EXECUTE upd_aba19_1 USING g_aba.abamksg,g_aba.abasign,
                                    g_aba.aba18  ,g_aba.aba19,
                                    g_aba.aba20  ,
                                    g_user,   #No.TQC-7B0086
                                    gl_no1       ,p_bookno1
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err('upd aba19',STATUS,1) LET g_success = 'N'
            END IF
         END IF   #MOD-770101
      END IF
END IF
       #No.FUN-CB0096 ---start--- Add
        LET l_time = TIME
        LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
        CALL s_log_data('I','113',g_id,'2',l_time,gl_no1,l_order)
        IF g_aba.abamksg = 'N' THEN
           LET l_time = TIME
           LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
           CALL s_log_data('I','107',g_id,'2',l_time,gl_no1,l_order)
        END IF
       #No.FUN-CB0096 ---end  --- Add
      LET gl_no1[g_no_sp-1,g_no_ep]=''
END REPORT

FUNCTION p400_create_tmp()
 DROP TABLE p400_tmp;


 SELECT npp02 dorder, chr30 order1,npq02 order2,   #FUN-8A0027 add order2
        npp_file.*,npq_file.*,  #No.MOD-840389
        chr1000 remark
   FROM npp_file,npq_file,type_file
  WHERE npp01 = npq01 AND npp01 = '@@@@' AND npp00 = npq00
    AND 1=0 
   INTO TEMP p400_tmp
 IF SQLCA.SQLCODE THEN
    LET g_success='N'
    CALL s_errmsg('','','create tmp1_file',SQLCA.SQLCODE,1)   #MOD-830249
 END IF
 DELETE FROM p400_tmp WHERE 1=1

END FUNCTION



FUNCTION chk_date()  #傳票日期抓npp02時要判斷的日期
  DEFINE l_npp            RECORD LIKE npp_file.*
  DEFINE l_npq            RECORD LIKE npq_file.*
  DEFINE l_aaa07  LIKE aaa_file.aaa07

  LET g_sql="SELECT npp_file.*,npq_file.* ",
            "  FROM npp_file,npq_file,apy_file",
            " WHERE nppsys= 'AP' AND nppglno IS NULL",
            "   AND npp01 = npq01 AND npp011=npq011",
            "   AND npp00 = npq00 ",     #TQC-750011
            "   AND ",g_wc CLIPPED,
            "   AND npp01 like ltrim(rtrim(apyslip)) || '-%' AND apydmy3='Y'", #MOD-980196
            "   AND nppsys=npqsys "
   PREPARE p400_1_p10 FROM g_sql
   IF STATUS THEN
      CALL cl_err('p400_1_p10',STATUS,1)
      CALL p400_tmn_del()   #MOD-820107
     #No.FUN-CB0096 ---start--- add
      LET l_time = TIME
      LET l_time = l_time[1,2],l_time[4,5],l_time[7,8]
      CALL s_log_data('U','100',g_id,'1',l_time,'','')
     #No.FUN-CB0096 ---end  --- add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE p400_1_c10 CURSOR WITH HOLD FOR p400_1_p10
   FOREACH p400_1_c10 INTO l_npp.*,l_npq.*
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      SELECT aaa07 INTO l_aaa07 FROM aaa_file
         WHERE aaa01 = p_bookno
      IF l_npp.npp02 <= l_aaa07 THEN
         CALL cl_err(l_npp.npp01,'axm-164',0)
         LET g_success = 'N'
      END IF
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file
         WHERE azn01 = l_npp.npp02
      IF STATUS THEN
         CALL cl_err3("sel","azn_file",l_npp.npp02,"",SQLCA.sqlcode,"","read azn",0)
         LET g_success = 'N'
      END IF
   END FOREACH
END FUNCTION

FUNCTION p400_tmn_del()
   DEFINE l_tmn02 LIKE tmn_file.tmn02
   DEFINE l_tmn06 LIKE tmn_file.tmn06
   FOREACH tmn_del INTO l_tmn02,l_tmn06
      DELETE FROM tmn_file
      WHERE tmn01 = p_plant
        AND tmn02 = l_tmn02
        AND tmn06 = l_tmn06
   END FOREACH
END FUNCTION
#No.FUN-9C0077 程式精簡
#CHI-AC0010

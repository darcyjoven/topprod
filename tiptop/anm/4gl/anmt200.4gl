# Prog. Version..: '5.30.06-13.03.21(00010)'     #
#
# Pattern name...: anmt200.4gl
# Descriptions...: 應收票據收票作業
# Date & Author..: 92/05/20 BY MAY
# 1994/11/29(Roger):付款銀行改Check nmt_file(全省銀行)
# Modify.........: 95/06/24 By Danny (當票面金額修改時,本幣金額重計)
# Modify	 : 95/08/24 by nick 1.新增時收票日default TODAY
#                                   2.到期日default blank
#                : 96/06/17 By Lynn     menu bar 增加一選項 T.異動記錄查詢
#                :                              (call anmq202)
#                : 97/12/23 By Apple    menu bar 增加一選項 D.沖帳記錄查詢
#                :                              (call anmq203)
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-470322 04/07/20 By Wiky 客戶編號輸入無法輸入(可查詢)
# MOdify.........: No.MOD-4A0252 04/10/19 By Smapmin 修正票別一開窗顯示資料
# Modify.........: No.FUN-4B0052 04/11/24 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# MOdify.........: No.MOD-4C0157 04/12/24 By Kitty  確認時 call s_chknpq 所傳的為 g_nmh.nmh01
#                                                   如為多筆確認時,會有問題,應該改成l_nmh01
# Modify.........: No.FUN-4C0098 05/01/12 By pengu 報表轉XML
# Modify.........: No.MOD-530663 05/03/28 By Smapmin 當輸入的收票單號的幣別等於本國幣別時,
#                                                    其本幣金額必須與原幣金額一致
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: No.MOD-580071 05/08/17 By Smapmin nmh24無 'X'的狀況,將相關判斷移除.
#                  收票單號幣別=本國幣別,本幣金額應與原幣金額不一致處理之修改.
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.MOD-590243 05/09/14 By Smapmin 已確認不可再產生分錄
# Modify.........: No.MOD-590373 05/09/19 By Dido nmh15 增加檢核 nmz08
# Modify.........: No.MOD-580306 05/09/29 By Smapmin 原幣金額不可為0
# Modify.........: No.MOD-590306 05/10/21 By Smapmin 取消確認時,沒有判斷在收款單身是否已有值
# Modify.........: No.MOD-5B0286 05/11/22 By kim 列印時,銀行簡稱應該改抓全省銀行檔
# Modify.........: NO.MOD-5B0188 05/11/24 BY yititng 新增時科目未default正確( 參數nmz11='N',部門欄位未經過前,可能直接確定離開
# Modify.........: NO.TQC-5B0148 05/11/17 BY yiting 確認過的資料還可以按"確認"
# Modify.........: No.MOD-5B0331 05/11/29 By Smapmin 查詢時收票單號開窗有誤
# Modify.........: No.FUN-630020 06/03/08 By pengu 流程訊息通知功能
# Modify.........: No.MOD-640249 04/04/10 By Claire 人員錯誤顯示部門錯誤
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-680034 06/08/24 By douzh 增加"票據科目編號二","對方科目編號二"欄位(nmh261,nmh271)
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-690023 06/09/13 By jamie 判斷occacti
# Modify.........: No.FUN-680034 06/09/19 By ice 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-6A0011 06/10/04 By jamie 1.FUNCTION t200_q() 一開始應清空g_nmh.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改 
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.TQC-6B0015 06/11/13 By xufeng 審核會報nmh38 update不成功
# Modify.........: No.FUN-6B0071 06/11/23 By Smapmin 顯示票別說明
# Modify.........: No.FUN-710024 07/01/30 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740028 07/04/10 By hongmei 會計科目加帳套
# Modify.........: No.TQC-740093 07/04/10 By hongmei 會計科目加帳套
# Modify.........: No.MOD-740469 07/04/26 By Smapmin 已拋轉傳票不可取消確認
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-750134 07/05/30 By kim 直接新增後,按列印,無法印出資料!
# Modify.........: No.FUN-770098 07/07/27 By rainy 填入日期後帶出星期幾/讓五六日能秀出來
# Modify.........: No.MOD-780073 07/08/13 By Smapmin 應收票據異動或收款沖帳作業若已作廢,皆視為未登打該應收票據
# Modify.........: No.MOD-790063 07/09/13 By Smapmin 修改錯誤訊息
# Modify.........: No.MOD-790064 07/09/13 By Smapmin 部門編號不可為空時,才預設部門
# Modify.........: No.MOD-7B0019 07/11/05 By Smapmin 重新過單
# Modify.........: No.TQC-7B0059 07/11/12 By wujie   到期日為周幾的寫法有錯
# Modify.........: No.TQC-7C0067 07/12/07 By Smapmin 修改星期幾的顯示方式
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810193 08/01/25 By Smapmin 修改抓取會科方式
# Modify.........: NO.FUN-830149 08/03/31 By zhaijie 報表輸出改為CR
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850038 08/05/09 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-860249 08/07/01 By Sarah 計算oob_file筆數時,應串ooa_file排除作廢的資料
# Modify.........: No.MOD-870008 08/07/08 By Sarah 新增時需檢查輸入單號是否正確
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.MOD-950093 09/05/12 By lilingyu AFTER FIELD nmh31段,檢查anm-109的sql未排除作廢資料
# Modify.........: No.CHI-960066 09/07/06 By mike 建議不要再最后才判斷l_flag='Y'跳到nmh03,而是在前面每一個欄位的判斷,當該欄位有問題>
# Modify.........: No.FUN-970071 09/07/27 By hongmei新增nmh41欄位
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.MOD-990211 09/10/18 By mike 檢查anm-095或anm-097訊息前,先判斷WEEKDAY(g_nmh.nmh09)是否為0(周日)或6(周六),      
# Modify.........: No.MOD-9C0271 09/12/24 By Sarah 1.CALL t200_ins_oma()重複寫了二次,造成寫入時key值重複
#                                                  2.使用多帳別功能時,CALL s_chknpq()檢查第二分錄時帳別應該傳g_bookno2
#                                                  3.取消確認時先檢查有oma_file資料才需刪除
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-A30124 10/08/03 By sabrina AFTER FIELD nmh08中的l_n=0應要l_n=6
# Modify.........: No:CHI-A80053 10/09/17 By Summer 入帳日數應該是工作天,改用s_aday()這個sub來取得計算後的日期
# Modify.........: No:MOD-A20064 10/10/05 By sabrina 會計科目不會自動帶出
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:MOD-AC0302 11/01/05 By lixia oma68,oma51f賦值，增加多帳期處理
# Modify.........: No:MOD-B10213 11/01/26 By Dido 確認段若無 g_wc 時,重新給予當下單號 
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:MOD-B30263 11/03/12 By wuxj  寫入 oma24 時,直接使用 nmh28
# Modify.........: No:FUN-B40003 11/04/01 By guoch 添加託收按鈕和取消託收按鈕
# Modify.........: No:FUN-B40011 11/04/11 By guoch 添加nmh42字段 轉付金額
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.CHI-B40058 11/05/17 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50090 11/05/18 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50065 11/06/09 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B70197 11/07/27 By guoch 托收功能只有在大陆版才能使用
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No.TQC-B80138 11/08/31 By Polly 修正date1顯示訊息
# Modify.........: No.TQC-B90237 11/09/29 By houlia 控管收票日期不能大於到期日期  
# Modify.........: No.CHI-B80059 11/10/18 By Polly 增加 nmh31/nmh05 傳遞至 rpt
# Modify.........: No.MOD-BB0146 11/11/15 By Polly 調整控卡aap-178設為警示提醒，不卡關
# Modify.........: No.MOD-BB0076 11/11/07 By Polly 取消地區限制，增加託收、取消託收action功能
# Modify.........: No.MOD-BB0220 11/11/22 By Dido 抓取日期邏輯調整 
# Modify.........: No.MOD-BC0007 11/12/01 By yinhy 點擊托收按鈕時，托貼日期不為空則托貼銀行必輸
# Modify.........: No.MOD-BC0076 11/12/08 By Polly 調整列印時接收變數
# Modify.........: No.MOD-C10039 12/01/06 By Elise nmh261預設值改為nms221, nmh271預設值改為nms211
# Modify.........: No.TQC-C10077 12/01/18 By zhangll 資料建立者,資料建立部門無法下查詢條件
# Modify.........: No.MOD-C10189 12/02/01 By Polly 取消託收時，需檢查是否有存在anmt250中
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30610 12/03/12 By minpp 若單別為屬於不拋轉轉票者,則不可將 nmh41 打勾
# Modify.........: No:MOD-C30499 12/03/12 By minpp 作業右側的ACTION托收以及取消托收,要往nmi_file中插入資料以及刪除資料
# Modify.........: No:TQC-C40033 12/04/06 by wujie t200_nmh15('a')写错
# Modify.........: No:TQC-C50033 12/05/07 By yinhy 流通版本，審核后應可以更改付款銀行
# Modify.........: No:FUN-C30200 12/04/23 by Lori 增加nmh26/nmh27科目名稱(nmh26_name/nmh27_name)
# Modify.........: No:TQC-C60132 12/06/15 By lujh 請參考anmt302作業，右側應提供【暫收款查詢】的串查功能鈕。
# Modify.........: No.FUN-C50136 12/07/10 By chenjing 增加審核時信用管控
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.TQC-C10083 12/10/09 By yinhy 更改時，修改部門和業務人員時，會清空會計科目資料
# Modify.........: No:MOD-C90092 12/10/12 By yinhy 提示報錯應不能更改審核狀態
# Modify.........: No.MOD-C80263 12/10/22 By Polly 調整anm-109控卡允許支票號碼重覆
# Modify.........: No.MOD-C90231 12/10/24 By wujie 将MOD-C10189分大陆/台湾条件
# Modify.........: No.MOD-CC0252 12/12/26 By Polly 預兌日期如為國定假日和例假日時，判斷順序為asmi400->anmi102->六日
# Modify.........: No.MOD-D10164 13/01/17 By yinhy 產生暫收賬款時對oma64和oma70賦值
# Modify.........: No:FUN-D20035 13/02/21 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.MOD-D30021 13/03/08 By Polly 調整控卡aap-178設為警示提醒，不卡關
# Modify.........: No.FUN-D40120 13/08/22 By yangtt 增加复制的功能
# Modify.........:               15/03/12 by liuxc  Anmt200中付款银行栏位改为手工录入，字符扩展为1000字符；
#                                                   出票人下方增加收款人全称，手工录入，字符扩展为1000字符；
#                                                    收票日期上方新增实际出票日期；手工录入
# Modify.........: NO:FUN-E80012 18/11/27 By lixwz 修改付款日期之後,tic現金流量明細重複

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nmh               RECORD LIKE nmh_file.*,
    g_nmh_t             RECORD LIKE nmh_file.*,
    g_nmh_o             RECORD LIKE nmh_file.*,
    g_nmh01_t           LIKE nmh_file.nmh01,
    g_nmh03_t           LIKE nmh_file.nmh03,
    g_nmh04_t           LIKE nmh_file.nmh04,
    g_nms               RECORD LIKE nms_file.*,
    g_nma11             LIKE nma_file.nma11,
    g_dept              LIKE aab_file.aab02,   #No.FUN-680107 VARCHAR(6)
    g_wc,g_sql          STRING,                #TQC-630166
    g_dbs_gl            LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,  #No.FUN-980025 VARCHAR(10)
    l_ans               LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
    l_wc,l_wc2	        LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(50)
    l_prtway	        LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
    g_no                LIKE nmh_file.nmh31,   #number
    l_cmd               LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(200)
    g_cmd               LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
    g_t1                LIKE oay_file.oayslip, #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
    g_nmydmy1           LIKE nmy_file.nmydmy1,
    g_nmydmy3           LIKE nmy_file.nmydmy3
 
DEFINE g_argv1          LIKE oea_file.oea01    #No.FUN-680107 VARCHAR(16) #No.FUN-630020 add
DEFINE g_argv2          STRING                 #No.FUN-630020 add
DEFINE g_forupd_sql     STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done   STRING
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_i              LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE g_msg            LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE g_str            STRING                 #No.FUN-680034
DEFINE g_wc_gl          STRING                 #No.FUN-680034
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE mi_no_ask        LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_void           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(01)
DEFINE g_bookno1        LIKE aza_file.aza81    #No.FUN-740028                                                                     
DEFINE g_bookno2        LIKE aza_file.aza82    #No.FUN-740028                                                                     
DEFINE g_flag           LIKE type_file.chr1    #No.FUN-740028
DEFINE l_table          STRING                 #NO.FUN-830149
DEFINE g_net            LIKE oox_file.oox10    #NO.MOD-AC0302
DEFINE g_nmi05          LIKE nmi_file.nmi05    #MOD-C30499
DEFINE g_nmi08          LIKE nmi_file.nmi08    #MOD-C30499
DEFINE g_nmi            RECORD LIKE nmi_file.* #MOD-C30499 
DEFINE g_nmh26_name     LIKE aag_file.aag02    #No.FUN-C30200
DEFINE g_nmh27_name     LIKE aag_file.aag02    #No.FUN-C30200
#DEFINE g_oaz96          LIKE oaz_file.oaz96    #No.FUN-C50136

MAIN
    DEFINE p_row,p_col  LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
    WHENEVER ERROR CALL cl_err_msg_log
    IF (NOT cl_setup("ANM")) THEN
       EXIT PROGRAM
    END IF
    LET g_plant_new = g_nmz.nmz02p
    LET g_plant_gl  = g_nmz.nmz02p    #No.FUN-980025
    CALL s_getdbs()
    LET g_dbs_gl = g_dbs_new
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
#  SELECT oaz96 INTO g_oaz96 FROM oaz_file WHERE oaz00 = '0'     #FUN-C50136   
   LET g_sql = "nmh01.nmh_file.nmh01,",
               "nmh06.nmh_file.nmh06,",
               "l_nma02.nma_file.nma02,",
               "nmh02.nmh_file.nmh02,",
               "l_nmo02.nmo_file.nmo02,",
               "nmh11.nmh_file.nmh11,",
               "nmh30.nmh_file.nmh30,",
               "l_sta1.ze_file.ze03,",
               "nmh28.nmh_file.nmh28,",
               "nmh26.nmh_file.nmh26,",
               "l_sta2.ze_file.ze03,",
               "t_azi04.azi_file.azi04,",
               "t_azi07.azi_file.azi07,",
               "nmh31.nmh_file.nmh31,",          #CHI-B80059 add
               "nmh05.nmh_file.nmh05"            #CHI-B80059 add
   LET l_table = cl_prt_temptable('anmt200',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?)"              #CHI-B80059 add 2個?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF         
    INITIALIZE g_nmh.* TO NULL
    INITIALIZE g_nmh_t.* TO NULL
    INITIALIZE g_nmh_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM nmh_file WHERE nmh01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW t200_w AT p_row,p_col
        WITH FORM "anm/42f/anmt200"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL cl_set_comp_visible("nmh261,nmh271",g_aza.aza63='Y')   #FUN-680034
    CALL cl_set_act_visible("entry_sheet2",g_aza.aza63='Y')     #FUN-680034
    LET g_no=ARG_VAL(1)
    LET g_cmd=ARG_VAL(5)
    LET g_argv1=ARG_VAL(1)          #No.FUN-630020 add
    LET g_argv2=ARG_VAL(2)          #No.FUN-630020 add
    IF g_no=' ' THEN LET g_no='' END IF
    IF g_cmd=' ' THEN LET g_cmd='' END IF
    IF g_cmd IS NOT NULL THEN
       IF g_cmd='a' THEN
          IF NOT cl_null(g_no) THEN
             SELECT COUNT(*) INTO g_cnt FROM nmh_file
              WHERE nmh31 = g_no
             IF g_cnt > 0 THEN                  # Duplicated
                CALL cl_err(g_nmh.nmh01,-239,1)
                EXIT PROGRAM
             END IF
           END IF
           CALL t200_a()
       ELSE
           CALL t200_q()
           CALL t200_u()
       END IF
    ELSE
       WHILE TRUE
         # 先以g_argv2判斷直接執行哪種功能
         # 執行I時，g_argv1是單號
         IF NOT cl_null(g_argv1) THEN
            CASE g_argv2
               WHEN "query"
                  LET g_action_choice = "query"
                  IF cl_chk_act_auth() THEN
                     CALL t200_q()
                  END IF
               WHEN "insert"
                  LET g_action_choice = "insert"
                  IF cl_chk_act_auth() THEN
                     CALL t200_a()
                  END IF
               OTHERWISE
                      CALL t200_q()
            END CASE
         END IF
         LET g_action_choice = ""
         CALL t200_menu()
         IF g_action_choice = "exit" THEN
            EXIT WHILE
         END IF
       END WHILE
    END IF
    CLOSE WINDOW t200_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t200_cs()
    CLEAR FORM
    IF g_no IS NULL OR cl_null(g_argv1) THEN        #No.FUN-630020 modify
   INITIALIZE g_nmh.* TO NULL    #No.FUN-750051
    	CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
              nmh01,nmh31,nmh04,nmh05,nmh03,nmh28,nmh02,nmh32,nmh06,nmh07,
              nmh08,nmh09,nmh10,nmh29,nmh11,nmh30,nmh41,nmh13,nmh14,nmh12,   #FUN-970071 addnmh41
              nmh15,nmh16,nmh22,nmh23,nmh19,
              nmh20,nmh21,nmh38,nmh24,nmh17,nmh25,nmh35,
              nmh18,nmh26,nmh261,nmh27,nmh271,nmh33,nmh34,  #FUN-680034 
              nmhuser,nmhgrup,nmhmodu,nmhdate,
              nmhoriu,nmhorig,   #TQC-C10077 add
              nmhud01,nmhud02,nmhud03,nmhud04,nmhud05,
              nmhud06,nmhud07,nmhud08,nmhud09,nmhud10,
              nmhud11,nmhud12,nmhud13,nmhud14,nmhud15,
              nmh42          #FUN-B40011
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
           ON ACTION CONTROLP
              CASE
                WHEN INFIELD(nmh01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nmh"
                   LET g_qryparam.state= "c"
                   LET g_qryparam.default1 = g_nmh.nmh01
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO nmh01
                   NEXT FIELD nmh01
                 WHEN INFIELD(nmh03) #幣別
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azi"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh03
                    NEXT FIELD nmh03
            #---start mark by liuxc150312----
               #  WHEN INFIELD(nmh06) #銀行代號
               #     CALL cl_init_qry_var()
               #     LET g_qryparam.form = "q_nmt"
               #     LET g_qryparam.state= "c"
               #     LET g_qryparam.default1 = g_nmh.nmh06
               #     CALL cl_create_qry() RETURNING g_qryparam.multiret
               #     DISPLAY g_qryparam.multiret TO nmh06
               #     CALL t200_nmh06('d')
               #     NEXT FIELD nmh06
        #----mark---end-------------
                 WHEN INFIELD(nmh11) #客戶代號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_occ"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh11
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh11
    		    CALL t200_nmh11('d')
                    NEXT FIELD nmh11
                 WHEN INFIELD(nmh12) #變動碼
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nml"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh12
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh12
                    CALL t200_nmh12('d')
                    NEXT FIELD nmh12
               WHEN INFIELD(nmh15) #部門
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh15
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh15
                    CALL t200_nmh15('d')
                    NEXT FIELD nmh15
                 WHEN INFIELD(nmh16) #人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh16
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh16
                    CALL t200_nmh16('d')
                    NEXT FIELD nmh16
                 WHEN INFIELD(nmh21) #銀行代號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nma1"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh21
                    LET g_qryparam.arg1 = g_nmh.nmh03
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh21
                    CALL t200_nmh21('d')
                    NEXT FIELD nmh21
                 WHEN INFIELD(nmh22) #廠商編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh22
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh22
                    NEXT FIELD nmh22
                 WHEN INFIELD(nmh26)
                    CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmh.nmh26,'23',g_bookno1)  #No.FUN-980025
                         RETURNING g_nmh.nmh26
                    #No.FUN-C30200--Begin---
                    IF cl_null(g_nmh.nmh26) THEN
                       LET g_nmh26_name = ''
                    ELSE
                       SELECT aag02 INTO g_nmh26_name from aag_file where aag01 = g_nmh.nmh26 AND aag00 = g_bookno1
                    END IF
                    #No.FUN-C30200--End---
                    DISPLAY BY NAME g_nmh.nmh26
                    DISPLAY g_nmh26_name TO nmh26_name   #No.FUN-C30200 
                    NEXT FIELD nmh26
                 WHEN INFIELD(nmh261)                                                                                                
                    CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmh.nmh261,'23',g_bookno2) #No.FUN-980025 
                         RETURNING g_nmh.nmh261                                                                                      
                    DISPLAY BY NAME g_nmh.nmh261 NEXT FIELD nmh261 
                 WHEN INFIELD(nmh27)
                    CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmh.nmh27,'23',g_bookno1)  #No.FUN-980025 
                         RETURNING g_nmh.nmh27
                    #No.FUN-C30200--Begin---
                    IF cl_null(g_nmh.nmh27) THEN
                       LET g_nmh27_name = ''
                    ELSE
                       SELECT aag02 INTO g_nmh27_name from aag_file where aag01 = g_nmh.nmh27 AND aag00 = g_bookno1
                    END IF
                    #No.FUN-C30200--End---
                    DISPLAY BY NAME g_nmh.nmh27
                    DISPLAY g_nmh27_name TO nmh27_name   #No.FUN-C30200 
                    NEXT FIELD nmh27
                 WHEN INFIELD(nmh271)                                                                                                
                    CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nmh.nmh271,'23',g_bookno2) #No.FUN-980025
                         RETURNING g_nmh.nmh271                                                                                      
                    DISPLAY BY NAME g_nmh.nmh271 NEXT FIELD nmh271
                 WHEN INFIELD(nmh10) #票別(一)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nmo01"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh10
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh10
                    NEXT FIELD nmh10
                 WHEN INFIELD(nmh29) #票別(二)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_nmo01"
                    LET g_qryparam.state= "c"
                    LET g_qryparam.default1 = g_nmh.nmh29
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nmh29
                    NEXT FIELD nmh29
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
    	IF INT_FLAG THEN RETURN END IF
    ELSE
        LET g_wc=' nmh01="',g_argv1,'"'      #No.FUN-630020 add     
    END IF
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nmhuser', 'nmhgrup')
 
    LET g_sql="SELECT nmh01 FROM nmh_file ", # 組合出 SQL 指令
        " WHERE ",g_wc CLIPPED, " ORDER BY nmh01"
    PREPARE t200_prepare FROM g_sql           # RUNTIME 編譯
    DECLARE t200_cs                         # SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t200_prepare
    LET g_sql=
        "SELECT COUNT(*) FROM nmh_file WHERE ",g_wc CLIPPED
    PREPARE t200_precount FROM g_sql
    DECLARE t200_count CURSOR FOR t200_precount
END FUNCTION
 
FUNCTION t200_menu()
    MENU ""
 
        BEFORE MENU
            #TQC-B70197 --begin
           #---------------MOD-BB0076-------------------------------------------------------mark
           #IF g_aza.aza26 <> '2' THEN
           #   CALL cl_set_act_visible("collection_discount,undo_collection_discount",FALSE)
           #END IF
           #---------------MOD-BB0076-------------------------------------------------------mark
            #TQC-B70197 --end
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
        ON ACTION insert
           LET g_action_choice="insert"
            IF cl_chk_act_auth() THEN
                 CALL t200_a()
            END IF
        ON ACTION query
            LET g_action_choice="query"
            IF cl_chk_act_auth() THEN
                 CALL t200_q()
            END IF
       #No.FUN-D40120 ---Add--- Start
        ON ACTION reproduce
           LET g_action_choice="reproduce"
           IF cl_chk_act_auth() THEN
              CALL t200_copy()
           END IF
       #No.FUN-D40120 ---Add--- End
        ON ACTION next
            CALL t200_fetch('N')
        ON ACTION previous
            CALL t200_fetch('P')
        ON ACTION modify
            LET g_action_choice="modify"
            IF cl_chk_act_auth() THEN
                 CALL t200_u()
            END IF
       ON ACTION confirm
          LET g_action_choice="confirm"
          IF cl_chk_act_auth() THEN
             CALL t200_firm1()
             IF g_nmh.nmh38 = 'X' THEN
                LET g_void = 'Y'
             ELSE
                LET g_void = 'N'
             END IF
             CALL cl_set_field_pic(g_nmh.nmh38,"","","",g_void,"")
          END IF
       ON ACTION undo_confirm
          LET g_action_choice="undo_confirm"
          IF cl_chk_act_auth() THEN
             CALL t200_firm2()
             IF g_nmh.nmh38 = 'X' THEN
                LET g_void = 'Y'
             ELSE
                LET g_void = 'N'
             END IF
             CALL cl_set_field_pic(g_nmh.nmh38,"","","",g_void,"")
          END IF
       ON ACTION void
          LET g_action_choice="void"
          IF cl_chk_act_auth() THEN
            #CALL t200_x()                        #FUN-D20035
             CALL t200_x(1)                       #FUN-D20035
             IF g_nmh.nmh38 = 'X' THEN
                LET g_void = 'Y'
                CALL cl_set_field_pic("","","","",g_void,"")
             ELSE
                LET g_void = 'N'
                CALL cl_set_field_pic(g_nmh.nmh38,"","","",g_void,"")
             END IF
          END IF

       #FUN-D20035---add--str
       #取消作废
       ON ACTION undo_void
          LET g_action_choice="void"
          IF cl_chk_act_auth() THEN
             CALL t200_x(2)            
             IF g_nmh.nmh38 = 'X' THEN
                LET g_void = 'Y'
                CALL cl_set_field_pic("","","","",g_void,"")
             ELSE
                LET g_void = 'N'
                CALL cl_set_field_pic(g_nmh.nmh38,"","","",g_void,"")
             END IF
          END IF
       #FUN-D20035---add--end      
       ON ACTION gen_entry
           LET g_action_choice="gen_entry"
          IF cl_chk_act_auth() THEN
             CALL t200_v('1')
          END IF
       ON ACTION entry_sheet
            LET g_action_choice="entry_sheet"
            IF cl_chk_act_auth() THEN #系統別、類別、單號、票面金額
               CALL s_showmsg_init()   #No.FUN-710024
               CALL s_fsgl('NM',2,g_nmh.nmh01,g_nmh.nmh02,g_nmz.nmz02b,
                         1,g_nmh.nmh38,'0', g_nmz.nmz02p)
               CALL s_showmsg()          #No.FUN-710024
               CALL t200_npp02('0')
            END IF
       CALL cl_navigator_setting( g_curs_index, g_row_count )
       ON ACTION entry_sheet2
            LET g_action_choice="entry_sheet2" 
            IF cl_chk_act_auth() THEN #系統別、類別、單號、票面金額
               CALL s_showmsg_init()   #No.FUN-710024
               CALL s_fsgl('NM',2,g_nmh.nmh01,g_nmh.nmh02,g_nmz.nmz02c,                                                               
                        1,g_nmh.nmh38,'1', g_nmz.nmz02p)                                                                           
               CALL s_showmsg()          #No.FUN-710024
               CALL t200_npp02('1')
            END IF
#@    ON ACTION 傳票拋轉
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         IF cl_chk_act_auth() THEN
            IF g_nmh.nmh38 ='Y' THEN
               CALL t200_carry_voucher()
            ELSE 
               CALL cl_err('','atm-402',1)
            END IF
         END IF
    
#@    ON ACTION 傳票拋轉還原
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         IF cl_chk_act_auth() THEN
            IF g_nmh.nmh38 ='Y' THEN
               CALL t200_undo_carry_voucher() 
            ELSE 
               CALL cl_err('','atm-403',1)
            END IF
         END IF
     
       #TQC-C60132--add--str--
       ON ACTION query_suspense_credit
          IF g_nmh.nmh41='Y' THEN
             LET l_cmd = "axrt300 '",g_nmh.nmh01,"' '' '24' "    
             CALL cl_cmdrun_wait(l_cmd CLIPPED)
          END IF
       #TQC-C60132--add--end--
         
       #NO.FUN-B40003--start--
       ON ACTION collection_discount
          LET g_action_choice="collection_discount"
          IF cl_chk_act_auth() THEN
             CALL t200_collection_discount()
          END IF
          
       ON ACTION undo_collection_discount
          LET g_action_choice="undo_collection_discount"
          IF cl_chk_act_auth() THEN
              CALL t200_undo_collection_discount()
          END IF
          
       #NO.FUN-B40003--end--         
         
       ON ACTION delete
            LET g_action_choice="delete"
            IF cl_chk_act_auth() THEN
                 CALL t200_r()
            END IF
       ON ACTION qry_transaction
            LET g_action_choice="qry_transaction"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "anmq202 '",g_nmh.nmh01,"'"
               CALL cl_cmdrun(l_cmd CLIPPED)
            END IF
       ON ACTION qry_contra
            LET g_action_choice="qry_contra"
            IF cl_chk_act_auth() THEN
               LET l_cmd = "anmq203 '",g_nmh.nmh01,"'"
               CALL cl_cmdrun(l_cmd CLIPPED)
            END IF
       ON ACTION output
             LET g_action_choice="output"
            IF cl_chk_act_auth()
               THEN CALL t200_out()
            END IF
        ON ACTION help
           CALL cl_show_help()
 
        ON ACTION locale
           CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           IF g_nmh.nmh38 = 'X' THEN
              LET g_void = 'Y'
              CALL cl_set_field_pic("","","","",g_void,"")
           ELSE
              LET g_void = 'N'
              CALL cl_set_field_pic(g_nmh.nmh38,"","","",g_void,"")
           END IF
        ON ACTION exit
            LET g_action_choice = 'exit'
            EXIT MENU
        ON ACTION jump
            CALL t200_fetch('/')
        ON ACTION first
            CALL t200_fetch('F')
        ON ACTION last
            CALL t200_fetch('L')
        ON ACTION CONTROLG
            CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
        ON ACTION related_document       #相關文件
           LET g_action_choice="related_document"
           IF cl_chk_act_auth() THEN
               IF g_nmh.nmh01 IS NOT NULL THEN
                  LET g_doc.column1 = "nmh01"
                  LET g_doc.value1 = g_nmh.nmh01
                  CALL cl_doc()
               END IF
           END IF
            LET g_action_choice = 'exit'
          CONTINUE MENU
 
        -- for Windows close event trapped
        ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
             LET INT_FLAG=FALSE 		#MOD-570244	mars
            LET g_action_choice = "exit"
            EXIT MENU
 
      &include "qry_string.4gl"
    END MENU
    CLOSE t200_cs
END FUNCTION
 
 
FUNCTION t200_a()
DEFINE   l_sta     LIKE ze_file.ze03   #No.FUN-680107 VARCHAR(04)  #TQC-840066
DEFINE li_result   LIKE type_file.num5   #No.FUN-550057 #No.FUN-680107 SMALLINT
 
    IF s_anmshut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                           # 清螢墓欄位內容
    INITIALIZE g_nmh.* LIKE nmh_file.*
    LET g_nmh_t.* = g_nmh.*
        LET g_nmh01_t = NULL
        LET g_nmh.nmh02 = 0              #票面金額
	LET g_nmh.nmh03 = g_aza.aza17
	LET g_nmh.nmh04 = g_today
	LET g_nmh.nmh11 = g_nmh_t.nmh11
	LET g_nmh.nmh10 = g_nmh_t.nmh10
	LET g_nmh.nmh29 = g_nmh_t.nmh29
        LET g_nmh.nmh15 = g_nmh_t.nmh15
        LET g_nmh.nmh16 = g_nmh_t.nmh16
	LET g_nmh.nmh17 = 0
	LET g_nmh.nmh05 = NULL                       #到期日
	LET g_nmh.nmh08 = 0
	LET g_nmh.nmh09 = NULL                       #預兌日
	LET g_nmh.nmh13 = 'N'
	LET g_nmh.nmh24 = '1'                        #票況
	LET g_nmh.nmh25 = g_today                    #異動日
	LET g_nmh.nmh28 = 1                          #收票匯率
	LET g_nmh.nmh38 = 'N'                        #收票匯率
        LET g_nmh.nmh41 = 'N'                        #暫收否 #FUN-970071
        LET l_sta = ' '
        LET g_nmh.nmh42 = 0                 #No.FUN-B40011
        DISPLAY BY NAME g_nmh.nmh42         #No.FUN-B40011
	CALL s_nmhsta(g_nmh.nmh24) RETURNING l_sta
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_nmh.nmhuser = g_user
        LET g_nmh.nmhoriu = g_user #FUN-980030
        LET g_nmh.nmhorig = g_grup #FUN-980030
        LET g_nmh.nmhgrup = g_grup               #使用者所屬群
        LET g_nmh.nmhdate = g_today
        IF g_cmd IS NOT NULL THEN
        	LET g_nmh.nmh31=g_no	       #Note Recevable Order Number
        	LET g_nmh.nmh02=ARG_VAL(2)     #Amount
        	LET g_nmh.nmh03=ARG_VAL(3)     #Currency
        	LET g_nmh.nmh28=ARG_VAL(4)     #Exchange Rate
        	LET g_nmh.nmh11=ARG_VAL(6)     #Customer
        	LET g_nmh.nmh16=ARG_VAL(7)     #Receiver
        	LET g_nmh.nmh17=ARG_VAL(8)     #Receive Order Number
        	LET g_nmh.nmh18=ARG_VAL(9)     #Remark(A/R)
        END IF
        CALL t200_i("a")                       # 各欄位輸入
        IF INT_FLAG THEN                       # 若按了DEL鍵
            LET INT_FLAG = 0
            INITIALIZE g_nmh.* TO NULL
            CALL cl_err('',9001,0)
            CLEAR FORM
            EXIT WHILE
        END IF
        BEGIN WORK
        CALL s_auto_assign_no("anm",g_nmh.nmh01,g_nmh.nmh04,"2","nmh_file","nmh01","","","")
             RETURNING li_result,g_nmh.nmh01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_nmh.nmh01
         LET g_nmh.nmh39=g_nmh.nmh28
         LET g_nmh.nmh40=(g_nmh.nmh02-g_nmh.nmh17)*g_nmh.nmh39
         LET g_nmh.nmh40 = cl_digcut(g_nmh.nmh40,g_azi04)
        LET g_success = 'Y'
 
        LET g_nmh.nmhlegal = g_legal 
        
        IF cl_null(g_nmh.nmh42) THEN LET g_nmh.nmh42 = 0 END IF  #No.FUN-B40011
 
        INSERT INTO nmh_file VALUES(g_nmh.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148  #No.FUN-B80067---調整至回滾事務前---
           ROLLBACK WORK  #No.7875
           CONTINUE WHILE
        ELSE
            LET g_nmh_t.* = g_nmh.*                # 保存上筆資料
            SELECT nmh01 INTO g_nmh.nmh01 FROM nmh_file
                WHERE nmh01 = g_nmh.nmh01
            #新增一筆資料時必需加一筆異動資料到票據異動記錄檔中
            CALL t200_hu(0,1)
            IF g_success = 'Y'
               THEN CALL cl_cmmsg(1) COMMIT WORK
                    CALL cl_flow_notify(g_nmh.nmh01,'I')
               ELSE CALL cl_rbmsg(1) ROLLBACK WORK
            END IF
            #---判斷是否立即confirm-----
           LET g_t1 = s_get_doc_no(g_nmh.nmh01)       #No.FUN-550057
            SELECT nmydmy1,nmydmy3 INTO g_nmydmy1,g_nmydmy3
              FROM nmy_file
             WHERE nmyslip = g_t1 AND nmyacti = 'Y'
            IF g_nmy.nmydmy3 = 'Y' THEN
               IF cl_confirm('axr-309') THEN
                  CALL t200_v('2')
               END IF
            END IF
            IF g_nmydmy1 = 'Y' AND g_nmydmy3='N' THEN CALL t200_firm1() END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t200_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
        l_direct        LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
        l_direct1       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
        l_direct2       LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
        l_ans           LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01)
        l_sta           LIKE aab_file.aab02,   #No.FUN-680107 VARCHAR(06)
        l_n             LIKE type_file.num10,  #No.FUN-680107 INTEGER
        l_i             LIKE type_file.num5,   #MOD-990211    
        l_count         LIKE type_file.num5,   #No.FUN-680107 SMALLINT
        g_t1            LIKE nmh_file.nmh01,   #No.FUN-550057  #No.FUN-680107 VARCHAR(05)
        old_nmh02       LIKE nmh_file.nmh02,
        l_nmo02         LIKE nmo_file.nmo02,   #票別說明
        l_nmz08         LIKE nmz_file.nmz08,    #應收票據部門是否為空白 MOD-590373
        l_nmydmy3       LIKE nmy_file.nmydmy3  #MOD-C30610 ADD
 
    DEFINE li_result   LIKE type_file.num5     #No.FUN-550057  #No.FUN-680107 SMALLINT
    DEFINE l_sdate     LIKE type_file.dat      #CHI-A80053 add
 
    INPUT BY NAME g_nmh.nmhoriu,g_nmh.nmhorig,
           g_nmh.nmh01,g_nmh.nmh31,g_nmh.nmhud13,g_nmh.nmh04,g_nmh.nmh05, #zhouxm151010 add g_nmh.nmhud13,
           g_nmh.nmh03,g_nmh.nmh28,g_nmh.nmh02,g_nmh.nmh32,
           g_nmh.nmh06,g_nmh.nmh07,g_nmh.nmh08,g_nmh.nmh09,
           g_nmh.nmh10,g_nmh.nmh29,g_nmh.nmh11,g_nmh.nmh30,
           g_nmh.nmh41,g_nmh.nmh13,  #FUN-970071 nmh41
           g_nmh.nmh14,g_nmh.nmh12,g_nmh.nmh15,g_nmh.nmh16,g_nmh.nmh22,
           g_nmh.nmh23,g_nmh.nmh19,
#          g_nmh.nmh20,             #FUN-B40003
           g_nmh.nmh21,g_nmh.nmh24,g_nmh.nmh17,
           g_nmh.nmh25, g_nmh.nmh35, g_nmh.nmh18, g_nmh.nmh38,
	   g_nmh.nmh26,g_nmh.nmh261,g_nmh.nmh27,g_nmh.nmh271,g_nmh.nmh33,g_nmh.nmh34,      #FUN-680034
           g_nmh.nmhuser,g_nmh.nmhgrup,g_nmh.nmhmodu,g_nmh.nmhdate,
           g_nmh.nmhud01,g_nmh.nmhud02,g_nmh.nmhud03,g_nmh.nmhud04,
           g_nmh.nmhud05,g_nmh.nmhud06,g_nmh.nmhud07,g_nmh.nmhud08,
           g_nmh.nmhud09,g_nmh.nmhud10,g_nmh.nmhud11,g_nmh.nmhud12,
           #g_nmh.nmhud13,g_nmh.nmhud14,g_nmh.nmhud15  #zhouxm151010 mark
           g_nmh.nmhud14,g_nmh.nmhud15  #zhouxm151010 add 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t200_set_entry(p_cmd)
            CALL t200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("nmh01")
         CALL cl_set_docno_format("nmh33")
          #MOD-C30610--ADD--STR 
          IF NOT cl_null(g_nmh.nmh01) THEN
             CALL s_get_doc_no(g_nmh.nmh01) RETURNING g_t1 
             SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip=g_t1
             IF l_nmydmy3='N' THEN
                LET g_nmh.nmh41='N'
                CALL cl_set_comp_entry('nmh41',FALSE)
             ELSE
                CALL cl_set_comp_entry('nmh41',TRUE)
             END IF
          END IF     
         CALL cl_set_comp_entry('nmh41',TRUE)  #141215wudj 在应收票据作业anmt200中，点击‘新增’按钮，将栏位暂收nmh41改为可以手工勾选lixia； 
         CALL cl_set_comp_required('nmh06',FALSE)  #zhouxm151010 add 
          #MOD-C30610--ADD--end
        AFTER FIELD nmh01
           IF cl_null(g_nmh.nmh01) THEN                                                                                             
              CALL cl_err('','9033',0)                                                                                              
              NEXT FIELD nmh01                                                                                                      
           END IF                                                                                                                   
           IF (p_cmd='a' AND NOT cl_null(g_nmh.nmh01)) OR                      #MOD-870008
              (p_cmd='u' AND g_nmh.nmh01 != g_nmh_t.nmh01) THEN                #MOD-870008
           CALL s_check_no("anm",g_nmh.nmh01,g_nmh01_t,"2","nmh_file","nmh01","")
             RETURNING li_result,g_nmh.nmh01
           DISPLAY BY NAME g_nmh.nmh01
           IF (NOT li_result) THEN
              NEXT FIELD nmh01
           END IF
           END IF
           #MOD-C30610--ADD--STR
           IF NOT cl_null(g_nmh.nmh01) THEN
              CALL s_get_doc_no(g_nmh.nmh01) RETURNING g_t1
              SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip=g_t1
              IF l_nmydmy3='N' THEN
                 LET g_nmh.nmh41='N'
                 CALL cl_set_comp_entry('nmh41',FALSE)
              ELSE
                 CALL cl_set_comp_entry('nmh41',TRUE)
              END IF
           END IF
           CALL cl_set_comp_entry('nmh41',TRUE)  #141215wudj 在应收票据作业anmt200中，点击‘新增’按钮，将栏位暂收nmh41改为可以手工勾选lixia； 
           #MOD-C30610--ADD--end
 
       #-----------------------MOD-C80263---------------------mark
       #AFTER FIELD nmh31
       #   IF NOT cl_null(g_nmh.nmh31) THEN
       #      IF p_cmd = 'a' OR g_nmh.nmh31 != g_nmh_t.nmh31 THEN
       #         SELECT count(*) INTO l_count
       #           FROM nmh_file
       #          WHERE nmh31=g_nmh.nmh31 AND nmh01!=g_nmh.nmh01
       #            AND nmh38 != 'X'      #MOD-950093
       #         IF l_count > 0 THEN
       #            CALL cl_err('nmh31','anm-109',0)
       #            LET g_nmh.nmh31 = g_nmh_t.nmh31
       #            DISPLAY BY NAME g_nmh.nmh31
       #            NEXT FIELD nmh31
       #         END IF
       #      END IF
       #      LET old_nmh02 = g_nmh.nmh02
       #   END IF
       #-----------------------MOD-C80263---------------------mark
 
        AFTER FIELD nmh04   #收票日
            IF NOT cl_null(g_nmh.nmh04) THEN
               IF g_nmh.nmh04 <= g_nmz.nmz10 THEN  #no.5261
                  CALL cl_err('','aap-176',1) NEXT FIELD nmh04
               END IF
#TQC-B90237 --begin
               IF g_nmh.nmh04 > g_nmh.nmh05 THEN 
                  CALL cl_err('','aap-178',1) 
                 #NEXT FIELD nmh04                         #MOD-D30021 mark
               END IF 
#TQC-B90237 --end
               LET g_nmh_o.nmh04 = g_nmh.nmh04
               LET g_nmh.nmh25 = g_nmh.nmh04 #預設異動日期
               DISPLAY BY NAME g_nmh.nmh25
               CALL s_get_bookno(YEAR(g_nmh.nmh04)) RETURNING g_flag,g_bookno1,g_bookno2         #No.TQC-740093                                                
               IF g_flag =  '1' THEN  #抓不到帳別                                                                                    
                  CALL cl_err(g_nmh.nmh04,'aoo-081',1)                                                                                   
                 #NEXT FIELD nmh04                   #MOD-BB0146 mark
               END IF                                                                                                                
              #-------------------------MOD-C80263---------------------(S)
               IF NOT cl_null(g_nmh.nmh31) THEN
                  IF p_cmd = 'a' OR g_nmh.nmh31 != g_nmh_t.nmh31 THEN
                     LET l_count = 0
                     SELECT COUNT(*) INTO l_count
                       FROM nmh_file
                      WHERE nmh31 = g_nmh.nmh31
                        AND nmh01 != g_nmh.nmh01
                        AND nmh38 != 'X'
                        AND nmh04 < g_nmh.nmh04
                        AND nmh24 NOT IN ('6','7','9')
                     IF cl_null(l_count) THEN LET l_count = 0 END If
                     IF l_count > 0 THEN
                        CALL cl_err('nmh31','anm-109',0)
                        LET g_nmh.nmh31 = g_nmh_t.nmh31
                        DISPLAY BY NAME g_nmh.nmh31
                        NEXT FIELD nmh31
                     END IF
                     LET l_count = 0
                     SELECT COUNT(*) INTO l_count
                       FROM nmh_file
                      WHERE nmh31 = g_nmh.nmh31
                        AND nmh01 != g_nmh.nmh01
                        AND nmh38 != 'X'
                        AND nmh04 > g_nmh.nmh04
                     IF cl_null(l_count) THEN LET l_count = 0 END If
                     IF l_count > 0 THEN
                        CALL cl_err('nmh31','anm-109',0)
                        LET g_nmh.nmh31 = g_nmh_t.nmh31
                        DISPLAY BY NAME g_nmh.nmh31
                        NEXT FIELD nmh31
                     END IF
                  END IF
                  LET old_nmh02 = g_nmh.nmh02
               END IF
              #-------------------------MOD-C80263---------------------(E)
            END IF
 
        AFTER FIELD nmh05   #到期日
            IF cl_null(g_nmh.nmh05) THEN                                                                                            
               CALL cl_err('','9033',0)                                                                                             
               NEXT FIELD nmh05                                                                                                     
            END IF
#TQC-B90237 --begin
               IF g_nmh.nmh05 < g_nmh.nmh04 THEN 
                  CALL cl_err('','aap-178',1) 
                 #NEXT FIELD nmh05                    #MOD-BB0146 mark
               END IF 
#TQC-B90237 --end                                                                                                                  
            IF NOT cl_null(g_nmh.nmh05) THEN
               CALL t200_week(g_nmh.nmh05,'1')
               LET g_nmh_o.nmh05 = g_nmh.nmh05
            END IF
 
        AFTER FIELD nmh03
            IF cl_null(g_nmh.nmh03) THEN                                                                                            
               CALL cl_err('','9033',0)                                                                                             
               NEXT FIELD nmh03                                                                                                     
            END IF                                                                                                                  
            IF NOT cl_null(g_nmh.nmh03) THEN
               SELECT azi04 INTO t_azi04 FROM azi_file
                 WHERE azi01 = g_nmh.nmh03
                 AND aziacti IN ('Y','y')
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("sel","azi_file",g_nmh.nmh03,"","anm-007","","",1)  #No.FUN-660148
                  NEXT FIELD nmh03
               END IF
               IF g_nmh.nmh03 != g_aza.aza17 THEN
                  CALL s_curr3(g_nmh.nmh03,g_nmh.nmh04,'B')
                       RETURNING g_nmh.nmh28
                  DISPLAY BY NAME g_nmh.nmh28
               END IF
               LET g_nmh.nmh32 = g_nmh.nmh02 * g_nmh.nmh28
               LET g_nmh.nmh32 = cl_digcut(g_nmh.nmh32,g_azi04)
               DISPLAY BY NAME g_nmh.nmh32
               LET g_nmh_o.nmh03 = g_nmh.nmh03
            END IF
 
 
 
        AFTER FIELD nmh02
            IF cl_null(g_nmh.nmh02) OR g_nmh.nmh02<=0 THEN                                                                          
               CALL cl_err('','9033',0)                                                                                             
               NEXT FIELD nmh02                                                                                                     
            END IF                                                                                                                  
            IF g_nmh.nmh02 <= 0 THEN
               CALL cl_err('','anm-249',0)
               NEXT FIELD nmh02
            END IF
            IF NOT cl_null(g_nmh.nmh02) THEN
               CALL cl_digcut(g_nmh.nmh02,t_azi04) RETURNING g_nmh.nmh02
               LET g_nmh.nmh32 = g_nmh.nmh02 * g_nmh.nmh28
               LET g_nmh.nmh32 = cl_digcut(g_nmh.nmh32,g_azi04)
               DISPLAY BY NAME g_nmh.nmh02
               DISPLAY BY NAME g_nmh.nmh32
               LET g_nmh_o.nmh02 = g_nmh.nmh02
            END IF
 
 
 
       AFTER FIELD nmh06    #付款銀行
            IF cl_null(g_nmh.nmh06) THEN                                                                                            
               CALL cl_err('','9033',0)                                                                                             
               NEXT FIELD nmh06                                                                                                     
            END IF 
#-start--mark--by liuxc150312-------------            
            #IF NOT cl_null(g_nmh.nmh06) THEN
              # CALL t200_nmh06('a')
              # IF NOT cl_null(g_errno) THEN
              #    CALL cl_err(g_nmh.nmh06,g_errno,0)
              #    LET g_nmh.nmh06 = g_nmh_o.nmh06
              #    DISPLAY BY NAME g_nmh.nmh06
              #    NEXT FIELD nmh06
              # END IF
              # LET g_nmh_o.nmh06 = g_nmh.nmh06
           # END IF
#----end--mark-------
 
       AFTER FIELD nmh08    #入帳日數
            IF NOT cl_null(g_nmh.nmh08) THEN
               #CHI-A80053 mark --start--
               #IF g_nmh.nmh05 > g_nmh.nmh04
               #THEN LET g_nmh.nmh09 = g_nmh.nmh05 + g_nmh.nmh08
               #ELSE LET g_nmh.nmh09 = g_nmh.nmh04 + g_nmh.nmh08
               #END IF
               #CHI-A80053 mark --end--
               #CHI-A80053 add --start--
               IF g_nmh.nmh05 > g_nmh.nmh04 THEN
                  CALL s_aday(g_nmh.nmh05,1,g_nmh.nmh08) RETURNING g_nmh.nmh09
               ELSE
                  CALL s_aday(g_nmh.nmh04,1,g_nmh.nmh08) RETURNING g_nmh.nmh09
               END IF
               #CHI-A80053 add --end--
              #--------------------MOD-CC0252-----------------------(S)
               FOR l_i = 1 TO 30
                  SELECT nph02 INTO g_msg FROM nph_file
                   WHERE nph01 = g_nmh.nmh09
                  IF STATUS = 0 THEN
                     LET g_nmh.nmh09 = g_nmh.nmh09+1
                  ELSE
                     EXIT FOR
                  END IF
               END FOR
              #--------------------MOD-CC0252-----------------------(E)
               #CHI-A80053 mark --start--
               #-MOD-BB0220-remark-
                LET l_n = WEEKDAY(g_nmh.nmh09)	# 若為週日
                IF l_n=0 THEN 
               #   LET g_nmh.nmh08 = g_nmh.nmh08 + 1                                                                                 
                   LET g_nmh.nmh09 = g_nmh.nmh09 + 1   
                END IF
              # IF l_n=0 THEN    #MOD-A30124 mark  
                IF l_n=6 THEN    #MOD-A30124 add 
               #   LET g_nmh.nmh08 = g_nmh.nmh08 + 2                                                                                 
                   LET g_nmh.nmh09 = g_nmh.nmh09 + 2  
                END IF
               #-MOD-BB0220-end-
               #CHI-A80053 mark --end-- 
              #--------------------MOD-CC0252-----------------------mark
              #FOR l_i = 1 TO 30 #MOD-990211   
              #   SELECT nph02 INTO g_msg FROM nph_file WHERE nph01=g_nmh.nmh09
              #   IF STATUS = 0 THEN
              #      LET g_nmh.nmh09=g_nmh.nmh09+1                                                                                 
              #   ELSE                                                                                                             
              #      EXIT FOR                                                                                                      
              #   END IF
              #END FOR  #MOD-990211                                                                                                 
              #--------------------MOD-CC0252-----------------------mark
              #-MOD-BB0220-add-
               IF g_nmh.nmh05 > g_nmh.nmh04 THEN 
                  LET l_sdate = g_nmh.nmh05
               ELSE 
                  LET l_sdate = g_nmh.nmh04
               END IF
               SELECT COUNT(*) INTO g_nmh.nmh08 
                FROM sme_file WHERE sme01 > l_sdate AND sme01 <= g_nmh.nmh09
	         AND sme02 IN ('Y','y')
               IF SQLCA.sqlcode != 0 THEN  
                  CALL cl_err('cannot select sme_file',SQLCA.sqlcode,0)
               END IF
              #-MOD-BB0220-end-
               DISPLAY BY NAME g_nmh.nmh08   #MOD-990211     
               DISPLAY BY NAME g_nmh.nmh09
               CALL t200_week(g_nmh.nmh09,'2')
               LET g_nmh_o.nmh08 =  g_nmh.nmh08
            END IF
 
       AFTER FIELD nmh09  #預兌日
           IF NOT cl_null(g_nmh.nmh09) THEN
              #CHI-A80053 mark --start--
              #LET l_n = WEEKDAY(g_nmh.nmh09)	# 若為週日
              #IF l_n=0 THEN 
              #   LET g_nmh.nmh08 = g_nmh.nmh08 + 1                                                                                  
              #   LET g_nmh.nmh09 = g_nmh.nmh09 + 1  
              #END IF 
              #IF l_n=6 THEN   #若為周六                                                                                             
              #   LET g_nmh.nmh08 = g_nmh.nmh08 + 2                                                                                  
              #   LET g_nmh.nmh09 = g_nmh.nmh09 + 2                                                                                  
              #END IF        
              #CHI-A80053 mark --end--
              #CHI-A80053 add --start--
              IF g_nmh.nmh05 > g_nmh.nmh04 THEN 
                 LET l_sdate = g_nmh.nmh05
              ELSE 
                 LET l_sdate = g_nmh.nmh04
              END IF
              LET g_nmh.nmh08 = 0 
              SELECT COUNT(*) INTO g_nmh.nmh08 
               FROM sme_file WHERE sme01 > l_sdate AND sme01 <= g_nmh.nmh09
		AND sme02 IN ('Y','y')
              IF SQLCA.sqlcode != 0 THEN  
                 CALL cl_err('cannot select sme_file',SQLCA.sqlcode,0)
              END IF
              #CHI-A80053 add --end--
              FOR l_i = 1 TO 30
                 SELECT nph02 INTO g_msg FROM nph_file WHERE nph01=g_nmh.nmh09
                 IF STATUS=0 THEN 
                    LET g_nmh.nmh09=g_nmh.nmh09+1                                                                                   
                 ELSE                                                                                                               
                    EXIT FOR                                                                                                        
                 END IF
              END FOR #MOD-990211      
             #--------------------MOD-CC0252-----------------------(S)
              LET l_n = WEEKDAY(g_nmh.nmh09)  # 若為週日
              IF l_n = 0 THEN
                 LET g_nmh.nmh09 = g_nmh.nmh09 + 1
              END IF
              IF l_n = 6 THEN
                 LET g_nmh.nmh09 = g_nmh.nmh09 + 2
              END IF
             #--------------------MOD-CC0252-----------------------(E)
              CALL t200_week(g_nmh.nmh09,'2')
              LET g_nmh_o.nmh09 =  g_nmh.nmh09
              #CHI-A80053 mark --start--
              #IF g_nmh.nmh05 > g_nmh.nmh04
              #   THEN LET g_nmh.nmh08 = g_nmh.nmh09 - g_nmh.nmh05
              #   ELSE LET g_nmh.nmh08 = g_nmh.nmh09 - g_nmh.nmh04
              #END IF
              #CHI-A80053 mark --end--
              DISPLAY BY NAME g_nmh.nmh08
              DISPLAY BY NAME g_nmh.nmh09   #MOD-990211     
           END IF
 
       AFTER FIELD nmh10  #票別(一)
           IF NOT cl_null(g_nmh.nmh10) THEN
              SELECT nmo02 INTO l_nmo02 FROM  nmo_file WHERE nmo01 = g_nmh.nmh10
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","nmo_file",g_nmh.nmh10,"","anm-086","","",1)  #No.FUN-660148
                 LET g_nmh.nmh10 =g_nmh_o.nmh10
                 NEXT FIELD nmh10
              END IF
              DISPLAY l_nmo02 TO w1
              LET g_nmh_o.nmh10 =  g_nmh.nmh10
           END IF
 
       AFTER FIELD nmh29  #票別(二)
          IF NOT cl_null(g_nmh.nmh29) THEN
             SELECT nmo02 INTO l_nmo02 FROM  nmo_file WHERE nmo01 = g_nmh.nmh29
             IF STATUS THEN
                CALL cl_err3("sel","nmo_file",g_nmh.nmh29,"","anm-086","","",1)  #No.FUN-660148
                LET g_nmh.nmh29 =g_nmh_o.nmh29
                NEXT FIELD nmh29
             END IF
             DISPLAY l_nmo02 TO w2
             LET g_nmh_o.nmh29 =  g_nmh.nmh29
          END IF
 
       BEFORE FIELD nmh11 #客戶編號
          CALL t200_set_entry(p_cmd)
 
       AFTER FIELD nmh11 #客戶編號
            IF cl_null(g_nmh.nmh11) THEN                                                                                            
               CALL cl_err('','9033',0)                                                                                             
               NEXT FIELD nmh11                                                                                                     
            END IF                                                                                                                  
            IF NOT cl_null(g_nmh.nmh11) THEN
              IF g_nmh.nmh11 != 'MISC' THEN
                 CALL t200_nmh11('')
                 IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_nmh.nmh11,g_errno,0)
                         LET g_nmh.nmh11 = g_nmh_t.nmh11  #No.MOD-470322
                        DISPLAY BY NAME g_nmh.nmh11
                        NEXT FIELD nmh11
                 END IF
               END IF
               LET g_nmh_o.nmh11 =  g_nmh.nmh11
           END IF
           CALL t200_set_no_entry(p_cmd)
 
        AFTER FIELD nmh13  #客票
            LET g_nmh_o.nmh13 = g_nmh.nmh13
 
        AFTER FIELD nmh12
            IF NOT cl_null(g_nmh.nmh12) THEN
               CALL t200_nmh12('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD nmh12
               END IF
            END IF
 
       BEFORE FIELD nmh15   #部門
           SELECT nmz08 INTO l_nmz08
             FROM nmz_file
            WHERE nmz00 = '0';
 
        AFTER FIELD nmh15   #部門
          IF p_cmd = 'a' OR g_nmh.nmh15 != g_nmh_t.nmh15 THEN  #TQC-C10083
            IF cl_null(g_nmh.nmh15) AND g_nmz.nmz08='N' THEN                                                                        
               CALL cl_err('','9033',0)                                                                                             
               NEXT FIELD nmh15                                                                                                     
            END IF                                                                                                                  
#              CALL t200_nmh15('a')
               CALL t200_nmh15(p_cmd)   #No.TQC-C40033
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nmh.nmh15,g_errno,0)
                  LET g_nmh.nmh15 = g_nmh_o.nmh15
                  DISPLAY BY NAME g_nmh.nmh15
                  NEXT FIELD nmh15
               END IF
               LET g_nmh_o.nmh15 = g_nmh.nmh15
               IF l_nmz08 = 'N' AND cl_null(g_nmh.nmh15) THEN   #MOD-810193
                  CALL cl_err(g_nmh.nmh15,'afa-091',1)
                  NEXT FIELD nmh15
               END IF
#              CALL t200_nmh15('a')   #FUN-970071 
               CALL t200_nmh15(p_cmd)   #No.TQC-C40033
            END IF  #TQC-C10083
 
        AFTER FIELD nmh16   #人員
	    IF NOT cl_null(g_nmh.nmh16) THEN
               CALL t200_nmh16('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_nmh.nmh16,g_errno,0)
                  LET g_nmh.nmh16 = g_nmh_o.nmh16
                  DISPLAY BY NAME g_nmh.nmh16
                  NEXT FIELD nmh16
               END IF
               LET g_nmh_o.nmh16 = g_nmh.nmh16
            END IF
 
        AFTER FIELD nmh19  #託貼
            IF NOT cl_null(g_nmh.nmh19) AND g_nmh.nmh19 <'5' THEN
               LET g_nmh.nmh24=g_nmh.nmh19
               DISPLAY BY NAME g_nmh.nmh24
               IF g_nmh.nmh20 IS NULL THEN
                  LET g_nmh.nmh20=g_nmh.nmh04
                  DISPLAY BY NAME g_nmh.nmh20
               END IF
            END IF
 
        AFTER FIELD nmh21  #託貼銀行
            IF g_nmh.nmh19 IS NOT NULL AND g_nmh.nmh21 IS NULL THEN
               NEXT FIELD nmh21
            END IF
            IF g_nmh.nmh21 IS NOT NULL THEN
               CALL t200_nmh21('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_nmh.nmh21,g_errno,0)
                   LET g_nmh.nmh21 = g_nmh_o.nmh21
                   DISPLAY BY NAME g_nmh.nmh21
                   NEXT FIELD nmh21
               END IF
            END IF
            LET g_nmh_o.nmh21 = g_nmh.nmh21
 
        AFTER FIELD nmh28
            IF cl_null(g_nmh.nmh28) OR g_nmh.nmh28<=0 THEN                                                                          
               CALL cl_err('','9033',0)                                                                                             
               NEXT FIELD nmh28                                                                                                     
            END IF                                                                                                                  
           IF g_nmh.nmh24 = '1' THEN
              LET g_nmh.nmh32 = g_nmh.nmh02 * g_nmh.nmh28
              LET g_nmh.nmh32 = cl_digcut(g_nmh.nmh32,g_azi04)
              DISPLAY BY NAME g_nmh.nmh32
           END IF
 
            IF g_nmh.nmh03 =g_aza.aza17 THEN
               LET g_nmh.nmh28 =1
               DISPLAY BY NAME g_nmh.nmh28
            END IF
 
 
        AFTER FIELD nmh32
           IF g_nmh.nmh32 <=0 THEN NEXT FIELD nmh32 END IF
           IF g_nmh.nmh03 = g_aza.aza17 THEN
              IF g_nmh.nmh02 <> g_nmh.nmh32 THEN
                CALL cl_err(g_nmh.nmh32,'anm-020',1)
                 LET g_nmh.nmh02 = g_nmh.nmh32   #MOD-580071
                 DISPLAY BY NAME g_nmh.nmh02   #MOD-580071
              END IF
           END IF
           IF NOT cl_null(g_nmh.nmh32) THEN
              LET g_nmh.nmh32 = cl_digcut(g_nmh.nmh32,g_azi04)
              DISPLAY BY NAME g_nmh.nmh32
           END IF
 
        AFTER FIELD nmh26
           IF g_nmz.nmz02 = 'Y' AND g_nmh.nmh26 IS NOT NULL THEN
              CALL s_m_aag(g_nmz.nmz02p,g_nmh.nmh26,g_bookno1) RETURNING g_msg   #No.FUN-740028   #FUN-990069 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmh.nmh26,'23',g_bookno1) 
                       RETURNING g_nmh.nmh26
                  DISPLAY BY NAME g_nmh.nmh26 
#FUN-B20073 --end-- 
                 NEXT FIELD nmh26
              END IF
              #No.FUN-C30200--Begin---
              IF cl_null(g_nmh.nmh26) THEN
                 LET g_nmh26_name = ''
              ELSE
                 SELECT aag02 INTO g_nmh26_name from aag_file where aag01 = g_nmh.nmh26 AND aag00 = g_bookno1
              END IF
              DISPLAY g_nmh26_name TO nmh26_name
              #No.FUN-C30200--End---
           END IF
 
        AFTER FIELD nmh261                                                                                                           
           IF g_nmz.nmz02 = 'Y' AND g_nmh.nmh261 IS NOT NULL THEN                                                                    
              CALL s_m_aag(g_nmz.nmz02p,g_nmh.nmh261,g_bookno2) RETURNING g_msg   #No.FUN-740028  #FUN-990069                                                                   
              IF NOT cl_null(g_errno) THEN                                                                                          
                 CALL cl_err('',g_errno,0)    
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmh.nmh261,'23',g_bookno2)
                       RETURNING g_nmh.nmh261                                                                                        
                  DISPLAY BY NAME g_nmh.nmh261
#FUN-B20073 --end--                                                                                                       
                 NEXT FIELD nmh261                                                                                                   
              END IF                                                                                                                
           END IF  

        AFTER FIELD nmh27
           IF g_nmz.nmz02 = 'Y' AND g_nmh.nmh27 IS NOT NULL THEN
              CALL s_m_aag(g_nmz.nmz02p,g_nmh.nmh27,g_bookno1) RETURNING g_msg   #No.FUN-740028   #FUN-990069 
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmh.nmh27,'23',g_bookno1) 
                       RETURNING g_nmh.nmh27
                  DISPLAY BY NAME g_nmh.nmh27 
#FUN-B20073 --end--                
                 NEXT FIELD nmh27
              END IF
              #No.FUN-C30200--Begin---
              IF cl_null(g_nmh.nmh27) THEN
                 LET g_nmh27_name = ''
              ELSE
                 SELECT aag02 INTO g_nmh27_name from aag_file where aag01 = g_nmh.nmh27 AND aag00 = g_bookno1
              END IF
              DISPLAY g_nmh27_name TO nmh27_name
              #No.FUN-C30200--End---
           END IF
 
        AFTER FIELD nmh271                                                                                                           
           IF g_nmz.nmz02 = 'Y' AND g_nmh.nmh271 IS NOT NULL THEN                                                                    
              CALL s_m_aag(g_nmz.nmz02p,g_nmh.nmh271,g_bookno2) RETURNING g_msg      #No.FUN-740028    #FUN-990069                                                          
              IF NOT cl_null(g_errno) THEN                                                                                          
                 CALL cl_err('',g_errno,0)                                                                                          
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nmh.nmh271,'23',g_bookno2)
                       RETURNING g_nmh.nmh271                                                                                        
                  DISPLAY BY NAME g_nmh.nmh271 
#FUN-B20073 --end--
                 NEXT FIELD nmh271                                                                                                   
              END IF                                                                                                                
           END IF
       
        AFTER FIELD nmh41    #暫收否
           IF NOT cl_null(g_nmh.nmh41) THEN
              IF g_nmh.nmh41 NOT MATCHES '[YN]' THEN
                 CALL cl_err(g_nmh.nmh41,'afa-086',0)
                 DISPLAY BY NAME g_nmh.nmh41
                 NEXT FIELD nmh41
              END IF
              LET g_nmh_o.nmh41 = g_nmh.nmh41
           END IF
#          CALL t200_nmh15('a') 
           CALL t200_nmh15(p_cmd)   #No.TQC-C40033 
 
        AFTER FIELD nmhud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nmhud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nmh.nmhuser = s_get_data_owner("nmh_file") #FUN-C10039
           LET g_nmh.nmhgrup = s_get_data_group("nmh_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT  END IF
            IF g_nmh.nmh03 = g_aza.aza17 THEN
               LET g_nmh.nmh28 = 1
               DISPLAY BY NAME g_nmh.nmh28
            END IF
            IF g_nmh.nmh13 MATCHES '[Nn]' THEN  #(客票才可打發票人)
               LET g_nmh.nmh14 = NULL
               DISPLAY BY NAME g_nmh.nmh14
            END IF
            IF  cl_null(g_nmh.nmh01) THEN
               CALL cl_err('','9033',0)   #CHI-960066 add       
               DISPLAY BY NAME g_nmh.nmh01
               NEXT FIELD nmh01           #CHI-960066 add     
            END IF
            IF  cl_null(g_nmh.nmh03) THEN
               CALL cl_err('','9033',0)   #CHI-960066 add       
               DISPLAY BY NAME g_nmh.nmh03
               NEXT FIELD nmh03           #CHI-960066 add     
            END IF
            IF  cl_null(g_nmh.nmh02) OR g_nmh.nmh02 <= 0 THEN
               CALL cl_err('','9033',0)   #CHI-960066 add       
               DISPLAY BY NAME g_nmh.nmh02
               NEXT FIELD nmh02           #CHI-960066 add      
            END IF
            IF cl_null(g_nmh.nmh05) THEN
               CALL cl_err('','9033',0)   #CHI-960066 add       
               DISPLAY BY NAME g_nmh.nmh05
               NEXT FIELD nmh05           #CHI-960066 add     
            END IF
            IF cl_null(g_nmh.nmh06) THEN
               CALL cl_err('','9033',0)   #CHI-960066 add       
               DISPLAY BY NAME g_nmh.nmh06
               NEXT FIELD nmh06           #CHI-960066 add     
            END IF
            IF cl_null(g_nmh.nmh11) THEN
               CALL cl_err('','9033',0)   #CHI-960066 add       
               DISPLAY BY NAME g_nmh.nmh11
               NEXT FIELD nmh11           #CHI-960066 add     
            END IF
            IF cl_null(g_nmh.nmh28) OR g_nmh.nmh28 <= 0 THEN
               CALL cl_err('','9033',0)   #CHI-960066 add       
               DISPLAY BY NAME g_nmh.nmh28
               NEXT FIELD nmh28           #CHI-960066 add     
            END IF
            IF cl_null(g_nmh.nmh15) AND g_nmz.nmz08 = 'N' THEN
               CALL cl_err('','9033',0)   #CHI-960066 add       
               DISPLAY BY NAME g_nmh.nmh15
               NEXT FIELD nmh15           #CHI-960066 add     
            END IF
           #MOD-A20064---add---start---
            IF g_aza.aza63 = 'Y' THEN
               IF cl_null(g_nmh.nmh26) AND cl_null(g_nmh.nmh261) AND cl_null(g_nmh.nmh27) AND cl_null(g_nmh.nmh271) THEN
#                 CALL t200_nmh15('a')
                  CALL t200_nmh15(p_cmd)   #No.TQC-C40033 
               END IF
            ELSE
               IF cl_null(g_nmh.nmh26) AND cl_null(g_nmh.nmh27) THEN
#                 CALL t200_nmh15('a')
                  CALL t200_nmh15(p_cmd)   #No.TQC-C40033 
               END IF
            END IF
           #MOD-A20064---add---end---
		
	ON KEY(F1)
   	   NEXT FIELD nmh01
 
	ON KEY(F2)
	   NEXT FIELD nmh08
   	   NEXT FIELD nmh15
      	   NEXT FIELD nmh24
 
 
        ON ACTION CONTROLP
            CASE
              WHEN INFIELD(nmh01)
                 LET g_t1 = s_get_doc_no(g_nmh.nmh01)       #No.FUN-550057
                 CALL q_nmy(FALSE,FALSE,g_t1,'2','ANM') RETURNING g_t1     #TQC-670008
                 LET g_nmh.nmh01 = g_t1
                 DISPLAY BY NAME g_nmh.nmh01
                 NEXT FIELD nmh01
               WHEN INFIELD(nmh03) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.default1 = g_nmh.nmh03
                  CALL cl_create_qry() RETURNING g_nmh.nmh03
                  DISPLAY BY NAME g_nmh.nmh03
                  NEXT FIELD nmh03
    #----start mark by liuxc150312-------
             #  WHEN INFIELD(nmh06) #銀行代號
             #     CALL cl_init_qry_var()
             #     LET g_qryparam.form = "q_nmt"
             #     LET g_qryparam.default1 = g_nmh.nmh06
             #     CALL cl_create_qry() RETURNING g_nmh.nmh06
             #     DISPLAY BY NAME g_nmh.nmh06
             #     CALL t200_nmh06('d')
             #     NEXT FIELD nmh06
    #----mark--end -------------
               WHEN INFIELD(nmh11) #客戶代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_occ"
                  LET g_qryparam.default1 = g_nmh.nmh11
                  CALL cl_create_qry() RETURNING g_nmh.nmh11
                  DISPLAY BY NAME g_nmh.nmh11
		  CALL t200_nmh11('d')
                  NEXT FIELD nmh11
               WHEN INFIELD(nmh12) #變動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.default1 = g_nmh.nmh12
                  CALL cl_create_qry() RETURNING g_nmh.nmh12
                  DISPLAY BY NAME g_nmh.nmh12
                  CALL t200_nmh12('d')
                  NEXT FIELD nmh12
               WHEN INFIELD(nmh15) #部門
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gem"
                  LET g_qryparam.default1 = g_nmh.nmh15
                  CALL cl_create_qry() RETURNING g_nmh.nmh15
                  DISPLAY BY NAME g_nmh.nmh15
                  CALL t200_nmh15('d')
                  NEXT FIELD nmh15
               WHEN INFIELD(nmh16) #人員
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gen"
                  LET g_qryparam.default1 = g_nmh.nmh16
                  CALL cl_create_qry() RETURNING g_nmh.nmh16
                  DISPLAY BY NAME g_nmh.nmh16
                  CALL t200_nmh16('d')
                  NEXT FIELD nmh16
               WHEN INFIELD(nmh21) #銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma1"
                  LET g_qryparam.default1 = g_nmh.nmh21
                  LET g_qryparam.arg1 = g_nmh.nmh03
                  CALL cl_create_qry() RETURNING g_nmh.nmh21
                  DISPLAY BY NAME g_nmh.nmh21
                  CALL t200_nmh21('d')
                  NEXT FIELD nmh21
               WHEN INFIELD(nmh22) #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmc"
                  LET g_qryparam.default1 = g_nmh.nmh22
                  CALL cl_create_qry() RETURNING g_nmh.nmh22
                  DISPLAY BY NAME g_nmh.nmh22
                  NEXT FIELD nmh22
               WHEN INFIELD(nmh26)
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmh.nmh26,'23',g_bookno1) #No.FUN-980025
                       RETURNING g_nmh.nmh26
                  #No.FUN-C30200--Begin---
                  IF cl_null(g_nmh.nmh26) THEN
                     LET g_nmh26_name = ''
                  ELSE
                     SELECT aag02 INTO g_nmh26_name from aag_file where aag01 = g_nmh.nmh26 AND aag00 = g_bookno1
                  END IF
                  #No.FUN-C30200--End---
                  DISPLAY BY NAME g_nmh.nmh26
                  DISPLAY g_nmh26_name TO nmh26_name   #No.FUN-C30200 
                  NEXT FIELD nmh26
               WHEN INFIELD(nmh261)                                                                                                  
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmh.nmh261,'23',g_bookno2)#No.FUN-980025 
                       RETURNING g_nmh.nmh261                                                                                        
                  DISPLAY BY NAME g_nmh.nmh261 NEXT FIELD nmh261
               WHEN INFIELD(nmh27)
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmh.nmh27,'23',g_bookno1) #No.FUN-980025
                       RETURNING g_nmh.nmh27
                  #No.FUN-C30200--Begin---
                  IF cl_null(g_nmh.nmh27) THEN
                     LET g_nmh27_name = ''
                  ELSE
                     SELECT aag02 INTO g_nmh27_name from aag_file where aag01 = g_nmh.nmh27 AND aag00 = g_bookno1
                  END IF
                  #No.FUN-C30200--End---
                  DISPLAY BY NAME g_nmh.nmh27
                  DISPLAY g_nmh27_name TO nmh27_name   #No.FUN-C30200 
                  NEXT FIELD nmh27
               WHEN INFIELD(nmh271)                                                                                                  
                  CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nmh.nmh271,'23',g_bookno2)#No.FUN-980025
                       RETURNING g_nmh.nmh271                                                                                        
                  DISPLAY BY NAME g_nmh.nmh271 NEXT FIELD nmh271     
               WHEN INFIELD(nmh10) #票別(一)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmo01"
                  LET g_qryparam.default1 = g_nmh.nmh10
                  CALL cl_create_qry() RETURNING g_nmh.nmh10
                  DISPLAY BY NAME g_nmh.nmh10
                  NEXT FIELD nmh10
               WHEN INFIELD(nmh29) #票別(二)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmo01"
                  LET g_qryparam.default1 = g_nmh.nmh29
                  CALL cl_create_qry() RETURNING g_nmh.nmh29
                  DISPLAY BY NAME g_nmh.nmh29
                  NEXT FIELD nmh29
              WHEN INFIELD(nmh28)
                   CALL s_rate(g_nmh.nmh03,g_nmh.nmh28) RETURNING g_nmh.nmh28
                   DISPLAY BY NAME g_nmh.nmh28
                   NEXT FIELD nmh28
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION create_currency
           CALL cl_cmdrun('aooi050'CLIPPED)
 
        ON ACTION create_all_bank_no
           CALL cl_cmdrun('anmi080'CLIPPED)
 
        ON ACTION create_customer
           CALL cl_cmdrun('axmi221'CLIPPED)
 
        ON ACTION create_department
           CALL cl_cmdrun('aooi030'CLIPPED)
 
        ON ACTION create_employee
           CALL cl_cmdrun('aooi040'CLIPPED)
 
        ON ACTION create_bank_basic
           CALL cl_cmdrun('anmi030'CLIPPED)
 
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
    LET g_no=''
END FUNCTION
 
FUNCTION t200_week(p_date,p_stu)
DEFINE p_date  LIKE type_file.dat,    #No.FUN-680107 DATE
       l_days  LIKE type_file.chr21,  #FUN-770098
       p_stu   LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01) #顯示位置
       l_week  LIKE type_file.num10   #No.FUN-680107 INTEGER   
 
 
        LET l_week = WEEKDAY(p_date)
 
        CASE l_week
             WHEN 0
#                 LET l_days = 'apy-147'   #CHI-B40058
                 LET l_days = 'apj-025'    #CHI-B40058
             WHEN 1
#                 LET l_days = 'apy-141'   #CHI-B40058
#                 LET l_days = 'aps-041'   #CHI-B40058 #No.TQC-B80138 mark
                  LET l_days = 'anm-851'   #TQC-B80138 add
             WHEN 2
#                 LET l_days = 'apy-142'   #CHI-B40058
#                 LET l_days = 'aps-042'   #CHI-B40058 #No.TQC-B80138 mark
                  LET l_days = 'axr-835'   #TQC-B80138 add
             WHEN 3
#                 LET l_days = 'apy-143'   #CHI-B40058
#                 LET l_days = 'aps-043'   #CHI-B40058 #No.TQC-B80138 mark
                  LET l_days = 'axr-836'   #TQC-B80138 add
             WHEN 4
#                 LET l_days = 'apy-144'   #CHI-B40058
                  LET l_days = 'aps-044'   #CHI-B40058
             WHEN 5
#                 LET l_days = 'apy-145'   #CHI-B40058
                  LET l_days = 'aps-045'   #CHI-B40058
             WHEN 6
#                 LET l_days = 'apy-146'   #CHI-B40058
                  LET l_days = 'aps-046'   #CHI-B40058
             OTHERWISE
                  LET l_days = ' '
        END CASE
        CALL cl_getmsg(l_days,g_lang) RETURNING l_days
        CASE p_stu
	   WHEN '1' DISPLAY l_days TO FORMONLY.date1
	   WHEN '2' DISPLAY l_days TO FORMONLY.date2
        END CASE
 
END FUNCTION
#---start mark--by--liuxc--150312----------
#FUNCTION t200_nmh06(p_cmd)  #銀行代號
#    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
#           l_nmt02      LIKE nmt_file.nmt02,
#           l_nmt03      LIKE nmt_file.nmt03,
#           l_nmtacti    LIKE nmt_file.nmtacti
# 
#    LET g_errno = ' '
#   SELECT nmt02,nmt03,nmtacti
#           INTO l_nmt02,l_nmt03,l_nmtacti
#           FROM nmt_file WHERE nmt01 = g_nmh.nmh06
#    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
#                            LET l_nmt02 = NULL
#         WHEN l_nmtacti='N' LET g_errno = '9028'
#         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
#    END CASE
#    IF cl_null(g_errno) OR p_cmd = 'd' THEN
#       DISPLAY l_nmt02 TO FORMONLY.nmt02
#    END IF
#    IF p_cmd = 'a' AND l_nmt03 IS NOT NULL AND g_nmh.nmh08=0 THEN
#       LET g_nmh.nmh08 = l_nmt03 DISPLAY BY NAME g_nmh.nmh08
#    END IF
#END FUNCTIOn 
#----mark---end--------------
 
FUNCTION t200_nmh11(p_cmd)  #
    DEFINE p_cmd	LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_occ02      LIKE occ_file.occ02,
           l_occ04      LIKE occ_file.occ04,
           l_occacti    LIKE occ_file.occacti
 
    LET g_errno = ' '
    SELECT occ02,occ04,occacti
           INTO l_occ02,l_occ04,l_occacti
           FROM occ_file WHERE occ01 = g_nmh.nmh11
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-045'
                            LET l_occ02 = NULL
         WHEN l_occacti='N' LET g_errno = '9028'
         
         WHEN l_occacti MATCHES '[PH]'       LET g_errno = '9038'
 
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF NOT cl_null(g_errno) THEN RETURN END IF
    LET g_nmh.nmh30 = l_occ02
    DISPLAY BY NAME g_nmh.nmh30
    IF NOT cl_null(l_occ04)  THEN
       LET g_nmh.nmh16 = l_occ04
       CALL t200_nmh16('d')
       IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_nmh.nmh16,'anm-207',1)
          LET g_nmh.nmh16 = g_nmh_o.nmh16
          LET g_errno = ' '
       ELSE
          IF g_nmz.nmz08 <> 'Y' THEN  #MOD-790064 
             SELECT gen03 INTO g_nmh.nmh15 FROM gen_file
              WHERE gen01 = g_nmh.nmh16
             DISPLAY BY NAME g_nmh.nmh15
          END IF   #MOD-790064
          CALL t200_nmh15('c')    #MOD-810193
       END IF
       DISPLAY BY NAME g_nmh.nmh16
     END IF
END FUNCTION
 
FUNCTION t200_nmh12(p_cmd)
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_nmlacti LIKE nml_file.nmlacti,
           l_nml02   LIKE nml_file.nml02
 
    SELECT nmlacti,nml02 INTO l_nmlacti,l_nml02 FROM nml_file
           WHERE nml01 = g_nmh.nmh12
    LET g_errno = ' '
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = '100'
         WHEN l_nmlacti = 'N'     LET g_errno = '9028'
         WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
    END CASE
    DISPLAY l_nml02 TO nml02
END FUNCTION
 
FUNCTION t200_nmh15(p_cmd)  #部門
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_gem02   LIKE gem_file.gem02,
           l_gemacti LIKE gem_file.gemacti
 
    LET g_errno = ' '
    #加判斷nmh15 如為空白,則不ref gem_file
    IF NOT cl_null(g_nmh.nmh15) THEN
       SELECT gem02,gemacti INTO l_gem02,l_gemacti
           FROM gem_file WHERE gem01 = g_nmh.nmh15
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-071'
                               LET l_gem02 = NULL
            WHEN l_gemacti='N' LET g_errno = '9028'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
    IF g_errno='anm-071' AND p_cmd='c' THEN
       LET g_errno='anm-072'
    END IF
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gem02 TO FORMONLY.gem02
    END IF
    IF p_cmd = 'a' THEN
       IF g_nmz.nmz11 = 'Y'
       THEN LET g_dept = g_nmh.nmh15
       ELSE LET g_dept = ' '
       END IF
       SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
       IF SQLCA.sqlcode THEN 
          CALL cl_err('','aap-053',0)   #MOD-810193
          INITIALIZE g_nms.* TO NULL 
       END IF
       LET g_nmh.nmh26  = g_nms.nms22
       #LET g_nmh.nmh261 = g_nms.nms22    #MOD-C10039 modify g_nms.nms22 #FUN-680034
       LET g_nmh.nmh261 = g_nms.nms221    #MOD-C10039 modify g_nms.nms22 #FUN-680034
       IF g_nmh.nmh41 = 'Y' THEN
          LET g_nmh.nmh27 = g_nms.nms28
          #LET g_nmh.nmh271 = g_nms.nms28  #MOD-C10039 modify g_nms.nms28
          LET g_nmh.nmh271 = g_nms.nms281  #MOD-C10039 modify g_nms.nms28
       ELSE
          LET g_nmh.nmh27 = g_nms.nms21 
          #LET g_nmh.nmh271= g_nms.nms21  #MOD-C10039 modify g_nms.nms21 #FUN-680034
          LET g_nmh.nmh271= g_nms.nms211  #MOD-C10039 modify g_nms.nms21 #FUN-680034
       END IF
       DISPLAY BY NAME g_nmh.nmh26,g_nmh.nmh261, g_nmh.nmh27,g_nmh.nmh271     #FUN-680034
    END IF
END FUNCTION
 
FUNCTION t200_nmh16(p_cmd)  #人員
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_gen02   LIKE gen_file.gen02,
           l_genacti LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti
           INTO l_gen02,l_genacti
           FROM gen_file WHERE gen01 = g_nmh.nmh16
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-207'  #MOD-640249 'anm-047'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_gen02 TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION t200_nmh21(p_cmd)  #託貼銀行代號
    DEFINE p_cmd     LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
           l_nma02   LIKE nma_file.nma02,
           l_nma10   LIKE nma_file.nma10,
           l_nmaacti LIKE nma_file.nmaacti
 
    LET g_errno = ' '
    SELECT nma02,nma10,nmaacti
           INTO l_nma02,l_nma10,l_nmaacti
           FROM nma_file WHERE nma01 = g_nmh.nmh21
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-013'
                            LET l_nma02 = NULL
         WHEN l_nmaacti='N' LET g_errno = '9028'
		 WHEN l_nma10 != g_nmh.nmh03 LET g_errno = 'anm-048'
                            LET l_nma02 = NULL
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY l_nma02 TO FORMONLY.nma02_1
    END IF
END FUNCTION
 
FUNCTION t200_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nmh.* TO NULL             #No.FUN-6A0011
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t200_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t200_count
    FETCH t200_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t200_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        INITIALIZE g_nmh.* TO NULL
    ELSE
        CALL t200_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t200_fetch(p_flnmh)
    DEFINE
        p_flnmh         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
    CASE p_flnmh
        WHEN 'N' FETCH NEXT     t200_cs INTO g_nmh.nmh01
        WHEN 'P' FETCH PREVIOUS t200_cs INTO g_nmh.nmh01
        WHEN 'F' FETCH FIRST    t200_cs INTO g_nmh.nmh01
        WHEN 'L' FETCH LAST     t200_cs INTO g_nmh.nmh01
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
            FETCH ABSOLUTE g_jump t200_cs INTO g_nmh.nmh01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        INITIALIZE g_nmh.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flnmh
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_nmh.* FROM nmh_file            # 重讀DB,因TEMP有不被更新特性
       WHERE nmh01 = g_nmh.nmh01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
    ELSE
       LET g_data_owner = g_nmh.nmhuser     #No.FUN-4C0063
       LET g_data_group = g_nmh.nmhgrup     #No.FUN-4C0063
       CALL s_get_bookno(YEAR(g_nmh.nmh04)) RETURNING g_flag,g_bookno1,g_bookno2                                                            
         IF g_flag =  '1' THEN  #抓不到帳別                                                                                    
            CALL cl_err(g_nmh.nmh04,'aoo-081',1)                                                                                   
         END IF                                                                                                                
       CALL t200_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t200_show()
DEFINE l_nmo02    LIKE nmo_file.nmo02 #No.FUN-680107 VARCHAR(10)
 
    LET g_nmh_t.* = g_nmh.*
    DISPLAY BY NAME g_nmh.nmhoriu,g_nmh.nmhorig,
           g_nmh.nmh01,g_nmh.nmh31,g_nmh.nmh04,g_nmh.nmh05,
           g_nmh.nmh03,g_nmh.nmh28,g_nmh.nmh02,g_nmh.nmh32,
           g_nmh.nmh06,g_nmh.nmh07,g_nmh.nmh08,g_nmh.nmh09,
           g_nmh.nmh10,g_nmh.nmh29,g_nmh.nmh11,g_nmh.nmh30,g_nmh.nmh13,
           g_nmh.nmh14,g_nmh.nmh12,g_nmh.nmh15,g_nmh.nmh16,g_nmh.nmh17,
           g_nmh.nmh19,g_nmh.nmh20,g_nmh.nmh21,g_nmh.nmh22,g_nmh.nmh23,
           g_nmh.nmh24,g_nmh.nmh25,g_nmh.nmh35,g_nmh.nmh26,g_nmh.nmh261,              #FUN-680034
           g_nmh.nmh41,   #FUN-970071
	   g_nmh.nmh33,g_nmh.nmh34,g_nmh.nmh27,g_nmh.nmh271,g_nmh.nmh18,g_nmh.nmh38,  #FUN-680034
	   g_nmh.nmhuser,g_nmh.nmhgrup,g_nmh.nmhmodu,g_nmh.nmhdate,
           g_nmh.nmhud01,g_nmh.nmhud02,g_nmh.nmhud03,g_nmh.nmhud04,
           g_nmh.nmhud05,g_nmh.nmhud06,g_nmh.nmhud07,g_nmh.nmhud08,
           g_nmh.nmhud09,g_nmh.nmhud10,g_nmh.nmhud11,g_nmh.nmhud12,
           g_nmh.nmhud13,g_nmh.nmhud14,g_nmh.nmhud15,
           g_nmh.nmh42   #FUN-B40011 
    LET l_nmo02 = NULL
    SELECT nmo02 INTO l_nmo02 FROM nmo_file WHERE nmo01 = g_nmh.nmh10
    DISPLAY l_nmo02 TO w1
    LET l_nmo02 = NULL
    SELECT nmo02 INTO l_nmo02 FROM nmo_file WHERE nmo01 = g_nmh.nmh29
    DISPLAY l_nmo02 TO w2
    CALL t200_week(g_nmh.nmh05,'1')
    CALL t200_week(g_nmh.nmh09,'2')
 #   CALL t200_nmh06('d') #mark by liuxc150312
    CALL t200_nmh12('d')
    CALL t200_nmh15('d')
    CALL t200_nmh16('d')
    CALL t200_nmh21('d')
    IF g_nmh.nmh38 = 'X' THEN
       LET g_void = 'Y'
       CALL cl_set_field_pic("","","","",g_void,"")
    ELSE
       LET g_void = 'N'
       CALL cl_set_field_pic(g_nmh.nmh38,"","","",g_void,"")
    END IF
 
    #No.FUN-C30200--Begin---
    IF cl_null(g_nmh.nmh26) THEN
       LET g_nmh26_name = ''
    ELSE
       SELECT aag02 INTO g_nmh26_name from aag_file where aag01 = g_nmh.nmh26 AND aag00 = g_bookno1
    END IF
    DISPLAY g_nmh26_name TO nmh26_name

    IF cl_null(g_nmh.nmh27) THEN
       LET g_nmh27_name = ''
    ELSE
       SELECT aag02 INTO g_nmh27_name from aag_file where aag01 = g_nmh.nmh27 AND aag00 = g_bookno1
    END IF
    DISPLAY g_nmh27_name TO nmh27_name
    #No.FUN-C30200--End---

    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t200_u()
  DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nmh.nmh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
    IF g_azw.azw04 <> 2 THEN  #TQC-C50033
       IF g_nmh.nmh38 = 'Y' THEN  CALL cl_err('','anm-137',0) RETURN END IF
    END IF                    #TQC-C50033
    IF g_nmh.nmh38 = 'X' THEN  CALL cl_err('','9024',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_nmh01_t = g_nmh.nmh01
    LET g_nmh03_t = g_nmh.nmh03
    LET g_nmh04_t = g_nmh.nmh04
    LET g_nmh_o.*=g_nmh.*
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t200_cl USING g_nmh.nmh01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_nmh.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    LET g_nmh.nmhmodu=g_user                     #修改者
    LET g_nmh.nmhdate = g_today                  #修改日期
    CALL t200_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t200_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0 LET g_success = 'N'
            LET g_nmh.*=g_nmh_t.*
            CALL t200_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        #nmh39,nmh40要給預設值
         LET g_nmh.nmh39=g_nmh.nmh28
         LET g_nmh.nmh40=(g_nmh.nmh02-g_nmh.nmh17)*g_nmh.nmh39
         LET g_nmh.nmh40 = cl_digcut(g_nmh.nmh40,g_azi04)
        UPDATE nmh_file SET nmh_file.* = g_nmh.*    # 更新DB
            WHERE nmh01 = g_nmh.nmh01             # COLAUTH?
        IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            CALL cl_err3("upd","nmh_file",g_nmh01_t,"",SQLCA.sqlcode,"","(t200_u:nmh)",1)  #No.FUN-660148
            CONTINUE WHILE
        ELSE CALL t200_hu(1,1)
        END IF
        UPDATE nmi_file SET nmi01=g_nmh.nmh01 WHERE nmi01=g_nmh_t.nmh01
        IF g_nmh.nmh04 != g_nmh_t.nmh04 THEN            # 更改單號
           UPDATE npp_file SET npp02=g_nmh.nmh04
            WHERE npp01=g_nmh.nmh01 AND npp00=2 AND npp011=1
              AND nppsys = 'NM'
           IF STATUS THEN 
              CALL cl_err3("upd","npp_file",g_nmh.nmh01,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
           END IF
           #FUN-E80012---add---str---
           SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
           IF g_nmz.nmz70 = '3' THEN
              LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_nmh.nmh04,1)
              LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_nmh.nmh04,3)
              UPDATE tic_file SET tic01=l_tic01,
                                  tic02=l_tic02
              WHERE tic04=g_nmh.nmh01
              IF STATUS THEN
                 CALL cl_err3("upd","tic_file",g_nmh.nmh01,"",STATUS,"","upd tic01,tic02:",1)
              END IF
           END IF
           #FUN-E80012---add---end---
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t200_cl
    IF g_success = 'Y'
       THEN CALL cl_cmmsg(1) COMMIT WORK
            CALL cl_flow_notify(g_nmh.nmh01,'U')
       ELSE CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t200_npp02(p_npptype)
  DEFINE p_npptype    LIKE npp_file.npptype  
  DEFINE l_tic01     LIKE tic_file.tic01   #FUN-E80012 add
  DEFINE l_tic02     LIKE tic_file.tic02   #FUN-E80012 add
  IF g_nmh.nmh33 IS NULL OR g_nmh.nmh33=' ' THEN
     UPDATE npp_file SET npp02=g_nmh.nmh04
      WHERE npp01=g_nmh.nmh01 AND npp00=2 AND npp011=1
        AND nppsys = 'NM' AND npptype=p_npptype      #FUN-680034                  
     IF STATUS THEN 
        CALL cl_err3("upd","npp_file",g_nmh.nmh01,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
     END IF
     #FUN-E80012---add---str---
     SELECT nmz70 INTO g_nmz.nmz70 FROM nmz_file
     IF g_nmz.nmz70 = '3' THEN
        LET l_tic01=s_get_aznn(g_plant,g_bookno1,g_nmh.nmh04,1)
        LET l_tic02=s_get_aznn(g_plant,g_bookno1,g_nmh.nmh04,3)
        UPDATE tic_file SET tic01=l_tic01,
                            tic02=l_tic02
        WHERE tic04=g_nmh.nmh01
        IF STATUS THEN
           CALL cl_err3("upd","tic_file",g_nmh.nmh01,"",STATUS,"","upd tic01,tic02:",1)
        END IF
     END IF
     #FUN-E80012---add---end---
  END IF
END FUNCTION
 
FUNCTION t200_firm1()
   DEFINE only_one   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmh01    LIKE nmh_file.nmh01
   DEFINE l_nmh04    LIKE nmh_file.nmh04
   DEFINE l_nmydmy3  LIKE nmy_file.nmydmy3
   DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(600)
   DEFINE l_n        LIKE type_file.num5      #No.FUN-680034  #No.FUN-680107 SMALLINT
#  DEFINE l_oia07    LIKE oia_file.oia07      #No.FUN-C50136
 
  #IF cl_null(g_nmh.nmh01) THEN RETURN END IF   #MOD-B10213 mark
  #-MOD-B10213-add-
   IF cl_null(g_nmh.nmh01) THEN 
      CALL cl_err('','9057',0) 
      RETURN
   ELSE
      LET g_wc=" nmh01='",g_nmh.nmh01,"'"
   END IF 
  #-MOD-B10213-end-
   SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
   IF g_nmh.nmh38 = 'Y' THEN  CALL cl_err('','9023',0) RETURN END IF
   IF g_nmh.nmh38 = 'X' THEN  CALL cl_err('','9024',0) RETURN END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
   #FUN-B50090 add -end--------------------------
   IF g_nmh.nmh04 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nmh.nmh01,'aap-176',1) 
      RETURN 
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   CALL s_get_doc_no(g_nmh.nmh01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
   IF cl_null(g_nmy.nmyglcr) THEN LET g_nmy.nmyglcr = 'N' END IF
   LET g_success='Y'   #MOD-9C0271 add
   IF g_nmy.nmydmy3 = 'Y' THEN                          #MOD-9C0271
      CALL s_chknpq(g_nmh.nmh01,'NM','1','0',g_bookno1)      #No.FUN-740028
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_nmh.nmh01,'NM','1','1',g_bookno2)   #No.FUN-740028  #MOD-9C0271 mod
      END IF  
   END IF
   IF g_success='N' THEN RETURN END IF
   LET g_success='Y'
   BEGIN WORK
   OPEN t200_cl USING g_nmh.nmh01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_nmh.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
      CLOSE t200_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #是否已經有分錄底稿
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys= 'NM'
         AND npq00 = 2
         AND npq01 = g_nmh.nmh01
         AND npq011='1'
      IF l_n = 0 THEN
         CALL t200_gen_glcr(g_nmh.*,g_nmy.*)
      END IF
     IF g_success = 'Y' THEN 
        CALL s_chknpq(g_nmh.nmh01,'NM','1','0',g_bookno1)     #No.FUN-740028
        IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
           CALL s_chknpq(g_nmh.nmh01,'NM','1','1',g_bookno2)  #No.FUN-740028  #MOD-9C0271 mod
        END IF  
      END IF     
   END IF
   IF g_nmh.nmh41 = 'Y' THEN   #MOD-B10213
      LET l_sql = "SELECT nmh01 FROM nmh_file,nmy_file ",
                  " WHERE nmh01 LIKE trim(nmyslip)||'-%' AND ", g_wc CLIPPED
      PREPARE t200_npq_p  FROM  l_sql
      DECLARE t200_chknpq CURSOR FOR t200_npq_p
      FOREACH t200_chknpq INTO l_nmh01
         IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
         CALL t200_ins_oma(l_nmh01)
         CALL t200_ins_omc(l_nmh01)   #MOD-AC0302
         IF g_success='N' THEN 
            EXIT FOREACH 
         END IF
      END FOREACH 
   END IF                      #MOD-B10213
   IF g_success='Y' THEN                            #MOD-C90092
      LET g_sql = "UPDATE nmh_file SET nmh38 = 'Y'",
                  " WHERE nmh01='",g_nmh.nmh01 ,"'"
      PREPARE t200_firm1_p FROM g_sql
   ##FUN-C50136--ADD--START--
   #  IF g_oaz96 = 'Y' THEN 
   #     CALL s_ccc_oia07('M',g_nmh.nmh11) RETURNING l_oia07
   #     IF NOT cl_null(l_oia07) AND l_oia07 = '0' THEN
   #        CALL s_ccc_oia(g_nmh.nmh11,'M',g_nmh.nmh01,0,'')
   #     END IF
   #  END IF
   ##FUN-C50136--ADD--END--
      EXECUTE t200_firm1_p
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err('upd nmh38',STATUS,1)
         SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
         CLOSE t200_cl
         ROLLBACK WORK
         RETURN
      ELSE
         CLOSE t200_cl
         COMMIT WORK
      END IF
   END IF  #MOD-C90092
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_nmh.nmh01,'" AND npp011 = 1'
      LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",
                " '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' ", 
                " '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nmh.nmh04,"' 'Y' '1' 'Y'"#FUN-860040
      CALL cl_cmdrun_wait(g_str)
      SELECT nmh33 INTO g_nmh.nmh33 FROM nmh_file
       WHERE nmh01 = g_nmh.nmh01
      DISPLAY BY NAME g_nmh.nmh33
   END IF
   SELECT nmh38,nmh17 INTO g_nmh.nmh38 
     FROM nmh_file 
    WHERE nmh01 = g_nmh.nmh01 
   DISPLAY BY NAME g_nmh.nmh17
   DISPLAY g_nmh.nmh38 TO nmh38
   CALL cl_set_field_pic(g_nmh.nmh38,"","","","N","")   #MOD-AC0073
END FUNCTION
 
FUNCTION t200_firm2()
 DEFINE only_one     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(01)
 DEFINE l_cnt        LIKE type_file.num5    #No.FUN-680107 SMALLINT
 DEFINE l_aba19      LIKE aba_file.aba19    #No.FUN-680034
 DEFINE l_sql        STRING                 #No.FUN-680034
 DEFINE l_oma57      LIKE oma_file.oma57    #FUN-970071 
#DEFINE l_oia07      LIKE oia_file.oia07    #FUN-C50136
 
   LET g_success = 'Y'
   IF cl_null(g_nmh.nmh01) THEN RETURN END IF
   SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","sel nmh",1)  #No.FUN-660148
      RETURN
   END IF
   #CHI-C90052 mark begin---
   #IF NOT cl_null(g_nmh.nmh33) THEN  
   #   CALL cl_err('','axr-370',0)
   #   RETURN 
   #END IF
   #CHI-C90052 mark end-----
   IF g_nmh.nmh38='X' THEN
      CALL cl_err('','9024',0)
      RETURN
   END IF
   IF g_nmh.nmh38='N' THEN
      CALL cl_err('','9025',0)
      RETURN
   END IF
   IF g_nmh.nmh41 = 'Y' THEN
      SELECT oma57 INTO l_oma57 FROM oma_file
       WHERE oma00 = '24'
         AND oma01 = g_nmh.nmh01
      IF l_oma57 != 0 THEN
         CALL cl_err(g_nmh.nmh01,'aap-172',0)
         RETURN
      END IF
   ELSE
      IF g_nmh.nmh17 > 0 THEN
         CALL cl_err(g_nmh.nmh17,'anm-241',0)
         RETURN
      END IF
   END IF
   #-->目前票況為'X'或'1' 才可undo_confirm
   IF g_nmh.nmh24 != '1' THEN   #MOD-580071
      CALL cl_err('','anm-141',0)
      RETURN
   END IF
   #-->異動資料
   SELECT COUNT(*) INTO l_cnt FROM npo_file,npn_file 
     WHERE npo03=g_nmh.nmh01 AND npo01 = npn01 AND npnconf <> 'X'
   IF l_cnt>0 THEN
      CALL cl_err('','anm-242',0)
      RETURN
   END IF
   #FUN-B50090 add begin-------------------------
   #重新抓取關帳日期
   SELECT nmz10 INTO g_nmz.nmz10 FROM nmz_file WHERE nmz00='0'
   #FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nmh.nmh04 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nmh.nmh01,'aap-176',1)
      RETURN
   END IF
   SELECT COUNT(*) INTO l_cnt FROM oob_file,ooa_file
     WHERE oob06 = g_nmh.nmh01 AND oob01 = ooa01 AND ooaconf <> 'X'
   IF l_cnt > 0 THEN
      CALL cl_err('','mfg-027',0)
      RETURN
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_nmh.nmh01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nmh.nmh33) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_nmh.nmh33,'anm-230',1)
         LET g_success = 'N'
      ELSE
         LET g_plant_new = g_nmz.nmz02p
         #CALL s_getdbs()   #FUN-A50102
         LET l_sql = "SELECT aba19 ",
                     #"  FROM ",g_dbs_new CLIPPED,"aba_file ",
                     "  FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                     " WHERE aba00 = '",g_nmz.nmz02b,"' ",
                     "   AND aba01 = '",g_nmh.nmh33,"' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE aba_pre FROM l_sql
         DECLARE aba_cs CURSOR FOR aba_pre
         OPEN aba_cs
         IF SQLCA.sqlcode THEN RETURN END IF
         FETCH aba_cs INTO l_aba19
         IF l_aba19 = 'Y' THEN
            CALL cl_err(g_nmh.nmh33,'axr-071',1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
   IF g_success='N'THEN
      SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
      RETURN
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmh.nmh33,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT nmh33 INTO g_nmh.nmh33 FROM nmh_file
       WHERE nmh01 = g_nmh.nmh01
      IF NOT cl_null(g_nmh.nmh33) THEN
         CALL cl_err(g_nmh.nmh33,'aap-929',1)
         RETURN    
      END IF
      DISPLAY BY NAME g_nmh.nmh33
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
   OPEN t200_cl USING g_nmh.nmh01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_nmh.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   MESSAGE "WORKING !"
   IF g_nmh.nmh41='Y' THEN
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM oma_file WHERE oma00='24' AND oma01=g_nmh.nmh01
      IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
      IF l_cnt > 0 THEN
         DELETE FROM oma_file WHERE oma00='24' AND oma01=g_nmh.nmh01
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("del","oma_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","del oma",1)
            LET g_success='N'
         END IF
         DELETE FROM omc_file WHERE omc01=g_nmh.nmh01   #MOD-AC0302
      END IF   #MOD-9C0271 add
      DELETE FROM oov_file WHERE oov01 = g_nmh.nmh01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("del","oov_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","No oov deleted",1)
         LET g_success = 'N'
      END IF
      UPDATE nmh_file SET nmh17 = 0 WHERE nmh01 = g_nmh.nmh01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("upd","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","upd nmh17",1)
         LET g_success='N'
      END IF
   END IF 
   UPDATE nmh_file SET nmh38 = 'N' WHERE nmh01 = g_nmh.nmh01
   IF SQLCA.sqlcode THEN                 #No.MOD-4C0157
      CALL cl_err3("upd","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","upd nmh_file",1)  #No.FUN-660148
      LET g_success ='N'
   END IF
# #FUN-C50136--ADD--START--
#  IF g_oaz96 ='Y' AND g_success = 'Y' THEN
#     CALL s_ccc_oia07('M',g_nmh.nmh11) RETURNING l_oia07
#     IF l_oia07 = '0' THEN
#        CALL s_ccc_rback(g_nmh.nmh11,'M',g_nmh.nmh01,0,'')
#     END IF
#  END IF
# #FUN-C50136--ADD--END--
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1) 
      COMMIT WORK
   ELSE 
      CALL cl_rbmsg(1) 
      ROLLBACK WORK
   END IF

   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmh.nmh33,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT nmh33 INTO g_nmh.nmh33 FROM nmh_file
   #    WHERE nmh01 = g_nmh.nmh01
   #   DISPLAY BY NAME g_nmh.nmh33
   #END IF
   #CHI-C90052 mark end----

   SELECT nmh38,nmh17 INTO g_nmh.nmh38,g_nmh.nmh17
     FROM nmh_file
    WHERE nmh01=g_nmh.nmh01
   DISPLAY BY NAME g_nmh.nmh17
   DISPLAY BY NAME g_nmh.nmh38
END FUNCTION
 
FUNCTION t200_r()
    DEFINE
        l_chr   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nmh.nmh01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
    IF g_nmh.nmh38 = 'Y' THEN  CALL cl_err('','anm-137',0) RETURN END IF
    IF g_nmh.nmh38 = 'X' THEN  CALL cl_err('','9024',0) RETURN END IF
    IF g_nmh.nmh24 NOT MATCHES '[16]' THEN  #票況開立,巳撤票
       CALL cl_err('','anm-012',0)
       RETURN
    END IF
    IF g_nmh.nmh17 > 0 THEN  CALL cl_err('','anm-137',0) RETURN END IF
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t200_cl USING g_nmh.nmh01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_nmh.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t200_show()
    IF cl_delete() THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "nmh01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_nmh.nmh01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                         #No.FUN-9B0098 10/02/24
	DELETE FROM nmh_file WHERE nmh01 = g_nmh.nmh01
	IF SQLCA.SQLERRD[3]=0 THEN
            LET g_success = 'N'
            CALL cl_err('(t200_r:nmh)',SQLCA.sqlcode,0)
        END IF
	CALL t200_hu(1,0)
        DELETE FROM npp_file
         WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_nmh.nmh01 AND npp011=1
        DELETE FROM npq_file
         WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_nmh.nmh01 AND npq011=1

        #FUN-B40056--add--str--
        DELETE FROM tic_file WHERE tic04 = g_nmh.nmh01
        #FUN-B40056--add--end--

        IF g_success = 'Y' THEN CLEAR FORM END IF
	INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant & legal
		VALUES ('anmt200',g_user,g_today,g_msg,g_nmh.nmh01,'Delete',g_plant,g_legal)
    END IF
    CLOSE t200_cl
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1)
       COMMIT WORK
       CALL cl_flow_notify(g_nmh.nmh01,'D')
       OPEN t200_count
       #FUN-B50065-add-start--
       IF STATUS THEN
          CLOSE t200_cl
          CLOSE t200_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       FETCH t200_count INTO g_row_count
       #FUN-B50065-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t200_cl
          CLOSE t200_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50065-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t200_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t200_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t200_fetch('/')
       END IF
    ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    END IF
END FUNCTION
 
#FUNCTION t200_x()                       #FUN-D20035
FUNCTION t200_x(p_type)                  #FUN-D20035
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035
   DEFINE l_flag    LIKE type_file.chr1  #FUN-D20035
   DEFINE
        l_chr   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
 
    IF s_anmshut(0) THEN RETURN END IF
    IF g_nmh.nmh01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
    IF g_nmh.nmh38 = 'Y' THEN  CALL cl_err('','anm-137',0) RETURN END IF
    IF g_nmh.nmh24 NOT MATCHES '[16]' THEN  #票況開立,巳撤票
       CALL cl_err('','anm-012',0)
       RETURN
    END IF
    IF g_nmh.nmh17 > 0 THEN  CALL cl_err('','anm-241',0) RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM oob_file,ooa_file
     WHERE oob06 = g_nmh.nmh01 AND oob01 = ooa01 AND ooaconf <> 'X'
    IF g_cnt > 0 THEN CALL cl_err('','anm-538',0) RETURN END IF

    #FUN-D20035---begin
    IF p_type = 1 THEN
       IF g_nmh.nmh38 ='X' THEN RETURN END IF
    ELSE
       IF g_nmh.nmh38 <>'X' THEN RETURN END IF
    END IF
   #FUN-D20035---end

    LET g_success = 'Y'
    BEGIN WORK
    OPEN t200_cl USING g_nmh.nmh01
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_nmh.*
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
        RETURN
    END IF
    CALL t200_show()
   #IF cl_void(0,0,g_nmh.nmh38) THEN              #FUN-D20035
    IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #FUN-D20035
    IF cl_void(0,0,l_flag) THEN                                         #FUN-D20035
      #IF g_nmh.nmh38='N' THEN    #切換為void                           #FUN-D20035
       IF p_type = 1 THEN                                               #FUN-D20035
          LET g_nmh.nmh38='X'
          DELETE FROM npp_file
           WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_nmh.nmh01 AND npp011=1
          IF STATUS THEN
             CALL cl_err3("del","npp_file",g_nmh.nmh01,"",STATUS,"","del npp:",1)  #No.FUN-660148
             LET g_success='N' 
          END IF
          DELETE FROM npq_file
           WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_nmh.nmh01 AND npq011=1
          IF STATUS THEN
             CALL cl_err3("del","npq_file",g_nmh.nmh01,"",STATUS,"","del npq:",1)  #No.FUN-660148
             LET g_success='N'
          END IF

          #FUN-B40056--add--str--
          DELETE FROM tic_file WHERE tic04 = g_nmh.nmh01
          IF STATUS THEN
             CALL cl_err3("del","tic_file",g_nmh.nmh01,"",STATUS,"","del tic:",1)
             LET g_success='N'
          END IF
          #FUN-B40056--add--end--

          CALL t200_hu(1,0)
       ELSE                       #取消void
          LET g_nmh.nmh38='N'
          CALL t200_hu(0,1)
       END IF
       UPDATE nmh_file SET nmh38 = g_nmh.nmh38
        WHERE nmh01 = g_nmh.nmh01
       IF STATUS THEN 
          CALL cl_err3("upd","nmh_file",g_nmh.nmh01,"",STATUS,"","",1)  #No.FUN-660148
          LET g_success='N' 
       END IF
       IF SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_err('','aap-161',0) LET g_success='N'
       END IF
    END IF
    SELECT nmh38 INTO g_nmh.nmh38 FROM nmh_file
     WHERE nmh01 = g_nmh.nmh01
    DISPLAY BY NAME g_nmh.nmh38
    CLOSE t200_cl
    IF g_success = 'Y'
       THEN CALL cl_cmmsg(1) COMMIT WORK
            CALL cl_flow_notify(g_nmh.nmh01,'V')
       ELSE CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t200_out()
    DEFINE
        l_i     LIKE type_file.num5,    #No.FUN-680107 SMALLINT
        l_name  LIKE type_file.chr20,   # External(Disk) file name  #No.FUN-680107 VARCHAR(20)
        l_nmh   RECORD LIKE nmh_file.*,
        l_za05  LIKE type_file.chr1000, #No.FUN-680107 VARCHAR(40)
        l_chr   LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
    DEFINE l_wc STRING #FUN-750134
DEFINE  l_sta1          LIKE ze_file.ze03
DEFINE  l_sta2          LIKE ze_file.ze03
DEFINE  l_nma02         LIKE nma_file.nma02
DEFINE  l_nmo02         LIKE nmo_file.nmo02
    CALL cl_del_data(l_table)
    IF g_wc IS NULL THEN 
       IF cl_null(g_nmh.nmh01) THEN #FUN-750134
          CALL cl_err('','9057',0) 
          RETURN
       ELSE
          LET l_wc=" nmh01='",g_nmh.nmh01,"'"
       END IF 
    ELSE
       LET l_wc=g_wc
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    LET g_sql="SELECT * FROM nmh_file ",          # 組合出 SQL 指令
              " WHERE ",l_wc CLIPPED  #FUN-750134
    PREPARE t200_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t200_co CURSOR FOR t200_p1
 
 
    FOREACH t200_co INTO l_nmh.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('Foreach:',SQLCA.sqlcode,1)   
            EXIT FOREACH
            END IF
           LET l_nmo02 = ''
           SELECT nmo02 INTO l_nmo02 FROM nmo_file
             WHERE nmo01 = l_nmh.nmh10
            LET l_nma02='' 
            SELECT nmt02 INTO l_nma02 FROM nmt_file WHERE nmt01=l_nmh.nmh06
            SELECT azi04,azi07 INTO t_azi04,t_azi07 FROM azi_file 
               WHERE azi01=l_nmh.nmh03
            LET l_sta1 = ' '
            CALL s_nmhsta(l_nmh.nmh24) RETURNING l_sta1
 
            LET l_sta2 = ' '
            CALL s_nmhsta(l_nmh.nmh19) RETURNING l_sta2
            EXECUTE insert_prep USING 
              l_nmh.nmh01,l_nmh.nmh06,l_nma02,l_nmh.nmh02,l_nmo02,l_nmh.nmh11,
              l_nmh.nmh30,l_sta1,l_nmh.nmh28,l_nmh.nmh26,l_sta2,t_azi04,t_azi07,
              l_nmh.nmh31,l_nmh.nmh05                                                   #CHI-B80059 add
    END FOREACH
 
     LET g_sql = " SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
     IF g_zz05 = 'Y' THEN
       #CALL cl_wcchp(g_wc,'nmh01,nmh31,nmh04,nmh05,nmh03,nmh28,nmh02,nmh32,   #MOD-BC0076 mark
        CALL cl_wcchp(l_wc,'nmh01,nmh31,nmh04,nmh05,nmh03,nmh28,nmh02,nmh32,   #MOD-BC0076 add
                             nmh06,nmh07,nmh08,nmh09,nmh10,nmh29,nmh11,nmh30,
                             nmh13,nmh14,nmh12,nmh15,nmh16,nmh22,nmh23,nmh19,
                             nmh20,nmh21,nmh38,nmh24,nmh17,nmh25,nmh35,nmh18,
                             nmh26,nmh261,nmh27,nmh271,nmh33,nmh34,
                             nmhuser,nmhgrup,nmhmodu,nmhdate')
            #RETURNING g_wc         #MOD-BC0076 mark
             RETURNING l_wc2        #MOD-BC0076 add
     END IF
    #LET g_str = g_wc               #MOD-BC0076 mark
     LET g_str = l_wc2              #MOD-BC0076 add
     CALL cl_prt_cs3('anmt200','anmt200',g_sql,g_str)
    CLOSE t200_co
    ERROR ""
END FUNCTION
FUNCTION t200_hu(r_sw,u_sw)
   DEFINE   r_sw     LIKE type_file.num5,   #No.FUN-680107 SMALLINT
            u_sw     LIKE type_file.num5    #No.FUN-680107 SMALLINT
    CALL t200_hu_nmi(r_sw,u_sw)
    CALL t200_hu_nma(r_sw,u_sw)
 
END FUNCTION
 
FUNCTION t200_hu_nmi(r_sw,u_sw)
   DEFINE   r_sw     LIKE type_file.num5,   #No.FUN-680107 SMALLINT
            u_sw     LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    IF r_sw THEN
       DELETE FROM nmi_file WHERE nmi01 = g_nmh.nmh01
       IF SQLCA.sqlcode THEN
          CALL cl_err3("del","nmi_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","delete nmi",1)  #No.FUN-660148
          LET g_success = 'N'
       END IF
    END IF
    IF u_sw THEN
       INSERT INTO nmi_file(nmi01,nmi02,nmi03,nmi04,nmi05,
                            nmi06,nmi07,nmi08,nmi09,nmilegal) # FUN-980005 add legal 
              VALUES(g_nmh.nmh01,g_nmh.nmh04,'1',g_user,'0',
	                 g_nmh.nmh24,g_nmh.nmh11,0,g_nmh.nmh28,g_legal)
	
       IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","nmi_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","insert nmi",1)  #No.FUN-660148
          LET g_success = 'N'
       END IF
    END IF
END FUNCTION
 
FUNCTION t200_hu_nma(r_sw,u_sw)
DEFINE   r_sw     LIKE type_file.num5,   #No.FUN-680107 SMALLINT #舊資料還原
         u_sw     LIKE type_file.num5    #No.FUN-680107 SMALLINT #新資料更新
 
    #已託貼不可更改, 故本 Update 目前應無法執行
    IF r_sw AND g_nmh_t.nmh21 MATCHES "[24]" THEN
{ckp#1}    UPDATE nma_file SET nma24 = nma24 - g_nmh_t.nmh02
	    	 WHERE nma01= g_nmh.nmh21
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL cl_err3("upd","nma_file",g_nmh.nmh21,"",SQLCA.sqlcode,"","(t200_hu_nma:ckp#1)",1)  #No.FUN-660148
              RETURN
           END IF
    END IF
    #票況 matches [24] 時, 才需UPDATE銀行檔資料
    IF u_sw AND g_nmh.nmh24 MATCHES "[24]" THEN
{ckp#2}   UPDATE nma_file SET nma24 = nma24 + g_nmh.nmh02
	    	 WHERE nma01= g_nmh.nmh21
           IF SQLCA.sqlcode THEN
              LET g_success = 'N'
              CALL cl_err3("upd","nma_file",g_nmh.nmh21,"",SQLCA.sqlcode,"","(t200_hu_nma:ckp#2)",1)  #No.FUN-660148
              RETURN
           END IF
    END IF
END FUNCTION
 
FUNCTION t200_v(p_cmd)
   DEFINE l_wc      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nmh     RECORD LIKE nmh_file.*
   DEFINE only_one  LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_t1      LIKE nmy_file.nmyslip  #No.FUN-680107 VARCHAR(5) #No.FUN-550057
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_nmydmy3 LIKE nmy_file.nmydmy3  #No.FUN-680107 VARCHAR(1)
 
   BEGIN WORK
   OPEN t200_cl USING g_nmh.nmh01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   IF g_nmh.nmh38 = 'Y' THEN
      CALL cl_err('','anm-232',1)
      RETURN
   END IF
   FETCH t200_cl INTO g_nmh.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
      CLOSE t200_cl ROLLBACK WORK RETURN ELSE COMMIT WORK
   END IF
   IF p_cmd  = '1' THEN
 
 
      OPEN WINDOW t200_w9 AT 4,11
           WITH FORM "anm/42f/anmt2003"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt2003")
 
 
      LET only_one = '1'
      INPUT BY NAME only_one WITHOUT DEFAULTS
        AFTER FIELD only_one
          IF only_one IS NULL THEN NEXT FIELD only_one END IF
          IF only_one NOT MATCHES "[12]" THEN NEXT FIELD only_one END IF
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
      IF INT_FLAG THEN LET INT_FLAG = 0 CLOSE WINDOW t200_w9 RETURN END IF
      IF only_one = '1' THEN
         IF g_nmh.nmh38 = 'X' THEN
            CALL cl_err('','9024',0) CLOSE WINDOW t200_w9 RETURN
         END IF
         LET l_wc = " nmh01 = '",g_nmh.nmh01,"' "
      ELSE
         CONSTRUCT BY NAME l_wc ON nmh01,nmh04,nmh05
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
            LET INT_FLAG=0
            CLOSE WINDOW t200_w9
            RETURN
         END IF
      END IF
      CLOSE WINDOW t200_w9
   ELSE
      LET l_wc = " nmh01 = '",g_nmh.nmh01,"' "
   END IF
   LET l_nmh.* = g_nmh.*   # backup old value
   MESSAGE "WORKING !"
 
   LET g_sql = "SELECT * FROM nmh_file ",
               " WHERE nmh38 <> 'X' AND ",l_wc CLIPPED, " ORDER BY nmh01"
   PREPARE t200_v_p FROM g_sql
   DECLARE t200_v_c CURSOR WITH HOLD FOR t200_v_p
   LET g_success='Y' #no.5573
   BEGIN WORK #no.5573
   CALL s_showmsg_init()                 #No.FUN-710024
   FOREACH t200_v_c INTO g_nmh.*
      IF STATUS THEN EXIT FOREACH END IF
      IF g_nmh.nmh38='Y' THEN
         CALL cl_getmsg('anm-232',g_lang) RETURNING g_msg
         MESSAGE g_nmh.nmh01,g_msg
         sleep 1
         CONTINUE FOREACH
      END IF
      LET l_t1 = s_get_doc_no(g_nmh.nmh01)       #MOD-590243
      LET l_nmydmy3 = ''
      SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t1
      IF SQLCA.sqlcode THEN 
         CALL s_errmsg('nmyslip',l_t1,'sel nmy:',STATUS,0) 
      END IF
      IF l_nmydmy3 = 'Y' THEN   #是否拋轉傳票
         IF NOT cl_null(g_nmh.nmh33) THEN
            CALL cl_getmsg('aap-122',g_lang) RETURNING g_msg
            MESSAGE g_nmh.nmh01,g_msg
            sleep 1
            CONTINUE FOREACH
         END IF
         CALL s_t200_gl(g_nmh.nmh01,'0')#第一分錄
         IF g_aza.aza63='Y' AND g_success ='Y' THEN
            CALL s_t200_gl(g_nmh.nmh01,'1')  #第二分錄
         END IF
      ELSE
         IF only_one = '1' THEN
            CALL s_errmsg('','',g_nmh.nmh01,'aap-286',0)  
         END IF
      END IF
   END FOREACH
   CALL s_showmsg()          #No.FUN-710024
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF #no.5573
   LET g_nmh.*=l_nmh.*
   MESSAGE " "
END FUNCTION
 
FUNCTION t200_set_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'a' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nmh01",TRUE)
   END IF
   IF INFIELD(nmh11) OR (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nmh30",TRUE)
   END IF
END FUNCTION
 
FUNCTION t200_set_no_entry(p_cmd)
DEFINE   p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
   IF p_cmd = 'u' AND g_chkey MATCHES '[Nn]' AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("nmh01",FALSE)
      #No.TQC-C50033  --Begin
      IF g_azw.azw04 = 2 AND g_nmh.nmh38 = 'Y' THEN
         CALL cl_set_comp_entry("nmh31,nmh32,nmh02,nmh03,nmh04,nmh05,nmh07,nmh08,nmh09,nmh10,nmh11,nmh29,nmh13,nmh41,nmh12,nmh14",FALSE)
         CALL cl_set_comp_entry("nmh15,nmh16,nmh22,nmh19,nmh20,nmh21,nmh26,nmh27,nmh28",FALSE)
      END IF
      #No.TQC-C50033  --End
   END IF
   IF INFIELD(nmh11) OR (NOT g_before_input_done) THEN
      IF g_nmh.nmh11 != 'MISC' THEN
         CALL cl_set_comp_entry("nmh30",FALSE)
      END IF
   END IF
END FUNCTION
 
FUNCTION t200_carry_voucher()
   DEFINE l_nmygslp    LIKE nmy_file.nmygslp
   DEFINE l_nmygslp1   LIKE nmy_file.nmygslp1  #No.FUN-680034
   DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
   DEFINE l_dbs        STRING                                                                                                        
   DEFINE l_sql        STRING                                                                                                        
   DEFINE l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_nmh.nmh33) OR g_nmh.nmh33 IS NOT NULL THEN
       CALL cl_err(g_nmh.nmh33,'aap-618',1)
       RETURN
    END IF
   IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
   CALL s_get_doc_no(g_nmh.nmh01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
   CALL s_chknpq(g_nmh.nmh01,'NM','1','0',g_bookno1)     #No.FUN-740028
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL s_chknpq(g_nmh.nmh01,'NM','1','1',g_bookno2)  #No.FUN-740028  #MOD-9C0271 mod
   END IF
   IF g_success='N' THEN RETURN END IF
   IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
      LET l_nmygslp = g_nmy.nmygslp
      LET l_nmygslp1= g_nmy.nmygslp1     #No.FUN-680034
      LET g_plant_new=g_nmz.nmz02p 
      #CALL s_getdbs() LET l_dbs=g_dbs_new    #FUN-A50102                                                             
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file", 
      LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102      
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",                                                                               
                  "    AND aba01 = '",g_nmh.nmh33,"'"                                                                                 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre2 FROM l_sql                                                                                                     
      DECLARE aba_cs2 CURSOR FOR aba_pre2                                                                                             
      OPEN aba_cs2                                                                                                                    
      FETCH aba_cs2 INTO l_n                                                                                                          
      IF l_n > 0 THEN                                                                                                                 
         CALL cl_err(g_nmh.nmh33,'aap-991',1)                                                                                         
         RETURN                                                                                                                       
      END IF 
   ELSE
      CALL cl_err('','aap-936',1)  #FUN-940036                                                                                                
      RETURN 
   END IF
   IF cl_null(l_nmygslp) THEN
      CALL cl_err(g_nmh.nmh01,'axr-070',1)
      RETURN
   END IF
   IF cl_null(l_nmygslp1) AND g_aza.aza63 = 'Y' THEN
      CALL cl_err(g_nmh.nmh01,'axr-070',1)
      RETURN
   END IF
   LET g_wc_gl = 'npp01 = "',g_nmh.nmh01,'" AND npp011 = 1'
   LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' ",
             " '",g_nmz.nmz02b,"' '",l_nmygslp,"' ", 
             " '",g_nmz.nmz02c,"' '",l_nmygslp1,"' '",g_nmh.nmh04,"' 'Y' '1' 'Y'" #FUN-860040
   CALL cl_cmdrun_wait(g_str)
   SELECT nmh33 INTO g_nmh.nmh33 FROM nmh_file
    WHERE nmh01 = g_nmh.nmh01
   DISPLAY BY NAME g_nmh.nmh33
   
END FUNCTION
 
FUNCTION t200_undo_carry_voucher() 
   DEFINE l_aba19    LIKE aba_file.aba19
   DEFINE l_sql      STRING
 
    IF cl_null(g_nmh.nmh33) OR g_nmh.nmh33 IS NULL THEN
       CALL cl_err(g_nmh.nmh33,'aap-619',1)
       RETURN
    END IF
   IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
   CALL s_get_doc_no(g_nmh.nmh01) RETURNING g_t1
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
   IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
      CALL cl_err('','aap-936',1)   #FUN-940036                                                                                                 
      RETURN                                                                                                                       
   END IF  
   CALL s_chknpq(g_nmh.nmh01,'NM','1','0',g_bookno1)     #No.FUN-740028 
   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
      CALL s_chknpq(g_nmh.nmh01,'NM','1','1',g_bookno2)  #No.FUN-740028  #MOD-9C0271 mod
   END IF
   IF g_success='N' THEN RETURN END IF
   LET g_plant_new = g_nmz.nmz02p
   #CALL s_getdbs() #FUN-A50102
   LET l_sql = "SELECT aba19 ",
               #"  FROM ",g_dbs_new CLIPPED,"aba_file ",
               "  FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
               " WHERE aba00 = '",g_nmz.nmz02b,"' ",
               "   AND aba01 = '",g_nmh.nmh33,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE aba_pre1 FROM l_sql
   DECLARE aba_cs1 CURSOR FOR aba_pre1
   OPEN aba_cs1
   IF SQLCA.sqlcode THEN RETURN END IF
   FETCH aba_cs1 INTO l_aba19
   IF l_aba19 = 'Y' THEN
      CALL cl_err(g_nmh.nmh33,'axr-071',1)
      RETURN
   END IF
   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmh.nmh33,"' 'Y'"
   CALL cl_cmdrun_wait(g_str)
   SELECT nmh33 INTO g_nmh.nmh33 FROM nmh_file
    WHERE nmh01 = g_nmh.nmh01
   DISPLAY BY NAME g_nmh.nmh33
END FUNCTION
 
FUNCTION t200_gen_glcr(p_nmh,p_nmy)
   DEFINE p_nmh    RECORD LIKE nmh_file.*
   DEFINE p_nmy    RECORD LIKE nmy_file.*
 
   IF cl_null(p_nmy.nmygslp) THEN
      CALL cl_err(p_nmh.nmh01,'axr-070',1)
      LET g_success = 'N'
      RETURN
   END IF       
   CALL s_t200_gl(g_nmh.nmh01,'0')     #第一分錄
   IF g_aza.aza63='Y' AND g_success ='Y' THEN
      CALL s_t200_gl(g_nmh.nmh01,'1')  #第二分錄
   END IF
   IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
# 新增應收:oma00='24'暫收
FUNCTION t200_ins_oma(p_nmh01)
   DEFINE p_nmh01   LIKE nmh_file.nmh01
   DEFINE l_nmh     RECORD LIKE nmh_file.*
   DEFINE l_oma     RECORD LIKE oma_file.*
   DEFINE l_n       SMALLINT
 
   SELECT * INTO l_nmh.* FROM nmh_file WHERE nmh01 = p_nmh01
  #-MOD-B10213-mark-
  #IF l_nmh.nmh41 <> 'Y' THEN
  #   RETURN
  #END IF
  #-MOD-B10213-end-
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM npq_file
    WHERE npq01 = l_nmh.nmh01
      AND npqsys = 'NM'
      AND npq011 = 1
   IF l_n IS NULL THEN LET l_n = 0 END IF
   IF l_n = 0 THEN
      CALL cl_err(l_nmh.nmh01,'aap-995',1)
      LET g_success='N'
      RETURN
   END IF
   LET g_success='Y'
   CALL s_chknpq(g_nmh.nmh01,'NM','1','0',g_bookno1)
   IF g_success = 'N' THEN
      RETURN
   END IF
   INITIALIZE l_oma.* TO NULL
   LET l_oma.oma01 = l_nmh.nmh01
 
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      MESSAGE l_oma.oma01
   ELSE
      DISPLAY l_oma.oma01 AT 2,1
   END IF
 
   LET l_oma.oma00 = '24'
   LET l_oma.oma02 = l_nmh.nmh04
   LET l_oma.oma03 = l_nmh.nmh11
   LET l_oma.oma04 = l_nmh.nmh11
   SELECT occ02,occ11,occ18,occ231,occ37
     INTO l_oma.oma032,l_oma.oma042,l_oma.oma043,l_oma.oma044,l_oma.oma40
     FROM occ_file
    WHERE occ01 = l_oma.oma03
      AND occacti = 'Y'
   LET l_oma.oma07 = 'N'
   LET l_oma.oma08 = '1'
   LET l_oma.oma13 = '1'
   LET l_oma.oma11 = l_oma.oma02
   LET l_oma.oma12 = l_oma.oma02
   LET l_oma.oma14 = g_user
   SELECT gen03 INTO l_oma.oma15 FROM gen_file WHERE gen01=l_oma.oma14
   LET l_oma.oma16 = l_nmh.nmh01  #070517 By TSD.alana
   LET l_oma.oma18 = l_nmh.nmh27
   LET l_oma.oma20 = 'N'
   LET l_oma.oma23 = l_nmh.nmh03
#  CALL s_curr3(l_oma.oma23,l_oma.oma02,'B') RETURNING l_oma.oma24  #MOD-B30263 mark 
   LET l_oma.oma24 = l_nmh.nmh28                                    #MOD-B30263 add 
   LET l_oma.oma50 = 0
   LET l_oma.oma50t= 0
   LET l_oma.oma52 = 0
   LET l_oma.oma53 = 0
   LET l_oma.oma54x= 0
   LET l_oma.oma56x= 0
   LET l_oma.oma55 = 0
   LET l_oma.oma57 = 0
   LET l_oma.oma54 = l_nmh.nmh02
   LET l_oma.oma54t= l_nmh.nmh02
   LET l_oma.oma56 = l_nmh.nmh32
   LET l_oma.oma56t= l_nmh.nmh32
   LET l_oma.oma58 = 0
   LET l_oma.oma59 = 0
   LET l_oma.oma59x= 0
   LET l_oma.oma59t= 0
   LET l_oma.oma60 = l_oma.oma24
   LET l_oma.oma61 = l_oma.oma56t - l_oma.oma57
   LET l_oma.oma65 = '1'
   LET l_oma.oma64 = '1'   #MOD-D10164
   LET l_oma.oma70 = '1'   #MOD-D10164
#MOD-AC0302--add--str--
   LET l_oma.oma68 = l_nmh.nmh11 
   LET l_oma.oma69  = l_nmh.nmh30 
   LET l_oma.oma51  = 0
   LET l_oma.oma51f = 0  
   SELECT occ45 INTO l_oma.oma32 FROM occ_file
    WHERE occ01 = l_oma.oma68
#MOD-AC0302--add--end--
   LET l_oma.omaconf='Y'
   LET l_oma.omavoid='N'
   LET l_oma.omauser=g_user
   LET l_oma.omagrup=g_grup
   LET l_oma.omadate=g_today
 
   LET l_oma.omalegal = g_legal 
 
   LET l_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
#No.FUN-AB0034 --begin
    IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
    IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
    IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF
#No.FUN-AB0034 --end
   INSERT INTO oma_file VALUES(l_oma.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","oma_file",l_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)
      LET g_success='N'
      RETURN
   END IF
   UPDATE nmh_file SET nmh17=l_nmh.nmh02 WHERE nmh01=l_nmh.nmh01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","nmh_file",l_nmh.nmh01,"",SQLCA.sqlcode,"","upd nmh17",1)
      LET g_success='N'
      RETURN
   END IF
END FUNCTION

#MOD-AC0302--add--str--
FUNCTION t200_ins_omc(p_nmh01)
DEFINE l_omc   RECORD LIKE omc_file.*,
       l_oma   RECORD LIKE oma_file.*,
       l_omc08 LIKE omc_file.omc08,
       l_omc09 LIKE omc_file.omc09,
       l_omc02 LIKE omc_file.omc02,
       p_nmh01 LIKE nmh_file.nmh01


   INITIALIZE l_oma.* TO NULL
   SELECT * INTO l_oma.* FROM oma_file WHERE oma01 = p_nmh01

   CALL s_ar_oox03(l_oma.oma01) RETURNING g_net

   IF l_oma.oma00[1,1] = '2' THEN
      LET l_omc.omc01 = l_oma.oma01
      LET l_omc.omc02 = 1
      LET l_omc.omc03 = l_oma.oma32
      LET l_omc.omc04 = l_oma.oma11
      LET l_omc.omc05 = l_oma.oma12
      LET l_omc.omc06 = l_oma.oma24
      LET l_omc.omc07 = l_oma.oma60
      LET l_omc.omc08 = l_oma.oma54t
      LET l_omc.omc09 = l_oma.oma56t
      LET l_omc.omc10 = 0
      LET l_omc.omc11 = 0
      LET l_omc.omc12 = l_oma.oma10
      LET l_omc.omc13 = l_omc.omc09-l_omc.omc11+g_net
      LET l_omc.omc14 = 0
      LET l_omc.omc15 = 0

      CALL cl_digcut(l_omc.omc08,g_azi04) RETURNING l_omc.omc08
      CALL cl_digcut(l_omc.omc09,t_azi04) RETURNING l_omc.omc09
      CALL cl_digcut(l_omc.omc13,t_azi04) RETURNING l_omc.omc13

      LET l_omc.omclegal = g_legal

      INSERT INTO omc_file VALUES(l_omc.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","omc_file","omc01","omc02",SQLCA.sqlcode,"","",1)
         LET g_success ='N'
         RETURN
      END IF
   END IF
   SELECT SUM(omc08),SUM(omc09),MAX(omc02) INTO l_omc08,l_omc09,l_omc02
     FROM omc_file
    WHERE omc01 = l_oma.oma01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","omc_file",l_oma.oma01,"",SQLCA.sqlcode,"","",1)
      LET g_success ='N'
      RETURN
   END IF
   IF cl_null(l_omc08) THEN
      LET l_omc08 = 0
   END IF
   IF cl_null(l_omc09) THEN
      LET l_omc09 = 0
   END IF
   IF l_omc08 <> l_oma.oma54t THEN
      UPDATE omc_file SET omc08 = omc08-(l_omc08-l_oma.oma54t)
       WHERE omc01 = l_oma.oma01
         AND omc02 = l_omc02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","omc_file",l_oma.oma01,l_omc02,SQLCA.sqlcode,"","",1)
         LET g_success ='N'
         RETURN
      END IF
   END IF
   IF l_omc09 <> l_oma.oma56t THEN
      UPDATE omc_file SET omc09 = omc09-(l_omc09-l_oma.oma56t)
       WHERE omc01 = l_oma.oma01
         AND omc02 = l_omc02
      IF SQLCA.sqlcode THEN
         CALL cl_err3("upd","omc_file",l_oma.oma01,l_omc02,SQLCA.sqlcode,"","",1)
         LET g_success ='N'
         RETURN
      END IF
   END IF
   SELECT MAX(omc04),MAX(omc05) INTO l_oma.oma11,l_oma.oma12 FROM omc_file
    WHERE omc01 = l_oma.oma01
   UPDATE oma_file SET oma11 = l_oma.oma11,
                       oma12 = l_oma.oma12
    WHERE oma01 = l_oma.oma01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","oma_file",l_oma.oma11,l_oma.oma12,SQLCA.sqlcode,"","",1)
   END IF
END FUNCTION
#MOD-AC0302--add--end--

#NO.FUN-B40003--start--
FUNCTION t200_collection_discount()
   DEFINE l_sql      LIKE type_file.chr1000
   #darcy:2024/08/22 add s---
   define l_npo04 		like npo_file.npo04
   #darcy:2024/08/22 add e---
   LET g_nmh_t.* = g_nmh.*
   
   SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
  
	IF g_nmh.nmh38 = 'N' THEN  CALL cl_err(g_nmh.nmh01,'anm-960',1) RETURN END IF
	IF g_nmh.nmh38 = 'X' THEN  CALL cl_err('','9024',1) RETURN END IF
	IF g_nmh.nmh24 != '1' THEN  
		#darcy:2024/08/22 mod s---
		# 如果转付还有余额的情况,也可以做托收
		
		if g_nmh.nmh24 != '5' then
			CALL cl_err(g_nmh.nmh01,'anm-347',1) 
			RETURN
		else
			select sum(npo04) into l_npo04 from npo_file,npn_file
			where npn01 = npo01 and npnconf = 'Y' and npo03 = g_nmh.nmh01
			if cl_null(l_npo04) then let l_npo04 = 0 end if
			if g_nmh.nmh02 - l_npo04 <= 0 then
                CALL cl_err(g_nmh.nmh01,'anm-347',1) 
			    RETURN
            end if
		end if
		#darcy:2024/08/22 mod e---
	END IF
   
   BEGIN WORK
   OPEN t200_cl USING g_nmh.nmh01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
  
   FETCH t200_cl INTO g_nmh.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
      CLOSE t200_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   
   CALL t200_collection_nmh21()     #進行input處理
   LET g_nmi05=g_nmh.nmh24   #MOD-C30499
   LET g_nmi08=g_nmh.nmh28
   LET g_nmh.nmh24 = '2'
   
   IF INT_FLAG THEN                       # 若按了ESC鍵
      LET INT_FLAG = 0
      CLOSE t200_cl
      ROLLBACK WORK
      LET g_nmh.nmh19 = g_nmh_t.nmh19
      LET g_nmh.nmh20 = g_nmh_t.nmh20
      LET g_nmh.nmh21 = g_nmh_t.nmh21
      LET g_nmh.nmh24 = g_nmh_t.nmh24
      LET g_nmh.nmh25 = g_nmh_t.nmh25
      DISPLAY BY NAME g_nmh.nmh19,
                      g_nmh.nmh20,
                      g_nmh.nmh21,
                      g_nmh.nmh24,
                      g_nmh.nmh25
      ROLLBACK WORK
      RETURN
   END IF
   
   LET g_sql = "UPDATE nmh_file SET nmh24 = '",g_nmh.nmh24,"',",
                                   "nmh19 = '",g_nmh.nmh19,"',",
                                   "nmh20 = '",g_nmh.nmh20,"',",
                                   "nmh21 = '",g_nmh.nmh21,"',",
                                   "nmh25 = '",g_nmh.nmh25,"'",
               " WHERE nmh01='",g_nmh.nmh01 ,"'"
   PREPARE t200_collection_p FROM g_sql
   EXECUTE t200_collection_p
   IF STATUS OR SQLCA.SQLERRD[3] = 0  THEN
      CALL cl_err3("upd","nmh_file",g_nmh01_t,"",SQLCA.sqlcode,"","(t200_u:nmh)",1)
      SELECT * INTO g_nmh.* FROM nmh_file WHERE nmh01 = g_nmh.nmh01
      CLOSE t200_cl
      ROLLBACK WORK
   ELSE
      CLOSE t200_cl
      COMMIT WORK
   END IF
   CALL t200_ins_nmi()              #MOD-C30499  ADD
   CALL t200_show()
END FUNCTION

FUNCTION t200_collection_nmh21()
   INPUT BY NAME  g_nmh.nmh20,g_nmh.nmh21  WITHOUT DEFAULTS
     BEFORE INPUT
       LET g_nmh.nmh19 = '2'
       LET g_nmh.nmh20 = g_today
       LET g_nmh.nmh25 = g_nmh.nmh20
       
       
      #AFTER FIELD nmh21  #託貼銀行  #No.MOD-BC0007 mark
       AFTER INPUT                   #No.MOD-BC0007
            IF INT_FLAG THEN EXIT INPUT  END IF  #No.MOD-BC0007
            IF g_nmh.nmh19 IS NOT NULL AND g_nmh.nmh21 IS NULL THEN
               NEXT FIELD nmh21
            END IF
            IF g_nmh.nmh21 IS NOT NULL THEN
               CALL t200_nmh21('a')
               IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_nmh.nmh21,g_errno,0)
                   LET g_nmh.nmh21 = g_nmh_o.nmh21
                   DISPLAY BY NAME g_nmh.nmh21
                   NEXT FIELD nmh21
               END IF
            END IF
            LET g_nmh_o.nmh21 = g_nmh.nmh21
            
     ON ACTION CONTROLP
        CASE
            WHEN INFIELD(nmh21)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.default1 = g_nmh.nmh21
                  CALL cl_create_qry() RETURNING g_nmh.nmh21
                  DISPLAY BY NAME g_nmh.nmh21
                  NEXT FIELD nmh21
            OTHERWISE EXIT CASE
        END CASE
        ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
   END INPUT
END FUNCTION

FUNCTION t200_undo_collection_discount()
    DEFINE l_sql      LIKE type_file.chr1000
    DEFINE l_cnt      LIKE type_file.num5        #MOD-C10189 add
    IF g_nmh.nmh24 != '2' THEN  CALL cl_err(g_nmh.nmh01,'anm-347',0) RETURN END IF
   #-----------------------------MOD-C10189--------------------start
#No.MOD-C90231 --begin
    IF g_aza.aza26 = '2' THEN 
       SELECT COUNT(*) INTO l_cnt 
         FROM npo_file,npn_file
        WHERE npo03 = g_nmh.nmh01
          AND npn01 = npo01
          AND npn03 = '4'
    ELSE 
       SELECT COUNT(*) INTO l_cnt 
         FROM npo_file,npn_file
        WHERE npo03 = g_nmh.nmh01
          AND npn01 = npo01
          AND npn03 = '2'
    END IF 
#No.MOD-C90231 --end
    IF l_cnt > 0 THEN
       CALL cl_err(g_nmh.nmh01,'anm-242',1)
       RETURN
    END IF
   #-----------------------------MOD-C10189----------------------end
    IF NOT cl_confirm('anm-825') THEN RETURN END IF
   
    BEGIN WORK
   OPEN t200_cl USING g_nmh.nmh01
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_nmh.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
      CLOSE t200_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   
   LET g_nmh.nmh25 = g_nmh.nmh04
   LET g_nmh.nmh19 = NULL
   LET g_nmh.nmh20 = NULL
   LET g_nmh.nmh21 = NULL
   #darcy:2024/08/22 mod s---
   # 还原后的状态应该取自nmi05
    select nmi05 into g_nmh.nmh24 from nmi_file
     where nmi01 = g_nmh.nmh01 and nmi06 = '2'
    if cl_null(g_nmh.nmh24) then
        LET g_nmh.nmh24 = '1' #TODO ,这里状态要根据nmi写
    end if
   #darcy:2024/08/22 mod e---
   LET g_success='Y'

   UPDATE nmh_file SET nmh19 = g_nmh.nmh19,
                       nmh20 = g_nmh.nmh20,
                       nmh21 = g_nmh.nmh21,
                       nmh24 = g_nmh.nmh24,
                       nmh25 = g_nmh.nmh25
   WHERE nmh01 = g_nmh.nmh01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","upd nmh_file",1)
      LET g_success ='N'
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1) 
      COMMIT WORK
   ELSE 
      CALL cl_rbmsg(1) 
      ROLLBACK WORK
   END IF
   DELETE FROM nmi_file WHERE nmi01=g_nmh.nmh01  AND nmi06='2'  #MOD-C30499
   CALL t200_show()
END FUNCTION
#NO.FUN-B40003--end--

#No.FUN-9C0073 -----------------By chenls 10/01/15
#MOD-C30499--ADD--STR
FUNCTION t200_ins_nmi()
   INITIALIZE g_nmi.* TO NULL
   LET g_nmi.nmi01 = g_nmh.nmh01
   LET g_nmi.nmi02 = g_nmh.nmh20
   SELECT MAX(nmi03) INTO g_nmi.nmi03 FROM nmi_file
    WHERE nmi01=g_nmh.nmh01
   IF cl_null(g_nmi.nmi03) THEN LET g_nmi.nmi03=0 END IF
   LET g_nmi.nmi03 = (g_nmi.nmi03 + 1) using '<<<<<' #darcy:2024/08/22 add using
   LET g_nmi.nmi04 = g_user
   LET g_nmi.nmi05 = g_nmi05 
   LET g_nmi.nmi06 = '2'
   LET g_nmi.nmi07 = g_nmh.nmh11
   LET g_nmi.nmi08 = g_nmi08
   LET g_nmi.nmi09 = g_nmh.nmh28

   LET g_nmi.nmilegal = g_legal

   INSERT INTO nmi_file VALUES(g_nmi.*)
   IF SQLCA.sqlcode THEN
      LET g_showmsg=g_nmi.nmi01,"/",g_nmi.nmi03
      CALL s_errmsg('nmi01,nmi03',g_showmsg,'t200_ins_nmi',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

#MOD-C30499--ADD--END

#No.FUN-D40120 ---Add--- Start
FUNCTION t200_copy()
   DEFINE l_newno      LIKE nmh_file.nmh01,
          l_oldno      LIKE nmh_file.nmh01
   DEFINE l_i          LIKE type_file.num5
   DEFINE li_result    LIKE type_file.num5

   IF s_shut(0) THEN RETURN END IF
   IF  g_nmh.nmh01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_before_input_done = FALSE
   CALL t200_set_entry('a')
   CALL t200_set_no_entry('a')
   LET g_before_input_done = TRUE

   INPUT l_newno FROM nmh01

      AFTER FIELD nmh01
         IF l_newno IS NULL THEN
            NEXT FIELD nmh01
         END IF
         CALL s_check_no("anm",l_newno,g_nmh01_t,"2","nmh_file","nmh01","")
            RETURNING li_result,l_newno
         DISPLAY BY NAME l_newno
         IF (NOT li_result) THEN
            NEXT FIELD nmd01
         END IF
      ON ACTION controlp
         CASE
            WHEN INFIELD(nmh01)
               LET g_t1 = s_get_doc_no(l_newno)
               CALL q_nmy(FALSE,FALSE,g_t1,'2','ANM')
                  RETURNING g_t1
               LET l_newno = g_t1
               DISPLAY BY NAME l_newno
               NEXT FIELD nmh01
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
      DISPLAY BY NAME g_nmh.nmh01
      RETURN
   END IF
   DROP TABLE x
   SELECT * FROM nmh_file
    WHERE nmh01 = g_nmh.nmh01
     INTO TEMP x

   CALL s_auto_assign_no("anm",l_newno,g_nmh.nmh04,"2","nmh_file","nmh01","","","")
      RETURNING li_result,l_newno
   IF (NOT li_result) THEN
      RETURN
   END IF

   UPDATE x
      SET nmh01  =l_newno,  #資料鍵值
          nmhuser=g_user,   #資料所有者
          nmhgrup=g_grup,   #資料所有者所屬群
          nmhmodu=NULL,     #資料修改日期
          nmhdate=g_today,  #資料建立日期
          nmhoriu=g_today,
          nmhorig=g_today,
          nmh24 ='1',
          nmh17 = 0,
          nmh42 = 0,
          nmh04 = g_today,
          nmh25 = g_today,
          nmh35 = '',
          nmh38 ='N'        #審核碼
   INSERT INTO nmh_file SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nmh.nmh01,SQLCA.sqlcode,0)
   ELSE
      MESSAGE 'ROW(',l_newno,') O.K'
      SELECT nmh_file.* INTO g_nmh.* FROM nmh_file
       WHERE nmh01 =  l_newno
      CALL t200_u()
   END IF
   DISPLAY BY NAME g_nmh.nmh01
END FUNCTION
#No.FUN-D40120 ---Add--- End

# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: saapt900.4gl
# Descriptions...: 成本分攤
# Date & Author..: 00/03/15 By Flora
# Modify.........: No.7277 03/05/23 By Kammy
#                           1.將拋轉傳票程式移到aapp400
#                           2.分錄底稿統一用 s_fsgl 程式,s_fsgla取消
#                         * 3.npp00 原為 '5'，因被重覆使用，改為 '4'
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.8009 03/09/15 By Kitty 分攤改為確認
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.FUN-4C0047 04/12/08 By Nicola 權限控管修改
# Modify.........: No.MOD-530684 05/04/06 By Nicola 目的應付帳款單身的單號選擇後沒有ENTER,資料會帶不全
# Modify.........: NO.FUN-550030 05/05/13 By will 加大單據編號格式長度 05/05/18 By ice 修改報表
# Modify.........: No.MOD-550001 05/05/16 By ching 有傳票不可取消確認
# Modify.........: NO.FUN-560002 05/06/06 By ice 加大單據編號格式長度
# Modify.........: No.MOD-590319 05/09/15 By Dido 檢查來源、目的帳款若有已作廢單號或外購，不可做分攤的動作
# Modify.........: No.MOD-5A0164 05/10/24 By Dido 報表調整
# Modify.........: No.MOD-590316 05/11/03 By Smapmin 分攤來源的帳款編號開放可重覆輸入,
#                                                    但要控管是否還有可被分攤的金額
# Modify.........: No.MOD-5B0053 05/11/28 By ice 分攤時,同時回寫來源預付的apa73
# Modify.........: No.TQC-5B0087 05/12/06 By Smapmin 分攤總金額與應付金額不符的問題,請依分攤總金額為主逐筆分攤至目的帳款中,
#                                                    若有差異請調整至目的帳款中之最大金額(分攤後金額)上
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify..........: No.TQC-630134 06/03/30 By Smapmin 拿掉apz24的判斷
# Modify.........: No.FUN-630081 06/03/31 By Smapmin 拿掉單頭的CONTROLO
# Modify.........: No.MOD-640294 06/04/10 By Smapmin 來源帳款不可以選擇沖暫估的帳款
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/04 By rainy 權限修正
# Modify.........: No.MOD-670024 06/07/06 By Rayven 報表中from和頁次未靠右
# Modify.........: No.FUN-670060 06/07/28 By wujie 新增"直接拋轉總帳"功能
# Modify.........: No.MOD-680032 06/08/07 By Smapmin 修正TQC-5B0087
# Modify.........: No.FUN-680029 06/08/17 By Elva 兩套帳功能新增
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.FUN-680064 06/10/18 By johnray 在新增函數_a()中單身函數_b()前初始化g_rec_b
# Modify.........: No.FUN-690080 06/10/26 By ice 分攤來源單身中可以選擇13,25類型的帳款
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0016 06/11/11 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6A0081 06/11/15 By baogui  欄位不對齊修改
# Modify.........: No.FUN-6B0033 06/11/16 By hellen 新增單頭折疊功能			
# Modify.........: No.TQC-6B0087 06/12/05 By Smapmin UPDATE 後要使用SQLCA.SQLERRD[3]=0來判斷
# Modify.........: NO.TQC-6A0031 06/12/06 By Smapmin 查詢條件加上分攤確認與確認
# Modify.........: No.TQC-6C0044 06/12/22 By Smapmin 修改回寫待抵已付金額
# Modify.........: No.MOD-710135 07/01/23 By Smapmin 修改分攤單號開窗查詢
# Modify.........: No.TQC-6B0105 07/03/06 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730048 07/03/14 By Smapmin 修改帳款編號開窗查詢
# Modify.........: No.FUN-730064 07/04/04 By arman   會計科目加帳套
# Modify.........: No.MOD-730098 07/04/16 By Smapmin 刪除重複程式段
# Modify.........: No.CHI-750011 07/05/09 By kim AFTER FIELD aqc02 那段應先判斷有值才跑
# Modify.........: No.MOD-750025 07/05/11 By Smapmin 修改aqc02欄位的控管
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-750121 07/05/23 By rainy 加傳參數g_argv3(g_wc)
# Modify.........: No.TQC-770055 07/07/10 By rainy 補TQC-750121被蓋回舊程式
# Modify.........: No.FUN-770093 07/10/26 By zhoufeng 報表打印改為Crystal Report
# Modify.........: No.TQC-7B0051 07/11/13 By Smapmin 單別不產生分錄則不需執行傳票拋轉還原動作
# Modify.........: No.MOD-7B0159 07/11/20 By Smapmin 拋轉傳票時,user要帶g_aqa.aqauser
# Modify.........: No.MOD-7B0107 07/11/21 By Carrier t900_aqb02()中s_get_bookno的SELECT結果影響了SQLCA.sqlcode判斷
# Modify.........: No.TQC-7B0083 07/11/30 By Carrier 目的帳款去除衝暫估資料
# Modify.........: No.MOD-7B0222 07/12/06 By Smapmin 帳款日期需檢核sma53
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810215 08/01/31 By Smapmin 已有分攤的記錄,就不可再分攤
# Modify.........: No.MOD-820031 08/02/13 By Smapmin 自動產生目的帳款單身時,限制不可大於最大筆數
# Modify.........: No.MOD-820050 08/03/12 By Smapmin 費用類暫估放來源帳款,一般暫估放目的帳款
# Modify.........: No.MOD-830144 08/03/19 By Smapmin 來源帳款日期不需卡成本關帳日.
# Modify.........: No.FUN-850038 08/05/09 By TSD.sar2436 自定欄位功能修改
# Modify.........: No.MOD-860075 08/06/10 By Carrier 直接拋轉總帳時，aba07(來源單號)沒有取得值
# Modify.........: No.FUN-860107 08/07/24 By sherry 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-970285 09/08/03 By sabrina (1)按取消確認時，apa35、apa35f的值沒有更新回來
#                                                    (2)單據確認後，沒有回寫apc_file
# Modify.........: No.FUN-9A0099 09/10/29 By TSD.apple   GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-9C0072 09/12/18 By vealxu  精簡程式碼
# Modify.........: No:MOD-A20039 10/02/08 By wujie   成本分摊后，应提示重新产生分录底稿 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A40065 10/04/13 By sabrina 目的帳款輸入的單據的日期不可超過分攤日期
# Modify.........: No.FUN-A50102 10/06/02 By lutingting 跨庫寫法統一改為用cl_get_target_table()來實現 
# Modify.........: No:CHI-A50028 10/07/27 By Summer aqaconf 改用下拉選單,增加作廢'X'選項
# Modify.........: No:MOD-A80107 10/08/13 By Dido 增加作廢碼過濾條件 
# Modify.........: No:MOD-A80248 10/09/02 By Dido 若已被沖帳應不可再做分攤 
# Modify.........: No:MOD-A10149 10/09/28 By sabrina 成本分攤後,雜項請款多帳期之已付金額變成null.
# Modify.........: No:MOD-AC0264 10/12/22 By Dido 增加 oma00 = '23' 條件 
# Modify.........: No:MOD-B10041 11/01/06 By Dido aapp400 增加參數 gl_summary = 'Y' 
# Modify.........: No:MOD-B20069 11/02/17 By Dido 更新待抵帳款位置有誤 
# Modify.........: No:CHI-B20013 11/03/01 By Summer 第三個單身增加查詢功能
# Modify.........: No:MOD-B30052 11/03/08 By Dido 待抵分批分攤時,需排除未確認的分攤資料 
# Modify.........: NO.FUN-B30211 11/03/30 By yangtingting 未加離開前得cl_used(2)
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/17 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50062 11/05/18 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B50200 11/05/23 By Sarah 確認/取消確認時也應回寫aapt220的已沖金額
# Modify.........: No:MOD-B60040 11/06/08 By Dido 22類取消*-1 
# Modify.........: No:MOD-B80061 11/08/09 By Dido 回寫待抵原幣計算邏輯調整 
# Modify.........: No:MOD-BC0134 11/12/13 By Polly 取消確認時，為待抵預付時，增加判斷給予apa35f值 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C30691 12/03/14 By minpp 一律不可維護確認碼(aqaconf)欄位
# Modify.........: No:MOD-C30706 12/03/14 By lujh 單據取消作廢時，應再次檢查"分攤來源"金額是否足以分攤，並檢查"分攤目的"的帳款編號是否已存在。
#                                                 當單別無須拋轉傳票時,如有按分錄底稿,則直接 return
# Modify.........: No:MOD-C50093 12/05/17 By Polly 呼叫aap400所產生的傳票編號改用匯總訊息顯示
# Modify.........: No.MOD-C50243 12/06/01 By Polly 拿除清訊息功能
# Modify.........: No.CHI-C30107 12/06/21 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C70093 12/07/23 By minpp 1.录入是默认aqa00='1'，成本分摊2.修改q_apa6傳參數,增加参数：aapt900,'','',''
# Modify.........: No:CHI-C90051 12/09/08 By Polly 將拋轉還原程式移至更新確認碼/過帳碼前處理，並判斷傳票編號如不為null時，則RETURN
# Modify.........: No.FUN-C90126 12/10/16 By xuxz  q_apb1添加參數
# Modify.........: No:FUN-D20035 13/02/20 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D30032 13/04/01 By fengrui 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_azi           RECORD LIKE azi_file.*,       #原幣幣別 record
    g_apa           RECORD LIKE apa_file.*,       #付款單   (假單頭)
    g_aqa           RECORD LIKE aqa_file.*,       #付款單   (假單頭)
    g_aqa_t         RECORD LIKE aqa_file.*,       #付款單   (舊值)
    g_aqa_o         RECORD LIKE aqa_file.*,       #付款單   (舊值)
    g_aqa01_t       LIKE aqa_file.aqa01,   # Pay No.     (舊值)
    g_aqb           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aqb02           LIKE aqb_file.aqb02,
        apa02           LIKE apa_file.apa02,
        apa51           LIKE apa_file.apa51,
        apa511          LIKE apa_file.apa511, #FUN-680029
        apa06           LIKE apa_file.apa06,
        apa07           LIKE apa_file.apa07,
        aqb03           LIKE aqb_file.aqb03,
        aqb04           LIKE aqb_file.aqb04,
        aqbud01 LIKE aqb_file.aqbud01,
        aqbud02 LIKE aqb_file.aqbud02,
        aqbud03 LIKE aqb_file.aqbud03,
        aqbud04 LIKE aqb_file.aqbud04,
        aqbud05 LIKE aqb_file.aqbud05,
        aqbud06 LIKE aqb_file.aqbud06,
        aqbud07 LIKE aqb_file.aqbud07,
        aqbud08 LIKE aqb_file.aqbud08,
        aqbud09 LIKE aqb_file.aqbud09,
        aqbud10 LIKE aqb_file.aqbud10,
        aqbud11 LIKE aqb_file.aqbud11,
        aqbud12 LIKE aqb_file.aqbud12,
        aqbud13 LIKE aqb_file.aqbud13,
        aqbud14 LIKE aqb_file.aqbud14,
        aqbud15 LIKE aqb_file.aqbud15
                    END RECORD,
    g_aqb_t         RECORD                 #程式變數 (舊值)
        aqb02           LIKE aqb_file.aqb02,
        apa02           LIKE apa_file.apa02,
        apa51           LIKE apa_file.apa51,
        apa511          LIKE apa_file.apa511, #FUN-680029
        apa06           LIKE apa_file.apa06,
        apa07           LIKE apa_file.apa07,
        aqb03           LIKE aqb_file.aqb03,
        aqb04           LIKE aqb_file.aqb04,
        aqbud01 LIKE aqb_file.aqbud01,
        aqbud02 LIKE aqb_file.aqbud02,
        aqbud03 LIKE aqb_file.aqbud03,
        aqbud04 LIKE aqb_file.aqbud04,
        aqbud05 LIKE aqb_file.aqbud05,
        aqbud06 LIKE aqb_file.aqbud06,
        aqbud07 LIKE aqb_file.aqbud07,
        aqbud08 LIKE aqb_file.aqbud08,
        aqbud09 LIKE aqb_file.aqbud09,
        aqbud10 LIKE aqb_file.aqbud10,
        aqbud11 LIKE aqb_file.aqbud11,
        aqbud12 LIKE aqb_file.aqbud12,
        aqbud13 LIKE aqb_file.aqbud13,
        aqbud14 LIKE aqb_file.aqbud14,
        aqbud15 LIKE aqb_file.aqbud15
                    END RECORD,
    g_aqc           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        aqc02           LIKE aqc_file.aqc02,
        aqc03           LIKE aqc_file.aqc03,
        aqc04           LIKE aqc_file.aqc04,
        aqc05           LIKE aqc_file.aqc05,
        aqc06           LIKE aqc_file.aqc06,
        aqc07           LIKE aqc_file.aqc07,
        aqc08           LIKE aqc_file.aqc08,
        aqcud01 LIKE aqc_file.aqcud01,
        aqcud02 LIKE aqc_file.aqcud02,
        aqcud03 LIKE aqc_file.aqcud03,
        aqcud04 LIKE aqc_file.aqcud04,
        aqcud05 LIKE aqc_file.aqcud05,
        aqcud06 LIKE aqc_file.aqcud06,
        aqcud07 LIKE aqc_file.aqcud07,
        aqcud08 LIKE aqc_file.aqcud08,
        aqcud09 LIKE aqc_file.aqcud09,
        aqcud10 LIKE aqc_file.aqcud10,
        aqcud11 LIKE aqc_file.aqcud11,
        aqcud12 LIKE aqc_file.aqcud12,
        aqcud13 LIKE aqc_file.aqcud13,
        aqcud14 LIKE aqc_file.aqcud14,
        aqcud15 LIKE aqc_file.aqcud15
 
                    END RECORD,
    g_aqc_t         RECORD
        aqc02           LIKE aqc_file.aqc02,
        aqc03           LIKE aqc_file.aqc03,
        aqc04           LIKE aqc_file.aqc04,
        aqc05           LIKE aqc_file.aqc05,
        aqc06           LIKE aqc_file.aqc06,
        aqc07           LIKE aqc_file.aqc07,
        aqc08           LIKE aqc_file.aqc08,
        aqcud01 LIKE aqc_file.aqcud01,
        aqcud02 LIKE aqc_file.aqcud02,
        aqcud03 LIKE aqc_file.aqcud03,
        aqcud04 LIKE aqc_file.aqcud04,
        aqcud05 LIKE aqc_file.aqcud05,
        aqcud06 LIKE aqc_file.aqcud06,
        aqcud07 LIKE aqc_file.aqcud07,
        aqcud08 LIKE aqc_file.aqcud08,
        aqcud09 LIKE aqc_file.aqcud09,
        aqcud10 LIKE aqc_file.aqcud10,
        aqcud11 LIKE aqc_file.aqcud11,
        aqcud12 LIKE aqc_file.aqcud12,
        aqcud13 LIKE aqc_file.aqcud13,
        aqcud14 LIKE aqc_file.aqcud14,
        aqcud15 LIKE aqc_file.aqcud15
                    END RECORD,
    g_aps           RECORD LIKE aps_file.*,
    g_wc,g_wc2      STRING,                    #No:FUN-580092 HCN
    g_wc3           STRING,                    #CHI-B20013 add
    g_sql,g_sql1    STRING,                    #No:FUN-580092 HCN
    g_rec_b,g_rec_b2    LIKE type_file.num5,            #單身筆數  #No.FUN-690028 SMALLINT
    m_aqa           RECORD LIKE aqa_file.*,
    m_aqb           RECORD LIKE aqb_file.*,
    m_aqc           RECORD LIKE aqc_file.*,
    g_buf           LIKE type_file.chr1000,             #  #No.FUN-690028 VARCHAR(78)
    g_aptype        LIKE type_file.chr2,        # No.FUN-690028 VARCHAR(2)               #帳款種類
    g_dbs_nm        LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21)
    g_net           LIKE apv_file.apv04,  #MOD-5B0053
    g_aqa03         LIKE aqa_file.aqa03,  #FUN-4B0079
    g_tot1          LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_tot2          LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_tot3          LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_tot4          LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_tot5          LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_tot           LIKE type_file.num20_6,     # No.FUN-690028 DEC(20,6),  #FUN-4B0079
    g_apa51         LIKE apa_file.apa51,
    g_statu         LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(01),              #是否從新賦予等級
    gl_no_b         LIKE abb_file.abb01,      # No.FUN-690028 VARCHAR(16),              #No.FUN-550030
    gl_no_e         LIKE abb_file.abb01,      # No.FUN-690028 VARCHAR(16),              #No.FUN-550030
    g_note_days     LIKE type_file.num5,        # No.FUN-690028 SMALLINT,              #最大票期
    g_add           LIKE type_file.chr1,        # No.FUN-690028 VARCHAR(1),               #是否為 Add Mode
    g_t1            LIKE oay_file.oayslip,               #單別  No.FUN-550030  #No.FUN-690028 VARCHAR(5)
    g_dbs_gl        LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21),              #工廠編號
    g_argv1         LIKE aqa_file.aqa01,   #付款單號
    g_argv2         STRING,                #No.FUN-630010 執行功能
    g_argv3         STRING,                #No.TQC-750121
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT  #No.FUN-690028 SMALLINT
    i               LIKE type_file.num5                 #目前處理的SCREEN LINE  #No.FUN-690028 SMALLINT
DEFINE g_add_entry  LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
#------for ora修改-------------------
DEFINE g_system         LIKE type_file.chr2        # No.FUN-690028 VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE g_N              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
#------for ora修改-------------------
DEFINE l_table      STRING                         #No.FUN-770093
DEFINE l_table1     STRING                         #No.FUN-770093
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose  #No.FUN-690028 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   g_jump         LIKE type_file.num10   #No.FUN-690028 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE  g_str           STRING     #No.FUN-670060
DEFINE  g_wc_gl         STRING     #No.FUN-670060
DEFINE  g_bookno1       LIKE aza_file.aza81     #NO.FUN-730064
DEFINE  g_bookno2       LIKE aza_file.aza82     #NO.FUN-730064
DEFINE  g_flag          LIKE  type_file.chr1    #NO.FUN-730064
DEFINE  g_void          LIKE type_file.chr1     #CHI-A50028 add
 
FUNCTION t900(p_argv1,p_argv2,p_argv3)    #No.FUN-630010  #TQC-750121
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE
   p_type        LIKE type_file.chr2,        # No.FUN-690028 VARCHAR(2)
   p_plant       LIKE type_file.chr20,       # No.FUN-690028 VARCHAR(12)
   l_dbs         LIKE type_file.chr21,       # No.FUN-690028 VARCHAR(21)
   p_argv1       LIKE aqa_file.aqa01,
   p_argv2       STRING,           #No.FUN-630010
   p_argv3       STRING            #No.TQC-750121 g_wc
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET g_sql="aqa01.aqa_file.aqa01,aqa02.aqa_file.aqa02,aqa03.aqa_file.aqa03,",
             "aqa05.aqa_file.aqa05,apa00.apa_file.apa00,apa01.apa_file.apa01,",
             "apa02.apa_file.apa02,apa51.apa_file.apa51,apa06.apa_file.apa06,",
             "apa07.apa_file.apa07,aqb03.aqb_file.aqb03,aqb04.aqb_file.aqb04,",
             "aqb01.aqb_file.aqb01,aqb02.aqb_file.aqb02"
   LET l_table = cl_prt_temptable('aapt900',g_sql) CLIPPED
   IF l_table = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM 
   END IF
 
   LET g_sql="aqc01.aqc_file.aqc01,aqc02.aqc_file.aqc02,aqc03.aqc_file.aqc03,",
             "apb12.apb_file.apb12,aqc05.aqc_file.aqc05,aqc04.aqc_file.aqc04,",
             "aqc06.aqc_file.aqc06,aqc07.aqc_file.aqc07,aqc08.aqc_file.aqc08"
   LET l_table1 = cl_prt_temptable('aapt9001',g_sql) CLIPPED
   IF l_table1 = -1 THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
      EXIT PROGRAM 
   END IF
 
   LET g_argv1 = p_argv1          #No.FUN-630010
   LET g_argv2 = p_argv2          #No.FUN-630010 
   LET g_argv3 = p_argv3          #No.TQC-750121
 
   LET g_forupd_sql = "SELECT * FROM aqa_file WHERE aqa01 = ?  FOR UPDATE"   
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t900_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET g_aptype = '41'
   LET g_add_entry='N'
 
   LET p_row = 1 LET p_col = 8
 
   OPEN WINDOW t900_w33 AT p_row,p_col WITH FORM "aap/42f/aapt900"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    IF g_aza.aza63 = 'N' THEN #不使用多帳套
       CALL cl_set_comp_visible("apa511",FALSE) 
    END IF
 
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv3) THEN   #TQC-750121
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t900_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t900_a()
            END IF
         OTHERWISE
            CALL t900_q()
      END CASE
   END IF
   WHILE TRUE
     LET g_action_choice = ""
     CALL t900_menu()
     IF g_action_choice = 'exit' THEN EXIT WHILE END IF
   END WHILE
   CLOSE WINDOW t900_w33
END FUNCTION
 
FUNCTION t900_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM                             #清除畫面
   CALL g_aqb.clear()
   CALL g_aqc.clear()
 
    IF NOT cl_null(g_argv3) THEN
       LET g_wc = g_argv3
       LET g_wc2=" 1=1 "
       LET g_wc3=" 1=1 "   #CHI-B20013 add
    ELSE  #TQC-750121 end
       IF g_argv1<>' ' THEN
          LET g_wc=" aqa01='",g_argv1,"'"
          LET g_wc2=" 1=1 "
          LET g_wc3=" 1=1 "   #CHI-B20013 add
       ELSE
          CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
          INITIALIZE g_aqa.* TO NULL      #No.FUN-750051
          CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
              aqa01, aqa02, aqainpd, aqa04, aqaconf, aqauser, aqagrup, aqamodu, aqadate, aqaacti,   #TQC-6A0031
              aqaud01,aqaud02,aqaud03,aqaud04,aqaud05,
              aqaud06,aqaud07,aqaud08,aqaud09,aqaud10,
              aqaud11,aqaud12,aqaud13,aqaud14,aqaud15
                  BEFORE CONSTRUCT
                     CALL cl_qbe_init()
 
             ON ACTION controlp
                CASE
                   WHEN INFIELD(aqa01) #查詢單据
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_aqa1"
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO aqa01
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
          LET g_wc = g_wc CLIPPED,cl_get_extra_cond('aqauser', 'aqagrup')
 
 
          LET g_wc2 = " 1=1"
          CONSTRUCT g_wc2 ON aqb02 
                        ,aqbud01,aqbud02,aqbud03,aqbud04,aqbud05
                        ,aqbud06,aqbud07,aqbud08,aqbud09,aqbud10
                        ,aqbud11,aqbud12,aqbud13,aqbud14,aqbud15
                    FROM s_aqb[1].aqb02
                        ,s_aqb[1].aqbud01,s_aqb[1].aqbud02,s_aqb[1].aqbud03,s_aqb[1].aqbud04,s_aqb[1].aqbud05
                        ,s_aqb[1].aqbud06,s_aqb[1].aqbud07,s_aqb[1].aqbud08,s_aqb[1].aqbud09,s_aqb[1].aqbud10
                        ,s_aqb[1].aqbud11,s_aqb[1].aqbud12,s_aqb[1].aqbud13,s_aqb[1].aqbud14,s_aqb[1].aqbud15
 
           	BEFORE CONSTRUCT
           	   CALL cl_qbe_display_condition(lc_qbe_sn)
             ON ACTION controlp
                CASE
                   WHEN INFIELD(aqb02)
                     #CALL q_apa6(TRUE,TRUE) RETURNING g_qryparam.multiret    #FUN-C70093
                      CALL q_apa6(TRUE,TRUE,'aapt900','','','') RETURNING g_qryparam.multiret   #FUN-C70093
                      DISPLAY g_qryparam.multiret TO aqb02
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

             #str CHI-B20013 add
             ON ACTION qbe_select
                CALL cl_qbe_list() RETURNING lc_qbe_sn
                CALL cl_qbe_display_condition(lc_qbe_sn)
             #end CHI-B20013 add
 
 
             #str CHI-B20013 mark
             #        ON ACTION qbe_save
             #           CALL cl_qbe_save()
             #end CHI-B20013 mark
          END CONSTRUCT
 
          IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF

         #str CHI-B20013 add
          LET g_wc3 = " 1=1"
          CONSTRUCT g_wc3 ON aqc02 
                        ,aqcud01,aqcud02,aqcud03,aqcud04,aqcud05
                        ,aqcud06,aqcud07,aqcud08,aqcud09,aqcud10
                        ,aqcud11,aqcud12,aqcud13,aqcud14,aqcud15
                    FROM s_aqc[1].aqc02
                        ,s_aqc[1].aqcud01,s_aqc[1].aqcud02,s_aqc[1].aqcud03,s_aqc[1].aqcud04,s_aqc[1].aqcud05
                        ,s_aqc[1].aqcud06,s_aqc[1].aqcud07,s_aqc[1].aqcud08,s_aqc[1].aqcud09,s_aqc[1].aqcud10
                        ,s_aqc[1].aqcud11,s_aqc[1].aqcud12,s_aqc[1].aqcud13,s_aqc[1].aqcud14,s_aqc[1].aqcud15
             BEFORE CONSTRUCT
                CALL cl_qbe_display_condition(lc_qbe_sn)

             ON ACTION controlp
                CASE
                   WHEN INFIELD(aqc02)
                      CALL cl_init_qry_var()
                      LET g_qryparam.state = "c"
                      LET g_qryparam.form ="q_aqc"
                      LET g_qryparam.default1 = g_aqc[1].aqc02
                      CALL cl_create_qry() RETURNING g_qryparam.multiret
                      DISPLAY g_qryparam.multiret TO aqc02
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
         #end CHI-B20013 add
       END IF
    END IF  #TQC-750121
    IF g_wc3 = " 1=1" THEN                           # 若單身未輸入條件   #CHI-B20013 add
       IF g_wc2 = " 1=1" THEN                           # 若單身未輸入條件
          LET g_sql = "SELECT aqa01 FROM aqa_file ",
                      " WHERE ", g_wc CLIPPED,
                      "   AND aqa00='1'",          #FUN-C70093 add--aqa00=1
                      " ORDER BY 1"
       ELSE                                        # 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE aqa01 ",
                      "  FROM aqa_file, aqb_file ",
                      " WHERE aqa01 = aqb01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      "   AND aqa00='1'",        #FUN-C70093 add--aqa00=1
                      " ORDER BY 1"
       END IF
   #str CHI-B20013 add
    ELSE
       IF g_wc2 = " 1=1" THEN                           # 若單身未輸入條件
          LET g_sql = "SELECT UNIQUE aqa01 ",
                      "  FROM aqa_file, aqc_file ",
                      " WHERE aqa01 = aqc01",
                      "   AND ", g_wc CLIPPED, " AND ",g_wc3 CLIPPED,
                      "   AND aqa00='1'",                                #FUN-C70093 add--aqa00=1
                      " ORDER BY 1"
       ELSE                                        # 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE aqa01 ",
                      "  FROM aqa_file, aqb_file, aqc_file",
                      " WHERE aqa01 = aqb01",
                      "   AND aqa01 = aqc01",
                      "   AND aqa00='1'",                                 #FUN-C70093 add--aqa00=1
                      "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                      " ORDER BY 1"
       END IF
    END IF
   #end CHI-B20013 add
 
    PREPARE t900_prepare FROM g_sql
    DECLARE t900_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t900_prepare
 
    IF g_wc3 = " 1=1" THEN                         # 取合乎條件筆數   #CHI-B20013 add
       IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
          LET g_sql="SELECT COUNT(*) FROM aqa_file WHERE ",g_wc CLIPPED,
                                                 "   AND aqa00='1'"                      #FUN-C70093 add--aqa00=1
       ELSE
          LET g_sql="SELECT COUNT(DISTINCT aqa01) FROM aqa_file,aqb_file WHERE ",
                    "aqb01=aqa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    "   AND aqa00='1'"                                                   #FUN-C70093 add--aqa00=1 
       END IF
   #str CHI-B20013 add
    ELSE
       IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
          LET g_sql="SELECT COUNT(DISTINCT aqa01) FROM aqa_file,aqc_file WHERE ",
                    "aqc01=aqa01 AND ",g_wc CLIPPED," AND ",g_wc3 CLIPPED,
                    "   AND aqa00='1'"                                                   #FUN-C70093 add--aqa00=1
       ELSE
          LET g_sql="SELECT COUNT(DISTINCT aqa01) FROM aqa_file,aqb_file,aqc_file WHERE ",
                    "aqb01=aqa01 AND aqc01=aqa01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED," AND ",g_wc3 CLIPPED,
                    "   AND aqa00='1'"                                                   #FUN-C70093 add--aqa00=1
       END IF
    END IF
   #end CHI-B20013 add
    PREPARE t900_precount FROM g_sql
    DECLARE t900_count CURSOR FOR t900_precount
END FUNCTION
 
FUNCTION t900_menu()
 
   WHILE TRUE
      CALL t900_bp("G")
      CASE g_action_choice
         WHEN "insert"
            LET g_add = 'Y'
            IF cl_chk_act_auth() THEN
               CALL t900_a()
            END IF
            LET g_add = NULL
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
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t900_o()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_aqb)
                                           ,base.TypeInfo.create(g_aqc),'')
             END IF
 
         WHEN "source_detail"
            IF cl_chk_act_auth() THEN
               CALL t900_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "object_detail"
            IF cl_chk_act_auth() THEN
               CALL t900_b2()
            ELSE
               LET g_action_choice = NULL
            END IF
         #No.8009
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t900_y()
               #CHI-A50028 add --start--
               IF g_aqa.aqaconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               #CHI-A50028 add --end--
              #CALL cl_set_field_pic(g_aqa.aqaconf,"","","","",g_aqa.aqaacti) #CHI-A50028 mark
               CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)  #CHI-A50028
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t900_z()
               #CHI-A50028 add --start--
               IF g_aqa.aqaconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               #CHI-A50028 add --end--
              #CALL cl_set_field_pic(g_aqa.aqaconf,"","","","",g_aqa.aqaacti)  #CHI-A50028 mark
               CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)  #CHI-A50028
            END IF
         #No.8009(end)
         #CHI-A50028 add --start--
         WHEN "void"
            IF cl_chk_act_auth() THEN
              #CALL t900_x()                  #FUN-D20035
               CALL t900_x(1)                  #FUN-D20035
               IF g_aqa.aqaconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)
            END IF
         #CHI-A50028 add --end--

         #FUN-D20035----add--str
         #取消作废
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t900_x(2)
               IF g_aqa.aqaconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)
            END IF
         #FUN-D20035---add---end

         WHEN "apportion"
            IF cl_chk_act_auth() THEN
               CALL t900_s()
            END IF
         WHEN "refirm"
            IF cl_chk_act_auth() THEN
               CALL t900_t()
            END IF
         WHEN "gen_entry"
            CALL t900_v('4')
         WHEN "entry_sheet"
            CALL s_fsgl('AP',4,g_aqa.aqa01,0,g_apz.apz02b,1,g_aqa.aqaconf,'0',g_apz.apz02p)#No.8009  
            CALL t900_npp02('0')
         WHEN "entry_sheet2"
            CALL s_fsgl('AP',4,g_aqa.aqa01,0,g_apz.apz02b,1,g_aqa.aqaconf,'1',g_apz.apz02p)#No.8009  
            CALL t900_npp02('1')
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_aqa.aqaconf = 'Y' THEN
                  CALL t900_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               IF g_aqa.aqaconf = 'Y' THEN
                  CALL t900_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_aqa.aqa01 IS NOT NULL THEN
                 LET g_doc.column1 = "aqa01"
                 LET g_doc.value1 = g_aqa.aqa01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t900_a()
DEFINE  li_result LIKE type_file.num5    #No.FUN-690028 SMALLINT
   IF s_aapshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM
   CALL g_aqb.clear()
   CALL g_aqc.clear()
   INITIALIZE g_aqa.* LIKE aqa_file.*             #DEFAULT 設定
   LET g_aqa01_t = NULL
   #預設值及將數值類變數清成零
   LET g_aqa.aqa00='1'    #FUN-C70093
   LET g_aqa.aqa02=g_today
   LET g_aqa.aqainpd=g_today
   LET g_aqa_o.* = g_aqa.*
   LET g_aqa.aqauser= g_user
   LET g_aqa.aqaoriu = g_user #FUN-980030
   LET g_aqa.aqaorig = g_grup #FUN-980030
   LET g_aqa.aqagrup= g_grup
   LET g_aqa.aqadate= g_today
   LET g_aqa.aqaacti= 'Y'             #資料有效
   LET g_aqa.aqa03  = 0
   LET g_aqa.aqa04  = 'N'
   LET g_aqa.aqaconf= 'N'             #No.8009
   LET g_aqa.aqalegal= g_legal  #FUN-980001 add
   LET g_note_days = 0
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t900_i("a")                #輸入單頭
      IF INT_FLAG THEN                #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_aqa.* TO NULL
         EXIT WHILE
      END IF
      IF g_aqa.aqa01 IS NULL THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
      CALL s_auto_assign_no("aap",g_aqa.aqa01,g_aqa.aqa02,"41","aqa_file","aqa01","","","")
      RETURNING li_result,g_aqa.aqa01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_aqa.aqa01
      INSERT INTO aqa_file VALUES (g_aqa.*)
 
      IF SQLCA.sqlcode THEN                           #置入資料庫不成功
         CALL cl_err3("ins","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_aqa.aqa01,'I')
      END IF
      SELECT aqa01 INTO g_aqa.aqa01 FROM aqa_file
       WHERE aqa01 = g_aqa.aqa01
      LET g_aqa01_t = g_aqa.aqa01        #保留舊值
      LET g_aqa_t.* = g_aqa.*
      CALL g_aqb.clear()
      LET g_rec_b = 0                    #No.FUN-680064
      LET g_add_entry='Y'
      CALL t900_b()                   #輸入單身-1
      SELECT COUNT(*) INTO g_cnt FROM aqb_file WHERE aqb01 = g_aqa.aqa01
      IF g_cnt = 0 THEN RETURN END IF
      CALL g_aqc.clear()
      LET g_rec_b2 = 0                    #No.FUN-680064
      CALL t900_b2()                   #輸入單身-2
      LET g_t1=s_get_doc_no(g_aqa.aqa01)
      SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t900_u()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_aqa.aqa01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqa04 = 'Y' THEN CALL cl_err('','mfg-060',0) RETURN END IF  #No.8009
   IF g_aqa.aqaconf = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF#No.8009
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
   IF g_aqa.aqaacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_aqa.aqa01,9027,0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_aqa01_t = g_aqa.aqa01
   LET g_aqa_o.* = g_aqa.*
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t900_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_aqa.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,1)      # 資料被他人LOCK
       CLOSE t900_cl
       ROLLBACK WORK RETURN
   END IF
   CALL t900_show()
   WHILE TRUE
      LET g_aqa01_t = g_aqa.aqa01
      LET g_aqa.aqamodu=g_user
      LET g_aqa.aqadate=g_today
      CALL t900_i("u")                      #欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         LET g_aqa.*=g_aqa_t.*
         CALL t900_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
      IF g_aqa.aqa01 != g_aqa01_t THEN            # 更改單號
         UPDATE aqb_file SET aqb01 = g_aqa.aqa01
          WHERE aqb01 = g_aqa01_t
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN   #TQC-6B0087
            CALL cl_err3("upd","aqb_file",g_aqa01_t,"",SQLCA.sqlcode,"","aqb",1)  #No.FUN-660122
            CONTINUE WHILE
         END IF
      END IF
      UPDATE aqa_file SET aqa_file.* = g_aqa.*
       WHERE aqa01 = g_aqa01_t
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN   #TQC-6B0087
         CALL cl_err3("upd","aqa_file",g_aqa01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t900_cl
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqa.aqa01,'U')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION
 
#處理INPUT
FUNCTION t900_i(p_cmd)
DEFINE
    l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入  #No.FUN-690028 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改  #No.FUN-690028 VARCHAR(1)
    l_paydate       LIKE type_file.dat,    #  #No.FUN-690028 DATE
    li_result   LIKE type_file.num5        #No.FUN-550030  #No.FUN-690028 SMALLINT
    CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
    INPUT BY NAME g_aqa.aqa01,g_aqa.aqa02,g_aqa.aqainpd, g_aqa.aqaoriu,g_aqa.aqaorig,
                  g_aqa.aqa04,g_aqa.aqaconf,g_aqa.aqauser,
                  g_aqa.aqagrup,g_aqa.aqamodu,g_aqa.aqadate,g_aqa.aqaacti,
                          g_aqa.aqaud01,g_aqa.aqaud02,g_aqa.aqaud03,g_aqa.aqaud04,
                          g_aqa.aqaud05,g_aqa.aqaud06,g_aqa.aqaud07,g_aqa.aqaud08,
                          g_aqa.aqaud09,g_aqa.aqaud10,g_aqa.aqaud11,g_aqa.aqaud12,
                          g_aqa.aqaud13,g_aqa.aqaud14,g_aqa.aqaud15 
        WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t900_set_entry(p_cmd)
         CALL t900_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("aqa01")
         #MOD-C30691--ADD--STR
            CALL cl_set_comp_entry ("aqaconf",FALSE)
         #MOD-C30691--ADD--END 
        AFTER FIELD aqa01                  #帳款編號
            IF NOT cl_null(g_aqa.aqa01) THEN
                CALL s_check_no("aap",g_aqa.aqa01,g_aqa01_t,"41","aqa_file","aqa01","")
                RETURNING li_result,g_aqa.aqa01
                DISPLAY BY NAME g_aqa.aqa01
                IF (NOT li_result) THEN
                    LET g_aqa.aqa01=g_aqa_o.aqa01
                    NEXT FIELD aqa01
                END IF
           END IF
 
        AFTER FIELD aqa02                  #付款日期不可小於關帳日期
            IF NOT cl_null(g_aqa.aqa02) THEN
               #FUN-B50090 add begin-------------------------
               #重新抓取關帳日期
               SELECT apz57 INTO g_apz.apz57 FROM apz_file WHERE apz00='0'
               #FUN-B50090 add -end--------------------------
               IF g_aqa.aqa02 <= g_apz.apz57 THEN
                  CALL cl_err(g_aqa.aqa02,'aap-176',0)
               END IF
            END IF
 
        AFTER FIELD aqaud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqaud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_aqa.aqauser = s_get_data_owner("aqa_file") #FUN-C10039
           LET g_aqa.aqagrup = s_get_data_group("aqa_file") #FUN-C10039
           LET l_flag='N'
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
           IF l_flag='Y' THEN
              CALL cl_err('','9033',0)
              NEXT FIELD aqa01
           END IF
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aqa01) #查詢單据
                 LET g_t1=s_get_doc_no(g_aqa.aqa01)      #No.FUN-560002
                 CALL q_apy(FALSE,FALSE,g_t1,g_aptype,'AAP') RETURNING g_t1  #TQC-670008
                 LET g_aqa.aqa01 = g_t1
                 DISPLAY BY NAME g_aqa.aqa01
                 NEXT FIELD aqa01
            END CASE
 
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
 
FUNCTION t900_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_aqa.* TO NULL             #No.FUN-6A0016 add
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_aqb.clear()
   CALL g_aqc.clear()
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t900_cs()
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t900_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_aqa.* TO NULL
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
   p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690028 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     t900_cs INTO g_aqa.aqa01
      WHEN 'P' FETCH PREVIOUS t900_cs INTO g_aqa.aqa01
      WHEN 'F' FETCH FIRST    t900_cs INTO g_aqa.aqa01
      WHEN 'L' FETCH LAST     t900_cs INTO g_aqa.aqa01
      WHEN '/'
         IF NOT mi_no_ask THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0
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
            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
         END IF
         FETCH ABSOLUTE g_jump t900_cs INTO g_aqa.aqa01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      INITIALIZE g_aqa.* TO NULL  #TQC-6B0105
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
   SELECT * INTO g_aqa.* FROM aqa_file WHERE aqa01 = g_aqa.aqa01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","aqa_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660122
      INITIALIZE g_aqa.* TO NULL
      RETURN
   ELSE
      LET g_data_owner = g_aqa.aqauser     #No.FUN-4C0047
      LET g_data_group = g_aqa.aqagrup     #No.FUN-4C0047
      CALL t900_show()
   END IF
END FUNCTION
 
FUNCTION t900_show()
   LET g_aqa_t.* = g_aqa.*                #保存單頭舊值
   DISPLAY BY NAME g_aqa.aqa01,g_aqa.aqa02,g_aqa.aqa03,g_aqa.aqa04,g_aqa.aqa05, g_aqa.aqaoriu,g_aqa.aqaorig,
                   g_aqa.aqaconf,g_aqa.aqainpd,g_aqa.aqauser, #No.8009
                   g_aqa.aqagrup,g_aqa.aqamodu,g_aqa.aqadate,g_aqa.aqaacti,
           g_aqa.aqaud01,g_aqa.aqaud02,g_aqa.aqaud03,g_aqa.aqaud04,
           g_aqa.aqaud05,g_aqa.aqaud06,g_aqa.aqaud07,g_aqa.aqaud08,
           g_aqa.aqaud09,g_aqa.aqaud10,g_aqa.aqaud11,g_aqa.aqaud12,
           g_aqa.aqaud13,g_aqa.aqaud14,g_aqa.aqaud15 
   CALL t900_b_fill(g_wc2)                 #單身
  #CALL t900_b2_fill(' 1=1')               #單身   #CHI-B20013 mark
   CALL t900_b2_fill(g_wc3)                #單身   #CHI-B20013
   #CHI-A50028 add --start--
   IF g_aqa.aqaconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   #CHI-A50028 add --end--
  #CALL cl_set_field_pic(g_aqa.aqaconf,"","","","",g_aqa.aqaacti)  #CHI-A50028 mark
   CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti)  #CHI-A50028
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t900_r()
   IF s_aapshut(0) THEN RETURN END IF
   IF g_aqa.aqa01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqa04 = 'Y' THEN CALL cl_err('','mfg-060',1) RETURN END IF  #No.8009
   IF g_aqa.aqaconf = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF#No.8009
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
   LET g_success = 'Y'
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t900_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_aqa.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
   CALL t900_show()
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "aqa01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_aqa.aqa01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
      DELETE FROM aqb_file WHERE aqb01 = g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","aqb_file",g_aqa.aqa01,"",STATUS,"","del aqb:",1)  #No.FUN-660122
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM aqc_file WHERE aqc01 = g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","aqc_file",g_aqa.aqa01,"",STATUS,"","del aqc:",1)  #No.FUN-660122
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM aqa_file WHERE aqa01 = g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","aqa_file",g_aqa.aqa01,"",STATUS,"","del aqa:",1)  #No.FUN-660122
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM npp_file WHERE npp01=g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","npp_file",g_aqa.aqa01,"",STATUS,"","del npp:",1)  #No.FUN-660122
         ROLLBACK WORK
         RETURN
      END IF
      DELETE FROM npq_file WHERE npq01=g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","apq_file",g_aqa.aqa01,"",STATUS,"","del npq:",1)  #No.FUN-660122
         ROLLBACK WORK
         RETURN
      END IF

      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_aqa.aqa01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_aqa.aqa01,"",STATUS,"","del tic:",1)
         ROLLBACK WORK
         RETURN
      END IF
      #FUN-B40056--add--end--

      INITIALIZE g_aqa.* TO NULL
      CLEAR FORM
      CALL g_aqb.clear()
      CALL g_aqc.clear()
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
   END IF
   CLOSE t900_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_aqa.aqa01,'D')
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

#CHI-A50028 add --start--
#FUNCTION t900_x()                             #FUN-D20035
FUNCTION t900_x(p_type)                        #FUN-D20035
   DEFINE l_year,l_month  LIKE type_file.num5,
          l_flag          LIKE type_file.chr1,
          #--#MOD-C30706--add--str--
          l_aqb02         LIKE aqb_file.aqb02,
          l_aqb03         LIKE aqb_file.aqb03,
          l_aqb04         LIKE aqb_file.aqb04,
          l_apa31         LIKE apa_file.apa31,
          l_apa00         LIKE apa_file.apa00,
          l_aqb04_1       LIKE aqb_file.aqb04,
          l_tot_aqb04     LIKE aqb_file.aqb04,
          l_aqc02         LIKE aqc_file.aqc02,
          l_aqc03         LIKE aqc_file.aqc03,
          l_sql           STRING 
          #--#MOD-C30706--add--end--        
   DEFINE p_type     LIKE type_file.chr1               #FUN-D20035
   DEFINE l_flag1    LIKE type_file.chr1               #FUN-D20035

   IF s_aapshut(0) THEN
      RETURN 
   END IF
   IF cl_null(g_aqa.aqa01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   #--MOD--C30706--add--str--
   IF g_aqa.aqaconf='X' THEN 
      LET l_sql = " SELECT aqb02,aqb04 FROM aqb_file",
                  "  WHERE aqb01 = '",g_aqa.aqa01,"'"
      PREPARE t900_pre FROM l_sql
      DECLARE t900_curs CURSOR FOR t900_pre
      FOREACH t900_curs INTO l_aqb02,l_aqb04_1
         LET l_apa31 = 0
         LET l_aqb04 = 0
         SELECT apa31,apa00 INTO l_apa31,l_apa00 FROM apa_file
          WHERE apa01 = l_aqb02
          IF l_apa00 = '23' THEN          
             IF g_apz.apz27 = 'N' THEN
                SELECT apa34-apa35 INTO l_apa31
                  FROM apa_file
                 WHERE apa01 = l_aqb02
             ELSE
                SELECT apa73 INTO l_apa31
                  FROM apa_file
                 WHERE apa01 = l_aqb02
             END IF
          END IF 
          IF l_apa00 <> '23' THEN     
             SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      
              WHERE aqb02 = l_aqb02
                AND aqa01 = aqb01 AND aqaconf <> 'X'                  
          ELSE
             SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      
              WHERE aqb02 = l_aqb02
                AND aqa01 = aqb01 AND aqaconf = 'N' 
          END IF  
          IF cl_null(l_apa31) THEN LET l_apa31 = 0 END IF
          IF cl_null(l_aqb04) THEN LET l_aqb04 = 0 END IF 

          IF l_aqb04_1 + l_aqb04 > l_apa31 THEN
             CALL cl_err(l_aqb02,'aap-801',1)
             RETURN 
          END IF

          IF g_aqa.aqa03 IS NULL THEN
             LET g_aqa.aqa03=0
          END IF

          CALL t900_aqb04()

          SELECT SUM(aqb04) INTO l_tot_aqb04 FROM aqa_file,aqb_file    #此帳款的總分攤額   
           WHERE aqb02 = l_aqb02
             AND aqb01 <> g_aqa.aqa01
             AND aqa01 = aqb01 AND aqaconf <> 'X'   
          IF cl_null(l_tot_aqb04) THEN
             LET l_tot_aqb04=0
          END IF
          LET l_tot_aqb04 = l_tot_aqb04 + l_aqb04_1
          IF l_tot_aqb04 > l_aqb03 THEN
             CALL cl_err('','mfg-038',0)
             RETURN 
          END IF
      END FOREACH 

      LET l_sql = " SELECT aqc02,aqc03 FROM aqc_file",
                  "  WHERE aqc01 = '",g_aqa.aqa01,"'"
      PREPARE t900_pre_1 FROM l_sql
      DECLARE t900_curs_1 CURSOR FOR t900_pre_1

      FOREACH t900_curs_1 INTO l_aqc02,l_aqc03
         SELECT COUNT(*) INTO g_cnt FROM aqa_file ,aqc_file
          WHERE aqa01 = aqc01
            AND aqc02 = l_aqc02
            AND aqc03 = l_aqc03
            AND aqaconf <> 'X'             
         IF g_cnt>0 THEN
            CALL cl_err(l_aqc02,'aap-035',1) 
            RETURN 
         END IF 
      END FOREACH 
   END IF 
   #--MOD--C30706--add--end--
   
   SELECT * INTO g_aqa.* FROM aqa_file WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqaconf='Y' THEN
      CALL cl_err(g_aqa.aqa01,'anm-105',2)
      RETURN
   END IF
   SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
   IF NOT cl_null(g_aqa.aqa05) THEN
      IF NOT (g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y') THEN
         CALL cl_err(g_aqa.aqa01,'aap-618',0) 
         RETURN
      END IF
   END IF

   #FUN-D20035---begin
   IF p_type = 1 THEN
      IF g_aqa.aqaconf='X' THEN RETURN END IF
   ELSE
      IF g_aqa.aqaconf<>'X' THEN RETURN END IF
   END IF
   #FUN-D20035---end

   LET g_success = 'Y'
   BEGIN WORK
   OPEN t900_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_aqa_o.* = g_aqa.*
   LET g_aqa_t.* = g_aqa.*
   CALL t900_show()
  #IF cl_void(0,0,g_aqa.aqaconf) THEN                                   #FUN-D20035
   IF p_type = 1 THEN LET l_flag1 = 'N' ELSE LET l_flag1 = 'X' END IF   #FUN-D20035
   IF cl_void(0,0,l_flag1) THEN                                         #FUN-D20035  
     #IF g_aqa.aqaconf='N' THEN    #切換為作廢                          #FUN-D20035
      #作废操作时
      IF p_type = 1 THEN                                                #FUN-D20035
         DELETE FROM npp_file
          WHERE nppsys= 'AP'
            AND npp00=4
            AND npp01 = g_aqa.aqa01
            AND npp011=1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npp_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","(t900_r:delete npp)",1)
            LET g_success='N'
         END IF
         DELETE FROM npq_file
          WHERE npqsys= 'AP'
            AND npq00=4
            AND npq01 = g_aqa.aqa01
            AND npq011=1
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","npq_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","(t900_r:delete npq)",1)
            LET g_success='N'
         END IF

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = g_aqa.aqa01
         IF SQLCA.sqlcode THEN
            CALL cl_err3("del","tic_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","(t900_r:delete tic)",1)
            LET g_success='N'
         END IF
         #FUN-B40056--add--end--

         LET g_aqa.aqaconf='X'
      ELSE                         #取消作廢
         LET g_aqa.aqaconf='N'
      END IF
      UPDATE aqa_file SET aqaconf=g_aqa.aqaconf
       WHERE aqa01 = g_aqa.aqa01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",STATUS,"","",1)
         LET g_success='N'
      END IF
   END IF
   SELECT aqaconf INTO g_aqa.aqaconf FROM aqa_file
    WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME g_aqa.aqaconf
   CLOSE t900_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
      CALL cl_flow_notify(g_aqa.aqa01,'V')
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
END FUNCTION
#CHI-A50028 add --end--
 
FUNCTION t900_g_b1()
   DEFINE l_sql                 LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(600)
   DEFINE body_sw               LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE apa51                 LIKE apa_file.apa51
   DEFINE p05f,p05              LIKE type_file.num20_6 # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_cnt                 LIKE type_file.num10   #MOD-810215
   DEFINE l_apa02               LIKE apa_file.apa02    #MOD-820050
 
   IF g_aqa.aqa01 IS NULL THEN RETURN END IF
 
 
   OPEN WINDOW t900_g_b_w AT 4,24 WITH FORM "aap/42f/aapt900_2"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("aapt900_2")
   CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
   INPUT BY NAME body_sw WITHOUT DEFAULTS
      AFTER FIELD body_sw
         IF NOT cl_null(body_sw) THEN
            IF body_sw NOT MATCHES "[12]" THEN
               NEXT FIELD body_sw
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
      CLOSE WINDOW t900_g_b_w
      RETURN
   END IF
 
   LET g_dbs_new = NULL
   CASE WHEN body_sw = '2'
             CLOSE WINDOW t900_g_b_w
             RETURN
        WHEN body_sw = '1'
 
 
             OPEN WINDOW t900_g_b_w2 AT 10,2 WITH FORM "aap/42f/aapt900_1"
                   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
             CALL cl_ui_locale("aapt900_1")
             CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
             CONSTRUCT BY NAME g_wc ON apa01,apa06,apa02,apb12,apb21
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
             CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
             INPUT BY NAME g_apa.apa51 WITHOUT DEFAULTS
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
             CLOSE WINDOW t900_g_b_w2
             IF INT_FLAG THEN
                LET INT_FLAG = 0
                CLOSE WINDOW t900_g_b_w
                RETURN
             END IF
   END CASE
   CLOSE WINDOW t900_g_b_w
 
 
   LET l_ac = 1
   LET g_sql = "SELECT apb01,apb02,apb081,apb09,apb101,apb081,apb101,'N'",
               "  FROM apa_file,apb_file",
               " WHERE ",g_wc CLIPPED,
               "   AND apa01 = apb01",
               "   AND apa41 ='Y'",
               "   AND apaacti = 'Y'",   #MOD-820050
               "   AND (apb34 IS NULL OR apb34 = 'N' )",   #No.TQC-7B0083
               "   AND (apa00 = '11' OR (apa00='16' AND apb21 IS NOT NULL)) ",   #MOD-820050
               "   AND apb08=apb081 "   #MOD-820050
 
   #No.8009
   IF NOT cl_null(g_apa.apa51) THEN
       LET g_sql = g_sql CLIPPED, " AND apa51 = '",g_apa.apa51,"'" #MOD-560082
   END IF
   LET g_sql = g_sql CLIPPED, " ORDER BY apb01,apb02"
   #No.8009(end)
   PREPARE t900_g_b_p1 FROM g_sql
   DECLARE t900_g_b_c1 CURSOR WITH HOLD FOR t900_g_b_p1
   FOREACH t900_g_b_c1 INTO g_aqc[l_ac].*
      IF STATUS THEN
         CALL cl_err('for apc',STATUS,1)
         EXIT FOREACH
      END IF
      BEGIN WORK
      LET g_success = 'Y'
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM aqa_file ,aqc_file
       WHERE aqa01=aqc01
         AND aqc02=g_aqc[l_ac].aqc02
         AND aqc03=g_aqc[l_ac].aqc03
         AND aqaconf <> 'X'             #MOD-A80107
      IF l_cnt>0 THEN
         CONTINUE FOREACH
      END IF
     SELECT apa02 INTO l_apa02 FROM apa_file
       WHERE apa01=g_aqc[l_ac].aqc02
    #IF l_apa02 <= g_sma.sma53 THEN                                  #MOD-A40065 mark
     #FUN-B50090 add begin-------------------------
     #重新抓取關帳日期
     SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
     #FUN-B50090 add -end--------------------------
     IF (l_apa02 <= g_sma.sma53) OR (l_apa02 > g_aqa.aqa02) THEN    #MOD-A40065 add
        CONTINUE FOREACH
     END IF
      INSERT INTO aqc_file(aqc01,aqc02,aqc03,aqc04,aqc05,aqc06,aqc07,aqc08,
                                  aqcud01,aqcud02,aqcud03,
                                  aqcud04,aqcud05,aqcud06,
                                  aqcud07,aqcud08,aqcud09,
                                  aqcud10,aqcud11,aqcud12,
                                  aqcud13,aqcud14,aqcud15,aqclegal) #FUN-980001 add legal
       VALUES(g_aqa.aqa01,g_aqc[l_ac].aqc02,g_aqc[l_ac].aqc03,g_aqc[l_ac].aqc04,
              g_aqc[l_ac].aqc05,g_aqc[l_ac].aqc06,g_aqc[l_ac].aqc07,g_aqc[l_ac].aqc08,
                                  g_aqc[l_ac].aqcud01,
                                  g_aqc[l_ac].aqcud02,
                                  g_aqc[l_ac].aqcud03,
                                  g_aqc[l_ac].aqcud04,
                                  g_aqc[l_ac].aqcud05,
                                  g_aqc[l_ac].aqcud06,
                                  g_aqc[l_ac].aqcud07,
                                  g_aqc[l_ac].aqcud08,
                                  g_aqc[l_ac].aqcud09,
                                  g_aqc[l_ac].aqcud10,
                                  g_aqc[l_ac].aqcud11,
                                  g_aqc[l_ac].aqcud12,
                                  g_aqc[l_ac].aqcud13,
                                  g_aqc[l_ac].aqcud14,
                                  g_aqc[l_ac].aqcud15,g_legal) #FUN-980001 add legal
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","aqc_file",g_aqa.aqa01,g_aqc[l_ac].aqc02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
         ROLLBACK WORK
         CONTINUE FOREACH
      END IF
      LET l_ac = l_ac + 1
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
      IF l_ac > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION t900_b()     #雜項
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690028 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690028 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690028 VARCHAR(1)
    l_apa41         LIKE apa_file.apa41,
    l_tot_aqb04     LIKE aqb_file.aqb04,  #FUN-4B0079
    l_tot_aqa03     LIKE aqa_file.aqa03,
    l_apa31         LIKE apa_file.apa31,   #MOD-590316
    l_aqb04         LIKE aqb_file.aqb04,   #MOD-590316
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690028 SMALLINT
DEFINE l_apa00      LIKE apa_file.apa00   #TQC-6B0087
 
    LET g_action_choice = ""
    IF s_aapshut(0) THEN
       RETURN
    END IF
    IF g_aqa.aqa01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_aqa.* FROM aqa_file
     WHERE aqa01=g_aqa.aqa01
    #No.8009
    IF g_aqa.aqa04 = 'Y' THEN CALL cl_err('','mfg-060',1) RETURN END IF
    IF g_aqa.aqaconf = 'Y' THEN CALL cl_err('','aap-086',1) RETURN END IF
    #No.8009(end)
    IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
    IF g_aqa.aqaacti ='N' THEN
       CALL cl_err(g_aqa.aqa01,'9027',0)
       RETURN
    END IF
 
    SELECT COUNT(*) INTO g_rec_b FROM aqb_file WHERE aqb01=g_aqa.aqa01
    IF g_rec_b = 0 THEN
       CALL t900_b_fill(' 1=1')
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT aqb02,'','','','','',aqb03,aqb04,",
                       "       aqbud01,aqbud02,aqbud03,aqbud04,aqbud05,",
                       "       aqbud06,aqbud07,aqbud08,aqbud09,aqbud10,",
                       "       aqbud11,aqbud12,aqbud13,aqbud14,aqbud15", 
                       " FROM aqb_file", #FUN-680029
                       " WHERE aqb01=? AND aqb02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_b2cl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_aqa.aqamodu=g_user
    LET g_aqa.aqadate=g_today
    DISPLAY BY NAME g_aqa.aqamodu,g_aqa.aqadate
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_aqb WITHOUT DEFAULTS FROM s_aqb.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
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
           LET g_success = 'Y'
           OPEN t900_cl USING g_aqa.aqa01
           IF STATUS THEN
              CALL cl_err("OPEN t900_cl:", STATUS, 1)
              CLOSE t900_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t900_cl INTO g_aqa.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
              CLOSE t900_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_aqb_t.* = g_aqb[l_ac].*  #BACKUP
              OPEN t900_b2cl USING g_aqa.aqa01,g_aqb_t.aqb02
              IF STATUS THEN
                 CALL cl_err("OPEN t900_b2cl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t900_b2cl INTO g_aqb[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aqb_t.aqb02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              LET g_aqb[l_ac].apa02 = g_aqb_t.apa02
              CALL t900_aqb02('d',l_ac)
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_aqb[l_ac].* TO NULL      #900423
           LET g_aqb_t.* = g_aqb[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD aqb02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO aqb_file(aqb01,aqb02,aqb03,aqb04,
                                  aqbud01,aqbud02,aqbud03,
                                  aqbud04,aqbud05,aqbud06,
                                  aqbud07,aqbud08,aqbud09,
                                  aqbud10,aqbud11,aqbud12,
                                  aqbud13,aqbud14,aqbud15,aqblegal) #FUN-980001 add
             VALUES(g_aqa.aqa01,g_aqb[l_ac].aqb02,g_aqb[l_ac].aqb03,
                    g_aqb[l_ac].aqb04,
                                  g_aqb[l_ac].aqbud01,
                                  g_aqb[l_ac].aqbud02,
                                  g_aqb[l_ac].aqbud03,
                                  g_aqb[l_ac].aqbud04,
                                  g_aqb[l_ac].aqbud05,
                                  g_aqb[l_ac].aqbud06,
                                  g_aqb[l_ac].aqbud07,
                                  g_aqb[l_ac].aqbud08,
                                  g_aqb[l_ac].aqbud09,
                                  g_aqb[l_ac].aqbud10,
                                  g_aqb[l_ac].aqbud11,
                                  g_aqb[l_ac].aqbud12,
                                  g_aqb[l_ac].aqbud13,
                                  g_aqb[l_ac].aqbud14,
                                  g_aqb[l_ac].aqbud15,g_legal) #FUN-980001 add legal
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","aqb_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
              CANCEL INSERT
              ROLLBACK WORK
           END IF
           SELECT SUM(aqb04) INTO g_aqa.aqa03 FROM aqb_file
            WHERE aqb01=g_aqa.aqa01
 
           UPDATE aqa_file SET aqa03=g_aqa.aqa03
            WHERE aqa01=g_aqa.aqa01
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN    #TQC-6B0087
              CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
              CANCEL INSERT
              ROLLBACK WORK
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
           DISPLAY BY NAME g_aqa.aqa03
 
        AFTER FIELD aqb02
           IF NOT cl_null(g_aqb[l_ac].aqb02) THEN
              LET l_apa31=0
              LET l_aqb04=0
              SELECT apa31,apa00 INTO l_apa31,l_apa00 FROM apa_file
                 WHERE apa01=g_aqb[l_ac].aqb02
             #IF l_apa00 = '22' THEN         #MOD-B60040 mark
             #   LET l_apa31 = l_apa31 * -1  #MOD-B60040 mark
             #END IF                         #MOD-B60040 mark
             #SELECT SUM(aqb04) INTO l_aqb04 FROM aqb_file               #MOD-A80107 mark
              SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      #MOD-A80107
                 WHERE aqb02=g_aqb[l_ac].aqb02
                   AND aqa01 = aqb01 AND aqaconf <> 'X'                  #MOD-A80107 
              IF cl_null(l_apa31) THEN LET l_apa31 = 0 END IF
              IF cl_null(l_aqb04) THEN LET l_aqb04 = 0 END IF
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt FROM aqa_file,aqb_file
                WHERE aqa01=aqb01 AND aqa01=g_aqa.aqa01 AND
                      aqb02=g_aqb[l_ac].aqb02
                  AND aqaconf <> 'X'                                     #MOD-A80107
              IF g_aqb_t.aqb02 <> g_aqb[l_ac].aqb02 OR
                    cl_null(g_aqb_t.aqb02) THEN
                 IF g_cnt > 0 THEN
                    CALL cl_err('','-239',0)
                    LET g_aqb[l_ac].aqb02 = g_aqb_t.aqb02
                    DISPLAY BY NAME g_aqb[l_ac].aqb02
                    NEXT FIELD aqb02
                 END IF
                 IF l_apa31=l_aqb04 THEN
                    CALL cl_err('','aap-801',0)
                    LET g_aqb[l_ac].aqb02 = g_aqb_t.aqb02
                    DISPLAY BY NAME g_aqb[l_ac].aqb02
                    NEXT FIELD aqb02
                 END IF
              END IF
              SELECT apa41 INTO l_apa41 FROM apa_file
               WHERE apa01=g_aqb[l_ac].aqb02
              IF l_apa41='N' THEN
                 CALL cl_err('','mfg-043',0)
                 NEXT FIELD aqb02
              END IF
             #檢查來源帳款若有已作廢單號或外購，不可做分攤的動作
             SELECT COUNT(*) INTO g_cnt
               FROM apa_file
              WHERE apa01 = g_aqb[l_ac].aqb02
                AND (apa42 = 'Y' OR apa75 = 'Y')   
             IF g_cnt > 0 THEN
                CALL cl_err('','aap-329',0)
                NEXT FIELD aqb02
             END IF
             LET g_cnt = 0 
             SELECT COUNT(*) INTO g_cnt
               FROM apa_file
              WHERE apa01 = g_aqb[l_ac].aqb02
                AND apa51 = 'UNAP'
             IF g_cnt > 0 THEN
                CALL cl_err('','aap-081',0)
                NEXT FIELD aqb02
             END IF
            #-MOD-A80248-add-
             LET g_cnt = 0 
             IF g_apz.apz27 = 'N' THEN
                SELECT COUNT(*) INTO g_cnt 
                  FROM apa_file
                 WHERE apa01 = g_aqb[l_ac].aqb02
                   AND (apa34-apa35) = 0 
                   AND apa42 = 'N'
                   AND apa00 = '23'        #MOD-AC0264
             ELSE
                SELECT COUNT(*) INTO g_cnt 
                  FROM apa_file
                 WHERE apa01 = g_aqb[l_ac].aqb02
                   AND apa73 = 0 
                   AND apa42 = 'N'
                   AND apa00 = '23'        #MOD-AC0264
             END IF
             IF g_cnt > 0 THEN
                CALL cl_err('','aco-228',0)
                NEXT FIELD aqb02
             END IF
            #-MOD-A80248-end-
              CALL t900_aqb02('a',l_ac)
              IF g_success="N" THEN
                 CALL cl_err(g_aqb[l_ac].aqb02,g_errno,0)
                 NEXT FIELD aqb02
              END IF
              IF g_aqb[l_ac].aqb02 != g_aqb_t.aqb02 OR    #MOD-7B0222
                 g_aqb_t.aqb02 IS NULL THEN   #MOD-7B0222
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_aqb[l_ac].aqb02=g_aqb_t.aqb02
                     NEXT FIELD aqb02
                 END IF
              END IF
              LET g_aqb[l_ac].aqb03 = cl_digcut(g_aqb[l_ac].aqb03,g_azi04)  #No.CHI-6A0004
           END IF
 
        AFTER FIELD aqb04
          #-MOD-B60040-mark-
          #SELECT apa00 INTO l_apa00 FROM apa_file
          #   WHERE apa01=g_aqb[l_ac].aqb02
          #IF l_apa00 = '22' THEN
          #   IF cl_null(g_aqb[l_ac].aqb04) OR g_aqb[l_ac].aqb04>=0 THEN
          #      NEXT FIELD aqb04
          #   END IF
          #ELSE
          #-MOD-B60040-end-
              IF cl_null(g_aqb[l_ac].aqb04) OR g_aqb[l_ac].aqb04<=0 THEN
                 NEXT FIELD aqb04
              END IF
          #END IF   #MOD-B60040 mark
           LET l_apa31=0
           LET l_aqb04=0
           SELECT apa31,apa00 INTO l_apa31,l_apa00 FROM apa_file
              WHERE apa01=g_aqb[l_ac].aqb02
          #IF l_apa00 = '22' THEN         #MOD-B60040 mark
          #   LET l_apa31 = l_apa31 * -1  #MOD-B60040 mark
          #END IF                         #MOD-B60040 mark
          #-MOD-A80248-add-
           IF l_apa00 = '23' THEN           #MOD-AC0264
              IF g_apz.apz27 = 'N' THEN
                 SELECT apa34-apa35 INTO l_apa31
                   FROM apa_file
                  WHERE apa01=g_aqb[l_ac].aqb02
              ELSE
                 SELECT apa73 INTO l_apa31
                   FROM apa_file
                  WHERE apa01=g_aqb[l_ac].aqb02
              END IF
           END IF                           #MOD-AC0264
          #-MOD-A80248-add-
          #SELECT SUM(aqb04) INTO l_aqb04 FROM aqb_file               #MOD-A80107 mark
           IF l_apa00 <> '23' THEN     #MOD-B30052
              SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      #MOD-A80107
                 WHERE aqb02=g_aqb[l_ac].aqb02
                   AND aqa01 = aqb01 AND aqaconf <> 'X'                  #MOD-A80107 
          #-MOD-B30052-add-
           ELSE
              SELECT SUM(aqb04) INTO l_aqb04 FROM aqa_file,aqb_file      
                 WHERE aqb02=g_aqb[l_ac].aqb02
                   AND aqa01 = aqb01 AND aqaconf = 'N' 
           END IF 
          #-MOD-B30052-end-
           IF cl_null(l_apa31) THEN LET l_apa31 = 0 END IF
           IF cl_null(l_aqb04) THEN LET l_aqb04 = 0 END IF
           IF p_cmd = 'a' THEN
             #-MOD-B60040-mark-
             #IF l_apa00 = '22' THEN
             #   IF g_aqb[l_ac].aqb04+l_aqb04 < l_apa31 THEN
             #      CALL cl_err('','aap-801',0)
             #      NEXT FIELD aqb04
             #   END IF
             #ELSE
             #-MOD-B60040-end-
                 IF g_aqb[l_ac].aqb04+l_aqb04 > l_apa31 THEN
                    CALL cl_err('','aap-801',0)
                    NEXT FIELD aqb04
                 END IF
             #END IF   #TQC-6B0087 #MOD-B60040 mark
           ELSE
             #-MOD-B60040-mark-
             #IF l_apa00 = '22' THEN
             #   IF g_aqb[l_ac].aqb04-g_aqb_t.aqb04+l_aqb04 < l_apa31 THEN
             #      CALL cl_err('','aap-801',0)
             #      LET g_aqb[l_ac].aqb04 = g_aqb_t.aqb04
             #      DISPLAY BY NAME g_aqb[l_ac].aqb04
             #      NEXT FIELD aqb04
             #   END IF
             #ELSE
             #-MOD-B60040-end-
                 IF g_aqb[l_ac].aqb04-g_aqb_t.aqb04+l_aqb04 > l_apa31 THEN
                    CALL cl_err('','aap-801',0)
                    LET g_aqb[l_ac].aqb04 = g_aqb_t.aqb04
                    DISPLAY BY NAME g_aqb[l_ac].aqb04
                    NEXT FIELD aqb04
                 END IF
             #END IF   #TQC-6B0087 #MOD-B60040 mark
           END IF
           IF g_aqa.aqa03 IS NULL THEN
              LET g_aqa.aqa03=0
           END IF
           CALL t900_aqb04()
          #SELECT SUM(aqb04) INTO l_tot_aqb04 FROM aqb_file    #此帳款的總分攤額            #MOD-A80107 mark
           SELECT SUM(aqb04) INTO l_tot_aqb04 FROM aqa_file,aqb_file    #此帳款的總分攤額   #MOD-A80107
            WHERE aqb02=g_aqb[l_ac].aqb02
              AND aqb01 <> g_aqa.aqa01
              AND aqa01 = aqb01 AND aqaconf <> 'X'                                          #MOD-A80107 
           IF cl_null(l_tot_aqb04) THEN
              LET l_tot_aqb04=0
           END IF
           LET l_tot_aqb04=l_tot_aqb04+g_aqb[l_ac].aqb04
          #-MOD-B60040-mark-
          #IF l_apa00 = '22' THEN
          #   IF l_tot_aqb04<g_aqb[l_ac].aqb03 THEN
          #      CALL cl_err('','mfg-038',0)
          #      NEXT FIELD aqb04
          #   END IF
          #ELSE
          #-MOD-B60040-end-
              IF l_tot_aqb04>g_aqb[l_ac].aqb03 THEN
                 CALL cl_err('','mfg-038',0)
                 NEXT FIELD aqb04
              END IF
          #END IF   #TQC-6B0087 #MOD-B60040 mark
 
        AFTER FIELD aqbud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqbud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_aqb_t.aqb02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM aqb_file
               WHERE aqb01 = g_aqa.aqa01
                 AND aqb02 = g_aqb_t.aqb02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","aqb_file",g_aqa.aqa01,g_aqb_t.aqb02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              SELECT SUM(aqb04) INTO g_aqa.aqa03 FROM aqb_file
               WHERE aqb01=g_aqa.aqa01
              UPDATE aqa_file SET aqa03=g_aqa.aqa03 WHERE aqa01=g_aqa.aqa01
              IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                 CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              DISPLAY BY NAME g_aqa.aqa03
              CALL t900_aqb04()
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_aqb[l_ac].* = g_aqb_t.*
               CLOSE t900_b2cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_aqb[l_ac].aqb02,-263,1)
               LET g_aqb[l_ac].* = g_aqb_t.*
            ELSE
               UPDATE aqb_file SET aqb02 = g_aqb[l_ac].aqb02,
                                   aqb03 = g_aqb[l_ac].aqb03,
                                   aqb04 = g_aqb[l_ac].aqb04,
                                aqbud01 = g_aqb[l_ac].aqbud01,
                                aqbud02 = g_aqb[l_ac].aqbud02,
                                aqbud03 = g_aqb[l_ac].aqbud03,
                                aqbud04 = g_aqb[l_ac].aqbud04,
                                aqbud05 = g_aqb[l_ac].aqbud05,
                                aqbud06 = g_aqb[l_ac].aqbud06,
                                aqbud07 = g_aqb[l_ac].aqbud07,
                                aqbud08 = g_aqb[l_ac].aqbud08,
                                aqbud09 = g_aqb[l_ac].aqbud09,
                                aqbud10 = g_aqb[l_ac].aqbud10,
                                aqbud11 = g_aqb[l_ac].aqbud11,
                                aqbud12 = g_aqb[l_ac].aqbud12,
                                aqbud13 = g_aqb[l_ac].aqbud13,
                                aqbud14 = g_aqb[l_ac].aqbud14,
                                aqbud15 = g_aqb[l_ac].aqbud15
                WHERE aqb01=g_aqa.aqa01 AND aqb02=g_aqb_t.aqb02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","aqb_file",g_aqb[l_ac].aqb02,"",SQLCA.sqlcode,"","",1)
                  LET g_aqb[l_ac].* = g_aqb_t.*
                  ROLLBACK WORK
               END IF
               SELECT SUM(aqb04) INTO g_aqa.aqa03 FROM aqb_file
                WHERE aqb01=g_aqa.aqa01
               UPDATE aqa_file SET aqa03=g_aqa.aqa03
                WHERE aqa01=g_aqa.aqa01
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","aqb_file",g_aqa.aqa01,g_aqb_t.aqb02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                  LET g_aqb[l_ac].* = g_aqb_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  IF g_success='Y' THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
               DISPLAY BY NAME g_aqa.aqa03
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032 
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aqb[l_ac].* = g_aqb_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_aqb.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "source_detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE t900_b2cl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032 
            CLOSE t900_b2cl
            COMMIT WORK
            CALL t900_aqb04()
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aqb02)
               # CALL q_apa6(FALSE,TRUE) RETURNING g_aqb[l_ac].aqb02   #MOD-750025   #FUN-C70093
                 CALL q_apa6(FALSE,TRUE,'aapt900','','','') RETURNING g_aqb[l_ac].aqb02   #FUN-C70093
                 DISPLAY g_aqb[l_ac].aqb02 TO aqb02   #MOD-750025
              OTHERWISE
                 EXIT CASE
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
    
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
    END INPUT
    UPDATE aqa_file SET aqamodu = g_aqa.aqamodu,
                        aqadate = g_aqa.aqadate
     WHERE aqa01=g_aqa.aqa01
   IF SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
      LET g_success = 'N'
   END IF
    CLOSE t900_b2cl
    CALL t900_v('')   #TQC-6B0087
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t900_aqb02(p_cmd,l_cnt)
   DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_amtf,l_amt    LIKE type_file.num20_6 # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_cnt  LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_apa00       LIKE apa_file.apa00
   DEFINE l_apa42       LIKE apa_file.apa42
   DEFINE l_apa75       LIKE apa_file.apa75
   DEFINE l_cnt2 LIKE type_file.num5   #MOD-820050
   DEFINE l_apaacti     LIKE apa_file.apaacti   #MOD-820050
   DEFINE l_apa41       LIKE apa_file.apa41     #MOD-820050
 
   LET g_errno = ' '
   LET g_success = 'Y'
   CALL s_get_bookno(YEAR(g_aqb[l_cnt].apa02))  RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN #抓不到帳別
        CALL cl_err(g_aqb[l_cnt].apa02,'aoo-081',1)
   END IF
   LET g_sql = "SELECT apa00,apa01,apa02,apa51,apa511,apa06,apa07,apa31,apa42,apa75,apaacti,apa41", #FUN-680029   #MOD-820050
               "  FROM apa_file WHERE apa01 = ?"
   PREPARE t900_p3 FROM g_sql DECLARE t900_c3 CURSOR FOR t900_p3
   OPEN t900_c3 USING g_aqb[l_cnt].aqb02
 
   FETCH t900_c3 INTO l_apa00,g_aqb[l_cnt].aqb02,g_aqb[l_cnt].apa02,
                      g_aqb[l_cnt].apa51,g_aqb[l_cnt].apa511,g_aqb[l_cnt].apa06, #FUN-680029
                      g_aqb[l_cnt].apa07,g_aqb[l_cnt].aqb03,l_apa42,l_apa75,
                      l_apaacti,l_apa41   #MOD-820050
  #IF l_apa00 = '22' THEN                               #MOD-B60040 mark
  #   LET g_aqb[l_cnt].aqb03 = g_aqb[l_cnt].aqb03 * -1  #MOD-B60040 mark
  #END IF                                               #MOD-B60040 mark
   IF p_cmd = 'd' THEN RETURN END IF
   CASE WHEN SQLCA.SQLCODE = 100  LET g_success="N"
                                  LET g_errno = 'mfg-044'
        WHEN l_apa42 = 'Y'        LET g_errno = '9024'
        WHEN l_apa75 = 'Y'        LET g_errno = 'aap-333' #外購已付款Q
        WHEN (l_apa00 !='12' AND l_apa00 !='22' AND l_apa00 !='23' AND
              l_apa00 !='13' AND l_apa00 !='25' AND l_apa00 !='16')
              LET g_success='N' LET g_errno='aap-325'
        WHEN l_apa00 = '16'
             LET l_cnt2 = 0
             SELECT COUNT(*) INTO l_cnt2 FROM apb_file
                WHERE apb01=g_aqb[l_cnt].aqb02
                  AND apb21 IS NOT NULL
             IF l_cnt2 > 0 THEN
                LET g_success='N' LET g_errno='aap-610'
             END IF
        WHEN l_apaacti='N'
             LET g_errno = 'mfg0301'
        WHEN l_apa41='N'
             LET g_errno = '9029'
 
   END CASE
END FUNCTION
 
FUNCTION t900_aqc03(l_cnt)
   DEFINE p_cmd           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_amtf,l_amt    LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
   DEFINE l_apa41         LIKE apa_file.apa41
   DEFINE l_cnt    LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_apaacti       LIKE apa_file.apaacti   #MOD-820050
 
   LET g_errno = ' '
   LET g_success = 'Y'
   LET g_sql = "SELECT apb01,apb02,apb081,apb09,apb101,apb081,apb101,apa41,apaacti",   #MOD-820050
               "  FROM apb_file,apa_file",
               "  WHERE apa01 =?",
               "    AND apa01 = apb01 ",
               "    AND (apb34 IS NULL OR apb34 = 'N') ",   #No.TQC-7B0083
               "    AND apb02 =?",
               "    AND (apa00 = '11' OR (apa00='16' AND apb21 IS NOT NULL)) ",   #MOD-820050
               "    AND apb08=apb081"   #MOD-820050
   PREPARE t900_p4 FROM g_sql
   DECLARE t900_c4 CURSOR FOR t900_p4
 
   OPEN t900_c4 USING g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03
   FETCH t900_c4 INTO g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03,g_aqc[l_cnt].aqc04,
                      g_aqc[l_cnt].aqc05,g_aqc[l_cnt].aqc06,g_aqc[l_cnt].aqc07,
                      g_aqc[l_cnt].aqc08,
                      l_apa41,l_apaacti   #MOD-820050
   DISPLAY BY NAME g_aqc[l_cnt].aqc02,g_aqc[l_cnt].aqc03,g_aqc[l_cnt].aqc04,
                   g_aqc[l_cnt].aqc05,g_aqc[l_cnt].aqc06,g_aqc[l_cnt].aqc07,
                   g_aqc[l_cnt].aqc08
   IF p_cmd = 'd' THEN RETURN END IF
   CASE WHEN SQLCA.SQLCODE = 100   LET g_errno = 'mfg-044'
        WHEN l_apa41 = 'N'         LET g_errno = '9029' #no.7008
        WHEN l_apaacti='N'         LET g_errno = 'mfg0301'   #MOD-820050
   END CASE
END FUNCTION
 
FUNCTION t900_b2()     #帳款
DEFINE
    p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-690028 VARCHAR(1)
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-690028 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-690028 SMALLINT
    l_cnt           LIKE type_file.num5,    #No.FUN-690028 SMALLINT
    l_aqc03         LIKE aqc_file.aqc03,
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-690028 VARCHAR(1)
    l_aptype        LIKE type_file.chr2,        # No.FUN-690028 VARCHAR(2)               #
    l_type          LIKE type_file.chr2,        # No.FUN-690028 VARCHAR(2)               #
    l_t1            LIKE apy_file.apyslip,      # No.FUN-690028 VARCHAR(05)                 #No.FUN-550030
    l_apb10         LIKE apb_file.apb10,
    l_apb101        LIKE apb_file.apb101,
    l_apydmy3       LIKE apy_file.apydmy3  ,
    l_aqc07         LIKE aqc_file.aqc07,
    l_aqc08         LIKE aqc_file.aqc08,
    l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-690028 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-690028 SMALLINT
DEFINE l_apa02      LIKE apa_file.apa02   #MOD-730048
 
    LET g_action_choice = ""  #FUN-D30032 add
    IF s_aapshut(0) THEN
       RETURN
    END IF
    IF g_aqa.aqa01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_aqa.* FROM aqa_file
     WHERE aqa01=g_aqa.aqa01
    #No.8009
    IF g_aqa.aqaconf = 'Y' THEN CALL cl_err('','aap-086',0) RETURN END IF
    IF g_aqa.aqa04 = 'Y' THEN CALL cl_err('','mfg-060',0) RETURN END IF
    #No.8009(end)
    IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
    IF g_aqa.aqaacti ='N' THEN
       CALL cl_err(g_aqa.aqa01,'9027',0)
       RETURN
    END IF
    SELECT COUNT(*) INTO g_rec_b FROM aqc_file WHERE aqc01=g_aqa.aqa01
    IF g_rec_b = 0 THEN
       CALL t900_g_b1()
       CALL t900_b2_fill(' 1=1')
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT aqc02,aqc03,aqc04,aqc05,aqc06,aqc07,aqc08,",
                       "       aqcud01,aqcud02,aqcud03,aqcud04,aqcud05,",
                       "       aqcud06,aqcud07,aqcud08,aqcud09,aqcud10,",
                       "       aqcud11,aqcud12,aqcud13,aqcud14,aqcud15", 
                       "  FROM aqc_file ",
                       " WHERE aqc01=? AND aqc02=? AND aqc03=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t900_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_aqa.aqamodu=g_user
    LET g_aqa.aqadate=g_today
    DISPLAY BY NAME g_aqa.aqamodu,g_aqa.aqadate
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_aqc WITHOUT DEFAULTS FROM s_aqc.*
          ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b2 != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           LET g_success = 'Y'
           OPEN t900_cl USING g_aqa.aqa01
           IF STATUS THEN
              CALL cl_err("OPEN t900_cl:", STATUS, 1)
              CLOSE t900_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t900_cl INTO g_aqa.*
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
              CLOSE t900_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b2 >= l_ac THEN
              LET p_cmd='u'
              LET g_aqc_t.* = g_aqc[l_ac].*  #BACKUP
              OPEN t900_bcl USING g_aqa.aqa01,g_aqc_t.aqc02,g_aqc_t.aqc03
              IF STATUS THEN
                 CALL cl_err("OPEN t900_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              END IF
              FETCH t900_bcl INTO g_aqc[l_ac].*
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_aqc_t.aqc02,SQLCA.sqlcode,1)
                 LET l_lock_sw = "Y"
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
           NEXT FIELD aqc02
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_aqc[l_ac].* TO NULL
            LET g_aqc_t.* = g_aqc[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD aqc02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           INSERT INTO aqc_file(aqc01,aqc02,aqc03,aqc04,aqc05,aqc06,aqc07,aqc08,
                                  aqcud01,aqcud02,aqcud03,
                                  aqcud04,aqcud05,aqcud06,
                                  aqcud07,aqcud08,aqcud09,
                                  aqcud10,aqcud11,aqcud12,
                                  aqcud13,aqcud14,aqcud15,aqclegal) #FUN-9A0099
            VALUES(g_aqa.aqa01,g_aqc[l_ac].aqc02,g_aqc[l_ac].aqc03,
                   g_aqc[l_ac].aqc04,g_aqc[l_ac].aqc05,g_aqc[l_ac].aqc06,
                   g_aqc[l_ac].aqc07,g_aqc[l_ac].aqc08,
                                  g_aqc[l_ac].aqcud01,
                                  g_aqc[l_ac].aqcud02,
                                  g_aqc[l_ac].aqcud03,
                                  g_aqc[l_ac].aqcud04,
                                  g_aqc[l_ac].aqcud05,
                                  g_aqc[l_ac].aqcud06,
                                  g_aqc[l_ac].aqcud07,
                                  g_aqc[l_ac].aqcud08,
                                  g_aqc[l_ac].aqcud09,
                                  g_aqc[l_ac].aqcud10,
                                  g_aqc[l_ac].aqcud11,
                                  g_aqc[l_ac].aqcud12,
                                  g_aqc[l_ac].aqcud13,
                                  g_aqc[l_ac].aqcud14,
                                  g_aqc[l_ac].aqcud15,g_legal)  #FUN-9A0099
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","aqc_file",g_aqa.aqa01,g_aqc[l_ac].aqc02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
              CANCEL INSERT
              ROLLBACK WORK
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b2=g_rec_b2+1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
          #No.8009 mark (確認段再判斷)
 
        AFTER FIELD aqc02
           IF NOT cl_null(g_aqc[l_ac].aqc02) THEN #CHI-750011
              IF g_aqc[l_ac].aqc02 != g_aqc_t.aqc02 OR 
                 g_aqc_t.aqc02 IS NULL THEN   #MOD-730048
                #檢查目的帳款若有已作廢單號或外購，不可做分攤的動作
                SELECT COUNT(*) INTO g_cnt
                  FROM apa_file
                 WHERE apa01 = g_aqc[l_ac].aqc02
                   AND (apa42 = 'Y' OR apa75 = 'Y')
                IF g_cnt > 0 THEN
                   CALL cl_err('','aap-330',0)
                   NEXT FIELD aqc02
                END IF
 
                #已完成成本結帳帳款不可再做成本分攤
                SELECT apa02 INTO l_apa02 FROM apa_file
                  WHERE apa01 = g_aqc[l_ac].aqc02
                
                
                #FUN-B50090 add begin-------------------------
                #重新抓取關帳日期
                SELECT sma53 INTO g_sma.sma53 FROM sma_file WHERE sma00='0'
                #FUN-B50090 add -end--------------------------
                IF l_apa02 <= g_sma.sma53 THEN
                   CALL cl_err(g_aqc[l_ac].aqc02,'axc-194',0)   #MOD-7B0222
                   NEXT FIELD aqc02
                END IF
               #MOD-A40065---add---start---
                IF l_apa02 > g_aqa.aqa02 THEN
                   CALL cl_err(g_aqc[l_ac].aqc02,'aap-102',0)
                   NEXT FIELD aqc02
                END IF
               #MOD-A40065---add---end---
                NEXT FIELD aqc03                          #MOD-A80107
              END IF
           END IF
 
        AFTER FIELD aqc03
           IF NOT cl_null(g_aqc[l_ac].aqc03) THEN
              IF g_aqc[l_ac].aqc02 IS NOT NULL THEN
                 IF g_aqc_t.aqc02 IS NULL THEN  # 單身新增
                    LET g_cnt=0
                    SELECT COUNT(*) INTO g_cnt FROM aqa_file ,aqc_file
                     WHERE aqa01=aqc01
                       AND aqc02=g_aqc[l_ac].aqc02
                       AND aqc03=g_aqc[l_ac].aqc03
                       AND aqaconf <> 'X'             #MOD-A80107
                    IF g_cnt>0 THEN
                       CALL cl_err('','aap-035',0) #No.8009
                       NEXT FIELD aqc02
                    END IF
                 END IF
              END IF
              CALL t900_aqc03(l_ac)           #for referenced field
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD aqc02
              END IF
              IF g_aqc[l_ac].aqc02 IS NOT NULL THEN
                 IF g_aqc_t.aqc02 IS NOT NULL AND g_success<>'N' THEN
                    CALL t900_apa51()
                    IF g_success='N' THEN
                       INITIALIZE g_aqc[l_ac].* TO NULL
                       NEXT FIELD aqc02
                    END IF
                 END IF
              END IF
              SELECT apb10,apb101 INTO l_apb10,l_apb101 FROM apb_file
               WHERE apb01=g_aqc[l_ac].aqc02
                 AND apb02=g_aqc[l_ac].aqc03
              LET g_aqc[l_ac].aqc04 = cl_digcut(g_aqc[l_ac].aqc04,g_azi03) #No.CHI-6A0004
              LET g_aqc[l_ac].aqc06 = cl_digcut(g_aqc[l_ac].aqc06,g_azi04) #No.CHI-6A0004
              LET g_aqc[l_ac].aqc07 = cl_digcut(g_aqc[l_ac].aqc07,g_azi03) #No.CHI-6A0004
              LET g_aqc[l_ac].aqc08 = cl_digcut(g_aqc[l_ac].aqc08,g_azi04) #No.CHI-6A0004
           END IF
 
        AFTER FIELD aqcud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD aqcud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        BEFORE DELETE                            #是否取消單身
           IF g_aqc_t.aqc02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM aqc_file
               WHERE aqc01 = g_aqa.aqa01
                 AND aqc02 = g_aqc_t.aqc02
                 AND aqc03 = g_aqc_t.aqc03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","aqc_file",g_aqa.aqa01,g_aqc_t.aqc02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn4
              CALL t900_aqc06_aqc08()   #MOD-820050
              LET g_cnt=0
             #No.8009 mark (確認段再判斷)
              IF g_success='Y' THEN
                 COMMIT WORK
              ELSE
                 ROLLBACK WORK
              END IF
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_aqc[l_ac].* = g_aqc_t.*
              CLOSE t900_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_aqc[l_ac].aqc02,-263,1)
              LET g_aqc[l_ac].* = g_aqc_t.*
           ELSE
              UPDATE aqc_file SET aqc02 = g_aqc[l_ac].aqc02,
                                  aqc03 = g_aqc[l_ac].aqc03,
                                  aqc04 = g_aqc[l_ac].aqc04,
                                  aqc05 = g_aqc[l_ac].aqc05,
                                  aqc06 = g_aqc[l_ac].aqc06,
                                  aqc07 = g_aqc[l_ac].aqc07,
                                  aqc08 = g_aqc[l_ac].aqc08,
                                aqcud01 = g_aqc[l_ac].aqcud01,
                                aqcud02 = g_aqc[l_ac].aqcud02,
                                aqcud03 = g_aqc[l_ac].aqcud03,
                                aqcud04 = g_aqc[l_ac].aqcud04,
                                aqcud05 = g_aqc[l_ac].aqcud05,
                                aqcud06 = g_aqc[l_ac].aqcud06,
                                aqcud07 = g_aqc[l_ac].aqcud07,
                                aqcud08 = g_aqc[l_ac].aqcud08,
                                aqcud09 = g_aqc[l_ac].aqcud09,
                                aqcud10 = g_aqc[l_ac].aqcud10,
                                aqcud11 = g_aqc[l_ac].aqcud11,
                                aqcud12 = g_aqc[l_ac].aqcud12,
                                aqcud13 = g_aqc[l_ac].aqcud13,
                                aqcud14 = g_aqc[l_ac].aqcud14,
                                aqcud15 = g_aqc[l_ac].aqcud15
               WHERE aqc01=g_aqa.aqa01
                 AND aqc02=g_aqc_t.aqc02
                 AND aqc03=g_aqc_t.aqc03
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN     #TQC-6B0087
                 CALL cl_err3("upd","aqc_file",g_aqa.aqa01,g_aqc_t.aqc02,SQLCA.sqlcode,"","",1)  #No.FUN-660122
                 LET g_aqc[l_ac].* = g_aqc_t.*
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'UPDATE O.K'

                 UPDATE aqa_file SET aqamodu=g_user,aqadate=g_today
                  WHERE aqa01=g_aqa.aqa01

                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                    CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
                    LET g_success ='N'
                 END IF
 
                 IF g_success='Y' THEN
                    COMMIT WORK
                 ELSE
                    ROLLBACK WORK
                 END IF
              END IF
             #No.8009 mark (確認段再判斷)
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
            #LET l_ac_t = l_ac  #FUN-D30032
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_aqc[l_ac].* = g_aqc_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_aqc.deleteElement(l_ac)
                  IF g_rec_b2 != 0 THEN
                     LET g_action_choice = "object_detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end--
               END IF
               CLOSE t900_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac  #FUN-D30032
            CLOSE t900_bcl
            COMMIT WORK
            CALL t900_aqc06_aqc08()   #MOD-820050
 
        ON ACTION controlp
           CASE
              WHEN INFIELD(aqc02)
                #CALL q_apb1(FALSE,TRUE) RETURNING g_aqc[l_ac].aqc02,                   #MOD-A40065 mark
                #CALL q_apb1(FALSE,TRUE,g_aqa.aqa02) RETURNING g_aqc[l_ac].aqc02,       #MOD-A40065 add#FUN-C90126 mark
                 CALL q_apb1(FALSE,TRUE,g_aqa.aqa02,g_aqa.aqa01) RETURNING g_aqc[l_ac].aqc02,       #FUN-C90126 add aqa01
                                                   g_aqc[l_ac].aqc03
                 DISPLAY g_aqc[l_ac].aqc02 TO aqc02
                 DISPLAY g_aqc[l_ac].aqc03 TO aqc03
              OTHERWISE
                 EXIT CASE
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
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
    END INPUT
    IF g_action_choice = "object_detail" THEN RETURN END IF  #FUN-D30032
    UPDATE aqa_file SET aqamodu=g_aqa.aqamodu,
                        aqadate=g_aqa.aqadate
     WHERE aqa01=g_aqa.aqa01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
       CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
       LET g_success ='N'
    END IF
 
    CLOSE t900_bcl
    CALL t900_v('')   #TQC-6B0087
    IF g_success='Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
 
END FUNCTION
 
FUNCTION t900_b_askkey()
    DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
    CLEAR azp02                           #清除FORMONLY欄位
    CONSTRUCT l_wc2 ON aqb02 
                  ,aqbud01,aqbud02,aqbud03,aqbud04,aqbud05
                  ,aqbud06,aqbud07,aqbud08,aqbud09,aqbud10
                  ,aqbud11,aqbud12,aqbud13,aqbud14,aqbud15
                 FROM s_aqb[1].aqb02
                     ,s_aqb[1].aqbud01,s_aqb[1].aqbud02,s_aqb[1].aqbud03,s_aqb[1].aqbud04,s_aqb[1].aqbud05
                     ,s_aqb[1].aqbud06,s_aqb[1].aqbud07,s_aqb[1].aqbud08,s_aqb[1].aqbud09,s_aqb[1].aqbud10
                     ,s_aqb[1].aqbud11,s_aqb[1].aqbud12,s_aqb[1].aqbud13,s_aqb[1].aqbud14,s_aqb[1].aqbud15
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
   p_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
   LET g_sql = "SELECT aqb02,'','','','','',aqb03,aqb04,", #FUN-680029
               "       aqbud01,aqbud02,aqbud03,aqbud04,aqbud05,",
               "       aqbud06,aqbud07,aqbud08,aqbud09,aqbud10,",
               "       aqbud11,aqbud12,aqbud13,aqbud14,aqbud15", 
               " FROM aqb_file",
               " WHERE aqb01 ='",g_aqa.aqa01,"'",
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY 1"
   PREPARE t900_pb FROM g_sql
   DECLARE aqb_curs CURSOR FOR t900_pb
 
   CALL g_aqb.clear()
   LET g_cnt = 1
   LET g_note_days = 0
   FOREACH aqb_curs INTO g_aqb[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_sql = "SELECT apa02,apa51,apa511,apa06,apa07", #FUN-680029
                  " FROM apa_file ",
                  "WHERE apa01 = ? "
      PREPARE t900_str6 FROM g_sql
      IF STATUS THEN
         CALL cl_err('change dbs_6 error',status,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      DECLARE z9_curs CURSOR FOR t900_str6
      OPEN z9_curs USING g_aqb[g_cnt].aqb02
      FETCH z9_curs INTO g_aqb[g_cnt].apa02,g_aqb[g_cnt].apa51,g_aqb[g_cnt].apa511, #FUN-680029
                         g_aqb[g_cnt].apa06, g_aqb[g_cnt].apa07
      CLOSE z9_curs
      CALL t900_aqb02('d',g_cnt)
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_aqb.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   CALL t900_aqb04()
END FUNCTION
 
FUNCTION t900_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
   #IF p_ud <> "G" OR g_action_choice = "detail" THEN                                             #FUN-D30032
   IF p_ud <> "G" OR g_action_choice = "source_detail" OR g_action_choice = "object_detail" THEN  #FUN-D30032
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   DISPLAY ARRAY g_aqb TO s_aqb.* ATTRIBUTE(COUNT=g_rec_b)
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
 
      AFTER DISPLAY
         CONTINUE DISPLAY
  
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
   END DISPLAY
 
    CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-490419
 
   DISPLAY ARRAY g_aqc TO s_aqc.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_aza.aza63 = 'N' THEN
            CALL cl_set_act_visible("entry_sheet2",FALSE)  
         END IF
 
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
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY
      ON ACTION previous
         CALL t900_fetch('P')
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY
      ON ACTION jump
         CALL t900_fetch('/')
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY
      ON ACTION next
         CALL t900_fetch('N')
         ACCEPT DISPLAY   #FUN-530067(smin)
         EXIT DISPLAY
      ON ACTION last
         CALL t900_fetch('L')
         ACCEPT DISPLAY   #FUN-530067(smin)
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
         #CHI-A50028 add --start--
         IF g_aqa.aqaconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         #CHI-A50028 add --end--
        #CALL cl_set_field_pic(g_aqa.aqaconf,"","","","",g_aqa.aqaacti)  #CHI-A50028 mark
         CALL cl_set_field_pic(g_aqa.aqaconf,"","","",g_void,g_aqa.aqaacti) #CHI-A50028
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
      #@ON ACTION 雜項單身
      ON ACTION source_detail
         LET g_action_choice="source_detail"
         EXIT DISPLAY
      #@ON ACTION 帳款單身
      ON ACTION object_detail
         LET g_action_choice="object_detail"
         EXIT DISPLAY
      #@ON ACTION 分攤
      ON ACTION apportion
         LET g_action_choice="apportion"
         EXIT DISPLAY
      #@ON ACTION 取消分攤
      ON ACTION refirm
         LET g_action_choice="refirm"
         EXIT DISPLAY
      ON ACTION confirm
         LET g_action_choice = "confirm"
         EXIT DISPLAY
      ON ACTION undo_confirm
         LET g_action_choice = "undo_confirm"
         EXIT DISPLAY
      #CHI-A50028 add --start--
      ON ACTION void   #作廢
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-A50028 add --end--

      #FUN-D20035---add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #FUN-D20035---add---end

      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      ON ACTION entry_sheet2
         LET g_action_choice="entry_sheet2"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="object_detail"
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
 
      ON ACTION carry_voucher #傳票拋轉
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
    
      ON ACTION undo_carry_voucher #傳票拋轉還原
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION related_document                #No.FUN-6A0016  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION controls                       #No.FUN-6B0033                                                                       
         CALL cl_set_head_visible("","AUTO")   #No.FUN-6B0033
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t900_b2_fill(p_wc2)              #BODY FILL UP
DEFINE
   p_wc2           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(200)
 
   LET g_sql = "SELECT aqc02,aqc03,aqc04,aqc05,aqc06,aqc07,aqc08,",
        "       aqcud01,aqcud02,aqcud03,aqcud04,aqcud05,",
        "       aqcud06,aqcud07,aqcud08,aqcud09,aqcud10,",
        "       aqcud11,aqcud12,aqcud13,aqcud14,aqcud15", 
               " FROM aqc_file",
               " WHERE aqc01 ='",g_aqa.aqa01,"'",
               "   AND ",p_wc2 CLIPPED
   PREPARE t900_aqc FROM g_sql
   DECLARE t900_aqc1 CURSOR FOR t900_aqc
 
   CALL g_aqc.clear()
   LET g_cnt = 1
   LET g_note_days = 0
   FOREACH t900_aqc1 INTO g_aqc[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_sql = "SELECT aqc04,aqc05,aqc06,aqc07,aqc08",
                  " FROM aqc_file ",
                  "WHERE aqc01 = ? ",
                  "  AND aqc02 = ? ",
                  "  AND aqc03 = ? "
      PREPARE t900_aqc6 FROM g_sql
      IF STATUS THEN
         CALL cl_err('change dbs_6 error',status,1)
         LET g_success='N'
         EXIT FOREACH
      END IF
      DECLARE z9_aqcs CURSOR FOR t900_aqc6
      OPEN z9_aqcs USING g_aqa.aqa01,g_aqc[g_cnt].aqc02,g_aqc[g_cnt].aqc03
      FETCH z9_aqcs INTO g_aqc[g_cnt].aqc04,g_aqc[g_cnt].aqc05,
                         g_aqc[g_cnt].aqc06,g_aqc[g_cnt].aqc07,
                         g_aqc[g_cnt].aqc08
      LET g_aqc[g_cnt].aqc07 = cl_digcut(g_aqc[g_cnt].aqc07,g_azi03) #No.CHI-6A0004
      LET g_aqc[g_cnt].aqc08 = cl_digcut(g_aqc[g_cnt].aqc08,g_azi04) #No.CHI-6A0004
      CLOSE z9_aqcs
      LET g_cnt = g_cnt + 1
   END FOREACH
   CALL g_aqc.deleteElement(g_cnt)
   LET g_rec_b2 = g_cnt-1
   DISPLAY g_rec_b2 TO FORMONLY.cn4
   CALL t900_aqc06_aqc08()
END FUNCTION
 
FUNCTION t900_aqc08()
 
DEFINE l_n   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_j   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_aqa03 LIKE aqa_file.aqa03  #FUN-4B0079
DEFINE l_aqc02 LIKE aqc_file.aqc02  #TQC-5B0087
DEFINE l_aqc03 LIKE aqc_file.aqc03  #TQC-5B0087
DEFINE l_aqc08 LIKE aqc_file.aqc08  #TQC-5B0087
DEFINE l_aqc05 LIKE aqc_file.aqc05  #TQC-5B0087
DEFINE l_aqc07 LIKE aqc_file.aqc07  #TQC-5B0087
DEFINE l_diff  LIKE aqa_file.aqa03  #TQC-5B0087
 
 
   IF g_tot IS NULL THEN LET g_tot=0 END IF
   IF g_tot1 IS NULL THEN LET g_tot1=0 END IF
   IF g_tot2 IS NULL THEN LET g_tot2=0 END IF
   IF g_tot3 IS NULL THEN LET g_tot3=0 END IF
 
   SELECT aqa03 INTO l_aqa03 FROM aqa_file where aqa01=g_aqa.aqa01
   LET l_n=g_rec_b2
 
   FOR i = 1 TO l_n
      LET g_tot=g_tot+g_aqc[i].aqc06
   END FOR
 
   FOR i = 1 TO l_n
      LET g_aqc[i].aqc08=g_aqc[i].aqc06+((g_aqc[i].aqc06/g_tot)*l_aqa03)
      LET g_aqc[i].aqc07=g_aqc[i].aqc08/g_aqc[i].aqc05
      IF g_aqc[i].aqc08 IS NULL THEN
         LET g_aqc[i].aqc08=g_aqc[i].aqc08
      END IF
      IF g_aqc[i].aqc07 IS NULL THEN
         LET g_aqc[i].aqc07=g_aqc[i].aqc07
      END IF
      LET g_aqc[i].aqc04 = cl_digcut(g_aqc[i].aqc04,g_azi03) #No.CHI-6A0004
      LET g_aqc[i].aqc06 = cl_digcut(g_aqc[i].aqc06,g_azi04) #No.CHI-6A0004
      LET g_aqc[i].aqc07 = cl_digcut(g_aqc[i].aqc07,g_azi03) #No.CHI-6A0004
      LET g_aqc[i].aqc08 = cl_digcut(g_aqc[i].aqc08,g_azi04) #No.CHI-6A0004
      UPDATE aqc_file SET aqc07=g_aqc[i].aqc07,aqc08=g_aqc[i].aqc08
       WHERE aqc01=g_aqa.aqa01 AND aqc02=g_aqc[i].aqc02
         AND aqc03=g_aqc[i].aqc03
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","aqc_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)
         LET g_success ='N'
         EXIT FOR
      END IF
      IF STATUS THEN LET g_success = 'N' END IF #No.8009
   END FOR
 
  SELECT SUM(aqc06) INTO g_tot1 FROM aqc_file where aqc01=g_aqa.aqa01
  SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
  LET g_tot3=g_tot2-g_tot1
  LET l_diff = g_tot3 - l_aqa03
  IF l_diff <> 0 THEN
     DECLARE aqc_c SCROLL CURSOR FOR  #MOD-680032
     SELECT aqc02,aqc03,aqc08,aqc05   #MOD-680032
        FROM aqc_file
        WHERE aqc01=g_aqa.aqa01 AND
              aqc06=(SELECT MAX(aqc06) FROM aqc_file WHERE aqc01=g_aqa.aqa01)
     OPEN aqc_c   #MOD-680032
     FETCH FIRST aqc_c INTO l_aqc02,l_aqc03,l_aqc08,l_aqc05   #MOD-680032
        LET l_aqc08 = cl_digcut(l_aqc08-l_diff,g_azi04)  #No.CHI-6A0004
        LET l_aqc07 = cl_digcut((l_aqc08-l_diff)/l_aqc05,g_azi03)  #No.CHI-6A0004
        UPDATE aqc_file SET aqc08=l_aqc08,aqc07=l_aqc07
           WHERE aqc01=g_aqa.aqa01 AND aqc02=l_aqc02 AND aqc03=l_aqc03
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
           LET g_success='N'
        ELSE
           SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
        END IF
  END IF
  DISPLAY g_tot1 TO FORMONLY.tot1
  DISPLAY g_tot2 TO FORMONLY.tot2
  DISPLAY g_tot3 TO FORMONLY.tot3
  LET g_tot=0
#No.MOD-A20039 --begin                                                          
  IF g_success ='Y' THEN                                                        
     CALL t900_v('')                                                            
  END IF                                                                        
#No.MOD-A20039 --end   
  CALL t900_b2_fill(' 1=1')
END FUNCTION
 
FUNCTION t900_un_aqc08()
 
DEFINE l_n   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_j   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_aqa03 LIKE aqa_file.aqa03  #FUN-4B0079
 
    IF g_tot IS NULL THEN LET g_tot=0 END IF
    IF g_tot1 IS NULL THEN LET g_tot1=0 END IF
    IF g_tot2 IS NULL THEN LET g_tot2=0 END IF
    IF g_tot3 IS NULL THEN LET g_tot3=0 END IF
 
   SELECT aqa03 INTO l_aqa03 FROM aqa_file where aqa01=g_aqa.aqa01
   LET l_n=g_rec_b2
 
    FOR i = 1 TO l_n
      LET g_tot=g_tot+g_aqc[i].aqc06
    END FOR
 
    FOR i = 1 TO l_n
       LET g_aqc[i].aqc08=g_aqc[i].aqc06
       LET g_aqc[i].aqc07=g_aqc[i].aqc04
       UPDATE aqc_file SET aqc07=g_aqc[i].aqc07,aqc08=g_aqc[i].aqc08
        WHERE aqc01=g_aqa.aqa01 AND aqc02=g_aqc[i].aqc02
          AND aqc03=g_aqc[i].aqc03
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
          CALL cl_err3("upd","aqc_file",g_aqa.aqa01,"",SQLCA.sqlcode,"","",1)   #TQC-6B0087
       END IF   #TQC-6B0087
    END FOR
 
  SELECT SUM(aqc06) INTO g_tot1 FROM aqc_file where aqc01=g_aqa.aqa01
  SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
  LET g_tot3=g_tot2-g_tot1
  CALL t900_v('')    #No.MOD-A20039 
  DISPLAY g_tot1 TO FORMONLY.tot1
  DISPLAY g_tot2 TO FORMONLY.tot2
  DISPLAY g_tot3 TO FORMONLY.tot3
  LET g_tot=0
  CALL t900_b2_fill(' 1=1')
END FUNCTION
 
FUNCTION t900_aqb04()
DEFINE l_n LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_tot  LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE l_tot4 LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE l_tot5 LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE l_tot6 LIKE type_file.num20_6     #TQC-6B0087
DEFINE l_tot_aqb04 LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
 
   IF l_tot IS NULL THEN LET l_tot=0 END IF
   IF l_tot4 IS NULL THEN LET l_tot4=0 END IF
   IF l_tot5 IS NULL THEN LET l_tot5=0 END IF
   IF l_tot6 IS NULL THEN LET l_tot6=0 END IF   #TQC-6B0087
   LET l_n=0
   SELECT SUM(aqb04) INTO l_tot FROM aqb_file WHERE aqb01=g_aqa.aqa01
   SELECT SUM(aqb04) INTO l_tot4 FROM aqb_file,apa_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND (apa00='23' OR apa00='25')     #No.FUN-690080
   SELECT SUM(aqb04) INTO l_tot5 FROM aqb_file,apa_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND (apa00='12' OR apa00='13' OR apa00='16')     #No.FUN-690080   #MOD-820050
   SELECT SUM(aqb04) INTO l_tot6 FROM aqb_file,apa_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND apa00='22'
   LET g_aqa03=0
   LET g_aqa03=l_tot
   LET g_aqa.aqa03=g_aqa03
   IF l_tot4 IS NULL THEN LET l_tot4=0 END IF
   IF l_tot5 IS NULL THEN LET l_tot5=0 END IF
   IF l_tot6 IS NULL THEN LET l_tot6=0 END IF   #TQC-6B0087
   DISPLAY BY NAME g_aqa.aqa03
   DISPLAY l_tot4 TO FORMONLY.tot4
   DISPLAY l_tot5 TO FORMONLY.tot5
   DISPLAY l_tot6 TO FORMONLY.tot6   #TQC-6B0087
END FUNCTION
 
FUNCTION t900_s()                   #No:8009 將S改為Y
DEFINE l_cnt     LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cnt1    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cnt2    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_apydmy3 LIKE apy_file.apydmy3
DEFINE l_aqa03   LIKE aqa_file.aqa03
 
   IF cl_null(g_aqa.aqa01) THEN RETURN END IF
    SELECT * INTO g_aqa.* FROM aqa_file
     WHERE aqa01=g_aqa.aqa01
    IF g_aqa.aqa04 = 'Y' THEN RETURN END IF
    IF g_aqa.aqaconf='Y' THEN RETURN END IF     #No:8009
    IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
    IF NOT cl_confirm('mfg-062') THEN RETURN END IF   #No:8009
   SELECT COUNT(*) INTO l_cnt1 FROM aqb_file
    WHERE aqb01 = g_aqa.aqa01
   SELECT COUNT(*) INTO l_cnt2 FROM aqc_file
    WHERE aqc01 = g_aqa.aqa01
   IF l_cnt1=0 OR l_cnt2=0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #檢查來源、目的帳款若有已作廢單號或外購，不可做分攤的動作 modi 01/08/04
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqb_file
    WHERE apa01 = aqb02 AND aqb01 = g_aqa.aqa01
      AND (apa42 = 'Y' OR apa75 = 'Y')
   IF g_cnt > 0 THEN CALL cl_err('','aap-329',0) RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqc_file
    WHERE apa01 = aqc02 AND aqc01 = g_aqa.aqa01
      AND (apa42 = 'Y' OR apa75 = 'Y')
   IF g_cnt > 0 THEN CALL cl_err('','aap-330',0) RETURN END IF
   #No:8009 分攤改為按功能鈕攤
   LET g_success='Y'
   BEGIN WORK
   OPEN t900_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
 
     CALL t900_aqc08()
     UPDATE aqa_file SET aqa04 = 'Y' WHERE aqa01 = g_aqa.aqa01
     #IF STATUS THEN   #TQC-6B0087
     IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
        CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",STATUS,"","upd aqa04:",1)  #No.FUN-660122
        LET g_success='N'
     END IF
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   SELECT aqa04 INTO g_aqa.aqa04 FROM aqa_file
    WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME  g_aqa.aqa04
END FUNCTION
 
FUNCTION t900_t()    #取消分攤 No:8009 add
   IF cl_null(g_aqa.aqa01) THEN RETURN END IF
    SELECT * INTO g_aqa.* FROM aqa_file
     WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqa04='N' THEN RETURN END IF
   IF g_aqa.aqaconf='Y' THEN RETURN END IF
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
 
   IF NOT cl_confirm('mfg-061') THEN RETURN END IF
   BEGIN WORK LET g_success = 'Y'
   OPEN t900_cl USING g_aqa.aqa01
   FETCH t900_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t900_cl
      ROLLBACK WORK RETURN
   END IF
   CALL t900_max()
   CALL t900_un_aqc08()
   UPDATE aqa_file SET aqa04 = 'N' WHERE aqa01 = g_aqa.aqa01
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
      CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",STATUS,"","upd aqa_file",1)  #No.FUN-660122
      LET g_success = 'N'
   END IF
   IF g_success = 'N' THEN ROLLBACK WORK ELSE COMMIT WORK END IF
   SELECT aqa04 INTO g_aqa.aqa04 FROM aqa_file WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME  g_aqa.aqa04
END FUNCTION
 
FUNCTION t900_y()                   #No.8009 新增確認碼
DEFINE l_cnt     LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cnt1    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_cnt2    LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_apydmy3 LIKE apy_file.apydmy3
DEFINE l_apyglcr LIKE apy_file.apyglcr          #No.FUN-670060
DEFINE l_apygslp LIKE apy_file.apygslp          #No.FUN-670060
DEFINE l_aqa03   LIKE aqa_file.aqa03
 
   LET g_success='Y'                            #No.FUN-670060
   IF cl_null(g_aqa.aqa01) THEN RETURN END IF
#CHI-C30107 --------------- add ----------------- begin
   IF g_aqa.aqa04 = 'N' THEN RETURN END IF      
   IF g_aqa.aqaconf = 'Y' THEN RETURN END IF    
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF 
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
#CHI-C30107 --------------- add ----------------- end
   IF g_aqa.aqa04 = 'N' THEN RETURN END IF      #No.8009 未攤不可確認
   IF g_aqa.aqaconf = 'Y' THEN RETURN END IF    #No.8009
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
   IF g_tot2=g_tot1 THEN
   #message "分攤前金額與分攤後金額相同!!"
   CALL cl_err('','mfg-045',0)
   RETURN END IF
   SELECT SUM(aqa03) INTO l_aqa03 FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF l_aqa03<>g_tot3 THEN
     CALL cl_err('','mfg-046',0)
     RETURN
   END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   SELECT COUNT(*) INTO l_cnt1 FROM aqb_file
    WHERE aqb01 = g_aqa.aqa01
   SELECT COUNT(*) INTO l_cnt2 FROM aqc_file
    WHERE aqc01 = g_aqa.aqa01
   IF l_cnt1=0 OR l_cnt2=0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   #檢查來源、目的帳款若有已作廢單號或外購，不可做分攤的動作 modi 01/08/04
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqb_file
    WHERE apa01 = aqb02 AND aqb01 = g_aqa.aqa01
      AND (apa42 = 'Y' OR apa75 = 'Y')
   IF g_cnt > 0 THEN CALL cl_err('','aap-329',0) RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqc_file
    WHERE apa01 = aqc02 AND aqc01 = g_aqa.aqa01
      AND (apa42 = 'Y' OR apa75 = 'Y')
   IF g_cnt > 0 THEN CALL cl_err('','aap-330',0) RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqb_file
    WHERE (apa00 = '22' OR apa00='23' OR apa00='25')   #No.FUN-690080   #TQC-6B0087
      AND apa01=aqb_file.aqb02
      AND aqb01=g_aqa.aqa01
   LET g_t1=s_get_doc_no(g_aqa.aqa01)     #No.FUN-560002
   SELECT apydmy3,apyglcr INTO l_apydmy3,l_apyglcr FROM apy_file WHERE apyslip = g_t1    #No.FUN-670060
   IF l_apydmy3 = 'Y' AND l_apyglcr = 'N' THEN  #No.FUN-670060
      CALL s_chknpq(g_aqa.aqa01,'AP',1,'0',g_bookno1)       #NO.FUN-730064
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_aqa.aqa01,'AP',1,'1',g_bookno2)    #NO.FUN-730064
      END IF
   END IF
   IF g_success='N' THEN RETURN END IF
 
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   LET g_success='Y'
   BEGIN WORK
   OPEN t900_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
 
 
   IF l_apydmy3 = 'Y' AND l_apyglcr = 'Y' THEN
      CALL s_get_doc_no(g_aqa.aqa01) RETURNING g_t1
      SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
      SELECT COUNT(*) INTO g_cnt FROM npq_file
       WHERE npq01 =g_aqa.aqa01
         AND npq011=1
         AND npqsys = 'AP'      
         AND npq00=4     
      IF g_cnt =0 THEN       
         CALL t900_gen_glcr(g_aqa.*,g_apy.*)
      END IF
      IF g_success = 'Y' THEN            
         CALL s_chknpq(g_aqa.aqa01,'AP',1,'0',g_bookno1)             #NO.FUN-730064
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_aqa.aqa01,'AP',1,'1',g_bookno2)          #NO.FUN-730064
         END IF
      END IF
   END IF
   IF g_success ='N' THEN
      CLOSE t900_cl                                                                                                                 
      ROLLBACK WORK                                                                                                                 
      RETURN    
   END IF
 
   UPDATE aqa_file SET aqaconf = 'Y' WHERE aqa01 = g_aqa.aqa01
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
      CALL cl_err3("upd","aqa_file",g_aqa.aqa01,"",STATUS,"","upd aqa04:",1)  #No.FUN-660122
      LET g_success= 'N'
   END IF
   CALL t900_hu()     #回寫 apa081
   CALL t900_apa35()  #回寫預付 apa35
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   SELECT aqaconf INTO g_aqa.aqaconf FROM aqa_file
    WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME  g_aqa.aqaconf
   IF l_apydmy3 = 'Y' AND l_apyglcr = 'Y' AND g_success = 'Y' THEN
     #CALL s_showmsg_init()                                            #MOD-C50093 add #MOD-C50243 mark
      LET g_wc_gl = 'npp01 = "',g_aqa.aqa01,'" AND npp011 = 1'
      LET g_str="aapp400 '",g_wc_gl CLIPPED,"' '",g_aqa.aqauser,"' '",g_aqa.aqauser,"' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_apy.apygslp,"' '",g_aqa.aqa02,"' 'Y' '1' 'Y' '",g_apz.apz02c,"' '",g_apy.apygslp1,"' 'Y'"      #MOD-7B0159  #No.MOD-860075 #MOD-B10041 add 'Y'
      CALL cl_cmdrun_wait(g_str)
      SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
       WHERE aqa01 = g_aqa.aqa01
     #--------------------------MOD-C50093---------------------------(S)
      CALL s_errmsg('',g_aqa.aqa05,'','','')
      CALL s_showmsg()
     #--------------------------MOD-C50093---------------------------(E)
      DISPLAY BY NAME g_aqa.aqa05
   END IF
END FUNCTION
 
FUNCTION t900_chk()
DEFINE l_n LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_d LIKE type_file.num20_6     # No.FUN-690028 DEC(20,6)  #FUN-4B0079
DEFINE l_aqa03 LIKE aqa_file.aqa03  #FUN-4B0079
 
   SELECT aqa03 INTO l_aqa03 FROM aqa_file WHERE aqa01=g_aqa.aqa01
   LET l_n=g_rec_b2
   LET l_d=0
   LET l_d=l_aqa03-g_tot3
 
   FOR i = l_n TO l_n
      LET g_aqc[i].aqc08=g_aqc[i].aqc08+l_d
      LET g_aqc[i].aqc08 = cl_digcut(g_aqc[i].aqc08,g_azi04)  #No.CHI-6A0004
      UPDATE aqc_file SET aqc08=g_aqc[i].aqc08
       WHERE aqc01=g_aqa.aqa01 AND aqc02=g_aqc[i].aqc02
         AND aqc03=g_aqc[i].aqc03
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
         CALL cl_err3("upd","aqc_file",g_aqa.aqa01,"",STATUS,"","",1)  #TQC-6B0087
      END IF   #TQC-6B0087
   END FOR
 
   SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
   LET g_tot3=g_tot2-g_tot1
   DISPLAY g_tot2 TO FORMONLY.tot2
   DISPLAY g_tot3 TO FORMONLY.tot3
END FUNCTION
 
FUNCTION t900_hu()
DEFINE l_n LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
    LET l_n=g_rec_b2
 
    FOR i = 1 TO l_n
        UPDATE apb_file set apb081=g_aqc[i].aqc07,apb101=g_aqc[i].aqc08
         WHERE apb01=g_aqc[i].aqc02
           AND apb02=g_aqc[i].aqc03
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
           CALL cl_err3("upd","apb_file",g_aqc[i].aqc02,g_aqc[i].aqc03,SQLCA.sqlcode,"","",1)  #No.FUN-660122
           LET g_success ='N' #No.7101
           EXIT FOR
        END IF
    END FOR
END FUNCTION
 
FUNCTION t900_z()
   DEFINE  l_aba19        LIKE aba_file.aba19   #No.FUN-670060
   DEFINE  l_dbs          STRING                #No.FUN-670060
   DEFINE  l_sql          STRING                #No.FUN-670060
 
   IF cl_null(g_aqa.aqa01) THEN RETURN END IF
   SELECT * INTO g_aqa.* FROM aqa_file
    WHERE aqa01=g_aqa.aqa01
   IF g_aqa.aqaconf='N' THEN RETURN END IF   #No.8009
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
 
   SELECT COUNT(*) INTO g_cnt FROM apa_file,aqb_file
    WHERE (apa00 = '22' OR apa00='23' OR apa00='25')   #No.FUN-690080   #TQC-6B0087
      AND apa01=aqb_file.aqb02
      AND aqb01=g_aqa.aqa01
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_aqa.aqa01) RETURNING g_t1 
   SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
   IF NOT cl_null(g_aqa.aqa05) THEN
      IF NOT (g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y') THEN
         CALL cl_err(g_aqa.aqa01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' THEN
      LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
     #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                  "  WHERE aba00 = '",g_apz.apz02b,"'",
                  "    AND aba01 = '",g_aqa.aqa05,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_aqa.aqa05,'axr-071',1)
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('axm-109') THEN
      RETURN
   END IF
  #-----------------------------CHI-C90051--------------(S)
   IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' THEN
      IF NOT cl_null(g_aqa.aqa05) THEN
         LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_aqa.aqa05,"' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
          WHERE aqa01 = g_aqa.aqa01
         DISPLAY BY NAME g_aqa.aqa05
         IF NOT cl_null(g_aqa.aqa05) THEN
            CALL cl_err('','aap-929',0)
            RETURN
         END IF
      END IF
   END IF
  #-----------------------------CHI-C90051--------------(E)
   BEGIN WORK
   LET g_success = 'Y'
   OPEN t900_cl USING g_aqa.aqa01
   IF STATUS THEN
      CALL cl_err("OPEN t900_cl:", STATUS, 1)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t900_cl INTO g_aqa.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_aqa.aqa01,SQLCA.sqlcode,0)
      CLOSE t900_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL t900_max()
   UPDATE aqa_file SET aqaconf = 'N' WHERE aqa01 = g_aqa.aqa01 #No.8009
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN LET g_success = 'N' END IF   #TQC-6B0087
   CALL t900_hu_z()
   CALL t900_apa35t()
   IF g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   SELECT aqaconf INTO g_aqa.aqaconf FROM aqa_file WHERE aqa01 = g_aqa.aqa01
   DISPLAY BY NAME  g_aqa.aqaconf   #No.8009
 
  #-----------------------------CHI-C90051--------------------mark
  #IF g_apy.apydmy3 = 'Y' AND g_apy.apyglcr = 'Y' AND g_success = 'Y' THEN
  #   LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_aqa.aqa05,"' 'Y'"
  #   CALL cl_cmdrun_wait(g_str)
  #   SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
  #    WHERE aqa01 = g_aqa.aqa01
  #   DISPLAY BY NAME g_aqa.aqa05
  #END IF
  #-----------------------------CHI-C90051--------------------mark
 
END FUNCTION
 
FUNCTION t900_hu_z()
DEFINE l_n LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_apb081 LIKE apb_file.apb081
DEFINE l_apb101 LIKE apb_file.apb101
 
   LET l_n=g_rec_b2
   FOR i = 1 TO l_n
      UPDATE apb_file SET apb081=g_aqc[i].aqc04,
                          apb101=g_aqc[i].aqc06
       WHERE apb01=g_aqc[i].aqc02
         AND apb02=g_aqc[i].aqc03
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         CALL cl_err3("upd","apb_file",g_aqc[i].aqc02,g_aqc[i].aqc03,SQLCA.sqlcode,"","",1)  #No.FUN-660122
         LET g_success = 'N'
         EXIT FOR
      END IF
   END FOR
END FUNCTION
 
FUNCTION t900_max()
DEFINE l_aqa02  LIKE aqa_file.aqa02
DEFINE l_n      LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   LET l_n=g_rec_b2
   FOR i = 1 TO l_n
      SELECT MAX(aqa02) INTO l_aqa02
        FROM aqa_file,aqc_file
       WHERE aqa01=aqc01
         AND aqc02=g_aqc[i].aqc02
         AND aqc03=g_aqc[i].aqc03
         AND aqaconf <> 'X'             #MOD-A80107
      IF l_aqa02<>g_aqa.aqa02 THEN
         CALL cl_err('','mfg-050',0)
         LET g_success ='N'
         EXIT FOR
      END IF
   END FOR
END FUNCTION
 
FUNCTION t900_apa51()
DEFINE l_apa51 LIKE apa_file.apa51
DEFINE t_apa51 LIKE apa_file.apa51
 
   LET g_cnt=0
   SELECT apa51,COUNT(*) INTO l_apa51,g_cnt
     FROM aqc_file,apa_file
    WHERE aqc01=g_aqa.aqa01
      AND aqc02=apa01
    GROUP BY apa51
   IF cl_null(g_cnt) THEN
      LET g_cnt=0
   END IF
 
   SELECT apa51 INTO t_apa51
     FROM apa_file
    WHERE apa01=g_aqc[l_ac].aqc02
 
   IF l_apa51 IS NULL THEN
      LET l_apa51=' '
    END IF
   IF t_apa51 IS NULL THEN
      LET t_apa51=' '
   END IF
END FUNCTION
 
FUNCTION t900_apa35()                 #分攤時,回寫來源預付的apa35
DEFINE l_apa00 LIKE apa_file.apa00
DEFINE l_apa01 LIKE apa_file.apa01
DEFINE l_apa34 LIKE apa_file.apa34    #MOD-B80061
DEFINE l_apa34f LIKE apa_file.apa34f  #MOD-B80061
DEFINE l_apa35 LIKE apa_file.apa35
DEFINE l_apa35f LIKE apa_file.apa35f
DEFINE l_apa13 LIKE apa_file.apa13    #MOD-B80061
DEFINE l_apa14 LIKE apa_file.apa14
DEFINE l_n     LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_apa11 LIKE apa_file.apa11
DEFINE l_sql   STRING
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_pmb03 LIKE pmb_file.pmb03
DEFINE l_pmb05 LIKE pmb_file.pmb05
DEFINE l_apc10 LIKE apc_file.apc10
DEFINE l_apc11 LIKE apc_file.apc11
 

   LET l_apa35 = 0                #MOD-A10149 add
   SELECT COUNT(*) INTO l_n FROM aqa_file,aqb_file
    WHERE aqa01 = aqb01 AND aqb01 = g_aqa.aqa01
 
   FOR i = 1 TO l_n
      SELECT apa00,apa01,apa14,apa11,apa34,apa34f INTO l_apa00,l_apa01,l_apa14,l_apa11,l_apa34,l_apa34f       #MOD-970285 add apa11,l_apa11 #MOD-B80061 add apa34/apa34f
        FROM apa_file
       WHERE apa01=g_aqb[i].aqb02
 
     #-MOD-B80061-add- 
      SELECT azi04 INTO t_azi04 
        FROM azi_file 
       WHERE azi01 = l_apa13 
     #-MOD-B80061-end- 

      IF l_apa00='23' OR l_apa00='25' OR l_apa00='22' THEN   #No.FUN-690080  #MOD-B50200 add 22
         SELECT aqb04 INTO l_apa35   #TQC-6C0044
           FROM aqa_file,aqb_file
          WHERE aqa01=aqb01
            AND aqa04='Y'
            AND aqaconf = 'Y'         #No.8009
            AND aqb02=g_aqb[i].aqb02
            AND aqa01=g_aqa.aqa01   #TQC-6C0044
 
        #IF l_apa00='22' THEN LET l_apa35=l_apa35*-1 END IF   #MOD-B50200 add #MOD-B60040 mark
         LET l_apa35f=0
        #LET l_apa35f=l_apa35/l_apa14        #MOD-B80061 mark
        #-MOD-B80061-add-
         IF l_apa00='23' THEN                                 #MOD-BC0134 add
            IF l_apa35 = l_apa34 THEN
               LET l_apa35f = l_apa34f
            ELSE
               LET l_apa35f=l_apa35/l_apa14
               LET l_apa35f = cl_digcut(l_apa35f,t_azi04) 
            END IF 
         END IF                                                #MOD-BC0134 add
        #-MOD-B80061-end-
         IF l_apa35 IS NULL THEN
            LET l_apa35=0
         END IF
         CALL t900_comp_oox(g_aqb[i].aqb02) RETURNING g_net
         UPDATE apa_file SET apa35=apa35 + l_apa35,
                             apa35f=apa35f + l_apa35f,
                             apa73=apa73 - l_apa35
          WHERE apa01=g_aqb[i].aqb02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
            CALL cl_err3("upd","apa_file",g_aqb[i].aqb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            LET g_success='N'   #TQC-6B0087
            EXIT FOR   #TQC-6B0087
         END IF
  #   END IF      #MOD-B20069 mark
  #END FOR        #MOD-B20069 mark
         SELECT COUNT(*) INTO l_cnt FROM pmb_file WHERE pmb01=l_apa11
         IF NOT cl_null(l_apa35) AND l_apa35 <> 0 THEN             #MOD-A10149 add
            IF l_cnt > 0 THEN
               LET l_sql="SELECT pmb03,pmb05 ",
                         "  FROM pmb_file ",
                         " WHERE pmb01='",l_apa11,"'"
               PREPARE pmb_pl FROM l_sql
               DECLARE pmb_cl CURSOR FOR pmb_pl
               FOREACH pmb_cl INTO l_pmb03,l_pmb05
                  LET l_apc10 = l_apa35f* l_pmb05/100
                  LET l_apc11 = l_apa35 * l_pmb05/100
                  UPDATE apc_file SET apc10 = apc10 + l_apc10,
                                      apc11 = apc11 + l_apc11,
                                     #apc13 = apc09 - apc11       #MOD-B20069 mark
                                      apc13 = apc13 - l_apc11     #MOD-B20069 
                   WHERE apc01=l_apa01 AND apc02=l_pmb03
               END FOREACH
            ELSE
               UPDATE apc_file SET apc10 = apc10 + l_apa35f,
                                   apc11 = apc11 + l_apa35,
                                  #apc13 = apc09 - apc11          #MOD-B20069 mark  
                                   apc13 = apc13 - l_apa35        #MOD-B20069 
                WHERE apc01=l_apa01
            END IF
         END IF              #MOD-A10149 add
      END IF     #MOD-B20069
   END FOR       #MOD-B20069
END FUNCTION
 
FUNCTION t900_apa35t()                 #分攤時,回寫來源預付的apa35
DEFINE l_apa00 LIKE apa_file.apa00
DEFINE l_apa01 LIKE apa_file.apa01
DEFINE l_apa34 LIKE apa_file.apa34    #MOD-BC0134 add
DEFINE l_apa34f LIKE apa_file.apa34f  #MOD-BC0134 add
DEFINE l_apa35 LIKE apa_file.apa35
DEFINE l_apa35f LIKE apa_file.apa35f
DEFINE l_apa13 LIKE apa_file.apa13    #MOD-B80061
DEFINE l_apa14 LIKE apa_file.apa14
DEFINE l_n     LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_apa11 LIKE apa_file.apa11
DEFINE l_sql   STRING
DEFINE l_cnt   LIKE type_file.num5
DEFINE l_pmb03 LIKE pmb_file.pmb03
DEFINE l_pmb05 LIKE pmb_file.pmb05
DEFINE l_apc10 LIKE apc_file.apc10
DEFINE l_apc11 LIKE apc_file.apc11
 
   LET l_apa35 = 0                #MOD-A10149 add
   SELECT COUNT(*) INTO l_n FROM aqa_file,aqb_file
    WHERE aqa01 = aqb01 AND aqb01 = g_aqa.aqa01
 
   FOR i = 1 TO l_n
      SELECT apa00,apa01,apa14,apa11,apa13,apa34,apa34f 
        INTO l_apa00,l_apa01,l_apa14,l_apa11,l_apa13,l_apa34,l_apa34f      #MOD-970285 add apa11,l_apa11 #MOD-B80061 add apa13 #MOD-BC0134 add apa34 apa34f
        FROM apa_file
       WHERE apa01=g_aqb[i].aqb02
 
     #-MOD-B80061-add- 
      SELECT azi04 INTO t_azi04 
        FROM azi_file 
       WHERE azi01 = l_apa13 
     #-MOD-B80061-end- 

      IF l_apa00='23' OR l_apa00='25' OR l_apa00='22' THEN   #No.FUN-690080  #MOD-B50200 add 22
         SELECT aqb04 INTO l_apa35   #TQC-6C0044
           FROM aqa_file,aqb_file
          WHERE aqb02=g_aqb[i].aqb02
            AND aqa01=aqb01
            AND aqa04='Y'
            AND aqaconf = 'N' #No.8009   #TQC-6C0044
            AND aqa01 = g_aqa.aqa01   #TQC-6C0044
 
         IF l_apa35 IS NULL THEN LET l_apa35=0 END IF
        #IF l_apa00='22' THEN LET l_apa35=l_apa35*-1 END IF   #MOD-B50200 add #MOD-B60040 mark
         LET l_apa35f=0
        #------------MOD-BC0134----------start
         IF l_apa00='23' THEN
            IF l_apa35 = l_apa34 THEN
               LET l_apa35f = l_apa34f
            ELSE
        #------------MOD-BC0134------------end
               LET l_apa35f=l_apa35/l_apa14
               LET l_apa35f = cl_digcut(l_apa35f,t_azi04)   #MOD-B80061 
            END IF                                             #MOD-BC0134 add
         END IF                                                #MOD-BC0134 add
         CALL t900_comp_oox(g_aqb[i].aqb02) RETURNING g_net
         UPDATE apa_file SET apa35=apa35 - l_apa35,
                             apa35f=apa35f - l_apa35f,
                             apa73=apa73 + l_apa35
          WHERE apa01=g_aqb[i].aqb02
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
            CALL cl_err3("upd","apa_file",g_aqb[i].aqb02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660122
            LET g_success='N'   #TQC-6B0087
            EXIT FOR   #TQC-6B0087
         END IF
  #   END IF           #MOD-B20069 mark
  #END FOR             #MOD-B20069 mark
         SELECT COUNT(*) INTO l_cnt FROM pmb_file WHERE pmb01=l_apa11
         IF NOT cl_null(l_apa35) AND l_apa35 <> 0 THEN             #MOD-A10149 add
            IF l_cnt > 0 THEN
               LET l_sql="SELECT pmb03,pmb05 ",
                         "  FROM pmb_file ",
                         " WHERE pmb01='",l_apa11,"'"
               PREPARE pmb_p2 FROM l_sql
               DECLARE pmb_c2 CURSOR FOR pmb_p2
               FOREACH pmb_c2 INTO l_pmb03,l_pmb05
                  LET l_apc10 = l_apa35f* l_pmb05/100
                  LET l_apc11 = l_apa35 * l_pmb05/100
                  UPDATE apc_file SET apc10 = apc10 - l_apc10,
                                      apc11 = apc11 - l_apc11,
                                     #apc13 = apc09 - apc11      #MOD-B20069 mark
                                      apc13 = apc13 + l_apc11    #MOD-B20069 
                   WHERE apc01=l_apa01 AND apc02=l_pmb03
               END FOREACH
            ELSE
               UPDATE apc_file SET apc10 = apc10 - l_apa35f,
                                   apc11 = apc11 - l_apa35,
                                  #apc13 = apc09 - apc11         #MOD-B20069 mark
                                   apc13 = apc13 + l_apa35       #MOD-B20069 
                WHERE apc01=l_apa01
            END IF
         END IF              #MOD-A10149 add
      END IF           #MOD-B20069 
   END FOR             #MOD-B20069
END FUNCTION
 
FUNCTION t900_v(p_cmd)
   DEFINE l_wc    LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(100)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
   DEFINE l_aqa01 LIKE aqa_file.aqa01
   DEFINE only_one   LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
   DEFINE l_t1       LIKE apy_file.apyslip      # No.FUN-690028 VARCHAR(5)                 #No.FUN-550030
   DEFINE l_cnt      LIKE type_file.num5    #No.FUN-690028 SMALLINT
   DEFINE l_apydmy3  LIKE type_file.chr1        # No.FUN-690028 VARCHAR(1)
   DEFINE l_apa00    LIKE apa_file.apa00

   #--MOD-C30706--add--str--
   IF p_cmd = '4' THEN 
      LET g_t1=s_get_doc_no(g_aqa.aqa01)
      SELECT apydmy3 INTO l_apydmy3 FROM apy_file
       WHERE apyslip = g_t1
      IF l_apydmy3 = 'N' THEN 
         CALL cl_err('','mfg9310',1) 
         RETURN 
      END IF 
   END IF 
   #--MOD-C30706--add--end--
 
   IF g_aqa.aqaconf = 'X' THEN CALL cl_err(g_aqa.aqa01,'9024',0) RETURN END IF  #CHI-A50028 add
   IF p_cmd  = '4' THEN
      OPEN WINDOW t900_w9 AT 10,10 WITH FORM "aap/42f/aapt900_9"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("aapt900_9")
 
 
      LET only_one = '1'
      CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
      INPUT BY NAME only_one WITHOUT DEFAULTS
         AFTER FIELD only_one
            IF NOT cl_null(only_one) THEN
               IF only_one NOT MATCHES "[12]" THEN
                  NEXT FIELD only_one
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
         CLOSE WINDOW t900_w9
         RETURN
      END IF
      IF only_one = '1' THEN
         LET l_wc = " aqa01 = '",g_aqa.aqa01,"' "
      ELSE
         CALL cl_set_head_visible("","YES")     #No.FUN-6B0033			
 
         CONSTRUCT BY NAME l_wc ON aqa01,aqa02
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              ON ACTION controlp
                 CASE
                    WHEN INFIELD(aqa01) #查詢單据
                  LET g_t1=s_get_doc_no(g_aqa.aqa01)
                       CALL q_apy(FALSE,FALSE,g_t1,g_aptype,'AAP') RETURNING g_t1   #TQC-670008 
                       LET g_aqa.aqa01=g_t1
                       DISPLAY BY NAME g_aqa.aqa01
                       NEXT FIELD aqa01
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
              IF INT_FLAG THEN
                 LET INT_FLAG=0
                 CLOSE WINDOW t900_w9
                 RETURN
              END IF
      END IF
      CLOSE WINDOW t900_w9
   END IF
 
   LET g_success='Y'
   BEGIN WORK
   MESSAGE "WORKING !"
 
   IF cl_null(l_wc) THEN LET l_wc = " aqa01 = '",g_aqa.aqa01,"' "  END IF  #TQC-6B0087
   LET g_sql = "SELECT aqa01 FROM aqa_file WHERE ",l_wc CLIPPED,
               "   AND (aqa05 IS NULL OR aqa05 = ' ')"
   PREPARE t900_v_p FROM g_sql
   DECLARE t900_v_c CURSOR WITH HOLD FOR t900_v_p
   FOREACH t900_v_c INTO l_aqa01
      IF STATUS THEN EXIT FOREACH END IF
      LET l_t1 = s_get_doc_no(l_aqa01)      #No.FUN-560002
      LET l_apydmy3 = ''
      SELECT apydmy3 INTO l_apydmy3 FROM apy_file WHERE apyslip = l_t1
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","apy_file",l_t1,"",STATUS,"","sel apy:",1)  #No.FUN-660122
         LET g_success = 'N'   #TQC-6B0087
         EXIT FOREACH   #TQC-6B0087
      END IF
      IF l_apydmy3 = 'Y' THEN   #是否拋轉傳票
         CALL t900_g_gl(l_aqa01,'0') #產生第一分錄
         IF g_aza.aza63 = 'Y' THEN
            CALL t900_g_gl(l_aqa01,'1') #產生第二分錄
         END IF
      END IF
   END FOREACH
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   MESSAGE " "
END FUNCTION
 
FUNCTION t900_npp02(p_npptype)  #FUN-680029
DEFINE p_npptype  LIKE npp_file.npptype  #FUN-680029
   UPDATE npp_file SET npp02=g_aqa.aqa02
    WHERE npp01=g_aqa.aqa01
      AND npp011=1
      AND nppsys = 'AP'
      AND npp00=4      
      AND npptype=p_npptype  #FUN-680029
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN   #TQC-6B0087
      CALL cl_err3("upd","npp_file",g_aqa.aqa01,"",STATUS,"","upd npp02:",1)  #No.FUN-660122
   END IF
END FUNCTION
 
FUNCTION t900_o()
    DEFINE
        l_i             LIKE type_file.num5,    #No.FUN-690028 SMALLINT
        l_name          LIKE type_file.chr20,                 # External(Disk) file name  #No.FUN-690028 VARCHAR(20)
        l_za05          LIKE type_file.chr1000,               #  #No.FUN-690028 VARCHAR(40)
        l_sql           LIKE type_file.chr1000, #No.FUN-690028 VARCHAR(600)
        l_apa00         LIKE apa_file.apa00,
        l_apa01         LIKE apa_file.apa01,
        l_apa02         LIKE apa_file.apa02,
        l_apa51         LIKE apa_file.apa51,
        l_apa06         LIKE apa_file.apa06,
        l_apa07         LIKE apa_file.apa07,
        sr        RECORD
                  aqa01 LIKE  aqa_file.aqa01,
                  aqa02 LIKE  aqa_file.aqa02,
                  aqa03 LIKE  aqa_file.aqa03,
                  aqa04 LIKE  aqa_file.aqa04,
                  aqa05 LIKE  aqa_file.aqa05,
                  apa00 LIKE  apa_file.apa00,
                  apa01 LIKE  apa_file.apa01,
                  apa02 LIKE  apa_file.apa02,
                  apa51 LIKE  apa_file.apa51,
                  apa06 LIKE  apa_file.apa06,
                  apa07 LIKE  apa_file.apa07,
                  aqb01 LIKE  aqb_file.aqb01,
                  aqb02 LIKE  aqb_file.aqb02,
                  aqb03 LIKE  aqb_file.aqb03,
                  aqb04 LIKE  aqb_file.aqb04
              END RECORD,
       sr1  RECORD
                  aqc01 LIKE  aqc_file.aqc01,
                  aqc02 LIKE  aqc_file.aqc02,
                  aqc03 LIKE  aqc_file.aqc03,
                  aqc05 LIKE  aqc_file.aqc05,
                  aqc04 LIKE  aqc_file.aqc04,
                  aqc06 LIKE  aqc_file.aqc06,
                  aqc07 LIKE  aqc_file.aqc07,
                  aqc08 LIKE  aqc_file.aqc08
             END RECORD
    DEFINE l_apb12   LIKE apb_file.apb12        #No.FUN-770093
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
       EXIT PROGRAM
    END IF
 
    LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
                " VALUES(?,?,?,?,?,?,?,?,?)"
    PREPARE insert_prep1 FROM g_sql
    IF STATUS THEN
       CALL cl_err('insert_prep1:',status,1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time    #FUN-B30211
       EXIT PROGRAM
    END IF
 
    CALL cl_del_data(l_table)
    CALL cl_del_data(l_table1)
 
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
    SELECT zz17 INTO g_len FROM zz_file WHERE zz01 = 'aapt900'
    IF g_len = 0 OR g_len IS NULL THEN
       LET g_len = 80
    END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
    LET l_sql="SELECT aqc01,aqc02,aqc03,aqc05,aqc04,aqc06,aqc07,aqc08",
               "  FROM aqc_file ",
               " WHERE aqc01='",g_aqa.aqa01,"'"
    PREPARE t900_p1a FROM l_sql
    DECLARE t900_coa CURSOR FOR t900_p1a
 
    LET g_sql="SELECT aqa01,aqa02,aqa03,aqa04,aqa05,'','','',",
              " '','','',aqb01,aqb02,aqb03,aqb04 ",
              " FROM aqa_file,aqb_file",
              " WHERE aqa01='",g_aqa.aqa01,"'",
              "   AND aqa01=aqb01 "
    PREPARE t900_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t900_co                         # SCROLL CURSOR
        SCROLL CURSOR FOR t900_p1
 
    FOREACH t900_co INTO sr.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
          END IF
       LET l_apa02 = NULL           #No.FUN-770093  修正CR日期顯示
       SELECT apa00,apa01,apa02,apa51,apa06,apa07
         INTO l_apa00,l_apa01,l_apa02,l_apa51,l_apa06,l_apa07
         FROM apa_file
        WHERE apa01=sr.aqb02
       LET sr.apa00=l_apa00
       LET sr.apa01=l_apa01
       LET sr.apa02=l_apa02
       LET sr.apa51=l_apa51
       LET sr.apa06=l_apa06
       LET sr.apa07=l_apa07
       EXECUTE insert_prep USING sr.aqa01,sr.aqa02,sr.aqa03,sr.aqa05,sr.apa00,
                                 sr.apa01,sr.apa02,sr.apa51,sr.apa06,sr.apa07,
                                 sr.aqb03,sr.aqb04,sr.aqb01,sr.aqb02
 
    END FOREACH
    FOREACH t900_coa INTO sr1.*
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,0)
               EXIT FOREACH
       END IF
       SELECT apb12 INTO l_apb12 FROM apb_file
          WHERE apb01=sr1.aqc02 AND apb02=sr1.aqc03
       EXECUTE insert_prep1 USING sr.aqa01,sr1.aqc02,sr1.aqc03,l_apb12,
                                  sr1.aqc05,sr1.aqc04,sr1.aqc06,sr1.aqc07,
                                  sr1.aqc08
    END FOREACH
 
    CLOSE t900_co
    ERROR ""
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog
    IF g_zz05 = 'Y' THEN
       CALL cl_wcchp(g_wc,'aqa01, aqa02, aqainpd, aqa04, aqaconf, aqauser, aqagrup, aqamodu,aqadate, aqaacti')
            RETURNING g_wc
       LET g_str=g_wc
    END IF
    LET g_str = g_str,";",g_azi05
    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED
    CALL cl_prt_cs3('aapt900','aapt900',l_sql,g_str)
END FUNCTION
 
FUNCTION t900_apa51_b()
DEFINE l_n   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_j   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_apa51 LIKE type_file.num5        # No.FUN-690028 SMALLINT
 
   LET g_cnt=0
   LET g_success='Y'
   SELECT UNIQUE apa51 FROM apa_file,aqb_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND (apa00='12' OR apa00='13')   #No.FUN-690080
   INTO TEMP tmpa;
   SELECT COUNT(*) INTO g_cnt FROM tmpa
 
   IF g_cnt>1 THEN
      CALL cl_err('','mfg-035',0)
      LET g_success='N'
   END IF
   DELETE FROM tmpa;
END FUNCTION
 
FUNCTION t900_apa51_b2()
DEFINE l_n   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_j   LIKE type_file.num5    #No.FUN-690028 SMALLINT
DEFINE l_apa51 LIKE apa_file.apa51
 
   LET g_cnt=0
   LET g_success='Y'
   SELECT UNIQUE apa51 FROM apa_file,aqc_file
    WHERE aqc01=g_aqa.aqa01
      AND apa01=aqc02
      AND apa00='11'
   INTO TEMP tmpb;
   SELECT COUNT(*) INTO g_cnt FROM tmpb
 
   IF g_cnt>1 THEN
      CALL cl_err('','mfg-036',0)
      LET g_success='N'
   END IF
   DELETE FROM tmpb;
END FUNCTION
 
FUNCTION t900_apa51_all()
DEFINE l_apa51 LIKE apa_file.apa51
 
   LET g_success='Y'
   #'12'的借方科目
   SELECT UNIQUE apa51 INTO g_apa51 FROM apa_file,aqb_file
    WHERE aqb01=g_aqa.aqa01
      AND apa01=aqb02
      AND (apa00='12' OR apa00='13')  #No.FUN-690080
   IF g_apa51 IS NULL THEN
      CALL cl_err('g_apa51 null','',0)
      LET g_apa51=' '
   END IF
 
   SELECT UNIQUE apa51 INTO l_apa51 FROM apa_file,aqc_file
    WHERE aqc01=g_aqa.aqa01
      AND apa01=aqc02
      AND apa00='11'
 
   IF l_apa51 IS NULL THEN
      CALL cl_err('l_apa51 null','',0)
      LET l_apa51=' '
   END IF
 
   IF g_apa51<>l_apa51 THEN
      CALL cl_err('','mfg-037',0)
      LET g_success='N'
   END IF
   LET g_apa51=''
   LET l_apa51=''
END FUNCTION
 
FUNCTION t900_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("aqa01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t900_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("aqa01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t900_comp_oox(p_apv03)
DEFINE l_net     LIKE apv_file.apv04
DEFINE p_apv03   LIKE apv_file.apv03
DEFINE l_apa00   LIKE apa_file.apa00
 
    LET l_net = 0
    IF g_apz.apz27 = 'Y' THEN
       SELECT SUM(oox10) INTO l_net FROM oox_file
        WHERE oox00 = 'AP' AND oox03 = p_apv03
       IF cl_null(l_net) THEN
          LET l_net = 0
       END IF
    END IF
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=p_apv03
    IF l_apa00 MATCHES '1*' THEN LET l_net = l_net * ( -1) END IF
 
    RETURN l_net
END FUNCTION
 
FUNCTION t900_gen_glcr(p_aqa,p_apy)
  DEFINE p_aqa     RECORD LIKE aqa_file.*
  DEFINE p_apy     RECORD LIKE apy_file.*
 
    IF cl_null(p_apy.apygslp) THEN
       CALL cl_err(p_aqa.aqa01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t900_g_gl(p_aqa.aqa01,'0')  #第一分錄
    IF g_aza.aza63 = 'Y' THEN
       CALL t900_g_gl(p_aqa.aqa01,'1') #產生第二分錄
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t900_carry_voucher()
  DEFINE l_apygslp    LIKE apy_file.apygslp
  DEFINE li_result    LIKE type_file.num5     #No.FUN-690028 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-690028 SMALLINT
  
    IF NOT cl_null(g_aqa.aqa05) OR g_aqa.aqa05 IS NOT NULL THEN
       CALL cl_err(g_aqa.aqa05,'aap-618',1)
       RETURN
    END IF   
 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_aqa.aqa01) RETURNING g_t1
    SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
    IF g_apy.apydmy3 = 'N' THEN RETURN END IF
    IF g_apy.apyglcr = 'Y' OR (g_apy.apyglcr ='N' AND NOT cl_null(g_apy.apygslp)) THEN #No.FUN-860107
       LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
      #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",   #FUN-A50102
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                   "  WHERE aba00 = '",g_apz.apz02b,"'",
                   "    AND aba01 = '",g_aqa.aqa05,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
       CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre2 FROM l_sql
       DECLARE aba_cs2 CURSOR FOR aba_pre2
       OPEN aba_cs2
       FETCH aba_cs2 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_aqa.aqa05,'aap-991',1)
          RETURN
       END IF
 
       LET l_apygslp = g_apy.apygslp
    ELSE
    	 CALL cl_err('','aap-936',1)    #No.FUN-860107 
       RETURN
 
    END IF
    IF cl_null(l_apygslp) OR (cl_null(g_apy.apygslp1) AND g_aza.aza63 = 'Y') THEN  #No.FUN-680029
       CALL cl_err(g_aqa.aqa01,'axr-070',1)
       RETURN
    END IF
   #CALL s_showmsg_init()                                            #MOD-C50093 add #MOD-C50243 mark
    LET g_wc_gl = 'npp01 = "',g_aqa.aqa01,'" AND npp011 = 1'
    LET g_str="aapp400 '",g_wc_gl CLIPPED,"' '",g_aqa.aqauser,"' '",g_aqa.aqauser,"' '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",l_apygslp,"' '",g_aqa.aqa02,"' 'Y' '1' 'Y' '",g_apz.apz02c,"' '",g_apy.apygslp1,"' 'Y'"      #MOD-7B0159  #No.MOD-860075 #MOD-B10041 add 'Y'
    CALL cl_cmdrun_wait(g_str)
    SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
     WHERE aqa01 = g_aqa.aqa01
   #--------------------------MOD-C50093---------------------------(S)
    CALL s_errmsg('',g_aqa.aqa05,'','','')
    CALL s_showmsg()
   #--------------------------MOD-C50093---------------------------(E)
    DISPLAY BY NAME g_aqa.aqa05
    
END FUNCTION
 
FUNCTION t900_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(1000)
  DEFINE l_dbs      STRING
    
    IF cl_null(g_aqa.aqa05) OR g_aqa.aqa05 IS NULL THEN
       CALL cl_err(g_aqa.aqa05,'aap-619',1)
       RETURN
    END IF   
    
    IF NOT cl_confirm('aap-988') THEN RETURN END IF 
 
    CALL s_get_doc_no(g_aqa.aqa01) RETURNING g_t1
    SELECT * INTO g_apy.* FROM apy_file WHERE apyslip=g_t1
    IF g_apy.apydmy3 = 'N' THEN RETURN END IF   #TQC-7B0051
    IF g_apy.apyglcr = 'N' AND cl_null(g_apy.apygslp)THEN #No.FUN-860107
    	 CALL cl_err('','aap-936',1)    #No.FUN-860107
       RETURN
    END IF
 
    LET g_plant_new=g_apz.apz02p CALL s_getdbs() LET l_dbs=g_dbs_new
   #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",   #FUN-A50102
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'),   #FUN-A50102
                "  WHERE aba00 = '",g_apz.apz02b,"'",
                "    AND aba01 = '",g_aqa.aqa05,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_aqa.aqa05,'axr-071',1)
       RETURN
    END IF
    LET g_str="aapp409 '",g_apz.apz02p,"' '",g_apz.apz02b,"' '",g_aqa.aqa05,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT aqa05 INTO g_aqa.aqa05 FROM aqa_file
     WHERE aqa01 = g_aqa.aqa01
    DISPLAY BY NAME g_aqa.aqa05
END FUNCTION

FUNCTION t900_aqc06_aqc08()
   IF g_tot1 IS NULL THEN LET g_tot1=0 END IF
   IF g_tot2 IS NULL THEN LET g_tot2=0 END IF
   IF g_tot3 IS NULL THEN LET g_tot3=0 END IF
   SELECT SUM(aqc06) INTO g_tot1 FROM aqc_file where aqc01=g_aqa.aqa01
   SELECT SUM(aqc08) INTO g_tot2 FROM aqc_file where aqc01=g_aqa.aqa01
   LET g_tot3=g_tot2-g_tot1
   DISPLAY g_tot1   TO FORMONLY.tot1
   DISPLAY g_tot2   TO FORMONLY.tot2
   DISPLAY g_tot3   TO FORMONLY.tot3
END FUNCTION
#No.FUN-9C0072 精簡程式碼


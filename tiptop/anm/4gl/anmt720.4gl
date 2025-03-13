# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: anmt720.4gl
# Descriptions...: 中長期貸款申請維護
# Date & Author..: 96/11/15 By paul
# Modify.........: 03/01/09 By Kitty加nng52-nng61
# Modify.........: 03/05/27 By Kammy 1.傳票拋轉移到 anmp400
#                  (No.7277)         2.傳票還原移到 anmp409
#                                    3.注意:npp00原 '3' 改 '17'以利區分
# Modify.........: No.7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No.8586 03/10/29 By Kitty 自動產生單身未給nnh07
# Modify.........: No.6721 03/12/10 By Kitty 增加開帳否與最後還息日欄位(nng25,nng26)
# Modify.........: No.8609 03/12/17 By Kitty 增加判斷若已有暫估資料不可取消確認
# Modify.........: No.8935 04/01/05 By Kitty 增加判斷nnn07='N'則不insert nme_fil
# Modify.........: No.B068 04/05/18 By Kitty row:2291應改為 IF NOT cl_null 才對
#                  若nng55,57,59未判斷null值,造成ins_nme金額欄nme04 err
# Modify.........: No.9712 04/07/01 By Kitty bug no:B068 null判斷要在AFTER FIELD也判斷一次
# Modify.........: MOD-470468 04/07/21 By Mandy 1.請將相關金額欄位default為零(不能為null),否則insert到nme_file會無金額 如:nng55,nng57,nng59,nng61
# Modify.........:                              2.是否自動產生單身,若選是則程式會當出
# Modify.........: MOD-470470 04/07/21 By Mandy 輸入完合約單號後請帶出信貸銀行
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0248 04/10/22 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4B0052 04/11/25 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/15 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-510039 05/01/21 By Kitty nmf05/nmf06 取值邏輯應同 anmp500/anmt750
# Modify.........: No.FUN-550037 05/05/13 By saki  欄位comment顯示
# Modify.........: NO.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify.........: NO.FUN-560002 05/06/02 By vivien 單據編號修改
# Modify.........: NO.FUN-560095 05/06/20 By ching 2.0功能修改
# Modify.........: No.MOD-580325 05/08/29 By day  將程序中寫死為中文的錯誤信息改由p_ze維護
# Modify.........: No.FUN-5B0110 05/11/23 By kim  合約編號開窗要加秀銀行簡稱,q_nnp->q_nnp01
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: NO.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.FUN-640021 06/04/12 By Smapmin 存入銀行異動碼開窗有誤
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670060 06/07/28 By cl    新增"直接拋轉總帳"功能
# Modify.........: No.TQC-680080 06/08/22 By Sarah p_flow流程訊息通知功能,加上OTHERWISE判斷漏改
# Modify.........: No.FUN-680088 06/08/28 By Elva 新增多帳套功能
# Modify.........: No.FUN-680107 06/09/18 By Hellen 欄位類型修改
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6B0011 06/11/03 By Smapmin 增加列印功能串anmr723
# Modify.........: No.FUN-6B0030 06/11/14 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-710024 07/02/05 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-740240 07/04/22 By Smapmin 已失效合約不可登打
# Modify.........: No.CHI-740030 07/04/22 By Smapmin 修改錯誤訊息
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.FUN-740229 07/04/28 By bnlent 審核以后根據情況對“應付票據還原”進行控管
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780005 07/08/03 By Smapmin 展單身時,應該依付款方式加月數
# Modify.........: No.FUN-780080 07/08/30 By Smapmin 增加"資產抵押融資貸款維護"等功能
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.TQC-790077 07/09/19 By Carrier 科目層級加入非負判斷
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810167 08/01/25 By Smapmin q_nnp01改為Hard Code
# Modify.........: No.MOD-840250 08/04/21 By Smapmin 增加信貸額度檢查
#                                                    輸入完長貸種類後,自動帶出利率
#                                                    拋轉應付票據後,沒有回寫單身付款銀行
# Modify.........: No.MOD-840248 08/04/28 By Smapmin 計算本票折價,過濾有效合約
# Modify.........: No.FUN-850038 08/05/12 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.MOD-850152 08/05/20 By Smapmin 單身無法新增
# Modify.........: No.CHI-860039 08/07/04 By Sarah 當nms65,nms651為空時,使用nng24再抓取nnn04,nnn041
# Modify.........: No.FUN-870057 08/07/14 By sherry  加入預設簿號欄位，并帶入anmt100 簿號欄位
# Modify.........: No.MOD-8A0148 08/10/16 By Sarah 當nnn06='2','3'時才需要計算nng55
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-920196 09/02/16 By Smapmin 修改錯誤訊息
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-940161 09/04/11 By Sarah 單身新增一筆資料用enter的方式移到下一筆再往上移,會出現-239錯誤訊息
# Modify.........: No.FUN-940036 09/04/06 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.TQC-960039 09/06/05 By xiaofeizhu 修改新增時“長貸種類”欄位的開窗
# Modify.........: No.MOD-960067 09/06/09 By baofei 4fd上沒有cn3欄位
# Modify.........: No.TQC-960040 09/06/09 By xiaofeizhu 給“期數”賦初值
# Modify.........: No.TQC-960043 09/06/10 By xiaofeizhu Mark"CLOSE WINDOW t720_g_np_w"
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980077 09/08/17 By liuxqa 非負控管。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980025 09/09/21 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No:MOD-9B0184 09/11/26 By Sarah 若已有還款資料則不可取消確認 
# Modify.........: No.TQC-9B0172 09/12/04 By liuxqa 直接按分录产生，但分录二一直没办法录入。
# Modify.........: No.FUN-9C0073 10/01/15 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->ANM
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.MOD-A40014 10/08/31 by sabrina 產生銀行異動應串nng24而非nne06
# Modify.........: No.MOD-A20041 10/10/05 By sabrina FUNCTION t720_show()的DISPLAY BY NAME增加g_nng.nng25
# Modify.........: No:MOD-AB0230 10/11/26 By Dido 檢核 nno09 是否為 'N'  
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-AA0087 11/01/28 By Mengxw 異動碼類型設定的改善 
# Modify.........: No:FUN-B20073 11/02/24 By lilingyu 科目查詢自動過濾-hcode
# Modify.........: No:MOD-B30357 11/03/16 By lixia 寫入nmd_file時,給予nmd40 = '1'
# Modify.........: No:MOD-B30354 11/03/17 By lixia nng082 nng102增加管控
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No:CHI-B30004 11/05/24 By Dido 依據融資種類類別(nnn06)預設 nng_c1 
# Modify.........: No.FUN-B50063 11/05/25 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60086 11/06/16 By zhangweib CONSTURCT時加上資料建立者和資料建立部門
# Modify.........: No.TQC-B60108 11/06/16 By yinhy 更改時，會計科目不自動帶出
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  
# Modify.........: No.MOD-B90165 11/09/21 By Polly t720_show() 中取消s_check_no檢核

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C30451 12/03/12 by lujh 若異動期數(nng11)後,應需重新計算單身,才可確認
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C30085 12/07/06 By lixiang 改CR報表串GR報表
# Modify.........: No.MOD-C70179 12/07/18 By Polly 確認段增加控卡1.分錄和金額不同2.單頭單身金額不同
# Modify.........: No.FUN-C80018 12/08/06 By minpp 大陸版時如果anmi030沒有維護單身時，anmt100單頭的簿號和支票號碼可以手動輸入
# Modify.........: No.TQC-C80198 12/09/03 By lujh q_nnp01增加了一个参数,这个要做相应的修改
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.MOD-CA0017 12/10/02 By Polly nng25為Y時，nng26才可做維護
# Modify.........: No.MOD-CA0174 12/10/30 By Polly 調整AFTER FIELD nng05欄位值重新抓取條件
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.MOD-D10187 13/01/23 By Polly 取消anm1017的控卡
# Modify.........: No.FUN-D20035 13/02/19 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 在調用s_def_npq前npq04=NULL
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-C60006 13/05/08 By qirl 系統作廢/取消作廢需要及時更新修改者以及修改時間欄位
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nme   RECORD LIKE nme_file.*,
    g_nme_o RECORD LIKE nme_file.*,
    g_nng   RECORD LIKE nng_file.*,
    g_nng_o RECORD LIKE nng_file.*,
    g_nng_t RECORD LIKE nng_file.*,
    b_nnh   RECORD LIKE nnh_file.*,
    g_nnn06 LIKE nnn_file.nnn06,
    g_nna03 LIKE nna_file.nna03,    #No.FUN-870057
    g_nna06 LIKE nna_file.nna06,    #No.FUN-870057 
    g_book_no LIKE nmd_file.nmd31,    #No.FUN-870057 
    g_alg   RECORD LIKE alg_file.*,
    g_nma   RECORD LIKE nma_file.*,
    g_nms   RECORD LIKE nms_file.*,
    g_npp   RECORD LIKE npp_file.*,
    g_npq   RECORD LIKE npq_file.*,
    g_nnh   DYNAMIC ARRAY OF RECORD
            nnh02    LIKE nnh_file.nnh02,
            nnh03    LIKE nnh_file.nnh03,
            nnh04f   LIKE nnh_file.nnh04f,
            nnh04    LIKE nnh_file.nnh04,
            nnh05    LIKE nnh_file.nnh05,
            nnh06    LIKE nnh_file.nnh06,
            nmd02    LIKE nmd_file.nmd02,
            nmd12    LIKE nmd_file.nmd12,
            nnh07    LIKE nnh_file.nnh07        #add
            ,nnhud01 LIKE nnh_file.nnhud01,
            nnhud02 LIKE nnh_file.nnhud02,
            nnhud03 LIKE nnh_file.nnhud03,
            nnhud04 LIKE nnh_file.nnhud04,
            nnhud05 LIKE nnh_file.nnhud05,
            nnhud06 LIKE nnh_file.nnhud06,
            nnhud07 LIKE nnh_file.nnhud07,
            nnhud08 LIKE nnh_file.nnhud08,
            nnhud09 LIKE nnh_file.nnhud09,
            nnhud10 LIKE nnh_file.nnhud10,
            nnhud11 LIKE nnh_file.nnhud11,
            nnhud12 LIKE nnh_file.nnhud12,
            nnhud13 LIKE nnh_file.nnhud13,
            nnhud14 LIKE nnh_file.nnhud14,
            nnhud15 LIKE nnh_file.nnhud15
           END RECORD,
    g_nnh_t RECORD
            nnh02    LIKE nnh_file.nnh02,
            nnh03    LIKE nnh_file.nnh03,
            nnh04f   LIKE nnh_file.nnh04f,
            nnh04    LIKE nnh_file.nnh04,
            nnh05    LIKE nnh_file.nnh05,
            nnh06    LIKE nnh_file.nnh06,
            nmd02    LIKE nmd_file.nmd02,
            nmd12    LIKE nmd_file.nmd12,
            nnh07    LIKE nnh_file.nnh07        #add
            ,nnhud01 LIKE nnh_file.nnhud01,
            nnhud02 LIKE nnh_file.nnhud02,
            nnhud03 LIKE nnh_file.nnhud03,
            nnhud04 LIKE nnh_file.nnhud04,
            nnhud05 LIKE nnh_file.nnhud05,
            nnhud06 LIKE nnh_file.nnhud06,
            nnhud07 LIKE nnh_file.nnhud07,
            nnhud08 LIKE nnh_file.nnhud08,
            nnhud09 LIKE nnh_file.nnhud09,
            nnhud10 LIKE nnh_file.nnhud10,
            nnhud11 LIKE nnh_file.nnhud11,
            nnhud12 LIKE nnh_file.nnhud12,
            nnhud13 LIKE nnh_file.nnhud13,
            nnhud14 LIKE nnh_file.nnhud14,
            nnhud15 LIKE nnh_file.nnhud15
           END RECORD,
    g_dbs_gl            LIKE type_file.chr21,   #No.FUN-680107 VARCHAR(21)
    g_plant_gl          LIKE type_file.chr10,   #No.FUN-980020
    g_cnn_sw            LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01) #nng22 被修改 update cnn_file
    g_nma_sw            LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01) #nng 20,nng22 被修改update nma_file
    m_chr               LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
    g_dec6              LIKE type_file.num20_6, #No.FUN-680107 dec(15,6)
    g_wc                string,                 #No.FUN-580092 HCN
    g_wc1,g_sql         string,                 #No.FUN-580092 HCN
    g_rec_b             LIKE type_file.num5,    #單身筆數  #No.FUN-680107 SMALLINT
    g_t1                LIKE oay_file.oayslip,  #No.FUN-550057  #No.FUN-680107 VARCHAR(5)
    l_ac                LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
    gl_no_b,gl_no_e     LIKE type_file.chr20    #No.FUN-680107 VARCHAR(16) #No.FUN-550057
DEFINE g_flag        LIKE type_file.chr1    #No.FUN-730032
DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-730032
DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-730032
DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-730032
DEFINE p_row,p_col      LIKE type_file.num5     #No.FUN-680107 SMALLINT
#------for ora修改-------------------
DEFINE g_system         LIKE type_file.chr2     #No.FUN-680107 VARCHAR(2)
DEFINE g_zero           LIKE type_file.num20_6  #No.FUN-680107 decimal(15,3)
DEFINE g_zero1          LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_N              LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_y              LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
#------for ora修改-------------------
 
DEFINE g_argv1           LIKE nng_file.nng01    #No.FUN-680107 VARCHAR(16) #單號 #TQC-630074
DEFINE g_argv2           STRING                 #指定執行的功能 #TQC-630074
 
DEFINE g_forupd_sql      STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5  #No.FUN-680107 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE   g_void          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_str           STRING                 #No.FUN-670060
DEFINE   g_wc_gl         STRING                 #No.FUN-670060
DEFINE   bal,amty,amtu,u_amty,u_amtu  LIKE nng_file.nng20   #MOD-840250
DEFINE   g_npq25         LIKE npq_file.npq25    #No.FUN-9A0036
DEFINE   g_aag44         LIKE aag_file.aag44    #FUN-D40118 add
 
MAIN
 
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
 
   LET g_argv1=ARG_VAL(1)           #TQC-630074 
   LET g_argv2=ARG_VAL(2)           #TQC-630074
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
   LET  g_wc1=" 1=1 "
   SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
   LET g_plant_gl = g_nmz.nmz02p             #FUN-980020
   LET g_plant_new = g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new
 
   LET g_forupd_sql = "SELECT * FROM nng_file WHERE nng01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t720_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   LET p_row = 1 LET p_col = 2
   OPEN WINDOW t720_w AT p_row,p_col
     WITH FORM "anm/42f/anmt720"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    IF g_aza.aza63 = 'N' THEN
       CALL cl_set_comp_visible("page05",FALSE) 
    END IF
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t720_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t720_a()
            END IF
         OTHERWISE
            CALL t720_q()
      END CASE
   END IF
 
   CALL t720_menu()
   CLOSE WINDOW t720_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t720_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_nnh.clear()
   INITIALIZE g_nng.* TO NULL #FUN-560095
   
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")       #No.FUN-6B0030
 
   INITIALIZE g_nng.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON
          nng01,nng25,nng15,nng02,nng03,nng52,nng04,nng24,nng05,nng051, #No.6721
          nng14,nng16,nng06,nng07,nngconf,nngglno,nng26,
          nng081,nng082,nng101,nng102,nng18,nng19,
          nngex2,nng20,nng21,nng22,nng23,nng12,nng09,nng13,
          nng11,nng17,nng54,nng53,nng55,  #No.6721
          nng57,nng59,nng61,nng_d1,nng_d2,nng_d11,nng_d21, #FUN-680088
          nnguser,nnggrup,nngmodu,nngdate
          ,nngud01,nngud02,nngud03,nngud04,nngud05,
          nngud06,nngud07,nngud08,nngud09,nngud10,
          nngud11,nngud12,nngud13,nngud14,nngud15
         ,nngoriu,nngorig    #TQC-B60086    Add
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()                     #No.FUN-580031
      
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nng01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nng"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng01
                  NEXT FIELD nng01
               WHEN INFIELD(nng04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_alg"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng04
                  NEXT FIELD nng04
               WHEN INFIELD(nng54)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng54
                  NEXT FIELD nng54
               WHEN INFIELD(nng05)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng05
                  NEXT FIELD nng05
               WHEN INFIELD(nng52) #合約號碼
                  CALL q_nnp01(1,1,g_nng.nng52,g_nng.nng03)             #TQC-C80198  add  g_nng.nng03
                       RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng52
               WHEN INFIELD(nng051) #銀行代號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmc"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng051
                  NEXT FIELD nng051
               WHEN INFIELD(nng17) #變動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng17
                  NEXT FIELD nng17
               WHEN INFIELD(nng18)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng18
                  NEXT FIELD nng18
               WHEN INFIELD(nng24) #長貸種類
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nnn"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nng24  #No.FUN-680088
                  NEXT FIELD nng24
              WHEN INFIELD(nng_d1)         # 總帳會計科目查詢
                    CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #No.FUN-980020
                    CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nng.nng_d1,'23',g_bookno1)     #No.FUN-980025
                    RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nng_d1
                    NEXT FIELD nng_d1
              WHEN INFIELD(nng_d2)         # 總帳會計科目查詢
                    CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                    CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nng.nng_d2,'23',g_bookno1)     #No.FUN-980025
                    RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nng_d2
                    NEXT FIELD nng_d2
              WHEN INFIELD(nng_d11)         # 總帳會計科目查詢
                    CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                    CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nng.nng_d11,'23',g_bookno2)     #No.FUN-980025 
                    RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nng_d11
                    NEXT FIELD nng_d11
              WHEN INFIELD(nng_d21)         # 總帳會計科目查詢
                    CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                    CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nng.nng_d21,'23',g_bookno2)     #No.FUN-980025 
                    RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO nng_d21
                    NEXT FIELD nng_d21
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
   ELSE
      LET g_wc =" nng01 = '",g_argv1,"'"    #No.TQC-630074 
   END IF
 
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nnguser', 'nnggrup')
     
   IF cl_null(g_argv1) THEN
     CONSTRUCT g_wc1 ON nnh02,nnh03,nnh04f,nnh04,nnh05,nnh06,nnh07
                        ,nnhud01,nnhud02,nnhud03,nnhud04,nnhud05,
                        nnhud06,nnhud07,nnhud08,nnhud09,nnhud10,
                        nnhud11,nnhud12,nnhud13,nnhud14,nnhud15
                   FROM s_nnh[1].nnh02,s_nnh[1].nnh03,
                        s_nnh[1].nnh04f,s_nnh[1].nnh04,
                        s_nnh[1].nnh05,s_nnh[1].nnh06,s_nnh[1].nnh07
                        ,s_nnh[1].nnhud01,s_nnh[1].nnhud02,s_nnh[1].nnhud03,s_nnh[1].nnhud04,s_nnh[1].nnhud05,
                        s_nnh[1].nnhud06,s_nnh[1].nnhud07,s_nnh[1].nnhud08,s_nnh[1].nnhud09,s_nnh[1].nnhud10,
                        s_nnh[1].nnhud11,s_nnh[1].nnhud12,s_nnh[1].nnhud13,s_nnh[1].nnhud14,s_nnh[1].nnhud15
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
     IF INT_FLAG THEN RETURN END IF
   ELSE
     LET g_wc1=" 1=1 "
   END IF
 
   IF g_wc1=" 1=1 " THEN
      LET g_sql="SELECT nng01 FROM nng_file ", # 組合出 SQL 指令
                " WHERE ",g_wc CLIPPED, " ORDER BY nng01"
   ELSE
      LET g_sql="SELECT UNIQUE nng_file.nng01 ",
                "  FROM nng_file,nnh_file ", # 組合出 SQL 指令
                " WHERE nng01=nnh01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED,
                " ORDER BY nng01"
   END IF
   PREPARE t720_pr FROM g_sql           # RUNTIME 編譯
   DECLARE t720_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t720_pr
 
   IF g_wc1=" 1=1 " THEN
      LET g_sql="SELECT COUNT(*) FROM nng_file ",
                " WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT nng01) FROM nng_file,nnh_file ",
                " WHERE nng01=nnh01 AND ",g_wc CLIPPED," AND ",g_wc1 CLIPPED
   END IF
   PREPARE t720_precount FROM g_sql                           # row的個數
   DECLARE t720_count CURSOR FOR t720_precount
 
END FUNCTION
 
FUNCTION t720_menu()
   DEFINE  l_cmd,l_wc   STRING   #FUN-6B0011
 
   WHILE TRUE
      CALL t720_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t720_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t720_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t720_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t720_u()
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               LET l_wc = 'nng01="',g_nng.nng01,'"'           # "新增"則印單張
              #LET l_cmd =  "anmr723 ",g_today," '' '",g_lang,"' 'Y' '' '' "," '",l_wc CLIPPED,"'" #FUN-C30085
               LET l_cmd =  "anmg723 ",g_today," '' '",g_lang,"' 'Y' '' '' "," '",l_wc CLIPPED,"'" #FUN-C30085 
               CALL cl_cmdrun(l_cmd)
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t720_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "undo_np"
                  CALL t720_d_np()   #No:8321
         WHEN "gen_n_p"
            CALL t720_g_np()
         WHEN "gen_entry_sheet"
            CALL t720_g_gl(g_nng.nng01,'0')
            IF g_aza.aza63 = 'Y'  THEN                        #TQC-9B0172 mod
               CALL t720_g_gl(g_nng.nng01,'1')
            END IF
         WHEN "maintain_entry_sheet"
            CALL s_fsgl('NM',17,g_nng.nng01,0,g_nmz.nmz02b,0,g_nng.nngconf,'0',g_nmz.nmz02p)   #FUN-680088
            CALL t720_npp02('0')  #FUN-680088
         WHEN "maintain_entry_sheet2"
            CALL s_fsgl('NM',17,g_nng.nng01,0,g_nmz.nmz02c,0,g_nng.nngconf,'1',g_nmz.nmz02p) 
            CALL t720_npp02('1')  
         WHEN "memo"
            LET g_msg="anmt700 '",g_nng.nng01,"' '2' "
            CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t720_firm1()
               IF g_nng.nngconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nng.nngconf,"","","",g_void,"")
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t720_firm2()
               IF g_nng.nngconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nng.nngconf,"","","",g_void,"")
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t720_x() #FUN-D20035 mark
               CALL t720_x(1) #FUN-D20035 add
               IF g_nng.nngconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nng.nngconf,"","","",g_void,"")
            END IF
#FUN-D20035 add str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t720_x(2)
               IF g_nng.nngconf = 'X' THEN
                  LET g_void = 'Y'
               ELSE
                  LET g_void = 'N'
               END IF
               CALL cl_set_field_pic(g_nng.nngconf,"","","",g_void,"")
            END IF
#FUN-D20035 add end 
         WHEN "cr_quota"
              CALL s_credit2('Y',g_nng.nng04,g_nng.nng52,g_nng.nng24)   
                           RETURNING amty,amtu,u_amty,u_amtu,bal
 
         WHEN "secur_paper_fin_lone"
             IF g_nng.nngconf <> 'X' THEN
                LET g_msg="anmt702 '",g_nng.nng01,"'"
                CALL cl_cmdrun_wait(g_msg)  
             END IF
        
         WHEN "collateral_fin_loan"
             IF g_nng.nngconf <> 'X' THEN
                LET g_msg="anmt703 '",g_nng.nng01,"'"
                CALL cl_cmdrun_wait(g_msg) 
             END IF
        
         WHEN "secur_bill_fin_lone"
             IF g_nng.nngconf <> 'X' THEN
                LET g_msg="anmt704 '",g_nng.nng01,"'"
                CALL cl_cmdrun_wait(g_msg)
             END IF
 
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnh),'','')
            END IF
         WHEN "carry_voucher"                                                                                                       
            IF cl_chk_act_auth() THEN
               IF g_nng.nngconf = 'Y' THEN                                                                                             
                  CALL t720_carry_voucher()                                                                                            
               ELSE 
                  CALL cl_err('','atm-402',1)
               END IF                                                                                                                  
            END IF                                                                                                                  
         WHEN "undo_carry_voucher"                                                                                                  
            IF cl_chk_act_auth() THEN
               IF g_nng.nngconf = 'Y' THEN                                                                                             
                  CALL t720_undo_carry_voucher()                                                                                       
               ELSE 
                  CALL cl_err('','atm-403',1)
               END IF                                                                                                                  
            END IF                                                                                                                  
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nng.nng01 IS NOT NULL THEN
                 LET g_doc.column1 = "nng01"
                 LET g_doc.value1 = g_nng.nng01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
   CLOSE t720_cs
END FUNCTION
 
FUNCTION t720_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t720_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN 
      LET INT_FLAG = 0 
      LET g_nng.nng01 = NULL   #MOD-660086 add
      RETURN 
   END IF
      OPEN t720_count
      FETCH t720_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t720_cs                               # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nng.nng01,SQLCA.sqlcode,0)
      INITIALIZE g_nng.* TO NULL
   ELSE
      CALL t720_fetch('F')                    # 讀出TEMP第一筆並顯示
   END IF
END FUNCTION
 
FUNCTION t720_fetch(p_flnng)
   DEFINE
       p_flnng         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flnng
      WHEN 'N' FETCH NEXT     t720_cs INTO g_nng.nng01
      WHEN 'P' FETCH PREVIOUS t720_cs INTO g_nng.nng01
      WHEN 'F' FETCH FIRST    t720_cs INTO g_nng.nng01
      WHEN 'L' FETCH LAST     t720_cs INTO g_nng.nng01
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
            FETCH ABSOLUTE g_jump t720_cs INTO g_nng.nng01
            LET mi_no_ask = FALSE
   END CASE
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nng.nng01,SQLCA.sqlcode,0)
      INITIALIZE g_nng.* TO NULL    #No.FUN-6B0079  add
      RETURN
   ELSE
      CASE p_flnng
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
   SELECT * INTO g_nng.* FROM nng_file            # 重讀DB,因TEMP有不被更新特性
    WHERE nng01 = g_nng.nng01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nng_file",g_nng.nng01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
      INITIALIZE g_nng.* TO NULL    #No.FUN-6B0079  add
   ELSE
      LET g_data_owner = g_nng.nnguser     #No.FUN-4C0063
      LET g_data_group = g_nng.nnggrup     #No.FUN-4C0063
      CALL t720_show()                     # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t720_show()
 DEFINE l_aag02    LIKE aag_file.aag02
 DEFINE li_result  LIKE type_file.num5     #No.FUN-560002  #No.FUN-680107 SMALLINT
 
   DISPLAY BY NAME g_nng.nngoriu,g_nng.nngorig,
        g_nng.nng01,g_nng.nng02,g_nng.nng03,g_nng.nng04,g_nng.nng05, #No.6721
        g_nng.nng051,g_nng.nng06,g_nng.nng081,g_nng.nng082,
        g_nng.nng101,g_nng.nng102,g_nng.nng18,g_nng.nng19,
        g_nng.nngex2,g_nng.nng20,g_nng.nng21,g_nng.nng22,
        g_nng.nng23,g_nng.nng15,g_nng.nng12,g_nng.nng11,g_nng.nng09,
        g_nng.nng13,g_nng.nng14,g_nng.nng16,g_nng.nng17,g_nng.nng07,
        g_nng.nngglno,g_nng.nng24,g_nng.nng52,g_nng.nng53,g_nng.nng26, #No.6721
        g_nng.nng54,g_nng.nng55,g_nng.nng56,g_nng.nng57,g_nng.nng58,
        g_nng.nng59,g_nng.nng60,g_nng.nng61,g_nng.nngconf,
        g_nng.nnguser,g_nng.nnggrup,g_nng.nngmodu,g_nng.nngdate,
        g_nng.nng_d1,g_nng.nng_d2,
        g_nng.nng_c1,g_nng.nng_c2,
        g_nng.nng_d11,g_nng.nng_d21,
        g_nng.nng_c11,g_nng.nng_c21
        ,g_nng.nngud01,g_nng.nngud02,g_nng.nngud03,g_nng.nngud04,
        g_nng.nngud05,g_nng.nngud06,g_nng.nngud07,g_nng.nngud08,
        g_nng.nngud09,g_nng.nngud10,g_nng.nngud11,g_nng.nngud12,
        g_nng.nngud13,g_nng.nngud14,g_nng.nngud15,g_nng.nng25          #MOD-A20041 add g_nng.nng25 
   IF STATUS THEN CALL cl_err('_show()',STATUS,1) END IF
   INITIALIZE g_alg.* TO NULL
   CALL t720_nng24('d')
   SELECT * INTO g_alg.* FROM alg_file WHERE alg01 = g_nng.nng04
   DISPLAY BY NAME g_alg.alg02
   INITIALIZE g_nma.* TO NULL
   SELECT * INTO g_nma.* FROM nma_file WHERE nma01 = g_nng.nng05
   DISPLAY BY NAME g_nma.nma02
   CALL t720_b_fill(g_wc1)
   CALL t720_b_tot()
    LET g_t1 = s_get_doc_no(g_nng.nng01)       #No.FUN-550057
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = g_t1
  #CALL s_check_no("anm",g_t1,"","5","","","") #MOD-B90165 mark
  #     RETURNING li_result,g_t1               #MOD-B90165 mark
   CALL s_get_bookno(YEAR(g_nng.nng02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
   END IF
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nng.nng_d1
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d1 LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nng.nng_d2
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d2 LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nng.nng_c1
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_c1 LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nng.nng_c2
                                             AND aag00 = g_bookno1       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_c2 LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nng.nng_d11
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d11 LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nng.nng_d21
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_d21 LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nng.nng_c11
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_c11 LET l_aag02=NULL
   SELECT aag02 INTO l_aag02 FROM aag_file WHERE aag01=g_nng.nng_c21
                                             AND aag00 = g_bookno2       #No.FUN-730032
   DISPLAY l_aag02 TO aag02_c21 LET l_aag02=NULL
   IF g_nng.nngconf = 'X' THEN
      LET g_void = 'Y'
   ELSE
      LET g_void = 'N'
   END IF
   CALL cl_set_field_pic(g_nng.nngconf,"","","",g_void,"")
    CALL cl_show_fld_cont()                 #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t720_a()                           #輸入
  DEFINE l_cmd       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
  DEFINE li_result   LIKE type_file.num5    #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢墓欄位內容
   CALL g_nnh.clear()
   INITIALIZE g_nng.* TO NULL
   LET g_nng_t.* = g_nng.*
   LET g_nng.nng02   = TODAY
   LET g_nng.nng19   = 1
   LET g_nng.nng20   = 0
   LET g_nng.nng21   = 0
   LET g_nng.nng22   = 0
   LET g_nng.nng23   = 0
   LET g_nng.nng15   = 1
   LET g_nng.nng12   = 1
   LET g_nng.nng11   = 0
   LET g_nng.nng09   = 0
   LET g_nng.nng13   = 1
   LET g_nng.nng14   = 1
   LET g_nng.nng16   = 1
   LET g_nng.nngex2  = 1
   LET g_nng.nng25   = 'N'                  #No:6721
   LET g_nng.nngconf = 'N'
   LET g_nng.nnguser = g_user
   LET g_nng.nngoriu = g_user #FUN-980030
   LET g_nng.nngorig = g_grup #FUN-980030
   LET g_nng.nnggrup = g_grup               #使用者所屬群
   LET g_nng.nngdate = g_today
   LET g_nng.nng55   = 0 #MOD-470468
   LET g_nng.nng57   = 0 #MOD-470468
   LET g_nng.nng59   = 0 #MOD-470468
   LET g_nng.nng61   = 0 #MOD-470468
   LET g_nng.nnglegal= g_legal
 
   CALL cl_opmsg('a')
   WHILE TRUE
      CALL t720_i('a')
      IF INT_FLAG THEN                   #使用者不玩了
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         INITIALIZE g_nng.* TO NULL EXIT WHILE
      END IF
      IF cl_null(g_nng.nng01) THEN                # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK
        CALL s_auto_assign_no("anm",g_nng.nng01,g_nng.nng02,"5","nng_file","nng01","","","")
             RETURNING li_result,g_nng.nng01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_nng.nng01
      INSERT INTO nng_file VALUES (g_nng.*)
      IF SQLCA.sqlcode THEN
         ROLLBACK WORK
         CALL cl_err3("ins","nng_file",g_nng.nng01,"",STATUS,"","ins nng:",1)  #No.FUN-660148
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_nng.nng01,'I')
      END IF
      LET g_nng_t.* = g_nng.*                # 保存上筆資料
      SELECT nng01 INTO g_nng.nng01 FROM nng_file
       WHERE nng01 = g_nng.nng01
      CALL g_nnh.clear()
      LET g_rec_b=0
      CALL t720_b()
      LET g_t1 = s_get_doc_no(g_nng.nng01)       #No.FUN-550057
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = g_t1
      IF g_nmy.nmydmy1 = 'Y' THEN CALL t720_firm1() END IF
      MESSAGE ""
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t720_i(p_cmd)
    DEFINE p_cmd        LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_aag02      LIKE aag_file.aag02    #No.FUN-680107 VARCHAR(30)
    DEFINE l_n          LIKE type_file.num5    #No.FUN-680107 SMALLINT
    DEFINE l_tot        LIKE type_file.num20_6 #No.FUN-4C0010  #No.FUN-680107 DECIMAL(20,6)
    DEFINE l_nma02      LIKE nma_file.nma02
    DEFINE l_nnn02      LIKE nnn_file.nnn02
    DEFINE l_nmaacti    LIKE nma_file.nmaacti
    DEFINE l_temp       LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
    DEFINE l_flag       LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
    DEFINE l_tmp,l_days LIKE type_file.num10   #No.FUN-680107 INTEGER
    DEFINE last_date    LIKE type_file.dat     #No.FUN-680107 DATE
    DEFINE l_msg        LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(30)
    DEFINE li_result    LIKE type_file.num5    #No.FUN-550057 #No.FUN-680107 SMALLINT
    DEFINE l_nno05      LIKE nno_file.nno05    #MOD-740240
    DEFINE l_nnn04      LIKE nnn_file.nnn04    #CHI-860039 add
    DEFINE l_nnn041     LIKE nnn_file.nnn041   #CHI-860039 add
    DEFINE l_nnn06      LIKE nnn_file.nnn06    #CHI-B30004
 
    CALL cl_set_head_visible("","YES")       #No.FUN-6B0030
 
    INPUT BY NAME g_nng.nng01,g_nng.nng25,g_nng.nng15,g_nng.nng02,g_nng.nng03, g_nng.nngoriu,g_nng.nngorig,
                  g_nng.nng52,g_nng.nng04,g_nng.nng24,g_nng.nng05,g_nng.nng051,
                  g_nng.nng14,g_nng.nng16,g_nng.nng06,g_nng.nng07,g_nng.nngconf,
                  g_nng.nngglno,g_nng.nng26,
                  g_nng.nng081,g_nng.nng082,g_nng.nng101,g_nng.nng102,
                  g_nng.nng18,g_nng.nng19,
                  g_nng.nngex2,g_nng.nng20,g_nng.nng21,
                  g_nng.nng22,g_nng.nng23,g_nng.nng12,g_nng.nng09,g_nng.nng13,
                  g_nng.nng11,g_nng.nng17,g_nng.nng54,g_nng.nng53,g_nng.nng55,
                  g_nng.nng57,g_nng.nng59,g_nng.nng61,
                  g_nng.nng_d1,g_nng.nng_d2,g_nng.nng_c1,g_nng.nng_c2,
                  g_nng.nng_d11,g_nng.nng_d21,g_nng.nng_c11,g_nng.nng_c21, #FUN-680088
                  g_nng.nnguser,g_nng.nnggrup,g_nng.nngmodu,g_nng.nngdate
                  ,g_nng.nngud01,g_nng.nngud02,g_nng.nngud03,g_nng.nngud04,
                  g_nng.nngud05,g_nng.nngud06,g_nng.nngud07,g_nng.nngud08,
                  g_nng.nngud09,g_nng.nngud10,g_nng.nngud11,g_nng.nngud12,
                  g_nng.nngud13,g_nng.nngud14,g_nng.nngud15 
        WITHOUT DEFAULTS
 
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL t720_set_entry(p_cmd)
         CALL t720_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("nng01") #FUN-560095
 
        AFTER FIELD nng01
           IF NOT cl_null(g_nng.nng01) AND (g_nng.nng01!=g_nng_t.nng01) THEN
              CALL s_check_no("anm",g_nng.nng01,g_nng_t.nng01,"5","nng_file","nng01","")
                 RETURNING li_result,g_nng.nng01
              DISPLAY BY NAME g_nng.nng01
              IF (NOT li_result) THEN
                NEXT FIELD nng01
              END IF
           END IF
 
        AFTER FIELD nng25    #No:6721
           IF NOT cl_null(g_nng.nng25) THEN
              IF g_nng.nng25 NOT MATCHES '[YN]' THEN
                 NEXT FIELD nng25
              END IF
           END IF
           CALL t720_set_entry(p_cmd)        #MOD-CA0017 add
           CALL t720_set_no_entry(p_cmd)     #MOD-CA0017 add
 
 
        AFTER FIELD nng02
           IF NOT cl_null(g_nng.nng02) THEN
              IF cl_null(g_nng.nng03) THEN
                 LET g_nng.nng03 = g_nng.nng02
                 DISPLAY BY NAME g_nng.nng03
              END IF
              IF g_nng.nng02 <= g_nmz.nmz10 THEN
                 CALL cl_err('','aap-176',1) NEXT FIELD nng02
              END IF
           END IF
 
        AFTER FIELD  nng03
           IF NOT cl_null(g_nng.nng03) THEN
              IF g_nng.nng03 < g_nng.nng02 THEN
                 CALL cl_err('',"anm-600",0)
                 NEXT FIELD nng03
              END IF
           END IF
 
        AFTER FIELD nng04
           IF NOT cl_null(g_nng.nng04) THEN
             #-MOD-AB0230-add-
              CALL t720_nng04('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng04,g_errno,0)
                 LET g_nng.nng04=g_nng_t.nng04
                 DISPLAY BY NAME g_nng.nng04
                 NEXT FIELD nng04
              END IF
             #-MOD-AB0230-end-
              SELECT * INTO g_alg.* FROM alg_file WHERE alg01 = g_nng.nng04
              IF STATUS THEN
                 CALL cl_err3("sel","alg_file",g_nng.nng04,"",STATUS,"","sel alg:",1)  #No.FUN-660148
                 NEXT FIELD nng04
              END IF
              DISPLAY BY NAME g_alg.alg02
           END IF
 
        AFTER FIELD nng05
          #IF NOT cl_null(g_nng.nng05) THEN                                               #No.TQC-B60108
          #IF NOT cl_null(g_nng.nng05) AND (g_nng.nng05!=g_nng_t.nng05) THEN              #No.TQC-B60108#MOD-CA0174 mark
           IF NOT cl_null(g_nng.nng05) THEN                                               #MOD-CA0174 add
              IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_nng.nng05 != g_nng_t.nng05)) THEN     #MOD-CA0174 add
                 SELECT * INTO g_nma.* FROM nma_file WHERE nma01 = g_nng.nng05
                 IF STATUS THEN
                    CALL cl_err3("sel","nma_file",g_nng.nng05,"",STATUS,"","sel nma:",1)  #No.FUN-660148
                    NEXT FIELD nng05
                 END IF
                 DISPLAY BY NAME g_nma.nma02
                 LET g_nng.nng_d1=g_nma.nma05
                 DISPLAY BY NAME g_nng.nng_d1
                 IF g_aza.aza63 = 'Y' THEN
                    LET g_nng.nng_d11=g_nma.nma051
                    DISPLAY BY NAME g_nng.nng_d11
                 END IF
                 CALL t720_aag(g_nng.nng_d1,'0') RETURNING l_aag02 #No.MOD-480327
                 DISPLAY l_aag02 TO aag02_d1                   #No.MOD-480327
                 IF g_aza.aza63 = 'Y' THEN
                    LET l_aag02 = NULL
                    CALL t720_aag(g_nng.nng_d11,'1') RETURNING l_aag02 #No.MOD-480327
                    DISPLAY l_aag02 TO aag02_d11                  #No.MOD-480327
                 END IF
              END IF                                                                      #MOD-CA0174 add
           END IF
 
        AFTER FIELD nng051
           IF NOT cl_null(g_nng.nng051) THEN
              SELECT nmc01 FROM nmc_file WHERE nmc01=g_nng.nng051
              IF STATUS THEN
                 CALL cl_err3("sel","nmc_file",g_nng.nng051,"",STATUS,"","sel nmc:",1)  #No.FUN-660148
                 NEXT FIELD nng051
              END IF
           END IF
 
        BEFORE FIELD nng55
           LET g_nnn06 = null
           SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nng.nng24
           IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN
              IF YEAR(g_nng.nng081)*12+MONTH(g_nng.nng081)<>
                 YEAR(g_nng.nng082)*12+MONTH(g_nng.nng082)
                 THEN LET last_date=
                          s_monend(YEAR(g_nng.nng081),MONTH(g_nng.nng081))
                 ELSE LET last_date=g_nng.nng082
              END IF
              LET g_nng.nng55 = g_nng.nng22 * g_nng.nng09/100
              IF cl_null(g_nng.nng55) THEN LET g_nng.nng55=0 END IF     #No:B068
              LET g_dec6=1-(g_nng.nng09/100 * (g_nng.nng082-g_nng.nng081)/365)
              LET g_nng.nng55 = g_nng.nng22 - (g_nng.nng22*g_dec6)
              IF cl_null(g_nng.nng55) THEN LET g_nng.nng55=0 END IF     #No:B068
              LET g_nng.nng55=cl_digcut(g_nng.nng55,g_azi04)
              DISPLAY BY NAME g_nng.nng55
           END IF
 
        AFTER FIELD nng52
           IF NOT cl_null(g_nng.nng52) THEN
             #-MOD-AB0230-add-
              CALL t720_nng52('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng52,g_errno,0)
                 LET g_nng.nng52=g_nng_t.nng52
                 DISPLAY BY NAME g_nng.nng52
                 NEXT FIELD nng52
              END IF
             #-MOD-AB0230-end-
              SELECT nno02,nno06 INTO g_nng.nng04,g_nng.nng18  #No.TQC-790077
                FROM nno_file
               WHERE nno01=g_nng.nng52
                 AND nnoacti = 'Y'   #MOD-840248
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","nno_file",g_nng.nng52,"","aap-091","","",1)  #No.FUN-660148
                 NEXT FIELD nng52
              END IF
              DISPLAY BY NAME g_nng.nng18  #No.TQC-790077
              LET l_nno05 = ''
              SELECT nno05 INTO l_nno05 FROM nno_file
                WHERE nno01=g_nng.nng52
              IF l_nno05 < g_nng.nng03 THEN
                 CALL cl_err(g_nng.nng52,'anm-320',0)
                 NEXT FIELD nng52
              END IF
           END IF
 
        AFTER FIELD nng55
           IF cl_null(g_nng.nng55) THEN LET g_nng.nng55=0 END IF     #No:9712
           LET g_nng.nng55=cl_digcut(g_nng.nng55,g_azi04)
           DISPLAY BY NAME g_nng.nng55
 
        BEFORE FIELD nng081
           IF g_nng.nng081 IS NULL THEN
              LET g_nng.nng081 = g_nng.nng03
              DISPLAY BY NAME g_nng.nng081
           END IF
 
        AFTER FIELD nng081
           IF NOT cl_null(g_nng.nng081) THEN
              IF g_nng.nng082 IS NULL THEN
                 LET g_nng.nng082 = g_nng.nng082
                 DISPLAY BY NAME g_nng.nng082
              END IF
              IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN   #MOD-8A0148 add
                 IF g_nng_t.nng081 IS NULL OR g_nng_t.nng081 <> g_nng.nng081 THEN 
                    LET g_dec6=1-(g_nng.nng09/100 * (g_nng.nng082-g_nng.nng081)/365)
                    LET g_nng.nng55 = g_nng.nng22 - (g_nng.nng22*g_dec6)
                    IF cl_null(g_nng.nng55) THEN LET g_nng.nng55=0 END IF  
                    LET g_nng.nng55=cl_digcut(g_nng.nng55,g_azi04)
                    DISPLAY BY NAME g_nng.nng55
                 END IF
              ELSE
                 LET g_nng.nng55=0
                 DISPLAY BY NAME g_nng.nng55
              END IF
           END IF
 
        AFTER FIELD nng082
           IF NOT cl_null(g_nng.nng082) THEN
              IF g_nng.nng082 < g_nng.nng081 THEN
                 CALL cl_err('',"anm-091",0) NEXT FIELD nng082
              END IF
             #------------------MOD-D10187-------------mark
             ##MOD-B30354--add--str--
             #LET l_nno05 = ''
             #SELECT nno05 INTO l_nno05 FROM nno_file WHERE nno01=g_nng.nng52
             #IF l_nno05 < g_nng.nng082 THEN
             #   CALL cl_err(g_nng.nng082,'anm1017',0)
             #   NEXT FIELD nng082
             #END IF
             ##MOD-B30354--add--end--
             #------------------MOD-D10187-------------mark
              IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN   #MOD-8A0148 add
                 IF g_nng_t.nng082 IS NULL OR g_nng_t.nng082 <> g_nng.nng082 THEN 
                    LET g_dec6=1-(g_nng.nng09/100 * (g_nng.nng082-g_nng.nng081)/365)
                    LET g_nng.nng55 = g_nng.nng22 - (g_nng.nng22*g_dec6)
                    IF cl_null(g_nng.nng55) THEN LET g_nng.nng55=0 END IF  
                    LET g_nng.nng55=cl_digcut(g_nng.nng55,g_azi04)
                    DISPLAY BY NAME g_nng.nng55
                 END IF
              ELSE
                 LET g_nng.nng55=0
                 DISPLAY BY NAME g_nng.nng55
              END IF
           END IF
 
        BEFORE FIELD nng101
           IF cl_null(g_nng.nng101) THEN
              LET g_nng.nng101 = g_nng.nng081
              DISPLAY BY NAME g_nng.nng101
           END IF
           
        AFTER FIELD nng101
           IF NOT cl_null(g_nng.nng101) THEN              
              IF p_cmd = 'u' AND (g_nng.nng101 != g_nng_t.nng101) THEN
                 CALL t720_nng11()
              END IF
           END IF      
 
        AFTER FIELD nng102
           IF NOT cl_null(g_nng.nng102) THEN
              IF g_nng.nng102 < g_nng.nng101 THEN
                 CALL cl_err('',"anm-091",0) NEXT FIELD nng102
              END IF
             #------------------MOD-D10187-------------mark
             ##MOD-B30354--add--str--
             #LET l_nno05 = ''
             #SELECT nno05 INTO l_nno05 FROM nno_file WHERE nno01=g_nng.nng52
             #IF l_nno05 < g_nng.nng102 THEN
             #   CALL cl_err(g_nng.nng102,'anm1017',0)
             #   NEXT FIELD nng102
             #END IF
             ##MOD-B30354--add--end--
             #------------------MOD-D10187-------------mark
              IF p_cmd = 'u' AND (g_nng.nng102 != g_nng_t.nng102) THEN
                 CALL t720_nng11()
              END IF   
           END IF
 
        AFTER FIELD nng11
           IF NOT cl_null(g_nng.nng11) THEN
              IF g_nng.nng11 < 0 THEN
                 CALL cl_err('',"anm-249",0) NEXT FIELD nng11
              END IF
           END IF
 
        AFTER FIELD nng12
           IF NOT cl_null(g_nng.nng12) THEN
              IF g_nng.nng12 NOT MATCHES "[1234]" THEN
                 NEXT FIELD nng12
              END IF
              IF p_cmd = 'a' OR (p_cmd = 'u' AND (g_nng.nng12 != g_nng_t.nng12)) THEN
                 CALL t720_nng11()
              END IF   
           END IF
 
        AFTER FIELD nng13
           IF NOT cl_null(g_nng.nng13) THEN
              IF g_nng.nng13 < 0 OR g_nng.nng13 > 31 THEN
                 CALL cl_err(g_nng.nng13,"anm-010",0)
                 NEXT FIELD nng13
              END IF
           END IF
 
        AFTER FIELD nng14
           IF NOT cl_null(g_nng.nng14) THEN
              IF g_nng.nng14 NOT MATCHES "[12]" THEN
                 NEXT FIELD nng14
              END IF
           END IF
 
        AFTER FIELD nng09
           IF g_nng.nng14 = '1' THEN   #固定利息
              IF g_nng.nng09 <=0 THEN
                 CALL cl_err(g_nng.nng09,'anm-246',0)
                 NEXT FIELD nng09
              END IF
           END IF
           IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN   #MOD-8A0148 add
              IF NOT cl_null(g_nng.nng09) AND 
                 (g_nng_t.nng09 IS NULL OR g_nng_t.nng09 <> g_nng.nng09) THEN 
                 LET g_dec6=1-(g_nng.nng09/100 * (g_nng.nng082-g_nng.nng081)/365)
                 LET g_nng.nng55 = g_nng.nng22 - (g_nng.nng22*g_dec6)
                 IF cl_null(g_nng.nng55) THEN LET g_nng.nng55=0 END IF  
                 LET g_nng.nng55=cl_digcut(g_nng.nng55,g_azi04)
                 DISPLAY BY NAME g_nng.nng55
              END IF
           ELSE
              LET g_nng.nng55=0
              DISPLAY BY NAME g_nng.nng55
           END IF
 
        AFTER FIELD nng54   #他保銀行add
           IF NOT cl_null(g_nng.nng54) THEN
              SELECT nma02 INTO l_nma02 FROM nma_file WHERE nma01=g_nng.nng54
              IF STATUS THEN
                 CALL cl_err3("sel","nma_file",g_nng.nng54,"",STATUS,"","sel nma:",1)  #No.FUN-660148
                 NEXT FIELD nng54
              END IF
           END IF
 
        AFTER FIELD nng15
           #IF NOT cl_null(g_nng.nng15) THEN                                 #No.TQC-B60108
           IF NOT cl_null(g_nng.nng15) AND (g_nng.nng15!=g_nng_t.nng15) THEN #No.TQC-B60108
              IF g_nng.nng15 NOT MATCHES "[123]" THEN
                 NEXT FIELD nng15
              END IF
             #當nms65,nms651為空時,使用nng24再抓取nnn04,nnn041
              LET l_nnn04 =' '   LET l_nnn041=' '
              LET l_nnn06 = ''   #CHI-B30004
              SELECT nnn04,nnn041,nnn06 INTO l_nnn04,l_nnn041,l_nnn06  #CHI-B30004 add nnn06
                FROM nnn_file
               WHERE nnn01=g_nng.nng24
              IF cl_null(l_nnn04)  THEN LET l_nnn04 =' ' END IF
              IF cl_null(l_nnn041) THEN LET l_nnn041=' ' END IF
              IF g_nng.nng15 = '1' THEN
                 LET g_nng.nng_d2=g_nms.nms67
                #-CHI-B30004-mark-
                #IF cl_null(g_nms.nms65) THEN
                #   LET g_nng.nng_c1=l_nnn04
                #ELSE
                #   LET g_nng.nng_c1=g_nms.nms65
                #END IF
                #-CHI-B30004-add-
                 IF l_nnn04 <> ' ' THEN
                    LET g_nng.nng_c1 = l_nnn04 
                 ELSE
                    CASE l_nnn06
                       WHEN '1' 
                         LET g_nng.nng_c1 = g_nms.nms65 
                       WHEN '2' 
                         LET g_nng.nng_c1 = g_nms.nms63 
                       WHEN '3' 
                         LET g_nng.nng_c1 = g_nms.nms62 
                       WHEN '4' 
                         LET g_nng.nng_c1 = g_nms.nms56
                       WHEN '5' 
                         LET g_nng.nng_c1 = l_nnn04
                    END CASE 
                 END IF
                #-CHI-B30004-end-
                 LET g_nng.nng_c2=g_nms.nms66
                 IF g_aza.aza63 = 'Y' THEN
                    LET g_nng.nng_d21=g_nms.nms671
                   #-CHI-B30004-mark-
                   #IF cl_null(g_nms.nms651) THEN
                   #   LET g_nng.nng_c11=l_nnn041
                   #ELSE
                   #   LET g_nng.nng_c11=g_nms.nms651
                   #END IF
                   #-CHI-B30004-add-
                    IF l_nnn041 <> ' ' THEN
                       LET g_nng.nng_c11 = l_nnn041 
                    ELSE
                       CASE l_nnn06
                          WHEN '1' 
                            LET g_nng.nng_c11 = g_nms.nms651 
                          WHEN '2' 
                            LET g_nng.nng_c11 = g_nms.nms631 
                          WHEN '3' 
                            LET g_nng.nng_c11 = g_nms.nms621 
                          WHEN '4' 
                            LET g_nng.nng_c11 = g_nms.nms561
                          WHEN '5' 
                            LET g_nng.nng_c11 = l_nnn041
                       END CASE 
                    END IF
                   #-CHI-B30004-end-
                    LET g_nng.nng_c21=g_nms.nms661
                 END IF
              END IF
              IF g_nng.nng15 = '2' THEN
                 LET g_nng.nng_d2=NULL
                 LET g_nng.nng_c1=g_nms.nms55
                 LET g_nng.nng_c2=NULL
                 IF g_aza.aza63 = 'Y' THEN
                    LET g_nng.nng_d21=NULL
                    LET g_nng.nng_c11=g_nms.nms551
                    LET g_nng.nng_c21=NULL
                 END IF
              END IF
              CALL t720_aag(g_nng.nng_d2,'0') RETURNING l_aag02
              DISPLAY l_aag02 TO aag02_d2
              CALL t720_aag(g_nng.nng_c1,'0') RETURNING l_aag02
              DISPLAY l_aag02 TO aag02_c1
              CALL t720_aag(g_nng.nng_c2,'0') RETURNING l_aag02
              DISPLAY l_aag02 TO aag02_c2
              DISPLAY BY NAME g_nng.nng_d2
              DISPLAY BY NAME g_nng.nng_c1
              DISPLAY BY NAME g_nng.nng_c2
              IF g_aza.aza63 = 'Y' THEN
                 DISPLAY BY NAME g_nng.nng_d21
                 DISPLAY BY NAME g_nng.nng_c11
                 DISPLAY BY NAME g_nng.nng_c21
                 LET l_aag02 = NULL
                 CALL t720_aag(g_nng.nng_d21,'1') RETURNING l_aag02
                 DISPLAY l_aag02 TO aag02_d21
                 CALL t720_aag(g_nng.nng_c11,'1') RETURNING l_aag02
                 DISPLAY l_aag02 TO aag02_c11
                 CALL t720_aag(g_nng.nng_c21,'1') RETURNING l_aag02
                 DISPLAY l_aag02 TO aag02_c21
              END IF
           END IF
 
        AFTER FIELD nng16
           IF NOT cl_null(g_nng.nng16) THEN
              IF g_nng.nng16 NOT MATCHES "[12]" THEN
                 NEXT FIELD nng16
              END IF
           END IF
 
        AFTER FIELD nng17
           IF NOT cl_null(g_nng.nng17) THEN
              SELECT COUNT(*) INTO l_n FROM nml_file
               WHERE nml01 = g_nng.nng17
              IF SQLCA.SQLCODE OR l_n <= 0 THEN
                 CALL cl_err3("sel","nml_file",g_nng.nng17,"","anm-030","","",1)  #No.FUN-660148
                 NEXT FIELD nng17
              END IF
           END IF
 
        AFTER FIELD nng18
           IF NOT cl_null(g_nng.nng18) THEN
              SELECT azi04 INTO t_azi04 FROM azi_file
               WHERE azi01 = g_nng.nng18
              IF SQLCA.SQLCODE THEN
                 CALL cl_err3("sel","azi_file",g_nng.nng18,"","anm-007","","",1)  #No.FUN-660148
                 NEXT FIELD nng18
              END IF
           END IF
 
        AFTER FIELD nng19   #匯率
            IF g_nng.nng18 =g_aza.aza17 THEN
               LET g_nng.nng19  =1
               DISPLAY BY NAME g_nng.nng19
            END IF
            IF NOT cl_null(g_nng.nng19) THEN
               IF g_nng.nng19 < 0 THEN
                  CALL cl_err(g_nng.nng19,'axm-179',0)
                  NEXT FIELD nng19
               END IF
            END IF
         AFTER FIELD nngex2
            IF NOT cl_null(g_nng.nngex2) THEN
               IF g_nng.nngex2 < 0 THEN
                  CALL cl_err(g_nng.nngex2,'axm-179',0)
                  NEXT FIELD nngex2
               END IF
            END IF
 
 
        BEFORE FIELD nng57   #保證金計算add03/01/10
            LET g_nng.nng57 = g_nng.nng22 * g_nng.nng56/100 *
                              ((g_nng.nng082-g_nng.nng081)/365)
            #他保-將數值依指定的小數位數做四捨五入,自保捨去
            IF cl_null(g_nng.nng54) THEN
               CALL cl_digcut(g_nng.nng57,g_azi04) RETURNING g_nng.nng57
            ELSE
               LET l_tmp=g_nng.nng57
               LET g_nng.nng57=l_tmp
            END IF
            DISPLAY BY NAME g_nng.nng57
 
        AFTER FIELD nng57
            IF cl_null(g_nng.nng57) THEN LET g_nng.nng57 = 0 END IF #MOD-470468
           LET g_nng.nng57=cl_digcut(g_nng.nng57,g_azi04)
           DISPLAY BY NAME g_nng.nng57
 
        BEFORE FIELD nng59   #保證金計算
           LET g_nng.nng59 = g_nng.nng22 * g_nng.nng58/100 *
                             ((g_nng.nng082-g_nng.nng081)/365)
           IF cl_null(g_nng.nng59) THEN LET g_nng.nng59=0 END IF   #No:B068
           CALL cl_digcut(g_nng.nng59,g_azi04) RETURNING g_nng.nng59
           DISPLAY BY NAME g_nng.nng59
 
        AFTER FIELD nng59
            IF cl_null(g_nng.nng59) THEN LET g_nng.nng59 = 0 END IF #MOD-470468
           LET g_nng.nng59=cl_digcut(g_nng.nng59,g_azi04)
           DISPLAY BY NAME g_nng.nng59
 
        BEFORE FIELD nng61   #保證金計算
           LET g_nng.nng61 = g_nng.nng22 * g_nng.nng60/100 *
                             ((g_nng.nng082-g_nng.nng081)/365)
           IF cl_null(g_nng.nng61) THEN LET g_nng.nng61=0 END IF   #No:B068
           CALL cl_digcut(g_nng.nng61,g_azi04) RETURNING g_nng.nng61
           DISPLAY BY NAME g_nng.nng61
 
        AFTER FIELD nng61
            IF cl_null(g_nng.nng61) THEN LET g_nng.nng61 = 0 END IF #MOD-470468
           LET g_nng.nng61=cl_digcut(g_nng.nng61,g_azi04)
           DISPLAY BY NAME g_nng.nng61
 
        BEFORE FIELD nng19
           IF g_nng.nng18 != g_nng_t.nng18 OR g_nng_t.nng18 IS NULL THEN
              LET g_nng.nng19=s_curr3(g_nng.nng18,g_nng.nng03,'S')
              DISPLAY BY NAME g_nng.nng19
           END IF
 
        AFTER FIELD nng20
           IF NOT cl_null(g_nng.nng20) THEN
              IF g_nng.nng20 < 0 THEN
                 CALL cl_err('',"anm-041",0)
                 NEXT FIELD nng20
              END IF
              CALL cl_digcut(g_nng.nng20,t_azi04) RETURNING g_nng.nng20
              DISPLAY BY NAME g_nng.nng20
              LET g_nng.nng22=g_nng.nng20*g_nng.nng19
              IF cl_null(g_nng.nng22) THEN LET g_nng.nng22=0 END IF   #No:B068
              CALL cl_digcut(g_nng.nng22,g_azi04) RETURNING g_nng.nng22
              DISPLAY BY NAME g_nng.nng22
              CALL s_credit2('N',g_nng.nng04,g_nng.nng52,g_nng.nng24)   
                           RETURNING amty,amtu,u_amty,u_amtu,bal
                              # 綜合額度,授信類別額度,綜合動用額度,動用額度,餘額
              LET bal=bal-(g_nng.nng20*g_nng.nngex2)
              IF bal<0 THEN
                 call cl_err('','anm-287',1)
                 NEXT FIELD nng20                        #MOD-C70179 add
              END IF
           END IF
 
        AFTER FIELD nng22
           CALL cl_digcut(g_nng.nng22,g_azi04) RETURNING g_nng.nng22
           DISPLAY BY NAME g_nng.nng22
           IF NOT cl_null(g_nng.nng22) THEN
              IF g_nng.nng22 < 0 THEN
                 CALL cl_err(g_nng.nng22,'axm-179',0)
                 NEXT FIELD nng22
              END IF
           END IF
 
           IF g_nnn06 IS NOT NULL AND g_nnn06 MATCHES '[23]' THEN   #MOD-8A0148 add
              IF NOT cl_null(g_nng.nng22) AND 
                 (g_nng_t.nng22 IS NULL OR g_nng_t.nng22 <> g_nng.nng22) THEN 
                 LET g_dec6=1-(g_nng.nng09/100 * (g_nng.nng082-g_nng.nng081)/365)
                 LET g_nng.nng55 = g_nng.nng22 - (g_nng.nng22*g_dec6)
                 IF cl_null(g_nng.nng55) THEN LET g_nng.nng55=0 END IF  
                 LET g_nng.nng55=cl_digcut(g_nng.nng55,g_azi04)
                 DISPLAY BY NAME g_nng.nng55
              END IF
           ELSE
              LET g_nng.nng55=0
              DISPLAY BY NAME g_nng.nng55
           END IF
 
        AFTER FIELD nng24   #長貸種類
          #IF NOT cl_null(g_nng.nng24) THEN                                            #No.TQC-B60108
          #IF NOT cl_null(g_nng.nng24) AND (g_nng.nng24!=g_nng_t.nng24)THEN            #No.TQC-B60108 #MOD-CA0174 mark
           IF NOT cl_null(g_nng.nng24) THEN                                            #MOD-CA0174 add
              IF p_cmd = 'a' OR (p_cmd= 'u' AND (g_nng.nng24!=g_nng_t.nng24))THEN      #MOD-CA0174 add
                 CALL t720_nng24('u')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nng.nng24,g_errno,0)
                    LET g_nng.nng24=g_nng_t.nng24
                    DISPLAY BY NAME g_nng.nng24
                    DISPLAY '' TO FORMONLY.nnn02
                    NEXT FIELD nng24
                 ELSE
                    #當nms65,nms651為空時,使用nng24再抓取nnn04,nnn041
                    LET l_nnn04 =' '   LET l_nnn041=' '
                    LET l_nnn06 = ''   #CHI-B30004
                    SELECT nnn04,nnn041,nnn06 INTO l_nnn04,l_nnn041,l_nnn06  #CHI-B30004 add nnn06
                      FROM nnn_file
                     WHERE nnn01=g_nng.nng24
                    IF cl_null(l_nnn04)  THEN LET l_nnn04 =' ' END IF
                    IF cl_null(l_nnn041) THEN LET l_nnn041=' ' END IF
                    IF g_nng.nng15 = '1' THEN
                      #-CHI-B30004-mark-
                      #IF cl_null(g_nms.nms65) THEN
                      #   LET g_nng.nng_c1=l_nnn04
                      #ELSE
                      #   LET g_nng.nng_c1=g_nms.nms65
                      #END IF
                      #-CHI-B30004-add-
                       IF l_nnn04 <> ' ' THEN
                          LET g_nng.nng_c1 = l_nnn04 
                       ELSE
                          CASE l_nnn06
                             WHEN '1' 
                               LET g_nng.nng_c1 = g_nms.nms65 
                             WHEN '2' 
                               LET g_nng.nng_c1 = g_nms.nms63 
                             WHEN '3' 
                               LET g_nng.nng_c1 = g_nms.nms62 
                             WHEN '4' 
                               LET g_nng.nng_c1 = g_nms.nms56
                             WHEN '5' 
                               LET g_nng.nng_c1 = l_nnn04
                          END CASE 
                       END IF
                      #-CHI-B30004-end-
                       DISPLAY BY NAME g_nng.nng_c1
                       IF g_aza.aza63 = 'Y' THEN
                         #-CHI-B30004-mark-
                         #IF cl_null(g_nms.nms651) THEN
                         #   LET g_nng.nng_c11=l_nnn041
                         #ELSE
                         #   LET g_nng.nng_c11=g_nms.nms651
                         #END IF
                         #-CHI-B30004-add-
                          IF l_nnn041 <> ' ' THEN
                             LET g_nng.nng_c11 = l_nnn041 
                          ELSE
                             CASE l_nnn06
                                WHEN '1' 
                                  LET g_nng.nng_c11 = g_nms.nms651 
                                WHEN '2' 
                                  LET g_nng.nng_c11 = g_nms.nms631 
                                WHEN '3' 
                                  LET g_nng.nng_c11 = g_nms.nms621 
                                WHEN '4' 
                                  LET g_nng.nng_c11 = g_nms.nms561
                                WHEN '5' 
                                  LET g_nng.nng_c11 = l_nnn041
                             END CASE 
                          END IF
                         #-CHI-B30004-end-
                          DISPLAY BY NAME g_nng.nng_c11
                       END IF
                    END IF
                 END IF
              END IF                                                              #MOD-CA0174 add
              LET g_nnn06 = null
              SELECT nnn06 INTO g_nnn06 FROM nnn_file WHERE nnn01 = g_nng.nng24
              IF g_nnn06 NOT MATCHES '[23]' THEN
                 LET g_nng.nng55=0
                 DISPLAY BY NAME g_nng.nng55
              END IF
           END IF

        AFTER FIELD nng_d1
           IF NOT cl_null(g_nng.nng_d1) THEN
              CALL t720_aag(g_nng.nng_d1,'0') RETURNING l_aag02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng_d1,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nng.nng_d1,'23',g_bookno1)  
                   RETURNING g_nng.nng_d1
                 DISPLAY BY NAME g_nng.nng_d1
#FUN-B20073 --end--                 
                 NEXT FIELD nng_d1
              END IF
              DISPLAY l_aag02 TO aag02_d1
           ELSE
              LET l_aag02 = ''
              DISPLAY l_aag02 TO aag02_d1
           END IF
 
        AFTER FIELD nng_d2
           IF NOT cl_null(g_nng.nng_d2) THEN
              CALL t720_aag(g_nng.nng_d2,'0') RETURNING l_aag02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng_d2,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nng.nng_d2,'23',g_bookno1)    
                   RETURNING g_nng.nng_d2
                 DISPLAY BY NAME g_nng.nng_d2
#FUN-B20073 --end--                 
                 NEXT FIELD nng_d2
              END IF
              DISPLAY l_aag02 TO aag02_d2
           ELSE
              LET l_aag02 = ''
              DISPLAY l_aag02 TO aag02_d2
           END IF
 
        AFTER FIELD nng_c1
           IF NOT cl_null(g_nng.nng_c1) THEN
              CALL t720_aag(g_nng.nng_c1,'0') RETURNING l_aag02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng_c1,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nng.nng_c1,'23',g_bookno1)  
                   RETURNING g_nng.nng_c1
                 DISPLAY BY NAME g_nng.nng_c1
#FUN-B20073 --end--                 
                 NEXT FIELD nng_c1
              END IF
              DISPLAY l_aag02 TO aag02_c1
           ELSE
              LET l_aag02 = ''
              DISPLAY l_aag02 TO aag02_c1
           END IF
 
        AFTER FIELD nng_c2
           IF NOT cl_null(g_nng.nng_c2) THEN
              CALL t720_aag(g_nng.nng_c2,'0') RETURNING l_aag02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng_c2,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nng.nng_c2,'23',g_bookno1)    
                    RETURNING g_nng.nng_c2
                 DISPLAY BY NAME g_nng.nng_c2
#FUN-B20073 --end--                 
                 NEXT FIELD nng_c2
              END IF
              DISPLAY l_aag02 TO aag02_c2
           ELSE
              LET l_aag02 = ''
              DISPLAY l_aag02 TO aag02_c2
           END IF
 
        AFTER FIELD nng_d11
           IF NOT cl_null(g_nng.nng_d11) THEN
              CALL t720_aag(g_nng.nng_d11,'1') RETURNING l_aag02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng_d11,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nng.nng_d11,'23',g_bookno2)   
                   RETURNING g_nng.nng_d11
                 DISPLAY BY NAME g_nng.nng_d11
#FUN-B20073 --end--                 
                 NEXT FIELD nng_d11
              END IF
              DISPLAY l_aag02 TO aag02_d11
           ELSE
              LET l_aag02 = ''
              DISPLAY l_aag02 TO aag02_d11
           END IF
 
        AFTER FIELD nng_d21
           IF NOT cl_null(g_nng.nng_d21) THEN
              CALL t720_aag(g_nng.nng_d21,'1') RETURNING l_aag02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng_d21,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nng.nng_d21,'23',g_bookno2)  
                   RETURNING g_nng.nng_d21
                 DISPLAY BY NAME g_nng.nng_d21
#FUN-B20073 --end--                 
                 NEXT FIELD nng_d21
              END IF
              DISPLAY l_aag02 TO aag02_d21
           ELSE
              LET l_aag02 = ''
              DISPLAY l_aag02 TO aag02_d21
           END IF
 
        AFTER FIELD nng_c11
           IF NOT cl_null(g_nng.nng_c11) THEN
              CALL t720_aag(g_nng.nng_c11,'1') RETURNING l_aag02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng_c11,g_errno,0) 
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nng.nng_c11,'23',g_bookno2)  
                    RETURNING g_nng.nng_c11
                 DISPLAY BY NAME g_nng.nng_c11
#FUN-B20073 --end--                 
                 NEXT FIELD nng_c11
              END IF
              DISPLAY l_aag02 TO aag02_c11
           ELSE
              LET l_aag02 = ''
              DISPLAY l_aag02 TO aag02_c11
           END IF
 
        AFTER FIELD nng_c21
           IF NOT cl_null(g_nng.nng_c21) THEN
              CALL t720_aag(g_nng.nng_c21,'1') RETURNING l_aag02
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nng.nng_c21,g_errno,0)
#FUN-B20073 --begin--
                 CALL q_m_aag(FALSE,FALSE,g_plant_gl,g_nng.nng_c21,'23',g_bookno2)    
                   RETURNING g_nng.nng_c21
                 DISPLAY BY NAME g_nng.nng_c21
#FUN-B20073 --end--                  
                  NEXT FIELD nng_c21
              END IF
              DISPLAY l_aag02 TO aag02_c21
           ELSE
              LET l_aag02 = ''
              DISPLAY l_aag02 TO aag02_c21
           END IF
        AFTER FIELD nngud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nngud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT
           LET g_nng.nnguser = s_get_data_owner("nng_file") #FUN-C10039
           LET g_nng.nnggrup = s_get_data_group("nng_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
           IF g_nng.nng55 > 0 THEN
              LET g_nng.nng_d2 = g_nms.nms59
           END IF
           IF NOT cl_null(g_nng.nng54) THEN
              LET g_nng.nng_c2 = g_nms.nms15
           END IF
           IF g_nng.nng55 != 0  THEN # Thomas 020103
              LET l_temp = (g_nng.nng09+g_nng.nng56+g_nng.nng58+g_nng.nng60)/100
              LET g_nng.nng53=l_temp/(1-(l_temp/365*(g_nng.nng082-g_nng.nng081)))*100
           ELSE
               LET g_nng.nng53 = g_nng.nng09
           END IF
           IF cl_null(g_nng.nng53) THEN LET g_nng.nng53=0 END IF   #No:B068
           DISPLAY BY NAME g_nng.nng53
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(nng01)
                 LET g_t1 = s_get_doc_no(g_nng.nng01)       #No.FUN-550057
              CALL q_nmy(FALSE,FALSE,g_t1,'5','ANM') RETURNING g_t1 #NO:6842    #TQC-670008
                 LET g_nng.nng01= g_t1             #No.FUN-550057
                 DISPLAY BY NAME g_nng.nng01 NEXT FIELD nng01
              WHEN INFIELD(nng04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_alg"
                 LET g_qryparam.default1 = g_nng.nng04
                 CALL cl_create_qry() RETURNING g_nng.nng04
                 DISPLAY BY NAME g_nng.nng04 NEXT FIELD nng04
              WHEN INFIELD(nng54)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_nng.nng54
                 CALL cl_create_qry() RETURNING g_nng.nng54
                 DISPLAY BY NAME g_nng.nng54 NEXT FIELD nng54
              WHEN INFIELD(nng05)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_nng.nng05
                 CALL cl_create_qry() RETURNING g_nng.nng05
                 DISPLAY BY NAME g_nng.nng05 NEXT FIELD nng05
              WHEN INFIELD(nng52) #合約號碼
                 CALL q_nnp01(0,1,g_nng.nng52,g_nng.nng03)     #TQC-C80198  add  g_nng.nng03
                      RETURNING g_nng.nng52
                 DISPLAY BY NAME g_nng.nng52
              WHEN INFIELD(nng051) #銀行代號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmc01"   #FUN-640021
                 LET g_qryparam.default1 = g_nng.nng051
                 LET g_qryparam.arg1 = '1'   #FUN-640021
                 CALL cl_create_qry() RETURNING g_nng.nng051
                 DISPLAY BY NAME g_nng.nng051
                 NEXT FIELD nng051
              WHEN INFIELD(nng17) #變動碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nml"
                 LET g_qryparam.default1 = g_nng.nng17
                 CALL cl_create_qry() RETURNING g_nng.nng17
                 DISPLAY BY NAME g_nng.nng17
                 NEXT FIELD nng17
              WHEN INFIELD(nng18)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_nng.nng18
                 CALL cl_create_qry() RETURNING g_nng.nng18
                 DISPLAY BY NAME g_nng.nng18 NEXT FIELD nng18
              WHEN INFIELD(nng24) #長貸種類
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nnp2"                #TQC-960039                 
                 LET g_qryparam.default1 = g_nng.nng24
                 LET g_qryparam.arg1 = g_nng.nng52             #TQC-960039
                 CALL cl_create_qry() RETURNING g_nng.nng24,l_nnn02
                  DISPLAY BY NAME g_nng.nng24               #No.MOD-490344
                 DISPLAY l_nnn02 TO FROMONLY.nnn02
                 CALL t720_nng24('d')
                 NEXT FIELD nng24
              WHEN INFIELD(nng_d1)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nng.nng_d1,'23',g_bookno1)  #No.FUN-980025 
                 RETURNING g_nng.nng_d1
                 DISPLAY BY NAME g_nng.nng_d1
                 NEXT FIELD nng_d1
              WHEN INFIELD(nng_d2)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nng.nng_d2,'23',g_bookno1)     #No.FUN-980025 
                 RETURNING g_nng.nng_d2
                 DISPLAY BY NAME g_nng.nng_d2
                 NEXT FIELD nng_d2
              WHEN INFIELD(nng_c1)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nng.nng_c1,'23',g_bookno1)     #No.FUN-980025 
                 RETURNING g_nng.nng_c1
                 DISPLAY BY NAME g_nng.nng_c1
                 NEXT FIELD nng_c1
              WHEN INFIELD(nng_c2)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nng.nng_c2,'23',g_bookno1)     #No.FUN-980025 
                 RETURNING g_nng.nng_c2
                 DISPLAY BY NAME g_nng.nng_c2
                 NEXT FIELD nng_c2
              WHEN INFIELD(nng_d11)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nng.nng_d11,'23',g_bookno2)     #No.FUN-980025 
                 RETURNING g_nng.nng_d11
                 DISPLAY BY NAME g_nng.nng_d11
                 NEXT FIELD nng_d11
              WHEN INFIELD(nng_d21)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nng.nng_d21,'23',g_bookno2)     #No.FUN-980025 
                 RETURNING g_nng.nng_d21
                 DISPLAY BY NAME g_nng.nng_d21
                 NEXT FIELD nng_d21
              WHEN INFIELD(nng_c11)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2   #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nng.nng_c11,'23',g_bookno2)     #No.FUN-980025 
                 RETURNING g_nng.nng_c11
                 DISPLAY BY NAME g_nng.nng_c11
                 NEXT FIELD nng_c11
              WHEN INFIELD(nng_c21)         # 總帳會計科目查詢
                 CALL s_get_bookno1(YEAR(g_nng.nng02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nng.nng_c21,'23',g_bookno2)     #No.FUN-980025  
                 RETURNING g_nng.nng_c21
                 DISPLAY BY NAME g_nng.nng_c21
                 NEXT FIELD nng_c21
              WHEN INFIELD(nng19)
                   CALL s_rate(g_nng.nng18,g_nng.nng19) RETURNING g_nng.nng19
                   DISPLAY BY NAME g_nng.nng19
                   NEXT FIELD nng19
              WHEN INFIELD(nngex2)
                   CALL s_rate(g_nng.nng18,g_nng.nngex2) RETURNING g_nng.nngex2
                   DISPLAY BY NAME g_nng.nngex2
                   NEXT FIELD nngex2
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
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
 
FUNCTION t720_nng24(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE g_nnn02   LIKE nnn_file.nnn02
   DEFINE l_nnnacti LIKE nnn_file.nnnacti
   
   LET g_errno = ' '
   SELECT COUNT(*) INTO g_cnt FROM nnp_file
    WHERE nnp01=g_nng.nng52 AND nnp03=g_nng.nng24
   IF g_cnt=0 THEN
      LET g_errno='anm-609'
      RETURN
   END IF
   IF cl_null(g_errno) OR p_cmd='d' THEN
      SELECT nnn02,nnnacti INTO g_nnn02,l_nnnacti
        FROM nnn_file WHERE nnn01=g_nng.nng24
      CASE
           WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-601'
                                    LET g_nnn02 = NULL
                                    LET l_nnnacti = NULL
           WHEN l_nnnacti='N'       LET g_errno = '9028'
           OTHERWISE           LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       DISPLAY g_nnn02 TO FORMONLY.nnn02
   END IF   
   
 
    IF cl_null(g_nng.nng09) OR g_nng.nng09 = 0 THEN
       SELECT nnp05 INTO g_nng.nng09 FROM nnp_file
         WHERE nnp01 = g_nng.nng52 AND 
               nnp03 = g_nng.nng24
       IF cl_null(g_nng.nng09) THEN LET g_nng.nng09 = 0 END IF 
       DISPLAY BY NAME g_nng.nng09
    END IF 
END FUNCTION
 
#-MOD-AB0230-add-
FUNCTION t720_nng52(p_cmd)    #合約號碼
   DEFINE p_cmd     LIKE type_file.chr1      
   DEFINE l_nnoacti LIKE nno_file.nnoacti
   DEFINE l_nno02   LIKE nno_file.nno02

   LET g_errno = ' '
   SELECT nnoacti,nno02 INTO l_nnoacti,l_nno02
     FROM nno_file
    WHERE nno01=g_nng.nng52
      AND nno09='N'  
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'anm-603'
                                  LET l_nnoacti = NULL
                                  LET l_nno02   = NULL
        WHEN l_nnoacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   LET g_nng.nng04=l_nno02  #信貸銀行
   DISPLAY BY NAME g_nng.nng04
   CALL t720_nng04('d')
END FUNCTION

FUNCTION t720_nng04(p_cmd)  #信貸銀行
   DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680107 CHAR(1)
   DEFINE l_nno02   LIKE nno_file.nno02
   DEFINE l_alg02   LIKE alg_file.alg02

   LET g_errno = ' '
   SELECT nno02 INTO l_nno02 FROM nno_file
    WHERE nno01=g_nng.nng52
      AND nno09='N'  
   CASE WHEN SQLCA.SQLCODE = 100    LET g_errno = 'aap-722'
                                    LET l_nno02 = NULL
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF cl_null(g_errno) AND p_cmd='d' THEN
      SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01=g_nng.nng04
      IF STATUS THEN LET g_errno='aap-722' RETURN END IF
      DISPLAY l_alg02 TO FORMONLY.alg02
   END IF
END FUNCTION
#-MOD-AB0230-end-

FUNCTION t720_aag(p_key,p_flag)       #No.FUN-730032
DEFINE
      l_aagacti  LIKE aag_file.aagacti,
      l_aag02    LIKE aag_file.aag02,
      l_aag07    LIKE aag_file.aag07,
      l_aag03    LIKE aag_file.aag03,
      l_aag09    LIKE aag_file.aag09,
      p_key      LIKE aag_file.aag01,
      p_flag     LIKE type_file.chr1,       #No.FUN-730032
      p_cmd      LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    CALL s_get_bookno(YEAR(g_nng.nng02)) RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag = '1' THEN
       CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
    END IF
    IF p_flag = '0' THEN
       LET g_bookno3 = g_bookno1
    ELSE
       LET g_bookno3 = g_bookno2
    END IF
    LET g_errno = " "
    SELECT aag02,aagacti,aag07,aag03,aag09
      INTO l_aag02,l_aagacti,l_aag07,l_aag03,l_aag09
      FROM aag_file
     WHERE aag01=p_key
       AND aag00 = g_bookno3       #No.FUN-730032
    CASE
         WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
                                  LET l_aag02 = NULL
                                  LET l_aagacti = NULL
         WHEN l_aagacti='N'       LET g_errno = '9028'
         WHEN l_aag07  ='1'       LET g_errno = 'agl-131'
         WHEN l_aag03  ='4'       LET g_errno = 'agl-912'
         WHEN l_aag09  ='N'       LET g_errno = 'agl-913'
         OTHERWISE                LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   RETURN l_aag02
END FUNCTION
 
FUNCTION t720_b()
DEFINE
    l_ac_t          LIKE type_file.num5,    #未取消的ARRAY CNT #No.FUN-680107 SMALLINT
    l_row,l_col     LIKE type_file.num5,    #分段輸入之行,列數 #No.FUN-680107 SMALLINT
    l_n,l_cnt       LIKE type_file.num5,    #檢查重複用        #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,    #單身鎖住否        #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,    #處理狀態          #No.FUN-680107 VARCHAR(1)
    l_flag          LIKE type_file.num10,   #No.FUN-680107 INTEGER
    l_dir           LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(01)
    l_allow_insert  LIKE type_file.num5,    #可新增否  #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5     #可刪除否  #No.FUN-680107 SMALLINT
 
    LET g_action_choice = ""
    SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
    IF cl_null(g_nng.nng01) THEN RETURN END IF
    IF g_nng.nngconf='Y' THEN CALL cl_err('','anm-137',1) RETURN END IF
    IF g_nng.nngconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
 
    IF g_nng.nng15 MATCHES '[12]' THEN
       SELECT COUNT(*) INTO l_n FROM nnh_file WHERE nnh01=g_nng.nng01
       IF l_n=0 THEN
          IF cl_confirm('aap-701') THEN
             CALL t720_g_b()
             CALL t720_b_fill(' 1=1')
             CALL t720_b_tot()
          END IF
       END IF
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM nnh_file WHERE nnh01=? AND nnh02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t720_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
     IF g_rec_b > 0 THEN #MOD-470468
        LET l_ac = 1
    END IF
 
    INPUT ARRAY g_nnh WITHOUT DEFAULTS FROM s_nnh.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
         IF g_rec_b!=0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            BEGIN WORK
            OPEN t720_cl USING g_nng.nng01
            IF STATUS THEN
               CALL cl_err("OPEN t720_cl:", STATUS, 1)
               CLOSE t720_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t720_cl INTO g_nng.*
            IF SQLCA.SQLCODE THEN
               CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
               CLOSE t720_cl
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_nnh_t.* = g_nnh[l_ac].*
               OPEN t720_bcl USING g_nng.nng01,g_nnh_t.nnh02
               IF STATUS THEN
                  CALL cl_err("OPEN t720_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH t720_bcl INTO b_nnh.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock nnh',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  CALL t720_b_move_to()
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
      
        #FUN-D30032-----Add---Str
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_nnh[l_ac].* TO NULL
           LET g_nnh_t.* = g_nnh[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()   
           NEXT FIELD nnh02
        #FUN-D30032-----Add---End

        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           CALL t720_b_move_back()   #MOD-850152
           INSERT INTO nnh_file
                   (nnh01,nnh02,nnh03,nnh04f,nnh04,nnh05,nnh06,nnh07
                   ,nnhud01,nnhud02,nnhud03,nnhud04,nnhud05,
                   nnhud06,nnhud07,nnhud08,nnhud09,nnhud10,
                   nnhud11,nnhud12,nnhud13,nnhud14,nnhud15,
                   nnhlegal) #FUN-980005 add legal
             VALUES(g_nng.nng01,b_nnh.nnh02,b_nnh.nnh03,
                    b_nnh.nnh04f,b_nnh.nnh04,b_nnh.nnh05,b_nnh.nnh06,b_nnh.nnh07
                   ,g_nnh[l_ac].nnhud01,g_nnh[l_ac].nnhud02,g_nnh[l_ac].nnhud03,
                   g_nnh[l_ac].nnhud04,g_nnh[l_ac].nnhud05,g_nnh[l_ac].nnhud06,
                   g_nnh[l_ac].nnhud07,g_nnh[l_ac].nnhud08,g_nnh[l_ac].nnhud09,
                   g_nnh[l_ac].nnhud10,g_nnh[l_ac].nnhud11,g_nnh[l_ac].nnhud12,
                   g_nnh[l_ac].nnhud13,g_nnh[l_ac].nnhud14,g_nnh[l_ac].nnhud15,
                   g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","nnh_file",g_nng.nng01,b_nnh.nnh02,SQLCA.sqlcode,"","ins nnh",1)  #No.FUN-660148
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              COMMIT WORK
           END IF
 
        BEFORE FIELD nnh02
           IF cl_null(g_nnh[l_ac].nnh02) THEN
              SELECT MAX(nnh02) INTO g_nnh[l_ac].nnh02 FROM nnh_file
               WHERE nnh01 = g_nng.nng01
              IF g_nnh[l_ac].nnh02 IS NULL THEN
                 LET g_nnh[l_ac].nnh02=0
              END IF
              LET g_nnh[l_ac].nnh02 = g_nnh[l_ac].nnh02 + 1
           END IF
 
        AFTER FIELD nnh02                        #check 序號是否重複
           IF NOT cl_null(g_nnh[l_ac].nnh02) THEN
              IF g_nnh[l_ac].nnh02 != g_nnh_t.nnh02 OR cl_null(g_nnh_t.nnh02) THEN
                 SELECT count(*) INTO l_n FROM nnh_file
                  WHERE nnh01 = g_nng.nng01 AND nnh02 = g_nnh[l_ac].nnh02
                 IF l_n > 0 THEN
                    LET g_nnh[l_ac].nnh02 = g_nnh_t.nnh02
                    CALL cl_err('',-239,0)
                    NEXT FIELD nnh02
                 END IF
              END IF
           END IF
 
        AFTER FIELD nnh04f
         IF NOT cl_null(g_nnh[l_ac].nnh04f) THEN
           CALL cl_digcut(g_nnh[l_ac].nnh04f,t_azi04) RETURNING g_nnh[l_ac].nnh04f
           LET g_nnh[l_ac].nnh04 = g_nnh[l_ac].nnh04f * g_nng.nng19
           CALL cl_digcut(g_nnh[l_ac].nnh04,g_azi04) RETURNING g_nnh[l_ac].nnh04
           DISPLAY BY NAME g_nnh[l_ac].nnh04f
           DISPLAY BY NAME g_nnh[l_ac].nnh04
         END IF
 
        AFTER FIELD nnh04
         IF NOT cl_null(g_nnh[l_ac].nnh04) THEN
           CALL cl_digcut(g_nnh[l_ac].nnh04,g_azi04) RETURNING g_nnh[l_ac].nnh04
         END IF
 
        AFTER FIELD nnh05
           IF NOT cl_null(g_nnh[l_ac].nnh05) THEN
              SELECT COUNT(*) INTO g_cnt FROM nma_file
               WHERE nma01 = g_nnh[l_ac].nnh05
              IF g_cnt = 0 THEN
                 CALL cl_err(g_nnh[l_ac].nnh05,'aap-007',0)
                 NEXT FIELD nnh05
              END IF
           END IF
 
        AFTER FIELD nnhud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnhud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        BEFORE DELETE                            #是否取消單身
           IF g_nnh_t.nnh02 > 0 AND g_nnh_t.nnh02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM nnh_file
               WHERE nnh01 = g_nng.nng01
                 AND nnh02 = g_nnh_t.nnh02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","nnh_file",g_nng.nng01,g_nnh_t.nnh02,SQLCA.sqlcode,"","del nnh:",1)  #No.FUN-660148
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t720_b_tot()
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_nnh[l_ac].* = g_nnh_t.*
              CLOSE t720_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_nnh[l_ac].nnh02,-263,1)
              LET g_nnh[l_ac].* = g_nnh_t.*
           ELSE
              CALL t720_b_move_back()
              UPDATE nnh_file SET nnh02 = b_nnh.nnh02,
                                  nnh03 = b_nnh.nnh03,
                                  nnh04f= b_nnh.nnh04f,
                                  nnh04 = b_nnh.nnh04,
                                  nnh05 = b_nnh.nnh05,
                                  nnh06 = b_nnh.nnh06,
                                  nnh07 = b_nnh.nnh07
                                  ,nnhud01 = g_nnh[l_ac].nnhud01,
                                  nnhud02 = g_nnh[l_ac].nnhud02,
                                  nnhud03 = g_nnh[l_ac].nnhud03,
                                  nnhud04 = g_nnh[l_ac].nnhud04,
                                  nnhud05 = g_nnh[l_ac].nnhud05,
                                  nnhud06 = g_nnh[l_ac].nnhud06,
                                  nnhud07 = g_nnh[l_ac].nnhud07,
                                  nnhud08 = g_nnh[l_ac].nnhud08,
                                  nnhud09 = g_nnh[l_ac].nnhud09,
                                  nnhud10 = g_nnh[l_ac].nnhud10,
                                  nnhud11 = g_nnh[l_ac].nnhud11,
                                  nnhud12 = g_nnh[l_ac].nnhud12,
                                  nnhud13 = g_nnh[l_ac].nnhud13,
                                  nnhud14 = g_nnh[l_ac].nnhud14,
                                  nnhud15 = g_nnh[l_ac].nnhud15
                WHERE nnh01=g_nng.nng01 AND nnh02=g_nnh_t.nnh02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","nnh_file",g_nng.nng01,g_nnh_t.nnh02,SQLCA.sqlcode,"","upd nnh",1)  #No.FUN-660148
                 LET g_nnh[l_ac].* = g_nnh_t.*
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D30032 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd='u' THEN
                 LET g_nnh[l_ac].* = g_nnh_t.*
              #FUN-D30032--add--str--
              ELSE
                 CALL g_nnh.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30032--add--end--    
              END IF
              CLOSE t720_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D30032 Add
           CLOSE t720_bcl
           COMMIT WORK
           CALL t720_b_tot()
 
        ON ACTION delete_whole_body
           SELECT COUNT(*) INTO l_n FROM nnh_file,nmd_file
             WHERE nnh01=g_nng.nng01 AND nnh06=nmd01 AND nmd30 <> 'X'
           IF l_n>0 THEN
              CALL cl_err(g_nng.nng01,'aap-741',0)
              NEXT FIELD nnh02
           END IF
           DELETE FROM nnh_file WHERE nnh01=g_nng.nng01
           CALL t720_b_fill(' 1=1')
           CALL t720_b_tot()
           EXIT INPUT
 
        ON ACTION auto_gen_body
           SELECT COUNT(*) INTO l_n FROM nnh_file WHERE nnh01=g_nng.nng01
           IF l_n>0 THEN
              CALL cl_err('','anm-996',0)
              NEXT FIELD nnh02
           END IF
           IF cl_confirm('aap-701') THEN
              CALL t720_g_b()
              CALL t720_b_fill(' 1=1')
              CALL t720_b_tot()
              EXIT INPUT
           END IF
 
        ON ACTION controls                       # No.FUN-6B0030
           CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0030
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(nnh02) AND l_ac > 1 THEN
                LET g_nnh[l_ac].* = g_nnh[l_ac-1].*
                LET g_nnh[l_ac].nnh02 = NULL
                NEXT FIELD nnh02
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
 
    END INPUT
 
    LET g_nng.nngmodu = g_user
    LET g_nng.nngdate = g_today
    UPDATE nng_file SET nngmodu = g_nng.nngmodu,nngdate = g_nng.nngdate
     WHERE nng01 = g_nng.nng01
    DISPLAY BY NAME g_nng.nngmodu,g_nng.nngdate
 
    CLOSE t720_bcl
    COMMIT WORK
    CALL t720_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t720_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_nng.nng01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM nng_file ",
                  "  WHERE nng01 LIKE '",l_slip,"%' ",
                  "    AND nng01 > '",g_nng.nng01,"'"
      PREPARE t720_pb1 FROM l_sql 
      EXECUTE t720_pb1 INTO l_cnt 
      
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
         #CALL t720_x() #FUN-D20035 mark
         CALL t720_x(1) #FUN-D20035 add
         IF g_nng.nngconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_nng.nngconf,"","","",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file
          WHERE nppsys='NM' AND npp00=17 AND npp01=g_nng.nng01 AND npp011=0
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=17 AND npq01=g_nng.nng01 AND npq011=0
         DELETE FROM tic_file WHERE tic04 = g_nng.nng01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM nng_file WHERE nng01 = g_nng.nng01
         INITIALIZE g_nng.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t720_baskey()
DEFINE l_wc2  LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200)
 
   CONSTRUCT l_wc2 ON nnh02,nnh03,nnh04,nnh05,nnh06,nnh07
                 FROM s_nnh[1].nnh02,s_nnh[1].nnh03,s_nnh[1].nnh04,
                      s_nnh[1].nnh05,s_nnh[1].nnh06,s_nnh[1].nnh07
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
   IF INT_FLAG THEN RETURN END IF
   CALL t720_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t720_b_fill(p_wc2)          #BODY FILL UP
DEFINE p_wc2  LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(300)
 
    LET g_sql = "SELECT nnh02,nnh03,nnh04f,nnh04,nnh05,nnh06,nmd02,nmd12,nnh07 ",
                "       ,nnhud01,nnhud02,nnhud03,nnhud04,nnhud05,",
                "       nnhud06,nnhud07,nnhud08,nnhud09,nnhud10,",
                "       nnhud11,nnhud12,nnhud13,nnhud14,nnhud15", 
                " FROM nnh_file LEFT JOIN nmd_file ON nnh06 = nmd_file.nmd01",
                " WHERE nnh01 ='",g_nng.nng01,"'",             #單頭
                "   AND ",p_wc2 CLIPPED,                     #單身
                " ORDER BY nnh02"
 
    PREPARE t720_pb FROM g_sql
    DECLARE nnh_curs CURSOR FOR t720_pb
 
    CALL g_nnh.clear()
    LET g_cnt = 1
    FOREACH nnh_curs INTO g_nnh[g_cnt].*   #單身 ARRAY 填充
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_nnh.deleteElement(g_cnt)   #取消 Array Element
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
FUNCTION t720_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnh TO s_nnh.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_aza.aza63 = 'N' THEN
            CALL cl_set_act_visible("maintain_entry_sheet2",FALSE)  
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
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION first
         CALL t720_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t720_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t720_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t720_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t720_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         IF g_nng.nngconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_nng.nngconf,"","","",g_void,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
 
      ON ACTION gen_n_p  # 產生應付票據
         LET g_action_choice="gen_n_p"
         EXIT DISPLAY
 
      ON ACTION undo_np  # 應付票據還原 #No.8321
         LET g_action_choice="undo_np"
         EXIT DISPLAY
 
      ON ACTION gen_entry_sheet  #分錄底稿產生
         LET g_action_choice="gen_entry_sheet"
         EXIT DISPLAY
 
      ON ACTION maintain_entry_sheet  #分錄底稿維護
         LET g_action_choice="maintain_entry_sheet"
         EXIT DISPLAY
 
      ON ACTION maintain_entry_sheet2  #分錄底稿二維護
         LET g_action_choice="maintain_entry_sheet2"
         EXIT DISPLAY
 
      ON ACTION memo    #備註
         LET g_action_choice="memo"
         EXIT DISPLAY
 
      ON ACTION confirm     #確認
         LET g_action_choice="confirm"
         EXIT DISPLAY
 
      ON ACTION undo_confirm   #取消確認
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
 
      ON ACTION void    #作廢
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20035 add str
      ON ACTION undo_void    #作廢
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20035 add end   
      ON ACTION cr_quota
         LET g_action_choice = "cr_quota"
         EXIT DISPLAY
 
      ON ACTION secur_paper_fin_lone
         LET g_action_choice="secur_paper_fin_lone"
         EXIT DISPLAY
      
      ON ACTION collateral_fin_loan
         LET g_action_choice="collateral_fin_loan"
         EXIT DISPLAY
      
      ON ACTION secur_bill_fin_lone
         LET g_action_choice="secur_bill_fin_lone"
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
 
      ON ACTION carry_voucher #傳票拋轉                                                                                             
         LET g_action_choice="carry_voucher"                                                                                        
         EXIT DISPLAY                                                                                                               
                                                                                                                                    
      ON ACTION undo_carry_voucher #傳票拋轉還原                                                                                    
         LET g_action_choice="undo_carry_voucher"                                                                                   
         EXIT DISPLAY                                                                                                               
 
      ON ACTION exporttoexcel       #FUN-4B0008
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      ON ACTION controls                       # No.FUN-6B0030
         CALL cl_set_head_visible("","AUTO")      # No.FUN-6B0030
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t720_b_move_to()
   LET g_nnh[l_ac].nnh02 = b_nnh.nnh02
   LET g_nnh[l_ac].nnh03 = b_nnh.nnh03
   LET g_nnh[l_ac].nnh04f= b_nnh.nnh04f
   LET g_nnh[l_ac].nnh04 = b_nnh.nnh04
   LET g_nnh[l_ac].nnh05 = b_nnh.nnh05
   LET g_nnh[l_ac].nnh06 = b_nnh.nnh06
   LET g_nnh[l_ac].nnh07 = b_nnh.nnh07
   LET g_nnh[l_ac].nnhud01 = b_nnh.nnhud01
   LET g_nnh[l_ac].nnhud02 = b_nnh.nnhud02
   LET g_nnh[l_ac].nnhud03 = b_nnh.nnhud03
   LET g_nnh[l_ac].nnhud04 = b_nnh.nnhud04
   LET g_nnh[l_ac].nnhud05 = b_nnh.nnhud05
   LET g_nnh[l_ac].nnhud06 = b_nnh.nnhud06
   LET g_nnh[l_ac].nnhud07 = b_nnh.nnhud07
   LET g_nnh[l_ac].nnhud08 = b_nnh.nnhud08
   LET g_nnh[l_ac].nnhud09 = b_nnh.nnhud09
   LET g_nnh[l_ac].nnhud10 = b_nnh.nnhud10
   LET g_nnh[l_ac].nnhud11 = b_nnh.nnhud11
   LET g_nnh[l_ac].nnhud12 = b_nnh.nnhud12
   LET g_nnh[l_ac].nnhud13 = b_nnh.nnhud13
   LET g_nnh[l_ac].nnhud14 = b_nnh.nnhud14
   LET g_nnh[l_ac].nnhud15 = b_nnh.nnhud15
END FUNCTION
 
FUNCTION t720_b_move_back()
   LET b_nnh.nnh02 = g_nnh[l_ac].nnh02
   LET b_nnh.nnh03 = g_nnh[l_ac].nnh03
   LET b_nnh.nnh04f= g_nnh[l_ac].nnh04f
   LET b_nnh.nnh04 = g_nnh[l_ac].nnh04
   LET b_nnh.nnh05 = g_nnh[l_ac].nnh05
   LET b_nnh.nnh06 = g_nnh[l_ac].nnh06
   LET b_nnh.nnh07 = g_nnh[l_ac].nnh07
   LET b_nnh.nnhud01 = g_nnh[l_ac].nnhud01
   LET b_nnh.nnhud02 = g_nnh[l_ac].nnhud02
   LET b_nnh.nnhud03 = g_nnh[l_ac].nnhud03
   LET b_nnh.nnhud04 = g_nnh[l_ac].nnhud04
   LET b_nnh.nnhud05 = g_nnh[l_ac].nnhud05
   LET b_nnh.nnhud06 = g_nnh[l_ac].nnhud06
   LET b_nnh.nnhud07 = g_nnh[l_ac].nnhud07
   LET b_nnh.nnhud08 = g_nnh[l_ac].nnhud08
   LET b_nnh.nnhud09 = g_nnh[l_ac].nnhud09
   LET b_nnh.nnhud10 = g_nnh[l_ac].nnhud10
   LET b_nnh.nnhud11 = g_nnh[l_ac].nnhud11
   LET b_nnh.nnhud12 = g_nnh[l_ac].nnhud12
   LET b_nnh.nnhud13 = g_nnh[l_ac].nnhud13
   LET b_nnh.nnhud14 = g_nnh[l_ac].nnhud14
   LET b_nnh.nnhud15 = g_nnh[l_ac].nnhud15
END FUNCTION
 
FUNCTION t720_u()
DEFINE l_year,l_month ,l_n  LIKE type_file.num5,    #No.FUN-680107 SMALLINT
       l_flag   LIKE type_file.chr1,                #No.FUN-680107 VARCHAR(1)
       l_nnh01  LIKE nnh_file.nnh01
 
   IF s_anmshut(0) THEN RETURN END IF
   IF cl_null(g_nng.nng01) THEN CALL cl_err('',-400,2) RETURN END IF
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
   IF g_nng.nngconf='Y' THEN CALL cl_err('','anm-137',1) RETURN END IF
   IF g_nng.nngconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t720_cl USING g_nng.nng01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_nng.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   LET g_nng_o.* = g_nng.*
   LET g_nng_t.* = g_nng.*
   CALL t720_show()
   WHILE TRUE
      CALL t720_i('u')
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_nng.* = g_nng_t.* CALL t720_show() ROLLBACK WORK RETURN
      END IF
      UPDATE nng_file SET * = g_nng.* WHERE nng01 = g_nng_t.nng01
      IF STATUS THEN 
         CALL cl_err3("upd","ngg_file",g_nng_t.nng01,"",STATUS,"","up nng",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF
      IF g_nng.nng03 != g_nng_t.nng03 THEN            # 更改單號
         UPDATE npp_file SET npp02=g_nng.nng03
          WHERE npp01=g_nng.nng01 AND npp00=17 AND npp011=0
            AND nppsys = 'NM'
         IF STATUS THEN 
            CALL cl_err3("upd","npp_file",g_nng_t.nng01,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
         END IF
      END IF
      #--MOD-C30451--add--str--
      IF g_nng_t.nng11 != g_nng.nng11 THEN 
         IF g_nng.nng15 MATCHES '[12]' THEN
            IF cl_confirm('aap-701') THEN
               DELETE FROM nnh_file WHERE nnh01=g_nng.nng01
               CALL t720_g_b()
               CALL t720_b_fill(' 1=1')
               CALL t720_b_tot()
            END IF
         END IF
      END IF 
      #--MOD-C30451--add--end--
      EXIT WHILE
   END WHILE
   COMMIT WORK
   CALL cl_flow_notify(g_nng.nng01,'U')
END FUNCTION
 
FUNCTION t720_npp02(p_npptype) #FUN-680088
DEFINE p_npptype  LIKE npp_file.npptype  #FUN-680088
 
  IF g_nng.nngglno IS NULL OR g_nng.nngglno=' ' THEN
     UPDATE npp_file SET npp02=g_nng.nng03
      WHERE npp01=g_nng.nng01 AND npp00=17 AND npp011=0
        AND nppsys = 'NM'
        AND npptype= p_npptype  #FUN-680088
     IF STATUS THEN 
        CALL cl_err3("upd","npp_file",g_nng.nng01,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
        END IF
  END IF
END FUNCTION
 
FUNCTION t720_r()
   IF s_anmshut(0) THEN RETURN END IF
   IF cl_null(g_nng.nng01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
   IF g_nng.nngconf='Y' THEN CALL cl_err('','anm-137',1) RETURN END IF
   IF g_nng.nngconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_nng.nngglno IS NOT NULL THEN
      CALL cl_err(g_nng.nng01,'anm-230',0)   #No:8321 有中文
      RETURN
   END IF
 
   SELECT COUNT(*) INTO g_cnt FROM nnh_file
    WHERE nnh01 = g_nng.nng01
      AND nnh06 IS NOT NULL
   IF g_cnt > 0 THEN RETURN END IF
   LET g_success = 'Y'
   BEGIN WORK
   OPEN t720_cl USING g_nng.nng01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_nng.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
      CLOSE t720_cl ROLLBACK WORK RETURN
   END IF
   CALL t720_show()
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nng01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nng.nng01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM nng_file WHERE nng01 = g_nng.nng01
      IF STATUS THEN 
         CALL cl_err3("del","nng_file",g_nng.nng01,"",STATUS,"","del nng:",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF
      DELETE FROM nnh_file WHERE nnh01 = g_nng.nng01
      IF STATUS THEN 
         CALL cl_err3("del","nnh_file",g_nng.nng01,"",STATUS,"","del nnh:",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF
      DELETE FROM npp_file
         WHERE nppsys='NM' AND npp00=17 AND npp01=g_nng.nng01 AND npp011=0
      IF STATUS THEN 
         CALL cl_err3("del","npp_file",g_nng.nng01,"",STATUS,"","del npp:",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF
      DELETE FROM npq_file
         WHERE npqsys='NM' AND npq00=17 AND npq01=g_nng.nng01 AND npq011=0
      IF STATUS THEN 
         CALL cl_err3("del","npq_file",g_nng.nng01,"",STATUS,"","del npq:",1)  #No.FUN-660148
         ROLLBACK WORK RETURN END IF
      
      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_nng.nng01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_nng.nng01,"",STATUS,"","del tic:",1)
         ROLLBACK WORK 
         RETURN
      END IF
      #FUN-B40056--add--end--
 
      CLEAR FORM
      CALL g_nnh.clear()
      INITIALIZE g_nng.* TO NULL
      OPEN t720_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t720_cs
         CLOSE t720_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t720_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t720_cs
         CLOSE t720_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t720_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t720_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t720_fetch('/')
      END IF
   END IF
   COMMIT WORK
   CALL cl_flow_notify(g_nng.nng01,'D')
END FUNCTION
 
#FUNCTION t720_x() #FUN-D20035 mark
FUNCTION t720_x(p_type) #FUN-D20035 add
   DEFINE p_type    LIKE type_file.chr1  #FUN-D20035 add   
    IF s_anmshut(0) THEN RETURN END IF
    IF cl_null(g_nng.nng01) THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
    IF g_nng.nngconf='Y' THEN CALL cl_err('','anm-137',1) RETURN END IF
    IF g_nng.nngglno IS NOT NULL THEN CALL cl_err('','agl-892',0) RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM nnh_file
     WHERE nnh01 = g_nng.nng01
       AND nnh06 IS NOT NULL
    IF g_cnt > 0 THEN RETURN END IF
    #FUN-D20035---begin 
    IF p_type = 1 THEN 
       IF g_nng.nngconf='X' THEN RETURN END IF
    ELSE
       IF g_nng.nngconf<>'X' THEN RETURN END IF
    END IF 
    #FUN-D20035---end     
    LET g_success = 'Y'
    BEGIN WORK
    OPEN t720_cl USING g_nng.nng01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_nng.*
    IF SQLCA.SQLCODE THEN
       CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
       CLOSE t720_cl ROLLBACK WORK RETURN
    END IF
    CALL t720_show()
    IF cl_void(0,0,g_nng.nngconf) THEN
      IF g_nng.nngconf='N' THEN    #切換為作廢
         DELETE FROM npp_file
          WHERE nppsys='NM' AND npp00=17 AND npp01=g_nng.nng01 AND npp011=0
         IF STATUS THEN
            CALL cl_err3("del","npp_file",g_nng.nng01,"",STATUS,"","del npp:",1)  #No.FUN-660148
             LET g_success='N'
         END IF
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=17 AND npq01=g_nng.nng01 AND npq011=0
         IF STATUS THEN
            CALL cl_err3("del","npq_file",g_nng.nng01,"",STATUS,"","del npq:",1)  #No.FUN-660148
            LET g_success='N'
         END IF

         #FUN-B40056--add--str--
         DELETE FROM tic_file WHERE tic04 = g_nng.nng01
         IF STATUS THEN
            CALL cl_err3("del","tic_file",g_nng.nng01,"",STATUS,"","del tic:",1)
            LET g_success='N'
         END IF
         #FUN-B40056--add--end--
      
         LET g_nng.nngconf = 'X'
      ELSE
         LET g_nng.nngconf = 'N'
      END IF
#No:FUN-C60006---add--star---
      LET g_nng.nngmodu = g_user
      LET g_nng.nngdate = g_today
      DISPLAY BY NAME g_nng.nngmodu
      DISPLAY BY NAME g_nng.nngdate
#No:FUN-C60006---add--end---
      UPDATE nng_file SET
                          nngconf=g_nng.nngconf,
      #No:FUN-C60006---add--star---
                          nngmodu = g_user,
                          nngdate = g_today
      #No:FUN-C60006---add--end---
       WHERE nng01 = g_nng.nng01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","nng_file",g_nng.nng01,"",STATUS,"","",1)  #No.FUN-660148
         LET g_success='N'
      END IF
   END IF
   SELECT nngconf INTO g_nng.nngconf FROM nng_file
    WHERE nng01 = g_nng.nng01
   DISPLAY BY NAME g_nng.nngconf
   CLOSE t720_cl
   IF g_success='Y' THEN
      CALL cl_cmmsg(1) COMMIT WORK
      CALL cl_flow_notify(g_nng.nng01,'V')
   ELSE
      CALL cl_rbmsg(1) ROLLBACK WORK
   END IF
END FUNCTION
 
FUNCTION t720_g_b()
   DEFINE l_nnh         RECORD LIKE nnh_file.*
   DEFINE i,j,yy,mm,dd  LIKE type_file.num10    #No.FUN-680107 INTEGER
   DEFINE totf,tot      LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
 
   IF g_nng.nng15 = '3' THEN RETURN END IF
   INITIALIZE l_nnh.* TO NULL
   LET yy= YEAR(g_nng.nng101) USING '&&&&'
   LET mm=MONTH(g_nng.nng101)
   LET dd=  DAY(g_nng.nng101)
   LET totf=0 LET tot=0
   LET g_success='Y'
   #取原幣抓取小數位數
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_nng.nng18
    IF STATUS THEN LET t_azi04 = 0 END IF
    BEGIN WORK
    OPEN t720_cl USING g_nng.nng01
    IF STATUS THEN
       CALL cl_err("OPEN t720_cl:", STATUS, 1)
       CLOSE t720_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t720_cl INTO g_nng.*
    IF SQLCA.SQLCODE THEN
       CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
       CLOSE t720_cl ROLLBACK WORK RETURN
    END IF
    CALL s_showmsg_init()    #No.FUN-710024
    FOR i = 1 TO g_nng.nng11
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
 
       LET l_nnh.nnh01 = g_nng.nng01
       LET l_nnh.nnh02 = i
       LET j=dd
       SELECT nnn05 INTO l_nnh.nnh07 FROM nnn_file WHERE nnn01 = g_nng.nng24
       IF cl_null(l_nnh.nnh07) THEN LET l_nnh.nnh07='N' END IF
 
       WHILE TRUE
          LET l_nnh.nnh03 = NULL
          LET l_nnh.nnh03 = MDY(mm,j,yy)      # 如果dd=31
          IF l_nnh.nnh03 IS NOT NULL OR j<=0 OR j IS NULL THEN EXIT WHILE END IF
          LET j=j-1
       END WHILE
       IF i<g_nng.nng11
          THEN LET l_nnh.nnh04f= g_nng.nng20/g_nng.nng11
               LET l_nnh.nnh04 = g_nng.nng22/g_nng.nng11
               CALL cl_digcut(l_nnh.nnh04f,t_azi04) RETURNING l_nnh.nnh04f
               CALL cl_digcut(l_nnh.nnh04,g_azi04) RETURNING l_nnh.nnh04
          ELSE LET l_nnh.nnh04f= g_nng.nng20-totf
               LET l_nnh.nnh04 = g_nng.nng22-tot
       END IF
       LET l_nnh.nnhlegal= g_legal
       INSERT INTO nnh_file VALUES(l_nnh.*)
       IF STATUS THEN
          LET g_showmsg = l_nnh.nnh01,"/",l_nnh.nnh02                   #No.FUN-710024
          CALL s_errmsg('nnh01,nnh02',g_showmsg,'ins nnh:',STATUS,1)    #No.FUN-710024
          LET g_success='N'CONTINUE  FOR      #No.FUN-710024
       END IF
       LET totf=totf+l_nnh.nnh04f
       LET tot =tot +l_nnh.nnh04
 
       CASE g_nng.nng12
            WHEN '1'  LET mm=mm+1  #月付
            WHEN '2'  LET mm=mm+3  #季付
            WHEN '3'  LET mm=mm+6  #半年
            WHEN '4'  LET mm=mm+12 #一年
       END CASE
       IF mm>12 THEN LET yy=yy+1 LET mm=mm-12 END IF
   END FOR
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
   CALL s_showmsg() #No.FUN-710024
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
# 產生票據資料
FUNCTION t720_g_np()
   DEFINE l_nmd         RECORD LIKE nmd_file.*
   DEFINE l_nmf         RECORD LIKE nmf_file.*
   DEFINE l_nnf         RECORD LIKE nnf_file.*
   DEFINE l_nnh         RECORD LIKE nnh_file.*  #No.8321
   DEFINE l_n           LIKE type_file.num10,   #No.FUN-680107 INTEGER
          l_cnt         LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_start,l_end LIKE nmd_file.nmd01     #No.FUN-680107 VARCHAR(10)
   DEFINE l_slip        LIKE type_file.chr5     #No.FUN-680107 VARCHAR(5) #No.FUN-560002
   DEFINE l_msg         LIKE ze_file.ze03       #No.FUN-680107 VARCHAR(50)
   DEFINE l_nnn05       LIKE nnn_file.nnn05
   DEFINE li_result     LIKE type_file.num5     #No.FUN-560002  #No.FUN-680107 SMALLINT
 
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
   SELECT nnn05 INTO l_nnn05 FROM nnn_file WHERE nnn01 = g_nng.nng24
   IF l_nnn05 ='N' THEN CALL cl_err(l_nnn05,'anm-400',1) RETURN END IF #No:8321   #CHI-740030
   IF g_nng.nngconf = 'N' THEN RETURN END IF
   IF g_nng.nng15 MATCHES '[23]' THEN         #No:8321
      CALL cl_err(g_nng.nng15,'anm-401',0) RETURN   #CHI-740030
   END IF
 
   SELECT COUNT(*) INTO l_n FROM nnh_file,nmd_file
     WHERE nnh01=g_nng.nng01 AND nnh06=nmd01
   IF l_n>0 THEN
      CALL cl_err('','aap-741',1) RETURN       #No:8321
   END IF
 
 
   BEGIN WORK
   LET g_success = 'Y'
   CALL t720_t1()
   IF NOT cl_sure(18,10) THEN RETURN END IF      #No:8321
   IF g_success='N' THEN ROLLBACK WORK RETURN END IF
   LET l_nmd.nmd01=g_nng.nng41
   CALL s_auto_assign_no("anm",l_nmd.nmd01,g_nng.nng43,"1","nng_file","nng01","","","")
   RETURNING li_result,l_nmd.nmd01
   IF (NOT li_result) THEN
       ROLLBACK WORK
       RETURN
   END IF
   LET l_slip = NULL
 
   LET l_cnt = 1
   LET l_start = null
   LET l_end = null
 
   DECLARE t720_g_np CURSOR FOR
    SELECT * FROM nnh_file                #No:8321
     WHERE nnh01 = g_nng.nng01
       AND (nnh06 IS NULL OR nnh06=' ')
       AND nnh07 = 'Y'
   CALL s_showmsg_init()  #No.FUN-710024
   FOREACH t720_g_np INTO l_nnh.*         #No:8321
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN  #No:8321
         LET g_showmsg = g_nng.nng01,"/",'Y'     #No.FUN-710024
         CALL s_errmsg('nnh01,nnh07',g_showmsg,'foreach nnh',STATUS,0)  #No.FUN-710024
         EXIT FOREACH 
      END IF  
      INITIALIZE l_nmd.* TO NULL
      LET l_nmd.nmd01= g_nng.nng41     #No.FUN-550057
   CALL s_auto_assign_no("anm",l_nmd.nmd01,g_nng.nng02,"1","nng_file","nng01","","","")
   RETURNING li_result,l_nmd.nmd01
   IF (NOT li_result) THEN
       EXIT FOREACH
   END IF
      IF l_nnh.nnh05 IS NOT NULL
         THEN LET l_nmd.nmd03 = l_nnh.nnh05
         ELSE LET l_nmd.nmd03 = g_nng.nng42
      END IF
      LET l_nmd.nmd04 = l_nnh.nnh04f
      LET l_nmd.nmd05 = l_nnh.nnh03
      LET l_nmd.nmd06 = g_nng.nng44
      LET l_nmd.nmd07 = g_nng.nng43
      LET l_nmd.nmd08 = g_nng.nng48
      LET l_nmd.nmd09 = g_nng.nng49
      LET l_nmd.nmd10 = l_nnh.nnh01
      LET l_nmd.nmd101= l_nnh.nnh02
      LET l_nmd.nmd11 = l_nnh.nnh05
      LET l_nmd.nmd12 = 'X'
      LET l_nmd.nmd13 = g_nng.nng02
      LET l_nmd.nmd14 = '3'
      LET l_nmd.nmd17 = g_nng.nng50
      LET l_nmd.nmd18 = g_nng.nng47
      LET l_nmd.nmd19 = g_nng.nng19
      LET l_nmd.nmd20 = g_nng.nng45
      LET l_nmd.nmd21 = g_nng.nng18
      LET l_nmd.nmd23 = g_nms.nms15
      IF g_aza.aza63 = 'Y' THEN
         LET l_nmd.nmd231= g_nms.nms151
      END IF
      LET l_nmd.nmd24 = g_nng.nng49
      LET l_nmd.nmd25 = g_nng.nng17
      LET l_nmd.nmd26 = l_nnh.nnh04
      LET l_nmd.nmd30 = 'N'
      LET l_nmd.nmd31 = g_book_no      #No.FUN-870057
      LET l_nmd.nmd34 = g_plant
      LET l_nmd.nmd40 = '1'            #MOD-B30357
      LET l_nmd.nmd51 = '2'
      LET l_nmd.nmd52 = g_nng.nng01
      LET l_nmd.nmd53 = 'Y'
      LET l_nmd.nmduser=g_user
      LET l_nmd.nmdgrup=g_grup
      LET l_nmd.nmddate=TODAY
      IF l_cnt = 1 THEN
         LET l_start = l_nmd.nmd01
         LET l_end = l_nmd.nmd01
      ELSE
         LET l_end = l_nmd.nmd01
      END IF
       LET l_nmd.nmd33=l_nmd.nmd19
 
      LET l_nmd.nmdlegal= g_legal
      LET l_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
      LET l_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO nmd_file VALUES(l_nmd.*)
      IF STATUS THEN
         CALL s_errmsg('nmd01',l_nmd.nmd01,'ins nmd:',STATUS,1)  #No.FUN-710024
         LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710024
      END IF
   #------------------------------------------------------------------
      INITIALIZE l_nmf.* TO NULL
      LET l_nmf.nmf01=l_nmd.nmd01
      LET l_nmf.nmf02=g_nng.nng02         #No:8321
      LET l_nmf.nmf03="00001"
      LET l_nmf.nmf04=g_user
       LET l_nmf.nmf05='0'          #No.MOD-510039
      LET l_nmf.nmf06='X'
      LET l_nmf.nmf07=l_nmd.nmd08
      LET l_nmf.nmf08=0
      LET l_nmf.nmf09=l_nmd.nmd19
 
      LET l_nmf.nmflegal= g_legal
 
      INSERT INTO nmf_file VALUES(l_nmf.*)              # 注意多工廠環境
      IF STATUS THEN
         LET g_showmsg = l_nmf.nmf01,"/",l_nmf.nmf03                 #No.FUN-710024
         CALL s_errmsg('nmf01,nmf03',g_showmsg,'ins nmf:',STATUS,1)  #No.FUN-710024
         LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710024
      END IF
      UPDATE nnh_file SET nnh05 = l_nmd.nmd03,nnh06 = l_nmd.nmd01    #MOD-840250
        WHERE nnh01 = l_nnh.nnh01       #No:8321
          AND nnh02 = l_nnh.nnh02
      IF STATUS THEN
         LET g_showmsg = l_nnh.nnh01,"/",l_nnh.nnh02                   #No.FUN-710024
         CALL s_errmsg('nnh01,nnh02',g_showmsg,'upd nnh:',STATUS,1)    #No.FUN-710024
         LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710024
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980005 add plant & legal 
     VALUES ('anmt720',g_user,g_today,'U nmf',g_nng.nng01,'UPDATE nnf',g_plant,g_legal)
   CALL s_showmsg()   #No.FUN-710024
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CALL t720_b_fill(' 1=1')  #No:8321
   MESSAGE 'Start No :',l_start,' End No :',l_end
END FUNCTION
 
 
# 還原票據資料 No:8321 add
FUNCTION t720_d_np()
   DEFINE l_nmd         RECORD LIKE nmd_file.*
   DEFINE l_nnh         RECORD LIKE nnh_file.*
   DEFINE l_n           LIKE type_file.num10
 
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
   SELECT COUNT(*) INTO l_n FROM nnl_file
     WHERE nnl04=g_nng.nng01 
   IF g_nng.nngconf = 'Y' AND l_n>0 THEN
      CALL cl_err(g_nng.nng01,'anm1001',0)
      RETURN 
   END IF
   IF NOT cl_sure(18,10) THEN RETURN END IF
   BEGIN WORK
   LET g_success='Y'
   DECLARE t720_d_np CURSOR FOR
    SELECT * FROM nnh_file
     WHERE nnh01 = g_nng.nng01
       AND nnh06<>' '
       AND nnh07 = 'Y'
   CALL s_showmsg_init()    #No.FUN-710024
   FOREACH t720_d_np INTO l_nnh.*
     IF g_success='N' THEN                                                                                                         
        LET g_totsuccess='N'                                                                                                       
        LET g_success="Y"                                                                                                          
     END IF                                                                                                                        
 
     IF STATUS THEN                   #No:8321
        CALL s_errmsg('nnh01,nnh07',g_showmsg,'nnh',STATUS,1)   #No.FUN-710024
        LET g_success='N'
        CONTINUE FOREACH              #No.FUN-710024
     END IF    
     INITIALIZE l_nmd.* TO NULL
     SELECT * INTO l_nmd.* FROM nmd_file
      WHERE nmd10=l_nnh.nnh01 AND nmd101=l_nnh.nnh02
     IF cl_null(l_nmd.nmd02) OR l_nmd.nmd12='9' THEN
        IF cl_null(l_nmd.nmd02) THEN
           DELETE FROM nmd_file
            WHERE nmd10=l_nnh.nnh01 AND nmd101=l_nnh.nnh02
        END IF
     ELSE
        LET g_showmsg = l_nnh.nnh01,"/",l_nnh.nnh02                   #No.FUN-710024
        CALL s_errmsg('nmd10,nmd101',g_showmsg,l_nnh.nnh01,'',1)      #No.FUN-710024
        LET g_success='N' CONTINUE FOREACH  #No.FUN-710024
     END IF
     DELETE FROM nmf_file WHERE nmf01=l_nmd.nmd01
     UPDATE nnh_file SET nnh06 = ''
      WHERE nnh01 = l_nnh.nnh01 AND nnh02 = l_nnh.nnh02
     IF STATUS THEN
        LET g_showmsg = l_nnh.nnh01,"/",l_nnh.nnh02                   #No.FUN-710024
        CALL s_errmsg('nnh01,nnh02',g_showmsg,'upd nnh:',STATUS,1)    #No.FUN-710024
        LET g_success = 'N' CONTINUE FOREACH   #No.FUN-710024
     END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
   CALL s_showmsg()   #No.FUN-710024
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CALL t720_b_fill(' 1=1')
END FUNCTION
 
FUNCTION t720_g_np_1() # Thomas 020808 Old function so must be saved沒有用了
   DEFINE l_nnh         RECORD LIKE nnh_file.*
   DEFINE l_nmd         RECORD LIKE nmd_file.*
   DEFINE l_nmf         RECORD LIKE nmf_file.*
   DEFINE l_n           LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE l_nnn05       LIKE nnn_file.nnn05
   DEFINE l_msg         LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(50)
   DEFINE li_result     LIKE type_file.num5    #No.FUN-560002  #No.FUN-680107 SMALLINT
 
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
   IF g_nng.nng15 MATCHES '[23]' THEN RETURN END IF
   IF g_nng.nngconf = 'N' THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM nnh_file,nmd_file
     WHERE nnh01=g_nng.nng01 AND nnh06=nmd01
   IF l_n>0 THEN
      CALL cl_getmsg('aap-741',g_lang) RETURNING l_msg
      ERROR l_msg CLIPPED  RETURN
   END IF
   SELECT nnn05 INTO l_nnn05 FROM nnn_file WHERE nnn01=g_nng.nng24
   IF l_nnn05 = 'N' THEN
      CALL cl_err(g_nng.nng24,'anm-656',0) RETURN
   END IF
 
   INITIALIZE l_nmd.* TO NULL
   LET g_nng_t.* = g_nng.*
   LET g_success='Y'
   BEGIN WORK
   OPEN t720_cl USING g_nng.nng01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_nng.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
      CLOSE t720_cl ROLLBACK WORK RETURN
   END IF
   CALL t720_t1()
   IF g_success='N' THEN ROLLBACK WORK RETURN END IF
   LET l_nmd.nmd01=g_nng.nng41
   CALL s_auto_assign_no("anm",l_nmd.nmd01,g_nng.nng43,"1","nng_file","nng01","","","")
   RETURNING li_result,l_nmd.nmd01
   IF (NOT li_result) THEN
       ROLLBACK WORK
       RETURN
   END IF
   DECLARE t720_t_c CURSOR FOR
    SELECT * FROM nnh_file
     WHERE nnh01=g_nng.nng01
       AND nnh06 IS NULL OR nnh06=' '
   CALL s_showmsg_init()    #No.FUN-710024
   FOREACH t720_t_c INTO l_nnh.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN 
         CALL s_errmsg('nnh01',g_nng.nng01,'for t720_t_c:',STATUS,0)  #No.FUN-710024
         EXIT FOREACH 
      END IF
      IF l_nnh.nnh05 IS NOT NULL
         THEN LET l_nmd.nmd03 = l_nnh.nnh05
         ELSE LET l_nmd.nmd03 = g_nng.nng42
      END IF
      LET l_nmd.nmd04 = l_nnh.nnh04f
      LET l_nmd.nmd05 = l_nnh.nnh03
      LET l_nmd.nmd06 = g_nng.nng44
      LET l_nmd.nmd07 = g_nng.nng43
      LET l_nmd.nmd08 = g_nng.nng48
      LET l_nmd.nmd09 = g_nng.nng49
      LET l_nmd.nmd10 = l_nnh.nnh01
      LET l_nmd.nmd101= l_nnh.nnh02
      LET l_nmd.nmd11 = l_nnh.nnh05
      LET l_nmd.nmd12 = 'X'
      LET l_nmd.nmd13 = g_nng.nng43
      LET l_nmd.nmd14 = '3'
      LET l_nmd.nmd17 = g_nng.nng50
      LET l_nmd.nmd18 = g_nng.nng47
      LET l_nmd.nmd19 = g_nng.nng19
      LET l_nmd.nmd20 = g_nng.nng45
      LET l_nmd.nmd21 = g_nng.nng18
      LET l_nmd.nmd23 = g_nms.nms15
      IF g_aza.aza63 = 'Y' THEN
         LET l_nmd.nmd231= g_nms.nms151
      END IF
      LET l_nmd.nmd24 = g_nng.nng49
      LET l_nmd.nmd25 = g_nng.nng17
      LET l_nmd.nmd26 = l_nmd.nmd04 * l_nmd.nmd19
      LET l_nmd.nmd30 = 'N'
      LET l_nmd.nmd34 = g_plant
      LET l_nmd.nmd40 = '1'            #MOD-B30357
      LET l_nmd.nmd51 = '2'
      LET l_nmd.nmd52 = g_nng.nng01
      LET l_nmd.nmd53 = 'Y'
      LET l_nmd.nmduser=g_user
      LET l_nmd.nmdgrup=g_grup
      IF g_success='N' THEN EXIT FOREACH END IF
      MESSAGE l_nmd.nmd01, l_nmd.nmd02
 
      LET l_nmd.nmdlegal= g_legal
      LET l_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
      LET l_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO nmd_file VALUES(l_nmd.*)
      IF STATUS THEN
         CALL s_errmsg('nmd01',l_nmd.nmd01,'ins nmd:',STATUS,1)  #No.FUN-710024
         LET g_success='N' CONTINUE FOREACH #No.FUN-710024
      END IF
      UPDATE nnh_file SET nnh06=l_nmd.nmd01
       WHERE nnh01=l_nnh.nnh01 AND nnh02=l_nnh.nnh02
      IF STATUS THEN
         LET g_showmsg = l_nnh.nnh01,"/",l_nnh.nnh02                     #No.FUN-710024
         CALL s_errmsg('nnh01,nnh02',g_showmsg,'upd nnh06:',STATUS,1)    #No.FUN-710024
         LET g_success='N' CONTINUE FOREACH #No.FUN-710024
      END IF
      LET l_nmd.nmd01[7,10]=(l_nmd.nmd01[7,10]+1) USING '&&&&'
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   IF STATUS THEN 
      CALL s_errmsg('','','for t720_t_c:',STATUS,0)   #No.FUN-710024
   END IF
   CALL s_showmsg() #No.FUN-710024
   IF g_success='Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
END FUNCTION
 
FUNCTION t720_del_np()
  DEFINE l_nmd         RECORD LIKE nmd_file.*
  DEFINE l_nmf         RECORD LIKE nmf_file.*
  DEFINE l_nnf         RECORD LIKE nnf_file.*
  DEFINE l_nnn05       LIKE nnn_file.nnn05
  DEFINE l_cnt         LIKE type_file.num5,    #No.FUN-680107 SMALLINT
         l_start,l_end LIKE nmd_file.nmd01     #No.FUN-680107 VARCHAR(10)
 
 
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
 
   IF g_nng.nngconf = 'N' THEN RETURN END IF
 
   IF NOT cl_sure(18,10) THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'
   LET l_start = null
   LET l_end = null
   LET l_cnt = 1
   DECLARE t720_del_np CURSOR FOR
    SELECT * FROM nnf_file
     WHERE nnf01 = g_nng.nng01
       AND nnf06 IS NOT NULL
   CALL s_showmsg_init()    #No.FUN-710024
   FOREACH t720_del_np INTO l_nnf.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN 
         CALL s_errmsg('nnf01',g_nng.nng01,'foreach nnf_del',STATUS,0)   #No.FUN-710024
         EXIT FOREACH
      END IF
 
      SELECT * INTO l_nmd.* FROM nmd_file WHERE nmd01=l_nnf.nnf06
      IF STATUS THEN CALL cl_err(g_nng.nng01,'anm-221',0)  EXIT FOREACH END IF
      IF l_nmd.nmd12 <> 'X' THEN
         CALL s_errmsg('nmd01',l_nnf.nnf06,g_nng.nng01,'anm-236',0)  #No.FUN-710024
         CONTINUE FOREACH     #No.FUN-710024
      END IF
      DELETE FROM nmd_file WHERE nmd01 = l_nnf.nnf06
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         CALL s_errmsg('nmd01',l_nnf.nnf06,'del nmd',STATUS,1)   #No.FUN-710024
         LET g_success = 'N'
      END IF
      DELETE FROM nmf_file WHERE nmf01 = l_nmd.nmd01
                             AND nmf02 = l_nnf.nnf03
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         LET g_showmsg = l_nmd.nmd01,"/",l_nnf.nnf03                  #No.FUN-710024
         CALL s_errmsg('nmf01,nmf02',g_showmsg,'del nmf',STATUS,1)    #No.FUN-710024
         LET g_success = 'N' 
      END IF
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980005 add plant & legal
        VALUES ('anmt720',g_user,g_today,'R nmd',l_nmd.nmd01,'Delete nmd',g_plant,g_legal)
      UPDATE nnf_file SET nnf06 = NULL
       WHERE nnf01 = l_nnf.nnf01
         AND nnf02 = l_nnf.nnf02
      IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
         LET g_showmsg = l_nnf.nnf01,"/",l_nnf.nnf02                  #No,FUN-710024
         CALL s_errmsg('nnf01,nnf02',g_showmsg,'upd nnf',STATUS,1)    #No.FUN-710024
         LET g_success = 'N'
      END IF
      IF l_cnt = 1 THEN
         LET l_start = l_nnf.nnf06
         LET l_end = l_nnf.nnf06
      ELSE
         LET l_end = l_nnf.nnf06
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
   CALL s_showmsg()   #No.FUN-710024
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK END IF
   CALL cl_end(18,10)
   MESSAGE 'Start No :',l_start,' End No :',l_end
 
 
END FUNCTION
 
FUNCTION t720_t1()
   DEFINE l_pmc081,l_pmc03  LIKE pmc_file.pmc081   #No.FUN-680107 VARCHAR(40)
   DEFINE li_result         LIKE type_file.num5    #No.FUN-560002  #No.FUN-680107 SMALLINT
   DEFINE l_nma28           LIKE nma_file.nma28    #No.FUN-870057
   DEFINE l_n               LIKE type_file.num5    #No.FUN-870057
   DEFINE l_cnt             LIKE type_file.num5    #FUN-C80018
   DEFINE l_azf09           LIKE azf_file.azf09    #No.FUN-930104
   DEFINE tm RECORD 
             book_no          LIKE nmd_file.nmd31    #No.FUN-870057      
             END RECORD
 
   OPEN t720_cl USING g_nng.nng01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_nng.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
      CLOSE t720_cl ROLLBACK WORK RETURN
   END IF
   LET g_success='Y'
 
   OPEN WINDOW t720_t_w AT 4,16 WITH FORM "anm/42f/anmt720a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("anmt720a")
 
 
   IF g_nng.nng43 IS NULL THEN
      LET g_nng.nng43 = g_nng.nng02
   END IF
   LET tm.book_no = NULL   #No.FUN-870057
   INPUT BY NAME g_nng.nng41,g_nng.nng42,g_nng.nng43,g_nng.nng44,
                 g_nng.nng45,tm.book_no,g_nng.nng47,g_nng.nng48, #No.FUN-870057 add book_no
                 g_nng.nng51,g_nng.nng49,g_nng.nng50
                 WITHOUT DEFAULTS
 
      AFTER FIELD nng41
         IF NOT cl_null(g_nng.nng41) THEN
            LET g_t1 = s_get_doc_no(g_nng.nng41)       #No.FUN-550057
#        CALL s_check_no(g_sys,g_t1,"","1","","","")
         CALL s_check_no("anm",g_t1,"","1","","","")   #No.FUN-A40041
              RETURNING li_result,g_nng.nng41
         DISPLAY BY NAME g_nng.nng41
         IF (NOT li_result) THEN
               NEXT FIELD nng41
         END IF
 
        END IF
 
      AFTER FIELD nng42
         SELECT nma02 FROM nma_file WHERE nma01=g_nng.nng42
         IF STATUS THEN 
         CALL cl_err3("sel","nma_file",g_nng.nng42,"",STATUS,"","sel nma:",1)  #No.FUN-660148
         NEXT FIELD nng42 END IF
 
      AFTER FIELD nng44
         SELECT nmo02 FROM nmo_file WHERE nmo01=g_nng.nng44
         IF STATUS THEN 
            CALL cl_err3("sel","nmo_file",g_nng.nng44,"",STATUS,"","sel nmo:",1)  #No.FUN-660148
            NEXT FIELD nng44 END IF
 
      AFTER FIELD nng45
         IF NOT cl_null(g_nng.nng45) THEN
            SELECT nmo02 FROM nmo_file WHERE nmo01=g_nng.nng45
            IF STATUS THEN 
               CALL cl_err3("sel","nmo_file",g_nng.nng45,"",STATUS,"","sel nmo:",1)  #No.FUN-660148
               NEXT FIELD nng45 END IF
         END IF
         
      AFTER FIELD book_no
          IF NOT cl_null(tm.book_no) THEN
               IF tm.book_no <> '98' THEN
                  SELECT nma28 INTO l_nma28 FROM nma_file
                   WHERE nma01= g_nng.nng42
                   SELECT COUNT(*) INTO l_cnt FROM nna_file WHERE nna01=tm.book_no   #FUN-C80018
                 # IF l_nma28 !='1'  THEN                                            #FUN-C80018
                   IF l_nma28 !='1' AND (g_aza.aza26!='2' OR l_cnt>0) THEN           #FUN-C80018
                      CALL cl_err('','anm-251',0)
                      NEXT FIELD book_no
                  END IF
               END IF
              #No.+120 簿號=99 表示可自行輸入票號不check(因為可能key別人之CP)
              #IF tm.book_no <> '99' AND tm.book_no <> '98' THEN                       #FUN-C80018
               IF tm.book_no <> '99' AND tm.book_no <> '98' AND (g_aza.aza26!='2' OR l_cnt>0) THEN    #FUN-C80018
               SELECT COUNT(*) INTO l_n FROM nna_file,nma_file
                WHERE nna01 = nma01
                  AND nna01 = g_nng.nng42
                  AND nna02 = tm.book_no
               IF l_n = 0 THEN
                  CALL cl_err('','anm-954',0) NEXT FIELD book_no
               ELSE
                  SELECT nna06,nna03 INTO g_nna06,g_nna03 FROM nna_file
                   WHERE nna01 = g_nng.nng42
                     AND nna02 = tm.book_no
                     AND nna021= (SELECT MAX(nna021) FROM nna_file
                          WHERE nna01 = g_nng.nng42 AND nna02 = tm.book_no)
               END IF
            END IF    
         END IF
      LET g_book_no = tm.book_no 
 
      AFTER FIELD nng47
         IF NOT cl_null(g_nng.nng47) THEN
            SELECT gem02 FROM gem_file WHERE gem01=g_nng.nng47
               AND gemacti='Y'
            IF STATUS THEN 
               CALL cl_err3("sel","gem_file",g_nng.nng47,"",STATUS,"","sel gem:",1)  #No.FUN-660148
               NEXT FIELD nng47 END IF
         END IF
 
      AFTER FIELD nng48
         IF NOT cl_null(g_nng.nng48) THEN
            SELECT pmc03,pmc081 INTO l_pmc03,l_pmc081
              FROM pmc_file WHERE pmc01=g_nng.nng48
            IF STATUS THEN 
               CALL cl_err3("sel","pmc_file",g_nng.nng48,"",STATUS,"","sel pmc:",1)  #No.FUN-660148
               NEXT FIELD nng48 END IF
            IF g_nng.nng48<>'MISC' THEN
               LET g_nng.nng51=l_pmc03
               LET g_nng.nng49=l_pmc081
               DISPLAY BY NAME g_nng.nng51,g_nng.nng49
            END IF
         END IF
 
      AFTER FIELD nng50
         IF NOT cl_null(g_nng.nng50) THEN
           SELECT azf02 FROM azf_file WHERE azf01=g_nng.nng50 AND azf02='2' #6818
            IF STATUS THEN 
               CALL cl_err3("sel","azf_file",g_nng.nng50,"",STATUS,"","sel azf:",1)  #No.FUN-660148
               NEXT FIELD nng50 END IF
           SELECT azf09 INTO l_azf09 FROM azf_file 
            WHERE azf01=g_nng.nng50 AND azf02='2'  #No.FUN-930104    
               IF l_azf09 != '8' THEN 
                  CALL cl_err('','aoo-407',1)  
                  NEXT FIELD nng50   
               END IF   
         END IF
              
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(nng41)
               LET g_t1 = s_get_doc_no(g_nng.nng41)       #No.FUN-550057
               CALL q_nmy(FALSE,TRUE,g_t1,'1','ANM') RETURNING g_t1 #票據性質:應付票據NO:6842  #TQC-67000
               LET g_nng.nng41 = g_t1        #No.FUN-550057
               DISPLAY BY NAME g_nng.nng41 NEXT FIELD nng41
            WHEN INFIELD(nng42) #銀行代號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nma"
               LET g_qryparam.default1 = g_nng.nng42
               CALL cl_create_qry() RETURNING g_nng.nng42
               DISPLAY BY NAME g_nng.nng42
               NEXT FIELD nng42
            WHEN INFIELD(nng47) #
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = g_nng.nng47
               CALL cl_create_qry() RETURNING g_nng.nng47
               DISPLAY BY NAME g_nng.nng47
               NEXT FIELD nng47
            WHEN INFIELD(nng48) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_pmc"
               LET g_qryparam.default1 = g_nng.nng48
               CALL cl_create_qry() RETURNING g_nng.nng48
               DISPLAY BY NAME g_nng.nng48
               NEXT FIELD nng48
            WHEN INFIELD(nng44)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmo01"
               LET g_qryparam.default1 = g_nng.nng44
               CALL cl_create_qry() RETURNING g_nng.nng44
               DISPLAY BY NAME g_nng.nng44
               NEXT FIELD nng44
            WHEN INFIELD(nng45)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_nmo01"
               LET g_qryparam.default1 = g_nng.nng45
               CALL cl_create_qry() RETURNING g_nng.nng45
               DISPLAY BY NAME g_nng.nng45
               NEXT FIELD nng45
            WHEN INFIELD(nng50)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azf01a"  #No.FUN-930104
               LET g_qryparam.arg1 = '8'         #No.FUN-930104     
               LET g_qryparam.default1 = g_nng.nng50
               CALL cl_create_qry() RETURNING g_nng.nng50
               DISPLAY BY NAME g_nng.nng50
               NEXT FIELD nng50
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
      LET INT_FLAG=0
      LET g_success='N'
      LET g_nng.*=g_nng_t.*
      CLOSE WINDOW t720_t_w
      RETURN
   END IF
   UPDATE nng_file SET *=g_nng.* WHERE nng01=g_nng.nng01
   IF STATUS THEN 
      CALL cl_err3("upd","nng_file",g_nng.nng01,"",STATUS,"","upd nng:",1)  #No.FUN-660148
      LET g_success='N' END IF
   CLOSE WINDOW t720_t_w
END FUNCTION
 
FUNCTION t720_firm1()
   DEFINE l_nnn07   LIKE nnn_file.nnn07    #No.8935
   DEFINE l_nmydmy3 LIKE nmy_file.nmydmy3  #No.FUN-670060 
   DEFINE l_nmyglcr LIKE nmy_file.nmyglcr  #No.FUN-670060 
   DEFINE l_nmygslp LIKE nmy_file.nmygslp  #No.FUN-670060 
   DEFINE l_n       LIKE type_file.num5    #No.FUN-670060  #No.FUN-680107 SMALLINT
   DEFINE l_npq07   LIKE npq_file.npq07    #MOD-C70179 add
 
   LET g_success='Y'                       #No.FUN-670060 
 
#CHI-C30107 --------- add ----------- begin
   IF g_nng.nngconf='Y' THEN RETURN END IF
   IF g_nng.nngconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 --------- add ----------- end
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
   IF g_nng.nngconf='Y' THEN RETURN END IF
   IF g_nng.nngconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nng.nng02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nng.nng01,'aap-176',1) RETURN
   END IF
  #------------------MOD-C70179-------------------(S)
   SELECT SUM(npq07) INTO l_npq07
     FROM npq_file
    WHERE npq01 = g_nng.nng01
      AND npq06 = '1'
      AND npq00 = '17'
      AND npq011= 0
      AND npqsys= 'NM'

   IF l_npq07 != g_nng.nng22 THEN
      CALL cl_err('','afa-154',1)
      RETURN
   END IF
   CALL t720_b_tot()
   IF NOT cl_null(g_errno) THEN RETURN END IF
  #------------------MOD-C70179-------------------(E)
   
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30107 mark
   CALL s_get_bookno(YEAR(g_nng.nng02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nng.nng02),'aoo-081',1)
      RETURN
   END IF
   LET g_success='Y'
   BEGIN WORK
   OPEN t720_cl USING g_nng.nng01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_nng.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
      CLOSE t720_cl ROLLBACK WORK RETURN
   END IF
   #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
   LET g_t1 = s_get_doc_no(g_nng.nng01)       #No.FUN-550057
   SELECT nmydmy3,nmyglcr INTO l_nmydmy3,l_nmyglcr FROM nmy_file WHERE nmyslip = g_t1   #No.FUN-670060
   IF l_nmydmy3 = 'Y'AND l_nmyglcr = 'N' THEN  #No.FUN-670060
      CALL s_chknpq(g_nng.nng01,'NM',0,'0',g_bookno1)   #FUN-680088        #No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_nng.nng01,'NM',0,'1',g_bookno2)       #No.FUN-730032
      END IF
   END IF
   SELECT nnn07 INTO l_nnn07 FROM nnn_file
   #WHERE nnn01=g_nne.nne06   #MOD-A40014 mark 
    WHERE nnn01=g_nng.nng24   #MOD-A40014 add 
   IF status THEN LET l_nnn07='Y' END IF
   #增加判斷非開帳才ins nme
   IF g_nng.nng25='N' AND l_nnn07='Y' THEN    #No:8935
      CALL t720_ins_nme()
   END IF
   IF g_success='N' THEN ROLLBACK WORK RETURN END IF
  
   IF l_nmydmy3 = 'Y' AND l_nmyglcr = 'Y' THEN                                                                                      
      CALL s_get_doc_no(g_nng.nng01) RETURNING g_t1 
      SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
      SELECT COUNT(*) INTO l_n FROM npq_file 
       WHERE npqsys='NM' AND npq00=17 AND npq01=g_nng.nng01 AND npq011=0
      IF l_n = 0 THEN
         CALL t720_gen_glcr(g_nng.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq(g_nng.nng01,'NM',0,'0',g_bookno1)   #FUN-680088 modify       #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_nng.nng01,'NM',0,'1',g_bookno2)       #No.FUN-730032
         END IF 
      END IF 
   END IF
   IF g_success='N' THEN ROLLBACK WORK RETURN END IF  #FUN-680088
 
   UPDATE nng_file SET nngconf = 'Y' WHERE nng01 = g_nng.nng01
   IF g_success='Y'
      THEN COMMIT WORK LET g_nng.nngconf ='Y' DISPLAY BY NAME  g_nng.nngconf
           CALL cl_flow_notify(g_nng.nng01,'Y')
      ELSE ROLLBACK WORK
   END IF
    IF l_nmydmy3 = 'Y' AND l_nmyglcr = 'Y' AND g_success = 'Y' THEN
       LET g_wc_gl = 'npp01="',g_nng.nng01 CLIPPED,'" AND npp011=0 '
       LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nng.nng02,"' 'Y' '1' 'Y'" #FUN-680088#FUN-860040
       CALL cl_cmdrun_wait(g_str)
       SELECT nngglno INTO g_nng.nngglno FROM nng_file
        WHERE nng01 = g_nng.nng01
       DISPLAY BY NAME g_nng.nngglno
    END IF
    CALL cl_set_field_pic(g_nng.nngconf,"","","","N","")   #MOD-AC0073
END FUNCTION
 
FUNCTION t720_firm2()
   DEFINE l_nnn07   LIKE nnn_file.nnn07 #No.8935
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE l_aba19   LIKE aba_file.aba19 #No.FUN-670060
   DEFINE l_dbs     STRING              #No.FUN-670060
   DEFINE l_sql     STRING              #No.FUN-670060
 
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
   IF g_nng.nngconf='N' THEN RETURN END IF
   IF g_nng.nngconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nng.nng02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nng.nng01,'aap-176',1) RETURN
   END IF
   #若已作暫估之資料不可取消確認
   SELECT COUNT(*) INTO l_cnt FROM nnm_file
    WHERE nnm01=g_nng.nng01
   IF l_cnt > 0 THEN CALL cl_err(g_nng.nng01,'anm1016',1) RETURN END IF   #MOD-920196 anm-004-->anm1016
   #若已有還款資料則不可取消確認
   IF g_nng.nng21 != 0 OR g_nng.nng23 != 0 THEN
      CALL cl_err(g_nng.nng01,'anm-240',1)
      RETURN
   END IF
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM nnj_file,nni_file
    WHERE nnj01=nni01
      AND nnj03=g_nng.nng01 AND nnj09='2' AND nniacti='Y'
      AND nniconf <> 'X'  #CHI-C80041
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt = 0 THEN 
      SELECT COUNT(*) INTO l_cnt FROM nnl_file,nnk_file
       WHERE nnl01=nnk01
         AND nnl04=g_nng.nng01 AND nnl03='2' AND nnkacti='Y'
         AND nnkconf <> 'X'  #CHI-C80041
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   END IF
   IF l_cnt > 0 THEN
      CALL cl_err(g_nng.nng01,'anm-240',1)
      RETURN
   END IF
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_nng.nng01) RETURNING g_t1 
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nng.nngglno) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_nng.nng01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nng.nngglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nng.nngglno,'axr-071',1)
         RETURN
      END IF
   END IF
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   LET g_success='Y'

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr='Y' THEN 
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nng.nngglno,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT nngglno INTO g_nng.nngglno FROM nng_file
       WHERE nng01 = g_nng.nng01
      IF NOT cl_null(g_nng.nngglno) THEN
         CALL cl_err(g_nng.nngglno,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_nng.nngglno
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
   OPEN t720_cl USING g_nng.nng01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_nng.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
      CLOSE t720_cl ROLLBACK WORK RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM nnh_file
    WHERE nnh01 = g_nng.nng01
      AND nnh06 IS NOT NULL
   IF g_cnt > 0 THEN
      CALL cl_err(g_nng.nng01,'anm-958',0)
      RETURN
   END IF
 
   SELECT nnn07 INTO l_nnn07 FROM nnn_file
   #WHERE nnn01=g_nne.nne06   #MOD-A40014 mark 
    WHERE nnn01=g_nng.nng24   #MOD-A40014 add 
   IF status THEN LET l_nnn07='Y' END IF
   #增加判斷非開帳才ins nme
   IF g_nng.nng25='N' AND l_nnn07='Y' THEN    #No:8935
      CALL t720_del_nme()
   END IF
 
   IF g_success='N' THEN ROLLBACK WORK RETURN END IF
   UPDATE nng_file SET nngconf = 'N' WHERE nng01 = g_nng.nng01
   IF g_success='Y'
      THEN COMMIT WORK LET g_nng.nngconf ='N' DISPLAY BY NAME  g_nng.nngconf
      ELSE ROLLBACK WORK
   END IF
 
   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr='Y' AND g_success = 'Y' THEN 
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nng.nngglno,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT nngglno INTO g_nng.nngglno FROM nng_file
   #    WHERE nng01 = g_nng.nng01
   #   DISPLAY BY NAME g_nng.nngglno
   #END IF
   #CHI-C90052 mark end-----
 
END FUNCTION
 
FUNCTION t720_ins_nme()
   DEFINE l_nme            RECORD LIKE nme_file.*

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end

   LET l_nme.nme00=0
   LET l_nme.nme01=g_nng.nng05
   LET l_nme.nme02=g_nng.nng03
   LET l_nme.nme03=g_nng.nng051
   LET l_nme.nme04=g_nng.nng20
   LET l_nme.nme05=g_nng.nng07
   LET l_nme.nme07=g_nng.nng19
   IF NOT cl_null(g_nng.nng54) THEN # 有他保銀行   No:B068
      LET l_nme.nme04=g_nng.nng20
                     -g_nng.nng55-g_nng.nng57-g_nng.nng59-g_nng.nng61
      LET l_nme.nme08=g_nng.nng22
                     -g_nng.nng55-g_nng.nng57-g_nng.nng59-g_nng.nng61
   ELSE
      LET l_nme.nme04=g_nng.nng20
                     -g_nng.nng55-g_nng.nng59-g_nng.nng61
      LET l_nme.nme08=g_nng.nng22
                     -g_nng.nng55-g_nng.nng59-g_nng.nng61
   END IF
   LET l_nme.nme10=g_nng.nngglno
   LET l_nme.nme12=g_nng.nng01
   LET l_nme.nme14=g_nng.nng17
   LET l_nme.nme16=g_nng.nng03
   LET l_nme.nme17=g_nng.nng01
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_nme.nme21 = b_nnh.nnh02
   LET l_nme.nme22 = '14'
   LET l_nme.nme23 = ''
   LET l_nme.nme24 = '9'  #No.TQC-750098
   LET l_nme.nme25 = ''
 
   LET l_nme.nmelegal= g_legal
   LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
   LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

   INSERT INTO nme_file VALUES(l_nme.*)
   IF STATUS THEN 
      CALL cl_err3("ins","nme_file",l_nme.nme01,"",STATUS,"","ins nme:",1)  #No.FUN-660148
      LET g_success='N' END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062  
END FUNCTION
 
FUNCTION t720_del_nme()
 DEFINE l_nme24     LIKE nme_file.nme24  #No.FUN-730032
 
   IF g_aza.aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme17='",g_nng.nng01,"'"
      PREPARE nme24_p1 FROM g_sql
      DECLARE nme24_cs1 CURSOR FOR nme24_p1
      FOREACH nme24_cs1 INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_nng.nng01,'anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021    
   #FUN-B40056  --begin
   DELETE FROM tic_file WHERE tic04 IN
  (SELECT nme12 FROM nme_file 
    WHERE nme17 = g_nng.nng01)
   
   IF STATUS THEN 
      CALL cl_err3("del","tic_file",g_nng.nng01,"",STATUS,"","del tic:",1)
      LET g_success='N' END IF
   #FUN-B40056  --end
   END IF                 #No.TQC-B70021
   DELETE FROM nme_file WHERE nme17=g_nng.nng01
   IF STATUS THEN 
      CALL cl_err3("del","nme_file",g_nng.nng01,"",STATUS,"","del nme:",1)  #No.FUN-660148
      LET g_success='N' END IF
END FUNCTION
 
FUNCTION t720_b_tot()
   DEFINE totf,tot   LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6)   #No.FUN-4C0010
   SELECT SUM(nnh04f),SUM(nnh04) INTO totf,tot
          FROM nnh_file WHERE nnh01=g_nng.nng01
   DISPLAY totf TO nnh04f_t
   DISPLAY tot  TO nnh04_t
   IF g_nng.nng20 != totf OR g_nng.nng22 != tot THEN
       CALL cl_err('','anm-234',0)
       LET g_errno = 'anm-234'         #MOD-C70179 add
   END IF
END FUNCTION
 
FUNCTION t720_g_gl(p_trno,p_npptype)        #FUN-680088
   DEFINE p_npptype   LIKE npp_file.npptype #FUN-680088
   DEFINE p_trno      LIKE nng_file.nng01
   DEFINE l_buf       LIKE type_file.chr1000#No.FUN-680107 VARCHAR(90)
   DEFINE l_n         LIKE type_file.num5,  #No.FUN-680107 SMALLINT
          l_t         LIKE nmy_file.nmyslip,#No.FUN-680107 VARCHAR(05) #No.FUN-560196
          l_nmydmy3   LIKE nmy_file.nmydmy3
 
   BEGIN WORK
 
   OPEN t720_cl USING g_nng.nng01
   IF STATUS THEN
      CALL cl_err("OPEN t720_cl:", STATUS, 1)
      CLOSE t720_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t720_cl INTO g_nng.*
   IF SQLCA.SQLCODE THEN
      CALL cl_err(g_nng.nng01,SQLCA.SQLCODE,0)
      CLOSE t720_cl ROLLBACK WORK RETURN ELSE COMMIT WORK
   END IF
   SELECT * INTO g_nng.* FROM nng_file WHERE nng01 = g_nng.nng01
   IF p_trno IS NULL THEN RETURN END IF
   IF g_nng.nngconf='Y' THEN CALL cl_err(g_nng.nng01,'anm-232',0) RETURN END IF
   IF g_nng.nngconf='X' THEN CALL cl_err(g_nng.nng01,'9024',0) RETURN END IF
   #-->立帳日期不可小於關帳日期
   IF g_nng.nng02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nng.nng01,'aap-176',1) RETURN
   END IF
   IF NOT cl_null(g_nng.nngglno) THEN
      CALL cl_err(g_nng.nng01,'aap-122',1) RETURN
   END IF
   #判斷該單別是否須拋轉總帳
   LET l_t = s_get_doc_no(p_trno)       #No.FUN-550057
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(l_nmydmy3) THEN LET l_nmydmy3 = 'N' END IF
   IF l_nmydmy3 = 'N' THEN RETURN END IF
 
   IF p_npptype = '0' THEN
      SELECT COUNT(*) INTO l_n FROM npq_file
       WHERE npqsys='NM' AND npq00=17 AND npq01=p_trno AND npq011=0
      IF l_n > 0 THEN
         IF NOT s_ask_entry(p_trno) THEN RETURN END IF #Genero

         #FUN-B40056--add--str--
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM tic_file
          WHERE tic04 = p_trno
         IF l_n > 0 THEN
            IF NOT cl_confirm('sub-533') THEN
               RETURN
            END IF
         END IF
         DELETE FROM tic_file WHERE tic04 = p_trno
         #FUN-B40056--add--end--
         DELETE FROM npq_file
             WHERE npqsys='NM' AND npq00=17 AND npq01=p_trno AND npq011=0
      END IF
   END IF
   INITIALIZE g_npp.* TO NULL
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =17
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=0
   LET g_npp.npp02 =g_nng.nng03
   LET g_npp.npptype =p_npptype #FUN-680088
 
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
      UPDATE npp_file SET npp02=g_npp.npp02
          WHERE nppsys='NM' AND npp00=17 AND npp01=p_trno AND npp011=0
            AND npptype=p_npptype  #FUN-680088
      IF SQLCA.SQLCODE THEN 
         CALL cl_err3("upd","npp_file",p_trno,"",STATUS,"","upd npp:",1)  #No.FUN-660148
         RETURN END IF
   END IF
   IF SQLCA.SQLCODE THEN 
      CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp:",1)  #No.FUN-660148
      RETURN END IF
   CALL t720_g_gl_1(p_trno,p_npptype)  #FUN-680088
   CALL t720_gen_diff()                #FUN-A40033
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t720_g_gl_1(p_trno,p_npptype)  #FUN-680088
   DEFINE p_npptype   LIKE npp_file.npptype #FUN-680088
   DEFINE p_trno      LIKE nng_file.nng01
   DEFINE l_aaa03     LIKE aaa_file.aaa03   #FUN-A40067                         
   DEFINE l_azi04_2   LIKE azi_file.azi04   #FUN-A40067
   DEFINE l_flag      LIKE type_file.chr1   #FUN-D40118 add
 
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npqtype= p_npptype #FUN-680088
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
   END IF
   IF g_npq.npqtype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
#FUN-A40067 --Begin
   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = g_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03
#FUN-A40067 --End
 
   LET g_npq.npq02 = 1
   IF p_npptype = '0' THEN
      LET g_npq.npq03 = g_nng.nng_d1
   ELSE
      LET g_npq.npq03 = g_nng.nng_d11
   END IF
   LET g_npq.npq04 = NULL  #FUN-D10065
   LET g_npq.npq06 = '1'
   LET g_npq.npq07f= g_nng.nng20
   LET g_npq.npq07 = g_nng.nng22
   LET g_npq.npq24 = g_nng.nng18
   LET g_npq.npq25 = g_nng.nng19
   LET g_npq25     = g_npq.npq25      #No.FUN-9A0036
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
    RETURNING  g_npq.*
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
   LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
      CALL s_newrate(g_bookno1,g_bookno2,
                     g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
   END IF
#No.FUN-9A0036 --End
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = g_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
   #FUN-D40118--add--end--
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d1:",1)  #No.FUN-660148
   END IF
 
   IF p_npptype = '0' THEN
      IF g_nng.nng_d2 IS NOT NULL THEN
         LET g_npq.npq02 = g_npq.npq02+1
         LET g_npq.npq03 = g_nng.nng_d2
         LET g_npq.npq04 = NULL  #FUN-D10065
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno1)       #No.FUN-730032
          RETURNING  g_npq.*
          
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
         LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno1
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno1) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
         END IF
      END IF
   ELSE
      IF g_nng.nng_d21 IS NOT NULL THEN
         LET g_npq.npq02 = g_npq.npq02+1
         LET g_npq.npq03 = g_nng.nng_d21
         LET g_npq.npq04 = NULL  #FUN-D10065
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno2)       #No.FUN-730032
          RETURNING  g_npq.*
            
         CALL s_def_npq31_npq34(g_npq.*,g_bookno2) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
         LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
         END IF
      END IF
   END IF
 
   LET g_npq.npq02 = g_npq.npq02+1
   IF p_npptype = '0' THEN
      LET g_npq.npq03 = g_nng.nng_c1
   ELSE
      LET g_npq.npq03 = g_nng.nng_c11
   END IF
   LET g_npq.npq06 = '2'
   LET g_npq.npq04 = NULL  #FUN-D10065
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
    RETURNING  g_npq.*
 
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
   LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
      CALL s_newrate(g_bookno1,g_bookno2,
                     g_npq.npq24,g_npq25,g_npp.npp02)
      RETURNING g_npq.npq25
      LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
   ELSE
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
   END IF
#No.FUN-9A0036 --End
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = g_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
   #FUN-D40118--add--end--
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c1:",1)  #No.FUN-660148
   END IF
 
   IF p_npptype = '0' THEN
      IF g_nng.nng_c2 IS NOT NULL THEN
         LET g_npq.npq02 = g_npq.npq02+1
         LET g_npq.npq03 = g_nng.nng_c2
         LET g_npq.npq04 = NULL  #FUN-D10065
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno1)       #No.FUN-730032
          RETURNING  g_npq.*
           
         CALL s_def_npq31_npq34(g_npq.*,g_bookno1) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
         LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno1
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno1) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c2:",1)  #No.FUN-660148
         END IF
      END IF
   ELSE
      IF g_nng.nng_c21 IS NOT NULL THEN
         LET g_npq.npq02 = g_npq.npq02+1
         LET g_npq.npq03 = g_nng.nng_c21
         LET g_npq.npq04 = NULL  #FUN-D10065
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno2)       #No.FUN-730032
          RETURNING  g_npq.*
           
         CALL s_def_npq31_npq34(g_npq.*,g_bookno2) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
         LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno2
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c2:",1)  #No.FUN-660148
         END IF
      END IF
   END IF
    CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021    
END FUNCTION
 
FUNCTION t720_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nng01",TRUE)
    END IF
 
    IF g_nng.nng25 = 'Y' THEN                     #MOD-CA0017 add
      CALL cl_set_comp_entry("nng26",TRUE)        #MOD-CA0017 add
    END IF                                        #MOD-CA0017 add

END FUNCTION
 
FUNCTION t720_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("nng01",FALSE)
    END IF

    IF g_nng.nng25 = 'N' THEN                     #MOD-CA0017 add
      CALL cl_set_comp_entry("nng26",FALSE)       #MOD-CA0017 add
    END IF                                        #MOD-CA0017 add
 
END FUNCTION
 
FUNCTION t720_gen_glcr(p_nng,p_nmy)
  DEFINE p_nng     RECORD LIKE nng_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_nng.nng01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t720_g_gl(p_nng.nng01,'0')
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL t720_g_gl(p_nng.nng01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t720_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE li_result    LIKE type_file.num5     #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_nng.nngglno) OR g_nng.nngglno IS NOT NULL THEN  
       CALL cl_err(g_nng.nngglno,'aap-618',1)  
       RETURN 
    END IF
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nng.nng01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN #FUN-940036
       LET l_nmygslp = g_nmy.nmygslp
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_nng.nngglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_nng.nngglno,'aap-991',1)
          RETURN
       END IF
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
 
    END IF
    IF cl_null(l_nmygslp) OR (cl_null(g_nmy.nmygslp1) AND g_aza.aza63 = 'Y') THEN
       CALL cl_err(g_nng.nng01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01="',g_nng.nng01 CLIPPED,'" AND npp011=0 '
    LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",l_nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nng.nng02,"' 'Y' '1' 'Y'" #FUN-680088#FUN-860040
    CALL cl_cmdrun_wait(g_str)
    SELECT nngglno INTO g_nng.nngglno FROM nng_file
     WHERE nng01 = g_nng.nng01
    DISPLAY BY NAME g_nng.nngglno
    
END FUNCTION
 
FUNCTION t720_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF cl_null(g_nng.nngglno) OR g_nng.nngglno IS NULL THEN 
       CALL cl_err(g_nng.nngglno,'aap-619',1)
       RETURN 
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nng.nng01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
 
    LET g_plant_new=g_nmz.nmz02p CLIPPED 
    #CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nng.nngglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre1 FROM l_sql
    DECLARE aba_cs1 CURSOR FOR aba_pre1
    OPEN aba_cs1
    FETCH aba_cs1 INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nng.nngglno,'axr-071',1)
       RETURN
    END IF
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nng.nngglno,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT nngglno INTO g_nng.nngglno FROM nng_file
     WHERE nng01 = g_nng.nng01
    DISPLAY BY NAME g_nng.nngglno
END FUNCTION
 
FUNCTION t720_nng11()           
    DEFINE l_dd         LIKE type_file.num10  
    DEFINE l_mm         LIKE type_file.num10   
    DEFINE l_yy         LIKE type_file.num10   
    DEFINE l_dd1        LIKE type_file.num10   
    DEFINE l_mm1        LIKE type_file.num10   
    DEFINE l_yy1        LIKE type_file.num10
    DEFINE l_n          LIKE type_file.num10   
               
    IF NOT cl_null(g_nng.nng101) AND NOT cl_null(g_nng.nng102) THEN
       LET l_yy = YEAR(g_nng.nng101)
       LET l_mm = MONTH(g_nng.nng101)
       LET l_dd = DAY(g_nng.nng101)
       LET l_yy1 = YEAR(g_nng.nng102)
       LET l_mm1 = MONTH(g_nng.nng102)
       LET l_dd1 = DAY(g_nng.nng102)
       IF l_mm1>=l_mm THEN 
          LET l_n = (l_yy1-l_yy)*12 + (l_mm1-l_mm)
       ELSE
          LET l_n = (l_yy1-l_yy-1)*12 + (l_mm1+12-l_mm)
       END IF                                    	   	    
       CASE g_nng.nng12
            WHEN '1'  LET g_nng.nng11 = l_n/1
            WHEN '2'  LET g_nng.nng11 = l_n/3
            WHEN '3'  LET g_nng.nng11 = l_n/6
            WHEN '4'  LET g_nng.nng11 = l_n/12
       END CASE
       IF l_dd<=l_dd1 THEN
          LET g_nng.nng11 = g_nng.nng11 + 1
       END IF     
       DISPLAY BY NAME g_nng.nng11
     END IF
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/15
#FUN-A40033 --Begin
FUNCTION t720_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
         RETURN
      END IF
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp.npp00
            AND npq01 = g_npp.npp01
            AND npq011= g_npp.npp011
            AND npqsys= g_npp.nppsys
         LET l_npq1.npqtype = g_npp.npptype
         LET l_npq1.npq00 = g_npp.npp00
         LET l_npq1.npq01 = g_npp.npp01
         LET l_npq1.npq011= g_npp.npp011
         LET l_npq1.npqsys= g_npp.nppsys
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal = g_legal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End


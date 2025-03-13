# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp650.4gl
# Descriptions...: 出貨單扣帳還原
# Date & Author..: 95/02/03 By Roger
# Modify.........: No:7772 03/08/14 Carol 出境外出貨單到海外A倉,海外A倉出貨後,
#                                         還原原出境外出貨單,會導致海外A倉成
#                                         為負庫存-->境外出貨還原請檢查是否
#                                         已有對應海外倉出貨單, 已有的話show msg並擋掉
# Modify.........: No:8613 03/10/31 Melody update img_file, 
#                : 要IF SQLCA.SQLCODE or SQLCA.SQLERRD[3]=0 THEN判斷
# Modify.........: No:9725 04/07/08 ching 未控管三角貿易是否已拋轉還原
# Modify.........: No.MOD-4B0070 04/11/09 By Carrier modify occ31
# Modify.........: No.MOD-4B0304 04/11/30 By Mandy 已有銷退資料不可將該出貨單扣帳還原
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-530031 05/03/22 By Carol 單價/金額欄位所用的變數型態應為 dec(20,6),匯率 dec(20,10)
# Modify.........: No.FUN-540049 05/06/07 By Carrier 雙單位內容修改
# Modify.........: No.FUN-560043 05/07/13 By Smapmin OPEN imgg_lock 條件錯誤
# Modify.........: No.FUN-580133 05/08/24 By Carrier 修改多單位境外倉 
# Modify.........: No.FUN-5C0075 05/12/27 By Elva 新增成品替代內容
# Modify.........: No.FUN-590088 06/01/11 By Sarah p650_u_oeb()中,增加更新訂單已備置量
# Modify.........: No.FUN-610057 06/01/11 By Carrier 出貨驗收功能 -- 新增出貨需驗/客戶驗收/客戶驗退功能 oga09=7/8/9
# Modify.........: No.FUN-610064 06/02/16 By wujie    針對分銷版出貨單（atmt242）增加代送出貨的判斷
# Modify.........: No.FUN-640014 06/04/08 By Sarah 1.tup_file的Key值應該是tup11,tup12,而非tup08,tup09
#                                                  2.原本判斷oga09='7'的,改成判斷oga09='2' AND oga65='Y'
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: NO.MOD-660127 06/07/05 BY yiting 出至境外倉扣帳還原沒有卡負庫
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-690083 06/09/27 By Sarah 當輸入寄銷訂單後(g_oga.oga00='7'),系統不應判斷此客戶設定是否為'客戶庫存管理'
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: NO.MOD-6B0062 06/11/16 BY claire 修改 MOD-4B0304
# Modify.........: No.TQC-6B0174 06/12/21 BY Ray 在途倉拋轉還原時未考慮批號
# Modify.........: No.FUN-710046 07/01/23 By cheunl 錯誤訊息匯整
# Modify.........: No.FUN-740016 07/05/09 By Nicola 借出管理
# Modify.........: No.MOD-780017 07/08/03 By claire 考慮替代時料號改變不可仍延用單身料號
# Modify.........: No.MOD-790023 07/09/06 By claire 出自境外倉出貨單當還原扣帳時,ogb31訂單號碼若為空白改傳出貨單號
# Modify.........: No.MOD-7A0001 07/10/01 By claire (1) p650_du() 增加判斷若母單位數量為0 不lock imgg_file
#                                                   (2) delete tlf_file ,tlff_file 使用變數應為b_ogb.* 
#                                                   (3) 9/30 簽收單過帳後的驗退單產生日期為 10/1 (g_today) 定義 l_oga02
#                                                   (4) 為程式嚴謹度 在delete tlf_file(tlff_file,oga_file,oga_fil) 加入sqlca.sqlerrd[3] 的判斷 (改ora)
# Modify.........: No.MOD-7A0084 07/10/16 By claire tuq_file 條件少了tuq05,tuq051造成 select 會有-284的錯誤
# Modify.........: No.FUN-7A0038 07/10/22 By Carrier 調貨出貨扣帳還原時,oga1012/oga1014賦值為NULL/N 
# Modify.........: No.TQC-7C0001 07/12/01 By xufeng 過賬后無法還原
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.FUN-7B0018 08/03/06 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-840244 08/04/20 By Nicola 做批/序管理才刪除tlfs_file 
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.MOD-890095 08/09/10 By Smapmin 當有做成品替代且多倉儲出貨時，在出貨還原時會出錯.
# Modify.........: No.MOD-890123 08/09/25 By Smapmin 過帳還原時,產生的調撥單若不能過帳還原,整個動作應該要ROLLBACK
# Modify.........: No.MOD-8A0208 08/10/23 By chenyu 鎖表的時候失敗，有的地方不應該用ROLLBACK WORK,應該LET g_success = 'N'
# Modify.........: No.CHI-8B0048 08/11/28 By claire (1)多角單據扣帳拋轉還原失敗,不再詢問直接做拋轉還原 
#                                                   (2)接收參數判斷是扣帳後拋轉失敗或扣帳還原串入  
# Modify.........: No.TQC-8C0027 08/12/15 By Nicola 償價數量更新修改
# Modify.........: No.MOD-8C0217 08/12/23 By Smapmin 判斷是否已存在帳款資料,應過濾作廢的情況.
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 rowid
# Modify.........: No.MOD-920195 09/02/16 By Smapmin 多單位:參考單位,若只打單據單位而不打參考單位,就不用刪除tlff_file
# Modify.........: No.FUN-930038 09/03/06 By kim 借貨單的刻號/BIN資料過帳時要拋轉至調撥單，調撥單刪除時要拋轉回借貨單
# Modify.........: No.MOD-970237 09/08/22 By Smapmin 借貨出貨流程,過帳時未回寫備置量
# Modify.........: No.FUN-980010 09/08/27 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990233 09/09/28 By Dido 增加多角回寫訂單部分
# Modify.........: No:CHI-970040 09/11/02 By Smapmin 客戶簽收流程,過帳還原時無法刪除tlfs_file/rvbs_file的資料
# Modify.........: No:MOD-9A0172 09/11/03 By Smapmin 同CHI-970040
# Modify.........: No:MOD-9C0049 09/12/04 By Smapmin 出至境外倉出貨單無法過帳還原
# Modify.........: No:CHI-9C0009 09/12/04 By Dido 銷售正拋已刪除 tlf_file,在此可不用再做一次 
# Modify.........: No:MOD-9C0226 09/12/25 By jan 出貨單過帳時有做『限定倉管員』的檢查，取消過帳沒有
# Modify.........: No:FUN-9C0071 10/01/11 By huangrh 精簡程式
# Modify.........: No:CHI-9C0037 10/01/14 By Dido 因銷售正拋扣庫存時已產生tlf_file,故還原時應刪除tlf_file
# Modify.........: No:MOD-A10160 10/01/27 By Smapmin 多倉儲出貨做批序號管理時,無法過帳還原
# Modify.........: No:MOD-A20117 10/03/02 By Smapmin 使用多單位且多倉儲出貨時,無法update imgs_file
# Modify.........: No:FUN-A20044 10/03/22 By JIACHENCHAO 更改关于字段ima26的相关语句
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:MOD-A50076 10/06/15 By Smapmin 修改出貨簽收流程update oeb23/oeb24的時機點
# Modify.........: No:MOD-A90056 10/09/08 By Smapmin 使用批序號功能,做替代時,無法過帳還原
# Modify.........: No:TQC-AA0010 10/10/08 By houlia 組 SQL 有誤:  tlf037 及 tlf027 後面用上兩個刮號，卻沒有對應的左刮號
# Modify.........: No.FUN-A90049 10/10/12 By huangtao 刪除異動檔之前增加料號參數的判斷
# Modify.........: No:MOD-AB0073 10/11/09 By Smapmin 修改變數型態
# Modify.........: No:TQC-AC0233 10/12/24 By huangtao 庫存過帳還原的時候庫存數量異常
# Modify.........: No:MOD-AB0151 10/12/24 By Summer 修改訂單待出貨數量的算法
# Modify.........: No:MOD-AC0257 10/12/24 By Smapmin 修正MOD-AB0151
# Modify.........: No:CHI-AC0034 11/01/06 By Summer 出貨簽收流程/出至境外倉產生的tlf,過帳還原時料號有錯
# Modify.........: No:TQC-B10066 11/01/11 By shiwuying 物返金額可以為0
# Modify.........: No.MOD-AC0060 11/01/25 By Smapmin 要一併刪除調撥單的rvbs_file
# Modify.........: No:MOD-B10172 11/01/26 By Summer 客戶簽收單確認(過帳)時，若銷售單位<>庫存單位會異常
# Modify.........: No:MOD-B30475 11/03/15 By Summer 刪除ogc_file之前,先count(*)ogc_file的筆數大於0再刪 
# Modify.........: No:MOD-B30464 11/03/15 By Summer 還原CHI-8B0048的修改 
# Modify.........: No:CHI-B30093 11/04/26 By lilingyu 出貨簽收功能
# Modify.........: No:FUN-AC0074 11/05/08 By jan
# Modify.........: No:FUN-B40098 10/05/18 By shiwuying 扣率代銷時產生一筆非成本倉的雜發單和成本倉的入庫單
# Modify.........: No:MOD-B60014 11/06/01 By lixia 修改m_ogb915,m_ogb917變量定義類型
# Modify.........: No:CHI-B60054 11/06/08 By yinhy MARK掉CHI-B30093單號更改內容
# Modify.........: No.FUN-B70074 11/07/21 By fengrui(imni_file By xianghui) 添加行業別表的新增於刪除
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.TQC-B90236 11/10/28 By zhuhao rvbs09=-1改為rvbs09=1
# Modify.........: No:TQC-BA0136 11/11/14 By jason 多倉儲批且走客戶簽收過帳和過帳還原會有問題
# Modify.........: No.FUN-910088 12/01/16 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BC0064 12/02/07 By xumeimei 增加出貨單axmt620扣賬還原相關邏輯
# Modify.........: No.FUN-BA0069 12/02/07 By yangxf 修改過帳/過帳還原時更新會員銷售及積分,加入積分款別
# Modify.........: No.FUN-BC0071 12/02/08 By huangtao 出貨過帳還原時，判斷出貨單身的換贈資料
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行
# Modify.........: NO.TQC-C20501 12/02/27 By huangtao 修改FUN-BC0071bug
# Modify.........: No:FUN-BB0167 11/12/05 By suncx 新增無訂單出貨走客戶簽收過帳和過帳還原
# Modify.........: No:CHI-B40056 12/02/29 By Summer tup08,tup09是No Use不使用的欄位,調整為tup11,tup12 
# Modify.........: No:TQC-C30097 12/03/05 By huangtao 過帳還原時，更新非訂單轉入的儲值金額
# Modify.........: No:FUN-BB0081 12/03/14 By Sakura 成品替代增加多單位替代功能
# Modify.........: No:FUN-C30289 12/04/12 By bart 恢復p650_u_img()
# Modify.........: No:FUN-910115 12/05/10 By Vampire axmt628 新增做廢功能
# Modify.........: No:FUN-C40072 12/05/29 By Sakura 扣帳還原加入oga09='4'
# Modify.........: No:FUN-C50097 12/06/04 By SunLM 當oaz92=Y(立賬走開票流程)且大陸版時,判斷參數oaz94='Y'(出貨多次簽收)時，增加多次簽收功能
# Modify.........: No:FUN-C50097 12/06/27 By SunLM 因前期分析不足,修改時間過長,為避免影響他人作業,暫時mark掉,待其他同仁完成后,再恢復
# Modify.........: No:TQC-C50225 12/07/04 By zhuhao 訂單已結案，不允許做過賬還原
# Modify.........: No:CHI-C60022 12/07/10 By Summer 寄銷出貨、出至境外倉出貨,扣帳還原imgs_file錯誤
# Modify.........: No:MOD-C70055 12/07/11 By Elise 出貨單扣帳時，與tlf_file記錄的入庫數量不一致
# Modify.........: No:FUN-C70045 12/07/12 By yangxf 单据类型调整
# Modify.........: No:MOD-C70145 12/07/13 By Carrier 出货签收多仓储过帐还原数量错误
# Modify.........: No:TQC-C70206 12/07/27 By SunLM將FUN-C50097中，非多次多次簽收功能過單到正式區，既與oaz94無關的參數。
# Modify.........: No:TQC-C70125 12/08/10 By yangtt 【出貨單號】欄位增加開窗
# Modify.........: No:FUN-C90007 12/09/10 By nanbing t600_del_lsn() 中增加判斷條件
# Modify.........: No:CHI-C90032 12/10/25 By pauline 出貨扣帳還原時業務額度邏輯修改
# Modify.........: No:MOD-CB0050 12/11/12 By SunLM 走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
# Modify.........:                                 出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
# Modify.........: No.MOD-CB0083 12/11/13 By SunLM "2"類型的出貨單以及"2/3"類型的銷退單不能開立發票,同時不更新發票倉庫存
# Modify.........: No.FUN-D10040 13/01/21 By xumm 扣帐还原更新为发售状态同时应更新已用门店和已用日期
# Modify.........: No:FUN-D30007 13/03/04 By pauline 異動lpj_file時同步異動lpjpos欄位
# Modify.........: No:MOD-D10185 13/03/12 By jt_chen MISC無庫存資料，故不應該產生調撥單。扣帳還原 axmp650 也須調整
# Modify.........: NO:TQC-D30066 12/03/26 By lixh1 其他作業串接時更改提示信息apm-936
# Modify.........: NO:MOD-D70030 13/07/25 By SunLM 出货单过帐时更新oeb24,在签退单过帐时再次更新


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oga		RECORD LIKE oga_file.*
DEFINE b_ogb		RECORD LIKE ogb_file.*
DEFINE b_ogb_t		RECORD LIKE ogb_file.*   #MOD-7A0001 add
DEFINE g_oga02_t        LIKE oga_file.oga02      #MOD-7A0001 add
DEFINE g_wc,g_wc2,g_sql STRING  #No.FUN-580092 HCN  
DEFINE g_argv1		LIKE oea_file.oea01     #No.FUN-540049  #No.FUN-680137 VARCHAR(16)
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL  #No.FUN-540049   
#DEFINE g_argv3          LIKE type_file.chr1      #CHI-8B0048 add #MOD-B30464 mark
DEFINE m_ogb12           LIKE ogb_file.ogb12,       #No.FUN-610057
       m_ogb912          LIKE ogb_file.ogb12,       #No.FUN-610057
       #m_ogb915          LIKE ogb_file.ogb15,       #No.FUN-610057
       #m_ogb917          LIKE ogb_file.ogb17        #No.FUN-610057
       m_ogb915          LIKE ogb_file.ogb915,       #No.FUN-610057  #MOD-B60014
       m_ogb917          LIKE ogb_file.ogb917        #No.FUN-610057  #MOD-B60014
DEFINE l_oha            RECORD LIKE oha_file.*,     #No.FUN-610064
       l_ohb            RECORD LIKE ohb_file.*      #No.FUN-610064
DEFINE   g_cnt           LIKE type_file.num10       #No.FUN-680137 INTEGER
DEFINE l_ima918   LIKE ima_file.ima918 #No.MOD-840244
DEFINE l_ima921   LIKE ima_file.ima921 #No.MOD-840244
DEFINE g_type        LIKE type_file.chr2   #MOD-9A0172   #MOD-AB0073 chr1-->chr2
DEFINE m_ogc12           LIKE ogc_file.ogc12    #CHI-AC0034 add
DEFINE g_type_t        LIKE type_file.chr2    #FUN-C50097  TQC-C70206
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1=ARG_VAL(1)
   #LET g_argv3=ARG_VAL(3)     #CHI-8B0048 #MOD-B30464 mark
    LET g_oga.oga01=g_argv1

#TQC-D30066 ------Begin--------
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' AND NOT cl_null(g_oga.oga01) THEN
      CALL cl_err('','apm-936',1)
      EXIT PROGRAM
   END IF
#TQC-D30066 ------End----------
#FUN-BC0062 --begin--
#  SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'   #TQC-D30066 mark
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-937',1)
      EXIT PROGRAM
   END IF
#FUN-BC0062 --end--
 
    SELECT * INTO l_oha.* FROM oha_file
     WHERE oha1018 = g_oga.oga01
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
    OPEN WINDOW p650_w WITH FORM "axm/42f/axmp650" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    LET g_type = '1'   #MOD-9A0172
    CALL p650_p1()
    CLOSE WINDOW p650_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p650_p1()
   DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_flag  LIKE type_file.num5          #No.FUN-680137 SMALLINT
   DEFINE l_imm03 LIKE imm_file.imm03   #No.FUN-740016 
   DEFINE l_ogb   RECORD LIKE ogb_file.*
   DEFINE l_tot   LIKE oeb_file.oeb24
   DEFINE l_ocn03   LIKE ocn_file.ocn03
   DEFINE l_ocn04   LIKE ocn_file.ocn04
   DEFINE l_oeb      RECORD
                      oeb04     LIKE oeb_file.oeb04,
                      oeb05_fac LIKE oeb_file.oeb05_fac,
                      oeb12     LIKE oeb_file.oeb12,
                      oeb19     LIKE oeb_file.oeb19,
                      oeb24     LIKE oeb_file.oeb24,
                      oeb25     LIKE oeb_file.oeb25,
                      oeb26     LIKE oeb_file.oeb26,
                      oeb905    LIKE oeb_file.oeb905
                     END RECORD
  # DEFINE l_ima262   LIKE ima_file.ima262,#FUN-A20044
   DEFINE l_avl_stk   LIKE type_file.num15_3,#FUN-A20044
          l_qoh      LIKE oeb_file.oeb12 
   DEFINE l_avl_stk_mpsmrp LIKE  type_file.num15_3 #FUN-A20044
   DEFINE l_unavl_stk LIKE  type_file.num15_3 #FUN-A20044
   DEFINE l_flag1    LIKE type_file.chr1  #FUN-B70074
 WHILE TRUE
   LET g_action_choice = ''
   CALL cl_opmsg('z')
 #MOD-B30464 mark --start--
 #IF NOT cl_null(g_oga.oga01) THEN 
 # SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_oga.oga01
 #END IF 
 #IF g_argv3='z' OR cl_null(g_argv3) THEN
 # #若為多角單據扣帳時失敗,不再等待輸入是否要執行還原transation
 #MOD-B30464 mark --end--
   INPUT BY NAME g_oga.oga01 WITHOUT DEFAULTS 
     AFTER FIELD oga01
        SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_oga.oga01
        IF STATUS THEN
           CALL cl_err3("sel","oga_file",g_oga.oga01,"",STATUS,"","sel oga:",0)     #FUN-660167
           NEXT FIELD oga01
        END IF
        IF g_oga.ogapost='N' THEN
           CALL cl_err('ogapost=N:','axm-206',0) NEXT FIELD oga01
        END IF
        IF NOT cl_null(g_sma.sma53) AND g_oga.oga02 <= g_sma.sma53 THEN
	   CALL cl_err('','mfg9999',0) 
           NEXT FIELD oga01
        END IF
        IF g_oga.oga00 MATCHES '[37]' THEN   #No.FUN-610064
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt FROM oea_file 
            WHERE oea12 = g_oga.oga01 
              AND oea00 = '4' AND oea11='7' AND oeaconf !='X'
           IF l_cnt > 0 THEN 
              CALL cl_err('','axm-811',0)
              NEXT FIELD oga01 
           END IF 
        END IF   
       #TQC-C50225 -- add -- begin
        LET l_cnt = 0
        SELECT COUNT(*) INTO l_cnt FROM oeb_file
         WHERE oeb70 = 'Y'
           AND oeb01||oeb03 IN
               (SELECT ogb31||ogb32 FROM ogb_file WHERE ogb01 = g_oga.oga01)
        IF l_cnt > 0 THEN
           CALL cl_err('','axm1055',1) 
           NEXT FIELD oga01
        END IF
       #TQC-C50225 -- add -- end
        #IF g_oga.oga65 = 'Y' AND g_oga.oga09='2' THEN   #FUN-640014
        #IF g_oga.oga65 = 'Y' AND g_oga.oga09 MATCHES '[23]' THEN   #FUN-BB0167 #FUN-C40072 mark
         IF g_oga.oga65 = 'Y' AND g_oga.oga09 MATCHES '[234]' THEN  #FUN-C40072 add 4
            SELECT COUNT(*) INTO l_cnt FROM oga_file
             WHERE oga011 = g_oga.oga01
               AND oga09 IN ('8','9')
               AND ogaconf <> 'X' #FUN-910115 add
            #此出貨需驗單有驗收或是驗退資料! 不可再做任何處理!
            IF l_cnt > 0 THEN
                CALL cl_err(g_oga.oga01,'axm-422',1)
                RETURN
            END IF
        END IF
        IF g_oga.oga909 = 'Y' and g_oga.oga905='Y' THEN
           CALL cl_err(g_oga.oga01,'tri-013',0)
           NEXT FIELD oga01
        END IF
         SELECT COUNT(oha01) INTO g_cnt
           FROM ohb_file,oha_file   #MOD-6B0062 add oha_file
          WHERE ohb31=g_oga.oga01
            AND oha01 = ohb01
            AND ohaconf != 'X'
         IF g_cnt > 0 THEN
             #已有銷退資料不可將此出貨單扣帳還原
             CALL cl_err(g_oga.oga01,'axm-650',1)
             NEXT FIELD oga01
         END IF
    
      #TQC-C70125-----add---str--
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(oga01)
             CALL cl_init_qry_var()
             LET g_qryparam.form ="q_oga01_2"
             LET g_qryparam.default1 = g_oga.oga01
             CALL cl_create_qry() RETURNING g_oga.oga01
             DISPLAY BY NAME g_oga.oga01
             NEXT FIELD oga01
         END CASE
    #TQC-C70125-----add---end--
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG
         CALL cl_cmdask()
      ON ACTION locale
         LET g_action_choice='locale'
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT INPUT
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
   END INPUT
   IF g_action_choice = 'locale' THEN
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF cl_sure(0,0) THEN #MOD-B30464 add
 #MOD-B30464 mark --start-- 
 # IF NOT cl_sure(0,0) THEN RETURN END IF 
 #ELSE 
 #END IF                 
 #MOD-B30464 mark --end--
 
      IF g_oga.oga00 = "A" THEN
         #MOD-D10185 add start -----
         SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE ogb01 = g_oga.oga01 AND ogb04 NOT LIKE 'MISC%'
         IF l_cnt > 0 THEN
         #MOD-D10185 add end   -----
            CALL p650_delimm()
            SELECT imm03 INTO l_imm03 FROM imm_file
             WHERE imm01=g_oga.oga70
            IF l_imm03 = "N" THEN
               IF NOT p650_icd_del_chk() THEN
                  LET g_success='N'
                  RETURN
               END IF
               DELETE FROM imn_file WHERE imn01 = g_oga.oga70
               #FUN-B70074-add-str--
               IF NOT s_industry('std') THEN 
                  LET l_flag1 = s_del_imni(g_oga.oga70,'','')
               END IF
               #FUN-B70074-add-end--
               DELETE FROM imm_file WHERE imm01 = g_oga.oga70
               DELETE FROM rvbs_file WHERE rvbs01 = g_oga.oga70   #MOD-AC0060
               UPDATE oga_file SET ogapost = "N",
                                   oga70 = ""
                WHERE oga01 = g_oga.oga01
               DECLARE p650_imm_c CURSOR FOR
                       SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01 ORDER BY ogb03
               
               FOREACH p650_imm_c INTO l_ogb.*
                   
                  SELECT oeb24 INTO l_tot FROM oeb_file
                   WHERE oeb01 = l_ogb.ogb31
                     AND oeb03 = l_ogb.ogb32
               
                  LET l_tot = l_tot-l_ogb.ogb12
               
                  UPDATE oeb_file SET oeb24=l_tot
                   WHERE oeb01 = l_ogb.ogb31
                     AND oeb03 = l_ogb.ogb32
              
                 #CHI-C90032 mark START 
                 #SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
                 # WHERE ocn01 = g_oga.oga14
               
                 #LET l_ocn03 = l_ocn03+(g_oga.oga24*l_ogb.ogb14)
                 #LET l_ocn04 = l_ocn04-(g_oga.oga24*l_ogb.ogb14)
               
                 #UPDATE ocn_file SET ocn03 = l_ocn03,
                 #                    ocn04 = l_ocn04
                 # WHERE ocn01 = g_oga.oga14
                 #CHI-C90032 mark END
                  #更新已備置量 
                 #FUN-AC0074--begin--mod-----
                  CALL s_updsie_unsie(l_ogb.ogb01,l_ogb.ogb03,'2') #FUN-AC0074
                 #SELECT oeb04,oeb05_fac,oeb12,oeb19,oeb24,oeb25,oeb26,oeb905 
                 # INTO l_oeb.*
                 #  FROM oeb_file WHERE oeb01=l_ogb.ogb31 AND oeb03=l_ogb.ogb32
                 #IF l_oeb.oeb19 = 'Y' THEN
                 #   IF l_oeb.oeb905 >= l_ogb.ogb12 THEN
                 #      LET l_oeb.oeb905=l_oeb.oeb905+l_ogb.ogb12
                 #   ELSE
                 #      LET l_oeb.oeb905=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26 #未交量
                 #   END IF
                 #
                 #   #備置量不可大於可用庫存量
                 #   ##可用庫存量
                 #  # SELECT ima262 INTO l_ima262 FROM ima_file
                 #   # WHERE ima01 = l_oeb.oeb04
                 #  # IF cl_null(l_ima262) THEN LET l_ima262 = 0 END IF  #FUN-A20044
                 #    CALL s_getstock(l_oeb.oeb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk
                 #   ##備置量
                 #   SELECT SUM(oeb905*oeb05_fac) INTO l_oeb.oeb12 FROM oeb_file
                 #    WHERE oeb04 = l_oeb.oeb04
                 #      AND (oeb01 != l_ogb.ogb31 OR oeb03 != l_ogb.ogb32)
                 #      AND oeb70 = 'N'
                 #   IF cl_null(l_oeb.oeb12) THEN LET l_oeb.oeb12 = 0 END IF
                 #
                 # #  LET l_qoh = l_ima262 - l_oeb.oeb12  #FUN-A20044`
                 #   LET l_qoh = l_avl_stk - l_oeb.oeb12  #FUN-A20044`
                 #
                 #   IF l_qoh < l_oeb.oeb905 THEN  #庫存不足
                 #      LET l_oeb.oeb905 = 0
                 #   END IF
                 #
                 #   UPDATE oeb_file SET oeb905 = l_oeb.oeb905
                 #    WHERE oeb01 = l_ogb.ogb31
                 #      AND oeb03 = l_ogb.ogb32
                 #END IF
                 #FUN-AC0074--end--mod----
               END FOREACH
            END IF
         #MOD-D10185 add start -----
         ELSE
            UPDATE oga_file SET ogapost = "N" WHERE oga01 = g_oga.oga01
            DECLARE p650_imm_d CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01 ORDER BY ogb03
            FOREACH p650_imm_d INTO l_ogb.*
               SELECT oeb24 INTO l_tot FROM oeb_file
                WHERE oeb01 = l_ogb.ogb31
                  AND oeb03 = l_ogb.ogb32

               LET l_tot = l_tot-l_ogb.ogb12

               UPDATE oeb_file SET oeb24=l_tot
                WHERE oeb01 = l_ogb.ogb31
                  AND oeb03 = l_ogb.ogb32
            END FOREACH
         END IF
        #MOD-D10185 add end   -----
         RETURN
      END IF
 
      LET g_success = 'Y'
      BEGIN WORK
      CALL p650_s1() 
     #FUN-B40098 Begin---
      IF g_success = 'Y' THEN
         CALL t620sub1_z('1',g_oga.oga01)
      END IF
     #FUN-B40098 End-----
      CALL p650_add_undo()    #FUN-BC0064
#FUN-BC0071 ------------------STA
#     IF g_success = 'Y' THEN
#        CALL t600_upd_lqe1(g_oga.*)     #TQC-C30097 mark
#     END IF
      IF g_success = 'Y' THEN
         CALL t600_del_lsn(g_oga.*)
      END IF
#FUN-BC0071 ------------------END 
      CALL s_showmsg()                 #No.FUN-710046
      IF g_success = 'Y' THEN
         COMMIT WORK
        #IF g_argv3='z' OR cl_null(g_argv3) THEN #CHI-8B0048 add #MOD-B30464 mark
            CALL cl_end2(1) RETURNING l_flag
        #END IF #CHI-8B0048 #MOD-B30464 mark
      ELSE
         ROLLBACK WORK
        #IF g_argv3='z' OR cl_null(g_argv3) THEN #CHI-8B0048 add #MOD-B30464 mark
            CALL cl_end2(2) RETURNING l_flag
        #END IF #CHI-8B0048 #MOD-B30464 mark
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF  #MOD-B30464 add
   IF NOT cl_null(g_argv1) THEN RETURN END IF
 END WHILE
END FUNCTION
 
#FUN-BC0064----add----str----
FUNCTION p650_add_undo()
DEFINE l_cnt          LIKE type_file.num5
DEFINE l_n            LIKE type_file.num5
DEFINE l_ima154       LIKE ima_file.ima154
DEFINE l_rxy_file     RECORD LIKE rxy_file.*
DEFINE l_lqe_file     RECORD LIKE lqe_file.*
DEFINE l_ogb          RECORD LIKE ogb_file.*
DEFINE l_rxe04        LIKE rxe_file.rxe04
DEFINE l_rxe05        LIKE rxe_file.rxe05
DEFINE max_lsm05      LIKE lsm_file.lsm05     #FUN-BA0069 add
DEFINE l_rxx04_point  LIKE rxx_file.rxx04     #FUN-BA0069 add

    IF g_success = 'Y' THEN
        SELECT COUNT(*) INTO l_cnt
          FROM rxy_file
         WHERE rxy00 = '02'
           AND rxy01 = g_oga.oga01
           AND rxy03 = '04'
        IF l_cnt > 0 THEN
           LET g_sql = " SELECT * FROM rxy_file ",
                       "  WHERE rxy00 = '02'",
                       "    AND rxy01 = '",g_oga.oga01,"' ",
                       "    AND rxy03 = '04' "
           DECLARE t600_sel_rxy_cr1 CURSOR FROM g_sql
           FOREACH t600_sel_rxy_cr1 INTO l_rxy_file.*
              UPDATE lqe_file
                 SET lqe17 = '1',
                     lqe24 = '',     #FUN-D10040 add 
                     lqe25 = ''      #FUN-D10040 add
                     #lqe18 = NULL,  #FUN-D10040 mark
                     #lqe19 = NULL   #FUN-D10040 mark
               WHERE lqe01 >= l_rxy_file.rxy14
                 AND lqe01 <= l_rxy_file.rxy15
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","lqe_file",g_oga.oga01,"",SQLCA.sqlcode,"","",1)
                 LET g_success = 'N'
                 RETURN
              END IF
              LET g_sql = " SELECT * FROM lqe_file ",
                          "  WHERE lqe01 >= '",l_rxy_file.rxy14,"' ",
                          "    AND lqe01 <= '",l_rxy_file.rxy15,"' "
              DECLARE t600_sel_lqe_cr1 CURSOR FROM g_sql
              FOREACH t600_sel_lqe_cr1 INTO l_lqe_file.*
                 SELECT COUNT(*) INTO l_n
                   FROM lqc_file
                  WHERE lqc01 = l_lqe_file.lqe01
                 IF l_n > 0 THEN
                    UPDATE lqc_file
                       SET lqc06 = lqc06 -1,
                           lqc04 = NULL
                     WHERE lqc01 = l_lqe_file.lqe01
                     IF SQLCA.sqlcode  THEN
                        CALL cl_err3("upd","lqc_file",l_lqe_file.lqe01,"",SQLCA.sqlcode,"","",1)
                        LET g_success = 'N'
                        RETURN
                     END IF
                 END IF
              END FOREACH
           END FOREACH
        END IF
     END IF

     LET g_sql = " SELECT * FROM ogb_file ",
                 "  WHERE ogb01 = '",g_oga.oga01,"' "
     DECLARE t600_sel_ogb_cr1 CURSOR FROM g_sql
     FOREACH t600_sel_ogb_cr1 INTO l_ogb.*
        LET g_cnt = g_cnt +1
        SELECT ima154 INTO l_ima154
          FROM ima_file
         WHERE ima01 = l_ogb.ogb04
        IF l_ima154 = 'Y' THEN
           LET g_sql = " SELECT rxe04,rxe05 FROM rxe_file ",
                     "  WHERE rxe01 = '",l_ogb.ogb01,"' ",
                     "    AND rxe02 = '",l_ogb.ogb03,"' "
           DECLARE t600sub_sel_rxe04_rxe05_cr CURSOR FROM g_sql
           FOREACH t600sub_sel_rxe04_rxe05_cr INTO l_rxe04,l_rxe05
              UPDATE lqe_file
                 SET lqe06 = NULL,
                     lqe07 = NULL,
                     lqe09 = g_oga.ogaplant,
                     lqe10 = g_oga.oga02,
                     lqe17 = '2'
               WHERE lqe01 >= l_rxe04
                 AND lqe01 <= l_rxe05
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","lqe_file",l_lqe_file.lqe01,"",SQLCA.sqlcode,"","",1)
                 LET g_success = 'N'
                 RETURN
              END IF
           END FOREACH
        END IF
     END FOREACH
     #FUN-BA0069 add begin ---
     IF g_azw.azw04 = '2' AND g_oga.oga94 ='N' AND NOT cl_null(g_oga.oga87) THEN
#       DELETE FROM lsm_file WHERE lsm01 = g_oga.oga87 AND lsm02 = '7' AND lsm03 = g_oga.oga01                        #FUN-C70045 MARK
#       DELETE FROM lsm_file WHERE lsm01 = g_oga.oga87 AND lsm02 = '9' AND lsm03 = g_oga.oga01                        #FUN-C70045 MARK
        DELETE FROM lsm_file WHERE lsm01 = g_oga.oga87 AND lsm02 = '7' AND lsm03 = g_oga.oga01 AND lsm15 = '1'        #FUN-C70045 add  
        DELETE FROM lsm_file WHERE lsm01 = g_oga.oga87 AND lsm02 = '9' AND lsm03 = g_oga.oga01 AND lsm15 = '1'        #FUN-C70045 add   
        SELECT SUM(rxy23) INTO l_rxx04_point
          FROM rxy_file
         WHERE rxy00 = '02'
           AND rxy01 = g_oga.oga01
           AND rxy03 = '09'
           AND rxyplant = g_oga.ogaplant
        IF cl_null(l_rxx04_point) THEN
           LET l_rxx04_point = 0
        END IF
        SELECT MAX(lsm05) INTO max_lsm05
          FROM lsm_file
         WHERE lsm01 = g_oga.oga87
#          AND lsm02 IN ('1','5','6','7','8')        #FUN-C70045 MARK
           AND lsm02 IN ('2','3','7','8')            #FUN-C70045 add
        UPDATE lpj_file
           SET lpj07 = COALESCE(lpj07,0) - 1,
               lpj08 = max_lsm05,
               lpj12 = COALESCE(lpj12,0) - g_oga.oga95 + l_rxx04_point,
               lpj13 = COALESCE(lpj13,0) - l_rxx04_point,
               lpj14 = COALESCE(lpj14,0) - g_oga.oga95,
               lpj15 = COALESCE(lpj15,0) - g_oga.oga51,
               lpjpos = '2'                               #FUN-D30007 add
         WHERE lpj03 = g_oga.oga87
         IF SQLCA.sqlcode  THEN
            CALL cl_err3("upd","lpj_file",g_oga.oga87,"",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            RETURN
         END IF
     END IF
     #FUN-BA0069 add end -----
END FUNCTION  
#FUN-BC0064----add----end----

#FUN-BC0071---------------STA
#FUNCTION t600_upd_lqe1(l_oga)
#DEFINE l_oga   RECORD LIKE oga_file.*
#DEFINE l_n     LIKE type_file.num5

# SELECT COUNT(*) INTO l_n FROM ogb_file,lpx_file,lqe_file,lqw_file
#  WHERE lpx32 = ogb04 AND lpx01 = lqe02
#    AND ogb01 = l_oga.oga01
#    AND lqw08 = lqe02 AND lqw00 = '02'
#    AND lqw01= l_oga.oga01
#    AND lqe01 BETWEEN lqw09 AND lqw10
#    AND lqe17 ='1'
#    AND lqe13 = l_oga.ogaplant
# IF l_n > 0 THEN

#    UPDATE lqe_file SET  lqe17 = '2',
#                         lqe06 = l_oga.ogaplant,
#                         lqe07 = g_today
#     WHERE lqe01 IN (SELECT lqe01 FROM ogb_file,lpx_file,lqe_file,lqw_file
#                      WHERE lpx32 = ogb04 AND lpx01 = lqe02
#                        AND ogb01 = l_oga.oga01
#          #             AND lqw08 = lqe02 AND lqw00 = '01'        #TQC-C20501 mark
#                        AND lqw08 = lqe02 AND lqw00 = '02'        #TQC-C20501 add
#                        AND lqw01= l_oga.oga01
#                        AND lqe01 BETWEEN lqw09 AND lqw10
#                        AND lqe17 ='1'
#                        AND lqe13 = l_oga.ogaplant)
#    IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
#       CALL cl_err3("upd","lqe_file",'',"",SQLCA.sqlcode,"","",1)
#       LET g_success = 'N'
#       RETURN
#    END IF
#  END IF

#END FUNCTION

FUNCTION t600_del_lsn(l_oga)
DEFINE l_oga    RECORD LIKE oga_file.*
DEFINE l_n      LIKE type_file.num5
DEFINE l_money  LIKE type_file.num20_6

   IF cl_null(l_oga.oga87) THEN RETURN END IF #FUN-C90007 add 
   SELECT COUNT(*) INTO l_n FROM ogb_file
    WHERE ogb01 = l_oga.oga01 AND ogb04= 'MISCCARD'
      AND (ogb31 = ' ' OR ogb31 IS NULL)       #TQC-C30097 add
   IF l_n >0 THEN
     SELECT SUM(ogb47+ogb14t) INTO l_money FROM ogb_file
      WHERE ogb01 = l_oga.oga01 AND ogb04= 'MISCCARD'
        AND (ogb31 = ' ' OR ogb31 IS NULL)       #TQC-C30097 add
     UPDATE lpj_file SET lpj06 = lpj06 - l_money,
                         lpjpos = '2'           #FUN-D30007 add
      WHERE lpj03 = l_oga.oga87
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL cl_err3("upd","lpj_file",'',"",SQLCA.sqlcode,"","",1)
        LET g_success = 'N'
        RETURN
     END IF

     IF g_success = 'Y' THEN
#       DELETE FROM lsn_file WHERE lsn01 = l_oga.oga87 AND lsn02 = 'F' AND lsn03 = l_oga.oga01                   #FUN-C70045 MARK
        DELETE FROM lsn_file WHERE lsn01 = l_oga.oga87 AND lsn02 = 'F' AND lsn03 = l_oga.oga01 AND lsn10 = '1'   #FUN-C70045 add
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","lsn_file",'',"",SQLCA.sqlcode,"","",1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
   END IF

END FUNCTION

#FUN-BC0071 --------------END

FUNCTION p650_s1()
  DEFINE l_ogc  RECORD LIKE ogc_file.*
  DEFINE l_ogg    RECORD LIKE ogg_file.*
  DEFINE l_ima906 LIKE ima_file.ima906
  DEFINE u_cnt    LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
  DEFINE l_oga01  LIKE oga_file.oga01   #No.FUN-610057
  DEFINE l_ogb    RECORD LIKE ogb_file.*  #No.FUN-610057
  DEFINE l_oga66  LIKE oga_file.oga66   #No.FUN-610057
  DEFINE l_oga67  LIKE oga_file.oga67   #No.FUN-610057
  DEFINE l_ima25  LIKE ima_file.ima25                                           
  DEFINE l_ima71  LIKE ima_file.ima71                                           
  DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac                                  
  DEFINE l_cnt,i  LIKE type_file.num5                                                                #No.FUN-680137 SMALLINT
  DEFINE l_occ31  LIKE occ_file.occ31                                           
  DEFINE l_tuq06  LIKE tuq_file.tuq06                                           
  DEFINE l_tup05  LIKE tup_file.tup05                                           
  DEFINE l_tuq07  LIKE tuq_file.tuq07                                           
  DEFINE l_desc   LIKE type_file.chr1          #No.FUN-680137  VARCHAR(01)                                                    
  DEFINE l_item   LIKE ima_file.ima01  #FUN-5C0075                              
  DEFINE l_ogc17  LIKE ogc_file.ogc17  #FUN-5C0075                              
  DEFINE l_oga02  LIKE oga_file.oga02   #MOD-7A0001
 #DEFINE l_poz011 LIKE poz_file.poz011  #CHI-9C0009   #CHI-9C0037 mark
  DEFINE lj_result LIKE type_file.chr1  #CHI-9C0025
#FUN-910088--add--start--
  DEFINE l_tup05_1 LIKE tup_file.tup05,
         l_tuq07_1 LIKE tuq_file.tuq07,
         l_tuq09_1 LIKE tuq_file.tuq09
#FUN-910088--add--end--  
  DEFINE l_factor  LIKE type_file.num26_10  #FUN-C50097  
  DEFINE l_ogb50   LIKE ogb_file.ogb50      #FUN-C50097 
  DEFINE l_ogb51   LIKE ogb_file.ogb51       #FUN-C50097
  DEFINE l_img09       LIKE img_file.img09 #CHI-C60022 add
  DEFINE p_lot     LIKE img_file.img04, #FUN-C50097 
         l_qty1    LIKE img_file.img10, #FUN-C50097 
         l_qty2    LIKE img_file.img10,  #FUN-C50097
         m_ogg12   LIKE ogg_file.ogg12   #FUN-C50097
  DEFINE l_cnt2         LIKE type_file.num5  #MOD-CB0050
   
  CALL p650_u_oga()
  DECLARE p650_s1_c CURSOR FOR SELECT * FROM ogb_file WHERE ogb01=g_oga.oga01
  CALL s_showmsg_init()                     #No.FUN-710046
  FOREACH p650_s1_c INTO b_ogb.*
      IF STATUS THEN LET g_success='N' RETURN END IF
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF                                                                                                                         
      MESSAGE '_s1() read ogb:',b_ogb.ogb03 
      CALL ui.Interface.refresh()
      IF cl_null(b_ogb.ogb04) THEN CONTINUE FOREACH END IF
      IF cl_null(g_oga.oga99) THEN
         CALL s_incchk(b_ogb.ogb09,b_ogb.ogb091,g_user)
              RETURNING lj_result
         IF NOT lj_result THEN
            LET g_success = 'N'
            LET g_showmsg = b_ogb.ogb03,"/",b_ogb.ogb09,"/",b_ogb.ogb091,"/",g_user
            CALL cl_err(g_showmsg,'asf-888',1)
            RETURN
         END IF
      END IF
      SELECT COUNT(*) INTO g_cnt 
        FROM oma_file,omb_file    #MOD-8C0217   增加oma_file
       WHERE omb01 = g_oga.oga10
         AND omb31 = b_ogb.ogb01
         AND omb32 = b_ogb.ogb03
         AND oma01 = omb01   #MOD-8C0217
         AND omavoid != 'Y'   #MOD-8C0217
      IF g_cnt > 0 THEN
         CALL s_errmsg('','',"b_ogb.ogb01","axm-302",1)    #No.FUN-710046
         LET g_success='N'
         CONTINUE FOREACH     #No.FUN-710046
      END IF
      CALL p650_u_oeb()
      IF g_oaz.oaz03 = 'N' THEN CONTINUE FOREACH END IF
      IF b_ogb.ogb04[1,4]='MISC' THEN CONTINUE FOREACH END IF
      SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = b_ogb.ogb04
      IF b_ogb.ogb17='Y' THEN     ##多倉儲出貨
         DECLARE p650_s1_ogc_c CURSOR FOR  SELECT * FROM ogc_file 
            WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
         FOREACH p650_s1_ogc_c INTO l_ogc.*
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"FOREACH #1",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success='N' 
               EXIT FOREACH                #No.FUN-710046
            END IF
            MESSAGE '_s1() read ogc:',b_ogb.ogb03,'-',l_ogc.ogc091
            CALL ui.Interface.refresh()
            IF g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
               LET l_item = l_ogc.ogc17
            ELSE
               LET l_item = b_ogb.ogb04
            END IF
            #CHI-AC0034 add --start--
            IF g_oga.oga09 = '8' THEN
               ##FUN-C50097 ADD begin
               IF g_aza.aza26='2' AND g_oaz.oaz94 = 'Y'  THEN #FUN-C50097 ADD
                  SELECT SUM(ogc12) INTO m_ogc12
                    FROM ogc_file
                   WHERE ogc01 = g_oga.oga011
                     AND ogc03 = b_ogb.ogb03
                     AND ogc17 = l_ogc.ogc17
                     AND ogc092= l_ogc.ogc092    #No.MOD-C70145                     
                  IF cl_null(m_ogc12)  THEN LET m_ogc12  = 0 END IF
                  IF m_ogc12 != l_ogc.ogc12 THEN 
                     LET l_ogc.ogc12 = l_ogc.ogc12 + l_ogc.ogc13
                     LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac 
                     LET l_ogc.ogc16 = s_digqty(l_ogc.ogc16,l_ogc.ogc15) 
                  END IF                     
               ELSE #FUN-C50097 ADD end
                  SELECT SUM(ogc12) INTO m_ogc12
                    FROM ogc_file
                   WHERE ogc01 = g_oga.oga011
                     AND ogc03 = b_ogb.ogb03
                     AND ogc17 = l_ogc.ogc17
                     AND ogc092= l_ogc.ogc092    #No.MOD-C70145
                  IF cl_null(m_ogc12)  THEN LET m_ogc12  = 0 END IF
                  LET l_ogc.ogc12 = m_ogc12
                  LET l_ogc.ogc16 = l_ogc.ogc12 * l_ogc.ogc15_fac
               END IF #FUN-C50097 ADD
            END IF
            #CHI-AC0034 add --end--
            
#CHI-B60054  --Begin #MARK掉CHI-B30093更改
#CHI-B30093 --begin--            
#            IF g_oga.oga65 = 'Y' AND g_oga.oga09 = '2' THEN 
#               UPDATE ogc_file SET ogc12 = 0,
#                                   ogc16 = 0 
#                WHERE ogc01 = l_ogc.ogc01
#                  AND ogc03 = l_ogc.ogc09
#                  AND ogc09 = l_ogc.ogc09
#                  AND ogc091= l_ogc.ogc091
#                  AND ogc092= l_ogc.ogc092
#                  AND ogc17 = l_ogc.ogc17                   
#               CALL p650_u_img(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,l_ogc.ogc16,l_item)                                                            
#               LET g_type = '-1'                 
#               CALL p650_u_img(g_oga.oga66,g_oga.oga67,l_ogc.ogc092,l_ogc.ogc16,l_item)   
#               LET g_type = '1'      
#            ELSE 
#CHI-B30093 --end--            	
#CHI-B60054  --END #MARK掉CHI-B30093更改
               CALL p650_u_img(l_ogc.ogc09,l_ogc.ogc091,l_ogc.ogc092,l_ogc.ogc16,l_item)            	  
            #END IF      #CHI-B30093 #CHI-B60054 #MARK掉CHI-B30093更改	     
                                        
            IF g_success='N' THEN RETURN END IF
         END FOREACH
         
         LET l_flag = '0'   #MOD-920195
         DECLARE p650_s1_ogg_c CURSOR FOR  SELECT * FROM ogg_file 
            WHERE ogg01=g_oga.oga01 AND ogg03=b_ogb.ogb03
         FOREACH p650_s1_ogg_c INTO l_ogg.*
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"Foreach #1",SQLCA.sqlcode,1)   #No.FUN-710046
               LET g_success='N'
               RETURN               #No.FUN-710046
               EXIT FOREACH         #No.FUN-710046
            END IF
            MESSAGE '_s1() read ogg:',b_ogb.ogb03,'-',l_ogg.ogg091
            CALL ui.Interface.refresh()
#FUN-C50097 ADD BEGIN
            IF g_oga.oga09 = '8' THEN
               ##FUN-C50097 ADD begin
               IF g_aza.aza26='2' AND g_oaz.oaz94 = 'Y'  THEN #FUN-C50097 ADD
                  SELECT SUM(ogg12) INTO m_ogg12
                    FROM ogg_file
                   WHERE ogg01 = g_oga.oga011
                     AND ogg03 = b_ogb.ogb03
                     AND ogg17 = l_ogg.ogg17
                     AND ogg092= l_ogg.ogg092    #No.MOD-C70145                     
                  IF cl_null(m_ogg12)  THEN LET m_ogg12  = 0 END IF
                  IF m_ogg12 != l_ogg.ogg12 THEN 
                     LET l_ogg.ogg12 = l_ogg.ogg12 + l_ogg.ogg13
                     LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac 
                     LET l_ogg.ogg16 = s_digqty(l_ogg.ogg16,l_ogg.ogg15) 
                  END IF                     
               ELSE #FUN-C50097 ADD end
                  SELECT SUM(ogg12) INTO m_ogg12
                    FROM ogg_file
                   WHERE ogg01 = g_oga.oga011
                     AND ogg03 = b_ogb.ogb03
                     AND ogg17 = l_ogg.ogg17
                     AND ogg092= l_ogg.ogg092    #No.MOD-C70145
                  IF cl_null(m_ogg12)  THEN LET m_ogg12  = 0 END IF
                  LET l_ogg.ogg12 = m_ogg12
                  LET l_ogg.ogg16 = l_ogg.ogg12 * l_ogg.ogg15_fac
               END IF #FUN-C50097 ADD
            END IF            
#FUN-C50097 ADD END            
            #-----MOD-A20117---------
            IF l_ima906 = '1' THEN 
               IF g_sma.sma115='Y' THEN 
                 #CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')     
                  CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')        #No:FUN-BB0081
               END IF
            END IF
            #-----END MOD-A20117-----
            IF l_ima906 = '2' THEN
               IF l_ogg.ogg20 = '1' THEN
                  CALL p650_du(l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                               '','','',l_ogg.ogg10,1,l_ogg.ogg12,'1')
               ELSE
                  CALL p650_du(l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                               l_ogg.ogg10,1,l_ogg.ogg12,'','','','1')
               END IF
               #-----MOD-A20117---------
               IF g_sma.sma115='Y' THEN 
                 #CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')     
                  CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')        #No:FUN-BB0081
               END IF
               #-----END MOD-A20117-----
            END IF
            IF l_ima906 = '3' THEN
               IF l_ogg.ogg20 = '2' THEN
                  CALL p650_du(l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,
                               l_ogg.ogg10,1,l_ogg.ogg12,'','','','1')
                  LET l_flag = '1'   #MOD-920195
               END IF
               #-----MOD-A20117---------
               IF g_sma.sma115='Y' THEN 
                 #CALL s_upimg_imgs(b_ogb.ogb04,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')     
                  CALL s_upimg_imgs(l_ogg.ogg17,l_ogg.ogg09,l_ogg.ogg091,l_ogg.ogg092,1,g_oga.oga01,b_ogb.ogb03,l_ogg.ogg10,'2')        #No:FUN-BB0081
               END IF
               #-----END MOD-A20117-----
            END IF
            IF g_success='N' THEN 
               EXIT FOREACH         #No.FUN-710046
            END IF
         END FOREACH
         IF g_sma.sma115 = 'Y' THEN
            IF l_ima906 = '2' OR l_flag = '1'  THEN   #MOD-920195   
                  CALL p650_tlff('1')   #No:FUN-BB0081
                  IF g_success='N' THEN
                     CONTINUE FOREACH     #No.FUN-710046
                  END IF
            END IF
         END IF
#---------#FUN-C50097 ADD BEG-----大陸版走開票流程,多次簽收作業流程
         IF g_oga.oga09 = '8' AND g_aza.aza26 = '2' THEN   #FUN-C50097 ADD             
           IF ((g_oaz.oaz92 = 'N' AND g_oaz.oaz93 = 'N') OR (g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'N') )  
               AND  g_oaz.oaz94 = 'Y'  THEN  #120727 add
               #更新ogb50,ogb51累计签收量和累计签退量
               SELECT ogb50,ogb51 INTO l_ogb50,l_ogb51 FROM ogb_file
                WHERE ogb01 =  g_oga.oga011
                  AND ogb03 = b_ogb.ogb03 
               LET l_ogb50 = l_ogb50 - b_ogb.ogb12
               LET l_ogb51 = l_ogb51 - b_ogb.ogb52
               IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
                  LET l_ogb50 = 0
               END IF 
               IF cl_null(l_ogb51) OR l_ogb51 < 0 THEN 
                  LET l_ogb51 = 0
               END IF
                    
               UPDATE ogb_file SET ogb50 = l_ogb50 ,
                                   ogb51 = l_ogb51 
                             WHERE ogb01 = g_oga.oga011
                               AND ogb03 = b_ogb.ogb03                   
               #下面代码将本次签收数量和本次签退数量还原到签收仓
               LET b_ogb.ogb12 = b_ogb.ogb12 + b_ogb.ogb52
               IF g_sma.sma115 = 'Y' THEN 
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=b_ogb.ogb04
                  IF l_ima906 = '2' THEN 
                     CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb910)
                        RETURNING l_cnt,l_factor
                     IF l_cnt = 1 THEN 
                        LET l_factor = 1 
                     END IF
                     LET b_ogb.ogb912 =  (b_ogb.ogb12 * l_factor) mod b_ogb.ogb914    #签退子单位数量
                     LET b_ogb.ogb915 =  (b_ogb.ogb12 * l_factor  - b_ogb.ogb912) / b_ogb.ogb914   #签退母单位数量                      
                  END IF 
                  IF l_ima906 = '3' THEN 
                     IF NOT cl_null(b_ogb.ogb911) THEN 
                        LET b_ogb.ogb912 = b_ogb.ogb12 / b_ogb.ogb911
                     END IF 
                     IF NOT cl_null(b_ogb.ogb914) THEN 
                        LET b_ogb.ogb915 = b_ogb.ogb12 / b_ogb.ogb914
                     END IF                  
                  END IF     
               END IF 
               IF NOT cl_null(b_ogb.ogb916) THEN
                  CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb916)
                       RETURNING l_cnt,l_factor
                  IF l_cnt = 1 THEN
                     LET l_factor = 1               	  
                  END IF 
                  LET b_ogb.ogb917 = b_ogb.ogb12 * l_factor
               END IF 
               LET b_ogb.ogb16 = b_ogb.ogb12*b_ogb.ogb15_fac
            END IF             
            IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND g_oaz.oaz94 = 'Y' THEN  
   #MOD-CB0050 add begin-------------------------------
               CALL p650_chk_ogb1001(b_ogb.ogb1001) RETURNING l_cnt2 
               IF l_cnt2 > 0 THEN
                  
                  #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                  #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
               ELSE 
   #MOD-CB0050 add end---------------------------------
                  IF g_oga.oga00 != '2' THEN  #MOD-CB0083
                     #扣减发票仓库存
                     CALL p650_u2_tlf() #删除发票仓tlf异动记录
                     LET g_type_t = g_type #保存舊值
                     LET g_type   = '-1'
                     DECLARE p650_s1_ogc_c1 CURSOR FOR  SELECT * FROM ogc_file 
                        WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
                     FOREACH p650_s1_ogc_c1 INTO l_ogc.*
                        IF SQLCA.SQLCODE THEN
                           CALL s_errmsg('','',"p650_s1_ogc_c1",SQLCA.sqlcode,1)  
                           LET g_success='N' 
                           EXIT FOREACH               
                        END IF
                        MESSAGE '_s1() read ogc:',b_ogb.ogb03,'-',l_ogc.ogc091
                        CALL ui.Interface.refresh()
                        IF g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
                           LET l_item = l_ogc.ogc17
                        ELSE
                           LET l_item = b_ogb.ogb04
                        END IF
                           CALL p650_u_img(g_oaz.oaz95,g_oga.oga03,l_ogc.ogc092,l_ogc.ogc16,l_item)            	                                          
                        IF g_success='N' THEN 
                           RETURN 
                        END IF
                     END FOREACH               
                     LET g_type = 1 #还原旧值
                     IF g_sma.sma115 = 'Y' THEN
                        CALL p650_u2_tlff()
                        #FOREACH 母单位存储批号 数量
                        DECLARE p650_ogg_c7 CURSOR FOR  
                         SELECT SUM(ogg16),ogg092 FROM ogg_file   
                          WHERE ogg01=b_ogb.ogb01 
                            AND ogg03=b_ogb.ogb03
                            AND ogg20='2'
                          GROUP BY ogg092   
                        FOREACH p650_ogg_c7 INTO l_qty2,p_lot
                           CALL p650_du(g_oaz.oaz95,g_oga.oga03,p_lot,b_ogb.ogb913,b_ogb.ogb914,l_qty2*-1,'','','','1') 
                           IF g_success='N' THEN 
                              CONTINUE FOREACH
                           END IF                                        
                        END FOREACH 
                        #FOREACH 子单位存储批号 数量
                        DECLARE p650_ogg_c6 CURSOR FOR  
                         SELECT SUM(ogg16),ogg092 FROM ogg_file   
                          WHERE ogg01=b_ogb.ogb01 
                            AND ogg03=b_ogb.ogb03
                            AND ogg20='1'
                          GROUP BY ogg092   
                        FOREACH p650_ogg_c6 INTO l_qty1,p_lot
                           CALL p650_du(g_oaz.oaz95,g_oga.oga03,p_lot,'','','',b_ogb.ogb910,b_ogb.ogb911,l_qty1*-1,'1') 
                           IF g_success='N' THEN 
                              CONTINUE FOREACH
                           END IF                                
                        END FOREACH                   
                        IF g_success='N' THEN 
                           CONTINUE FOREACH     
                        END IF
                     END IF                     
                  END IF #MOD-CB0083 add                              
               END IF #MOD-CB0050 add 
               #更新ogb50,ogb51累计签收量和累计签退量
               SELECT ogb50,ogb51 INTO l_ogb50,l_ogb51 FROM ogb_file
                WHERE ogb01 =  g_oga.oga011
                  AND ogb03 = b_ogb.ogb03 
               LET l_ogb50 = l_ogb50 - b_ogb.ogb12
               LET l_ogb51 = l_ogb51 - b_ogb.ogb52
               IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
                  LET l_ogb50 = 0
               END IF 
               IF cl_null(l_ogb51) OR l_ogb51 < 0 THEN 
                  LET l_ogb51 = 0
               END IF
                    
               UPDATE ogb_file SET ogb50 = l_ogb50 ,
                                   ogb51 = l_ogb51 
                             WHERE ogb01 = g_oga.oga011
                               AND ogb03 = b_ogb.ogb03                   
               #下面代码将本次签收数量和本次签退数量还原到签收仓
               LET b_ogb.ogb12 = b_ogb.ogb12 + b_ogb.ogb52
               IF g_sma.sma115 = 'Y' THEN 
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=b_ogb.ogb04
                  IF l_ima906 = '2' THEN 
                     CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb910)
                        RETURNING l_cnt,l_factor
                     IF l_cnt = 1 THEN 
                        LET l_factor = 1 
                     END IF
                     LET b_ogb.ogb912 =  (b_ogb.ogb12 * l_factor) mod b_ogb.ogb914    #签退子单位数量
                     LET b_ogb.ogb915 =  (b_ogb.ogb12 * l_factor  - b_ogb.ogb912) / b_ogb.ogb914   #签退母单位数量                      
                  END IF 
                  IF l_ima906 = '3' THEN 
                     IF NOT cl_null(b_ogb.ogb911) THEN 
                        LET b_ogb.ogb912 = b_ogb.ogb12 / b_ogb.ogb911
                     END IF 
                     IF NOT cl_null(b_ogb.ogb914) THEN 
                        LET b_ogb.ogb915 = b_ogb.ogb12 / b_ogb.ogb914
                     END IF                  
                  END IF     
               END IF 
               IF NOT cl_null(b_ogb.ogb916) THEN
                  CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb916)
                       RETURNING l_cnt,l_factor
                  IF l_cnt = 1 THEN
                     LET l_factor = 1               	  
                  END IF 
                  LET b_ogb.ogb917 = b_ogb.ogb12 * l_factor
               END IF 
               LET b_ogb.ogb16 = b_ogb.ogb12*b_ogb.ogb15_fac
            END IF 
            IF g_oaz.oaz94 != 'Y' THEN
               IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN  
   #MOD-CB0050 add begin-------------------------------
                  CALL p650_chk_ogb1001(b_ogb.ogb1001) RETURNING l_cnt2
                  IF l_cnt2 > 0 THEN 
                     #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                     #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                  ELSE 
   #MOD-CB0050 add end---------------------------------
                     IF g_oga.oga00 != '2' THEN  #MOD-CB0083 
                        #扣减发票仓库存
                        CALL p650_u2_tlf() #删除发票仓tlf异动记录
                        LET g_type_t = g_type #保存舊值
                        LET g_type   = '-1'
                        DECLARE p650_s1_ogc_c6 CURSOR FOR  SELECT * FROM ogc_file 
                           WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
                        FOREACH p650_s1_ogc_c6 INTO l_ogc.*
                           IF SQLCA.SQLCODE THEN
                              CALL s_errmsg('','',"p650_s1_ogc_c6",SQLCA.sqlcode,1)  
                              LET g_success='N' 
                              EXIT FOREACH               
                           END IF
                           MESSAGE '_s1() read ogc:',b_ogb.ogb03,'-',l_ogc.ogc091
                           CALL ui.Interface.refresh()
                           IF g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
                              LET l_item = l_ogc.ogc17
                           ELSE
                              LET l_item = b_ogb.ogb04
                           END IF
                              CALL p650_u_img(g_oaz.oaz95,g_oga.oga03,l_ogc.ogc092,l_ogc.ogc16,l_item)            	                                          
                           IF g_success='N' THEN 
                              RETURN 
                           END IF
                        END FOREACH               
                        LET g_type = 1 #还原旧值
                        IF g_sma.sma115 = 'Y' THEN
                           CALL p650_u2_tlff()
                           #FOREACH 母单位存储批号 数量
                           DECLARE p650_ogg_c9 CURSOR FOR  
                            SELECT SUM(ogg16),ogg092 FROM ogg_file   
                             WHERE ogg01=b_ogb.ogb01 
                               AND ogg03=b_ogb.ogb03
                               AND ogg20='2'
                             GROUP BY ogg092   
                           FOREACH p650_ogg_c9 INTO l_qty2,p_lot
                              CALL p650_du(g_oaz.oaz95,g_oga.oga03,p_lot,b_ogb.ogb913,b_ogb.ogb914,l_qty2*-1,'','','','1') 
                              IF g_success='N' THEN 
                                 CONTINUE FOREACH
                              END IF                                        
                           END FOREACH 
                           #FOREACH 子单位存储批号 数量
                           DECLARE p650_ogg_c10 CURSOR FOR  
                            SELECT SUM(ogg16),ogg092 FROM ogg_file   
                             WHERE ogg01=b_ogb.ogb01 
                               AND ogg03=b_ogb.ogb03
                               AND ogg20='1'
                             GROUP BY ogg092   
                           FOREACH p650_ogg_c10 INTO l_qty1,p_lot
                              CALL p650_du(g_oaz.oaz95,g_oga.oga03,p_lot,'','','',b_ogb.ogb910,b_ogb.ogb911,l_qty1*-1,'1') 
                              IF g_success='N' THEN 
                                 CONTINUE FOREACH
                              END IF                                
                           END FOREACH                   
                           IF g_success='N' THEN 
                              CONTINUE FOREACH     
                           END IF
                        END IF  
                     END IF  #MOD-CB0083 add  
                  END IF #MOD-CB0050 add 
               END IF                      
               SELECT ogb12,ogb912,ogb915,ogb917 INTO m_ogb12,m_ogb912,m_ogb915,m_ogb917
                 FROM oga_file,ogb_file
                WHERE ogb01 = oga01
                  AND oga01 = g_oga.oga011
                  AND oga65 = 'Y'   #FUN-640014
                 #AND oga09 = '2'   #FUN-640014
                  AND (oga09 = '2' OR oga09 = '3')  #FUN-BB0167
                  AND ogb03 = b_ogb.ogb03
                IF cl_null(m_ogb12)  THEN LET m_ogb12  = 0 END IF
                IF cl_null(m_ogb912) THEN LET m_ogb912 = 0 END IF
                IF cl_null(m_ogb915) THEN LET m_ogb915 = 0 END IF
                IF cl_null(m_ogb917) THEN LET m_ogb917 = 0 END IF
                LET b_ogb.ogb12 = m_ogb12
                LET b_ogb.ogb912= m_ogb912
                LET b_ogb.ogb915= m_ogb915
                LET b_ogb.ogb917= m_ogb917
               #LET b_ogb.ogb16 = b_ogb.ogb12/b_ogb.ogb15_fac #MOD-B10172 mark
                LET b_ogb.ogb16 = b_ogb.ogb12*b_ogb.ogb15_fac #MOD-B10172
             END IF                 
         END IF
#--------#FUN-C50097 ADD END-----         
#FUN-C50097 ADD BEGIN-------#大陆版,还原产生的发票仓库存和tlf异动档
         IF g_oga.oga09 MATCHES '[23]' AND g_oga.oga65 ='N' AND g_aza.aza26 = '2' THEN
            IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN
   #MOD-CB0050 add begin-------------------------------
               CALL p650_chk_ogb1001(b_ogb.ogb1001) RETURNING l_cnt2
               IF l_cnt2 > 0 THEN 
                  #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                  #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
               ELSE 
   #MOD-CB0050 add end---------------------------------               
                  IF g_oga.oga00 != '2' THEN  #MOD-CB0083 add
                     #扣减发票仓库存(此处添加双单位逻辑)
                     CALL p650_u2_tlf() #删除发票仓tlf异动记录
                     LET g_type_t = g_type #保存舊值
                     LET g_type   = '-1'
                     #发票仓的储位统一用客户编号g_oga.oga03
                     DECLARE p650_s1_ogc_c7 CURSOR FOR  SELECT * FROM ogc_file 
                        WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
                     FOREACH p650_s1_ogc_c7 INTO l_ogc.*
                        IF SQLCA.SQLCODE THEN
                           CALL s_errmsg('','',"p650_s1_ogc_c7",SQLCA.sqlcode,1)  
                           LET g_success='N' 
                           EXIT FOREACH               
                        END IF
                        MESSAGE '_s1() read ogc:',b_ogb.ogb03,'-',l_ogc.ogc091
                        CALL ui.Interface.refresh()
                        IF g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
                           LET l_item = l_ogc.ogc17
                        ELSE
                           LET l_item = b_ogb.ogb04
                        END IF
                           CALL p650_u_img(g_oaz.oaz95,g_oga.oga03,l_ogc.ogc092,l_ogc.ogc16,l_item)            	                                          
                        IF g_success='N' THEN 
                           RETURN 
                        END IF
                     END FOREACH               
                     #CALL p650_u_img(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092,b_ogb.ogb16,b_ogb.ogb04)  
                     LET g_type = 1 #还原旧值
                     IF g_sma.sma115 = 'Y' THEN
                        CALL p650_u2_tlff()
      #FUN-C50097 add --BEG
                        #FOREACH 母单位存储批号 数量
                        DECLARE p650_ogg_c5 CURSOR FOR  
                         SELECT SUM(ogg16),ogg092 FROM ogg_file   
                          WHERE ogg01=b_ogb.ogb01 
                            AND ogg03=b_ogb.ogb03
                            AND ogg20='2'
                          GROUP BY ogg092   
                        FOREACH p650_ogg_c5 INTO l_qty2,p_lot
                           CALL p650_du(g_oaz.oaz95,g_oga.oga03,p_lot,b_ogb.ogb913,b_ogb.ogb914,l_qty2*-1,'','','','1') 
                           IF g_success='N' THEN 
                              CONTINUE FOREACH
                           END IF                                        
                        END FOREACH 
                        #FOREACH 子单位存储批号 数量
                        DECLARE p650_ogg_c8 CURSOR FOR  
                         SELECT SUM(ogg16),ogg092 FROM ogg_file   
                          WHERE ogg01=b_ogb.ogb01 
                            AND ogg03=b_ogb.ogb03
                            AND ogg20='1'
                          GROUP BY ogg092   
                        FOREACH p650_ogg_c8 INTO l_qty1,p_lot
                           CALL p650_du(g_oaz.oaz95,g_oga.oga03,p_lot,'','','',b_ogb.ogb910,b_ogb.ogb911,l_qty1*-1,'1') 
                           IF g_success='N' THEN 
                              CONTINUE FOREACH
                           END IF                                
                        END FOREACH 
      #FUN-C50097 add ---END                  
                     END IF                                           
                  END IF #MOD-CB0083 add   
               END IF # #MOD-CB0050 add                                           
               IF g_success='N' THEN 
                  CONTINUE FOREACH
               END IF               
            END IF 
         END IF    
#FUN-C50097 ADD END-------
#以下为非多仓储逻辑 ogb17='N'         
      ELSE
         #axmt628對于待驗倉庫的數量不應以單身的數量來做扣帳,因為如有驗退的數量
         #要把相應的量轉至驗退單上,所以此處就把它扣完,然后再后面處理驗退倉庫的量增加
         IF g_oga.oga09 = '8' AND g_aza.aza26 != '2' THEN  #FUN-C50097 ADD !=2 
            SELECT ogb12,ogb912,ogb915,ogb917 INTO m_ogb12,m_ogb912,m_ogb915,m_ogb917
              FROM oga_file,ogb_file
             WHERE ogb01 = oga01
               AND oga01 = g_oga.oga011
               AND oga65 = 'Y'   #FUN-640014
              #AND oga09 = '2'   #FUN-640014
              #AND (oga09 = '2' OR oga09 = '3')  #FUN-BB0167   #FUN-C40072 mark
               AND (oga09 = '2' OR oga09 = '3' OR oga09 = '4') #FUN-C40072 add 4
               AND ogb03 = b_ogb.ogb03
             IF cl_null(m_ogb12)  THEN LET m_ogb12  = 0 END IF
             IF cl_null(m_ogb912) THEN LET m_ogb912 = 0 END IF
             IF cl_null(m_ogb915) THEN LET m_ogb915 = 0 END IF
             IF cl_null(m_ogb917) THEN LET m_ogb917 = 0 END IF
             LET b_ogb.ogb12 = m_ogb12
             LET b_ogb.ogb912= m_ogb912
             LET b_ogb.ogb915= m_ogb915
             LET b_ogb.ogb917= m_ogb917
            #LET b_ogb.ogb16 = b_ogb.ogb12/b_ogb.ogb15_fac #MOD-B10172 mark
             LET b_ogb.ogb16 = b_ogb.ogb12*b_ogb.ogb15_fac #MOD-B10172
         END IF
         #FUN-C50097 ADD BEG-----大陸版走開票流程,多次簽收作業流程
         IF g_oga.oga09 = '8' AND g_aza.aza26 = '2' THEN   #FUN-C50097 ADD             
           IF ((g_oaz.oaz92 = 'N' AND g_oaz.oaz93 = 'N') OR (g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'N') )  
               AND  g_oaz.oaz94 = 'Y' THEN    #120727 add      
               #更新ogb50,ogb51累计签收量和累计签退量
               SELECT ogb50,ogb51 INTO l_ogb50,l_ogb51 FROM ogb_file
                WHERE ogb01 =  g_oga.oga011
                  AND ogb03 = b_ogb.ogb03 
               LET l_ogb50 = l_ogb50 - b_ogb.ogb12
               LET l_ogb51 = l_ogb51 - b_ogb.ogb52
               IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
                  LET l_ogb50 = 0
               END IF 
               IF cl_null(l_ogb51) OR l_ogb51 < 0 THEN 
                  LET l_ogb51 = 0
               END IF
                    
               UPDATE ogb_file SET ogb50 = l_ogb50 ,
                                   ogb51 = l_ogb51 
                             WHERE ogb01 = g_oga.oga011
                               AND ogb03 = b_ogb.ogb03                   
               #下面代码将本次签收数量和本次签退数量还原到签收仓
               LET b_ogb.ogb12 = b_ogb.ogb12 + b_ogb.ogb52
               IF g_sma.sma115 = 'Y' THEN 
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=b_ogb.ogb04
                  IF l_ima906 = '2' THEN 
                     CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb910)
                        RETURNING l_cnt,l_factor
                     IF l_cnt = 1 THEN 
                        LET l_factor = 1 
                     END IF
                     LET b_ogb.ogb912 =  (b_ogb.ogb12 * l_factor) mod b_ogb.ogb914    #签退子单位数量
                     LET b_ogb.ogb915 =  (b_ogb.ogb12 * l_factor  - b_ogb.ogb912) / b_ogb.ogb914   #签退母单位数量                      
                  END IF 
                  IF l_ima906 = '3' THEN 
                     IF NOT cl_null(b_ogb.ogb911) THEN 
                        LET b_ogb.ogb912 = b_ogb.ogb12 / b_ogb.ogb911
                     END IF 
                     IF NOT cl_null(b_ogb.ogb914) THEN 
                        LET b_ogb.ogb915 = b_ogb.ogb12 / b_ogb.ogb914
                     END IF                  
                  END IF     
               END IF 
               IF NOT cl_null(b_ogb.ogb916) THEN
                  CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb916)
                       RETURNING l_cnt,l_factor
                  IF l_cnt = 1 THEN
                     LET l_factor = 1               	  
                  END IF 
                  LET b_ogb.ogb917 = b_ogb.ogb12 * l_factor
               END IF 
               LET b_ogb.ogb16 = b_ogb.ogb12*b_ogb.ogb15_fac            
            END IF 
            IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' AND  g_oaz.oaz94 = 'Y'  THEN  
   #MOD-CB0050 add begin-------------------------------
               CALL p650_chk_ogb1001(b_ogb.ogb1001) RETURNING l_cnt2 
               IF l_cnt2 > 0 THEN 
                  #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                  #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
               ELSE 
   #MOD-CB0050 add end---------------------------------
                  IF g_oga.oga00 != '2' THEN  #MOD-CB0083 add
                     #扣减发票仓库存
                     CALL p650_u2_tlf() #删除发票仓tlf异动记录
                     LET g_type_t = g_type #保存舊值
                     LET g_type   = '-1'
                     CALL p650_u_img(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092,b_ogb.ogb16,b_ogb.ogb04)   
                     LET g_type = 1 #还原旧值
                     IF g_sma.sma115 = 'Y' THEN
                        CALL p650_u2_tlff()
                        CALL p650_du(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092, 
                                     b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915*-1,
                                     b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912*-1,'1') 
                        IF g_success='N' THEN 
                           CONTINUE FOREACH     
                        END IF
                     END IF       
                  END IF #MOD-CB0083 add                                         
               END IF #MOD-CB0050 add                             
               #更新ogb50,ogb51累计签收量和累计签退量
               SELECT ogb50,ogb51 INTO l_ogb50,l_ogb51 FROM ogb_file
                WHERE ogb01 =  g_oga.oga011
                  AND ogb03 = b_ogb.ogb03 
               LET l_ogb50 = l_ogb50 - b_ogb.ogb12
               LET l_ogb51 = l_ogb51 - b_ogb.ogb52
               IF cl_null(l_ogb50) OR l_ogb50 < 0 THEN 
                  LET l_ogb50 = 0
               END IF 
               IF cl_null(l_ogb51) OR l_ogb51 < 0 THEN 
                  LET l_ogb51 = 0
               END IF
                    
               UPDATE ogb_file SET ogb50 = l_ogb50 ,
                                   ogb51 = l_ogb51 
                             WHERE ogb01 = g_oga.oga011
                               AND ogb03 = b_ogb.ogb03                   
               #下面代码将本次签收数量和本次签退数量还原到签收仓
               LET b_ogb.ogb12 = b_ogb.ogb12 + b_ogb.ogb52
               IF g_sma.sma115 = 'Y' THEN 
                  SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=b_ogb.ogb04
                  IF l_ima906 = '2' THEN 
                     CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb910)
                        RETURNING l_cnt,l_factor
                     IF l_cnt = 1 THEN 
                        LET l_factor = 1 
                     END IF
                     LET b_ogb.ogb912 =  (b_ogb.ogb12 * l_factor) mod b_ogb.ogb914    #签退子单位数量
                     LET b_ogb.ogb915 =  (b_ogb.ogb12 * l_factor  - b_ogb.ogb912) / b_ogb.ogb914   #签退母单位数量                      
                  END IF 
                  IF l_ima906 = '3' THEN 
                     IF NOT cl_null(b_ogb.ogb911) THEN 
                        LET b_ogb.ogb912 = b_ogb.ogb12 / b_ogb.ogb911
                     END IF 
                     IF NOT cl_null(b_ogb.ogb914) THEN 
                        LET b_ogb.ogb915 = b_ogb.ogb12 / b_ogb.ogb914
                     END IF                  
                  END IF     
               END IF 
               IF NOT cl_null(b_ogb.ogb916) THEN
                  CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,b_ogb.ogb916)
                       RETURNING l_cnt,l_factor
                  IF l_cnt = 1 THEN
                     LET l_factor = 1               	  
                  END IF 
                  LET b_ogb.ogb917 = b_ogb.ogb12 * l_factor
               END IF 
               LET b_ogb.ogb16 = b_ogb.ogb12*b_ogb.ogb15_fac
            END IF 
            IF g_oaz.oaz94 != 'Y' THEN
               IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN  
   #MOD-CB0050 add begin-------------------------------
                  CALL p650_chk_ogb1001(b_ogb.ogb1001) RETURNING l_cnt2
                  IF l_cnt2 > 0 THEN 
                     #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                     #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
                  ELSE 
   #MOD-CB0050 add END---------------------------------
                     IF g_oga.oga00 != '2' THEN  #MOD-CB0083 add
                        #扣减发票仓库存
                        CALL p650_u2_tlf() #删除发票仓tlf异动记录
                        LET g_type_t = g_type #保存舊值
                        LET g_type   = '-1'
                        CALL p650_u_img(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092,b_ogb.ogb16,b_ogb.ogb04)   
                        LET g_type = 1 #还原旧值
                        IF g_sma.sma115 = 'Y' THEN
                           CALL p650_u2_tlff()
                           CALL p650_du(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092, 
                                        b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915*-1,
                                        b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912*-1,'1') 
                           IF g_success='N' THEN 
                              CONTINUE FOREACH     
                           END IF
                        END IF
                     END IF #MOD-CB0083 add   
                  END IF #MOD-CB0050 add   
               END IF                         
               SELECT ogb12,ogb912,ogb915,ogb917 INTO m_ogb12,m_ogb912,m_ogb915,m_ogb917
                 FROM oga_file,ogb_file
                WHERE ogb01 = oga01
                  AND oga01 = g_oga.oga011
                  AND oga65 = 'Y'   #FUN-640014
                 #AND oga09 = '2'   #FUN-640014
                  AND (oga09 = '2' OR oga09 = '3')  #FUN-BB0167
                  AND ogb03 = b_ogb.ogb03
                IF cl_null(m_ogb12)  THEN LET m_ogb12  = 0 END IF
                IF cl_null(m_ogb912) THEN LET m_ogb912 = 0 END IF
                IF cl_null(m_ogb915) THEN LET m_ogb915 = 0 END IF
                IF cl_null(m_ogb917) THEN LET m_ogb917 = 0 END IF
                LET b_ogb.ogb12 = m_ogb12
                LET b_ogb.ogb912= m_ogb912
                LET b_ogb.ogb915= m_ogb915
                LET b_ogb.ogb917= m_ogb917
               #LET b_ogb.ogb16 = b_ogb.ogb12/b_ogb.ogb15_fac #MOD-B10172 mark
                LET b_ogb.ogb16 = b_ogb.ogb12*b_ogb.ogb15_fac #MOD-B10172
             END IF                 
         END IF
         #FUN-C50097 ADD END-----         
#FUN-C50097 ADD BEGIN-------#大陆版,还原产生的发票仓库存和tlf异动档
         IF g_oga.oga09 MATCHES '[23]' AND g_oga.oga65 ='N' AND g_aza.aza26 = '2' THEN
            IF g_oaz.oaz92 = 'Y' AND g_oaz.oaz93 = 'Y' THEN
   #MOD-CB0050 add begin-------------------------------
               CALL p650_chk_ogb1001(b_ogb.ogb1001) RETURNING l_cnt2
               IF l_cnt2 > 0 THEN 
                  #走開票流程時，對于原因碼為贈品（aooi313列入銷售費用為Y）的項次，
                  #出貨過賬不應產生至發票倉，axmt670也不能針對此項次開票。
               ELSE 
   #MOD-CB0050 add end---------------------------------
                  IF g_oga.oga00 != '2' THEN  #MOD-CB0083 add
                     #扣减发票仓库存(此处添加双单位逻辑)
                     CALL p650_u2_tlf() #删除发票仓tlf异动记录
                     LET g_type_t = g_type #保存舊值
                     LET g_type   = '-1'
                     #发票仓的储位统一用客户编号g_oga.oga03
                     CALL p650_u_img(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092,b_ogb.ogb16,b_ogb.ogb04)  
                     LET g_type = 1 #还原旧值
                     IF g_sma.sma115 = 'Y' THEN
                        CALL p650_u2_tlff()
                        CALL p650_du(g_oaz.oaz95,g_oga.oga03,b_ogb.ogb092, 
                                     b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915*-1,
                                     b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912*-1,'1') 
                        IF g_success='N' THEN 
                           CONTINUE FOREACH      #No.FUN-710046
                        END IF
                     END IF                                           
                  END IF #MOD-CB0083 add   
               END IF # MOD-CB0050 add                                           
               IF g_success='N' THEN 
                  CONTINUE FOREACH
               END IF               
            END IF 
         END IF    
#FUN-C50097 ADD BEGIN-------
         CALL p650_u_img(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,b_ogb.ogb16,b_ogb.ogb04)  #FUN-5C0075
         CALL p650_du(b_ogb.ogb09,b_ogb.ogb091,b_ogb.ogb092,
                      b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915,
                      b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912,'2') 
         IF g_success='N' THEN 
            CONTINUE FOREACH #No.FUN-710046
         END IF
      END IF
 
      #--境外倉之處理 modi in 99/12/22
      IF g_oga.oga00 MATCHES '[37]' THEN   #No.FUN-610064
        #CHI-AC0034 mod --start--
        #CALL p650_u2_tlf()
        #LET g_type = '-1'   #MOD-A30157
  #     #CALL p650_u_img(g_oga.oga910,g_oga.oga911,b_ogb.ogb092,b_ogb.ogb16*-1,b_ogb.ogb04)  #FUN-5C0075     #No.TQC-6B0174  #TQC-AC0233 mark
        #CALL p650_u_img(g_oga.oga910,g_oga.oga911,b_ogb.ogb092,b_ogb.ogb16,b_ogb.ogb04)                                    #TQC-AC0233
        IF b_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨       
           #DECLARE p650_s1_ogc_c2 CURSOR FOR  SELECT * FROM ogc_file #CHI-C60022 mark 
            DECLARE p650_s1_ogc_c2 CURSOR FOR                         #CHI-C60022 add 
             SELECT SUM(ogc12),ogc17,ogc092                           #CHI-C60022 add
               FROM ogc_file                                          #CHI-C60022 add
               WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
               GROUP BY ogc17,ogc092                                  #CHI-C60022 add
           #FOREACH p650_s1_ogc_c2 INTO l_ogc.*                               #CHI-C60022 mark
            FOREACH p650_s1_ogc_c2 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  #CHI-C60022
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"FOREACH #1",SQLCA.sqlcode,1)  
                  LET g_success='N' 
                  EXIT FOREACH     
               END IF
               CALL p650_u2_tlf()
               IF g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
                  LET l_item = l_ogc.ogc17
               ELSE
                  LET l_item = b_ogb.ogb04
               END IF
               #CHI-C60022 add --start--
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_item AND img02= g_oga.oga910
                 #AND img03= g_oga.oga911 AND img04= b_ogb.ogb092  #MOD-C70055 mark
                  AND img03= g_oga.oga911 AND img04= l_ogc.ogc092  #MOD-C70055 
               CALL s_umfchk(l_item,b_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
               LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
               #CHI-C60022 add --end--
               LET g_type = '-1'  
              #CALL p650_u_img(g_oga.oga910,g_oga.oga911,b_ogb.ogb092,l_ogc.ogc16,l_item) #CHI-C60022 mark 
               CALL p650_u_img(g_oga.oga910,g_oga.oga911,l_ogc.ogc092,l_ogc.ogc16,l_item) #CHI-C60022
            END FOREACH 
         ELSE
            CALL p650_u2_tlf()
            LET g_type = '-1'  
            CALL p650_u_img(g_oga.oga910,g_oga.oga911,b_ogb.ogb092,b_ogb.ogb16,b_ogb.ogb04)  
         END IF
        #CHI-AC0034 mod --end--
         LET g_type = '1'    #MOD-A30157
         CALL p650_u2_tlff()
         CALL p650_du(g_oga.oga910,g_oga.oga911,b_ogb.ogb092,     #No.TQC-6B0174
                      b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915*-1,
                      b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912*-1,'1') 
         IF g_success='N' THEN 
            CONTINUE FOREACH        #No.FUN-710046
         END IF
      END IF
 
     #IF g_oga.oga65 = 'Y' AND g_oga.oga09='2' THEN   #FUN-640014 
     #IF g_oga.oga65 = 'Y' AND g_oga.oga09 MATCHES '[23]' THEN   #FUN-BB0167 #FUN-C40072 mark
      IF g_oga.oga65 = 'Y' AND g_oga.oga09 MATCHES '[234]' THEN  #FUN-C40072 add 4
        #CHI-AC0034 mod --start--
        #CALL p650_u2_tlf()
        #LET g_type = '-1'   #MOD-9A0172
        #CALL p650_u_img(g_oga.oga66,g_oga.oga67,b_ogb.ogb092,b_ogb.ogb16*-1,b_ogb.ogb04)  #FUN-5C0075     #No.TQC-6B0174
        #No.MOD-C70145  --Begin
        #IF b_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨     #CHI-B30093 #去掉CHI-B30093 mark #No.MOD-C70145
         #IF b_ogb.ogb17='Y' THEN                           ##多倉儲出貨     #CHI-B30093 #mark CHI-B30093 
        IF b_ogb.ogb17='Y'  THEN     ##多倉儲出貨
        #No.MOD-C70145  --End 
           #DECLARE p650_s1_ogc_c3 CURSOR FOR  SELECT * FROM ogc_file #MOD-C70055 mark
            DECLARE p650_s1_ogc_c3 CURSOR FOR                         #MOD-C70055 add
             SELECT SUM(ogc12),ogc17,ogc092                           #MOD-C70055 add
               FROM ogc_file                                          #MOD-C70055 add
               WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
              GROUP BY ogc17,ogc092                                   #MOD-C70055 add
           #FOREACH p650_s1_ogc_c3 INTO l_ogc.*                               #MOD-C70055 mark
            FOREACH p650_s1_ogc_c3 INTO l_ogc.ogc12,l_ogc.ogc17,l_ogc.ogc092  #MOD-C70055
               IF SQLCA.SQLCODE THEN
                  CALL s_errmsg('','',"FOREACH #1",SQLCA.sqlcode,1)  
                  LET g_success='N' 
                  EXIT FOREACH     
               END IF
               CALL p650_u2_tlf()
               IF g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
                  LET l_item = l_ogc.ogc17
               ELSE
                  LET l_item = b_ogb.ogb04
               END IF 
              #MOD-C70055---S---
               SELECT img09 INTO l_img09 FROM img_file
                WHERE img01= l_item
                  AND img02= g_oga.oga66
                  AND img03= g_oga.oga67
                  AND img04= l_ogc.ogc092
               CALL s_umfchk(l_item,b_ogb.ogb05,l_img09) RETURNING g_cnt,l_ogc.ogc15_fac
               LET l_ogc.ogc16=l_ogc.ogc12*l_ogc.ogc15_fac
              #MOD-C70055---E---                  
               LET g_type = '-1'              
              #CALL p650_u_img(g_oga.oga66,g_oga.oga67,b_ogb.ogb092,l_ogc.ogc16,l_item)        #CHI-B30093  #去掉CHI-B30093 mark
              CALL p650_u_img(g_oga.oga66,g_oga.oga67,l_ogc.ogc092,l_ogc.ogc16,l_item)  #FUN-C50097 应带过来多仓储的批号l_ogc.ogc092,而不是单身批号
            END FOREACH 
         ELSE    	 	
              CALL p650_u2_tlf()
              LET g_type = '-1'  
              CALL p650_u_img(g_oga.oga66,g_oga.oga67,b_ogb.ogb092,b_ogb.ogb16,b_ogb.ogb04)  #TQC-BA0136 mark  #FUN-C30289
              #CALL p650_u_img(g_oga.oga66,g_oga.oga67,l_ogc.ogc092,l_ogc.ogc16,l_item)        #TQC-BA0136     #FUN-C30289 mark
         END IF
        #CHI-AC0034 mod --end--
         #TQC-BA0136(S)
         #出貨單過帳還原後,要將出貨簽收在途倉的ida_file刪掉
         IF s_industry('icd') THEN
            IF g_type = -1 THEN
               CALL icd_ida_del(g_oga.oga01,b_ogb.ogb03,'')
            END IF
         END IF
         #TQC-BA0136(S)
         LET g_type = '1'   #MOD-9A0172
         IF g_sma.sma115 = 'Y' THEN
            CALL p650_u2_tlff()
#FUN-C50097 MARK --BEG
#            CALL p650_du(g_oga.oga66,g_oga.oga67,b_ogb.ogb092,     #No.TQC-6B0174
#                         b_ogb.ogb913,b_ogb.ogb914,b_ogb.ogb915*-1,
#                         b_ogb.ogb910,b_ogb.ogb911,b_ogb.ogb912*-1,'1')
#FUN-C50097 MARK ---END
#FUN-C50097 add --BEG
            #FOREACH 母单位存储批号 数量
            DECLARE p650_ogg_c1 CURSOR FOR  
             SELECT SUM(ogg16),ogg092 FROM ogg_file   
              WHERE ogg01=b_ogb.ogb01 
                AND ogg03=b_ogb.ogb03
                AND ogg20='2'
              GROUP BY ogg092   
            FOREACH p650_ogg_c1 INTO l_qty2,p_lot
            CALL p650_du(g_oga.oga66,g_oga.oga67,p_lot,     
                         b_ogb.ogb913,b_ogb.ogb914,l_qty2*-1,
                         '','','','1')            
            END FOREACH 
            #FOREACH 子单位存储批号 数量
            DECLARE p650_ogg_c2 CURSOR FOR  
             SELECT SUM(ogg16),ogg092 FROM ogg_file   
              WHERE ogg01=b_ogb.ogb01 
                AND ogg03=b_ogb.ogb03
                AND ogg20='1'
              GROUP BY ogg092   
            FOREACH p650_ogg_c2 INTO l_qty1,p_lot
            CALL p650_du(g_oga.oga66,g_oga.oga67,p_lot,     
                         '','','',
                         b_ogb.ogb910,b_ogb.ogb911,l_qty1*-1,'1')              
            END FOREACH 
#FUN-C50097 add ---END                        
            IF g_success='N' THEN
               CONTINUE FOREACH           #No.FUN-710046
            END IF
         END IF
      END IF
      IF (g_oga.oga09='8' AND g_aza.aza26 != '2') OR 
         (g_aza.aza26 = '2' AND g_oga.oga09='8' AND g_oaz.oaz94 != 'Y') THEN #FUN-C50097 ADD !=2 AND oaz94   AND g_aza.aza26 != '2') OR (g_oga.oga09='8' AND g_oaz.oaz94 = 'N'
         SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
          WHERE oga01  = ogb01 AND oga09 = '9'
            AND oga011 = g_oga.oga011
            AND ogb03  = b_ogb.ogb03
         IF NOT cl_null(l_ogb.ogb01) AND SQLCA.sqlcode = 0 THEN
            SELECT oga66,oga67,oga02 INTO l_oga66,l_oga67,l_oga02   #MOD-7A0001 modify oga02
              FROM oga_file
             WHERE oga01 = l_ogb.ogb01
 
            LET b_ogb_t.* = b_ogb.*   #MOD-7A0001 #backup           
            LET b_ogb.* = l_ogb.*     #MOD-7A0001  
            LET g_oga02_t=g_oga.oga02 #MOD-7A0001 #backup            
            LET g_oga.oga02 = l_oga02 #MOD-7A0001 
 
            #CHI-AC0034 mod --start--
           #CALL p650_u2_tlf()
           #CALL p650_u_img(l_oga66,l_oga67,l_ogb.ogb092,l_ogb.ogb16*-1,b_ogb.ogb04)  #FUN-5C0075      #No.TQC-6B0174
           #No.MOD-C70145  --Begin
           #IF b_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨   #CHI-B30093 #去掉CHI-B30093 mark #No.MOD-C70145
           #IF b_ogb.ogb17 = 'Y' THEN                                        #CHI-B30093 #mark CHI-B30093
           IF b_ogb.ogb17='Y' THEN     ##多倉儲出貨  
           #No.MOD-C70145  --End             
               DECLARE p650_s1_ogc_c4 CURSOR FOR  SELECT * FROM ogc_file 
                  WHERE ogc01=l_ogb.ogb01 AND ogc03=b_ogb.ogb03
               FOREACH p650_s1_ogc_c4 INTO l_ogc.*
                  IF SQLCA.SQLCODE THEN
                     CALL s_errmsg('','',"FOREACH #1",SQLCA.sqlcode,1)  
                     LET g_success='N' 
                     EXIT FOREACH     
                  END IF
                  CALL p650_u2_tlf()
                  IF g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
                     LET l_item = l_ogc.ogc17
                  ELSE
                     LET l_item = b_ogb.ogb04
                  END IF
                  LET g_type = '-1'  
                  #CALL p650_u_img(l_oga66,l_oga67,l_ogb.ogb092,l_ogc.ogc16,l_item)   #CHI-B30093 #去掉CHI-B30093 mark #TQC-BA0136 mark
                  CALL p650_u_img(l_oga66,l_oga67,l_ogc.ogc092,l_ogc.ogc16,l_item)   #TQC-BA0136 
                  #CALL p650_u_img(l_oga66,l_oga67,l_ogc.ogc092,l_ogc.ogc16,l_item)   #CHI-B30093 #mark CHI-B30093
               END FOREACH 
            ELSE
               CALL p650_u2_tlf()
               LET g_type = '-1'  
               CALL p650_u_img(l_oga66,l_oga67,l_ogb.ogb092,l_ogb.ogb16,b_ogb.ogb04) 
            END IF
            LET g_type = '1'  
           #CHI-AC0034 mod --end--
            IF g_sma.sma115 = 'Y' THEN
               CALL p650_u2_tlff()
               CALL p650_du(l_oga66,l_oga67,b_ogb.ogb092,     #No.TQC-6B0174
                            b_ogb.ogb913,b_ogb.ogb914,l_ogb.ogb915*-1,
                            b_ogb.ogb910,b_ogb.ogb911,l_ogb.ogb912*-1,'1') 
               IF g_success='N' THEN 
                  CONTINUE FOREACH      #No.FUN-710046
               END IF
            END IF
 
            LET b_ogb.* = b_ogb_t.*   #MOD-7A0001            
            LET g_oga.oga02=g_oga02_t #MOD-7A0001
 
            DELETE FROM ogb_file
             WHERE ogb01  = l_ogb.ogb01
               AND ogb03  = l_ogb.ogb03
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03                                      #No.FUN-710046
               CALL s_errmsg("ogb01,ogb03",g_showmsg,"DEL ogb_file",SQLCA.sqlcode,1)           #No.FUN-710046
               LET g_success='N' 
               CONTINUE FOREACH                #No.FUN-710046
            ELSE
               IF NOT s_industry('std') THEN
                  IF NOT s_del_ogbi(l_ogb.ogb01,l_ogb.ogb03,'') THEN
                     LET g_success = 'N'
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03                     #No.FUN-710046
               CALL s_errmsg("ogb01,ogb03",g_showmsg,"DEL ogb_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success='N'  CONTINUE FOREACH                           #No.FUN-710046
            END IF

            #MOD-B30475 add --start--
            SELECT COUNT(*) INTO l_cnt 
              FROM ogc_file 
             WHERE ogc01  = l_ogb.ogb01
               AND ogc03  = l_ogb.ogb03
            IF l_cnt > 0 THEN
            #MOD-B30475 add --end--
               #CHI-AC0034 add --start--
               DELETE FROM ogc_file
                WHERE ogc01  = l_ogb.ogb01
                  AND ogc03  = l_ogb.ogb03
               IF STATUS OR SQLCA.SQLCODE THEN
                  LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03                             
                  CALL s_errmsg("ogc01,ogc03",g_showmsg,"DEL ogc_file",SQLCA.sqlcode,1)   
                  LET g_success='N' 
                  CONTINUE FOREACH       
               END IF
               IF SQLCA.SQLERRD[3]=0 THEN
                  LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03              
                  CALL s_errmsg("ogc01,ogc03",g_showmsg,"DEL ogc_file",SQLCA.sqlcode,1)  
                  LET g_success='N'  CONTINUE FOREACH            
               END IF
               #CHI-AC0034 add --end--
            END IF #MOD-B30475 add

            DELETE FROM rvbs_file 
             WHERE rvbs00 = 'axmt629'
               AND rvbs01 = l_ogb.ogb01
               AND rvbs02 = l_ogb.ogb03 
              #AND rvbs13 = 0 #CHI-AC0034 mark 
               AND rvbs09 = -1               #TQC-B90236 mark #FUN-C50097 ADD 应该为"-1"
               #AND rvbs09 = 1                #TQC-B90236 add
            SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE ogb01=l_ogb.ogb01
            IF l_cnt = 0 THEN
               DELETE FROM oga_file WHERE oga01 = l_ogb.ogb01
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg("oga01",l_ogb.ogb01,"DEL oga_file",SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success='N'  CONTINUE FOREACH                           #No.FUN-710046
               END IF
               IF SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg("oga01",l_ogb.ogb01,"DEL oga_file","axm-176",1)  #No.FUN-710046
                  LET g_success='N'  CONTINUE FOREACH                            #No.FUN-710046
               END IF
            END IF
         END IF
      END IF
#FUN-C50097 ADD BEGIN-----
#處理大陸版多次簽退的數據
      IF g_oga.oga09='8' AND g_aza.aza26 = '2' AND g_oaz.oaz94 = 'Y' THEN
         SELECT ogb_file.* INTO l_ogb.* FROM oga_file,ogb_file
          WHERE oga01  = ogb01 AND oga09 = '9'
            AND oga011 = g_oga.oga011
            AND ogb03  = b_ogb.ogb03
            AND oga56  = g_oga.oga01 #出貨簽收單號
         IF NOT cl_null(l_ogb.ogb01) AND SQLCA.sqlcode = 0 THEN
            SELECT oga66,oga67,oga02 INTO l_oga66,l_oga67,l_oga02   #MOD-7A0001 modify oga02
              FROM oga_file
             WHERE oga01 = l_ogb.ogb01
 
            LET b_ogb_t.* = b_ogb.*   #MOD-7A0001 #backup           
            LET b_ogb.* = l_ogb.*     #MOD-7A0001  
            LET g_oga02_t=g_oga.oga02 #MOD-7A0001 #backup            
            LET g_oga.oga02 = l_oga02 #MOD-7A0001 
 
            #CHI-AC0034 mod --start--
           #CALL p650_u2_tlf()
           #CALL p650_u_img(l_oga66,l_oga67,l_ogb.ogb092,l_ogb.ogb16*-1,b_ogb.ogb04)  #FUN-5C0075      #No.TQC-6B0174
           #IF b_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN     ##多倉儲出貨   #CHI-B30093 #去掉CHI-B30093 mark #FUN-C50097 MARK
           IF b_ogb.ogb17 = 'Y' THEN                                        #CHI-B30093 #mark CHI-B30093 #FUN-C50097
           
               DECLARE p650_s1_ogc_c5 CURSOR FOR  SELECT * FROM ogc_file 
                  WHERE ogc01=l_ogb.ogb01 AND ogc03=b_ogb.ogb03
               FOREACH p650_s1_ogc_c5 INTO l_ogc.*
                  IF SQLCA.SQLCODE THEN
                     CALL s_errmsg('','',"FOREACH #1",SQLCA.sqlcode,1)  
                     LET g_success='N' 
                     EXIT FOREACH     
                  END IF
                  CALL p650_u2_tlf()
                  IF g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
                     LET l_item = l_ogc.ogc17
                  ELSE
                     LET l_item = b_ogb.ogb04
                  END IF
                  LET g_type = '-1'  
                  #CALL p650_u_img(l_oga66,l_oga67,l_ogb.ogb092,l_ogc.ogc16,l_item)   #CHI-B30093 #去掉CHI-B30093 mark #TQC-BA0136 mark
                  CALL p650_u_img(l_oga66,l_oga67,l_ogc.ogc092,l_ogc.ogc16,l_item)   #TQC-BA0136 
                  #CALL p650_u_img(l_oga66,l_oga67,l_ogc.ogc092,l_ogc.ogc16,l_item)   #CHI-B30093 #mark CHI-B30093
               END FOREACH 
            ELSE
               CALL p650_u2_tlf()
               LET g_type = '-1'  
               CALL p650_u_img(l_oga66,l_oga67,l_ogb.ogb092,l_ogb.ogb16,b_ogb.ogb04) 
            END IF
            LET g_type = '1'  
           #CHI-AC0034 mod --end--
            IF g_sma.sma115 = 'Y' THEN
               CALL p650_u2_tlff()
#               CALL p650_du(l_oga66,l_oga67,b_ogb.ogb092,     #No.TQC-6B0174
#                            b_ogb.ogb913,b_ogb.ogb914,l_ogb.ogb915*-1,
#                            b_ogb.ogb910,b_ogb.ogb911,l_ogb.ogb912*-1,'1') 
#FUN-C50097 add --BEG
               #FOREACH 母单位存储批号 数量
               DECLARE p650_ogg_c3 CURSOR FOR  
                SELECT SUM(ogg16),ogg092 FROM ogg_file   
                 WHERE ogg01=l_ogb.ogb01 
                   AND ogg03=l_ogb.ogb03
                   AND ogg20='2'
                 GROUP BY ogg092   
               FOREACH p650_ogg_c3 INTO l_qty2,p_lot
               CALL p650_du(l_ogb.ogb09,l_ogb.ogb091,p_lot,     
                            l_ogb.ogb913,l_ogb.ogb914,l_qty2*-1,
                            '','','','1')            
               END FOREACH 
               #FOREACH 子单位存储批号 数量
               DECLARE p650_ogg_c4 CURSOR FOR  
                SELECT SUM(ogg16),ogg092 FROM ogg_file   
                 WHERE ogg01=b_ogb.ogb01 
                   AND ogg03=b_ogb.ogb03
                   AND ogg20='1'
                 GROUP BY ogg092   
               FOREACH p650_ogg_c4 INTO l_qty1,p_lot
               CALL p650_du(l_ogb.ogb09,l_ogb.ogb091,p_lot,     
                            '','','',
                            l_ogb.ogb910,l_ogb.ogb911,l_qty1*-1,'1')              
               END FOREACH 
#FUN-C50097 add ---END
               IF g_success='N' THEN 
                  CONTINUE FOREACH      #No.FUN-710046
               END IF
            END IF
 
            LET b_ogb.* = b_ogb_t.*   #MOD-7A0001            
            LET g_oga.oga02=g_oga02_t #MOD-7A0001
 
            DELETE FROM ogb_file
             WHERE ogb01  = l_ogb.ogb01
               AND ogb03  = l_ogb.ogb03
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03                                      #No.FUN-710046
               CALL s_errmsg("ogb01,ogb03",g_showmsg,"DEL ogb_file",SQLCA.sqlcode,1)           #No.FUN-710046
               LET g_success='N' 
               CONTINUE FOREACH                #No.FUN-710046
            ELSE
               IF NOT s_industry('std') THEN
                  IF NOT s_del_ogbi(l_ogb.ogb01,l_ogb.ogb03,'') THEN
                     LET g_success = 'N'
                     CONTINUE FOREACH
                  END IF
               END IF
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03                     #No.FUN-710046
               CALL s_errmsg("ogb01,ogb03",g_showmsg,"DEL ogb_file",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success='N'  CONTINUE FOREACH                           #No.FUN-710046
            END IF
            #FUN-C50097 add BEG-----
            SELECT COUNT(*) INTO l_cnt 
              FROM ogg_file 
             WHERE ogg01  = l_ogb.ogb01
               AND ogg03  = l_ogb.ogb03
            IF l_cnt > 0 THEN
               DELETE FROM ogg_file
                WHERE ogg01  = l_ogb.ogb01
                  AND ogg03  = l_ogb.ogb03
               IF STATUS OR SQLCA.SQLCODE THEN
                  LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03                             
                  CALL s_errmsg("ogg01,ogg03",g_showmsg,"DEL ogg_file",SQLCA.sqlcode,1)   
                  LET g_success='N' 
                  CONTINUE FOREACH       
               END IF
               IF SQLCA.SQLERRD[3]=0 THEN
                  LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03              
                  CALL s_errmsg("ogg01,ogg03",g_showmsg,"DEL ogg_file",SQLCA.sqlcode,1)  
                  LET g_success='N'  CONTINUE FOREACH            
               END IF
            END IF 
            #FUN-C50097 add END-----
            #MOD-B30475 add --start--
            SELECT COUNT(*) INTO l_cnt 
              FROM ogc_file 
             WHERE ogc01  = l_ogb.ogb01
               AND ogc03  = l_ogb.ogb03
            IF l_cnt > 0 THEN
            #MOD-B30475 add --end--
               #CHI-AC0034 add --start--
               DELETE FROM ogc_file
                WHERE ogc01  = l_ogb.ogb01
                  AND ogc03  = l_ogb.ogb03
               IF STATUS OR SQLCA.SQLCODE THEN
                  LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03                             
                  CALL s_errmsg("ogc01,ogc03",g_showmsg,"DEL ogc_file",SQLCA.sqlcode,1)   
                  LET g_success='N' 
                  CONTINUE FOREACH       
               END IF
               IF SQLCA.SQLERRD[3]=0 THEN
                  LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03              
                  CALL s_errmsg("ogc01,ogc03",g_showmsg,"DEL ogc_file",SQLCA.sqlcode,1)  
                  LET g_success='N'  CONTINUE FOREACH            
               END IF
               #CHI-AC0034 add --end--
            END IF #MOD-B30475 add

            DELETE FROM rvbs_file 
             WHERE rvbs00 = 'axmt629'
               AND rvbs01 = l_ogb.ogb01
               AND rvbs02 = l_ogb.ogb03 
              #AND rvbs13 = 0 #CHI-AC0034 mark 
               AND rvbs09 = -1               #TQC-B90236 mark
               #AND rvbs09 = 1                #TQC-B90236 add #FUN-C50097
            SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE ogb01=l_ogb.ogb01
            IF l_cnt = 0 THEN
               DELETE FROM oga_file WHERE oga01 = l_ogb.ogb01
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL s_errmsg("oga01",l_ogb.ogb01,"DEL oga_file",SQLCA.sqlcode,1)  #No.FUN-710046
                  LET g_success='N'  CONTINUE FOREACH                           #No.FUN-710046
               END IF
               IF SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg("oga01",l_ogb.ogb01,"DEL oga_file","axm-176",1)  #No.FUN-710046
                  LET g_success='N'  CONTINUE FOREACH                            #No.FUN-710046
               END IF
            END IF
         END IF
      END IF
#FUN-C50097 ADD END------ 
      IF b_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' AND (NOT cl_null(l_ogc.ogc17)) THEN
         DECLARE p650_ogc_c3 CURSOR FOR  SELECT ogc17 FROM ogc_file 
           WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
         FOREACH p650_ogc_c3 INTO l_ogc17
            IF SQLCA.SQLCODE THEN
               CALL s_errmsg('','',"Foreach #1",SQLCA.sqlcode,1)  #No.FUN-710046
               LET g_success='N' CONTINUE FOREACH    #No.FUN-710046
            END IF
            MESSAGE '_s1() read ogc:',b_ogb.ogb03,'-',l_ogc.ogc091
            CALL p650_u_ima(l_ogc17)
         END FOREACH
      ELSE
         CALL p650_u_ima(b_ogb.ogb04)
      END IF
     #-CHI-9C0037-mark-
     #SELECT poz011 INTO l_poz011 
     #  FROM oea_file,oeb_file,poz_file 
     # WHERE oeb01 = b_ogb.ogb31
     #   AND oeb03 = b_ogb.ogb32
     #   AND oea01 = oeb01
     #   AND oea904 = poz01
     #IF NOT (g_oga.oga09 = '4' AND l_poz011 = '1') THEN 
      CALL p650_u_tlf() 
     #END IF
     #-CHI-9C0037-end-
    SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=g_oga.oga03             
    IF cl_null(l_occ31) THEN LET l_occ31='N' END IF                             
    IF g_oga.oga00 ='7' THEN LET l_occ31='Y' END IF   #FUN-690083 add
     IF l_occ31 = 'N' THEN CONTINUE FOREACH END IF    #occ31=.w&s:^2z'_  #NO.MOD-4B0070                   
    SELECT ima25,ima71 INTO l_ima25,l_ima71                                     
      FROM ima_file WHERE ima01=b_ogb.ogb04                                     
    IF cl_null(l_ima71) THEN LET l_ima71=0 END IF                               
                                                                                
 
   IF g_oga.oga00 ='7' THEN
    SELECT COUNT(*) INTO i FROM tuq_file                                        
     WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                             
       AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                             
       AND tuq11 ='2'
       AND tuq12 =g_oga.oga04
       AND tuq05 =g_oga.oga01  #MOD-7A0084      
       AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
    IF i=0 THEN                                                                 
       LET l_fac1=1                                                             
       IF b_ogb.ogb05 <> l_ima25 THEN                                           
          CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ima25)                        
               RETURNING l_cnt,l_fac1                                           
          IF l_cnt = '1'  THEN                                                  
             CALL s_errmsg('','',b_ogb.ogb04,"abm-731",0)   #No.FUN-710046                    
             LET l_fac1=1                                                       
          END IF                                                                
       END IF                                                                   
    #FUN-910088--add--start--
       LET l_tuq09_1 = b_ogb.ogb12*l_fac1*-1
       LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
    #FUN-910088--add--end--
       INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,                      
                            tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,tuq051,  #No.TQC-7C0001 add tuq051
                            tuqplant,tuqlegal)    #FUN-980010 add
    #FUN-910088--mark--start--
    #  VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,g_oga.oga02,g_oga.oga01,     
    #         b_ogb.ogb05,b_ogb.ogb12*-1,l_fac1,b_ogb.ogb12*l_fac1*-1,'1','2',g_oga.oga04,b_ogb.ogb03,  #No.TQC-7C0001 add b_ogb.ogb03    
    #                       g_plant,g_legal)    #FUN-980010 add
    #FUN-910088--mark--end--
    #FUN-910088--add--start--
       VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,g_oga.oga02,g_oga.oga01,
              b_ogb.ogb05,b_ogb.ogb12*-1,l_fac1,l_tuq09_1,'1','2',g_oga.oga04,b_ogb.ogb03,  #No.TQC-7C0001 add b_ogb.ogb03
                            g_plant,g_legal)    #FUN-980010 add
    #FUN-910088--add--end--
       IF SQLCA.sqlcode THEN                                                    
          CALL s_errmsg('','',"INS tuq_file",SQLCA.sqlcode,1)                      #No.FUN-710046
          LET g_success ='N'                                                    
          CONTINUE FOREACH       #No.FUN-710046                                               
       END IF                                                                   
    ELSE                                                                        
       SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file                           
        WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                          
          AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                          
          AND tuq11 ='2'
          AND tuq12 =g_oga.oga04
          AND tuq05 =g_oga.oga01  #MOD-7A0084      
          AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
       #&],0key-H*:-l&],&P$@KEY-H*:%u/`+O/d$@-S-l)l3f&l                         
       IF SQLCA.sqlcode THEN                                                    
          LET g_showmsg=g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04  #No.FUN-710046
          CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"SEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
          LET g_success ='N'                                                    
          CONTINUE FOREACH  #No.FUN-710046                                                       
       END IF                                                                   
       LET l_fac1=1                                                             
       IF b_ogb.ogb05 <> l_tuq06 THEN                                           
          CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_tuq06)                        
               RETURNING l_cnt,l_fac1                                           
          IF l_cnt = '1'  THEN               
             CALL s_errmsg('','',b_ogb.ogb04,"abm-731",0)  #No.FUN-710046                    
             LET l_fac1=1                                                       
          END IF                                                                
       END IF                                                                   
                                                                                
       LET l_fac2=1                                                             
       IF l_tuq06 <> l_ima25 THEN                                               
          CALL s_umfchk(b_ogb.ogb04,l_tuq06,l_ima25)                            
               RETURNING l_cnt,l_fac2                                           
          IF l_cnt = '1'  THEN                                                  
             CALL s_errmsg('','',b_ogb.ogb04,"abm-731",0) #No.FUN-710046                      
             LET l_fac2=1                                                       
          END IF                                                                
       END IF                                                                   
                                                                                
       SELECT tuq07 INTO l_tuq07 FROM tuq_file                                  
        WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                          
          AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                          
          AND tuq11 ='2'
          AND tuq12 =g_oga.oga04
          AND tuq05 =g_oga.oga01  #MOD-7A0084      
          AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
       IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF                            
       IF l_tuq07<b_ogb.ogb12*l_fac1 THEN                                       
          LET l_desc='2'                                                        
       ELSE                                                                     
          LET l_desc='1'          
       END IF                                                                   
       IF l_tuq07=b_ogb.ogb12*l_fac1 THEN                                       
          DELETE FROM tuq_file                                                  
           WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                       
             AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                       
             AND tuq11 ='2'
             AND tuq12 =g_oga.oga04
             AND tuq05 =g_oga.oga01  #MOD-7A0084      
             AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
          IF SQLCA.sqlcode THEN                                                 
             LET g_showmsg=g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04  #No.FUN-710046
             CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"DEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
             LET g_success='N'                                                  
             CONTINUE FOREACH    #No.FUN-710046                                                       
          END IF                                                                
       ELSE                                                                     
       #FUN-910088--add--start--
          LET l_tuq07_1 = b_ogb.ogb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = b_ogb.ogb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                              tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start--
       #  UPDATE tuq_file SET tuq07=tuq07-b_ogb.ogb12*l_fac1,                   
       #                      tuq09=tuq09-b_ogb.ogb12*l_fac1*l_fac2,            
       #FUN-910088--mark--end--
                              tuq10=l_desc                                      
           WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                       
             AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                       
             AND tuq11 ='2'
             AND tuq12 =g_oga.oga04
             AND tuq05 =g_oga.oga01  #MOD-7A0084      
             AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
          IF SQLCA.sqlcode THEN                                                 
             LET g_showmsg=g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04  #No.FUN-710046
             CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"UPD tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046
             LET g_success='N'                                                  
             CONTINUE FOREACH  #No.FUN-710046                                                      
          END IF                                                                
       END IF                       
    END IF                                              
   ELSE                        
    LET i= 0  #MOD-7A0084 add 
    SELECT COUNT(*) INTO i FROM tuq_file                                        
     WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                             
       AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                             
       AND tuq11 ='1'
       AND tuq12 =g_oga.oga04
       AND tuq05 =g_oga.oga01  #MOD-7A0084      
       AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
    IF i=0 THEN                                                                 
       LET l_fac1=1                                                             
       IF b_ogb.ogb05 <> l_ima25 THEN                                           
          CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ima25)                        
               RETURNING l_cnt,l_fac1                                           
          IF l_cnt = '1'  THEN                                                  
             CALL s_errmsg('','',b_ogb.ogb04,"abm-731",0) #No.FUN-710046                     
             LET l_fac1=1                                                       
          END IF                                                                
       END IF                                                                   
     #FUN-910088--add--start--
       LET l_tuq09_1 = b_ogb.ogb12*l_fac1*-1
       LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
     #FUN-910088--add--end--
       INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,                      
                            tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,tuq051,  #No.TQC-7C0001 add tuq051
                            tuqplant,tuqlegal)    #FUN-980010 add
     #FUN-910088--mark--start--
     # VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,g_oga.oga02,g_oga.oga01,     
     #        b_ogb.ogb05,b_ogb.ogb12*-1,l_fac1,b_ogb.ogb12*l_fac1*-1,'1','1',g_oga.oga04,b_ogb.ogb03, #No.TQC-7C0001 add b_ogb.ogb03     
     #                      g_plant,g_legal)    #FUN-980010 add
     #FUN-910088--mark--end--
     #FUN-910088--add--start--
       VALUES(g_oga.oga03,b_ogb.ogb04,b_ogb.ogb092,g_oga.oga02,g_oga.oga01,
              b_ogb.ogb05,b_ogb.ogb12*-1,l_fac1,l_tuq09_1,'1','1',g_oga.oga04,b_ogb.ogb03, #No.TQC-7C0001 add b_ogb.ogb03
                            g_plant,g_legal)
     #FUN-910088--add--end--
       IF SQLCA.sqlcode THEN                                                    
          CALL s_errmsg('','',"INS tuq_file",SQLCA.sqlcode,1)                      #No.FUN-710046
          LET g_success ='N'                                                    
          CONTINUE FOREACH                                                         #No.FUN-710046 
       END IF                                                                   
    ELSE                                                                        
       SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file                           
        WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                          
          AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                          
          AND tuq11 ='1'
          AND tuq12 =g_oga.oga04
          AND tuq05 =g_oga.oga01  #MOD-7A0084      
          AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
       #&],0key-H*:-l&],&P$@KEY-H*:%u/`+O/d$@-S-l)l3f&l                         
       IF SQLCA.sqlcode THEN                                                    
          LET g_showmsg=g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04 #No.FUN-710046
          CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"SEL tuq_file",SQLCA.sqlcode,1)  #No.FUN-710046 
          LET g_success ='N'                                                    
          CONTINUE FOREACH        #No.FUN-710046                                             
       END IF                                                                   
       LET l_fac1=1                                                             
       IF b_ogb.ogb05 <> l_tuq06 THEN                                           
          CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_tuq06)                        
               RETURNING l_cnt,l_fac1                                           
          IF l_cnt = '1'  THEN               
             CALL s_errmsg('','',b_ogb.ogb04,"abm-731",0)         #No.FUN-710046                 
             LET l_fac1=1                                                       
          END IF                                                                
       END IF                                                                   
                                                                                
       LET l_fac2=1                                                             
       IF l_tuq06 <> l_ima25 THEN                                               
          CALL s_umfchk(b_ogb.ogb04,l_tuq06,l_ima25)                            
               RETURNING l_cnt,l_fac2                                           
          IF l_cnt = '1'  THEN                                                  
             CALL s_errmsg('','',b_ogb.ogb04,"abm-731",0)        #No.FUN-710046               
             LET l_fac2=1                                                       
          END IF                                                                
       END IF                                                                   
                                                                                
       SELECT tuq07 INTO l_tuq07 FROM tuq_file                                  
        WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                          
          AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                          
          AND tuq11 ='1'
          AND tuq12 =g_oga.oga04
          AND tuq05 =g_oga.oga01  #MOD-7A0084      
          AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
       IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF                            
       IF l_tuq07<b_ogb.ogb12*l_fac1 THEN                                       
          LET l_desc='2'                                                        
       ELSE                                                                     
          LET l_desc='1'          
       END IF                                                                   
       IF l_tuq07=b_ogb.ogb12*l_fac1 THEN                                       
          DELETE FROM tuq_file                                                  
           WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                       
             AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                       
             AND tuq11 ='1'
             AND tuq12 =g_oga.oga04
             AND tuq05 =g_oga.oga01  #MOD-7A0084      
             AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
          IF SQLCA.sqlcode THEN                                                 
             LET g_showmsg=g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04    #No.FUN-710046
             CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"DEL tuq_file",SQLCA.sqlcode,1)      #No.FUN-710046
             LET g_success='N'                                                  
             CONTINUE FOREACH          #No.FUN-710046                                              
          END IF                                                                
       ELSE                                                                     
       #FUN-910088--add--start--
          LET l_tuq07_1 = b_ogb.ogb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = b_ogb.ogb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07-l_tuq07_1,
                              tuq09=tuq09-l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start
       #  UPDATE tuq_file SET tuq07=tuq07-b_ogb.ogb12*l_fac1,                   
       #                      tuq09=tuq09-b_ogb.ogb12*l_fac1*l_fac2,   
       #FUN-910088--mark--end--         
                              tuq10=l_desc                                      
           WHERE tuq01=g_oga.oga03  AND tuq02=b_ogb.ogb04                       
             AND tuq03=b_ogb.ogb092 AND tuq04=g_oga.oga02                       
             AND tuq11 ='1'
             AND tuq12 =g_oga.oga04
             AND tuq05 =g_oga.oga01  #MOD-7A0084      
             AND tuq051 =b_ogb.ogb03  #MOD-7A0084 
          IF SQLCA.sqlcode THEN                                                 
             LET g_showmsg=g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092,"/",g_oga.oga02,"/",g_oga.oga04   #No.FUN-710046
             CALL s_errmsg("tuq01,tuq02,tuq03,tuq04,tuq12",g_showmsg,"UPD tuq_file",SQLCA.sqlcode,1)      #No.FUN-710046
             LET g_success='N'                                                  
             CONTINUE FOREACH      #No.FUN-710046                                            
          END IF                                                                
       END IF                       
    END IF                                                                      
   END IF                                                                      
                                                                                
    LET l_fac1=1                                                                
    IF b_ogb.ogb05 <> l_ima25 THEN                                              
       CALL s_umfchk(b_ogb.ogb04,b_ogb.ogb05,l_ima25)                           
            RETURNING l_cnt,l_fac1                                              
       IF l_cnt = '1'  THEN                                                     
          CALL s_errmsg('','',b_ogb.ogb04,"abm-731",0)   #No.FUN-710046                              
          LET l_fac1=1                                                          
       END IF                                                                   
    END IF                                                                      
    IF g_oga.oga00 ='7' THEN
    SELECT tup05 INTO l_tup05 FROM tup_file                                     
     WHERE tup01=g_oga.oga03  AND tup02=b_ogb.ogb04                             
       AND tup03=b_ogb.ogb092 
      #AND ((tup08 ='2' AND tup09 =g_oga.oga04) OR   #FUN-640014 modify #CHI-B40056 mark
      #     (tup11 ='2' AND tup12 =g_oga.oga04))     #FUN-640014 modify #CHI-B40056 mark
       AND tup11 ='2' AND tup12 =g_oga.oga04                            #CHI-B40056
     #FUN-910088--add--start--
       LET l_tup05_1 = b_ogb.ogb12*l_fac1            
       LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       UPDATE tup_file SET tup05 = tup05-l_tup05_1 
     #FUN-910088--add--end--
     # UPDATE tup_file SET tup05=tup05-b_ogb.ogb12*l_fac1   #FUN-910088--mark--                       
        WHERE tup01=g_oga.oga03  AND tup02=b_ogb.ogb04                          
          AND tup03=b_ogb.ogb092                                                
         #AND ((tup08 ='2' AND tup09 =g_oga.oga04) OR   #FUN-640014 modify #CHI-B40056 mark
         #     (tup11 ='2' AND tup12 =g_oga.oga04))     #FUN-640014 modify #CHI-B40056 mark
          AND tup11 ='2' AND tup12 =g_oga.oga04                            #CHI-B40056
       IF SQLCA.sqlcode THEN                                                    
          LET g_showmsg=g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092                  #No.FUN-710046
          CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1) #No.FUN-710046
          LET g_success='N' CONTINUE FOREACH                                          #No.FUN-710046
       END IF                                                                   
    ELSE                              
    SELECT tup05 INTO l_tup05 FROM tup_file                                     
     WHERE tup01=g_oga.oga03  AND tup02=b_ogb.ogb04                             
       AND tup03=b_ogb.ogb092 
      #AND ((tup08 ='1' AND tup09 =g_oga.oga04) OR   #FUN-640014 modify #CHI-B40056 mark
      #     (tup11 ='1' AND tup12 =g_oga.oga04))     #FUN-640014 modify #CHI-B40056 mark
       AND tup11 ='1' AND tup12 =g_oga.oga04                            #CHI-B40056
     #FUN-910088--add--start--
       LET l_tup05_1 = b_ogb.ogb12*l_fac1            
       LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)
       UPDATE tup_file SET tup05 = tup05-l_tup05_1 
     #FUN-910088--add--end--
     # UPDATE tup_file SET tup05=tup05-b_ogb.ogb12*l_fac1     #FUN-910088--mark--                      
        WHERE tup01=g_oga.oga03  AND tup02=b_ogb.ogb04                          
          AND tup03=b_ogb.ogb092                                                
         #AND ((tup08 ='1' AND tup09 =g_oga.oga04) OR   #FUN-640014 modify #CHI-B40056 mark
         #     (tup11 ='1' AND tup12 =g_oga.oga04))     #FUN-640014 modify #CHI-B40056 mark
          AND tup11 ='1' AND tup12 =g_oga.oga04                            #CHI-B40056 
       IF SQLCA.sqlcode THEN                                                    
          LET g_showmsg=g_oga.oga03,"/",b_ogb.ogb04,"/",b_ogb.ogb092                  #No.FUN-710046
          CALL s_errmsg("tup01,tup02,tup03",g_showmsg,"UPD tup_file",SQLCA.sqlcode,1) #No.FUN-710046
          LET g_success='N' CONTINUE FOREACH                                          #No.FUN-710046
       END IF                                                                   
     END IF                       
 
      IF g_success='N' THEN CONTINUE FOREACH END IF           #No.FUN-710046
  END FOREACH
   IF g_totsuccess = 'N' THEN                                                                                                       
      LET g_success = 'N'                                                                                                           
   END IF                                                                                                                           
  IF g_oga.oga00='6' THEN      #代表代送出貨
     CALL p650_s1_7()
     IF g_success = 'Y' THEN
        DELETE FROM ohb_file WHERE ohb01 = l_oha.oha01
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           RETURN
    #FUN-B70074-add-str--
        ELSE 
           IF NOT s_industry('std') THEN 
              IF NOT s_del_ohbi(l_oha.oha01,'','') THEN 
                 LET g_success='N'
                 RETURN
              END IF 
           END IF
    #FUN-B70074-add-end--
        END IF
        DELETE FROM oha_file WHERE oha01 = l_oha.oha01
        IF SQLCA.SQLCODE THEN
           LET g_success='N'
           RETURN
        END IF
        UPDATE oga_file SET oga1012=NULL,oga1014='N'
         WHERE oga01 = g_oga.oga01
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","",1)
           LET g_success = 'N'
           RETURN
        END IF
     END IF
  END IF
END FUNCTION
 
FUNCTION p650_s1_7()
DEFINE l_oha01  LIKE oha_file.oha01
DEFINE l_ima906 LIKE ima_file.ima906
 
 SELECT COUNT(*) INTO g_cnt 
   FROM omb_file,oma_file 
  WHERE omb31 = l_oha.oha01
    AND omb01=oma01 
    AND omavoid!='Y'
 
  IF g_cnt > 0 THEN
     CALL cl_err('','atm-396',0)
     LET g_success='N'
     RETURN
  END IF
  SELECT oha01 INTO l_oha01
    FROM oha_file
   WHERE oha1018 = g_oga.oga01
  IF SQLCA.SQLCODE THEN
     LET g_success = 'N'
     RETURN
  END IF
  SELECT * INTO l_oha.*
    FROM oha_file
   WHERE oha01 = l_oha01
  IF SQLCA.SQLCODE THEN
     LET g_success = 'N'
     RETURN
  END IF
 
  CALL p650_u_oha_7()
  DECLARE p650_s1_c_7 CURSOR FOR
   SELECT * FROM ohb_file WHERE ohb01=l_oha.oha01 
    ORDER BY ohb03
  FOREACH p650_s1_c_7 INTO l_ohb.*
      IF STATUS THEN LET g_success='N' RETURN END IF
      MESSAGE '_s1() read no:',l_ohb.ohb03 USING '#####&',' -> parts: ',
               l_ohb.ohb04 
      CALL ui.Interface.refresh()
      IF cl_null(l_ohb.ohb04) THEN CONTINUE FOREACH END IF
      IF l_ohb.ohb04[1,4] = 'MISC' THEN CONTINUE FOREACH END IF 
      CALL p650_u_img_7(l_ohb.ohb09,l_ohb.ohb091,l_ohb.ohb092,l_ohb.ohb16)
      IF g_success='N' THEN RETURN END IF 
  
      CALL p650_u_ima_7()
      IF g_success='N' THEN RETURN END IF 
 
      CALL p650_u_tlf_7()
      IF g_success='N' THEN RETURN END IF 
 
      IF g_sma.sma115 = 'Y' THEN
      SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=l_ohb.ohb04
       IF l_ima906 = '2' THEN  #子母單位
          IF NOT cl_null(l_ohb.ohb913) THEN 
             CALL p650_u_imgg_7('1',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
             l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,-1,'2')
             IF g_success='N' THEN RETURN END IF
          END IF
          IF NOT cl_null(l_ohb.ohb910) THEN 
             CALL p650_u_imgg_7('1',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                  l_ohb.ohb092,l_ohb.ohb910,l_ohb.ohb911,l_ohb.ohb912,-1,'1')
             IF g_success='N' THEN RETURN END IF
          END IF
          IF l_ohb.ohb915 <>0 OR l_ohb.ohb912 <>0 THEN
             CALL p650_u_tlff_7()
             IF g_success='N' THEN RETURN END IF
          END IF
       END IF
       IF l_ima906 = '3' THEN  #參考單位
          IF NOT cl_null(l_ohb.ohb913) THEN 
             CALL p650_u_imgg_7('2',l_ohb.ohb04,l_ohb.ohb09,l_ohb.ohb091,
                  l_ohb.ohb092,l_ohb.ohb913,l_ohb.ohb914,l_ohb.ohb915,-1,'2')
             IF g_success='N' THEN RETURN END IF
          END IF
          IF l_ohb.ohb915 <>0 OR l_ohb.ohb912 <>0 THEN
             CALL p650_u_tlff_7()
             IF g_success='N' THEN RETURN END IF
          END IF
       END IF
      END IF
                                                               
      CALL p650_u_tuq_tup_7()                                                     
      IF g_success='N' THEN RETURN END IF
      
  END FOREACH
END FUNCTION
 
FUNCTION p650_u_oha_7()
MESSAGE "u_oha!"
    CALL ui.Interface.refresh()
    UPDATE oha_file SET ohapost='N' WHERE oha01=l_oha.oha01
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err('upd ohapost:',SQLCA.SQLCODE,1) LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('upd ohapost:','axm-176',1) LET g_success='N' RETURN
    END IF
END FUNCTION
 
FUNCTION p650_u_img_7(p_ware,p_loca,p_lot,p_qty)
DEFINE p_ware LIKE ohb_file.ohb09
DEFINE p_loca LIKE ohb_file.ohb091
DEFINE p_lot  LIKE ohb_file.ohb092
DEFINE p_qty  LIKE ohb_file.ohb16
 
    CALL ui.Interface.refresh()
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF

    CALL ui.Interface.refresh()
    LET g_forupd_sql = 
        "   SELECT img01,img02,img03,img04 FROM img_file ",
        "     WHERE img01 = ? ",
        "      AND img02= ? ",
        "      AND img03= ? ",
        "      AND img04= ? ",
        "   FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock CURSOR FROM g_forupd_sql
 
    OPEN img_lock USING l_ohb.ohb04,p_ware,p_loca,p_lot
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock
       LET g_success = 'N' #No.MOD-8A0208 add
       RETURN
    END IF

    FETCH img_lock INTO l_ohb.ohb04,p_ware,p_loca,p_lot 
    IF STATUS THEN
       CALL cl_err('img_lock fail',STATUS,1) LET g_success='N' RETURN
    END IF
 
     CALL s_upimg(l_ohb.ohb04,p_ware,p_loca,p_lot,-1,p_qty,g_today,  #FUN-8C0084
                 '','','','',l_ohb.ohb01,l_ohb.ohb03,'','','','','','','','',0,0,'','')  #No.FUN-810036
    IF STATUS OR g_success = 'N' THEN
       CALL cl_err('p650_u_img_7(-1):','9050',0)
       LET g_success='N'
       RETURN
    END IF
END FUNCTION
 
FUNCTION p650_u_ima_7()
#DEFINE l_ima26  LIKE ima_file.ima26  #FUN-A20044
DEFINE l_avl_stk_mpsmrp  LIKE type_file.num15_3  #FUN-A20044
#DEFINE l_ima261 LIKE ima_file.ima261    #FUN-A20044
DEFINE l_unavl_stk LIKE type_file.num15_3    #FUN-A20044
#DEFINE l_ima262 LIKE ima_file.ima262     #FUN-A20044
DEFINE l_avl_stk LIKE type_file.num15_3     #FUN-A20044
 
MESSAGE "u_ima!"
    CALL ui.Interface.refresh()
  #  LET l_ima26=0 #FUN-A20044
    LET l_avl_stk_mpsmrp =0 #FUN-A20044
  #  LET l_ima261=0 #FUN-A20044
    LET l_unavl_stk = 0 #FUN-A20044
   # LET l_ima262=0  #FUN-A20044
    LET l_avl_stk=0  #FUN-A20044
   # SELECT SUM(img10*img21) INTO l_ima26  FROM img_file
    # WHERE img01=l_ohb.ohb04 
     #  AND img24='Y'   #FUN-A20044
    CALL s_getstock(l_ohb.ohb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 
       IF STATUS THEN
       CALL cl_err3("sel","img_file",l_ohb.ohb04,"",STATUS,"","sel sum1:",1)     #FUN-660167
       LET g_success='N'
    END IF 
   # IF l_ima26 IS NULL THEN LET l_ima26=0 END IF   #FUN-A20044
   # SELECT SUM(img10*img21) INTO l_ima261 FROM img_file
    # WHERE img01=l_ohb.ohb04 
    #   AND img23='N'    #FUN-A20044
     CALL s_getstock(l_ohb.ohb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
          IF STATUS THEN 
       CALL cl_err3("sel","img_file",l_ohb.ohb04,"",STATUS,"","sel sum2:",1)     #FUN-660167
       LET g_success='N' 
    END IF
 #   IF l_ima261 IS NULL THEN LET l_ima261=0 END IF  #FUN-A20044
    IF l_unavl_stk IS NULL THEN LET l_unavl_stk=0 END IF  #FUN-A20044
  #  SELECT SUM(img10*img21) INTO l_ima262 FROM img_file
   #@  WHERE img01=l_ohb.ohb04
     #  AND img23='Y'               #FUN-A20044
    CALL s_getstock(l_ohb.ohb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
       IF STATUS THEN
       CALL cl_err3("sel","img_file",l_ohb.ohb04,"",STATUS,"","sel sum3:",1)     #FUN-660167
       LET g_success='N' 
    END IF
  #  IF l_ima262 IS NULL THEN LET l_ima262=0 END IF  ##FUN-A20044
    IF l_avl_stk IS NULL THEN LET l_avl_stk=0 END IF  ##FUN-A20044
   ###FUN-A20044-----BEGIN
   #  UPDATE ima_file SET ima26=l_ima26,ima261=l_ima261,ima262=l_ima262
    # WHERE ima01= l_ohb.ohb04
   # IF STATUS OR SQLCA.SQLCODE THEN
   #    CALL cl_err('upd ima26*:',SQLCA.SQLCODE,1) LET g_success='N' RETURN 
   # END IF
  #  IF SQLCA.SQLERRD[3]=0 THEN
   #    CALL cl_err('upd ima26*:','axm-176',1) LET g_success='N' RETURN
   # END IF
  #####FUN-A20044-----END
END FUNCTION
 
FUNCTION p650_u_tlf_7()
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131 
 
   MESSAGE "d_tlf!"
 
   CALL ui.Interface.refresh()

  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",l_ohb.ohb04,"'",
                 "    AND tlf03= 50 AND tlf026='",l_ohb.ohb01,"' ",
                 "    AND tlf027=",l_ohb.ohb03," AND tlf06='",l_oha.oha02,"' "
    DECLARE p650_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p650_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end 
    IF s_joint_venture( l_ohb.ohb04 ,g_plant) OR NOT s_internal_item( l_ohb.ohb04,g_plant ) THEN    #FUN-A90049
    ELSE                                                                                  #FUN-A90049
       DELETE FROM tlf_file
          WHERE tlf01 =l_ohb.ohb04
            AND tlf03=50
            AND tlf026=l_ohb.ohb01 #銷退單號
            AND tlf027=l_ohb.ohb03 #銷退項次 
            AND tlf06 =l_oha.oha02 #銷退日期
 
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlf_file",l_ohb.ohb04,l_oha.oha02,SQLCA.SQLCODE,"","del tlf",1)   #No.FUN-660167
          LET g_success='N' RETURN
       END IF
 
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlf:','axm-176',1) LET g_success='N' RETURN
       END IF
    END IF            #FUN-A90049
    ##NO.FUN-8C0131   add--begin
   FOR l_i = 1 TO la_tlf.getlength()
      LET g_tlf.* = la_tlf[l_i].*
      IF NOT s_untlf1('') THEN 
         LET g_success='N' RETURN
      END IF 
   END FOR       
  ##NO.FUN-8C0131   add--end 
 
   SELECT ima918,ima921 INTO l_ima918,l_ima921
     FROM ima_file
    WHERE ima01 = l_ohb.ohb04
      AND imaacti = "Y"
 
   IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
      IF s_joint_venture( l_ohb.ohb04 ,g_plant) OR NOT s_internal_item( l_ohb.ohb04,g_plant ) THEN    #FUN-A90049
      ELSE                                                                                         #FUN-A90049
         DELETE FROM tlfs_file
         WHERE tlfs01 = l_ohb.ohb04
           AND tlfs10 = l_ohb.ohb01
           AND tlfs11 = l_ohb.ohb03
     
         IF STATUS OR SQLCA.SQLCODE THEN
            CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"",STATUS,"","del tlfs",1)
            LET g_success='N'
            RETURN
          END IF
     
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"","mfg0177","","del tlfs",1) 
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF   #No.MOD-840244
 
END FUNCTION
 
 
FUNCTION p650_u_imgg_7(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_imgg211,p_imgg10,p_type,p_no)
DEFINE p_imgg00    LIKE imgg_file.imgg00,
       p_imgg01    LIKE imgg_file.imgg01,
       p_imgg02    LIKE imgg_file.imgg02,
       p_imgg03    LIKE imgg_file.imgg03,
       p_imgg04    LIKE imgg_file.imgg04,
       p_imgg09    LIKE imgg_file.imgg09,
       p_imgg211   LIKE imgg_file.imgg211,
       p_imgg10    LIKE imgg_file.imgg10,
       p_type      LIKE aba_file.aba18,        #No.FUN-680137 VARCHAR(2)
       p_no        LIKE type_file.chr1,        #No.FUN-680137 VARCHAR(1)
       l_ima25     LIKE ima_file.ima25,
       l_ima906    LIKE ima_file.ima906,
       l_imgg21    LIKE imgg_file.imgg21
 
    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",   
        "  WHERE imgg01= ? ",
        "   AND imgg02= ? ",
        "   AND imgg03= ? ",
        "   AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "  
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock1 CURSOR FROM g_forupd_sql
 
  
    OPEN imgg_lock1 USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09   
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N' 
       CLOSE imgg_lock1
       RETURN
    END IF
    FETCH imgg_lock1 INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09 
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1) 
       LET g_success='N' 
       CLOSE imgg_lock1
       RETURN
    END IF

    SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"","ima25 null",0)   #No.FUN-660167
       LET g_success = 'N' RETURN 
    END IF
    
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no ='2') THEN 
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN 
    END IF
 
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_oga.oga02,  #FUN-8C0084
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
END FUNCTION
 
FUNCTION p650_u_tlff_7()
MESSAGE "d_tlff!"
    CALL ui.Interface.refresh()
    IF s_joint_venture( l_ohb.ohb04 ,g_plant) OR NOT s_internal_item( l_ohb.ohb04,g_plant ) THEN    #FUN-A90049
    ELSE  
        DELETE FROM tlff_file
        WHERE tlff01 =l_ohb.ohb04 
          AND tlff03=50
          AND tlff026=l_ohb.ohb01 #銷退單號
          AND tlff027=l_ohb.ohb03 #銷退項次 
          AND tlff06 =l_oha.oha02 #銷退日期
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlff_file",l_ohb.ohb04,l_oha.oha02,SQLCA.SQLCODE,"","del tlff",1)   #No.FUN-660167
          LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlff:','axm-176',1) LET g_success='N' RETURN
       END IF
    END IF
END FUNCTION
 
FUNCTION p650_u_tuq_tup_7()
DEFINE l_occ31     LIKE occ_file.occ31,
       l_ima25     LIKE ima_file.ima25,
       l_ima71     LIKE ima_file.ima71,
       l_imgg21    LIKE imgg_file.imgg21,
       l_tup05     LIKE tup_file.tup05,
       l_tuq06     LIKE tuq_file.tuq06,
       l_tuq07     LIKE tuq_file.tuq07,
       i           LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_cnt       LIKE type_file.num5,          #No.FUN-680137 SMALLINT
       l_desc      LIKE type_file.chr1           #No.FUN-680137 VARCHAR(1) 
DEFINE l_fac1,l_fac2 LIKE ogb_file.ogb15_fac
#FUN-910088--add--start--
DEFINE l_tup05_1   LIKE tup_file.tup05,
       l_tuq07_1   LIKE tuq_file.tuq07,
       l_tuq09_1   LIKE tuq_file.tuq09
#FUN-910088--add--end--    
 
   SELECT occ31 INTO l_occ31 FROM occ_file WHERE occ01=l_oha.oha03              
   IF cl_null(l_occ31) THEN LET l_occ31='N' END IF                              
   IF l_occ31 = 'N' THEN RETURN END IF    #occ31=.w&s:^2z'_                     
   SELECT ima25,ima71 INTO l_ima25,l_ima71                                      
     FROM ima_file WHERE ima01=l_ohb.ohb04                                      
   IF cl_null(l_ima71) THEN LET l_ima71=0 END IF                                
                                                                                
  IF g_oga.oga00 ='7' THEN
   SELECT COUNT(*) INTO i FROM tuq_file                                         
    WHERE tuq01=l_oha.oha03  
      AND tuq02=l_ohb.ohb04                              
      AND tuq03=l_ohb.ohb092 
      AND tuq04=l_oha.oha02  
      AND tuq11 ='2'
      AND tuq12 =l_oha.oha04   #MOD-7A0084 modify g_oga.oga04
 
   IF i=0 THEN
      LET l_fac1=1                                                              
      IF l_ohb.ohb05 <> l_ima25 THEN                                            
         CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)                         
              RETURNING l_cnt,l_fac1                                            
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(l_ohb.ohb04,'abm-731',1)                                
            LET l_fac1=1                                                        
         END IF                                                                 
      END IF                                                                    
       IF b_ogb.ogb092 ="" THEN 
          LET b_ogb.ogb092 = " "
       END IF
     #FUN-910088--add--start--
       LET l_tuq09_1 = b_ogb.ogb12*l_fac1
       LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
     #FUN-910088--add--end--
      INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,                       
                           tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,tuq051,    #No.TQC-7C0001 add tuq051                   
                            tuqplant,tuqlegal)    #FUN-980010 add
      VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,      
             l_ohb.ohb05,l_ohb.ohb12,l_fac1,l_ohb.ohb12*l_fac1,'2','2',g_oga.oga04,b_ogb.ogb03,   #No.TQC-7C0001 add b_ogb.ogb03            
                            g_plant,g_legal)    #FUN-980010 add
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",0)   #No.FUN-660167
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF                                                                    
   ELSE                                                                         
      SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file                            
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                           
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02         
         AND tuq11 ='2'
         AND tuq12 =l_oha.oha04   #MOD-7A0084 modify g_oga.oga04
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",0)   #No.FUN-660167
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF                                                                    
      LET l_fac1=1                                                              
      IF l_ohb.ohb05 <> l_tuq06 THEN                                            
         CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)                         
              RETURNING l_cnt,l_fac1                                            
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(l_ohb.ohb04,'abm-731',1)                                
            LET l_fac1=1                                                        
         END IF                                                                 
      END IF                                                                    
                                                                                
      LET l_fac2=1                                                              
      IF l_tuq06 <> l_ima25 THEN                                                
         CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)                             
              RETURNING l_cnt,l_fac2                                            
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(l_ohb.ohb04,'abm-731',1)           
            LET l_fac2=1                                                        
         END IF                                                                 
      END IF                                                                    
                                                                                
      SELECT tuq07 INTO l_tuq07 FROM tuq_file                                   
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                           
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                           
         AND tuq11 ='2'
         AND tuq12 =l_oha.oha04   #MOD-7A0084 modify g_oga.oga04
      IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF                             
      IF l_tuq07+l_ohb.ohb12*l_fac1<0 THEN                                      
         LET l_desc='2'                                                         
      ELSE                                                                      
         LET l_desc='1'                                                         
      END IF                                                                    
      IF l_tuq07+l_ohb.ohb12*l_fac1=0 THEN                                      
         DELETE FROM tuq_file                                                   
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                        
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                        
            AND tuq11 ='2'
            AND tuq12 =l_oha.oha04   #MOD-7A0084 modify g_oga.oga04
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",0)   #No.FUN-660167
            LET g_success='N'                                                   
            RETURN                                                              
         END IF                                                
      ELSE                                                                      
       #FUN-910088--add--start--
          LET l_tuq07_1 = l_ohb.ohb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07+l_tuq07_1,
                              tuq09=tuq09+l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088--mark--start--
       # UPDATE tuq_file SET tuq07=tuq07+l_ohb.ohb12*l_fac1,                    
       #                     tuq09=tuq09+l_ohb.ohb12*l_fac1*l_fac2,             
       #FUN-910088--mark--end--
                             tuq10=l_desc                                       
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                        
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                        
            AND tuq11 ='2'
            AND tuq12 =l_oha.oha04   #MOD-7A0084 modify g_oga.oga04
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",0)   #No.FUN-660167
            LET g_success='N'                                                   
            RETURN                                                              
         END IF                                                                 
      END IF                                                                    
   END IF                              
  ELSE                                         
   SELECT COUNT(*) INTO i FROM tuq_file                                         
    WHERE tuq01=l_oha.oha03  
      AND tuq02=l_ohb.ohb04                              
      AND tuq03=l_ohb.ohb092 
      AND tuq04=l_oha.oha02  
      AND tuq11 ='1'             #MOD-7A0084  modify 2->1
      AND tuq12 =l_oha.oha04     #MOD-7A0084  modify g_oga.oga04
 
   IF i=0 THEN
      LET l_fac1=1                                                              
      IF l_ohb.ohb05 <> l_ima25 THEN                                            
         CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)                         
              RETURNING l_cnt,l_fac1                                            
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(l_ohb.ohb04,'abm-731',1)                                
            LET l_fac1=1                                                        
         END IF                                                                 
      END IF                                                                    
      INSERT INTO tuq_file(tuq01,tuq02,tuq03,tuq04,tuq05,                       
                           tuq06,tuq07,tuq08,tuq09,tuq10,tuq11,tuq12,tuq051,  #No.TQC-7C0001 add tuq051                     
                            tuqplant,tuqlegal)    #FUN-980010 add
      VALUES(l_oha.oha03,l_ohb.ohb04,l_ohb.ohb092,l_oha.oha02,l_oha.oha01,      
             l_ohb.ohb05,l_ohb.ohb12,l_fac1,l_ohb.ohb12*l_fac1,'2','2',g_oga.oga04,b_ogb.ogb03,  #No.TQC-7C0001 add b_ogb.ogb03            
                            g_plant,g_legal)    #FUN-980010 add
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("ins","tuq_file","","",SQLCA.sqlcode,"","insert tuq_file",0)   #No.FUN-660167
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF                                                                    
   ELSE                                                                         
      SELECT UNIQUE tuq06 INTO l_tuq06 FROM tuq_file                            
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                           
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02         
         AND tuq11 ='1'             #MOD-7A0084  modify 2->1
         AND tuq12 =l_oha.oha04     #MOD-7A0084  modify g_oga.oga04
      IF SQLCA.sqlcode THEN                                                     
         CALL cl_err3("sel","tuq_file","","",SQLCA.sqlcode,"","select tuq06",0)   #No.FUN-660167
         LET g_success ='N'                                                     
         RETURN                                                                 
      END IF                                                                    
      LET l_fac1=1                                                              
      IF l_ohb.ohb05 <> l_tuq06 THEN                                            
         CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_tuq06)                         
              RETURNING l_cnt,l_fac1                                            
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(l_ohb.ohb04,'abm-731',1)                                
            LET l_fac1=1                                                        
         END IF                                                                 
      END IF                                                                    
                                                                                
      LET l_fac2=1                                                              
      IF l_tuq06 <> l_ima25 THEN                                                
         CALL s_umfchk(l_ohb.ohb04,l_tuq06,l_ima25)                             
              RETURNING l_cnt,l_fac2                                            
         IF l_cnt = '1'  THEN                                                   
            CALL cl_err(l_ohb.ohb04,'abm-731',1)           
            LET l_fac2=1                                                        
         END IF                                                                 
      END IF                                                                    
                                                                                
      SELECT tuq07 INTO l_tuq07 FROM tuq_file                                   
       WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                           
         AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                           
         AND tuq11 ='1'             #MOD-7A0084  modify 2->1
         AND tuq12 =l_oha.oha04     #MOD-7A0084  modify g_oga.oga04
      IF cl_null(l_tuq07) THEN LET l_tuq07=0 END IF                             
      IF l_tuq07+l_ohb.ohb12*l_fac1<0 THEN                                      
         LET l_desc='2'                                                         
      ELSE                                                                      
         LET l_desc='1'                                                         
      END IF                                                                    
      IF l_tuq07+l_ohb.ohb12*l_fac1=0 THEN                                      
         DELETE FROM tuq_file                                                   
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                        
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                        
            AND tuq11 ='1'             #MOD-7A0084  modify 2->1
            AND tuq12 =l_oha.oha04     #MOD-7A0084  modify g_oga.oga04
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("del","tuq_file","","",SQLCA.sqlcode,"","delete tuq_file",0)   #No.FUN-660167
            LET g_success='N'                                                   
            RETURN                                                              
         END IF                                                
      ELSE                                                                      
       #FUN-910088--add--start--
          LET l_tuq07_1 = l_ohb.ohb12*l_fac1
          LET l_tuq07_1 = s_digqty(l_tuq07_1,l_tuq06)
          LET l_tuq09_1 = l_ohb.ohb12*l_fac1*l_fac2
          LET l_tuq09_1 = s_digqty(l_tuq09_1,l_ima25)
          UPDATE tuq_file SET tuq07=tuq07+l_tuq07_1,
                              tuq09=tuq09+l_tuq09_1,
       #FUN-910088--add--end--
       #FUN-910088-mark--start--
       # UPDATE tuq_file SET tuq07=tuq07+l_ohb.ohb12*l_fac1,                    
       #                     tuq09=tuq09+l_ohb.ohb12*l_fac1*l_fac2,             
       #FUN-910088-mark--end--
                             tuq10=l_desc                                       
          WHERE tuq01=l_oha.oha03  AND tuq02=l_ohb.ohb04                        
            AND tuq03=l_ohb.ohb092 AND tuq04=l_oha.oha02                        
            AND tuq11 ='1'             #MOD-7A0084  modify 2->1
            AND tuq12 =l_oha.oha04     #MOD-7A0084  modify g_oga.oga04
         IF SQLCA.sqlcode THEN                                                  
            CALL cl_err3("upd","tuq_file","","",SQLCA.sqlcode,"","update tuq_file",0)   #No.FUN-660167
            LET g_success='N'                                                   
            RETURN                                                              
         END IF                                                                 
      END IF                                                                    
   END IF                                                                       
  END IF                     
                                                                                
   LET l_fac1=1                                                                 
   IF l_ohb.ohb05 <> l_ima25 THEN                                               
      CALL s_umfchk(l_ohb.ohb04,l_ohb.ohb05,l_ima25)                            
           RETURNING l_cnt,l_fac1                                               
      IF l_cnt = '1'  THEN                                                      
         CALL cl_err(l_ohb.ohb04,'abm-731',1)                                   
         LET l_fac1=1                                                           
      END IF                                  
   END IF                                                                       
   IF g_oga.oga00 ='7' THEN
   SELECT tup05 INTO l_tup05 FROM tup_file                                      
    WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04                              
      AND tup03=l_ohb.ohb092                                                    
     #AND ((tup08 ='2' AND tup09 =g_oga.oga04) OR   #FUN-640014 modify #CHI-B40056 mark
     #     (tup11 ='2' AND tup12 =g_oga.oga04))     #FUN-640014 modify #CHI-B40056 mark
      AND tup11 ='2' AND tup12 =g_oga.oga04                            #CHI-B40056
     #FUN-910088--add--start--
       LET l_tup05_1 = l_ohb.ohb12*l_fac1            
       LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)    
       UPDATE tup_file SET tup05 = tup05+l_tup05_1 
     #FUN-910088--add--end--
     #UPDATE tup_file SET tup05=tup05+l_ohb.ohb12*l_fac1        #FUN-910088--mark--                
       WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04                           
         AND tup03=l_ohb.ohb092         
        #AND ((tup08 ='2' AND tup09 =g_oga.oga04) OR   #FUN-640014 modify #CHI-B40056 mark
        #     (tup11 ='2' AND tup12 =g_oga.oga04))     #FUN-640014 modify #CHI-B40056 mark
         AND tup11 ='2' AND tup12 =g_oga.oga04                            #CHI-B40056
   ELSE
   SELECT tup05 INTO l_tup05 FROM tup_file                                      
    WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04                              
      AND tup03=l_ohb.ohb092                                                    
     #AND ((tup08 ='1' AND tup09 =g_oga.oga04) OR   #FUN-640014 modify #CHI-B40056 mark
     #     (tup11 ='1' AND tup12 =g_oga.oga04))     #FUN-640014 modify #CHI-B40056 mark
      AND tup11 ='1' AND tup12 =g_oga.oga04                            #CHI-B40056
     #FUN-910088--add--start--
       LET l_tup05_1 = l_ohb.ohb12*l_fac1            
       LET l_tup05_1 = s_digqty(l_tup05_1,l_ima25)    
       UPDATE tup_file SET tup05 = tup05+l_tup05_1 
     #FUN-910088--add--end--
                                                                     
     #UPDATE tup_file SET tup05=tup05+l_ohb.ohb12*l_fac1   #FUN-910088--mark--                     
       WHERE tup01=l_oha.oha03  AND tup02=l_ohb.ohb04                           
         AND tup03=l_ohb.ohb092         
        #AND ((tup08 ='1' AND tup09 =g_oga.oga04) OR   #FUN-640014 modify #CHI-B40056 mark
        #     (tup11 ='1' AND tup12 =g_oga.oga04))     #FUN-640014 modify #CHI-B40056 mark
         AND tup11 ='1' AND tup12 =g_oga.oga04                            #CHI-B40056 
    END IF
END FUNCTION
 
FUNCTION p650_u_oga()
    MESSAGE "u_oga!"
    CALL ui.Interface.refresh()
    UPDATE oga_file SET ogapost='N' WHERE oga01=g_oga.oga01
    IF STATUS OR SQLCA.SQLCODE THEN
       CALL cl_err3("upd","oga_file","","",STATUS,"","upd ogapost",1)   #No.FUN-660167
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err('upd ogapost:','axm-176',1) LET g_success='N' RETURN
    END IF
   IF NOT cl_null(g_oga.oga011) THEN #通知單號
      IF g_oga.oga09 <> '8' THEN
         UPDATE oga_file SET ogapost='N' WHERE oga01=g_oga.oga011
      END IF
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('upd ogapost:','axm-176',1) LET g_success='N' RETURN
   END IF
END FUNCTION
 
FUNCTION p650_u_img(p_ware,p_loca,p_lot,p_qty,p_item) # Update img_file #FUN-5C0075
  DEFINE p_ware  LIKE ogb_file.ogb09,       ##倉庫
         p_loca  LIKE ogb_file.ogb091,      ##儲位 
         p_lot   LIKE ogb_file.ogb092,      ##批號   
         p_qty   LIKE qcs_file.qcs06,   ##數量   #No.FUN-680137 DECIMAL (11,3)
         p_item  LIKE ogb_file.ogb04        #FUN-5C0075
  DEFINE l_img    RECORD
                  img10   LIKE img_file.img10,
                  img16   LIKE img_file.img16,
                  img23   LIKE img_file.img23,
                  img24   LIKE img_file.img24,
                  img09   LIKE img_file.img09,
                  img21   LIKE img_file.img21
                  END RECORD
  DEFINE l_ogbi RECORD LIKE ogbi_file.*  #TQC-BA0136
  DEFINE l_flag LIKE type_file.num5      #TQC-BA0136
  
    MESSAGE "u_img!"
#FUN-A90049-------------start
    IF s_joint_venture( p_item ,g_plant) OR NOT s_internal_item( p_item,g_plant ) THEN    
       RETURN
    END IF    
#FUN-A90049-------------end
    CALL ui.Interface.refresh()
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' ' END IF
    IF cl_null(p_qty)  THEN LET p_qty=0 END IF
 
#NO.MOD-660127 start-- 不能直接update img10，要檢查庫存量是否足夠，是否允許負庫存
    LET g_forupd_sql = "SELECT img10,img16,img23,img24,img09,img21 ",
                       " FROM img_file ",
                       "  WHERE img01 = ? AND img02= ? AND img03= ? ",
                       " AND img04= ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img_lock1 CURSOR FROM g_forupd_sql
 
    OPEN img_lock1 USING p_item,p_ware,p_loca,p_lot         #MOD-780017 
    IF STATUS THEN
       CALL cl_err("OPEN img_lock:", STATUS, 1)
       CLOSE img_lock1
       LET g_success = 'N'  #No.MOD-8A)208 add
       RETURN
    END IF
 
    FETCH img_lock1 INTO l_img.*
    IF STATUS THEN
       CALL s_errmsg('','',"lock img fail",SQLCA.sqlcode,1)  #No.FUN-710046
       LET g_success='N' RETURN
    END IF
    IF cl_null(l_img.img10) THEN LET l_img.img10=0 END IF
    CALL s_upimg(p_item,p_ware,p_loca,p_lot,g_type,p_qty,g_today,   #MOD-9A0172
          '','','','',b_ogb.ogb01,b_ogb.ogb03,'','','','','','','','',0,0,'','')  #No.FUN-810036
    IF g_success='N' THEN
       CALL s_errmsg('','',"s_upimg()",SQLCA.sqlcode,1)   #No.FUN-710046
       RETURN
    END IF

    #TQC-BA0136(S)
    IF s_industry('icd') THEN
       SELECT * INTO l_ogbi.* FROM ogbi_file 
         WHERE ogbi01 = b_ogb.ogb01 AND ogbi03 = b_ogb.ogb03
       CALL s_icdpost(g_type*-1,p_item,p_ware,p_loca,
                         p_lot,b_ogb.ogb05,p_qty,
                         b_ogb.ogb01,b_ogb.ogb03,g_oga.oga02,'N','',''
                         ,l_ogbi.ogbiicd029,l_ogbi.ogbiicd028,g_plant)
              RETURNING l_flag  
       IF l_flag = 0 THEN 
          LET g_success="Y"
          RETURN
       END IF  
    END IF 
    #TQC-BA0136(E)
 
END FUNCTION
 
FUNCTION p650_u_ima(p_item) #------------------------------------ Update ima_file  #FUN-5C0075
  #  DEFINE l_ima26,l_ima261,l_ima262	LIKE ima_file.ima26  #FUN-A20044
    DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3  #FUN-A20044
    DEFINE p_item   LIKE ogb_file.ogb04  #FUN-5C0075
    CALL ui.Interface.refresh()
   # LET l_ima26=0 LET l_ima261=0 LET l_ima262=0     #FUN-A20044
    LET l_avl_stk_mpsmrp = 0 LET l_unavl_stk =0 LET l_avl_stk =0 #FUN-A20044
   # SELECT SUM(img10*img21) INTO l_ima26  FROM img_file
     #      WHERE img01=p_item AND img23='Y' AND img24='Y'  #FUN-5C0075  #FUN-A20044
    CALL s_getstock(p_item,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
   #   IF STATUS THEN 
    #   CALL cl_err3("sel","img_file",p_item,"",STATUS,"","sel sum1:",1)      #FUN-660167
     #  LET g_success='N' 
   # END IF
   # IF l_ima26 IS NULL THEN LET l_ima26=0 END IF #FUN-A20044
    IF l_avl_stk_mpsmrp IS NULL THEN LET l_avl_stk_mpsmrp=0 END IF #FUN-A20044
   # SELECT SUM(img10*img21) INTO l_ima261 FROM img_file
    #       WHERE img01=p_item AND img23='N'  #FUN-5C0075 #FUN-A20044
   
   # IF STATUS THEN 
    #   CALL s_errmsg("img01",p_item,"SEL img_file",SQLCA.sqlcode,1)          #No.FUN-710046
     #  LET g_success='N' 
   # END IF                    #FUN-A20044
   # IF l_ima261 IS NULL THEN LET l_ima261=0 END IF
   # SELECT SUM(img10*img21) INTO l_ima262 FROM img_file
    #       WHERE img01=p_item AND img23='Y'  #FUN-5C0075 
   # IF STATUS THEN 
    #   CALL s_errmsg("img01",p_item,"SEL img_file",SQLCA.sqlcode,1)          #No.FUN-710046
     #  LET g_success='N' 
  #  END IF
   # IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
   # UPDATE ima_file SET ima26=l_ima26,ima261=l_ima261,ima262=l_ima262
    #           WHERE ima01= p_item    #FUN-5C0075 
   # IF STATUS OR SQLCA.SQLCODE THEN
    #   CALL s_errmsg("ima01",p_item,"UPD ima_file",SQLCA.sqlcode,1)          #No.FUN-710046
     #  LET g_success='N' RETURN
  #  END IF
   # IF SQLCA.SQLERRD[3]=0 THEN
    #   CALL s_errmsg("ima01",p_item,"UPD ima_file",SQLCA.sqlcode,1)          #No.FUN-710046
     #  LET g_success='N' RETURN                                              #No.FUN-710046
  #  END IF
END FUNCTION
 
FUNCTION p650_u_tlf() #------------------------------------ Update tlf_file
DEFINE    l_ogc17   LIKE ogc_file.ogc17
DEFINE    la_tlf    DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
DEFINE    l_sql     STRING                                    #NO.FUN-8C0131 
DEFINE    l_i       LIKE type_file.num5                       #NO.FUN-8C0131 
    MESSAGE "d_tlf!"
    CALL ui.Interface.refresh()
    IF b_ogb.ogb17='Y' AND g_oaz.oaz23 = 'Y' THEN
       DECLARE p650_ogc_c1 CURSOR FOR  SELECT UNIQUE ogc17 FROM ogc_file    #MOD-890095
         WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
       FOREACH p650_ogc_c1 INTO l_ogc17
  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",l_ogc17,"'",
                 "    AND  tlf02 =50 AND tlf026='",g_oga.oga01,"' ",
                 "    AND  tlf027=",b_ogb.ogb03,"  ",
                 "   AND tlf06 ='",g_oga.oga02,"'"     
    DECLARE p650_u_tlf_c1 CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p650_u_tlf_c1 INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end
     IF s_joint_venture( l_ogc17 ,g_plant) OR NOT s_internal_item( l_ogc17,g_plant ) THEN    #FUN-A90049
     ELSE                                                                                  #FUN-A90049
          DELETE FROM tlf_file
           WHERE tlf01 =l_ogc17 AND tlf02=50
             AND tlf026=g_oga.oga01 #參考單据(出貨單號)
             AND tlf027=b_ogb.ogb03 #出貨項次 
             AND tlf06 =g_oga.oga02 #出貨日期
          IF STATUS OR SQLCA.SQLCODE THEN
             CALL cl_err3("del","tlf_file",l_ogc17,g_oga.oga02,STATUS,"","del tlf",1)   #No.FUN-660167
             LET g_success='N' RETURN
          END IF
          IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err('del tlf:','axm-176',1) LET g_success='N' RETURN
          END IF
     END IF                                                                              #FUN-A90049
    ##NO.FUN-8C0131   add--begin
                 FOR l_i = 1 TO la_tlf.getlength()
                    LET g_tlf.* = la_tlf[l_i].*
                    IF NOT s_untlf1('') THEN 
                       LET g_success='N' RETURN
                    END IF 
                 END FOR       
  ##NO.FUN-8C0131   add--end  
         SELECT ima918,ima921 INTO l_ima918,l_ima921
           FROM ima_file
         #WHERE ima01 = b_ogb.ogb04 #CHI-AC0034 mark
          WHERE ima01 = l_ogc17 #CHI-AC0034
            AND imaacti = "Y"
         
         IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
           IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
           ELSE                                                                                       #FUN-A90049
           #IF (g_oga.oga65 = 'Y' AND g_oga.oga09='2') OR g_oga.oga09 = '8'    
           #IF (g_oga.oga65 = 'Y' AND g_oga.oga09 MATCHES '[23]') OR g_oga.oga09 = '8'   #FUN-BB0167  #FUN-C40072 mark
            IF (g_oga.oga65 = 'Y' AND g_oga.oga09 MATCHES '[234]') OR g_oga.oga09 = '8'               #FUN-C40072 add 4
                OR g_oga.oga00 MATCHES '[37]' THEN      #MOD-9C0049
                DELETE FROM tlfs_file
                 #WHERE tlfs01 = b_ogb.ogb04   #MOD-A90056
                 WHERE tlfs01 = l_ogc17   #MOD-A90056
                   AND tlfs10 = b_ogb.ogb01
                   AND tlfs11 = b_ogb.ogb03
                   AND tlfs09 = -1
             ELSE
                DELETE FROM tlfs_file
                 #WHERE tlfs01 = b_ogb.ogb04   #MOD-A90056
                 WHERE tlfs01 = l_ogc17   #MOD-A90056
                   AND tlfs10 = b_ogb.ogb01
                   AND tlfs11 = b_ogb.ogb03
            END IF   #MOD-9A0172
          END IF                                                                                 #FUN-90019 
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"",STATUS,"","del tlfs",1)
               LET g_success='N'
               RETURN
            END IF
           
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"","mfg0177","","del tlfs",1) 
               LET g_success='N'
               RETURN
            END IF
         END IF   #No.MOD-840244
 
       END FOREACH
    ELSE
  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",b_ogb.ogb04,"'",
                 "    AND  tlf02 =50 AND tlf026='",g_oga.oga01,"' ",
                 "    AND  tlf027=",b_ogb.ogb03,"  ",
                 "   AND tlf06 ='",g_oga.oga02,"'"     
    DECLARE p650_u_tlf_c2 CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH p650_u_tlf_c2 INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end 
   IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
   ELSE                                                                                       #FUN-A90049
       DELETE FROM tlf_file
              WHERE tlf01 =b_ogb.ogb04 AND tlf02=50
                AND tlf026=g_oga.oga01 #參考單据(出貨單號)
                AND tlf027=b_ogb.ogb03 #出貨項次 
                AND tlf06 =g_oga.oga02 #出貨日期
       IF STATUS OR SQLCA.SQLCODE THEN
          CALL cl_err3("del","tlf_file",b_ogb.ogb04,g_oga.oga02,STATUS,"","del tlf",1)   #No.FUN-660167
          LET g_success='N' RETURN
       END IF
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('del tlf:','axm-176',1) LET g_success='N' RETURN
       END IF
   END IF                                                                                      #FUN-90049
    ##NO.FUN-8C0131   add--begin
       FOR l_i = 1 TO la_tlf.getlength()
          LET g_tlf.* = la_tlf[l_i].*
          IF NOT s_untlf1('') THEN 
             LET g_success='N' RETURN
          END IF 
       END FOR       
  ##NO.FUN-8C0131   add--end  
       SELECT ima918,ima921 INTO l_ima918,l_ima921
         FROM ima_file
        WHERE ima01 = b_ogb.ogb04
          AND imaacti = "Y"
       
       IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
         IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
         ELSE                                                                                    #FUN-A90049
          #IF (g_oga.oga65 = 'Y' AND g_oga.oga09='2') OR g_oga.oga09 = '8'    
          #IF (g_oga.oga65 = 'Y' AND g_oga.oga09 MATCHES '[23]') OR g_oga.oga09 = '8'    #FUN-BB0167  #FUN-C40072 mark
           IF (g_oga.oga65 = 'Y' AND g_oga.oga09 MATCHES '[234]') OR g_oga.oga09 = '8'   #FUN-C40072 add 4
              OR g_oga.oga00 MATCHES '[37]' THEN      #MOD-9C0049
             DELETE FROM tlfs_file
              WHERE tlfs01 = b_ogb.ogb04
                AND tlfs10 = b_ogb.ogb01
                AND tlfs11 = b_ogb.ogb03
                AND tlfs09 = -1
          ELSE
             DELETE FROM tlfs_file
              WHERE tlfs01 = b_ogb.ogb04
                AND tlfs10 = b_ogb.ogb01
                AND tlfs11 = b_ogb.ogb03
          END IF   #CHI-970040
         
          IF STATUS OR SQLCA.SQLCODE THEN
             CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"",STATUS,"","del tlfs",1)
             LET g_success='N'
             RETURN
          END IF
         
          IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"","mfg0177","","del tlfs",1) 
             LET g_success='N'
             RETURN
          END IF
         END IF                                                                                #FUN-A90049 
       END IF   #No.MOD-840244
 
    END IF
 
END FUNCTION
 
FUNCTION p650_u2_tlf() #for 境外倉-------------------------- Update tlf_file
DEFINE    l_ogc17   LIKE ogc_file.ogc17
DEFINE    la_tlf    DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
DEFINE    l_sql     STRING                                    #NO.FUN-8C0131 
DEFINE    l_i       LIKE type_file.num5                       #NO.FUN-8C0131 
    MESSAGE "d_tlf!"
    CALL ui.Interface.refresh()
    IF b_ogb.ogb17='Y' AND g_oga.oga09 <> '7' THEN     ##多倉儲出貨  #No.FUN-610057
       DECLARE p650_ogc_c2 CURSOR FOR  SELECT ogc17 FROM ogc_file 
         WHERE ogc01=g_oga.oga01 AND ogc03=b_ogb.ogb03
       FOREACH p650_ogc_c2 INTO l_ogc17
        IF cl_null(b_ogb.ogb31) THEN 
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         "  WHERE  tlf01 = '",l_ogc17,"' AND tlf02=724 ",
                      #  "    AND tlf036='",b_ogb.ogb01,"' AND tlf037=",b_ogb.ogb03,") ",
                      #  "    AND tlf026='",b_ogb.ogb01,"' AND tlf027=",b_ogb.ogb03,") ",
                         "    AND tlf036='",b_ogb.ogb01,"' AND tlf037='",b_ogb.ogb03,"' ",  #TQC-AA0010 modify
                         "    AND tlf026='",b_ogb.ogb01,"' AND tlf027='",b_ogb.ogb03,"' ",  #TQC-AA0010 modify
                         "   AND tlf06 ='",g_oga.oga02,"'"     
            DECLARE p650_u_tlf_c3 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p650_u_tlf_c3 INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end 
          IF s_joint_venture( l_ogc17 ,g_plant) OR NOT s_internal_item( l_ogc17,g_plant ) THEN    #FUN-A90049
          ELSE                                                                                      #FUN-A90049
             DELETE FROM tlf_file
                  WHERE tlf01 =l_ogc17 AND tlf02=724
                    AND tlf036=b_ogb.ogb01
                    AND tlf037=b_ogb.ogb03
                    AND tlf026=b_ogb.ogb01 #參考單据(出貨單號)
                    AND tlf027=b_ogb.ogb03 #出貨項次 
                    AND tlf06 =g_oga.oga02 #出貨日期
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("del","tlf_file",l_ogc17,g_oga.oga02,SQLCA.SQLCODE,"","del tlf(2)",1)   #No.FUN-660167
                LET g_success='N' RETURN
             END IF
          END IF                                                                               #FUN-A90049  
    ##NO.FUN-8C0131   add--begin
           FOR l_i = 1 TO la_tlf.getlength()
              LET g_tlf.* = la_tlf[l_i].*
              IF NOT s_untlf1('') THEN 
                 LET g_success='N' RETURN
              END IF 
           END FOR       
  ##NO.FUN-8C0131   add--end 
           SELECT ima918,ima921 INTO l_ima918,l_ima921
             FROM ima_file
           #WHERE ima01 = b_ogb.ogb04 #CHI-AC0034 mark
            WHERE ima01 = l_ogc17 #CHI-AC0034
              AND imaacti = "Y"
           IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
             IF s_joint_venture( l_ogc17 ,g_plant) OR NOT s_internal_item( l_ogc17,g_plant ) THEN    #FUN-A90049
             ELSE                                                                          #FUN-A90049
                DELETE FROM tlfs_file
                #WHERE tlfs01 = b_ogb.ogb04   #MOD-A90056
                 WHERE tlfs01 = l_ogc17   #MOD-A90056
                  AND tlfs10 = b_ogb.ogb01
                  AND tlfs11 = b_ogb.ogb03
              
                IF STATUS OR SQLCA.SQLCODE THEN
                   CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"",STATUS,"","del tlfs",1)
                   LET g_success='N'
                   RETURN
                END IF
              END IF                                                                     #FUN-A90049
              #-----MOD-A10160--------- 
              #IF SQLCA.SQLERRD[3]=0 THEN
              #   CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"","mfg0177","","del tlfs",1) 
              #   LET g_success='N'
              #   RETURN
              #END IF
              #-----END MOD-A10160-----
           END IF   #No.MOD-840244
        ELSE
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         "  WHERE  tlf01 = '",l_ogc17,"' AND tlf02=724 ",
                       # "    AND tlf036='",b_ogb.ogb01,"' AND tlf037=",b_ogb.ogb03,") ",
                       # "    AND tlf026='",b_ogb.ogb31,"' AND tlf027=",b_ogb.ogb32,") ",
                         "    AND tlf036='",b_ogb.ogb01,"' AND tlf037='",b_ogb.ogb03,"' ",  #TQC-AA0010 modify
                         "    AND tlf026='",b_ogb.ogb31,"' AND tlf027='",b_ogb.ogb32,"' ",  #TQC-AA0010 modify
                         "   AND tlf06 ='",g_oga.oga02,"'"     
            DECLARE p650_u_tlf_c4 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p650_u_tlf_c4 INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
           IF s_joint_venture( l_ogc17 ,g_plant) OR NOT s_internal_item( l_ogc17,g_plant ) THEN    #FUN-A90049
           ELSE                                                                                #FUN-A90049
           DELETE FROM tlf_file
                  WHERE tlf01 =l_ogc17 AND tlf02=724
                    AND tlf036=b_ogb.ogb01
                    AND tlf037=b_ogb.ogb03
                    AND tlf026=b_ogb.ogb31 #參考單据(出貨單號)
                    AND tlf027=b_ogb.ogb32 #出貨項次 
                    AND tlf06 =g_oga.oga02 #出貨日期
           
           IF STATUS OR SQLCA.SQLCODE THEN
              CALL cl_err3("del","tlf_file",l_ogc17,g_oga.oga02,SQLCA.SQLCODE,"","del tlf(2)",1)   #No.FUN-660167
              LET g_success='N' RETURN
           END IF
           END IF                                                                       #FUN-A90049
    ##NO.FUN-8C0131   add--begin
           FOR l_i = 1 TO la_tlf.getlength()
              LET g_tlf.* = la_tlf[l_i].*
              IF NOT s_untlf1('') THEN 
                 LET g_success='N' RETURN
              END IF 
           END FOR       
  ##NO.FUN-8C0131   add--end 
           SELECT ima918,ima921 INTO l_ima918,l_ima921
             FROM ima_file
           #WHERE ima01 = b_ogb.ogb04 #CHI-AC0034 mark
            WHERE ima01 = l_ogc17 #CHI-AC0034
              AND imaacti = "Y"
           IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
             IF s_joint_venture( l_ogc17 ,g_plant) OR NOT s_internal_item( l_ogc17,g_plant ) THEN    #FUN-A90049
             ELSE                                                                               #FUN-A90049
              DELETE FROM tlfs_file
               #WHERE tlfs01 = b_ogb.ogb04   #MOD-A90056
               WHERE tlfs01 = l_ogc17   #MOD-A90056
                 AND tlfs10 = b_ogb.ogb01   
                 AND tlfs11 = b_ogb.ogb03   
                 AND tlfs09 = 1
              
              IF STATUS OR SQLCA.SQLCODE THEN
                 CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"",STATUS,"","del tlfs",1)
                 LET g_success='N'
                 RETURN
              END IF
             END IF                                                                             #FUN-A90049
              
              #-----MOD-A10160--------- 
              #IF SQLCA.SQLERRD[3]=0 THEN
              #   CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"","mfg0177","","del tlfs",1) 
              #   LET g_success='N'
              #   RETURN
              #END IF
              #-----END MOD-A10160----- 
           END IF   #No.MOD-840244
        END IF   #MOD-790023 add
       END FOREACH
    ELSE
        IF cl_null(b_ogb.ogb31) THEN 
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         "  WHERE  tlf01 = '",b_ogb.ogb04,"' AND tlf02=724 ",
                    #    "    AND tlf036='",b_ogb.ogb01,"' AND tlf037=",b_ogb.ogb03,") ",
                    #    "    AND tlf026='",b_ogb.ogb01,"' AND tlf027=",b_ogb.ogb03,") ",
                         "    AND tlf036='",b_ogb.ogb01,"' AND tlf037='",b_ogb.ogb03,"' ", #TQC-AA0010 modify
                         "    AND tlf026='",b_ogb.ogb01,"' AND tlf027='",b_ogb.ogb03,"' ", #TQC-AA0010 modify
                         "   AND tlf06 ='",g_oga.oga02,"'"     
            DECLARE p650_u_tlf_c5 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p650_u_tlf_c5 INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
          IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
          ELSE                                                                                 #FUN-A90049
            DELETE FROM tlf_file
              WHERE tlf01 =b_ogb.ogb04 AND tlf02=724
                AND tlf036=b_ogb.ogb01
                AND tlf037=b_ogb.ogb03
                AND tlf026=b_ogb.ogb01 #參考單据(出貨單號)
                AND tlf027=b_ogb.ogb03 #出貨項次 
                AND tlf06 =g_oga.oga02 #出貨日期
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("del","tlf_file",b_ogb.ogb04,g_oga.oga02,SQLCA.SQLCODE,"","del tlf(2)",1)   #No.FUN-660167
               LET g_success='N' RETURN
            END IF
          END IF                                                                             #FUN-A90049
    ##NO.FUN-8C0131   add--begin
          FOR l_i = 1 TO la_tlf.getlength()
             LET g_tlf.* = la_tlf[l_i].*
             IF NOT s_untlf1('') THEN 
                LET g_success='N' RETURN
             END IF 
          END FOR       
  ##NO.FUN-8C0131   add--end
           SELECT ima918,ima921 INTO l_ima918,l_ima921
             FROM ima_file
            WHERE ima01 = b_ogb.ogb04
              AND imaacti = "Y"
           
           IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
             IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
             ELSE                                                                                       #FUN-A90049
              DELETE FROM tlfs_file
               WHERE tlfs01 = b_ogb.ogb04
                 AND tlfs10 = b_ogb.ogb01
                 AND tlfs11 = b_ogb.ogb03
              IF STATUS OR SQLCA.SQLCODE THEN
                 CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"",STATUS,"","del tlfs",1)
                 LET g_success='N'
                 RETURN
              END IF
            END IF                                                                               #FUN-A90049

              #-----MOD-A10160--------- 
              #IF SQLCA.SQLERRD[3]=0 THEN
              #   CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"","mfg0177","","del tlfs",1) 
              #   LET g_success='N'
              #   RETURN
              #END IF
              #-----MOD-A10160--------- 
           END IF   #No.MOD-840244
        ELSE
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         "  WHERE  tlf01 = '",b_ogb.ogb04,"' AND tlf02=724 ",
                      #  "    AND tlf036='",b_ogb.ogb01,"' AND tlf037=",b_ogb.ogb03,") ",
                      #  "    AND tlf026='",b_ogb.ogb31,"' AND tlf027=",b_ogb.ogb32,") ",
                         "    AND tlf036='",b_ogb.ogb01,"' AND tlf037='",b_ogb.ogb03,"' ",    #TQC-AA0010  modify
                         "    AND tlf026='",b_ogb.ogb31,"' AND tlf027='",b_ogb.ogb32,"' ",    #TQC-AA0010  modify
                         "   AND tlf06 ='",g_oga.oga02,"'"     
            DECLARE p650_u_tlf_c6 CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH p650_u_tlf_c6 INTO g_tlf.*
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
           IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
           ELSE                                                                                         #FUN-A90049
               DELETE FROM tlf_file
                  WHERE tlf01 =b_ogb.ogb04 AND tlf02=724
                    AND tlf036=b_ogb.ogb01
                    AND tlf037=b_ogb.ogb03
                    AND tlf026=b_ogb.ogb31 #參考單据(出貨單號)
                    AND tlf027=b_ogb.ogb32 #出貨項次 
                    AND tlf06 =g_oga.oga02 #出貨日期
             IF STATUS OR SQLCA.SQLCODE THEN
                CALL cl_err3("del","tlf_file",b_ogb.ogb04,g_oga.oga02,SQLCA.SQLCODE,"","del tlf(2)",1)   #No.FUN-660167
                LET g_success='N' RETURN
             END IF
           END IF                                                                                       #FUN-A90049
    ##NO.FUN-8C0131   add--begin
          FOR l_i = 1 TO la_tlf.getlength()
             LET g_tlf.* = la_tlf[l_i].*
             IF NOT s_untlf1('') THEN 
                LET g_success='N' RETURN
             END IF 
          END FOR       
  ##NO.FUN-8C0131   add--end 
           SELECT ima918,ima921 INTO l_ima918,l_ima921
             FROM ima_file
            WHERE ima01 = b_ogb.ogb04
              AND imaacti = "Y"
           
           IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
             IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
             ELSE                                                                                   #FUN-A90049
               DELETE FROM tlfs_file
                WHERE tlfs01 = b_ogb.ogb04
                 AND tlfs10 = b_ogb.ogb01   
                 AND tlfs11 = b_ogb.ogb03   
                 AND tlfs09 = 1
              IF STATUS OR SQLCA.SQLCODE THEN
                 CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"",STATUS,"","del tlfs",1)
                 LET g_success='N'
                 RETURN
              END IF
            END IF                                                                               #FUN-A90049  
              #-----MOD-A10160--------- 
              #IF SQLCA.SQLERRD[3]=0 THEN
              #   CALL cl_err3("del","tlfs_file",l_ohb.ohb01,"","mfg0177","","del tlfs",1) 
              #   LET g_success='N'
              #   RETURN
              #END IF
              #-----END MOD-A10160----- 
           END IF   #No.MOD-840244
        END IF   #MOD-790023 add
    END IF
END FUNCTION
 
FUNCTION p650_u_oeb() 				#更新訂單已出貨單量
   DEFINE tot1,tot3        LIKE ogb_file.ogb12  #FUN-4C0006
   DEFINE tot5     LIKE ogb_file.ogb12   #MOD-AB0151
   DEFINE tot6     LIKE ogb_file.ogb12   #MOD-AB0151
   DEFINE l_oga011 LIKE oga_file.oga011  #MOD-AB0151
   DEFINE l_amount         LIKE oea_file.oea62  #FUN-4C0006
   DEFINE l_tot4           LIKE oeb_file.oeb29   #No.TQC-8C0027
   DEFINE l_oeb29          LIKE oeb_file.oeb29   #No.TQC-8C0027
   DEFINE l_oea12          LIKE oea_file.oea12   #No.TQC-8C0027
   DEFINE l_oeb71          LIKE oeb_file.oeb71   #No.TQC-8C0027
 #  DEFINE l_ima262   LIKE ima_file.ima262,#FUN-A20044
   DEFINE l_avl_stk_mpsmrp,l_unavl_stk LIKE type_file.num15_3#FUN-A20044
  DEFINE l_avl_stk   LIKE type_file.num15_3,#FUN-A20044
          l_qoh      LIKE oeb_file.oeb12,
          l_oeb      RECORD
                      oeb04     LIKE oeb_file.oeb04,
                      oeb05_fac LIKE oeb_file.oeb05_fac,
                      oeb12     LIKE oeb_file.oeb12,
                      oeb19     LIKE oeb_file.oeb19,
                      oeb24     LIKE oeb_file.oeb24,
                      oeb25     LIKE oeb_file.oeb25,
                      oeb26     LIKE oeb_file.oeb26,
                      oeb905    LIKE oeb_file.oeb905
                     END RECORD
   DEFINE l_ogb14  LIKE ogb_file.ogb14   #CHI-C90032 add
   DEFINE l_ocn03   LIKE ocn_file.ocn03  #CHI-C90032 add
   DEFINE l_ocn04   LIKE ocn_file.ocn04  #CHI-C90032 add
   DEFINE l_oea61   LIKE oea_file.oea61  #CHI-C90032 add
   DEFINE tot1_t    LIKE ogb_file.ogb12   #MOD-D70030 add
 
   MESSAGE "u_oeb!"
   CALL ui.Interface.refresh()
   IF NOT cl_null(b_ogb.ogb31) AND b_ogb.ogb31[1,4] <> 'MISC' THEN
 
      #-----MOD-A50076---------
      #SELECT SUM(ogb12) INTO tot3 FROM ogb_file, oga_file
      #    WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32 AND ogb01=oga01
      #      AND ((oga09='1' AND oga011 IS NULL AND ogaconf='Y') OR
      #           (oga09 IN ('2','4','6','7') AND ogapost='N'    AND ogaconf='Y'))  #No.FUN-610057	#MOD-990233
      #
      #SELECT SUM(ogb12) INTO tot1 FROM ogb_file, oga_file
      #    WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32
      #      AND ogb01=oga01 AND ogapost='Y' AND oga09 IN ('2','4','6','7')  #No.FUN-610057	#MOD-990233
      SELECT SUM(ogb12) INTO tot3 FROM ogb_file, oga_file
          WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32 AND ogb01=oga01
            AND ogb04=b_ogb.ogb04 
            AND ((oga09 IN ('1','5') AND (oga011 IS NULL OR oga011=' ')
                                       AND ogaconf='Y')
             #-----MOD-AB0151---------
             #OR (oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
             #              AND oga011 IN (SELECT oga01 FROM oga_file,ogb_file
             #                            WHERE ogb31=b_ogb.ogb31
             #                              AND ogb32=b_ogb.ogb32
             #                              AND ogb01=oga01 AND ogaconf='N'))
             #-----END MOD-AB0151-----
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                                         AND ogaconf='Y' AND ogapost='N')    
              OR (oga09 IN ('2','4','6') AND (oga011 IS NULL OR oga011=' ')   #MOD-AB0151 add AND (oga011 IS NULL OR oga011=' ')
                                         AND ogaconf='Y' AND ogapost='Y' AND oga65='Y'
                         AND oga01 NOT IN(SELECT oga011 FROM oga_file,ogb_file
                                            WHERE ogb31=b_ogb.ogb31
                                              AND ogb32=b_ogb.ogb32
                                              AND ogb01=oga01
                                              AND ogaconf='Y'
                                              AND ogapost='Y'
                                              AND oga09='8')))  
         #-----MOD-AB0151---------
         IF cl_null(tot3) THEN LET tot3 = 0 END IF
         SELECT SUM(ogb12) INTO tot5 FROM ogb_file, oga_file
           WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32 AND ogb01=oga01
             AND ogb04=b_ogb.ogb04 
             AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         IF cl_null(tot5) THEN LET tot5 = 0 END IF
         DECLARE p650_curs CURSOR FOR 
           SELECT DISTINCT oga011 FROM ogb_file, oga_file
             WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32 AND ogb01=oga01
               AND ogb04=b_ogb.ogb04 
               AND oga09 IN ('1','5') AND oga011 IS NOT NULL AND oga011!=' '
         FOREACH p650_curs INTO l_oga011
           SELECT SUM(ogb12) INTO tot6 FROM ogb_file, oga_file
             WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32 AND ogb01=oga01
               AND ogb04=b_ogb.ogb04 
               AND oga09 IN ('2','4','6') 
               AND oga01 = l_oga011 
               AND ((ogapost = 'Y' AND oga65='N')
                   OR ( oga65='Y' AND 
                        oga01 IN (SELECT oga011 FROM oga_file,ogb_file
                                       WHERE ogb31=b_ogb.ogb31
                                         AND ogb32=b_ogb.ogb32
                                         AND ogb01=oga01
                                         AND ogaconf='Y'
                                         AND ogapost='Y'
                                         AND oga09='8')))  
           IF cl_null(tot6) THEN LET tot6 = 0 END IF
           LET tot5 = tot5 - tot6 
           #LET tot3 = tot3 + tot5   #MOD-AC0257
         END FOREACH
         LET tot3 = tot3 + tot5   #MOD-AC0257
               #MOD-D70030 mark begin-----------------
      #-----END MOD-AB0151-----
#      SELECT SUM(ogb12) INTO tot1 FROM ogb_file,oga_file
#          WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32
#            AND ogb04=b_ogb.ogb04 
#           #AND ogb1005 = '1'                                   #TQC-B10066
#            AND (ogb1005 = '1' OR (ogb1005='2' AND ogb03<9001)) #TQC-B10066
#            AND ogb01=oga01
#            AND ((oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y') # AND oga65='N') 
#              OR (oga09='8' AND ogaconf='Y' AND ogapost='Y'))
      #-----END MOD-A50076----- 
            #MOD-D70030 mark end-----------------
#MOD-D70030 add begin----------
	   SELECT SUM(ogb12) INTO tot1 FROM ogb_file,oga_file
	     WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32
	       AND ogb04=b_ogb.ogb04 
               AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
               AND ogb01=oga01
               AND (oga09 IN ('2','4','6','A') AND ogaconf='Y' AND ogapost='Y') 
      IF g_oga.oga09='8' THEN
   	   SELECT SUM(ogb52) INTO tot1_t FROM ogb_file,oga_file
   	     WHERE ogb31=b_ogb.ogb31 AND ogb32=b_ogb.ogb32
   	       AND ogb04=b_ogb.ogb04 
                  AND (ogb1005 = '1' OR (ogb1005='2' OR ogb03<9001))
                  AND ogb01=oga01    
                  AND oga09='8' AND ogaconf='Y' AND ogapost='Y' 
      END IF
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
      IF cl_null(tot1_t) THEN LET tot1_t = 0 END IF         
      IF g_oga.oga09='8' THEN
         LET  tot1 = tot1 - tot1_t  #出货量 - 签退量 = 实际出货量
      END IF
#MOD-D70030 add end---------------- 
      IF cl_null(tot3) THEN LET tot3 = 0 END IF
 
      IF cl_null(tot1) THEN LET tot1 = 0 END IF
 
      SELECT SUM(ogb12) INTO l_tot4 FROM ogb_file,oga_file
         #CHI-AC0034 mod --start--
         #WHERE ogb31=l_ogb.ogb31
         #  AND ogb32=l_ogb.ogb32
         #  AND ogb04=l_ogb.ogb04
          WHERE ogb31=b_ogb.ogb31
            AND ogb32=b_ogb.ogb32
            AND ogb04=b_ogb.ogb04
         #CHI-AC0034 mod --end--
            AND ogb01=oga01 AND oga00='B'
            AND ogaconf='Y'
            AND ogapost='Y'  
      IF cl_null(l_tot4) THEN LET l_tot4 = 0 END IF
 
      UPDATE oeb_file SET oeb23 = tot3,
                          oeb24 = tot1,
                          oeb29 = l_tot4   #No.TQC-8C0027
          WHERE oeb01 = b_ogb.ogb31 AND oeb03 = b_ogb.ogb32
      IF STATUS OR SQLCA.SQLCODE THEN
         CALL cl_err3("upd","oeb_file",b_ogb.ogb31,b_ogb.ogb32,STATUS,"","upd oeb24",1)   #No.FUN-660167
         LET g_success = 'N' RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd oeb24','axm-176',1) LET g_success = 'N' RETURN
      END IF
 
      #如為借貨償價出貨單
      IF g_oga.oga00 = "B" THEN 
         #抓出原借貨訂單單號
         SELECT oea12,oeb71 INTO l_oea12,l_oeb71 FROM oea_file,oeb_file 
          WHERE oeb01 = b_ogb.ogb31
            AND oeb03 = b_ogb.ogb32
            AND oea01 = oeb01
        
         #抓出原償價數量
         SELECT oeb29 INTO l_oeb29 from oeb_file
          WHERE oeb01 = l_oea12 
            AND oeb03 = l_oeb71
        
         IF cl_null(l_oeb29) THEN
            LET l_oeb29 = 0
         END IF
        
         UPDATE oeb_file SET oeb29 = l_oeb29 - b_ogb.ogb12 
          WHERE oeb01 = l_oea12 
            AND oeb03 = l_oeb71
         IF STATUS THEN
            CALL cl_err3("upd","oeb_file",l_oea12,l_oeb71,SQLCA.sqlcode,"","upd oeb29",1)  #No.FUN-670008
            LET g_success = 'N' RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err('upd oeb29','axm-134',1) LET g_success = 'N' RETURN
         END IF
        #業務額度在借貨出貨庫存扣帳時並不會異動,所以過帳還原時也不需異動
        #業務額度在借貨償價庫存扣帳時會將業務額度加回,所以過帳還原時必須要異動回來
        #其他項目,像是一般訂單出貨單必不會異動業務額度,所以不過帳還原時也不需異動
        #CHI-C90032 add START
           LET l_oea61 = g_oga.oga24*b_ogb.ogb14
           CALL cl_digcut(l_oea61,g_azi04) RETURNING l_oea61
           SELECT ocn03,ocn04 INTO l_ocn03,l_ocn04 FROM ocn_file
            WHERE ocn01 = g_oga.oga14

           LET l_ocn03 = l_ocn03+l_oea61
           LET l_ocn04 = l_ocn04-l_oea61

           UPDATE ocn_file SET ocn03 = l_ocn03,
                               ocn04 = l_ocn04
            WHERE ocn01 = g_oga.oga14
        #CHI-C90032 add END
      END IF
 
      # update 出貨金額 (oea62) for prog:axmq420 ----------
      SELECT SUM(oeb24*oeb13) INTO l_amount FROM oeb_file
          WHERE oeb01 = b_ogb.ogb31
      IF cl_null(l_amount) THEN LET l_amount=0 END IF
      UPDATE oea_file SET oea62=l_amount
       WHERE oea01=b_ogb.ogb31
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","oea_file",b_ogb.ogb31,"",status,"","upd oea62",1)   #No.FUN-660167
         LET g_success = 'N' RETURN
      END IF
 
      #更新已備置量 no.7182
     #FUN-AC0074--begin--mod-----
      CALL s_updsie_unsie(b_ogb.ogb01,b_ogb.ogb03,'2') #FUN-AC0074
     #SELECT oeb04,oeb05_fac,oeb12,oeb19,oeb24,oeb25,oeb26,oeb905 INTO l_oeb.*
     #  FROM oeb_file WHERE oeb01=b_ogb.ogb31 AND oeb03=b_ogb.ogb32
     #IF l_oeb.oeb19 = 'Y' THEN
     #   IF l_oeb.oeb905 >= b_ogb.ogb12 THEN
     #      LET l_oeb.oeb905=l_oeb.oeb905+b_ogb.ogb12
     #   ELSE
     #      LET l_oeb.oeb905=l_oeb.oeb12-l_oeb.oeb24+l_oeb.oeb25-l_oeb.oeb26 #未交量
     #   END IF
 
     #   #備置量不可大於可用庫存量
     #   ##可用庫存量
     # #  SELECT ima262 INTO l_ima262 FROM ima_file #FUN-A20044
     # #   WHERE ima01 = l_oeb.oeb04
     # #  IF cl_null(l_ima262) THEN LET l_ima262 = 0 END IF       #FUN-A20044
     #       CALL s_getstock(l_oeb.oeb04,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 
     #   ##備置量
     #   SELECT SUM(oeb905*oeb05_fac) INTO l_oeb.oeb12 FROM oeb_file
     #    WHERE oeb04 = l_oeb.oeb04
     #      AND (oeb01 != b_ogb.ogb31 OR oeb03 != b_ogb.ogb32)
     #      AND oeb70 = 'N'
     #   IF cl_null(l_oeb.oeb12) THEN LET l_oeb.oeb12 = 0 END IF
 
     #  # LET l_qoh = l_ima262 - l_oeb.oeb12 #FUN-A20044
     #   LET l_qoh = l_avl_stk - l_oeb.oeb12 #FUN-A20044
 
     #   IF l_qoh < l_oeb.oeb905 THEN  #庫存不足
     #      LET l_oeb.oeb905 = 0
     #   END IF
 
     #   UPDATE oeb_file SET oeb905 = l_oeb.oeb905
     #    WHERE oeb01 = b_ogb.ogb31
     #      AND oeb03 = b_ogb.ogb32
     #   IF STATUS THEN
     #      CALL cl_err3("upd","oeb_file",b_ogb.ogb31,b_ogb.ogb32,STATUS,"","upd oeb905",1)   #No.FUN-660167
     #      LET g_success = 'N' RETURN
     #   END IF
     #FUN-AC0074--end--mod------
     #END IF
   END IF
END FUNCTION
 
FUNCTION p650_upd_imgg(p_imgg00,p_imgg02,p_imgg03,p_imgg04,            
                       p_imgg09,p_imgg10,p_imgg211,p_no)
 DEFINE p_imgg00   LIKE imgg_file.imgg00,                                       
        p_imgg02   LIKE imgg_file.imgg02,                                       
        p_imgg03   LIKE imgg_file.imgg03,                                       
        p_imgg04   LIKE imgg_file.imgg04,                                       
        p_imgg09   LIKE imgg_file.imgg09,                                       
        p_imgg10   LIKE imgg_file.imgg10,                                       
        p_imgg211  LIKE imgg_file.imgg211,                                       
        p_no       LIKE type_file.chr1,     #No.FUN-680137  VARCHAR(1)
        l_ima25    LIKE ima_file.ima25,                                         
        l_ima906   LIKE ima_file.ima906,                                         
        l_imgg21   LIKE imgg_file.imgg21

   CALL ui.Interface.refresh()                                                  
                                                                                
   LET g_forupd_sql =                                                           
       "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",                                          
       "  WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
       "    AND imgg09= ? FOR UPDATE "     #FUN-560043                         
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE imgg_lock CURSOR FROM g_forupd_sql                                   
                                                                                
   OPEN imgg_lock USING b_ogb.ogb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN                                                               
      CALL cl_err("OPEN imgg_lock:", STATUS, 1)                                 
      LET g_success='N'                                                         
      CLOSE imgg_lock                                                           
      RETURN                                                                    
   END IF                                                                       

   FETCH imgg_lock INTO b_ogb.ogb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09
   IF STATUS THEN                                                               
      CALL cl_err('lock imgg fail',STATUS,1)                                    
      LET g_success='N'                                                         
      CLOSE imgg_lock                                                           
      RETURN                                                                    
   END IF                 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=b_ogb.ogb04  
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN                                    
       CALL s_errmsg("ima01",b_ogb.ogb04,"SEL ima_file",SQLCA.sqlcode,1)               #No.FUN-710046
       LET g_success = 'N' RETURN                                               
    END IF                                                                      
                                                                                
    CALL s_umfchk(b_ogb.ogb04,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21                                              
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN                                                           
       CALL s_errmsg('','','',"mfg3075",1)   #No.FUN-710046                                 
       LET g_success = 'N' RETURN                                               
    END IF                                                                      
                                                                                
   CALL s_upimgg(b_ogb.ogb04,p_imgg02,p_imgg03,p_imgg04,p_imgg09,+1,p_imgg10,g_oga.oga02,   #FUN-8C0084                        
          '','','','','','','','','','',l_imgg21,'','','','','','','',p_imgg211)
   IF g_success = 'N' THEN                                                      
      CALL s_errmsg('','',"u_upimgg(+1)","9050",0)  #No.FUN-710046
      RETURN                                
   END IF    
                                                                                
END FUNCTION
 
FUNCTION p650_tlff(p_type) #------------------------------------ Update tlf_file        #No:FUN-BB0081
   DEFINE p_type  LIKE type_file.chr1   #No:FUN-BB0081 1表多單位多倉儲

    MESSAGE "d_tlff!"                                                            
    CALL ui.Interface.refresh()        
    IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
    ELSE                                                                                     #FUN-A90049                                         
       #-----No:FUN-BB0081-----
       IF p_type = "1" THEN
          DELETE FROM tlff_file                                                        
           WHERE tlff02=50      #No:FUN-BB0081
             AND tlff026=g_oga.oga01 #參考單  (出貨單號)                         
             AND tlff027=b_ogb.ogb03 #出貨項次                                   
             AND tlff06 =g_oga.oga02 #出貨日期                                   
       ELSE
       #-----No:FUN-BB0081 END-----
    DELETE FROM tlff_file                                                        
           WHERE tlff01 =b_ogb.ogb04 AND tlff02=50                                
             AND tlff026=g_oga.oga01 #參考單  (出貨單號)                         
             AND tlff027=b_ogb.ogb03 #出貨項次                                   
             AND tlff06 =g_oga.oga02 #出貨日期                                   
       END IF      #No:FUN-BB0081
    IF STATUS OR SQLCA.SQLCODE THEN                                             
       LET g_showmsg=b_ogb.ogb04,"/",g_oga.oga01,"/",b_ogb.ogb03,"/",g_oga.oga02    #No.FUN-710046
       CALL s_errmsg("tlff01,tlff026,tlff027,tlff06",g_showmsg,"DEL tlff_file",SQLCA.sqlcode,1)   #No.FUN-710046
       LET g_success='N' RETURN             
    END IF                                                                      
    IF SQLCA.SQLERRD[3]=0 THEN                                                  
       LET g_showmsg=b_ogb.ogb04,"/",g_oga.oga01,"/",b_ogb.ogb03,"/",g_oga.oga02    #No.FUN-710046
       CALL s_errmsg("tlff01,tlff026,tlff027,tlff06",g_showmsg,"DEL tlff_file","axm-176",1)   #No.FUN-710046
       LET g_success='N' RETURN              #No.FUN-710046
    END IF                                                                                  
    END IF                                                                                 #FUN=A90049       
END FUNCTION   
 
FUNCTION p650_du(p_ware,p_loc,p_lot,p_unit2,p_fac2,p_qty2,p_unit1,p_fac1,p_qty1,p_flag) 
  DEFINE p_ware     LIKE img_file.img02
  DEFINE p_loc      LIKE img_file.img03
  DEFINE p_lot      LIKE img_file.img04
  DEFINE p_unit2    LIKE img_file.img09
  DEFINE p_fac2     LIKE img_file.img21
  DEFINE p_qty2     LIKE img_file.img10
  DEFINE p_unit1    LIKE img_file.img09
  DEFINE p_fac1     LIKE img_file.img21
  DEFINE p_qty1     LIKE img_file.img10
  DEFINE p_flag     LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
  DEFINE l_ima906   LIKE ima_file.ima906
 
    IF g_sma.sma115 = 'N' THEN RETURN END IF
    LET l_ima906 = NULL
    SELECT ima906 INTO l_ima906 FROM ima_file
     WHERE ima01=b_ogb.ogb04
    IF l_ima906 IS NULL OR l_ima906 = '1' THEN RETURN END IF
    IF l_ima906 = '2' THEN
       IF cl_null(p_qty2) THEN LET p_qty2=0  END IF #MOD-7A0001 add
       IF NOT cl_null(p_unit2) AND p_qty2<>0 THEN   #MOD-7A0001 modify p_qry2
          CALL p650_upd_imgg('1',p_ware,p_loc,p_lot,
                             p_unit2,p_qty2,p_fac2,'2') 
          IF g_success='N' THEN RETURN END IF
       END IF
       IF NOT cl_null(p_unit1) THEN
          CALL p650_upd_imgg('1',p_ware,p_loc,p_lot,
                             p_unit1,p_qty1,p_fac1,'1')
          IF g_success='N' THEN RETURN END IF
       END IF
       IF p_flag = '2' THEN
          CALL p650_tlff('2')   #No:FUN-BB0081
          IF g_success='N' THEN RETURN END IF
       END IF
    END IF
    IF l_ima906 = '3' THEN
       IF NOT cl_null(p_unit2) THEN
          CALL p650_upd_imgg('2',p_ware,p_loc,p_lot,
                             p_unit2,p_qty2,p_fac2,'2') 
          IF g_success='N' THEN RETURN END IF
       END IF
       IF p_flag = '2' THEN
          CALL p650_tlff('2')   #No:FUN-BB0081
          IF g_success='N' THEN RETURN END IF
       END IF
    END IF
END FUNCTION
 
FUNCTION p650_u2_tlff() #for 境外倉-------------------------- delete tlff_file
    DEFINE l_ima906   LIKE ima_file.ima906
    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01=b_ogb.ogb04
    IF l_ima906 IS NULL OR l_ima906='1' THEN RETURN END IF
    MESSAGE "d_tlff!"
    CALL ui.Interface.refresh()
    IF s_joint_venture( b_ogb.ogb04 ,g_plant) OR NOT s_internal_item( b_ogb.ogb04,g_plant ) THEN    #FUN-A90049
    ELSE
    	IF cl_null(b_ogb.ogb31)  OR cl_null(b_ogb.ogb32) THEN #无订单出货单  
          DELETE FROM tlff_file
           WHERE tlff01 =b_ogb.ogb04 AND tlff02=724
             AND tlff036=b_ogb.ogb01
             AND tlff037=b_ogb.ogb03
             AND tlff026=b_ogb.ogb01 #參考單据(出貨單號)
             AND tlff027=b_ogb.ogb03 #出貨項次 
             AND tlff06 =g_oga.oga02 #出貨日期    	                                                                  
      ELSE     
          DELETE FROM tlff_file
           WHERE tlff01 =b_ogb.ogb04 AND tlff02=724
             AND tlff036=b_ogb.ogb01
             AND tlff037=b_ogb.ogb03
             AND tlff026=b_ogb.ogb31 #參考單据(出貨單號)
             AND tlff027=b_ogb.ogb32 #出貨項次 
             AND tlff06 =g_oga.oga02 #出貨日期
      END IF        
    IF STATUS OR SQLCA.SQLCODE THEN
       LET g_showmsg=b_ogb.ogb04,"/",b_ogb.ogb01,"/",b_ogb.ogb03,"/",b_ogb.ogb31,"/",b_ogb.ogb32,"/",g_oga.oga02     #No.FUN-710046
       CALL s_errmsg("tlff01,tlff036,tlff037,tlff026,tlff027,tlff06",g_showmsg,"DEL tlff_file",SQLCA.sqlcode,1)      #No.FUN-710046
       LET g_success='N' RETURN          
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('','',"DEL tlff(2):","axm-176",1) LET g_success='N' RETURN  #No.FUN-710046 
    END IF
    END IF                                                                           #FUN-A90049
END FUNCTION
 
FUNCTION p650_delimm()
   DEFINE l_msg   STRING
   DEFINE l_tot   LIKE oeb_file.oeb25
   DEFINE l_tot1  LIKE oeb_file.oeb25
   DEFINE l_ocn03 LIKE ocn_file.ocn03
   DEFINE l_ocn04 LIKE ocn_file.ocn04
 
   IF cl_null(g_oga.oga70) THEN
      CALL cl_err("g_oga.oga01","axm-145",1)
      LET g_success = "N"
      RETURN
   END IF
 
   BEGIN WORK
   LET g_success='Y'
 
   IF g_success = 'Y' THEN 
      COMMIT WORK  
      LET l_msg="aimp378 '",g_oga.oga70,"'"
      CALL cl_cmdrun_wait(l_msg)
      RETURN 
   ELSE 
      ROLLBACK WORK
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p650_icd_del_chk()
   DEFINE l_cntout  LIKE type_file.num5,
          l_cntin   LIKE type_file.num5,
          l_flag    LIKE type_file.num5,
          l_imm01   LIKE imm_file.imm01,
          l_cnt     LIKE type_file.num5
 
   IF cl_null(g_oga.oga70) THEN
      RETURN TRUE
   END IF
   LET l_imm01 = g_oga.oga70
   LET l_flag = 1
 
   #for ICD 扣帳還原時,需將調撥單的刻號/BIN資料拋轉回借貨單
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM idb_file
                  WHERE idb07 = l_imm01
   IF l_cnt > 0 THEN
      UPDATE idb_file SET idb07 = g_oga.oga01
                    WHERE idb07 = l_imm01
      IF SQLCA.sqlerrd[3] = 0 THEN
         RETURN FALSE
      END IF
   END IF
 
   LET l_cntin = 0
   LET l_cntout = 0
   SELECT COUNT(*) INTO l_cntout FROM idb_file
    WHERE idb07 = l_imm01
 
   SELECT COUNT(*) INTO l_cntin FROM ida_file
    WHERE ida07 = l_imm01
 
   IF l_cntin = 0 AND l_cntout = 0 THEN RETURN l_flag END IF #沒有刻號/BIN資料
   
   CASE
       WHEN l_cntout > 0 AND l_cntin = 0    #只有出庫資料
            CALL s_icdinout_del(-1,l_imm01,'','') RETURNING l_flag    #FUN-B80119--傳入p_plant參數''---
       WHEN l_cntout = 0 AND l_cntin > 0    #只有入庫資料
            CALL s_icdinout_del(1,l_imm01,'','') RETURNING l_flag     #FUN-B80119--傳入p_plant參數''---
       WHEN l_cntout > 0 AND l_cntin > 0    #出入庫資料
            CALL s_icdinout_del(-1,l_imm01,'','') RETURNING l_flag    #FUN-B80119--傳入p_plant參數''---
            IF l_flag THEN
               CALL s_icdinout_del(1,l_imm01,'','') RETURNING l_flag  #FUN-B80119--傳入p_plant參數''---
            END IF
   END CASE
   RETURN l_flag
END FUNCTION
#No:FUN-9C0071--------精簡程式-----


#MOD-CB0050 add begin-----------
FUNCTION p650_chk_ogb1001(p_ogb1001)
DEFINE p_ogb1001 LIKE ogb_file.ogb1001,
       l_cnt2    LIKE type_file.num5

   SELECT COUNT(*) INTO l_cnt2 FROM azf_file 
    WHERE azf01=p_ogb1001
    AND azf02 = '2' 
    AND azf08 = 'Y'   
    AND azfacti = 'Y' 
   RETURN l_cnt2
   
END FUNCTION     
#MOD-CB0050 add end-------------


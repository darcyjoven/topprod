# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: anmt750.4gl
# Descriptions...: 信用狀還本付款作業
# Date & Author..: 95/11/17 By Roger
# MODIFY.........: 99/05/10 By kammy 將傳票拋轉作業移至anmp400
#                                    將還原傳票作業移至anmp409
# MODIFY.........: 03/02/10 By Kitty 大幅度修改
# Modify.........: No:7875 03/08/21 By Kammy 呼叫自動取單號時應在 Transction中
# Modify.........: No:8615 03/10/31 By Kitty 產生應付票據 未加上利息金額
# Modify.........: No.MOD-480326 Kammy 支付銀行若修改過，出帳匯率須重新預設
# Modify.........: No.MOD-470476 04/08/26 By Nicola 輸竹完長貸編號後,本幣金額/利息等欄位要每個欄位ENTRY後才會有值,若直接按[確認]會照成相關欄位為零
# Modify.........: No.MOD-490146 04/09/13 By Yuna nnk08的開窗next field 皆寫nnk28,應為nnk08
# Modify.........: No.MOD-490291 04/09/15 By Kitty 1.加上確認的圖示 2.加狀態頁 3.
# Modify.........: No.MOD-490344 04/09/21 By Kitty Controlp 未加display
# Modify.........: No.MOD-4A0248 04/10/25 By Yuna QBE開窗開不出來
# Modify.........: No.FUN-4B0008 04/11/17 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4B0052 04/11/25 By Nicola 加入"匯率計算"功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-4C0063 04/12/09 By Nicola 權限控管修改
# Modify.........: No.FUN-4C0070 04/12/17 By pengu  匯率幣別欄位修改，與aoos010的aza17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.FUN-550057 05/05/28 By jackie 單據編號加大
# Modify ........: No.FUN-560002 05/06/03 By day  單據編號修改
# Modify.........: No.MOD-5A0022 05/10/20 By Smapmin 利息計算天數應為單頭之付款日期-單身的起息日
# Modify ........: No.TQC-5B0076 05/11/09 By Claire  excel匯出失效
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.MOD-5B0328 05/12/06 By Smapmin 執行"產生應付票據"時,未確認就不可執行未提示錯誤訊息
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.MOD-5C0143 06/01/20 By Smapmin 付款方式非支存,開票等欄位應不可異動
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.TQC-620046 06/03/06 By Smapmin 未還本幣直接以總金額-已還本幣的方式去計算
# Modify.........: No.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.MOD-630118 06/03/30 By Smapmin LET l_nmd.nmd19=g_nnk.nnk09
# Modify.........: No.FUN-640021 06/04/12 By Smapmin 若還款與實付原幣相同,仍然需要考慮匯差的存在
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.MOD-660048 06/06/13 By Smapmin 修改利息費用之幣別,匯率
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.TQC-610058 06/06/29 By Smapmin 修改背景執行參數傳遞
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-670060 06/08/02 By Ray 新增"直接拋轉總帳"功能
# Modify.........: No.FUN-670108 06/08/16 By Smapmin 利息費用(npq07f)=原幣應付利息(nnl15)/換匯標準(nnk23),幣別(npq24)為借款幣別
# Modify.........: No.TQC-680080 06/08/22 By Sarah p_flow流程訊息通知功能,加上OTHERWISE判斷漏改
# Modify.........: No.FUN-680088 06/08/28 By Ray 多帳套處理
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.MOD-690100 06/10/16 By Smapmin 開放原本被mark起來的列印功能
# Modify.........: No.CHI-6A0004 06/10/26 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改  
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-6A0011 06/11/12 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6B0030 06/11/14 By bnlent  單頭折疊功能修改
# Modify.........: No.MOD-6B0069 06/12/06 By Smapmin 修改幣別取位
# Modify.........: No.MOD-6C0067 06/12/12 By Smapmin 增加有效/無效功能
# Modify.........: No.FUN-710024 07/02/04 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730063 07/03/15 By Smapmin 回寫最後付息日
# Modify.........: No.FUN-730032 07/03/21 By Rayven 新增nme21,nme22,nme23,nme24
# Modify.........: No.MOD-740346 07/04/23 By Rayven 取消審核是報anm-043的錯卻還是能取消審核
#                                                   不使用網銀時不去判斷是否未轉
# Modify.........: No.TQC-750098 07/05/18 By Rayven nme24默認初始值給'9'
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-790091 07/09/17 By Mandy Primary Key的關係,原本SQLCA.sqlcode重複的錯誤碼-239，在informix不適用
# Modify.........: No.TQC-790126 O7/09/24 By destiny 修改查詢時狀態欄為灰色的BUG
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840003 O8/04/01 By Carol 還本確認時考慮nne08的設定回寫付息單號
# Modify.........: No.MOD-840009 O8/04/03 By Carol 分錄底稿產生時匯兌損益科目應考慮是否為多帳套
# Modify.........: No.MOD-840093 08/04/14 By Carol 依nnk23區分npq24,npq25的來源
# Modify.........: No.MOD-840278 08/04/21 By Smapmin 確認/取消確認,回寫利息暫估檔還息付款單號,要先判斷是否有該利息暫估檔
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.FUN-850038 08/05/12 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-850231 08/05/26 By Sarah 手續費產生分錄底稿時,LET g_npq.npq07=g_nnk.nnk17*g_nnk.nnk09,LET g_npq.npq25=g_nnk.nnk09
# Modify.........: No.MOD-870275 08/07/30 By Sarah 當最後一次還款時,還款本幣應為剩餘金額,當不是最後一次,則用原幣*匯率
# Modify.........: No.FUN-8A0086 08/10/22 By zhaijie添加LET g_success = 'N'
# Modify.........: No.CHI-8A0030 08/11/04 By Sarah 1.輸入單身單據號碼時,依種類檢核nne04/nng04是否與單頭nnk05一致
#                                                  2.單據號碼開窗時應過濾其信貸銀行與單頭信貸銀行相同
# Modify.........: No.MOD-8C0138 08/12/15 By Sarah 當種類為1.短借時,date1的預設值應先抓取anmt710的nne33,若nne33為null時才預設為nne111
#                                                  當種類為2.長貸時,date1的預設值應先抓取anmt720的nng26,若nng26為null時才預設為nng101
# Modify.........: No.MOD-8C0225 08/12/25 By Sarah 底稿產生時,若nmz52設定為Y時,應將該暫估利息併入應付利息
# Modify.........: No.MOD-8C0251 08/12/31 By Sarah 利息計算的方式應是算頭不算尾,第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
# Modify.........: No.FUN-860040 09/01/14 By jan 直接拋轉總帳時，(來源單號)沒有取得值 
# Modify.........: No.MOD-940328 09/04/24 By lilingyu 無效資料不可再修改單身
# Modify.........: No.MOD-940333 09/04/24 By lilingyu 1.DISPLAY BY NAME 少了g_nnk.nnkacti
# Modify..............................................2.cl_set_field_pic()少了g_nnk.nnkacti
# Modify.........: No.FUN-940036 09/04/07 By jan 當其單據性質之【傳票單別】非空白者,即可有ACTION 【拋轉總帳】及【傳票拋轉還原】功能
# Modify.........: No.TQC-940177 09/05/12 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.TQC-960333 09/06/23 By hongmei FOREACH t750_g_gl_c1 后的SQL,撈nnl03,nnl04時，where條件加nnl02這個KEY
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980106 09/08/20 By mike 在INSERT INTO nme_file前,有g_nme.nme21~g_nme.nme25,請改成l_nme.nme21~l_nme.nme25  
# Modify.........: No.MOD-980222 09/08/26 By mike 應在INSERT INTO npq_file VALUES (g_npq.*)之前先判斷g_npq.npq07是否為零，          
#                                                 若為零不可做insert into npq_file，并將npq.npq02-1                                 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/02 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.MOD-980146 09/09/03 By sabrina FUNCTION t750_ins_nme()應寫入現金變動碼nme14
# Modify.........: No.TQC-990013 09/09/04 By lilingyu l_grup_lc這個變量根本就沒有用到,mark掉t750_x這個sql
# Modify.........: No.FUN-980025 09/09/23 By dxfwo GP集團架構修改,sub相關參數
# Modify.........: No.MOD-990157 09/09/30 By mike 在新增時,若銀行類別(nnk07)為1:支存, 則開票單號nnk21應為必key欄位,                 
# Modify.........: No:TQC-9B0074 09/11/17 By wujie 手续费栏位不能为负数
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No:CHI-A10014 10/01/19 By sabrina 若aza26='0'且幣別=aza17時，利息以365天計算，其餘則用360天計算
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.MOD-A20096 10/02/26 By sabrina 單據確認後不可做無效
# Modify.........: No.MOD-A30016 10/03/03 BY sabrina 拋轉傳票時傳遞user採用"0"到"z"的方式 
# Modify.........: No.MOD-A40137 10/04/22 BY sabrina 中長期還款確認時還息方式欄位抓錯
# Modify.........: No:CHI-A40018 10/06/14 By Summer 確認段檢核npq03=nnk10時,金額與nnk14比對是否一致,否則提示錯誤訊息(aap-065)
# Modify.........: No.FUN-A50102 10/07/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:MOD-A80101 10/08/12 By Dido 手續費寫入 nme08 時須再取位 
# Modify.........: No:MOD-A90009 10/09/02 By Dido 短長貸皆須計算利率 
# Modify.........: No:MOD-AA0072 10/10/13 By Dido 分錄利息費用本幣改用原幣差異*nnk09取得,差額歸入nnk16 
# Modify.........: No:CHI-890030 10/11/26 By Summer 若nnl15,nnl17均為0時,無須更新nnm13
# Modify.........: No.MOD-AC0073 10/12/09 By Dido 立即確認時,確認圖示調整
# Modify.........: No.FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善
# Modify.........: No:MOD-B20031 11/02/11 By Dido 確認段檢核金額時,應相同科目合計方式計算
# Modify.........: No:MOD-B30022 11/03/02 By Dido nnk07 預設值應為新增時使用 
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:CHI-B40029 11/04/19 By Dido 融資單需控卡不可存在應付票據中 
# Modify.........: No:MOD-B40256 11/04/28 By Dido 異動 nnl15 後產生分錄金額有誤;帳款與分錄檢核需考慮手續費
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No.FUN-B50090 11/05/16 By suncx 財務關帳日期加嚴控管修正
# Modify.........: No.FUN-B50063 11/05/26 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:MOD-B60157 11/06/20 By Dido 增加指定貸方金額做檢核 
# Modify.........: No:MOD-B70044 11/07/06 By Dido 顯示欄位無須取位
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No:MOD-B70249 11/07/27 By Polly修正錯誤訊息，改用anm1015提示。
# Modify.........: No.FUN-B80067 11/08/05 By fengrui  程式撰寫規範修正
# Modify.........: No:MOD-B80149 11/08/16 By Polly 修改l_rate型態
# Modify.........: No.MOD-B90077 11/09/09 By Polly nnl04檢核是否重複打單，排除已作廢單據
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  
# Modify.........: No.MOD-B90165 11/09/21 By Polly t750_show() 中取消s_check_no檢核
# Modify.........: No.MOD-B90135 11/09/23 By Polly 調整t750_upd_nne()裡l_nne33型態
# Modify.........: No.MOD-B90258 11/09/30 By Dido 若暫估利息大於還本利息時,差異金額不須計算 
# Modify.........: No.MOD-BA0015 11/10/06 By Dido npq04 需先清空
# Modify.........: No.MOD-BB0214 11/11/21 By Polly 調整未回寫nng26, 造成執行暫估利息從借款起始日開始起算
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C20057 12/02/07 By Polly 還本還息確認增加付款單號日期判斷
# Modify.........: No:MOD-C20237 12/03/01 By Polly 調整利息暫估差異應直接計算至利息費用中
# Modify.........: No:MOD-C30047 12/03/05 By Polly 調整回寫付息單號條件，抓取前月或本月暫估資料
# Modify.........: No:CHI-C30003 12/05/09 By Dido 於寫入銀存異動前增加檢核是否存在 nmd_file 
# Modify.........: No.CHI-C30002 12/05/23 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:MOD-C50167 12/05/25 By Polly date1 預設值抓取 nne33/nng26 時要多加1天
# Modify.........: No:MOD-C50186 12/05/28 By Polly 回寫單號增加判斷若為null才回寫
# Modify.........: No:MOD-C50232 12/06/01 By Polly 取消確認時需重新抓取nnj06回寫nne33(短貸)或nng26(中長貸)
# Modify.........: No.CHI-C30107 12/06/11 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:FUN-C30085 12/06/29 By lixiang 串CR報表改GR報表
# Modify.........: No:TQC-C70057 12/07/20 By lujh 【拋轉憑證】的單別輸入資料後建議自動產生分錄底稿，不需要手動點擊【產生分錄底稿】功能鈕後才產生分錄底稿。
# Modify.........: No.CHI-C90052 12/10/02 By Lori 取消確認需在傳票拋轉還原成功後才執行
# Modify.........: No.MOD-CA0029 12/10/04 By Polly 參考Anmt740方式，取消開票單號nnk21應為必key欄位
# Modify.........: No.MOD-CA0037 12/10/22 By Polly 起息日期抓取值調整
# Modify.........: No:CHI-C80041 12/12/27 By bart 1.增加作廢功能 2.刪除單頭時，一併刪除相關table
# Modify.........: No:MOD-C90186 13/03/11 By apo 提早還款不一定會有暫估利息的單據，UPDATE nmm13時，先判斷是否有nnm的資料
# Modify.........: No:MOD-CA0191 13/03/15 By Polly 暫估利息次月回轉，需產生折價分錄
# Modify.........: No:FUN-D30032 13/04/03 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.MOD-CC0064 13/04/07 By apo 當nnk07為2,3時，可以寫入與刪除nme_file
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_nnk                RECORD LIKE nnk_file.*,
    g_nnk_t              RECORD LIKE nnk_file.*,
    g_nnk_o              RECORD LIKE nnk_file.*,
    g_nnk01_t            LIKE nnk_file.nnk01,
    b_nnl                RECORD LIKE nnl_file.*,
    g_nne                RECORD LIKE nne_file.*,
    g_nng                RECORD LIKE nng_file.*,
    g_nmd                RECORD LIKE nmd_file.*,
    g_nme                RECORD LIKE nme_file.*,
    g_nms                RECORD LIKE nms_file.*,
    g_npp                RECORD LIKE npp_file.*,
    g_npq                RECORD LIKE npq_file.*,
     g_wc,g_wc2,g_sql    string,                #No.FUN-580092 HCN
    g_statu              LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(01) # 是否從新賦予等級
    g_dbs_gl             LIKE type_file.chr21,  #No.FUN-680107 VARCHAR(21)
    g_plant_gl           LIKE type_file.chr10,  #No.FUN-980020
    b_date               LIKE type_file.dat,    #No.FUN-680107 DATE
    nm_no_b,nm_no_e      LIKE type_file.num10,  #No.FUN-680107 INTEGER
    gl_no_b,gl_no_e      LIKE apk_file.apk28,   #No.FUN-680107 VARCHAR(12)
    ddd,yy,mm            LIKE type_file.num5,   #No.FUN-680107 SMALLINT
    g_nnl           DYNAMIC ARRAY OF RECORD     #程式變數(Program Variables)
        nnl02            LIKE nnl_file.nnl02,
        nnl03            LIKE nnl_file.nnl03,
        nnl04            LIKE nnl_file.nnl04,
        exrate           LIKE nne_file.nne17,
        nnl18            LIKE nnl_file.nnl18,
        date1            LIKE type_file.dat,    #No.FUN-680107 DATE
        date2            LIKE type_file.dat,    #No.FUN-680107 DATE
        nnl11            LIKE nnl_file.nnl11,
        nnl13            LIKE nnl_file.nnl13,
        nnl12            LIKE nnl_file.nnl12,
        nnl14            LIKE nnl_file.nnl14,
        nnl15            LIKE nnl_file.nnl15,
        nnl17            LIKE nnl_file.nnl17,
        nnl16            LIKE nnl_file.nnl16,
        nnlud01          LIKE nnl_file.nnlud01,
        nnlud02          LIKE nnl_file.nnlud02,
        nnlud03          LIKE nnl_file.nnlud03,
        nnlud04          LIKE nnl_file.nnlud04,
        nnlud05          LIKE nnl_file.nnlud05,
        nnlud06          LIKE nnl_file.nnlud06,
        nnlud07          LIKE nnl_file.nnlud07,
        nnlud08          LIKE nnl_file.nnlud08,
        nnlud09          LIKE nnl_file.nnlud09,
        nnlud10          LIKE nnl_file.nnlud10,
        nnlud11          LIKE nnl_file.nnlud11,
        nnlud12          LIKE nnl_file.nnlud12,
        nnlud13          LIKE nnl_file.nnlud13,
        nnlud14          LIKE nnl_file.nnlud14,
        nnlud15          LIKE nnl_file.nnlud15
                    END RECORD,
    g_nnl_t         RECORD                      #程式變數 (舊值)
        nnl02            LIKE nnl_file.nnl02,
        nnl03            LIKE nnl_file.nnl03,
        nnl04            LIKE nnl_file.nnl04,
        exrate           LIKE nne_file.nne17,
        nnl18            LIKE nnl_file.nnl18,
        date1            LIKE type_file.dat,    #No.FUN-680107 DATE
        date2            LIKE type_file.dat,    #No.FUN-680107 DATE
        nnl11            LIKE nnl_file.nnl11,
        nnl13            LIKE nnl_file.nnl13,
        nnl12            LIKE nnl_file.nnl12,
        nnl14            LIKE nnl_file.nnl14,
        nnl15            LIKE nnl_file.nnl15,
        nnl17            LIKE nnl_file.nnl17,
        nnl16            LIKE nnl_file.nnl16,
        nnlud01          LIKE nnl_file.nnlud01,
        nnlud02          LIKE nnl_file.nnlud02,
        nnlud03          LIKE nnl_file.nnlud03,
        nnlud04          LIKE nnl_file.nnlud04,
        nnlud05          LIKE nnl_file.nnlud05,
        nnlud06          LIKE nnl_file.nnlud06,
        nnlud07          LIKE nnl_file.nnlud07,
        nnlud08          LIKE nnl_file.nnlud08,
        nnlud09          LIKE nnl_file.nnlud09,
        nnlud10          LIKE nnl_file.nnlud10,
        nnlud11          LIKE nnl_file.nnlud11,
        nnlud12          LIKE nnl_file.nnlud12,
        nnlud13          LIKE nnl_file.nnlud13,
        nnlud14          LIKE nnl_file.nnlud14,
        nnlud15          LIKE nnl_file.nnlud15
                    END RECORD,
    g_buf                LIKE type_file.chr1000,#No.FUN-680107 VARCHAR(78)
    g_tot                LIKE type_file.num20_6,#No.FUN-4C0010  #No.FUN-680107 DECIMAL(20,6)
    g_rec_b              LIKE type_file.num5,   #單身筆數  #No.FUN-680107 SMALLINT
    l_ac                 LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680107 SMALLINT
#------for ora修改-------------------
DEFINE g_system          LIKE ooy_file.ooytype  #No.FUN-680107 VARCHAR(2) #TQC-840066
DEFINE g_N               LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_y               LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
#------for ora修改-------------------
 
DEFINE g_argv1           LIKE nnk_file.nnk01    #No.FUN-680107 VARCHAR(16) #單號 #TQC-630074
DEFINE g_argv2           STRING                 #指定執行的功能 #TQC-630074
DEFINE g_flag            LIKE type_file.chr1    #No.FUN-730032
DEFINE g_bookno1         LIKE aza_file.aza81    #No.FUN-730032
DEFINE g_bookno2         LIKE aza_file.aza82    #No.FUN-730032
DEFINE g_bookno3         LIKE aza_file.aza82    #No.FUN-730032
 
DEFINE g_forupd_sql      STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680107 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE   g_void          LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #No.MOD-490291
DEFINE   g_cnt           LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-680107 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
DEFINE   g_str           STRING                 #No.FUN-670060
DEFINE   g_wc_gl         STRING                 #No.FUN-670060
DEFINE   g_t1            LIKE oay_file.oayslip  #單別  #No.FUN-680107 VARCHAR(5)
 
 
 
DEFINE   g_row_count     LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   g_jump          LIKE type_file.num10   #No.FUN-680107 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_npq25           LIKE npq_file.npq25    #No.FUN-9A0036
DEFINE  g_aag44          LIKE aag_file.aag44    #FUN-D40118 add
MAIN
DEFINE         p_row,p_col     LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
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
 
   SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
   SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00 = '0'   #MOD-8C0225 add
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
 
   LET p_row = 1 LET p_col = 2
   OPEN WINDOW t750_w AT p_row,p_col WITH FORM "anm/42f/anmt750"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
    IF g_aza.aza63 = 'Y' THEN
       CALL cl_set_comp_visible("nnk101",TRUE)
    ELSE
       CALL cl_set_comp_visible("nnk101",FALSE)
    END IF
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv2
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t750_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t750_a()
            END IF
         OTHERWISE
            CALL t750_q()
      END CASE
   END IF
 
   CALL t750()
   CLOSE WINDOW t750_w
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0082
END MAIN
 
FUNCTION t750()
   LET g_plant_gl = g_nmz.nmz02p                     #FUN-980020
   LET g_plant_new=g_nmz.nmz02p
   CALL s_getdbs()
   LET g_dbs_gl=g_dbs_new
   INITIALIZE g_nnk.* TO NULL
   INITIALIZE g_nnk_t.* TO NULL
   INITIALIZE g_nnk_o.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM nnk_file WHERE nnk01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t750_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
   CALL t750_menu()
END FUNCTION
 
FUNCTION t750_cs()
DEFINE  lc_qbe_sn  LIKE gbm_file.gbm01    #No.FUN-580031  HCN
   CLEAR FORM
   CALL g_nnl.clear()
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF cl_null(g_argv1) THEN
   INITIALIZE g_nnk.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON
                nnk01, nnk02, nnk04, nnk05, nnk06, nnk09, nnk23,
                nnk07, nnk08, nnk21, nnkconf, nnkglno,
                nnk22, nnk17, nnk18, nnk19,
                nnk11, nnk13, nnk12, nnk14, nnk16,
                nnk10, nnk101      #No.FUN-680029
                ,nnkuser,nnkdate,nnkacti,nnkgrup,nnkmodu,         #No.TQC-790126
                nnkud01,nnkud02,nnkud03,nnkud04,nnkud05,
                nnkud06,nnkud07,nnkud08,nnkud09,nnkud10,
                nnkud11,nnkud12,nnkud13,nnkud14,nnkud15
                  BEFORE CONSTRUCT
                     CALL cl_qbe_init()
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nnk01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nnk"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnk01
                  NEXT FIELD nnk01
               WHEN INFIELD(nnk05) # Dept CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_alg"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnk05
               WHEN INFIELD(nnk06) # Dept CODE
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnk06
               WHEN INFIELD(nnk10) # Dept CODE
                  CALL s_get_bookno1(YEAR(g_nnk.nnk02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020 
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nnk.nnk10,'23',g_bookno1)     #No.FUN-980025  
                  RETURNING g_nnk.nnk10
                  DISPLAY BY NAME g_nnk.nnk10
               WHEN INFIELD(nnk101)
                  CALL s_get_bookno1(YEAR(g_nnk.nnk02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2     #FUN-980020
                  CALL q_m_aag(TRUE,TRUE,g_plant_gl,g_nnk.nnk101,'23',g_bookno2)     #No.FUN-980025
                  RETURNING g_nnk.nnk101
                  DISPLAY BY NAME g_nnk.nnk101
               WHEN INFIELD(nnk21)
                  LET g_t1 = s_get_doc_no(g_nnk.nnk21)       #No.FUN-550057
                  CALL q_nmy(TRUE,TRUE,g_t1,'1','ANM') RETURNING g_t1 #TQC-670008
                  LET g_nnk.nnk21= g_t1    #No.FUN-550057
                  DISPLAY BY NAME g_nnk.nnk21 NEXT FIELD nnk21
               WHEN INFIELD(nnk18) #扣除手續銀行
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nma"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnk18
               WHEN INFIELD(nnk19) #現金變動碼值
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nml"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO g_nnk.nnk19
               WHEN INFIELD(nnk22) #銀行異動碼
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_nmc"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnk22
                  NEXT FIELD nnk22
               WHEN INFIELD(nnk08) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO nnk08
                   NEXT FIELD nnk08   #No.MOD-490146
               WHEN INFIELD(nnk04) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_azi"
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_nnk.nnk04
                  DISPLAY BY NAME g_nnk.nnk04
                  NEXT FIELD nnk04
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
      CONSTRUCT g_wc2 ON nnl02,nnl03,nnl04,nnl18
                         ,nnlud01,nnlud02,nnlud03,nnlud04,nnlud05
                         ,nnlud06,nnlud07,nnlud08,nnlud09,nnlud10
                         ,nnlud11,nnlud12,nnlud13,nnlud14,nnlud15
              FROM s_nnl[1].nnl02,s_nnl[1].nnl03,s_nnl[1].nnl04,s_nnl[1].nnl18
                   ,s_nnl[1].nnlud01,s_nnl[1].nnlud02,s_nnl[1].nnlud03
                   ,s_nnl[1].nnlud04,s_nnl[1].nnlud05,s_nnl[1].nnlud06
                   ,s_nnl[1].nnlud07,s_nnl[1].nnlud08,s_nnl[1].nnlud09
                   ,s_nnl[1].nnlud10,s_nnl[1].nnlud11,s_nnl[1].nnlud12
                   ,s_nnl[1].nnlud13,s_nnl[1].nnlud14,s_nnl[1].nnlud15
           BEFORE CONSTRUCT
              CALL cl_qbe_display_condition(lc_qbe_sn)
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(nnl04)
                  IF g_nnl[1].nnl03 = '1' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nne"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnl04
                     NEXT FIELD nnl04
                  ELSE
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_nng"
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO nnl04
                     NEXT FIELD nnl04
                  END IF
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
      
      
               ON ACTION qbe_save
                  CALL cl_qbe_save()
      END CONSTRUCT
      
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc =" nnk01 = '",g_argv1,"'"   
      LET g_wc2=" 1=1"
   END IF
 
 
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('nnkuser', 'nnkgrup')
 
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT nnk01 FROM nnk_file ",
                " WHERE ",g_wc CLIPPED, " ORDER BY nnk01"
   ELSE
      LET g_sql="SELECT nnk01 FROM nnk_file,nnl_file",
                " WHERE nnk01=nnl01 ",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " ORDER BY nnk01"
   END IF
   PREPARE t750_prepare FROM g_sql                # RUNTIME 編譯
   DECLARE t750_cs                                # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t750_prepare
   IF g_wc2=' 1=1' THEN
      LET g_sql="SELECT COUNT(*) FROM nnk_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT nnk01) FROM nnk_file,nnl_file",
                " WHERE nnk01=nnl01",
                "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
   PREPARE t750_precount FROM g_sql
   DECLARE t750_count CURSOR FOR t750_precount
END FUNCTION
 
FUNCTION t750_menu()
 
   WHILE TRUE
      CALL t750_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t750_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t750_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t750_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t750_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t750_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t750_out('o')
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "gen_n_p"
            CALL t750_g_np()
         WHEN "modify_n_p"
            LET g_msg="anmt100 '",g_nnk.nnk21,"'"
            CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
         WHEN "undo_n_p"
            IF cl_chk_act_auth() THEN
               CALL t750_del_np()
            END IF
         WHEN "gen_entry_sheet"
            CALL t750_g_gl(g_nnk.nnk01,'0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
               CALL t750_g_gl(g_nnk.nnk01,'1')
            END IF
         WHEN "maintain_entry_sheet"
            CALL s_fsgl('NM',7,g_nnk.nnk01,0,g_nmz.nmz02b,0,g_nnk.nnkconf,'0',g_nmz.nmz02p)   #FUN-670047      #No.FUN-680088
            CALL t750_npp02('0')  #No.+086 010502 by plum      #No.FUN-680088
         WHEN "maintain_entry_sheet2"
            CALL s_fsgl('NM',7,g_nnk.nnk01,0,g_nmz.nmz02c,0,g_nnk.nnkconf,'1',g_nmz.nmz02p)
            CALL t750_npp02('1')
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t750_firm1()
                CALL cl_set_field_pic(g_nnk.nnkconf,"","","",g_void,g_nnk.nnkacti)          #MOD-940333 
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t750_firm2()
                CALL cl_set_field_pic(g_nnk.nnkconf,"","","",g_void,g_nnk.nnkacti)          #MOD-940333 
            END IF
        WHEN "carry_voucher"
           IF cl_chk_act_auth() THEN
              IF g_nnk.nnkconf ='Y'  THEN
                 CALL t750_carry_voucher()
               ELSE 
                  CALL cl_err('','atm-402',1)
              END IF
           END IF
        WHEN "undo_carry_voucher"
           IF cl_chk_act_auth() THEN
              IF g_nnk.nnkconf ='Y'  THEN
                 CALL t750_undo_carry_voucher() 
               ELSE 
                  CALL cl_err('','atm-403',1)
              END IF
           END IF
         WHEN "exporttoexcel"     #FUN-4B0008
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_nnl),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_nnk.nnk01 IS NOT NULL THEN
                 LET g_doc.column1 = "nnk01"
                 LET g_doc.value1 = g_nnk.nnk01
                 CALL cl_doc()
               END IF
         END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL t750_x()
               CALL cl_set_field_pic(g_nnk.nnkconf,"","","",g_void,g_nnk.nnkacti)   #MOD-940333 
            END IF
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               CALL t750_v()
               IF g_nnk.nnkconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_nnk.nnkconf,"","","",g_void,g_nnk.nnkacti)
            END IF
         #CHI-C80041---end 
      END CASE
   END WHILE
    CLOSE t750_cs
END FUNCTION
 
FUNCTION t750_a()
DEFINE li_result   LIKE type_file.num5     #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   IF s_anmshut(0) THEN RETURN END IF
   MESSAGE ""
   CLEAR FORM                                   # 清螢幕欄位內容
   CALL g_nnl.clear()
   INITIALIZE g_nnk.* LIKE nnk_file.*
   LET g_nnk_t.* = g_nnk.*
   LET g_nnk01_t = NULL
   LET g_nnk.nnk02 = g_today
   LET g_nnk.nnkconf = 'N'
   CALL cl_opmsg('a')
   WHILE TRUE
      LET g_nnk.nnk17   =0
      LET g_nnk.nnkacti ='Y'                   # 有效的資料
      LET g_nnk.nnkuser = g_user
      LET g_nnk.nnkoriu = g_user #FUN-980030
      LET g_nnk.nnkorig = g_grup #FUN-980030
      LET g_nnk.nnkgrup = g_grup               # 使用者所屬群
      LET g_nnk.nnkdate = g_today
      LET g_nnk.nnkinpd = g_today
      LET g_nnk.nnklegal= g_legal
 
      CALL t750_i("a")                         # 各欄位輸入
      IF INT_FLAG THEN                         # 若按了DEL鍵
         LET INT_FLAG = 0
         INITIALIZE g_nnk.* TO NULL
         CALL cl_err('',9001,0)
         CLEAR FORM
         CALL g_nnl.clear()
         EXIT WHILE
      END IF
      IF g_nnk.nnk01 IS NULL THEN              # KEY 不可空白
         CONTINUE WHILE
      END IF
      BEGIN WORK  #No.7875
        CALL s_auto_assign_no("anm",g_nnk.nnk01,g_nnk.nnk02,"7","nnk_file","nnk01","","","")
             RETURNING li_result,g_nnk.nnk01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_nnk.nnk01
      INSERT INTO nnk_file VALUES(g_nnk.*)     # DISK WRITE
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","nnk_file",g_nnk.nnk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148  #No.FUN-B80067---調整至回滾事務前---
         ROLLBACK WORK
         CONTINUE WHILE
      ELSE
         COMMIT WORK
         CALL cl_flow_notify(g_nnk.nnk01,'I')
         LET g_nnk_t.* = g_nnk.*               # 保存上筆資料
         SELECT nnk01 INTO g_nnk.nnk01 FROM nnk_file
                WHERE nnk01 = g_nnk.nnk01
      END IF
      CALL g_nnl.clear()
      LET g_rec_b=0
      CALL t750_b('0')
      IF g_nmy.nmydmy1 = 'Y' THEN
         CALL t750_firm1()
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION t750_i(p_cmd)
DEFINE
       p_cmd           LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入  #No.FUN-680107 VARCHAR(1)
       g_t1            LIKE oay_file.oayslip, #單別  #No.FUN-680107 VARCHAR(5)
       l_dept          LIKE type_file.chr20,  #No.FUN-680107 VARCHAR(10) #Dept
       l_amt           LIKE type_file.num20_6,#No.FUN-4C0010 #No.FUN-680107 DECIMAL(20,6)
       l_nma10         LIKE nma_file.nma10,
       l_nmc03         LIKE nmc_file.nmc03,   #No.MOD-490291
       l_n             LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE li_result       LIKE type_file.num5    #No.FUN-550057  #No.FUN-680107 SMALLINT
 
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME g_nnk.nnk01,g_nnk.nnk02,g_nnk.nnk04,g_nnk.nnk05,g_nnk.nnk06, g_nnk.nnkoriu,g_nnk.nnkorig,
                  g_nnk.nnk09,g_nnk.nnk23,g_nnk.nnk07,g_nnk.nnk08,
                  g_nnk.nnk21,g_nnk.nnkconf,g_nnk.nnkglno,g_nnk.nnk22,
                  g_nnk.nnk17,g_nnk.nnk18,g_nnk.nnk19,g_nnk.nnk11,
                  g_nnk.nnk13,g_nnk.nnk12,g_nnk.nnk14,g_nnk.nnk16,g_nnk.nnk10,g_nnk.nnk101,      #No.FUN-680088
                  g_nnk.nnkgrup,g_nnk.nnkuser,g_nnk.nnkdate,g_nnk.nnkmodu,   #No.MOD-490291
                  g_nnk.nnkud01,g_nnk.nnkud02,g_nnk.nnkud03,g_nnk.nnkud04,
                  g_nnk.nnkud05,g_nnk.nnkud06,g_nnk.nnkud07,g_nnk.nnkud08,
                  g_nnk.nnkud09,g_nnk.nnkud10,g_nnk.nnkud11,g_nnk.nnkud12,
                  g_nnk.nnkud13,g_nnk.nnkud14,g_nnk.nnkud15 
        WITHOUT DEFAULTS
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t750_set_entry(p_cmd)
           CALL t750_set_no_entry(p_cmd)
           LET g_before_input_done = TRUE
         CALL cl_set_docno_format("nnk01")
         CALL cl_set_docno_format("nnk21")
         CALL cl_set_docno_format("nnl04")
 
        AFTER FIELD nnk01
           IF NOT cl_null(g_nnk.nnk01) AND (g_nnk.nnk01!=g_nnk_t.nnk01) THEN
    CALL s_check_no("anm",g_nnk.nnk01,g_nnk01_t,"7","nnk_file","nnk01","")
         RETURNING li_result,g_nnk.nnk01
    DISPLAY BY NAME g_nnk.nnk01
       IF (NOT li_result) THEN
          NEXT FIELD nnk01
       END IF
           END IF
 
        AFTER FIELD nnk02
           IF NOT cl_null(g_nnk.nnk02) THEN
              IF g_nnk.nnk02 <= g_nmz.nmz10 THEN
                 CALL cl_err('','aap-176',1)
                 NEXT FIELD nnk02
              END IF
           END IF
 
        AFTER FIELD nnk04
           IF NOT cl_null(g_nnk.nnk04) THEN
              SELECT COUNT(*) INTO g_cnt FROM azi_file
               WHERE azi01 = g_nnk.nnk04
              IF g_cnt = 0 THEN
                 CALL cl_err(g_nnk.nnk04,"anm-007",0)
                 NEXT FIELD nnk04
              END IF
           END IF
 
        AFTER FIELD nnk05
           IF NOT cl_null(g_nnk.nnk05) THEN
              CALL t750_nnk05('a')
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_nnk.nnk05,g_errno,0)
                 LET g_nnk.nnk05 = g_nnk_o.nnk05
                 DISPLAY BY NAME g_nnk.nnk05
                 NEXT FIELD nnk05
              END IF
              LET g_nnk_o.nnk05 = g_nnk.nnk05
           END IF
 
        AFTER FIELD nnk06
           IF NOT cl_null(g_nnk.nnk06) THEN
               #No.MOD-480326 加判斷是否資料有修改過
              IF cl_null(g_nnk_t.nnk06) OR g_nnk.nnk06 != g_nnk_o.nnk06 THEN
                 CALL t750_nnk06('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnk.nnk06,g_errno,0)
                    LET g_nnk.nnk06 = g_nnk_o.nnk06
                    DISPLAY BY NAME g_nnk.nnk06
                    NEXT FIELD nnk06
                 END IF
               END IF
               LET g_nnk_o.nnk06 = g_nnk.nnk06
           END IF
 
        AFTER FIELD nnk08
           IF NOT cl_null(g_nnk.nnk08) THEN
              SELECT COUNT(*) INTO g_cnt FROM azi_file
               WHERE azi01 = g_nnk.nnk08
              IF g_cnt = 0 THEN
                 CALL cl_err(g_nnk.nnk08,"anm-007",0)
                 NEXT FIELD nnk08
              END IF
           END IF
 
        BEFORE FIELD nnk09                  # 自動計算出帳匯率
           IF g_nnk.nnk09 IS NULL OR g_nnk.nnk09 = 0 THEN
              CALL s_bankex(g_nnk.nnk06,g_nnk.nnk02) RETURNING g_nnk.nnk09
              DISPLAY BY NAME g_nnk.nnk09
           END IF
 
        AFTER FIELD nnk09   #匯率
           IF g_nnk.nnk04 =g_aza.aza17 THEN
              LET g_nnk.nnk09=1
              DISPLAY BY NAME g_nnk.nnk09
           END IF
 
 
        AFTER FIELD nnk10
           IF NOT cl_null(g_nnk.nnk10) THEN
              IF g_nnk_o.nnk10 IS NULL OR g_nnk.nnk10 != g_nnk_o.nnk10 THEN
                 CALL t750_nnk10('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnk.nnk10,g_errno,0)
                    LET g_nnk.nnk10 = g_nnk_o.nnk10
                    DISPLAY BY NAME g_nnk.nnk10
                    NEXT FIELD nnk10
                 END IF
              END IF
              LET g_nnk_o.nnk10 = g_nnk.nnk10
           END IF
 
        AFTER FIELD nnk101
           IF NOT cl_null(g_nnk.nnk101) THEN
              IF g_nnk_o.nnk101 IS NULL OR g_nnk.nnk101 != g_nnk_o.nnk101 THEN
                 CALL t750_nnk101('a')
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_nnk.nnk101,g_errno,0)
                    LET g_nnk.nnk101 = g_nnk_o.nnk101
                    DISPLAY BY NAME g_nnk.nnk101
                    NEXT FIELD nnk101
                 END IF
              END IF
              LET g_nnk_o.nnk101 = g_nnk.nnk101
           END IF
 
        BEFORE FIELD nnk23  #換匯標準
            #-->借款幣別與實付幣別相同時預設為1
            IF g_nnk.nnk04 = g_nnk.nnk08 THEN
               LET g_nnk.nnk23 = 1
            END IF
            #-->實付幣別與本幣相同時預設匯率
            IF g_nnk.nnk08 = g_aza.aza17 THEN
               CALL s_curr3(g_nnk.nnk04,g_nnk.nnk02,'B')
                      RETURNING g_nnk.nnk23
            END IF
            DISPLAY BY NAME g_nnk.nnk23
 
        AFTER FIELD nnk23
            IF NOT cl_null(g_nnk.nnk23) THEN
               IF g_nnk.nnk23 <=0 THEN
                  NEXT FIELD nnk23
               END IF
               #-->借款幣別與實付幣別相同時預設為1
               IF g_nnk.nnk04 = g_nnk.nnk08 THEN
                  LET g_nnk.nnk23 = 1
                   DISPLAY BY NAME g_nnk.nnk23
               END IF
            END IF
 
        AFTER FIELD nnk22
            IF g_nnk.nnk07='2' AND cl_null(g_nnk.nnk22) THEN
               NEXT FIELD nnk22
            END IF
            IF NOT cl_null(g_nnk.nnk22) THEN
               SELECT nmc03 INTO l_nmc03 FROM nmc_file
                WHERE nmc01=g_nnk.nnk22 #AND nmc03='2'
               IF STATUS THEN
                  CALL cl_err3("sel","nmc_file",g_nnk.nnk22,"",STATUS,"","sel nmc:",1)  #No.FUN-660148
                  NEXT FIELD nnk22
               ELSE
                  IF l_nmc03<>'2' THEN
                     CALL cl_err(l_nmc03,'anm-019',0)   
                     NEXT FIELD nnk22
                  END IF
               END IF
            END IF
 
        BEFORE FIELD nnk21
            IF g_nnk.nnk07 MATCHES "[23]" THEN
               LET g_nnk.nnk21=''
               DISPLAY BY NAME g_nnk.nnk21
            END IF
 
             CALL t750_set_entry('')
             CALL t750_set_no_entry('')
 
        AFTER FIELD nnk21
         #-------------------------MOD-CA0029-----------------mark
         #IF g_nnk.nnk07='1' AND cl_null(g_nnk.nnk21) THEN    #MOD-990157                                                          
         #   NEXT FIELD nnk21                                 #MOD-990157                                                          
         #END IF                                              #MOD-990157    
         #-------------------------MOD-CA0029-----------------mark
          IF NOT cl_null(g_nnk.nnk21) AND (g_nnk.nnk21!=g_nnk_t.nnk21) THEN
          CALL s_check_no("anm",g_nnk.nnk21,g_nnk_t.nnk21,"1","nnk_file","nnk21","")
              RETURNING li_result,g_nnk.nnk21
               IF (NOT li_result) THEN
                NEXT FIELD nnk21
               END IF
              LET g_msg = NULL
              IF g_nnk.nnk21[5,10]<>' ' THEN
                 SELECT nmd02 INTO g_msg FROM nmd_file
                   WHERE nmd01=g_nnk.nnk21 AND nmd30 <> 'X'
                 IF STATUS THEN
                    CALL cl_err3("sel","nmd_file",g_nnk.nnk21,"",STATUS,"","sel nmd",1)  #No.FUN-660148
                    NEXT FIELD nnk21
                 END IF
                 DISPLAY g_msg TO nmd02
              END IF
           END IF
 
        AFTER FIELD nnk17
           IF cl_null(g_nnk.nnk17) THEN
              LET g_nnk.nnk17 = 0
              DISPLAY BY NAME g_nnk.nnk17
           END IF
           IF g_nnk.nnk17 <0 THEN                                           
              CALL cl_err(g_nnk.nnk17,'aim-391',1)                          
              LET g_nnk.nnk17 = g_nnk_t.nnk17
              NEXT FIELD nnk17                                                    
           END IF                                                                 
 
        AFTER FIELD nnk18
           IF g_nnk.nnk17 > 0 AND cl_null(g_nnk.nnk18) THEN
              NEXT FIELD nnk18
           END IF
           IF NOT cl_null(g_nnk.nnk18) THEN
              SELECT nma02,nma10 INTO g_buf,l_nma10 FROM nma_file
                 WHERE nma01 = g_nnk.nnk18
              IF STATUS THEN
                 LET g_buf = ' ' LET l_nma10 = ' '
                 CALL cl_err3("sel","nma_file",g_nnk.nnk18,"",STATUS,"","sel nma",1)  #No.FUN-660148
                  NEXT FIELD nnk18 
              END IF
              DISPLAY g_buf TO nma02_2
              IF l_nma10 != g_nnk.nnk04 AND l_nma10 != g_nnk.nnk08
              THEN CALL cl_err(l_nma10,'anm-658',0)
                   NEXT FIELD nnk18
              END IF
           END IF
 
        AFTER FIELD nnk19   #現金變動碼
           IF NOT cl_null(g_nnk.nnk19) THEN
              SELECT nml02 INTO g_buf FROM nml_file WHERE nml01 = g_nnk.nnk19
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("sel","nml_file",g_nnk.nnk19,"","anm-006","","",1)  #No.FUN-660148
                 NEXT FIELD nnk19
              END IF
              DISPLAY g_buf TO nml02
           END IF
 
        AFTER FIELD nnkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_nnk.nnkuser = s_get_data_owner("nnk_file") #FUN-C10039
           LET g_nnk.nnkgrup = s_get_data_group("nnk_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT END IF
            IF g_nnk.nnk07 = '1' THEN   #支存
               LET g_nnk.nnk17 = 0
               LET g_nnk.nnk18 = NULL
               DISPLAY BY NAME g_nnk.nnk17,g_nnk.nnk18
               DISPLAY ' ' TO nma02_2
            END IF
 
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(nnk01)
                LET g_t1 = s_get_doc_no(g_nnk.nnk01)       #No.FUN-550057
                 CALL q_nmy(FALSE,TRUE,g_t1,'7','ANM') RETURNING g_t1  #TQC-670008
                 LET g_nnk.nnk01 = g_t1    #No.FUN-550057
                 DISPLAY BY NAME g_nnk.nnk01
                 NEXT FIELD nnk01
              WHEN INFIELD(nnk05) # Dept CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_alg"
                 LET g_qryparam.default1 = g_nnk.nnk05
                 CALL cl_create_qry() RETURNING g_nnk.nnk05
                 DISPLAY BY NAME g_nnk.nnk05
              WHEN INFIELD(nnk06) # Dept CODE
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_nnk.nnk06
                 CALL cl_create_qry() RETURNING g_nnk.nnk06
                 DISPLAY BY NAME g_nnk.nnk06
              WHEN INFIELD(nnk10) # Dept CODE
                 CALL s_get_bookno1(YEAR(g_nnk.nnk02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2 #FUN-980020
                 IF g_flag = '1' THEN
                    CALL cl_err(YEAR(g_nnk.nnk02),'aoo-081',1)
                 END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nnk.nnk10,'23',g_bookno1)     #No.FUN-980025
                 RETURNING g_nnk.nnk10
                 DISPLAY BY NAME g_nnk.nnk10
              WHEN INFIELD(nnk101) # Dept CODE
                  CALL s_get_bookno1(YEAR(g_nnk.nnk02),g_plant_gl) RETURNING g_flag,g_bookno1,g_bookno2  #FUN-980020
                  IF g_flag = '1' THEN
                     CALL cl_err(YEAR(g_nnk.nnk02),'aoo-081',1)
                  END IF
                 CALL q_m_aag(FALSE,TRUE,g_plant_gl,g_nnk.nnk101,'23',g_bookno2)     #No.FUN-980025 
                 RETURNING g_nnk.nnk101
                 DISPLAY BY NAME g_nnk.nnk101
              WHEN INFIELD(nnk21)
                 LET g_t1 = s_get_doc_no(g_nnk.nnk21)       #No.FUN-550057
                 CALL q_nmy(FALSE,TRUE,g_t1,'1','ANM') RETURNING g_t1  #TQC-670008
                 LET g_nnk.nnk21= g_t1    #No.FUN-550057
                 DISPLAY BY NAME g_nnk.nnk21 NEXT FIELD nnk21
              WHEN INFIELD(nnk18) #扣除手續銀行
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nma"
                 LET g_qryparam.default1 = g_nnk.nnk18
                 CALL cl_create_qry() RETURNING g_nnk.nnk18
                 DISPLAY BY NAME g_nnk.nnk18
              WHEN INFIELD(nnk19) #現金變動碼值
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nml"
                 LET g_qryparam.default1 = g_nnk.nnk19
                 CALL cl_create_qry() RETURNING g_nnk.nnk19
                 DISPLAY BY NAME g_nnk.nnk19
              WHEN INFIELD(nnk22) #銀行異動碼
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_nmc01"   #FUN-640021
                 LET g_qryparam.default1 = g_nnk.nnk22
                 LET g_qryparam.arg1 = '2'   #FUN-640021
                 CALL cl_create_qry() RETURNING g_nnk.nnk22
                 DISPLAY BY NAME g_nnk.nnk22
                 NEXT FIELD nnk22
              WHEN INFIELD(nnk08) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_nnk.nnk08
                 CALL cl_create_qry() RETURNING g_nnk.nnk08
                 DISPLAY BY NAME g_nnk.nnk08
                  NEXT FIELD nnk08   #No.MOD-490146
              WHEN INFIELD(nnk04) #幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_azi"
                 LET g_qryparam.default1 = g_nnk.nnk04
                 CALL cl_create_qry() RETURNING g_nnk.nnk04
                 DISPLAY BY NAME g_nnk.nnk04
                 NEXT FIELD nnk04
              WHEN INFIELD(nnk09)
                   CALL s_rate(g_nnk.nnk08,g_nnk.nnk09) RETURNING g_nnk.nnk09
                   DISPLAY BY NAME g_nnk.nnk09
                   NEXT FIELD nnk09
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
 
FUNCTION t750_nnk05(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_alg02 LIKE alg_file.alg02
 
   SELECT alg02 INTO l_alg02 FROM alg_file WHERE alg01 = g_nnk.nnk05
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-013'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   DISPLAY l_alg02 TO alg02
END FUNCTION
 
FUNCTION t750_nnk06(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_nma     RECORD LIKE nma_file.*
 
   IF g_nnk.nnk06 IS NULL THEN RETURN END IF
   SELECT * INTO l_nma.*
          FROM nma_file WHERE nma01 = g_nnk.nnk06
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-013'
        WHEN l_nma.nmaacti = 'N' LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   DISPLAY BY NAME l_nma.nma02
  #LET g_nnk.nnk07 = l_nma.nma28    #MOD-B30022 mark
   IF p_cmd = 'a' THEN
      LET g_nnk.nnk07 = l_nma.nma28 #MOD-B30022
      LET g_nnk.nnk08 = l_nma.nma10
      CALL s_bankex(g_nnk.nnk06,g_nnk.nnk02) RETURNING g_nnk.nnk09
      DISPLAY BY NAME g_nnk.nnk09
 
      IF {g_apz.apz52 = '1' AND}g_nnk.nnk07='1' THEN   # 貸: 應付票據
         SELECT nms15 INTO g_nnk.nnk10 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
         IF g_aza.aza63 = 'Y' THEN
            SELECT nms151 INTO g_nnk.nnk101 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
         END IF
      ELSE
         LET g_nnk.nnk10 = l_nma.nma05       # 貸: 銀行存款
         IF g_aza.aza63 = 'Y' THEN
            LET g_nnk.nnk101 = l_nma.nma051       # 貸: 銀行存款
         END IF
      END IF
   END IF
   DISPLAY BY NAME g_nnk.nnk07,g_nnk.nnk08,g_nnk.nnk10,g_nnk.nnk101      #No.FUN-680088
END FUNCTION
 
FUNCTION t750_nnk10(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_aag   RECORD LIKE aag_file.*
 
   CALL s_get_bookno(YEAR(g_nnk.nnk02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nnk.nnk02),'aoo-081',1)
   END IF
   SELECT * INTO l_aag.* FROM aag_file WHERE aag01 = g_nnk.nnk10
                                         AND aag00 = g_bookno1       #No.FUN-730032
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
        WHEN l_aag.aagacti = 'N' LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
END FUNCTION
 
FUNCTION t750_nnk101(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
   DEFINE l_aag   RECORD LIKE aag_file.*
 
   CALL s_get_bookno(YEAR(g_nnk.nnk02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nnk.nnk02),'aoo-081',1)
   END IF
   SELECT * INTO l_aag.* FROM aag_file WHERE aag01 = g_nnk.nnk101
                                         AND aag00 = g_bookno2       #No.FUN-730032
   LET g_errno = ' '
   CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'afa-025'
        WHEN l_aag.aagacti = 'N' LET g_errno = '9028'
        WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-----'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
END FUNCTION
 
FUNCTION t750_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_nnk.* TO NULL             #No.FUN-6A0011
   MESSAGE ""
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt
   CALL t750_cs()                          # 宣告 SCROLL CURSOR
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLEAR FORM
      CALL g_nnl.clear()
      RETURN
   END IF
   MESSAGE " SEARCHING ! "
   OPEN t750_count
   FETCH t750_count INTO g_row_count
   DISPLAY g_row_count TO FORMONLY.cnt
   OPEN t750_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
      INITIALIZE g_nnk.* TO NULL
   ELSE
      CALL t750_fetch('F')                # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION t750_fetch(p_flnnk)
   DEFINE
       p_flnnk         LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
       l_abso          LIKE type_file.num10   #No.FUN-680107 INTEGER
 
   CASE p_flnnk
      WHEN 'N' FETCH NEXT     t750_cs INTO g_nnk.nnk01
      WHEN 'P' FETCH PREVIOUS t750_cs INTO g_nnk.nnk01
      WHEN 'F' FETCH FIRST    t750_cs INTO g_nnk.nnk01
      WHEN 'L' FETCH LAST     t750_cs INTO g_nnk.nnk01
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
            FETCH ABSOLUTE g_jump t750_cs INTO g_nnk.nnk01
            LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
      INITIALIZE g_nnk.* TO NULL  #TQC-6B0105
      RETURN
   ELSE
      CASE p_flnnk
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_nnk.* FROM nnk_file       # 重讀DB,因TEMP有不被更新特性
    WHERE nnk01 = g_nnk.nnk01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","nnk_file",g_nnk.nnk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
   ELSE
      LET g_data_owner = g_nnk.nnkuser     #No.FUN-4C0063
      LET g_data_group = g_nnk.nnkgrup     #No.FUN-4C0063
      CALL t750_show()                      # 重新顯示
   END IF
END FUNCTION
 
FUNCTION t750_show()
DEFINE g_t1            LIKE oay_file.oayslip,   #單別  #No.FUN-680107 VARCHAR(5)
       g_nnl15         LIKE nnl_file.nnl15,
       g_nnl17         LIKE nnl_file.nnl17
DEFINE li_result       LIKE type_file.num5      #No.FUN-560002  #No.FUN-680107 SMALLINT
 
   LET g_nnk_t.* = g_nnk.*
   DISPLAY BY NAME g_nnk.nnkoriu,g_nnk.nnkorig,
          g_nnk.nnk01, g_nnk.nnk02, g_nnk.nnk04, g_nnk.nnk05,
          g_nnk.nnk06, g_nnk.nnk07, g_nnk.nnk08,
          g_nnk.nnk22, g_nnk.nnk09, g_nnk.nnk23, g_nnk.nnk21,
          g_nnk.nnk17, g_nnk.nnk18, g_nnk.nnk19,
          g_nnk.nnkglno, g_nnk.nnkconf,
          g_nnk.nnk11, g_nnk.nnk12, g_nnk.nnk13,
          g_nnk.nnk14, g_nnk.nnk16, g_nnk.nnk10, g_nnk.nnk101,      #No.FUN-680088
          g_nnk.nnkuser,g_nnk.nnkmodu,g_nnk.nnkdate,g_nnk.nnkgrup,g_nnk.nnkacti,    #MOD-940333 add g_nnk.nnkacti
          g_nnk.nnkud01,g_nnk.nnkud02,g_nnk.nnkud03,g_nnk.nnkud04,
          g_nnk.nnkud05,g_nnk.nnkud06,g_nnk.nnkud07,g_nnk.nnkud08,
          g_nnk.nnkud09,g_nnk.nnkud10,g_nnk.nnkud11,g_nnk.nnkud12,
          g_nnk.nnkud13,g_nnk.nnkud14,g_nnk.nnkud15 
   LET g_buf = NULL
   SELECT nmd02 INTO g_buf FROM nmd_file WHERE nmd01=g_nnk.nnk21
   DISPLAY g_buf TO nmd02 LET g_buf = NULL
 
   SELECT nml02 INTO g_buf FROM nml_file WHERE nml01 = g_nnk.nnk19
   DISPLAY g_buf TO nml02 LET g_buf = NULL
 
   SELECT nma02 INTO g_buf FROM nma_file WHERE nma01 = g_nnk.nnk18
   DISPLAY g_buf TO nma02_2
 
   SELECT sum(nnl15),sum(nnl17) INTO g_nnl15,g_nnl17
     FROM nnl_file where nnl01 = g_nnk.nnk01
   IF cl_null(g_nnl15) THEN LET g_nnl15 = 0 END IF
   IF cl_null(g_nnl17) THEN LET g_nnl17 = 0 END IF
   DISPLAY g_nnl15,g_nnl17 TO tot1,tot2
 
   CALL t750_nnk05('d')
   CALL t750_nnk06('d')
   CALL t750_b_fill(' 1=1')
  LET g_t1 = s_get_doc_no(g_nnk.nnk01)       #No.FUN-550057
  #CALL s_check_no("anm",g_nnk.nnk01,"","7","","","")  #No.MOD-B90165 mark
  #RETURNING li_result,g_nnk.nnk01           #No.MOD-B90165 mark
                CALL cl_set_field_pic(g_nnk.nnkconf,"","","",g_void,g_nnk.nnkacti)          #MOD-940333 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t750_u()
   IF s_anmshut(0) THEN RETURN END IF
   IF g_nnk.nnk01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_nnk.* FROM nnk_file WHERE nnk01 = g_nnk.nnk01
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_nnk.nnkconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   IF g_nnk.nnkacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_nnk.nnk01,'9027',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN t750_cl USING g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err("OPEN t750_cl:", STATUS, 1)
      CLOSE t750_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t750_cl INTO g_nnk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
       CLOSE t750_cl ROLLBACK WORK RETURN
   END IF
   LET g_nnk01_t = g_nnk.nnk01
   LET g_nnk_o.*=g_nnk.*
   LET g_nnk.nnkmodu=g_user                     #修改者
   LET g_nnk.nnkdate = g_today                  #修改日期
   CALL t750_show()                          # 顯示最新資料
   WHILE TRUE
      CALL t750_i("u")                      # 欄位更改
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          LET g_nnk.*=g_nnk_t.*
          CALL t750_show()
          CALL cl_err('',9001,0)
          EXIT WHILE
      END IF
      UPDATE nnk_file SET nnk_file.* = g_nnk.*    # 更新DB
          WHERE nnk01 = g_nnk01_t
      IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","nnk_file",g_nnk01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660148
          CONTINUE WHILE
      END IF
      IF g_nnk.nnk02 != g_nnk_t.nnk02 THEN            # 更改單號
         UPDATE npp_file SET npp02=g_nnk.nnk02
          WHERE npp01=g_nnk.nnk01 AND npp00=7 AND npp011=0
            AND nppsys = 'NM'
         IF STATUS THEN 
            CALL cl_err3("upd","npp_file",g_nnk01_t,"",STATUS,"","upd npp02:",1)  #No.FUN-660148
         END IF
      END IF
      EXIT WHILE
   END WHILE
   CLOSE t750_cl
   COMMIT WORK
   CALL cl_flow_notify(g_nnk.nnk01,'U')
END FUNCTION
 
FUNCTION t750_npp02(p_npptype)
   DEFINE p_npptype    LIKE npp_file.npptype      #No.FUN-680088
 
   IF g_nnk.nnkglno IS NULL OR g_nnk.nnkglno=' ' THEN
      UPDATE npp_file SET npp02=g_nnk.nnk02
       WHERE npp01=g_nnk.nnk01 AND npp00=7 AND npp011=0
         AND nppsys = 'NM'
         AND npptype = p_npptype      #No.FUN-680088
      IF STATUS THEN 
         CALL cl_err3("upd","npp_file",g_nnk.nnk01,"",STATUS,"","upd nnp02:",1)  #No.FUN-660148
      END IF
   END IF
END FUNCTION
FUNCTION t750_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_nnk.nnk01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
  #MOD-A20096---add---start---
   IF g_nnk.nnkconf = 'Y' THEN
      CALL cl_err('','aim1006',0)
      RETURN
   END IF
  #MOD-A20096---add---end---
 
   BEGIN WORK
 
   OPEN t750_cl USING g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err("OPEN t750_cl:", STATUS, 1)
      CLOSE t750_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t750_cl INTO g_nnk.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL t750_show()
 
   IF cl_exp(0,0,g_nnk.nnkacti) THEN                   #確認一下
      LET g_chr=g_nnk.nnkacti
      IF g_nnk.nnkacti='Y' THEN
         LET g_nnk.nnkacti='N'
      ELSE
         LET g_nnk.nnkacti='Y'
      END IF
 
      UPDATE nnk_file SET nnkacti=g_nnk.nnkacti,
                          nnkmodu=g_user,
                          nnkdate=g_today
       WHERE nnk01=g_nnk.nnk01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
         LET g_nnk.nnkacti=g_chr
      END IF
   END IF
 
   CLOSE t750_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT nnkacti,nnkmodu,nnkdate
     INTO g_nnk.nnkacti,g_nnk.nnkmodu,g_nnk.nnkdate FROM nnk_file
    WHERE nnk01=g_nnk.nnk01
   DISPLAY BY NAME g_nnk.nnkacti,g_nnk.nnkmodu,g_nnk.nnkdate
 
END FUNCTION
 
FUNCTION t750_r()
   DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-680107 VARCHAR(1)
          l_cnt   LIKE type_file.num5,    #No.FUN-680107 SMALLINT
          l_nnk02 LIKE nnk_file.nnk02
 
   IF s_anmshut(0) THEN RETURN END IF
   IF g_nnk.nnk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_nnk.* FROM nnk_file WHERE nnk01 = g_nnk.nnk01
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_nnk.nnkconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
   SELECT count(*) INTO l_cnt FROM nmd_file WHERE nmd01 = g_nnk.nnk21
   IF l_cnt > 0 THEN
      CALL cl_err(g_nnk.nnk01,'anm-235',0)
      RETURN
   END IF
 
   SELECT count(*) INTO l_cnt FROM nnl_file WHERE nnl04 = g_nnk.nnk01
   IF l_cnt > 0 THEN
      CALL cl_err(g_nnk.nnk01,'anm-190',0)
      RETURN
   END IF
   BEGIN WORK
 
   OPEN t750_cl USING g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err("OPEN t750_cl:", STATUS, 1)
      CLOSE t750_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t750_cl INTO g_nnk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
      CLOSE t750_cl ROLLBACK WORK RETURN
   END IF
   CALL t750_show()
   IF cl_delh(15,21) THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "nnk01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_nnk.nnk01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                           #No.FUN-9B0098 10/02/24
      DELETE FROM nnk_file WHERE nnk01 = g_nnk.nnk01
      IF STATUS THEN 
         CALL cl_err3("del","nnk_file",g_nnk.nnk01,"",STATUS,"","del nnk:",1)  #No.FUN-660148
         RETURN END IF
      DELETE FROM nnl_file WHERE nnl01 = g_nnk.nnk01
      IF STATUS THEN 
         CALL cl_err3("del","nnl_file",g_nnk.nnk01,"",STATUS,"","del nnl:",1)  #No.FUN-660148
         RETURN END IF
      DELETE FROM npp_file
       WHERE nppsys='NM' AND npp00=7 AND npp01=g_nnk.nnk01 AND npp011=0
      IF STATUS THEN 
         CALL cl_err3("del","npp_file",g_nnk.nnk01,"",STATUS,"","del npp:",1)  #No.FUN-660148
         RETURN END IF
      DELETE FROM npq_file
       WHERE npqsys='NM' AND npq00=7 AND npq01=g_nnk.nnk01 AND npq011=0
      IF STATUS THEN 
         CALL cl_err3("del","npq_file",g_nnk.nnk01,"",STATUS,"","del npq:",1)  #No.FUN-660148
         RETURN END IF
      #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_nnk.nnk01
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_nnk.nnk01,"",STATUS,"","del tic:",1)
         RETURN
      END IF
      #FUN-B40056--add--end--
 
      INITIALIZE g_nnk.* TO NULL
      OPEN t750_count
      #FUN-B50063-add-start--
      IF STATUS THEN
         CLOSE t750_cs
         CLOSE t750_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end-- 
      FETCH t750_count INTO g_row_count
      #FUN-B50063-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE t750_cs
         CLOSE t750_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50063-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN t750_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL t750_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL t750_fetch('/')
      END IF
   END IF
   CLOSE t750_cl
   CLEAR FORM
   CALL g_nnl.clear()
   COMMIT WORK
   CALL cl_flow_notify(g_nnk.nnk01,'D')
END FUNCTION
 
FUNCTION t750_g_np()
   DEFINE l_nmd       RECORD LIKE nmd_file.*
   DEFINE l_nmf       RECORD LIKE nmf_file.*
   DEFINE l_nnl15     LIKE nnl_file.nnl15
   DEFINE l_nnl17     LIKE nnl_file.nnl17
   DEFINE l_n         LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE l_msg       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(60)
   DEFINE li_result   LIKE type_file.num5    #No.FUN-560002 #No.FUN-680107 SMALLINT
 
   SELECT * INTO g_nnk.* FROM nnk_file WHERE nnk01 = g_nnk.nnk01
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_nnk.nnkconf = 'N' THEN CALL cl_err('','anm-960',0) RETURN END IF   #MOD-5B0328
   IF g_nnk.nnk07 != '1' THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM nmd_file WHERE nmd01=g_nnk.nnk21
   IF l_n>0 THEN
      CALL cl_getmsg('aap-741',g_lang) RETURNING l_msg
      ERROR l_msg CLIPPED  RETURN
   END IF
 
   BEGIN WORK
 
   OPEN t750_cl USING g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err("OPEN t750_cl:", STATUS, 1)
      CLOSE t750_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t750_cl INTO g_nnk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
      CLOSE t750_cl ROLLBACK WORK RETURN
   END IF
   INITIALIZE l_nmd.* TO NULL
   LET g_nnk_t.* = g_nnk.*
   LET l_nmd.nmd01=g_nnk.nnk21
    CALL s_auto_assign_no("anm",l_nmd.nmd01,g_nnk.nnk02,"1","","","","","")
         RETURNING li_result,l_nmd.nmd01
    IF (NOT li_result) THEN
        ROLLBACK WORK
        RETURN
    END IF
   LET l_nmd.nmd03=g_nnk.nnk06
   SELECT SUM(nnl15),SUM(nnl17) INTO l_nnl15,l_nnl17 FROM nnl_file
    WHERE nnl01=g_nnk.nnk01
   IF cl_null(l_nnl15) THEN LET l_nnl15=0 END IF
   IF cl_null(l_nnl17) THEN LET l_nnl17=0 END IF
   LET l_nmd.nmd04=g_nnk.nnk12+l_nnl15     #No:8615 原幣
   LET l_nmd.nmd25=g_nnk.nnk19
   LET l_nmd.nmd26=g_nnk.nnk14+l_nnl17     #No:8615 本幣
   LET l_nmd.nmd05=g_nnk.nnk02
   LET l_nmd.nmd07=g_nnk.nnk02
   LET l_nmd.nmd08=g_nnk.nnk05
   SELECT alg02,alg021 INTO l_nmd.nmd24,l_nmd.nmd09
     FROM alg_file WHERE alg01=l_nmd.nmd08
   LET l_nmd.nmd10=g_nnk.nnk01
   CALL cl_getmsg('anm-641',g_lang) RETURNING g_msg
   LET l_nmd.nmd11=g_msg
   LET l_nmd.nmd12='X'
   LET l_nmd.nmd13=g_nnk.nnk02
   LET l_nmd.nmd14='3'
   LET l_nmd.nmd19=g_nnk.nnk09   #MOD-630118
   LET l_nmd.nmd21=g_nnk.nnk08
   LET l_nmd.nmd30='N'
   LET l_nmd.nmduser=g_user
   LET l_nmd.nmdgrup=g_grup
   LET l_nmd.nmddate=TODAY
   LET l_nmd.nmd34 = g_plant
   LET l_nmd.nmd33=l_nmd.nmd19    #bug no:A049
   MESSAGE l_nmd.nmd01
   LET l_nmd.nmdlegal= g_legal
   LET l_nmd.nmdoriu = g_user      #No.FUN-980030 10/01/04
   LET l_nmd.nmdorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO nmd_file VALUES(l_nmd.*)
   IF STATUS THEN
      CALL cl_err3("ins","nmd_file",l_nmd.nmd01,"",STATUS,"","ins nmd:",1)  #No.FUN-660148
      ROLLBACK WORK RETURN 
   END IF
   INITIALIZE l_nmf.* TO NULL
   LET l_nmf.nmf01=l_nmd.nmd01
   LET l_nmf.nmf02=g_nnk.nnk02
   LET l_nmf.nmf03="1"
   LET l_nmf.nmf04=g_user
   LET l_nmf.nmf05='0'
   LET l_nmf.nmf06='X'
   LET l_nmf.nmf07=l_nmd.nmd08
   LET l_nmf.nmf08=0
   LET l_nmf.nmf09=l_nmd.nmd19
   LET l_nmf.nmflegal= g_legal
   INSERT INTO nmf_file VALUES(l_nmf.*)            # 注意多工廠環境
   IF STATUS THEN
      CALL cl_err3("ins","nmf_file",l_nmf.nmf01,l_nmf.nmf03,STATUS,"","ins nmf:",1)  #No.FUN-660148
      ROLLBACK WORK RETURN
   END IF
   UPDATE nnk_file SET nnk21=l_nmd.nmd01 WHERE nnk01=g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err3("upd","nnk_file",g_nnk.nnk01,"",STATUS,"","upd nnk21:",1)  #No.FUN-660148
       ROLLBACK WORK RETURN 
   END IF
   COMMIT WORK
   SELECT nnk21 INTO g_nnk.nnk21 FROM nnk_file WHERE nnk01=g_nnk.nnk01
   DISPLAY BY NAME g_nnk.nnk21
   LET g_msg="anmt100 '",g_nnk.nnk21,"'"
   CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
END FUNCTION
 
FUNCTION t750_del_np()
   DEFINE l_nmd       RECORD LIKE nmd_file.*
   DEFINE l_nmf       RECORD LIKE nmf_file.*
   DEFINE l_n         LIKE type_file.num10   #No.FUN-680107 INTEGER
   DEFINE l_msg       LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(60)
   DEFINE l_nnk21     LIKE nnk_file.nnk21
 
   SELECT * INTO g_nnk.* FROM nnk_file WHERE nnk01 = g_nnk.nnk01
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_nnk.nnkconf = 'N' THEN RETURN END IF
   IF g_nnk.nnk07 != '1' THEN RETURN END IF
   IF g_nnk.nnk21 IS NULL THEN RETURN END IF
   SELECT * INTO l_nmd.* FROM nmd_file WHERE nmd01=g_nnk.nnk21
   IF STATUS THEN 
      CALL cl_err3("sel","nmd_file",g_nnk.nnk21,"","anm-221","","",1)  #No.FUN-660148 
      RETURN  END IF
  #IF l_nmd.nmd12 <> 'X' OR (l_nmd.nmd02 IS NOT NULL AND l_nmd.nmd02<>' ') THEN   #No:8042 #No.MOD-B70249 mark
   IF l_nmd.nmd12 <> 'X' THEN   #No.MOD-B70249 add
      CALL cl_err(l_nmd.nmd12,'anm-236',0)
      RETURN
   END IF
#----------------------------------No.MOD-B70249-------------------------------start
   IF l_nmd.nmd02 IS NOT NULL AND l_nmd.nmd02<>' ' THEN
      CALL cl_err(l_nmd.nmd12,'anm1015',0)
      RETURN
   END IF
#----------------------------------No.MOD-B70249---------------------------------end
   IF NOT cl_sure(0,0) THEN
      RETURN
   END IF
   BEGIN WORK
   LET g_success='Y'
   DELETE FROM nmd_file WHERE nmd01 = g_nnk.nnk21
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","nmd_file",g_nnk.nnk21,"",STATUS,"","del nmd",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   DELETE FROM nmf_file WHERE nmf01 = g_nnk.nnk21
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("del","nmf_file",g_nnk.nnk21,"",STATUS,"","del nmf",1)  #No.FUN-660148
      LET g_success = 'N'  
   END IF
    LET l_nnk21= s_get_doc_no(g_nnk.nnk21)       #No.FUN-550057
   UPDATE nnk_file SET nnk21 = l_nnk21
    WHERE nnk01 = g_nnk.nnk01
   IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
      CALL cl_err3("upd","nnk_file",g_nnk.nnk01,"",STATUS,"","upd nnk",1)  #No.FUN-660148
      LET g_success = 'N'
   END IF
   IF g_success = 'Y' THEN
      CALL cl_cmmsg(1)
      COMMIT WORK
   ELSE
      CALL cl_rbmsg(1)
      ROLLBACK WORK
   END IF
   SELECT nnk21 INTO g_nnk.nnk21 FROM nnk_file WHERE nnk01=g_nnk.nnk01
   DISPLAY BY NAME g_nnk.nnk21
END FUNCTION
 
FUNCTION t750_firm1()
   DEFINE l_n    LIKE type_file.num10      #No.FUN-670060  #No.FUN-680107 INTEGER
   DEFINE l_npq03    LIKE npq_file.npq03  #CHI-A40018 add
   DEFINE l_npq07    LIKE npq_file.npq07  #CHI-A40018 add
   DEFINE l_nnk14    LIKE nnk_file.nnk14  #CHI-A40018 add
   DEFINE l_tot2     LIKE type_file.num20_6 #CHI-A40018 add
   DEFINE l_nma05    LIKE nma_file.nma05    #MOD-B40256
   DEFINE l_nnk17    LIKE nnk_file.nnk17    #MOD-B40256
 
#CHI-C30107 ----------- add ------------ begin
   IF g_nnk.nnkacti ='N' THEN
      CALL cl_err('','9027',0)
      RETURN
   END IF
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_nnk.nnkconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM nnl_file
    WHERE nnl01=g_nnk.nnk01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ----------- add ------------ end
   SELECT * INTO g_nnk.* FROM nnk_file WHERE nnk01 = g_nnk.nnk01
  #MOD-A20096---add---start---
   IF g_nnk.nnkacti ='N' THEN    
      CALL cl_err('','9027',0)
      RETURN
   END IF
  #MOD-A20096---add---end---
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_nnk.nnkconf='Y' THEN RETURN END IF
   SELECT COUNT(*) INTO g_cnt FROM nnl_file
    WHERE nnl01=g_nnk.nnk01
   IF g_cnt = 0 THEN
      CALL cl_err('','arm-034',1) RETURN
   END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p FROM g_sql
   EXECUTE nmz10_p INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nnk.nnk02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nnk.nnk01,'aap-176',1) RETURN
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   CALL s_get_bookno(YEAR(g_nnk.nnk02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_nnk.nnk02),'aoo-081',1)
      RETURN
   END IF
   SELECT COUNT(*) INTO g_cnt FROM nnl_file
    WHERE nnl01=g_nnk.nnk01
   IF g_cnt = 0 THEN
      CALL cl_err(g_nnk.nnk01,'arm-034',0)
      RETURN
   END IF
   BEGIN WORK LET g_success='Y'
 
   OPEN t750_cl USING g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err("OPEN t750_cl:", STATUS, 1)
      CLOSE t750_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t750_cl INTO g_nnk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
      CLOSE t750_cl ROLLBACK WORK RETURN
   END IF

   #CHI-A40018 add --start--
   IF cl_null(g_nnk.nnk14) THEN 
      LET l_nnk14 = 0
   ELSE
      LET l_nnk14=g_nnk.nnk14
   END IF
   SELECT SUM(nnl17) INTO l_tot2
     FROM nnl_file
    WHERE nnl01 = g_nnk.nnk01
   IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
   DECLARE t750_c2 CURSOR FOR
      SELECT npq03 FROM npq_file
       WHERE npqsys = "NM" 
         AND npq00= 7
         AND npq01=g_nnk.nnk01  
         AND npq011= 0 
   FOREACH t750_c2 INTO l_npq03
      IF l_npq03 = g_nnk.nnk10 THEN
        #SELECT npq07 INTO l_npq07       #MOD-B20031 mark
         SELECT SUM(npq07) INTO l_npq07  #MOD-B20031
           FROM npq_file
          WHERE npqsys = "NM" 
            AND npq00= 7
            AND npq01=g_nnk.nnk01  
            AND npq011= 0 
            AND npqtype='0'
            AND npq03=l_npq03
            AND npq06 = '2'         #MOD-B60157
      
        #-MOD-B40256-add-
         LET l_nnk17 = 0
         LET l_nma05 = ''
         IF g_nnk.nnk17 > 0 THEN
            SELECT nma05 INTO l_nma05 
              FROM nma_file 
             WHERE nma01 = g_nnk.nnk18
            IF l_nma05 = g_nnk.nnk10 THEN
               LET l_nnk17 = g_nnk.nnk17 * g_nnk.nnk09 
               CALL cl_digcut(l_nnk17,g_azi04) RETURNING l_nnk17
            END IF 
         END IF
        #-MOD-B40256-end-      
        #IF l_nnk14+l_tot2 <> l_npq07 THEN         #MOD-B40256 mark
         IF l_nnk14+l_tot2+l_nnk17 <> l_npq07 THEN #MOD-B40256
            CALL cl_err(g_nnk.nnk01,'aap-065',1)
            LET g_success='N'
            EXIT FOREACH
         END IF

         IF g_aza.aza63 = 'Y' THEN
           #SELECT npq07 INTO l_npq07       #MOD-B20031 mark
            SELECT SUM(npq07) INTO l_npq07  #MOD-B20031
              FROM npq_file
             WHERE npqsys = "NM" 
               AND npq00= 6
               AND npq01=g_nnk.nnk01  
               AND npq011= 0 
               AND npqtype='1'
               AND npq03=l_npq03
               AND npq06 = '2'         #MOD-B60157
      
            IF l_nnk14+l_tot2 <> l_npq07 THEN
               CALL cl_err(g_nnk.nnk01,'aap-065',1)
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
      END IF
   END FOREACH
   IF g_success='N' THEN RETURN END IF
   #CHI-A40018 add --end--
   
   #TQC-C70057--add--str--
   CALL s_get_doc_no(g_nnk.nnk01) RETURNING g_t1    
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip = g_t1
   #TQC-C70057--add--end--
 
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'N' THEN  #No.FUN-670060  #若單別須拋轉總帳, 檢查分錄底稿平衡正確否
      CALL s_chknpq(g_nnk.nnk01,'NM',0,'0',g_bookno1)       #No.FUN-730032
      IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
         CALL s_chknpq(g_nnk.nnk01,'NM',0,'1',g_bookno2)       #No.FUN-730032
      END IF
   END IF
   LET g_nnk.nnkconf ='Y'
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      SELECT count(*) INTO l_n FROM npq_file
       WHERE npq01 = g_nnk.nnk01
         AND npq011 = 0
         AND npqsys = 'NM'
         AND npq00 = 7
      IF l_n = 0 THEN
         CALL t750_gen_glcr(g_nnk.*,g_nmy.*)
      END IF
      IF g_success = 'Y' THEN 
         CALL s_chknpq(g_nnk.nnk01,'NM',0,'0',g_bookno1)       #No.FUN-730032
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_chknpq(g_nnk.nnk01,'NM',0,'1',g_bookno2)       #No.FUN-730032
         END IF
      END IF
   END IF
   UPDATE nnk_file SET nnkconf = 'Y' WHERE nnk01 = g_nnk.nnk01
   CALL t750_y1()
   CALL s_showmsg() #No.FUN-710028
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_nnk.nnk01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_nnk.nnkconf ='N'
   END IF
   DISPLAY BY NAME g_nnk.nnkconf
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
      LET g_wc_gl = 'npp01 = "',g_nnk.nnk01 CLIPPED,'" AND npp011 = 0'
     #LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nnk.nnk02,"' 'Y' '1' 'Y'"  #No.FUN-680088#FUN-860040 #MOD-A30016 mark
      LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nnk.nnk02,"' 'Y' '1' 'Y'"      #MOD-A30016 add
      CALL cl_cmdrun_wait(g_str)
      SELECT nnkglno INTO g_nnk.nnkglno FROM nnk_file
       WHERE nnk01 = g_nnk.nnk01
      DISPLAY BY NAME g_nnk.nnkglno
   END IF
   CALL cl_set_field_pic(g_nnk.nnkconf,"","","",g_void,g_nnk.nnkacti)  #MOD-AC0073 
END FUNCTION
 
FUNCTION t750_y1()
   DEFINE  l_nne08    LIKE nne_file.nne08      #MOD-840003-add
   DEFINE  l_cnt      LIKE type_file.num5      #MOD-840278
   DEFINE  l_sumcnt   LIKE type_file.num5      #CHI-C30003
   DEFINE  l_nnkconf  LIKE nnk_file.nnkconf    #MOD-BB0214 add 
 
   DECLARE t750_y1_c CURSOR FOR
      SELECT * FROM nnl_file WHERE nnl01=g_nnk.nnk01
   CALL s_showmsg_init()    #No.FUN-710028
   LET l_sumcnt = 0     #CHI-C30003                  
   FOREACH t750_y1_c INTO b_nnl.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      IF STATUS THEN
         LET g_success='N'              #FUN-8A0086 
         EXIT FOREACH
      END IF
      MESSAGE b_nnl.nnl02
      IF b_nnl.nnl12 IS NULL THEN       #尚未輸入金額資料!
         CALL s_errmsg('','',b_nnl.nnl03,'aap-705',1)  #No.FUN-710024
         LET g_success='N'
         CONTINUE FOREACH   #No.FUN-710024
      END IF
      SELECT COUNT(*) INTO g_cnt FROM nnk_file,nnl_file
       WHERE nnk01=nnl01 AND nnl04  =b_nnl.nnl04
         AND nnkconf='N' AND nnl01 !=g_nnk.nnk01
         AND nnkacti = 'Y'                               #No.MOD-B90077 add
      IF g_cnt >0 THEN
         CALL s_errmsg('','',b_nnl.nnl04,'aap-239',1)  #No.FUN-710024
         LET g_success='N'
         CONTINUE FOREACH   #No.FUN-710024
      END IF
 
 
#select 付息方式 
      LET l_nne08 = ''
      CASE b_nnl.nnl03 
           WHEN '1' 
                 SELECT nne08 INTO l_nne08 FROM nne_file
                  WHERE nne01=b_nnl.nnl04  AND nneconf <> 'X'
                 IF STATUS THEN
                    CALL cl_err3("sel","nne_file",b_nnl.nnl04,"",STATUS,"","sel nne:",1)
                    LET g_success = 'N'
                 END IF 
           WHEN '2' 
                #SELECT nng14 INTO l_nne08 FROM nng_file    #MOD-A40137 mark 
                 SELECT nng16 INTO l_nne08 FROM nng_file    #MOD-A40137 add 
                  WHERE nng01=b_nnl.nnl04
                    AND nngconf <> 'X'
                 IF STATUS THEN
                    CALL cl_err3("sel","nng_file",b_nnl.nnl04,"",STATUS,"","sel nng:",1) 
                    LET g_success = 'N'
                 END IF
           OTHERWISE
      END CASE
 
      IF cl_null(l_nne08) THEN 
         CALL cl_err('y1_sel nne08',SQLCA.SQLCODE,1) 
         LET g_success = 'N'
      END IF 
          
#依不同的付息方式回寫利息暫估資料檔(nnm_file)
     #-MOD-C90186-mark-
     #IF l_nne08 = '1' THEN        #1.每月付息
     #   LET l_cnt = 0
     #   SELECT COUNT(*) INTO l_cnt FROM nnm_file
     #    WHERE nnm01=b_nnl.nnl04
     #      AND nnm02=YEAR(g_nnk.nnk02)
     #     #AND nnm03=MONTH(g_nnk.nnk02)      #MOD-C30047 mark
     #      AND nnm03<=MONTH(g_nnk.nnk02)     #MOD-C30047 add
     #   IF l_cnt > 0 THEN 
     #     #str CHI-890030 add
     #     #若nnl15,nnl17均為0時,無須更新nnm13
     #      LET l_cnt = 0
     #      SELECT COUNT(*) INTO l_cnt FROM nnl_file
     #       WHERE nnl01 =b_nnl.nnl01
     #         AND nnl04 =b_nnl.nnl04
     #         AND (nnl15!=0 OR nnl17!=0)
     #      IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
     #      IF l_cnt > 0 THEN
     #     #end CHI-890030 add
     #         UPDATE nnm_file SET nnm13 = g_nnk.nnk01
     #          WHERE nnm01 = b_nnl.nnl04
     #            AND nnm02 = YEAR(g_nnk.nnk02)
     #           #AND nnm03 = MONTH(g_nnk.nnk02)      #MOD-C30047 mark
     #            AND nnm03 <= MONTH(g_nnk.nnk02)     #MOD-C30047 add
     #            AND (nnm13 IS NULL OR nnm13 = ' ')  #MOD-C50186 add
     #         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     #            CALL s_errmsg('nnm01',b_nnl.nnl04,'upd nnm13:',SQLCA.SQLCODE,1) 
     #            LET g_success='N'
     #         END IF
     #      END IF   #CHI-890030 add
     #   END IF
     #ELSE                         #2.還本還息 
     #-MOD-C90186-end-
        #依分錄產生方式回寫利息暫估資料檔(nnm_file)
         LET l_cnt = 0
         SELECT COUNT(*) INTO l_cnt FROM nnm_file
          WHERE nnm01=b_nnl.nnl04
            AND (nnm13 IS NULL OR nnm13 = ' ')   
            AND ((nnm02 = YEAR(g_nnk.nnk02)                                      #MOD-C20057 add
            AND nnm03 <= MONTH(g_nnk.nnk02)) OR (nnm02 < YEAR(g_nnk.nnk02)))     #MOD-C20057 add
         IF l_cnt > 0 THEN 
          #-MOD-C90186-mark-
          ##str CHI-890030 add
          ##若nnl15,nnl17均為0時,無須更新nnm13
          # LET l_cnt = 0
          # SELECT COUNT(*) INTO l_cnt FROM nnl_file
          #  WHERE nnl01 =b_nnl.nnl01
          #    AND nnl04 =b_nnl.nnl04
          #    AND (nnl15!=0 OR nnl17!=0)
          # IF cl_null(l_cnt) THEN LET l_cnt=0 END IF
          # IF l_cnt > 0 THEN
          ##end CHI-890030 add
          #-MOD-C90186-end-
               UPDATE nnm_file SET nnm13 = g_nnk.nnk01
                WHERE nnm01=b_nnl.nnl04
                  AND (nnm13 IS NULL OR nnm13 = ' ')  
                  AND ((nnm02 = YEAR(g_nnk.nnk02)                                      #MOD-C20057 add
                  AND nnm03 <= MONTH(g_nnk.nnk02)) OR (nnm02 < YEAR(g_nnk.nnk02)))     #MOD-C20057 add 
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('nnm01',b_nnl.nnl04,'upd nnm13:',SQLCA.SQLCODE,1) 
                  LET g_success='N'
               END IF
           #END IF   #MOD-C90186 mark   #CHI-890030 add
         END IF
     #END IF   #MOD-C90186 mark
 
      LET l_cnt = 0     #CHI-C30003 
      LET l_nnkconf = 'Y'                           #MOD-C50232 add
      IF b_nnl.nnl03='1' THEN 
        #CALL t750_upd_nne()                        #MOD-C50232 mark
         CALL t750_upd_nne(l_nnkconf)               #MOD-C50232 add
        #-CHI-C30003-add-
         SELECT COUNT(*) INTO l_cnt    
           FROM nmd_file                 
          WHERE nmd51 = '1' 
            AND nmd52 = b.nnl.nnl04
        #-CHI-C30003-end-
      ELSE 
        #LET l_nnkconf = 'Y'                        #MOD-BB0214 add #MOD-C50232 mark
        #CALL t750_upd_nng()                        #MOD-BB0214 mark
         CALL t750_upd_nng(l_nnkconf)               #MOD-BB0214 add
        #-CHI-C30003-add-
         SELECT COUNT(*) INTO l_cnt  
           FROM nmd_file                 
          WHERE nmd51 = '2' 
            AND nmd52 = b.nnl.nnl04
        #-CHI-C30003-end-
      END IF
      IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF   #CHI-C30003 
      LET l_sumcnt = l_sumcnt + l_cnt               #CHI-C30003
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
   IF l_sumcnt = 0 THEN      #CHI-C30003 
      CALL t750_ins_nme()
   END IF                    #CHI-C30003
 
END FUNCTION
 
#FUNCTION t750_upd_nne()                       #MOD-C50232 mark
FUNCTION t750_upd_nne(p_nnkconf)               #MOD-C50232 add
   DEFINE amt1,amt2     LIKE type_file.num20_6,#No.FUN-680107 DEC(20,6) #No.FUN-4C0010
          l_nnk02       LIKE nnk_file.nnk02,   # Jason 020402
          l_alh11       LIKE alh_file.alh11,
          l_alh12       LIKE alh_file.alh12,
          l_nne06       LIKE nne_file.nne06,
          l_nnn06       LIKE nnn_file.nnn06,
          l_nne28       LIKE nne_file.nne28,
          l_nne12       LIKE nne_file.nne12,
          l_nne26       LIKE nne_file.nne26,
          l_nne27       LIKE nne_file.nne27
  #DEFINE l_nne33       LIKE nne_file.nne22     #MOD-730063 #MOD-B90135 mark
   DEFINE l_nne33       LIKE nne_file.nne33     #MOD-B90135 add
   DEFINE p_nnkconf     LIKE nnk_file.nnkconf   #MOD-C50232 add

  #--------------------------MOD-C50232-----------------------------(S)
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF p_nnkconf = 'N'  THEN
      SELECT MAX(nnj06) INTO l_nne33
        FROM nnj_file,nnl_file,nni_file
       WHERE nnj03 = nnl04
         AND nnj03 = b_nnl.nnl04
         AND nnj01 = nni01
         AND nni03 < g_nnk.nnk02
         AND nniacti = 'Y'
         AND nniconf <> 'X' #CHI-C80041

      UPDATE nne_file SET nne33 = l_nne33
       WHERE nne01 = b_nnl.nnl04
      IF SQLCA.SQLCODE THEN
         CALL cl_err('upd nne33:',SQLCA.SQLCODE,1)
         CALL s_errmsg('nne01',b_nnl.nnl04,'upd nne33:',SQLCA.SQLCODE,1)
         LET g_success='N'
      END IF
   ELSE
  #--------------------------MOD-C50232-----------------------------(E)
     IF b_nnl.nnl17 > 0 THEN
        SELECT nne33 INTO l_nne33 FROM nne_file
         WHERE nne01 = b_nnl.nnl04 AND nne09='2'
        IF g_nnk.nnk02 > l_nne33 OR cl_null(l_nne33) THEN
           UPDATE nne_file SET nne33 = g_nnk.nnk02
            WHERE nne01 = b_nnl.nnl04
           IF SQLCA.SQLCODE THEN
              CALL cl_err('upd nne33:',SQLCA.SQLCODE,1) LET g_success='N'
              CALL s_errmsg('nne01',b_nnl.nnl04,'upd nne33:',SQLCA.SQLCODE,1)   
              LET g_success='N'
           END IF
        END IF
     END IF
   END IF                                                    #MOD-C50232 add
 
   SELECT SUM(nnl11),SUM(nnl13) INTO amt1,amt2   #FUN-640021
     FROM nnl_file,nnk_file
    WHERE nnl04=b_nnl.nnl04 AND nnl01=nnk01 AND nnkconf='Y'
   IF STATUS THEN 
      LET g_showmsg = b_nnl.nnl04,"/",'Y' #No.FUN-710024
      CALL s_errmsg('nnl04,nnkconf',g_showmsg,'sum(nnl):',STATUS,1) #No.FUN-710024
      LET g_success='N' END IF
   IF amt1 IS NULL THEN LET amt1=0 END IF
   IF amt2 IS NULL THEN LET amt2=0 END IF
   UPDATE nne_file SET nne27 = amt1,
                       nne20 = amt2
        WHERE nne01=b_nnl.nnl04
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('nne01',b_nnl.nnl04,'upd nne27,20:',SQLCA.SQLCODE,1)   #No.FUN-710024
      LET g_success='N' 
   END IF
   SELECT nne12,nne27 INTO l_nne12,l_nne27
     FROM nne_file WHERE nne01 = b_nnl.nnl04
   IF l_nne27 >= l_nne12 THEN
      LET l_nne26 = g_nnk.nnk02      #modi by kitty
   ELSE
      LET l_nne26 = null
      LET l_nnk02 = null
   END IF
   SELECT MAX(nnk02) INTO l_nnk02 FROM nnk_file,nnl_file
    WHERE nnl01=nnk01 AND nnl04 = b_nnl.nnl04 AND nnkconf='Y'
   UPDATE nne_file SET nne26 = l_nne26, nne21 = l_nnk02
    WHERE nne01 = b_nnl.nnl04
   IF SQLCA.SQLCODE THEN
      CALL s_errmsg('nne01',b_nnl.nnl04,'upd nne26:',STATUS,1)   #No.FUN-710024
      LET g_success='N'  
   END IF
   LET l_nne06 = NULL
   LET l_nnn06 = NULL
   LET l_nne28 = NULL
   LET l_alh11 = NULL
   LET l_alh12 = NULL
 
   SELECT nne06,nne28,alh11,alh12
     INTO l_nne06,l_nne28,l_alh11,l_alh12
     FROM nne_file,alh_file
    WHERE nne01 = b_nnl.nnl04 AND alh01 = nne28
   SELECT nnn06 INTO l_nnn06 FROM nnn_file WHERE nnn01 = l_nne06
   IF l_nnn06 IS NOT NULL AND l_nnn06 = '1' THEN
      IF g_nnk.nnk08 <> l_alh11 THEN
         UPDATE alh_file SET alh76 = l_alh12,alh77 = amt2
          WHERE alh01 = l_nne28
      ELSE
         UPDATE alh_file SET alh76 = amt1,alh77 = amt2
          WHERE alh01 = l_nne28
      END IF
 
      IF STATUS THEN
         CALL s_errmsg('alh01',l_nne28,'upd alh',STATUS,0) #No.FUN-710024
         LET g_success = 'N'
      END IF
   END IF
END FUNCTION
 
#FUNCTION t750_upd_nng()                                       #MOD-BB0214 mark
FUNCTION t750_upd_nng(p_nnkconf)                               #MOD-BB0214 add
   DEFINE amt1,amt2   LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
   DEFINE l_nnk02     LIKE nnk_file.nnk02                      #MOD-BB0214 add
   DEFINE l_nng26     LIKE nng_file.nng26                      #MOD-BB0214 add
   DEFINE p_nnkconf   LIKE nnk_file.nnkconf                    #MOD-BB0214 add

   IF p_nnkconf='X' THEN RETURN END IF  #CHI-C80041
   SELECT SUM(nnl11),SUM(nnl13) INTO amt1,amt2   #FUN-640021
     FROM nnl_file,nnk_file
    WHERE nnl04=b_nnl.nnl04 AND nnl01=nnk01 AND nnkconf='Y'
   IF STATUS THEN 
      LET g_showmsg = b_nnl.nnl04,"/",'Y'    #No.FUN-710024
      CALL s_errmsg('nnl04,nnkconf',g_showmsg,'sum(nnl):',STATUS,1) #No.FUN-710024
      LET g_success='N' END IF
   IF amt1 IS NULL THEN LET amt1=0 END IF
   IF amt2 IS NULL THEN LET amt2=0 END IF
  #------------------------------------MOD-BB0214-------------------------------start
  IF p_nnkconf = 'Y' THEN
     SELECT nng26 INTO l_nng26
       FROM nng_file
      WHERE nng01=b_nnl.nnl04

     SELECT nnk02 INTO l_nnk02
       FROM nnl_file,nnk_file
      WHERE nnl04=b_nnl.nnl04
        AND nnk01 = b_nnl.nnl01

     IF b_nnl.nnl15 >0 OR b_nnl.nnl17 >0 THEN
        LET l_nng26 = l_nnk02
     END IF
  ELSE
     SELECT nnk02 INTO l_nnk02
       FROM nnl_file,nnk_file
      WHERE nnl04 = b_nnl.nnl04
        AND nnk01 = nnl01
        AND nnk02 = (SELECT max(nnk02)
       FROM nnl_file,nnk_file
      WHERE nnl04 = b_nnl.nnl04
        AND nnk01 = nnl01
        AND nnk01 <> b_nnl.nnl01
        AND nnkconf <> 'X'  #CHI-C80041
        AND nnk02 < (SELECT nnk02
       FROM nnl_file,nnk_file
      WHERE nnl04 = b_nnl.nnl04
        AND nnk01 = nnl01
        AND nnk01 = b_nnl.nnl01))
     IF sqlca.sqlcode= 100  THEN
        LET l_nng26 = ''
     ELSE
        LET l_nng26 = l_nnk02
     END IF
  END IF
  #------------------------------------MOD-BB0214---------------------------------end
   UPDATE nng_file SET nng21 = amt1,
                       nng23 = amt2,
                       nng26 = l_nng26           #MOD-BB0214 add
    WHERE nng01=b_nnl.nnl04
   IF SQLCA.SQLCODE THEN
     #CALL s_errmsg('nng01',b_nnl.nnl04,'upd nng21,23:',SQLCA.SQLCODE,1)       #No.FUN-710024 #MOD-BB0214 mark
      CALL s_errmsg('nng01',b_nnl.nnl04,'upd nng21,23,26:',SQLCA.SQLCODE,1)    #No.MOD-BB0214 add
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t750_ins_nme()
  DEFINE l_nme          RECORD LIKE nme_file.*,
         l_nnl15        LIKE nnl_file.nnl15,
         l_nnl17        LIKE nnl_file.nnl17,
         l_nma10        LIKE nma_file.nma10,
         l_nma28        LIKE nma_file.nma28,
         l_nnk17        LIKE nnk_file.nnk17                  #MOD-A80101

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   SELECT nma10 INTO l_nma10 FROM nma_file
                     WHERE nma01 = g_nnk.nnk06
   IF SQLCA.sqlcode THEN LET l_nma10 = ' ' END IF
   SELECT nma28 INTO l_nma28 FROM nma_file
                     WHERE nma01 = g_nnk.nnk18
   IF SQLCA.sqlcode THEN LET l_nma28 = ' ' END IF
   LET l_nme.nme14=g_nnk.nnk19       #MOD-980146 add
   #-->為活存帳戶才產生nme_file
  #IF g_nnk.nnk07='2' THEN                                #MOD-CC0064 mark
   IF g_nnk.nnk07 ='2' OR  g_nnk.nnk07 = '3' THEN         #MOD-CC0064 add 
      LET l_nme.nme00=0
      SELECT SUM(nnl15),SUM(nnl17) INTO l_nnl15,l_nnl17
        FROM nnl_file WHERE nnl01=g_nnk.nnk01
      IF cl_null(l_nnl15) THEN LET l_nnl15 = 0 END IF
      IF cl_null(l_nnl17) THEN LET l_nnl17 = 0 END IF
      LET l_nme.nme01=g_nnk.nnk06
      LET l_nme.nme02=g_nnk.nnk02
      LET l_nme.nme03=g_nnk.nnk22
     #若銀行為本國幣別時
      LET l_nme.nme04=g_nnk.nnk12+l_nnl15
      LET l_nme.nme07=g_nnk.nnk09
      LET l_nme.nme08=g_nnk.nnk14+l_nnl17
      LET l_nme.nme10=g_nnk.nnkglno
      LET l_nme.nme12=g_nnk.nnk01
      SELECT alg02 INTO l_nme.nme13 FROM alg_file where alg01=g_nnk.nnk05
      IF STATUS THEN LET l_nme.nme13=g_nnk.nnk05 END IF
      LET l_nme.nme16=g_nnk.nnk02
      LET l_nme.nme17=g_nnk.nnk01
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=TODAY
 
      #-->支付銀行與手續費支付銀行相同
      IF (g_nnk.nnk06 = g_nnk.nnk18)  THEN
         IF l_nma10 = g_aza.aza17 THEN      #幣別為本幣時銀行金額加上手續費
            LET l_nme.nme04 = l_nme.nme04 + g_nnk.nnk17
            LET l_nme.nme08 = l_nme.nme08 + g_nnk.nnk17
         ELSE
            LET l_nme.nme04 = l_nme.nme04 + g_nnk.nnk17
            LET l_nnk17 = g_nnk.nnk17 * g_nnk.nnk09                           #MOD-A80101
            CALL cl_digcut(l_nnk17,g_azi04) RETURNING l_nnk17                 #MOD-A80101  
           #LET l_nme.nme08 = l_nme.nme08 + (g_nnk.nnk17 * g_nnk.nnk09)       #MOD-A80101 mark
            LET l_nme.nme08 = l_nme.nme08 + l_nnk17                           #MOD-A80101
         END IF
      END IF
      LET t_azi04 = 0   #NO.CHI-6A0004  
      SELECT azi04 INTO t_azi04 FROM azi_file, nma_file #NO.CHI-6A0004
       WHERE azi01 = nma10 AND nma01 = l_nme.nme01
      IF NOT cl_null(t_azi04) THEN     #NO.CHI-6A0004  
         CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04     #NO.CHI-6A0004  
      END IF
      LET l_nme.nme21 = b_nnl.nnl02 #TQC-980106 g_nme.nme21-->l_nme.nme21   
      LET l_nme.nme22 = '15' #TQC-980106 g_nme.nme22-->l_nme.nme22   
      LET l_nme.nme23 = '' #TQC-980106 g_nme.nme23-->l_nme.nme23   
      LET l_nme.nme24 = '9'  #No.TQC-750098 #TQC-980106 g_nme.nme24-->l_nme.nme24   
      LET l_nme.nme25 = g_nnk.nnk05 #TQC-980106 g_nme.nme25-->l_nme.nme25   
 
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
      END IF
#FUN-B30166--add--end

      INSERT INTO nme_file VALUES(l_nme.*)
      IF STATUS THEN 
         CALL s_errmsg('nme02',l_nme.nme02,'ins nme:',STATUS,1) #No.FUN-710024
         LET g_success='N' END IF
   END IF
   #-->支付銀行與手續費支付銀行不同且手續費銀行為活存(nma28 = '2')
  #IF g_nnk.nnk06 != g_nnk.nnk18 AND l_nma28 ='2' THEN                   #MOD-CC0064 mark
   IF g_nnk.nnk06 != g_nnk.nnk18 AND (l_nma28 ='2' OR l_nma28 ='3') THEN #MOD-CC0064
      LET l_nme.nme00=0
      LET l_nme.nme01=g_nnk.nnk18   #銀行編號
      LET l_nme.nme02=g_nnk.nnk02
      LET l_nme.nme03=g_nnk.nnk22
      LET l_nme.nme04=g_nnk.nnk17
      LET l_nme.nme07=g_nnk.nnk09
      LET l_nme.nme08=g_nnk.nnk17 * g_nnk.nnk09   #FUN-640021
      CALL cl_digcut(l_nme.nme08,g_azi04) RETURNING l_nme.nme08         #MOD-A80101  
      LET l_nme.nme10=g_nnk.nnkglno
      LET l_nme.nme12=g_nnk.nnk01
      SELECT alg02 INTO l_nme.nme13 FROM alg_file where alg01=g_nnk.nnk05
      IF STATUS THEN LET l_nme.nme13=g_nnk.nnk05 END IF
      LET l_nme.nme16=g_nnk.nnk02
      LET l_nme.nme17=g_nnk.nnk01
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=TODAY
      LET t_azi04 = 0                                    #NO.CHI-6A0004  
      SELECT azi04 INTO t_azi04 FROM azi_file, nma_file  #NO.CHI-6A0004  
       WHERE azi01 = nma10 AND nma01 = l_nme.nme01
      IF NOT cl_null(t_azi04) THEN                        #NO.CHI-6A0004  
         CALL cl_digcut(l_nme.nme04,t_azi04) RETURNING l_nme.nme04 #NO.CHI-6A0004  
      END IF
      LET l_nme.nme21 = b_nnl.nnl02 #TQC-980106 g_nme.nme21-->l_nme.nme21   
      LET l_nme.nme22 = '15' #TQC-980106 g_nme.nme22-->l_nme.nme22   
      LET l_nme.nme23 = '' #TQC-980106 g_nme.nme23-->l_nme.nme23   
      LET l_nme.nme24 = '9'  #No.TQC-750098 #TQC-980106 g_nme.nme24-->l_nme.nme24   
      LET l_nme.nme25 = g_nnk.nnk05 #TQC-980106 g_nme.nme25-->l_nme.nme25   
 
      LET l_nme.nmelegal= g_legal

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
      END IF
#FUN-B30166--add--end

      INSERT INTO nme_file VALUES(l_nme.*)
      IF STATUS THEN 
         CALL s_errmsg('nme02',l_nme.nme02,'ins nme:',STATUS,1) #No.FUN-710024
         LET g_success='N' END IF
      CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
   END IF
END FUNCTION
 
FUNCTION t750_firm2()
   DEFINE l_aba19     LIKE aba_file.aba19   #No.FUN-670060
   DEFINE l_sql       STRING #No.FUN-670060  #No.FUN-680107 VARCHAR(1000) #MOD-BA0015 mod chr1000 -> STRING
   DEFINE l_dbs       STRING                #No.FUN-670060
   DEFINE l_cnt       LIKE type_file.num5   #MOD-840278
 
   SELECT * INTO g_nnk.* FROM nnk_file WHERE nnk01 = g_nnk.nnk01
  #MOD-A20096---add---start---
   IF g_nnk.nnkacti ='N' THEN    
      CALL cl_err('','9027',0)
      RETURN
   END IF
  #MOD-A20096---add---end---
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_nnk.nnkconf='N' THEN RETURN END IF
#FUN-B50090 add begin-------------------------
#重新抓取關帳日期
   LET g_sql ="SELECT nmz10 FROM nmz_file ",
              " WHERE nmz00 = '0'"
   PREPARE nmz10_p1 FROM g_sql
   EXECUTE nmz10_p1 INTO g_nmz.nmz10
#FUN-B50090 add -end--------------------------
   #-->立帳日期不可小於關帳日期
   IF g_nnk.nnk02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nnk.nnk01,'aap-176',1) RETURN
   END IF
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_nnk.nnk01) RETURNING g_t1     #No.FUN-550071
   SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
   IF NOT cl_null(g_nnk.nnkglno) THEN
      IF NOT (g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y') THEN
         CALL cl_err(g_nnk.nnk01,'axr-370',0) RETURN
      END IF
   END IF
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                  "    AND aba01 = '",g_nnk.nnkglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
      PREPARE aba_pre1 FROM l_sql
      DECLARE aba_cs1 CURSOR FOR aba_pre1
      OPEN aba_cs1
      FETCH aba_cs1 INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL cl_err(g_nnk.nnkglno,'axr-071',1)
         RETURN
      END IF
 
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   IF NOT cl_null(g_nnk.nnkglno) AND g_nmy.nmyglcr = 'N' THEN
       CALL cl_err(g_nnk.nnk01,'anm-230',1)
       RETURN
   END IF
   IF g_nnk.nnk21 IS NOT NULL THEN   #若已開票,則不可取消確認
      SELECT COUNT(*) INTO g_cnt FROM nmd_file WHERE nmd01=g_nnk.nnk21
      IF g_cnt > 0 THEN
         CALL cl_err(g_nnk.nnk01,'anm-958',0) RETURN
      END IF
   END IF

   #CHI-C90052 add begin---
   IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' THEN
      LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nnk.nnkglno,"' 'Y'"
      CALL cl_cmdrun_wait(g_str)
      SELECT nnkglno INTO g_nnk.nnkglno FROM nnk_file
       WHERE nnk01 = g_nnk.nnk01
      IF NOT cl_null(g_nnk.nnkglno) THEN
         CALL cl_err(g_nnk.nnkglno,'aap-929',1)
         RETURN
      END IF
      DISPLAY BY NAME g_nnk.nnkglno
   END IF
   #CHI-C90052 add end-----

   BEGIN WORK
 
   OPEN t750_cl USING g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err("OPEN t750_cl:", STATUS, 1)
      CLOSE t750_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t750_cl INTO g_nnk.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
      CLOSE t750_cl ROLLBACK WORK RETURN
   END IF
   LET g_success='Y'
   LET g_nnk.nnkconf ='N'
   UPDATE nnk_file SET nnkconf = 'N' WHERE nnk01 = g_nnk.nnk01
   IF SQLCA.SQLCODE THEN
      CALL cl_err3("upd","nnk_file",g_nnk.nnk01,"",SQLCA.sqlcode,"","upd nnkconf:",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM nnm_file 
     WHERE nnm13 = g_nnk.nnk01
   IF l_cnt > 0 THEN 
      UPDATE nnm_file SET nnm13 = NULL WHERE nnm13 = g_nnk.nnk01
      IF SQLCA.SQLCODE THEN
         CALL cl_err3("upd","nnm_file",g_nnk.nnk01,"",SQLCA.sqlcode,"","upd nnm13:",1)  #No.FUN-660148
         LET g_success='N'
      END IF
   END IF   #MOD-840278
   CALL t750_y2()
   CALL s_showmsg() #No.FUN-710028
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_nnk.nnkconf ='N'
   ELSE
      ROLLBACK WORK
      LET g_nnk.nnkconf ='Y'
   END IF
   DISPLAY BY NAME g_nnk.nnkconf
   
   #CHI-C90052 mark begin---
   #IF g_nmy.nmydmy3 = 'Y' AND g_nmy.nmyglcr = 'Y' AND g_success = 'Y' THEN
   #   LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nnk.nnkglno,"' 'Y'"
   #   CALL cl_cmdrun_wait(g_str)
   #   SELECT nnkglno INTO g_nnk.nnkglno FROM nnk_file
   #    WHERE nnk01 = g_nnk.nnk01
   #   DISPLAY BY NAME g_nnk.nnkglno
   #END IF
   #CHI-C90052 mark end-----
END FUNCTION
 
FUNCTION t750_y2()
   DEFINE  l_nnkconf  LIKE nnk_file.nnkconf    #MOD-BB0214 add
   DECLARE t750_y2_c CURSOR FOR
      SELECT * FROM nnl_file WHERE nnl01=g_nnk.nnk01
   CALL s_showmsg_init()    #No.FUN-710028
   FOREACH t750_y2_c INTO b_nnl.*
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
 
      MESSAGE b_nnl.nnl02
      LET l_nnkconf = 'N'                       #MOD-C50232 add
      IF b_nnl.nnl03='1' THEN
        #CALL t750_upd_nne()                    #MOD-C50232 mark
         CALL t750_upd_nne(l_nnkconf)           #MOD-C50232 add
      ELSE
        #LET l_nnkconf = 'N'                    #MOD-BB0214 add   #MOD-C50232 mark
        #CALL t750_upd_nng()                    #MOD-BB0214 mark
         CALL t750_upd_nng(l_nnkconf)           #MOD-BB0214 add
      END IF
      UPDATE nne_file SET nne26 =NULL
       WHERE nne01 = b_nnl.nnl04
      IF SQLCA.SQLCODE THEN
         CALL s_errmsg('nne01',b_nnl.nnl04,'upd nne26:',SQLCA.SQLCODE,1)   #No.FUN-710024
         LET g_success='N'
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
 
  #IF g_nnk.nnk07='2' THEN CALL t750_del_nme() END IF     #MOD-CC0064 mark
   IF g_nnk.nnk07 ='2' OR  g_nnk.nnk07 = '3' THEN         #MOD-CC0064 add 
      CALL t750_del_nme()                                 #MOD-CC0064 add
   END IF                                                 #MOD-CC0064 add
 
END FUNCTION
 
FUNCTION t750_del_nme()
 DEFINE l_nme24     LIKE nme_file.nme24  #No.FUN-730032
 
   IF g_aza.aza73 = 'Y' THEN
      LET g_sql="SELECT nme24 FROM nme_file",
                " WHERE nme12='",g_nnk.nnk01,"'"
      PREPARE nme24_p1 FROM g_sql
      DECLARE nme24_cs1 CURSOR FOR nme24_p1
      FOREACH nme24_cs1 INTO l_nme24
         IF l_nme24 != '9' THEN
            CALL cl_err(g_nnk.nnk01,'anm-043',1)
            LET g_success='N'
            RETURN
         END IF
      END FOREACH
   END IF
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021 
   #FUN-B40056  --begin
   DELETE FROM tic_file WHERE tic04 IN
  (SELECT nme12 FROM nme_file 
    WHERE nme17 = g_nnk.nnk01)
   
   IF STATUS THEN 
      CALL cl_err3("del","tic_file",g_nnk.nnk01,"",STATUS,"","del tic:",1)
      LET g_success='N' END IF
   #FUN-B40056  --end
   END IF                 #No.TQC-B70021 
   DELETE FROM nme_file WHERE nme17=g_nnk.nnk01
   IF STATUS THEN 
      CALL s_errmsg('nme17',g_nnk.nnk01,'del nme:',STATUS,1) #No.FUN-710024
      LET g_success='N' END IF
END FUNCTION
 
FUNCTION t750_out(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1,   #No.FUN-680107 VARCHAR(1)
          l_cmd     LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(400)
         #l_wc      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(200) #MOD-BA0015 mark
 
   CALL cl_wait()
   LET g_wc = 'nnk01="',g_nnk.nnk01,'"'
  #LET l_cmd =  "anmr750 '' '' '",g_lang,"' 'Y' '' '' "," '",g_wc CLIPPED,"' '3'" CLIPPED #FUN-C30085 mark
   LET l_cmd =  "anmg750 '' '' '",g_lang,"' 'Y' '' '' "," '",g_wc CLIPPED,"' '3'" CLIPPED #FUN-C30085 add
   CALL cl_cmdrun(l_cmd)
   ERROR ' '
END FUNCTION
 
FUNCTION t750_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1) #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,       #未取消的ARRAY CNT  #No.FUN-680107 SMALLINT
    l_n             LIKE type_file.num5,       #檢查重複用  #No.FUN-680107 SMALLINT
    l_lock_sw       LIKE type_file.chr1,       #單身鎖住否  #No.FUN-680107 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,       #處理狀態    #No.FUN-680107 VARCHAR(1)
   #l_rate          LIKE cae_file.cae07,       #No.FUN-680107 DEC(15,5)  #No.FUN-680107 mark
    l_rate          LIKE type_file.num26_10,   #No.MOD-B80149 add    
    l_day           LIKE type_file.num5,       #No.FUN-680107 SMALLINT
    l_allow_insert  LIKE type_file.num5,       #可新增否  #No.FUN-680107 SMALLINT
    l_allow_delete  LIKE type_file.num5,       #可刪除否  #No.FUN-680107 SMALLINT
    l_rate2         LIKE nne_file.nne14,       #MOD-A90009 
    l_curr          LIKE nne_file.nne16        #MOD-A90009 
DEFINE l_date1         LIKE gxk_file.gxk02     #MOD-CA0037 add
DEFINE l_date2         LIKE gxk_file.gxk02     #MOD-CA0037 add
 
    LET g_action_choice = ""
    IF s_anmshut(0) THEN RETURN END IF
    SELECT * INTO g_nnk.* FROM nnk_file WHERE nnk01 = g_nnk.nnk01
    IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
    IF g_nnk.nnkconf='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_nnk.nnk01 IS NULL THEN RETURN END IF
 
   IF g_nnk.nnkacti ='N' THEN    
      CALL cl_err(g_nnk.nnk01,'9027',0)
      RETURN
   END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT nnl02,nnl03,nnl04,'',nnl18,'','',",
                       "       nnl11,nnl13,nnl12,",
                       "       nnl14,nnl15,nnl17,nnl16,",
                       "       nnlud01,nnlud02,nnlud03,nnlud04,nnlud05,",
                       "       nnlud06,nnlud07,nnlud08,nnlud09,nnlud10,",
                       "       nnlud11,nnlud12,nnlud13,nnlud14,nnlud15 ", 
                       "  FROM nnl_file ",
                       " WHERE nnl01=? AND nnl02=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t750_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_nnl WITHOUT DEFAULTS FROM s_nnl.*
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
           OPEN t750_cl USING g_nnk.nnk01
           IF STATUS THEN
              CALL cl_err("OPEN t750_cl:", STATUS, 1)
              CLOSE t750_cl
              ROLLBACK WORK
              RETURN
           END IF
           FETCH t750_cl INTO g_nnk.*               # 對DB鎖定
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
              CLOSE t750_cl
              ROLLBACK WORK
              RETURN
           END IF
           IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_nnl_t.* = g_nnl[l_ac].*  #BACKUP
               OPEN t750_bcl USING g_nnk.nnk01,g_nnl_t.nnl02
               IF STATUS THEN
                  CALL cl_err("OPEN t750_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               END IF
               FETCH t750_bcl INTO g_nnl[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_nnl_t.nnl02,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
               LET g_nnl[l_ac].exrate= g_nnl_t.exrate
               LET g_nnl[l_ac].date1 = g_nnl_t.date1
               LET g_nnl[l_ac].date2 = g_nnl_t.date2
               CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_nnl[l_ac].* TO NULL      #900423
           LET g_nnl[l_ac].nnl11 = 0
           LET g_nnl[l_ac].nnl12 = 0
           LET g_nnl[l_ac].nnl13 = 0
           LET g_nnl[l_ac].nnl14 = 0
           LET g_nnl[l_ac].nnl15 = 0
           LET g_nnl[l_ac].nnl16 = 0
           LET g_nnl[l_ac].nnl17 = 0
           LET g_nnl_t.* = g_nnl[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD nnl02
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
 
           INSERT INTO nnl_file(nnl01,nnl02,nnl03,nnl04,
                                nnl11,nnl12,nnl13,nnl14,nnl15,
                                nnl16,nnl17,nnl18,
                                nnlud01,nnlud02,nnlud03,
                                nnlud04,nnlud05,nnlud06,
                                nnlud07,nnlud08,nnlud09,
                                nnlud10,nnlud11,nnlud12,
                                nnlud13,nnlud14,nnlud15,
                                nnllegal)  #FUN-980005 add legal 
            VALUES(g_nnk.nnk01,g_nnl[l_ac].nnl02,
                   g_nnl[l_ac].nnl03,g_nnl[l_ac].nnl04,
                   g_nnl[l_ac].nnl11,g_nnl[l_ac].nnl12,
                   g_nnl[l_ac].nnl13,g_nnl[l_ac].nnl14,
                   g_nnl[l_ac].nnl15,g_nnl[l_ac].nnl16,
                   g_nnl[l_ac].nnl17,g_nnl[l_ac].nnl18,
                   g_nnl[l_ac].nnlud01,g_nnl[l_ac].nnlud02,
                   g_nnl[l_ac].nnlud03,g_nnl[l_ac].nnlud04,
                   g_nnl[l_ac].nnlud05,g_nnl[l_ac].nnlud06,
                   g_nnl[l_ac].nnlud07,g_nnl[l_ac].nnlud08,
                   g_nnl[l_ac].nnlud09,g_nnl[l_ac].nnlud10,
                   g_nnl[l_ac].nnlud11,g_nnl[l_ac].nnlud12,
                   g_nnl[l_ac].nnlud13,g_nnl[l_ac].nnlud14,
                   g_nnl[l_ac].nnlud15,g_legal)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","nnl_file",g_nnk.nnk01,g_nnl[l_ac].nnl02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
           END IF
 
        BEFORE FIELD nnl02                        #default 序號
           IF g_nnl[l_ac].nnl02 IS NULL OR g_nnl[l_ac].nnl02 = 0 THEN
              SELECT max(nnl02)+1
                INTO g_nnl[l_ac].nnl02
                FROM nnl_file
               WHERE nnl01 = g_nnk.nnk01
              IF g_nnl[l_ac].nnl02 IS NULL THEN
                 LET g_nnl[l_ac].nnl02 = 1
              END IF
           END IF
 
        AFTER FIELD nnl02                        #check 序號是否重複
           IF NOT cl_null(g_nnl[l_ac].nnl02) THEN
              IF g_nnl[l_ac].nnl02 != g_nnl_t.nnl02 OR g_nnl_t.nnl02 IS NULL THEN
                 SELECT count(*) INTO l_n
                   FROM nnl_file
                  WHERE nnl01 = g_nnk.nnk01
                    AND nnl02 = g_nnl[l_ac].nnl02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_nnl[l_ac].nnl02 = g_nnl_t.nnl02
                    NEXT FIELD nnl02
                 END IF
              END IF
           END IF
 
        AFTER FIELD nnl03
           IF NOT cl_null(g_nnl[l_ac].nnl03) THEN
              IF g_nnl[l_ac].nnl03 NOT MATCHES '[12]'THEN
                 NEXT FIELD nnl03
              END IF
           END IF
 
        AFTER FIELD nnl04
           IF NOT cl_null(g_nnl[l_ac].nnl04) THEN
              LET g_cnt = 0
              SELECT COUNT(*) INTO g_cnt FROM nnk_file,nnl_file
               WHERE nnk01=nnl01 AND nnl04=g_nnl[l_ac].nnl04
                 AND nnl01 = g_nnk.nnk01
              IF g_nnl[l_ac].nnl04 <> g_nnl_t.nnl04 OR
                 cl_null(g_nnl_t.nnl04) THEN
                 IF g_cnt > 0 THEN
                    CALL cl_err('','-239',0)
                    NEXT FIELD nnl04
                 END IF
              END IF
              LET g_cnt = 0
               
              SELECT COUNT(*) INTO g_cnt FROM nnk_file,nnl_file
               WHERE nnk01=nnl01 AND nnl04  =g_nnl[l_ac].nnl04
                 AND nnkconf='N' AND nnl01 !=g_nnk.nnk01
                 AND nnkacti = 'Y'                               #No.MOD-B90077 add
              IF g_cnt >0 THEN
                 CALL cl_err(g_nnl[l_ac].nnl04,'aap-239',0) NEXT FIELD nnl04
              END IF
              #-------------融資類短貸------------------------
              IF g_nnl[l_ac].nnl03 = '1' THEN
                 SELECT * INTO g_nne.* FROM nne_file
                  WHERE nne01=g_nnl[l_ac].nnl04  AND nneconf <> 'X'
                 IF STATUS THEN
                    CALL cl_err3("sel","nne_file",g_nnl[l_ac].nnl04,"",STATUS,"","sel nne:",1)  #No.FUN-660148
                    NEXT FIELD nnl04
                #-CHI-C30003-mark-
                #ELSE
                #  #SELECT * FROM nmd_file              #CHI-B40029 mark
                #   LET g_cnt = 0                       #CHI-B40029
                #   SELECT COUNT(*) INTO g_cnt          #CHI-B40029
                #     FROM nmd_file                     #CHI-B40029
                #    WHERE nmd51='1' AND nmd52=g_nne.nne01
                #  #-CHI-B40029-add-
                #   IF cl_null(g_cnt) THEN
                #      LET g_cnt = 0
                #   END IF
                #   IF g_cnt > 0 THEN
                #  #-CHI-B40029-end-
                #  #IF STATUS=0 THEN       #CHI-B40029 mark
                #      CALL cl_err('','anm-290',1)           #CHI-B40029 
                #     #CALL cl_err3("sel","nmd_file",g_nne.nne01,"","anm-290","","",1)  #No.FUN-660148 #CHI-B40029 mark
                #      NEXT FIELD nnl04 
                #   END IF
                #-CHI-C30003-end-
                 END IF
                 #-->幣別必須要與單頭借款幣別一致,
                 #   否則在計算應計息利時多幣別會有問題
                 IF g_nne.nne16 !=g_nnk.nnk04 THEN
                    CALL cl_err(g_nne.nne16,'anm-659',0) NEXT FIELD nnl04
                 END IF
                 #-->融資資料之信貸銀行必須與單頭信貸銀行一致
                 IF g_nne.nne04 !=g_nnk.nnk05 THEN
                    CALL cl_err(g_nne.nne04,'anm-661',0) NEXT FIELD nnl04
                 END IF
                 ##-->已還款
                 IF g_nne.nne27 >= g_nne.nne12 THEN
                    CALL cl_err('','anm-240',0)
                    NEXT FIELD nnl04
                 END IF
                 IF g_nne.nneconf = 'N' THEN       #未確認
                    CALL cl_err('','aap-141',0) NEXT FIELD nnl04
                 END IF
                 IF g_nne.nneconf = 'X' THEN       #已作廢
                    CALL cl_err('','9024',0) NEXT FIELD nnl04
                 END IF
                 LET g_nnl[l_ac].exrate= g_nne.nne17
                #--------------------------------MOD-CA0037-----------------------(S)
                #--MOD-CA0037--mark
                #IF NOT cl_null(g_nne.nne33) THEN
                #  #LET g_nnl[l_ac].date1 = g_nne.nne33       #MOD-C50167 mark
                #   LET g_nnl[l_ac].date1 = g_nne.nne33 + 1   #MOD-C50167 add
                #ELSE
                #   LET g_nnl[l_ac].date1 = g_nne.nne111
                #END IF
                #--MOD-CA0037--mark
                 SELECT MAX(nnm05) INTO l_date1 FROM nnm_file
                  WHERE nnm01 = g_nnl[l_ac].nnl04
                 SELECT MAX(nnj06) INTO l_date2
                   FROM nnj_file,nni_file
                  WHERE nnj03 = g_nnl[l_ac].nnl04
                    AND nnj01 = nni01
                    AND nniconf <> 'X'
                  CASE
                    WHEN (l_date1 IS NULL AND l_date2 IS NOT NULL)
                      LET l_date2 = l_date2 + 1
                      LET g_nnl[l_ac].date1 = l_date2
                    WHEN (l_date1 IS NOT NULL AND l_date2 IS NULL)
                      LET l_date1 = l_date1 + 1
                      LET g_nnl[l_ac].date1 = l_date1
                    WHEN (l_date1 IS NULL AND l_date2 IS NULL)
                      SELECT nne33 INTO l_date1 FROM nne_file
                       WHERE nne01 = g_nnl[l_ac].nnl04
                      IF NOT cl_null(l_date1) THEN 
                         LET l_date1 = l_date1 + 1
                      ELSE
                         LET l_date1 = g_nne.nne111
                      END IF
                      LET g_nnl[l_ac].date1 = l_date1
                    WHEN (l_date1 = l_date2)
                      LET l_date1 = l_date1 + 1
                      LET g_nnl[l_ac].date1 = l_date1
                    OTHERWISE
                      IF l_date1 > l_date2 THEN
                         LET l_date1 = l_date1 + 1
                         LET g_nnl[l_ac].date1 = l_date1
                      ELSE
                         LET l_date2 = l_date2 + 1
                         LET g_nnl[l_ac].date1 = l_date2
                      END IF
                  END CASE
                #--------------------------------MOD-CA0037-----------------------(E)
                 LET g_nnl[l_ac].date2 = g_nne.nne112
                 LET g_nnl[l_ac].nnl18 = g_nne.nneex2
                 LET g_nnl[l_ac].nnl11 = g_nne.nne12-g_nne.nne27
                 DISPLAY BY NAME g_nnl[l_ac].exrate
                 DISPLAY BY NAME g_nnl[l_ac].date1
                 DISPLAY BY NAME g_nnl[l_ac].date2
                 DISPLAY BY NAME g_nnl[l_ac].nnl18
                 DISPLAY BY NAME g_nnl[l_ac].nnl11
               #利息計算的方式應是算頭不算尾,
               #第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
                 IF g_nnk.nnk02=g_nne.nne112 THEN   #付款日期=融資截止日期
                    LET l_day = g_nnk.nnk02-g_nnl[l_ac].date1
                 ELSE
                    LET l_day = g_nnk.nnk02-g_nnl[l_ac].date1 + 1
                 END IF
                 LET l_rate2 = g_nne.nne14               #MOD-A90009 
                 LET l_curr  = g_nne.nne16               #MOD-A90009 
              END IF
              #-------------合約類中長貸------------------------
              IF g_nnl[l_ac].nnl03 = '2' THEN
                 SELECT * INTO g_nng.* FROM nng_file
                  WHERE nng01=g_nnl[l_ac].nnl04
                    AND nngconf <> 'X'                  #MOD-840003-add
                 IF STATUS THEN
                    CALL cl_err3("sel","nng_file",g_nnl[l_ac].nnl04,"",STATUS,"","sel nng:",1)  #No.FUN-660148
                    NEXT FIELD nnl04
                #-CHI-B40029-add-
                #-CHI-C30003-mark-
                #ELSE
                #   LET g_cnt = 0
                #   SELECT COUNT(*) INTO g_cnt
                #     FROM nmd_file
                #    WHERE nmd51 = '2' AND nmd52 = g_nng.nng01
                #   IF cl_null(g_cnt) THEN
                #      LET g_cnt = 0
                #   END IF
                #   IF g_cnt > 0 THEN
                #      CALL cl_err('','anm-290',1) 
                #      NEXT FIELD nnl04 
                #   END IF
                #-CHI-C30003-end-
                #-CHI-B40029-end-
                 END IF
                 #-->幣別必須要與單頭借款幣別一致,
                 #   否則在計算應計息利時多幣別會有問題
                 IF g_nng.nng18 !=g_nnk.nnk04 THEN
                    CALL cl_err(g_nng.nng18,'anm-659',0) NEXT FIELD nnl04
                 END IF
                 #-->融資資料之信貸銀行必須與單頭信貸銀行一致
                 IF g_nng.nng04 !=g_nnk.nnk05 THEN
                    CALL cl_err(g_nng.nng04,'anm-661',0) NEXT FIELD nnl04
                 END IF
                 #-->已還款
                 IF g_nng.nng21 >= g_nng.nng20 THEN
                    CALL cl_err('','anm-240',0)
                    NEXT FIELD nnl04
                 END IF
                 IF g_nng.nngconf = 'N' THEN       #未確認
                    CALL cl_err('','aap-141',0) NEXT FIELD nnl04
                 END IF
                 IF g_nng.nngconf = 'X' THEN       #已作廢
                    CALL cl_err('','9024',0) NEXT FIELD nnl04
                 END IF
                 LET g_nnl[l_ac].exrate= g_nng.nng19
                #--------------------------------MOD-CA0037-----------------------(S)
                #--MOD-CA0037--mark
                #IF NOT cl_null(g_nng.nng26) THEN
                #  #LET g_nnl[l_ac].date1 = g_nng.nng26         #MOD-C50167 mark
                #   LET g_nnl[l_ac].date1 = g_nng.nng26 + 1     #MOD-C50167 add
                #ELSE
                #   LET g_nnl[l_ac].date1 = g_nng.nng101
                #END IF
                #--MOD-CA0037--mark
                 SELECT MAX(nnm05) INTO l_date1 FROM nnm_file
                  WHERE nnm01 = g_nnl[l_ac].nnl04
                 SELECT MAX(nnj06) INTO l_date2
                   FROM nnj_file,nni_file
                  WHERE nnj03 = g_nnl[l_ac].nnl04
                    AND nnj01 = nni01
                    AND nniconf <> 'X'
                  CASE
                    WHEN (l_date1 IS NULL AND l_date2 IS NOT NULL)
                      LET l_date2 = l_date2 + 1
                      LET g_nnl[l_ac].date1 = l_date2
                    WHEN (l_date1 IS NOT NULL AND l_date2 IS NULL)
                      LET l_date1 = l_date1 + 1
                      LET g_nnl[l_ac].date1 = l_date1
                    WHEN (l_date1 IS NULL AND l_date2 IS NULL)
                      SELECT nng26 INTO l_date1 FROM nng_file
                       WHERE nng01 = g_nnl[l_ac].nnl04
                      IF NOT cl_null(l_date1) THEN 
                         LET l_date1 = l_date1 + 1
                      ELSE
                         LET l_date1 = g_nng.nng101
                      END IF
                      LET g_nnl[l_ac].date1 = l_date1
                    WHEN (l_date1 = l_date2)
                      LET l_date1 = l_date1 + 1
                      LET g_nnl[l_ac].date1 = l_date1
                    OTHERWISE
                      IF l_date1 > l_date2 THEN
                         LET l_date1 = l_date1 + 1
                         LET g_nnl[l_ac].date1 = l_date1
                      ELSE
                         LET l_date2 = l_date2 + 1
                         LET g_nnl[l_ac].date1 = l_date2
                      END IF
                  END CASE
                #--------------------------------MOD-CA0037-----------------------(E)
                 LET g_nnl[l_ac].date2 = g_nng.nng102
                 LET g_nnl[l_ac].nnl18 = g_nng.nngex2
                 LET g_nnl[l_ac].nnl11 = g_nng.nng20-g_nng.nng21
                 LET g_nnl[l_ac].nnl15 = 0
                 LET g_nnl[l_ac].nnl17 = 0
                #利息計算的方式應是算頭不算尾,
                #第一個月計息應從借款日~月底,最後一個月計息應從月初~還款日前一天
                 IF g_nnk.nnk02=g_nng.nng102 THEN   #付款日期=融資截止日期
                    LET l_day = g_nnk.nnk02-g_nnl[l_ac].date1
                 ELSE
                    LET l_day = g_nnk.nnk02-g_nnl[l_ac].date1 + 1
                 END IF
                 LET l_rate2 = g_nng.nng09                            #MOD-A90009 
                 LET l_curr  = g_nng.nng18                            #MOD-A90009
              END IF
              SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nnk.nnk04   #bug no:7011
              CALL cl_digcut(g_nnl[l_ac].nnl11,t_azi04)
                   RETURNING g_nnl[l_ac].nnl11
             #IF g_nne.nne16 = g_aza.aza17 THEN                           #CHI-A10014 mark
             #IF g_aza.aza26 = '0' AND g_nne.nne16 = g_aza.aza17 THEN     #CHI-A10014 add  #MOD-A90009 mark
              IF g_aza.aza26 = '0' AND l_curr = g_aza.aza17 THEN                           #MOD-A90009
                 LET g_i=365    # 本幣一年採365天
                #LET l_rate = g_nne.nne14 / 365                       #MOD-A90009 mark
                 LET l_rate = l_rate2 / 365                           #MOD-A90009
              ELSE
                 LET g_i=360    # 外幣一年採360天
                #LET l_rate = g_nne.nne14 / 360                       #MOD-A90009 mark
                 LET l_rate = l_rate2 / 360                           #MOD-A90009
              END IF
              #-- 原幣利息=貸款金額*(利率/100/365)*天數 -----------
              LET g_nnl[l_ac].nnl15=g_nnl[l_ac].nnl12*l_rate*l_day/100
              SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nnk.nnk08
              CALL cl_digcut(g_nnl[l_ac].nnl15,t_azi04)
                   RETURNING g_nnl[l_ac].nnl15
              #-- 本幣利息=原幣利息*Ex.Rate
              LET g_nnl[l_ac].nnl17 = g_nnl[l_ac].nnl15 * g_nnk.nnk09
              CALL cl_digcut(g_nnl[l_ac].nnl17,g_azi04)
                   RETURNING g_nnl[l_ac].nnl17
              DISPLAY BY NAME g_nnl[l_ac].nnl15   #MOD-5A0095
              DISPLAY BY NAME g_nnl[l_ac].nnl17   #MOD-5A0095
           END IF
           IF cl_null(g_nnl_t.nnl04) OR g_nnl_t.nnl04 != g_nnl[l_ac].nnl04 THEN
              IF g_nnl[l_ac].nnl03 = '1' THEN
                 LET g_nnl[l_ac].nnl13 = g_nne.nne19 - g_nne.nne20   #TQC-620046   #FUN-640021         #MOD-870275 mark回復
              ELSE
                 LET g_nnl[l_ac].nnl13 = g_nng.nng22 - g_nng.nng23   #TQC-620046   #FUN-640021         #MOD-870275 mark回復
              END IF
              CALL cl_digcut(g_nnl[l_ac].nnl13,g_azi04) RETURNING g_nnl[l_ac].nnl13
              DISPLAY BY NAME g_nnl[l_ac].nnl13
 
              #-->借款幣別與實付幣別相同時預設
              LET g_nnl[l_ac].nnl12 = g_nnl[l_ac].nnl11 * g_nnk.nnk23
              SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nnk.nnk08  #MOD-6B0069
              CALL cl_digcut(g_nnl[l_ac].nnl12,t_azi04) RETURNING g_nnl[l_ac].nnl12
              DISPLAY BY NAME g_nnl[l_ac].nnl12
 
              #-->實付本幣 = 實付原幣 * 出帳匯率
              LET g_nnl[l_ac].nnl14=g_nnl[l_ac].nnl12*g_nnk.nnk09
              CALL cl_digcut(g_nnl[l_ac].nnl14,g_azi04) RETURNING g_nnl[l_ac].nnl14
 
              LET g_nnl[l_ac].nnl15 = g_nnl[l_ac].nnl12 * l_rate * l_day / 100
              SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nnk.nnk08  #MOD-6B0069
              CALL cl_digcut(g_nnl[l_ac].nnl15,t_azi04) RETURNING g_nnl[l_ac].nnl15
 
              LET g_nnl[l_ac].nnl16 = g_nnl[l_ac].nnl13 - g_nnl[l_ac].nnl14
              CALL cl_digcut(g_nnl[l_ac].nnl16,g_azi04) RETURNING g_nnl[l_ac].nnl16
 
              #-- 本幣利息=原幣利息*Ex.Rate
              LET g_nnl[l_ac].nnl17=g_nnl[l_ac].nnl15* g_nnk.nnk09
              CALL cl_digcut(g_nnl[l_ac].nnl17,g_azi04) RETURNING g_nnl[l_ac].nnl17
              DISPLAY BY NAME g_nnl[l_ac].nnl14
              DISPLAY BY NAME g_nnl[l_ac].nnl15
              DISPLAY BY NAME g_nnl[l_ac].nnl16
              DISPLAY BY NAME g_nnl[l_ac].nnl17
           END IF
 
        AFTER FIELD nnl18   #No:8164
            IF NOT cl_null(g_nnl[l_ac].nnl18) THEN
               IF g_nnl[l_ac].nnl18 <=0 THEN
                  NEXT FIELD nnl18
               END IF
            END IF
 
        AFTER FIELD nnl11
           IF g_nnl[l_ac].nnl03 = '1' THEN
              IF g_nnl[l_ac].nnl11 > g_nne.nne12 - g_nne.nne27 THEN
                 CALL cl_err('','anm-931',0)
                 NEXT FIELD nnl11
              END IF
           ELSE
              IF g_nnl[l_ac].nnl11 > g_nng.nng20 - g_nng.nng21 THEN
                 CALL cl_err('','anm-931',0)
                 NEXT FIELD nnl11
              END IF
           END IF    
 
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nnk.nnk04  #MOD-6B0069
           CALL cl_digcut(g_nnl[l_ac].nnl11,t_azi04) RETURNING g_nnl[l_ac].nnl11
           #當最後一次還款時,還款本幣應為剩餘金額,當不是最後一次,則用原幣*匯率
           IF g_nnl[l_ac].nnl03 = '1' THEN
             #str MOD-870275 add
              IF g_nnl[l_ac].nnl11 = g_nne.nne12 - g_nne.nne27 THEN
                 LET g_nnl[l_ac].nnl13 = g_nne.nne19 - g_nne.nne20
              ELSE
             #end MOD-870275 add
                 LET g_nnl[l_ac].nnl13 = g_nnl[l_ac].nnl11 * g_nne.nne17
              END IF   #MOD-870275 add
           ELSE
             #str MOD-870275 add
              IF g_nnl[l_ac].nnl11 = g_nng.nng20-g_nng.nng21 THEN
                 LET g_nnl[l_ac].nnl13 = g_nng.nng22 - g_nng.nng23
              ELSE
             #end MOD-870275 add
                 LET g_nnl[l_ac].nnl13 = g_nnl[l_ac].nnl11 * g_nng.nng19
              END IF   #MOD-870275 add
           END IF
           CALL cl_digcut(g_nnl[l_ac].nnl13,g_azi04) RETURNING g_nnl[l_ac].nnl13
 
           LET g_nnl[l_ac].nnl12 = g_nnl[l_ac].nnl11 * g_nnk.nnk23   
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nnk.nnk08  #MOD-6B0069  
           CALL cl_digcut(g_nnl[l_ac].nnl12,t_azi04) RETURNING g_nnl[l_ac].nnl12   #MOD-6B0069
           LET g_nnl[l_ac].nnl14 = g_nnl[l_ac].nnl12 * g_nnk.nnk09   
           CALL cl_digcut(g_nnl[l_ac].nnl14,g_azi04) RETURNING g_nnl[l_ac].nnl14   
 
           DISPLAY BY NAME g_nnl[l_ac].nnl11
           DISPLAY BY NAME g_nnl[l_ac].nnl13
           DISPLAY BY NAME g_nnl[l_ac].nnl12   #FUN-640021
           DISPLAY BY NAME g_nnl[l_ac].nnl14   #FUN-640021
 
        BEFORE FIELD nnl12
            #-->借款幣別與實付幣別相同時預設
            IF g_nnk.nnk04 = g_nnk.nnk08 THEN
               LET g_nnl[l_ac].nnl12 = g_nnl[l_ac].nnl11
            ELSE
               LET g_nnl[l_ac].nnl12 = g_nnl[l_ac].nnl11 * g_nnk.nnk23
            END IF
            DISPLAY BY NAME g_nnl[l_ac].nnl12
 
        AFTER FIELD nnl12  #實付原幣
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nnk.nnk08  #MOD-6B0069
           CALL cl_digcut(g_nnl[l_ac].nnl12,t_azi04) RETURNING g_nnl[l_ac].nnl12
           #-->實付本幣 = 實付原幣 * 出帳匯率
           LET g_nnl[l_ac].nnl14=g_nnl[l_ac].nnl12*g_nnk.nnk09
           CALL cl_digcut(g_nnl[l_ac].nnl14,g_azi04) RETURNING g_nnl[l_ac].nnl14
 
           LET g_nnl[l_ac].nnl16 = g_nnl[l_ac].nnl13 - g_nnl[l_ac].nnl14
           CALL cl_digcut(g_nnl[l_ac].nnl16,g_azi04) RETURNING g_nnl[l_ac].nnl16
           LET g_nnl[l_ac].nnl15 = g_nnl[l_ac].nnl12 * l_rate * l_day / 100
           SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_nnk.nnk08  #MOD-6B0069
           CALL cl_digcut(g_nnl[l_ac].nnl15,t_azi04)
                RETURNING g_nnl[l_ac].nnl15
           #-- 本幣利息=原幣利息*Ex.Rate
           LET g_nnl[l_ac].nnl17 = g_nnl[l_ac].nnl15 * g_nnk.nnk09
           CALL cl_digcut(g_nnl[l_ac].nnl17,g_azi04)
                RETURNING g_nnl[l_ac].nnl17
           DISPLAY BY NAME g_nnl[l_ac].nnl12
           DISPLAY BY NAME g_nnl[l_ac].nnl14
           DISPLAY BY NAME g_nnl[l_ac].nnl15
           DISPLAY BY NAME g_nnl[l_ac].nnl16
           DISPLAY BY NAME g_nnl[l_ac].nnl17
 
        AFTER FIELD nnl14
           LET g_nnl[l_ac].nnl14 = cl_digcut(g_nnl[l_ac].nnl14,g_azi04)   #MOD-6B0069
           LET g_nnl[l_ac].nnl16 = g_nnl[l_ac].nnl13 - g_nnl[l_ac].nnl14
           CALL cl_digcut(g_nnl[l_ac].nnl16,g_azi04) RETURNING g_nnl[l_ac].nnl16
           DISPLAY BY NAME g_nnl[l_ac].nnl14   #MOD-6B0069
           DISPLAY BY NAME g_nnl[l_ac].nnl16
 
        AFTER FIELD nnl15
           LET g_nnl[l_ac].nnl17=g_nnl[l_ac].nnl15* g_nnk.nnk09
           CALL cl_digcut(g_nnl[l_ac].nnl17,g_azi04) RETURNING g_nnl[l_ac].nnl17
           DISPLAY BY NAME g_nnl[l_ac].nnl17
 
        AFTER FIELD nnl17
           LET g_nnl[l_ac].nnl17 = cl_digcut(g_nnl[l_ac].nnl17,g_azi04)
           DISPLAY BY NAME g_nnl[l_ac].nnl17
 
        AFTER FIELD nnlud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD nnlud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_nnl_t.nnl02 > 0 AND g_nnl_t.nnl02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
              DELETE FROM nnl_file
               WHERE nnl01 = g_nnk.nnk01
                 AND nnl02 = g_nnl_t.nnl02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","nnl_file",g_nnk.nnk01,g_nnl_t.nnl02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
              COMMIT WORK
              CALL t750_b_tot()
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_nnl[l_ac].* = g_nnl_t.*
              CLOSE t750_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_nnl[l_ac].nnl02,-263,1)
              LET g_nnl[l_ac].* = g_nnl_t.*
           ELSE
              UPDATE nnl_file SET nnl02 = g_nnl[l_ac].nnl02,
                                  nnl03 = g_nnl[l_ac].nnl03,
                                  nnl04 = g_nnl[l_ac].nnl04,
                                  nnl11 = g_nnl[l_ac].nnl11,
                                  nnl12 = g_nnl[l_ac].nnl12,
                                  nnl13 = g_nnl[l_ac].nnl13,
                                  nnl14 = g_nnl[l_ac].nnl14,
                                  nnl15 = g_nnl[l_ac].nnl15,
                                  nnl16 = g_nnl[l_ac].nnl16,
                                  nnl17 = g_nnl[l_ac].nnl17,
                                  nnl18 = g_nnl[l_ac].nnl18,
                                  nnlud01 = g_nnl[l_ac].nnlud01,
                                  nnlud02 = g_nnl[l_ac].nnlud02,
                                  nnlud03 = g_nnl[l_ac].nnlud03,
                                  nnlud04 = g_nnl[l_ac].nnlud04,
                                  nnlud05 = g_nnl[l_ac].nnlud05,
                                  nnlud06 = g_nnl[l_ac].nnlud06,
                                  nnlud07 = g_nnl[l_ac].nnlud07,
                                  nnlud08 = g_nnl[l_ac].nnlud08,
                                  nnlud09 = g_nnl[l_ac].nnlud09,
                                  nnlud10 = g_nnl[l_ac].nnlud10,
                                  nnlud11 = g_nnl[l_ac].nnlud11,
                                  nnlud12 = g_nnl[l_ac].nnlud12,
                                  nnlud13 = g_nnl[l_ac].nnlud13,
                                  nnlud14 = g_nnl[l_ac].nnlud14,
                                  nnlud15 = g_nnl[l_ac].nnlud15
               WHERE nnl01=g_nnk.nnk01 AND nnl02=g_nnl_t.nnl02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","nnl_file",g_nnk.nnk01,g_nnl_t.nnl02,SQLCA.sqlcode,"","",1)  #No.FUN-660148
                 LET g_nnl[l_ac].* = g_nnl_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac       #FUN-D30032 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_nnl[l_ac].* = g_nnl_t.*
               #FUN-D30032--add--str--
               ELSE
                  CALL g_nnl.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D30032--add--end-- 
               END IF
               CLOSE t750_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac       #FUN-D30032 Add
            CLOSE t750_bcl
            COMMIT WORK
            CALL t750_b_tot()
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(nnl02) AND l_ac > 1 THEN
              LET g_nnl[l_ac].* = g_nnl[l_ac-1].*
              LET g_nnl[l_ac].nnl02 = NULL  #TQC-620018
              NEXT FIELD nnl02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLP
          CASE
             WHEN INFIELD(nnl04)
                IF g_nnl[l_ac].nnl03 = '1' THEN
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nne"
                   LET g_qryparam.default1 = g_nnl[l_ac].nnl04
                   LET g_qryparam.arg1 = g_nnk.nnk05   #CHI-8A0030 add
                   CALL cl_create_qry() RETURNING g_nnl[l_ac].nnl04
                ELSE
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_nng"
                   LET g_qryparam.default1 = g_nnl[l_ac].nnl04
                   LET g_qryparam.arg1 = g_nnk.nnk05   #CHI-8A0030 add
                   CALL cl_create_qry() RETURNING g_nnl[l_ac].nnl04
                END IF
                 DISPLAY BY NAME g_nnl[l_ac].nnl04        #No.MOD-490344
                NEXT FIELD nnl04
             OTHERWISE EXIT CASE
          END CASE
 
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
 
    LET g_nnk.nnkmodu = g_user
    LET g_nnk.nnkdate = g_today
    UPDATE nnk_file SET nnkmodu = g_nnk.nnkmodu,nnkdate = g_nnk.nnkdate
     WHERE nnk01 = g_nnk.nnk01
    DISPLAY BY NAME g_nnk.nnkmodu,g_nnk.nnkdate
 
    CALL t750_b_tot()
 
    CLOSE t750_bcl
    COMMIT WORK
    CALL t750_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t750_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_nnk.nnk01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM nnk_file ",
                  "  WHERE nnk01 LIKE '",l_slip,"%' ",
                  "    AND nnk01 > '",g_nnk.nnk01,"'"
      PREPARE t750_pb1 FROM l_sql 
      EXECUTE t750_pb1 INTO l_cnt       
      
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
         CALL t750_v()
         IF g_nnk.nnkconf='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_nnk.nnkconf,"","","",g_void,g_nnk.nnkacti)
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM npp_file
          WHERE nppsys='NM' AND npp00=7 AND npp01=g_nnk.nnk01 AND npp011=0
         DELETE FROM npq_file
          WHERE npqsys='NM' AND npq00=7 AND npq01=g_nnk.nnk01 AND npq011=0
         DELETE FROM tic_file WHERE tic04 = g_nnk.nnk01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM nnk_file WHERE nnk01 = g_nnk.nnk01
         INITIALIZE g_nnk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t750_b_tot()
  DEFINE l_tot1,l_tot2   LIKE type_file.num20_6  #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
   SELECT SUM(nnl11),SUM(nnl12),SUM(nnl13),SUM(nnl14),SUM(nnl16),
          SUM(nnl15),SUM(nnl17)
          INTO g_nnk.nnk11,g_nnk.nnk12,g_nnk.nnk13,g_nnk.nnk14,g_nnk.nnk16,
               l_tot1 ,l_tot2
          FROM nnl_file
         WHERE nnl01 = g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err3("sel","nnl_file",g_nnk.nnk01,"",STATUS,"","sel sum(nnl11-17):",1)  #No.FUN-660148
      LET g_success='N'
   END IF
   IF g_nnk.nnk11 IS NULL THEN LET g_nnk.nnk11 = 0 END IF
   IF g_nnk.nnk12 IS NULL THEN LET g_nnk.nnk12 = 0 END IF
   IF g_nnk.nnk13 IS NULL THEN LET g_nnk.nnk13 = 0 END IF
   IF g_nnk.nnk14 IS NULL THEN LET g_nnk.nnk14 = 0 END IF
   IF g_nnk.nnk16 IS NULL THEN LET g_nnk.nnk16 = 0 END IF
   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=g_nnk.nnk04   #MOD-6B0069
   CALL cl_digcut(g_nnk.nnk11,t_azi05) RETURNING g_nnk.nnk11
   SELECT azi05 INTO t_azi05 FROM azi_file WHERE azi01=g_nnk.nnk08
   CALL cl_digcut(g_nnk.nnk12,t_azi05) RETURNING g_nnk.nnk12
   CALL cl_digcut(g_nnk.nnk13,g_azi05) RETURNING g_nnk.nnk13
   CALL cl_digcut(g_nnk.nnk14,g_azi05) RETURNING g_nnk.nnk14
   CALL cl_digcut(g_nnk.nnk16,g_azi05) RETURNING g_nnk.nnk16
   DISPLAY BY NAME g_nnk.nnk11,g_nnk.nnk12,g_nnk.nnk13,g_nnk.nnk14,g_nnk.nnk16
   UPDATE nnk_file SET nnk11 = g_nnk.nnk11,
                       nnk12 = g_nnk.nnk12,
                       nnk13 = g_nnk.nnk13,
                       nnk14 = g_nnk.nnk14,
                       nnk16 = g_nnk.nnk16
    WHERE nnk01=g_nnk.nnk01
   IF cl_null(l_tot1) THEN LET l_tot1 = 0 END IF
   IF cl_null(l_tot2) THEN LET l_tot2 = 0 END IF
  #CALL cl_digcut(l_tot1,t_azi05) RETURNING l_tot1  #MOD-B70044 mark
  #CALL cl_digcut(l_tot2,g_azi05) RETURNING l_tot2  #MOD-B70044 mark
   DISPLAY l_tot1,l_tot2 TO tot1,tot2
END FUNCTION
 
FUNCTION t750_b_askkey()
DEFINE
   l_wc2  STRING #No.FUN-680107 VARCHAR(200) #MOD-BA0015 char1000 -> STRING
 
   CONSTRUCT g_wc2 ON nnl02,nnl03,nnl04,nnl18
                      ,nnlud01,nnlud02,nnlud03,nnlud04,nnlud05
                      ,nnlud06,nnlud07,nnlud08,nnlud09,nnlud10
                      ,nnlud11,nnlud12,nnlud13,nnlud14,nnlud15
           FROM s_nnl[1].nnl02,s_nnl[1].nnl03,s_nnl[1].nnl04,s_nnl[1].nnl18
                ,s_nnl[1].nnlud01,s_nnl[1].nnlud02,s_nnl[1].nnlud03
                ,s_nnl[1].nnlud04,s_nnl[1].nnlud05,s_nnl[1].nnlud06
                ,s_nnl[1].nnlud07,s_nnl[1].nnlud08,s_nnl[1].nnlud09
                ,s_nnl[1].nnlud10,s_nnl[1].nnlud11,s_nnl[1].nnlud12
                ,s_nnl[1].nnlud13,s_nnl[1].nnlud14,s_nnl[1].nnlud15
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
   CALL t750_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t750_b_fill(p_wc2)      #BODY FILL UP
DEFINE
   p_wc2  STRING #No.FUN-680107 VARCHAR(200) #MOD-BA0015 mod char1000 -> STRING
 
   LET g_sql = "SELECT nnl02,nnl03,nnl04,'',nnl18,'','',",
               "       nnl11,nnl13,nnl12,nnl14,nnl15,nnl17,nnl16, ",
               "       nnlud01,nnlud02,nnlud03,nnlud04,nnlud05,",
               "       nnlud06,nnlud07,nnlud08,nnlud09,nnlud10,",
               "       nnlud11,nnlud12,nnlud13,nnlud14,nnlud15 ", 
               " FROM nnl_file",
               " WHERE nnl01 ='",g_nnk.nnk01,"'",
               " ORDER BY 1"
   PREPARE t750_pb FROM g_sql
   DECLARE nnl_curs CURSOR FOR t750_pb
 
   CALL g_nnl.clear()
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH nnl_curs INTO g_nnl[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
      END IF
      IF g_nnl[g_cnt].nnl03='1' THEN
         INITIALIZE g_nne.* TO NULL
         SELECT * INTO g_nne.* FROM nne_file WHERE nne01=g_nnl[g_cnt].nnl04
         LET g_nnl[g_cnt].exrate=g_nne.nne17
         IF NOT cl_null(g_nne.nne33) THEN
           #LET g_nnl[g_cnt].date1=g_nne.nne33        #MOD-C50167 mark
            LET g_nnl[g_cnt].date1=g_nne.nne33 + 1    #MOD-C50167 add
         ELSE
            LET g_nnl[g_cnt].date1=g_nne.nne111
         END IF
         LET g_nnl[g_cnt].date2=g_nne.nne112
      END IF
      IF g_nnl[g_cnt].nnl03='2' THEN
         INITIALIZE g_nng.* TO NULL
         SELECT * INTO g_nng.* FROM nng_file WHERE nng01=g_nnl[g_cnt].nnl04
         LET g_nnl[g_cnt].exrate=g_nng.nng19
         IF NOT cl_null(g_nng.nng26) THEN
           #LET g_nnl[g_cnt].date1=g_nng.nng26          #MOD-C50167 mark
            LET g_nnl[g_cnt].date1=g_nng.nng26 + 1      #MOD-C50167 add
         ELSE
            LET g_nnl[g_cnt].date1=g_nng.nng101
         END IF
         LET g_nnl[g_cnt].date2=g_nng.nng102
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_nnl.deleteElement(g_cnt)   #取消 Array Element
   LET g_rec_b=(g_cnt-1)
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t750_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_nnl TO s_nnl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_act_visible("maintain_entry_sheet2",TRUE)
         ELSE
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
      ON ACTION first
         CALL t750_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505  #FUN-6A0011 mod fgl_fet_arr_curr -> fgl_set_arr_curr
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t750_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t750_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t750_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t750_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 產生應付票據
      ON ACTION gen_n_p
         LET g_action_choice="gen_n_p"
         EXIT DISPLAY
      #@ON ACTION 應付票據修改
      ON ACTION modify_n_p
         LET g_action_choice="modify_n_p"
         EXIT DISPLAY
      #@ON ACTION 應付票據還原
      ON ACTION undo_n_p
         LET g_action_choice="undo_n_p"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿產生
      ON ACTION gen_entry_sheet
         LET g_action_choice="gen_entry_sheet"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿維護
      ON ACTION maintain_entry_sheet
         LET g_action_choice="maintain_entry_sheet"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿維護2
      ON ACTION maintain_entry_sheet2
         LET g_action_choice="maintain_entry_sheet2"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
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
         EXIT DISPLAY  #TQC-5B0076
 
      ON ACTION related_document                #No.FUN-6A0011  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      &include "qry_string.4gl"
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t750_g_gl(p_trno,p_npptype)         #No.FUN-680088
   DEFINE p_npptype   LIKE npp_file.npptype  #No.FUN-680088
   DEFINE p_trno      LIKE npq_file.npq01    #No.FUN-680107 VARCHAR(20)
   DEFINE l_buf       LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(70)
   DEFINE l_n         LIKE type_file.num5,   #No.FUN-680107 SMALLINT
          l_t         LIKE nmy_file.nmyslip, #No.FUN-680107 VARCHAR(05) #No.FUN-550057
          l_nmydmy3   LIKE nmy_file.nmydmy3
 
    LET g_success = 'Y'       #No.FUN-680088
    BEGIN WORK
 
    OPEN t750_cl USING g_nnk.nnk01
    IF STATUS THEN
       CALL cl_err("OPEN t750_cl:", STATUS, 1)
       CLOSE t750_cl
       LET g_success = 'N'      #No.FUN-680088
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t750_cl INTO g_nnk.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)
        LET g_success = 'N'      #No.FUN-680088
        CLOSE t750_cl ROLLBACK WORK RETURN 
    ELSE 
        COMMIT WORK
    END IF
   SELECT * INTO g_nnk.* FROM nnk_file WHERE nnk01 = g_nnk.nnk01
   IF p_trno IS NULL THEN RETURN END IF
   IF g_nnk.nnkconf='X' THEN RETURN END IF  #CHI-C80041
   IF g_nnk.nnkconf='Y' THEN 
      CALL cl_err(g_nnk.nnk01,'anm-232',0)
      LET g_success = 'N'      #No.FUN-680088
      RETURN
   END IF
   #-->立帳日期不可小於關帳日期
   IF g_nnk.nnk02 <= g_nmz.nmz10 THEN #no.5261
      CALL cl_err(g_nnk.nnk01,'aap-176',1) RETURN
      LET g_success = 'N'      #No.FUN-680088
   END IF
   IF NOT cl_null(g_nnk.nnkglno) THEN
      CALL cl_err(g_nnk.nnk01,'aap-122',1) RETURN
      LET g_success = 'N'      #No.FUN-680088
   END IF
   #判斷該單別是否須拋轉總帳
   LET l_t= s_get_doc_no(p_trno)       #No.FUN-550057
   SELECT nmydmy3 INTO l_nmydmy3 FROM nmy_file WHERE nmyslip = l_t
   IF STATUS OR cl_null(l_nmydmy3) THEN LET l_nmydmy3 = 'N' END IF
   IF l_nmydmy3 = 'N' THEN 
      LET g_success = 'N'      #No.FUN-680088
      RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_n FROM npq_file
    WHERE npqsys='NM' AND npq00=7 AND npq01=p_trno AND npq011=0
   IF l_n > 0 THEN
      IF p_npptype = '0' THEN
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
          WHERE npqsys='NM' AND npq00=7 AND npq01=p_trno AND npq011=0
      END IF
   END IF
   INITIALIZE g_npp.* TO NULL
   LET g_npp.nppsys='NM'
   LET g_npp.npp00 =7
   LET g_npp.npp01 =p_trno
   LET g_npp.npp011=0
   LET g_npp.npp02 =g_nnk.nnk02
   LET g_npp.npptype = p_npptype      #No.FUN-680088
 
   LET g_npp.npplegal= g_legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN #TQC-790091 mod
      UPDATE npp_file SET npp02=g_npp.npp02
       WHERE nppsys='NM' AND npp00=7 AND npp01=p_trno AND npp011=0
         AND npptype = p_npptype      #No.FUN-680088
      IF SQLCA.SQLCODE THEN 
         CALL cl_err3("upd","nnp_file",p_trno,"",STATUS,"","upd npp:",1)  #No.FUN-660148
         LET g_success = 'N'      #No.FUN-680088
         RETURN END IF
   END IF
   IF SQLCA.SQLCODE THEN 
      CALL cl_err3("ins","nnp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp:",1)  #No.FUN-660148
      LET g_success = 'N'      #No.FUN-680088
      RETURN END IF
   CALL t750_g_gl_1(p_trno,p_npptype)      #No.FUN-680088
   CALL t750_gen_diff()                     #No.FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021    
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t750_g_gl_1(p_trno,p_npptype)
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680088
   DEFINE p_trno        LIKE alk_file.alk01
   DEFINE l_nnl         RECORD LIKE nnl_file.*
   DEFINE amt1,amt2,amt3,amt4  LIKE type_file.num20_6 #No.FUN-680107 DEC(20,6) #No.FUN-4C0010
   DEFINE l_nnl15       LIKE nnl_file.nnl15
   DEFINE l_nnl17       LIKE nnl_file.nnl17
   DEFINE l_nma05       LIKE nma_file.nma05
   DEFINE l_nma051      LIKE nma_file.nma05    #No.FUN-680088
   DEFINE l_nma10       LIKE nma_file.nma10
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_nnm11       LIKE nnm_file.nnm11
   DEFINE l_nnm12       LIKE nnm_file.nnm12
 
   DEFINE l_nnl04       LIKE nnl_file.nnl04    # 融資單號
   DEFINE l_nnl03       LIKE nnl_file.nnl03    # 1:短借 ,2:長借
   DEFINE l_nne28       LIKE nne_file.nne28    # 參考單號
   DEFINE l_grup        LIKE nne_file.nnegrup  # 融資單記錄的keyin人員所屬部門
   DEFINE l_grup_lc     LIKE nne_file.nnegrup  # 到單單號記錄的部門
   DEFINE l_dbs         LIKE ooy_file.ooytype  #No.FUN-680107 VARCHAR(2)                # 廠別資料庫
   DEFINE g_sql         string                 #No.FUN-580092 HCN
   DEFINE l_aaa03       LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE l_azi04_2     LIKE azi_file.azi04    #FUN-A40067
   DEFINE l_diffamt     LIKE npq_file.npq07    #MOD-AA0072
   DEFINE l_nne25       LIKE nne_file.nne25    #本票折價             #MOD-CA0191 add
   DEFINE l_nne_d2      LIKE nne_file.nne_d2   #貸方科目-折價/利息   #MOD-CA0191 add
   DEFINE l_nne_d21     LIKE nne_file.nne_d21  #貸方科目二-折價/利息 #MOD-CA0191 add
   DEFINE l_flag        LIKE type_file.chr1    #FUN-D40118 add
 
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = g_npp.nppsys
   LET g_npq.npq00  = g_npp.npp00
   LET g_npq.npq01  = g_npp.npp01
   LET g_npq.npq011 = g_npp.npp011
   LET g_npq.npq02  = 0
   LET g_npq.npqtype = p_npptype      #No.FUN-680088
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
   #------------------------------------------------ Dr:借/貸款
   DECLARE t750_g_gl_c1 CURSOR FOR
      SELECT * FROM nnl_file WHERE nnl01=g_nnk.nnk01 ORDER By 1,2
   FOREACH t750_g_gl_c1 INTO l_nnl.*
 
      SELECT nnl04,nnl03 INTO l_nnl04,l_nnl03
          FROM nnl_file
          WHERE nnl01 = p_trno
            AND nnl02 = l_nnl.nnl02   #TQC-960333 add
 
      IF l_nnl03 = '1' THEN
      ELSE
          SELECT nnggrup INTO l_grup
            FROM nng_file
           WHERE nng01 = l_nnl04
      END IF
 
      #-->取科目&匯率
      IF l_nnl.nnl03='1' THEN   #短期融資
        IF p_npptype = '0' THEN
           SELECT nne_c1,nne17 INTO g_npq.npq03,g_npq.npq25 FROM nne_file
            WHERE nne01=l_nnl.nnl04 AND nneconf <> 'X'
        ELSE
           SELECT nne_c11,nne17 INTO g_npq.npq03,g_npq.npq25 FROM nne_file
            WHERE nne01=l_nnl.nnl04 AND nneconf <> 'X'
        END IF
      ELSE                      #中長期合約
        IF p_npptype = '0' THEN
           SELECT nng_c1,nng19 INTO g_npq.npq03,g_npq.npq25 FROM nng_file
            WHERE nng01= l_nnl.nnl04 AND nngconf <> 'X'
        ELSE
           SELECT nng_c11,nng19 INTO g_npq.npq03,g_npq.npq25 FROM nng_file
            WHERE nng01= l_nnl.nnl04 AND nngconf <> 'X'
        END IF
      END IF
      LET g_npq25     = g_npq.npq25                  #No.FUN-9A0036
      LET g_npq.npq02 = g_npq.npq02+1
      LET g_npq.npq04 = NULL                        #MOD-BA0015 
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f= l_nnl.nnl11                 #實付原幣   #FUN-640021
      LET g_npq.npq07 = l_nnl.nnl13                 #實付本幣   #FUN-640021
      LET g_npq.npq24 = g_nnk.nnk04
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
       RETURNING  g_npq.*
 
      LET g_npq.npqlegal= g_legal
      IF g_npq.npq07<>0 THEN #MOD-980222
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
      ELSE #MOD-980222
         LET g_npq.npq02=g_npq.npq02-1 #MOD-980222
      END IF #MOD-980222
      IF STATUS THEN 
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq:d1:",1)  #No.FUN-660148
         LET g_success = 'N'      #No.FUN-680088
      END IF
   END FOREACH
   SELECT SUM(nnl15),SUM(nnl17) INTO l_nnl15,l_nnl17
     FROM nnl_file WHERE nnl01=g_nnk.nnk01
   IF cl_null(l_nnl15) THEN LET l_nnl15 = 0 END IF
   IF cl_null(l_nnl17) THEN LET l_nnl17 = 0 END IF
   #-->產生應付利息(原幣nnl15)(本幣nnl17)
   IF l_nnl15 > 0 OR l_nnl17 > 0 THEN
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = g_nms.nms60   #利息費用
      ELSE
         LET g_npq.npq03 = g_nms.nms601
      END IF
      LET g_npq.npq06 = '1'
 
#nnk23 的判斷
      IF g_nnk.nnk23 = 1 THEN
         LET g_npq.npq24 = g_nnk.nnk08   #MOD-840093-modify   #FUN-640021
         LET g_npq.npq25 = g_nnk.nnk09   #MOD-840093-modify   #FUN-640021
      ELSE
         IF l_nnl.nnl03='1' THEN   #短期融資
           SELECT nne16,nne17 INTO g_npq.npq24,g_npq.npq25 FROM nne_file
            WHERE nne01=l_nnl.nnl04 AND nneconf <> 'X'
         ELSE                      #中長期合約
           SELECT nng18,nng19 INTO g_npq.npq24,g_npq.npq25 FROM nng_file
            WHERE nng01= l_nnl.nnl04 AND nngconf <> 'X'
         END IF
      END IF
      LET g_npq25     = g_npq.npq25                  #No.FUN-9A0036
 
      LET g_npq.npq07f = l_nnl15 / g_nnk.nnk23   #FUN-670108
      LET g_npq.npq07 = l_nnl17
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
      IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
      SELECT SUM(nnm11),SUM(nnm12) INTO l_nnm11,l_nnm12 
        FROM nnm_file
       WHERE nnm13 IS NULL 
         AND nnm01 IN (SELECT nnl04 FROM nnl_file WHERE nnl01 = g_nnk.nnk01)
         AND ((nnm02 = YEAR(g_nnk.nnk02)                                      #MOD-C20057 add
         AND nnm03 <= MONTH(g_nnk.nnk02)) OR (nnm02 < YEAR(g_nnk.nnk02)))     #MOD-C20057 add
      IF cl_null(l_nnm11) THEN LET l_nnm11 = 0 END IF
      IF cl_null(l_nnm12) THEN LET l_nnm12 = 0 END IF
      IF l_nnm11 > 0 OR l_nnm12 > 0 THEN
         #nmz52!=Y,融資暫估利息,次月不回轉,要切應付利息暫估分錄,
         #所以在產生利息費用分錄時金額需扣除暫估利息金額
         IF g_nmz.nmz52!='Y' THEN   #MOD-8C0225 add
           #LET g_npq.npq07 = g_npq.npq07 - l_nnm12           #MOD-AA0072 mark
            LET l_diffamt = g_npq.npq07 - l_nnm12             #MOD-AA0072 
            IF l_diffamt < 0 THEN LET l_diffamt = 0 END IF    #MOD-B90258
            LET g_npq.npq07f= g_npq.npq07f- l_nnm11
           #LET g_npq.npq07 = g_npq.npq07f * g_nnk.nnk09      #MOD-AA0072 #MOD-C20237 mark
            LET g_npq.npq07 = l_diffamt                       #MOD-C20237 add
            LET g_npq.npq25 = g_npq.npq07 / g_npq.npq07f      #MOD-C20237 add
         END IF                     #MOD-8C0225 add
         IF g_npq.npq07 < 0 THEN
            LET g_npq.npq06 = '2'
            LET g_npq.npq07 = g_npq.npq07 * -1
            LET g_npq.npq07f = g_npq.npq07f * -1
         END IF
         LET g_npq.npq04 = NULL                        #MOD-BA0015 
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
          RETURNING  g_npq.*
         
         LET g_npq.npqlegal= g_legal
         IF g_npq.npq07<>0 THEN #MOD-980222    
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
               CALL s_newrate(g_bookno1,g_bookno2,
                              g_npq.npq24,g_npq25,g_npp.npp02)
               RETURNING g_npq.npq25
               LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
 #             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
            ELSE
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            END IF
           #IF l_diffamt > 0 THEN                                #MOD-B90258 #MOD-C20237 mark
           #   LET l_diffamt = g_npq.npq07 - l_diffamt           #MOD-AA0072 #MOD-C20237 mark
           #END IF                                               #MOD-B90258 #MOD-C20237 mark
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
         ELSE #MOD-980222                                                                                                           
            LET g_npq.npq02=g_npq.npq02-1 #MOD-980222                                                                               
            LET l_diffamt = l_diffamt * -1 #MOD-B40256 
         END IF  #MOD-980222  
         IF STATUS THEN 
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
            LET g_success = 'N'      #No.FUN-680088
         END IF
         #nmz52!=Y,融資暫估利息,次月不回轉,則要切應付利息暫估分錄
         IF g_nmz.nmz52!='Y' THEN   #MOD-8C0225 add
            LET g_npq.npq02 = g_npq.npq02+1
            IF p_npptype = '0' THEN
               LET g_npq.npq03 = g_nms.nms64   #應付利息暫估
            ELSE
               LET g_npq.npq03 = g_nms.nms641
            END IF
            LET g_npq.npq04 = NULL                        #MOD-BA0015 
            LET g_npq.npq06 = '1'
            LET g_npq.npq07f = l_nnm11
            LET g_npq.npq07 = l_nnm12
           #-MOD-B40256-add-
            LET g_npq.npq25 = l_nnm12/l_nnm11
            LET t_azi07=0
            SELECT azi07 INTO t_azi07 FROM azi_file WHERE azi01=g_npq.npq24
            IF cl_null(t_azi07) THEN LET t_azi07=0 END IF
            LET g_npq.npq25 = cl_digcut(g_npq.npq25,t_azi07)
           #-MOD-B40256-end-
            IF g_npq.npq07 > 0 OR g_npq.npq07f > 0 THEN
               CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
                RETURNING  g_npq.*
              
               LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
               IF p_npptype = '1' THEN
                  CALL s_newrate(g_bookno1,g_bookno2,
                                 g_npq.npq24,g_npq25,g_npp.npp02)
                  RETURNING g_npq.npq25
                  LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#                 LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
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
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
                  LET g_success = 'N'      #No.FUN-680088
               END IF
            END IF
         END IF   #MOD-8C0225 add
      ELSE
         IF g_npq.npq07 > 0 OR g_npq.npq07f > 0 THEN
            LET g_npq.npq04 = NULL                        #MOD-BA0015 
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
             RETURNING  g_npq.*
              
            LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
            IF p_npptype = '1' THEN
               CALL s_newrate(g_bookno1,g_bookno2,
                              g_npq.npq24,g_npq25,g_npp.npp02)
               RETURNING g_npq.npq25
               LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
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
               CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_d2:",1)  #No.FUN-660148
               LET g_success = 'N'      #No.FUN-680088
            END IF
         END IF
      END IF
   END IF
  #-MOD-AA0072-add-
  #IF l_diffamt <> 0 THEN                         #MOD-C20237 mark
  #   LET g_nnk.nnk16 = g_nnk.nnk16 + l_diffamt   #MOD-C20237 mark
  #END IF                                         #MOD-C20237 mark
  #-MOD-AA0072-end-
   #------------------------------------------------ Cr:Diff-匯差
   LET g_npq.npq25 = g_nnk.nnk09
   LET g_npq25     = g_npq.npq25                  #No.FUN-9A0036
 
   #nnk16=實付-借款-> >0:匯差 ,<0:匯盈
   IF g_nnk.nnk16 !=0 THEN #No.+235 010615 BY PLUM
      LET g_npq.npq24=g_aza.aza17   #FUN-640021
      LET g_npq.npq25=1   #FUN-640021
      LET g_npq25     = g_npq.npq25                  #No.FUN-9A0036
      IF g_nnk.nnk16 < 0 THEN   #FUN-640021
         LET g_npq.npq02 = g_npq.npq02+1       #Dr:匯損
         IF g_aza.aza63 = 'N' THEN            #MOD-840009-modify
            LET g_npq.npq03 = g_nms.nms13
         ELSE
            LET g_npq.npq03 = g_nms.nms131
         END IF
         LET g_npq.npq04 = NULL                        #MOD-BA0015 
         LET g_npq.npq06 = '1'
         LET g_npq.npq07f= 0
         LET g_npq.npq07 = g_nnk.nnk16 * -1  #FUN-640021
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
          RETURNING  g_npq.*
           
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
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_cl:",1)  #No.FUN-660148
            LET g_success = 'N'      #No.FUN-680088
         END IF
      ELSE
         LET g_npq.npq02 = g_npq.npq02+1      #Cr:匯盈
         IF g_aza.aza63 = 'N' THEN             #MOD-840009-modify
            LET g_npq.npq03 = g_nms.nms12
         ELSE
            LET g_npq.npq03 = g_nms.nms121
         END IF
         LET g_npq.npq04 = NULL                        #MOD-BA0015 
         LET g_npq.npq06 = '2'
         LET g_npq.npq07f= 0
         LET g_npq.npq07 = g_nnk.nnk16    #FUN-640021
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
          RETURNING  g_npq.*
            
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
            CALL cl_err('ins npq_c1:',STATUS,1) 
            LET g_success = 'N'      #No.FUN-680088
         END IF
      END IF
   END IF
 
   #----------------------------------------- Dr&Cr:手續費
   LET g_npq.npq14 = ' '
   IF g_nnk.nnk17 <> 0 THEN
      LET l_nma05 = ''
      LET l_nma10 = ''
      #------------------------------------------------ Dr:手續費(nms58)
      #-->取手續費銀行會計科目(nma05)&幣別(nma10)
      SELECT nma05,nma051,nma10 INTO l_nma05,l_nma051,l_nma10 FROM nma_file      #No.FUN-680088
       WHERE nma01 = g_nnk.nnk18
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = g_nms.nms58   #手續費(nms58)
      ELSE
         LET g_npq.npq03 = g_nms.nms581
      END IF
      LET g_npq.npq04 = NULL                        #MOD-BA0015 
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f= g_nnk.nnk17
      LET g_npq.npq07 = g_nnk.nnk17*g_nnk.nnk09   #MOD-850231
      LET g_npq.npq24 = l_nma10
      LET g_npq.npq25 = g_nnk.nnk09   #MOD-850231
      LET g_npq25     = g_npq.npq25                  #No.FUN-9A0036
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
       RETURNING  g_npq.*
        
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
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
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c3:",1)  #No.FUN-660148
         LET g_success = 'N'      #No.FUN-680088
      END IF
      #------------------------------------------------ Cr:手續費(nma05)
      LET g_npq.npq02 = g_npq.npq02+1
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = l_nma05  #銀行存款
      ELSE
         LET g_npq.npq03 = l_nma051
      END IF
      LET g_npq.npq04 = NULL                        #MOD-BA0015 
      LET g_npq.npq05 = ' '
      LET g_npq.npq06 = '2'
      LET g_npq.npq07f= g_nnk.nnk17
      LET g_npq.npq07 = g_nnk.nnk17*g_nnk.nnk09   #MOD-850231
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
       RETURNING  g_npq.*
       
      LET g_npq.npqlegal= g_legal
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
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
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c4:",1)  #No.FUN-660148
         LET g_success = 'N'      #No.FUN-680088
      END IF
   END IF
 
  #--------------------MOD-CA0191--------------------(S)
  #貸：預付費用
   IF g_nmz.nmz52 = 'Y' THEN
      SELECT nne25,nne_d2,nne_d21
        INTO l_nne25,l_nne_d2,l_nne_d21
        FROM nne_file
       WHERE nne01 = l_nnl.nnl04
      IF cl_null(l_nne25) THEN
         LET l_nne25 = 0
      END IF
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq04 = NULL
      LET g_npq.npq06 = '2'
      LET g_npq.npq07f= l_nne25
      LET g_npq.npq07 = g_npq.npq07f * g_nnk.nnk09
      IF p_npptype = '0' THEN
         LET g_npq.npq03 = l_nne_d2
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01 = g_npq.npq03
            AND aag00 = g_bookno1
      ELSE
         LET g_npq.npq03 = l_nne_d21
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01 = g_npq.npq03
            AND aag00 = g_bookno2
      END IF
      IF l_aag05 = 'N' THEN
         LET g_npq.npq05 = ''
      ELSE
         LET g_npq.npq05 = g_nnk.nnk05
      END IF
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)
           RETURNING  g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3)
           RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
      IF cl_null(g_npq.npq07) THEN LET g_npq.npq07 = 0 END IF
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f = 0 END IF
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
              RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)
      END IF
      LET g_npq.npqlegal = g_legal
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
         CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c5:",1)
         LET g_success='N'
      END IF
   END IF
  #--------------------MOD-CA0191--------------------(E)

   #------------------------------------------------ Cr:Cash/NP
   LET g_npq.npq02 = g_npq.npq02+1
   IF p_npptype = '0' THEN
      LET g_npq.npq03 = g_nnk.nnk10
   ELSE
      LET g_npq.npq03 = g_nnk.nnk101
   END IF
   LET g_npq.npq04 = NULL                        #MOD-BA0015 
   LET g_npq.npq06 = '2'
   LET g_npq.npq07f= g_nnk.nnk12+l_nnl15  
   LET g_npq.npq07 = g_nnk.nnk14+l_nnl17  
  #--------------------MOD-CA0191---------------(S)
   IF g_nmz.nmz52 = 'Y' THEN         #需扣除預付費用
      LET g_npq.npq07f= g_npq.npq07f - l_nne25
      LET g_npq.npq07 = g_npq.npq07f * g_nnk.nnk09
   END IF
  #--------------------MOD-CA0191---------------(E)
   LET g_npq.npq24 = g_nnk.nnk08   #FUN-640021
   LET g_npq.npq25 = g_nnk.nnk09   #FUN-640021
   LET g_npq25     = g_npq.npq25                  #No.FUN-9A0036
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
    RETURNING  g_npq.*
 
   LET g_npq.npqlegal= g_legal
   IF g_npq.npq07<>0 THEN #MOD-980222
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
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
   ELSE #MOD-980222
      LET g_npq.npq02=g_npq.npq02-1 #MOD-980222
   END IF #MOD-980222 
   IF STATUS THEN 
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq_c2:",1)  #No.FUN-660148
      LET g_success = 'N'      #No.FUN-680088
   END IF
END FUNCTION
 
FUNCTION t750_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("nnk01",TRUE)
    END IF
    CALL cl_set_comp_entry("nnk21",TRUE)   #MOD-5C0143
 
END FUNCTION
 
FUNCTION t750_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("nnk01",FALSE)
    END IF
    IF g_nnk.nnk07 <> '1' THEN   #MOD-5C0143
       CALL cl_set_comp_entry("nnk21",FALSE)   #MOD-5C0143
    END IF   #MOD-5C0143
END FUNCTION
 
FUNCTION t750_gen_glcr(p_nnk,p_nmy)
  DEFINE p_nnk     RECORD LIKE nnk_file.*
  DEFINE p_nmy     RECORD LIKE nmy_file.*
 
    IF cl_null(p_nmy.nmygslp) THEN
       CALL cl_err(p_nnk.nnk01,'axr-070',1)
       LET g_success = 'N'
       RETURN
    END IF       
    CALL t750_g_gl(g_nnk.nnk01,'0')
    IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
       CALL t750_g_gl(g_nnk.nnk01,'1')
    END IF
    IF g_success = 'N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t750_carry_voucher()
  DEFINE l_nmygslp    LIKE nmy_file.nmygslp
  DEFINE l_nmygslp1   LIKE nmy_file.nmygslp1
  DEFINE li_result    LIKE type_file.num5    #No.FUN-680107 SMALLINT
  DEFINE l_dbs        STRING
  DEFINE l_sql        STRING
  DEFINE l_n          LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
    IF NOT cl_null(g_nnk.nnkglno) OR g_nnk.nnkglno IS NOT NULL THEN 
       CALL cl_err(g_nnk.nnkglno,'aap-618',1)
       RETURN
    END IF 
    IF NOT cl_confirm('aap-989') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nnk.nnk01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmydmy3 = 'N' THEN RETURN END IF
    IF g_nmy.nmyglcr = 'Y' OR (g_nmy.nmyglcr = 'N' AND NOT cl_null(g_nmy.nmygslp)) THEN  #FUN-940036
       #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
       #LET l_sql = " SELECT COUNT(aba00) FROM ",l_dbs,"aba_file",
       LET l_sql = " SELECT COUNT(aba00) FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                   "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                   "    AND aba01 = '",g_nnk.nnkglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
       PREPARE aba_pre5 FROM l_sql
       DECLARE aba_cs5 CURSOR FOR aba_pre5
       OPEN aba_cs5
       FETCH aba_cs5 INTO l_n
       IF l_n > 0 THEN
          CALL cl_err(g_nnk.nnkglno,'aap-991',1)
          RETURN
       END IF
       LET l_nmygslp = g_nmy.nmygslp
       LET l_nmygslp1= g_nmy.nmygslp1
    ELSE
       CALL cl_err('','aap-936',1) #FUN-940036
       RETURN
    END IF
    IF cl_null(l_nmygslp) THEN
       CALL cl_err(g_nnk.nnk01,'axr-070',1)
       RETURN
    END IF
    LET g_wc_gl = 'npp01 = "',g_nnk.nnk01 CLIPPED,'" AND npp011 = 0'
   #LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '",g_user,"' '",g_user,"' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nnk.nnk02,"' 'Y' '1' 'Y'"  #No.FUN-680088#FUN-860040#MOD-A30016 mark
    LET g_str="anmp400 '",g_wc_gl CLIPPED,"' '0' 'z' '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nmy.nmygslp,"' '",g_nmz.nmz02c,"' '",g_nmy.nmygslp1,"' '",g_nnk.nnk02,"' 'Y' '1' 'Y'"       #MOD-A30016 add
    CALL cl_cmdrun_wait(g_str)
    SELECT nnkglno INTO g_nnk.nnkglno FROM nnk_file
     WHERE nnk01 = g_nnk.nnk01
    DISPLAY BY NAME g_nnk.nnkglno
    
END FUNCTION
 
FUNCTION t750_undo_carry_voucher() 
  DEFINE l_aba19    LIKE aba_file.aba19
  DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(1000)
  DEFINE l_dbs      STRING
 
    IF cl_null(g_nnk.nnkglno) OR g_nnk.nnkglno IS NULL THEN
       CALL cl_err(g_nnk.nnkglno,'aap-619',1)
       RETURN 
    END IF
    IF NOT cl_confirm('aap-988') THEN RETURN END IF
 
    CALL s_get_doc_no(g_nnk.nnk01) RETURNING g_t1
    SELECT * INTO g_nmy.* FROM nmy_file WHERE nmyslip=g_t1
    IF g_nmy.nmyglcr = 'N' AND cl_null(g_nmy.nmygslp) THEN   #FUN-940036 
       CALL cl_err('','aap-936',1)   #FUN-940036
       RETURN
    END IF
    #LET g_plant_new=g_nmz.nmz02p CALL s_getdbs() LET l_dbs=g_dbs_new  #FUN-A50102
    #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
    LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_nmz.nmz02p,'aba_file'), #FUN-A50102
                "  WHERE aba00 = '",g_nmz.nmz02b,"'",
                "    AND aba01 = '",g_nnk.nnkglno,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_nmz.nmz02p) RETURNING l_sql #FUN-A50102
    PREPARE aba_pre FROM l_sql
    DECLARE aba_cs CURSOR FOR aba_pre
    OPEN aba_cs
    FETCH aba_cs INTO l_aba19
    IF l_aba19 = 'Y' THEN
       CALL cl_err(g_nnk.nnkglno,'axr-071',1)
       RETURN
    END IF
 
    LET g_str="anmp409 '",g_nmz.nmz02p,"' '",g_nmz.nmz02b,"' '",g_nnk.nnkglno,"' 'Y'"
    CALL cl_cmdrun_wait(g_str)
    SELECT nnkglno INTO g_nnk.nnkglno FROM nnk_file
     WHERE nnk01 = g_nnk.nnk01
    DISPLAY BY NAME g_nnk.nnkglno
END FUNCTION
#FUN-A40033 --Begin
FUNCTION t750_gen_diff()
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
         LET l_npq1.npqlegal=g_legal
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
#No.FUN-9C0073 -----------------By chenls 10/01/18
#CHI-C80041---begin
FUNCTION t750_v()
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_nnk.nnk01) THEN CALL cl_err('',-400,0) RETURN END IF  
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t750_cl USING g_nnk.nnk01
   IF STATUS THEN
      CALL cl_err("OPEN t750_cl:", STATUS, 1)
      CLOSE t750_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t750_cl INTO g_nnk.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_nnk.nnk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t750_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_nnk.nnkconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   IF cl_void(0,0,g_nnk.nnkconf)   THEN 
        LET g_chr=g_nnk.nnkconf
        IF g_nnk.nnkconf='N' THEN 
            LET g_nnk.nnkconf='X' 
        ELSE
            LET g_nnk.nnkconf='N'
        END IF
        UPDATE nnk_file
            SET nnkconf=g_nnk.nnkconf,  
                nnkmodu=g_user,
                nnkdate=g_today
            WHERE nnk01=g_nnk.nnk01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","nnk_file",g_nnk.nnk01,"",SQLCA.sqlcode,"","",1)  
            LET g_nnk.nnkconf=g_chr 
        END IF
        DISPLAY BY NAME g_nnk.nnkconf
   END IF
 
   CLOSE t750_cl
   COMMIT WORK
   CALL cl_flow_notify(g_nnk.nnk01,'V')
 
END FUNCTION
#CHI-C80041---end

# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program code...: asft622.4gl
# Program name...: 拆件式工單完工入庫維護作業
# Date & Author..: 98/06/10 By Star
# R1 : Steven Chiang 99/01/28
# Modify.........: No.B461 01/05/10 by linda mark 有關ksb_file 的check
#                  因為已無asft611程式,FQC己移至qcf_file, 但不可直接
#                  check qcf_file因為aqct410是針對成品之FQC,而拆件式
#                  可能為半成品,故不可直接替換
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No:9813 04/08/14 Carol asfr627--> asfr628
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.MOD-4B0169 04/11/22 By Mandy check imd_file 的程式段...應加上 imdacti 的判斷
# Modify.........: No.MOD-4C0010 04/12/02 By Mandy DEFINE smydesc欄位用LIKE方式
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530600 05/03/29 By pengu  單身開窗查詢應該查的是該主件之bom表下階料件
# Modify.........: No.FUN-540055 05/05/17 By Elva  新增雙單位內容&單據編號加大
# Modify.........: No.FUN-550052 05/05/25 By Trisy 單據編號加大
# Modify.........: No.FUN-550011 05/05/31 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: NO.FUN-560020 05/06/10 By Elva   雙單位內容調整
# Modify.........: No.MOD-570344 05/07/25 By pengu tlf024,tlf034應該記錄img10量而不是ima262
# Modify.........: No.MOD-590120 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.MOD-590347 05/09/16 By Carrier mark du_default()
# Modify.........: No.MOD-5A0012 05/10/16 By pengu  拆件式工單應該還是需要有發料才能做完工入庫
# Modify.........: No.MOD-5B0102 05/11/09 By kim 變數宣告寫死的全部改用LIKE
# Modify.........: No.TQC-5C0035 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-5C0055 05/12/19 By kim 更新工單狀態為'4'時,不應該考慮sfs_file是否存在
# Modify.........: No.FUN-5C0091 06/01/03 By Sarah 單身料號開窗,應考慮'工單之BOM有效日期'代出下階材料供挑選
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-610090 06/02/07 By Nicola 拆併箱功能修改
# Modify.........: No.FUN-630010 06/03/07 By saki 流程訊息通知功能
# Modify.........: NO.TQC-620156 06/03/15 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660134 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-650112 06/06/26 By Sarah t622_y_b1()產生單身LET ksd04=bmb03
# Modify.........: No.FUN-650120 06/06/28 By Sarah 入庫數量完全未做套數管控
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-660085 06/07/03 By Joe 若單身倉庫欄位已有值，則倉庫開窗查詢時，重新查詢時不會顯示該料號所有的倉儲。
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670103 06/07/31 By kim GP3.5 利潤中心
# Modify.........: No.TQC-680012 06/08/03 By 單身修改時其值無法UPDATE成功
# Modify.........: No.FUN-680121 06/09/18 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能 
# Modify.........: No.FUN-6A0164 06/11/22 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0031 06/12/13 By rainy 單身料件不在存BOM時要能過
# Modify.........: No.CHI-6A0015 06/12/19 By rainy 輸入料號後，自動帶出預設倉庫儲位
# Modify.........: No.FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.MOD-730094 07/03/28 By pengu 還原FUN-650120對入庫做足套數控管的判斷
# Modify.........: No.FUN-730075 07/04/02 By kim 行業別架構
# Modify.........: No.TQC-740145 07/04/24 By hongmei 修改"入庫量"小于0，報錯信息
# Modify.........: No.TQC-750018 07/05/04 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.CHI-740001 07/09/27 By rainy bma_file要判斷有效碼
# Modify.........: No.TQC-7A0068 07/10/19 By rainy CHI-740001 bma_file判斷有效碼沒做OUTER轉換
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-810036 08/01/16 By Nicola 序號管理
# Modify.........: No.MOD-830120 08/03/14 By chenl 在多單位采用參考單位情況下，增加對imgg_file的自動錄入。
# Modify.........: No.MOD-820144 08/03/20 By Pengu 查詢時單頭入庫單號開窗有誤
# Modify.........: No.MOD-810108 08/03/24 By Pengu 若單身中按「產生」則不應控管入庫數量，應與手動入輸入控管一致
# Modify.........: No.FUN-840042 08/04/16 by TSD.zeak 自訂欄位功能修改 
# Modify.........: No.FUN-850120 08/05/23 By rainy 多單位補批序號處理
# Modify.........: NO.CHI-860008 08/06/11 BY yiting s_del_rvbs
# Modify.........: No.FUN-860045 08/06/12 By Nicola 批/序號傳入值修改及開窗詢問使用者是否回寫單身數量
# Modify.........: No.FUN-860069 08/06/18 By Sherry 增加輸入日期(ksc14)
# Modify.........: No.CHI-860032 08/06/24 By Nicola 批/序號修改
# Modify.........: No.FUN-880011 08/08/15 By sherry 依BOM產生單身功能
# Modify.........: No.MOD-890047 08/09/03 By chenl  拆件式工單入庫時，必須判斷拆件料號是否有發料，若無發料則錄入時警告,但不可審核。
# Modify.........: No.FUN-880129 08/09/05 By xiaofeizhu s_del_rvbs的傳入參數(出/入庫，單據編號，單據項次，專案編號)，改為(出/入庫，單據編號，單據項次，檢驗順序)
# Modify.........: No.MOD-8B0227 08/11/21 By claire 倉庫為wip應可輸入
# Modify.........: No.MOD-8C0058 08/12/08 By claire 刪除 tlfs_file應先判斷有使用批序號設定
# Modify.........: No.MOD-8C0073 08/12/09 By sherry 增加對完工入庫日期的控管
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.MOD-910222 09/01/20 By claire 料件要確認才能輸入單身
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-930108 09/03/23 By zhaijie過賬時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.TQC-930155 09/03/31 By dongbg open cursor或fetch cursor失敗時不要rollback,給g_success賦值
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.TQC-950134 09/05/22 By Carrier rowid定義規範化
# Modify.........: No.MOD-950221 09/05/25 By mike 將sfb01=b_sfv.sfv11條件改成b_ksd.ksd11
# Modify.........: No.FUN-950021 09/05/27 By Carrier 組合拆解 & 把過帳及審核段移至sasft620_sub
# Modify.........: No.FUN-960007 09/06/04 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.CHI-950036 09/07/17 By jan 參考asft620對FQC單的處理方式，包括輸入(單頭移至單身)，卡關，及后續過帳 
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990070 09/09/21 By Carrier 單身'生成'action,多select sfb25
# Modify.........: No.TQC-990072 09/09/21 By Carrier 單身'生成'action,入庫的儲位/批號若為空,則給' '
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.FUN-9A0085 09/10/27 By liuxqa 標準SQL修改。 
# Modify.........: NO.CHI-9B0005 09/11/05 By liuxqa substr 修改.
# Modify.........: No.FUN-9C0073 10/01/08 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-9A0022 10/03/20 By chenmoyan給s_lotout加一個參數:歸屬單號
# Modify.........: No.MOD-A30193 10/03/30 By Summer 1.單身鍵入FQC單時,應帶出該筆FQC可入庫量
#                                                   2.請在確認段就控卡入庫量不可為0
# Modify.........: No.MOD-A30194 10/03/30 By Summer 單身輸入工單時檢核是否須要FQC，若要則強制FQC單號欄位一定要輸入
# Modify.........: No.FUN-A40058 10/04/26 By lilingyu bmb16增加7.規格替代的內容
# Modify.........: No.FUN-A40022 10/10/25 By jan 當料件為批號控管,則批號必須輸入
# Modify.........: No.FUN-AA0059 10/11/02 By huangtao 修改料號AFTER FIELD的管控
# Modify.........: No.FUN-AB0025 10/11/10 By chenying 修改料號開窗控管
# Modify.........: No.FUN-AB0047 10/11/11 By zhangll 仓库营运中心控管
# Modify.........: No:MOD-AC0093 10/12/13 By sabrina 按查詢，點選資料後卻查出全部入庫單 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B30170 11/04/11 By suncx 單身增加批序號明細頁簽
# Modify.........: No.FUN-B40029 11/04/13 By xianghui 修改substr
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50096 11/08/18 By lixh1 所有入庫程式應該要加入可以依料號設置"批號(倉儲批的批)是否為必要輸入欄位"的選項
# Modify.........: No.CHI-B90021 11/09/14 By lixh1  拿掉AFTER ROW 之後判斷批號不可為空的程式
# Modify.........: NO:MOD-BA0106 11/11/07 By johung s_lotin_del拿掉transaction，相關程式應調整
# Modify.........: No.FUN-910088 11/12/08 By chenjing 增加數量欄位小數取位
# Modify.........: No.TQC-B90236 12/01/11 By zhuhao 原執行s_lotin_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   _r()中，使用FOR迴圈執行s_del_rvbs程式段Mark，改為s_lot_del，傳入參數同上，但第三個參數(項次)傳""
#                                                   s_lotin程式段，改為s_mod_lot，於第6,7,8個參數傳入倉儲批，最後多傳入1，其餘傳入參數不變
# Modify.........: No.FUN-BC0104 12/01/14 By xujing QC料件判定,判定結果編碼、結果說明、項次 3個欄位
# Modify.........: No.FUN-C20048 12/02/10 By fengrui 數量欄位小數取位處理
# Modify.........: No.TQC-C30013 12/03/01 By xujing 增加判定結果編碼性質為'2'的情況
# Modify.........: No.FUN-C40016 12/04/06 By xianghui 單據作廢時不須清空QC料件判定新增的那幾個欄位,重新回寫已轉入庫量即可，取消作廢時檢查數量是否合理
# Modify.........: No:CHI-C30118 12/04/06 By Sakura 參考來源單號CHI-C30106,批序號維護修改
# Modify.........: No.FUN-C30300 12/04/09 By bart  倉儲批開窗需顯示參考單位數量
# Modify.........: No:MOD-C50012 12/05/04 By Elise 將aim-400的判斷搬到IF外先做
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:TQC-C60028 12/06/04 By bart 只要是ICD行業 倉儲批開窗改用q_idc
# Modify.........: No:MOD-C60047 12/06/06 By ck2yuan 若事後扣帳,則控卡入庫日期不可小於工單開立日期
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:TQC-C50227 12/08/07 By SunLM  組合拆解工單可以查詢,但不可取消審核和取消過帳
# Modify.........: No:TQC-C80178 12/09/04 By qiull sma95='N'時隱藏批序號的相關功能按鈕和頁簽
# Modify.........: No.FUN-CB0014 12/11/12 By xujing 增加資料清單
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No.FUN-D10094 13/01/21 By fengrui 倉庫單據理由碼改善，單身添加理由碼,还原FUN-CB0087修改
# Modify.........: No.FUN-CC0013 13/01/21 By Lori aqci106移除性質3.驗退/重工(qcl05=3)選項
# Modify.........: No.TQC-D10084 13/01/28 By xujing  資料清單頁簽不可點擊單身按鈕
# Modify.........: No.TQC-D10107 13/01/30 By xujing 在新增庫存明細前應先判斷若ksd06、ksd07為null則給空白
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D20060 13/02/22 By yangtt 設限倉庫/儲位控卡
# Modify.........: No.TQC-D20042 13/02/25 By fengrui 修正倉庫單據理由碼改善测试问题
# Modify.........: No.MOD-D30267 13/04/01 By bart 生產料件應走退料流程
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasft622.global"
 
DEFINE g_ima918  LIKE ima_file.ima918  #No.FUN-810036
DEFINE g_ima921  LIKE ima_file.ima921  #No.FUN-810036
DEFINE l_i       LIKE type_file.num5   #No.FUN-860045
DEFINE l_r       LIKE type_file.chr1   #No.FUN-860045
DEFINE l_fac     LIKE img_file.img34   #No.FUN-860045
#FUN-B30170 add begin--------------------------
DEFINE g_rvbs   DYNAMIC ARRAY OF RECORD        #批序號明細單身變量
                  rvbs02  LIKE rvbs_file.rvbs02,
                  rvbs021 LIKE rvbs_file.rvbs021,
                  ima02a  LIKE ima_file.ima02,
                  ima021a LIKE ima_file.ima021,
                  rvbs022 LIKE rvbs_file.rvbs022,
                  rvbs04  LIKE rvbs_file.rvbs04,
                  rvbs03  LIKE rvbs_file.rvbs03,
                  rvbs05  LIKE rvbs_file.rvbs05,
                  rvbs06  LIKE rvbs_file.rvbs06,
                  rvbs07  LIKE rvbs_file.rvbs07,
                  rvbs08  LIKE rvbs_file.rvbs08
                END RECORD
DEFINE g_rec_b1           LIKE type_file.num5,   #單身二筆數 ##FUN-B30170
       l_ac1              LIKE type_file.num5    #目前處理的ARRAY CNT  #FUN-B30170
#FUN-B30170 add -end---------------------------
#FUN-CB0014---add---str---
DEFINE g_ksc_l  DYNAMIC ARRAY OF RECORD
                  ksc01   LIKE ksc_file.ksc01,
                  smydesc LIKE smy_file.smydesc,
                  ksc14   LIKE ksc_file.ksc14,
                  ksc02   LIKE ksc_file.ksc02,
                  ksc04   LIKE ksc_file.ksc04,
                  gem02   LIKE gem_file.gem02,
                  ksc09   LIKE ksc_file.ksc09,
                  ksc05   LIKE ksc_file.ksc05,
                  azf03   LIKE azf_file.azf03,
                  ksc07   LIKE ksc_file.ksc07,
                  kscconf LIKE ksc_file.kscconf,
                  kscpost LIKE ksc_file.kscpost
                END RECORD 
DEFINE g_rec_b2           LIKE type_file.num5,   #單身二筆數 
       l_ac2              LIKE type_file.num5    #目前處理的ARRAY CNT  
DEFINE g_action_flag      STRING
DEFINE   w    ui.Window
DEFINE   f    ui.Form
DEFINE   page om.DomNode
#FUN-CB0014---add---end---

#FUN-910088--add--start--
DEFINE g_ksd08_t   LIKE ksd_file.ksd08,
       g_ksd30_t   LIKE ksd_file.ksd30,
       g_ksd33_t   LIKE ksd_file.ksd33
#FUN-910088--add--end--

 
FUNCTION sasft622(p_argv,p_argv1,p_argv2)       #No.FUN-630010
 
DEFINE  p_argv   LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1) #No.FUN-6A0090
        p_argv1  LIKE ksc_file.ksc01,         #No.FUN-630010
        p_argv2  STRING                       #No.FUN-630010
 
   WHENEVER ERROR CONTINUE
 
   CALL t622_def_form()
 
    LET g_forupd_sql = "SELECT * FROM ksc_file WHERE ksc01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t622_cl CURSOR FROM g_forupd_sql
 
    LET g_argv = p_argv
    LET g_argv1 = p_argv1    #No.FUN-630010
    LET g_argv2 = p_argv2    #No.FUN-630010
 
    IF g_argv = '2' THEN LET u_sign=-1 ELSE LET u_sign=1 END IF
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    DROP TABLE t622_temp
    CREATE TEMP TABLE t622_temp(
            bmb01     LIKE bmb_file.bmb01,
            bmb03     LIKE bmb_file.bmb03);
    CREATE unique index t622_1  ON t622_temp(bmb01,bmb03)
 
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t622_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t622_a()
             END IF
          OTHERWISE
             CALL t622_q()
       END CASE
    END IF
    CALL t622_menu()
    DROP TABLE t622_temp
 
END FUNCTION
 
FUNCTION t622_cs()
DEFINE  lc_qbe_sn LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_ksd.clear()
 
    IF cl_null(g_argv1) THEN               #No.FUN-630010
       IF g_argv='1' THEN 
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_ksc.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME g_wc ON
                ksc01,ksc14,ksc02,ksc04,ksc09,ksc05,ksc07,kscconf,       #CHI-950036 mod
                kscpost,kscuser,kscgrup,kscmodu,kscdate
                ,kscud01,kscud02,kscud03,kscud04,kscud05,
                kscud06,kscud07,kscud08,kscud09,kscud10,
                kscud11,kscud12,kscud13,kscud14,kscud15
                     BEFORE CONSTRUCT
                     CALL cl_qbe_init()
 
           ON ACTION controlp
             CASE WHEN INFIELD(ksc01) #查詢單据
 
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form  = "q_ksc"
                       ##組合拆解的完工入庫單不顯示出來!
                      #LET g_qryparam.where = " substr(ksc01,1,",g_doc_len,") NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "
                       #LET g_qryparam.where = " ksc01[1,",g_doc_len,"] NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "     #FUN-B40029 #TQC-C50227
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                      #LET g_qryparam.multiret=g_t1    #MOD-AC0093 mark
                       DISPLAY g_qryparam.multiret TO ksc01
                       NEXT FIELD ksc01
                  WHEN INFIELD(ksc04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO ksc04
                       NEXT FIELD ksc04
 
                  WHEN INFIELD(ksc05)
                           CALL cl_init_qry_var()
                           LET g_qryparam.form ="q_azf01a"  #No.FUN-930104    
                           LET g_qryparam.default1 = g_ksc.ksc05
                           LET g_qryparam.arg1 = 'C'        #No.FUN-930104
                           LET g_qryparam.state = "c"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ksc05
                       NEXT FIELD ksc05
 
               END CASE
 
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
 
                   ON ACTION qbe_select
                      CALL cl_qbe_list() RETURNING lc_qbe_sn
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
 
          END CONSTRUCT
       ELSE
          CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
          CONSTRUCT BY NAME g_wc ON
                ksc01,ksc14,ksc02,ksc04,ksc05,ksc07,ksc09,kscconf,  #FUN-660134 #FUN-860069
                kscpost,kscuser,kscgrup,kscmodu,kscdate
                  BEFORE CONSTRUCT
                  CALL cl_qbe_init()
 
           ON ACTION controlp
             CASE WHEN INFIELD(ksc01) #查詢單据
                       LET g_t1=s_get_doc_no(g_ksc.ksc01)     #No.FUN-550052
                       #LET g_sql = " smyslip NOT IN (SELECT UNIQUE smy71 FROM smy_file WHERE smy71 IS NOT NULL)"
                       #CALL smy_qry_set_par_where(g_sql) #TQC-C50227 mark
                       IF g_argv='1' THEN
                          CALL q_smy( FALSE, TRUE,g_t1,'ASF','C') RETURNING g_t1  #TQC-670008
                       ELSE
                          CALL q_smy( FALSE, TRUE,g_t1,'ASF','E') RETURNING g_t1   #TQC-670008
                       END IF
                       LET g_qryparam.multiret=g_t1
                       DISPLAY g_qryparam.multiret TO ksc01
                       NEXT FIELD ksc01
 
                  WHEN INFIELD(ksc04)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state = "c"
                       LET g_qryparam.form ="q_gem"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO ksc04
                       NEXT FIELD ksc04
 
                  WHEN INFIELD(ksc05)
                           CALL cl_init_qry_var()
                           LET g_qryparam.form ="q_azf01a"  #No.FUN-930104
                           LET g_qryparam.default1 = g_ksc.ksc05
                           LET g_qryparam.arg1 = 'C'        #No.FUN-930104
                           LET g_qryparam.state = "c"
                           CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ksc05
                       NEXT FIELD ksc05
               END CASE
 
             ON IDLE g_idle_seconds
                CALL cl_on_idle()
                CONTINUE CONSTRUCT
                   ON ACTION qbe_select
                      CALL cl_qbe_list() RETURNING lc_qbe_sn
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
          END CONSTRUCT
       END IF
 
       IF INT_FLAG THEN RETURN END IF
    ELSE
       LET g_wc = " ksc01 = '",g_argv1 CLIPPED,"'"       #No.FUN-630010
    END IF
 
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('kscuser', 'kscgrup')
 
    ##組合拆解的完工入庫單不顯示出來!
    #LET g_wc = g_wc CLIPPED,
               #" AND ksc01[1,",g_doc_len,"] NOT IN (SELECT smy71 FROM smy_file WHERE smy71 IS NOT NULL) "  #CHI-9B0005 mod
 
    IF cl_null(g_argv1) THEN    #No.FUN-630010
       CONSTRUCT g_wc2 ON ksd03,ksd17,ksd11,
                          ksd46,qcl02,ksd47,  #BC0104 add
                          ksd04,ksd08,ksd05,  #CHI-950036 add ksd17
                          ksd06,ksd07,ksd09,ksd33,ksd34,
                          #ksd35,ksd30,ksd31,ksd32,ksd12,sfv930  #FUN-670103      #FUN-D10094 mark 
                          ksd35,ksd30,ksd31,ksd32,ksd12,ksd930,ksd36  #FUN-670103 #FUN-D10094 add 
                          ,ksdud01,ksdud02,ksdud03,ksdud04,ksdud05,
                          ksdud06,ksdud07,ksdud08,ksdud09,ksdud10,
                          ksdud11,ksdud12,ksdud13,ksdud14,ksdud15
                     FROM s_ksd[1].ksd03, s_ksd[1].ksd17, s_ksd[1].ksd11,
                          s_ksd[1].ksd46, s_ksd[1].qcl02, s_ksd[1].ksd47,   #BC0104 add
                          s_ksd[1].ksd04, #CHI-950036 add ksd17
                          s_ksd[1].ksd08, s_ksd[1].ksd05,
                          s_ksd[1].ksd06, s_ksd[1].ksd07,
                          s_ksd[1].ksd09, s_ksd[1].ksd33,
                          s_ksd[1].ksd34, s_ksd[1].ksd35,
                          s_ksd[1].ksd30, s_ksd[1].ksd31,
                          s_ksd[1].ksd32, s_ksd[1].ksd12, s_ksd[1].ksd930, s_ksd[1].ksd36  #FUN-670103 #FUN-D10094
                          ,s_ksd[1].ksdud01,s_ksd[1].ksdud02,s_ksd[1].ksdud03,s_ksd[1].ksdud04,s_ksd[1].ksdud05,
                          s_ksd[1].ksdud06,s_ksd[1].ksdud07,s_ksd[1].ksdud08,s_ksd[1].ksdud09,s_ksd[1].ksdud10,
                          s_ksd[1].ksdud11,s_ksd[1].ksdud12,s_ksd[1].ksdud13,s_ksd[1].ksdud14,s_ksd[1].ksdud15
 
                   BEFORE CONSTRUCT
                      CALL cl_qbe_display_condition(lc_qbe_sn)
 
           ON ACTION controlp
              CASE WHEN INFIELD(ksd11)    #拆件式工單單號
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_sfb11"
                        LET g_qryparam.state = "c"
                        LET g_qryparam.default1 = g_ksd[1].ksd11
                        LET g_qryparam.arg1 = 23456
                        ##組合拆解的工單不顯示出來!
                       #LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                        #LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69  IS NOT NULL) "         #FUN-B40029 #TQC-C50227 mark
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ksd11
                        NEXT FIELD ksd11
                WHEN INFIELD(ksd17)    #FQC單號
                     CALL cl_init_qry_var()
                     LET g_qryparam.state= "c"
                     IF g_argv<>'3' THEN
                        LET g_qryparam.construct = "Y"
                        LET g_qryparam.form ="q_qcf5"
                     ELSE
                        LET g_qryparam.form ="q_srf"
                        LET g_qryparam.where ="srf07='1'" 
                     END IF
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksd17
                     NEXT FIELD ksd17
                   WHEN INFIELD(ksd04)     #料號
#FUN-AB0025-----mod-------------str---------------------                   
#                       CALL cl_init_qry_var()
#                       LET g_qryparam.form ="q_ima"
#                       LET g_qryparam.state = "c"
#                       LET g_qryparam.default1 = g_ksd[1].ksd04
#                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                        CALL q_sel_ima(TRUE, "q_ima","",g_ksd[1].ksd04,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AB0025-----mod-------------end----------------------
                        DISPLAY g_qryparam.multiret TO ksd04
                        NEXT FIELD ksd04
                   WHEN INFIELD(ksd08)     #單位
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_gfe"
                        LET g_qryparam.state = "c"
                        LET g_qryparam.default1 = g_ksd[1].ksd08
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO ksd08
                        NEXT FIELD ksd08
                  WHEN INFIELD(ksd05)
                    #Mod No.FUN-AB0047
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_imd"
                    #LET g_qryparam.state    = "c"
                    #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                     CALL q_imd_1(TRUE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                          RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AB0047
                     DISPLAY g_qryparam.multiret TO ksd05
                     NEXT FIELD ksd05
                  WHEN INFIELD(ksd06)
                    #Mod No.FUN-AB0047
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_ime"
                    #LET g_qryparam.state    = "c"
                    #CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                         RETURNING g_qryparam.multiret
                    #End Mod No.FUN-AB0047
                     DISPLAY g_qryparam.multiret TO ksd06
                     NEXT FIELD ksd06
                  WHEN INFIELD(ksd07)
                     CALL cl_init_qry_var()
                    #LET g_qryparam.form     = "q_ime"
                     LET g_qryparam.form     = "q_ksd07"   #Mod No.FUN-AB0047
                     LET g_qryparam.state    = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksd07
                     NEXT FIELD ksd07
                  WHEN INFIELD(ksd33)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_ksd[1].ksd33
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksd33
                     NEXT FIELD ksd33
                  WHEN INFIELD(ksd30)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_ksd[1].ksd30
                     LET g_qryparam.state = "c"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksd30
                     NEXT FIELD ksd30
                  WHEN INFIELD(ksd930)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form  = "q_gem4"
                     LET g_qryparam.state = "c"   #多選
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksd930
                     NEXT FIELD ksd930
                  #FUN-BC0104---add---str
                  WHEN INFIELD(ksd46)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_qco1"     
                     LET g_qryparam.state = "c"   
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksd46
                     NEXT FIELD ksd46

                  WHEN INFIELD(ksd47)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_qco1"    
                     LET g_qryparam.state = "c"   
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksd47
                     NEXT FIELD ksd47
                  #FUN-BC0104---add---end
                  #FUN-D10094---add---str--- 
                  WHEN INFIELD(ksd36)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_azf41"              
                     LET g_qryparam.state = "c"   
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO ksd36
                     NEXT FIELD ksd36
                  #FUN-D10094---add---end---
              END CASE
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
                       ON ACTION qbe_save
                          CALL cl_qbe_save()
 
       END CONSTRUCT
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    ELSE
       LET g_wc2 = " 1=1"
    END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT ksc01 FROM ksc_file",
                   " WHERE ", g_wc CLIPPED,
                   "   AND ksc00 = '",g_argv,"'",
                   " ORDER BY 1"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE  ksc01 ",
                   "  FROM ksc_file, ksd_file",
                   " WHERE ksc01 = ksd01",
                   "   AND ksc00 = '",g_argv,"'",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY 1"
    END IF
 
    PREPARE t622_prepare FROM g_sql
    DECLARE t622_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t622_prepare
    DECLARE t622_fill_cs CURSOR FOR t622_prepare    #FUN-CB0014 add
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
          LET g_sql="SELECT COUNT(*) FROM ksc_file ",
                    " WHERE ",g_wc CLIPPED,
                    "   AND ksc00 = '",g_argv,"'"
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT ksc01) FROM ksc_file,ksd_file WHERE ",
                  "ksc01=ksd01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                  "   AND ksc00 = '",g_argv,"'"
    END IF
    PREPARE t622_precount FROM g_sql
    DECLARE t622_count CURSOR FOR t622_precount
 
END FUNCTION
 
FUNCTION t622_menu()
DEFINE l_cmd        LIKE type_file.chr1000   #FUN-BC0104
DEFINE l_ksc01_doc  LIKE ksc_file.ksc01, #TQC-C50227
       l_cnt        LIKE type_file.num5  
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014
         CALL t622_bp("G")
      #FUN-CB0014---add---str---
      ELSE                           
         CALL t622_list_fill()
         CALL t622_bp2("G")           
         IF NOT cl_null(g_action_choice) AND l_ac2>0 THEN #將清單的資料回傳到主畫面
            SELECT ksc_file.* INTO g_ksc.*
              FROM ksc_file
             WHERE ksc01=g_ksc_l[l_ac2].ksc01
         END IF
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac2 = ARR_CURR()
            LET g_jump = l_ac2
            LET mi_no_ask = TRUE
            IF g_rec_b2 >0 THEN
               CALL t622_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("info,userdefined_field", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("info,userdefined_field", TRUE)
          END IF               
      END IF  
      #FUN-CB0014---add---end--
      CASE g_action_choice
           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL t622_a()
              END IF
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL t622_q()
              END IF
           WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL t622_r()
              END IF
           WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL t622_u()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL t622_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
           WHEN "output"
              IF cl_chk_act_auth() THEN
                 CALL t622_out()
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
           WHEN "void"
              IF cl_chk_act_auth() THEN
                #CALL t622_x()   #CHI-D20010
                 CALL t622_x(1)  #CHI-D20010
                 CALL t622_show() #FUN-BC0104 add
              END IF
              ##圖形顯示
              IF g_ksc.kscconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
         #CHI-D20010---begin
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t622_x(2)
               CALL t622_show() #FUN-BC0104 add
            END IF
            ##圖形顯示
             IF g_ksc.kscconf = 'X' THEN
                LET g_void = 'Y'
             ELSE
                LET g_void = 'N'
             END IF
             CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
         #CHI-D20010---end
         #@WHEN "確認"
           WHEN "confirm"
              IF cl_chk_act_auth() THEN
                 CALL t622sub_y_chk(g_ksc.ksc01,g_action_choice) #CHI-C30118 add g_action_choice
                 IF g_success = "Y" THEN
                    CALL t622sub_y_upd(g_ksc.ksc01,g_action_choice,FALSE)
                 END IF
                 CALL t622sub_refresh(g_ksc.ksc01) RETURNING g_ksc.*
                 CALL t622_show()
              END IF
         #@WHEN "取消確認"
           WHEN "undo_confirm"
              IF cl_chk_act_auth() THEN
                 #TQC-C50227 add begin---- 拆解組合工單不能取消審核
                 LET l_cnt=0
                 LET l_ksc01_doc = g_ksc.ksc01[1,g_doc_len]
                 SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smy71 = l_ksc01_doc
                 IF l_cnt > 0 THEN 
                    CALL cl_err('','asf-599',1)
                 ELSE    
                 #TQC-C50227 add  end------              
                    CALL t622sub_z(g_ksc.ksc01,g_action_choice,FALSE)
                    CALL t622sub_refresh(g_ksc.ksc01) RETURNING g_ksc.*
                    CALL t622_show()
                 END IF #TQC-C50227 add   
              END IF
           WHEN "stock_post"
              IF cl_chk_act_auth() THEN             
                 CALL t622sub_s(g_ksc.ksc01,g_argv,FALSE,g_action_choice)
                 CALL t622sub_refresh(g_ksc.ksc01) RETURNING g_ksc.*
                 CALL t622_show()
              END IF
              ##圖形顯示
              IF g_ksc.kscconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
           WHEN "undo_post"
              IF cl_chk_act_auth() THEN
                 #TQC-C50227 add begin---- 拆解組合工單不能取消審核
                 LET l_cnt=0
                 LET l_ksc01_doc = g_ksc.ksc01[1,g_doc_len]
                 SELECT COUNT(*) INTO l_cnt FROM smy_file WHERE smy71 = l_ksc01_doc
                 IF l_cnt > 0 THEN 
                    CALL cl_err('','asf-598',1)
                 ELSE    
                 #TQC-C50227 add  end------                
                    CALL t622sub_w(g_ksc.ksc01,g_action_choice,FALSE,g_argv)
                    CALL t622sub_refresh(g_ksc.ksc01) RETURNING g_ksc.*
                    CALL t622_show()
                 END IF #TQC-C50227 add
              END IF
              ##圖形顯示
              IF g_ksc.kscconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
         WHEN "exporttoexcel"
            LET w = ui.Window.getCurrent()   #FUN-CB0014 add
            LET f = w.getForm()              #FUN-CB0014 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-CB0014 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")  #FUN-CB0014 add
#                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ksd),'','')    #FUN-CB0014 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_ksd),'','')       #FUN-CB0014 add
               END IF
            #FUN-CB0014---add---str---  
            END IF
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_ksc_l),'','')
               END IF
            END IF
            #FUN-CB0014---add---end---
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_ksc.ksc01 IS NOT NULL THEN
                 LET g_doc.column1 = "ksc01"
                 LET g_doc.value1 = g_ksc.ksc01
                 CALL cl_doc()
               END IF
         END IF
         #FUN-BC0104---add---str
         WHEN "qc_determine_storage"
            IF cl_chk_act_auth() THEN
               LET  l_cmd = "aqcp107 '2' '' '' '' '' '' '' '' '' 'N'"
               CALL cl_cmdrun(l_cmd)
            END IF
         #FUN-BC0104---add---end
 
        WHEN "qry_lot"
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_ksd[l_ac].ksd04
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              IF cl_null(g_ksd[l_ac].ksd06) THEN
                 LET g_ksd[l_ac].ksd06 = ' '
              END IF
              IF cl_null(g_ksd[l_ac].ksd07) THEN
                 LET g_ksd[l_ac].ksd07 = ' '
              END IF
              SELECT img09 INTO g_img09 FROM img_file
               WHERE img01=g_ksd[l_ac].ksd04
                 AND img02=g_ksd[l_ac].ksd05
                 AND img03=g_ksd[l_ac].ksd06
                 AND img04=g_ksd[l_ac].ksd07
              CALL s_umfchk(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09) 
                  RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF
#TQC-B90236--mark--begin
#             CALL s_lotin(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
#                          g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09,
#                          l_fac,g_ksd[l_ac].ksd09,'','QRY')#CHI-9A0022 add ''
#TQC-B90236--mark--end
#TQC-B90236--add---begin
              CALL s_mod_lot(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
                             g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                             g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                             g_ksd[l_ac].ksd08,g_img09,l_fac,g_ksd[l_ac].ksd09,'','QRY',1)
#TQC-B90236--add---end
                     RETURNING l_r,g_qty 
           END IF
 
        END CASE
   END WHILE
END FUNCTION
 
FUNCTION t622_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550052  #No.FUN-680121 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_ksd.clear()
    INITIALIZE g_ksc.* TO NULL
    LET g_ksc_o.* = g_ksc.*
    LET g_ksc_t.* = g_ksc.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_ksc.ksc00 = g_argv
        LET g_ksc.ksc14 = g_today #FUN-860069
        LET g_ksc.ksc02 = g_today
        LET g_ksc.kscpost='N'
        LET g_ksc.kscconf='N' #FUN-660134
        LET g_ksc.kscuser=g_user
        LET g_ksc.kscoriu = g_user #FUN-980030
        LET g_ksc.kscorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_ksc.kscgrup=g_grup
        LET g_ksc.kscdate=g_today
        LET g_ksc.ksc04=g_grup #FUN-670103
        LET g_ksc.kscplant = g_plant #FUN-980008 add
        LET g_ksc.ksclegal = g_legal #FUN-980008 add
        CALL t622_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 
           CALL cl_err('',9001,0)
           ROLLBACK WORK 
           EXIT WHILE
        END IF
        IF g_ksc.ksc01 IS NULL THEN CONTINUE WHILE END IF
        # 98.09.14 Star 和一般入庫單是同一單別.. 為預防相同單據號碼 ...
        LET g_cnt = 0
        BEGIN WORK    #No:7829
      CALL s_auto_assign_no("asf",g_ksc.ksc01,g_ksc.ksc02,"","ksc_file","ksc01","","","")
        RETURNING li_result,g_ksc.ksc01
      IF (NOT li_result) THEN
 
 
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
           END IF
           DISPLAY BY NAME g_ksc.ksc01
        SELECT COUNT(*) INTO g_cnt FROM ksc_file WHERE ksc01 = g_ksc.ksc01
        IF g_i OR g_cnt !=0 THEN
           LET g_ksc.ksc01[g_no_sp,g_no_ep] = ' ' #No.FUN-550035
           DISPLAY BY NAME g_ksc.ksc01
           CALL cl_err('','asf-003',0)
           CONTINUE WHILE       	#有問題
        END IF
        INSERT INTO ksc_file VALUES (g_ksc.*)
        IF STATUS THEN
           CALL cl_err3("ins","ksc_file",g_ksc.ksc01,"",STATUS,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_ksc.ksc01,'I')
 
        SELECT ksc01 INTO g_ksc.ksc01 FROM ksc_file WHERE ksc01 = g_ksc.ksc01
        LET g_ksc_t.* = g_ksc.*
 
        CALL p622(g_ksc.ksc01)               
        LET g_wc2=NULL
        CALL t622_b_fill(g_wc2)
        LET g_action_choice="detail"
        IF cl_chk_act_auth() THEN
           CALL t622_b()
        ELSE
           RETURN
        END IF
        SELECT COUNT(*) INTO g_cnt FROM ksd_file WHERE ksd01=g_ksc.ksc01
        IF g_cnt>0 THEN
           IF g_smy.smyprint='Y' THEN
              IF cl_confirm('mfg9392') THEN CALL t622_out() END IF
           END IF
           IF g_smy.smydmy4='Y' THEN 
              CALL t622sub_s(g_ksc.ksc01,g_argv,FALSE,g_action_choice)
              CALL t622sub_refresh(g_ksc.ksc01) RETURNING g_ksc.*
           END IF
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t622_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_ksc.ksc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ksc.* FROM ksc_file WHERE ksc01 = g_ksc.ksc01
    IF g_ksc.kscconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660134
    IF g_ksc.kscpost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_ksc.kscpost = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    MESSAGE ""
 
    CALL cl_opmsg('u')
 
    LET g_ksc_o.* = g_ksc.*
 
    BEGIN WORK
 
    OPEN t622_cl USING g_ksc.ksc01
    IF STATUS THEN
       CALL cl_err("OPEN t622_cl:", STATUS, 1)
       CLOSE t622_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t622_cl INTO g_ksc.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ksc.ksc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t622_cl ROLLBACK WORK RETURN
    END IF
    CALL t622_show()
    WHILE TRUE
        LET g_ksc.kscmodu=g_user
        LET g_ksc.kscdate=g_today
        CALL t622_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_ksc.*=g_ksc_t.*
            CALL t622_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE ksc_file SET * = g_ksc.* WHERE ksc01 = g_ksc_o.ksc01
        IF STATUS OR SQLCA.SQLERRD[3]=0  THEN
           CALL cl_err3("upd","ksc_file",g_ksc_o.ksc01,"",STATUS,"","",1)  #No.FUN-660128
           CONTINUE WHILE
        END IF
        IF g_ksc.ksc01 != g_ksc_t.ksc01 THEN CALL t622_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t622_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ksc.ksc01,'U')
 
END FUNCTION
 
FUNCTION t622_chkkey()
    UPDATE ksd_file SET ksd01=g_ksc.ksc01 WHERE ksd01=g_ksc_t.ksc01
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","ksd_file",g_ksc_t.ksc01,"",STATUS,"","upd ksd01",1)  #No.FUN-660128
       LET g_ksc.*=g_ksc_t.* CALL t622_show() ROLLBACK WORK RETURN
    END IF
END FUNCTION
 
FUNCTION t622_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1     #a:輸入 u:更改  #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1     #判斷必要欄位是否有輸入  #No.FUN-680121 VARCHAR(1)  
  DEFINE li_result       LIKE type_file.num5     #No.FUN-550052  #No.FUN-680121 SMALLINT

   DISPLAY BY NAME
        g_ksc.ksc01,g_ksc.ksc14,g_ksc.ksc02,g_ksc.ksc04, #FUN-860069  #CHI-950036 mod
        g_ksc.ksc05,g_ksc.ksc07,g_ksc.ksc09,g_ksc.kscconf, #FUN-660134
        g_ksc.kscpost,g_ksc.kscuser,g_ksc.kscgrup,
        g_ksc.kscmodu,g_ksc.kscdate
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
       INPUT BY NAME g_ksc.kscoriu,g_ksc.kscorig,
          g_ksc.ksc01,g_ksc.ksc14,g_ksc.ksc02,g_ksc.ksc04, #FUN-860069 #CHI-950036 mod
          g_ksc.ksc09,g_ksc.ksc05,g_ksc.ksc07,g_ksc.kscconf, #FUN-660134
          g_ksc.kscpost,g_ksc.kscuser,g_ksc.kscgrup,
          g_ksc.kscmodu,g_ksc.kscdate
          ,g_ksc.kscud01,g_ksc.kscud02,g_ksc.kscud03,g_ksc.kscud04,
          g_ksc.kscud05,g_ksc.kscud06,g_ksc.kscud07,g_ksc.kscud08,
          g_ksc.kscud09,g_ksc.kscud10,g_ksc.kscud11,g_ksc.kscud12,
          g_ksc.kscud13,g_ksc.kscud14,g_ksc.kscud15 
             WITHOUT DEFAULTS
 
        BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL t622_set_entry(p_cmd)
          CALL t622_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
         CALL cl_set_docno_format("ksc01")
         CALL cl_set_docno_format("ksc09")
 
        AFTER FIELD ksc01
          IF NOT cl_null(g_ksc.ksc01) THEN
             LET g_t1=s_get_doc_no(g_ksc.ksc01)     #No.FUN-550052
 
             SELECT * INTO g_smy.* FROM smy_file
              WHERE smyslip=g_t1
           IF g_argv='0' THEN
               CALL s_check_no("asf",g_ksc.ksc01,g_ksc_t.ksc01,"9","ksc_file","ksc01","")
               RETURNING li_result,g_ksc.ksc01
            ELSE
               CALL s_check_no("asf",g_ksc.ksc01,g_ksc_t.ksc01,"C","ksc_file","ksc01","")
               RETURNING li_result,g_ksc.ksc01
            END IF
            DISPLAY BY NAME g_ksc.ksc01
            IF (NOT li_result) THEN
               LET g_ksc.ksc01=g_ksc_t.ksc01
               NEXT FIELD ksc01
            END IF
            CALL t622_ksc01(p_cmd)
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_ksc.ksc01,g_errno,0)
               NEXT FIELD ksc01
            END IF
            DISPLAY g_smy.smydesc TO smydesc
 
          END IF
 
        AFTER FIELD ksc14
	    IF NOT cl_null(g_ksc.ksc14) THEN
	       IF g_sma.sma53 IS NOT NULL AND g_ksc.ksc14 <= g_sma.sma53 THEN
	          CALL cl_err('','mfg9999',0) NEXT FIELD ksc14
	       END IF
               CALL s_yp(g_ksc.ksc14) RETURNING g_yy,g_mm
               #不可大於現行年月
               IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                  CALL cl_err('','mfg6091',0) NEXT FIELD ksc14
               END IF
            END IF
        #--
 
 
        AFTER FIELD ksc02
	    IF NOT cl_null(g_ksc.ksc02) THEN
	       IF g_sma.sma53 IS NOT NULL AND g_ksc.ksc02 <= g_sma.sma53 THEN
	          CALL cl_err('','mfg9999',0) NEXT FIELD ksc02
	       END IF
               CALL s_yp(g_ksc.ksc02) RETURNING g_yy,g_mm
               #不可大於現行年月
               IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                  CALL cl_err('','mfg6091',0) NEXT FIELD ksc02
               END IF
            END IF
 
        AFTER FIELD ksc04
            IF NOT cl_null(g_ksc.ksc04) THEN
               LET g_buf = ''
               SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_ksc.ksc04
                  AND gemacti='Y'   #NO:6950
               IF STATUS THEN
                  CALL cl_err3("sel","gem_file",g_ksc.ksc04,"",STATUS,"","select gem",1)  #No.FUN-660128
                  NEXT FIELD ksc04 
               END IF
               DISPLAY g_buf TO gem02
               #FUN-D10094--add--str--
               IF g_aza.aza115='Y' THEN 
                  IF g_ksc.ksc04 <> g_ksc_t.ksc04 AND NOT t622_ksd36_chkall() THEN 
                     LET g_ksc.ksc04 = g_ksc_t.ksc04
                     NEXT FIELD ksc04 
                  END IF
               END IF 
               #FUN-D10094--add--end--  
            END IF

        AFTER FIELD ksc05
            IF NOT cl_null(g_ksc.ksc05) THEN
               CALL t622_azf01()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ksc.ksc05,g_errno,0)
                  NEXT FIELD ksc05
               END IF
            END IF
 
        AFTER FIELD ksc09    #領料單號
            IF NOT cl_null(g_ksc.ksc09) THEN
               SELECT COUNT(*) INTO g_cnt FROM sfp_file
                WHERE sfp01 = g_ksc.ksc09
                  AND sfp06  = '4' AND sfpconf!='X' #FUN-660106
               IF g_cnt = 0 THEN
                  CALL cl_err(g_ksc.ksc09,'asf-525',0)
                  NEXT FIELD ksc09
               END IF
            END IF
 
        AFTER FIELD kscud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD kscud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
           
        ON ACTION controlp
          CASE WHEN INFIELD(ksc01) #查詢單据
                    LET g_t1=s_get_doc_no(g_ksc.ksc01)     #No.FUN-550052
                    LET g_sql = " smyslip NOT IN (SELECT UNIQUE smy71 FROM smy_file WHERE smy71 IS NOT NULL)"
                    CALL smy_qry_set_par_where(g_sql)
	            IF g_argv='1' THEN
                       CALL q_smy( FALSE, TRUE,g_t1,'ASF','C') RETURNING g_t1  #TQC-670008
                    ELSE
                       CALL q_smy( FALSE, TRUE,g_t1,'ASF','E') RETURNING g_t1  #TQC-670008
	            END IF
                    LET g_ksc.ksc01 = g_t1                 #No.FUN-550052
                    DISPLAY BY NAME g_ksc.ksc01
                    NEXT FIELD ksc01
 
               WHEN INFIELD(ksc04)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_ksc.ksc04
                    CALL cl_create_qry() RETURNING g_ksc.ksc04
                    DISPLAY BY NAME g_ksc.ksc04
                    NEXT FIELD ksc04
 
               WHEN INFIELD(ksc05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_azf01a"   #No.FUN-930104 
                    LET g_qryparam.default1 = g_ksc.ksc05
                    LET g_qryparam.arg1 = 'C'     #No.FUN-930104
                    CALL cl_create_qry() RETURNING g_ksc.ksc05
                    DISPLAY BY NAME g_ksc.ksc05
                    NEXT FIELD ksc05
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
END FUNCTION
 
FUNCTION t622_azf01()   #報廢理由
   DEFINE l_azf03 LIKE azf_file.azf03 #說明內容
   DEFINE l_azf09 LIKE azf_file.azf09    #No.FUN-930104 
  
   IF g_ksc.ksc05 IS NULL THEN RETURN END IF
   LET l_azf03=' '
   LET g_errno=' '
   SELECT azf03 INTO l_azf03
     FROM azf_file
    WHERE azf01=g_ksc.ksc05 AND azf02='2' AND azfacti='Y'                
   IF SQLCA.sqlcode THEN
      LET g_errno='asf-453'
      LET l_azf03=''
   END IF
   DISPLAY l_azf03 TO FORMONLY.azf03
   SELECT azf09 INTO l_azf09
     FROM azf_file
    WHERE azf01=g_ksc.ksc05 AND azf02='2' AND azfacti='Y'                
   IF l_azf09 !='C' THEN
      LET g_errno='aoo-411'
      LET l_azf03=''
   END IF
   DISPLAY l_azf03 TO FORMONLY.azf03
END FUNCTION
 
FUNCTION t622_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ksc.* TO NULL               #No.FUN-6A0164 
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t622_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_ksc.* TO NULL 
       RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t622_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_ksc.* TO NULL
    ELSE
        OPEN t622_count
        FETCH t622_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t622_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t622_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式  #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數  #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t622_cs INTO g_ksc.ksc01
        WHEN 'P' FETCH PREVIOUS t622_cs INTO g_ksc.ksc01
        WHEN 'F' FETCH FIRST    t622_cs INTO g_ksc.ksc01
        WHEN 'L' FETCH LAST     t622_cs INTO g_ksc.ksc01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t622_cs INTO g_ksc.ksc01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ksc.ksc01,SQLCA.sqlcode,0)
        INITIALIZE g_ksc.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_ksc.* FROM ksc_file WHERE ksc01 = g_ksc.ksc01
 
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","ksc_file",g_ksc.ksc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_ksc.* TO NULL
    ELSE
       LET g_data_owner = g_ksc.kscuser      #FUN-4C0035 add
       LET g_data_group = g_ksc.kscgrup      #FUN-4C0035 add
       LET g_data_plant = g_ksc.kscplant #FUN-980030
       CALL t622_show()
    END IF
 
END FUNCTION
 
FUNCTION t622_show()
     DEFINE l_smydesc LIKE smy_file.smydesc  #MOD-4C0010
 
    LET g_ksc_t.* = g_ksc.*                #保存單頭舊值
 
    SELECT kscconf INTO g_ksc.kscconf     #FUN-C40016
      FROM ksc_file                       #FUN-C40016
     WHERE ksc01 = g_ksc.ksc01            #FUN-C40016
    DISPLAY BY NAME g_ksc.kscoriu,g_ksc.kscorig,
            g_ksc.ksc01,g_ksc.ksc14,g_ksc.ksc02,g_ksc.ksc04, #FUN-860069 #CHI-950036 mod
            g_ksc.ksc05,g_ksc.ksc07,g_ksc.ksc09,g_ksc.kscconf,g_ksc.kscpost, #FUN-660134
            g_ksc.kscuser,g_ksc.kscgrup,g_ksc.kscmodu,g_ksc.kscdate
            ,g_ksc.kscud01,g_ksc.kscud02,g_ksc.kscud03,g_ksc.kscud04,
            g_ksc.kscud05,g_ksc.kscud06,g_ksc.kscud07,g_ksc.kscud08,
            g_ksc.kscud09,g_ksc.kscud10,g_ksc.kscud11,g_ksc.kscud12,
            g_ksc.kscud13,g_ksc.kscud14,g_ksc.kscud15 
 
    LET g_buf = s_get_doc_no(g_ksc.ksc01)     #No.FUN-550052
     SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip=g_buf #MOD-4C0010
     DISPLAY l_smydesc TO smydesc LET g_buf = NULL #MOD-4C0010
 
     SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_buf  #CHI-950036
     
    CALL t622_show2()
 
    ##圖形顯示
    IF g_ksc.kscconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
    CALL t622_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t622_show2()
    SELECT gem02 INTO g_buf FROM gem_file WHERE gem01=g_ksc.ksc04
    DISPLAY g_buf TO gem02 LET g_buf = NULL
 
    SELECT azf03 INTO g_buf FROM azf_file
     WHERE azf01=g_ksc.ksc05
       AND azf02 = '2' AND azfacti = 'Y'                
    DISPLAY g_buf TO azf03 LET g_buf = NULL
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION t622_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
    DEFINE l_i          LIKE type_file.num5    #no.CHI-860008
    #FUN-BC0104---add---str---
    DEFINE l_ksd17         LIKE ksd_file.ksd17,
           l_ksd47         LIKE ksd_file.ksd47,
           l_cn            LIKE type_file.num5,
           l_c             LIKE type_file.num5
    DEFINE l_ksd_a   DYNAMIC ARRAY OF RECORD
           ksd17           LIKE ksd_file.ksd17,
           ksd47           LIKE ksd_file.ksd47
                     END RECORD
    #FUN-BC0104---add---end---
 
    IF s_shut(0) THEN RETURN END IF
    IF g_ksc.ksc01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_ksc.* FROM ksc_file WHERE ksc01 = g_ksc.ksc01
    IF g_ksc.kscpost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_ksc.kscconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660134
    IF g_ksc.kscconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660134
 
    BEGIN WORK
 
    OPEN t622_cl USING g_ksc.ksc01
    IF STATUS THEN
       CALL cl_err("OPEN t622_cl:", STATUS, 1)
       CLOSE t622_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t622_cl INTO g_ksc.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ksc.ksc01,SQLCA.sqlcode,0)
       ROLLBACK WORK RETURN
    END IF
 
    CALL t622_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "ksc01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_ksc.ksc01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       MESSAGE "Delete ksc,ksd!"
       DELETE FROM ksc_file WHERE ksc01 = g_ksc.ksc01
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("del","ksc_file",g_ksc.ksc01,"",SQLCA.SQLCODE,"","No ina deleted",1)  #No.FUN-660128
          ROLLBACK WORK RETURN
       END IF
       #FUN-BC0104---add---str---
       DECLARE ksd03_cur CURSOR FOR SELECT ksd17,ksd47
                                     FROM ksd_file
                                     WHERE ksd01 = g_ksc.ksc01
        LET l_cn = 1
        FOREACH ksd03_cur INTO l_ksd17,l_ksd47
           LET l_ksd_a[l_cn].ksd17 = l_ksd17
           LET l_ksd_a[l_cn].ksd47 = l_ksd47
           LET l_cn = l_cn+1
        END FOREACH
       #FUN-BC0104---add---end---
       DELETE FROM ksd_file WHERE ksd01 = g_ksc.ksc01
       #FUN-BC0104---add---str---
        FOR l_c=1 TO l_cn-1
           IF NOT s_iqctype_upd_qco20(l_ksd_a[l_c].ksd17,0,0,l_ksd_a[l_c].ksd47,'3') THEN
              ROLLBACK WORK
              RETURN
           END IF
        END FOR
       #FUN-BC0104---add---end---
       FOR l_i = 1 TO g_rec_b 
          #IF NOT s_del_rvbs("2",g_ksc.ksc01,g_ksd[l_i].ksd03,0)  THEN         #FUN-880129   #TQC-B90236 mark
           IF NOT s_lot_del(g_prog,g_ksc.ksc01,'',0,g_ksd[l_i].ksd04,'DEL') THEN  #TQC-B90236 add
              ROLLBACK WORK
              RETURN
           END IF
       END FOR
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980008 add
                    VALUES ('asft622',g_user,g_today,g_msg,g_ksc.ksc01,'delete',g_plant,g_legal) #FUN-980008 add
       CLEAR FORM
       CALL g_ksd.clear()
       INITIALIZE g_ksc.* TO NULL
       MESSAGE ""
       OPEN t622_count
       #FUN-B50064-add-start--
       IF STATUS THEN
          CLOSE t622_cs
          CLOSE t622_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end--
       FETCH t622_count INTO g_row_count
       #FUN-B50064-add-start--
       IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
          CLOSE t622_cs
          CLOSE t622_count
          COMMIT WORK
          RETURN
       END IF
       #FUN-B50064-add-end-- 
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t622_cs
       IF g_curs_index = g_row_count + 1 THEN
          LET g_jump = g_row_count
          CALL t622_fetch('L')
       ELSE
          LET g_jump = g_curs_index
          LET mi_no_ask = TRUE
          CALL t622_fetch('/')
       END IF
 
    END IF
 
    CLOSE t622_cl
    COMMIT WORK
    CALL cl_flow_notify(g_ksc.ksc01,'D')
 
END FUNCTION
 
FUNCTION t622_b()
DEFINE
    l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680121 SMALLINT
    l_row,l_col      LIKE type_file.num5,    #No.FUN-680121 SMALLINT,              #分段輸入之行,列數
    l_n,l_cnt        LIKE type_file.num5,                #檢查重複用  #No.FUN-680121 SMALLINT
    l_lock_sw        LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680121 VARCHAR(1)
    p_cmd            LIKE type_file.chr1,                 #處理狀態  #No.FUN-680121 VARCHAR(1)
    l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
    l_allow_delete   LIKE type_file.num5,                #可刪除否  #No.FUN-680121 SMALLINT
    l_sfb05          LIKE sfb_file.sfb05    #--No.MOD-530600
DEFINE   l_date      LIKE sfp_file.sfp02    #MOD-8C0073 add
DEFINE   l_sfv14     LIKE sfv_file.sfv14   #CHI-950036
DEFINE   l_qcf091    LIKE qcf_file.qcf091  #CHI-950036
DEFINE   l_tmp_qcqty LIKE sfv_file.sfv09   #CHI-950036
DEFINE   l_sfb94     LIKE sfb_file.sfb94   #CHI-950036
#DEFINE   l_imaicd13  LIKE imaicd_file.imaicd13  #FUN-A40022
DEFINE   l_ima159    LIKE ima_file.ima159  #FUN-B50096 
DEFINE l_tf      LIKE type_file.chr1     #FUN-910088--add--
DEFINE l_tf1     LIKE type_file.chr1     #FUN-910088--add--
DEFINE l_sum     LIKE qco_file.qco11     #FUN-BC0104 add
DEFINE l_qcl05   LIKE qcl_file.qcl05     #FUN-BC0104 add
DEFINE l_ac2     LIKE type_file.num5     #CHI-C30118 
DEFINE l_flag    LIKE type_file.chr1     #FUN-D10094
DEFINE l_where   STRING                  #FUN-D10094   

    LET g_action_choice = ""
 
    IF g_ksc.ksc01 IS NULL THEN RETURN END IF
    IF g_ksc.kscpost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_ksc.kscconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660134
    IF g_ksc.kscconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660134
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * FROM ksd_file",
                       " WHERE ksd01 = ? AND ksd03 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t622_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_ksd.clear() END IF
 
    INPUT ARRAY g_ksd WITHOUT DEFAULTS FROM s_ksd.*
 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
         CALL cl_set_docno_format("ksd11")
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            #鎖住將被更改或取消的資料
 
            OPEN t622_cl USING g_ksc.ksc01
            IF STATUS THEN
               CALL cl_err("OPEN t622_cl:", STATUS, 1)
               CLOSE t622_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t622_cl INTO g_ksc.*
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_ksc.ksc01,SQLCA.sqlcode,0)     # 資料被他人LOCK
                  CLOSE t622_cl ROLLBACK WORK RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
               #CKP
               LET p_cmd='u'
               LET g_ksd_t.* = g_ksd[l_ac].*  #BACKUP
            #FUN-910088--add--start--
               LET g_ksd08_t = g_ksd[l_ac].ksd08
               LET g_ksd30_t = g_ksd[l_ac].ksd30
               LET g_ksd33_t = g_ksd[l_ac].ksd33
             #FUN-910088--add--end--
                OPEN t622_bcl USING g_ksc.ksc01,g_ksd_t.ksd03
                IF STATUS THEN
                   CALL cl_err("OPEN t622_bcl:", STATUS, 1)
                   CLOSE t622_bcl
                   ROLLBACK WORK
                   RETURN
                ELSE
                   FETCH t622_bcl INTO b_ksd.* #FUN-730075
                   IF SQLCA.sqlcode THEN
                      CALL cl_err('lock ksd',SQLCA.sqlcode,1)
                      LET l_lock_sw = "Y"
                   ELSE
                      CALL t622_b_move_to() #FUN-730075
                   END IF
                   LET g_ksd[l_ac].gem02c=s_costcenter_desc(g_ksd[l_ac].ksd930) #FUN-670103
                END IF
                IF g_sma.sma115 = 'Y' THEN
                   IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
                      SELECT ima25,ima31 INTO g_ima25,g_ima31
                        FROM ima_file WHERE ima01=g_ksd[l_ac].ksd04
 
                      CALL s_chk_va_setting(g_ksd[l_ac].ksd04)
                           RETURNING g_flag,g_ima906,g_ima907
                   END IF
 
                   CALL t622_set_entry_b()
                   CALL t622_set_no_entry_b()
                   CALL t622_set_no_required()
                   CALL t622_set_required()
                END IF
              # IF s_industry('icd') THEN        #FUN-A40022   #FUN-B50096
                CALL t622_set_no_required_1()    #FUN-A40022
                CALL t622_set_required_1(p_cmd)  #FUN-A40022
                CALL t622_set_entry_ksd07()      #FUN-B50096
                CALL t622_set_no_entry_ksd07()   #FUN-B50096
                #FUN-BC0104---add---str---
                CALL t622_set_noentry_ksd46()    
                IF NOT cl_null(g_ksd[l_ac].ksd46) THEN
                   CALL t622_qcl02_desc()
                END IF
                CALL t622_set_ksd04_ksd08_entry()
                CALL t622_set_ksd04_ksd08_noentry()
                #FUN-BC0104---add---end---
              # END IF                           #FUN-A40022   #FUN-B50096
                #FUN-540055  --end
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              #CKP
              INITIALIZE g_ksd[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_ksd[l_ac].* TO s_ksd.*
              CALL g_ksd.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
              #CKP
              #CANCEL INSERT
            END IF
            IF g_sma.sma115 = 'Y' THEN
               CALL s_chk_va_setting(g_ksd[l_ac].ksd04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD ksd04
               END IF
 
               CALL t622_du_data_to_correct()
 
               SELECT img09 INTO g_img09 FROM img_file
                WHERE img01=g_ksd[l_ac].ksd04
                  AND img02=g_ksd[l_ac].ksd05
                  AND img03=g_ksd[l_ac].ksd06
                  AND img04=g_ksd[l_ac].ksd07
               IF cl_null(g_img09) THEN
                  CALL cl_err(g_ksd[l_ac].ksd04,'mfg6069',0)
                  NEXT FIELD ksd04
               END IF
 
               CALL t622_set_origin_field()
            END IF
 
            CALL t622_b_else()
            CALL t622_b_move_back() #FUN-730075
            INSERT INTO ksd_file VALUES (b_ksd.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","ksd_file",g_ksc.ksc01,g_ksd[l_ac].ksd03,SQLCA.sqlcode,"","ins ksd",1)  #No.FUN-660128
              #CANCEL INSERT   #MOD-BA0106 mark
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_ksd[l_ac].ksd04
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 #IF NOT s_lotin_del(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,g_ksd[l_ac].ksd04,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                  IF NOT s_lot_del(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,g_ksd[l_ac].ksd04,'DEL') THEN   #No.FUN-860045  #TQC-B90236 add
                     CALL cl_err3("del","rvbs_file",g_ksc.ksc01,g_ksd_t.ksd03,
                                   SQLCA.sqlcode,"","",1)
                  END IF
               END IF
               CANCEL INSERT   #MOD-BA0106 
            ELSE
               MESSAGE 'INSERT O.K'
               #FUN-BC0104---add---str---
               IF NOT s_iqctype_upd_qco20(g_ksd[l_ac].ksd17,0,0,g_ksd[l_ac].ksd47,'3') THEN
                  CANCEL INSERT 
               END IF
               #FUN-BC0104---add---end---
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
             END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ksd[l_ac].* TO NULL      #900423
            LET g_ksd_t.* = g_ksd[l_ac].*
            LET g_ksd[l_ac].ksd09=0
            LET g_ksd[l_ac].ksd930=s_costcenter(g_ksc.ksc04) #FUN-670103
            LET g_ksd[l_ac].gem02c=s_costcenter_desc(g_ksd[l_ac].ksd930) #FUN-670103
            #CKP
        #FUN-910088--add--start--
            LET g_ksd08_t = NULL                 
            LET g_ksd30_t = NULL             
            LET g_ksd33_t = NULL             
        #FUN-910088--add--end--
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            CALL cl_set_comp_required('ksd46,ksd47',FALSE)       #FUN-BC0104 add
            CALL cl_set_comp_entry('ksd46,ksd47',TRUE)           #FUN-BC0104 add
            NEXT FIELD ksd03
 
        BEFORE FIELD ksd03                            #default 序號
            IF g_ksd[l_ac].ksd03 IS NULL OR g_ksd[l_ac].ksd03 = 0 THEN
                SELECT max(ksd03)+1 INTO g_ksd[l_ac].ksd03
                  FROM ksd_file WHERE ksd01 = g_ksc.ksc01
                IF g_ksd[l_ac].ksd03 IS NULL THEN
                    LET g_ksd[l_ac].ksd03 = 1
                END IF
            END IF
 
        AFTER FIELD ksd03                        #check 序號是否重複
            IF NOT cl_null(g_ksd[l_ac].ksd03) THEN
               IF g_ksd[l_ac].ksd03 != g_ksd_t.ksd03 OR
                  g_ksd_t.ksd03 IS NULL THEN
                   SELECT count(*) INTO l_n FROM ksd_file
                    WHERE ksd01 = g_ksc.ksc01
                      AND ksd03 = g_ksd[l_ac].ksd03
                   IF l_n > 0 THEN
                      LET g_ksd[l_ac].ksd03 = g_ksd_t.ksd03
                      CALL cl_err('',-239,0) NEXT FIELD ksd03
                   END IF
               END IF
            END IF
            #FUN-BC0104---add---str---
            IF p_cmd = 'a' THEN
              CALL cl_set_comp_required('ksd46,ksd47',FALSE)
              CALL cl_set_comp_entry('ksd46,ksd47',TRUE)
            END IF
           #FUN-BC0104---add---end---
 
        AFTER FIELD ksd17
          IF NOT cl_null(g_ksd[l_ac].ksd17) THEN
             IF g_ksd[l_ac].ksd17 != g_ksd_t.ksd17 OR
                g_ksd_t.ksd17 IS NULL THEN
                  IF g_argv<>'3' THEN 
                      CALL t622_ksd17(p_cmd)
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err('',g_errno,1)
                         NEXT FIELD ksd17
                      END IF
                  ELSE
                      IF NOT t622_asr_ksd17() THEN
                         NEXT FIELD ksd17
                      END IF
                  END IF
                IF NOT t622_ksd11_1() THEN
                   NEXT FIELD ksd17
                END IF 
              END IF
              #FUN-BC0104---add---str---
              IF p_cmd = 'a' THEN 
                 CALL t622_ksd46_check() 
              END IF
              #FUN-BC0104---add---end---
         #str MOD-A30194 add
          ELSE
             IF NOT cl_null(g_ksd[l_ac].ksd11) THEN
                LET l_sfb94 = ''
                SELECT sfb94 INTO l_sfb94 FROM sfb_file
                 WHERE sfb01 = g_ksd[l_ac].ksd11
                IF l_sfb94='Y' THEN
                   CALL cl_err(g_ksd[l_ac].ksd11,'asf-680',1)
                   NEXT FIELD ksd17
                END IF
             END IF
         #end MOD-A30194 add
          END IF
 
        AFTER FIELD ksd11     #拆件式工單號碼
          #程式碼移到t622_ksd11_1()
          IF NOT t622_ksd11_1() THEN
            #str MOD-A30194 mod
            #NEXT FIELD ksd11
             IF g_sfb.sfb94='Y' AND cl_null(g_ksd[l_ac].ksd17) THEN
                NEXT FIELD ksd17
             ELSE
                NEXT FIELD ksd11
             END IF
            #end MOD-A30194 mod
          END IF
          #MOD-D30267---begin
          IF NOT cl_null(g_ksd[l_ac].ksd11) AND NOT cl_null(g_ksd[l_ac].ksd04) THEN 
             SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01 = g_ksd[l_ac].ksd11
                 IF g_ksd[l_ac].ksd04 = l_sfb05 THEN
                    CALL cl_err('','asf-264',1)
                    NEXT FIELD ksd11
                 END IF 
          END IF 
          #MOD-D30267---end
           #FUN-BC0104---add---str
        BEFORE FIELD ksd46
           CALL t622_set_ksd04_ksd08_entry()
           CALL t622_set_entry_b()

        AFTER FIELD ksd46
           IF NOT cl_null(g_ksd[l_ac].ksd46) AND p_cmd = 'a' THEN
              IF NOT t622_ksd46_47_check() THEN
                 CALL cl_err(g_ksd[l_ac].ksd46,'apm-808',0)
                 NEXT FIELD ksd46
              END IF
              #FUN-CC0013 mark begin---
              #LET l_n = 0
              #SELECT COUNT(*) INTO l_n FROM qco_file,qcf_file,
              #                              qcl_file
              #                         WHERE qco01 = g_ksd[l_ac].ksd17
              #                         AND   qcf00 = '1'
              #                         AND   qcf01 = qco01 
              #                         AND   qcf14 = 'Y'
              #                         AND   qco03 = g_ksd[l_ac].ksd46
              #                         AND   qcl01 = qco03
              #                         AND   qcl05 = '3'
              # IF l_n > 0 THEN
              #    CALL cl_err('','apm-806',0)
              #    NEXT FIELD ksd46
              # END IF
              #FUN-CC0013 mark end-----
               CALL t622_set_ksd04_ksd08_noentry()
               IF g_sma.sma115 = 'Y' THEN
                  CALL t622_set_entry_b()
               END IF 
               CALL t622_set_comp_required(g_ksd[l_ac].ksd46,g_ksd[l_ac].ksd47)
               CALL t622_qcl02_desc()
               IF NOT cl_null(g_ksd[l_ac].ksd46) AND NOT cl_null(g_ksd[l_ac].ksd47) THEN
                  CALL t622_qco_show()
                  CALL t622_qcl05_check() RETURNING l_qcl05
                  IF (l_qcl05 = '0' OR l_qcl05 = '2') AND g_sma.sma115='N' THEN      #TQC-C30013
                     IF NOT t622_ksd09_check(p_cmd) THEN
                        NEXT FIELD ksd09
                     END IF
                  END IF
               END IF
            END IF 

        AFTER FIELD ksd47
           IF NOT cl_null(g_ksd[l_ac].ksd47) AND p_cmd = 'a' THEN
              IF NOT t622_ksd46_47_check() THEN
                 CALL cl_err(g_ksd[l_ac].ksd47,'apm-808',0)
                 NEXT FIELD ksd47
              END IF
              LET l_n = 0
              SELECT COUNT(*) INTO l_n FROM qco_file,qcf_file,
                                            qcl_file
                                       WHERE qco01 = g_ksd[l_ac].ksd17
                                       AND   qcf00 = '1'
                                       AND   qcf01 = qco01 
                                       AND   qcf14 = 'Y'
                                       AND   qco04 = g_ksd[l_ac].ksd47
                                       AND   qcl01 = qco03
                                      #AND   qcl05 != '3'    #FUN-CC0013 mark
               IF l_n = 0 THEN
                  CALL cl_err('','apm-807',0)
                  NEXT FIELD ksd47
               END IF
               CALL t622_set_comp_required(g_ksd[l_ac].ksd46,g_ksd[l_ac].ksd47)
               IF NOT cl_null(g_ksd[l_ac].ksd46) AND NOT cl_null(g_ksd[l_ac].ksd47) THEN
                  CALL t622_qco_show()
                  CALL t622_qcl05_check() RETURNING l_qcl05
                  IF (l_qcl05 = '0' OR l_qcl05 = '2') AND g_sma.sma115='N' THEN         #TQC-C30013
                     IF NOT t622_ksd09_check(p_cmd) THEN
                        NEXT FIELD ksd09
                     END IF
                  END IF
               END IF
            END IF 
        #FUN-BC0104---add---end
 
        BEFORE FIELD ksd04
           LET g_sfb05 = ''
           SELECT sfb05 INTO g_sfb05 FROM sfb_file
            WHERE sfb01 = g_ksd[l_ac].ksd11
	         IF NOT cl_null(g_ksd[l_ac].ksd11) THEN
              SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=g_ksd[l_ac].ksd11
           END IF
           CALL t622_set_entry_b()
           CALL t622_set_no_required()
         # IF s_industry('icd') THEN      #FUN-A40022  #FUN-B50096
           CALL t622_set_no_required_1()  #FUN-A40022
           CALL t622_set_entry_ksd07()    #FUN-B50096
         # END IF                         #FUN-A40022  #FUN-B50096
 
        AFTER FIELD ksd04    #拆件式工單 - 拆出元件
           LET l_tf = ""  #FUN-910088
           LET l_tf1= ""  #FUN-910088
           IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_ksd[l_ac].ksd04,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_ksd[l_ac].ksd04= g_ksd_t.ksd04
                 NEXT FIELD ksd04
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              #MOD-D30267---begin
              IF g_ksd[l_ac].ksd04 = l_sfb05 THEN
                 CALL cl_err('','asf-264',1)
                 NEXT FIELD ksd04
              END IF 
              #MOD-D30267---end
                 CALL t622_ksd04()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_ksd[l_ac].ksd04,g_errno,1)
                    LET g_ksd[l_ac].ksd04 = g_ksd_t.ksd04
                    LET g_ksd[l_ac].ima02 = g_ksd_t.ima02
                    LET g_ksd[l_ac].ima021= g_ksd_t.ima021
                    LET g_ksd[l_ac].ksd08 = g_ksd_t.ksd08
                    NEXT FIELD ksd04
                 END IF
             #FUN-910088--add--start--
                 IF NOT cl_null(g_ksd[l_ac].ksd09) AND g_ksd[l_ac].ksd09<>0 THEN  #FUN-C20048 add
                    CALL t622_ksd09_check(p_cmd) RETURNING l_tf   #FUN-BC0104 add p_cmd
                 END IF                                                           #FUN-C20048 add
                 LET g_ksd08_t = g_ksd[l_ac].ksd08
             #FUN-910088--add--end--
 
 
                 DISPLAY BY NAME g_ksd[l_ac].ksd04
                 DISPLAY BY NAME g_ksd[l_ac].ima02
                 DISPLAY BY NAME g_ksd[l_ac].ima021
                 DISPLAY BY NAME g_ksd[l_ac].ksd08
 
            END IF
            IF g_sma.sma115 = 'Y' THEN
               IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
                  CALL s_chk_va_setting(g_ksd[l_ac].ksd04)
                      RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD ksd04
                  END IF
                  IF g_ima906 = '3' THEN
                     LET g_ksd[l_ac].ksd33=g_ima907
                 #FUN-910088--add--start--
                     IF NOT cl_null(g_ksd[l_ac].ksd35) AND g_ksd[l_ac].ksd35<>0 THEN  #FUN-C20048 add
                        CALL t622_ksd35_check(p_cmd) RETURNING l_tf1
                     END IF                                                           #FUN-C20048 add
                     LET g_ksd33_t = g_ksd[l_ac].ksd33
                 #FUN-910088--add--end--
                  END IF
               END IF
               CALL t622_set_no_entry_b()
               CALL t622_set_required()
            END IF
          # IF s_industry('icd') THEN       #FUN-A40022  #FUN-B50096
            CALL t622_set_required_1(p_cmd) #FUN-A40022
            CALL t622_set_no_entry_ksd07()  #FUN-B50096
          # END IF                          #FUN-A40022  #FUN-B50096
            #No.FUN-540055  --end
          #FUN-910088--add-start--
            IF NOT cl_null(l_tf) AND NOT l_tf THEN
               NEXT FIELD ksd09
            END IF
            IF NOT cl_null(l_tf1) AND NOT l_tf1 THEN
               NEXT FIELD ksd35
            END IF
         #FUN-910088--add--end--
 
         AFTER FIELD ksd08    #單位
            IF NOT cl_null(g_ksd[l_ac].ksd08) THEN
               CALL t622_unit(g_ksd[l_ac].ksd08)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_ksd[l_ac].ksd08,g_errno,0)
                  LET g_ksd[l_ac].ksd08 = g_ksd_t.ksd08
                  DISPLAY BY NAME g_ksd[l_ac].ksd08
                  NEXT FIELD ksd08
               END IF
         #FUN-910088--add--start-- 
               IF NOT cl_null(g_ksd[l_ac].ksd09) AND g_ksd[l_ac].ksd09<>0 THEN  #FUN-C20048 add
                  IF NOT t622_ksd09_check(p_cmd) THEN       #FUN-BC0104 add p_cmd
                     LET g_ksd08_t = g_ksd[l_ac].ksd08
                     NEXT FIELD ksd09
                  END IF 
               END IF                                                           #FUN-C20048 add
               LET g_ksd08_t = g_ksd[l_ac].ksd08
         #FUN-910088--add--end--
            END IF
 
        AFTER FIELD ksd05     #倉庫
           IF NOT cl_null(g_ksd[l_ac].ksd05) THEN
              #FUN-D20060----add---str--
              IF NOT s_chksmz(g_ksd[l_ac].ksd04, g_ksc.ksc01,
                           g_ksd[l_ac].ksd05, g_ksd[l_ac].ksd06) THEN
                 NEXT FIELD ksd05
              END IF
              #FUN-D20060----add---end--
              IF g_argv MATCHES '[12]' THEN
                 SELECT imd02 INTO g_buf FROM imd_file
                  WHERE imd01=g_ksd[l_ac].ksd05 AND (imd10='S' OR imd10='W')  #MOD-8B0227
                     AND imdacti = 'Y' #MOD-4B0169
                 IF STATUS THEN
                    CALL cl_err3("sel","imd_file",g_ksd[l_ac].ksd05,"","mfg1100","","imd",1)  #No.FUN-660128
                    NEXT FIELD ksd05
                 END IF
                 #Add No.FUN-AB0047
                 IF NOT s_chk_ware(g_ksd[l_ac].ksd05) THEN  #检查仓库是否属于当前门店
                    NEXT FIELD ksd05
                 END IF
                 #End Add No.FUN-AB0047
              END IF
              #FUN-BC0104---add---str---
              IF NOT cl_null(g_ksd[l_ac].ksd46) THEN
                 IF NOT t622_ksd05_check() THEN
                   CALL cl_err('','aqc-524',0)
                   NEXT FIELD ksd05
                 END IF
              END IF
              #FUN-BC0104---add---end---
           END IF
 
        AFTER FIELD ksd06    #儲位
           #BugNo:5626 控管是否為全型空白
           IF g_ksd[l_ac].ksd06 = '　' THEN #全型空白
               LET g_ksd[l_ac].ksd06 = ' '
           END IF
           IF g_argv MATCHES '[12]' THEN
           IF g_ksd[l_ac].ksd06 IS NULL THEN LET g_ksd[l_ac].ksd06 = ' ' END IF
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF NOT cl_null(g_ksd[l_ac].ksd05) THEN  #FUN-D20060 add
              IF NOT s_chksmz(g_ksd[l_ac].ksd04, g_ksc.ksc01,
                              g_ksd[l_ac].ksd05, g_ksd[l_ac].ksd06) THEN
                 NEXT FIELD ksd05
              END IF
           END IF   #FUN-D20060 add
           #-------------------------------------
           END IF
     #FUN-B50096 --------------Begin-------------------
           IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
              SELECT ima159 INTO l_ima159 FROM ima_file
               WHERE ima01 = g_ksd[l_ac].ksd04
              IF l_ima159 = '2' THEN
                 CASE t622_b_ksd07_inschk(p_cmd)
                    WHEN "ksd05" NEXT FIELD ksd05   #MOD-C50012 add
                    WHEN "ksd07" NEXT FIELD ksd06 
                 END CASE
              #FUN-910088--add--start--
                 IF NOT cl_null(g_ksd[l_ac].ksd09) AND g_ksd[l_ac].ksd09<>0 THEN  #FUN-C20048 add
                    IF NOT t622_ksd09_check(p_cmd) THEN    #FUN-BC0104 add p_cmd
                       LET g_ksd08_t = g_ksd[l_ac].ksd08
                       NEXT FIELD ksd09
                    END IF
                 END IF                                                           #FUN-C20048 add
                 LET g_ksd08_t = g_ksd[l_ac].ksd08
              #FUN-910088--add--end--
              END IF
           END IF
     #FUN-B50096 --------------End---------------------
 
        AFTER FIELD ksd07    #批號

           CASE t622_b_ksd07_inschk(p_cmd)   #FUN-B50096
              WHEN "ksd05" NEXT FIELD ksd05  #MOD-C50012 add
              WHEN "ksd07" NEXT FIELD ksd07  #FUN-B50096
           END CASE                          #FUN-B50096
        #FUN-910088--add--start--
           IF NOT cl_null(g_ksd[l_ac].ksd09) AND g_ksd[l_ac].ksd09<>0 THEN  #FUN-C20048 add
              IF NOT t622_ksd09_check(p_cmd) THEN       #FUN-BC0104 add p_cmd
                 LET g_ksd08_t = g_ksd[l_ac].ksd08
                 NEXT FIELD ksd09
              END IF
           END IF                                                           #FUN-C20048 add
           LET g_ksd08_t = g_ksd[l_ac].ksd08
        #FUN-910088--add--end--

#FUN-B50096 ----------------Begin---------------------
#          #BugNo:5626 控管是否為全型空白
#          IF g_ksd[l_ac].ksd07 = '　' THEN #全型空白
#              LET g_ksd[l_ac].ksd07 = ' '
#          END IF
#          #FUN-A40022----begin--add--------------- 
#          IF s_industry('icd') THEN 
#             IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
#                LET l_imaicd13='' 
#                SELECT imaicd13 INTO l_imaicd13
#                  FROM imaicd_file
#                 WHERE imaicd00 = g_ksd[l_ac].ksd04
#                IF l_imaicd13 = 'Y' AND cl_null(g_ksd[l_ac].ksd07) THEN
#                   CALL cl_err(g_ksd[l_ac].ksd04,'aim-034',1)
#                   NEXT FIELD ksd07
#                END IF
#             END IF
#          END IF 
#          #FUN-A40022--end--add------------------
#          IF g_argv MATCHES '[12]' THEN
#             IF g_ksd[l_ac].ksd07 IS NULL THEN
#                LET g_ksd[l_ac].ksd07 = ' '
#             END IF
#
#           IF NOT cl_null(g_ksd[l_ac].ksd05) THEN
#             SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
#              WHERE img01=g_ksd[l_ac].ksd04 AND img02=g_ksd[l_ac].ksd05
#                AND img03=g_ksd[l_ac].ksd06 AND img04=g_ksd[l_ac].ksd07
#
#             IF STATUS THEN
#                IF g_sma.sma892[3,3] = 'Y' THEN
#                   IF NOT cl_confirm('mfg1401') THEN
#                      NEXT FIELD ksd07
#                   END IF
#                END IF
#
#                CALL s_add_img(g_ksd[l_ac].ksd04, g_ksd[l_ac].ksd05,
#                               g_ksd[l_ac].ksd06, g_ksd[l_ac].ksd07,
#                               g_ksc.ksc01,       g_ksd[l_ac].ksd03, g_today)
#
#                IF g_errno='N' THEN
#                   NEXT FIELD ksd07
#                END IF
#
#                SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
#                 WHERE img01=g_ksd[l_ac].ksd04 AND img02=g_ksd[l_ac].ksd05
#                   AND img03=g_ksd[l_ac].ksd06 AND img04=g_ksd[l_ac].ksd07
#
#             END IF
#
#             IF g_sma.sma115 = 'N' THEN
#                IF cl_null(g_ksd[l_ac].ksd08) THEN   #若單位空白
#                   LET g_ksd[l_ac].ksd08=g_img09
#                END IF
#             ELSE
#                SELECT COUNT(*) INTO g_cnt FROM img_file
#                 WHERE img01 = g_ksd[l_ac].ksd04   #料號
#                   AND img02 = g_ksd[l_ac].ksd05   #倉庫
#                   AND img03 = g_ksd[l_ac].ksd06   #儲位
#                   AND img04 = g_ksd[l_ac].ksd07   #批號
#                   AND img18 < g_ksc.ksc02   #調撥日期
#                IF g_cnt > 0 THEN    #大於有效日期
#                   call cl_err('','aim-400',0)   #須修改
#                   NEXT FIELD ksd07
#                END IF
#                # - FQC入庫不做雙單位處理
#                IF cl_null(g_ksd[l_ac].ksd17) OR (g_argv='3') THEN  
#                   CALL t622_du_default(p_cmd)
#                ELSE
#                   CALL s_du_umfchk(g_ksd[l_ac].ksd04,'','','',
#                                    g_img09,g_ksd[l_ac].ksd30,'1')
#                        RETURNING g_errno,g_factor
#                   IF NOT cl_null(g_errno) THEN
#                      CALL cl_err(g_ksd[l_ac].ksd30,g_errno,1)
#                      NEXT FIELD ksd07
#                   END IF
#                   LET g_ksd[l_ac].ksd31 = g_factor
#                   DISPLAY BY NAME g_ksd[l_ac].ksd31
#                END IF
#                CALL t622_du_default(p_cmd)
#             END IF
#           END IF
#         END IF
#FUN-B50096 ----------------End----------------------
 
        AFTER FIELD ksd09    #入庫量
           IF NOT t622_ksd09_check(p_cmd) THEN NEXT FIELD ksd09 END IF  #FUN-910088--add--   #FUN-BC0104 add p_cmd
           
       #FUN-910088--mark--start--
       #   IF cl_null(g_ksd[l_ac].ksd09) THEN
       #      LET g_ksd[l_ac].ksd09 = 0
       #   END IF
 
       #   IF NOT cl_null(g_ksd[l_ac].ksd09) THEN
       #      IF g_ksd[l_ac].ksd09 < 0 THEN
       #         CALL cl_err(g_ksd[l_ac].ksd09,'afa1001',0)       #No.TQC-740145
       #         NEXT FIELD ksd09
       #      END IF
       #    LET l_sfb94 = ''
       #    SELECT sfb94 INTO l_sfb94 FROM sfb_file WHERE sfb01 = g_ksd[l_ac].ksd11
       #    IF l_sfb94 = 'Y' AND g_sma.sma896 = 'Y' THEN
       #       SELECT qcf091 INTO l_qcf091 FROM qcf_file   
       #        WHERE qcf01 = g_ksd[l_ac].ksd17
       #          AND qcf09 <> '2'   
       #          AND qcf14 = 'Y'
       #       IF STATUS OR l_qcf091 IS NULL THEN
       #          LET l_qcf091 = 0
       #       END IF
 
       #       SELECT SUM(ksd09) INTO l_tmp_qcqty FROM ksd_file,ksc_file
       #        WHERE ksd11 = g_ksd[l_ac].ksd11
       #          AND ksd17 = g_ksd[l_ac].ksd17
       #          AND ksd01 = ksc01
       #          AND ksc00 = '1'  
       #          AND (ksd01 != g_ksc.ksc01 OR                                                                             
       #              (ksd01 = g_ksc.ksc01 AND ksd03 != g_ksd[l_ac].ksd03))                                                
       #          AND kscconf <> 'X' 
       #       IF cl_null(l_tmp_qcqty) THEN LET l_tmp_qcqty = 0 END IF
       #     END IF
       #     IF l_sfb94='Y' AND g_sma.sma896='Y' AND
       #        (g_ksd[l_ac].ksd09) > l_qcf091 - l_tmp_qcqty
       #     THEN
       #        CALL cl_err(g_ksd[l_ac].ksd09,'asf-675',1)
       #        NEXT FIELD ksd09
       #     END IF
       #   END IF
       #   SELECT ima918,ima921 INTO g_ima918,g_ima921 
       #     FROM ima_file
       #    WHERE ima01 = g_ksd[l_ac].ksd04
       #      AND imaacti = "Y"
       #   
       #   IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
       #      (cl_null(g_ksd_t.ksd09) OR (g_ksd[l_ac].ksd09<>g_ksd_t.ksd09 )) THEN
       #      IF cl_null(g_ksd[l_ac].ksd06) THEN
       #         LET g_ksd[l_ac].ksd06 = ' '
       #      END IF
       #      IF cl_null(g_ksd[l_ac].ksd07) THEN
       #         LET g_ksd[l_ac].ksd07 = ' '
       #      END IF
       #      SELECT img09 INTO g_img09 FROM img_file
       #       WHERE img01=g_ksd[l_ac].ksd04
       #         AND img02=g_ksd[l_ac].ksd05
       #         AND img03=g_ksd[l_ac].ksd06
       #         AND img04=g_ksd[l_ac].ksd07
       #      CALL s_umfchk(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09) 
       #          RETURNING l_i,l_fac
       #      IF l_i = 1 THEN LET l_fac = 1 END IF
       #      CALL s_lotin(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
       #                   g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09,
       #                   l_fac,g_ksd[l_ac].ksd09,'','MOD')#CHI-9A0022 add ''
       #             RETURNING l_r,g_qty 
       #      IF l_r = "Y" THEN
       #         LET g_ksd[l_ac].ksd09 = g_qty
       #         LET g_ksd[l_ac].ksd09 = s_digqty(g_ksd[l_ac].ksd09,g_ksd[l_ac].ksd08)   #FUN-910088--add--
       #      END IF
       #   END IF
       #FUN-910088--mark--end--
 
 
 
        BEFORE FIELD ksd33
           IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
              SELECT ima25,ima31 INTO g_ima25,g_ima31
                FROM ima_file WHERE ima01=g_ksd[l_ac].ksd04
           END IF
           CALL t622_set_no_required()
 
        AFTER FIELD ksd33  #第二單位
           IF cl_null(g_ksd[l_ac].ksd04) THEN NEXT FIELD ksd04 END IF
           IF g_ksd[l_ac].ksd05 IS NULL OR g_ksd[l_ac].ksd06 IS NULL OR
              g_ksd[l_ac].ksd07 IS NULL THEN
              NEXT FIELD ksd07
           END IF
           IF NOT cl_null(g_ksd[l_ac].ksd33) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ksd[l_ac].ksd33
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ksd[l_ac].ksd33,"",STATUS,"","gfe",1)  #No.FUN-660128
                 NEXT FIELD ksd33
              END IF
              CALL s_du_umfchk(g_ksd[l_ac].ksd04,'','','',
                               g_img09,g_ksd[l_ac].ksd33,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ksd[l_ac].ksd33,g_errno,0)
                 NEXT FIELD ksd33
              END IF
              LET g_ksd[l_ac].ksd34 = g_factor
              DISPLAY BY NAME g_ksd[l_ac].ksd34    #CHI-950036
              CALL s_chk_imgg(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                              g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                              g_ksd[l_ac].ksd33) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_argv = '2' THEN    #入庫退回
                    CALL cl_err('sel img:',STATUS,0)
                    NEXT FIELD ksd05
                 END IF
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN NEXT FIELD ksd33 END IF
                 END IF
                    CALL s_add_imgg(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                                    g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                                    g_ksd[l_ac].ksd33,g_ksd[l_ac].ksd34,
                                    g_ksc.ksc01,
                                    g_ksd[l_ac].ksd03,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD ksd33
                    END IF
              END IF
           END IF
           CALL t622_du_data_to_correct()
           CALL t622_set_required()
           CALL cl_show_fld_cont()
        #FUN-910088--add--start--
           IF NOT cl_null(g_ksd[l_ac].ksd35) AND g_ksd[l_ac].ksd35<>0 THEN  #FUN-C20048 add
              IF NOT t622_ksd35_check(p_cmd) THEN
                 LET g_ksd33_t = g_ksd[l_ac].ksd33
                 NEXT FIELD ksd35
              END IF
           END IF                                                           #FUN-C20048
           LET g_ksd33_t = g_ksd[l_ac].ksd33
        #FUN-910088--add--end--
 
        BEFORE FIELD ksd34  #第二轉換率
           IF cl_null(g_ksd[l_ac].ksd04) THEN NEXT FIELD ksd04 END IF
           IF g_ksd[l_ac].ksd05 IS NULL OR g_ksd[l_ac].ksd06 IS NULL OR
              g_ksd[l_ac].ksd07 IS NULL THEN
              NEXT FIELD ksd07
           END IF
 
        AFTER FIELD ksd34  #第二轉換率
           IF NOT cl_null(g_ksd[l_ac].ksd34) THEN
              IF g_ksd[l_ac].ksd34=0 THEN
                 NEXT FIELD ksd34
              END IF
           END IF
 
        AFTER FIELD ksd35  #第二數量
           IF NOT t622_ksd35_check(p_cmd) THEN NEXT FIELD ksd35 END IF   #FUN-910088--add--
         #FUN-910088--mark--start--
         # IF NOT cl_null(g_ksd[l_ac].ksd35) THEN
         #    IF g_ksd[l_ac].ksd35 < 0 THEN
         #       CALL cl_err('','aim-391',0)  #
         #       NEXT FIELD ksd35
         #    END IF
         #    IF p_cmd = 'a' OR  p_cmd = 'u' AND
         #       g_ksd_t.ksd35 <> g_ksd[l_ac].ksd35 THEN
         #       IF g_ima906='3' THEN
         #          LET g_tot=g_ksd[l_ac].ksd35*g_ksd[l_ac].ksd34
         #          IF cl_null(g_ksd[l_ac].ksd32) OR g_ksd[l_ac].ksd32=0 THEN #CHI-960022
         #             LET g_ksd[l_ac].ksd32=g_tot*g_ksd[l_ac].ksd31
         #             LET g_ksd[l_ac].ksd32 = s_digqty(g_ksd[l_ac].ksd32,g_ksd[l_ac].ksd30)   #FUN-910088--add--
         #             DISPLAY BY NAME g_ksd[l_ac].ksd32                      #CHI-960022
         #          END IF                                                    #CHI-960022
         #       END IF
         #    END IF
         # SELECT ima918,ima921 INTO g_ima918,g_ima921 
         #   FROM ima_file
         #  WHERE ima01 = g_ksd[l_ac].ksd04
         #    AND imaacti = "Y"
         # 
         # IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
         #    (cl_null(g_ksd_t.ksd35) OR (g_ksd[l_ac].ksd35<>g_ksd_t.ksd35 )) THEN
         #    IF cl_null(g_ksd[l_ac].ksd06) THEN
         #       LET g_ksd[l_ac].ksd06 = ' '
         #    END IF
         #    IF cl_null(g_ksd[l_ac].ksd07) THEN
         #       LET g_ksd[l_ac].ksd07 = ' '
         #    END IF
         #    SELECT img09 INTO g_img09 FROM img_file
         #     WHERE img01=g_ksd[l_ac].ksd04
         #       AND img02=g_ksd[l_ac].ksd05
         #       AND img03=g_ksd[l_ac].ksd06
         #       AND img04=g_ksd[l_ac].ksd07
         #    CALL s_umfchk(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09) 
         #        RETURNING l_i,l_fac
         #    IF l_i = 1 THEN LET l_fac = 1 END IF
         #    CALL s_lotin(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
         #                 g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09,
         #                 l_fac,g_ksd[l_ac].ksd09,'','MOD')#CHI-9A0022 add ''
         #           RETURNING l_r,g_qty 
         #    IF l_r = "Y" THEN
         #       LET g_ksd[l_ac].ksd09 = g_qty
         #       LET g_ksd[l_ac].ksd09 = s_digqty(g_ksd[l_ac].ksd09,g_ksd[l_ac].ksd08)   #FUN-910088--add--
         #    END IF
         # END IF
         # END IF
         # CALL cl_show_fld_cont()
         #FUN-910088--mark--end--
 
        BEFORE FIELD ksd30
           CALL t622_set_no_required()
 
        AFTER FIELD ksd30  #第一單位
           IF cl_null(g_ksd[l_ac].ksd04) THEN NEXT FIELD ksd04 END IF
           IF g_ksd[l_ac].ksd05 IS NULL OR g_ksd[l_ac].ksd06 IS NULL OR
              g_ksd[l_ac].ksd07 IS NULL THEN
              NEXT FIELD ksd07
           END IF
           IF NOT cl_null(g_ksd[l_ac].ksd30) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_ksd[l_ac].ksd30
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_ksd[l_ac].ksd30,"",STATUS,"","gfe:",1)  #No.FUN-660128
                 NEXT FIELD ksd30
              END IF
              CALL s_du_umfchk(g_ksd[l_ac].ksd04,'','','',
                               g_ksd[l_ac].ksd08,g_ksd[l_ac].ksd30,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ksd[l_ac].ksd30,g_errno,0)
                 NEXT FIELD ksd30
              END IF
              LET g_ksd[l_ac].ksd31 = g_factor
              DISPLAY BY NAME g_ksd[l_ac].ksd31   #CHI-950036
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                                 g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                                 g_ksd[l_ac].ksd30) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_argv = '2' THEN    #入庫退回
                       CALL cl_err('sel img:',STATUS,0)
                       NEXT FIELD ksd05
                    END IF
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD ksd30 END IF
                    END IF
                       CALL s_add_imgg(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                                       g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                                       g_ksd[l_ac].ksd30,g_ksd[l_ac].ksd31,
                                       g_ksc.ksc01,
                                       g_ksd[l_ac].ksd03,0) RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD ksd30
                       END IF
                 END IF
              END IF
              IF NOT cl_null(g_ksd[l_ac].ksd33) AND g_ima906 = '3' THEN
                 CALL s_chk_imgg(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                                 g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                                 g_ksd[l_ac].ksd33) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_argv = '2' THEN    #入庫退回
                       CALL cl_err('sel img:',STATUS,0)
                       NEXT FIELD ksd05
                    END IF
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN NEXT FIELD ksd33 END IF
                    END IF
                       CALL s_add_imgg(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                                       g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                                       g_ksd[l_ac].ksd33,g_ksd[l_ac].ksd34,
                                       g_ksc.ksc01,
                                       g_ksd[l_ac].ksd03,0) RETURNING g_flag
                       IF g_flag = 1 THEN
                          NEXT FIELD ksd30
                       END IF
                 END IF
              END IF
           END IF
           CALL t622_du_data_to_correct()
           CALL t622_set_required()
           CALL cl_show_fld_cont()
        #FUN-910088--add--start--
           IF NOT t622_ksd32_check(p_cmd) THEN   #FUN-BC0104 add p_cmd
              LET g_ksd30_t = g_ksd[l_ac].ksd30
              NEXT FIELD ksd32
           END IF
           LET g_ksd30_t = g_ksd[l_ac].ksd30
        #FUN-910088--add--end--
 
        AFTER FIELD ksd31  #第一轉換率
           IF NOT cl_null(g_ksd[l_ac].ksd31) THEN
              IF g_ksd[l_ac].ksd31=0 THEN
                 NEXT FIELD ksd31
              END IF
           END IF
 
        AFTER FIELD ksd32  #第一數量
           IF NOT t622_ksd32_check(p_cmd) THEN NEXT FIELD ksd32 END IF   #FUN-910088--add-- #FUN-BC0104 add p_cmd
        #FUN-910088--mark--start--
        #  IF NOT cl_null(g_ksd[l_ac].ksd32) THEN
        #     IF g_ksd[l_ac].ksd32 < 0 THEN
        #        CALL cl_err('','aim-391',0)  #
        #        NEXT FIELD ksd32
        #     END IF
        #  END IF
        #  CALL cl_show_fld_cont()
        #FUN-910088--mark--end--

        #FUN-D10094--add--str--
        BEFORE FIELD ksd36
          IF g_aza.aza115 = 'Y' AND cl_null(g_ksd[l_ac].ksd36) THEN 
             LET g_ksd[l_ac].ksd36=s_reason_code(g_ksc.ksc01,g_ksd[l_ac].ksd11,'',g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,'',g_ksc.ksc04) 
             CALL t622_azf03_desc()  #TQC-D20042 add
             DISPLAY BY NAME g_ksd[l_ac].ksd36
          END IF
       
        AFTER FIELD ksd36
           IF NOT cl_null(g_ksd[l_ac].ksd36) THEN #TQC-D20042
              IF t622_ksd36_check() THEN 
                 SELECT azf03 INTO g_ksd[l_ac].azf03 FROM azf_file WHERE azf01=g_ksd[l_ac].ksd36 AND azf02='2'
                 DISPLAY g_ksd[l_ac].azf03 TO azf03c
              END IF 
           END IF 
           CALL t622_azf03_desc()  #TQC-D20042 add
        #FUN-D10094--add--end-- 
        
        AFTER FIELD ksdud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ksdud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
 
        BEFORE DELETE
           IF g_ksd_t.ksd03 > 0 AND g_ksd_t.ksd03 IS NOT NULL THEN
               IF NOT cl_delb(0,0) THEN
                  CANCEL DELETE
               END IF
 
               IF l_lock_sw = "Y" THEN
                  CALL cl_err("", -263, 1)
                  CANCEL DELETE
               END IF
 
               DELETE FROM ksd_file
                WHERE ksd01 = g_ksc.ksc01 AND ksd03 = g_ksd_t.ksd03
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("del","ksd_file",g_ksc.ksc01,g_ksd_t.ksd03,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                  ROLLBACK WORK
                  CANCEL DELETE
               END IF
               #FUN-BC0104---add---str
                IF NOT s_iqctype_upd_qco20(g_ksd[l_ac].ksd17,0,0,g_ksd[l_ac].ksd47,'3') THEN
                   ROLLBACK WORK
                   CANCEL DELETE 
                END IF
                #FUN-BC0104---add---end
 
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_ksd[l_ac].ksd04
                 AND imaacti = "Y"
              
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                #IF NOT s_lotin_del(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,g_ksd[l_ac].ksd04,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                 IF NOT s_lot_del(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,g_ksd[l_ac].ksd04,'DEL') THEN   #No.FUN-860045  #TQC-B90236 add
                    CALL cl_err3("del","rvbs_file",g_ksc.ksc01,g_ksd_t.ksd03,
                                  SQLCA.sqlcode,"","",1)
                     ROLLBACK WORK
                     CANCEL DELETE
                 END IF
              END IF
 
               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
	       COMMIT WORK
           END IF
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_ksd[l_ac].* = g_ksd_t.*
              CLOSE t622_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF NOT t622_ksd36_check() THEN NEXT FIELD ksd36 END IF  #TQC-D20042
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_ksd[l_ac].ksd03,-263,1)
              LET g_ksd[l_ac].* = g_ksd_t.*
           ELSE
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_ksd[l_ac].ksd04)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD ksd04
                 END IF
 
                 CALL t622_du_data_to_correct()
                 CALL t622_set_origin_field()
              END IF            #No.TQC-680012 add
                 CALL t622_b_else()
                 CALL t622_b_move_back() #FUN-730075
                UPDATE ksd_file SET * = b_ksd.*
                  WHERE ksd01=g_ksc.ksc01
                    AND ksd03=g_ksd_t.ksd03
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("upd","ksd_file",g_ksc.ksc01,g_ksd_t.ksd03,SQLCA.sqlcode,"","upd ksd",1)  #No.FUN-660128
                 LET g_ksd[l_ac].* = g_ksd_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 #FUN-BC0104---add---str
                  IF NOT s_iqctype_upd_qco20(g_ksd[l_ac].ksd17,0,0,g_ksd[l_ac].ksd47,'3') THEN
                     ROLLBACK WORK 
                  END IF
                  #FUN-BC0104---add---end
	         COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac      #FUN-D40030 Mark
#CHI-B90021 ---------------Begin-------------------
        #  #FUN-A40022----begin--add--------------- 
        #  IF s_industry('icd') THEN   #FUN-B50096
        #     IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
        #        LET l_imaicd13='' 
        #        SELECT imaicd13 INTO l_imaicd13
        #          FROM imaicd_file
        #         WHERE imaicd00 = g_ksd[l_ac].ksd04
        #        IF l_imaicd13 = 'Y' THEN 
        #           IF (cl_null(g_ksd[l_ac].ksd07) OR cl_null(g_ksd[l_ac].ksd05))THEN
        #              IF NOT t622_chk_ksd() THEN 
        #                 LET INT_FLAG = 0
        #                 CALL cl_err(g_ksd[l_ac].ksd04,'aic-205',1)
        #                 NEXT FIELD ksd05
        #              END IF 
        #           END IF
        #        END IF
        #     END IF
        #  END IF
        #  #FUN-A40022--end--add------------------
#CHI-B90021 ---------------End--------------------
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'a' AND l_ac <= g_ksd.getLength() THEN #CHI-C30118 add
                 SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_ksd[l_ac].ksd04
                   AND imaacti = "Y"
                
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   #IF NOT s_lotin_del(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,g_ksd[l_ac].ksd04,'DEL') THEN   #No.FUN-860045  #TQC-B90236 mark
                    IF NOT s_lot_del(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,g_ksd[l_ac].ksd04,'DEL') THEN   #No.FUN-860045  #TQC-B90236 add
                       CALL cl_err3("del","rvbs_file",g_ksc.ksc01,g_ksd_t.ksd03,
                                     SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
              END IF #CHI-C30118 add 
              IF p_cmd='u' THEN
                 LET g_ksd[l_ac].* = g_ksd_t.* 
             #MOD-C50012---S--- 
              ELSE
                 INITIALIZE g_ksd[l_ac].* TO NULL
                 CALL g_ksd.deleteElement(l_ac)
                 #FUN-D40030--add--str--
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
                 #FUN-D40030--add--end--   
             #MOD-C50012---E---
              END IF
              CLOSE t622_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac      #FUN-D40030 Add  
          #MOD-C50012---S---
           IF l_ac <= g_ksd.getLength() THEN
              CASE t622_b_ksd07_inschk(p_cmd)
                 WHEN "ksd05" NEXT FIELD ksd05
                 WHEN "ksd07" NEXT FIELD ksd07
              END CASE
           END IF
          #MOD-C50012---E---
           IF NOT t622_ksd36_check() THEN NEXT FIELD ksd36 END IF  #TQC-D20042
           CLOSE t622_bcl
           COMMIT WORK
           #CKP
          #CALL g_ksd.deleteElement(g_rec_b+1)   #FUN-D40030 Mark
 
    #CHI-C30118---add---START 回寫批序料號資料
        AFTER INPUT
            SELECT COUNT(*) INTO g_cnt FROM ksd_file WHERE ksd01=g_ksc.ksc01
            FOR l_ac2 = 1 TO g_cnt
                LET g_ima918 = ' '
                LET g_ima921 = ' '
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                  FROM ima_file
                 WHERE ima01 = g_ksd[l_ac2].ksd04
                   AND imaacti = "Y"
                   
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   UPDATE rvbs_file SET rvbs021 = g_ksd[l_ac2].ksd04
                     WHERE rvbs00 = g_prog
                       AND rvbs01 = g_ksc.ksc01
                       AND rvbs02 = g_ksd[l_ac2].ksd03
                END IF
            END FOR
    #CHI-C30118---add---END 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(ksd03) AND l_ac > 1 THEN
              LET g_ksd[l_ac].* = g_ksd[l_ac-1].*
              LET g_ksd[l_ac].ksd03 = NULL
              NEXT FIELD ksd03
           END IF
 
        ON ACTION controlp
           CASE WHEN INFIELD(ksd11)    #拆件式工單單號
                      #MOD-490170
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_sfb11"
                     LET g_qryparam.default1 = g_ksd[l_ac].ksd11
                     ##組合拆解的工單不顯示出來!
                   # LET g_qryparam.where = " substr(sfb01,1,",g_doc_len,") NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "
                     LET g_qryparam.where = " sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "    #FUN-B40029
                     CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd11
                      DISPLAY BY NAME g_ksd[l_ac].ksd11    #No.MOD-490371
                     NEXT FIELD ksd11
                WHEN INFIELD(ksd04)     #料號
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_bmb303"
                     LET g_qryparam.arg1 =l_sfb05
                     LET g_qryparam.arg2 =g_sfb.sfb071   #FUN-5C0091
                     LET g_qryparam.default1 = g_ksd[l_ac].ksd04
                     CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd04
                      DISPLAY BY NAME g_ksd[l_ac].ksd04     #No.MOD-490371
                     NEXT FIELD ksd04
                WHEN INFIELD(ksd17)    #FQC NO.
                     IF g_argv<>'3' THEN 
                        CALL q_qcf(FALSE,TRUE,g_ksd[l_ac].ksd17,'1')
                        RETURNING  g_ksd[l_ac].ksd17
                        DISPLAY BY NAME g_ksd[l_ac].ksd17
                     ELSE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_srg03"
                        CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd17,l_sfv14
                        DISPLAY BY NAME g_ksd[l_ac].ksd17
                     END IF
                     NEXT FIELD ksd17
                WHEN INFIELD(ksd08)     #單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_ksd[l_ac].ksd08
                     CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd08
                      DISPLAY BY NAME g_ksd[l_ac].ksd08    #No.MOD-490371
                     NEXT FIELD ksd08
                WHEN INFIELD(ksd05) OR INFIELD(ksd06) OR INFIELD(ksd07)
                  #FUN-C30300---begin
                   LET g_ima906 = NULL
                   SELECT ima906 INTO g_ima906 FROM ima_file
                    WHERE ima01 = g_ksd[l_ac].ksd04
                   #IF s_industry("icd") AND g_ima906='3' THEN  #TQC-C60028
                   IF s_industry("icd") THEN  #TQC-C60028
                      CALL q_idc(FALSE,TRUE,g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07)
                      RETURNING g_ksd[l_ac].ksd05,g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07
                   ELSE
                   #FUN-C30300---end 
                     CALL q_img4(FALSE,TRUE,g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,   ##NO.FUN-660085
                                 g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,'A')
                       RETURNING g_ksd[l_ac].ksd05,g_ksd[l_ac].ksd06,
                                 g_ksd[l_ac].ksd07
                   END IF #FUN-C30300
                     DISPLAY g_ksd[l_ac].ksd05 TO ksd05
                     DISPLAY g_ksd[l_ac].ksd06 TO ksd06
                     DISPLAY g_ksd[l_ac].ksd07 TO ksd07
                     IF INFIELD(ksd05) THEN NEXT FIELD ksd05 END IF
                     IF INFIELD(ksd06) THEN NEXT FIELD ksd06 END IF
                     IF INFIELD(ksd07) THEN NEXT FIELD ksd07 END IF
                WHEN INFIELD(ksd30) #第一單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_ksd[l_ac].ksd30
                     CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd30
                     DISPLAY BY NAME g_ksd[l_ac].ksd30
                     NEXT FIELD ksd30
 
                WHEN INFIELD(ksd33) #第二單位
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.default1 = g_ksd[l_ac].ksd33
                     CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd33
                     DISPLAY BY NAME g_ksd[l_ac].ksd33
                     NEXT FIELD ksd33

                #FUN-BC0104---add---str
                WHEN INFIELD(ksd46)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_qco1"
                     LET g_qryparam.default1 = g_ksd[l_ac].ksd46
                     LET g_qryparam.arg1 = g_ksd[l_ac].ksd17
                     CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd46,g_ksd[l_ac].ksd47
                     DISPLAY BY NAME g_ksd[l_ac].ksd46,g_ksd[l_ac].ksd47
                     NEXT FIELD ksd46

                WHEN INFIELD(ksd47)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_qco1"
                     LET g_qryparam.default1 = g_ksd[l_ac].ksd47
                     LET g_qryparam.arg1 = g_ksd[l_ac].ksd17
                     CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd46,g_ksd[l_ac].ksd47
                     DISPLAY BY NAME g_ksd[l_ac].ksd46,g_ksd[l_ac].ksd47
                     NEXT FIELD ksd47
                #FUN-BC0104---add---end

                #FUN-D10094---add---str--- 
                WHEN INFIELD(ksd36)
                     CALL s_get_where(g_ksc.ksc01,g_ksd[l_ac].ksd11,'',g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,'',g_ksc.ksc04) RETURNING l_flag,l_where
                     IF l_flag AND g_aza.aza115 = 'Y' THEN 
                        CALL cl_init_qry_var()
                        LET g_qryparam.form  ="q_ggc08"
                        LET g_qryparam.where = l_where
                        LET g_qryparam.default1 = g_ksd[l_ac].ksd36
                     ELSE
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_azf41"              
                        LET g_qryparam.default1 = g_ksd[l_ac].ksd36
                     END IF 
                     CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd36
                     DISPLAY BY NAME g_ksd[l_ac].ksd36
                     CALL t622_azf03_desc()  #TQC-D20042 add
                     NEXT FIELD ksd36
                #FUN-D10094---add---end---
                  
                WHEN INFIELD(ksd930)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gem4"
                   CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd930
                   DISPLAY BY NAME g_ksd[l_ac].ksd930
                   NEXT FIELD ksd930
           END CASE
 
        ON ACTION gen_detail
           CALL t622_y_b()
           CALL t622_b_fill(" 1=1")
           COMMIT WORK
           LET g_errno='genb'
           EXIT INPUT
 
        ON ACTION qry_warehouse
                    #Mod No.FUN-AB0047
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_imd"
                    #LET g_qryparam.default1 = g_ksd[l_ac].ksd05
                    #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                    #CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd05
                     CALL q_imd_1(FALSE,TRUE,g_ksd[l_ac].ksd05,"",g_plant,"","")  #只能开当前门店的
                          RETURNING g_ksd[l_ac].ksd05
                    #End Mod No.FUN-AB0047
                     NEXT FIELD ksd05
 
        ON ACTION qry_location
                    #Mod No.FUN-AB0047
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form ="q_ime"
                    #LET g_qryparam.default1 = g_ksd[l_ac].ksd06
                    #LET g_qryparam.arg1     = g_ksd[l_ac].ksd05 #倉庫編號 #MOD-4A0063
                    #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                    #CALL cl_create_qry() RETURNING g_ksd[l_ac].ksd06
                     CALL q_ime_1(FALSE,TRUE,g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd05,"",g_plant,"","","")
                          RETURNING g_ksd[l_ac].ksd06
                    #End Mod No.FUN-AB0047
                     NEXT FIELD ksd06
 
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_ksd[l_ac].ksd04
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              IF cl_null(g_ksd[l_ac].ksd06) THEN
                 LET g_ksd[l_ac].ksd06 = ' '
              END IF
              IF cl_null(g_ksd[l_ac].ksd07) THEN
                 LET g_ksd[l_ac].ksd07 = ' '
              END IF
              SELECT img09 INTO g_img09 FROM img_file
               WHERE img01=g_ksd[l_ac].ksd04
                 AND img02=g_ksd[l_ac].ksd05
                 AND img03=g_ksd[l_ac].ksd06
                 AND img04=g_ksd[l_ac].ksd07
              CALL s_umfchk(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09) 
                  RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF
#TQC-B90236--mark--begin
#             CALL s_lotin(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
#                          g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09,
#                          l_fac,g_ksd[l_ac].ksd09,'','MOD')#CHI-9A0022 add ''
#TQC-B90236--mark--end
#TQC-B90236--add---begin
              CALL s_mod_lot(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
                             g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                             g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                             g_ksd[l_ac].ksd08,g_img09,l_fac,g_ksd[l_ac].ksd09,'','MOD',1)
#TQC-B90236--add---end
                     RETURNING l_r,g_qty 
              IF l_r = "Y" THEN
                 LET g_ksd[l_ac].ksd09 = g_qty
                 LET  g_ksd[l_ac].ksd09= s_digqty( g_ksd[l_ac].ksd09, g_ksd[l_ac].ksd08)    #FUN-910088--add--
              END IF
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
    UPDATE ksc_file SET kscmodu = g_user,kscdate = g_today
     WHERE ksc01 = g_ksc.ksc01
 
    CLOSE t622_bcl
    COMMIT WORK
    CALL t622_delHeader()     #CHI-C30002 add
 
END FUNCTION
 

#CHI-C30002 -------- add -------- begin
FUNCTION t622_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_ksc.ksc01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM ksc_file ",
                  "  WHERE ksc01 LIKE '",l_slip,"%' ",
                  "    AND ksc01 > '",g_ksc.ksc01,"'"
      PREPARE t622_pb1 FROM l_sql 
      EXECUTE t622_pb1 INTO l_cnt 
      
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
        #CALL t622_x()   #CHI-D20010
         CALL t622_x(1)  #CHI-D20010
         CALL t622_show() #FUN-BC0104 add
         #圖形顯示
         IF g_ksc.kscconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM ksc_file WHERE ksc01 = g_ksc.ksc01
         INITIALIZE g_ksc.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
#FUN-B50096 -----------------Begin------------------
FUNCTION t622_b_ksd07_inschk(p_cmd)
DEFINE l_ima159   LIKE ima_file.ima159
DEFINE p_cmd      LIKE type_file.chr1
    IF cl_null(g_ksd[l_ac].ksd06) THEN LET g_ksd[l_ac].ksd06 = ' ' END IF   #TQC-D10107 add
    IF cl_null(g_ksd[l_ac].ksd07) THEN LET g_ksd[l_ac].ksd07 = ' ' END IF   #TQC-D10107 add
    IF g_ksd[l_ac].ksd07 = '　' THEN #全型空白
        LET g_ksd[l_ac].ksd07 = ' '
    END IF
    IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
       LET l_ima159 = ''
       SELECT ima159 INTO l_ima159 FROM ima_file
        WHERE ima01 = g_ksd[l_ac].ksd04  
       IF l_ima159 = '1' AND cl_null(g_ksd[l_ac].ksd07) THEN
          CALL cl_err(g_ksd[l_ac].ksd04,'aim-034',1)
          RETURN "ksd07"
       END IF
    END IF
    IF g_argv MATCHES '[12]' THEN
       IF g_ksd[l_ac].ksd07 IS NULL THEN
          LET g_ksd[l_ac].ksd07 = ' '
       END IF
 
     IF NOT cl_null(g_ksd[l_ac].ksd05) THEN
       SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
        WHERE img01=g_ksd[l_ac].ksd04 AND img02=g_ksd[l_ac].ksd05
          AND img03=g_ksd[l_ac].ksd06 AND img04=g_ksd[l_ac].ksd07
 
       IF STATUS THEN
          IF g_sma.sma892[3,3] = 'Y' THEN
             IF NOT cl_confirm('mfg1401') THEN
               #RETURN "ksd07"   #MOD-C50012 mark
                RETURN "ksd05"   #MOD-C50012
             END IF
          END IF
 
          CALL s_add_img(g_ksd[l_ac].ksd04, g_ksd[l_ac].ksd05,
                         g_ksd[l_ac].ksd06, g_ksd[l_ac].ksd07,
                         g_ksc.ksc01,       g_ksd[l_ac].ksd03, g_today)
 
          IF g_errno='N' THEN
            #RETURN "ksd07"   #MOD-C50012 mark
             RETURN "ksd05"   #MOD-C50012
          END IF
 
          SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
           WHERE img01=g_ksd[l_ac].ksd04 AND img02=g_ksd[l_ac].ksd05
             AND img03=g_ksd[l_ac].ksd06 AND img04=g_ksd[l_ac].ksd07
 
       END IF

      #MOD-C50012---S---
          SELECT COUNT(*) INTO g_cnt FROM img_file
           WHERE img01 = g_ksd[l_ac].ksd04   #料號
             AND img02 = g_ksd[l_ac].ksd05   #倉庫
             AND img03 = g_ksd[l_ac].ksd06   #儲位
             AND img04 = g_ksd[l_ac].ksd07   #批號
             AND img18 < g_ksc.ksc02   #調撥日期
          IF g_cnt > 0 THEN    #大於有效日期
             CALL cl_err('','aim-400',0)   #須修改
             RETURN "ksd07"
          END IF
      #MOD-C50012---E---
 
       IF g_sma.sma115 = 'N' THEN
          IF cl_null(g_ksd[l_ac].ksd08) THEN   #若單位空白
             LET g_ksd[l_ac].ksd08=g_img09
          END IF
       ELSE
      #MOD-C50012---S---
      #   SELECT COUNT(*) INTO g_cnt FROM img_file
      #    WHERE img01 = g_ksd[l_ac].ksd04   #料號
      #      AND img02 = g_ksd[l_ac].ksd05   #倉庫
      #      AND img03 = g_ksd[l_ac].ksd06   #儲位
      #      AND img04 = g_ksd[l_ac].ksd07   #批號
      #      AND img18 < g_ksc.ksc02   #調撥日期
      #   IF g_cnt > 0 THEN    #大於有效日期
      #      CALL cl_err('','aim-400',0)   #須修改
      #      RETURN "ksd07"
      #   END IF
      #MOD-C50012---E---
          # - FQC入庫不做雙單位處理
          IF cl_null(g_ksd[l_ac].ksd17) OR (g_argv='3') THEN  
             CALL t622_du_default(p_cmd)
          ELSE
             CALL s_du_umfchk(g_ksd[l_ac].ksd04,'','','',
                              g_img09,g_ksd[l_ac].ksd30,'1')
                  RETURNING g_errno,g_factor
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ksd[l_ac].ksd30,g_errno,1)
                RETURN "ksd07"
             END IF
             LET g_ksd[l_ac].ksd31 = g_factor
             DISPLAY BY NAME g_ksd[l_ac].ksd31
          END IF
          CALL t622_du_default(p_cmd)
       END IF
     END IF
   END IF
   RETURN NULL
END FUNCTION
#FUN-B50096 -----------------End--------------------

FUNCTION  t622_ksd17(p_cmd)
 DEFINE l_qcf02   LIKE qcf_file.qcf02,
        l_qcf021  LIKE qcf_file.qcf021,
        l_qcf14   LIKE qcf_file.qcf14,
        l_qcfacti LIKE qcf_file.qcfacti,
        l_qcf09   LIKE qcf_file.qcf09,
        l_qcf36   LIKE qcf_file.qcf36,   #No.FUN-610075
        l_qcf37   LIKE qcf_file.qcf37,   #No.FUN-610075
        l_qcf38   LIKE qcf_file.qcf38,   #No.FUN-610075
        l_qcf39   LIKE qcf_file.qcf39,   #No.FUN-610075
        l_qcf40   LIKE qcf_file.qcf40,   #No.FUN-610075
        l_qcf41   LIKE qcf_file.qcf41,   #No.FUN-610075
        p_cmd     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_sfb94     LIKE sfb_file.sfb94,   #MOD-A30193 add
        l_qcf091    LIKE qcf_file.qcf091,  #MOD-A30193 add
        l_tmp_qcqty LIKE sfv_file.sfv09    #MOD-A30193 add

 
   LET g_errno = ''
   SELECT qcf02,qcf021,qcf14,qcfacti,qcf09,
          qcf36,qcf37,qcf38,qcf39,qcf40,qcf41  #No.FUN-610075
     INTO l_qcf02,l_qcf021,l_qcf14,l_qcfacti,l_qcf09,
          l_qcf36,l_qcf37,l_qcf38,l_qcf39,l_qcf40,l_qcf41  #No.FUN-610075
     FROM qcf_file
    WHERE qcf01 = g_ksd[l_ac].ksd17
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0044'
        WHEN l_qcfacti='N'        LET g_errno = '9028'
        WHEN l_qcf14='N'          LET g_errno = 'asf-048'
        WHEN l_qcf09='2'          LET g_errno = 'aqc-400'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) THEN
      LET g_ksd[l_ac].ksd11 = l_qcf02
      LET g_ksd[l_ac].ksd04 = l_qcf021
      LET g_ksd[l_ac].ksd30 = l_qcf36  
      LET g_ksd[l_ac].ksd31 = l_qcf37 
      LET g_ksd[l_ac].ksd32 = l_qcf38  
      LET g_ksd[l_ac].ksd33 = l_qcf39 
      LET g_ksd[l_ac].ksd34 = l_qcf40  
      LET g_ksd[l_ac].ksd35 = l_qcf41 
      DISPLAY BY NAME g_ksd[l_ac].ksd11
      DISPLAY BY NAME g_ksd[l_ac].ksd04
      DISPLAY BY NAME g_ksd[l_ac].ksd30,g_ksd[l_ac].ksd31,g_ksd[l_ac].ksd32  
      DISPLAY BY NAME g_ksd[l_ac].ksd33,g_ksd[l_ac].ksd34,g_ksd[l_ac].ksd35

    #str MOD-A30193 add
    #單身鍵入FQC單時,應帶出該筆FQC可入庫量
     LET l_sfb94 = ''
     SELECT sfb94 INTO l_sfb94 FROM sfb_file WHERE sfb01=g_ksd[l_ac].ksd11
     IF l_sfb94 = 'Y' AND g_sma.sma896 = 'Y' THEN
        #FQC合格量
        SELECT qcf091 INTO l_qcf091 FROM qcf_file
         WHERE qcf01 = g_ksd[l_ac].ksd17
           AND qcf09 <> '2'
           AND qcf14 = 'Y'
        IF STATUS OR l_qcf091 IS NULL THEN
           LET l_qcf091 = 0
        END IF
        #工單已入庫量
        SELECT SUM(ksd09) INTO l_tmp_qcqty FROM ksd_file,ksc_file
         WHERE ksd11 = g_ksd[l_ac].ksd11
           AND ksd17 = g_ksd[l_ac].ksd17
           AND ksd01 = ksc01
           AND ksc00 = '1'
           AND (ksd01!= g_ksc.ksc01 OR
               (ksd01 = g_ksc.ksc01 AND ksd03 != g_ksd[l_ac].ksd03))
           AND kscconf <> 'X'
        IF cl_null(l_tmp_qcqty) THEN LET l_tmp_qcqty = 0 END IF
        #入庫量=FQC量-已keyin入庫量
        LET g_ksd[l_ac].ksd09 = l_qcf091 - l_tmp_qcqty
        DISPLAY BY NAME g_ksd[l_ac].ksd09
     END IF
    #end MOD-A30193 add
   END IF
 
   IF cl_null(g_ksd_t.ksd11) OR g_ksd[l_ac].ksd11 ! = g_ksd_t.ksd11 THEN
      CALL t622_sfb01()
   END IF
 
END FUNCTION
 
FUNCTION t622_asr_ksd17()
DEFINE l_result LIKE type_file.num5, 
       l_cnt    LIKE type_file.num10 
 
   LET l_result=FALSE
   SELECT COUNT(*) INTO l_cnt FROM srf_file WHERE srfconf='Y'
                                              AND srf07='1' 
      AND srf01 = g_ksd[l_ac].ksd17     
   IF SQLCA.sqlcode THEN
      LET l_cnt=0
   END IF
   IF l_cnt = 0 THEN
      CALL cl_err(g_ksd[l_ac].ksd17,'asf-107',0)
      LET l_result=FALSE
   END IF
   IF l_cnt>0 THEN
      LET l_result=TRUE
   END IF
   RETURN l_result
END FUNCTION
 
FUNCTION t622_ksd11_1()
DEFINE l_date   LIKE type_file.dat
 
    IF NOT cl_null(g_ksd[l_ac].ksd11) THEN
       IF g_ksd[l_ac].ksd11 != g_ksd_t.ksd11
          OR cl_null(g_ksd_t.ksd11) THEN
          CALL t622_sfb01()
          IF NOT cl_null(g_errno) THEN
             CALL cl_err(g_ksd[l_ac].ksd11,g_errno,0)
             RETURN FALSE
          END IF
       ELSE
          SELECT sfb_file.* INTO g_sfb.* FROM sfb_file
           WHERE sfb01=g_ksd[l_ac].ksd11
             AND sfb04!= '8' AND sfb02 = 11
          IF STATUS THEN
             CALL cl_err3("sel","sfb_file",g_ksd[l_ac].ksd11,"",STATUS,"","sel sfb",1)  #No.FUN-660128
             RETURN FALSE
          END IF
       END IF
       CALL t622_ksd11_chk('')
       IF NOT cl_null(g_errno) THEN
          CALL cl_err(g_ksd[l_ac].ksd11,g_errno,0)
          RETURN FALSE
        END IF
       CALL t622sub_check_ksd11(g_ksd[l_ac].ksd11)
       IF NOT cl_null(g_errno) THEN 
          CALL cl_err(g_ksd[l_ac].ksd11,g_errno,1)
       END IF 
       #檢查工單最小發料日是否小於入庫日
       IF g_sfb.sfb39 != '2' THEN
          SELECT MIN(sfp02) INTO l_date FROM sfe_file,sfp_file
            WHERE sfe01 = g_ksd[l_ac].ksd11 AND sfe02 = sfp01
          IF STATUS OR cl_null(l_date) THEN
             SELECT MIN(sfp02) INTO l_date FROM sfs_file,sfp_file
              WHERE sfs03=g_ksd[l_ac].ksd11 AND sfp01=sfs01
          END IF
          IF cl_null(l_date) OR l_date > g_ksc.ksc02 THEN
             CALL cl_err('sel_sfp02','asf-824',1)
             RETURN FALSE
          END IF
      #MOD-C60047 str add------
       ELSE
          SELECT sfb81 INTO l_date FROM sfb_file WHERE sfb01 = g_ksd[l_ac].ksd11
          IF cl_null(l_date) OR l_date > g_ksc.ksc02 THEN
             CALL cl_err(g_ksd[l_ac].ksd11,'asf-342',1)
             RETURN FALSE
          END IF
      #MOD-C60047 end add------
       END IF
    END IF
    IF g_sfb.sfb94='Y' AND
       cl_null(g_ksd[l_ac].ksd17)  THEN  
       CALL cl_err(g_sfb.sfb01,'asf-680',1)
       RETURN FALSE
    END IF
    LET g_ksd[l_ac].ksd930=g_sfb.sfb98 
    LET g_ksd[l_ac].gem02c=s_costcenter_desc(g_ksd[l_ac].ksd930)
    RETURN TRUE 
END FUNCTION
 
#--->拆件式工單.. 拆出料件, 相關資料顯示於劃面
FUNCTION t622_ksd04()
   DEFINE l_ima02   LIKE ima_file.ima02,
          l_ima021  LIKE ima_file.ima021,
          l_ima1010 LIKE ima_file.ima1010, #MOD-910222 add
          l_ima25   LIKE ima_file.ima25,
          l_ima35   LIKE ima_file.ima35,  #CHI-6A0015 add
          l_ima36   LIKE ima_file.ima36   #CHI-6A0015 add
 
    LET g_errno=' '
    SELECT ima02,ima021,ima25,ima35,ima36,ima1010  #CHI-6A0015 add ima35/36  #MOD-910222 add ima1010
      INTO l_ima02,l_ima021,l_ima25,l_ima35,l_ima36,l_ima1010  #CHI-6A0015 add ima35/36 #MOD-910222 add ima1010
      FROM ima_file
     WHERE ima01 = g_ksd[l_ac].ksd04
    CASE
        WHEN SQLCA.sqlcode=100
             LET g_errno = 'mfg0002' #MOD-490223
            LET l_ima02=' '
            LET l_ima021=' '
            LET l_ima25=' '
        OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
    END CASE
    IF l_ima1010 <> '1' THEN
       LET g_errno = 'atm-380'
    END IF
    LET g_ksd[l_ac].ima02  = l_ima02
    LET g_ksd[l_ac].ima021 = l_ima021
    LET g_ksd[l_ac].ksd08  = l_ima25
    IF cl_null(g_ksd_t.ksd04) OR g_ksd_t.ksd04 <> g_ksd[l_ac].ksd04 THEN  #TQC-750018
      LET g_ksd[l_ac].ksd05  = l_ima35    #CHI-6A0015 add
      LET g_ksd[l_ac].ksd06  = l_ima36    #CHI-6A0015 add
      LET g_ksd[l_ac].ksd07  = NULL       #TQC-750018
    END IF   #TQC-750018
    DISPLAY BY NAME g_ksd[l_ac].ima02
    DISPLAY BY NAME g_ksd[l_ac].ima021
    DISPLAY BY NAME g_ksd[l_ac].ksd08
    DISPLAY BY NAME g_ksd[l_ac].ksd05   #CHI-6A0015 add
    DISPLAY BY NAME g_ksd[l_ac].ksd06   #CHI-6A0015 add
    DISPLAY BY NAME g_ksd[l_ac].ksd07   #CHI-6A0015 add
 
END FUNCTION
 
#--->拆件式工單相關資料顯示於劃面
FUNCTION  t622_sfb01()
   DEFINE
          l_ksd09   LIKE ksd_file.ksd09,
          l_cnt     LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          l_d2      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(15),
          l_d4      LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(20),
          l_no      LIKE oay_file.oayslip,  #No.FUN-680121 VARCHAR(05), #MOD-5B0102 3->5
          l_status  LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          p_ac      LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
          p_sl      LIKE type_file.num5     #No.FUN-680121 SMALLINT
 
    INITIALIZE g_sfb.* TO NULL
    LET g_min_set = 0
    SELECT sfb_file.*
    INTO g_sfb.*
    FROM  sfb_file
    WHERE sfb01=g_ksd[l_ac].ksd11
    IF SQLCA.sqlcode THEN
       LET l_status=SQLCA.sqlcode
    ELSE
       LET l_status=0
    END IF
    LET g_errno=' '
    CASE
       WHEN g_sfb.sfbacti='N' LET g_errno = '9028'
       WHEN g_sfb.sfb04 = '8' # 不得為已結案
            LET g_errno = 'mfg3430'
       WHEN g_sfb.sfb04<'2' OR   g_sfb.sfb28='3'
            LET g_errno='mfg9006'
       WHEN g_sfb.sfb02 != 11  # 僅允許輸入拆件式工單
            LET g_errno = 'asf-813'
       WHEN g_sfb.sfb04 < '4'
            IF g_sfb.sfb39 !=2 THEN    #MOD-C60047 add
               LET g_errno='asf-570'
            END IF                     #MOD-C60047 add

       OTHERWISE
            LET g_errno = l_status USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t622_b_else()
     IF g_ksd[l_ac].ksd05 IS NULL THEN LET g_ksd[l_ac].ksd05 =' ' END IF
     IF g_ksd[l_ac].ksd06 IS NULL THEN LET g_ksd[l_ac].ksd06 =' ' END IF
     IF g_ksd[l_ac].ksd07 IS NULL THEN LET g_ksd[l_ac].ksd07 =' ' END IF
END FUNCTION
 
FUNCTION t622_y_b()
DEFINE ls_tmp STRING
 
   IF g_ksc.ksc00 != '0' THEN
      LET ls_tmp = g_prog CLIPPED
      LET g_prog='aglt620y'
 
      OPEN WINDOW t622_y_w AT 2,12 WITH FORM "asf/42f/asft620y"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("asft620y")
 
 
      CALL t622_y_b1()
 
      CLOSE WINDOW t622_y_w
 
      LET g_prog = ls_tmp
   END IF
 
   CALL t622_b_fill(' 1=1')
 
END FUNCTION
 
FUNCTION t622_y_b1()
   DEFINE l_sql,l_wc	   LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(500)
   DEFINE i,j,k,l_i        LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE in_qty_t,qty_t   LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE l_sfb            DYNAMIC ARRAY OF RECORD
                          #sfb05   LIKE sfb_file.sfb05,   #FUN-650112 mark
                           bmb03   LIKE bmb_file.bmb03,   #FUN-650112                        sfb01   LIKE sfb_file.sfb01,
                           sfb01   LIKE sfb_file.sfb01,   #FUN-650112 add
                           seq     LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
                           qty     LIKE type_file.num10,   #No.FUN-680121 INTEGER,
                           y       LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1),
                           in_qty  LIKE type_file.num10,   #No.FUN-680121 INTEGER,
                           sfb98   LIKE sfb_file.sfb98 #FUN-670103
		           END RECORD
   DEFINE l_ksd RECORD     LIKE ksd_file.*
   DEFINE partno           LIKE sfb_file.sfb05 #No.MOD-490217
   DEFINE tot_qty,qty2     LIKE type_file.num10   #No.FUN-680121 INTEGER
   DEFINE seq1	           LIKE type_file.num5    #No.FUN-680121 SMALLINT
   DEFINE #ware,loc,lot    VARCHAR(20), #MOD-5B0102
          ware             LIKE img_file.img02, #MOD-5B0102
          loc              LIKE img_file.img03, #MOD-5B0102
          lot              LIKE img_file.img04, #MOD-5B0102
          l_allow_insert   LIKE type_file.num5,                #可新增否  #No.FUN-680121 SMALLINT
          l_allow_delete   LIKE type_file.num5                 #可刪除否  #No.FUN-680121 SMALLINT
 
   LET seq1=NULL
 
   INPUT BY NAME partno,tot_qty,seq1,ware,loc,lot WITHOUT DEFAULTS
 
      #Add No.FUN-AB0047
      AFTER FIELD ware
         IF NOT cl_null(ware) THEN
            IF NOT s_chk_ware(ware) THEN  #检查仓库是否属于当前门店
               NEXT FIELD ware
            END IF
         END IF
      #End Add No.FUN-AB0047

      AFTER INPUT
         IF ware IS NOT NULL OR loc IS NOT NULL THEN
            IF NOT s_chksmz('', g_ksc.ksc01,ware,loc) THEN
               NEXT FIELD ware
            END IF
         END IF
 
      ON ACTION controlp
         CASE WHEN INFIELD(partno)
#FUN-AB0025-------mod---------------str-------------
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form ="q_ima"
#                  LET g_qryparam.default1 = partno
#                  CALL cl_create_qry() RETURNING partno
                   CALL q_sel_ima(FALSE, "q_ima","",partno,"","","","","",'' ) 
                     RETURNING partno
#FUN-AB0025-------mod---------------end-----------
                   DISPLAY BY NAME partno
                   NEXT FIELD partno
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   IF INT_FLAG THEN LET INT_FLAG=0 END IF
 
   LET l_sql="SELECT bmb03,sfb01,ecm03,((sfb081-sfb09)*(bmb06/bmb07)),",
             "'','',sfb98", 
             "  FROM sfb_file LEFT OUTER JOIN ecm_file ON sfb01=ecm01 LEFT OUTER JOIN bmb_file ON sfb05 = bmb01 AND sfb95 = bmb29 ", #FUN-9A0085 mod
             " WHERE sfb081>sfb09 AND sfb04<'8'",
             "   AND sfb05 MATCHES '",partno CLIPPED,"'",
             "   AND sfb02='11'",
             "   AND (bmb04 <='", g_today,"'"," OR bmb04 IS NULL )",
             "   AND (bmb05 >  '",g_today,"'"," OR bmb05 IS NULL )"
   IF seq1 IS NOT NULL THEN
      LET l_sql=l_sql CLIPPED, " AND ecm_file.ecm03=",seq1
   END IF
   LET l_sql = l_sql CLIPPED," AND sfb01[1,",g_doc_len,"] NOT IN (SELECT smy69 FROM smy_file WHERE smy69 IS NOT NULL) "  #CHI-9B0005 mod
   LET l_sql=l_sql CLIPPED, " ORDER BY bmb03,sfb01,ecm03"   #FUN-650112
 
   PREPARE t622_y_b1_p FROM l_sql
   DECLARE t622_y_b1_c CURSOR FOR t622_y_b1_p
 
   LET i=1
   LET qty2=tot_qty
 
   MESSAGE "Waiting..."
   FOREACH t622_y_b1_c INTO l_sfb[i].*
      IF g_ksc.ksc00 = '1' THEN		# 入庫應取最小套數
         IF l_sfb[i].qty<=0 THEN CONTINUE FOREACH END IF
      END IF
      IF qty2>0 THEN
         LET l_sfb[i].y='Y'
         IF qty2 > l_sfb[i].qty THEN
            LET l_sfb[i].in_qty=l_sfb[i].qty
         ELSE
            LET l_sfb[i].in_qty=qty2
         END IF
         LET qty2 = qty2 - l_sfb[i].in_qty
      END IF
      LET i=i+1
   END FOREACH
   MESSAGE ""
   LET l_i = i - 1
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_sfb WITHOUT DEFAULTS FROM s_sfb.*
         ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
          CALL fgl_set_arr_curr(l_ac)
 
      BEFORE ROW
        LET i=ARR_CURR()
 
      BEFORE FIELD y
 
        LET qty_t=0 LET in_qty_t=0
 
        FOR k=1 TO l_sfb.getLength()
            IF l_sfb[k].qty > 0 THEN
               LET qty_t = qty_t+l_sfb[k].qty
            END IF
            IF l_sfb[k].y ='Y' AND l_sfb[k].in_qty IS NOT NULL THEN
               LET in_qty_t = in_qty_t+l_sfb[k].in_qty
            END IF
        END FOR
        DISPLAY BY NAME qty_t,in_qty_t
 
      BEFORE FIELD in_qty
        IF l_sfb[i].y IS NULL OR l_sfb[i].y<>'Y'  OR l_sfb[i].sfb01 IS NULL THEN
           LET l_sfb[i].in_qty=NULL
           DISPLAY l_sfb[i].in_qty TO s_sfb[j].in_qty
           NEXT FIELD PREVIOUS
        END IF
 
        IF l_sfb[i].in_qty IS NULL OR l_sfb[i].in_qty = 0 THEN
           LET l_sfb[i].in_qty = l_sfb[i].qty
           DISPLAY l_sfb[i].in_qty TO s_sfb[j].in_qty
        END IF
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
   END INPUT
 
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF NOT cl_sure(0,0) THEN RETURN END IF
 
   INITIALIZE l_ksd.* TO NULL
   SELECT MAX(ksd03) INTO l_ksd.ksd03 FROM ksd_file WHERE ksd01=g_ksc.ksc01
   IF l_ksd.ksd03 IS NULL
      THEN LET l_ksd.ksd03 = 0
   END IF
 
   FOR k=1 TO l_sfb.getLength()
      IF l_sfb[k].sfb01 IS NULL THEN
         CONTINUE FOR
      END IF
      IF l_sfb[k].in_qty IS NULL OR l_sfb[k].in_qty<=0 THEN
         CONTINUE FOR
      END IF
      LET l_ksd.ksd01=g_ksc.ksc01
      LET l_ksd.ksd03=l_ksd.ksd03+1
      LET l_ksd.ksd04=l_sfb[k].bmb03   #FUN-650112
      LET l_ksd.ksd05=ware
      LET l_ksd.ksd06=loc
      LET l_ksd.ksd07=lot
      IF cl_null(l_ksd.ksd06) THEN LET l_ksd.ksd06 = ' ' END IF
      IF cl_null(l_ksd.ksd07) THEN LET l_ksd.ksd07 = ' ' END IF
      SELECT ima55 INTO l_ksd.ksd08 FROM ima_file WHERE ima01=l_ksd.ksd04
      LET l_ksd.ksd09=l_sfb[k].in_qty
      LET l_ksd.ksd09 = s_digqty(l_ksd.ksd09,l_ksd.ksd08)   #FUN-910088--add--
      LET l_ksd.ksd11=l_sfb[k].sfb01
      LET l_ksd.ksd930=l_sfb[k].sfb98  #FUN-670103
 
      LET l_ksd.ksdplant = g_plant #FUN-980008 add
      LET l_ksd.ksdlegal = g_legal #FUN-980008 add
      #FUN-D10094--add--str--
      IF g_aza.aza115='Y' THEN 
         LET l_ksd.ksd36=s_reason_code(g_ksc.ksc01,l_ksd.ksd11,'',l_ksd.ksd04,l_ksd.ksd05,'',g_ksc.ksc04) 
      END IF 
      #FUN-D10094--add--end--
 
      INSERT INTO ksd_file VALUES(l_ksd.*)
      MESSAGE 'ins ksd:',l_ksd.ksd03,l_ksd.ksd11,STATUS
 
   END FOR
END FUNCTION
 
FUNCTION t622_b_askkey()
DEFINE l_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(200)
   
    CONSTRUCT l_wc2 ON ksd03,ksd17,ksd11,ksd04,ksd08,ksd05,ksd06,ksd07,ksd09,ksd12   #CHI-950036 add ksd17
                  FROM s_ksd[1].ksd03,s_ksd[1].ksd17,s_ksd[1].ksd11,s_ksd[1].ksd04,  #CHI-950036 add ksd17
                       s_ksd[1].ksd08,s_ksd[1].ksd05,s_ksd[1].ksd06,
                       s_ksd[1].ksd07,s_ksd[1].ksd09,s_ksd[1].ksd12
       ON IDLE g_idle_seconds
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    CALL t622_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION t622_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(200)
 
       IF p_wc2 IS NULL THEN
          LET p_wc2 = '1=1'
       END IF
       LET g_sql = "SELECT ksd03,ksd17,ksd11,ksd46,qcl02,ksd47,ksd04,ima02,ima021,",  #CHI-950036 add ksd17 FUN-BC0104 add ksd11,ksd46,qcl02
                   "ksd08,ksd05,ksd06,ksd07,ksd09,ksd33,ksd34,",
                   "ksd35,ksd30,ksd31,ksd32,ksd12,ksd930,'',ksd36,azf03 ", #FUN-670103 #FUN-D10094 ksd36,azf03
                   ",ksdud01,ksdud02,ksdud03,ksdud04,ksdud05,",
                   "ksdud06,ksdud07,ksdud08,ksdud09,ksdud10,",
                   "ksdud11,ksdud12,ksdud13,ksdud14,ksdud15", 
                   " FROM ksd_file LEFT  OUTER JOIN ima_file ON ksd04 = ima01 ",   #FUN-9A0085 mod
                   "               LEFT  OUTER JOIN qcl_file ON ksd46 = qcl01 ",   #FUN-BC0104 add
                   "               LEFT  OUTER JOIN azf_file ON azf01 = ksd36 AND azf02='2' ", #FUN-D10094
                   " WHERE ksd01 ='",g_ksc.ksc01,"'",  #單頭
                   "   AND ",p_wc2 CLIPPED,      #單身    #FUN-9A0085 mod
                   " ORDER BY 1"
 
    PREPARE t622_pb FROM g_sql
    DECLARE ksd_curs CURSOR FOR t622_pb
 
    CALL g_ksd.clear()
 
    LET g_cnt = 1
    FOREACH ksd_curs INTO g_ksd[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_ksd[g_cnt].gem02c=s_costcenter_desc(g_ksd[g_cnt].ksd930) #FUN-670103
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
    END FOREACH
    CALL g_ksd.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0

   #FUN-B30170 add begin-------------------------
   LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
               "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
               "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_ksc.ksc01,"'"
   PREPARE sel_rvbs_pre FROM g_sql
   DECLARE rvbs_curs CURSOR FOR sel_rvbs_pre

   CALL g_rvbs.clear()

   LET g_cnt = 1
   FOREACH rvbs_curs INTO g_rvbs[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvbs.deleteElement(g_cnt)
   LET g_rec_b1 = g_cnt - 1
   #FUN-B30170 add -end--------------------------
 
END FUNCTION
 
FUNCTION t622_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   IF g_errno='genb' THEN CALL t622_b_fill(' 1=1') LET g_errno='' END IF
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-B30170 add begin-------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_ksd TO s_ksd.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY
      
      DISPLAY ARRAY g_rvbs TO s_rvbs.* ATTRIBUTE(COUNT=g_rec_b1)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            CALL cl_show_fld_cont()

         AFTER DISPLAY
            CONTINUE DIALOG   #因為外層是DIALOG
      END DISPLAY

      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      #FUN-CB0014---add---str---
      ON ACTION page_list
         LET g_action_flag = "page_list"  
         EXIT DIALOG
      #FUN-CB0014---add---end--- 
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
      ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
      ON ACTION first
         CALL t622_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t622_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t622_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t622_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t622_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t622_def_form()   #FUN-610006
         ##圖形顯示
         IF g_ksc.kscconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
         
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
 
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DIALOG
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG

      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG 
      #CHI-D20010---end
 
     ON ACTION accept
        LET g_action_choice="detail"
        LET l_ac = ARR_CURR()
        EXIT DIALOG
     
     ON ACTION cancel
        LET INT_FLAG=FALSE 		#MOD-570244	mars
        LET g_action_choice="exit"
        EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
##
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG

      #FUN-BC0104---add---str
      #QC 結果判定產生入庫單
      ON ACTION qc_determine_storage 
         LET g_action_choice = "qc_determine_storage"
         EXIT DIALOG
      #FUN-BC0104---add---end
 
      &include "qry_string.4gl"
   END DIALOG
#FUN-B30170 add -end--------------------------
#FUN-B30170 mark begin---------------------------
#   DISPLAY ARRAY g_ksd TO s_ksd.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
#      ON ACTION insert
#         LET g_action_choice="insert"
#         EXIT DISPLAY
#      ON ACTION query
#         LET g_action_choice="query"
#         EXIT DISPLAY
#      ON ACTION delete
#         LET g_action_choice="delete"
#         EXIT DISPLAY
#      ON ACTION modify
#         LET g_action_choice="modify"
#         EXIT DISPLAY
#      ON ACTION first
#         CALL t622_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
#      ON ACTION previous
#         CALL t622_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION jump
#         CALL t622_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION next
#         CALL t622_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION last
#         CALL t622_fetch('L')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION detail
#         LET g_action_choice="detail"
#         LET l_ac = 1
#         EXIT DISPLAY
#      ON ACTION output
#         LET g_action_choice="output"
#         EXIT DISPLAY
#      ON ACTION help
#         LET g_action_choice="help"
#         EXIT DISPLAY
# 
#      ON ACTION locale
#         CALL cl_dynamic_locale()
#         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         CALL t622_def_form()   #FUN-610006
#         ##圖形顯示
#         IF g_ksc.kscconf = 'X' THEN
#            LET g_void = 'Y'
#         ELSE
#            LET g_void = 'N'
#         END IF
#         CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
#         EXIT DISPLAY
# 
#      ON ACTION exit
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ##########################################################################
#      # Special 4ad ACTION
#      ##########################################################################
#      ON ACTION controlg
#         LET g_action_choice="controlg"
#         EXIT DISPLAY
#         
#    #@ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#    #@ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
# 
##@    ON ACTION 庫存過帳
#      ON ACTION stock_post
#         LET g_action_choice="stock_post"
#         EXIT DISPLAY
##@    ON ACTION 過帳還原
#      ON ACTION undo_post
#         LET g_action_choice="undo_post"
#         EXIT DISPLAY
##@    ON ACTION 作廢
#      ON ACTION void
#         LET g_action_choice="void"
#         EXIT DISPLAY
# 
#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
#     
#     ON ACTION cancel
#        LET INT_FLAG=FALSE 		#MOD-570244	mars
#        LET g_action_choice="exit"
#        EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
###
#      ON ACTION related_document                #No.FUN-6A0164  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY
# 
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      &include "qry_string.4gl"
# 
#   END DISPLAY
#FUN-B30170 mark -end---------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION t622_out()
     CASE WHEN g_argv = '1'  #完工入庫
           # LET l_program = 'asfr626' #FUN-C30085 mark
            LET l_program = 'asfg626' #FUN-C30085 add
     END CASE
     LET g_wc = 'ksc01 = "',g_ksc.ksc01,'"'
     LET g_cmd = l_program,
                 " '",g_argv,"'",
                 " '",g_today,"'",
                 " ' '",
                 " '",g_lang,"'",
                 " 'Y'",
                 " ' '",
                 " '1'",
                 " '",g_wc CLIPPED,"'"
    CALL cl_cmdrun(g_cmd CLIPPED)
END FUNCTION
 
#FUNCTION t622_x()  #CHI-D20010
FUNCTION t622_x(p_type)  #CHI-D20010
#FUN-BC0104---add---str---
DEFINE l_ksd17 LIKE ksd_file.ksd17,
       l_ksd46 LIKE ksd_file.ksd46,
       l_ksd47 LIKE ksd_file.ksd47,
       l_ksd09 LIKE ksd_file.ksd09
#FUN-BC0104---add---end---       
DEFINE l_flag  LIKE type_file.chr1  #CHI-D20010
DEFINE p_type  LIKE type_file.chr1  #CHI-D20010
   IF s_shut(0) THEN RETURN END IF
 
   SELECT * INTO g_ksc.* FROM ksc_file WHERE ksc01 = g_ksc.ksc01       #MOD-660086 add
   IF cl_null(g_ksc.ksc01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_ksc.kscconf ='X' THEN RETURN END IF
   ELSE
      IF g_ksc.kscconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t622_cl USING g_ksc.ksc01
   IF STATUS THEN
      CALL cl_err("OPEN t622_cl:", STATUS, 1)
      CLOSE t622_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t622_cl INTO g_ksc.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ksc.ksc01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t622_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_ksc.ksc01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_ksc.kscconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660134
   IF g_ksc.kscconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
 # IF cl_void(0,0,g_ksc.kscconf)   THEN #FUN-660134  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN #FUN-660134   #CHI-D20010
      LET g_chr=g_ksc.kscconf #FUN-660134
     #IF g_ksc.kscconf='N' THEN #FUN-660134  #CHI-D20010
      IF p_type = 1 THEN #FUN-660134         #CHI-D20010
          LET g_ksc.kscconf='X' #FUN-660134
      ELSE
          LET g_ksc.kscconf='N' #FUN-660134
      END IF
      UPDATE ksc_file
          SET kscconf=g_ksc.kscconf, #FUN-660134
              kscmodu=g_user,
              kscdate=g_today
          WHERE ksc01  =g_ksc.ksc01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","ksc_file",g_ksc_t.ksc01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
          LET g_ksc.kscconf=g_chr #FUN-660134
      #FUN-C40016-------------------mark---------------str-----------------
      ##FUN-BC0104---add---str---
      #ELSE
      #   DECLARE ksd03_cur1 CURSOR FOR SELECT ksd09,ksd17,ksd46,ksd47
      #                                 FROM ksd_file
      #                                WHERE ksd01 = g_ksc.ksc01
      #   FOREACH ksd03_cur1 INTO l_ksd09,l_ksd17,l_ksd46,l_ksd47
      #      IF NOT cl_null(l_ksd46) THEN
      #         UPDATE qco_file SET qco20 = qco20-l_ksd09 WHERE qco01 = l_ksd17
      #                                                     AND qco02 = 0
      #                                                     AND qco04 = l_ksd47
      #                                                     AND qco05 = 0
      #         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #            CALL cl_err3("upd","qco_file",g_ksc.ksc01,"",STATUS,"","upd qco20:",1)
      #            ROLLBACK WORK
      #            RETURN
      #         END IF
      #      END IF
      #   END FOREACH
      #   UPDATE ksd_file SET ksd46 = '',ksd47 = ''
      #       WHERE ksd01 = g_ksc.ksc01
      #   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      #      CALL cl_err3("upd","ksc_file",g_ksc.ksc01,"",STATUS,"","upd ksd46,ksd47:",1)
      #      ROLLBACK WORK
      #      RETURN
      #   END IF
      ##FUN-BC0104---add---end---
      #FUN-C40016-------------------mark---------------end-----------------
      #FUN-C40016----add----str----
      ELSE
         DECLARE ksd03_cur1 CURSOR FOR SELECT ksd17,ksd46,ksd47
                                         FROM ksd_file
                                        WHERE ksd01 = g_ksc.ksc01
         FOREACH ksd03_cur1 INTO l_ksd17,l_ksd46,l_ksd47
            IF NOT cl_null(l_ksd46) THEN
               IF NOT s_iqctype_upd_qco20(l_ksd17,0,0,l_ksd47,'3') THEN
                  ROLLBACK WORK
                  RETURN
               END IF                 
            END IF
         END FOREACH
      #FUN-C40016----add----end----
      END IF
      DISPLAY BY NAME g_ksc.kscconf #FUN-660134
   END IF
 
   CLOSE t622_cl
   COMMIT WORK
   CALL cl_flow_notify(g_ksc.ksc01,'V')
 
END FUNCTION
 
 
FUNCTION t622_unit(p_unit)  #單位
    DEFINE p_unit    LIKE gfe_file.gfe01,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
           FROM gfe_file WHERE gfe01 = p_unit
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                   LET l_gfeacti = NULL
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION t622_ksd11(p_level,p_key,p_total)
   DEFINE p_level   LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
          p_total   LIKE csb_file.csb05,    #No.FUN-680121 DECIMAL(13,5),
          l_total   LIKE csb_file.csb05,    #No.FUN-680121 DECIMAL(13,5),
          l_tot     LIKE type_file.num10,   #No.FUN-680121 INTEGER,
          l_times   LIKE type_file.num5,    #No.FUN-680121 SMALLINT,
          p_key		LIKE bma_file.bma01,  #主件料件編號
          l_ac,i	LIKE type_file.num5,    #No.FUN-680121 SMALLINT
          b_seq	 	LIKE type_file.num10,   #No.FUN-680121 INTEGER,              #當BUFFER滿時,重新讀單身之起始ROWID
          l_chr		LIKE type_file.chr1,    #No.FUN-680121 VARCHAR(1)
          l_order2  LIKE type_file.chr20,   #No.FUN-680121 VARCHAR(20),
          sr DYNAMIC ARRAY OF RECORD           #每階存放資料
              bma01 LIKE bma_file.bma01,    #主件料件
              bmb01 LIKE bmb_file.bmb01,    #本階主件
              bmb02 LIKE bmb_file.bmb02,    #項次
              bmb03 LIKE bmb_file.bmb03,    #元件料號
              bmb04 LIKE bmb_file.bmb04,    #有效日期
              bmb05 LIKE bmb_file.bmb05,    #失效日期
              bmb06 LIKE bmb_file.bmb06,    #QPA/BASE
              bmb08 LIKE bmb_file.bmb08,    #損耗率%
              bmb10 LIKE bmb_file.bmb10,    #發料單位
              bmb13 LIKE bmb_file.bmb13,    #插件位置
              bmb16 LIKE bmb_file.bmb16,    #替代特性
              ima02 LIKE ima_file.ima02,    #品名規格
              ima021 LIKE ima_file.ima02,    #品名規格
              ima05 LIKE ima_file.ima05,    #版本
              ima08 LIKE ima_file.ima08,    #來源
              ima15 LIKE ima_file.ima15     #保稅否
          END RECORD,
          l_cmd		LIKE type_file.chr1000 #No.FUN-680121 VARCHAR(601)
 
    IF p_level > 20 THEN
       CALL cl_err('','mfg2733',1) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
 
    LET p_level = p_level + 1
    IF p_level = 1 THEN                          #第0階主件資料
       INITIALIZE sr[1].* TO NULL
       LET sr[1].bmb03 = p_key
       INSERT INTO t622_temp VALUES(p_key,p_key) #第0階主件資料
    END IF
 
    LET l_times=1
    WHILE TRUE
        LET l_cmd=
            "SELECT bma01, bmb01,bmb02, bmb03, bmb04, bmb05,",
            "       bmb06/bmb07,  bmb08, bmb10,",
            "       bmb13, bmb16, ",
            "       ima02,ima021,ima05, ima08, ima15 ",
            "  FROM bmb_file LEFT OUTER JOIN ima_file ON bmb03 = ima01 LEFT OUTER JOIN bma_file ON bmb03 = bma01 AND bma_file.bmaacti='Y' ",  #FUN-9A0085 mod
            " WHERE bmb01='", p_key,"' AND bmb02 >",b_seq
 
        PREPARE q601_precur FROM l_cmd
        IF SQLCA.sqlcode THEN
           CALL cl_err('P1:',STATUS,1)
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
           EXIT PROGRAM
        END IF
        DECLARE q601_cur CURSOR FOR q601_precur
 
        LET l_ac = 1
        FOREACH q601_cur INTO sr[l_ac].*	# 先將BOM單身存入BUFFER
            LET l_ac = l_ac + 1		    	# 但BUFFER不宜太大
        END FOREACH
        LET l_tot = l_ac - 1
        FOR i = 1 TO l_tot    	        	# 讀BUFFER傳給REPORT
            LET l_total=p_total*sr[i].bmb06
 
            INSERT INTO t622_temp VALUES(g_sfb05,sr[i].bmb03)
            IF sr[i].bma01 IS NOT NULL THEN #若為主件
                CALL t622_ksd11(p_level,sr[i].bmb03,p_total*sr[i].bmb06)
            END IF
 
        END FOR
        IF l_tot=0 THEN                 # BOM單身已讀完
           EXIT WHILE
        ELSE
           LET b_seq = sr[l_tot].bmb02
	   LET l_times=l_times+1
        END IF
 
    END WHILE
 
END FUNCTION
 
FUNCTION t622_chk_bom(p_bmb01)
DEFINE p_bmb01 LIKE bmb_file.bmb01,
       l_bmb   DYNAMIC ARRAY OF RECORD
         bmb03 LIKE bmb_file.bmb03,
         bmb16 LIKE bmb_file.bmb16
               END RECORD,
       l_bmd04 DYNAMIC ARRAY OF LIKE bmd_file.bmd04,
       l_ima01 DYNAMIC ARRAY OF LIKE ima_file.ima01,      #FUN-A40058 
       l_ab,l_ad,i,j   LIKE type_file.num10   #No.FUN-680121 INTEGER
 
 IF g_yn = 'Y' THEN RETURN END IF
 
 WHILE TRUE
 
    IF g_yn = 'Y' THEN
       EXIT WHILE
    END IF
 
    DECLARE t622_bmb_cur CURSOR WITH HOLD FOR
     SELECT bmb03,bmb16 FROM bmb_file
      WHERE bmb01 = p_bmb01
      ORDER BY bmb03
 
    LET l_ab = 1
    FOREACH t622_bmb_cur INTO l_bmb[l_ab].*
        LET l_ab = l_ab + 1
    END FOREACH
 
    FOR i=1 TO l_ab-1
      #找取替代料件*****************************************#
      IF l_bmb[i].bmb16 MATCHES"[12]" THEN
         DECLARE t622_bmd_cur CURSOR WITH HOLD FOR
          SELECT UNIQUE bmd04 FROM bmd_file
           WHERE  bmd01 = l_bmb[i].bmb03
             AND  bmd02 = l_bmb[i].bmb16
             AND (bmd08 = p_bmb01
              OR  bmd08 = 'ALL')
             AND bmdacti = 'Y'                                           #CHI-910021 
           ORDER BY bmd04
 
         LET l_ad=1
         FOREACH t622_bmd_cur INTO l_bmd04[l_ad]
             LET l_ad = l_ad + 1
         END FOREACH
 
         FOR j=1 TO l_ad -1
             IF l_bmd04[j] = g_ksd[l_ac].ksd04 THEN #找到了,確定存在BOM中
                 LET g_yn = 'Y'
                 EXIT FOR
             ELSE
                 IF g_yn='Y' THEN
                     EXIT FOR
                 ELSE
                     CALL t622_chk_bom(l_bmd04[j])
                 END IF
             END IF
 
         END FOR
      END IF
#FUN-A40058 --begin--
      IF l_bmb[i].bmb16 MATCHES"[7]" THEN
         DECLARE t622_bon_cur CURSOR WITH HOLD FOR
             SELECT ima01 FROM ima_file,bon_file,bmb_file
              WHERE imaacti = 'Y'
                AND bmb03 = l_bmb[i].bmb03
                AND bmb03 = bon01
                AND bmb01 = p_bmb01
                AND (bmb01 = bon02 or bon02 = '*')
                AND bmb16 = '7'
                AND bonacti = 'Y'
                AND ima251 = bon06
                AND ima109 = bon07
                AND ima54  = bon08
                AND ima022 BETWEEN bon04 AND bon05
                AND ima01 != bon01
              ORDER BY ima01
 
         LET l_ad=1
         FOREACH t622_bon_cur INTO l_ima01[l_ad]
             LET l_ad = l_ad + 1
         END FOREACH
 
         FOR j=1 TO l_ad -1
             IF l_ima01[j] = g_ksd[l_ac].ksd04 THEN #找到了,確定存在BOM中
                 LET g_yn = 'Y'
                 EXIT FOR
             ELSE
                 IF g_yn='Y' THEN
                     EXIT FOR
                 ELSE
                     CALL t622_chk_bom(l_ima01[j])
                 END IF
             END IF
 
         END FOR
      END IF
#FUN-A40058 --end--      
 
      #找取替代料件**************************************END#
 
      IF l_bmb[i].bmb03 = g_ksd[l_ac].ksd04 THEN  #找到了,確定存在BOM中
          LET g_yn='Y'
          EXIT FOR
      ELSE
          IF g_yn='Y' THEN
              EXIT FOR
          ELSE
              CALL t622_chk_bom(l_bmb[i].bmb03)
          END IF
      END IF
 
    END FOR
 
    EXIT WHILE
 
  END WHILE
 
END FUNCTION
 
FUNCTION t622_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ksc01",TRUE)        #CHI-950036 mod
    END IF
 
END FUNCTION
 
FUNCTION t622_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ksc01",FALSE)
    END IF
 
 
END FUNCTION
 
FUNCTION t622_set_entry_b()
 
   CALL cl_set_comp_entry("ksd30,ksd31,ksd33,ksd34,ksd35",TRUE) #FUN-BC0104 add 'ksd30'
 
END FUNCTION
 
FUNCTION t622_set_no_entry_b()
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("ksd33,ksd34,ksd35",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("ksd31,ksd34",FALSE)
   END IF
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("ksd33",FALSE)
   END IF
   #FUN-BC0104---add---str---
   IF NOT cl_null(g_ksd[l_ac].ksd46) THEN
      CALL cl_set_comp_entry("ksd30,ksd33",FALSE)
   END IF
   #FUN-BC0104---add---end---
END FUNCTION
 
FUNCTION t622_set_required()
 
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("ksd33,ksd35,ksd30,ksd32",TRUE)
  END IF
  IF NOT cl_null(g_ksd[l_ac].ksd33) THEN
     CALL cl_set_comp_required("ksd35",TRUE)
  END IF
  IF NOT cl_null(g_ksd[l_ac].ksd30) THEN
     CALL cl_set_comp_required("ksd32",TRUE)
  END IF
 
END FUNCTION
 
 
FUNCTION t622_set_no_required()
 
  CALL cl_set_comp_required("ksd33,ksd34,ksd35,ksd30,ksd31,ksd32",FALSE)
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t622_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE ksd_file.ksd34,     #第二轉換率
            l_qty2   LIKE ksd_file.ksd35,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE ksd_file.ksd31,     #第一轉換率
            l_qty1   LIKE ksd_file.ksd32,     #第一數量
            p_cmd    LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
    LET l_item = g_ksd[l_ac].ksd04
    LET l_ware = g_ksd[l_ac].ksd05
    LET l_loc  = g_ksd[l_ac].ksd06
    LET l_lot  = g_ksd[l_ac].ksd07
 
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    SELECT img09 INTO l_img09 FROM img_file
     WHERE img01 = l_item
       AND img02 = l_ware
       AND img03 = l_loc
       AND img04 = l_lot
    IF cl_null(l_img09) THEN LET l_img09 = l_ima25 END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = l_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF p_cmd = 'a' THEN
       LET g_ksd[l_ac].ksd33=l_unit2
       LET g_ksd[l_ac].ksd34=l_fac2
       LET g_ksd[l_ac].ksd35=l_qty2
       LET g_ksd[l_ac].ksd30=l_unit1
       LET g_ksd[l_ac].ksd31=l_fac1
       LET g_ksd[l_ac].ksd32=l_qty1
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t622_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE ksd_file.ksd34,
            l_qty2   LIKE ksd_file.ksd35,
            l_fac1   LIKE ksd_file.ksd31,
            l_qty1   LIKE ksd_file.ksd32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680121 DECIMAL(16,8)
 
    IF g_sma.sma115='N' THEN RETURN END IF
    LET l_fac2=g_ksd[l_ac].ksd34
    LET l_qty2=g_ksd[l_ac].ksd35
    LET l_fac1=g_ksd[l_ac].ksd31
    LET l_qty1=g_ksd[l_ac].ksd32
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
          WHEN '1' LET g_ksd[l_ac].ksd08=g_ksd[l_ac].ksd30
                   LET g_ksd[l_ac].ksd09=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_ksd[l_ac].ksd08=g_img09
                   LET g_ksd[l_ac].ksd09=l_tot
          WHEN '3' LET g_ksd[l_ac].ksd08=g_ksd[l_ac].ksd30
                   LET g_ksd[l_ac].ksd09=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_ksd[l_ac].ksd34=l_qty1/l_qty2
                   ELSE
                      LET g_ksd[l_ac].ksd34=0
                   END IF
       END CASE
       LET g_ksd[l_ac].ksd09 = s_digqty(g_ksd[l_ac].ksd09,g_ksd[l_ac].ksd08)   #FUN-910088--add--
    END IF
 
END FUNCTION
 
#以img09單位來計算雙單位所確定的數量
FUNCTION t622_tot_by_img09(p_item,p_fac2,p_qty2,p_fac1,p_qty1)
  DEFINE p_item    LIKE ima_file.ima01
  DEFINE p_fac2    LIKE ksd_file.ksd34
  DEFINE p_qty2    LIKE ksd_file.ksd35
  DEFINE p_fac1    LIKE ksd_file.ksd31
  DEFINE p_qty1    LIKE ksd_file.ksd32
  DEFINE l_ima906  LIKE ima_file.ima906
  DEFINE l_ima907  LIKE ima_file.ima907
  DEFINE l_tot     LIKE img_file.img10
 
    SELECT ima906,ima907 INTO l_ima906,l_ima907
      FROM ima_file WHERE ima01 = p_item
 
    IF cl_null(p_fac2) THEN LET p_fac2 = 1 END IF
    IF cl_null(p_qty2) THEN LET p_qty2 = 0 END IF
    IF cl_null(p_fac1) THEN LET p_fac1 = 1 END IF
    IF cl_null(p_qty1) THEN LET p_qty1 = 0 END IF
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
          WHEN '1' LET l_tot=p_qty1*p_fac1
          WHEN '2' LET l_tot=p_qty1*p_fac1+p_qty2*p_fac2
          WHEN '3' LET l_tot=p_qty1*p_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=p_qty1*p_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    RETURN l_tot
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t622_du_data_to_correct()
 
   IF cl_null(g_ksd[l_ac].ksd30) THEN
      LET g_ksd[l_ac].ksd31 = NULL
      LET g_ksd[l_ac].ksd32 = NULL
   END IF
 
   IF cl_null(g_ksd[l_ac].ksd33) THEN
      LET g_ksd[l_ac].ksd34 = NULL
      LET g_ksd[l_ac].ksd35 = NULL
   END IF
   DISPLAY BY NAME g_ksd[l_ac].ksd31
   DISPLAY BY NAME g_ksd[l_ac].ksd32
   DISPLAY BY NAME g_ksd[l_ac].ksd34
   DISPLAY BY NAME g_ksd[l_ac].ksd35
 
END FUNCTION
 
FUNCTION t622_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("ksd30,ksd32,ksd33,ksd35",FALSE)
       CALL cl_set_comp_visible("ksd08,ksd09",TRUE)
    ELSE
       CALL cl_set_comp_visible("ksd30,ksd32,ksd33,ksd35",TRUE)
       CALL cl_set_comp_visible("ksd08,ksd09",FALSE)
    END IF
    CALL cl_set_comp_visible("ksd31,ksd34",FALSE)
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ksd33",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ksd35",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ksd30",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ksd32",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ksd33",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ksd35",g_msg CLIPPED)
       CALL cl_getmsg('asm-328',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ksd30",g_msg CLIPPED)
       CALL cl_getmsg('asm-329',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("ksd32",g_msg CLIPPED)
    END IF
   IF g_aaz.aaz90='Y' THEN
      CALL cl_set_comp_required("ksc04",TRUE)
   END IF
   CALL cl_set_comp_required('ksd36',g_aza.aza115 ='Y')          #FUN-D10094 add
   CALL cl_set_comp_visible("ksd930,gem02c",g_aaz.aaz90='Y')
   CALL cl_set_comp_visible("page2",g_sma.sma95='Y')             #TQC-C80178
   CALL cl_set_act_visible("qry_lot,modi_lot",g_sma.sma95='Y')   #TQC-C80178
END FUNCTION
 
FUNCTION t622_b_move_to()
   LET g_ksd[l_ac].ksd03  = b_ksd.ksd03 
   LET g_ksd[l_ac].ksd17  = b_ksd.ksd17   #CHI-950036
   LET g_ksd[l_ac].ksd11  = b_ksd.ksd11 
   #FUN-BC0104---add---str---
   LET g_ksd[l_ac].ksd46  = b_ksd.ksd46
   LET g_ksd[l_ac].ksd47  = b_ksd.ksd47
   #FUN-BC0104---add---end---
   LET g_ksd[l_ac].ksd04  = b_ksd.ksd04 
   LET g_ksd[l_ac].ksd08  = b_ksd.ksd08 
   LET g_ksd[l_ac].ksd05  = b_ksd.ksd05 
   LET g_ksd[l_ac].ksd06  = b_ksd.ksd06 
   LET g_ksd[l_ac].ksd07  = b_ksd.ksd07 
   LET g_ksd[l_ac].ksd09  = b_ksd.ksd09 
   LET g_ksd[l_ac].ksd33  = b_ksd.ksd33 
   LET g_ksd[l_ac].ksd34  = b_ksd.ksd34 
   LET g_ksd[l_ac].ksd35  = b_ksd.ksd35 
   LET g_ksd[l_ac].ksd30  = b_ksd.ksd30 
   LET g_ksd[l_ac].ksd31  = b_ksd.ksd31 
   LET g_ksd[l_ac].ksd32  = b_ksd.ksd32 
   LET g_ksd[l_ac].ksd12  = b_ksd.ksd12 
   LET g_ksd[l_ac].ksd930 = b_ksd.ksd930
   LET g_ksd[l_ac].ksd36  = b_ksd.ksd36  #FUN-D10094 add
   LET g_ksd[l_ac].ksdud01 = b_ksd.ksdud01
   LET g_ksd[l_ac].ksdud02 = b_ksd.ksdud02
   LET g_ksd[l_ac].ksdud03 = b_ksd.ksdud03
   LET g_ksd[l_ac].ksdud04 = b_ksd.ksdud04
   LET g_ksd[l_ac].ksdud05 = b_ksd.ksdud05
   LET g_ksd[l_ac].ksdud06 = b_ksd.ksdud06
   LET g_ksd[l_ac].ksdud07 = b_ksd.ksdud07
   LET g_ksd[l_ac].ksdud08 = b_ksd.ksdud08
   LET g_ksd[l_ac].ksdud09 = b_ksd.ksdud09
   LET g_ksd[l_ac].ksdud10 = b_ksd.ksdud10
   LET g_ksd[l_ac].ksdud11 = b_ksd.ksdud11
   LET g_ksd[l_ac].ksdud12 = b_ksd.ksdud12
   LET g_ksd[l_ac].ksdud13 = b_ksd.ksdud13
   LET g_ksd[l_ac].ksdud14 = b_ksd.ksdud14
   LET g_ksd[l_ac].ksdud15 = b_ksd.ksdud15
END FUNCTION
 
FUNCTION t622_b_move_back()
   LET b_ksd.ksd01  = g_ksc.ksc01 #Key值
 
   LET b_ksd.ksd03  = g_ksd[l_ac].ksd03
   LET b_ksd.ksd17  = g_ksd[l_ac].ksd17   #CHI-950036 
   LET b_ksd.ksd11  = g_ksd[l_ac].ksd11 
   #FUN-BC0104---add---str---
   LET b_ksd.ksd46  = g_ksd[l_ac].ksd46
   LET b_ksd.ksd47  = g_ksd[l_ac].ksd47
   #FUN-BC0104---add---end---
   LET b_ksd.ksd04  = g_ksd[l_ac].ksd04 
   LET b_ksd.ksd08  = g_ksd[l_ac].ksd08 
   LET b_ksd.ksd05  = g_ksd[l_ac].ksd05 
   LET b_ksd.ksd06  = g_ksd[l_ac].ksd06 
   LET b_ksd.ksd07  = g_ksd[l_ac].ksd07 
   LET b_ksd.ksd09  = g_ksd[l_ac].ksd09 
   LET b_ksd.ksd33  = g_ksd[l_ac].ksd33 
   LET b_ksd.ksd34  = g_ksd[l_ac].ksd34 
   LET b_ksd.ksd35  = g_ksd[l_ac].ksd35 
   LET b_ksd.ksd30  = g_ksd[l_ac].ksd30 
   LET b_ksd.ksd31  = g_ksd[l_ac].ksd31 
   LET b_ksd.ksd32  = g_ksd[l_ac].ksd32 
   LET b_ksd.ksd12  = g_ksd[l_ac].ksd12 
   LET b_ksd.ksd930 = g_ksd[l_ac].ksd930
   LET b_ksd.ksd36  = g_ksd[l_ac].ksd36  #FUN-D10094 add
   LET b_ksd.ksdud01 = g_ksd[l_ac].ksdud01
   LET b_ksd.ksdud02 = g_ksd[l_ac].ksdud02
   LET b_ksd.ksdud03 = g_ksd[l_ac].ksdud03
   LET b_ksd.ksdud04 = g_ksd[l_ac].ksdud04
   LET b_ksd.ksdud05 = g_ksd[l_ac].ksdud05
   LET b_ksd.ksdud06 = g_ksd[l_ac].ksdud06
   LET b_ksd.ksdud07 = g_ksd[l_ac].ksdud07
   LET b_ksd.ksdud08 = g_ksd[l_ac].ksdud08
   LET b_ksd.ksdud09 = g_ksd[l_ac].ksdud09
   LET b_ksd.ksdud10 = g_ksd[l_ac].ksdud10
   LET b_ksd.ksdud11 = g_ksd[l_ac].ksdud11
   LET b_ksd.ksdud12 = g_ksd[l_ac].ksdud12
   LET b_ksd.ksdud13 = g_ksd[l_ac].ksdud13
   LET b_ksd.ksdud14 = g_ksd[l_ac].ksdud14
   LET b_ksd.ksdud15 = g_ksd[l_ac].ksdud15
 
   LET b_ksd.ksdplant = g_plant #FUN-980008 add
   LET b_ksd.ksdlegal = g_legal #FUN-980008 add
END FUNCTION
 
FUNCTION t622_ksc01(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_cnt     LIKE type_file.num5
 
   LET g_errno = ' '
   IF cl_null(g_ksc.ksc01) THEN RETURN END IF
   LET l_slip = s_get_doc_no(g_ksc.ksc01)
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM smy_file
    WHERE smy71 = l_slip          #No.FUN-950021
   IF l_cnt > 0 THEN
      LET g_errno = 'asf-876'     #不可使用組合拆解對應完工入庫單別
   END IF
 
END FUNCTION
 
FUNCTION t622_ksd11_chk(p_cmd)
   DEFINE p_cmd     LIKE type_file.chr1
   DEFINE l_slip    LIKE smy_file.smyslip
   DEFINE l_cnt     LIKE type_file.num5
 
   LET g_errno = ' '
   IF cl_null(g_ksd[l_ac].ksd11) THEN RETURN END IF
   LET l_slip = s_get_doc_no(g_ksd[l_ac].ksd11)
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM smy_file
    WHERE smy69 = l_slip          #No.FUN-950021
   IF l_cnt > 0 THEN
      LET g_errno = 'asf-873'     #組合拆解對應的工單,不得使用!
   END IF
 
END FUNCTION
# No.FUN-9C0073 ---------------By chenls  10/01/08

#FUN-A40022--begin--add------------------
FUNCTION t622_set_required_1(p_cmd)
#DEFINE l_imaicd13 LIKE imaicd_file.imaicd13 #FUN-B50096
DEFINE l_ima159   LIKE ima_file.ima159       #FUN-B50096  
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(ksd04) THEN
      IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
#FUN-B50096 -------------Begin------------------
   #     SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
   #      WHERE imaicd00 = g_ksd[l_ac].ksd04
   #     IF l_imaicd13 = 'Y' THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_ksd[l_ac].ksd04
         IF l_ima159 = '1' THEN 
#FUN-B50096 -------------End--------------------
            CALL cl_set_comp_required("ksd07",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t622_set_no_required_1()
     CALL cl_set_comp_required("ksd07",FALSE)
END FUNCTION

#FUN-B50096 ---------------Begin------------------
FUNCTION t622_set_no_entry_ksd07()
DEFINE l_ima159    LIKE ima_file.ima159 
   IF l_ac > 0 THEN
      IF NOT cl_null(g_ksd[l_ac].ksd04) THEN
         SELECT ima159 INTO l_ima159 FROM ima_file
          WHERE ima01 = g_ksd[l_ac].ksd04
         IF l_ima159 = '2' THEN
            CALL cl_set_comp_entry("ksd07",FALSE)
         ELSE
            CALL cl_set_comp_entry("ksd07",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t622_set_entry_ksd07()
   CALL cl_set_comp_entry("ksd07",TRUE)
END FUNCTION
#FUN-B50096 ---------------End--------------------

#CHI-B90021 ------------------Begin---------------
#FUNCTION t622_chk_ksd()
#DEFINE l_n  LIKE type_file.num5
# 
#  LET l_n = 0
#  SELECT COUNT(*) INTO l_n FROM ksd_file
#   WHERE ksd01 = g_ksc.ksc01
#  IF l_n = 0 AND INT_FLAG THEN RETURN 1 ELSE RETURN 0 END IF
#END FUNCTION
#CHI-B90021 ------------------End----------------
#FUN-A40022--end--add--------------------
#FUN-910088--add--start--
FUNCTION t622_ksd09_check(p_cmd)               #FUN-BC0104 add p_cmd
   DEFINE l_sfb94       LIKE sfb_file.sfb94,
          l_qcf091      LIKE qcf_file.qcf091,
          l_tmp_qcqty   LIKE ksd_file.ksd09
   DEFINE l_qcl05       LIKE qcl_file.qcl05,   #FUN-BC0104 add
          p_cmd         LIKE type_file.chr1,   #FUN-BC0104 add 
          l_sum         LIKE qco_file.qco11    #FUN-BC0104 add

   IF NOT cl_null(g_ksd[l_ac].ksd09) AND NOT cl_null(g_ksd[l_ac].ksd08) THEN
      IF cl_null(g_ksd08_t) OR cl_null(g_ksd_t.ksd09) OR  g_ksd08_t != g_ksd[l_ac].ksd08 OR g_ksd_t.ksd09 != g_ksd[l_ac].ksd09 THEN
         LET g_ksd[l_ac].ksd09 = s_digqty(g_ksd[l_ac].ksd09,g_ksd[l_ac].ksd08) 
      DISPLAY BY NAME g_ksd[l_ac].ksd09
      END IF
   END IF
   IF cl_null(g_ksd[l_ac].ksd09) THEN
      LET g_ksd[l_ac].ksd09 = 0
   END IF
 
   IF NOT cl_null(g_ksd[l_ac].ksd09) THEN
      IF g_ksd[l_ac].ksd09 < 0 THEN
         CALL cl_err(g_ksd[l_ac].ksd09,'afa1001',0) 
         RETURN FALSE    
      END IF
    LET l_sfb94 = ''
    SELECT sfb94 INTO l_sfb94 FROM sfb_file WHERE sfb01 = g_ksd[l_ac].ksd11
    IF l_sfb94 = 'Y' AND g_sma.sma896 = 'Y' THEN
       SELECT qcf091 INTO l_qcf091 FROM qcf_file   
        WHERE qcf01 = g_ksd[l_ac].ksd17
          AND qcf09 <> '2'   
          AND qcf14 = 'Y'
       IF STATUS OR l_qcf091 IS NULL THEN
          LET l_qcf091 = 0
       END IF
 
       SELECT SUM(ksd09) INTO l_tmp_qcqty FROM ksd_file,ksc_file
        WHERE ksd11 = g_ksd[l_ac].ksd11
          AND ksd17 = g_ksd[l_ac].ksd17
          AND ksd01 = ksc01
          AND ksc00 = '1'  
          AND (ksd01 != g_ksc.ksc01 OR                                                                             
              (ksd01 = g_ksc.ksc01 AND ksd03 != g_ksd[l_ac].ksd03))                                                
          AND kscconf <> 'X' 
       IF cl_null(l_tmp_qcqty) THEN LET l_tmp_qcqty = 0 END IF
     END IF
     IF l_sfb94='Y' AND g_sma.sma896='Y' AND
        (g_ksd[l_ac].ksd09) > l_qcf091 - l_tmp_qcqty
     THEN
        CALL cl_err(g_ksd[l_ac].ksd09,'asf-675',1)
        RETURN FALSE    
     END IF
   END IF
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_ksd[l_ac].ksd04
      AND imaacti = "Y"
   
   IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
      (cl_null(g_ksd_t.ksd09) OR (g_ksd[l_ac].ksd09<>g_ksd_t.ksd09 )) THEN
      IF cl_null(g_ksd[l_ac].ksd06) THEN
         LET g_ksd[l_ac].ksd06 = ' '
      END IF
      IF cl_null(g_ksd[l_ac].ksd07) THEN
         LET g_ksd[l_ac].ksd07 = ' '
      END IF
      SELECT img09 INTO g_img09 FROM img_file
       WHERE img01=g_ksd[l_ac].ksd04
         AND img02=g_ksd[l_ac].ksd05
         AND img03=g_ksd[l_ac].ksd06
         AND img04=g_ksd[l_ac].ksd07
      CALL s_umfchk(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09) 
          RETURNING l_i,l_fac
      IF l_i = 1 THEN LET l_fac = 1 END IF
#TQC-B90236---mark--begin
#     CALL s_lotin(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
#                  g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09,
#                  l_fac,g_ksd[l_ac].ksd09,'','MOD')#CHI-9A0022 add ''
#TQC-B90236---mark--end
#TQC-B90236---add---begin
      CALL s_mod_lot(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
                     g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                     g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                     g_ksd[l_ac].ksd08,g_img09,l_fac,g_ksd[l_ac].ksd09,'','MOD',1)
#TQC-B90236---add---end
             RETURNING l_r,g_qty 
      IF l_r = "Y" THEN
         LET g_ksd[l_ac].ksd09 = g_qty
         LET g_ksd[l_ac].ksd09 = s_digqty(g_ksd[l_ac].ksd09,g_ksd[l_ac].ksd08)   #FUN-910088--add--
      END IF
   END IF
   #FUN-BC0104---add---str---
   IF NOT cl_null(g_ksd[l_ac].ksd09) THEN
      CALL t622_qcl05_check() RETURNING l_qcl05
      IF l_qcl05 = '0' OR l_qcl05 = '2' THEN            #TQC-C30013 
         CALL t622_ksd09_sum_check(p_cmd) RETURNING l_sum
         IF g_ksd[l_ac].ksd09 > l_sum THEN 
            CALL cl_err('','apm-804',1)
            LET g_ksd[l_ac].ksd09 = l_sum
            DISPLAY BY NAME g_ksd[l_ac].ksd09
            RETURN FALSE 
         END IF
      END IF 
   END IF 
   #FUN-BC0104---add---end---
   RETURN TRUE 
END FUNCTION
  
FUNCTION t622_ksd32_check(p_cmd)    #FUN-BC0104 add p_cmd
DEFINE p_cmd LIKE type_file.chr1    #FUN-BC0104 add p_cmd
   IF NOT cl_null(g_ksd[l_ac].ksd32) AND NOT cl_null(g_ksd[l_ac].ksd30) THEN
      IF cl_null(g_ksd30_t) OR cl_null(g_ksd_t.ksd32) OR g_ksd30_t != g_ksd[l_ac].ksd30 OR g_ksd_t.ksd32 != g_ksd[l_ac].ksd32 THEN
         LET g_ksd[l_ac].ksd32 = s_digqty(g_ksd[l_ac].ksd32,g_ksd[l_ac].ksd30)
      END IF
      DISPLAY BY NAME g_ksd[l_ac].ksd32
   END IF
   IF NOT cl_null(g_ksd[l_ac].ksd32) THEN
      IF g_ksd[l_ac].ksd32 < 0 THEN
         CALL cl_err('','aim-391',0)  #
         RETURN FALSE    
      END IF
   END IF
   #FUN-BC0104---add---str---
   CALL t622_set_origin_field()
   IF g_sma.sma115='Y' AND NOT cl_null(g_ksd[l_ac].ksd46) THEN
      IF NOT cl_null(g_ksd[l_ac].ksd32) AND g_ksd[l_ac].ksd32!=0 THEN
         IF NOT t622_ksd09_check(p_cmd) THEN
            RETURN FALSE 
         END IF  
      END IF
   END IF
   #FUN-BC0104---add---end---
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION

FUNCTION t622_ksd35_check(p_cmd)
   DEFINE p_cmd  LIKE type_file.chr1
   IF NOT cl_null(g_ksd[l_ac].ksd35) AND cl_null(g_ksd[l_ac].ksd33) THEN
      IF cl_null(g_ksd33_t) OR cl_null(g_ksd_t.ksd35) OR g_ksd33_t != g_ksd[l_ac].ksd33 OR g_ksd_t.ksd35 != g_ksd[l_ac].ksd35 THEN
         LET g_ksd[l_ac].ksd35 = s_digqty(g_ksd[l_ac].ksd35,g_ksd[l_ac].ksd33)
      END IF
   END IF
   IF NOT cl_null(g_ksd[l_ac].ksd35) THEN
      IF g_ksd[l_ac].ksd35 < 0 THEN
         CALL cl_err('','aim-391',0)   
         RETURN FALSE    
      END IF 
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_ksd_t.ksd35 <> g_ksd[l_ac].ksd35 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_ksd[l_ac].ksd35*g_ksd[l_ac].ksd34
            IF cl_null(g_ksd[l_ac].ksd32) OR g_ksd[l_ac].ksd32=0 THEN #CHI-960022
               LET g_ksd[l_ac].ksd32=g_tot*g_ksd[l_ac].ksd31
               LET g_ksd[l_ac].ksd32 = s_digqty(g_ksd[l_ac].ksd32,g_ksd[l_ac].ksd30)                             
               DISPLAY BY NAME g_ksd[l_ac].ksd32                                     
            END IF                                                                     
         END IF
      END IF
   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_ksd[l_ac].ksd04
      AND imaacti = "Y"
   
   IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
      (cl_null(g_ksd_t.ksd35) OR (g_ksd[l_ac].ksd35<>g_ksd_t.ksd35 )) THEN
      IF cl_null(g_ksd[l_ac].ksd06) THEN
         LET g_ksd[l_ac].ksd06 = ' '
      END IF
      IF cl_null(g_ksd[l_ac].ksd07) THEN
         LET g_ksd[l_ac].ksd07 = ' '
      END IF
      SELECT img09 INTO g_img09 FROM img_file
       WHERE img01=g_ksd[l_ac].ksd04
         AND img02=g_ksd[l_ac].ksd05
         AND img03=g_ksd[l_ac].ksd06
         AND img04=g_ksd[l_ac].ksd07
      CALL s_umfchk(g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09) 
          RETURNING l_i,l_fac
      IF l_i = 1 THEN LET l_fac = 1 END IF
#TQC-B90236--mark--begin
#     CALL s_lotin(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
#                  g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd08,g_img09,
#                  l_fac,g_ksd[l_ac].ksd09,'','MOD')#CHI-9A0022 add ''
#TQC-B90236--mark--end
#TQC-B90236--add---begin
      CALL s_mod_lot(g_prog,g_ksc.ksc01,g_ksd[l_ac].ksd03,0,
                     g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                     g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                     g_ksd[l_ac].ksd08,g_img09,l_fac,g_ksd[l_ac].ksd09,'','MOD',1)
#TQC-B90236--add---end
             RETURNING l_r,g_qty 
      IF l_r = "Y" THEN
         LET g_ksd[l_ac].ksd09 = g_qty
         LET g_ksd[l_ac].ksd09 = s_digqty(g_ksd[l_ac].ksd09,g_ksd[l_ac].ksd08)                           
      END IF
   END IF
   END IF
   #FUN-BC0104---add---str---
   IF g_sma.sma115='Y' AND NOT cl_null(g_ksd[l_ac].ksd46) THEN
       IF NOT cl_null(g_ksd[l_ac].ksd32) AND NOT cl_null(g_ksd[l_ac].ksd35) THEN
          IF g_ksd[l_ac].ksd35!=0 THEN
             CALL t622_set_origin_field()
             IF NOT t622_ksd09_check(p_cmd) THEN 
                RETURN FALSE 
             END IF  
          END IF
       END IF
    END IF   
   #FUN-BC0104---add---end---
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--

#FUN-BC0104---add---str
FUNCTION t622_set_noentry_ksd46()
   CALL cl_set_comp_entry('ksd46,ksd47',FALSE)
END FUNCTION 

FUNCTION t622_set_ksd04_ksd08_entry()
   CALL cl_set_comp_entry('ksd04,ksd08',TRUE)
END FUNCTION 

FUNCTION t622_set_ksd04_ksd08_noentry()
   IF l_ac>0 THEN
      IF NOT cl_null(g_ksd[l_ac].ksd46) THEN
         CALL cl_set_comp_entry('ksd04,ksd08',FALSE)
      END IF
   END IF
END FUNCTION 

FUNCTION t622_ksd46_check()
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_n1    LIKE type_file.num5
   DEFINE l_sql   STRING
   DEFINE l_sql1  STRING
   DEFINE l_sql2  STRING

   LET l_n  = 0
   LET l_n1 = 0

   LET l_sql= "SELECT COUNT(*) FROM ksd_file",
              " WHERE  ksd17 = ?"

   LET l_sql1=l_sql CLIPPED," AND ksd46 IS NOT NULL AND ksd46<>' '"
   PREPARE insert_ln FROM l_sql1
   EXECUTE insert_ln INTO l_n USING g_ksd[l_ac].ksd17

   LET l_sql2=l_sql CLIPPED," AND ksd46 IS NULL OR ksd46=' '"
   PREPARE insert_ln1 FROM l_sql2           
   EXECUTE insert_ln1 INTO l_n1 USING g_ksd[l_ac].ksd17
   IF l_n > 0 THEN 
      CALL cl_set_comp_required('ksd46,ksd47',TRUE)
   END IF
   IF l_n1 > 0 THEN
      LET g_ksd[l_ac].ksd46 = ''
      LET g_ksd[l_ac].ksd47 = ''
      DISPLAY BY NAME g_ksd[l_ac].ksd46,g_ksd[l_ac].ksd47
      CALL cl_set_comp_entry('ksd46,ksd47',FALSE)
   END IF 
                 
END FUNCTION 

FUNCTION t622_set_comp_required(p_ksd46,p_ksd47)
   DEFINE p_ksd46 LIKE ksd_file.ksd46,
          p_ksd47 LIKE ksd_file.ksd47

   IF NOT cl_null(p_ksd46) OR NOT cl_null(p_ksd47) THEN
      CALL cl_set_comp_required('ksd46,ksd47',TRUE)
   END IF
 
   IF cl_null(p_ksd46) AND cl_null(p_ksd47) THEN
      CALL cl_set_comp_required('ksd46,ksd47',FALSE)
      LET g_ksd[l_ac].qcl02 = ''
   END IF
END FUNCTION

FUNCTION t622_qcl02_desc()

  SELECT qcl02 INTO g_ksd[l_ac].qcl02 FROM qcl_file
             WHERE qcl01 = g_ksd[l_ac].ksd46
      DISPLAY BY NAME g_ksd[l_ac].qcl02
   
END FUNCTION

FUNCTION t622_qcl05_check() 
   DEFINE l_qcl05 LIKE qcl_file.qcl05

   IF NOT cl_null(g_ksd[l_ac].ksd46) THEN
      SELECT qcl05 INTO l_qcl05 FROM qcl_file
                                WHERE qcl01 = g_ksd[l_ac].ksd46
      RETURN l_qcl05
   END IF 
RETURN ''
END FUNCTION

FUNCTION t622_qco_show()
DEFINE l_qcl05  LIKE qcl_file.qcl05,
       l_qco20  LIKE qco_file.qco20,
       l_ksd30  LIKE ksd_file.ksd30,
       l_ksd32  LIKE ksd_file.ksd32,
       l_ksd33  LIKE ksd_file.ksd33,
       l_ksd35  LIKE ksd_file.ksd35,
       l_img09  LIKE img_file.img09,
       l_ima906 LIKE ima_file.ima906
   
      SELECT qco06,qco07,qco08,qco09,qco10,qco13,qco15,qco16,qco18,qco20 INTO g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                                                g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                                                g_ksd[l_ac].ksd08,l_ksd30,l_ksd32,l_ksd33,l_ksd35,l_qco20
                                           FROM qco_file
                                          WHERE qco01 = g_ksd[l_ac].ksd17
                                            AND qco02 = 0
                                            AND qco05 = 0
                                            AND qco04 = g_ksd[l_ac].ksd47
      DISPLAY BY NAME g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,
                      g_ksd[l_ac].ksd06,g_ksd[l_ac].ksd07,
                      g_ksd[l_ac].ksd08
      IF g_sma.sma115 = 'Y' THEN
         LET g_ksd[l_ac].ksd30 = l_ksd30  #單位一賦值
         LET g_ksd[l_ac].ksd33 = l_ksd33  #單位二賦值
         CALL t622_set_origin_field()
         CALL s_du_umfchk(g_ksd[l_ac].ksd04,'','','',
                          g_ksd[l_ac].ksd08,g_ksd[l_ac].ksd30,'1')
                          RETURNING g_errno,g_factor
         LET g_ksd[l_ac].ksd31 = g_factor
         DISPLAY BY NAME g_ksd[l_ac].ksd31

         SELECT img09,ima906 INTO l_img09,l_ima906 FROM img_file,ima_file
                WHERE img01=g_ksd[l_ac].ksd04 
                  AND ima01=img01
         CALL s_du_umfchk(g_ksd[l_ac].ksd04,'','','',
                               l_img09,g_ksd[l_ac].ksd33,l_ima906)
                   RETURNING g_errno,g_factor
         LET g_ksd[l_ac].ksd34 = g_factor
         DISPLAY BY NAME g_ksd[l_ac].ksd34
      END IF
      CALL t622_qcl05_check() RETURNING l_qcl05
      IF l_qcl05 = '0' OR l_qcl05 = '2' THEN   #TQC-C30013
         IF g_sma.sma115 = 'N' THEN
            CALL t622_ksd09_sum_check('') RETURNING g_ksd[l_ac].ksd09
            CALL cl_set_comp_entry('ksd09',TRUE)
            DISPLAY BY NAME g_ksd[l_ac].ksd09
         ELSE
            IF l_qco20=0 THEN
               LET g_ksd[l_ac].ksd32 = l_ksd32
               LET g_ksd[l_ac].ksd35 = l_ksd35
            ELSE
               LET g_ksd[l_ac].ksd32=0
               LET g_ksd[l_ac].ksd35=0
            END IF
            CALL t622_set_origin_field()
            DISPLAY BY NAME g_ksd[l_ac].ksd32,g_ksd[l_ac].ksd35
         END IF
      END IF
       
END FUNCTION

FUNCTION t622_ksd09_sum_check(p_cmd)
DEFINE l_sum LIKE qco_file.qco11,
       p_cmd LIKE type_file.chr1
   SELECT qco11-qco20 INTO l_sum FROM qco_file
                                      WHERE qco01 = g_ksd[l_ac].ksd17
                                        AND qco02 = 0
                                        AND qco05 = 0
                                        AND qco04 = g_ksd[l_ac].ksd47
   IF cl_null(l_sum) THEN LET l_sum=0 END IF
   IF p_cmd = 'u' THEN
      LET l_sum = l_sum+g_ksd_t.ksd09
   END IF
   RETURN l_sum 
END FUNCTION 

FUNCTION t622_ksd05_check()
DEFINE l_n     LIKE type_file.num5,
       l_qcl05 LIKE qcl_file.qcl05,
       l_sql   STRING
   LET l_n = 0
   LET l_sql="SELECT COUNT(*) FROM qcl_file,imd_file",
             " WHERE qcl01='",g_ksd[l_ac].ksd46 CLIPPED,
             "' AND imd01 = '",g_ksd[l_ac].ksd05 CLIPPED,
             "' AND qcl03=imd11 AND qcl04=imd12"
   CALL t622_qcl05_check() RETURNING l_qcl05
   IF l_qcl05 = '0' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 NOT IN(SELECT jce02 FROM jce_file)"
   END IF

  #TQC-C30013---add---str---
   IF l_qcl05 = '2' THEN
      LET l_sql = l_sql CLIPPED," AND imd01 IN(SELECT jce02 FROM jce_file)"
   END IF
  #TQC-C30013---add---end---
   PREPARE insert_l_n2 FROM l_sql
   EXECUTE insert_l_n2 INTO l_n

   IF l_n = 0 THEN
      RETURN FALSE
   END IF
RETURN TRUE
END FUNCTION

FUNCTION t622_ksd46_47_check()
DEFINE l_n    LIKE type_file.num5,
       l_sql  STRING

   LET l_n = 0
   LET l_sql=" SELECT COUNT(*) FROM qcf_file,qco_file,qcl_file",
                 " WHERE qcf00='1' AND qcf14='Y' AND qco01=qcf01",
                 "  AND qcl01 = qco03 AND qco01='",g_ksd[l_ac].ksd17 CLIPPED,"'"

    IF NOT cl_null(g_ksd[l_ac].ksd46) THEN
       LET l_sql=l_sql CLIPPED," AND qco03='",g_ksd[l_ac].ksd46 CLIPPED,"'"
    END IF

    IF NOT cl_null(g_ksd[l_ac].ksd47) THEN
       LET l_sql=l_sql CLIPPED," AND qco04=",g_ksd[l_ac].ksd47 CLIPPED
    END IF

    PREPARE insert_l_n FROM l_sql
    EXECUTE insert_l_n INTO l_n

    IF l_n = 0 THEN
       RETURN FALSE
    END IF
RETURN TRUE
END FUNCTION
#FUN-BC0104---add---end

#FUN-CB0014---add---str
FUNCTION t622_list_fill()
  DEFINE l_ksc01         LIKE ksc_file.ksc01
  DEFINE l_i             LIKE type_file.num10

    CALL g_ksc_l.clear()
    LET l_i = 1
    FOREACH t622_fill_cs INTO l_ksc01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT ksc01,'',ksc14,ksc02,ksc04,gem02,ksc09,ksc05,
              azf03,ksc07,kscconf,kscpost
         INTO g_ksc_l[l_i].*
         FROM ksc_file
              LEFT OUTER JOIN gem_file ON ksc04 = gem01
              LEFT OUTER JOIN azf_file ON ksc05 = azf01 
                                      AND azf02 = '2'
                                      AND azfacti='Y'
        WHERE ksc01=l_ksc01
       LET g_buf = s_get_doc_no(l_ksc01)
       SELECT smydesc INTO g_ksc_l[l_i].smydesc FROM smy_file WHERE smyslip=g_buf
       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN  
            CALL cl_err( '', 9035, 0 )
          END IF                             
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_buf = NULL
    LET g_rec_b2 = l_i - 1
    DISPLAY ARRAY g_ksc_l TO s_ksc_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION

FUNCTION t622_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G"  THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ksc_l TO s_ksc_l.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
       BEFORE DISPLAY
          CALL fgl_set_arr_curr(g_curs_index) 
          CALL cl_navigator_setting( g_curs_index, g_row_count )  
       BEFORE ROW
          LET l_ac2 = ARR_CURR()
          LET g_curs_index = l_ac2
          CALL cl_show_fld_cont()

      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         IF g_rec_b2 > 0 THEN
             CALL t622_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("info,userdefined_field", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac2 = ARR_CURR()
         LET g_jump = l_ac2
         LET mi_no_ask = TRUE
         CALL t622_fetch('/')
         CALL cl_set_comp_visible("info,userdefined_field", FALSE)
         CALL cl_set_comp_visible("info,userdefined_field", TRUE)
         CALL cl_set_comp_visible("page_list", FALSE) 
         CALL ui.interface.refresh()                 
         CALL cl_set_comp_visible("page_list", TRUE)    
         EXIT DISPLAY
         
      ON ACTION CONTROLS                                                                                                          
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
         CALL t622_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  
           END IF
           ACCEPT DISPLAY                 
 
      ON ACTION previous
         CALL t622_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  
           END IF
	ACCEPT DISPLAY                
 
 
      ON ACTION jump
         CALL t622_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION next
         CALL t622_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index) 
           END IF
	ACCEPT DISPLAY                  
 
 
      ON ACTION last
         CALL t622_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(g_curs_index)  
           END IF
	ACCEPT DISPLAY                  
 
#TQC-D10084---mark---str---
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#TQC-D10084---mark---end---
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t622_def_form()   #FUN-610006
         ##圖形顯示
         IF g_ksc.kscconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_ksc.kscconf,"",g_ksc.kscpost,"",g_void,"")
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
 
#@    ON ACTION 庫存過帳
      ON ACTION stock_post
         LET g_action_choice="stock_post"
         EXIT DISPLAY
#@    ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY
#@    ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

     #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
 
     ON ACTION cancel
        LET INT_FLAG=FALSE 		#MOD-570244	mars
        LET g_action_choice="exit"
        EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
      ON ACTION related_document                #No.FUN-6A0164  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY

      #FUN-BC0104---add---str
      #QC 結果判定產生入庫單
      ON ACTION qc_determine_storage 
         LET g_action_choice = "qc_determine_storage"
         EXIT DISPLAY
      #FUN-BC0104---add---end
 
      &include "qry_string.4gl"
   END DISPLAY

   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-CB0014---add---end

#FUN-D10094--add--str--
FUNCTION t622_ksd36_check()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5

   LET l_flag = FALSE 
   IF cl_null(g_ksd[l_ac].ksd36) THEN RETURN TRUE END IF  #TQC-D20042 add
   IF g_aza.aza115='Y' THEN 
      CALL s_get_where(g_ksc.ksc01,g_ksd[l_ac].ksd11,'',g_ksd[l_ac].ksd04,g_ksd[l_ac].ksd05,'',g_ksc.ksc04) RETURNING l_flag,l_where
   END IF 
   IF g_aza.aza115='Y' AND l_flag THEN
      LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_ksd[l_ac].ksd36,"' AND ",l_where
      PREPARE ggc08_pre1 FROM l_sql
      EXECUTE ggc08_pre1 INTO l_n
      IF l_n < 1 THEN
         CALL cl_err(g_ksd[l_ac].ksd36,'aim-425',0)
         RETURN FALSE 
      END IF
   ELSE 
      SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_ksd[l_ac].ksd36 AND azf02='2'
      IF l_n < 1 THEN
         CALL cl_err(g_ksd[l_ac].ksd36,'aim-425',0)
         RETURN FALSE
      END IF
   END IF  
   RETURN TRUE 
END FUNCTION 

FUNCTION t622_ksd36_chkall()
DEFINE l_flag        LIKE type_file.chr1       
DEFINE l_where       STRING                    
DEFINE l_sql         STRING                    
DEFINE l_n           LIKE type_file.num5
DEFINE l_cnt         LIKE type_file.num5

   IF g_ksd.getlength() = 0 THEN RETURN TRUE END IF 
   IF g_aza.aza115='Y' THEN 
      FOR l_cnt = 1 TO  g_ksd.getlength()
         CALL s_get_where(g_ksc.ksc01,g_ksd[l_cnt].ksd11,'',g_ksd[l_cnt].ksd04,g_ksd[l_cnt].ksd05,'',g_ksc.ksc04) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n = 0 
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_ksd[l_cnt].ksd36,"' AND ",l_where
            PREPARE ggc08_pre2 FROM l_sql
            EXECUTE ggc08_pre2 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE 
            END IF
         END IF 
      END FOR
   END IF    
   RETURN TRUE 
END FUNCTION 
#FUN-D10094--add--end-- 
#TQC-D20042---add---str---
FUNCTION t622_azf03_desc()
   LET g_ksd[l_ac].azf03 = ''
   IF NOT cl_null(g_ksd[l_ac].ksd36) THEN
      SELECT azf03 INTO g_ksd[l_ac].azf03 FROM azf_file WHERE azf01=g_ksd[l_ac].ksd36 AND azf02='2'
   END IF
   DISPLAY g_ksd[l_ac].azf03 TO azf03c
END FUNCTION
#TQC-D20042---add---end---

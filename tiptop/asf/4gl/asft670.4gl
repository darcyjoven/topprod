# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Program code...: asft670.4gl
# Descriptions...: 下階料報廢作業
# Date & Author..: 93/10/01 By David
# Modify.........: 99/08/18 By Carol:加單據管理(雙檔)
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: 04/07/16 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位用like方式
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4C0035 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-510040 05/02/03 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580029 05/08/08 By elva 新增雙單位內容
# Modify.........: No.MOD-590120 05/09/09 By Carrier 修改set_origin_field
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0015 05/11/02 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5C0035 05/12/07 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-610071 06/01/19 By Claire 過帳及還原過帳要確認工單狀態
# Modify.........: No.TQC-630068 06/03/07 By Sarah 指定單據編號、執行功能
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.TQC-660067 06/06/14 By Sarah p_flow功能補強
# Modify.........: No.FUN-660134 06/06/19 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660128 06/06/28 By Xumin cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-670103 06/07/31 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6C0226 06/12/29 By day 單身單位加controlp開窗 
# Modify.........: No.FUN-710026 07/01/26 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-710137 07/02/06 By Smapmin 單身刪除時,不應控管數量大於0
# Modify.........: No.TQC-720063 07/03/21 By Judy    錄入時,開窗字段"報廢單號"錄入任何值不報錯
# Modify.........: No.FUN-730057 07/03/27 By dxfwo   會計科目加帳套
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
# Modify.........: No.TQC-740145 07/04/24 By hongmei 修改本次報廢量不可為負數
# Modify.........: No.FUN-740161 07/04/24 By kim 單身料號開窗錯誤
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760119 07/06/15 By Sarah 單身料號開窗僅開出生產料號的下階料供選擇, 輸入也需做同樣的檢查
# Modify.........: No.FUN-760085 07/07/23 By sherry  報表改由Crystal Report輸出 
# Modify.........: No.CHI-770019 07/07/26 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.MOD-7A0088 07/10/25 By Pengu 1.當有作取替代料時其報廢數量檢核有問題
#                                                  2.應該同時考慮到一個主料作多次取替代的情況。
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840042 08/04/16 By Wind 自定欄位功能修改
# Modify.........: No.FUN-870051 08/07/18 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.MOD-880026 08/08/05 By wujie  在函數FUNCTION t670_sfa_num(p_cmd)中計算l_sfl07時,如果為空未賦值0
# Modify.........: No.MOD-880029 08/08/08 By liuxqa 調整SQL語句條件
# Modify,........: No.MOD-880137 08/08/19 By liuxqa 調整g_sfb02和g_ima63_fac的變量定義，將其改為動態數組
# Modify.........: No.FUN-890050 08/09/27 By sherry 產生&維護雜發單,ina00給'3' 產生雜收單
# Modify.........: No.MOD-870286 08/10/02 By claire 單身自行輸入下階料時,要帶出單位
# Modify.........: No.MOD-910122 09/01/12 By sherry 調整作業編號的開窗，增加工單不走流程時候的開窗條件
# Modify.........: No.MOD-930107 09/03/11 By sabrina 單別欄位開窗查詢應該是要查雜收單而不是雜發單
#                                                    產生到雜收單的申請數量(inb16)與異動數量(inb09)應該是要用asft670單身的"本次報廢"(sfl07)欄位
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-940313 09/04/23 By Smapmin asf-574的控管應該要加上超領量(sfa062)
# Modify.........: No.CHI-970037 09/07/17 By mike 請在數量欄位加上控管數量不可為0，若是0則show錯誤訊息                              
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870100 09/08/20 By cockroach  對ina12,inapos賦默認值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No:MOD-930077 09/11/27 By sabrina 可報廢量未考慮發料誤差率
# Modify.........: No:TQC-970019 09/11/27 By sabrina 無法進行下階報廢
# Modify.........: No:MOD-9C0120 09/12/25 By Pengu 使用參考單位時，單位數量key 0程式會當住
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No.FUN-A60027 10/06/13 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A60076 10/06/24 By huanbtao 製造功能優化-平行制程（批量修改）
# Modify.........: No:FUN-A60095 10/07/26 By kim GP5.25平行工藝
# Modify.........: No:FUN-A80027 10/08/04 By jan key值增加sfl041
# Modify.........: No.FUN-AA0059 10/10/27 By huangtao 修改料號的管控
# Modify.........: No.MOD-AA0184 10/10/29 By zhangll 过账时做可报废量的控管,调用t670_sfa_num,为公用性考虑,增加传参
#                                                    其中发现调用t670_sfb01函数的所有地方不能通用l_ac,一并调整
# Modify.........: No.FUN-AB0049 10/11/11 By zhangll 倉庫營運中心權限修改
# Modify.........: No:CHI-A80038 10/11/26 By Summer 增加批序號功能
# Modify.........: No.TQC-AB0394 10/12/04 By vealxu 下階料報廢，單位無法錄入通過,序號sfl041無法錄入通過
# Modify.........: No:MOD-B10178 11/01/24 By sabrina 會有小數位差的問題
# Modify.........: No:FUN-B10052 11/01/27 By lilingyu 科目查詢自動過濾
# Modify.........: No:MOD-B20114 11/02/22 By zhangll 取消審核時增加控管
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No:FUN-B30170 11/04/12 By suncx 單身增加批序號明細頁簽
# Modify.........: No:MOD-B50063 11/05/09 By destiny 单别传参有误    
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B70074 11/07/20 By xianghui (inbi_file By fengrui) 添加行業別表的新增於刪除
# Modify.........: No:TQC-B90236 11/10/28 By zhuhao s_lotout_del程式段Mark，改為s_lot_del，傳入參數不變
#                                                   _r()中使用FOR迴圈執行s_lotout_del程式段Mark，改為s_lot_del，傳入參數不變，但第三個參數(項次)傳""
#                                                   原執行s_lotou程式段，改為s_mod_lot，傳入參數不變，於最後多傳入-1
#                                                   當ima918<>Y AND ima921<>Y點擊批序號維護批序號查詢給出提示信息
# Modify.........: No:FUN-910088 12/01/16 By chenjing  增加數量欄位小數取位
# Modify.........: No:FUN-BB0086 12/01/17 By tanxc  增加數量欄位小數取位
# Modify.........: No:TQC-C20183 12/02/09 By chenjing  增加數量欄位小數取位
# Modify.........: No:MOD-C30035 12/03/05 By Elise asft670右邊的ACTION應該是雜收(產生雜收單、維護雜收單) 
# Modify.........: No:CHI-C30106 12/04/05 By Elise 批序號維護
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:MOD-C60012 12/06/01 By ck2yuan 給sfl033欄位值
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C60069 12/06/27 By chenjing 修改點擊gen_data顯示不出來資料問題
# Modify.........: No.FUN-C70014 12/07/16 By suncx 新增sfe014
# Modify.........: No.TQC-C80160 12/09/10 By qiull sma95='N'時，隱藏批序號的相關功能按鈕和頁簽
# Modify.........: No.MOD-C80171 12/09/21 By Elise sfl02編碼方式改為一般的輸入格式
# Modify.........: No.CHI-C70016 12/10/30 By bart 增加項次欄位
# Modify.........: No.FUN-CB0043 12/11/26 By bart sfe_file增加自定義欄位
# Modify.........: No.CHI-C80041 12/11/28 By bart 取消單頭資料控制
# Modify.........: No.FUN-CB0087 12/12/14 By fengrui 倉庫單據理由碼改善
# Modify.........: No.FUN-CB0087 12/12/20 By xujing 倉庫單據理由碼改善
# Modify.........: No.TQC-D10080 13/01/21 By xujing 处理t670_azf03() 中g_errno清空
# Modify.........: No:CHI-D20010 13/02/21 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.TQC-D20042 13/02/25 By fengrui 修正倉庫單據理由碼改善测试问题
# Modify.........: No:FUN-D30065 13/03/20 By lixh1 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原			
# Modify.........: No:TQC-D40002 13/04/01 By fengrui 此作業無需根據ccz28='6'控卡過帳還原
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
# Modify.........: No:TQC-D50127 13/05/30 By lixh1 儲位為空則給空格

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    g_sfk   RECORD LIKE sfk_file.*,
    g_sfk_t RECORD LIKE sfk_file.*,
    g_sfk_o RECORD LIKE sfk_file.*,
    b_sfl       RECORD LIKE sfl_file.*,
    g_sfl           DYNAMIC ARRAY OF RECORD
          sfl011    LIKE sfl_file.sfl011,  #CHI-C70016
          sfl02     LIKE sfl_file.sfl02,
          sfl03     LIKE sfl_file.sfl03,
          ima02     LIKE ima_file.ima02,
          ima021    LIKE ima_file.ima021,
          sfl012    LIKE sfl_file.sfl012,     #FUN-A60027 
          sfl04     LIKE sfl_file.sfl04,
          sfl041    LIKE sfl_file.sfl041,
          sfl031    LIKE sfl_file.sfl031,
          sfl05     LIKE sfl_file.sfl05,
          sfl06     LIKE sfl_file.sfl06,
          sfl063    LIKE sfl_file.sfl063,
          sfl07     LIKE sfl_file.sfl07,
          sfl13     LIKE sfl_file.sfl13,
          sfl14     LIKE sfl_file.sfl14,
          sfl15     LIKE sfl_file.sfl15,
          sfl10     LIKE sfl_file.sfl10,
          sfl11     LIKE sfl_file.sfl11,
          sfl12     LIKE sfl_file.sfl12,
          sfl08     LIKE sfl_file.sfl08,
          azf03     LIKE azf_file.azf03,
          sfl09     LIKE sfl_file.sfl09,
          sflud01   LIKE sfl_file.sflud01,
          sflud02   LIKE sfl_file.sflud02,
          sflud03   LIKE sfl_file.sflud03,
          sflud04   LIKE sfl_file.sflud04,
          sflud05   LIKE sfl_file.sflud05,
          sflud06   LIKE sfl_file.sflud06,
          sflud07   LIKE sfl_file.sflud07,
          sflud08   LIKE sfl_file.sflud08,
          sflud09   LIKE sfl_file.sflud09,
          sflud10   LIKE sfl_file.sflud10,
          sflud11   LIKE sfl_file.sflud11,
          sflud12   LIKE sfl_file.sflud12,
          sflud13   LIKE sfl_file.sflud13,
          sflud14   LIKE sfl_file.sflud14,
          sflud15   LIKE sfl_file.sflud15
                    END RECORD,
    #g_sfb02     DYNAMIC ARRAY OF LIKE sfb_file.sfb02, #No.MOD-880137 add by liuxqa
     g_sfb02     LIKE sfb_file.sfb02,  #Mod No.MOD-AA0184 写法存在问题
     g_ima63_fac DYNAMIC ARRAY OF LIKE ima_file.ima63_fac, #No.MOD-880137 add by liuxqa
    g_sfl_t         RECORD
          sfl011    LIKE sfl_file.sfl011,  #CHI-C70016
          sfl02     LIKE sfl_file.sfl02,
          sfl03     LIKE sfl_file.sfl03,
          ima02     LIKE ima_file.ima02,
          ima021    LIKE ima_file.ima021,
          sfl012    LIKE sfl_file.sfl012,        #FUN-A60027
          sfl04     LIKE sfl_file.sfl04,
          sfl041    LIKE sfl_file.sfl041,
          sfl031    LIKE sfl_file.sfl031,
          sfl05     LIKE sfl_file.sfl05,
          sfl06     LIKE sfl_file.sfl06,
          sfl063    LIKE sfl_file.sfl063,
          sfl07     LIKE sfl_file.sfl07,
          sfl13     LIKE sfl_file.sfl13,
          sfl14     LIKE sfl_file.sfl14,
          sfl15     LIKE sfl_file.sfl15,
          sfl10     LIKE sfl_file.sfl10,
          sfl11     LIKE sfl_file.sfl11,
          sfl12     LIKE sfl_file.sfl12,
          sfl08     LIKE sfl_file.sfl08,
          azf03     LIKE azf_file.azf03,
          sfl09     LIKE sfl_file.sfl09,
          sflud01   LIKE sfl_file.sflud01,
          sflud02   LIKE sfl_file.sflud02,
          sflud03   LIKE sfl_file.sflud03,
          sflud04   LIKE sfl_file.sflud04,
          sflud05   LIKE sfl_file.sflud05,
          sflud06   LIKE sfl_file.sflud06,
          sflud07   LIKE sfl_file.sflud07,
          sflud08   LIKE sfl_file.sflud08,
          sflud09   LIKE sfl_file.sflud09,
          sflud10   LIKE sfl_file.sflud10,
          sflud11   LIKE sfl_file.sflud11,
          sflud12   LIKE sfl_file.sflud12,
          sflud13   LIKE sfl_file.sflud13,
          sflud14   LIKE sfl_file.sflud14,
          sflud15   LIKE sfl_file.sflud15
                    END RECORD,
    g_ima86     LIKE ima_file.ima86,
    g_img09     LIKE img_file.img09,
    g_img10     LIKE img_file.img10,
    g_ima571    LIKE ima_file.ima571,
    g_ecb08     LIKE ecb_file.ecb08,
    g_over_qty  LIKE sfb_file.sfb08,
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_yy,g_mm           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_sfk01             LIKE sfk_file.sfk01,
    g_cmd               LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(200)
    g_t1                LIKE oay_file.oayslip,        #No.FUN-550067        #No.FUN-680121 VARCHAR(05)
    g_ima63             LIKE ima_file.ima63,
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_factor            LIKE ima_file.ima31_fac,
    g_sfl033            LIKE sfl_file.sfl033,         #MOD-C60012 add
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10,
    g_flag              LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_buf               LIKE gfe_file.gfe02,          #No.FUN-680121 VARCHAR(20)
    g_rec_b             LIKE type_file.num5,          #單身筆數        #No.FUN-680121 SMALLINT
    l_za05              LIKE za_file.za05,
    l_ac            LIKE type_file.num5,                #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
    g_argv1         LIKE oea_file.oea01,   #No.FUN-680121 VARCHAR(16)#No.FUN-550067
    g_argv2         STRING,                #TQC-630068 add
    g_argv3         LIKE sfl_file.sfl02,   #No.FUN-680121 CAHR(16)#TQC-630068 從g_argv1->g_argv3
    g_argv4         LIKE sfl_file.sfl02,   #No.FUN-680121 VARCHAR(10)#TQC-630068 從g_argv2->g_argv4
    g_argv5         LIKE sfl_file.sfl04,   #No.FUN-680121 VARCHAR(6)#TQC-630068 從g_argv3->g_argv5
    g_argv6         LIKE sfl_file.sfl03    #No.MOD-490217   #TQC-630068 從g_argv4->g_argv6
 
DEFINE   u_sign	   LIKE type_file.num5     #No.FUN-680121 SMALLINT
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
#主程式開始
DEFINE g_before_input_done  LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_bookno1       LIKE aza_file.aza81          #No.FUN-730057 INTEGER
DEFINE   g_bookno2       LIKE aza_file.aza82          #No.FUN-730057 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_post          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   g_void          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   DEFINE  l_table    STRING                                                    
   DEFINE  l_sql      STRING                                                    
   DEFINE  g_str      STRING                                                    
#--------------------No:CHI-A80038 add 
DEFINE   g_ima918     LIKE ima_file.ima918
DEFINE   g_ima921     LIKE ima_file.ima921
DEFINE   g_r          LIKE type_file.chr1
#--------------------No:CHI-A80038 end 
#FUN-910088--add--start--
DEFINE g_sfl031_t    LIKE sfl_file.sfl031,
       g_sfl10_t     LIKE sfl_file.sfl10,
       g_sfl13_t     LIKE sfl_file.sfl13
#FUN-910088--add--end--

MAIN
DEFINE
    p_row,p_col   LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730075
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ASF")) THEN
       EXIT PROGRAM
    END IF
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
    LET g_sql = "sfk01.sfk_file.sfk01,",
                "sfk02.sfk_file.sfk02,",
                "sfk03.sfk_file.sfk03,",  
                "sfl02.sfl_file.sfl02,",
                "sfl03.sfl_file.sfl03,",
                "sfl04.sfl_file.sfl04,",
                "sfl041.sfl_file.sfl041,",
                "sfl05.sfl_file.sfl05,",
                "sfl06.sfl_file.sfl06,",
                "sfl063.sfl_file.sfl063,",
                "sfl07.sfl_file.sfl07,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021,",
                "sfl031.sfl_file.sfl031,",
                "azf03.azf_file.azf03,",
                "sfl09.sfl_file.sfl09,",
                "aag02.aag_file.aag02,"
 
   LET l_table = cl_prt_temptable('asft670',g_sql) CLIPPED                      
   IF l_table = -1 THEN EXIT PROGRAM END IF                                     
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                        
               " VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "                    
   PREPARE insert_prep FROM g_sql                                               
   IF STATUS THEN                                                               
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                         
   END IF                                                                       
 
    LET g_argv1  = ARG_VAL(1)  #報廢單號
    LET g_argv2  = ARG_VAL(2)  #執行功能   #TQC-630068 add
    LET g_argv3  = ARG_VAL(3)  #工單單號   #TQC-630068 從g_argv1->g_argv3
    LET g_argv4  = ARG_VAL(4)  #程式代號   #TQC-630068 從g_argv2->g_argv4
    LET g_argv5  = ARG_VAL(5)  #製程序號   #TQC-630068 從g_argv3->g_argv5
    LET g_argv6  = ARG_VAL(6)  #料件編號   #TQC-630068 從g_argv4->g_argv6
 
    LET p_row = 3 LET p_col = 3
    OPEN WINDOW t670_w AT p_row,p_col      #顯示畫面
         WITH FORM "asf/42f/asft670"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
    CALL t670_def_form()
    #FUN-A60027 --------------start----------------
    IF g_sma.sma541 = 'Y' THEN
       CALL cl_set_comp_visible("sfl012,sfl041", TRUE)   #TQC-AB0394 add sfl041
    ELSE
       CALL cl_set_comp_visible("sfl012,sfl041",FALSE)   #TQC-AB0394 addsfl041
    END IF 
    #FUN-A60027 -------------end------------------    
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    # 先以g_argv2判斷直接執行哪種功能：
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t670_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t670_a()
             END IF
          OTHERWISE          #TQC-660067 add
             CALL t670_q()   #TQC-660067 add
       END CASE
    END IF
 
    CALL t670()
 
    CLOSE WINDOW t670_w                    #結束畫面
 
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
FUNCTION t670()
  DEFINE l_za05    LIKE type_file.chr1000  #No.FUN-680121 VARCHAR(40)
    WHENEVER ERROR CONTINUE                #忽略一切錯誤
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM sfk_file WHERE sfk01 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t670_cl CURSOR FROM g_forupd_sql
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
    CALL t670_menu()
 
END FUNCTION
 
FUNCTION t670_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                             #清除畫面
    CALL g_sfl.clear()
 
  IF NOT cl_null(g_argv1) THEN
     LET g_wc = " sfk01 = '",g_argv1,"'"
     LET g_wc2= " 1=1"
  ELSE
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_sfk.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON sfk01,sfk02,sfk03,sfkconf, #FUN-660134
                              sfkpost,sfkuser,sfkgrup,sfkmodu,sfkdate,
                              sfkud01,sfkud02,sfkud03,sfkud04,sfkud05,
                              sfkud06,sfkud07,sfkud08,sfkud09,sfkud10,
                              sfkud11,sfkud12,sfkud13,sfkud14,sfkud15
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
          CASE WHEN INFIELD(sfk01) #查詢單据
                    CALL cl_init_qry_var()
                    LET g_qryparam.state    = "c"
                    LET g_qryparam.form     = "q_sfk"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO sfk01
                    NEXT FIELD sfk01
            END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
 # 螢幕上取單身條件
    CONSTRUCT g_wc2 ON sfl011,sfl02,sfl03,sfl012,sfl04,sfl041,sfl031,sfl05,sfl06,sfl063,    #FUN-A60027 add sfl012 #CHI-C70016 add sfl011
                       sfl07,sfl13,sfl14,sfl15,sfl10,sfl11,sfl12,sfl08,sfl09, 
                       sflud01,sflud02,sflud03,sflud04,sflud05,
                       sflud06,sflud07,sflud08,sflud09,sflud10,
                       sflud11,sflud12,sflud13,sflud14,sflud15
         FROM s_sfl[1].sfl011,s_sfl[1].sfl02,s_sfl[1].sfl03,s_sfl[1].sfl012,s_sfl[1].sfl04,          #FUN-A60027 add sfl012 #CHI-C70016 add sfl011
              s_sfl[1].sfl041,s_sfl[1].sfl031,s_sfl[1].sfl05,s_sfl[1].sfl06,
              s_sfl[1].sfl063,s_sfl[1].sfl07,s_sfl[1].sfl13,s_sfl[1].sfl14,
              s_sfl[1].sfl15,s_sfl[1].sfl10,s_sfl[1].sfl11,s_sfl[1].sfl12,
              s_sfl[1].sfl08,s_sfl[1].sfl09,
              s_sfl[1].sflud01,s_sfl[1].sflud02,s_sfl[1].sflud03,
              s_sfl[1].sflud04,s_sfl[1].sflud05,s_sfl[1].sflud06,
              s_sfl[1].sflud07,s_sfl[1].sflud08,s_sfl[1].sflud09,
              s_sfl[1].sflud10,s_sfl[1].sflud11,s_sfl[1].sflud12,
              s_sfl[1].sflud13,s_sfl[1].sflud14,s_sfl[1].sflud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION controlp
           CASE WHEN INFIELD(sfl02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfb02"
                     LET g_qryparam.construct= "Y"
                     LET g_qryparam.arg1     = "234567"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfl02
                     NEXT FIELD sfl02
 
                WHEN INFIELD(sfl03)
 
## q_sfa2 只能回傳3個值--> old 是5個
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfa2"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfl03
                     NEXT FIELD sfl03
 
                #FUN-A60027 ---------------start---------------
                WHEN INFIELD(sfl012)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_ecu012_1"     
                     CALL cl_create_qry() RETURNING g_qryparam.multiret    
                     DISPLAY g_qryparam.multiret TO  sfl012
                     NEXT FIELD sfl012 
                #FUN-A60027 --------------end-----------------

                WHEN INFIELD(sfl08)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_azf01a" #No.FUN-930104 
                     LET g_qryparam.default1 = g_sfl[1].sfl08
                     LET g_qryparam.arg1     = "D"        #No.FUN-930104  
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfl08
                     NEXT FIELD sfl08
 
                WHEN INFIELD(sfl04)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfa14"
                     LET g_qryparam.construct= "Y"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfl04
                     NEXT FIELD sfl04
                     
               WHEN INFIELD(sfl041)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form     = "q_sfl041"
                     LET g_qryparam.construct= "Y"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfl041
                     NEXT FIELD sfl041      
 
               WHEN INFIELD(sfl09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_aag"
                     LET g_qryparam.construct = "Y"
                     LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') "
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfl09
                     NEXT FIELD sfl09
               WHEN INFIELD(sfl031)
                     CALL cl_init_qry_var()
                     LET g_qryparam.state    = "c"
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.construct = "Y"
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO sfl031
                     NEXT FIELD sfl031
           END CASE
           MESSAGE ' '
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
  END IF   #TQC-630068
 
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('sfkuser', 'sfkgrup')
 
    IF NOT cl_null(g_argv3)  THEN   #TQC-630068
       LET g_sql = "SELECT UNIQUE sfk01 FROM sfl_file,sfk_file ",
                   " WHERE sfl01=sfk01 AND sfl02 = ",g_argv3 CLIPPED,
                   "   AND sfl03 = ",g_argv6 CLIPPED,
                   "   AND sfl04 = ",g_argv5 CLIPPED
    ELSE
      IF g_wc2 = " 1=1" THEN                    # 若單身未輸入條件
          LET g_sql = "SELECT  sfk01 FROM sfk_file WHERE ", g_wc CLIPPED
      ELSE                                              # 若單身有輸入條件
          LET g_sql = "SELECT UNIQUE sfk01 ",
                      " FROM sfl_file,sfk_file ",
                      " WHERE sfl01 = sfk01 AND ", g_wc CLIPPED,
                      " AND ",g_wc2 CLIPPED
      END IF
    END IF
    IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
 
   PREPARE t670_prepare FROM g_sql
   DECLARE t670_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t670_prepare
 
  #IF NOT cl_null(g_argv1) THEN   #TQC-630068 mark
   IF NOT cl_null(g_argv3) THEN   #TQC-630068
      LET g_sql="SELECT COUNT(DISTINCT sfk01) FROM sfk_file,sfl_file WHERE ",
                "sfk01=sfl01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                " AND sfl02 = ",g_argv3 CLIPPED,
                " AND sfl03 = ",g_argv6 CLIPPED,
                " AND sfl04 = ",g_argv5 CLIPPED
   ELSE
     IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM sfk_file WHERE ",g_wc CLIPPED
     ELSE
        LET g_sql="SELECT COUNT(DISTINCT sfk01) FROM sfk_file,sfl_file WHERE ",
                  "sfk01=sfl01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
     END IF
   END IF
   PREPARE t670_precount FROM g_sql
   DECLARE t670_count CURSOR FOR t670_precount
 
END FUNCTION
 
FUNCTION t670_menu()
 
   WHILE TRUE
 
      CALL t670_bp("G")
      CASE g_action_choice
 
           WHEN "insert"
              IF cl_chk_act_auth() THEN
                 CALL t670_a()
              END IF
           WHEN "query"
              IF cl_chk_act_auth() THEN
                 CALL t670_q()
              END IF
           WHEN "delete"
              IF cl_chk_act_auth() THEN
                 CALL t670_r()
              END IF
           WHEN "modify"
              IF cl_chk_act_auth() THEN
                 CALL t670_u()
              END IF
           WHEN "detail"
              IF cl_chk_act_auth() THEN
                 CALL t670_b()
              ELSE
                 LET g_action_choice = NULL
              END IF
           WHEN "output"
              IF cl_chk_act_auth() THEN
                 CALL t670_out()
              END IF
           WHEN "help"
              CALL cl_show_help()
           WHEN "exit"
              EXIT WHILE
           WHEN "controlg"
              CALL cl_cmdask()
          #WHEN "gen_m_iss"  #產生雜發單  #MOD-C30035 mark
           WHEN "gen_m_iss"  #產生雜收單  #MOD-C30035
              CALL t670_gen_m_iss()
          #WHEN "m_iss"  #維護雜發單  #MOD-C30035 mark
           WHEN "m_iss"  #維護雜收單  #MOD-C30035
              CALL t670_m_iss()
           WHEN "stock_post"
              IF cl_chk_act_auth() THEN
                 CALL t670_s()
              END IF
              IF g_sfk.sfkconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_void,"")
         #@WHEN "確認"
           WHEN "confirm"
              IF cl_chk_act_auth() THEN
                 CALL t670_y_chk()
                 IF g_success = "Y" THEN
                    CALL t670_y_upd()
                 END IF
              END IF
         #@WHEN "取消確認"
           WHEN "undo_confirm"
              IF cl_chk_act_auth() THEN
                 CALL t670_z()
              END IF
           WHEN "undo_post"
              IF cl_chk_act_auth() THEN
                 CALL t670_w()
              END IF
              IF g_sfk.sfkconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_void,"")
           WHEN "void"
              IF cl_chk_act_auth() THEN
                #CALL t670_x()   #CHI-D20010
                 CALL t670_x(1)  #CHI-D20010
              END IF
              IF g_sfk.sfkconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_void,"")
           #CHI-D20010---begin
           WHEN "undo_void"
              IF cl_chk_act_auth() THEN
                 CALL t670_x(2)
              END IF
              IF g_sfk.sfkconf = 'X' THEN
                 LET g_void = 'Y'
              ELSE
                 LET g_void = 'N'
              END IF
              CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_void,"")
          #CHI-D20010---end
          #------------------No:CHI-A80038 add
           WHEN "qry_lot"
              IF (NOT cl_null(l_ac)) AND (l_ac >0) THEN                                  #TQC-B90236 add 
                 SELECT ima918,ima921 INTO g_ima918,g_ima921 
                   FROM ima_file
                  WHERE ima01 = g_sfl[l_ac].sfl03
                    AND imaacti = "Y"
              
                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                    LET g_success = 'Y'           
                    BEGIN WORK                 
                   #CALL s_lotout(g_prog,g_sfk.sfk01,0,0,                         #TQC-B90236 mark
                    CALL s_mod_lot(g_prog,g_sfk.sfk01,0,0,                         #TQC-B90236 add
                                  g_sfl[l_ac].sfl03,' ',' ',' ',
                                  g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl031,1,
                                  g_sfl[l_ac].sfl07,'','QRY',-1)                  #TQC-B90236 add '-1'
                           RETURNING g_r,g_qty 
                    IF g_success = "Y" THEN
                       COMMIT WORK
                    ELSE
                       ROLLBACK WORK    
                    END IF
                 #TQC-B90236---add----begin---
                 ELSE
                    CALL cl_err('','sfl-001',0)
                 #TQC-B90236---add----end-----
                 END IF
              END IF                                                       #TQC-B90236 add
          #------------------No:CHI-A80038 end
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfl),'','')
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_sfk.sfk01 IS NOT NULL THEN
                 LET g_doc.column1 = "sfk01"
                 LET g_doc.value1 = g_sfk.sfk01
                 CALL cl_doc()
               END IF
         END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t670_a()
    DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_sfl.clear()
    INITIALIZE g_sfk.* TO NULL
    LET g_sfk_o.* = g_sfk.*
    LET g_sfk_t.* = g_sfk.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_sfk.sfk02 = g_today
        LET g_sfk.sfkpost='N'
        LET g_sfk.sfkconf='N' #FUN-660134
        LET g_sfk.sfkuser=g_user
        LET g_sfk.sfkoriu = g_user #FUN-980030
        LET g_sfk.sfkorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_sfk.sfkgrup=g_grup
        LET g_sfk.sfkdate=g_today
        LET g_sfk.sfkplant = g_plant #FUN-980008 add
        LET g_sfk.sfklegal = g_legal #FUN-980008 add
        CALL t670_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0 CALL cl_err('',9001,0)
           INITIALIZE g_sfk.* TO NULL
           ROLLBACK WORK EXIT WHILE
        END IF
        IF g_sfk.sfk01 IS NULL THEN CONTINUE WHILE END IF
        BEGIN WORK            #NO:7829
        CALL s_auto_assign_no("asf",g_sfk.sfk01,g_sfk.sfk02,"F","sfk_file","sfk01","","","")
        RETURNING li_result,g_sfk.sfk01
      IF (NOT li_result) THEN
 
              ROLLBACK WORK   #No:7829
              CONTINUE WHILE
          END IF     #No.FUN-550067
	   DISPLAY BY NAME g_sfk.sfk01
        INSERT INTO sfk_file VALUES (g_sfk.*)
        IF STATUS THEN
           CALL cl_err3("ins","sfk_file",g_sfk.sfk01,"",STATUS,"","",1)  #No.FUN-660128
           ROLLBACK WORK   #No:7829
           CONTINUE WHILE
        END IF
 
        COMMIT WORK
 
        CALL cl_flow_notify(g_sfk.sfk01,'I')
 
        SELECT sfk01 INTO g_sfk.sfk01 FROM sfk_file WHERE sfk01 = g_sfk.sfk01
        LET g_sfk_t.* = g_sfk.*
 
        CALL g_sfl.clear()
        LET g_rec_b = 0
 
        CALL t670_b()                   #輸入單身
 
        SELECT COUNT(*) INTO g_cnt FROM sfl_file WHERE sfl01=g_sfk.sfk01
        IF g_cnt>0 THEN
           IF g_smy.smydmy4='Y' THEN #過帳否
               CALL t670_y_chk() #FUN-660134
               IF g_success='Y' THEN #FUN-660134
                  CALL t670_y_upd() #FUN-660134
               END IF
           END IF  
        ELSE
           DELETE FROM sfk_file WHERE sfk01 = g_sfk.sfk01
           IF STATUS  THEN
              CALL cl_err3("del","sfk_file",g_sfk.sfk01,"",STATUS,"","a_sfk_del",1)  #No.FUN-660128
           END IF
        END IF
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t670_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_sfk.sfk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sfk.* FROM sfk_file WHERE sfk01 = g_sfk.sfk01
    IF g_sfk.sfkpost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfk.sfkconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660134
    IF g_sfk.sfkpost = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_sfk_o.* = g_sfk.*
    BEGIN WORK
 
    OPEN t670_cl USING g_sfk.sfk01
    IF STATUS THEN
       CALL cl_err("OPEN t670_cl:", STATUS, 1)
       CLOSE t670_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t670_cl INTO g_sfk.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t670_cl ROLLBACK WORK RETURN
    END IF
    CALL t670_show()
    WHILE TRUE
        LET g_sfk.sfkmodu=g_user
        LET g_sfk.sfkdate=g_today
        CALL t670_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_sfk.*=g_sfk_t.*
            CALL t670_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        UPDATE sfk_file SET * = g_sfk.* WHERE sfk01 = g_sfk.sfk01
        IF STATUS OR SQLCA.SQLERRD[3]=0  THEN
           CALL cl_err3("upd","sfk_file",g_sfk_t.sfk01,"",STATUS,"","",1)  #No.FUN-660128
           CONTINUE WHILE
        END IF
        IF g_sfk.sfk01 != g_sfk_t.sfk01 THEN CALL t670_chkkey() END IF
        EXIT WHILE
    END WHILE
 
    CLOSE t670_cl
    COMMIT WORK
    CALL cl_flow_notify(g_sfk.sfk01,'U')
 
END FUNCTION
 
FUNCTION t670_chkkey()
    UPDATE sfl_file SET sfl01=g_sfk.sfk01 WHERE sfl01=g_sfk_t.sfk01
    IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("upd","sfl_file",g_sfk_t.sfk01,"",STATUS,"","upd sfl01",1)  #No.FUN-660128
       LET g_sfk.*=g_sfk_t.*
       CALL t670_show()
       ROLLBACK WORK
       RETURN
    END IF
END FUNCTION
 
FUNCTION t670_i(p_cmd)
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
  DEFINE p_cmd           LIKE type_file.chr1                 #a:輸入 u:更改        #No.FUN-680121 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1                 #判斷必要欄位是否有輸入        #No.FUN-680121 VARCHAR(1)
 
    DISPLAY BY NAME
        g_sfk.sfk01,g_sfk.sfk02,g_sfk.sfk03,g_sfk.sfkconf, #FUN-660134
        g_sfk.sfkpost,g_sfk.sfkuser,g_sfk.sfkgrup,g_sfk.sfkmodu,g_sfk.sfkdate
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_sfk.sfkoriu,g_sfk.sfkorig,
        g_sfk.sfk01,g_sfk.sfk02,g_sfk.sfk03,
        g_sfk.sfkud01,g_sfk.sfkud02,g_sfk.sfkud03,g_sfk.sfkud04,
        g_sfk.sfkud05,g_sfk.sfkud06,g_sfk.sfkud07,g_sfk.sfkud08,
        g_sfk.sfkud09,g_sfk.sfkud10,g_sfk.sfkud11,g_sfk.sfkud12,
        g_sfk.sfkud13,g_sfk.sfkud14,g_sfk.sfkud15 
         WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t670_set_entry(p_cmd)
            CALL t670_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         CALL cl_set_docno_format("sfk01")
 
        AFTER FIELD sfk01
         IF NOT cl_null(g_sfk.sfk01) AND (g_sfk.sfk01 != g_sfk_t.sfk01 OR g_sfk_t.sfk01 IS NULL) THEN  #TQC-720063
            CALL s_check_no("asf",g_sfk.sfk01, g_sfk_t.sfk01 ,"F","sfk_file","sfk01","")
            RETURNING li_result,g_sfk.sfk01
            DISPLAY BY NAME g_sfk.sfk01
            IF (NOT li_result) THEN
               LET g_sfk.sfk01=g_sfk_o.sfk01
               NEXT FIELD sfk01
            END IF
         END IF
 
        AFTER FIELD sfk02
            IF NOT cl_null(g_sfk.sfk02) THEN
	       IF g_sma.sma53 IS NOT NULL AND g_sfk.sfk02 <= g_sma.sma53 THEN
	           CALL cl_err('','mfg9999',0) NEXT FIELD sfk02
	       END IF
               CALL s_yp(g_sfk.sfk02) RETURNING g_yy,g_mm
               #不可大於現行年月
               IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                  CALL cl_err('','mfg6091',0) NEXT FIELD sfk02
               END IF
               CALL s_get_bookno(YEAR(g_sfk.sfk02))                                                                                    
                    RETURNING g_flag,g_bookno1,g_bookno2                                                                            
               IF g_flag =  '1' THEN  #抓不到帳別                                                                                   
                  CALL cl_err(g_sfk.sfk02,'aoo-081',1)                                                                           
                  NEXT FIELD sfk02                                                                                                  
               END IF                                                                                                               
            END IF
 
        AFTER FIELD sfkud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sfkud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        ON ACTION controlp
            CASE WHEN INFIELD(sfk01) #查詢單据
                      LET g_t1 = s_get_doc_no(g_sfk.sfk01)     #No.FUN-550067
                      CALL q_smy(FALSE,TRUE,g_t1,'ASF','F') RETURNING g_t1   #TQC-670008
                      LET g_sfk.sfk01=g_t1     #No.FUN-550067
                      DISPLAY BY NAME g_sfk.sfk01
                      NEXT FIELD sfk01
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
 
FUNCTION t670_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfk01",TRUE)
    END IF
END FUNCTION
 
FUNCTION t670_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("sfk01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t670_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t670_cs()
    IF INT_FLAG THEN 
       LET INT_FLAG = 0 
       INITIALIZE g_sfk.* TO NULL 
       RETURN 
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t670_cs                            #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_sfk.* TO NULL
    ELSE
        OPEN t670_count
        FETCH t670_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t670_fetch('F')                #讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t670_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t670_cs INTO g_sfk.sfk01
        WHEN 'P' FETCH PREVIOUS t670_cs INTO g_sfk.sfk01
        WHEN 'F' FETCH FIRST    t670_cs INTO g_sfk.sfk01
        WHEN 'L' FETCH LAST     t670_cs INTO g_sfk.sfk01
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
            FETCH ABSOLUTE g_jump t670_cs INTO g_sfk.sfk01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfk.sfk01,SQLCA.sqlcode,0)
        INITIALIZE g_sfk.* TO NULL          #No.FUN-6B0079 add
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
    SELECT * INTO g_sfk.* FROM sfk_file WHERE sfk01 = g_sfk.sfk01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sfk_file",g_sfk.sfk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_sfk.* TO NULL
    ELSE
       LET g_data_owner = g_sfk.sfkuser      #FUN-4C0035
       LET g_data_group = g_sfk.sfkgrup      #FUN-4C0035
       LET g_data_plant = g_sfk.sfkplant #FUN-980030
     CALL s_get_bookno(YEAR(g_sfk.sfk02))                                                                                    
          RETURNING g_flag,g_bookno1,g_bookno2                                                                            
     IF g_flag =  '1' THEN  #抓不到帳別                                                                                   
        CALL cl_err(g_sfk.sfk02,'aoo-081',1)                                                                           
     END IF                                                                                                               
       CALL t670_show()
    END IF
 
END FUNCTION
 
FUNCTION t670_show()
    LET g_sfk_t.* = g_sfk.*                #保存單頭舊值
    DISPLAY BY NAME g_sfk.sfkoriu,g_sfk.sfkorig,
               g_sfk.sfk01,g_sfk.sfk02,g_sfk.sfk03, g_sfk.sfkconf,g_sfk.sfkpost, #FUN-660134
               g_sfk.sfkuser,g_sfk.sfkgrup,g_sfk.sfkmodu,g_sfk.sfkdate,
               g_sfk.sfkud01,g_sfk.sfkud02,g_sfk.sfkud03,g_sfk.sfkud04,
               g_sfk.sfkud05,g_sfk.sfkud06,g_sfk.sfkud07,g_sfk.sfkud08,
               g_sfk.sfkud09,g_sfk.sfkud10,g_sfk.sfkud11,g_sfk.sfkud12,
               g_sfk.sfkud13,g_sfk.sfkud14,g_sfk.sfkud15 
 
    IF g_sfk.sfkconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_void,"")
    CALL t670_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t670_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
    DEFINE l_i          LIKE type_file.num10         #No:CHI-A80038 add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_sfk.sfk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    SELECT * INTO g_sfk.* FROM sfk_file WHERE sfk01 = g_sfk.sfk01
    IF g_sfk.sfkpost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfk.sfkconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660134
    IF g_sfk.sfkconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660134
    CALL t670_show()
 
    BEGIN WORK
 
    OPEN t670_cl USING g_sfk.sfk01
    IF STATUS THEN
       CALL cl_err("OPEN t670_cl:", STATUS, 1)
       CLOSE t670_cl
       ROLLBACK WORK
       RETURN
    END IF
 
    FETCH t670_cl INTO g_sfk.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfk.sfk01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
 
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "sfk01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_sfk.sfk01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete sfk,sfl!"
        DELETE FROM sfk_file WHERE sfk01 = g_sfk.sfk01
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
           CALL cl_err3("del","sfk_file",g_sfk.sfk01,"",STATUS,"","del_sfk",1)  #No.FUN-660128
           ROLLBACK WORK RETURN
        END IF
        DELETE FROM sfl_file WHERE sfl01 = g_sfk.sfk01
        IF STATUS THEN
           CALL cl_err3("del","sfl_file",g_sfk.sfk01,"",STATUS,"","del_sfl",1)  #No.FUN-660128
           ROLLBACK WORK RETURN
        END IF
       #---------------No:CHI-A80038 add
        FOR l_i = 1 TO g_rec_b
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_sfl[l_i].sfl03
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
             #IF NOT s_lotout_del(g_prog,g_sfk.sfk01,0,0,g_sfl[l_i].sfl03,'DEL') THEN   #TQC-B90236
              IF NOT s_lot_del(g_prog,g_sfk.sfk01,'',0,g_sfl[l_i].sfl03,'DEL') THEN   #TQC-B90236
                 CALL cl_err3("del","rvbs_file",g_sfk.sfk01,0,
                               SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 RETURN 
              END IF
           END IF
        END FOR
       #---------------No:CHI-A80038 end
    END IF
 
    COMMIT WORK
    CALL cl_flow_notify(g_sfk.sfk01,'D')
    CLEAR FORM
    CALL g_sfl.clear()
    INITIALIZE g_sfk.* TO NULL
    OPEN t670_count
    #FUN-B50064-add-start--
    IF STATUS THEN
       CLOSE t670_cl
       CLOSE t670_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50064-add-end-- 
    FETCH t670_count INTO g_row_count
    #FUN-B50064-add-start--
    IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
       CLOSE t670_cl
       CLOSE t670_count
       COMMIT WORK
       RETURN
    END IF
    #FUN-B50064-add-end-- 
    DISPLAY g_row_count TO FORMONLY.cnt
    OPEN t670_cs
    IF g_curs_index = g_row_count + 1 THEN
       LET g_jump = g_row_count
       CALL t670_fetch('L')
    ELSE
       LET g_jump = g_curs_index
       LET mi_no_ask = TRUE
       CALL t670_fetch('/')
    END IF
 
 
END FUNCTION
 
FUNCTION t670_b()
DEFINE
    l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_row,l_col      LIKE type_file.num5,                #No.FUN-680121 SMALLINT #分段輸入之行,列數
    l_n,l_cnt        LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw        LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd            LIKE type_file.chr1,                #處理狀態          #No.FUN-680121 VARCHAR(1)
    l_qty            LIKE sfl_file.sfl07,                #No.FUN-680121 DEC(15,3)
    l_sfa12          LIKE sfa_file.sfa12,
    l_sfa13          LIKE sfa_file.sfa13,
    l_sfb93          LIKE sfb_file.sfb93,   #MOD-910122 add
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5,                #可刪除否        #No.FUN-680121 SMALLINT
    l_c             LIKE type_file.num5,    #CHI-C30106 add
    l_flag          LIKE type_file.chr1,    #FUN-CB0087
    l_where         STRING                  #FUN-CB0087 
 
    LET g_action_choice = ""
    IF g_sfk.sfk01 IS NULL THEN RETURN END IF
    IF g_sfk.sfkpost = 'Y' THEN CALL cl_err('','mfg0175',0) RETURN END IF
    IF g_sfk.sfkconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF #FUN-660134
    IF g_sfk.sfkconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660134
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
        "SELECT * FROM sfl_file ",
        #" WHERE sfl01= ? AND sfl02 = ? AND sfl03 = ?  AND sfl012 = ? AND sfl04 = ? AND sfl041=? FOR UPDATE"    #FUN -A60027 add sfl012 #FUN-A80027 #CHI-C70016
        " WHERE sfl01= ? AND sfl011= ? FOR UPDATE"  #CHI-C70016
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t670_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_sfl.clear() END IF
 
    INPUT ARRAY g_sfl WITHOUT DEFAULTS FROM s_sfl.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b!=0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
         CALL cl_set_comp_entry("sfl04",g_sma.sma541 = 'N')     #FUN-A60076 
        #CALL cl_set_docno_format("sfl02")  #MOD-C80171 mark
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t670_cl USING g_sfk.sfk01
            IF STATUS THEN
               CALL cl_err("OPEN t670_cl:", STATUS, 1)
               CLOSE t670_cl
               ROLLBACK WORK
               RETURN
            END IF
 
            FETCH t670_cl INTO g_sfk.*          # 鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
                CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
                CLOSE t670_cl ROLLBACK WORK RETURN
            END IF

            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sfl_t.* = g_sfl[l_ac].*  #BACKUP
            #FUN-910088--add--start--
               LET g_sfl031_t = g_sfl[l_ac].sfl031
               LET g_sfl10_t = g_sfl[l_ac].sfl10
               LET g_sfl13_t = g_sfl[l_ac].sfl13
            #FUN-910088--add--end--
               #OPEN t670_bcl USING g_sfk.sfk01,g_sfl_t.sfl02,  #CHI-C70016
               #                    g_sfl_t.sfl03,g_sfl_t.sfl012,g_sfl_t.sfl04,     #FUN-A60027 add sfl012  #CHI-C70016
               #                    g_sfl_t.sfl041    #FUN-A80027  #CHI-C70016
               OPEN t670_bcl USING g_sfk.sfk01,g_sfl_t.sfl011  #CHI-C70016
               IF STATUS THEN
                  CALL cl_err("OPEN t670_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t670_bcl INTO b_sfl.* #FUN-730075
                  IF SQLCA.sqlcode THEN
                     CALL cl_err('lock sfl',SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t670_b_move_to() #FUN-730075
                  END IF
               END IF
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_sfl[l_ac].sfl03) THEN
                     SELECT ima63 INTO g_ima63
                       FROM ima_file WHERE ima01=g_sfl[l_ac].sfl03
 
                     CALL s_chk_va_setting(g_sfl[l_ac].sfl03)
                          RETURNING g_flag,g_ima906,g_ima907
 
                  END IF
                  CALL t670_set_entry_b(p_cmd)
                  CALL t670_set_no_entry_b(p_cmd)
               END IF
 
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_sfl[l_ac].* TO NULL          #900423
            LET g_sfl_t.* = g_sfl[l_ac].*
           #LET g_sfl[l_ac].sfl041=0
            LET g_sfl[l_ac].sfl05=0
            LET g_sfl[l_ac].sfl06=0
            LET g_sfl[l_ac].sfl063=0
            LET g_sfl[l_ac].sfl07=0
            LET g_sfl[l_ac].sfl11=1
            LET g_sfl[l_ac].sfl14=1
          #FUN-910088--add--start--
            LET g_sfl031_t = NULL
            LET g_sfl10_t = NULL
            LET g_sfl13_t = NULL
          #FUN-910088--add--end--
          # IF g_sma.sma541='N' OR g_sma.sma541 IS NULL THEN      #TQC-AB0394
               LET g_sfl[l_ac].sfl041=0  #TQC-AB0394
               LET g_sfl[l_ac].sfl012=' '#TQC-AB0394
          # END IF                       #TQC-AB0394
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            #NEXT FIELD sfl02  #CHI-C70016
            NEXT FIELD sfl011  #CHI-C70016
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
             #---------------No:CHI-A80038 add
              SELECT ima918,ima921 INTO g_ima918,g_ima921 
                FROM ima_file
               WHERE ima01 = g_sfl[l_ac].sfl03
                 AND imaacti = "Y"
              
              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                #IF NOT s_lotout_del(g_prog,g_sfk.sfk01,0,0,g_sfl[l_ac].sfl03,'DEL') THEN   #TQC-B90236
                 IF NOT s_lot_del(g_prog,g_sfk.sfk01,0,0,g_sfl[l_ac].sfl03,'DEL') THEN   #TQC-B90236
                    CALL cl_err3("del","rvbs_file",g_sfk.sfk01,0,
                                  SQLCA.sqlcode,"","",1)
                 END IF
              END IF
             #---------------No:CHI-A80038 end
              INITIALIZE g_sfl[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_sfl[l_ac].* TO s_sfl.*
              CALL g_sfl.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
            END IF
 
            IF cl_null(l_sfa13)  THEN LET l_sfa13 = 1  END IF
            IF cl_null(g_sfl[l_ac].sfl012) THEN LET g_sfl[l_ac].sfl012 = ' ' END IF    #FUN-A60076  
 
            IF g_sma.sma115 = 'Y' THEN
              IF NOT cl_null(g_sfl[l_ac].sfl03) THEN
                 SELECT ima63 INTO g_ima63
                   FROM ima_file WHERE ima01=g_sfl[l_ac].sfl03
              END IF
 
              CALL s_chk_va_setting(g_sfl[l_ac].sfl03)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD sfl03
              END IF
 
              CALL t670_du_data_to_correct()
 
              CALL t670_set_origin_field()
              #計算sfl07的值,檢查數量的合理性
              CALL t670_check_inventory_qty(p_cmd)  #No.MOD-7A0088 modify
               RETURNING g_flag,l_sfa13
              IF g_flag = '1' THEN
                 IF g_ima906 = '3' OR g_ima906 = '2' THEN
                    NEXT FIELD sfl15
                 ELSE
                    NEXT FIELD sfl12
                 END IF
              END IF
            ELSE 
               IF g_sfl[l_ac].sfl07<=0 THEN                                                                                           
                  CALL cl_err('','asf-991',1)                                                                                        
                  NEXT FIELD sfl07                                                                                                   
               END IF                                                                                                                
            END IF
            CALL t670_chk_sfl033()  #MOD-C60012 add
            CALL t670_b_move_back() #FUN-730075      
            IF cl_null(g_sfl[l_ac].sfl012)  THEN LET g_sfl[l_ac].sfl012 = ' '  END IF   #FUN-A60027 
            IF cl_null(b_sfl.sfl012)  THEN LET b_sfl.sfl012 = ' '  END IF   #FUN-A60095 
            IF cl_null(b_sfl.sfl041)  THEN LET b_sfl.sfl041 = 0  END IF   #FUN-A60095 
            INSERT INTO sfl_file VALUES (b_sfl.*)           
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","sfl_file",g_sfk.sfk01,g_sfl[l_ac].sfl02,SQLCA.sqlcode,"","ins sfl",1)  #No.FUN-660128
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
#CHI-C70016---begin
        BEFORE FIELD sfl011
           IF cl_null(g_sfl[l_ac].sfl011) OR g_sfl[l_ac].sfl011 = 0 THEN 
              SELECT MAX(sfl011)+1 
                INTO g_sfl[l_ac].sfl011
                FROM sfl_file
               WHERE sfl01 = g_sfk.sfk01
              IF cl_null(g_sfl[l_ac].sfl011) THEN
                 LET g_sfl[l_ac].sfl011 = 1
              END IF 
           END IF 
#CHI-C70016---end
        AFTER FIELD sfl02     #工單號碼
           IF NOT cl_null(g_sfl[l_ac].sfl02) THEN
             #CALL t670_sfb01('a')
              CALL t670_sfb01('a',g_sfl[l_ac].sfl02)  #Mod No.MOD-AA0184
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err(g_sfl[l_ac].sfl02,g_errno,0)
                 LET g_sfl[l_ac].sfl02=g_sfl_t.sfl02
                 NEXT FIELD sfl02
              END IF
              SELECT sfb93 INTO l_sfb93 FROM sfb_file WHERE sfb01 = g_sfl[l_ac].sfl02 #MOD-910122
           END IF
 
        BEFORE FIELD sfl03
            CALL t670_set_entry_b(p_cmd)
            CALL t670_set_no_required()
 
        AFTER FIELD sfl03     #料件編號
           IF NOT cl_null(g_sfl[l_ac].sfl03) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_sfl[l_ac].sfl03,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_sfl[l_ac].sfl03= g_sfl_t.sfl03
                 NEXT FIELD sfl03
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              #先檢查輸入的料件必須是前面輸入的那張工單的下階料
              SELECT COUNT(*) INTO l_cnt FROM sfa_file
               WHERE sfa01=g_sfl[l_ac].sfl02 
                 AND sfa03=g_sfl[l_ac].sfl03
              IF l_cnt = 0 THEN
                 CALL cl_err(g_sfl[l_ac].sfl03,'ams-003',0)
                 LET g_sfl[l_ac].sfl03=g_sfl_t.sfl03
                 NEXT FIELD sfl03
              END IF
              CALL t670_ima01('a')
              CALL t670_chk_sfl033()  #MOD-C60012 add
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err(g_sfl[l_ac].sfl03,g_errno,0)
                 LET g_sfl[l_ac].sfl03=g_sfl_t.sfl03
                 NEXT FIELD sfl03
              END IF
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_sfl[l_ac].sfl03)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD sfl03
                 END IF
                 SELECT ima63 INTO g_ima63
                   FROM ima_file WHERE ima01=g_sfl[l_ac].sfl03
                 CALL t670_du_default(p_cmd)
                 CALL t670_set_no_entry_b(p_cmd)
                 CALL t670_set_required()
              END IF
              IF g_sfl[l_ac].sfl03 <> g_sfl_t.sfl03 OR cl_null(g_sfl_t.sfl03) THEN
                 IF g_sfl[l_ac].sfl04 IS NULL THEN LET g_sfl[l_ac].sfl04=' ' END IF
                 SELECT sfa12 INTO g_sfl[l_ac].sfl031 FROM sfa_file
                  WHERE sfa01 = g_sfl[l_ac].sfl02 AND sfa03 = g_sfl[l_ac].sfl03
                    AND sfa08 = g_sfl[l_ac].sfl04 
                    AND sfa012 = g_sfl[l_ac].sfl012 AND sfa013=g_sfl[l_ac].sfl041  #FUN-A60095
                 IF STATUS THEN LET g_sfl[l_ac].sfl031='' END IF 
                 CALL t670_ins_rvbs()    #No:CHI-A80038 add  
              END IF 
           #FUN-910088--add--start--
              LET g_sfl[l_ac].sfl05 = s_digqty(g_sfl[l_ac].sfl05,g_sfl[l_ac].sfl031)
              LET g_sfl[l_ac].sfl06 = s_digqty(g_sfl[l_ac].sfl06,g_sfl[l_ac].sfl031)
              LET g_sfl[l_ac].sfl063 = s_digqty(g_sfl[l_ac].sfl063,g_sfl[l_ac].sfl031)
              DISPLAY BY NAME g_sfl[l_ac].sfl05,g_sfl[l_ac].sfl06,g_sfl[l_ac].sfl063
              IF NOT cl_null(g_sfl[l_ac].sfl07) AND g_sfl[l_ac].sfl07 != 0 THEN       #TQC-C20183--add--
                 IF NOT t670_sfl07_check() THEN 
                    LET g_sfl031_t = g_sfl[l_ac].sfl031
                    NEXT FIELD sfl07
                 END IF                                                                #TQC-C20183--add--
              END IF
           #FUN-910088--add--end--
           END IF
        #FUN-A60076 ----------start----------------
        AFTER FIELD sfl012    #製程段號
           LET l_cnt = 0    
           IF NOT cl_null(g_sfl[l_ac].sfl012) THEN
             #TQC-AB0394 --------------mod start--------------------  
             #IF cl_null(g_sfl[l_ac].sfl041) THEN
             #   SELECT COUNT(*) INTO l_cnt FROM ecm_file     #check 製程段號是否存在
             #    WHERE ecm01 = g_sfl[l_ac].sfl02
             #      AND ecm012 = g_sfl[l_ac].sfl012  
             #     #AND ecm03 = g_sfl[l_ac].sfl041           #FUN-A80027
             # ELSE
             #   SELECT COUNT(*) INTO l_cnt FROM ecm_file     #check 製程段號是否存在
             #    WHERE ecm01 = g_sfl[l_ac].sfl02
             #      AND ecm012 = g_sfl[l_ac].sfl012  
             #      AND ecm03 = g_sfl[l_ac].sfl041 
             # END IF
               SELECT COUNT(*) INTO l_cnt FROM sfa_file
                WHERE sfa01= g_sfl[l_ac].sfl02
                  AND sfa012= g_sfl[l_ac].sfl012
             #TQC-AB0394 -----------mod end------------------
               IF l_cnt = 0   THEN
                  CALL cl_err(g_sfl[l_ac].sfl012,'aec-300',0)
                  LET g_sfl[l_ac].sfl012 = g_sfl_t.sfl012
                  NEXT FIELD sfl012
               END IF 
            END IF 
            IF NOT t670_shl012() THEN CALL cl_err(g_sfl[l_ac].sfl012,'aec-300',0) NEXT FIELD sfl012 END IF   #TQC-AB0394
           #TQC-AB0394 ------------mod start------------- 
           # IF NOT cl_null(g_sfl[l_ac].sfl041) THEN
           #   SELECT ecm04  INTO g_sfl[l_ac].sfl04  FROM ecm_file   #由工單單號，制程段號，制程式帶出作業編號
           #    WHERE ecm01 = g_sfl[l_ac].sfl02                  
           #      AND ecm03 = g_sfl[l_ac].sfl041                   
           #      AND ecm012 = g_sfl[l_ac].sfl012       
           #END IF       
            CALL t670_sfa08(g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl012,g_sfl[l_ac].sfl041)
           #TQC-AB0394 ------------mod end------------------ 
        #FUN-A60076 ----------end-------------------    
 
        AFTER FIELD sfl04     #製程編號
           LET g_errno = ''
           IF NOT cl_null(g_sfl[l_ac].sfl04) THEN
             #TQC-AB0394 -------------add start--------------
             #IF l_sfb93 = 'Y' THEN    #MOD-910122
             #   SELECT COUNT(*) INTO l_cnt FROM ecm_file  #check 料件製程是否存在
             #    WHERE ecm01=g_sfl[l_ac].sfl02
             #     #AND ecm04=g_sfl[l_ac].sfl04        #FUN-A60076 mark
             #      AND ecm03 = g_sfl[l_ac].sfl041     #FUN-A60076 
             #      AND ecm012=g_sfl[l_ac].sfl012      #FUN-A60027 add by huangtao
              SELECT COUNT(*) INTO l_cnt FROM sfa_file
               WHERE sfa01=g_sfl[l_ac].sfl02
                 AND sfa08=g_sfl[l_ac].sfl04
                 AND sfa03=g_sfl[l_ac].sfl03
             #TQC-AB0394 -----------mod end----------------------
                 IF l_cnt = 0   THEN
                    CALL cl_err(g_sfl[l_ac].sfl04,g_errno,0)
                    LET g_sfl[l_ac].sfl04=g_sfl_t.sfl04
                    NEXT FIELD sfl04
                 END IF
            # END IF        #MOD-910122     #TQC-AB0394  
           END IF
           IF g_sfl[l_ac].sfl04 IS NULL THEN LET g_sfl[l_ac].sfl04=' ' END IF
           IF g_sfl[l_ac].sfl04 <> g_sfl_t.sfl04 OR cl_null(g_sfl_t.sfl04) THEN
              SELECT sfa12 INTO g_sfl[l_ac].sfl031 FROM sfa_file
               WHERE sfa01 = g_sfl[l_ac].sfl02 AND sfa03 = g_sfl[l_ac].sfl03
                 AND sfa08 = g_sfl[l_ac].sfl04 
                 AND sfa012 = g_sfl[l_ac].sfl012 AND sfa013=g_sfl[l_ac].sfl041  #FUN-A60095
	            IF STATUS THEN LET g_sfl[l_ac].sfl031='' END IF 
               #FUN-910088--add--start--
                 IF NOT cl_null(g_sfl[l_ac].sfl07) AND g_sfl[l_ac].sfl07 != 0 THEN      #TQC-C20183--add--
                    IF NOT t670_sfl07_check() THEN 
                       NEXT FIELD sfl07
                    END IF
                 END IF                                                                  #TQC-C20183--add--
                 LET g_sfl031_t = g_sfl[l_ac].sfl031
               #FUN-910088--add--end--
           END IF 
           
        AFTER FIELD sfl041     #製程序號
           IF NOT cl_null(g_sfl[l_ac].sfl041) THEN
            #TQC-AB0394--begin--add-----
            # IF g_sfl[l_ac].sfl041 > 0  THEN
 #..........#....check 料件製程序號是否存在
            #    SELECT COUNT(*) INTO l_cnt FROM ecm_file  #check 料件製程是否存在
            #     WHERE ecm01=g_sfl[l_ac].sfl02
            #       AND ecm03=g_sfl[l_ac].sfl041
            #       AND ecm012=g_sfl[l_ac].sfl012      #FUN-A60076 add by huangtao
            #    IF l_cnt = 0   THEN
            #       LET g_errno='100'
            #       CALL cl_err(g_sfl[l_ac].sfl041,g_errno,0)
            #       LET g_sfl[l_ac].sfl041=g_sfl_t.sfl041
            #       NEXT FIELD sfl041
            #    END IF
            # END IF
          #ELSE
          # LET g_sfl[l_ac].sfl041=0
            IF NOT t670_shl012() THEN CALL cl_err(g_sfl[l_ac].sfl012,'aec-301',0) NEXT FIELD sfl041 END IF
           END IF 
         #TQC-AB0394--end--add---------

         #TQC-AB0394-- -------------mod start--------------- 
         # SELECT ecm04  INTO g_sfl[l_ac].sfl04  FROM ecm_file   #FUN-A60076   由工單單號，制程段號，制程式帶出作業編號
         #  WHERE ecm01 = g_sfl[l_ac].sfl02                      #FUN-A60076
         #    AND ecm012 = g_sfl[l_ac].sfl012                    #FUN-A60076
         #    AND ecm03 = g_sfl[l_ac].sfl041                     #FUN-A60076  
          CALL t670_sfa08(g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl012,g_sfl[l_ac].sfl041)
         #TQC-AB0394 ------------mod end--------------------  
  
        AFTER FIELD sfl031    #單位
           LET g_errno = ''
           IF NOT cl_null(g_sfl[l_ac].sfl031) THEN
              CALL t670_gfe01('a')
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err(g_sfl[l_ac].sfl031,g_errno,0)
                 LET g_sfl[l_ac].sfl031=g_sfl_t.sfl031
                 NEXT FIELD sfl031
              END IF
             #IF g_sfb02[l_ac] != 11 THEN #若不是拆件式工單,則需check工單備料檔
              IF g_sfb02 != 11 THEN #若不是拆件式工單,則需check工單備料檔  #Mod No.MOD-AA0184
                    SELECT sfa12,sfa13 INTO l_sfa12,l_sfa13 FROM sfa_file
                     WHERE sfa01 = g_sfl[l_ac].sfl02 AND sfa03=g_sfl[l_ac].sfl03
                       AND sfa08 = g_sfl[l_ac].sfl04 AND sfa12=g_sfl[l_ac].sfl031
                       AND sfa012 = g_sfl[l_ac].sfl012 AND sfa013=g_sfl[l_ac].sfl041  #FUN-A60095
                 IF STATUS  THEN
                    CALL cl_err3("sel","sfa_file",g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl03,"asf-814","","sel_sfa",1)  #No.FUN-660128
                    LET g_sfl[l_ac].sfl031=g_sfl_t.sfl031
                    NEXT FIELD sfl031
                 END IF
                 IF cl_null(l_sfa13)  THEN LET l_sfa13 = 1  END IF
                 CALL t670_sfa('a')
                 IF NOT cl_null(g_errno)  THEN
                    CALL cl_err(g_sfl[l_ac].sfl031,g_errno,0)
                    LET g_sfl[l_ac].sfl031=g_sfl_t.sfl031
                    LET g_sfl[l_ac].sfl05 =g_sfl_t.sfl05
                    LET g_sfl[l_ac].sfl06 =g_sfl_t.sfl06
                    LET g_sfl[l_ac].sfl063=g_sfl_t.sfl063
                    NEXT FIELD sfl031
                 END IF
                 LET l_sfa13 = g_ima63_fac[l_ac] #發料單位/庫存單位換算率
              END IF
            #FUN-910088--add--start--
              IF NOT cl_null(g_sfl[l_ac].sfl07) AND g_sfl[l_ac].sfl07 != 0 THEN      #TQC-C20183--add--
                 IF NOT t670_sfl07_check() THEN 
                    NEXT FIELD sfl07
                 END IF
              END IF                                                                 #TQC-C20183--add
              LET g_sfl031_t = g_sfl[l_ac].sfl031
            #FUN-910088--add--end--
           END IF
 
        AFTER FIELD sfl07  #報廢量
           IF NOT t670_sfl07_check() THEN NEXT FIELD sfl07 END IF   #FUN-910088--add--
       #FUN-910088--mark--start--
       #   IF NOT cl_null(g_sfl[l_ac].sfl07) THEN
       #      IF g_sfl[l_ac].sfl07=0 THEN                                                                                           
       #         CALL cl_err('','asf-713',0)                                                                                        
       #         NEXT FIELD sfl07                                                                                                   
       #      END IF                                                                                                                
       #     #IF g_sfb02[l_ac] != 11 THEN
       #      IF g_sfb02 != 11 THEN  #Mod No.MOD-AA0184
       #         #Mod No.MOD-AA0184
       #         #CALL t670_sfa_num(p_cmd)   #check數量    #No.MOD-7A0088 modify
       #          CALL t670_sfa_num(p_cmd,g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl04,
       #                            g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl041,g_sfl[l_ac].sfl012,
       #                            g_sfl[l_ac].sfl07,g_sfl[l_ac].sfl063)   #check數量    #No.MOD-7A0088 modify
       #         #End Mod No.MOD-AA0184
       #      END IF
       #      IF NOT cl_null(g_errno)  THEN
       #         CALL cl_err(g_sfl[l_ac].sfl07,g_errno,0)
       #         LET g_sfl[l_ac].sfl07=g_sfl_t.sfl07
       #         NEXT FIELD sfl07
       #      END IF
       #   END IF
       #   IF g_sfl[l_ac].sfl07<0 THEN NEXT FIELD sfl07 END IF      #No.TQC-740145
       #  #--------------------------No:CHI-A80038 add
       #   SELECT ima918,ima921 INTO g_ima918,g_ima921 
       #     FROM ima_file
       #    WHERE ima01 = g_sfl[l_ac].sfl03
       #      AND imaacti = "Y"
       #   IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
       #      (cl_null(g_sfl_t.sfl07) OR (g_sfl[l_ac].sfl07<>g_sfl_t.sfl07 )) THEN
       #     #CALL s_lotout(g_prog,g_sfk.sfk01,0,0,                          #TQC-B90236 mark
       #      CALL s_mod_lot(g_prog,g_sfk.sfk01,0,0,                          #TQC-B90236 add
       #                    g_sfl[l_ac].sfl03,' ',' ',' ',
       #                    g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl031,1,
       #                    g_sfl[l_ac].sfl07,'','SEL',-1)                   #TQC-B90236 add '-1'
       #            RETURNING g_r,g_qty 
       #      
       #      IF g_r = "Y" THEN
       #         LET g_sfl[l_ac].sfl07 = g_qty
       #      END IF
       #   END IF
       #  #--------------------------No:CHI-A80038 add
       #FUN-910088--mark--end--
 
        BEFORE FIELD sfl13
           IF NOT cl_null(g_sfl[l_ac].sfl03) THEN
              SELECT ima63 INTO g_ima63
                FROM ima_file WHERE ima01=g_sfl[l_ac].sfl03
           END IF
           CALL t670_set_no_required()
 
        AFTER FIELD sfl13  #第二單位
           IF cl_null(g_sfl[l_ac].sfl03) THEN NEXT FIELD sfl03 END IF
           IF NOT cl_null(g_sfl[l_ac].sfl13) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_sfl[l_ac].sfl13
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_sfl[l_ac].sfl13,"",STATUS,"","gfe",1)  #No.FUN-660128
                 NEXT FIELD sfl13
              END IF
              CALL s_du_umfchk(g_sfl[l_ac].sfl03,'','','',
                               g_ima63,g_sfl[l_ac].sfl13,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfl[l_ac].sfl13,g_errno,0)
                 NEXT FIELD sfl13
              END IF
              IF cl_null(g_sfl_t.sfl13) OR g_sfl_t.sfl13 <> g_sfl[l_ac].sfl13 THEN
                 LET g_sfl[l_ac].sfl14 = g_factor
              END IF
           END IF
           CALL t670_du_data_to_correct()
           CALL t670_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
       #FUN-910088--add--start--
           IF NOT t670_sfl15_check() THEN
              NEXT FIELD sfl15
           END IF
           LET g_sfl13_t = g_sfl[l_ac].sfl13
       #FUN-910088--add--end--
 
        AFTER FIELD sfl14  #第二轉換率
           IF NOT cl_null(g_sfl[l_ac].sfl14) THEN
              IF g_sfl[l_ac].sfl14=0 THEN
                 NEXT FIELD sfl14
              END IF
           END IF
 
        AFTER FIELD sfl15  #第二數量
           IF NOT t670_sfl15_check() THEN NEXT FIELD sfl15 END IF   #FUN-910088--add--
       #FUN-910088--mark--start--
       #   IF NOT cl_null(g_sfl[l_ac].sfl15) THEN
       #      IF g_sfl[l_ac].sfl15 < 0 THEN
       #         CALL cl_err('','aim-391',0)  #
       #         NEXT FIELD sfl15
       #      END IF
       #      IF p_cmd = 'a' OR  p_cmd = 'u' AND
       #         g_sfl_t.sfl15 <> g_sfl[l_ac].sfl15 THEN
       #         IF g_ima906='3' THEN
       #            LET g_tot=g_sfl[l_ac].sfl15*g_sfl[l_ac].sfl14
       #            IF cl_null(g_sfl[l_ac].sfl12) OR g_sfl[l_ac].sfl12=0 THEN #CHI-960022
       #               LET g_sfl[l_ac].sfl12=g_tot*g_sfl[l_ac].sfl11
       #               LET g_sfl[l_ac].sfl12 = s_digqty(g_sfl[l_ac].sfl12,g_sfl[l_ac].sfl10)
       #               DISPLAY BY NAME g_sfl[l_ac].sfl12                      #CHI-960022
       #            END IF                                                    #CHI-960022
       #         END IF
       #      END IF
       #   END IF
       #   CALL cl_show_fld_cont()                   #No.FUN-560197
       #FUN-910088--mark--end--
 
        AFTER FIELD sfl10  #第一單位
           IF cl_null(g_sfl[l_ac].sfl03) THEN NEXT FIELD sfl03 END IF
           IF NOT cl_null(g_sfl[l_ac].sfl10) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_sfl[l_ac].sfl10
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_sfl[l_ac].sfl10,"",STATUS,"","gfe",1)  #No.FUN-660128
                 NEXT FIELD sfl10
              END IF
              CALL s_du_umfchk(g_sfl[l_ac].sfl03,'','','',
                               g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl10,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_sfl[l_ac].sfl10,g_errno,0)
                 NEXT FIELD sfl10
              END IF
              IF cl_null(g_sfl_t.sfl10) OR g_sfl_t.sfl10 <> g_sfl[l_ac].sfl10 THEN
                 LET g_sfl[l_ac].sfl11 = g_factor
              END IF
           END IF
           CALL t670_du_data_to_correct()
           CALL t670_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
        #FUN-910088--add--start--
           IF NOT cl_null(g_sfl[l_ac].sfl12) AND g_sfl[l_ac].sfl12 != 0 THEN    #TQC-C20183--add--
              CASE t670_sfl12_check(l_sfa13)
                 WHEN "sfl12"
                    NEXT FIELD sfl12
                 WHEN "sfl15"
                    NEXT FIELD sfl15
                 OTHERWISE EXIT CASE
              END CASE
           END IF                                                                #TQC-C20183--add--
           LET g_sfl10_t = g_sfl[l_ac].sfl10
        #FUN-910088--add--end--
 
        AFTER FIELD sfl11  #第一轉換率
           IF NOT cl_null(g_sfl[l_ac].sfl11) THEN
              IF g_sfl[l_ac].sfl11=0 THEN
                 NEXT FIELD sfl11
              END IF
           END IF
 
        AFTER FIELD sfl12  #第一數量
           IF NOT t670_sfl12_check(l_sfa13) THEN NEXT FIELD sfl12 END IF    #FUN-910088--add--
       #FUN-910088--mark--start--
       #   IF NOT cl_null(g_sfl[l_ac].sfl12) THEN
       #      IF g_sfl[l_ac].sfl12 < 0 THEN
       #         CALL cl_err('','aim-391',0)  #
       #         NEXT FIELD sfl12
       #      END IF
       #   END IF
       #   #計算sfl07的值,檢查數量的合理性
       #   CALL t670_set_origin_field()
       #   LET l_sfa13 = g_factor
       #   CALL t670_check_inventory_qty(p_cmd)  #No.MOD-7A0088 modify
       #       RETURNING g_flag,l_sfa13
       #   IF g_flag = '1' THEN
       #      IF g_ima906 = '3' OR g_ima906 = '2' THEN
       #         NEXT FIELD sfl15
       #      ELSE
       #         NEXT FIELD sfl12
       #      END IF
       #   END IF
       #   CALL cl_show_fld_cont()                   #No.FUN-560197
       #FUN-910088--mark-end--

        #FUN-CB0087--add--str--
        BEFORE FIELD sfl08
           IF g_aza.aza115 = 'Y' AND cl_null(g_sfl[l_ac].sfl08) THEN 
              CALL s_reason_code(g_sfk.sfk01,g_sfl[l_ac].sfl02,'',g_sfl[l_ac].sfl03,'','','') RETURNING g_sfl[l_ac].sfl08
              CALL t670_azf03_desc()  #TQC-D20042
              DISPLAY BY NAME g_sfl[l_ac].sfl08
           END IF
        #FUN-CB0087--add--end--  
        AFTER FIELD sfl08  #理由碼 
           IF NOT cl_null(g_sfl[l_ac].sfl08) THEN
              CALL t670_azf03('a')
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err(g_sfl[l_ac].sfl08,g_errno,0)
                 LET g_sfl[l_ac].sfl08=g_sfl_t.sfl08
                 NEXT FIELD sfl08
              END IF
           END IF
           CALL t670_azf03_desc()  #TQC-D20042
           
        AFTER FIELD sfl09  #會計科目
           IF NOT cl_null(g_sfl[l_ac].sfl09)  THEN
              CALL t670_aag01('a',g_bookno1)      #No.FUN-730057
              IF NOT cl_null(g_errno)  THEN
                 CALL cl_err(g_sfl[l_ac].sfl09,g_errno,0)
#FUN-B10052 --begin--
#                 LET g_sfl[l_ac].sfl09=g_sfl_t.sfl09
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aag"
                     LET g_qryparam.arg1 = g_bookno1 
                     LET g_qryparam.construct = "N"
                     LET g_qryparam.default1 = g_sfl[l_ac].sfl09
                     LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') AND aag01 LIKE '",g_sfl[l_ac].sfl09 CLIPPED,"%'"
                     CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl09
                     DISPLAY BY NAME g_sfl[l_ac].sfl09  
#FUN-B10052 --end--
                 NEXT FIELD sfl09
              END IF
           END IF
 
        AFTER FIELD sflud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD sflud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF NOT cl_null(g_sfl_t.sfl02) AND   #MOD-710137
               NOT cl_null(g_sfl_t.sfl03)
            THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF

               #---------------No:CHI-A80038 add
                SELECT ima918,ima921 INTO g_ima918,g_ima921 
                  FROM ima_file
                 WHERE ima01 = g_sfl[l_ac].sfl03
                   AND imaacti = "Y"
                
                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  #IF NOT s_lotout_del(g_prog,g_sfk.sfk01,0,0,g_sfl[l_ac].sfl03,'DEL') THEN    #TQC-B90236
                   IF NOT s_lot_del(g_prog,g_sfk.sfk01,0,0,g_sfl[l_ac].sfl03,'DEL') THEN    #TQC-B90236
                      CALL cl_err3("del","rvbs_file",g_sfk.sfk01,0,
                                    SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
               #---------------No:CHI-A80038 end

                DELETE FROM sfl_file
                 #WHERE sfl01 = g_sfk.sfk01   AND sfl02 = g_sfl_t.sfl02  #CHI-C70016
                 #  AND sfl03 = g_sfl_t.sfl03 AND sfl012 = g_sfl_t.sfl012 AND sfl04 = g_sfl_t.sfl04     #FUN-A60027 add sfl012  #CHI-C70016
                 #  AND sfl041= g_sfl_t.sfl041   #FUN-A80027  #CHI-C70016
                 WHERE sfl01 = g_sfk.sfk01   AND sfl011 = g_sfl_t.sfl011  #CHI-C70016
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","sfl_file",g_sfk.sfk01,g_sfl_t.sfl02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
		COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_sfl[l_ac].* = g_sfl_t.*
               CLOSE t670_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sfl[l_ac].sfl02,-263,1)
               LET g_sfl[l_ac].* = g_sfl_t.*
            ELSE
               IF g_sma.sma115 = 'Y' THEN
                  IF NOT cl_null(g_sfl[l_ac].sfl03) THEN
                     SELECT ima63 INTO g_ima63
                       FROM ima_file WHERE ima01=g_sfl[l_ac].sfl03
                  END IF
 
                  CALL s_chk_va_setting(g_sfl[l_ac].sfl03)
                       RETURNING g_flag,g_ima906,g_ima907
                  IF g_flag=1 THEN
                     NEXT FIELD sfl03
                  END IF
 
                  CALL t670_du_data_to_correct()
 
                  CALL t670_set_origin_field()
                  LET l_sfa13 = g_factor
                  #計算sfl08的值,檢查數量的合理性
                  CALL t670_check_inventory_qty(p_cmd)  #No.MOD-7A0088 modify
                      RETURNING g_flag,l_sfa13
                  IF g_flag = '1' THEN
                     IF g_ima906 = '3' OR g_ima906 = '2' THEN
                        NEXT FIELD sfl15
                     ELSE
                        NEXT FIELD sfl12
                     END IF
                  END IF
               ELSE 
                  IF g_sfl[l_ac].sfl07<=0 THEN                                                                                           
                     CALL cl_err('','asf-991',1)                                                                                        
                     NEXT FIELD sfl07                                                                                                   
                  END IF                                                                                                                
               END IF
              #FUN-CB0087--add--str--
              IF g_aza.aza115='Y' THEN
                 CALL t670_azf03('a')
                 IF NOT cl_null(g_errno)  THEN
                    CALL cl_err(g_sfl[l_ac].sfl08,g_errno,1)
                    NEXT FIELD sfl08
                 END IF
              END IF   
              #FUN-CB0087--add--end--
              CALL t670_chk_sfl033()  #MOD-C60012 add
              CALL t670_b_move_back() #FUN-730075
              UPDATE sfl_file SET * = b_sfl.*
                 WHERE sfl01=g_sfk.sfk01
                   #AND sfl02=g_sfl_t.sfl02  #CHI-C70016
                   #AND sfl03=g_sfl_t.sfl03  #CHI-C70016
                   #AND sfl012 = g_sfl_t.sfl012   #FUN-A60027  #CHI-C70016
                   #AND sfl04=g_sfl_t.sfl04  #CHI-C70016
                   #AND sfl041=g_sfl_t.sfl041     #FUN-A80027  #CHI-C70016
                   AND sfl011=g_sfl_t.sfl011
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","sfl_file",g_sfk.sfk01,g_sfl_t.sfl02,SQLCA.sqlcode,"","upd sfl",1)  #No.FUN-660128
                  LET g_sfl[l_ac].* = g_sfl_t.*
                  ROLLBACK WORK
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              #CHI-C30106 add---str---
               IF p_cmd='a' AND l_ac <= g_sfl.getLength() THEN
                  SELECT ima918,ima921 INTO g_ima918,g_ima921
                    FROM ima_file
                   WHERE ima01 = g_sfl[l_ac].sfl03
                     AND imaacti = "Y"
                  IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                    IF NOT s_lotout_del(g_prog,g_sfk.sfk01,0,0,g_sfl[l_ac].sfl03,'DEL') THEN
                           CALL cl_err3("del","rvbs_file",g_sfk.sfk01,0,
                                         SQLCA.sqlcode,"","",1)
                    END IF
                  END IF
               END IF
              #CHI-C30106 add---end---
               IF p_cmd='u' THEN
                  LET g_sfl[l_ac].* = g_sfl_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sfl.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t670_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            #FUN-CB0087--add--str--
            IF g_aza.aza115='Y' THEN 
               CALL t670_azf03('a')
               IF NOT cl_null(g_errno)  THEN
                  CALL cl_err(g_sfl[l_ac].sfl08,g_errno,1)
                  NEXT FIELD sfl08
               END IF
            END IF                                            
            #FUN-CB0087--add--end--
            CLOSE t670_bcl
            COMMIT WORK
           #CALL g_sfl.deleteElement(g_rec_b+1)   #FUN-D40030 Mark

        #CHI-C30106---add---S---
        AFTER INPUT
          LET g_cnt = 0
          SELECT COUNT(*) INTO g_cnt FROM sfl_file WHERE sfl01=g_sfk.sfk01
          FOR l_c=1 TO g_cnt
          SELECT ima918,ima921 INTO g_ima918,g_ima921
            FROM ima_file
           WHERE ima01 = g_sfl[l_c].sfl03
             AND imaacti = "Y"

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              UPDATE rvbs_file SET rvbs021 = g_sfl[l_c].sfl03
               WHERE rvbs00=g_prog
                 AND rvbs01=g_sfk.sfk01
              END IF
          END FOR
        #CHI-C30106---add---E--- 
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF l_ac > 1 THEN
              LET g_sfl[l_ac].* = g_sfl[l_ac-1].*
              LET g_sfl[l_ac].sfl03 = NULL
              NEXT FIELD sfl03
           END IF
 
       #--------------------No:CHI-A80038 add
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921 
             FROM ima_file
            WHERE ima01 = g_sfl[l_ac].sfl03
              AND imaacti = "Y"
           
           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                #CALL s_lotout(g_prog,g_sfk.sfk01,0,0,                #TQC-B90236 mark
                 CALL s_mod_lot(g_prog,g_sfk.sfk01,0,0,                #TQC-B90236 add
                               g_sfl[l_ac].sfl03,' ',' ',' ',
                               g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl031,1,
                               g_sfl[l_ac].sfl07,'','SEL',-1)         #TQC-B90236 add '-1'
                       RETURNING g_r,g_qty 
              IF g_r = "Y" THEN
                 LET g_sfl[l_ac].sfl07 = g_qty
                 LET g_sfl[l_ac].sfl07 = s_digqty(g_sfl[l_ac].sfl07,g_sfl[l_ac].sfl031)    #FUN-910088--add--
              END IF
           #TQC-B90236---add----begin---
           ELSE
              CALL cl_err('','sfl-001',0)
           #TQC-B90236---add----end-----
           END IF
       #--------------------No:CHI-A80038 add

        ON ACTION controlp
           CASE WHEN INFIELD(sfl02)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_sfb02"
                     LET g_qryparam.construct= "Y"
                     LET g_qryparam.default1 = g_sfl[l_ac].sfl02
                     LET g_qryparam.arg1     = "234567"
                     CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl02
                      DISPLAY BY NAME g_sfl[l_ac].sfl02    #No.MOD-490371
                     NEXT FIELD sfl02
 
                WHEN INFIELD(sfl03)
## q_sfa2 只能回傳3個值--> old 是5個
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_sfa2"
                     LET g_qryparam.arg1 = g_sfl[l_ac].sfl02
                     CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl04,g_sfl[l_ac].sfl031
                        SELECT sfa05 INTO g_sfl[l_ac].sfl05 FROM sfa_file
                         WHERE sfa01 = g_sfl[l_ac].sfl02 AND sfa03 = g_sfl[l_ac].sfl03
                           AND sfa08 = g_sfl[l_ac].sfl04 AND sfa12 = g_sfl[l_ac].sfl031
                           AND sfa012 = g_sfl[l_ac].sfl012 AND sfa013=g_sfl[l_ac].sfl041  #FUN-A60095
                     DISPLAY BY NAME  g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl04,g_sfl[l_ac].sfl031
                     NEXT FIELD sfl03
 
                #FUN-A60027 ----------start----------------
                WHEN INFIELD(sfl012) 
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_shl012"                         #TQC-AB0394 mod q_shb012 -> q_shl012
                     LET g_qryparam.default1 = g_sfl[l_ac].sfl012
                     LET g_qryparam.default2 = g_sfl[l_ac].sfl041
                     LET g_qryparam.default3 = g_sfl[l_ac].sfl04
                     LET g_qryparam.arg1     = g_sfl[l_ac].sfl02
                     CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl012,g_sfl[l_ac].sfl041,g_sfl[l_ac].sfl04
                     #TQC-AB0394 --add start------------
                     IF g_sfl[l_ac].sfl012 IS NULL THEN LET g_sfl[l_ac].sfl012 = ' ' END IF
                     IF cl_null(g_sfl[l_ac].sfl04) THEN LET g_sfl[l_ac].sfl04 =  ' '     END IF
                     #TQC-AB0394 --addend---------------  
                     DISPLAY BY NAME g_sfl[l_ac].sfl012,g_sfl[l_ac].sfl041,g_sfl[l_ac].sfl04 
                     NEXT FIELD sfl012
                #FUN-A60027 -----------end-----------------
                
                WHEN INFIELD(sfl08)
                     #FUN-CB0087---add---str---         
                     CALL s_get_where(g_sfk.sfk01,g_sfl[l_ac].sfl02,'',g_sfl[l_ac].sfl03,'','','') RETURNING l_flag,l_where
                     IF l_flag AND g_aza.aza115 = 'Y' THEN 
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     ="q_ggc08"
                        LET g_qryparam.where = l_where
                        LET g_qryparam.default1 = g_sfl[l_ac].sfl08
                     ELSE
                     #FUN-CB0087---add---end---
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     = "q_azf01a" #No.FUN-930104 
                        LET g_qryparam.default1 = g_sfl[l_ac].sfl08
                        LET g_qryparam.arg1     = "D"        #No.FUN-930104
                     END IF  #FUN-CB0087 add   
                     CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl08
                     DISPLAY BY NAME g_sfl[l_ac].sfl08    #No.MOD-490371
                     CALL t670_azf03_desc()  #TQC-D20042
                     NEXT FIELD sfl08
 
                WHEN INFIELD(sfl04)
                   # IF l_sfb93 = 'N' THEN               #TQC-AB0394
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     = "q_sfa14"
                        LET g_qryparam.default1 = g_sfl[l_ac].sfl04
                        LET g_qryparam.arg1     = g_sfl[l_ac].sfl02
                        CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl04
                        DISPLAY BY NAME g_sfl[l_ac].sfl04  
                        NEXT FIELD sfl04          #TQC-AB0394 sfl08 -> sfl04
                    #TQC-AB0394--begin--mark---  
                    #ELSE
                    #   CALL q_ecm(FALSE,FALSE,g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl04)
                    #        RETURNING g_sfl[l_ac].sfl04,g_sfl[l_ac].sfl041
                    #   DISPLAY BY NAME g_sfl[l_ac].sfl04,g_sfl[l_ac].sfl041
                    #   NEXT FIELD sfl04
                    #END IF #MOD-910122   
                    #TQC-AB0394--end--mark--
  
                WHEN INFIELD(sfl041)
                     #FUN-A60076 ----------start-----------
                   # IF g_sma.sma541 = 'Y' THEN          #TQC-AB0394
                        CALL cl_init_qry_var()
                        LET g_qryparam.form     = "q_shl012"                     #TQC-AB0394 mod q_shb012 ->q_shl012
                        LET g_qryparam.default1 = g_sfl[l_ac].sfl012
                        LET g_qryparam.default2 = g_sfl[l_ac].sfl041
                        LET g_qryparam.default3 = g_sfl[l_ac].sfl04
                        LET g_qryparam.arg1     = g_sfl[l_ac].sfl02
                        CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl012,g_sfl[l_ac].sfl041,g_sfl[l_ac].sfl04
                        #TQC-AB0394 --add start------------
                        IF g_sfl[l_ac].sfl012 IS NULL THEN LET g_sfl[l_ac].sfl012 = ' ' END IF
                        IF cl_null(g_sfl[l_ac].sfl04) THEN LET g_sfl[l_ac].sfl04 =  ' '     END IF
                        #TQC-AB0394 --addend---------------                        
                        DISPLAY BY NAME g_sfl[l_ac].sfl012,g_sfl[l_ac].sfl041,g_sfl[l_ac].sfl04
                        NEXT FIELD sfl041
                    #TQC-AB0394--begin--mark-
                    #ELSE
                    ##FUN-A60076 -----------end-------------
                    #   CALL q_ecm(FALSE,FALSE,g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl04)
                    #        RETURNING g_sfl[l_ac].sfl04,g_sfl[l_ac].sfl041
                    #   DISPLAY BY NAME g_sfl[l_ac].sfl04,g_sfl[l_ac].sfl041
                    #   NEXT FIELD sfl041
                    #END IF                           #FUN-A60076 add 
                    #TQC-AB0394--end--mark---
               WHEN INFIELD(sfl09)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_aag"
                     LET g_qryparam.arg1 = g_bookno1 #No.FUN-730057
                     LET g_qryparam.construct = "Y"
                     LET g_qryparam.default1 = g_sfl[l_ac].sfl09
                     LET g_qryparam.where = " aag07 IN ('2','3') AND aag03 IN ('2') "
                     CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl09
                      DISPLAY BY NAME g_sfl[l_ac].sfl09    #No.MOD-490371
                     NEXT FIELD sfl09
               WHEN INFIELD(sfl031)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form ="q_gfe"
                     LET g_qryparam.construct = "Y"
                     LET g_qryparam.default1 = g_sfl[l_ac].sfl031
                     CALL cl_create_qry() RETURNING g_sfl[l_ac].sfl031
                     DISPLAY BY NAME g_sfl[l_ac].sfl031
                     NEXT FIELD sfl031
           END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
     END INPUT
 
      UPDATE sfk_file SET sfkmodu = g_user,sfkdate = g_today
       WHERE sfk01 = g_sfk.sfk01
 
    CLOSE t670_bcl
    COMMIT WORK
    CALL t670_delHeader()     #CHI-C30002 add
 
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t670_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_sfk.sfk01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM sfk_file ",
                  "  WHERE sfk01 LIKE '",l_slip,"%' ",
                  "    AND sfk01 > '",g_sfk.sfk01,"'"
      PREPARE t670_pb1 FROM l_sql 
      EXECUTE t670_pb1 INTO l_cnt 
      
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
         IF cl_chk_act_auth() THEN
           #CALL t670_x()   #CHI-D20010
            CALL t670_x(1)  #CHI-D20010
         END IF
         IF g_sfk.sfkconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM sfk_file WHERE sfk01 = g_sfk.sfk01
         INITIALIZE g_sfk.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
 
#---------------------------------No:CHI-A80038 add------------------------------------
FUNCTION t670_ins_rvbs()
   DEFINE l_rvbs     RECORD LIKE rvbs_file.*
   DEFINE l_c        LIKE type_file.num5
   DEFINE l_rvbs022  LIKE rvbs_file.rvbs022
   DEFINE l_sfe02    LIKE sfe_file.sfe02
   DEFINE l_sfs02    LIKE sfs_file.sfs02
   DEFINE l_sfs03    LIKE sfs_file.sfs03
   DEFINE l_sfs04    LIKE sfs_file.sfs04
 

   SELECT ima918,ima921 INTO g_ima918,g_ima921 
     FROM ima_file
    WHERE ima01 = g_sfl[l_ac].sfl03
      AND imaacti = "Y"
   
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      DECLARE t670_g_sfs CURSOR FOR SELECT sfe02 FROM sfe_file
                                     WHERE sfe01 = g_sfl[l_ac].sfl02
                                       AND sfe07 = g_sfl[l_ac].sfl03
                                    #  AND sfe06 MATCHES '[123AC]'          #TQC-C60069
                                       AND sfe06 IN ('1','2','3','A','C')   #TQC-C60069
      
      LET l_rvbs022 = 0

      FOREACH t670_g_sfs INTO l_sfe02
         IF STATUS THEN
            CALL cl_err('sfs',STATUS,1)
         END IF
      
         DECLARE t670_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                        WHERE rvbs01 = l_sfe02
                                          AND rvbs021 = g_sfl[l_ac].sfl03
         
         FOREACH t670_g_rvbs INTO l_rvbs.*
            IF STATUS THEN
               CALL cl_err('rvbs',STATUS,1)
            END IF
         
            LET l_rvbs.rvbs00 = g_prog       #程式代號
            LET l_rvbs.rvbs01 = g_sfk.sfk01
            LET l_rvbs.rvbs02 = 0
         
            IF cl_null(l_rvbs.rvbs10) THEN
               LET l_rvbs.rvbs10 = 0
            END IF
         
            LET l_rvbs.rvbs10 = l_rvbs.rvbs10 + l_rvbs.rvbs06
         
            LET l_rvbs.rvbs06 = 0
         
            UPDATE rvbs_file SET rvbs10 = l_rvbs.rvbs10
             WHERE rvbs00 = l_rvbs.rvbs00
               AND rvbs01 = l_rvbs.rvbs01
               AND rvbs02 = l_rvbs.rvbs02
               AND rvbs03 = l_rvbs.rvbs03
               AND rvbs04 = l_rvbs.rvbs04
               AND rvbs08 = l_rvbs.rvbs08
               AND rvbs09 = -1
               AND rvbs13 = 0
         
            IF STATUS OR SQLCA.SQLCODE THEN
               CALL cl_err3("upd","rvbs_file","","",SQLCA.sqlcode,"","upd rvbs",1)  
               LET g_success='N'
            END IF
         
            IF SQLCA.SQLERRD[3]=0 THEN
               LET l_rvbs022 = l_rvbs022 + 1
               LET l_rvbs.rvbs022 = l_rvbs022
               INSERT INTO rvbs_file VALUES(l_rvbs.*)
               IF STATUS OR SQLCA.SQLCODE THEN
                  CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1) 
                  LET g_success='N'
               END IF
            END IF
         
         END FOREACH
      END FOREACH
   END IF

END FUNCTION
#---------------------------------No:CHI-A80038 end------------------------------------

#FUNCTION t670_sfb01(p_cmd)  #工單
FUNCTION t670_sfb01(p_cmd,p_sfl02)  #工單  #Mod No.MOD-AA0184
    DEFINE l_sfbacti  LIKE sfb_file.sfbacti,
           l_sfb04    LIKE sfb_file.sfb04,
           p_cmd      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
    DEFINE p_sfl02    LIKE sfl_file.sfl02  #Add No.MOD-AA0184
 
    LET g_errno = ' '
   #Mod No.MOD-AA0184
   #SELECT sfbacti,sfb04,sfb02 INTO l_sfbacti,l_sfb04,g_sfb02[l_ac] FROM sfb_file
   # WHERE sfb01 = g_sfl[l_ac].sfl02 AND sfb87!='X'
    SELECT sfbacti,sfb04,sfb02 INTO l_sfbacti,l_sfb04,g_sfb02 FROM sfb_file
     WHERE sfb01 = p_sfl02 AND sfb87!='X'
   #End Mod No.MOD-AA0184
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-410'
         WHEN l_sfbacti='N'        LET g_errno = '9028'
         WHEN l_sfb04 NOT MATCHES '[234567]'   LET g_errno = 'mfg9006'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION t670_ima01(p_cmd)  #料件編號
    DEFINE l_ima02     LIKE ima_file.ima02,
           l_ima021    LIKE ima_file.ima021,
           l_imaacti   LIKE ima_file.imaacti,
           l_ima63     LIKE ima_file.ima63,
           l_ima63_fac LIKE ima_file.ima63_fac,
           p_cmd       LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT ima02,ima021,imaacti,ima63,ima63_fac INTO l_ima02,l_ima021,l_imaacti,l_ima63,l_ima63_fac
      FROM ima_file WHERE ima01 = g_sfl[l_ac].sfl03
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'ams-003'
                                   LET l_ima02 = NULL
                                   LET l_ima021= NULL
         WHEN l_imaacti='N'        LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #No.FUN-690022 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_sfl[l_ac].ima02 = l_ima02
       LET g_sfl[l_ac].ima021= l_ima021
      #IF g_sfb02[l_ac]=11 THEN
       IF g_sfb02=11 THEN  #Mod No.MOD-AA0184
          LET g_sfl[l_ac].sfl031 = l_ima63
          LET g_ima63_fac[l_ac]  = l_ima63_fac
       END IF
    END IF
 
END FUNCTION
 
FUNCTION t670_azf03(p_cmd)  #理由碼
    DEFINE l_azf03    LIKE azf_file.azf03,
           l_azf09    LIKE azf_file.azf09,         #No.FUN-930104
           l_azfacti  LIKE azf_file.azfacti,
           p_cmd      LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
           #FUN-CB0087--add--str--
           l_flag     LIKE type_file.chr1,
           l_where    STRING,
           l_sql      STRING,
           l_n        LIKE type_file.num5
           #FUN-CB0087--add--end--

   #FUN-CB0087--add--str--
   LET l_flag = FALSE
   IF g_aza.aza115='Y' THEN
      IF cl_null(g_sfl[l_ac].sfl08) THEN RETURN END IF  #TQC-D20042
      CALL s_get_where(g_sfk.sfk01,g_sfl[l_ac].sfl02,'',g_sfl[l_ac].sfl03,'','','') RETURNING l_flag,l_where
   END IF
   LET g_errno = ' '      #TQC-D10080 add
   IF g_aza.aza115='Y' AND l_flag THEN
      LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_sfl[l_ac].sfl08,"' AND ",l_where
      PREPARE ggc08_pre FROM l_sql
      EXECUTE ggc08_pre INTO l_n
      IF l_n < 1 THEN
         LET g_errno = 'aim-425'
         RETURN 
      ELSE 
         SELECT azf03 INTO g_sfl[l_ac].azf03 FROM azf_file WHERE azf01=g_sfl[l_ac].sfl08 AND azf02='2'
      END IF
   ELSE
   #FUN-CB0087--add--end--
   #   LET g_errno = ' '  #TQC-D10080 mark
       SELECT azf03,azf09,azfacti INTO l_azf03,l_azf09,l_azfacti      #No.FUN-930104
         FROM azf_file WHERE azf01 = g_sfl[l_ac].sfl08 AND azf02 = '2'                
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3088'
                                      LET l_azf03 = ' '
            WHEN l_azfacti='N'        LET g_errno = '9028'
            WHEN l_azf09 !='D'        LET g_errno = 'aoo-412' #No.FUN-930104 
           OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
       IF cl_null(g_errno) OR p_cmd = 'd' THEN
          LET g_sfl[l_ac].azf03 = l_azf03
       END IF
   END IF  #FUN-CB0087 add
END FUNCTION

 
FUNCTION t670_gfe01(p_cmd)  #單位
    DEFINE l_gfeacti  LIKE gfe_file.gfeacti,
           p_cmd      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT gfeacti INTO l_gfeacti
      FROM gfe_file WHERE gfe01 = g_sfl[l_ac].sfl031
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'afa-319'
         WHEN l_gfeacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION t670_aag01(p_cmd,p_bookno1)  #會計科目     #No.FUN-730057 
    DEFINE l_aagacti  LIKE aag_file.aagacti,
           p_cmd      LIKE type_file.chr1,         #No.FUN-680121 VARCHAR(1)
           p_bookno1  LIKE aza_file.aza81          #No.FUN-730057 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT aagacti INTO l_aagacti
      FROM aag_file WHERE aag01 = g_sfl[l_ac].sfl09             
                      AND aag00 = p_bookno1           #No.FUN-730057 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1004'
         WHEN l_aagacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION t670_sfa(p_cmd)  #check備料檔
    DEFINE l_n        LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_sfa05    LIKE sfa_file.sfa05,
           l_sfa06    LIKE sfa_file.sfa06,
           l_sfa061   LIKE sfa_file.sfa061,
           l_sfa062   LIKE sfa_file.sfa062,
           l_sfa063   LIKE sfa_file.sfa063,
           l_sfa13    LIKE sfa_file.sfa13,
           l_sfa161   LIKE sfa_file.sfa161,
           l_sfaacti  LIKE sfa_file.sfaacti,
           l_qty      LIKE sfb_file.sfb09,         #No.FUN-680121 DEC(15,3)
           p_cmd      LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    LET g_errno = ' '
    SELECT sfa05,sfa06,sfa061,sfa062,sfa063,sfa13,sfa161,sfaacti
     INTO l_sfa05,l_sfa06,l_sfa061,l_sfa062,l_sfa063,
          l_sfa13,l_sfa161,l_sfaacti FROM sfa_file
     WHERE sfa01 = g_sfl[l_ac].sfl02 AND sfa03 = g_sfl[l_ac].sfl03
       AND sfa08 = g_sfl[l_ac].sfl04 AND sfa12 = g_sfl[l_ac].sfl031
       AND sfa012 = g_sfl[l_ac].sfl012 AND sfa013=g_sfl[l_ac].sfl041  #FUN-A60095
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-814'
         #WHEN l_sfa06=0            LET g_errno = 'asf-574'   #MOD-940313
         WHEN l_sfa06+l_sfa062=0   LET g_errno = 'asf-574'   #MOD-940313
         WHEN l_sfaacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno) OR p_cmd = 'd'  THEN
       LET g_sfl[l_ac].sfl05 = l_sfa05
       LET g_sfl[l_ac].sfl06 = l_sfa06
       LET g_sfl[l_ac].sfl063= l_sfa063
    END IF
END FUNCTION
 
#Mod No.MOD-AA0184 增加传参
#          此外存在l_ac的，如g_sfl[l_ac].sfl*均改成p_sfl*
#FUNCTION t670_sfa_num(p_cmd)  #check備料檔數量    #No.MOD-7A0088 modify
FUNCTION t670_sfa_num(p_cmd,p_sfl02,p_sfl03,p_sfl04,p_sfl031,p_sfl041,p_sfl012,p_sfl07,p_sfl063)  #check備料檔數量    #No.MOD-7A0088 modify
#End Mod No.MOD-AA0184
    DEFINE l_qty      LIKE sfb_file.sfb09,        #No.FUN-680121 DEC(15,3)
           l_sfa06    LIKE sfa_file.sfa06,
           l_sfa062   LIKE sfa_file.sfa062,
           l_sfa161   LIKE sfa_file.sfa161
    DEFINE l_sfa03    LIKE sfa_file.sfa03
    DEFINE l_sfa063   LIKE sfa_file.sfa063
    DEFINE l_sfa26    LIKE sfa_file.sfa26
    DEFINE l_sfa27    LIKE sfa_file.sfa27
    DEFINE l_sfa28    LIKE sfa_file.sfa28
    DEFINE l_qty1     LIKE sfa_file.sfa062
    DEFINE l_sfl07    LIKE sfl_file.sfl07
    DEFINE p_cmd      LIKE type_file.chr1
    DEFINE p_sfl02    LIKE sfl_file.sfl02         #Add No.MOD-AA0184
    DEFINE p_sfl03    LIKE sfl_file.sfl03         #Add No.MOD-AA0184
    DEFINE p_sfl04    LIKE sfl_file.sfl04         #Add No.MOD-AA0184
    DEFINE p_sfl031   LIKE sfl_file.sfl031        #Add No.MOD-AA0184
    DEFINE p_sfl041   LIKE sfl_file.sfl041        #Add No.MOD-AA0184
    DEFINE p_sfl012   LIKE sfl_file.sfl012        #Add No.MOD-AA0184
    DEFINE p_sfl07    LIKE sfl_file.sfl07         #Add No.MOD-AA0184
    DEFINE p_sfl063   LIKE sfl_file.sfl063        #Add No.MOD-AA0184
    DEFINE l_qty2     LIKE sfb_file.sfb09         #No:MOD-930077 add
    DEFINE l_qty3     LIKE sfb_file.sfb09         #MOD-B10178 add
    DEFINE l_sfa100   LIKE sfa_file.sfa100        #No:MOD-930077 add
 
    LET g_errno = ' '
    #FUN-A60095(S)
    IF cl_null(p_sfl012) THEN  #制程段号
       LET p_sfl012 =' '
    END IF
    IF cl_null(p_sfl041) THEN  #製程序號
       LET p_sfl041 =0
    END IF
    #FUN-A60095(E)

    SELECT sfa062,sfa161,sfa06,sfa100 INTO l_sfa062,l_sfa161,l_sfa06,l_sfa100 FROM sfa_file       #No:MOD-930077 add sfa100,l_sfa100
     WHERE sfa01 = p_sfl02 AND sfa03 = p_sfl03
       AND sfa08 = p_sfl04 AND sfa12 = p_sfl031
       AND sfa012 = p_sfl012 AND sfa013=p_sfl041  #FUN-A60095
 
    #完工入库数量+再加工数量+F.Q.C 数量+报废数量
    SELECT sfb09+sfb10+sfb11+sfb12 INTO l_qty
     FROM sfb_file WHERE sfb01 = p_sfl02
 
    #替代码,被替代料号,替代率,发料误差允许率
    SELECT sfa26,sfa27,sfa28,sfa100 INTO l_sfa26,l_sfa27,l_sfa28,l_sfa100 FROM sfa_file    #No.MOD-930077 add sfa100
     WHERE sfa01 = p_sfl02 AND sfa03 = p_sfl03
       AND sfa08 = p_sfl04 AND sfa12 = p_sfl031
       AND sfa012 = p_sfl012 AND sfa013=p_sfl041  #FUN-A60095
     
    IF cl_null(l_sfa100) THEN LET l_sfa100 = 0 END IF   #No:MOD-930077 add 
    IF l_sfa26 MATCHES '[SUTZ]' THEN  #FUN-A20037 add 'Z' 
       LET l_sfa03 = l_sfa27
       SELECT sfa161 INTO l_sfa161 FROM sfa_file
        WHERE sfa01 = p_sfl02 AND sfa03 = l_sfa03
          AND sfa08 = p_sfl04 AND sfa12 = p_sfl031
          AND sfa27 = l_sfa27     #No.FUN-870051
          AND sfa012 = p_sfl012 AND sfa013=p_sfl041  #FUN-A60095
    ELSE
       LET l_sfa03 = p_sfl03
    ENd IF
 
    #SUM與此取替代料有關的所有料的發料量與報廢量
    SELECT SUM((sfa06+sfa062)/sfa28),SUM(sfa063/sfa28)
      INTO l_qty1,l_sfa063 FROM sfa_file
     WHERE sfa01 = p_sfl02 AND sfa27 = l_sfa03
       AND sfa08 = p_sfl04 AND sfa12 = p_sfl031
       AND sfa012 = p_sfl012 AND sfa013=p_sfl041  #FUN-A60095
    LET l_sfa063 = s_digqty(l_sfa063,p_sfl031)   #No.FUN-BB0086
 
    #SUM與此取替代料有關的所有料以KEY報廢量但未過帳數量
     SELECT SUM(sfl07/sfa28) INTO l_sfl07 FROM sfk_file,sfl_file,sfa_file
            WHERE sfa01 = p_sfl02 AND sfa27 = l_sfa03
              AND sfa08 = p_sfl04 AND sfa12 = p_sfl031
              AND sfa012 = p_sfl012 AND sfa013=p_sfl041  #FUN-A60095
              AND sfl03 = sfa03 AND sfk01 = sfl01
              AND sfl02 = sfa01 AND sfl04 = sfa08     #No.MOD-880029 add by liuxqa
              AND sfkconf != 'X' AND sfkpost = 'N'
        
     LET l_sfl07 = s_digqty(l_sfl07,p_sfl031)    #FUN-910088--add--
     IF cl_null(l_sfl07) THEN LET l_sfl07 =0 END IF    #No.MOD-880026 #本次报废数量
 
     IF p_cmd = 'u' THEN LET l_sfl07 = l_sfl07 - g_sfl_t.sfl07 END IF
 
    LET l_qty = l_qty * l_sfa161
 
    IF p_sfl07 > l_sfa06 + l_sfa062 - p_sfl063 THEN
       LET g_errno = 'asf-575'
    END IF
 
    IF g_sma.sma899 = 'N' THEN    #No:MOD-930077 add
       IF (p_sfl07/l_sfa28) > l_qty1 - l_qty - l_sfa063 - l_sfl07 THEN
          LET g_errno = 'asf-575'
       END IF
    ELSE
      LET l_qty2 = (l_qty1 - (p_sfl07/l_sfa28) - l_sfl07 - l_sfa063) / l_sfa161 * ((100+l_sfa100)/100)   #No:TQC-970019 modify
     #IF (l_qty2 - (l_qty/l_sfa161)) < 0 THEN      #MOD-B10178 mark
      LET l_qty3 = l_qty/l_sfa161                  #MOD-B10178 add
      IF (l_qty2 - l_qty3) < 0 THEN                #MOD-B10178 add
         LET g_errno = 'asf-575'
      END IF
    END IF
 
END FUNCTION
 
FUNCTION t670_b_askkey()
DEFINE l_wc2   LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    CONSTRUCT l_wc2 ON sfl02,sfl03,sfl04,sfl041,sfl031,sfl05,sfl06,
                       sfl063,sfl07,sfl13,sfl14,sfl15,
                       sfl10,sfl11,sfl12,sfl08,sfl09,
                       sflud01,sflud02,sflud03,sflud04,sflud05,
                       sflud06,sflud07,sflud08,sflud09,sflud10,
                       sflud11,sflud12,sflud13,sflud14,sflud15
            FROM s_sfl[1].sfl02,s_sfl[1].sfl03,s_sfl[1].sfl04,
                 s_sfl[1].sfl041,s_sfl[1].sfl031,s_sfl[1].sfl05,
                 s_sfl[1].sfl06,s_sfl[1].sfl063,s_sfl[1].sfl07,
                 s_sfl[1].sfl13,s_sfl[1].sfl14,s_sfl[1].sfl15,
                 s_sfl[1].sfl10,s_sfl[1].sfl11,s_sfl[1].sfl12,
                 s_sfl[1].sfl08,s_sfl[1].sfl09,
                 s_sfl[1].sflud01,s_sfl[1].sflud02,s_sfl[1].sflud03,
                 s_sfl[1].sflud04,s_sfl[1].sflud05,s_sfl[1].sflud06,
                 s_sfl[1].sflud07,s_sfl[1].sflud08,s_sfl[1].sflud09,
                 s_sfl[1].sflud10,s_sfl[1].sflud11,s_sfl[1].sflud12,
                 s_sfl[1].sflud13,s_sfl[1].sflud14,s_sfl[1].sflud15
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
    CALL t670_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t670_b_fill(p_wc2)              #BODY FILL UP
DEFINE    p_wc2   LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(200)
 
    LET g_sql = "SELECT sfl011,sfl02,sfl03,ima02,ima021,sfl012,sfl04,sfl041,sfl031,sfl05,sfl06,sfl063,",     #FUN-A60027 add sfl012 #CHI-C70016 add sfl011
                "sfl07,sfl13,sfl14,sfl15,sfl10,sfl11,sfl12,sfl08,azf03,sfl09, ",
                "sflud01,sflud02,sflud03,sflud04,sflud05,",
                "sflud06,sflud07,sflud08,sflud09,sflud10,",
                "sflud11,sflud12,sflud13,sflud14,sflud15", 
                " FROM sfl_file, OUTER ima_file,OUTER azf_file ",
                " WHERE sfl01 ='",g_sfk.sfk01,"'",  #單頭
                "   AND sfl_file.sfl03 = ima_file.ima01 AND sfl_file.sfl08=azf_file.azf01 AND azf_file.azf02='2' ",               
                "   AND ",p_wc2 CLIPPED, #單身
                #" ORDER BY sfl02"  #CHI-C70016
                " ORDER BY sfl011"  #CHI-C70016
 
    PREPARE t670_pb FROM g_sql
    DECLARE sfl_curs CURSOR FOR t670_pb
 
    CALL g_sfl.clear()
 
    LET g_cnt = 1
    FOREACH sfl_curs INTO g_sfl[g_cnt].*   #單身 ARRAY 填充
      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_sfl.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
   
    #FUN-B30170 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_sfk.sfk01,"'"
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
 
FUNCTION t670_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #FUN-B30170 add -----------begin-------------
   DIALOG ATTRIBUTE(UNBUFFERED)
      DISPLAY ARRAY g_sfl TO s_sfl.* ATTRIBUTE(COUNT=g_rec_b)
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()                   
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
     #--------------No:CHI-A80038 add
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG
     #--------------No:CHI-A80038 end
      ON ACTION first
         CALL t670_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t670_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t670_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t670_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t670_fetch('L')
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
         CALL t670_def_form()   #FUN-610006
         IF g_sfk.sfkconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_void,"")
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
##No.FUN-890050 on action產生雜發單 #MOD-C30035 mark
#No.FUN-890050 on action產生雜收單  #MOD-C30035
      ON ACTION gen_m_iss
         LET g_action_choice="gen_m_iss"
         EXIT DIALOG
##No.FUN-890050 on action維護雜發單 #MOD-C30035 mark
#No.FUN-890050 on action維護雜收單  #MOD-C30035
      ON ACTION m_iss
         LET g_action_choice="m_iss"
         EXIT DIALOG
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

        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG 
 
      AFTER DIALOG
         CONTINUE DIALOG
 
      &include "qry_string.4gl"
   END DIALOG
#   DISPLAY ARRAY g_sfl TO s_sfl.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
# 
#      BEFORE DISPLAY
#         CALL cl_navigator_setting( g_curs_index, g_row_count )
# 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
#      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
# 
#      ##########################################################################
#      # Standard 4ad ACTION
#      ##########################################################################
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
#     #--------------No:CHI-A80038 add
#      ON ACTION qry_lot
#         LET g_action_choice="qry_lot"
#         EXIT DISPLAY
#     #--------------No:CHI-A80038 end
#      ON ACTION first
#         CALL t670_fetch('F')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION previous
#         CALL t670_fetch('P')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION jump
#         CALL t670_fetch('/')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION next
#         CALL t670_fetch('N')
#         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#           IF g_rec_b != 0 THEN
#         CALL fgl_set_arr_curr(1)  ######add in 040505
#           END IF
#	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
# 
# 
#      ON ACTION last
#         CALL t670_fetch('L')
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
#         CALL t670_def_form()   #FUN-610006
#         IF g_sfk.sfkconf = 'X' THEN
#            LET g_void = 'Y'
#         ELSE
#            LET g_void = 'N'
#         END IF
#         CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_void,"")
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
#    #@ON ACTION 確認
#      ON ACTION confirm
#         LET g_action_choice="confirm"
#         EXIT DISPLAY
#    #@ON ACTION 取消確認
#      ON ACTION undo_confirm
#         LET g_action_choice="undo_confirm"
#         EXIT DISPLAY
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
##No.FUN-890050 on action產生雜發單
#      ON ACTION gen_m_iss
#         LET g_action_choice="gen_m_iss"
#         EXIT DISPLAY
##No.FUN-890050 on action維護雜發單
#      ON ACTION m_iss
#         LET g_action_choice="m_iss"
#         EXIT DISPLAY
#      ON ACTION accept
#         LET g_action_choice="detail"
#         LET l_ac = ARR_CURR()
#         EXIT DISPLAY
# 
#      ON ACTION cancel
#         LET INT_FLAG=FALSE 		#MOD-570244	mars
#         LET g_action_choice="exit"
#         EXIT DISPLAY
# 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE DISPLAY
# 
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
#
#        ON ACTION CONTROLS                                                                                                          
#           CALL cl_set_head_visible("","AUTO")                                                                                      
# 
#      ON ACTION related_document                #No.FUN-6B0079  相關文件
#         LET g_action_choice="related_document"          
#         EXIT DISPLAY 
# 
#      AFTER DISPLAY
#         CONTINUE DISPLAY
# 
#      &include "qry_string.4gl"
#   END DISPLAY
   #FUN-B30170 add ------------end-------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t670_s()       #過帳
   DEFINE  l_sfb39      LIKE  sfb_file.sfb39,
           l_sfb88      LIKE  sfb_file.sfb88,
           l_sfb02      LIKE  sfb_file.sfb02,
           l_time       LIKE type_file.chr8,
           l_type       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_n          LIKE type_file.num5           #No.FUN-680121 SMALLINT
   DEFINE  l_sfei       RECORD LIKE sfei_file.*       #FUN-B70074 
   IF s_shut(0) THEN RETURN END IF
   IF g_sfk.sfk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_sfk.* FROM sfk_file WHERE sfk01 = g_sfk.sfk01
   IF g_sfk.sfkconf = 'N' THEN CALL cl_err('','aba-100',0) RETURN END IF #FUN-660134
   IF g_sfk.sfkpost='Y' THEN RETURN END IF
   IF g_sfk.sfkconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660134
   IF g_sma.sma53 IS NOT NULL AND g_sfk.sfk02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
   CALL s_yp(g_sfk.sfk02) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      CALL cl_err(g_yy,'mfg6090',0) RETURN
   END IF
   IF NOT cl_confirm('mfg0176') THEN RETURN END IF
   DECLARE t670_s CURSOR WITH HOLD FOR
       SELECT * FROM sfl_file WHERE sfl01=g_sfk.sfk01
 
   LET g_success = 'Y'
   LET l_n = 0
 
   BEGIN WORK
 
    OPEN t670_cl USING g_sfk.sfk01
    IF STATUS THEN
       CALL cl_err3("sel","sfl_file",g_sfk.sfk01,"", STATUS,"","OPEN t670_cl",1)  #No.FUN-660128
       CLOSE t670_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t670_cl INTO g_sfk.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t670_cl ROLLBACK WORK RETURN
    END IF
 
   CALL s_showmsg_init()    #NO.FUN-710026
   FOREACH t670_s INTO b_sfl.*
      IF STATUS  THEN    
         CALL s_errmsg('','','foreach',STATUS,0)        #NO.FUN-710026
         LET g_success = 'N'                             #NO.FIN-710026
         EXIT FOREACH
      END IF
      IF g_success='N' THEN                                                                                                          
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                    
 
     #CALL t670_sfb01('a')
      CALL t670_sfb01('a',b_sfl.sfl02) #Mod No.MOD-AA0184
      IF NOT cl_null(g_errno)  THEN
        #CALL s_errmsg('','',g_sfl[l_ac].sfl02,g_errno,1)     #NO.FUN-710026
         CALL s_errmsg('','',b_sfl.sfl02,g_errno,1)     #NO.FUN-710026  #Mod No.MOD-AA0184
         LET g_success = 'N'                                  #NO.FUN-710026 
         EXIT FOREACH
      END IF
      #---> Add No.MOD-AA0184
      IF g_sfb02 != 11 THEN
          LET g_sfl_t.sfl07 = b_sfl.sfl07
          CALL t670_sfa_num('u',b_sfl.sfl02,b_sfl.sfl03,b_sfl.sfl04,
                            b_sfl.sfl031,b_sfl.sfl041,b_sfl.sfl012,
                            b_sfl.sfl07,b_sfl.sfl063
                           )   #check數量    #No.MOD-7A0088 modify
          IF NOT cl_null(g_errno)  THEN
             CALL s_errmsg('','',b_sfl.sfl02,g_errno,1)
             LET g_success = 'N'  
             EXIT FOREACH
          END IF
      END IF
      #---> End Add No.MOD-AA0184
 
      SELECT sfb39,sfb88,sfb02 INTO l_sfb39,l_sfb88,l_sfb02 FROM sfb_file
       WHERE sfb01 = b_sfl.sfl02
      IF l_sfb39 ='1' THEN
         LET l_type ='5'
      ELSE
         LET l_type ='0'
      END IF
      IF l_sfb02 !=11 THEN #若不是拆件式工單
          UPDATE sfa_file SET sfa063 = sfa063 + b_sfl.sfl07
           WHERE sfa01= b_sfl.sfl02 AND sfa03 = b_sfl.sfl03
             AND sfa08= b_sfl.sfl04 AND sfa12 = b_sfl.sfl031
             AND sfa012= b_sfl.sfl012 AND sfa013 = b_sfl.sfl041  #FUN-A60095
          IF SQLCA.SQLCODE THEN
              LET g_showmsg=b_sfl.sfl02,"/",b_sfl.sfl03,"/",b_sfl.sfl04,"/",b_sfl.sfl031              #NO.FUN-710026
              CALL s_errmsg('sfa01,sfa03,sfa08,sfa12',g_showmsg,'upd_sfa063',SQLCA.sqlcode,1)         #NO.FUN-710026
              LET g_success ='N'
              EXIT FOREACH
          END IF
      END IF
 
      SELECT ecb08 INTO g_ecb08 FROM ecb_file    #工作站
       WHERE ecb01 = b_sfl.sfl03 AND ecb02 = b_sfl.sfl04
        AND  ecb03 = b_sfl.sfl041
      IF g_ecb08 IS NULL THEN  LET g_ecb08 = ' ' END IF
      LET l_time = TIME
      INSERT INTO sfe_file(sfe01,sfe02,sfe03,sfe04,sfe05,sfe06,sfe07,sfe08,
                           sfe09,sfe10,sfe11,sfe12,sfe13,sfe14,sfe15,sfe16,
                           sfe17,sfe18,sfe19,sfe20,sfe21,sfe22,sfe23,sfe24,
                           sfe25,sfe26,sfe27,sfe28,sfe91,sfe92,sfe93,sfe94,
                           sfe95,sfe30,sfe31,sfe32,sfe33,sfe34,sfe35, #FUN-580029
                           sfeplant,sfelegal,sfe012,sfe013,sfe014,    #FUN-980008 add  FUN-A60095  #FUN-C70014 add sfe014
                           sfeud01,sfeud02,sfeud03,sfeud04,sfeud05,sfeud06,sfeud07,sfeud08,  #FUN-CB0043
                           sfeud09,sfeud10,sfeud11,sfeud12,sfeud13,sfeud14,sfeud15)  #FUN-CB0043
             VALUES (b_sfl.sfl02,g_sfk.sfk01,l_sfb88,
             g_sfk.sfk02,l_time,l_type,b_sfl.sfl03,' ',' ',' ',' ',' ',' ',
             b_sfl.sfl041,g_ecb08,b_sfl.sfl07,b_sfl.sfl031,
             0,0,0,0,0,0,g_prog,g_user,b_sfl.sfl08,'',0,'','','','','',       #FUN-B70074 將sfe28這個欄位的空改成默認值0
             b_sfl.sfl10,b_sfl.sfl11,b_sfl.sfl12,b_sfl.sfl13,b_sfl.sfl14,b_sfl.sfl15, #FUN-580029
             g_plant,g_legal,b_sfl.sfl012,b_sfl.sfl041,' ',     #FUN-980008 add  FUN-A60095   #FUN-C70014 add ' '
             b_sfl.sflud01,b_sfl.sflud02,b_sfl.sflud03,b_sfl.sflud04,b_sfl.sflud05,  #FUN-CB0043
             b_sfl.sflud06,b_sfl.sflud07,b_sfl.sflud08,b_sfl.sflud09,b_sfl.sflud10,  #FUN-CB0043
             b_sfl.sflud11,b_sfl.sflud12,b_sfl.sflud13,b_sfl.sflud14,b_sfl.sflud15)  #FUN-CB0043       
      IF SQLCA.sqlcode THEN
         LET g_showmsg=b_sfl.sfl03,"/",b_sfl.sfl04 ,"/",b_sfl.sfl041                 #NO.FUN-710026      
         CALL s_errmsg('ecb01,ecb02,ecb03',g_showmsg,'ins_sfe:',SQLCA.sqlcode,1)     #NO.FUN-710026
         LET g_success ='N'
         EXIT FOREACH
      #FUN-B70074-add-str--
      ELSE
         IF NOT s_industry('std') THEN
            INITIALIZE l_sfei.* TO NULL
            LET l_sfei.sfei02 = g_sfk.sfk01
            LET l_sfei.sfei28 = 0
            IF NOT s_ins_sfei(l_sfei.*,g_plant)  THEN
               LET g_success = 'N'
               EXIT FOREACH
            END IF
      END IF
      #FUN-B70074-add-end--
      END IF
      CALL t670_tlf_ins()
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','ins_tlf:',SQLCA.sqlcode,1)          #NO.FUN-710026
         LET g_success ='N'
         EXIT FOREACH
      END IF
      IF g_sma.sma115 = 'Y' THEN
         IF b_sfl.sfl12 != 0 OR b_sfl.sfl15 != 0 THEN
            CALL t670_update_du('s')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      LET l_n = l_n + 1
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
 
   IF g_success = 'Y' AND l_n > 0  THEN
       INSERT INTO tlm_file(tlm01,tlm02,tlm03,tlm04,tlm05,tlm06,  #No.MOD-470041
                            tlmplant,tlmlegal) #FUN-980008 add
             VALUES(g_sfk.sfk01,b_sfl.sfl02,
                    g_prog,g_today,l_time,g_user,
                    g_plant,g_legal) #FUN-980008 add
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','Insert tlm:',SQLCA.sqlcode,1)                                      #NO.FUN-710026    
         LET g_success ='N'
      END IF
   END IF
 
   IF g_success = 'Y'  THEN
      UPDATE sfk_file SET sfkpost='Y' WHERE sfk01=g_sfk.sfk01
      IF STATUS THEN 
         CALL s_errmsg('sfk01',g_sfk.sfk01,'upd-sfk',STATUS,1)              #NO.FUN-710026
      END IF
   END IF
   
   CALL s_showmsg()           #NO.FUN-710026
   IF g_success = 'Y'  THEN
      LET g_sfk.sfkpost='Y'
      COMMIT WORK
      CALL cl_flow_notify(g_sfk.sfk01,'S')
 
   ELSE
      LET g_sfk.sfkpost='N'
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_sfk.sfkpost
END FUNCTION
 
FUNCTION t670_w()       #過帳還原
   DEFINE  l_type       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
           l_n          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
           l_sfb02      LIKE sfb_file.sfb02
  DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*   #NO.FUN-8C0131 
  DEFINE l_sql   STRING                                    #NO.FUN-8C0131 
  DEFINE l_i     LIKE type_file.num5                       #NO.FUN-8C0131
 
   IF s_shut(0) THEN RETURN END IF
   IF g_sfk.sfk01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF

   SELECT * INTO g_sfk.* FROM sfk_file WHERE sfk01 = g_sfk.sfk01
   IF g_sfk.sfkpost='N' THEN CALL cl_err('','mfg0178',0) RETURN END IF
 
   IF g_sfk.sfkconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660134

#TQC-D40002--mark--str--
##FUN-D30065 ----------Begin-------------
#   #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
#   SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
#   IF g_ccz.ccz28  = '6' THEN
#      CALL cl_err('','apm-936',1)
#      RETURN
#   END IF
##FUN-D30065 ----------End---------------
#TQC-D40002--mark--end--
   IF g_sma.sma53 IS NOT NULL AND g_sfk.sfk02 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',0) RETURN
   END IF
 
   CALL s_yp(g_sfk.sfk02) RETURNING g_yy,g_mm
   IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
      CALL cl_err(g_yy,'mfg6090',0) RETURN
   END IF

   IF NOT cl_confirm('asf-663') THEN RETURN END IF
 
   DECLARE t670_w CURSOR WITH HOLD FOR
       SELECT * FROM sfl_file WHERE sfl01=g_sfk.sfk01
 
   LET g_success = 'Y'
   LET l_n = 0
 
   BEGIN WORK
 
   OPEN t670_cl USING g_sfk.sfk01
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)   
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH t670_cl INTO g_sfk.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err('lock sfb:',SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t670_cl ROLLBACK WORK RETURN
   END IF
 
   CALL s_showmsg_init()    #NO.FUN-710026
   FOREACH t670_w INTO b_sfl.*
      IF STATUS  THEN    
         CALL s_errmsg('','','w_foreach',STATUS,0)        #NO.FUN-710026
         LET g_success = 'N'                              #NO.FUN-710026  
         EXIT FOREACH END IF
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
 
      #CALL t670_sfb01('a')
       CALL t670_sfb01('a',b_sfl.sfl02)  #Mod No.MOD-AA0184
       IF NOT cl_null(g_errno)  THEN
          LET g_success = 'N'
         #CALL s_errmsg('','',g_sfl[l_ac].sfl02,g_errno,1)        #NO.FUN-710026
          CALL s_errmsg('','',b_sfl.sfl02,g_errno,1)        #NO.FUN-710026  #Mod No.MOD-AA0184
          EXIT FOREACH
       END IF
 
      SELECT sfb02 INTO l_sfb02 FROM sfb_file
       WHERE sfb01 = b_sfl.sfl02
      IF l_sfb02 != 11 THEN
          #備料檔資料還原
          UPDATE sfa_file SET sfa063 = sfa063 - b_sfl.sfl07
           WHERE sfa01= b_sfl.sfl02 AND sfa03 = b_sfl.sfl03
             AND sfa08= b_sfl.sfl04 AND sfa12 = b_sfl.sfl031
             AND sfa012= b_sfl.sfl012 AND sfa013 = b_sfl.sfl041  #FUN-A60095
          IF SQLCA.SQLCODE THEN
              LET g_showmsg=b_sfl.sfl02,"/",b_sfl.sfl03,"/",b_sfl.sfl04,"/",b_sfl.sfl031              #NO.FUN-710026
              CALL s_errmsg('sfa01,sfa03,sfa08,sfa12',g_showmsg,'upd_sfa063',SQLCA.sqlcode,1)         #NO.FUN-710026
              LET g_success ='N'
              CONTINUE FOREACH                                                                        #NO.FUN-710026   
          END IF
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
 
   IF g_success = 'Y'  THEN
#.....清除工單料帳歷史檔
      DELETE FROM sfe_file WHERE  sfe02=g_sfk.sfk01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('sfe02',g_sfk.sfk01,'del_sfe:',SQLCA.sqlcode,1)              #NO.FUN-710026    
         LET g_success ='N'
      #FUN-B70074-add-str--
      ELSE 
         IF NOT s_industry('std') THEN 
            IF NOT s_del_sfei(g_sfk.sfk01,'','') THEN 
               LET g_success ='N'
            END IF 
         END IF
      #FUN-B70074-add-end--
      END IF
   END IF
#..........................
   IF g_success = 'Y'  THEN
  ##NO.FUN-8C0131   add--begin   
            LET l_sql =  " SELECT  * FROM tlf_file ", 
                         " WHERE tlf03 = 40 ", 
                         "   AND tlf036 = '",g_sfk.sfk01,"'"
            DECLARE t670_u_tlf_c CURSOR FROM l_sql
            LET l_i = 0 
            CALL la_tlf.clear()
            FOREACH t670_u_tlf_c INTO g_tlf.*  
               LET l_i = l_i + 1
               LET la_tlf[l_i].* = g_tlf.*
            END FOREACH     

  ##NO.FUN-8C0131   add--end
      DELETE FROM tlf_file
       WHERE tlf03  = 40 AND tlf036 = g_sfk.sfk01
      IF SQLCA.sqlcode THEN
         LET g_showmsg=40,"/",g_sfk.sfk01                                            #NO.FUN-710026 
         CALL s_errmsg('tlf03,tlf036',g_showmsg,'del_tlf',SQLCA.sqlcode,1)           #NO.FUN-710026 
         LET g_success ='N'
      END IF
    ##NO.FUN-8C0131   add--begin
      FOR l_i = 1 TO la_tlf.getlength()
         LET g_tlf.* = la_tlf[l_i].*
         IF NOT s_untlf1('') THEN 
            LET g_success='N' RETURN
         END IF 
      END FOR       
  ##NO.FUN-8C0131   add--end 
      #---------------No:CHI-A80038 add
       SELECT ima918,ima921 INTO g_ima918,g_ima921
         FROM ima_file
        WHERE ima01 = b_sfl.sfl03
          AND imaacti = "Y"
       
       IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
          DELETE FROM tlfs_file
           WHERE tlfs01 = b_sfl.sfl03
             AND tlfs10 = b_sfl.sfl01
             AND tlfs11 = 0
       
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err('del tlfs',STATUS,0)
             LET g_success = 'N'
             RETURN
          END IF
       END IF
      #---------------No:CHI-A80038 end
      IF g_sma.sma115 = 'Y' THEN
         IF b_sfl.sfl12 != 0 OR b_sfl.sfl15 != 0 THEN
            CALL t670_update_du('t')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
#..........................
   IF g_success = 'Y'  THEN
      DELETE FROM tlm_file WHERE tlm01 = g_sfk.sfk01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('tlm01',g_sfk.sfk01,'Insert tlm:',SQLCA.sqlcode,1)             #NO.FUN-710026
         LET g_success ='N'
      END IF
   END IF
#..過帳碼還原為N
   IF g_success = 'Y'  THEN
      UPDATE sfk_file SET sfkpost='N' WHERE sfk01=g_sfk.sfk01
        IF STATUS THEN 
           CALl s_errmsg('sfk01',g_sfk.sfk01,'upd_sfk_w',STATUS,1)              #NO.FUN-710026  
           LET g_success ='N'
        END IF
   END IF
   CALL s_showmsg()           #NO.FUN-710026 
   IF g_success = 'Y'  THEN
      LET g_sfk.sfkpost='N'
      COMMIT WORK
   ELSE
      LET g_sfk.sfkpost='Y'
      ROLLBACK WORK
   END IF
   DISPLAY BY NAME g_sfk.sfkpost
 
END FUNCTION
 
FUNCTION t670_tlf_ins()
 
#DEFINE l_ima262  LIKE ima_file.ima262,
DEFINE l_avl_stk LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
       l_ima25   LIKE ima_file.ima25,
       l_ima55   LIKE ima_file.ima55,
       l_sta     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
       l_ima86   LIKE ima_file.ima86,
       l_ecb08   LIKE ecb_file.ecb08,
       l_sfb     RECORD LIKE sfb_file.*
 
#   CALL s_getima(b_sfl.sfl03) RETURNING l_ima262,l_ima25,l_ima55,l_ima86
    CALL s_getima(b_sfl.sfl03) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86
    SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=b_sfl.sfl02
 
    LET g_tlf.tlf01=b_sfl.sfl03      #異動料件編號
    LET g_tlf.tlf02=60               #資料來源為工單
    LET g_tlf.tlf020=g_plant
    LET g_tlf.tlf021=' '             #倉庫別
    LET g_tlf.tlf022=' '             #儲位別
    LET g_tlf.tlf023=' '             #批號
    LET g_tlf.tlf024=' '             #異動後庫存數量(同料件主檔之可用量)
    LET g_tlf.tlf025=' '             #庫存單位(同料件之庫存單位)
    LET g_tlf.tlf026=b_sfl.sfl02     #單据編號(工單單號)
    LET g_tlf.tlf027=''
    LET g_tlf.tlf03=40               #資料目的為
    LET g_tlf.tlf031=' '             #倉庫別
    LET g_tlf.tlf030=g_plant
    LET g_tlf.tlf032=' '             #儲位別
    LET g_tlf.tlf033=' '             #入庫批號
    LET g_tlf.tlf034=' '             #異動後庫存數量(同料件主檔之可用量)
    LET g_tlf.tlf035=' '             #庫存單位(同料件之庫存單位)
    LET g_tlf.tlf036=g_sfk.sfk01     #參考號碼
    LET g_tlf.tlf037=0               #項次
    LET g_tlf.tlf04= g_ecb08         #工作站
    LET g_tlf.tlf05= b_sfl.sfl04     #製程編號
    LET g_tlf.tlf06= g_sfk.sfk02     #報廢日期
    LET g_tlf.tlf07= TODAY           #異動資料產生日期
    LET g_tlf.tlf08=TIME             #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user           #產生人
    LET g_tlf.tlf10=b_sfl.sfl07      #數量
    LET g_tlf.tlf11=b_sfl.sfl031     #單位
    LET g_tlf.tlf12=b_sfl.sfl033     #發料/庫存轉換率
    #異動命令代號
    LET g_tlf.tlf13=g_prog
    LET g_tlf.tlf14=b_sfl.sfl08      #異動原因
    LET g_tlf.tlf15=b_sfl.sfl09      #借方會計科目
    LET g_tlf.tlf16=l_sfb.sfb03      #貸方會計科目
    LET g_tlf.tlf17=' '              #非庫存性料件編號
    CALL s_imaQOH(b_sfl.sfl03)
         RETURNING g_tlf.tlf18       #異動後總庫存量
    LET g_tlf.tlf19= ' '             #異動廠商/客戶編號
    LET g_tlf.tlf20= l_sfb.sfb27     #專案號碼project no.
    LET g_tlf.tlf61= l_ima86
    LET g_tlf.tlf62= b_sfl.sfl02     #單据編號(工單單號)
    LET g_tlf.tlf905= g_sfk.sfk01    #單据編號(報廢單號)
    LET g_tlf.tlf906= 0              #單据項次
    LET g_tlf.tlf64 = l_sfb.sfb97    #手冊編號 no.A050
    LET g_tlf.tlf930 = l_sfb.sfb98   #FUN-670103
    CALL s_tlf(1,0)
END FUNCTION
 
FUNCTION t670_out()
    DEFINE
        l_sfl           RECORD LIKE sfl_file.*,
        l_ima02         LIKE ima_file.ima02,
        l_ima021        LIKE ima_file.ima021,
        l_azf03         LIKE azf_file.azf03,
        l_i             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_name          LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
        l_za05          LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)#
        l_sfl04         STRING,                                                 
        l_aag02         LIKE aag_file.aag02    
    IF g_wc2 IS NULL THEN
       CALL cl_err('','9057',0) RETURN END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog #No.FUN-760085
    LET g_sql="SELECT sfl_file.*,ima02,ima021,azf03  FROM sfl_file,",
              "OUTER ima_file,OUTER azf_file ",
              " WHERE sfl01='",g_sfk.sfk01 CLIPPED,"' ",
              "   AND sfl_file.sfl03=ima_file.ima01 AND sfl_file.sfl08 = azf_file.azf01 AND azf_file.azf02 = '2' "                 
    PREPARE t670_p1 FROM g_sql                       # RUNTIME 編譯
    DECLARE t670_co                                  # SCROLL CURSOR
        CURSOR FOR t670_p1
 
    CALL cl_del_data(l_table)
    FOREACH t670_co INTO l_sfl.*,l_ima02,l_ima021,l_azf03
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)  
            EXIT FOREACH
            END IF
        SELECT aag02 INTO l_aag02                                           
               FROM aag_file WHERE aag01 = sr.sfl09                           
                             AND aag00 = g_bookno1           #No.FUN-730057 
        LET l_sfl04 = l_sfl.sfl04,' ',l_sfl.sfl041 USING '####'     
        EXECUTE insert_prep USING g_sfk.sfk01,g_sfk.sfk02,g_sfk.sfk03,
                                  l_sfl.sfl02,l_sfl.sfl03,l_sfl.sfl04,
                                  l_sfl.sfl041,l_sfl.sfl05,l_sfl.sfl06,
                                  l_sfl.sfl063,l_sfl.sfl07,l_ima02,l_ima021,
                                  l_sfl.sfl031,l_azf03,l_sfl.sfl09,l_aag02
    END FOREACH
 
 
    CLOSE t670_co
    ERROR ""
    IF g_zz05 = 'Y' THEN                                                       
       CALL cl_wcchp(g_wc,'sfk01,sfk02,sfk03')                         
            RETURNING g_str                                                    
    END IF                                                                     
    LET l_sql = "SELECT * FROM ", g_cr_db_str CLIPPED, l_table CLIPPED         
    CALL cl_prt_cs3('asft670','asft670',l_sql,g_str)      
END FUNCTION
 
#FUNCTION t670_x()       #CHI-D20010
FUNCTION t670_x(p_type)  #CHI-D20010
DEFINE l_flag  LIKE type_file.chr1  #CHI-D20010
DEFINE p_type  LIKE type_file.chr1  #CHI-D20010
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_sfk.sfk01) THEN CALL cl_err('',-400,0) RETURN END IF   #MOD-660086 add
 
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_sfk.sfkconf ='X' THEN RETURN END IF
   ELSE
      IF g_sfk.sfkconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t670_cl USING g_sfk.sfk01
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t670_cl INTO g_sfk.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sfk.sfk01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t670_cl ROLLBACK WORK RETURN
   END IF
   IF cl_null(g_sfk.sfk01) THEN CALL cl_err('',-400,0) RETURN END IF
   #-->確認不可作廢
   IF g_sfk.sfkconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF #FUN-660134
   IF g_sfk.sfkpost = 'Y' THEN CALL cl_err('','afa-101',0) RETURN END IF #FUN-660134
   IF g_sfk.sfkconf = 'X' THEN  LET l_flag = 'X' ELSE LET l_flag = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_sfk.sfkconf)   THEN #FUN-660134  #CHI-D20010
   IF cl_void(0,0,l_flag)   THEN #FUN-660134         #CHI-D20010
        LET g_chr=g_sfk.sfkconf #FUN-660134
       #IF g_sfk.sfkconf='N' THEN #FUN-660134   #CHI-D20010
        IF p_type=1 THEN #FUN-660134            #CHI-D20010
            LET g_sfk.sfkconf='X' #FUN-660134
        ELSE
            LET g_sfk.sfkconf='N' #FUN-660134
        END IF
        UPDATE sfk_file
            SET sfkconf=g_sfk.sfkconf,  #FUN-660134
                sfkmodu=g_user,
                sfkdate=g_today
            WHERE sfk01  =g_sfk.sfk01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err(g_sfk.sfkconf,SQLCA.sqlcode,0) #FUN-660134   #No.FUN-660128
            CALL cl_err3("upd","sfk_file",g_sfk.sfk01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660128
            LET g_sfk.sfkconf=g_chr #FUN-660134
        END IF
        DISPLAY BY NAME g_sfk.sfkconf #FUN-660134
   END IF
 
   CLOSE t670_cl
   COMMIT WORK
   CALL cl_flow_notify(g_sfk.sfk01,'V')
 
END FUNCTION
 
FUNCTION t670_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   l_sfb93   LIKE sfb_file.sfb93         #No.MOD-910122
 
    CALL cl_set_comp_entry("sfl10,sfl11,sfl12,sfl13,sfl14,sfl15",TRUE)
 
END FUNCTION
 
FUNCTION t670_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE   l_sfb93   LIKE sfb_file.sfb93         #No.MOD-910122
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("sfl13,sfl14,sfl15",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("sfl13",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("sfl14,sfl11",FALSE)
   END IF
   
END FUNCTION
 
FUNCTION t670_set_required()
   #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
   IF g_ima906 = '3' THEN
      #CALL cl_set_comp_required("sfl13,sfl14,sfl15,sfl10,sfl11,sfl12",TRUE)
      CALL cl_set_comp_required("sfl13,sfl15,sfl10,sfl12",TRUE)
   END IF
   #單位不同,轉換率,數量必KEY
   IF NOT cl_null(g_sfl[l_ac].sfl10) THEN
      CALL cl_set_comp_required("sfl12",TRUE)
   END IF
   IF NOT cl_null(g_sfl[l_ac].sfl13) THEN
      CALL cl_set_comp_required("sfl15",TRUE)
   END IF
END FUNCTION
 
FUNCTION t670_set_no_required()
 
  CALL cl_set_comp_required("sfl13,sfl14,sfl15,sfl10,sfl11,sfl12",FALSE)
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t670_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima63  LIKE ima_file.ima63,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac       #No.FUN-680121 DECIMAL(16,8)
 
    LET l_item = g_sfl[l_ac].sfl03
 
    SELECT ima63,ima906,ima907
      INTO l_ima63,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',l_ima63,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
 
    LET l_unit1 = l_ima63
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF p_cmd = 'a' THEN
       LET g_sfl[l_ac].sfl13=l_unit2
       LET g_sfl[l_ac].sfl14=l_fac2
       LET g_sfl[l_ac].sfl15=l_qty2
       LET g_sfl[l_ac].sfl10=l_unit1
       LET g_sfl[l_ac].sfl11=l_fac1
       LET g_sfl[l_ac].sfl12=l_qty1
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t670_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE sfl_file.sfl14,
            l_qty2   LIKE sfl_file.sfl15,
            l_fac1   LIKE sfl_file.sfl11,
            l_qty1   LIKE sfl_file.sfl12,
            l_factor LIKE ima_file.ima31_fac,        #No.FUN-680121 DECIMAL(16,8)
            l_ima63  LIKE ima_file.ima63,            #MOD-C60012 add,
            l_ima25  LIKE ima_file.ima25             #MOD-C60012 add
 
    IF g_sma.sma115='N' THEN RETURN END IF
   #SELECT ima63 INTO l_ima63                             #MOD-C60012 mark
    SELECT ima25,ima63 INTO l_ima25,l_ima63               #MOD-C60012 add
      FROM ima_file WHERE ima01=g_sfl[l_ac].sfl03
    LET l_fac2=g_sfl[l_ac].sfl14
    LET l_qty2=g_sfl[l_ac].sfl15
    LET l_fac1=g_sfl[l_ac].sfl11
    LET l_qty1=g_sfl[l_ac].sfl12
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_sfl[l_ac].sfl031=g_sfl[l_ac].sfl10
                   LET g_sfl[l_ac].sfl07=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_sfl[l_ac].sfl031=l_ima63
                   LET g_sfl[l_ac].sfl07=l_tot
                   LET g_sfl[l_ac].sfl07 = s_digqty(g_sfl[l_ac].sfl07,g_sfl[l_ac].sfl031)   #FUN-910088--add--
          WHEN '3' LET g_sfl[l_ac].sfl031=g_sfl[l_ac].sfl10
                   LET g_sfl[l_ac].sfl07=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_sfl[l_ac].sfl14=l_qty1/l_qty2
                   ELSE
                      LET g_sfl[l_ac].sfl14=0
                   END IF
       END CASE
    END IF
 
    LET g_factor = 1
   #CALL s_umfchk(g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl031,l_ima63)  #MOD-C60012 mark
    CALL s_umfchk(g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl031,l_ima25)  #MOD-C60012 add
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF

    LET g_sfl033 = g_factor       #MOD-C60012 add 
END FUNCTION
#MOD-C60012 str add-----
FUNCTION t670_chk_sfl033()
  DEFINE l_ima25 LIKE ima_file.ima25

    SELECT ima25 INTO l_ima25
      FROM ima_file WHERE ima01=g_sfl[l_ac].sfl03

    LET g_sfl033 = 1
    CALL s_umfchk(g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl031,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_sfl033 = 1
    END IF

END FUNCTION
#MOD-C60012 end add----- 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t670_du_data_to_correct()
 
   IF cl_null(g_sfl[l_ac].sfl10) THEN
      LET g_sfl[l_ac].sfl11 = NULL
      LET g_sfl[l_ac].sfl12 = NULL
   END IF
 
   IF cl_null(g_sfl[l_ac].sfl13) THEN
      LET g_sfl[l_ac].sfl14 = NULL
      LET g_sfl[l_ac].sfl15 = NULL
   END IF
 
   DISPLAY BY NAME g_sfl[l_ac].sfl11
   DISPLAY BY NAME g_sfl[l_ac].sfl12
   DISPLAY BY NAME g_sfl[l_ac].sfl14
   DISPLAY BY NAME g_sfl[l_ac].sfl15
 
END FUNCTION
 
FUNCTION t670_check_inventory_qty(p_cmd)     #No.MOD-7A0088 modify
DEFINE l_sfa12    LIKE sfa_file.sfa12
DEFINE l_sfa13    LIKE sfa_file.sfa13
DEFINE p_cmd      LIKE type_file.chr1        #No.MOD-7A0088 add
   LET g_errno = ''
   IF NOT cl_null(g_sfl[l_ac].sfl031) THEN
      CALL t670_gfe01('a')
      IF NOT cl_null(g_errno)  THEN
         CALL cl_err(g_sfl[l_ac].sfl031,g_errno,0)
         LET g_sfl[l_ac].sfl031=g_sfl_t.sfl031
         RETURN 1,l_sfa13
      END IF
     #IF g_sfb02[l_ac] != 11 THEN #若不是拆件式工單,則需check工單備料檔
      IF g_sfb02 != 11 THEN #若不是拆件式工單,則需check工單備料檔 #Mod No.MOD-AA0184
         SELECT sfa12,sfa13 INTO l_sfa12,l_sfa13 FROM sfa_file
          WHERE sfa01 = g_sfl[l_ac].sfl02 AND sfa03=g_sfl[l_ac].sfl03
            AND sfa08 = g_sfl[l_ac].sfl04 AND sfa12=g_sfl[l_ac].sfl031
            AND sfa012 = g_sfl[l_ac].sfl012 AND sfa013=g_sfl[l_ac].sfl041  #FUN-A60095
         IF STATUS  THEN
            CALL cl_err3("sel","sfa_file",g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl03,'asf-814',"","sel_sfa",1)  #No.FUN-660128
            LET g_sfl[l_ac].sfl031=g_sfl_t.sfl031
            RETURN 1,l_sfa13
         END IF
         IF cl_null(l_sfa13)  THEN LET l_sfa13 = 1  END IF
         CALL t670_sfa('a')
         IF NOT cl_null(g_errno)  THEN
            CALL cl_err(g_sfl[l_ac].sfl031,g_errno,0)
            LET g_sfl[l_ac].sfl031=g_sfl_t.sfl031
            LET g_sfl[l_ac].sfl05 =g_sfl_t.sfl05
            LET g_sfl[l_ac].sfl06 =g_sfl_t.sfl06
            LET g_sfl[l_ac].sfl063=g_sfl_t.sfl063
            RETURN 1,l_sfa13
         END IF
         LET l_sfa13 = g_ima63_fac[l_ac] #發料單位/庫存單位換算率
      END IF
   END IF
   IF NOT cl_null(g_sfl[l_ac].sfl07) THEN
     #IF g_sfb02[l_ac] != 11 THEN
      IF g_sfb02 != 11 THEN  #Mod No.MOD-AA0184
         #Mod No.MOD-AA0184
         #CALL t670_sfa_num(p_cmd)   #check數量    #No.MOD-7A0088 modify
          CALL t670_sfa_num(p_cmd,g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl04,
                            g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl041,g_sfl[l_ac].sfl012,
                            g_sfl[l_ac].sfl07,g_sfl[l_ac].sfl063
                           )   #check數量    #No.MOD-7A0088 modify
         #End Mod No.MOD-AA0184
      END IF
      IF NOT cl_null(g_errno)  THEN
         CALL cl_err(g_sfl[l_ac].sfl07,g_errno,0)
         LET g_sfl[l_ac].sfl07=g_sfl_t.sfl07
         RETURN 1,l_sfa13
      END IF
      IF g_sfl[l_ac].sfl07 <= 0 THEN
         CALL cl_err(g_sfl[l_ac].sfl07,'asf-991',1)
         RETURN 1,l_sfa13
      END IF
   END IF
   RETURN 0,l_sfa13
END FUNCTION
 
FUNCTION t670_update_du(p_type)
DEFINE l_ima63   LIKE ima_file.ima63,
       u_type    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
       p_type    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
   IF g_sma.sma115 = 'N' THEN RETURN END IF
 
   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    WHERE ima01 = b_sfl.sfl03
   SELECT ima63 INTO l_ima63 FROM ima_file
    WHERE ima01 = b_sfl.sfl03
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(b_sfl.sfl13) THEN
         IF p_type = 's' THEN
            IF NOT cl_null(b_sfl.sfl15) AND b_sfl.sfl15 <> 0 THEN
               CALL t670_tlff('','','',l_ima63,
                              b_sfl.sfl15,b_sfl.sfl13,b_sfl.sfl14,'2')
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF NOT cl_null(b_sfl.sfl10) THEN
         IF p_type = 's' THEN
            IF NOT cl_null(b_sfl.sfl12) AND b_sfl.sfl12 <> 0 THEN
               CALL t670_tlff('','','',l_ima63,
                           b_sfl.sfl12,b_sfl.sfl10,b_sfl.sfl11,'1')
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF p_type = 't' THEN
         CALL t670_tlff_w()
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(b_sfl.sfl13) THEN
         IF p_type = 's' THEN
            IF NOT cl_null(b_sfl.sfl15) AND b_sfl.sfl15 <> 0 THEN
               CALL t670_tlff('','','',l_ima63,
                              b_sfl.sfl15,b_sfl.sfl13,b_sfl.sfl14,'2')
               IF g_success='N' THEN RETURN END IF
            END IF
         END IF
      END IF
      IF p_type = 't' THEN
         CALL t670_tlff_w()
         IF g_success='N' THEN RETURN END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t670_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_uom,p_factor,
                   p_flag)
DEFINE
   l_sfb      RECORD LIKE sfb_file.*,
#  l_ima262   LIKE ima_file.ima262,
   l_avl_stk  LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
   l_ima25    LIKE ima_file.ima63,
   l_ima55    LIKE ima_file.ima55,
   l_ima86    LIKE ima_file.ima86,
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位
   p_lot      LIKE img_file.img04,     	 ##批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   p_flag     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
   g_cnt      LIKE type_file.num5           #No.FUN-680121 SMALLINT
 
#  CALL s_getima(b_sfl.sfl03) RETURNING l_ima262,l_ima25,l_ima55,l_ima86
   CALL s_getima(b_sfl.sfl03) RETURNING l_avl_stk,l_ima25,l_ima55,l_ima86
   SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=b_sfl.sfl02
 
   IF cl_null(p_ware) THEN LET p_ware=' ' END IF
   IF cl_null(p_loca) THEN LET p_loca=' ' END IF
   IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
   IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
   IF p_uom IS NULL THEN
      CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
   END IF
   INITIALIZE g_tlff.* TO NULL
 
    LET g_tlff.tlff01=b_sfl.sfl03      #異動料件編號
    LET g_tlff.tlff02=60               #資料來源為工單
    LET g_tlff.tlff020=g_plant
    LET g_tlff.tlff021=' '             #倉庫別
    LET g_tlff.tlff022=' '             #儲位別
    LET g_tlff.tlff023=' '             #批號
    LET g_tlff.tlff024=' '             #異動後庫存數量(同料件主檔之可用量)
    LET g_tlff.tlff025=' '             #庫存單位(同料件之庫存單位)
    LET g_tlff.tlff026=b_sfl.sfl02     #單据編號(工單單號)
    LET g_tlff.tlff027=''
    LET g_tlff.tlff03=40               #資料目的為
    LET g_tlff.tlff031=' '             #倉庫別
    LET g_tlff.tlff030=g_plant
    LET g_tlff.tlff032=' '             #儲位別
    LET g_tlff.tlff033=' '             #入庫批號
    LET g_tlff.tlff034=' '             #異動後庫存數量(同料件主檔之可用量)
    LET g_tlff.tlff035=' '             #庫存單位(同料件之庫存單位)
    LET g_tlff.tlff036=g_sfk.sfk01     #參考號碼
    LET g_tlff.tlff037=0               #項次
    LET g_tlff.tlff04= g_ecb08         #工作站
    LET g_tlff.tlff05= b_sfl.sfl04     #製程編號
    LET g_tlff.tlff06= g_sfk.sfk02     #報廢日期
    LET g_tlff.tlff07= TODAY           #異動資料產生日期
    LET g_tlff.tlff08=TIME             #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user           #產生人
    LET g_tlff.tlff10=p_qty            #數量
    LET g_tlff.tlff11=p_uom            #單位
    LET g_tlff.tlff12=p_factor         #發料/庫存轉換率
    #異動命令代號
    LET g_tlff.tlff13=g_prog
    LET g_tlff.tlff14=b_sfl.sfl08      #異動原因
    LET g_tlff.tlff15=b_sfl.sfl09      #借方會計科目
    LET g_tlff.tlff16=l_sfb.sfb03      #貸方會計科目
    LET g_tlff.tlff17=' '              #非庫存性料件編號
    CALL s_imaQOH(b_sfl.sfl03)
         RETURNING g_tlff.tlff18       #異動後總庫存量
    LET g_tlff.tlff19= ' '             #異動廠商/客戶編號
    LET g_tlff.tlff20= l_sfb.sfb27     #專案號碼project no.
    LET g_tlff.tlff61= l_ima86
    LET g_tlff.tlff62= b_sfl.sfl02     #單据編號(工單單號)
    LET g_tlff.tlff905= g_sfk.sfk01    #單据編號(報廢單號)
    LET g_tlff.tlff906= 0              #單据項次
    LET g_tlff.tlff64 = l_sfb.sfb97    #手冊編號 no.A050
    LET g_tlff.tlff930 = l_sfb.sfb98   #FUN-670103
   IF cl_null(b_sfl.sfl15) OR b_sfl.sfl15=0 THEN
      CALL s_tlff(p_flag,NULL)
   ELSE
      CALL s_tlff(p_flag,b_sfl.sfl13)
   END IF
END FUNCTION
 
FUNCTION t670_tlff_w()
 
    MESSAGE "d_tlff!"
    CALL ui.Interface.refresh()
 
    DELETE FROM tlff_file
     WHERE tlff03  = 40 AND tlff036 = g_sfk.sfk01
 
    IF STATUS THEN
       CALL cl_err3("del","tlff_file",g_sfk.sfk01,"",STATUS,"","del tlff",1)  #No.FUN-660128
       LET g_success='N' RETURN
    END IF
END FUNCTION
 
FUNCTION t670_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("sfl13,sfl15,sfl10,sfl12",FALSE)
      CALL cl_set_comp_visible("sfl07,sfl031",TRUE)
   ELSE
      CALL cl_set_comp_visible("sfl13,sfl15,sfl10,sfl12",TRUE)
      CALL cl_set_comp_visible("sfl07,sfl031",FALSE)
   END IF
   CALL cl_set_comp_visible("sfl14,sfl11",FALSE)
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("sfl13",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("sfl15",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("sfl10",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("sfl12",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("sfl13",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("sfl15",g_msg CLIPPED)
      CALL cl_getmsg('asm-316',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("sfl10",g_msg CLIPPED)
      CALL cl_getmsg('asm-320',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("sfl12",g_msg CLIPPED)
   END IF
   #TQC-C80160----add----begin
   CALL cl_set_comp_visible("page2",g_sma.sma95='Y')
   CALL cl_set_act_visible("modi_lot,qry_lot",g_sma.sma95='Y')
   #TQC-C80160----add----end
   IF g_aza.aza115 ='Y' THEN                   #TQC-D20042 add 
       CALL cl_set_comp_required('sfl08',TRUE) #TQC-D20042 add
    END IF 
END FUNCTION
 
FUNCTION t670_y_chk()
DEFINE l_cnt LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE l_rvbs06      LIKE rvbs_file.rvbs06  #No:CHI-A80038 add

#CHI-C30107 ------------ add ------------ begin
   IF g_sfk.sfkconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF

   IF g_sfk.sfkconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
#CHI-C30107 ------------ add ----------- end
   IF NOT cl_confirm('axm-108') THEN RETURN END IF  #CHI-C30106
   IF cl_null(g_sfk.sfk01) THEN 
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN 
   END IF
   LET g_success = 'Y'
 
   SELECT * INTO g_sfk.* FROM sfk_file WHERE sfk01 = g_sfk.sfk01
   IF g_sfk.sfkconf='Y' THEN
      LET g_success = 'N'
      CALL cl_err('','9023',0)
      RETURN
   END IF
 
   IF g_sfk.sfkconf = 'X' THEN
      LET g_success = 'N'
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM sfk_file
      WHERE sfk01= g_sfk.sfk01
   IF l_cnt = 0 THEN
      LET g_success = 'N'
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
  #------------------------No:CHI-A80038 add
   DECLARE t670_y_chk_c CURSOR FOR SELECT * FROM sfl_file
                                   WHERE sfl01=g_sfk.sfk01
   FOREACH t670_y_chk_c INTO b_sfl.*
      SELECT ima918,ima921 INTO g_ima918,g_ima921 
        FROM ima_file
       WHERE ima01 = b_sfl.sfl03
         AND imaacti = "Y"
      
      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
            LET l_rvbs06 = 0
            SELECT SUM(rvbs06) INTO l_rvbs06
              FROM rvbs_file
             WHERE rvbs00 = g_prog
               AND rvbs01 = g_sfk.sfk01
               AND rvbs021 = b_sfl.sfl03
               AND rvbs02 = 0
               AND rvbs13 = 0
               AND rvbs09 = -1
         
         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF
         
         IF b_sfl.sfl07 <> l_rvbs06 THEN
            LET g_success = "N"
            CALL cl_err(b_sfl.sfl03,"aim-011",1)
            RETURN
         END IF
      END IF
      #FUN-CB0087--add--str--
      IF g_aza.aza115='Y' AND cl_null(b_sfl.sfl08) THEN
         CALL cl_err('',"aim-888",1)
         LET g_success = "N"
         RETURN
      END IF
      #FUN-CB0087--add--end--
   END FOREACH
  #------------------------No:CHI-A80038 
 
   IF g_success = 'N' THEN RETURN END IF
END FUNCTION
 
FUNCTION t670_y_upd()
  #IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30106 mark
   LET g_success = 'Y'
   BEGIN WORK
 
   OPEN t670_cl USING g_sfk.sfk01
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t670_cl INTO g_sfk.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_sfk.sfk01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t670_cl 
       ROLLBACK WORK 
       RETURN
   END IF
   CLOSE t670_cl
   UPDATE sfk_file SET sfkconf = 'Y' WHERE sfk01 = g_sfk.sfk01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","sfk_file",g_sfk.sfk01,"",STATUS,"","upd sfkconf",1)  #No.FUN-660128
      LET g_success = 'N'
   END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      LET g_sfk.sfkconf='Y'
      CALL cl_flow_notify(g_sfk.sfk01,'Y')
   ELSE
      ROLLBACK WORK
      LET g_sfk.sfkconf='N'
   END IF
   DISPLAY BY NAME g_sfk.sfkconf
   IF g_sfk.sfkconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t670_z()
DEFINE l_cnt     LIKE type_file.num5   #Add No:MOD-B20114

   IF cl_null(g_sfk.sfk01) THEN CALL cl_err('',-400,0) RETURN END IF
   SELECT * INTO g_sfk.* FROM sfk_file WHERE sfk01 = g_sfk.sfk01   
   IF g_sfk.sfkconf='N' THEN RETURN END IF
   IF g_sfk.sfkconf='X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_sfk.sfkpost='Y' THEN
      CALL cl_err('sfkconf=Y:','afa-101',0)
      RETURN
   END IF
   #Add No:MOD-B20114
   #已产生杂收单，不允许取消审核
   SELECT COUNT(*) INTO l_cnt FROM ina_file
    WHERE ina10 = g_sfk.sfk01
   IF l_cnt > 0 THEN
      CALL cl_err(g_sfk.sfk01,'asf-126',0)
      RETURN
   END IF
   #End Add No:MOD-B20114
 
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
   OPEN t670_cl USING g_sfk.sfk01
   IF STATUS THEN
      CALL cl_err("OPEN t670_cl:", STATUS, 1)
      CLOSE t670_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t670_cl INTO g_sfk.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_sfk.sfk01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t670_cl 
      ROLLBACK WORK 
      RETURN
   END IF
   CLOSE t670_cl
   LET g_success = 'Y'
   UPDATE sfk_file SET sfkconf = 'N' WHERE sfk01 = g_sfk.sfk01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
      LET g_success = 'N' 
   END IF
   IF g_success = 'Y' THEN
      LET g_sfk.sfkconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_sfk.sfkconf
   ELSE
      LET g_sfk.sfkconf='Y'
      ROLLBACK WORK
   END IF
   IF g_sfk.sfkconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_sfk.sfkconf,"",g_sfk.sfkpost,"",g_chr,"")
END FUNCTION
 
FUNCTION t670_b_move_to()
   LET g_sfl[l_ac].sfl011 = b_sfl.sfl011     #CHI-C70016
   LET g_sfl[l_ac].sfl02  = b_sfl.sfl02 
   LET g_sfl[l_ac].sfl03  = b_sfl.sfl03 
   LET g_sfl[l_ac].sfl012 = b_sfl.sfl012     #FUN-A60027 add 
   LET g_sfl[l_ac].sfl04  = b_sfl.sfl04 
   LET g_sfl[l_ac].sfl041 = b_sfl.sfl041
   LET g_sfl[l_ac].sfl031 = b_sfl.sfl031
   LET g_sfl[l_ac].sfl05  = b_sfl.sfl05 
   LET g_sfl[l_ac].sfl06  = b_sfl.sfl06 
   LET g_sfl[l_ac].sfl063 = b_sfl.sfl063
   LET g_sfl[l_ac].sfl07  = b_sfl.sfl07 
   LET g_sfl[l_ac].sfl13  = b_sfl.sfl13 
   LET g_sfl[l_ac].sfl14  = b_sfl.sfl14 
   LET g_sfl[l_ac].sfl15  = b_sfl.sfl15 
   LET g_sfl[l_ac].sfl10  = b_sfl.sfl10 
   LET g_sfl[l_ac].sfl11  = b_sfl.sfl11 
   LET g_sfl[l_ac].sfl12  = b_sfl.sfl12 
   LET g_sfl[l_ac].sfl08  = b_sfl.sfl08 
   LET g_sfl[l_ac].sfl09  = b_sfl.sfl09 
   LET g_sfl[l_ac].sflud01 = b_sfl.sflud01
   LET g_sfl[l_ac].sflud02 = b_sfl.sflud02
   LET g_sfl[l_ac].sflud03 = b_sfl.sflud03
   LET g_sfl[l_ac].sflud04 = b_sfl.sflud04
   LET g_sfl[l_ac].sflud05 = b_sfl.sflud05
   LET g_sfl[l_ac].sflud06 = b_sfl.sflud06
   LET g_sfl[l_ac].sflud07 = b_sfl.sflud07
   LET g_sfl[l_ac].sflud08 = b_sfl.sflud08
   LET g_sfl[l_ac].sflud09 = b_sfl.sflud09
   LET g_sfl[l_ac].sflud10 = b_sfl.sflud10
   LET g_sfl[l_ac].sflud11 = b_sfl.sflud11
   LET g_sfl[l_ac].sflud12 = b_sfl.sflud12
   LET g_sfl[l_ac].sflud13 = b_sfl.sflud13
   LET g_sfl[l_ac].sflud14 = b_sfl.sflud14
   LET g_sfl[l_ac].sflud15 = b_sfl.sflud15
END FUNCTION
 
FUNCTION t670_b_move_back()
   #Key 值
   LET b_sfl.sfl01  = g_sfk.sfk01
   LET b_sfl.sflplant = g_plant #FUN-980008 add
   LET b_sfl.sfllegal = g_legal #FUN-980008 add
   LET b_sfl.sfl011 = g_sfl[l_ac].sfl011    #CHI-C70016
   LET b_sfl.sfl02  = g_sfl[l_ac].sfl02 
   LET b_sfl.sfl03  = g_sfl[l_ac].sfl03 
   LET b_sfl.sfl033 = g_sfl033                    #MOD-C60012 add
  #LET g_sfl[l_ac].sfl012 = g_sfl[l_ac].sfl012    #FUN-A60027   #FUN-A60095 mark
   LET b_sfl.sfl012 = g_sfl[l_ac].sfl012    #FUN-A60095  
   LET b_sfl.sfl04  = g_sfl[l_ac].sfl04 
   LET b_sfl.sfl041 = g_sfl[l_ac].sfl041
   LET b_sfl.sfl031 = g_sfl[l_ac].sfl031
   LET b_sfl.sfl05  = g_sfl[l_ac].sfl05 
   LET b_sfl.sfl06  = g_sfl[l_ac].sfl06 
   LET b_sfl.sfl063 = g_sfl[l_ac].sfl063
   LET b_sfl.sfl07  = g_sfl[l_ac].sfl07 
   LET b_sfl.sfl13  = g_sfl[l_ac].sfl13 
   LET b_sfl.sfl14  = g_sfl[l_ac].sfl14 
   LET b_sfl.sfl15  = g_sfl[l_ac].sfl15 
   LET b_sfl.sfl10  = g_sfl[l_ac].sfl10 
   LET b_sfl.sfl11  = g_sfl[l_ac].sfl11 
   LET b_sfl.sfl12  = g_sfl[l_ac].sfl12 
   LET b_sfl.sfl08  = g_sfl[l_ac].sfl08 
   LET b_sfl.sfl09  = g_sfl[l_ac].sfl09 
   LET b_sfl.sflud01 = g_sfl[l_ac].sflud01
   LET b_sfl.sflud02 = g_sfl[l_ac].sflud02
   LET b_sfl.sflud03 = g_sfl[l_ac].sflud03
   LET b_sfl.sflud04 = g_sfl[l_ac].sflud04
   LET b_sfl.sflud05 = g_sfl[l_ac].sflud05
   LET b_sfl.sflud06 = g_sfl[l_ac].sflud06
   LET b_sfl.sflud07 = g_sfl[l_ac].sflud07
   LET b_sfl.sflud08 = g_sfl[l_ac].sflud08
   LET b_sfl.sflud09 = g_sfl[l_ac].sflud09
   LET b_sfl.sflud10 = g_sfl[l_ac].sflud10
   LET b_sfl.sflud11 = g_sfl[l_ac].sflud11
   LET b_sfl.sflud12 = g_sfl[l_ac].sflud12
   LET b_sfl.sflud13 = g_sfl[l_ac].sflud13
   LET b_sfl.sflud14 = g_sfl[l_ac].sflud14
   LET b_sfl.sflud15 = g_sfl[l_ac].sflud15
END FUNCTION
 
##No.FUN-890050---Begin  產生雜發單  #MOD-C30035 mark
#No.FUN-890050---Begin  產生雜收單   #MOD-C30035
FUNCTION t670_gen_m_iss()
DEFINE l_cnt     LIKE type_file.num10      
DEFINE li_result LIKE type_file.num5    
DEFINE l_sno     LIKE type_file.num10   
DEFINE tm RECORD
        ship     LIKE oay_file.oayslip,  
        dept     LIKE  gem_file.gem01,   
        gem02    LIKE  gem_file.gem02,
        stk      LIKE  inb_file.inb05,   
        azf03    LIKE  azf_file.azf03,
        loc      LIKE  ime_file.ime01    
        END RECORD
 
DEFINE g_ina RECORD LIKE ina_file.*
DEFINE g_inb RECORD LIKE inb_file.*
DEFINE l_unit1 LIKE inb_file.inb08
DEFINE l_cmd        LIKE type_file.chr1000 
DEFINE p_row        LIKE type_file.num10,   
       p_col        LIKE type_file.num10    
DEFINE l_err        STRING
DEFINE l_sfb98      LIKE sfb_file.sfb98 
DEFINE l_rvbs       RECORD LIKE rvbs_file.*   
DEFINE l_inbi       RECORD LIKE inbi_file.*  #FUN-B70074--add--insert--by--fengrui--
 
     IF g_sfk.sfkconf != 'Y' THEN
        CALL cl_err(g_sfk.sfk01,'asf-125',0)
        RETURN
     END IF 
   
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM ima_file
      WHERE ima01 IN (SELECT sfl03 FROM sfl_file WHERE sfl01 = g_sfk.sfk01)
        AND imaacti ='Y'
     IF l_cnt = 0 THEN  RETURN  END IF
    
##    如已產生過雜發單不可再重新產生  #MOD-C30035 mark
#    如已產生過雜收單不可再重新產生   #MOD-C30035
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM ina_file
      WHERE ina10 = g_sfk.sfk01 and inapost <> 'X'
     IF l_cnt > 0 THEN 
        CALL cl_err(g_sfk.sfk01,'asf-126',0)
     ELSE   
        LET p_row = 10 LET p_col = 35
 
        OPEN WINDOW t670_m_w AT p_row,p_col WITH FORM "asf/42f/asft670m"
             ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
        CALL cl_ui_locale("asft670m")
 
        INPUT BY NAME tm.ship,tm.dept,tm.stk,tm.loc
              WITHOUT DEFAULTS
 
           AFTER FIELD ship
             IF cl_null(tm.ship) THEN
                NEXT FIELD ship
             ELSE
               CALL s_check_no("aim",tm.ship,'','2',"ina_file","ina01","") #No.MOD-930107
                    RETURNING li_result,tm.ship
               DISPLAY BY NAME tm.ship
               IF (NOT li_result) THEN
                   NEXT FIELD ship
               END IF
             END IF
 
           AFTER FIELD dept
             IF cl_null(tm.dept) THEN
                NEXT FIELD dept
             ELSE
                SELECT COUNT(*) INTO l_cnt FROM gem_file
                 WHERE gem01=tm.dept
                IF l_cnt = 0 THEN #部門別不存在
                   LET tm.dept=''
                   DISPLAY BY NAME tm.dept
                   NEXT FIELD dept
                ELSE
                  SELECT gem02 INTO tm.gem02 FROM gem_file
                   WHERE gem01=tm.dept
                  DISPLAY by NAME tm.gem02
                END IF
             END IF
 
           AFTER FIELD stk
             IF NOT cl_null(tm.stk) THEN
                SELECT COUNT(*) INTO l_cnt FROM imd_file
                 WHERE imd01=tm.stk AND imd10='S'
                IF l_cnt = 0 THEN #倉庫別不存在
                   LET tm.stk=''
                   DISPLAY BY NAME tm.stk
                   NEXT FIELD stk
                END IF
                #Add No.FUN-AB0049 
                IF NOT s_chk_ware(tm.stk) THEN  #检查仓库是否属于当前门店
                   LET tm.stk=''
                   DISPLAY BY NAME tm.stk
                   NEXT FIELD stk
                END IF
                #End Add No.FUN-AB0049 
             END IF
             #FUN-D40103 -------Begin------
             IF NOT s_imechk(tm.stk,tm.loc) THEN
                NEXT FIELD loc 
             END IF
             #FUN-D40103 -------End--------
 
           AFTER FIELD loc
           #FUN-D40103 -----Begin------
            #IF NOT cl_null(tm.loc) THEN
            #   SELECT COUNT(*) INTO l_cnt FROM ime_file
            #    WHERE ime01=tm.loc
            #   IF l_cnt = 0 THEN #儲位不存在
            #      LET tm.loc=''
            #      DISPLAY BY NAME tm.stk
            #      NEXT FIELD loc
            #   END IF
            #END IF
           #FUN-D40103 -----End--------
             IF cl_null(tm.loc) THEN LET tm.loc = ' ' END IF   #TQC-D50127
             #FUN-D40103 -------Begin------
              IF NOT s_imechk(tm.stk,tm.loc) THEN
                 LET tm.loc=''
                 DISPLAY BY NAME tm.loc
                 NEXT FIELD loc
              END IF
             #FUN-D40103 -------End--------
 
           ON ACTION CONTROLP
              CASE
                WHEN INFIELD(ship)
                   LET g_t1 = s_get_doc_no(g_sfk.sfk01)       #No.FUN-550067
                   CALL q_smy( FALSE,TRUE,g_t1,'AIM','2') RETURNING g_t1              #No.MOD-930107
                   LET tm.ship=g_t1     #No.FUN-550067
                   DISPLAY tm.ship TO ship
                   NEXT FIELD ship
                WHEN INFIELD(dept)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_gem"
                   CALL cl_create_qry() RETURNING tm.dept
                   DISPLAY tm.dept TO dept
                   NEXT FIELD dept
                WHEN INFIELD(stk)
                  #Mod No.FUN-AB0049
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_imd"
                  #LET g_qryparam.arg1 = 'S'
                  #CALL cl_create_qry() RETURNING tm.stk
                   CALL q_imd_1(FALSE,TRUE,"","S",g_plant,"","")  #只能开当前门店的
                        RETURNING tm.stk
                  #End Mod No.FUN-AB0049
                   DISPLAY tm.stk TO stk
                   NEXT FIELD stk
                WHEN INFIELD(loc)
                  #Mod No.FUN-AB0049
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.form     = "q_ime3"
                  #LET g_qryparam.arg1 = 'S'
                  #CALL cl_create_qry() RETURNING tm.loc
                   CALL q_ime_1(FALSE,TRUE,"","","S",g_plant,"Y","","")
                        RETURNING tm.loc
                  #End Mod No.FUN-AB0049
                   DISPLAY tm.loc TO loc
                   NEXT FIELD loc
              END CASE
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
           
           ON ACTION about         
              CALL cl_about()      
           
           ON ACTION controlg      
              CALL cl_cmdask()     
           
           ON ACTION help          
              CALL cl_show_help()  
 
        END INPUT
 
        IF INT_FLAG THEN
           LET INT_FLAG=0
           CLOSE WINDOW t670_m_w
        ELSE
    ##塞雜發單  #MOD-C30035  
     #塞雜收單  #MOD-C30035
           BEGIN WORK
           INITIALIZE g_ina.* TO NULL
           LET g_ina.ina00   = '3'
           LET g_ina.ina02   = g_today
           LET g_ina.ina03   = g_today
           LET g_ina.ina04   = tm.dept
           LET g_ina.ina10   = g_sfk.sfk01
           LET g_ina.ina11   = g_user
           LET g_ina.ina08   = '0'              #No.MOD-760148 add
           LET g_ina.ina11   = g_user
           LET g_ina.inaprsw = 0
           LET g_ina.inaconf = 'N'
           LET g_ina.inapost = 'N'
           LET g_ina.inauser = g_user
           LET g_ina.inagrup = g_grup
           LET g_ina.inamodu = ''
           LET g_ina.inadate = g_today
           LET g_ina.inamksg = g_smy.smyapr     #No.MOD-760148 add
           LET g_ina.inaplant = g_plant #FUN-980008 add
           LET g_ina.inalegal = g_legal #FUN-980008 add
           LET g_ina.ina12   = 'N'      #FUN-870100 ADD                                                                             
           LET g_ina.inapos  = 'N'      #FUN-870100 ADD 
 
          #CALL s_auto_assign_no("aim",tm.ship,g_ina.ina03,'1',"ina_file","ina01","","","")  #MOD-B50063
           CALL s_auto_assign_no("aim",tm.ship,g_ina.ina03,'2',"ina_file","ina01","","","")  #MOD-B50063
               RETURNING li_result,g_ina.ina01
 
           LET g_ina.inaoriu = g_user      #No.FUN-980030 10/01/04
           LET g_ina.inaorig = g_grup      #No.FUN-980030 10/01/04
           INSERT INTO ina_file VALUES(g_ina.*)
 
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","ina_file",g_ina.ina01,"",SQLCA.sqlcode,"","ins ina:",1)  #No.FUN-660128
              ROLLBACK WORK
              RETURN
           END IF
 
           #INSERT 單身
           LET l_sno = 0
           LET g_sql =
             "SELECT sfl03,sfl031,sfl07,ima35,ima36",  #No.MOD-930107
             " FROM sfl_file ,OUTER ima_file",
             " WHERE sfl01 ='",g_sfk.sfk01,"'",
             "   AND sfl_file.sfl03 = ima_file.ima01 "
           # foreach 塞資料
           PREPARE t670_pb2 FROM g_sql
           DECLARE sfa_curs2 CURSOR FOR t670_pb2
          #------------------------No:CHI-A80038 add
           LET g_sql = " SELECT * FROM rvbs_file ",
                       "  WHERE rvbs00 ='",g_prog,"'",
                       "    AND rvbs01 ='",g_sfk.sfk01,"'",
                       "    AND rvbs021= ? ",
                       "    AND rvbs02 = 0 "
                         
           PREPARE t670_rvbs2 FROM g_sql
           DECLARE rvbs_curs2 CURSOR FOR t670_rvbs2
          #------------------------No:CHI-A80038 end
           FOREACH sfa_curs2 INTO g_inb.inb04,g_inb.inb08,g_inb.inb09,g_inb.inb05,g_inb.inb06
              LET l_cnt = 0
              SELECT COUNT(*) INTO l_cnt FROM ima_file
               WHERE ima01 = g_inb.inb04
                 AND imaacti ='Y'
              IF l_cnt = 0 THEN
                 CONTINUE FOREACH
              END IF
 
               LET l_sno = l_sno + 1
               IF NOT cl_null(tm.stk) THEN
                  LET g_inb.inb05=tm.stk
               END IF
               IF NOT cl_null(tm.loc) THEN
                  LET g_inb.inb06 = tm.loc
               ELSE LET g_inb.inb06 = ' '  #TQC-670017 add
               END IF
 
 
               LET g_inb.inb01  = g_ina.ina01
               LET g_inb.inb03 = l_sno
               LET g_inb.inb07  = ' ' 
               #抓異動單位
                SELECT img09 INTO l_unit1 FROM img_file
                  WHERE img01 = g_inb.inb04 AND img02 = g_inb.inb05
                    AND img03 = g_inb.inb06 AND img04 = g_inb.inb07
 
               #異動(inb08)/庫存單位(img09)
               CALL  s_umfchk(g_inb.inb04,g_inb.inb08,l_unit1)
                         RETURNING l_cnt,g_inb.inb08_fac
               IF l_cnt = 1 THEN
                   CALL cl_err('','mfg3075',0)
                   LET g_inb.inb08_fac = 0
               END IF
 
               LET g_inb.inb16  = g_inb.inb09    #No.MOD-930107
               LET g_inb.inb10  = 'N'
               LET g_inb.inb11  = ''
               LET g_inb.inb12  = ''
               LET g_inb.inb13  = 0
        #FUN-AB0089--add--begin
               LET g_inb.inb132 = 0
               LET g_inb.inb133 = 0
               LET g_inb.inb134 = 0
               LET g_inb.inb135 = 0
               LET g_inb.inb136 = 0
               LET g_inb.inb137 = 0
               LET g_inb.inb138 = 0
        #FUN-AB0089--add--end
               LET g_inb.inb14  = 0
               LET g_inb.inb15  = ''
               LET g_inb.inb901 = ''
               LET g_inb.inb902 = g_inb.inb08
               LET g_inb.inb903 = g_inb.inb08_fac
               LET g_inb.inb904 = g_inb.inb09
               LET g_inb.inb905 = ''
               LET g_inb.inb906 = ''
               LET g_inb.inb907 = ''
               LET g_inb.inb930 = '' 
               LET g_inb.inb41 = ''  #專案
               LET g_inb.inb42 = ''  #WBS
               LET g_inb.inb43 = ''  #活動
               LET g_inb.inb16 = g_inb.inb09  
               LET g_inb.inbplant = g_plant #FUN-980008 add
               LET g_inb.inblegal = g_legal #FUN-980008 add
 
              #判斷是否做專案庫存及批序號管理
              #IF 有專案庫存但無批序號管理，則要insert到rvbs_file
               IF s_chk_rvbs(g_inb.inb41,g_inb.inb04) THEN
                 LET g_success = 'Y'
                 #              出庫  作業代號   單號        單身序號     數量(換算成庫存數量)      專案代號
                 LET l_rvbs.rvbs00 = "aimt302"
                 LET l_rvbs.rvbs01 = g_ina.ina01
                 LET l_rvbs.rvbs02 = g_inb.inb03
                 LET l_rvbs.rvbs021= g_inb.inb04
                 LET l_rvbs.rvbs06 =g_inb.inb09*g_inb.inb08_fac
                 LET l_rvbs.rvbs08 = g_inb.inb41
                 LET l_rvbs.rvbs09 = -1   #出庫
                 CALL s_ins_rvbs("1",l_rvbs.*)
                 IF g_success = 'N' THEN
                   LET l_err = 'N'
                   EXIT FOREACH
                 END IF
               END IF
              #FUN-CB0087-xj---add---str
               IF g_aza.aza115 = 'Y' THEN
                 CALL s_reason_code(g_ina.ina01,g_ina.ina10,'',g_inb.inb04,g_inb.inb05,g_ina.ina04,g_ina.ina11) RETURNING g_inb.inb15
                 IF cl_null(g_inb.inb15) THEN
                    CALL cl_err('','aim-425',1)
                    EXIT FOREACH
                 END IF
               END IF
              #FUN-CB0087-xj---add---end 
               INSERT INTO inb_file VALUES(g_inb.*)
 
               IF SQLCA.sqlcode THEN
                  LET l_err = SQLCA.sqlcode
                  CALL cl_err3("ins","inb_file",g_inb.inb01,g_inb.inb03,l_err,"","ins inb:",1)  #No.FUN-660128
                  EXIT FOREACH
#FUN-B70074--add--insert--by--fengrui--
              ELSE
                  IF NOT s_industry('std') THEN
                     INITIALIZE l_inbi.* TO NULL
                     LET l_inbi.inbi01 = g_inb.inb01
                     LET l_inbi.inbi03 = g_inb.inb03
                     IF NOT s_ins_inbi(l_inbi.*,g_inb.inbplant ) THEN
                        EXIT FOREACH
                     END IF
                  END IF 
#FUN-B70074--add--insert----by--fengrui--
               END IF
              #----------------No:CHI-A80038 add
               SELECT ima918,ima921 INTO g_ima918,g_ima921 
                 FROM ima_file
                WHERE ima01 = g_inb.inb04
                  AND imaacti = "Y"
               
               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  FOREACH rvbs_curs2 USING g_inb.inb04 INTO l_rvbs.*
                     LET l_rvbs.rvbs00= 'aimt302'
                     LET l_rvbs.rvbs01= g_inb.inb01
                     LET l_rvbs.rvbs02= g_inb.inb03
                     LET l_rvbs.rvbs09= 1
                     INSERT INTO rvbs_file VALUES(l_rvbs.*)
                     IF STATUS OR SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                        CALL cl_err3("ins","rvbs_file","","",SQLCA.sqlcode,"","ins rvbs",1) 
                        LET g_success='N'
                     END IF
                  END FOREACH
               END IF
              #----------------No:CHI-A80038 end
           END FOREACH
           CLOSE WINDOW t670_m_w
 
           IF cl_null(l_err) THEN
              COMMIT WORK
              LET l_cmd = "aimt302 '", g_ina.ina01 CLIPPED ,"'"
              CALL cl_cmdrun_wait(l_cmd)  
           ELSE
              ROLLBACK WORK
           END IF
       END IF 
     END IF
  
END FUNCTION
 
## add 維護雜發單 #MOD-C30035 mark
# add 維護雜收單  #MOD-C30035
FUNCTION t670_m_iss()
  DEFINE l_ina01      LIKE ina_file.ina01
  DEFINE l_cmd        LIKE type_file.chr1000 
 
  SELECT ina01 INTO l_ina01 FROM ina_file
   WHERE ina10 = g_sfk.sfk01
 
  IF SQLCA.sqlcode THEN
     IF SQLCA.sqlerrd[3]=0 THEN
        CALL cl_err3("sel","ina_file",g_sfk.sfk01,"","asf-020","","",1)  
        RETURN
     ELSE
        RETURN
     END IF
  END IF
 
  IF NOT cl_null(l_ina01) THEN
     LET l_cmd = "aimt302 '", l_ina01 CLIPPED ,"'"
     CALL cl_cmdrun_wait(l_cmd)  
  ELSE
     CALL cl_err('','asf-020',1)
  END IF
END FUNCTION

#TQC-AB0394 ------------add start------------
FUNCTION t670_shl012()
DEFINE l_cnt   LIKE type_file.num5

  IF g_sma.sma541 = 'Y' AND g_sfl[l_ac].sfl012 IS NOT NULL AND NOT cl_null(g_sfl[l_ac].sfl041) THEN
     LET l_cnt = 0
     SELECT count(*) INTO l_cnt FROM sfa_file
      WHERE sfa01=g_sfl[l_ac].sfl02
        AND sfa012=g_sfl[l_ac].sfl012
        AND sfa013=g_sfl[l_ac].sfl041
     IF l_cnt > 0 THEN RETURN TRUE ELSE RETURN FALSE END IF
  ELSE
     RETURN TRUE
  END IF

END FUNCTION

FUNCTION t670_sfa08(l_sfl02,l_sfl03,l_sfl031,l_sfl012,l_sfl041)
  DEFINE l_sfl02    LIKE sfl_file.sfl02,
         l_sfl03    LIKE sfl_file.sfl03,
         l_sfl031   LIKE sfl_file.sfl031,
         l_sfl012   LIKE sfl_file.sfl012,
         l_sfl041   LIKE sfl_file.sfl041
  DEFINE l_sfa08    LIKE sfa_file.sfa08
  DEFINE l_sql      STRING

  IF NOT cl_null(l_sfl02) AND NOT cl_null(l_sfl03) AND g_sma.sma541 = 'Y' AND
     NOT cl_null(l_sfl031) AND l_sfl012 IS NOT NULL AND NOT cl_null(l_sfl041)   THEN
     LET l_sql = " SELECT sfa08 FROM sfa_file ",
                 "  WHERE sfa01 = '",l_sfl02,"' AND sfa03 = '",l_sfl03,"'",
                 "    AND sfa12 = '",l_sfl031,"'",
                 "    AND sfa012 = '",l_sfl012,"' AND sfa013 = ",l_sfl041
     PREPARE t670_pre1 FROM l_sql
     DECLARE t670_cs1 CURSOR FOR t670_pre1

     FOREACH t670_cs1 INTO l_sfa08
       IF NOT cl_null(l_sfa08) THEN
          EXIT FOREACH
       ELSE
         CONTINUE FOREACH
       END IF
    END FOREACH
    LET g_sfl[l_ac].sfl04 = l_sfa08
  END IF
END FUNCTION
#TQC-AB0394 --------------add end--------------------
#No.FUN-9C0072 精簡程式碼

#FUN-910088--add--start--
FUNCTION t670_sfl07_check()
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_sfl[l_ac].sfl07) AND NOT cl_null(g_sfl[l_ac].sfl031) THEN
      IF cl_null(g_sfl031_t) OR cl_null(g_sfl_t.sfl07) OR g_sfl031_t != g_sfl[l_ac].sfl031 OR g_sfl_t.sfl07 != g_sfl[l_ac].sfl07 THEN
         LET g_sfl[l_ac].sfl07 = s_digqty(g_sfl[l_ac].sfl07,g_sfl[l_ac].sfl031)
         DISPLAY BY NAME g_sfl[l_ac].sfl07
      END IF
   END IF
    IF NOT cl_null(g_sfl[l_ac].sfl07) THEN
       IF g_sfl[l_ac].sfl07=0 THEN                                                                                           
          CALL cl_err('','asf-713',0)                                                                                        
          RETURN FALSE                                                                                                       
       END IF                                                                                                                
       IF g_sfb02 != 11 THEN 
           CALL t670_sfa_num(p_cmd,g_sfl[l_ac].sfl02,g_sfl[l_ac].sfl03,g_sfl[l_ac].sfl04,
                             g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl041,g_sfl[l_ac].sfl012,
                             g_sfl[l_ac].sfl07,g_sfl[l_ac].sfl063)   #check數量    
       END IF
       IF NOT cl_null(g_errno)  THEN
          CALL cl_err(g_sfl[l_ac].sfl07,g_errno,0)
          LET g_sfl[l_ac].sfl07=g_sfl_t.sfl07
          RETURN FALSE     
       END IF
    END IF
    IF g_sfl[l_ac].sfl07<0 THEN RETURN FALSE END IF      
    SELECT ima918,ima921 INTO g_ima918,g_ima921 
      FROM ima_file
     WHERE ima01 = g_sfl[l_ac].sfl03
       AND imaacti = "Y"
    IF (g_ima918 = "Y" OR g_ima921 = "Y") AND 
       (cl_null(g_sfl_t.sfl07) OR (g_sfl[l_ac].sfl07<>g_sfl_t.sfl07 )) THEN
       CALL s_mod_lot(g_prog,g_sfk.sfk01,0,0,                         
                     g_sfl[l_ac].sfl03,' ',' ',' ',
                     g_sfl[l_ac].sfl031,g_sfl[l_ac].sfl031,1,
                     g_sfl[l_ac].sfl07,'','SEL',-1)                  
             RETURNING g_r,g_qty 
       
       IF g_r = "Y" THEN
          LET g_sfl[l_ac].sfl07 = g_qty
          LET g_sfl[l_ac].sfl07 = s_digqty(g_sfl[l_ac].sfl07,g_sfl[l_ac].sfl031)
       END IF
    END IF
    RETURN TRUE
END FUNCTION

FUNCTION t670_sfl12_check(l_sfa13)
   DEFINE p_cmd LIKE type_file.chr1
   DEFINE l_sfa13 LIKE sfa_file.sfa13
   IF NOT cl_null(g_sfl[l_ac].sfl12) AND NOT cl_null(g_sfl[l_ac].sfl10) THEN
      IF cl_null(g_sfl10_t) OR cl_null(g_sfl_t.sfl12) OR g_sfl10_t != g_sfl[l_ac].sfl10 OR g_sfl_t.sfl12 != g_sfl[l_ac].sfl12 THEN
         LET g_sfl[l_ac].sfl12 = s_digqty(g_sfl[l_ac].sfl12,g_sfl[l_ac].sfl10) 
         DISPLAY BY NAME g_sfl[l_ac].sfl12
      END IF
   END IF
   IF NOT cl_null(g_sfl[l_ac].sfl12) THEN
      IF g_sfl[l_ac].sfl12 < 0 THEN
         CALL cl_err('','aim-391',0)  
         RETURN "sfl12"
      END IF
   END IF
   #計算sfl07的值,檢查數量的合理性
   CALL t670_set_origin_field()
   LET l_sfa13 = g_factor
   CALL t670_check_inventory_qty(p_cmd)  
       RETURNING g_flag,l_sfa13
   IF g_flag = '1' THEN
      IF g_ima906 = '3' OR g_ima906 = '2' THEN
         RETURN "sfl15"  
      ELSE
         RETURN "sfl12"  
      END IF
   END IF
   CALL cl_show_fld_cont()
   RETURN "" 
END FUNCTION       

FUNCTION t670_sfl15_check()
   DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_sfl[l_ac].sfl15) AND NOT cl_null(g_sfl[l_ac].sfl13) THEN
      IF cl_null(g_sfl13_t) OR cl_null(g_sfl_t.sfl15) OR g_sfl13_t != g_sfl[l_ac].sfl13 OR g_sfl_t.sfl15 != g_sfl[l_ac].sfl15 THEN
         LET g_sfl[l_ac].sfl15 = s_digqty(g_sfl[l_ac].sfl15,g_sfl[l_ac].sfl13)
         DISPLAY BY NAME g_sfl[l_ac].sfl15
      END IF
   END IF
   IF NOT cl_null(g_sfl[l_ac].sfl15) THEN
      IF g_sfl[l_ac].sfl15 < 0 THEN
         CALL cl_err('','aim-391',0)   
         RETURN FALSE    
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_sfl_t.sfl15 <> g_sfl[l_ac].sfl15 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_sfl[l_ac].sfl15*g_sfl[l_ac].sfl14
            IF cl_null(g_sfl[l_ac].sfl12) OR g_sfl[l_ac].sfl12=0 THEN                     
               LET g_sfl[l_ac].sfl12=g_tot*g_sfl[l_ac].sfl11
               LET g_sfl[l_ac].sfl12 = s_digqty(g_sfl[l_ac].sfl12,g_sfl[l_ac].sfl10)                          
               DISPLAY BY NAME g_sfl[l_ac].sfl12                                          
            END IF                                                                   
         END IF
      END IF
   END IF
   CALL cl_show_fld_cont()                                     
   RETURN TRUE
END FUNCTION
#FUN-910088--add--end--
#TQC-D20042---add---str---
FUNCTION t670_azf03_desc()
   LET g_sfl[l_ac].azf03 = ''
   IF NOT cl_null(g_sfl[l_ac].sfl08) THEN
      SELECT azf03 INTO g_sfl[l_ac].azf03 FROM azf_file WHERE azf01=g_sfl[l_ac].sfl08 AND azf02='2'
   END IF
   DISPLAY BY NAME g_sfl[l_ac].azf03
END FUNCTION
#TQC-D20042---add---end---

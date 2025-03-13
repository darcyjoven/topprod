# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aimt306.4gl
# Date & Author..: 91/06/10 By LEE
# Modify ........: 98/10/26 By Raymon  改寫為單據式 BUG No:2643
# Modify ........: 99/08/18 BY Kammy   重新整理並增加過帳還原 BUG NO:0444
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.MOD-480340 04/09/01 By Nicola  1.轉換率,已償還數量應不能維護.
#                                                    2.單身順序調整
#                                                    3.新增存入後,單身庫存量與轉入數量不見
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.FUN-4A0072 04/10/11 By Carol Controlp q_img4--> q_img1()
#                                                  construct 改為 call q_imd,q_ime
# Modify.........: No.MOD-4A0201 04/10/13 By Mandy 在sma53關帳後,關帳前的資料即應不可異動!
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-540001 05/04/01 By echo 新增報表備註
# Modify.........: No.FUN-550011 05/05/25 By kim GP2.0功能 庫存單據不同期要check庫存是否為負
# Modify.........: No.FUN-550029 05/05/30 By vivien 單據編號格式放大
# Modify.........: No.MOD-530271 05/05/26 By echo 新增報表備註
# Modify.........: No.FUN-560183 05/06/22 By kim 移除ima86成本單位
# Modify.........: No.FUN-570249 05/08/01 By Carrier 多單位內容修改
# Modify.........: No.MOD-580082 05/08/29 By pengu imp10的值都為空,沒有用數量*單價進行計算,導致新增,
#                                                  修改的時候該欄位都沒有內容
# Modify.........: No.FUN-590023 05/09/08 By Nicola 單身輸入完一筆料件的借料數量，跳至下一筆(序號2)，會將「借料數量」及「轉入數量」的數字清為0。
# Modify.........: No.FUN-5A0029 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-5C0077 05/12/23 By jackie  單身增加檢驗否imp15欄位，扣帳時做檢查
# Modify.........: No.FUN-610006 06/01/07 By Smapmin 雙單位畫面調整
# Modify.........: No.TQC-630052 06/03/07 By Claire 流程訊息通知傳參數
# Modify.........: NO.TQC-620156 06/03/14 By kim GP3.0過帳錯誤統整顯示功能新增
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.TQC-660068 06/06/14 By Claire 流程訊息通知傳參數
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-640213 06/07/14 By rainy 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-670093 06/07/20 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670066 06/08/02 By xumin voucher型報表轉template1 
# Modify.........: No.FUN-680010 06/08/26 by Joe SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-690026 06/09/13 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690024 06/09/22 By jamie 判斷pmcacti
# Modify.........: No.FUN-680046 06/10/11 By jamie 1.FUNCTION t306()_q 一開始應清空g_imo.*值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.CHI-690066 06/12/13 By rainy CALL s_daywk() 要判斷未設定或非工作日
# Modify.........: No.CHI-6A0015 06/12/19 By rainy 輸完料號後，自動帶出預設的倉庫儲位
# Modify.........: No.FUN-6C0083 07/01/08 By Nicola 錯誤訊息彙整
# Modify.........: No.FUN-710025 07/01/29 By bnlent 錯誤訊息彙整
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/21 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740042 07/04/09 By bnlent 用年度取帳套
# Modify.........: No.TQC-750018 07/05/04 By rainy 更改狀態無更改料號時，不重帶倉庫儲位
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: No.TQC-750015 07/08/14 By pengu 庫存轉換率異常
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-840296 08/04/28 By Pengu 倉庫無法重複維護
#                                                  2.列印時儲位位置未對應
# Modify.........: No.FUN-840020 08/04/07 By zhaijie 報表輸出改為CR
# Modify.........: No.CHI-860005 08/06/27 By xiaofeizhu 使用參考單位且參考數量為0時，也需寫入tlff_file
# Modify.........: No.MOD-890194 08/09/19 By claire 加入imoconf,imopost報表列印
# Modify.........: No.FUN-8C0084 08/12/22 By jan s_upimg相關改以 料倉儲批為參數傳入 ,不使用 ROWID
# Modify.........: No.FUN-930109 09/03/19 By xiaofeizhu 過賬時增加s_incchk檢查使用者是否有相應倉,儲的過賬權限
# Modify.........: No.TQC-930155 09/03/30 By Sunyanchun Lock img_file,imgg_file時，若報錯，不要rollback ，要放g_success ='N'
# Modify.........: No.FUN-980004 09/08/25 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No.FUN-9C0072 10/01/15 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:FUN-8C0131 10/04/07 by dxfwo  過帳還原時的呆滯日期異動
# Modify.........: No:FUN-A80106 10/08/19 by Summer 增加ICD維護刻號/BIN
# Modify.........: No.FUN-A90048 10/09/28 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No.MOD-AA0106 10/10/18 By sabrina 查詢單一單號在列印時只能印一次，之後再印就會顯示"無報表產生"錯誤訊息
# Modify.........: No.FUN-AA0049 10/10/21 by destiny 增加倉庫的權限控管
# Modify.........: No.MOD-AC0105 10/12/14 By sabrina 單身結案(imp07)應不可維護 
# Modify.........: No.TQC-B10062 11/01/11 By lilingyu 狀態page,部分欄位不可下查詢條件;刪除資料時,報錯訊息有誤
# Modify.........: No.FUN-B10049 11/01/20 By destiny 科目查詢自動過濾
# Modify.........: No:FUN-B40004 11/04/11 By yinhy 維護資料時“部門”欄位check部門內容時應根據部門拒絕/允許設置作業管控
# Modify.........: No.TQC-B50032 11/05/18 By destiny 审核时不存在的部门可以通过 
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B30187 11/06/29 By jason ICD功能修改，增加母批、DATECODE欄位 
# Modify.........: No:FUN-B70061 11/07/20 By jason 維護刻號/BIN回寫母批DATECODE
# Modify.........: No.FUN-B80070 11/08/08 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外 
# Modify.........: No.FUN-B80119 11/09/14 By fengrui  增加調用s_icdpost的p_plant參數
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No:FUN-BB0083 11/12/07 By xujing 增加數量欄位小數取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-BC0109 12/02/08 By jason for ICD Datecode回寫多筆時即以","做分隔
# Modify.........: No.TQC-C20183 12/02/16 By xujing 小數取位補充
# Modify.........: No.FUN-C30062 12/03/13 By bart 修改ICD無法列印報表
# Modify.........: No:FUN-C30302 12/04/13 By bart 修改 s_icdin 回傳值
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C50071 12/06/06 By Sakura 增加批序號功能(單身批序號修改/批序號查詢)
# Modify.........: No.CHI-C30107 12/06/08 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No:TQC-C60020 12/06/14 By bart datecode可維護
# Modify.........: No.FUN-C70087 12/07/31 By bart 整批寫入img_file
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.FUN-CB0087 12/12/10 By xujing 倉庫單據理由碼改善
# Modify.........: No:FUN-CC0095 13/01/16 By bart 修改整批寫入img_file
# Modify.........: No:FUN-D10081 13/01/17 By qiull 增加資料清單
# Modify.........: No:TQC-D10084 13/01/29 By qiull 資料清單頁簽不可點擊單身按鈕
# Modify.........: No:TQC-D10103 13/02/01 By xujing 處理理由碼改善控管的一些問題
# Modify.........: No:CHI-D20010 13/02/20 By yangtt 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No.FUN-D20060 13/02/25 By chenying 設限倉庫控卡
# Modify.........: No.TQC-D20042 13/02/25 By xujing 處理審核時理由碼控管及理由碼說明
# Modify.........: No:FUN-BC0062 13/02/28 By fengrui 當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
# Modify.........: No:FUN-D30024 13/03/12 By qiull 負庫存依據imd23判斷
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.CHI-CC0028 13/04/15 By bart 過帳還原需控管"有無此倉儲的過賬權限"
# Modify.........: No.TQC-D40025 13/04/19 By xumm 修改FUN-D40030遗留问题
# Modify.........: No.FUN-D40103 13/05/07 By fengrui 添加庫位有效性檢查
# Modify.........: No.TQC-D50124 13/05/28 By lixiang 修正FUN-D40103部份邏輯控管
# Modify.........: No:TQC-DB0075 13/11/27 By wangrr 點擊"查詢"再"退出",會報錯"-404:找不到光標或說明"

DATABASE ds
 
GLOBALS "../../config/top.global"
#FUN-CC0095---begin
GLOBALS
   DEFINE g_padd_img       DYNAMIC ARRAY OF RECORD
                     img01 LIKE img_file.img01,
                     img02 LIKE img_file.img02,
                     img03 LIKE img_file.img03,
                     img04 LIKE img_file.img04,
                     img05 LIKE img_file.img05,
                     img06 LIKE img_file.img06,
                     img09 LIKE img_file.img09,
                     img13 LIKE img_file.img13,
                     img14 LIKE img_file.img14,
                     img17 LIKE img_file.img17,
                     img18 LIKE img_file.img18,
                     img19 LIKE img_file.img19,
                     img21 LIKE img_file.img21,
                     img26 LIKE img_file.img26,
                     img27 LIKE img_file.img27,
                     img28 LIKE img_file.img28,
                     img35 LIKE img_file.img35,
                     img36 LIKE img_file.img36,
                     img37 LIKE img_file.img37
                           END RECORD

   DEFINE g_padd_imgg      DYNAMIC ARRAY OF RECORD
                    imgg00 LIKE imgg_file.imgg00,
                    imgg01 LIKE imgg_file.imgg01,
                    imgg02 LIKE imgg_file.imgg02,
                    imgg03 LIKE imgg_file.imgg03,
                    imgg04 LIKE imgg_file.imgg04,
                    imgg05 LIKE imgg_file.imgg05,
                    imgg06 LIKE imgg_file.imgg06,
                    imgg09 LIKE imgg_file.imgg09,
                    imgg10 LIKE imgg_file.imgg10,
                    imgg20 LIKE imgg_file.imgg20,
                    imgg21 LIKE imgg_file.imgg21,
                    imgg211 LIKE imgg_file.imgg211,
                    imggplant LIKE imgg_file.imggplant,
                    imgglegal LIKE imgg_file.imgglegal
                            END RECORD
END GLOBALS
#FUN-CC0095---end
#模組變數(Module Variables)
DEFINE
    g_imo           RECORD LIKE imo_file.*,    #簽核等級 (假單頭)
    g_imo_t         RECORD LIKE imo_file.*,    #簽核等級 (舊值)
    g_imo_o         RECORD LIKE imo_file.*,    #簽核等級 (舊值)
    b_imp           RECORD LIKE imp_file.*,
    b_impi          RECORD LIKE impi_file.*,   #FUN-B30187
    g_imo01_t       LIKE imo_file.imo01,       #簽核等級 (舊值)
    g_imp           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)    #No.MOD-480340
       imp02       LIKE imp_file.imp02,   #項次
       imp03       LIKE imp_file.imp03,   #
       ima02       LIKE ima_file.ima02,   #
       ima05       LIKE ima_file.ima05,   #
       ima08       LIKE ima_file.ima08,   #
       ima25       LIKE ima_file.ima25,   #
       imp05       LIKE imp_file.imp05,   #
       imp04       LIKE imp_file.imp04,   #
       imp09       LIKE imp_file.imp09,   #
       imp11       LIKE imp_file.imp11,   #
       imp12       LIKE imp_file.imp12,   #
       imp13       LIKE imp_file.imp13,   #
       bala        LIKE imp_file.imp04,   #
       imp14       LIKE imp_file.imp14,   #
       imp14_fac   LIKE imp_file.imp14_fac,
       imp23       LIKE imp_file.imp23,   #單位二
       imp24       LIKE imp_file.imp24,   #單位二轉換率
       imp25       LIKE imp_file.imp25,   #單位二數量
       imp20       LIKE imp_file.imp20,   #單位一
       imp21       LIKE imp_file.imp21,   #單位一轉換率
       imp22       LIKE imp_file.imp22,   #單位一數量
       actu        LIKE imp_file.imp08,
       imp06       LIKE imp_file.imp06,   #
       imp08       LIKE imp_file.imp08,   #
       imp07       LIKE imp_file.imp07,
       imp15       LIKE imp_file.imp15,   #No.FUN-5C0077
       imp16       LIKE imp_file.imp16,   #FUN-CB0087
       azf03       LIKE azf_file.azf03,   #FUN-CB0087
       imp930      LIKE imp_file.imp930,  #FUN-670093
       gem02c      LIKE gem_file.gem02,    #FUN-670093
       impiicd028  LIKE impi_file.impiicd028,   #FUN-B30187
       impiicd029  LIKE impi_file.impiicd029   #FUN-B30187
       
                   END RECORD,
    g_imp_t         RECORD                 #程式變數 (舊值)    #No.MOD-480340
       imp02       LIKE imp_file.imp02,   #項次
       imp03       LIKE imp_file.imp03,   #
       ima02       LIKE ima_file.ima02,   #
       ima05       LIKE ima_file.ima05,   #
       ima08       LIKE ima_file.ima08,   #
       ima25       LIKE ima_file.ima25,   #
       imp05       LIKE imp_file.imp05,   #
       imp04       LIKE imp_file.imp04,   #
       imp09       LIKE imp_file.imp09,   #
       imp11       LIKE imp_file.imp11,   #
       imp12       LIKE imp_file.imp12,   #
       imp13       LIKE imp_file.imp13,   #
       bala        LIKE imp_file.imp04,   #
       imp14       LIKE imp_file.imp14,   #
       imp14_fac   LIKE imp_file.imp14_fac,
       imp23       LIKE imp_file.imp23,   #單位二
       imp24       LIKE imp_file.imp24,   #單位二轉換率
       imp25       LIKE imp_file.imp25,   #單位二數量
       imp20       LIKE imp_file.imp20,   #單位一
       imp21       LIKE imp_file.imp21,   #單位一轉換率
       imp22       LIKE imp_file.imp22,   #單位一數量
       actu        LIKE imp_file.imp08,
       imp06       LIKE imp_file.imp06,   #
       imp08       LIKE imp_file.imp08,   #
       imp07       LIKE imp_file.imp07,
       imp15       LIKE imp_file.imp15,   #No.FUN-5C0077
       imp16       LIKE imp_file.imp16,   #FUN-CB0087
       azf03       LIKE azf_file.azf03,   #FUN-CB0087
       imp930      LIKE imp_file.imp930,  #FUN-670093
       gem02c      LIKE gem_file.gem02,    #FUN-670093
       impiicd028  LIKE impi_file.impiicd028,  #FUN-B30187
       impiicd029  LIKE impi_file.impiicd029   #FUN-B30187
       
                    END RECORD,
    g_wc,g_wc2,g_sql   STRING, #TQC-630166
    g_cmd             LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(100)
    g_rec_b           LIKE type_file.num5,    #單身筆數  #No.FUN-690026 SMALLINT
    g_void            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_ac              LIKE type_file.num5,    #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    g_t1              LIKE smy_file.smyslip, #單別   #No.FUN-550029 #No.FUN-690026 VARCHAR(05)
    g_unit            LIKE ima_file.ima25,   #庫存單位 #No.FUN-690026 VARCHAR(04)
    g_flag            LIKE type_file.chr1,   #判斷是否為新增的自動編號  #No.FUN-690026 VARCHAR(1)
    g_ima25      LIKE ima_file.ima25,        #主檔庫存單位
    g_ima25_fac  LIKE img_file.img20,        #收料單位對主檔庫存單位轉換率
    g_ima39      LIKE ima_file.ima39,        #料件所屬會計科目
    g_img10      LIKE img_file.img10,        #庫存數量
    g_img26      LIKE img_file.img26,        #倉庫所屬會計科目
    g_img23      LIKE img_file.img23,        #是否為可用倉儲
    g_img24      LIKE img_file.img24,        #是否為MRP可用倉儲
    g_img21      LIKE img_file.img21,        #庫存單位對料件庫存單位轉換率
    g_img19      LIKE ima_file.ima271,       #最高限量
    g_ima271     LIKE ima_file.ima271,       #最高儲存量
    g_imf05      LIKE imf_file.imf05,        #預設料件庫存量
    h_qty        LIKE ima_file.ima271,
    g_desc       LIKE ze_file.ze03,          #說明 #No.FUN-690026 VARCHAR(26)
    l_year,l_prd LIKE type_file.num5,        #No.FUN-690026 SMALLINT
    sn1,sn2      LIKE type_file.num5,        #No.FUN-690026 SMALLINT
#   g_a          LIKE ima_file.ima262,       #料件庫存可使用量(ima262)
    g_a          LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
    g_img RECORD
                 img19 LIKE img_file.img19,  #Class
                 img36 LIKE img_file.img36
          END RECORD,
    m_imo RECORD
                 img09_fac LIKE ima_file.ima63_fac,
                 img09     LIKE img_file.img09,
                 ima63     LIKE ima_file.ima63,
                 img10     LIKE img_file.img10,
                 img35_2   LIKE img_file.img35,
                 img27     LIKE img_file.img27,
                 img28     LIKE img_file.img28,
                 ima25_fac LIKE ima_file.ima63_fac,
                 ima25 LIKE ima_file.ima25
          END RECORD,
    t_img02      LIKE img_file.img02,         #倉庫
    t_img03      LIKE img_file.img03,         #儲位
    g_v          LIKE type_file.chr1,         # IF g_v = 'Y'   經由 menu BAR 'V.單價' 進入單身  #No.FUN-690026 VARCHAR(1)
    g_yy,g_mm	 LIKE type_file.num5          #MOD-4A0201  #No.FUN-690026 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_bookno1        LIKE aza_file.aza81   #No.FUN-730033
DEFINE g_bookno2        LIKE aza_file.aza82   #No.FUN-730033
 
DEFINE
    g_yes               LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_imgg10_2          LIKE img_file.img10,
    g_imgg10_1          LIKE img_file.img10,
    g_change            LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    g_ima906            LIKE ima_file.ima906,
    g_ima907            LIKE ima_file.ima907,
    g_imgg00            LIKE imgg_file.imgg00,
    g_imgg10            LIKE imgg_file.imgg10,
    g_img09             LIKE img_file.img09,
    g_imp10             LIKE imp_file.imp10,
    g_sw                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    g_factor            LIKE inb_file.inb08_fac,
    g_tot               LIKE img_file.img10,
    g_qty               LIKE img_file.img10
DEFINE  g_dies          LIKE ida_file.ida17 #FUN-A80106 add
#FUN-C50071 add begin--------------------------
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
DEFINE g_rec_b1    LIKE type_file.num5,   #單身二筆數
       l_ac1       LIKE type_file.num5    #目前處理的ARRAY CNT
DEFINE g_ima918    LIKE ima_file.ima918
DEFINE g_ima921    LIKE ima_file.ima921
DEFINE l_r         LIKE type_file.chr1
DEFINE l_i         LIKE type_file.num5
DEFINE l_fac       LIKE img_file.img34
#FUN-C50071 add -end---------------------------
 
#主程式開始
DEFINE g_forupd_sql    STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count     LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index    LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask       LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_argv1         LIKE imo_file.imo01    # 單號 #TQC-630052 #No.FUN-690026 VARCHAR(16)
DEFINE g_argv2         STRING                 # 指定執行的功能   #TQC-630052
DEFINE l_table        STRING
DEFINE g_str          STRING
DEFINE g_imp05_t       LIKE imp_file.imp05    #FUN-BB0083 add
DEFINE g_imp20_t       LIKE imp_file.imp20    #FUN-BB0083 add
DEFINE g_imp23_t       LIKE imp_file.imp23    #FUN-BB0083 add
#DEFINE l_img_table      STRING                #FUN-C70087  #FUN-CC0095
#DEFINE l_imgg_table     STRING                #FUN-C70087  #FUN-CC0095
#FUN-D10081---add---str---
DEFINE g_imo_l DYNAMIC ARRAY OF RECORD
               imo01   LIKE imo_file.imo01,
               smydesc LIKE smy_file.smydesc,
               imo02   LIKE imo_file.imo02,
               imo03   LIKE imo_file.imo03,
               imo04   LIKE imo_file.imo04,
               imo05   LIKE imo_file.imo05,
               imo06   LIKE imo_file.imo06,
               gen02   LIKE gen_file.gen02,
               imo08   LIKE imo_file.imo08,
               gem02   LIKE gem_file.gem02,
               imoconf LIKE imo_file.imoconf,
               imopost LIKE imo_file.imopost,
               imo07   LIKE imo_file.imo07
               END RECORD,
        l_ac4      LIKE type_file.num5,
        g_rec_b4   LIKE type_file.num5,
        g_action_flag  STRING
DEFINE   w     ui.Window
DEFINE   f     ui.Form
DEFINE   page  om.DomNode
#FUN-D10081---add---end---

MAIN
 
    OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
#FUN-A80106 add --start--
    LET g_cmd ='aimt306_icd'
    LET g_prog='aimt306_icd'
#FUN-A80106 add --end--
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AIM")) THEN
       EXIT PROGRAM
    END IF
    
    #CALL s_padd_img_create() RETURNING l_img_table   #FUN-C70087  #FUN-CC0095
    #CALL s_padd_imgg_create() RETURNING l_imgg_table #FUN-C70087  #FUN-CC0095
 
    LET g_argv1=ARG_VAL(1)           #TQC-630052
    LET g_argv2=ARG_VAL(2)           #TQC-630052
 
    CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
    LET p_row = 3 LET p_col = 2
    
    LET g_sql = "imo01.imo_file.imo01,",
                "imo02.imo_file.imo02,",
                "imo03.imo_file.imo03,",
                "imo04.imo_file.imo04,",
                "imo05.imo_file.imo05,",
                "imo06.imo_file.imo06,",
                "imoconf.imo_file.imoconf,",   #MOD-890194 add
                "imopost.imo_file.imopost,",   #MOD-890194 add
                "imp02.imp_file.imp02,",
                "imp03.imp_file.imp03,",        
                "imp04.imp_file.imp04,",
                "imp05.imp_file.imp05,",
                "imp06.imp_file.imp06,",
                "imp07.imp_file.imp07,",
                "imp11.imp_file.imp11,",
                "imp12.imp_file.imp12,",
                "imp13.imp_file.imp13,",
                "ima02.ima_file.ima02,",
                "ima021.ima_file.ima021"
   LET l_table = cl_prt_temptable('aimt306',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?)"    #MOD-890194  add ?,?
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",status,1) EXIT PROGRAM
   END IF         
    OPEN WINDOW t306_w AT p_row,p_col             #顯示畫面
        WITH FORM "aim/42f/aimt306"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    # 先以g_argv2判斷直接執行哪種功能，執行Q時，g_argv1是單號(imo01)
    # 執行I時，g_argv1是單號(imo01)
    IF g_aza.aza115 ='Y' THEN                    #FUN-CB0087
       CALL cl_set_comp_required('imp16',TRUE)   #FUN-CB0087 
    END IF                                       #FUN-CB0087
    
    IF NOT cl_null(g_argv1) THEN
       CASE g_argv2
          WHEN "query"
             LET g_action_choice = "query"
             IF cl_chk_act_auth() THEN
                CALL t306_q()
             END IF
          WHEN "insert"
             LET g_action_choice = "insert"
             IF cl_chk_act_auth() THEN
                CALL t306_a()
             END IF
          OTHERWISE
                CALL t306_q()
       END CASE
    END IF
 
    CALL t306_mu_ui()
 
 
    CALL t306()
    CLOSE WINDOW t306_w                    #結束畫面
    #CALL s_padd_img_drop(l_img_table)    #FUN-C70087  #FUN-CC0095
    #CALL s_padd_imgg_drop(l_imgg_table)  #FUN-C70087  #FUN-CC0095
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
FUNCTION t306()
 
    LET g_forupd_sql =
      " SELECT * FROM imo_file WHERE imo01 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t306_cl CURSOR FROM g_forupd_sql
 
    CALL t306_menu()
END FUNCTION
 
#QBE 查詢資料
FUNCTION t306_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    CLEAR FORM                                    #清除畫面
   CALL g_imp.clear()
 
    INITIALIZE g_imo.* TO NULL
   IF cl_null(g_argv1) THEN  #TQC-630052
    INITIALIZE g_imo.* TO NULL   #FUN-640213
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
                      imo01,imo02,imo03,imo04,imo05,imo06,imo08,imoconf,imospc,imopost,imo07, #FUN-670093 #FUN-680010
                      imouser,imogrup,
                      imooriu,imoorig,       #TQC-B10062 add 
                      imomodu,imodate
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imo01) #借料單號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_imo"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imo01
                    NEXT FIELD imo01
               WHEN INFIELD(imo03) #廠商編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imo03
                    NEXT FIELD imo03
               WHEN INFIELD(imo05) #會計科目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imo05
                    NEXT FIELD imo05
               WHEN INFIELD(imo06) #借料人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imo06
                    NEXT FIELD imo06
               WHEN INFIELD(imo08)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gem"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.default1 = g_imo.imo08
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imo08
                  NEXT FIELD imo08
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
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imouser', 'imogrup')
 
 
    CONSTRUCT g_wc2 ON imp02,imp03,imp05,imp04,imp08,imp09,imp07,
                       imp11,imp12,imp13,imp14,imp23,imp25,
                       imp20,imp22,imp06,imp15,imp16,imp930   #No.FUN-5C0077 #FUN-670093 #FUN-CB0087 imp16
                       ,impiicd028,impiicd029   #FUN-B30187
                                            # 螢幕上取單身條件
         FROM s_imp[1].imp02,s_imp[1].imp03,s_imp[1].imp05,
              s_imp[1].imp04,s_imp[1].imp08,s_imp[1].imp09,
              s_imp[1].imp07,s_imp[1].imp11,s_imp[1].imp12,
              s_imp[1].imp13,s_imp[1].imp14,s_imp[1].imp23,
              s_imp[1].imp25,s_imp[1].imp20,s_imp[1].imp22,
              s_imp[1].imp06,s_imp[1].imp15,s_imp[1].imp16,    #No.FUN-5C0077   #FUN-CB0087 imp16
              s_imp[1].imp930 #FUN-670093
              ,s_imp[1].impiicd028,s_imp[1].impiicd029   #FUN-B30187
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imp03) #品號
            #No.FUN-A90048 -----------start--------------------------
            #        CALL cl_init_qry_var()
            #        LET g_qryparam.form = "q_ima"
            #        LET g_qryparam.state = 'c'
            #        CALL cl_create_qry() RETURNING g_qryparam.multiret
                    CALL q_sel_ima( TRUE, "q_ima","","","","","","","",'')  
                              RETURNING  g_qryparam.multiret
            #No.FUN-A90048 ------------end---------------------------
                    DISPLAY g_qryparam.multiret TO imp03
                    NEXT FIELD imp03
               WHEN INFIELD(imp05) #借料單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imp05
                    NEXT FIELD imp05
                WHEN INFIELD(imp11)
                   #No.FUN-AA0049--begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form     = "q_imd"
                   #LET g_qryparam.state    = "c"
                   #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_imd_1(TRUE,TRUE,"","","","","") RETURNING g_qryparam.multiret 
                   #No.FUN-AA0049--end
                   DISPLAY g_qryparam.multiret TO imp11
                   NEXT FIELD imp11
                WHEN INFIELD(imp12)
                   #No.FUN-AA0049--begin
                   #CALL cl_init_qry_var()
                   #LET g_qryparam.form     = "q_ime"
                   #LET g_qryparam.state    = "c"
                   #CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","") RETURNING g_qryparam.multiret
                   #No.FUN-AA0049--end
                   DISPLAY g_qryparam.multiret TO imp12
                   NEXT FIELD imp12
               WHEN INFIELD(imp14) #借料單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO imp14
                    NEXT FIELD imp14

              
              
              WHEN INFIELD(imp23)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imp23
                 NEXT FIELD imp23
              WHEN INFIELD(imp20)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO imp20
                 NEXT FIELD imp20
               WHEN INFIELD(imp930)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form  = "q_gem4"
                  LET g_qryparam.state = "c"   #多選
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO imp930
                  NEXT FIELD imp930
               #FUN-B30187 --START--
               WHEN INFIELD(impiicd029)
                  CALL q_slot(TRUE,TRUE,g_imp[1].impiicd029,g_imp[1].imp13,'')                         
                   RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO impiicd029
                  NEXT FIELD impiicd029
               #FUN-B30187 --END--
               #FUN-CB0087---add---str
               WHEN INFIELD(imp16) #理由  
               CALL cl_init_qry_var()                                          
               LET g_qryparam.form     ="q_azf41"                        
               LET g_qryparam.state = "c"                                                                                                           
               CALL cl_create_qry() RETURNING g_qryparam.multiret                    
               DISPLAY g_qryparam.multiret TO imp16                                    
               NEXT FIELD imp16 
         #FUN-CB0087---add---end               
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
    IF INT_FLAG THEN 
       #LET INT_FLAG=0 #TQC-DB0075 mark
       RETURN 
    END IF
 
   ELSE
      LET g_wc =" imo01 = '",g_argv1,"'"  
      LET g_wc2 =" 1=1"  
   END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  imo01 FROM imo_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY imo01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE imo_file. imo01 ",
                   "  FROM imo_file, imp_file ",
                   " WHERE imo01 = imp01",
                   "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                   " ORDER BY imo01"
       #FUN-B30187 --START--
       IF g_wc2.getindexof('impi',1)>0 THEN
          LET g_sql = "SELECT UNIQUE imo_file.imo01 ",
                      " FROM imo_file, imp_file, impi_file ",
                      " WHERE imo01 = imp01",
                      " AND imp01 = impi01",
                      " AND imp02 = impi02",
                      " AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                      " ORDER BY imo01"
       END IF 
       #FUN-B30187 --END--
    END IF
 
    PREPARE t306_prepare FROM g_sql
    DECLARE t306_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR t306_prepare
    DECLARE t306_fill_cs CURSOR WITH HOLD FOR t306_prepare   #FUN-D10081 add
 
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imo_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT imo01) ",
                  "  FROM imo_file,imp_file ",
                  " WHERE imp01=imo01 ",
                  "   AND ",g_wc CLIPPED,
                  "   AND ",g_wc2 CLIPPED
       #FUN-B30187 --START--
       IF g_wc2.getindexof('impi',1)>0 THEN
          LET g_sql = "SELECT COUNT(DISTINCT imo01) ",
                      " FROM imo_file, imp_file, impi_file ",
                      " WHERE imo01 = imp01",
                      " AND imp01 = impi01",
                      " AND imp02 = impi02",
                      " AND ", g_wc CLIPPED,
                      " AND ", g_wc2 CLIPPED
       END IF 
       #FUN-B30187 --END--
    END IF
    PREPARE t306_precount FROM g_sql
    DECLARE t306_count CURSOR FOR t306_precount
END FUNCTION
 
FUNCTION t306_menu()
#FUN-A80106 add --start--
DEFINE l_imp             RECORD LIKE imp_file.*
DEFINE l_imaicd01        LIKE imaicd_file.imaicd01
DEFINE l_r               LIKE type_file.chr1  #FUN-C30302
DEFINE l_qty             LIKE type_file.num15_3  #FUN-C30302
#FUN-A80106 add --end--
 
   WHILE TRUE
      IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN      #FUN-D10081 add
         CALL t306_bp("G")
      #FUN-D10081---add---str---
      ELSE 
         CALL t306_list_fill()
         CALL t306_bp2("G")
         IF NOT cl_null(g_action_choice) AND l_ac4>0 THEN #將清單的資料回傳到主畫面
            SELECT imo_file.* INTO g_imo.*
              FROM imo_file
             WHERE imo01 = g_imo_l[l_ac4].imo01
         END IF 
         IF g_action_choice!= "" THEN
            LET g_action_flag = "page_main"
            LET l_ac4 = ARR_CURR()
            LET g_jump = l_ac4
            LET mi_no_ask = TRUE
            IF g_rec_b4 >0 THEN
               CALL t306_fetch('/')
            END IF
            CALL cl_set_comp_visible("page_list", FALSE)
            CALL cl_set_comp_visible("page_main", FALSE)
            CALL ui.interface.refresh()
            CALL cl_set_comp_visible("page_list", TRUE)
            CALL cl_set_comp_visible("page_main", TRUE)
         END IF
      END IF
      #FUN-D10081---add---end---
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t306_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t306_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t306_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t306_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               LET g_v = 'N'
               CALL t306_b()
            ELSE                           #TQC-D40025 Add
               LET g_action_choice = ""    #TQC-D40025 Add
            END IF
           #LET g_action_choice = ""       #TQC-D40025 Mark  
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL t306_out()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
       #@WHEN "確認"
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
                CALL t306_y()
                IF g_imo.imoconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
            END IF
       #@WHEN "取消確認"
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
                CALL t306_z()
                IF g_imo.imoconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
            END IF
       #@WHEN "作廢"
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t306_x()    #CHI-D20010
                CALL t306_x(1)   #CHI-D20010
                IF g_imo.imoconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
            END IF
       #CHI-D20010---begin
          WHEN "undo_void"
             IF cl_chk_act_auth() THEN
                CALL t306_x(2)
                IF g_imo.imoconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
             END IF
       #CHI-D20010---end  
#FUN-A80106 add --start--
       #@WHEN "單據刻號BIN查詢作業"
         WHEN "aic_s_icdqry"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_imo.imo01) THEN
               #入庫
               CALL s_icdqry(1,g_imo.imo01,'',g_imo.imopost,'')  
               END IF
            END IF
 
       #@WHEN 刻號/BIN號入庫明細
         WHEN "aic_s_icdin"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_imo.imo01) AND
                  g_imo.imopost = 'N' AND
                  NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  #避免畫面資料是舊的，所以重撈
                  INITIALIZE l_imp.* TO NULL
                  SELECT * INTO l_imp.* FROM imp_file
                   WHERE imp01 = g_imo.imo01 AND imp02 = g_imp[l_ac].imp02
                  #入庫
                  LET g_dies = 0
			            SELECT imaicd01 INTO l_imaicd01
			              FROM imaicd_file
			             WHERE imaicd00 = l_imp.imp03
                 CALL s_icdin(1,l_imp.imp03,l_imp.imp11,
                                l_imp.imp12,l_imp.imp13,
                                l_imp.imp14,l_imp.imp04,
                                g_imo.imo01,l_imp.imp02,
                                g_imo.imo02,'',
                                l_imaicd01,'','')
                      RETURNING g_dies,l_r,l_qty   #FUN-C30302
                 #FUN-C30302---begin
                 IF l_r = 'Y' THEN
                     LET l_qty = s_digqty(l_qty,l_imp.imp14) 
                     LET g_imp[l_ac].imp04 = l_qty
                     LET g_imp[l_ac].imp22 = l_qty
                     LET g_imp[l_ac].actu = l_qty
	                 UPDATE imp_file set imp04 = g_imp[l_ac].imp04,imp22 = g_imp[l_ac].imp22
                      WHERE imp01=g_imo.imo01 AND imp02=g_imp[l_ac].imp02
	                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
		                LET g_imp[l_ac].imp04 = b_imp.imp04
		                LET g_imp[l_ac].imp22 = b_imp.imp22
                        LET g_success = 'N'
	                 ELSE
		                LET b_imp.imp04 = g_imp[l_ac].imp04
		                LET b_imp.imp22 = g_imp[l_ac].imp22                
	                 END IF
	                 DISPLAY BY NAME g_imp[l_ac].imp04, g_imp[l_ac].imp22,
                                     g_imp[l_ac].actu
                 #FUN-C30302---end
                    CALL t306_ind_icd_upd_dies()
                 END IF  #FUN-C30302
               END IF
            END IF
#FUN-A80106 add --end--
       #@WHEN "過帳"
         WHEN "post"
            IF cl_chk_act_auth() THEN
                CALL t306_s()
                IF g_imo.imoconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
            END IF
       #@WHEN "過帳還原"
         WHEN "undo_post"
            IF cl_chk_act_auth() THEN
                CALL t306_w()
                IF g_imo.imoconf = 'X' THEN
                   LET g_void = 'Y'
                ELSE
                   LET g_void = 'N'
                END IF
                CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
            END IF
       #@WHEN "單價"
         WHEN "unit_price"
            IF cl_chk_act_auth() THEN
               LET g_v = 'Y'
               CALL t306_b()
               LET g_v = 'N'
            END IF
 
         WHEN "exporttoexcel" #FUN-4B0002
            LET w = ui.Window.getCurrent()   #FUN-D10081 add
            LET f = w.getForm()              #FUN-D10081 add
            IF cl_null(g_action_flag) OR g_action_flag = "page_main" THEN   #FUN-D10081 add
               IF cl_chk_act_auth() THEN
                  LET page = f.FindNode("Page","page_main")                 #FUN-D10081 add
                  #CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_imp),'','')  #FUN-D10081 mark
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imp),'','')  #FUN-D10081 add
               END IF
            #FUN-D10081---add---str---
            END IF 
            IF g_action_flag = "page_list" THEN
               LET page = f.FindNode("Page","page_list")
               IF cl_chk_act_auth() THEN
                  CALL cl_export_to_excel(page,base.TypeInfo.create(g_imo_l),'','')
               END IF
            END IF
            #FUN-D10081---add---end---     
 
         WHEN "trans_spc"         
            IF cl_chk_act_auth() THEN
               CALL t306_spc()
            END IF
 
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_imo.imo01 IS NOT NULL THEN
                 LET g_doc.column1 = "imo01"
                 LET g_doc.value1 = g_imo.imo01
                 CALL cl_doc()
               END IF
           END IF
#FUN-C50071 add begin-------------------------
         WHEN "qry_lot"  #批序號查詢
            IF l_ac > 0 THEN
               SELECT ima918,ima921 INTO g_ima918,g_ima921
                 FROM ima_file
                WHERE ima01 = g_imp[l_ac].imp03
                  AND imaacti = "Y"

               IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                  LET g_success = 'Y'
                  BEGIN WORK
                  LET g_img09 = ''   LET g_img10 = 0

                  SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
                   WHERE img01 = g_imp[l_ac].imp03 AND img02 = g_imp[l_ac].imp11
                     AND img03 = g_imp[l_ac].imp12 AND img04 = g_imp[l_ac].imp13

                  CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp14,g_img09)
                     RETURNING l_i,l_fac
                  IF l_i = 1 THEN LET l_fac = 1 END IF

                  CALL s_mod_lot(g_prog,g_imo.imo01,g_imp[l_ac].imp02,0,
                               g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                               g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                               g_imp[l_ac].imp14,g_img09,
                               g_imp[l_ac].imp14_fac,g_imp[l_ac].imp04,'','QRY',1)
                     RETURNING l_r,g_qty
                  IF g_success = "Y" THEN
                     COMMIT WORK
                  ELSE
                     ROLLBACK WORK
                  END IF
               END IF
            END IF
#FUN-C50071 add -end--------------------------
      END CASE
   END WHILE
END FUNCTION
 
#Add  輸入
FUNCTION t306_a()
    DEFINE li_result   LIKE type_file.num5          #No.FUN-550029  #No.FUN-690026 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_imp.clear()
    INITIALIZE g_imo.* LIKE imo_file.*             #DEFAULT 設定
    LET g_imo01_t = NULL
    #預設值及將數值類變數清成零
    LET g_imo_t.* = g_imo.*
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imo.imo07='N'
        LET g_imo.imoconf='N'
        LET g_imo.imospc ='0' #FUN-680010
        LET g_imo.imopost='N'
        LET g_imo.imouser=g_user
        LET g_imo.imooriu = g_user #FUN-980030
        LET g_imo.imoorig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_imo.imogrup=g_grup
        LET g_imo.imodate=g_today
        LET g_imo.imo02=g_today         #借料日期為系統日期
        LET g_imo.imo06=g_user
        LET g_imo.imo08=g_grup  #FUN-670093
        LET g_imo.imoplant = g_plant #FUN-980004 add 
        LET g_imo.imolegal = g_legal #FUN-980004 add 
        CALL t306_i("a")                #輸入單頭
        IF INT_FLAG THEN                #使用者不玩了
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            INITIALIZE g_imo.* TO NULL
            EXIT WHILE
        END IF
        BEGIN WORK #No:7857
        CALL s_auto_assign_no("aim",g_imo.imo01,g_imo.imo02,"","imo_file","imo01",   #No.FUN-5C0077
                  "","","")
                  RETURNING li_result,g_imo.imo01
           IF (NOT li_result) THEN
             CONTINUE WHILE
           END IF
 
	#進行輸入之單號檢查
	CALL s_mfgchno(g_imo.imo01) RETURNING g_i,g_imo.imo01
	DISPLAY BY NAME g_imo.imo01
	IF NOT g_i THEN CONTINUE WHILE END IF
 
        INSERT INTO imo_file VALUES (g_imo.*)
        IF SQLCA.sqlcode THEN           # 置入資料庫不成功
        #    ROLLBACK WORK #No:7857   #FUN-B80070---回滾放在報錯後---
            CALL cl_err3("ins","imo_file",g_imo.imo01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            ROLLBACK WORK         #FUN-B80070 add 
            CONTINUE WHILE
        ELSE
            COMMIT WORK #No:7857
            CALL cl_flow_notify(g_imo.imo01,'I')
        END IF
        SELECT imo01 INTO g_imo.imo01 FROM imo_file
            WHERE imo01 = g_imo.imo01
        LET g_imo01_t = g_imo.imo01        #保留舊值
        LET g_imo_t.* = g_imo.*
        CALL g_imp.clear()
        LET g_rec_b = 0   #No.FUN-5C0077
        CALL t306_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t306_u()
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_imo.* FROM imo_file WHERE imo01=g_imo.imo01
    IF g_imo.imo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_imo.imoconf='Y' THEN CALL cl_err(g_imo.imo01,'9023',0) RETURN END IF
    IF g_imo.imopost='Y' THEN CALL cl_err(g_imo.imo01,'aar-347',0) RETURN END IF
    IF g_imo.imoconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
 
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imo01_t = g_imo.imo01
    LET g_imo_o.* = g_imo.*
    BEGIN WORK
 
    OPEN t306_cl USING g_imo.imo01
    IF STATUS THEN
       CALL cl_err("OPEN t306_cl:", STATUS, 1)
       CLOSE t306_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t306_cl INTO g_imo.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t306_cl ROLLBACK WORK RETURN
    END IF
    CALL t306_show()
    WHILE TRUE
        LET g_imo01_t = g_imo.imo01
        LET g_imo.imomodu=g_user
        LET g_imo.imodate=g_today
        CALL t306_i("u")                      #欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imo.*=g_imo_t.*
            CALL t306_show()
            CALL cl_err('','9001',0)
            EXIT WHILE
        END IF
        IF g_imo.imo01 != g_imo01_t THEN            # 更改單號
            UPDATE imp_file SET imp01 = g_imo.imo01
                WHERE imp01 = g_imo01_t
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","imp_file",g_imo01_t,"",SQLCA.sqlcode,"",
                            "imp",0)  #No.FUN-660156
               CONTINUE WHILE 
            END IF
        END IF
        #FUN-B30187 --START--
        IF g_imo.imo01 != g_imo01_t THEN            # 更改單號
           UPDATE impi_file SET impi01 = g_imo.imo01
                   WHERE impi01 = g_imo01_t
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","impi_file",g_imo01_t,"",SQLCA.sqlcode,"",
                               "impi",0)  #No.FUN-660156
                  CONTINUE WHILE 
               END IF
        END IF                
        #FUN-B30187 --END--
        UPDATE imo_file SET imo_file.* = g_imo.* WHERE imo01 = g_imo01_t
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","imo_file",g_imo_t.imo01,"",SQLCA.sqlcode,"",
                         "",0)  #No.FUN-660156
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t306_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imo.imo01,'U')
END FUNCTION
 
#處理INPUT
FUNCTION t306_i(p_cmd)
DEFINE
       p_cmd     LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       l_flag    LIKE type_file.chr1     #判斷必要欄位是否有輸入  #No.FUN-690026 VARCHAR(1)
DEFINE li_result LIKE type_file.num5     #No.FUN-550029  #No.FUN-690026 SMALLINT
DEFINE l_gem02   LIKE gem_file.gem02     #FUN-670093
DEFINE l_aag05   LIKE aag_file.aag05     #No.FUN-B40004
 
    DISPLAY BY NAME                              # 顯示單頭值
                    g_imo.imo01,g_imo.imo02,g_imo.imo03,
                    g_imo.imo04,g_imo.imo05,
                    g_imo.imo06,g_imo.imo08,g_imo.imo07, #FUN-670093
                    g_imo.imoconf,g_imo.imospc,g_imo.imopost,g_imo.imouser,#FUN-680010
                    g_imo.imogrup,g_imo.imomodu,g_imo.imodate
    
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT BY NAME g_imo.imo01,g_imo.imo02,g_imo.imo03, g_imo.imooriu,g_imo.imoorig,
                  g_imo.imo04,g_imo.imo05,g_imo.imo06,g_imo.imo08 #FUN-670093
                  WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t306_set_entry(p_cmd)
            CALL t306_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("imo01")
 
        AFTER FIELD imo02        #借料日期不可空白
	    IF g_imo.imo02 IS NULL THEN
                LET g_imo.imo02=g_today
            END IF
            DISPLAY g_imo.imo02 to imo02
              LET li_result = 0
              CALL s_daywk(g_imo.imo02) RETURNING li_result
	      IF li_result = 0 THEN #非工作日
                 CALL cl_err(g_imo.imo02,'mfg3152',0)
	         NEXT FIELD imo02
	      END IF
	      IF li_result = 2 THEN #未設定
                 CALL cl_err(g_imo.imo02,'mfg3153',0)
	         NEXT FIELD imo02
	      END IF
	      
            	      
            CALL s_yp(g_imo.imo02) RETURNING l_year,l_prd
            #---->與目前會計年度,期間比較,如日期大於目前會計年度,期間則不可過
            IF (l_year*12+l_prd) > (g_sma.sma51*12+g_sma.sma52)
               THEN CALL cl_err('','mfg6091',0) NEXT FIELD imo02
            END IF
	    IF g_sma.sma53 IS NOT NULL AND g_imo.imo02 <= g_sma.sma53 THEN
		CALL cl_err('','mfg9999',0) NEXT FIELD imo02
	    END IF
            CALL s_get_bookno(YEAR(g_imo.imo02))    #TQC-740042
                 RETURNING g_flag,g_bookno1,g_bookno2
            IF g_flag =  '1' THEN  #抓不到帳別
               CALL cl_err(g_imo.imo02,'aoo-081',1)
               NEXT FIELD imo02 
            END IF
 
 
        AFTER FIELD imo01       #借料單號(不可空白)
            CALL s_check_no("aim",g_imo.imo01,g_imo01_t,"6","imo_file","imo01","")
                 RETURNING li_result,g_imo.imo01
            DISPLAY BY NAME g_imo.imo01
            IF (NOT li_result) THEN
                   NEXT FIELD imo01
            END IF
            DISPLAY g_smy.smydesc TO FORMONLY.smydesc
 
#               #進行輸入之單號檢查
                CALL s_mfgchno(g_imo.imo01) RETURNING g_i,g_imo.imo01
                DISPLAY BY NAME g_imo.imo01
                IF NOT g_i THEN NEXT FIELD imo01 END IF
 
        AFTER FIELD imo03   #MAKER ID.
            IF NOT cl_null(g_imo.imo03) THEN
               CALL t306_imo03()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  LET g_imo.imo03 = g_imo_t.imo03
                  DISPLAY BY NAME g_imo.imo03
                  NEXT FIELD imo03
               END IF
            END IF
 
        AFTER FIELD imo05      #貸方科目
            IF g_imo.imo05 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                IF NOT s_actchk3(g_imo.imo05,g_bookno1) THEN  #No.FUN-730033
                    CALL cl_err(g_imo.imo05,'mfg0018',0)
                    #FUN-B10049--begin
                    CALL cl_init_qry_var()                                         
                    LET g_qryparam.form ="q_aag"                                   
                    LET g_qryparam.default1 = g_imo.imo05  
                    LET g_qryparam.construct = 'N'                
                    LET g_qryparam.arg1 = g_bookno1  
                    LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imo.imo05 CLIPPED,"%' "       
                    CALL cl_create_qry() RETURNING g_imo.imo05
                    DISPLAY BY NAME g_imo.imo05  
                    #FUN-B10049--end                        
                    NEXT FIELD imo05
                END IF
               END IF
            END IF
 
        AFTER FIELD imo06    #借料人員,不可空白
          IF NOT cl_null(g_imo.imo06) THEN
              CALL t306_imo06('d') #檢查員工資料檔
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 LET g_imo.imo06 = g_imo_t.imo06
                 DISPLAY BY NAME g_imo.imo06
                 NEXT FIELD imo06
              END IF
          #FUN-CB0087---add---str---
             IF NOT t306_imp16_chk2() THEN
                LET g_imo.imo06 = g_imo_t.imo06
                NEXT FIELD imo06
             END IF  
          #FUN-CB0087---add---end---
          END IF
        AFTER FIELD imo08
            IF NOT cl_null(g_imo.imo08) THEN
               SELECT gem02 INTO l_gem02 FROM gem_file
                WHERE gem01=g_imo.imo08
                  AND gemacti='Y'
               IF STATUS THEN
                  CALL cl_err3("sel","gem_file",g_imo.imo08,"",SQLCA.sqlcode,"",
                               "select gem",1)
                  NEXT FIELD imo08
               END IF
               DISPLAY l_gem02 TO gem02
               #No.FUN-B40004  --Begin
               LET l_aag05=''
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01 = g_imo.imo05
                  AND aag00 = g_aza.aza81
               IF l_aag05 = 'Y' THEN
                  #當使用利潤中心時(aaz90=Y),允許/拒絕部門的判斷請改用會科+成本中心
                  IF g_aaz.aaz90 !='Y' THEN
                     LET g_errno = ' '
                     CALL s_chkdept(g_aaz.aaz72,g_imo.imo05,g_imo.imo08,g_aza.aza81)
                          RETURNING g_errno
                  END IF
               END IF
               IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imo.imo08,g_errno,0)
                 LET g_imo.imo08 = g_imo_t.imo08
                 DISPLAY BY NAME g_imo.imo08
                 NEXT FIELD imo08
              END IF 
               #No.FUN-B40004  --End
              #FUN-CB0087---add---str---
              IF NOT t306_imp16_chk2() THEN
                 LET g_imo.imo08 = g_imo_t.imo08
                 NEXT FIELD imo08
              END IF  
              #FUN-CB0087---add---end---
            END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_imo.imouser = s_get_data_owner("imo_file") #FUN-C10039
           LET g_imo.imogrup = s_get_data_group("imo_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN
                EXIT INPUT
            END IF
            IF g_imo.imo01 IS NULL THEN  #借料單號
               LET l_flag='Y'
               DISPLAY BY NAME g_imo.imo01
            END IF
            IF g_imo.imo02 IS NULL THEN  #借料日期
               LET l_flag='Y'
               DISPLAY BY NAME g_imo.imo02
            END IF
 
            IF l_flag='Y' THEN
                 CALL cl_err('','9033',0)
                 NEXT FIELD imo01
            END IF
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imo01) #查詢單据
                    LET g_t1=s_get_doc_no(g_imo.imo01)     #No.FUN-550029
                    CALL q_smy(FALSE,FALSE,g_t1,'AIM','6') RETURNING g_t1 #TQC-670008
                    LET g_imo.imo01=g_t1                   #No.FUN-550029
                    DISPLAY BY NAME g_imo.imo01
                    NEXT FIELD imo01
               WHEN INFIELD(imo03) #廠商編號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc"
                    LET g_qryparam.default1 = g_imo.imo03
                    CALL cl_create_qry() RETURNING g_imo.imo03
                    DISPLAY BY NAME g_imo.imo03
                    NEXT FIELD imo03
               WHEN INFIELD(imo05) #會計科目
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_aag"
                    LET g_qryparam.default1 = g_imo.imo05
                    LET g_qryparam.arg1 = g_bookno1   #No.FUN-730033
                    CALL cl_create_qry() RETURNING g_imo.imo05
                    DISPLAY BY NAME g_imo.imo05
                    NEXT FIELD imo05
               WHEN INFIELD(imo06) #借料人員
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.default1 = g_imo.imo06
                    CALL cl_create_qry() RETURNING g_imo.imo06
                    DISPLAY BY NAME g_imo.imo06
                    NEXT FIELD imo06
               WHEN INFIELD(imo08)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gem"
                    LET g_qryparam.default1 = g_imo.imo08
                    CALL cl_create_qry() RETURNING g_imo.imo08
                    DISPLAY BY NAME g_imo.imo08
                    NEXT FIELD imo08
               OTHERWISE EXIT CASE
            END CASE
        ON ACTION CONTROLF
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
 
FUNCTION t306_imo06(p_cmd)    #人員
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_gen02     LIKE gen_file.gen02,
         l_genacti   LIKE gen_file.genacti
 
  LET g_errno = ' '
  SELECT gen02,genacti INTO l_gen02,l_genacti
    FROM gen_file WHERE gen01 = g_imo.imo06
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                 LET l_gen02 = NULL
       WHEN l_genacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF p_cmd='d' THEN
     DISPLAY l_gen02 TO FORMONLY.gen02
  END IF
END FUNCTION
 
FUNCTION t306_imo03()        #廠商簡稱
  DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         l_pmc03     LIKE pmc_file.pmc03,
         l_pmcacti   LIKE pmc_file.pmcacti
 
  LET g_errno = ' '
  SELECT pmc03,pmcacti INTO g_imo.imo04,l_pmcacti
    FROM pmc_file WHERE pmc01 = g_imo.imo03
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
                                 LET g_imo.imo04=NULL
       WHEN l_pmcacti='N' LET g_errno = '9028'
       WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  DISPLAY BY NAME g_imo.imo04
END FUNCTION
 
#Query 查詢
FUNCTION t306_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_imo.* TO NULL             #No.FUN-680046
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_imp.clear()
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t306_cs()
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t306_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imo.* TO NULL
    ELSE
        OPEN t306_count
        FETCH t306_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t306_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
#處理資料的讀取
FUNCTION t306_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式  #No.FUN-690026 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t306_cs INTO g_imo.imo01
        WHEN 'P' FETCH PREVIOUS t306_cs INTO g_imo.imo01
        WHEN 'F' FETCH FIRST    t306_cs INTO g_imo.imo01
        WHEN 'L' FETCH LAST     t306_cs INTO g_imo.imo01
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
            FETCH ABSOLUTE g_jump t306_cs INTO g_imo.imo01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)
        INITIALIZE g_imo.* TO NULL  #TQC-6B0105
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
    SELECT * INTO g_imo.* FROM imo_file WHERE imo01 = g_imo.imo01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","imo_file",g_imo.imo01,"",SQLCA.sqlcode,"",
                     "",0)  #No.FUN-660156
        INITIALIZE g_imo.* TO NULL
        RETURN
    ELSE
        LET g_data_owner = g_imo.imouser #FUN-4C0053
        LET g_data_group = g_imo.imogrup #FUN-4C0053
        LET g_data_plant = g_imo.imoplant #FUN-980030
    END IF
    CALL s_get_bookno(YEAR(g_imo.imo02)) #TQC-740042
         RETURNING g_flag,g_bookno1,g_bookno2
    IF g_flag =  '1' THEN  #抓不到帳別
       CALL cl_err(g_imo.imo02,'aoo-081',1)
    END IF
 
    CALL t306_show()
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t306_show()
  DEFINE l_smydesc   LIKE smy_file.smydesc
    LET g_imo_t.* = g_imo.*                #保存單頭舊值
    DISPLAY BY NAME g_imo.imooriu,g_imo.imoorig,                              # 顯示單頭值
        g_imo.imo01,g_imo.imo02,g_imo.imo03,
        g_imo.imo04,g_imo.imo05,
        g_imo.imo06,g_imo.imo08,g_imo.imo07, #FUN-670093
        g_imo.imoconf,g_imo.imospc,g_imo.imopost,g_imo.imouser,g_imo.imogrup,g_imo.imomodu,#FUN-680010
        g_imo.imodate
 
 
    LET g_t1=s_get_doc_no(g_imo.imo01)     #No.FUN-550029
    SELECT smydesc INTO l_smydesc
      FROM smy_file
     WHERE smyslip = g_t1
    DISPLAY l_smydesc TO FORMONLY.smydesc
 
    CALL t306_imo06('d')
    DISPLAY s_costcenter_desc(g_imo.imo08) TO FORMONLY.gem02 #FUN-670093
    IF g_imo.imoconf = 'X' THEN
       LET g_void = 'Y'
    ELSE
       LET g_void = 'N'
    END IF
    CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
    CALL t306_b_fill(g_wc2)                 #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
#取消整筆 (所有合乎單頭的資料)
FUNCTION t306_r()
#FUN-A80106 add --start--
DEFINE l_flag   LIKE type_file.chr1 
#FUN-A80106 add --end--

    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_imo.* FROM imo_file WHERE imo01=g_imo.imo01
    IF cl_null(g_imo.imo01) THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_imo.imoconf = 'Y' OR g_imo.imoconf = 'X' THEN
        CALL cl_err(g_imo.imo01,'aim-073',0)                   #TQC-B10062 9021->aim-073
        RETURN
    END IF
    IF g_imo.imo07 = 'Y' THEN
        CALL cl_err(g_imo.imo01,'aec-078',0)  #已結案 !!
        RETURN
    END IF
    BEGIN WORK
 
    OPEN t306_cl USING g_imo.imo01
    IF STATUS THEN
       CALL cl_err("OPEN t306_cl:", STATUS, 1)
       CLOSE t306_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t306_cl INTO g_imo.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t306_cl ROLLBACK WORK RETURN
    END IF
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imo01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imo.imo01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
#FUN-A80106 add --start--
        LET g_cnt = 0
        #入庫
        SELECT COUNT(*) INTO g_cnt FROM ida_file
         WHERE ida07 = g_imo.imo01
        IF g_cnt > 0 THEN
           #此單號項次已有刻號/BIN明細資料,將一併刪除,是否確定執行此動作？
           IF NOT cl_confirm('aic-112') THEN
              CLOSE t306_cl
              ROLLBACK WORK
              RETURN
           ELSE
              LET g_cnt = 0
              #入庫
              CALL s_icdinout_del(1,g_imo.imo01,'','')  #FUN-B80119--傳入p_plant參數''---
                   RETURNING l_flag
              IF l_flag = 0 THEN
                 CLOSE t306_cl
                 ROLLBACK WORK
                 RETURN
              END IF
            END IF
        END IF
#FUN-A80106 add --end--        
         DELETE FROM imo_file WHERE imo01 = g_imo.imo01
         DELETE FROM imp_file WHERE imp01 = g_imo.imo01
        #FUN-B30187 --START--
        IF NOT s_del_impi(g_imo.imo01,'','') THEN
           #不作處理        
        END IF
        #FUN-B30187 --END--
#FUN-C50071 add begin-------------------------
        FOR l_i = 1 TO g_rec_b
            IF NOT s_lot_del(g_prog,g_imo.imo01,'',0,g_imp[l_i].imp03,'DEL') THEN
              ROLLBACK WORK
              RETURN
            END IF
        END FOR
#FUN-C50071 add -end--------------------------
         INITIALIZE g_imo.* TO NULL
         CLEAR FORM
         CALL g_imp.clear()
         OPEN t306_count
         #FUN-B50062-add-start--
         IF STATUS THEN
            CLOSE t306_cs
            CLOSE t306_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         FETCH t306_count INTO g_row_count
         #FUN-B50062-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t306_cs
            CLOSE t306_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50062-add-end--
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t306_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t306_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE
            CALL t306_fetch('/')
         END IF
    END IF
    CLOSE t306_cl
    COMMIT WORK
    CALL cl_flow_notify(g_imo.imo01,'D')
END FUNCTION
 
#單身
FUNCTION t306_b()
DEFINE
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用  #No.FUN-690026 SMALLINT
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_possible      LIKE type_file.num5,   #用來設定判斷重複的可能性  #No.FUN-690026 SMALLINT
    l_ima02         LIKE ima_file.ima02,   #品名規格
    l_ima05         LIKE ima_file.ima05,   #目前版本
    l_ima08         LIKE ima_file.ima08,   #來源碼
    l_ima25         LIKE ima_file.ima25,   #庫存單位
    l_imp10         LIKE imp_file.imp10,
    l_direct        LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
    l_code          LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(07)
    l_azo05         LIKE azo_file.azo05,
    l_azo06         LIKE azo_file.azo06,
    l_date          LIKE type_file.dat,    #No.FUN-690026 DATE
    l_ccz01         LIKE ccz_file.ccz01,
    l_ccz02         LIKE ccz_file.ccz02,
    l_allow_insert  LIKE type_file.num5,   #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5    #可刪除否  #No.FUN-690026 SMALLINT  
#FUN-A80106 add --start--
DEFINE   l_flag     LIKE type_file.chr1       #判斷BIN/刻號處理成功否
#DEFINE   l_imaicd08 LIKE imaicd_file.imaicd08 #刻號明細維護   #FUN-BA0051 mark
DEFINE   l_imaicd01 LIKE imaicd_file.imaicd01 
DEFINE   l_imp03    LIKE imp_file.imp03
DEFINE   l_act      LIKE type_file.chr1
DEFINE   l_r        LIKE type_file.chr1  #FUN-C30302
DEFINE   l_qty      LIKE type_file.num15_3  #FUN-C30302
DEFINE   l_imaicd09 LIKE imaicd_file.imaicd09  #TQC-C60020
#FUN-A80106 add --end--
DEFINE   l_case     STRING                 #FUN-BB0083 add  
DEFINE l_flag1          LIKE type_file.chr1     #FUN-CB0087
DEFINE l_where         STRING                  #FUN-CB0087   
DEFINE l_sql           STRING                  #FUN-CB0087
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_imo.* FROM imo_file WHERE imo01=g_imo.imo01
    IF cl_null(g_imo.imo01) THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_imo.imoconf = 'X' THEN
        CALL cl_err(g_imo.imo01,'9022',0)
        RETURN
    END IF
    IF g_imo.imo07 = 'Y' THEN
        CALL cl_err(g_imo.imo01,'aec-078',0)  #已結案 !!
        RETURN
    END IF
    IF (g_imo.imoconf = 'Y' ) THEN
        IF g_v = 'Y' THEN
            SELECT ccz01,ccz02 INTO l_ccz01,l_ccz02 FROM ccz_file
            LET l_date = MDY(l_ccz02,1,l_ccz01) #現行成本結算年度期別
            IF g_imo.imo02 < l_date THEN
                #只可維護單據年期大於等於現行成本結算年度期別的單據資料
                CALL cl_err('','aim-115',0)
                RETURN
            END IF
             IF NOT t306_chk_sma() THEN RETURN END IF #MOD-4A0201
        ELSE
            CALL cl_err(g_imo.imo01,'9022',0)
            RETURN
        END IF
    ELSE
        IF g_v = 'Y' THEN
           CALL cl_err(g_imo.imo01,'aap-717',0)
           RETURN
        END IF
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
      "SELECT imp02,imp03,'','','','', ",    #No.MOD-480340
     "       imp05,imp04,imp09,imp11,imp12,imp13,'',imp14,imp14_fac,",
     "       imp23,imp24,imp25,imp20,imp21,imp22,'', ",
     "       imp06,imp08,imp07,imp15,imp16,'',imp930,'','','' ",   #No.FUN-5C0077 #FUN-670093 #FUN-B30187  #FUN-CB0087 imp16,''
     "   FROM imp_file ",
     "    WHERE imp01 = ? ",
     "    AND imp02 = ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t306_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
    
    #FUN-B30187 --START--
    LET g_forupd_sql = " SELECT impiicd028,impiicd029 FROM impi_file ",
                          "  WHERE impi01 = ? ",
                          "    AND impi02 = ? ",
                          "    FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t306_bcl_ind CURSOR FROM g_forupd_sql
    #FUN-B30187 --END--
    
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
    IF l_allow_insert AND g_v = 'Y' THEN
        LET l_allow_insert = FALSE
    END IF
    IF l_allow_delete AND g_v = 'Y' THEN
        LET l_allow_delete = FALSE
    END IF
 
    IF g_rec_b = 0 THEN CALL g_imp.clear() END IF  #No.FUN-5C0077
 
    INPUT ARRAY g_imp WITHOUT DEFAULTS FROM s_imp.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           LET g_before_input_done = FALSE
           CALL t306_set_entry_b(p_cmd)
           CALL t306_set_no_entry_b(p_cmd)
           LET g_before_input_done = TRUE
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           LET p_cmd=''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
#FUN-A80106 add --start--
            LET l_act = NULL
#FUN-A80106 add --end--
           BEGIN WORK
           OPEN t306_cl USING g_imo.imo01
           IF STATUS THEN
              CALL cl_err("OPEN t306_cl:", STATUS, 1)
              CLOSE t306_cl
              ROLLBACK WORK
              RETURN
           ELSE
              FETCH t306_cl INTO g_imo.*            # 鎖住將被更改或取消的資料
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
                 CLOSE t306_cl
                 ROLLBACK WORK
                 RETURN
              END IF
           END IF
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_imp_t.* = g_imp[l_ac].*  #BACKUP
              #FUN-BB0083---add---str
              LET g_imp05_t = g_imp[l_ac].imp05
              LET g_imp23_t = g_imp[l_ac].imp23
              LET g_imp20_t = g_imp[l_ac].imp20
              #FUN-BB0083---add---end
              OPEN t306_bcl USING g_imo.imo01,g_imp_t.imp02
              IF STATUS THEN
                 CALL cl_err("OPEN t306_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH t306_bcl INTO g_imp[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_imp_t.imp02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 #FUN-B30187 --START--
                 ELSE 
                    OPEN t306_bcl_ind USING g_imo.imo01,g_imp_t.imp02
                    IF STATUS THEN
                       CALL cl_err("OPEN t306_bcl_ind:", STATUS, 1)
                       LET l_lock_sw = "Y"
                    ELSE 
                       FETCH t306_bcl_ind INTO g_imp[l_ac].impiicd028,g_imp[l_ac].impiicd029
                       IF SQLCA.sqlcode THEN
                          CALL cl_err('lock impi',SQLCA.sqlcode,1)
                          LET l_lock_sw = "Y"
                       END IF 
                    END IF
                 #FUN-B30187 --END--
                 END IF
                 LET g_imp[l_ac].gem02c=s_costcenter_desc(g_imp[l_ac].imp930) #FUN-670093
              END IF
              CALL t306_azf03_desc()    #TQC-D20042 add
              CALL t306_imp03(p_cmd)
              CALL t306_imp13_a()
              CALL cl_show_fld_cont()     #FUN-550037(smin)
              LET g_change='N'
              CALL t306_set_entry_b(p_cmd)
              CALL t306_set_no_entry_b(p_cmd)
              CALL t306_set_no_required_impiicd028()   #FUN-B30187
              CALL t306_set_required_impiicd028(p_cmd) #FUN-B30187
              CALL t306_set_no_required_impiicd029()   #FUN-B30187
              CALL t306_set_required_impiicd029(p_cmd) #FUN-B30187
               #TQC-C60020---begin
               IF NOT cl_null(g_imp[l_ac].imp03) THEN 
                  SELECT imaicd09 INTO l_imaicd09 FROM imaicd_file
                   WHERE imaicd00 = g_imp[l_ac].imp03
                  IF l_imaicd09 = 'Y' THEN
                     CALL cl_set_comp_entry('impiicd028',TRUE)
                  ELSE
                     CALL cl_set_comp_entry('impiicd028',FALSE)
                  END IF 
               END IF 
               #TQC-C60020---end
           END IF
 
        AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF g_sma.sma12 = 'Y' THEN
              IF cl_null(g_imp[l_ac].imp11) THEN
                 #此欄位不可空白, 請輸入資料!
                 CALL cl_err('','aap-099',0)
                 NEXT FIELD imp11
              END IF
           END IF
           IF g_sma.sma115 = 'Y' THEN
              CALL s_chk_va_setting(g_imp[l_ac].imp03)
                   RETURNING g_flag,g_ima906,g_ima907
              IF g_flag=1 THEN
                 NEXT FIELD imp03
              END IF
              CALL t306_du_data_to_correct()
           END IF
           CALL t306_set_origin_field()
           IF NOT cl_null(g_imp[l_ac].imp04) AND NOT cl_null(g_imp[l_ac].imp09) THEN
              LET l_imp10 = g_imp[l_ac].imp04 * g_imp[l_ac].imp09
           ELSE
              LET l_imp10 = 0
           END IF
#FUN-A80106 add --start--
	    #   料號為參考單位,單一單位,且狀態為其它段生產料號(imaicd04=3,4)時,
            #   將單位一的資料給單位二
            CALL t306_ind_icd_set_value()
#FUN-A80106 add --end--

#FUN-C50071 add begin-------------------------
            SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
               WHERE ima01 = g_imp[l_ac].imp03
                 AND imaacti = 'Y'

            IF (g_ima918 = 'Y' OR g_ima921 = 'Y') AND g_imp[l_ac].imp15 = 'N'
               AND (g_imp[l_ac].imp04 <> g_imp_t.imp04 OR cl_null(g_imp_t.imp04)) THEN
               LET g_success = 'Y'
               LET g_img09 = ''

               SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01 = g_imp[l_ac].imp03
                    AND img02 = g_imp[l_ac].imp11
                    AND img03 = g_imp[l_ac].imp12
                    AND img04 = g_imp[l_ac].imp13

              CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp14,g_img09)
                 RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF

              CALL s_mod_lot(g_prog,g_imo.imo01,g_imp[l_ac].imp02,0,
                           g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                           g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                           g_imp[l_ac].imp14,g_img09,
                           g_imp[l_ac].imp14_fac,g_imp[l_ac].imp04,'','MOD',1)
                 RETURNING l_r,g_qty
              IF l_r = "Y" THEN
                 LET g_imp[l_ac].imp04 = g_qty
              END IF
            END IF
            LET g_success = 'Y'
            IF s_chk_rvbs('',g_imp[l_ac].imp03) THEN
               CALL t306_rvbs()
            END IF
            IF g_success = 'N' THEN
               CANCEL INSERT
               NEXT FIELD imp02
            END IF
#FUN-C50071 add -end--------------------------
           LET g_success = 'Y'   #FUN-B30187           
 
           INSERT INTO imp_file (imp01,imp02,imp03,imp04,imp05,
                                 imp06,imp07,imp08,imp09,imp10,
                                 imp11,imp12,imp13,imp14,imp14_fac,
                                 imp20,imp21,imp22,imp23,imp24,imp25,imp15,imp16,imp930,impplant,implegal) #FUN-670093 #FUN-980004 add impplant,implegal #FUN-CB0087 imp16
           VALUES(g_imo.imo01,g_imp[l_ac].imp02,
                  g_imp[l_ac].imp03,g_imp[l_ac].imp04,
                  g_imp[l_ac].imp05,g_imp[l_ac].imp06,
                  g_imp[l_ac].imp07,g_imp[l_ac].imp08,
                  g_imp[l_ac].imp09,l_imp10,
                  g_imp[l_ac].imp11,g_imp[l_ac].imp12,
                  g_imp[l_ac].imp13,g_imp[l_ac].imp14,
                  g_imp[l_ac].imp14_fac,
                  g_imp[l_ac].imp20,g_imp[l_ac].imp21,
                  g_imp[l_ac].imp22,g_imp[l_ac].imp23,
                  g_imp[l_ac].imp24,g_imp[l_ac].imp25,
                  g_imp[l_ac].imp15,g_imp[l_ac].imp16,g_imp[l_ac].imp930,g_plant,g_legal)   #No.FUN-5C0077  #FUN-670093 #FUN-980004 add g_plant,g_legal   #FUN-CB0087 imp16
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","imp_file",g_imo.imo01,g_imp[l_ac].imp02,
                            SQLCA.sqlcode,"","",0)  #No.FUN-660156
              LET g_success = 'N'   #FUN-B30187                            
              CANCEL INSERT              
#FUN-C50071 add begin-------------------------
              SELECT ima918,ima921 INTO g_ima918,g_ima921
                 FROM ima_file
                 WHERE ima01 = g_imp[l_ac].imp03
                   AND imaacti = 'Y'

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                 IF NOT s_lot_del(g_prog,g_imo.imo01,g_imp[l_ac].imp02,0,g_imp[l_ac].imp03,'DEL') THEN
                    CALL cl_err3("del","rvbs_file",g_imo.imo01,g_imp_t.imp02,
                                  SQLCA.sqlcode,"","",1)
                 END IF
              END IF
#FUN-C50071 add -end--------------------------
           ELSE
              #FUN-B30187 --START--
              LET b_impi.impi01 = g_imo.imo01
              LET b_impi.impi02 = g_imp[l_ac].imp02
              LET b_impi.impiicd028 = g_imp[l_ac].impiicd028
              LET b_impi.impiicd029 = g_imp[l_ac].impiicd029
              LET b_impi.impilegal = g_legal
              LET b_impi.impiplant = g_plant              
              IF NOT s_ins_impi(b_impi.*,g_plant) THEN
                 LET g_success = 'N'  
                 CANCEL INSERT
              END IF
              #FUN-B30187 --END--
           END IF 

           IF g_success = 'Y' THEN   ##FUN-B30187
              MESSAGE 'INSERT O.K'
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
#FUN-A80106 add --start--
	          LET l_act = 'a'
#FUN-A80106 add --end--              
           END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_imp[l_ac].* TO NULL      #900423
            LET g_imp[l_ac].imp07 = 'N'
            LET g_imp[l_ac].imp08 = 0
            LET g_imp[l_ac].imp21=1
            LET g_imp[l_ac].imp24=1
            LET g_change='Y'
            LET g_imp[l_ac].imp15 = 'N'
            LET g_imp[l_ac].imp930 = s_costcenter(g_imo.imo08) #FUN-670093
            LET g_imp[l_ac].gem02c = s_costcenter_desc(g_imp[l_ac].imp930) #FUN-670093
            LET g_imp_t.* = g_imp[l_ac].*         #新輸入資料
            #FUN-BB0083---add---str
            LET g_imp05_t = NULL
            LET g_imp23_t = NULL
            LET g_imp20_t = NULL
            #FUN-BB0083---add---end
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD imp02
 
 
        BEFORE FIELD imp02                        #default 序號
            IF g_imp[l_ac].imp02 IS NULL OR g_imp[l_ac].imp02 = 0 THEN
               SELECT max(imp02)+1
                 INTO g_imp[l_ac].imp02
                 FROM imp_file
                WHERE imp01 = g_imo.imo01
               IF g_imp[l_ac].imp02 IS NULL THEN
                  LET g_imp[l_ac].imp02 = 1
               END IF
            END IF
 
        AFTER FIELD imp02                        #check 序號是否重複
           IF g_imp[l_ac].imp02 IS NULL THEN
              LET g_imp[l_ac].imp02 = g_imp_t.imp02
           END IF
           IF NOT cl_null(g_imp[l_ac].imp02) THEN
              IF g_imp[l_ac].imp02 != g_imp_t.imp02 OR g_imp_t.imp02 IS NULL THEN
                 SELECT count(*) INTO l_n FROM imp_file
                  WHERE imp01 = g_imo.imo01
                    AND imp02 = g_imp[l_ac].imp02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_imp[l_ac].imp02 = g_imp_t.imp02
                    NEXT FIELD imp02
                 END IF
              END IF
           END IF
#FUN-A80106 add --start--
           #若已有ida/idb存在不可修改--(S)
           IF p_cmd = 'u' AND NOT cl_null(g_imp[l_ac].imp02) THEN
              IF g_imp_t.imp02 <> g_imp[l_ac].imp02 THEN
                 CALL t306_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imp[l_ac].imp02 = g_imp_t.imp02
                    NEXT FIELD imp02
                 END IF
              END IF
           END IF
           #若已有ida/idb存在不可修改--(E)
#FUN-A80106 add --end--          
 
        BEFORE FIELD imp03
	   IF g_sma.sma60 = 'Y' THEN      # 若須分段輸入
              CALL s_inp5(11,14,g_imp[l_ac].imp03) RETURNING g_imp[l_ac].imp03
              DISPLAY BY NAME g_imp[l_ac].imp03
              IF INT_FLAG THEN LET INT_FLAG = 0 END IF
      	   END IF
           CALL t306_set_entry_b(p_cmd)
           CALL t306_set_no_required()
           CALL t306_set_no_required_impiicd028()   #FUN-B30187
           CALL t306_set_no_required_impiicd029()   #FUN-B30187          
 
        AFTER FIELD imp03 #料件編號
           IF NOT cl_null(g_imp[l_ac].imp03) THEN
#NO.FUN-A90048 add -----------start--------------------     
              IF NOT s_chk_item_no(g_imp[l_ac].imp03,'') THEN
                 CALL cl_err('',g_errno,1)
                 LET g_imp[l_ac].imp03= g_imp_t.imp03 
                 NEXT FIELD imp03
              END IF
#NO.FUN-A90048 add ------------end --------------------   
           
              CALL t306_imp03(p_cmd)
              IF g_chr='L' THEN #Locked
                 CALL cl_err(g_imp[l_ac].imp03,'aoo-060',0)
                 NEXT FIELD imp03
              END IF
              IF g_chr='E' THEN
                 CALL cl_err(g_imp[l_ac].imp03,'mfg0016',0)
                 NEXT FIELD imp03
              END IF
#FUN-A80106 add --start--
	         #若已有ida/idb存在不可修改--(S)
           IF p_cmd = 'u' AND NOT cl_null(g_imp[l_ac].imp03) THEN
              IF g_imp_t.imp03 <> g_imp[l_ac].imp03 THEN
                 CALL t306_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imp[l_ac].imp03 = g_imp_t.imp03
                    NEXT FIELD imp03
                 END IF
              END IF
           END IF
#FUN-A80106 add --end--              
              IF cl_null(g_imp_t.imp03) OR g_imp[l_ac].imp03<>g_imp_t.imp03 THEN
                 LET g_change = 'Y'
              END IF
              IF g_sma.sma115 = 'Y' THEN
                 CALL s_chk_va_setting(g_imp[l_ac].imp03)
                      RETURNING g_flag,g_ima906,g_ima907
                 IF g_flag=1 THEN
                    NEXT FIELD imp03
                 END IF
                 IF g_ima906 = '3' THEN
                    LET g_imp[l_ac].imp23=g_ima907
                 END IF
              END IF
           END IF
           CALL t306_set_no_entry_b(p_cmd)
           CALL t306_set_required()
           CALL t306_set_required_impiicd028(p_cmd)   #FUN-B30187
           CALL t306_set_required_impiicd029(p_cmd)   #FUN-B30187          
 
        AFTER FIELD imp04 #借料數量
           #FUN-BB0083---add---str
           IF NOT t306_imp04_check() THEN
              NEXT FIELD imp04
           END IF            
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---str
           #IF NOT cl_null(g_imp[l_ac].imp04) THEN
           #   IF g_imp[l_ac].imp04 <=0 THEN
           #      CALL cl_err(g_imp[l_ac].imp04,'mfg6109',0)
           #      NEXT FIELD imp04
           #   END IF
           #END IF
           #FUN-BB0083---mark---end
 
        AFTER FIELD imp05  #借料單位
           IF NOT cl_null(g_imp[l_ac].imp05) THEN
              CALL t306_unit(g_imp[l_ac].imp05)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD imp05
              END IF
              #檢查該借料單位與主檔之單位是否可以轉換
              CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp05,m_imo.ima25)
                   RETURNING g_cnt,m_imo.ima25_fac
              IF g_cnt = 1 THEN
                 CALL cl_err('','mfg3075',0)
                 NEXT FIELD imp05
              END IF
              IF p_cmd = 'u' AND g_imp[l_ac].imp05 != g_imp_t.imp05 THEN
                 CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp05,
                        g_imp[l_ac].imp14)
                 RETURNING g_cnt,g_imp[l_ac].imp14_fac
	          LET g_imp[l_ac].actu=g_imp[l_ac].imp04*g_imp[l_ac].imp14_fac
                  DISPLAY g_imp[l_ac].imp14_fac TO imp14_fac  #No.MOD-490371
                  DISPLAY g_imp[l_ac].actu      TO actu       #No.MOD-490371
              END IF
              #FUN-BB0083---add---str
              IF NOT t306_imp04_check() THEN
                 LET g_imp05_t = g_imp[l_ac].imp05
                 NEXT FIELD imp04
              END IF 
              LET g_imp05_t = g_imp[l_ac].imp05
              #FUN-BB0083---add---end
	       END IF
           
 
        BEFORE FIELD imp23
           CALL t306_set_no_required()
 
        AFTER FIELD imp23  #第二單位
           IF cl_null(g_imp[l_ac].imp03) THEN NEXT FIELD imp03 END IF
           IF g_imp[l_ac].imp11 IS NULL OR g_imp[l_ac].imp12 IS NULL OR
              g_imp[l_ac].imp13 IS NULL THEN
              NEXT FIELD imp11
           END IF
           IF NOT cl_null(g_imp[l_ac].imp23) THEN
              CALL t306_unit(g_imp[l_ac].imp23)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD imp23
              END IF
              CALL s_du_umfchk(g_imp[l_ac].imp03,'','','',
                               g_img09,g_imp[l_ac].imp23,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imp[l_ac].imp23,g_errno,0)
                 NEXT FIELD imp23
              END IF
              LET g_imp[l_ac].imp24 = g_factor
              CALL s_chk_imgg(g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                              g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                              g_imp[l_ac].imp23) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD imp23
                    END IF
                 END IF
                 CALL s_add_imgg(g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                                 g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                                 g_imp[l_ac].imp23,g_imp[l_ac].imp24,
                                 g_imo.imo01,
                                 g_imp[l_ac].imp02,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imp23
                 END IF
              END IF
           END IF
           
           CALL t306_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
           #FUN-BB0083---add---str
           IF NOT cl_null(g_imp[l_ac].imp23) THEN
              IF NOT t306_imp25_check() THEN
                 LET g_imp23_t = g_imp[l_ac].imp23
                 NEXT FIELD imp25
              END IF 
              LET g_imp23_t = g_imp[l_ac].imp23
           END IF
           #FUN-BB0083---add---end
 
        BEFORE FIELD imp25
           IF cl_null(g_imp[l_ac].imp03) THEN NEXT FIELD imp03 END IF
           IF g_imp[l_ac].imp11 IS NULL OR g_imp[l_ac].imp12 IS NULL OR
              g_imp[l_ac].imp13 IS NULL THEN
              NEXT FIELD imp13
           END IF
           IF NOT cl_null(g_imp[l_ac].imp23) AND g_ima906 = '3' THEN
              CALL s_du_umfchk(g_imp[l_ac].imp03,'','','',
                               g_img09,g_imp[l_ac].imp23,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imp[l_ac].imp23,g_errno,0)
                 NEXT FIELD imp11
              END IF
              LET g_imp[l_ac].imp24 = g_factor
              CALL s_chk_imgg(g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                              g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                              g_imp[l_ac].imp23) RETURNING g_flag
              IF g_flag = 1 THEN
                 IF g_sma.sma892[3,3] = 'Y' THEN
                    IF NOT cl_confirm('aim-995') THEN
                       NEXT FIELD imp03
                    END IF
                 END IF
                 CALL s_add_imgg(g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                                 g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                                 g_imp[l_ac].imp23,g_imp[l_ac].imp24,
                                 g_imo.imo01,
                                 g_imp[l_ac].imp02,0) RETURNING g_flag
                 IF g_flag = 1 THEN
                    NEXT FIELD imp03
                 END IF
              END IF
           END IF
 
        AFTER FIELD imp25  #第二數量
           #FUN-BB0083---add---str
           IF NOT t306_imp25_check() THEN
              NEXT FIELD imp25
           END IF            
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---end
           #IF NOT cl_null(g_imp[l_ac].imp25) THEN
           #   IF g_imp[l_ac].imp25 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD imp25
           #   END IF
           #   IF p_cmd = 'a' THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_imp[l_ac].imp25*g_imp[l_ac].imp24
           #         IF cl_null(g_imp[l_ac].imp22) OR g_imp[l_ac].imp22=0 THEN #No.CHI-960022
           #            LET g_imp[l_ac].imp22=g_tot*g_imp[l_ac].imp21
           #            DISPLAY BY NAME g_imp[l_ac].imp22                      #CHI-960022
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #END IF
           
           #CALL cl_show_fld_cont()                   #No.FUN-560197
 
        BEFORE FIELD imp20
           CALL t306_set_no_required()
 
        AFTER FIELD imp20  #第一單位
           IF cl_null(g_imp[l_ac].imp03) THEN NEXT FIELD imp03 END IF
           IF g_imp[l_ac].imp11 IS NULL OR g_imp[l_ac].imp12 IS NULL OR
              g_imp[l_ac].imp13 IS NULL THEN
              NEXT FIELD imp13
           END IF
           IF NOT cl_null(g_imp[l_ac].imp20) THEN
              CALL t306_unit(g_imp[l_ac].imp20)
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err('',g_errno,0)
                 NEXT FIELD imp20
              END IF
              CALL s_du_umfchk(g_imp[l_ac].imp03,'','','',
                               g_imp[l_ac].imp05,g_imp[l_ac].imp20,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_imp[l_ac].imp20,g_errno,0)
                 NEXT FIELD imp20
              END IF
              LET g_imp[l_ac].imp21 = g_factor
              IF g_ima906 = '2' THEN
                 CALL s_chk_imgg(g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                                 g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                                 g_imp[l_ac].imp20) RETURNING g_flag
                 IF g_flag = 1 THEN
                    IF g_sma.sma892[3,3] = 'Y' THEN
                       IF NOT cl_confirm('aim-995') THEN
                          NEXT FIELD imp20
                       END IF
                    END IF
                    CALL s_add_imgg(g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                                    g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                                    g_imp[l_ac].imp20,g_imp[l_ac].imp21,
                                    g_imo.imo01,
                                    g_imp[l_ac].imp02,0) RETURNING g_flag
                    IF g_flag = 1 THEN
                       NEXT FIELD imp20
                    END IF
                 END IF
              END IF
           END IF
           
           CALL t306_set_required()
           CALL cl_show_fld_cont()                   #No.FUN-560197
           #FUN-BC0109 --START mark-- 在此檢查imp22會造成多單位無法跳至借料數量欄位輸入
           ##FUN-BB0083---add---str           
           #IF NOT cl_null(g_imp[l_ac].imp20) THEN
           #   CALL t306_imp22_check() RETURNING l_case
           #   LET g_imp20_t = g_imp[l_ac].imp20
           #   CASE l_case
           #      WHEN "imp22"
           #         NEXT FIELD imp22
           #      WHEN "imp11"
           #         NEXT FIELD imp11
           #      WHEN "imp25"
           #         NEXT FIELD imp25
           #      OTHERWISE EXIT CASE
           #   END CASE 
           #END IF
           ##FUN-BB0083---add---end
           #FUN-BC0109 --END mark--
           #TQC-C20183---add---str---
           IF NOT cl_null(g_imp[l_ac].imp20) THEN
              LET g_imp[l_ac].imp22 = s_digqty(g_imp[l_ac].imp22,g_imp[l_ac].imp20)
              DISPLAY BY NAME g_imp[l_ac].imp22
           END IF
           #TQC-C20183---add---end---
#FUN-A80106 add --start--
	         IF p_cmd = 'u' AND g_sma.sma115 = 'Y' THEN  #修改且多單位
              IF NOT cl_null(g_imp[l_ac].imp20) THEN
                 LET g_ima906 = NULL
                 SELECT ima906 INTO g_ima906 FROM ima_file
                  WHERE ima01 = g_imp[l_ac].imp03
                 IF NOT cl_null(g_ima906) AND g_ima906 MATCHES '[13]' THEN
                    IF g_imp_t.imp20 <> g_imp[l_ac].imp20 THEN
                       CALL t306_ind_icd_chk_icd()
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,0)
                          LET g_imp[l_ac].imp20 = g_imp_t.imp20
                          NEXT FIELD imp20
                       END IF
                    END IF
                 END IF
              END IF
           END IF
#FUN-A80106 add --end--
 
        AFTER FIELD imp22  #第一數量
           #FUN-BB0083---add---str
           CALL t306_imp22_check() RETURNING l_case
           CASE l_case
                 WHEN "imp22"
                    NEXT FIELD imp22
                 WHEN "imp11"
                    NEXT FIELD imp11
                 WHEN "imp25"
                    NEXT FIELD imp25
                 OTHERWISE EXIT CASE
              END CASE 
           #FUN-BB0083---add---end
           #FUN-BB0083---mark---str
           #IF NOT cl_null(g_imp[l_ac].imp22) THEN
           #   IF g_imp[l_ac].imp22 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD imp22
           #   END IF
           #END IF
           #CALL t306_du_data_to_correct()
           #CALL t306_set_origin_field()
           #IF g_imp[l_ac].imp04 <=0 THEN
           #   CALL cl_err(g_imp[l_ac].imp04,'mfg6109',0)
           #   IF g_ima906 MATCHES '[23]' THEN
           #      NEXT FIELD imp25
           #   ELSE
           #      NEXT FIELD imp22
           #   END IF
           #END IF
           #CALL t306_unit(g_imp[l_ac].imp05)
           #IF NOT cl_null(g_errno) THEN
           #   CALL cl_err('',g_errno,0)
           #   NEXT FIELD imp11
           #END IF
           ##檢查該借料單位與主檔之單位是否可以轉換
           #CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp05,m_imo.ima25)
           #     RETURNING g_cnt,m_imo.ima25_fac
           #IF g_cnt = 1 THEN
           #   CALL cl_err('imp05/ima25','mfg3075',0)
           #   NEXT FIELD imp11
           #END IF
           #CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp05,
           #       g_imp[l_ac].imp14)
           #RETURNING g_cnt,g_imp[l_ac].imp14_fac
           #IF g_cnt = 1 THEN
           #   CALL cl_err('imp05/imp14','mfg3075',0)
           #   NEXT FIELD imp11
	       #END IF
           #FUN-BB0083---mark---end
 
        AFTER FIELD imp06 #預償日期
           IF NOT cl_null(g_imp[l_ac].imp06) THEN
               IF g_imp[l_ac].imp06 < g_imo.imo02 THEN
                  CALL cl_err(g_imp[l_ac].imp06,'mfg6110',0)
                  NEXT FIELD imp06
               END IF
           END IF
 
        AFTER FIELD imp11  #倉庫
            IF NOT cl_null(g_imp[l_ac].imp11) THEN
               #FUN-D20060--add--str--
               IF NOT s_chksmz(g_imp[l_ac].imp03, g_imo.imo01,
                               g_imp[l_ac].imp11, g_imp[l_ac].imp12) THEN
                  NEXT FIELD imp11
               END IF
               #FUN-D20060--add--end--
                #No.FUN-AA0049--begin
                IF NOT s_chk_ware(g_imp[l_ac].imp11) THEN
                   NEXT FIELD imp11
                END IF 
                #No.FUN-AA0049--end                
                #------>check-1
                IF NOT s_imfchk1(g_imp[l_ac].imp03,g_imp[l_ac].imp11)
                   THEN CALL cl_err(g_imp[l_ac].imp11,'mfg9036',0)
                        NEXT FIELD imp11
                END IF
                #------>check-2
                CALL  s_stkchk(g_imp[l_ac].imp11,'A') RETURNING l_code
                IF l_code = 0 THEN
                   CALL cl_err(g_imp[l_ac].imp11,'mfg4020',0)
                   NEXT FIELD imp11
                END IF
                #----->檢查倉庫是否為可用倉
                CALL  s_swyn(g_imp[l_ac].imp11) RETURNING sn1,sn2
                IF sn1=1 AND g_imp[l_ac].imp11!=t_img02 THEN
                   CALL cl_err(g_imp[l_ac].imp11,'mfg6080',0)
                   LET t_img02=g_imp[l_ac].imp11
                   NEXT FIELD imp11
                ELSE
                  IF sn2=2 AND g_imp[l_ac].imp11!=t_img02 THEN
                     CALL cl_err(g_imp[l_ac].imp11,'mfg6085',0)
                     LET t_img02=g_imp[l_ac].imp11
                     NEXT FIELD imp11
                  END IF
                END IF
                LET sn1=0 LET sn2=0
                IF cl_null(g_imp_t.imp11) OR
                   g_imp_t.imp11 <> g_imp[l_ac].imp11 THEN
                   LET g_change='Y'
                END IF 
            END IF
#FUN-A80106 add --start--
           #若已有ida/idb存在不可修改--(S)
           IF p_cmd = 'u' AND NOT cl_null(g_imp[l_ac].imp11) THEN
              IF g_imp_t.imp11 <> g_imp[l_ac].imp11 THEN
                 CALL t306_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imp[l_ac].imp11 = g_imp_t.imp11
                    NEXT FIELD imp11
                 END IF
              END IF
           END IF
           #若已有ida/idb存在不可修改--(E)
#FUN-A80106 add --end--            
#IF NOT s_imechk(g_imp[l_ac].imp11,g_imp[l_ac].imp12) THEN NEXT FIELD imp12 END IF  #FUN-D40103 add #TQC-D50124 mark 
 
        AFTER FIELD imp12  #儲位
           #BugNo:5626 控管是否為全型空白
           IF g_imp[l_ac].imp12 = '　' THEN #全型空白
               LET g_imp[l_ac].imp12 =' '
           END IF
           IF g_imp[l_ac].imp12 IS NULL THEN LET g_imp[l_ac].imp12=' ' END IF
           #------------------------------------ 檢查料號預設倉儲及單別預設倉儲
           IF NOT cl_null(g_imp[l_ac].imp11)  THEN #FUN-D20060
              IF NOT s_chksmz(g_imp[l_ac].imp03, g_imo.imo01,
                              g_imp[l_ac].imp11, g_imp[l_ac].imp12) THEN
                 NEXT FIELD imp11
              END IF
           END IF   #FUN-D20060
#------>chk-1
          IF NOT s_imfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp11,g_imp[l_ac].imp12)
             THEN CALL cl_err(g_imp[l_ac].imp12,'mfg6095',0)
                  NEXT FIELD imp12
          END IF
	 #IF NOT s_imechk(g_imp[l_ac].imp11,g_imp[l_ac].imp12) THEN NEXT FIELD imp12 END IF  #FUN-D40103 add #TQC-D50124 mark
 
#---->需存在倉庫/儲位檔中
          IF g_imp[l_ac].imp12 IS NOT NULL THEN
             CALL s_hqty(g_imp[l_ac].imp03,g_imp[l_ac].imp11,g_imp[l_ac].imp12)
                  RETURNING g_cnt,g_img19,g_imf05
             IF g_img19 IS NULL THEN LET g_img19=0 END IF
             LET h_qty=g_img19
             CALL  s_lwyn(g_imp[l_ac].imp11,g_imp[l_ac].imp12) RETURNING sn1,sn2
              IF sn1=1 AND g_imp[l_ac].imp12!=t_img03
                 THEN CALL cl_err(g_imp[l_ac].imp12,'mfg6080',0)
                      LET t_img03=g_imp[l_ac].imp12
                      NEXT FIELD imp12
              ELSE IF sn2=2 AND g_imp[l_ac].imp12!=t_img03
                      THEN CALL cl_err(g_imp[l_ac].imp12,'mfg6085',0)
                      LET t_img03=g_imp[l_ac].imp12
                      NEXT FIELD imp12
                   END IF
              END IF
              LET sn1=0 LET sn2=0
          END IF
          LET l_direct='D'
{&}       IF g_imp[l_ac].imp12 IS NULL THEN LET g_imp[l_ac].imp12 = ' ' END IF
          IF g_imp_t.imp12 IS NULL OR
             g_imp_t.imp12 <> g_imp[l_ac].imp12 THEN
             LET g_change='Y'
          END IF
#FUN-A80106 add --start--
	        IF p_cmd = 'u' THEN
             IF cl_null(g_imp_t.imp12) THEN LET g_imp_t.imp12 = ' ' END IF
             IF g_imp_t.imp12 <> g_imp[l_ac].imp12 THEN
                CALL t306_ind_icd_chk_icd()
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   LET g_imp[l_ac].imp12 = g_imp_t.imp12
                   NEXT FIELD imp12
                END IF
             END IF
          END IF
#FUN-A80106 add --end--          
 
        AFTER FIELD imp13  # 批號
           #BugNo:5626 控管是否為全型空白
           IF g_imp[l_ac].imp13 = '　' THEN #全型空白
               LET g_imp[l_ac].imp13 =' '
           END IF
           IF g_imp[l_ac].imp13 IS NULL THEN LET g_imp[l_ac].imp13 = ' ' END IF
           IF cl_null(g_imp[l_ac].imp12) THEN LET g_imp[l_ac].imp12 = ' ' END IF    #TQC-D10103 add  
           IF NOT cl_null(g_imp[l_ac].imp11) THEN
               SELECT * FROM img_file
                WHERE img01=g_imp[l_ac].imp03 AND img02=g_imp[l_ac].imp11
                  AND img03=g_imp[l_ac].imp12 AND img04=g_imp[l_ac].imp13
               IF STATUS=100 THEN
                  IF NOT cl_confirm('mfg1401') THEN NEXT FIELD imp11 END IF
                  CALL s_add_img(g_imp[l_ac].imp03,g_imp[l_ac].imp11,   #No.7304
                                 g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                                 g_imo.imo01,      g_imp[l_ac].imp02,
                                 g_imo.imo02)
               END IF
               CALL t306_imp13_a()
               IF g_imp[l_ac].imp05 IS NULL THEN
                  LET g_imp[l_ac].imp05=g_imp[l_ac].imp14
               END IF
               DISPLAY BY name g_imp[l_ac].imp05
               IF NOT s_actimg(g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                               g_imp[l_ac].imp12,g_imp[l_ac].imp13) THEN
                  CALL cl_err('inactive','mfg6117',0)
                  NEXT FIELD imp11
               END IF
	       LET g_imp[l_ac].actu=g_imp[l_ac].imp04*g_imp[l_ac].imp14_fac
               DISPLAY g_imp[l_ac].bala,g_imp[l_ac].actu
                     TO bala,actu                       #No.MOD-490371
               IF g_imp[l_ac].imp05 IS NULL THEN
                  LET g_imp[l_ac].imp05=g_imp[l_ac].imp14
               END IF
               LET l_direct='D'
               CALL t306_du_default(p_cmd)
           END IF
           IF g_imp_t.imp13 IS NULL OR
              g_imp_t.imp13 <> g_imp[l_ac].imp13 THEN
              LET g_change='Y'
           END IF
#FUN-A80106 add --start--
	         IF p_cmd = 'u' THEN
              IF cl_null(g_imp_t.imp13) THEN LET g_imp_t.imp13 = ' ' END IF
              IF g_imp_t.imp13 <> g_imp[l_ac].imp13 THEN
                 CALL t306_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imp[l_ac].imp13 = g_imp_t.imp13
                    NEXT FIELD imp13
                 END IF
              END IF
           END IF
           CALL t306_def_impiicd029()   #FUN-B30187 
#FUN-A80106 add --end--           
#FUN-A80106 add --start--
        AFTER FIELD imp14
	         IF p_cmd = 'u' AND g_sma.sma115 = 'N' AND
              NOT cl_null(g_imp[l_ac].imp14) THEN
              IF g_imp_t.imp14 <> g_imp[l_ac].imp14 THEN
                 CALL t306_ind_icd_chk_icd()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err('',g_errno,0)
                    LET g_imp[l_ac].imp14 = g_imp_t.imp14
                    NEXT FIELD imp14
                 END IF
              END IF
           END IF
#FUN-A80106 add --end--

        #FUN-CB0087---add---str---
        BEFORE FIELD imp16
            IF g_aza.aza115 = 'Y' AND cl_null(g_imp[l_ac].imp16) THEN 
               CALL s_reason_code(g_imo.imo01,'','',g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                                  g_imo.imo06,g_imo.imo08) RETURNING g_imp[l_ac].imp16
               DISPLAY BY NAME g_imp[l_ac].imp16
            END IF

        AFTER FIELD imp16
            IF t306_imp16_check() THEN
               CALL t306_azf03_desc()
            ELSE
               NEXT FIELD imp16
            END IF
        #FUN-CB0087---end---end---
        BEFORE FIELD imp09
            IF h_qty !=0   THEN   #零表不做最高限量控制
                IF (g_imp[l_ac].bala+g_imp[l_ac].actu) > h_qty     THEN
                    CALL cl_err(g_imp[l_ac].bala+g_imp[l_ac].actu,'mfg6094',1)
                END IF
            END IF
        AFTER FIELD imp09  #
            IF NOT cl_null(g_imp[l_ac].imp09) THEN
                IF g_imp[l_ac].imp09 < 0 THEN
                    #輸入值不可小於零!
                    CALL cl_err('','aim-391',0)
                    NEXT FIELD imp09
                END IF
                IF g_sma.sma12 != 'Y' AND g_imp[l_ac].imp14_fac IS NULL THEN
                    LET g_imp[l_ac].imp14_fac=1.0
                    DISPLAY BY NAME g_imp[l_ac].imp14_fac
                END IF
                LET l_direct='U'
            END IF
        AFTER FIELD imp930 
           IF NOT s_costcenter_chk(g_imp[l_ac].imp930) THEN
              LET g_imp[l_ac].imp930=g_imp_t.imp930
              LET g_imp[l_ac].gem02c=g_imp_t.gem02c
              DISPLAY BY NAME g_imp[l_ac].imp930,g_imp[l_ac].gem02c
              NEXT FIELD imp930
           ELSE
              LET g_imp[l_ac].gem02c=s_costcenter_desc(g_imp[l_ac].imp930)
              DISPLAY BY NAME g_imp[l_ac].gem02c
           END IF
        
        BEFORE DELETE                            #是否取消單身
            IF g_imp_t.imp02 > 0 AND
               g_imp_t.imp02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
#FUN-A80106 add --start--
             LET g_cnt = 0
             #入庫
             SELECT COUNT(*) INTO g_cnt FROM ida_file
              WHERE ida07 = g_imo.imo01
                AND ida08 = g_imp_t.imp02
             IF g_cnt > 0 THEN
                IF NOT cl_confirm('aic-112') THEN
                   CANCEL DELETE
                ELSE
                   LET g_cnt = 0
                   #入庫
                   CALL s_icdinout_del(1,g_imo.imo01,g_imp_t.imp02,'')  #FUN-B80119--傳入p_plant參數''---
                        RETURNING l_flag
                   IF l_flag = 0 THEN
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
             END IF
#FUN-A80106 add --end--                
#FUN-C50071 add begin-------------------------
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                   FROM ima_file
                   WHERE ima01 = g_imp[l_ac].imp03
                     AND imaacti = 'Y'

                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   IF NOT s_lot_del(g_prog,g_imo.imo01,g_imp[l_ac].imp02,0,g_imp[l_ac].imp03,'DEL') THEN
                      CALL cl_err3("del","rvbs_file",g_imo.imo01,g_imp_t.imp02,
                                    SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
#FUN-C50071 add -end--------------------------
                DELETE FROM imp_file
                    WHERE imp01 = g_imo.imo01 AND imp02 = g_imp_t.imp02
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","imp_file",g_imo.imo01,g_imp_t.imp02,
                                 SQLCA.sqlcode,"","",0)  #No.FUN-660156
                #FUN-B30187 -START--
                ELSE 
                   IF NOT s_del_impi(g_imo.imo01,g_imp_t.imp02,'') THEN
                   END IF
                #FUN-B30187 -END--
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
                COMMIT WORK
#FUN-C50071 add begin-------------------------
            ELSE
                SELECT ima918,ima921 INTO g_ima918,g_ima921
                   FROM ima_file
                   WHERE ima01 = g_imp[l_ac].imp03
                     AND imaacti = 'Y'

                IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                   IF NOT s_lot_del(g_prog,g_imo.imo01,g_imp[l_ac].imp02,0,g_imp[l_ac].imp03,'DEL') THEN
                      CALL cl_err3("del","rvbs_file",g_imo.imo01,g_imp_t.imp02,
                                    SQLCA.sqlcode,"","",1)
                      ROLLBACK WORK
                      CANCEL DELETE
                   END IF
                END IF
#FUN-C50071 add -end--------------------------
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_imp[l_ac].* = g_imp_t.*
               CLOSE t306_bcl
               CLOSE t306_bcl_ind   #FUN-B30187
               ROLLBACK WORK
               EXIT INPUT
            END IF
#FUN-A80106 add --start--
            IF cl_null(g_imp_t.imp12) THEN LET g_imp_t.imp12 = ' ' END IF
            IF cl_null(g_imp_t.imp13) THEN LET g_imp_t.imp13 = ' ' END IF
            IF cl_null(g_imp[l_ac].imp12) THEN
               LET g_imp[l_ac].imp12 = ' '
            END IF
            IF cl_null(g_imp[l_ac].imp13) THEN
               LET g_imp[l_ac].imp13 = ' '
            END IF
            IF g_imp_t.imp02 <> g_imp[l_ac].imp02 OR
               g_imp_t.imp03 <> g_imp[l_ac].imp03 OR
               g_imp_t.imp11 <> g_imp[l_ac].imp11 OR
               g_imp_t.imp12 <> g_imp[l_ac].imp12 OR
               g_imp_t.imp13 <> g_imp[l_ac].imp13 OR
               g_imp_t.imp14 <> g_imp[l_ac].imp14 THEN
               CALL t306_ind_icd_chk_icd()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('',g_errno,0)
                  NEXT FIELD imp03
               END IF
            END IF
#FUN-A80106 add --end--        
           #TQC-D10103---add---str---    
            IF NOT t306_imp16_check() THEN
               NEXT FIELD imp16
            END IF
           #TQC-D10103---add---end---
#FUN-C50071 add begin-------------------------
            SELECT ima918,ima921 INTO g_ima918,g_ima921
               FROM ima_file
               WHERE ima01 = g_imp[l_ac].imp03
                 AND imaacti = 'Y'

            IF (g_ima918 = 'Y' OR g_ima921 = 'Y') AND g_imp[l_ac].imp15 = 'N'
               AND (g_imp[l_ac].imp04 <> g_imp_t.imp04 OR cl_null(g_imp_t.imp04)) THEN
               LET g_success = 'Y'
               LET g_img09 = ''

               SELECT img09 INTO g_img09 FROM img_file
                  WHERE img01 = g_imp[l_ac].imp03
                    AND img02 = g_imp[l_ac].imp11
                    AND img03 = g_imp[l_ac].imp12
                    AND img04 = g_imp[l_ac].imp13

               CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp14,g_img09)
                  RETURNING l_i,l_fac
               IF l_i = 1 THEN LET l_fac = 1 END IF

               CALL s_mod_lot(g_prog,g_imo.imo01,g_imp[l_ac].imp02,0,
                            g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                            g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                            g_imp[l_ac].imp14,g_img09,
                            g_imp[l_ac].imp14_fac,g_imp[l_ac].imp04,'','MOD',1)
                  RETURNING l_r,g_qty
               IF l_r = "Y" THEN
                  LET g_imp[l_ac].imp04 = g_qty
               END IF
            END IF
#FUN-C50071 add -end--------------------------
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_imp[l_ac].imp03,-263,1)
               LET g_imp[l_ac].* = g_imp_t.*
            ELSE
                 IF g_sma.sma12 = 'Y' THEN
                     IF cl_null(g_imp[l_ac].imp11) THEN
                         #此欄位不可空白, 請輸入資料!
                         CALL cl_err('','aap-099',0)
                         NEXT FIELD imp11
                     END IF
                 END IF
                 IF g_sma.sma115 = 'Y' THEN
                    CALL s_chk_va_setting(g_imp[l_ac].imp03)
                         RETURNING g_flag,g_ima906,g_ima907
                    IF g_flag=1 THEN
                       NEXT FIELD imp03
                    END IF
                    CALL t306_du_data_to_correct()
                 END IF
                 CALL t306_set_origin_field()
                 IF NOT cl_null(g_imp[l_ac].imp04)
                            AND NOT cl_null(g_imp[l_ac].imp09) THEN
                    LET l_imp10 = g_imp[l_ac].imp04 * g_imp[l_ac].imp09
                 ELSE
                    LET l_imp10 = 0
                 END IF
#FUN-C50071 add begin-------------------------
                 LET g_success = 'Y'
                 IF s_chk_rvbs('',g_imp[l_ac].imp03) THEN
                    CALL t306_rvbs()
                 END IF
                 IF g_success = 'N' THEN
                    NEXT FIELD imp02
                 END IF
#FUN-C50071 add -end--------------------------

#FUN-A80106 add --start--
               #   料號為參考單位,單一單位,且狀態為其它段生產料號
               #   (imaicd04=3,4)時,將單位一的資料給單位二
               CALL t306_ind_icd_set_value()
#FUN-A80106 add --end-- 
                 LET g_success = 'Y'   #FUN-B30187
                 UPDATE imp_file SET
                               imp02=g_imp[l_ac].imp02,
                               imp03=g_imp[l_ac].imp03,imp04=g_imp[l_ac].imp04,
                               imp05=g_imp[l_ac].imp05,imp06=g_imp[l_ac].imp06,
                               imp09=g_imp[l_ac].imp09,imp10=l_imp10,
                               imp11=g_imp[l_ac].imp11,
                               imp12=g_imp[l_ac].imp12,imp13=g_imp[l_ac].imp13,
                               imp14=g_imp[l_ac].imp14,imp14_fac=g_imp[l_ac].imp14_fac,
                               imp20=g_imp[l_ac].imp20,imp21=g_imp[l_ac].imp21,
                               imp22=g_imp[l_ac].imp22,imp23=g_imp[l_ac].imp23,
                               imp24=g_imp[l_ac].imp24,imp25=g_imp[l_ac].imp25,
                               imp15=g_imp[l_ac].imp15,imp16=g_imp[l_ac].imp16,   #FUN-CB0087 imp16
                               imp930=g_imp[l_ac].imp930  #FUN-670093 #FUN-680010
                         WHERE imp01=g_imo.imo01
                           AND imp02=g_imp_t.imp02
                        IF SQLCA.sqlcode THEN
                           CALL cl_err3("upd","imp_file",g_imo.imo01,g_imp_t.imp02,
                                         SQLCA.sqlcode,"","",0)  #No.FUN-660156 
                            LET g_imp[l_ac].* = g_imp_t.*
                            LET g_success = 'N'
                        #FUN-B30187 --START--
                        ELSE 
                           UPDATE impi_file SET 
                                          impi02=g_imp[l_ac].imp02,
                                          impiicd028=g_imp[l_ac].impiicd028,
                                          impiicd029=g_imp[l_ac].impiicd029
                                  WHERE impi01=g_imo.imo01 AND impi02=g_imp_t.imp02
                           IF SQLCA.sqlcode THEN
                              CALL cl_err3("upd","impi_file",g_imo.imo01,g_imp_t.imp02,
                              SQLCA.sqlcode,"","upd impi",1) 
                              LET g_imp[l_ac].* = g_imp_t.*
                              LET g_success = 'N'
                           END IF
                        #FUN-B30187 --END--
                        END IF
                        #單價變更時INSERT 系統重要資料修改記錄[azo_file]
                        IF g_v = 'Y' THEN
                            #====>INSERT INTO azo_file
                            LET g_msg=TIME
                            LET l_azo05 = g_imo.imo01,'-',g_imp[l_ac].imp02 USING '####'
                            LET l_azo06 = g_imp_t.imp09 USING '#########.#####','---->',g_imp[l_ac].imp09 USING '#########.#####'
                            INSERT INTO azo_file (azo01    ,azo02 ,azo03  ,azo04  ,azo05  ,azo06 ,azoplant,azolegal ) #FUN-980004 add azoplant,azolegal
                                          VALUES ('aimt306',g_user,g_today,g_msg  ,l_azo05,l_azo06,g_plant,g_legal) #FUN-980004 add g_plant,g_legal
                            IF SQLCA.sqlcode THEN
                               CALL cl_err3("ins","azo_file","","",
                                             SQLCA.sqlcode,"","",1)  #No.FUN-660156 
                                LET g_success = 'N'
                            END IF
 
                            #====>UPDATE tlf_file
                            IF g_imo.imopost = 'Y' THEN
                                UPDATE tlf_file
                                   SET tlf21 = l_imp10,
                                       tlf221= l_imp10
                                 WHERE tlf01 =g_imp[l_ac].imp03
                                   AND tlf036=g_imo.imo01
                                   AND tlf037=g_imp[l_ac].imp02
                                   AND tlf03 =50
                                IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
                                    CALL cl_err3("upd","tlf_file",g_imp[l_ac].imp03,"",sqlca.sqlcode,"","UPDATE tlf err!",1)   #NO.FUN-640266  #No.FUN-660156
                                    LET g_success='N'
                                END IF
                            END IF
                        END IF
#FUN-A80106 add --start--
               IF g_success='Y' THEN
                  LET l_act = 'u'
               END IF
#FUN-A80106 add --end-- 
            END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
          #LET l_ac_t = l_ac       #FUN-D40030 Mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
#FUN-C50071 add begin-------------------------
              IF p_cmd = 'a' AND l_ac <= g_imp.getLength() THEN
                 SELECT ima918,ima921 INTO g_ima918,g_ima921
                    FROM ima_file
                    WHERE ima01 = g_imp[l_ac].imp03
                      AND imaacti = 'Y'

                 IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
                    IF NOT s_lot_del(g_prog,g_imo.imo01,g_imp[l_ac].imp02,0,g_imp[l_ac].imp03,'DEL') THEN
                       CALL cl_err3("del","rvbs_file",g_imo.imo01,g_imp_t.imp02,
                                     SQLCA.sqlcode,"","",1)
                    END IF
                 END IF
                 #FUN-D40030--add--str--
                 CALL g_imp.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
                 #FUN-D40030--add--end-- 
              END IF
#FUN-C50071 add -end--------------------------
              IF p_cmd='u' THEN
                 LET g_imp[l_ac].* = g_imp_t.*
              END IF
              LET l_ac_t = l_ac       #FUN-D40030 Add
              CLOSE t306_bcl
              CLOSE t306_bcl_ind   #FUN-B30187
              ROLLBACK WORK
              EXIT INPUT
           END IF

           #FUN-CB0087---add---str---
            IF NOT t306_imp16_check() THEN
#              ROLLBACK WORK                  #TQC-D10103 mark
               NEXT FIELD imp16
            END IF 
           #FUN-CB0087---add---end---
           CLOSE t306_bcl
           CLOSE t306_bcl_ind   #FUN-B30187
           COMMIT WORK
           
#FUN-A80106 add --start--
            IF NOT cl_null(l_act) AND l_act MATCHES '[au]' THEN
               #FUN-BA0051 --START mark--
               #LET l_imaicd08 = NULL
               #SELECT l_imaicd08 INTO l_imaicd08 FROM imaicd_file
               # WHERE imaicd00 = g_imp[l_ac].imp03
               #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' THEN
               #FUN-BA0051 --END mark--
               IF s_icdbin(g_imp[l_ac].imp03) THEN   #FUN-BA0051
                  #入庫
                  IF cl_confirm('aic-311') THEN
                     LET l_imp03= g_imp[l_ac].imp03
			               SELECT imaicd01 INTO l_imaicd01
			                 FROM imaicd_file
			                WHERE imaicd00 = l_imp03
 
                     LET g_dies = 0
                     CALL s_icdin(1,g_imp[l_ac].imp03,
                                    g_imp[l_ac].imp11,
                                    g_imp[l_ac].imp12,
                                    g_imp[l_ac].imp13,
                                    g_imp[l_ac].imp14,
                                    g_imp[l_ac].imp04,
                                    g_imo.imo01,g_imp[l_ac].imp02,
                                    g_imo.imo02,'',
                                    l_imaicd01,'','')
                           RETURNING g_dies,l_r,l_qty   #FUN-C30302
                     #FUN-C30302---begin
                     IF l_r = 'Y' THEN
                         LET l_qty = s_digqty(l_qty,g_imp[l_ac].imp14) 
                         LET g_imp[l_ac].imp04 = l_qty
                         LET g_imp[l_ac].imp22 = l_qty
                         LET g_imp[l_ac].actu = l_qty
                         UPDATE imp_file set imp04 = g_imp[l_ac].imp04,imp22 = g_imp[l_ac].imp22
                          WHERE imp01=g_imo.imo01 AND imp02=g_imp[l_ac].imp02
                         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                            LET g_imp[l_ac].imp04 = b_imp.imp04
                            LET g_imp[l_ac].imp22 = b_imp.imp22
                            LET g_success = 'N'
                         ELSE
                            LET b_imp.imp04 = g_imp[l_ac].imp04
                            LET b_imp.imp22 = g_imp[l_ac].imp22                
                         END IF
                         DISPLAY BY NAME g_imp[l_ac].imp04, g_imp[l_ac].imp22,
                                         g_imp[l_ac].actu
                     #FUN-C30302---end
                      CALL t306_ind_icd_upd_dies()
                      END IF #FUN-C30302
                  END IF
               END IF
            END IF
#FUN-A80106 add --end-- 

#FUN-C50071 add begin-------------------------
       AFTER INPUT
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM imp_file WHERE imp01=g_imo.imo01
            FOR l_ac=1 TO g_cnt
              SELECT ima918,ima921 INTO g_ima918,g_ima921
                FROM ima_file
               WHERE ima01 = g_imp[l_ac].imp03
                 AND imaacti = "Y"

              IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              UPDATE rvbs_file SET rvbs021=g_imp[l_ac].imp03
               WHERE rvbs00= g_prog
                 AND rvbs01= g_imo.imo01
                 AND rvbs02= g_imp[l_ac].imp02
              END IF
            END FOR
#FUN-C50071 add -end--------------------------
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(imp03) #品號
            #No.FUN-A90048 ------------start -------------------------   
            #        CALL cl_init_qry_var()
            #        LET g_qryparam.form = "q_ima"
            #        LET g_qryparam.default1 = g_imp[l_ac].imp03
            #        CALL cl_create_qry() RETURNING g_imp[l_ac].imp03
                      CALL q_sel_ima(FALSE, "q_ima","",g_imp[l_ac].imp03,"", "", "", "" ,"" ,'')
                                  RETURNING g_imp[l_ac].imp03
            #No.FUN-A90048 ---------------end -------------------------
                     DISPLAY g_imp[l_ac].imp03 TO imp03            #No.MOD-490371
                    NEXT FIELD imp03
               WHEN INFIELD(imp05) #借料單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gfe"
                    LET g_qryparam.default1 = g_imp[l_ac].imp05
                    CALL cl_create_qry() RETURNING g_imp[l_ac].imp05
                     DISPLAY g_imp[l_ac].imp05 TO imp05           #No.MOD-490371
                    NEXT FIELD imp05
              WHEN INFIELD(imp20) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_imp[l_ac].imp20
                   CALL cl_create_qry() RETURNING g_imp[l_ac].imp20
                   DISPLAY BY NAME g_imp[l_ac].imp20
                   NEXT FIELD imp20
 
              WHEN INFIELD(imp23) #單位
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_gfe"
                   LET g_qryparam.default1 = g_imp[l_ac].imp23
                   CALL cl_create_qry() RETURNING g_imp[l_ac].imp23
                   DISPLAY BY NAME g_imp[l_ac].imp23
                   NEXT FIELD imp23
                WHEN INFIELD(imp11) OR INFIELD(imp12) OR INFIELD(imp13)
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_img1"
                      LET g_qryparam.arg1 = g_imp[l_ac].imp03
                      CALL cl_create_qry() RETURNING g_imp[l_ac].imp11,g_imp[l_ac].imp12,g_imp[l_ac].imp13
                      DISPLAY g_imp[l_ac].imp11,g_imp[l_ac].imp12, g_imp[l_ac].imp13
                               TO imp11,imp12,imp13                 #No.MOD-490371
                      CALL t306_def_impiicd029()   #FUN-B30187 
                      IF INFIELD(imp11) THEN NEXT FIELD imp11 END IF
                      IF INFIELD(imp12) THEN NEXT FIELD imp12 END IF
                      IF INFIELD(imp13) THEN NEXT FIELD imp13 END IF
               WHEN INFIELD(imp14) #借料單位
                      CALL cl_init_qry_var()
                      LET g_qryparam.form = "q_gfe"
                      LET g_qryparam.default1 = g_imp[l_ac].imp14
                      CALL cl_create_qry() RETURNING g_imp[l_ac].imp14
                       DISPLAY g_imp[l_ac].imp14 TO imp14         #No.MOD-490371
                      NEXT FIELD imp14
              WHEN INFIELD(imp09_fac) #單位換算
                   CALL cl_cmdrun("aooi102 ")
              WHEN INFIELD(imp930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_imp[l_ac].imp930
                 DISPLAY BY NAME g_imp[l_ac].imp930
                 NEXT FIELD imp930
               #FUN-B30187 --START--
               WHEN INFIELD(impiicd029)
                  CALL q_slot(FALSE,TRUE,g_imp[l_ac].impiicd029,'','')
                      RETURNING g_imp[l_ac].impiicd029
                  DISPLAY BY NAME g_imp[l_ac].impiicd029
                  NEXT FIELD impiicd029
               #FUN-B30187 --END--
              #FUN-CB0087---add---str
                WHEN INFIELD(imp16) #理由  
                 CALL s_get_where(g_imo.imo01,'','',g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                             g_imo.imo06,g_imo.imo08) RETURNING l_flag1,l_where
                 IF l_flag1 AND g_aza.aza115 = 'Y' THEN 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form     ="q_ggc08"
                    LET g_qryparam.where = l_where
                    LET g_qryparam.default1 = g_imp[l_ac].imp16
                 ELSE
                    CALL cl_init_qry_var()                                          
                    LET g_qryparam.form     ="q_azf41"                        
                    LET g_qryparam.default1 = g_imp[l_ac].imp16                                                       
                 END IF                                                        
                 CALL cl_create_qry() RETURNING g_imp[l_ac].imp16                    
                 DISPLAY BY NAME g_imp[l_ac].imp16     
                 CALL t306_azf03_desc()       #TQC-D20042                               
                 NEXT FIELD imp16 
              #FUN-CB0087---add---end
              OTHERWISE EXIT CASE
            END CASE
 
       ON ACTION mntn_stock
                    LET g_cmd = 'aimi200 x'
                    CALL cl_cmdrun(g_cmd)
       ON ACTION mntn_loc
                    LET g_cmd = "aimi201 '",g_imp[l_ac].imp11,"'" #BugNo:6598
                    CALL cl_cmdrun(g_cmd)
       ON ACTION mntn_unit
                   CALL cl_cmdrun("aooi103 ")
 
       ON ACTION qry_warehouse  #倉庫
                    #No.FUN-AA0049--begin
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form = "q_imfd"
                    #LET g_qryparam.default1 = g_imp[l_ac].imp11
                    #CALL cl_create_qry() RETURNING g_imp[l_ac].imp11
                    CALL q_imd_1(FALSE,TRUE,g_imp[l_ac].imp11,"","","","") RETURNING g_imp[l_ac].imp11
                    #No.FUN-AA0049--end
                    DISPLAY g_imp[l_ac].imp11 TO imp11  #No.MOD-490371
                    NEXT FIELD imp11
 
       ON ACTION qry_location #儲位
                    #No.FUN-AA0049--begin
                    #CALL cl_init_qry_var()
                    #LET g_qryparam.form = "q_imfe"
                    #LET g_qryparam.default1 = g_imp[l_ac].imp12
                    #CALL cl_create_qry() RETURNING g_imp[l_ac].imp12
                    CALL q_ime_1(FALSE,TRUE,"",g_imp[l_ac].imp11,"",g_plant,"","","") RETURNING g_imp[l_ac].imp12
                    #No.FUN-AA0049--end
                    DISPLAY g_imp[l_ac].imp12,g_imp[l_ac].imp13
                          TO imp12,imp13                 #No.MOD-490371
                    NEXT FIELD imp12
 
       ON ACTION qry_lot #批號
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_img"
                    LET g_qryparam.default1 = g_imp[l_ac].imp03
                    CALL cl_create_qry() RETURNING  g_imp[l_ac].imp13
                     DISPLAY g_imp[l_ac].imp13 TO imp13  #No.MOD-490371
                    NEXT FIELD imp13
#FUN-A80106 add --start--
        ON ACTION aic_s_icdqry #刻號/BIN號查詢作業
           IF NOT cl_null(g_imp[l_ac].imp02) THEN
              CALL s_icdqry(1,g_imo.imo01,g_imp[l_ac].imp02,
                            g_imo.imopost,g_imp[l_ac].imp03)
           END IF
#FUN-A80106 add --end--                    

#FUN-C50071 add begin-------------------------
        ON ACTION modi_lot
           SELECT ima918,ima921 INTO g_ima918,g_ima921
             FROM ima_file
            WHERE ima01 = g_imp[l_ac].imp03
              AND imaacti = "Y"

           IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
              LET g_img09 = ''   LET g_img10 = 0

              SELECT img09,img10 INTO g_img09,g_img10 FROM img_file
               WHERE img01 = g_imp[l_ac].imp03 AND img02 = g_imp[l_ac].imp11
                 AND img03 = g_imp[l_ac].imp12 AND img04 = g_imp[l_ac].imp13

              CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp14,g_img09)
                 RETURNING l_i,l_fac
              IF l_i = 1 THEN LET l_fac = 1 END IF

              CALL s_mod_lot(g_prog,g_imo.imo01,g_imp[l_ac].imp02,0,
                           g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                           g_imp[l_ac].imp12,g_imp[l_ac].imp13,
                           g_imp[l_ac].imp14,g_img09,
                           g_imp[l_ac].imp14_fac,g_imp[l_ac].imp04,'','MOD',1)
                 RETURNING l_r,g_qty
              IF l_r = "Y" THEN
                 LET g_imp[l_ac].imp04 = g_qty
              END IF
           END IF
#FUN-C50071 add -end--------------------------
 
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
 
    LET g_imo.imomodu = g_user
    LET g_imo.imodate = g_today
    UPDATE imo_file SET imomodu = g_imo.imomodu,imodate = g_imo.imodate
     WHERE imo01 = g_imo.imo01
    DISPLAY BY NAME g_imo.imomodu,g_imo.imodate
 
    CLOSE t306_bcl
    CLOSE t306_bcl_ind   #FUN-B30187
    COMMIT WORK
#   CALL t306_delall()        #CHI-C30002 mark
    CALL t306_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t306_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_imo.imo01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM imo_file ",
                  "  WHERE imo01 LIKE '",l_slip,"%' ",
                  "    AND imo01 > '",g_imo.imo01,"'"
      PREPARE t306_pb1 FROM l_sql 
      EXECUTE t306_pb1 INTO l_cnt   
      
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
        #CALL t306_x()   #CHI-D20010
         CALL t306_x(1)  #CHI-D20010
         IF g_imo.imoconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM imo_file WHERE imo01 = g_imo.imo01
         INITIALIZE g_imo.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION t306_delall()
#   SELECT COUNT(*) INTO g_cnt FROM imp_file
#       WHERE imp01 = g_imo.imo01
#   IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
#      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#      ERROR g_msg CLIPPED
#      DELETE FROM imo_file WHERE imo01 = g_imo.imo01
#      CLEAR FORM
#  CALL g_imp.clear()
#   END IF
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION t306_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CLEAR gen02                           #清除FORMONLY欄位
    CONSTRUCT g_wc2 ON imp02,imp03,imp05,imp04,imp08,imp09,
                       imp07,
                       imp11,imp12,imp13,imp14,imp06
                                            # 螢幕上取單身條件
         FROM s_imp[1].imp02,s_imp[1].imp03,s_imp[1].imp05,
              s_imp[1].imp04,s_imp[1].imp08,s_imp[1].imp09,
              s_imp[1].imp07,s_imp[1].imp11,s_imp[1].imp12,
              s_imp[1].imp13,s_imp[1].imp14,s_imp[1].imp06
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
        LET INT_FLAG = 0
        RETURN
    END IF
    CALL t306_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t306_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(500)
 
    LET g_sql =
         "SELECT imp02,imp03,ima02,ima05,ima08,ima25, ",    #No.MOD-480340
        "       imp05,imp04,imp09,imp11,imp12,imp13,'',imp14,imp14_fac, ",
        "       imp23,imp24,imp25,imp20,imp21,imp22,",  #No.FUN-570249
        "       ''  ,imp06,imp08,imp07,imp15,imp16,azf03,imp930,'','','' ",  #No.FUN-5C0077  #FUN-670093 #FUN-B30187  #FUN-CB0087 add imp16,azf03
        " FROM imp_file,OUTER ima_file,OUTER img_file,OUTER azf_file",       #FUN-CB0087 add azf_file 
        " WHERE imp01 ='",g_imo.imo01,"'", #單頭
        "   AND imp_file.imp03 = ima_file.ima01 ",  #No.FUN-570249
        "   AND imp_file.imp03 = img_file.img01 ",  #No.FUN-570249
        "   AND imp_file.imp11 = img_file.img02 ",  #No.FUN-570249
        "   AND imp_file.imp12 = img_file.img03 ",  #No.FUN-570249
        "   AND imp_file.imp13 = img_file.img04 ",  #No.FUN-570249
        "   AND imp_file.imp16 = azf_file.azf01 ",  #No.FUN-CB0087 
        "   AND azf_file.azf02 = '2' ",             #No.FUN-CB0087
        "   AND ",p_wc2 CLIPPED,           #單身
        " ORDER BY imp02"                  #No.FUN-570249

    #FUN-B30187 --START--
    LET g_sql =
         "SELECT imp02,imp03,ima02,ima05,ima08,ima25, ",    
        "       imp05,imp04,imp09,imp11,imp12,imp13,'',imp14,imp14_fac, ",
        "       imp23,imp24,imp25,imp20,imp21,imp22,",  
        "       ''  ,imp06,imp08,imp07,imp15,imp16,azf03,imp930,'',impiicd028,impiicd029 ",  #FUN-CB0087 add imp16,azf03
        " FROM imp_file,OUTER ima_file,OUTER img_file,OUTER impi_file,OUTER azf_file", #FUN-CB0087 add azf_file 
        " WHERE imp01 ='",g_imo.imo01,"'", #單頭
        "   AND imp_file.imp03 = ima_file.ima01 ", 
        "   AND imp_file.imp03 = img_file.img01 ", 
        "   AND imp_file.imp11 = img_file.img02 ", 
        "   AND imp_file.imp12 = img_file.img03 ",  
        "   AND imp_file.imp13 = img_file.img04 ",
        "   AND imp_file.imp01 = impi_file.impi01 ",    
        "   AND imp_file.imp02 = impi_file.impi02 ",
        "   AND imp_file.imp16 = azf_file.azf01 ",  #No.FUN-CB0087
        "   AND azf_file.azf02 = '2' ",             #No.FUN-CB0087
        "   AND ",p_wc2 CLIPPED,           #單身
        " ORDER BY imp02"                  
    #FUN-B30187 --END--
        
    PREPARE t306_pb FROM g_sql
    DECLARE imp_curs                       #CURSOR
        CURSOR FOR t306_pb
 
    CALL g_imp.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH imp_curs INTO g_imp[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       SELECT img10 INTO g_imp[g_cnt].bala FROM img_file
        WHERE img01=g_imp[g_cnt].imp03
          AND img02=g_imp[g_cnt].imp11
          AND img03=g_imp[g_cnt].imp12
          AND img04=g_imp[g_cnt].imp13
 
       LET g_imp[g_cnt].actu = g_imp[g_cnt].imp04*g_imp[g_cnt].imp14_fac
       LET g_imp[g_cnt].gem02c=s_costcenter_desc(g_imp[g_cnt].imp930) #FUN-670093
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_imp.deleteElement(g_cnt)
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 #FUN-C50071 add begin-------------------------
    LET g_sql = " SELECT rvbs02,rvbs021,ima02,ima021,rvbs022,rvbs04,rvbs03,rvbs05,rvbs06,rvbs07,rvbs08",
                "   FROM rvbs_file LEFT JOIN ima_file ON rvbs021 = ima01",
                "  WHERE rvbs00 = '",g_prog,"' AND rvbs01 = '",g_imo.imo01,"'"
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
  #FUN-C50071 add -end--------------------------
END FUNCTION
 
FUNCTION t306_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
#FUN-C50071 add begin-------------------------
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_imp TO s_imp.* ATTRIBUTE(COUNT=g_rec_b)

         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )

         BEFORE ROW
            LET l_ac = ARR_CURR()
            CALL cl_show_fld_cont()

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

      #FUN-D10081---add---str---
      ON ACTION page_list 
         LET g_action_flag="page_list"
         EXIT DIALOG
      #FUN-D10081---add---end---
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
         CALL t306_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL t306_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL t306_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t306_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DIALOG                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL t306_fetch('L')
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
         CALL t306_mu_ui()   #FUN-610006
         IF g_imo.imoconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
         EXIT DIALOG 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG 
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
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG 
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG 
      #CHI-D20010---end
#FUN-A80106 add --start--
    #@ON ACTION 單據刻號BIN查詢作業
      ON ACTION aic_s_icdqry
         LET g_action_choice = "aic_s_icdqry"
         EXIT DIALOG 
 
    #@ON ACTION 單據刻號BIN明細維護作業
      ON ACTION aic_s_icdin
         LET g_action_choice = "aic_s_icdin"
         EXIT DIALOG 
#FUN-A80106 add --end--         
    #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DIALOG 
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DIALOG 
    #@ON ACTION 單價
      ON ACTION unit_price
         LET g_action_choice="unit_price"
         EXIT DIALOG 
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DIALOG 
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DIALOG 
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG 
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DIALOG 
 
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DIALOG
     
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DIALOG

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      &include "qry_string.4gl"
   END DIALOG 
#FUNl-C50071 add -end--------------------------

#FUN-C50071 mark -begin--------------------------
#  DISPLAY ARRAY g_imp TO s_imp.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
#
#     BEFORE DISPLAY
#        CALL cl_navigator_setting( g_curs_index, g_row_count )
#
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#
#     ON ACTION insert
#        LET g_action_choice="insert"
#        EXIT DISPLAY
#     ON ACTION query
#        LET g_action_choice="query"
#        EXIT DISPLAY
#     ON ACTION delete
#        LET g_action_choice="delete"
#        EXIT DISPLAY
#     ON ACTION modify
#        LET g_action_choice="modify"
#        EXIT DISPLAY
#     ON ACTION first
#        CALL t306_fetch('F')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION previous
#        CALL t306_fetch('P')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION jump
#        CALL t306_fetch('/')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#
#     ON ACTION next
#        CALL t306_fetch('N')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION last
#        CALL t306_fetch('L')
#        CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
#        IF g_rec_b != 0 THEN
#           CALL fgl_set_arr_curr(1)  ######add in 040505
#        END IF
#        ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
#
#     ON ACTION detail
#        LET g_action_choice="detail"
#        LET l_ac = 1
#        EXIT DISPLAY
#     ON ACTION output
#        LET g_action_choice="output"
#        EXIT DISPLAY
#     ON ACTION help
#        LET g_action_choice="help"
#        EXIT DISPLAY
#
#     ON ACTION locale
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        CALL t306_mu_ui()   #FUN-610006
#        IF g_imo.imoconf = 'X' THEN
#           LET g_void = 'Y'
#        ELSE
#           LET g_void = 'N'
#        END IF
#        CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
#        EXIT DISPLAY
#
#     ON ACTION exit
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#     ON ACTION controlg
#        LET g_action_choice="controlg"
#        EXIT DISPLAY
#   #@ON ACTION 確認
#     ON ACTION confirm
#        LET g_action_choice="confirm"
#        EXIT DISPLAY
#   #@ON ACTION 取消確認
#     ON ACTION undo_confirm
#        LET g_action_choice="undo_confirm"
#        EXIT DISPLAY
#   #@ON ACTION 作廢
#     ON ACTION void
#        LET g_action_choice="void"
#        EXIT DISPLAY
##FUN-A80106 add --start--
#&ifdef ICD
#   #@ON ACTION 單據刻號BIN查詢作業
#     ON ACTION aic_s_icdqry
#        LET g_action_choice = "aic_s_icdqry"
#        EXIT DISPLAY
#
#   #@ON ACTION 單據刻號BIN明細維護作業
#     ON ACTION aic_s_icdin
#        LET g_action_choice = "aic_s_icdin"
#        EXIT DISPLAY
#&endif
##FUN-A80106 add --end--         
#   #@ON ACTION 過帳
#     ON ACTION post
#        LET g_action_choice="post"
#        EXIT DISPLAY
#   #@ON ACTION 過帳還原
#     ON ACTION undo_post
#        LET g_action_choice="undo_post"
#        EXIT DISPLAY
#   #@ON ACTION 單價
#     ON ACTION unit_price
#        LET g_action_choice="unit_price"
#        EXIT DISPLAY
#
#     ON ACTION accept
#        LET g_action_choice="detail"
#        LET l_ac = ARR_CURR()
#        EXIT DISPLAY
#
#     ON ACTION cancel
#            LET INT_FLAG=FALSE 		#MOD-570244	mars
#        LET g_action_choice="exit"
#        EXIT DISPLAY
#
#     ON ACTION exporttoexcel #FUN-4B0002
#        LET g_action_choice = 'exporttoexcel'
#        EXIT DISPLAY
#
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#        CONTINUE DISPLAY
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     AFTER DISPLAY
#        CONTINUE DISPLAY
#
#   #@ON ACTION 拋轉至SPC
#     ON ACTION trans_spc                     
#        LET g_action_choice="trans_spc"
#        EXIT DISPLAY
#
#     ON ACTION related_document                #No.FUN-680046  相關文件
#        LET g_action_choice="related_document"          
#        EXIT DISPLAY     
#    ON ACTION controls                                                                                                             
#        CALL cl_set_head_visible("","AUTO")                                                                                        
#
#     &include "qry_string.4gl"
#  END DISPLAY
#FUN-C50071 mark --end---------------------------
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t306_imp03(p_cmd)
DEFINE
    l_ima02 LIKE ima_file.ima02,   #品名規格
    l_ima05 LIKE ima_file.ima05,   #目前版本
#   l_aqty  LIKE ima_file.ima262,  
    l_aqty  LIKE type_file.num15_3,###GP5.2  #NO.FUN-A20044  
    l_ima08 LIKE ima_file.ima08,   #來源碼
    p_cmd   LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
    l_ima35 LIKE ima_file.ima35, #預設倉庫
    l_ima36 LIKE ima_file.ima36  #預設儲位
DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044 
 
    LET g_chr=''
#--->單倉管理時,為顯示料件來源碼,版本,品名規格,發料單位,
#                     庫存單位,庫存數量,庫存可用量,轉換率
#.........在此處無法顯示多倉之資料
    IF g_sma.sma12='N' THEN #單倉管理時, 須要將該筆資料鎖住
        LET g_forupd_sql =
#         " SELECT ima02,ima05,ima08,ima63,ima25,ima262,0, ", #NO.FUN-A20044
          " SELECT ima02,ima05,ima08,ima63,ima25,0,0, ",      #NO.FUN-A20044
	  "        ima63_fac ,ima35,ima36", #FUN-560183 拿掉 ima86_fac  #CHI-6A0015 add ima35/36
          " FROM ima_file ",
          "   WHERE ima01= ? ",
          " FOR UPDATE "
        LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
        DECLARE imp03_lock CURSOR FROM g_forupd_sql
        OPEN imp03_lock USING g_imp[l_ac].imp03
        IF STATUS THEN
           CALL cl_err("OPEN imp03_lock:", STATUS, 1)
           CLOSE imp03_lock
           ROLLBACK WORK
           RETURN
        END IF
        FETCH imp03_lock
            INTO l_ima02,l_ima05,l_ima08,m_imo.ima63,m_imo.img09,
            m_imo.img10,l_aqty,m_imo.img09_fac,l_ima35,l_ima36  #,m_imo.ima86_fac #FUN-560183  #CHI-6A0115 add ima35/36
        IF SQLCA.sqlcode THEN
            IF SQLCA.sqlcode=-246 OR STATUS =-250 OR STATUS =-263 THEN            #NO.TQC-930155
                LET g_chr='L'
            ELSE
                LET g_chr='E'
            END IF
            RETURN
        END IF
        ##No.FUN-AA0049--begin
        #IF NOT s_chk_ware(l_ima35) THEN
        #   LET l_ima35=' '
        #   LET l_ima36=' '
        #END IF 
        ##No.FUN-AA0049--end
        CALL s_getstock(g_imp[l_ac].imp03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
        LET m_imo.img10 = l_n3                                        #NO.FUN-A20044
        IF l_aqty IS NULL THEN
            LET l_aqty=0
        END IF
        LET g_imp[l_ac].imp14=m_imo.img09
        LET g_imp[l_ac].imp14_fac=m_imo.img09_fac
        LET g_imp[l_ac].bala=m_imo.img10
        LET g_imp[l_ac].actu=g_imp[l_ac].imp04*g_imp[l_ac].imp14_fac
        IF cl_null(g_imp_t.imp03) OR g_imp_t.imp03 != g_imp[l_ac].imp03 THEN   #TQC-750018
          LET g_imp[l_ac].imp11 = l_ima35   #CHI-6A0015 add
          LET g_imp[l_ac].imp12 = l_ima36   #CHI-6A0015 add
          LET g_imp[l_ac].imp13 = NULL      #TQC-750018
          DISPLAY BY NAME g_imp[l_ac].imp11, g_imp[l_ac].imp12,g_imp[l_ac].imp13  #TQC-750018
        END IF    #TQC-750018
 
        DISPLAY    l_ima02,     #品名規格
                   l_ima05,     #版本
                   l_ima08,     #來源碼
                   m_imo.img09, #料件庫存單位
                   m_imo.img09, #料件庫存單位
                   m_imo.img09_fac,#轉換率
                   m_imo.img10, #庫存數量
                   g_imp[l_ac].actu   #轉入數量
             TO    ima02,
                   ima05,
                   ima08,
                   ima25,
                   imp14,
                   imp14_fac,
                   bala ,
                    actu             #No.MOD-490371
    ELSE
        SELECT   ima02,  ima05,  ima08,      ima63,ima25,
#             (ima262),ima35,ima36  #,ima86_fac  #FUN-560183                        #CHI-6A0015 add ima35/36
              0,ima35,ima36  #,ima86_fac  #FUN-560183                        #CHI-6A0015 add ima35/36
          INTO l_ima02,l_ima05,l_ima08,m_imo.ima63,m_imo.img09,g_a,l_ima35,l_ima36  #CHI-6A0015 add ima35/36
          FROM ima_file
         WHERE ima01=g_imp[l_ac].imp03
        IF SQLCA.sqlcode THEN LET  g_chr='E' RETURN END IF
        ##No.FUN-AA0049--begin
        #IF NOT s_chk_ware(l_ima35) THEN
        #   LET l_ima35=' '
        #   LET l_ima36=' '
        #END IF 
        ##No.FUN-AA0049--end     
        LET g_imp[l_ac].ima02=l_ima02
        LET g_imp[l_ac].ima05=l_ima05
        LET g_imp[l_ac].ima08=l_ima08
        LET g_imp[l_ac].ima25=m_imo.img09
        CALL s_getstock(g_imp[l_ac].imp03,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
        LET g_a = l_n3                                                #NO.FUN-A20044
        IF cl_null(g_imp_t.imp03) OR g_imp_t.imp03 <> g_imp[l_ac].imp03  THEN  #TQC-750018
          LET g_imp[l_ac].imp11=l_ima35
          LET g_imp[l_ac].imp12=l_ima36
          LET g_imp[l_ac].imp13= NULL   #TQC-750018
          DISPLAY BY NAME g_imp[l_ac].imp11,g_imp[l_ac].imp12,g_imp[l_ac].imp13  #TQC-750018
        END IF   #TQC-750018
 
        DISPLAY l_ima02,l_ima05,l_ima08,m_imo.img09
             TO   
                 ima02,ima05,ima08,ima25    #No.MOD-490371
    END IF
    LET m_imo.ima25=m_imo.img09  #料件庫存單位(保留當多倉時檢查)
    IF p_cmd = 'a' OR
        g_imp[l_ac].imp03 != g_imp_t.imp03 THEN
        LET g_imp[l_ac].imp05=m_imo.img09
         DISPLAY g_imp[l_ac].imp05 TO imp05   #No.MOD-490371
    END IF
END FUNCTION
 
#取得該倉庫/ 儲位的相關數量資料
FUNCTION t306_imp13_a()
 
    LET g_errno=' ' LET g_desc=' '
    SELECT img09,img10,img23,img24,img21
      INTO g_imp[l_ac].imp14,g_imp[l_ac].bala,g_img23,g_img24,g_img21
      FROM img_file
     WHERE img01=g_imp[l_ac].imp03
       AND img02=g_imp[l_ac].imp11
       AND img03=g_imp[l_ac].imp12
       AND img04=g_imp[l_ac].imp13

     IF SQLCA.SQLCODE THEN #FUN-C30302
        CASE WHEN SQLCA.SQLCODE=100  LET g_errno ='apm-259'
                                     LET g_desc  ='尚未存在之倉庫/儲位/批號'
             OTHERWISE               LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
     END IF  #FUN-C30302
     IF cl_null(g_imp[l_ac].bala) THEN LET g_imp[l_ac].bala=0 END IF
     CALL t306_loc()
     IF cl_null(g_desc) THEN
        CALL s_wardesc(g_img23,g_img24) RETURNING g_desc
     END IF
      DISPLAY g_imp[l_ac].bala  TO bala   #No.MOD-490371
      DISPLAY g_imp[l_ac].imp14 TO imp14  #No.MOD-490371
     CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp05,g_imp[l_ac].imp14)
               RETURNING g_cnt,g_imp[l_ac].imp14_fac
     IF cl_null(g_imp[l_ac].imp14_fac) THEN
         LET g_imp[l_ac].imp14_fac = 1
     END IF
     LET g_imp[l_ac].actu = g_imp[l_ac].imp04*g_imp[l_ac].imp14_fac
      DISPLAY g_imp[l_ac].actu TO actu            #No.MOD-490371
      DISPLAY g_imp[l_ac].imp14_fac TO imp14_fac  #No.MOD-490371
 
END FUNCTION
 
FUNCTION t306_loc()
    #取得儲位性質
    IF g_imp[l_ac].imp12 IS NOT NULL THEN
        SELECT ime05,ime06 INTO g_img23,g_img24
          FROM ime_file
         WHERE ime01=g_imp[l_ac].imp11
           AND ime02=g_imp[l_ac].imp12
	AND imeacti='Y'  #FUN-D40103 add
    ELSE
        SELECT imd11,imd12 INTO g_img23,g_img24
          FROM imd_file
         WHERE imd01=g_imp[l_ac].imp11
    END IF
    IF SQLCA.sqlcode THEN LET g_img23=' ' LET g_img24=' ' END IF
 
END FUNCTION
 
#檢查單位是否存在於單位檔中
FUNCTION t306_unit(p_key)
    DEFINE p_key     LIKE gfe_file.gfe01,
           l_gfe02   LIKE gfe_file.gfe02,
           l_gfeacti LIKE gfe_file.gfeacti
 
    LET g_errno = ' '
    SELECT gfe02,gfeacti
           INTO l_gfe02,l_gfeacti
           FROM gfe_file WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100 LET g_errno = 'mfg2605'
                            LET l_gfe02 = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
#--------------------------------------------------------------------#
#更新相關的檔案
#--------------------------------------------------------------------#
FUNCTION t306_t()
  DEFINE
    l_n         LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    l_qty       LIKE img_file.img08
#FUN-A80106 add --start--
  DEFINE l_flag   LIKE type_file.num5   #判斷s_icdpost()成功/失敗
#FUN-A80106 add --end--
  
    LET l_qty = b_imp.imp04 * b_imp.imp14_fac
    IF l_qty IS NULL THEN LET g_success='N' RETURN END IF
    LET g_forupd_sql = "SELECT img01,img02,img03,img04 FROM img_file ",                                                                               
                       "  WHERE img01 = ? AND img02 = ? ",                                                                          
                       "    AND img03 = ? AND img04 = ? FOR UPDATE "                                                                
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE img2_lock CURSOR FROM g_forupd_sql                                                                                      
    OPEN img2_lock USING b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13                                                            
    IF STATUS THEN                                                                                                                  
       LET g_showmsg = b_imp.imp03,"/",b_imp.imp11,"/",b_imp.imp12,"/",b_imp.imp13                                    
       CALL s_errmsg('lock img2 fail',g_showmsg,'lock img:',SQLCA.sqlcode,1)                                          
       LET g_success = 'N'                                                                                                          
       RETURN                                                                                                                       
    END IF                                                                                                                          
    FETCH img2_lock INTO b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13                                                                                                
    IF STATUS THEN                                                                                                                  
       LET g_showmsg = b_imp.imp03,"/",b_imp.imp11,"/",b_imp.imp12,"/",b_imp.imp13                                   
       CALL s_errmsg('sel img2 fail',g_showmsg,'sel img:',SQLCA.sqlcode,1)                                            
       LET g_success = 'N'                                                                                                          
       RETURN                                                                                                                       
    END IF                                                                                                                          
    CALL t306_get_value()
    
#FUN-A80106 add --start--
        #FUN-B30187 --START--        
        SELECT * INTO b_impi.* FROM impi_file 
         WHERE impi01=g_imo.imo01 AND impi02=b_imp.imp02
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)
            LET g_success = 'N'                                                                                                       
            RETURN
        END IF 
        #FUN-B30187 --END--
        CALL s_icdpost(1,b_imp.imp03,b_imp.imp11,b_imp.imp12,
                       b_imp.imp13,b_imp.imp14,b_imp.imp04,
                       b_imp.imp01,b_imp.imp02,g_imo.imo02,'Y',
                       '','',b_impi.impiicd029,b_impi.impiicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
             RETURNING l_flag
        IF l_flag = 0 THEN
           LET g_success = 'N'
           RETURN
        END IF
#FUN-A80106 add --end-- 

    CALL s_upimg(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,+1,l_qty,g_imo.imo02,  #FUN-8C0084
#       5           6           7           8           9
        b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,g_imo.imo01,
#       10 11          12          13
       #'',b_imp.imp05,b_imp.imp04,b_imp.imp14,          #FUN-C50071 mark
        b_imp.imp02,b_imp.imp05,b_imp.imp04,b_imp.imp14, #FUN-C50071 add
#       14              15              16
        b_imp.imp14_fac,g_ima25_fac,   1,  #FUN-560183  g_ima86 -> 1
#       17 18 19 20 21
        '','','','','','')
    IF g_success = 'N' THEN RETURN  END IF
 
#更新庫存主檔之庫存數量
    IF s_udima(b_imp.imp03,                       #料件編號
               g_img23,                           #是否可用倉儲
               g_img24,                           #是否為MRP可用倉儲
               b_imp.imp04*b_imp.imp14_fac,       #發料數量(換算為庫存單位)
               g_imo.imo02,                       #最近一次發料日期
               +1)                                #表收料
       THEN LET g_success='N' RETURN
    END IF
#產生異動記錄資料
    CALL t306_log(1,0,'',b_imp.imp03,l_qty)
    IF g_sma.sma115='Y' THEN
       CALL t306_update_du(+1)
    END IF
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
#處理異動記錄
FUNCTION t306_log(p_stdc,p_reason,p_code,p_item,p_qty)
DEFINE
    l_pmn02         LIKE pmn_file.pmn02,   #採購單性質
    p_stdc          LIKE type_file.num5,   #是否需取得標準成本  #No.FUN-690026 SMALLINT
    p_reason        LIKE type_file.num5,   #是否需取得異動原因  #No.FUN-690026 SMALLINT
    p_code          LIKE type_file.chr20,  #No.FUN-690026 VARCHAR(04)
    p_item          LIKE ima_file.ima01,   #No.FUN-690026 VARCHAR(20)
    p_qty           LIKE img_file.img08    #MOD-530179        #異動數量
 
#----來源----
    LET g_tlf.tlf01=p_item      	 #異動料件編號
    LET g_tlf.tlf02=80         	         #資料目的為同業
    LET g_tlf.tlf020=g_plant             #工廠別
    LET g_tlf.tlf021=' '          	 #倉庫別
    LET g_tlf.tlf022=' '          	 #儲位別
    LET g_tlf.tlf023=' '          	 #入庫批號
    LET g_tlf.tlf024=' '          	 #異動後庫存數量
    LET g_tlf.tlf025=' '          	 #庫存單位(ima_file or imo_file)
    LET g_tlf.tlf026=g_imo.imo01         #參考單据
    LET g_tlf.tlf027=b_imp.imp02
#----目的----
    LET g_tlf.tlf03=50         	 	 #資料來源為倉庫
    LET g_tlf.tlf030=g_plant             #工廠別
    LET g_tlf.tlf031=b_imp.imp11         #倉庫別
    LET g_tlf.tlf032=b_imp.imp12	 #儲位別
    LET g_tlf.tlf033=b_imp.imp13	 #批號
    LET g_tlf.tlf034=g_img10+(b_imp.imp04*b_imp.imp14_fac) #異動後庫存數量
    LET g_tlf.tlf035=b_imp.imp14         #庫存單位(ima_file or imo_file)
    LET g_tlf.tlf036=g_imo.imo01         #借料單號
    LET g_tlf.tlf037=b_imp.imp02         #借料項次
#--->異動數量
    LET g_tlf.tlf04=' '                  #工作站
    LET g_tlf.tlf05=' '                  #作業序號
    LET g_tlf.tlf06=g_imo.imo02          #收料日期
    LET g_tlf.tlf07=g_today              #異動資料產生日期
    LET g_tlf.tlf08=TIME                 #異動資料產生時:分:秒
    LET g_tlf.tlf09=g_user               #產生人
    LET g_tlf.tlf10=b_imp.imp04          #借料數量
    LET g_tlf.tlf11=b_imp.imp05          #借料單位
    LET g_tlf.tlf12=b_imp.imp14_fac      #借料/庫存轉換率
    LET g_tlf.tlf13='aimt306'            #異動命令代號
    LET g_tlf.tlf14=' '                  #異動原因
    IF g_sma.sma12='N'                  #貸方會計科目
       THEN LET g_tlf.tlf15=g_ima39     #料件會計科目
       ELSE LET g_tlf.tlf15=g_img26     #倉儲會計科目
    END IF
    LET g_tlf.tlf16=g_imo.imo05         #貸方會計科目
    LET g_tlf.tlf17=' '                 #非庫存性料件編號
    CALL s_imaQOH(b_imp.imp03)
         RETURNING g_tlf.tlf18          #異動後總庫存量
    LET g_tlf.tlf19= ' '                #異動廠商/客戶編號
    LET g_tlf.tlf20= ' '                #project no.
    LET g_tlf.tlf21=  b_imp.imp10
    LET g_tlf.tlf211= g_imo.imo02
    LET g_tlf.tlf930=  b_imp.imp930 #FUN-670093
    CALL s_tlf(p_stdc,p_reason)
END FUNCTION
 
FUNCTION t306_get_value()
    SELECT img10,img26,img23,img24
      INTO g_img10,g_img26,g_img23,g_img24 FROM img_file
 
    SELECT ima39,ima25 #FUN-560183 拿掉 ima86
      INTO g_ima39,g_ima25 FROM ima_file #FUN-560183 拿掉 g_ima86
     WHERE ima01=b_imp.imp03
 
      CALL s_umfchk(b_imp.imp03,b_imp.imp05,g_ima25)
                    RETURNING g_cnt,g_ima25_fac
END FUNCTION
 
FUNCTION t306_s()
DEFINE l_cnt     LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       l_sql     LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(400)
       l_imp04   LIKE imp_file.imp04,
       l_imp15   LIKE imp_file.imp15,
       l_imp03   LIKE imp_file.imp03,
       l_qcs01   LIKE qcs_file.qcs01,
       l_qcs02   LIKE qcs_file.qcs02,
       l_qcs091c LIKE qcs_file.qcs091
DEFINE l_flag    LIKE type_file.chr1     #FUN-930109
DEFINE l_imp11   LIKE imp_file.imp11     #FUN-930109
DEFINE l_imp12   LIKE imp_file.imp12     #FUN-930109
DEFINE l_imp02   LIKE imp_file.imp02     #FUN-930109
DEFINE g_flag    LIKE type_file.chr1     #FUN-930109
DEFINE l_cnt_img   LIKE type_file.num5     #FUN-C70087
DEFINE l_cnt_imgg  LIKE type_file.num5     #FUN-C70087

    SELECT * INTO g_imo.* FROM imo_file WHERE imo01=g_imo.imo01
    IF cl_null(g_imo.imo01) THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_imo.imo07 = 'Y' THEN
        CALL cl_err(g_imo.imo01,'aec-078',0)  #已結案 !!
        RETURN
    END IF
    IF g_imo.imoconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_imo.imopost='Y' THEN CALL cl_err(g_imo.imo01,'aar-347',0) RETURN END IF
    IF g_imo.imoconf != 'Y' THEN CALL cl_err('','9029',0) RETURN END IF
    IF NOT t306_chk_sma() THEN RETURN END IF #MOD-4A0201
     
    LET g_flag = 'Y'
    DECLARE t306_s_cs1 CURSOR FOR SELECT imp02,imp11,imp12 FROM imp_file 
                                   WHERE imp01=g_imo.imo01
 
    CALL s_showmsg_init()
 
    FOREACH t306_s_cs1 INTO l_imp02,l_imp11,l_imp12
      CALL s_incchk(l_imp11,l_imp12,g_user) 
      RETURNING l_flag
      IF l_flag = FALSE THEN
         LET g_flag='N'
         LET g_showmsg=l_imp02,"/",l_imp11,"/",l_imp12,"/",g_user                                                                   
         CALL s_errmsg('imp02,imp11,imp12,inc03',g_showmsg,'','asf-888',1)
      END IF
    END FOREACH
    CALL s_showmsg()                                                                                                                 
    IF g_flag='N' THEN                                                                                                            
       RETURN                                                                                                                        
    END IF
 
   LET l_sql = " SELECT imp04,imp15,imp03,imp01,imp02 FROM imp_file ",
               "  WHERE imp01 = '",g_imo.imo01,"'"
   PREPARE t306_curs1 FROM l_sql
   DECLARE t306_pre1 CURSOR FOR t306_curs1
   FOREACH t306_pre1 INTO l_imp04,l_imp15,l_imp03,l_qcs01,l_qcs02
     IF l_imp15 = 'Y' THEN
       LET l_qcs091c = 0
       SELECT SUM(qcs091) INTO l_qcs091c
         FROM qcs_file
        WHERE qcs01 = l_qcs01
          AND qcs02 = l_qcs02
          AND qcs14 = 'Y'
 
       IF l_qcs091c IS NULL THEN
          LET l_qcs091c = 0
       END IF
       IF l_imp04 > l_qcs091c THEN
          CALL cl_err(l_imp03,'mfg3558',1)
          RETURN
       END IF
     END IF
   END FOREACH
    IF NOT cl_sure(21,20) THEN RETURN END IF

   #FUN-C70087---begin
   CALL s_padd_img_init()  #FUN-CC0095
   CALL s_padd_imgg_init()  #FUN-CC0095
   
   DECLARE t306_s_c1 CURSOR FOR SELECT * FROM imp_file
     WHERE imp01 = g_imo.imo01 

   FOREACH t306_s_c1 INTO b_imp.*
      IF STATUS THEN EXIT FOREACH END IF
      LET l_cnt_img = 0
      SELECT COUNT(*) INTO l_cnt_img
        FROM img_file
       WHERE img01 = b_imp.imp03
         AND img02 = b_imp.imp11
         AND img03 = b_imp.imp12
         AND img04 = b_imp.imp13
       IF l_cnt_img = 0 THEN
          #CALL s_padd_img_data(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,g_imo.imo01,b_imp.imp02,g_imo.imo02,l_img_table)  #FUN-CC0095
          CALL s_padd_img_data1(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,g_imo.imo01,b_imp.imp02,g_imo.imo02)  #FUN-CC0095
       END IF

       CALL s_chk_imgg(b_imp.imp03,b_imp.imp11,
                       b_imp.imp12,b_imp.imp13,
                       b_imp.imp20) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,b_imp.imp20,g_imo.imo01,b_imp.imp02,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,b_imp.imp20,g_imo.imo01,b_imp.imp02)  #FUN-CC0095
       END IF 
       CALL s_chk_imgg(b_imp.imp03,b_imp.imp11,
                       b_imp.imp12,b_imp.imp13,
                       b_imp.imp23) RETURNING g_flag
       IF g_flag = 1 THEN
          #CALL s_padd_imgg_data(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,b_imp.imp23,g_imo.imo01,b_imp.imp02,l_imgg_table)  #FUN-CC0095
          CALL s_padd_imgg_data1(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,b_imp.imp23,g_imo.imo01,b_imp.imp02)  #FUN-CC0095
       END IF  
   END FOREACH 
   #FUN-CC0095---begin mark
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_img_table CLIPPED #g_cr_db_str,
   #PREPARE cnt_img FROM g_sql
   #LET l_cnt_img = 0
   #EXECUTE cnt_img INTO l_cnt_img
   #
   #LET g_sql = " SELECT COUNT(*) ",
   #            " FROM ",l_imgg_table CLIPPED #g_cr_db_str,
   #PREPARE cnt_imgg FROM g_sql 
   #LET l_cnt_imgg = 0
   #EXECUTE cnt_imgg INTO l_cnt_imgg
   #FUN-CC0095---end
   LET l_cnt_img = g_padd_img.getLength()  #FUN-CC0095
   LET l_cnt_imgg = g_padd_imgg.getLength()  #FUN-CC0095
   
   IF g_sma.sma892[3,3] = 'Y' AND (l_cnt_img > 0 OR l_cnt_imgg > 0) THEN
      IF cl_confirm('mfg1401') THEN 
         IF l_cnt_img > 0 THEN 
            #IF NOT s_padd_img_show(l_img_table) THEN  #FUN-CC0095
            IF NOT s_padd_img_show1() THEN  #FUN-CC0095
               #CALL s_padd_img_del(l_img_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF 
         IF l_cnt_imgg > 0 THEN #FUN-CC0095
            #IF NOT s_padd_imgg_show(l_imgg_table) THEN  #FUN-CC0095
            IF NOT s_padd_imgg_show1() THEN  #FUN-CC0095
               #CALL s_padd_imgg_del(l_imgg_table) #FUN-CC0095
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF  #FUN-CC0095
      ELSE
         #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
         #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #CALL s_padd_img_del(l_img_table)  #FUN-CC0095
   #CALL s_padd_imgg_del(l_imgg_table)  #FUN-CC0095
   #FUN-C70087---end
    
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t306_cl USING g_imo.imo01
    IF STATUS THEN
       CALL cl_err("OPEN t306_cl:", STATUS, 1)
       CLOSE t306_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t306_cl INTO g_imo.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t306_cl ROLLBACK WORK RETURN
    END IF
    DECLARE t306_s_cs CURSOR FOR
      SELECT * FROM imp_file WHERE imp01=g_imo.imo01
      
    CALL s_showmsg_init()   #No.FUN-6C0083 
 
    FOREACH t306_s_cs INTO b_imp.*
   
       CALL t306_t()
       IF g_success='N' THEN    #No.FUN-6C0083
          LET g_totsuccess="N"
          LET g_success="Y"
          CONTINUE FOREACH
       END IF
    END FOREACH
 
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
    CALL s_showmsg()   #No.FUN-6C0083
    MESSAGE ""
    UPDATE imo_file SET imopost='Y' WHERE imo01=g_imo.imo01
    IF sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
    IF g_success = 'Y'
       THEN
       LET g_imo.imopost='Y'
       DISPLAY BY NAME g_imo.imopost
       CALL cl_cmmsg(1) COMMIT WORK
       CALL cl_flow_notify(g_imo.imo01,'S')
    ELSE
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
END FUNCTION
 
FUNCTION t306_w()
DEFINE l_qty   LIKE img_file.img08
DEFINE la_tlf  DYNAMIC ARRAY OF RECORD LIKE tlf_file.*  #NO.FUN-8C0131 
DEFINE l_sql   STRING                                   #NO.FUN-8C0131 
DEFINE l_i     LIKE type_file.num5                      #NO.FUN-8C0131
DEFINE l_ima918     LIKE ima_file.ima918   #No:FUN-C50071
DEFINE l_ima921     LIKE ima_file.ima921   #No:FUN-C50071
#FUN-A80106 add --start--
#&ifdef ICD  #CHI-CC0028
DEFINE l_flag   LIKE type_file.num5   #判斷s_icdpost()成功/失敗
#&endif  #CHI-CC0028
#FUN-A80106 add --end-- 
DEFINE l_imp11   LIKE imp_file.imp11     #CHI-CC0028
DEFINE l_imp12   LIKE imp_file.imp12     #CHI-CC0028
DEFINE l_imp02   LIKE imp_file.imp02     #CHI-CC0028
DEFINE g_flag    LIKE type_file.chr1     #CHI-CC0028

    SELECT * INTO g_imo.* FROM imo_file WHERE imo01=g_imo.imo01
    IF cl_null(g_imo.imo01) THEN CALL cl_err("",-400,0) RETURN END IF
    IF g_imo.imo07 = 'Y' THEN
        CALL cl_err(g_imo.imo01,'aec-078',0)  #已結案 !!
        RETURN
    END IF
    IF g_imo.imoconf='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_imo.imoconf='N' THEN CALL cl_err('','9029',0) RETURN END IF
    IF g_imo.imopost='N' THEN CALL cl_err('','afa-108',0) RETURN END IF
    #若已有對應的還料單(不論還料單的狀態過帳,未過帳,或是作廢)就不可執行W.過帳還原,
    #出訊息『此借料單號已有對應的還料單,不可過帳還原』
    #FUN-BC0062 ---------Begin--------
    #當成本計算方式ccz28選擇'6'，過帳還原時控制不可過帳還原
       SELECT ccz_file.* INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
       IF g_ccz.ccz28  = '6' THEN
          CALL cl_err('','apm-936',1)
          RETURN
       END IF
    #FUN-BC0062 ---------End----------
    #CHI-CC0028---begin
    LET g_flag = 'Y'
    DECLARE t306_w_cs1 CURSOR FOR SELECT imp02,imp11,imp12 FROM imp_file 
                                   WHERE imp01=g_imo.imo01
 
    CALL s_showmsg_init()
 
    FOREACH t306_w_cs1 INTO l_imp02,l_imp11,l_imp12
      CALL s_incchk(l_imp11,l_imp12,g_user) 
      RETURNING l_flag
      IF l_flag = FALSE THEN
         LET g_flag='N'
         LET g_showmsg=l_imp02,"/",l_imp11,"/",l_imp12,"/",g_user                                                                   
         CALL s_errmsg('imp02,imp11,imp12,inc03',g_showmsg,'','asf-888',1)
      END IF
    END FOREACH
    CALL s_showmsg()                                                                                                                 
    IF g_flag='N' THEN                                                                                                            
       RETURN                                                                                                                        
    END IF
    #CHI-CC0028---end
    SELECT COUNT(*) INTO g_cnt
      FROM imr_file,imq_file
     WHERE imr01   = imq01
       AND (imr05  = g_imo.imo01 OR imq03 = g_imo.imo01)
    IF g_cnt > 0 THEN
        #此借料單號已有對應的還料單,不可過帳還原
        CALL cl_err(g_imo.imo01,'aim-114',0)
        RETURN
    END IF

     IF NOT t306_chk_sma() THEN RETURN END IF #MOD-4A0201
    IF NOT cl_sure(21,20) THEN RETURN END IF
 
    LET g_success='Y'
    BEGIN WORK
 
    OPEN t306_cl USING g_imo.imo01
    IF STATUS THEN
       CALL cl_err("OPEN t306_cl:", STATUS, 1)
       CLOSE t306_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t306_cl INTO g_imo.*            # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
        CLOSE t306_cl ROLLBACK WORK RETURN
    END IF
 
    CALL s_showmsg_init()   #No.FUN-6C0083 
 
    DECLARE t306_w_cs CURSOR FOR
      SELECT * FROM imp_file WHERE imp01=g_imo.imo01
 
    FOREACH t306_w_cs INTO b_imp.*
 
       LET l_qty = b_imp.imp04 * b_imp.imp14_fac
 
       CALL t306_get_value()
       LET g_forupd_sql = "SELECT img01,img02,img03,img04 FROM img_file ",                                                                            
                          "  WHERE img01 = ? AND img02 = ? ",                                                                       
                          "    AND img03 = ? AND img04 = ? FOR UPDATE "                                                             
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE img3_lock CURSOR FROM g_forupd_sql                                                                                   
       OPEN img3_lock USING b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13                                                         
       IF STATUS THEN                                                                                                               
          CALL cl_err('lock img3 fail',STATUS,1)                                                                                    
          LET g_success = 'N'                                                                                                       
          RETURN                                                                                                                    
       END IF                                                                                                                       
       FETCH img3_lock INTO b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13                                                                                                 
       IF STATUS THEN                                                                                                               
          CALL cl_err('lock img3 fail',STATUS,1)                                                                                    
          LET g_success = 'N'                                                                                                       
          RETURN                                                                                                                    
       END IF                                                                                                                       
       IF NOT s_stkminus(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,
                        #b_imp.imp04,b_imp.imp14_fac,g_imo.imo02,g_sma.sma894[5,5]) THEN    #FUN-D30024--mark
                        b_imp.imp04,b_imp.imp14_fac,g_imo.imo02) THEN                       #FUN-D30024--add
 
          LET g_totsuccess="N"   #No.FUN-6C0083
          LET g_success="Y"
          CONTINUE FOREACH
       END IF
#FUN-A80106 add --start--
        #FUN-B30187 --START--        
        SELECT * INTO b_impi.* FROM impi_file 
         WHERE impi01=g_imo.imo01 AND impi02=b_imp.imp02        
        IF SQLCA.sqlcode THEN
            CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)
            LET g_success = 'N'                                                                                                       
            RETURN
        END IF 
        #FUN-B30187 --END--
        CALL s_icdpost(1,b_imp.imp03,b_imp.imp11,b_imp.imp12,
                       b_imp.imp13,b_imp.imp14,b_imp.imp04,
                       b_imp.imp01,b_imp.imp02,g_imo.imo02,'N',
                       '','',b_impi.impiicd029,b_impi.impiicd028,'') #FUN-B30187  #FUN-B80119--傳入p_plant參數''---
             RETURNING l_flag
        IF l_flag = 0 THEN
           LET g_success = 'N'
           RETURN
        END IF
#FUN-A80106 add --end--        
 
       CALL s_upimg(b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,-1,l_qty,g_imo.imo02, #FUN-8C0084
                    b_imp.imp03,b_imp.imp11,b_imp.imp12,b_imp.imp13,
                   #g_imo.imo01,'',b_imp.imp05,b_imp.imp04,b_imp.imp14,          #FUN-C50071 mark
                    g_imo.imo01,b_imp.imp02,b_imp.imp05,b_imp.imp04,b_imp.imp14, #FUN-C50071 add
                    b_imp.imp14_fac,g_ima25_fac,1, #FUN-560183 g_ima86->1
                    '','','','','','')
 
       IF g_success = 'N' THEN    #No.FUN-6C0083
          LET g_totsuccess="N"
          LET g_success="Y"
          CONTINUE FOREACH
       END IF
 
       IF s_udima(b_imp.imp03,g_img23, g_img24,
                  b_imp.imp04*b_imp.imp14_fac,g_imo.imo02, +1) THEN
          LET g_success='N' EXIT FOREACH
       END IF

  ##NO.FUN-8C0131   add--begin   
    LET l_sql =  " SELECT  * FROM tlf_file ", 
                 "  WHERE  tlf01 = '",b_imp.imp03,"'",
                 "    AND tlf036='",g_imo.imo01,"' AND tlf037='",b_imp.imp02,"'",
                 "   AND tlf03 =50"     
    DECLARE t306_u_tlf_c CURSOR FROM l_sql
    LET l_i = 0 
    CALL la_tlf.clear()
    FOREACH t306_u_tlf_c INTO g_tlf.*
       LET l_i = l_i + 1
       LET la_tlf[l_i].* = g_tlf.*
    END FOREACH     

  ##NO.FUN-8C0131   add--end 
 
       DELETE FROM tlf_file
        WHERE tlf01 =b_imp.imp03 AND tlf036=g_imo.imo01
          AND tlf037=b_imp.imp02 AND tlf03 =50
       IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
          LET g_showmsg = b_imp.imp03,"/",g_imo.imo01,"/",b_imp.imp02,"/",50
          CALL s_errmsg('tlf01,tlf036,tlf037,tlf03',g_showmsg,'del tlf:',SQLCA.sqlcode,1)
          LET g_success='N'
          CONTINUE FOREACH
       END IF
  ##NO.FUN-8C0131   add--begin
       FOR l_i = 1 TO la_tlf.getlength()
          LET g_tlf.* = la_tlf[l_i].*
          IF NOT s_untlf1('') THEN 
             LET g_success='N' RETURN
          END IF 
       END FOR       
  ##NO.FUN-8C0131   add--end 

#FUN-C50071 add begin-------------------------
       SELECT ima918,ima921 INTO l_ima918,l_ima921
         FROM ima_file
        WHERE ima01 = b_imp.imp03
          AND imaacti = "Y"
       
       IF l_ima918 = "Y" OR l_ima921 = "Y" THEN
          DELETE FROM tlfs_file
          WHERE tlfs01 = b_imp.imp03
            AND tlfs10 = b_imp.imp01
            AND tlfs11 = b_imp.imp02
       
          IF STATUS OR SQLCA.SQLCODE THEN
             CALL cl_err3("del","tlfs_file",b_imp.imp01,"",STATUS,"","del tlfs",1)
             LET g_success='N'
             RETURN
           END IF
       
          IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","tlfs_file",b_imp.imp01,"","mfg0177","","del tlfs",1)
             LET g_success='N'
             RETURN
          END IF
       END IF
#FUN-C50071 add -end--------------------------

       IF g_sma.sma115='Y' THEN
          CALL t306_update_du(-1)
          IF g_success='N' THEN    #No.FUN-6C0083
             LET g_totsuccess="N"
             LET g_success="Y"
             CONTINUE FOREACH
          END IF
          SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=b_imp.imp03
          IF g_ima906 MATCHES '[23]' THEN
             DELETE FROM tlff_file
              WHERE tlff01 =b_imp.imp03 AND tlff036=g_imo.imo01
                AND tlff037=b_imp.imp02 AND tlff03 =50
             IF SQLCA.sqlerrd[3]=0 OR SQLCA.sqlcode THEN
                LET g_showmsg = b_imp.imp03,"/",g_imo.imo01,"/",b_imp.imp02,"/",50
                CALL s_errmsg('tlff01,tlff036,tlff037,tlff03',g_showmsg,'del tlff:',SQLCA.sqlcode,1)
                LET g_success='N'
                CONTINUE FOREACH
             END IF
          END IF
       END IF
 
    END FOREACH
 
    IF g_totsuccess="N" THEN
       LET g_success="N"
       CALL s_showmsg_init()   #No.FUN-6C0083 
    END IF
 
    UPDATE imo_file SET imopost='N' WHERE imo01=g_imo.imo01
    IF sqlca.sqlcode or sqlca.sqlerrd[3]=0 THEN LET g_success='N' END IF
 
    IF g_success = 'Y' THEN
       LET g_imo.imopost='N'
       CALL cl_cmmsg(1) COMMIT WORK
    ELSE
       LET g_imo.imopost='Y'
       CALL cl_rbmsg(1) ROLLBACK WORK
    END IF
    DISPLAY BY NAME g_imo.imopost
END FUNCTION
 
#====>作廢/作廢還原功能
#FUNCTION t306_x()        #CHI-D20010
FUNCTION t306_x(p_type)   #CHI-D20010
#FUN-A80106 add --start--
   DEFINE l_flag    LIKE type_file.chr1     #判斷BIN/刻號處理成功否
#FUN-A80106 add --end--
DEFINE l_flag1 LIKE type_file.chr1  #CHI-D20010
DEFINE p_type  LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_imo.* FROM imo_file WHERE imo01=g_imo.imo01
   IF cl_null(g_imo.imo01) THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_imo.imo07 = 'Y' THEN
       CALL cl_err(g_imo.imo01,'aec-078',0)  #已結案 !!
       RETURN
   END IF
    IF NOT t306_chk_sma() THEN RETURN END IF #MOD-4A0201
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_imo.imoconf ='X' THEN RETURN END IF
   ELSE
      IF g_imo.imoconf <>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end

   BEGIN WORK
   LET g_success='Y'
 
   OPEN t306_cl USING g_imo.imo01
   IF STATUS THEN
      CALL cl_err("OPEN t306_cl:", STATUS, 1)
      CLOSE t306_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t306_cl INTO g_imo.* #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0) #資料被他人LOCK
       CLOSE t306_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_imo.imoconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   IF g_imo.imoconf = 'X' THEN  LET l_flag1 = 'X' ELSE LET l_flag1 = 'N' END IF #CHI-D20010
  #IF cl_void(0,0,g_imo.imoconf)   THEN  #CHI-D20010
   IF cl_void(0,0,l_flag1)   THEN        #CHI-D20010
        LET g_chr=g_imo.imoconf
       #IF g_imo.imoconf ='N' THEN   #CHI-D20010
        IF p_type = 1  THEN          #CHI-D20010
#FUN-A80106 add --start--
            #若已有ida/idb詢問且一併刪
            LET g_cnt = 0
            #入庫
            SELECT COUNT(*) INTO g_cnt FROM ida_file
             WHERE ida07 = g_imo.imo01
            IF g_cnt > 0 THEN
               IF NOT cl_confirm('aic-112') THEN
                  CLOSE t306_cl
                  ROLLBACK WORK
                  RETURN
               ELSE
                  LET g_cnt = 0
                  #入庫
                  CALL s_icdinout_del(1,g_imo.imo01,'','')  #FUN-B80119--傳入p_plant參數''---
                       RETURNING l_flag
                  IF l_flag = 0 THEN
                     CLOSE t306_cl
                     ROLLBACK WORK
                     RETURN
                  END IF
               END IF
            END IF
#FUN-A80106 add --end--        
            LET g_imo.imoconf='X'
        ELSE
            LET g_imo.imoconf='N'
        END IF
        UPDATE imo_file
            SET imoconf=g_imo.imoconf,
                imomodu=g_user,
                imodate=g_today
            WHERE imo01  =g_imo.imo01
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","imo_file",g_imo.imo01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
            LET g_imo.imoconf = g_chr
        END IF
        DISPLAY BY NAME g_imo.imoconf
   END IF
   CLOSE t306_cl
   COMMIT WORK
   CALL cl_flow_notify(g_imo.imo01,'V')
END FUNCTION
 
FUNCTION t306_y()
DEFINE l_cnt   LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE l_buf       LIKE gem_file.gem02 #TQC-B50032
#FUN-A80106 add --start--
DEFINE l_flag      LIKE type_file.chr1
#DEFINE l_imaicd08  LIKE imaicd_file.imaicd08   #FUN-BA0051 mark
#FUN-A80106 add --end--
#FUN-C50071 add begin-------------------------
DEFINE l_rvbs06       LIKE rvbs_file.rvbs06
DEFINE l_imp14_fac    LIKE imp_file.imp14_fac
#FUN-C50071 add -end--------------------------

   IF s_shut(0) THEN RETURN END IF
#CHI-C30107 ------------ add --------------- begin
   IF cl_null(g_imo.imo01) THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_imo.imo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_imo.imoconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_imo.imoconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_imo.imo07 = 'Y' THEN
       CALL cl_err(g_imo.imo01,'aec-078',0)  #已結案 !!
       RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------------ add --------------- end
   SELECT * INTO g_imo.* FROM imo_file WHERE imo01=g_imo.imo01
   IF cl_null(g_imo.imo01) THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_imo.imo01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_imo.imoconf = 'Y' THEN CALL cl_err('','9023',0) RETURN END IF
   IF g_imo.imoconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
   IF g_imo.imo07 = 'Y' THEN
       CALL cl_err(g_imo.imo01,'aec-078',0)  #已結案 !!
       RETURN
   END IF
   #TQC-B50032--begin
   IF NOT cl_null(g_imo.imo08) THEN
      SELECT gem02 INTO l_buf FROM gem_file
       WHERE gem01=g_imo.imo08  
         AND gemacti='Y'   
      IF STATUS THEN
         CALL cl_err3("sel","gem_file",g_imo.imo08,"",SQLCA.sqlcode,"","select gem",1)
         RETURN 
      END IF
   END IF
   #TQC-B50032--end 
#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM imp_file
    WHERE imp01=g_imo.imo01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   
#FUN-A80106 add --start--
   DECLARE t306_y_chk_c CURSOR FOR SELECT * FROM imp_file
                                   WHERE imp01=g_imo.imo01
   FOREACH t306_y_chk_c INTO b_imp.*     
      #FUN-BA0051 --START mark--   
      #LET l_imaicd08 = NULL
      #SELECT imaicd08 INTO l_imaicd08
      #  FROM imaicd_file
      # WHERE imaicd00 = b_imp.imp03
      # IF l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
       IF s_icdbin(b_imp.imp03) THEN   #FUN-BA0051      
          CALL s_icdchk(1,b_imp.imp03,
                          b_imp.imp11,
                          b_imp.imp12, 
                          b_imp.imp13, 
                          b_imp.imp04, 
                          b_imp.imp01, 
                          b_imp.imp02, 
                          g_imo.imo02,'')  #FUN-B80119--傳入p_plant參數''---
                  RETURNING l_flag
          IF l_flag = 0 THEN
             CALL cl_err(b_imp.imp02,'aic-056',1)
             LET g_success = 'N'
             RETURN
          END IF
       END IF            
   END FOREACH
   IF g_success = 'N' THEN RETURN END IF       
#FUN-A80106 add --end--   
#No.FUN-AA0049--begin
   LET g_success='Y' 
   CALL s_showmsg_init()   
   DECLARE t306_chk_ware CURSOR FOR SELECT * FROM imp_file
                                   WHERE imp01=g_imo.imo01
   FOREACH t306_chk_ware INTO b_imp.*           
      IF NOT s_chk_ware(b_imp.imp11) THEN
         LET g_success='N' 
      END IF 
#FUN-C50071 add begin-------------------------
      SELECT ima918,ima921 INTO g_ima918,g_ima921
        FROM ima_file
       WHERE ima01 = g_imp[l_ac].imp03
         AND imaacti = "Y"

      IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
         SELECT SUM(rvbs06) INTO l_rvbs06
           FROM rvbs_file
          WHERE rvbs00 = g_prog
            AND rvbs01 = g_imo.imo01
            AND rvbs02 = g_imp[l_ac].imp02
            AND rvbs13 = 0
            AND rvbs09 = 1

         IF cl_null(l_rvbs06) THEN
            LET l_rvbs06 = 0
         END IF

         SELECT img09 INTO g_img09 FROM img_file
          WHERE img01 = g_imp[l_ac].imp03 AND img02 = g_imp[l_ac].imp11
            AND img03 = g_imp[l_ac].imp12 AND img04 = g_imp[l_ac].imp13

         CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp14,g_img09) RETURNING l_cnt,l_imp14_fac
         IF l_cnt = 1 THEN
            LET l_imp14_fac = 1
         END IF
         IF (g_imp[l_ac].imp04 * l_imp14_fac) <> l_rvbs06 THEN
            LET g_success = "N"
            CALL cl_err(g_imp[l_ac].imp03,"aim-011",1)
            EXIT FOREACH
         END IF
      END IF
      #TQC-D20042---add---str---
       IF g_aza.aza115='Y' AND cl_null(b_imp.imp16) THEN
          CALL cl_err('','aim-888',1)
          LET g_success = "N"
          EXIT FOREACH
       END IF 
      #TQC-D20042---add---end--- 
#FUN-C50071 add -end--------------------------
   END FOREACH 
   CALL s_showmsg()
   LET g_bgerr=0 
   IF g_success='N' THEN 
      RETURN 
   END IF 
#No.FUN-AA0049--end 
    IF NOT t306_chk_sma() THEN RETURN END IF #MOD-4A0201
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
 
   BEGIN WORK
   LET g_success = 'Y' 
   OPEN t306_cl USING g_imo.imo01
   IF STATUS THEN
      CALL cl_err("OPEN t306_cl:", STATUS, 1)
      CLOSE t306_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t306_cl INTO g_imo.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t306_cl
       ROLLBACK WORK
       RETURN
   END IF
   
   UPDATE imo_file
      SET imoconf = 'Y'
    WHERE imo01 = g_imo.imo01
   IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","imo_file",g_imo.imo01,"",SQLCA.sqlcode,"",
                    "up imo_file",0)  #No.FUN-660156
       LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN COMMIT WORK
           CALL cl_flow_notify(g_imo.imo01,'Y')
      ELSE ROLLBACK WORK
   END IF
   SELECT imoconf INTO g_imo.imoconf
     FROM imo_file
    WHERE imo01 = g_imo.imo01
   DISPLAY BY NAME g_imo.imoconf
END FUNCTION
 
FUNCTION t306_z()
   DEFINE l_cnt     LIKE type_file.num5      #FUN-680010  #No.FUN-690026 SMALLINT
 
   SELECT * INTO g_imo.* FROM imo_file WHERE imo01=g_imo.imo01
   IF cl_null(g_imo.imo01) THEN CALL cl_err("",-400,0) RETURN END IF
   IF g_imo.imoconf = 'N' THEN CALL cl_err(g_imo.imo01,'aap-717',0) RETURN END IF
   IF g_imo.imopost = 'Y' THEN CALL cl_err('','afa-106',0) RETURN END IF
   IF g_imo.imo07 = 'Y'   THEN CALL cl_err('','aec-078',0) RETURN END IF
   IF g_imo.imoconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF
 
   #-->已有QC單則不可取消確認
   SELECT COUNT(*) INTO l_cnt FROM qcs_file
    WHERE qcs01 = g_imo.imo01 AND qcs00='E'  
   IF l_cnt > 0 THEN
      CALL cl_err(' ','aqc-118',0)
      RETURN
   END IF
 
   IF g_imo.imo07 = 'Y' THEN
       CALL cl_err(g_imo.imo01,'aec-078',0)  #已結案 !!
       RETURN
   END IF
    IF NOT t306_chk_sma() THEN RETURN END IF #MOD-4A0201
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN t306_cl USING g_imo.imo01
   IF STATUS THEN
      CALL cl_err("OPEN t306_cl:", STATUS, 1)
      CLOSE t306_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t306_cl INTO g_imo.*            # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_imo.imo01,SQLCA.sqlcode,0)      # 資料被他人LOCK
       CLOSE t306_cl
       ROLLBACK WORK
       RETURN
   END IF
   UPDATE imo_file SET imoconf = 'N'
    WHERE imo01 = g_imo.imo01
   IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","imo_file",g_imo.imo01,"",SQLCA.sqlcode,"",
                    "up imo_file",0)  #No.FUN-660156
       LET g_success = 'N'
   END IF
   IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
   END IF
   SELECT imoconf INTO g_imo.imoconf FROM imo_file
    WHERE imo01 = g_imo.imo01
   DISPLAY BY NAME g_imo.imoconf
END FUNCTION
 
FUNCTION t306_out()
DEFINE
    l_i             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
    sr              RECORD
        imo01       LIKE imo_file.imo01,   #單頭
        imo02       LIKE imo_file.imo02,   #
        imo03       LIKE imo_file.imo03,   #
        imo04       LIKE imo_file.imo04,   #
        imo05       LIKE imo_file.imo05,   #
        imo06       LIKE imo_file.imo06,   #
        gen02       LIKE gen_file.gen02,   #
        imoconf     LIKE imo_file.imoconf, #
        imopost     LIKE imo_file.imopost, #
        imp02       LIKE imp_file.imp02  , #單身
        imp03       LIKE imp_file.imp03  , #
        imp04       LIKE imp_file.imp04  , #
        imp05       LIKE imp_file.imp05  , #
        imp06       LIKE imp_file.imp06  , #
        imp07       LIKE imp_file.imp07  , #
        imp11       LIKE imp_file.imp11  , #
        imp12       LIKE imp_file.imp12  , #
        imp13       LIKE imp_file.imp13  , #
        ima02       LIKE ima_file.ima02  , #
        ima021      LIKE ima_file.ima021
       END RECORD,
    l_name          LIKE type_file.chr20,           #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
    l_za05          LIKE za_file.za05,              #No.FUN-690026 VARCHAR(40)
    l_wc            STRING,                          #MOD-AA0106
    l_prog          STRING                          #FUN-C30062
    
    CALL cl_del_data(l_table)                       #NO.FUN-840020
    IF g_imo.imo01 IS NULL THEN CALL cl_err("",-400,0) RETURN END IF
    IF cl_null(g_wc) THEN
        LET g_wc=" imo01='",g_imo.imo01,"'"
    END IF
    IF cl_null(g_wc2) THEN
        LET g_wc2=" 1=1 "
    END IF
    CALL cl_wait()
    SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
    SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'aimt306' #NO.FUN-840020
    LET g_sql="SELECT imo01,imo02,imo03,imo04,imo05,imo06,gen02,imoconf,imopost,",    #單頭
              "       imp02,imp03,imp04,imp05,imp06,imp07,imp11,imp12,imp13,ima02,ima021 ",
              " FROM imo_file,imp_file,OUTER gen_file,OUTER ima_file",
              " WHERE imo01 = imp01 ",
              "   AND gen_file.gen01 = imo_file.imo06 ",
              "   AND ima_file.ima01 = imp_file.imp03 ",
              "   AND ",g_wc  CLIPPED,
              "   AND ",g_wc2 CLIPPED,
              " ORDER BY imo01,imo02,imo03,imp02,imp03"
    PREPARE t306_p1 FROM g_sql                # RUNTIME 編譯
    DECLARE t306_co                         # CURSOR
        CURSOR FOR t306_p1
 
    FOREACH t306_co INTO sr.*
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
            END IF
       EXECUTE insert_prep USING
         sr.imo01,sr.imo02,sr.imo03,sr.imo04,sr.imo05,sr.imo06,sr.imoconf,sr.imopost,sr.imp02,  #MOD-890194 add imoconf,imopost
         sr.imp03,sr.imp04,sr.imp05,sr.imp06,sr.imp07,sr.imp11,sr.imp12,
         sr.imp13,sr.ima02,sr.ima021
    END FOREACH
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05 = 'Y' THEN 
        CALL cl_wcchp(g_wc,'imo01,imo02,imo03,imo04,imo05,imo06,imo08,imoconf,                            imospc,imopost,imo07,imouser,imogrup,imomodu,imodate,                            imp02,imp03,imp05,imp04,imp08,imp09,imp07,imp11,                            imp12,imp13,imp14,imp23,imp25,imp20,imp22,imp06,                            imp15,imp930')
          #RETURNING g_wc          #MOD-AA0106 mark   
           RETURNING l_wc          #MOD-AA0106 add 
     END IF
    #LET g_str = g_wc              #MOD-AA0106 mark          
     LET g_str = l_wc              #MOD-AA0106 add 
     LET l_prog = g_prog            #FUN-C30062
     LET g_prog = 'aimt306'         #FUN-C30062
     CALL cl_prt_cs3('aimt306','aimt306',g_sql,g_str) 
     LET g_prog = l_prog            #FUN-C30062
    CLOSE t306_co
    ERROR ""
END FUNCTION
#單頭
FUNCTION t306_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("imo01",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION t306_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("imo01",FALSE)
       END IF
   END IF
 
END FUNCTION
 
#單身
FUNCTION t306_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
      #CALL cl_set_comp_entry("imp02,imp03,imp05,imp04,imp07,imp11,imp12,imp13,imp06",TRUE)     #MOD-AC0105 mark
       CALL cl_set_comp_entry("imp02,imp03,imp05,imp04,imp11,imp12,imp13,imp06",TRUE)           #MOD-AC0105 add 
   END IF
 
   CALL cl_set_comp_entry("imp23,imp25",TRUE)

   CALL cl_set_comp_entry("impiicd028,impiicd029",TRUE)   #FUN-B30187
 
END FUNCTION
 
FUNCTION t306_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE l_imaicd09 LIKE imaicd_file.imaicd09  #TQC-C60020
#DEFINE   l_imaicd08 LIKE imaicd_file.imaicd08   #FUN-B30187   #FUN-BA0051 mark
 
   IF (NOT g_before_input_done) THEN
       IF g_v = 'Y' THEN
            CALL cl_set_comp_entry("imp02,imp03,imp05,imp04,imp07,imp11,imp12,imp13,imp14,imp06",FALSE)   #No.MOD-480340
       END IF
       IF g_sma.sma12 != 'Y' THEN
           CALL cl_set_comp_entry("imp11,imp12,imp13",FALSE)
       END IF
   END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("imp23,imp25",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("imp23",FALSE)
   END IF

   #FUN-B30187 --START--
   IF INFIELD(imp03) THEN  #FUN-C30302
     IF l_ac > 0 THEN
      #FUN-BA0051 --START mark--
      #SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
      #             WHERE imaicd00 = g_imp[l_ac].imp03
      #IF NOT cl_null(l_imaicd08) AND l_imaicd08 = 'Y' THEN
      #FUN-BA0051 --END mark--
         IF s_icdbin(g_imp[l_ac].imp03) THEN   #FUN-BA0051
            CALL cl_set_comp_entry("impiicd028,impiicd029",FALSE)
         END IF
         #TQC-C60020---begin
         IF NOT cl_null(g_imp[l_ac].imp03) THEN 
            SELECT imaicd09 INTO l_imaicd09 FROM imaicd_file
             WHERE imaicd00 = g_imp[l_ac].imp03
            IF l_imaicd09 = 'Y' THEN
               CALL cl_set_comp_entry('impiicd028',TRUE)
            ELSE
               CALL cl_set_comp_entry('impiicd028',FALSE)
            END IF 
         END IF 
         #TQC-C60020---end
      END IF  
   END IF #FUN-C30302   
   #FUN-B30187 --END--
 
END FUNCTION
 
FUNCTION t306_chk_sma()
    
    
    IF g_sma.sma53 IS NOT NULL AND g_imo.imo02 <= g_sma.sma53 THEN
        CALL cl_err('','mfg9999',0)
        RETURN FALSE
    END IF
    CALL s_yp(g_imo.imo02) RETURNING g_yy,g_mm
    IF g_yy > g_sma.sma51 THEN # 與目前會計年度,期間比較
        CALL cl_err(g_yy,'mfg6090',0)
        RETURN FALSE
    ELSE
        IF g_yy=g_sma.sma51 AND g_mm > g_sma.sma52 THEN
            CALL cl_err(g_mm,'mfg6091',0)
            RETURN FALSE
        END IF
    END IF
    RETURN TRUE
END FUNCTION
 
FUNCTION t306_mu_ui()
    CALL cl_set_comp_visible("imp21,imp24",FALSE)
    CALL cl_set_comp_visible("imp20,imp23,imp22,imp25",g_sma.sma115='Y')
    CALL cl_set_comp_visible("imp04,imp05,imp14_fac",g_sma.sma115='N')
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp23",g_msg CLIPPED)
       CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp25",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp20",g_msg CLIPPED)
       CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp22",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp23",g_msg CLIPPED)
       CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp25",g_msg CLIPPED)
       CALL cl_getmsg('asm-397',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp20",g_msg CLIPPED)
       CALL cl_getmsg('asm-398',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("imp22",g_msg CLIPPED)
    END IF
    IF g_aaz.aaz90='Y' THEN
       CALL cl_set_comp_required("imo08",TRUE)
    END IF
    CALL cl_set_comp_visible("imp930,gem02c",g_aaz.aaz90='Y')  #FUN-670093
 
    IF g_aza.aza64 matches '[ Nn]' THEN
       CALL cl_set_comp_visible("imospc",FALSE)
       CALL cl_set_act_visible("trans_spc",FALSE)
    END IF 
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t306_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ware   LIKE img_file.img02,     #倉庫
            l_loc    LIKE img_file.img03,     #儲
            l_lot    LIKE img_file.img04,     #批
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            p_cmd    LIKE type_file.chr1,     #No.FUN-690026 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    LET l_item = g_imp[l_ac].imp03
    LET l_ware = g_imp[l_ac].imp11
    LET l_loc  = g_imp[l_ac].imp12
    LET l_lot  = g_imp[l_ac].imp13
 
    SELECT ima25,ima906,ima907 INTO l_ima25,l_ima906,l_ima907
      FROM ima_file WHERE ima01 = l_item
 
    SELECT img09 INTO g_img09 FROM img_file
     WHERE img01 = l_item
       AND img02 = l_ware
       AND img03 = l_loc
       AND img04 = l_lot
    IF cl_null(g_img09) THEN LET g_img09 = l_ima25 END IF
 
    IF l_ima906 = '1' THEN  #不使用雙單位
       LET l_unit2 = NULL
       LET l_fac2  = NULL
       LET l_qty2  = NULL
    ELSE
       LET l_unit2 = l_ima907
       CALL s_du_umfchk(l_item,'','','',g_img09,l_ima907,l_ima906)
            RETURNING g_errno,l_factor
       LET l_fac2 = l_factor
       LET l_qty2  = 0
    END IF
    LET l_unit1 = g_img09
    LET l_fac1  = 1
    LET l_qty1  = 0
 
    IF p_cmd = 'a' OR g_change = 'Y' THEN
       LET g_imp[l_ac].imp23 =l_unit2
       LET g_imp[l_ac].imp24 =l_fac2
       LET g_imp[l_ac].imp25 =l_qty2
       LET g_imp[l_ac].imp20 =l_unit1
       LET g_imp[l_ac].imp21 =l_fac1
       LET g_imp[l_ac].imp22 =l_qty1
    END IF
END FUNCTION
 
FUNCTION t306_update_du(p_type)
DEFINE l_ima25   LIKE ima_file.ima25
DEFINE p_type    LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
   SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
    WHERE ima01 = b_imp.imp03
   IF g_ima906 = '1' OR g_ima906 IS NULL THEN
      RETURN
   END IF
 
   SELECT ima25 INTO l_ima25 FROM ima_file
    WHERE ima01=b_imp.imp03
   IF SQLCA.sqlcode THEN
      LET g_success='N' RETURN
   END IF
   IF g_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(b_imp.imp25) THEN                                             #CHI-860005
         CALL t306_upd_imgg('1',b_imp.imp03,b_imp.imp11,b_imp.imp12,
                         b_imp.imp13,b_imp.imp23,b_imp.imp24,b_imp.imp25,'2',p_type)
         IF g_success='N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t306_tlff(b_imp.imp11,b_imp.imp12,b_imp.imp13,l_ima25,
                           b_imp.imp25,0,b_imp.imp23,b_imp.imp24,'2')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
      IF NOT cl_null(b_imp.imp22) THEN                                              #CHI-860005 
         CALL t306_upd_imgg('1',b_imp.imp03,b_imp.imp11,b_imp.imp12,
                         b_imp.imp13,b_imp.imp20,b_imp.imp21,b_imp.imp22,'1',p_type)
         IF g_success='N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t306_tlff(b_imp.imp11,b_imp.imp12,b_imp.imp13,l_ima25,
                           b_imp.imp22,0,b_imp.imp20,b_imp.imp21,'1')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
   IF g_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(b_imp.imp25) THEN                                             #CHI-860005
         CALL t306_upd_imgg('2',b_imp.imp03,b_imp.imp11,b_imp.imp12,
                         b_imp.imp13,b_imp.imp23,b_imp.imp24,b_imp.imp25,'2',p_type)
         IF g_success = 'N' THEN RETURN END IF
         IF p_type=1 THEN
            CALL t306_tlff(b_imp.imp11,b_imp.imp12,b_imp.imp13,l_ima25,
                           b_imp.imp25,0,b_imp.imp23,b_imp.imp24,'2')
            IF g_success='N' THEN RETURN END IF
         END IF
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t306_upd_imgg(p_imgg00,p_imgg01,p_imgg02,p_imgg03,p_imgg04,
                       p_imgg09,p_imgg211,p_imgg10,p_no,p_type)
  DEFINE p_imgg00   LIKE imgg_file.imgg00,
         p_imgg01   LIKE imgg_file.imgg01,
         p_imgg02   LIKE imgg_file.imgg02,
         p_imgg03   LIKE imgg_file.imgg03,
         p_imgg04   LIKE imgg_file.imgg04,
         p_imgg09   LIKE imgg_file.imgg09,
         p_imgg10   LIKE imgg_file.imgg10,
         p_imgg211  LIKE imgg_file.imgg211,
         l_ima25    LIKE ima_file.ima25,
         l_ima906   LIKE ima_file.ima906,
         l_imgg21   LIKE imgg_file.imgg21,
         p_no       LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
         p_type     LIKE type_file.num5     #No.FUN-690026 SMALLINT
 
    LET g_forupd_sql =
        "SELECT imgg01,imgg02,imgg03,imgg04,imgg09 FROM imgg_file ",
        "   WHERE imgg01= ? AND imgg02= ? AND imgg03= ? AND imgg04= ? ",
        "   AND imgg09= ? FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE imgg_lock CURSOR FROM g_forupd_sql
 
    OPEN imgg_lock USING p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err("OPEN imgg_lock:", STATUS, 1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
    FETCH imgg_lock INTO p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09
    IF STATUS THEN
       CALL cl_err('lock imgg fail',STATUS,1)
       LET g_success='N'
       CLOSE imgg_lock
       RETURN
    END IF
 
    SELECT ima25,ima906 INTO l_ima25,l_ima906
      FROM ima_file WHERE ima01=p_imgg01
    IF SQLCA.sqlcode OR l_ima25 IS NULL THEN
       CALL cl_err3("sel","ima_file",p_imgg01,"",SQLCA.sqlcode,"",
                    "ima25 null",0)  #No.FUN-660156
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_umfchk(p_imgg01,p_imgg09,l_ima25)
          RETURNING g_cnt,l_imgg21
    IF g_cnt = 1 AND NOT (l_ima906='3' AND p_no='2') THEN
       CALL cl_err('','mfg3075',0)
       LET g_success = 'N' RETURN
    END IF
 
    CALL s_upimgg(p_imgg01,p_imgg02,p_imgg03,p_imgg04,p_imgg09,p_type,p_imgg10,g_imo.imo02, #FUN-8C0084
          p_imgg01,p_imgg02,p_imgg03,p_imgg04,'','','','',p_imgg09,'',l_imgg21,'','','','','','','',p_imgg211)
    IF g_success='N' THEN RETURN END IF
 
END FUNCTION
 
FUNCTION t306_tlff(p_ware,p_loca,p_lot,p_unit,p_qty,p_img10,p_uom,p_factor,
                   p_flag)
DEFINE
   p_ware     LIKE img_file.img02,	 ##倉庫
   p_loca     LIKE img_file.img03,	 ##儲位
   p_lot      LIKE img_file.img04,     	 ##批號
   p_unit     LIKE img_file.img09,
   p_qty      LIKE img_file.img10,       ##數量
   p_img10    LIKE img_file.img10,       ##異動後數量
   p_uom      LIKE img_file.img09,       ##img 單位
   p_factor   LIKE img_file.img21,  	 ##轉換率
   l_imgg10   LIKE imgg_file.imgg10,
   p_flag     LIKE type_file.chr1,       #No.FUN-690026 VARCHAR(1)
   g_cnt      LIKE type_file.num5        #No.FUN-690026 SMALLINT
 
    IF cl_null(p_ware) THEN LET p_ware=' ' END IF
    IF cl_null(p_loca) THEN LET p_loca=' ' END IF
    IF cl_null(p_lot)  THEN LET p_lot=' '  END IF
    IF cl_null(p_qty)  THEN LET p_qty=0    END IF
 
    IF p_uom IS NULL THEN
       CALL cl_err('p_uom null:','asf-031',1) LET g_success = 'N' RETURN
    END IF
 
    SELECT imgg10 INTO l_imgg10 FROM imgg_file
     WHERE imgg01=b_imp.imp03 AND imgg02=p_ware
       AND imgg03=p_loca      AND imgg04=p_lot
       AND imgg09=p_uom
    IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF
    INITIALIZE g_tlff.* TO NULL
#----來源----
    LET g_tlff.tlff01=b_imp.imp03 	 #異動料件編號
    LET g_tlff.tlff02=80                 #資料目的為同業
    LET g_tlff.tlff020=g_plant           #工廠別
    LET g_tlff.tlff021=' '          	 #倉庫別
    LET g_tlff.tlff022=' '          	 #儲位別
    LET g_tlff.tlff023=' '          	 #入庫批號
    LET g_tlff.tlff024=' '          	 #異動後庫存數量
    LET g_tlff.tlff025=' '          	 #庫存單位(ima_file or imo_file)
    LET g_tlff.tlff026=g_imo.imo01       #參考單据
    LET g_tlff.tlff027=b_imp.imp02
#----目的----
    LET g_tlff.tlff03=50          	 #資料來源為倉庫
    LET g_tlff.tlff030=g_plant           #工廠別
    LET g_tlff.tlff031=p_ware            #倉庫別
    LET g_tlff.tlff032=p_loca     	 #儲位別
    LET g_tlff.tlff033=p_lot             #批號
    LET g_tlff.tlff034=l_imgg10          #異動後庫存數量
    LET g_tlff.tlff035=b_imp.imp14       #庫存單位(ima_file or imo_file)
    LET g_tlff.tlff036=g_imo.imo01       #借料單號
    LET g_tlff.tlff037=b_imp.imp02       #借料項次
#--->異動數量
    LET g_tlff.tlff04=' '                #工作站
    LET g_tlff.tlff05=' '                #作業序號
    LET g_tlff.tlff06=g_imo.imo02        #收料日期
    LET g_tlff.tlff07=g_today            #異動資料產生日期
    LET g_tlff.tlff08=TIME               #異動資料產生時:分:秒
    LET g_tlff.tlff09=g_user             #產生人
    LET g_tlff.tlff10=p_qty              #借料數量
    LET g_tlff.tlff11=p_uom              #借料單位
    LET g_tlff.tlff12=p_factor           #借料/庫存轉換率
    LET g_tlff.tlff13='aimt306'          #異動命令代號
    LET g_tlff.tlff14=' '                #異動原因
    IF g_sma.sma12='N'                   #貸方會計科目
       THEN LET g_tlff.tlff15=g_ima39    #料件會計科目
       ELSE LET g_tlff.tlff15=g_img26    #倉儲會計科目
    END IF
    LET g_tlff.tlff16=g_imo.imo05        #貸方會計科目
    LET g_tlff.tlff17=' '                #非庫存性料件編號
    CALL s_imaQOH(b_imp.imp03)
         RETURNING g_tlff.tlff18         #異動後總庫存量
    LET g_tlff.tlff19= ' '               #異動廠商/客戶編號
    LET g_tlff.tlff20= ' '               #project no.
    LET g_tlff.tlff21=  b_imp.imp10
    LET g_tlff.tlff211= g_imo.imo02
    LET g_tlff.tlff930= b_imp.imp930  #FUN-670093
    IF cl_null(b_imp.imp25) OR b_imp.imp25=0 THEN
       CALL s_tlff(p_flag,NULL)
    ELSE
       CALL s_tlff(p_flag,b_imp.imp23)
    END IF
END FUNCTION
 
FUNCTION t306_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE imn_file.imn34,
            l_qty2   LIKE imn_file.imn35,
            l_fac1   LIKE imn_file.imn31,
            l_qty1   LIKE imn_file.imn32,
            l_factor LIKE ima_file.ima31_fac  #No.FUN-690026 DECIMAL(16,8)
 
    LET l_fac2=g_imp[l_ac].imp24
    LET l_qty2=g_imp[l_ac].imp25
    LET l_fac1=g_imp[l_ac].imp21
    LET l_qty1=g_imp[l_ac].imp22
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          WHEN '1' LET g_imp[l_ac].imp05=g_imp[l_ac].imp20
                   LET g_imp[l_ac].imp04=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_imp[l_ac].imp05=g_img09
                   LET g_imp[l_ac].imp04=l_tot
          WHEN '3' LET g_imp[l_ac].imp05=g_imp[l_ac].imp20
                   LET g_imp[l_ac].imp04=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_imp[l_ac].imp24 =l_qty1/l_qty2
                   ELSE
                      LET g_imp[l_ac].imp24 =0
                   END IF
       END CASE
    END IF
    CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp05,g_img09)
         RETURNING g_cnt,g_imp[l_ac].imp14_fac
    LET g_imp[l_ac].actu=g_imp[l_ac].imp04*g_imp[l_ac].imp14_fac
    LET g_imp10         =g_imp[l_ac].imp04*g_imp[l_ac].imp09
 
END FUNCTION
 
FUNCTION t306_set_required()
 
  #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
  IF g_ima906 = '3' THEN
     CALL cl_set_comp_required("imp23,imp25,imp20,imp22",TRUE)
  END IF
  #單位不同,轉換率,數量必KEY
  IF NOT cl_null(g_imp[l_ac].imp20) THEN
     CALL cl_set_comp_required("imp22",TRUE)
  END IF
  IF NOT cl_null(g_imp[l_ac].imp23) THEN
     CALL cl_set_comp_required("imp25",TRUE)
  END IF
 
END FUNCTION
 
FUNCTION t306_set_no_required()
 
  CALL cl_set_comp_required("imp23,imp25,imp20,imp22",FALSE)
 
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t306_du_data_to_correct()
 
   IF cl_null(g_imp[l_ac].imp23) THEN
      LET g_imp[l_ac].imp24 = NULL
      LET g_imp[l_ac].imp25 = NULL
   END IF
 
   IF cl_null(g_imp[l_ac].imp20) THEN
      LET g_imp[l_ac].imp21 = NULL
      LET g_imp[l_ac].imp22 = NULL
   END IF
   DISPLAY BY NAME g_imp[l_ac].imp21
   DISPLAY BY NAME g_imp[l_ac].imp22
   DISPLAY BY NAME g_imp[l_ac].imp24
   DISPLAY BY NAME g_imp[l_ac].imp25
 
END FUNCTION
 
 
FUNCTION t306_spc()
DEFINE l_gaz03        LIKE gaz_file.gaz03
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_imp02        LIKE imp_file.imp02    ## 項次
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qc_prog      LIKE zz_file.zz01      #No.FUN-690026 VARCHAR(10)
DEFINE l_i            LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE l_cmd          STRING
DEFINE l_sql          STRING
DEFINE l_err          STRING
 
   LET g_success = 'Y'
 
   #檢查資料是否可拋轉至 SPC
   IF g_imo.imopost matches '[Yy]' THEN    #判斷是否已過帳
      CALL cl_err('imopost','aim-318',0)
      LET g_success='N'
      RETURN
   END IF
 
   #CALL aws_spccli_check('單號','SPC拋轉碼','確認碼','有效碼')
   CALL aws_spccli_check(g_imo.imo01,g_imo.imospc,g_imo.imoconf,'')
   IF g_success = 'N' THEN
      RETURN
   END IF
 
   LET l_qc_prog = "aqct700"               #設定QC單的程式代號
 
   #若在 QC 單已有此單號相關資料，則取消拋轉至 SPC
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imo.imo01  
   IF l_cnt > 0 THEN
      CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
      CALL cl_err_msg(g_imo.imo01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
      LET g_success='N'
      RETURN
   END IF
  
   #需要 QC 檢驗的筆數
   SELECT COUNT(*) INTO l_qc_cnt FROM imp_file 
    WHERE imp01 = g_imo.imo01 AND imp15 = 'Y' 
   IF l_qc_cnt = 0 THEN 
      CALL cl_err(g_imo.imo01,l_err,0) 
      LET g_success='N'
      RETURN
   END IF
 
   #需檢驗的資料，自動新增資料至 QC 單 ,功能參數為「SPC」
   LET l_sql  = "SELECT imp02 FROM imp_file                   WHERE imp01 = '",g_imo.imo01,"' AND imp15='Y'"
   PREPARE t306_imp_p FROM l_sql
   DECLARE t306_imp_c CURSOR WITH HOLD FOR t306_imp_p
   FOREACH t306_imp_c INTO l_imp02
       display l_cmd
       LET l_cmd = l_qc_prog CLIPPED," '",g_imo.imo01,"' '",l_imp02,"' '1' 'SPC' 'E'"
       CALL aws_spccli_qc(l_qc_prog,l_cmd)
   END FOREACH 
 
   #判斷產生的 QC 單筆數是否正確
   SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_imo.imo01
   IF l_cnt <> l_qc_cnt THEN
      CALL t306_qcs_del()
      LET g_success='N'
      RETURN
   END IF
 
   LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_imo.imo01,"'"
   PREPARE t306_qc_p FROM l_sql
   DECLARE t306_qc_c CURSOR WITH HOLD FOR t306_qc_p
   LET l_cnt = 1
   FOREACH t306_qc_c INTO l_qcs[l_cnt].*
       LET l_cnt = l_cnt + 1 
   END FOREACH
   CALL l_qcs.deleteElement(l_cnt)
 
   # CALL aws_spccli() 
   #功能: 傳送此單號所有的 QC 單至 SPC 端
   # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
   # 回傳值  : 0 傳送失敗; 1 傳送成功
   IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert") THEN
      LET g_imo.imospc = '1'
   ELSE
      LET g_imo.imospc = '2'
      CALL t306_qcs_del()
   END IF
 
   UPDATE imo_file set imospc = g_imo.imospc WHERE imo01 = g_imo.imo01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","imo_file",g_imo.imo01,"",STATUS,"","upd imospc",1)
      IF g_imo.imospc = '1' THEN
          CALL t306_qcs_del()
      END IF
      LET g_success = 'N'
   END IF
   DISPLAY BY NAME g_imo.imospc
  
END FUNCTION 
 
FUNCTION t306_qcs_del()
 
      DELETE FROM qcs_file WHERE qcs01 = g_imo.imo01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_imo.imo01,"",SQLCA.sqlcode,"","DEL qcs_file err!",0)
      END IF
 
      DELETE FROM qct_file WHERE qct01 = g_imo.imo01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_imo.imo01,"",SQLCA.sqlcode,"","DEL qct_file err!",0)
      END IF
 
      DELETE FROM qctt_file WHERE qctt01 = g_imo.imo01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_imo.imo01,"",SQLCA.sqlcode,"","DEL qcstt_file err!",0)
      END IF
 
      DELETE FROM qcu_file WHERE qcu01 = g_imo.imo01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcu_file",g_imo.imo01,"",SQLCA.sqlcode,"","DEL qcu_file err!",0)
      END IF
 
      DELETE FROM qcv_file WHERE qcu01 = g_imo.imo01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcv_file",g_imo.imo01,"",SQLCA.sqlcode,"","DEL qcv_file err!",0)
      END IF
 
END FUNCTION 
#No.FUN-9C0072 精簡程式碼

#FUN-A80106 add --start--
#檢查是否有ida/idb存在--(S)
FUNCTION t306_ind_icd_chk_icd()
     LET g_cnt = 0
     LET g_errno = ' '
     #入庫
     SELECT COUNT(*) INTO g_cnt FROM ida_file
      WHERE ida07 = g_imo.imo01
        AND ida08 = g_imp_t.imp02
     IF g_cnt > 0 THEN
	LET g_errno = 'aic-113'
     ELSE
	LET g_errno = SQLCA.SQLCODE USING '-------'
     END IF
END FUNCTION
#檢查是否有ida/idb存在--(E)
 
 
#   料號為參考單位,單一單位,且狀態為其它段生產料號(imaicd04=3,4)時,
#   將單位一的資料給單位二
FUNCTION t306_ind_icd_set_value()
    DEFINE l_ima906    LIKE ima_file.ima906,
	   l_imaicd04  LIKE imaicd_file.imaicd04
    IF g_sma.sma115 = 'Y' THEN
       LET l_ima906 = NULL
       LET l_imaicd04 = NULL
       SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04 FROM ima_file,imaicd_file
	WHERE imaicd00 = ima01
	  AND imaicd00 = g_imp[l_ac].imp03
       IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[3]' THEN
	  IF l_imaicd04 MATCHES '[34]' THEN
	     LET g_imp[l_ac].imp23 = g_imp[l_ac].imp20 #單位
	     LET g_imp[l_ac].imp25 = g_imp[l_ac].imp22 #數量
	     LET g_imp[l_ac].imp24 = g_imp[l_ac].imp22/g_imp[l_ac].imp25
 
	     LET b_imp.imp23= g_imp[l_ac].imp23
	     LET b_imp.imp24= g_imp[l_ac].imp24
	     LET b_imp.imp25= g_imp[l_ac].imp25
	     DISPLAY BY NAME g_imp[l_ac].imp23,
			     g_imp[l_ac].imp24,
			     g_imp[l_ac].imp23
 
	  END IF
       END IF
    END IF
END FUNCTION
 
 #更新die數
 #當料號為wafer段時imaicd04=1,用dice數量加總給原將單據的第二單位數量。
 #當料號為wafer段時imaicd04=2,用pass bin = 'Y'數量加總給原將單據的第二單位數量。
FUNCTION t306_ind_icd_upd_dies()
    DEFINE l_ima906    LIKE ima_file.ima906,
	   l_imaicd04  LIKE imaicd_file.imaicd04                 #FUN-BA0051 
       #l_imaicd08  LIKE imaicd_file.imaicd08  #FUN-B30187   #FUN-BA0051 mark
    DEFINE l_ida15 LIKE ida_file.ida15,        #FUN-B30187
           l_ida16 LIKE ida_file.ida16         #FUN-B30187

    BEGIN WORK            #FUN-B30187
    LET g_success = 'Y'   #FUN-B30187
    
    IF g_sma.sma115 = 'Y' THEN
       LET l_ima906 = NULL
       LET l_imaicd04 = NULL
       SELECT ima906,imaicd04 INTO l_ima906,l_imaicd04 #FUN-B30187 加imaicd08 #FUN-BA0051 mark imaicd08 
        FROM ima_file,imaicd_file 
	    WHERE ima01 = imaicd00 AND ima01 = g_imp[l_ac].imp03
       #若料號為單一單位, 如IC料號, 出入庫不回寫單位二級單位二數量
       IF NOT cl_null(l_ima906) AND l_ima906 MATCHES '[3]' THEN
	      IF l_imaicd04 MATCHES '[12]' THEN
	         LET g_imp[l_ac].imp25 = g_dies             #數量
	         LET g_imp[l_ac].imp24 = g_imp[l_ac].imp22/g_imp[l_ac].imp25
	         #BEGIN WORK   #FUN-B30187 mark
	         UPDATE imp_file set imp24 = g_imp[l_ac].imp24,imp25 = g_imp[l_ac].imp25
              WHERE imp01=g_imo.imo01 AND imp02=g_imp[l_ac].imp02
	         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
		        LET g_imp[l_ac].imp24 = b_imp.imp24
		        LET g_imp[l_ac].imp25 = b_imp.imp25
                LET g_success = 'N'   #FUN-B30187
		        #ROLLBACK WORK        #FUN-B30187mark
	         ELSE
		        LET b_imp.imp24 = g_imp[l_ac].imp24
		        LET b_imp.imp25 = g_imp[l_ac].imp25                
		        #COMMIT WORK   #FUN-B30187 mark
	         END IF
	         DISPLAY BY NAME g_imp[l_ac].imp24, g_imp[l_ac].imp25
	      END IF
       END IF
    END IF

    #FUN-BA0051 --START mark--
    ##FUN-B70061 --START--
    #IF cl_null(l_imaicd08) THEN
    #    SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file 
    #     WHERE imaicd00 = g_imp[l_ac].imp03
    #END IF
    ##FUN-B70061 --END-- 
    # 
    ##FUN-B30187 --START--    
    #IF l_imaicd08 = 'Y' THEN
    #FUN-BA0051 --END mark--
    IF s_icdbin(g_imp[l_ac].imp03) THEN   #FUN-BA0051
       LET g_sql = "SELECT ida15 FROM ida_file",   #FUN-BC0109 del ,ida16 
                            " WHERE ida07 = '", g_imo.imo01, "'",
                            " AND ida08 =", g_imp[l_ac].imp02
       DECLARE t306_upd_dia_c CURSOR FROM g_sql            
       OPEN t306_upd_dia_c                                       
       FETCH t306_upd_dia_c INTO g_imp[l_ac].impiicd029   #FUN-BC0109 del ,g_imp[l_ac].impiicd028       
       
       #串接Date Code值
       CALL s_icdfun_datecode('2',g_imo.imo01,g_imp[l_ac].imp02) 
                                RETURNING g_imp[l_ac].impiicd028   #FUN-BC0109
                                
       UPDATE impi_file set impiicd029 = g_imp[l_ac].impiicd029,
        impiicd028 = g_imp[l_ac].impiicd028
        WHERE impi01=g_imo.imo01 AND impi02=g_imp[l_ac].imp02
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          LET g_imp[l_ac].impiicd029 = g_imp_t.impiicd029
          LET g_imp[l_ac].impiicd028 = g_imp_t.impiicd028
          LET g_success  = 'N'
       ELSE
          LET g_imp_t.impiicd029 = g_imp[l_ac].impiicd029
          LET g_imp_t.impiicd028 = g_imp[l_ac].impiicd028          
       END IF 
       DISPLAY BY NAME g_imp[l_ac].impiicd029, g_imp[l_ac].impiicd028       
    END IF
    
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    #FUN-B30187 --END--  
END FUNCTION

#FUN-B30187 --START--
FUNCTION t306_set_required_impiicd028(p_cmd)
DEFINE l_imaicd09 LIKE imaicd_file.imaicd09
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(imp03) THEN
      IF NOT cl_null(g_imp[l_ac].imp03) THEN
         SELECT imaicd09 INTO l_imaicd09 FROM imaicd_file
          WHERE imaicd00 = g_imp[l_ac].imp03
         IF l_imaicd09 = 'Y' THEN            
            CALL cl_set_comp_required("impiicd028",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t306_set_no_required_impiicd028()
     CALL cl_set_comp_required("impiicd028",FALSE)
END FUNCTION

FUNCTION t306_set_required_impiicd029(p_cmd)
DEFINE l_imaicd13 LIKE imaicd_file.imaicd13
DEFINE p_cmd      LIKE type_file.chr1

   IF p_cmd='u' OR INFIELD(imp03) THEN
      IF NOT cl_null(g_imp[l_ac].imp03) THEN
         SELECT imaicd13 INTO l_imaicd13 FROM imaicd_file
          WHERE imaicd00 = g_imp[l_ac].imp03
         IF l_imaicd13 = 'Y' THEN            
            CALL cl_set_comp_required("impiicd029",TRUE)
         END IF
      END IF
   END IF
END FUNCTION

FUNCTION t306_set_no_required_impiicd029()
     CALL cl_set_comp_required("impiicd029",FALSE)
END FUNCTION

FUNCTION t306_def_impiicd029()
DEFINE l_idc10    LIKE idc_file.idc10,
       l_idc11    LIKE idc_file.idc11
DEFINE l_flag     LIKE type_file.num10

   CALL s_icdfun_def_slot(g_imp[l_ac].imp03,g_imp[l_ac].imp11,g_imp[l_ac].imp12,
                          g_imp[l_ac].imp13) RETURNING l_flag,l_idc10,l_idc11   
   IF l_flag = 1 THEN 
      LET g_imp[l_ac].impiicd029 = l_idc10
      LET g_imp[l_ac].impiicd028 = l_idc11      
      DISPLAY BY NAME g_imp[l_ac].impiicd029,g_imp[l_ac].impiicd028
   END IF 
END FUNCTION 
#FUN-B30187 --END--
#FUN-A80106 add --end--

                    #No.FUN-AA0049--end    
#FUN-BB0083---add---str
FUNCTION t306_imp04_check()
#imp04 的單位 imp05
   IF NOT cl_null(g_imp[l_ac].imp05) AND NOT cl_null(g_imp[l_ac].imp04) THEN
      IF cl_null(g_imp_t.imp04) OR cl_null(g_imp05_t) OR g_imp_t.imp04 != g_imp[l_ac].imp04 OR g_imp05_t != g_imp[l_ac].imp05 THEN 
         LET g_imp[l_ac].imp04=s_digqty(g_imp[l_ac].imp04,g_imp[l_ac].imp05)
         DISPLAY BY NAME g_imp[l_ac].imp04  
      END IF  
   END IF
   IF NOT cl_null(g_imp[l_ac].imp04) THEN
      IF g_imp[l_ac].imp04 <=0 THEN
      CALL cl_err(g_imp[l_ac].imp04,'mfg6109',0)
      RETURN FALSE
      END IF
   END IF
RETURN TRUE

END FUNCTION

FUNCTION t306_imp22_check()
#imp22 的單位 imp20
   IF NOT cl_null(g_imp[l_ac].imp20) AND NOT cl_null(g_imp[l_ac].imp22) THEN
      IF cl_null(g_imp_t.imp22) OR cl_null(g_imp20_t) OR g_imp_t.imp22 != g_imp[l_ac].imp22 OR g_imp20_t != g_imp[l_ac].imp20 THEN 
         LET g_imp[l_ac].imp22=s_digqty(g_imp[l_ac].imp22,g_imp[l_ac].imp20)
         DISPLAY BY NAME g_imp[l_ac].imp22  
      END IF  
   END IF
   IF NOT cl_null(g_imp[l_ac].imp22) THEN
      IF g_imp[l_ac].imp22 < 0 THEN
      CALL cl_err('','aim-391',0)  #
      RETURN "imp22"
      END IF
   END IF
   CALL t306_du_data_to_correct()
   CALL t306_set_origin_field()
   IF g_imp[l_ac].imp04 <=0 THEN
      CALL cl_err(g_imp[l_ac].imp04,'mfg6109',0)
      IF g_ima906 MATCHES '[23]' THEN
         RETURN "imp25"
      ELSE
         RETURN "imp22"
      END IF
   END IF
   CALL t306_unit(g_imp[l_ac].imp05)
   IF NOT cl_null(g_errno) THEN
      CALL cl_err('',g_errno,0)
      RETURN "imp11"
   END IF
   #檢查該借料單位與主檔之單位是否可以轉換
   CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp05,m_imo.ima25)
        RETURNING g_cnt,m_imo.ima25_fac
   IF g_cnt = 1 THEN
      CALL cl_err('imp05/ima25','mfg3075',0)
      RETURN "imp11"
   END IF
   CALL s_umfchk(g_imp[l_ac].imp03,g_imp[l_ac].imp05,
        g_imp[l_ac].imp14)
        RETURNING g_cnt,g_imp[l_ac].imp14_fac
   IF g_cnt = 1 THEN
      CALL cl_err('imp05/imp14','mfg3075',0)
      RETURN "imp11"
   END IF
RETURN ''
END FUNCTION

FUNCTION t306_imp25_check()
#imp25 的單位 imp23
DEFINE p_cmd LIKE type_file.chr1
   IF NOT cl_null(g_imp[l_ac].imp23) AND NOT cl_null(g_imp[l_ac].imp25) THEN
      IF cl_null(g_imp_t.imp25) OR cl_null(g_imp23_t) OR g_imp_t.imp25 != g_imp[l_ac].imp25 OR g_imp23_t != g_imp[l_ac].imp23 THEN 
         LET g_imp[l_ac].imp25=s_digqty(g_imp[l_ac].imp25,g_imp[l_ac].imp23)
         DISPLAY BY NAME g_imp[l_ac].imp23  
      END IF  
   END IF
   IF NOT cl_null(g_imp[l_ac].imp25) THEN
      IF g_imp[l_ac].imp25 < 0 THEN
      CALL cl_err('','aim-391',0)  
      RETURN FALSE
      END IF
      IF p_cmd = 'a' THEN
         IF g_ima906='3' THEN
            LET g_tot=g_imp[l_ac].imp25*g_imp[l_ac].imp24
            IF cl_null(g_imp[l_ac].imp22) OR g_imp[l_ac].imp22=0 THEN 
               LET g_imp[l_ac].imp22=g_tot*g_imp[l_ac].imp21
               DISPLAY BY NAME g_imp[l_ac].imp22                      
            END IF                                                    
         END IF
      END IF
   END IF
   CALL cl_show_fld_cont()  
RETURN TRUE
END FUNCTION

   
#FUN-BB0083---add---end                    

#FUN-C50071 add begin-------------------------
FUNCTION t306_rvbs()
  DEFINE b_rvbs  RECORD  LIKE rvbs_file.*
  DEFINE l_ima25         LIKE ima_file.ima25

      LET b_rvbs.rvbs00  = g_prog
      LET b_rvbs.rvbs01  = g_imo.imo01
      LET b_rvbs.rvbs02  = g_imp[l_ac].imp02
      LET b_rvbs.rvbs021 = g_imp[l_ac].imp03
      LET b_rvbs.rvbs06  = g_imp[l_ac].imp04 * g_imp[l_ac].imp14_fac  #數量*庫存單位換算率
      LET b_rvbs.rvbs09  = 1  #1入庫
      CALL s_ins_rvbs("2",b_rvbs.*)

END FUNCTION
#FUN-C50071 add -end--------------------------

#FUN-CB0087---add---str---

FUNCTION t306_imp16_check()   #理由碼
DEFINE
    l_n       LIKE type_file.num5,    #FUN-CB0087
    l_sql     STRING,                 #FUN-CB0087
    l_where   STRING,                 #FUN-CB0087          
    l_flag    LIKE type_file.chr1     #FUN-CB0087 


    LET l_flag = FALSE
    CALL s_get_where(g_imo.imo01,'','',g_imp[l_ac].imp03,g_imp[l_ac].imp11,
                                g_imo.imo06,g_imo.imo08) RETURNING l_flag,l_where
    IF NOT cl_null(g_imp[l_ac].imp16) THEN 
       LET l_n = 0
       IF g_aza.aza115='Y' AND l_flag THEN
          LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imp[l_ac].imp16,"' AND ",l_where
          PREPARE ggc08_pre2 FROM l_sql
          EXECUTE ggc08_pre2 INTO l_n
          IF l_n < 1 THEN 
             CALL cl_err(g_imp[l_ac].imp16,'aim-425',1)
             RETURN FALSE 
          END IF
       ELSE
          SELECT COUNT(*) INTO l_n FROM azf_file WHERE azf01 = g_imp[l_ac].imp16 AND azf02='2'
          IF l_n < 1 THEN
             CALL cl_err(g_imp[l_ac].imp16,'aim-425',1)
             RETURN FALSE
          END IF
       END IF
    ELSE
       CALL t306_azf03_desc()    #TQC-D20042
    END IF
RETURN TRUE
END FUNCTION 

FUNCTION t306_imp16_chk2()
DEFINE l_flag       LIKE type_file.chr1,
       l_sql        STRING,
       l_where      STRING,
       l_n          LIKE type_file.num5,
       l_i          LIKE type_file.num5
   IF g_aza.aza115 = 'Y' THEN
      FOR l_i=1 TO g_imp.getlength()
         CALL s_get_where(g_imo.imo01,'','',g_imp[l_i].imp03,g_imp[l_i].imp11,
                                g_imo.imo06,g_imo.imo08) RETURNING l_flag,l_where
         IF l_flag THEN
            LET l_n=0
            LET l_sql = " SELECT COUNT(*) FROM ggc_file WHERE ggc08='",g_imp[l_i].imp16,"' AND ",l_where
            PREPARE ggc08_pre3 FROM l_sql
            EXECUTE ggc08_pre3 INTO l_n
            IF l_n < 1 THEN
               CALL cl_err('','aim-425',1)
               RETURN FALSE
            END IF
         END IF
      END FOR
   END IF
   RETURN TRUE
END FUNCTION
#FUN-CB0087---add---end---

#FUN-D10081---add---str---
FUNCTION t306_list_fill()
  DEFINE l_imo01         LIKE imo_file.imo01
  DEFINE l_i             LIKE type_file.num10

    CALL g_imo_l.clear()
    LET l_i = 1
    FOREACH t306_fill_cs INTO l_imo01
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
          CONTINUE FOREACH
       END IF
       SELECT imo01,'',imo02,imo03,imo04,imo05,imo06,
              gen02,imo08,gem02,imoconf,imopost,imo07
         INTO g_imo_l[l_i].*
         FROM imo_file
              LEFT OUTER JOIN gem_file ON gem01 = imo08
              LEFT OUTER JOIN gen_file ON gen01 = imo06
        WHERE imo01=l_imo01
       LET g_t1=s_get_doc_no(g_imo_l[l_i].imo01)
       SELECT smydesc INTO g_imo_l[l_i].smydesc
         FROM smy_file 
        WHERE smyslip = g_t1

       LET l_i = l_i + 1
       IF l_i > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b4 = l_i - 1
    DISPLAY ARRAY g_imo_l TO s_imo_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY
    
END FUNCTION

FUNCTION t306_bp2(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1  
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_imo_l TO s_imo_l.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
          CALL fgl_set_arr_curr(g_curs_index)
          CALL cl_navigator_setting( g_curs_index, g_row_count )
       BEFORE ROW
          LET l_ac4 = ARR_CURR()
          LET g_curs_index = l_ac4
          CALL cl_show_fld_cont()

      ON ACTION page_main
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         IF g_rec_b4 > 0 THEN
             CALL t306_fetch('/')
         END IF
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", TRUE)          
         EXIT DISPLAY

      ON ACTION ACCEPT
         LET g_action_flag = "page_main"
         LET l_ac4 = ARR_CURR()
         LET g_jump = l_ac4
         LET mi_no_ask = TRUE
         CALL t306_fetch('/')  
         CALL cl_set_comp_visible("page_list", FALSE)
         CALL cl_set_comp_visible("page_list", TRUE)
         CALL cl_set_comp_visible("page_main", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page_main", TRUE)    
         EXIT DISPLAY

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
         CALL t306_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION previous
         CALL t306_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                   
 
      ON ACTION jump
         CALL t306_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                
 
      ON ACTION next
         CALL t306_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
	 ACCEPT DISPLAY                 
 
      ON ACTION last
         CALL t306_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
         ACCEPT DISPLAY                
 
      #TQC-D10084---mark---str---
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DISPLAY
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
         CALL t306_mu_ui()   #FUN-610006
         IF g_imo.imoconf = 'X' THEN
            LET g_void = 'Y'
         ELSE
            LET g_void = 'N'
         END IF
         CALL cl_set_field_pic(g_imo.imoconf,"",g_imo.imopost,g_imo.imo07,g_void,"")
         EXIT DISPLAY 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY 
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
      #CHI-D20010---begin
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010---end
#FUN-A80106 add --start--
    #@ON ACTION 單據刻號BIN查詢作業
      ON ACTION aic_s_icdqry
         LET g_action_choice = "aic_s_icdqry"
         EXIT DISPLAY 
 
    #@ON ACTION 單據刻號BIN明細維護作業
      ON ACTION aic_s_icdin
         LET g_action_choice = "aic_s_icdin"
         EXIT DISPLAY 
#FUN-A80106 add --end--         
    #@ON ACTION 過帳
      ON ACTION post
         LET g_action_choice="post"
         EXIT DISPLAY 
    #@ON ACTION 過帳還原
      ON ACTION undo_post
         LET g_action_choice="undo_post"
         EXIT DISPLAY 
    #@ON ACTION 單價
      ON ACTION unit_price
         LET g_action_choice="unit_price"
         EXIT DISPLAY 

      ON ACTION cancel
             LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DISPLAY 
 
      ON ACTION exporttoexcel 
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
      ON ACTION about         
         CALL cl_about()      
 
    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                     
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DISPLAY
     
      ON ACTION qry_lot
         LET g_action_choice="qry_lot"
         EXIT DISPLAY

     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      &include "qry_string.4gl"
   END DISPLAY 

   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION 
#FUN-D10081---add---end
#TQC-D20042---add---str---
FUNCTION t306_azf03_desc()
   IF NOT cl_null(g_imp[l_ac].imp16) THEN
      SELECT azf03 INTO g_imp[l_ac].azf03 FROM azf_file WHERE azf01=g_imp[l_ac].imp16 AND azf02='2'
      DISPLAY BY NAME g_imp[l_ac].azf03
   ELSE
      LET g_imp[l_ac].azf03 = ' '
      DISPLAY BY NAME g_imp[l_ac].azf03
   END IF
END FUNCTION
#TQC-D20042---add---end---


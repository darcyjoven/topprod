# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi252.4gl
# Descriptions...: 採購料件詢價維護作業
# Date & Author..: 91/09/05 By Wu
# Modify.........: 92/11/16 By Apple
# Modify.........: 98/07/01 By Carol print item sorting by pmw01,pmx02
# Modify.........: 00/04/06 By Carol:料號可輸入MISC,品名,規格須存檔
#                                    pmx_file add 2 fields:pmx081,pmx082
# Modify.........: 7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: 9506 04/04/29 By Melody p_wc2應加上NULL的判斷
# Modify.........: No.MOD-490280 04/09/16 Melody 新增第二張以上單據時，由單頭至單身新增時會SHOW 100找不到資料的問題
# Modify.........: No.MOD-490371 04/09/23 By Kitty Controlp 未加display
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4C0056 04/12/08 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.MOD-530329 05/03/28 By Mandy 詢價單輸完,無法馬上列印
# Modify.........: No.MOD-530533 05/03/30 By Mandy 1.詢價日期無法輸入
#                                                  2.廠商編號-->不須控管只有'1(供應商)或3(兩者)'的才能下單,與核價單/採購單控管邏輯衝突
#                                                               實務上有可能跟付款廠商或供應商都有可以作詢價.
# Modify.........: No.FUN-4A0089 05/04/22 By saki 試做筆數顯示
# Modify.........: No.FUN-550019 05/04/27 By Danny 採購含稅單價
# Modify.........: No.MOD-540182 05/05/06 By saki 單據編號格式放大
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.FUN-560193 05/06/27 By kim 單身 '詢價單位' 之後增秀 '採購單位','計價單位'
# Modify.........: No.FUN-580035 05/08/09 By Sarah 權限群組測試範例
# Modify.........: No.FUN-580013 05/08/15 By vivien 改新報表格式
# Modify.........: No.MOD-590276 05/09/14 By Rosayu 單身輸入料號後採購單位及計價單位不會立即顯示,但實際會有資料
# Modify.........: No.FUN-5A0139 05/10/21 By Pengu 調整報表的格式
# Modify.........: No.TQC-5A0096 05/10/26 By Niocla 單據性質取位修改
# Modify.........: No.TQC-5B0037 05/11/07 By Rosayu 報表項次移到第一行
# Modify.........: No.FUN-5B0136 05/12/02 By Sarah 修改單身後單頭的資料更改者,最近修改日應update
# Modify.........: No.FUN-610018 06/01/05 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: NO.TQC-630074 06/03/07 By Echo 流程訊息通知功能
# Modify.........: No.MOD-640052 06/04/08 By Echo 無列印「規格 」欄位
# Modify.........: No.FUN-640063 06/04/09 By Sarah 修改單頭稅別時，單頭應稅未稅、稅率欄位應跟著修改，單身含稅單價應該重新計算
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-660099 06/08/02 By Nicola 價格管理修改-新增欄位作業編號，用傳參數的方式決定採購委外
# Modify.........: No.TQC-680080 06/08/29 By Sarah p_flow流程訊息通知功能,加上OTHERWISE判斷漏改
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-6A0067 06/10/23 By atsea 將g_no_ask修改為g_no_ask
# Modify.........: No.CHI-6A0004 06/11/01 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.FUN-650191 06/11/08 By rainy pmw03改抓 pmx12
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/16 By jamie 1.FUNCTION _fetch() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6C0031 06/12/07 By Sarah 將項次挪到料號前面列印
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.FUN-710055 07/01/24 By saki 自定義欄位功能範例
# Modify.........: No.FUN-710091 07/02/14 By xufeng 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/22 By Nicole 增加CR參數
# Modify.........: No.TQC-740192 07/04/22 By Nicola pmx12應為key值
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760033 07/06/05 By Sarah 新增好單頭/單身資料後馬上按列印,會show lib-216 無報表資料產生,
#                                                  但是重查此筆資料,再按列印,則列印OK
# Modify.........: No.TQC-760046 07/06/15 By rainy 單身_b()進去後出現err -201 OPEN i252_bcl: 發生語法錯誤.
# Modify.........: No.TQC-780049 07/08/15 By Sarah 修改INSERT INTO temptable語法
# Modify.........: No.FUN-730060 07/08/21 By Xufeng 無效的資料改為可以刪除 
# Modify.........: No.MOD-7C0150 07/12/20 By claire apmi262無法列印
# Modify.........: No.FUN-810017 08/01/08 By jan 新增服飾作業
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-830114 08/03/31 By jan 若料件編號字段輸入的是多屬性的分段定價資料且不存在于ima_file中
#                                                那麼單身輸入料號后需帶出的默認資料
# Modify.........: No.CHI-880028 08/10/13 By xiaofeizhu 新增欄位價格型態pmw07 
# Modify.........: No.MOD-920024 09/02/03 By Smapmin 廠商性質需為1|3類
# Modify.........: No.FUN-980006 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930061 09/09/27 By chenmoyan 單身加上作業名稱
# Modify.........: No.TQC-9A0145 09/10/28 By Carrier SQL STANDARDIZE
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:CHI-A40042 10/04/21 By Smapmin 允許雜項廠商也可以登入詢價檔
# Modify.........: No:FUN-A40073 10/05/05 By liuxqa 追单MOD-9A0078 
# Modify.........: No.FUN-A90048 10/09/28 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No.FUN-AA0047 10/09/28 By huangtao 修改料號欄位控管以及開窗
# Modify.........: No.TQC-AB0020 10/11/03 By lilingyu 供應廠商簡稱欄位的值沒有顯示出來
# Modify.........: No:TQC-960202 10/11/05 By Sabrina 在單身AFTER FIELD pmx03 中的sql有用到 AND pmx03[1,4] <> 'MISC' ，
#                                                    這邊感覺是要檢查料號，而pmx03是下限數量(有二處)
# Modify.........: No:TQC-AC0100 10/12/10 By lixh1   修改撈報表數據的SQL,去除重複的資料
# Modify.........: No:TQC-AC0402 10/12/31 By destiny 复制时点取消询价日期栏位会变成无值的 
# Modify.........: No.TQC-B10029 11/01/06 By zhangll 修正sql
# Modify.........: No:FUN-B30211 11/03/30 By lixiang 加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50018 11/06/07 By xumm  \t特殊字元導致轉GR的時候p_gengre出錯
# Modify.........: No.FUN-B50065 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60257 11/06/21 By zhangweib 复制时,在点击确定时在after input段加上资料的检查
# Modify.........: No.FUN-B80088 11/08/09 By fengrui  程式撰寫規範修正
# Modify.........: No.FUB-B50018 11/08/01 By yangtt 改寫報表CALL apmr252
# Modify.........: No:TQC-B80232 11/08/30 By guoch 资料建立者，资料建立部门查询时无法下条件
# Modify.........: No.FUN-910088 11/11/25 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-C20068 12/02/13 By fengrui 數量欄位小數取位處理
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.TQC-C80032 12/08/03 By Elise 已經沒有程式段,故mark 
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No.MOD-C80179 12/09/20 By jt_chen 非MISC料不可維護品名/規格
# Modify.........: No.MOD-C80192 12/09/20 By jt_chen 修正當apmi252勾選 zz13 可更改KEY值時，UPDATE會出錯
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE g_pmw         RECORD LIKE pmw_file.*,       #簽核等級 (單頭)
       g_pmw_t       RECORD LIKE pmw_file.*,       #簽核等級 (舊值)
       g_pmw_o       RECORD LIKE pmw_file.*,       #簽核等級 (舊值)
       g_pmw01_t     LIKE pmw_file.pmw01,          #簽核等級 (舊值)
       g_t1          LIKE oay_file.oayslip,    
       g_sheet       LIKE oay_file.oayslip,        #單別 (沿用)
       g_ydate       LIKE type_file.dat,           #單據日期(沿用)
       g_pmx         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號  #No.FUN-670099
           ecd02     LIKE ecd_file.ecd02,          #作業名稱  #No.FUN-930061 
           pmx13     LIKE pmx_file.pmx13,          #單元編號  #No.FUN-810017
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #FUN-560193 採購單位
           ima908    LIKE ima_file.ima908,         #FUN-560193 計價單位
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價  FUN-550019
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_pmx_t       RECORD                        #程式變數 (舊值)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號  #No.FUN-670099
           ecd02     LIKE ecd_file.ecd02,          #作業名稱  #No.FUN-930061 
           pmx13     LIKE pmx_file.pmx13,          #單元編號  #No.FUN-810017
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #FUN-560193
           ima908    LIKE ima_file.ima908,         #FUN-560193
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價  FUN-550019
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_pmx_o       RECORD                        #程式變數 (舊值)
           pmx02     LIKE pmx_file.pmx02,          #項次
           pmx12     LIKE pmx_file.pmx12,          #廠商代號 
           pmc03     LIKE pmc_file.pmc03,          #廠商簡稱 
           pmx08     LIKE pmx_file.pmx08,          #料件編號
           pmx081    LIKE pmx_file.pmx081,         #品名規格
           pmx082    LIKE pmx_file.pmx082,         #規格
           pmx10     LIKE pmx_file.pmx10,          #作業編號  #No.FUN-670099
           ecd02     LIKE ecd_file.ecd02,          #作業名稱  #No.FUN-930061 
           pmx13     LIKE pmx_file.pmx13,          #單元編號  #No.FUN-810017
           pmx09     LIKE pmx_file.pmx09,          #詢價單位
           ima44     LIKE ima_file.ima44,          #FUN-560193
           ima908    LIKE ima_file.ima908,         #FUN-560193
           pmx04     LIKE pmx_file.pmx04,          #生效日期
           pmx05     LIKE pmx_file.pmx05,          #失效日期
           pmx03     LIKE pmx_file.pmx03,          #上限數量
           pmx06     LIKE pmx_file.pmx06,          #採購價格
           pmx06t    LIKE pmx_file.pmx06t,         #含稅單價  FUN-550019
           pmx07     LIKE pmx_file.pmx07           #折扣比率
                     END RECORD,
       g_sql         STRING,                       #CURSOR暫存 TQC-5B0183
       g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  #No.FUN-680136 
       l_ac          LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680136 
DEFINE g_gec07             LIKE gec_file.gec07    
DEFINE g_forupd_sql        STRING                  #SELECT ... FOR UPDATE  SQL
DEFINE g_before_input_done LIKE type_file.num5   
DEFINE g_chr               LIKE type_file.chr1    
DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_i                 LIKE type_file.num5     #count/index for any purpose  
DEFINE g_msg               LIKE ze_file.ze03      
DEFINE g_curs_index        LIKE type_file.num10  
DEFINE g_row_count         LIKE type_file.num10    #總筆數 
DEFINE g_jump              LIKE type_file.num10    #查詢指定的筆數
DEFINE g_no_ask            LIKE type_file.num5     #是否開啟指定筆視窗  
DEFINE g_argv1             LIKE pmw_file.pmw01     #單號 
DEFINE g_argv2             STRING                  #指定執行的功能 #TQC-630074
DEFINE g_argv3             LIKE pmx_file.pmx11  
DEFINE g_pmx11             LIKE pmx_file.pmx11  
DEFINE l_table             STRING
DEFINE g_str               STRING
DEFINE g_pmw07             LIKE pmw_file.pmw07   
DEFINE g_buf               STRING
DEFINE g_pmx09_t           LIKE pmx_file.pmx09     #FUN-910088--add--
 
MAIN

#  IF FGL_GETENV("FGLGUI") <> "0" THEN      #若為整合EF自動簽核功能: 需抑制此段落 此處不適用
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
#  END IF
 
   LET g_argv1=ARG_VAL(1)           #TQC-630074
   LET g_argv2=ARG_VAL(2)           #TQC-630074
   LET g_argv3=ARG_VAL(3)

   IF g_argv3 = "1" THEN                  #在cl_user前須預先處理全域變數值
      LET g_prog="apmi252"                #此處是 apmi252與 apmi262為共用程式的處理方式
      LET g_pmx11 = "1"
   ELSE
      LET g_prog="apmi262"
      LET g_pmx11 = "2"
   END IF 
   LET g_pmw07 = g_pmx11                  #No.CHI-880028
 
   IF (NOT cl_user()) THEN                #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                        #切換成使用者預設的營運中心
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log     #遇錯則記錄log檔
 
   IF (NOT cl_setup("APM")) THEN          #抓取權限共用變數及模組變數(g_aza.*...)
      EXIT PROGRAM                        #判斷使用者執行程式權限
   END IF
 
   LET g_sql="pmw01.pmw_file.pmw01,",#若需使用CR報表的TEMP Table需在setup後宣告開啟的字串
             "pmx12.pmx_file.pmx12,",#格式為 "colname_in_temp.table.col_name"
             "pmc03.pmc_file.pmc03,",#每個宣告間以逗號隔開
             "pmw04.pmw_file.pmw04,",
             "pmw06.pmw_file.pmw06,",
             "pmwacti.pmw_file.pmwacti,",
             "pmx02.pmx_file.pmx02,",
             "pmx08.pmx_file.pmx08,",
             "pmx081.pmx_file.pmx081,",
             "pmx082.pmx_file.pmx082,",
             "pmx10.pmx_file.pmx10,",
             "ecd02.ecd_file.ecd02,",#FUN-A40037 add
             "pmx09.pmx_file.pmx09,",
             "pmx06.pmx_file.pmx06,",
             "pmx03.pmx_file.pmx03,",
             "pmx07.pmx_file.pmx07,",
             "pmx04.pmx_file.pmx04,",
             "pmx05.pmx_file.pmx05,",
             "pmw05.pmw_file.pmw05,",
             "pmw051.pmw_file.pmw051,",
             "pmx06t.pmx_file.pmx06t,",
             "gec07.gec_file.gec07,",
             "azi03.azi_file.azi03"
   LET l_table = cl_prt_temptable('apmi252',g_sql) CLIPPED  #建立temp table,回傳狀態值
   IF  l_table = -1 THEN EXIT PROGRAM END IF                #依照狀態值決定程式是否繼續
                                                            #單頭Lock Cursor
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #計算使用時間 (進入時間)
 
   LET g_forupd_sql = "SELECT * FROM pmw_file WHERE pmw01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)           #轉換不同資料庫語法
   DECLARE i252_cl CURSOR FROM g_forupd_sql                 #單頭Lock Cursor
 
#  IF g_bgjob='N' OR cl_null(g_bgjob) THEN            #若為整合EF自動簽核功能: 需抑制此段落 此處不適用 
      OPEN WINDOW i252_w WITH FORM "apm/42f/apmi252"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      CALL cl_set_locale_frm_name("apmi252")          #共用程式在 cl_ui_init前須做指定畫面名稱處理
      CALL cl_ui_init()                               #轉換介面語言別、匯入ToolBar、Action...等資訊
#  END IF
   
   LET g_pdate = g_today                                    #No.FUN-710091 
 
   IF g_aza.aza71 MATCHES '[Yy]' THEN                       #依照系統參數設定隱藏功能鍵
      CALL aws_gpmcli_toolbar()                             #aza71為 是否與GPM整合 功能
      CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
   ELSE
      CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
   END IF
 
   IF (g_sma.sma116 MATCHES '[02]') THEN                    #依照系統參數設定隱藏欄位
      CALL cl_set_comp_visible("ima908",FALSE)
   END IF
 
   IF g_pmx11 = "1" THEN                                    #不同的價格型態隱藏部分欄位
      CALL cl_set_comp_visible("pmx10,ecd02",FALSE)         #No.FUN-930061
   END IF
   
   IF g_pmx11 = "1" THEN
      CALL cl_set_comp_visible("pmx13",FALSE)
   END IF
 
   LET g_ydate = NULL
 
   IF NOT cl_null(g_argv1) THEN                             #單據程式可透過外部參數
      CASE g_argv2                                          #決定是否直接進入查詢或新增功能
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL i252_q()
            END IF

         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL i252_a()
            END IF

#        WHEN "efconfirm"                             #若有自動簽核功能，應於此設定 本作業不適用

         OTHERWISE
            CALL i252_q()
      END CASE
   END IF
 
   CALL i252_menu()                                   #進入主視窗選單
   CLOSE WINDOW i252_w                                #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
END MAIN
 
#QBE 查詢資料
FUNCTION i252_cs()
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM 
   CALL g_pmx.clear()
  
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " pmw01 = '",g_argv1,"'"  #FUN-580120
   ELSE
      CALL cl_set_head_visible("","YES")           #設定單頭為顯示狀態
      INITIALIZE g_pmw.* TO NULL    
      CONSTRUCT BY NAME g_wc ON pmw01,pmw06,pmw04,pmw05,pmw051, 
                                pmwuser,pmwgrup,pmwmodu,pmwdate,pmwacti,
                                pmworiu,pmworig    #TQC-B80232  add
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION controlp
            CASE
               WHEN INFIELD(pmw01) #詢價單號   
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_pmw01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw01
                  NEXT FIELD pmw01
      
               WHEN INFIELD(pmw04) #幣別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_azi"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw04
                  NEXT FIELD pmw04
      
               WHEN INFIELD(pmw05)   #稅別
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gec"
                  LET g_qryparam.state = "c"
                  LET g_qryparam.where = " gec011='1' "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmw05
                  NEXT FIELD pmw05
               OTHERWISE EXIT CASE
            END CASE
      
         ON IDLE g_idle_seconds                         #每個交談指令必備以下四個功能
            CALL cl_on_idle()                           #idle、about、help、controlg
            CONTINUE CONSTRUCT
      
         ON ACTION about       
            CALL cl_about()   
      
         ON ACTION help         
            CALL cl_show_help() 
      
         ON ACTION controlg    
            CALL cl_cmdask()
      
         ON ACTION qbe_select                           #查詢提供條件選擇，選擇後直接帶入畫面
            CALL cl_qbe_list() RETURNING lc_qbe_sn      #提供列表選擇
            CALL cl_qbe_display_condition(lc_qbe_sn)    #顯示條件
 
      END CONSTRUCT
      
      IF INT_FLAG THEN
         RETURN
      END IF
   END IF
   LET g_wc = g_wc CLIPPED," AND pmw07 ='",g_pmw07,"'"             #CHI-880028 Add
 
#  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmwuser', 'pmwgrup')  #FUN-B50018
 
   IF NOT cl_null(g_argv1) THEN
      LET g_wc2 = ' 1=1'     
   ELSE
      CONSTRUCT g_wc2 ON pmx02,pmx12,pmx08,pmx09,ima44,ima908,pmx04,   #螢幕上取單身條件 #FUN-560193 add ima44,ima908  #FUN-650191
                         pmx05,pmx03,pmx06,pmx06t,pmx07,pmx082,pmx13   #No.FUN-550019 #No.FUN-810017 add pmx13
              FROM s_pmx[1].pmx02,s_pmx[1].pmx12,s_pmx[1].pmx08,s_pmx[1].pmx09,  #FUN-650191
                   s_pmx[1].ima44,s_pmx[1].ima908,
                   s_pmx[1].pmx04,s_pmx[1].pmx05,s_pmx[1].pmx03,
                   s_pmx[1].pmx06,s_pmx[1].pmx06t,s_pmx[1].pmx07,  #No.FUN-550019
                   s_pmx[1].pmx082,s_pmx[1].pmx13                  #No.FUN-550019 #No.FUN-810017
 
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)    #再次顯示查詢條件，因為進入單身後會將原顯示值清空
   
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmx10)     #作業編號
                  CALL q_ecd(TRUE,TRUE,'') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmx10
                  NEXT FIELD pmx10

            WHEN INFIELD(pmx08)
              CALL q_sel_ima(TRUE, "q_pmx08","","","", "", "", "" ,"" ,'')
                                  RETURNING g_qryparam.multiret  
               DISPLAY g_qryparam.multiret TO pmx08 
               NEXT FIELD pmx08
 
            WHEN INFIELD(pmx12) #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_pmc1"   #MOD-920024 q_pmc2-->q_pmc1
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmx12
              NEXT FIELD pmx12
            WHEN INFIELD(pmx13) 
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_sga"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmx13
              NEXT FIELD pmx13
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
    
         ON ACTION qbe_save                       #條件儲存
            CALL cl_qbe_save()
 
      END CONSTRUCT
   
      IF INT_FLAG THEN
         RETURN
      END IF
    END IF
 
 
   IF g_wc2 = " 1=1" THEN                  # 若單身未輸入條件
      LET g_sql = "SELECT  pmw01 FROM pmw_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY pmw01"
   ELSE                              # 若單身有輸入條件
      LET g_sql = "SELECT UNIQUE pmw_file. pmw01 ",
                  "  FROM pmw_file, pmx_file ",
                  " WHERE pmw01 = pmx01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY pmw01"
   END IF
 
   PREPARE i252_prepare FROM g_sql
   DECLARE i252_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i252_prepare
 
   IF g_wc2 = " 1=1" THEN                  # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM pmw_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT pmw01) FROM pmw_file,pmx_file WHERE ",
                "pmx01=pmw01 AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
   END IF
 
   PREPARE i252_precount FROM g_sql
   DECLARE i252_count CURSOR FOR i252_precount
 
END FUNCTION
 
FUNCTION i252_menu()
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   WHILE TRUE
      CALL i252_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i252_a()
            END IF
 
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i252_q()
            END IF
 
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL i252_r()
            END IF
 
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL i252_u()
            END IF
 
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
               CALL i252_x()
            END IF
 
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL i252_copy()
            END IF
 
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i252_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i252_out()
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmx),'','')
            END IF

         WHEN "related_document"                    #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pmw.pmw01 IS NOT NULL THEN
                 LET g_doc.column1 = "pmw01"
                 LET g_doc.value1 = g_pmw.pmw01
               #   CALL cl_doc()
                 CALL cl_doc_smb()
               END IF
         END IF
 
         WHEN "gpm_show"                            #GPM規範顯示   
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN 
                 LET l_partnum = g_pmx[l_ac].pmx08 
                 LET l_supplierid = g_pmx[l_ac].pmx12
              END IF
              CALL aws_gpmcli(l_partnum,l_supplierid) RETURNING l_status
 
         WHEN "gpm_query"                           #GPM規範查詢
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN 
                 LET l_partnum = g_pmx[l_ac].pmx08 
                 LET l_supplierid = g_pmx[l_ac].pmx12
              END IF
              CALL aws_gpmcli(l_partnum,l_supplierid) RETURNING l_status
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION i252_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pmx TO s_pmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i252_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION previous
         CALL i252_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION jump
         CALL i252_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION next
         CALL i252_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION last
         CALL i252_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY   #FUN-530067(smin)
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
 
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
         CALL cl_show_fld_cont()                    #畫面上欄位的工具提示轉換語言別
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE                         #利用單身驅動menu時，cancel代表右上角的"X"
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()    
 
      ON ACTION exporttoexcel                       #匯出Excel      
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      ON ACTION controls                            #單頭摺疊，可利用hot key "Ctrl-s"開啟/關閉單頭區塊
         CALL cl_set_head_visible("","AUTO")      
 
      ON ACTION related_document                    #相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
                                                    #有使用pre-processor的那一行不可以加註解
                                                    #引入動態虛擬按鍵的on action (config/include目錄)
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i252_bp_refresh()
  DISPLAY ARRAY g_pmx TO s_pmx.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
     BEFORE DISPLAY
        EXIT DISPLAY
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
  END DISPLAY
 
END FUNCTION
 
FUNCTION i252_a()
   DEFINE li_result   LIKE type_file.num5  
   DEFINE ls_doc      STRING
   DEFINE li_inx      LIKE type_file.num10  
 
   MESSAGE ""
   CLEAR FORM
   CALL g_pmx.clear()
   LET g_wc = NULL #MOD-530329
   LET g_wc2= NULL #MOD-530329
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_pmw.* LIKE pmw_file.*             #DEFAULT 設定
   LET g_pmw01_t = NULL
 
   IF g_ydate IS NULL THEN
      LET g_pmw.pmw01 = NULL
      LET g_pmw.pmw06 = g_today
   ELSE                                          #使用上筆資料值
      LET g_pmw.pmw01 = g_sheet                  #採購詢價單別
      LET g_pmw.pmw06 = g_ydate                  #收貨日期
   END IF
 
   #預設值及將數值類變數清成零
   LET g_pmw_t.* = g_pmw.*
   LET g_pmw_o.* = g_pmw.*
   CALL cl_opmsg('a')
 
   WHILE TRUE
      LET g_pmw.pmwuser=g_user
      LET g_pmw.pmworiu = g_user #FUN-980030
      LET g_pmw.pmworig = g_grup #FUN-980030
      LET g_data_plant = g_plant #FUN-980030
      LET g_pmw.pmwgrup=g_grup
      LET g_pmw.pmwdate=g_today
      LET g_pmw.pmwacti='Y'              #資料有效
      LET g_pmw.pmw07=g_pmw07            #CHI-880028 Add 
      LET g_pmw.pmwplant=g_plant  #FUN-980006
      LET g_pmw.pmwlegal=g_legal  #FUN-980006
 
      CALL i252_i("a")                   #輸入單頭
 
      IF INT_FLAG THEN                   #使用者不玩了
         INITIALIZE g_pmw.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_pmw.pmw01) THEN       # KEY 不可空白
         CONTINUE WHILE
      END IF
 
      #輸入後, 若該單據需自動編號, 並且其單號為空白, 則自動賦予單號
      BEGIN WORK
      CALL s_auto_assign_no("apm",g_pmw.pmw01,g_pmw.pmw06,"","pmw_file","pmw01","","","") RETURNING li_result,g_pmw.pmw01
      IF (NOT li_result) THEN
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_pmw.pmw01
 
      INSERT INTO pmw_file VALUES (g_pmw.*)
 
      LET g_ydate = g_pmw.pmw06                         #備份上一筆交貨日期
      CALL s_get_doc_no(g_pmw.pmw01) RETURNING g_sheet  #截取單據編號中的單別代碼
 
      IF SQLCA.sqlcode THEN                             #置入資料庫不成功
         CALL cl_err3("ins","pmw_file",g_pmw.pmw01,"",SQLCA.sqlcode,"","",1) #No.FUN-B80088---上移一行調整至回滾事務前---
         ROLLBACK WORK     
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                    #新增成功後，若有設定流程通知
         CALL cl_flow_notify(g_pmw.pmw01,'I')           #則增加訊息到udm7主畫面上或使用者信箱
      END IF                                            #此功能適用單據程式
 
      SELECT pmw01 INTO g_pmw.pmw01 FROM pmw_file WHERE pmw01 = g_pmw.pmw01

      LET g_pmw01_t = g_pmw.pmw01                       #保留舊值
      LET g_pmw_t.* = g_pmw.*
      LET g_pmw_o.* = g_pmw.*
      CALL g_pmx.clear()
 
      LET g_rec_b = 0  
      CALL i252_b()                                     #輸入單身
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i252_u()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_pmw.* FROM pmw_file
    WHERE pmw01=g_pmw.pmw01
 
   IF g_pmw.pmwacti ='N' THEN    #檢查資料是否為無效
      CALL cl_err(g_pmw.pmw01,'mfg1000',0)
      RETURN
   END IF
 
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_pmw01_t = g_pmw.pmw01
   BEGIN WORK
 
   OPEN i252_cl USING g_pmw.pmw01
   IF STATUS THEN
      CALL cl_err("OPEN i252_cl:", STATUS, 1)
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i252_cl INTO g_pmw.*                      # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)    # 資料被他人LOCK
       CLOSE i252_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i252_show()
 
   WHILE TRUE
      LET g_pmw01_t = g_pmw.pmw01
      LET g_pmw_o.* = g_pmw.*
      LET g_pmw.pmwmodu=g_user
      LET g_pmw.pmwdate=g_today
      LET g_pmw.pmw07=g_pmw07            #CHI-880028 Add
 
      CALL i252_i("u")                      #欄位更改
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_pmw.*=g_pmw_t.*
         CALL i252_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_pmw.pmw01 != g_pmw01_t THEN            # 更改單號
         UPDATE pmx_file SET pmx01 = g_pmw.pmw01
          WHERE pmx01 = g_pmw01_t
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","pmx_file",g_pmw01_t,"",SQLCA.sqlcode,"","pmx",1)  #No.FUN-660129
            CONTINUE WHILE
         END IF
      END IF
 
      UPDATE pmw_file SET pmw_file.* = g_pmw.*
       WHERE pmw01 = g_pmw01_t                #MOD-C80192 g_pmw.pmw01 -> g_pmw01_t 
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","pmw_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         CONTINUE WHILE
      END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i252_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmw.pmw01,'U')
 
   CALL i252_b_fill("1=1")
   CALL i252_bp_refresh()
 
END FUNCTION
 

FUNCTION i252_i(p_cmd)

   DEFINE l_pmc05     LIKE pmc_file.pmc05
   DEFINE l_pmc30     LIKE pmc_file.pmc30
   DEFINE l_n         LIKE type_file.num5    
   DEFINE p_cmd       LIKE type_file.chr1     #a:輸入 u:更改  
   DEFINE li_result   LIKE type_file.num5    
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   DISPLAY BY NAME g_pmw.pmwuser,g_pmw.pmwmodu,g_pmw.pmwgrup,g_pmw.pmwdate,g_pmw.pmwacti
 
   CALL cl_set_head_visible("","YES")

   INPUT BY NAME g_pmw.pmworiu,g_pmw.pmworig,g_pmw.pmw01,g_pmw.pmw06,g_pmw.pmw04,
                 g_pmw.pmw05,g_pmw.pmw051
       WITHOUT DEFAULTS
 
      BEFORE INPUT
         LET g_before_input_done = FALSE
         CALL i252_set_entry(p_cmd)
         CALL i252_set_no_entry(p_cmd)
         LET g_before_input_done = TRUE
         CALL cl_set_docno_format("pmw01")
 
      AFTER FIELD pmw01
         #單號處理方式:
         #在輸入單別後, 至單據性質檔中讀取該單別資料;
         #若該單別不需自動編號, 則讓使用者自行輸入單號, 並檢查其是否重複
         #若要自動編號, 則單號不用輸入, 直到單頭輸入完成後, 再行自動指定單號
         IF NOT cl_null(g_pmw.pmw01) THEN
            CALL s_check_no("apm",g_pmw.pmw01,g_pmw01_t,"6","pmw_file","pmw01","") RETURNING li_result,g_pmw.pmw01
            DISPLAY BY NAME g_pmw.pmw01
            IF (NOT li_result) THEN
               LET g_pmw.pmw01=g_pmw_o.pmw01
               NEXT FIELD pmw01
            END IF
            DISPLAY g_smy.smydesc TO smydesc
           #TQC-C80032---mark---
           #IF g_pmw.pmw01 != g_pmw01_t OR g_pmw01_t IS NULL THEN
           #   #進行輸入之單號檢查
           #END IF
           #TQC-C80032---mark---
         END IF
 
      AFTER FIELD pmw04                  #幣別
         IF NOT cl_null(g_pmw.pmw04) THEN
            IF g_pmw_o.pmw04 IS NULL OR
               (g_pmw_o.pmw04 != g_pmw.pmw04 ) THEN
               CALL i252_pmw04(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmw.pmw04,g_errno,0)
                  LET g_pmw.pmw04 = g_pmw_o.pmw04
                  DISPLAY BY NAME g_pmw.pmw04
                  NEXT FIELD pmw04
               END IF
            END IF
            LET g_pmw_o.pmw04 = g_pmw.pmw04
         END IF
 
      AFTER FIELD pmw05                  #稅別
         IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
         IF NOT cl_null(g_pmw.pmw05) THEN
            IF g_pmw_o.pmw05 IS NULL OR
               (g_pmw_o.pmw05 != g_pmw.pmw05 ) THEN
               CALL i252_pmw05(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_pmw.pmw05,g_errno,0)
                  LET g_pmw.pmw05 = g_pmw_o.pmw05
                  DISPLAY BY NAME g_pmw.pmw05
                  NEXT FIELD pmw05
               END IF
               IF p_cmd = 'u' AND g_pmw_o.pmw051 != g_pmw.pmw051 THEN   
                  #當修改單頭稅別時,要重計單身的詢價未稅單價欄位(pmx06)
                  CALL i252_cal_price()
               END IF
            END IF
            LET g_pmw_o.pmw05 = g_pmw.pmw05
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(pmw01) #單據編號
                 LET g_t1 = s_get_doc_no(g_pmw.pmw01) 
                 CALL q_smy(FALSE,FALSE,g_t1,'APM','6') RETURNING g_t1 
                 LET g_pmw.pmw01 = g_t1           
                 DISPLAY BY NAME g_pmw.pmw01
                 CALL i252_pmw01('d')
                 NEXT FIELD pmw01
 
            WHEN INFIELD(pmw04) #幣別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azi"
               LET g_qryparam.default1 = g_pmw.pmw04
               CALL cl_create_qry() RETURNING g_pmw.pmw04
               DISPLAY BY NAME g_pmw.pmw04
               CALL i252_pmw04('d')
               NEXT FIELD pmw04
 
            WHEN INFIELD(pmw05) #稅別
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gec"
               LET g_qryparam.default1 = g_pmw.pmw05
               LET g_qryparam.arg1     = '1'
               CALL cl_create_qry() RETURNING g_pmw.pmw05
               DISPLAY BY NAME g_pmw.pmw05
               CALL i252_pmw05('d')
               NEXT FIELD pmw05
 
            OTHERWISE EXIT CASE
          END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION i252_pmw01(p_cmd)  #單據編號
   DEFINE l_smydesc LIKE smy_file.smydesc,
          l_smyacti LIKE smy_file.smyacti,
          l_t1      LIKE oay_file.oayslip, 
          p_cmd     LIKE type_file.chr1   
 
   LET g_errno = ' '
   LET l_t1 = s_get_doc_no(g_pmw.pmw01)        #No.MOD-540182
   IF g_pmw.pmw01 IS NULL THEN
      LET g_errno = 'E'
      LET l_smydesc=NULL
   ELSE
      SELECT smydesc,smyacti
        INTO l_smydesc,l_smyacti
        FROM smy_file WHERE smyslip = l_t1
      IF SQLCA.sqlcode THEN
         LET g_errno = 'E'
         LET l_smydesc = NULL
      ELSE
         IF l_smyacti matches'[nN]' THEN
            LET g_errno = 'E'
         END IF
      END IF
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_smydesc TO FORMONLY.smydesc
   END IF
 
END FUNCTION
 
FUNCTION i252_pmw03(p_cmd)  #廠商編號
    DEFINE l_pmc03 LIKE pmc_file.pmc03,
           l_pmc22 LIKE pmc_file.pmc22,
           l_pmc47 LIKE pmc_file.pmc47,           #No.FUN-550019
           l_pmcacti LIKE pmc_file.pmcacti,
           p_cmd   LIKE type_file.chr1    
 
   LET g_errno = " "
   SELECT pmc03,pmc22,pmc47,pmcacti
     INTO l_pmc03,l_pmc22,l_pmc47,l_pmcacti
     FROM pmc_file WHERE pmc01 = g_pmw.pmw03
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                           LET l_pmc03 = NULL
                           LET l_pmc22 = NULL
        WHEN l_pmcacti='N' LET g_errno = '9028'
        WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690024
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd = 'a' THEN
      LET g_pmw.pmw04 = l_pmc22
      LET g_pmw.pmw05 = l_pmc47       #No.FUN-550019
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.pmc03
      DISPLAY BY NAME g_pmw.pmw04
   END IF
 
END FUNCTION
 
FUNCTION i252_pmx12(p_cmd)  #廠商編號

   DEFINE l_pmc RECORD LIKE pmc_file.*
   DEFINE p_cmd   LIKE type_file.chr1 
 
   LET g_errno = ""
   SELECT * INTO l_pmc.* FROM pmc_file
     WHERE pmc01=g_pmx[l_ac].pmx12

   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3001'
                                  LET g_pmx[l_ac].pmc03 = NULL
        WHEN l_pmc.pmcacti='N'        LET g_errno = '9028'
        WHEN l_pmc.pmcacti MATCHES '[H]'  LET g_errno = '9038'  
        WHEN l_pmc.pmc05 = "0" AND l_pmc.pmc14 <> '2'   LET g_errno = 'mfg3288' 
        WHEN l_pmc.pmc05 = "3"    LET g_errno = 'mfg3289' 
        WHEN l_pmc.pmc30 = "2"    LET g_errno = 'mfg3290'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_pmx[l_ac].pmc03 = l_pmc.pmc03
      DISPLAY BY NAME g_pmx[l_ac].pmc03
   END IF
 
END FUNCTION


 
FUNCTION i252_pmw04(p_cmd)  #幣別
   DEFINE l_azi02   LIKE azi_file.azi02,
          l_aziacti LIKE azi_file.aziacti,
          p_cmd     LIKE type_file.chr1 
 
   LET g_errno = ' '
   LET t_azi03 = 0    #No.CHI-6A0004
   SELECT azi02,aziacti,azi03
     INTO l_azi02,l_aziacti,t_azi03  #No.CHI-6A0004
     FROM azi_file WHERE azi01 = g_pmw.pmw04
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                           LET l_azi02 = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azi02 TO FORMONLY.azi02
   END IF
 
END FUNCTION
 
FUNCTION i252_pmw05(p_cmd)  #稅別
    DEFINE  l_gec04   LIKE gec_file.gec04,
            l_gecacti LIKE gec_file.gecacti,
            p_cmd     LIKE type_file.chr1    
 
    LET g_errno = " "
    SELECT gec04,gecacti,gec07 INTO l_gec04,l_gecacti,g_gec07
      FROM gec_file
     WHERE gec01 = g_pmw.pmw05 AND gec011='1'  #進項
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                   LET l_gec04 = 0
         WHEN l_gecacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_gec07) THEN
       LET g_gec07 = 'N'
    END IF
 
       LET g_pmw.pmw051 = l_gec04
       DISPLAY BY NAME g_pmw.pmw051   #FUN-640063 add
 
    IF cl_null(g_errno) OR p_cmd = 'd' THEN
       DISPLAY g_gec07 TO FORMONLY.gec07
    END IF
 
END FUNCTION
 
FUNCTION i252_cal_price()
    DEFINE l_pmx02   LIKE pmx_file.pmx02,
           l_pmx06t  LIKE pmx_file.pmx06t,
           l_pmx06   LIKE pmx_file.pmx06
 
    #抓取單身詢價含稅單價
    LET g_sql = "SELECT pmx02,pmx06t FROM pmx_file WHERE pmx01 ='",g_pmw.pmw01,"' "
    PREPARE i252_cal FROM g_sql
    DECLARE pmx_cs_cal CURSOR FOR i252_cal             #CURSOR
 
    FOREACH pmx_cs_cal INTO l_pmx02,l_pmx06t
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       LET l_pmx06 = l_pmx06t / (1 + g_pmw.pmw051/100)
       LET l_pmx06 = cl_digcut(l_pmx06,t_azi03)  #No.CHI-6A0004
 
       UPDATE pmx_file SET pmx06 = l_pmx06 
                     WHERE pmx01 = g_pmw.pmw01 
                       AND pmx02 = l_pmx02
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","pmx_file",g_pmw.pmw01,l_pmx02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
       END IF
    END FOREACH
 
END FUNCTION
 
FUNCTION i252_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   MESSAGE ""
   CALL cl_opmsg('q')
   CLEAR FORM
   CALL g_pmx.clear()
   DISPLAY ' ' TO FORMONLY.cnt
 
   CALL i252_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      INITIALIZE g_pmw.* TO NULL
      RETURN
   END IF
 
   OPEN i252_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_pmw.* TO NULL
   ELSE
      OPEN i252_count
      FETCH i252_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
 
      CALL i252_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i252_fetch(p_flag)

   DEFINE p_flag          LIKE type_file.chr1                  #處理方式
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i252_cs INTO g_pmw.pmw01
      WHEN 'P' FETCH PREVIOUS i252_cs INTO g_pmw.pmw01
      WHEN 'F' FETCH FIRST    i252_cs INTO g_pmw.pmw01
      WHEN 'L' FETCH LAST     i252_cs INTO g_pmw.pmw01
      WHEN '/'
            IF (NOT g_no_ask) THEN      #No.FUN-6A0067
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
                IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump i252_cs INTO g_pmw.pmw01
            LET g_no_ask = FALSE     #No.FUN-6A0067
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)
      INITIALIZE g_pmw.* TO NULL               #No.FUN-6A0162
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
      DISPLAY g_curs_index TO FORMONLY.idx                    #No.FUN-4A0089
   END IF
 
   SELECT * INTO g_pmw.* FROM pmw_file WHERE pmw01 = g_pmw.pmw01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","pmw_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      INITIALIZE g_pmw.* TO NULL
      RETURN
   END IF
 
   LET g_data_owner = g_pmw.pmwuser      #FUN-4C0056 add
   LET g_data_group = g_pmw.pmwgrup      #FUN-4C0056 add
   LET g_data_plant = g_pmw.pmwplant #FUN-980030
 
   CALL i252_show()
 
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION i252_show()
 
   LET g_pmw_t.* = g_pmw.*                #保存單頭舊值
   LET g_pmw_o.* = g_pmw.*                #保存單頭舊值
   DISPLAY BY NAME g_pmw.pmworiu,g_pmw.pmworig, g_pmw.pmw01,g_pmw.pmw06,g_pmw.pmw04,                #FUN-650191
                   g_pmw.pmwuser,g_pmw.pmwgrup,g_pmw.pmwmodu,
                   g_pmw.pmwdate,g_pmw.pmwacti,
                   g_pmw.pmw05,g_pmw.pmw051           #No.FUN-550019
 
   CALL i252_pmw01('d')
   CALL i252_pmw04('d')
   CALL i252_pmw05('d')                    #No.FUN-550019
 
   CALL i252_b_fill(g_wc2)                 #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i252_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i252_cl USING g_pmw.pmw01
   IF STATUS THEN
      CALL cl_err("OPEN i252_cl:", STATUS, 1)
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i252_cl INTO g_pmw.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   LET g_success = 'Y'
 
   CALL i252_show()
 
   IF cl_exp(0,0,g_pmw.pmwacti) THEN                   #確認一下
      LET g_chr=g_pmw.pmwacti
      IF g_pmw.pmwacti='Y' THEN
         LET g_pmw.pmwacti='N'
      ELSE
         LET g_pmw.pmwacti='Y'
      END IF
 
      UPDATE pmw_file SET pmwacti=g_pmw.pmwacti,
                          pmwmodu=g_user,
                          pmwdate=g_today
       WHERE pmw01=g_pmw.pmw01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","pmw_file",g_pmw.pmw01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
         LET g_pmw.pmwacti=g_chr
      END IF
   END IF
 
   CLOSE i252_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL cl_flow_notify(g_pmw.pmw01,'V')
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT pmwacti,pmwmodu,pmwdate
     INTO g_pmw.pmwacti,g_pmw.pmwmodu,g_pmw.pmwdate FROM pmw_file
    WHERE pmw01=g_pmw.pmw01
   DISPLAY BY NAME g_pmw.pmwacti,g_pmw.pmwmodu,g_pmw.pmwdate
 
END FUNCTION
 
FUNCTION i252_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_pmw.* FROM pmw_file
    WHERE pmw01=g_pmw.pmw01
   BEGIN WORK
 
   OPEN i252_cl USING g_pmw.pmw01
   IF STATUS THEN
      CALL cl_err("OPEN i252_cl:", STATUS, 1)
      CLOSE i252_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i252_cl INTO g_pmw.*               # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)          #資料被他人LOCK
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i252_show()
 
   IF cl_delh(0,0) THEN                   #確認一下
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "pmw01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_pmw.pmw01      #No.FUN-9B0098 10/02/24
      #  CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
       CALL cl_del_doc_smb()                #No.FUN-9B0098 10/02/24
      DELETE FROM pmw_file WHERE pmw01 = g_pmw.pmw01
      DELETE FROM pmx_file WHERE pmx01 = g_pmw.pmw01
      CLEAR FORM
      CALL g_pmx.clear()
      OPEN i252_count
      #FUN-B50065-add-start--
      IF STATUS THEN
         CLOSE i252_cs
         CLOSE i252_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50065-add-end--
      FETCH i252_count INTO g_row_count
      #FUN-B50065-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i252_cs
         CLOSE i252_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50065-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i252_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i252_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET g_no_ask = TRUE      #No.FUN-6A0067
         CALL i252_fetch('/')
      END IF
   END IF
 
   CLOSE i252_cl
   COMMIT WORK
   CALL cl_flow_notify(g_pmw.pmw01,'D')
END FUNCTION
 
#單身
FUNCTION i252_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  
    l_n             LIKE type_file.num5,                #檢查重複用  
    l_n1            LIKE type_file.num5,        
    l_n2            LIKE type_file.num5,        
    l_n3            LIKE type_file.num5,         
    l_cnt           LIKE type_file.num5,                #檢查重複用 
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否 
    p_cmd           LIKE type_file.chr1,                #處理狀態  
    l_misc          LIKE gef_file.gef01,               
    l_allow_insert  LIKE type_file.num5,                #可新增否  
    l_allow_delete  LIKE type_file.num5,                #可刪除否  
    l_pmc05         LIKE pmc_file.pmc05,   
    l_pmc30         LIKE pmc_file.pmc30   
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
DEFINE  l_s1     LIKE type_file.chr1000 
DEFINE  l_m1     LIKE type_file.chr1000 
DEFINE  i1       LIKE type_file.num5
DEFINE l_case    STRING                  #FUN-C20068 add
DEFINE l_case1   STRING                  #FUN-C20068 add
 
    LET g_action_choice = ""
 
    IF s_shut(0) THEN
       RETURN
    END IF
 
    IF g_pmw.pmw01 IS NULL THEN
       RETURN
    END IF
 
    SELECT * INTO g_pmw.* FROM pmw_file
     WHERE pmw01=g_pmw.pmw01
 
    IF g_pmw.pmwacti ='N' THEN    #檢查資料是否為無效
       CALL cl_err(g_pmw.pmw01,'mfg1000',0)
       RETURN
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT pmx02,pmx12,'',pmx08,pmx081,pmx082,pmx10,'',pmx13,pmx09,'','',pmx04,",#No.FUN-930061 add ''
                       "       pmx05,pmx03,pmx06,pmx06t,pmx07 ",  #No.FUN-550019
                       "  FROM pmx_file",
                       "  WHERE pmx01=? AND pmx02=? ",
                       "   AND pmx11='",g_pmx11,"' FOR UPDATE "  #No.FUN-670099         #TQC-760046
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i252_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    INPUT ARRAY g_pmx WITHOUT DEFAULTS FROM s_pmx.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                    APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           DISPLAY "BEFORE INPUT!"
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
 
        BEFORE ROW
           DISPLAY "BEFORE ROW!"
           LET p_cmd = ''
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'            #DEFAULT
           LET l_n  = ARR_COUNT()
 
           BEGIN WORK
 
           OPEN i252_cl USING g_pmw.pmw01
           IF STATUS THEN
              CALL cl_err("OPEN i252_cl:", STATUS, 1)
              CLOSE i252_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           FETCH i252_cl INTO g_pmw.*            # 鎖住將被更改或取消的資料
           IF SQLCA.sqlcode THEN
              CALL cl_err(g_pmw.pmw01,SQLCA.sqlcode,0)      # 資料被他人LOCK
              CLOSE i252_cl
              ROLLBACK WORK
              RETURN
           END IF
 
           IF g_rec_b >= l_ac THEN
              LET p_cmd='u'
              LET g_pmx_t.* = g_pmx[l_ac].*  #BACKUP
              LET g_pmx_o.* = g_pmx[l_ac].*  #BACKUP
              LET g_pmx09_t = g_pmx[l_ac].pmx09   #FUN-910088--add--
              OPEN i252_bcl USING g_pmw.pmw01,g_pmx_t.pmx02
              IF STATUS THEN
                 CALL cl_err("OPEN i252_bcl:", STATUS, 1)
                 LET l_lock_sw = "Y"
              ELSE
                 FETCH i252_bcl INTO g_pmx[l_ac].*
                 IF SQLCA.sqlcode THEN
                    CALL cl_err(g_pmx_t.pmx02,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                 END IF
                 CALL i252_pmx12('d') #FUN-650191 add
 
                 LET g_errno = ' '
                 SELECT ima02,ima021,ima44,imaacti INTO l_ima02,l_ima021,l_ima44,l_imaacti
                   FROM ima_file WHERE ima01 = g_pmx[l_ac].pmx08
 
                 CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                                LET l_ima02 = NULL
                                                LET l_ima44 = NULL
                      WHEN l_imaacti='N' LET g_errno = '9028'
                      WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038' 
                      OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
                END CASE
                SELECT ecd02 INTO g_pmx[l_ac].ecd02
                  FROM ecd_file
                 WHERE ecd01=g_pmx[l_ac].pmx10
                IF SQLCA.sqlcode = 100 THEN
                   LET g_pmx[l_ac].ecd02 = " "
                END IF
                DISPLAY BY NAME g_pmx[l_ac].ecd02
                LET l_m1 = ' '
                IF g_sma.sma120 = 'Y' THEN
                   IF NOT cl_null(g_errno) THEN
                      LET g_buf = g_pmx[l_ac].pmx08
                      LET l_s1 = g_buf.trim()
                      FOR i1=1 TO length(l_s1)
                      IF l_s1[i1,i1] = '_' THEN
                         LET l_m1 = l_s1[1,i1-1]
                         EXIT FOR
                      ELSE                                                                                                                            
                         CONTINUE FOR
                      END IF
                      IF l_s1[i1,i1] = '-' THEN
                        LET l_m1 = l_s1[1,i1-1]
                        EXIT FOR
                      ELSE                                                                                                                            
                        CONTINUE FOR
                      END IF
                      IF l_s1[i1,i1] = ' ' THEN
                         LET l_m1 = l_s1[1,i1-1]
                         EXIT FOR
                     ELSE                                                                                                                            
                        CONTINUE FOR
                     END IF
                     END FOR
                   END IF 
                 END IF
                 IF NOT cl_null(l_m1) THEN
                    SELECT ima44,ima908 INTO g_pmx[l_ac].ima44,g_pmx[l_ac].ima908
                      FROM ima_file WHERE ima01=l_m1
                 ELSE
                   SELECT ima44,ima908 INTO g_pmx[l_ac].ima44,g_pmx[l_ac].ima908
                     FROM ima_file WHERE ima01=g_pmx[l_ac].pmx08
                 END IF
              END IF
              CALL cl_show_fld_cont()     #FUN-550037(smin)
              CALL i252_set_entry_b(p_cmd)    #No.FUN-610018
              CALL i252_set_no_entry_b(p_cmd) #No.FUN-610018
           END IF
 
        BEFORE INSERT
           DISPLAY "BEFORE INSERT!"
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_pmx[l_ac].* TO NULL      #900423
           LET g_pmx[l_ac].pmx03 =  0            #Body default
           LET g_pmx[l_ac].pmx06 =  0            #Body default
           LET g_pmx[l_ac].pmx06t=  0            #No.FUN-550019
           LET g_pmx[l_ac].pmx07 =  0            #Body default
           LET g_pmx[l_ac].pmx10 = " "           #No.TQC-740192
           LET g_pmx[l_ac].ecd02 = " "           #No.FUN-930061
           LET g_pmx[l_ac].pmx13 = " "           #No.FUN-810017
           LET g_pmx_t.* = g_pmx[l_ac].*         #新輸入資料
           LET g_pmx_o.* = g_pmx[l_ac].*         #新輸入資料
           LET g_pmx09_t = NULL                  #FUN-910088--add--
           IF l_ac > 1 THEN
              LET g_pmx[l_ac].pmx04 = g_pmx[l_ac-1].pmx04
           ELSE
              LET g_pmx[l_ac].pmx04 = g_pmw.pmw06
           END IF
           CALL cl_show_fld_cont()         #FUN-550037(smin)
           CALL i252_set_entry_b(p_cmd)    #No.FUN-610018
           CALL i252_set_no_entry_b(p_cmd) #No.FUN-610018
           NEXT FIELD pmx02
 
        AFTER INSERT
           DISPLAY "AFTER INSERT!"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF cl_null(g_pmx[l_ac].pmx10) THEN
              LET g_pmx[l_ac].pmx10 = " "
              LET g_pmx[l_ac].ecd02 = " "           #No.FUN-930061
           END IF
           INSERT INTO pmx_file(pmx01,pmx02,pmx03,pmx04,pmx05,pmx06,
                                pmx06t,pmx07,pmx08,pmx09,pmx10,pmx13,pmx11,pmx081,pmx082,pmx12,pmxplant,pmxlegal)  #No.FUN-550019  #No.FUN-670099  #FUN-650191 add pmx12 #No.FUN-810017 #FUN-980006 add pmxplant,pmxlegal
           VALUES(g_pmw.pmw01,g_pmx[l_ac].pmx02,
                  g_pmx[l_ac].pmx03,g_pmx[l_ac].pmx04,
                  g_pmx[l_ac].pmx05,g_pmx[l_ac].pmx06,
                  g_pmx[l_ac].pmx06t,                     #No.FUN-550019
                  g_pmx[l_ac].pmx07,g_pmx[l_ac].pmx08,
                  g_pmx[l_ac].pmx09,g_pmx[l_ac].pmx10,g_pmx[l_ac].pmx13,g_pmx11,  #No.FUN-670099 #No.FUN-810017
                  g_pmx[l_ac].pmx081,g_pmx[l_ac].pmx082,g_pmx[l_ac].pmx12,g_plant,g_legal)  #FUN-650191 add pmx12 #FUN-980006 add g_plant,g_legal
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","pmx_file",g_pmw.pmw01,g_pmx[l_ac].pmx02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
              CANCEL INSERT
           ELSE
              MESSAGE 'INSERT O.K'
              COMMIT WORK
              LET g_rec_b=g_rec_b+1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
 
        BEFORE FIELD pmx02                        #default 序號
           IF g_pmx[l_ac].pmx02 IS NULL OR g_pmx[l_ac].pmx02 = 0 THEN
              SELECT max(pmx02)+1
                INTO g_pmx[l_ac].pmx02
                FROM pmx_file
               WHERE pmx01 = g_pmw.pmw01
              IF g_pmx[l_ac].pmx02 IS NULL THEN
                 LET g_pmx[l_ac].pmx02 = 1
              END IF
           END IF
 
        AFTER FIELD pmx02                        #check 序號是否重複
           IF NOT cl_null(g_pmx[l_ac].pmx02) THEN
              IF g_pmx[l_ac].pmx02 != g_pmx_t.pmx02
                 OR g_pmx_t.pmx02 IS NULL THEN
                 SELECT count(*)
                   INTO l_n
                   FROM pmx_file
                  WHERE pmx01 = g_pmw.pmw01
                    AND pmx02 = g_pmx[l_ac].pmx02
                 IF l_n > 0 THEN
                    CALL cl_err('',-239,0)
                    LET g_pmx[l_ac].pmx02 = g_pmx_t.pmx02
                    NEXT FIELD pmx02
                 END IF
              END IF
           END IF
 
      AFTER FIELD pmx12                       #廠商編號
         IF NOT cl_null(g_pmx[l_ac].pmx12) THEN
            IF g_pmx_o.pmx12 IS NULL OR
               (g_pmx[l_ac].pmx12 != g_pmx_o.pmx12 ) THEN
               CALL i252_pmx12(p_cmd)
               IF NOT cl_null(g_errno) THEN
                  #-----CHI-A40042---------
                  IF g_errno = 'mfg3288' THEN   
                     CALL cl_err(g_pmx[l_ac].pmx12,g_errno,1)
                  ELSE
                  #-----END CHI-A40042-----
                     CALL cl_err(g_pmx[l_ac].pmx12,g_errno,0)
                     LET g_pmx[l_ac].pmx12 = g_pmx_o.pmx12
                     DISPLAY BY NAME g_pmx[l_ac].pmx12
                     NEXT FIELD pmx12
                  END IF   #CHI-A40042
               END IF
            END IF
            #-----CHI-A40042---------
            #SELECT pmc05,pmc30 INTO l_pmc05,l_pmc30 FROM pmc_file
            # WHERE pmc01 = g_pmx[l_ac].pmx12
            #IF l_pmc05 = "0" THEN
            #   CALL cl_err('','mfg3288',1)
            #END IF
            #IF l_pmc05 = "3" THEN
            #   CALL cl_err('','mfg3289',0)
            #   NEXT FIELD pmx12
            #END IF
            #IF l_pmc30 = "2" THEN       
            #   CALL cl_err('','mfg3290',0)
            #   NEXT FIELD pmx12
            #END IF
            #-----END CHI-A40042-----
            LET g_pmx_o.pmx12 = g_pmx[l_ac].pmx12
         END IF
 
        BEFORE FIELD pmx08
           CALL i252_set_entry_b(p_cmd)
 
        AFTER FIELD pmx08                  #料件編號   
           LET l_misc=g_pmx[l_ac].pmx08[1,4]
           LET l_case = NULL  #FUN-C20068 add
           LET l_case1 = NULL #FUN-C20068 add
           IF g_pmx[l_ac].pmx08[1,4]='MISC' THEN
              SELECT COUNT(*) INTO l_n FROM ima_file
               WHERE ima01=l_misc
                 AND ima01='MISC'
              IF l_n=0 THEN
                 CALL cl_err('','aim-806',0)
                 NEXT FIELD pmx08
              END IF
           END IF
           IF NOT cl_null(g_pmx[l_ac].pmx08) THEN
#NO.FUN-A90048 add -----------start--------------------     
             IF NOT s_chk_item_no(g_pmx[l_ac].pmx08,'') THEN
                CALL cl_err('',g_errno,1)
                LET g_pmx[l_ac].pmx08 = g_pmx_t.pmx08 
                NEXT FIELD pmx08
             END IF
#NO.FUN-A90048 add ------------end --------------------               
              IF g_pmx_o.pmx08 IS NULL OR g_pmx_o.pmx081 IS NULL OR
                (g_pmx[l_ac].pmx08 != g_pmx_o.pmx08 ) THEN
                 CALL i252_pmx08('a')
                 CALL i252_pmx03_check(p_cmd) RETURNING l_case  #FUN-C20068 add
                 LET g_pmx09_t = g_pmx[l_ac].pmx09              #FUN-910088 add
               LET l_m = ' '
              IF g_sma.sma120 = 'Y' THEN
               IF NOT cl_null(g_errno) THEN
                 SELECT count(*) INTO l_n3
                   FROM imx_file,sma_file
                  WHERE (imx00||sma46||imx01||sma46||imx02||sma46||imx03||sma46||imx04=g_pmx[l_ac].pmx08)
                     OR (imx00||sma46||imx01||sma46||imx02||sma46||imx03=g_pmx[l_ac].pmx08)
                     OR (imx00||sma46||imx01||sma46||imx02=g_pmx[l_ac].pmx08)
                     OR (imx00||sma46||imx01=g_pmx[l_ac].pmx08)
                     OR imx00=g_pmx[l_ac].pmx08
                 IF l_n3 > 0 THEN
                    LET g_errno = ' ' 
                    LET g_buf = g_pmx[l_ac].pmx08
                    LET l_s = g_buf.trim()
                    FOR i=1 TO length(l_s)
                        IF l_s[i,i] = '_' THEN
                           LET l_m = l_s[1,i-1]
                           CALL i252_pmx08_1('a',l_m)
                           EXIT FOR
                        ELSE                                                                                                                            
                           CONTINUE FOR
                        END IF
                        IF l_s[i,i] = '-' THEN
                           LET l_m = l_s[1,i-1]
                           CALL i252_pmx08_1('a',l_m)
                           EXIT FOR
                        ELSE                                                                                                                            
                           CONTINUE FOR
                        END IF
                        IF l_s[i,i] = ' ' THEN
                           LET l_m = l_s[1,i-1]
                           CALL i252_pmx08_1('a',l_m)
                           EXIT FOR
                        ELSE                                                                                                                            
                           CONTINUE FOR
                        END IF
                    END FOR
                    CALL i252_pmx03_check(p_cmd) RETURNING l_case1  #FUN-C20068 add
                 ELSE
                    CALL cl_err('','apm-828',0)
                    NEXT FIELD pmx08
                 END IF
               END IF  
             END IF
              IF NOT cl_null(l_m) THEN
                 SELECT ima44,ima908 INTO g_pmx[l_ac].ima44,g_pmx[l_ac].ima908
                 FROM ima_file WHERE ima01= l_m
              ELSE
                 SELECT ima44,ima908 INTO g_pmx[l_ac].ima44,g_pmx[l_ac].ima908
                 FROM ima_file WHERE ima01=g_pmx[l_ac].pmx08
              END IF  #No.FUN-830114
                 IF NOT cl_null(g_errno)
                    AND g_pmx[l_ac].pmx08[1,4] !='MISC' THEN  #NO:6808
                    CALL cl_err(g_pmx[l_ac].pmx08,g_errno,0)
                    LET g_pmx[l_ac].pmx08 = g_pmx_o.pmx08
                    DISPLAY BY NAME g_pmx[l_ac].pmx08
                    NEXT FIELD pmx08
                 END IF
              END IF
           END IF
           LET g_pmx_o.pmx08 = g_pmx[l_ac].pmx08
           CALL i252_set_no_entry_b(p_cmd)
           #FUN-C20069--add--str--
           LET g_pmx09_t = g_pmx[l_ac].pmx09
           CASE l_case
              WHEN "pmx03" NEXT FIELD pmx03
              WHEN "pmx04" NEXT FIELD pmx04
           END CASE
           CASE l_case1
              WHEN "pmx03" NEXT FIELD pmx03
              WHEN "pmx04" NEXT FIELD pmx04
           END CASE
           #FUN-C20068--add--end--

        AFTER FIELD pmx10
           IF NOT cl_null(g_pmx[l_ac].pmx10) THEN
              SELECT COUNT(*) INTO g_cnt FROM ecd_file
               WHERE ecd01=g_pmx[l_ac].pmx10
              IF g_cnt=0 THEN
                 CALL cl_err('sel ecd_file',100,0)
                 NEXT FIELD pmx10
              END IF
           END IF
           IF cl_null(g_pmx[l_ac].pmx10) THEN
              LET g_pmx[l_ac].pmx10 =" " 
           END IF
           IF g_pmx_o.pmx081 IS NULL OR g_pmx_o.pmx08 IS NULL OR
             (g_pmx[l_ac].pmx08 != g_pmx_o.pmx08 ) OR
             (g_pmx[l_ac].pmx081 != g_pmx_o.pmx081 ) THEN
              SELECT COUNT(*) INTO l_cnt FROM pmx_file
               WHERE pmx01=g_pmw.pmw01
                 AND pmx08=g_pmx[l_ac].pmx08
                 AND pmx081=g_pmx[l_ac].pmx081
                 AND pmx10=g_pmx[l_ac].pmx10
                 AND pmx11=g_pmx11
                 AND pmx12=g_pmx[l_ac].pmx12   #No.TQC-740192
              IF l_cnt > 0 THEN
                 CALL cl_err('',-239,0)
                 NEXT FIELD pmx10
              END IF
           END IF
           IF NOT cl_null(g_pmx[l_ac].pmx13) AND g_pmx[l_ac].pmx13 != " " THEN
               IF g_pmx[l_ac].pmx10 IS NULL OR g_pmx[l_ac].pmx10 = " " THEN
                 CALL cl_err('','aap-099',0)
                 NEXT FIELD pmx10
              END IF
           END IF
           SELECT ecd02 INTO g_pmx[l_ac].ecd02
             FROM ecd_file
            WHERE ecd01=g_pmx[l_ac].pmx10
           DISPLAY BY NAME g_pmx[l_ac].ecd02
           IF SQLCA.sqlcode = 100 THEN
              LET g_pmx[l_ac].ecd02 = " "
           END IF
 
        AFTER FIELD pmx09                  #詢價單位
           IF NOT cl_null(g_pmx[l_ac].pmx09) THEN
              IF g_pmx[l_ac].pmx09 IS NULL OR g_pmx_t.pmx09 IS NULL OR
                 (g_pmx[l_ac].pmx09 != g_pmx_o.pmx09) THEN
                 CALL i252_pmx09()
                 IF NOT cl_null(g_errno) THEN
                    CALL cl_err(g_pmx[l_ac].pmx09,g_errno,0)
                    LET g_pmx[l_ac].pmx09 = g_pmx_o.pmx09
                    DISPLAY BY NAME g_pmx[l_ac].pmx09
                    NEXT FIELD pmx09
                 END IF
              END IF
              #FUN-C20068--add--str-- 
              CALL i252_pmx03_check(p_cmd) RETURNING l_case 
              LET g_pmx09_t = g_pmx[l_ac].pmx09
              CASE l_case
                 WHEN "pmx03" NEXT FIELD pmx03
                 WHEN "pmx04" NEXT FIELD pmx04
              END CASE
              #FUN-C20068--add--end--
           END IF
           LET g_pmx_o.pmx09 = g_pmx[l_ac].pmx09
 
        AFTER FIELD pmx05
           IF NOT cl_null(g_pmx[l_ac].pmx05) THEN
              IF (g_pmx[l_ac].pmx05 < g_pmx[l_ac].pmx04) THEN
                 CALL cl_err(g_pmx[l_ac].pmx05,'mfg3009',0)
                 NEXT FIELD pmx05
              END IF
           END IF
 
        AFTER FIELD pmx03                 #下限數量
           #FUN-C20068--add--str--
           CASE i252_pmx03_check(p_cmd) 
              WHEN "pmx03" NEXT FIELD pmx03
              WHEN "pmx04" NEXT FIELD pmx04
           END CASE
           #FUN-C20068--add--end--
        #FUN-910088--mark--start--
        #  IF NOT cl_null(g_pmx[l_ac].pmx03) THEN
        #     IF g_pmx[l_ac].pmx03 < 0 THEN
        #        CALL cl_err(g_pmx[l_ac].pmx03,'mfg5034',0)
        #        LET g_pmx[l_ac].pmx03 = g_pmx_o.pmx03
        #        DISPLAY BY NAME g_pmx[l_ac].pmx03
        #        NEXT FIELD pmx03
        #     END IF
        #     IF p_cmd = 'a' THEN
        #        IF NOT cl_null(g_pmx[l_ac].pmx05) THEN
        #           SELECT COUNT(*) INTO l_cnt FROM pmx_file
        #            WHERE( (g_pmx[l_ac].pmx04 <= pmx04
        #              AND g_pmx[l_ac].pmx05 >= pmx04)
        #               OR (g_pmx[l_ac].pmx04 <= pmx05
        #              AND g_pmx[l_ac].pmx05 >= pmx05)
        #               OR (g_pmx[l_ac].pmx04 >= pmx04
        #              AND g_pmx[l_ac].pmx05 <= pmx05)
        #               OR (g_pmx[l_ac].pmx04 <= pmx04
        #              AND g_pmx[l_ac].pmx05 >= pmx05)
        #               OR (pmx05 IS NULL AND pmx04 <= g_pmx[l_ac].pmx05))
        #              AND pmx08 = g_pmx[l_ac].pmx08
        #              AND pmx09 = g_pmx[l_ac].pmx09
        #              AND pmx03 = g_pmx[l_ac].pmx03
        #              AND pmx01 = g_pmw.pmw01
        #             #AND pmx03[1,4] <> 'MISC'              #No.TQC-9B0021 #TQC-960202 mark
        #              AND pmx08[1,4] <> 'MISC'              #No.TQC-960202 add
        #              AND pmx11 =  g_pmx11  #No.FUN-670099
        #              AND pmx12 = g_pmx[l_ac].pmx12   #No.TQC-740192
        #        END IF
        #        IF g_pmx[l_ac].pmx05 IS NULL THEN
        #           SELECT COUNT(*) INTO l_cnt FROM pmx_file
        #            WHERE ((g_pmx[l_ac].pmx04 <= pmx05)
        #               OR (pmx05 IS NULL))
        #              AND pmx08 = g_pmx[l_ac].pmx08
        #              AND pmx09 = g_pmx[l_ac].pmx09
        #              AND pmx03 = g_pmx[l_ac].pmx03
        #              AND pmx01 = g_pmw.pmw01
        #             #AND pmx03[1,4] <> 'MISC'              #No.TQC-9B0021 #TQC-960202 mark
        #              AND pmx08[1,4] <> 'MISC'              #TQC-960202 add
        #              AND pmx11 =  g_pmx11  #No.FUN-670099
        #              AND pmx10 =  g_pmx[l_ac].pmx10  #No.FUN-670099
        #              AND pmx12 = g_pmx[l_ac].pmx12   #No.TQC-740192
        #        END IF
        #        IF l_cnt > 0 THEN
        #           CALL cl_err('','mfg3287',0)
        #           NEXT FIELD pmx04
        #        END IF
        #     END IF
        #     IF p_cmd = 'u' THEN
        #        IF g_pmx[l_ac].pmx05 IS NOT NULL THEN
        #           SELECT COUNT(*) INTO l_cnt FROM pmx_file
        #            WHERE( (g_pmx[l_ac].pmx04 <= pmx04
        #              AND g_pmx[l_ac].pmx05 >= pmx04)
        #               OR (g_pmx[l_ac].pmx04 <= pmx05
        #              AND g_pmx[l_ac].pmx05 >= pmx05)
        #               OR (g_pmx[l_ac].pmx04 >= pmx04
        #              AND g_pmx[l_ac].pmx05 <= pmx05)
        #               OR (g_pmx[l_ac].pmx04 <= pmx04
        #              AND g_pmx[l_ac].pmx05 >= pmx05)
        #               OR (pmx05 IS NULL AND pmx04 <= g_pmx[l_ac].pmx05))
        #              AND pmx08 = g_pmx[l_ac].pmx08
        #              AND pmx09 = g_pmx[l_ac].pmx09
        #              AND pmx03 = g_pmx[l_ac].pmx03
        #              AND pmx02 != g_pmx[l_ac].pmx02
        #              AND pmx01 = g_pmw.pmw01
        #              AND pmx11 =  g_pmx11  #No.FUN-670099
        #              AND pmx12 = g_pmx[l_ac].pmx12   #No.TQC-740192
        #        END IF
        #        IF g_pmx[l_ac].pmx05 IS NULL THEN
        #           SELECT COUNT(*) INTO l_cnt FROM pmx_file
        #            WHERE ((g_pmx[l_ac].pmx04 <= pmx05)
        #               OR (pmx05 IS NULL))
        #              AND pmx08 = g_pmx[l_ac].pmx08
        #              AND pmx09 = g_pmx[l_ac].pmx09
        #              AND pmx03 = g_pmx[l_ac].pmx03
        #              AND pmx02 != g_pmx[l_ac].pmx02
        #              AND pmx01 = g_pmw.pmw01
        #              AND pmx11 =  g_pmx11  #No.FUN-670099
        #              AND pmx10 =  g_pmx[l_ac].pmx10  #No.FUN-670099
        #              AND pmx12 =  g_pmx[l_ac].pmx12  #No.TQC-740192
        #        END IF
        #        IF l_cnt > 0 THEN
        #           CALL cl_err('','mfg3287',0)
        #           NEXT FIELD pmx04
        #        END IF
        #     END IF
        #     LET g_pmx_o.pmx03 = g_pmx[l_ac].pmx03
        #  END IF
        #FUN-910088--mark--end--
 
        AFTER FIELD pmx06                  #詢價單價
           IF NOT cl_null(g_pmx[l_ac].pmx06) THEN
              IF g_pmx[l_ac].pmx06 <= 0 THEN
                 CALL cl_err(g_pmx[l_ac].pmx06,'mfg3291',0)
                 LET g_pmx[l_ac].pmx06 = g_pmx_o.pmx06
                 NEXT FIELD pmx06
              END IF
              LET g_pmx[l_ac].pmx06 = cl_digcut(g_pmx[l_ac].pmx06,t_azi03)  #幣別取位  #No.CHI-6A0004
              DISPLAY BY NAME g_pmx[l_ac].pmx06
              LET g_pmx_o.pmx06 = g_pmx[l_ac].pmx06
              LET g_pmx[l_ac].pmx06t = g_pmx[l_ac].pmx06 * (1 + g_pmw.pmw051/100)
              LET g_pmx[l_ac].pmx06t = cl_digcut(g_pmx[l_ac].pmx06t,t_azi03)  #No.CHI-6A0004
              LET g_pmx_o.pmx06t = g_pmx[l_ac].pmx06t
           END IF
 
        AFTER FIELD pmx06t                  #詢價單價
           IF NOT cl_null(g_pmx[l_ac].pmx06t) THEN
              IF g_pmx[l_ac].pmx06t <= 0 THEN
                 CALL cl_err(g_pmx[l_ac].pmx06t,'mfg3291',0)
                 LET g_pmx[l_ac].pmx06t = g_pmx_o.pmx06t
                 NEXT FIELD pmx06t
              END IF
              LET g_pmx[l_ac].pmx06t = cl_digcut(g_pmx[l_ac].pmx06t,t_azi03)  #No.CHI-6A0004
              LET g_pmx_o.pmx06t = g_pmx[l_ac].pmx06t
 
              LET g_pmx[l_ac].pmx06 = g_pmx[l_ac].pmx06t / (1 + g_pmw.pmw051/100)
              LET g_pmx[l_ac].pmx06 = cl_digcut(g_pmx[l_ac].pmx06,t_azi03)  #No.CHI-6A0004
              LET g_pmx_o.pmx06 = g_pmx[l_ac].pmx06
           END IF
 
        AFTER FIELD pmx07                 #折扣比率
           IF NOT cl_null(g_pmx[l_ac].pmx07) THEN
              IF g_pmx[l_ac].pmx07 < 0 OR g_pmx[l_ac].pmx07 >= 100 THEN
                 CALL cl_err(g_pmx[l_ac].pmx07,'mfg0013',0)
                 LET g_pmx[l_ac].pmx07 = g_pmx_o.pmx07
                 DISPLAY BY NAME g_pmx[l_ac].pmx07
                 NEXT FIELD pmx07
              END IF
              LET g_pmx_o.pmx07 = g_pmx[l_ac].pmx07
           END IF
   
        AFTER FIELD pmx13
           IF cl_null(g_pmx[l_ac].pmx13) THEN
              LET g_pmx[l_ac].pmx13 = " "
           END IF
           IF NOT cl_null(g_pmx[l_ac].pmx13) AND g_pmx[l_ac].pmx13 != " " THEN
              SELECT count(*) INTO l_n1 FROM sga_file
               WHERE sga01 = g_pmx[l_ac].pmx13
                 AND sgaacti = 'Y'
              IF l_n1 = 0 THEN
                 CALL cl_err('','apm-105',0)
                 NEXT FIELD pmx13
              END IF
               IF g_pmx[l_ac].pmx10 IS NULL OR g_pmx[l_ac].pmx10 = " " THEN
                 CALL cl_err('','aap-099',0)
                 NEXT FIELD pmx10
              END IF
           END IF
 
        BEFORE DELETE                      #是否取消單身
           DISPLAY "BEFORE DELETE"
           IF g_pmx_t.pmx02 > 0 AND g_pmx_t.pmx02 IS NOT NULL THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM pmx_file
               WHERE pmx01 = g_pmw.pmw01
                 AND pmx02 = g_pmx_t.pmx02
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pmx_file",g_pmw.pmw01,g_pmx_t.pmx02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b=g_rec_b-1
              DISPLAY g_rec_b TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_pmx[l_ac].* = g_pmx_t.*
              CLOSE i252_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err(g_pmx[l_ac].pmx02,-263,1)
              LET g_pmx[l_ac].* = g_pmx_t.*
           ELSE
              IF cl_null(g_pmx[l_ac].pmx10) THEN
                 LET g_pmx[l_ac].pmx10 = " "
              END IF
              UPDATE pmx_file SET pmx02=g_pmx[l_ac].pmx02,
                                  pmx03=g_pmx[l_ac].pmx03,
                                  pmx04=g_pmx[l_ac].pmx04,
                                  pmx05=g_pmx[l_ac].pmx05,
                                  pmx06=g_pmx[l_ac].pmx06,
                                  pmx06t=g_pmx[l_ac].pmx06t,    #No.FUN-550019
                                  pmx07=g_pmx[l_ac].pmx07,
                                  pmx08=g_pmx[l_ac].pmx08,
                                  pmx09=g_pmx[l_ac].pmx09,
                                  pmx10=g_pmx[l_ac].pmx10,  #No.FUN-670099
                                  pmx13=g_pmx[l_ac].pmx13,  #No.FUN-810017
                                  pmx11=g_pmx11,            #No.FUN-670099
                                  pmx081=g_pmx[l_ac].pmx081,
                                  pmx082=g_pmx[l_ac].pmx082,
                                  pmx12=g_pmx[l_ac].pmx12  #FUN-650191 add
               WHERE pmx01=g_pmw.pmw01
                 AND pmx02=g_pmx_t.pmx02
                 AND pmx11=g_pmx11
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","pmx_file",g_pmw.pmw01,g_pmx_t.pmx02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                 LET g_pmx[l_ac].* = g_pmx_t.*
              ELSE
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           DISPLAY  "AFTER ROW!!"
           LET l_ac = ARR_CURR()
#          LET l_ac_t = l_ac        #FUN-D30034 mark
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_pmx[l_ac].* = g_pmx_t.*
              #FUN-D30034---add---str---
              ELSE
                 CALL g_pmx.deleteElement(l_ac)
                 IF g_rec_b != 0 THEN
                    LET g_action_choice = "detail"
                    LET l_ac = l_ac_t
                 END IF
              #FUN-D30034---add---end---
              END IF
              CLOSE i252_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           LET l_ac_t = l_ac        #FUN-D30034 add
           CLOSE i252_bcl
           COMMIT WORK
 
        ON ACTION CONTROLO                        #沿用所有欄位
           IF INFIELD(pmx02) AND l_ac > 1 THEN
              LET g_pmx[l_ac].* = g_pmx[l_ac-1].*
              LET g_pmx[l_ac].pmx02 = g_rec_b + 1
              NEXT FIELD pmx02
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION itemno
           IF g_sma.sma38 matches'[Yy]' THEN
              CALL cl_cmdrun("aimi109 ")
           ELSE
              CALL cl_err(g_sma.sma38,'mfg0035',1)
           END IF
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(pmx12) #廠商編號
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_pmc1"   #MOD-920024 q_pmc2-->q_pmc1
               LET g_qryparam.default1 = g_pmx[l_ac].pmx12
               CALL cl_create_qry() RETURNING g_pmx[l_ac].pmx12
               DISPLAY BY NAME g_pmx[l_ac].pmx12
               CALL i252_pmx12('d')
               NEXT FIELD pmx12
 
              WHEN INFIELD(pmx08) #料件編號
        #No.FUN-A90048 ------------------start------------------------      
        #         CALL cl_init_qry_var()
        #         LET g_qryparam.form ="q_ima"
        #         LET g_qryparam.default1 = g_pmx[l_ac].pmx08
        #         CALL cl_create_qry() RETURNING g_pmx[l_ac].pmx08
                  CALL q_sel_ima(FALSE, "q_ima","",g_pmx[l_ac].pmx08,"", "", "", "" ,"" ,'')
                                  RETURNING g_pmx[l_ac].pmx08  
        #No.FUN-A90048 ------------------end -------------------------
                  DISPLAY BY NAME g_pmx[l_ac].pmx08              #No.MOD-490371
                 IF NOT cl_null(g_pmx[l_ac].pmx08) AND
                    g_pmx[l_ac].pmx08[1,4] !='MISC' THEN
                    CALL i252_pmx08('d')
                 END IF
                 NEXT FIELD pmx08
 
              WHEN INFIELD(pmx09) #詢價單位
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gfe"
                 LET g_qryparam.default1 = g_pmx[l_ac].pmx09
                 CALL cl_create_qry() RETURNING g_pmx[l_ac].pmx09
                 DISPLAY BY NAME g_pmx[l_ac].pmx09
                 NEXT FIELD pmx09
              WHEN INFIELD(pmx13) 
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_sga"
                 LET g_qryparam.default1 = g_pmx[l_ac].pmx13
                 CALL cl_create_qry() RETURNING g_pmx[l_ac].pmx13
                 DISPLAY BY NAME g_pmx[l_ac].pmx13
              WHEN INFIELD(pmx10)     #作業編號
                 CALL q_ecd(FALSE,TRUE,'') RETURNING g_pmx[l_ac].pmx10
                 SELECT ecd02 INTO g_pmx[l_ac].ecd02                                                                                
                   FROM ecd_file                                                                                                    
                  WHERE ecd01=g_pmx[l_ac].pmx10                                                                                     
                 IF STATUS=100 THEN                                                                                                 
                    LET g_pmx[l_ac].ecd02 = " "                                                                                     
                 END IF                                                                                                             
                 DISPLAY BY NAME g_pmx[l_ac].ecd02                                                                                  
                 DISPLAY BY NAME g_pmx[l_ac].pmx10
                 NEXT FIELD pmx10
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
    END INPUT
 
    LET g_pmw.pmwmodu = g_user
    LET g_pmw.pmwdate = g_today
    UPDATE pmw_file SET pmwmodu = g_pmw.pmwmodu,pmwdate = g_pmw.pmwdate
     WHERE pmw01 = g_pmw.pmw01
    DISPLAY BY NAME g_pmw.pmwmodu,g_pmw.pmwdate
 
    CLOSE i252_bcl
    COMMIT WORK
#   CALL i252_delall() #CHI-C30002 mark
    CALL i252_delHeader()     #CHI-C30002 add
 
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION i252_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
         DELETE FROM pmw_file WHERE pmw01 = g_pmw.pmw01
         INITIALIZE g_pmw.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#FUNCTION i252_delall()
#
#  SELECT COUNT(*) INTO g_cnt FROM pmx_file
#   WHERE pmx01 = g_pmw.pmw01
#
#  IF g_cnt = 0 THEN                   # 未輸入單身資料, 是否取消單頭資料
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM pmw_file WHERE pmw01 = g_pmw.pmw01
#  END IF
#
#END FUNCTION
#CHI-C30002 -------- mark -------- end
 
FUNCTION i252_pmx08(p_cmd)  #料件編號
   DEFINE l_ima02    LIKE ima_file.ima02,
          l_ima44    LIKE ima_file.ima44,
          l_ima021   LIKE ima_file.ima021,
          l_imaacti  LIKE ima_file.imaacti,
          p_cmd      LIKE type_file.chr1    
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima44,imaacti INTO l_ima02,l_ima021,l_ima44,l_imaacti
     FROM ima_file WHERE ima01 = g_pmx[l_ac].pmx08
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                           LET l_ima02 = NULL
                           LET l_ima44 = NULL
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd = 'a' THEN
      LET g_pmx[l_ac].pmx09 = l_ima44
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' OR g_pmx[l_ac].pmx08[1,4]='MISC' THEN #6808
      LET g_pmx[l_ac].pmx081 = l_ima02
      LET g_pmx[l_ac].pmx082 = l_ima021
      DISPLAY BY NAME g_pmx[l_ac].pmx081
      DISPLAY BY NAME g_pmx[l_ac].pmx082
   END IF
 
END FUNCTION
FUNCTION i252_pmx08_1(p_cmd,l_m)  #料件編號
   DEFINE l_ima02    LIKE ima_file.ima02,
          l_ima44    LIKE ima_file.ima44,
          l_ima021   LIKE ima_file.ima021,
          l_imaacti  LIKE ima_file.imaacti,
          p_cmd      LIKE type_file.chr1    
   DEFINE l_m        LIKE type_file.chr1000 
 
   LET g_errno = ' '
   SELECT ima02,ima021,ima44,imaacti INTO l_ima02,l_ima021,l_ima44,l_imaacti
     FROM ima_file WHERE ima01 = l_m
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                           LET l_ima02 = NULL
                           LET l_ima44 = NULL
        WHEN l_imaacti='N' LET g_errno = '9028'
        WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF p_cmd = 'a' THEN
      LET g_pmx[l_ac].pmx09 = l_ima44
   END IF
 
   IF cl_null(g_errno) OR p_cmd = 'd' OR g_pmx[l_ac].pmx08[1,4]='MISC' THEN #6808
      LET g_pmx[l_ac].pmx081 = l_ima02
      LET g_pmx[l_ac].pmx082 = l_ima021
      DISPLAY BY NAME g_pmx[l_ac].pmx081
      DISPLAY BY NAME g_pmx[l_ac].pmx082
   END IF
 
END FUNCTION
 
FUNCTION i252_pmx09()  #單位
   DEFINE l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = " "
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = g_pmx[l_ac].pmx09
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                            LET l_gfeacti = NULL
         WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
 
FUNCTION i252_b_askkey()
 
    DEFINE l_wc2           STRING
 
    CONSTRUCT l_wc2 ON pmx02,pmx12,pmx08,pmx09,ima44,ima908,pmx04,
                       pmx05,pmx03,pmx06,pmx06t,pmx07,pmx082,pmx13     #No.FUN-550019 #No.FUN-810017 add pmx13
            FROM s_pmx[1].pmx02,s_pmx[1].pmx08,s_pmx[1].pmx09,
                 s_pmx[1].ima44,s_pmx[1].ima908,
                 s_pmx[1].pmx04,s_pmx[1].pmx05,s_pmx[1].pmx03,
                 s_pmx[1].pmx06,s_pmx[1].pmx06t,                       #No.FUN-550019
                 s_pmx[1].pmx07,s_pmx[1].pmx082,s_pmx[1].pmx13         #No.FUN-550019 #No.FUN-810017
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
            WHEN INFIELD(pmx12) #廠商編號
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_pmc1"   #MOD-920024 q_pmc2-->q_pmc1
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO pmx12
              NEXT FIELD pmx12
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
       LET INT_FLAG = 0
       RETURN
    END IF
 
 
    CALL i252_b_fill(l_wc2)
 
END FUNCTION
 
FUNCTION i252_b_fill(p_wc2)
DEFINE p_wc2   STRING
DEFINE l_ima02    LIKE ima_file.ima02,
       l_ima44    LIKE ima_file.ima44,
       l_ima021   LIKE ima_file.ima021,
       l_imaacti  LIKE ima_file.imaacti
DEFINE  l_s      LIKE type_file.chr1000 
DEFINE  l_m      LIKE type_file.chr1000 
DEFINE  i        LIKE type_file.num5
 
   LET g_sql = "SELECT pmx02,pmx12,'',pmx08,pmx081,pmx082,pmx10,'',pmx13,pmx09,'    ','    ',pmx04,pmx05,pmx03,",#No.FUN-930061 add ''
               " pmx06,pmx06t,pmx07  FROM pmx_file",    #No.FUN-550019
               " WHERE pmx01 ='",g_pmw.pmw01,"' "   #單頭
 
   IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
   END IF
   LET g_sql=g_sql CLIPPED," ORDER BY pmx08,pmx02,pmx04 "
   DISPLAY g_sql
 
   PREPARE i252_pb FROM g_sql
   DECLARE pmx_cs CURSOR FOR i252_pb
 
   CALL g_pmx.clear()
   LET g_cnt = 1
 
   FOREACH pmx_cs INTO g_pmx[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
   
       SELECT pmc03 INTO g_pmx[g_cnt].pmc03 FROM pmc_file
        WHERE pmc01 = g_pmx[g_cnt].pmx12
       IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","pmc_file",g_pmx[g_cnt].pmc03,"",SQLCA.sqlcode,"","",0)  
         LET g_pmx[g_cnt].pmc03 = NULL
       END IF
 
      LET g_errno = ' '
      SELECT ima02,ima021,ima44,imaacti INTO l_ima02,l_ima021,l_ima44,l_imaacti
        FROM ima_file WHERE ima01 = g_pmx[g_cnt].pmx08
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3006'
                                      LET l_ima02 = NULL
                                      LET l_ima44 = NULL
             WHEN l_imaacti='N' LET g_errno = '9028'
             WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'   #No.FUN-690022
             OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        IF NOT cl_null(g_pmx[g_cnt].pmx10) THEN
           SELECT ecd02 INTO g_pmx[g_cnt].ecd02
             FROM ecd_file
            WHERE ecd01=g_pmx[g_cnt].pmx10
           DISPLAY BY NAME g_pmx[g_cnt].ecd02
        END IF
        LET l_m = ' '
        IF g_sma.sma120 = 'Y' THEN
          IF NOT cl_null(g_errno) THEN
             LET g_buf = g_pmx[g_cnt].pmx08
             LET l_s = g_buf.trim()
            FOR i=1 TO length(l_s)
                IF l_s[i,i] = '_' THEN
                   LET l_m = l_s[1,i-1]
                   EXIT FOR
                ELSE                                                                                                                            
                   CONTINUE FOR
                END IF
               IF l_s[i,i] = '-' THEN
                  LET l_m = l_s[1,i-1]
                  EXIT FOR
               ELSE                                                                                                                            
                 CONTINUE FOR
               END IF
               IF l_s[i,i] = ' ' THEN
                  LET l_m = l_s[1,i-1]
                  EXIT FOR
               ELSE                                                                                                                            
                 CONTINUE FOR
               END IF
            END FOR
          END IF 
        END IF
       IF NOT cl_null(l_m) THEN
          SELECT ima44,ima908 INTO g_pmx[g_cnt].ima44,g_pmx[g_cnt].ima908
            FROM ima_file
           WHERE ima01 = l_m
       ELSE
         SELECT ima44,ima908 INTO g_pmx[g_cnt].ima44,g_pmx[g_cnt].ima908
           FROM ima_file
          WHERE ima01 = g_pmx[g_cnt].pmx08
       END IF                            #No.FUN-830014
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH
   CALL g_pmx.deleteElement(g_cnt)
 
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i252_copy()
   DEFINE l_newno     LIKE pmw_file.pmw01,
          l_newdate   LIKE pmw_file.pmw06,
          l_oldno     LIKE pmw_file.pmw01
   DEFINE li_result   LIKE type_file.num5  
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_pmw.pmw01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   CALL i252_set_entry('a')
 
   CALL cl_set_head_visible("","YES")       
   INPUT l_newno,l_newdate FROM pmw01,pmw06
       BEFORE INPUT
          CALL cl_set_docno_format("pmw01")
 
       AFTER FIELD pmw01
           CALL s_check_no("apm",l_newno,"","6","pmw_file","pmw01","") RETURNING li_result,l_newno
           DISPLAY l_newno TO pmw01
           IF (NOT li_result) THEN
              LET g_pmw.pmw01 = g_pmw_o.pmw01
              NEXT FIELD pmw01
           END IF
           DISPLAY g_smy.smydesc TO smydesc           #單據名稱
 
       AFTER FIELD pmw06
           IF cl_null(l_newdate) THEN NEXT FIELD pmw06 END IF
           BEGIN WORK #No:7857
           CALL s_auto_assign_no("apm",l_newno,l_newdate,"","pmw_file","pmw01","","","") RETURNING li_result,l_newno
           IF (NOT li_result) THEN
              NEXT FIELD pmw01
           END IF
           DISPLAY l_newno TO pmw01
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(pmw01) #單據編號
                 LET g_t1=s_get_doc_no(l_newno)         #No.MOD-540182
                CALL q_smy(FALSE,FALSE,g_t1,'APM','6') RETURNING g_t1 #TQC-670008
                 LET l_newno=g_t1                       #No.MOD-540182
                DISPLAY BY NAME l_newno
                NEXT FIELD pmw01
              OTHERWISE EXIT CASE
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
 
#TQC-B60257   ---start   Add
     AFTER INPUT
       IF cl_null(l_newdate) AND NOT INT_FLAG THEN
          CALL cl_err('','afa-321',1)
          NEXT FIELD pmw06
       END IF
#TQC-B60257   ---end     Add
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DISPLAY BY NAME g_pmw.pmw01
      DISPLAY BY NAME g_pmw.pmw06 #TQC-AC0402
      ROLLBACK WORK
      RETURN
   END IF
 
   DROP TABLE y
 
   SELECT * FROM pmw_file         #單頭複製
       WHERE pmw01=g_pmw.pmw01
       INTO TEMP y
 
   UPDATE y
       SET pmw01=l_newno,    #新的鍵值
           pmw06=l_newdate,  #新的鍵值
           pmwuser=g_user,   #資料所有者
           pmwgrup=g_grup,   #資料所有者所屬群
           pmwmodu=NULL,     #資料修改日期
           pmwdate=g_today,  #資料建立日期
           pmwacti='Y'       #有效資料
 
   INSERT INTO pmw_file SELECT * FROM y
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmw_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      ROLLBACK WORK
      RETURN
   ELSE
      COMMIT WORK
   END IF
 
   DROP TABLE x
 
   SELECT * FROM pmx_file         #單身複製
       WHERE pmx01=g_pmw.pmw01
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","x","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      RETURN
   END IF
 
   UPDATE x SET pmx01=l_newno
 
   INSERT INTO pmx_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pmx_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129  #No.FUN-B80088---上移一行調整至回滾事務前---
      ROLLBACK WORK #No:7857
      RETURN
   ELSE
       COMMIT WORK #No:7857
   END IF
   LET g_cnt=SQLCA.SQLERRD[3]
   MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
   LET l_oldno = g_pmw.pmw01
   SELECT pmw_file.* INTO g_pmw.* FROM pmw_file WHERE pmw01 = l_newno
   CALL i252_u()
   CALL i252_b()
   #SELECT pmw_file.* INTO g_pmw.* FROM pmw_file WHERE pmw01 = l_oldno  #FUN-C80046
   #CALL i252_show()  #FUN-C80046
 
END FUNCTION

#FUN-B50018---mark----str----- 
#FUNCTION i252_out()
#DEFINE
#   l_i             LIKE type_file.num5, 
#   sr              RECORD
#       pmw01       LIKE pmw_file.pmw01,   #單據編號
#       pmx12       LIKE pmx_file.pmx12,   #廠商編號 #FUN-650191
#       pmc03       LIKE pmc_file.pmc03,   #廠商簡稱
#       pmw04       LIKE pmw_file.pmw04,   #交易幣別
#       pmw06       LIKE pmw_file.pmw06,   #詢價日期
#       pmwacti     LIKE pmw_file.pmwacti, #資料有效碼
#       pmx02       LIKE pmx_file.pmx02,   #項次
#       pmx08       LIKE pmx_file.pmx08,   #料件編號
#       pmx081      LIKE pmx_file.pmx081,  #品名
#       pmx082      LIKE pmx_file.pmx082,  #規格      #MOD-640052
#       pmx10       LIKE pmx_file.pmx10,   
#       ecd02       LIKE ecd_file.ecd02,   
#       pmx09       LIKE pmx_file.pmx09,   #詢價單位
#       pmx06       LIKE pmx_file.pmx06,   #採購價格
#       pmx03       LIKE pmx_file.pmx03,   #上限數量
#       pmx07       LIKE pmx_file.pmx07,   #折扣比率
#       pmx04       LIKE pmx_file.pmx04,   #生效日期
#       pmx05       LIKE pmx_file.pmx05,   #失效日期
#       pmw05       LIKE pmw_file.pmw05,   #稅別
#       pmw051      LIKE pmw_file.pmw051,  #稅率
#       pmx06t      LIKE pmx_file.pmx06t,  #含稅單價
#       gec07       LIKE gec_file.gec07    #含稅否
#      END RECORD,
#   l_name          LIKE type_file.chr20,  #External(Disk) file name  
#   l_za05          LIKE za_file.za05,    
#   l_azi03         LIKE azi_file.azi03,   
#   l_wc            STRING                
#
#   IF cl_null(g_pmw.pmw01) THEN
#      CALL cl_err('','9057',0) RETURN
#   END IF
#   IF cl_null(g_wc) THEN
#      LET g_wc =" pmw01='",g_pmw.pmw01,"'"       #TQC-760033 modify
#      LET g_wc2=" 1=1 AND pmx11='",g_pmx11,"'"   #TQC-760033 modify
#   END IF
#
#   CALL cl_wait()
#   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
#   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog   

#   CALL cl_del_data(l_table)
#   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,  
#              " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"   
#   PREPARE insert_prep FROM g_sql
#   IF STATUS THEN
#      CALL cl_err("insert_prep:",STATUS,1) 
#      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
#      EXIT PROGRAM
#   END IF
#   LET g_sql="SELECT distinct pmw01,pmx12,pmc03,pmw04,pmw06,pmwacti,",   #FUN-650191 pmw03->pmx12     #TQC-AC0100  add distinct
#         " pmx02,pmx08,pmx081,pmx082,pmx10,ecd02,pmx09,pmx06,pmx03,pmx07,pmx04,pmx05,", #MOD-640052  #No.FUN-670099 #No.FUN-930061 ADD ecd02
#         " pmw05,pmw051,pmx06t,gec07",
#         #FUN-A40073 mod--str
#         #" FROM pmw_file,pmx_file,OUTER pmc_file,OUTER gec_file,OUTER ecd_file",#No.FUN-930061 add ecd_file   #FUN-A40073 mark
#        #" FROM pmw_file LEFT OUTER JOIN gec_file ON pmw05=gec01,pmx_file LEFT OUTER JOIN pmc_file ON pmx12=pmc01 ",  #FUN-A40073 mod
#         " FROM pmw_file LEFT OUTER JOIN gec_file ON pmw05=gec01 AND gec011='1',pmx_file LEFT OUTER JOIN pmc_file ON pmx12=pmc01 ",  #FUN-A40073 mod  #Mod No.TQC-B10029
#         " LEFT OUTER JOIN ecd_file ON pmx10=ecd01 ",       #FUN-A40073 mod
#         #" WHERE pmx01 = pmw01 AND pmx_file.pmx12=pmc_file.pmc01 AND ",g_wc CLIPPED, #FUN-650191  
#         #"   AND pmx10 = ecd_file.ecd02 AND ",                              #FUN-930061
#         #"   AND pmx10 = ecd_file.ecd01 ",          #FUN-A40073 ecd02-->ecd01                    #FUN-930061
#         #"   AND pmw_file.pmw05 = gec_file.gec01 AND ",g_wc2 CLIPPED
#         " WHERE pmx01 = pmw01 AND ",g_wc CLIPPED,"AND ",g_wc2 CLIPPED   #FUN-A40073 add
#         #FUN-A400073 mod --end
#   LET g_sql = g_sql CLIPPED," ORDER BY pmw01,pmx02"  #No.FUN-710091
#   PREPARE i252_p1 FROM g_sql                # RUNTIME 編譯
#   IF STATUS THEN CALL cl_err('i252_p1',STATUS,0) END IF
#
#   DECLARE i252_co                         # CURSOR
#       CURSOR FOR i252_p1
#
#
#   FOREACH i252_co INTO sr.*
#       IF SQLCA.sqlcode THEN
#           CALL cl_err('foreach:',SQLCA.sqlcode,1)
#           EXIT FOREACH
#           END IF
#       SELECT azi03 INTO l_azi03 FROM azi_file WHERE azi01=sr.pmw04
#       EXECUTE insert_prep USING sr.*,l_azi03  #No.FUN-710091 
#   END FOREACH
#   IF g_zz05 = 'Y' THEN
#      CALL cl_wcchp(g_wc,'pmw01,pmw06,pmw04,pmw05,pmw051,pmwuser,pmwgrup,pmwmodu,pmwdate,pmwacti')                 
#           RETURNING l_wc
#   ELSE
#      LET l_wc = ' '
#   END IF
#   LET g_str = l_wc CLIPPED ,";",g_prog CLIPPED        #TQC-760033  #MOD-7C0150
#   LET g_sql ="SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
#   LET g_prog="apmi252"   #MOD-7C0150
#   CALL cl_prt_cs3('apmi252','apmi252',g_sql,g_str)
#    IF g_pmx11 = "2" THEN
#       LET g_prog="apmi262"
#    END IF 
#
#
#   CLOSE i252_co
#   ERROR ""
#END FUNCTION
#FUN-B50018---mark-----end-------


#FUN-B50018---add-----str---
FUNCTION i252_out()
DEFINE l_cmd        LIKE type_file.chr1000,
       l_wc         LIKE type_file.chr1000,
       l_prtway     LIKE type_file.chr1

    CALL cl_wait()

    LET l_wc = 'pmw01="',g_pmw.pmw01,'"'


    SELECT zz22 INTO l_prtway FROM zz_file WHERE zz01 = 'apmr252'
    LET l_cmd = "apmr252",
                " '",g_today,"' '' '",g_lang,"' 'Y' '",l_prtway,"' '1' '",l_wc CLIPPED,"'"
    CALL cl_cmdrun_wait(l_cmd)

    ERROR ' '
END FUNCTION
#FUN-B50018---add-----end---
 
FUNCTION i252_set_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1  
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("pmw01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION i252_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1    
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("pmw01",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION i252_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
   #IF INFIELD(pmx08) THEN   #MOD-C80179 mark
       CALL cl_set_comp_entry("pmx081,pmx082,pmx06,pmx06t",TRUE)    #No.FUN-550019
   #END IF                   #MOD-C80179 mark
    CALL cl_set_comp_entry("pmx06,pmx06t",TRUE)    #No.FUN-610018
 
END FUNCTION
 
FUNCTION i252_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   
 
   #IF INFIELD(pmx08) THEN   #MOD-C80179 mark
       IF g_pmx[l_ac].pmx08[1,4] <> 'MISC' THEN
          CALL cl_set_comp_entry("pmx081,pmx082",FALSE)
       END IF
   #END IF                   #MOD-C80179 mark
 
    IF g_gec07 = 'N' THEN           #No.FUN-560102
       CALL cl_set_comp_entry("pmx06t",FALSE)
    ELSE
       CALL cl_set_comp_entry("pmx06",FALSE)
    END IF
 
END FUNCTION
#No:FUN-9C0071--------精簡程式-----
#Patch....NO.TQC-610037 <> #
#FUN-B50018
#FUN-910088--add--start--
FUNCTION i252_pmx03_check(p_cmd)
   DEFINE p_cmd LIKE type_file.chr1,
          l_cnt LIKE type_file.num5
   IF NOT cl_null(g_pmx[l_ac].pmx09) AND NOT cl_null(g_pmx[l_ac].pmx03) THEN
      IF cl_null(g_pmx09_t) OR cl_null(g_pmx_t.pmx03) OR g_pmx09_t != g_pmx[l_ac].pmx09 OR g_pmx_t.pmx03 != g_pmx[l_ac].pmx03 THEN
         LET g_pmx[l_ac].pmx03 = s_digqty(g_pmx[l_ac].pmx03,g_pmx[l_ac].pmx09)
         DISPLAY BY NAME g_pmx[l_ac].pmx03
      END IF
   END IF
   IF NOT cl_null(g_pmx[l_ac].pmx03) THEN
      IF g_pmx[l_ac].pmx03 < 0 THEN
         CALL cl_err(g_pmx[l_ac].pmx03,'mfg5034',0)
         LET g_pmx[l_ac].pmx03 = g_pmx_o.pmx03
         DISPLAY BY NAME g_pmx[l_ac].pmx03
         RETURN "pmx03"
      END IF
      IF p_cmd = 'a' THEN
         IF NOT cl_null(g_pmx[l_ac].pmx05) THEN
            SELECT COUNT(*) INTO l_cnt FROM pmx_file
             WHERE( (g_pmx[l_ac].pmx04 <= pmx04
               AND g_pmx[l_ac].pmx05 >= pmx04)
                OR (g_pmx[l_ac].pmx04 <= pmx05
               AND g_pmx[l_ac].pmx05 >= pmx05)
                OR (g_pmx[l_ac].pmx04 >= pmx04
               AND g_pmx[l_ac].pmx05 <= pmx05)
                OR (g_pmx[l_ac].pmx04 <= pmx04
               AND g_pmx[l_ac].pmx05 >= pmx05)
                OR (pmx05 IS NULL AND pmx04 <= g_pmx[l_ac].pmx05))
               AND pmx08 = g_pmx[l_ac].pmx08
               AND pmx09 = g_pmx[l_ac].pmx09
               AND pmx03 = g_pmx[l_ac].pmx03
               AND pmx01 = g_pmw.pmw01
               AND pmx08[1,4] <> 'MISC'         
               AND pmx11 =  g_pmx11  
               AND pmx12 = g_pmx[l_ac].pmx12   
         END IF
         IF g_pmx[l_ac].pmx05 IS NULL THEN
            SELECT COUNT(*) INTO l_cnt FROM pmx_file
             WHERE ((g_pmx[l_ac].pmx04 <= pmx05)
                OR (pmx05 IS NULL))
               AND pmx08 = g_pmx[l_ac].pmx08
               AND pmx09 = g_pmx[l_ac].pmx09
               AND pmx03 = g_pmx[l_ac].pmx03
               AND pmx01 = g_pmw.pmw01
               AND pmx08[1,4] <> 'MISC'              
               AND pmx11 =  g_pmx11  
               AND pmx10 =  g_pmx[l_ac].pmx10  
               AND pmx12 = g_pmx[l_ac].pmx12   
         END IF
         IF l_cnt > 0 THEN
            CALL cl_err('','mfg3287',0)
            RETURN "pmx04"
         END IF
      END IF
      IF p_cmd = 'u' THEN
         IF g_pmx[l_ac].pmx05 IS NOT NULL THEN
            SELECT COUNT(*) INTO l_cnt FROM pmx_file
             WHERE( (g_pmx[l_ac].pmx04 <= pmx04
               AND g_pmx[l_ac].pmx05 >= pmx04)
                OR (g_pmx[l_ac].pmx04 <= pmx05
               AND g_pmx[l_ac].pmx05 >= pmx05)
                OR (g_pmx[l_ac].pmx04 >= pmx04
               AND g_pmx[l_ac].pmx05 <= pmx05)
                OR (g_pmx[l_ac].pmx04 <= pmx04
               AND g_pmx[l_ac].pmx05 >= pmx05)
                OR (pmx05 IS NULL AND pmx04 <= g_pmx[l_ac].pmx05))
               AND pmx08 = g_pmx[l_ac].pmx08
               AND pmx09 = g_pmx[l_ac].pmx09
               AND pmx03 = g_pmx[l_ac].pmx03
               AND pmx02 != g_pmx[l_ac].pmx02
               AND pmx01 = g_pmw.pmw01
               AND pmx11 =  g_pmx11  
               AND pmx12 = g_pmx[l_ac].pmx12   
         END IF
         IF g_pmx[l_ac].pmx05 IS NULL THEN
            SELECT COUNT(*) INTO l_cnt FROM pmx_file
             WHERE ((g_pmx[l_ac].pmx04 <= pmx05)
                OR (pmx05 IS NULL))
               AND pmx08 = g_pmx[l_ac].pmx08
               AND pmx09 = g_pmx[l_ac].pmx09
               AND pmx03 = g_pmx[l_ac].pmx03
               AND pmx02 != g_pmx[l_ac].pmx02
               AND pmx01 = g_pmw.pmw01
               AND pmx11 =  g_pmx11  #No.FUN-670099
               AND pmx10 =  g_pmx[l_ac].pmx10 
               AND pmx12 =  g_pmx[l_ac].pmx12  
         END IF
         IF l_cnt > 0 THEN
            CALL cl_err('','mfg3287',0)
            RETURN "pmx04"
         END IF
      END IF
      LET g_pmx_o.pmx03 = g_pmx[l_ac].pmx03
   END IF
   RETURN ""
END FUNCTION
#FUN-910088--add--end--

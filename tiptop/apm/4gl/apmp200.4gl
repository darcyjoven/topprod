# Prog. Version..: '5.30.06-13.04.22(00010)'     #
# 
# Pattern name...: apmp200.4gl
# Descriptions...: 請購單整批處理作業
# Date & Author..: No.TQC-730022 07/03/13 By rainy
# Modify.........: No.CHI-740022 07/04/25 By rainy 單身數量數量-已轉數量=0的不要轉入採購單
# Modify.........: No.TQC-740226 07/04/26 By rainy 請購單頭若無供應商，單身任一料無設定主供應商則整張不拋轉
# Modify.........: No.FUN-740034 07/05/14 By kim 確認過帳不使用rowid,改用單號
# Modify.........: No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.........: No.TQC-790169 07/09/29 By claire MOD-730044 s_defprice 參數加上單位
# Modify.........: No.MOD-810181 08/01/22 By ve007 s_defprice()增加一個參數
# Modify.........: No.MOD-810197 08/01/24 By claire 請購轉採購單未考慮回寫請購單身的已轉採購量
# Modify.........: No.FUN-810045 08/02/14 By rainy  拋轉採購單將項目相關欄位帶入
# Modify.........: No.FUN-830132 08/03/28 By hellen 行業別表拆分INSERT/DELETE
# Modify.........: No.FUN-840006 08/04/07 By hellen 項目管理，去掉預算編號相關欄位 pml66,pmn66,pmm06,pmk06
# Modify.........: No.MOD-850242 08/05/26 By Smapmin 匯總時未傳入備註/重要說明
# Modify.........: No.MOD-860116 08/06/14 By Smapmin 預設採購所屬會計年度/期別
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-880020 08/09/10 By xiaofeizhu 判斷若請購單上有指定供應商，則依請購單上的供應商，若無則依料件主檔上的主要供應商來匯總
# Modify.........: No.MOD-860242 08/06/20 By chenl   將g_msg定義為String，防止超過範圍的情況發生。
# Modify.........: No.CHI-890026 08/10/06 By Smapmin 依照稅別含稅否重新計算含稅/未稅金額
# Modify.........: No.MOD-8A0271 08/11/05 By Smapmin 特別說明拋轉到採購單時會亂掉
# Modify.........: No.MOD-8B0273 08/11/26 By chenyu 采購單單頭單價含稅時，單身的未稅單價=未稅金額/數量
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-920077 09/02/06 By Smapmin 變數定義錯誤
# Modify.........: No.MOD-920208 09/02/17 By Smapmin 料號為MISC時,pmn09 default為1
# Modify.........: No.MOD-920297 09/02/24 By Smapmin 採購單別需簽核,簽核卻未打勾
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.FUN-930113 09/04/02 By mike oah-->pnz
# Modify.........: No.FUN-940083 09/05/05 By douzh 新增VIM管理否欄位判斷
# Modify.........: No.MOD-960185 09/07/08 By Smapmin 雙單位畫面調整
# Modify.........: No.MOD-960191 09/07/08 By Smapmin pmk10有可能為一個空白
# Modify.........: No.CHI-970009 09/07/06 By mike 若為MISC 則應保持原請購單位     
# Modify.........: No.FUN-960130 09/08/14 By Sunyanchun 流通零售欄位給默認值
# Modify.........: No.FUN-980006 09/08/21 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.TQC-980279 09/08/28 By sherry 請購的料號若為統購的，不可以拋采購單   
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990146 09/09/16 By mike 采購單的會計年度/期別已由采購日期來決定.故pmk31/pmk32也不需要再參考.              
# Modify.........: No.FUN-9A0068 09/10/29 By destiny 修正VMI管理否的抓值设定
# Modify.........: No:FUN-9A0065 09/11/02 By baofei 請購單轉採購時，需排除"電子採購否(pml92)"='Y'的資料
# Modify.........: No.FUN-9B0016 09/11/08 By Sunyanchun post no
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:FUN-A10034 10/01/08 By chenmoyan  修改單身中pml92='N'時，可以拋轉，反之，不可拋轉
# Modify.........: No:FUN-9C0071 10/01/13 By huangrh 精簡程式
# Modify.........: No:TQC-A70004 10/07/01 By yinhy INSERT INTO pmn_file時，pmn012為空則給‘ ’ 
# Modify.........: No:FUN-A80150 10/09/14 By sabrina GP5.2號機管理
# Modify.........: No.TQC-AB0038 10/11/09 By vealxu sybase err
# Modify.........: No.MOD-AC0194 10/12/18 By huangtao 轉採時，供應商取取順序為 請購單->採購策略->料件主檔
# Modify.........: No.MOD-AC0193 10/12/21 By huangtao 轉採購時，應判斷料號在採購策略的採購類型為：自行訂
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No.TQC-B10137 11/01/14 By huangtao 拋轉採購單時根據請購單的經營狀態分類
# Modify.........: No.TQC-B10172 11/01/18 By lilingyu 未審核的資料,拋轉採購單時增加對應的提示訊息
# Modify.........: No.TQC-B10160 11/01/18 By lilingyu  拋轉採購單時,錄入的採購單日期沒有控管大於等於請購日期
# Modify.........: No.TQC-B10122 11/01/19 By lilingyu  請購單單身已經結案的項次資料,不可再轉成採購單 
# Modify.........: No:FUN-B40098 11/04/29 By shiwuying 扣率代銷時，倉庫取arti200中設置的非成本倉rtz08
# Modify.........: No:FUN-B60150 11/06/28 By shiwuying 成本代銷(sma16='2')，倉庫取arti200中設置的非成本倉rtz08
# Modify.........: No:MOD-B90134 11/09/16 By suncx 單身未全部轉採購的亦可整批轉採購單
# Modify.........: No:FUN-BB0086 11/11/21 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-BB0085 11/11/22 By xianghui 增加數量欄位小數取位(pmn_file)
# Modify.........: No:TQC-BB0212 11/11/24 By suncx MOD-B90134完善
# Modify.........: No:TQC-BC0021 12/01/20 By SunLM 修正批量轉採購單時候,採購數量和金額不准的問題
#                                                  (針對已經部份轉過採購單的請購單出現的問題)
# Modify.........: No:TQC-BC0135 12/01/20 By SunLM 對pmn69賦初值''
# Modify.........: No:FUN-C10002 12/02/01 By bart 作業編號pmn78帶預設值
# Modify.........: No:FUN-C30056 12/03/14 By xjll 服飾行業下右邊的action都未串連到_slk的程式
# Modify.........: No:TQC-C40197 12/04/25 by qiaozy 轉採購單功能BUG修改
# Modify.........: No:TQC-C40248 12/04/27 By qiaozy 點擊右上角的叉程序不能退出
# Modify.........: No:TQC-C50067 12/05/09 By zhuhao 請購單位傳值修改
# Modify.........: No:MOD-C50239 12/06/15 By Vampire p200_carry_po()中撈pml_file資料時,加上pml16結案條件
# Modify.........: No:MOD-C70184 12/07/17 By Elise 查詢資料時,action被關掉了
# Modify.........: No:MOD-C80238 12/08/30 By Vampire 因請購人員和採購人員確認的人不一樣，點選右邊action拋轉採購單時，建議不要預帶pmk15給pmm15
# Modify.........: No:MOD-C90083 12/09/20 By jt_chen 拋轉採購單,採購員與採購部門調整為g_user、g_grup
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:MOD-D40002 13/04/02 By Vampire 在產生採購單身時會判斷 請購數量(pml20) - 已轉採數量(pml21) <= 0 就不產生單身，新增採購單頭時也需要此判斷
# Modify.........: No:FUN-D40042 13/04/15 By fengrui 請購單轉採購時，請購單備註pml06帶入採購單備註pmn100

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_renew   LIKE type_file.num5       #NO.FUN-9B0016 
DEFINE g_pmk1   DYNAMIC ARRAY OF RECORD
                  a         LIKE type_file.chr1,   #選擇
                  pmk04     LIKE pmk_file.pmk04,    
                  pmk01     LIKE pmk_file.pmk01,  
                  pmk03     LIKE pmk_file.pmk03,  
                  pmk02     LIKE pmk_file.pmk02,
                  pmk09     LIKE pmk_file.pmk09,
                  pmc03     LIKE pmc_file.pmc03,
                  pmk22     LIKE pmk_file.pmk22,
                  pmk21     LIKE pmk_file.pmk21,
                  pmk41     LIKE pmk_file.pmk41,
                  pmk20     LIKE pmk_file.pmk20,
                  pmk12     LIKE pmk_file.pmk12,
                  gen02     LIKE gen_file.gen02, 
                  pmk13     LIKE pmk_file.pmk13,
                  gem02     LIKE gem_file.gem02, 
                  pmk18     LIKE pmk_file.pmk18,
                  pmk25     LIKE pmk_file.pmk25
               END RECORD,
       g_pmk1_t RECORD
                  a         LIKE type_file.chr1,   #選擇
                  pmk04     LIKE pmk_file.pmk04,    
                  pmk01     LIKE pmk_file.pmk01,  
                  pmk03     LIKE pmk_file.pmk03,  
                  pmk02     LIKE pmk_file.pmk02,
                  pmk09     LIKE pmk_file.pmk09,
                  pmc03     LIKE pmc_file.pmc03,
                  pmk22     LIKE pmk_file.pmk22,
                  pmk21     LIKE pmk_file.pmk21,
                  pmk41     LIKE pmk_file.pmk41,
                  pmk20     LIKE pmk_file.pmk20,
                  pmk12     LIKE pmk_file.pmk12,
                  gen02     LIKE gen_file.gen02, 
                  pmk13     LIKE pmk_file.pmk13,
                  gem02     LIKE gem_file.gem02, 
                  pmk18     LIKE pmk_file.pmk18,
                  pmk25     LIKE pmk_file.pmk25
               END RECORD,
 
       g_pml1   DYNAMIC ARRAY OF RECORD
                  pml02    LIKE pml_file.pml02,  #項次
                  pml24    LIKE pml_file.pml24,  #來源單號   
                  pml25    LIKE pml_file.pml25,  #來源項次   
                  pml04    LIKE pml_file.pml04,  #料件編號
                  att00     LIKE imx_file.imx00,  
                  att01     LIKE imx_file.imx01,  
                  att01_c   LIKE imx_file.imx01,  
                  att02     LIKE imx_file.imx02,  
                  att02_c   LIKE imx_file.imx02,  
                  att03     LIKE imx_file.imx03,  
                  att03_c   LIKE imx_file.imx03,  
                  att04     LIKE imx_file.imx04,  
                  att04_c   LIKE imx_file.imx04,  
                  att05     LIKE imx_file.imx05,  
                  att05_c   LIKE imx_file.imx05,  
                  att06     LIKE imx_file.imx06,  
                  att06_c   LIKE imx_file.imx06,  
                  att07     LIKE imx_file.imx07,  
                  att07_c   LIKE imx_file.imx07,  
                  att08     LIKE imx_file.imx08,  
                  att08_c   LIKE imx_file.imx08,  
                  att09     LIKE imx_file.imx09,  
                  att09_c   LIKE imx_file.imx09,  
                  att10     LIKE imx_file.imx10,  
                  att10_c   LIKE imx_file.imx10,  
                  pml041   LIKE pml_file.pml041, #品名
                  ima021   LIKE ima_file.ima021, #規格
                  pml07    LIKE pml_file.pml07,  #單位
                  pml20    LIKE pml_file.pml20,  #請購量
                  pml83    LIKE pml_file.pml83,  #單位二
                  pml84    LIKE pml_file.pml84,  #轉換率二
                  pml85    LIKE pml_file.pml85,  #單位二數量
                  pml80    LIKE pml_file.pml80,  #單位一
                  pml81    LIKE pml_file.pml81,  #轉換率一
                  pml82    LIKE pml_file.pml82,  #單位一數量
                  pml86    LIKE pml_file.pml86,  #計價單位
                  pml87    LIKE pml_file.pml87,  #計價數量
                  pml21    LIKE pml_file.pml21,  #轉購量
                  pml35    LIKE pml_file.pml35,  #入庫日期   
                  pml34    LIKE pml_file.pml34,  #到廠日期   
                  pml33    LIKE pml_file.pml33,  #交貨日期   
                  pml919   LIKE pml_file.pml919, #計畫批號    #FUN-A80150 add
                  pml41    LIKE pml_file.pml41,  #PLT-NO
                  pml190   LIKE pml_file.pml190, 
                  pml191   LIKE pml_file.pml191, 
                  pml192   LIKE pml_file.pml192, 
                  pml12    LIKE pml_file.pml12,  #專案代號
                  pml121   LIKE pml_file.pml121, #專案代號-順序
                  pml122   LIKE pml_file.pml122, #專案代號-項次
                  pml930   LIKE pml_file.pml930, #成本中心 
                  gem02a   LIKE gem_file.gem02,  #成本中心簡稱
                  pml06    LIKE pml_file.pml06,  #備註
                  pml38    LIKE pml_file.pml38,  #可用/不可用   
                  pml11    LIKE pml_file.pml11   #凍結碼`  
               END RECORD,
 
       g_pml1_t RECORD
                  pml02    LIKE pml_file.pml02,  #項次
                  pml24    LIKE pml_file.pml24,  #來源單號   
                  pml25    LIKE pml_file.pml25,  #來源項次   
                  pml04    LIKE pml_file.pml04,  #料件編號
                  att00     LIKE imx_file.imx00,  
                  att01     LIKE imx_file.imx01,  
                  att01_c   LIKE imx_file.imx01,  
                  att02     LIKE imx_file.imx02,  
                  att02_c   LIKE imx_file.imx02,  
                  att03     LIKE imx_file.imx03,  
                  att03_c   LIKE imx_file.imx03,  
                  att04     LIKE imx_file.imx04,  
                  att04_c   LIKE imx_file.imx04,  
                  att05     LIKE imx_file.imx05,  
                  att05_c   LIKE imx_file.imx05,  
                  att06     LIKE imx_file.imx06,  
                  att06_c   LIKE imx_file.imx06,  
                  att07     LIKE imx_file.imx07,  
                  att07_c   LIKE imx_file.imx07,  
                  att08     LIKE imx_file.imx08,  
                  att08_c   LIKE imx_file.imx08,  
                  att09     LIKE imx_file.imx09,  
                  att09_c   LIKE imx_file.imx09,  
                  att10     LIKE imx_file.imx10,  
                  att10_c   LIKE imx_file.imx10,  
                  pml041   LIKE pml_file.pml041, #品名
                  ima021   LIKE ima_file.ima021, #規格
                  pml07    LIKE pml_file.pml07,  #單位
                  pml20    LIKE pml_file.pml20,  #請購量
                  pml83    LIKE pml_file.pml83,  #單位二
                  pml84    LIKE pml_file.pml84,  #轉換率二
                  pml85    LIKE pml_file.pml85,  #單位二數量
                  pml80    LIKE pml_file.pml80,  #單位一
                  pml81    LIKE pml_file.pml81,  #轉換率一
                  pml82    LIKE pml_file.pml82,  #單位一數量
                  pml86    LIKE pml_file.pml86,  #計價單位
                  pml87    LIKE pml_file.pml87,  #計價數量
                  pml21    LIKE pml_file.pml21,  #轉購量
                  pml35    LIKE pml_file.pml35,  #入庫日期   
                  pml34    LIKE pml_file.pml34,  #到廠日期   
                  pml33    LIKE pml_file.pml33,  #交貨日期   
                  pml919   LIKE pml_file.pml919, #計畫批號    #FUN-A80150 add
                  pml41    LIKE pml_file.pml41,  #PLT-NO
                  pml190   LIKE pml_file.pml190, 
                  pml191   LIKE pml_file.pml191, 
                  pml192   LIKE pml_file.pml192, 
                  pml12    LIKE pml_file.pml12,  #專案代號
                  pml121   LIKE pml_file.pml121, #專案代號-順序
                  pml122   LIKE pml_file.pml122, #專案代號-項次
                  pml930   LIKE pml_file.pml930, #成本中心 
                  gem02a   LIKE gem_file.gem02,  #成本中心簡稱
                  pml06    LIKE pml_file.pml06,  #備註
                  pml38    LIKE pml_file.pml38,  #可用/不可用   
                  pml11    LIKE pml_file.pml11   #凍結碼`  
               END RECORD,
       g_pmk RECORD       LIKE pmk_file.*,
       g_pml RECORD       LIKE pml_file.*,
       g_pmm RECORD       LIKE pmm_file.*,       #採購單頭
       g_pmn RECORD       LIKE pmn_file.*,       #採購單身
       begin_no,end_no     LIKE oga_file.oga01,
       lr_agc        DYNAMIC ARRAY OF RECORD LIKE agc_file.*,
       g_wc2,g_sql,g_ws1,g_ws2    STRING,
       g_wc_pmk       STRING,
       g_rec_b        LIKE type_file.num5,         
       g_rec_b1       LIKE type_file.num5,         
       l_ac1          LIKE type_file.num5,         
       l_ac1_t        LIKE type_file.num5,         
       l_ac           LIKE type_file.num5          
DEFINE lg_group      LIKE oay_file.oay22   #當前單身中采用的組別
DEFINE lg_smy62      LIKE smy_file.smy62   #在smy_file中定義的與當前單別關聯的組別   
DEFINE p_row,p_col    LIKE type_file.num5          
DEFINE g_cnt          LIKE type_file.num10         
DEFINE g_forupd_sql   STRING
DEFINE g_before_input_done STRING
DEFINE li_result      LIKE type_file.num5          
DEFINE g_msg          STRING                         #No.MOD-860242
DEFINE mi_need_cons     LIKE type_file.num5
DEFINE g_dbs2          LIKE type_file.chr30   #TQC-680074
DEFINE tm RECORD			      #
          slip         LIKE oay_file.oayslip, #單據別
          dt           LIKE oeb_file.oeb16,   #出通/出貨日期
          g            LIKE type_file.chr1    #匯總方式
      END RECORD,
      g_gfa  RECORD    LIKE gfa_file.*
DEFINE t_aza41   LIKE type_file.num5        #單別位數 (by aza41)
DEFINE g_ima54   LIKE ima_file.ima54        #CHI-880020
DEFINE g_count   LIKE type_file.num5        #CHI-880020
DEFINE g_wc_pml       STRING                #CHI-880020
DEFINE g_wc_pmk09     STRING                #CHI-880020
DEFINE g_rty05   LIKE rty_file.rty05      #MOD-AC0194
DEFINE g_pml48    LIKE pml_file.pml48     #MOD-AC0194 
DEFINE g_pml49    LIKE pml_file.pml49      #TQC-B10137

MAIN
 
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p200_w AT p_row,p_col WITH FORM "apm/42f/apmp200"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
   CALL p200_def_form()    #MOD-960185
   CALL p200_init() 
   LET mi_need_cons = 1  #讓畫面一開始進去就停在查詢
   LET g_renew = 1
   CALL p200()
 
   CLOSE WINDOW p200_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
 
END MAIN
 
FUNCTION p200()
 
   CLEAR FORM
   WHILE TRUE
      IF (mi_need_cons) THEN
         LET mi_need_cons = 0
         CALL p200_q()
      END IF
      CALL p200_p1()
      IF INT_FLAG THEN EXIT WHILE END IF 
      CASE g_action_choice
         WHEN "select_all"   #全部選取
           CALL p200_sel_all('Y')
 
         WHEN "select_non"   #全部不選
           CALL p200_sel_all('N')
 
         WHEN "pr_detail" #訂單明細
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
#FUN-C30056---modify-----begin-------------------
              IF s_industry("slk") THEN  
                 LET g_msg = " apmt420_slk '", g_pmk1_t.pmk01,"'"
              ELSE
                 LET g_msg = " apmt420 '", g_pmk1_t.pmk01,"'"
              END IF  
#FUN-C30056----------end-------------------------
              CALL cl_cmdrun_wait(g_msg CLIPPED)
           END IF
 
         WHEN "batch_confirm" #整批確認
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
              CALL p200_batch_confirm()
           END IF
 
         WHEN "carry_po"      #轉採購單
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p200_carry_po()
           END IF
 
         WHEN "po_dist"       #轉採購分配
           LET g_renew = 0
           IF cl_chk_act_auth() THEN
             CALL p200_po_dist()
           END IF
 
         WHEN "exporttoexcel" #匯出excel
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pmk1),'','')
            END IF
     
         WHEN "exit"
           EXIT WHILE
      END CASE
   END WHILE
END FUNCTION
 
 
 
 
FUNCTION p200_p1()
      LET g_action_choice = " "
      CALL cl_set_act_visible("accept,cancel", FALSE)
 
      INPUT ARRAY g_pmk1 WITHOUT DEFAULTS FROM s_pmk.*  #顯示並進行選擇
        ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW = FALSE,DELETE ROW = FALSE,APPEND ROW= FALSE)
 
         BEFORE ROW
             IF g_renew THEN
               LET l_ac1 = ARR_CURR()
               IF l_ac1 = 0 THEN
                  LET l_ac1 = 1
               END IF
             END IF
             CALL fgl_set_arr_curr(l_ac1)
             LET g_renew = 1
             CALL cl_show_fld_cont()
             LET l_ac1_t = l_ac1
             LET g_pmk1_t.* = g_pmk1[l_ac1].*
 
             IF g_rec_b1 > 0 THEN
               CALL p200_b_fill()
               CALL p200_bp2('')
               CALL cl_set_act_visible("select_all,select_non,pr_detail,batch_confirm,carry_po,po_dist", TRUE)
             ELSE
               CALL cl_set_act_visible("select_all,select_non,pr_detail,batch_confirm,carry_po,po_dist", FALSE)
             END IF
 
         ON CHANGE a
            IF cl_null(g_pmk1[l_ac1].a) THEN 
               LET g_pmk1[l_ac1].a = 'Y'
            END IF
#TQC-C40248----ADD----STR------
         ON ACTION close
            LET g_action_choice ="exit"
            EXIT INPUT
#TQC-C40248----ADD---END-------
 
         ON ACTION query
            LET mi_need_cons = 1
            EXIT INPUT
 
         ON ACTION select_all   #全部選取
            LET g_action_choice="select_all"
            EXIT INPUT
 
         ON ACTION select_non   #全部不選
            LET g_action_choice="select_non"
            EXIT INPUT
 
         ON ACTION pr_detail #請購單明細
            LET g_action_choice="pr_detail"
            EXIT INPUT
 
         ON ACTION batch_confirm #整批確認
            LET g_action_choice="batch_confirm"
            EXIT INPUT
 
         ON ACTION carry_po      #轉採購單
            LET g_action_choice="carry_po"
            EXIT INPUT
 
         ON ACTION po_dist       #轉採購分配
            LET g_action_choice="po_dist"
            EXIT INPUT
 
         ON ACTION view
            CALL p200_bp2('V')
 
         ON ACTION exporttoexcel
            LET g_action_choice = "exporttoexcel"
            EXIT INPUT     
 
         ON ACTION help
            CALL cl_show_help()
            EXIT INPUT
 
         ON ACTION controlg
            CALL cl_cmdask()
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            CALL p200_def_form()    #MOD-960185
 
         ON ACTION exit
            LET g_action_choice="exit"
            EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
      END INPUT
      CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p200_q()
   CALL p200_b_askkey()
END FUNCTION
 
FUNCTION p200_b_askkey()
   CLEAR FORM
   CALL g_pmk1.clear()
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
   CONSTRUCT g_wc2 ON pmk04,pmk01,pmk03,pmk02,pmk09,pmk22,pmk21,
                      pmk41,pmk20,pmk12,pmk13,pmk18,pmk25
                 FROM s_pmk[1].pmk04,s_pmk[1].pmk01,s_pmk[1].pmk03,
                      s_pmk[1].pmk02,s_pmk[1].pmk09,s_pmk[1].pmk22,
                      s_pmk[1].pmk21,s_pmk[1].pmk41,s_pmk[1].pmk20,
                      s_pmk[1].pmk12,s_pmk[1].pmk13,s_pmk[1].pmk18,
                      s_pmk[1].pmk25 
                      
 
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmk01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmk3"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk01
                    NEXT FIELD pmk01
               WHEN INFIELD(pmk09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk09
                    NEXT FIELD pmk09
               WHEN INFIELD(pmk22)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azi"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk22
                    NEXT FIELD pmk22
               WHEN INFIELD(pmk21)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gec"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk21
                    NEXT FIELD pmk21
               WHEN INFIELD(pmk41)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pnz01" #FUN-930113    
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk41
                    NEXT FIELD pmk41
               WHEN INFIELD(pmk20)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pma"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk20
                    NEXT FIELD pmk20
               WHEN INFIELD(pmk12)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gen"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk12
                    NEXT FIELD pmk12
               WHEN INFIELD(pmk13)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_gem"
                    LET g_qryparam.state = 'c'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO pmk13
                    NEXT FIELD pmk13
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about
         CALL cl_about()

      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON ACTION qbe_select
         CALL cl_qbe_select()
      ON ACTION qbe_save
         CALL cl_qbe_save()
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup') #FUN-980030
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   CALL p200_b1_fill(g_wc2)
 
   LET l_ac1 = 1
   LET g_pmk1_t.* = g_pmk1[l_ac1].*
 
   CALL p200_b_fill()
END FUNCTION
 
FUNCTION p200_b1_fill(p_wc2)
   DEFINE p_wc2     STRING
 
   LET g_sql = " SELECT 'N',pmk04,pmk01,pmk03,pmk02,pmk09,'',pmk22,pmk21,",
               "      pmk41,pmk20,pmk12,''   ,pmk13,''   ,pmk18,pmk25 ", 
               "  FROM pmk_file ",
               " WHERE ",p_wc2 CLIPPED,
               " ORDER BY pmk04 DESC "  #依請購日期降冪
 
   PREPARE p200_pb1 FROM g_sql
   DECLARE pmk_curs CURSOR FOR p200_pb1
  
   CALL g_pmk1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH pmk_curs INTO g_pmk1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)   
         EXIT FOREACH
      END IF

 
      SELECT pmc03 INTO g_pmk1[g_cnt].pmc03
        FROM pmc_file
       WHERE pmc01 = g_pmk1[g_cnt].pmk09
 
      SELECT gen02 INTO g_pmk1[g_cnt].gen02
        FROM gen_file
       WHERE gen01 = g_pmk1[g_cnt].pmk12
 
      SELECT gem02 INTO g_pmk1[g_cnt].gem02
        FROM gem_file
       WHERE gem01 = g_pmk1[g_cnt].pmk13
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL  g_pmk1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b1 = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b1 TO FORMONLY.cn2
   LET g_cnt = 0
END FUNCTION
 
 
FUNCTION p200_b_fill()
 
    LET g_sql="SELECT pml02,pml24,pml25,pml04,",
              "       '','','','','','','','','','','','','',",
              "       '','','','','','','','', ",  
              "       pml041,ima021,pml07,pml20,",
              "       pml83,pml84,pml85,pml80,pml81,pml82,pml86,pml87,",
              "       pml21,pml35,pml34,pml33,pml919,pml41,",      #FUN-A80150 add pml919
              "       pml190,pml191,pml192,",     
              "       pml12,pml121,pml122,pml930,'',pml06,pml38,pml11 ", 
              " FROM pml_file,OUTER ima_file ",
              " WHERE pml01= '",g_pmk1_t.pmk01,"'",
              "   AND pml_file.pml04=ima_file.ima01",
              " ORDER BY pml02 " CLIPPED
 
   PREPARE p200_pb FROM g_sql
   DECLARE pml_curs CURSOR FOR p200_pb
  
   CALL g_pml1.clear()
  
   LET g_cnt = 1
   MESSAGE "Searching!"
 
   FOREACH pml_curs INTO g_pml1[g_cnt].*
      IF STATUS THEN
         CALL cl_err("foreach:",STATUS,1)
         EXIT FOREACH
      END IF
 
      IF cl_null(g_pml1[g_cnt].pml80) THEN
         LET g_pml1[g_cnt].pml81 = NULL
         LET g_pml1[g_cnt].pml82 = NULL
      END IF
      IF cl_null(g_pml1[g_cnt].pml83) THEN
         LET g_pml1[g_cnt].pml84 = NULL
         LET g_pml1[g_cnt].pml85 = NULL
      END IF
 
      SELECT gem02 INTO g_pml1[g_cnt].gem02a
        FROM gem_file
       WHERE gem01= g_pml1[g_cnt].pml930
 
      #如果進行料件多屬性管理并選擇新機制則要對單身顯示的東東進行更改         
      IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN                       
         #得到該料件對應的父料件和所有屬性                                    
         SELECT imx00,imx01,imx02,imx03,imx04,imx05,imx06,                    
                imx07,imx08,imx09,imx10 INTO                                  
                g_pml1[g_cnt].att00,g_pml1[g_cnt].att01,g_pml1[g_cnt].att02,     
                g_pml1[g_cnt].att03,g_pml1[g_cnt].att04,g_pml1[g_cnt].att05,     
                g_pml1[g_cnt].att06,g_pml1[g_cnt].att07,g_pml1[g_cnt].att08,     
                g_pml1[g_cnt].att09,g_pml1[g_cnt].att10                         
         FROM imx_file WHERE imx000 = g_pml1[g_cnt].pml04      
 
         LET g_pml1[g_cnt].att01_c = g_pml1[g_cnt].att01                        
         LET g_pml1[g_cnt].att02_c = g_pml1[g_cnt].att02                        
         LET g_pml1[g_cnt].att03_c = g_pml1[g_cnt].att03                        
         LET g_pml1[g_cnt].att04_c = g_pml1[g_cnt].att04                        
         LET g_pml1[g_cnt].att05_c = g_pml1[g_cnt].att05                        
         LET g_pml1[g_cnt].att06_c = g_pml1[g_cnt].att06                        
         LET g_pml1[g_cnt].att07_c = g_pml1[g_cnt].att07                        
         LET g_pml1[g_cnt].att08_c = g_pml1[g_cnt].att08                        
         LET g_pml1[g_cnt].att09_c = g_pml1[g_cnt].att09                        
         LET g_pml1[g_cnt].att10_c = g_pml1[g_cnt].att10                        
      END IF                                                                  
 
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err("",9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_pml1.deleteElement(g_cnt)
   MESSAGE ""
   LET g_rec_b = g_cnt - 1
   CALL ui.Interface.refresh()
   DISPLAY g_rec_b TO FORMONLY.cn3
   LET g_cnt = 0
END FUNCTION
 
FUNCTION p200_bp2(p_cmd)
   DEFINE p_cmd   LIKE  type_file.chr1
   
  #CALL cl_set_act_visible("accept,cancel", FALSE)  #MOD-C70184 mark
   DISPLAY ARRAY g_pml1 TO s_pml.* ATTRIBUTE(COUNT=g_rec_b)
      BEFORE DISPLAY
         IF cl_null(p_cmd) THEN
           EXIT DISPLAY
         END IF
      ON ACTION return
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help    
         CALL cl_show_help()
      
      ON ACTION controlg 
         CALL cl_cmdask()

   END DISPLAY
END FUNCTION
 
FUNCTION p200_refresh_detail()
  DEFINE l_compare          LIKE smy_file.smy62    
  DEFINE li_col_count       LIKE type_file.num5     
  DEFINE li_i, li_j         LIKE type_file.num5     
  DEFINE lc_agb03           LIKE agb_file.agb03
  DEFINE lr_agd             RECORD LIKE agd_file.*
  DEFINE lc_index           STRING
  DEFINE ls_combo_vals      STRING
  DEFINE ls_combo_txts      STRING
  DEFINE ls_sql             STRING
  DEFINE ls_show,ls_hide    STRING
  DEFINE l_gae04            LIKE gae_file.gae04
   
  #判斷是否進行料件多屬性新機制管理以及是否傳入了屬性群組
  IF (g_sma.sma120 = 'Y') AND (g_sma.sma907 = 'Y') AND
     NOT cl_null(lg_smy62) THEN
     #首先判斷有無單身記錄，如果單身根本沒有東東，則按照默認的lg_smy62來決定
     #顯示什么組別的信息，如果有單身，則進行下面的邏輯判斷
     IF g_pml1.getLength() = 0 THEN
        LET lg_group = lg_smy62
     ELSE   
       #讀取當前單身所有的料件資料，如果它們都屬于多屬性子料件，并且擁有一致的
       #屬性群組，則以該屬性群組作為顯示單身明細屬性的依據，如果有不統一的狀況
       #則返回一個NULL，下面將不顯示任明細屬性列
       FOR li_i = 1 TO g_pml1.getLength()
         #如果某一個料件沒有對應的母料件(已經在前面的b_fill中取出來放在imx00中了)
         #則不進行下面判斷直接退出了
         IF  cl_null(g_pml1[li_i].att00) THEN
            LET lg_group = ''
            EXIT FOR
         END IF
         SELECT imaag INTO l_compare FROM ima_file WHERE ima01 = g_pml1[li_i].att00
         #第一次是賦值
         IF cl_null(lg_group) THEN 
            LET lg_group = l_compare
         #以后是比較   
         ELSE 
           #如果在單身料件屬于不同的屬性組則直接退出（不顯示這些東東)
           IF l_compare <> lg_group THEN
              LET lg_group = ''
              EXIT FOR
           END IF
         END IF
         IF lg_group <> lg_smy62 THEN
            LET lg_group = ''
            EXIT FOR
         END IF
       END FOR 
     END IF
 
     #到這里時lg_group中存放的已經是應該顯示的組別了，該變量是一個全局變量
     #在單身INPUT或開窗時都會用到，因為refresh函數被執行的時機較早，所以能保証在需要的時候有值
     SELECT COUNT(*) INTO li_col_count FROM agb_file WHERE agb01 = lg_group
 
     #走到這個分支說明是采用新機制，那么使用att00父料件編號代替oeb04子料件編號來顯示
     #得到當前語言別下oeb04的欄位標題
     SELECT gae04 INTO l_gae04 FROM gae_file 
       WHERE gae01 = g_prog AND gae02 = 'pml04' AND gae03 = g_lang
     CALL cl_set_comp_att_text("att00",l_gae04)
     
     #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
     IF NOT cl_null(lg_group) THEN
        LET ls_hide = 'pml04,pml041'
        LET ls_show = 'att00'
     ELSE
        LET ls_hide = 'att00'
        LET ls_show = 'pml04,pml041'
     END IF
 
     #顯現該有的欄位,置換欄位格式
     CALL lr_agc.clear()  #因為這個過程可能會被執行多次，作為一個公共變量，每次執行之前必須要初始化
     FOR li_i = 1 TO li_col_count
         SELECT agb03 INTO lc_agb03 FROM agb_file
           WHERE agb01 = lg_group AND agb02 = li_i
 
         LET lc_agb03 = lc_agb03 CLIPPED
         SELECT * INTO lr_agc[li_i].* FROM agc_file
           WHERE agc01 = lc_agb03
 
         LET lc_index = li_i USING '&&'
 
         CASE lr_agc[li_i].agc04
           WHEN '1'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
           WHEN '2'
             LET ls_show = ls_show || ",att" || lc_index || "_c"
             LET ls_hide = ls_hide || ",att" || lc_index 
             CALL cl_set_comp_att_text("att" || lc_index || "_c",lr_agc[li_i].agc02)
             LET ls_sql = "SELECT * FROM agd_file WHERE agd01 = '",lr_agc[li_i].agc01,"'"
             DECLARE agd_curs CURSOR FROM ls_sql
             LET ls_combo_vals = ""
             LET ls_combo_txts = ""
             FOREACH agd_curs INTO lr_agd.*
                IF SQLCA.sqlcode THEN
                   EXIT FOREACH
                END IF
                IF ls_combo_vals IS NULL THEN
                   LET ls_combo_vals = lr_agd.agd02 CLIPPED
                ELSE
                   LET ls_combo_vals = ls_combo_vals,",",lr_agd.agd02 CLIPPED
                END IF
                IF ls_combo_txts IS NULL THEN
                   LET ls_combo_txts = lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                ELSE
                   LET ls_combo_txts = ls_combo_txts,",",lr_agd.agd02 CLIPPED,":",lr_agd.agd03 CLIPPED
                END IF
             END FOREACH
             CALL cl_set_combo_items("formonly.att" || lc_index || "_c",ls_combo_vals,ls_combo_txts)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index || "_c","NOT NULL|REQUIRED|SCROLL","1|1|1")
          WHEN '3'
             LET ls_show = ls_show || ",att" || lc_index
             LET ls_hide = ls_hide || ",att" || lc_index || "_c"
             CALL cl_set_comp_att_text("att" || lc_index,lr_agc[li_i].agc02)
             #這里需要判別g_sma.sma908,如果是允許新增子料件則要把這些屬性設置成為REQUIRED的,否則要設成NOENTRY
                CALL cl_chg_comp_att("formonly.att" || lc_index,"NOT NULL|REQUIRED|SCROLL","1|1|1")
       END CASE
     END FOR       
  ELSE
    #否則什么也不做(不顯示任何屬性列)
    LET li_i = 1
    #為了提高效率，把需要顯示和隱藏的欄位都放到各自的變量里，然后在結尾的地方一次性顯示或隱藏
    LET ls_hide = 'att00'
    LET ls_show = 'pml04'
  END IF
  
  #下面開始隱藏其他明細屬性欄位(從li_i開始)
  FOR li_j = li_i TO 10
      LET lc_index = li_j USING '&&'
      #注意att0x和att0x_c都要隱藏，別忘了_c的
      LET ls_hide = ls_hide || ",att" || lc_index || ",att" || lc_index || "_c"
  END FOR
 
  #這樣只用調兩次公共函數就可以解決問題了，效率應該會高一些
  CALL cl_set_comp_visible(ls_show, TRUE)
  CALL cl_set_comp_visible(ls_hide, FALSE)
END FUNCTION
 
 
FUNCTION p200_sel_all(p_flag)
  DEFINE  p_flag   LIKE type_file.chr1 
  DEFINE  l_i      LIKE type_file.num5
  FOR l_i = 1 TO g_rec_b1 
    LET g_pmk1[l_i].a = p_flag
    DISPLAY BY NAME g_pmk1[l_i].a
  END FOR
END FUNCTION
 
 
FUNCTION p200_init()
   LET lg_smy62 = ''                                                                                                             
   LET lg_group = ''                                                                                                             
   CALL p200_refresh_detail()                                                                                                    
 
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)   #FUN-9B0106
   CASE g_aza.aza41
     WHEN "1"
       LET t_aza41 = 3
     WHEN "2"
       LET t_aza41 = 4
     WHEN "3"
       LET t_aza41 = 5 
   END CASE
END FUNCTION
 
 
FUNCTION p200_chk_pmk()
  DEFINE l_i,l_n  LIKE type_file.num5
  DEFINE l_pml02  LIKE pml_file.pml02,   #TQC-740226
         l_pml04  LIKE pml_file.pml04,
         l_ima54  LIKE ima_file.ima54,
         l_y     LIKE type_file.num5
  DEFINE l_rty05 LIKE rty_file.rty05       #MOD-AC0194
  DEFINE l_j     LIKE type_file.num5  

  LET l_n = 0  
  FOR l_i = 1 TO g_rec_b1
    IF g_pmk1[l_i].a = 'Y' THEN  #有勾選
      #MOD-B90134 add begin-------------
      SELECT COUNT(*) INTO l_j FROM pml_file
      #WHERE pml16 = '1'   #TQC-BB0212 mark
       WHERE (pml16 = '1' OR (pml16='2' AND pml21 < pml20))  #TQC-BB0212 add
         AND pml01 = g_pmk1[l_i].pmk01
      #MOD-B90134 add end--------------
      #要是"已確認"且"已核准"的資料
      #單頭是"已確認"且單身有‘已核准’的資料也需要拋轉  #MOD-B90134 add
      #IF NOT (g_pmk1[l_i].pmk18 = 'Y' AND g_pmk1[l_i].pmk25 = '1')  THEN 
      IF NOT (g_pmk1[l_i].pmk18 = 'Y' AND (g_pmk1[l_i].pmk25 = '1' OR l_j > 0)) THEN  #MOD-B90134 add 
         CALL s_errmsg('pmk01',g_pmk1[l_i].pmk01,'',"apm-098",1)        #TQC-B10172 
         LET g_pmk1[l_i].a = 'N'  #將勾勾拿掉
      ELSE
        # 判斷單頭如無供應商，則單身每一筆料一定要有主供應商
          IF NOT cl_null(g_pmk1[l_i].pmk09) THEN
             LET l_n = l_n + 1
          ELSE #單頭無供應商
             LET l_y = 1
             LET g_sql = " SELECT  pml02,pml04  FROM pml_file ",
                         "  WHERE  pml01 = '", g_pmk1[l_i].pmk01 CLIPPED, "'"
                        ,"   AND pml92 <> 'Y' "   #FUN-A10034
             PREPARE pml_pre FROM g_sql
             DECLARE pml_cur  CURSOR  FOR pml_pre           
             FOREACH pml_cur  INTO  l_pml02,l_pml04
#MOD-AC0194 ---------------------STA
              IF g_azw.azw04 = '2' THEN
               SELECT rty05 INTO l_rty05 FROM rty_file
                WHERE rty01 = g_plant AND rty02 = l_pml04
                IF cl_null(l_rty05) THEN
#MOD-AC0194 ---------------------END
                  SELECT ima54 INTO l_ima54 FROM ima_file 
                   WHERE ima01 = l_pml04
                  IF cl_null(l_ima54) THEN
                     LET g_pmk1[l_i].a = 'N'
                     LET g_msg = g_pmk1[l_i].pmk01 CLIPPED,"-",l_pml02 USING "###"
                     CALL s_errmsg("ima54",g_msg CLIPPED,l_pml04,"apm-571",1)
                     LET l_y = 0
                  END IF
#MOD-AC0194 ---------------------STA
                END IF                                     
              ELSE
                 SELECT ima54 INTO l_ima54 FROM ima_file
                   WHERE ima01 = l_pml04
                  IF cl_null(l_ima54) THEN
                     LET g_pmk1[l_i].a = 'N'
                     LET g_msg = g_pmk1[l_i].pmk01 CLIPPED,"-",l_pml02 USING "###"
                     CALL s_errmsg("ima54",g_msg CLIPPED,l_pml04,"apm-571",1)
                     LET l_y = 0
                  END IF
              END IF
#MOD-AC0194 ---------------------END
             END FOREACH
             IF l_y THEN LET l_n = l_n + 1 END IF
          END IF
      END IF 
    END IF
  END FOR
 
  IF l_n > 0 THEN
    RETURN TRUE
  ELSE
    RETURN FALSE
  END IF
END FUNCTION
 
FUNCTION p200_batch_confirm()
  DEFINE l_i,l_n       LIKE type_file.num5
 
  LET l_n = 0 
  FOR l_i = 1 TO g_rec_b1
    IF g_pmk1[l_i].a = 'Y' THEN
       IF g_pmk1[l_i].pmk18 <> 'N' THEN
          LET g_pmk1[l_i].a = 'N' 
       ELSE
          LET l_n = l_n + 1
       END IF
    END IF
  END FOR
 
  IF l_n > 0 THEN
    IF NOT cl_confirm('axm-596') THEN
      RETURN
    END IF
  ELSE
    RETURN
  END IF
 
  FOR l_i = 1 TO g_rec_b1
    IF g_pmk1[l_i].a = 'Y' THEN
         SELECT pmk_file.* INTO g_pmk.* FROM pmk_file
          WHERE pmk01 = g_pmk1[l_i].pmk01
 
          CALL t420sub_y_chk(g_pmk.pmk01)          #CALL 原確認的 check 段
          IF g_success = "Y" THEN
              CALL t420sub_y_upd(g_pmk.pmk01,'')  #CALL apmt420原確認的 update 段 #FUN-740034
              CALL t420sub_refresh(g_pmk.pmk01) RETURNING g_pmk.*  
              LET g_pmk1[l_i].pmk18 = g_pmk.pmk18
              LET g_pmk1[l_i].pmk25 = g_pmk.pmk25
              LET g_pmk1_t.* = g_pmk1[l_i].*
          END IF
          INITIALIZE g_pmk.* TO NULL
    END IF
  END FOR
END FUNCTION
 
FUNCTION p200_po_dist()
  DEFINE l_str,l_str2  STRING
  DEFINE l_i,l_n    LIKE type_file.num5
 
  LET l_str = ''
  LET l_str2 = ''
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
     IF g_pmk1[l_i].a = 'Y' THEN
        IF l_n = 0 THEN
          LET l_str = g_pmk1[l_i].pmk01
          LET l_str2 = " pmk01 IN ('",g_pmk1[l_i].pmk01 CLIPPED,"'"
        ELSE
          LET l_str = l_str CLIPPED, "|", g_pmk1[l_i].pmk01 CLIPPED
          LET l_str2 = l_str2 CLIPPED, ",'", g_pmk1[l_i].pmk01 CLIPPED ,"'"
        END IF
        LET l_n = l_n + 1
     END IF
  END FOR  
  LET l_str2 = l_str2 CLIPPED, ")"
  LET l_str2 = cl_replace_str( l_str2, "'", "\"")
  IF NOT cl_null(l_str) THEN
#FUN-C30056----modify------begin----------------------
    IF s_industry("slk") THEN
       LET g_msg = " apmp570_slk '", l_str CLIPPED,"' '",l_str2 CLIPPED,"' 'Y'"
    ELSE
       LET g_msg = " apmp570 '", l_str CLIPPED,"' '",l_str2 CLIPPED,"' 'Y'"
    END IF
#FUN-C30056----modify---end--------------------------
    CALL cl_cmdrun_wait(g_msg CLIPPED)
  END IF
END FUNCTION
 
 
FUNCTION p200_carry_po()
 #單頭資料要依下列切
  DEFINE
    l_pmk01    LIKE  pmk_file.pmk01,      #
    l_pmk07    LIKE  pmk_file.pmk07,      #單據分類
    l_pmk08    LIKE  pmk_file.pmk08,      #PBI批號
    l_pmk09    LIKE  pmk_file.pmk09,      #供應廠商
    l_pmk10    LIKE  pmk_file.pmk10,      #送貨地址
    l_pmk11    LIKE  pmk_file.pmk11,      #帳單地址
    l_pmk14    LIKE  pmk_file.pmk14,      #收貨部門
    l_pmk15    LIKE  pmk_file.pmk15,      #確認人
    l_pmk16    LIKE  pmk_file.pmk16,      #運送方式
    l_pmk17    LIKE  pmk_file.pmk17,      #代理商
    l_pmk20    LIKE  pmk_file.pmk20,      #付款方式
    l_pmk21    LIKE  pmk_file.pmk21,      #稅別       
    l_pmk22    LIKE  pmk_file.pmk22,      #幣別
    l_pmk28    LIKE  pmk_file.pmk28,      #會計分類
    l_pmk29    LIKE  pmk_file.pmk29,      #會計科目
    l_pmk30    LIKE  pmk_file.pmk30,      #驗收單列印否
    l_pmk41    LIKE  pmk_file.pmk41,      #價格條件
    l_pmk42    LIKE  pmk_file.pmk42,      #匯率
    l_pmk43    LIKE  pmk_file.pmk43,      #稅別      
    l_pmk45    LIKE  pmk_file.pmk45,      #可用/不可用
    l_pmkprsw  LIKE  pmk_file.pmkprsw    #列印抑制
 
  DEFINE l_buf1    LIKE pmk_file.pmk01        #單別
  DEFINE l_i,l_n       LIKE type_file.num5
  DEFINE li_i          LIKE type_file.num5  #FUN-A10034 
  DEFINE l_pml04       LIKE pml_file.pml04    #CHI-880020
  DEFINE l_wc    STRING 
  DEFINE l_pml92   LIKE pml_file.pml92    #FUN-990069 
  DEFINE l_flag    LIKE type_file.num5    #FUN-990069
  DEFINE l_all,l_y     LIKE type_file.chr1  #FUN-A10034


  LET begin_no = NULL
  LET end_no = NULL
  
  CALL s_showmsg_init()      #TQC-740226
  IF NOT  p200_chk_pmk() THEN 
     CALL s_showmsg()      #TQC-740226
     RETURN 
  END IF
 
  SELECT * INTO g_gfa.* FROM gfa_file 
   WHERE gfa01 = '3'  AND gfa03 ='apmt540'
     AND gfa02 = (SELECT DISTINCT MIN(gfa02) FROM gfa_file 
                      WHERE gfa01 = '3' AND gfa03 = 'apmt540')
 
  OPEN WINDOW p200_exp AT p_row,p_col WITH FORM "apm/42f/apmp200a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) 
  
  CALL cl_ui_locale("apmp200a")
  
  LET tm.slip = g_gfa.gfa05  #預設單據別
  LET tm.dt = g_today        
  LET tm.g = "3"
 
  DISPLAY BY NAME tm.slip,tm.dt,tm.g
  LET g_success = 'Y'
  DROP TABLE pmk_tmp
    
  CREATE TEMP TABLE pmk_temp(
     pmk01    LIKE  pmk_file.pmk01,      
     pmk09    LIKE  pmk_file.pmk09)
      
  DELETE FROM pmk_temp          
  BEGIN WORK
  INPUT BY NAME tm.slip,tm.dt,tm.g  WITHOUT DEFAULTS
    AFTER FIELD slip
      IF NOT cl_null(tm.slip) THEN  
         LET g_cnt = 0
         CALL s_check_no("apm",tm.slip,'',"2","pmm_file","pmm01","")
           RETURNING li_result,tm.slip
         IF (NOT li_result) THEN
           CALL cl_err(tm.slip,'aap-010',0)       
           NEXT FIELD slip
         END IF
         DISPLAY BY NAME tm.slip
      END IF
  
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success = 'N'
         CLOSE WINDOW p200_exp
         RETURN
      END IF
  
      ON ACTION controlp
         CASE
            WHEN INFIELD(slip)
              CALL q_smy(FALSE,FALSE,tm.slip,'APM','2') 
                   RETURNING tm.slip
              DISPLAY BY NAME tm.slip
              NEXT FIELD slip
            OTHERWISE EXIT CASE
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
     LET g_success = 'N'
     ROLLBACK WORK      
     CLOSE WINDOW p200_exp
     RETURN
  END IF
  CLOSE WINDOW p200_exp
 
 
  LET l_wc = " pmk01 in ("
  LET l_n = 0
  FOR l_i = 1 TO g_rec_b1
#TQC-B10160 --begin--     
     IF g_pmk1[l_i].pmk04 > tm.dt THEN
        CALL cl_err('','apm-099',1)
        RETURN
     END IF 
#TQC-B10160 --end--     
     IF g_pmk1[l_i].a = 'Y' THEN
        LET l_n = l_n + 1
        IF l_n = 1 THEN
          LET l_wc = l_wc CLIPPED,"'",g_pmk1[l_i].pmk01,"'"
        ELSE
          LET l_wc = l_wc CLIPPED,",'",g_pmk1[l_i].pmk01,"'"
        END IF
     END IF
  END FOR
  LET l_wc = l_wc CLIPPED ,")"
  
  LET g_wc_pmk09 = NULL                                     #CHI-880020
 
  CASE tm.g
    WHEN "1"   #供應商     
      LET g_sql = "SELECT DISTINCT '','',"
    WHEN "2"   #供應商+單別      (pmk09+substr(pmk01,1,aza41)  #依系統設定抓單據位數
      LET g_sql = "SELECT DISTINCT pmk01[1,",t_aza41,"],'',"            #No.TQC-9B0021
    WHEN "3"   #不匯總         (pmk01)
      LET g_sql = "SELECT DISTINCT '',pmk01,"
  END CASE 
  LET g_sql = g_sql ,"pmk07,pmk08,pmk09,pmk10,pmk11,pmk14,",   #No.FUN-840006 pmk07之前去掉pmk06
                     "pmk15,pmk16,pmk17,pmk20,pmk21,pmk22,pmk28,",
                     "pmk29,pmk30,pmk41,pmk42,pmk43,", #MOD-990146        
                     "pmk45,pmkprsw,pml48,pml49 ",           #MOD-AC0194 add pml48    #TQC-B10137 add pml49
              #       "  FROM  pmk_file ",
                     "  FROM  pmk_file,pml_file ",                            #MOD-AC0193
                     "   WHERE ",l_wc ,
                     "   AND (pmk09 <>'' OR pmk09 IS NOT NULL) ",          #先處理有供應商的資料
#MOD-AC0193 --------------STA
                     "   AND pml01 = pmk01 ",
                     "   AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL) ",
#MOD-AC0193 --------------END
                     "   AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                     "   AND pml20-pml21 > 0 ", #MOD-D40002 add
                     "  ORDER BY pmk09 "
  PREPARE pmk_pre FROM g_sql
  DECLARE pmk_cur2 CURSOR FOR pmk_pre
  FOREACH pmk_cur2 INTO  l_buf1 ,  l_pmk01,
                   l_pmk07,l_pmk08,l_pmk09,l_pmk10,l_pmk11,l_pmk14,        #No.FUN-840006 l_pmk07之前去掉l_pmk06
                   l_pmk15,l_pmk16,l_pmk17,l_pmk20,l_pmk21,l_pmk22,l_pmk28,
                   l_pmk29,l_pmk30,l_pmk41,l_pmk42,l_pmk43, #MOD-990146               
                   l_pmk45,l_pmkprsw,g_pml48,g_pml49              #MOD-AC0194 add pml48      #TQC-B10137 add pml49
 
       LET g_ws2 = ' '
       IF NOT cl_null(l_pmk07) THEN 
          LET g_ws2 = g_ws2,"   AND pmk07 = '",l_pmk07,"'"
       ELSE
          LET g_ws2 = g_ws2,"   AND pmk07 IS NULL "
       END IF
       IF NOT cl_null(l_pmk08) THEN 
          LET g_ws2=g_ws2,"   AND pmk08 = '", l_pmk08, "'"
       ELSE
          LET g_ws2=g_ws2,"   AND pmk08 IS NULL "
       END IF
       IF NOT cl_null(l_pmk10) THEN 
          LET g_ws2=g_ws2,"   AND pmk10 = '", l_pmk10, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND (pmk10 IS NULL OR pmk10 = ' ') "   #MOD-960191
       END IF
       IF NOT cl_null(l_pmk11) THEN 
          LET g_ws2=g_ws2,"   AND pmk11 = '", l_pmk11, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk11 IS NULL "
       END IF
       IF NOT cl_null(l_pmk14) THEN 
          LET g_ws2=g_ws2,"   AND pmk14 = '", l_pmk14, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk14 IS NULL "
       END IF
       IF NOT cl_null(l_pmk15) THEN 
          LET g_ws2=g_ws2,"   AND pmk15 = '", l_pmk15, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk15 IS NULL "
       END IF
       IF NOT cl_null(l_pmk16) THEN 
          LET g_ws2=g_ws2,"   AND pmk16 = '", l_pmk16, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk16 IS NULL "
       END IF
       IF NOT cl_null(l_pmk17) THEN 
          LET g_ws2=g_ws2,"   AND pmk17 = '", l_pmk17, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk17 IS NULL "
       END IF
       IF NOT cl_null(l_pmk20) THEN 
          LET g_ws2=g_ws2,"   AND pmk20 = '", l_pmk20, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk20 IS NULL "
       END IF
       IF NOT cl_null(l_pmk21) THEN 
          LET g_ws2=g_ws2,"   AND pmk21 = '", l_pmk21, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk21 IS NULL "
       END IF
       IF NOT cl_null(l_pmk22) THEN 
          LET g_ws2=g_ws2,"   AND pmk22 = '", l_pmk22, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk22 IS NULL "
       END IF
       IF NOT cl_null(l_pmk28) THEN 
          LET g_ws2=g_ws2,"   AND pmk28 = '", l_pmk28, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk28 IS NULL "
       END IF
       IF NOT cl_null(l_pmk29) THEN 
          LET g_ws2=g_ws2,"   AND pmk29 = '", l_pmk29, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk29 IS NULL "
       END IF
       IF NOT cl_null(l_pmk30) THEN 
          LET g_ws2=g_ws2,"   AND pmk30 = '", l_pmk30, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk30 IS NULL "
       END IF
       IF NOT cl_null(l_pmk41) THEN 
          LET g_ws2=g_ws2,"   AND pmk41 = '", l_pmk41, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk41 IS NULL "
       END IF
       IF NOT cl_null(l_pmk42) THEN 
          LET g_ws2=g_ws2,"   AND pmk42 = ", l_pmk42 
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk42 IS NULL "
       END IF
       IF NOT cl_null(l_pmk43) THEN 
          LET g_ws2=g_ws2,"   AND pmk43 = ", l_pmk43
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk43 IS NULL "
       END IF
       IF NOT cl_null(l_pmk45) THEN 
          LET g_ws2=g_ws2,"   AND pmk45 = '", l_pmk45, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmk45 IS NULL "
       END IF
       IF NOT cl_null(l_pmkprsw) THEN 
          LET g_ws2=g_ws2,"   AND pmkprsw = '", l_pmkprsw, "'"
       ELSE 
          LET g_ws2=g_ws2,"   AND pmkprsw IS NULL "
       END IF
 
       IF cl_null(g_wc_pmk09) THEN
          LET g_wc_pmk09 = " pmk09 IN('",l_pmk09,"'"
       ELSE
          LET g_wc_pmk09 = g_wc_pmk09,",'",l_pmk09,"'"
       END IF       
 
      CASE tm.g     
        WHEN "1"  #供應商
#MOD-AC0194 ------------------STA
          IF NOT cl_null(g_pml48) THEN
             LET g_sql = "SELECT * FROM pmk_file,pml_file",
                        "  WHERE 1 = 1"," AND pml01 = pmk01"
              LET g_ws1 = "  AND pml48 = '", g_pml48,"'",
                          "  AND pml49 = '",g_pml49,"'",                 #TQC-B10137 add
                          "   AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                          "   AND ",l_wc
          ELSE
#MOD-AC0194 ------------------END
#TQC-B10137 -----------------STA
#            LET g_sql = "SELECT * FROM pmk_file",
#                       "   WHERE 1 = 1"
#            LET g_ws1 = "   AND pmk09 = '", l_pmk09,"'",
#                       "   AND ",l_wc
             LET g_sql = "SELECT * FROM pmk_file,pml_file",
                        "  WHERE 1 = 1"," AND pml01 = pmk01"
             LET g_ws1 = "   AND pmk09 = '", l_pmk09,"'",
                         "   AND pml49 = '",g_pml49,"'", 
                         "   AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                         "   AND ",l_wc
#TQC-B10137 -----------------END
          END IF
          LET g_sql = g_sql ,g_ws1 CLIPPED ,g_ws2 CLIPPED
 
        WHEN "2"  #依供應商+單別
#MOD-AC0194 -------------------STA
          IF NOT cl_null(g_pml48) THEN
             LET g_sql = "SELECT * FROM pmk_file,pml_file ",
                         " WHERE pmk01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'", 
                         "  AND pml01 = pmk01 "         
             LET g_ws1 = "   AND pml48 = '", g_pml48,"'",
                         "  AND pml49 = '",g_pml49,"'",                 #TQC-B10137 add
                         "   AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                         "   AND ",l_wc
          ELSE
#MOD-AC0194 -------------------END
#TQC-B10137 -----------------STA
#            LET g_sql = "SELECT * FROM pmk_file ",
#                        " WHERE pmk01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'"            #No.TQC-9B0021
#            LET g_ws1 = "   AND pmk09 = '", l_pmk09,"'",
#                        "   AND ",l_wc
             LET g_sql = "SELECT * FROM pmk_file,pml_file ",
                          " WHERE pmk01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'",
                          " AND pml01 = pmk01"
              LET g_ws1 = "   AND pmk09 = '", l_pmk09,"'",
                          "   AND pml49 = '",g_pml49,"'", 
                          "   AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                          "   AND ",l_wc    
#TQC-B10137 -----------------END
          END IF
          LET g_sql = g_sql ,g_ws1 CLIPPED ,g_ws2 CLIPPED
 
        WHEN "3"  #不匯總 
#TQC-B10137 -----------------STA  
#         LET g_sql = "SELECT * FROM pmk_file ",
#                     " WHERE pmk01 ='", l_pmk01, "'"
          LET g_sql = "SELECT * FROM pmk_file,pml_file ",
                      " WHERE pmk01 ='", l_pmk01, "'"," AND pml01 = pmk01",
                      " AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                      " AND pml49 = '",g_pml49,"'"
#TQC-B10137 -----------------END
      END CASE
 
      LET g_wc_pmk = NULL   
      PREPARE pmk_pre1  FROM g_sql
      DECLARE p200_pmk_cs  SCROLL CURSOR FOR pmk_pre1  #SCROLL CURSOR
      FOREACH p200_pmk_cs INTO g_pmk.*
         IF cl_null(g_wc_pmk) THEN
           LET g_wc_pmk = " pml01 IN('",g_pmk.pmk01,"'"
         ELSE
           LET g_wc_pmk = g_wc_pmk,",'",g_pmk.pmk01,"'"
         END IF
      END FOREACH
      IF NOT cl_null(g_wc_pmk) THEN LET g_wc_pmk=g_wc_pmk,")" END IF
 
      CALL p200_ins_pmm()
      CALL p200_ins_pmo()
      CALL p200_upd_pmm()
      IF g_success = 'N' THEN
        EXIT FOREACH
      END IF
     
  END FOREACH
  IF NOT cl_null(g_wc_pmk09) THEN LET g_wc_pmk09=g_wc_pmk09,")" END IF         
  IF g_success = 'N' THEN
     ROLLBACK WORK
     CALL cl_err('','abm-020',1)
  ELSE
     COMMIT WORK
  END IF

  BEGIN WORK     
                                                                #CHI-880020
#MOD-AC0194 ----------------------STA
IF g_azw.azw04 = '2' THEN
 IF g_success = 'Y' THEN
     #處理供應商空白的
  CASE tm.g
    WHEN "1"   #供應商     
      LET g_sql = "SELECT DISTINCT '','',"
    WHEN "2"   #供應商+單別      (pmk09+substr(pmk01,1,aza41)  #依系統設定抓單據位數
      LET g_sql = "SELECT DISTINCT pmk01[1,",t_aza41,"],'',"           
    WHEN "3"   #不匯總         (pmk01)
      LET g_sql = "SELECT DISTINCT '',pmk01,"
  END CASE 
  LET g_sql = g_sql ,"pmk09,pml48,pml49,rty05",      
                     "    FROM  pmk_file,pml_file,rty_file",
                     "   WHERE ",l_wc ,
                     "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                     "     AND pml01 = pmk01 ",
                     "     AND pml04 = rty02 ",
                     "     AND rty01 = '",g_plant,"'",
       #             "     AND (rty03 = '1' OR rty03 = ' ' OR rty03 IS NULL) ",         #MOD-AC0193 add
                     "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                     "     AND (rty05 <>'' OR rty05 IS NOT NULL) ",
                     "     AND pml92 <> 'Y' ",      #FUN-A10034
                     "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                     "   AND pml20-pml21 > 0 ", #MOD-D40002 add
                     "   ORDER BY rty05 "
  PREPARE pmk_pre_0 FROM g_sql
  DECLARE pmk_cur2_0 CURSOR FOR pmk_pre_0
  FOREACH pmk_cur2_0 INTO l_buf1,l_pmk01,l_pmk09,g_pml48,g_pml49,g_rty05              #TQC-B10137 add  pml49
     
    CASE tm.g                                            
      WHEN "1"  #供應商
#MOD-AC0194----------------STA
         IF NOT cl_null(g_pml48) THEN
            LET g_sql = "SELECT DISTINCT pmk_file.* FROM pmk_file,pml_file ",
                        "   WHERE ",l_wc ,
                        "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                        "     AND pml01 = pmk01 ",
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",      
                        "     AND pml48 = '", g_pml48,"' ", 
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "        
         ELSE
#MOD-AC0194 ----------------END
            LET g_sql = "SELECT DISTINCT pmk_file.* FROM pmk_file,pml_file,rty_file ",
                        "   WHERE ",l_wc ,
                        "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                        "     AND pml01 = pmk01 ",
                        "     AND pml04 = rty02 ",
                        "     AND rty01 = '",g_plant,"'",
       #                "     AND (rty03 = '1' OR rty03 = ' ' OR rty03 IS NULL) ",         #MOD-AC0193 add
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                        "     AND rty05 = '", g_rty05,"' ", 
                        "     AND (pml48 = '' OR pml48 = ' ' OR pml48 IS NULL)",         #MOD-AC0194
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "        #FUN-A10034
         END IF
      WHEN "2"  #依供應商+單別 
#MOD-AC0194 -----------------STA
         IF NOT cl_null(g_pml48) THEN
               LET g_sql = "SELECT pmk_file.* FROM pmk_file,pml_file ",
                        "   WHERE ",l_wc ,
                        "     AND pmk01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'",            
                        "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                        "     AND pml01 = pmk01 ",
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       
                        "     AND pml48 = '", g_pml48,"' ",
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "       
         ELSE
#MOD-AC0194 ------------------END
            LET g_sql = "SELECT pmk_file.* FROM pmk_file,pml_file,rty_file ",
                        "   WHERE ",l_wc ,
                        "     AND pmk01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'",            
                        "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                        "     AND pml01 = pmk01 ",
                        "     AND pml04 = rty02 ",
                        "     AND rty01 = '",g_plant,"'",
      #                 "     AND (rty03 = '1' OR rty03 = ' ' OR rty03 IS NULL) ",         #MOD-AC0193 add
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                        "     AND rty05 = '", g_rty05,"' ",
                        "     AND (pml48 = '' OR pml48 = ' ' OR pml48 IS NULL)",         #MOD-AC0194
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "        #FUN-A10034
         END IF
      WHEN "3"   #不匯總           
         LET g_sql = "SELECT * FROM pmk_file,pml_file ",                             #MOD-AC0193 add pml_file
                     " WHERE pmk01 ='", l_pmk01, "'",                           
                     "   AND (pmk09 = '' OR pmk09 IS NULL) ",
                     "   AND pml01 = pmk01 ",                                        #MOD-AC0193
                     "   AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                     "   AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                     "   AND pml92 <> 'Y' "        #FUN-A10034
    END CASE                         
         PREPARE pmk_pre2_0  FROM g_sql
         DECLARE p200_pmk_cs2_0  SCROLL CURSOR FOR pmk_pre2_0  #SCROLL CURSOR
         LET g_wc_pmk = NULL
         FOREACH p200_pmk_cs2_0 INTO g_pmk.*   
               IF cl_null(g_wc_pmk) THEN
                  LET g_wc_pmk = " pml01 IN('",g_pmk.pmk01,"'"
               ELSE
                  LET g_wc_pmk = g_wc_pmk,",'",g_pmk.pmk01,"'"
               END IF
         END FOREACH      
         IF NOT cl_null(g_wc_pmk) THEN LET g_wc_pmk=g_wc_pmk,")" END IF 
#MOD-AC0194 ----------------STA
         IF NOT cl_null(g_pml48) THEN
           LET g_sql = "SELECT pml04 FROM pml_file ",                           
                       "   WHERE ",g_wc_pmk ,                           
                       "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       
                       "     AND pml48 = '", g_pml48,"' ",
                       "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                       "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                       "     AND pml92 <> 'Y' "  
         ELSE    
#MOD-AC0194 -----------------END
           LET g_sql = "SELECT pml04 FROM pml_file,rty_file ",                           
                       "   WHERE ",g_wc_pmk ,                           
                       "     AND pml04 = rty02 ",
                       "     AND rty01 = '",g_plant,"'",
         #             "     AND (rty03 = '1' OR rty03 = ' ' OR rty03 IS NULL) ",         #MOD-AC0193 add
                       "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                       "     AND rty05 = '", g_rty05,"' ",
                       "     AND (pml48 = '' OR pml48 = ' ' OR pml48 IS NULL)",         #MOD-AC0194
                       "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                       "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                       "     AND pml92 <> 'Y' "   #FUN-A10034
         END IF
         PREPARE pmk_pre2_02  FROM g_sql
         DECLARE p200_pmk_cs2_02  SCROLL CURSOR FOR pmk_pre2_02  #SCROLL CURSOR
         LET g_wc_pml = NULL
         FOREACH p200_pmk_cs2_02 INTO l_pml04   
               IF cl_null(g_wc_pml) THEN
                  LET g_wc_pml = " pml04 IN('",l_pml04,"'"
               ELSE
                  LET g_wc_pml = g_wc_pml,",'",l_pml04,"'"
               END IF
         END FOREACH      
         IF NOT cl_null(g_wc_pml) THEN LET g_wc_pml=g_wc_pml,")" END IF
         LET g_wc_pmk = g_wc_pmk," AND ",g_wc_pml                                
         CALL p200_ins_pmm()
         CALL p200_ins_pmo()
         CALL p200_upd_pmm()
         IF g_success = 'N' THEN
            EXIT FOREACH
         END IF
  END FOREACH
 END IF               
ELSE                                                

#MOD-AC0194 ----------------------END                                                              
  IF g_success = 'Y' THEN
     #處理供應商空白的
  CASE tm.g
    WHEN "1"   #供應商     
      LET g_sql = "SELECT DISTINCT '','',"
    WHEN "2"   #供應商+單別      (pmk09+substr(pmk01,1,aza41)  #依系統設定抓單據位數
      LET g_sql = "SELECT DISTINCT pmk01[1,",t_aza41,"],'',"            #No.TQC-9B0021
    WHEN "3"   #不匯總         (pmk01)
      LET g_sql = "SELECT DISTINCT '',pmk01,"
  END CASE 
  LET g_sql = g_sql ,"pmk09,pml48,pml49,ima54",      
                     "    FROM  pmk_file,pml_file,ima_file ", 
                     "   WHERE ",l_wc ,
                     "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                     "     AND pml01 = pmk01 ",
                     "     AND pml04 = ima01 ",
                     "     AND pml92 <> 'Y' ",      #FUN-A10034
                     "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                     "     AND (ima54 <>'' OR ima54 IS NOT NULL) ",
                     "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                     "     AND pml20-pml21 > 0 ", #MOD-D40002 add
                     "   ORDER BY ima54 "
  PREPARE pmk_pre_1 FROM g_sql
  DECLARE pmk_cur2_1 CURSOR FOR pmk_pre_1
  FOREACH pmk_cur2_1 INTO l_buf1,l_pmk01,l_pmk09,g_pml48,g_pml49,g_ima54
    LET g_count = 0
    LET g_sql = "SELECT COUNT(*) FROM pmk_file ",
                "   WHERE ",g_wc_pmk09,
                "     AND pmk09 = '", g_ima54,"' "
    PREPARE pmk09_pre  FROM g_sql
    DECLARE p200_pmk09 CURSOR FOR pmk09_pre
    OPEN p200_pmk09
    FETCH p200_pmk09 INTO g_count
                                           
    CASE tm.g                                            
      WHEN "1"  #供應商
#MOD-AC0194 --------------STA
         IF NOT cl_null(g_pml48) THEN
            LET g_sql = "SELECT DISTINCT pmk_file.* FROM pmk_file,pml_file ",   
                        "   WHERE ",l_wc ,
                        "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                        "     AND pml01 = pmk01 ",
                        "     AND pml48 = '", g_pml48,"' ",      
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add         
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",      
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "      
         ELSE
#MOD-AC0194 ---------------END
            LET g_sql = "SELECT DISTINCT pmk_file.* FROM pmk_file,pml_file,ima_file ",   
                        "   WHERE ",l_wc ,
                        "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                        "     AND pml01 = pmk01 ",
                        "     AND pml04 = ima01 ",
                        "     AND ima54 = '", g_ima54,"' ",                 #MOD-AC0194
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                        "     AND (pml48 = '' OR pml48 = ' ' OR pml48 IS NULL)",         #MOD-AC0194
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "        #FUN-A10034
         END IF
      WHEN "2"  #依供應商+單別  
#MOD-AC0194 ---------------STA
         IF NOT cl_null(g_pml48) THEN  
             LET g_sql = "SELECT pmk_file.* FROM pmk_file,pml_file ",
                        "   WHERE ",l_wc ,
                        "     AND pmk01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'",            
                        "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                        "     AND pml01 = pmk01 ",
                        "     AND pml48 = '", g_pml48,"' ",             
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",      
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "       
         ELSE
#MOD-AC0194 ----------------END
            LET g_sql = "SELECT pmk_file.* FROM pmk_file,pml_file,ima_file ",
                        "   WHERE ",l_wc ,
                        "     AND pmk01[1,",t_aza41,"]='",l_buf1 CLIPPED,"'",            #No.TQC-9B0021
                        "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                        "     AND pml01 = pmk01 ",
                        "     AND pml04 = ima01 ",
                        "     AND ima54 = '", g_ima54,"' ",              #MOD-AC0194
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                        "     AND (pml48 = '' OR pml48 = ' ' OR pml48 IS NULL)",         #MOD-AC0194
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "        #FUN-A10034
         END IF
      WHEN "3"   #不匯總           
         LET g_sql = "SELECT * FROM pmk_file,pml_file ",                             #MOD-AC0193 add pml_file
                     " WHERE pmk01 ='", l_pmk01, "'",                           
                     "   AND (pmk09 = '' OR pmk09 IS NULL) ",
                     "   AND pmk01 = pml01 ",                                        #MOD-AC0193
                     "   AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                     "   AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                     "   AND pml92 <> 'Y' "        #FUN-A10034
    END CASE                         
         PREPARE pmk_pre2_1  FROM g_sql
         DECLARE p200_pmk_cs2_1  SCROLL CURSOR FOR pmk_pre2_1  #SCROLL CURSOR
         LET g_wc_pmk = NULL
         FOREACH p200_pmk_cs2_1 INTO g_pmk.*   
               IF cl_null(g_wc_pmk) THEN
                  LET g_wc_pmk = " pml01 IN('",g_pmk.pmk01,"'"
               ELSE
                  LET g_wc_pmk = g_wc_pmk,",'",g_pmk.pmk01,"'"
               END IF
         END FOREACH      
         IF NOT cl_null(g_wc_pmk) THEN LET g_wc_pmk=g_wc_pmk,")" END IF 
#MOD-AC0194 ---------------STA
         IF NOT cl_null(g_pml48) THEN
             LET g_sql = "SELECT pml04 FROM pml_file ",                           
                        "   WHERE ",g_wc_pmk ,                           
                        "     AND pml48 = '", g_pml48,"' ",           
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",      
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "   
         ELSE   
#MOD-AC0194 ----------------END
            LET g_sql = "SELECT pml04 FROM pml_file,ima_file ",                           
                        "   WHERE ",g_wc_pmk ,                           
                        "     AND pml04 = ima01 ",
                        "     AND ima54 = '", g_ima54,"' ",            #MOD-AC0194
                        "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                        "     AND (pml48 = '' OR pml48 = ' ' OR pml48 IS NULL)",         #MOD-AC0194
                        "     AND pml49 = '", g_pml49,"' ",                         #TQC-B10137 add
                        "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                        "     AND pml92 <> 'Y' "   #FUN-A10034
         END IF
         PREPARE pmk_pre2_2  FROM g_sql
         DECLARE p200_pmk_cs2_2  SCROLL CURSOR FOR pmk_pre2_2  #SCROLL CURSOR
         LET g_wc_pml = NULL
         FOREACH p200_pmk_cs2_2 INTO l_pml04   
               IF cl_null(g_wc_pml) THEN
                  LET g_wc_pml = " pml04 IN('",l_pml04,"'"
               ELSE
                  LET g_wc_pml = g_wc_pml,",'",l_pml04,"'"
               END IF
         END FOREACH      
         IF NOT cl_null(g_wc_pml) THEN LET g_wc_pml=g_wc_pml,")" END IF
         LET g_wc_pmk = g_wc_pmk," AND ",g_wc_pml                                
         CALL p200_ins_pmm()
         CALL p200_ins_pmo()
         CALL p200_upd_pmm()
         IF g_success = 'N' THEN
            EXIT FOREACH
         END IF
  END FOREACH
  
         LET g_sql = "SELECT pmk_file.*,pml04,ima54 FROM pmk_file,pml_file,ima_file ",
                     "   WHERE ",l_wc ,
                     "     AND (pmk09 = '' OR pmk09 IS NULL) ",
                     "     AND pml01 = pmk01 ",
                     "     AND pml04 = ima01 ",
                     "     AND pml92 <> 'Y' ",                    #FUN-A10034
                     "     AND (pml50 = '1' OR pml50 = ' ' OR pml50 IS NULL)",       #MOD-AC0193
                     "     AND pml16 NOT IN ('6','7','8','9') ", #MOD-C50239 add
                     "     AND pml20-pml21 > 0 ", #MOD-D40002 add
                     "     AND (ima54 = '' OR ima54 IS NULL) "                #MOD-AC0194
         PREPARE pmk_pre2  FROM g_sql
         DECLARE p200_pmk_cs2  SCROLL CURSOR FOR pmk_pre2  #SCROLL CURSOR
         FOREACH p200_pmk_cs2 INTO g_pmk.*              
             LET tm.g = "3"  #以不匯總的方式處理                  
             CALL p200_ins_pmm()
             CALL p200_upd_pmm()
             IF g_success = 'N' THEN
               EXIT FOREACH
             END IF
         END FOREACH             

                                    
  END IF
END IF                                                                      #MOD-AC0193 
  CALL s_showmsg()      #TQC-740226
  IF g_success = 'N' THEN
     ROLLBACK WORK
     CALL cl_err('','abm-020',1)
  ELSE
     COMMIT WORK
     IF NOT cl_null(begin_no) THEN
       LET g_msg = begin_no CLIPPED,"~",end_no CLIPPED
       CALL cl_err(g_msg CLIPPED,"mfg0101",1)
     END IF
  END IF
 
  FOR l_i = 1 TO g_rec_b1
     IF g_pmk1[l_i].a = 'Y' THEN
        SELECT pmk25 INTO g_pmk1[l_i].pmk25 FROM pmk_file
         WHERE pmk01 = g_pmk1[l_i].pmk01
     END IF
  END FOR
 
END FUNCTION
 
 
FUNCTION p200_ins_pmm()
   DEFINE l_oax01   LIKE oax_file.oax01,   #三角貿易使用匯率 S/B/C/D      #NO.FUN-670007
          l_oaz52   LIKE oaz_file.oaz52,   #內銷使用匯率 B/S/C/D
          l_oaz70   LIKE oaz_file.oaz70,   #外銷使用匯率 B/S/C/D
          li_result LIKE type_file.num5,             
          exT       LIKE type_file.chr1,             
          l_date1   LIKE type_file.dat,              
          l_date2   LIKE type_file.dat               
   DEFINE l_pmn02   LIKE type_file.num5
   DEFINE l_pmc14   LIKE pmc_file.pmc14,
          l_pmc15   LIKE pmc_file.pmc15,
          l_pmc16   LIKE pmc_file.pmc16,
          l_pmc17   LIKE pmc_file.pmc17,
          l_pmc22   LIKE pmc_file.pmc22,   #MOD-920077
          l_pmc47   LIKE pmc_file.pmc47,
          l_pmc49   LIKE pmc_file.pmc49
   DEFINE l_t       LIKE smy_file.smyslip  #MOD-920297
 
   #Default初植
    LET g_pmm.pmm02=g_pmk.pmk02        #單據性質
    IF g_pmk.pmk02 = 'TAP' THEN
       LET g_pmm.pmm02  ='TAP'             #單據性質
       LET g_pmm.pmm901 = 'Y'
       LET g_pmm.pmm902 = 'N'
       LET g_pmm.pmm905 = 'N'
       LET g_pmm.pmm906 = 'Y'
    ELSE
       LET g_pmm.pmm901 = 'N'         #非三角貿易代買單據
       LET g_pmm.pmm905 = 'N'         #非三角貿易代買單據
    END IF
    LET g_pmm.pmm03=0               #更動序號
    LET g_pmm.pmm04=tm.dt             #採購日期
    LET g_pmm.pmm05=''                #專案號碼-> no use
    LET g_pmm.pmm07=g_pmk.pmk07       #單據分類
    LET g_pmm.pmm08=g_pmk.pmk08       #PBI批號
    IF cl_null(g_pml48) THEN
       IF cl_null(g_pmk.pmk09) THEN      #CHI-880020
#MOD-AC0194 ---------------STA
          IF cl_null(g_rty05) THEN
             LET g_pmm.pmm09=g_ima54
          ELSE
             LET g_pmm.pmm09 = g_rty05
          END IF
#       LET g_pmm.pmm09=g_ima54        #CHI-880020
#MOD-AC0194 ---------------END
       ELSE                              #CHI-880020
          LET g_pmm.pmm09=g_pmk.pmk09    #供應廠商
       END IF                            #CHI-880020
    ELSE
       LET g_pmm.pmm09 =g_pml48
    END IF
    LET g_pmm.pmm10=g_pmk.pmk10       #送貨地址
    LET g_pmm.pmm11=g_pmk.pmk11       #帳單地址
    LET g_pmm.pmm12=g_user            #採購員     #MOD-C90083 modify g_pmk.pmk12 -> g_user
    LET g_pmm.pmm13=g_grup            #採購部門   #MOD-C90083 modify g_pmk.pmk13 -> g_grup
    LET g_pmm.pmm14=g_pmk.pmk14       #收貨部門
    #LET g_pmm.pmm15=g_pmk.pmk15       #確認人  #MOD-C80238 mark
    LET g_pmm.pmm16=g_pmk.pmk16       #運送方式
    LET g_pmm.pmm17=g_pmk.pmk17       #代理商
    LET g_pmm.pmm18="N"
    LET g_pmm.pmm20=g_pmk.pmk20       #付款方式
    LET g_pmm.pmm21=g_pmk.pmk21       #稅別       
    LET g_pmm.pmm22=g_pmk.pmk22       #幣別
    LET l_t = s_get_doc_no(tm.slip)   #MOD-920297
    SELECT smyapr INTO g_pmm.pmmmksg
      FROM smy_file WHERE smyslip=l_t   #MOD-920297
    IF STATUS THEN LET g_pmm.pmmmksg='N' END IF
    LET g_pmm.pmm25='0'			#狀況碼
    LET g_pmm.pmm26=NULL              #理由碼
    LET g_pmm.pmm27=g_today           #狀況異動日期
    LET g_pmm.pmm28=g_pmk.pmk28       #會計分類
    LET g_pmm.pmm29=g_pmk.pmk29       #會計科目
    LET g_pmm.pmm30=g_pmk.pmk30       #驗收單列印否
    SELECT azn02 INTO g_pmm.pmm31 FROM azn_file
     WHERE azn01 = g_pmm.pmm04
    SELECT azn04 INTO g_pmm.pmm32 FROM azn_file
     WHERE azn01 = g_pmm.pmm04
    LET g_pmm.pmm40=0                 #總金額
    LET g_pmm.pmm40t=0                #總含稅金額 
    LET g_pmm.pmm401=0                #代買總金額
    LET g_pmm.pmm41=g_pmk.pmk41       #價格條件
    LET g_pmm.pmm42=g_pmk.pmk42       #匯率
    LET g_pmm.pmm43=g_pmk.pmk43       #稅率       
    LET g_pmm.pmm44='1'               #稅處理
    LET g_pmm.pmm45=g_pmk.pmk45       #可用/不可用
    LET g_pmm.pmm46=0                 #預付比率
    LET g_pmm.pmm47=0                 #預付金額
    LET g_pmm.pmm48=0                 #已結帳金額
    LET g_pmm.pmm49='N'               #預付發票否
    LET g_pmm.pmm909="2"              #No.FUN-630006
    LET g_pmm.pmmprsw=g_pmk.pmkprsw   #列印抑制
    LET g_pmm.pmmprno=0               #已列印次數
    LET g_pmm.pmmprdt=NULL            #最後列印日期
    LET g_pmm.pmmsseq = 0             #已簽順序
    LET g_pmm.pmmsmax = 0             #應簽順序
    LET g_pmm.pmmacti='Y'             #資料有效碼
    LET g_pmm.pmmuser=g_user          #No:9564
    LET g_pmm.pmmgrup=g_grup          #資料所有部門  
    LET g_pmm.pmmmodu=' '             #資料修改者
    LET g_pmm.pmmdate=g_today         #最近修改日期  
    LET g_pmm.pmmplant=g_plant   #FUN-980006 add
    LET g_pmm.pmmlegal=g_legal   #FUN-980006 add
#---後續default 判斷
    SELECT pmc14,pmc15,pmc16,pmc17,pmc22,pmc47,pmc49
      INTO l_pmc14,l_pmc15,l_pmc16,l_pmc17,l_pmc22,l_pmc47,l_pmc49
      FROM pmc_file
     WHERE pmc01 = g_pmm.pmm09
    IF cl_null(g_pmm.pmm41) THEN
       LET g_pmm.pmm41 = l_pmc49
    END IF
    IF cl_null(g_pmm.pmm20) THEN
       LET g_pmm.pmm20 = l_pmc17
       SELECT pma06 INTO g_pmm.pmm46 FROM pma_file
                   WHERE pma01 = g_pmm.pmm20
    END IF
    IF cl_null(g_pmm.pmm21) THEN
       LET g_pmm.pmm21 = l_pmc47  #慣用稅別
       SELECT  gec04 INTO g_pmm.pmm43
          FROM gec_file WHERE gec01 = l_pmc47
    END IF
    IF cl_null(g_pmm.pmm22) THEN
       LET g_pmm.pmm22 = l_pmc22
    END IF
    IF g_pmm.pmm10 IS NULL OR g_pmm.pmm10 = ' ' THEN
       LET g_pmm.pmm10 = l_pmc15
    END IF
    IF g_pmm.pmm11 IS NULL OR g_pmm.pmm11 = ' ' THEN
       LET g_pmm.pmm11 = l_pmc16
    END IF
    IF g_aza.aza17 = g_pmm.pmm22 THEN   #本幣
       LET g_pmm.pmm42 = 1
    ELSE
       CALL s_curr3(g_pmm.pmm22,g_pmm.pmm04,g_sma.sma904) 
       RETURNING g_pmm.pmm42
    END IF
 
   IF (tm.g = '1' AND g_count = 0 ) OR (tm.g = '2' AND g_count = 0 ) OR tm.g = 3 THEN    #CHI-880020   
   CALL s_auto_assign_no("apm",tm.slip,g_pmm.pmm04,"2","pmm_file","pmm01","","","")
     RETURNING li_result,g_pmm.pmm01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF
#   LET g_pmm.pmm51 = ' '         #TQC-B10137 mark
   LET g_pmm.pmm51 = g_pml49      #TQC-B10137 add
   LET g_pmm.pmmpos = 'N'
   LET g_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
   LET g_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO pmm_file VALUES(g_pmm.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','','',SQLCA.sqlcode,1)      
      LET g_success = 'N'
      RETURN
   END IF
   IF cl_null(begin_no) THEN 
      LET begin_no = g_pmm.pmm01
   END IF
   LET end_no=g_pmm.pmm01
   INSERT INTO pmk_temp VALUES(g_pmm.pmm01,g_pmm.pmm09)                                  #CHI-880020   
   END IF                                                                                #CHI-880020
 
   CASE tm.g
    WHEN "1"  #供應商
      LET g_sql = "SELECT * FROM pml_file ",
                  " WHERE ",g_wc_pmk,
                  "   AND pml92 <> 'Y' "   #FUN-A10034
                  ," AND pml49 = '",g_pml49,"'"      #TQC-B10137 add
                  ," AND pml16 NOT IN('6','7','8','9')"       #TQC-B10122 add   #TQC-BB0212 remark
                 #," AND pml16 NOT IN('2','6','7','8','9')"       #TQC-B10122 add  #MOD-B90134  #TQC-BB0212 mark
    WHEN "2"  #供應商+單別
      LET g_sql = "SELECT * FROM pml_file ",
                  " WHERE ", g_wc_pmk,
                  "   AND pml92 <> 'Y' "   #FUN-A10034
                  ," AND pml49 = '",g_pml49,"'"      #TQC-B10137 add
                  ," AND pml16 NOT IN('6','7','8','9')"       #TQC-B10122 add   #TQC-BB0212 remark   
                 #," AND pml16 NOT IN('2','6','7','8','9')"       #TQC-B10122 add  #MOD-B90134  #TQC-BB0212 mark  
    WHEN "3"  #不匯總
      LET g_sql = "SELECT * FROM pml_file ",      
                  " WHERE ", g_wc_pmk,
                  "   AND pml92 <> 'Y' "   #FUN-A10034
                  ," AND pml49 = '",g_pml49,"'"      #TQC-B10137 add
		  ," AND pml16 NOT IN('6','7','8','9')"       #TQC-B10122 add   #TQC-BB0212 remark                
                 #," AND pml16 NOT IN('2','6','7','8','9')"       #TQC-B10122 add  #MOD-B90134  #TQC-BB0212 mark               
   END CASE
    
   LET l_pmn02 = 0
   PREPARE p200_prepare1 FROM g_sql
   IF SQLCA.sqlcode THEN 
      CALL s_errmsg('','','',SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN 
   END IF
   DECLARE p200_cs1 CURSOR WITH HOLD FOR p200_prepare1
   FOREACH p200_cs1 INTO g_pml.* 
#MOD-AC0193 -------------STA
         IF cl_null(g_pml.pml21) THEN
            LET g_pml.pml21 = 0
         END IF
#MOD-AC0193 -------------END
         IF g_pml.pml20 - g_pml.pml21 <= 0 THEN
            CONTINUE  FOREACH
         END IF 
         IF g_pml.pml190 = 'Y' THEN                                                                                                 
            CONTINUE  FOREACH                                                                                                       
         END IF     
#MOD-AC0193 -------------STA
         IF g_pml.pml50 <> '1' AND  NOT cl_null(g_pml.pml50) THEN
            CONTINUE  FOREACH
         END IF
#MOD-AC0193 -------------END    
         LET l_pmn02 = l_pmn02 + 1
         IF SQLCA.sqlcode THEN 
            CALL s_errmsg('','','prepare:',SQLCA.sqlcode,1)  
            LET g_success = 'N'
            RETURN 
         END IF
         LET g_pmn.pmn02  = l_pmn02     #項次
         CALL p200_ins_pmn()
         INITIALIZE g_pmn.* LIKE pmn_file.*   #DEFAULT 設定
         INITIALIZE g_pml.* LIKE pml_file.*   #DEFAULT 設定
   END FOREACH
   IF g_pmn.pmn02 = 0 THEN                                                                                                          
      CALL cl_err('','apm-204',1)                                                                                                   
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
#FUN-C30056----add---begin--------------
   IF s_industry("slk") THEN
      IF g_azw.azw04 = '2' THEN
         CALL p200_ins_pmnslk()
      END IF
   END IF
#FUN-C30056----end----------------------
END FUNCTION

#FUN-C30056----add----------------begin---------------------
FUNCTION p200_ins_pmnslk()
  DEFINE l_cnt           LIKE type_file.num10
  DEFINE l_pmnslk04      LIKE pmnslk_file.pmnslk04
  DEFINE l_pmnslk        RECORD LIKE pmnslk_file.*
  DEFINE l_ima151        LIKE ima_file.ima151
  DEFINE l_pmlslk21      LIKE pmlslk_file.pmlslk21
  DEFINE l_n             LIKE type_file.num5       #TQC-C40197--ADD---
  DEFINE l_pmnslk02      LIKE pmnslk_file.pmnslk02 #TQC-C40197--ADD-

  LET g_success = 'Y'
  DECLARE pmnslk_cs CURSOR FOR SELECT pmlslk04,pmlslk02 FROM pmlslk_file
                                WHERE pmlslk01=g_pmk.pmk01
                               
                                                             
  LET l_cnt=1
  INITIALIZE l_pmnslk.* TO NULL
  FOREACH pmnslk_cs INTO l_pmnslk.pmnslk04,l_pmnslk.pmnslk25

    LET l_pmnslk.pmnslk01 = g_pmm.pmm01
    LET l_pmnslk.pmnslk02 = l_cnt
    LET l_pmnslk.pmnslklegal = g_legal
    LET l_pmnslk.pmnslkplant = g_plant

    SELECT ima02 INTO l_pmnslk.pmnslk041 FROM ima_file WHERE ima01=l_pmnslk.pmnslk04

    SELECT DISTINCT pmn07,pmn08,pmn24,pmn30,pmn31,pmn31t,pmn33,pmn34,pmn35,
                    pmn52,pmn54,pmn56,pmn44,pmn73,pmn74
     INTO l_pmnslk.pmnslk07,l_pmnslk.pmnslk08,l_pmnslk.pmnslk24,l_pmnslk.pmnslk30,l_pmnslk.pmnslk31,
          l_pmnslk.pmnslk31t,l_pmnslk.pmnslk33,l_pmnslk.pmnslk34,l_pmnslk.pmnslk35,l_pmnslk.pmnslk52,
          l_pmnslk.pmnslk54,l_pmnslk.pmnslk56,l_pmnslk.pmnslk44,l_pmnslk.pmnslk73,l_pmnslk.pmnslk74
     FROM pmn_file,pmni_file
      WHERE pmn01=pmni01
        AND pmn02=pmni02
        AND pmn01=g_pmm.pmm01
        AND pmn24=g_pmk.pmk01
        AND pmnislk02=(SELECT pmlslk04 FROM pmlslk_file WHERE pmlslk01=g_pmk.pmk01 AND pmlslk02=l_pmnslk.pmnslk25)   

     SELECT SUM(pmn20),SUM(pmn88),SUM(pmn88t) INTO l_pmnslk.pmnslk20,l_pmnslk.pmnslk88,l_pmnslk.pmnslk88t
       FROM pmn_file,pmni_file WHERE pmn01=pmni01
                                 AND pmn02=pmni02
                                 AND pmn01=g_pmm.pmm01
                                 AND pmn24=g_pmk.pmk01
                                 AND pmn25 IN(SELECT pml02 FROM pml_file,pmli_file WHERE pml01=pmli01
                                                            AND pml02=pmli02
                                                            AND pmli01=g_pmk.pmk01             #请购单号
                                                            AND pmlislk03=l_pmnslk.pmnslk25)   #母料件項次

     IF SQLCA.sqlcode OR cl_null(l_pmnslk.pmnslk20) THEN
        CONTINUE FOREACH      #TQC-C40197--ADD-----
#        LET l_pmnslk.pmnslk20 =0  #TQC-C40197--mark-----
     END IF
     IF SQLCA.sqlcode OR cl_null(l_pmnslk.pmnslk88) THEN
        LET l_pmnslk.pmnslk88 = 0
     END IF
     IF SQLCA.sqlcode OR cl_null(l_pmnslk.pmnslk88t) THEN
        LET l_pmnslk.pmnslk88t = 0
     END IF
     CALL cl_digcut(l_pmnslk.pmnslk88,t_azi04) RETURNING  l_pmnslk.pmnslk88
     CALL cl_digcut(l_pmnslk.pmnslk88t,t_azi04) RETURNING l_pmnslk.pmnslk88t
#TQC-C40197---ADD----STR---     
     SELECT COUNT(*) INTO l_n FROM pmnslk_file 
      WHERE pmnslk01=g_pmm.pmm01 AND pmnslk04=l_pmnslk.pmnslk04
        AND pmnslk25= l_pmnslk.pmnslk25 AND pmnslk24=g_pmk.pmk01
     SELECT pmnslk02 INTO l_pmnslk02 FROM pmnslk_file 
      WHERE pmnslk01=g_pmm.pmm01 AND pmnslk04=l_pmnslk.pmnslk04
        AND pmnslk25= l_pmnslk.pmnslk25 AND pmnslk24=g_pmk.pmk01   
     IF l_n>0 THEN 
        UPDATE pmnslk_file SET pmnslk20=l_pmnslk.pmnslk20,
                               pmnslk88=l_pmnslk.pmnslk88,
                               pmnslk88t=l_pmnslk.pmnslk88t
         WHERE pmnslk01=g_pmm.pmm01 AND pmnslk04=l_pmnslk.pmnslk04 AND pmnslk02=l_pmnslk02
           AND pmnslk25= l_pmnslk.pmnslk25 AND pmnslk24=g_pmk.pmk01
        IF SQLCA.sqlcode  THEN
           CALL cl_err3("upd","pmnslk_file",g_pmm.pmm01,l_pmnslk02,SQLCA.sqlcode,"","upd pmnslk_file",1)
           LET g_success='N'
           EXIT FOREACH
        ELSE
           UPDATE pmni_file SET pmnislk03=l_pmnslk02 WHERE pmni01=g_pmm.pmm01 
                                               AND pmni02 IN (SELECT pmn02 FROM pmn_file WHERE pmn01=g_pmm.pmm01 
                                                                 AND pmn24=g_pmk.pmk01
                                                                 AND pmn25 IN(SELECT pml02 FROM pml_file,pmli_file WHERE pml01=pmli01
                                                                                AND pml02=pmli02
                                                                                AND pmli01=g_pmk.pmk01             #请购单号
                                                                                AND pmlislk03=l_pmnslk.pmnslk25))   #母料件項次
           IF SQLCA.sqlcode  THEN
              CALL cl_err3("upd","pmni_file",g_pmm.pmm01,'',SQLCA.sqlcode,"","upd pmni_file",1)
              LET g_success='N'
              EXIT FOREACH
           END IF
        END IF 
        
#        CONTINUE FOREACH 
     ELSE          
#TQC-C40197----ADD----END----     
        INSERT INTO pmnslk_file VALUES(l_pmnslk.*)
        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_success='N'
        ELSE
           UPDATE pmni_file SET pmnislk03=l_cnt WHERE pmni01=g_pmm.pmm01 
                                               AND pmni02 IN (SELECT pmn02 FROM pmn_file WHERE pmn01=g_pmm.pmm01 
                                                                 AND pmn24=g_pmk.pmk01
                                                                 AND pmn25 IN(SELECT pml02 FROM pml_file,pmli_file WHERE pml01=pmli01
                                                                                AND pml02=pmli02
                                                                                AND pmli01=g_pmk.pmk01             #请购单号
                                                                                AND pmlislk03=l_pmnslk.pmnslk25))   #母料件項次 
           IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
              LET g_success='N'
           END IF
        END IF
     END IF    #TQC-C40197----ADD----
     SELECT SUM(pml21) INTO l_pmlslk21 FROM pml_file
      WHERE pml01=g_pmk.pmk01
        AND pml02 IN(SELECT pml02 FROM pml_file,pmli_file WHERE pml01=pmli01
                                                            AND pml02=pmli02
                                                            AND pmli01=g_pmk.pmk01             #请购单号
                                                            AND pmlislk03=l_pmnslk.pmnslk25)   #母料件項次
     IF SQLCA.sqlcode OR cl_null(l_pmlslk21) THEN
        LET l_pmlslk21 = 0
     END IF
     UPDATE pmlslk_file SET pmlslk21=l_pmlslk21 WHERE pmlslk01=g_pmk.pmk01 AND pmlslk02=l_pmnslk.pmnslk25
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
        LET g_success='N'
     END IF
     INITIALIZE l_pmnslk.* TO NULL  #TQC-C40197-----ADD----
     IF l_n>0 THEN                  #TQC-C40197-----ADD----
        CONTINUE FOREACH             #TQC-C40197-----ADD----
     ELSE                           #TQC-C40197-----ADD----
        LET l_cnt=l_cnt+1    
     END IF                         #TQC-C40197-----ADD----  
  END FOREACH

END FUNCTION
#FUN-C30056----end--------------------------------
 
FUNCTION p200_ins_pmn()
   DEFINE l_flag   LIKE type_file.num5,           
          l_ima25  LIKE ima_file.ima25
   DEFINE l_pon07    LIKE pon_file.pon07
   DEFINE l_ima491   LIKE ima_file.ima491   #No.TQC-640132
   DEFINE l_ima49    LIKE ima_file.ima49    #No.TQC-640132
   DEFINE l_pmm09    LIKE pmm_file.pmm09,
          l_pmm22    LIKE pmm_file.pmm22,
          l_pmm04    LIKE pmm_file.pmm04,
          l_pmm21    LIKE pmm_file.pmm21,
          l_pmm43    LIKE pmm_file.pmm43,
          l_pmm42    LIKE pmm_file.pmm42
   DEFINE l_pmni     RECORD LIKE pmni_file.*  #No.FUN-830132
   DEFINE l_gec07    LIKE gec_file.gec07    #CHI-890026
   DEFINE l_pmh24    LIKE pmh_file.pmh24    #FUN-940083
   DEFINE l_pmc914   LIKE pmc_file.pmc914   #FUN-940083
   DEFINE l_rtz08    LIKE rtz_file.rtz08    #FUN-B40098
   DEFINE l_rtz07    LIKE rtz_file.rtz07    #FUN-B60150
   DEFINE l_pmn87    LIKE pmn_file.pmn87,   # TQC-BC0021
          l_cnt      LIKE type_file.num5
  #---產生採購單身資料
  
   IF (tm.g = '1' AND g_count <> 0 ) OR (tm.g = '2' AND g_count <> 0 ) THEN    
      SELECT pmk01 INTO g_pmn.pmn01 FROM pmk_temp
       WHERE pmk09 = g_pmm.pmm09
      SELECT MAX(pmn02) INTO g_pmn.pmn02 FROM pmn_file
       WHERE pmn01 = g_pmn.pmn01
      LET g_pmn.pmn02 = g_pmn.pmn02 + 1        
   ELSE       
      LET  g_pmn.pmn01=g_pmm.pmm01          #採購單號
   END IF
   LET  g_pmn.pmn011=g_pml.pml011        #採購性質
   LET  g_pmn.pmn03=g_pml.pml03          #詢價單號
   LET  g_pmn.pmn04=g_pml.pml04          #料號
   LET  g_pmn.pmn041=g_pml.pml041        #品名
   LET  g_pmn.pmn05=g_pml.pml05          #APS單號
   SELECT  pmh04 INTO g_pmn.pmn06 FROM pmh_file
      WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
        AND pmh13 = g_pmm.pmm22
        AND pmh21 = " "                                             #CHI-860042                                                     
        AND pmh22 = '1'                                             #CHI-860042
        AND pmhacti = 'Y'                                           #CHI-910021
#修改目的:若為MISC 則應保持原請購單位                                                                                               
  #TQC-C50067 -- mark -- begin
  #IF g_pml.pml04[1,4] = 'MISC' THEN                                                                                                
  #   LET g_pmn.pmn07 = g_pml.pml07                                                                                                 
  #ELSE                                                                                                                             
  #SELECT ima44 INTO g_pmn.pmn07 FROM ima_file
  # WHERE ima01 = g_pml.pml04
  #END IF  #CHI-970009    
  #TQC-C50067 -- mark -- end
   LET  g_pmn.pmn07=g_pml.pml07     #TQC-C50067 add
   LET  g_pmn.pmn20=g_pml.pml20 - g_pml.pml21 #數量
   LET  g_pmn.pmn20= s_digqty(g_pmn.pmn20,g_pmn.pmn07)    #FUN-BB0085
   LET  g_pmn.pmn930=g_pml.pml930        #成本中心 
   LET  g_pmn.pmn83=g_pml.pml83
   LET  g_pmn.pmn84=g_pml.pml84
   LET  g_pmn.pmn85=g_pml.pml85
   LET  g_pmn.pmn80=g_pml.pml80
   LET  g_pmn.pmn81=g_pml.pml81
   LET  g_pmn.pmn82=g_pml.pml82
   LET  g_pmn.pmn86=g_pml.pml86
# TQC-BC0021  mark begin
#   LET  g_pmn.pmn87=g_pml.pml87   
#   IF cl_null(g_pmn.pmn86) THEN
#       LET g_pmn.pmn86 = g_pmn.pmn07
#       LET g_pmn.pmn87 = g_pmn.pmn20
#   END IF
# TQC-BC0021  mark end
# TQC-BC0021 add begin
    #對是否已經轉過採購單進行統計
   SELECT COUNT(*) INTO l_cnt
     FROM pmn_file,pmm_file
    WHERE pmn01 = pmm01
      AND pmn24 = g_pml.pml01
      AND pmn25 = g_pml.pml02

      
      IF l_cnt > 0 THEN     
         #對已轉採購單的計價數量進行統計   
         SELECT SUM(pmn87) INTO l_pmn87 
           FROM pmn_file,pmm_file
          WHERE pmn01 = pmm01
            AND pmn24 = g_pml.pml01
            AND pmn25 = g_pml.pml02

               IF l_pmn87 IS NULL OR l_pmn87 = '' 
                  THEN LET l_pmn87 = 0 
               END IF 
          #採購單計價數量 = 請購單計價數量 - 此請購單已經轉採購單數量        
          LET  g_pmn.pmn87=g_pml.pml87 - l_pmn87  
       ELSE 
       	  LET  g_pmn.pmn87=g_pml.pml87
             IF cl_null(g_pmn.pmn86) THEN
                LET g_pmn.pmn86 = g_pmn.pmn07
                LET g_pmn.pmn87 = g_pmn.pmn20
             END IF
       END IF 
# TQC-BC0021 add end
   LET  g_pmn.pmn08=g_pml.pml08          #庫存單位
   IF g_pml.pml04[1,4] <> 'MISC' THEN
      CALL s_umfchk(g_pml.pml04,g_pmn.pmn07,g_pml.pml08) #CHI-970009     
          RETURNING l_flag,g_pmn.pmn09      #取換算率(採購對庫存)
     IF l_flag=1 THEN
         CALL cl_err('pmn07/pml08: ','abm-731',1)
         LET g_success ='N'
     END IF
   ELSE   #MOD-920208
     LET g_pmn.pmn09 = 1   #MOD-920208
   END IF
   LET  g_pmn.pmn11=g_pml.pml11          #凍結碼
   LET  g_pmn.pmn121=1                    #採購對請購之轉換率
   LET  g_pmn.pmn122=g_pml.pml12         #no use-> 專案代號 
   IF cl_null(g_pmn.pmn122) THEN LET g_pmn.pmn122=' ' END IF 
   LET  g_pmn.pmn123=g_pml.pml123        #No use
 
   IF cl_null(g_pmn.pmn123) THEN
      SELECT pmh07 INTO g_pmn.pmn123 FROM pmh_file
       WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
         AND pmh13 = g_pmm.pmm22
         AND pmh21 = " "                                             #CHI-860042                                                    
         AND pmh22 = '1'                                             #CHI-860042
         AND pmhacti = 'Y'                                           #CHI-910021
   END IF
 
   LET  g_pmn.pmn13=g_pml.pml13          #超短交限率
   LET  g_pmn.pmn14=g_pml.pml14          #部份交貨否
   LET  g_pmn.pmn15=g_pml.pml15          #提前交貨否
   LET  g_pmn.pmn16='0'
   LET  g_pmn.pmn23=' '                   #送貨地址
   LET  g_pmn.pmn24=g_pml.pml01              #請購單號
   LET  g_pmn.pmn25=g_pml.pml02    #序號
   LET  g_pmn.pmn30=g_pml.pml30          #標準價格
 
   IF g_pml.pml04[1,4] <> 'MISC' THEN
      CALL s_defprice_new(g_pmn.pmn04,g_pmm.pmm09,g_pmm.pmm22,g_pmm.pmm04,g_pmn.pmn87,'',g_pmm.pmm21,g_pmm.pmm43,'1',g_pmn.pmn86,''
                      ,g_pmm.pmm41,g_pmm.pmm20,g_plant)  #TQC-9B0214
 #        RETURNING g_pmn.pmn31,g_pmn.pmn31t                 #MOD-AC0193
          RETURNING g_pmn.pmn31,g_pmn.pmn31t,g_pmn.pmn73,g_pmn.pmn74    #TQC-AC0257 add
   ELSE
      LET g_pmn.pmn31 = 0
      LET g_pmn.pmn31t = 0
   END IF
   IF cl_null(g_pmn.pmn31) THEN LET g_pmn.pmn31 = 0 END IF #TQC-BB0212
   IF cl_null(g_pmn.pmn31t) THEN LET g_pmn.pmn31t = 0 END IF  
   IF cl_null(g_pmn.pmn73) THEN LET g_pmn.pmn73 ='4' END IF    #TQC-AC0257 add
   LET  g_pmn.pmn34=g_pml.pml34
   SELECT ima49,ima491 INTO l_ima49,l_ima491 FROM ima_file
   WHERE ima01=g_pmn.pmn04
   CALL s_aday(g_pmn.pmn34,-1,l_ima49) RETURNING g_pmn.pmn33
   CALL s_aday(g_pmn.pmn34,1,l_ima491) RETURNING g_pmn.pmn35
   LET  g_pmn.pmn36=NULL                  #最近確認交貨日期
   LET  g_pmn.pmn37=NULL                  #最後一次到廠日期
   LET  g_pmn.pmn38=g_pml.pml38          #可用/不可用
   LET  g_pmn.pmn40=g_pml.pml40          #會計科目
   LET  g_pmn.pmn919=g_pml.pml919        #計畫批號   #FUN-A80150 add
   LET  g_pmn.pmn41=g_pml.pml41          #工單號碼
   LET  g_pmn.pmn42=g_pml.pml42          #替代碼
   LET  g_pmn.pmn43=g_pml.pml43          #作業序號
   LET  g_pmn.pmn431=g_pml.pml431        #下一站作業序號
   LET  g_pmn.pmn44 = g_pmn.pmn31 * g_pmm.pmm42  #本幣單價
   LET  g_pmn.pmn45=NULL                  #NO:7190
   LET  g_pmn.pmn50=0                     #交貨量
   LET  g_pmn.pmn51=0                     #在驗量
   LET  g_pmn.pmn53=0                     #入庫量
   LET g_pmn.pmn122 = g_pml.pml12   #專案代號
   LET g_pmn.pmn96 =  g_pml.pml121  #WBS
   LET g_pmn.pmn97 =  g_pml.pml122  #活動
   LET g_pmn.pmn98 =  g_pml.pml90   #費用原因
   LET g_pmn.pmn100 = g_pml.pml06   #FUN-D40042 備註
   SELECT ima35,ima36 INTO g_pmn.pmn52,g_pmn.pmn54 FROM ima_file
   WHERE ima01=g_pmn.pmn04
  #FUN-B60150 Begin---
  ##FUN-B40098 Begin---
  #IF g_azw.azw04 = '2' AND g_pmm.pmm51 = '3' THEN
  #   SELECT rtz08 INTO l_rtz08 FROM rtz_file
  #    WHERE rtz01 = g_pmm.pmmplant
  #   IF NOT cl_null(l_rtz08) THEN
  #      LET g_pmn.pmn52 = l_rtz08
  #      LET g_pmn.pmn54 = ' '
  #      LET g_pmn.pmn56 = ' '
  #   END IF
  #END IF
  ##FUN-B40098 End-----
   IF g_azw.azw04 = '2' THEN
      #FUN-C90049 mark begin---
      #SELECT rtz07,rtz08 INTO l_rtz07,l_rtz08 FROM rtz_file
      # WHERE rtz01 = g_pmm.pmmplant
      #FUN-C90049 mark end-----

      CALL s_get_defstore(g_pmm.pmmplant,g_pmn.pmn04) RETURNING l_rtz07,l_rtz08    #FUN-C90049 add
      IF (g_pmm.pmm51 = '3' OR (g_pmm.pmm51 = '2' AND g_sma.sma146 = '2'))THEN
         IF NOT cl_null(l_rtz08) THEN
            LET g_pmn.pmn52 = l_rtz08
            LET g_pmn.pmn54 = ' '
            LET g_pmn.pmn56 = ' '
         END IF
      END IF
      IF g_pmm.pmm51 = '2' AND g_sma.sma146 = '1' THEN
         IF NOT cl_null(l_rtz07) THEN
            LET g_pmn.pmn52 = l_rtz07
            LET g_pmn.pmn54 = ' '
            LET g_pmn.pmn56 = ' '
         END IF
      END IF
   END IF
  #FUN-B60150 End-----
   LET  g_pmn.pmn55=0                     #驗退量
   LET  g_pmn.pmn56=' '                   #批號
   LET  g_pmn.pmn57=0                     #超短交量
   LET  g_pmn.pmn58=0                     #無交期性採購單已轉量
   LET  g_pmn.pmn59=' '                   #退貨單號
   LET  g_pmn.pmn60=' '                   #項次
   LET  g_pmn.pmn61=g_pmn.pmn04           #被替代料號
   LET  g_pmn.pmn62=1                     #替代率
   LET  g_pmn.pmn63='N'                   #急料否
   LET  g_pmn.pmn67=g_pml.pml67
   LET g_pmn.pmn88  = g_pmn.pmn31  * g_pmn.pmn87   #未稅金額
   LET g_pmn.pmn88t = g_pmn.pmn31t * g_pmn.pmn87   #含稅金額
   SELECT gec07 INTO l_gec07 FROM gec_file  
     WHERE gec01 = g_pmm.pmm21 
   SELECT azi03,azi04 INTO t_azi03,t_azi04 FROM azi_file
    WHERE azi01=g_pmm.pmm22 AND aziacti = 'Y' 
   IF l_gec07 = 'N' THEN 
      LET g_pmn.pmn88t = g_pmn.pmn88 * ( 1 + g_pmm.pmm43/100)
   ELSE
      LET g_pmn.pmn88  = g_pmn.pmn88t / ( 1 + g_pmm.pmm43/100)
   END IF
   LET g_pmn.pmn88  = cl_digcut(g_pmn.pmn88,t_azi04)
   LET g_pmn.pmn88t = cl_digcut(g_pmn.pmn88t,t_azi04)
   LET g_pmn.pmn68 = ''
   LET g_pmn.pmn69 = '' #TQC-BC0135
   LET g_pmn.pmn70 = 0
 
   SELECT ima15 INTO g_pmn.pmn64 FROM ima_file
    WHERE ima01=g_pml.pml04
   IF cl_null(g_pmn.pmn64) OR g_pmn.pmn64 NOT MATCHES '[YN]' THEN
      LET  g_pmn.pmn64='N'
   END IF
   LET g_pmn.pmn65='1'                   #一般/代買
   LET g_pmn.pmn90=g_pmn.pmn31          
 
   SELECT  pmh24 INTO l_pmh24 FROM pmh_file
      WHERE pmh01 = g_pmn.pmn04 AND pmh02 = g_pmm.pmm09
        AND pmh13 = g_pmm.pmm22
        AND pmh21 = " "     
        AND pmh22 = '1'    
        AND pmhacti = 'Y'
   IF NOT cl_null(l_pmh24) THEN 
      LET g_pmn.pmn89=l_pmh24
   ELSE
      SELECT pmc914 INTO l_pmc914 FROM pmc_file
       WHERE pmc01 = g_pmm.pmm09
      IF l_pmc914 ='Y' THEN
         LET g_pmn.pmn89='Y'
      ELSE    
         LET g_pmn.pmn89='N'
      END IF
   END IF
 
   IF cl_null(g_pmn.pmn01) THEN LET g_pmn.pmn01 = ' ' END IF
   IF cl_null(g_pmn.pmn02) THEN LET g_pmn.pmn02 = 0 END IF
#   LET g_pmn.pmn73 = ' '                                   #MOD-AC0193
   LET g_pmn.pmnplant = g_plant #FUN-980006 add
   LET g_pmn.pmnlegal = g_legal #FUN-980006 add
   IF cl_null(g_pmn.pmn58) THEN LET g_pmn.pmn58 = 0 END IF   #TQC-9B0203
   IF cl_null(g_pmn.pmn012) THEN LET g_pmn.pmn012 = ' ' END IF   #TQC-A70004
   CALL s_schdat_pmn78(g_pmn.pmn41,g_pmn.pmn012,g_pmn.pmn43,g_pmn.pmn18,   #FUN-C10002
                                   g_pmn.pmn32) RETURNING g_pmn.pmn78      #FUN-C10002
   INSERT INTO pmn_file VALUES(g_pmn.*)
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p200_ins_pmn():",SQLCA.sqlcode,1)  
      LET g_success = 'N'
      RETURN
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmni.* TO NULL
         LET l_pmni.pmni01 = g_pmn.pmn01
         LET l_pmni.pmni02 = g_pmn.pmn02
#FUN-C30056---add------------------
         IF s_industry("slk") THEN
            IF g_azw.azw04 = '2' THEN
               SELECT DISTINCT(COALESCE(imx00,pmn04)) INTO l_pmni.pmnislk02 
                FROM pmn_file LEFT JOIN imx_file ON imx000=pmn04  #存取母料件料號
                WHERE pmn01=g_pmn.pmn01
                  AND pmn02=g_pmn.pmn02
            END IF 
         END IF 
#FUN-C30056---end------------------

         IF NOT s_ins_pmni(l_pmni.*,'') THEN 
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
   CALL p200_upd_pml()  #MOD-810197 
 
END FUNCTION
 
FUNCTION p200_ins_pmo()
  DEFINE l_pmn24    LIKE pmn_file.pmn24
  DEFINE l_pmn02    LIKE pmn_file.pmn02   #MOD-8A0271
  DEFINE l_pmn25    LIKE pmn_file.pmn25   #MOD-8A0271
  DEFINE l_pmp      RECORD LIKE pmp_file.*
  DEFINE l_pmp_t    RECORD LIKE pmp_file.*
  DEFINE l_pmp04_t  LIKE pmp_file.pmp04
  DEFINE l_pmo      RECORD LIKE pmo_file.*
  DEFINE l_pmo_t    RECORD LIKE pmo_file.*
  DEFINE l_i        LIKE pmo_file.pmo05
  DEFINE l_pmo05_t  LIKE pmo_file.pmo05
 
  DECLARE pmn_curs CURSOR FOR 
    SELECT DISTINCT(pmn24) FROM pmm_file,pmn_file 
      WHERE pmm01=pmn01 AND pmm01 = g_pmm.pmm01
 
  #抓取備註
  LET l_i = 1
  FOREACH pmn_curs INTO l_pmn24
    DECLARE pmp_curs_1 CURSOR FOR 
      SELECT * FROM pmp_file WHERE pmp01 = l_pmn24 ORDER BY pmp03,pmp04
    FOREACH pmp_curs_1 INTO l_pmp.* 
      LET l_pmp.pmp01 = g_pmm.pmm01
      LET l_pmp.pmp02 = '1' 
      LET l_pmp.pmp04 = l_i
      LET l_pmp.pmpplant = g_plant #FUN-980006 add
      LET l_pmp.pmplegal = g_legal #FUN-980006 add
      INSERT INTO pmp_file VALUES (l_pmp.*)
      IF STATUS OR SQLCA.SQLCODE THEN 
         LET g_success='N'
         CALL cl_err3("ins","pmp_file",l_pmp.pmp01,"",SQLCA.SQLCODE,"","ins pmp",1)
         RETURN
      END IF
      LET l_i = l_i + 1
    END FOREACH
  END FOREACH
  DECLARE pmp_curs_2 CURSOR FOR
     SELECT * FROM pmp_file WHERE pmp01 = g_pmm.pmm01 ORDER BY pmp03,pmp04
  FOREACH pmp_curs_2 INTO l_pmp.*
     IF l_pmp_t.pmp03 <> l_pmp.pmp03 THEN
        LET l_pmp04_t = l_pmp.pmp04
        LET l_pmp.pmp04 = 1
     ELSE
        IF NOT cl_null(l_pmp_t.pmp03) THEN  
           LET l_pmp04_t = l_pmp.pmp04
           LET l_pmp.pmp04 = l_pmp_t.pmp04 + 1
        ELSE
           LET l_pmp04_t = l_pmp.pmp04
        END IF
     END IF
     UPDATE pmp_file SET pmp04=l_pmp.pmp04 WHERE pmp01=l_pmp.pmp01 AND
                                             pmp03=l_pmp.pmp03 AND 
                                             pmp04=l_pmp04_t
     LET l_pmp_t.* = l_pmp.*
  END FOREACH
 
 
  #抓取特別說明
  LET l_i = 1
  FOREACH pmn_curs INTO l_pmn24
    DECLARE pmo_curs_1 CURSOR FOR 
      SELECT * FROM pmo_file WHERE pmo01 = l_pmn24 AND pmo03 = '0' ORDER BY pmo04,pmo05   #MOD-8A0271
    FOREACH pmo_curs_1 INTO l_pmo.* 
      LET l_pmo.pmo01 = g_pmm.pmm01
      LET l_pmo.pmo05 = l_i
      LET l_pmo.pmoplant = g_plant #FUN-980006 add
      LET l_pmo.pmolegal = g_legal #FUN-980006 add
      INSERT INTO pmo_file VALUES (l_pmo.*)
      IF STATUS OR SQLCA.SQLCODE THEN 
         LET g_success='N'
         CALL cl_err3("ins","pmo_file",l_pmo.pmo01,"",SQLCA.SQLCODE,"","ins pmo",1)
         RETURN
      END IF
      LET l_i = l_i + 1
    END FOREACH
  END FOREACH
  DECLARE pmo_curs_2 CURSOR FOR
     SELECT * FROM pmo_file WHERE pmo01 = g_pmm.pmm01 ORDER BY pmo04,pmo05
  FOREACH pmo_curs_2 INTO l_pmo.*
     IF l_pmo_t.pmo04 <> l_pmo.pmo04 THEN
        LET l_pmo05_t = l_pmo.pmo05
        LET l_pmo.pmo05 = 1
     ELSE
        IF NOT cl_null(l_pmo_t.pmo04) THEN  
           LET l_pmo05_t = l_pmo.pmo05
           LET l_pmo.pmo05 = l_pmo_t.pmo05 + 1
        ELSE
           LET l_pmo05_t = l_pmo.pmo05
        END IF
     END IF
     UPDATE pmo_file SET pmo05=l_pmo.pmo05 WHERE pmo01=l_pmo.pmo01 AND
                                             pmo04=l_pmo.pmo04 AND 
                                             pmo05=l_pmo05_t
     LET l_pmo_t.* = l_pmo.*
  END FOREACH
  DECLARE pmn_curs2 CURSOR FOR 
    SELECT DISTINCT pmn02,pmn24,pmn25 FROM pmm_file,pmn_file 
      WHERE pmm01=pmn01 AND pmm01 = g_pmm.pmm01
 
  LET l_i = 1
  FOREACH pmn_curs2 INTO l_pmn02,l_pmn24,l_pmn25   
    DECLARE pmo_curs_1_2 CURSOR FOR 
      SELECT * FROM pmo_file WHERE pmo01 = l_pmn24 AND pmo03 = l_pmn25 ORDER BY pmo03,pmo04,pmo05  
    FOREACH pmo_curs_1_2 INTO l_pmo.* 
      LET l_pmo.pmo01 = g_pmm.pmm01
      LET l_pmo.pmo03 = l_pmn02
      LET l_pmo.pmo05 = l_i
      LET l_pmo.pmoplant = g_plant #FUN-980006 add
      LET l_pmo.pmolegal = g_legal #FUN-980006 add
      INSERT INTO pmo_file VALUES (l_pmo.*)
      IF STATUS OR SQLCA.SQLCODE THEN 
         LET g_success='N'
         CALL cl_err3("ins","pmo_file",l_pmo.pmo01,"",SQLCA.SQLCODE,"","ins pmo",1)
         RETURN
      END IF
      LET l_i = l_i + 1
    END FOREACH
  END FOREACH
  DECLARE pmo_curs_2_2 CURSOR FOR
     SELECT * FROM pmo_file WHERE pmo01 = g_pmm.pmm01 ORDER BY pmo03,pmo04,pmo05   
  FOREACH pmo_curs_2_2 INTO l_pmo.*
     IF l_pmo_t.pmo04 <> l_pmo.pmo04 THEN
        LET l_pmo05_t = l_pmo.pmo05
        LET l_pmo.pmo05 = 1
     ELSE
        IF NOT cl_null(l_pmo_t.pmo04) THEN  
           LET l_pmo05_t = l_pmo.pmo05
           LET l_pmo.pmo05 = l_pmo_t.pmo05 + 1
        ELSE
           LET l_pmo05_t = l_pmo.pmo05
        END IF
     END IF
     UPDATE pmo_file SET pmo05=l_pmo.pmo05 WHERE pmo01=l_pmo.pmo01 AND
                                             pmo04=l_pmo.pmo04 AND 
                                             pmo05=l_pmo05_t
     LET l_pmo_t.* = l_pmo.*
  END FOREACH
END FUNCTION
 
FUNCTION p200_upd_pmm()
 # DEFINE l_pmm40  LIKE pmn_file.pmn40,     #TQC-AB0038 mark
   DEFINE l_pmm40  LIKE pmm_file.pmm40,     #TQC-AB0038 add
          l_pmm40t LIKE pmm_file.pmm40t
 
  SELECT SUM(pmn88),SUM(pmn88t) 
     INTO l_pmm40,l_pmm40t
     FROM pmn_file
    WHERE pmn01 = g_pmm.pmm01
   LET l_pmm40 = cl_digcut(l_pmm40,t_azi05)
   LET l_pmm40t= cl_digcut(l_pmm40t,t_azi05)
   UPDATE pmm_file SET pmm40 = l_pmm40,
                       pmm40t= l_pmm40t
    WHERE pmm01 = g_pmm.pmm01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p200_upd_pmm():",SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN
   END IF
 
   UPDATE pmk_file SET pmk25 = '2'
    WHERE pmk01 = g_pmk.pmk01
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p200_upd_pmk():",SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION p200_upd_pml()
   DEFINE l_pmn20  LIKE pmn_file.pmn20
   DEFINE l_pml07  LIKE pml_file.pml07  #No:FUN-BB0086 add 
 
    SELECT SUM(pmn20/pmn62*pmn121) INTO l_pmn20 FROM pmn_file
     WHERE pmn24 = g_pmn.pmn24 AND pmn25 = g_pmn.pmn25
       AND pmn16<>'9'       #取消(Cancel)
   IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
   
   #No:FUN-BB0086--start--add--
   SELECT pml07 INTO l_pml07 FROM pml_file WHERE pml01 = g_pmn.pmn24 AND pml02 = g_pmn.pmn25
   LET l_pmn20 = s_digqty(l_pmn20,l_pml07)
   #No:FUN-BB0086--end--add--
   
   UPDATE pml_file SET pml21 = l_pmn20,pml16='2'
    WHERE pml01 = g_pmn.pmn24 AND pml02 = g_pmn.pmn25
      AND pml92 <> 'Y'       #No.FUN-A10034
   IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('','',"p200_upd_pml():",SQLCA.sqlcode,1)   
      LET g_success = 'N'
      RETURN
   ELSE
      UPDATE pmk_file SET pmk25 = '2'
       WHERE pmk01 = g_pmn.pmn24
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","pmk_file",g_pmn.pmn24,"",SQLCA.sqlcode,"","pmn24 update pmk25",1)  #No.FUN-660129
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION
FUNCTION p200_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pml83,pml85,pml80,pml82",FALSE)
      CALL cl_set_comp_visible("pml07,pml20",TRUE)
   ELSE
      CALL cl_set_comp_visible("pml07,pml20",FALSE)
      CALL cl_set_comp_visible("pml83,pml85,pml80,pml82",TRUE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN 
       CALL cl_set_comp_visible("pml86,pml87",FALSE)
   ELSE   
       CALL cl_set_comp_visible("pml86,pml87",TRUE)
   END IF
   CALL cl_set_comp_visible("pml81,pml84",FALSE)
   CALL cl_set_comp_visible("pml919",g_sma.sma1421='Y')   #FUN-A80150 add 
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pml83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pml85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pml80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pml82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pml83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pml85",g_msg CLIPPED)
      CALL cl_getmsg('asm-359',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pml80",g_msg CLIPPED)
      CALL cl_getmsg('asm-360',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pml82",g_msg CLIPPED)
   END IF
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: apmt580.4gl
# Descriptions...: 無交期性採購單資料維護作業
# Date & Author..: 01/03/23 By Kammy
# Modify.........: No:7857 03/08/20 By Mandy  呼叫自動取單號時應在 Transction中
# Modify.........: No.8618 03/11/27 Apple 改公式g_pmn[l_ac].pmn31*g_pmm.pmm42> l_ima53* (1+g_sma.sma84/100)
# Modify.........: No.8752 03/11/27 Apple 在 g_sma.sma109='R' 時也應顯示錯誤訊息。
# Modify.........: No.MOD-480239 04/08/10 Wiky copy 寫法不正確
# Modify.........: No.MOD-490284 04/09/16 By Smapmin以彈跳視窗顯示警告訊息
# Modify.........: No.MOD-490337 04/09/20 By Smapmin顯示總金額
# Modify.........: No.MOD-4A0252 04/10/22 By Smapmin採購單號開窗
# Modify.........: No.FUN-4B0025 04/11/05 By Smapmin ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0051 04/11/24 By Mandy 匯率加開窗功能
# Modify.........: No.MOD-4B0276 04/11/26 By Mandy LET g_qryparam.where = " AND ........."
# Modify.........: No.MOD-4B0276                                            ^^^最一開始這�不能有AND 否則組SQL會錯
# Modify.........: No.MOD-4B0255 04/11/26 By Mandy 串apmi600時,可針對供應商顯示相關的資料,如果供應商空白則可查詢全部的資料
# Modify.........: No.FUN-4C0056 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: No.FUN-4C0074 04/12/14 By pengu  匯率幣別欄位修改，與aoos010的azi17做判斷，
                                                    #如果二個幣別相同時，匯率強制為 1
# Modify.........: No.MOD-530190 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式 or DEC(20,6)
# Modify.........: No.FUN-550098 05/05/20 By Elva  雙單位內容修改
# Modify.........: No.FUN-550089 05/05/26 By Danny 採購含稅單價
#                                                  BUG處理,若pon31有值,則不CALL s_defprice
# Modify.........: NO.FUN-540027 05/05/31 By jackie 單據編號加大
# Modify.........: No.FUN-560020 05/06/08 By Elva  雙單位內容調整
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.FUN-560194 05/06/22 By Elva  默認用ima44為單位一
# Modify.........: No.MOD-590119 05/09/09 By Carrier 多單位set_origin_field修改
# Modify.........: No.MOD-590346 05/09/16 By Carrier mark du_default()
# Modify.........: No.MOD-580341 05/10/19 By Nicola 按取消時，不詢問是否要列印
# Modify.........: No.MOD-580389 05/10/19 By Nicola p_zz中沒有設定"修改時可以修改Key值"採購單號"
# Modify.........: NO.TQC-5A0096 05/10/26 By Niocla 單據性質取位修改
# Modify.........: No.TQC-5C0014 05/12/05 By Carrier set_required時去除單位換算率
# Modify.........: No.FUN-560029 06/01/11 By Echo 刪除「簽核狀況」button
# Modify.........: No.FUN-610018 06/01/08 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-610067 06/02/06 By Smapmin 雙單位畫面調整
# Modify.........: No.FUN-630010 06/03/08 By saki 流程訊息通知功能
# Modify.........: No.TQC-610060 06/03/21 By Ray 修改pom01欄位的AFTER FIELD事件中的條件判斷語句(AND改為OR)
# Modify.........: No.TQC-610085 06/04/06 By Claire Review所有報表程式接收的外部參數是否完整
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: No.MOD-640325 06/04/10 By Carol 無交期採購單輸入不需要由asms250[採購單直接輸入否(sma45)]控管
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.MOD-660086 06/07/05 By Sarah 查詢一筆未確認的單號後按新增再放棄,再按作廢,之前查詢的那筆會被作廢掉
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.TQC-630284 06/07/12 By Pengu 隱藏無權限按鈕功能修改
# Modify.........: No.FUN-650191 06/08/14 By rainy pmw03 改抓pmx12
# Modify.........: No.FUN-680029 06/08/24 By Rayven 新增apmq650參數
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理修改
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-690022 06/09/21 By jamie 判斷imaacti
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼pmc05
# Modify.........: No.CHI-6A0004 06/10/31 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6A0079 06/10/31 By king 改正被誤定義為apm08類型的
# Modify.........: No.FUN-6B0032 06/11/13 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.FUN-6A0162 06/11/16 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-6B0124 06/12/19 By pengu 參數勾選不使用多單位但使用計價單位時，計價單位與計價數量會異常
# Modify.........: No.FUN-6C0055 07/01/08 By Joe 新增與GPM整合的顯示及查詢的Toolbar
# Modify.........: No.TQC-710037 07/01/10 By Ray 增加無資料時按供應商資料按紐報錯 
# Modify.........: No.TQC-710042 07/01/11 By Joe 解決未經設定整合之工廠,會有Action顯示異常情況出現
# Modify.........: No.FUN-710030 07/02/05 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730033 07/03/27 By Carrier 會計科目加帳套
# Modify.........: No.FUN-730068 07/03/30 By kim 行業別架構
# Modify.........: No.FUN-740029 07/04/10 By dxfwo    會計科目加帳套
# Modify.........: No.FUN-740033 07/03/27 By Carrier 會計科目加帳套-afa_file要傳帳套
# Modify.........: No.TQC-740082 07/04/13 By Ray 輸入狀態下，在料件欄位會被LOCK，無法離開。只能按退出鈕，才能退出
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.FUN-710060 07/08/08 By jamie 料件供應商管制建議依品號設定;程式中原判斷sma63=1者改為判斷ima915=2 OR 3
# Modify.........: No.MOD-730044 07/09/19 By claire 需考慮採購單位與料件採購資料的採購單位換算
# Modify.........: No.MOD-7A0101 07/10/18 By claire mfg3227訊息改為apm-420
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.TQC-7C0089 07/12/08 By heather 給"發票扣扺區分"欄位設定缺省值
# Modify.........: No.FUN-810017 08/02/28 By jan 新增服飾作業
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-810181 08/01/22 By ve007 s_defprice()增加一參數
# Modify.........: No.FUN-7B0018 08/02/01 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-810045 08/02/13 By rainy 項目管理，單頭pom05(專案代號)顯示，前於轉入採購單時帶入pmm05
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業別拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830161 08/04/01 By Carrier 去掉預算編號pom06
# Modify.........: No.FUN-840042 08/04/15 By TSD.Wind 自定欄位功能修改
# Modify.........: No.MOD-840127 08/04/16 By Dido pon 預設值應與雙單位無關
# Modify.........: No.TQC-860019 08/06/09 By cliare ON IDLE 控制調整
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: NO.FUN-880016 08/08/21 BY yiting 增加GPM控管
# Modify.........: NO.FUN-8A0054 08/10/13 BY sabrina 若沒有勾選〝與GPM整合〞，則不做GPM控管
# Modify.........: No.MOD-8B0273 08/12/01 By chenyu 1.單頭單價含稅時，未稅單價=未稅金額/計價數量
#                                                   2.標准版的單身錄入時，沒有更新單頭的金額，只有再修改單身或刪除一筆單身之后才會update
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-930113 09/03/19 By mike 將oah_file-->pnz_file
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.MOD-950258 09/05/26 By Smapmin 複製時不會自動編號
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.FUN-980006 09/08/17 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930152 09/08/28 By chenmoyan '運送方式'欄位改為開窗,并帶出運送方式的名稱
# Modify.........: No.CHI-960033 09/10/10 By chenmoyan 加pmh22為條件者，再加pmh23=''
# Modify.........: No.CHI-960022 09/10/15 By chenmoyan 預設單位一數量時，加上判斷，單位一數量為空或為1時，才預設
# Modify.........: No.CHI-960052 09/10/15 By chenmoyan 使用多單位，料件是單一單位或參考單位時，單位一的轉換率錯誤
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No:CHI-9C0002 09/12/15 By Smapmin special_description加入權限控管
# Modify.........: No:MOD-9C0285 09/12/21 By Cockroach 檢查價格以決定欄位是否可以錄入
# Modify.........: No:FUN-9C0071 10/01/06 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:MOD-A30079 10/03/12 By Smapmin 取消確認一開始就要重抓單頭資料
# Modify.........: No:FUN-A20044 10/03/24 By JIACHENCHAO 更改關於字段ima26*的相關語句 
# Modify.........: No:FUN-A40023 10/03/24 By JIACHENCHAO 更改關於字段ima26*的相關語句 
# Modify.........: No.FUN-A80001 10/08/02 By destiny 增加截止日期
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.FUN-AB0066 10/11/18 By lilingyu 審核段增加倉庫權限控管
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No:CHI-B10026 11/01/13 By Smapmin 無權限的時候沒有顯示訊息 
# Modify.........: No:CHI-B10034 10/01/21 By Smapmin 確認時沒有回寫確認人
# Modify.........: No:MOD-B30413 11/03/16 By Summer 追CHI-A40019單,單頭的供應商.幣別.採購日期.稅別.稅率等欄位有異動時,詢問是否update單身單價
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-B50063 11/06/01 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No:FUN-B70121 11/07/28 By zhangll 增加pnz07判斷，決定取到了單價是否可以修改
# Modify.........: No:CHI-B80082 11/09/01 By johung 將apm-281控卡改為判斷是否存在pmh_file，存在才允許修改
# Modify.........: No.FUN-BB0085 11/11/22 By xianghui 增加數量欄位小數取位
# Modify.........: No.TQC-C10020 12/01/05 By suncx 無資料時，點擊複製和更改時報錯信息內容不對
# Modify.........: No.TQC-C10021 12/01/05 By suncx CHI-B80082卡控時未完全卡控住資料
# Modify.........: No.TQC-BC0216 12/01/05 By suncx 品名規格資料帶出值錯誤
# Modify.........: No:TQC-BB0172 12/01/09 By destiny 变更采购单日期后应提示是否需要变更汇率
# Modify.........: No:TQC-BB0177 12/01/09 By destiny 1.oriu,orig无法查询 2.多次复制同一笔资料采购单号会无法输入
# Modify.........: No:TQC-BC0174 12/02/09 By destiny 填完供应商后自动带出相对应汇率 
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.FUN-C20068 12/02/10 By xianghui 對FUN-BB0085進行調整
# Modify.........: No.TQC-C20183 12/02/21 By fengrui 數量欄位小數取位處理
# Modify.........: No:TQC-BC0214 12/02/28 By lilingyu 錄入單身第二筆資料後再刪除，就無法回到第一筆資料
# Modify.........: No:TQC-C30126 12/03/07 By suncx 最近更改者欄位查詢和更改時錯誤  
# Modify.........: No:FUN-C30057 12/04/12 By linlin 服飾二維開發
# Modify.........: No:FUN-BC0088 12/05/10 By Vampire 判斷MISC料可輸入單價
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C40157 12/06/18 By zhuhao 修改單頭價格條件，跳出【是否重取單身所有價格】的訊息。
# Modify.........: No.TQC-C60178 12/06/26 By zhuhao 採購部門審核時進行校驗和控卡
# Modify.........: No:FUN-C60091 12/06/27 By qiaozy 未稅單價未帶出
# Modify.........: No:FUN-C60100 12/06/27 By qiaozy 服飾流通：快捷鍵controlb的問題，切換的標記請在BEFORE INPUT 賦值
# Modify.........: No:TQC-C60245 12/06/29 By zhuhao 修改g_action_choice默認值問題
# Modify.........: No:FUN-C30085 12/07/04 By nanbing CR改串GR
# Modify.........: No.FUN-C70098 12/07/24 By xjll  服飾流通二維，不可審核數量為零的母單身資料
# Modify.........: No:FUN-C80046 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:FUN-CB0014 12/11/13 By lixh1 增加資料清單
# Modify.........: No.CHI-C80041 12/11/27 By bart 取消單頭資料控制
# Modify.........: No.TQC-D10084 13/01/28 By xianghui 資料清單頁簽下隱藏一部分ACTION
# Modify.........: No.FUN-D20025 13/02/21 By nanbing 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:CHI-C10037 13/02/22 By Elise s_sizechk.4gl目前只有判斷採購單位，應該要考慮單據單位
# Modify.........: No.CHI-D30005 13/04/09 By Elise 串查apmi600第一個參數g_argv1為廠商代號,第二個g_argv2為執行功能
# Modify.........: No.TQC-D40036 13/04/17 By xumm 取消审核更新审核异动人员
# Modify.........: No:FUN-D30034 13/04/18 By chenjing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:TQC-D40025 13/04/19 By chenjing 修改FUN-D30034遺留問題
# Modify.........: No:TQC-D50078 13/07/15 By qirl 更改供應商后報錯,有供應商管控時，直接帶出apmi254中的【幣種】

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../apm/4gl/sapmt580.global"
GLOBALS "../../axm/4gl/s_slk.global"    #FUN-C30057

DEFINE g_pmn73  LIKE pmn_file.pmn73,    #TQC-AC0257 add
       g_pmn74  LIKE pmn_file.pmn74     #TQC-AC0257 add
DEFINE g_pon07_t LIKE pon_file.pon07    #FUN-BB0085
DEFINE g_pon80_t LIKE pon_file.pon80    #FUN-BB0085
DEFINE g_pon83_t LIKE pon_file.pon83    #FUN-BB0085
DEFINE g_pon86_t LIKE pon_file.pon86    #FUN-BB0085

#FUN-C30057--add--begin--
DEFINE g_wc3          STRING
#FUN-C30057--add--end--
 
#FUN-CB0014 ---------------Begin---------------
DEFINE   w    ui.Window      
DEFINE   f    ui.Form       
DEFINE   page om.DomNode
DEFINE   g_action_flag  STRING
DEFINE   g_rec_b1       LIKE type_file.num10
DEFINE   l_ac1          LIKE type_file.num10
DEFINE   g_b_flag       LIKE type_file.chr1   #TQC-D40025
DEFINE   g_pom_1        DYNAMIC ARRAY OF RECORD
                          pom01_1        LIKE pom_file.pom01,
                          pom04_1        LIKE pom_file.pom04,
                          pom09_1        LIKE pom_file.pom09,
                          pmc03_1        LIKE pmc_file.pmc03,
                          pom18_1        LIKE pom_file.pom18,
                          pom25_11       LIKE pom_file.pom25,
                          pom20_1        LIKE pom_file.pom20,
                          pma02_1        LIKE pma_file.pma02,
                          pom41_1        LIKE pom_file.pom41,
                          pnz02_1        LIKE pnz_file.pnz02,
                          pom12_1        LIKE pom_file.pom12,
                          gen02_1        LIKE gen_file.gen02,
                          pom13_1        LIKE pom_file.pom13,
                          gem02_1        LIKE gem_file.gem02,
                          pommksg        LIKE pom_file.pommksg 

                        END RECORD      
#FUN-CB0014 ---------------End-----------------

FUNCTION t580(p_argv1,p_argv2,p_argv3,p_argv11)  #No.FUN-630010
   DEFINE p_argv1    LIKE pom_file.pom01,     #採購單號
          p_argv2    LIKE type_file.chr1,     #NO.FUN-680136 VARCHAR(01)     #狀況碼
          p_argv3    LIKE pom_file.pom02,     #性質
          p_argv11   STRING                   #No.FUN-630010
 
   WHENEVER ERROR CONTINUE
   LET g_argv1 = p_argv1      #單號
   LET g_argv2 = p_argv2      #狀況
   LET g_argv3 = ' '
   LET g_argv11 = p_argv11    #No.FUN-630010  #FUN-A40023
   IF cl_null(g_argv2) THEN LET g_argv2=0 END IF
   LET g_ydate = NULL
   LET g_wc2=" 1=1 "
   INITIALIZE g_pom.* TO NULL
   INITIALIZE g_pom_t.* TO NULL
   INITIALIZE g_pom_o.* TO NULL
 
 
   LET g_forupd_sql =
     "SELECT * FROM pom_file WHERE pom01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t580_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 2 LET p_col = 2
#FUN-C30057--add--begin--
#FUN-C30057--add--end--   
   OPEN WINDOW t580_w AT p_row,p_col
        WITH FORM "apm/42f/apmt580"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) 
#FUN-C30057 add &endif 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("ponislk01",FALSE) #No.FUN-810017
 
   IF g_aza.aza71 MATCHES '[Yy]' THEN 
      CALL aws_gpmcli_toolbar()
      CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
   ELSE
      CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)
   END IF
   CALL t580_def_form()
 
   IF NOT cl_null(g_argv1) THEN
      CASE g_argv11
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t580_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t580_a()
            END IF
         OTHERWISE
            CALL t580_q()
      END CASE
   END IF
   CALL t580_menu()
   CLOSE WINDOW t580_w
END FUNCTION
 
FUNCTION t580_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
	   CLEAR FORM
   CALL g_pon.clear()
#No.FUN-C30057--add--
#No.FUN-C30057--end--   
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = " pom01 = '",g_argv1,"'"
   ELSE
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
      INITIALIZE g_pom.* TO NULL    #No.FUN-750051
#FUN-C30057--add--begin--
      DIALOG ATTRIBUTES(UNBUFFERED)
         CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
                    pom01,pom04,pom09,pom05,pom18,         
                    pom20,pom41,pom10,pom11,
                    pom12,pom13,pom21,pom43,pom22,pom42,
                    pom45,pom25,pommksg,
                    pom14,pom15,pom16,pom17,pom30,pom44,
                    pomuser,pomgrup,pomdate,pomacti,pommodu,
                    pomoriu,pomorig, 
                    pomud01,pomud02,pomud03,pomud04,pomud05,
                    pomud06,pomud07,pomud08,pomud09,pomud10,
                    pomud11,pomud12,pomud13,pomud14,pomud15
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
      END CONSTRUCT      
      CONSTRUCT g_wc2 ON pon02,pon04,pon041,pon07,pon19,pon20, 
	           pon83,pon84,pon85,pon80,pon81,
                   pon82,pon86,pon87,pon21,pon31,pon31t,       
                   pon06,ima021
                   ,ponud01,ponud02,ponud03,ponud04,ponud05
                  ,ponud06,ponud07,ponud08,ponud09,ponud10
                   ,ponud11,ponud12,ponud13,ponud14,ponud15
              FROM s_pon[1].pon02,s_pon[1].pon04,s_pon[1].pon041,
                   s_pon[1].pon07,s_pon[1].pon19,s_pon[1].pon20,s_pon[1].pon83, 
                   s_pon[1].pon84,s_pon[1].pon85,s_pon[1].pon80,
                   s_pon[1].pon81,s_pon[1].pon82,s_pon[1].pon86,
                   s_pon[1].pon87,s_pon[1].pon21,s_pon[1].pon31,
                   s_pon[1].pon31t,s_pon[1].pon06,s_pon[1].ima021    
                   ,s_pon[1].ponud01,s_pon[1].ponud02,s_pon[1].ponud03
                   ,s_pon[1].ponud04,s_pon[1].ponud05,s_pon[1].ponud06
                   ,s_pon[1].ponud07,s_pon[1].ponud08,s_pon[1].ponud09
                   ,s_pon[1].ponud10,s_pon[1].ponud11,s_pon[1].ponud12
                   ,s_pon[1].ponud13,s_pon[1].ponud14,s_pon[1].ponud15
	
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT     
 
      ON ACTION CONTROLP
                  CASE
                     WHEN INFIELD(pom01) #單據編號   
                        CALL cl_init_qry_var()
                        LET g_qryparam.state= "c"
                        LET g_qryparam.form = "q_pom1"
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pom01
                        NEXT FIELD pom01
  
                     WHEN INFIELD(pom05)  #專案代號
                        CALL cl_init_qry_var()
                        LET g_qryparam.form ="q_pja2"  
                        LET g_qryparam.state = "c"   #多選
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pom05
                        NEXT FIELD pom05
                     WHEN INFIELD(pom09) #查詢廠商檔
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_pmc1"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pom09
                        CALL t580_supplier('a','1',g_pom.pom09)
                        NEXT FIELD pom09
                     WHEN INFIELD(pom17) #查詢廠商檔
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_pmc1"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pom17
                        CALL t580_supplier('a','2',g_pom.pom17)
                        NEXT FIELD pom09
                     WHEN INFIELD(pom10) #查詢地址資料檔 (0:表送貨地址)
                        CALL cl_init_qry_var()
                        LET g_qryparam.form = "q_pme"
                        LET g_qryparam.state = 'c'
                        CALL cl_create_qry() RETURNING g_qryparam.multiret
                        DISPLAY g_qryparam.multiret TO pom10
                        NEXT FIELD pom10
                     WHEN INFIELD(pom11) #查詢地址資料檔 (0:表送貨地址)
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_pme"
                          LET g_qryparam.state = 'c'
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                          DISPLAY g_qryparam.multiret TO pom11
                          NEXT FIELD pom11
                     WHEN INFIELD(pom12) #採購員
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_gen"
                          LET g_qryparam.default1 = g_pom.pom12
                          LET g_qryparam.state = 'c'
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                          DISPLAY g_qryparam.multiret TO pom12
                          NEXT FIELD pom12
                     WHEN INFIELD(pom13) #請購DEPT
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_gem"
                          LET g_qryparam.state = 'c'
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                          DISPLAY g_qryparam.multiret TO pom13
                          NEXT FIELD pom13
                     WHEN INFIELD(pom20) #查詢付款條件資料檔(pma_file)
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_pma"
                          LET g_qryparam.state = 'c'
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                          DISPLAY g_qryparam.multiret TO pom20
                          NEXT FIELD pom20
                     WHEN INFIELD(pom16)
                         CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_ged"
                          LET g_qryparam.state = 'c'
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                          DISPLAY g_qryparam.multiret TO pom16
                          NEXT FIELD pom16
                     WHEN INFIELD(pom21) #查詢稅別資料檔(gec_file)i
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_gec"
                          LET g_qryparam.state = 'c'
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                          DISPLAY g_qryparam.multiret TO pom21
                          NEXT FIELD pom21
                     WHEN INFIELD(pom22) #查詢幣別資料檔
                          CALL cl_init_qry_var()
                          LET g_qryparam.form = "q_azi"
                          LET g_qryparam.state = 'c'
                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                          DISPLAY g_qryparam.multiret TO pom22
                          NEXT FIELD pom22
                    WHEN INFIELD(pom41) #價格條件
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_pnz01" 
                         LET g_qryparam.state = 'c'
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO pom41
                         NEXT FIELD pom41
                    WHEN INFIELD(ponslk04) #價格條件
                         CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO ponslk04
                         NEXT FIELD ponslk04
                    WHEN INFIELD(ponslk07) #價格條件
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_gfe" 
                         LET g_qryparam.state = 'c'
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO ponslk07
                         NEXT FIELD ponslk07
                    WHEN INFIELD(pon04) #料件編號
#FUN-AA0059---------mod------------str-----------------                     
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_ima"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
                         CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                         DISPLAY g_qryparam.multiret TO pon04
                         NEXT FIELD pon04
                    WHEN INFIELD(pon07) #採購單位
                         CALL cl_init_qry_var()
                         LET g_qryparam.form = "q_gfe"
                         LET g_qryparam.state = 'c'
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO pon07
                         NEXT FIELD pon07
                    WHEN INFIELD(pon80)
               	         CALL cl_init_qry_var()
               	         LET g_qryparam.state = "c"
               	         LET g_qryparam.form ="q_gfe"
               	         CALL cl_create_qry() RETURNING g_qryparam.multiret
               	         DISPLAY g_qryparam.multiret TO pon80
               	         NEXT FIELD pon80
                    WHEN INFIELD(pon86)
                         CALL cl_init_qry_var()
                         LET g_qryparam.state = "c"
                         LET g_qryparam.form ="q_gfe"
                         CALL cl_create_qry() RETURNING g_qryparam.multiret
                         DISPLAY g_qryparam.multiret TO pon86
                         NEXT FIELD pon86
                    OTHERWISE EXIT CASE
                  END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG

      ON ACTION about         
         CALL cl_about()      

      ON ACTION help          
         CALL cl_show_help() 

      ON ACTION controlg      
         CALL cl_cmdask()     

      ON ACTION qbe_select
		 CALL cl_qbe_list() RETURNING lc_qbe_sn
	     CALL cl_qbe_display_condition(lc_qbe_sn)
	       
      ON ACTION accept
         EXIT DIALOG
      
      ON ACTION EXIT
         LET INT_FLAG = TRUE
         EXIT DIALOG 
          
      ON ACTION cancel
         LET INT_FLAG = TRUE
         EXIT DIALOG          
      END DIALOG 
#FUN-C30057--add--end----    
#FUN-C30057--mark--begin--
#              CONSTRUCT BY NAME g_wc ON                    # 螢幕上取條件
#                    pom01,pom04,pom09,pom05,pom18,         #FUN-810045 add pom05  #No.FUN-830161
#                    pom20,pom41,pom10,pom11,
#                    pom12,pom13,pom21,pom43,pom22,pom42,
#                    pom45,pom25,pommksg,
#                    pom14,pom15,pom16,pom17,pom30,pom44,
#                   #pomuser,pomgrup,pomdate,pomacti,
#                    pomuser,pomgrup,pomdate,pomacti,pommodu, #TQC-C30126 add pommodu
#                    pomoriu,pomorig, #TQC-BB0177
#                     pomud01,pomud02,pomud03,pomud04,pomud05,
#                     pomud06,pomud07,pomud08,pomud09,pomud10,
#                     pomud11,pomud12,pomud13,pomud14,pomud15
#                BEFORE CONSTRUCT
#                   CALL cl_qbe_init()
#  
#               ON ACTION CONTROLP
#                  CASE
#                     WHEN INFIELD(pom01) #單據編號   #MOD-4A0252
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.state= "c"
#                         LET g_qryparam.form = "q_pom1"
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO pom01
#                         NEXT FIELD pom01
#  
#                     WHEN INFIELD(pom05)  #專案代號
#                       CALL cl_init_qry_var()
#                      LET g_qryparam.form ="q_pja2"  
#                      LET g_qryparam.state = "c"   #多選
#                      CALL cl_create_qry() RETURNING g_qryparam.multiret
#                      DISPLAY g_qryparam.multiret TO pom05
#                      NEXT FIELD pom05
#                     WHEN INFIELD(pom09) #查詢廠商檔
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_pmc1"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom09
#                          CALL t580_supplier('a','1',g_pom.pom09)
#                          NEXT FIELD pom09
#                     WHEN INFIELD(pom17) #查詢廠商檔
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_pmc1"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom17
#                          CALL t580_supplier('a','2',g_pom.pom17)
#                          NEXT FIELD pom09
#                     WHEN INFIELD(pom10) #查詢地址資料檔 (0:表送貨地址)
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_pme"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom10
#                          NEXT FIELD pom10
#                     WHEN INFIELD(pom11) #查詢地址資料檔 (0:表送貨地址)
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_pme"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom11
#                          NEXT FIELD pom11
#                     WHEN INFIELD(pom12) #採購員
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_gen"
#                          LET g_qryparam.default1 = g_pom.pom12
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom12
#                          NEXT FIELD pom12
#                     WHEN INFIELD(pom13) #請購DEPT
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_gem"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom13
#                          NEXT FIELD pom13
#                     WHEN INFIELD(pom20) #查詢付款條件資料檔(pma_file)
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_pma"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom20
#                          NEXT FIELD pom20
#                     WHEN INFIELD(pom16)
#                         CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_ged"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom16
#                          NEXT FIELD pom16
#                     WHEN INFIELD(pom21) #查詢稅別資料檔(gec_file)i
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_gec"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom21
#                          NEXT FIELD pom21
#                     WHEN INFIELD(pom22) #查詢幣別資料檔
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_azi"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pom22
#                          NEXT FIELD pom22
#                    WHEN INFIELD(pom41) #價格條件
#                         CALL cl_init_qry_var()
#                         LET g_qryparam.form = "q_pnz01" #FUN-930113 oah-->pnz01
#                         LET g_qryparam.state = 'c'
#                         CALL cl_create_qry() RETURNING g_qryparam.multiret
#                         DISPLAY g_qryparam.multiret TO pom41
#                         NEXT FIELD pom41
#                    OTHERWISE EXIT CASE
#                  END CASE
#                 ON IDLE g_idle_seconds
#                    CALL cl_on_idle()
#                    CONTINUE CONSTRUCT
# 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
# 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
# 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
#                 ON ACTION qbe_select
#		   CALL cl_qbe_list() RETURNING lc_qbe_sn
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
#              END CONSTRUCT
#              IF INT_FLAG THEN 
#                 RETURN 
#              END IF
#	      CONSTRUCT g_wc2 ON pon02,pon04,pon041,pon07,pon19,pon20, #NO.FUN-A80001 add pon19
#	           pon83,pon84,pon85,pon80,pon81,
#                   pon82,pon86,pon87,pon21,pon31,pon31t,       #No.FUN-550089
#                   pon06,ima021
#&ifdef SLK         
#                   ,ponislk01                      #No.FUN-810017
#&endif
#                   ,ponud01,ponud02,ponud03,ponud04,ponud05
#                   ,ponud06,ponud07,ponud08,ponud09,ponud10
#                   ,ponud11,ponud12,ponud13,ponud14,ponud15
#              FROM s_pon[1].pon02,s_pon[1].pon04,s_pon[1].pon041,
#                   s_pon[1].pon07,s_pon[1].pon19,s_pon[1].pon20,s_pon[1].pon83, #NO.FUN-A80001 add pon19
#                   s_pon[1].pon84,s_pon[1].pon85,s_pon[1].pon80,
#                   s_pon[1].pon81,s_pon[1].pon82,s_pon[1].pon86,
#                   s_pon[1].pon87,s_pon[1].pon21,s_pon[1].pon31,
#                   s_pon[1].pon31t,s_pon[1].pon06,s_pon[1].ima021    #No.FUN-550089
#&ifdef SLK
#                   ,s_pon[1].ponislk01                               #No.FUN-810017
#&endif
#                   ,s_pon[1].ponud01,s_pon[1].ponud02,s_pon[1].ponud03
#                   ,s_pon[1].ponud04,s_pon[1].ponud05,s_pon[1].ponud06
#                   ,s_pon[1].ponud07,s_pon[1].ponud08,s_pon[1].ponud09
#                   ,s_pon[1].ponud10,s_pon[1].ponud11,s_pon[1].ponud12
#                   ,s_pon[1].ponud13,s_pon[1].ponud14,s_pon[1].ponud15
#		BEFORE CONSTRUCT
#		   CALL cl_qbe_display_condition(lc_qbe_sn)
#              ON ACTION CONTROLP
#                  CASE
#                     WHEN INFIELD(pon04) #料件編號
                     
#FUN-AA0059---------mod------------str-----------------                     
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_ima"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret

#                          CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

#                          DISPLAY g_qryparam.multiret TO pon04
#                         NEXT FIELD pon04
#&ifdef SLK
#                     WHEN INFIELD(ponislk01)
#                 	        CALL cl_init_qry_var()
#                 	        LET g_qryparam.state = "c"
#                 	        LET g_qryparam.form ="q_skd1"
#                 	        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 	        DISPLAY g_qryparam.multiret TO ponislk01
#                  	        NEXT FIELD ponislk01
#&endif
#                     WHEN INFIELD(pon07) #採購單位
#                          CALL cl_init_qry_var()
#                          LET g_qryparam.form = "q_gfe"
#                          LET g_qryparam.state = 'c'
#                          CALL cl_create_qry() RETURNING g_qryparam.multiret
#                          DISPLAY g_qryparam.multiret TO pon07
#                          NEXT FIELD pon07
#                     WHEN INFIELD(pon80)
#                 	        CALL cl_init_qry_var()
#                 	        LET g_qryparam.state = "c"
#                 	        LET g_qryparam.form ="q_gfe"
#                 	        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 	        DISPLAY g_qryparam.multiret TO pon80
#                  	        NEXT FIELD pon80
#              	     WHEN INFIELD(pon86)
#                 	        CALL cl_init_qry_var()
#                 	        LET g_qryparam.state = "c"
#                 	        LET g_qryparam.form ="q_gfe"
#                 	        CALL cl_create_qry() RETURNING g_qryparam.multiret
#                 	        DISPLAY g_qryparam.multiret TO pon86
#                 	        NEXT FIELD pon86
#                     OTHERWISE EXIT CASE
#                  END CASE
#                 ON IDLE g_idle_seconds
#                    CALL cl_on_idle()
#                    CONTINUE CONSTRUCT
 
#      ON ACTION about         #MOD-4C0121
#         CALL cl_about()      #MOD-4C0121
 
#      ON ACTION help          #MOD-4C0121
#         CALL cl_show_help()  #MOD-4C0121
 
#      ON ACTION controlg      #MOD-4C0121
#         CALL cl_cmdask()     #MOD-4C0121
 
#                    ON ACTION qbe_save
#		       CALL cl_qbe_save()
#              END CONSTRUCT
#FUN-C30057--mark--end--
              IF INT_FLAG THEN RETURN END IF
           END IF
	   #資料權限的檢查
 
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pomuser', 'pomgrup')
	   #End:FUN-980030
 
       IF g_argv2 = '0' THEN      #已開立
          LET g_wc = g_wc clipped," AND pom25 IN ('X','0','1','2','6','9','S','R','W') "
       END IF
       IF g_argv2 = '1' THEN      #已核淮
          LET g_wc = g_wc clipped," AND pom25 matches '1' "
       END IF
       IF g_argv2 = '2' THEN      #已發出
	  LET g_wc = g_wc clipped," AND pom25 matches '2' "
       END IF
       IF g_wc2=' 1=1 ' THEN
	  LET g_sql="SELECT pom01 FROM pom_file ", #組合出SQL指令
                    " WHERE ",g_wc CLIPPED,
                    " ORDER BY pom01"
#FUN-C30057--add--begin--
#FUN-C30057--add--end---
       ELSE
          LET g_sql="SELECT pom_file.pom01 FROM pom_file,pon_file ",
                    " WHERE ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                    "   AND pom01 = pon01",
                    " ORDER BY pom01"
#FUN-C30057--add--begin--
#FUN-C30057--add--end---                    
       END IF
       PREPARE t580_prepare FROM g_sql           # RUNTIME 編譯
       DECLARE t580_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR t580_prepare
       DECLARE t580_fill_cs CURSOR WITH HOLD FOR t580_prepare   #FUN-CB0014
       IF g_wc2=' 1=1 ' THEN
          LET g_sql= "SELECT COUNT(*) FROM pom_file",
                     " WHERE pom02 != 'SUB' AND ",g_wc CLIPPED
 #FUN-C30057--add--begin--
 #FUN-C30057--add--end--
      ELSE
          LET g_sql= "SELECT COUNT(DISTINCT pom01) FROM pom_file,pon_file",
                     " WHERE pom01 = pon01",
                     "  AND pom02 != 'SUB' AND ",g_wc CLIPPED," AND ",
                     g_wc2
 
 #FUN-C30057--add--begin--
 #FUN-C30057--add--end--      
      END IF
      PREPARE t580_precount FROM g_sql
      DECLARE t580_count CURSOR FOR t580_precount
END FUNCTION
 
FUNCTION t580_b_askkey()
	   CONSTRUCT g_wc2 ON pon02,pon04,pon041,pon07,pon19,pon20,   #NO.FUN-A80001 add pon19
	                      pon83,pon84,pon85,pon80,pon81,
                              pon82,pon86,pon87,pon21,pon31,
                              pon31t,pon06,ima021            #No.FUN-550089
                              ,ponud01,ponud02,ponud03,ponud04,ponud05
                              ,ponud06,ponud07,ponud08,ponud09,ponud10
                              ,ponud11,ponud12,ponud13,ponud14,ponud15
           FROM s_pon[1].pon02, s_pon[1].pon04,s_pon[1].pon041,
                s_pon[1].pon07,s_pon[1].pon19,s_pon[1].pon20,s_pon[1].pon83,   #NO.FUN-A80001 add pon19
                s_pon[1].pon84,s_pon[1].pon85,s_pon[1].pon80,
                s_pon[1].pon81,s_pon[1].pon82,s_pon[1].pon86,
                s_pon[1].pon87,s_pon[1].pon21,s_pon[1].pon31,
                s_pon[1].pon31t,s_pon[1].pon06,s_pon[1].ima021    #No.FUN-550089
                ,s_pon[1].ponud01,s_pon[1].ponud02,s_pon[1].ponud03
                ,s_pon[1].ponud04,s_pon[1].ponud05,s_pon[1].ponud06
                ,s_pon[1].ponud07,s_pon[1].ponud08,s_pon[1].ponud09
                ,s_pon[1].ponud10,s_pon[1].ponud11,s_pon[1].ponud12
                ,s_pon[1].ponud13,s_pon[1].ponud14,s_pon[1].ponud15
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
END FUNCTION
 
 
FUNCTION t580_menu()
   DEFINE l_partnum    STRING   #GPM料號
   DEFINE l_supplierid STRING   #GPM廠商
   DEFINE l_status     LIKE type_file.num10  #GPM傳回值
 
   WHILE TRUE
    # CALL t580_bp("G")      #FUN-CB0014 mark
    #FUN-CB0014 ----Begin----add-----
      CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "main")
            CALL t580_bp("G")
         WHEN (g_action_flag = "info_list") 
            CALL t580_list_fill()
            CALL t580_bp1("G")
            IF NOT cl_null(g_action_choice) AND l_ac1>0 THEN #將清單的資料回傳到主畫面
               SELECT pom_file.* INTO g_pom.* FROM pom_file
                WHERE pom01=g_pom_1[l_ac1].pom01_1
            END IF
            IF g_action_choice!= "" THEN
               LET g_action_flag = 'main'
               LET l_ac1 = ARR_CURR()
               LET g_jump = l_ac1
               LET mi_no_ask = TRUE
               IF g_rec_b1 >0 THEN
                   CALL t580_fetch('/')
               END IF
               CALL cl_set_comp_visible("page1", FALSE)
               CALL cl_set_comp_visible("page2", FALSE)
               CALL ui.interface.refresh()
               CALL cl_set_comp_visible("page1", TRUE)
               CALL cl_set_comp_visible("page2", TRUE)
             END IF
      END CASE
    #FUN-CB0014 ----End------add-----
      CASE g_action_choice
         WHEN "insert"
	     IF cl_chk_act_auth() THEN
                CALL t580_a()
             END IF
	 WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t580_q()
            END IF
	 WHEN "delete"
	    IF cl_chk_act_auth() THEN
               CALL t580_r()
	    END IF
	 WHEN "modify"
	    IF cl_chk_act_auth() THEN
               CALL t580_u()
	    END IF
	 WHEN "reproduce"
            IF cl_chk_act_auth() THEN
               CALL t580_copy()
            END IF
	 WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t580_b()
            ELSE
               LET g_action_choice = ""
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
            CALL t580_out()
            END IF
        WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()

       #@WHEN "供應商資料"
	 WHEN "vender"
            IF cl_null(g_pom.pom01) THEN
               CALL cl_err('','-400',1)
               CONTINUE WHILE
            ELSE
               CALL t582(g_argv2,g_pom.pom01)
            END IF
 
       #@WHEN "特別說明"
	 WHEN "special_description"
            IF cl_chk_act_auth() THEN   #CHI-9C0002
               IF g_pom.pom01 IS NOT NULL AND g_pom.pom01 != ' ' THEN
                  LET g_cmd = "apmt402 ",'2 ',"'",
                     g_pom.pom01,"'",' ','0' CLIPPED
                  CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
               END IF
            END IF   #CHI-9C0002
       #@WHEN "作廢"
	 WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t580_x() #FUN-D20025 mark
               CALL t580_x(1) #FUN-D20025 add
            END IF
#FUN-D20025 add            
       #@WHEN "取消作廢"
	 WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t580_x(2)
            END IF 
#FUN-D20025 add            
       #@WHEN "採購狀況查詢"
	 WHEN "qry_po_status"
            LET g_cmd = "apmq580 "," '",g_pom.pom01,"'"," ' ' "
            CALL cl_cmdrun(g_cmd CLIPPED)
       #@WHEN "確認"
	 WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t580_y()
            END IF
       #@WHEN "取消確認"
	 WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t580_z()
            END IF
         WHEN "exporttoexcel"     #FUN-4B0025
            IF cl_chk_act_auth() THEN
            # CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_pon),'','')
             #FUN-CB0014 -------Begin--------
               LET w = ui.Window.getCurrent()
               LET f = w.getForm()
               CASE g_action_flag
                  WHEN 'main'
                     LET page = f.FindNode("Page","page3")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_pon),'','')
                  WHEN 'info_list'
                     LET page = f.FindNode("Page","page4")
                     CALL cl_export_to_excel(page,base.TypeInfo.create(g_pom_1),'','')
               END CASE
               LET g_action_choice = NULL
             #FUN-CB0014 -------End---------
            
            END IF
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_pom.pom01 IS NOT NULL THEN
                 LET g_doc.column1 = "pom01"
                 LET g_doc.value1 = g_pom.pom01
                 CALL cl_doc()
               END IF
         END IF
         #@WHEN GPM規範顯示   
         WHEN "gpm_show"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_pon[l_ac].pon04 END IF
              LET l_supplierid = g_pom.pom09
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
 
         #@WHEN GPM規範查詢
         WHEN "gpm_query"
              LET l_partnum = ''
              LET l_supplierid = ''
              IF l_ac > 0 THEN LET l_partnum = g_pon[l_ac].pon04 END IF
              LET l_supplierid = g_pom.pom09
              CALL aws_gpmcli(l_partnum,l_supplierid)
                RETURNING l_status
      END CASE
   END WHILE
      CLOSE t580_cs
END FUNCTION
 
FUNCTION t580_a()
DEFINE li_result   LIKE type_file.num5        #No.FUN-540027  #No.FUN-680136 SMALLINT
  DEFINE  l_chr   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
    IF s_shut(0) THEN RETURN END IF 
    MESSAGE ""
    CLEAR FORM                                  # 清螢幕欄位內容
    CALL g_pon.clear()
#FUN-C30057--add--begin--
#FUN-C30057--add--end--
    INITIALIZE g_pom.* LIKE pom_file.*
    INITIALIZE g_pom_o.* LIKE pom_file.*
    IF g_ydate IS NULL THEN
       LET g_pom.pom01 = NULL
       LET g_pom.pom04 = g_today               #採購日期
    ELSE                                        #使用上筆資料值
       LET g_pom.pom01 = g_sheet               #單別
       LET g_pom.pom04 = g_ydate               #收貨日期
    END IF
    LET g_pom01_t = NULL
       LET g_pom.pom02 = g_argv3     #單號性質
       LET g_pom.pom03 = 0
       LET g_pom.pom12 = g_user
       LET g_pom.pom18 = 'N'
       LET g_pom.pom25 = '0'         #開立
       LET g_pom.pom27 = g_today
       LET g_pom.pom30 ='N'          #列印
       LET g_pom.pom40 = 0           #總金額
       LET g_pom.pom40t= 0           #含稅總金額  #No.FUN-610018
       LET g_pom.pom401= 0           #代買總金額
       LET g_pom.pom42 = 1           #匯率
       LET g_pom.pom43 = 0           #稅率
       LET g_pom.pom44 = '1'         #No.TQC-7C0089
       LET g_pom.pom45 = 'Y'         #可用
       LET g_pom.pom46 = 0           #預付比率
       LET g_pom.pom47 = 0           #預付金額
       LET g_pom.pom48 = 0           #已結帳金額
       LET g_pom.pomdays = 0         #列印次數
       LET g_pom.pomprno = 0         #列印次數
       LET g_pom.pomsmax = 0         #己簽順序
       LET g_pom.pomsseq = 0         #應簽順序
       LET g_pom.pomprsw = 'Y'
       LET l_tmp.prt   = 'N'
       CALL s_pmmsta('pmm',g_pom.pom25,g_pom.pom18,g_pom.pommksg)
                   RETURNING g_sta
       DISPLAY g_sta TO FORMONLY.desc2
       CALL cl_opmsg('a')

       WHILE TRUE
         LET g_pom.pomacti ='Y'                   #有效的資料
         LET g_pom.pomuser = g_user
         LET g_pom.pomoriu = g_user #FUN-980030
         LET g_pom.pomorig = g_grup #FUN-980030
         LET g_data_plant = g_plant #FUN-980030
	 LET g_pom.pomgrup = g_grup               #使用者所屬群
	 LET g_pom.pomdate = g_today
	 LET g_pom.pomplant = g_plant  #FUN-980006 add
	 LET g_pom.pomlegal = g_legal  #FUN-980006 add
	 CALL t580_i("a")                      # 各欄位輸入
         IF INT_FLAG THEN                         # 若按了DEL鍵
            INITIALIZE g_pom.* TO NULL
	     LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_pon.clear()
#FUN-C30057--add--begin--
#FUN-C30057--add--end--
            EXIT WHILE
         END IF
         IF cl_null(g_pom.pom01) THEN           # KEY 不可空白
            CONTINUE WHILE
         END IF
         BEGIN WORK #No:7857
        CALL s_auto_assign_no("apm",g_pom.pom01,g_pom.pom04,"8","pom_file","pom01","","","")
             RETURNING li_result,g_pom.pom01
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_pom.pom01
         INSERT INTO pom_file VALUES(g_pom.*)       # DISK WRITE
         LET g_ydate = g_pom.pom04           #備份上一筆交貨日期
         LET g_sheet = s_get_doc_no(g_pom.pom01)       #No.FUN-540027
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            ROLLBACK WORK #No:7857
            CONTINUE WHILE
         ELSE
            COMMIT WORK #No:7857
            CALL cl_flow_notify(g_pom.pom01,'I')
            SELECT pom01 INTO g_pom.pom01 FROM pom_file
             WHERE pom01 = g_pom.pom01             
            CALL g_pon.clear()
            CALL SET_COUNT(0)
            LET g_rec_b = 0
#FUN-C30057--add--begin--
#FUN-C30057--add--end--
            CALL t580_b()
            LET g_pom_t.* = g_pom.*                # 保存上筆資料
            LET g_pom_o.* = g_pom.*                # 保存上筆資料
            CALL t580_sign('a')
         END IF
 
         IF NOT cl_null(g_pom.pom01) THEN
            IF g_smy.smydmy4='Y' THEN  #確認
               CALL t580_y()
            END IF
            IF g_smy.smyprint='Y' THEN
               CALL t580_prt()
            END IF
         END IF
         EXIT WHILE
       END WHILE
END FUNCTION
 
FUNCTION t580_i(p_cmd)
  DEFINE
    p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(60)
    l_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
    l_buf           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(20)
    l_n             LIKE type_file.num5,    #No.FUN-680136 SMALLINT
    l_ged02         LIKE ged_file.ged02     #No.FUN-930152
DEFINE li_result   LIKE type_file.num5        #No.FUN-540027  #No.FUN-680136 SMALLINT
#MOD-B30413 add --start--
  DEFINE l_pon01     LIKE pon_file.pon01
  DEFINE l_pon02     LIKE pon_file.pon02
  DEFINE l_pon04     LIKE pon_file.pon04
  DEFINE l_pon87     LIKE pon_file.pon87
  DEFINE l_pon86     LIKE pon_file.pon86
  DEFINE l_pon31     LIKE pon_file.pon31
  DEFINE l_pon31t    LIKE pon_file.pon31t
  DEFINE l_pon88     LIKE pon_file.pon88
  DEFINE l_pon88t    LIKE pon_file.pon88t
#MOD-B30413 add --end--
  DEFINE l_ima915    LIKE ima_file.ima915   #CHI-B80082 add
#FUN-C30057--add--begin---
DEFINE l_ponslk01  LIKE ponslk_file.ponslk01
DEFINE l_ponslk02  LIKE ponslk_file.ponslk02
DEFINE l_ponslk31  LIKE ponslk_file.ponslk31
DEFINE l_ponslk31t LIKE ponslk_file.ponslk31t  
#FUN-C30057--add--end--
DEFINE l_pon19     LIKE pon_file.pon19    #TQC-D50078 add
 
        CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
        INPUT BY NAME   g_pom.pomoriu,g_pom.pomorig,#87/04/21 modify g_pom.pom03不可輸入
           #g_pom.pom01,g_pom.pom04,g_pom.pom09,g_pom.pom06,g_pom.pom05,g_pom.pom18,  #FUN-810045 add pom05  #No.FUN-830161
            g_pom.pom01,g_pom.pom04,g_pom.pom09,g_pom.pom05,g_pom.pom18,              #FUN-810045 add pom05  #No.FUN-830161
            g_pom.pom20,g_pom.pom41,g_pom.pom10,g_pom.pom11,
            g_pom.pom12,g_pom.pom13,g_pom.pom21,g_pom.pom43,
            g_pom.pom22,g_pom.pom42,
            g_pom.pom45,g_pom.pom25,g_pom.pommksg,
            g_pom.pom14,g_pom.pom15,g_pom.pom16,g_pom.pom17,
            g_pom.pom30,g_pom.pom44,
            g_pom.pomuser,g_pom.pomgrup,g_pom.pomdate,g_pom.pomacti,
            g_pom.pomud01,g_pom.pomud02,g_pom.pomud03,g_pom.pomud04,
            g_pom.pomud05,g_pom.pomud06,g_pom.pomud07,g_pom.pomud08,
            g_pom.pomud09,g_pom.pomud10,g_pom.pomud11,g_pom.pomud12,
            g_pom.pomud13,g_pom.pomud14,g_pom.pomud15 
            WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t580_set_entry(p_cmd)
            CALL t580_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
         CALL cl_set_docno_format("pom01")
 
 
         BEFORE FIELD pom01
            CALL t580_set_entry(p_cmd)
 
         AFTER FIELD pom01
            IF NOT cl_null(g_pom.pom01) OR (g_pom.pom01!=g_pom_t.pom01) THEN        #No.TQC-610060
            CALL s_check_no("apm",g_pom.pom01,g_pom01_t,"8","pom_file","pom01","")
                RETURNING li_result,g_pom.pom01
            DISPLAY BY NAME g_pom.pom01
            IF (NOT li_result) THEN
              NEXT FIELD pom01
            END IF
                IF cl_null(g_pom_t.pom01) OR (g_pom.pom01 != g_pom_t.pom01 ) THEN
                   LET  g_pom.pommksg = g_smy.smyapr
                   LET  g_pom.pomsign = g_smy.smysign
                   LET  g_pom.pomprsw = 'Y'
                   DISPLAY BY NAME g_pom.pommksg
                END IF
           END IF
           CALL t580_set_no_entry(p_cmd)
		
         AFTER FIELD pom04       #採購日期(預設會計年度/期間)
            IF NOT cl_null(g_pom.pom04) THEN
                IF (g_pom_o.pom04 IS NULL) OR (g_pom_o.pom04 != g_pom.pom04) THEN
                   SELECT azn02,azn04 INTO g_pom.pom31,g_pom.pom32
                     FROM azn_file WHERE azn01 = g_pom.pom04
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("sel","azn_file",g_pom.pom04,"","mfg0027","","",1)  #No.FUN-660129
                      LET g_pom.pom04 = g_pom_o.pom04
                      DISPLAY BY NAME g_pom.pom04
                      NEXT FIELD pom04
                    END IF
                END IF
                CALL s_get_bookno(YEAR(g_pom.pom04))
                     RETURNING g_flag,g_bookno1,g_bookno2
                IF g_flag =  '1' THEN  #抓不到帳別
                   CALL cl_err(g_pom.pom04,'aoo-081',1)
                   NEXT FIELD pom04
                END IF
               #TQC-BB0172--begin
               IF g_aza.aza17 != g_pom.pom22 THEN
                  IF NOT cl_null(g_pom_o.pom04) AND g_pom_o.pom04 != g_pom.pom04 THEN
                     IF cl_confirm('apm-701') THEN
                        CALL s_curr3(g_pom.pom22,g_pom.pom04,g_sma.sma904)
                              RETURNING g_pom.pom42
                        DISPLAY BY NAME g_pom.pom42
                     END IF
                  END IF
               END IF
               #TQC-BB0172--end
            END IF
            LET g_pom_o.pom04 = g_pom.pom04
 
           AFTER FIELD pom05    #專案代號
             IF NOT cl_null(g_pom.pom05) THEN
                SELECT COUNT(*) INTO g_cnt FROM pjb_file
                 WHERE pjb01 = g_pom.pom05
                   AND pjbacti = 'Y'    
                IF g_cnt = 0 THEN
                   CALL cl_err(g_pom.pom05,'asf-984',0)
                   NEXT FIELD pom05
                END IF
             END IF
 
            AFTER FIELD pom09     #供應商
               IF NOT cl_null(g_pom.pom09) THEN
                   IF (g_pom_o.pom09 IS NULL) OR (g_pom_o.pom09 != g_pom.pom09)
                   THEN CALL t580_supplier('a','1',g_pom.pom09)     #show 簡稱
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_pom.pom09,g_errno,0)
                           LET g_pom.pom09 = g_pom_o.pom09
                           CALL t580_supplier('a','1',g_pom.pom09)     #TQC-D50078  add
                           DISPLAY BY NAME g_pom.pom09
                           NEXT FIELD pom09
                        END IF
                        IF p_cmd='u' AND g_pom.pom02<>'SUB' THEN
#CHI-B80082 -- mark begin --
                          #SELECT COUNT(*) INTO l_n FROM pon_file,pom_file 
                          # WHERE pom01=g_pom.pom01
                          #   AND pon01=pom01
                          #   AND pon04 IN (SELECT ima01 FROM ima_file 
                          #                  WHERE ima915 IN ('2','3'))
                          #IF l_n > 0 THEN                    
                          #   CALL cl_err('','apm-281',0)
                          #   LET g_pom.pom09 = g_pom_o.pom09
                          #   DISPLAY BY NAME g_pom.pom09
                          #   CALL t580_supplier('a','1',g_pom.pom09)
                          #   NEXT FIELD pom09
                          #END IF
#CHI-B80082 -- mark end --
#CHI-B80082 -- begin --
                           DECLARE pon_cur CURSOR FOR
                              SELECT pon04 FROM pon_file
                                 WHERE pon01 = g_pom.pom01
                           FOREACH pon_cur INTO l_pon04
                              SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01 = l_pon04
                              IF l_ima915 = '2' OR l_ima915 = '3' THEN
                                 CALL t580_pmh(l_pon04)
                                 IF NOT cl_null(g_errno) THEN
                                    CALL cl_err(l_pon04,g_errno,0)
                                    LET g_pom.pom09 = g_pom_o.pom09
                                    CALL t580_supplier('a','1',g_pom.pom09)    #TQC-D50078  add
                                    DISPLAY BY NAME g_pom.pom09
                                    NEXT FIELD pom09
                                    EXIT FOREACH
                                 END IF
                              END IF
                           END FOREACH
#CHI-B80082 -- end --
                         END IF
                         CALL t580_supplier_cd()    #show 出預設值
                         CALL t580_pom21()          #No.FUN-550089
                         IF NOT cl_null(g_chr) THEN
                            LET g_pom.pom09 = g_pom_o.pom09
                            DISPLAY BY NAME g_pom.pom09
                            NEXT FIELD pom09
                         END IF
                   END IF
               END IF
               LET g_pom_o.pom09 = g_pom.pom09
	
	   AFTER FIELD pom12       #採購員
               IF NOT cl_null(g_pom.pom12) THEN
                   IF g_pom_o.pom12 IS NULL OR (g_pom.pom12!=g_pom_o.pom12 ) THEN
                       CALL t580_peo('a','1',g_pom.pom12)
                       IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_pom.pom12,g_errno,0)
                           LET g_pom.pom12 = g_pom_o.pom12
                           DISPLAY BY NAME g_pom.pom12
                           NEXT FIELD pom12
                       END IF
                    END IF
               END IF
               LET g_pom_o.pom12 = g_pom.pom12
 
            AFTER FIELD pom13       #採購員
               IF NOT cl_null(g_pom.pom13) THEN
                   IF g_pom_o.pom13 IS NULL OR (g_pom.pom13!=g_pom_o.pom13 )
                      THEN CALL t580_dep('a','1',g_pom.pom13)
                           IF NOT cl_null(g_errno) THEN
                              CALL cl_err(g_pom.pom13,g_errno,0)
                              LET g_pom.pom13 = g_pom_o.pom13
                              DISPLAY BY NAME g_pom.pom13
                              NEXT FIELD pom13
                           END IF
                   END IF
               END IF
               LET g_pom_o.pom13 = g_pom.pom13
 
	    AFTER FIELD pom41                       #價格條件
              IF NOT cl_null(g_pom.pom41) THEN
                 SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pom.pom41 #FUN-930113 oah-->pnz
                 IF STATUS THEN
                    CALL cl_err3("sel","pnz_file",g_pom.pom41,"",STATUS,"","sel pnz:",1)  #No.FUN-660129 #FUN-930113 oah-->pnz
                    NEXT FIELD pom41
                 END IF
                 DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113 oah-->pnz
              END IF
 
	    AFTER FIELD pom20                       #付款條件
                IF NOT cl_null(g_pom.pom20) THEN
                    CALL t580_pom20('a')
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pom.pom20,g_errno,0)
                       LET g_pom.pom20 = g_pom_o.pom20
                       DISPLAY BY NAME g_pom.pom20
                       NEXT FIELD pom20
                    END IF
                END IF
                LET g_pom_o.pom20 = g_pom.pom20
			
	   AFTER FIELD pom21                       #稅別條件
                IF NOT cl_null(g_pom.pom21) THEN
                   IF (g_pom_o.pom21 IS NULL) OR (g_pom.pom21 != g_pom_o.pom21)
                    THEN CALL t580_pom21()
                         IF NOT cl_null(g_errno) THEN
                            CALL cl_err(g_pom.pom21,g_errno,0)
                            LET g_pom.pom21 = g_pom_o.pom21
                            DISPLAY BY NAME g_pom.pom21
                            NEXT FIELD pom21
                         END IF
                    END IF
                END IF
                LET g_pom_o.pom21 = g_pom.pom21
 
	    AFTER FIELD pom10  		        #送貨地址
                IF NOT cl_null(g_pom.pom10) THEN
                   IF (g_pom_o.pom10 IS NULL) OR (g_pom_o.pom10 != g_pom.pom10)
                   THEN CALL t580_pom10(g_pom.pom10)
                        IF NOT cl_null(g_errno) THEN
                           CALL cl_err(g_pom.pom10,g_errno,0)
                           LET g_pom.pom10 = g_pom_o.pom10
                           DISPLAY BY NAME g_pom_o.pom10
                           NEXT FIELD pom10
                        END IF
                   END IF
                END IF
                LET  g_pom_o.pom10 = g_pom.pom10
 
	    AFTER FIELD pom11  		        #發票地址
                IF NOT cl_null(g_pom.pom11) THEN
                   IF (g_pom_o.pom11 IS NULL) OR
                      (g_pom_o.pom11 != g_pom.pom11) THEN
                      CALL t580_pom10(g_pom.pom11)
                      IF NOT cl_null(g_errno) THEN
                         CALL cl_err(g_pom.pom11,g_errno,0)
                         LET g_pom.pom11 = g_pom_o.pom11
                         DISPLAY BY NAME g_pom_o.pom11
                         NEXT FIELD pom11
                      END IF
                   END IF
                END IF
                LET  g_pom_o.pom11 = g_pom.pom11
 
	   AFTER FIELD pom22  		        #幣別
               IF NOT cl_null(g_pom.pom22) THEN
                 IF (g_pom_o.pom22 IS NULL) OR (g_pom_o.pom22 != g_pom.pom22)
                 THEN CALL t580_pom22()
                      IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pom.pom22,g_errno,0)
                        LET g_pom.pom22 = g_pom_o.pom22
                        DISPLAY BY NAME g_pom.pom22
                        NEXT FIELD pom22
                      END IF
                      #TQC-D50078--add--str--
                      DECLARE pon_cur_1 CURSOR FOR
                       SELECT pon04 FROM pon_file       
                        WHERE pon01 = g_pom.pom01
                      FOREACH pon_cur_1 INTO l_pon04   
                        SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01 = l_pon04
                        IF l_ima915 = '2' OR l_ima915 = '3' THEN
                            CALL t580_pmh(l_pon04)    
                            IF NOT cl_null(g_errno) THEN
                               CALL cl_err(l_pon04,g_errno,0)
                               LET g_pom.pom22 = g_pom_o.pom22
                               DISPLAY BY NAME g_pom.pom22
                               NEXT FIELD pom22
                               EXIT FOREACH
                            END IF
                        END IF
                      END FOREACH
                      #TQC-D50078--add--end---
                      IF g_aza.aza17 = g_pom.pom22 THEN   #本幣
                         LET g_pom.pom42 = 1
                      ELSE
                         CALL s_curr3(g_pom.pom22,g_pom.pom04,g_sma.sma904) #FUN-640012
                              RETURNING g_pom.pom42
                      END IF
                      DISPLAY BY NAME g_pom.pom42
                 END IF
              END IF
              LET g_pom_o.pom22 = g_pom.pom22
 
         AFTER FIELD pom42                      #匯率
              IF NOT cl_null(g_pom.pom22) THEN
                  IF g_pom.pom42 <= 0 THEN
                     CALL cl_err(g_pom.pom42,'mfg0013',0)
                     LET g_pom.pom42 = g_pom_o.pom42
                     DISPLAY BY NAME g_pom.pom42
                     NEXT FIELD pom42
                  END IF
 
                  IF g_pom.pom22 =g_aza.aza17 THEN
                     LET g_pom.pom42 =1
                     DISPLAY g_pom.pom42  TO pom42
                  END IF
              END IF
              LET g_pom_o.pom42 = g_pom.pom42
 
         AFTER FIELD pom43          #稅率
              IF cl_null(g_pom.pom43) THEN
                  LET g_pom.pom43 = 0
                  DISPLAY BY NAME g_pom.pom43
              END IF
              IF NOT cl_null(g_pom.pom43) AND g_pom.pom43 < 0 THEN
                 CALL cl_err(g_pom.pom43,'mfg0013',0)
                 LET g_pom.pom43 = g_pom_o.pom43
                 DISPLAY BY NAME g_pom.pom43
                 NEXT FIELD pom43
              END IF
              LET g_pom_o.pom43 = g_pom.pom43
 
        AFTER FIELD pom45                      #可用否
            IF NOT cl_null(g_pom.pom45) THEN
               IF g_pom.pom45 NOT MATCHES'[YyNn]' THEN
                   CALL cl_err(g_pom.pom45,'mfg1002',0)
                   LET g_pom.pom45 = g_pom_o.pom45
                   DISPLAY BY NAME g_pom.pom45
                   NEXT FIELD pom45
               END IF
            END IF
            LET g_pom_o.pom45= g_pom.pom45
 
        AFTER FIELD pommksg    #簽核否
           IF NOT cl_null(g_pom.pommksg) THEN
               IF g_pom.pommksg NOT MATCHES '[yYnN]' THEN
                  NEXT FIELD pommksg
               END IF
               IF g_pom.pommksg  MATCHES'[Nn]' THEN
                  LET g_pom.pomsmax = 0
                  LET g_pom.pomsseq = 0
               ELSE
                  LET g_pom.pom25 = "0"
                  DISPLAY BY NAME g_pom.pom25
                  CALL s_pmmsta('pmm',g_pom.pom25,g_pom.pom18,g_pom.pommksg)
                                RETURNING g_sta
                  DISPLAY g_sta TO FORMONLY.desc2
               END IF
               IF g_pom.pommksg MATCHES '[Nn]' AND g_argv2 !='2' THEN
                  LET g_pom.pom25 = "1"
                  DISPLAY BY NAME g_pom.pom25
                  CALL s_pmmsta('pmm',g_pom.pom25,g_pom.pom18,g_pom.pommksg)
                                RETURNING g_sta
                  DISPLAY g_sta TO FORMONLY.desc2
                END IF
           END IF
 
##-------------- Genero 其他畫面副程式(sapmt583)加入主程式 ---------------##
       AFTER FIELD pom14
            IF cl_null(g_pom.pom14) THEN    #收貨部門
               DISPLAY ' ' TO FORMONLY.gem02_2
            ELSE
               IF g_pom_o.pom14 IS NULL OR
                  (g_pom.pom14 != g_pom_o.pom14 ) THEN
                   CALL t580_dep('a','2',g_pom.pom14)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pom.pom14,g_errno,0)
                        LET g_pom.pom14 = g_pom_o.pom14
                        DISPLAY BY NAME g_pom_o.pom14
                        NEXT FIELD pom14
                    END IF
               END IF
            END IF
            LET g_pom_o.pom14 = g_pom.pom14
 
       AFTER FIELD pom15
            IF cl_null(g_pom.pom15) THEN    #確認人
               DISPLAY ' ' TO FORMONLY.gen02_2
            ELSE
               IF (g_pom_o.pom15 IS NULL) OR
                  (g_pom.pom15 != g_pom_o.pom15 ) THEN
                   CALL t580_peo('a','2',g_pom.pom15)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pom.pom15,g_errno,0)
                        LET g_pom.pom15 = g_pom_o.pom15
                        DISPLAY BY NAME g_pom_o.pom15
                        NEXT FIELD pom15
                    END IF
               END IF
            END IF
            LET g_pom_o.pom15 = g_pom.pom15
 
       AFTER FIELD pom16
            IF cl_null(g_pom.pom16) THEN
               DISPLAY ' ' TO FORMONLY.ged02
            ELSE
               IF (g_pom_o.pom16 IS NULL) OR (g_pom.pom16<>g_pom_o.pom16) THEN
                  SELECT ged02 INTO l_ged02 FROM ged_file
                   WHERE ged01 = g_pom.pom16
                  IF SQLCA.sqlcode = 100 THEN
                     CALL cl_err(g_pom.pom16,'apm-425',0)
                     LET g_pom.pom16 = g_pom_o.pom16
                     DISPLAY BY NAME g_pom.pom16
                     NEXT FIELD pom16
                  ELSE
                     DISPLAY l_ged02 TO FORMONLY.ged02
                  END IF
               END IF
            END IF
       AFTER FIELD pom17                      #代理商
           IF cl_null(g_pom.pom17) THEN
              DISPLAY ' ' TO FORMONLY.pmc03
           ELSE IF (g_pom_o.pom17 IS NULL) OR
                    (g_pom.pom17 != g_pom_o.pom17 ) THEN
                    CALL t580_supplier('a','2',g_pom.pom17)
                    IF NOT cl_null(g_errno) THEN
                       CALL cl_err(g_pom.pom17,g_errno,0)
                       LET g_pom.pom17 = g_pom_o.pom17
                       DISPLAY BY NAME g_pom_o.pom17
                       NEXT FIELD pom17
                    END IF
                 END IF
            END IF
 
        AFTER FIELD pom30       #印驗收單
            IF NOT cl_null(g_pom.pom30 ) THEN
               IF g_pom.pom30 NOT MATCHES'[YyNn]' THEN
                  CALL cl_err(g_pom.pom30,'mfg1002',0)
                  LET g_pom.pom30 = g_pom_o.pom30
                  DISPLAY BY NAME g_pom.pom30
                  NEXT FIELD pom30
               END IF
            END IF
            LET g_pom_o.pom30= g_pom.pom30
 
        AFTER FIELD pom44     #稅處理
            IF cl_null(g_pom.pom44) OR g_pom.pom44 NOT MATCHES'[1234]' THEN
               LET g_pom.pom44 = g_pom_o.pom44
               DISPLAY BY NAME g_pom.pom44
               NEXT FIELD pom44
            END IF
            LET g_pom_o.pom44 = g_pom.pom44
 
##-------------- Genero 其他畫面副程式(sapmt583)加入主程式 (end)----------##
 
        AFTER FIELD pomud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD pomud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
	
        AFTER INPUT
           LET g_pom.pomuser = s_get_data_owner("pom_file") #FUN-C10039
           LET g_pom.pomgrup = s_get_data_group("pom_file") #FUN-C10039
            IF INT_FLAG THEN                         # 若按了DEL鍵
               CALL cl_err('',9001,0)
               EXIT INPUT
            END IF
            IF NOT cl_null(g_pom.pom22) THEN
                IF cl_null(g_pom.pom42) OR g_pom.pom42 <= 0 THEN
                   NEXT FIELD pom42
                END IF
            END IF
            IF cl_null(g_pom.pom30) THEN LET g_pom.pom30 = 'N' END IF
           #TQC-C10021 add begin------------------------------------------
            IF p_cmd='u' AND g_pom.pom02<>'SUB' THEN
               DECLARE pon_cur1 CURSOR FOR
                  SELECT pon04 FROM pon_file
                     WHERE pon01 = g_pom.pom01
               FOREACH pon_cur1 INTO l_pon04
                  SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01 = l_pon04
                  IF l_ima915 = '2' OR l_ima915 = '3' THEN
                     CALL t580_pmh(l_pon04)
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(l_pon04,g_errno,0)
                        LET g_pom.pom09 = g_pom_o.pom09
                        DISPLAY BY NAME g_pom.pom09
                        NEXT FIELD pom09
                        EXIT FOREACH
                     END IF
                  END IF
               END FOREACH
            END IF
           #TQC-C10021 add end--------------------------------------------

           #MOD-B30413 add --start--
           IF g_pom.pom09 != g_pom_t.pom09 OR g_pom.pom22 != g_pom_t.pom22 OR g_pom.pom04 != g_pom_t.pom04 OR g_pom.pom21 != g_pom_t.pom21 OR g_pom.pom43 != g_pom_t.pom43
              OR g_pom.pom41 != g_pom_t.pom41 THEN      #TQC-C40157 add pom41
              SELECT COUNT(*) INTO g_cnt FROM pon_file
               WHERE pon01=g_pom.pom01
              IF g_cnt > 0 THEN
                 IF cl_confirm('apm-543') THEN  #是否重新取價
                    DECLARE upd_pon_cs CURSOR FOR
                      SELECT pon01,pon02,pon04,pon87,pon86,pon31,pon31t,pon19   #TQC-D50078 add pon19
                        FROM pon_file
                       WHERE pon01=g_pom.pom01
                    FOREACH upd_pon_cs INTO l_pon01,l_pon02,l_pon04,l_pon87,l_pon86,l_pon31,l_pon31t,l_pon19  #TQC-D50078
                       LET g_errno=''
                       CALL s_defprice_new(l_pon04,g_pom.pom09,g_pom.pom22,
                                      g_pom.pom04,l_pon87,'',g_pom.pom21,g_pom.pom43,'1',l_pon86,'',g_pom.pom41,g_pom.pom20,g_plant)
                           RETURNING l_pon31,l_pon31t,
                                     g_pmn73,g_pmn74 
                       CALL t580_price_check(l_pon31,l_pon31t) 
                       IF NOT cl_null(g_errno) THEN
                          CALL cl_err('',g_errno,1)
                          EXIT FOREACH
                       END IF

                       #重新取價後金額重算
                       LET l_pon88 = l_pon31 * l_pon87
                       LET l_pon88t= l_pon31t* l_pon87

                       UPDATE pon_file SET pon19 = l_pon19,
                                           pon31 = l_pon31,
                                           pon31t= l_pon31t,
                                           pon06 = l_pon06,
                                           pon88= l_pon88,
                                           pon88t= l_pon88t
                        WHERE pon01 = l_pon01 AND pon02 = l_pon02
                       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                          CALL cl_err3("upd","pon_file",l_pon01,l_pon02,STATUS,"","upd pon:",1)
                          EXIT FOREACH
                       END IF
                    END FOREACH
                   CALL t580_b_fill(' 1=1',' 1=1')                   
                   CALL t580_update()
                 END IF
              END IF
           END IF
           #MOD-B30413 add --end--
 
        ON ACTION mntn_vender
                    #LET g_cmd = "apmi600 ",g_pom.pom09 CLIPPED     #MOD-4B0255
                    #LET g_cmd = "apmi600 '' ",g_pom.pom09 CLIPPED  #MOD-4B0255 參數傳錯 #CHI-D30005 mark
                     LET g_cmd = "apmi600 '",g_pom.pom09,"' '' "    #CHI-D30005
                    CALL cl_cmdrun(g_cmd)
 
        ON ACTION qry_item_vender #查詢料件/廠商
                     LET g_cmd = "apmq210 '' ",g_pom.pom09 CLIPPED  #MOD-4B0255
                    CALL cl_cmdrun(g_cmd)
 
        ON ACTION qry_vender_item
                     LET g_cmd = "apmq220 ",g_pom.pom09 CLIPPED  #MOD-4B0255
                    CALL cl_cmdrun(g_cmd)
 
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pom01) #單據編號
                     LET g_t1 = s_get_doc_no(g_pom.pom01)       #No.FUN-540027
                     CALL q_smy(FALSE,FALSE,g_t1,'APM','8') RETURNING g_t1 #TQC-670008
                     LET g_pom.pom01=g_t1    #No.FUN-540027
                     DISPLAY BY NAME g_pom.pom01
                     NEXT FIELD pom01
               WHEN INFIELD(pom05)  #項目編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_pja2"  
                  CALL cl_create_qry() RETURNING g_pom.pom05 
                  DISPLAY BY NAME g_pom.pom05
                  NEXT FIELD pom05
                WHEN INFIELD(pom09) #查詢廠商檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc1"
                     LET g_qryparam.default1 = g_pom.pom09
                     CALL cl_create_qry() RETURNING g_pom.pom09
                     DISPLAY BY NAME g_pom.pom09
                     CALL t580_supplier('a','1',g_pom.pom09)
                     NEXT FIELD pom09
                WHEN INFIELD(pom17) #查詢廠商檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pmc1"
                     LET g_qryparam.default1 = g_pom.pom17
                     CALL cl_create_qry() RETURNING g_pom.pom17
                     DISPLAY BY NAME g_pom.pom17
                     CALL t580_supplier('a','2',g_pom.pom17)
                     NEXT FIELD pom09
                WHEN INFIELD(pom10) #查詢地址資料檔 (0:表送貨地址)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.default1 = g_pom.pom10
                     CALL cl_create_qry() RETURNING g_pom.pom10
                     DISPLAY BY NAME g_pom.pom10
                     NEXT FIELD pom10
                WHEN INFIELD(pom11) #查詢地址資料檔 (0:表送貨地址)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pme"
                     LET g_qryparam.default1 = g_pom.pom11
                     CALL cl_create_qry() RETURNING g_pom.pom11
                     DISPLAY BY NAME g_pom.pom11
                     NEXT FIELD pom11
                WHEN INFIELD(pom12) #採購員
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_pom.pom12
                     CALL cl_create_qry() RETURNING g_pom.pom12
                     DISPLAY BY NAME g_pom.pom12
                     CALL t580_peo('a','1',g_pom.pom12)
                     NEXT FIELD pom12
                WHEN INFIELD(pom15) #採購員
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gen"
                     LET g_qryparam.default1 = g_pom.pom15
                     CALL cl_create_qry() RETURNING g_pom.pom15
                     DISPLAY BY NAME g_pom.pom15
                     CALL t580_peo('a','2',g_pom.pom15)
                     NEXT FIELD pom12
                WHEN INFIELD(pom13) #請購DEPT
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_pom.pom13
                     CALL cl_create_qry() RETURNING g_pom.pom13
                     DISPLAY BY NAME g_pom.pom13
                     CALL t580_dep('a','1',g_pom.pom13)
                     NEXT FIELD pom13
                WHEN INFIELD(pom14) #收貨DEPT
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gem"
                     LET g_qryparam.default1 = g_pom.pom14
                     CALL cl_create_qry() RETURNING g_pom.pom14
                     DISPLAY BY NAME g_pom.pom14
                     CALL t580_dep('a','2',g_pom.pom14)
                     NEXT FIELD pom14
                WHEN INFIELD(pom16)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_ged"
                     LET g_qryparam.default1 = g_pom.pom16
                     CALL cl_create_qry() RETURNING g_pom.pom16
                     DISPLAY BY NAME g_pom.pom16
                     SELECT ged02 INTO l_ged02 FROM ged_file
                      WHERE ged01 = g_pom.pom16
                     DISPLAY l_ged02 TO FORMONLY.ged02
                     NEXT FIELD pom16
                WHEN INFIELD(pom20) #查詢付款條件資料檔(pma_file)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_pma"
                     LET g_qryparam.default1 = g_pom.pom20
                     CALL cl_create_qry() RETURNING g_pom.pom20
                     DISPLAY BY NAME g_pom.pom20
                     NEXT FIELD pom20
                WHEN INFIELD(pom21) #查詢稅別資料檔(gec_file)i
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gec"
                     LET g_qryparam.default1 = g_pom.pom21
                     LET g_qryparam.arg1 = '1'
                     CALL cl_create_qry() RETURNING g_pom.pom21
                     DISPLAY BY NAME g_pom.pom21
                     NEXT FIELD pom21
                WHEN INFIELD(pom22) #查詢幣別資料檔
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_azi"
                     LET g_qryparam.default1 = g_pom.pom22
                     CALL cl_create_qry() RETURNING g_pom.pom22
                     DISPLAY BY NAME g_pom.pom22
                     NEXT FIELD pom22
                WHEN INFIELD(pom42)
                   CALL s_rate(g_pom.pom22,g_pom.pom42) RETURNING g_pom.pom42
                   DISPLAY BY NAME g_pom.pom42
                   NEXT FIELD pom42
               WHEN INFIELD(pom41) #價格條件
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pnz01" #FUN-930113 oah-->pnz01
                  LET g_qryparam.default1 = g_pom.pom41
                  CALL cl_create_qry() RETURNING g_pom.pom41
                  DISPLAY BY NAME g_pom.pom41
                  SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pom.pom41 #FUN-930113 oah-->pnz
                  DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113 oah-->pnz
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
 
FUNCTION t580_supplier(p_cmd,p_code,p_key)  #供應廠商
        DEFINE l_pmc03   LIKE pmc_file.pmc03,
               l_pmc30   LIKE pmc_file.pmc30,
               l_pmcacti LIKE pmc_file.pmcacti,
               p_cmd     LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
               p_code    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
               p_key     LIKE pmc_file.pmc01
	
	LET g_errno = ' '
	SELECT pmc03,pmc30,pmcacti INTO l_pmc03,l_pmc30,l_pmcacti
	  FROM pmc_file
	 WHERE pmc01 = p_key
 
	CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3014'
                                       LET l_pmc03 = NULL
             WHEN l_pmcacti='N' LET g_errno = '9028'
             WHEN l_pmcacti MATCHES '[PH]'  LET g_errno = '9038'  #No.FUN-690024 add
             WHEN l_pmc30  ='2' LET g_errno = 'apm-420'   #MOD-7A0101 modify'mfg3227'      #付款商
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	END CASE
	IF cl_null(g_errno) OR p_cmd = 'd' THEN
           IF p_code = '1' THEN
              DISPLAY l_pmc03 TO FORMONLY.pmc03
           ELSE
              DISPLAY l_pmc03 TO FORMONLY.pmc03_2
           END IF
	END IF
END FUNCTION
 
FUNCTION t580_supplier_cd()  #供應廠商check ,default
	DEFINE l_pmc05   LIKE pmc_file.pmc05,   #廠商目前狀況
               l_pmcacti LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
               l_chr     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
	   LET g_chr = " "
	   #FOB/送貨地址/帳單地址/付款方式/付款幣別/列印抑制
	   SELECT pmc05,pmc15,pmc16,pmc17,pmc22,pmc47,pmc49,pmcacti
		 INTO l_pmc05,g_pom.pom10,g_pom.pom11,g_pom.pom20,
			  g_pom.pom22,g_pom.pom21,g_pom.pom41,l_pmcacti
		 FROM pmc_file
		WHERE pmc01 = g_pom.pom09 AND pmc30 IN ('1','3')
		CASE
		   WHEN l_pmc05 = '0'   #尚待核准    #No.FUN-690025
                      CALL cl_getmsg('mfg3174',g_lang) RETURNING g_msg
                      WHILE l_chr IS NULL OR l_chr NOT MATCHES'[YyNn]'
            LET INT_FLAG = 0  ######add for prompt bug
                            PROMPT g_msg CLIPPED FOR CHAR l_chr
                               ON IDLE g_idle_seconds
                                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                            END PROMPT
                            IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
                            IF l_chr MATCHES '[Nn]' THEN LET g_chr = 'e'  END IF
                       END WHILE
		   WHEN l_pmc05 = '3'  CALL cl_err(g_pom.pom09,'mfg3042',0)  #No.FUN-690025
                        LET g_chr = 's'
		   OTHERWISE EXIT CASE
		END CASE
                #TQC-BC0174--begin
                IF NOT cl_null(g_pom.pom22) THEN
                   IF g_aza.aza17 = g_pom.pom22 THEN   #本幣
                      LET g_pom.pom42 = 1
                   ELSE
                      CALL s_curr3(g_pom.pom22,g_pom.pom04,g_sma.sma904)
                      RETURNING g_pom.pom42
                   END IF
                END IF
                DISPLAY BY NAME g_pom.pom42
                #TQC-BC0174--end
		DISPLAY BY NAME g_pom.pom20         #付款條件
		DISPLAY BY NAME g_pom.pom22         #幣別
		DISPLAY BY NAME g_pom.pom21         #稅別
		DISPLAY BY NAME g_pom.pom41         #PRICE TERM
END FUNCTION
 
FUNCTION t580_peo(p_cmd,p_code,p_key)    #人員
         DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                l_gen02     LIKE gen_file.gen02,
                l_gen03     LIKE gen_file.gen03,
                l_genacti   LIKE gen_file.genacti,
                p_code      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
                p_key       LIKE gen_file.gen01
 
	  LET g_errno = ' '
	  SELECT gen02,genacti,gen03 INTO l_gen02,l_genacti,l_gen03
            FROM gen_file WHERE gen01 = p_key
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1312'
                                         LET l_gen02 = NULL
               WHEN l_genacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          IF p_code = '1' THEN
             DISPLAY l_gen02 TO FORMONLY.gen02
             IF p_cmd='a' THEN
                LET g_pom.pom13=l_gen03
                DISPLAY BY NAME g_pom.pom13
             END IF
          ELSE
             DISPLAY l_gen02 TO FORMONLY.gen02_2
          END IF
END FUNCTION
 
FUNCTION t580_dep(p_cmd,p_code,p_key)    #部門
         DEFINE p_cmd       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                l_gem02     LIKE gem_file.gem02,
                l_gemacti   LIKE gem_file.gemacti,
                p_code      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(01)
                p_key       LIKE gem_file.gem01
 
	  LET g_errno = ' '
	  SELECT gem02,gemacti INTO l_gem02,l_gemacti FROM gem_file
				  WHERE gem01 = p_key
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                         LET l_gem02 = NULL
               WHEN l_gemacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
          IF p_code = '1' THEN
             DISPLAY l_gem02 TO FORMONLY.gem02
          ELSE
             DISPLAY l_gem02 TO FORMONLY.gem02_2
          END IF
END FUNCTION
 
FUNCTION t580_pom20(p_cmd)  #付款條件
	 DEFINE    p_cmd      LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                   l_pma02    like pma_file.pma02,
                   l_pma06    like pma_file.pma06,
                   l_pmaacti  like pma_file.pmaacti
	
	 LET g_errno = " "
	   SELECT pma02,pma06,pmaacti INTO l_pma02,l_pma06,l_pmaacti
		  FROM pma_file WHERE pma01 = g_pom.pom20
 
	   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3099'
                                          LET l_pma06   = NULL
                                          LET l_pma02   = NULL
                                          LET l_pmaacti = NULL
		 WHEN l_pmaacti='N' LET g_errno = '9028'
		 OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	   END CASE
	   IF p_cmd = 'a' THEN LET g_pom.pom46 = l_pma06 END IF
	   DISPLAY l_pma02 TO pma02
END FUNCTION
 
FUNCTION t580_pom21()  #稅別
	  DEFINE  l_gec04   LIKE gec_file.gec04,
                  l_gecacti LIKE gec_file.gecacti
	
	  LET g_errno = " "
	  SELECT gec04,gecacti,gec07 INTO l_gec04,l_gecacti,g_gec07   #No.FUN-550089
            FROM gec_file
           WHERE gec01 = g_pom.pom21
             AND gec011='1'  #進項
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3044'
                                         LET l_gec04 = 0
               WHEN l_gecacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
	  IF NOT cl_null(l_gec04) THEN
		 LET g_pom.pom43 = l_gec04
		 DISPLAY BY NAME g_pom.pom43
	  END IF
          DISPLAY g_gec07 TO gec07
END FUNCTION
 
FUNCTION t580_pom10(p_code)    #check 地址
	  DEFINE  p_cmd   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
			  p_code  LIKE pme_file.pme01,
			  l_pme02 LIKE pme_file.pme02,
			  l_pmeacti LIKE pme_file.pmeacti
 
	  LET g_errno = " "
	  SELECT pme02,pmeacti INTO l_pme02,l_pmeacti FROM pme_file
  	  WHERE pme01 = p_code
 
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='mfg3012'
                                         LET l_pmeacti=NULL
               WHEN l_pmeacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
END FUNCTION
 
FUNCTION t580_pom22()  #幣別
	  DEFINE l_aziacti LIKE azi_file.aziacti
	
	  LET g_errno = " "
	  SELECT azi03,aziacti INTO t_azi03,l_aziacti FROM azi_file   #No.FUN-550089   #No.CHI-6A0004
					WHERE azi01 = g_pom.pom22
	  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                         LET l_aziacti = 0
               WHEN l_aziacti='N' LET g_errno = '9028'
               OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
	  END CASE
END FUNCTION
 
FUNCTION t580_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_pom.* TO NULL               #No.FUN-6A0162 
       MESSAGE ""
       CALL cl_opmsg('q')
       DISPLAY '   ' TO FORMONLY.cnt
       CALL t580_cs()                        # 宣告 SCROLL CURSOR
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLEAR FORM
          CALL g_pon.clear()
#FUN-C30057--add--begin--
#FUN-C30057--add--end--
          INITIALIZE g_pom.* TO NULL
          RETURN
       END IF
       MESSAGE " SEARCHING ! "
       OPEN t580_count
       FETCH t580_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       OPEN t580_cs                            # 從DB產生合乎條件TEMP(0-30秒)
       IF SQLCA.sqlcode THEN
          CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)
          INITIALIZE g_pom.* TO NULL
       ELSE
          CALL t580_fetch('F')                  # 讀出TEMP第一筆並顯示
          CALL t580_list_fill()                 #FUN-CB0014
       END IF
       MESSAGE " "

END FUNCTION
 
FUNCTION t580_fetch(p_flpom)
        DEFINE p_flpom          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
        CASE p_flpom
             WHEN 'N' FETCH NEXT     t580_cs INTO g_pom.pom01
             WHEN 'P' FETCH PREVIOUS t580_cs INTO g_pom.pom01
             WHEN 'F' FETCH FIRST    t580_cs INTO g_pom.pom01
             WHEN 'L' FETCH LAST     t580_cs INTO g_pom.pom01
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
                      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
                  END IF
                  FETCH ABSOLUTE g_jump t580_cs INTO g_pom.pom01
                  LET mi_no_ask = FALSE
        END CASE
 
	IF SQLCA.sqlcode THEN
           CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)
           INITIALIZE g_pom.* TO NULL  #TQC-6B0105
           RETURN
        ELSE
           CASE p_flpom
              WHEN 'F' LET g_curs_index = 1
              WHEN 'P' LET g_curs_index = g_curs_index - 1
              WHEN 'N' LET g_curs_index = g_curs_index + 1
              WHEN 'L' LET g_curs_index = g_row_count
              WHEN '/' LET g_curs_index = g_jump
           END CASE
 
           CALL cl_navigator_setting( g_curs_index, g_row_count )
        END IF
 
	SELECT * INTO g_pom.* FROM pom_file       # 重讀DB,因TEMP有不被更新特性
         WHERE pom01 = g_pom.pom01
        IF SQLCA.sqlcode THEN
            CALL cl_err3("sel","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1) #No.FUN-660129
        ELSE
            LET g_t1 = s_get_doc_no(g_pom.pom01)       #No.FUN-540027
            SELECT * INTO g_smy.* FROM smy_file WHERE smyslip=g_t1
            LET g_data_owner = g_pom.pomuser      #FUN-4C0056 add
            LET g_data_group = g_pom.pomgrup      #FUN-4C0056 add
            LET g_data_plant = g_pom.pomplant #FUN-980030
            CALL s_get_bookno(YEAR(g_pom.pom04)) RETURNING g_flag,g_bookno1,g_bookno2
            IF g_flag =  '1' THEN  #抓不到帳別
               CALL cl_err(g_pom.pom04,'aoo-081',1)
            END IF
            CALL t580_show()                      # 重新顯示
        END IF
END FUNCTION
 
FUNCTION t580_show()
	  DEFINE l_str   LIKE imd_file.imd01    #No.FUN-680136 VARCHAR(10)
	  DEFINE l_buf   LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(20)
          DEFINE l_ged02 LIKE ged_file.ged02    #No.FUN-930152
 
	  LET g_pom_t.* = g_pom.*
	  LET g_pom_o.* = g_pom.*
	  DISPLAY BY NAME
              g_pom.pom01,g_pom.pom04,g_pom.pom09,g_pom.pom18,              #No.FUN-830161
              g_pom.pom20,g_pom.pom41,g_pom.pom10,g_pom.pom11,
              g_pom.pom12,g_pom.pom13,g_pom.pom21,g_pom.pom43,
              g_pom.pom22,g_pom.pom42,g_pom.pom40,g_pom.pom40t, #MOD-490337補上g_pom.pom40顯示出總金額  FUN-610018
              g_pom.pom45,g_pom.pom25,g_pom.pommksg,
              g_pom.pom14,g_pom.pom15,g_pom.pom16,g_pom.pom17,
              g_pom.pom30,g_pom.pom44,g_pom.pom05,             #FUN-810045 add pom05
             #g_pom.pomuser,g_pom.pomgrup,g_pom.pomdate,g_pom.pomacti,
              g_pom.pomuser,g_pom.pomgrup,g_pom.pomdate,g_pom.pomacti,g_pom.pommodu,  #TQC-C30126
              g_pom.pomud01,g_pom.pomud02,g_pom.pomud03,g_pom.pomud04,
              g_pom.pomud05,g_pom.pomud06,g_pom.pomud07,g_pom.pomud08,
              g_pom.pomud09,g_pom.pomud10,g_pom.pomud11,g_pom.pomud12,
              g_pom.pomud13,g_pom.pomud14,g_pom.pomud15 
 
        #CKP
        IF g_pom.pom18='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
        IF g_pom.pom25='1' OR
           g_pom.pom25='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
        IF g_pom.pom25='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
        CALL cl_set_field_pic(g_pom.pom18,"",g_chr2,g_chr3,g_chr,"")
        CALL s_pmmsta('pmm',g_pom.pom25,g_pom.pom18,g_pom.pommksg)
                       RETURNING g_sta
        DISPLAY g_sta TO FORMONLY.desc2
        IF NOT cl_null(g_pom.pom16) THEN
           SELECT ged02 INTO l_ged02 FROM ged_file
            WHERE ged01 = g_pom.pom16
           DISPLAY l_ged02 TO FORMONLY.ged02
        ELSE
           DISPLAY ' ' TO FORMONLY.ged02
        END IF
        CALL t580_peo('d','1',g_pom.pom12)
        CALL t580_peo('d','2',g_pom.pom15)
        CALL t580_dep('d','1',g_pom.pom13)
        CALL t580_dep('d','2',g_pom.pom14)
        CALL t580_supplier('d','1',g_pom.pom09)
        CALL t580_supplier('d','2',g_pom.pom17)
        CALL t580_pom20('d')
        CALL t580_pom21()          #No.FUN-550089
        CALL t580_pom22()          #No.FUN-550089
        SELECT pnz02 INTO l_buf FROM pnz_file WHERE pnz01=g_pom.pom41 #FUN-930113 oah-->pnz
        DISPLAY l_buf TO FORMONLY.pnz02 #FUN-930113 oah-->pnz
        CALL t580_b_fill(g_wc2,g_wc3) #單身
#FUN-C30057--add--begin
#FUN-C30057--add--end-- 
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        CALL t580_list_fill()                     #FUN-CB0014
END FUNCTION
 
FUNCTION t580_b_fill(p_wc2,p_wc3)      #FUN-C30057 add 第二個參數，服飾中母單身的條件
	   DEFINE
                  p_wc2    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
		  l_sql    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(300)
		  l_name   LIKE gfe_file.gfe01     #No.FUN-680136 VARCHAR(04)
       DEFINE p_wc3    STRING                  #FUN-C30057 add

#&ifndef STD
#&else          #FUN-C30057 mark
#FUN-C30057--add--begin--
      LET l_sql="SELECT pon02,'',pon04,pon041,ima021,pon07,pon19,pon20,pon83,pon84,pon85,",  #NO.FUN-A80001 add pon19
                     "       pon80,pon81,pon82,pon86,pon87,pon21,0,pon31,",
                     "       pon31t,pon06,  ",      #No.FUN-550089
                     "       ponud01,ponud02,ponud03,ponud04,ponud05,",
                     "       ponud06,ponud07,ponud08,ponud09,ponud10,",
                     "       ponud11,ponud12,ponud13,ponud14,ponud15 ",
                     " FROM pon_file, OUTER ima_file ",
                     " WHERE pon01= '",g_pom.pom01,"' AND ",g_wc2 CLIPPED,
                     "   AND pon_file.pon04=ima_file.ima01 ",
                     " ORDER BY pon02"
#FUN-C30057--add--end--    
           
           #No.FUN-550098  --end
	   PREPARE t580_pp FROM l_sql
	   IF SQLCA.sqlcode THEN
		  CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
                  EXIT PROGRAM   #No.FUN-660129
	   END IF
	   DECLARE t580_cs2 CURSOR FOR t580_pp
           CALL g_pon.clear()
	   LET g_cnt=1
	   FOREACH t580_cs2 INTO g_pon[g_cnt].*
		  IF SQLCA.sqlcode THEN
                     CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
		  END IF
                  LET g_pon[g_cnt].diff = g_pon[g_cnt].pon20-g_pon[g_cnt].pon21
		  LET g_cnt=g_cnt+1
                  IF g_cnt > g_max_rec THEN
                     CALL cl_err( '', 9035, 0 )
                     EXIT FOREACH
                  END IF
	   END FOREACH
           CALL g_pon.deleteElement(g_cnt)
           LET g_rec_b=g_cnt - 1
           DISPLAY g_rec_b TO FORMONLY.cn2
           LET g_cnt = 0
END FUNCTION

#FUN-C30057-------begin-----------
#FUN-C30057--add--end--

FUNCTION t580_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_chr='@'
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_pon TO s_pon.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
        CALL cl_navigator_setting( g_curs_index, g_row_count )
       #TQC-C60245 -- mark -- begin
       #LET g_action_choice = 'insert'   
       #CALL cl_chk_act_auth_nomsg()   #No.TQC-630284 add
       #IF NOT cl_chk_act_auth() THEN
       #    CALL cl_set_act_visible("insert",FALSE)
       #END IF
       #CALL cl_chk_act_auth_showmsg()   #CHI-B10026
       #TQC-C60245 -- mark -- end
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
    #FUN-CB0014 -----Begin------
      ON ACTION info_list
         LET g_action_flag="info_list"    
         EXIT DISPLAY
    #FUN-CB0014 -----End--------

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
         CALL t580_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t580_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t580_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t580_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t580_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL t580_def_form()     #FUN-610067
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  #N0.TQC-710042
         END IF 
         #CKP
         IF g_pom.pom18='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_pom.pom25='1' OR
            g_pom.pom25='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         IF g_pom.pom25='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
         CALL cl_set_field_pic(g_pom.pom18,"",g_chr2,g_chr3,g_chr,"")
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
    #@ON ACTION 供應商資料
      ON ACTION vender
         LET g_action_choice="vender"
         EXIT DISPLAY
 
    #@ON ACTION 特別說明
      ON ACTION special_description
         LET g_action_choice="special_description"
         EXIT DISPLAY
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
#FUN-D20025 add
    #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
#FUN-D20025 add             
    #@ON ACTION 採購狀況查詢
      ON ACTION qry_po_status
         LET g_action_choice="qry_po_status"
         EXIT DISPLAY
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
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
 
 
      ON ACTION exporttoexcel       #FUN-4B0025
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
      
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DISPLAY
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-C30057--add--begin--
#FUN-C30057--add--end--

#FUN-CB0014 ------------------Begin-----------------
FUNCTION t580_bp1(p_ud)

   DEFINE   p_ud   LIKE type_file.chr1    
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
   LET g_chr='@'
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
      DISPLAY ARRAY g_pom_1 TO s_pom_1.*
 
         BEFORE DISPLAY
            CALL cl_navigator_setting( g_curs_index, g_row_count )
            CALL fgl_set_arr_curr(g_curs_index)

         BEFORE ROW
            LET l_ac1 = ARR_CURR()
            LET g_curs_index = l_ac1
            CALL cl_show_fld_cont()  
      END  DISPLAY      
 
      ON ACTION main
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         IF g_rec_b1 >0 THEN
             CALL t580_fetch('/')
         END IF
         CALL cl_set_comp_visible("page3", FALSE)
         CALL cl_set_comp_visible("page4", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page3", TRUE)
         CALL cl_set_comp_visible("page4", TRUE)
         EXIT DIALOG

      ON ACTION accept
         LET g_action_flag = 'main'
         LET l_ac1 = ARR_CURR()
         LET g_jump = l_ac1
         LET mi_no_ask = TRUE
         CALL t580_fetch('/')
         CALL cl_set_comp_visible("page4", FALSE)
         CALL cl_set_comp_visible("page4", TRUE)
         CALL cl_set_comp_visible("page3", FALSE)
         CALL ui.interface.refresh()
         CALL cl_set_comp_visible("page3", TRUE)
         EXIT DIALOG 

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
         CALL t580_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
      ACCEPT DIALOG                   
 
 
      ON ACTION previous
         CALL t580_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index) 
         END IF
	  ACCEPT DIALOG                   
 
 
      ON ACTION jump
         CALL t580_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	  ACCEPT DIALOG                   
 
 
      ON ACTION next
         CALL t580_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index)  
         END IF
	  ACCEPT DIALOG                   
 
 
      ON ACTION last
         CALL t580_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b1 != 0 THEN
            CALL fgl_set_arr_curr(g_curs_index) 
         END IF
	  ACCEPT DIALOG                   
 
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
         
      #TQC-D10084--mark--str--
      #ON ACTION detail
      #   LET g_action_choice="detail"
      #   LET l_ac = 1
      #   EXIT DIALOG
      #TQC-D10084--mark--end--
         
      ON ACTION output
         LET g_action_choice="output"
         EXIT DIALOG
         
      ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   
         CALL t580_def_form()     
         IF g_aza.aza71 MATCHES '[Yy]' THEN       
            CALL aws_gpmcli_toolbar()
            CALL cl_set_act_visible("gpm_show,gpm_query", TRUE)
         ELSE
            CALL cl_set_act_visible("gpm_show,gpm_query", FALSE)  
         END IF 
         #CKP
         IF g_pom.pom18='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         IF g_pom.pom25='1' OR
            g_pom.pom25='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
         IF g_pom.pom25='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
         CALL cl_set_field_pic(g_pom.pom18,"",g_chr2,g_chr3,g_chr,"")
         EXIT DIALOG
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG
 

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DIALOG
         
    #@ON ACTION 供應商資料
      ON ACTION vender
         LET g_action_choice="vender"
         EXIT DIALOG
 
    #@ON ACTION 特別說明
      ON ACTION special_description
         LET g_action_choice="special_description"
         EXIT DIALOG
         
    #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DIALOG
#FUN-D20025 add
    #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DIALOG 
#FUN-D20025 add             
    #@ON ACTION 採購狀況查詢
      ON ACTION qry_po_status
         LET g_action_choice="qry_po_status"
         EXIT DIALOG
         
    #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DIALOG
         
    #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DIALOG
 
      ON ACTION CANCEL
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"
         EXIT DIALOG
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DIALOG
 
      ON ACTION about         
         CALL cl_about()     
  
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DIALOG
 
      AFTER DIALOG
         CONTINUE DIALOG
      
      ON ACTION controls                                      
         CALL cl_set_head_visible("","AUTO")       
 
      ON ACTION related_document                
         LET g_action_choice="related_document"          
         EXIT DIALOG
 
      ON ACTION gpm_show
         LET g_action_choice="gpm_show"
         EXIT DIALOG
         
      ON ACTION gpm_query
         LET g_action_choice="gpm_query"
         EXIT DIALOG
 
      &include "qry_string.4gl"
 
   END DIALOG
   CALL cl_set_act_visible("accept,cancel", TRUE)

END FUNCTION

FUNCTION t580_list_fill()
DEFINE  l_pom01      LIKE pom_file.pom01
DEFINE  l_cnt        LIKE type_file.num10 

   CALL g_pom_1.clear()
   LET l_cnt = 1
   FOREACH t580_fill_cs INTO l_pom01
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach item_cur',SQLCA.sqlcode,1)
         CONTINUE FOREACH
      END IF   
   
      SELECT pom01,pom04,pom09,pmc03,pom18,pom25,pom20,pma02,pom41,pnz02,
             pom12,gen02,pom13,gem02,pommksg
        INTO g_pom_1[l_cnt].*
        FROM pom_file LEFT OUTER JOIN pmc_file ON pom09 = pmc01 
                      LEFT OUTER JOIN pma_file ON pom20 = pma01
                      LEFT OUTER JOIN pnz_file ON pom41 = pnz01
                      LEFT OUTER JOIN gen_file ON pom12 = gen01
                      LEFT OUTER JOIN gem_file ON pom13 = gem01
       WHERE pom01 = l_pom01

       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
          IF g_action_choice ="query"  THEN
            CALL cl_err( '', 9035, 0 )
          END IF
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b1 = l_cnt - 1
    
    DISPLAY ARRAY g_pom_1 TO s_pom_1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
       BEFORE DISPLAY
          EXIT DISPLAY
    END DISPLAY

END FUNCTION 

#FUN-CB0014 ------------------End-------------------

FUNCTION t580_u()
	DEFINE   l_pon02    LIKE pon_file.pon02
	DEFINE   l_pon31    LIKE pon_file.pon31
	DEFINE   l_pon44    LIKE pon_file.pon44
	DEFINE   l_flag     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
	IF s_shut(0) THEN RETURN END IF
       #IF g_pom.pom01 IS NULL THEN CALL cl_err('',-420,0) RETURN END IF
	IF g_pom.pom01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF  #TQC-C10020
        SELECT * INTO g_pom.* FROM pom_file
         WHERE pom01=g_pom.pom01
	IF g_pom.pomacti ='N' THEN    #檢查資料是否為無效
	   CALL cl_err(g_pom.pom01,9027,0) RETURN
	END IF
        IF g_pom.pom18='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
        IF g_argv2 = '0' AND g_pom.pom25 = "1" AND g_pom.pommksg = "Y"  THEN
           CALL cl_err('','mfg3168',0) RETURN
        END IF
        IF g_argv2 MATCHES '[01]' AND g_pom.pom25 MATCHES'[269]' THEN
           CALL cl_err('','mfg9136',0) RETURN
        END IF
        MESSAGE ""
        CALL cl_opmsg('u')
        LET g_pom01_t = g_pom.pom01
        BEGIN WORK
 
        OPEN t580_cl USING g_pom.pom01
        IF STATUS THEN
           CALL cl_err("OPEN t580_cl:", STATUS, 1)
           CLOSE t580_cl
           ROLLBACK WORK
           RETURN
        END IF
        FETCH t580_cl INTO g_pom.*               # 對DB鎖定
        IF SQLCA.sqlcode THEN
           CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)
           CLOSE t580_cl
           ROLLBACK WORK
           RETURN
        END IF
          LET g_pom.pommodu=g_user                     #修改者
          LET g_pom.pomdate = g_today                  #修改日期
          CALL t580_show()                             # 顯示最新資料
          WHILE TRUE
            LET g_pom_o.* = g_pom.*
            CALL t580_i("u")                         # 欄位更改
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET g_pom.*=g_pom_t.*
               CALL t580_show()
               CALL cl_err('',9001,0)
               EXIT WHILE
            END IF
            LET l_flag='N'
            IF (NOT cl_null(g_pom_t.pom42)) AND (NOT cl_null(g_pom.pom42))
               THEN
               IF g_pom_t.pom42 != g_pom.pom42 THEN
                  LET l_flag='Y'
               END IF
            END IF
 
           IF g_pom.pommksg  MATCHES'[Yy]'  THEN
              IF g_argv2='1' THEN #為巳核准
                IF g_sma.sma77 = '2' THEN #不可重簽
                   CALL cl_err('','mfg6144',0)
                   CALL s_signm(6,34,g_lang,'2',g_pom.pom01,3,g_pom.pomsign,
                    g_pom.pomdays,g_pom.pomprit,g_pom.pomsmax,g_pom.pomsseq)
                ELSE  #可重簽
                   CALL s_signm(6,34,g_lang,'1',g_pom.pom01,3,g_pom.pomsign,
                    g_pom.pomdays,g_pom.pomprit,g_pom.pomsmax,g_pom.pomsseq)
                    RETURNING g_pom.pomsign,       #等級
                              g_pom.pomdays,
                              g_pom.pomprit,
                              g_pom.pomsmax,       #應簽
                              g_pom.pomsseq,       #已簽
                              g_statu
                   #重簽的處理1:將巳簽歸零2:過程檔delete 3:狀況碼為0.開立
                    LET g_pom.pomsseq = 0
                    LET g_pom.pom25   = '0'
                    DELETE FROM azd_file WHERE azd01=g_pom.pom01 AND azd02 = 3
                END IF
              ELSE  #不為巳准單號
                CALL s_signm(6,34,g_lang,'1',g_pom.pom01,3,g_pom.pomsign,
                 g_pom.pomdays,g_pom.pomprit,g_pom.pomsmax,g_pom.pomsseq)
                 RETURNING g_pom.pomsign,       #等級
                           g_pom.pomdays,
                           g_pom.pomprit,
                           g_pom.pomsmax,       #應簽
                           g_pom.pomsseq,       #已簽
                           g_statu
               END IF
            END IF
            IF cl_null(g_pom.pom03) THEN LET g_pom.pom03=0 END IF
            UPDATE pom_file SET pom_file.* = g_pom.*    # 更新DB
             WHERE pom01 = g_pom.pom01             # COLAUTH?
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               CONTINUE WHILE
            END IF
        IF g_pom.pom01 != g_pom_t.pom01 THEN
           UPDATE pon_file SET pon01=g_pom.pom01 WHERE pon01=g_pom_t.pom01
           IF STATUS THEN
              CALL cl_err3("upd","pon_file",g_pom_t.pom01,"",STATUS,"","upd pon01",1)  #No.FUN-660129
              ROLLBACK WORK RETURN
           END IF
           UPDATE pmo_file SET pmo01=g_pom.pom01 WHERE pmo01=g_pom_t.pom01
           UPDATE pmp_file SET pmp01=g_pom.pom01 WHERE pmp01=g_pom_t.pom01
        END IF
        #如單頭性質更改,單身也須更改96-09-13
	 #更改單身狀況
        DECLARE t580_stat CURSOR FOR SELECT pon02,pon31 FROM pon_file
                                      WHERE pon01 = g_pom.pom01
        IF NOT SQLCA.sqlcode THEN
           CALL s_showmsg_init()        #No.FUN-710030
           FOREACH t580_stat INTO l_pon02,l_pon31
    ###950228 Add By Jackson 異動匯率,更改本幣單價
              IF g_success="N" THEN
                 LET g_totsuccess="N"
                 LET g_success="Y"
              END IF
           IF l_flag='Y' THEN
              LET l_pon44=cl_digcut(l_pon31*g_pom.pom42,g_azi03)   #No.CHI-6A0004
              UPDATE pon_file SET pon16 = g_pom.pom25,
                                  pon44=l_pon44
               WHERE pon01 = g_pom.pom01 AND pon02 = l_pon02
           ELSE
              UPDATE pon_file SET pon16 = g_pom.pom25
               WHERE pon01 = g_pom.pom01 AND pon02 = l_pon02
           END IF
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                 LET g_showmsg = g_pom.pom01,"/",l_pon02
                 CALL s_errmsg("pon01,pon02",g_showmsg,"",SQLCA.sqlcode,1)
                 CONTINUE FOREACH
              ELSE
                 CALL cl_err3("upd","pon_file",g_pom.pom01,l_pon02,SQLCA.sqlcode,"","",1)
              END IF
           END IF
          END FOREACH
          IF g_totsuccess="N" THEN
             LET g_success="N"
          END IF
 
        END IF
        EXIT WHILE
    END WHILE
     CALL t580_b_fill(' 1=1',' 1=1') 
    CLOSE t580_cl
    CALL s_showmsg()       #No.FUN-710030
    COMMIT WORK
    CALL cl_flow_notify(g_pom.pom01,'U')
END FUNCTION
 
FUNCTION t580_sign(p_cmd)
	  DEFINE     p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
                     l_slip   LIKE oay_file.oayslip,  #No.FUN-680136 VARCHAR(05)#No.FUN-540027
                     l_pomsign   LIKE pom_file.pomsign
 
	 IF cl_null(g_pom.pom01) THEN RETURN END IF
	 IF g_pom.pommksg MATCHES'[nN]' OR g_pom.pom25 matches'[269]'
             THEN RETURN
	 END IF
         LET g_pom.pomdays=g_smy.smydays #1999/04/21 add by Carol
	 IF p_cmd = 'a' OR g_argv2 matches'[0X]' THEN
            LET g_pom.pomdays=g_smy.smydays
            LET l_pomsign = ' '
            IF p_cmd = 'b' THEN
               LET g_smy.smyatsg=' '
               LET l_slip = s_get_doc_no(g_pom.pom01)       #No.FUN-540027
               SELECT smyatsg INTO g_smy.smyatsg FROM smy_file
                WHERE smyslip = l_slip
               SELECT pomsign INTO l_pomsign FROM pom_file
                WHERE pom01 = g_pom.pom01
            END IF
            IF g_smy.smyatsg matches'[Yy]' THEN   #自動賦予簽核等級
               CALL s_sign(g_pom.pom01,3,'pom01','pom_file')
                RETURNING g_pom.pomsign
            END IF
            CALL signm_count(g_pom.pomsign) RETURNING g_pom.pomsmax
            IF l_pomsign != g_pom.pomsign THEN
               UPDATE pom_file SET pomsign = g_pom.pomsign,
                                   pomsmax = g_pom.pomsmax,
                                   pomdays = g_pom.pomdays,
                                   pomprit = g_pom.pomprit,
                                   pomsseq = 0
               WHERE pom01 = g_pom.pom01
               DELETE FROM azd_file WHERE azd01 = g_pom.pom01 AND azd02 = 3
            END IF
	 ELSE
            IF g_argv2 = '1' THEN  #已核准P/R
               #重簽的處理1:將巳簽歸零2:過程檔delete 3:狀況碼為開立
               #如為自動符予簽核等級則要重新來過
               IF g_sma.sma77 = '1' THEN  #需重簽
                  LET g_smy.smyatsg = ' '
                LET l_slip = s_get_doc_no(g_pom.pom01)       #No.FUN-540027
               SELECT smyatsg INTO g_smy.smyatsg FROM smy_file
                   WHERE smyslip = l_slip
                  IF g_smy.smyatsg matches'[Yy]' THEN
                     CALL s_sign(g_pom.pom01,3,'pom01','pom_file')
                      RETURNING l_pomsign
                  ELSE
                     CALL s_signm(6,34,g_lang,'1',g_pom.pom01,3,g_pom.pomsign,
                                  g_pom.pomdays,g_pom.pomprit,g_pom.pomsmax,
                                  g_pom.pomsseq)
                     RETURNING l_pomsign,       #等級
                               g_pom.pomdays,
                               g_pom.pomprit,
                               g_pom.pomsmax,       #應簽
                               g_pom.pomsseq,       #已簽
                               g_statu
                  END IF
                  IF l_pomsign != g_pom.pomsign THEN
                     CALL signm_count(l_pomsign) RETURNING g_pom.pomsmax
                     UPDATE pom_file SET pomsseq = 0,
                                         pom25 = '0',
                                         pomsmax = g_pom.pomsmax,
                                         pomsign = l_pomsign,
                                         pomdays = g_pom.pomdays,
                                         pomprit = g_pom.pomprit
                     WHERE pom01 = g_pom.pom01
                     DELETE FROM azd_file
                      WHERE azd01 = g_pom.pom01 AND azd02 = 3 END IF
		  ELSE
                     CALL s_signm(6,34,g_lang,'1',g_pom.pom01,3,g_pom.pomsign,
                       g_pom.pomdays,g_pom.pomprit,g_pom.pomsmax,g_pom.pomsseq)
                     RETURNING l_pomsign,       #等級
                               g_pom.pomdays,
                               g_pom.pomprit,
                               g_pom.pomsmax,       #應簽
                               g_pom.pomsseq,       #已簽
                               g_statu
                     IF l_pomsign != g_pom.pomsign THEN
                        CALL signm_count(l_pomsign) RETURNING g_pom.pomsmax
                        UPDATE pom_file SET pomsseq = 0,pom25 = '0',
                                            pomsmax = g_pom.pomsmax,
                                            pomsign = l_pomsign,
                                            pomdays = g_pom.pomdays,
                                            pomprit = g_pom.pomprit
                         WHERE pom01 = g_pom.pom01
                         DELETE FROM azd_file
                          WHERE azd01 = g_pom.pom01 AND azd02 = 3
                     END IF
		   END IF
		END IF
	 END IF
END FUNCTION
	
FUNCTION t580_r()
    DEFINE l_chr,l_sure LIKE type_file.chr1      #No.FUN-680136 VARCHAR(1)
#    DEFINE l_qty	LIKE ima_file.ima26       #No.FUN-680136  DECIMAL(15,3) #FUN-A20044
    DEFINE l_qty	LIKE type_file.num15_3       #No.FUN-680136  DECIMAL(15,3) #FUN-A20044
    DEFINE l_pon	RECORD LIKE pon_file.*
    DEFINE l_oeb01      LIKE oeb_file.oeb01    #NO.FUN-C30057
    IF s_shut(0) THEN RETURN END IF
    IF g_pom.pom01 IS NULL THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6A0162
       RETURN 
    END IF
    SELECT * INTO g_pom.* FROM pom_file
     WHERE pom01=g_pom.pom01
    IF g_pom.pom18='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_pom.pom18='X' THEN CALL cl_err('','9024',0) RETURN END IF
    IF g_pom.pom01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_pom.pom25 = '2' THEN CALL cl_err('','axm-101',0) RETURN END IF
    BEGIN WORK
 
    OPEN t580_cl USING g_pom.pom01
    IF STATUS THEN
       CALL cl_err("OPEN t580_cl:", STATUS, 1)
       CLOSE t580_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t580_cl INTO g_pom.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t580_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "pom01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_pom.pom01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        MESSAGE "Delete pom,pon,pmo,pmp!"
        DELETE FROM pom_file WHERE pom01 = g_pom.pom01
        IF SQLCA.SQLERRD[3]=0 THEN
             CALL cl_err3("del","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","No pom deleted",1)  #No.FUN-660129
                ROLLBACK WORK RETURN
        END IF
        DECLARE t580_r_c CURSOR FOR
                SELECT * FROM pon_file WHERE pon01=g_pom.pom01
        CALL s_showmsg_init()        #No.FUN-710030
        FOREACH t580_r_c INTO l_pon.*
           IF g_success="N" THEN
              LET g_totsuccess="N"
              LET g_success="Y"
           END IF
 
           DELETE FROM pon_file
                WHERE pon01=l_pon.pon01 AND pon02=l_pon.pon02
           IF SQLCA.SQLERRD[3]=0          #modi by kitty96-05-24
                THEN
              IF g_bgerr THEN
                 LET g_totsuccess="N"
                 LET g_showmsg = l_pon.pon01,"/",l_pon.pon02
                 CALL s_errmsg("pon01,pon02",g_showmsg,"No pon deleted",SQLCA.sqlcode,1)
                 CONTINUE FOREACH
              ELSE
                 CALL cl_err3("del","pon_file",l_pon.pon01,l_pon.pon02,SQLCA.sqlcode,"","l_pon.pon02",1)
                 ROLLBACK WORK
                 RETURN
              END IF
           
           END IF
        END FOREACH
        IF g_totsuccess="N" THEN
           LET g_success="N"
        END IF
#FUN-C30057--add--begin-- 
#FUN-C30057--add--end--
        DELETE FROM pmo_file WHERE pmo01 = g_pom.pom01
        DELETE FROM pmp_file WHERE pmp01 = g_pom.pom01
        LET g_msg=TIME
        INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #FUN-980006 add azoplant,azolegal
           VALUES ('apmt580',g_user,g_today,g_msg,g_pom.pom01,'delete',g_plant,g_legal) #FUN-980006 add g_plant,g_legal
        CLEAR FORM
        CALL g_pon.clear()
#FUN-C30057--add--begin--
#FUN-C30057--add--end--        
    	INITIALIZE g_pom.* TO NULL
        MESSAGE ""
        OPEN t580_count
        #FUN-B50063-add-start--
        IF STATUS THEN
           CLOSE t580_cs
           CLOSE t580_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50063-add-end-- 
        FETCH t580_count INTO g_row_count
        #FUN-B50063-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t580_cs
           CLOSE t580_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50063-add-end--
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t580_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t580_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t580_fetch('/')
        END IF
    END IF
    CLOSE t580_cl
    IF g_success="N" THEN
       CALL s_showmsg()       #No.FUN-710030
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
    CALL cl_flow_notify(g_pom.pom01,'D')
END FUNCTION
 
FUNCTION t580_copy()
  DEFINE
     l_newno         LIKE pom_file.pom01,
     l_newdate       LIKE pom_file.pom04,   #MOD-950258
     l_pom31         LIKE pom_file.pom31,   #MOD-950258
     l_pom32         LIKE pom_file.pom32,   #MOD-950258
     p_stat          LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(01)
     l_oldno         LIKE pom_file.pom01,
     l_pom01_t       LIKE pom_file.pom01
  DEFINE li_result   LIKE type_file.num5       #No.FUN-540027  #No.FUN-680136 SMALLINT
     IF s_shut(0) THEN RETURN END IF
     #TQC-C10020 mark---------------
     #IF g_pom.pom01 IS NULL THEN
     #   CALL cl_err('',-420,0)
     #   RETURN
     #END IF
     #TQC-C10020 mark end-----------
     IF g_pom.pom01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF  #TQC-C10020
     IF g_argv2 MATCHES '[Yy]' THEN
        CALL cl_err('','mfg0055',0)
        RETURN
     END IF
 
      LET g_before_input_done = FALSE  #MOD-480239
      CALL t580_set_entry_b('a')       #MOD-480239
      LET g_before_input_done = TRUE   #MOD-480239
      LET l_newdate=NULL   #MOD-950258
     CALL cl_set_comp_entry("pom01",true) #TQC-BB0177 
     CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
     INPUT l_newno,l_newdate WITHOUT DEFAULTS FROM pom01,pom04   #MOD-950258 add
	  BEFORE INPUT
	     CALL cl_set_docno_format("pom01")
 
          AFTER FIELD pom01
             BEGIN WORK #No:7857
             IF NOT cl_null(l_newno) THEN
              CALL s_check_no("apm",l_newno,"","8","pom_file","pom01","")
                   RETURNING li_result,l_newno
              DISPLAY l_newno TO pom01
              IF (NOT li_result) THEN
                 NEXT FIELD pom01
              END IF
              END IF
              AFTER FIELD pom04
                IF cl_null(l_newdate) THEN
                   NEXT FIELD pom04
                ELSE
                  SELECT azn02,azn04 INTO l_pom31,l_pom32 FROM azn_file
                   WHERE azn01 = l_newdate
                  IF SQLCA.sqlcode THEN
                     CALL cl_err3("sel","azn_file",l_newdate,"","mfg0027","","",1)
                     LET l_newdate = g_pom.pom04
                     DISPLAY l_newdate TO pom04
                     NEXT FIELD pom04
                  END IF
                  CALL s_get_bookno(YEAR(l_newdate))
                       RETURNING g_flag,g_bookno1,g_bookno2
                  IF g_flag =  '1' THEN  #抓不到帳別
                     CALL cl_err(l_newdate,'aoo-081',1)
                     NEXT FIELD pom04
                  END IF
                END IF
 
         CALL s_auto_assign_no("apm",l_newno,l_newdate,"8","pom_file","pom01","","","")
              RETURNING li_result,l_newno
         IF (NOT li_result) THEN
            NEXT FIELD pom01
         END IF
         DISPLAY l_newno TO pom01
 
         ON ACTION CONTROLP
            CASE
                WHEN INFIELD(pom01) #單據編號
                     LET g_t1 = s_get_doc_no(l_newno)       #No.FUN-540027
                     CALL q_smy(FALSE,FALSE,g_t1,'APM','8') RETURNING g_t1 #TQC-670008
                     LET l_newno=g_t1         #No.FUN-540027
                     DISPLAY l_newno TO pom01
                     NEXT FIELD pom01
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
       LET INT_FLAG = 0
	ROLLBACK WORK
        SELECT pom_file.* INTO g_pom.* FROM pom_file #TQC-BB0177
        WHERE pom01 = l_oldno   #TQC-BB0177
       DISPLAY BY NAME g_pom.pom01,g_pom.pomoriu,g_pom.pomorig
       RETURN
    END IF
    DROP TABLE y
    IF g_pom.pommksg = 'N' THEN
       LET p_stat = '1' ELSE  LET p_stat = '0'
    END IF
    SELECT * FROM pom_file         #單頭複製
     WHERE pom01=g_pom.pom01
    INTO TEMP y
    UPDATE y
         SET pom01=l_newno,    #新的鍵值
             pom03= 0     ,    #更動序號
             pom04= l_newdate,   #單據日期   #MOD-950258
             pom18= 'N',
             pom25= '0'   ,    #狀況碼
             pom27= g_today,   #狀況日期
             pomsseq=0,        #已簽人數
             pomprdt= NULL,    #列印日期
             pomprno= 0,       #列印次數
             pomuser=g_user,   #資料所有者
             pomgrup=g_grup,   #資料所有者所屬群
             pommodu=NULL,     #資料修改日期
             pomdate=g_today,  #資料建立日期
             pomacti='Y'       #有效資料
    INSERT INTO pom_file
        SELECT * FROM y
         IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
           ROLLBACK WORK
           RETURN
         ELSE	
           COMMIT WORK
         END IF
#FUN-C30057--add--begin--
#FUN-C30057--add--end-- 
    DROP TABLE x
    SELECT * FROM pon_file         #單身複製
     WHERE pon01=g_pom.pom01
      INTO TEMP x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","x",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       RETURN
    END IF
    UPDATE x
        SET pon01=l_newno,
            pon05= ' ',
            pon16= '0',
            pon65='1',
            pon41= ' ',
            pon21= 0,
            pon50= 0,
            pon51= 0,
            pon53= 0,
            pon55= 0,
            pon57= 0, pon58= 0,
             pon59= ' ',pon60 =NULL #No.MOD-480239, pon60 為smallint 不可=' '
    INSERT INTO pon_file
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","pon_file",g_pom.pom01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660129
       ROLLBACK WORK #No:7857
       RETURN
    ELSE
       COMMIT WORK #No:7857
    END IF
    LET g_cnt=SQLCA.SQLERRD[3]
        MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno,') O.K'
 
    LET l_oldno = g_pom.pom01
    SELECT pom_file.* INTO g_pom.* FROM pom_file
      WHERE pom01 = l_newno
    CALL t580_u()
    #SELECT pom_file.* INTO g_pom.* FROM pom_file  #FUN-C80046
    #  WHERE pom01 = l_oldno                       #FUN-C80046
    #CALL t580_show()                              #FUN-C80046
    DISPLAY BY NAME g_pom.pom01
END FUNCTION
 
FUNCTION t580_prt()
   IF cl_confirm('mfg3242') THEN CALL t580_out() END IF
END FUNCTION
 
FUNCTION t580_out()
   DEFINE l_cmd         LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
          l_prog        LIKE zz_file.zz01,      #No.FUN-680136 VARCHAR(10)
          l_wc,l_wc2    LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(50)
          l_prtway      LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
        IF g_pom.pom01 IS NULL OR g_pom.pom01 = ' '
           THEN RETURN
        END IF
        SELECT pomprsw INTO g_pom.pomprsw FROM pom_file
         WHERE pom01 = g_pom.pom01
       IF g_pom.pomprsw = 'Y'  THEN
          LET l_wc='pom01="',g_pom.pom01,'"'
 
          SELECT zz21,zz22 INTO l_wc2,l_prtway FROM zz_file
         #   WHERE zz01 = "apmr580"  #FUN-C30085 mark
           WHERE zz01 = "apmg580"   #FUN-C30085 add
	 # LET l_cmd = "apmr580 ", #FUN-C30085 mark
           LET l_cmd = "apmg580 ", #FUN-C30085 add
                      " '",g_today CLIPPED,"' ''",
                      " '",g_lang CLIPPED,"' 'Y' '",l_prtway,"' '1'",
                      " '",l_wc CLIPPED,"' "    # 'N' 'N' 'N' "  #No.TQC-610085 mark
          CALL cl_cmdrun(l_cmd)
       END IF
END FUNCTION
	
FUNCTION t580_b()
DEFINE
       l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
       l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
       l_cnt           LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
       l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680136 VARCHAR(1)
       p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680136 VARCHAR(1)
       l_flag          LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_date          LIKE type_file.dat,     #No.FUN-680136 DATE
       l_over          LIKE pon_file.pon20,
       l_ima07         LIKE ima_file.ima07,
       l_pon18         LIKE pon_file.pon18,
       l_pon07         LIKE pon_file.pon07,
       l_pon50         LIKE pon_file.pon50,
       l_pom25         LIKE pom_file.pom25,
       l_pon20         LIKE pon_file.pon20,
       l_qty,l_diff    LIKE pon_file.pon20,
       l_pon           RECORD LIKE pon_file.*,
       l_qty1          LIKE pon_file.pon20,
       l_ima53         LIKE ima_file.ima53,   #最近採購單價
       l_flag1         LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
       l_misc          LIKE gfe_file.gfe01,   #No.FUN-680136 VARCHAR(04)
       l_feature       LIKE aba_file.aba00,    #No.FUN-680136 VARCHAR(05) #No.TQC-5A0096
       l_pommksg       LIKE pom_file.pommksg,
       l_sql           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(100)
       l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
       l_allow_delete  LIKE type_file.num5                 #可刪除否  #No.FUN-680136 SMALLINT
DEFINE l_ima915        LIKE ima_file.ima915 #FUN-710060 add
DEFINE l_tf            LIKE type_file.chr1  #FUN-BB0085
DEFINE l_case          STRING               #FUN-BB0085
DEFINE l_ima151        LIKE ima_file.ima151 
DEFINE l_imaag         LIKE ima_file.imaag
DEFINE l_count         LIKE pon_file.pon20
DEFINE l_error         LIKE type_file.chr10,  
       l_ima01         LIKE ima_file.ima01 
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_pom.pom01 IS NULL THEN RETURN END IF
    SELECT * INTO g_pom.* FROM pom_file WHERE pom01=g_pom.pom01
    IF g_pom.pomacti ='N' THEN
        CALL cl_err(g_pom.pom01,'aom-000',0) RETURN
    END IF
    IF g_pom.pom18='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    IF g_argv2 = '0' AND g_pom.pom25 = "1" AND g_pom.pommksg = "Y"  THEN
       CALL cl_err('','mfg3168',0) RETURN
    END IF
    IF g_argv2 MATCHES '[01]' AND g_pom.pom25 MATCHES'[269]' THEN
       CALL cl_err('','mfg9136',0) RETURN
    END IF
    LET g_success = 'Y'
 
    CALL cl_opmsg('b')
#FUN-C30057---add--begin--

       LET g_forupd_sql =
       " SELECT * ",
       "    FROM pon_file ",
       "   WHERE pon01= ? ",
       "     AND pon02= ? ",
       "  FOR UPDATE "
 
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE t580_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR

#FUN-C30057---add--end--
#FUN-C30057----MARK--begin--
#    LET g_forupd_sql =
#     " SELECT * ",
#     "    FROM pon_file ",
#     "   WHERE pon01= ? ",
#     "     AND pon02= ? ",
#     "  FOR UPDATE "
 
#    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#    DECLARE t580_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
#&ifndef STD
#       LET g_forupd_sql = "SELECT * FROM poni_file ",
#                          " WHERE poni01= ? AND poni02= ? FOR UPDATE"
#       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
#       DECLARE t580_bcl_ind CURSOR FROM g_forupd_sql      # LOCK CURSOR
#&endif
#FUN-C30057----MARK--end--
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
#FUN-C30057--add--str--
    INPUT ARRAY g_pon WITHOUT DEFAULTS FROM s_pon.*
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_before_input_done = FALSE
            CALL t580_set_entry_b(p_cmd)
            CALL t580_set_no_entry_b(p_cmd)
            LET g_before_input_done = TRUE
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
 
            BEGIN WORK
 
            OPEN t580_cl USING g_pom.pom01
            IF STATUS THEN
               CALL cl_err("OPEN t580_cl:", STATUS, 1)
               CLOSE t580_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t580_cl INTO g_pom.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)
               ROLLBACK WORK
               RETURN
            END IF
 
            IF g_rec_b >= l_ac THEN
                LET p_cmd='u'
                LET g_pon_t.* = g_pon[l_ac].*  #BACKUP
                LET g_pon07_t = g_pon[l_ac].pon07  #FUN-BB0085
                LET g_pon80_t = g_pon[l_ac].pon80  #FUN-BB0085
                LET g_pon83_t = g_pon[l_ac].pon83  #FUN-BB0085
                LET g_pon86_t = g_pon[l_ac].pon86  #FUN-BB0085
                LET g_pon_o.pon07=g_pon_t.pon07
 
                OPEN t580_bcl USING g_pom.pom01 ,g_pon_t.pon02
                IF STATUS THEN
                    CALL cl_err("OPEN t580_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                ELSE
                    FETCH t580_bcl INTO g_pon2.* #FUN-730068
                    IF SQLCA.sqlcode THEN
                        CALL cl_err(g_pon_t.pon02,SQLCA.sqlcode,1)
                        LET l_lock_sw = "Y"
                    ELSE
                       CALL t580_b_move_to()
                       LET g_pon_o.*=g_pon2.*
                       SELECT ima021 INTO g_pon[l_ac].ima021 FROM ima_file
                        WHERE ima01=g_pon[l_ac].pon04
                    END IF
                END IF
                IF g_sma.sma115 = 'Y' THEN
                   IF NOT cl_null(g_pon[l_ac].pon04) THEN
                      SELECT ima44 INTO g_ima44
                        FROM ima_file WHERE ima01=g_pon[l_ac].pon04
 
                      CALL s_chk_va_setting(g_pon[l_ac].pon04)
                           RETURNING g_flag,g_ima906,g_ima907
 
                      CALL s_chk_va_setting1(g_pon[l_ac].pon04)
                           RETURNING g_flag,g_ima908
                   END IF
 
                   CALL t580_set_entry_b('u')
                   CALL t580_set_no_entry_b('u')
                   CALL t580_set_no_required()
                   CALL t580_set_required()
                END IF
                CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t) #FUN-B70121 add
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
            END IF
            CALL t580_b_move_back() #FUN-730068
            IF g_sma.sma115 = 'Y' THEN
               IF NOT cl_null(g_pon[l_ac].pon04) THEN
                  SELECT ima44 INTO g_ima44
                    FROM ima_file WHERE ima01=g_pon[l_ac].pon04
               END IF
 
               CALL s_chk_va_setting(g_pon[l_ac].pon04)
                    RETURNING g_flag,g_ima906,g_ima907
               IF g_flag=1 THEN
                  NEXT FIELD pon04
               END IF
 
               CALL s_chk_va_setting1(g_pon[l_ac].pon04)
                    RETURNING g_flag,g_ima908
               IF g_flag=1 THEN
                  NEXT FIELD pon04
               END IF
 
               CALL t580_du_data_to_correct()
 
               #計算pon20,pon07的值,檢查數量的合理性
               CALL t580_set_origin_field()
               CALL t580_check_inventory_qty(p_cmd)
                   RETURNING g_flag
               IF g_flag = '1' THEN
                  IF g_ima906 = '3' OR g_ima906 = '2' THEN
                     NEXT FIELD pon85
                  ELSE
                     NEXT FIELD pon82
                  END IF
               END IF
            END IF
            LET g_pon2.pon44 = g_pon[l_ac].pon31 * g_pom.pom42 #本幣單價
            CALL cl_digcut(g_pon2.pon44,g_azi03) RETURNING g_pon2.pon44    #No.CHI-6A0004
            IF cl_null(g_pon[l_ac].pon86) THEN
               LET g_pon[l_ac].pon86 = g_pon[l_ac].pon07
               LET g_pon[l_ac].pon87 = g_pon[l_ac].pon20
            END IF
            LET g_pon2.pon06 = g_pon[l_ac].pon06   #NO:7066
            LET g_pon2.pon21 = g_pon[l_ac].pon21
            LET g_pon2.pon31 = g_pon[l_ac].pon31
            LET g_pon2.pon31t= g_pon[l_ac].pon31t  #No.FUN-550089
            LET g_pon2.pon32 = g_pon2.pon44 - g_pon2.pon30
            LET g_pon2.pon65 = '1'
            LET g_pon2.pon64 = 'N'
            LET g_pon2.pon63 = 'N'
            LET g_pon2.pon33 = null
            LET g_pon2.pon34 = null
            LET g_pon2.pon41 = null
    	    IF cl_null(g_pon2.pon011) THEN #採購單據性質
                LET g_pon2.pon011 = g_pom.pom02
            END IF
    	    IF cl_null(g_pon2.pon61) THEN #替代料
               LET g_pon2.pon61=g_pon2.pon04
               LET g_pon2.pon62=1
            END IF
    	    IF cl_null(g_pon2.pon65) THEN #代買
               LET g_pon2.pon65='1'
            END IF
            IF g_pon2.pon20 <> g_pon[l_ac].pon20 THEN
                LET g_pon[l_ac].pon20 = g_pon2.pon20
            END IF
            LET g_pon2.pon42='0'
            LET g_pon2.pon61=g_pon2.pon04
            LET g_pon2.pon62=1
            IF g_pon2.pon34 IS NULL THEN
               LET g_pon2.pon34=g_pon2.pon33
            END IF
            IF g_pon2.pon35 IS NULL THEN
               LET g_pon2.pon35=g_pon2.pon33
            END IF
            LET g_pon2.pon80 = g_pon[l_ac].pon80
            LET g_pon2.pon81 = g_pon[l_ac].pon81
            LET g_pon2.pon82 = g_pon[l_ac].pon82
            LET g_pon2.pon83 = g_pon[l_ac].pon83
            LET g_pon2.pon84 = g_pon[l_ac].pon84
            LET g_pon2.pon85 = g_pon[l_ac].pon85
            LET g_pon2.pon86 = g_pon[l_ac].pon86
            LET g_pon2.pon87 = g_pon[l_ac].pon87
            LET g_pon2.ponplant = g_plant  #FUN-980006 add
            LET g_pon2.ponlegal = g_legal  #FUN-980006 add
            IF cl_null(g_pon2.pon88) THEN
               LET g_pon2.pon88 = g_pon2.pon31 * g_pon[l_ac].pon87
            END IF
            IF cl_null(g_pon2.pon88t) THEN
               LET g_pon2.pon88t= g_pon2.pon31t* g_pon[l_ac].pon87
            END IF
            INSERT INTO pon_file VALUES(g_pon2.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","pon_file",g_pon2.pon01,g_pon2.pon02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_success = 'N'
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               CALL  t580_update()
               IF g_success = 'N' THEN
                  CALL cl_rbmsg(1) ROLLBACK WORK
               ELSE
                  COMMIT WORK
               END IF
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_pon[l_ac].* TO NULL      #900423
            INITIALIZE g_pon_o.* TO NULL
            INITIALIZE g_pon_t.* TO NULL
            INITIALIZE g_pon2.* TO NULL
            LET g_pon[l_ac].pon20 = 0
            LET g_pon[l_ac].pon21 = 0
            LET g_pon[l_ac].diff  = 0
            LET g_pon[l_ac].pon31 = 0
            LET g_pon[l_ac].pon31t= 0      #No.FUN-550089
            LET g_pon2.pon16      = g_pom.pom25
            LET g_pon2.pon63      = 'N'
            LET g_pon2.pon01      = g_pom.pom01
            LET g_pon2.pon011     = g_pom.pom02
            LET g_pon2.pon16      = g_pom.pom25
            LET g_pon2.pon09      = 1          #轉換率
            LET g_pon2.pon11      ='N'         #凍結碼
            LET g_pon2.pon14 =g_sma.sma886[1,1]         #部份交貨
            LET g_pon2.pon15 =g_sma.sma886[2,2]         #提前交貨
            LET g_pon2.pon20      = 0          #訂購量
            LET g_pon2.pon30      = 0          #標準價格
            LET g_pon2.pon31      = 0          #單價
            LET g_pon2.pon31t     = 0          #含稅單價  No.FUN-550089
            LET g_pon2.pon32      = 0          #PPV
            LET g_pon2.pon38      ='Y'         #MPS/MRP 可用/不可用
            LET g_pon2.pon44      = 0          #本幣單價
            LET g_pon2.pon50      = 0
            LET g_pon2.pon51      = 0
            LET g_pon2.pon53      = 0
            LET g_pon2.pon55      = 0
            LET g_pon2.pon57      = 0
            LET g_pon2.pon58      = 0
            LET g_pon2.pon63      = ' '
            LET g_pon_t.*         = g_pon[l_ac].*      #新輸入資料
            LET g_pon07_t         = NULL               #FUN-BB0085
            LET g_pon80_t         = NULL               #FUN-BB0085
            LET g_pon83_t         = NULL               #FUN-BB0085
            LET g_pon86_t         = NULL               #FUN-BB0085
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD pon02
 
        BEFORE FIELD pon02                        #default 序號
            IF g_pon[l_ac].pon02 IS NULL OR
               g_pon[l_ac].pon02 = 0 THEN
               SELECT max(pon02)+1 INTO g_pon[l_ac].pon02
                   FROM pon_file
                   WHERE pon01 = g_pom.pom01
               IF g_pon[l_ac].pon02 IS NULL THEN
                  LET g_pon[l_ac].pon02 = 1
               END IF
        #      DISPLAY g_pon[l_ac].pon02 TO pon02                  #TQC-BC0214
            END IF
 
        AFTER FIELD pon02                        #check 序號是否重複
            IF g_pon[l_ac].pon02 IS NULL THEN
               LET g_pon[l_ac].pon02 = g_pon_t.pon02
            END IF
            IF NOT cl_null(g_pon[l_ac].pon02) THEN
                IF g_pon[l_ac].pon02 != g_pon_t.pon02 OR
                   g_pon_t.pon02 IS NULL THEN
                    SELECT count(*) INTO l_n FROM pon_file
                        WHERE pon01 = g_pom.pom01 AND
                              pon02 = g_pon[l_ac].pon02
                    IF l_n > 0 THEN
                        CALL cl_err('',-239,0)
                        LET g_pon[l_ac].pon02 = g_pon_t.pon02
                        NEXT FIELD pon02
                    END IF
                END IF
            END IF
            LET g_pon2.pon02 = g_pon[l_ac].pon02
            LET g_pon_o.pon02 = g_pon[l_ac].pon02
        
        
        BEFORE FIELD pon04
           CALL t580_set_entry_b(p_cmd)
           CALL t580_set_no_required()
           IF g_argv2 = '2' THEN
              LET l_pon50 = 0
              SELECT pon50 INTO l_pon50 FROM pon_file
                     WHERE pon01 = g_pom.pom01 AND pon02 = g_pon_t.pon02
              IF l_pon50 > 0 THEN
                CALL cl_err('','mfg3374',0)
              END IF
           END IF
 
        AFTER FIELD pon04  	# check 料件編號
            IF NOT cl_null(g_pon[l_ac].pon04) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_pon[l_ac].pon04,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_pon[l_ac].pon04= g_pon_t.pon04
                  NEXT FIELD pon04
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               LET l_misc=g_pon[l_ac].pon04[1,4]
               IF g_pon[l_ac].pon04[1,4]='MISC' THEN  #NO:6808
                   SELECT COUNT(*) INTO l_n FROM ima_file
                    WHERE ima01=l_misc
                      AND ima01='MISC'
                   IF l_n=0 THEN
                      CALL cl_err('','aim-806',0)
                      NEXT FIELD pon04
                   END IF
               END IF
               LET g_pon2.pon04 = g_pon[l_ac].pon04
               LET g_no = g_pon2.pon04[1,4]
               LET l_feature = s_get_doc_no(g_pon2.pon011)  #No.TQC-5A0096
              #IF (g_pon[l_ac].pon04 != g_pon_t.pon04) OR cl_null(g_pon[l_ac].pon041) THEN
               IF (g_pon[l_ac].pon04 != g_pon_t.pon04 OR g_pon_t.pon04 IS NULL) OR cl_null(g_pon[l_ac].pon041) THEN #TQC-BC0216
                   CALL t580_pon04('a',g_no)
                   LET g_pon_o.pon86 = g_pon[l_ac].pon86   #MOD-730044  add
               END IF
               IF g_sma.sma115 = 'Y' THEN
                   CALL s_chk_va_setting(g_pon[l_ac].pon04)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD pon04
                   END IF
                   CALL s_chk_va_setting1(g_pon[l_ac].pon04)
                        RETURNING g_flag,g_ima908
                   IF g_flag=1 THEN
                      NEXT FIELD pon04
                   END IF
                   IF g_ima906 = '3' THEN
                      LET g_pon[l_ac].pon83=g_ima907
                   END IF
                END IF       #No.TQC-6B0124 add
                   #計價單位與數量的default值不受多單位參數的影響
                   SELECT ima44 INTO g_ima44
                     FROM ima_file WHERE ima01=g_pon[l_ac].pon04
                   CALL t580_du_default(p_cmd)
                 IF p_cmd='u' AND  (g_pon[l_ac].pon04 <> g_pon_o.pon04) THEN
                  IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
                     LET g_pon[l_ac].pon86=g_ima908
                     DISPLAY g_pon[l_ac].pon86 TO pon86
                  END IF
                 END IF 
            END IF
            IF (g_pon_t.pon04 IS NULL OR g_pon[l_ac].pon04 != g_pon_t.pon04) AND NOT cl_null(g_pon[l_ac].pon04)      #No.TQC-740082
                AND (g_no != 'MISC') THEN
               #採購料件/供應商控制
                SELECT ima915 INTO l_ima915 FROM ima_file WHERE ima01=g_pon[l_ac].pon04
                IF l_ima915='2' OR l_ima915='3' THEN 
                   CALL t580_pmh(g_pon[l_ac].pon04)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_pon[l_ac].pon04,g_errno,0)
                      LET g_pon[l_ac].pon04 = g_pon_o.pon04
                      DISPLAY g_pon[l_ac].pon04 TO pon04
 
                      NEXT FIELD pon04
                   END IF
                END IF
                #料件主檔檢查/預設值的讀取
                IF g_pon[l_ac].pon04<>g_pon_t.pon04 OR
                   cl_null(g_pon_t.pon04) THEN
                   CALL t580_def()
                   #FUN-BB0085-add-str---
                   LET l_tf = ''
                   IF g_sma.sma115 !='N' THEN                                               #TQC-C20183 add
                      LET g_pon[l_ac].pon20 = s_digqty(g_pon[l_ac].pon20,g_pon[l_ac].pon07) #TQC-C20183 add
                      DISPLAY BY NAME g_pon[l_ac].pon20                                     #TQC-C20183 add
                   ELSE
                     IF NOT t580_pon20_check(p_cmd) AND g_pon[l_ac].pon20 <> 0 THEN    #FUN-C20068  add pon20 <>0
                         LET g_pon07_t = g_pon[l_ac].pon07
                         LET l_tf = 0       
                      END IF
                   END IF
                   LET g_pon07_t = g_pon[l_ac].pon07
                   #FUN-BB0085-add-end---
                END IF
                IF NOT cl_null(g_errno) THEN
                   LET g_pon[l_ac].pon04 = g_pon_o.pon04
                   DISPLAY g_pon[l_ac].pon04 TO pon04
                   NEXT FIELD pon04
                END IF
                #單價預設值的設定
            END IF
            LET g_pon2.pon04 = g_pon[l_ac].pon04
            LET g_pon_o.pon04 = g_pon[l_ac].pon04
            CALL t580_set_no_entry_b(p_cmd)
            CALL t580_set_required()
            IF l_tf=0 THEN NEXT FIELD pon20 END IF   #FUN-BB0085
 
        AFTER FIELD pon041
            LET g_pon2.pon041 = g_pon[l_ac].pon041
 
        BEFORE FIELD pon07
           IF g_argv2 = '2' THEN
              LET l_pon50 = 0
              SELECT pon50 INTO l_pon50 FROM pon_file
                     WHERE pon01 = g_pom.pom01 AND pon02 = g_pon_t.pon02
              IF l_pon50 > 0 THEN
                  CALL cl_err('','mfg3374',0)
              END IF
           END IF
 
        AFTER FIELD pon07    #採購單位
            IF NOT cl_null(g_pon[l_ac].pon07) THEN
                IF g_no = 'MISC' THEN
                   LET g_pon2.pon121=1
                   LET g_pon2.pon09=1
                 ELSE
                   CALL t580_unit(g_pon[l_ac].pon07)
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_pon[l_ac].pon07,g_errno,0)
                      LET g_pon[l_ac].pon07 = g_pon_o.pon07
                      DISPLAY g_pon[l_ac].pon07 TO pon07
                      NEXT FIELD pon07
                   ELSE
                      #取採購對庫存換算率
                      CALL s_umfchk(g_pon[l_ac].pon04,g_pon[l_ac].pon07,
                                            g_pon2.pon08)
                             RETURNING g_sw,g_pon2.pon09
                       IF g_sw THEN       #85-09-23 by kitty
                         CALL cl_err(g_pon[l_ac].pon07,'mfg7002',0)
                          LET g_pon2.pon09=1
                          NEXT FIELD pon07
                       END IF
                   END IF
                END IF
                IF g_pon[l_ac].pon07 <> g_pon_o.pon07 THEN
                CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,
                                g_pom.pom04,g_pon[l_ac].pon87,'',g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant)
                     RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
                               g_pmn73,g_pmn74   #TQC-AC0257 add
                CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)    #MOD-9C0285 ADD
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD pon07
                END IF
                END IF
            END IF
            LET g_pon2.pon07  = g_pon[l_ac].pon07
            LET g_pon_o.pon07 = g_pon[l_ac].pon07

            #FUN-BB0085-add-str---
            IF NOT t580_pon20_check(p_cmd) THEN 
               LET g_pon07_t = g_pon[l_ac].pon07
               NEXT FIELD pon20
            END IF
            LET g_pon07_t = g_pon[l_ac].pon07
            #FUN-BB0085-add-end---
       #NO.FUN-A80001--begin 
       AFTER FIELD pon19
           IF NOT cl_null(g_pon[l_ac].pon19) THEN
              IF g_pon[l_ac].pon19 < g_pom.pom04 THEN
                  CALL cl_err('','apm-816',1)
                  NEXT FIELD pon19
              END IF
           END IF  
       #NO.FUN-A80001--end      
       AFTER FIELD pon20   #採購數量
          IF NOT t580_pon20_check(p_cmd) THEN    #FUN-BB0085
             NEXT FIELD pon20                    #FUN-BB0085
          END IF                                 #FUN-BB0085
        #FUN-BB0085-mark-str-------------
        #  IF NOT cl_null(g_pon[l_ac].pon20) THEN
        #      IF g_pon[l_ac].pon20 <= 0 THEN
        #          CALL cl_err(g_pon[l_ac].pon20,'mfg3331',0)
        #          LET g_pon[l_ac].pon20 = g_pon_o.pon20
        #          DISPLAY g_pon[l_ac].pon20 TO pon20
        #          NEXT FIELD pon20
        #      END IF
        #      IF (g_pon_o.pon20 IS NULL OR g_pon[l_ac].pon20 != g_pon_o.pon20 )
        #               AND (g_no != 'MISC') THEN
        #         CALL s_sizechk(g_pon[l_ac].pon04,g_pon[l_ac].pon20,g_lang)
        #                 RETURNING g_pon[l_ac].pon20
        #         DISPLAY g_pon[l_ac].pon20 TO pon20
 
        #      END IF
        #      IF p_cmd ='a' OR g_pon_o.pon20 != g_pon[l_ac].pon20 THEN
        #         #add or 修改時,採購量不可小於已交量
        #         IF g_pon[l_ac].pon20 < g_pon_o.pon50 THEN
        #            CALL cl_err(g_pon_o.pon50,'mfg3424',1)
        #            NEXT FIELD pon20
        #         END IF
        #         # show 已轉數量
        #         LET g_pon[l_ac].diff = g_pon[l_ac].pon20 - g_pon[l_ac].pon21
        #         DISPLAY g_pon[l_ac].diff TO diff
        #      END IF
        #  END IF
        #  LET g_pon2.pon20 = g_pon[l_ac].pon20
        #  LET g_pon_o.pon20 = g_pon[l_ac].pon20
        #  DISPLAY BY NAME g_pon[l_ac].pon20
        #  IF cl_null(g_pon[l_ac].pon86) THEN
        #     LET g_pon[l_ac].pon86 = g_pon[l_ac].pon07
        #     LET g_pon[l_ac].pon87 = g_pon[l_ac].pon20
        #     DISPLAY BY NAME g_pon[l_ac].pon86
        #     DISPLAY BY NAME g_pon[l_ac].pon87
        #  END IF
        #  IF g_pon[l_ac].pon87 = 0 OR
        #        (g_pon_t.pon20 <> g_pon[l_ac].pon20 OR
        #         g_pon_t.pon86 <> g_pon[l_ac].pon86) THEN
        #     CALL t580_set_pon87()
        #     LET g_pon2.pon87 = g_pon[l_ac].pon87
        #     LET g_pon_o.pon87 = g_pon[l_ac].pon87
        #  END IF
        #  IF cl_null(g_pon[l_ac].pon31) OR g_pon[l_ac].pon31 = 0 THEN
        #     CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,g_pom.pom04,g_pon[l_ac].pon87,'',
        #                         g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant) 
        #        RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
        #                  g_pmn73,g_pmn74   #TQC-AC0257 add 
        #     CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)  #No.MOD-9C0285 ADD
        #     IF g_pon[l_ac].pon31=0 THEN
        #        LET g_pon[l_ac].pon31=g_pon2.pon31
        #        LET g_pon[l_ac].pon31t=g_pon2.pon31t
        #     END IF
        #     LET g_pon[l_ac].pon31 = cl_digcut(g_pon[l_ac].pon31,t_azi03)   #No.CHI-6A0004
        #     LET g_pon[l_ac].pon31t = cl_digcut(g_pon[l_ac].pon31t,t_azi03) #No.CHI-6A0004
        #     DISPLAY g_pon[l_ac].pon31 TO pon31
        #     DISPLAY g_pon[l_ac].pon31t TO pon31t
        #  END IF
        #  IF g_pon[l_ac].pon20 <> g_pon_t.pon20 THEN 
        #     CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,g_pom.pom04,g_pon[l_ac].pon87,'',
        #                         g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant)
        #            RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
        #                      g_pmn73,g_pmn74   #TQC-AC0257 add
        #      CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)   #MOD-9C0285  ADD
        #  END IF    
        #FUN-BB0085-mark-end----------
 
        BEFORE FIELD pon83
           IF NOT cl_null(g_pon[l_ac].pon04) THEN
              SELECT ima44 INTO g_ima44
                FROM ima_file WHERE ima01=g_pon[l_ac].pon04
           END IF
           CALL t580_set_no_required()
 
        AFTER FIELD pon83  #第二單位
           IF cl_null(g_pon[l_ac].pon04) THEN NEXT FIELD pon04 END IF
           IF NOT cl_null(g_pon[l_ac].pon83) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pon[l_ac].pon83
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pon[l_ac].pon83,"",STATUS,"","gfe:",1)  #No.FUN-660129
                 NEXT FIELD pon83
              END IF
              CALL s_du_umfchk(g_pon[l_ac].pon04,'','','',
                               g_ima44,g_pon[l_ac].pon83,g_ima906)
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pon[l_ac].pon83,g_errno,0)
                 NEXT FIELD pon83
              END IF
              IF cl_null(g_pon_t.pon83) OR g_pon_t.pon83 <> g_pon[l_ac].pon83 THEN
                 LET g_pon[l_ac].pon84 = g_factor
              END IF
              LET g_pon2.pon83  = g_pon[l_ac].pon83
              LET g_pon_o.pon83 = g_pon[l_ac].pon83
           END IF
           CALL t580_du_data_to_correct()
           CALL t580_set_required()
           CALL cl_show_fld_cont()
           #FUN-BB0085-add-str--
           IF NOT t580_pon85_check(p_cmd) THEN
              LET g_pon83_t = g_pon[l_ac].pon83
              NEXT FIELD pon85
           END IF
           LET g_pon83_t = g_pon[l_ac].pon83
           #FUN-BB0085-add-end--
 
        AFTER FIELD pon84  #第二轉換率
           IF NOT cl_null(g_pon[l_ac].pon84) THEN
              IF g_pon[l_ac].pon84=0 THEN
                 NEXT FIELD pon84
              END IF
              LET g_pon2.pon84  = g_pon[l_ac].pon84
              LET g_pon_o.pon84 = g_pon[l_ac].pon84
           END IF
 
        AFTER FIELD pon85  #第二數量
           #FUN-BB0085-add-str----
           IF NOT t580_pon85_check(p_cmd) THEN 
              NEXT FIELD pon85
           END IF
           #FUN-BB0085-add-end----
           #FUN-BB0085-mark-str-----------------
           #IF NOT cl_null(g_pon[l_ac].pon85) THEN
           #   IF g_pon[l_ac].pon85 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD pon85
           #   END IF
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      g_pon_t.pon85 <> g_pon[l_ac].pon85 THEN
           #      IF g_ima906='3' THEN
           #         LET g_tot=g_pon[l_ac].pon85*g_pon[l_ac].pon84
           #         IF cl_null(g_pon[l_ac].pon82) OR g_pon[l_ac].pon82=0 THEN #CHI-960022
           #            LET g_pon[l_ac].pon82=g_tot*g_pon[l_ac].pon81
           #            LET g_pon2.pon82  = g_pon[l_ac].pon82
           #            LET g_pon_o.pon82 = g_pon[l_ac].pon82
           #            DISPLAY BY NAME g_pon[l_ac].pon82                      #CHI-960022
           #         END IF                                                    #CHI-960022
           #      END IF
           #   END IF
           #   LET g_pon2.pon85  = g_pon[l_ac].pon85
           #   LET g_pon_o.pon85 = g_pon[l_ac].pon85
           #END IF
           #IF cl_null(g_pon[l_ac].pon86) THEN
           #   LET g_pon[l_ac].pon87 = 0
           #ELSE
           #   IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #      (g_pon_t.pon81 <> g_pon[l_ac].pon81 OR
           #       g_pon_t.pon82 <> g_pon[l_ac].pon82 OR
           #       g_pon_t.pon84 <> g_pon[l_ac].pon84 OR
           #       g_pon_t.pon85 <> g_pon[l_ac].pon85 OR
           #       g_pon_t.pon86 <> g_pon[l_ac].pon86) THEN
           #       CALL t580_set_pon87()
           #   END IF
           #END IF
           #CALL cl_show_fld_cont()
           #FUN-BB0085-mark-end----------
 
        AFTER FIELD pon80  #第一單位
           LET l_tf = ''  #FUN-BB0085 add
           IF cl_null(g_pon[l_ac].pon04) THEN NEXT FIELD pon04 END IF
           IF NOT cl_null(g_pon[l_ac].pon80) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pon[l_ac].pon80
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pon[l_ac].pon80,"",STATUS,"","gfe:",1)  #No.FUN-660129
                 NEXT FIELD pon80
              END IF
              CALL s_du_umfchk(g_pon[l_ac].pon04,'','','',
                               g_pon[l_ac].pon07,g_pon[l_ac].pon80,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pon[l_ac].pon80,g_errno,0)
                 NEXT FIELD pon80
              END IF
              IF cl_null(g_pon_t.pon80) OR g_pon_t.pon80 <> g_pon[l_ac].pon80 THEN
                 LET g_pon[l_ac].pon81 = g_factor
              END IF
              LET g_pon2.pon80  = g_pon[l_ac].pon80
              LET g_pon_o.pon80 = g_pon[l_ac].pon80
              CALL t580_pon82_check(p_cmd) RETURNING l_tf  #FUN-BB0085 add
           END IF
           CALL t580_du_data_to_correct()
           CALL t580_set_required()
           CALL cl_show_fld_cont()
           #FUN-BB0085-add-str----
           LET g_pon80_t = g_pon[l_ac].pon80
           IF l_tf = 0 THEN 
              NEXT FIELD pon82 
           END IF
           IF l_tf = 1 THEN 
              NEXT FIELD pon85 
           END IF
           #FUN-BB0085-add-end----
 
        AFTER FIELD pon81  #第一轉換率
           IF NOT cl_null(g_pon[l_ac].pon81) THEN
              IF g_pon[l_ac].pon81=0 THEN
                 NEXT FIELD pon81
              END IF
              LET g_pon2.pon81  = g_pon[l_ac].pon81
              LET g_pon_o.pon81 = g_pon[l_ac].pon81
           END IF
 
        AFTER FIELD pon82  #第一數量
           #FUN-BB0085-add-str----
           LET l_case=''
           CALL t580_pon82_check(p_cmd) RETURNING l_case
           CASE l_case
              WHEN 'pon82'  NEXT FIELD pon82
              WHEN 'pon85'  NEXT FIELD pon85
           END CASE
           #FUN-BB0085-add-end----
           #FUN-BB0085-mark-str------------------
           #IF NOT cl_null(g_pon[l_ac].pon82) THEN
           #   IF g_pon[l_ac].pon82 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD pon82
           #   END IF
           #   LET g_pon2.pon82  = g_pon[l_ac].pon82
           #   LET g_pon_o.pon82 = g_pon[l_ac].pon82
           #END IF
           ##計算pon20,pon07的值,檢查數量的合理性
           # CALL t580_set_origin_field()
           # CALL t580_check_inventory_qty(p_cmd)
           #     RETURNING g_flag
           # IF g_flag = '1' THEN
           #    IF g_ima906 = '3' OR g_ima906 = '2' THEN
           #       NEXT FIELD pon85
           #    ELSE
           #       NEXT FIELD pon82
           #    END IF
           # END IF
           # IF cl_null(g_pon[l_ac].pon86) THEN
           #    LET g_pon[l_ac].pon87 = 0
           # ELSE
           #    IF p_cmd = 'a' OR  p_cmd = 'u' AND
           #       (g_pon_t.pon81 <> g_pon[l_ac].pon81 OR
           #        g_pon_t.pon82 <> g_pon[l_ac].pon82 OR
           #        g_pon_t.pon84 <> g_pon[l_ac].pon84 OR
           #        g_pon_t.pon85 <> g_pon[l_ac].pon85 OR
           #        g_pon_t.pon86 <> g_pon[l_ac].pon86) THEN
           #        CALL t580_set_pon87()
           #    END IF
           # END IF
           # CALL cl_show_fld_cont()
           #FUN-BB0085-mark-end---------------------------
 
        BEFORE FIELD pon86
           IF NOT cl_null(g_pon[l_ac].pon04) THEN
              SELECT ima44 INTO g_ima44
                FROM ima_file WHERE ima01=g_pon[l_ac].pon04
           END IF
           CALL t580_set_no_required()
 
        AFTER FIELD pon86
           IF cl_null(g_pon[l_ac].pon04) THEN NEXT FIELD pon04 END IF
           IF NOT cl_null(g_pon[l_ac].pon86) THEN
              SELECT gfe02 INTO g_buf FROM gfe_file
               WHERE gfe01=g_pon[l_ac].pon86
                 AND gfeacti='Y'
              IF STATUS THEN
                 CALL cl_err3("sel","gfe_file",g_pon[l_ac].pon86,"",STATUS,"","gfe:",1)  #No.FUN-660129
                 NEXT FIELD pon86
              END IF
              CALL s_du_umfchk(g_pon[l_ac].pon04,'','','',
                               g_ima44,g_pon[l_ac].pon86,'1')
                   RETURNING g_errno,g_factor
              IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_pon[l_ac].pon86,g_errno,0)
                 NEXT FIELD pon86
              END IF
                IF g_pon[l_ac].pon86 <> g_pon_o.pon86 THEN
                CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,
                                g_pom.pom04,g_pon[l_ac].pon87,'',g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant)  
                     RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
                               g_pmn73,g_pmn74   #TQC-AC0257 add
                CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)          #MOD-9C0285 ADD
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,1)
                   NEXT FIELD pon86
                END IF
                END IF
              LET g_pon_o.pon86 = g_pon[l_ac].pon86
           END IF
           CALL t580_set_required()
           #FUN-BB0085-add-str--
           IF NOT t580_pon87_check(p_cmd) THEN
              LET g_pon86_t = g_pon[l_ac].pon86
              NEXT FIELD pon87
           END IF 
           LET g_pon86_t = g_pon[l_ac].pon86
           #FUN-BB0085-add-end--
 
        BEFORE FIELD pon87
           IF g_sma.sma115 = 'Y' THEN
              IF p_cmd = 'a' OR  p_cmd = 'u' AND
                    (g_pon_t.pon81 <> g_pon[l_ac].pon81 OR
                     g_pon_t.pon82 <> g_pon[l_ac].pon82 OR
                     g_pon_t.pon84 <> g_pon[l_ac].pon84 OR
                     g_pon_t.pon85 <> g_pon[l_ac].pon85 OR
                     g_pon_t.pon86 <> g_pon[l_ac].pon86) THEN
                 CALL t580_set_pon87()
              END IF
           ELSE
              IF g_pon[l_ac].pon87 = 0 OR
                    (g_pon_t.pon20 <> g_pon[l_ac].pon20 OR
                     g_pon_t.pon86 <> g_pon[l_ac].pon86) THEN
                 CALL t580_set_pon87()
              END IF
           END IF
           #No.FUN-560020  --end
 
        AFTER FIELD pon87
           #FUN-BB0085-add-str--
           IF NOT t580_pon87_check(p_cmd) THEN 
              NEXT FIELD pon87
           END IF
           #FUN-BB0085-add-end--
           #FUN-BB0085-mark-str-----------
           #IF NOT cl_null(g_pon[l_ac].pon87) THEN
           #   IF g_pon[l_ac].pon87 < 0 THEN
           #      CALL cl_err('','aim-391',0)  #
           #      NEXT FIELD pon87
           #   END IF
           #  IF cl_null(g_pon[l_ac].pon31) OR g_pon[l_ac].pon31 = 0 THEN
           #     CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,g_pom.pom04,g_pon[l_ac].pon87,'',
           #                         g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant) 
           #        RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
           #                  g_pmn73,g_pmn74   #TQC-AC0257 add
           #     CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)     #MOD-9C0285 ADD
           #     IF g_pon[l_ac].pon31=0 THEN
           #        LET g_pon[l_ac].pon31=g_pon2.pon31
           #        LET g_pon[l_ac].pon31t=g_pon2.pon31t
           #     END IF
           #     LET g_pon[l_ac].pon31 = cl_digcut(g_pon[l_ac].pon31,t_azi03)
           #     LET g_pon[l_ac].pon31t = cl_digcut(g_pon[l_ac].pon31t,t_azi03)
           #     DISPLAY g_pon[l_ac].pon31 TO pon31
           #     DISPLAY g_pon[l_ac].pon31t TO pon31t
           #  END IF
           #END IF
           #FUN-BB0085-mark-end-----------
 
        AFTER FIELD pon31   #單價
            IF NOT cl_null(g_pon[l_ac].pon31) THEN
                IF g_pon[l_ac].pon31 < 0 THEN
                   CALL cl_err(g_pon[l_ac].pon31,'mfg1322',1)
                   LET g_pon[l_ac].pon31 = g_pon_o.pon31
                   DISPLAY g_pon[l_ac].pon31 TO pon31
                   NEXT FIELD pon31
                END IF
                #----- check採購單價超過最近採購單價% 96-06-25
                IF g_sma.sma84 != 99.99 AND g_pon[l_ac].pon04<>'MISC' THEN
                   SELECT ima53 INTO l_ima53 FROM ima_file
                    WHERE ima01=g_pon[l_ac].pon04
                   IF l_ima53 != 0 THEN  #No:8752
                      IF g_pon[l_ac].pon31*g_pom.pom42 > l_ima53*(1+g_sma.sma84/100) #No.8618
                      THEN
                         IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                             CALL cl_err(g_pon[l_ac].pon04,'apm-240',0)
                             NEXT FIELD pon31
                         ELSE
                             CALL cl_err(g_pon[l_ac].pon04,'apm-240',0)
                         END IF
                      END IF
                   END IF
                END IF
                CALL cl_digcut(g_pon[l_ac].pon31,t_azi03)  #No.CHI-6A0004
                     RETURNING g_pon[l_ac].pon31
                DISPLAY g_pon[l_ac].pon31  TO pon31
                LET g_pon2.pon44 = g_pon[l_ac].pon31 * g_pom.pom42 #本幣單價
                CALL cl_digcut(g_pon2.pon44,g_azi03) RETURNING g_pon2.pon44    #No.CHI-6A0004
                LET g_pon[l_ac].pon31t =
                    g_pon[l_ac].pon31 * ( 1 + g_pom.pom43/100)
                LET g_pon[l_ac].pon31t = cl_digcut(g_pon[l_ac].pon31t,t_azi03)   #No.CHI-6A0004
                LET g_pon2.pon32 = g_pon2.pon44 - g_pon2.pon30
                LET g_pon_o.pon31 = g_pon[l_ac].pon31
                LET g_pon2.pon31 = g_pon[l_ac].pon31
                LET g_pon_o.pon31t = g_pon[l_ac].pon31t
                LET g_pon2.pon31t = g_pon[l_ac].pon31t
                DISPLAY g_pon[l_ac].pon31  TO pon31
                DISPLAY g_pon[l_ac].pon31t TO pon31t
                #end No.FUN-550089
            END IF
 
        AFTER FIELD pon31t     #含稅單價
            IF NOT cl_null(g_pon[l_ac].pon31t) THEN
                IF g_pon[l_ac].pon31t < 0 THEN
                   CALL cl_err(g_pon[l_ac].pon31t,'mfg1322',1)
                   LET g_pon[l_ac].pon31t = g_pon_o.pon31t
                   NEXT FIELD pon31t
                END IF
                LET g_pon[l_ac].pon31t = cl_digcut(g_pon[l_ac].pon31t,t_azi03)   #No.CHI-6A0004
                LET g_pon[l_ac].pon31 =                                                                                             
                    g_pon[l_ac].pon31t / ( 1 + g_pom.pom43 / 100)
                LET g_pon[l_ac].pon31 = cl_digcut(g_pon[l_ac].pon31,t_azi03)     #No.CHI-6A0004
                #----- check採購單價超過最近採購單價% 96-06-25
                IF g_sma.sma84 != 99.99 AND g_pon[l_ac].pon04<>'MISC' THEN
                   SELECT ima53 INTO l_ima53 FROM ima_file
                    WHERE ima01=g_pon[l_ac].pon04
                   IF l_ima53 != 0 THEN  #No:8752
                      IF g_pon[l_ac].pon31*g_pom.pom42 > l_ima53*(1+g_sma.sma84/100) #No.8618
                      THEN
                         IF g_sma.sma109 = 'R' THEN #Rejected NO:7231
                             CALL cl_err(g_pon[l_ac].pon04,'apm-240',0)
                             NEXT FIELD pon31t
                         ELSE
                             CALL cl_err(g_pon[l_ac].pon04,'apm-240',0)
                         END IF
                      END IF
                   END IF
                END IF
                LET g_pon2.pon44 = g_pon[l_ac].pon31 * g_pom.pom42 #本幣單價
                CALL cl_digcut(g_pon2.pon44,g_azi03) RETURNING g_pon2.pon44    #No.CHI-6A0004
                LET g_pon2.pon32 = g_pon2.pon44 - g_pon2.pon30
                LET g_pon_o.pon31 = g_pon[l_ac].pon31
                LET g_pon2.pon31  = g_pon[l_ac].pon31
                LET g_pon_o.pon31t= g_pon[l_ac].pon31t
                LET g_pon2.pon31t = g_pon[l_ac].pon31t
                DISPLAY g_pon[l_ac].pon31 TO pon31
                DISPLAY g_pon[l_ac].pon31t TO pon31t
            END IF
 
        AFTER FIELD ponud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD ponud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
           IF g_argv2 = '2' THEN
              SELECT pon50 INTO l_pon50 FROM pon_file
                     WHERE pon01 = g_pom.pom01 AND pon02 = g_pon[l_ac].pon02
              IF l_pon50 > 0 THEN
                  CALL cl_err('','mfg3374',0)
                  CANCEL DELETE
              END IF
           END IF
            IF g_pon_t.pon02 > 0 AND
                    g_pon_t.pon02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) OR (g_argv2 !=2 AND
                   g_pom.pom25 MATCHES'[26789]') THEN
                    CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM pon_file
                    WHERE pon01 = g_pom.pom01 AND
                          pon02 = g_pon_t.pon02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","pon_file",g_pom.pom01,g_pon_t.pon02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    ROLLBACK WORK
                    CANCEL DELETE
                ELSE
                    LET g_rec_b=g_rec_b-1
                    DISPLAY g_rec_b TO FORMONLY.cn2
                END IF
                LET g_no = g_pon2.pon04[1,4]
                LET l_diff = (g_pon[l_ac].pon20 * g_pon2.pon09) * -1
            END IF
 
        AFTER DELETE
            CALL  t580_update()
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_pon[l_ac].* = g_pon_t.*
               CLOSE t580_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_pon[l_ac].pon02,-263,1)
                LET g_pon[l_ac].* = g_pon_t.*
            ELSE
                IF g_sma.sma115 = 'Y' THEN
                   IF NOT cl_null(g_pon[l_ac].pon04) THEN
                      SELECT ima44 INTO g_ima44
                        FROM ima_file WHERE ima01=g_pon[l_ac].pon04
                   END IF
 
                   CALL s_chk_va_setting(g_pon[l_ac].pon04)
                        RETURNING g_flag,g_ima906,g_ima907
                   IF g_flag=1 THEN
                      NEXT FIELD pon04
                   END IF
                   CALL s_chk_va_setting1(g_pon[l_ac].pon04)
                        RETURNING g_flag,g_ima908
                   IF g_flag=1 THEN
                      NEXT FIELD pon04
                   END IF
 
                   CALL t580_du_data_to_correct()
 
                   CALL t580_set_origin_field()
                   LET g_pon2.pon80 = g_pon[l_ac].pon80
                   LET g_pon2.pon81 = g_pon[l_ac].pon81
                   LET g_pon2.pon82 = g_pon[l_ac].pon82
                   LET g_pon2.pon83 = g_pon[l_ac].pon83
                   LET g_pon2.pon84 = g_pon[l_ac].pon84
                   LET g_pon2.pon85 = g_pon[l_ac].pon85
                   LET g_pon2.pon86 = g_pon[l_ac].pon86
                   LET g_pon2.pon87 = g_pon[l_ac].pon87
                   #計算pon20,pon07的值,檢查數量的合理性
                   CALL t580_set_origin_field()
                   CALL t580_check_inventory_qty(p_cmd)
                       RETURNING g_flag
                   IF g_flag = '1' THEN
                      IF g_ima906 = '3' OR g_ima906 = '2' THEN
                         NEXT FIELD pon85
                      ELSE
                         NEXT FIELD pon82
                      END IF
                   END IF
                END IF
                CALL t580_b_move_back() #MOD-840127
                IF cl_null(g_pon2.pon88) THEN
                   LET g_pon2.pon88 = g_pon2.pon31 * g_pon[l_ac].pon87
                END IF
                IF cl_null(g_pon2.pon88t) THEN
                   LET g_pon2.pon88t= g_pon2.pon31t* g_pon[l_ac].pon87
                END IF
                UPDATE pon_file SET pon_file.* = g_pon2.*   # 更新DB
                    WHERE pon01=g_pom.pom01
                      AND pon02=g_pon_t.pon02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","pon_file",g_pom.pom01,g_pon_t.pon02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_pon[l_ac].* = g_pon_t.*
                    LET g_success = 'N'
                ELSE
                    MESSAGE 'UPDATE O.K'
                    CALL  t580_update()
                    #將舊值和轉換因子的值與新值和轉換因子的值相減
                    IF g_success = 'N' THEN
                        CALL cl_rbmsg(1) ROLLBACK WORK
                    ELSE
                        COMMIT WORK
                    END IF
                END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
        #   LET l_ac_t = l_ac   #FUN-D30034
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_pon[l_ac].* = g_pon_t.*
           #FUN-D30034--add--str--
               ELSE
                  CALL g_pon.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
           #FUN-D30034--add--end--
               END IF
               CLOSE t580_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac   #FUN-D30034
            CLOSE t580_bcl
            COMMIT WORK
 
        ON ACTION mntn_item #料件編號
            IF g_sma.sma38 MATCHES'[Yy]' THEN
               CALL cl_cmdrun("aimi109 ")
            ELSE
               CALL cl_err(g_sma.sma38,'mfg0035',1)
            END IF
 
        ON ACTION mntn_unit  #單位資料
            LET g_cmd = 'aooi101 '
            CALL cl_cmdrun(g_cmd)
 
        ON ACTION mntn_unit_conv  #單位換算資料
            LET g_cmd = 'aooi102 '
            CALL cl_cmdrun(g_cmd)
 
        ON ACTION mntn_item_unit_conv #料件單位換算資料
            LET g_cmd = 'aooi103 '
            CALL cl_cmdrun(g_cmd)
 
        ON ACTION mntn_po_unit_conv #維護採購單位換算
            CALL t562()
 
        ON ACTION q_pmh #料件廠商資料
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_pmh"
                  LET g_qryparam.default1 = g_pom.pom09
                  CALL cl_create_qry() RETURNING g_pon[l_ac].pon04
                  DISPLAY g_pon[l_ac].pon04 TO pon04
                  NEXT FIELD pon04
 
        ON ACTION mntn_item_vender #料件/供應商維護
             CALL cl_cmdrun('apmi254')
 
 
        ON ACTION special_desc
             LET g_cmd = "apmt402 2 '",g_pom.pom01,"' ",g_pon[l_ac].pon02
             CALL cl_cmdrun_wait(g_cmd)  #FUN-660216 add
 
 
        ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pon04) #料件編號
#FUN-AA0059---------mod------------str-----------------               
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.default1 = g_pon[l_ac].pon04
#                  CALL cl_create_qry() RETURNING g_pon[l_ac].pon04

                  CALL q_sel_ima(FALSE, "q_ima","",g_pon[l_ac].pon04,"","","","","",'' ) 
                  RETURNING g_pon[l_ac].pon04
#FUN-AA0059---------mod------------end-----------------

                  DISPLAY g_pon[l_ac].pon04 TO pon04
                  NEXT FIELD pon04
               WHEN INFIELD(pon07) #採購單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_pon[l_ac].pon07
                  CALL cl_create_qry() RETURNING g_pon[l_ac].pon07
                  DISPLAY g_pon[l_ac].pon07 TO pon07
                  NEXT FIELD pon07
               WHEN INFIELD(pon80) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pon[l_ac].pon80
                    CALL cl_create_qry() RETURNING g_pon[l_ac].pon80
                    DISPLAY BY NAME g_pon[l_ac].pon80
                    NEXT FIELD pon80
 
               WHEN INFIELD(pon83) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pon[l_ac].pon83
                    CALL cl_create_qry() RETURNING g_pon[l_ac].pon83
                    DISPLAY BY NAME g_pon[l_ac].pon83
                    NEXT FIELD pon83
 
               WHEN INFIELD(pon86) #單位
                    CALL cl_init_qry_var()
                    LET g_qryparam.form ="q_gfe"
                    LET g_qryparam.default1 = g_pon[l_ac].pon86
                    CALL cl_create_qry() RETURNING g_pon[l_ac].pon86
                    DISPLAY BY NAME g_pon[l_ac].pon86
                    NEXT FIELD pon86
               OTHERWISE EXIT CASE
            END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(pon02) AND l_ac > 1 THEN
                LET g_pon[l_ac].* = g_pon[l_ac-1].*
                NEXT FIELD pon02
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
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
 
        END INPUT
         UPDATE pom_file SET pommodu=g_user,pomdate=g_today
          WHERE pom01=g_pom.pom01
 
    CLOSE t580_bcl
    IF g_success = 'N' THEN
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    ELSE
       COMMIT WORK
    END IF
    CALL t580_delHeader()     #CHI-C30002 add
END FUNCTION
 
#CHI-C30002 -------- add -------- begin
FUNCTION t580_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
  
   SELECT COUNT(*) INTO g_cnt FROM pon_file WHERE pon01 = g_pom.pom01
   IF g_cnt = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_pom.pom01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM pom_file ",
                  "  WHERE pom01 LIKE '",l_slip,"%' ",
                  "    AND pom01 > '",g_pom.pom01,"'"
      PREPARE t580_pb1 FROM l_sql 
      EXECUTE t580_pb1 INTO l_cnt 
      
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
         #CALL t580_x() #FUN-D20025 mark
         CALL t580_x(1) #FUN-D20025 add
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM pmo_file WHERE pmo01 = g_pom.pom01
         DELETE FROM pmp_file WHERE pmp01 = g_pom.pom01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM pom_file WHERE pom01=g_pom.pom01
         INITIALIZE g_pom.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION t580_pon03()  #詢價單號
 DEFINE  l_pmwacti   LIKE pmw_file.pmwacti
 
  LET g_errno = " "
  SELECT pmwacti INTO l_pmwacti   #FUN-650191  拿掉pmw03
                       FROM pmw_file, OUTER pmx_file #FUN-650191 (add pmx_file)
                      WHERE pmw01 = g_pon2.pon03
                        AND pmw_file.pmw01 = pmx_file.pmx01            #FUN-650191 add
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3051'
                            LET l_pmwacti = NULL
         WHEN l_pmwacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t580_pon23(p_code)    #check 地址
  DEFINE  p_cmd   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
          p_code  LIKE pme_file.pme01,
          l_pme02 LIKE pme_file.pme02,
          l_pmeacti LIKE pme_file.pmeacti
 
  LET g_errno = " "
  SELECT pme02,pmeacti INTO l_pme02,l_pmeacti FROM pme_file
   WHERE pme01 = p_code
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno='mfg3012' LET l_pmeacti=NULL
         WHEN l_pmeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t580_pon04(p_cmd,p_no)  #料件編號
    DEFINE l_ima02 LIKE ima_file.ima02,
           l_ima021 LIKE ima_file.ima021,
           l_ima39 LIKE ima_file.ima39,
           l_imaacti LIKE ima_file.imaacti,
           p_no      LIKE gfe_file.gfe01,   #No.FUN-680136 VARCHAR(04)
           p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
  LET g_errno = " "
  SELECT ima02,ima021,ima39,ima49,ima491,imaacti
         INTO l_ima02,l_ima021,l_ima39,g_ima49,g_ima491,l_imaacti
    FROM ima_file  WHERE ima01 = g_pon[l_ac].pon04
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 LET l_ima02 = NULL  LET l_imaacti = NULL
                                 LET l_ima021=NULl
       WHEN l_imaacti='N'        LET g_errno = '9028'
       WHEN l_imaacti MATCHES '[PH]' LET g_errno = '9038'  #No.FUN-690022 add
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
     LET g_pon[l_ac].pon041= l_ima02
     LET g_pon2.pon041     = l_ima02
     DISPLAY g_pon[l_ac].pon041 TO pon041
  LET g_pon[l_ac].ima021= l_ima021
  DISPLAY g_pon[l_ac].ima021 TO ima021
  IF g_pon[l_ac].pon04 <> 'MISC' AND g_pon2.pon40 IS NULL THEN
     LET g_pon2.pon40 = l_ima39
  END IF
  IF cl_null(g_ima49) THEN LET g_ima49 = 0 END IF
  IF cl_null(g_ima491) THEN LET g_ima491 = 0 END IF
END FUNCTION
 
#系統參數設料件/供應商須存在
FUNCTION t580_pmh(l_part)  #供應廠商
 DEFINE  l_pmhacti LIKE pmh_file.pmhacti,
         l_pmh05   LIKE pmh_file.pmh05,
         l_part    LIKE pmh_file.pmh01
 
 LET g_errno = " "
 SELECT pmhacti,pmh05 INTO l_pmhacti,l_pmh05 FROM pmh_file
        WHERE pmh01=l_part AND pmh02=g_pom.pom09
          AND pmh13=g_pom.pom22
          AND pmh21 = " "                                             #CHI-860042                                                   
          AND pmh22 = '1'                                             #CHI-860042
          AND pmh23 = ' '                                             #No.CHI-960033
          AND pmhacti = 'Y'                                           #CHI-910021
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0031'
                                   LET l_pmhacti = NULL
         WHEN l_pmhacti='N'        LET g_errno = '9028'
         WHEN l_pmh05 MATCHES '[12]' LET g_errno = 'mfg3043'   #00/03/07 add
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t580_update()
    DEFINE l_tot_pom40   LIKE pom_file.pom40
    DEFINE l_tot_pom40t  LIKE pom_file.pom40t   #No.FUN-610018
    SELECT SUM(pon88) INTO g_pom.pom40                                                                                               
     FROM pon_file                                                                                                                  
    WHERE pon01=g_pom.pom01
   IF SQLCA.sqlcode OR g_pom.pom40 IS NULL THEN                                                                                     
      LET g_pom.pom40=0                                                                                                             
   END IF                 
    SELECT SUM(pon31 * pon20),SUM(pon31t * pon20)
      INTO l_tot_pom40,l_tot_pom40t
      FROM pon_file
     WHERE pon01 = g_pom.pom01
    IF SQLCA.sqlcode OR l_tot_pom40 IS NULL THEN
       LET l_tot_pom40 = 0
       LET l_tot_pom40t = 0   #No.FUN-610018
    END IF
    SELECT azi04 INTO t_azi04 FROM azi_file   #No.CHI-6A0004
     WHERE azi01=g_pom.pom22 AND aziacti ='Y'
    CALL cl_digcut(l_tot_pom40,t_azi04) RETURNING l_tot_pom40    #No.CHI-6A0004
    CALL cl_digcut(l_tot_pom40t,t_azi04) RETURNING l_tot_pom40t  #No.FUN-610018   #No.CHI-6A0004
    UPDATE pom_file SET pom40 = l_tot_pom40,  #總金額
                        pom40t= l_tot_pom40t  #No.FUN-610018
                  WHERE pom01 = g_pom.pom01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","update pom40 fail :",1)  #No.FUN-660129
       LET g_success = 'N'
    END IF
    DISPLAY l_tot_pom40 TO pom40
    DISPLAY l_tot_pom40t TO pom40t  #No.FUN-610018
    LET g_pom.pom40 = l_tot_pom40   #MOD-B30413 add
    LET g_pom.pom40t = l_tot_pom40t #MOD-B30413 add
END FUNCTION


#料件輸入完後
FUNCTION t580_def()
  DEFINE  l_imaacti  LIKE ima_file.imaacti,
          l_ima02    LIKE ima_file.ima02,
          l_ima021   LIKE ima_file.ima021
 
  LET g_errno = " "
#來源料件主檔的預設值 (版本/採購單位/庫存單位/OPC/再補貨量)
  SELECT ima05,ima44,ima25,ima37,ima99,imaacti,ima02,ima15,ima021
   INTO g_pon2.pon05,g_pon2.pon07,g_pon2.pon08,g_ima37,
        g_ima99,l_imaacti,l_ima02,g_pon2.pon64,l_ima021
    FROM ima_file
   WHERE ima01=g_pon[l_ac].pon04
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                   LET l_imaacti = NULL
         WHEN l_imaacti='N' LET g_errno = '9028'
         WHEN l_imaacti MATCHES '[PH]'  LET g_errno = '9038'  #No.FUN-690022 add
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN RETURN END IF
   LET g_pon[l_ac].pon07 = g_pon2.pon07
   DISPLAY g_pon[l_ac].pon07 TO pon07
 
#來源料件/供廠商對應檔的預設值(超短交限率)
   CALL s_overate(g_pon[l_ac].pon04) RETURNING g_pon2.pon13
 
#來源料件/供廠商對應檔的預設值(標準價格)
   SELECT imb118 INTO g_pon2.pon30 FROM imb_file
                WHERE imb01 = g_pon[l_ac].pon04
END FUNCTION
 
FUNCTION t580_unit(p_unit)  #單位
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
 
FUNCTION  t562()
  DEFINE  l_flag   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE  l_pml07  LIKE pml_file.pml07
 
 
 LET p_row = 3 LET p_col = 40
 OPEN WINDOW t584_w AT p_row,p_col
      WITH FORM "apm/42f/apmt584"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("apmt584")
 
    SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=g_pon2.pon04
    CALL t584_def_form()
 
  INPUT BY NAME g_pon2.pon07,g_pon2.pon83,g_pon2.pon80,
                g_pon2.pon08,g_pon2.pon09
        WITHOUT DEFAULTS
        BEFORE INPUT
            CALL t580_set_entry_b('u')
            CALL t580_set_no_entry_b('u')
            CALL t580_set_no_required()
            CALL t580_set_required()
 
        AFTER FIELD pon83  #第二單位
            IF NOT cl_null(g_pon2.pon83) THEN
                IF (g_pon_o.pon83 IS NULL ) OR
                   (g_pon2.pon83 != g_pon_o.pon83) THEN
                    CALL t580_unit(g_pon2.pon83)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pon2.pon83,g_errno,0)
                        LET g_pon2.pon83 = g_pon_o.pon83
                        DISPLAY BY NAME g_pon2.pon83
                        NEXT FIELD pon83
                    END IF
                END IF
                LET g_pon_o.pon83  = g_pon2.pon83
             END IF
 
        AFTER FIELD pon80  #第一單位
            IF NOT cl_null(g_pon2.pon80) THEN
                IF (g_pon_o.pon80 IS NULL ) OR
                   (g_pon2.pon80 != g_pon_o.pon80) THEN
                    CALL t580_unit(g_pon2.pon80)
                    IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_pon2.pon80,g_errno,0)
                        LET g_pon2.pon80 = g_pon_o.pon80
                        DISPLAY BY NAME g_pon2.pon80
                        NEXT FIELD pon80
                    END IF
                END IF
                LET g_pon_o.pon80  = g_pon2.pon80
             END IF
 
         AFTER FIELD pon07  #採購單位,須存在
            IF cl_null(g_pon2.pon07) THEN
               NEXT FIELD pon07
            ELSE
               IF (g_pon_o.pon07 IS NULL )
                   OR (g_pon2.pon07 != g_pon_o.pon07) THEN
                  CALL t580_unit(g_pon2.pon07)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err(g_pon2.pon07,g_errno,0)
                     LET g_pon2.pon07 = g_pon_o.pon07
                     DISPLAY BY NAME g_pon2.pon07
                     NEXT FIELD pon07
                  END IF
               END IF
               IF (g_pon2.pon07 != g_pon_o.pon07 AND
                  g_pon2.pon08 IS NOT NULL ) THEN
                  CALL s_umfchk(g_pon[l_ac].pon04,g_pon2.pon07,g_pon2.pon08)
                  RETURNING l_flag,g_pon2.pon09
                  IF l_flag THEN
                     CALL cl_err(g_pon2.pon07,'mfg1206',0)
                     LET g_pon2.pon07 = g_pon_o.pon07
                     DISPLAY BY NAME g_pon2.pon07
                     LET g_pon2.pon09 = g_pon_o.pon09
                     DISPLAY BY NAME g_pon2.pon09
                     NEXT FIELD pon07
                  END IF
                  DISPLAY BY NAME g_pon2.pon09
               END IF
            END IF
            LET g_pon_o.pon07 = g_pon2.pon07
 
       BEFORE FIELD pon09         #採購對庫存轉換率
          IF g_sma.sma115 = 'Y' THEN
             IF cl_null(g_pon2.pon80) AND cl_null(g_pon2.pon83) THEN
                NEXT FIELD pon80
             END IF
             CALL t580_set_pon07() RETURNING l_flag
             IF l_flag THEN
               CALL cl_err(g_pon2.pon07,'mfg1206',0)
               LET g_pon2.pon07 = g_pon_o.pon07
               LET g_pon2.pon83 = g_pon_o.pon83
               LET g_pon2.pon80 = g_pon_o.pon80
               DISPLAY BY NAME g_pon2.pon07
               DISPLAY BY NAME g_pon2.pon83
               DISPLAY BY NAME g_pon2.pon80
               LET g_pon2.pon09 = g_pon_o.pon09
               DISPLAY BY NAME g_pon2.pon09
               NEXT FIELD pon80
             ELSE
                LET g_pon_o.pon07  = g_pon2.pon07
             END IF
          END IF
 
       AFTER FIELD pon09         #採購對庫存轉換率
            IF cl_null(g_pon2.pon09) OR g_pon2.pon09 <= 0 THEN
               CALL cl_err(g_pon2.pon09,'mfg0013',0)
               LET g_pon2.pon09 = g_pon_o.pon09
               DISPLAY g_pon2.pon09 TO pon09
               NEXT FIELD pon09
            END IF
            LET g_pon_o.pon09  = g_pon2.pon09
 
 
 
       ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pon07) #採購單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_pon2.pon07
                  CALL cl_create_qry() RETURNING g_pon2.pon07
 
                  DISPLAY BY NAME g_pon2.pon07
                  NEXT FIELD pon07
               WHEN INFIELD(pon83) #第二單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_pon2.pon83
                  CALL cl_create_qry() RETURNING g_pon2.pon83
                  DISPLAY BY NAME g_pon2.pon83
                  NEXT FIELD pon83
               WHEN INFIELD(pon80) #第一單位
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_gfe"
                  LET g_qryparam.default1 = g_pon2.pon80
                  CALL cl_create_qry() RETURNING g_pon2.pon80
                  DISPLAY BY NAME g_pon2.pon80
                  NEXT FIELD pon80
               #No.FUN-550098  --end
               OTHERWISE EXIT CASE
            END CASE
 
       ON ACTION mntn_unit #單位資料
                 LET g_cmd = 'aooi101 '
                 CALL cl_cmdrun(g_cmd)
 
       ON ACTION mntn_unit_conv #單位換算資料
                 LET g_cmd = 'aooi102 '
                 CALL cl_cmdrun(g_cmd)
 
       ON ACTION mntn_item_unit_conv #料件單位換算資料
                 LET g_cmd = 'aooi103 '
                 CALL cl_cmdrun(g_cmd)
 
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
            CALL cl_cmdask()
 
       AFTER INPUT
        IF INT_FLAG THEN                         # 若按了DEL鍵
           LET INT_FLAG = 0
           EXIT INPUT
        END IF
        LET l_flag = 'N'
        IF cl_null(g_pon2.pon07) THEN
           LET l_flag = 'Y'
           DISPLAY BY NAME g_pon2.pon07
        END IF
        IF g_sma.sma115 = 'Y' THEN
           IF cl_null(g_pon2.pon83) AND cl_null(g_pon2.pon80) THEN
              LET l_flag = 'Y'
              DISPLAY BY NAME g_pon2.pon80
              DISPLAY BY NAME g_pon2.pon83
           END IF
        END IF
        IF cl_null(g_pon2.pon09) OR g_pon2.pon09 <= 0 THEN
           LET l_flag = 'Y'
           DISPLAY BY NAME g_pon2.pon09
        END IF
        IF l_flag = 'Y' THEN
           CALL cl_err('','9033',0)
           IF g_sma.sma115 = 'N' THEN
              NEXT FIELD pon07
           ELSE
              NEXT FIELD pon80
           END IF
        END IF
        LET g_pon[l_ac].pon06 = g_pon2.pon06
        LET g_pon[l_ac].pon07 = g_pon2.pon07
        LET g_pon[l_ac].pon19 = g_pon2.pon19
        LET g_pon[l_ac].pon20 = s_digqty(g_pon[l_ac].pon20,g_pon[l_ac].pon07) #FUN-BB0085
        LET g_pon[l_ac].pon80 = g_pon2.pon80
        LET g_pon[l_ac].pon82 = s_digqty(g_pon[l_ac].pon82,g_pon[l_ac].pon80) #FUN-BB0085
        LET g_pon[l_ac].pon83 = g_pon2.pon83
        LET g_pon[l_ac].pon85 = s_digqty(g_pon[l_ac].pon85,g_pon[l_ac].pon83) #FUN-BB0085
        #No.FUN-550098  --end
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
 END INPUT
 CLOSE WINDOW t584_w
END FUNCTION
 
#FUNCTION t580_x() #FUN-D20025 mark
FUNCTION t580_x(p_type) #FUN-D20025 add
DEFINE l_pon02     LIKE pon_file.pon02  #FUN-C30057 ---add---
DEFINE p_type    LIKE type_file.chr1  #FUN-D20025 add 
   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_pom.* FROM pom_file WHERE pom01=g_pom.pom01
   IF g_pom.pom01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_pom.pom18 = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #FUN-D20025---begin 
   IF p_type = 1 THEN 
      IF g_pom.pom18='X' THEN RETURN END IF
   ELSE
      IF g_pom.pom18<>'X' THEN RETURN END IF
   END IF 
   #FUN-D20025---end     
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t580_cl USING g_pom.pom01
   IF STATUS THEN
      CALL cl_err("OPEN t580_cl:", STATUS, 1)
      CLOSE t580_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t580_cl INTO g_pom.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   IF cl_void(0,0,g_pom.pom18) THEN
        IF g_pom.pom18 ='N' THEN
            LET g_pom.pom18='X'
            LET g_pom.pom25='9'
        ELSE
            LET g_pom.pom18='N'
            LET g_pom.pom25='0'
        END IF

        UPDATE pom_file SET pom18 = g_pom.pom18,
                            pom25 = g_pom.pom25,
                            pommodu=g_user,
                            pomdate=TODAY
          WHERE pom01 = g_pom.pom01
       IF STATUS THEN
          CALL cl_err3("upd","pom_file",g_pom.pom01,"",STATUS,"","upd pomconf:",1)  #No.FUN-660129
          LET g_success='N'
       END IF
       UPDATE pon_file SET pon16=g_pom.pom25 WHERE pon01 = g_pom.pom01
       IF STATUS THEN
          CALL cl_err3("upd","pon_file",g_pom.pom01,"",STATUS,"","upd pon16:",1)  #No.FUN-660129
          LET g_success='N'
       END IF
   END IF
   IF g_success='Y' THEN
       COMMIT WORK
       CALL cl_flow_notify(g_pom.pom01,'V')
   ELSE
       ROLLBACK WORK
   END IF
   SELECT pom18,pom25 INTO g_pom.pom18,g_pom.pom25
     FROM pom_file WHERE pom01 = g_pom.pom01
   CALL s_pmmsta('pmm',g_pom.pom25,g_pom.pom18,g_pom.pommksg) RETURNING g_sta
   DISPLAY g_sta TO FORMONLY.desc2
   DISPLAY BY NAME g_pom.pom18,g_pom.pom25
    #CKP
    IF g_pom.pom18='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pom.pom25='1' OR
       g_pom.pom25='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    IF g_pom.pom25='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
    CALL cl_set_field_pic(g_pom.pom18,"",g_chr2,g_chr3,g_chr,"")
END FUNCTION
 
FUNCTION t580_y()   # when g_pmk.pmk18='N' (Turn to 'Y')
   DEFINE l_cnt LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE l_status     LIKE type_file.num10  #FUN-880016
   DEFINE l_pmn52      LIKE pmn_file.pmn52   #FUN-AB0066
   DEFINE l_gemacti    LIKE gem_file.gemacti #TQC-C60178
#FUN-C70098---add--begin--------
#FUN-C70098---add---end---------
   DEFINE l_gen02      LIKE gen_file.gen02   #TQC-D40036 add

#CHI-C30107 --------------- add ------------------ begin
   IF g_pom.pom18='X' THEN CALL cl_err('','9024',0) RETURN END IF  #No.MOD-480239
   IF g_pom.pom18='Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
   SELECT * INTO g_pom.* FROM pom_file WHERE pom01 = g_pom.pom01
#CHI-C30107 --------------- add ------------------ end
   IF g_pom.pom18='X' THEN CALL cl_err('','9024',0) RETURN END IF  #No.MOD-480239
   IF g_pom.pom18='Y' THEN RETURN END IF
#TQC-C60178 --- add -- begin
   SELECT gemacti INTO l_gemacti FROM gem_file
    WHERE gem01 = g_pom.pom13
   IF l_gemacti <> 'Y' THEN
      CALL cl_err(g_pom.pom13,'apm1079',0)
      RETURN
   END IF
#TQC-C60178 --- add -- end 

#---BUGNO:7379---無單身資料不可確認
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt
     FROM pon_file
    WHERE pon01=g_pom.pom01
   IF l_cnt=0 OR l_cnt IS NULL THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   #FUN-C70098----add----begin--------------
   #FUN-C70098----add----end----------------

#FUN-AB0066 --begin--
   DECLARE t580_pon52 CURSOR FOR 
    SELECT pon52 FROM pon_file
     WHERE pon01 = g_pom.pom01
   FOREACH t580_pon52 INTO l_pon52
      IF NOT s_chk_ware(l_pon52) THEN 
         RETURN 
      END IF 
   END FOREACH      
#FUN-AB0066 --end--
 
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK LET g_success = 'Y'
 
   OPEN t580_cl USING g_pom.pom01
   IF STATUS THEN
      CALL cl_err("OPEN t580_cl:", STATUS, 1)
      CLOSE t580_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t580_cl INTO g_pom.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)
      CLOSE t580_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   #No.FUN-830161  --Begin  BPO不做預算管控了
   ##--------------------------------- 請採購預算控管 00/03/29 By Melody
   #IF g_smy.smy59='Y' AND g_success='Y' THEN CALL t580_budchk() END IF
   ##-------------------------------------------------------------------
 
   IF g_aza.aza71 MATCHES '[Yy]' THEN   #FUN-8A0054 判斷是否有勾選〝與GPM整合〞，有則做GPM控
      LET g_t1 = s_get_doc_no(g_pom.pom01) 
      SELECT * INTO g_smy.* FROM smy_file
      WHERE smyslip=g_t1
      IF g_smy.smy64 != '0' THEN    #要控管GPM
         CALL s_showmsg_init()
         CALL aws_gpmcli_part(g_pom.pom01,g_pom.pom09,'','2')
	      RETURNING l_status
         IF l_status = '1' THEN   #回傳結果為失敗
            IF g_smy.smy64 = '1' THEN
               CALL s_showmsg()
            END IF
            IF g_smy.smy64 = '2' THEN   
                LET g_success = 'N'
                CALL s_showmsg()
                RETURN
            END IF
         END IF
      END IF
   END IF               #FUN-8A0054
 
   CALL t580_y1()    #FUN-8A0054 add  若做GPM控管，則會等控管結束後才做確認動作
 
   IF g_success = 'Y' THEN
           LET g_pom.pom18='Y'
           COMMIT WORK
           CALL cl_flow_notify(g_pom.pom01,'Y')
           DISPLAY BY NAME g_pom.pom25
           CALL s_pmmsta('pmm',g_pom.pom25,g_pom.pom18,g_pom.pommksg)
                         RETURNING g_sta
           DISPLAY g_sta TO FORMONLY.desc2
           DISPLAY BY NAME g_pom.pom18
      ELSE LET g_pom.pom18='N' ROLLBACK WORK
   END IF
   #-----CHI-B10034---------
   SELECT pom15 INTO g_pom.pom15 FROM pom_file WHERE pom01=g_pom.pom01
   DISPLAY BY NAME g_pom.pom15
   #-----END CHI-B10034-----
   #TQC-D40036---add--str
   SELECT gen02 INTO l_gen02
     FROM gen_file
    WHERE gen01 = g_pom.pom15
   DISPLAY l_gen02 TO FORMONLY.gen02_2
   #TQC-D40036---add--end
    #CKP
    IF g_pom.pom18='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pom.pom25='1' OR
       g_pom.pom25='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    IF g_pom.pom25='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
    CALL cl_set_field_pic(g_pom.pom18,"",g_chr2,g_chr3,g_chr,"")
END FUNCTION
 
FUNCTION t580_z() 	# when g_pmk.pmk18='Y' (Turn to 'N')
   DEFINE l_gen02      LIKE gen_file.gen02   #TQC-D40036 add

   SELECT * INTO g_pom.* FROM pom_file WHERE pom01=g_pom.pom01   #MOD-A30079
   IF g_pom.pom18='N' THEN RETURN END IF
   IF g_pom.pom25 not matches '[X01]' THEN
      CALL cl_err('Status not allow','!',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK LET g_success = 'Y'
 
   OPEN t580_cl USING g_pom.pom01
   IF STATUS THEN
      CALL cl_err("OPEN t580_cl:", STATUS, 1)
      CLOSE t580_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t580_cl INTO g_pom.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_pom.pom01,SQLCA.sqlcode,0)
      CLOSE t580_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t580_z1()
 
   IF g_success = 'Y'
      THEN LET g_pom.pom18='N' COMMIT WORK
           DISPLAY BY NAME g_pom.pom03
           DISPLAY BY NAME g_pom.pom25
           CALL s_pmmsta('pmm',g_pom.pom25,g_pom.pom18,g_pom.pommksg)
                         RETURNING g_sta
           DISPLAY g_sta TO FORMONLY.desc2
           DISPLAY BY NAME g_pom.pom18
      ELSE LET g_pom.pom18='Y' ROLLBACK WORK
   END IF
   #TQC-D40036---add---str
   SELECT pom15 INTO g_pom.pom15 FROM pom_file WHERE pom01=g_pom.pom01
   DISPLAY BY NAME g_pom.pom15 
   SELECT gen02 INTO l_gen02
     FROM gen_file 
    WHERE gen01 = g_pom.pom15
   DISPLAY l_gen02 TO FORMONLY.gen02_2
   #TQC-D40036---add---end
    #CKP
    IF g_pom.pom18='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    IF g_pom.pom25='1' OR
       g_pom.pom25='2' THEN LET g_chr2='Y' ELSE LET g_chr2='N' END IF
    IF g_pom.pom25='6' THEN LET g_chr3='Y' ELSE LET g_chr3='N' END IF
    CALL cl_set_field_pic(g_pom.pom18,"",g_chr2,g_chr3,g_chr,"")
END FUNCTION
 
FUNCTION t580_y1()
   DEFINE l_cmd		LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(400)
 
   IF g_pom.pommksg='N' AND g_pom.pom25='0' THEN
      LET g_pom.pom25='1'
      UPDATE pon_file SET pon16=g_pom.pom25
       WHERE pon01=g_pom.pom01
      IF STATUS THEN
         CALL cl_err3("upd","pon_file",g_pom.pom01,"",STATUS,"","upd pon16",1)  #No.FUN-660129
         LET g_success = 'N' RETURN 
      END IF
   END IF
   LET g_wc2='1=1'
   CALL t580_b_fill(g_wc2,' 1=1')
   UPDATE pom_file SET
          pom25=g_pom.pom25,
          pom18='Y',
          pom15=g_user   #CHI-B10034
    WHERE pom01 = g_pom.pom01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","pom_file",g_pom.pom01,"",STATUS,"","upd pom18",1)  #No.FUN-660129
      LET g_success = 'N' RETURN 
   END IF
END FUNCTION
 
FUNCTION t580_z1()
   LET g_pom.pom25=0
   LET g_pom.pom03=g_pom.pom03+1
   UPDATE pom_file SET
          pom03=g_pom.pom03,
          pom18='N',
          pom25=g_pom.pom25,
          pom15=g_user,     #TQC-D40036 Add
          pomsseq=0
          WHERE pom01 = g_pom.pom01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","pom_file",g_pom.pom01,"",STATUS,"","upd pom18",1)  #No.FUN-660129
      LET g_success = 'N' RETURN 
   ELSE
     # 將簽核資料還原
      IF g_pom.pommksg MATCHES '[Yy]'  THEN
         LET g_pom.pomsseq = 0
         DELETE FROM azd_file WHERE azd01 = g_pom.pom01 AND azd02 = 3
         IF STATUS  THEN 
            LET g_success = 'N' 
            RETURN
         ELSE
            CALL s_signm(6,34,g_lang,'2',g_pom.pom01,3,g_pom.pomsign,
                         g_pom.pomdays,g_pom.pomprit,g_pom.pomsmax,g_pom.pomsseq)
         END IF
      END IF
   END IF
 
END FUNCTION
 

 
FUNCTION t580_pon(p_pml01,p_pml02,p_n)      #產生單身資料
  DEFINE p_pml01    LIKE pml_file.pml01
  DEFINE p_pml02    LIKE pml_file.pml02
  DEFINE l_flag     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
  DEFINE p_n        LIKE type_file.num5     #No.FUN-680136 SMALLINT
  DEFINE l_pml      RECORD LIKE pml_file.*
  DEFINE l_pon      RECORD LIKE pon_file.*
  DEFINE l_pon87     LIKE pon_file.pon87
  DEFINE l_pon86     LIKE pon_file.pon86
 
  #---取出請購單身資料
   SELECT * INTO l_pml.* FROM pml_file
    WHERE pml01=p_pml01 AND pml02=p_pml02
 
  #---產生採購單身資料
   LET  l_pon.pon01=g_pom.pom01          #採購單號
   LET  l_pon.pon011=g_pom.pom02         #採購性質
   LET  l_pon.pon02=p_n                  #序號
   LET  l_pon.pon03=l_pml.pml03          #詢價單號
   LET  l_pon.pon04=l_pml.pml04          #料號
   LET  l_pon.pon041=l_pml.pml041        #品名
   LET  l_pon.pon05=l_pml.pml05          #APS單號 no.4649
   LET  l_pon.pon06=l_pml.pml06          #廠商料號
   LET  l_pon.pon08=l_pml.pml08          #庫存單位
 
   IF l_pml.pml04[1,4] <> 'MISC' THEN
      SELECT ima44 INTO l_pon.pon07 FROM ima_file  #採購單位
       WHERE ima01=l_pon.pon04
      CALL s_umfchk(l_pon.pon04,l_pon.pon07,l_pon.pon08)
           RETURNING l_flag,l_pon.pon09            #取換算率(採購對庫存)
      IF l_flag=1 THEN                             #單位換算率抓不到
         IF g_bgerr THEN
            CALL s_errmsg("","","","abm-731",1)
         ELSE
            CALL cl_err3("","","","","abm-731","","",1)
         END IF
         RETURN
      END IF
   END IF
   LET  l_pon.pon10=l_pml.pml10         #檢驗碼
   LET  l_pon.pon11=l_pml.pml11         #凍結碼
   LET  l_pon.pon121=1                  #採購對請購之轉換率
   LET  l_pon.pon122=l_pml.pml12        #No use->專案代號 00/04/18
   LET  l_pon.pon123=l_pml.pml123       #No use
   LET  l_pon.pon13=l_pml.pml13          #超短交限率
   LET  l_pon.pon14=l_pml.pml14          #部份交貨否
   LET  l_pon.pon15=l_pml.pml15          #提前交貨否
   LET  l_pon.pon16='0'
   LET  l_pon.pon18=l_pml.pml18          #MRP需求日
   LET  l_pon.pon20=l_pml.pml20-l_pml.pml21 #採購量
   LET  l_pon.pon20=s_digqty(l_pon.pon20,l_pon.pon07)     #FUN-BB0085
   LET  l_pon.pon23=' '                  #送貨地址
   LET  l_pon.pon24=p_pml01              #請購單號
   LET  l_pon.pon25=p_pml02              #序號
   LET  l_pon.pon30=l_pml.pml30          #標準價格
   CALL s_defprice_new(l_pon.pon04,g_pom.pom09,g_pom.pom22,g_pom.pom04,l_pon87,'',g_pom.pom21,g_pom.pom43,'1',l_pon86,'',g_pom.pom41,g_pom.pom20,g_plant) 
      RETURNING l_pon.pon31,l_pon.pon31t,
                g_pmn73,g_pmn74   #TQC-AC0257 add
   CALL t580_price_check(l_pon.pon31,l_pon.pon31t)  #MOD-9C0285 ADD
    IF NOT cl_null(g_errno) THEN
       CALL cl_err('',g_errno,1)
    END IF
   LET  l_pon.pon32=l_pml.pml32          #採購價差(PPV)
   LET  l_pon.pon34=l_pml.pml34          #原始到廠日期
   LET  l_pon.pon33=l_pon.pon34          #原始交貨日
   LET  l_pon.pon35=l_pon.pon34          #到庫日
   LET  l_pon.pon36=NULL                 #最近確認交貨日期
   LET  l_pon.pon37=NULL                 #最後一次到廠日期
   LET  l_pon.pon38=l_pml.pml38          #可用/不可用
   LET  l_pon.pon40=l_pml.pml40          #會計科目
   LET  l_pon.pon41=l_pml.pml41          #工單號碼
   LET  l_pon.pon42=l_pml.pml42          #替代碼
   LET  l_pon.pon43=l_pml.pml43          #作業序號
   LET  l_pon.pon431=l_pml.pml431        #下一站作業序號
   LET  l_pon.pon44 =l_pon.pon31*g_pom.pom42  #本幣單價
   LET  l_pon.pon45=0                    #無交期性採購單項次
   LET  l_pon.pon50=0                    #交貨量
   LET  l_pon.pon51=0                    #在驗量
   LET  l_pon.pon53=0                    #入庫量
   SELECT ima35,ima36 INTO l_pon.pon52,l_pon.pon54 FROM ima_file
    WHERE ima01=l_pon.pon04
   LET  l_pon.pon55=0                     #驗退量
   LET  l_pon.pon56=' '                   #批號
   LET  l_pon.pon57=0                     #超短交量
   LET  l_pon.pon58=0                     #無交期性採購單已轉量
   LET  l_pon.pon59=' '                   #退貨單號
   LET  l_pon.pon60=' '                   #項次
   LET  l_pon.pon61=l_pon.pon04           #被替代料號
   LET  l_pon.pon62=1                     #替代率
   LET  l_pon.pon63='N'                   #急料否
   LET  l_pon.pon67=l_pml.pml67
   LET  l_pon.pon83=l_pml.pml83
   LET  l_pon.pon84=l_pml.pml84
   LET  l_pon.pon85=l_pml.pml85
   LET  l_pon.pon80=l_pml.pml80
   LET  l_pon.pon81=l_pml.pml81
   LET  l_pon.pon82=l_pml.pml82
   LET  l_pon.pon86=l_pml.pml86
   LET  l_pon.pon87=l_pml.pml87
   LET  l_pon.pon88=l_pml.pml88
   LET  l_pon.pon88t=l_pml.pml88t
   SELECT ima15 INTO l_pon.pon64 FROM ima_file
    WHERE ima01=l_pml.pml04
   IF cl_null(l_pon.pon64) OR l_pon.pon64 NOT MATCHES '[YN]' THEN
      LET  l_pon.pon64='N'
   END IF
   LET  l_pon.pon65='1'                   #一般/代買
   LET  l_pon.ponplant = g_plant #FUN-980006 add 
   LET  l_pon.ponlegal = g_legal #FUN-980006 add 
 
   # check 請購量+容許量
   IF g_sma.sma32='Y' THEN   #請購與採購是否要互相勾稽
      IF t580_available_qty(l_pon.pon09*l_pon.pon20,
                            l_pon.pon24,l_pon.pon25,l_pon.pon04)
      THEN RETURN END IF
   END IF
   IF g_success = 'Y' THEN
      INSERT INTO pon_file VALUES (l_pon.*)
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         IF g_bgerr THEN
            LET g_showmsg = l_pon.pon01,"/",l_pon.pon02
            CALL s_errmsg("pon01,pon02",g_showmsg,"ins pon",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","pon_file",l_pon.pon01,l_pon.pon02,SQLCA.sqlcode,"","ins pon",1)
         END IF
         RETURN
      END IF
   END IF
 
END FUNCTION
 
FUNCTION  t580_pmo(p_pml01,p_pml02,p_n)      #請購單號
   DEFINE   p_pml01    LIKE pml_file.pml01
   DEFINE   p_pml02    LIKE pml_file.pml02
   DEFINE   l_pmo      RECORD LIKE pmo_file.*
   DEFINE   p_n        LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE   l_sql      LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(300)
 
   LET l_sql = "SELECT pmo01,pmo02,pmo03,pmo04,pmo05,pmo06 ",
               " FROM pmo_file ",
               " WHERE pmo01 ='",p_pml01,"' ",
               "   AND pmo02='0' AND pmo03=",p_pml02,
               " ORDER BY 1"
   PREPARE t580_pmo2 FROM l_sql
   DECLARE pmo2_cs CURSOR FOR t580_pmo2  #CURSOR
   FOREACH pmo2_cs INTO l_pmo.*          #單身 ARRAY 填充
     LET l_pmo.pmo01=g_pom.pom01
     LET l_pmo.pmo02='1'
     LET l_pmo.pmo03=p_n
     LET l_pmo.pmoplant = g_plant #FUN-980006 add
     LET l_pmo.pmolegal = g_legal #FUN-980006 add
     INSERT INTO pmo_file VALUES (l_pmo.*)
     IF SQLCA.sqlcode THEN
        LET g_success='N'
       IF g_bgerr THEN
          LET g_showmsg = l_pmo.pmo01,"/",l_pmo.pmo03
          CALL s_errmsg("pmo01,pmo03",g_showmsg,"ins pmo2",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("ins","pmo_file",l_pmo.pmo01,l_pmo.pmo03,SQLCA.sqlcode,"","ins pmo2",1)
       END IF
        RETURN
     END IF
   END FOREACH
 
END FUNCTION
 
FUNCTION  t580_pom40()     #update 採購單頭的總金額
   DEFINE l_pom40  LIKE pom_file.pom40,
          l_pom40t LIKE pom_file.pom40t
   SELECT SUM(pon20*pon31),SUM(pon20*pon31t)
     INTO l_pom40,l_pom40t
     FROM pon_file
    WHERE pon01 = g_pom.pom01
   IF cl_null(l_pom40) THEN LET l_pom40 = 0 END IF
   IF cl_null(l_pom40t) THEN LET l_pom40t = 0 END IF
   LET l_pom40 = cl_digcut(l_pom40,t_azi04)   #No.CHI-6A0004
   LET l_pom40t = cl_digcut(l_pom40t,t_azi04)   #No.CHI-6A0004
   UPDATE pom_file SET pom40 = l_pom40,
                       pom40t= l_pom40t
                 WHERE pom01 = g_pom.pom01
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      IF g_bgerr THEN
         CALL s_errmsg("pom01",g_pom.pom01,"upd pom40",SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","pom_file",g_pom.pom01,"",SQLCA.sqlcode,"","upd pom40",1)
      END IF
      RETURN
   END IF
END FUNCTION

FUNCTION t580_available_qty(p_qty,p_pon24,p_pon25,p_item)
DEFINE   p_pon24  LIKE  pon_file.pon24
DEFINE   p_pon25  LIKE  pon_file.pon25
DEFINE   p_item   LIKE  pon_file.pon04
DEFINE   p_qty    LIKE  pon_file.pon20,
         l_pon20  LIKE  pon_file.pon20,
         l_over   LIKE  pml_file.pml20,   #No.FUN-680136 DECIMAL(13,3)
         l_ima07  LIKE  ima_file.ima07,
         l_pml20  LIKE  pml_file.pml20
 
   LET l_pon20 = 0
   SELECT SUM(pon20/pon62*pon121) INTO l_pon20 FROM pon_file #採購量
    WHERE pon24=p_pon24     #請購單
      AND pon25=p_pon25     #請購序號
      AND pon16<>'9'        #取消(Cancel)
   IF STATUS OR cl_null(l_pon20) THEN LET l_pon20 = 0 END IF
 #----------------與請購互相勾稽 -------------------------------------
   SELECT ima07 INTO l_ima07 FROM ima_file  #select ABC code
    WHERE ima01=p_item
 
   SELECT pml20*pml09 INTO l_pml20 FROM pml_file
    WHERE pml01=p_pon24
      AND pml02=p_pon25
 
   IF cl_null(l_pml20) THEN LET l_pml20 = 0 END IF
   CASE
   WHEN l_ima07='A'  #計算可容許的數量
        LET l_over=l_pml20 * (g_sma.sma341/100)
   WHEN l_ima07='B'
        LET l_over=l_pml20 * (g_sma.sma342/100)
   WHEN l_ima07='C'
        LET l_over=l_pml20 * (g_sma.sma343/100)
   OTHERWISE
        LET l_over=0
   END CASE
   IF p_qty+l_pon20>    #本筆採購量+已轉採購量
      (l_pml20+l_over) THEN   #請購量+容許量
       CALL cl_err(p_qty,'mfg3425',1)  #MOD-490284
      IF g_sma.sma33='R'    #reject
         THEN
         RETURN -1
      END IF
   END IF
   RETURN 0
END FUNCTION
 
#genero
FUNCTION t580_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
      CALL cl_set_comp_entry("pom01",TRUE)
   END IF
    CALL cl_set_comp_entry("pom15",TRUE)   #TQC-D40036 cj add
END FUNCTION
 
FUNCTION t580_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
       IF p_cmd = 'u' AND g_chkey ="N" THEN   #No.MOD-580389
           CALL cl_set_comp_entry("pom01",FALSE)
       END IF
 

  #TQC-D40036---S---
   IF p_cmd='u' OR p_cmd='a' THEN
      CALL cl_set_comp_entry("pom15",FALSE)
   END IF
  #TQC-D40036---E---
END FUNCTION
 
FUNCTION t580_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF NOT g_before_input_done THEN
       CALL cl_set_comp_entry("pon31,pon31t",TRUE)
   END IF
 
   IF INFIELD(pon04) THEN
       CALL cl_set_comp_entry("pon041",TRUE)
   END IF
 
   CALL cl_set_comp_entry("pon81,pon83,pon84,pon85,pon86,pon87",TRUE)
 
END FUNCTION
 
FUNCTION t580_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF INFIELD(pon04) THEN
      IF g_pon[l_ac].pon04[1,4] != 'MISC' THEN
         CALL cl_set_comp_entry("pon041",FALSE)
      END IF
   END IF
 
   IF g_gec07 = 'N' THEN        #No.FUN-560102
      CALL cl_set_comp_entry("pon31t",FALSE)
   ELSE
      CALL cl_set_comp_entry("pon31",FALSE)
   END IF
 
   IF g_ima906 = '1' THEN
      CALL cl_set_comp_entry("pon83,pon84,pon85",FALSE)
   END IF
   #參考單位，每個料件只有一個，所以不開放讓用戶輸入
   IF g_ima906 = '3' THEN
      CALL cl_set_comp_entry("pon83",FALSE)
   END IF
   IF g_ima906 = '2' THEN
      CALL cl_set_comp_entry("pon84,pon81",FALSE)
   END IF
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
      CALL cl_set_comp_entry("pon86,pon87",FALSE)
   END IF
END FUNCTION
 
FUNCTION t580_set_required()
 
   #兩組雙單位資料不是一定要全部輸入,但是參考單位的時候要全輸入
   #No.TQC-5C0014  --Begin
   IF g_ima906 = '3' THEN
      #CALL cl_set_comp_required("pon83,pon84,pon85,pon80,pon81,pon82",TRUE)
      CALL cl_set_comp_required("pon83,pon85,pon80,pon82",TRUE)
   END IF
   #單位不同,轉換率,數量必KEY
   IF NOT cl_null(g_pon[l_ac].pon80) THEN
      #CALL cl_set_comp_required("pon81,pon82",TRUE)
      CALL cl_set_comp_required("pon82",TRUE)
   END IF
   IF NOT cl_null(g_pon[l_ac].pon83) THEN
      CALL cl_set_comp_required("pon85",TRUE)
   END IF
   IF NOT cl_null(g_pon[l_ac].pon86) THEN
      CALL cl_set_comp_required("pon87",TRUE)
   END IF
END FUNCTION
 
FUNCTION t580_set_no_required()
 
  CALL cl_set_comp_required("pon83,pon84,pon85,pon80,pon81,pon82,pon86,pon87",FALSE)
 
END FUNCTION
 
#用于default 雙單位/轉換率/數量
FUNCTION t580_du_default(p_cmd)
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_ima908 LIKE ima_file.ima907,
            l_unit2  LIKE img_file.img09,     #第二單位
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_unit1  LIKE img_file.img09,     #第一單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_unit3  LIKE img_file.img09,     #計價單位
            l_qty3   LIKE img_file.img10,     #計價數量
            p_cmd    LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            l_factor LIKE ima_file.ima31_fac   #No.FUN-680136 DECIMAL(16,8)
 
    LET l_item = g_pon[l_ac].pon04
 
    SELECT ima44,ima906,ima907,ima908
      INTO l_ima44,l_ima906,l_ima907,l_ima908
      FROM ima_file WHERE ima01 = l_item
 
    IF g_sma.sma115 = 'Y' THEN        ##No.TQC-6B0124 add
       IF l_ima906 = '1' THEN  #不使用雙單位
          LET l_unit2 = NULL
          LET l_fac2  = NULL
          LET l_qty2  = NULL
       ELSE
          LET l_unit2 = l_ima907
          CALL s_du_umfchk(l_item,'','','',l_ima44,l_ima907,l_ima906)
               RETURNING g_errno,l_factor
          LET l_fac2 = l_factor
          LET l_qty2  = 0
       END IF
       
       LET l_unit1 = l_ima44
       LET l_fac1  = 1
       LET l_qty1  = 0
    END IF                  ##No.TQC-6B0124 add
 
    IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       LET l_unit3 = NULL
       LET l_qty3  = NULL
    ELSE
       LET l_unit3 = l_ima908
       LET l_qty3  = 0
    END IF
 
    IF p_cmd = 'a' THEN
       
       LET g_pon[l_ac].pon83=l_unit2
       LET g_pon[l_ac].pon84=l_fac2
       LET g_pon[l_ac].pon85=l_qty2
       LET g_pon[l_ac].pon85=s_digqty(g_pon[l_ac].pon85,g_pon[l_ac].pon83)  #FUN-BB0085
       LET g_pon[l_ac].pon80=l_unit1
       LET g_pon[l_ac].pon81=l_fac1
       LET g_pon[l_ac].pon82=l_qty1
       LET g_pon[l_ac].pon82=s_digqty(g_pon[l_ac].pon82,g_pon[l_ac].pon80)  #FUN-BB0085
       LET g_pon[l_ac].pon86=l_unit3
       LET g_pon[l_ac].pon87=l_qty3
       LET g_pon[l_ac].pon87=s_digqty(g_pon[l_ac].pon87,g_pon[l_ac].pon86)  #FUN-BB0085
       LET g_pon2.pon83 = g_pon[l_ac].pon83
       LET g_pon2.pon84 = g_pon[l_ac].pon84
       LET g_pon2.pon85 = g_pon[l_ac].pon85
       LET g_pon2.pon80 = g_pon[l_ac].pon80
       LET g_pon2.pon81 = g_pon[l_ac].pon81
       LET g_pon2.pon82 = g_pon[l_ac].pon82
       LET g_pon2.pon86 = g_pon[l_ac].pon86
       LET g_pon2.pon87 = g_pon[l_ac].pon87
    END IF
END FUNCTION
 
#對原來數量/換算率/單位的賦值
FUNCTION t580_set_origin_field()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,     #img單位
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pon_file.pon84,
            l_qty2   LIKE pon_file.pon85,
            l_fac1   LIKE pon_file.pon81,
            l_qty1   LIKE pon_file.pon82,
            l_factor LIKE ima_file.ima31_fac,   #No.FUN-680136 DECIMAL(16,8)
            l_ima25  LIKE ima_file.ima25,
            l_ima44  LIKE ima_file.ima44
 
    IF g_sma.sma115='N' THEN RETURN END IF
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=g_pon[l_ac].pon04
    IF SQLCA.sqlcode = 100 THEN
       IF g_pon[l_ac].pon04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44=l_ima25 END IF
    LET l_fac2=g_pon[l_ac].pon84
    LET l_qty2=g_pon[l_ac].pon85
    LET l_fac1=g_pon[l_ac].pon81
    LET l_qty1=g_pon[l_ac].pon82
 
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE g_ima906
          #'1'這種情況是不應該出現的.但是由于操作的順序問題,故目前保留它
          WHEN '1' LET g_pon[l_ac].pon07=g_pon[l_ac].pon80
                   LET g_pon[l_ac].pon20=l_qty1
          WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                   LET g_pon[l_ac].pon07=l_ima44
                   LET g_pon[l_ac].pon20=l_tot
          WHEN '3' LET g_pon[l_ac].pon07=g_pon[l_ac].pon80
                   LET g_pon[l_ac].pon20=l_qty1
                   IF l_qty2 <> 0 THEN
                      LET g_pon[l_ac].pon84=l_qty1/l_qty2
                   ELSE
                      LET g_pon[l_ac].pon84=0
                   END IF
       END CASE
       LET g_pon[l_ac].pon20=s_digqty(g_pon[l_ac].pon20,g_pon[l_ac].pon07)    #FUN-BB0085
    END IF
 
    LET g_pon2.pon07=g_pon[l_ac].pon07
    LET g_pon2.pon20=g_pon[l_ac].pon20
 
    LET g_factor = 1
    CALL s_umfchk(g_pon[l_ac].pon04,g_pon[l_ac].pon07,l_ima25)
          RETURNING g_cnt,g_factor
    IF g_cnt = 1 THEN
       LET g_factor = 1
    END IF
    LET g_pon2.pon09 = g_factor
 
    IF cl_null(g_pon[l_ac].pon86) THEN
       LET g_pon[l_ac].pon86 = g_pon[l_ac].pon07
       LET g_pon[l_ac].pon87 = g_pon[l_ac].pon20
    END IF
    IF cl_null(g_pon2.pon88) THEN
       LET g_pon2.pon88 = g_pon2.pon31 * g_pon[l_ac].pon87
    END IF
    IF cl_null(g_pon2.pon88t) THEN
       LET g_pon2.pon88t= g_pon2.pon31t* g_pon[l_ac].pon87
    END IF
END FUNCTION
 
#兩組雙單位資料不是一定要全部KEY,如果沒有KEY單位,則把換算率/數量清空
FUNCTION t580_du_data_to_correct()
 
   IF cl_null(g_pon[l_ac].pon80) THEN
      LET g_pon[l_ac].pon81 = NULL
      LET g_pon[l_ac].pon82 = NULL
      LET g_pon2.pon80 = NULL
      LET g_pon2.pon81 = NULL
      LET g_pon2.pon82 = NULL
   END IF
 
   IF cl_null(g_pon[l_ac].pon83) THEN
      LET g_pon[l_ac].pon84 = NULL
      LET g_pon[l_ac].pon85 = NULL
      LET g_pon2.pon83 = NULL
      LET g_pon2.pon84 = NULL
      LET g_pon2.pon85 = NULL
   END IF
 
   IF cl_null(g_pon[l_ac].pon86) THEN
      LET g_pon[l_ac].pon87 = NULL
      LET g_pon2.pon86 = NULL
      LET g_pon2.pon87 = NULL
   END IF
 
   DISPLAY BY NAME g_pon[l_ac].pon81
   DISPLAY BY NAME g_pon[l_ac].pon82
   DISPLAY BY NAME g_pon[l_ac].pon84
   DISPLAY BY NAME g_pon[l_ac].pon85
   DISPLAY BY NAME g_pon[l_ac].pon86
   DISPLAY BY NAME g_pon[l_ac].pon87
 
END FUNCTION
 
FUNCTION t580_set_pon87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac   #No.FUN-680136 DECIMAL(16,8)
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=g_pon[l_ac].pon04
 
    IF SQLCA.sqlcode =100 THEN
       IF g_pon[l_ac].pon04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac2=g_pon[l_ac].pon84
       LET l_qty2=g_pon[l_ac].pon85
       LET l_fac1=g_pon[l_ac].pon81
       LET l_qty1=g_pon[l_ac].pon82
    ELSE
       LET l_fac1=1
       LET l_qty1=g_pon[l_ac].pon20
       CALL s_umfchk(g_pon[l_ac].pon04,g_pon[l_ac].pon07,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    IF g_sma.sma115 = 'Y' THEN
       CALL s_umfchk(g_pon[l_ac].pon04,g_pon[l_ac].pon07,g_pon[l_ac].pon86)
             RETURNING g_cnt,l_factor
    ELSE
    CALL s_umfchk(g_pon[l_ac].pon04,l_ima44,g_pon[l_ac].pon86)
          RETURNING g_cnt,l_factor
    END IF                   #No.CHI-960052 
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET g_pon[l_ac].pon87 = l_tot
    LET g_pon[l_ac].pon87 = s_digqty(g_pon[l_ac].pon87,g_pon[l_ac].pon86)     #FUN-BB0085
    LET g_pon2.pon87 = g_pon[l_ac].pon87
    LET g_pon_o.pon87 = g_pon[l_ac].pon87
    DISPLAY BY NAME g_pon[l_ac].pon87
END FUNCTION

FUNCTION t580_set_pon07()
  DEFINE    l_ima906 LIKE ima_file.ima906,
            l_ima907 LIKE ima_file.ima907,
            l_img09  LIKE img_file.img09,
            l_tot    LIKE img_file.img10,
            l_fac2   LIKE pon_file.pon84,
            l_qty2   LIKE pon_file.pon85,
            l_fac1   LIKE pon_file.pon81,
            l_qty1   LIKE pon_file.pon82,
            l_factor LIKE ima_file.ima31_fac,   #No.FUN-680136 DECIMAL(16,8)
            l_ima44  LIKE ima_file.ima44,
            l_pml07  LIKE pml_file.pml07,
            l_flag   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)
            p_code   LIKE type_file.chr1     #No.FUN-680136 VARCHAR(01)
 
   SELECT ima44,ima906 INTO l_ima44,l_ima906 FROM ima_file
    WHERE ima01=g_pon[l_ac].pon04
   LET l_fac2=g_pon2.pon84
   LET l_qty2=g_pon2.pon85
   LET l_fac1=g_pon2.pon81
   LET l_qty1=g_pon2.pon82
 
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET g_pon2.pon07=g_pon2.pon80
                  LET g_pon2.pon20=l_qty1
         WHEN '2' LET l_tot=l_fac1*l_qty1+l_fac2*l_qty2
                  LET g_pon2.pon07=l_ima44
                  LET g_pon2.pon20=l_tot
         WHEN '3' LET g_pon2.pon07=g_pon2.pon80
                  LET g_pon2.pon20=l_qty1
      END CASE
   ELSE
      LET g_pon2.pon07=g_pon2.pon80
      LET g_pon2.pon20=l_qty1
   END IF
   LET g_pon2.pon20=s_digqty(g_pon2.pon20,g_pon2.pon07)   #FUN-BB0085
 
   LET g_cnt = 0
   LET g_factor = 1
   CALL s_umfchk(g_pon2.pon04,g_pon2.pon07,l_ima44)
         RETURNING g_cnt,g_factor
   IF g_cnt = 1 THEN
      LET g_factor = 1
   END IF
   LET g_pon2.pon09 = g_factor
 
   IF cl_null(g_pon2.pon86) THEN
      LET g_pon2.pon86 = g_pon2.pon07
      LET g_pon2.pon87 = g_pon2.pon09
   END IF
   RETURN g_cnt
 
END FUNCTION
 
FUNCTION t580_check_inventory_qty(p_cmd)
DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
   IF NOT cl_null(g_pon[l_ac].pon07) THEN
      IF g_no = 'MISC' THEN
         LET g_pon2.pon121=1
         LET g_pon2.pon09=1
      ELSE
         CALL t580_unit(g_pon[l_ac].pon07)
         IF NOT cl_null(g_errno) THEN
            CALL cl_err(g_pon[l_ac].pon07,g_errno,0)
            LET g_pon[l_ac].pon07 = g_pon_o.pon07
            DISPLAY g_pon[l_ac].pon07 TO pon07
            RETURN 1
         ELSE
            #取採購對庫存換算率
            CALL s_umfchk(g_pon[l_ac].pon04,g_pon[l_ac].pon07,
                                  g_pon2.pon08)
                   RETURNING g_sw,g_pon2.pon09
             IF g_sw THEN       #85-09-23 by kitty
                CALL cl_err(g_pon[l_ac].pon07,'mfg7002',0)
                LET g_pon2.pon09=1
                RETURN 1
             END IF
        END IF
      END IF
   END IF
   LET g_pon2.pon07  = g_pon[l_ac].pon07
   LET g_pon_o.pon07 = g_pon[l_ac].pon07
 
   IF NOT cl_null(g_pon[l_ac].pon20) THEN
      IF g_pon[l_ac].pon20 <= 0 THEN
          CALL cl_err(g_pon[l_ac].pon20,'mfg3331',0)
          LET g_pon[l_ac].pon20 = g_pon_o.pon20
          DISPLAY g_pon[l_ac].pon20 TO pon20
          RETURN 1
      END IF
      IF (g_pon_o.pon20 IS NULL OR g_pon[l_ac].pon20 != g_pon_o.pon20 )
               AND (g_no != 'MISC') THEN
        #CALL s_sizechk(g_pon[l_ac].pon04,g_pon[l_ac].pon20,g_lang)  #CHI-C10037 mark
         CALL s_sizechk(g_pon[l_ac].pon04,g_pon[l_ac].pon20,g_lang,g_pon[l_ac].pon07) #CHI-C10037 add
                 RETURNING g_pon[l_ac].pon20
         DISPLAY g_pon[l_ac].pon20 TO pon20
 
         IF cl_null(g_pon[l_ac].pon31) OR g_pon[l_ac].pon31 = 0 THEN
            CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,g_pom.pom04,g_pon[l_ac].pon87,'',g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant)
                 RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
                           g_pmn73,g_pmn74   #TQC-AC0257 add
            CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)   #MOD-9C0285 ADD
            IF g_pon[l_ac].pon31=0 THEN
               LET g_pon[l_ac].pon31=g_pon2.pon31
               LET g_pon[l_ac].pon31t=g_pon2.pon31t
            END IF
            LET g_pon[l_ac].pon31 = cl_digcut(g_pon[l_ac].pon31,t_azi03)   #No.CHI-6A0004
            LET g_pon[l_ac].pon31t = cl_digcut(g_pon[l_ac].pon31t,t_azi03)   #No.CHI-6A0004
            DISPLAY g_pon[l_ac].pon31 TO pon31
            DISPLAY g_pon[l_ac].pon31t TO pon31t
         END IF
      END IF
      IF p_cmd ='a' OR g_pon_o.pon20 != g_pon[l_ac].pon20 THEN
         #add or 修改時,採購量不可小於已交量
         IF g_pon[l_ac].pon20 < g_pon_o.pon50 THEN
            CALL cl_err(g_pon_o.pon50,'mfg3424',1)
            RETURN 1
         END IF
         # show 已轉數量
         LET g_pon[l_ac].diff = g_pon[l_ac].pon20 - g_pon[l_ac].pon21
         DISPLAY g_pon[l_ac].diff TO diff
      END IF
   END IF
   LET g_pon2.pon20 = g_pon[l_ac].pon20
   LET g_pon_o.pon20 = g_pon[l_ac].pon20
   RETURN 0
END FUNCTION
 
FUNCTION t580_def_form()
   IF g_sma.sma115 ='N' THEN
      CALL cl_set_comp_visible("pon80,pon82,pon83,pon85",FALSE)
      CALL cl_set_comp_visible("pon07,pon20",TRUE)
   ELSE
      CALL cl_set_comp_visible("pon80,pon82,pon83,pon85",TRUE)
      CALL cl_set_comp_visible("pon07,pon20",FALSE)
   END IF
   CALL cl_set_comp_visible("pon81,pon84",FALSE)
   IF g_sma.sma116 MATCHES '[02]' THEN    #No.FUN-610076
       CALL cl_set_comp_visible("pon86,pon87",FALSE)
   END IF
   IF g_sma.sma122 ='1' THEN
      CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pon83",g_msg CLIPPED)
      CALL cl_getmsg('asm-306',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pon85",g_msg CLIPPED)
      CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pon80",g_msg CLIPPED)
      CALL cl_getmsg('asm-307',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pon82",g_msg CLIPPED)
   END IF
   IF g_sma.sma122 ='2' THEN
      CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pon83",g_msg CLIPPED)
      CALL cl_getmsg('asm-308',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pon85",g_msg CLIPPED)
      CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pon80",g_msg CLIPPED)
      CALL cl_getmsg('asm-309',g_lang) RETURNING g_msg
      CALL cl_set_comp_att_text("pon82",g_msg CLIPPED)
   END IF
   
   CALL cl_set_comp_visible("pom05",g_aza.aza08 = 'Y')  #FUN-810045 add
END FUNCTION
 
FUNCTION t584_def_form()
    IF g_sma.sma115 ='N' THEN
       CALL cl_set_comp_visible("pon83,pon80",FALSE)
       CALL cl_set_comp_att_text("pon83",' ')
       CALL cl_set_comp_att_text("pon80",' ')
       CALL cl_set_comp_visible("pon07,pon09",TRUE)
    ELSE
       CALL cl_set_comp_visible("pon07",FALSE)
       CALL cl_set_comp_visible("pon09",FALSE)
       CALL cl_set_comp_att_text("pon07",' ')
       CALL cl_set_comp_att_text("pon09",' ')
       IF g_ima906 ='1' THEN
          CALL cl_set_comp_visible("pon80",TRUE)
          CALL cl_set_comp_visible("pon83",FALSE)
          CALL cl_set_comp_att_text("pon83",' ')
       ELSE
          CALL cl_set_comp_visible("pon83",TRUE)
          CALL cl_set_comp_visible("pon80",TRUE)
       END IF
    END IF
    IF g_sma.sma122 ='1' THEN
       CALL cl_getmsg('asm-302',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pon83",g_msg CLIPPED)
       CALL cl_getmsg('asm-303',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pon80",g_msg CLIPPED)
    END IF
    IF g_sma.sma122 ='2' THEN
       CALL cl_getmsg('asm-304',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pon83",g_msg CLIPPED)
       CALL cl_getmsg('asm-305',g_lang) RETURNING g_msg
       CALL cl_set_comp_att_text("pon80",g_msg CLIPPED)
    END IF
END FUNCTION
FUNCTION t580_b_move_to()
#FUN-C30057--add--begin
#FUN-C30057--add--end--
   LET g_pon[l_ac].pon02  = g_pon2.pon02 
   LET g_pon[l_ac].pon04  = g_pon2.pon04 
   LET g_pon[l_ac].pon041 = g_pon2.pon041
   LET g_pon[l_ac].pon07  = g_pon2.pon07
   LET g_pon[l_ac].pon19  = g_pon2.pon19 
   LET g_pon[l_ac].pon20  = g_pon2.pon20 
   LET g_pon[l_ac].pon83  = g_pon2.pon83 
   LET g_pon[l_ac].pon84  = g_pon2.pon84 
   LET g_pon[l_ac].pon85  = g_pon2.pon85 
   LET g_pon[l_ac].pon80  = g_pon2.pon80 
   LET g_pon[l_ac].pon81  = g_pon2.pon81 
   LET g_pon[l_ac].pon82  = g_pon2.pon82 
   LET g_pon[l_ac].pon86  = g_pon2.pon86 
   LET g_pon[l_ac].pon87  = g_pon2.pon87 
   LET g_pon[l_ac].pon21  = g_pon2.pon21 
   LET g_pon[l_ac].pon31  = g_pon2.pon31 
   LET g_pon[l_ac].pon31t = g_pon2.pon31t
   LET g_pon[l_ac].pon06  = g_pon2.pon06
#&ifdef SLK                                                            #No.FUN-C30057
#   LET g_pon[l_ac].ponislk01 = g_poni.ponislk01 #No.FUN-810017        #No.FUN-C30057
#&endif                                                                #No.FUN-C30057
   LET g_pon[l_ac].ponud01 = g_pon2.ponud01
   LET g_pon[l_ac].ponud02 = g_pon2.ponud02
   LET g_pon[l_ac].ponud03 = g_pon2.ponud03
   LET g_pon[l_ac].ponud04 = g_pon2.ponud04
   LET g_pon[l_ac].ponud05 = g_pon2.ponud05
   LET g_pon[l_ac].ponud06 = g_pon2.ponud06
   LET g_pon[l_ac].ponud07 = g_pon2.ponud07
   LET g_pon[l_ac].ponud08 = g_pon2.ponud08
   LET g_pon[l_ac].ponud09 = g_pon2.ponud09
   LET g_pon[l_ac].ponud10 = g_pon2.ponud10
   LET g_pon[l_ac].ponud11 = g_pon2.ponud11
   LET g_pon[l_ac].ponud12 = g_pon2.ponud12
   LET g_pon[l_ac].ponud13 = g_pon2.ponud13
   LET g_pon[l_ac].ponud14 = g_pon2.ponud14
   LET g_pon[l_ac].ponud15 = g_pon2.ponud15
   LET g_pon[l_ac].pon19 = g_pon2.pon19     #NO.FUN-A80001
#FUN-C30057 add &endif
END FUNCTION
 
FUNCTION t580_b_move_back()
#FUN-C30057--add--begin--
#FUN-C30057--add--end--
   LET g_pon2.pon02  = g_pon[l_ac].pon02  
   LET g_pon2.pon04  = g_pon[l_ac].pon04
   LET g_pon2.pon06  = g_pon[l_ac].pon06  
   LET g_pon2.pon041 = g_pon[l_ac].pon041 
   LET g_pon2.pon07  = g_pon[l_ac].pon07  
   LET g_pon2.pon19  = g_pon[l_ac].pon19 
   LET g_pon2.pon20  = g_pon[l_ac].pon20  
   LET g_pon2.pon83  = g_pon[l_ac].pon83  
   LET g_pon2.pon84  = g_pon[l_ac].pon84  
   LET g_pon2.pon85  = g_pon[l_ac].pon85  
   LET g_pon2.pon80  = g_pon[l_ac].pon80  
   LET g_pon2.pon81  = g_pon[l_ac].pon81  
   LET g_pon2.pon82  = g_pon[l_ac].pon82  
   LET g_pon2.pon86  = g_pon[l_ac].pon86  
   LET g_pon2.pon87  = g_pon[l_ac].pon87  
   LET g_pon2.pon21  = g_pon[l_ac].pon21  
   LET g_pon2.pon31  = g_pon[l_ac].pon31  
   LET g_pon2.pon31t = g_pon[l_ac].pon31t 
   LET g_pon2.pon06  = g_pon[l_ac].pon06
#&ifdef SLK                                                        #No.FUN-C30057
#   LET g_poni.ponislk01 = g_pon[l_ac].ponislk01 #No.FUN-810017    #No.FUN-C30057
#&endif                                                            #No.FUN-C30057
   
   IF cl_null(g_pon2.pon20) THEN LET g_pon2.pon20 = 0 END IF
   IF cl_null(g_pon2.pon31) THEN LET g_pon2.pon31 = 0 END IF
   IF cl_null(g_pon2.pon50) THEN LET g_pon2.pon50 = 0 END IF
   IF cl_null(g_pon2.pon51) THEN LET g_pon2.pon51 = 0 END IF
   IF cl_null(g_pon2.pon53) THEN LET g_pon2.pon53 = 0 END IF
   IF cl_null(g_pon2.pon55) THEN LET g_pon2.pon55 = 0 END IF
   IF cl_null(g_pon2.pon57) THEN LET g_pon2.pon57 = 0 END IF
   IF cl_null(g_pon2.pon62) THEN LET g_pon2.pon62 = 1 END IF
   
   IF cl_null(g_pon2.pon61) THEN
      LET g_pon2.pon61=' '
   END IF
   LET g_pon2.ponud01 = g_pon[l_ac].ponud01
   LET g_pon2.ponud02 = g_pon[l_ac].ponud02
   LET g_pon2.ponud03 = g_pon[l_ac].ponud03
   LET g_pon2.ponud04 = g_pon[l_ac].ponud04
   LET g_pon2.ponud05 = g_pon[l_ac].ponud05
   LET g_pon2.ponud06 = g_pon[l_ac].ponud06
   LET g_pon2.ponud07 = g_pon[l_ac].ponud07
   LET g_pon2.ponud08 = g_pon[l_ac].ponud08
   LET g_pon2.ponud09 = g_pon[l_ac].ponud09
   LET g_pon2.ponud10 = g_pon[l_ac].ponud10
   LET g_pon2.ponud11 = g_pon[l_ac].ponud11
   LET g_pon2.ponud12 = g_pon[l_ac].ponud12
   LET g_pon2.ponud13 = g_pon[l_ac].ponud13
   LET g_pon2.ponud14 = g_pon[l_ac].ponud14
   LET g_pon2.ponud15 = g_pon[l_ac].ponud15
   LET g_pon2.pon19 = g_pon[l_ac].pon19    #NO.FUN-A80001
END FUNCTION

FUNCTION t580_price_check(p_pon31,p_pon31t)
   DEFINE p_pon31    LIKE   pon_file.pon31
   DEFINE p_pon31t   LIKE   pon_file.pon31t
   DEFINE l_pom41    LIKE   pom_file.pom41
   DEFINE l_pnz04    LIKE   pnz_file.pnz04
   DEFINE l_pnz07    LIKE   pnz_file.pnz07  #FUN-B70121 add

   IF cl_null(g_pom.pom41) THEN
   	  SELECT pmc49 INTO l_pom41 FROM pmc_file
   	   WHERE pmc01 = g_pom.pom09
      IF SQLCA.sqlcode THEN 
      	 CALL cl_err( 'sel pmc49' , SQLCA.sqlcode,0)
      	 RETURN
      END IF	  
   ELSE 
      LET l_pom41 = g_pom.pom41	   
   END IF

   IF NOT cl_null(l_pom41) THEN
      SELECT pnz04,pnz07 INTO l_pnz04,l_pnz07 FROM pnz_file  #FUN-B70121 add pnz07
       WHERE pnz01 = l_pom41
      IF SQLCA.sqlcode THEN 
         CALL cl_err( 'sel pnz04' , SQLCA.sqlcode,0)
         RETURN
      END IF	   	   
   END IF 
  #FUN-B70121 mod
  #IF l_pnz04 = 'Y'  THEN 
  #   IF g_gec07 = 'Y' THEN
  #      CALL cl_set_comp_entry("pon31",FALSE)  
  #      IF p_pon31t = 0 OR cl_null(p_pon31t) THEN 
  #         CALL cl_set_comp_entry("pon31t",TRUE) 
  #      ELSE 
  #         CALL cl_set_comp_entry("pon31t",FALSE)  	 
  #      END IF
  #   ELSE
  #      CALL cl_set_comp_entry("pon31t",FALSE)  
  #	     IF p_pon31 = 0 OR cl_null(p_pon31) THEN 
  #         CALL cl_set_comp_entry("pon31",TRUE)
  #      ELSE 
  #         CALL cl_set_comp_entry("pon31",FALSE)     
  #      END IF       	     	   	  		  
  #   END IF
  #ELSE
  #   CALL cl_set_comp_entry("pon31",FALSE)  
  #   CALL cl_set_comp_entry("pon31t",FALSE) 
  #END IF

   #FUN-BC0088 ----- add start -----
   IF g_pon[l_ac].pon04[1,4] = 'MISC' THEN
      IF g_gec07 = 'Y' THEN   #含税
         CALL cl_set_comp_entry("pon31",FALSE)
         CALL cl_set_comp_entry("pon31t",TRUE)
      ELSE
         CALL cl_set_comp_entry("pon31",TRUE)
         CALL cl_set_comp_entry("pon31t",FALSE)
      END IF
      RETURN
   END IF
   #FUN-BC0088 ----- add end -----

   IF g_gec07 = 'Y' THEN   #含税
      IF p_pon31t = 0 OR cl_null(p_pon31t) THEN
         #未取到含税单价
         IF l_pnz04 = 'Y' THEN #未取到单价可人工输入
            CALL cl_set_comp_entry("pon31",FALSE)
            CALL cl_set_comp_entry("pon31t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pon31",FALSE)
            CALL cl_set_comp_entry("pon31t",FALSE)
         END IF
      ELSE
         #有取到含税单价
         IF l_pnz07 = 'Y' THEN   #取到价格可修改
            CALL cl_set_comp_entry("pon31",FALSE)
            CALL cl_set_comp_entry("pon31t",TRUE)
         ELSE
            CALL cl_set_comp_entry("pon31",FALSE)
            CALL cl_set_comp_entry("pon31t",FALSE)
         END IF
      END IF
   ELSE                    #不含税
      IF p_pon31 = 0 OR cl_null(p_pon31) THEN
         #未取到税前单价
         IF l_pnz04 = 'Y' THEN   #未取到单价可人工输入
            CALL cl_set_comp_entry("pon31",TRUE)
            CALL cl_set_comp_entry("pon31t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pon31",FALSE)
            CALL cl_set_comp_entry("pon31t",FALSE)
         END IF
      ELSE
         #有取到税前单价
         IF l_pnz07 = 'Y' THEN   #取到价格可修改
            CALL cl_set_comp_entry("pon31",TRUE)
            CALL cl_set_comp_entry("pon31t",FALSE)
         ELSE
            CALL cl_set_comp_entry("pon31",FALSE)
            CALL cl_set_comp_entry("pon31t",FALSE)
         END IF
      END IF
   END IF
  #FUN-B70121 mod--end

END FUNCTION  
#FUN-BB0085-add-str----------------------
FUNCTION t580_pon20_check(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1

   IF NOT cl_null(g_pon[l_ac].pon07) AND NOT cl_null(g_pon[l_ac].pon20) THEN 
      IF cl_null(g_pon07_t) OR cl_null(g_pon_t.pon20) OR g_pon07_t != g_pon[l_ac].pon07 OR g_pon_t.pon20 !=g_pon[l_ac].pon20 THEN  
         LET g_pon[l_ac].pon20 = s_digqty(g_pon[l_ac].pon20,g_pon[l_ac].pon07)
         DISPLAY BY NAME g_pon[l_ac].pon20
      END IF
   END IF

   IF NOT cl_null(g_pon[l_ac].pon20) THEN
       IF g_pon[l_ac].pon20 <= 0 THEN
           CALL cl_err(g_pon[l_ac].pon20,'mfg3331',0)
           LET g_pon[l_ac].pon20 = g_pon_o.pon20
           DISPLAY g_pon[l_ac].pon20 TO pon20
           RETURN FALSE
       END IF
       IF (g_pon_o.pon20 IS NULL OR g_pon[l_ac].pon20 != g_pon_o.pon20 )
                AND (g_no != 'MISC') THEN
         #CALL s_sizechk(g_pon[l_ac].pon04,g_pon[l_ac].pon20,g_lang) #CHI-C10037 mark
          CALL s_sizechk(g_pon[l_ac].pon04,g_pon[l_ac].pon20,g_lang,g_pon[l_ac].pon07) #CHI-C10037 add
                  RETURNING g_pon[l_ac].pon20
          DISPLAY g_pon[l_ac].pon20 TO pon20

       END IF
       IF p_cmd ='a' OR g_pon_o.pon20 != g_pon[l_ac].pon20 THEN
          #add or 修改時,採購量不可小於已交量
          IF g_pon[l_ac].pon20 < g_pon_o.pon50 THEN
             CALL cl_err(g_pon_o.pon50,'mfg3424',1)
             RETURN FALSE
          END IF
          # show 已轉數量
          LET g_pon[l_ac].diff = g_pon[l_ac].pon20 - g_pon[l_ac].pon21
          DISPLAY g_pon[l_ac].diff TO diff
       END IF
   END IF
   LET g_pon2.pon20 = g_pon[l_ac].pon20
   LET g_pon_o.pon20 = g_pon[l_ac].pon20
   DISPLAY BY NAME g_pon[l_ac].pon20
   IF cl_null(g_pon[l_ac].pon86) THEN
      LET g_pon[l_ac].pon86 = g_pon[l_ac].pon07
      LET g_pon[l_ac].pon87 = g_pon[l_ac].pon20
      DISPLAY BY NAME g_pon[l_ac].pon86
      DISPLAY BY NAME g_pon[l_ac].pon87
   END IF
   IF g_pon[l_ac].pon87 = 0 OR
         (g_pon_t.pon20 <> g_pon[l_ac].pon20 OR
          g_pon_t.pon86 <> g_pon[l_ac].pon86) THEN
      CALL t580_set_pon87()
      LET g_pon2.pon87 = g_pon[l_ac].pon87
      LET g_pon_o.pon87 = g_pon[l_ac].pon87
   END IF
   IF cl_null(g_pon[l_ac].pon31) OR g_pon[l_ac].pon31 = 0 THEN
      CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,g_pom.pom04,g_pon[l_ac].pon87,'',
                          g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant)
         RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
                   g_pmn73,g_pmn74   #TQC-AC0257 add
      CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)
      IF g_pon[l_ac].pon31=0 THEN
         LET g_pon[l_ac].pon31=g_pon2.pon31
         LET g_pon[l_ac].pon31t=g_pon2.pon31t
      END IF
      LET g_pon[l_ac].pon31 = cl_digcut(g_pon[l_ac].pon31,t_azi03)
      LET g_pon[l_ac].pon31t = cl_digcut(g_pon[l_ac].pon31t,t_azi03)
      DISPLAY g_pon[l_ac].pon31 TO pon31
      DISPLAY g_pon[l_ac].pon31t TO pon31t
   END IF
   IF g_pon[l_ac].pon20 <> g_pon_t.pon20 THEN
      CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,g_pom.pom04,g_pon[l_ac].pon87,'',
                          g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant)
             RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
                       g_pmn73,g_pmn74   #TQC-AC0257 add
       CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)
   END IF
   RETURN TRUE
END FUNCTION

FUNCTION t580_pon82_check(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1

   IF NOT cl_null(g_pon[l_ac].pon80) AND NOT cl_null(g_pon[l_ac].pon82) THEN
      IF cl_null(g_pon80_t) OR cl_null(g_pon_t.pon82) OR g_pon80_t!=g_pon[l_ac].pon80 OR g_pon_t.pon82!=g_pon[l_ac].pon82 THEN
         LET g_pon[l_ac].pon82 = s_digqty(g_pon[l_ac].pon82,g_pon[l_ac].pon80)
         DISPLAY BY NAME g_pon[l_ac].pon82
      END IF
   END IF

   IF NOT cl_null(g_pon[l_ac].pon82) THEN
      IF g_pon[l_ac].pon82 < 0 THEN
         CALL cl_err('','aim-391',0) 
         RETURN 'pon82'
      END IF
      LET g_pon2.pon82  = g_pon[l_ac].pon82
      LET g_pon_o.pon82 = g_pon[l_ac].pon82
   END IF
   #計算pon20,pon07的值,檢查數量的合理性
    CALL t580_set_origin_field()
    CALL t580_check_inventory_qty(p_cmd)
        RETURNING g_flag
    IF g_flag = '1' THEN
       IF g_ima906 = '3' OR g_ima906 = '2' THEN
          RETURN 'pon85'
       ELSE
          RETURN 'pon82'
       END IF
    END IF
    IF cl_null(g_pon[l_ac].pon86) THEN
       LET g_pon[l_ac].pon87 = 0
    ELSE
       IF p_cmd = 'a' OR  p_cmd = 'u' AND
          (g_pon_t.pon81 <> g_pon[l_ac].pon81 OR
           g_pon_t.pon82 <> g_pon[l_ac].pon82 OR
           g_pon_t.pon84 <> g_pon[l_ac].pon84 OR
           g_pon_t.pon85 <> g_pon[l_ac].pon85 OR
           g_pon_t.pon86 <> g_pon[l_ac].pon86) THEN
           CALL t580_set_pon87()
       END IF
    END IF
    CALL cl_show_fld_cont()
    RETURN NULL
END FUNCTION

FUNCTION t580_pon85_check(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1

   IF NOT cl_null(g_pon[l_ac].pon83) AND NOT cl_null(g_pon[l_ac].pon85) THEN
      IF cl_null(g_pon83_t) OR cl_null(g_pon_t.pon85) OR g_pon83_t!=g_pon[l_ac].pon83 OR g_pon_t.pon85!=g_pon[l_ac].pon85 THEN
         LET g_pon[l_ac].pon85 = s_digqty(g_pon[l_ac].pon85,g_pon[l_ac].pon83)
         DISPLAY BY NAME g_pon[l_ac].pon85
      END IF
   END IF

   IF NOT cl_null(g_pon[l_ac].pon85) THEN
      IF g_pon[l_ac].pon85 < 0 THEN
         CALL cl_err('','aim-391',0)
         RETURN FALSE
      END IF
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         g_pon_t.pon85 <> g_pon[l_ac].pon85 THEN
         IF g_ima906='3' THEN
            LET g_tot=g_pon[l_ac].pon85*g_pon[l_ac].pon84
            IF cl_null(g_pon[l_ac].pon82) OR g_pon[l_ac].pon82=0 THEN #CHI-960022
               LET g_pon[l_ac].pon82=g_tot*g_pon[l_ac].pon81
               LET g_pon2.pon82  = g_pon[l_ac].pon82
               LET g_pon_o.pon82 = g_pon[l_ac].pon82
               DISPLAY BY NAME g_pon[l_ac].pon82                      #CHI-960022
            END IF                                                    #CHI-960022
         END IF
      END IF
      LET g_pon2.pon85  = g_pon[l_ac].pon85
      LET g_pon_o.pon85 = g_pon[l_ac].pon85
   END IF
   IF cl_null(g_pon[l_ac].pon86) THEN
      LET g_pon[l_ac].pon87 = 0
   ELSE
      IF p_cmd = 'a' OR  p_cmd = 'u' AND
         (g_pon_t.pon81 <> g_pon[l_ac].pon81 OR
          g_pon_t.pon82 <> g_pon[l_ac].pon82 OR
          g_pon_t.pon84 <> g_pon[l_ac].pon84 OR
          g_pon_t.pon85 <> g_pon[l_ac].pon85 OR
          g_pon_t.pon86 <> g_pon[l_ac].pon86) THEN
          CALL t580_set_pon87()
      END IF
   END IF
   CALL cl_show_fld_cont()
   RETURN TRUE
END FUNCTION

FUNCTION t580_pon87_check(p_cmd)
DEFINE p_cmd     LIKE type_file.chr1

   IF NOT cl_null(g_pon[l_ac].pon86) AND NOT cl_null(g_pon[l_ac].pon87) THEN 
      IF cl_null(g_pon86_t) OR cl_null(g_pon_t.pon87) OR g_pon86_t!=g_pon[l_ac].pon86 OR g_pon_t.pon87!=g_pon[l_ac].pon87 THEN 
         LET g_pon[l_ac].pon87 = s_digqty(g_pon[l_ac].pon87,g_pon[l_ac].pon86)
         DISPLAY BY NAME g_pon[l_ac].pon87
      END IF
   END IF 

   IF NOT cl_null(g_pon[l_ac].pon87) THEN
      IF g_pon[l_ac].pon87 < 0 THEN
         CALL cl_err('','aim-391',0) 
         RETURN FALSE
      END IF
     IF cl_null(g_pon[l_ac].pon31) OR g_pon[l_ac].pon31 = 0 THEN
           CALL s_defprice_new(g_pon[l_ac].pon04,g_pom.pom09,g_pom.pom22,g_pom.pom04,g_pon[l_ac].pon87,'',
                               g_pom.pom21,g_pom.pom43,'1',g_pon[l_ac].pon86,'',g_pom.pom41,g_pom.pom20,g_plant)
           RETURNING g_pon[l_ac].pon31,g_pon[l_ac].pon31t,
                     g_pmn73,g_pmn74
        CALL t580_price_check(g_pon[l_ac].pon31,g_pon[l_ac].pon31t)
        IF g_pon[l_ac].pon31=0 THEN
           LET g_pon[l_ac].pon31=g_pon2.pon31
           LET g_pon[l_ac].pon31t=g_pon2.pon31t
        END IF
        LET g_pon[l_ac].pon31 = cl_digcut(g_pon[l_ac].pon31,t_azi03)
        LET g_pon[l_ac].pon31t = cl_digcut(g_pon[l_ac].pon31t,t_azi03)
        DISPLAY g_pon[l_ac].pon31 TO pon31
        DISPLAY g_pon[l_ac].pon31t TO pon31t
     END IF
   END IF
   RETURN TRUE
END FUNCTION
#FUN-BB0085-add-end------------------------------
#No:FUN-9C0071--------精簡程式-----
   
   
   


# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# pattern name...: apmp840.4gl
# Descriptions...: 代採購三角貿易倉退單拋轉作業(正拋)
# Date & Author..: 01/11/16 By Tommy
# Modify ........: No.7709 03/08/06 Kammy 倉退不用判斷庫存不足
# Modify.........: No.7902 03/08/23 Kammy 幣別取位應用原幣幣別而非用各站的本幣
# Modify.........: No.8128 03/09/06 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.倉庫別帶流程代碼的 
# Modify.........: No.FUN-4C0011 04/12/01 By Mandy 單價金額位數改為dec(20,6)
# Modify.........: No.FUN-550060 05/05/30 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/06/29 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: NO.MOD-610117 06/01/24 By Pengu Line:840的地方CLOSE oeb_c1,應調整為CLOSE rvb_c1
# Modify.........: NO.FUN-620025 06/02/14 By day 流通版多角貿易修改
# Modify.........: NO.FUN-640167 06/04/18 BY yiting 出貨或入庫扣帳拋單時，中間廠都會詢問"這是新的倉儲批，是否新增? -->不用問，直接產生 
# Modify.........: No.FUN-660129 06/06/19 By ray cl_err --> cl_err3
# Modify.........: NO.MOD-650005 06/06/22 By Mandy 產生銷退時CALL p840_ohbins(i),銷退的單價目前取訂單,應取出貨單
# Modify.........: No.MOD-660122 06/06/30 By Rayven 當ima25與img09的單位一樣時，imgg21及imgg211所存的轉換率，也應該要一樣
# Modify.........: No.MOD-680058 06/08/18 By day 增加對ohb1005的預設
# Modify.........: NO.FUN-670007 06/09/04 BY yiting 1.判斷是否有中斷營運中心，如有，所設定營運中心之後不拋
#                                                   2.依站別抓取單別及倉庫資料
# Modify.........: No.FUN-680136 06/09/07 By Jackho 欄位類型修改
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼occ1004
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: NO.TQC-690057 06/11/15 BY Claire img_file值要取自imd_file
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: NO.TQC-6A0084 06/12/05 By Nicola 含稅金額、未稅金額調整
# Modify.........: No.MOD-690156 06/12/14 By Mandy add l_aza.aza50='Y'的判斷
# Modify.........: NO.MOD-6C0086 06/12/14 BY Claire 語法調整
# Modify.........: No.FUN-710030 07/01/23 By johnray 錯誤訊息匯總顯示修改
# Modify.........: NO.CHI-710059 07/02/02 BY jamie ogb14應為ogb917*ogb13
# Modify.........: NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.........: No.CHI-770019 07/07/25 By Carrier 多單位:參考單位時,交易單位不寫入tlff
# Modify.........: NO.CHI-760003 07/08/14 BY wujie  當sma115='Y'時才需判斷ima906 
# Modify.........: NO.MOD-780191 07/08/29 BY yiting 拋轉時需檢核單別設定資料是否齊全
# Modify.........: No.MOD-780264 07/08/31 By Claire 未回寫呆滯日期 
# Modify.........: NO.TQC-790003 07/09/03 BY yiting insert into前給予預設值
# Modify.........: NO.TQC-790117 07/09/21 BY yiting 二站時會發生拋轉錯誤
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.MOD-7B0182 07/11/21 By Claire 倉退產生的銷退單, 出貨單號要給值
# Modify.........: No.TQC-7B0083 07/11/23 By Carrier rvv88給default值
# Modify.........: No.TQC-7C0064 07/12/08 By Beryl   判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.........: NO.TQC-810029 08/01/09 BY yiting 有最終供應商時，最後一站產生的倉退單單別抓不到 
# Modify.........: No.MOD-820060 08/02/14 By Claire rvv87已於計算前給值
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-830002 08/03/18 By claire 原單頭的來源廠商(poz04:已不使用)改於單身第0站的上游廠商(poy03)
# Modify.........: No.FUN-830035 08/03/18 By Claire 倉退併單
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-870123 08/07/11 By claire 有最終供應商時,要清除殘值收貨/入庫單號
# Modify.........: No.MOD-880099 08/08/15 By claire 拋轉各站時,品名規格應不需重新抓取,以原始倉退單的品名為主
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-920265 09/02/20 By claire rvv930,ohb930應來源單號的值
# Modify.........: No.FUN-930104 09/03/23 By dxfwo   理由碼的分類改善
# Modify.........: No.MOD-940067 09/04/07 By chenyu poz04現在系統中沒有使用，給tlf19賦值時用oha04
# Modify.........: No.MOD-950136 09/05/13 By wujie  入庫單插入tlf19時，直接取rvu04的值。使tlf和入庫單一致。
# Modify.........: No.TQC-950010 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-940083 09/05/18 By zhaijie 調整批處理賦值
# Modify.........: No.CHI-960041 09/06/15 By Dido 轉換率抓取問題
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980081 09/08/21 By destiny 修改傳到s_mupimg里的參數
# Modify.........: No.TQC-980229 09/08/24 By sherry "倉退單號"欄位需要可以開窗選擇           
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980059 09/09/09 By arman GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/17 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-950020 09/10/06 By chenmoyan 將自定義欄位的值拋轉各站
# Modify.........: No.CHI-9B0008 09/11/11 By Dido 增加拋轉 tlf930
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No.TQC-A10060 10/01/11 By wuxj   修改INSERT INTO加入oriu及orig這2個欄位 
# Modify.........: No:FUN-9C0071 10/01/14 By huangrh 精簡程式
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No.FUN-A50102 10/07/21 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-AB0122 10/11/16 By Smapmin 倉退單價來源應為收貨單
# Modify.........: No.FUN-AB0061 10/11/17 By chenying 銷退單加基礎單價字段ohb37
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AA0023 10/11/24 By lixia 將apmp840拆開成apmp840及sapmp840

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_argv1         LIKE oga_file.oga01
DEFINE g_change_lang   LIKE type_file.chr1

MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)                       
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   
   CALL p840(g_argv1,g_plant,FALSE) #FUN-AA0023
   
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
   
END MAIN


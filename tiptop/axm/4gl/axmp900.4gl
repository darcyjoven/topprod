# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmp900.4gl
# Descriptions...: 三角貿易出貨單拋轉作業(反向)
# Date & Author..: 99/11/09 By Kammy
# Note...........: 由 axmp820 改寫
# Modify ........: No.+196 010612 by linda mod 各廠若料件主檔之主要倉庫有值,
#                  則以ima為主,ima35 is null 才以目的廠之倉庫給值
# Modify.........: No.7742 03/08/07 By Kammy 1.備品資料不回寫訂單已出貨量
#                                            2.若為備品資料金額單價皆為零
# Modify.........: No.8047 03/09/03 By Kammy 1.銷售逆拋、採購逆拋合併
#                                            2.請注意：採購逆拋來源廠不拋出貨單
#                                            3.新版多角貿易出貨單扣帳動作在
#                                              axmt820 所以取消 axmp902
# Modify.........: No.9059 04/01/27 Kammy 代採買 call s_mupimg 應判斷為 i = 0
#                                         而非 i = 1
# Modify.........: No.9337 04/03/12 Melody line#977寫錯了,應該是 LET l_ogb.ogb09
# Modify.........: No.9508 04/05/05 ching  取得多角貿易匯率程式段，移至_p2()
# Modify.........: No.9565 04/05/14 ching  "WHERE oga30 = ? "改應改為 oga01 = ?
# Modify.........: No.MOD-4B0148 04/11/15 ching tlf11,tlf12 單位錯誤
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-4C0064 04/12/17 By Carol 1.第一站的入庫量未回寫 , 因為 採用 l_ogb31 ,l_ogb32 但是第一站應該不會有 l_ogb 的資料 建議採用 l_rvv
# Modify.........: No.MOD-4C0070 04/12/17 By Carol 採逆出貨單拋轉產生之收貨單,其採購己交量錯誤
# Modify.........: No.MOD-520099 05/03/03 By ching 出通單更新錯誤處理
# Modify.........: No.MOD-530592 05/04/27 By kim 若為新倉/儲/批 新增詢問改confirm
# Modify.........: No.FUN-550070 05/05/26 By Will 單據編號放大
# Modify.........: NO.FUN-560043 05/07/06 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: No.MOD-570191 05/08/03 By Nicola SQL語法修改
# Modify.........: No.MOD-580202 05/08/17 By Smapmin 自動編號未給性質
# Modify.........: No.FUN-5A0155 05/10/24 By Sarah p900_ogains()寫入出貨單單頭檔(oga_file)單前,CALL p900_chk99()檢查序號是否重複
# Modify.........: No.MOD-5B0317 05/12/05 By Nicola oea161,162,163預設值設定
# Modify.........: No.MOD-5B0320 05/12/05 By Nicola ofa32 建議重新抓取各站的訂單oea32來 default，不要直接用來源站的ofa32
# Modify.........: No.MOD-5B0326 05/12/20 By Nicola 若一張出通單分批出貨時,在第一次拋轉時DS-4應產生一張出通單,此出通單內容同DS-6
# Modify.........: No.FUN-620029 06/02/11 By Carrier 將axmp900拆開成axmp900及saxmp900
# Modify.........: NO.MOD-640189 06/04/09 BY yiting DS3多角出貨單axmt820(多角序號S001    -06040001)扣帳拋單至各廠時，DS2及DS1的多角收貨單及多角入庫單皆產生不出來，但tlf_file有產生成功!
 
# Modify.........: No.FUN-680137 06/09/08 By ice 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-710046 07/01/24 BY yjkhero 錯誤訊息匯整
# Modify...........No.FUN-8A0086 08/10/20 By lutingting如果是沒有let g_success == 'Y' 就寫給g_success 賦初始值，不
#                                                      然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-620029  --Begin
DEFINE g_argv1        LIKE oga_file.oga01
DEFINE g_argv2        LIKE oga_file.oga09
 
MAIN
   OPTIONS                                 #改變一些系統預設值
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
 
   LET g_argv1 = ARG_VAL(1)
   LET g_argv2 = ARG_VAL(2)
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
   LET g_success = 'Y'             #No.FUN-8A0086 
   CALL s_showmsg_init()          #NO.FUN-710046  
   CALL p900(g_argv1,g_argv2)
   CALL s_showmsg()               #NO.FUN-710046
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
END MAIN
#No.FUN-620029  --End

# Prog. Version..: '5.30.06-13.04.17(00006)'     #
#
# Pattern name...: axmp901.4gl
# Descriptions...: 三角貿易出貨單拋轉還原作業(逆拋時使用)
# Date & Author..: 98/12/14 By Linda
# Modify ........: 00/02/25 By Kammy 由 axmp901 改寫
# Modify.........: No.8047 03/09/03 By Kammy 1.銷售逆拋、採購逆拋合併
#                                            2.請注意：採購逆拋來源廠不拋出貨單
# Modify.........: No.9059 04/01/27 Kammy 代採買 call s_mupimg 應判斷為 i = 0
#                                         而且 i = 1
# Modify.........: No.MOD-4B0148 04/11/15 ching tlf11,tlf12 單位錯誤
# Modify.........: No.MOD-520099 05/03/03 By ching 出通單更新錯誤處理
# Modify.........: No.MOD-5C0147 05/12/28 By Nicola l_slip改抓ofa01
# Modify.........: No.TQC-5C0131 05/12/29 By Nicola 抓取l_slip時，多加一個條件
# Modify.........: No.FUN-620029 06/02/11 By Carrier 將axmp901拆開成axmp901及saxmp901
# Modify.........: No.MOD-660081 06/06/20 By Pengu 在第139,249行錯誤訊息有誤
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE 
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: No.TQC-710053 07/01/23 By Smapmin 接收單號及類別二參數
# Modify.........: No.FUN-710046 07/01/22 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-8A0086 08/10/17 By lutingting如果是沒有let g_success == 'Y' 就寫給g_success 賦初始值，
#                                                      不然如果一次失敗，以后都無法成功
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-BC0062 12/02/15 By lilingyu 當成本計算方式czz28選擇了'6.移動加權平均成本'時,批次類作業不可運行
# Modify.........: NO:TQC-D30066 12/03/26 By lixh1 其他作業串接時更改提示信息apm-936
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#No.FUN-620029  --Begin
DEFINE g_argv1     LIKE oga_file.oga01
DEFINE g_argv2     LIKE oga_file.oga09
DEFINE g_change_lang  LIKE type_file.chr1          #FUN-570155  #No.FUN-680137  VARCHAR(1)
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
    LET g_argv1 = ARG_VAL(1)   #TQC-710053
    LET g_argv2 = ARG_VAL(2)   #TQC-710053
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF

#TQC-D30066 ------Begin--------
   SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'
   IF g_ccz.ccz28  = '6' AND NOT cl_null(g_argv1) THEN
      CALL cl_err('','apm-936',1)
      EXIT PROGRAM
   END IF
#TQC-D30066 ------End----------

#FUN-BC0062 --begin--
#  SELECT * INTO g_ccz.* FROM ccz_file WHERE ccz00='0'   #TQC-D30066
   IF g_ccz.ccz28  = '6' THEN
      CALL cl_err('','apm-937',1)
      EXIT PROGRAM
   END IF
#FUN-BC0062 --end--
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("AXM")) THEN
       EXIT PROGRAM
    END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
    LET g_success = 'Y'              #No.FUN-8A0086
    CALL s_showmsg_init()            #NO.FUN-710046   
    CALL p901(g_argv1,g_argv2)
    CALL s_showmsg()                 #NO.FUN-710046 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
#No.FUN-620029  --End
 

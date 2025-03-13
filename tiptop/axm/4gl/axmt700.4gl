# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt700.4gl
# Descriptions...: 銷退單維護作業
# Modify.........: No.TQC-660096 06/06/22 By saki 流程訊息通知功能
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710074 07/01/30 By kim GP3.6行業別架構
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-840012 08/10/08 By kim mBarcode 功能修改
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30012 11/03/09 By baogc MARK掉可發贈品按鈕部份,退贈品的時候直接打銷退單
# Modify.........: No.FUN-B70061 11/07/21 By jason axmt700.4gl-> axmt700.src.4gl
# Modify.........: No:FUN-B70087 11/07/21 By zhangll 增加oah07控管，s_unitprice_entry增加传参
# Modify.........: No:FUN-B90103 11/10/11 By xjll   增加服飾二維應用  
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt700.global" #FUN-730018
GLOBALS "../4gl/s_slk.global"    #FUN-B90103 add  
 
#FUN-B70087 為過單
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
MAIN
DEFINE
#       l_time    LIKE type_file.chr8            #No.FUN-6A0094
    p_row,p_col   LIKE type_file.num5          #No.FUN-680137 SMALLINT
    IF FGL_GETENV("FGLGUI") <> "0" THEN   #No.FUN-840012
#FUN-B90103--add
#由於新增服飾頁簽故調整下程序
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
#FUN-B90103--add
    END IF
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)     #No.TQC-660096
   LET g_argv2 = ARG_VAL(2)     #No.TQC-660096

#No.FUN-B70061
#FUN-B90103--start--
#FUN-B90103--end-- 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
   LET p_row = 2 LET p_col = 2
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN #No.FUN-840012
#FUN-B90103--start--
#FUN-B90103--end--
      OPEN WINDOW t700_w AT p_row,p_col WITH FORM "axm/42f/axmt700"
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#FUN-B90103 add 
      CALL cl_ui_init()
   END IF
   CALL t700('1',g_argv1,g_argv2) #FUN-840012 
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN #No.FUN-840012
      CLOSE WINDOW t700_w                 #結束畫面
   END IF
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
END MAIN
 
###FUN-B30012 ADD 在saxmt700做的修改

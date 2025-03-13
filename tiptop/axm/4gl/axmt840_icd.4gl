# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: axmt840.4gl
# Descriptions...: 三角貿易銷退單維護作業(多工廠)
# Modify.........: FUN-610062 06/02/21 By yoyo增加代送銷退 
# Modify.........: TQC-660096 06/06/22 By saki 流程訊息通知功能
# Modify.........: FUN-650108 06/06/25 By yoyo 一般銷退和流通分銷的合并
# Modify.........: NO.FUN-670007 06/07/27 by Yiting oaz32->oax01
# Modify.........: No.FUN-680137 06/09/11 By bnlent  欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/02 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710074 07/01/30 By kim GP3.6行業別架構
# Modify.........: No.FUN-730018 07/03/28 By kim 行業別架構
# Modify.........: No.FUN-840012 08/10/08 By kim mBarcode 功能修改
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B90012 11/08/22 By xianghui axmt840.4gl-->axmt840.src.4gl
# Modify.........: No.MOD-C80078 12/09/17 By jt_chen 單頭單身的串查請一併調整,需考慮行業別
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/saxmt700.global" #FUN-730018
 
#主程式開始
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
MAIN
DEFINE
#    l_time        LIKE type_file.chr8,                   #計算被使用時間  #No.FUN-680137 VARCHAR(8) #NO.FUN-6A0094
    p_row,p_col   LIKE type_file.num5    #No.FUN-680137 SMALLINT
    
    IF FGL_GETENV("FGLGUI") <> "0" THEN #FUN-840012
       OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM                   #整個畫面欄位輸入會依照p_per所設定的順序(忽略4gl寫的順序)  #FUN-730018
    END IF
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1 = ARG_VAL(1)     #No.TQC-660096
   LET g_argv2 = ARG_VAL(2)     #No.TQC-660096
   LET g_prog = 'axmt840_icd'   #FUN-B90012
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818    #NO.FUN-6A0094
 
   LET p_row = 2 LET p_col = 2
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN #FUN-840012
     #OPEN WINDOW t840_w AT p_row,p_col WITH FORM "axm/42f/axmt840" #FUN-710074
      OPEN WINDOW t840_w AT p_row,p_col WITH FORM "axm/42f/axmt700" #FUN-710074
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
      CALL cl_ui_init()
      #MOD-C80078 -- add start --
      CASE g_sma.sma124
          WHEN 'std'
             CALL cl_reset_qry_btn("oha16,oha1018,b1_ohb31,b1_ohb33,b1_ohb34,b2_ohb31","axmt820,axmt820,axmt820,axmt810,axmt810,axmt810")
          WHEN 'icd'
             CALL cl_reset_qry_btn("oha16,oha1018,b1_ohb31,b1_ohb33,b1_ohb34,b2_ohb31","axmt820_icd,axmt820_icd,axmt820_icd,axmt810_icd,axmt810_icd,axmt810_icd")
          WHEN 'slk'
             CALL cl_reset_qry_btn("oha16,oha1018,b1_ohb31,b1_ohb33,b1_ohb34,b2_ohb31","axmt820_slk,axmt820_slk,axmt820_slk,axmt810_slk,axmt810_slk,axmt810_slk")
      END CASE
     #MOD-C80078 -- add end --
   END IF
   IF cl_null(g_oax.oax01) THEN       #三角貿易使用匯率
      LET g_oax.oax01='S'
   END IF
 
   CALL t700('2',g_argv1,g_argv2) #FUN-840012
 
   IF g_bgjob='N' OR cl_null(g_bgjob) THEN #FUN-840012
      CLOSE WINDOW t840_w                 #結束畫面
   END IF
 
   CALL cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
      RETURNING g_time                  #NO.FUN-6A0094   
 
END MAIN

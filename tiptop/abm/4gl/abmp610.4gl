# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: abmp610.4gl
# Descriptions...: 產品結構偵錯作業
# Date & Author..: 91/09/30 By Lee
# Modify.........: No.MOD-550054 05/05/06 By Carol sabmp610.p610(2,1)
# Modify.........: No.FUN-550093 05/06/01 By kim 配方BOM,特性代碼
# Modify.........: No.FUN-570114 06/02/21 By saki 批次背景執行
# Modify.........: No.FUN-680096 06/08/29 By cheunl  欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0060 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-750225 07/05/29 By arman 運行完一次作業之后，對話框提示“是否繼續作業”，選否，但作業沒有跳出，仍回原界面
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_item     LIKE bma_file.bma01,                # 主件料件編號
    g_bmd01    LIKE bmd_file.bmd01,                # 主件料件編號
    g_bma01    ARRAY[100] OF LIKE bma_file.bma01,  # 已被使用主件編號
    max_level  LIKE type_file.num5,                #No.FUN-680096 SMALLINT
    g_max      LIKE type_file.num5,                # 用來記錄目前ARRAY己使用筆數 #No.FUN-680096 SMALLINT
    g_tot      LIKE type_file.num10,               #No.FUN-680096 INTEGER
    g_err      LIKE type_file.num5,                # 用來記錄發生錯誤的次數 #No.FUN-680096 SMALLINT
    g_acode    LIKE bma_file.bma06,                # No.FUN-570114
    l_flag     LIKE type_file.chr1                 # No.FUN-570114    #No.FUN-680096 VARCHAR(1)
DEFINE   g_i   LIKE type_file.num5                 # count/index for any purpose    #No.FUN-680096 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_item = ARG_VAL(1)
   LET g_acode = ARG_VAL(2)
   LET max_level = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ABM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  #No.FUN-6A0060
   WHILE TRUE
     IF g_bgjob = 'N' THEN
        CALL p610_tm(0,0)
        IF cl_sure(18,20) THEN   #確定執行本作業
           CALL cl_wait()
           LET g_success = 'Y'
           CALL p610(g_item,'abmp610') RETURNING g_i      
           IF g_i <= 0 THEN CALL cl_err('','mfg2641',1) END IF
 
           CALL cl_end2(1) RETURNING l_flag   
           IF l_flag THEN
              CLOSE WINDOW p610_w
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p610_w
              EXIT WHILE
           END IF
        ELSE
           CLOSE WINDOW p610_w
           EXIT WHILE            #NO.TQC-750225
        END IF
        CLOSE WINDOW p610_w
     ELSE
        LET g_success = 'Y'
        CALL p610(g_item,'abmp610') RETURNING g_i
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time   #No.FUN-6A0060
END MAIN

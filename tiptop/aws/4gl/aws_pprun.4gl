# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: aws_pprun.4gl
# Descriptions...: Product Portal 呼叫 ERP 程式啟動器(待辦事項指定的執行程式)
# Date & Author..: 2007/03/21 by Brendan
# Modify.........: No.FUN-6B0036 07/03/21 by Brendan 新建立
# Modify.........: No.CHI-790021 07/09/17 By kim 修改-239的寫法
# Modify.........: No.FUN-7A0054 07/10/23 By Brendan 修正 GP5.0 後執行程式無法正確切換資料庫問題
# Modify.........: No.TQC-870015 08/08/15 By saki 取消使用zxx_file, 補cl_used()
# Modify.........: No.TQC-880043 08/08/22 By saki 取消使用zxx_file
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-950082 10/05/03 By alex 新增ap server hostname設定
# Modify.........: No:FUN-B80064 11/08/05 By Lujh 模組程序撰寫規範修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../../aws/4gl/aws_ppgw.inc"
 
MAIN
    DEFINE ls_gah01    LIKE gah_file.gah01,
           ls_prog     STRING,
           ls_doc      STRING,
           ls_action   STRING,
           ls_sok      STRING,
           ls_cmd      STRING,
           ls_str      STRING,
#          lc_zxx02    LIKE zxx_file.zxx02,    #No.TQC-880043 mark
           lc_gbq10    LIKE gbq_file.gbq10
   DEFINE  lc_fglserver LIKE gbq_file.gbq02    #No.TQC-880043
 
 
    WHENEVER ERROR CONTINUE
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
#   WHENEVER ERROR CALL cl_err_msg_log
 
#    IF (NOT cl_setup("AWS")) THEN
#       EXIT PROGRAM
#    END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #No.TQC-870015
 
    #---------------------------------------------------------------------------
    # Product Portal 啟動程式時帶入參數
    # Arg1 : ERP 代辦事項編號
    # Arg2 : 執行程式代號
    # Arg3 : 單據編號 (***目前僅適用於一個 KEY value 的作業程式)
    # Arg4 : 執行動作
    # Arg5 : 工廠別
    # Arg6 : SOK 字串
    #---------------------------------------------------------------------------
    LET ls_gah01  = ARG_VAL(1)
    LET ls_prog   = ARG_VAL(2)
    LET ls_doc    = ARG_VAL(3)
    LET ls_action = ARG_VAL(4)
    LET g_plant   = ARG_VAL(5)
    LET ls_sok    = ARG_VAL(6)
 
    #---------------------------------------------------------------------------
    # 任何參數未傳入, 視為錯誤
    #---------------------------------------------------------------------------
    IF cl_null(ls_gah01) OR cl_null(ls_prog) OR cl_null(ls_doc) OR 
       cl_null(ls_action) OR cl_null(g_plant) OR cl_null(ls_sok) THEN
       CALL cl_err("Incomplete program parameters", "!", 1)
       DISPLAY "Incomplete program parameters."
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-870015
       EXIT PROGRAM
    END IF
 
    #---------------------------------------------------------------------------
    # 抓取對應資料庫 aza.* 資料
    #---------------------------------------------------------------------------
    SELECT azp03 INTO g_dbs FROM azp_file WHERE azp01 = g_plant
#    CALL cl_ins_del_sid(2) #FUN-980030   #FUN-990069
    CALL cl_ins_del_sid(2,'') #FUN-980030   #FUN-990069
    CLOSE DATABASE 
    DATABASE g_dbs
#    CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
    CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
    SELECT * INTO g_aza.* FROM aza_file WHERE aza01='0'
    IF SQLCA.SQLCODE THEN
       LET ls_str = "Select Parameter file of aza_file Error! Code:", SQLCA.SQLCODE CLIPPED, "\n",
                   "Contact to System Administrator!"
       CALL cl_err(ls_str, "!", 1)
       DISPLAY ls_str
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-870015
       EXIT PROGRAM
    END IF
 
    #---------------------------------------------------------------------------
    # 呼叫 Product Portal 進行 SOK 驗證並取得執行使用者代號
    #---------------------------------------------------------------------------
    LET g_user = cl_ppcli_VerifySOK(ls_sok)
    IF cl_null(g_user) THEN
       CALL cl_err("SOK verify failed or User Account verify failed", "!", 1)
       DISPLAY "SOK verify failed or User Account verify failed."
       CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-870015
       EXIT PROGRAM 
    END IF
 
#No.TQC-870015 --mark start--
    #---------------------------------------------------------------------------
    # 更新 zxx_file 檔案, 以供後續執行作業程式選用正確的資料庫
    #---------------------------------------------------------------------------
#   LET lc_zxx02 = fgl_getenv('FGLSERVER')
#   INSERT INTO zxx_file (zxx01, zxx02, zxx03) 
#                 VALUES (g_user, lc_zxx02, g_plant)
#  #IF SQLCA.SQLCODE = -239 THEN #CHI-790021
#   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-790021
#      UPDATE zxx_file SET zxx03 = g_plant
#       WHERE zxx01 = g_user AND zxx02 = lc_zxx02
#   END IF
#No.TQC-870015 ---mark end---
 
    #-- NO.FUN-7A0054 BEGIN ----------------------------------------------------
    #---------------------------------------------------------------------------
    # 更新 gbq_file 檔案, 以供後續執行作業程式選用正確的資料庫(for GP 5.0)
    #---------------------------------------------------------------------------
    #No.TQC-880043 --start--
    LET lc_fglserver = FGL_GETENV("FGLSERVER")
    LET lc_fglserver = cl_process_chg_iprec(lc_fglserver)
    #No.TQC-880043 ---end---
    LET lc_gbq10 = g_plant CLIPPED, "/", g_plant CLIPPED
    INSERT INTO gbq_file (gbq01, gbq02, gbq03, gbq04, gbq06, gbq10, gbq11 )              #FUN-950082
#                 VALUES (FGL_GETPID(), lc_zxx02, g_user, 'aws_pprun', 2, lc_gbq10)      #No.TQC-880043 mark
                 # VALUES (FGL_GETPID(), lc_fglserver, g_user, 'aws_pprun', 2, lc_gbq10,  #No.TQC-880043 modify
                         # cl_used_ap_hostname() )                                       #FUN-950082              #FUN-B80064   MARK  
                  VALUES (g_time, lc_fglserver, g_user, 'aws_pprun', 2, lc_gbq10,  #No.TQC-880043 modify          #FUN-B80064   ADD
                          g_prog )   #FUN-B80064  ADD
    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN
       UPDATE gbq_file SET gbq10 = lc_gbq10
#       WHERE gbq02 = lc_zxx02 AND gbq03 = g_user     #No.TQC-880043 mark
        WHERE gbq02 = lc_fglserver AND gbq03 = g_user     #No.TQC-880043 modify
    END IF
    #-- NO.FUN-7A0054 END ------------------------------------------------------
 
    #---------------------------------------------------------------------------
    # 轉換傳入的 action 為實際執行 action name
    #---------------------------------------------------------------------------
    CASE ls_action
         WHEN '1'
              LET ls_action = "query"
         WHEN '2'
              LET ls_action = "insert"
         OTHERWISE
              LET ls_action = ""
    END CASE
 
    LET ls_cmd = ls_prog, " ", ls_doc, " ", ls_action
    CALL cl_cmdrun_wait(ls_cmd)
 
    #---------------------------------------------------------------------------
    # 更新 ERP / Product Portal 代辦事項完成日期(結案)
    #---------------------------------------------------------------------------
    IF cl_set_default_plant() THEN
       UPDATE gah_file SET gah09 = TODAY WHERE gah01 = ls_gah01
       CALL cl_ppcli_CloseToDoList(ls_gah01 CLIPPED)
    END IF
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time            #No.TQC-870015
END MAIN

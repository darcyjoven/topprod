# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: gxcp200.4gl
# Descriptions...: 成本系統月結作業
# Date & Author..: 03/12/22 By Danny
 # Modify.........: No.MOD-4A0012 04/11/01 By Yuna 語言button沒亮
# Modify.........: No.FUN-570167 06/03/03 By saki 批次背景執行
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680145 06/09/01 By Dxfwo  欄位類型定義
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.TQC-910017 09/01/12 By liuxqa INSERT INTO	cxb_file時，并沒有給cxb010,cxb011插入進去，導致報錯！
# Modify.........: No.MOD-930237 09/03/25 By chenyu cxd_file計算邏輯的改變
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)

 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   tm      RECORD
                 wc     LIKE type_file.chr1000,  #NO.FUN-680145 VARCHAR(300)
                 year   LIKE type_file.num5,     #NO.FUN-680145 SMALLINT
                 month  LIKE type_file.num5      #NO.FUN-680145 SMALLINT
                 END RECORD,
         last_y  LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
         last_m  LIKE type_file.num5,         #NO.FUN-680145 SMALLINT
         b_date,e_date  LIKE type_file.dat,          #NO.FUN-680145 DATE
          g_sql   string,  #No.FUN-580092 HCN
         g_err   LIKE type_file.chr1000,      #NO.FUN-680145 VARCHAR(80)
         g_cxa   RECORD LIKE cxa_file.*,
         g_cxb   RECORD LIKE cxb_file.*,
         l_flag  LIKE type_file.chr1,         #NO.FUN-680145 VARCHAR(01)
         g_change_lang    LIKE type_file.chr1          #NO.FUN-680145 VARCHAR(01)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0099
   DEFINE p_row,p_col   LIKE type_file.num5          #NO.FUN-680145 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   #No.FUN-570167 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.year  = ARG_VAL(1)
   LET tm.month = ARG_VAL(2)
   LET g_bgjob  = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   #No.FUN-570167 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("GXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1)    RETURNING g_time     #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
       
   #No.FUN-570167 --start--
   #LET tm.year  = ARG_VAL(1)
   #LET tm.month = ARG_VAL(2)
   #IF NOT cl_null(tm.year) THEN
   #   CALL p200_process()
   #ELSE
   #   LET p_row = 4 LET p_col = 25
#   OPEN WINDOW p200_w AT p_row,p_col
   #        WITH FORM "gxc/42f/gxcp200" ATTRIBUTE(STYLE = g_win_style)
   #   CALL cl_ui_init()
   #   CALL p200_tm()
   #   CLOSE WINDOW p200_w
   #END IF
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p200_tm()
         LET g_success='Y'
         BEGIN WORK
         IF cl_sure(0,0) THEN
            CALL p200_process() 
            IF g_success = 'Y' THEN
                 COMMIT WORK
                 CALL cl_end2(1) RETURNING l_flag   #批次作業正確結束
            ELSE
                 ROLLBACK WORK
                 CALL cl_end2(2) RETURNING l_flag   #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p200_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p200_process()
         IF g_success = "Y" THEN
              COMMIT WORK
           ELSE
              ROLLBACK WORK
           END IF
           CALL cl_batch_bg_javamail(g_success)
           EXIT WHILE
      END IF
   END WHILE 
   #No.FUN-570167 --end----
   CALL  cl_used(g_prog,g_time,2)   RETURNING g_time      #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0099
END MAIN
 
FUNCTION p200_tm()
   DEFINE p_row,p_col     LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE lc_cmd          LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(500) 
 
   #No.FUN-570167 --start--
    LET p_row = 4 LET p_col = 25 
    OPEN WINDOW p200_w AT p_row,p_col
         WITH FORM "gxc/42f/gxcp200" ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
   #No.FUN-570167 --end----
 
   CLEAR FORM
   CALL cl_opmsg('z')
   LET tm.year = g_ccz.ccz01
   LET tm.month= g_ccz.ccz02
   LET g_bgjob = 'N'                   #No.FUN-570167
   WHILE TRUE
      INPUT BY NAME tm.year,tm.month,g_bgjob WITHOUT DEFAULTS   #No.FUN-570167
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.MOD-4A0012
         ON ACTION locale
            #No.FUN-570167 --start--
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE
            EXIT INPUT
            #No.FUN-570167 ---end---
         #END
         AFTER FIELD month
            IF tm.month IS NOT NULL THEN
               IF tm.month < 1 OR tm.month > 12 THEN
                  NEXT FIELD month
               END IF
            END IF
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      #-->No.FUN-570167 --start--
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()
          CONTINUE WHILE
       END IF
      #IF INT_FLAG THEN LET INT_FLAG=0 EXIT WHILE END IF
       IF INT_FLAG THEN 
          LET INT_FLAG=0
          CLOSE WINDOW p200_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM 
       END IF
      #IF cl_sure(0,0) THEN
      #   CALL cl_wait()
      #   BEGIN WORK
      #   LET g_success = 'Y'
      #   CALL p200_process()
      #   IF g_success = 'Y' THEN
      #       COMMIT WORK
      #       CALL cl_end2(1) RETURNING l_flag
      #   ELSE
      #       ROLLBACK WORK
      #       CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
      #   END IF
      #   IF l_flag THEN
      #      CONTINUE WHILE
      #   ELSE
      #      EXIT WHILE
      #   END IF
      #END IF
      #ERROR ''
 
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gxcp200"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
             CALL cl_err('gxcp200','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",tm.year CLIPPED,"'",
                         " '",tm.month CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gxcp200',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p200_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
      #-- No.FUN-570167 --end----
  END WHILE
END FUNCTION
 
FUNCTION p200_process()
 
  DELETE FROM cxb_file WHERE cxb02 = tm.year AND cxb03 = tm.month
  IF STATUS THEN
#    CALL cl_err('del cxb',STATUS,0)  #No.FUN-660146
     CALL cl_err3("del","cxb_file",tm.year,tm.month,STATUS,"","del cxb",0)   #No.FUN-660146
     LET g_success = 'N' RETURN  
  END IF
 
  DECLARE p200_curs CURSOR FOR
   SELECT * FROM cxa_file
    WHERE cxa02 = tm.year AND cxa03 = tm.month
      AND cxa08 > cxa10
    ORDER BY cxa01,cxa02,cxa03,cxa04,cxa05,cxa06,cxa07
  IF STATUS THEN
     CALL cl_err('p200_curs',STATUS,1) LET g_success = 'N' RETURN 
  END IF
 
  FOREACH p200_curs INTO g_cxa.*
     IF STATUS THEN
        CALL cl_err('p200_curs #2',STATUS,1) LET g_success = 'N' EXIT FOREACH
     END IF
     INITIALIZE g_cxb.* TO NULL
     LET g_cxb.cxb01 =g_cxa.cxa01
     LET g_cxb.cxb02 =tm.year
     LET g_cxb.cxb03 =tm.month
     LET g_cxb.cxb04 =g_cxa.cxa04
     LET g_cxb.cxb05 =g_cxa.cxa05
     LET g_cxb.cxb06 =g_cxa.cxa06
     LET g_cxb.cxb07 =g_cxa.cxa07
     LET g_cxb.cxb08 =g_cxa.cxa08 -g_cxa.cxa10
    #No.MOD-930237 modify --begin
    #LET g_cxb.cxb09 =g_cxa.cxa09 -g_cxa.cxa11
    #LET g_cxb.cxb091=g_cxa.cxa091-g_cxa.cxa111
    #LET g_cxb.cxb092=g_cxa.cxa092-g_cxa.cxa112
    #LET g_cxb.cxb093=g_cxa.cxa093-g_cxa.cxa113
    #LET g_cxb.cxb094=g_cxa.cxa094-g_cxa.cxa114
    #LET g_cxb.cxb095=g_cxa.cxa095-g_cxa.cxa115
     LET g_cxb.cxb091=(g_cxa.cxa08-g_cxa.cxa10)*g_cxa.cxa091/g_cxa.cxa08
     LET g_cxb.cxb092=(g_cxa.cxa08-g_cxa.cxa10)*g_cxa.cxa092/g_cxa.cxa08
     LET g_cxb.cxb093=(g_cxa.cxa08-g_cxa.cxa10)*g_cxa.cxa093/g_cxa.cxa08
     LET g_cxb.cxb094=(g_cxa.cxa08-g_cxa.cxa10)*g_cxa.cxa094/g_cxa.cxa08
     LET g_cxb.cxb095=(g_cxa.cxa08-g_cxa.cxa10)*g_cxa.cxa095/g_cxa.cxa08
     LET g_cxb.cxb096=(g_cxa.cxa08-g_cxa.cxa10)*g_cxa.cxa096/g_cxa.cxa08
     LET g_cxb.cxb097=(g_cxa.cxa08-g_cxa.cxa10)*g_cxa.cxa097/g_cxa.cxa08
     LET g_cxb.cxb098=(g_cxa.cxa08-g_cxa.cxa10)*g_cxa.cxa098/g_cxa.cxa08
     LET g_cxb.cxb09 = g_cxb.cxb091 + g_cxb.cxb092 + g_cxb.cxb093 + g_cxb.cxb094
                      +g_cxb.cxb095 + g_cxb.cxb096 + g_cxb.cxb097 + g_cxb.cxb098
    #No.MOD-930237 modify --end
     LET g_cxb.cxb010=g_cxa.cxa010        #No.TQC-910017 add by liuxqa
     LET g_cxb.cxb011=g_cxa.cxa011        #No.TQC-910017 add by liuxqa
     IF cl_null(g_cxb.cxb08)  THEN LET g_cxb.cxb08  = 0 END IF
     IF cl_null(g_cxb.cxb09)  THEN LET g_cxb.cxb09  = 0 END IF
     IF cl_null(g_cxb.cxb091) THEN LET g_cxb.cxb091 = 0 END IF
     IF cl_null(g_cxb.cxb092) THEN LET g_cxb.cxb092 = 0 END IF
     IF cl_null(g_cxb.cxb093) THEN LET g_cxb.cxb093 = 0 END IF
     IF cl_null(g_cxb.cxb094) THEN LET g_cxb.cxb094 = 0 END IF
     IF cl_null(g_cxb.cxb095) THEN LET g_cxb.cxb095 = 0 END IF
     #LET g_cxb.cxbplant = g_plant #FUN-980011 add    #FUN-A50075
      LET g_cxb.cxblegal = g_legal #FUN-980011 add
     INSERT INTO cxb_file VALUES(g_cxb.*)
     IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
#       CALL cl_err('ins cxb',STATUS,1)  #No.FUN-660146
        CALL cl_err3("ins","cxb_file",g_cxb.cxb01,g_cxb.cxb02,STATUS,"","ins cxb",1)   #No.FUN-660146
        LET g_success = 'N' EXIT FOREACH  
     END IF
  END FOREACH
END FUNCTION
#Patch....NO.TQC-610037 <001> #

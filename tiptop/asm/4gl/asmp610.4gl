# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: asmp610.4gl
# Descriptions...: 製造管理系統單別流水號月更新
# Input parameter: 
# Return code....: 
# Date & Author..: 94/12/13 By Nick
# Modify.........: No.FUN-570246 05/07/25 By Elva 將月份改為期別處理方式 
# Modify.........: No.MOD-560190 05/08/30 By pengu 當執行完畢會詢問是否繼續,若選擇是,則現在年度月份應該重新Default..
# Modify.........: No.MOD-5C0114 05/12/22 By kim 按照財會期別設定，將相關作業依年度/月份的處理方式 改為 年度/期別 處理
# Modify.........: No.FUN-570152 06/03/13 By yiting 批次背景執行
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-C80092 12/12/05 By lixh1 增加寫入日誌功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          yy1     LIKE type_file.num5,  #No.FUN-690010  SMALLINT
          m1      LIKE type_file.num5,  #No.FUN-690010  SMALLINT
          yy2     LIKE type_file.num5,  #No.FUN-690010  SMALLINT
          m2      LIKE type_file.num5   #No.FUN-690010  SMALLINT 
          END RECORD,
          l_trn   LIKE type_file.chr4,            #No.FUN-690010 VARCHAR(4),
          g_change_lang   LIKE type_file.chr1   # Prog. Version..: '5.30.06-13.03.12(01) #是否有做語言切換
 
#     DEFINEl_time  LIKE type_file.chr8          #No.FUN-6A0089
      DEFINE   l_flag      LIKE type_file.chr1     #No.FUN-570152  #No.FUN-690010 VARCHAR(1)
      DEFINE   g_cka00     LIKE cka_file.cka00   #FUN-C80092
      DEFINE   l_msg       STRING                #FUN-C80092
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
  #-->No.FUN-570152 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy2  = ARG_VAL(1)
   LET tm.m2   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
  #-- No.FUN-570152 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASM")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570152 start--
 # CALL cl_used('asmp610',g_time,1) RETURNING g_time                #No.FUN-6A0089
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   # Prog. Version..: '5.30.06-13.03.12(0,0)                           #
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p610_tm(0,0)
         LET g_success='Y'
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "tm.yy2 = '",tm.yy2,"'",";","tm.m2 = '",tm.m2,"'",";",
                     "g_bgjob = '",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy2,tm.m2,'',l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         BEGIN WORK
         IF cl_sure(21,21) THEN
            CALL p610()
            IF g_success = 'Y' THEN
                 COMMIT WORK
                 CALL s_log_upd(g_cka00,'Y')        #更新日誌  #FUN-C80092
                 CALL cl_end2(1) RETURNING l_flag   #批次作業正確結束
            ELSE
                 ROLLBACK WORK
                 CALL s_log_upd(g_cka00,'N')        #更新日誌  #FUN-C80092
                 CALL cl_end2(2) RETURNING l_flag   #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p610_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "tm.yy2 = '",tm.yy2,"'",";","tm.m2 = '",tm.m2,"'",";",
                     "g_bgjob = '",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy2,tm.m2,'',l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         BEGIN WORK
         CALL p610()
         IF g_success = "Y" THEN
              COMMIT WORK
              CALL s_log_upd(g_cka00,'Y')        #更新日誌  #FUN-C80092
           ELSE
              ROLLBACK WORK
              CALL s_log_upd(g_cka00,'N')        #更新日誌  #FUN-C80092
           END IF
           CALL cl_batch_bg_javamail(g_success)
           EXIT WHILE
        END IF
   END WHILE
 # CALL cl_used('asmp610',g_time,2) RETURNING g_time              #No.FUN-6A0089
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
 
  #-- No.FUN-570152 --end----
# Prog. Version..: '5.30.06-13.03.12(0,0)				#NO.FUN-570152 MARK
END MAIN
 
FUNCTION p610_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
            l_chr         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
            l_flag        LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
            l_aza02       LIKE aza_file.aza02, #MOD-5C0114
            l_range       LIKE type_file.num5   #No.FUN-690010  SMALLINT #MOD-5C0114
   DEFINE   lc_cmd        LIKE type_file.chr1000#No.FUN-690010 VARCHAR(500)   #No.FUN-570152
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW p610_w AT p_row,p_col WITH FORM "asm/42f/asmp610" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   SELECT sma51,sma52 INTO tm.yy1,tm.m1 FROM sma_file
   LET tm.yy2  = tm.yy1
   LET tm.m2   = tm.m1  + 1
   #MOD-5C0114...............begin
   LET l_aza02=''
   SELECT aza02 INTO l_aza02 FROM aza_file
   IF l_aza02='2' THEN
     LET l_range=14
   ELSE
     LET l_range=13
   END IF
   #MOD-5C0114...............end
  #IF tm.m2 = 14 THEN    #FUN-570246 #MOD-5C0114
   IF tm.m2 = l_range THEN  #MOD-5C0114
      LET tm.yy2 = tm.yy1 + 1
      LET tm.m2  = 1
   END IF
   IF s_shut(0) THEN
      CLOSE WINDOW p610_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   WHILE TRUE
     #INPUT BY NAME tm.yy1,tm.m1,tm.yy2,tm.m2 WITHOUT DEFAULTS #No.FUN-570152
      INPUT BY NAME tm.yy1,tm.m1,tm.yy2,tm.m2,g_bgjob WITHOUT DEFAULTS
        
         AFTER FIELD yy2
            IF tm.yy2 IS NULL OR tm.yy2 < 999 OR tm.yy2>2100
               THEN NEXT FIELD yy2
            END IF
     
         AFTER FIELD m2
            IF tm.m2 IS NULL OR tm.m2 <1 OR tm.m2>13  #FUN-570246
               THEN NEXT FIELD m2
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
      
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      
         ON ACTION locale
#NO.FUN-570152 mark
#            LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-570152 mark
            LET g_change_lang = TRUE                  #NO.FUN-570152 
            EXIT INPUT
      
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      
      #IF g_action_choice = "locale" THEN  #NO.FUN-570152 
      IF g_change_lang = TRUE THEN         #NO.FUN-570152
         LET g_change_lang = FALSE
#         LET g_action_choice = ""         #NO.FUN-570152 
         CALL cl_dynamic_locale() 
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p610_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
#NO.FUN-570152 mark--
#         IF cl_sure(0,0) THEN
#            CALL p610()
#            IF g_success='Y' THEN
#               COMMIT WORK
#               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#            ELSE
#               ROLLBACK WORK
#               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#            END IF
#            IF l_flag THEN
#              #--No.MOD-560190 add
#               SELECT sma51,sma52 INTO tm.yy1,tm.m1 FROM sma_file
#               LET tm.yy2  = tm.yy1
#               LET tm.m2   = tm.m1  + 1
#               IF tm.m2 = 13 THEN
#                  LET tm.yy2 = tm.yy1 + 1
#                  LET tm.m2  = 1
#               END IF
#               DISPLAY tm.yy1
#               DISPLAY tm.m1
#               DISPLAY tm.yy2
#               DISPLAY tm.m2
#              #--No.MOD-560190 end
#               CONTINUE WHILE
#            ELSE
#               EXIT WHILE
#            END IF
#         END IF
##           CALL cl_end(0,0)
#NO.FUN-570152 MARK--
 
#NO.FUN-570152 start--
         IF g_bgjob = "Y" THEN
            LET lc_cmd = NULL
            SELECT zz08 INTO lc_cmd FROM zz_file
             WHERE zz01 = "asmp610"
            IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
                CALL cl_err('asmp610','9031',1)                 
            ELSE
                LET lc_cmd = lc_cmd CLIPPED,
                             " '",tm.yy2 CLIPPED,"'",
                             " '",tm.m2 CLIPPED,"'",
                             " '",g_bgjob CLIPPED,"'"
                CALL cl_cmdat('asmp610',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p610_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       EXIT WHILE
#-- No.FUN-570152 --end----
   END WHILE
   ERROR ""
 #  CLOSE WINDOW p610_w   #NO.FUN-570152
END FUNCTION
 
FUNCTION p610()                      #
   DEFINE  l_day        LIKE type_file.num10, #No.FUN-690010   INTEGER,
           l_week       LIKE type_file.num5,  #No.FUN-690010  SMALLINT,
           l_date       LIKE type_file.dat,   #No.FUN-690010  DATE,
           l_sme02      LIKE sme_file.sme02
	
#	LET g_success ='Y'       #NO.FUN-570152 MARK
#	BEGIN WORK               #NO.FUN-570152 MARK
	UPDATE sma_file SET sma51=tm.yy2,sma52=tm.m2 
	IF STATUS THEN
#          CALL cl_err('upd sma51,sma52',STATUS,1)   #No.FUN-660138
           CALL cl_err3("upd","sma_file","","",STATUS,"","upd sma51,sma52",1)  #No.FUN-660138
           LET g_success ='N'
        END IF
 
#       IF g_success = 'Y' THEN
#          CALL cl_cmmsg(1)
#          COMMIT WORK	
#       ELSE
#          CALL cl_rbmsg(1)
#          ROLLBACK WORK
#       END IF
END FUNCTION

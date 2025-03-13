# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: asmp620.4gl
# Descriptions...: 製造管理系統成會關帳更新
# Input parameter: 
# Return code....: 
# Date & Author..: 02/01/31 BY ANN CHEN
# Modify.........: No.FUN-570152 06/03/13 By yiting 批次背景執行
# Modify.........: No.FUN-660138 06/06/20 By pxlpxl cl_err --> cl_err3
# Modify.........: No.FUN-690010 06/09/05 By yjkhero  欄位類型轉換為 LIKE型 
# Modify.........: No.FUN-6A0089 06/10/27 By jackho l_time轉g_time
# Modify.........: No.FUN-740095 07/05/03 By Sarah 畫面上多顯示執行本作業前的成會關帳日
# Modify.........: No.CHI-960043 09/08/24 By dxfwo  本作業沒有呼叫cl_used(),當啟動aoos010做記錄時,則無法記錄本支作業的異動情況到p_used中
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-C80092 12/12/05 By lixh1 增加寫入日誌功能
# Modify.........: No:MOD-D40132 13/05/18 By SunLM  關帳日期不可小於等於主帳別總賬關帳日期
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
           yy1          LIKE type_file.num5,  #No.FUN-690010  SMALLINT,
           m1           LIKE type_file.num5,  #No.FUN-690010  SMALLINT,
           sma53_1      LIKE sma_file.sma53,  #FUN-740095 add   #目前成會關帳日
           sma53        LIKE sma_file.sma53
          END RECORD,
       l_flag           LIKE type_file.chr1,  #No.FUN-690010 VARCHAR(1)
       g_edate,g_bdate  LIKE sma_file.sma53,  #No.FUN-690010  DATE,
       l_trn            LIKE type_file.chr4   #No.FUN-690010  VARCHAR(4)
#DEFINE l_time           LIKE type_file.chr8   #No.FUN-6A0089
DEFINE g_change_lang    LIKE type_file.chr1,  # Prog. Version..: '5.30.06-13.03.12(01), #是否有做語言切換
       ls_date          STRING                #No.FUN-570152
DEFINE g_cka00          LIKE cka_file.cka00   #FUN-C80092
DEFINE l_msg            STRING                #FUN-C80092 
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   #-->No.FUN-570152 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ls_date  = ARG_VAL(1)
   LET tm.sma53 = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob  = ARG_VAL(2)
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
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time  #No.CHI-960043
#NO.FUN-570152 start--
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p610_tm(0,0)
         LET g_success='Y'
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "tm.yy1 = '",tm.yy1,"'",";","tm.m1 = '",tm.m1,"'",";","tm.sma53_1 = '",tm.sma53_1,"'",";",
                     "tm.sma53 = '",tm.sma53,"'",";","g_bgjob = '",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy1,tm.m1,'',l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         BEGIN WORK
         IF cl_sure(0,0) THEN
            CALL p610()
            IF g_success = 'Y' THEN
                 COMMIT WORK
                 CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
                 CALL cl_end2(1) RETURNING l_flag   #批次作業正確結束
            ELSE
                 ROLLBACK WORK
                 CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
                 CALL cl_end2(2) RETURNING l_flag   #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p620_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
   #FUN-C80092 -------------Begin---------------
         LET l_msg = "tm.yy1 = '",tm.yy1,"'",";","tm.m1 = '",tm.m1,"'",";","tm.sma53_1 = '",tm.sma53_1,"'",";",
                     "tm.sma53 = '",tm.sma53,"'",";","g_bgjob = '",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy1,tm.m1,'',l_msg)
              RETURNING g_cka00
   #FUN-C80092 -------------End-----------------
         BEGIN WORK
         CALL p610()
         IF g_success = "Y" THEN
              COMMIT WORK
              CALL s_log_upd(g_cka00,'Y')             #更新日誌  #FUN-C80092
           ELSE
              ROLLBACK WORK
              CALL s_log_upd(g_cka00,'N')             #更新日誌  #FUN-C80092
           END IF
           CALL cl_batch_bg_javamail(g_success)
           EXIT WHILE
        END IF
   END WHILE
 # CALL cl_used('asmp620',g_time,2) RETURNING g_time   #No.FUN-6A0089 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
   #-- No.FUN-570152 --end----
# Prog. Version..: '5.30.06-13.03.12(0,0)				#NO.FUN-570152 mark   
END MAIN
 
FUNCTION p610_tm(p_row,p_col)
   DEFINE   p_row,p_col   LIKE type_file.num5,    #No.FUN-690010 SMALLINT
            l_chr         LIKE type_file.chr1,    #No.FUN-690010 VARCHAR(1)
            l_flag        LIKE type_file.chr1    #No.FUN-690010 VARCHAR(1)
   DEFINE   lc_cmd        LIKE type_file.chr1000#No.FUN-690010 VARCHAR(500)  #No.FUN-570152
   DEFINE   l_aaa07       LIKE aaa_file.aaa07    #MOD-D40132 add
 
   LET p_row = 4 LET p_col = 15
 
   OPEN WINDOW p610_w AT p_row,p_col WITH FORM "asm/42f/asmp620" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   INITIALIZE tm.* TO NULL			# Default condition
   SELECT sma51,sma52,sma53 INTO tm.yy1,tm.m1,tm.sma53_1 FROM sma_file   #FUN-740095 add sma53_1
   CALL s_azm(tm.yy1,tm.m1) RETURNING l_flag,g_bdate,g_edate
   LET tm.sma53=g_edate
   IF s_shut(0) THEN
      CLOSE WINDOW p610_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM 
   END IF
   WHILE TRUE
       #-->No.FUN-570152 --start--
       SELECT sma51,sma52,sma53 INTO tm.yy1,tm.m1,tm.sma53_1 FROM sma_file   #FUN-740095 add sma53_1
       CALL s_azm(tm.yy1,tm.m1) RETURNING l_flag,g_bdate,g_edate
       LET tm.sma53=g_edate
       #-- No.FUN-570152 --end----
 
     #INPUT BY NAME tm.yy1,tm.m1,tm.sma53 WITHOUT DEFAULTS  #No.FUN-570152
      INPUT BY NAME tm.yy1,tm.m1,tm.sma53_1,tm.sma53,g_bgjob WITHOUT DEFAULTS   #FUN-740095 add sma53_1
         #MOD-D40132 add beg-----
         AFTER FIELD sma53
            SELECT aaa07 INTO l_aaa07 FROM aaa_file WHERE aaa01= g_aza.aza81
            IF tm.sma53 <=l_aaa07 THEN 
               CALL cl_err(l_aaa07,'asm-994',1)
               NEXT FIELD sma53
            END IF     
         #MOD-D40132 add end-----         
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()    # Command execution
      
         ON ACTION locale
#NO.FUN-570152 mark
#           CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#           LET g_action_choice = "locale"
#NO.FUN-570152 mark
            LET g_change_lang = TRUE    #NO.FUN-570152
            EXIT INPUT
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
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
         
#NO.FUN-570152 start---
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
      IF g_change_lang = TRUE THEN       
         LET g_change_lang = FALSE      
         CALL cl_dynamic_locale()      
         CALL cl_show_fld_cont()      
         CONTINUE WHILE
      END IF
#NO.FUN-570152 end--      
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 
         CLOSE WINDOW p610_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
#NO.FUN-570152 mark--
#      IF cl_sure(0,0) THEN
#         CALL p610()
#         IF g_success='Y' THEN
#            COMMIT WORK
#            CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#         ELSE
#            ROLLBACK WORK
#            CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#         END IF
#         IF l_flag THEN
#            CONTINUE WHILE
#         ELSE
#            EXIT WHILE
#         END IF
#      END IF
##        CALL cl_end(0,0)
#   END WHILE
#   ERROR ""
#   CLOSE WINDOW p610_w
#NO.FUN-570152 mark--
 
#NO.FUN-570152 start--
         IF g_bgjob = "Y" THEN
            LET lc_cmd = NULL
            SELECT zz08 INTO lc_cmd FROM zz_file
             WHERE zz01 = "asmp620"
            IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
                CALL cl_err('asmp620','9031',1)               
            ELSE
                LET lc_cmd = lc_cmd CLIPPED,
                             " '",tm.sma53 CLIPPED,"'",
                             " '",g_bgjob CLIPPED,"'"
                CALL cl_cmdat('asmp620',g_time,lc_cmd CLIPPED)
          END IF
          CLOSE WINDOW p620_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
          EXIT PROGRAM
       END IF
       EXIT WHILE
   #-- No.FUN-570152 --end----
END WHILE
END FUNCTION
 
FUNCTION p610()                      #
   DEFINE  l_day         LIKE type_file.num10, #No.FUN-690010  INTEGER,
           l_week        LIKE type_file.num5,  #No.FUN-690010  SMALLINT,
           l_date        LIKE type_file.dat,   #No.FUN-690010 DATE,
           l_sme02       LIKE sme_file.sme02
	
#   LET g_success ='Y'  #NO.FUN-570152 MARK
#   BEGIN WORK          #NO.FUN-570152 MARK
    UPDATE sma_file SET (sma53) = (tm.sma53)
    IF STATUS THEN
       CALL cl_err('upd sma53',STATUS,1) 
       CALL cl_err3("upd","sma_file","","",STATUS,"","upd sma53",1) # FUN-660138
       LET g_success ='N'
    END IF
 
#   IF g_success = 'Y' THEN
#      CALL cl_cmmsg(1)
#      COMMIT WORK	
#   ELSE
#      CALL cl_rbmsg(1)
#      ROLLBACK WORK
#   END IF
 
END FUNCTION

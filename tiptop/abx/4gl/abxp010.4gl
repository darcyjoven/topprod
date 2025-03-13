# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: abxp010.4gl
# Descriptions...: 放行單銷案作業
# Return code....: 
# Date & Author..: 96/07/27 BY Star  
# Modify.........: No.FUN-550033 05/05/18 By wujie 單據編號加大
# Modify.........: No.MOD-580323 05/09/02 By jackie 將程序中寫死為中文的錯誤
# Modify.........: No.FUN-570115 06/02/24 By saki 加入背景作業功能
# Modify.........: No.FUN-660052 05/06/13 By ice cl_err3訊息修改
# Modify.........: No.FUN-680062 06/08/21 By yjkhero  欄位類型轉換 
# Modify.........: No.FUN-6A0062 06/10/27 By hellen l_time轉g_time
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting  1、將cl_used()改成標準，使用g_prog
#                                                          2、未加離開前的 cl_used(2) 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
           tm RECORD
               sfb01  LIKE sfb_file.sfb01,
               sfb36  LIKE sfb_file.sfb36,
               bnb16  LIKE  bnb_file.bnb16,                            #No.FUN-680062 VARCHAR(16)
               bnb13  LIKE  bnb_file.bnb13                             #No.FUN-680062 DATE
          END RECORD,
          l_name LIKE type_file.chr20,                         #No.FUN-680062 VARCHAR(20)
          l_cnt LIKE type_file.num5,          #No.FUN-680062 SMALLINT
          l_flag          LIKE type_file.chr1,          #No.FUN-680062 VARCHAR(1)
          g_wc STRING, #No.FUN-580092 HCN       
          g_change_lang   LIKE  type_file.chr1,                 #No.FUN-680062  VARCHAR(1)
          ls_date         STRING         #No.FUN-570115  
#       l_time          LIKE type_file.chr8              #No.FUN-6A0062
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#FUN-570115 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.sfb01 = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.sfb36 = cl_batch_bg_date_convert(ls_date)
   LET ls_date  = ARG_VAL(3)
   LET tm.bnb13 = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN LET g_bgjob="N" END IF
#FUN-570115 --end--
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ABX")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570115 --start--
   #CALL cl_used('abxp010',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time      #FUN-B30211
   WHILE TRUE
     IF g_bgjob='N' THEN
        CALL p010_tm()
        IF cl_sure(0,0) THEN
           CALL cl_wait()
           LET g_success='Y'
           BEGIN WORK
           CALL abxp010()
           IF g_success = 'Y' THEN
              COMMIT WORK
              CALL cl_end2(1) RETURNING l_flag
           ELSE
              ROLLBACK WORK
              CALL cl_end2(2) RETURNING l_flag
           END IF
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              CLOSE WINDOW p010_w
              EXIT WHILE
           END IF
        ELSE
           CONTINUE WHILE
        END IF
        CLOSE WINDOW p010_w
     ELSE
        LET g_success='Y'
        BEGIN WORK
        CALL abxp010()
        IF g_success="Y" THEN
           COMMIT WORK
        ELSE
           ROLLBACK WORK
        END IF
        CALL cl_batch_bg_javamail(g_success)
        EXIT WHILE
     END IF
   END WHILE
   #CALL cl_used('abxp010',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
   #No.FUN-570115 --end--
#  CALL p010_tm()
END MAIN
 
FUNCTION p010_tm()  #輸入基本條件
   DEFINE   p_row,p_col   LIKE type_file.num5,          #No.FUN-680062
            l_direct      LIKE type_file.chr1           #No.FUN-680062 VARCHAR(01)
   DEFINE   l_str         STRING   #No.MOD-580323
   DEFINE   lc_cmd        LIKE type_file.chr1000        #No.FUN-680062 VARCHAR(500)
 
   LET p_row = 6 LET p_col = 25
 
   OPEN WINDOW p010_w AT p_row,p_col WITH FORM "abx/42f/abxp010" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   WHILE TRUE
  #   BEGIN WORK                               #No.FUN-570115
      IF s_shut(0) THEN
         RETURN
      END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Default condition
      LET tm.bnb13 = g_today
      LET g_bgjob="N"                          #No.FUN-570115
                                               #No.FUN-570115
      INPUT BY NAME tm.sfb01,tm.sfb36,tm.bnb13,g_bgjob WITHOUT DEFAULTS 
#No.FUN-550033--begin
      BEFORE INPUT
      CALL cl_set_docno_format("sfb01")
#No.FUN-550033--end   
 
 
 
         AFTER FIELD sfb01
            IF NOT cl_null(tm.sfb01) THEN 
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM sfb_file WHERE sfb01=tm.sfb01 
                  AND sfb36 IS NOT NULL 
               IF l_cnt=0 THEN 
#No.MOD-580323 --start        
                  CALL cl_getmsg('-0101',g_lang) RETURNING l_str    
                  ERROR l_str  
#                 ERROR " 工單未結案, 不可銷案! "
#No.MOD-580323 --end--     
                  NEXT FIELD sfb01 
               ELSE
                  NEXT FIELD bnb13
               END IF
            END IF
 
#        AFTER FIELD sfb36 
#           IF cl_null(tm.sfb36) AND cl_null(tm.sfb01) THEN
#              error " 工單號碼與工單結案日期必須擇一輸入! "
#              NEXT FIELD sfb36  
#           END IF
            
         AFTER FIELD bnb13 
            IF cl_null(tm.bnb13) THEN
               NEXT FIELD bnb13 
            END IF 
         #No.FUN-580031 --start--
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
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
 
 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
               EXIT PROGRAM
            END IF
            IF cl_null(tm.sfb36) AND cl_null(tm.sfb01) THEN
               error " 工單號碼與工單結案日期必須擇一輸入! "
               NEXT FIELD sfb36  
            END IF
        ON ACTION locale
    #      CALL cl_dynamic_locale()                 #No.FUN-570115  --start--
    #     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang=TRUE                   #No.FUN-570115  ---end---
            EXIT INPUT
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
      #No.FUN-570115 --start--
      IF g_change_lang THEN
         LET g_change_lang=FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
      #No.FUN-570115 --end--
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      
      #No.FUN-570115 --start
      IF g_bgjob="Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01="abxp010"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('abxp010','9031',1)
         ELSE
            LET lc_cmd=lc_cmd CLIPPED,
                       " '",tm.sfb01 CLIPPED,"'",
                       " '",tm.sfb36 CLIPPED,"'",
                       " '",tm.bnb13 CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('abxp010',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p010_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
      
#     IF cl_sure(0,0) THEN
#        CALL abxp010()    #找出欲處理之工單資料
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE 
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
            EXIT WHILE
#        END IF
#     END IF
   END WHILE
#  CLOSE WINDOW p010_w
  # No.FUN-570115 --end--
END FUNCTION
 
FUNCTION abxp010()
 
    CALL cl_outnam('abxp010') RETURNING l_name
   IF cl_null(tm.sfb01) THEN
      LET g_wc=" SELECT sfb01 FROM sfb_file WHERE sfb36='",
          tm.sfb36,"' AND sfb02=7 "
   ELSE 
      LET g_wc=" SELECT sfb01 FROM sfb_file WHERE sfb01='",tm.sfb01,"'"
   END IF
   PREPARE g_prepare FROM g_wc
   DECLARE aaa CURSOR FOR g_prepare                   
    LET g_success = 'N'
    FOREACH aaa INTO tm.bnb16 
        UPDATE bnb_file SET bnb13 = tm.bnb13 WHERE bnb16 = tm.bnb16
        #No.FUN-570115 --start--
        IF g_bgjob='N' THEN
           MESSAGE tm.bnb16
        END IF
        #No.FUN-570115 --end--
        IF SQLCA.sqlcode THEN 
           LET g_success = 'N' 
#          CALL cl_err('(bnb update)','lib-030',1)     #No.FUN-660052
           CALL cl_err3("upd","bnb_file","","","lib-030","","(bnb update)",1) 
        ELSE
           LET g_success = 'Y'
           CALL cl_err('(bnb update)','afa-116',1)
        END IF
    END FOREACH
END FUNCTION
 
REPORT a_rep(g_bnb)
   DEFINE g_bnb RECORD
                bnb01 LIKE bnb_file.bnb01,
                bnb13 LIKE bnb_file.bnb13,
                bnb16 LIKE bnb_file.bnb16 END RECORD
   FORMAT
      PAGE HEADER
         PRINT '放行單號    銷案日期  工單號碼'
         PRINT '--------------------------------'
      ON EVERY ROW
         PRINT g_bnb.bnb01,'  ',g_bnb.bnb13,'  ',g_bnb.bnb16
END REPORT        

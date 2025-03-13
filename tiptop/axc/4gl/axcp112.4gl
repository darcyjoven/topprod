# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axcp112.4gl
# Descriptions...: 庫存異動換算率(tlf60)更新作業
# Date & Author..: 96/01/30 By Roger
# Remark         : 若始用本作業, 則 axcp111 可直接取 tlf10*tlf60
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/29 By zdyllq 類型轉換
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_bdate,g_edate	LIKE type_file.dat            #No.FUN-680122DATE
DEFINE g_flag           LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE l_flag          LIKE type_file.chr1,                  #No.FUN-570153        #No.FUN-680122 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,          #No.FUN-680122CHAR(1)               #是否有做語言切換 No.FUN-570153
       ls_date         STRING                  #->No.FUN-570153
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
#->No.FUN-570153 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET ls_date = ARG_VAL(1)
   LET g_bdate = cl_batch_bg_date_convert(ls_date)
   LET ls_date = ARG_VAL(2)
   LET g_edate = cl_batch_bg_date_convert(ls_date)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570153 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
#NO.FUN-570153 mark--
#   OPEN WINDOW p112_w WITH FORM "axc/42f/axcp112" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
#   CALL cl_opmsg('q')
#   LET g_bdate=NULL
#   LET g_edate=NULL
#   WHILE TRUE 
#      LET g_flag = 'Y' 
#      CALL p112_ask()
#      IF g_flag = 'N' THEN
#         CONTINUE WHILE
#      END IF
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#      IF NOT cl_sure(0,0) THEN EXIT WHILE END IF
#      BEGIN WORK
#      LET g_success='Y'
#      CALL cl_wait()
#      CALL p112()
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#      ELSE
#        ROLLBACK WORK
#         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#      END IF
#      IF g_flag THEN
#         CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#      ERROR ''
#      IF INT_FLAG THEN LET INT_FLAG = 0 EXIT WHILE END IF
#   END WHILE
#  CALL cl_end(0,0) 
#   CLOSE WINDOW p112_w
#NO.FUN-570153 mark--
 
#NO.FUN-570153 start--
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = "N" THEN
         CALL p112_ask()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            CALL p112()
            CALL s_showmsg()        #No.FUN-710027 
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
               CLOSE WINDOW p112_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p112_w
      ELSE
         BEGIN WORK
         CALL p112()
         CALL s_showmsg()        #No.FUN-710027 
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570153 end---
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p112_ask()
   DEFINE c             LIKE cre_file.cre08            #No.FUN-680122CHAR(10)
   DEFINE lc_cmd        LIKE type_file.chr1000         #No.FUN-680122CHAR(500)            #No.FUN-570153
 
   OPEN WINDOW p112_w WITH FORM "axc/42f/axcp112"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   LET g_bdate=NULL
   LET g_edate=NULL
 
   LET g_bgjob = "N"          #->No.FUN-570153
   WHILE TRUE
  
   #INPUT BY NAME g_bdate,g_edate WITHOUT DEFAULTS 
   INPUT BY NAME g_bdate,g_edate,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570153
 
      AFTER FIELD g_bdate
         IF cl_null(g_bdate) THEN
            NEXT FIELD g_bdate 
         END IF
 
      AFTER FIELD g_edate
         IF cl_null(g_edate) THEN
            NEXT FIELD g_edate
         END IF
 
      AFTER INPUT 
#NO.FUN-570153 start--
#         IF INT_FLAG THEN 
#            RETURN
#         END IF
         IF INT_FLAG THEN
            LET INT_FLAG = 0
            CLOSE WINDOW p112_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
#NO.FUN-570153 end--
         IF cl_null(g_edate) THEN
            NEXT FIELD g_edate
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION locale #genero
#         LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_change_lang = TRUE                    #NO.FUN-570153 
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
#NO.FUN-570153 start--
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      LET g_flag = 'N'
      RETURN
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p112_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
#      RETURN
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axcp112"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('axcp112','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_bdate CLIPPED ,"'",
                      " '",g_edate CLIPPED ,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axcp112',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p112_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
 
 
FUNCTION p112()
   DEFINE tlf_rowid	LIKE type_file.row_id     #chr18  FUN-A70120
   DEFINE tlf		RECORD LIKE tlf_file.*
   DEFINE img21_a,img21_b	LIKE pml_file.pml09
 
   DECLARE p112_c1 CURSOR FOR
        SELECT tlf_file.rowid, tlf_file.*, a.img21, b.img21
          FROM tlf_file LEFT OUTER JOIN img_file a ON tlf01 =a.img01 AND tlf021=a.img02 AND tlf022=a.img03 AND tlf023=a.img04 LEFT OUTER JOIN img_file b ON tlf01 =b.img01 AND tlf031=b.img02 AND tlf032=b.img03 AND tlf033=b.img04
         WHERE tlf06 BETWEEN g_bdate AND g_edate
           AND (tlf02 BETWEEN 50 AND 59 OR tlf03 BETWEEN 50 AND 59)
   CALL s_showmsg_init()   #No.FUN-710027
   FOREACH p112_c1 INTO tlf_rowid, tlf.*, img21_a, img21_b
      IF SQLCA.SQLCODE THEN
#         CALL cl_err('',SQLCA.SQLCODE,1)            #No.FUN-710027
          CALL s_errmsg('','','',SQLCA.SQLCODE,1)    #No.FUN-710027
         LET g_success='N'
         EXIT FOREACH
      END IF
 
#No.FUN-710027--begin 
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
#No.FUN-710027--end
 
      IF img21_a IS NULL OR img21_a = 0 THEN LET img21_a=1 END IF
      IF img21_b IS NULL OR img21_b = 0 THEN LET img21_b=1 END IF
      IF tlf.tlf12 IS NULL OR tlf.tlf12 = 0 THEN LET tlf.tlf12=1 END IF
      IF tlf.tlf02 >= 50 AND tlf.tlf02 <= 59 THEN
         LET tlf.tlf60 = tlf.tlf12 * img21_a
      END IF
      IF tlf.tlf03 >= 50 AND tlf.tlf03 <= 59 THEN
         LET tlf.tlf60 = tlf.tlf12 * img21_b
      END IF
      #->No.FUN-570153 --start--
      IF g_bgjob = 'N' THEN
         MESSAGE tlf.tlf06
      END IF
      #->NO.FUN-570153 end------ 
      UPDATE tlf_file SET tlf60=tlf.tlf60 WHERE rowid=tlf_rowid
      IF SQLCA.SQLCODE THEN
#        CALL cl_err('',SQLCA.SQLCODE,1)    #No.FUN-660127
#No.FUN-710027--begin 
#         CALL cl_err3("upd","tlf_file","","",SQLCA.SQLCODE,"","",1)   #No.FUN-660127
         CALL s_errmsg('tlf60',tlf.tlf60,'upd tlf:',SQLCA.sqlcode,1)
         LET g_success='N'
#         EXIT FOREACH
         CONTINUE FOREACH
#No.FUN-710027--end
      END IF
 
   END FOREACH
#No.FUN-710027--begin 
      IF g_totsuccess="N" THEN
           LET g_success="N"
      END IF 
#No.FUN-710027--end
 
END FUNCTION

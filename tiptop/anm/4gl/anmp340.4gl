# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: anmp340.4gl
# Descriptions...: 銀行存款對帳關帳作業
# Date & Author..: 96/10/11 By Charis
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/01/15 By Jackho 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-750041 07/05/10 By mike   銀行編號欄位控管
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9B0057 09/11/16 By wujie  银行编号错误码修改
# Modify.........: No:MOD-A30227 10/03/29 By sabrina FETCH p340_cl1 INTO l_cnt之前要加OPEN p340_cl1 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm_wc,l_sql     LIKE type_file.chr1000     #No.FUN-680107 VARCHAR(100)
DEFINE g_nma21         LIKE nma_file.nma21        #No.FUN-680107 DATE
DEFINE g_bank          LIKE nmp_file.nmp01        #銀行編號
DEFINE g_flag          LIKE type_file.chr1        #No.FUN-680107 VARCHAR(1)
DEFINE l_flag          LIKE type_file.chr1,       #No.FUN-570127 #No.FUN-680107 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,       #No.FUN-680107 VARCHAR(1) #是否有做語言切換 No.FUN-570127
       ls_date         STRING                     #->日期轉換 No.FUN-570127
DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680107 SMALLINT
DEFINE g_sql           varchar(300)
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0082
 
     OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570127 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm_wc   = ARG_VAL(1)                          #銀行編號
   LET ls_date = ARG_VAL(2)
   LET g_nma21 = cl_batch_bg_date_convert(ls_date)   #關帳日期
   LET g_bgjob = ARG_VAL(3)                 #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570127 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#NO.FUN-570127 mark--
#    OPEN WINDOW p340 AT p_row,p_col WITH FORM "anm/42f/anmp340"
#          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#    CALL cl_opmsg('z')
#    CALL p340_ask()
#    CLOSE WINDOW p340
#NO.FUN-570127 mark--
 
#NO.FUN-570127 start--
   LET g_success = 'Y'
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p340_ask()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL s_showmsg_init()             #No.FUN-710024
            CALL p340()
            CALL s_showmsg()                  #No.FUN-710024
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
               CLOSE WINDOW p340
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL s_showmsg_init()             #No.FUN-710024
         CALL p340()
         CALL s_showmsg()                  #No.FUN-710024
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#->No.FUN-570127 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION p340_ask()
   DEFINE   l_bdate   LIKE type_file.chr8    #No.FUN-680107 VARCHAR(8)
   DEFINE   l_year    LIKE nmp_file.nmp02
   DEFINE   lc_cmd    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(500) #No.FUN-570127
#->No.FUN-570127 --start--
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p340 AT p_row,p_col WITH FORM "anm/42f/anmp340"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
#->No.FUN-570127 ---end---
 
   WHILE TRUE
     CONSTRUCT BY NAME tm_wc ON nma01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
        ON ACTION locale                    #genero
#           LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang = TRUE                  #NO.FUN-570127
           EXIT CONSTRUCT
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
 
#NO.FUN-570127 start---
#     IF g_action_choice = "locale" THEN  #genero
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CONTINUE WHILE
#     END IF
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        EXIT WHILE
#     END IF
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p340
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
#NO.FUN-570127 end--------
 
     #資料權限的檢查
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #        LET tm_wc = tm_wc clipped," AND nmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #        LET tm_wc = tm_wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #        LET tm_wc = tm_wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
     #End:FUN-980030
 
     LET g_nma21=g_today
     DISPLAY BY NAME g_nma21
     LET g_bgjob = "N"   #NO.FUN-570127 
     #INPUT BY NAME g_nma21 WITHOUT DEFAULTS
     INPUT BY NAME g_nma21,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570127 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        AFTER INPUT
           IF INT_FLAG THEN
              EXIT INPUT
           END IF
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
        ON ACTION exit  #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
#NO.FUN-570127 start--
      ON ACTION locale                    #genero
         LET g_change_lang = TRUE   #NO.FUN-570126
         EXIT INPUT
#NO.FUN-570127 end---
 
     END INPUT
#NO.FUN-570127 start--
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        EXIT WHILE
#     END IF
 
#     IF NOT cl_sure(0,0) THEN
#        CONTINUE WHILE
#     END IF
 
#     BEGIN WORK
#     CALL p340()
#     IF g_success = 'Y' THEN
#        COMMIT WORK
#        CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#     ELSE
#        ROLLBACK WORK
#        CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#     END IF
#     IF g_flag THEN
#        CONTINUE WHILE
#     ELSE
#        EXIT WHILE
#     END IF
#
#  END WHILE
 #->No.FUN-570127 --start--
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p340
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "anmp340"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('anmp340','9031',1)   
        ELSE
           LET tm_wc=cl_replace_str(tm_wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm_wc CLIPPED ,"'",
                        " '",g_nma21 CLIPPED , "'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('anmp340',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p340
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
   EXIT WHILE
#NO.FUN-570127 end----------
END WHILE
END FUNCTION
 
FUNCTION p340()
DEFINE l_cnt LIKE type_file.num5      #No.FUN-750041
     LET g_success = 'Y'
     LET l_sql = "SELECT nma01 FROM nma_file ",
                 " WHERE ",tm_wc CLIPPED
     #No.fun-750041  --begin--
 
     LET g_sql = "SELECT COUNT(*) FROM nma_file ",
                 " WHERE ",tm_wc CLIPPED
     PREPARE p340_pl1 FROM g_sql
     DECLARE p340_cl1 CURSOR FOR p340_pl1
     OPEN p340_cl1              #MOD-A30227 add 
     FETCH p340_cl1 INTO l_cnt
 
     IF cl_null(l_cnt) OR l_cnt = 0 THEN  
#       CALL cl_err('g_nma01','7510',1)
        CALL cl_err('g_nma01','aap-007',1)  #No.TQC-9B0057 
        LET g_success = 'N'
     END IF
 
     # No.FUN-750041 --END--
     
     PREPARE p340_p1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
 
     DECLARE p340_c1 CURSOR FOR p340_p1
     IF SQLCA.sqlcode THEN
        CALL cl_err('declare:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
 
     FOREACH p340_c1 INTO g_bank
       IF g_bgjob='N' THEN  #NO.FUN-570127
           MESSAGE 'fetch bank:',g_bank
           CALL ui.Interface.refresh()
       END IF
       UPDATE nma_file SET nma21=g_nma21
        WHERE nma01=g_bank
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#         CALL cl_err('ins nmp',STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#          CALL cl_err3("upd","nma_file",g_bank,"",STATUS,"","ins nmp",1) #No.FUN-660148
          CALL s_errmsg('nma01',g_bank,'upd nmp',STATUS,1)
          LET g_success = 'N'
#          EXIT FOREACH
          CONTINUE FOREACH
#No.FUN-710024--end
       ELSE
       END IF
    END FOREACH
END FUNCTION
 

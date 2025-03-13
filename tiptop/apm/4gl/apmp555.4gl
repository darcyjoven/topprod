# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: apmp555.4gl
# Descriptions...: 已結案採購單刪除作業(採購單狀況碼結束與取消)
# Input parameter: 
# Return code....: 
# Date & Author..: 91/10/01 By Wu 
# Modify.........: 99/04/16 BY Carol:modify s_pmmsta()
# Modify.........: No.FUN-570138 06/03/08 By TSD.Martin 批次背景執行
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.MOD-660092 06/06/26 By Pengu 採購單單頭檔沒有刪掉以外，其餘資料都已刪除。
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-7B0018 08/02/29 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          pmm04      LIKE pmm_file.pmm04,       #採購日期
          y          LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
          END RECORD,
       sr RECORD
          pmm01	     LIKE pmm_file.pmm01,
          pmm02	     LIKE pmm_file.pmm02,
          pmm04	     LIKE pmm_file.pmm04,
          pmm09	     LIKE pmm_file.pmm09,
          pmm25      LIKE pmm_file.pmm25       #No.FUN-680136 VARCHAR(10)
          END RECORD,
        g_wc         string                     #No.FUN-580092 HCN
DEFINE l_flag        LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
       g_change_lang LIKE type_file.chr1,       #No.FUN-680136 VARCHAR(1)
       ls_date       STRING                     #No.FUN-570138
 
DEFINE g_forupd_sql  STRING                     #SELECT ... FOR UPDATE SQL
DEFINE g_chr         LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
DEFINE g_flag        LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
DEFINE g_cnt         LIKE type_file.num10       #No.FUN-680136 INTEGER

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#->No.FUN-570138 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.pmm04 = cl_batch_bg_date_convert(ls_date)
   LET tm.y     = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= "N"
   END IF
#->No.FUN-570138 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

#NO.FUN-570138 start---
#   CALL p555_tm()				# 
#   CLOSE WINDOW p555_w
   WHILE TRUE
      IF g_bgjob= "N" THEN
         CALL p555_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL apmp555()
            CALL s_showmsg()       #No.FUN-710030
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
               CLOSE WINDOW p555_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p555_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL apmp555()
         CALL s_showmsg()       #No.FUN-710030
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p555_tm()
   DEFINE p_row,p_col	LIKE type_file.num5    #No.FUN-680136 SMALLINT
   DEFINE lc_cmd        LIKE type_file.chr1000 #No.FUN-680136 VARCHAR(500)
 
   LET p_row = 3 LET p_col = 15
 
   OPEN WINDOW p555_w AT p_row,p_col WITH FORM "apm/42f/apmp555" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   IF s_shut(0) THEN RETURN END IF
 
 WHILE TRUE
    CLEAR FORM 
    ERROR ''
    CONSTRUCT g_wc ON pmm01,pmm09 FROM pmm01,pmm09
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
#no.FUN-570138 mark
#         LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#no.FUN-570138 mark
         LET g_change_lang = TRUE                    #NO.FUN-570138 
         EXIT CONSTRUCT
     
      ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup') #FUN-980030
 
#NO.FUN-570138 start--- 
#   IF g_action_choice = "locale" THEN  #genero
#      LET g_action_choice = ""
#      CALL cl_dynamic_locale()
#      CONTINUE WHILE  
#   END IF
 
#   IF INT_FLAG THEN
#      EXIT WHILE  
#   END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p555_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211 
      EXIT PROGRAM
   END IF
#NO.FUN-570138 end---------
 
   INITIALIZE tm.* TO NULL			# Default condition
 
   LET tm.y = 'Y'
   LET g_bgjob = "N"          #->No.FUN-570138
   #INPUT BY NAME tm.pmm04,tm.y WITHOUT DEFAULTS 
   INPUT BY NAME tm.pmm04,tm.y,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570138 
 
      AFTER FIELD y
        IF NOT cl_null(tm.y) THEN 
           IF tm.y NOT MATCHES "[YN]" THEN 
              NEXT FIELD y 
           END IF
        END IF
 
        ON ACTION CONTROLF                        # 欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
 
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
 
 
        ON ACTION exit  #加離開功能genero
           LET INT_FLAG = 1
           EXIT INPUT
   
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
#NO.FUN-570138 add--
      ON ACTION locale                    #genero
         LET g_change_lang = TRUE
         EXIT INPUT
#NO.FUN-570138 add--
 
   END INPUT
 
#NO.FUN-570138 start---
#   IF INT_FLAG THEN 
#      LET INT_FLAG = 0 
#      CONTINUE WHILE 
#   END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()   #FUN-550037(smin)
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p555_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "apmp555"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('apmp555','9031',1)  
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED ,"'",
                      " '",tm.pmm04 CLIPPED,"'",
                      " 'N' ",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('apmp555',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p555_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
#NO.FUN-570138 end-----------------
 
#NO.FUN-570138 mark------
#   IF cl_sure(0,0) THEN
#      CALL cl_wait()
#      CALL apmp555()    #show 欲刪除之資料
#      IF INT_FLAG THEN 
#         LET INT_FLAG = 0
#         CONTINUE WHILE 
#      END IF 
#      IF g_success = 'Y' THEN 
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#      END IF
#
#      IF g_flag THEN
#         CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#   END IF
#   ERROR ""
#NO.FUN-570138 mark------
 END WHILE
 
END FUNCTION
 
FUNCTION apmp555()
   DEFINE l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT                #No.FUN-680136 VARCHAR(600)
          l_buf 	LIKE type_file.chr1000,		#No.FUN-680136 VARCHAR(80)
          l_cnt1,l_cnt2	LIKE type_file.num5    		# Already-cnt, N-cnt             #No.FUN-680136 SMALLINT
 
    LET g_success = 'Y'
    BEGIN WORK
 
    LET l_sql = " SELECT pmm01,pmm02,pmm04,pmm09,pmm25 ",
                     " FROM pmm_file",
                     " WHERE pmm04 <='",tm.pmm04,"' AND " ,
                     " pmm25 IN ('6','9') AND ",
                     g_wc clipped
    PREPARE p555_prepare1 FROM l_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('prepare p555_prepare1:',SQLCA.sqlcode,1) 
       LET g_success = 'N'
       RETURN 
    END IF
    DECLARE p555_cur CURSOR FOR p555_prepare1
    IF SQLCA.sqlcode THEN 
       CALL cl_err('declare p555_cur:',SQLCA.sqlcode,1) 
       LET g_success = 'N'
       RETURN 
    END IF
 
    LET g_forupd_sql = "SELECT pmm01,pmm02,pmm04,pmm09,pmm25 ",   #No.MOD-660092 modify
                       "  FROM pmm_file  WHERE pmm01 = ? ",
                       "   FOR UPDATE "
 
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p555_curl CURSOR FROM g_forupd_sql
    IF SQLCA.sqlcode THEN 
       CALL cl_err('declare p555_cur1:',SQLCA.sqlcode,1) 
       LET g_success = 'N'
       RETURN 
    END IF
    IF g_bgjob = 'N' THEN       #NO.FUN-570138
        OPEN WINDOW p555_w2 AT 15,5 WITH 6 ROWS, 70 COLUMNS
         
       CALL cl_getmsg('mfg2730',g_lang) RETURNING l_buf
       #DISPLAY l_buf AT 1,1    #CHI-A70049 mark
        CALL cl_getmsg('mfg3118',g_lang) RETURNING l_buf
       #DISPLAY l_buf AT 3,1    #CHI-A70049 mark
        CALL cl_getmsg('mfg3119',g_lang) RETURNING l_buf
       #DISPLAY l_buf AT 4,1    #CHI-A70049 mark
    END IF
    LET l_cnt1 = 0
    LET l_cnt2 = 0
    LET g_cnt = NULL
    CALL s_showmsg_init()        #No.FUN-710030
    FOREACH p555_cur INTO sr.*
       IF SQLCA.sqlcode THEN 
#No.FUN-710030 -- begin --
#          CALL cl_err('foreach:',SQLCA.sqlcode,1) 
          IF g_bgerr THEN
             CALL s_errmsg("","","foreach:",SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","foreach:",1)
          END IF
#No.FUN-710030 -- end --
          LET g_success = 'N'
          EXIT FOREACH 
       END IF
#No.FUN-710030 -- begin --
       IF g_success="N" THEN
          LET g_totsuccess="N"
          LET g_success="Y"
       END IF
#No.FUN-710030 -- end --
 
       IF g_cnt IS NULL THEN
          LET g_cnt = SQLCA.SQLERRD[3]
          IF g_bgjob = 'N' THEN  #NO.FUN-570138
              DISPLAY g_cnt USING "###&" AT 1,17 
          END IF
       END IF
       LET l_cnt1 = l_cnt1 + 1
       IF g_bgjob = 'N' THEN  #NO.FUN-570138
           DISPLAY l_cnt1 USING "###&" AT 1,34 
       END IF
       OPEN p555_curl USING sr.pmm01
       IF STATUS THEN
#          CALL cl_err("OPEN p555_curl:", STATUS, 1)   #No.FUN-710030
          CLOSE p555_curl
          LET g_success = 'N'
#          RETURN                                      #No.FUN-710030
#No.FUN-710030 -- begin --
          IF g_bgerr THEN
             CALL s_errmsg("","","OPEN p555_curl:",STATUS,1)
             CONTINUE FOREACH
          ELSE
             CALL cl_err3("","","","",STATUS,"","OPEN p555_curl:",1)
             EXIT FOREACH
          END IF
#No.FUN-710030 -- end --
       END IF
       FETCH p555_curl INTO
             sr.pmm01,sr.pmm02,sr.pmm04,sr.pmm09,sr.pmm25
       IF STATUS THEN 
#No.FUN-710030 -- begin --
#          CALL cl_err('fetch p555_curl',STATUS,1) 
          IF g_bgerr THEN
             CALL s_errmsg("","","fetch p555_curl",STATUS,1)
          ELSE
             CALL cl_err3("","","","",STATUS,"","fetch p555_curl",1)
          END IF
#No.FUN-710030 -- begin --
          CONTINUE FOREACH 
       END IF 
       CALL s_pmmsta('pmm',sr.pmm25,' ',' ') RETURNING sr.pmm25
       IF tm.y = 'N' THEN 
          LET g_chr = 'Y'
          IF g_bgjob = 'N' THEN  #NO.FUN-570138
              MESSAGE sr.pmm01,' ',sr.pmm04,' ',sr.pmm02,' ',sr.pmm09,' ',sr.pmm25
              CALL ui.Interface.refresh()
          END IF
       ELSE 
          LET g_chr = ' '
          WHILE g_chr NOT MATCHES "[YNyn]" OR cl_null(g_chr) 
              IF g_bgjob = 'N' THEN  #NO.FUN-570138
                   PROMPT sr.pmm01,' ',sr.pmm04,' ',sr.pmm02,' ', 
                          sr.pmm09,' ',sr.pmm25,'     '
                          FOR CHAR g_chr
                  IF INT_FLAG THEN 
                      EXIT WHILE 
                   END IF
              END IF
          END WHILE
          IF INT_FLAG THEN 
             LET g_success = 'N'
             EXIT FOREACH
          END IF 
       END IF
       IF g_chr MATCHES "[Yy]" THEN
          DELETE FROM pmm_file WHERE pmm01=sr.pmm01   #刪除採購單頭
          IF SQLCA.sqlcode THEN 
             LET g_success = 'N'
#            CALL cl_err('delete pmm_file error',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#             CALL cl_err3("del","pmm_file","","",SQLCA.sqlcode,"","delete pmm_file error",1)  #No.FUN-660129
#             EXIT FOREACH
             IF g_bgerr THEN
                CALL s_errmsg("pmm01",sr.pmm01,"delete pmm_file error",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("del","pmm_file",sr.pmm01,"",SQLCA.sqlcode,"","delete pmm_file error",1)
                EXIT FOREACH
             END IF
#No.FUN-710030 -- end --
          END IF
          DELETE FROM pmn_file WHERE pmn01 = sr.pmm01       #刪除採購單身
          IF SQLCA.sqlcode THEN 
             LET g_success = 'N'
#            CALL cl_err('delete pmn_file error',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#             CALL cl_err3("del","pmn_file",sr.pmm01,"",SQLCA.sqlcode,"","delete pmn_file error",1)  #No.FUN-660129
#             EXIT FOREACH
             IF g_bgerr THEN
                CALL s_errmsg("pmn01",sr.pmm01,"delete pmn_file error",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("del","pmn_file",sr.pmm01,"",SQLCA.sqlcode,"","delete pmn_file error",1)
                EXIT FOREACH
             END IF
#No.FUN-710030 -- end --
          #NO.FUN-7B0018 08/02/29 add --begin
          ELSE
             IF NOT s_industry('std') THEN
                IF NOT s_del_pmni(sr.pmm01,'','') THEN
                   LET g_success = 'N'
                END IF
             END IF
          #NO.FUN-7B0018 08/02/29 add --end
          END IF
          DELETE FROM pmz_file WHERE pmz01 = sr.pmm01   #刪除採購交期確認資料
          IF SQLCA.sqlcode THEN 
             LET g_success = 'N'
#            CALL cl_err('delete pmz_file error',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#             CALL cl_err3("del","pmz_file","","",SQLCA.sqlcode,"","delete pmz_file error",1)  #No.FUN-660129
#             EXIT FOREACH
             IF g_bgerr THEN
                CALL s_errmsg("pmz01",sr.pmm01,"delete pmz_file error",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("del","pmz_file","sr.pmm01","",SQLCA.sqlcode,"","delete pmz_file error",1)
                EXIT FOREACH
             END IF
#No.FUN-710030 -- begin --
          END IF
          DELETE FROM pmp_file WHERE pmp01 = sr.pmm01       #刪除採購備註
                                 AND pmp02 matches '1'
          IF SQLCA.sqlcode THEN 
             LET g_success = 'N'
#            CALL cl_err('delete pmp_file error',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#             CALL cl_err3("del","pmp_file",sr.pmm01,"",SQLCA.sqlcode,"","delete pmp_file error",1)  #No.FUN-660129
#             EXIT FOREACH
             IF g_bgerr THEN
                LET g_showmsg = sr.pmm01,"/","matches '1'"
                CALL s_errmsg("pmp01,pmp02",g_showmsg,"delete pmp_file error",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("del","pmp_file",sr.pmm01,"matches '1'",SQLCA.sqlcode,"","delete pmp_file error",1)
                EXIT FOREACH
             END IF
#No.FUN-710030 -- begin --
          END IF
          DELETE FROM pmo_file WHERE pmo01 = sr.pmm01       #刪除採購說明
                                 AND pmo02 matches '1'
          IF SQLCA.sqlcode THEN 
             LET g_success = 'N'
#            CALL cl_err('delete pmo_file error',SQLCA.sqlcode,1)   #No.FUN-660129
#No.FUN-710030 -- begin --
#             CALL cl_err3("del","pmo_file",sr.pmm01,"",SQLCA.sqlcode,"","delete pmo_file error",1)  #No.FUN-660129
#             EXIT FOREACH
             IF g_bgerr THEN
                LET g_showmsg = sr.pmm01,"/","matches '1'"
                CALL s_errmsg("pmo01,pmo02",g_showmsg,"delete pmo_file error",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("del","pmo_file",sr.pmm01,"matches '1'",SQLCA.sqlcode,"","delete pmo_file error",1)
                EXIT FOREACH
             END IF
#No.FUN-710030 -- begin --
          END IF
       ELSE
          LET l_cnt2 = l_cnt2 + 1
          IF g_bgjob = 'N' THEN  #NO.FUN-570138
              DISPLAY l_cnt2 USING "###&" AT 1,53 
          END IF
       END IF
       CLOSE p555_curl
    END FOREACH
#No.FUN-710030 -- begin --
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
#No.FUN-710030 -- end --
 
    CLOSE WINDOW p555_w2
     
END FUNCTION

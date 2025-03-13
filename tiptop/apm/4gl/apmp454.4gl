# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: apmp454.4gl
# Descriptions...: 已結案/取消請購單刪除作業
# Input parameter: 
# Return code....: 
# Date & Author..: 91/10/01 By Wu 
# Modify.........: 99/04/16 By Carol:modify s_pmksta()
# Modify.........: No.FUN-570138 06/03/09 By yiting 批次背景執行
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-710030 07/01/17 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0067 09/11/10 By lilingyu 去掉ATTRIBUTE
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)

DATABASE ds

GLOBALS "../../config/top.global"
 
DEFINE tm RECORD
          pmk04 LIKE pmk_file.pmk04,              #請購日期
          y     LIKE type_file.chr1               #No.FUN-680136 VARCHAR(1)
          END RECORD,
       sr RECORD
          pmk01	LIKE pmk_file.pmk01,
          pmk02	LIKE pmk_file.pmk02,
          pmk04	LIKE pmk_file.pmk04,
          pmk09	LIKE pmk_file.pmk09,
          pmk25 LIKE pmk_file.pmk25              #No.FUN-680136 VARCHAR(10)
          END RECORD,
        g_wc   string                             #No.FUN-580092 HCN
DEFINE l_flag          LIKE type_file.chr1,       #No.FUN-570138       #No.FUN-680136 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1,       #是否有做語言切換    #No.FUN-570138 #No.FUN-680136 VARCHAR(1)
       ls_date         STRING                     #->No.FUN-570138
 
DEFINE   g_forupd_sql  STRING                     #SELECT ... FOR UPDATE SQL
DEFINE   g_chr         LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
DEFINE   g_flag        LIKE type_file.chr1        #No.FUN-680136 VARCHAR(1)
DEFINE   g_cnt         LIKE type_file.num10       #No.FUN-680136 INTEGER
DEFINE   p_row,p_col   LIKE type_file.num5        #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
#->No.FUN-570138 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   LET ls_date  = ARG_VAL(2)
   LET tm.pmk04 = cl_batch_bg_date_convert(ls_date)
   LET tm.y     = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
#->No.FUN-570138 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   IF g_sma.sma31 matches'[Nn]' THEN    #無使用請購功能
      CALL cl_err(g_sma.sma31,'mfg0032',1)
      IF g_bgjob = "Y" THEN CALL cl_batch_bg_javamail("N") END IF  #NO.FUN-570138
      EXIT PROGRAM  
   END IF
 
#NO.FUN-570138 mark---
#   LET p_row = 3 LET p_col = 20
 
#   OPEN WINDOW p454_w AT p_row,p_col WITH FORM "apm/42f/apmp454" 
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#   CALL cl_ui_init()
 
#   CALL cl_opmsg('q')
 
     CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818
#   CALL p454_tm()				# 
#   ERROR ''
#   CLOSE WINDOW p454_w
#NO.FUN-570138 mark--
 
#NO.FUN-570138 start--
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p454_tm()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL apmp454()
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
               CLOSE WINDOW p454_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p454_w
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL apmp454()
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
#NO.FUN-570138 end---

   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818
END MAIN
 
FUNCTION p454_tm()
   DEFINE lc_cmd         LIKE type_file.chr1000   #No.FUN-680136 VARCHAR(500)
#->No.FUN-570138 --start--
   IF s_shut(0) THEN RETURN END IF
   LET p_row = 3 LET p_col = 20
 
   OPEN WINDOW p454_w AT p_row,p_col WITH FORM "apm/42f/apmp454"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
 
#->No.FUN-570138 --end--
 
  WHILE TRUE
   # IF s_shut(0) THEN RETURN END IF
    CLEAR FORM 
    ERROR ''
    CONSTRUCT g_wc ON pmk01,pmk09 FROM pmk01,pmk09
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
#no.FUN-570138 MARK
#           LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#no.FUN-570138 MARK
           LET g_change_lang = TRUE                  #NO.FUN-570138
           EXIT CONSTRUCT
       
        ON ACTION exit              #加離開功能genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
    END CONSTRUCT
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup') #FUN-980030
   
#NO.FUN-570138 start--
#    IF g_action_choice = "locale" THEN  #genero
#       LET g_action_choice = ""
#       CALL cl_dynamic_locale()
#       CONTINUE WHILE  
#    END IF
 
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0
#       EXIT WHILE 
#    END IF
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p454_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
#NO.FUN-570138 end------------
 
    INITIALIZE tm.* TO NULL			# Default condition
    LET tm.y = 'Y'
    LET g_bgjob = 'N'  #NO.FUN-570138 
    #INPUT BY NAME tm.pmk04,tm.y WITHOUT DEFAULTS 
    INPUT BY NAME tm.pmk04,tm.y,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570138
 
      AFTER FIELD y
         IF NOT cl_null(tm.y) THEN 
            IF tm.y NOT MATCHES "[YN]" THEN
               NEXT FIELD y
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
 
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
        
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
        ON ACTION locale                    #genero
           LET g_change_lang = TRUE                  #NO.FUN-570138
           EXIT INPUT
 
   END INPUT
 
#NO.FUN-570138 start--
#   IF INT_FLAG THEN 
#      LET INT_FLAG = 0
#      EXIT WHILE 
#   END IF
   
#   IF cl_sure(0,0) THEN
#      CALL cl_wait()
#      ERROR ""
#
#      BEGIN WORK
#
#      LET g_success = 'Y'
#      CALL apmp454()    #show 欲刪除之資料
#
#      IF g_success = 'Y' THEN 
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#      ELSE
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#      END IF
#      IF g_flag THEN
#         CONTINUE WHILE
#      ELSE
#         EXIT WHILE
#      END IF
#   END IF
#NO.FUN-570138 mark---
 
#NO.FUN-570138 start---
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "apmp454"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('apmp454','9031',1)
        ELSE
           LET g_wc=cl_replace_str(g_wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_wc CLIPPED ,"'",
                        " '",tm.pmk04 CLIPPED ,"'",
                        " 'N' ",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('apmp454',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p454_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
   EXIT WHILE
  #->No.FUN-570138 ---end---
 END WHILE
END FUNCTION
 
FUNCTION apmp454()
   DEFINE l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT #No.FUN-680136 VARCHAR(600)
          l_buf 	LIKE type_file.chr1000,	        #No.FUN-680136 VARCHAR(80)
          l_cnt1,l_cnt2	LIKE type_file.num5    		# Already-cnt, N-cnt #No.FUN-680136 SMALLINT
 
   LET l_sql = " SELECT pmk01,pmk02,pmk04,pmk09,pmk25 ",
                      " FROM pmk_file",
                      " WHERE pmk04 <='",tm.pmk04,"' AND " ,
                      " pmk25 IN ('6','9') AND ",
                      g_wc clipped
 
   PREPARE p454_prepare1 FROM l_sql
   IF SQLCA.sqlcode THEN 
      CALL cl_err('prepare:',SQLCA.sqlcode,1) 
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE p454_cs CURSOR  FOR p454_prepare1
   IF SQLCA.sqlcode THEN 
      CALL cl_err('declare p454_cs:',SQLCA.sqlcode,1) 
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_forupd_sql = "SELECT pmk01,pmk02,pmk04,pmk09,pmk25 ",
                      "FROM pmk_file  WHERE pmk01 = ? ",
                      "FOR UPDATE "
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p454_cl CURSOR FROM g_forupd_sql
   IF SQLCA.sqlcode THEN 
      CALL cl_err('declare p454_cl:',SQLCA.sqlcode,1) 
      LET g_success = 'N'
      RETURN
   END IF
   IF g_bgjob ='N' THEN  #NO.FUN-570138
      OPEN WINDOW p454_w2 AT 15,5 WITH 6 ROWS, 70 COLUMNS
#         ATTRIBUTES(BORDER,RED)   #FUN-9B0067
          
      CALL cl_getmsg('mfg2730',g_lang) RETURNING l_buf
     #DISPLAY l_buf AT 1,1   #CHI-A70049 mark
      CALL cl_getmsg('mfg3118',g_lang) RETURNING l_buf
     #DISPLAY l_buf AT 3,1   #CHI-A70049 mark
      CALL cl_getmsg('mfg3119',g_lang) RETURNING l_buf
     #DISPLAY l_buf AT 4,1   #CHI-A70049 mark
   END IF
 
   LET l_cnt1 = 0
   LET l_cnt2 = 0
   LET g_cnt = NULL
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH p454_cs INTO sr.*
      IF SQLCA.sqlcode THEN 
         IF g_bgerr THEN
#No.FUN-710030 -- begin -- 
#            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            CALL s_errmsg("","","foreach:",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('foreach:',SQLCA.sqlcode,1) 
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
      IF g_bgjob ='N' THEN    #NO.FUN-570138
         IF cl_null(g_cnt) THEN
            LET g_cnt = SQLCA.SQLERRD[3]
           DISPLAY g_cnt USING "###&" AT 1,17   
         END IF
         LET l_cnt1 = l_cnt1 + 1
        DISPLAY l_cnt1 USING "###&" AT 1,34 
      END IF                  #NO.FUN-570138
      OPEN p454_cl USING sr.pmk01
      IF STATUS THEN
#No.FUN-710030 -- begin --
#         CALL cl_err("OPEN p454_cl:", STATUS, 1)
         IF g_bgerr THEN
            CALL s_errmsg("","","","OPEN p454_cl:",1)
         ELSE
            CALL cl_err("OPEN p454_cl:", STATUS, 1)
         END IF
#No.FUN-710030 -- end --
         CLOSE p454_cl
         LET g_success = 'N'
#No.FUN-710030 -- begin --
#         EXIT FOREACH
         IF g_bgerr THEN
            CONTINUE FOREACH
         ELSE
            EXIT FOREACH
         END IF
#No.FUN-710030 -- end --
      END IF
 
      FETCH p454_cl INTO sr.pmk01,sr.pmk02,sr.pmk04,sr.pmk09,sr.pmk25
      IF STATUS THEN
#No.FUN-710030 -- begin --
#         CALL cl_err("FETCH p454_cl:", STATUS, 1)
         IF g_bgerr THEN
            CALL s_errmsg("","","FETCH p454_cl:",STATUS,1)
         ELSE
            CALL cl_err("FETCH p454_cl:", STATUS, 1)
         END IF
#No.FUN-710030 -- end --
         CLOSE p454_cl
         LET g_success = 'N'
#No.FUN-710030 -- begin --
#         EXIT FOREACH
         IF g_bgerr THEN
            CONTINUE FOREACH
         ELSE
            EXIT FOREACH
         END IF
#No.FUN-710030 -- end --
 
      END IF
 
      IF sr.pmk09 IS NULL THEN LET sr.pmk09 = ' ' END IF
         CALL s_pmksta('pmk',sr.pmk25,' ',' ') RETURNING sr.pmk25
         IF tm.y = 'N' THEN 
            LET g_chr = 'Y'
            IF g_bgjob = 'N' THEN  #NO.FUN-570138
               MESSAGE sr.pmk01,' ',sr.pmk04,' ',sr.pmk02,' ',sr.pmk09,' ',sr.pmk25
               CALL ui.Interface.refresh()
            END IF
         ELSE 
            LET g_chr = ' '
            WHILE g_chr NOT MATCHES "[YyNn]" OR g_chr IS NULL
               IF g_bgjob ='N' THEN  #NO.FUN-570138
                  PROMPT sr.pmk01,' ',sr.pmk04,' ',sr.pmk02,' ', 
                         sr.pmk09,' ',sr.pmk25,'     '
                     FOR CHAR g_chr
                  IF INT_FLAG THEN
                     LET g_success = 'N'
                     EXIT WHILE    
                  END IF
               END IF
            END WHILE
         IF g_success = 'N' THEN 
            EXIT FOREACH
         END IF 
      END IF
 
      IF g_chr MATCHES "[Yy]" THEN
         DELETE FROM pmk_file WHERE pmk01 = sr.pmk01   #刪除請購單頭
         IF SQLCA.sqlcode THEN 
            LET g_success = 'N'
#            CALL cl_err('delete pmk_file error',SQLCA.sqlcode,1)
#No.FUN-710030 -- begin --
#            CALL cl_err3("del","pmk_file","","",SQLCA.sqlcode,"","delete pmk_file error",1)  #No.FUN-660129
#            EXIT FOREACH
            IF g_bgerr THEN
               CALL s_errmsg("pmk01","sr.pmk01","delete pmk_file error",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("del","pmk_file","pmk01",sr.pmk01,SQLCA.sqlcode,"","delete pmk_file error",1)
               EXIT FOREACH
            END IF
#No.FUN-710030 -- end --
         END IF
         DELETE FROM pml_file WHERE pml01 = sr.pmk01       #刪除請購單身
         IF SQLCA.sqlcode THEN  
            LET g_success = 'N'
#No.FUN-710030 -- begin --
#            CALL cl_err('delete pml_file error',SQLCA.sqlcode,1)
#            EXIT FOREACH
            IF g_bgerr THEN
               CALL s_errmsg("pml01",sr.pmk01,"delete pml_file error",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("del","pml_file",sr.pmk01,"",SQLCA.sqlcode,"","delete pml_file error",1)
               EXIT FOREACH
            END IF
#No.FUN-710030 -- end --
         END IF
         #NO.FUN-7B0018 08/01/31 add --begin                             
         IF NOT s_industry('std') THEN                                   
            IF NOT s_del_pmli(sr.pmk01,'','') THEN              
               LET g_success = 'N'                                             
            END IF                                                       
         END IF                                                          
         #NO.FUN-7B0018 08/01/31 add --end
         DELETE FROM pnl_file WHERE pnl01 = sr.pmk01       #刪除請購單身
         IF SQLCA.sqlcode THEN  
            LET g_success = 'N'
#No.FUN-710030 -- begin --
#            CALL cl_err('delete pnl_file error',SQLCA.sqlcode,1)
#            EXIT FOREACH
            IF g_bgerr THEN
               CALL s_errmsg("pnl01",sr.pmk01,"delete pnl_file error",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("del","pnl_file",sr.pmk01,"",SQLCA.sqlcode,"","delete pnl_file error",1)
               EXIT FOREACH
            END IF
#No.FUN-710030 -- end --
         END IF
         DELETE FROM pmp_file WHERE pmp01 = sr.pmk01       #刪除請購備註
                                AND pmp02 matches '0'
         IF SQLCA.sqlcode THEN 
            LET g_success = 'N'
#No.FUN-710030 -- begin --
#            CALL cl_err('delete pmp_file error',SQLCA.sqlcode,1)
#            EXIT FOREACH
            IF g_bgerr THEN
               LET g_showmsg = sr.pmk01,"/","matches '0'"
               CALL s_errmsg("pmp01,pmp02",g_showmsg,"delete pmp_file error",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("del","pmp_file",sr.pmk01,"matches '0'",SQLCA.sqlcode,"","delete pmp_file error",1)
               EXIT FOREACH
            END IF
#No.FUN-710030 -- begin --
         END IF
         DELETE FROM pmo_file WHERE pmo01 = sr.pmk01       #刪除請購說明
         IF SQLCA.sqlcode THEN 
            LET g_success = 'N'
#No.FUN-710030 -- begin --
#            CALL cl_err('delete pmo_file error',SQLCA.sqlcode,1)
#            EXIT FOREACH
            IF g_bgerr THEN
               CALL s_errmsg("pmo01",sr.pmk01,"delete pmo_file error",SQLCA.sqlcode,1)
               CONTINUE FOREACH
            ELSE
               CALL cl_err3("del","pmo_file",sr.pmk01,"",SQLCA.sqlcode,"","delete pmo_file error",1)
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
      CLOSE p454_cl
   END FOREACH
#No.FUN-710030 -- begin --
   IF g_success="N" THEN
      LET g_totsuccess="N"
      LET g_success="Y"
   END IF
#No.FUN-710030 -- end --
 
   IF g_bgjob = 'N' THEN  #NO.FUN-570138
      CLOSE WINDOW p454_w2
   END IF
     
END FUNCTION

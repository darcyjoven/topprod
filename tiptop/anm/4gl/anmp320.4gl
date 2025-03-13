# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmp320.4gl
# Descriptions...: 銀行存款統計資料更新作業
# Date & Author..: 93/04/12 By Felicity Tseng
# Modify.........: No.9016 04/01/08 Kammy nme17 != 'Revalued' 判斷拿掉
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/08/28 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-710065 07/01/10 By Smapmin 修改年月Default值
# Modify.........: No.FUN-710024 07/01/15 By Jackho 增加修改單身批處理錯誤統整功能
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A70004 10/07/12 By Summer 增加aza63判斷使用s_azmm
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_nmp               RECORD LIKE nmp_file.*
DEFINE tm_wc,l_sql         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(100)
DEFINE g_flag              LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_last_yy,g_last_mm LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_this_yy,g_this_mm LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_next_yy,g_next_mm LIKE type_file.num5    #No.FUN-680107 SMALLINT
DEFINE g_bdate,g_edate     LIKE type_file.dat     #No.FUN-680107 DATE
DEFINE open_flag           LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1)
DEFINE g_bank              LIKE nmp_file.nmp01    #銀行編號
DEFINE l_flag              LIKE type_file.chr1,   #No.FUN-570127 #No.FUN-680107 VARCHAR(1)
       g_change_lang       LIKE type_file.chr1    #No.FUN-680107 VARCHAR(1) #是否有做語言切換 No.FUN-570127
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
MAIN
#     DEFINEl_time LIKE type_file.chr8                  #No.FUN-6A0082
 
     OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
#->No.FUN-570127 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_this_yy = ARG_VAL(1)                       #現行年度
   LET g_this_mm = ARG_VAL(2)                       #現行月份
   LET tm_wc   = ARG_VAL(3)                         #銀行編號
   LET g_bgjob = ARG_VAL(4)                #背景作業
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
#    OPEN WINDOW p320 AT p_row,p_col WITH FORM "anm/42f/anmp320"
#          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
#
#    CALL cl_opmsg('z')
#    CALL p320_ask()
#    CLOSE WINDOW p320
#NO.FUN-570127 mark--
 
#NO.FUN-570127 start--
   LET g_success = 'Y' 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p320_ask()
         IF cl_sure(18,20) THEN
            BEGIN WORK
            LET g_success = 'Y'
            CALL s_showmsg_init()   #No.FUN-710024
            CALL p320()
            CALL s_showmsg()        #No.FUN-710024
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
                 CLOSE WINDOW p320
                 EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         LET g_success = 'Y'
         CALL s_showmsg_init()   #No.FUN-710024
         CALL p320()
         CALL s_showmsg()        #No.FUN-710024
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
 
FUNCTION p320_ask()
   DEFINE   l_bdate   LIKE type_file.chr8    #No.FUN-680107 VARCHAR(8)
   DEFINE   l_year    LIKE nmp_file.nmp02
   DEFINE   lc_cmd    LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(500) #No.FUN-570127
 
#->No.FUN-570127 --start--
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p320 AT p_row,p_col WITH FORM "anm/42f/anmp320"
      ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
#->No.FUN-570127 ---end---
 
   WHILE TRUE
     #-----MOD-710065---------
     #LET g_this_yy = g_nmz.nmz41
     #LET g_this_mm = g_nmz.nmz42
     #DISPLAY g_nmz.nmz41, g_nmz.nmz42 TO y1,m1 
     LET g_this_yy = YEAR(g_today)
     LET g_this_mm = MONTH(g_today)
     DISPLAY g_this_yy,g_this_mm TO y1,m1 
     #-----END MOD-710065-----
     LET g_bgjob = "N"   #NO.FUN-570127
 
## No: 2400 modify 1998/08/18 ---------
     #INPUT BY NAME g_this_yy, g_this_mm WITHOUT DEFAULTS
     INPUT BY NAME g_this_yy, g_this_mm,g_bgjob  WITHOUT DEFAULTS  #NO.FUN-570127 
 
        AFTER FIELD g_this_yy   # 年度
           IF cl_null(g_this_yy) THEN
              CALL cl_err('','anm-089',0)
              NEXT FIELD g_this_yy
           END IF
 
        AFTER FIELD g_this_mm    # 月份
           IF cl_null(g_this_mm) THEN
              CALL cl_err('','anm-090',0)
              NEXT FIELD g_this_mm
           END IF
           IF (g_this_mm >13) OR (g_this_mm < 0) THEN
              CALL cl_err(g_this_mm,'anm-088',0)
              #LET g_this_mm = g_nmz.nmz42   #MOD-710065
              LET g_this_mm = MONTH(g_today)   #MOD-710065
              NEXT FIELD g_this_mm
           END IF
 
        AFTER INPUT
           IF cl_null(g_this_yy) THEN
              CALL cl_err('','anm-089',0)
              NEXT FIELD nmp02
           END IF
           IF cl_null(g_this_mm) THEN
              CALL cl_err('','anm-090',0)
              NEXT FIELD nmp03
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION locale                    #genero
#           LET g_action_choice = "locale"
            LET g_change_lang = TRUE   #NO.FUN-570127
           EXIT INPUT
 
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
 
     END INPUT
 
 #NO.FUN-570127 start--
#     IF g_action_choice = "locale" THEN  #genero
#        LET g_action_choice = ""
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()   #FUN-550037(smin)
#        CONTINUE WHILE
#     END IF
# 
#     IF INT_FLAG THEN
#        EXIT WHILE
#     END IF
     #->No.FUN-570127 --start--
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p320
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
#->No.FUN-570127 ---end---
 
## ----------------------------------
     CONSTRUCT BY NAME tm_wc ON nma01
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
           #CALL cl_dynamic_locale()
           #CALL cl_show_fld_cont()   #FUN-550037(smin)
           LET g_change_lang = TRUE     #NO.FUN-570127  
           EXIT CONSTRUCT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION exit  #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
     END CONSTRUCT
 
#NO.FUN-570127 start--
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p320
#        EXIT WHILE   #NO.FUN-570127
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
 
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "anmp320"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('anmp320','9031',1)   
        ELSE
           LET tm_wc=cl_replace_str(tm_wc, "'", "\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_this_yy CLIPPED ,"'",
                        " '",g_this_mm CLIPPED ,"'",
                        " '",tm_wc CLIPPED ,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('anmp320',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p320
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
        EXIT PROGRAM
     END IF
    EXIT WHILE
#NO.FUN-570127 END-----
 
#NO.FUN-570127 mark---
#     CALL p320()
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
#   END WHILE
#NO.FUN-570127 mark--
END WHILE 
END FUNCTION
 
FUNCTION p320()
  DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680107 SMALLINT
 
     IF g_this_mm > 1 THEN
        LET g_last_yy = g_this_yy
        LET g_last_mm = g_this_mm - 1
     ELSE
        LET g_last_yy = g_this_yy - 1
        IF g_aza.aza02 = '1' THEN
           LET g_last_mm = 12
        ELSE
           LET g_last_mm = 13
        END IF
     END IF
 
#     LET g_success = 'Y'                  #No.FUN-710024 mark  
 
     #CALL s_azm(g_this_yy,g_this_mm) RETURNING g_flag,g_bdate,g_edate #CHI-A70004 mark
     #CHI-A70004 add --start--
     IF g_aza.aza63 = 'Y' THEN
        CALL s_azmm(g_this_yy,g_this_mm,g_nmz.nmz02p,g_nmz.nmz02b) RETURNING g_flag,g_bdate,g_edate
     ELSE
        CALL s_azm(g_this_yy,g_this_mm) RETURNING g_flag,g_bdate,g_edate
     END IF
     #CHI-A70004 add --end--
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm_wc = tm_wc clipped," AND nmauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm_wc = tm_wc clipped," AND nmagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm_wc = tm_wc clipped," AND nmagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('nmauser', 'nmagrup')
     #End:FUN-980030
 
     LET l_sql = "SELECT nma01 FROM nma_file ",
                 " WHERE ",tm_wc CLIPPED
     PREPARE p320_p1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
 
     DECLARE p320_c1 CURSOR FOR p320_p1
     IF SQLCA.sqlcode THEN
        CALL cl_err('ceclare p320_c1:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
 
#     BEGIN WORK             #No.FUN-710024 mark
 
     LET l_cnt = 0
     FOREACH p320_c1 INTO g_bank
#No.FUN-710024--begin
       IF g_success='N' THEN                                                                                                          
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF             
       IF SQLCA.sqlcode THEN
#          CALL cl_err('p320_c1',SQLCA.sqlcode,0)
          CALL s_errmsg('','','p320_c1',SQLCA.sqlcode,0)
          LET g_success = 'N'
#          EXIT FOREACH
          CONTINUE FOREACH
#No.FUN-710024--end  
       END IF
       #-->刪除時必需以
       DELETE FROM nmp_file WHERE nmp01 = g_bank
                              AND nmp02 = g_this_yy AND nmp03 = g_this_mm
       INITIALIZE g_nmp.* TO NULL
       IF g_bgjob='N' THEN
           MESSAGE 'fetch bank:',g_bank
           CALL ui.Interface.refresh()
       END IF
       CALL p320_open()	# 若有期初開帳則以期初為準
       LET l_cnt = l_cnt + 1
       IF open_flag='Y' THEN CONTINUE FOREACH END IF
       CALL p320_last_saving()	#-> 6,9 16,19
       CALL p320_this_dc_tot()	#-> 4,5 7,8 14,15 17,18
       LET g_nmp.nmp06 = g_nmp.nmp06 + g_nmp.nmp04 - g_nmp.nmp05
       LET g_nmp.nmp09 = g_nmp.nmp09 + g_nmp.nmp07 - g_nmp.nmp08
       LET g_nmp.nmp16 = g_nmp.nmp16 + g_nmp.nmp14 - g_nmp.nmp15
       LET g_nmp.nmp19 = g_nmp.nmp19 + g_nmp.nmp17 - g_nmp.nmp18
       LET g_nmp.nmp01 = g_bank
       LET g_nmp.nmp02 = g_this_yy LET g_nmp.nmp03 = g_this_mm
 
       #FUN-980005 add legal 
       LET g_nmp.nmplegal = g_legal 
       #FUN-980005 end legal 
 
       INSERT INTO nmp_file VALUES (g_nmp.*)
       IF SQLCA.sqlcode  THEN
#         CALL cl_err('ins nmp',STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin  
#          CALL cl_err3("ins","nmp_file",g_nmp.nmp01,g_nmp.nmp02,STATUS,"","ins nmp",1) #No.FUN-660148
          LET g_showmsg=g_nmp.nmp01,"/",g_nmp.nmp02,"/",g_nmp.nmp03
          CALL s_errmsg('nmp01,nmp02,nmp03',g_showmsg,'ins nmp',STATUS,1)
          LET g_success = 'N'
#          EXIT FOREACH
          CONTINUE FOREACH
#No.FUN-710024--end  
       END IF
    END FOREACH
#No.FUN-710024--begin
    IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
    END IF 
#No.FUN-710024--end 
 
    LET g_next_yy = g_this_yy
    LET g_next_mm = g_this_mm + 1
    IF (g_aza.aza02 = '1' AND g_next_mm > 12) OR
       (g_aza.aza02 = '2' AND g_next_mm > 13)     THEN
       LET g_next_yy = g_next_yy + 1
       LET g_next_mm = 1
    END IF
    IF l_cnt = 0 THEN
#       CALL cl_err('','aap-129',1)                     #No.FUN-710024
      CALL s_errmsg('','','','aap-129',1)               #No.FUN-710024 
      LET g_success = 'N'
    END IF
 
END FUNCTION
 
FUNCTION p320_open()
   DEFINE l_npg RECORD LIKE npg_file.*
   LET open_flag='N'
   SELECT * INTO l_npg.* FROM npg_file
          WHERE npg01=g_bank AND npg02=g_this_yy AND npg03=g_this_mm
   IF STATUS THEN RETURN END IF
   LET open_flag='Y'
   LET g_nmp.nmp01=l_npg.npg01
   LET g_nmp.nmp02=l_npg.npg02
   LET g_nmp.nmp03=l_npg.npg03
   LET g_nmp.nmp04=0
   LET g_nmp.nmp05=0
   LET g_nmp.nmp06=l_npg.npg06
   LET g_nmp.nmp07=0
   LET g_nmp.nmp08=0
   LET g_nmp.nmp09=l_npg.npg09
   LET g_nmp.nmp14=0
   LET g_nmp.nmp15=0
   LET g_nmp.nmp16=l_npg.npg16
   LET g_nmp.nmp17=0
   LET g_nmp.nmp18=0
   LET g_nmp.nmp19=l_npg.npg19
 
   #FUN-980005 add legal 
   LET g_nmp.nmplegal = g_legal 
   #FUN-980005 end legal 
 
   INSERT INTO nmp_file VALUES(g_nmp.*)
END FUNCTION
 
FUNCTION p320_last_saving()
       SELECT * INTO g_nmp.* FROM nmp_file
             WHERE nmp01 = g_bank AND nmp02 = g_last_yy AND nmp03 = g_last_mm
       IF STATUS THEN
          LET g_nmp.nmp06 = 0 LET g_nmp.nmp09 = 0
          LET g_nmp.nmp16 = 0 LET g_nmp.nmp19 = 0
       END IF
END FUNCTION
 
FUNCTION p320_this_dc_tot()
       SELECT SUM(nme04),SUM(nme08) INTO g_nmp.nmp04,g_nmp.nmp07
              FROM nme_file, nmc_file
             WHERE nme01 = g_bank AND nme03 = nmc01 AND nmc03 = '1'
               AND nme02 BETWEEN g_bdate AND g_edate
             #No:9016
             # AND nme17 != 'Revalued'     #A048
       SELECT SUM(nme04),SUM(nme08) INTO g_nmp.nmp05,g_nmp.nmp08
              FROM nme_file, nmc_file
             WHERE nme01 = g_bank AND nme03 = nmc01 AND nmc03 = '2'
               AND nme02 BETWEEN g_bdate AND g_edate
             # AND nme17 != 'Revalued'     #A048  No:9016 mark
       SELECT SUM(nme04),SUM(nme08) INTO g_nmp.nmp14,g_nmp.nmp17
              FROM nme_file, nmc_file
             WHERE nme01 = g_bank AND nme03 = nmc01 AND nmc03 = '1'
               AND nme16 BETWEEN g_bdate AND g_edate
              #AND nme17 != 'Revalued'     #A048  No:9016 mark
       SELECT SUM(nme04),SUM(nme08) INTO g_nmp.nmp15,g_nmp.nmp18
              FROM nme_file, nmc_file
             WHERE nme01 = g_bank AND nme03 = nmc01 AND nmc03 = '2'
               AND nme16 BETWEEN g_bdate AND g_edate
             # AND nme17 != 'Revalued'     #A048   No:9016 mark
       IF g_nmp.nmp04 IS NULL THEN LET g_nmp.nmp04 = 0 END IF
       IF g_nmp.nmp05 IS NULL THEN LET g_nmp.nmp05 = 0 END IF
       IF g_nmp.nmp07 IS NULL THEN LET g_nmp.nmp07 = 0 END IF
       IF g_nmp.nmp08 IS NULL THEN LET g_nmp.nmp08 = 0 END IF
       IF g_nmp.nmp14 IS NULL THEN LET g_nmp.nmp14 = 0 END IF
       IF g_nmp.nmp15 IS NULL THEN LET g_nmp.nmp15 = 0 END IF
       IF g_nmp.nmp17 IS NULL THEN LET g_nmp.nmp17 = 0 END IF
       IF g_nmp.nmp18 IS NULL THEN LET g_nmp.nmp18 = 0 END IF
END FUNCTION

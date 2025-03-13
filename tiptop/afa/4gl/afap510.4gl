# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: afap510.4gl
# Descriptions...: 保費計算作業              
# Date & Author..: 97/08/26 By Sophia
# Modify.........: No.MOD-490179 04/09/22 By Yuna afat500已確認的單子才可執行保費計算作業
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/09/08 By day 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/06 By Rayven 語言切換時，程序自動運行保費作業，且報錯
# Modify.........: No.FUN-710028 07/01/22 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-750104 07/05/21 By rainy 科目二未代入
# Modify.........: No.CHI-790004 07/09/03 By kim 新增段PK值不可為NULL
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc       string,  #No.FUN-580092 HCN
       tm         RECORD
                  nowy  LIKE type_file.num5,       #No.FUN-680070 SMALLINT
                  nowm  LIKE type_file.num5        #No.FUN-680070 SMALLINT
                  END RECORD,
       g_fac           LIKE type_file.num20_6      #No.FUN-680070 DEC(16,8)
DEFINE p_row,p_col     LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE g_flag          LIKE type_file.chr1,        #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1         #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
 
MAIN
#     DEFINEl_time LIKE type_file.chr8              #No.FUN-6A0069
 
    OPTIONS
       INPUT NO WRAP
    DEFER INTERRUPT                                # Supress DEL key function
 
    #->No.FUN-570144 --start--
    INITIALIZE g_bgjob_msgfile TO NULL
    LET g_wc     = ARG_VAL(1)
    LET tm.nowy  = ARG_VAL(2)
    LET tm.nowm  = ARG_VAL(3)
    LET g_bgjob = ARG_VAL(4)    #背景作業
    IF cl_null(g_bgjob) THEN
       LET g_bgjob = "N"
    END IF
    #->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
#NO.FUN-570144 MARK--
#    IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
#         LET p_row = 6 LET p_col = 35
#    ELSE LET p_row = 6 LET p_col = 14
#    END IF       
#    OPEN WINDOW p510_w AT p_row,p_col
#         WITH FORM "afa/42f/afap510" 
#################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570144 MARK---
 
    CALL cl_opmsg('p')
#NO.FUN-570144 START---
    SELECT faa07,faa08 INTO tm.nowy,tm.nowm FROM faa_file
        WHERE faa00='0'
    LET g_success = 'Y'
    WHILE TRUE
     IF g_bgjob = "N" THEN
       CALL p510_i()
       IF cl_sure(18,20) THEN
          LET g_success = 'Y'
          BEGIN WORK
          CALL p510_go()
          CALL s_showmsg()   #No.FUN-710028
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING g_flag
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING g_flag
          END IF
         IF g_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p510_w
            EXIT WHILE
         END IF
     ELSE
         CONTINUE WHILE
     END IF
   ELSE
     BEGIN WORK
     LET g_success = 'Y'
     CALL p510_go()
     CALL s_showmsg()   #No.FUN-710028
      IF g_success = "Y" THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     CALL cl_batch_bg_javamail(g_success)
     EXIT WHILE
    END IF
  END WHILE
#->No.FUN-570144 ---end---
#NO.FUN-570144 MARK-------
#       CALL p510_i()
#       IF INT_FLAG THEN
#          LET INT_FLAG = 0
#          EXIT WHILE
#       END IF
#    END WHILE
#    CLOSE WINDOW p510_w
#NO.FUN-570144 MARK-------
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
#輸入基本條件 
FUNCTION p510_i()  
   DEFINE   l_cnt   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            mm      LIKE type_file.num5         #No.FUN-680070 SMALLINT
 
   DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
   #->No.FUN-570144 --start--
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p510_w AT p_row,p_col WITH FORM "afa/42f/afap510"
     ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   #->No.FUN-570144 ---end---
 
   IF s_shut(0) THEN
      RETURN
   END IF 
 
   CLEAR FORM
 WHILE TRUE  #NO.FUN-570144 
   
   CONSTRUCT BY NAME g_wc ON fdc01  
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
        #->No.FUN-570144 --start--
#           LET g_change_lang = TRUE          #No.TQC-6C0009 mark
            CALL cl_dynamic_locale()          #No.TQC-6C0009 取消mark
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf #No.TQC-6C0009 取消mark
         #  LET g_action_choice = "locale"
        #->No.FUN-570144 ---end---
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
 
  
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
  END CONSTRUCT
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
#NO.FUN-570144 START----
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT WHILE
      END IF
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#      #   CONTINUE WHILE
#          RETURN
#      END IF
 
   IF INT_FLAG THEN
      CLOSE WINDOW p110_w   #NO.FUN-570144 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM          #NO.FUN-570144
      #RETURN               #NO.FUN-570144 
   END IF
   IF g_wc IS NULL THEN 
      LET g_wc=' 1=1'
   END IF
   SELECT faa07,faa08 INTO tm.nowy,tm.nowm FROM faa_file
    WHERE faa00='0'
 
   LET g_bgjob = 'N'  #NO.FUN-570144 
   #INPUT BY NAME tm.nowy,tm.nowm WITHOUT DEFAULTS 
   INPUT BY NAME tm.nowy,tm.nowm,g_bgjob  WITHOUT DEFAULTS   #NO.FUN-570144 
 
      AFTER FIELD nowy
         IF cl_null(tm.nowy) THEN
            NEXT FIELD nowy
         END IF
 
      AFTER FIELD nowm
         IF cl_null(tm.nowm) THEN
            NEXT FIELD nowm
         END IF
         IF tm.nowm > 12 OR tm.nowm < 1 THEN NEXT FIELD nowm END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION locale
      #->No.FUN-570144 --start--
         LET g_change_lang = TRUE
      #->No.FUN-570144 ---end---
            EXIT INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
  
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
#->No.FUN-570144 --start--
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin) #NO.FUN-570112 MARK
         CONTINUE WHILE
      END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
#   IF INT_FLAG THEN 
#      RETURN
#   END IF
#   IF NOT cl_confirm('afa-347') THEN
#      RETURN
#   ELSE
#      CALL p510_go()
#   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap510'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap510','9031',1)   
      ELSE
         LET g_wc = cl_replace_str(g_wc,"'","\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",tm.nowy CLIPPED,"'",
                      " '",tm.nowm CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('afap510',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p510_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   EXIT WHILE
 END WHILE
#NO.FUN-570144 END--------
END FUNCTION
 
FUNCTION p510_go()
DEFINE l_cnt         LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE l_sql,l_buf      LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(1000)
DEFINE l_succ           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
DEFINE l_flag           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
DEFINE yy,mm            LIKE type_file.num10        #No.FUN-680070 INTEGER
DEFINE l_fda03,l_fda04  LIKE fda_file.fda03,        #No.FUN-680070 DATE
       l_no,l_mon,l_yy  LIKE type_file.num5,        #No.FUN-680070 SMALLINT
       l_fdd05,t_fdd05  LIKE fdd_file.fdd05, 
       sum_fdd05        LIKE fdd_file.fdd05, 
       sum1_fdd05       LIKE fdd_file.fdd05, 
       sum2_fdd05       LIKE fdd_file.fdd05, 
       l_fdd08          LIKE fdd_file.fdd08,
       l_fdd09          LIKE fdd_file.fdd09,
       l_fdd081         LIKE fdd_file.fdd081,       #No.FUN-680028
       l_fdd091         LIKE fdd_file.fdd091        #No.FUN-680028
DEFINE l_fdc            RECORD LIKE fdc_file.*
DEFINE l_fdd            RECORD LIKE fdd_file.*
DEFINE l_fdaconf        LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
 
    LET l_sql ="SELECT * FROM fdc_file",
               " WHERE (fdc04 !='0' or fdc04 is not null) ",
               " and ", g_wc CLIPPED
 
    PREPARE afap510_prepare FROM l_sql
    IF status THEN CALL cl_err('Prepare #1',status,1) RETURN END IF
    DECLARE afap510_curs CURSOR WITH HOLD FOR afap510_prepare
 
    LET l_no = 0
    BEGIN WORK
    LET g_success = 'Y'
    CALL s_showmsg_init()   #No.FUN-710028
    FOREACH afap510_curs INTO l_fdc.*
       IF status THEN 
#         CALL cl_err('foreach: #1',status,1)         #No.FUN-710028
          CALL s_errmsg('','','foreach: #1',status,1) #No.FUN-710028
          LET g_success = 'N'                         #No.FUN-8A0086
          EXIT FOREACH 
       END IF
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 -end
 
        #--No.MOD-490179
       SELECT fdaconf INTO l_fdaconf FROM fda_file where fda01=l_fdc.fdc01
       IF l_fdaconf = 'N' THEN
          CONTINUE FOREACH
       END IF
       #--END
       IF g_bgjob = 'N' THEN   #FUN-570144
           message l_fdc.fdc01,'-',l_fdc.fdc02,'-',l_fdc.fdc03,'-',l_fdc.fdc032
           CALL ui.Interface.refresh()
       END IF
       LET l_no = l_no + 1
       SELECT fda03,fda04 INTO l_fda03,l_fda04 FROM fda_file
        WHERE fda01 = l_fdc.fdc01
       #--若輸入的年月資料已存在,DELETE重新產生
        SELECT * INTO l_fdd.* FROM fdd_file
         WHERE fdd01 = l_fdc.fdc01
           AND fdd02 = l_fdc.fdc03
           AND fdd022 = l_fdc.fdc032
           AND fdd03 = tm.nowy
           AND fdd033= tm.nowm
        IF NOT cl_null(l_fdd.fdd06) AND NOT cl_null(l_fdd.fdd07) THEN
           CONTINUE FOREACH
        END IF
        IF STATUS <> 100 THEN 
           DELETE FROM fdd_file WHERE fdd01 = l_fdc.fdc01
                                  AND fdd02 = l_fdc.fdc03
                                  AND fdd022 = l_fdc.fdc032
                                  AND fdd03 = tm.nowy
                                  AND fdd033= tm.nowm
           IF STATUS THEN
#             CALL cl_err('del fdd',STATUS,0)   #No.FUN-660136
#             CALL cl_err3("del","fdd_file",l_fdc.fdc01,l_fdc.fdc02,STATUS,"","del fdd",0)         #No.FUN-660136
              LET g_showmsg = l_fdc.fdc01,"/",l_fdc.fdc03,"/",l_fdc.fdc032,"/",tm.nowy,"/",tm.nowm #No.FUN-710028
              CALL s_errmsg('fdd01,fdd02,fdd022,fdd03,fdd033',g_showmsg,'del fdd',STATUS,1)        #No.FUN-710028
              LET g_success = 'N'
#             EXIT FOREACH       #No.FUN-710028
              CONTINUE FOREACH   #No.FUN-710028
           END IF
        END IF
       #-----保費計算-----
        LET l_mon = 0
        LET l_yy = 0
        IF YEAR(l_fda04) = YEAR(l_fda03) THEN   #同一年
           LET l_mon = MONTH(l_fda04) - MONTH(l_fda03) + 1
        ELSE    #不同年
           LET l_yy = YEAR(l_fda04) - YEAR(l_fda03)
           IF DAY(l_fda03) > 15 THEN
             LET l_mon = (12-MONTH(l_fda03))+(l_yy-1)*12 + MONTH(l_fda04)
           ELSE
             LET l_mon = (12-MONTH(l_fda03)+1)+(l_yy-1)*12 + MONTH(l_fda04)
           END IF
        END IF
        LET l_fdd05 = l_fdc.fdc09 / l_mon  #保險期間
        IF cl_null(l_fdd05) THEN LET l_fdd05 = 0 END IF
 
        #---若已攤到最後一個月......(modify by kammy in 99/05/31)---#
        IF tm.nowy=YEAR(l_fda04) AND tm.nowm=MONTH(l_fda04) THEN
 
           IF YEAR(l_fda04) = YEAR(l_fda03) THEN                   #同一年
              SELECT SUM(fdd05) INTO sum_fdd05 FROM fdd_file 
               WHERE fdd01 = l_fdc.fdc01 AND fdd02 = l_fdc.fdc03
                 AND fdd022 = l_fdc.fdc032
                 AND fdd03 = YEAR(l_fda04)
                 AND fdd033 < MONTH(l_fda04) 
                 AND fdd033 >= MONTH(l_fda03)
              IF cl_null(sum_fdd05) THEN LET sum_fdd05 = 0 END IF
           ELSE                                                     #不同年
              SELECT SUM(fdd05) INTO sum1_fdd05 FROM fdd_file
               WHERE fdd01 = l_fdc.fdc01 AND fdd02 = l_fdc.fdc03
                 AND fdd022 = l_fdc.fdc032
                 AND fdd03 = YEAR(l_fda03)
                 AND fdd033 >= MONTH(l_fda03)
              IF cl_null(sum1_fdd05) THEN LET sum1_fdd05 = 0 END IF
              SELECT SUM(fdd05) INTO sum2_fdd05 FROM fdd_file
               WHERE fdd01 = l_fdc.fdc01 AND fdd02 = l_fdc.fdc03
                 AND fdd022 = l_fdc.fdc032
                 AND fdd03 = YEAR(l_fda04)
                 AND fdd033 < MONTH(l_fda04)
              IF cl_null(sum2_fdd05) THEN LET sum2_fdd05 = 0 END IF
 
              LET sum_fdd05 = sum1_fdd05 + sum2_fdd05
 
           END IF
           LET l_fdd05 = l_fdc.fdc09 - sum_fdd05
        END IF
        #-----------------------------------------------------------#
        CALL cl_digcut(l_fdd05,g_azi04) RETURNING l_fdd05 
 
 
        SELECT fbz13,fbz14 INTO l_fdd08,l_fdd09 FROM fbz_file WHERE fbz00='0'
 
        #CHI-790004..................begin
        IF cl_null(l_fdc.fdc032) THEN
           LET l_fdc.fdc032=' '
        END IF
        #CHI-790004..................end
        INSERT INTO fdd_file (fdd01,fdd02,fdd022,fdd03,fdd033,fdd04,fdd05,
                              fdd08,fdd09,fdduser,fddgrup,fddmodu,fdddate,
                              fddlegal,fddoriu,fddorig) #FUN-980003 add
                      VALUES (l_fdc.fdc01,l_fdc.fdc03,l_fdc.fdc032,tm.nowy,
                              tm.nowm,l_fdc.fdc05,l_fdd05,l_fdd08,l_fdd09,
                              g_user,g_grup,g_user,g_today,
                              g_legal, g_user, g_grup) #FUN-980003 add      #No.FUN-980030 10/01/04  insert columns oriu, orig
        IF STATUS THEN
#          CALL cl_err('ins fdd',STATUS,0)   #No.FUN-660136
#          CALL cl_err3("ins","fdd_file",l_fdc.fdc01,l_fdc.fdc03,STATUS,"","ins fdd",0)         #No.FUN-660136 #No.FUN-710028
           LET g_showmsg = l_fdc.fdc01,"/",l_fdc.fdc03,"/",l_fdc.fdc032,"/",tm.nowy,"/",tm.nowm #No.FUN-710028
           CALL s_errmsg('fdd01,fdd02,fdd022,fdd03,fdd033',g_showmsg,'ins fdd',STATUS,1)        #No.FUN-710028
           LET g_success = 'N'
#          EXIT FOREACH       #No.FUN-710028
           CONTINUE FOREACH   #No.FUN-710028
        END IF
        #No.FUN-680028--begin
 #      IF g_aza.aza63 = 'Y' THEN  
        IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 
           SELECT fbz131,fbz141 INTO l_fdd081,l_fdd091 FROM fbz_file WHERE fbz00='0'
         #TQC-750104 begin
           #UPDATE fdd_file SET fdd081 = l_fdd081,
           #                    fdd091 = l_fdd091
           # WHERE fdd01 = l_fdc.fdc01
           #   AND fdd02 = l_fdc.fdc03
           #   AND fdd022= l_fdc.fdc032
           #   AND fdd03 = tm.nowy 
           #   AND fdd033= tm.nowm 
 
           LET l_sql = "UPDATE fdd_file SET fdd081 ='", l_fdd081 ,"'",
                       "                   ,fdd091 ='", l_fdd091 ,"'",
                       " WHERE fdd01 ='", l_fdc.fdc01 ,"'",
                       "   AND fdd02 ='", l_fdc.fdc03 ,"'"
           IF cl_null(l_fdc.fdc032) THEN
             LET l_sql = l_sql,"   AND fdd022 IS NULL "
           ELSE
             LET l_sql = l_sql,"   AND fdd022 ='", l_fdc.fdc032,"'"
           END IF
           LET l_sql = l_sql ,"   AND fdd03 =", tm.nowy ,
                              "   AND fdd033=", tm.nowm 
           PREPARE p510_upd_pre FROM l_sql
           EXECUTE p510_upd_pre
         #TQC-750104 end
           IF STATUS THEN
#             CALL cl_err3("upd","fdd_file",l_fdc.fdc01,l_fdc.fdc03,STATUS,"","upd fdd",0)         #No.FUN-710028
              LET g_showmsg = l_fdc.fdc01,"/",l_fdc.fdc03,"/",l_fdc.fdc032,"/",tm.nowy,"/",tm.nowm #No.FUN-710028
              CALL s_errmsg('fdd01,fdd02,fdd022,fdd03,fdd033',g_showmsg,'upd fdd',STATUS,1)        #No.FUN-710028
              LET g_success = 'N'
#             EXIT FOREACH       #No.FUN-710028
              CONTINUE FOREACH   #No.FUN-710028
           END IF
        END IF
        #No.FUN-680028--end  
       #------更新保險單身檔(fdc_file)
         #---更新已攤保費
         SELECT SUM(fdd05) INTO t_fdd05 FROM fdd_file
          WHERE fdd01 = l_fdc.fdc01
            AND fdd02 = l_fdc.fdc03
            AND fdd022 = l_fdc.fdc032
         #  AND ((fdd03 = tm.nowy AND fdd033 < tm.nowm)
         #    OR (fdd03 <> tm.nowy AND fdd03 < tm.nowy))
            AND ((fdd03 = tm.nowy AND fdd033 <= tm.nowm)
              OR (fdd03 <> tm.nowy AND fdd03 <= tm.nowy))
         IF cl_null(t_fdd05) THEN LET t_fdd05 = 0 END IF 
         LET t_fdd05 = cl_digcut(t_fdd05,g_azi04)
        UPDATE fdc_file SET fdc11 = t_fdd05
         WHERE fdc01 = l_fdc.fdc01
           AND fdc02 = l_fdc.fdc02
           AND fdc03 = l_fdc.fdc03
           AND fdc032 = l_fdc.fdc032 
         IF STATUS THEN
#           CALL cl_err('upd fdc11',STATUS,0)   #No.FUN-660136
#           CALL cl_err3("upd","fdc_file",l_fdc.fdc01,l_fdc.fdc02,STATUS,"","upd fdc11",0)   #No.FUN-660136 #No.FUN-710028
            LET g_showmsg = l_fdc.fdc01,"/",l_fdc.fdc02,"/",l_fdc.fdc03,"/",l_fdc.fdc032     #No.FUN-710028
            CALL s_errmsg('fdc01,fdc02,fdc03,fdc032',g_showmsg,'upd fdc11',STATUS,1)         #No.FUN-710028
            LET g_success = 'N'
         END IF
       #---更新預付保險費----
        UPDATE fdc_file SET fdc10 = fdc09 - fdc11
         WHERE fdc01 = l_fdc.fdc01
           AND fdc02 = l_fdc.fdc02
           AND fdc03 = l_fdc.fdc03
           AND fdc032 = l_fdc.fdc032 
         IF STATUS THEN
#           CALL cl_err('upd fdc10',STATUS,0)   #No.FUN-660136
#           CALL cl_err3("upd","fdc_file",l_fdc.fdc01,l_fdc.fdc02,STATUS,"","upd fdc10",0)   #No.FUN-660136 #No.FUN-710028
            LET g_showmsg = l_fdc.fdc01,"/",l_fdc.fdc02,"/",l_fdc.fdc03,"/",l_fdc.fdc032     #No.FUN-710028
            CALL s_errmsg('fdc01,fdc02,fdc03,fdc032',g_showmsg,'upd fdc10',STATUS,1)         #No.FUN-710028
            LET g_success = 'N'
#           EXIT FOREACH       #No.FUN-710028
            CONTINUE FOREACH   #No.FUN-710028
         END IF
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
#NO.FUN-570144 MARK---
#    IF g_success = 'Y' THEN 
#       COMMIT WORK 
#       #CALL cl_cmmsg(1)
#       CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#    ELSE 
#       ROLLBACK WORK 
#       #CALL cl_rbmsg(1)
#       CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#    END IF
#NO.FUN-570144 MARK--
  # IF status THEN CALL cl_err('foreach #1',status,1) END IF
  # ERROR ""
  #  CALL cl_end(0,0)
    
END FUNCTION

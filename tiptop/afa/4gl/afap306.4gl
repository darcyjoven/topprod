# Prog. Version..: '5.30.06-13.03.12(00010)'        #
#
# Pattern name...: afap306.4gl
# Descriptions...: 本期銷帳累折重計作業
# Date & Author..: 97/06/28 By Star
# Modify.........: No.MOD-570257 05/07/28 By Smapmin 將"調整"也納入本期累折
# Modify.........: No.FUN-570144 06/03/06 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-680070 06/09/13 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710028 07/01/19 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:CHI-A60036 10/07/12 By Summer 過帳檢查改用s_azmm,增加aza63判斷
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:FUN-BB0114 11/11/22 By minpp 處理財簽二重測BUG 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string,  #No.FUN-580092 HCN
       g_yy,g_mm        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       b_date,e_date    LIKE type_file.dat,          #No.FUN-680070 DATE
       g_a,g_b          LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_dc             LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_amt1,g_amt2    LIKE type_file.num20_6,      #No.FUN-680070 DECIMAL(20,6)
       g_foo            RECORD LIKE foo_file.*,
       g_faa07,g_faa08  LIKE faa_file.faa07         #No.FUN-680070 SMALLINT
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE l_flag           LIKE type_file.chr1,                 #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
       g_change_lang    LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
 
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE g_bookno1        LIKE aza_file.aza81       #CHI-A60036 add
DEFINE g_bookno2        LIKE aza_file.aza82       #CHI-A60036 add
DEFINE g_flag           LIKE type_file.chr1       #CHI-A60036 add

MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0069
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)             #QBE條件
   LET g_yy    = ARG_VAL(2)
   LET g_mm    = ARG_VAL(3)
   LET g_a     = ARG_VAL(4)
   LET g_b     = ARG_VAL(5)
   LET g_bgjob = ARG_VAL(6)                    #背景作業
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
 
#NO.FUN-570144 MARK--
#   OPEN WINDOW p306_w AT p_row,p_col WITH FORM "afa/42f/afap306"
################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570144 MARK--                              
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
  #->No.FUN-570144 --start--
WHILE TRUE
   IF g_bgjob = "N" THEN
      CALL p306()
      IF cl_sure(18,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL p306_1()
         CALL s_showmsg()   #No.FUN-710028
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
            CLOSE WINDOW p306_w
            EXIT WHILE
         END IF
      ELSE
       CONTINUE WHILE
      END IF
   ELSE
      LET g_success = 'Y'
      BEGIN WORK
      CALL p306_1()
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
  #->No.FUN-570144 --start--
 
#   CALL p306()  #NO.FUN-570144 MARK
#   CLOSE WINDOW p306_w   #NO.FUN-570144 MARK
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p306()
   DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
   #->No.FUN-570144 --start--
   LET p_row = 5 LET p_col = 28
 
   OPEN WINDOW p306_w AT p_row,p_col WITH FORM "afa/42f/afap306"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('p')
 
   #->No.FUN-570144 ---end---
 
   CLEAR FORM
   SELECT faa07,faa08 INTO g_faa07,g_faa08 FROM faa_file
   LET g_yy=g_faa07  LET g_mm=g_faa08
   LET g_a = 'Y' LET g_b = 'Y' 
   DISPLAY g_yy TO FORMONLY.g_yy 
   DISPLAY g_mm TO FORMONLY.g_mm 
   DISPLAY g_a TO FORMONLY.g_a 
   DISPLAY g_b TO FORMONLY.g_b 
   CALL cl_opmsg('p')
 
   WHILE TRUE  #NO.FUN-570144
   CONSTRUCT BY NAME g_wc ON faj04,faj05,faj02,faj022 
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
     ON ACTION locale
        #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        #LET g_action_choice = "locale"
        LET g_change_lang = TRUE                   #->No.FUN-570144
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
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
#NO.FUN-570144 start--
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
#         CALL cl_dynamic_locale()
#       #  CONTINUE WHILE
#          RETURN
#      END IF
 
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW p306_w EXIT PROGRAM
#   END IF
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW p306_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
#NO.FUN-570144 END---
   IF g_wc = ' 1=1' THEN 
      CALL cl_err('','9046',0) 
      CONTINUE WHILE   #FUN-BB0114  ADD
     #RETURN   #FUN-BB0114 MARK
   END IF
 
   LET g_bgjob = "N"           #FUN-570144
   #INPUT BY NAME g_yy,g_mm,g_a,g_b WITHOUT DEFAULTS 
   INPUT BY NAME g_yy,g_mm,g_a,g_b,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570144 
 
      AFTER FIELD g_yy
         IF cl_null(g_yy) THEN
            NEXT FIELD g_yy
         END IF 
         IF g_yy<g_faa07 THEN 
            CALL cl_err(g_faa07,'afa-370',0)
            NEXT FIELD g_yy 
         END IF
      
      AFTER FIELD g_mm
#No.TQC-720032 -- begin --
         IF NOT cl_null(g_mm) THEN
            SELECT azm02 INTO g_azm.azm02 FROM azm_file
              WHERE azm01 = g_yy
            IF g_azm.azm02 = 1 THEN
               IF g_mm > 12 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            ELSE
               IF g_mm > 13 OR g_mm < 1 THEN
                  CALL cl_err('','agl-020',0)
                  NEXT FIELD g_mm
               END IF
            END IF
         END IF
#No.TQC-720032 -- end --
         IF cl_null(g_mm) OR g_mm < 1 OR g_mm > 12 THEN 
            NEXT FIELD g_mm
         END IF 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   
     ON ACTION locale        #FUN-570144
        LET g_change_lang = TRUE
        EXIT INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
  
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
#NO.FUN-570144 START--
#   IF INT_FLAG THEN
#      LET INT_FLAG = 0 CLOSE WINDOW p306_w EXIT PROGRAM
#   END IF
 
#   IF (g_a != 'N' AND g_b != 'N') AND NOT cl_sure(0,0) THEN 
#      RETURN 
#   ELSE
#      CALL p306_1() ERROR ''
#   END IF
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p306_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
      RETURN
   END IF
 
   IF g_bgjob = "Y" THEN
    SELECT zz08 INTO lc_cmd FROM zz_file
     WHERE zz01 = "afap306"
    IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
       CALL cl_err('afap306','9031',1)
    ELSE
       LET g_wc=cl_replace_str(g_wc, "'", "\"")
       LET lc_cmd = lc_cmd CLIPPED,
                    " '",g_wc CLIPPED,"'",
                    " '",g_yy CLIPPED,"'",
                    " '",g_mm CLIPPED,"'",
                    " '",g_a  CLIPPED,"'",
                    " '",g_b  CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
       CALL cl_cmdat('afap306',g_time,lc_cmd CLIPPED)
    END IF
    CLOSE WINDOW p306_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
    EXIT PROGRAM
   END IF
 EXIT WHILE
END WHILE
#->No.FUN-570144 --end--
 
END FUNCTION
 
FUNCTION p306_1()
DEFINE l_faj02  LIKE faj_file.faj02,              
       l_faj022 LIKE faj_file.faj022,
       l_fap02  LIKE fap_file.fap02,              
       l_fap021 LIKE fap_file.fap021,
       l_curr   LIKE fan_file.fan07,
       l_flag   LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(01)
       l_faj01  LIKE faj_file.faj01 # saki 20070821 faj01 chr18 -> num10 
 
    CALL cl_wait()
    IF g_a = 'Y' THEN  #更新本期累折
       LET g_sql="SELECT faj01,faj02,faj022 ",
                 "  FROM faj_file ",
                 " WHERE ",g_wc CLIPPED 
       PREPARE fan_prepare FROM g_sql 
       DECLARE fan_cs  CURSOR WITH HOLD FOR fan_prepare
   
       #BEGIN WORK LET g_success = 'Y'   #NO.FUN-570144 MARK
       CALL s_showmsg_init()    #No.FUN-710028
       FOREACH fan_cs INTO l_faj01,l_faj02,l_faj022
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 -end
 
           IF g_bgjob = "N" THEN             #FUN-570144
               MESSAGE l_faj02,' ',l_faj022 
               CALL ui.Interface.refresh()
           END IF
           LET l_curr = 0 
           SELECT count(*) INTO l_curr FROM fan_file   #本期累折
                       WHERE fan03= g_yy
                         AND fan04<= g_mm
                          #AND fan041 = '1'   #MOD-570257
                         AND fan05 !='3'  #1.單一部門 2.多部門 3.被分攤
#          IF l_curr =0 THEN EXIT FOREACH END IF      #No.FUN-710028
           IF l_curr =0 THEN CONTINUE FOREACH END IF  #No.FUN-710028
           LET l_curr = 0 
           SELECT SUM(fan07) INTO l_curr FROM fan_file   #本期累折
                       WHERE fan01=l_faj02 AND fan02=l_faj022 
                         AND fan03= g_yy
                         AND fan04<= g_mm
                          #AND fan041 = '1'   #MOD-570257
                         AND fan05 !='3'  #1.單一部門 2.多部門 3.被分攤
           IF l_curr IS NULL OR l_curr = ' ' OR l_curr = 0 
           THEN CONTINUE FOREACH END IF
           UPDATE faj_file SET faj203 = l_curr WHERE faj01 = l_faj01 AND faj02 = l_faj02 AND faj022 = l_faj022
           IF SQLCA.SQLERRD[3] = 0 THEN 
              CALL s_errmsg('faj01',l_faj01,'upd faj:',SQLCA.sqlcode,1)  #No.FUN-710028
#             LET g_success = 'N' EXIT FOREACH      #No.FUN-710028
              LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
           END IF 
  
          ##-----No:FUN-B60140 Mark----- 
          ##-----No:FUN-AB0088-----
          #IF g_faa.faa31 = 'Y' THEN
          #   LET l_curr = 0

          #   SELECT COUNT(*) INTO l_curr FROM fbn_file   #本期累折
          #               WHERE fbn03= g_yy
          #                 AND fbn04<= g_mm
          #                 AND fbn05 !='3'  #1.單一部門 2.多部門 3.被分攤

          #   IF l_curr =0 THEN CONTINUE FOREACH END IF

          #   LET l_curr = 0

          #   SELECT SUM(fbn07) INTO l_curr FROM fan_file   #本期累折
          #    WHERE fbn01=l_faj02
          #      AND fbn02=l_faj022
          #      AND fbn03= g_yy
          #      AND fbn04<= g_mm
          #      AND fbn05 !='3'  #1.單一部門 2.多部門 3.被分攤

          #   IF l_curr IS NULL OR l_curr = ' ' OR l_curr = 0 THEN CONTINUE FOREACH END IF

          #   UPDATE faj_file SET faj2032 = l_curr
          #     WHERE faj02 = l_fap02
          #       AND faj01= l_fap01
          #       AND faj022=l_faj022 
          #   IF SQLCA.SQLERRD[3] = 0 THEN
          #      CALL s_errmsg('faj02,faj01',g_showmsg,'upd faj2:',SQLCA.sqlcode,1)
          #      LET g_success = 'N'
          #      CONTINUE FOREACH
          #   END IF
          #END IF
          ##-----No:FUN-AB0088 END-----
          ##-----No:FUN-B60140 Mark END-----
       END FOREACH 
#No.FUN-710028 --begin                                                                                                              
       IF g_totsuccess="N" THEN                                                                                                        
          LET g_success="N"                                                                                                            
       END IF                                                                                                                          
#No.FUN-710028 --end
 
     #  IF g_success = 'Y' THEN COMMIT WORK 
     #                     ELSE CALL cl_rbmsg(1) ROLLBACK WORK END IF 
    END IF 
 
    IF g_b = 'Y' THEN  #更新本期銷帳累折
       #CALL s_azm(g_yy,g_mm) RETURNING g_chr,b_date,e_date #CHI-A60036 mark
       #CHI-A60036 add --start--
       CALL s_get_bookno(g_yy)
          RETURNING g_flag,g_bookno1,g_bookno2
    #  IF g_aza.aza63 = 'Y' THEN
       IF g_faa.faa31 = 'Y' THEN   #No:FUN-AB0088
             CALL s_azmm(g_yy,g_mm,g_plant,g_bookno1) RETURNING g_chr,b_date,e_date
       ELSE
          CALL s_azm(g_yy,g_mm) RETURNING g_chr,b_date,e_date
       END IF
       #CHI-A60036 add --end--
      #IF g_chr='1' THEN CALL cl_err('s_azm:error','',1) RETURN END IF
       IF g_chr='1' THEN 
          CALL cl_err('s_azm:error','agl-101',1) 
          LET g_success='N'   #FUN-BB0114 ADD
          RETURN 
       END IF
       LET b_date = MDY(1,1,g_yy)
       LET g_sql="SELECT unique fap02,fap021 FROM fap_file,faj_file ",
                 "  WHERE  fap03 IN ('4','5','6') ",
                 "    AND fap02 = faj02 ",
                 "    AND fap021 = faj022 ",
                 "   AND ",g_wc CLIPPED 
       PREPARE fap_prepare FROM g_sql 
       DECLARE fap_cs  CURSOR WITH HOLD FOR fap_prepare
 
       #BEGIN WORK LET g_success = 'Y'   #NO.FUN-570144 MARK
       CALL s_showmsg_init()    #No.FUN-710028
       FOREACH fap_cs INTO l_fap02,l_fap021 
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 -end
 
           IF g_bgjob = "N" THEN             #FUN-570144
               MESSAGE l_fap02,' ',l_fap021 
               CALL ui.Interface.refresh()
           END IF
           SELECT SUM(fap57) INTO l_curr FROM fap_file   #本期累折
                       WHERE fap02=l_fap02 AND fap021=l_fap021 
                         AND (fap04 BETWEEN b_date AND e_date ) 
                         AND fap03 IN ('4','5','6') 
           IF l_curr IS NULL OR l_curr = ' ' OR l_curr = 0 
           THEN CONTINUE FOREACH END IF
           UPDATE faj_file SET faj204 = l_curr WHERE faj02 = l_fap02 
                                                 AND faj022= l_fap021
           IF SQLCA.SQLERRD[3] = 0 THEN 
              CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj:',SQLCA.sqlcode,1)  #No.FUN-710028
#             LET g_success = 'N' EXIT FOREACH      #No.FUN-710028
              LET g_success = 'N' CONTINUE FOREACH  #No.FUN-710028
           END IF

          ##-----No:FUN-B60140 Mark-----
          ##-----No:FUN-AB0088-----
          #IF g_faa.faa31 = 'Y' THEN
          #   SELECT SUM(fap572) INTO l_curr FROM fap_file   #本期累折
          #    WHERE fap02=l_fap02 AND fap021=l_fap021
          #      AND (fap04 BETWEEN b_date AND e_date )
          #      AND fap03 MATCHES '[456]'

          #   IF l_curr IS NULL OR l_curr = ' ' OR l_curr = 0 THEN CONTINUE FOREACH END IF

          #   UPDATE faj_file SET faj2042 = l_curr
          #    WHERE faj02 = l_fap02
          #      AND faj022= l_fap021
          #   IF SQLCA.SQLERRD[3] = 0 THEN
          #      CALL s_errmsg('faj02,faj022',g_showmsg,'upd faj2:',SQLCA.sqlcode,1)
          #      LET g_success = 'N'
          #      CONTINUE FOREACH
          #   END IF
          #END IF
          ##-----No:FUN-AB0088 END-----
          ##-----No:FUN-B60140 Mark END-----
 
       END FOREACH 
#No.FUN-710028 --begin                                                                                                              
       IF g_totsuccess="N" THEN                                                                                                        
          LET g_success="N"                                                                                                            
       END IF                                                                                                                          
#No.FUN-710028 --end
 
    END IF 
#NO.FUN-570144 MARK ---
 
#    IF g_success = 'Y' THEN
#       COMMIT WORK 
#       CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#    ELSE 
#         # CALL cl_rbmsg(1)
#          ROLLBACK WORK
#          CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#    END IF 
 
#    ERROR ''
#    CALL cl_end(0,0)
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#NO.FUN-570144 MARK---
END FUNCTION

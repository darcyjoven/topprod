# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmp510.4gl
# Descriptions...: 請購單拋轉作業
# Date & Author..: No.FUN-630040 06/03/16 By Nicola
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.TQC-650120 06/07/05 By Sam pmk02 -->pmk04 
# Modify.........: No.FUN-680136 06/08/31 By Jackho 欄位類型修改
# Modify.........: No.FUN-710030 07/01/19 By johnray 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-740028 07/04/06 By Ray 增加語言轉換功能
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0059 10/10/22 By chenying 料號開窗控管 
# Modify.........: No.TQC-C10025 12/01/05 By suncx 未找到可拋轉資料時應該提示拋轉失敗
# Modify.........: No.TQC-BB0085 12/02/14 By destiny 开窗过滤掉非统购的请购单
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_pnx          RECORD LIKE pnx_file.* 
DEFINE g_pnx01        LIKE pnx_file.pnx01
DEFINE g_pnx03        LIKE pnx_file.pnx03
DEFINE g_wc,g_sql     STRING 
DEFINE p_row,p_col    LIKE type_file.num5          #No.FUN-680136 SMALLINT
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680136 INTEGER
 
MAIN
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   CALL p510_p1()
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
 
END MAIN
 
FUNCTION p510_p1()
   DEFINE l_flag      LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE lc_qbe_sn   LIKE gbm_file.gbm01     #No.FUN-580031
   DEFINE l_pnx03     LIKE pnx_file.pnx03
   DEFINE n_pnx03     LIKE pnx_file.pnx03
   DEFINE s_pnx03     LIKE type_file.num5     #No.FUN-680136 SMALLINT
   DEFINE l_month     LIKE type_file.chr3     #No.FUN-680136 VARCHAR(3)
   DEFINE l_day       LIKE type_file.chr3     #No.FUN-680136 VARCHAR(3)
 
   LET p_row = 2 LET p_col = 3
 
   OPEN WINDOW p510_w AT p_row,p_col WITH FORM "apm/42f/apmp510"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      IF s_shut(0) THEN RETURN END IF
 
      CLEAR FORM
 
   #  CONSTRUCT BY NAME g_wc ON pmk01,pmk02,pml04  NO.TQC-650120
      CONSTRUCT BY NAME g_wc ON pmk01,pmk04,pml04  # NO.TQC-650120
      
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pmk01)
                  CALL cl_init_qry_var()
                  #LET g_qryparam.form = "q_pmk3"   #TQC-BB0085
                  LET g_qryparam.form = "q_pmk3_1" #TQC-BB0085
                  LET g_qryparam.state = 'c'
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO pmk01
                  NEXT FIELD pmk01
               WHEN INFIELD(pml04)
#FUN-AA0059---------mod------------str----------------                              
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = "q_ima"
#                  LET g_qryparam.state = 'c'
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end----------------
                  DISPLAY g_qryparam.multiret TO pml04
                  NEXT FIELD pml04
            END CASE
      
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
      
         ON ACTION about
            CALL cl_about()
      
         ON ACTION help
            CALL cl_show_help()
      
         ON ACTION controlg
            CALL cl_cmdask()
      
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
         #No.TQC-740028 --begin
         ON ACTION locale    
            LET g_action_choice = "locale"
            EXIT CONSTRUCT
         #No.TQC-740028 --end
      
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmkuser', 'pmkgrup') #FUN-980030
      #No.TQC-740028 --begin
      IF g_action_choice = "locale" THEN  #genero
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE 
      END IF
      #No.TQC-740028 --end
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      INPUT g_pnx01,g_pnx03 FROM pnx01,pnx03
 
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
         AFTER FIELD pnx01
            IF NOT cl_null(g_pnx01) THEN
               SELECT * FROM geu_file
                WHERE geu01 = g_pnx01
                  AND geu00 = "4"
               IF STATUS THEN
#                 CALL cl_err(g_pnx01,"anm-027",0)   #No.FUN-660129
                  CALL cl_err3("sel","geu_file",g_pnx01,"","anm-027","","",0)  #No.FUN-660129
                  NEXT FIELD pnx01
               END IF
               LET l_month = "0"||MONTH(g_today)
               LET l_month = l_month[LENGTH(l_month)-1,LENGTH(l_month)]
               LET l_day = "0"||DAY(g_today)
               LET l_day = l_day[LENGTH(l_day)-1,LENGTH(l_day)]
               LET l_pnx03 = g_plant CLIPPED||YEAR(g_today)||l_month||l_day
               SELECT MAX(pnx03) INTO n_pnx03 FROM pnx_file
                WHERE pnx03 LIKE l_pnx03||'%'
               IF cl_null(n_pnx03) THEN
                  LET g_pnx03 = "01"
               ELSE
                  LET s_pnx03 = n_pnx03[LENGTH(l_pnx03)+1,LENGTH(l_pnx03)+2]+1
                  LET g_pnx03 = "0"||s_pnx03
                  LET g_pnx03 = g_pnx03[LENGTH(g_pnx03)-1,LENGTH(g_pnx03)]
               END IF
               LET g_pnx03 = l_pnx03 CLIPPED,g_pnx03
            END IF
 
         AFTER FIELD pnx03
            IF NOT cl_null(g_pnx03) THEN
               SELECT COUNT(*) INTO g_cnt 
                 FROM pnx_file
                WHERE pnx03 = g_pnx03
               IF g_cnt > 0 THEN
                  CALL cl_err(g_pnx03,"axm-298",0)
                  NEXT FIELD pnx03
               END IF
            END IF
 
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(pnx01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_geu"
                  LET g_qryparam.arg1 = "4"
                  LET g_qryparam.default1 = g_pnx01
                  CALL cl_create_qry() RETURNING g_pnx01
                  DISPLAY g_pnx01 TO pnx01
                  NEXT FIELD pnx01
               OTHERWISE
            END CASE
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
       
         ON ACTION help
            CALL cl_show_help()
       
         ON ACTION controlg
            CALL cl_cmdask()
       
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
         #No.TQC-740028 --begin
         ON ACTION locale       
            LET g_action_choice = "locale"
            CALL cl_show_fld_cont()
            EXIT INPUT
         #No.TQC-740028 --end
 
      END INPUT
 
      #No.TQC-740028 --begin
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
      #No.TQC-740028 --end
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         RETURN
      END IF
 
      IF cl_sure(0,0) THEN
         BEGIN WORK               #No.FUN-710030
         CALL p510_p2()
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
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p510_w
 
END FUNCTION
 
FUNCTION p510_p2()
   DEFINE l_pml     RECORD LIKE pml_file.*
   DEFINE l_pmk04   LIKE pmk_file.pmk04
   DEFINE l_flag    LIKE type_file.chr1    #TQC-C10025
 
   LET g_sql = "SELECT pml_file.*,pmk04 FROM pml_file,pmk_file",
               " WHERE pml01 = pmk01 ", 
               "   AND pmk18 = 'Y'",
               "   AND pml192 = 'N'",
               "   AND pml190 = 'Y'",
               "   AND pml191 = '",g_pnx01,"'",
               "   AND ",g_wc CLIPPED
 
   PREPARE p510_pb FROM g_sql
   #TQC-C10025 add begin-----------------------
   EXECUTE p510_pb
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      CALL cl_err3("","","","",SQLCA.sqlcode,"","pml_curs",1)
      RETURN
   END IF
   #TQC-C10025 add end-------------------------
   DECLARE pml_curs CURSOR FOR p510_pb
  
#   BEGIN WORK                #No.FUN-710030
   LET g_success = "Y"
   LET l_flag = 'N'            #TQC-C10025
 
   CALL s_showmsg_init()        #No.FUN-710030
   FOREACH pml_curs INTO l_pml.*,l_pmk04
      IF STATUS THEN
#No.FUN-710030 -- begin --
#         CALL cl_err("pml_curs",STATUS,1)
         IF g_bgerr THEN
            CALL s_errmsg("","","pml_curs",STATUS,1)
         ELSE
            CALL cl_err3("","","","",STATUS,"","pml_curs",1)
         END IF
#No.FUN-710030 -- end --
         LET g_success = 'N'  #No.FUN-8A0086
 
         EXIT FOREACH
      END IF
#No.FUN-710030 -- begin --
      IF g_success="N" THEN
         LET g_totsuccess="N"
         LET g_success="Y"
      END IF
#No.FUN-710030 -- end --
      LET l_flag = 'Y'   #TQC-C10025
 
      LET g_pnx.pnx01 = g_pnx01
      LET g_pnx.pnx02 = "1"
      LET g_pnx.pnx03 = g_pnx03
      LET g_pnx.pnx04 = g_plant
      LET g_pnx.pnx05 = l_pml.pml01
      LET g_pnx.pnx06 = l_pml.pml02
      LET g_pnx.pnx07 = l_pml.pml04
      LET g_pnx.pnx08 = l_pmk04
      LET g_pnx.pnx09 = l_pml.pml33
      LET g_pnx.pnx10 = l_pml.pml80
      LET g_pnx.pnx11 = l_pml.pml81
      LET g_pnx.pnx12 = l_pml.pml82
      LET g_pnx.pnx13 = l_pml.pml83
      LET g_pnx.pnx14 = l_pml.pml84
      LET g_pnx.pnx15 = l_pml.pml85
      LET g_pnx.pnx16 = l_pml.pml07
      LET g_pnx.pnx17 = l_pml.pml09
      LET g_pnx.pnx18 = l_pml.pml20
      LET g_pnx.pnx19 = ""
      LET g_pnx.pnx20 = 0
      LET g_pnx.pnxplant = g_plant #FUN-980006
      LET g_pnx.pnxlegal = g_legal #FUN-980006
 
      INSERT INTO pnx_file VALUES(g_pnx.*)
      IF STATUS THEN
#        CALL cl_err("ins pnx error","",0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("ins","pnx_file","","",SQLCA.sqlcode,"","ins pnx error",0)  #No.FUN-660129
#         LET g_success = "N"
         LET g_success = "N"
         IF g_bgerr THEN
            LET g_showmsg = g_pnx.pnx01,"/",g_pnx.pnx02,"/",g_pnx.pnx03,"/",g_pnx.pnx04,"/",g_pnx.pnx05,"/",g_pnx.pnx06
            CALL s_errmsg("pnx01,pnx02,pnx03,pnx04,pnx05,pnx06",g_showmsg,"ins pnx error",SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","pnx_file",g_pnx.pnx01,g_pnx.pnx02,SQLCA.sqlcode,"","ins pnx error",1)
         END IF
#No.FUN-710030 -- end --
      END IF
 
      UPDATE pml_file SET pml192 = "Y"
       WHERE pml01 = l_pml.pml01
         AND pml02 = l_pml.pml02
      IF STATUS THEN
#        CALL cl_err("upd pml err",STATUS,0)   #No.FUN-660129
#No.FUN-710030 -- begin --
#         CALL cl_err3("upd","pml_file",l_pml.pml01,l_pml.pml02,STATUS,"","upd pml err",0)  #No.FUN-660129
#         LET g_success = "N"
         LET g_success = "N"
         IF g_bgerr THEN
            LET g_showmsg = l_pml.pml01,"/",l_pml.pml02
            CALL s_errmsg("pml01,pml02",g_showmsg,"upd pml err",STATUS,0)
         ELSE
            CALL cl_err3("upd","pml_file",l_pml.pml01,l_pml.pml02,STATUS,"","upd pml err",0)
         END IF
#No.FUN-710030 -- end --
      END IF
 
   END FOREACH
   #TQC-C10025 add begin-------------
   IF l_flag = 'N' THEN
      CALL s_errmsg("","","pml_curs",'aic-024',1)
      LET g_success="N"
   END IF
   #TQC-C10025 add end---------------
#No.FUN-710030 -- begin --
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
#No.FUN-710030 -- end --
 
END FUNCTION
 
 

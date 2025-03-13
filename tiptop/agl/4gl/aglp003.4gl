# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: aglp003.4gl
# Descriptions...: 期末結轉作業 (整批資料處理作業)
# Input parameter: 
# Return code....: 
# Modify ........: No.FUN-570145 06/02/28 By yiting 批次背景執行
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/16 By yjkhero 錯誤訊息匯整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-780068 07/08/31 By Sarah INPUT條件增加輸入axz01,axz05,axz06,axn_file SCHEMA改變,修改結轉下期方法
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B60144 11/07/01 By lixiang  呼叫saglp003.4gl
# Modify.........: NO.FUN-BB0065 12/03/06 BY belle axn->ayd, axo->aye,結轉時要加入key:族群及上層公司為key,並將aglp003獨立程式
# Modify.........: NO.FUN-C10054 12/03/06 By belle 畫面上的「期別」直接default '0',並且不可輸入
#                                                  取去年度的12月合併科餘的「本期損益BS」時，結轉至當年期初的「累積盈虧」科餘
# Modify.........: NO.FUN-C10016 12/04/12 By belle Action名稱修改

DATABASE ds
 
GLOBALS "../../config/top.global"

#---FUN-BB0065 start------
DEFINE tm      RECORD
                axa01  LIKE axa_file.axa01,
                axa02  LIKE axa_file.axa02,
                aaa04  LIKE aaa_file.aaa04,
                aaa05  LIKE aaa_file.aaa05,
                aaz641 LIKE aaz_file.aaz641         
               END RECORD,
       close_y,close_m LIKE type_file.num5,   #closing year & month
       l_yy,l_mm       LIKE type_file.num5,  
       l_yy1,l_mm1     LIKE type_file.num5,   #FUN-C10054
       b_date          LIKE type_file.dat, 
       e_date          LIKE type_file.dat,   
       g_bookno        LIKE aea_file.aea00, 
       bno             LIKE type_file.chr6, 
       eno             LIKE type_file.chr6 
DEFINE ls_date         STRING,            
       l_flag          LIKE type_file.chr1, 
       g_change_lang   LIKE type_file.chr1 
DEFINE g_argv1         LIKE type_file.chr1
DEFINE g_dbs_axz03     LIKE type_file.chr21      
DEFINE g_axz06         LIKE axz_file.axz06
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   LET tm.axa01    = ARG_VAL(1)
   LET tm.axa02    = ARG_VAL(2)
   LET tm.aaa04    = ARG_VAL(3)                   
   LET tm.aaa05    = ARG_VAL(4)           
   LET tm.aaz641   = ARG_VAL(5)
   LET g_bgjob     = ARG_VAL(6)

   IF cl_null(g_bgjob) THEN LET g_bgjob= "N" END IF

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   IF (NOT cl_null(tm.axa01) AND NOT cl_null(tm.axa02)) THEN
       CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03
       CALL s_get_aaz641(g_dbs_axz03) RETURNING tm.aaz641
   END IF

   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL aglp003_tm_1(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL p003_1()
            CALL s_showmsg()    
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag      
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag      
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW aglp003_w
               EXIT WHILE
            END IF
         END IF
      ELSE
         LET tm.aaa05 = 0       #FUN-C10054
         LET l_mm = tm.aaa05    #FUN-C10054
        #FUN-C10054--Mark--
        #IF tm.aaa05=1 THEN   
        #   LET l_yy = tm.aaa04-1 LET l_mm = 12
        #ELSE
        #   LET l_yy = tm.aaa04   LET l_mm = tm.aaa05-1
        #END IF
         LET g_success = 'Y'
         BEGIN WORK
         CALL p003_1()
         CALL s_showmsg()      
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END  IF
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION aglp003_tm_1(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5    
   DEFINE  lc_cmd          LIKE type_file.chr100
   DEFINE  l_cnt           LIKE type_file.num5 

   LET p_row = 4 LET p_col = 26
 
   OPEN WINDOW aglp003_w AT p_row,p_col WITH FORM "agl/42f/aglp003" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Defaealt condition
     #FUN-C10054--Mark-- 
     #SELECT aaa04,aaa05,YEAR(aaa07),MONTH(aaa07) 
     #  INTO tm.aaa04,tm.aaa05,close_y,close_m FROM aaa_file
     # WHERE aaa01 = tm.aaz641
     #FUN-C10054--Mark-- 
     #FUN-C10054--Add-- 
      LET tm.aaa05 = 0 
      SELECT aaa04,YEAR(aaa07),MONTH(aaa07)
        INTO tm.aaa04,close_y,close_m FROM aaa_file
       WHERE aaa01 = tm.aaz641
     #FUN-C10054--Add-- 
      DISPLAY BY NAME tm.aaa04,tm.aaa05
 
      LET g_bgjob = 'N'                    
 
       INPUT tm.axa01,tm.axa02,tm.aaa04,tm.aaa05,tm.aaz641,g_bgjob WITHOUT DEFAULTS  
          FROM axa01,axa02,aaa04,aaa05,aaz641,g_bgjob                         

         AFTER FIELD axa01
            IF NOT cl_null(tm.axa01) THEN
               SELECT DISTINCT axa01 FROM axa_file WHERE axa01=tm.axa01
               IF STATUS THEN
                  CALL cl_err3("sel","axa_file",tm.axa01,tm.axa02,"agl-11","","",0)  
                  NEXT FIELD axa01 
               END IF
            END IF

         AFTER FIELD axa02
            IF NOT cl_null(tm.axa02) THEN
               SELECT count(*) INTO l_cnt FROM axa_file 
                WHERE axa01=tm.axa01 AND axa02=tm.axa02
               IF l_cnt = 0  THEN 
                  CALL cl_err('sel axa:','agl-118',0) NEXT FIELD axa02
               END IF
               CALL s_aaz641_dbs(tm.axa01,tm.axa02) RETURNING g_dbs_axz03
               CALL s_get_aaz641(g_dbs_axz03) RETURNING tm.aaz641
               SELECT axz06 INTO g_axz06
                 FROM axz_file 
                WHERE axz01 = tm.axa02
              #FUN-C10054--Mark--
              #SELECT aaa04,aaa05,YEAR(aaa07),MONTH(aaa07) 
              #  INTO tm.aaa04,tm.aaa05,close_y,close_m FROM aaa_file
              #FUN-C10054--Mark--
               SELECT aaa04,YEAR(aaa07),MONTH(aaa07)            #FUN-C10054--Modify
                 INTO tm.aaa04,close_y,close_m FROM aaa_file    #FUN-C10054--Modify
                WHERE aaa01 = tm.aaz641
               LET tm.aaa05 = 0                                 #FUN-C10054--Modify
               DISPLAY BY NAME tm.aaa04,tm.aaa05

               DISPLAY tm.aaz641 TO aaz641
               DISPLAY g_axz06 TO axz06
            END IF

         AFTER FIELD aaa04
            IF cl_null(tm.aaa04) THEN
               NEXT FIELD aaa04
            END IF
            IF tm.aaa04<close_y THEN 
               CALL cl_err('','agl-085',0) 
               NEXT FIELD aaa04
            END IF
 
         AFTER FIELD aaa05 
            IF NOT cl_null(tm.aaa05) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.aaa04
               IF g_azm.azm02 = 1 THEN
                  #IF tm.aaa05 > 12 OR tm.aaa05 < 1 THEN
                  IF tm.aaa05 > 12 OR tm.aaa05 < 0 THEN   #FUN-BB0065
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD aaa05
                  END IF
               ELSE
                  #IF tm.aaa05 > 13 OR tm.aaa05 < 1 THEN
                  IF tm.aaa05 > 13 OR tm.aaa05 < 0 THEN   #FUN-BB0065
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD aaa05
                  END IF
               END IF
            END IF
            IF cl_null(tm.aaa05) THEN
                NEXT FIELD aaa05
            END IF
            IF tm.aaa04*100+tm.aaa05 < close_y*100+close_m THEN
               CALL cl_err('','agl-085',0) 
                NEXT FIELD aaa05
            END IF
            LET l_mm = 0          #FUN-C10054
           #IF tm.aaa05=1 THEN 
           #FUN-C10054--Mark--
           #IF tm.aaa05=0 THEN    #FUN-BB0065
           #   LET l_yy=tm.aaa04-1 LET l_mm=12
           #ELSE
           #   LET l_yy=tm.aaa04 LET l_mm=tm.aaa05-1
           #END IF
           #FUN-C10054--Mark--

        ON ACTION controlp
           CASE
             WHEN INFIELD(axa01) #族群編號                                                                                   
                  CALL cl_init_qry_var()                                                                                       
                  LET g_qryparam.form = "q_axa5"                                                                               
                  LET g_qryparam.default1 = tm.axa01
                  CALL cl_create_qry() RETURNING tm.axa01
                  DISPLAY BY NAME tm.axa01
                  NEXT FIELD axa01                                                                                             
             WHEN INFIELD(axa02)  
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_axz" 
                  LET g_qryparam.default1 = tm.axa02
                  CALL cl_create_qry() RETURNING tm.axa02
                  DISPLAY BY NAME tm.axa02
                  NEXT FIELD axa02
             OTHERWISE EXIT CASE
           END CASE
 
 
         ON ACTION CONTROLR              #FUN-C10016
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
 
         ON ACTION exit    
            LET INT_FLAG = 1
            EXIT INPUT
   
         BEFORE INPUT
            CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION locale
            CALL cl_show_fld_cont()               
            LET g_change_lang = TRUE
            EXIT INPUT
 
      END INPUT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()              
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp003_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'aglp003'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp003','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.axa01 CLIPPED,"'",
                         " '",tm.axa02 CLIPPED,"'",
                         " '",tm.aaa04 CLIPPED,"'",
                         " '",tm.aaa05 CLIPPED,"'",
                         " '",tm.aaz641 CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp003',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW aglp003_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p003_1()
DEFINE l_ayd_o RECORD LIKE ayd_file.*
DEFINE l_ayd_n RECORD LIKE ayd_file.*
DEFINE l_aya01 LIKE aya_file.aya01, 
       l_axl01 LIKE axl_file.axl01, 
       l_axl02 LIKE axl_file.axl02
DEFINE l_aye08 LIKE aye_file.aye08
DEFINE l_sql   STRING
DEFINE l_cnt           LIKE type_file.num5 
#FUN-C10054--add--
DEFINE l_aaz114 LIKE aaz_file.aaz114          #本期損益BS
DEFINE l_aaz131 LIKE aaz_file.aaz131          #累計盈虧
DEFINE l_aaj01  RECORD
               aaj03   LIKE aaj_file.aaj03,  #科目編號(本期損益BS)
               aaj04   LIKE aaj_file.aaj04,  #分類代碼
               aaj05   LIKE aaj_file.aaj05,  #群組代碼
               amt     LIKE aye_file.aye08   #金額
               END RECORD
DEFINE l_aaj02  RECORD
               aaj03   LIKE aaj_file.aaj03,  #科目編號(累計盈虧)
               aaj04   LIKE aaj_file.aaj04,  #分類代碼
               aaj05   LIKE aaj_file.aaj05,  #群組代碼
               amt     LIKE aye_file.aye08   #金額
               END RECORD

  LET l_sql = " SELECT aaz114,aaz131 FROM aaz_file"
  PREPARE p003_p_aaz01 FROM l_sql
  DECLARE p003_c_aaz01 CURSOR FOR p003_p_aaz01
  OPEN p003_c_aaz01
  FETCH p003_c_aaz01 INTO l_aaj01.aaj03,l_aaj02.aaj03
  LET l_sql = " SELECT aaj04,aaj05 FROM aaj_file"
             ," WHERE aaj00 = ? AND aaj01 = ? AND aaj02 = ? AND aaj03 = ?"
  PREPARE p003_p_aaj01 FROM l_sql
  DECLARE p003_c_aaj01 CURSOR FOR p003_p_aaj01

 #取得[本期損益BS]所歸屬的分類與群組
  OPEN p003_c_aaj01 USING tm.aaz641,tm.axa01,tm.axa02,l_aaj01.aaj03
  FETCH p003_c_aaj01 INTO l_aaj01.aaj04,l_aaj01.aaj05

 #取得[累計盈虧]所歸屬的分類與群組
  OPEN p003_c_aaj01 USING tm.aaz641,tm.axa01,tm.axa02,l_aaj02.aaj03
  FETCH p003_c_aaj01 INTO l_aaj02.aaj04,l_aaj02.aaj05

  LET l_yy = tm.aaa04
  LET l_yy1= tm.aaa04-1

  LET l_sql = " SELECT MAX(axh07) FROM axh_file"
             ," WHERE axh00 = ? AND axh01 = ? AND axh02 = ?"
             ,"   AND axh06 = ?"
  PREPARE p003_p_axh07 FROM l_sql
  DECLARE p003_c_axh07 CURSOR FOR p003_p_axh07
  OPEN p003_c_axh07 USING tm.aaz641,tm.axa01,tm.axa02,l_yy1
  FETCH p003_c_axh07 INTO l_mm1

  IF NOT cl_null(l_mm1) THEN
     LET l_sql = " SELECT SUM(axh08-axh09) FROM axh_file"
                ," WHERE axh00 = ? AND axh01 = ? AND axh02 = ? AND axh05 = ?"
                ,"   AND axh06 = ? AND axh07 = ?"
     PREPARE p003_p_axh01 FROM l_sql
     DECLARE p003_c_axh01 CURSOR FOR p003_p_axh01
   
    #取得[累計盈虧]前一年度最後期的餘額
     OPEN p003_c_axh01 USING tm.aaz641,tm.axa01,tm.axa02,l_aaj02.aaj03,l_yy1,l_mm1
     FETCH p003_c_axh01 INTO l_aaj02.amt
  END IF
  IF cl_null(l_aaj02.amt) THEN LET l_aaj02.amt = 0 END IF
#FUN-C10054--add--

   DELETE FROM ayd_file
    WHERE ayd03 = tm.aaa04 
      AND ayd04 = tm.aaa05 
      AND ayd00 = tm.aaz641
      AND ayd01 = tm.axa01
      AND ayd02 = tm.axa02
      AND ayd05 = g_axz06
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","ayd_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","del ayd_file",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   INITIALIZE l_ayd_o.* TO NULL
 
   DECLARE ayd_cs1 CURSOR FOR
      SELECT * FROM ayd_file
      #WHERE ayd03 = l_yy     #FUN-C10054 mark
       WHERE ayd03 = l_yy1    #FUN-C10054 modify
         AND ayd04 = l_mm 
         AND ayd00 = tm.aaz641
         AND ayd01 = tm.axa01
         AND ayd02 = tm.axa02
         AND ayd05 = g_axz06
       ORDER BY ayd06
 
   CALL s_showmsg_init()            
   FOREACH ayd_cs1 INTO l_ayd_o.*
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     
 
      IF SQLCA.sqlcode THEN
        #LET g_showmsg=tm.axa01,"/",tm.axa02,"/",l_yy,"/",l_mm,"/",tm.aaz641    #FUN-C10054 mark
         LET g_showmsg=tm.axa01,"/",tm.axa02,"/",l_yy1,"/",l_mm,"/",tm.aaz641   #FUN-C10054 modify
         CALL s_errmsg('ayd01,ayd02,ayd03,ayd04,ayd00',g_showmsg,'(ayd_cs1#1:foreach)',SQLCA.sqlcode,1)
         LET g_success='N' RETURN                             
      END IF
 
      INITIALIZE l_ayd_n.* TO NULL
 
      LET l_ayd_n.ayd00 = tm.aaz641
      LET l_ayd_n.ayd01 = tm.axa01
      LET l_ayd_n.ayd02 = tm.axa02
      LET l_ayd_n.ayd03 = tm.aaa04      
      LET l_ayd_n.ayd04 = tm.aaa05 
      LET l_ayd_n.ayd05 = g_axz06    
      LET l_ayd_n.ayd06 = l_ayd_o.ayd06   
      LET l_ayd_n.ayd07 = l_ayd_o.ayd07   
      LET l_ayd_n.ayd08 = l_ayd_o.ayd08  
      LET l_ayd_n.aydlegal = g_legal    
      LET l_ayd_n.aydoriu = g_user  
      LET l_ayd_n.aydorig = g_grup 
 
      LET l_aye08 = 0
      SELECT SUM(aye08) INTO l_aye08
        FROM aye_file,aya_file
       WHERE aya01 = aye06
         AND aye01 = tm.axa01
         AND aye02 = tm.axa02
        #AND aye03 = l_yy     #FUN-C10054 mark 
        #AND aye04 = l_mm     #FUN-C10054 mark
         AND aye03 = l_yy1    #FUN-C10054 
         AND aye04 = l_mm1    #FUN-C10054
         AND aye05 = g_axz06
         AND aye00 = tm.aaz641
         AND aye06 = l_ayd_n.ayd06
         AND aye07 = l_ayd_n.ayd07
         AND aya07 = 'Y'
       GROUP BY aya01
      IF cl_null(l_aye08) THEN LET l_aye08 = 0 END IF
 
      LET l_ayd_n.ayd08 = l_ayd_n.ayd08 + l_aye08
    #FUN-C10054--add--
     IF (l_ayd_n.ayd06 = l_aaj01.aaj04 AND l_ayd_n.ayd07 = l_aaj01.aaj05) THEN
        LET l_ayd_n.ayd08 = l_ayd_n.ayd08 + l_aaj02.amt
     END IF
     IF (l_ayd_n.ayd06 = l_aaj02.aaj04 AND l_ayd_n.ayd07 = l_aaj02.aaj05) THEN
        LET l_ayd_n.ayd08 = l_ayd_n.ayd08 - l_aaj02.amt
     END IF
    #FUN-C10054--add--

      INSERT INTO ayd_file VALUES (l_ayd_n.*)
      IF STATUS THEN
         UPDATE ayd_file SET ayd08 = l_ayd_n.ayd08
                       WHERE ayd01 = l_ayd_n.ayd01
                         AND ayd02 = l_ayd_n.ayd02
                         AND ayd03 = l_ayd_n.ayd03  
                         AND ayd04 = l_ayd_n.ayd04 
                         AND ayd00 = l_ayd_n.ayd00
                         AND ayd05 = g_axz06     
                         AND ayd06 = l_ayd_n.ayd06 
                         AND ayd07 = l_ayd_n.ayd07
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
            LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.aaa04,"/",tm.aaa05 
            CALL s_errmsg('ayd01,ayd02,ayd03,ayd04',g_showmsg,'upd_ayd)',SQLCA.sqlcode,1) 
            LET g_success='N' RETURN 
         END IF
      END IF
   END FOREACH
 
   LET l_sql = "SELECT aya01,aye07 ",
               "  FROM aye_file,aya_file ",
               " WHERE aya01 = aye06 ",
               "   AND aye01 = '",tm.axa01,"'",
               "   AND aye02 = '",tm.axa02,"'",
              #"   AND aye03 = '",l_yy,"'",      #FUN-C10054 mark
              #"   AND aye04 = '",l_mm,"'",      #FUN-C10054 mark
               "   AND aye03 = '",l_yy1,"'",     #FUN-C10054 
               "   AND aye04 = '",l_mm1,"'",     #FUN-C10054
               "   AND aye05 = '",g_axz06,"'",
               "   AND aye00 = '",tm.aaz641,"'",
               "   AND aya07 = 'Y'"
   PREPARE p003_aye_p FROM l_sql
   IF STATUS THEN 
       CALL cl_err('prepare:1',STATUS,1)             
       LET g_success = 'N'
   END IF
   DECLARE p003_aye_c CURSOR FOR p003_aye_p
   FOREACH p003_aye_c INTO l_aya01,l_axl01
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt
         FROM ayd_file
        WHERE ayd01 = tm.axa01
          AND ayd02 = tm.axa02
         #AND ayd03 = l_yy        #FUN-C10054 mark 
          AND ayd03 = l_yy1       #FUN-C10054
          AND ayd04 = l_mm       
          AND ayd05 = g_axz06
          AND ayd00 = tm.aaz641
          AND (ayd06 = l_aya01 AND ayd07 = l_axl01)
       IF l_cnt = 0 THEN
           SELECT SUM(aye08) INTO l_aye08
             FROM aye_file
            WHERE aye01 =tm.axa01
              AND aye02 =tm.axa02
             #AND aye03 =l_yy      #FUN-C10054 mark
             #AND aye04 =l_mm      #FUN-C10054 mark
              AND aye03 =l_yy1     #FUN-C10054
              AND aye04 =l_mm1     #FUN-C10054
              AND aye05 =g_axz06
              AND aye00 =tm.aaz641
              AND aye06 =l_aya01
              AND aye07 =l_axl01
       ELSE
           CONTINUE FOREACH
       END IF

      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     
 
      IF SQLCA.sqlcode THEN
         LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.aaa04,"/",tm.aaa05,"/",tm.aaz641
         CALL s_errmsg('aye01,aye02,aye03,aye04,aye00',g_showmsg,'(aye_cs1#1:foreach)',SQLCA.sqlcode,1) 
         LET g_success='N' RETURN                             
      END IF
 
      INITIALIZE l_ayd_n.* TO NULL
 
      LET l_ayd_n.ayd01 = tm.axa01
      LET l_ayd_n.ayd02 = tm.axa02
      LET l_ayd_n.ayd03 = tm.aaa04      
      LET l_ayd_n.ayd04 = tm.aaa05 
      LET l_ayd_n.ayd05 = g_axz06    
      LET l_ayd_n.ayd00 = tm.aaz641
      LET l_ayd_n.ayd06 = l_aya01        
      LET l_ayd_n.ayd08 = l_aye08       
      LET l_ayd_n.ayd07 = l_axl01
      LET l_ayd_n.aydlegal = g_legal
      LET l_ayd_n.aydoriu = g_user  
      LET l_ayd_n.aydorig = g_grup

    #FUN-C10054--add--
     IF (l_ayd_n.ayd06 = l_aaj01.aaj04 AND l_ayd_n.ayd07 = l_aaj01.aaj05) THEN
        LET l_ayd_n.ayd08 = l_ayd_n.ayd08 + l_aaj02.amt
        LET l_aye08 = l_aye08 + l_aaj02.amt
     END IF
     IF (l_ayd_n.ayd06 = l_aaj02.aaj04 AND l_ayd_n.ayd07 = l_aaj02.aaj05) THEN
        LET l_ayd_n.ayd08 = l_ayd_n.ayd08 - l_aaj02.amt
        LET l_aye08 = l_aye08 - l_aaj02.amt
     END IF
    #FUN-C10054--add--

      INSERT INTO ayd_file VALUES (l_ayd_n.*)
      IF STATUS THEN
         UPDATE ayd_file SET ayd08 = ayd08+l_aye08
                       WHERE ayd01 = l_ayd_n.ayd01
                         AND ayd02 = l_ayd_n.ayd02
                         AND ayd03 = l_ayd_n.ayd03
                         AND ayd04 = l_ayd_n.ayd04
                         AND ayd00 = l_ayd_n.ayd00
                         AND ayd05 = g_axz06   
                         AND ayd06 = l_aya01
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
            LET g_showmsg=tm.axa01,"/",tm.axa02,"/",tm.aaa04,"/",tm.aaa05 
            CALL s_errmsg('ayd01,ayd02,ayd03,ayd04',g_showmsg,'upd_ayd)',SQLCA.sqlcode,1) 
            LET g_success='N' RETURN 
         END IF
      END IF
   END FOREACH
 
   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          
 
END FUNCTION
#---FUN-BB0065 end--------

#No.FUN-B60144--mark
#DEFINE tm      RECORD
#               aaa04  LIKE aaa_file.aaa04,
#               aaa05  LIKE aaa_file.aaa05,
#               axz01  LIKE axz_file.axz01,   #公司編號   #FUN-780068 add
#               axz05  LIKE axz_file.axz05,   #帳別       #FUN-780068 add
#               axz06  LIKE axz_file.axz06    #幣別       #FUN-780068 add
#              END RECORD,
#      close_y,close_m LIKE type_file.num5,   #closing year & month  #No.FUN-680098   SMALLINT   
#      l_yy,l_mm       LIKE type_file.num5,   #No.FUN-680098  SMALLINT  
#      b_date          LIKE type_file.dat,    #期間起始日期   #No.FUN-680098 DATE
#      e_date          LIKE type_file.dat,    #期間起始日期   #No.FUN-680098 DATE
#      g_bookno        LIKE aea_file.aea00,   #帳別
#      bno             LIKE type_file.chr6,   #起始傳票編號   #No.FUN-680098 VARCHAR(6)    
#      eno             LIKE type_file.chr6    #截止傳票編號   #No.FUN-680098 VARCHAR(6)    
#DEFINE ls_date         STRING,                #No.FUN-570145
#      l_flag          LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
#      g_change_lang   LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1) 
#
#No.FUN-B60144--mark--

#MAIN  #FUN-BB0065 mark
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073
 
#---FUN-BB0065 mark start--
#   OPTIONS
#      FORM LINE     FIRST + 2,
#      MESSAGE LINE  LAST,
#      PROMPT LINE   LAST,
#      INPUT NO WRAP
#   DEFER INTERRUPT
#--FUN-BB0065 mark end---

#No.FUN-B60144--mark-- 
#  LET g_bookno = ARG_VAL(1)
# #-->No.FUN-570145 --start
#  INITIALIZE g_bgjob_msgfile TO NULL
#  LET tm.aaa04    = ARG_VAL(2)                   #結轉年度
#  LET tm.aaa05    = ARG_VAL(3)                   #結轉期別
#  LET tm.axz01    = ARG_VAL(3)                   #公司編號   #FUN-780068 add
#  LET tm.axz05    = ARG_VAL(4)                   #帳別       #FUN-780068 add
#  LET tm.axz06    = ARG_VAL(5)                   #幣別       #FUN-780068 add
#  LET g_bgjob     = ARG_VAL(6)
#  IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
# #--- No:FUN-570145 --end---
#No.FUN-B60144--mark

#--FUN-BB0065 mark- start--
#   IF (NOT cl_user()) THEN
#      EXIT PROGRAM
#   END IF
#  
#   WHENEVER ERROR CALL cl_err_msg_log
#  
#   IF (NOT cl_setup("AGL")) THEN
#     EXIT PROGRAM
#   END IF
#   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#--FUN-BB0065 mark end---

#No.FUN-B60144--mark
#  IF g_bookno IS NULL OR g_bookno = ' ' THEN
#     SELECT aaz64 INTO g_bookno FROM aaz_file
#  END IF
##NO.FUN-570145 START
#   #CALL aglp003_tm(0,0)
#  WHILE TRUE
#     LET g_change_lang = FALSE
#     IF g_bgjob = 'N' THEN
#        CALL aglp003_tm(0,0)
#        IF cl_sure(21,21) THEN
#           CALL cl_wait()
#           LET g_success = 'Y'
#           BEGIN WORK
#           CALL p003()
#           CALL s_showmsg()                          #NO.FUN-710023     
#           IF g_success='Y' THEN
#              COMMIT WORK
#              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#           ELSE
#              ROLLBACK WORK
#              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#           END IF
#           IF l_flag THEN
#              CONTINUE WHILE
#           ELSE
#              CLOSE WINDOW aglp003_w
#              EXIT WHILE
#           END IF
#        END IF
#     ELSE
#        IF tm.aaa05=1 THEN   #結轉期別=1
#           LET l_yy = tm.aaa04-1 LET l_mm = 12
#        ELSE
#           LET l_yy = tm.aaa04   LET l_mm = tm.aaa05-1
#        END IF
#
#        LET g_success = 'Y'
#        BEGIN WORK
#        CALL p003()
#        CALL s_showmsg()                             #NO.FUN-710023    
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#        ELSE
#           ROLLBACK WORK
#        END IF
#        CALL cl_batch_bg_javamail(g_success)
#        EXIT WHILE
#     END  IF
#  END WHILE
#->No.FUN-570145 ---end---
#No.FUN-B60144--mark--
#--FUN-BB0065 mark start--
#   CALL aglp003('1')     #No.FUN-B60144
#   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#END MAIN
#--FUN-BB0065 mark end--

#No.FUN-B60144--mark-- 
#FUNCTION aglp003_tm(p_row,p_col)
#  DEFINE  p_row,p_col     LIKE type_file.num5       #No.FUN-680098 SMALLINT
#          #l_flag         LIKE type_file.chr1       #FUN-570145        #No.FUN-680098   VARCHAR(1) 
#  DEFINE  lc_cmd          LIKE type_file.chr1000    #FUN-570145        #No.FUN-680098   VARCHAR(500)  
#
#  CALL s_dsmark(g_bookno)
#
#  LET p_row = 4 LET p_col = 26
#
#  OPEN WINDOW aglp003_w AT p_row,p_col WITH FORM "agl/42f/aglp003" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#  CALL cl_ui_init()
#
#  CALL s_shwact(0,0,g_bookno)
#  CALL cl_opmsg('q')
#  WHILE TRUE 
#     IF s_shut(0) THEN RETURN END IF
#     CLEAR FORM 
#     INITIALIZE tm.* TO NULL			# Defaealt condition
#
#     #結轉年度,結轉期別,關帳年度,關帳期別
#     SELECT aaa04,aaa05,YEAR(aaa07),MONTH(aaa07) 
#       INTO tm.aaa04,tm.aaa05,close_y,close_m FROM aaa_file
#      WHERE aaa01 = g_bookno
#     DISPLAY BY NAME tm.aaa04,tm.aaa05
#
#     LET g_bgjob = 'N'                              #FUN-570145
#     #INPUT tm.aaa04,tm.aaa05 WITHOUT DEFAULTS FROM aaa04,aaa05
#     INPUT tm.aaa04,tm.aaa05,tm.axz01,tm.axz05,tm.axz06,g_bgjob WITHOUT DEFAULTS    #FUN-780068 add tm.axz01,tm.axz05,tm.axz06
#      FROM aaa04,aaa05,axz01,axz05,axz06,g_bgjob                                    #FUN-780068 add axz01,axz05,axz06
#        #NO.FUN-570145 MARK--
#        #ON ACTION locale
#        #     CALL cl_dynamic_locale()
#        #    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        #NO.FUN-570145 END
#
#        AFTER FIELD aaa04
#           IF cl_null(tm.aaa04) THEN
#              NEXT FIELD tm.aaa04
#           END IF
#           IF tm.aaa04<close_y THEN 
#              CALL cl_err('','agl-085',0) 
#              NEXT FIELD aaa04
#           END IF
#
#        AFTER FIELD aaa05 
#No.TQC-720032 -- begin --
#           IF NOT cl_null(tm.aaa05) THEN
#              SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                WHERE azm01 = tm.aaa04
#              IF g_azm.azm02 = 1 THEN
#                 IF tm.aaa05 > 12 OR tm.aaa05 < 1 THEN
#                    CALL cl_err('','agl-020',0)
#                    NEXT FIELD aaa05
#                 END IF
#              ELSE
#                 IF tm.aaa05 > 13 OR tm.aaa05 < 1 THEN
#                    CALL cl_err('','agl-020',0)
#                    NEXT FIELD aaa05
#                 END IF
#              END IF
#           END IF
#No.TQC-720032 -- end --
#           IF cl_null(tm.aaa05) THEN
#               NEXT FIELD aaa05
#           END IF
#           IF tm.aaa04*100+tm.aaa05 < close_y*100+close_m THEN
#              CALL cl_err('','agl-085',0) 
#               NEXT FIELD aaa05
#           END IF
#           #上一期年(l_yy)/月(l_mm)
#           IF tm.aaa05=1 THEN 
#              LET l_yy=tm.aaa04-1 LET l_mm=12
#           ELSE
#              LET l_yy=tm.aaa04 LET l_mm=tm.aaa05-1
#           END IF
#
#       #str FUN-780068 add
#        AFTER FIELD axz01    #公司編號
#           IF cl_null(tm.axz01) THEN NEXT FIELD axz01 END IF
#           SELECT axz05,axz06 INTO tm.axz05,tm.axz06 FROM axz_file
#            WHERE axz01 = tm.axz01
#           IF STATUS THEN
#              CALL cl_err(tm.axz01,'aco-025',0) NEXT FIELD axz01
#           ELSE
#              DISPLAY BY NAME tm.axz05,tm.axz06
#           END IF
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(axz01)   #公司編號
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_axz'
#                  LET g_qryparam.default1 = tm.axz01
#                  CALL cl_create_qry() RETURNING tm.axz01
#                  DISPLAY BY NAME tm.axz01
#                  NEXT FIELD axz01
#              WHEN INFIELD(axz05)   #帳別
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_aaa'
#                  LET g_qryparam.default1 = tm.axz05
#                  CALL cl_create_qry() RETURNING tm.axz05
#                  DISPLAY BY NAME tm.axz05
#                  NEXT FIELD axz05
#              WHEN INFIELD(axz06)   #幣別
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_azi'
#                  LET g_qryparam.default1 = tm.axz06
#                  CALL cl_create_qry() RETURNING tm.axz06
#                  DISPLAY BY NAME tm.axz06
#                  NEXT FIELD axz06
#              OTHERWISE EXIT CASE
#           END CASE
#       #end FUN-780068 add
#
#        ON ACTION CONTROLR
#           CALL cl_show_req_fields()
#
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#
#        ON ACTION exit                            #加離開功能
#           LET INT_FLAG = 1
#           EXIT INPUT
#  
#        #No.FUN-580031 --start--
#        BEFORE INPUT
#           CALL cl_qbe_init()
#        #No.FUN-580031 ---end---
#
#        #No.FUN-580031 --start--
#        ON ACTION qbe_select
#           CALL cl_qbe_select()
#        #No.FUN-580031 ---end---
#
#        #No.FUN-580031 --start--
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No.FUN-580031 ---end---
#
#        #->FUN-570145-start----------
#        ON ACTION locale
#           #CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()               #No.FUN-550037 hmf
#           LET g_change_lang = TRUE
#           EXIT INPUT
#        #->FUN-570145-end------------
#
#     END INPUT
#    #FUN-570145 --start--
#     #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
#     IF g_change_lang THEN
#        LET g_change_lang = FALSE
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()               #No.FUN-550037 hmf
#        CONTINUE WHILE
#     END IF
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW aglp003_w
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#        EXIT PROGRAM
#     END IF
#
#     IF cl_sure(21,21) THEN
#        CALL cl_wait()
#        #期末結轉(END OF MONTH)
#        LET g_success = 'Y'
#        BEGIN WORK
#-----------------------------月結
#        CALL p003()
#        IF g_success='Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#     END  IF
#     ERROR ""
#  END WHILE
#  CLOSE WINDOW aglp003_w
#     IF g_bgjob = 'Y' THEN
#        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'aglp003'
#        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
#           CALL cl_err('aglp003','9031',1)   
#        ELSE
#           LET lc_cmd = lc_cmd CLIPPED,
#                        " ''",
#                        " '",tm.aaa04 CLIPPED,"'",
#                        " '",tm.aaa05 CLIPPED,"'",
#                        " '",tm.axz01 CLIPPED,"'",   #FUN-780068 add
#                        " '",tm.axz05 CLIPPED,"'",   #FUN-780068 add
#                        " '",tm.axz06 CLIPPED,"'",   #FUN-780068 add
#                        " '",g_bgjob CLIPPED,"'"
#           CALL cl_cmdat('aglp003',g_time,lc_cmd CLIPPED)
#        END IF
#        CLOSE WINDOW aglp003_w
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#        EXIT PROGRAM
#     END IF
#     EXIT WHILE
#No.FUN-570145 ---end---
#  END WHILE
#END FUNCTION
#
#FUNCTION p003()
#DEFINE l_axn_o RECORD LIKE axn_file.*
#DEFINE l_axn_n RECORD LIKE axn_file.*
#DEFINE l_aya01 LIKE aya_file.aya01,   #分類代碼   #FUN-780068 add
#      l_axo04 LIKE axo_file.axo04    #異動金額
#
#
#  ### -->1.結轉前先刪除舊資料
#  DELETE FROM axn_file
#   WHERE axn01 = tm.aaa04   #年度 
#     AND axn02 = tm.aaa05   #月份
#     AND axn14 = tm.axz01   #公司編號
#     AND axn15 = tm.axz05   #帳別
#     AND axn16 = tm.axz06   #幣別
#  IF SQLCA.sqlcode THEN
#     CALL cl_err3("del","axn_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","del axn_file",1)
#     LET g_success = 'N'
#     RETURN
#  END IF
#
#  INITIALIZE l_axn_o.* TO NULL
#
# #str FUN-780068 mod
#  ### -->2.開始結轉資料
#  #找出上一期的axn
#  DECLARE axn_cs1 CURSOR FOR 
#     SELECT * FROM axn_file 
#      WHERE axn01 = l_yy       #上一期年度 
#        AND axn02 = l_mm       #上一期月份
#        AND axn14 = tm.axz01   #公司編號
#        AND axn15 = tm.axz05   #帳別
#        AND axn16 = tm.axz06   #幣別
#      ORDER BY axn17           #分類
#
#  CALL s_showmsg_init()                     #NO.FUN-710023 
#  FOREACH axn_cs1 INTO l_axn_o.*
#     #NO.FUN-710023--BEGIN                                                           
#     IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y' 
#     END IF                                                     
#     #NO.FUN-710023--END
#
#     IF SQLCA.sqlcode THEN
#        LET g_showmsg=l_yy,"/",l_mm,"/",tm.axz01,"/",tm.axz05,"/",tm.axz06
#        CALL s_errmsg('axn01,axn02,axn14,axn15,axn16',g_showmsg,'(axn_cs1#1:foreach)',SQLCA.sqlcode,1)
#        LET g_success='N' RETURN                             
#     END IF
#
#     INITIALIZE l_axn_n.* TO NULL
#
#     LET l_axn_n.axn01 = tm.aaa04       #年度
#     LET l_axn_n.axn02 = tm.aaa05       #月份
#     LET l_axn_n.axn14 = tm.axz01       #公司編號    #FUN-780068 add
#     LET l_axn_n.axn15 = tm.axz05       #帳別        #FUN-780068 add
#     LET l_axn_n.axn16 = tm.axz06       #幣別        #FUN-780068 add
#     LET l_axn_n.axn17 = l_axn_o.axn17  #分類代碼    #FUN-780068 add
#     LET l_axn_n.axn18 = l_axn_o.axn18  #餘額        #FUN-780068 add
#     LET l_axn_n.axnuser = g_user
#     LET l_axn_n.axngrup = g_grup
#     LET l_axn_n.axndate = g_today
#     LET l_axn_n.axnlegal = g_legal     #FUN-980003 add
#
#     LET l_axo04 = 0
#     #本期異動金額
#     SELECT SUM(axo04) INTO l_axo04 
#       FROM axo_file,aya_file
#      WHERE aya01 = axo14
#        AND axo01 = tm.aaa04       #年度
#        AND axo02 = tm.aaa05       #月份
#        AND axo11 = tm.axz01       #公司編號
#        AND axo12 = tm.axz05       #帳別
#        AND axo13 = tm.axz06       #幣別
#        AND axo14 = l_axn_n.axn17  #分類代碼
#      GROUP BY aya01
#     IF cl_null(l_axo04) THEN LET l_axo04 = 0 END IF
#
#     #本期餘額 = 上期餘額 + 本期異動金額
#     LET l_axn_n.axn18 = l_axn_n.axn18 + l_axo04
#
#     LET l_axn_n.axnoriu = g_user      #No.FUN-980030 10/01/04
#     LET l_axn_n.axnorig = g_grup      #No.FUN-980030 10/01/04
#     INSERT INTO axn_file VALUES (l_axn_n.*)
#     IF STATUS THEN
#        UPDATE axn_file SET axn18 = l_axn_n.axn18,
#                            axnmodu = g_user,
#                            axndate = g_today
#                      WHERE axn01 = l_axn_n.axn01   #年度 
#                        AND axn02 = l_axn_n.axn02   #月份
#                        AND axn14 = l_axn_n.axn14   #公司編號
#                        AND axn15 = l_axn_n.axn15   #帳別
#                        AND axn16 = l_axn_n.axn16   #幣別
#                        AND axn17 = l_axn_n.axn17   #分類代碼
#        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#           CALL cl_err('upd_axn)',SQLCA.sqlcode,1)   #No.FUN-660123
#           CALL cl_err3("upd","axn_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","upd_axn",1)   #No.FUN-660123 #NO.FUN-710023
#           LET g_showmsg=tm.aaa04,"/",tm.aaa05 
#           CALL s_errmsg('axn01,axn02',g_showmsg,'upd_axn)',SQLCA.sqlcode,1) #NO.FUN-710023 
#           LET g_success='N' RETURN 
#        END IF
#     END IF
#  END FOREACH
#
#  #找看看有沒有上期沒有，本期卻增加的分類代碼
#  DECLARE axo_cs1 CURSOR FOR
#     SELECT aya01,SUM(axo04)
#       FROM axo_file,aya_file
#      WHERE aya01 = axo14
#        AND axo01 = tm.aaa04       #年度
#        AND axo02 = tm.aaa05       #月份
#        AND axo11 = tm.axz01       #公司編號
#        AND axo12 = tm.axz05       #帳別
#        AND axo13 = tm.axz06       #幣別
#        AND axo14 NOT IN (SELECT axo14 FROM axo_file
#                           WHERE axo01 = l_yy           #年度
#                             AND axo02 = l_mm           #月份
#                             AND axo11 = tm.axz01       #公司編號
#                             AND axo12 = tm.axz05       #帳別
#                             AND axo13 = tm.axz06)      #幣別
#        AND axo14 NOT IN (SELECT axn17 FROM axn_file
#                           WHERE axn01 = l_yy           #年度 
#                             AND axn02 = l_mm           #月份
#                             AND axn14 = tm.axz01       #公司編號
#                             AND axn15 = tm.axz05       #帳別
#                             AND axn16 = tm.axz06)      #幣別
#      GROUP BY aya01
#
#  FOREACH axo_cs1 INTO l_aya01,l_axo04
#     #NO.FUN-710023--BEGIN                                                           
#     IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y' 
#     END IF                                                     
#     #NO.FUN-710023--END
#
#     IF SQLCA.sqlcode THEN
#        LET g_showmsg=tm.aaa04,"/",tm.aaa05,"/",tm.axz01,"/",tm.axz05,"/",tm.axz06
#        CALL s_errmsg('axo01,axo02,axo11,axo12,axo13',g_showmsg,'(axo_cs1#1:foreach)',SQLCA.sqlcode,1)
#        LET g_success='N' RETURN                             
#     END IF
#
#     INITIALIZE l_axn_n.* TO NULL
#
#     LET l_axn_n.axn01 = tm.aaa04       #年度
#     LET l_axn_n.axn02 = tm.aaa05       #月份
#     LET l_axn_n.axn14 = tm.axz01       #公司編號    #FUN-780068 add
#     LET l_axn_n.axn15 = tm.axz05       #帳別        #FUN-780068 add
#     LET l_axn_n.axn16 = tm.axz06       #幣別        #FUN-780068 add
#     LET l_axn_n.axn17 = l_aya01        #分類代碼    #FUN-780068 add
#     LET l_axn_n.axn18 = l_axo04        #餘額        #FUN-780068 add
#     LET l_axn_n.axnuser = g_user
#     LET l_axn_n.axngrup = g_grup
#     LET l_axn_n.axndate = g_today
#     LET l_axn_n.axnlegal = g_legal     #FUN-980003 add
#
#     INSERT INTO axn_file VALUES (l_axn_n.*)
#     IF STATUS THEN
#        UPDATE axn_file SET axn18 = axn18+l_axo04,
#                            axnmodu = g_user,
#                            axndate = g_today
#                      WHERE axn01 = l_axn_n.axn01   #年度 
#                        AND axn02 = l_axn_n.axn02   #月份
#                        AND axn14 = l_axn_n.axn14   #公司編號
#                        AND axn15 = l_axn_n.axn15   #帳別
#                        AND axn16 = l_axn_n.axn16   #幣別
#                        AND axn17 = l_aya01         #分類代碼
#        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#           CALL cl_err('upd_axn)',SQLCA.sqlcode,1)   #No.FUN-660123
#           CALL cl_err3("upd","axn_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","upd_axn",1)   #No.FUN-660123 #NO.FUN-710023
#           LET g_showmsg=tm.aaa04,"/",tm.aaa05 
#           CALL s_errmsg('axn01,axn02',g_showmsg,'upd_axn)',SQLCA.sqlcode,1) #NO.FUN-710023 
#           LET g_success='N' RETURN 
#        END IF
#     END IF
#  END FOREACH
# #end FUN-780068 mod
#
#  #NO.FUN-710023--BEGIN                                                           
#  IF g_totsuccess="N" THEN                                                        
#     LET g_success="N"                                                           
#  END IF                                                                          
#  #NO.FUN-710023--END
#
#END FUNCTION
#No.FUN-B60144--mark--

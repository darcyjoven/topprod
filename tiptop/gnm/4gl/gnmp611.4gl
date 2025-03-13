# Prog. Version..: '5.30.07-13.06.13(00006)'     #
#
# Pattern name...: gnmp611.4gl
# Descriptions...: 應收票據月底重評價還原作業
# Date & Author..: 07/11/19 By Carrier  #No.FUN-7B0092
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0072 09/12/08 By Smapmin 更新月底重評價年度月份nmz60,nmz61
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-CB0156 12/11/16 By yinhy 默認期間取nmz21、nmz22
# Modify.........: No:FUN-D40107 13/05/23 By lujh 傳參修改
# Modify.........: No:MOD-D60018 13/06/04 By Lori nmh24增加「託收」票據(nmh24='2') 

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_yy,g_mm	LIKE type_file.num5
DEFINE b_date,e_date    LIKE type_file.dat
DEFINE g_change_lang    LIKE type_file.chr1
DEFINE ls_date          STRING                 
 
MAIN
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE p_row,p_col   LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy   = ARG_VAL(1)
   LET g_mm   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GNM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
   WHILE TRUE
      IF g_bgjob = "N" THEN
         IF g_nmz.nmz59 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE
         ELSE
            CALL p610()
            IF cl_sure(18,20) THEN 
               LET g_success = 'Y'
               BEGIN WORK
               CALL cl_wait()
               CALL p610_t()
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
                  CLOSE WINDOW p610
                  EXIT WHILE
               END IF
            ELSE
               CONTINUE WHILE
            END IF
         END IF
      ELSE
         IF g_nmz.nmz59 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE
         ELSE
            LET g_success = 'Y'
            BEGIN WORK
            CALL p610_t()
            IF g_success = "Y" THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p610()
   DEFINE   lc_cmd        LIKE type_file.chr1000
   DEFINE   p_row,p_col   LIKE type_file.num5
 
   LET p_row=5
   LET p_col=25
   OPEN WINDOW p610 AT p_row,p_col
        WITH FORM "gnm/42f/gnmp610" 
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   #No.MOD-CB0156  --Begin
   #LET g_yy = YEAR(g_today)
   #LET g_mm = MONTH(g_today)
   IF cl_null(g_yy) OR g_yy=0 THEN   #FUN-D40107  add
      LET g_yy = g_nmz.nmz21
   END IF                  #FUN-D40107  add
   IF cl_null(g_mm) OR g_mm=0 THEN   #FUN-D40107  add
      LET g_mm = g_nmz.nmz22
   END IF                  #FUN-D40107  add
   #No.MOD-CB0156  --End
   LET g_bgjob = "N"
 
   WHILE TRUE
      INPUT BY NAME g_yy,g_mm,g_bgjob WITHOUT DEFAULTS
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT INPUT
 
         AFTER FIELD g_yy
            IF cl_null(g_yy) THEN 
               NEXT FIELD g_yy
            END IF
 
         AFTER FIELD g_mm
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
 
         AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT 
            END IF
            IF (g_yy*12+g_mm) < (g_nmz.nmz60*12+g_nmz.nmz61) THEN 
               CALL cl_err(g_mm,'axr-404',1) NEXT FIELD g_mm
            END IF
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about
            CALL cl_about()
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p610
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gnmp610"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gnmp610','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gnmp610',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p610
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p610_t()
   DEFINE #l_sql         LIKE type_file.chr1000
          l_sql   STRING      #NO.FUN-910082
   DEFINE l_name        LIKE type_file.chr20
   DEFINE yymm          LIKE azj_file.azj02
   DEFINE amt1,amt2     LIKE nmh_file.nmh32
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE l_net,l_amt   LIKE nmh_file.nmh32       
   DEFINE l_trno        LIKE npp_file.npp01
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE sr            RECORD 
                        nmh01   LIKE nmh_file.nmh01,
                        nmh04   LIKE nmh_file.nmh04,
                        nmh03   LIKE nmh_file.nmh03,
                        nmh28   LIKE nmh_file.nmh28,
                        nmh32   LIKE nmh_file.nmh32,
                        nmh39   LIKE nmh_file.nmh39,
                        nmh40   LIKE nmh_file.nmh40,
                        amt1    LIKE nmh_file.nmh32, 
                        azj07   LIKE azj_file.azj07,
                        nmh24   LIKE nmh_file.nmh24
                        END RECORD
   DEFINE l_yy          LIKE oox_file.oox01   #MOD-9C0072                                                                       
   DEFINE l_mm          LIKE oox_file.oox02   #MOD-9C0072
 
   CALL s_azn01(g_yy,g_mm) RETURNING b_date,e_date
   LET yymm = e_date USING 'yyyymmdd'
 
   LET l_trno = 'NM',g_yy USING '&&&&',g_mm USING '&&'
 
   SELECT COUNT(*) INTO l_cnt FROM npp_file 
    WHERE nppsys = 'NM' AND npp00 = 14 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'NR' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-415',1) LET g_success = 'N' RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM nmh_file 
    WHERE nmh03 != g_aza.aza17
     #AND nmh24 MATCHES '[13]' AND nmh38='Y'     #MOD-D60018 mark
      AND nmh24 IN ('1','2','3') AND nmh38='Y'   #MOD-D60018 add
      AND nmh04 <= e_date
      AND nmh01 IN (SELECT oob06 FROM ooa_file,oob_file 
                     WHERE ooa01=oob01 AND ooaconf !='X'
                       AND ooa02 > e_date ) 
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-402',1) LET g_success = 'N' RETURN 
   END IF
 
   DELETE FROM npp_file 
    WHERE nppsys = 'NM' AND npp00 = 14 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1)
      LET g_success='N' RETURN 
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'NM' AND npq00 = 14 AND npq011 = 1
      AND npq01 = l_trno 
   IF STATUS THEN
      CALL cl_err3("del","npq_file",l_trno,"",STATUS,"","del npq",1)
      LET g_success='N' RETURN  
   END IF

   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = l_trno
   IF STATUS THEN
      CALL cl_err3("del","tic_file",l_trno,"",STATUS,"","del tic",1)
      LET g_success='N' 
      RETURN
   END IF
   #FUN-B40056--add--end--
 
   DECLARE p610_del_curs1 CURSOR FOR 
     SELECT oox_file.* FROM oox_file 
      WHERE oox00 = 'NR' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p610_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p610_del_curs1',STATUS,1) LET g_success='N' RETURN 
      END IF
      DELETE FROM oox_file WHERE oox00 = l_oox.oox00 AND oox01 = l_oox.oox01 AND oox02 = l_oox.oox02
      AND oox03 = l_oox.oox03 AND oox04 = l_oox.oox04 AND oox041 = l_oox.oox041
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox01,STATUS,"","del oox",1)
         LET g_success='N' RETURN 
      END IF
      CALL s_g_np('4','1',sr.nmh01,'') RETURNING l_amt
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt
      UPDATE nmh_file SET nmh39 = l_oox.oox06, nmh40 = l_amt
       WHERE nmh01 = l_oox.oox03
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","nmh_file",l_oox.oox03,"",STATUS,"","upd nmh",1)
         LET g_success='N' RETURN 
      END IF
   END FOREACH
   #-----MOD-9C0072---------
   #更新月底重評價年度月份
   DECLARE upd_nmz_cs CURSOR FOR SELECT oox01,oox02 FROM oox_file                                                                   
                WHERE oox00 = 'NR'                                                                
                  AND (oox01 < g_yy OR (oox01 = g_yy AND oox02 < g_mm))
                ORDER BY oox01 desc,oox02 desc                                                                                           
   FOREACH upd_nmz_cs INTO l_yy,l_mm                                                                                                
      EXIT FOREACH                                                                                                                  
   END FOREACH                                                                                                                      
   UPDATE nmz_file SET nmz60 = l_yy,nmz61 = l_mm                                                                                    
    WHERE nmz00 = '0'                                                                                                               
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","nmz_file","","",STATUS,"","upd nmz60/61",1) 
      LET g_success='N'
   END IF
   #-----END MOD-9C0072-----
END FUNCTION
#No.FUN-7B0092

# Prog. Version..: '5.30.07-13.06.13(00005)'     #
#
# Pattern name...: gxrp601.4gl
# Descriptions...: 應收帳款月底重評價還原作業
# Date & Author..: 07/11/16 By Carrier  #No.FUN-7B0090
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0072 09/12/08 By Smapmin 更新月底重評價年度月份ooz05,ooz06
# Modify.........: No.FUN-9C0072 10/01/19 By vealxu 精簡程式碼
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料 
# Modfiy.........: No.MOD-B80182 11/08/19 By Polly 增加判斷抓取月底重評價的年度月份
# Modify.........: No:FUN-D40107 13/05/30 By zhangweib 有傳參時,年度期別不給默認值

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql   	string
DEFINE g_yy,g_mm	LIKE oox_file.oox01
DEFINE g_tabname        STRING
DEFINE g_key2           STRING
DEFINE b_date,e_date    LIKE type_file.dat
DEFINE g_flag           LIKE type_file.chr1
DEFINE g_change_lang    LIKE type_file.chr1
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy     = ARG_VAL(1)
   LET g_mm   = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GXR")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p601_tm()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p601_t()
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
               CLOSE WINDOW p601_w
               EXIT WHILE 
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         BEGIN WORK
         CALL p601_t()
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
 
FUNCTION p601_tm()
   DEFINE   lc_cmd        LIKE type_file.chr1000
 
   IF cl_null(g_yy) OR cl_null(g_mm) OR g_yy = 0 THEN   #No.FUN-D40107  Add
   LET g_yy = g_ooz.ooz05 
   LET g_mm = g_ooz.ooz06
   END IF   #No.FUN-D40107  Add
 
   OPEN WINDOW p601_w WITH FORM "gxr/42f/gxrp601"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
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
            IF (g_yy*12+g_mm) < (g_ooz.ooz05*12+g_ooz.ooz06) THEN 
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
         CLOSE WINDOW p601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gxrp601"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gxrp601','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED ,"'",
                         " '",g_mm CLIPPED ,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gxrp601',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p601_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
 
   END WHILE
END FUNCTION
 
FUNCTION p601_t()
   DEFINE yymm          LIKE azj_file.azj02
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE l_amt         LIKE oma_file.oma56       
   DEFINE l_trno        LIKE npp_file.npp01
   DEFINE l_oma00       LIKE oma_file.oma00
   DEFINE l_flag        LIKE type_file.chr1
   DEFINE yy1,mm1       LIKE type_file.num5
   DEFINE l_yy          LIKE oox_file.oox01   #MOD-9C0072                                                                       
   DEFINE l_mm          LIKE oox_file.oox02   #MOD-9C0072
 
   CALL s_azn01(g_yy,g_mm) RETURNING b_date,e_date
   LET yymm = e_date USING 'yyyymmdd'
 
   LET l_trno = 'AR',g_yy USING '&&&&',g_mm USING '&&'
 
   SELECT COUNT(*) INTO l_cnt FROM npp_file 
    WHERE nppsys = 'AR' AND npp00 = 4 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'AR' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-415',1) LET g_success = 'N' RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM oma_file
    WHERE oma23 != g_aza.aza17
      AND (oma00 MATCHES '1*' OR oma00 MATCHES '2*')
      AND omaconf='Y' AND omavoid='N'
      AND oma02 <= e_date
      AND oma01 IN (SELECT oob06 FROM ooa_file,oob_file
                      WHERE ooa01=oob01 AND ooaconf !='X' AND ooa00 ='1'
                        AND ooa02 > e_date)
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN 
      #CALL cl_err('','axr-402',1) LET g_success = 'N' RETURN   #mark by dengsy170326
   END IF
 
   DELETE FROM npp_file 
    WHERE nppsys = 'AR' AND npp00 = 4 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1)
      LET g_success='N' RETURN  
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'AR' AND npq00 = 4 AND npq011 = 1
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
 
   DECLARE p601_del_curs1 CURSOR FOR 
     SELECT oox_file.* FROM oox_file 
      WHERE oox00 = 'AR' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p601_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p601_del_curs1',STATUS,1) LET g_success='N' RETURN 
      END IF
 
      DELETE FROM oox_file WHERE oox00 = l_oox.oox00 AND oox01 = l_oox.oox01 AND oox02 = l_oox.oox02
      AND oox03 = l_oox.oox03 AND oox04 = l_oox.oox04 AND oox041 = l_oox.oox041
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox01,STATUS,"","del oox",1)
         LET g_success='N' RETURN 
      END IF
 
      SELECT oma00 INTO l_oma00 FROM oma_file WHERE oma01=l_oox.oox03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","oma_file",l_oox.oox03,"",STATUS,"","sel oma",1)
         LET g_success ='N' EXIT FOREACH
      END IF
 
      LET l_amt = 0 
      IF l_oma00 MATCHES '1*' THEN
         IF g_ooz.ooz62 = 'N' THEN
            #CALL s_g_np1('1',l_oma00,l_oox.oox03,0,l_oox.oox041) RETURNING l_amt  #mark by dengsy170326
            CALL s_g_np2('1',l_oma00,l_oox.oox03,0,l_oox.oox041,g_yy,g_mm) RETURNING l_amt #add by dengsy170326
            IF cl_null(l_amt) THEN LET l_amt = 0 END IF           
            CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt
            UPDATE omc_file SET omc07 = l_oox.oox06, omc13 = l_amt
             WHERE omc01 = l_oox.oox03 AND omc02 = l_oox.oox041
            LET g_tabname = "omc_file"
            LET g_key2 = l_oox.oox041
         ELSE
            CALL s_g_np('1',l_oma00,l_oox.oox03,l_oox.oox04) RETURNING l_amt
            IF cl_null(l_amt) THEN LET l_amt = 0 END IF           
            CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt
            UPDATE omb_file SET omb36 = l_oox.oox06, omb37 = l_amt
             WHERE omb01 = l_oox.oox03 AND omb03 = l_oox.oox04
            LET g_tabname = "omb_file"
            LET g_key2=l_oox.oox04
         END IF
      ELSE
         #CALL s_g_np1('1',l_oma00,l_oox.oox03,0,l_oox.oox041) RETURNING l_amt  #mark by dengsy170326
         CALL s_g_np2('1',l_oma00,l_oox.oox03,0,l_oox.oox041,g_yy,g_mm) RETURNING l_amt   #add by dengsy170326
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF           
         CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt
         UPDATE omc_file SET omc07 = l_oox.oox06, omc13 = l_amt
          WHERE omc01 = l_oox.oox03 AND omc02 = l_oox.oox041
         LET g_tabname = "omc_file"
         LET g_key2 = l_oox.oox041
      END IF
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd",g_tabname,l_oox.oox03,g_key2,STATUS,"","upd oma/omb/omc",1)
         LET g_success='N' RETURN
      END IF
 
      IF (l_oma00 MATCHES '1*' AND g_ooz.ooz62 = 'Y') OR g_ooz.ooz62 = 'N' THEN
         LET l_amt = 0
         CALL s_g_np('1',l_oma00,l_oox.oox03,0) RETURNING l_amt
         IF cl_null(l_amt) THEN LET l_amt = 0 END IF
         CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt
         UPDATE oma_file SET oma60 = l_oox.oox06, oma61 = l_amt
          WHERE oma01 = l_oox.oox03
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","oma_file",l_oox.oox03,"",SQLCA.sqlcode,"","upd oma2",1)
            LET g_success='N' EXIT FOREACH 
         END IF
      END IF
 
   END FOREACH
   #更新月底重評價年度月份
   DECLARE upd_ooz_cs CURSOR FOR SELECT oox01,oox02 FROM oox_file                                                                   
                WHERE oox00 = 'AR'                                                                
                  AND (oox01 < g_yy OR (oox01 = g_yy AND oox02 < g_mm))
                ORDER BY oox01 desc,oox02 desc                                                                                           
   FOREACH upd_ooz_cs INTO l_yy,l_mm                                                                                                
      EXIT FOREACH                                                                                                                  
   END FOREACH                                                                                                                      
   #----------------------------No.MOD-B80182-------------------------start
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'AR'
      AND (oox01 < g_yy OR (oox01 = g_yy AND oox02 < g_mm))
     
   IF l_cnt = 0 THEN
      LET l_yy = g_yy
      LET l_mm = g_mm -1
      IF l_mm = 0 THEN
         LET l_yy = l_yy -1
         LET l_mm = 12
      END IF
   END IF
   #----------------------------No.MOD-B80182---------------------------end
   UPDATE ooz_file SET ooz05 = l_yy,ooz06 = l_mm                                                                                    
    WHERE ooz00 = '0'                                                                                                               
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ooz_file","","",STATUS,"","upd ooz05/06",1) 
      LET g_success='N'
   END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

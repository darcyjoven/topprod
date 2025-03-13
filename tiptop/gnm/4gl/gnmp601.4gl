# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: gnmp601.4gl
# Descriptions...: 外幣存款月底重評價還原作業
# Date & Author..: 07/11/19 By Carrier  #No.FUN-7B0092
# Modify.........: No.MOD-850088 08/05/09 By Sarah 更新月底重評價年度月份nmz21,nmz22
# Modify.........: No.MOD-860097 08/06/11 By Sarah g_sql及DELETE條件判斷nme03=g_nmz.nmz35,應改為判斷nme22='24'
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990193 09/09/22 By mike update nmz22 錯誤  
# Modify.........: No:MOD-9C0072 09/12/08 By Smapmin 修正MOD-990193
# Modify.........: No:CHI-A70029 10/07/16 By Summer 取消 nmg_file 部分
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modfiy.........: No.MOD-B80182 11/08/19 By Polly 增加判斷抓取月底重評價的年度月份
# Modify.........: No:MOD-CB0156 12/11/16 By yinhy 默認期間取nmz21、nmz22

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql   	string
DEFINE g_yy,g_mm	LIKE type_file.num5
DEFINE b_date,e_date    LIKE type_file.dat
DEFINE g_nmc04          LIKE nmc_file.nmc04
DEFINE g_nmc05          LIKE nmc_file.nmc05
DEFINE g_change_lang    LIKE type_file.chr1
DEFINE ls_date          STRING                 
 
MAIN
   DEFINE p_row,p_col   LIKE type_file.num5
   DEFINE l_flag        LIKE type_file.chr1
 
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
         IF g_nmz.nmz20 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE
         ELSE
            CALL p601()
            IF cl_sure(18,20) THEN 
               LET g_success = 'Y'
               BEGIN WORK
               CALL p601_t()
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
                  CLOSE WINDOW p601
                  EXIT WHILE
               END IF
            ELSE
               CONTINUE WHILE
            END IF
         END IF
      ELSE
         IF g_nmz.nmz20 = 'N' THEN
            CALL cl_err('','axr-408',1)
            EXIT WHILE
         ELSE
            LET g_success = 'Y'
            BEGIN WORK
            CALL p601_t()
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
 
FUNCTION p601()
   DEFINE   lc_cmd        LIKE type_file.chr1000
   DEFINE   p_row,p_col   LIKE type_file.num5
 
   LET p_row=5
   LET p_col=25
   OPEN WINDOW p601 AT p_row,p_col
        WITH FORM "gnm/42f/gnmp601" 
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   #No.MOD-CB0156  --Begin
   #LET g_yy = YEAR(g_today)
   #LET g_mm = MONTH(g_today)
   LET g_yy = g_nmz.nmz21
   LET g_mm = g_nmz.nmz22
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
            IF (g_yy*12+g_mm) < (g_nmz.nmz21*12+g_nmz.nmz22) THEN 
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
         CLOSE WINDOW p601
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gnmp601"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
             CALL cl_err('gnmp601','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gnmp601',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p601
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      EXIT WHILE
 
   END WHILE
END FUNCTION
 
FUNCTION p601_t()
   DEFINE yymm          LIKE azj_file.azj02
  #DEFINE l_amt         LIKE oma_file.oma56 #CHI-A70029 mark
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE l_trno        LIKE npp_file.npp01
   DEFINE l_edate       LIKE nme_file.nme12
   DEFINE l_nme24       LIKE nme_file.nme24
   DEFINE l_yy          LIKE oox_file.oox01 #MOD-990193                                                                             
   DEFINE l_mm          LIKE oox_file.oox02 #MOD-990193     
   CALL s_azn01(g_yy,g_mm) RETURNING b_date,e_date
   LET yymm = e_date USING 'yyyymmdd'
 
   LET l_trno = 'NM',g_yy USING '&&&&',g_mm USING '&&'
 
   SELECT COUNT(*) INTO l_cnt FROM npp_file 
    WHERE nppsys = 'NM' AND npp00 = 13 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'NM' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-415',1) LET g_success = 'N' RETURN 
   END IF
 
  #CHI-A70029 mark --start--
  #SELECT COUNT(*) INTO l_cnt FROM nmg_file,npk_file
  # WHERE nmg00 = npk00
  #   AND npk05 != g_aza.aza17
  #   AND nmg20 MATCHES '2*' AND nmgconf='Y' 
  #   AND nmg01 <= e_date
  #   AND nmg00 IN (SELECT oob06 FROM ooa_file,oob_file 
  #                  WHERE ooa01=oob01 AND ooaconf !='X'
  #                    AND ooa02 > e_date ) 
  #IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
  #IF l_cnt > 0 THEN 
  #   CALL cl_err('','axr-402',1) LET g_success = 'N' RETURN 
  #END IF
  #CHI-A70029 mark --end--
 
   DELETE FROM npp_file 
    WHERE nppsys = 'NM' AND npp00 = 13 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1)
      LET g_success='N' RETURN  
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'NM' AND npq00 = 13 AND npq011 = 1
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
      WHERE oox00 = 'NM' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p601_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p601_del_curs1',STATUS,1) LET g_success='N' RETURN 
      END IF
 
      DELETE FROM oox_file WHERE oox00 = l_oox.oox00 AND oox01 = l_oox.oox01 AND oox02 = l_oox.oox02 AND oox03 = l_oox.oox03 AND oox04 = l_oox.oox04 AND oox041 = l_oox.oox041
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox01,STATUS,"","del oox",1)
         LET g_success='N' RETURN  
      END IF
 
     #CHI-A70029 mark --start--
     #IF l_oox.oox03v = '2' THEN
     #   CALL s_g_np('3','2',l_oox.oox03,'') RETURNING l_amt
     #   IF cl_null(l_amt) THEN LET l_amt = 0 END IF
     #   CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt
     #   UPDATE nmg_file SET nmg09 = l_oox.oox06, nmg10 = l_amt
     #    WHERE nmg00 = l_oox.oox03
     #   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
     #      CALL cl_err3("upd","nmg_file",l_oox.oox03,"",STATUS,"","upd nmg",1)
     #      LET g_success='N' RETURN 
     #   END IF
     #END IF
     #CHI-A70029 mark --end--
 
      LET l_edate = e_date USING 'YYYYMMDD'
      IF l_oox.oox03v = '1' THEN
         IF g_aza.aza73 = 'Y' THEN
            LET g_sql="SELECT nme24 FROM nme_file",
                      " WHERE nme01='", l_oox.oox03,"'",
                      "   AND nme02='", e_date,"'",
                     #"   AND nme03='", g_nmz.nmz35,"'",   #MOD-860097 mark
                      "   AND nme22='24'",                 #MOD-860097
                      "   AND nme12='", l_edate,"'"
            PREPARE del_nme24_p FROM g_sql
            DECLARE del_nme24_cs CURSOR FOR del_nme24_p
            FOREACH del_nme24_cs INTO l_nme24
               IF l_nme24 != '9' THEN
                  CALL cl_err(l_edate,'anm-043',1)
                  LET g_success='N'
                  RETURN
               END IF
            END FOREACH
         END IF
         
         #FUN-B40056  --begin
         IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
            DELETE FROM tic_file
             WHERE tic04 IN (
            SELECT nme12 FROM nme_file
             WHERE nme01 = l_oox.oox03 AND nme02 = e_date
               AND nme22 = '24'
               AND nme12 = l_edate )
            IF STATUS THEN 
               CALL cl_err3("del","tic_file",l_oox.oox03,e_date,STATUS,"","del tic",0)
               LET g_success ='N'   
            END IF
         END IF
         #FUN-B40056  --end
         
         DELETE FROM nme_file
          WHERE nme01 = l_oox.oox03 AND nme02 = e_date
           #AND nme03 = g_nmz.nmz35 AND nme12 = l_edate   #MOD-860097 mark
            AND nme22 = '24'        AND nme12 = l_edate   #MOD-860097
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
            CALL cl_err3("del","nme_file",l_oox.oox03,e_date,STATUS,"","del nme",1)
            LET g_success ='N'   
         END IF
         UPDATE nmp_file SET nmp17 = nmp17 - l_oox.oox10,
                             nmp19 = nmp19 - l_oox.oox10,
                             nmp07 = nmp07 - l_oox.oox10,
                             nmp09 = nmp09 - l_oox.oox10
          WHERE nmp01 = l_oox.oox03 AND nmp02 = l_oox.oox01
            AND nmp03 = l_oox.oox02
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
            CALL cl_err3("upd","nmp_file",l_oox.oox03,l_oox.oox01,STATUS,"","upd nmp",1)
            LET g_success ='N'   
         END IF
      END IF
   END FOREACH
  #str MOD-850088 add
   #更新月底重評價年度月份
  #MOD-990193   ---start        
  #UPDATE nmz_file SET nmz21 = g_yy, nmz22 = g_mm
  # WHERE nmz00 = '0'
   DECLARE upd_nmz_cs CURSOR FOR SELECT oox01,oox02 FROM oox_file                                                                   
                #-----MOD-9C0072---------
                #WHERE oox00 = 'NM' AND oox01 <= g_yy AND oox02 <g_mm                                                                
                #ORDER BY oox01,oox02 desc                                                                                           
                WHERE oox00 = 'NM'                                                                
                  AND (oox01 < g_yy OR (oox01 = g_yy AND oox02 < g_mm))
                ORDER BY oox01 desc,oox02 desc                                                                                           
                #-----END MOD-9C0072-----
   FOREACH upd_nmz_cs INTO l_yy,l_mm                                                                                                
      EXIT FOREACH                                                                                                                  
   END FOREACH                                                                                                                      
   #----------------------------No.MOD-B80182-------------------------start
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'NM'
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
   UPDATE nmz_file SET nmz21 = l_yy,nmz22 = l_mm                                                                                    
    WHERE nmz00 = '0'                                                                                                               
  #MOD-990193   ---end                
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('upd nmz21/22',STATUS,1)    #No.FUN-660146
      CALL cl_err3("upd","nmz_file","","",STATUS,"","upd nmz21/22",1)   #No.FUN-660146
      LET g_success='N'
   END IF
  #end MOD-850088 add
END FUNCTION
#No.FUN-7B0092

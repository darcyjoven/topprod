# Prog. Version..: '5.30.07-13.06.13(00007)'     #
#
# Pattern name...: gapp601.4gl
# Descriptions...: 應付帳款月底重評價還原作業
# Date & Author..: 07/11/16 By Carrier  #No.FUN-7B0090
# Modify.........: No.MOD-910075 09/01/08 By Nicola 於 axr-402 增加 api_file 針對 api26 檢核(參考 apv_file 檢核部分)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-980152 09/09/03 By sabrina 若g_apz.apz27='N'時，錯誤訊息會無法關掉 
# Modify.........: No:MOD-9C0072 09/12/08 By Smapmin 更新月底重評價年度月份apz21,apz22
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modfiy.........: No.MOD-B80182 11/08/19 By Polly 增加判斷抓取月底重評價的年度月份
# Modify.........: No:MOD-CB0158 12/11/16 By yinhy 默認期間取apz21、apz22
# Modify.........: No:FUN-D40107 13/05/30 By zhangweib 有傳參時,年度期別不給默認值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql   	string
DEFINE g_yy,g_mm	LIKE type_file.num5
DEFINE b_date,e_date    LIKE type_file.dat
DEFINE g_change_lang    LIKE type_file.chr1
DEFINE g_flag           LIKE type_file.chr1
 
MAIN
      DEFINE   p_row,p_col   LIKE type_file.num5
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)
   LET g_mm    = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF
 
#  CALL cl_used('gapp601',g_time,1) RETURNING g_time
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   WHILE TRUE
     IF g_bgjob = "N" THEN
        IF g_apz.apz27 = 'N' THEN
           CALL cl_err('','axr-408',1) 
           EXIT WHILE            #MOD-980152 add
        ELSE
           CALL p601()
           LET g_success='Y'          
           CALL cl_wait()
           BEGIN WORK
           IF cl_sure(15,20) THEN 
              CALL p601_t()
              IF g_success = 'Y' THEN
                 COMMIT WORK
                 CALL cl_end2(1) RETURNING g_flag #批次作業正確結束
              ELSE
                 ROLLBACK WORK
                 CALL cl_end2(2) RETURNING g_flag #批次作業失敗
              END IF
              IF g_flag THEN
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
        IF g_apz.apz27 = 'N' THEN
           CALL cl_err('','axr-408',1) 
           EXIT WHILE            #MOD-980152 add
        ELSE
           LET g_success='Y'          
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
     EXIT WHILE
   END WHILE
 
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION p601()
   DEFINE p_row,p_col     LIKE type_file.num5
   DEFINE lc_cmd          LIKE type_file.chr1000
 
   OPEN WINDOW p601 AT p_row,p_col WITH FORM "gap/42f/gapp601" 
      ATTRIBUTE (STYLE = g_win_style)
   
   CALL cl_ui_init()
 
  #No.MOD-CB0158  --Begin
  # SELECT aznn02,aznn04 INTO g_yy,g_mm
  #   FROM aznn_file
  #  WHERE aznn00=g_apz.apz02b
  #    AND aznn01=g_today
  IF cl_null(g_yy) OR cl_null(g_mm) OR g_yy = 0 THEN   #No.FUN-D40107  Add
     LET g_yy = g_apz.apz21
     LET g_mm = g_apz.apz22
     #No.MOD-CB0158  --End 
  END IF   #No.FUN-D40107  Add
   LET g_bgjob = 'N'
 
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
            IF (g_yy*12+g_mm) < (g_apz.apz21*12+g_apz.apz22) THEN 
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
         CLOSE WINDOW p601
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211         
         EXIT PROGRAM
      END IF
 
      IF g_bgjob = "Y" THEN
         LET lc_cmd = NULL
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "gapp601"
         IF SQLCA.sqlcode OR cl_null(lc_cmd) THEN
            CALL cl_err('gapp601','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('gapp601',g_time,lc_cmd CLIPPED)
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
   DEFINE l_apa00       LIKE apa_file.apa00
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE l_oox         RECORD LIKE oox_file.*
   DEFINE l_amt         LIKE oma_file.oma56       
   DEFINE l_trno        LIKE npp_file.npp01
   DEFINE yy1,mm1       LIKE type_file.num5
   DEFINE l_yy          LIKE oox_file.oox01   #MOD-9C0072                                                                       
   DEFINE l_mm          LIKE oox_file.oox02   #MOD-9C0072
 
   CALL s_azn01(g_yy,g_mm) RETURNING b_date,e_date
   LET yymm = e_date USING 'yyyymmdd'
 
   LET l_trno = 'AP',g_yy USING '&&&&',g_mm USING '&&'
 
   SELECT COUNT(*) INTO l_cnt FROM npp_file 
    WHERE nppsys = 'AP' AND npp00 = 5 AND npp011 = 1
      AND npp01 = l_trno AND nppglno IS NOT NULL 
   IF l_cnt > 0 THEN 
      CALL cl_err(l_trno,'anm-230',1) LET g_success = 'N' RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'AP' AND (oox01 > g_yy OR (oox01 = g_yy AND oox02 > g_mm))
   IF l_cnt > 0 THEN 
      CALL cl_err('','axr-415',1) LET g_success = 'N' RETURN 
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM apa_file
    WHERE apa13 != g_aza.aza17
      AND apa41 = 'Y' AND apa42 = 'N'
      AND apa02 <= e_date
      AND (apa01 IN (SELECT apg04 FROM apf_file,apg_file 
                      WHERE apf01=apg01 AND apf00 = '33'
                        AND apf41 = 'Y'
                        AND apf02 > e_date) OR 
           apa01 IN (SELECT apv03 FROM apv_file,apa_file
                      WHERE apv01=apa01
                        AND apa41 = 'Y' 
                        AND apa02 > e_date) OR
           apa01 IN (SELECT aph04 FROM apf_file,aph_file 
                      WHERE aph01=apf01  
                        AND apf41 = 'Y'
                        AND apf02 > e_date) OR
           apa01 IN (SELECT oob06 FROM oob_file,ooa_file
                      WHERE oob01=ooa01 
                        AND ooaconf = 'Y' 
                        AND oob03 = '2' AND oob04 = '9'
                        AND ooa02 > e_date) OR
           #-----No.MOD-910075-----
           apa01 IN (SELECT api26 FROM api_file,apa_file
                      WHERE apa01 = api01
                        AND apa41 = 'Y' 
                        AND apa02 > e_date))
           #-----No.MOD-910075 END-----
 
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   IF l_cnt > 0 THEN 
      #CALL cl_err('','axr-402',1) LET g_success = 'N' RETURN  #mark by dengsy170326 
   END IF
 
   DELETE FROM npp_file 
    WHERE nppsys = 'AP' AND npp00 = 5 AND npp011 = 1
      AND npp01 = l_trno 
   IF STATUS THEN
      CALL cl_err3("del","npp_file",l_trno,"",STATUS,"","del npp",1)
      LET g_success='N' RETURN
   END IF
   DELETE FROM npq_file 
    WHERE npqsys = 'AP' AND npq00 = 5 AND npq011 = 1
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
      WHERE oox00 = 'AP' AND oox01 = g_yy AND oox02 = g_mm
   FOREACH p601_del_curs1 INTO l_oox.*
      IF STATUS THEN
         CALL cl_err('p601_del_curs1',STATUS,1) LET g_success='N' RETURN
      END IF
      DELETE FROM oox_file WHERE oox00 = l_oox.oox00 AND oox01 = l_oox.oox01 AND oox02 = l_oox.oox02 AND oox03 = l_oox.oox03
     AND oox04 = l_oox.oox04 AND oox041 = l_oox.oox041
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("del","oox_file",l_oox.oox03,l_oox.oox04,STATUS,"","del oox",1)
         LET g_success='N' RETURN
      END IF
 
      SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=l_oox.oox03
      IF SQLCA.sqlcode THEN
         CALL cl_err3("sel","apa_file",l_oox.oox03,"",STATUS,"","sel apa",1)
         LET g_success ='N' EXIT FOREACH
      END IF
      LET l_amt = 0
      CALL s_g_np1('2',l_apa00,l_oox.oox03,0,l_oox.oox041) RETURNING l_amt  #mark by dengsy170326 #remark by liumin 170415
      #CALL s_g_np2('2',l_apa00,l_oox.oox03,0,l_oox.oox041,g_yy,g_mm) RETURNING l_amt  #add by dengsy170326 #mark by liumin 170415
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt
      UPDATE apc_file SET apc07 = l_oox.oox06, apc13 = l_amt
       WHERE apc01 = l_oox.oox03
         AND apc02 = l_oox.oox041
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","apc_file",l_oox.oox03,l_oox.oox041,STATUS,"","upd apc",1)
         LET g_success='N' RETURN
      END IF
      LET l_amt = 0
      CALL s_g_np('2',l_apa00,l_oox.oox03,0) RETURNING l_amt
      IF cl_null(l_amt) THEN LET l_amt = 0 END IF
      CALL cl_digcut(l_amt,g_azi04) RETURNING l_amt
      UPDATE apa_file SET apa72 = l_oox.oox06, apa73 = l_amt
       WHERE apa01 = l_oox.oox03
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","apa_file",l_oox.oox03,'',STATUS,"","upd apa",1)
         LET g_success='N' RETURN
      END IF
 
   END FOREACH
   #-----MOD-9C0072---------
   #更新月底重評價年度月份
   DECLARE upd_apz_cs CURSOR FOR SELECT oox01,oox02 FROM oox_file                                                                   
                WHERE oox00 = 'AP'                                                                
                  AND (oox01 < g_yy OR (oox01 = g_yy AND oox02 < g_mm))
                ORDER BY oox01 desc,oox02 desc                                                                                           
   FOREACH upd_apz_cs INTO l_yy,l_mm                                                                                                
      EXIT FOREACH                                                                                                                  
   END FOREACH                                                                                                                      
   #----------------------------No.MOD-B80182-------------------------start
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM oox_file
    WHERE oox00 = 'AP'
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
   UPDATE apz_file SET apz21 = l_yy,apz22 = l_mm                                                                                    
    WHERE apz00 = '0'                                                                                                               
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","apz_file","","",STATUS,"","upd apz21/22",1) 
      LET g_success='N'
   END IF
   #-----END MOD-9C0072-----
 
END FUNCTION
#No.FUN-7B0090

# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: afap407.4gl
# Descriptions...: 固定資產稅簽月底結轉還原作業                    
# Date & Author..: No.CHI-860025 08/07/23 By Smapmin 
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢

DATABASE ds
 
GLOBALS "../../config/top.global"
 
 
DEFINE   g_yy,g_mm        LIKE type_file.num5,
         g_yy2,g_mm2      LIKE type_file.num5,
         l_flag           LIKE type_file.chr1,
         p_row,p_col      LIKE type_file.num5
 
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
WHILE TRUE
    IF g_bgjob = "N" THEN
       CALL p407()
       IF cl_sure(18,20) THEN
          LET g_success = 'Y'
          BEGIN WORK
          CALL p407_1()
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
             CLOSE WINDOW p407_w
             EXIT WHILE
          END IF
      ELSE
       CONTINUE WHILE
      END IF
   ELSE
     BEGIN WORK
     CALL p407_1()
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
 
FUNCTION p407()
  DEFINE   lc_cmd      LIKE type_file.chr1000    
 
  LET p_row = 5 LET p_col = 28
 
  OPEN WINDOW p407_w AT p_row,p_col WITH FORM "afa/42f/afap407"
   ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
 
  CLEAR FORM
  SELECT faa11,faa12 INTO g_yy,g_mm FROM faa_file
  DISPLAY g_yy TO FORMONLY.g_yy 
  DISPLAY g_mm TO FORMONLY.g_mm 
  IF g_mm-1 = 0 THEN   
     LET g_yy2 = g_yy - 1
     LET g_mm2 = 12
  ELSE
     LET g_yy2 = g_yy
     LET g_mm2 = g_mm - 1
  END IF
  DISPLAY g_yy2 TO FORMONLY.g_yy2
  DISPLAY g_mm2 TO FORMONLY.g_mm2
  LET g_bgjob = "N"
WHILE TRUE
  INPUT BY NAME g_bgjob WITHOUT DEFAULTS
    ON ACTION CONTROLG
       CALL cl_cmdask()
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about         
       CALL cl_about()      
 
    ON ACTION help          
       CALL cl_show_help()  
 
    ON ACTION locale    
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()       
       EXIT INPUT
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p407_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
      RETURN
   END IF
 
   IF g_bgjob = "Y" THEN
    SELECT zz08 INTO lc_cmd FROM zz_file
     WHERE zz01 = "afap407"
    IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
       CALL cl_err('afap407','9031',1)   
    ELSE
       LET lc_cmd = lc_cmd CLIPPED,
                    " '",g_yy CLIPPED,"'",
                    " '",g_mm CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
       CALL cl_cmdat('afap407',g_time,lc_cmd CLIPPED)
    END IF
    CLOSE WINDOW p407_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
    EXIT PROGRAM
   END IF
 EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p407_1()
  DEFINE l_cnt    LIKE type_file.num5,
         l_faj02  LIKE faj_file.faj02,
         l_faj022 LIKE faj_file.faj022,
         l_faj23  LIKE faj_file.faj23,
         l_faj24  LIKE faj_file.faj24,
         l_faj20  LIKE faj_file.faj20,
         l_faj205 LIKE faj_file.faj205,
         l_fao07  LIKE fao_file.fao07 
  
    #不可存在大於/等於該月份的折舊資料
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt FROM fao_file
      WHERE ((fao03=g_yy AND fao04>=g_mm) OR
              fao03>g_yy)
    IF l_cnt > 0 THEN
       CALL cl_err('','afa-187',1)
       LET g_success='N' 
       RETURN
    END IF
 
    #不可存在大於/等於該月份的異動/處份資料
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM fay_file,faz_file
      WHERE fay01=faz01 
        AND ((YEAR(fay02)=g_yy AND MONTH(fay02)>=g_mm) OR 
              YEAR(fay02)>g_yy)
    IF l_cnt > 0 THEN
       CALL cl_err('','afa-156',1)
       LET g_success='N' 
       RETURN
    END IF
       
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM fba_file,fbb_file
      WHERE fba01=fbb01
        AND ((YEAR(fba02)=g_yy AND MONTH(fba02)>=g_mm) OR 
              YEAR(fba02)>g_yy)
    IF l_cnt > 0 THEN
       CALL cl_err('','afa-140',1)
       LET g_success='N' 
       RETURN
    END IF
    
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM fbc_file,fbd_file
      WHERE fbc01=fbd01
        AND ((YEAR(fbc02)=g_yy AND MONTH(fbc02)>=g_mm) OR
              YEAR(fbc02)>g_yy)
    IF l_cnt > 0 THEN
       CALL cl_err('','afa-141',1)
       LET g_success='N' 
       RETURN
    END IF
    
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM fgh_file,fgi_file
      WHERE fgh01=fgi01
        AND ((YEAR(fgh02)=g_yy AND MONTH(fgh02)>=g_mm) OR
              YEAR(fgh02)>g_yy)
        AND fghconf<>'X'  #CHI-C80041
              
    IF l_cnt > 0 THEN
       CALL cl_err('','afa-142',1)
       LET g_success='N' 
       RETURN
    END IF
    
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM fbg_file,fbh_file
      WHERE fbg01=fbh01 
        AND ((YEAR(fbg02)=g_yy AND MONTH(fbg02)>=g_mm) OR
              YEAR(fbg02)>g_yy)
    IF l_cnt > 0 THEN
       CALL cl_err('','afa-143',1)
       LET g_success='N' 
       RETURN
    END IF
    
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM fbe_file,fbf_file
      WHERE fbe01=fbf01 
        AND ((YEAR(fbe02)=g_yy AND MONTH(fbe02)>=g_mm) OR
              YEAR(fbe02)>g_yy)
    IF l_cnt > 0 THEN
       CALL cl_err('','afa-144',1)
       LET g_success='N' 
       RETURN
    END IF
    
  
    DELETE FROM foo_file WHERE foo03=g_yy AND foo04=g_mm
    IF STATUS THEN 
        CALL cl_err3("del","foo_file",g_yy,g_mm,STATUS,"","del foo:",1) 
        LET g_success = 'N'        
        RETURN 
    END IF
 
    #本期累折(faj205)會因afap405年結動作而歸零.
    #當本期累折(faj205)還原為0時,要update成上一年度的SUM(fao07)
    IF g_yy <> g_yy2 THEN 
       DECLARE p407_faj_c CURSOR FOR SELECT faj02,faj022 FROM faj_file WHERE 1=1 
       FOREACH p407_faj_c INTO l_faj02,l_faj022 
          IF SQLCA.sqlcode THEN 
             CALL cl_err('p407_faj_c',SQLCA.sqlcode,0)
             LET g_success='N'
             RETURN
          END IF
          SELECT faj23,faj24,faj20,faj205 
             INTO l_faj23,l_faj24,l_faj20,l_faj205 FROM faj_file
              WHERE faj02=l_faj02 AND faj022=l_faj022
          IF cl_null(l_faj20) THEN LET l_faj20 = ' ' END IF
          IF l_faj205 = 0 THEN
             IF l_faj23 = '1' THEN 
                SELECT SUM(fao07) INTO l_fao07 FROM fao_file
                  WHERE fao01= l_faj02 AND fao02=l_faj022 AND
                        fao03=g_yy2 AND fao06=l_faj24
             ELSE
                SELECT SUM(fao07) INTO l_fao07 FROM fao_file
                  WHERE fao01=l_faj02 AND fao02=l_faj022 AND
                        fao03=g_yy2 AND fao06=l_faj20
             END IF
             IF cl_null(l_fao07) THEN LET l_fao07 = 0 END IF
             UPDATE faj_file SET faj205 = l_fao07 WHERE faj02=l_faj02
                                                    AND faj022=l_faj022
             IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                CALL cl_err3("upd","faj_file",l_faj02,l_faj022,STATUS,"","upd faj:",1)
                LET g_success='N'
                RETURN
             END IF
          END IF
       END FOREACH
    END IF
 
    #update 現行年月
    UPDATE faa_file SET faa11=g_yy2,faa12=g_mm2
    IF STATUS THEN 
        CALL cl_err3("upd","faa_file",g_yy2,g_mm2,STATUS,"","upd faa:",1) 
        LET g_success = 'N'        
        RETURN 
    END IF
END FUNCTION
#CHI-860025

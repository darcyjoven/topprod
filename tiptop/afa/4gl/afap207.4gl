# Prog. Version..: '5.30.06-13.03.12(00002)'     #
#
# Pattern name...: afap207.4gl
# Descriptions...: 財簽二固定資產月底結轉還原作業                    
# Date & Author..: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No.CHI-C60010 12/06/15 By wangrr 財簽二欄位需依財簽二幣別做取位
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢

DATABASE ds

GLOBALS "../../config/top.global"


DEFINE g_yy,g_mm        LIKE type_file.num5,
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

   IF g_faa.faa31 = 'N' THEN
      CALL cl_err('','afa-260',1)
      EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time 
   SET LOCK MODE TO WAIT

   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p207()
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            BEGIN WORK
            CALL p207_1()
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
               CLOSE WINDOW p207_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
          BEGIN WORK
          CALL p207_1()
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

FUNCTION p207()
   DEFINE lc_cmd      LIKE type_file.chr1000    
   
   LET p_row = 5 LET p_col = 28
   
   OPEN WINDOW p207_w AT p_row,p_col WITH FORM "afa/42f/afap207"
     ATTRIBUTE (STYLE = g_win_style)
   
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   
   CLEAR FORM

   SELECT faa072,faa082 INTO g_yy,g_mm FROM faa_file

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
         CLOSE WINDOW p207_w
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
         EXIT PROGRAM
         RETURN
      END IF
     
      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afap207"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap207','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " '",g_yy CLIPPED,"'",
                         " '",g_mm CLIPPED,"'",
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('afap207',g_time,lc_cmd CLIPPED)
         END IF

         CLOSE WINDOW p207_w
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
         EXIT PROGRAM
      END IF
      EXIT WHILE
   END WHILE

END FUNCTION

FUNCTION p207_1()
   DEFINE l_cnt     LIKE type_file.num5,
          l_faj02   LIKE faj_file.faj02,
          l_faj022  LIKE faj_file.faj022,
          l_faj23   LIKE faj_file.faj23,
          l_faj24   LIKE faj_file.faj24,
          l_faj20   LIKE faj_file.faj20,
          l_faj203  LIKE faj_file.faj203,
          l_faj232  LIKE faj_file.faj232,   #No:FUN-AB0088
          l_faj242  LIKE faj_file.faj242,   #No:FUN-AB0088
          l_faj2032 LIKE faj_file.faj2032,  #No:FUN-AB0088
          l_fbn07   LIKE fbn_file.fbn07     #No:FUN-AB0088 
   DEFINE l_azi04   LIKE azi_file.azi04     #CHI-C60010 add
  
   #不可存在大於/等於該月份的折舊資料
   LET l_cnt = 0 

   SELECT COUNT(*) INTO l_cnt FROM fbn_file
    WHERE ((fbn03=g_yy AND fbn04>=g_mm) OR
            fbn03>g_yy)

   IF l_cnt > 0 THEN
      CALL cl_err('','afa-186',1)
      LET g_success='N' 
      RETURN
   END IF

    #不可存在大於/等於該月份的異動/處份資料
    LET l_cnt=0
    SELECT COUNT(*) INTO l_cnt FROM fay_file,faz_file
     WHERE fay01=faz01 
       AND ((YEAR(fay02)=g_yy AND MONTH(fay02)>=g_mm) OR 
             YEAR(fay02)>g_yy)
       AND fayconf <> 'X' 

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
       AND fbaconf <> 'X' 

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
       AND fbcconf <> 'X'

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
       AND fbgconf <> 'X' 

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
       AND fbeconf <> 'X'  

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
#CHI-C60010--add--str--#財簽二帳套對應的幣別小數位數
    IF g_faa.faa31='Y' THEN
       SELECT azi04 INTO l_azi04 FROM azi_file,aaa_file
        WHERE azi01=aaa03 AND aaa01=g_faa.faa02c
    END IF
#CHI-C60010--add--end
    #本期累折(faj203)會因afap305年結動作而歸零.
    #當本期累折(faj203)還原為0時,要update成上一年度的SUM(fbn07)
    IF g_yy <> g_yy2 THEN 
       DECLARE p207_faj_c CURSOR FOR SELECT faj02,faj022 FROM faj_file WHERE 1=1 

       FOREACH p207_faj_c INTO l_faj02,l_faj022 
          IF SQLCA.sqlcode THEN 
             CALL cl_err('p207_faj_c',SQLCA.sqlcode,0)
             LET g_success='N'
             RETURN
          END IF

          SELECT faj232,faj242,faj2032 
            INTO l_faj232,l_faj242,l_faj2032 FROM faj_file
           WHERE faj02=l_faj02 AND faj022=l_faj022
          IF l_faj2032 = 0 THEN
             IF l_faj232 = '1' THEN 
                SELECT SUM(fbn07) INTO l_fbn07 FROM fbn_file
                 WHERE fbn01= l_faj02 AND fbn02=l_faj022
                   AND fbn03=g_yy2 
             ELSE
                SELECT SUM(fbn07) INTO l_fbn07 FROM fbn_file
                 WHERE fbn01=l_faj02 AND fbn02=l_faj022
                   AND fbn03=g_yy2 AND fbn05='2' 
             END IF
             IF cl_null(l_fbn07) THEN LET l_fbn07 = 0 END IF
             LET l_fbn07=cl_digcut(l_fbn07,l_azi04)  #CHI-C60010 add
             UPDATE faj_file SET faj2032= l_fbn07 WHERE faj02=l_faj02
                                                    AND faj022=l_faj022
             IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
                CALL cl_err3("upd","faj_file",l_faj02,l_faj022,STATUS,"","upd faj2032:",1)
                LET g_success='N'
                RETURN
             END IF
          END IF
       END FOREACH
    END IF

    #update 現行年月
    UPDATE faa_file SET faa072=g_yy2,faa082=g_mm2
    IF STATUS THEN 
        CALL cl_err3("upd","faa_file",g_yy2,g_mm2,STATUS,"","upd faa:",1) 
        LET g_success = 'N'        
        RETURN 
    END IF

END FUNCTION
  #No:FUN-B60140

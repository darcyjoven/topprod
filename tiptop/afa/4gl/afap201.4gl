# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: afap201.4gl
# Descriptions...: 財簽二攤提折舊還原作業                    
# Date & Author..: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:TQC-C50092 12/05/10 By xuxz 增加開窗
# Modify.........: No.CHI-C80041 13/02/05 By bart 排除作廢
                                                                                                 
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_wc             STRING,
       g_yy,g_mm	LIKE type_file.num5,
       l_yy,l_mm        LIKE type_file.num5,
       g_fbn		RECORD LIKE fbn_file.*, 
       p_row,p_col      LIKE type_file.num5,
       g_flag           LIKE type_file.chr1,
       g_cnt2           LIKE type_file.num5,  
       g_ym             LIKE type_file.chr6    
DEFINE  g_show_msg  DYNAMIC ARRAY OF RECORD
                 faj02     LIKE faj_file.faj02,
                 faj022    LIKE faj_file.faj022,
                 ze01      LIKE ze_file.ze01,
                 ze03      LIKE ze_file.ze03
       END RECORD,
       l_msg,l_msg2    STRING,
       lc_gaq03  LIKE gaq_file.gaq03

DEFINE g_y1      LIKE type_file.num5
DEFINE g_m1      LIKE type_file.num5
DEFINE g_b1      LIKE type_file.dat
DEFINE g_e1      LIKE type_file.dat
DEFINE l_flag    LIKE type_file.chr1
DEFINE g_bookno1     LIKE aza_file.aza81      
DEFINE g_bookno2     LIKE aza_file.aza82     

MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)
   LET g_mm    = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)             
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
         CALL p201()
         IF cl_sure(18,20) THEN
            LET g_cnt2 = 1
            CALL g_show_msg.clear()
            CALL p201_1()
            IF g_show_msg.getLength() > 0 THEN 
               CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
               CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
               CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
               CONTINUE WHILE
            ELSE
               CALL cl_end2(1) RETURNING g_flag
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p201_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_cnt2 = 1
         CALL g_show_msg.clear()
         CALL p201_1()
         IF g_show_msg.getLength() > 0 THEN 
            CALL cl_get_feldname("faj02",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("faj022",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze01",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_get_feldname("ze03",g_lang) RETURNING lc_gaq03 LET l_msg2=l_msg2.trim(),"|",lc_gaq03 CLIPPED
            CALL cl_getmsg("lib-314",g_lang) RETURNING l_msg
            CALL cl_show_array(base.TypeInfo.create(g_show_msg),l_msg,l_msg2)
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE

   CALL cl_used(g_prog,g_time,2) RETURNING g_time 

END MAIN

FUNCTION p201()
   DEFINE lc_cmd   LIKE type_file.chr1000            

   CLEAR FORM

   LET p_row = 10
   LET p_col = 10

   OPEN WINDOW p201_w AT p_row,p_col WITH FORM "afa/42f/afap201"
       ATTRIBUTE (STYLE = g_win_style CLIPPED)
    
   CALL cl_ui_init()
  
   WHILE TRUE
      SELECT faa072,faa082 INTO g_yy,g_mm FROM faa_file

      LET g_ym = g_yy USING '&&&&',g_mm USING '&&'   
      DISPLAY g_yy TO FORMONLY.yy 
      DISPLAY g_mm TO FORMONLY.mm 

      LET g_bgjob = "N"

      CALL s_get_bookno(g_yy) RETURNING g_flag,g_bookno1,g_bookno2

      IF g_faa.faa31 = 'Y' THEN  
         CALL s_azmm(g_yy,g_mm,g_plant,g_bookno1) RETURNING l_flag,g_b1,g_e1
      ELSE
         CALL s_azm(g_yy,g_mm) RETURNING l_flag,g_b1,g_e1
      END IF

      LET g_y1 = YEAR(g_b1)
      LET g_m1 = MONTH(g_e1)

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

         ON ACTION qbe_save
            CALL cl_qbe_save()
    
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

      END INPUT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p300_w
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
         EXIT PROGRAM
      END IF

      CONSTRUCT BY NAME g_wc ON  faj09,faj04,faj02
      
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         
         #TQC-C50092--add--str
         ON ACTION CONTROLP
            CASE
               WHEN INFIELD(faj04)   #資產類別
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_fab"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO faj04
                  NEXT FIELD faj04
               WHEN INFIELD(faj02)   #資產編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form = "q_faj"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO faj02
                  NEXT FIELD faj02
            END CASE 
         #TQC-C50092--add--end
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()
            EXIT CONSTRUCT
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION help          
            CALL cl_show_help()  
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
         
         ON ACTION qbe_select
            CALL cl_qbe_select()
      
      END CONSTRUCT

      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p201_w
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
         EXIT PROGRAM
      END IF

      IF g_wc =' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      END IF

      IF g_bgjob = "Y" THEN
         SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "afap201"
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('afap201','9031',1)
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_yy CLIPPED,"'",
                        " '",g_mm CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('afap201',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW p201_w
         CALL cl_used(g_prog,g_time,2)  RETURNING g_time #FUN-B60140 
         EXIT PROGRAM
      END IF

      EXIT WHILE

   END WHILE

END FUNCTION

FUNCTION p201_1()
 DEFINE  l_over     LIKE type_file.chr1,
         l_cnt      LIKE type_file.num5,
         l_cnt1_2   LIKE type_file.num5,  
         l_faj302   LIKE faj_file.faj302, 
         l_faj312   LIKE faj_file.faj312, 
         l_faj332   LIKE faj_file.faj332, 
         l_faj3312  LIKE faj_file.faj3312,
         l_faj262   LIKE faj_file.faj262, 
         l_faj272   LIKE faj_file.faj272, 
         l_faj292   LIKE faj_file.faj292, 
         l_faj362   LIKE faj_file.faj362, 
         l_faj572   LIKE faj_file.faj572, 
         l_faj5712  LIKE faj_file.faj5712,
         l_faj432   LIKE faj_file.faj432, 
         l_yy2      LIKE type_file.chr4,   
         l_mm2      LIKE type_file.chr2,
         l_ym       LIKE type_file.chr6,
         l_sql      STRING,
         l_bdate01  LIKE type_file.dat, 
         l_edate01  LIKE type_file.dat, 
         l_bdate02  LIKE type_file.dat, 
         l_edate02  LIKE type_file.dat  
  DEFINE l_correct  LIKE type_file.chr1 

  #當月起始日與截止日
   IF g_faa.faa31 = 'Y' THEN 
      CALL s_get_bookno(g_yy) RETURNING g_flag,g_bookno1,g_bookno2
      CALL s_azmm(g_yy,g_mm,g_plant,g_bookno1) RETURNING l_correct,l_bdate01,l_edate01
      CALL s_get_bookno(g_y1) RETURNING g_flag,g_bookno1,g_bookno2
      CALL s_azmm(g_y1,g_m1,g_plant,g_bookno1) RETURNING l_correct,l_bdate02,l_edate02
   ELSE
      CALL s_azm(g_yy,g_mm) RETURNING l_correct,l_bdate01,l_edate01
      CALL s_azm(g_y1,g_m1) RETURNING l_correct,l_bdate02,l_edate02
   END IF

   #取折舊明細檔中分攤類別不為'3'被分攤者,還原資產主檔
   LET l_cnt1_2 = 0  

   LET l_sql = " SELECT COUNT(*) FROM fbn_file,faj_file ",
               "  WHERE fbn03='",g_yy,"' AND fbn04='",g_mm,"' AND fbn05<>'3'",
               "  AND faj02 = fbn01 ",
               "  AND faj022 = fbn02 ",
               "  AND fbn041='1' AND ",g_wc

   PREPARE p201_p21 FROM l_sql
   DECLARE p201_cs21 CURSOR FOR p201_p21

   OPEN p201_cs21
   FETCH p201_cs21 INTO l_cnt1_2

   IF l_cnt1_2 = 0 THEN 
      CALL cl_err('','afa-115',1)
      RETURN
   END IF

   LET l_cnt = 0

   SELECT COUNT(*) INTO l_cnt FROM npp_file
    WHERE nppsys='FA'
      AND npp00=10 
      AND npp03 BETWEEN l_bdate01 AND l_edate01 
      AND npptype = '1'

   IF l_cnt > 0 THEN
      CALL cl_err(0,'afa-363',1)
      RETURN 
   END IF

   INITIALIZE g_fbn.* TO NULL

   LET l_sql = "SELECT fbn_file.* FROM fbn_file,faj_file ",
               " WHERE fbn03='",g_yy,"' AND fbn04='",g_mm,"' AND fbn05<>'3' ",
               "   AND faj02 = fbn01 ",
               "   AND faj022 = fbn02 ",
               "   AND fbn041 = '1' AND ",g_wc

   PREPARE p201_p3 FROM l_sql
   DECLARE p201_cs3 CURSOR WITH HOLD FOR p201_p3
   
   FOREACH p201_cs3 INTO g_fbn.*                  
      IF SQLCA.sqlcode  THEN
         CALL cl_err('p201_cs3 foreach:',STATUS,1) 
         RETURN
      END IF

      LET g_success='Y'

      BEGIN WORK
   
      IF g_fbn.fbn02 IS NULL THEN LET g_fbn.fbn02 = ' ' END IF   
      IF g_fbn.fbn06 IS NULL THEN LET g_fbn.fbn06 = ' ' END IF   
   
      #不可有大於該還原月份的異動 
      LET l_cnt=0

      SELECT COUNT(*) INTO l_cnt FROM fay_file,faz_file
       WHERE fay01=faz01 AND faz03=g_fbn.fbn01 AND faz031=g_fbn.fbn02
         AND ((YEAR(fay02)=g_y1 AND MONTH(fay02)>g_m1) OR 
               YEAR(fay02)>g_y1)
      IF l_cnt > 0 THEN
         CALL cl_getmsg("afa-145",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
         LET g_show_msg[g_cnt2].ze01   = 'afa-145'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
       
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM fba_file,fbb_file
       WHERE fba01=fbb01 AND fbb03=g_fbn.fbn01 AND fbb031=g_fbn.fbn02
         AND ((YEAR(fba02)=g_y1 AND MONTH(fba02)>g_m1) OR 
               YEAR(fba02)>g_y1)
      IF l_cnt > 0 THEN
         CALL cl_getmsg("afa-146",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
         LET g_show_msg[g_cnt2].ze01   = 'afa-146'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
       
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM fbc_file,fbd_file
       WHERE fbc01=fbd01 AND fbd03=g_fbn.fbn01 AND fbd031=g_fbn.fbn02
         AND ((YEAR(fbc02)=g_y1 AND MONTH(fbc02)>g_m1) OR
               YEAR(fbc02)>g_y1)
      IF l_cnt > 0 THEN
         CALL cl_getmsg("afa-147",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
         LET g_show_msg[g_cnt2].ze01   = 'afa-147'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
       
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM fgh_file,fgi_file
       WHERE fgh01=fgi01 AND fgi06=g_fbn.fbn01 AND fgi07=g_fbn.fbn02
         AND ((YEAR(fgh02)=g_y1 AND MONTH(fgh02)>g_m1) OR
               YEAR(fgh02)>g_y1)
         AND fghconf<>'X'  #CHI-C80041      
      IF l_cnt > 0 THEN
         CALL cl_getmsg("afa-148",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
         LET g_show_msg[g_cnt2].ze01   = 'afa-148'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
   
      #不可有大於該還原月份的折舊
      LET l_cnt=0
      SELECT COUNT(*) INTO l_cnt FROM fbn_file
       WHERE fbn01 = g_fbn.fbn01 AND fbn02 = g_fbn.fbn02
         AND ((fbn03=g_yy AND fbn04>g_mm) OR fbn03>g_yy) 
      IF l_cnt > 0 THEN
         CALL cl_getmsg("afa-149",g_lang) RETURNING l_msg
         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
         LET g_show_msg[g_cnt2].ze01   = 'afa-149'
         LET g_show_msg[g_cnt2].ze03   = l_msg
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
   
      #當月處份應提列折舊='Y',處份需先確認還原
      IF g_faa.faa232 = 'Y' THEN
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM fbg_file,fbh_file
          WHERE fbg01=fbh01 AND fbh03=g_fbn.fbn01 AND fbh031=g_fbn.fbn02
            AND fbgconf='Y' 
            AND fbg02 BETWEEN l_bdate02 AND l_edate02  
         IF l_cnt > 0 THEN
            CALL cl_getmsg("afa-150",g_lang) RETURNING l_msg
            LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01 
            LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
            LET g_show_msg[g_cnt2].ze01   = 'afa-150'
            LET g_show_msg[g_cnt2].ze03   = l_msg
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'
            CONTINUE FOREACH
         END IF
         
         LET l_cnt=0
         SELECT COUNT(*) INTO l_cnt FROM fbe_file,fbf_file
          WHERE fbe01=fbf01 AND fbf03=g_fbn.fbn01 AND fbf031=g_fbn.fbn02
            AND fbeconf='Y' 
            AND fbe02 BETWEEN l_bdate02 AND l_edate02  
         IF l_cnt > 0 THEN
            CALL cl_getmsg("afa-151",g_lang) RETURNING l_msg
            LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01 
            LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
            LET g_show_msg[g_cnt2].ze01   = 'afa-151'
            LET g_show_msg[g_cnt2].ze03   = l_msg
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF
      
      #若在折舊月份前就為先前折畢
      SELECT faj302,faj572,faj5712 INTO l_faj302,l_faj572,l_faj5712    
        FROM faj_file 
       WHERE faj02  = g_fbn.fbn01 
         AND faj022 = g_fbn.fbn02 
      IF SQLCA.sqlcode THEN 
         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
         LET g_show_msg[g_cnt2].ze01   = ''
         LET g_show_msg[g_cnt2].ze03   = 'sel faj_file'
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF

      IF l_faj302 = 0 AND (l_faj572<g_yy OR
                          (l_faj572=g_yy AND l_faj5712<g_mm)) THEN
         LET l_over = 'Y'    
      ELSE 
         LET l_over = 'N'    
      END IF 
   
      LET l_mm = g_mm - 1      
      LET l_yy = g_yy

      IF l_mm < 1 THEN
         LET l_yy = g_yy - 1
         LET l_mm = 12 
      END IF

      #還原 折舊年月,累折,未折減額,剩餘月數,資產狀態
      IF l_over = 'N' THEN 
         SELECT faj432,faj3312,faj262,faj292,faj362 
           INTO l_faj432,l_faj3312,l_faj262,l_faj292,l_faj362 
           FROM faj_file   
          WHERE faj02 = g_fbn.fbn01
            AND faj022 = g_fbn.fbn02

         IF g_faa.faa152 = '4' THEN                                                                                                 
            LET l_cnt = 0                                                                                                          
            SELECT COUNT(DISTINCT fbn03||fbn04) INTO l_cnt                                                                         
              FROM fbn_file                                                                                                        
             WHERE fbn01=g_fbn.fbn01
               AND fbn02 = g_fbn.fbn02                                                                       
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                            
            #如何判斷此次還原是否為殘月,                                                                                           
            #狀態為4或7可能為一般/續提折舊的最後一期,                                                                              
            #再判斷已存在折舊檔折舊次數+1是否等於耐用年限,且入帳日不為1,                                                           
            #還原時,faj30還是要為0,faj331需寫回                                                                                    
            IF (l_faj432 = '7' OR l_faj432 ='4') AND                                                                                 
               l_cnt = l_faj292+1 AND DAY(l_faj262) != 1 THEN                                                                        
               LET l_faj302=0 
            ELSE 
               LET l_faj302=l_faj302 + 1 
            END IF
         ELSE  
            IF l_faj432 = '7' THEN      
               IF l_faj302=l_faj362 THEN
                  #第一次進入折畢再提,還原的話是要將未用年限回寫為1
                  LET l_faj302=1
               ELSE
                  LET l_faj302=l_faj302 + 1
               END IF
            ELSE 
               LET l_faj302=l_faj302 + 1
            END IF
         END IF  

         SELECT MAX(fbn03*100+fbn04) INTO l_ym FROM fbn_file
          WHERE fbn01 = g_fbn.fbn01
            AND fbn02 = g_fbn.fbn02
            AND ((fbn03 = g_yy AND fbn04 < g_mm) OR fbn03 < g_yy)
         IF STATUS THEN
            LET l_yy2 = ''
            LET l_mm2 = ''
         ELSE
            LET l_yy2 = l_ym[1,4]
            LET l_mm2 = l_ym[5,6]
         END IF

         IF g_faa.faa152 != '4' THEN 
            UPDATE faj_file
               SET faj572  = l_yy2,                  #最近折舊年
                   faj5712 = l_mm2,                  #最近折舊月
                   faj322  = faj322 - g_fbn.fbn07,   #累折
                   faj2032 = faj2032- g_fbn.fbn07,   #本期累折
                   faj332  = faj332 + g_fbn.fbn07,   #未折減額
                   faj302  = l_faj302,      
                   faj432  = g_fbn.fbn10             #狀態
             WHERE faj02   = g_fbn.fbn01
               AND faj022  = g_fbn.fbn02
         ELSE                                                                                                                      
            #當最後那個殘月的折舊還原,需還原第一個月未折減額                                                                       
            SELECT faj312,faj332,faj3312,faj262,faj272,faj292                                                                            
              INTO l_faj312,l_faj332,l_faj3312,l_faj262,l_faj272,l_faj292                                                                
              FROM faj_file                                                                                                        
             WHERE faj02  = g_fbn.fbn01                                                                                            
               AND faj022 = g_fbn.fbn02                                                                                            

            LET l_cnt = 0                                                                                                          

            SELECT COUNT(DISTINCT fbn03||fbn04) INTO l_cnt                                                                         
              FROM fbn_file                                                                                                        
             WHERE fbn01 = g_fbn.fbn01
               AND fbn02 = g_fbn.fbn02                                                                       
            IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF                                                                            
            #如何判斷此次還原是否為殘月,                                                                                           
            #狀態為4或7可能為一般/續提折舊的最後一期,                                                                              
            #再判斷已存在折舊檔折舊次數+1是否等於耐用年限,且入帳日不為1,                                                           
            #還原時,faj30還是要為0,faj331需寫回                                                                                    
            IF (l_faj432 = '7' OR l_faj432 ='4') AND                                                                                 
               l_cnt = l_faj292+1 AND DAY(l_faj262) != 1 THEN                                                                        
               #最後那個殘月的折舊還原                                                                                             
               UPDATE faj_file
                  SET faj572  = l_yy2,                  #最近折舊年                                                    
                      faj5712 = l_mm2,                  #最近折舊月                                                    
                      faj322  = faj322 - g_fbn.fbn07,   #累折                                                          
                      faj2032 = faj2032- g_fbn.fbn07,   #本期累折      
                      faj3312 = faj3312+ g_fbn.fbn07,   #第一個月未折減額                                              
                      faj302  = l_faj302,                                                                               
                      faj432  = g_fbn.fbn10             #狀態                                                          
                WHERE faj02   = g_fbn.fbn01                                                                            
                  AND faj022  = g_fbn.fbn02                                                                            
            ELSE                                                                                                                   
               IF g_ym = l_faj272 THEN    #第一期攤提還原                                                                           
                  UPDATE faj_file
                     SET faj572  = l_yy2,                            #最近折舊年                                       
                         faj5712 = l_mm2,                            #最近折舊月                                       
                         faj322  = faj322 - g_fbn.fbn07,             #累折                                             
                         faj2032 = faj2032- g_fbn.fbn07,             #本期累折                                         
                         faj332  = faj332 + g_fbn.fbn07+ l_faj3312,  #未折減額                                         
                         faj3312 = 0,                                #第一個月未折減額                                 
                         faj302  = l_faj302,                                                                            
                         faj432  = g_fbn.fbn10                       #狀態                                             
                   WHERE faj02   = g_fbn.fbn01                                                                         
                     AND faj022  = g_fbn.fbn02                                                                         
               ELSE                                                                                                                
                  UPDATE faj_file
                     SET faj572  = l_yy2,                  #最近折舊年                                                 
                         faj5712 = l_mm2,                  #最近折舊月                                                 
                         faj322  = faj322 - g_fbn.fbn07,   #累折                                                       
                         faj2032 = faj2032- g_fbn.fbn07,   #本期累折                                                   
                         faj332  = faj332 + g_fbn.fbn07,   #未折減額                                                   
                         faj302  = l_faj302,             
                         faj432  = g_fbn.fbn10             #狀態                                                       
                   WHERE faj02   = g_fbn.fbn01                                                                         
                     AND faj022  = g_fbn.fbn02                                                                         
               END IF                                                                                                              
            END IF                                                                                                                 
         END IF                                                                                                                    

         IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
            LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
            LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
            LET g_show_msg[g_cnt2].ze01   = ''
            LET g_show_msg[g_cnt2].ze03   = 'upd faj_file'
            LET g_cnt2 = g_cnt2 + 1
            LET g_success='N'
            CONTINUE FOREACH
         END IF
      END IF

      #刪除折舊費用各期明細檔--------
      DELETE FROM fbn_file WHERE fbn01 = g_fbn.fbn01 
                             AND fbn02 = g_fbn.fbn02 
                             AND fbn03 = g_yy   
                             AND fbn04 = g_mm
                             AND fbn041 = '1'  
      IF STATUS OR SQLCA.SQLERRD[3] = 0 THEN
         LET g_show_msg[g_cnt2].faj02  = g_fbn.fbn01
         LET g_show_msg[g_cnt2].faj022 = g_fbn.fbn02
         LET g_show_msg[g_cnt2].ze01   = ''
         LET g_show_msg[g_cnt2].ze03   = 'del fbn_file'
         LET g_cnt2 = g_cnt2 + 1
         LET g_success='N'
         CONTINUE FOREACH
      END IF
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
         ROLLBACK WORK
      END IF
   END FOREACH

END FUNCTION 
  #No:FUN-B60140

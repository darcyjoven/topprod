# Prog. Version..: '5.30.07-13.05.31(00007)'     #
#
# Pattern name...: axcp323.4gl
# Descriptions...: 
# Date & Author..: 10/06/25 By xiaofeizhu   #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 分錄底稿根據幣種取位
# Modify.........: No:FUN-BB0038 11/11/09 By elva 成本改善
# Modify.........: No:MOD-D50164 13/05/20 By bart g_success預設為Y
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D60025 13/06/05 by yuhuabao 根據系統設置自動帶摘要已經核算項

DATABASE ds   

#No.FUN-AA0025
GLOBALS "../../config/top.global"



FUNCTION p323_gl(tm)
DEFINE l_npp       RECORD LIKE npp_file.*
DEFINE l_npq       RECORD LIKE npq_file.*
DEFINE l_cdk       RECORD LIKE cdk_file.*
DEFINE l_date      LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_ccz12     LIKE ccz_file.ccz12 
DEFINE l_ccz21     LIKE ccz_file.ccz21
DEFINE l_wc        STRING
DEFINE l_npq02     LIKE npq_file.npq02
DEFINE l_cdk01     LIKE cdk_file.cdk01
DEFINE l_cdk02     LIKE cdk_file.cdk02
DEFINE l_cdk03     LIKE cdk_file.cdk03
DEFINE l_cdk04     LIKE cdk_file.cdk04
DEFINE l_cdk07     LIKE cdk_file.cdk07
DEFINE l_cdk09     LIKE cdk_file.cdk09
DEFINE l_cdk11     LIKE cdk_file.cdk11
DEFINE l_cdk13     LIKE cdk_file.cdk13
DEFINE g_cdk09     LIKE cdk_file.cdk09
DEFINE l_ccz24     LIKE ccz_file.ccz24
DEFINE l_ccz25     LIKE ccz_file.ccz25
DEFINE g_wc        STRING 
DEFINE tm          RECORD 
                   tlfctype    LIKE tlfc_file.tlfctype,
                   yy          LIKE type_file.num5,
                   mm          LIKE type_file.num5,
                   b           LIKE aaa_file.aaa01
                   END RECORD
DEFINE l_n         LIKE type_file.num5
DEFINE l_sumc      LIKE npq_file.npq07
DEFINE l_sumd      LIKE npq_file.npq07
DEFINE l_sumfc     LIKE npq_file.npq07f
DEFINE l_sumfd     LIKE npq_file.npq07f 
DEFINE g_aag44     LIKE aag_file.aag44   #FUN-D40118 add
DEFINE l_flag      LIKE type_file.chr1   #FUN-D40118 add
DEFINE l_bookno1   LIKE aza_file.aza81   #FUN-D60025
DEFINE l_bookno2   LIKE aza_file.aza82   #FUN-D60025
DEFINE l_bookno3   LIKE aza_file.aza81   #FUN-D60025

   WHENEVER ERROR CALL cl_err_msg_log
   INITIALIZE l_cdk.* TO NULL

   #LET g_success = 'N'  #MOD-D50164
   LET g_success = 'Y'  #MOD-D50164
   SELECT ccz12,ccz21 INTO l_ccz12,l_ccz21 FROM ccz_file
   
   LET l_sql = "SELECT DISTINCT cdk01,cdk02,cdk03,cdk04 ",
               "  FROM cdk_file ",
               " WHERE cdk01 ='",tm.b CLIPPED,"'",
               "   AND cdk02 ='",tm.yy CLIPPED,"'",
               "   AND cdk03 ='",tm.mm CLIPPED,"'",
               "   AND cdk04 ='",tm.tlfctype CLIPPED,"'"

   PREPARE p323_p3 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p323_c3 CURSOR FOR p323_p3

   LET l_sql = "SELECT cdk01,cdk02,cdk03,cdk04,cdk07,cdk11,SUM(cdk09) ",
               "  FROM cdk_file,aag_file ",
               " WHERE cdk01 =? ",
               "   AND cdk02 =? ",
               "   AND cdk03 =? ",
               "   AND cdk04 =? ", 
               "   AND cdk01 = aag00 ",
               "   AND cdk07 = aag01 ",
               "   AND aag05 ='Y' ", 
               "   AND cdk07 IS NOT NULL ",
               " GROUP BY cdk01,cdk02,cdk03,cdk04,cdk07,cdk11 ",
               " UNION ",
               "SELECT cdk01,cdk02,cdk03,cdk04,cdk07,'',SUM(cdk09) ",
               "  FROM cdk_file,aag_file ",
               " WHERE cdk01 =? ",
               "   AND cdk02 =? ",
               "   AND cdk03 =? ",
               "   AND cdk04 =? ", 
               "   AND cdk01 = aag00 ",
               "   AND cdk07 = aag01 ",
               "   AND aag05 ='N' ", 
               "   AND cdk07 IS NOT NULL ",               
               " GROUP BY cdk01,cdk02,cdk03,cdk04,cdk07 ",
               " UNION ",
               "SELECT cdk01,cdk02,cdk03,cdk04,cdk07,cdk11,cdk09 ",
               "  FROM cdk_file ",
               " WHERE cdk01 =? ",
               "   AND cdk02 =? ",
               "   AND cdk03 =? ",
               "   AND cdk04 =? ",  
               "   AND cdk07 IS NULL ", 
               " ORDER BY cdk01,cdk02,cdk03,cdk04,cdk07 "

   PREPARE p323_p4 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p323_c4 CURSOR FOR p323_p4
   
   #FUN-BB0038 --begin
#  LET l_sql = "SELECT cdk01,cdk02,cdk03,cdk04,cdk13,cdk11,SUM(cdk09) ",
#              "  FROM cdk_file,aag_file ",
#              " WHERE cdk01 =? ",
#              "   AND cdk02 =? ",
#              "   AND cdk03 =? ",
#              "   AND cdk04 =? ",
#              "   AND cdk01 = aag00 ",
#              "   AND cdk07 = aag01 ",
#              "   AND aag05 ='Y' ", 
#              "   AND cdk07 IS NOT NULL ",
#              " GROUP BY cdk01,cdk02,cdk03,cdk04,cdk13,cdk11 ",
#              " UNION ",
#              "SELECT cdk01,cdk02,cdk03,cdk04,cdk13,'',SUM(cdk09) ",
#              "  FROM cdk_file,aag_file ",
#              " WHERE cdk01 =? ",
#              "   AND cdk02 =? ",
#              "   AND cdk03 =? ",
#              "   AND cdk04 =? ",
#              "   AND cdk01 = aag00 ",
#              "   AND cdk07 = aag01 ",
#              "   AND aag05 ='N' ", 
#              "   AND cdk07 IS NOT NULL ",
#              " UNION ",
#              "SELECT cdk01,cdk02,cdk03,cdk04,cdk13,cdk11,cdk09 ",
#              "  FROM cdk_file ",
#              " WHERE cdk01 =? ",
#              "   AND cdk02 =? ",
#              "   AND cdk03 =? ",
#              "   AND cdk04 =? ", 
#              "   AND cdk07 IS NULL ",
#              " GROUP BY cdk01,cdk02,cdk03,cdk04,cdk13 ",
#              " ORDER BY cdk01,cdk02,cdk03,cdk04,cdk13 "
#
#  PREPARE p323_p5 FROM l_sql
#  IF SQLCA.SQLCODE THEN
#     CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
#     LET g_success ='N'
#     RETURN
#  END IF
#  DECLARE p323_c5 CURSOR FOR p323_p5   
   #FUN-BB0038 --end
   
   FOREACH p323_c3 INTO l_cdk.cdk01,l_cdk.cdk02,l_cdk.cdk03,l_cdk.cdk04  
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success ='N'
         RETURN 
      END IF 
      INITIALIZE l_npp.* TO NULL
      IF l_cdk.cdk01 = l_ccz12 THEN 
         LET l_npp.npptype =0
      ELSE
         LET l_npp.npptype =1
      END IF  
      LET l_date = MDY(l_cdk.cdk03,1,l_cdk.cdk02)
      LET l_npp.nppsys   = 'CA'
      LET l_npp.npp00    = 5
      LET l_npp.npp01    = 'D',l_cdk.cdk04 CLIPPED,l_cdk.cdk01 CLIPPED,'-',l_cdk.cdk02 USING '&&&&',l_cdk.cdk03 CLIPPED USING '&&','0001'
      LET l_npp.npp011   = 1
      LET l_npp.npp02    = s_last(l_date)
      LET l_npp.npp03    = NULL
      LET l_npp.npp06    = g_plant
      SELECT DISTINCT cdklegal INTO l_npp.npplegal 
        FROM cdk_file 
       WHERE cdk01 = l_cdk.cdk01
         AND cdk02 = l_cdk.cdk02
         AND cdk03 = l_cdk.cdk03
         AND cdk04 = l_cdk.cdk04
         
      LET l_npp.nppglno  = NULL
      LET l_npp.npp07 = l_cdk.cdk01
      SELECT COUNT(*) INTO l_n FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = 5
         AND npp01   = l_npp.npp01
         AND npp011  = 1
         AND npptype = l_npp.npptype
         AND nppglno IS NOT NULL 
         
      IF l_n >0 THEN  
         CALL cl_err(l_npp.npp01,'axm-275',1)
         LET g_success ='N' 
         RETURN 
      END IF 
                
      DELETE FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = 5
         AND npp01   = l_npp.npp01
         AND npp011  = 1
         AND npptype = l_npp.npptype
      
      INSERT INTO npp_file VALUES(l_npp.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('nppsys','CA','insert npp_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF

#抓取帐套
#FUN-D60025 ------------ begin by yuhuabao 13/06/05
       CALL s_get_bookno(YEAR(l_npp.npp02)) RETURNING l_flag,l_bookno1,l_bookno2
       IF l_flag =  '1' THEN  #抓不到帳別
         CALL cl_err(l_npp.npp02,'aoo-081',1)
         LET g_success = 'N'
         RETURN
       END IF
       IF l_npp.npptype = '0' THEN
         LET l_bookno3 = l_bookno1
       ELSE
         LET l_bookno3 = l_bookno2
       END IF
#FUN-D60025 ------------ end by yuhuabao 13/06/05

   #insert npq_file 單身
      DELETE FROM npq_file
       WHERE npqsys  = 'CA'
         AND npq00   = 5
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype
   #FUN-B40056 --begin
      DELETE FROM tic_file
       WHERE tic04 = l_npp.npp01
   #FUN-B40056 --end
      LET l_npq02 = 1
      INITIALIZE l_npq.* TO NULL
      FOREACH p323_c4 USING  l_cdk.cdk01,l_cdk.cdk02,l_cdk.cdk03,l_cdk.cdk04,l_cdk.cdk01,l_cdk.cdk02,l_cdk.cdk03,l_cdk.cdk04,l_cdk.cdk01,l_cdk.cdk02,l_cdk.cdk03,l_cdk.cdk04
                       INTO l_cdk01,l_cdk02,l_cdk03,l_cdk04,l_cdk07,l_cdk11,l_cdk09                    
         IF STATUS THEN LET g_success = 'N' RETURN END IF
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 5
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_cdk07
         LET l_npq.npq04 = ''
         LET l_npq.npq05 = l_cdk11          
         IF l_cdk09 > 0 THEN
            LET l_npq.npq06 = '1'
            LET g_cdk09 = l_cdk09
         ELSE
            LET l_npq.npq06 = '2'
            LET g_cdk09 = l_cdk09 * -1
         END IF                  
         LET l_npq.npq07f = g_cdk09  
         LET l_npq.npq07  = g_cdk09  
         #No.TQC-BB0046  --Begin
         #LET l_npq.npq07f = cl_digcut(l_npq.npq07f,2) 
         #LET l_npq.npq07  = cl_digcut(l_npq.npq07,2)
         LET l_npq.npq07f= cl_digcut(l_npq.npq07f,t_azi04)
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
         #No.TQC-BB0046  --End
         LET l_npq.npq08 = NULL
         LET l_npq.npq11 = ' '
         LET l_npq.npq12 = ' '
         LET l_npq.npq13 = ' '
         LET l_npq.npq14 = ' '
         LET l_npq.npq15 = NULL
         LET l_npq.npq21 = NULL
         LET l_npq.npq22 = NULL
         LET l_npq.npq24 = g_aza.aza17
         LET l_npq.npq25 = 1
         LET l_npq.npq30 = l_npp.npp06
         LET l_npq.npq31 = ' '
         LET l_npq.npq32 = ' '
         LET l_npq.npq33 = ' '
         LET l_npq.npq34 = ' '
         LET l_npq.npq35 = ' '
         LET l_npq.npq36 = ' '
         LET l_npq.npq37 = ' '
         LET l_npq.npqtype = l_npp.npptype
         LET l_npq.npqlegal =l_npp.npplegal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = tm.b
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,tm.b) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)       #FUN-D60025 add by yuhuabao130605
           RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
         INSERT INTO npq_file VALUES(l_npq.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_npq02 = l_npq02 + 1 
         LET g_success ='Y'
      END FOREACH
      
      #FUN-BB0038 --begin
#     FOREACH p323_c5 USING  l_cdk.cdk01,l_cdk.cdk02,l_cdk.cdk03,l_cdk.cdk04,l_cdk.cdk01,l_cdk.cdk02,l_cdk.cdk03,l_cdk.cdk04,l_cdk.cdk01,l_cdk.cdk02,l_cdk.cdk03,l_cdk.cdk04
#                      INTO l_cdk01,l_cdk02,l_cdk03,l_cdk04,l_cdk13,l_cdk11,l_cdk09                    
#        IF STATUS THEN LET g_success = 'N' RETURN END IF
#        INITIALIZE l_npq.* TO NULL
#        LET l_npq.npqsys ='CA'
#        LET l_npq.npq00  = 5
#        LET l_npq.npq01  =l_npp.npp01
#        LET l_npq.npq011 = 1
#        LET l_npq.npq02 = l_npq02
#        LET l_npq.npq03 = l_cdk13
#        LET l_npq.npq04 = ''
#        LET l_npq.npq05 = l_cdk11         
#        IF l_cdk09 > 0 THEN
#           LET l_npq.npq06 = '2'
#           LET g_cdk09 = l_cdk09
#        ELSE
#           LET l_npq.npq06 = '1'
#           LET g_cdk09 = l_cdk09 * -1
#        END IF                  
#        LET l_npq.npq07f = g_cdk09  
#        LET l_npq.npq07  = g_cdk09  
#        LET l_npq.npq07f = cl_digcut(l_npq.npq07f,2) 
#        LET l_npq.npq07  = cl_digcut(l_npq.npq07,2)
#        LET l_npq.npq08 = NULL
#        LET l_npq.npq11 = ' '
#        LET l_npq.npq12 = ' '
#        LET l_npq.npq13 = ' '
#        LET l_npq.npq14 = ' '
#        LET l_npq.npq15 = NULL
#        LET l_npq.npq21 = NULL
#        LET l_npq.npq22 = NULL
#        LET l_npq.npq24 = g_aza.aza17
#        LET l_npq.npq25 = 1
#        LET l_npq.npq30 = l_npp.npp06
#        LET l_npq.npq31 = ' '
#        LET l_npq.npq32 = ' '
#        LET l_npq.npq33 = ' '
#        LET l_npq.npq34 = ' '
#        LET l_npq.npq35 = ' '
#        LET l_npq.npq36 = ' '
#        LET l_npq.npq37 = ' '
#        LET l_npq.npqtype = l_npp.npptype
#        LET l_npq.npqlegal =l_npp.npplegal
#        INSERT INTO npq_file VALUES(l_npq.*)
#        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#           CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
#           LET g_success = 'N'
#           RETURN
#        END IF
#        LET l_npq02 = l_npq02 + 1 
#        LET g_success ='Y'
#     END FOREACH             
   #FUN-BB0038 --end
   END FOREACH
   
   IF NOT cl_null(l_npp.npp01) THEN
      LET l_cdk.cdk10 = l_npp.npp01
      UPDATE cdk_file SET cdk10 = l_cdk.cdk10 
       WHERE cdk01 = l_cdk.cdk01
         AND cdk02 = l_cdk.cdk02
         AND cdk03 = l_cdk.cdk03
         AND cdk04 = l_cdk.cdk04
   END IF
      
    SELECT SUM(npq07) INTO l_sumc FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = 5
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '1'

    SELECT SUM(npq07) INTO l_sumd FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = 5
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '2'

    SELECT SUM(npq07f) INTO l_sumfc FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = 5
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '1'

    SELECT SUM(npq07f) INTO l_sumfd FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = 5
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '2'

   IF cl_null(l_sumc) THEN LET l_sumc =0 END IF 
   IF cl_null(l_sumd) THEN LET l_sumd =0 END IF 
   IF cl_null(l_sumfc) THEN LET l_sumfc =0 END IF 
   IF cl_null(l_sumfd) THEN LET l_sumfd =0 END IF 

   SELECT ccz24,ccz25 INTO l_ccz24,l_ccz25 FROM ccz_file 

   IF l_ccz24 = l_ccz25 THEN
     IF g_success ='Y' AND l_sumc <> l_sumd THEN 
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 5
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_ccz24         
         LET l_npq.npq04 = ''
         LET l_npq.npq05 = NULL  
         IF l_sumc - l_sumd >0 THEN
            LET l_npq.npq06 = '2'
            LET l_npq.npq07f = l_sumfc - l_sumfd 
            LET l_npq.npq07  = l_sumc  - l_sumd         
         ELSE 
            LET l_npq.npq06 = '1'          	
            LET l_npq.npq07f = l_sumfd - l_sumfc 
            LET l_npq.npq07  = l_sumd  - l_sumc
         END IF 
         LET l_npq.npq08 = NULL
         LET l_npq.npq11 = ' '
         LET l_npq.npq12 = ' '
         LET l_npq.npq13 = ' '
         LET l_npq.npq14 = ' '
         LET l_npq.npq15 = NULL
         LET l_npq.npq21 = NULL
         LET l_npq.npq22 = NULL
         LET l_npq.npq24 = g_aza.aza17
         LET l_npq.npq25 = 1
         LET l_npq.npq30 = l_npp.npp06
         LET l_npq.npq31 = ' '
         LET l_npq.npq32 = ' '
         LET l_npq.npq33 = ' '
         LET l_npq.npq34 = ' '
         LET l_npq.npq35 = ' '
         LET l_npq.npq36 = ' '
         LET l_npq.npq37 = ' '
         LET l_npq.npqtype = l_npp.npptype
         LET l_npq.npqlegal =l_npp.npplegal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = tm.b 
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,tm.b) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)       #FUN-D60025 add by yuhuabao130605
           RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
         INSERT INTO npq_file VALUES(l_npq.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_npq02 = l_npq02 + 1   
     END IF
   ELSE
     IF g_success ='Y' AND l_sumc <> l_sumd THEN 
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 5
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02                  
         LET l_npq.npq04 = ''
         LET l_npq.npq05 = NULL  
         IF l_sumc - l_sumd >0 THEN
            LET l_npq.npq06 = '2'
            LET l_npq.npq03 = l_ccz25
            LET l_npq.npq07f = l_sumfc - l_sumfd 
            LET l_npq.npq07  = l_sumc  - l_sumd         
         ELSE 
            LET l_npq.npq06 = '1'
            LET l_npq.npq03 = l_ccz24          	
            LET l_npq.npq07f = l_sumfd - l_sumfc 
            LET l_npq.npq07  = l_sumd  - l_sumc
         END IF 
         LET l_npq.npq08 = NULL
         LET l_npq.npq11 = ' '
         LET l_npq.npq12 = ' '
         LET l_npq.npq13 = ' '
         LET l_npq.npq14 = ' '
         LET l_npq.npq15 = NULL
         LET l_npq.npq21 = NULL
         LET l_npq.npq22 = NULL
         LET l_npq.npq24 = g_aza.aza17
         LET l_npq.npq25 = 1
         LET l_npq.npq30 = l_npp.npp06
         LET l_npq.npq31 = ' '
         LET l_npq.npq32 = ' '
         LET l_npq.npq33 = ' '
         LET l_npq.npq34 = ' '
         LET l_npq.npq35 = ' '
         LET l_npq.npq36 = ' '
         LET l_npq.npq37 = ' '
         LET l_npq.npqtype = l_npp.npptype
         LET l_npq.npqlegal =l_npp.npplegal
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = tm.b
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,tm.b) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)       #FUN-D60025 add by yuhuabao130605
           RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
         INSERT INTO npq_file VALUES(l_npq.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_npq02 = l_npq02 + 1   
     END IF   	
   END IF
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021   
   IF g_success ='Y' AND g_prog ='axct323' THEN CALL cl_err('','abm-019',0) END IF 
   IF g_success ='N' THEN CALL cl_err('','aap-129',0) END IF 
END FUNCTION


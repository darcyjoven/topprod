# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: axcp324.4gl
# Descriptions...: 杂项进出分录底稿整批生成作业
# Date & Author..: 10/07/08 By wujie   #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 分錄底稿根據幣種取位
# Modify.........: No:MOD-C20135 12/02/15 By yinhy 产生分錄底稿時增加部門，按是否部門管理賦值
# Modify.........: No:MOD-C20151 12/02/16 By yinhy cdl10為0時，不产生分錄底稿
# Modify.........: No:MOD-C30878 12/03/28 By yinhy 修正MOD-C20151
# Modify.........: No.FUN-CC0153 13/01/23 By wujie 增加cdl14项目编号cdl15WBS编号到npq08，npq35
# Modify.........: No:MOD-D50164 13/05/20 By bart g_success預設為Y
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D60025 13/06/05 by yuhuabao 根據系統設置自動帶摘要已經核算項
# Modify.........: No.FUN-D80089 13/12/12 by fengmy 加入部門所屬成本中心的判斷

DATABASE ds   

#No.FUN-AA0025
GLOBALS "../../config/top.global"



FUNCTION p324_gl(tm)
DEFINE l_npp       RECORD LIKE npp_file.*
DEFINE l_npq       RECORD LIKE npq_file.*
DEFINE l_cdl       RECORD LIKE cdl_file.*
DEFINE l_date      LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_ccz12     LIKE ccz_file.ccz12 
DEFINE l_ccz21     LIKE ccz_file.ccz21
DEFINE l_ccz23     LIKE ccz_file.ccz23   #MOD-C20135
DEFINE l_aag05     LIKE aag_file.aag05   #MOD-C20135
DEFINE l_npq02     LIKE npq_file.npq02
DEFINE l_cdl01     LIKE cdl_file.cdl01
DEFINE l_cdl02     LIKE cdl_file.cdl02
DEFINE l_cdl03     LIKE cdl_file.cdl03
DEFINE l_cdl04     LIKE cdl_file.cdl04
DEFINE l_cdl05     LIKE cdl_file.cdl05
DEFINE l_cdl16     LIKE cdl_file.cdl16   #FUN-D80089 add
DEFINE l_cdl08     LIKE cdl_file.cdl08
DEFINE l_cdl09     LIKE cdl_file.cdl09
DEFINE l_cdl10     LIKE cdl_file.cdl10
DEFINE l_cdl11     LIKE cdl_file.cdl11
DEFINE g_wc        STRING 
DEFINE tm                  RECORD 
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
#No.FUN-CC0153 --begin
DEFINE l_cdl14     LIKE cdl_file.cdl14
DEFINE l_cdl15     LIKE cdl_file.cdl15
#No.FUN-CC0153 --end
DEFINE l_aag44     LIKE aag_file.aag44   #FUN-D40118 add
DEFINE l_flag      LIKE type_file.chr1   #FUN-D40118 add
DEFINE l_bookno1   LIKE aza_file.aza81   #FUN-D60025
DEFINE l_bookno2   LIKE aza_file.aza82   #FUN-D60025
DEFINE l_bookno3   LIKE aza_file.aza81   #FUN-D60025

   WHENEVER ERROR CALL cl_err_msg_log
   INITIALIZE l_cdl.* TO NULL

   #LET g_success = 'N'  #MOD-D50164
   LET g_success = 'Y'  #MOD-D50164
   
   SELECT ccz12,ccz21,ccz23 INTO l_ccz12,l_ccz21,l_ccz23 FROM ccz_file  #MOD-C20135 add ccz23
   
   LET l_sql = "SELECT DISTINCT cdl01,cdl02,cdl03,cdl04,cdllegal ",
               "  FROM cdl_file ",
               " WHERE cdl01 ='",tm.b CLIPPED,"'",
               "   AND cdl02 ='",tm.yy CLIPPED,"'",
               "   AND cdl03 ='",tm.mm CLIPPED,"'",
               "   AND cdl04 ='",tm.tlfctype CLIPPED,"'"

   PREPARE p324_p3 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p324_c3 CURSOR FOR p324_p3

  #LET l_sql = "SELECT cdl01,cdl02,cdl03,cdl04,cdl08,cdl05,cdl14,cdl15,SUM(cdl10) ",   #No.FUN-CC0153 add cdl14,cdl15   #FUN-D80089 mark
   LET l_sql = "SELECT cdl01,cdl02,cdl03,cdl04,cdl08,cdl16,cdl14,cdl15,SUM(cdl10) ",    #FUN-D80089 add
               "  FROM cdl_file,aag_file ",
               " WHERE cdl01 =? ",
               "   AND cdl02 =? ",
               "   AND cdl03 =? ",
               "   AND cdl04 =? ",
               "   AND cdl08 = aag01 ",
               "   AND cdl01 = aag00 ",
               "   AND aag05 ='Y' ",  
               "   AND cdl08 IS NOT NULL ",
               #" GROUP BY cdl01,cdl02,cdl03,cdl04,cdl08,cdl05,cdl14,cdl15 ",          #No.FUN-CC0153 add cdl14,cdl15   #FUN-D80089 mark
               " GROUP BY cdl01,cdl02,cdl03,cdl04,cdl08,cdl16,cdl14,cdl15 ",           #FUN-D80089 add
               " UNION ",
               "SELECT cdl01,cdl02,cdl03,cdl04,cdl08,'',cdl14,cdl15,SUM(cdl10) ",      #No.FUN-CC0153 add cdl14,cdl15
               "  FROM cdl_file,aag_file ",
               " WHERE cdl01 =? ",
               "   AND cdl02 =? ",
               "   AND cdl03 =? ",
               "   AND cdl04 =? ",
               "   AND cdl08 = aag01 ",
               "   AND cdl01 = aag00 ",
               "   AND aag05 ='N' ", 
               "   AND cdl08 IS NOT NULL ",
               " GROUP BY cdl01,cdl02,cdl03,cdl04,cdl08,cdl14,cdl15 ",                #No.FUN-CC0153 add cdl14,cdl15
               " UNION ",
              #"SELECT cdl01,cdl02,cdl03,cdl04,cdl08,cdl05,cdl14,cdl15,cdl10 ",      #No.FUN-CC0153 add cdl14,cdl15  #FUN-D80089 mark
               "SELECT cdl01,cdl02,cdl03,cdl04,cdl08,cdl16,cdl14,cdl15,cdl10 ",       #FUN-D80089 add
               "  FROM cdl_file ",
               " WHERE cdl01 =? ",
               "   AND cdl02 =? ",
               "   AND cdl03 =? ",
               "   AND cdl04 =? ", 
               "   AND cdl08 IS NULL ",
               " ORDER BY cdl01,cdl02,cdl03,cdl04,cdl08,cdl14,cdl15 "                 #No.FUN-CC0153 add cdl14,cdl15

   PREPARE p324_p4 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p324_c4 CURSOR FOR p324_p4

  #LET l_sql = "SELECT cdl01,cdl02,cdl03,cdl04,cdl09,cdl05,SUM(cdl10) ",   #FUN-D80089 mark
   LET l_sql = "SELECT cdl01,cdl02,cdl03,cdl04,cdl09,cdl16,SUM(cdl10) ",    #FUN-D80089 add
               "  FROM cdl_file,aag_file ",
               " WHERE cdl01 =? ",
               "   AND cdl02 =? ",
               "   AND cdl03 =? ",
               "   AND cdl04 =? ",
               "   AND cdl09 = aag01 ",
               "   AND cdl01 = aag00 ",
               "   AND aag05 ='Y' ", 
               "   AND cdl09 IS NOT NULL ",
              #" GROUP BY cdl01,cdl02,cdl03,cdl04,cdl09,cdl05 ",    #FUN-D80089 mark
               " GROUP BY cdl01,cdl02,cdl03,cdl04,cdl09,cdl16 ",     #FUN-D80089 add
               " UNION ",
               "SELECT cdl01,cdl02,cdl03,cdl04,cdl09,'',SUM(cdl10) ",
               "  FROM cdl_file,aag_file ",
               " WHERE cdl01 =? ",
               "   AND cdl02 =? ",
               "   AND cdl03 =? ",
               "   AND cdl04 =? ",
               "   AND cdl09 = aag01 ",
               "   AND cdl01 = aag00 ",
               "   AND aag05 ='N' ", 
               "   AND cdl09 IS NOT NULL ",
               " GROUP BY cdl01,cdl02,cdl03,cdl04,cdl09 ", 
               " UNION ",
              #"SELECT cdl01,cdl02,cdl03,cdl04,cdl09,cdl05,cdl10 ",  #FUN-D80089 mark
               "SELECT cdl01,cdl02,cdl03,cdl04,cdl09,cdl16,cdl10 ",   #FUN-D80089 add
               "  FROM cdl_file ",
               " WHERE cdl01 =? ",
               "   AND cdl02 =? ",
               "   AND cdl03 =? ",
               "   AND cdl04 =? ", 
               "   AND cdl09 IS NULL ",
               " ORDER BY cdl01,cdl02,cdl03,cdl04,cdl09 "

   PREPARE p324_p5 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1) 
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p324_c5 CURSOR FOR p324_p5
      
   FOREACH p324_c3 INTO l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04,l_cdl.cdllegal  
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success ='N'
         RETURN 
      END IF 
      INITIALIZE l_npp.* TO NULL
      IF l_cdl.cdl01 = l_ccz12 THEN 
         LET l_npp.npptype =0
      ELSE
         LET l_npp.npptype =1
      END IF  
      LET l_date = MDY(l_cdl.cdl03,1,l_cdl.cdl02)
      LET l_npp.nppsys   = 'CA'
      LET l_npp.npp00    = 6
      LET l_npp.npp01    = 'E',l_cdl.cdl04 CLIPPED,l_cdl.cdl01 CLIPPED,'-',l_cdl.cdl02 USING '&&&&',l_cdl.cdl03 CLIPPED USING '&&','0001'
      LET l_npp.npp011   = 1
      LET l_npp.npp02    = s_last(l_date)
      LET l_npp.npp03    = NULL
      LET l_npp.npp06    = g_plant         
      LET l_npp.nppglno  = NULL
      LET l_npp.npp07 = l_cdl.cdl01
      LET l_npp.npplegal = l_cdl.cdllegal
      
      SELECT COUNT(*) INTO l_n FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = 6
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
         AND npp00   = 6
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

   END FOREACH 

   #insert npq_file 單身
   DELETE FROM npq_file
    WHERE npqsys  = 'CA'
      AND npq00   = 6
      AND npq01   = l_npp.npp01
      AND npq011  = 1
      AND npqtype = l_npp.npptype
      
   #FUN-B40056 --begin
   DELETE FROM tic_file
    WHERE tic04 = l_npp.npp01
   #FUN-B40056 --end

   LET l_npq02 = 1

   FOREACH p324_c4 USING  l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04,l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04,l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04
                   #INTO l_cdl01,l_cdl02,l_cdl03,l_cdl04,l_cdl08,l_cdl05,l_cdl14,l_cdl15,l_cdl10   #No.FUN-CC0153 add cdl14,cdl15    #FUN-D80089 mark
                    INTO l_cdl01,l_cdl02,l_cdl03,l_cdl04,l_cdl08,l_cdl16,l_cdl14,l_cdl15,l_cdl10    #FUN-D80089  add
      IF STATUS THEN LET g_success = 'N' RETURN END IF
      #No.MOD-C20151  --Begin
      IF l_cdl10 = 0 THEN
         CONTINUE FOREACH  
      END IF
      #No.MOD-C20151  --End
      INITIALIZE l_npq.* TO NULL
      LET l_npq.npqsys ='CA'
      LET l_npq.npq00  = 6
      LET l_npq.npq01  =l_npp.npp01
      LET l_npq.npq011 = 1
      LET l_npq.npq02 = l_npq02
      LET l_npq.npq03 = l_cdl08
      LET l_npq.npq04 = ''
     #LET l_npq.npq05 = l_cdl05   #FUN-D80089 mark
      LET l_npq.npq05 = l_cdl16    #FUN-D80089 add
      LET l_npq.npq06 = '1'
      IF l_cdl10 >0 THEN 
         LET l_npq.npq06 = '2'
         LET l_npq.npq07f = l_cdl10  
         LET l_npq.npq07  = l_cdl10
      ELSE 
         LET l_npq.npq06 = '1'
         LET l_npq.npq07f = l_cdl10*(-1)  
         LET l_npq.npq07  = l_cdl10*(-1)
      END IF   
      #No.TQC-BB0046  --Begin
      #LET l_npq.npq07f = cl_digcut(l_npq.npq07f,2) 
      #LET l_npq.npq07  = cl_digcut(l_npq.npq07,2)
      LET l_npq.npq07f  = cl_digcut(l_npq.npq07f,t_azi04)
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)
      #No.TQC-BB0046  --End
#      LET l_npq.npq08 = NULL
      LET l_npq.npq08 = l_cdl14   #No.FUN-CC0153
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
#      LET l_npq.npq35 = ' '
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)       #FUN-D60025 add by yuhuabao130605
        RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
      IF l_cdl15 IS NULL THEN LET l_cdl15 = ' ' END IF     #No.FUN-CC0153
      LET l_npq.npq35 = l_cdl15                            #No.FUN-CC0153
      LET l_npq.npq36 = ' '
      LET l_npq.npq37 = ' '
      LET l_npq.npqtype = l_npp.npptype
      LET l_npq.npqlegal =l_npp.npplegal
      #FUN-D40118--add--str--
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = tm.b 
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,tm.b) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES(l_npq.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      LET l_npq02 = l_npq02 + 1 
      LET g_success ='Y'
   END FOREACH 

   FOREACH p324_c5 USING  l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04,l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04,l_cdl.cdl01,l_cdl.cdl02,l_cdl.cdl03,l_cdl.cdl04
                   #INTO l_cdl01,l_cdl02,l_cdl03,l_cdl04,l_cdl09,l_cdl05,l_cdl10    #FUN-D80089 mark
                    INTO l_cdl01,l_cdl02,l_cdl03,l_cdl04,l_cdl09,l_cdl16,l_cdl10     #FUN-D80089 add
      IF STATUS THEN LET g_success = 'N' RETURN END IF
      #No.MOD-C30878  --Begin
      IF l_cdl10 = 0 THEN
         CONTINUE FOREACH
      END IF
      #No.MOD-C30878  --End
      INITIALIZE l_npq.* TO NULL
      LET l_npq.npqsys ='CA'
      LET l_npq.npq00  = 6
      LET l_npq.npq01  =l_npp.npp01
      LET l_npq.npq011 = 1
      LET l_npq.npq02 = l_npq02
      LET l_npq.npq03 = l_cdl09
      LET l_npq.npq04 = ''
     #LET l_npq.npq05 = l_cdl05    #FUN-D80089 mark
      LET l_npq.npq05 = l_cdl16     #FUN-D80089 add
      LET l_npq.npq06 = '1'
      IF l_cdl10 >0 THEN 
         LET l_npq.npq06 = '1'
         LET l_npq.npq07f = l_cdl10  
         LET l_npq.npq07  = l_cdl10
      ELSE 
         LET l_npq.npq06 = '2'
         LET l_npq.npq07f = l_cdl10*(-1)  
         LET l_npq.npq07  = l_cdl10*(-1)
      END IF   
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,2) 
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,2)
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
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = tm.b
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
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

   IF NOT cl_null(l_npp.npp01) THEN
      LET l_cdl.cdl11 = l_npp.npp01
      UPDATE cdl_file SET cdl11 = l_cdl.cdl11 
       WHERE cdl01 = l_cdl.cdl01
         AND cdl02 = l_cdl.cdl02
         AND cdl03 = l_cdl.cdl03
         AND cdl04 = l_cdl.cdl04

   END IF   
#尾差
   SELECT SUM(npq07) INTO l_sumc FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 6
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '1'

   SELECT SUM(npq07) INTO l_sumd FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 6
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '2'

   SELECT SUM(npq07f) INTO l_sumfc FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 6
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '1'

   SELECT SUM(npq07f) INTO l_sumfd FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 6
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '2'

   IF cl_null(l_sumc) THEN LET l_sumc =0 END IF 
   IF cl_null(l_sumd) THEN LET l_sumd =0 END IF 
   IF cl_null(l_sumfc) THEN LET l_sumfc =0 END IF 
   IF cl_null(l_sumfd) THEN LET l_sumfd =0 END IF 

   IF g_success ='Y' AND l_sumc <> l_sumd THEN 
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 6
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_ccz21         
         LET l_npq.npq04 = ''
         #No.MOD-C20135  --Begin
         SELECT aag05 INTO l_aag05 FROM aag_file
          WHERE aag01 = l_npq.npq03
            AND aag00 = l_cdl.cdl01
         IF NOT cl_null(l_aag05) AND l_aag05 = 'N' THEN
         #No.MOD-C20135  --End
         SELECT aag05 INTO l_aag05 FROM aag_file
            LET l_npq.npq05 = NULL
         #No.MOD-C20135  --Begin
         ELSE
            LET l_npq.npq05 = l_ccz23
         END IF
         #No.MOD-C20135  --End
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
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = tm.b
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
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
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
   IF g_success ='Y' AND (g_prog ='axct324' OR g_prog ='axct325')  THEN CALL cl_err('','abm-019',0) END IF 
   IF g_success ='N'  THEN CALL cl_err('','aap-129',0) END IF 
END FUNCTION

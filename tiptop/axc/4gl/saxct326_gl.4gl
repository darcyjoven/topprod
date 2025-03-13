# Prog. Version..: '5.30.07-13.05.31(00006)'     #
#
# Pattern name...: saxct326_gl.4gl
# Descriptions...: 入库成本调整分录产生子程序
# Date & Author..: 11/11/11 By elva   #No.FUN-BB0038
# Modify.........: No.FUN-C60003 12/06/01 By elva
# Modify.........: No:MOD-C70140 12/07/11 By yinhy 原幣取位時使用t_azi04
# Modify.........: No.FUN-C90002 12/09/03 By minpp 增加参数传入p_cdm00,判斷來源作業
# Modify.........: No.MOD-D40036 13/04/08 By wujie 修正程序共用判断npp00是8还是9的问题
# Modify.........: No.MOD-D40079 13/04/12 By wujie 若科目做部门管理，则带ccz23
# Modify.........: No:MOD-D50164 13/05/20 By bart g_success預設為Y
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D60025 13/06/05 by yuhuabao 根據系統設置自動帶摘要已經核算項

DATABASE ds   

#No.FUN-BB0038
GLOBALS "../../config/top.global"

DEFINE g_npp00     LIKE npp_file.npp00           #No.MOD-D40036 

#FUNCTION p326_gl(tm)                            #FUN-C90002
FUNCTION p326_gl(tm,p_cdm00)                     #FUN-C90002
DEFINE l_npp       RECORD LIKE npp_file.*
DEFINE l_npq       RECORD LIKE npq_file.*
DEFINE l_cdm       RECORD LIKE cdm_file.*
DEFINE l_date      LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_ccz12     LIKE ccz_file.ccz12 
DEFINE l_ccz21     LIKE ccz_file.ccz21
DEFINE l_wc        STRING
DEFINE l_npq02     LIKE npq_file.npq02
DEFINE l_cdm01     LIKE cdm_file.cdm01
DEFINE l_cdm02     LIKE cdm_file.cdm02
DEFINE l_cdm03     LIKE cdm_file.cdm03
DEFINE l_cdm04     LIKE cdm_file.cdm04
DEFINE l_cdm07     LIKE cdm_file.cdm07
DEFINE l_cdm08     LIKE cdm_file.cdm08 #FUN-C60003 
DEFINE l_cdm09     LIKE cdm_file.cdm09
DEFINE l_cdm11     LIKE cdm_file.cdm11
DEFINE g_cdm09     LIKE cdm_file.cdm09
DEFINE l_ccz24     LIKE ccz_file.ccz24
DEFINE l_ccz25     LIKE ccz_file.ccz25
DEFINE g_wc        STRING 
DEFINE tm          RECORD 
                   ccb06       LIKE ccb_file.ccb06,
                   ccb02       LIKE ccb_file.ccb02,
                   ccb03       LIKE ccb_file.ccb03,
                   b           LIKE aaa_file.aaa01
                   END RECORD
DEFINE l_n         LIKE type_file.num5
DEFINE l_sumc      LIKE npq_file.npq07
DEFINE l_sumd      LIKE npq_file.npq07
DEFINE l_sumfc     LIKE npq_file.npq07f
DEFINE l_sumfd     LIKE npq_file.npq07f 
DEFINE p_cdm00     LIKE cdm_file.cdm00        #FUN-C90002
DEFINE l_ccz19     LIKE ccz_file.ccz19        #FUN-C90002
DEFINE l_aag05     LIKE aag_file.aag05        #No.MOD-D40079 
DEFINE l_aag44     LIKE aag_file.aag44        #FUN-D40118 add
DEFINE l_flag      LIKE type_file.chr1        #FUN-D40118 add
DEFINE l_bookno1   LIKE aza_file.aza81   #FUN-D60025
DEFINE l_bookno2   LIKE aza_file.aza82   #FUN-D60025
DEFINE l_bookno3   LIKE aza_file.aza81   #FUN-D60025

   WHENEVER ERROR CALL cl_err_msg_log
   INITIALIZE l_cdm.* TO NULL

   #LET g_success = 'N'  #MOD-D50164
   LET g_success = 'Y'  #MOD-D50164

  #No.MOD-D40036--begin--
   IF p_cdm00 = '1' THEN 
       LET g_npp00 = '9'
   END IF 
   IF p_cdm00 = '2' THEN 
       LET g_npp00 = '8'
   END IF 
  #No.MOD-D40036---end---
     
   SELECT ccz12,ccz21 INTO l_ccz12,l_ccz21 FROM ccz_file
   
   LET l_sql = "SELECT DISTINCT cdm01,cdm02,cdm03,cdm04 ",
               "  FROM cdm_file ",
               " WHERE cdm00 = '",p_cdm00,"'" ,    #FUN-C90002
               "   AND cdm01 ='",tm.b CLIPPED,"'",
               "   AND cdm02 =",tm.ccb02 CLIPPED,
               "   AND cdm03 =",tm.ccb03 CLIPPED,
               "   AND cdm04 ='",tm.ccb06 CLIPPED,"'"

   PREPARE p326_p3 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p326_c3 CURSOR FOR p326_p3

   LET l_sql = "SELECT cdm01,cdm02,cdm03,cdm04,cdm07,SUM(cdm09) ",
               "  FROM cdm_file,aag_file ",
               " WHERE cdm01 =? ",
               "   AND cdm02 =? ",
               "   AND cdm03 =? ",
               "   AND cdm04 =? ", 
               "   AND cdm01 = aag00 ",
               "   AND cdm07 = aag01 ",
               "   AND cdm07 IS NOT NULL ",
               "   AND cdm00 = '",p_cdm00,"'" ,    #FUN-C90002
               " GROUP BY cdm01,cdm02,cdm03,cdm04,cdm07 ",
               " UNION ",
               "SELECT cdm01,cdm02,cdm03,cdm04,cdm07,cdm09 ",
               "  FROM cdm_file ",
               " WHERE cdm01 =? ",
               "   AND cdm02 =? ",
               "   AND cdm03 =? ",
               "   AND cdm04 =? ",  
               "   AND cdm07 IS NULL ", 
               "   AND cdm00 = '",p_cdm00,"'" ,    #FUN-C90002
               " ORDER BY cdm01,cdm02,cdm03,cdm04,cdm07 "

   PREPARE p326_p4 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p326_c4 CURSOR FOR p326_p4
   
   FOREACH p326_c3 INTO l_cdm.cdm01,l_cdm.cdm02,l_cdm.cdm03,l_cdm.cdm04  
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success ='N'
         RETURN 
      END IF 
      INITIALIZE l_npp.* TO NULL
      IF l_cdm.cdm01 = l_ccz12 THEN 
         LET l_npp.npptype =0
      ELSE
         LET l_npp.npptype =1
      END IF  
      LET l_date = MDY(l_cdm.cdm03,1,l_cdm.cdm02)
      LET l_npp.nppsys   = 'CA'
      LET l_npp.nppsys   = 'CA'
     #No.MOD-D40036--begin-- modify
      LET l_npp.npp00 = g_npp00
     #No.MOD-D40036---end---
      LET l_npp.npp01    = 'G',l_cdm.cdm04 CLIPPED,l_cdm.cdm01 CLIPPED,'-',l_cdm.cdm02 USING '&&&&',l_cdm.cdm03 CLIPPED USING '&&','0001'
      LET l_npp.npp011   = 1
      LET l_npp.npp02    = s_last(l_date)
      LET l_npp.npp03    = NULL
      LET l_npp.npp06    = g_plant
      #FUN-C90002--add--str
      IF p_cdm00 = '2' THEN
         LET l_npp.npp01= 'G',l_cdm.cdm04 CLIPPED,l_cdm.cdm01 CLIPPED,'-',l_cdm.cdm02 USING "&&&&",l_cdm.cdm03 CLIPPED USING "&&",'0002'
      END IF
      #FUN-C90002--add--end
      SELECT DISTINCT cdmlegal INTO l_npp.npplegal 
        FROM cdm_file 
       WHERE cdm01 = l_cdm.cdm01
         AND cdm02 = l_cdm.cdm02
         AND cdm03 = l_cdm.cdm03
         AND cdm04 = l_cdm.cdm04
         
      LET l_npp.nppglno  = NULL
      LET l_npp.npp07 = l_cdm.cdm01
     #No.MOD-D40036--begin--
      SELECT COUNT(*) INTO l_n FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = g_npp00
         AND npp01   = l_npp.npp01
         AND npp011  = 1
         AND npptype = l_npp.npptype
         AND nppglno IS NOT NULL 
     #No.MOD-D40036---end---
         
      IF l_n >0 THEN  
         CALL cl_err(l_npp.npp01,'axm-275',1)
         LET g_success ='N' 
         RETURN 
      END IF 
                
     #No.MOD-D40036--begin-- modify
      DELETE FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = g_npp00
         AND npp01   = l_npp.npp01
         AND npp011  = 1
         AND npptype = l_npp.npptype
     #No.MOD-D40036---end---  
      
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
     #No.MOD-D40036--begin-- modify
      DELETE FROM npq_file
       WHERE npqsys  = 'CA'
         AND npq00   = g_npp00
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype
     #No.MOD-D40036---end---
   #FUN-B40056 --begin
      DELETE FROM tic_file
       WHERE tic04 = l_npp.npp01
   #FUN-B40056 --end
      LET l_npq02 = 1
      FOREACH p326_c4 USING  l_cdm.cdm01,l_cdm.cdm02,l_cdm.cdm03,l_cdm.cdm04,l_cdm.cdm01,l_cdm.cdm02,l_cdm.cdm03,l_cdm.cdm04
                       INTO l_cdm01,l_cdm02,l_cdm03,l_cdm04,l_cdm07,l_cdm09                    
         IF STATUS THEN LET g_success = 'N' RETURN END IF
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
        #No.MOD-D40036--begin-- modify
         LET l_npq.npq00  = g_npp00
        #No.MOD-D40036---end---
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_cdm07
         LET l_npq.npq04 = ''  
#No.MOD-D40079 --begin
         LET l_aag05 = NULL 
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = tm.b AND aag01 = l_npq.npq03
         IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
         IF l_cdm09 > 0 THEN
            LET l_npq.npq06 = '1'
            LET g_cdm09 = l_cdm09
         ELSE
            LET l_npq.npq06 = '2'
            LET g_cdm09 = l_cdm09 * -1
         END IF                  
         LET l_npq.npq07f = g_cdm09  
         LET l_npq.npq07  = g_cdm09  
         #No.MOD-C70140  --Begin
         #LET l_npq.npq07f = cl_digcut(l_npq.npq07f,2) 
         #LET l_npq.npq07  = cl_digcut(l_npq.npq07,2)
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04) 
         LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)
         #No.MOD-C70140  --End
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
      
   END FOREACH
   
   IF NOT cl_null(l_npp.npp01) THEN
      LET l_cdm.cdm10 = l_npp.npp01
      UPDATE cdm_file SET cdm10 = l_cdm.cdm10 
       WHERE cdm00 = p_cdm00                         #FUN-C90002
         AND cdm01 = l_cdm.cdm01
         AND cdm02 = l_cdm.cdm02
         AND cdm03 = l_cdm.cdm03
         AND cdm04 = l_cdm.cdm04
   END IF
      
   #No.MOD-D40036--begin-- modify
    SELECT SUM(npq07),SUM(npq07f) INTO l_sumc,l_sumfc FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = g_npp00
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '1'
    SELECT SUM(npq07),SUM(npq07f) INTO l_sumd,l_sumfd FROM npq_file 
       WHERE npqsys  = 'CA'
         AND npq00   = g_npp00
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype 
         AND npq06   = '2'
   #No.MOD-D40036---end---

   IF cl_null(l_sumc) THEN LET l_sumc =0 END IF 
   IF cl_null(l_sumd) THEN LET l_sumd =0 END IF 
   IF cl_null(l_sumfc) THEN LET l_sumfc =0 END IF 
   IF cl_null(l_sumfd) THEN LET l_sumfd =0 END IF 

   SELECT ccz19 INTO l_ccz19 FROM ccz_file       #FUN-C90002
   SELECT ccz24,ccz25 INTO l_ccz24,l_ccz25 FROM ccz_file 

#FUN-C60003 --begin
#  IF l_ccz24 = l_ccz25 THEN
#    IF g_success ='Y' AND l_sumc <> l_sumd THEN 
#        INITIALIZE l_npq.* TO NULL
#        LET l_npq.npqsys ='CA'
#        LET l_npq.npq00  = 9
#        LET l_npq.npq01  =l_npp.npp01
#        LET l_npq.npq011 = 1
#        LET l_npq.npq02 = l_npq02
#        LET l_npq.npq03 = l_ccz24         
#        LET l_npq.npq04 = ''
#        LET l_npq.npq05 = NULL  
#        IF l_sumc - l_sumd >0 THEN
#           LET l_npq.npq06 = '2'
#           LET l_npq.npq07f = l_sumfc - l_sumfd 
#           LET l_npq.npq07  = l_sumc  - l_sumd         
#        ELSE 
#           LET l_npq.npq06 = '1'          	
#           LET l_npq.npq07f = l_sumfd - l_sumfc 
#           LET l_npq.npq07  = l_sumd  - l_sumc
#        END IF 
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
#    END IF
#  ELSE
     IF g_success ='Y' AND l_sumc <> l_sumd THEN 
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
        #No.MOD-D40036--begin-- modify
         LET l_npq.npq00  = g_npp00
        #No.MOD-D40036---end---
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02            
         LET l_npq.npq04 = ''
#No.MOD-D40079 --begin
         LET l_aag05 = NULL 
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = tm.b AND aag01 = l_npq.npq03
         IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end  
         IF l_sumc - l_sumd >0 THEN
            LET l_npq.npq06 = '2'
            LET l_npq.npq03 = l_ccz25
            #FUN-C90002--add---str
            IF p_cdm00 = '2' THEN
               LET l_npq.npq03=l_ccz19
            END IF
            #FUN-C90002---add--end
            LET l_npq.npq07f = l_sumfc - l_sumfd 
            LET l_npq.npq07  = l_sumc  - l_sumd         
         ELSE 
            LET l_npq.npq06 = '1'
            LET l_npq.npq03 = l_ccz24  
            #FUN-C90002--add---str
            IF p_cdm00 = '2' THEN
               LET l_npq.npq03=l_ccz19
            END IF
            #FUN-C90002---add--end
            LET l_npq.npq07f = l_sumfd - l_sumfc 
            LET l_npq.npq07  = l_sumd  - l_sumc
#No.MOD-D40079 --begin
         LET l_aag05 = NULL 
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = tm.b AND aag01 = l_npq.npq03
         IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
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
         RETURNING l_npq.*                                                     #FUN-D60025 add by yuhuabao130605
         INSERT INTO npq_file VALUES(l_npq.*)
         IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
         LET l_npq02 = l_npq02 + 1   
     END IF   	
#   END IF
   #FUN-C60003 --end
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021   
   IF g_success ='Y' AND g_prog ='axct326' THEN CALL cl_err('','abm-019',0) END IF 
   IF g_success ='N' THEN CALL cl_err('','aap-129',0) END IF 
END FUNCTION


# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: axcp321.4gl
# Descriptions...: 工单入库分录底稿整批生成作业
# Date & Author..: 10/07/07 By wujie   #No.FUN-AA0025
# Modify.........:
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:TQC-BB0046 11/11/04 By yinhy 根據幣種取位
# Modify.........: No:FUN-BB0038 11/11/17 By elva 成本改善
# Modify.........: No:FUN-D20040 13/02/20 By wujie 增加cdg14，部门厂商的group，核算项1取cdg14
# Modify.........: No.MOD-D40058 13/04/03 By wujie 修正委托加工物资科目取值问题
# Modify.........: No:MOD-D40073 13/04/11 By wujie 增加考虑科目是否做核算项管理
# Modify.........: No:MOD-D50164 13/05/20 By bart g_success預設為Y
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.FUN-D60025 13/06/05 by yuhuabao 根據系統設置自動帶摘要已經核算項
# Modify.........: No.MOD-DB0136 13/11/20 By suncx axct328產生分錄成功後無提示信息

DATABASE ds   
#No.FUN-AA0025
GLOBALS "../../config/top.global"



FUNCTION p321_gl(g_type,g_wc,b)  #FUN-BB0038 add g_type '1'.入库 '2'.差异转出
DEFINE l_npp       RECORD LIKE npp_file.*
DEFINE l_npq       RECORD LIKE npq_file.*
DEFINE l_cdg       RECORD LIKE cdg_file.*
DEFINE l_date      LIKE type_file.dat
DEFINE l_sql       STRING
DEFINE l_ccz12     LIKE ccz_file.ccz12 
DEFINE l_ccz21     LIKE ccz_file.ccz21
DEFINE l_wc        STRING
DEFINE l_npq02     LIKE npq_file.npq02
DEFINE l_cdg01     LIKE cdg_file.cdg01
DEFINE l_cdg02     LIKE cdg_file.cdg02
DEFINE l_cdg03     LIKE cdg_file.cdg03
DEFINE l_cdg04     LIKE cdg_file.cdg04
DEFINE l_cdg09     LIKE cdg_file.cdg09
DEFINE l_cdg11     LIKE cdg_file.cdg11
DEFINE l_cdg12     LIKE cdg_file.cdg12
DEFINE l_cdh01     LIKE cdh_file.cdh01
DEFINE l_cdh02     LIKE cdh_file.cdh02
DEFINE l_cdh03     LIKE cdh_file.cdh03
DEFINE l_cdh04     LIKE cdh_file.cdh04
DEFINE l_cdh08     LIKE cdh_file.cdh08
DEFINE l_cdh10     LIKE cdh_file.cdh10
DEFINE l_cdh11     LIKE cdh_file.cdh11
DEFINE l_cdi05     LIKE cdi_file.cdi05
DEFINE l_cdi06     LIKE cdi_file.cdi06
DEFINE l_cdi07     LIKE cdi_file.cdi07
DEFINE l_cdi08     LIKE cdi_file.cdi08
DEFINE l_cdi09     LIKE cdi_file.cdi09
DEFINE l_cdi10     LIKE cdi_file.cdi10
DEFINE l_cdi11     LIKE cdi_file.cdi11
DEFINE l_cdi12b    LIKE cdi_file.cdi12b
DEFINE l_cdi12c    LIKE cdi_file.cdi12c
DEFINE l_cdi12d    LIKE cdi_file.cdi12d
DEFINE l_cdi12e    LIKE cdi_file.cdi12e
DEFINE l_cdi12f    LIKE cdi_file.cdi12f
DEFINE l_cdi12g    LIKE cdi_file.cdi12g
DEFINE l_cdi12h    LIKE cdi_file.cdi12h
DEFINE g_wc        STRING 
DEFINE b           LIKE aaa_file.aaa01
DEFINE l_n         LIKE type_file.num5
DEFINE l_sumc      LIKE npq_file.npq07
DEFINE l_sumd      LIKE npq_file.npq07
DEFINE l_sumfc     LIKE npq_file.npq07f
DEFINE l_sumfd     LIKE npq_file.npq07f
DEFINE l_aag05     LIKE aag_file.aag05
DEFINE g_type      LIKE cdi_file.cdi00 #FUN-BB0038
DEFINE l_cdg14     LIKE cdg_file.cdg14     #No.FUN-D20040
DEFINE l_aag15     LIKE aag_file.aag15   #No.MOD-D40073
DEFINE g_aag44     LIKE aag_file.aag44   #FUN-D40118 add
DEFINE l_flag      LIKE type_file.chr1   #FUN-D40118 add
DEFINE l_bookno1   LIKE aza_file.aza81   #FUN-D60025
DEFINE l_bookno2   LIKE aza_file.aza82   #FUN-D60025
DEFINE l_bookno3   LIKE aza_file.aza81   #FUN-D60025

   WHENEVER ERROR CALL cl_err_msg_log
   INITIALIZE l_cdg.* TO NULL

   #LET g_success = 'N'  #MOD-D50164
   LET g_success = 'Y'  #MOD-D50164
   LET l_wc = cl_replace_str(g_wc,"ccg06","cdg04")
   LET l_wc = cl_replace_str(l_wc,"ccg02","cdg02")
   LET l_wc = cl_replace_str(l_wc,"ccg03","cdg03")
   
   SELECT ccz12,ccz21 INTO l_ccz12,l_ccz21 FROM ccz_file 
   
   LET l_sql = "SELECT DISTINCT cdg00,cdg01,cdg02,cdg03,cdg04 ", #FUN-BB0038 add cdg00
               "  FROM cdg_file ",
               " WHERE ",l_wc CLIPPED 

   #FUN-BB0038 --begin
   IF g_type='2' THEN LET l_sql=l_sql CLIPPED," AND cdg00='2'"
                 ELSE LET l_sql=l_sql CLIPPED," AND cdg00='1'"
   END IF
   #FUN-BB0038 --end
   PREPARE p321_p3 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p321_c3 CURSOR FOR p321_p3

      LET l_sql = "SELECT cdg01,cdg02,cdg03,cdg04,cdg09,cdg12,cdg14,SUM(cdg11)*(-1) ",    #No.FUN-D20040 add cdg14
                  "  FROM cdg_file,aag_file ",
                  " WHERE cdg01 =? ",
                  "   AND cdg02 =? ",
                  "   AND cdg03 =? ",
                  "   AND cdg04 =? ",
                  "   AND cdg00 =? ", #FUN-BB0038
                  "   AND cdg01 = aag00 ",
                  "   AND cdg09 = aag01 ",
                  "   AND aag05 ='Y' ",  
                  "   AND cdg09 IS NOT NULL ",
                  "   AND cdg00 ='2' ", #FUN-BB0038
                  " GROUP BY cdg01,cdg02,cdg03,cdg04,cdg09,cdg12,cdg14 ",                #No.FUN-D20040 add cdg14
                  " UNION ",
                  "SELECT cdg01,cdg02,cdg03,cdg04,cdg09,'',cdg14,SUM(cdg11)*(-1) ",      #No.FUN-D20040 add cdg14
                  "  FROM cdg_file,aag_file ",
                  " WHERE cdg01 =? ",
                  "   AND cdg02 =? ",
                  "   AND cdg03 =? ",
                  "   AND cdg04 =? ",
                  "   AND cdg00 =? ", #FUN-BB0038
                  "   AND cdg01 = aag00 ",
                  "   AND cdg09 = aag01 ",
                  "   AND aag05 ='N' ", 
                  "   AND cdg09 IS NOT NULL ",
                  " GROUP BY cdg01,cdg02,cdg03,cdg04,cdg09,cdg14 ",                      #No.FUN-D20040 add cdg14
                  " UNION ",
                  "SELECT cdg01,cdg02,cdg03,cdg04,cdg09,cdg12,cdg14,cdg11*(-1) ",        #No.FUN-D20040 add cdg14
                  "  FROM cdg_file ",
                  " WHERE cdg01 =? ",
                  "   AND cdg02 =? ",
                  "   AND cdg03 =? ",
                  "   AND cdg04 =? ",
                  "   AND cdg00 =? ", #FUN-BB0038
                  "   AND cdg09 IS NULL ",
                  " ORDER BY cdg01,cdg02,cdg03,cdg04,cdg09,cdg14 "                       #No.FUN-D20040 add cdg14

   PREPARE p321_p4 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1)
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p321_c4 CURSOR FOR p321_p4

     #LET l_sql = "SELECT cdh01,cdh02,cdh03,cdh04,cdh08,cdh11,SUM(cdh10)*(-1) ",    #No.MOD-D40058 mark
      LET l_sql = "SELECT cdh01,cdh02,cdh03,cdh04,cdh08,cdh11,'',SUM(cdh10)*(-1) ", #No.MOD-D40058
                  "  FROM cdh_file,aag_file ",
                  " WHERE cdh01 =? ",
                  "   AND cdh02 =? ",
                  "   AND cdh03 =? ",
                  "   AND cdh04 =? ",
                  "   AND cdh00 =? ", #FUN-BB0038
                  "   AND cdh07 <> ' DL+OH+SUB' ",
                  "   AND cdh01 = aag00 ",
                  "   AND cdh08 = aag01 ",
                  "   AND aag05 ='Y' ", 
                  "   AND cdh08 IS NOT NULL ",
                  " GROUP BY cdh01,cdh02,cdh03,cdh04,cdh08,cdh11 ",
                  " UNION ",
                 #"SELECT cdh01,cdh02,cdh03,cdh04,cdh08,'',SUM(cdh10)*(-1) ",         #No.MOD-D40058 mark
                  "SELECT cdh01,cdh02,cdh03,cdh04,cdh08,'',cdg14,SUM(cdh10)*(-1) ",   #No.MOD-D40058
                 #"  FROM cdh_file,aag_file ",                                        #No.MOD-D40058 mark
                  "  FROM cdh_file,aag_file,cdg_file ",                               #No.MOD-D40058
                  " WHERE cdh01 =? ",
                  "   AND cdh02 =? ",
                  "   AND cdh03 =? ",
                  "   AND cdh04 =? ",
                  "   AND cdh00 =? ", #FUN-BB0038
                  "   AND cdh07 <> ' DL+OH+SUB' ",
                  "   AND cdh01 = aag00 ",
                  "   AND cdh08 = aag01 ",
                  "   AND cdh08 IS NOT NULL ",    
                  "   AND aag05 ='N' ",
                 #No.MOD-D40058--begin--
                  "   AND cdg01 = cdh01 ",
                  "   AND cdg02 = cdh02 ",
                  "   AND cdg03 = cdh03 ",
                  "   AND cdg04 = cdh04 ",
                  "   AND cdg06 = cdh05 ",
                  "   AND cdg07 = cdh06 ",
                  "   AND cdg00 = cdh00 ",
                 #" GROUP BY cdh01,cdh02,cdh03,cdh04,cdh08 ", 
                  " GROUP BY cdh01,cdh02,cdh03,cdh04,cdh08,cdg14 ", 
                 #No.MOD-D40058---end---
                  " UNION ",
                 #"SELECT cdh01,cdh02,cdh03,cdh04,cdh08,cdh11,cdh10*(-1) ",     #No.MOD-D40058 mark
                  "SELECT cdh01,cdh02,cdh03,cdh04,cdh08,cdh11,'',cdh10*(-1) ",  #No.MOD-D40058
                  "  FROM cdh_file ",
                  " WHERE cdh01 =? ",
                  "   AND cdh02 =? ",
                  "   AND cdh03 =? ",
                  "   AND cdh04 =? ",
                  "   AND cdh00 =? ", #FUN-BB0038
                  "   AND cdh07 <> ' DL+OH+SUB' ",
                  "   AND cdh08 IS NULL ",    
                  " ORDER BY cdh01,cdh02,cdh03,cdh04,cdh08 "

   PREPARE p321_p5 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1) 
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p321_c5 CURSOR FOR p321_p5

   LET l_sql = "SELECT cdi05,cdi06,cdi07,cdi08,cdi09,cdi10,cdi11,cdi12b*(-1),cdi12c*(-1),cdi12d*(-1),cdi12e*(-1),cdi12f*(-1),cdi12g*(-1),cdi12h*(-1) ",
               "  FROM cdi_file ",
               " WHERE cdi01 =? ",
               "   AND cdi02 =? ",
               "   AND cdi03 =? ",
               "   AND cdi04 =? ",
               "   AND cdi00 =? "   #FUN-BB0038

   PREPARE p321_p10 FROM l_sql
   IF SQLCA.SQLCODE THEN
      CALL cl_err('FILL PREPARE:',SQLCA.SQLCODE,1) 
      LET g_success ='N'
      RETURN
   END IF
   DECLARE p321_c10 CURSOR FOR p321_p10
      
   FOREACH p321_c3 INTO l_cdg.cdg00,l_cdg.cdg01,l_cdg.cdg02,l_cdg.cdg03,l_cdg.cdg04   #FUN-BB0038
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         LET g_success ='N'
         RETURN 
      END IF 
      INITIALIZE l_npp.* TO NULL
      IF l_cdg.cdg01 = l_ccz12 THEN 
         LET l_npp.npptype =0
      ELSE
         LET l_npp.npptype =1
      END IF  
      LET l_date = MDY(l_cdg.cdg03,1,l_cdg.cdg02)
      LET l_npp.nppsys   = 'CA'
      LET l_npp.npp00    = 3
      #FUN-BB0038 --begin
      IF g_type = '1' THEN
         LET l_npp.npp01    = 'B',l_cdg.cdg04 CLIPPED,l_cdg.cdg01 CLIPPED,'-',l_cdg.cdg02 USING '&&&&',l_cdg.cdg03 CLIPPED USING '&&','0001'
      ELSE
         LET l_npp.npp01    = 'B',l_cdg.cdg04 CLIPPED,l_cdg.cdg01 CLIPPED,'-',l_cdg.cdg02 USING '&&&&',l_cdg.cdg03 CLIPPED USING '&&','0002'
      END IF
      #FUN-BB0038 --end
      LET l_npp.npp011   = 1
      LET l_npp.npp02    = s_last(l_date)
      LET l_npp.npp03    = NULL
      SELECT DISTINCT cdgplant,cdglegal INTO l_npp.npp06,l_npp.npplegal 
        FROM cdg_file 
       WHERE cdg01 = l_cdg.cdg01
         AND cdg02 = l_cdg.cdg02
         AND cdg03 = l_cdg.cdg03
         AND cdg04 = l_cdg.cdg04
         AND cdg00 = l_cdg.cdg00  #FUN-BB0038
         
      LET l_npp.nppglno  = NULL
      LET l_npp.npp07 = l_cdg.cdg01
      SELECT COUNT(*) INTO l_n FROM npp_file
       WHERE nppsys  = 'CA'
         AND npp00   = 3
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
         AND npp00   = 3
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
         AND npq00   = 3
         AND npq01   = l_npp.npp01
         AND npq011  = 1
         AND npqtype = l_npp.npptype

   #FUN-B40056  --begin
      DELETE FROM tic_file
       WHERE tic04 = l_npp.npp01
   #FUN-B40056  --end
      LET l_npq02 = 1
      INITIALIZE l_npq.* TO NULL
      FOREACH p321_c4 USING  l_cdg.cdg01,l_cdg.cdg02,l_cdg.cdg03,l_cdg.cdg04,l_cdg.cdg00,l_cdg.cdg01,l_cdg.cdg02,l_cdg.cdg03,l_cdg.cdg04,l_cdg.cdg00,l_cdg.cdg01,l_cdg.cdg02,l_cdg.cdg03,l_cdg.cdg04,l_cdg.cdg00  #FUN-BB0038
                       INTO l_cdg01,l_cdg02,l_cdg03,l_cdg04,l_cdg09,l_cdg12,l_cdg14,l_cdg11       #No.FUN-D20040 add cdg14                     
         IF STATUS THEN LET g_success = 'N' RETURN END IF
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 3
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_cdg09
         LET l_npq.npq04 = ''
         LET l_npq.npq05 = l_cdg12  
         LET l_npq.npq06 = '1'
         LET l_npq.npq07f = l_cdg11  
         LET l_npq.npq07  = l_cdg11  
       # LET l_npq.npq07f = cl_digcut(l_npq.npq07f,2)   #FUN-BB0038
       # LET l_npq.npq07  = cl_digcut(l_npq.npq07,2)  #FUN-BB0038
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)   #FUN-BB0038 #TQC-BB0046
         LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)  #FUN-BB0038
         LET l_npq.npq08 = NULL
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)       #FUN-D60025 add by yuhuabao130605
           RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605

#No.FUN-D20040 --begin
#         LET l_npq.npq11 = ' '
         LET l_npq.npq11 = l_cdg14
#No.FUN-D20040 --end
#No.MOD-D40073 --begin
         LET l_aag15 = ''
         SELECT aag15 INTO l_aag15 FROM aag_file 
          WHERE aag00 = l_cdg01
            AND aag01 = l_npq.npq03
         IF cl_null(l_aag15) THEN 
            LET l_npq.npq11 = ' '
         END IF 
#No.MOD-D40073 --end
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
          WHERE aag00 = b 
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
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

      INITIALIZE l_npq.* TO NULL
      FOREACH p321_c5 USING  l_cdg.cdg01,l_cdg.cdg02,l_cdg.cdg03,l_cdg.cdg04,l_cdg.cdg00,l_cdg.cdg01,l_cdg.cdg02,l_cdg.cdg03,l_cdg.cdg04,l_cdg.cdg00,l_cdg.cdg01,l_cdg.cdg02,l_cdg.cdg03,l_cdg.cdg04,l_cdg.cdg00 #FUN-BB0038
                      #INTO l_cdh01,l_cdh02,l_cdh03,l_cdh04,l_cdh08,l_cdh11,l_cdh10          #No.MOD-D40058 mark                 
                       INTO l_cdh01,l_cdh02,l_cdh03,l_cdh04,l_cdh08,l_cdh11,l_cdg14,l_cdh10  #No.MOD-D40058                   
         IF STATUS THEN LET g_success = 'N' RETURN END IF
         INITIALIZE l_npq.* TO NULL
         LET l_npq.npqsys ='CA'
         LET l_npq.npq00  = 3
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_cdh08
         LET l_npq.npq04 = ''
         LET l_npq.npq05 = l_cdh11 
         LET l_npq.npq06 = '2'
         LET l_npq.npq07f = l_cdh10  
         LET l_npq.npq07  = l_cdh10 
         LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038 #TQC-BB0046
         LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
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
         LET l_npq.npq11 = l_cdg14   #No.MOD-D40058 mark
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = b
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
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
#处理' DL+OH+SUB'
      INITIALIZE l_npq.* TO NULL
      OPEN p321_c10 USING  l_cdg.cdg01,l_cdg.cdg02,l_cdg.cdg03,l_cdg.cdg04,l_cdg.cdg00 #FUN-BB0038
      FETCH p321_c10 INTO l_cdi05,l_cdi06,l_cdi07,l_cdi08,l_cdi09,l_cdi10,l_cdi11,l_cdi12b,l_cdi12c,l_cdi12d,l_cdi12e,l_cdi12f,l_cdi12g,l_cdi12h                   
      IF STATUS THEN LET g_success = 'N' RETURN END IF
      INITIALIZE l_npq.* TO NULL
      LET l_npq.npqsys ='CA'
      LET l_npq.npq00  = 3
      LET l_npq.npq01  =l_npp.npp01
      LET l_npq.npq011 = 1
      LET l_npq.npq04 = ''
      LET l_npq.npq05 = NULL 
#No.MOD-D40079 --begin
      LET l_aag05 = NULL 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
      IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
      LET l_npq.npq06 = '2'
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
#人工      
      LET l_npq.npq02  = l_npq02
      LET l_npq.npq03  = l_cdi05
      LET l_npq.npq05  = NULL
#No.MOD-D40079 --begin
      LET l_aag05 = NULL 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
      IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
      LET l_npq.npq07f = l_cdi12b  
      LET l_npq.npq07  = l_cdi12b
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038 #TQC-BB0046
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)  #FUN-BB0038
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_cdg.cdg01 AND aag01 = l_npq.npq03
      IF l_aag05 ='Y' THEN 
         DECLARE p320_cdi05 CURSOR FOR 
           SELECT cdh11,SUM(cdh10b)*(-1) 
             FROM cdh_file 
            WHERE cdh01 = l_cdg.cdg01
              AND cdh02 = l_cdg.cdg02
              AND cdh03 = l_cdg.cdg03
              AND cdh04 = l_cdg.cdg04
              AND cdh00 = l_cdg.cdg00 #FUN-BB0038
              AND cdh07 = ' DL+OH+SUB'
            GROUP BY cdh11  
         FOREACH p320_cdi05 INTO l_npq.npq05,l_npq.npq07f          
            IF l_npq.npq07f <> 0 THEN   
               LET l_npq.npq07  = l_npq.npq07f
               LET l_npq.npq02  = l_npq02 
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)    #FUN-BB0038  #TQC-BB0046
               LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)  #FUN-BB0038
               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = b
                   AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
               #FUN-D40118--add--end--
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-D60025 add by yuhuabao130605
               RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
               INSERT INTO npq_file VALUES(l_npq.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_npq02 = l_npq02 + 1 
            END IF  
         END FOREACH 
      ELSE  
         IF l_npq.npq07f <> 0 THEN  
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = b
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
            #FUN-D40118--add--end--
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-D60025 add by yuhuabao130605
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
#制费一      
      LET l_npq.npq02  = l_npq02
      LET l_npq.npq03  = l_cdi06
      LET l_npq.npq05  = NULL 
#No.MOD-D40079 --begin
      LET l_aag05 = NULL 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
      IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
      LET l_npq.npq07f = l_cdi12c  
      LET l_npq.npq07  = l_cdi12c
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)   #FUN-BB0038 #TQC-BB0046
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04)  #FUN-BB0038
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_cdg.cdg01 AND aag01 = l_npq.npq03 
      IF l_aag05 ='Y' THEN 
         DECLARE p320_cdi06 CURSOR FOR 
           SELECT cdh11,SUM(cdh10c)*(-1) 
             FROM cdh_file 
            WHERE cdh01 = l_cdg.cdg01
              AND cdh02 = l_cdg.cdg02
              AND cdh03 = l_cdg.cdg03
              AND cdh04 = l_cdg.cdg04
              AND cdh00 = l_cdg.cdg00 #FUN-BB0038
              AND cdh07 = ' DL+OH+SUB' 
            GROUP BY cdh11 
         FOREACH p320_cdi06 INTO l_npq.npq05,l_npq.npq07f          
            IF l_npq.npq07f <> 0 THEN   
               LET l_npq.npq07  = l_npq.npq07f
               LET l_npq.npq02  = l_npq02
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038  #TQC-BB0046
               LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = b
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
               #FUN-D40118--add--end--
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)   #FUN-D60025 add by yuhuabao130605
               RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
               INSERT INTO npq_file VALUES(l_npq.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_npq02 = l_npq02 + 1 
            END IF  
         END FOREACH 
      ELSE  
         IF l_npq.npq07f <> 0 THEN  
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = b
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
            #FUN-D40118--add--end--
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-D60025 add by yuhuabao130605
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
#制费二      
      LET l_npq.npq02  = l_npq02
      LET l_npq.npq03  = l_cdi08 
      LET l_npq.npq05  = NULL
#No.MOD-D40079 --begin
      LET l_aag05 = NULL 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
      IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
      LET l_npq.npq07f = l_cdi12e  
      LET l_npq.npq07  = l_cdi12e
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038  #TQC-BB0046
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_cdg.cdg01 AND aag01 = l_npq.npq03 
      IF l_aag05 ='Y' THEN 
         DECLARE p320_cdi08 CURSOR FOR 
           SELECT cdh11,SUM(cdh10e)*(-1) 
             FROM cdh_file 
            WHERE cdh01 = l_cdg.cdg01
              AND cdh02 = l_cdg.cdg02
              AND cdh03 = l_cdg.cdg03
              AND cdh04 = l_cdg.cdg04
              AND cdh00 = l_cdg.cdg00 #FUN-BB0038
              AND cdh07 = ' DL+OH+SUB' 
            GROUP BY cdh11 
         FOREACH p320_cdi08 INTO l_npq.npq05,l_npq.npq07f          
            IF l_npq.npq07f <> 0 THEN   
               LET l_npq.npq07  = l_npq.npq07f
               LET l_npq.npq02  = l_npq02
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038 #TQC-BB0046
               LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = b
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                 END IF
               END IF
               #FUN-D40118--add--end--
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-D60025 add by yuhuabao130605
               RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
               INSERT INTO npq_file VALUES(l_npq.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_npq02 = l_npq02 + 1 
            END IF  
         END FOREACH 
      ELSE  
         IF l_npq.npq07f <> 0 THEN  
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = b
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
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
         END IF
      END IF
#制费三      
      LET l_npq.npq02  = l_npq02
      LET l_npq.npq03  = l_cdi09 
      LET l_npq.npq05  = NULL
#No.MOD-D40079 --begin
      LET l_aag05 = NULL 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
      IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
      LET l_npq.npq07f = l_cdi12f  
      LET l_npq.npq07  = l_cdi12f
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038  #TQC-BB0046
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_cdg.cdg01 AND aag01 = l_npq.npq03 
      IF l_aag05 ='Y' THEN 
         DECLARE p320_cdi09 CURSOR FOR 
           SELECT cdh11,SUM(cdh10f)*(-1) 
             FROM cdh_file 
            WHERE cdh01 = l_cdg.cdg01
              AND cdh02 = l_cdg.cdg02
              AND cdh03 = l_cdg.cdg03
              AND cdh04 = l_cdg.cdg04
              AND cdh00 = l_cdg.cdg00 #FUN-BB0038
              AND cdh07 = ' DL+OH+SUB' 
            GROUP BY cdh11 
         FOREACH p320_cdi09 INTO l_npq.npq05,l_npq.npq07f          
            IF l_npq.npq07f <> 0 THEN   
               LET l_npq.npq07  = l_npq.npq07f
               LET l_npq.npq02  = l_npq02
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038 #TQC-BB0046
               LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = b
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
               #FUN-D40118--add--end-- 
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-D60025 add by yuhuabao130605
               RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
               INSERT INTO npq_file VALUES(l_npq.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_npq02 = l_npq02 + 1 
            END IF  
         END FOREACH 
      ELSE  
         IF l_npq.npq07f <> 0 THEN  
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = b
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
            #FUN-D40118--add--end--
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)   #FUN-D60025 add by yuhuabao130605
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
#制费四     
      LET l_npq.npq02  = l_npq02
      LET l_npq.npq05  = NULL 
#No.MOD-D40079 --begin
      LET l_aag05 = NULL 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
      IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
      LET l_npq.npq03  = l_cdi10
      LET l_npq.npq07f = l_cdi12g  
      LET l_npq.npq07  = l_cdi12g
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038  #TQC-BB0046
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_cdg.cdg01 AND aag01 = l_npq.npq03 
      IF l_aag05 ='Y' THEN 
         DECLARE p320_cdi10 CURSOR FOR 
           SELECT cdh11,SUM(cdh10g)*(-1) 
             FROM cdh_file 
            WHERE cdh01 = l_cdg.cdg01
              AND cdh02 = l_cdg.cdg02
              AND cdh03 = l_cdg.cdg03
              AND cdh04 = l_cdg.cdg04
              AND cdh00 = l_cdg.cdg00 #FUN-BB0038
              AND cdh07 = ' DL+OH+SUB' 
            GROUP BY cdh11 
         FOREACH p320_cdi10 INTO l_npq.npq05,l_npq.npq07f          
            IF l_npq.npq07f <> 0 THEN   
               LET l_npq.npq07  = l_npq.npq07f
               LET l_npq.npq02  = l_npq02
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038 #TQC-BB0046
               LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = b
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
               #FUN-D40118--add--end--
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)   #FUN-D60025 add by yuhuabao130605
               RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
               INSERT INTO npq_file VALUES(l_npq.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_npq02 = l_npq02 + 1 
            END IF  
         END FOREACH 
      ELSE  
         IF l_npq.npq07f <> 0 THEN  
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = b
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET l_npq.npq03 = ''
               END IF
            END IF
            #FUN-D40118--add--end--
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)   #FUN-D60025 add by yuhuabao130605
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
#制费五      
      LET l_npq.npq02  = l_npq02
      LET l_npq.npq03  = l_cdi11 
      LET l_npq.npq05  = NULL
#No.MOD-D40079 --begin
      LET l_aag05 = NULL 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
      IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
      LET l_npq.npq07f = l_cdi12h  
      LET l_npq.npq07  = l_cdi12h
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038 #TQC-BB0046
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_cdg.cdg01 AND aag01 = l_npq.npq03 
      IF l_aag05 ='Y' THEN 
         DECLARE p320_cdi11 CURSOR FOR 
           SELECT cdh11,SUM(cdh10h)*(-1) 
             FROM cdh_file 
            WHERE cdh01 = l_cdg.cdg01
              AND cdh02 = l_cdg.cdg02
              AND cdh03 = l_cdg.cdg03
              AND cdh04 = l_cdg.cdg04
              AND cdh00 = l_cdg.cdg00 #FUN-BB0038
              AND cdh07 = ' DL+OH+SUB' 
            GROUP BY cdh11 
         FOREACH p320_cdi11 INTO l_npq.npq05,l_npq.npq07f          
            IF l_npq.npq07f <> 0 THEN   
               LET l_npq.npq07  = l_npq.npq07f
               LET l_npq.npq02  = l_npq02
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038 #TQC-BB0046
               LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = b
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
               #FUN-D40118--add--end--
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-D60025 add by yuhuabao130605
               RETURNING l_npq.*                                                   #FUN-D60025 add by yuhuabao130605
               INSERT INTO npq_file VALUES(l_npq.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('npq03',l_npq.npq03,'insert npq_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_npq02 = l_npq02 + 1 
            END IF  
         END FOREACH 
      ELSE  
         IF l_npq.npq07f <> 0 THEN  
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = b
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
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

#加工      
      LET l_npq.npq02  = l_npq02
      LET l_npq.npq03  = l_cdi07 
      LET l_npq.npq05  = NULL
#No.MOD-D40079 --begin
      LET l_aag05 = NULL 
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
      IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
      LET l_npq.npq07f = l_cdi12d  
      LET l_npq.npq07  = l_cdi12d
      LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038  #TQC-BB0046
      LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_cdg.cdg01 AND aag01 = l_npq.npq03 
      IF l_aag05 ='Y' THEN 
         DECLARE p320_cdi07 CURSOR FOR 
           SELECT cdh11,SUM(cdh10d)*(-1) 
             FROM cdh_file 
            WHERE cdh01 = l_cdg.cdg01
              AND cdh02 = l_cdg.cdg02
              AND cdh03 = l_cdg.cdg03
              AND cdh04 = l_cdg.cdg04
              AND cdh00 = l_cdg.cdg00 #FUN-BB0038
              AND cdh07 = ' DL+OH+SUB' 
            GROUP BY cdh11 
         FOREACH p320_cdi07 INTO l_npq.npq05,l_npq.npq07f          
            IF l_npq.npq07f <> 0 THEN   
               LET l_npq.npq07  = l_npq.npq07f
               LET l_npq.npq02  = l_npq02
               LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #FUN-BB0038 #TQC-BB0046
               LET l_npq.npq07  = cl_digcut(l_npq.npq07,g_azi04) #FUN-BB0038
               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = b
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
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
         END FOREACH 
      ELSE  
         IF l_npq.npq07f <> 0 THEN  
            #FUN-D40118--add--str--
            SELECT aag44 INTO g_aag44 FROM aag_file
             WHERE aag00 = b
               AND aag01 = l_npq.npq03
            IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
               CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
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
      CLOSE p321_c10
      LET g_success ='Y'      
   END FOREACH 

   IF NOT cl_null(l_npp.npp01) THEN
      LET l_cdg.cdg05 = l_npp.npp01
      UPDATE cdg_file SET cdg05 = l_cdg.cdg05 
       WHERE cdg01 = l_cdg.cdg01
         AND cdg02 = l_cdg.cdg02
         AND cdg03 = l_cdg.cdg03
         AND cdg04 = l_cdg.cdg04
         AND cdg00 = l_cdg.cdg00 #FUN-BB0038 
   END IF   
#尾差
   SELECT SUM(npq07) INTO l_sumc FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 3
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '1'

   SELECT SUM(npq07) INTO l_sumd FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 3
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '2'

   SELECT SUM(npq07f) INTO l_sumfc FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 3
        AND npq01   = l_npp.npp01
        AND npq011  = 1
        AND npqtype = l_npp.npptype 
        AND npq06   = '1'

   SELECT SUM(npq07f) INTO l_sumfd FROM npq_file 
      WHERE npqsys  = 'CA'
        AND npq00   = 3
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
         LET l_npq.npq00  = 3
         LET l_npq.npq01  =l_npp.npp01
         LET l_npq.npq011 = 1
         LET l_npq.npq02 = l_npq02
         LET l_npq.npq03 = l_ccz21         
         LET l_npq.npq04 = ''
         LET l_npq.npq05 = NULL  
#No.MOD-D40079 --begin
         LET l_aag05 = NULL 
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag00 = l_bookno3 AND aag01 = l_npq.npq03
         IF l_aag05 = 'Y' THEN LET l_npq.npq05 = g_ccz.ccz23 END IF 
#No.MOD-D40079 --end
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
          WHERE aag00 = b
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,b) RETURNING l_flag
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
  #IF g_success ='Y' AND (g_prog ='axct321' OR g_prog ='axct327') THEN CALL cl_err('','abm-019',0) END IF  #FUN-BB0038 #MOD-DB0136 mark
   IF g_success ='Y'  THEN CALL cl_err('','abm-019',0) END IF  #MOD-DB0136 add
   IF g_success ='N'  THEN CALL cl_err('','aap-129',0) END IF 
END FUNCTION


# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_costs_ar2.4gl
# Descriptions...: 
# Date & Author..:NO.TQC-AC0127 2010/12/22  By  wuxj 
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B80072 11/08/08 By Lujh 模組程序撰寫規範修正

GLOBALS "../../config/top.global"
DEFINE       g_oma         RECORD LIKE oma_file.*, 
             g_omb         RECORD LIKE omb_file.*,
             g_npq         RECORD LIKE npq_file.*,
             g_ooa         RECORD LIKE ooa_file.*,
             g_ool         RECORD LIKE ool_file.*,
             g_oow         RECORD LIKE oow_file.*,
             g_oob         RECORD LIKE oob_file.*,
             b_oob         RECORD LIKE oob_file.*,
             g_npp         RECORD LIKE npp_file.*,
             g_nmh         RECORD LIKE nmh_file.*,
             g_nms         RECORD LIKE nms_file.*,
             g_rxr         RECORD LIKE rxr_file.*,
             li_result     LIKE type_file.num5,
             g_cnt         LIKE type_file.num10,
             g_bookno1     LIKE type_file.chr20,
             g_bookno2     LIKE type_file.chr20,
             g_bookno3     LIKE type_file.chr20,
             g_net         LIKE type_file.num5,
             g_aag05       LIKE aag_file.aag05,
             g_aag23       LIKE aag_file.aag23,
             l_ac          LIKE type_file.num5,
             g_sql1        LIKE type_file.chr1000,
             g_omc         RECORD LIKE omc_file.*,
             g_dbs2        LIKE type_file.chr30
DEFINE       g_plant2      LIKE type_file.chr10
DEFINE       g_flag1       LIKE type_file.chr1
DEFINE tot,tot1,tot2       LIKE type_file.num20_6
DEFINE tot3                LIKE type_file.num20_6
DEFINE un_pay1,un_pay2     LIKE type_file.num20_6
DEFINE       g_sql         STRING 

FUNCTION s_costs_ar2(p_rxr01)
DEFINE p_rxr01    LIKE rxr_file.rxr01
DEFINE l_occ      RECORD LIKE occ_file.*
DEFINE l_rxx      RECORD LIKE rxx_file.*
DEFINE l_ooe02    LIKE ooe_file.ooe02   
DEFINE l_aag05    LIKE aag_file.aag05
DEFINE l_cnt      LIKE type_file.num5
DEFINE i          LIKE type_file.num5
DEFINE l_sql      STRING
DEFINE l_t1       LIKE ooy_file.ooyslip
DEFINE l_ooydmy1  like ooy_file.ooydmy1
DEFINE l_rxy05    LIKE rxy_file.rxy05 
DEFINE l_rxy12    LIKE rxy_file.rxy12
DEFINE l_rxy17    LIKE rxy_file.rxy17

   IF cl_null(p_rxr01) THEN
        CALL cl_err('','-400',0)
        LET g_success = 'N'
        RETURN ''
   END IF
 
   SELECT * INTO g_rxr.* FROM rxr_file
    WHERE rxr01=p_rxr01    
      AND rxr00='2'
 
   IF g_rxr.rxracti='N' THEN  
        CALL cl_err('','alm-048',0)
        LET g_success = 'N'
        RETURN ''
   END IF
 
   LET g_success = 'Y'
 
   ###變量使用前初始化
   INITIALIZE g_ooa.* TO NULL
   INITIALIZE g_oob.* TO NULL
 
   LET g_ooa.ooa00  = '1'
   LET g_ooa.ooa02  = g_today
   LET g_ooa.ooa021 = g_today
   LET g_ooa.ooa03  = 'MISC'     
   LET g_ooa.ooa032 = g_rxr.rxr06
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   LET g_ooa.ooa13 = l_occ.occ67
   LET g_ooa.ooa14 = g_user
   LET g_ooa.ooa15 = g_grup
   LET g_ooa.ooa20 = 'Y'
   LET g_ooa.ooa23 = l_occ.occ42
  
   IF cl_null(g_ooa.ooa23) THEN
      LET g_ooa.ooa23 = g_aza.aza17
   END IF
   
   CALL s_curr3(g_ooa.ooa23,g_ooa.ooa02,'S') RETURNING g_ooa.ooa24
   LET g_ooa.ooa31d = 0
   LET g_ooa.ooa31c = 0
   LET g_ooa.ooa32d = 0
   LET g_ooa.ooa32c = 0
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_ooa.ooa23
   CALL cl_digcut(g_ooa.ooa31d,t_azi04) RETURNING g_ooa.ooa31d
   CALL cl_digcut(g_ooa.ooa31c,t_azi04) RETURNING g_ooa.ooa31c
   CALL cl_digcut(g_ooa.ooa32d,g_azi04) RETURNING g_ooa.ooa32d
   CALL cl_digcut(g_ooa.ooa32c,g_azi04) RETURNING g_ooa.ooa32c
   LET g_ooa.ooa33 = NULL
   LET g_ooa.ooa34 = '1'
   LET g_ooa.ooa35 = "5"
   LET g_ooa.ooa36 = g_rxr.rxr01
   #LET g_ooa.ooa37 = 'Y'
   LET g_ooa.ooa37 = '2'
   LET g_ooa.ooa38 = '1'
   LET g_ooa.ooaconf = 'Y'
   LET g_ooa.ooaprsw = 0
   LET g_ooa.ooauser = g_user
   LET g_ooa.ooagrup = g_grup
   LET g_ooa.ooadate = g_today
   SELECT * INTO g_oow.* FROM oow_file
    WHERE oow00 = '0'   
   IF cl_null(g_oow.oow05) THEN
      CALL cl_err(g_rxr.rxr01,'axr-149',1)
      LET g_success = 'N'
   END IF
   CALL s_auto_assign_no("axr",g_oow.oow05,g_ooa.ooa02,"32","oea_file","oea01","","","")
      RETURNING g_cnt,g_ooa.ooa01
 
   IF (NOT g_cnt) THEN
      CALL cl_err(g_ooa.ooa01,'alm-722',1)
      LET g_success = 'N'
   END IF
 
   LET g_ooa.ooaoriu = g_user  
   LET g_ooa.ooaorig = g_grup 
   LET g_ooa.ooalegal = g_rxr.rxrlegal                                
   INSERT INTO ooa_file values(g_ooa.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
   END IF
 
    INITIALIZE g_oob.* TO NULL
    LET i = 1
    LET g_oob.oob01 = g_ooa.ooa01
    LET g_oob.oob02 = i
    LET g_oob.oob03 = '1'
    LET g_oob.oob04 = '3'
    SELECT oma19 INTO g_oob.oob06 FROM oma_file
     WHERE oma16=g_rxr.rxr03 AND omaconf='Y' AND oma00 = '15'
    SELECT oma18,oma181 INTO g_oob.oob11,g_oob.oob111 FROM oma_file
     WHERE oma01=g_oob.oob06
    IF g_aza.aza63 = 'Y' THEN
       LET g_oob.oob111 =''
    END IF 
    LET g_oob.oob20 = 'N'
    LET g_oob.oob07 = g_ooa.ooa23
    LET g_oob.oob08 = g_ooa.ooa24
    LET g_oob.oob09 = g_rxr.rxr13                         
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob.oob07
    CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
    LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
    CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
    LET g_oob.ooblegal = g_rxr.rxrlegal                        
    INSERT INTO oob_file values(g_oob.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"","ins oob",1)
      LET g_success = 'N'
    END IF
 
    UPDATE ooa_file SET ooa31d = ooa31d + g_oob.oob09 WHERE ooa01 = g_ooa.ooa01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
    END IF
 
    UPDATE ooa_file SET ooa32d = ooa32d + g_oob.oob10 WHERE ooa01 = g_ooa.ooa01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
    END IF
 
   CALL s_get_bookno(year(g_ooa.ooa02)) RETURNING g_flag1,g_bookno1,g_bookno2
   IF g_flag1='1' THEN
      CALL cl_err(g_oma.oma02,'aoo-081',1)
      LET g_success = 'N'
   END IF
   LET l_sql = "SELECT *  FROM rxx_file where rxx01= '",g_rxr.rxr01 CLIPPED ,"'",
               " and rxxplant= '",g_rxr.rxrplant CLIPPED,"' and rxx00='06'"
   PREPARE credit_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('credit_prep:',status,0) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time             #No.FUN-B30211
      EXIT PROGRAM
      LET g_success = 'N'
   END IF
   DECLARE credit_cs CURSOR FOR credit_prep
   FOREACH credit_cs INTO l_rxx.*
     IF STATUS THEN
         CALL s_errmsg('rxx01',g_rxr.rxr01,'l_rxx foreach',STATUS,1)
         LET g_success = 'N'
         RETURN ''
     END IF
     INITIALIZE g_oob.* TO NULL
     SELECT ooe02 INTO l_ooe02 FROM ooe_file,rxx_file
      WHERE ooe01=rxx02 AND rxx00='06' AND rxx02 = l_rxx.rxx02
        AND rxx01=g_rxr.rxr01 AND rxxplant=g_rxr.rxrplant
    LET g_oob.oob01 = g_ooa.ooa01
    LET g_oob.oob02 = i + 1
    LET g_oob.oob03 = '2'
    LET g_oob.oob06 = NULL
    LET g_oob.oob20 = 'N'
    LET g_oob.oob07 = g_ooa.ooa23
    LET g_oob.oob08 = g_ooa.ooa24
    LET g_oob.oob09 = l_rxx.rxx04
    SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob.oob07
    CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
    LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
    CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
    IF l_rxx.rxx02 MATCHES '0[1238]' THEN
       LET g_oob.oob04 = 'A'
       IF l_ooe02 IS NOT NULL THEN
          LET g_oob.oob17 = l_ooe02
          SELECT nma05 INTO g_oob.oob11 FROM nma_file WHERE nma01=l_ooe02
          IF g_aza.aza63 = 'Y' THEN
             SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01=l_ooe02
          ELSE
             LET g_oob.oob111 = NULL
          END IF
      ELSE
      END IF
      SELECT oow04 INTO g_oow.oow04 FROM oow_file
       WHERE oow00 = '0'  
      LET g_oob.oob18 = g_oow.oow04
      SELECT nmc05 INTO g_oob.oob21 FROM nmc_file WHERE nmc01=g_oob.oob18
    END IF
    IF l_rxx.rxx02 = '05' THEN
       LET g_oob.oob04 = 'E'
       IF l_ooe02 IS NOT NULL THEN
          LET g_oob.oob17 = l_ooe02
          SELECT nma05 INTO g_oob.oob11 FROM nma_file
             WHERE nma01=l_ooe02
          IF g_aza.aza63 = 'Y' THEN
            SELECT nma051 INTO g_oob.oob111 FROM nma_file
               WHERE nma01=l_ooe02
          ELSE
             LET g_oob.oob111 = NULL
          END IF
       ELSE
        #若銀行為空,則根據卡種抓科目(rxw_file卡種維護作業)
        #根據rxy_file
        
       LET l_sql = "SELECT rxy05,rxy12,rxy17 FROM rxy_file ",
            " WHERE rxy01 = '",g_rxr.rxr01 ,"'",
            "   AND rxyplant = '", g_rxr.rxrplant,"'",
            "   AND rxy03 = '05' AND rxy00 = '08' "
       PREPARE rxx02_05prep FROM l_sql
       IF STATUS THEN
          CALL cl_err('rxx02_05prep:',status,0) 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time         #No.FUN-B30211
          EXIT PROGRAM
          LET g_success = 'N'
       END IF
       DECLARE rxx02_05cs CURSOR FOR rxx02_05prep
       FOREACH rxx02_05cs INTO l_rxy05,l_rxy12,l_rxy17
           SELECT ood02,ood03 INTO g_oob.oob11,g_oob.oob111 FROM ood_file
               WHERE ood01 = l_rxy12
           IF g_aza.aza63 = 'N' THEN LET g_oob.oob111 = '' END IF
           LET g_oob.oob09 = l_rxy05
           LET g_oob.oob10 = g_oob.oob08 * g_oob.oob09
           IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
              CALL cl_err('','axr-074',1)
              LET g_success = 'N'
           END IF
           IF cl_null(g_oob.oob11) THEN
              CALL cl_err('','axr-074',1)
              LET g_success = 'N'
           END IF
           SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_oob.oob11  AND aag00=g_bookno1
           IF l_aag05 ='Y' THEN
              LET g_oob.oob13=g_ooa.ooa15
           ELSE
              LET g_oob.oob13 = NULL
           END IF
           LET g_oob.ooblegal = g_rxr.rxrlegal
           INSERT INTO oob_file VALUES(g_oob.*)
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"","ins oob",1)
              LET g_success = 'N'
            END IF
 
            UPDATE ooa_file SET ooa31c = ooa31c + g_oob.oob09	WHERE ooa01 = g_ooa.ooa01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
              LET g_success = 'N'
            END IF
 
            UPDATE ooa_file SET ooa32c = ooa32c + g_oob.oob10 WHERE ooa01 = g_ooa.ooa01
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
              CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
              LET g_success = 'N'
            END IF
            LET i = i +1
      END FOREACH
      CONTINUE FOREACH
       END IF
    END IF

    IF l_rxx.rxx02 = '06' THEN           ##儲值卡退款
       INITIALIZE g_oob.* TO NULL
       LET g_oob.oob01 = g_ooa.ooa01
       LET g_oob.oob02 = i + 1
       LET g_oob.oob03 = '2'
       LET g_oob.oob04 = 'C'
       #LET g_oob.oob06 = l_oma01   # (之后審核時候產生預收款的單據)
       #審核的時候產生預收款的單據，并更新oob07,oob08
       LET g_oob.oob20 = 'N' 
       SELECT ool21 INTO g_oob.oob11 FROM ool_file WHERE ool01 = g_ooa.ooa13
       IF cl_null(g_oob.oob11) THEN
          LET g_success = 'N'
          CALL s_errmsg('ool21',g_ooa.ooa13,'sel ool',STATUS,1)
       END IF
       IF g_aza.aza63 = 'Y' THEN
          SELECT ool211 INTO g_oob.oob111 FROM ool_file WHERE ool01 = g_ooa.ooa13
          IF cl_null(g_oob.oob111) THEN
             LET g_success = 'N'
             CALL s_errmsg('ool211',g_ooa.ooa13,'sel ool',STATUS,1)
          END IF
       END IF
       LET g_oob.oob17 = NULL
       LET g_oob.oob18 = NULL
       LET g_oob.oob21 = NULL
       LET g_oob.oob19 = 1
       SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_oob.oob11  AND aag00=g_bookno1
       IF l_aag05 = 'Y' THEN
          LET g_oob.oob13 = g_ooa.ooa15
       ELSE
         LET g_oob.oob13 = ''
       END IF
       LET g_oob.oob09 = l_rxx.rxx04
       LET g_oob.oob10 = l_rxx.rxx04 
       IF cl_null(g_oob.oob09) THEN LET g_oob.oob09=0 END IF
       IF cl_null(g_oob.oob10) THEN LET g_oob.oob10=0 END IF
       LET g_oob.ooblegal = g_legal 
       INSERT INTO oob_file VALUES(g_oob.*) 
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
          CALL s_errmsg('oob01',g_oob.oob01,'ins oob',SQLCA.sqlcode,1)
          LET g_success = 'N'
       END IF
       UPDATE ooa_file SET ooa31c = ooa31c + g_oob.oob09   WHERE ooa01 = g_ooa.ooa01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
          LET g_success = 'N'
       END IF

       UPDATE ooa_file SET ooa32c = ooa32c + g_oob.oob10 WHERE ooa01 = g_ooa.ooa01
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
          LET g_success = 'N'
       END IF
       LET i = i + 1
       CONTINUE FOREACH
    END IF
    
    SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_oob.oob11  AND aag00=g_bookno1
    IF l_aag05 ='Y' THEN
       LET g_oob.oob13=g_ooa.ooa15
    ELSE
       LET g_oob.oob13 = NULL
    END IF
    LET g_oob.ooblegal = g_rxr.rxrlegal
    INSERT INTO oob_file values(g_oob.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"","ins oob",1)
      LET g_success = 'N'
    END IF
 
    UPDATE ooa_file SET ooa31c = ooa31c + g_oob.oob09	WHERE ooa01 = g_ooa.ooa01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
    END IF
 
    UPDATE ooa_file SET ooa32c = ooa32c + g_oob.oob10 WHERE ooa01 = g_ooa.ooa01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
    END IF
    LET i = i +1
   END FOREACH
#########分錄底槁##############
    LET l_t1 = s_get_doc_no(g_ooa.ooa01)
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_t1
    LET l_ooydmy1= ''
    SELECT ooydmy1 INTO l_ooydmy1 FROM ooy_file
     WHERE ooyslip = l_t1
    IF STATUS THEN
       CALL s_errmsg('ooyslip',l_t1,'sel ooy',STATUS,0)
    END IF
     IF l_ooydmy1 = 'Y' THEN
        CALL s_t400_gl(g_ooa.ooa01,'0')
        IF g_aza.aza63='Y' THEN
           CALL s_t400_gl(g_ooa.ooa01,'1')
        END IF
     END IF
     IF g_success = "Y" THEN
        CALL s_costs_ar2_upd()
     ELSE
        UPDATE ooa_file SET ooaconf = 'N' WHERE ooa01 = g_ooa.ooa01
        IF SQLCA.sqlcode THEN
           CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",STATUS,"","",1)
           LET g_success = 'N'
        END IF
     END IF
###################################
     RETURN g_ooa.ooa01
END FUNCTION

FUNCTION s_costs_ar2_upd()
DEFINE l_cnt  LIKE type_file.num5  

   LET g_success = 'Y'
   IF g_ooa.ooamksg='Y' THEN       #若簽核碼為 'Y' 且狀態碼不為 '1' 已同意
         IF g_ooa.ooa34 != '1' THEN
               CALL cl_err('','aws-078',1)
               LET g_success = 'N'
               RETURN
         END IF
   END IF
   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
   IF g_ooa.ooa32d != g_ooa.ooa32c THEN
      CALL cl_err('','axr-203',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF g_ooa.ooa02 <= g_ooz.ooz09 THEN
      CALL cl_err('','axr-164',0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01 = g_ooa.ooa01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ooz.ooz62='Y' THEN        #oob15 = ' '為數值type,要拿掉oracle會產生錯!
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01 = g_ooa.ooa01
         AND oob03 = '2'
         AND oob04 = '1'
         AND (oob06 IS NULL OR oob06 = ' ' OR oob15 IS NULL OR oob15 <= 0 )

      IF cl_null(l_cnt) THEN
         LET l_cnt = 0
      END IF
      IF l_cnt > 0 THEN
         CALL cl_err('','axr-900',0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oob_file,oma_file
    WHERE ( YEAR(oma02) > YEAR(g_ooa.ooa02)
       OR (YEAR(oma02) = YEAR(g_ooa.ooa02)
      AND MONTH(oma02) > MONTH(g_ooa.ooa02)) )
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = g_ooa.ooa01

   IF l_cnt >0 THEN
      CALL cl_err(g_ooa.ooa01,'axr-371',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'N' THEN
      CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
      IF g_aza.aza63='Y' AND g_success='Y' THEN
         CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
      END IF
      LET g_dbs_new = g_dbs CLIPPED,'.'
   END IF

   IF g_success = 'N' THEN
      RETURN
   END IF

   UPDATE ooa_file SET ooa34 = g_ooa.ooa34 WHERE ooa01 = g_ooa.ooa01
   IF STATUS THEN
      LET g_success = 'N'
   END IF
   CALL s_costs_ar2_y1()
END FUNCTION  

FUNCTION s_costs_ar2_y1()
   DEFINE n       LIKE type_file.num5 
   DEFINE l_cnt   LIKE type_file.num5
   DEFINE l_n     LIKE type_file.num5
   DEFINE l_flag  LIKE type_file.chr1 

   UPDATE ooa_file SET ooaconf = 'Y' WHERE ooa01 = g_ooa.ooa01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooaconf",1)
      LET g_success = 'N'
      RETURN
   END IF

   CALL s_costs_ar2_hu2()

   IF g_success = 'N' THEN
      RETURN
   END IF      #更新 ??/??

   DECLARE s_costs_ar2_y1_c CURSOR FOR
   SELECT * FROM oob_file WHERE oob01 = g_ooa.ooa01 ORDER BY oob02

   LET l_cnt = 1
   LET l_n = 1
   LET l_flag = '0'
   CALL s_showmsg_init()
   FOREACH s_costs_ar2_y1_c INTO b_oob.*
      IF STATUS THEN
         CALL s_errmsg('oob01',g_ooa.ooa01,'y1 foreach',STATUS,1)  
         LET g_success = 'N'
         RETURN
      END IF
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF

      IF l_flag = '0' THEN
         LET l_flag = b_oob.oob03
      END IF

      IF l_flag != b_oob.oob03 THEN
         LET l_cnt = l_cnt + 1
      END IF

      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
         CALL s_costs_ar2_bu_13('+')
      END IF

      IF g_ooa.ooa37 = '2' AND b_oob.oob03 = '2' AND b_oob.oob04 = 'C' THEN
         CALL s_costs_ar2_bu_2C('+',l_n)   #產生暫收的單據
      END IF

      LET l_cnt = l_cnt + 1
      LET l_n = l_n + 1 
   END FOREACH
  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF

   #---------------------------------- 970124 roger A/P對沖->需自動產生apf,g,h
   #No.B184 010419 by plum mod 只要類別為9,就都INS AP:apf,g,h
   SELECT COUNT(*) INTO n FROM oob_file
    WHERE oob01 = g_ooa.ooa01
      AND oob04 = '9'
   IF n > 0 THEN
      CALL ins_apf()
   END IF
   CALL s_showmsg()
END FUNCTION

FUNCTION s_costs_ar2_hu2()            #最近交易日
DEFINE l_occ RECORD LIKE occ_file.*
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   IF STATUS THEN
      CALL cl_err3("sel","occ_file",g_ooa.ooa03,"",STATUS,"","s ccc",1)  
      LET g_success='N'
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=g_ooa.ooa02 END IF
   IF l_occ.occ174 IS NULL OR l_occ.occ174 < g_ooa.ooa02 THEN
      LET l_occ.occ174=g_ooa.ooa02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=g_ooa.ooa03
  IF STATUS THEN
     CALL cl_err3("upd","occ_file",g_ooa.ooa03,"",SQLCA.sqlcode,"","u ccc",1)  
     LET g_success='N'
     RETURN
   END IF
END FUNCTION

FUNCTION s_costs_ar2_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1      # +:更新 -:還原
  DEFINE l_omaconf      LIKE oma_file.omaconf,
         l_omavoid      LIKE oma_file.omavoid,
         l_cnt          LIKE type_file.num5  
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE tot4,tot4t     LIKE type_file.num20_6  
  DEFINE tot5,tot6      LIKE type_file.num20_6 
  DEFINE tot8           LIKE type_file.num20_6
  DEFINE l_omc10        LIKE omc_file.omc10,
         l_omc11        LIKE omc_file.omc11,
         l_omc13        LIKE omc_file.omc13

   IF g_bgjob='N' OR cl_null(g_bgjob) THEN
      DISPLAY "bu_13:",b_oob.oob02,' ',b_oob.oob03,' ',b_oob.oob04 AT 2,1
   END IF
   
# 同參考單號若有一筆以上僅沖款一次即可 --------------
  SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='1'
            AND oob04='3'  
            AND oob06=b_oob.oob06
  IF l_cnt>0 THEN RETURN END IF

 #預防在收款沖帳確認前,多沖待抵貨款
  SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob01=ooa01
     AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'     
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF

  IF p_sw='+' THEN
     SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
      WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
        AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'     
       IF cl_null(tot5) THEN LET tot5 = 0 END IF
       IF cl_null(tot6) THEN LET tot6 = 0 END IF
  END IF

  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  CALL cl_digcut(tot1,t_azi04) RETURNING tot1
  CALL cl_digcut(tot2,g_azi04) RETURNING tot2
  LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
            "  FROM ",cl_get_target_table(g_rxr.rxrplant, 'oma_file'),
            " WHERE oma01=?"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
  CALL cl_parse_qry_sql(g_sql, g_rxr.rxrplant) RETURNING g_sql
  PREPARE s_costs_ar2_bu_13_p1 FROM g_sql
  DECLARE s_costs_ar2_bu_13_c1 CURSOR FOR s_costs_ar2_bu_13_p1
  OPEN s_costs_ar2_bu_13_c1 USING b_oob.oob06
  FETCH s_costs_ar2_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
    IF p_sw='+' AND l_omavoid='Y' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) LET g_success = 'N' RETURN 
    END IF
    IF p_sw='+' AND l_omaconf='N' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) LET g_success = 'N' RETURN
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL s_costs_ar2_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4    
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t 

    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN
       CALL s_errmsg(' ',' ','un_pay<pay#1','axr-196',1) LET g_success = 'N' RETURN
       END IF
    END IF

    SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
     WHERE oob06=b_oob.oob06 AND oob01=ooa01  AND ooaconf = 'Y'
       AND oob03='1'  AND oob04 = '3'
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
    IF p_sw='+' THEN
       SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
        WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
          AND ooaconf = 'Y' AND oob03='1'  AND oob04 = '3'
       IF cl_null(tot5) THEN LET tot5 = 0 END IF
       IF cl_null(tot6) THEN LET tot6 = 0 END IF

       SELECT omc10,omc11,omc13 INTO l_omc10,l_omc11,l_omc13 FROM omc_file
        WHERE omc01=b_oob.oob06 AND omc02 = b_oob.oob19
       IF cl_null(l_omc10) THEN LET l_omc10=0 END IF
       IF cl_null(l_omc11) THEN LET l_omc11=0 END IF
       IF cl_null(l_omc13) THEN LET l_omc13=0 END IF
     END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       #取得未沖金額
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
       #未衝金額扣除待扺
       LET tot3 = tot3 - tot4t
    ELSE
       LET tot3 = un_pay2 - tot2 - tot4t
    END IF
    LET g_sql="UPDATE ",cl_get_target_table(g_rxr.rxrplant, 'oma_file')," SET oma55=?,oma57=?,oma61=? ", 
              " WHERE oma01=? "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql           
    CALL cl_parse_qry_sql(g_sql, g_rxr.rxrplant) RETURNING g_sql  
    PREPARE s_costs_ar2_bu_13_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2

    EXECUTE s_costs_ar2_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55',STATUS,1)
       LET g_success = 'N'
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55','axr-198',1) LET g_success = 'N' RETURN
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL s_costs_ar2_omc(p_sw)
    END IF
END FUNCTION

FUNCTION ins_apf()
  DEFINE b_oob      RECORD LIKE oob_file.*
  DEFINE l_apf      RECORD LIKE apf_file.*
  DEFINE l_apg      RECORD LIKE apg_file.*
  DEFINE l_aph      RECORD LIKE aph_file.*
  DEFINE l_amt      LIKE type_file.num20_6
  DEFINE l_apz27    LIKE apz_file.apz27

  INITIALIZE l_apf.* TO NULL
  LET l_apf.apf00='33'
  LET l_apf.apf01 =g_ooa.ooa01
  LET l_apf.apf02 =g_ooa.ooa02
  LET l_apf.apf03 =g_ooa.ooa03
  LET l_apf.apf12 =g_ooa.ooa032
  LET l_apf.apf04 =g_ooa.ooa14
  LET l_apf.apf05 =g_ooa.ooa15
  LET l_apf.apf06 =g_ooa.ooa23
  LET l_apf.apf07 =1
  LET l_apf.apf08f=g_ooa.ooa31d
  LET l_apf.apf08 =g_ooa.ooa32d
  LET l_apf.apf09f=0
  LET l_apf.apf09 =0
  LET l_apf.apf10f=g_ooa.ooa31c
  LET l_apf.apf10 =g_ooa.ooa32c
  LET l_apf.apf13 = ''
  SELECT pmc24 INTO l_apf.apf13 FROM pmc_file
    WHERE pmc01 = g_ooa.ooa03
  LET l_apf.apf41 ='Y'
  LET l_apf.apf44 =g_ooa.ooa33
  LET l_apf.apfinpd =TODAY
  LET l_apf.apfmksg ='N'
  LET l_apf.apfacti ='Y'
  LET l_apf.apfuser =g_user
  LET l_apf.apfgrup =g_grup
  LET l_apf.apforiu = g_user      
  LET l_apf.apforig = g_grup      
  INSERT INTO apf_file VALUES(l_apf.*)
  IF STATUS OR SQLCA.SQLCODE THEN
     CALL s_errmsg('apf01','g_ooa.ooa01','ins apf',SQLCA.SQLCODE,1)
     LET g_success = 'N'
  END IF
  DECLARE ins_apf_c CURSOR FOR
    SELECT * FROM oob_file WHERE oob01=g_ooa.ooa01 ORDER BY 1,2
  FOREACH ins_apf_c INTO b_oob.*
       IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
       END IF
    IF b_oob.oob03='1' THEN
       INITIALIZE l_apg.* TO NULL
       LET l_apg.apg01 =g_ooa.ooa01
       LET l_apg.apg02 =b_oob.oob02
       LET l_apg.apg04 =b_oob.oob06
       LET l_apg.apg05f=b_oob.oob09
       LET l_apg.apg05 =b_oob.oob10
       LET l_apg.apg06 =b_oob.oob19
       INSERT INTO apg_file VALUES(l_apg.*)
       IF STATUS OR SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          LET g_showmsg=g_ooa.ooa01,"/",b_oob.oob02
          CALL s_errmsg('apg01',g_showmsg,'ins apg',SQLCA.SQLCODE,1)
          LET g_success = 'N'
       END IF
    END IF
    IF b_oob.oob03='2' THEN
       INITIALIZE l_aph.* TO NULL
       LET l_aph.aph01 =g_ooa.ooa01
       LET l_aph.aph02 =b_oob.oob02
       LET l_aph.aph03 ='0'
      #No.B592 010525 by plum 若抓科目,到時aapt230,240會無法查到此沖帳記錄
       LET l_aph.aph04 =b_oob.oob06
       LET l_aph.aph05f=b_oob.oob09
       LET l_aph.aph05 =b_oob.oob10
       LET l_aph.aph13 =b_oob.oob07
       LET l_aph.aph14 =b_oob.oob08
       LET l_aph.aph17 =b_oob.oob19  
       INSERT INTO aph_file VALUES(l_aph.*)
       IF STATUS OR SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
          LET g_showmsg=g_ooa.ooa01,"/",b_oob.oob02
          CALL s_errmsg('aph01',g_showmsg,'ins aph',SQLCA.SQLCODE,1)
          LET g_success = 'N'
       END IF
    END IF
  END FOREACH

  IF g_totsuccess="N" THEN
     LET g_success="N"
  END IF
END FUNCTION

FUNCTION s_costs_ar2_omc(p_sw)
DEFINE   l_omc10           LIKE omc_file.omc10
DEFINE   l_omc11           LIKE omc_file.omc11
DEFINE   l_omc13           LIKE omc_file.omc13
DEFINE   p_sw              LIKE type_file.chr1
DEFINE   l_oob09           LIKE oob_file.oob09
DEFINE   l_oob10           LIKE oob_file.oob10

  SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19
     AND oob01=ooa01  AND ooaconf = 'Y'
     AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))
  IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
  IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  CALL cl_digcut(l_oob09,t_azi04) RETURNING l_oob09
  CALL cl_digcut(l_oob10,g_azi04) RETURNING l_oob10
     LET g_sql=" UPDATE ",cl_get_target_table(g_rxr.rxrplant, 'omc_file')," SET omc10=?,omc11=? ",
               " WHERE omc01=? AND omc02=? "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql          
     CALL cl_parse_qry_sql(g_sql, g_rxr.rxrplant) RETURNING g_sql 
     PREPARE s_costs_ar2_bu_13_p3 FROM g_sql
     EXECUTE s_costs_ar2_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
     #LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc13=omc09-omc11",
     LET g_sql=" UPDATE ",cl_get_target_table(g_rxr.rxrplant, 'omc_file')," SET omc13=omc09-omc11",
               " WHERE omc01=? AND omc02=? "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql   
     CALL cl_parse_qry_sql(g_sql, g_rxr.rxrplant) RETURNING g_sql
     PREPARE s_costs_ar2_bu_13_p4 FROM g_sql
     EXECUTE s_costs_ar2_bu_13_p4 USING b_oob.oob06,b_oob.oob19
END FUNCTION

#取得衝帳單的待扺金額
FUNCTION s_costs_ar2_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t

   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION  #TQC-AC0127 add

FUNCTION s_costs_ar2_bu_2C(p_sw,p_cnt)   #暫收
  DEFINE p_sw     LIKE type_file.chr1    # +:更新 -:還原
  DEFINE l_occ    RECORD LIKE occ_file.*
  DEFINE li_result  LIKE type_file.num5
  DEFINE l_omc    RECORD LIKE omc_file.*
  DEFINE l_net           LIKE apv_file.apv04
  DEFINE p_cnt           LIKE type_file.num5

  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  INITIALIZE l_occ.* TO NULL
  INITIALIZE l_omc.* TO NULL
  IF p_sw = '+'  THEN
     INITIALIZE g_oma.* LIKE oma_file.*
     CALL cl_digcut(b_oob.oob09,t_azi04) RETURNING b_oob.oob09
     CALL cl_digcut(b_oob.oob10,g_azi04) RETURNING b_oob.oob10
     LET g_oma.oma00 = '26'             
     CALL s_auto_assign_no("axr",g_oow.oow19,g_today,"26","oma_file","oma01","","","")
          RETURNING li_result,g_oma.oma01
     LET g_oma.oma02 = g_today
    #LET g_oma.oma03 = g_ooa.ooa03
     LET g_oma.oma03 = 'MISCCARD' 
     LET g_oma.oma032 = g_ooa.ooa032
     LET g_oma.oma16 = g_ooa.ooa01
     SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oma.oma03
     LET g_oma.oma68 = l_occ.occ07
     SELECT occ02 INTO g_oma.oma69 FROM occ_file WHERE occ01 = g_oma.oma68
     LET g_oma.oma04 = g_oma.oma03
     LET g_oma.oma05 = l_occ.occ08
     LET g_oma.oma21 = l_occ.occ41
     LET g_oma.oma23 = l_occ.occ42
     LET g_oma.oma40 = l_occ.occ37
     LET g_oma.oma25 = l_occ.occ43
     LET g_oma.oma32 = l_occ.occ45
     LET g_oma.oma042= l_occ.occ11
     LET g_oma.oma043= l_occ.occ18
     LET g_oma.oma044= l_occ.occ231
     CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant2)
          RETURNING g_oma.oma11,g_oma.oma12
     SELECT gec04,gec05,gec07 INTO g_oma.oma211,g_oma.oma212,g_oma.oma213
       FROM gec_file WHERE gec01=g_oma.oma21 AND gec011='2'
     LET g_oma.oma08  = '1'
     IF g_oma.oma23=g_aza.aza17 THEN
        LET g_oma.oma24=1
        LET g_oma.oma58=1
     ELSE
        CALL s_curr3(g_oma.oma23,g_oma.oma02,g_ooz.ooz17) RETURNING g_oma.oma24
        CALL s_curr3(g_oma.oma23,g_oma.oma09,g_ooz.ooz17) RETURNING g_oma.oma58
     END IF
     LET g_oma.oma13 = g_ooa.ooa13
     LET g_oma.oma18 = b_oob.oob11
     IF g_aza.aza63 = 'Y' THEN
        LET g_oma.oma181 = b_oob.oob111
     END IF
     LET g_oma.oma60 = b_oob.oob08
     LET g_oma.oma61 = b_oob.oob10
     LET g_oma.oma70 = NULL
     LET g_oma.oma66 = g_plant 
     LET g_oma.omalegal = g_azw.azw02
     LET g_oma.oma70 = '1'
     LET g_oma.oma50 = 0
     LET g_oma.oma50t = 0
     LET g_oma.oma51f = 0
     LET g_oma.oma51  = 0
     LET g_oma.oma52 = 0
     LET g_oma.oma53 = 0
     LET g_oma.oma54t = b_oob.oob09
     LET g_oma.oma56t=b_oob.oob09*g_oma.oma24
     IF cl_null(g_oma.oma213) THEN LET  g_oma.oma213 = 'N' END IF
     IF cl_null(g_oma.oma211) THEN LET g_oma.oma211 = 0 END IF
     IF g_oma.oma213 = 'N' THEN
        LET g_oma.oma54 = g_oma.oma54t
        LET g_oma.oma56 = g_oma.oma56t
     ELSE
        LET g_oma.oma54 = g_oma.oma54t/(1+g_oma.oma211/100)
        LET g_oma.oma56 = g_oma.oma56t/(1+g_oma.oma211/100)
     END IF
     LET g_oma.oma54x = g_oma.oma54t - g_oma.oma54
     LET g_oma.oma56x = g_oma.oma56t - g_oma.oma56
     CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54
     CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56
     CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x
     CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t
     LET g_oma.oma55 = 0
     LET g_oma.oma57 = 0
     LET g_oma.omaconf = 'Y'
     LET g_oma.omavoid = 'N'
     LET g_oma.omauser = g_user
     LET g_oma.omagrup = g_grup
     LET g_oma.oma64 = '0'
     LET g_oma.oma65 = '1'
     LET g_oma.omaoriu = g_user 
     LET g_oma.omaorig = g_grup
     IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
     IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
     IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF
     INSERT INTO oma_file VALUES(g_oma.*)
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        LET g_success = 'N'
        CALL s_errmsg('oma01',g_oma.oma01,'ins oma',SQLCA.sqlcode,1)       #FUN-B80072    ADD
        ROLLBACK WORK
       # CALL s_errmsg('oma01',g_oma.oma01,'ins oma',SQLCA.sqlcode,1)      #FUN-B80072    MARK
     END IF

     CALL s_ar_oox03(g_oma.oma01) RETURNING l_net
     LET l_omc.omc01 = g_oma.oma01
     LET l_omc.omc02 = 1
     LET l_omc.omc03 = g_oma.oma32
     LET l_omc.omc04 = g_oma.oma11
     LET l_omc.omc05 = g_oma.oma12
     LET l_omc.omc06 = g_oma.oma24
     LET l_omc.omc07 = g_oma.oma60
     LET l_omc.omc08 = g_oma.oma54t
     LET l_omc.omc09 = g_oma.oma56t
     LET l_omc.omc10 = 0
     LET l_omc.omc11 = 0
     LET l_omc.omc12 = g_oma.oma10
     LET l_omc.omc13 = l_omc.omc09-l_omc.omc11+l_net
     LET l_omc.omc14 = 0
     LET l_omc.omc15 = 0
     CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08
     CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09
     CALL cl_digcut(l_omc.omc13,g_azi04) RETURNING l_omc.omc13

     LET l_omc.omclegal = g_legal
     INSERT INTO omc_file VALUES(l_omc.*)
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       LET g_success = 'N'
       CALL s_errmsg('omc01',l_omc.omc01,'ins omc',SQLCA.sqlcode,1)
     END IF

     UPDATE oob_file SET oob06 = g_oma.oma01               #單據回寫oob06
       WHERE oob01 = b_oob.oob01 AND oob02 = b_oob.oob02
     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
        LET g_success = 'N'
        CALL s_errmsg('oob01',g_oma.oma01,'upd oob06',SQLCA.sqlcode,1)
     END IF
  END IF
END FUNCTION

#TQC-AC0127 add
#FUN-B80072

# Prog. Version..: '5.10.00-08.01.04(00002)'     #
#
# Pattern name...: saxdp201.4gl
# Descriptions...: 集團間銷售系統成本更新作業
# Date & Author..: 04/03/09 By Carrier
# Modify.........: No.FUN-610018 06/01/12 By ice 新增含稅總金額pmm40t
# Modify.........: No:FUN-680108 06/08/29 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No:CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改


DATABASE ds

GLOBALS "../../config/top.global"

#模組變數(Module Variables)
DEFINE
    g_adf    RECORD LIKE adf_file.*,
    g_adg    RECORD LIKE adg_file.*,
    tm       RECORD
             yy     LIKE type_file.num5,   #No.FUN-680108 SMALLINT
             mm     LIKE type_file.num5    #No.FUN-680108 SMALLINT
             END RECORD,
    g_chr    LIKE type_file.chr1,          #No.FUN-680108 VARCHAR(01)
     g_sql    string,                                                #No:FUN-580092 HCN
    p_dbs    LIKE azp_file.azp03,
    g_flag   LIKE type_file.chr1           #No.FUN-680108 VARCHAR(01)

FUNCTION p201(p_argv1,p_argv2,p_argv3,p_argv4,p_argv5)
DEFINE p_argv1  RECORD LIKE adf_file.*,
       p_argv2  RECORD LIKE adg_file.*,
       p_argv3  LIKE type_file.num5,       #No.FUN-680108 SMALLINT
       p_argv4  LIKE type_file.num5,       #No.FUN-680108 SMALLINT
       p_argv5  LIKE type_file.chr1        #No.FUN-680108 VARCHAR(01)

    IF cl_null(p_argv1.adf01) OR cl_null(p_argv2.adg02) THEN
       CALL cl_err('parameter error',SQLCA.sqlcode,0)
       EXIT PROGRAM
    END IF
    LET g_adf.*=p_argv1.*
    LET g_adg.*=p_argv2.*
    LET tm.yy = p_argv3
    LET tm.mm = p_argv4
    LET g_chr = p_argv5
    CALL p201_adg_1(g_adf.*,g_adg.*)
    IF g_success = 'N' THEN RETURN END IF
    SELECT * INTO g_adf.* FROM adf_file WHERE adf01=g_adf.adf01
    SELECT * INTO g_adg.* FROM adg_file WHERE adg01=g_adg.adg01 AND adg02=g_adg.adg02
    CASE g_adf.adf00
         WHEN '2' CALL p201_adg_2(g_adf.*,g_adg.*)
         WHEN '3' CALL p201_adg_3(g_adf.*,g_adg.*)
    END CASE
END FUNCTION

FUNCTION p201_adi(p_dbs,p_adg,p_adf)
DEFINE   p_adf    RECORD LIKE adf_file.*,
         p_adg    RECORD LIKE adg_file.*,
         p_dbs    LIKE azp_file.azp03

      LET g_sql=" SELECT ",p_dbs CLIPPED,".adi_file.* FROM ",p_dbs CLIPPED,".",
                "        adi_file,",p_dbs CLIPPED,".adh_file",
                "  WHERE adi03 = '",p_adg.adg01,"'",
                "    AND adi04 =  ",p_adg.adg02,
                "    AND adi01 = adh01",
                "    AND adh00 = '",p_adf.adf00,"'"
      PREPARE p201_prepare1 FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare adi',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
END FUNCTION

FUNCTION p201_adg_1(p_adf,p_adg)
DEFINE   p_adf    RECORD LIKE adf_file.*,
         p_adg    RECORD LIKE adg_file.*,
         l_adi    RECORD LIKE adi_file.*,
         l_ccc23  LIKE ccc_file.ccc23,
         l_adb06  LIKE adb_file.adb06

      SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adg.adg09
      IF SQLCA.sqlcode THEN
         CALL cl_err('select azp',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
      END IF

      IF g_chr='1' THEN
         IF p_adg.adg13 MATCHES '[124]' THEN    #axdp201
            SELECT ccc23 INTO l_ccc23 FROM ccc_file
             WHERE ccc01 = p_adg.adg05
               AND ccc02 = tm.yy
               AND ccc03 = tm.mm
            IF cl_null(l_ccc23) THEN LET l_ccc23 = 0 END IF
            LET p_adg.adg15 = l_ccc23
            LET p_adg.adg16 = p_adg.adg15 * p_adg.adg12
            IF cl_null(p_adg.adg15) THEN LET p_adg.adg15 = 0 END IF
            IF cl_null(p_adg.adg16) THEN LET p_adg.adg16 = 0 END IF
            UPDATE adg_file SET adg15=p_adg.adg15,adg16=p_adg.adg16
             WHERE adg01 = p_adg.adg01
               AND adg02 = p_adg.adg02
            IF SQLCA.sqlcode THEN
               CALL cl_err('update adg_1',SQLCA.sqlcode,0)
               LET g_success = 'N' RETURN
            END IF
 
            CASE p_adf.adf00
                 WHEN '2' SELECT adb06 INTO l_adb06 FROM adb_file
                           WHERE adb01=g_plant AND adb02=p_adg.adg09
                 WHEN '3' SELECT adb06 INTO l_adb06 FROM adb_file
                           WHERE adb02=g_plant AND adb01=p_adg.adg09
            END CASE
            LET g_sql=" UPDATE ",p_dbs CLIPPED,".adi_file",
                      "    SET adi13 = ?, adi14 = ?",
                      "  WHERE adi01 = ? AND adi02 = ?"
            PREPARE p201_prepare2 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('prepare adi',SQLCA.sqlcode,0)
               LET g_success = 'N' RETURN
            END IF
            CALL p201_adi(p_dbs,p_adg.*,p_adf.*)
            DECLARE adg_adi_1 CURSOR FOR p201_prepare1
            IF SQLCA.sqlcode THEN
               CALL cl_err('select adi',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            FOREACH adg_adi_1 INTO l_adi.*
               IF STATUS THEN
                  CALL cl_err('adg1_adi',STATUS,0)
                  LET g_success='N' RETURN
               END IF
               CASE l_adi.adi11
                    WHEN '1' LET l_adi.adi13=p_adg.adg15
                    WHEN '2' LET l_adi.adi13=p_adg.adg15*l_adb06
                    WHEN '4' LET l_adi.adi13=p_adg.adg15*p_adg.adg14
               END CASE
               IF cl_null(l_adi.adi13) THEN LET l_adi.adi13 = 0 END IF
               LET l_adi.adi14=l_adi.adi13*l_adi.adi10
               IF cl_null(l_adi.adi14) THEN LET l_adi.adi14 = 0 END IF
               EXECUTE p201_prepare2 USING l_adi.adi13,l_adi.adi14,
                                           l_adi.adi01,l_adi.adi02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('update adi_1',SQLCA.sqlcode,0)
                  LET g_success = 'N' RETURN
               END IF
            END FOREACH
         END IF
      END IF
      IF g_chr='2' THEN
         IF p_adg.adg13='3' THEN  #axdt200
            LET g_sql=" UPDATE ",p_dbs CLIPPED,".adi_file",
                      "    SET adi13 = ?, adi14 = ?",
                      "  WHERE adi01 = ? AND adi02 = ?"
            PREPARE p201_prepare15 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('prepare adi',SQLCA.sqlcode,0)
               LET g_success = 'N' RETURN
            END IF
            CALL p201_adi(p_dbs,p_adg.*,p_adf.*)
            DECLARE adg_adi_12 CURSOR FOR p201_prepare1
            IF SQLCA.sqlcode THEN
               CALL cl_err('select adi',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            FOREACH adg_adi_12 INTO l_adi.*
               IF STATUS THEN
                  CALL cl_err('adg1_adi',STATUS,0)
                  LET g_success='N' RETURN
               END IF
               LET l_adi.adi11=p_adg.adg13
               LET l_adi.adi13=p_adg.adg15
               LET l_adi.adi14=l_adi.adi10 * l_adi.adi13
               IF cl_null(l_adi.adi13) THEN LET l_adi.adi13 = 0 END IF
               IF cl_null(l_adi.adi14) THEN LET l_adi.adi14 = 0 END IF
               EXECUTE p201_prepare15 USING l_adi.adi13,l_adi.adi14,
                                            l_adi.adi01,l_adi.adi02
               IF SQLCA.sqlcode THEN
                  CALL cl_err('update adi_1',SQLCA.sqlcode,0)
                  LET g_success = 'N' RETURN
               END IF
            END FOREACH
         END IF
      END IF
END FUNCTION

FUNCTION p201_adg_2(p_adf,p_adg)
DEFINE   p_adf    RECORD LIKE adf_file.*,
         p_adg    RECORD LIKE adg_file.*,
         l_pmn    RECORD LIKE pmn_file.*,
         l_pmm    RECORD LIKE pmm_file.*,
         l_adi    RECORD LIKE adi_file.*,
         l_ogb    RECORD LIKE ogb_file.*,
         l_oga    RECORD LIKE oga_file.*,
         l_rva    RECORD LIKE rva_file.*,
         l_rvb    RECORD LIKE rvb_file.*,
         l_rvv    RECORD LIKE rvv_file.*,
         l_pmm42  LIKE pmm_file.pmm42,
         l_pmm43  LIKE pmm_file.pmm43,
         l_pmm22  LIKE pmm_file.pmm22,
         l_pmm40  LIKE pmm_file.pmm40,  #No.FUN-610018
         l_pmm40t LIKE pmm_file.pmm40t  #No.FUN-610018

      SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adg.adg09
      IF SQLCA.sqlcode THEN
         CALL cl_err('select azp',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
      END IF
#########update pmm_file,pmn_file#########
      LET g_sql=" SELECT * FROM ",p_dbs CLIPPED,".",
                "        pmn_file,",p_dbs CLIPPED,".pmm_file",
                "  WHERE pmn24 = '",p_adg.adg01,"'",
                "    AND pmn25 = '",p_adg.adg02,"'",
                "    AND pmn01 = pmm01 AND pmm09 = '",g_plant,"'"
      PREPARE p201_prepare3 FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare pmn',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      DECLARE adg_2_pmn SCROLL CURSOR FOR p201_prepare3
      IF SQLCA.sqlcode THEN
         CALL cl_err('select pmn',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      OPEN adg_2_pmn
      FETCH adg_2_pmn INTO l_pmn.*,l_pmm.*
      IF cl_null(l_pmm.pmm42) THEN LET l_pmm.pmm42 = 0 END IF
      IF cl_null(l_pmm.pmm43) THEN LET l_pmm.pmm43 = 0 END IF
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 =l_pmm.pmm22     #No.CHI-6A0004 
      LET l_pmn.pmn31 =p_adg.adg15
      IF cl_null(l_pmn.pmn31) THEN LET l_pmn.pmn31 = 0 END IF
      LET l_pmn.pmn31t=l_pmn.pmn31*(1+l_pmm.pmm43/100)
      IF cl_null(l_pmn.pmn31t) THEN LET l_pmn.pmn31t = 0 END IF
      LET l_pmn.pmn44 =l_pmn.pmn31*l_pmm.pmm42
      IF cl_null(l_pmn.pmn44) THEN LET l_pmn.pmn44 = 0 END IF
      LET l_pmn.pmn44 = cl_digcut(l_pmn.pmn44,t_azi04)          #No.CHI-6A0004   
      LET g_sql=" UPDATE ",p_dbs CLIPPED,".pmn_file",
                "    SET pmn31 = ?,pmn31t = ?,pmn44 = ?",
                "  WHERE pmn01 = ? AND pmn02 = ?"
      PREPARE p201_prepare4 FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare pmn',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      EXECUTE p201_prepare4 USING l_pmn.pmn31,l_pmn.pmn31t,
                                  l_pmn.pmn44,l_pmn.pmn01,l_pmn.pmn02
      IF SQLCA.sqlcode THEN
         CALL cl_err('update pmn_2',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
      END IF
      #No.FUN-610018 --start--
      LET g_sql=" SELECT SUM(pmn31*pmn20),SUM(pmn31t*pmn20) ",
                "   FROM ",p_dbs CLIPPED,".pmn_file",
                "  WHERE pmn01='",l_pmn.pmn01,"'"
      PREPARE p201_prepmn FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare pmn',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      EXECUTE p201_prepmn INTO l_pmm40,l_pmm40t
      LET l_pmm40 = cl_digcut(l_pmm40,t_azi04)        #No.CHI-6A0004           
      LET l_pmm40t = cl_digcut(l_pmm40t,t_azi04)      #No.CHI-6A0004 
      LET g_sql=" UPDATE ",p_dbs CLIPPED,".pmm_file SET pmm40 = ",l_pmm40,", ",
                "                                       pmm40t= ",l_pmm40t," ",
                "                                 WHERE pmm01 = '",l_pmm.pmm01,"'"
      #LET g_sql=" UPDATE ",p_dbs CLIPPED,".pmm_file SET pmm40 = (",
      #          " SELECT SUM(pmn31*pmn20) FROM ",p_dbs CLIPPED,".pmn_file",
      #          "  WHERE pmn01='",l_pmn.pmn01,"')",
      #          "  WHERE pmm01='",l_pmm.pmm01,"'"
      #No.FUN-610018 --end--
      PREPARE p201_prepare5 FROM g_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare pmm',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      EXECUTE p201_prepare5
      IF SQLCA.sqlcode THEN
         CALL cl_err('update pmm_2',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
      END IF
      CALL p201_adi(p_dbs,p_adg.*,p_adf.*)
      DECLARE adg_adi_2 CURSOR FOR p201_prepare1
      IF SQLCA.sqlcode THEN
         CALL cl_err('select adi',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      FOREACH adg_adi_2 INTO l_adi.*
         IF STATUS THEN
            CALL cl_err('adg2_adi',STATUS,0)
            LET g_success='N' RETURN
         END IF
         IF cl_null(l_adi.adi13) THEN LET l_adi.adi13=0 END IF
         IF cl_null(l_adi.adi14) THEN LET l_adi.adi14=0 END IF
#########update oga_file,ogb_file#########
         SELECT oga_file.*,ogb_file.* INTO l_oga.*,l_ogb.*
           FROM oga_file,ogb_file
          WHERE ogb31=l_adi.adi01 AND ogb32=l_adi.adi02
            AND oga01=ogb01 AND oga03=p_adg.adg09
         SELECT * FROM omb_file WHERE omb31=l_ogb.ogb01 AND omb32=l_ogb.ogb03
         IF STATUS=100 THEN    #出貨單未有應收帳款
            SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 =l_oga.oga23         #No.CHI-6A0004
            LET l_ogb.ogb13 =l_adi.adi13
            LET l_ogb.ogb14 =l_adi.adi14
            IF cl_null(l_ogb.ogb13) THEN LET l_ogb.ogb13=0 END IF
            IF cl_null(l_ogb.ogb14) THEN LET l_ogb.ogb14=0 END IF
            LET l_ogb.ogb14t=l_ogb.ogb14*(1+l_oga.oga211/100)
            IF cl_null(l_ogb.ogb14t) THEN LET l_ogb.ogb14t=0 END IF
            UPDATE ogb_file SET *=l_ogb.*
             WHERE ogb01=l_ogb.ogb01 AND ogb03=l_ogb.ogb03
            IF SQLCA.sqlcode THEN
               CALL cl_err('update ogb',SQLCA.sqlcode,0)
               LET g_success='N' RETURN
            END IF
            SELECT SUM(ogb14) INTO l_oga.oga50 FROM ogb_file
             WHERE ogb01=l_ogb.ogb01
            IF cl_null(l_oga.oga50) THEN LET l_oga.oga50=0 END IF
            LET l_oga.oga501=l_oga.oga50*l_oga.oga24
            IF cl_null(l_oga.oga501) THEN LET l_oga.oga501=0 END IF
            LET l_oga.oga501=cl_digcut(l_oga.oga501,t_azi04)       #No.CHI-6A0004
            LET l_oga.oga51 =l_oga.oga50*(1+l_oga.oga211/100)
            IF cl_null(l_oga.oga51) THEN LET l_oga.oga51=0 END IF
            LET l_oga.oga511=l_oga.oga51*l_oga.oga24
            IF cl_null(l_oga.oga511) THEN LET l_oga.oga511=0 END IF
            LET l_oga.oga511=cl_digcut(l_oga.oga511,t_azi04)       #No.CHI-6A0004  
            UPDATE oga_file SET *=l_oga.*
             WHERE oga01=l_oga.oga01
            IF SQLCA.sqlcode THEN
               CALL cl_err('update oga',SQLCA.sqlcode,0)
               LET g_success='N' RETURN
            END IF
         END IF
#########update rvb_file#########
         LET g_sql=" SELECT * FROM ",p_dbs CLIPPED,".",
                   "        rva_file,",p_dbs CLIPPED,".rvb_file",
                   "  WHERE rva07 = '",l_adi.adi01,"'",
                   "    AND rvb32 = '",l_adi.adi02,"'",
                   "    AND rva01 = rvb01"
         PREPARE p201_prepare6 FROM g_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('prepare rva,rvb',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         DECLARE adg_2_rvb SCROLL CURSOR FOR p201_prepare6
         IF SQLCA.sqlcode THEN
            CALL cl_err('select rva,rvb',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         OPEN adg_2_rvb
         FETCH adg_2_rvb INTO l_rva.*,l_rvb.*
         LET g_sql=" UPDATE ",p_dbs CLIPPED,".rvb_file SET rvb10 = ? ",
                   "  WHERE rvb01=? AND rvb02=?"
         PREPARE p201_prepare7 FROM g_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('prepare rvb',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         EXECUTE p201_prepare7 USING l_adi.adi13,l_rvb.rvb01,l_rvb.rvb02
         IF SQLCA.sqlcode THEN
            CALL cl_err('update rvb_2',SQLCA.sqlcode,0)
            LET g_success = 'N' RETURN
         END IF
#########update rvv_file#########
         LET g_sql=" SELECT ",p_dbs CLIPPED,".rvv_file.* FROM ",p_dbs CLIPPED,".",
                   "        rvu_file,",p_dbs CLIPPED,".rvv_file",
                   "  WHERE rvu02 = '",l_rva.rva01,"'",
                   "    AND rvv05 =  ",l_rvb.rvb02,
                   "    AND rvu01 = rvv01"
         PREPARE p201_prepare8 FROM g_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('prepare rvu,rvv',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         DECLARE adg_2_rvv SCROLL CURSOR FOR p201_prepare8
         IF SQLCA.sqlcode THEN
            CALL cl_err('select rvu,rvv',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         OPEN adg_2_rvv
         FETCH adg_2_rvv INTO l_rvv.*
         LET g_sql =" SELECT * FROM ",p_dbs CLIPPED,".apb_file",
                    "  WHERE apb21 = '",l_rvv.rvv01,"'",
                    "    AND apb22 =  ",l_rvv.rvv02
         PREPARE p201_prepare9 FROM g_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('prepare apb',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         EXECUTE p201_prepare9
         IF STATUS=100 THEN     #入庫未有應付帳款
            LET g_sql=" UPDATE ",p_dbs CLIPPED,".rvv_file ",
                      "    SET rvv38 = ?,    rvv39 = ? ",
                      "  WHERE rvv01 = ? AND rvv02 = ? "
            PREPARE p201_prepare10 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('prepare rvv',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            EXECUTE p201_prepare10 USING l_adi.adi13,l_adi.adi14,
                                         l_rvv.rvv01,l_rvv.rvv02
            IF SQLCA.sqlcode THEN
               CALL cl_err('update rvv_2',SQLCA.sqlcode,0)
               LET g_success = 'N' RETURN
            END IF
         END IF
      END FOREACH
END FUNCTION

FUNCTION p201_adg_3(p_adf,p_adg)
DEFINE   p_adf    RECORD LIKE adf_file.*,
         p_adg    RECORD LIKE adg_file.*,
         l_adi    RECORD LIKE adi_file.*,
         l_oha    RECORD LIKE oha_file.*,
         l_ohb    RECORD LIKE ohb_file.*,
         l_adi14  LIKE adi_file.adi14
 
      SELECT azp03 INTO p_dbs FROM azp_file WHERE azp01 = p_adg.adg09
      IF SQLCA.sqlcode THEN
         CALL cl_err('select azp',SQLCA.sqlcode,0)
         LET g_success = 'N' RETURN
      END IF
      UPDATE rvv_file SET rvv38=p_adg.adg15,rvv39=p_adg.adg16
       WHERE rvv36=p_adg.adg01 AND rvv37=p_adg.adg02
      IF SQLCA.sqlcode THEN
         CALL cl_err('update rvv',SQLCA.sqlcode,0)
         LET g_success='N' RETURN
      END IF
      CALL p201_adi(p_dbs,p_adg.*,p_adf.*)
      DECLARE adg_adi_3 CURSOR FOR p201_prepare1
      IF SQLCA.sqlcode THEN
         CALL cl_err('select adi',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      FOREACH adg_adi_3 INTO l_adi.*
         IF STATUS THEN
            CALL cl_err('adg3_adi',STATUS,0)
            LET g_success='N' RETURN
         END IF
         LET g_sql=" SELECT * FROM ",p_dbs CLIPPED,".",
                   "        oha_file,",p_dbs CLIPPED,".ohb_file",
                   "  WHERE ohb33 = '",l_adi.adi01,"'",
                   "    AND ohb34 = '",l_adi.adi02,"'",
                   "    AND oha01 = ohb01"
         PREPARE p201_prepare11 FROM g_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('prepare oha,ohb',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         DECLARE adg_2_ohb SCROLL CURSOR FOR p201_prepare11
         IF SQLCA.sqlcode THEN
            CALL cl_err('select oha,ohb',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         OPEN adg_2_ohb
         FETCH adg_2_ohb INTO l_oha.*,l_ohb.*
         LET g_sql =" SELECT * FROM ",p_dbs CLIPPED,".omb_file",
                    "  WHERE omb31 = '",l_ohb.ohb01,"'",
                    "    AND omb32 =  ",l_ohb.ohb03
         PREPARE p201_prepare12 FROM g_sql
         IF SQLCA.sqlcode THEN
            CALL cl_err('prepare omb',SQLCA.sqlcode,0)
            LET g_success = 'N'
            RETURN
         END IF
         EXECUTE p201_prepare12
         IF STATUS=100 THEN     #銷退未有應收帳款
            LET l_ohb.ohb13 =l_adi.adi13
            LET l_ohb.ohb14 =l_adi.adi14
            IF cl_null(l_ohb.ohb13) THEN LET l_ohb.ohb13=0 END IF
            IF cl_null(l_ohb.ohb14) THEN LET l_ohb.ohb14=0 END IF
            LET l_ohb.ohb14t=l_ohb.ohb14*(1+l_oha.oha21/100)
            IF cl_null(l_ohb.ohb14t) THEN LET l_ohb.ohb14t=0 END IF
            LET g_sql=" UPDATE ",p_dbs CLIPPED,".ohb_file ",
                      "    SET ohb13 = ?,ohb14=?,ohb14t=?",
                      "  WHERE ohb01=? AND ohb03=?"
            PREPARE p201_prepare13 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('prepare ohb',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            EXECUTE p201_prepare13 USING l_ohb.ohb13,l_ohb.ohb14,
                                   l_ohb.ohb14t,l_ohb.ohb01,l_ohb.ohb03
            IF SQLCA.sqlcode THEN
               CALL cl_err('update ohb_3',SQLCA.sqlcode,0)
               LET g_success = 'N' RETURN
            END IF
            #l_adi14有可能是空值,而oha50是not null的field
            LET g_sql=" SELECT SUM(adi14) FROM ",p_dbs CLIPPED,
                      "   .adi_file WHERE adi01='",l_adi.adi01,"'"
            PREPARE p201_prepare16 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('prepare adi',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            EXECUTE p201_prepare16 INTO l_adi14
            IF SQLCA.sqlcode THEN
               CALL cl_err('select adi_3',SQLCA.sqlcode,0)
               LET g_success = 'N' RETURN
            END IF
            IF cl_null(l_adi14) THEN LET l_adi14=0 END IF
            LET g_sql=" UPDATE ",p_dbs CLIPPED,".oha_file ",
                      "    SET oha53=0,oha54=0,oha50=",l_adi14,
                      "  WHERE oha01='",l_ohb.ohb01,"'"
            PREPARE p201_prepare14 FROM g_sql
            IF SQLCA.sqlcode THEN
               CALL cl_err('prepare oha',SQLCA.sqlcode,0)
               LET g_success = 'N'
               RETURN
            END IF
            EXECUTE p201_prepare14
            IF SQLCA.sqlcode THEN
               CALL cl_err('update oha_3',SQLCA.sqlcode,0)
               LET g_success = 'N' RETURN
            END IF
         END IF
      END FOREACH
END FUNCTION
#Patch....NO:TQC-610037 <001> #

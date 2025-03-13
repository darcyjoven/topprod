# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_iqctype.4gl
# Descriptions...: 將驗收單之狀況碼轉換為狀況說明
# Date & Author..: 92/12/03 By Apple
# Usage..........: CALL s_iqctype(p_code) RETURNING l_str
# Input Parameter: p_code  狀況碼
# Return code....: l_str   狀況說明
# Modify.........: No.FUN-680147 06/09/04 By Czl  類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-BC0104 12/01/11 By xujing 新增一支程式來會寫qco20的值 
#                                12/01/17 By xianghui 新增FUNCTION s_iqctype_rvv(p_rvv01,p_rvv02),
#                                                         FUNCTION s_iqctype_inb(p_inb01,p_inb03)
#                                                         FUNCTION s_iqctype_sfv(p_sfv01,p_sfv03)
#                                                         FUNCTION s_iqctype_ksd(p_ksd01,p_ksd03)
#                                                         FUNCTION s_qcl05_sel(p_qcl01)
# Modify.........: No.MOD-C30130 12/03/09 By lixh1 單位換算時來源單位和目的單位的位置顛倒
# Modify.........: No.MOD-C30149 12/03/15 By lixh1 若asms250的『採購入庫允收數量與IQC量勾稽』未勾選,則s_iqctype不做數量的檢查 
# Modify.........: No.FUN-C40016 12/04/05 By xianghui 撈取數量時應排除作廢掉的數量

DATABASE ds      #No.FUN-680147 
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
FUNCTION s_iqctype(p_code)
   DEFINE  p_code   LIKE type_file.chr2,         #No.FUN-680147 VARCHAR(2)
           l_str    LIKE cob_file.cob08        #No.FUN-680147 VARCHAR(10)
 
   LET l_str = " "
   CASE p_code
     WHEN '10' CALL cl_getmsg('mfg3264',g_lang) RETURNING l_str
     WHEN '20' CALL cl_getmsg('mfg3265',g_lang) RETURNING l_str
     WHEN '30' CALL cl_getmsg('mfg3266',g_lang) RETURNING l_str
     OTHERWISE EXIT CASE
   END CASE
   RETURN l_str
END FUNCTION

#FUN-BC0104---add---str
#p_type='1' :收貨單 入庫 p_type='2'：工單完工入庫 OR RUNCARD完工入库  p_type='3':拆件式工单完工入库 p_type='4':杂项收料									

FUNCTION s_iqctype_upd_qco20(p_qco01,p_qco02,p_qco05,p_qco04,p_type)		
 DEFINE l_cnt    LIKE type_file.num5,
        p_qco01  LIKE qco_file.qco01,
        p_qco02  LIKE qco_file.qco02,
        p_qco05  LIKE qco_file.qco05,
        p_qco04  LIKE qco_file.qco04,
        p_type   LIKE type_file.chr1,
        l_rvv17  LIKE rvv_file.rvv17,
        l_unit   LIKE rvv_file.rvv35,
        l_i      LIKE type_file.num5,
        l_fac    LIKE rvv_file.rvv35_fac,
        l_qco06  LIKE qco_file.qco06,
        l_qco10  LIKE qco_file.qco10,
        l_sql    STRING

   IF cl_null(p_qco01) OR cl_null(p_qco02) OR cl_null(p_qco05) OR cl_null(p_qco04) THEN RETURN TRUE END IF									
   LET l_cnt=0									
								
   SELECT COUNT(*) INTO l_cnt FROM qco_file									
    WHERE qco01=p_qco01 AND qco02=p_qco02 AND qco05=p_qco05 AND qco04=p_qco04									
   IF l_cnt=0 THEN RETURN TRUE END IF									
   CASE p_type									
    WHEN '1'									
        SELECT sum(rvv17) INTO l_rvv17 FROM rvv_file,rvu_file      #FUN-C40016 add rvu_file
         WHERE rvv04=p_qco01 AND rvv05=p_qco02 AND rvv45=p_qco05 AND rvv47=p_qco04
           AND rvuconf <>'X' AND rvv01 = rvu01                     #FUN-C40016
        LET l_sql = "SELECT DISTINCT rvv35 FROM rvv_file WHERE rvv04='",p_qco01 CLIPPED,
                    "' AND rvv05=",p_qco02 CLIPPED," AND rvv45=",p_qco05 CLIPPED,
                    "  AND rvv47=",p_qco04 CLIPPED 
    WHEN '2' 									
        SELECT sum(sfv09) INTO l_rvv17 FROM sfv_file,sfu_file      #FUN-C40016 add sfu_file
         WHERE sfv17=p_qco01 AND sfv47=p_qco04	
           AND sfu01 = sfv01 AND sfuconf <> 'X'                    #FUN-C40016
        LET l_sql = "SELECT DISTINCT sfv08 FROM sfv_file WHERE sfv17='",p_qco01 CLIPPED,
                    "' AND sfv47=",p_qco04 CLIPPED								
    WHEN '3' 									
        SELECT sum(ksd09) INTO l_rvv17 FROM ksd_file,ksc_file     #FUN-C40016 add ksc_file
         WHERE ksd17=p_qco01 AND ksd47=p_qco04
           AND ksc01 = ksd01 AND kscconf <> 'X'                   #FUN-C40016
        LET l_sql = "SELECT DISTINCT ksd08 FROM ksd_file WHERE ksd17='",p_qco01 CLIPPED,
                    "' AND ksd47=",p_qco04 CLIPPED
    WHEN '4' 					
        SELECT sum(inb09) INTO l_rvv17 FROM inb_file,ina_file     #FUN-C40016 add ina_file
         WHERE inb44=p_qco01 AND inb45=p_qco02 AND inb48=p_qco05 AND inb47=p_qco04
           AND ina01 = inb01 AND inaconf <>'X'                    #FUN-C40016
        LET l_sql = "SELECT DISTINCT inb08 FROM inb_file WHERE inb44='",p_qco01 CLIPPED,
                    "' AND inb45=",p_qco02 CLIPPED," AND inb48=",p_qco05 CLIPPED,
                    "  AND inb47=",p_qco04 CLIPPED
    WHEN '5'
        SELECT sum(rvv87) INTO l_rvv17 FROM rvv_file,rvu_file      #FUN-C40016 add rvu_file
         WHERE rvv04=p_qco01 AND rvv05=p_qco02 AND rvv45=p_qco05 AND rvv47=p_qco04
           AND rvuconf <>'X' AND rvv01 = rvu01                     #FUN-C40016
        LET l_sql = "SELECT DISTINCT rvv86 FROM rvv_file WHERE rvv04='",p_qco01 CLIPPED,
                    "' AND rvv05=",p_qco02 CLIPPED," AND rvv45=",p_qco05 CLIPPED,
                    "  AND rvv47=",p_qco04 CLIPPED
    WHEN '6'
        SELECT sum(inb1005) INTO l_rvv17 FROM inb_file,ina_file     #FUN-C40016 add ina_file
         WHERE inb44=p_qco01 AND inb45=p_qco02 AND inb48=p_qco05 AND inb47=p_qco04
           AND ina01 = inb01 AND inaconf <>'X'                    #FUN-C40016
        LET l_sql = "SELECT DISTINCT inb1004 FROM inb_file WHERE inb44='",p_qco01 CLIPPED,
                    "' AND inb45=",p_qco02 CLIPPED," AND inb48=",p_qco05 CLIPPED,
                    "  AND inb47=",p_qco04 CLIPPED
   END CASE	
   IF cl_null(l_rvv17) THEN LET l_rvv17=0 END IF
   PREPARE unit_pre FROM l_sql
   DECLARE unit_cur SCROLL CURSOR FOR unit_pre
   OPEN unit_cur
   FETCH FIRST unit_cur INTO l_unit
   SELECT qco06,qco10 INTO l_qco06,l_qco10 FROM qco_file
         WHERE qco01=p_qco01 AND qco02=p_qco02 AND qco05=p_qco05 AND qco04=p_qco04
#  CALL s_umfchk(l_qco06,l_qco10,l_unit)   #單位一換算率  MOD-C30130 mark
   CALL s_umfchk(l_qco06,l_unit,l_qco10)   #MOD-C30130
          RETURNING l_i,l_fac
   IF l_i THEN LET l_fac=1 END IF								
   UPDATE qco_file SET qco20=l_rvv17*l_fac									
    WHERE qco01=p_qco01 AND qco02=p_qco02 AND qco05=p_qco05 AND qco04=p_qco04									
   IF SQLCA.SQLCODE THEN 									
      CALL cl_err3("upd","qco_file",p_qco01,"",SQLCA.sqlcode,"","update qco",1) 
      RETURN FALSE									
   END IF									
   IF g_sma.sma886[8,8]='N' AND p_type MATCHES'[15]' THEN      #MOD-C30149
   ELSE           #MOD-C30149                                 
      LET l_cnt=0									
      SELECT COUNT(*) INTO l_cnt FROM qco_file									
       WHERE qco01=p_qco01 AND qco02=p_qco02 AND qco05=p_qco05 AND qco04=p_qco04 									
         AND (qco11<qco20 OR qco20<0)									
      IF l_cnt > 0 THEN									
         CALL cl_err('','sub-535',1)					
         RETURN FALSE									
      END IF						
   END IF       #MOD-C30149 			
   RETURN TRUE									
END FUNCTION									
#FUN-BC0104---add---end
#FUN-BC0104---add---str--xianghui--
FUNCTION s_iqctype_rvv(p_rvv01,p_rvv02)
DEFINE l_rvv04  LIKE rvv_file.rvv04,
       l_rvv05  LIKE rvv_file.rvv05,
       l_rvv45  LIKE rvv_file.rvv45,
       l_rvv46  LIKE rvv_file.rvv46,
       l_rvv47  LIKE rvv_file.rvv47,
       p_rvv01  LIKE rvv_file.rvv01,
       p_rvv02  LIKE rvv_file.rvv02

   SELECT rvv04,rvv05,rvv45,rvv46,rvv47 INTO l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47 
     FROM rvv_file
    WHERE rvv01=p_rvv01 AND rvv02=p_rvv02
   IF cl_null(l_rvv47) THEN
      RETURN l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,'N'
   END IF
   RETURN l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,'Y'
END FUNCTION

FUNCTION s_iqctype_inb(p_inb01,p_inb03)
DEFINE l_inb46  LIKE inb_file.inb46,
       l_inb47  LIKE inb_file.inb47,
       l_inb48  LIKE inb_file.inb48,
       l_inb44  LIKE inb_file.inb44,
       l_inb45  LIKE inb_file.inb45,
       p_inb01  LIKE inb_file.inb01,
       p_inb03  LIKE inb_file.inb03

   SELECT inb44,inb45,inb46,inb47,inb48 INTO l_inb44,l_inb45,l_inb46,l_inb47,l_inb48
     FROM inb_file
    WHERE inb01 = p_inb01 AND inb03 = p_inb03
   IF cl_null(l_inb47) THEN 
      RETURN l_inb44,l_inb45,l_inb46,l_inb48,l_inb47,'N'
   END IF
   RETURN l_inb44,l_inb45,l_inb46,l_inb48,l_inb47,'Y'
END FUNCTION

FUNCTION s_iqctype_sfv(p_sfv01,p_sfv03)
DEFINE l_sfv17  LIKE sfv_file.sfv17,
       l_sfv47  LIKE sfv_file.sfv47,
       p_sfv01  LIKE sfv_file.sfv01,
       p_sfv03  LIKE sfv_file.sfv03

   SELECT sfv17,sfv47 INTO l_sfv17,l_sfv47
     FROM sfv_file
    WHERE sfv01 = p_sfv01 AND sfv03 = p_sfv03
   IF cl_null(l_sfv47) THEN
      RETURN l_sfv17,l_sfv47,'N'
   END IF
   RETURN l_sfv17,l_sfv47,'Y'
END FUNCTION

FUNCTION s_iqctype_ksd(p_ksd01,p_ksd03)
DEFINE l_ksd17  LIKE ksd_file.ksd17,
       l_ksd47  LIKE ksd_file.ksd47,
       p_ksd01  LIKE ksd_file.ksd01,
       p_ksd03  LIKE ksd_file.ksd03

   SELECT ksd17,ksd47 INTO l_ksd17,l_ksd47
     FROM ksd_file
    WHERE ksd01 = p_ksd01 AND ksd03 = p_ksd03
   IF cl_null(l_ksd47) THEN
      RETURN l_ksd17,l_ksd47,'N'
   END IF
   RETURN l_ksd17,l_ksd47,'Y'
END FUNCTION

FUNCTION s_qcl05_sel(p_qcl01)
DEFINE p_qcl01  LIKE qcl_file.qcl01
DEFINE l_qcl05  LIKE qcl_file.qcl05

   SELECT qcl05 INTO l_qcl05
     FROM qcl_file
    WHERE qcl01 = p_qcl01
   RETURN l_qcl05
END FUNCTION

#FUN-BC0104---add---end--xianghui--

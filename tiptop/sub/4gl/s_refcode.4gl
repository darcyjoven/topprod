# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: s_refcode.4gl
# Descriptions...: 判斷程式代號其出入庫狀況 
# Date & Author..: 93/05/20 By Apple
# Usage..........: CALL s_refcode(p_program.p_tlf026,p_tlf027,p_tlf036,
#                                 p_tlf037,p_tlf14,p_tlf19,p_tlf021,p_tlf022,
#                                 p_tlf023,p_tlf031,p_tlf032,p_tlf033)
#                       RETURNING l_refer1,l_refer2,l_refer3,l_refer4
# Input Parameter: p_program  程式代號
#                  p_tlf026   來源單據編號
#                  p_tlf027   來源單據項次
#                  p_tlf036   目的單據編號
#                  p_tlf037   目的單據項次
#                  p_tlf14    異動原因
#                  p_tlf19    異動廠商/客戶編號
#                  p_tlf021   來源倉庫別
#                  p_tlf022   來源存放位置
#                  p_tlf023   來源批號
#                  p_tlf031   目的倉庫別
#                  p_tlf032   目的存放位置
#                  p_tlf033   目的批號
# Return code....: l_refer1   來源單據編號
#                  l_refer2   製造部門
#                  l_refer3   單號
#                  l_refer4   工單編號
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改 
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_refcode(p_program,p_tlf026,p_tlf027,
                   p_tlf036,p_tlf037,p_tlf14,p_tlf19,
                   p_tlf021,p_tlf022,p_tlf023,
                   p_tlf031,p_tlf032,p_tlf033)
   DEFINE  p_program       LIKE zaa_file.zaa01,        #No.FUN-680147 VARCHAR(10)
           p_tlf026        LIKE tlf_file.tlf026,
           p_tlf027        LIKE tlf_file.tlf027,
           p_tlf036        LIKE tlf_file.tlf036,
           p_tlf037        LIKE tlf_file.tlf037,
           p_tlf14         LIKE tlf_file.tlf14,
           p_tlf19         LIKE tlf_file.tlf19,
           p_tlf021        LIKE tlf_file.tlf021,
           p_tlf022        LIKE tlf_file.tlf022,
           p_tlf023        LIKE tlf_file.tlf023,
           p_tlf031        LIKE tlf_file.tlf031,
           p_tlf032        LIKE tlf_file.tlf032,
           p_tlf033        LIKE tlf_file.tlf033,
           l_item          LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           l_refer1,l_refer2,l_refer3,l_refer4 LIKE tlf_file.tlf026        #No.FUN-680147 VARCHAR(16) #No.FUN-560002          
 
  CASE 
   WHEN  p_program = 'asft230' OR p_program = 'asft240'   
         OR p_program ='apmt2081'
         LET l_refer1 = p_tlf026
         SELECT sfb22,sfb82 
                 INTO l_refer3,l_refer2
                 FROM sfb_file WHERE sfb01=p_tlf026
   WHEN  p_program ='asft610' OR p_program = 'asft620'   
      OR p_program ='asft700' OR p_program = 'asft650'
      OR p_program ='asft801'
 
         LET l_refer1 = p_tlf026
         SELECT sfb22,sfb82 INTO l_refer3,l_refer2
                FROM sfb_file WHERE sfb01=p_tlf026
   WHEN  p_program ='apmt150' OR p_program = 'apmt110'   
      OR p_program ='apmt120' 
         LET l_refer1 = p_tlf026
         LET l_refer2 = p_tlf19
         SELECT rvb04 INTO l_refer3
                      FROM rvb_file 
                     WHERE rvb01=p_tlf026 AND rvb02 =p_tlf027
 
   WHEN  p_program = 'apmt230'
         LET l_refer1 = p_tlf026
         LET l_refer2 = p_tlf19
         SELECT rvb03,rvb04 INTO l_item,l_refer3
                            FROM rvb_file 
                           WHERE rvb01=p_tlf026 AND rvb02 =p_tlf027
         IF l_refer3 IS NOT NULL THEN 
            SELECT pmn41 INTO l_refer4 
                         FROM pmn_file  
                        WHERE pmn01 = l_refer3
                          AND pmn02 = l_item
         END IF
 
   WHEN  p_program ='aimt302' OR p_program = 'aimt312'   
      OR p_program ='aimt307' OR p_program = 'aimt310' 
         LET l_refer1 = p_tlf026 
         LET l_refer2 = p_tlf14
  
   WHEN  p_program ='aimt304' OR p_program = 'aimt305'   
      OR p_program ='aimt314' OR p_program = 'aimt315' 
      OR p_program ='aimp401' OR p_program = 'aomt800' 
         LET l_refer1 = p_tlf021 
         LET l_refer2 = p_tlf022
         LET l_refer3 = p_tlf023
 
   #出庫狀況
   WHEN  p_program ='asfp210' OR p_program = 'asfp211'   
      OR p_program ='asfp212' OR p_program = 'asfp213' 
      OR p_program ='asft210' OR p_program = 'asft220' 
      OR p_program ='asft250' 
         LET l_refer1 = p_tlf036 
         SELECT sfb22,sfb82 INTO l_refer3,l_refer2
                            FROM sfb_file WHERE sfb01=p_tlf036
 
   WHEN p_program ='apmt1071' OR p_program = 'apmt1072'   
        OR p_program ='apmt2082' OR p_program ='apmt2083'
        LET l_refer2 = p_tlf19
        SELECT rvv04,rvv36   #驗收單/採購單
                INTO l_refer1,l_refer3 FROM rvv_file 
               WHERE rvv01 = p_tlf026 and rvv02 = p_tlf027
 
   WHEN p_program ='aimt301' OR p_program = 'aimt311'   
     OR p_program ='aimt303' OR p_program = 'aimt313' 
        LET l_refer1 = p_tlf036
        LET l_refer2 = p_tlf14
 
   WHEN p_program ='aimt304' OR p_program = 'aimt305'   
     OR p_program ='aimt314' OR p_program = 'aimt315' 
     OR p_program ='aimp400'
        LET l_refer1 = p_tlf031 
        LET l_refer2 = p_tlf032
        LET l_refer3 = p_tlf033
{
   WHEN p_program ='aomt100' OR p_program = 'aomt200'   
     OR p_program ='aomt500' OR p_program = 'aimt350' 
     OR p_program ='aomt400' OR p_program = 'aomu024'
     OR p_program ='aomu025' OR p_program = 'aomu026'
        SELECT gmb04 INTO l_refer1 FROM gmb_file 
                                    WHERE gmb01 =p_tlf026 
                                      AND gmb02 =p_tlf027
                                     AND gmb03 =0
        LET l_refer2 = p_tlf19
}
   WHEN p_program ='aimt307' OR p_program = 'aimt310'   
     OR p_program ='aimp811' 
        LET l_refer1 = p_tlf026 
        LET l_refer2 = p_tlf14
   END CASE
   RETURN l_refer1,l_refer2,l_refer3,l_refer4
END FUNCTION

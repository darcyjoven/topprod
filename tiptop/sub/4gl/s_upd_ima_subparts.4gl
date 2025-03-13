# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Program name...: s_upd_ima_subparts.4gl
# Descriptions...: 維護子料件更新作業
# Date & Author..: No.FUN-A50011 10/07/11 By yangfeng 
# Date & Author..: No.TQC-A80013 10/08/03 By jan 過單
# Modify.........: No.FUN-A90049 10/09/26 BY vealxu 規通料件整合商戶料號合併到 ima_file
# Modify.........: No.FUN-B80032 11/10/31 By yangxf ima_file 更新揮寫rtepos 
# Modify.........: No.FUN-C60021 12/06/15 By qiaozy imaag1重新賦值

DATABASE ds   
 

GLOBALS "../../config/top.global"
GLOBALS "../../aim/4gl/aimi100.global"
GLOBALS "../../sub/4gl/s_data_center.global"   #No.FUN-7C0010

FUNCTION s_upd_ima_subparts(p_ima01)
   DEFINE l_sql1    STRING
   DEFINE l_sql2    STRING
   DEFINE l_msg     STRING
   DEFINE l_agd021  LIKE  agd_file.agd02
   DEFINE l_agd022  LIKE  agd_file.agd02
   DEFINE l_agd031  LIKE  agd_file.agd03
   DEFINE l_agd032  LIKE  agd_file.agd03
   DEFINE l_ima02   LIKE  ima_file.ima02
   DEFINE l_n1      LIKE  type_file.num5
   DEFINE l_n2      LIKE  type_file.num5
   DEFINE l_n3      LIKE  type_file.num5
   DEFINE l_n       LIKE  type_file.num5
   DEFINE l_ima01_t LIKE  ima_file.ima01
   DEFINE l_ima02_t LIKE  ima_file.ima02
   DEFINE l_ima940_t LIKE ima_file.ima940
   DEFINE l_ima941_t LIKE ima_file.ima941
   DEFINE p_ima01    LIKE ima_file.ima01
   DEFINE l_confirm  LIKE ze_file.ze03
   DEFINE l_ps       LIKE sma_file.sma46
   DEFINE g_ima RECORD  LIKE ima_file.*            #FUN-A90049 add
   DEFINE l_ima RECORD  LIKE ima_file.*            #FUN-B80032

   SELECT * INTO g_ima.* FROM ima_file WHERE ima01 = p_ima01
   LET l_ima940_t = g_ima.ima940
   LET l_ima941_t = g_ima.ima941
   LET l_ima01_t = g_ima.ima01
   LET l_ima02_t = g_ima.ima02
   SELECT sma46 INTO l_ps FROM sma_file
   LET l_sql1 = "SELECT agd02,agd03 FROM agd_file WHERE agd01 ='",g_ima.ima940,"'"
   DECLARE i100_upd_cs1 SCROLL CURSOR WITH HOLD FROM l_sql1  
   LET l_sql2 = "SELECT agd02,agd03 FROM agd_file WHERE agd01 ='",g_ima.ima941,"'"
   DECLARE i100_upd_cs2 SCROLL CURSOR WITH HOLD FROM l_sql2
   SELECT count(agd02) INTO l_n1 FROM agd_file WHERE agd01 = g_ima.ima940
   SELECT count(agd02) INTO l_n2 FROM agd_file WHERE agd01 = g_ima.ima941
   IF(l_n1 = 0 OR l_n2 = 0) THEN
     CALL cl_err('','aim1103',1)
   ELSE
        FOREACH i100_upd_cs1 INTO l_agd021,l_agd031
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            FOREACH i100_upd_cs2 INTO l_agd022,l_agd032
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            LET g_ima.imaag1=g_ima.imaag   #FUN-C60021----add---
            LET g_ima.ima01 = l_ima01_t,l_ps,l_agd021,l_ps,l_agd022
            LET g_ima.ima02 = l_ima02_t,l_ps,l_agd031,l_ps,l_agd032 
            LET g_ima.imaag = '@CHILD'
#            LET g_ima.imaag1 = l_ima01_t  #FUN-C60021----MARK--
            LET g_ima.ima151 = 'N'
            IF g_ima.ima151 = 'N' THEN
               LET g_ima.ima940 = l_agd021 
               LET g_ima.ima941 = l_agd022 
            END IF
           #FUN-B80032---------STA-------
            SELECT * INTO l_ima.*
              FROM ima_file
             WHERE ima01 = g_ima.ima01
             IF l_ima.ima02 <> g_ima.ima02 OR l_ima.ima021 <> g_ima.ima021
               OR l_ima.ima25 <> g_ima.ima25 OR l_ima.ima45 <> g_ima.ima45
               OR l_ima.ima131 <> g_ima.ima131 OR l_ima.ima151 <> g_ima.ima151
               OR l_ima.ima154 <> g_ima.ima154 OR l_ima.ima1004 <> g_ima.ima1004 
               OR l_ima.ima1005 <> g_ima.ima1005 OR l_ima.ima1006 <> g_ima.ima1006
               OR l_ima.ima1007 <> g_ima.ima1007 OR l_ima.ima1008 <> g_ima.ima1008
               OR l_ima.ima1009 <> g_ima.ima1009 THEN        
               IF g_aza.aza88 = 'Y' THEN
                  UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima.ima01 AND rtepos = '3'
               END IF
            END IF 
            #FUN-B80032---------END-------            
            SELECT count(*) INTO l_n3 FROM ima_file WHERE ima01 = g_ima.ima01
            IF l_n3 > 0 THEN 
               UPDATE ima_file SET ima_file.* = g_ima.*    
               WHERE ima01 = g_ima.ima01             
               IF SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  
               END IF
            END IF
          END FOREACH
        END FOREACH 
        LET g_ima.ima01 = l_ima01_t
        LET g_ima.ima02 = l_ima02_t
        LET g_ima.ima151 = 'Y'
        LET g_ima.ima940 = l_ima940_t
        LET g_ima.ima941 = l_ima941_t
   END IF
END FUNCTION
#TQC-A80013

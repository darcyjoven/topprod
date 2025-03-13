# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_program.4gl
# Descriptions...: 判斷程式代號其出入庫狀況 
# Date & Author..: 93/05/03 By Apple
# Usage..........: CALL s_program(p_code) RETURNING l_str,l_wc
# Input Parameter: p_code  程式代號
# Return code....: l_str   出入庫狀況代號
#                  l_wc    異動條件
# Modify.........: No.FUN-5C0114 06/02/20 By kim add asri210/220/230/asrt320
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-880164 08/08/21 By claire add asfi526/asfi527
# Modify.........: No.MOD-C30697 12/03/15 By fengrui 在p_code='7'與p_code='27'時加上tlf13='aimt325'
# Modify.........: No:FUN-C70014 12/07/11 By wangwei 新增RUN CARD發料作業
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_program(p_code)
   DEFINE  p_code          LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           l_str           LIKE ze_file.ze03,            #No.FUN-680147 VARCHAR(40)
           l_wc            LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(1000)
 
   IF p_code  IS NULL OR p_code = ' ' OR p_code < 1 THEN 
      RETURN l_str,l_wc
   END IF 
   CASE 
      #入庫狀況
      WHEN p_code = 1  #工單退料日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-079' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'asft230' OR tlf13 ='asft240' ",
                   "  OR tlf13 = 'apmt2081'",
                   "  OR tlf13 = 'asfi526' ",  #MOD-880164 add 
                   "  OR tlf13 = 'asfi527' ",  #MOD-880164 add
                   "  OR tlf13 = 'asfi528' ",
                   "  OR tlf13 = 'asfi529' OR tlf13 = 'asri220')" #FUN-5C0114 add asri220
      WHEN p_code = 2  #工單完工入庫日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-080' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 ='asft6201' OR tlf13='asft5003' ",
                   "  OR tlf13 ='asft6151'  OR tlf13='asft6156' ",
                   "  OR tlf13 ='asft6501'  OR tlf13='asft660' ",
                   "  OR  tlf13 ='asft8001' OR tlf13='asft6101' OR tlf13='asrt320' ", #FUN-5C0114 add asrt320
                   "  ) "  
      WHEN p_code = 3  #工單完工全檢日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-081' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 ='asft6001'  ",  
                   "  OR tlf13='asft6051' OR tlf13 ='asft6152') "
      WHEN p_code =  4 #採購驗收入庫日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-082' AND ze02 = g_lang
         LET l_wc =" AND ((tlf13 = 'apmt150') ",
                   "  OR (tlf13 = 'apmt1101' AND tlf03 = 50 ) ",
                   "  OR (tlf13 = 'apmt1201' AND tlf03 = 50 ))"
      WHEN p_code =  5 #委外驗收入庫日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-083' AND ze02 = g_lang
         #LET l_wc =" AND ((tlf13 = 'apmt230') ",  95/01/01 Jackson
         LET l_wc =" AND ( (tlf13 = 'apmt2071') ",
                   "  OR (tlf13 = 'apmt2001' AND tlf03 = 50 )",
                   "  OR (tlf13 = 'asft6101' AND tlf03 = 50 )",
                   #No.+389 010719 add by linda
                   "  OR (tlf13 = 'asft6201' AND tlf03 = 50 )", 
                   #No.+389 end----
                   "  OR (tlf13 = 'apmt230'  AND tlf03 = 50 )",
                   "  OR (tlf13 = 'apmt2301' AND tlf03 = 50 ))"
      WHEN p_code =  6 #庫存雜項收料日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-084' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aimt302' OR tlf13 ='aimt312') "
      WHEN p_code = 7  #庫存調撥入庫日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-085' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aimt304' OR tlf13='aimt305' ",
                   "   OR tlf13 = 'aimt314' OR tlf13='aimt315' ",
                   "   OR tlf13 = 'aimp401' OR ",
                   "   (tlf13 = 'aimt324' AND tlf02='99' ",
                   "    AND tlf03='50') ",
                   "   OR (tlf13 = 'aimt325' AND tlf02='99' AND tlf03='50')) "     #MOD-C30697 add
      WHEN p_code = 8  #銷退入庫日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-086' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aomt800') "
      WHEN p_code = 9  #工廠間調撥入庫日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-087' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aimp701') "
      #出庫狀況
      WHEN p_code = 21 #工單成套發料日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-088' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'asfp210' OR tlf13 ='asfp211' ",
                   "  OR  tlf13 = 'asfp212' OR tlf13 ='asfp213' ",
                   "  OR  tlf13 = 'apmt2072' OR tlf13 = 'asft6153'",
                   "  OR  tlf13 = 'asfi511' OR tlf13='asfi519' OR tlf13 = 'asri210')" #FUN-5C0114 add asri210   #FUN-C70014 add tlf13='asfi519'
      WHEN p_code = 23 #工單超領日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-089' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'asft210' OR tlf13='asft220' ",
                   "  OR  tlf13 = 'asft250' OR tlf13='asfi512' OR tlf13='asri230')" #FUN-5C0114 add asri230
      WHEN p_code = 24 #庫存退貨日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-090' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'apmt1071' OR tlf13='apmt1072' ",
                   "  OR  tlf13 = 'apmt1073' OR tlf13='apmt1074' ",
                    " OR  tlf13 = 'apmt2082' OR tlf13='apmt2083')"
      WHEN p_code = 25 #庫存雜項發料日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-091' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aimt301' OR tlf13='aimt311') "
      WHEN p_code = 26 #庫存雜項報廢日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-092' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aimt303' OR tlf13='aimt313') "
      WHEN p_code = 27 #庫存調撥出庫日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-093' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aimt304' OR tlf13='aimt305' ",
                   "   OR tlf13 = 'aimt314' OR tlf13='aimt315' ",
                   "   OR tlf13 = 'aimp400' OR (tlf13='aimt324' ",
                   "   AND tlf02='50' AND tlf03='99') ",
                   "   OR (tlf13 = 'aimt325' AND tlf02='50' AND tlf03='99')) "     #MOD-C30697 add
      WHEN p_code = 28 #銷單出貨日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-094' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aomt100' OR tlf13='aomt200'",
                   "  OR  tlf13 = 'aomt500' OR tlf13='aimt350'",
                   "  OR  tlf13 = 'aomt400' OR tlf13='aomu024'",
                   "  OR  tlf13 = 'aomu025' OR tlf13='aomu026'",
                   "  OR  tlf13 = 'aomt119' OR tlf13='axmt620'",
                   "  OR  tlf13 = 'axmt650')"
      WHEN p_code = 29 #庫存調整日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-095' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aimt307' OR tlf13 ='aimt310' ",
                   "  OR tlf13 ='aimt3101'  OR tlf13 ='aimt3102' ",
                   "  OR  tlf13 = 'aimp702' OR tlf13 ='aimp880')"
      WHEN p_code = 31 #工廠間調撥出庫日報表
         SELECT ze03 INTO l_str FROM ze_file WHERE ze01 = 'sub-096' AND ze02 = g_lang
         LET l_wc =" AND (tlf13 = 'aimp700') "
      OTHERWISE EXIT CASE
   END CASE
   RETURN l_str,l_wc
END FUNCTION

# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_i010_unconfirm
# Descriptions...: 費用單取消審核
# Date & Author..: 2009/07/17 By dongbg (FUN-960141)
# Usage..........: CALL s_i010_unconfirm(p_no)
# Input Parameter: p_no    費用單號
# Return Code....: g_flag  0:不成功
#                          1:成功            
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_lua    RECORD LIKE lua_file.*
DEFINE g_oma    RECORD LIKE oma_file.*
DEFINE g_ooa    RECORD LIKE ooa_file.*
DEFINE g_oob    RECORD LIKE oob_file.*
DEFINE g_omb    RECORD LIKE omb_file.*
DEFINE g_omc    RECORD LIKE omc_file.*
DEFINE g_sql1   LIKE type_file.chr1000
DEFINE g_flag   LIKE type_file.chr1
 
FUNCTION s_i010_unconfirm(p_no)
DEFINE p_no   LIKE lua_file.lua01
DEFINE l_amt1 LIKE type_file.num5,
       l_amt2 LIKE type_file.num5,
       l_oob RECORD LIKE oob_file.*,
       l_sum  LIKE type_file.num5,
       l_cnt  LIKE type_file.num5,
       l_t1    LIKE type_file.chr20,
       l_dbs   LIKE type_file.chr10,
       l_aba19 LIKE aba_file.aba19
 
   SELECT * INTO g_lua.* FROM lua_file WHERE lua01=p_no
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lua01',p_no,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN 0
   END IF
 
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01=g_lua.lua24
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('oma01',g_lua.lua24,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN 0
   END IF
 
   IF g_lua.lua02='01' THEN
      CALL s_yz_hu1('-')
  END IF
  DELETE FROM npp_file 
    WHERE npp01 = g_oma.oma01 AND npp011=1 AND nppsys='AR' AND npp00=2 
  DELETE FROM npq_file 
    WHERE npq01 = g_oma.oma01 AND npq011=1 AND npqsys='AR' AND npq00=2  
  #FUN-B40056--add--str--
  DELETE FROM tic_file WHERE tic04 = g_oma.oma01
  #FUN-B40056--add--end--

  LET g_sql1 =
     "SELECT * FROM oob_file",
       " WHERE oob01 ='", g_oma.oma01,"' AND oob04 = '3' AND oob03 = '1' AND oob06 IS NOT NULL AND oob09 > 0"
  PREPARE i010_pb6 FROM g_sql1
  DECLARE i010_cs6 SCROLL CURSOR FOR i010_pb6
  FOREACH i010_cs6 INTO l_oob.*
  IF SQLCA.sqlcode THEN                                                                                                        
     CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                   
     LET g_success = 'N'
     EXIT FOREACH                                                                                                              
  END IF 
  UPDATE oma_file SET oma55 = oma55 - l_oob.oob09,
                      oma57 = oma57 - l_oob.oob10
  WHERE oma01 = l_oob.oob06
  SELECT oma55, oma57 INTO l_amt1,l_amt2 FROM oma_file 
  WHERE oma01 = l_oob.oob06
  IF l_amt1<0 OR l_amt2 <0 THEN
     CALL cl_err('','alm-205',1)
     LEt g_success = 'N' 
     END IF
  END FOREACH
  SELECT sum(rxx04) + SUM(rxx05) INTO l_sum FROM rxx_file                                                                          
      WHERE rxx01=g_lua.lua01 and rxx930=g_lua.luaplant and rxx00='07'                                                            
 IF cl_null(l_sum) THEN LET l_sum=0 END IF                                                                                        
 IF l_sum > 0 THEN LET g_flag = '1' LET g_oma.oma65 = '2' ELSE LET g_flag = '0' LET g_oma.oma65 = '1' END IF
 LET g_sql1 = "SELECT * FROM oob_file WHERE oob01 = '",g_oma.oma01,"' AND oob03 = '1' AND oob02 > 0 "
 PREPARE i010_pb7 FROM g_sql1
 DECLARE i010_cs7 SCROLL CURSOR FOR i010_pb7
   FOREACH i010_cs7 INTO l_oob.*
      IF SQLCA.sqlcode THEN                                                                                                        
         CALL cl_err('foreach:',SQLCA.sqlcode,1)                                                                                   
         LEt g_success = 'N' 
         EXIT FOREACH                                                                                                              
      END IF 
   IF l_oob.oob04 = '1' THEN
      DELETE FROM nmh_file WHERE nmh01 = l_oob.oob06
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                 
         CALL cl_err3("del","nmh_file","l_oob.oob06","",SQLCA.sqlcode,"","del nmh",1)                                                          
         LET g_success = 'N'                                                                                                        
      END IF                                                                                                                        
   END IF
   IF l_oob.oob04 = '2' THEN
      DELETE FROM nme_file WHERE nme12 = l_oob.oob06
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                      
         CALL cl_err3("del","nme_file",'','',SQLCA.sqlcode,"","del nme",1)                                                               
         LET g_success = 'N'                                                                                                             
      END IF    
      #FUN-B40056 --begin
      IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
         DELETE FROM tic_file WHERE tic04 = l_oob.oob06
         IF SQLCA.sqlcode THEN                                                                                      
            CALL cl_err3("del","tic_file",'','',SQLCA.sqlcode,"","del tic",1)                                                               
            LET g_success = 'N'                                                                                                             
         END IF   
      END IF   
      #FUN-B40056 --end
   END IF
 END FOREACH
 IF g_flag = '1' THEN
    DELETE FROM ooa_file WHERE ooa01 = g_oma.oma01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
       CALL cl_err3("del","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","del ooa",1)                                           
       LET g_success = 'N'                                                                                                            
    END IF 
    DELETE FROM oob_file WHERE oob01 = g_oma.oma01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
       CALL cl_err3("del","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","del oob",1)                                           
       LET g_success = 'N'                                                                                                            
    END IF 
 END IF
 DELETE FROM oma_file WHERE oma01 = g_oma.oma01
 IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
    CALL cl_err3("del","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","del oma",1)                                           
    LET g_success = 'N'                                                                                                            
 END IF 
 DELETE FROM omb_file WHERE omb01 = g_oma.oma01
 IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
    CALL cl_err3("del","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.sqlcode,"","del omb",1)                                           
    LET g_success = 'N'                                                                                                            
 END IF 
 DELETE FROM omc_file WHERE omc01 = g_oma.oma01
 IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                                                   
    CALL cl_err3("del","omc_file",g_omc.omc01,g_omc.omc02,SQLCA.sqlcode,"","del omc",1)                                           
    LET g_success = 'N'                                                                                                            
 END IF
 IF g_success = 'N' THEN RETURN 0 ELSE RETURN 1 END IF
END FUNCTION
#FUN-960141

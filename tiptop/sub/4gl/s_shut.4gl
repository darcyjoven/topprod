# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Program name...: s_shut.4gl
# Descriptions...: 判斷目前系統是否可使用
# Date & Author..: 92/05/08 By Nora
# Usage..........: IF NOT s_shut()
# Input Parameter: p_pause
# Return Code....: 1 YES
#                  0 NO
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6C0017 06/12/13 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-950208 09/05/20 By lilingyu 增加檢查目前系統是否可使用之模組
# Modify.........: No:MOD-9C0452 09/12/30 By Dido 增加客制系統 
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_shut(p_pause)
 
DEFINE
    p_pause LIKE type_file.num5,          #No.FUN-680147 SMALLINT
    l_sys01 LIKE apz_file.apz01           #No.FUN-680147 VARCHAR(01)
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    CASE
      #WHEN g_sys="AAP"                   #MOD-9C0452 mark
       WHEN g_sys="AAP" OR g_sys="CAP"    #MOD-9C0452
          SELECT apz01 INTO l_sys01 FROM apz_file WHERE apz00='0'
 
      #WHEN g_sys="ABX"                                               #MOD-9C0452 mark 
       WHEN g_sys="ABX" OR g_sys="CBX" OR g_sys="ABT" OR g_sys="CBT"  #MOD-9C0452
         #SELECT bxa10 INTO l_sys01 FROM bxa_file WHERE bxa00='0'   #MOD-950208
          SELECT bxz01 INTO l_sys01 FROM bxz_file WHERE bxz00='0'   #MOD-950208
 
#MOD-950208 --begin                                                                                                                 
      #WHEN g_sys="ACO"                   #MOD-9C0452 mark 
       WHEN g_sys="ACO" OR g_sys="CCO"    #MOD-9C0452
          SELECT coz01 INTO l_sys01 FROM coz_file WHERE coz00='0'                                                                   
      #WHEN g_sys="AFA"                   #MOD-9C0452 mark 
       WHEN g_sys="AFA" OR g_sys="CFA"    #MOD-9C0452
          SELECT faa01 INTO l_sys01 FROM faa_file WHERE faa00='0'                                                                   
      #WHEN g_sys="AXR"                   #MOD-9C0452 mark 
       WHEN g_sys="AXR" OR g_sys="CXR"    #MOD-9C0452
          SELECT ooz01 INTO l_sys01 FROM ooz_file WHERE ooz00='0'                                                                   
#MOD-950208 --end                                                                                                                   
                                                                                                                                    
#       WHEN g_sys="AGL"  #軞梛炵苀                                  #MOD-950208 MARK                                               
#          SELECT aaz01 INTO l_sys01 FROM aaz_file WHERE aaz00='0'   #MOD-950208 MARK
 
      #WHEN g_sys="AMM" OR g_sys="AXM"                                                                 #MOD-9C0452 mark 
       WHEN g_sys="AMM" OR g_sys="AXM" OR g_sys="CMM" OR g_sys="CXM"  OR g_sys="ATM" OR g_sys="CTM"    #MOD-9C0452
          SELECT oaz01 INTO l_sys01 FROM oaz_file WHERE oaz00='0'
 
      #WHEN g_sys="ANM"                   #MOD-9C0452 mark 
       WHEN g_sys="ANM" OR g_sys="CNM"    #MOD-9C0452
          SELECT nmz01 INTO l_sys01 FROM nmz_file WHERE nmz00='0'
 
       OTHERWISE
          SELECT sma01 INTO l_sys01 FROM sma_file WHERE sma00='0'
 
    END CASE
 
    IF l_sys01='N' THEN
        CALL cl_err('','9037',p_pause)
        RETURN 1
    END IF
    RETURN 0
END FUNCTION

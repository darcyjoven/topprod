# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Modify.........: No.MOD-4C0086 04/12/15 By Nicola 多語言切換寫死在程式中
# Modify.........: No.MOD-610021 06/01/05 By Smapmin 增加貸方'9'項目
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-690090 06/11/23 By day 增加借方 'X' 集團代收
# Modify.........: No.FUN-960141 09/06/24 By dongbg GP5.2修改:
#                                            借方增加:A:溢退,E:聯盟卡,F:轉費用,Q:券
#                                            貸方增加:A:T/T,B:轉收入,C:溢收(流通),D:支票,E:聯盟卡,F:轉費用,Q:券
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9B0043 09/11/09 By lutingting去除類型為'F'得設定 
# Modify.........: No.FUN-9C0109 09/12/29 By lutingting取消MOD-9B0043修改
# Modify.........: No.FUN-D70029 13/07/05 By wangrr 增加借方'H'帳扣費用
DATABASE ds
 
GLOBALS "../../config/top.global"
 
FUNCTION s_oob04(p_code1,p_code2)
DEFINE p_code1,p_code2   LIKE type_file.chr1,      #No.FUN-680123 VARCHAR(1)
       l_ooc02           LIKE ooc_file.ooc02,
       l_msgcode         LIKE ze_file.ze01,        #No.FUN-680123 VARCHAR(10)
       l_msg             LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(50)
 
   LET l_msgcode=""
   CASE
      WHEN p_code1 = "1" AND p_code2 = "1"
         LET l_msgcode = "axr-920"
      WHEN p_code1 = "1" AND p_code2 = "2"
         LET l_msgcode = "axr-921"
      WHEN p_code1 = "1" AND p_code2 = "3"
         LET l_msgcode = "axr-922"
      WHEN p_code1 = "1" AND p_code2 = "4"
         LET l_msgcode = "axr-923"
      WHEN p_code1 = "1" AND p_code2 = "5"
         LET l_msgcode = "axr-924"
      WHEN p_code1 = "1" AND p_code2 = "6"
         LET l_msgcode = "axr-925"
      WHEN p_code1 = "1" AND p_code2 = "7"
         LET l_msgcode = "axr-926"
      WHEN p_code1 = "1" AND p_code2 = "8"
         LET l_msgcode = "axr-927"
      WHEN p_code1 = "1" AND p_code2 = "9"
         LET l_msgcode = "axr-928"
      #FUN-960141 add begin
      WHEN p_code1 = "1" AND p_code2 = "A"
         LET l_msgcode = "axr-117"
      WHEN p_code1 = "1" AND p_code2 = "E"                                                                                             LET l_msgcode = "axr-118"
         LET l_msgcode = "axr-118"
      WHEN p_code1 = "1" AND p_code2 = "F"   #MOD-9B0043   #FUN-9C0109 取消MARK
         LET l_msgcode = "axr-119"           #MOD-9B0043   #FUN-9C0109 取消MARK
      WHEN p_code1 = "1" AND p_code2 = "H"   #FUN-D70029
         LET l_msgcode = "axr-183"           #FUN-D70029
      WHEN p_code1 = "1" AND p_code2 = "Q"
         LET l_msgcode = "axr-120"
      WHEN p_code1 = "2" AND p_code2 = "A"
         LET l_msgcode = "axr-121"
      WHEN p_code1 = "2" AND p_code2 = "B"
         LET l_msgcode = "axr-122"
      WHEN p_code1 = "2" AND p_code2 = "C"
         LET l_msgcode = "axr-143"
      WHEN p_code1 = "2" AND p_code2 = "D"
         LET l_msgcode = "axr-221"
      WHEN p_code1 = "2" AND p_code2 = "E"
         LET l_msgcode = "axr-118"
      WHEN p_code1 = "2" AND p_code2 = "F"  #MOD-9B0043   #FUN-9C0109 取消MARK
         LET l_msgcode = "axr-119"          #MOD-9B0043   #FUN-9C0109 取消MARK
      WHEN p_code1 = "2" AND p_code2 = "Q"
         LET l_msgcode = "axr-120"
      #FUN-960141 add end
      WHEN p_code1 = "2" AND p_code2 = "1"
         LET l_msgcode = "axr-929"
      WHEN p_code1 = "2" AND p_code2 = "2"
         LET l_msgcode = "axr-930"
      WHEN p_code1 = "2" AND p_code2 = "4"
         LET l_msgcode = "axr-931"
      WHEN p_code1 = "2" AND p_code2 = "7"
         LET l_msgcode = "axr-932"
      #-----MOD-610021---------
      WHEN p_code1 = "2" AND p_code2 = "9"
         LET l_msgcode = "axr-922"
      #-----END MOD-610021-----
      #No.FUN-690090--begin
      WHEN p_code1 = "1" AND p_code2 = "X"
         LET l_msgcode = "axr-951"
      #No.FUN-690090--end  
      OTHERWISE 
         SELECT ooc02 INTO l_ooc02 FROM ooc_file WHERE ooc01 = p_code2
         IF SQLCA.sqlcode THEN
            LET l_ooc02 = " "
         END IF
         RETURN l_ooc02 
   END CASE
 
   IF NOT cl_null(l_msgcode) THEN
      SELECT ze03 INTO l_msg FROM ze_file
       WHERE ze01=l_msgcode AND ze02=g_lang
      RETURN l_msg
   END IF
 
   RETURN " " 
 
END FUNCTION

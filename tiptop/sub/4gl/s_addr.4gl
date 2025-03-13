# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program name...: s_addr.4gl
# Descriptions...: 
# Date & Author..: 
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改
# Modify.........: No.TQC-660003 06/06/16 By Pengu l_add1,l_add2,l_add3應改為CHAR(255)
# Modify.........: No.MOD-680087 06/08/28 By Claire l_add1,l_add2,l_add3應改為LIKE occ241
# Modify.........: No.FUN-680147 06/09/08 By Czl  類型轉換
# Modify.........: No.FUN-720014 07/03/02 By rainy 客戶地址增為5欄`
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
 
DATABASE ds   #FUN-7C0053
 
FUNCTION s_addr(p_no,p_cus_no,p_add_no)
    DEFINE p_no,p_cus_no,p_add_no     LIKE oap_file.oap01       #No.FUN-680147 VARCHAR(16)         #No.FUN-560002
   #DEFINE l_add1,l_add2,l_add3       VARCHAR(36)          #No.TQC-660003 mark
   #DEFINE l_add1,l_add2,l_add3       VARCHAR(255)         #No.TQC-660003 add   #MOD-680087 mark
    DEFINE l_add1,l_add2,l_add3       LIKE occ_file.occ241       #MOD-680087 add
    DEFINE l_add4,l_add5              LIKE occ_file.occ245       #FUN-720014
    CASE WHEN p_add_no IS NULL  SELECT occ241,occ242,occ243,occ244,occ245   #FUN-720014 add occ244/245 
                                  INTO l_add1,l_add2,l_add3,l_add4,l_add5  FROM occ_file 
                                 WHERE occ01=p_cus_no
         WHEN p_add_no = 'MISC' SELECT oap041,oap042,oap043,oap044,oap045   #FUN-720014 add oap044/045
                                  INTO l_add1,l_add2,l_add3,l_add4,l_add5  FROM oap_file 
                                 WHERE oap01=p_no
         OTHERWISE SELECT ocd221,ocd222,ocd223,ocd230,ocd231       #FUN-720014 add ocd230/231 
                     INTO l_add1,l_add2,l_add3,l_add4,l_add5  FROM ocd_file 
                    WHERE ocd01=p_cus_no AND ocd02=p_add_no
    END CASE
    RETURN l_add1,l_add2,l_add3,l_add4,l_add5     #FUN-720014 add l_add4/5
END FUNCTION

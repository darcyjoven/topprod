# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name ..: s_upd_codcoe               
# DESCRIPTION....: 更新手冊出口成品檔(cod_file)
#                  更新手冊進口料件檔(coe_file)
# Parmeter.......: p_key  手冊編號
#                  p_key2 備案序號
#                  p_key3 資料型態 1.成品 2.材料 
#                  p_key4 交易型態 1.出口 2.進口 3.報廢
#                  p_key5 報關類別 0.報廢 1.直接 2.轉廠 3.退港 4.內銷 5.核銷  6.內購
# Date & Autor...: No.MOD-490398 05/01/10 By Danny  將acot500的更新段獨立於此作業
# Modify.........: No.MOD-530224 05/03/24 By Carrier 在重新開帳前的報關作業資料,不納入合計
# Modify.........: No.TQC-660045 06/06/09 By hellen  cl_err --> cl_err3
# Modify.........: No.FUN-680069 06/08/24 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-910088 12/01/12 By chenjing 增加數量欄位小數取位
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE 
   g_coc01       LIKE coc_file.coc01 
 
FUNCTION s_upd_codcoe(p_key,p_key2,p_key3,p_key4,p_key5)
   DEFINE p_key    LIKE coc_file.coc03
   DEFINE p_key2   LIKE cod_file.cod02
   DEFINE p_key3   LIKE cno_file.cno03
   DEFINE p_key4   LIKE cno_file.cno031
   DEFINE p_key5   LIKE cno_file.cno04
   DEFINE l_cnp05  LIKE cnp_file.cnp05
   DEFINE l_cno18  LIKE cno_file.cno18         #add by carrier
   DEFINE l_sql    LIKE type_file.chr1000      #No.FUN-680069  VARCHAR(300)
    #No.MOD-530224  --begin
   DEFINE l_bdate  LIKE type_file.dat          #No.FUN-680069 DATE
   DEFINE l_edate  LIKE type_file.dat          #No.FUN-680069 DATE
   DEFINE l_correct LIKE type_file.chr1        #No.FUN-680069 VARCHAR(01)
   DEFINE l_item   LIKE cod_file.cod03
   DEFINE l_date   LIKE type_file.dat          #No.FUN-680069 DATE
   DEFINE l_yy     LIKE type_file.num5         #No.FUN-680069 SMALLINT
   DEFINE l_mm     LIKE type_file.num5         #No.FUN-680069 SMALLINT
   DEFINE l_unit   LIKE gfe_file.gfe01
   DEFINE l_cod06  LIKE cod_file.cod06
   DEFINE l_fac    LIKE img_file.img21	
   DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680069 SMALLINT
   DEFINE l_qty    LIKE cnw_file.cnw07
    #No.MOD-530224  --end    
    #FUN-910088--add--start--
   DEFINE l_coe06  LIKE coe_file.coe06,
          l_coe09  LIKE coe_file.coe09,
          l_coe101 LIKE coe_file.coe101,
          l_coe051 LIKE coe_file.coe051,
          l_coe107 LIKE coe_file.coe107,
          l_coe091 LIKE coe_file.coe091,
          l_coe102 LIKE coe_file.coe102,
          l_coe106 LIKE coe_file.coe106,
          l_coe105 LIKE coe_file.coe105
   DEFINE l_cod09  LIKE cod_file.cod09,
          l_cod101 LIKE cod_file.cod101,
          l_cod106 LIKE cod_file.cod106
    #FUN-910088--add--end--
 
   #找出原始的申請編號
   SELECT coc01 INTO g_coc01 FROM coc_file
    WHERE coc03 = p_key AND cocacti !='N' 
   IF cl_null(g_coc01) THEN 
#     CALL cl_err(p_key,'aco-062',1)  #No.TQC-660045
      CALL cl_err3("sel","coc_file",p_key,"","aco-062","","",1) #TQC-660045
      RETURN
   END IF
 
    #No.MOD-530224  --begin
   IF p_key3 = '1' THEN            #成品
      SELECT cod03,cod06 INTO l_item,l_cod06 FROM cod_file,coc_file
       WHERE coc01=cod01 AND coc03=p_key AND cod02=p_key2
      SELECT cnx03,cnx04,cnx05
        INTO l_yy,l_mm,l_unit
        FROM cnx_file
       WHERE cnx01=l_item AND cnx02=p_key
         AND cnxconf='Y'
         AND cnx03*12+cnx04=(SELECT MAX(cnx03*12+cnx04) FROM cnx_file
                              WHERE cnx01=l_item AND cnx02=p_key AND cnxconf='Y')
      LET l_fac = 1
      IF l_unit <> l_cod06 THEN
         CALL s_umfchk(l_item,l_unit,l_cod06)
              RETURNING l_cnt,l_fac
      END IF
      LET l_date = '1899/12/31'
      IF NOT cl_null(l_yy) AND NOT cl_null(l_mm) THEN
         CALL s_azm(l_yy,l_mm) RETURNING l_correct, l_bdate, l_edate
         IF l_correct = '0' THEN
            LET l_date=l_edate+1
         END IF
      END IF
   END IF
   IF p_key3 = '2' THEN            #材料
      SELECT coe03,coe06 INTO l_item,l_cod06 FROM coe_file,coc_file
       WHERE coc01=coe01 AND coc03=p_key AND coe02=p_key2
      SELECT cnw03,cnw04,cnw05
        INTO l_yy,l_mm,l_unit
        FROM cnw_file
       WHERE cnw01=l_item AND cnw02=p_key
         AND cnwconf='Y'
         AND cnw03*12+cnw04=(SELECT MAX(cnw03*12+cnw04) FROM cnw_file
                              WHERE cnw01=l_item AND cnw02=p_key AND cnwconf='Y')
      LET l_fac = 1
      IF l_unit <> l_cod06 THEN
         CALL s_umfchk(l_item,l_unit,l_cod06)
              RETURNING l_cnt,l_fac
      END IF
      LET l_date = '1899/12/31'
      IF NOT cl_null(l_yy) AND NOT cl_null(l_mm) THEN
         CALL s_azm(l_yy,l_mm) RETURNING l_correct, l_bdate, l_edate
         IF l_correct = '0' THEN
            LET l_date=l_edate+1
         END IF
      END IF
   END IF
    #No.MOD-530224  --end   
 
   IF p_key3 = '1' THEN            #成品
      IF p_key4 = '1' THEN         #出口
         CASE p_key5               #類別  
              WHEN '1' #直接
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '1' AND cno031 = '1' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date
                      AND cno04 = '1'     #直接出口
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnx06+cnx09 INTO l_qty FROM cnx_file
                    WHERE cnx01=l_item AND cnx02=p_key 
                      AND cnx03=l_yy   AND cnx04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               #FUN-910088--add--start--
                   LET l_cod09 = l_cnp05 + l_qty
                   LET l_cod09 = s_digqty(l_cod09,l_cod06)
                   UPDATE cod_file SET cod09 = l_cod09
               #FUN-910088--add--end--
               #   UPDATE cod_file SET cod09 = l_cnp05 + l_qty     #FUN-910088--mark--
                    WHERE cod01 = g_coc01 AND cod02 = p_key2
                    #No.MOD-530224  --end   
              WHEN '2' #轉廠
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '1' AND cno031 = '1' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date
                      AND cno04 = '2'     #轉廠出口
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnx07+cnx10 INTO l_qty FROM cnx_file
                    WHERE cnx01=l_item AND cnx02=p_key 
                      AND cnx03=l_yy   AND cnx04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                #FUN-910088--add--start--
                   LET l_cod101 = l_cnp05 + l_qty
                   LET l_cod101 = s_digqty(l_cod101,l_cod06)
                   UPDATE cod_file SET cod101 = l_cod101
                #FUN-910088--add--end-- 
                #  UPDATE cod_file SET cod101 = l_cnp05 + l_qty    #FUN-910088--mark--
                    WHERE cod01 = g_coc01 AND cod02 = p_key2
                    #No.MOD-530224  --end
              WHEN '4' #內銷
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '1' AND cno031 = '1' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date
                      AND cno04 = '4'     #內銷出貨
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnx08+cnx11 INTO l_qty FROM cnx_file
                    WHERE cnx01=l_item AND cnx02=p_key 
                      AND cnx03=l_yy   AND cnx04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
               #FUN-910088--add--start--
                   LET l_cod106 = l_cnp05 + l_qty
                   LET l_cod106 = s_digqty(l_cod106,l_cod06)
                   UPDATE cod_file SET cod106 = l_cod106
                #FUN-910088--add--end--
                #  UPDATE cod_file SET cod106 = l_cnp05 + l_qty   #FUN-910088--mark--
                    WHERE cod01 = g_coc01 AND cod02 = p_key2
                    #No.MOD-530224  --end
         END CASE
      END IF
      IF p_key4 = '2' THEN         #進口
         CASE p_key5               #類別  
              WHEN '1' #直接
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '1' AND cno031 = '2' AND cnoconf = 'Y'
                      AND cno10 = p_key
                       AND cno02 >= l_date  #No.MOD-530224
                      AND cno04 = '1'     #國外退貨
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   UPDATE cod_file SET cod091 = l_cnp05
                    WHERE cod01 = g_coc01 AND cod02 = p_key2
              WHEN '2' #轉廠
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '1' AND cno031 = '2' AND cnoconf = 'Y'
                      AND cno10 = p_key
                       AND cno02 >= l_date  #No.MOD-530224
                      AND cno04 = '2'     #轉廠退貨
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   UPDATE cod_file SET cod102 = l_cnp05
                    WHERE cod01 = g_coc01 AND cod02 = p_key2
              WHEN '4' #內銷
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '1' AND cno031 = '2' AND cnoconf = 'Y'
                      AND cno10 = p_key
                       AND cno02 >= l_date  #No.MOD-530224
                      AND cno04 = '4'     #內銷退貨
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   UPDATE cod_file SET cod104 = l_cnp05
                    WHERE cod01 = g_coc01 AND cod02 = p_key2
         END CASE
      END IF
   END IF
   IF p_key3 = '2' THEN            #材料
    #FUN-910088--add--start--
      SELECT coe06 INTO l_coe06 FROM coe_file
       WHERE coe01 = g_coc01 AND coe02 = p_key2
    #FUN-910088--add--end--
      IF p_key4 = '2' THEN         #進口
         CASE p_key5               #類別  
              WHEN '1' #直接
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '2' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date  
                      AND cno04 = '1'     #直接進口
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnw07+cnw15 INTO l_qty FROM cnw_file
                    WHERE cnw01=l_item AND cnw02=p_key
                      AND cnw03=l_yy   AND cnw04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                   LET l_coe09 = l_cnp05 + l_qty           #FUN-910088--add--
                   LET l_coe09 = s_digqty(l_coe09,l_coe06) #FUN-910088--add--
                   UPDATE coe_file SET coe09 = l_coe09     #FUN-910088--add--
                 # UPDATE coe_file SET coe09 = l_cnp05 + l_qty    #FUN-910088--mark--
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
                    #No.MOD-530224  --end
              WHEN '2' #轉廠
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '2' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date  
                      AND cno04 = '2'     #轉廠進口
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnw09+cnw17 INTO l_qty FROM cnw_file
                    WHERE cnw01=l_item AND cnw02=p_key
                      AND cnw03=l_yy   AND cnw04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                   LET l_coe101 = l_cnp05 + l_qty                   #FUN-910088--add--
                   LET l_coe101 = s_digqty(l_coe101,l_coe06)        #FUN-910088--add--
                   UPDATE coe_file SET coe101 = l_coe101            #FUN-910088--add--
               #   UPDATE coe_file SET coe101 = l_cnp05 + l_qty     #FUN-910088--mark--
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
                    #No.MOD-530224  --end
              WHEN '5' #核銷
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '2' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date  
                      AND cno04 = '5'     #手冊轉入
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnw06+cnw14 INTO l_qty FROM cnw_file
                    WHERE cnw01=l_item AND cnw02=p_key
                      AND cnw03=l_yy   AND cnw04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                #FUN-910088--add--start--
                   LET l_coe051 = l_cnp05 + l_qty
                   LET l_coe051 = s_digqty(l_coe051,l_coe06)
                   UPDATE coe_file SET coe051 = l_coe051
                #FUN-910088--add--end--
                 # UPDATE coe_file SET coe051 = l_cnp05 + l_qty     #FUN-910088--mark--
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
                    #No.MOD-530224  --end
              WHEN '6' #內購
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '2' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date  
                      AND cno04 = '6'     #國內採購
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnw11+cnw19 INTO l_qty FROM cnw_file
                    WHERE cnw01=l_item AND cnw02=p_key
                      AND cnw03=l_yy   AND cnw04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                #FUN-910088--add--start--
                   LET l_coe107 = l_cnp05 + l_qty
                   LET l_coe107 = s_digqty(l_coe107,l_coe06)
                   UPDATE coe_file SET coe107 = l_coe107
                #FUN-910088--add--end--
                #  UPDATE coe_file SET coe107 = l_cnp05 + l_qty    #FUN-910088--mark--
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
                    #No.MOD-530224  --end
         END CASE
      END IF
      #modify by carrier
      IF p_key4 = '4' THEN         #耗用
         CASE p_key5               #類別  
              WHEN '1' #直接
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '4' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date  
                      AND cno04 = '1'     #成品直接耗用
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnw08+cnw16 INTO l_qty FROM cnw_file
                    WHERE cnw01=l_item AND cnw02=p_key
                      AND cnw03=l_yy   AND cnw04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                #FUN-910088--add--start--
                   LET l_coe091 = l_cnp05 + l_qty
                   LET l_coe091 = s_digqty(l_coe091,l_coe06)
                   UPDATE coe_file SET coe091 = l_coe091
                #FUN-910088--add--end--
                #  UPDATE coe_file SET coe091 = l_cnp05 + l_qty    #FUN-910088--mark--
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
                    #No.MOD-530224  --end   
              WHEN '2' #轉廠
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '4' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date  
                      AND cno04 = '2'     #成品轉廠耗用
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnw10+cnw18 INTO l_qty FROM cnw_file
                    WHERE cnw01=l_item AND cnw02=p_key
                      AND cnw03=l_yy   AND cnw04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                #FUN-910088--add--start--
                   LET l_coe102 = l_cnp05 + l_qty
                   LET l_coe102 = s_digqty(l_coe102,l_coe06)
                   UPDATE coe_file SET coe102 = l_coe102
                #FUN-910088--add--end--
                #  UPDATE coe_file SET coe102 = l_cnp05 + l_qty   #FUN-910088--mark--
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
                    #No.MOD-530224  --end   
              WHEN '4' #內銷
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '4' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date  
                      AND cno04 = '4'     #成品內銷耗用
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnw12+cnw20 INTO l_qty FROM cnw_file
                    WHERE cnw01=l_item AND cnw02=p_key
                      AND cnw03=l_yy   AND cnw04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                #FUN-910088--add--start--
                   LET l_coe106 = l_cnp05 + l_qty
                   LET l_coe106 = s_digqty(l_coe106,l_coe06)
                   UPDATE coe_file SET coe106 = l_coe106
                #FUN-910088--add--end--
                #  UPDATE coe_file SET coe106 = l_cnp05 + l_qty    #FUN-910088--mark--
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
                    #No.MOD-530224  --end   
         END CASE
      END IF
      IF p_key4 = '1' THEN         #出口
         CASE p_key5               #類別  
              WHEN '2' #轉廠
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '1' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND (cno18 IS NULL OR cno18 = ' ')
                       AND cno02 >= l_date   #No.MOD-530224
                      AND cno04 = '2'
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   UPDATE coe_file SET coe108 = l_cnp05
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
              WHEN '3' #退港
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '1' AND cnoconf = 'Y'
                      AND cno10 = p_key
                       AND cno02 >= l_date   #No.MOD-530224
                      AND cno04 = '3'     #倉退出口
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   UPDATE coe_file SET coe104 = l_cnp05
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
              WHEN '5' #核銷
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '1' AND cnoconf = 'Y'
                      AND cno10 = p_key
                       AND cno02 >= l_date   #No.MOD-530224
                      AND cno04 = '5'     #手冊轉出
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   UPDATE coe_file SET coe103 = l_cnp05
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
              WHEN '6' #內購   #add by carrier
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '1' AND cnoconf = 'Y'
                      AND cno10 = p_key
                       AND cno02 >= l_date   #No.MOD-530224
                      AND cno04 = '6'     #內購退貨
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   UPDATE coe_file SET coe109 = l_cnp05
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
         END CASE
      END IF
      IF p_key4 = '3' THEN         #報廢
         CASE p_key5               #類別  
              WHEN '0'  #報廢
                    #No.MOD-530224  --begin
                   SELECT SUM(cnp05) INTO l_cnp05 FROM cnp_file,cno_file
                    WHERE cno01 = cnp01 AND cnp02 = p_key2
                      AND cno03 = '2' AND cno031 = '3' AND cnoconf = 'Y'
                      AND cno10 = p_key
                      AND cno02 >= l_date   
                      AND cno04 = '0'     #材料報廢
                   IF cl_null(l_cnp05) THEN LET l_cnp05 = 0 END IF
                   SELECT cnw13+cnw21 INTO l_qty FROM cnw_file
                    WHERE cnw01=l_item AND cnw02=p_key
                      AND cnw03=l_yy   AND cnw04=l_mm
                   IF cl_null(l_qty) THEN LET l_qty = 0 END IF
                #FUN-910088--add--start--
                   LET l_coe105 = l_cnp05 + l_qty
                   LET l_coe105 = s_digqty(l_coe105,l_coe06)
                   UPDATE coe_file SET coe105 = l_coe105
                #FUN-910088--add--end--
                #  UPDATE coe_file SET coe105 = l_cnp05 + l_qty   #FUN-910088--mark--
                    WHERE coe01 = g_coc01 AND coe02 = p_key2
                    #No.MOD-530224  --end
         END CASE
      END IF
   END IF
   #modify end
 
END FUNCTION

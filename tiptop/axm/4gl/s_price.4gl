# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Modify.........: NO.MOD-570248 05/10/07 By Mandy 重新抓取客戶主檔上的折扣率%
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE  
#
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A70202 10/07/29 By Smapmin 加上資料有效否的判斷
 
DATABASE ds
 
FUNCTION s_price(p_oea02,p_oea31,p_oea23,p_oea32,
                 p_oea03,p_oeb04,p_oeb05,p_oeb12,p_oah)
  DEFINE p_oah		LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
         p_oea02        LIKE oea_file.oea02,
         p_oea31        LIKE oea_file.oea31,
         p_oea23        LIKE oea_file.oea23,
         p_oea32        LIKE oea_file.oea32,
         p_oea03        LIKE oea_file.oea03,
         p_oeb04        LIKE oeb_file.oeb04,
         p_oeb05        LIKE oeb_file.oeb05,
         p_oeb12        LIKE oeb_file.oeb12,
         l_sql		LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(100)
         p_row,p_col    LIKE type_file.num5,          #No.FUN-680137 SMALLINT
         p_price        LIKE xmc_file.xmc08,
         l_occ32        LIKE occ_file.occ32,
         l_xmf05        LIKE xmf_file.xmf05,
         l_xmg05        LIKE xmg_file.xmg05,
         l_xmh03        LIKE xmh_file.xmh03,
         l_tmp1         LIKE xmc_file.xmc08,
         l_tmp2         LIKE xmc_file.xmc08,
         l_tmp3         LIKE xmd_file.xmd08,
         l_tmp4         LIKE xmd_file.xmd09
 
    IF cl_null(p_oah) OR p_oah != '4' THEN RETURN END IF
   
    #先取特賣產品價格折扣
    DECLARE x1_curs CURSOR FOR 
     SELECT xmc08,xmc09 
       FROM xmb_file,xmc_file
      WHERE xmb01 = xmc01 AND xmb02 = xmc02 
        AND xmb03 = xmc03 AND xmb04 = xmc04 
        AND xmb05 = xmc05 
        AND xmc01 = p_oea31                           #價格條件
        AND xmc02 = p_oea23                           #幣別
        AND (xmc04 = p_oea03 OR xmc04 = ' ')          #客戶編號
        AND (xmc05 = p_oea32 OR xmc05 = ' ')          #收款條件
        AND xmc06 = p_oeb04                           #料件編號
        AND xmc07 = p_oeb05                           #單位
        AND xmb03 <= p_oea02 AND xmb06 >= p_oea02     #生效/失效日
      ORDER BY 1,2
    IF STATUS THEN 
       CALL cl_err('x1_curs',STATUS,1) RETURN 0
    END IF
 
    #若有特賣產品數量價格折扣, 則再乘上此折扣
    DECLARE x2_curs CURSOR FOR         
     SELECT xmd08,xmd09 
       FROM xmb_file,xmd_file
      WHERE xmb01 = xmd01 AND xmb02 = xmd02   
        AND xmb03 = xmd03 AND xmb04 = xmd04 
        AND xmb05 = xmd05
        AND xmd01 = p_oea31 
        AND xmd02 = p_oea23
        AND (xmd04 = p_oea03 OR xmd04 = ' ')         #客戶編號
        AND (xmd05 = p_oea32 OR xmd05 = ' ')         #收款條件
        AND xmd06 = p_oeb04 
        AND xmd07 = p_oeb05 
        AND xmd03 <= p_oea02
        AND xmd08 > 0 
      ORDER BY xmd08 DESC,xmd09
    IF STATUS THEN 
       CALL cl_err('x2_curs',STATUS,1) RETURN 0
    END IF
 
    LET p_price = 0
    FOREACH x1_curs INTO l_tmp1,l_tmp2
       IF STATUS THEN CALL cl_err('sel xmc',STATUS,1) RETURN 0 END IF
       IF cl_null(l_tmp1) THEN LET l_tmp1 = 0 END IF
       IF cl_null(l_tmp2) THEN LET l_tmp2 = 0 END IF
       LET p_price = l_tmp1 * l_tmp2 / 100 
 
       #若有特賣產品數量價格折扣, 則再乘上此折扣
       LET l_tmp4 = 0
       FOREACH x2_curs INTO l_tmp3,l_tmp4
          IF STATUS THEN CALL cl_err('sel xmd',STATUS,1) RETURN 0 END IF
          IF cl_null(l_tmp3) THEN LET l_tmp3 = 0 END IF
          IF cl_null(l_tmp4) THEN LET l_tmp4 = 0 END IF
          IF p_oeb12 >= l_tmp3 THEN
             EXIT FOREACH
          END IF 
          LET l_tmp4 = 0
       END FOREACH
       IF l_tmp4 > 0 THEN
          LET p_price = p_price * (l_tmp4 / 100) 
       END IF
       IF cl_null(p_price) THEN LET p_price = 0 END IF
       EXIT FOREACH
    END FOREACH
 
    #取產品價格檔
    IF p_price = 0 THEN 
       DECLARE x3_curs CURSOR FOR 
        SELECT xmf05,xmf07,xmf08
          FROM xme_file,xmf_file
         WHERE xme01 = xmf01 AND xme02 = xmf02 
           AND xmf01 = p_oea31
           AND xmf02 = p_oea23 
           AND xmf03 = p_oeb04   
           AND xmf04 = p_oeb05
           AND xmf05 <= p_oea02
         ORDER BY xmf05 DESC,xmf07,xmf08
       IF STATUS THEN 
          CALL cl_err('x3_curs',STATUS,1) RETURN 0
       END IF
 
       #若有產品數量價格折扣, 則再乘上此折扣
       DECLARE x4_curs CURSOR FOR 
        SELECT xmg05,xmg06,xmg07
          FROM xme_file,xmg_file 
          WHERE xme01 = xmg01 AND xme02 = xmg02
            AND xmg01 = p_oea31 
            AND xmg02 = p_oea23
            AND xmg03 = p_oeb04 
            AND xmg04 = p_oeb05
            AND xmg05 <= p_oea02 
            AND xmg06 > 0 
          ORDER BY xmg05 DESC,xmg06 DESC,xmg07
       IF STATUS THEN 
          CALL cl_err('x4_curs',STATUS,1) RETURN 0
       END IF
 
       LET p_price = 0
       FOREACH x3_curs INTO l_xmf05,l_tmp1,l_tmp2
          IF STATUS THEN CALL cl_err('sel xmf',STATUS,1) RETURN 0 END IF
          IF cl_null(l_tmp1) THEN LET l_tmp1 = 0 END IF
          IF cl_null(l_tmp2) THEN LET l_tmp2 = 0 END IF
          LET p_price = l_tmp1 * (l_tmp2 / 100) 
 
          #若有產品數量價格折扣, 則再乘上此折扣
          LET l_tmp4 = 0
          FOREACH x4_curs INTO l_xmg05,l_tmp3,l_tmp4
             IF STATUS THEN CALL cl_err('sel xmg',STATUS,1) RETURN 0 END IF
             IF cl_null(l_tmp3) THEN LET l_tmp3 = 0 END IF
             IF cl_null(l_tmp4) THEN LET l_tmp4 = 0 END IF
             IF p_oeb12 >= l_tmp3 THEN
                EXIT FOREACH
             END IF 
             LET l_tmp4 = 0
          END FOREACH
          IF l_tmp4 > 0 THEN
             LET p_price = p_price * (l_tmp4 / 100) 
          END IF
          IF cl_null(p_price) THEN LET p_price = 0 END IF
          EXIT FOREACH
       END FOREACH
 
       #取客戶分類/產品分類折扣
       SELECT xmh03,occ32 INTO l_xmh03,l_occ32
         FROM xmh_file,occ_file,ima_file
        WHERE xmh01 = occ03 AND xmh02 = ima131
          AND occ01 = p_oea03 AND ima01 = p_oeb04
          AND xmh04 = 'Y'   #MOD-A70202
       IF STATUS THEN LET l_xmh03 = 0 END IF
       IF cl_null(l_xmh03) THEN LET l_xmh03 = 0 END IF
       IF l_xmh03 > 0 THEN
          LET p_price = p_price * l_xmh03 / 100 
       END IF
 
       #客戶折扣
      #MOD-570248 MARK
      #IF l_occ32 > 0 THEN
      #   LET p_price = p_price * l_occ32 /100 
      #END IF
       #MOD-570248-STR
       #重新抓取客戶主檔上的折扣率%
        LET l_occ32 = NULL
        SELECT occ32 INTO l_occ32 FROM occ_file
         WHERE occ01 = p_oea03
        IF NOT cl_null(l_occ32) AND l_occ32 > 0 THEN
            LET p_price = p_price * l_occ32 /100
        END IF
        #MOD-570248-END
 
    END IF
    RETURN p_price
END FUNCTION

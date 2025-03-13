# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_ebomchk
# DESCRIPTION....: 試產性工單E-BOM 檢查
# Date & Author..: 2000/01/12 By Kammy
 # Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.FUN-560027 05/06/16 By Mandy 增加特性代碼
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.MOD-790166 07/09/28 By Pengu l_cmd SQL UTER語法錯誤
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-AC0183 10/12/22 By liweie  新增bmp081,bmp082字段
 
DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE
    l_ac      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_bmb     RECORD LIKE bmb_file.*,
     g_part    LIKE ima_file.ima01,   #No.MOD-490217
     g_mpart   LIKE ima_file.ima01,   #No.MOD-490217
    l_bmp01   LIKE bmp_file.bmp01,
    t_bmp01   LIKE bmp_file.bmp01,
    g_bflag   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_ver     LIKE bmp_file.bmp011          #No.FUN-680121 VARCHAR(04)
 
FUNCTION s_ebomchk(p_mpart,p_part,p_ver) #FUN-560027 add p_code 特性代碼
DEFINE
     p_part  LIKE ima_file.ima01, #part number  No.MOD-490217
     p_mpart LIKE ima_file.ima01, #part number  No.MOD-490217
    p_code  LIKE ima_file.ima910,#特性代碼     #FUN-560027 add
    p_ver   LIKE bmo_file.bmo011  #E-BOM version #FUN-560027  改用like方式DEFINE
 
    WHENEVER ERROR CONTINUE
    INITIAlIZE g_bmb.* TO NULL
    LET g_bflag = 'Y'
    LET g_mpart = p_mpart
    LET g_part = p_part
    LET g_ver  = p_ver
    LET l_ac = 0
    LET t_bmp01 = NULL
    #FUN-560027 add
    SELECT bmq910 INTO p_code FROM bmq_file
     WHERE bmq01 = p_mpart
    IF p_code IS NULL THEN
        LET p_code = ' '
    END IF
    #FUN-560027(end)
    CALL check_ebom(p_mpart,p_part,p_ver,p_code)         #由BOM產生備料檔 #FUN-560027 add p_code
    
 
   RETURN g_bmb.*,g_errno
END FUNCTION
 
FUNCTION check_ebom(p_key,p_key1,p_key2,p_key3) #FUN-560027 add p_key3
DEFINE
    p_level      LIKE type_file.num5,  #No.FUN-680121 SMALLINT#level code
     p_key       LIKE ima_file.ima01,  #No.MOD-490217
     p_key1      LIKE ima_file.ima01,  #No.MOD-490217
    p_key2      LIKE bmo_file.bmo011,  #FUN-560027  改用like方式DEFINE
    p_key3      LIKE bmq_file.bmq910,  #No.FUN-560027 add 
    l_cmd       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)
    l_bmp       RECORD LIKE bmp_file.*,
    l_bmo01     LIKE bmo_file.bmo01,
    l_bmp03     LIKE bmp_file.bmp03,
    l_ac,arrno  LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_i,l_x     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    sr          DYNAMIC ARRAY OF RECORD 
        bmp     RECORD LIKE bmp_file.*,
        bmo01   LIKE bmo_file.bmo01 
        END RECORD,
    b_seq       LIKE type_file.num10          #No.FUN-680121 INTEGER#restart sequence (line number)
 
    LET b_seq = 0
    LET arrno = 500
 
    LET l_cmd="SELECT bmp_file.*,bmo_file.bmo01",
              "  FROM bmp_file,OUTER bmo_file",
              " WHERE bmp01='", p_key,"' AND bmp02>",b_seq,"",
              "   AND bmp03=bmo_file.bmo01 AND bmp011='",p_key2,"'",
              "   AND bmp28='",p_key3,"'", #FUN-560027 add
              "   AND bmp011=bmo_file.bmo011 ",
              "   AND bmp28=bmo_file.bmo06 ", #FUN-560027 add   #No.MOD-790166 modify
              " ORDER BY 1"
        PREPARE cralc_ppp FROM l_cmd
        IF SQLCA.sqlcode THEN
             CALL cl_err('P1:',SQLCA.sqlcode,1) RETURN 0 END IF
        DECLARE cralc_cur CURSOR FOR cralc_ppp
        LET l_ac = 1
        FOREACH cralc_cur INTO sr[l_ac].*
            MESSAGE p_key CLIPPED,'-',sr[l_ac].bmp.bmp03 CLIPPED
            IF sr[l_ac].bmp.bmp03 = g_part THEN  #在BOM中找到此料號
               LET g_bmb.bmb01 = sr[l_ac].bmp.bmp01
               LET g_bmb.bmb02 = sr[l_ac].bmp.bmp02
               LET g_bmb.bmb03 = sr[l_ac].bmp.bmp03
               LET g_bmb.bmb04 = sr[l_ac].bmp.bmp04
               LET g_bmb.bmb05 = sr[l_ac].bmp.bmp05
               LET g_bmb.bmb06 = sr[l_ac].bmp.bmp06
               LET g_bmb.bmb07 = sr[l_ac].bmp.bmp07
               LET g_bmb.bmb08 = sr[l_ac].bmp.bmp08
               LET g_bmb.bmb081= sr[l_ac].bmp.bmp081  #TQC-AC0183 add
               LET g_bmb.bmb082= sr[l_ac].bmp.bmp082  #TQC-AC0183 add
               LET g_bmb.bmb09 = sr[l_ac].bmp.bmp09
               LET g_bmb.bmb10 = sr[l_ac].bmp.bmp10
               LET g_bmb.bmb10_fac = sr[l_ac].bmp.bmp10_fac
               LET g_bmb.bmb10_fac2= sr[l_ac].bmp.bmp10_fac2
               LET g_bmb.bmb11 = sr[l_ac].bmp.bmp11
               LET g_bmb.bmb13 = sr[l_ac].bmp.bmp13
               LET g_bmb.bmb14 = sr[l_ac].bmp.bmp14
               LET g_bmb.bmb15 = sr[l_ac].bmp.bmp15
               LET g_bmb.bmb16 = sr[l_ac].bmp.bmp16
               LET g_bmb.bmb17 = sr[l_ac].bmp.bmp17
               LET g_bmb.bmb18 = sr[l_ac].bmp.bmp18
               LET g_bmb.bmb19 = sr[l_ac].bmp.bmp19
               LET g_bmb.bmb23 = sr[l_ac].bmp.bmp23
               LET g_bmb.bmb24 = sr[l_ac].bmp.bmp24
               LET g_bmb.bmb25 = sr[l_ac].bmp.bmp25
               LET g_bmb.bmb26 = sr[l_ac].bmp.bmp26
               LET g_bmb.bmbmodu = sr[l_ac].bmp.bmpmodu
               LET g_bmb.bmbdate = sr[l_ac].bmp.bmpdate
               LET g_bmb.bmbcomm = sr[l_ac].bmp.bmpcomm
               EXIT FOREACH
            END IF
            LET l_ac = l_ac + 1
            IF l_ac > arrno THEN EXIT FOREACH END IF
        END FOREACH
        IF g_bmb.bmb03 IS NOT NULL THEN RETURN END IF 
        LET l_x = l_ac - 1
        #-------- NO:0115 -------------#
        IF l_x = 0 THEN 
           LET g_errno='asf-715' RETURN
        END IF
        #------------------------------#
        FOR l_i = 1 TO l_x 
            MESSAGE p_key CLIPPED,'-',sr[l_i].bmp.bmp03 CLIPPED
            IF sr[l_i].bmp.bmp03 = g_part THEN  #在BOM中找到此料號
               LET g_bmb.bmb01 = sr[l_ac].bmp.bmp01
               LET g_bmb.bmb02 = sr[l_ac].bmp.bmp02
               LET g_bmb.bmb03 = sr[l_ac].bmp.bmp03
               LET g_bmb.bmb04 = sr[l_ac].bmp.bmp04
               LET g_bmb.bmb05 = sr[l_ac].bmp.bmp05
               LET g_bmb.bmb06 = sr[l_ac].bmp.bmp06
               LET g_bmb.bmb07 = sr[l_ac].bmp.bmp07
               LET g_bmb.bmb08 = sr[l_ac].bmp.bmp08
               LET g_bmb.bmb081= sr[l_ac].bmp.bmp081   #TQC-AC0183 add
               LET g_bmb.bmb082= sr[l_ac].bmp.bmp082   #TQC-AC0183 add
               LET g_bmb.bmb09 = sr[l_ac].bmp.bmp09
               LET g_bmb.bmb10 = sr[l_ac].bmp.bmp10
               LET g_bmb.bmb10_fac = sr[l_ac].bmp.bmp10_fac
               LET g_bmb.bmb10_fac2= sr[l_ac].bmp.bmp10_fac2
               LET g_bmb.bmb11 = sr[l_ac].bmp.bmp11
               LET g_bmb.bmb13 = sr[l_ac].bmp.bmp13
               LET g_bmb.bmb14 = sr[l_ac].bmp.bmp14
               LET g_bmb.bmb15 = sr[l_ac].bmp.bmp15
               LET g_bmb.bmb16 = sr[l_ac].bmp.bmp16
               LET g_bmb.bmb17 = sr[l_ac].bmp.bmp17
               LET g_bmb.bmb18 = sr[l_ac].bmp.bmp18
               LET g_bmb.bmb19 = sr[l_ac].bmp.bmp19
               LET g_bmb.bmb23 = sr[l_ac].bmp.bmp23
               LET g_bmb.bmb24 = sr[l_ac].bmp.bmp24
               LET g_bmb.bmb25 = sr[l_ac].bmp.bmp25
               LET g_bmb.bmb26 = sr[l_ac].bmp.bmp26
               LET g_bmb.bmbmodu = sr[l_ac].bmp.bmpmodu
               LET g_bmb.bmbdate = sr[l_ac].bmp.bmpdate
               LET g_bmb.bmbcomm = sr[l_ac].bmp.bmpcomm
               EXIT FOR
            END IF
            IF sr[l_i].bmo01 IS NOT NULL THEN
               CALL check_ebom(sr[l_i].bmp.bmp03,sr[l_i].bmp.bmp01,g_ver,' ') #FUN-560027 add ' '
            END IF
        END FOR
        LET b_seq = sr[l_x].bmp.bmp02
 
END FUNCTION

# Prog. Version..: '5.30.06-13.03.12(00000)'     #
DATABASE ds

GLOBALS "../../config/top.global"
DEFINE g_ccz07 VARCHAR(1)
DEFINE l_npp    RECORD LIKE npp_file.*
DEFINE l_npq    RECORD LIKE npq_file.*

DEFINE   g_chr           VARCHAR(1)
DEFINE   g_msg           VARCHAR(72)
FUNCTION t110_g_gl(p_aptype,p_apno)
   DEFINE p_aptype	LIKE apa_file.apa00
   DEFINE p_apno	LIKE apa_file.apa01
   DEFINE l_buf	 VARCHAR(70)
   DEFINE l_n  		SMALLINT

   WHENEVER ERROR CONTINUE
   IF p_apno IS NULL THEN RETURN END IF
   #modify by danny 97/05/15 若已拋轉總帳, 不可重新產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file 
    WHERE npp01 = p_apno AND nppglno != '' AND nppglno IS NOT NULL
      AND nppsys = 'AP'  AND npp00 = 1     AND npp011 = 1
   IF l_n > 0 THEN 
      CALL cl_err(p_apno,'aap-122',1) RETURN 
   END IF
   SELECT COUNT(*) INTO l_n FROM npp_file WHERE nppsys = 'AP' AND npp00 = 1
                                            AND npp01  = p_apno
                                            AND npp011 = 1 
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_apno) THEN RETURN END IF #Genero
   END IF
   DELETE FROM npp_file WHERE nppsys = 'AP' AND npp00 = 1
                          AND npp01  = p_apno
                          AND npp011 = 1 
   DELETE FROM npq_file WHERE npqsys = 'AP' AND npq00 = 1
                          AND npq01  = p_apno
                          AND npq011 = 1 
   IF p_aptype[1,1] = '1'
   THEN CALL t110_g_gl_1(p_aptype,p_apno)
   ELSE CALL t110_g_gl_2(p_aptype,p_apno)
   END IF
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION

FUNCTION t110_g_gl_1(p_aptype,p_apno)
   DEFINE p_aptype	LIKE apa_file.apa00
   DEFINE p_apno	LIKE apa_file.apa01
   DEFINE l_amt		INTEGER
   DEFINE l_amt_f	LIKE apb_file.apb24
   DEFINE l_actno       VARCHAR(20)
   DEFINE l_actno2 VARCHAR(20)
   DEFINE l_aag181      LIKE aag_file.aag181    #No:9189
   DEFINE amt1,amt2	DEC(15,3)
   DEFINE l_apa06       LIKE apa_file.apa06     #No:7871
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag21       LIKE aag_file.aag21
   DEFINE l_aag23       LIKE aag_file.aag23
   DEFINE l_apa		RECORD LIKE apa_file.*
   DEFINE l_aph		RECORD LIKE aph_file.*
   DEFINE l_api		RECORD LIKE api_file.*
   DEFINE l_apb29       LIKE apb_file.apb29
   DEFINE l_pmc03       LIKE pmc_file.pmc03,
          l_pmc903      LIKE pmc_file.pmc903

   SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = p_apno
   IF STATUS THEN RETURN END IF
   IF l_apa.apa42 = 'Y' THEN CALL cl_err("apa42=Y",'aap-165',0) RETURN END IF
   IF l_apa.apa74 = 'Y' THEN CALL cl_err('apa74=Y','aap-333',0) RETURN END IF
   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL

   #-->for 合併報表-關係人
   SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
    WHERE pmc01 = l_apa.apa05
   IF l_pmc903='Y' THEN LET l_npq.npq14=l_pmc03 CLIPPED END IF

   #-->單頭
   LET l_npp.nppsys = 'AP'
   LET l_npp.npp00  = 1
   LET l_npp.npp01  = l_apa.apa01 
   LET l_npp.npp011 = 1 
   LET l_npp.npp02  = l_apa.apa02
   LET l_npp.npp03  = NULL
   LET l_npp.npp05  = NULL
   LET l_npp.nppglno= NULL
   INSERT INTO npp_file VALUES (l_npp.*)
   IF SQLCA.sqlcode THEN 
      CALL cl_err('insert npp_file',SQLCA.sqlcode,0)
      LET g_success = 'N' 
   END IF
   #-->單身
   LET l_npq.npqsys = 'AP'
   LET l_npq.npq00  = 1
   LET l_npq.npq01  = l_apa.apa01 
   LET l_npq.npq011 = 1 
   LET l_npq.npq02  = 0  
   LET l_npq.npq21 = l_apa.apa06   #廠商編號
   LET l_npq.npq23 = l_apa.apa01   #參考單號
   LET l_npq.npq24 = l_apa.apa13   #幣別
   LET l_npq.npq25 = l_apa.apa14   #匯率
  #No.+083 010425 by plum add
   LET l_npq.npq22 = l_apa.apa07   #簡稱
  #No.+083..end
#-----------------------------------( Dr: Un-Invoice A/P )---------------------
   #--->MISC
   IF l_apa.apa51 = 'MISC' OR l_apa.apa51 = 'UNAP' THEN
      DECLARE t110_gl_c1 CURSOR FOR
              SELECT * FROM api_file WHERE api01 = p_apno
      FOREACH t110_gl_c1 INTO l_api.*
         IF STATUS THEN EXIT FOREACH END IF
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq03 = l_api.api04
         LET l_npq.npq04 = l_api.api06
         IF cl_null(l_npq.npq04) THEN LET l_npq.npq04 = l_apa.apa25 END IF
         LET l_npq.npq06 = '1'
         LET l_npq.npq07 = l_api.api05
         LET l_npq.npq07f= l_api.api05f
         #No:9189
         LET l_aag05=' ' LET l_aag21=' ' LET l_aag23=' ' LET l_aag181=' '
         SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23,l_aag181
           FROM aag_file
          WHERE aag01=l_npq.npq03
         IF l_aag23 = 'Y' THEN
            LET l_npq.npq08 = l_api.api26    # 專案
         ELSE
            LET l_npq.npq08 = null
         END IF
         IF l_aag21='Y' THEN
            LET l_npq.npq15 = l_api.api25    # 預算
         END IF
         #No:9189
         IF l_aag181 MATCHES '[23]' THEN
           #-->for 合併報表-關係人
           LET l_npq.npq14=' '
           SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            WHERE pmc01 = l_apa.apa05
           IF l_pmc903='Y' THEN LET l_npq.npq14=l_pmc03 CLIPPED END IF
         END IF
         IF l_npq.npq07 < 0 THEN
            LET l_npq.npq07 = l_npq.npq07  * -1
            LET l_npq.npq07f= l_npq.npq07f * -1
            IF l_npq.npq06 = '1'
               THEN LET l_npq.npq06 = '2'
               ELSE LET l_npq.npq06 = '1'
            END IF
         END IF
         IF l_aag05='Y' THEN
            LET l_npq.npq05 = l_api.api07
         ELSE
            LET l_npq.npq05 = ''           
         END IF
         #--NO:0004 in 99/04/26 -----#
         LET l_npq.npq11=l_api.api21
         LET l_npq.npq12=l_api.api22
         LET l_npq.npq13=l_api.api23
         LET l_npq.npq14=l_api.api24
         ##
         IF l_npq.npq07!=0 THEN 
            INSERT INTO npq_file VALUES (l_npq.*)
            MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                    l_npq.npq07
            IF STATUS THEN 
               CALL cl_err('t110_g_gl(ckp#1)',STATUS,1) 
               LET g_success='N' EXIT FOREACH  #no.5573
            END IF
         END IF
      END FOREACH
   END IF
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''

   #-->for 合併報表-關係人
   SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
    WHERE pmc01 = l_apa.apa05
   IF l_pmc903='Y' THEN LET l_npq.npq14=l_pmc03 CLIPPED END IF

   #--->STOCK
   IF l_apa.apa51 = 'STOCK' THEN
      CALL t110_stock(p_apno,l_apa.apa66) #no.6903
   END IF
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   #---->多借方多貸方
   IF cl_null(l_apa.apa51) THEN		# 9602 By roger
      DECLARE t110_gl_c41 CURSOR FOR
              SELECT apb29,apb25,apb26,apb27,apb30,SUM(apb10),SUM(apb24)
                FROM apb_file WHERE apb01 = p_apno
                 AND (apb10 != 0 OR apb27 IS NOT NULL)
               GROUP BY apb29,apb25,apb26,apb27,apb30
               ORDER BY 1,2,3
      FOREACH t110_gl_c41 INTO l_apb29,l_npq.npq03,l_npq.npq05,
                               l_npq.npq04,l_npq.npq15,l_npq.npq07,l_npq.npq07f
         IF STATUS THEN EXIT FOREACH END IF
         IF cl_null(l_actno) THEN LET l_actno = l_apa.apa51 END IF
         LET l_npq.npq02 = l_npq.npq02 + 1
         IF l_apb29 = '1' THEN LET l_npq.npq06 = '1' END IF
         IF l_apb29 = '3' THEN LET l_npq.npq06 = '2' END IF
         IF l_npq.npq07 < 0 THEN
            LET l_npq.npq07 = l_npq.npq07  * -1
            LET l_npq.npq07f= l_npq.npq07f * -1
            IF l_npq.npq06 = '1'
               THEN LET l_npq.npq06 = '2'
               ELSE LET l_npq.npq06 = '1'
            END IF
         END IF
          #No:9189
         SELECT aag05,aag21,aag23,aag181 INTO l_aag05,l_aag21,l_aag23,l_aag181
           FROM aag_file
          WHERE aag01=l_npq.npq03
         IF l_aag23='Y' THEN
            LET l_npq.npq08 = l_apa.apa66
         ELSE
            LET l_npq.npq08 = null
         END IF
         IF l_aag05='Y' THEN
            IF cl_null(l_npq.npq05) THEN
               LET l_npq.npq05 = l_apa.apa22
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF
         IF l_aag21!='Y' THEN LET l_npq.npq15=' ' END IF
         #No:9189
         IF l_aag181 MATCHES '[23]' THEN
           #-->for 合併報表-關係人
           SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            WHERE pmc01 = l_apa.apa05
           IF l_pmc903='Y' THEN LET l_npq.npq14=l_pmc03 CLIPPED END IF
         END IF
         #End
         IF l_npq.npq07!=0 THEN 
            INSERT INTO npq_file VALUES (l_npq.*)
            MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                    l_npq.npq07
            IF STATUS THEN 
               CALL cl_err('t110_g_gl(ckp#41)',STATUS,1) 
               LET g_success='N' EXIT FOREACH #no.5573
            END IF
         END IF
      END FOREACH
   END IF
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   #---->單一借方
   IF NOT cl_null(l_apa.apa51) AND l_apa.apa51 != 'UNAP' AND
      l_apa.apa51 != 'MISC' AND l_apa.apa51 != 'STOCK' THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq03 = l_apa.apa51
      LET l_npq.npq06 = '1'
      LET l_npq.npq04 = l_apa.apa25
      IF l_apa.apa57>0
         THEN LET l_npq.npq07 = l_apa.apa57
              LET l_npq.npq07f= l_apa.apa57f
         ELSE LET l_npq.npq07 = l_apa.apa31
              LET l_npq.npq07f= l_apa.apa31f
      END IF
      #No:9189
      SELECT aag05,aag23,aag181 INTO l_aag05,l_aag23,l_aag181 FROM aag_file
       WHERE aag01=l_npq.npq03
      IF l_aag23='Y' THEN
         LET l_npq.npq08 = l_apa.apa66
      ELSE
         LET l_npq.npq08 = null
      END IF
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apa.apa22
      ELSE
         LET l_npq.npq05 = ''
      END IF
      #No:9189
      IF l_aag181 MATCHES '[23]' THEN
        #-->for 合併報表-關係人
        SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
         WHERE pmc01 = l_apa.apa05
        IF l_pmc903='Y' THEN LET l_npq.npq14=l_pmc03 CLIPPED END IF
      END IF
      #End
      IF l_npq.npq07!=0 THEN 
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                 l_npq.npq07
         IF STATUS THEN
            CALL cl_err('t110_g_gl(ckp#1)',STATUS,1) 
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
#-----------------------------------( Dr: VAT tax        )---------------------
   IF l_apa.apa08 ='MISC' THEN
      SELECT SUM(apk07) INTO amt2 FROM apk_file
             WHERE apk01=l_apa.apa01 AND apk171='23'
      IF amt2 IS NULL THEN LET amt2=0 END IF
      LET amt1=l_apa.apa32+amt2
      LET l_npq.npq03 = l_apa.apa52
      IF amt1 <> 0 THEN
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq06 = '1'
         LET l_npq.npq07 = amt1
         LET l_npq.npq07f= amt1
         SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
          WHERE aag01=l_npq.npq03
         IF l_aag23='Y' THEN 
            LET l_npq.npq08 = l_apa.apa66 
         ELSE 
            LET l_npq.npq08 = null
         END IF
         IF l_aag05='Y' THEN
            LET l_npq.npq05 = l_apa.apa22
         ELSE
            LET l_npq.npq05 = ''           
         END IF
         INSERT INTO npq_file VALUES (l_npq.*)
         #no.5573
         IF STATUS THEN
            CALL cl_err('t110_g_gl(ckp#2)',STATUS,1) 
            LET g_success='N' 
         END IF
         #no.5573(end)
      END IF
      IF amt2 <> 0 THEN
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq06 = '2'
         LET l_npq.npq07 = amt2
         LET l_npq.npq07f= amt2
         SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
          WHERE aag01=l_npq.npq03
         IF l_aag23='Y' THEN 
            LET l_npq.npq08 = l_apa.apa66 
         ELSE 
            LET l_npq.npq08 = null
         END IF
         IF l_aag05='Y' THEN
            LET l_npq.npq05 = l_apa.apa22
         ELSE
            LET l_npq.npq05 = ''           
         END IF
         INSERT INTO npq_file VALUES (l_npq.*)
         #no.5573
         IF STATUS THEN
            CALL cl_err('t110_g_gl(ckp#2)',STATUS,1) 
            LET g_success='N'
         END IF
         #no.5573(end)
      END IF
   END IF
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   IF l_apa.apa08 <>'MISC' AND l_apa.apa32 > 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq03 = l_apa.apa52
      LET l_npq.npq04 = NULL
      LET l_npq.npq06 = '1'
      IF p_aptype = '12' AND g_apz.apz54 = '1' THEN
         LET l_npq.npq04 = l_apa.apa07 CLIPPED,' ',l_apa.apa08 CLIPPED,' ',
                           l_apa.apa09
      END IF
      LET l_npq.npq07 = l_apa.apa32
      LET l_npq.npq07f= l_apa.apa32f
      SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
       WHERE aag01=l_npq.npq03
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apa.apa22
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN 
            CALL cl_err('t110_g_gl(ckp#2)',SQLCA.sqlcode,1) 
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
#-----------------------------------( Cr: VAT tax allowan)---------------------
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   IF l_apa.apa61 > 0 THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq03 = l_apa.apa52
      LET l_npq.npq06 = '2'
      LET l_npq.npq07 = l_apa.apa61
      LET l_npq.npq07f= l_apa.apa61f
      SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
       WHERE aag01=l_npq.npq03
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apa.apa22
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN 
            CALL cl_err('t110_g_gl(ckp#2)',SQLCA.sqlcode,1) 
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
#-----------------------------------( Dr/Cr: Difference  )---------------------
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   IF l_apa.apa57>0 AND l_apa.apa33 != 0 AND l_apa.apa56 != '3' THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      IF l_apa.apa56 = '2' THEN 
         LET l_npq.npq03 = l_apa.apa53
      ELSE
         LET l_npq.npq03 = l_apa.apa51
      END IF
      IF l_apa.apa33 > 0
## No:2443 modify 1998/09/28 ----------------------
#        THEN LET l_npq.npq06 = '2'
         THEN LET l_npq.npq06 = '1'
              LET l_npq.npq07  = l_apa.apa33
              LET l_npq.npq07f = l_apa.apa33f
#        ELSE LET l_npq.npq06 = '1'
         ELSE LET l_npq.npq06 = '2'
              LET l_npq.npq07 = l_apa.apa33  * -1
              LET l_npq.npq07f= l_apa.apa33f * -1
      END IF
      SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
       WHERE aag01=l_npq.npq03
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apa.apa22
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN 
            CALL cl_err('g_gl(ckp#3)',SQLCA.sqlcode,1) 
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
#-----------------------------------( Cr: Pre-Paid       )---------------------
   DECLARE t110_gl_c3 CURSOR FOR
      SELECT apv03,apv04,apv04f,apa54,apa06,apa13,apa14     #No:7871
         FROM apv_file, OUTER apa_file #96-10-07
        WHERE apv01=p_apno AND apv04 > 0 AND apv03 = apa_file.apa01
   FOREACH t110_gl_c3 INTO l_npq.npq04,l_npq.npq07,l_npq.npq07f,l_npq.npq03,
                           l_apa06,l_npq.npq24,l_npq.npq25             #No:7871
     IF STATUS THEN EXIT FOREACH END IF
     IF l_npq.npq07 IS NULL THEN CONTINUE FOREACH END IF
     LET l_npq.npq02 = l_npq.npq02 + 1
     LET l_npq.npq06 = '2'
     MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
     SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
      WHERE aag01=l_npq.npq03
     IF l_aag23='Y' THEN 
        LET l_npq.npq08 = l_apa.apa66 
     ELSE 
        LET l_npq.npq08 = null
     END IF
     IF l_aag05='Y' THEN
        LET l_npq.npq05 = l_apa.apa22
     ELSE
        LET l_npq.npq05 = ''           
     END IF
     LET l_npq.npq11=''
     LET l_npq.npq12=''
     LET l_npq.npq13=''
     LET l_npq.npq14=''
     LET l_npq.npq24=l_apa06     #No:7871
     IF l_npq.npq07!=0 THEN
        INSERT INTO npq_file VALUES (l_npq.*)
        IF STATUS THEN 
           CALL cl_err('t110_g_gl(ckp#4)',STATUS,1) 
           LET g_success='N' EXIT FOREACH #no.5573
        END IF
     END IF
   END FOREACH
#-----------------------------------( Cr: 直接付款       )---------------------
   DECLARE t110_gl_c5 CURSOR FOR
           SELECT * FROM aph_file WHERE aph01=p_apno ORDER BY aph02
   FOREACH t110_gl_c5 INTO l_aph.*
      LET l_npq.npq11=''
      LET l_npq.npq12=''
      LET l_npq.npq13=''
      LET l_npq.npq14=''
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq03 = l_aph.aph04
      IF l_aph.aph03 MATCHES '[6789]' THEN
         SELECT apa54 INTO l_npq.npq03 FROM apa_file WHERE apa01=l_aph.aph04
      END IF
      LET l_npq.npq04 = NULL
      #No.B558 010518 add by linda
      IF l_aph.aph03 = "1" THEN
         CASE WHEN g_apz.apz44 = '1' 
                   LET l_npq.npq04=l_apa.apa06 CLIPPED,' ',l_apa.apa07
              WHEN g_apz.apz44 = '2' 
                   LET l_npq.npq04=l_apa.apa06 CLIPPED,' ',l_apa.apa07,' ',
                                   l_aph.aph07
         END CASE
      END IF
      #No.B558 end---
      LET l_npq.npq05 = NULL
      LET l_npq.npq06 = '2'
      LET l_npq.npq07f= l_aph.aph05f
      LET l_npq.npq07 = l_aph.aph05
##No.    modify 1998/11/13
      IF l_aph.aph03 = 'B' THEN    #貸方科目
         IF l_aph.aph08 IS NOT NULL AND l_aph.aph08 <> ' ' THEN
            LET l_npq.npq21 = l_aph.aph08
            SELECT nma02 INTO l_npq.npq22 FROM nma_file 
             WHERE nma01 = l_aph.aph08
         ELSE
            LET l_npq.npq21 = l_apa.apa06
            LET l_npq.npq22 = l_apa.apa07
         END IF
      ELSE
         LET l_npq.npq21 = l_apa.apa06
         LET l_npq.npq22 = l_apa.apa07
      END IF
##--------------------------
      IF l_npq.npq07 < 0 THEN
         LET l_npq.npq06 = '1'
         LET l_npq.npq07f= l_npq.npq07f * -1
         LET l_npq.npq07 = l_npq.npq07  * -1
      END IF
      SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
       WHERE aag01=l_npq.npq03
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apa.apa22
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS THEN 
            CALL cl_err('t110_g_gl(ckp#5)',STATUS,1) 
            LET g_success='N' EXIT FOREACH #no.5573
         END IF
      END IF
      LET l_apa.apa34f=l_apa.apa34f-l_aph.aph05f
      LET l_apa.apa34 =l_apa.apa34 -l_aph.aph05
   END FOREACH
#-----------------------------------( Cr: A/P            )---------------------
   CASE WHEN g_apz.apz55 = '1' AND l_apa.apa55 = '2' AND p_aptype = '12'
                          LET l_npq.npq04 = l_apa.apa07 CLIPPED,' ',l_apa.apa64
        WHEN g_apz.apz43 = '1' LET l_npq.npq04 =
                               l_apa.apa06 CLIPPED,' ',l_apa.apa07
        WHEN g_apz.apz43 = '2' LET l_npq.npq04 =
                            l_apa.apa06 CLIPPED,' ',l_apa.apa07,' ',l_apa.apa08
        OTHERWISE              LET l_npq.npq04 = NULL
   END CASE
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq03 = l_apa.apa54
   LET l_npq.npq06 = '2'             
   IF l_apa.apa56 = '3'
      THEN LET l_npq.npq07 = l_apa.apa34
           LET l_npq.npq07f= l_apa.apa34f
           LET l_npq.npq02 = l_npq.npq02 + 1
      ELSE IF l_apa.apa54 = 'MISC'
              THEN DECLARE t110_gl_c2 CURSOR FOR
                      SELECT * FROM api_file WHERE api01=p_apno AND api02='2'
                   FOREACH t110_gl_c2 INTO l_api.*
                      IF STATUS THEN EXIT FOREACH END IF
                      LET l_npq.npq02 = l_npq.npq02 + 1
                      LET l_npq.npq03 = l_api.api04
                      LET l_npq.npq04 = l_api.api06
                      LET l_npq.npq07 = l_api.api05
                      LET l_npq.npq07f= l_api.api05f 
                      SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23
                        FROM aag_file WHERE aag01=l_npq.npq03
                      IF l_aag05='Y' THEN
                         LET l_npq.npq05 = l_apa.apa22
                      ELSE
                         LET l_npq.npq05 = ''           
                      END IF
                      IF l_aag21!='Y' THEN LET l_npq.npq15 = ' ' END IF    
                      IF l_npq.npq07!=0 THEN
                         INSERT INTO npq_file VALUES (l_npq.*)
                         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                                     l_npq.npq06,' ',l_npq.npq07
                         IF STATUS THEN 
                            CALL cl_err('t110_g_gl(ckp#1)',STATUS,1)
                            LET g_success='N' EXIT FOREACH #no.5573
                         END IF
                      END IF
                   END FOREACH
              ELSE LET l_npq.npq07 = l_apa.apa34
                   LET l_npq.npq07f= l_apa.apa34f
                   LET l_npq.npq02 = l_npq.npq02 + 1
           END IF
   END IF
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   IF l_apa.apa56 = '3' OR l_apa.apa54 != 'MISC' THEN
     MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
   SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23
     FROM aag_file WHERE aag01=l_npq.npq03
   IF l_aag23='Y' THEN 
      LET l_npq.npq08 = l_apa.apa66 
   ELSE 
      LET l_npq.npq08 = null
   END IF
   IF l_aag05='Y' THEN
      LET l_npq.npq05 = l_apa.apa22
   ELSE
      LET l_npq.npq05 = ''           
   END IF
   IF l_aag21!='Y' THEN LET l_npq.npq15 = ' ' END IF    
         IF l_npq.npq07 < 0 THEN
            LET l_npq.npq07 = l_npq.npq07  * -1
            LET l_npq.npq07f= l_npq.npq07f * -1
            IF l_npq.npq06 = '1'
               THEN LET l_npq.npq06 = '2'
               ELSE LET l_npq.npq06 = '1'
            END IF
         END IF
     IF l_npq.npq07!=0 THEN
        INSERT INTO npq_file VALUES (l_npq.*)
        IF STATUS THEN 
           CALL cl_err('t110_g_gl(ckp#4)',STATUS,1) 
           LET g_success='N' #no.5573
        END IF
     END IF
   END IF
#------------------------------------------------------------------------------
END FUNCTION

FUNCTION t110_g_gl_2(p_aptype,p_apno)
   DEFINE p_aptype	LIKE apa_file.apa00
   DEFINE p_apno	LIKE apa_file.apa01
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag23       LIKE aag_file.aag23
   DEFINE l_apa		RECORD LIKE apa_file.*

   SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = p_apno
   IF STATUS THEN RETURN END IF
   IF l_apa.apa56 = '3' THEN RETURN END IF
   IF l_apa.apa42 = 'Y' THEN CALL cl_err("apa42=Y",'aap-165',0) RETURN END IF
   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL
#-----------------------------------( Dr: Un-Invoice ALW )---------------------
   #-->單頭
   LET l_npp.nppsys = 'AP'
   LET l_npp.npp00  = 1
   LET l_npp.npp01  = l_apa.apa01 
   LET l_npp.npp011 = 1 
   LET l_npp.npp02  = l_apa.apa02
   LET l_npp.npp03  = NULL
   LET l_npp.npp05  = NULL
   LET l_npp.nppglno= NULL
   INSERT INTO npp_file VALUES (l_npp.*)
   IF SQLCA.sqlcode THEN 
      CALL cl_err('insert npp_file',SQLCA.sqlcode,0)
      LET g_success = 'N' 
   END IF
   #-->單身
   LET l_npq.npqsys = 'AP'
   LET l_npq.npq00  = 1
   LET l_npq.npq011 = 1 
   LET l_npq.npq01 = l_apa.apa01
   LET l_npq.npq02 = 1
   LET l_npq.npq03 = l_apa.apa54       #85-09-30
   LET l_npq.npq04 = NULL
  #No.+083 010425 by plum add
   LET l_npq.npq24 = l_apa.apa13       #幣別
  #No.+083..end

  #LET l_npq.npq05 = l_apa.apa22
   SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
    WHERE aag01=l_npq.npq03
   IF l_aag23='Y' THEN 
      LET l_npq.npq08 = l_apa.apa66 
   ELSE 
      LET l_npq.npq08 = null
   END IF
   IF l_aag05='Y' THEN
      LET l_npq.npq05 = l_apa.apa22
   ELSE
      LET l_npq.npq05 = ''           
   END IF
   LET l_npq.npq06 = '1'
   LET l_npq.npq07 = l_apa.apa34
   LET l_npq.npq07f= l_apa.apa34f
   LET l_npq.npq25 = l_apa.apa14
   IF l_apa.apa06 = 'MISC' OR l_apa.apa06 = 'UNAP' OR l_apa.apa06 = 'EMPL'
      THEN LET l_npq.npq21 = l_apa.apa07
      ELSE LET l_npq.npq21 = l_apa.apa06
   END IF
   LET l_npq.npq22 = l_apa.apa07
   IF l_npq.npq07!=0 THEN
      INSERT INTO npq_file VALUES (l_npq.*)
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN 
         CALL cl_err('t110_g_gl(ckp#5)',SQLCA.sqlcode,1) 
         LET g_success='N' #no.5573
      END IF
   END IF
#-----------------------------------( Dr/Cr: Diff        )---------------------
   IF l_apa.apa33 != 0 THEN
   LET l_npq.npq02 = l_npq.npq02 + 1
   LET l_npq.npq03 = l_apa.apa51
   LET l_npq.npq04 = NULL
   IF l_apa.apa33 > 0
      THEN LET l_npq.npq06 = '1'
           LET l_npq.npq07 = l_apa.apa33
           LET l_npq.npq07f= l_apa.apa33f
      ELSE LET l_npq.npq06 = '2'
           LET l_npq.npq07 = l_apa.apa33 * -1
           LET l_npq.npq07f= l_apa.apa33f* -1
   END IF
   SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
    WHERE aag01=l_npq.npq03
   IF l_aag23='Y' THEN 
      LET l_npq.npq08 = l_apa.apa66 
   ELSE 
      LET l_npq.npq08 = null
   END IF
   IF l_aag05='Y' THEN
      LET l_npq.npq05 = l_apa.apa22
   ELSE
      LET l_npq.npq05 = ''           
   END IF
   IF l_npq.npq07!=0 THEN 
      INSERT INTO npq_file VALUES (l_npq.*)
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN 
         CALL cl_err('t110_g_gl(ckp#3)',SQLCA.sqlcode,1) 
         LET g_success='N' #no.5573
      END IF
   END IF
   END IF
#-----------------------------------( Cr: ALW            )---------------------
   #no.6903
   IF l_apa.apa51 = 'STOCK' THEN
      CALL t110_stock(p_apno,l_apa.apa66) 
   END IF
   #no.6903(end)
   IF l_apa.apa51 !='STOCK' THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq03 = l_apa.apa51         #85-09-30
      CASE WHEN g_apz.apz43 = '1' LET l_npq.npq04 =
                                  l_apa.apa06 CLIPPED,' ',l_apa.apa07
           WHEN g_apz.apz43 = '2' LET l_npq.npq04 =
                               l_apa.apa06 CLIPPED,' ',l_apa.apa07,' ',l_apa.apa08
           OTHERWISE              LET l_npq.npq04 = NULL
      END CASE
      LET l_npq.npq06 = '2'
      LET l_npq.npq07 = l_apa.apa31
      LET l_npq.npq07f= l_apa.apa31f
      SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
       WHERE aag01=l_npq.npq03
      IF l_aag23='Y' THEN 
         LET l_npq.npq08 = l_apa.apa66 
      ELSE 
         LET l_npq.npq08 = null
      END IF
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apa.apa22
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      IF l_npq.npq07!=0 THEN
         INSERT INTO npq_file VALUES (l_npq.*)
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN 
            CALL cl_err('t110_g_gl(ckp#6)',SQLCA.sqlcode,1) 
            LET g_success='N' #no.5573
         END IF
      END IF
   END IF
#-----------------------------------( Cr: VAT TAX        )---------------------
   IF l_apa.apa32 > 0 THEN
   LET l_npq.npq02 = l_npq.npq02 + 1
   LET l_npq.npq03 = l_apa.apa52
   LET l_npq.npq04 = NULL
   LET l_npq.npq07 = l_apa.apa32
   LET l_npq.npq07f= l_apa.apa32f
   SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
    WHERE aag01=l_npq.npq03
   IF l_aag23='Y' THEN 
      LET l_npq.npq08 = l_apa.apa66 
   ELSE 
      LET l_npq.npq08 = null
   END IF
   IF l_aag05='Y' THEN
      LET l_npq.npq05 = l_apa.apa22
   ELSE
      LET l_npq.npq05 = ''           
   END IF
   IF l_npq.npq07!=0 THEN
      INSERT INTO npq_file VALUES (l_npq.*)
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN 
         CALL cl_err('t110_g_gl(ckp#7)',SQLCA.sqlcode,1) 
         LET g_success='N' #no.5573
      END IF
   END IF
   END IF
#------------------------------------------------------------------------------
END FUNCTION

#no.6903
FUNCTION t110_stock(p_apa01,p_apa66)
  DEFINE l_amt	       INTEGER
  DEFINE l_amt_f       LIKE apb_file.apb24
  DEFINE l_apb29       VARCHAR(1)
  DEFINE l_actno       VARCHAR(20)
  DEFINE l_deptno      VARCHAR(20)
  DEFINE l_apb12       VARCHAR(20)
  DEFINE l_apb08       DEC(15,3)
  DEFINE l_apb09       DEC(15,3)
  DEFINE l_ware,l_loc  VARCHAR(10)
  DEFINE l_aag05       LIKE aag_file.aag05
  DEFINE l_aag21       LIKE aag_file.aag21
  DEFINE l_aag23       LIKE aag_file.aag23
  DEFINE p_apa66       LIKE apa_file.apa66
  DEFINE p_apa01       LIKE apa_file.apa01

  DECLARE t110_gl_c4 CURSOR FOR
       SELECT apb10,apb29,apb25,apb26,apb12,apb09,apb08,apb24,rvv32,rvv33
         FROM apb_file, OUTER rvv_file
        WHERE apb01 = p_apa01 AND apb10 != 0
          AND apb21 = rvv01  AND apb22=rvv02
  FOREACH t110_gl_c4 INTO l_amt,l_apb29,l_actno,l_deptno,
                          l_apb12,l_apb09,l_apb08,l_amt_f,l_ware,l_loc
     IF STATUS THEN EXIT FOREACH END IF
     IF cl_null(l_actno) THEN
        LET l_actno = t110_stock_act(l_apb12,l_ware,l_loc) #no.6903
     END IF
     LET l_npq.npq02 = l_npq.npq02 + 1
     LET l_npq.npq03 = l_actno
     LET l_npq.npq04 = NULL
    #LET l_npq.npq04 = l_apb12 CLIPPED,l_apb09 USING ' <<<<<<<',
    #                            '*@',l_apb08 USING '####&.&&'
     IF l_apb29 = '1' THEN LET l_npq.npq06 = '1' END IF
     IF l_apb29 = '3' THEN LET l_npq.npq06 = '2' END IF
     LET l_npq.npq07 = l_amt
     LET l_npq.npq07f= l_amt_f
     SELECT aag05,aag23 INTO l_aag05,l_aag23 FROM aag_file
      WHERE aag01=l_npq.npq03
     IF l_aag23='Y' THEN 
        LET l_npq.npq08 = p_apa66
     ELSE 
        LET l_npq.npq08 = null
     END IF
     IF l_aag05='Y' THEN
        LET l_npq.npq05 = l_deptno
     ELSE
        LET l_npq.npq05 = ''           
     END IF
     IF l_npq.npq07!=0 THEN 
        INSERT INTO npq_file VALUES (l_npq.*)
        MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                 l_npq.npq07
        IF STATUS THEN 
           CALL cl_err('t110_g_gl(ckp#1)',STATUS,1) 
           LET g_success='N' EXIT FOREACH  #no.5573
        END IF
     END IF
  END FOREACH
END FUNCTION

FUNCTION t110_stock_act(p_item,p_ware,p_loc)
  DEFINE p_item   LIKE ima_file.ima01
  DEFINE p_ware   LIKE ime_file.ime01
  DEFINE p_loc    LIKE ime_file.ime02
  DEFINE l_actno  LIKE aag_file.aag01

  SELECT ccz07 INTO g_ccz07 FROM ccz_file WHERE ccz00='0'

  CASE WHEN g_ccz07='1' SELECT ima39 INTO l_actno FROM ima_file
                         WHERE ima01=p_item
       WHEN g_ccz07='2' SELECT imz39 INTO l_actno
                          FROM ima_file,imz_file
                         WHERE ima01=p_item AND ima06=imz01
       WHEN g_ccz07='3' SELECT imd08 INTO l_actno FROM imd_file
                         WHERE imd01=p_ware
       WHEN g_ccz07='4' SELECT ime09 INTO l_actno FROM ime_file
                         WHERE ime01=p_ware AND ime02=p_loc
       OTHERWISE        LET l_actno='STOCK'
  END CASE
  RETURN l_actno
END FUNCTION

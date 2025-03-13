# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_chknpq2.4gl
# Descriptions...: 
# Date & Author..: 
# Input Parameter: 
# Return code....: 
# Memo...........: 本程式與s_chknpq 不同在於不要有單別是否產生分錄的判斷
#                  (anmt400/anmt420)在使用
# Modify.........: No.FUN-4C0031 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify ........: No.FUN-560060 05/06/15 By wujie 單據編號加大返工
# Modify ........: No.FUN-670047 06/08/15 By elva 多帳套修改
# Modify.........: No.FUN-680147 06/09/10 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810045 08/03/05 By rainy 項目管理:專案相關Table gja_file 改為 pja_file
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.CHI-9A0012 09/10/15 By sabrina 增加第5~11組異動碼管理
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
   DEFINE g_nmz02p     LIKE nmz_file.nmz02p
   DEFINE g_dbs_gl     LIKE type_file.chr21         #No.FUN-680147 VARCHAR(21)
   DEFINE g_aaz72      LIKE aaz_file.aaz72          #No.FUN-680147 VARCHAR(01)
   DEFINE g_bookno     LIKE aza_file.aza81          #No.FUN-730020
END GLOBALS
 
# 檢查分錄底稿正確否
FUNCTION s_chknpq2(p_no,p_sys,p_cat,p_npq011,p_npptype,p_bookno)   #FUN-670047  #No.FUN-730020
   DEFINE p_no		LIKE npq_file.npq01         #No.FUN-680147 VARCHAR(20) # 單號
   DEFINE p_sys		LIKE npq_file.npqsys        # Prog. Version..: '5.30.06-13.03.12(02) # 系統別:AP/AR/NM
   DEFINE p_cat	        LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE p_npq011      LIKE npq_file.npq011
   DEFINE p_npptype     LIKE npp_file.npptype   #FUN-670047
   DEFINE p_bookno      LIKE aag_file.aag00         #No.FUN-730020
   DEFINE amtd,amtc	LIKE npq_file.npq07     # FUN-4C0031
   DEFINE l_t1		LIKE oay_file.oayslip       #No.FUN-680147 VARCHAR(5) #No.FUN-560060
   DEFINE l_dmy3	LIKE type_file.chr1          #No.FUN-680147 VARCHAR(01)
   DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
   DEFINE n1,n2		LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE l_cnt         LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE g_pmc903      LIKE pmc_file.pmc903    #CHI-9A0012 add
   DEFINE g_occ37       LIKE occ_file.occ37     #CHI-9A0012 add
   DEFINE l_pmc903      LIKE pmc_file.pmc903    #CHI-9A0012 add
   DEFINE ls_code       LIKE ze_file.ze01       #CHI-9A0012 add
   DEFINE ls_ze03       LIKE ze_file.ze03       #CHI-9A0012 add
   DEFINE l_npq         RECORD
                        npq03  LIKE npq_file.npq03,
                        npq05  LIKE npq_file.npq05,
                        npq11  LIKE npq_file.npq11,
                        npq12  LIKE npq_file.npq12,
                        npq13  LIKE npq_file.npq13,
                        npq14  LIKE npq_file.npq14,
                        npq08  LIKE npq_file.npq08,
                        aag05  LIKE aag_file.aag05,
                        aag151 LIKE aag_file.aag151,
                        aag161 LIKE aag_file.aag161,
                        aag171 LIKE aag_file.aag171,
                        aag181 LIKE aag_file.aag181,
                        aag23  LIKE aag_file.aag23,
                        aag311 LIKE aag_file.aag311,   #CHI-9A0012 add
                        aag321 LIKE aag_file.aag321,   #CHI-9A0012 add
                        aag331 LIKE aag_file.aag331,   #CHI-9A0012 add
                        aag341 LIKE aag_file.aag341,   #CHI-9A0012 add
                        aag351 LIKE aag_file.aag351,   #CHI-9A0012 add
                        aag361 LIKE aag_file.aag361,   #CHI-9A0012 add
                        aag371 LIKE aag_file.aag371,   #CHI-9A0012 add
                        npq31  LIKE npq_file.npq31,    #CHI-9A0012 add
                        npq32  LIKE npq_file.npq32,    #CHI-9A0012 add
                        npq33  LIKE npq_file.npq33,    #CHI-9A0012 add
                        npq34  LIKE npq_file.npq34,    #CHI-9A0012 add
                        npq35  LIKE npq_file.npq35,    #CHI-9A0012 add
                        npq36  LIKE npq_file.npq36,    #CHI-9A0012 add
                        npq37  LIKE npq_file.npq37     #CHI-9A0012 add
                        END RECORD
 
   LET g_bookno = p_bookno  #No.FUN-730020
   SELECT nmz02p INTO g_nmz02p FROM nmz_file WHERE nmz00 = '0'
   LET g_plant_new = g_nmz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new 
#-->取總帳系統參數
   LET l_sql = "SELECT aaz72  FROM ",g_dbs_gl CLIPPED,
               "aaz_file WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   PREPARE chk2_pregl FROM l_sql
   DECLARE chk2_curgl CURSOR FOR chk2_pregl
   OPEN chk2_curgl 
   FETCH chk2_curgl INTO g_aaz72 
   IF SQLCA.sqlcode THEN LET g_aaz72 = '1' END IF
 
   LET g_success='Y'
   SELECT sum(npq07) INTO amtd FROM npq_file 
          WHERE npq01 = p_no AND npq06 = '1' #--->借方合計
            AND npqsys = p_sys AND npq00 = p_cat AND npq011 = p_npq011 
            AND npqtype = p_npptype #FUN-670047
   IF STATUS THEN CALL cl_err('sel sum(npq07)',STATUS,1)LET g_success='N'END IF
   SELECT sum(npq07) INTO amtc FROM npq_file 
          WHERE npq01 = p_no AND npq06 = '2' #--->貸方合計
            AND npqsys = p_sys AND npq00 = p_cat AND npq011 = p_npq011
            AND npqtype = p_npptype #FUN-670047
   IF STATUS THEN CALL cl_err('sel sum(npq07)',STATUS,1)LET g_success='N'END IF
   IF amtd IS NULL THEN LET amtd = 0 END IF 
   IF amtc IS NULL THEN LET amtc = 0 END IF 
   #-->必須要有分錄
   IF (amtd = 0 OR amtc=0) THEN
      CALL cl_err(p_no,'aap-261',1) LET g_success='N'
   END IF
   #-->借貸要平
   IF amtd != amtc THEN
      CALL cl_err(p_no,'aap-058',1) LET g_success='N'
   END IF
   #-->科目要對
   SELECT COUNT(*) INTO n1 FROM npq_file
        WHERE npq01=p_no AND npqsys=p_sys AND npq00=p_cat AND npq011 = p_npq011
          AND npqtype = p_npptype #FUN-670047
   SELECT COUNT(*) INTO n2 FROM npq_file,aag_file
          WHERE npq01 = p_no AND npqsys = p_sys AND npq00 = p_cat
            AND npq011= p_npq011
            AND npq03=aag01 AND aag03='2' AND aag07 IN ('2','3')
            AND npqtype = p_npptype #FUN-670047
            AND aag00 = p_bookno   #No.FUN-730020
   IF n1<>n2 THEN
      CALL cl_err(p_no,'aap-262',1) LET g_success='N'
   END IF
   #-->檢查異動碼輸入否
   # 2.必須輸入, 不檢查  3.必須輸入, 須檢查
   DECLARE npq_curs CURSOR FOR
    SELECT npq03,npq05,npq11,npq12,npq13,npq14,npq08,
           aag05,aag151,aag161,aag171,aag181,aag23,
           aag311,aag321,aag331,aag341,aag351,aag361,aag371,        #CHI-9A0012 add
           npq31,npq32,npq33,npq34,npq35,npq36,npq37                #CHI-9A0012 add
      FROM npq_file,aag_file
     WHERE npqsys = p_sys AND npq01 = p_no AND aag01 = npq03 
       AND npq00 = p_cat  AND npq011 = p_npq011 
       AND npqtype = p_npptype #FUN-670047
       AND aag00 = p_bookno    #No.FUN-730020
   FOREACH npq_curs INTO l_npq.*
       #--> ( 若科目有部門管理者,應check部門欄位 )
       IF l_npq.aag05='Y' THEN  #部門明細管理
          IF cl_null(l_npq.npq05) THEN 
             LET g_success='N'
             CALL cl_err(l_npq.npq03,'aap-287',1)
          END IF
          #-->若有部門管理應Check其部門是否為拒絕部門
          IF g_aaz72 = '2' THEN 
               SELECT COUNT(*) INTO l_cnt FROM aab_file 
                WHERE aab01 = l_npq.npq03   #科目
                  AND aab02 = l_npq.npq05   #部門
                  AND aab00 = p_bookno      #No.FUN-730020
               IF l_cnt = 0 THEN
                  LET g_success='N'
                  CALL cl_err(l_npq.npq03,'agl-209',1)
               END IF
          ELSE SELECT COUNT(*) INTO l_cnt FROM aab_file 
                WHERE aab01 = l_npq.npq03   #科目
                  AND aab02 = l_npq.npq05   #部門
                  AND aab00 = p_bookno      #No.FUN-730020
               IF l_cnt > 0 THEN
                  LET g_success='N'
                  CALL cl_err(l_npq.npq03,'agl-207',1)
               END IF
          END IF
       END IF
       IF l_npq.aag151 MATCHES '[23]' AND cl_null(l_npq.npq11) OR
          l_npq.aag161 MATCHES '[23]' AND cl_null(l_npq.npq12) OR
          l_npq.aag171 MATCHES '[23]' AND cl_null(l_npq.npq13) OR
          l_npq.aag181 MATCHES '[23]' AND cl_null(l_npq.npq14) THEN
          CALL cl_err(l_npq.npq03,'anm-147',1) LET g_success = 'N' 
       END IF
 
      #若科目須做專案管理，專案編號不可空白(modi in 01/09/14 no.3565)
      IF l_npq.aag23 = 'Y' THEN
         IF cl_null(l_npq.npq08) THEN
            LET g_success='N'
            CALL cl_err('','agl-922',1)
         ELSE
         #SELECT * FROM gja_file WHERE gja01 = l_npq.npq08 AND gjaacti = 'Y'   #FUN-810045
         SELECT * FROM pja_file WHERE pja01 = l_npq.npq08 AND pjaacti = 'Y'    #FUN-810045
                                  AND pjaclose = 'N'                           #FUN-960038
         IF STATUS = 100 THEN
            LET g_success='N'
            CALL cl_err(l_npq.npq03,'apj-005',1)
         END IF
         END IF
      END IF
 
       #異動碼一
       IF l_npq.aag151 = '3' AND NOT cl_null(l_npq.npq11) THEN
          CALL s_chknpq_aee(l_npq.npq03,'1',l_npq.npq11)
       END IF
       #異動碼二
       IF l_npq.aag161 = '3' AND NOT cl_null(l_npq.npq12) THEN
          CALL s_chknpq_aee(l_npq.npq03,'2',l_npq.npq12)
       END IF
       #異動碼三
       IF l_npq.aag171 = '3' AND NOT cl_null(l_npq.npq13) THEN
          CALL s_chknpq_aee(l_npq.npq03,'3',l_npq.npq13)
       END IF
       #異動碼四
       IF l_npq.aag181 = '3' AND NOT cl_null(l_npq.npq14) THEN
          CALL s_chknpq_aee(l_npq.npq03,'4',l_npq.npq14)
       END IF
    #CHI-9A0012---add---start---
       #異動碼五
       IF l_npq.aag311 = '3' AND NOT cl_null(l_npq.npq31) THEN 
          CALL s_chknpq_aee(l_npq.npq03,'5',l_npq.npq31)
       END IF
       #異動碼六
       IF l_npq.aag321 = '3' AND NOT cl_null(l_npq.npq32) THEN 
          CALL s_chknpq_aee(l_npq.npq03,'6',l_npq.npq32)   
       END IF
       #異動碼七
       IF l_npq.aag331 = '3' AND NOT cl_null(l_npq.npq33) THEN 
          CALL s_chknpq_aee(l_npq.npq03,'7',l_npq.npq33)
       END IF
       #異動碼八
       IF l_npq.aag341 = '3' AND NOT cl_null(l_npq.npq34) THEN 
          CALL s_chknpq_aee(l_npq.npq03,'8',l_npq.npq34)
       END IF
       #異動碼九
       IF l_npq.aag351 = '3' AND NOT cl_null(l_npq.npq35) THEN 
          CALL s_chknpq_aee(l_npq.npq03,'9',l_npq.npq35)
       END IF
       #異動碼十
       IF l_npq.aag361 = '3' AND NOT cl_null(l_npq.npq36) THEN 
          CALL s_chknpq_aee(l_npq.npq03,'10',l_npq.npq36)
       END IF
       #異動碼十一
       IF l_npq.aag371 = '3' AND NOT cl_null(l_npq.npq37) THEN 
          CALL s_chknpq_aee(l_npq.npq03,'99',l_npq.npq37)
       END IF
    #CHI-9A0012---add---end---
   END FOREACH
END FUNCTION
 
FUNCTION s_chknpq_aee(p_key1,p_key2,p_key3)
   DEFINE p_key1    LIKE aee_file.aee01,
          p_key2    LIKE aee_file.aee02,
          p_key3    LIKE aee_file.aee03,
          l_aee04   LIKE aee_file.aee04,
          l_aeeacti LIKE aee_file.aeeacti
 
   SELECT aee04,aeeacti INTO l_aee04,l_aeeacti FROM aee_file
    WHERE aee01 = p_key1 AND aee02 = p_key2 AND aee03 = p_key3
      AND aee00 = g_bookno  #No.FUN-730020
   IF STATUS = 100 THEN 
      CALL cl_err(p_key3,'agl-153',1) LET g_success = 'N' RETURN
   END IF
   IF l_aeeacti = 'N' THEN 
      CALL cl_err(p_key3,'9027',1) LET g_success = 'N' RETURN
   END IF
END FUNCTION

# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_chknpq1.4gl
# Descriptions...: 
# Date & Author..: 
# Input Parameter: 
# Return code....: 
# Modify.........: No.FUN-4C0031 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.FUN-560060 05/06/15 By wujie 單據編號加大返工
# Modify ........: No.FUN-670047 06/08/15 By elva 多帳套修改
# Modify.........: No.FUN-680147 06/09/10 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-810045 08/03/05 By rainy 項目管理:專案相關Table gja_file 改為 pja_file
# Modify.........: No.MOD-870074 08/07/10 By Sarah 信用狀修改(npq00=6)無任何費用時,確認時不需檢核aap-266訊息
# Modify.........: No.MOD-870127 08/07/11 By Sarah 信用狀修改(npq00=7)無任何費用時,確認時不需檢核aap-266訊息
# Modify.........: No.FUN-960038 09/09/04 By chenmoyan 專案加上'結案'的判斷
# Modify.........: No.CHI-9A0012 09/10/15 By sabrina 增加第5~11組異動碼管理
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
GLOBALS
   DEFINE g_apz02p     LIKE apz_file.apz02p
   DEFINE g_dbs_gl     LIKE type_file.chr21         #No.FUN-680147 VARCHAR(21)
   DEFINE g_aaz72      LIKE aaz_file.aaz72          #No.FUN-680147 VARCHAR(01)
END GLOBALS
 
FUNCTION s_chknpq1(p_no,p_npq011,p_npq00,p_npptype,p_bookno)   # 檢查分錄底稿正確否(外購用) #FUN-670047  #No.FUN-730020
   DEFINE p_no		LIKE npq_file.npq01         #No.FUN-680147 VARCHAR(20) # 單號
   DEFINE p_npq011      LIKE type_file.num5         #No.FUN-680147 SMALLINT         
   DEFINE p_npq00       LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE p_npptype     LIKE npp_file.npptype   #FUN-670047
   DEFINE p_bookno    LIKE aag_file.aag00     #No.FUN-730020
   DEFINE amtd,amtc	LIKE npq_file.npq07     # FUN-4C0031
   DEFINE l_t1		LIKE oay_file.oayslip       #No.FUN-680147 VARCHAR(5)     #No.FUN-560060
   DEFINE l_sql	        LIKE type_file.chr1000      #No.FUN-680147 VARCHAR(1000)
   DEFINE n1,n2,l_cnt   LIKE type_file.num5         #No.FUN-680147 SMALLINT
   DEFINE l_npq RECORD LIKE npq_file.*
   DEFINE l_aag RECORD LIKE aag_file.*
   DEFINE p_sys         LIKE npq_file.npqsys    #CHI-9A0012   # 系統別:AP/AR/NM/FA
   DEFINE g_pmc903      LIKE pmc_file.pmc903    #CHI-9A0012
   DEFINE l_pmc903      LIKE pmc_file.pmc903    #CHI-9A0012
   DEFINE g_occ37       LIKE occ_file.occ37     #CHI-9A0012
 
 
   SELECT apz02p INTO g_apz02p FROM apz_file WHERE apz00 = '0'
   LET g_plant_new = g_apz02p
   CALL s_getdbs()
   LET g_dbs_gl = g_dbs_new 
#-->取總帳系統參數
   LET l_sql = "SELECT aaz72  FROM ",g_dbs_gl CLIPPED,
               "aaz_file WHERE aaz00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
   PREPARE chk1_pregl FROM l_sql
   DECLARE chk1_curgl CURSOR FOR chk1_pregl
   OPEN chk1_curgl 
   FETCH chk1_curgl INTO g_aaz72 
   IF SQLCA.sqlcode THEN LET g_aaz72 = '1' END IF
 
 
   SELECT sum(npq07) INTO amtd FROM npq_file 
          WHERE npq01 = p_no AND npq06 = '1' #--->借方合計
            AND npq011= p_npq011 AND npq00=p_npq00
            AND npqtype = p_npptype #FUN-670047
   IF STATUS THEN CALL cl_err('sel sum(npq07)',STATUS,1)LET g_success='N'END IF
   SELECT sum(npq07) INTO amtc FROM npq_file 
          WHERE npq01 = p_no AND npq06 = '2' #--->貸方合計
            AND npq011=p_npq011 AND npq00=p_npq00
            AND npqtype = p_npptype #FUN-670047
   IF STATUS THEN CALL cl_err('sel sum(npq07)',STATUS,1)LET g_success='N'END IF
   IF amtd IS NULL THEN LET amtd = 0 END IF 
   IF amtc IS NULL THEN LET amtc = 0 END IF 
   #-->必須要有分錄
  #IF (amtd = 0 OR amtc=0) THEN                  #MOD-870074 mark
  #IF p_npq00!=6 AND (amtd = 0 OR amtc=0) THEN   #MOD-870074                  #MOD-870127 mark
   IF p_npq00!=6 AND p_npq00!=7 AND (amtd = 0 OR amtc=0) THEN   #MOD-870074   #MOD-870127
      CALL cl_err(p_no,'aap-266',1) LET g_success='N'
   END IF
   #-->借貸要平
   IF amtd != amtc THEN
      CALL cl_err(p_no,'aap-058',1) LET g_success='N'
   END IF
   #-->科目要對
   SELECT COUNT(*) INTO n1 FROM npq_file
          WHERE npq01 = p_no AND npq011= p_npq011 AND npq00=p_npq00
            AND npqtype = p_npptype #FUN-670047
   SELECT COUNT(*) INTO n2 FROM npq_file,aag_file
          WHERE npq01 = p_no AND npq011= p_npq011 AND npq00=p_npq00
            AND npq03=aag01 AND aag03='2' AND aag07 IN ('2','3')
            AND npqtype = p_npptype #FUN-670047
            AND aag00=p_bookno  #No.FUN-730020
   IF n1<>n2 THEN
      CALL cl_err(p_no,'aap-262',1) LET g_success='N'
   END IF
 
## No:2406 modify 1998/08/26 ----------------------------
   DECLARE npq_cur CURSOR FOR
    SELECT npq_file.*,aag_file.*
      FROM npq_file,OUTER aag_file 
     WHERE npq01 = p_no 
       AND npq00 = p_npq00
       AND npq011 = p_npq011
       AND npq_file.npq03=aag_file.aag01 AND aag_file.aag00=p_bookno  #No.FUN-730020
       AND npqtype = p_npptype #FUN-670047
   IF STATUS THEN CALL cl_err('decl cursor',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
   
   FOREACH npq_cur INTO l_npq.*,l_aag.*
 
## ( 若科目有部門管理者,應check部門欄位 )
      IF l_aag.aag05='Y' THEN #部門明細管理
         IF cl_null(l_npq.npq05) THEN 
            LET g_success='N'
            CALL cl_err(l_npq.npq03,'aap-287',1)
         END IF
##No.2874 modify 1998/12/01 若有部門管理應Check其部門是否為拒絕部門
         IF g_aaz72 = '2' THEN 
             SELECT COUNT(*) INTO l_cnt FROM aab_file 
              WHERE aab01 = l_npq.npq03   #科目
                AND aab02 = l_npq.npq05   #部門
                AND aab00 = p_bookno      #No.FUN-730020
             IF l_cnt = 0 THEN
                LET g_success='N'
                CALL cl_err(l_npq.npq03,'agl-209',1)
             END IF
         ELSE 
             SELECT COUNT(*) INTO l_cnt FROM aab_file 
              WHERE aab01 = l_npq.npq03   #科目
                AND aab02 = l_npq.npq05   #部門
                AND aab00 = p_bookno      #No.FUN-730020
             IF l_cnt > 0 THEN
                LET g_success='N'
                CALL cl_err(l_npq.npq03,'agl-207',1)
             END IF
         END IF
      END IF
 
      #若科目須做專案管理，專案編號不可空白(modi in 01/09/14 no.3565)
      IF l_aag.aag23 = 'Y' THEN
         IF cl_null(l_npq.npq08) THEN
            LET g_success='N'
            CALL cl_err(l_npq.npq03,'agl-922',1)
         ELSE
         #SELECT * FROM gja_file WHERE gja01 = l_npq.npq08 AND gjaacti = 'Y'  #FUN-810045
         SELECT * FROM pja_file WHERE pja01 = l_npq.npq08 AND pjaacti = 'Y'   #FUN-810045
                                  AND pjaclose = 'N'                          #No.FUN-960038
         IF STATUS = 100 THEN
            LET g_success='N'
            CALL cl_err(l_npq.npq03,'apj-005',1)
         END IF
         END IF
      END IF
 
## ( 若科目有異動碼管理者,應check異動碼欄位 )
      IF (l_aag.aag151='2' OR     #異動碼-1控制方式 
         l_aag.aag151='3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq11)     #   2.必須輸入,不需檢查 
         THEN                 #   3.必須輸入, 必須檢查
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag161='2' OR     #異動碼-1控制方式 
         l_aag.aag161='3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq12)     #   2.必須輸入,不需檢查 
         THEN                 #   3.必須輸入, 必須檢查
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag171='2' OR     #異動碼-1控制方式 
         l_aag.aag171='3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq13)     #   2.必須輸入,不需檢查 
         THEN                 #   3.必須輸入, 必須檢查
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag181='2' OR     #異動碼-1控制方式 
         l_aag.aag181='3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq14)     #   2.必須輸入,不需檢查 
         THEN                 #   3.必須輸入, 必須檢查
         LET g_success='N'
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
    #CHI-9A0012---add---start---
      IF (l_aag.aag311 = '2' OR     #異動碼-1控制方式 
         l_aag.aag311 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq31)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_success = "N"
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag321 = '2' OR     #異動碼-1控制方式 
         l_aag.aag321 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq32)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_success = "N"
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag331 = '2' OR     #異動碼-1控制方式 
         l_aag.aag331 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq33)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_success = "N"
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag341 = '2' OR     #異動碼-1控制方式 
         l_aag.aag341 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq34)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_success = "N"
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag351 = '2' OR     #異動碼-1控制方式 
         l_aag.aag351 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq35)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_success = "N"
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF (l_aag.aag361 = '2' OR     #異動碼-1控制方式 
         l_aag.aag361 = '3') AND    #   1:可輸入,  可空白
         cl_null(l_npq.npq36)     #   2.必須輸入,不需檢查 
         THEN                     #   3.必須輸入, 必須檢查
         LET g_success = "N"
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
      IF p_sys  = 'AP' THEN 
          SELECT pmc903 INTO g_pmc903 FROM pmc_file,apa_file
           WHERE pmc01 = apa05
             AND apa44 = l_npq.npq01
          LET l_pmc903 = g_pmc903
      END IF  
      IF p_sys = 'AR' THEN  
          SELECT occ37 INTO g_occ37 FROM occ_file,oma_file
            WHERE occ01 =oma03
              AND oma33 = l_npq.npq01
          LET l_pmc903 = g_occ37
      END IF        
      IF (l_aag.aag371 = '2' OR     #異動碼-1控制方式 
         l_aag.aag371 = '3' 
         OR (l_aag.aag371 = '4' AND l_pmc903 = 'Y'))  #   1:可輸入,  可空白   
         AND cl_null(l_npq.npq37)   #   2.必須輸入,不需檢查   
         THEN                     #   3.必須輸入, 必須檢查
         LET g_success = "N"
         CALL cl_err(l_npq.npq03,'aap-288',1)
      END IF
    #CHI-9A0012---add---end---
   END FOREACH
## ------------------------------------------------------
END FUNCTION

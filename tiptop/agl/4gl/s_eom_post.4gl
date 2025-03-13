# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
##□ s_post
##SYNTAX	   CALL s_eom_post(p_bookno,p_bdate,p_edate,bno,p_eno,p_chr)
##DESCRIPTION	   輸入要過帳的起始、截止的日期、起始傳票單號、截止傳票單號
##PARAMETERS       p_bookno	帳別
##		   p_bdate	起始日期
##		   p_edate	截止日期
##		   p_bno	起始傳票編號
##		   p_eno	截止傳票編號
##		   p_chr        0.過帳 1.還原
##RETURNING	   NONE
##NOTE		   請檢查g_success看是否成功
# Date & Author..: 03/05/20 By Danny
 # Modify.........: No:BUG-470041(MOD-470573) 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-4C0009 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.MOD-630045 06/03/13 By Carrier 大陸版時,科目層數超過2層時,aah/tah/tas重新月結會出現數據錯誤
# Modify.........: No.FUN-640004 06/04/06 By Carrier 將帳套放大至5碼
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/09/04 By yjkhero  欄位類型轉換為 LIKE型
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-710023 07/01/19 By yjkhero 錯誤訊息匯整
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.FUN-740020 07/04/13 By Lynn 會計科目加帳套
# Modify.........: No.MOD-7B0215 07/12/04 By Smapmin 修改transaction流程
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0052 09/11/17 By Carrier 增加'科目核算項'統計檔功能
# Modify.........: No.FUN-9A0092 09/11/17 By douzh 修改笔误tahlegal改成taslegal
# Modify.........: No:CHI-890014 10/11/26 By Summer 當月已有拋轉CE傳票再重新執行aglp103做月結後金額會Double
# Modify.........: No.FUN-B10009 11/01/07 By Carrier aeh_file增加aehlegal字段
# Modify.........: No.CHI-BB0026 11/12/14 By Dido 調整 aeh_file 在 CE 傳票重新拋轉金額重覆問題  

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_aaa	RECORD LIKE aaa_file.*
DEFINE g_aag	RECORD LIKE aag_file.*
DEFINE g_aba	RECORD LIKE aba_file.*
DEFINE g_abb	RECORD LIKE abb_file.*
DEFINE g_chr	LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)
DEFINE g_aaa09  LIKE aaa_file.aaa09     #CHI-890014 add
DEFINE g_aaa10  LIKE aaa_file.aaa10     #CHI-890014 add

FUNCTION s_eom_post(p_bookno,p_bdate,p_edate,p_bno,p_eno,p_chr)
   DEFINE p_bookno	LIKE aaa_file.aaa01   #No.FUN-640004
   DEFINE p_bdate	LIKE aba_file.aba02   #No.FUN-680098 date
   DEFINE p_edate       LIKE aba_file.aba02   #No.FUN-680098 date
   DEFINE p_bno		LIKE aba_file.aba01   #No.FUN-680098 VARCHAR(12)
   DEFINE p_eno		LIKE aba_file.aba01   #No.FUN-680098 VARCHAR(12)
   DEFINE p_chr		LIKE type_file.chr1      #No.FUN-680098 VARCHAR(1)
   DEFINE l_sql		LIKE type_file.chr1000   #No.FUN-680098 VARCHAR(600)
   DEFINE l_cnt,l_cnt1,l_cnt2,l_cnt3 LIKE type_file.num5          #No.FUN-680098 smallint
   DEFINE p_row,p_col LIKE type_file.num5          #No.FUN-680098 smallint

   WHENEVER ERROR CONTINUE

   LET g_chr = p_chr

  #str CHI-890014 add
  #當月結或年結為2.帳結法時,於還原階段建立Temp Table
  #以下Temptable用來記錄還原的金額、筆數
   SELECT aaa09,aaa10 INTO g_aaa09,g_aaa10 FROM aaa_file WHERE aaa01=p_bookno
   IF ((g_aaa09 = '2' OR g_aaa10 = '2') AND g_chr = '1') THEN
     #DROP TABLE s_eom_post_tmpaah    #CHI-BB0026 mark
     #DROP TABLE s_eom_post_tmpaas    #CHI-BB0026 mark
     #DROP TABLE s_eom_post_tmptah    #CHI-BB0026 mark
     #DROP TABLE s_eom_post_tmptas    #CHI-BB0026 mark
      SELECT * FROM aah_file WHERE 1!=1 INTO TEMP s_eom_post_tmpaah
      SELECT * FROM aas_file WHERE 1!=1 INTO TEMP s_eom_post_tmpaas
      SELECT * FROM aeh_file WHERE 1!=1 INTO TEMP s_eom_post_tmpaeh   #CHI-BB0026
      SELECT * FROM tah_file WHERE 1!=1 INTO TEMP s_eom_post_tmptah
      SELECT * FROM tas_file WHERE 1!=1 INTO TEMP s_eom_post_tmptas
   END IF
  #end CHI-890014 add

   #設定資料選擇條件
   LET l_sql = "SELECT * FROM aba_file",
               " WHERE (aba02 BETWEEN '",p_bdate,"' AND '",p_edate,"')",
               "   AND aba00 ='",p_bookno,"'",
               "   AND abapost = 'Y' AND aba19 = 'Y' ",
               "   AND abaacti = 'Y' AND aba06 = 'CE' "

   #若有傳起始傳票單號時.....
   IF NOT cl_null(p_bno) THEN
      LET l_sql  = l_sql CLIPPED, " AND aba01 >= '",p_bno,"'"
   END IF
   #若有傳截止傳票單號時.....
   IF NOT cl_null(p_eno) THEN
      LET l_sql  = l_sql CLIPPED, " AND aba01 <= '",p_eno,"'"
   END IF
   LET l_sql = l_sql CLIPPED, " ORDER BY aba02,aba01"

   PREPARE post_prepare FROM l_sql
   IF STATUS THEN CALL cl_err('prepare:',STATUS,1)
         LET g_success ='N'   #FUN-8A0086
         RETURN
   END IF
   DECLARE post_cur CURSOR WITH HOLD FOR post_prepare

   LET l_cnt = 0 LET l_cnt1 = 0 LET l_cnt2 = 0 LET l_cnt3 = 0
   FOREACH post_cur INTO g_aba.*
#     IF STATUS THEN CALL cl_err('fore aba:',STATUS,1) RETURN END IF #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF STATUS THEN
         IF g_bgerr THEN
          LET g_showmsg=p_bookno,"/",'Y',"/",'Y',"/",'Y',"/",'CE'
          CALL s_errmsg('aba00,abapost,aba19,abaacti,aba06',g_showmsg,'fore aba:',STATUS,1)
         ELSE
          CALL cl_err('fore aba:',STATUS,1)
         END IF
         LET g_success ='N'   #FUN-8A0086
         RETURN
      END IF
      IF g_success='N' THEN
         LET g_totsuccess='N'
         LET g_success='Y'
      END IF
#NO.FUN-710023--END

       #----------------------------------------------------------------------
      # 可能資料恰巧已被post/del/upd所以重讀 (V2.0此處有漏洞,易造成過帳錯誤)
      SELECT * INTO g_aba.* FROM aba_file
             WHERE aba01=g_aba.aba01 AND aba00=g_aba.aba00
      IF STATUS THEN
#        CALL cl_err('sel aba:',STATUS,1) # NO.FUN-660123
#        CALL cl_err3("sel","aba_file",g_aba.aba01,g_aba.aba00,STATUS,"","sel aba:",1)  # NO.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
            CALL s_errmsg('aba01,aba00',g_showmsg,'sel aba:',STATUS,0)
         ELSE
            CALL cl_err3("sel","aba_file",g_aba.aba01,g_aba.aba00,STATUS,"","sel aba:",1)
         END IF
#NO.FUN-710023--END
         CONTINUE FOREACH
      END IF
      #----------------------------------------------------------------------
      IF g_aba.aba02<=g_aaa.aaa07 THEN 			# 小於關帳年月
#        CALL cl_err('aba02<aaa07','agl-200',1) CONTINUE FOREACH #NO.FUN-710023
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
            LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
            CALL s_errmsg('aba01,aba00',g_showmsg,'aba02<aaa07','agl-200',0)
         ELSE
            CALL cl_err('aba02<aaa07','agl-200',1)
         END IF
#NO.FUN-710023--END
      END IF
      #-------------------------------------------------------- 開始過帳
      #BEGIN WORK   #MOD-7B0215
      #LET g_success='Y'   #MOD-7B0215
      CALL s_eom_post_abb()
      #IF g_success='N' THEN ROLLBACK WORK CONTINUE FOREACH END IF   #MOD-7B0215
      IF g_success='N' THEN CONTINUE FOREACH END IF   #MOD-7B0215
      #COMMIT WORK   #MOD-7B0215
      #-------------------------------------------------------- 過帳成功
      LET l_cnt = l_cnt + 1
      DISPLAY l_cnt USING '####' AT 4,31
   END FOREACH
#NO.FUN-710023--BEGIN
    IF g_totsuccess="N" THEN
       LET g_success="N"
    END IF
#NO.FUN-710023--END
   UPDATE aaa_file SET aaa06 = g_today WHERE  aaa01 = p_bookno
   IF STATUS THEN
#    CALL cl_err('upd aaa06:',STATUS,1)  # NO.FUN-660123
#    CALL cl_err3("upd","aaa_file",g_today,p_bookno,STATUS,"","upd aaa06:",1)  # NO.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
     IF g_bgerr THEN
       CALL s_errmsg('aaa01',p_bookno,'upd aaa06:',STATUS,1)
     ELSE
         CALL cl_err3("upd","aaa_file",g_today,p_bookno,STATUS,"","upd aaa06:",1)
     END IF
#NO.FUN-710023--END
   END IF
END FUNCTION

FUNCTION s_eom_post_abb()
   DECLARE s_eom_post_abb_c CURSOR FOR
         SELECT * FROM abb_file,aag_file
                WHERE abb01=g_aba.aba01 AND abb00=g_aba.aba00 AND abb00 = aag00 AND abb03=aag01     #No.FUN-740020
   FOREACH s_eom_post_abb_c INTO g_abb.*, g_aag.*
      IF STATUS THEN
#        CALL cl_err('fore abb',STATUS,1) LET g_success='N' RETURN    #NO.FUN-710023
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
           LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
           CALL s_errmsg('abb01,abb00',g_showmsg,'fore abb',STATUS,1) LET g_success='N' RETURN
         ELSE
           CALL cl_err('fore abb',STATUS,1) LET g_success='N' RETURN
         END IF
#NO.FUN-710023--END
      END IF
      DISPLAY g_aba.aba02,' ',g_aba.aba01 AT 4,2
      IF g_aag.aag01 IS NULL THEN
#         CALL cl_err('aag01=null','aap-262',1) LET g_success='N' RETURN #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
            CALL s_errmsg('abb01,abb00',g_showmsg,'aag01=null','aap-262',1)
          ELSE
            CALL cl_err('aag01=null','aap-262',1)
          END IF
          LET g_success='N' RETURN
#NO.FUN-710023--END
      END IF
      IF g_aag.aag07='2' AND g_aag.aag08 IS NULL THEN
#        CALL cl_err('aag07=2 aag08=null','agl-179',1) LET g_success='N' RETURN #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=g_aba.aba01,"/",g_aba.aba00
            CALL s_errmsg('abb01,abb00',g_showmsg,'aag01=null','aap-262',1)
          ELSE
            CALL cl_err('aag01=null','aap-262',1)
          END IF
          LET g_success='N' RETURN
#NO.FUN-710023--END
      END IF

      #No.FUN-9A0052  --Begin
      IF cl_null(g_abb.abb05) THEN LET g_abb.abb05 = ' ' END IF
      IF cl_null(g_abb.abb08) THEN LET g_abb.abb08 = ' ' END IF
      IF cl_null(g_abb.abb15) THEN LET g_abb.abb15 = ' ' END IF
      IF cl_null(g_abb.abb24) THEN LET g_abb.abb24 = ' ' END IF
      IF cl_null(g_abb.abb11) THEN LET g_abb.abb11 = ' ' END IF
      IF cl_null(g_abb.abb12) THEN LET g_abb.abb12 = ' ' END IF
      IF cl_null(g_abb.abb13) THEN LET g_abb.abb13 = ' ' END IF
      IF cl_null(g_abb.abb14) THEN LET g_abb.abb14 = ' ' END IF
      IF cl_null(g_abb.abb31) THEN LET g_abb.abb31 = ' ' END IF
      IF cl_null(g_abb.abb32) THEN LET g_abb.abb32 = ' ' END IF
      IF cl_null(g_abb.abb33) THEN LET g_abb.abb33 = ' ' END IF
      IF cl_null(g_abb.abb34) THEN LET g_abb.abb34 = ' ' END IF
      IF cl_null(g_abb.abb35) THEN LET g_abb.abb35 = ' ' END IF
      IF cl_null(g_abb.abb36) THEN LET g_abb.abb36 = ' ' END IF
      IF cl_null(g_abb.abb37) THEN LET g_abb.abb37 = ' ' END IF
      #No.FUN-9A0052  --End

      IF g_chr = '0' THEN   #過帳
         CALL s_eom_post_aah(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         CALL s_eom_post_aas(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         CALL s_eom_post_tah(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         CALL s_eom_post_tas(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         #No.FUN-9A0052  --Begin
         CALL s_eom_post_aeh(g_aag.aag07,g_aag.aag08)  #明細檔
              IF g_success='N' THEN RETURN END IF
         #No.FUN-9A0052  --End
      ELSE                  #還原
         CALL re_aah(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         CALL re_aas(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         CALL re_tah(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         CALL re_tas(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         #No.FUN-9A0052  --Begin
         CALL re_aeh(g_aag.aag07,g_aag.aag08)
              IF g_success='N' THEN RETURN END IF
         #No.FUN-9A0052  --End

      END IF
   END FOREACH
END FUNCTION

FUNCTION s_eom_post_aah(p_aag07,p_aag08)
    DEFINE p_aag07	LIKE aag_file.aag07    #No.FUN-680098 VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08    #No.FUN-680098 VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04    #No.FUN-4C0009 #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5    #No.FUN-680098 smallint
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE l_i          LIKE type_file.num5    #No.FUN-680098 smallint
    DEFINE l_aag08	LIKE aag_file.aag08       #No.FUN-680098 VARCHAR(24)
    DEFINE m_aag08	LIKE aag_file.aag08       #No.FUN-680098 VARCHAR(24)
    DEFINE l_aah04_1    LIKE aah_file.aah04    #CHI-890014 add
    DEFINE l_aah05_1    LIKE aah_file.aah05    #CHI-890014 add

    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
   #str CHI-890014 add
    SELECT SUM(aah04),SUM(aah05) INTO l_aah04_1,l_aah05_1
      FROM s_eom_post_tmpaah
     WHERE aah00=g_aba.aba00 AND aah01=g_abb.abb03
       AND aah02=g_aba.aba03 AND aah03=g_aba.aba04
    IF cl_null(l_aah04_1) THEN LET l_aah04_1=0 END IF
    IF cl_null(l_aah05_1) THEN LET l_aah05_1=0 END IF
    IF l_aah04_1 !=0 AND g_abb.abb06 = 1 THEN 
       LET amt_d=amt_d+l_aah04_1*-1
    END IF
    IF l_aah05_1 !=0 AND g_abb.abb06 != 1 THEN
       LET amt_c=amt_c+l_aah05_1*-1
    END IF
   #end CHI-890014 add
    UPDATE aah_file SET aah04 = aah04 + amt_d,
                        aah05 = aah05 + amt_c,
                        aah06 = aah06 + rec_d,
                        aah07 = aah07 + rec_c
     WHERE aah00=g_aba.aba00 AND aah01=g_abb.abb03
       AND aah02=g_aba.aba03 AND aah03=g_aba.aba04
    IF STATUS THEN
#      CALL cl_err('upd aah:',STATUS,1)   #No.FUN-660123
#      CALL cl_err3("upd","aah_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aah:",1)   #No.FUN-660123 #NO.FUN-710023a
#NO.FUN-710023--BEGIN
       IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",g_abb.abb00,"/",g_aba.aba03,"/",g_aba.aba04
         CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'upd aah:',STATUS,1)
       ELSE
          CALL cl_err3("upd","aah_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aah:",1)
       END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
        INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
            VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba03,g_aba.aba04,
                   amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
       IF STATUS THEN
#         CALL cl_err('ins aah:',STATUS,1)   #No.FUN-660123
#         CALL cl_err3("ins","aah_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aah:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04
            CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'ins aah:',STATUS,1)
          ELSE
            CALL cl_err3("ins","aah_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aah:",1)
          END IF
#NO.FUN-710023--END
          LET g_success='N' RETURN
       END IF
    END IF
    IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
       CALL s_eom_post_aah_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
      #IF g_aza.aza26 = '2' THEN  #CHI-710005
          SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
           WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00     #No.FUN-740020
          IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
          LET m_aag08 = l_aag08
          FOR l_i = l_aag24 - 1  TO 1 STEP -1
              CALL s_eom_post_aah_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
              LET l_aag08 = m_aag08
              SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00   #No.FUN-740020
          END FOR
      #END IF
    END IF
END FUNCTION

FUNCTION s_eom_post_aah_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE aah_file.aah04
   DEFINE  rec_d,rec_c   LIKE aah_file.aah06

   UPDATE aah_file SET aah04 = aah04 + amt_d,
                       aah05 = aah05 + amt_c,
                       aah06 = aah06 + rec_d,
                       aah07 = aah07 + rec_c
    WHERE aah00=g_aba.aba00 AND aah01=p_aag08
      AND aah02=g_aba.aba03 AND aah03=g_aba.aba04
   IF STATUS THEN
#     CALL cl_err('upd aah(2):',STATUS,1)  #No.FUN-660123
#     CALL cl_err3("upd","aah_file",g_aba.aba00,p_aag08,STATUS,"","upd aah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04
         CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'upd aah(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","aah_file",g_aba.aba00,p_aag08,STATUS,"","upd aah(2):",1)
      END IF
#NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO aah_file(aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07,aahlegal)  #No.MOD-470041 #FUN-980003 add aahlegal
           VALUES(g_aba.aba00,p_aag08,g_aba.aba03,g_aba.aba04,
                  amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins aah(2):',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("ins","aah_file",g_aba.aba00,p_aag08,STATUS,"","ins aah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
           LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04
           CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'ins aah(2):',STATUS,1)
         ELSE
           CALL cl_err3("ins","aah_file",g_aba.aba00,p_aag08,STATUS,"","ins aah(2):",1)
         END IF
#NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

FUNCTION s_eom_post_tah(p_aag07,p_aag08)
    DEFINE p_aag07	 LIKE aag_file.aag07       #No.FUN-680098 VARCHAR(1)
    DEFINE p_aag08	 LIKE aag_file.aag08       #No.FUN-680098 VARCHAR(24)
    DEFINE amt_d,amt_c	 LIKE aah_file.aah04       #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5       #No.FUN-680098  smallint
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6    #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE l_i          LIKE type_file.num5        #No.FUN-680098 smallint
    DEFINE l_aag08	LIKE aag_file.aag08        #No.FUN-680098 VARCHAR(24)
    DEFINE m_aag08	LIKE aag_file.aag08        #No.FUN-680098 VARCHAR(24)
    DEFINE l_tah04_1    LIKE tah_file.tah04        #CHI-890014 add
    DEFINE l_tah05_1    LIKE tah_file.tah05        #CHI-890014 add
    DEFINE l_tah09_1    LIKE tah_file.tah09        #CHI-890014 add
    DEFINE l_tah10_1    LIKE tah_file.tah10        #CHI-890014 add

    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
   #str CHI-890014 add
    SELECT SUM(tah04),SUM(tah05),SUM(tah09),SUM(tah10)
      INTO l_tah04_1,l_tah05_1,l_tah09_1,l_tah10_1
      FROM s_eom_post_tmptah
     WHERE tah00=g_aba.aba00 AND tah01=g_abb.abb03
       AND tah02=g_aba.aba03 AND tah03=g_aba.aba04
       AND tah08=g_abb.abb24     #幣別
    IF cl_null(l_tah04_1) THEN LET l_tah04_1=0 END IF
    IF cl_null(l_tah05_1) THEN LET l_tah05_1=0 END IF
    IF cl_null(l_tah09_1) THEN LET l_tah09_1=0 END IF
    IF cl_null(l_tah10_1) THEN LET l_tah10_1=0 END IF
    IF l_tah04_1 !=0 AND g_abb.abb06 = 1 THEN 
       LET amt_d =amt_d +l_tah04_1*-1
       LET amtf_d=amtf_d+l_tah09_1*-1
    END IF
    IF l_tah05_1 !=0 AND g_abb.abb06 != 1 THEN
       LET amt_c =amt_c +l_tah05_1*-1
       LET amtf_c=amtf_c+l_tah10_1*-1
    END IF
   #end CHI-890014 add
    UPDATE tah_file SET tah04 = tah04 + amt_d, tah05 = tah05 + amt_c,
                        tah06 = tah06 + rec_d, tah07 = tah07 + rec_c,
                        tah09 = tah09 + amtf_d,tah10 = tah10 + amtf_c
     WHERE tah00=g_aba.aba00 AND tah01=g_abb.abb03
       AND tah02=g_aba.aba03 AND tah03=g_aba.aba04
       AND tah08=g_abb.abb24     #幣別
    IF STATUS THEN
#      CALL cl_err('upd tah:',STATUS,1)  #No.FUN-660123
#      CALL cl_err3("upd","tah_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tah:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
       IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
         CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'upd tah:',STATUS,1)
       ELSE
          CALL cl_err3("upd","tah_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tah:",1)
       END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
        INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,  #No.MOD-470041
                            tah06,tah07,tah08,tah09,tah10,tahlegal) #FUN-980003 add tahlegal
            VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba03,g_aba.aba04,amt_d,
                   amt_c,rec_d,rec_c,g_abb.abb24,amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
       IF STATUS THEN
#         CALL cl_err('ins tah:',STATUS,1)   #No.FUN-660123
#         CALL cl_err3("ins","tah_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tah:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
            CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'ins tah:',STATUS,1)
          ELSE
            CALL cl_err3("ins","tah_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tah:",1)
          END IF
#NO.FUN-710023--END
          LET g_success='N' RETURN
       END IF
    END IF
    IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
       CALL s_eom_post_tah_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
     # IF g_aza.aza26 = '2' THEN  #CHI-710005
          SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
           WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
          IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
          LET m_aag08 = l_aag08
          FOR l_i = l_aag24 - 1  TO 1 STEP -1
              CALL s_eom_post_tah_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
              LET l_aag08 = m_aag08
              SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
          END FOR
     # END IF
    END IF
END FUNCTION

FUNCTION s_eom_post_tah_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE tah_file.tah04
   DEFINE  rec_d,rec_c   LIKE tah_file.tah06
   DEFINE  amtf_d,amtf_c LIKE tah_file.tah09

   UPDATE tah_file SET tah04 = tah04 + amt_d, tah05 = tah05 + amt_c,
                       tah06 = tah06 + rec_d, tah07 = tah07 + rec_c,
                       tah09 = tah09 + amtf_d,tah10 = tah10 + amtf_c
    WHERE tah00=g_aba.aba00 AND tah01=p_aag08
      AND tah02=g_aba.aba03 AND tah03=g_aba.aba04
      AND tah08=g_abb.abb24     #幣別
   IF STATUS THEN
#     CALL cl_err('upd tah(2):',STATUS,1) #No.FUN-660123
#     CALL cl_err3("upd","tah_file",g_aba.aba00,p_aag08,STATUS,"","upd tah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
         CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'upd tah:',STATUS,1)
      ELSE
         CALL cl_err3("upd","tah_file",g_aba.aba00,p_aag08,STATUS,"","upd tah(2):",1)
      END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO tah_file(tah00,tah01,tah02,tah03,tah04,tah05,  #No.MOD-470041
                           tah06,tah07,tah08,tah09,tah10,tahlegal) #FUN-980003 add tahlegal
           VALUES(g_aba.aba00,p_aag08,g_aba.aba03,g_aba.aba04,amt_d,amt_c,
                  rec_d,rec_c,g_abb.abb24,amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins tah(2):',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("ins","tah_file",g_aba.aba00,p_aag08,STATUS,"","ins tah(2):",1)
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
           LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
           CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'ins tah(2):',STATUS,1)
         ELSE
           CALL cl_err3("ins","tah_file",g_aba.aba00,p_aag08,STATUS,"","ins tah(2):",1)   #No.FUN-660123
         END IF
#NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

FUNCTION s_eom_post_aas(p_aag07,p_aag08)
    DEFINE p_aag07	LIKE aag_file.aag02     #No.FUN-680098 VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08     #No.FUN-680098 VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04     #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5     #No.FUN-680098  smallint
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE l_i          LIKE type_file.num5          #No.FUN-680098 smallint
    DEFINE l_aag08	LIKE aag_file.aag08       #No.FUN-680098 VARCHAR(24)
    DEFINE m_aag08	LIKE aag_file.aag08       #No.FUN-680098 VARCHAR(24)
    DEFINE l_aas04_1    LIKE aas_file.aas04     #CHI-890014 add
    DEFINE l_aas05_1    LIKE aas_file.aas05     #CHI-890014 add

    IF g_aaz.aaz51 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
   #str CHI-890014 add
    SELECT SUM(aas04),SUM(aas05) INTO l_aas04_1,l_aas05_1
      FROM s_eom_post_tmpaas
     WHERE aas00=g_aba.aba00 AND aas01=g_abb.abb03
       AND aas02=g_aba.aba02
    IF cl_null(l_aas04_1) THEN LET l_aas04_1=0 END IF
    IF cl_null(l_aas05_1) THEN LET l_aas05_1=0 END IF
    IF l_aas04_1 !=0 AND g_abb.abb06 = 1 THEN 
       LET amt_d=amt_d+l_aas04_1*-1
    END IF
    IF l_aas05_1 !=0 AND g_abb.abb06 != 1 THEN
       LET amt_c=amt_c+l_aas05_1*-1
    END IF
   #end CHI-890014 add
    UPDATE aas_file SET aas04 = aas04+amt_d,aas05 = aas05+amt_c,
                        aas06 = aas06+rec_d,aas07 = aas07+rec_c
     WHERE aas00 = g_aba.aba00 AND aas01 = g_abb.abb03 AND aas02 = g_aba.aba02
    IF STATUS THEN
#      CALL cl_err('upd aas:',STATUS,1)     #No.FUN-660123
#      CALL cl_err3("upd","aas_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aas:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
       IF g_bgerr THEN
          LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02
          CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'upd aas:',STATUS,1)
       ELSE
          CALL cl_err3("upd","aas_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aas:",1)
       END IF
#NO.FUN-710023--END
       RETURN
       LET g_success='N'
    END IF
    IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
        INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
            VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba02,amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
       IF STATUS THEN
#         CALL cl_err('ins aas:',STATUS,1) #No.FUN-660123
#         CALL cl_err3("ins","aas_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aas:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
            LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02
            CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'ins aas:',STATUS,1)
          ELSE
            CALL cl_err3("ins","aas_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aas:",1)
          END IF
#NO.FUN-710023--END
          LET g_success='N' RETURN
       END IF
    END IF
    IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
       CALL s_eom_post_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
    #  IF g_aza.aza26 = '2' THEN  #CHI-710005
          SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
           WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
          IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
          LET m_aag08 = l_aag08
          FOR l_i = l_aag24 - 1 TO 1 STEP -1
              CALL s_eom_post_aas_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
              LET l_aag08 = m_aag08
              SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00  #No.FUN-740020
          END FOR
    #  END IF
    END IF
END FUNCTION

FUNCTION s_eom_post_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE aah_file.aah04
   DEFINE  rec_d,rec_c	 LIKE type_file.num5          #No.FUN-680098 smallint

   UPDATE aas_file SET aas04 = aas04+amt_d,aas05 = aas05+amt_c,
                       aas06 = aas06+rec_d,aas07 = aas07+rec_c
    WHERE aas00 = g_aba.aba00 AND aas01 = p_aag08 AND aas02 = g_aba.aba02
   IF STATUS THEN
#     CALL cl_err('upd aas(2):',STATUS,1)  #No.FUN-660123
#     CALL cl_err3("upd","aas_file",g_aba.aba00,p_aag08,STATUS,"","upd aas(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02
         CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'upd aas(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","aas_file",g_aba.aba00,p_aag08,STATUS,"","upd aas(2):",1)
      END IF
#NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO aas_file(aas00,aas01,aas02,aas04,aas05,aas06,aas07,aaslegal)  #No.MOD-470041 #FUN-980003 add aaslegal
           VALUES(g_aba.aba00,p_aag08,g_aba.aba02,amt_d,amt_c,rec_d,rec_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins aas(2):',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("ins","aas_file",g_aba.aba00,p_aag08,STATUS,"","ins aas(2):",1)   #No.FUN-660123
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
           LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02
           CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'upd aas:',STATUS,1)
         ELSE
           CALL cl_err3("ins","aas_file",g_aba.aba00,p_aag08,STATUS,"","ins aas(2):",1)
         END IF
#NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

FUNCTION s_eom_post_tas(p_aag07,p_aag08)
    DEFINE p_aag07	 LIKE aag_file.aag07     #No.FUN-680098 VARCHAR(1)
    DEFINE p_aag08	 LIKE aag_file.aag08     #No.FUN-680098 VARCHAR(24)
    DEFINE amt_d,amt_c	 LIKE aah_file.aah04     #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5     #No.FUN-680098  smallint
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6  #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE l_aag24       LIKE aag_file.aag24
    DEFINE l_i           LIKE type_file.num5     #No.FUN-680098 smallint
    DEFINE l_aag08       LIKE aag_file.aag08     #No.FUN-680098 VARCHAR(24)
    DEFINE m_aag08       LIKE aag_file.aag08     #No.FUN-680098 VARCHAR(24)
    DEFINE l_tas04_1     LIKE tas_file.tas04     #CHI-890014 add
    DEFINE l_tas05_1     LIKE tas_file.tas05     #CHI-890014 add
    DEFINE l_tas09_1     LIKE tas_file.tas09     #CHI-890014 add
    DEFINE l_tas10_1     LIKE tas_file.tas10     #CHI-890014 add

    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF g_aaz.aaz51 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
   #str CHI-890014 add
    SELECT SUM(tas04),SUM(tas05),SUM(tas09),SUM(tas10)
      INTO l_tas04_1,l_tas05_1,l_tas09_1,l_tas10_1
      FROM s_eom_post_tmptas
     WHERE tas00=g_aba.aba00 AND tas01=g_abb.abb03
       AND tas02=g_aba.aba02 AND tas08=g_abb.abb24
    IF cl_null(l_tas04_1) THEN LET l_tas04_1=0 END IF
    IF cl_null(l_tas05_1) THEN LET l_tas05_1=0 END IF
    IF cl_null(l_tas09_1) THEN LET l_tas09_1=0 END IF
    IF cl_null(l_tas10_1) THEN LET l_tas10_1=0 END IF
    IF l_tas04_1 !=0 AND g_abb.abb06 = 1 THEN 
       LET amt_d =amt_d +l_tas04_1*-1
       LET amtf_d=amtf_d+l_tas09_1*-1
    END IF
    IF l_tas05_1 !=0 AND g_abb.abb06 != 1 THEN
       LET amt_c =amt_c +l_tas05_1*-1
       LET amtf_c=amtf_c+l_tas10_1*-1
    END IF
   #end CHI-890014 add
    UPDATE tas_file SET tas04 = tas04 + amt_d, tas05 = tas05 + amt_c,
                        tas06 = tas06 + rec_d, tas07 = tas07 + rec_c,
                        tas09 = tas09 + amtf_d,tas10 = tas10 + amtf_c
     WHERE tas00=g_aba.aba00 AND tas01=g_abb.abb03
       AND tas02=g_aba.aba02 AND tas08=g_abb.abb24     #幣別
    IF STATUS THEN
#      CALL cl_err('upd tas:',STATUS,1)  #No.FUN-660123
#      CALL cl_err3("upd","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tas:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
       IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02,"/",g_abb.abb24
         CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'upd tas:',STATUS,1)
       ELSE
         CALL cl_err3("upd","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd tas:",1)
       END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
        INSERT INTO tas_file(tas00,tas01,tas02,tas04,tas05,  #No.MOD-470041
                            tas06,tas07,tas08,tas09,tas10,taslegal) #FUN-980003 add taslegal
            VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba02,amt_d,amt_c,rec_d,
                   rec_c,g_abb.abb24,amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
       IF STATUS THEN
#         CALL cl_err('ins tas:',STATUS,1)   #No.FUN-660123
#         CALL cl_err3("ins","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tas:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
          IF g_bgerr THEN
             LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02,"/",g_abb.abb24
             CALL s_errmsg('tas00,tas01,tahs02,tas08',g_showmsg,'ins tas:',STATUS,1)
          ELSE
             CALL cl_err3("ins","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins tas:",1)
          END IF
#NO.FUN-710023--END
          LET g_success='N' RETURN
       END IF
    END IF
    IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
       CALL s_eom_post_tas_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
     # IF g_aza.aza26 = '2' THEN  #CHI-710005
          SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
           WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
          IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
          LET m_aag08 = l_aag08
          FOR l_i = l_aag24 - 1 TO 1 STEP -1
              CALL s_eom_post_tas_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
               LET l_aag08 = m_aag08
              SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00   #No.FUN-740020
          END FOR
     # END IF
    END IF
END FUNCTION

FUNCTION s_eom_post_tas_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE  p_aag08       LIKE aag_file.aag08
   DEFINE  amt_d,amt_c   LIKE tah_file.tah04
   DEFINE  rec_d,rec_c   LIKE tah_file.tah06
   DEFINE  amtf_d,amtf_c LIKE tah_file.tah09

   UPDATE tas_file SET tas04 = tas04 + amt_d, tas05 = tas05 + amt_c,
                       tas06 = tas06 + rec_d, tas07 = tas07 + rec_c,
                       tas09 = tas09 + amtf_d,tas10 = tas10 + amtf_c
    WHERE tas00=g_aba.aba00 AND tas01=p_aag08
      AND tas02=g_aba.aba02 AND tas08=g_abb.abb24     #幣別
   IF STATUS THEN
#     CALL cl_err('upd tas(2):',STATUS,1)   #No.FUN-660123
#     CALL cl_err3("upd","tas_file",g_aba.aba00,p_aag08,STATUS,"","upd tas(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02,"/",g_abb.abb24
         CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'upd tas(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","tas_file",g_aba.aba00,p_aag08,STATUS,"","upd tas(2):",1)
      END IF
#NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO tas_file(tas00,tas01,tas02,tas04,tas05,  #No.MOD-470041
#                          tas06,tas07,tas08,tas09,tas10,tahlegal) #FUN-980003 add tahlegal  #FUN-9A0092 mark
                           tas06,tas07,tas08,tas09,tas10,taslegal) #FUN-980003 add tahlegal  #FUN-9A0092  
           VALUES(g_aba.aba00,p_aag08,g_aba.aba02,amt_d,amt_c,rec_d,rec_c,
                  g_abb.abb24,amtf_d,amtf_c,g_legal) #FUN-980003 add g_legal
      IF STATUS THEN
#        CALL cl_err('ins tas(2):',STATUS,1)   #No.FUN-660123
#        CALL cl_err3("ins","tas_file",g_aba.aba00,p_aag08,STATUS,"","ins tas(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
         IF g_bgerr THEN
           LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02,"/",g_abb.abb24
           CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'ins tas(2):',STATUS,1)
         ELSE
           CALL cl_err3("ins","tas_file",g_aba.aba00,p_aag08,STATUS,"","ins tas(2):",1)
         END IF
#NO.FUN-710023--END
         LET g_success='N' RETURN
      END IF
   END IF
END FUNCTION

#No.FUN-9A0052  --Begin
FUNCTION s_eom_post_aeh(p_aag07,p_aag08)
    DEFINE p_aag07	 LIKE aag_file.aag07
    DEFINE p_aag08	 LIKE aag_file.aag08
    DEFINE amt_d,amt_c	 LIKE aah_file.aah04
    DEFINE rec_d,rec_c	 LIKE type_file.num5
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6
    DEFINE l_aag24       LIKE aag_file.aag24
    DEFINE l_i           LIKE type_file.num5
    DEFINE l_aag08       LIKE aag_file.aag08
    DEFINE m_aag08       LIKE aag_file.aag08
    DEFINE l_str         STRING
    DEFINE l_aeh11_1     LIKE aeh_file.aeh11   #CHI-BB0026
    DEFINE l_aeh12_1     LIKE aeh_file.aeh12   #CHI-BB0026
    DEFINE l_aeh15_1     LIKE aeh_file.aeh15   #CHI-BB0026
    DEFINE l_aeh16_1     LIKE aeh_file.aeh16   #CHI-BB0026

    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF

   #-CHI-BB0026-add-
    SELECT SUM(aeh11),SUM(aeh12),SUM(aeh15),SUM(aeh16)  
      INTO l_aeh11_1,l_aeh12_1,l_aeh15_1,l_aeh16_1
      FROM s_eom_post_tmpaeh
     WHERE aeh00=g_aba.aba00 AND aeh01=g_abb.abb03 AND aeh02=g_abb.abb05
       AND aeh03=g_abb.abb08 AND aeh08=g_abb.abb15 AND aeh09=g_aba.aba03
       AND aeh10=g_aba.aba04 AND aeh17=g_abb.abb24 AND aeh04=g_abb.abb11
       AND aeh05=g_abb.abb12 AND aeh06=g_abb.abb13 AND aeh07=g_abb.abb14
       AND aeh31=g_abb.abb31 AND aeh32=g_abb.abb32 AND aeh33=g_abb.abb33
       AND aeh34=g_abb.abb34 AND aeh35=g_abb.abb35 AND aeh36=g_abb.abb36
       AND aeh37=g_abb.abb37
    IF cl_null(l_aeh11_1) THEN LET l_aeh11_1=0 END IF
    IF cl_null(l_aeh12_1) THEN LET l_aeh12_1=0 END IF
    IF cl_null(l_aeh15_1) THEN LET l_aeh15_1=0 END IF
    IF cl_null(l_aeh16_1) THEN LET l_aeh16_1=0 END IF
    IF l_aeh11_1 !=0 AND g_abb.abb06 = 1 THEN 
       LET amt_d  = amt_d  + l_aeh11_1*-1
       LET amtf_d = amtf_d + l_aeh15_1*-1
    END IF
    IF l_aeh12_1 !=0 AND g_abb.abb06 != 1 THEN
       LET amt_c  = amt_c  + l_aeh12_1*-1
       LET amtf_c = amtf_c + l_aeh16_1*-1
    END IF
   #-CHI-BB0026-end-

    UPDATE aeh_file SET aeh11 = aeh11 + amt_d, aeh12 = aeh12 + amt_c,
                        aeh13 = aeh13 + rec_d, aeh14 = aeh14 + rec_c,
                        aeh15 = aeh15 + amtf_d,aeh16 = aeh16 + amtf_c
     WHERE aeh00=g_aba.aba00 AND aeh01=g_abb.abb03 AND aeh02=g_abb.abb05
       AND aeh03=g_abb.abb08 AND aeh08=g_abb.abb15 AND aeh09=g_aba.aba03
       AND aeh10=g_aba.aba04 AND aeh17=g_abb.abb24 AND aeh04=g_abb.abb11
       AND aeh05=g_abb.abb12 AND aeh06=g_abb.abb13 AND aeh07=g_abb.abb14
       AND aeh31=g_abb.abb31 AND aeh32=g_abb.abb32 AND aeh33=g_abb.abb33
       AND aeh34=g_abb.abb34 AND aeh35=g_abb.abb35 AND aeh36=g_abb.abb36
       AND aeh37=g_abb.abb37
    IF STATUS THEN
       IF g_bgerr THEN
         LET g_showmsg = g_aba.aba00,"/",g_abb.abb03,"/",g_abb.abb05,"/",
                         g_abb.abb08,"/",g_abb.abb15,"/",g_aba.aba03,"/",
                         g_aba.aba04,"/",g_abb.abb24,"/",g_abb.abb11,"/",
                         g_abb.abb12,"/",g_abb.abb13,"/",g_abb.abb14,"/",
                         g_abb.abb31,"/",g_abb.abb32,"/",g_abb.abb33,"/",
                         g_abb.abb34,"/",g_abb.abb35,"/",g_abb.abb36,"/",
                         g_abb.abb37
         LET l_str = " aeh00,aeh01,aeh02,",
                     " aeh03,aeh08,aeh09,",
                     " aeh10,aeh17,aeh04,",
                     " aeh05,aeh06,aeh07,",
                     " aeh31,aeh32,aeh33,",
                     " aeh34,aeh35,aeh36,",
                     " aeh37"
         CALL s_errmsg(l_str,g_showmsg,'upd aeh:',STATUS,1)
       ELSE
         CALL cl_err3("upd","aeh_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd aeh:",1)
       END IF
       LET g_success='N' RETURN
    END IF
    IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
       INSERT INTO aeh_file( aeh00, aeh01, aeh02, aeh03, aeh04, aeh05,
                                aeh06, aeh07, aeh08, aeh09, aeh10, aeh11,
                                aeh12, aeh13, aeh14, aeh15, aeh16, aeh17,
                                aeh31, aeh32, aeh33, aeh34, aeh35, aeh36,
                                aeh37, aehlegal)            #No.FUN-B10009
              VALUES( g_aba.aba00,g_abb.abb03,g_abb.abb05,g_abb.abb08,g_abb.abb11,g_abb.abb12,
                      g_abb.abb13,g_abb.abb14,g_abb.abb15,g_aba.aba03,g_aba.aba04,amt_d,
                      amt_c,rec_d, rec_c,amtf_d,amtf_c,g_abb.abb24,
                      g_abb.abb31,g_abb.abb32,g_abb.abb33,g_abb.abb34,g_abb.abb35,g_abb.abb36,
                      g_abb.abb37,g_legal)            #No.FUN-B10009
       IF STATUS THEN
          IF g_bgerr THEN
             LET g_showmsg = g_aba.aba00,"/",g_abb.abb03,"/",g_abb.abb05,"/",
                             g_abb.abb08,"/",g_abb.abb15,"/",g_aba.aba03,"/",
                             g_aba.aba04,"/",g_abb.abb24,"/",g_abb.abb11,"/",
                             g_abb.abb12,"/",g_abb.abb13,"/",g_abb.abb14,"/",
                             g_abb.abb31,"/",g_abb.abb32,"/",g_abb.abb33,"/",
                             g_abb.abb34,"/",g_abb.abb35,"/",g_abb.abb36,"/",
                             g_abb.abb37
             LET l_str = " aeh00,aeh01,aeh02,",
                         " aeh03,aeh08,aeh09,",
                         " aeh10,aeh17,aeh04,",
                         " aeh05,aeh06,aeh07,",
                         " aeh31,aeh32,aeh33,",
                         " aeh34,aeh35,aeh36,",
                         " aeh37"
             CALL s_errmsg(l_str,g_showmsg,'ins aeh:',STATUS,1)
          ELSE
             CALL cl_err3("ins","aeh_file",g_aba.aba00,g_abb.abb03,STATUS,"","ins aeh:",1)
          END IF
          LET g_success='N' RETURN
       END IF
    END IF

    #IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
    #   CALL s_eom_post_aeh_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
    #      SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
    #       WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
    #      IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
    #      LET m_aag08 = l_aag08
    #      FOR l_i = l_aag24 - 1 TO 1 STEP -1
    #          CALL s_eom_post_aeh_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
    #           LET l_aag08 = m_aag08
    #          SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00   #No.FUN-740020
    #      END FOR
    #END IF
END FUNCTION

#FUNCTION s_eom_post_aeh_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
#   DEFINE  p_aag08       LIKE aag_file.aag08
#   DEFINE  amt_d,amt_c   LIKE tah_file.tah04
#   DEFINE  rec_d,rec_c   LIKE tah_file.tah06
#   DEFINE  amtf_d,amtf_c LIKE tah_file.tah09
#   DEFINE  l_str         STRING
#
#    UPDATE aeh_file SET aeh11 = aeh11 + amt_d, aeh12 = aeh12 + amt_c,
#                        aeh13 = aeh13 + rec_d, aeh14 = aeh14 + rec_c,
#                        aeh15 = aeh15 + amtf_d,aeh16 = aeh16 + amtf_c
#     WHERE aeh00=g_aba.aba00 AND aeh01=p_aag08     AND aeh02=g_abb.abb05
#       AND aeh03=g_abb.abb08 AND aeh08=g_abb.abb15 AND aeh09=g_aba.aba03
#       AND aeh10=g_aba.aba04 AND aeh17=g_abb.abb24 AND aeh04=g_abb.abb11
#       AND aeh05=g_abb.abb12 AND aeh06=g_abb.abb13 AND aeh07=g_abb.abb14
#       AND aeh31=g_abb.abb31 AND aeh32=g_abb.abb32 AND aeh33=g_abb.abb33
#       AND aeh34=g_abb.abb34 AND aeh35=g_abb.abb35 AND aeh36=g_abb.abb36
#       AND aeh37=g_abb.abb37
#
#   IF STATUS THEN
#      IF g_bgerr THEN
#         LET g_showmsg = g_aba.aba00,"/",p_aag08    ,"/",g_abb.abb05,"/",
#                         g_abb.abb08,"/",g_abb.abb15,"/",g_aba.aba03,"/",
#                         g_aba.aba04,"/",g_abb.abb24,"/",g_abb.abb11,"/",
#                         g_abb.abb12,"/",g_abb.abb13,"/",g_abb.abb14,"/",
#                         g_abb.abb31,"/",g_abb.abb32,"/",g_abb.abb33,"/",
#                         g_abb.abb34,"/",g_abb.abb35,"/",g_abb.abb36,"/",
#                         g_abb.abb37
#         LET l_str = " aeh00,aeh01,aeh02,",
#                     " aeh03,aeh08,aeh09,",
#                     " aeh10,aeh17,aeh04,",
#                     " aeh05,aeh06,aeh07,",
#                     " aeh31,aeh32,aeh33,",
#                     " aeh34,aeh35,aeh36,",
#                     " aeh37"
#         CALL s_errmsg(l_str,g_showmsg,'upd aeh(2):',STATUS,1)
#      ELSE
#         CALL cl_err3("upd","aeh_file",g_aba.aba00,p_aag08,STATUS,"","upd aeh(2):",1)
#      END IF
#      LET g_success='N' RETURN
#   END IF
#   IF SQLCA.SQLERRD[3] = 0 THEN #若處理筆數為零,則代表尚無此筆
#       INSERT INTO aeh_file( aeh00, aeh01, aeh02, aeh03, aeh04, aeh05,
#                                aeh06, aeh07, aeh08, aeh09, aeh10, aeh11,
#                                aeh12, aeh13, aeh14, aeh15, aeh16, aeh17,
#                                aeh31, aeh32, aeh33, aeh34, aeh35, aeh36,
#                                aeh37)
#              VALUES( g_aba.aba00,p_aag08    ,g_abb.abb05,g_abb.abb08,g_abb.abb11,g_abb.abb12,
#                      g_abb.abb13,g_abb.abb14,g_abb.abb15,g_aba.aba03,g_aba.aba04,amt_d,
#                      amt_c,rec_d, rec_c,amtf_d,amtf_c,g_abb.abb24,
#                      g_abb.abb31,g_abb.abb32,g_abb.abb33,g_abb.abb34,g_abb.abb35,g_abb.abb36,
#                      g_abb.abb37)
#      IF STATUS THEN
#         IF g_bgerr THEN
#            LET g_showmsg = g_aba.aba00,"/",p_aag08    ,"/",g_abb.abb05,"/",
#                            g_abb.abb08,"/",g_abb.abb15,"/",g_aba.aba03,"/",
#                            g_aba.aba04,"/",g_abb.abb24,"/",g_abb.abb11,"/",
#                            g_abb.abb12,"/",g_abb.abb13,"/",g_abb.abb14,"/",
#                            g_abb.abb31,"/",g_abb.abb32,"/",g_abb.abb33,"/",
#                            g_abb.abb34,"/",g_abb.abb35,"/",g_abb.abb36,"/",
#                            g_abb.abb37
#            LET l_str = " aeh00,aeh01,aeh02,",
#                        " aeh03,aeh08,aeh09,",
#                        " aeh10,aeh17,aeh04,",
#                        " aeh05,aeh06,aeh07,",
#                        " aeh31,aeh32,aeh33,",
#                        " aeh34,aeh35,aeh36,",
#                        " aeh37"
#           CALL s_errmsg('aeh00,aeh01,aeh02,aeh08',g_showmsg,'ins aeh(2):',STATUS,1)
#         ELSE
#           CALL cl_err3("ins","aeh_file",g_aba.aba00,p_aag08,STATUS,"","ins aeh(2):",1)
#         END IF
#         LET g_success='N' RETURN
#      END IF
#   END IF
#END FUNCTION
#No.FUN-9A0052  --End

FUNCTION re_aah(p_aag07,p_aag08)
    DEFINE p_aag07      LIKE aag_file.aag07   #No.FUN-680098 VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08   #No.FUN-680098 VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04   #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5   #No.FUN-680098  smallint
    DEFINE l_i        	LIKE type_file.num5   #No.FUN-680098  smallint
    DEFINE l_aag08      LIKE aag_file.aag08
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE m_aag08	LIKE aag_file.aag08   #No.MOD-630045

    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aah_file SET aah04 = aah04 - amt_d, aah05 = aah05 - amt_c,
                        aah06 = aah06 - rec_d, aah07 = aah07 - rec_c
     WHERE aah00=g_aba.aba00 AND aah01=g_abb.abb03
       AND aah02=g_aba.aba03 AND aah03=g_aba.aba04
    IF STATUS THEN
#      CALL cl_err('upd re_aah:',STATUS,1)  #No.FUN-660123
#      CALL cl_err3("upd","aah_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_aah:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
       IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04
         CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'upd re_aah:',STATUS,1)
       ELSE
         CALL cl_err3("upd","aah_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_aah:",1)
       END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
    END IF
   #str CHI-890014 add
    INSERT INTO s_eom_post_tmpaah
    (aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07)
    VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba03,g_aba.aba04,
           -amt_d,-amt_c,-rec_d,-rec_c)
   #end CHI-890014 add
    IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
       CALL re_aah_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
    #  IF g_aza.aza26 = '2' THEN   #CHI-710005
          SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
           WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
          #No.MOD-630045  --Begin
          IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
          LET m_aag08 = l_aag08
          FOR l_i = l_aag24 - 1  TO 1 STEP -1
            # CALL re_aah_2(l_aag08,amt_d,amt_c,rec_d,rec_c)
              CALL re_aah_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
              LET l_aag08 = m_aag08
              SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00   #No.FUN-740020
          END FOR
          #No.MOD-630045  --End
    #  END IF
    END IF
END FUNCTION

FUNCTION re_aah_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE p_aag08      LIKE aag_file.aag08
   DEFINE amt_d,amt_c  LIKE aah_file.aah04
   DEFINE rec_d,rec_c  LIKE aah_file.aah06

   UPDATE aah_file SET aah04 = aah04 - amt_d, aah05 = aah05 - amt_c,
                       aah06 = aah06 - rec_d, aah07 = aah07 - rec_c
    WHERE aah00=g_aba.aba00 AND aah01=p_aag08
      AND aah02=g_aba.aba03 AND aah03=g_aba.aba04
   IF STATUS THEN
#     CALL cl_err('upd re_aah(2):',STATUS,1)   #No.FUN-660123
#     CALL cl_err3("upd","aah_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_aah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04
         CALL s_errmsg('aah00,aah01,aah02,aah03',g_showmsg,'upd re_aah(2):',STATUS,1)
      ELSE
          CALL cl_err3("upd","aah_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_aah(2):",1)
      END IF
#NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
   #str CHI-890014 add
    INSERT INTO s_eom_post_tmpaah
    (aah00,aah01,aah02,aah03,aah04,aah05,aah06,aah07)
    VALUES(g_aba.aba00,p_aag08,g_aba.aba03,g_aba.aba04,
           -amt_d,-amt_c,-rec_d,-rec_c)
   #end CHI-890014 add
END FUNCTION

FUNCTION re_tah(p_aag07,p_aag08)
    DEFINE p_aag07     LIKE aag_file.aag07      #No.FUN-680098  VARCHAR(1)
    DEFINE p_aag08     LIKE aag_file.aag08      #No.FUN-680098  VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04     #No.FUN-4C0009  #No.FUN-680098  dec(20,6)
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6 #No.FUN-4C0009   #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5        #No.FUN-680098  smalint
    DEFINE l_i        	 LIKE type_file.num5        #No.FUN-680098 smallint
    DEFINE l_aag08       LIKE aag_file.aag08
    DEFINE l_aag24       LIKE aag_file.aag24
    DEFINE m_aag08	 LIKE aag_file.aag08   #No.MOD-630045

    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE tah_file SET tah04 = tah04 - amt_d, tah05 = tah05 - amt_c,
                        tah06 = tah06 - rec_d, tah07 = tah07 - rec_c,
                        tah09 = tah09 - amtf_d,tah10 = tah10 - amtf_c
     WHERE tah00=g_aba.aba00 AND tah01=g_abb.abb03
       AND tah02=g_aba.aba03 AND tah03=g_aba.aba04
       AND tah08=g_abb.abb24
    IF STATUS THEN
#      CALL cl_err('upd re_tah:',STATUS,1)   #No.FUN-660123
#      CALL cl_err3("upd","tah_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_tah:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
         CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'upd re_tah:',STATUS,1)
      ELSE
         CALL cl_err3("upd","tah_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_tah:",1)
      END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
    END IF
   #str CHI-890014 add
    INSERT INTO s_eom_post_tmptah
    (tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,tah08,tah09,tah10)
    VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba03,g_aba.aba04,
           -amt_d,-amt_c,-rec_d,-rec_c,g_abb.abb24,-amtf_d,-amtf_c)
   #end CHI-890014 add
    IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
       CALL re_tah_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
    #  IF g_aza.aza26 = '2' THEN   #CHI-710005
          SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
           WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00     #No.FUN-740020
          #No.MOD-630045  --Begin
          IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
          LET m_aag08 = l_aag08
          FOR l_i = l_aag24 - 1  TO 1 STEP -1
             #CALL re_tah_2(l_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
              CALL re_tah_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
              LET l_aag08 = m_aag08
              SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
          END FOR
          #No.MOD-630045  --End
    #  END IF
    END IF
END FUNCTION

FUNCTION re_tah_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE p_aag08        LIKE aag_file.aag08
   DEFINE amt_d,amt_c    LIKE aah_file.aah04
   DEFINE rec_d,rec_c    LIKE aah_file.aah06
   DEFINE amtf_d,amtf_c  LIKE tah_file.tah09

   UPDATE tah_file SET tah04 = tah04 - amt_d, tah05 = tah05 - amt_c,
                       tah06 = tah06 - rec_d, tah07 = tah07 - rec_c,
                       tah09 = tah09 - amtf_d,tah10 = tah10 - amtf_c
    WHERE tah00=g_aba.aba00 AND tah01=p_aag08
      AND tah02=g_aba.aba03 AND tah03=g_aba.aba04
      AND tah08=g_abb.abb24
   IF STATUS THEN
#     CALL cl_err('upd re_tah(2):',STATUS,1)  #No.FUN-660123
#     CALL cl_err3("upd","tah_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_tah(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba03,"/",g_aba.aba04,"/",g_abb.abb24
         CALL s_errmsg('tah00,tah01,tah02,tah03,tah08',g_showmsg,'upd re_tah(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","tah_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_tah(2):",1)
      END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
   END IF
  #str CHI-890014 add
   INSERT INTO s_eom_post_tmptah
   (tah00,tah01,tah02,tah03,tah04,tah05,tah06,tah07,tah08,tah09,tah10)
   VALUES(g_aba.aba00,p_aag08,g_aba.aba03,g_aba.aba04,
          -amt_d,-amt_c,-rec_d,-rec_c,g_abb.abb24,-amtf_d,-amtf_c)
  #end CHI-890014 add
END FUNCTION

FUNCTION re_aas(p_aag07,p_aag08)
    DEFINE p_aag07	LIKE aag_file.aag07   #No.FUN-680098 VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08   #No.FUN-680098 VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04   #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	LIKE type_file.num5       #No.FUN-680098 smallint
    DEFINE l_i          LIKE type_file.num5       #No.FUN-680098 smallint
    DEFINE l_aag08      LIKE aag_file.aag08
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE m_aag08	LIKE aag_file.aag08   #No.MOD-630045

    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07 LET rec_d = 1
            LET amt_c = 0           LET rec_c = 0
       ELSE LET amt_d = 0           LET rec_d = 0
            LET amt_c = g_abb.abb07 LET rec_c = 1
    END IF
    UPDATE aas_file SET aas04 = aas04-amt_d,aas05 = aas05-amt_c,
                        aas06 = aas06-rec_d,aas07 = aas07-rec_c
     WHERE aas00 = g_aba.aba00 AND aas01 = g_abb.abb03 AND aas02 = g_aba.aba02
    IF STATUS THEN
#      CALL cl_err('upd re_aas:',STATUS,1)   #No.FUN-660123
#      CALL cl_err3("upd","aas_file",g_aba.aba00,g_aba.aba02,STATUS,"","upd re_aas:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
       IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02
         CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'upd re_aas:',STATUS,1)
       ELSE
         CALL cl_err3("upd","aas_file",g_aba.aba00,g_aba.aba02,STATUS,"","upd re_aas:",1)
       END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
    END IF
   #str CHI-890014 add
    INSERT INTO s_eom_post_tmpaas
    (aas00,aas01,aas02,aas04,aas05,aas06,aas07)
    VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba02,
           -amt_d,-amt_c,-rec_d,-rec_c)
   #end CHI-890014 add
    IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
       CALL re_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
     # IF g_aza.aza26 = '2' THEN  #CHI-710005
          SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
           WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
          #No.MOD-630045  --Begin
          IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
          LET m_aag08 = l_aag08
          FOR l_i = l_aag24 - 1  TO 1 STEP -1
             #CALL re_aas_2(l_aag08,amt_d,amt_c,rec_d,rec_c)
              CALL re_aas_2(m_aag08,amt_d,amt_c,rec_d,rec_c)
              LET l_aag08 = m_aag08
              SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00   #No.FUN-740020
          END FOR
          #No.MOD-630045  --End
     # END IF
    END IF
END FUNCTION

FUNCTION re_aas_2(p_aag08,amt_d,amt_c,rec_d,rec_c)
   DEFINE p_aag08      LIKE aag_file.aag08
   DEFINE amt_d,amt_c  LIKE aah_file.aah04
   DEFINE rec_d,rec_c  LIKE aah_file.aah06

   UPDATE aas_file SET aas04 = aas04-amt_d,aas05 = aas05-amt_c,
                       aas06 = aas06-rec_d,aas07 = aas07-rec_c
    WHERE aas00 = g_aba.aba00 AND aas01 = p_aag08 AND aas02 = g_aba.aba02
   IF STATUS THEN
#     CALL cl_err('upd re_aas(2):',STATUS,1)    #No.FUN-660123
#     CALL cl_err3("upd","aas_file",g_aba.aba00,g_aba.aba02,STATUS,"","upd re_aas(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02
         CALL s_errmsg('aas00,aas01,aas02',g_showmsg,'upd re_aas(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","aas_file",g_aba.aba00,g_aba.aba02,STATUS,"","upd re_aas(2):",1)
      END IF
#NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
  #str CHI-890014 add
   INSERT INTO s_eom_post_tmpaas
   (aas00,aas01,aas02,aas04,aas05,aas06,aas07)
   VALUES(g_aba.aba00,p_aag08,g_aba.aba02,
          -amt_d,-amt_c,-rec_d,-rec_c)
  #end CHI-890014 add
END FUNCTION

FUNCTION re_tas(p_aag07,p_aag08)
    DEFINE p_aag07 	LIKE aag_file.aag07      #No.FUN-680098  VARCHAR(1)
    DEFINE p_aag08	LIKE aag_file.aag08      #No.FUN-680098  VARCHAR(24)
    DEFINE amt_d,amt_c	LIKE aah_file.aah04      #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6  #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
    DEFINE rec_d,rec_c	 LIKE type_file.num5     #No.FUN-680098  smallint
    DEFINE l_i          LIKE type_file.num5      #No.FUN-680098  smallint
    DEFINE l_aag08      LIKE aag_file.aag08
    DEFINE l_aag24      LIKE aag_file.aag24
    DEFINE m_aag08	LIKE aag_file.aag08   #No.MOD-630045

    IF g_aaz.aaz83 = 'N' THEN RETURN END IF
    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE tas_file SET tas04=tas04-amt_d, tas05=tas05-amt_c,
                        tas06=tas06-rec_d, tas07=tas07-rec_c,
                        tas09=tas09-amtf_d,tas10=tas10-amtf_c
     WHERE tas00=g_aba.aba00 AND tas01=g_abb.abb03 AND tas02=g_aba.aba02
       AND tas08=g_abb.abb24
    IF STATUS THEN
#      CALL cl_err('upd re_tas:',STATUS,1)    #No.FUN-660123
#      CALL cl_err3("upd","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd re_tas:",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
       IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",g_abb.abb03,"/",g_aba.aba02,"/",g_abb.abb24
         CALL s_errmsg('tas00,tas01,tas02,tas08',g_showmsg,'upd re_tas:',STATUS,1)
       ELSE
         CALL cl_err3("upd","tas_file",g_aba.aba00,g_abb.abb03,STATUS,"","upd re_tas:",1)
       END IF
#NO.FUN-710023--END
       LET g_success='N' RETURN
    END IF
   #str CHI-890014 add
    INSERT INTO s_eom_post_tmptas
    (tas00,tas01,tas02,tas04,tas05,tas06,tas07,tas08,tas09,tas10)
    VALUES(g_aba.aba00,g_abb.abb03,g_aba.aba02,
           -amt_d,-amt_c,-rec_d,-rec_c,g_abb.abb24,-amtf_d,-amtf_c)
   #end CHI-890014 add
    IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
       CALL re_tas_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
    #  IF g_aza.aza26 = '2' THEN  #CHI-710005
          SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
           WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00     #No.FUN-740020
          #No.MOD-630045  --Begin
          IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
          LET m_aag08 = l_aag08
          FOR l_i = l_aag24 - 1  TO 1 STEP -1
             #CALL re_tas_2(l_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
              CALL re_tas_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
              LET l_aag08 = m_aag08
              SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
          END FOR
          #No.MOD-630045  --End
    #  END IF
    END IF
END FUNCTION

FUNCTION re_tas_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
   DEFINE p_aag08        LIKE aag_file.aag08
   DEFINE amt_d,amt_c	 LIKE aah_file.aah04 #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
   DEFINE amtf_d,amtf_c  LIKE aah_file.aah04 #No.FUN-4C0009  #No.FUN-680098 dec(20,6)
   DEFINE rec_d,rec_c	 LIKE type_file.num5        #No.FUN-680098 SMALLINT

   UPDATE tas_file SET tas04=tas04-amt_d, tas05=tas05-amt_c,
                       tas06=tas06-rec_d, tas07=tas07-rec_c,
                       tas09=tas09-amtf_d,tas10=tas10-amtf_c
    WHERE tas00=g_aba.aba00 AND tas01=p_aag08
      AND tas02=g_aba.aba02 AND tas08=g_abb.abb24
   IF STATUS THEN
#     CALL cl_err('upd re_tas(2):',STATUS,1)   #No.FUN-660123
#     CALL cl_err3("upd","tas_file",g_aba.aba00,g_aba.aba02,STATUS,"","upd re_tas(2):",1)   #No.FUN-660123 #NO.FUN-710023
#NO.FUN-710023--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_aba.aba00,"/",p_aag08,"/",g_aba.aba02,"/",g_abb.abb24
         CALL s_errmsg('tas00,tas01,tas02,tah08',g_showmsg,'upd re_tas(2):',STATUS,1)
      ELSE
         CALL cl_err3("upd","tas_file",g_aba.aba00,g_aba.aba02,STATUS,"","upd re_tas(2):",1)
      END IF
#NO.FUN-710023--END
      LET g_success='N' RETURN
   END IF
  #str CHI-890014 add
   INSERT INTO s_eom_post_tmptas
   (tas00,tas01,tas02,tas04,tas05,tas06,tas07,tas08,tas09,tas10)
   VALUES(g_aba.aba00,p_aag08,g_aba.aba02,
          -amt_d,-amt_c,-rec_d,-rec_c,g_abb.abb24,-amtf_d,-amtf_c)
  #end CHI-890014 add
END FUNCTION

#No.FUN-9A0052  --Begin
FUNCTION re_aeh(p_aag07,p_aag08)
    DEFINE p_aag07       LIKE aag_file.aag07
    DEFINE p_aag08       LIKE aag_file.aag08
    DEFINE amt_d,amt_c   LIKE aah_file.aah04
    DEFINE amtf_d,amtf_c LIKE type_file.num20_6
    DEFINE rec_d,rec_c	 LIKE type_file.num5
    DEFINE l_i        	 LIKE type_file.num5
    DEFINE l_aag08       LIKE aag_file.aag08
    DEFINE l_aag24       LIKE aag_file.aag24
    DEFINE m_aag08	 LIKE aag_file.aag08
    DEFINE l_str         STRING

    IF g_abb.abb06 = 1
       THEN LET amt_d = g_abb.abb07  LET rec_d = 1
            LET amt_c = 0            LET rec_c = 0
            LET amtf_d= g_abb.abb07f LET amtf_c= 0
       ELSE LET amt_d = 0            LET rec_d = 0
            LET amt_c = g_abb.abb07  LET rec_c = 1
            LET amtf_c= g_abb.abb07f LET amtf_d= 0
    END IF
    UPDATE aeh_file SET aeh11 = aeh11 - amt_d, aeh12 = aeh12 - amt_c,
                        aeh13 = aeh13 - rec_d, aeh14 = aeh14 - rec_c,
                        aeh15 = aeh15 - amtf_d,aeh16 = aeh16 - amtf_c
     WHERE aeh00=g_aba.aba00 AND aeh01=g_abb.abb03 AND aeh02=g_abb.abb05
       AND aeh03=g_abb.abb08 AND aeh08=g_abb.abb15 AND aeh09=g_aba.aba03
       AND aeh10=g_aba.aba04 AND aeh17=g_abb.abb24 AND aeh04=g_abb.abb11
       AND aeh05=g_abb.abb12 AND aeh06=g_abb.abb13 AND aeh07=g_abb.abb14
       AND aeh31=g_abb.abb31 AND aeh32=g_abb.abb32 AND aeh33=g_abb.abb33
       AND aeh34=g_abb.abb34 AND aeh35=g_abb.abb35 AND aeh36=g_abb.abb36
       AND aeh37=g_abb.abb37
    IF STATUS THEN
      IF g_bgerr THEN
         LET g_showmsg = g_aba.aba00,"/",g_abb.abb03,"/",g_abb.abb05,"/",
                         g_abb.abb08,"/",g_abb.abb15,"/",g_aba.aba03,"/",
                         g_aba.aba04,"/",g_abb.abb24,"/",g_abb.abb11,"/",
                         g_abb.abb12,"/",g_abb.abb13,"/",g_abb.abb14,"/",
                         g_abb.abb31,"/",g_abb.abb32,"/",g_abb.abb33,"/",
                         g_abb.abb34,"/",g_abb.abb35,"/",g_abb.abb36,"/",
                         g_abb.abb37
         LET l_str = " aeh00,aeh01,aeh02,",
                     " aeh03,aeh08,aeh09,",
                     " aeh10,aeh17,aeh04,",
                     " aeh05,aeh06,aeh07,",
                     " aeh31,aeh32,aeh33,",
                     " aeh34,aeh35,aeh36,",
                     " aeh37"
         CALL s_errmsg(l_str,g_showmsg,'upd re_aeh:',STATUS,1)
      ELSE
         CALL cl_err3("upd","aeh_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_aeh:",1)
      END IF
       LET g_success='N' RETURN
    END IF
   #-CHI-BB0026-add-
    INSERT INTO s_eom_post_tmpaeh (aeh00,aeh01,aeh02,aeh03,aeh04,
                                   aeh05,aeh06,aeh07,aeh08,aeh09,
                                   aeh10,aeh11,aeh12,aeh13,aeh14,
                                   aeh15,aeh16,aeh17,aeh31,aeh32,
                                   aeh33,aeh34,aeh35,aeh36,aeh37,
                                   aehlegal)
    VALUES(g_aba.aba00,g_abb.abb03,g_abb.abb05,g_abb.abb08,g_abb.abb11,
           g_abb.abb12,g_abb.abb13,g_abb.abb14,g_abb.abb15,g_aba.aba03,
           g_aba.aba04,-amt_d,-amt_c,-rec_d,-rec_c,
           -amtf_d,-amtf_c,g_abb.abb24,g_abb.abb31,g_abb.abb32,
           g_abb.abb33,g_abb.abb34,g_abb.abb35,g_abb.abb36,g_abb.abb37,
           g_legal)
   #-CHI-BB0026-end-
#   IF p_aag07 = '2' THEN #判斷是否為明細帳戶若是則處理
#      CALL re_aeh_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
#         SELECT aag08,aag24 INTO l_aag08,l_aag24 FROM aag_file
#          WHERE aag01 = p_aag08 AND aag00 = g_aba.aba00     #No.FUN-740020
#         IF cl_null(l_aag24) THEN LET l_aag24 = 1 END IF
#         LET m_aag08 = l_aag08
#         FOR l_i = l_aag24 - 1  TO 1 STEP -1
#             CALL re_aeh_2(m_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
#             LET l_aag08 = m_aag08
#             SELECT aag08 INTO m_aag08 FROM aag_file WHERE aag01 = l_aag08 AND aag00 = g_aba.aba00    #No.FUN-740020
#         END FOR
#   END IF
END FUNCTION

#FUNCTION re_aeh_2(p_aag08,amt_d,amt_c,rec_d,rec_c,amtf_d,amtf_c)
#   DEFINE p_aag08        LIKE aag_file.aag08
#   DEFINE amt_d,amt_c    LIKE aah_file.aah04
#   DEFINE rec_d,rec_c    LIKE aah_file.aah06
#   DEFINE amtf_d,amtf_c  LIKE aeh_file.aeh09
#   DEFINE l_str          STRING
#
#   UPDATE aeh_file SET aeh04 = aeh04 - amt_d, aeh05 = aeh05 - amt_c,
#                       aeh06 = aeh06 - rec_d, aeh07 = aeh07 - rec_c,
#                       aeh09 = aeh09 - amtf_d,aeh10 = aeh10 - amtf_c
#    WHERE aeh00=g_aba.aba00 AND aeh01=p_aag08
#      AND aeh02=g_aba.aba03 AND aeh03=g_aba.aba04
#      AND aeh08=g_abb.abb24
#    UPDATE aeh_file SET aeh11 = aeh11 - amt_d, aeh12 = aeh12 - amt_c,
#                           aeh13 = aeh13 - rec_d, aeh14 = aeh14 - rec_c,
#                           aeh15 = aeh15 - amtf_d,aeh16 = aeh16 - amtf_c
#     WHERE aeh00=g_aba.aba00 AND aeh01=p_aag08     AND aeh02=g_abb.abb05
#       AND aeh03=g_abb.abb08 AND aeh08=g_abb.abb15 AND aeh09=g_aba.aba03
#       AND aeh10=g_aba.aba04 AND aeh17=g_abb.abb24 AND aeh04=g_abb.abb11
#       AND aeh05=g_abb.abb12 AND aeh06=g_abb.abb13 AND aeh07=g_abb.abb14
#       AND aeh31=g_abb.abb31 AND aeh32=g_abb.abb32 AND aeh33=g_abb.abb33
#       AND aeh34=g_abb.abb34 AND aeh35=g_abb.abb35 AND aeh36=g_abb.abb36
#       AND aeh37=g_abb.abb37
#   IF STATUS THEN
#      IF g_bgerr THEN
#         LET g_showmsg = g_aba.aba00,"/",p_aag08    ,"/",g_abb.abb05,"/",
#                         g_abb.abb08,"/",g_abb.abb15,"/",g_aba.aba03,"/",
#                         g_aba.aba04,"/",g_abb.abb24,"/",g_abb.abb11,"/",
#                         g_abb.abb12,"/",g_abb.abb13,"/",g_abb.abb14,"/",
#                         g_abb.abb31,"/",g_abb.abb32,"/",g_abb.abb33,"/",
#                         g_abb.abb34,"/",g_abb.abb35,"/",g_abb.abb36,"/",
#                         g_abb.abb37
#         LET l_str = " aeh00,aeh01,aeh02,",
#                     " aeh03,aeh08,aeh09,",
#                     " aeh10,aeh17,aeh04,",
#                     " aeh05,aeh06,aeh07,",
#                     " aeh31,aeh32,aeh33,",
#                     " aeh34,aeh35,aeh36,",
#                     " aeh37"
#         CALL s_errmsg(l_str,g_showmsg,'upd re_aeh(2):',STATUS,1)
#      ELSE
#         CALL cl_err3("upd","aeh_file",g_aba.aba00,g_aba.aba03,STATUS,"","upd re_aeh(2):",1)
#      END IF
#       LET g_success='N' RETURN
#   END IF
#END FUNCTION
#No.FUN-9A0052  --End

# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: acop888.4gl
# Descriptions...: 進出口材料平衡表計算作業
# Date & Author..: 05/04/12 By Carrier
# Modify.........: No.FUN-560011 05/06/03 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-570116 06/02/27 By yiting 批次背景執行
# MOdify.........: No.TQC-660045 06/06/09 BY hellen  cl_err --> cl_err3
# MOdify.........: No.FUN-680069 06/08/23 By Czl  類型轉換
# Modify.........: No.FUN-690109 06/10/16 By johnray cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0063 06/10/26 By czl l_time轉g_time
# Modify.........: No.FUN-980002 09/08/05 By TSD.SusanWu GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-BB0083 11/12/23 By xujing 增加數量欄位小數取位 cok_file
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_cok        RECORD LIKE cok_file.*,
        g_conf       LIKE type_file.chr1,        #No.FUN-680069 VARCHAR(01)
        g_c1         LIKE type_file.chr1         #No.FUN-680069 VARCHAR(01)
DEFINE p_row,p_col   LIKE type_file.num5         #No.FUN-680069 SMALLINT
DEFINE g_cnt         LIKE type_file.num10        #No.FUN-680069 INTEGER
DEFINE g_change_lang LIKE type_file.chr1         # Prog. Version..: '5.30.06-13.03.12(01)  #No.FUN-570116
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8	    #No.FUN-6A0063
    DEFINE l_flag       LIKE type_file.chr1      #No.FUN-570116        #No.FUN-680069 VARCHAR(1)
 
    OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
 
    #No.FUN-570116--start--
     INITIALIZE g_bgjob_msgfile TO NULL
     LET g_c1 = ARG_VAL(1)
     LET g_bgjob= ARG_VAL(2)
     IF cl_null(g_bgjob)THEN
       LET g_bgjob="N"
     END IF
    #No.FUN-570116--end--
 
    IF (NOT cl_user()) THEN
       EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("ACO")) THEN
       EXIT PROGRAM
    END IF
    CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690109
 
 
#NO.FUN-570116 START---
#    OPEN WINDOW p888_w AT p_row,p_col WITH FORM "aco/42f/acop888"
#          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#    CALL cl_ui_init()
 
#    CALL p888_tm()
#    IF INT_FLAG THEN
#       LET INT_FLAG = 0
#    ELSE
#        IF cl_sure(0,0) THEN
#           BEGIN WORK
#           LET g_success='Y'
#           CALL p888_p1()
#           IF g_success = 'Y' THEN
#              CALL cl_cmmsg(1) COMMIT WORK
#           ELSE
#              CALL cl_rbmsg(1) ROLLBACK WORK
#           END IF
#        END IF
#    END IF
#    CLOSE WINDOW p888_w
WHILE TRUE
   IF g_bgjob="N" THEN
      CALL p888_tm()
      IF cl_sure(21,21) THEN
         CALL cl_wait()
         LET g_success='Y'
         BEGIN WORK
         CALL p888_p1()
         IF g_success='Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING l_flag
         END IF
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p888_w
            EXIT WHILE
         END IF
      ELSE
         CONTINUE WHILE
      END IF
   ELSE
      LET g_success='Y'
      BEGIN WORK
      CALL p888_p1()
      IF g_success="Y" THEN
         CALL cl_cmmsg(1)
         COMMIT WORK
      ELSE
         CALL cl_rbmsg(1)
         ROLLBACK WORK
      END IF
      CALL cl_batch_bg_javamail(g_success)
      EXIT WHILE
   END IF
END WHILE
# No.FUN-570116--end--
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
END MAIN
 
FUNCTION p888_tm()
  DEFINE lc_cmd    LIKE type_file.chr1000      #No.FUN-680069 VARCHAR(500)   #No.FUN-570116
    #No.FUN-570116--start--
      OPEN WINDOW p888_w AT p_row,p_col WITH FORM "aco/42f/acop888"
        ATTRIBUTE(STYLE=g_win_style)
      CALL cl_ui_init()
      CLEAR FORM
   #No.FUN-570116--end--
 
   LET g_conf='Y'
   LET g_bgjob = "N"         #No.FUN-570116
 
   DISPLAY g_conf TO FORMONLY.conf
 
  WHILE TRUE
   #INPUT g_conf WITHOUT DEFAULTS FROM conf
   INPUT g_conf,g_bgjob WITHOUT DEFAULTS FROM conf,g_bgjob  #NO.FUN-570116 
 
       ON ACTION locale
          #CALL cl_dynamic_locale()
          #CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_change_lang = TRUE
          EXIT INPUT                                #No.FUN-570116--end--
 
 
       AFTER FIELD conf
          IF cl_null(g_conf) OR g_conf NOT MATCHES '[YN]' THEN NEXT FIELD conf END IF
 
       ON ACTION CONTROLR
          CALL cl_show_req_fields()
 
       ON ACTION CONTROLG
          CALL cl_cmdask()
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121 
 
 
       ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT INPUT
 
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_set_comp_entry("g_bgjob",TRUE)   #NO.FUN-570116 
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   #No.FUN-570611--start--
    IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CONTINUE WHILE
    END IF
    IF INT_FLAG THEN
       LET INT_FLAG=0
       CLOSE WINDOW p888_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
      END IF
#   IF INT_FLAG THEN
#      LET INT_FLAG=0
#      EXIT PROGRAM
#   END IF
 
    IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
          WHERE zz01 = "acop888"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
          CALL cl_err('acop888','9031',1)
        ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                   " '",g_c1  CLIPPED,"'",
                   " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('acop888',g_time,lc_cmd CLIPPED)
       END IF
         CLOSE WINDOW p888_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690109
       EXIT PROGRAM
     END IF
   EXIT WHILE
 END WHILE
 #No.FUN-570116--end---
 
END FUNCTION
 
FUNCTION p888_p1()
 DEFINE  l_sql       LIKE type_file.chr1000,   #No.FUN-680069 VARCHAR(600)
         l_cok       RECORD LIKE cok_file.*,
         l_coc10     LIKE coc_file.coc10,
         l_ima01     LIKE ima_file.ima01,
         l_amount    LIKE coq_file.coq10,
         l_unit      LIKE gfe_file.gfe01,
         l_coa04     LIKE coa_file.coa04,
         l_ima25     LIKE ima_file.ima25,
         l_coq07     LIKE coq_file.coq07,
         l_cok07     LIKE cok_file.cok07,
         l_cok18     LIKE cok_file.cok18,
         l_coq17     LIKE coq_file.coq17,
         l_cop16     LIKE cop_file.cop16,
         l_cok03_1   LIKE cok_file.cok03,
         l_cok03_2   LIKE cok_file.cok03,
         l_cok17_1   LIKE cok_file.cok17,
         l_cok17_2   LIKE cok_file.cok17,
         l_coq10     LIKE coq_file.coq10,
         l_col10     LIKE col_file.col10,
         l_lvl       LIKE type_file.num5,      #No.FUN-680069 SMALLINT
         l_fac       LIKE coa_file.coa04       #No.FUN-680069 DEC(16,8)
 
   #由于coq_file中沒有記錄商品編號,折合的原料資料沒法拆開
   #目前是只歸在第一個對應的商品編號內...此部分的值應該由人工調整
#No.FUN-680069-begin
   CREATE TEMP TABLE p888_ima (
               ima01  LIKE ima_file.ima01)
#No.FUN-680069-end
 
 
#No.FUN-680069-begin
   CREATE TEMP TABLE p888_cna (
               cna01  LIKE cna_file.cna01,
               lvl    LIKE type_file.num5);
#No.FUN-680069-end
 
   INSERT INTO p888_cna SELECT cna01,99 FROM cna_file
   IF SQLCA.sqlcode THEN
#     CALL cl_err('create p888_cna',SQLCA.sqlcode,0) #No.TQC-660045
      CALL cl_err3("ins","p888_cna","","",SQLCA.sqlcode,"","create p888_cna",0) #TQC-660045
   END IF
   UPDATE p888_cna SET lvl=0 WHERE cna01=g_coz.coz02
   IF SQLCA.sqlcode or SQLCA.sqlerrd[3]=0 THEN
#     CALL cl_err('update p888_cna',SQLCA.sqlcode,0) #No.TQC-660045
      CALL cl_err3("upd","p888_cna",g_coz.coz02,"",SQLCA.sqlcode,"","update p888_cna",0) #TQC-660045
   END IF
 
   DELETE FROM cok_file
   IF SQLCA.sqlcode THEN
#     CALL cl_err('delete cok',SQLCA.sqlcode,0) #No.TQC-660045
      CALL cl_err3("del","cok_file","","",SQLCA.sqlcode,"","delete cok",0) #TQC-660045
      LET g_success='N'
      RETURN
   END IF
 
   DELETE FROM p888_ima
 
   LET l_sql = " SELECT UNIQUE lvl,coc03,coc10,coe03,coe06 ", #合同基本資料檔
               "   FROM coc_file,coe_file,p888_cna",
               "  WHERE coc01 = coe01",
               "    AND coc10 = cna01",
               "  ORDER BY lvl,coc03,coc10,coe03,coe06 "
 
   PREPARE p888_precoe   FROM l_sql
   DECLARE p888_coe_cur  CURSOR FOR p888_precoe
 
   LET l_sql = "SELECT coa01,coa04 FROM coa_file ",    #廠內料件及轉換率
               " WHERE coa05 = ?",
               "   AND coa03 = ?"
   PREPARE p888_pre1   FROM l_sql
   DECLARE p888_ima  CURSOR FOR p888_pre1
 
   ##################cok10 委外加工折原料#########################
   LET l_sql = "SELECT SUM(coq17),coq16 FROM coq_file,sfb_file ",
               " WHERE coq01 = ?    AND coq00 = '1' ",
               "   AND coq02 =sfb01 AND (sfb02 =7 OR sfb02=8) ",
               " GROUP BY coq16 "
   PREPARE p888_pren3  FROM l_sql
   DECLARE coq17_1 CURSOR FOR p888_pren3
   ###############################################################
 
   ##################cok11 在制工單折原料#########################
   LET l_sql = "SELECT SUM(coq17),coq16 FROM coq_file,sfb_file ",
               " WHERE coq01 = ?    AND coq00 = '1' ",
               "   AND coq02 =sfb01 AND (sfb02 <>7 AND sfb02<>8) ",
               " GROUP BY coq16 "
   PREPARE p888_pren4  FROM l_sql
   DECLARE coq17_2 CURSOR FOR p888_pren4
   ###############################################################
 
   ##################cok12 原材料#################################
   LET l_sql = "SELECT SUM(coq07),coq06 FROM coq_file ",   #cok12
               " WHERE coq01 = ?    AND coq00 = '0' ",
               " GROUP BY coq06 "
   PREPARE p888_pren5  FROM l_sql
   DECLARE coq07_1 CURSOR FOR p888_pren5
   ###############################################################
 
   ##################cok13 半成品折原料###########################
   LET l_sql = "SELECT SUM(coq10),coq09 FROM coq_file ",   #cok13
               " WHERE coq01 = ?    AND coq00 = '2' ",
               " GROUP BY coq09 "
   PREPARE p888_pren6  FROM l_sql
   DECLARE coq10_1 CURSOR FOR p888_pren6
   ###############################################################
 
   ##################cok14 庫存成品折原料#########################
   LET l_sql = "SELECT SUM(coq10),coq09 FROM coq_file ",   #cok14
               " WHERE coq01 = ?    AND coq00 = '3' ",
               " GROUP BY coq09 "
   PREPARE p888_pren7  FROM l_sql
   DECLARE coq10_2 CURSOR FOR p888_pren7
   ###############################################################
 
   FOREACH p888_coe_cur INTO l_lvl,l_cok.cok00,l_coc10,l_cok.cok01,l_cok.cok02
     IF SQLCA.sqlcode THEN
        CALL cl_err('p888_coe_cur',SQLCA.sqlcode,0)
        EXIT FOREACH
     END IF
     IF g_bgjob = 'Y' THEN   #NO.FUN-570116 
         MESSAGE l_cok.cok00 CLIPPED,l_cok.cok01 CLIPPED,l_cok.cok02 CLIPPED
     END IF
     LET l_cok.cok03=0 LET l_cok.cok04=0 LET l_cok.cok05=0
     LET l_cok.cok06=0 LET l_cok.cok07=0 LET l_cok.cok08=0
     LET l_cok.cok09=0 LET l_cok.cok10=0 LET l_cok.cok11=0
     LET l_cok.cok12=0 LET l_cok.cok13=0 LET l_cok.cok14=0
     LET l_cok.cok15=0 LET l_cok.cok16=0 LET l_cok.cok17=0
     LET l_cok.cok18=0 LET l_cok.cok19=0 LET l_cok.cok20=0
     LET l_cok.cok21=0
 
     FOREACH p888_ima USING l_coc10,l_cok.cok01 INTO l_ima01,l_coa04
        IF g_bgjob = 'Y' THEN   #NO.FUN-570116 
            MESSAGE l_ima01
        END IF
        IF SQLCA.sqlcode THEN
           CALL cl_err('p888_ima',SQLCA.sqlcode,0)
           EXIT FOREACH
        END IF
        SELECT ima01 FROM p888_ima WHERE ima01=l_ima01
        IF SQLCA.sqlcode = 0 THEN   #該料件已折過原料了
           CONTINUE FOREACH
        ELSE
           INSERT INTO p888_ima VALUES(l_ima01)
           IF SQLCA.sqlcode THEN
#             CALL cl_err('insert p888_ima',SQLCA.sqlcode,0) #No.TQC-660045
              CALL cl_err3("ins","p888_ima",l_ima01,"",SQLCA.sqlcode,"","insert p888_ima",0) #TQC-660045
           END IF
        END IF
        IF cl_null(l_coa04) THEN LET l_coa04=1 END IF
        SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_ima01
 
###########fetch cok10委外加工折原料#############
        LET l_coq17=0
        FOREACH coq17_1 USING l_ima01 INTO l_amount,l_unit
           IF SQLCA.sqlcode THEN
              CALL cl_err('coq17_1',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF cl_null(l_amount) THEN LET l_amount=0 END IF
           CALL p888_umf(l_ima01,l_unit,l_ima25) RETURNING l_fac
           LET l_amount=l_amount*l_fac*l_coa04
           LET l_coq17=l_coq17+l_amount
        END FOREACH
        LET l_cok.cok10=l_cok.cok10+l_coq17
        LET l_cok.cok10=s_digqty(l_cok.cok10,l_cok.cok02) #FUN-BB0083 add
#####################################
#########fetch cok11在制工單折原料#################
        LET l_coq17=0
        FOREACH coq17_2 USING l_ima01 INTO l_amount,l_unit
           IF SQLCA.sqlcode THEN
              CALL cl_err('coq17_2',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF cl_null(l_amount) THEN LET l_amount=0 END IF
           CALL p888_umf(l_ima01,l_unit,l_ima25) RETURNING l_fac
           LET l_amount=l_amount*l_fac*l_coa04
           LET l_coq17=l_coq17+l_amount
        END FOREACH
        LET l_cok.cok11=l_cok.cok11+l_coq17
        LET l_cok.cok11=s_digqty(l_cok.cok11,l_cok.cok02) #FUN-BB0083 add
#####################################
#########fetch cok12原材料#################
        LET l_coq07=0
        FOREACH coq07_1 USING l_ima01 INTO l_amount,l_unit
           IF SQLCA.sqlcode THEN
              CALL cl_err('coq07_1',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF cl_null(l_amount) THEN LET l_amount=0 END IF
           CALL p888_umf(l_ima01,l_unit,l_ima25) RETURNING l_fac
           LET l_amount=l_amount*l_fac*l_coa04
           LET l_coq07=l_coq07+l_amount
        END FOREACH
        LET l_cok.cok12=l_cok.cok12+l_coq07
        LET l_cok.cok12=s_digqty(l_cok.cok12,l_cok.cok02) #FUN-BB0083 add
#####################################
#########fetch cok13半成品折原料#################
        LET l_coq10=0
        FOREACH coq10_1 USING l_ima01 INTO l_amount,l_unit
           IF SQLCA.sqlcode THEN
              CALL cl_err('coq10_1',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF cl_null(l_amount) THEN LET l_amount=0 END IF
           CALL p888_umf(l_ima01,l_unit,l_ima25) RETURNING l_fac
           LET l_amount=l_amount*l_fac*l_coa04
           LET l_coq10=l_coq10+l_amount
        END FOREACH
        LET l_cok.cok13=l_cok.cok13+l_coq10
        LET l_cok.cok13=s_digqty(l_cok.cok13,l_cok.cok02) #FUN-BB0083 add
#####################################
#########fetch cok14庫存成品折原料#################
        LET l_coq10=0
        FOREACH coq10_2 USING l_ima01 INTO l_amount,l_unit
           IF SQLCA.sqlcode THEN
              CALL cl_err('coq10_2',SQLCA.sqlcode,0)
              EXIT FOREACH
           END IF
           IF cl_null(l_amount) THEN LET l_amount=0 END IF
           CALL p888_umf(l_ima01,l_unit,l_ima25) RETURNING l_fac
           LET l_amount=l_amount*l_fac*l_coa04
           LET l_coq10=l_coq10+l_amount
        END FOREACH
        LET l_cok.cok14=l_cok.cok14+l_coq10
        LET l_cok.cok14=s_digqty(l_cok.cok14,l_cok.cok02) #FUN-BB0083 add
#####################################
     END FOREACH    #ima
 
   #####################cok03 直接進口 ##########################
     SELECT SUM(cop16) INTO l_cok03_1 FROM cop_file    #cok03_1
      WHERE cop18 = l_cok.cok00   AND cop11 = l_cok.cok01
        AND cop20 = 'Y' AND copacti = 'Y'
        AND cop07 <> ' ' AND cop07 IS NOT NULL
        AND cop10 = '1'
     IF cl_null(l_cok03_1) THEN LET l_cok03_1=0 END IF
     SELECT SUM(cop16) INTO l_cok03_2 FROM cop_file    #cok03_1
      WHERE cop18 = l_cok.cok00   AND cop11 = l_cok.cok01
        AND cop20 = 'Y' AND copacti = 'Y'
        AND cop07 <> ' ' AND cop07 IS NOT NULL
        AND cop10 = '4'
     IF cl_null(l_cok03_2) THEN LET l_cok03_2=0 END IF
     LET l_cok.cok03=l_cok03_1-l_cok03_2
     LET l_cok.cok03=s_digqty(l_cok.cok03,l_cok.cok02) #FUN-BB0083 add
   ###############################################################
 
   #####################cok15 轉廠進口 ##########################
     SELECT SUM(cop16) INTO l_cok03_1 FROM cop_file    #cok03_1
      WHERE cop18 = l_cok.cok00   AND cop11 = l_cok.cok01
        AND cop20 = 'Y' AND copacti = 'Y'
        AND cop07 <> ' ' AND cop07 IS NOT NULL
        AND cop10 = '2'
     IF cl_null(l_cok03_1) THEN LET l_cok03_1=0 END IF
     SELECT SUM(cop16) INTO l_cok03_2 FROM cop_file    #cok03_1
      WHERE cop18 = l_cok.cok00   AND cop11 = l_cok.cok01
        AND cop20 = 'Y' AND copacti = 'Y'
        AND cop07 <> ' ' AND cop07 IS NOT NULL
        AND cop10 = '5'
     IF cl_null(l_cok03_2) THEN LET l_cok03_2=0 END IF
     LET l_cok.cok15=l_cok03_1-l_cok03_2
     LET l_cok.cok15=s_digqty(l_cok.cok15,l_cok.cok02) #FUN-BB0083 add
   ###############################################################
   #####################cok17 國內採購 ##########################
     SELECT SUM(cop16) INTO l_cok03_1 FROM cop_file    #cok03_1
      WHERE cop18 = l_cok.cok00   AND cop11 = l_cok.cok01
        AND cop20 = 'Y' AND copacti = 'Y'
        AND cop07 <> ' ' AND cop07 IS NOT NULL
        AND cop10 = '3'
     IF cl_null(l_cok03_1) THEN LET l_cok03_1=0 END IF
     SELECT SUM(cop16) INTO l_cok03_2 FROM cop_file    #cok03_1
      WHERE cop18 = l_cok.cok00   AND cop11 = l_cok.cok01
        AND cop20 = 'Y' AND copacti = 'Y'
        AND cop07 <> ' ' AND cop07 IS NOT NULL
        AND cop10 = '6'
     IF cl_null(l_cok03_2) THEN LET l_cok03_2=0 END IF
     LET l_cok.cok17=l_cok03_1-l_cok03_2
     LET l_cok.cok17=s_digqty(l_cok.cok17,l_cok.cok02) #FUN-BB0083 add
   ###############################################################
 
   #####################cok07 直接耗用############################
     SELECT SUM(col10) INTO l_cok03_1 FROM col_file,coo_file     #cok07_1
      WHERE coo01=col01 AND coo02=col02
        AND coo10='1'
        AND col04=l_cok.cok01 AND coo18=l_cok.cok00
        AND col06=l_cok.cok02
        AND coo20='Y'
        AND coo07 <> ' ' AND coo07 IS NOT NULL
        AND cooacti = 'Y'
     IF cl_null(l_cok03_1) THEN LET l_cok03_1=0 END IF
     SELECT SUM(col10) INTO l_cok03_2 FROM col_file,coo_file     #cok07_6
      WHERE coo01=col01 AND coo02=col02
        AND coo10='6'
        AND col04=l_cok.cok01 AND coo18=l_cok.cok00
        AND col06=l_cok.cok02
        AND coo20='Y'
        AND coo07 <> ' ' AND coo07 IS NOT NULL
        AND cooacti = 'Y'
     IF cl_null(l_cok03_2) THEN LET l_cok03_2=0 END IF
     LET l_cok.cok07=l_cok03_1-l_cok03_2
     LET l_cok.cok07=s_digqty(l_cok.cok07,l_cok.cok02) #FUN-BB0083 add
   ###############################################################
   #####################cok16 轉廠耗用############################
     SELECT SUM(col10) INTO l_cok03_1 FROM col_file,coo_file     #cok07_1
      WHERE coo01=col01 AND coo02=col02
        AND coo10='2'
        AND col04=l_cok.cok01 AND coo18=l_cok.cok00
        AND col06=l_cok.cok02
        AND coo20='Y'
        AND coo07 <> ' ' AND coo07 IS NOT NULL
        AND cooacti = 'Y'
     IF cl_null(l_cok03_1) THEN LET l_cok03_1=0 END IF
     SELECT SUM(col10) INTO l_cok03_2 FROM col_file,coo_file     #cok07_6
      WHERE coo01=col01 AND coo02=col02
        AND coo10='7'
        AND col04=l_cok.cok01 AND coo18=l_cok.cok00
        AND col06=l_cok.cok02
        AND coo20='Y'
        AND coo07 <> ' ' AND coo07 IS NOT NULL
        AND cooacti = 'Y'
     IF cl_null(l_cok03_2) THEN LET l_cok03_2=0 END IF
     LET l_cok.cok16=l_cok03_1-l_cok03_2
     LET l_cok.cok16=s_digqty(l_cok.cok16,l_cok.cok02) #FUN-BB0083 add
   ###############################################################
   #####################cok20 內銷耗用############################
     SELECT SUM(col10) INTO l_cok03_1 FROM col_file,coo_file     #cok07_1
      WHERE coo01=col01 AND coo02=col02
        AND coo10='0'
        AND col04=l_cok.cok01 AND coo18=l_cok.cok00
        AND col06=l_cok.cok02
        AND coo20='Y'
        AND coo07 <> ' ' AND coo07 IS NOT NULL
        AND cooacti = 'Y'
     IF cl_null(l_cok03_1) THEN LET l_cok03_1=0 END IF
     SELECT SUM(col10) INTO l_cok03_2 FROM col_file,coo_file     #cok07_6
      WHERE coo01=col01 AND coo02=col02
        AND coo10='5'
        AND col04=l_cok.cok01 AND coo18=l_cok.cok00
        AND col06=l_cok.cok02
        AND coo20='Y'
        AND coo07 <> ' ' AND coo07 IS NOT NULL
        AND cooacti = 'Y'
     IF cl_null(l_cok03_2) THEN LET l_cok03_2=0 END IF
     LET l_cok.cok20=l_cok03_1-l_cok03_2
     LET l_cok.cok20=s_digqty(l_cok.cok20,l_cok.cok02) #FUN-BB0083 add
   ###############################################################
   #####################cok06 制造損耗############################
     SELECT SUM(col10) INTO l_cok.cok06 FROM col_file,coo_file     #cok06
      WHERE coo01=col01 AND coo02=col02
        AND (coo10='4' OR coo10='3')
        AND col04=l_cok.cok01 AND coo18=l_cok.cok00
        AND col06=l_cok.cok02
        AND coo20='Y'
        AND coo07 <> ' ' AND coo07 IS NOT NULL
        AND cooacti = 'Y'
     IF cl_null(l_cok.cok06) THEN LET l_cok.cok06=0 END IF
     SELECT SUM(cop16) INTO l_cok03_2 FROM cop_file    #cok03_1
      WHERE cop18 = l_cok.cok00   AND cop11 = l_cok.cok01
        AND cop20 = 'Y' AND copacti = 'Y'
        AND cop07 <> ' ' AND cop07 IS NOT NULL
        AND cop10='7'
     IF cl_null(l_cok03_2) THEN LET l_cok03_2 = 0 END IF
     LET l_cok.cok06 = l_cok.cok06 + l_cok03_2
     LET l_cok.cok06=s_digqty(l_cok.cok06,l_cok.cok02) #FUN-BB0083 add
   ###############################################################
     MESSAGE ""
     LET l_cok.cokplant = g_plant #FUN-980002
     LET l_cok.coklegal = g_legal #FUN-980002
 
     INSERT INTO cok_file VALUES(l_cok.*)
     IF SQLCA.sqlcode THEN LET g_success = 'N' EXIT FOREACH END IF
   END FOREACH
 
 
END FUNCTION
 
FUNCTION p888_umf(p_ima01,p_unit,p_ima25)
  DEFINE p_unit      LIKE gfe_file.gfe01,
         p_ima25     LIKE ima_file.ima25,
         p_ima01     LIKE ima_file.ima01,
         l_fac       LIKE coa_file.coa04       #No.FUN-680069 DEC(16,8)
 
         LET l_fac=1
         IF p_unit <> p_ima25 THEN
            CALL s_umfchk(p_ima01,p_unit,p_ima25)
                 RETURNING g_cnt,l_fac
            IF g_cnt = 1 THEN
               CALL cl_err(p_ima01,'mfg3075',0)
               LET l_fac=1
            END IF
         END IF
         RETURN l_fac
END FUNCTION
#Patch....NO.TQC-610035 <001,002,003> #

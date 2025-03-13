# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: artt100_sub.4gl
# Descriptions...: 策略批量審批調整單 -- 變更發出功能
# Date & Author..: FUN-BC0076 11/12/27 By baogc
# Modify.........: No:TQC-C30322 12/03/29 by pauline 變更發出時在價格策略時應把計價單位加入當做key值 
# Modify.........: No:FUN-C50036 12/05/22 by fanbj 更新生效日期
# Modify.........: No:FUN-C80076 12/08/22 By nanbing 如果rtj25為空，則賦值為0
DATABASE ds

GLOBALS "../../config/top.global"

FUNCTION t100_sub(p_no,p_org)
DEFINE p_no  LIKE rti_file.rti01
DEFINE p_org LIKE azp_file.azp01

   WHENEVER ERROR CONTINUE

   #變更產品策略
   IF g_success = 'Y' THEN 
      CALL t100_sub_rtdrte(p_no,p_org)
   END IF 

   #變更價格策略
   IF g_success = 'Y' THEN 
      CALL t100_sub_rtfrtg(p_no,p_org)
   END IF 

   #變更採購策略
   IF g_success = 'Y' THEN 
      CALL t100_sub_rty(p_no,p_org)
   END IF 
END FUNCTION

#產品策略
FUNCTION t100_sub_rtdrte(p_no,p_org)
DEFINE p_no     LIKE rti_file.rti01
DEFINE p_org    LIKE azp_file.azp01
DEFINE l_sql    STRING
DEFINE l_n      LIKE type_file.num5
DEFINE l_rtj    RECORD
       rtj24    LIKE rtj_file.rtj24,
       rtj03    LIKE rtj_file.rtj03,
       rtj04    LIKE rtj_file.rtj04,
       rtj06    LIKE rtj_file.rtj06,
       rtj07    LIKE rtj_file.rtj07,
       rtj08    LIKE rtj_file.rtj08,
       rtj20    LIKE rtj_file.rtj20,
       rtj21    LIKE rtj_file.rtj21
                END RECORD 
DEFINE l_rte02  LIKE rte_file.rte02
DEFINE l_ruh04  LIKE ruh_file.ruh04
DEFINE l_ruh06  LIKE ruh_file.ruh06
DEFINE l_rvy03  LIKE rvy_file.rvy03
DEFINE l_rtepos LIKE rte_file.rtepos

   #從策略變更單單身檔中抓取產品策略編號
   LET l_sql = "SELECT rtj24,rtj03,rtj04,rtj06,rtj07,rtj08,rtj20,rtj21 ",
               "  FROM ",cl_get_target_table(p_org,'rtj_file'),
               " WHERE rtj01 = '",p_no,"' ",
               "   AND rtj02 = '1' ",
               " ORDER BY rtj24,rtj04 "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
   PREPARE sel_rtj_pre1 FROM l_sql
   DECLARE sel_rtj_cs1 CURSOR FOR sel_rtj_pre1
   FOREACH sel_rtj_cs1 INTO l_rtj.*
      IF STATUS THEN
         CALL s_errmsg('','','foreach',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH 
      END IF 

      #預先定義抓取多稅種所需的CURSOR
      LET l_sql = "SELECT ruh04,ruh06 ",
                  "  FROM ",cl_get_target_table(p_org,'ruh_file'),
                  " WHERE ruh01 = '",p_no,"' AND ruh02 = '",l_rtj.rtj03,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
      PREPARE sel_ruh_pre FROM l_sql
      DECLARE sel_ruh_cs CURSOR FOR sel_ruh_pre
      
      #備註：1.產品策略維護作業若不存在當前策略則新增該產品策略
      #     2.若存在，則判斷產品策略+產品編號是否存在，若存在則更新反之則新增
     #SELECT COUNT(*) INTO l_n FROM rtd_file WHERE rtd01 = l_rtj.rtj24
      LET l_sql = "SELECT COUNT(*) ",
                  "  FROM ",cl_get_target_table(p_org,'rtd_file'),
                  " WHERE rtd01 = '",l_rtj.rtj24,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
      PREPARE sel_rtd_pre FROM l_sql 
      EXECUTE sel_rtd_pre INTO l_n

      #存在當前產品策略
      IF l_n > 0 THEN
         LET l_n = 0
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM ",cl_get_target_table(p_org,'rte_file'), 
                     " WHERE rte01 = '",l_rtj.rtj24,"' AND rte03 = '",l_rtj.rtj04,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
         PREPARE sel_rte_pre1 FROM l_sql
         EXECUTE sel_rte_pre1 INTO l_n
         #存在該產品策略+產品編號信息
         IF l_n > 0 THEN
            #抓取當前產品策略+產品編號在產品基本資料中的項次
            LET l_sql = "SELECT rte02,rtepos ",
                        "  FROM ",cl_get_target_table(p_org,'rte_file'),
                        " WHERE rte01 = '",l_rtj.rtj24,"' AND rte03 = '",l_rtj.rtj04,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
            PREPARE sel_rte_pre2 FROM l_sql
            EXECUTE sel_rte_pre2 INTO l_rte02,l_rtepos
            IF l_rtepos <> '1' THEN LET l_rtepos = '2' END IF

            #更新產品策略基本資料的單身信息
            LET l_sql = "UPDATE ",cl_get_target_table(p_org,'rte_file'),
                        "   SET rte04  = '",l_rtj.rtj06,"', ",
                        "       rte05  = '",l_rtj.rtj07,"', ",
                        "       rte06  = '",l_rtj.rtj08,"', ",
                        "       rte07  = '",l_rtj.rtj20,"', ",
                        "       rte08  = '",l_rtj.rtj21,"', ",
                        "       rte09  = '2', ",
                        "       rtepos = '",l_rtepos,"' ",
                        " WHERE rte01  = '",l_rtj.rtj24,"' AND rte02 = '",l_rte02,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
            PREPARE upd_rte_pre FROM l_sql
            EXECUTE upd_rte_pre
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('rte01',l_rtj.rtj24,'upd rtj_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN 
            END IF
            
            #刪除對應的多稅種信息
            LET l_sql = "DELETE FROM ",cl_get_target_table(p_org,'rvy_file'),
                        " WHERE rvy01 = '",l_rtj.rtj24,"' AND rvy02 = '",l_rte02,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
            PREPARE del_rvy_pre FROM l_sql
            EXECUTE del_rvy_pre
            IF SQLCA.sqlcode THEN 
               CALL s_errmsg('rvy01',l_rtj.rtj24,'del rvy_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN 
            END IF 

            #新增多稅種資料
            FOREACH sel_ruh_cs INTO l_ruh04,l_ruh06
               IF STATUS THEN 
                  CALL s_errmsg('','','foreach:',STATUS,1)
                  LET g_success = 'N'
                  RETURN 
               END IF 
               INITIALIZE l_rvy03 TO NULL 
               LET l_sql = "SELECT MAX(rvy03)+1 ",
                           "  FROM ",cl_get_target_table(p_org,'rvy_file'), 
                           " WHERE rvy01 = '",l_rtj.rtj24,"' AND rvy02 = '",l_rte02,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
               PREPARE sel_rvy_pre1 FROM l_sql
               EXECUTE sel_rvy_pre1 INTO l_rvy03
               IF cl_null(l_rvy03) THEN LET l_rvy03 = 1 END IF 
               LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rvy_file'),
                           "              (rvy01,rvy02,rvy03,rvy04,rvy05,rvy06) ",
                           "VALUES(?,?,?,?,?,?) "
               PREPARE ins_rvy_pre1 FROM l_sql
               EXECUTE ins_rvy_pre1 USING l_rtj.rtj24,l_rte02,l_rvy03,l_ruh04,'2',l_ruh06
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL s_errmsg('rvy01',l_rtj.rtj24,'ins rvy_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN 
               END IF
            END FOREACH
         #不存在該產品策略+產品編號信息
         ELSE
            INITIALIZE l_rte02 TO NULL
            LET l_sql = "SELECT MAX(rte02)+1 ",
                        "  FROM ",cl_get_target_table(p_org,'rte_file'),
                        " WHERE rte01 = '",l_rtj.rtj24,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
            PREPARE sel_rte_pre3 FROM l_sql
            EXECUTE sel_rte_pre3 INTO l_rte02
            IF cl_null(l_rte02) THEN LET l_rte02 = 1 END IF
            LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rte_file'),
                        "              (rte01,rte02,rte03,rte04,rte05,rte06, ",
                        "               rte07,rte08,rte09,rtepos) ",
                        "VALUES(?,?,?,?,?,?,?,?,?,?) "
            PREPARE ins_rte_pre1 FROM l_sql
            EXECUTE ins_rte_pre1 USING l_rtj.rtj24,l_rte02,l_rtj.rtj04,l_rtj.rtj06,
                                       l_rtj.rtj07,l_rtj.rtj08,l_rtj.rtj20,l_rtj.rtj21,'2','1'
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('rte01',l_rtj.rtj24,'ins rte_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN 
            END IF

            #新增多稅種資料
            FOREACH sel_ruh_cs INTO l_ruh04,l_ruh06
               IF STATUS THEN 
                  CALL s_errmsg('','','foreach:',STATUS,1)
                  LET g_success = 'N'
                  EXIT FOREACH 
               END IF 
               LET l_sql = "SELECT MAX(rvy03)+1 ",
                           "  FROM ",cl_get_target_table(p_org,'rvy_file'), 
                           " WHERE rvy01 = '",l_rtj.rtj24,"' AND rvy02 = '",l_rte02,"' "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
               PREPARE sel_rvy_pre2 FROM l_sql
               EXECUTE sel_rvy_pre2 INTO l_rvy03
               IF cl_null(l_rvy03) THEN LET l_rvy03 = 1 END IF
               LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rvy_file'),
                           "              (rvy01,rvy02,rvy03,rvy04,rvy05,rvy06) ",
                           "VALUES(?,?,?,?,?,?) "
               PREPARE ins_rvy_pre2 FROM l_sql
               EXECUTE ins_rvy_pre2 USING l_rtj.rtj24,l_rte02,l_rvy03,l_ruh04,'2',l_ruh06
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL s_errmsg('rvy01',l_rtj.rtj24,'ins rvy_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN 
               END IF
            END FOREACH 
         END IF
      #不存在當前產品策略
      ELSE
         #新增產品策略單頭資料
         LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rtd_file'),
                     "              (rtd01,rtd02,rtd03,rtd04,rtd05,rtdacti,rtdcond,rtdconf, ",
                     "               rtdconu,rtdcrat,rtddate,rtdgrup,rtdmodu,rtdorig,rtdoriu,rtduser) ",
                     "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
         PREPARE ins_rtd_pre FROM l_sql
         EXECUTE ins_rtd_pre USING l_rtj.rtj24,'',g_plant,'0','','Y',g_today,'Y',
                                   g_user,g_today,'',g_grup,'',g_grup,g_user,g_user
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rtd01',l_rtj.rtj24,'ins rtd_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN 
         END IF

         #新增產品策略單身資料
         INITIALIZE l_rte02 TO NULL
         LET l_sql = "SELECT MAX(rte02)+1 ",
                     "  FROM ",cl_get_target_table(p_org,'rte_file'),
                     " WHERE rte01 = '",l_rtj.rtj24,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
         PREPARE sel_rte_pre4 FROM l_sql
         EXECUTE sel_rte_pre4 INTO l_rte02
         IF cl_null(l_rte02) THEN LET l_rte02 = 1 END IF
         LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rte_file'),
                     "              (rte01,rte02,rte03,rte04,rte05,rte06, ",
                     "               rte07,rte08,rte09,rtepos) ",
                     "VALUES(?,?,?,?,?,?,?,?,?,?) "
         PREPARE ins_rte_pre2 FROM l_sql
         EXECUTE ins_rte_pre2 USING l_rtj.rtj24,l_rte02,l_rtj.rtj04,l_rtj.rtj06,
                                   l_rtj.rtj07,l_rtj.rtj08,l_rtj.rtj20,l_rtj.rtj21,'2','1'
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rte01',l_rtj.rtj24,'ins rte_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN 
         END IF

         #新增多稅種資料
         FOREACH sel_ruh_cs INTO l_ruh04,l_ruh06
            IF STATUS THEN 
               CALL s_errmsg('','','foreach:',STATUS,1)
               LET g_success = 'N'
               EXIT FOREACH 
            END IF 
            LET l_sql = "SELECT MAX(rvy03)+1 ",
                        "  FROM ",cl_get_target_table(p_org,'rvy_file'), 
                        " WHERE rvy01 = '",l_rtj.rtj24,"' AND rvy02 = '",l_rte02,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
            PREPARE sel_rvy_pre3 FROM l_sql
            EXECUTE sel_rvy_pre3 INTO l_rvy03
            IF cl_null(l_rvy03) THEN LET l_rvy03 = 1 END IF
            LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rvy_file'),
                        "              (rvy01,rvy02,rvy03,rvy04,rvy05,rvy06) ",
                        "VALUES(?,?,?,?,?,?) "
            PREPARE ins_rvy_pre3 FROM l_sql
            EXECUTE ins_rvy_pre3 USING l_rtj.rtj24,l_rte02,l_rvy03,l_ruh04,'2',l_ruh06
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('rvy01',l_rtj.rtj24,'ins rvy_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN 
            END IF
         END FOREACH 
      END IF
   END FOREACH 
END FUNCTION

#價格策略
FUNCTION t100_sub_rtfrtg(p_no,p_org)
DEFINE p_no        LIKE rti_file.rti01
DEFINE p_org       LIKE azp_file.azp01
DEFINE l_rtg02     LIKE rtg_file.rtg02
DEFINE l_rtg08     LIKE rtg_file.rtg08
DEFINE l_rtgpos    LIKE rtg_file.rtgpos
DEFINE l_rtz01     LIKE rtz_file.rtz01
DEFINE l_n         LIKE type_file.num5
DEFINE l_sql       STRING
DEFINE l_rtj       RECORD
       rtj24       LIKE rtj_file.rtj24,
       rtj03       LIKE rtj_file.rtj03,
       rtj04       LIKE rtj_file.rtj04,
       rtj09       LIKE rtj_file.rtj09,
       rtj10       LIKE rtj_file.rtj10,
       rtj11       LIKE rtj_file.rtj11,
       rtj12       LIKE rtj_file.rtj12,
       rtj13       LIKE rtj_file.rtj13,
       rtj14       LIKE rtj_file.rtj14,
       rtj15       LIKE rtj_file.rtj15,
       rtj16       LIKE rtj_file.rtj16,
       rtj17       LIKE rtj_file.rtj17,
       rtj18       LIKE rtj_file.rtj18,
       rtj25       LIKE rtj_file.rtj25,        #FUN-C50036 add
       rtj19       LIKE rtj_file.rtj19,
       rtj23       LIKE rtj_file.rtj23,
       rtj20       LIKE rtj_file.rtj20
                   END RECORD

   #從策略變更單單身檔中抓取價格策略變更資料
   LET l_sql = "SELECT rtj24,rtj03,rtj04,rtj09,rtj10,rtj11,rtj12,rtj13,rtj14, ",
               #"       rtj15,rtj16,rtj17,rtj18,rtj19,rtj23,rtj20 ",           #FUN-C50036 mark
               "       rtj15,rtj16,rtj17,rtj18,rtj25,rtj19,rtj23,rtj20 ",      #FUN-C50036 add
               "  FROM ",cl_get_target_table(p_org,'rtj_file'),
               " WHERE rtj01 = '",p_no,"' ",
               "   AND rtj02 = '2' ",
               " ORDER BY rtj24,rtj04 "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
   PREPARE sel_rtj_pre2 FROM l_sql
   DECLARE sel_rtj_cs2 CURSOR FOR sel_rtj_pre2
   FOREACH sel_rtj_cs2 INTO l_rtj.*
      IF STATUS THEN
         CALL s_errmsg('','','foreach:',STATUS,1)
         LET g_success = 'N'
         RETURN 
      END IF 

      #備註：1.價格策略維護作業若不存在當前策略則新增該價格策略
      #      2.若存在，則判斷價格策略+產品編號是否存在，若存在則更新反之則新增
      LET l_n = 0
      LET l_sql = "SELECT COUNT(*) ",
                  "  FROM ",cl_get_target_table(p_org,'rtf_file'),
                  " WHERE rtf01 = '",l_rtj.rtj24,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
      PREPARE sel_rtf_pre FROM l_sql
      EXECUTE sel_rtf_pre INTO l_n

      #存在價格策略
      IF l_n > 0 THEN
         LET l_n = 0
         LET l_sql = "SELECT COUNT(*) ",
                     "  FROM ",cl_get_target_table(p_org,'rtg_file'),
                     " WHERE rtg01 = '",l_rtj.rtj24,"' AND rtg03 = '",l_rtj.rtj04,"' ",
                     "   AND rtg04 = '",l_rtj.rtj09,"'"  #TQC-C30322 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
         PREPARE sel_rtg_pre1 FROM l_sql
         EXECUTE sel_rtg_pre1 INTO l_n
         IF l_n > 0 THEN
            LET l_sql = "SELECT rtg02,rtg08,rtgpos ",
                        "  FROM ",cl_get_target_table(p_org,'rtg_file'),
                        " WHERE rtg01 = '",l_rtj.rtj24,"' ",
                        "   AND rtg03 = '",l_rtj.rtj04,"' AND rtg04 = '",l_rtj.rtj09,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
            PREPARE sel_rtg_pre2 FROM l_sql
            EXECUTE sel_rtg_pre2 INTO l_rtg02,l_rtg08,l_rtgpos
            IF l_rtgpos <> '1' THEN
               LET l_rtgpos = '2'
            ELSE
               LET l_rtgpos = '1'
            END IF 
            IF l_rtg08 IS NULL THEN LET l_rtg08 = 'N' END IF
            #FUN-C80076 add sta
            IF cl_null(l_rtj.rtj25) THEN
               LET l_rtj.rtj25 = 0 
            END IF
            #FUN-C80076 add end 
            LET l_sql = "UPDATE ",cl_get_target_table(p_org,'rtg_file'),
                        "   SET rtg04  = '",l_rtj.rtj09,"', ",
                        "       rtg05  = '",l_rtj.rtj16,"', ",
                        "       rtg06  = '",l_rtj.rtj17,"', ",
                        "       rtg07  = '",l_rtj.rtj18,"', ",
                        "       rtg08  = '",l_rtj.rtj19,"', ",
                        "       rtg09  = '",l_rtj.rtj20,"', ",
                        "       rtg10  = '",l_rtj.rtj23,"', ",
                        "       rtg12  = '",g_today,"', ",             #FUN-C50036 add
                        "       rtg11  = '",l_rtj.rtj25,"', ",         #FUN-C50036 add
                        "       rtgpos = '",l_rtgpos,"' ",
                        " WHERE rtg01  = '",l_rtj.rtj24,"' ",
                        "   AND rtg02  = '",l_rtg02,"' AND rtg04 = '",l_rtj.rtj09,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
            PREPARE upd_rtg_pre1 FROM l_sql
            EXECUTE upd_rtg_pre1 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('rtg01',l_rtj.rtj24,'upd rtg_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN 
            END IF 

            #備註：當價格策略中商品由允許自定價變更為不允許自定價時，則需在變更價格策略的同時，
            #      將使用此價格策略的各營運中心自定價表中此商品記錄刪除
            IF l_rtg08 = 'Y' AND l_rtj.rtj19 = 'N' THEN
               LET l_sql = "SELECT DISTINCT rtz01 FROM rtz_file ",
                           " WHERE rtz05 = '",l_rtj.rtj24,"'"
               PREPARE sel_rtz_pre FROM l_sql
               DECLARE sel_rtz_cs CURSOR FOR sel_rtz_pre
               FOREACH sel_rtz_cs INTO l_rtz01
                  LET l_sql = "SELECT COUNT(*) ",
                              "  FROM ",cl_get_target_table(l_rtz01,'rth_file'),
                              " WHERE rth01 = '",l_rtj.rtj04,"' ",
                              "   AND rth02 = '",l_rtj.rtj09,"' ",
                              "   AND rthplant = '",l_rtz01,"' "
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql,l_rtz01) RETURNING l_sql
                  PREPARE pre_sel_rth FROM l_sql
                  EXECUTE pre_sel_rth INTO l_n
                  IF l_n IS NULL THEN LET l_n = 0 END IF
                  IF l_n != 0 THEN
                     LET l_sql = "DELETE FROM ",cl_get_target_table(l_rtz01,'rth_file'),
                                 " WHERE rth01 = '",l_rtj.rtj04,"' ",
                                 "   AND rth02 = '",l_rtj.rtj09,"' ",
                                 "   AND rthplant = '",l_rtz01,"' "
                     CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                     CALL cl_parse_qry_sql(l_sql,l_rtz01) RETURNING l_sql
                     PREPARE pre_del_rth FROM l_sql
                     EXECUTE pre_del_rth
                     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                        CALL s_errmsg('rth01',l_rtj.rtj04,'del rth_file',SQLCA.sqlcode,1)
                        LET g_success='N'
                        RETURN
                     END IF
                  END IF
               END FOREACH
            END IF 
         ELSE
            INITIALIZE l_rtg02 TO NULL 
            LET l_sql = "SELECT MAX(rtg02)+1 ",
                        "  FROM ",cl_get_target_table(p_org,'rtg_file'),
                        " WHERE rtg01 = '",l_rtj.rtj24,"' "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
            PREPARE sel_rtg_pre3 FROM l_sql
            EXECUTE sel_rtg_pre3 INTO l_rtg02
            IF cl_null(l_rtg02) THEN LET l_rtg02 = 1 END IF 
            #在價格策略單身中增加商品
            LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rtg_file'),
                        "              (rtg01,rtg02,rtg03,rtg04,rtg05,rtg06, ",
                        #"               rtg07,rtg08,rtg09,rtg10,rtgpos) ",                                    #FUN-C50036 mark
                        "               rtg07,rtg08,rtg09,rtg10,rtg11,rtg12,rtgpos) ",                         #FUN-C50036 add   
                        #"VALUES(?,?,?,?,?,?,?,?,?,?,?) "                                                      #FUN-C50036 mark
                        "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                   #FUN-C50036 add
            PREPARE ins_rtg_pre1 FROM l_sql
            EXECUTE ins_rtg_pre1 USING l_rtj.rtj24,l_rtg02,l_rtj.rtj04,l_rtj.rtj09,l_rtj.rtj16,l_rtj.rtj17,
                                      #l_rtj.rtj18,l_rtj.rtj19,l_rtj.rtj20,l_rtj.rtj23,'1'                      #FUN-C50036 mark
                                       l_rtj.rtj18,l_rtj.rtj19,l_rtj.rtj20,l_rtj.rtj23,l_rtj.rtj25,g_today,'1'  #FUN-C50036 add
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('rtg01',l_rtj.rtj24,'ins rtg_file',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN 
            END IF 
         END IF 
         LET l_sql = "UPDATE ",cl_get_target_table(p_org,'rtf_file'),
                     "   SET rtf04 = rtf04 + 1 ",
                     " WHERE rtf01 = '",l_rtj.rtj24,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
         PREPARE upd_rtg_pre2 FROM l_sql
         EXECUTE upd_rtg_pre2 
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rtf01',l_rtj.rtj24,'upd rtf_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN 
         END IF 
      #不存在價格策略
      ELSE
         #新增價格策略單頭資料
         LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rtf_file'),
                     "              (rtf01,rtf02,rtf03,rtf04,rtf05,rtfacti,rtfcond,rtfconf,rtfconu, ",
                     "               rtfcrat,rtfdate,rtfgrup,rtfmodu,rtforig,rtforiu,rtfuser) ",
                     "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
         PREPARE ins_rtf_pre FROM l_sql
         EXECUTE ins_rtf_pre USING l_rtj.rtj24,'',g_plant,'0','','Y',g_today,'Y',g_user,
                                   g_today,'',g_grup,'',g_grup,g_user,g_user
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rtf01',l_rtj.rtj24,'ins rtf_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN 
         END IF 

         INITIALIZE l_rtg02 TO NULL
         LET l_sql = "SELECT MAX(rtg02)+1 ",
                     "  FROM ",cl_get_target_table(p_org,'rtg_file'),
                     " WHERE rtg01 = '",l_rtj.rtj24,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
         PREPARE sel_rtg_pre4 FROM l_sql
         EXECUTE sel_rtg_pre4 INTO l_rtg02
         IF cl_null(l_rtg02) THEN LET l_rtg02 = 1 END IF 

         #在價格策略單身中增加商品資料
         LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rtg_file'),
                     "              (rtg01,rtg02,rtg03,rtg04,rtg05,rtg06, ",
                     #"               rtg07,rtg08,rtg09,rtg10,rtgpos) ",                                     #FUN-C50036 mark
                     "               rtg07,rtg08,rtg09,rtg10,rtg11,rtg12,rtgpos) ",                          #FUN-C50036 add
                     #"VALUES(?,?,?,?,?,?,?,?,?,?,?) "                                                       #FUN-C50036 mark
                     "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?) "                                                    #FUN-C50036 add
         PREPARE ins_rtg_pre2 FROM l_sql
         EXECUTE ins_rtg_pre2 USING l_rtj.rtj24,l_rtg02,l_rtj.rtj04,l_rtj.rtj09,l_rtj.rtj16,l_rtj.rtj17,
                                    #l_rtj.rtj18,l_rtj.rtj19,l_rtj.rtj20,l_rtj.rtj23,'1'                     #FUN-C50036 mark
                                    l_rtj.rtj18,l_rtj.rtj19,l_rtj.rtj20,l_rtj.rtj23,l_rtj.rtj25,g_today,'1'  #FUN-C50036 add
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL s_errmsg('rtg01',l_rtj.rtj24,'ins rtg_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN 
         END IF 
      END IF 
      
   END FOREACH 
END FUNCTION 

#採購策略
FUNCTION t100_sub_rty(p_no,p_org)
DEFINE p_no   LIKE rti_file.rti01
DEFINE p_org  LIKE azp_file.azp01
DEFINE l_n    LIKE type_file.num5
DEFINE l_sql  STRING
DEFINE l_ryn  RECORD 
       ryn03  LIKE ryn_file.ryn03,
       ryn04  LIKE ryn_file.ryn04,
       ryn05  LIKE ryn_file.ryn05,
       ryn06  LIKE ryn_file.ryn06,
       ryn07  LIKE ryn_file.ryn07,
       ryn08  LIKE ryn_file.ryn08,
       ryn09  LIKE ryn_file.ryn09,
       ryn10  LIKE ryn_file.ryn10,
       ryn11  LIKE ryn_file.ryn11,
       ryn12  LIKE ryn_file.ryn12,
       ryn13  LIKE ryn_file.ryn13,
       ryn14  LIKE ryn_file.ryn14,
       ryn15  LIKE ryn_file.ryn15
              END RECORD 

   LET l_sql = "SELECT ryn03,ryn04,ryn05,ryn06,ryn07,ryn08,ryn09,ryn10, ",
               "       ryn11,ryn12,ryn13,ryn14,ryn15 ",
               "  FROM ",cl_get_target_table(p_org,'ryn_file'),
               " WHERE ryn01 = '",p_no,"' ",
               " ORDER BY ryn03,ryn04 "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
   PREPARE sel_ryn_pre FROM l_sql
   DECLARE sel_ryn_cs CURSOR FOR sel_ryn_pre
   FOREACH sel_ryn_cs INTO l_ryn.*
      IF STATUS THEN
         CALL s_errmsg('','','foreach:',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH 
      END IF 
      IF cl_null(l_ryn.ryn09) THEN LET l_ryn.ryn09 = 0 END IF
      IF cl_null(l_ryn.ryn10) THEN LET l_ryn.ryn10 = 0 END IF
      IF cl_null(l_ryn.ryn11) THEN LET l_ryn.ryn11 = 0 END IF

      #備註：查詢當前營運中心+產品編號是否存在，存在更新反之新增
      LET l_n = 0
      LET l_sql = "SELECT COUNT(*) ",
                  "  FROM ",cl_get_target_table(p_org,'rty_file'),
                  "  WHERE rty01 = '",l_ryn.ryn03,"' AND rty02 = '",l_ryn.ryn04,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
      PREPARE sel_rty_pre FROM l_sql
      EXECUTE sel_rty_pre INTO l_n
      IF l_n > 0 THEN 
         #更新採購策略單身
         LET l_sql = "UPDATE ",cl_get_target_table(p_org,'rty_file'),
                     "   SET rty03   = '",l_ryn.ryn05,"', ",
                     "       rty05   = '",l_ryn.ryn07,"', ",
                     "       rty06   = '",l_ryn.ryn08,"', ",
                     "       rty08   =  ",l_ryn.ryn10," , ",
                     "       rty09   =  ",l_ryn.ryn11," , ",
                     "       rty12   = '",l_ryn.ryn15,"', ",
                     "       rtyacti = '",l_ryn.ryn14,"' "
         IF NOT cl_null(l_ryn.ryn06) THEN
            LET l_sql = l_sql CLIPPED,",rty04 = '",l_ryn.ryn06,"' "
         END IF 
         IF NOT cl_null(l_ryn.ryn09) THEN
            LET l_sql = l_sql CLIPPED,",rty07 =  ",l_ryn.ryn09,"  "
         END IF 
         IF NOT cl_null(l_ryn.ryn12) THEN
            LET l_sql = l_sql CLIPPED,",rty10 = '",l_ryn.ryn12,"' "
         END IF 
         IF NOT cl_null(l_ryn.ryn13) THEN
            LET l_sql = l_sql CLIPPED,",rty11 = '",l_ryn.ryn13,"' "
         END IF 
         LET l_sql = l_sql CLIPPED," WHERE rty01 = '",l_ryn.ryn03,"' ",
                                   "   AND rty02 = '",l_ryn.ryn04,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql,p_org) RETURNING l_sql
         PREPARE upd_rty_pre FROM l_sql
         EXECUTE upd_rty_pre
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
            CALL s_errmsg('rty01',l_ryn.ryn03,'upd rty_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN 
         END IF 
      ELSE 
         #新增採購策略單身
         LET l_sql = "INSERT INTO ",cl_get_target_table(p_org,'rty_file'),
                     "              (rty01,rty02,rty03,rty04,rty05,rty06, ",
                     "               rty07,rty08,rty09,rty10,rty11,rty12,rty13,rtyacti) ",
                     "VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
         PREPARE ins_rty_pre FROM l_sql
         EXECUTE ins_rty_pre USING l_ryn.ryn03,l_ryn.ryn04,l_ryn.ryn05,l_ryn.ryn06,l_ryn.ryn07,
                                   l_ryn.ryn08,l_ryn.ryn09,l_ryn.ryn10,l_ryn.ryn11,l_ryn.ryn12,
                                   l_ryn.ryn13,l_ryn.ryn15,'',l_ryn.ryn14
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
            CALL s_errmsg('rty01',l_ryn.ryn03,'ins ryn_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN          
         END IF 
      END IF 
   END FOREACH 
END FUNCTION 

#FUN-BC0076

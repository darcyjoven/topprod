# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: artt402_sub.4gl
# Descriptions...: 一般促銷變更審核檢驗
# Date & Author..: NO.FUN-A70048 10/07/29 By Cockroach
# Modify.........: No.MOD-AC0176 10/12/18 By shenyang 修改5.25CT1 bug
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No:FUN-B70075 11/10/31 By baogc 已傳POS否部份邏輯調整
# Modify.........: No.FUN-BC0072 11/12/20 By pauline GP5.3 artt402 一般促銷變更單促銷功能優化
# Modify.........: No.FUN-BC0126 12/01/11 By pauline GP5.3 artt402 一般促銷變更單促銷功能優化修改
# Modify.........: No.TQC-C20378 12/02/22 By pauline 更新rap時將會員促銷方式當為key值
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE l_rbb01     LIKE rbb_file.rbb01
DEFINE l_rbb02     LIKE rbb_file.rbb02
DEFINE l_rbb03     LIKE rbb_file.rbb03
DEFINE l_plant     LIKE azw_file.azw01
DEFINE l_n         LIKE type_file.num5
DEFINE l_rbb       RECORD LIKE rbb_file.*
DEFINE l_sql       STRING


FUNCTION t402sub_y_upd(p_rbb01,p_rbb02,p_rbb03,p_rbbplant)
DEFINE p_rbb01     LIKE rbb_file.rbb01
DEFINE p_rbb02     LIKE rbb_file.rbb02
DEFINE p_rbb03     LIKE rbb_file.rbb03
DEFINE p_rbbplant  LIKE rbb_file.rbbplant

   LET l_rbb01=p_rbb01
   LET l_rbb02=p_rbb02
   LET l_rbb03=p_rbb03
   LET l_plant=p_rbbplant
 
   LET l_sql="SELECT * FROM ",cl_get_target_table(l_plant,'rbb_file'),
             " WHERE rbb01='",l_rbb01,"'",
             "   AND rbb02='",l_rbb02,"'",
             "   AND rbb03='",l_rbb03,"'",
             "   AND rbbplant='",l_plant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t402sub_sel_rbb FROM l_sql
      EXECUTE t402sub_sel_rbb INTO l_rbb.*
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         RETURN
      END IF

      LET g_success = 'Y'
  
      IF g_success='Y' THEN 
         CALL t402sub_rab_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t402sub_rac_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t402sub_rad_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t402sub_raq_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t402sub_rap_upd()
      END IF

    #FUN-BC0072 add START
      IF g_success='Y' THEN
         CALL t402sub_rak_upd()
      END IF
    #FUN-BC0072 add END

      IF g_success='Y' THEN 
         CALL t402sub_repeat()
      END IF

      IF g_success = 'N' THEN
         RETURN
      END IF
   
END FUNCTION

FUNCTION t402sub_rab_upd()

      LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rab_file'),
                "   SET rab04='",l_rbb.rbb04t,"',",
                "       rab05='",l_rbb.rbb05t,"',",
                "       rab06='",l_rbb.rbb06t,"',",
                "       rab07='",l_rbb.rbb07t,"',",
                "       rab08='",l_rbb.rbb08t,"',",
                "       rab09='",l_rbb.rbb09t,"',",
                "       rab10='",l_rbb.rbb10t,"'",
                " WHERE rab01='",l_rbb.rbb01,"'",
                "   AND rab02='",l_rbb.rbb02,"'",
                "   AND rabplant='",l_rbb.rbbplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t402sub_upd_rab FROM l_sql
      EXECUTE t402sub_upd_rab
      IF SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
         RETURN
      END IF
      #FUN-B70075 Add Begin---
      LET l_sql = "UPDATE ",cl_get_target_table(l_plant,'rac_file'),
                  "   SET racpos = (CASE racpos WHEN '1' THEN '1' ELSE '2' END) ",
                  " WHERE rac01 = '",l_rbb.rbb01,"' ",
                  "   AND rac02 = '",l_rbb.rbb02,"' ",
                  "   AND racplant = '",l_rbb.rbbplant,"' "
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t402sub_upd_racpos1 FROM l_sql
      EXECUTE t402sub_upd_racpos1
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL s_errmsg('upd','','UPDATE rac_file:',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF
      #FUN-B70075 Add End-----
END FUNCTION


FUNCTION t402sub_rac_upd()
DEFINE l_rbc   RECORD LIKE rbc_file.*
DEFINE l_racpos LIKE rac_file.racpos #FUN-B40071

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbc_file'),
             "  WHERE rbc01='",l_rbb.rbb01,"'",
             "    AND rbc02='",l_rbb.rbb02,"'",
             "    AND rbc03='",l_rbb.rbb03,"'",
             "    AND rbc05='1' ",
             "    AND rbcplant='",l_rbb.rbbplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t402sub_sel_rbc FROM l_sql
      DECLARE t402sub_sel_rbc_cs CURSOR FOR t402sub_sel_rbc
      FOREACH t402sub_sel_rbc_cs INTO l_rbc.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rac_file'),
                   " WHERE rac01='",l_rbc.rbc01,"'",
                   "   AND rac02='",l_rbc.rbc02,"'",
                   "   AND rac03='",l_rbc.rbc06,"'",
                   "   AND racplant='",l_rbc.rbcplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t402sub_sel_rac FROM l_sql
         EXECUTE t402sub_sel_rac INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF

         IF cl_null(l_rbc.rbc09) THEN
            LET l_rbc.rbc09 = 0
         END IF
         IF cl_null(l_rbc.rbc13) THEN
            LET l_rbc.rbc13 = 0
         END IF 
         
         IF l_n>0 THEN         
            #FUN-B40071 --START--
            SELECT racpos INTO l_racpos FROM rac_file
             WHERE rac01=l_rbc.rbc01 AND rac02=l_rbc.rbc02 
             AND rac03=l_rbc.rbc06 AND racplant=l_rbc.rbcplant
            IF l_racpos <> '1' THEN
               LET l_racpos = '2'
            ELSE
               LET l_racpos = '1'
            END if
            #FUN-B40071 --END--    
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rac_file'),
                      "   SET rac04='",l_rbc.rbc07,"',",
                      "       rac05='",l_rbc.rbc08,"',",
                      "       rac06='",l_rbc.rbc09,"',",
                      "       rac07='",l_rbc.rbc10,"',",
                      "       rac08='",l_rbc.rbc11,"',",
                      "       rac09='",l_rbc.rbc12,"',",
                      "       rac10='",l_rbc.rbc13,"',",
                      "       rac11='",l_rbc.rbc14,"',",
                     #"       rac12='",l_rbc.rbc15,"',",  #mark
                     #"       rac13='",l_rbc.rbc16,"',",  #mark
                     #"       rac14='",l_rbc.rbc17,"',",  #mark
                     #"       rac15='",l_rbc.rbc18,"',",  #mark
                      "       racacti='",l_rbc.rbcacti,"',",
                      "       racpos='", l_racpos, "' ", #NO.FUN-B40071
                      " WHERE rac01='",l_rbc.rbc01,"'",
                      "   AND rac02='",l_rbc.rbc02,"'",
                      "   AND rac03='",l_rbc.rbc06,"'",
                      "   AND racplant='",l_rbc.rbcplant,"'"
            TRY                 #NO.MOD-AC0176
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_upd_rac FROM l_sql
            EXECUTE t402sub_upd_rac
            CATCH               #NO.MOD-AC0176 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE rac_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
            END TRY             #NO.MOD-AC0176
            
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rac_file'),
                        "(rac01,rac02,rac03,rac04,rac05,rac06,rac07,rac08,rac09,",
                       #" rac10,rac11,rac12,rac13,rac14,rac15,rac16,rac17,racacti,",  #FUN-BC0072 mark
                        " rac10,rac11,rac16,rac17,racacti,",  #FUN-BC0072 add
                        " racpos,raclegal,racplant) ", 
                        "VALUES('",l_rbc.rbc01,"','",l_rbc.rbc02,"','",l_rbc.rbc06,"',",
                        "       '",l_rbc.rbc07,"','",l_rbc.rbc08,"','",l_rbc.rbc09,"',",
                        "       '",l_rbc.rbc10,"','",l_rbc.rbc11,"','",l_rbc.rbc12,"',",
                       #"       '",l_rbc.rbc13,"','",l_rbc.rbc14,"','",l_rbc.rbc15,"',",  #FUN-BC0072 mark
                       #"       '",l_rbc.rbc16,"','",l_rbc.rbc17,"','",l_rbc.rbc18,"',",  #FUN-BC0072 mark
                        "       '",l_rbc.rbc13,"','",l_rbc.rbc14,"',",  #FUN-BC0072 add 
                        "       ' ',' ','",l_rbc.rbcacti,"','1','",l_rbc.rbclegal,"','",l_rbc.rbcplant,"')" #NO.FUN-B40071
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_ins_rac FROM l_sql
            EXECUTE t402sub_ins_rac
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rac_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

      END FOREACH
END FUNCTION

FUNCTION t402sub_rad_upd()
DEFINE l_rbd   RECORD LIKE rbd_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbd_file'),
             "  WHERE rbd01='",l_rbb.rbb01,"'",
             "    AND rbd02='",l_rbb.rbb02,"'",
             "    AND rbd03='",l_rbb.rbb03,"'",
             "    AND rbd05='1' ",
             "    AND rbdplant='",l_rbb.rbbplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t402sub_sel_rbd FROM l_sql
      DECLARE t402sub_sel_rbd_cs CURSOR FOR t402sub_sel_rbd
      FOREACH t402sub_sel_rbd_cs INTO l_rbd.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rad_file'),
                   " WHERE rad01='",l_rbd.rbd01,"'",
                   "   AND rad02='",l_rbd.rbd02,"'",
                   "   AND rad03='",l_rbd.rbd06,"'",
                   "   AND rad04='",l_rbd.rbd07,"'",
                   "   AND rad05='",l_rbd.rbd08,"'",  #FUN-BC0072 add
                   "   AND radplant='",l_rbd.rbdplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t402sub_sel_rad FROM l_sql
         EXECUTE t402sub_sel_rad INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rad_file'),
                      "   SET rad05='",l_rbd.rbd08,"',",
                      "       rad06='",l_rbd.rbd09,"',",
                      "       radacti='",l_rbd.rbdacti,"'",
                      " WHERE rad01='",l_rbd.rbd01,"'",
                      "   AND rad02='",l_rbd.rbd02,"'",
                      "   AND rad03='",l_rbd.rbd06,"'",
                      "   AND rad04='",l_rbd.rbd07,"'",
                      "   AND rad05='",l_rbd.rbd08,"'",  #FUN-BC0072 add
                      "   AND radplant='",l_rbd.rbdplant,"'"
            TRY                 #NO.MOD-AC0176
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_upd_rad FROM l_sql
            EXECUTE t402sub_upd_rad
            CATCH               #NO.MOD-AC0176 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE rad_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
            END TRY             #NO.MOD-AC0176
            #FUN-B70075 Add Begin---
            LET l_sql = "UPDATE ",cl_get_target_table(l_plant,'rac_file'),
                        "   SET racpos = (CASE racpos WHEN '1' THEN '1' ELSE '2' END) ",
                        " WHERE rac01 = '",l_rbb.rbb01,"' ",
                        "   AND rac02 = '",l_rbb.rbb02,"' ",
                        "   AND rac03 = '",l_rbd.rbd06,"' ",
                        "   AND racplant = '",l_rbb.rbbplant,"' "
            TRY
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_upd_racpos2 FROM l_sql
            EXECUTE t402sub_upd_racpos2
            CATCH
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('upd','','UPDATE rac_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
            END TRY
            #FUN-B70075 Add End-----            
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rad_file'),
                        "(rad01,rad02,rad03,rad04,rad05,rad06,radacti,radlegal,radplant)", 
                        "VALUES('",l_rbd.rbd01,"','",l_rbd.rbd02,"','",l_rbd.rbd06,"',",
                        "       '",l_rbd.rbd07,"','",l_rbd.rbd08,"','",l_rbd.rbd09,"',",
                        "       '",l_rbd.rbdacti,"','",l_rbd.rbdlegal,"','",l_rbd.rbdplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_ins_rad FROM l_sql
            EXECUTE t402sub_ins_rad
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rad_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

      END FOREACH
END FUNCTION


FUNCTION t402sub_raq_upd()
DEFINE l_rbq   RECORD LIKE rbq_file.*
DEFINE l_raq06        LIKE raq_file.raq06  #FUN-BC0072 add
DEFINE l_raq07        LIKE raq_file.raq07  #FUN-BC0072 add


   LET l_raq06 = g_today   #FUN-BC0072 add
   LET l_raq07 = TIME      #FUN-BC0072 add
   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbq_file'),
             "  WHERE rbq01='",l_rbb.rbb01,"'",
             "    AND rbq02='",l_rbb.rbb02,"'",
             "    AND rbq03='",l_rbb.rbb03,"'",
             "    AND rbq04='1' ",
             "    AND rbq06='1' ",
             "    AND rbqplant='",l_rbb.rbbplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t402sub_sel_rbq FROM l_sql
      DECLARE t402sub_sel_rbq_cs CURSOR FOR t402sub_sel_rbq
      FOREACH t402sub_sel_rbq_cs INTO l_rbq.*
         IF NOT cl_null(l_rbq.rbq09) THEN  #FUN-BC0072 add  #有攤位編號 
            LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                      " WHERE raq01='",l_rbq.rbq01,"'",
                      "   AND raq02='",l_rbq.rbq02,"'",
                      "   AND raq03='1'",
                      "   AND raq04='",l_rbq.rbq07,"'",
                      "   AND raqplant='",l_rbq.rbqplant,"'",
                      "   AND raq08 = '",l_rbq.rbq09,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_sel_raq FROM l_sql
            EXECUTE t402sub_sel_raq INTO l_n
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               RETURN
            END IF
            IF l_n>0 THEN   #此攤位編號已存在原促銷單中
               LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                         "   SET raq05='",l_rbq.rbq08,"',",
                         "       raq08='",l_rbq.rbq09,"',",  #FUN-BC0072 add
                         "       raqacti='",l_rbq.rbqacti,"'",
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='1'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raq08='",l_rbq.rbq09,"'",  #FUN-BC0072 add
                         "   AND raqplant='",l_rbq.rbqplant,"'"
               TRY                 #NO.MOD-AC0176
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t402sub_upd_raq FROM l_sql
               EXECUTE t402sub_upd_raq
               CATCH               #NO.MOD-AC0176 
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
               END TRY             #NO.MOD-AC0176
            ELSE  #此攤位編號不存在於原促銷單中
             #FUN-BC0072 add START
               LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='1'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raqplant='",l_rbq.rbqplant,"'",
                         "   AND RTRIM(raq08) IS NULL "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t402sub_sel_raq5 FROM l_sql
               EXECUTE t402sub_sel_raq5 INTO l_n
               IF l_n> 0 THEN
                  LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                            "   SET raq05='",l_rbq.rbq08,"',",
                            "       raq08='",l_rbq.rbq09,"',",  
                            "       raqacti='",l_rbq.rbqacti,"'",
                            " WHERE raq01='",l_rbq.rbq01,"'",
                            "   AND raq02='",l_rbq.rbq02,"'",
                            "   AND raq03='1'",
                            "   AND raq04='",l_rbq.rbq07,"'",
                            "   AND RTRIM(raq08) IS NULL ", 
                            "   AND raqplant='",l_rbq.rbqplant,"'"
                  TRY               
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t402sub_upd_raq5 FROM l_sql
                  EXECUTE t402sub_upd_raq5
                  CATCH               
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
                     LET g_success='N'
                     RETURN
                  END IF
                  END TRY
               ELSE   
               #FUN-BC0072 add END
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'raq_file'),
                              "(raq01,raq02,raq03,raq04,raq05,raq08,raqacti,raqlegal,raqplant,",  #FUN-BC0072 add raq08
                              " raq06, raq07 ) ",   #FUN-BC0072 add 
                              "VALUES('",l_rbq.rbq01,"','",l_rbq.rbq02,"','",l_rbq.rbq04,"',",
                              "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"','",l_rbq.rbq09,"','",l_rbq.rbqacti,"',",  #FUN-BC0072 add rbq09
                              "       '",l_rbq.rbqlegal,"','",l_rbq.rbqplant,"',",
                              "       '",l_raq06,"','",l_raq07,"')"  #FUN-BC0072 add
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t402sub_ins_raq FROM l_sql
                  EXECUTE t402sub_ins_raq
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('ns','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF
            END IF  #FUN-BC0072 add
         #FUN-BC0072 add START
         ELSE  #未有攤位編號 
            LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                      " WHERE raq01='",l_rbq.rbq01,"'",
                      "   AND raq02='",l_rbq.rbq02,"'",
                      "   AND raq03='1'",
                      "   AND raq04='",l_rbq.rbq07,"'",
                      "   AND raqplant='",l_rbq.rbqplant,"'",
                      "   AND raqacti = 'Y'",
                      "   AND RTRIM(raq08) IS NOT NULL "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_sel_raq2 FROM l_sql
            EXECUTE t402sub_sel_raq2 INTO l_n               
            IF l_n > 0 THEN  #若營運中心下有攤位 ,則將攤位全部update 為無效
               LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                         "   SET raq06='",l_raq06,"',",     
                         "       raq07='",l_raq07,"',",    
                         "       raqacti='N' ",
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='1'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raqplant='",l_rbq.rbqplant,"'",
                         "   AND RTRIM(raq08) IS NOT NULL "
               TRY
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t402sub_upd_raq3 FROM l_sql
               EXECUTE t402sub_upd_raq3
               CATCH
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
               END TRY  #新增一筆攤位為空值的營運中心
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'raq_file'),
                           "(raq01,raq02,raq03,raq04,raq05,raq08,raqacti,raqlegal,raqplant, ",
                           " raq06,raq07) ",  #FUN-BC0072 add
                           "VALUES('",l_rbq.rbq01,"','",l_rbq.rbq02,"','",l_rbq.rbq04,"',",
                           "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"','",l_rbq.rbq09,"','",l_rbq.rbqacti,"',",
                           "       '",l_rbq.rbqlegal,"','",l_rbq.rbqplant,"',",
                           "       '",l_raq06,"','",l_raq07,"')"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t402sub_ins_raq4 FROM l_sql
               EXECUTE t402sub_ins_raq4
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('ns','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
            ELSE   
               LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='1'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raqplant='",l_rbq.rbqplant,"'",
                         "   AND RTRIM(raq08) IS NULL "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t402sub_sel_raq3 FROM l_sql
               EXECUTE t402sub_sel_raq3 INTO l_n                  
               IF l_n > 0 THEN   #原本有營運中心 但是攤位為空
                  LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                            "   SET raq05='",l_rbq.rbq08,"',",
                            "       raq06='",l_raq06,"',",      
                            "       raq07='",l_raq07,"',",      
                            "       raqacti='",l_rbq.rbqacti,"'",
                            " WHERE raq01='",l_rbq.rbq01,"'",
                            "   AND raq02='",l_rbq.rbq02,"'",
                            "   AND raq03='1'",
                            "   AND raq04='",l_rbq.rbq07,"'",
                            "   AND RTRIM(raq08) IS NULL ",
                            "   AND raqplant='",l_rbq.rbqplant,"'"
                  TRY                
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t402sub_upd_raq2 FROM l_sql
                  EXECUTE t402sub_upd_raq2
                  CATCH          
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
                     LET g_success='N'
                     RETURN
                  END IF
                  END TRY
               ELSE  #沒有此營運中心
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'raq_file'),
                              "(raq01,raq02,raq03,raq04,raq05,raq08,raqacti,raqlegal,raqplant) ",
                              "VALUES('",l_rbq.rbq01,"','",l_rbq.rbq02,"','",l_rbq.rbq04,"',",
                              "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"','",l_rbq.rbq09,"','",l_rbq.rbqacti,"',",
                              "       '",l_rbq.rbqlegal,"','",l_rbq.rbqplant,"')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t402sub_ins_raq5 FROM l_sql
                  EXECUTE t402sub_ins_raq5
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('ns','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF
            END IF
 
         END IF
         LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                   "   SET raq05='Y',",
                   "       raq06='",l_raq06,"',",      
                   "       raq07='",l_raq07,"' ",     
                   " WHERE raq01='",l_rbq.rbq01,"'",
                   "   AND raq02='",l_rbq.rbq02,"'",
                   "   AND raq03='1'",
                   "   AND raqplant='",l_rbq.rbqplant,"'"
         TRY                 #NO.MOD-AC0176
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t402sub_upd_raq4 FROM l_sql
         EXECUTE t402sub_upd_raq4
         CATCH  
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
            LET g_success='N'
            RETURN
         END IF
         END TRY
         #FUN-BC0072 add END
      END FOREACH
END FUNCTION

FUNCTION t402sub_rap_upd()
DEFINE l_rbp   RECORD LIKE rbp_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbp_file'),
             "  WHERE rbp01='",l_rbb.rbb01,"'",
             "    AND rbp02='",l_rbb.rbb02,"'",
             "    AND rbp03='",l_rbb.rbb03,"'",
             "    AND rbp04='1' ",
             "    AND rbp06='1' ",
             "    AND rbpplant='",l_rbb.rbbplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t402sub_sel_rbp FROM l_sql
      DECLARE t402sub_sel_rbp_cs CURSOR FOR t402sub_sel_rbp
      FOREACH t402sub_sel_rbp_cs INTO l_rbp.*
#MOD-AC0176--ADD--begin
      IF cl_null(l_rbp.rbp10) THEN
         LET l_rbp.rbp10 = 100
      END IF
#MOD-AC0176--ADD--end
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rap_file'),
                   " WHERE rap01='",l_rbp.rbp01,"'",
                   "   AND rap02='",l_rbp.rbp02,"'",
                   "   AND rap03='1' ",
                   "   AND rap04='",l_rbp.rbp07,"'",
                   "   AND rap05='",l_rbp.rbp08,"'",
                   "   AND rapplant='",l_rbp.rbpplant,"'",
                   "   AND rap09 = '",l_rbp.rbp12,"'"  #TQC-C20378 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t402sub_sel_rap FROM l_sql
         EXECUTE t402sub_sel_rap INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rap_file'),
                      "   SET rap06='",l_rbp.rbp09,"',",
                      "       rap07='",l_rbp.rbp10,"',",
                      "       rap08='",l_rbp.rbp11,"',",
                      "       rapacti='",l_rbp.rbpacti,"'",
                      " WHERE rap01='",l_rbp.rbp01,"'",
                      "   AND rap02='",l_rbp.rbp02,"'",
                      "   AND rap03='1'",
                      "   AND rap04='",l_rbp.rbp07,"'",
                      "   AND rap05='",l_rbp.rbp08,"'",
                      "   AND rapplant='",l_rbp.rbpplant,"'",
                      "   AND rap09 = '",l_rbp.rbp12,"'"  #TQC-C20378 add
            TRY                 #NO.MOD-AC0176
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_upd_rap FROM l_sql
            EXECUTE t402sub_upd_rap
            CATCH               #NO.MOD-AC0176 
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE rap_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
            END TRY             #NO.MOD-AC0176
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rap_file'),
                        "(rap01,rap02,rap03,rap04,rap05,rap06,rap07,rap08,rap09,rapacti,",  #FUN-BC0072 add rap09
                        " raplegal,rapplant) ", 
                        "VALUES('",l_rbp.rbp01,"','",l_rbp.rbp02,"','",l_rbp.rbp04,"',",
                        "       '",l_rbp.rbp07,"','",l_rbp.rbp08,"','",l_rbp.rbp09,"',",
                        "       '",l_rbp.rbp10,"','",l_rbp.rbp11,"','",l_rbp.rbp12,"','",l_rbp.rbpacti,"',",  #FUN-BC0072 add rbp12
                        "       '",l_rbp.rbplegal,"','",l_rbp.rbpplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_ins_rap FROM l_sql
            EXECUTE t402sub_ins_rap
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rap_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

      END FOREACH
END FUNCTION


FUNCTION  t402sub_repeat()
 DEFINE l_rac  RECORD LIKE rac_file.*
  
   LET l_sql="SELECT * FROM ",cl_get_target_table(l_plant,'rac_file'),
             " WHERE rac01='",l_rbb.rbb01,"'",
             "   AND rac02='",l_rbb.rbb02,"'",
             "   AND racplant='",l_rbb.rbbplant,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
   PREPARE t402sub_chk_rac FROM l_sql
   DECLARE t402sub_chk_rac_cs CURSOR FOR t402sub_chk_rac
   FOREACH t402sub_chk_rac_cs INTO l_rac.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('sel','','CHECK rac_file:',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF

    # CALL t302sub_chk('1',l_plant,l_rac.rac01,l_rac.rac02,l_rac.rac03,l_rac.rac12,l_rac.rac13,l_rac.rac14,l_rac.rac15) #MOD-AC0176 
   END FOREACH

END FUNCTION





  #BEGIN WORK
  #   LET g_success = 'Y'
      
  #   CALL t402sub_lock_cl()

  #   OPEN t402sub_cl USING l_rbb01,l_rbb02,l_rbb03,l_rbbplant

  #   IF STATUS THEN
  #      CALL cl_err("OPEN t402_cl:", STATUS, 1)
  #      CLOSE t402_cl
  #      ROLLBACK WORK
  #      RETURN
  #   END IF

  #   FETCH t402sub_cl INTO l_rbb.*
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err(g_rbb.rbb02,SQLCA.sqlcode,0)
  #      CLOSE t402sub_cl
  #      ROLLBACK WORK
  #      RETURN
  #   END IF
  #   LET g_success = 'Y'
  #   LET g_time =TIME
  #
  #   LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rbb_file'),
  #             "   SET rbbconf='Y',",
  #             "       rbbcond='",g_today,"',",
  #             "       rbbcont='",g_time ,"',",
  #             "       rbbconu='",g_user ,"'",
  #             " WHERE rbb01='",l_rbb01,"'", 
  #             "   AND rbb02='",l_rbb02,"'",
  #             "   AND rbb03='",l_rbb03,"'", 
  #             "   AND rbbplant='",l_rbbplant,"'"
  #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  #   CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
  #   PREPARE t402sub_upd_rbb FROM l_sql
  #   EXECUTE t402sub_upd_rbb
  #   IF SQLCA.sqlerrd[3]=0 THEN
  #      LET g_success='N'
  #   END IF


#FUNCTION t402sub_lock_cl()
# DEFINE l_forupd_sql STRING                                                   
#
#   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'rbb_file'),
#                      " WHERE rbb01 = ? AND rbb02 = ? AND rbb03 =? AND rbbplant = ?  ",
#                      " FOR UPDATE "       
#   CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql      
#   CALL cl_parse_qry_sql(l_forupd_sql,l_plant) RETURNING l_forupd_sql 
#   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
#   DECLARE t402sub_cl CURSOR FROM l_forupd_sql 
#
#END FUNCTION
#FUN-A70048
#FUN-BC0072 add START
FUNCTION  t402sub_rak_upd()
DEFINE l_rbk   RECORD LIKE rbk_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbk_file'),
             "  WHERE rbk01='",l_rbb.rbb01,"'",
             "    AND rbk02='",l_rbb.rbb02,"'",
             "    AND rbk03='",l_rbb.rbb03,"'",
             "    AND rbk05='1' ",
             "    AND rbkplant='",l_rbb.rbbplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t402sub_sel_rbk FROM l_sql
      DECLARE t402sub_sel_rbk_cs CURSOR FOR t402sub_sel_rbk
      FOREACH t402sub_sel_rbk_cs INTO l_rbk.*
         IF cl_null(l_rbk.rbk14) THEN LET l_rbk.rbk14 = ' ' END IF
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rak_file'),
                   " WHERE rak01='",l_rbk.rbk01,"'",
                   "   AND rak02='",l_rbk.rbk02,"'",
                   "   AND rak03='1'",
                   "   AND rak04='",l_rbk.rbk07,"'",
                   "   AND rak05='",l_rbk.rbk08,"'",
                   "   AND rakplant='",l_rbk.rbkplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t402sub_sel_rak FROM l_sql
         EXECUTE t402sub_sel_rak INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rak_file'),
                      "   SET rak06='",l_rbk.rbk09,"',",
                      "       rak07='",l_rbk.rbk10,"',",
                      "       rak08='",l_rbk.rbk11,"',",
                      "       rak09='",l_rbk.rbk12,"',",
                      "       rak10='",l_rbk.rbk13,"',",
                      "       rak11='",l_rbk.rbk14,"',",
                      "       rakacti='",l_rbk.rbkacti,"'",
                      " WHERE rak01='",l_rbk.rbk01,"'",
                      "   AND rak02='",l_rbk.rbk02,"'",
                      "   AND rak03='1' ",
                     #"   AND rak04='",l_rbk.rbk07,"'",
                     #"   AND rak05='",l_rbk.rbk08,"'",
                      "   AND rak04=",l_rbk.rbk07,  #FUN-BC0126 add
                      "   AND rak05=",l_rbk.rbk08,  #FUN-BC0126 add
                      "   AND rakplant='",l_rbk.rbkplant,"'"
            TRY                 #NO.MOD-AC0176
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_upd_rak FROM l_sql
            EXECUTE t402sub_upd_rak
            CATCH              
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE rak_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
            END TRY         

            LET l_sql = "UPDATE ",cl_get_target_table(l_plant,'rac_file'),
                        "   SET racpos = (CASE racpos WHEN '1' THEN '1' ELSE '2' END) ",
                        " WHERE rac01 = '",l_rbk.rbk01,"' ",
                        "   AND rac02 = '",l_rbk.rbk02,"' ",
                        "   AND rac03 = '",l_rbk.rbk07,"' ",
                        "   AND racplant = '",l_rbk.rbkplant,"' "
            TRY
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_upd_racpos4 FROM l_sql
            EXECUTE t402sub_upd_racpos4
            CATCH
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               CALL s_errmsg('upd','','UPDATE rac_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
            END TRY

         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rak_file'),
                        "(rak01,rak02,rak03,rak04,rak05,rak06,",
                        " rak07,rak08,rak09,rak10,rak11,",
                        " rakacti,raklegal,rakplant)",
                        "VALUES('",l_rbk.rbk01,"','",l_rbk.rbk02,"','1',",
                        "       '",l_rbk.rbk07,"','",l_rbk.rbk08,"','",l_rbk.rbk09,"',",
                        "       '",l_rbk.rbk10,"','",l_rbk.rbk11,"','",l_rbk.rbk12,"',",
                        "       '",l_rbk.rbk13,"','",l_rbk.rbk14,"',",
                        "       '",l_rbk.rbkacti,"','",l_rbk.rbklegal,"','",l_rbk.rbkplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t402sub_ins_rak FROM l_sql
            EXECUTE t402sub_ins_rak
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rak_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF

      END FOREACH 
END FUNCTION

#FUN-BC0072 add END

# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: artt404_sub.4gl
# Descriptions...: 滿額促銷變更審核檢驗
# Date & Author..: NO.FUN-A80121  10/09/09 By shenyang
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-BC0126 11/12/30 By pauline GP5.3 artt404 一般促銷變更單促銷功能優化
# Modify.........: No.TQC-C20378 12/02/22 By pauline 更新rap時將會員促銷方式當為key值 
# Modify.........: No.TQC-C30055 12/03/03 By pauline 促銷優化修改
# Modify.........: No.FUN-C30151 12/03/20 By pauline 增加折扣基數
# Modify.........: No:FUN-C60041 12/06/14 By huangtao 調整相應生效門店發佈狀態
# Modify.........: No:MOD-D10080 13/01/15 By Sakura 補上"rbi13"折讓基數欄位回寫

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE l_rbh01     LIKE rbh_file.rbh01
DEFINE l_rbh02     LIKE rbh_file.rbh02
DEFINE l_rbh03     LIKE rbh_file.rbh03
DEFINE l_plant     LIKE azw_file.azw01
DEFINE l_n         LIKE type_file.num5
DEFINE l_rbh       RECORD LIKE rbh_file.*
DEFINE l_sql       STRING


FUNCTION t404sub_y_upd(p_rbh01,p_rbh02,p_rbh03,p_rbhplant)
DEFINE p_rbh01     LIKE rbh_file.rbh01
DEFINE p_rbh02     LIKE rbh_file.rbh02
DEFINE p_rbh03     LIKE rbh_file.rbh03
DEFINE p_rbhplant  LIKE rbh_file.rbhplant
                                                #FUN-A80121 
   LET l_rbh01=p_rbh01
   LET l_rbh02=p_rbh02
   LET l_rbh03=p_rbh03
   LET l_plant=p_rbhplant
 
   LET l_sql="SELECT * FROM ",cl_get_target_table(l_plant,'rbh_file'),
             " WHERE rbh01='",l_rbh01,"'",
             "   AND rbh02='",l_rbh02,"'",
             "   AND rbh03='",l_rbh03,"'",
             "   AND rbhplant='",l_plant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_sel_rbh FROM l_sql
      EXECUTE t404sub_sel_rbh INTO l_rbh.*
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         RETURN
      END IF

      LET g_success = 'Y'
  
      IF g_success='Y' THEN 
         CALL t404sub_rah_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t404sub_rai_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t404sub_raj_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t404sub_raq_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t404sub_rap_upd()
      END IF

      IF g_success='Y' THEN 
         CALL t404sub_rar_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t404sub_ras_upd()
      END IF
      
      IF g_success='Y' THEN 
         CALL t404sub_repeat()
      END IF

    #FUN-BC0126 add START
      IF g_success='Y' THEN
         CALL t404sub_rak_upd()
      END IF
    #FUN-BC0126 add END

      IF g_success = 'N' THEN
         RETURN
      END IF
   
END FUNCTION

FUNCTION t404sub_rah_upd()
DEFINE l_rahpos LIKE rah_file.rahpos #FUN-B40071
    IF  cl_null(l_rbh.rbh23t) THEN
      LET l_rbh.rbh23t = 100
   END IF 
   #FUN-B40071 --START--
   SELECT rahpos INTO l_rahpos FROM rah_file
    WHERE rah01= l_rbh.rbh01 AND rah02= l_rbh.rbh02 
                 AND rahplant= l_rbh.rbhplant
   IF l_rahpos <> '1' THEN
      LET l_rahpos = '2'
   ELSE
      LET l_rahpos = '1'
   END if   
   #FUN-B40071 --END--
         LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rah_file'),
               #"   SET rah04='",l_rbh.rbh04t,"',",  #FUN-BC0126 mark 
               #"       rah05='",l_rbh.rbh05t,"',",  #FUN-BC0126 mark
               #"       rah06='",l_rbh.rbh06t,"',",  #FUN-BC0126 mark
               #"       rah07='",l_rbh.rbh07t,"',",  #FUN-BC0126 mark
                "  SET  rah08='",l_rbh.rbh08t,"',",
                "       rah09='",l_rbh.rbh09t,"',",
                "       rah10='",l_rbh.rbh10t,"',",
                "       rah11='",l_rbh.rbh11t,"',",
                "       rah12='",l_rbh.rbh12t,"',",
                "       rah13='",l_rbh.rbh13t,"',",
                "       rah14='",l_rbh.rbh14t,"',",
                "       rah15='",l_rbh.rbh15t,"',",
                "       rah16='",l_rbh.rbh16t,"',",
                "       rah17='",l_rbh.rbh17t,"',",
                "       rah18='",l_rbh.rbh18t,"',",
                "       rah19='",l_rbh.rbh19t,"',",
                "       rah20='",l_rbh.rbh20t,"',",
                "       rah21='",l_rbh.rbh21t,"',",
                "       rah22='",l_rbh.rbh22t,"',",
                "       rah23='",l_rbh.rbh23t,"',",
                "       rah25='",l_rbh.rbh25t,"',",
                "       rahpos='", l_rahpos, "'", #No:FUN-B40071
                " WHERE rah01='",l_rbh.rbh01,"'",
                "   AND rah02='",l_rbh.rbh02,"'",
                "   AND rahplant='",l_rbh.rbhplant,"'"
      
          
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_upd_rah FROM l_sql
      EXECUTE t404sub_upd_rah
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         LET g_success='N'
         RETURN
      END IF

END FUNCTION


FUNCTION t404sub_rai_upd()
DEFINE l_rbi   RECORD LIKE rbi_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbi_file'),
             "  WHERE rbi01='",l_rbh.rbh01,"'",
             "    AND rbi02='",l_rbh.rbh02,"'",
             "    AND rbi03='",l_rbh.rbh03,"'",
             "    AND rbi05='1' ",
             "    AND rbiplant='",l_rbh.rbhplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_sel_rbi FROM l_sql
      DECLARE t404sub_cs_rbi CURSOR FOR t404sub_sel_rbi
      FOREACH t404sub_cs_rbi INTO l_rbi.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rai_file'),
                   " WHERE rai01='",l_rbi.rbi01,"'",
                   "   AND rai02='",l_rbi.rbi02,"'",
                   "   AND rai03='",l_rbi.rbi06,"'",
                   "   AND raiplant='",l_rbi.rbiplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t404sub_sel_rai FROM l_sql
         EXECUTE t404sub_sel_rai INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
           #IF cl_null(l_rbi.rbi08) THEN LET l_rbi.rbi08 = 1 END IF  #FUN-BC0126 add
           #IF cl_null(l_rbi.rbi11) THEN LET l_rbi.rbi11 = 1 END IF  #FUN-BC0126 add
            IF cl_null(l_rbi.rbi08) THEN LET l_rbi.rbi08 = 0 END IF  #FUN-C30151 add
            IF cl_null(l_rbi.rbi11) THEN LET l_rbi.rbi11 = 0 END IF  #FUN-C30151 add
            IF cl_null(l_rbi.rbi13) THEN LET l_rbi.rbi13 = 0 END IF  #MOD-D10080 add 
            IF cl_null(l_rbi.rbi08) AND cl_null(l_rbi.rbi11)  THEN
               LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rai_file'),
                         "   SET rai04='",l_rbi.rbi07,"',",
                         "       rai05= 1 ,",
                         "       rai06='",l_rbi.rbi09,"',",
                         "       rai07='",l_rbi.rbi10,"',",
                         "       rai08= 1 ,",
                         "       rai09='",l_rbi.rbi12,"',",
                         "       rai10='",l_rbi.rbi13,"',", #MOD-D10080 add
                         "       raiacti='",l_rbi.rbiacti,"'",
                         " WHERE rai01='",l_rbi.rbi01,"'",
                         "   AND rai02='",l_rbi.rbi02,"'",
                         "   AND rai03='",l_rbi.rbi06,"'",
                         "   AND raiplant='",l_rbi.rbiplant,"'"
            ELSE
               LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rai_file'),
                         "   SET rai04='",l_rbi.rbi07,"',",
                         "       rai05='",l_rbi.rbi08,"',",
                         "       rai06='",l_rbi.rbi09,"',",
                         "       rai07='",l_rbi.rbi10,"',",
                         "       rai08='",l_rbi.rbi11,"',",
                         "       rai09='",l_rbi.rbi12,"',",
                         "       rai10='",l_rbi.rbi13,"',", #MOD-D10080 add
                         "       raiacti='",l_rbi.rbiacti,"'",
                         " WHERE rai01='",l_rbi.rbi01,"'",
                         "   AND rai02='",l_rbi.rbi02,"'",
                         "   AND rai03='",l_rbi.rbi06,"'",
                         "   AND raiplant='",l_rbi.rbiplant,"'"
            END IF        
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_upd_rai FROM l_sql
            EXECUTE t404sub_upd_rai
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE rai_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
         ELSE
           IF cl_null(l_rbi.rbi07) THEN LET l_rbi.rbi07 = 0 END IF  #FUN-BC0126 add
           IF cl_null(l_rbi.rbi08) THEN LET l_rbi.rbi08 = 0 END IF  #FUN-BC0126 add 
           IF cl_null(l_rbi.rbi09) THEN LET l_rbi.rbi09 = 0 END IF  #FUN-BC0126 add 
           IF cl_null(l_rbi.rbi11) THEN LET l_rbi.rbi11 = 0 END IF  #FUN-BC0126 add 
           IF cl_null(l_rbi.rbi12) THEN LET l_rbi.rbi12 = 0 END IF  #FUN-BC0126 add 
           IF cl_null(l_rbi.rbi13) THEN LET l_rbi.rbi13 = 0 END IF  #FUN-BC0126 add 
           #FUN-BC0126 mark START
           #LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rai_file'),
           #            "(rai01,rai02,rai03,rai04,rai05,rai06,rai07,rai08,rai09, raiacti, railegal,raiplant) ", 
           #            "VALUES('",l_rbi.rbi01,"','",l_rbi.rbi02,"','",l_rbi.rbi06,"',",
           #            "       '",l_rbi.rbi07,"','",l_rbi.rbi08,"','",l_rbi.rbi09,"',",
           #            "       '",l_rbi.rbi10,"','",l_rbi.rbi11,"','",l_rbi.rbi12,"',",             
           #            "       '",l_rbi.rbiacti,"','",l_rbi.rbilegal,"','",l_rbi.rbiplant,"')"
           #FUN-BC0126 mark END
           #FUN-BC0126 add START
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rai_file'),
                        "(rai01,rai02,rai03,rai04,rai05,rai06,rai07,rai08,rai09,rai10, raiacti, railegal,raiplant) ",   #FUN-BC0126 add rai10
                        "VALUES('",l_rbi.rbi01,"','",l_rbi.rbi02,"',",l_rbi.rbi06,",",
                        "        ",l_rbi.rbi07,",",l_rbi.rbi08,",",l_rbi.rbi09,",",
                        "       '",l_rbi.rbi10,"',",l_rbi.rbi11,",",l_rbi.rbi12,",",l_rbi.rbi13,",",               #FUN-BC0126 add rbi13
                        "       '",l_rbi.rbiacti,"','",l_rbi.rbilegal,"','",l_rbi.rbiplant,"')"
           #FUN-BC0126 add END
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_ins_rai FROM l_sql
            EXECUTE t404sub_ins_rai
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins','','INSERT INTO rai_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

     END FOREACH
END FUNCTION

FUNCTION t404sub_raj_upd()
DEFINE l_rbj   RECORD LIKE rbj_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbj_file'),
             "  WHERE rbj01='",l_rbh.rbh01,"'",
             "    AND rbj02='",l_rbh.rbh02,"'",
             "    AND rbj03='",l_rbh.rbh03,"'",
             "    AND rbj05='1' ",
             "    AND rbjplant='",l_rbh.rbhplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_sel_rbj FROM l_sql
      DECLARE t404sub_cs_rbj CURSOR FOR t404sub_sel_rbj
      FOREACH t404sub_cs_rbj INTO l_rbj.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raj_file'),
                   " WHERE raj01='",l_rbj.rbj01,"'",
                   "   AND raj02='",l_rbj.rbj02,"'",
                   "   AND raj03='",l_rbj.rbj06,"'",
                   "   AND raj04='",l_rbj.rbj07,"'",
                   "   AND rajplant='",l_rbj.rbjplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t404sub_sel_raj FROM l_sql
         EXECUTE t404sub_sel_raj INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raj_file'),
                      "   SET raj05='",l_rbj.rbj08,"',",
                      "       raj06='",l_rbj.rbj09,"',",
                      "       rajacti='",l_rbj.rbjacti,"'",
                      " WHERE raj01='",l_rbj.rbj01,"'",
                      "   AND raj02='",l_rbj.rbj02,"'",
                      "   AND raj03='",l_rbj.rbj06,"'",
                      "   AND raj04='",l_rbj.rbj07,"'",
                      "   AND rajplant='",l_rbj.rbjplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_upd_raj FROM l_sql
            EXECUTE t404sub_upd_raj
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE raj_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'raj_file'),
                        "(raj01,raj02,raj03,raj04,raj05,raj06,rajacti,rajlegal,rajplant)", 
                        "VALUES('",l_rbj.rbj01,"','",l_rbj.rbj02,"','",l_rbj.rbj06,"',",
                        "       '",l_rbj.rbj07,"','",l_rbj.rbj08,"','",l_rbj.rbj09,"',",
                        "       '",l_rbj.rbjacti,"','",l_rbj.rbjlegal,"','",l_rbj.rbjplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_ins_raj FROM l_sql
            EXECUTE t404sub_ins_raj
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins','','INSERT INTO raj_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

      END FOREACH
END FUNCTION


FUNCTION t404sub_raq_upd()
DEFINE l_rbq   RECORD LIKE rbq_file.*
DEFINE l_raq06        LIKE raq_file.raq06  #FUN-BC0126 add
DEFINE l_raq07        LIKE raq_file.raq07  #FUN-BC0126 add

   LET l_raq06 = g_today   #FUN-BC0126 add
   LET l_raq07 = TIME      #FUN-BC0126 add

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbq_file'),
             "  WHERE rbq01='",l_rbh.rbh01,"'",
             "    AND rbq02='",l_rbh.rbh02,"'",
             "    AND rbq03='",l_rbh.rbh03,"'",
             "    AND rbq04='3' ",
             "    AND rbq06='1' ",
             "    AND rbqplant='",l_rbh.rbhplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_sel_rbq FROM l_sql
      DECLARE t404sub_cs_rbq CURSOR FOR t404sub_sel_rbq
      FOREACH t404sub_cs_rbq INTO l_rbq.*
         IF NOT cl_null(l_rbq.rbq09) THEN   #FUN-BC0126 add  #有攤位編號
            LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                      " WHERE raq01='",l_rbq.rbq01,"'",
                      "   AND raq02='",l_rbq.rbq02,"'",
                      "   AND raq03='3'",
                      "   AND raq04='",l_rbq.rbq07,"'",
                      "   AND raq08 = '",l_rbq.rbq09,"'",   #FUN-BC0126 add
                      "   AND raqplant='",l_rbq.rbqplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_sel_raq FROM l_sql
            EXECUTE t404sub_sel_raq INTO l_n
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               RETURN
            END IF
            IF l_n>0 THEN   #此攤位編號已存在原促銷單中
               LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                         "   SET raq05='",l_rbq.rbq08,"',",
                         "       raq08='",l_rbq.rbq09,"',",  #FUN-BC0126 add
                         "       raqacti='",l_rbq.rbqacti,"'",
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='3'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raq08 = '",l_rbq.rbq09,"'",   #FUN-BC0126 add
                         "   AND raqplant='",l_rbq.rbqplant,"'"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t404sub_upd_raq FROM l_sql
               EXECUTE t404sub_upd_raq
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
            ELSE  #此攤位編號不存在於原促銷單中
              #FUN-BC0126 add START
               LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='3'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raqplant='",l_rbq.rbqplant,"'",
                         "   AND RTRIM(raq08) IS NULL "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_sel_raq5 FROM l_sql
               EXECUTE t403sub_sel_raq5 INTO l_n
               IF l_n> 0 THEN   #原促銷單存在有空值的攤位編號
                  LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                            "   SET raq05='",l_rbq.rbq08,"',",
                            "       raq08='",l_rbq.rbq09,"',",  
                            "       raqacti='",l_rbq.rbqacti,"'",
                            " WHERE raq01='",l_rbq.rbq01,"'",
                            "   AND raq02='",l_rbq.rbq02,"'",
                            "   AND raq03='3'",
                            "   AND raq04='",l_rbq.rbq07,"'",
                            "   AND RTRIM(raq08) IS NULL ",
                            "   AND raqplant='",l_rbq.rbqplant,"'"
                  TRY
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t403sub_upd_raq5 FROM l_sql
                  EXECUTE t403sub_upd_raq5
                  CATCH
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
                     LET g_success='N'
                     RETURN
                  END IF
                  END TRY
               ELSE
              #FUN-BC0126 add END   #此攤位編號不存在於原促銷單,且沒有攤位編號為空的生效營運中心
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'raq_file'),
#FUN-C60041 ----------------STA
#                             "(raq01,raq02,raq03,raq04,raq05,raqacti,raqlegal,raqplant) ", 
#                             "VALUES('",l_rbq.rbq01,"','",l_rbq.rbq02,"','",l_rbq.rbq04,"',",
#                             "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"','",l_rbq.rbqacti,"',",
#                             "       '",l_rbq.rbqlegal,"','",l_rbq.rbqplant,"')"
                              "(raq01,raq02,raq03,raq04,raq05,raqacti,raqlegal,raqplant,raq06,raq07) ",
                              "VALUES('",l_rbq.rbq01,"','",l_rbq.rbq02,"','",l_rbq.rbq04,"',",
                              "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"','",l_rbq.rbqacti,"',",
                              "       '",l_rbq.rbqlegal,"','",l_rbq.rbqplant,"','",l_raq06,"','",l_raq07,"')"
#FUN-C60041 ----------------END
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t404sub_ins_raq FROM l_sql
                  EXECUTE t404sub_ins_raq
                  IF SQLCA.sqlcode THEN
                     CALL s_errmsg('ins','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     RETURN
                  END IF 
               END IF   #FUN-BC0126 add
            END IF  #FUN-BC0126 add
         #FUN-BC0126 add START
         ELSE  #未有攤位編號 
            LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                      " WHERE raq01='",l_rbq.rbq01,"'",
                      "   AND raq02='",l_rbq.rbq02,"'",
                      "   AND raq03='3'",
                      "   AND raq04='",l_rbq.rbq07,"'",
                      "   AND raqplant='",l_rbq.rbqplant,"'",
                      "   AND raqacti = 'Y'",
                      "   AND RTRIM(raq08) IS NOT NULL "
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_sel_raq2 FROM l_sql
            EXECUTE t403sub_sel_raq2 INTO l_n
            IF l_n > 0 THEN  #若營運中心下有攤位 ,則將攤位全部update 為無效
               LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                         "   SET raq06='",l_raq06,"',",      
                         "       raq07='",l_raq07,"',",  
                         "       raqacti='N' ",
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='3'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raqplant='",l_rbq.rbqplant,"'",
                         "   AND RTRIM(raq08) IS NOT NULL "
               TRY
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_upd_raq3 FROM l_sql
               EXECUTE t403sub_upd_raq3
               CATCH
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
               END TRY  #新增一筆攤位為空值的營運中心
               LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'raq_file'),
                           "(raq01,raq02,raq03,raq04,raq05,raq08,raqacti,raqlegal,raqplant, ",
                           " raq06,raq07) ",  
                           "VALUES('",l_rbq.rbq01,"','",l_rbq.rbq02,"','",l_rbq.rbq04,"',",
                           "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"','",l_rbq.rbq09,"','",l_rbq.rbqacti,"',",  
                           "       '",l_rbq.rbqlegal,"','",l_rbq.rbqplant,"',",
                           "       '",l_raq06,"','",l_raq07,"')"
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_ins_raq4 FROM l_sql
               EXECUTE t403sub_ins_raq4
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('ns','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
            ELSE
               LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='3'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raqplant='",l_rbq.rbqplant,"'",
                         "   AND RTRIM(raq08) IS NULL "
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_sel_raq3 FROM l_sql
               EXECUTE t403sub_sel_raq3 INTO l_n
               IF l_n > 0 THEN   #原本有營運中心 但是攤位為空
                  LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                            "   SET raq05='",l_rbq.rbq08,"',",      
                            "       raq06='",l_raq06,"',",     
                            "       raq07='",l_raq07,"',",     
                            "       raqacti='",l_rbq.rbqacti,"'",
                            " WHERE raq01='",l_rbq.rbq01,"'",
                            "   AND raq02='",l_rbq.rbq02,"'",
                            "   AND raq03='3'",
                            "   AND raq04='",l_rbq.rbq07,"'",
                            "   AND RTRIM(raq08) IS NULL ",
                            "   AND raqplant='",l_rbq.rbqplant,"'"
                  TRY
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t403sub_upd_raq2 FROM l_sql
                  EXECUTE t403sub_upd_raq2
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
#                             "       '",l_rbq.rbq07,"','",l_rbq.rbq09,"',' ','",l_rbq.rbqacti,"',",   #FUN-C60041 mark
                              "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"',' ','",l_rbq.rbqacti,"',",   #FUN-C60041 add
                              "       '",l_rbq.rbqlegal,"','",l_rbq.rbqplant,"')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t403sub_ins_raq5 FROM l_sql
                  EXECUTE t403sub_ins_raq5
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('ns','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     RETURN
                  END IF
               END IF
            END IF
         #FUN-BC0126 add END
         END IF
         #FUN-BC0126 add START
         LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                   "   SET raq05='Y',",
                   "       raq06='",l_raq06,"',",      
                   "       raq07='",l_raq07,"' ",     
                   " WHERE raq01='",l_rbq.rbq01,"'",
                   "   AND raq02='",l_rbq.rbq02,"'",
                   "   AND raq03='3'",
                   "   AND raqplant='",l_rbq.rbqplant,"'"
         TRY              
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t403sub_upd_raq4 FROM l_sql
         EXECUTE t403sub_upd_raq4
         CATCH
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
            CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
            LET g_success='N'
            RETURN
         END IF
         END TRY
       #FUN-BC0126 add END
      END FOREACH
END FUNCTION

FUNCTION t404sub_rap_upd()
DEFINE l_rbp   RECORD LIKE rbp_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbp_file'),
             "  WHERE rbp01='",l_rbh.rbh01,"'",
             "    AND rbp02='",l_rbh.rbh02,"'",
             "    AND rbp03='",l_rbh.rbh03,"'",
             "    AND rbp04='3' ",
             "    AND rbp06='1' ",
             "    AND rbpplant='",l_rbh.rbhplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_sel_rbp FROM l_sql
      DECLARE t404sub_cs_rbp CURSOR FOR t404sub_sel_rbp
      FOREACH t404sub_cs_rbp INTO l_rbp.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rap_file'),
                   " WHERE rap01='",l_rbp.rbp01,"'",
                   "   AND rap02='",l_rbp.rbp02,"'",
                   "   AND rap03='3' ",
                   "   AND rap04='",l_rbp.rbp07,"'",
                   "   AND rap05='",l_rbp.rbp08,"'",
                   "   AND rapplant='",l_rbp.rbpplant,"'",
                   "   AND rap09 = '",l_rbp.rbp12,"'"  #TQC-C20378 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t404sub_sel_rap FROM l_sql
         EXECUTE t404sub_sel_rap INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rap_file'),
                      "   SET rap06='",l_rbp.rbp09,"',",
                      "       rap07='",l_rbp.rbp10,"',",
                      "       rap08='",l_rbp.rbp11,"',",
                      "       rap09='",l_rbp.rbp12,"',",  #FUN-BC0126 add
                      "       rapacti='",l_rbp.rbpacti,"'",
                      " WHERE rap01='",l_rbp.rbp01,"'",
                      "   AND rap02='",l_rbp.rbp02,"'",
                      "   AND rap03='3'",
                      "   AND rap04='",l_rbp.rbp07,"'",
                      "   AND rap05='",l_rbp.rbp08,"'",
                      "   AND rapplant='",l_rbp.rbpplant,"'",
                      "   AND rap09 = '",l_rbp.rbp12,"'"  #TQC-C20378 add
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_upd_rap FROM l_sql
            EXECUTE t404sub_upd_rap
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE rap_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rap_file'),
                        "(rap01,rap02,rap03,rap04,rap05,rap06,rap07,rap08,rap09,rapacti,",  #FUN-BC0126 add rap09
                        " raplegal,rapplant) ", 
                        "VALUES('",l_rbp.rbp01,"','",l_rbp.rbp02,"','",l_rbp.rbp04,"',",
                        "       '",l_rbp.rbp07,"','",l_rbp.rbp08,"','",l_rbp.rbp09,"',",
                        "       '",l_rbp.rbp10,"','",l_rbp.rbp11,"','",l_rbp.rbp12,"','",l_rbp.rbpacti,"',",  #FUN-BC0126 add rbp12
                        "       '",l_rbp.rbplegal,"','",l_rbp.rbpplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_ins_rap FROM l_sql
            EXECUTE t404sub_ins_rap
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins','','INSERT INTO rap_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

      END FOREACH
END FUNCTION

FUNCTION t404sub_rar_upd()
DEFINE l_rbr   RECORD LIKE rbr_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbr_file'),
             "  WHERE rbr01='",l_rbh.rbh01,"'",
             "    AND rbr02='",l_rbh.rbh02,"'",
             "    AND rbr03='",l_rbh.rbh03,"'",
             "    AND rbr04='3' ",
             "    AND rbr06='1' ",
             "    AND rbrplant='",l_rbh.rbhplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_sel_rbr FROM l_sql
      DECLARE t404sub_cs_rbr CURSOR FOR t404sub_sel_rbr
      FOREACH t404sub_cs_rbr INTO l_rbr.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rar_file'),
                   " WHERE rar01='",l_rbr.rbr01,"'",
                   "   AND rar02='",l_rbr.rbr02,"'",
                   "   AND rar03='3' ",
                   "   AND rar04='",l_rbr.rbr07,"'",
                   "   AND rar05='",l_rbr.rbr08,"'",
                   "   AND rarplant='",l_rbr.rbrplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t404sub_sel_rar FROM l_sql
         EXECUTE t404sub_sel_rar INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rar_file'),
                      "   SET rar06='",l_rbr.rbr09,"',",
                      "       rar07='",l_rbr.rbr10,"',",
                      "       rar08='",l_rbr.rbr11,"',",
                      "       raracti='",l_rbr.rbracti,"'",
                      " WHERE rar01='",l_rbr.rbr01,"'",
                      "   AND rar02='",l_rbr.rbr02,"'",
                      "   AND rar03='3'",
                      "   AND rar04='",l_rbr.rbr07,"'",
                      "   AND rar05='",l_rbr.rbr08,"'",
                      "   AND rarplant='",l_rbr.rbrplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_upd_rar FROM l_sql
            EXECUTE t404sub_upd_rar
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE rar_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rar_file'),
                        "(rar01,rar02,rar03,rar04,rar05,rar06,rar07,rar08,raracti,",
                        " rarlegal,rarplant) ", 
                        "VALUES('",l_rbr.rbr01,"','",l_rbr.rbr02,"','",l_rbr.rbr04,"',",
                        "       '",l_rbr.rbr07,"','",l_rbr.rbr08,"','",l_rbr.rbr09,"',",
                        "       '",l_rbr.rbr10,"','",l_rbr.rbr11,"','",l_rbr.rbracti,"',",
                        "       '",l_rbr.rbrlegal,"','",l_rbr.rbrplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_ins_rar FROM l_sql
            EXECUTE t404sub_ins_rar
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins','','INSERT INTO rar_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

      END FOREACH
END FUNCTION

FUNCTION t404sub_ras_upd()
DEFINE l_rbs   RECORD LIKE rbs_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbs_file'),
             "  WHERE rbs01='",l_rbh.rbh01,"'",
             "    AND rbs02='",l_rbh.rbh02,"'",
             "    AND rbs03='",l_rbh.rbh03,"'",
             "    AND rbs04='3' ",
             "    AND rbs06='1' ",
             "    AND rbsplant='",l_rbh.rbhplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_sel_rbs FROM l_sql
      DECLARE t404sub_cs_rbs CURSOR FOR t404sub_sel_rbs  
      FOREACH t404sub_cs_rbs INTO l_rbs.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'ras_file'),
                   " WHERE ras01='",l_rbs.rbs01,"'",
                   "   AND ras02='",l_rbs.rbs02,"'",
                   "   AND ras03='3' ",
                   "   AND ras04='",l_rbs.rbs07,"'",
                   "   AND ras05='",l_rbs.rbs08,"'",
                   "   AND ras06='",l_rbs.rbs09,"'",  #TQC-C30055 add
                   "   AND rasplant='",l_rbs.rbsplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t404sub_sel_ras FROM l_sql
         EXECUTE t404sub_sel_ras INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'ras_file'),
                      "   SET ras06='",l_rbs.rbs09,"',",
                      "       ras07='",l_rbs.rbs10,"',",
                      "       ras08='",l_rbs.rbs11,"',",
                      "       ras09='",l_rbs.rbs12,"',",  #FUN-BC0126 add
                      "       rasacti='",l_rbs.rbsacti,"'",
                      " WHERE ras01='",l_rbs.rbs01,"'",
                      "   AND ras02='",l_rbs.rbs02,"'",
                      "   AND ras03='3'",
                      "   AND ras04='",l_rbs.rbs07,"'",
                      "   AND ras05='",l_rbs.rbs08,"'",
                      "   AND ras06='",l_rbs.rbs09,"'",  #FUN-BC0126 add
                      "   AND rasplant='",l_rbs.rbsplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_upd_ras FROM l_sql
            EXECUTE t404sub_upd_ras
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE ras_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'ras_file'),
                        "(ras01,ras02,ras03,ras04,ras05,ras06,ras07,ras08,ras09,rasacti,",  #FUN-BC0126 add ras09
                        " raslegal,rasplant) ", 
                        "VALUES('",l_rbs.rbs01,"','",l_rbs.rbs02,"','",l_rbs.rbs04,"',",
                        "       '",l_rbs.rbs07,"','",l_rbs.rbs08,"','",l_rbs.rbs09,"',",
                        "       '",l_rbs.rbs10,"','",l_rbs.rbs11,"','",l_rbs.rbs12,"','",l_rbs.rbsacti,"',",  #FUN-BC0126 add rbs12
                        "       '",l_rbs.rbslegal,"','",l_rbs.rbsplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_ins_ras FROM l_sql
            EXECUTE t404sub_ins_ras
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('ins','','INSERT INTO ras_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

      END FOREACH
END FUNCTION

FUNCTION  t404sub_repeat()
 DEFINE l_rai  RECORD LIKE rai_file.*
  
   LET l_sql="SELECT * FROM ",cl_get_target_table(l_plant,'rai_file'),
             " WHERE rai01='",l_rbh.rbh01,"'",
             "   AND rai02='",l_rbh.rbh02,"'",
             "   AND raiplant='",l_rbh.rbhplant,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
   PREPARE t404sub_chk_rai FROM l_sql
   DECLARE t404sub_cs_rai CURSOR FOR t404sub_chk_rai
   FOREACH t404sub_cs_rai INTO l_rai.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('sel','','CHECK rai_file:',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF

     # CALL t304sub_chk('3',l_plant,l_rah.rah01,l_rah.rah02,l_rah.rah03,l_rah.rah04,l_rah.rah05,l_rah.rah06,l_rah.rah07)
   END FOREACH

END FUNCTION





  #BEGIN WORK
  #   LET g_success = 'Y'
      
  #   CALL t404sub_lock_cl()

  #   OPEN t404sub_cl USING l_rbh01,l_rbh02,l_rbh03,l_rbhplant

  #   IF STATUS THEN
  #      CALL cl_err("OPEN t404_cl:", STATUS, 1)
  #      CLOSE t404_cl
  #      ROLLBACK WORK
  #      RETURN
  #   END IF

  #   FETCH t404sub_cl INTO l_rbh.*
  #   IF SQLCA.sqlcode THEN
  #      CALL cl_err(g_rbh.rbh02,SQLCA.sqlcode,0)
  #      CLOSE t404sub_cl
  #      ROLLBACK WORK
  #      RETURN
  #   END IF
  #   LET g_success = 'Y'
  #   LET g_time =TIME
  #
  #   LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rbh_file'),
  #             "   SET rbhconf='Y',",
  #             "       rbhcond='",g_today,"',",
  #             "       rbhcont='",g_time ,"',",
  #             "       rbhconu='",g_user ,"'",
  #             " WHERE rbh01='",l_rbh01,"'", 
  #             "   AND rbh02='",l_rbh02,"'",
  #             "   AND rbh03='",l_rbh03,"'", 
  #             "   AND rbhplant='",l_rbhplant,"'"
  #   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
  #   CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
  #   PREPARE t404sub_upd_rbh FROM l_sql
  #   EXECUTE t404sub_upd_rbh
  #   IF SQLCA.sqlerrd[3]=0 THEN
  #      LET g_success='N'
  #   END IF


#FUNCTION t404sub_lock_cl()
# DEFINE l_forupd_sql STRING                                                   
#
#   LET l_forupd_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'rbh_file'),
#                      " WHERE rbh01 = ? AND rbh02 = ? AND rbh03 =? AND rbhplant = ?  ",
#                      " FOR UPDATE "       
#   CALL cl_replace_sqldb(l_forupd_sql) RETURNING l_forupd_sql      
#   CALL cl_parse_qry_sql(l_forupd_sql,l_plant) RETURNING l_forupd_sql 
#   LET l_forupd_sql = cl_forupd_sql(l_forupd_sql)
#   DECLARE t404sub_cl CURSOR FROM l_forupd_sql 
#
#END FUNCTION

#FUN-BC0126 add START
FUNCTION  t404sub_rak_upd()
DEFINE l_rbk   RECORD LIKE rbk_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbk_file'),
             "  WHERE rbk01='",l_rbh.rbh01,"'",
             "    AND rbk02='",l_rbh.rbh02,"'",
             "    AND rbk03='",l_rbh.rbh03,"'",
             "    AND rbk05='3' ",
             "    AND rbkplant='",l_rbh.rbhplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t404sub_sel_rbk FROM l_sql
      DECLARE t404sub_sel_rbk_cs CURSOR FOR t404sub_sel_rbk
      FOREACH t404sub_sel_rbk_cs INTO l_rbk.*
         IF cl_null(l_rbk.rbk14) THEN LET l_rbk.rbk14 = ' ' END IF
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rak_file'),
                   " WHERE rak01='",l_rbk.rbk01,"'",
                   "   AND rak02='",l_rbk.rbk02,"'",
                   "   AND rak03='3'",
                   "   AND rak04='",l_rbk.rbk07,"'",
                   "   AND rak05='",l_rbk.rbk08,"'",
                   "   AND rakplant='",l_rbk.rbkplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t404sub_sel_rak FROM l_sql
         EXECUTE t404sub_sel_rak INTO l_n
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
                      "   AND rak03='3' ",
                      "   AND rak05=",l_rbk.rbk08,
                      "   AND rakplant='",l_rbk.rbkplant,"'"
            TRY                 #NO.MOD-AC0176
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_upd_rak FROM l_sql
            EXECUTE t404sub_upd_rak
            CATCH
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('upd','','UPDATE rak_file:',SQLCA.sqlcode,1)
               LET g_success='N'
               RETURN
            END IF
            END TRY
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rak_file'),
                        "(rak01,rak02,rak03,rak04,rak05,rak06,",
                        " rak07,rak08,rak09,rak10,rak11,",
                        " rakacti,raklegal,rakplant)",
                        "VALUES('",l_rbk.rbk01,"','",l_rbk.rbk02,"','3',",
                        "       '",l_rbk.rbk07,"','",l_rbk.rbk08,"','",l_rbk.rbk09,"',",
                        "       '",l_rbk.rbk10,"','",l_rbk.rbk11,"','",l_rbk.rbk12,"',",
                        "       '",l_rbk.rbk13,"','",l_rbk.rbk14,"',",
                        "       '",l_rbk.rbkacti,"','",l_rbk.rbklegal,"','",l_rbk.rbkplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t404sub_ins_rak FROM l_sql
            EXECUTE t404sub_ins_rak
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rak_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF

      END FOREACH
END FUNCTION

#FUN-BC0126 add END

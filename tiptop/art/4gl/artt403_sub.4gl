# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: artt403_sub.4gl
# Descriptions...: 組合促銷變更審核檢驗
#Date & Author...: NO.FUN-A80104 10/09/08 By lixia
# Modify.........: No.FUN-AB0033 10/11/22 By wangxin 促銷BUG調整
# Modify.........: No.MOD-AC0188 10/12/20 By shenyang 5.25CT1 BUG調整
# Modify.........: No.TQC-B10003 11/01/05 By shenyang 修改5.25PT bug
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-BC0078 11/12/22 By pauline GP5.3 artt403 一般促銷變更單促銷功能優化
# Modify.........: No.FUN-BC0126 12/01/11 By pauline GP5.3 artt403 一般促銷變更單促銷功能優化修改
# Modify.........: No.TQC-C20378 12/02/22 By pauline 更新rap時將會員促銷方式當為key值
DATABASE ds

GLOBALS "../../config/top.global"

DEFINE l_rbe01     LIKE rbe_file.rbe01
DEFINE l_rbe02     LIKE rbe_file.rbe02
DEFINE l_rbe03     LIKE rbe_file.rbe03
DEFINE l_plant     LIKE azw_file.azw01
DEFINE l_n         LIKE type_file.num5
DEFINE l_rbe       RECORD LIKE rbe_file.*
DEFINE l_sql       STRING


FUNCTION t403sub_y_upd(p_rbe01,p_rbe02,p_rbe03,p_rbeplant) 
DEFINE p_rbe01     LIKE rbe_file.rbe01
DEFINE p_rbe02     LIKE rbe_file.rbe02
DEFINE p_rbe03     LIKE rbe_file.rbe03
DEFINE p_rbeplant  LIKE rbe_file.rbeplant

   LET l_rbe01=p_rbe01
   LET l_rbe02=p_rbe02
   LET l_rbe03=p_rbe03
   LET l_plant=p_rbeplant
   LET g_time = TIME
       
   LET l_sql="SELECT * FROM ",cl_get_target_table(l_plant,'rbe_file'),
             " WHERE rbe01='",l_rbe01,"'",
             "   AND rbe02='",l_rbe02,"'",
             "   AND rbe03='",l_rbe03,"'",
             "   AND rbeplant='",l_plant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t403sub_sel_rbe FROM l_sql
      EXECUTE t403sub_sel_rbe INTO l_rbe.*
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         RETURN
      END IF

      LET g_success = 'Y'
  
      IF g_success='Y' THEN 
         CALL t403sub_rae_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t403sub_raf_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t403sub_rag_upd()       
      END IF
      IF g_success='Y' THEN 
         CALL t403sub_raq_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t403sub_rap_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t403sub_rar_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t403sub_ras_upd()
      END IF
      IF g_success='Y' THEN 
         CALL t403sub_repeat()
      END IF

    #FUN-BC0078 add START
      IF g_success='Y' THEN
         CALL t403sub_rak_upd()
      END IF
    #FUN-BC0078 add END

      IF g_success = 'N' THEN
         RETURN
      END IF
   
END FUNCTION

FUNCTION t403sub_rae_upd()
DEFINE l_raepos LIKE rae_file.raepos #FUN-B40071 
   IF cl_null(l_rbe.rbe16t) THEN
      LET l_rbe.rbe16t = 100
   END IF
   IF cl_null(l_rbe.rbe19t) THEN
      LET l_rbe.rbe19t = 100
   END IF     
#MOD-AC0188--ADD--begin
   IF cl_null(l_rbe.rbe21t) THEN
      LET l_rbe.rbe21t = 0
   END IF
#MOD-AC0188--ADD--end 
   #FUN-B40071 --START--
   SELECT raepos INTO l_raepos FROM rae_file
    WHERE rae01= l_rbe.rbe01 AND rae02= l_rbe.rbe02
     AND raeplant=l_rbe.rbeplant
   IF l_raepos <> '1' THEN
      LET l_raepos = '2'
   ELSE
      LET l_raepos = '1'
   END IF   
   #FUN-B40071 --END--
   IF cl_null(l_rbe.rbe31t) THEN LET l_rbe.rbe31t = 0 END IF
   LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rae_file'),
            #"   SET rae04='",l_rbe.rbe04t,"',",  #FUN-BC0078 mark
            #"       rae05='",l_rbe.rbe05t,"',",  #FUN-BC0078 mark
            #"       rae06='",l_rbe.rbe06t,"',",  #FUN-BC0078 mark
            #"       rae07='",l_rbe.rbe07t,"',",  #FUN-BC0078 mark
             "   SET rae10='",l_rbe.rbe10t,"',",
             "       rae11='",l_rbe.rbe11t,"',",
             "       rae12='",l_rbe.rbe12t,"',",
             "       rae13='",l_rbe.rbe13t,"',",
             "       rae14='",l_rbe.rbe14t,"',",
             "       rae15='",l_rbe.rbe15t,"',",
             "       rae16='",l_rbe.rbe16t,"',",
             "       rae17='",l_rbe.rbe17t,"',",
             "       rae18='",l_rbe.rbe18t,"',",
             "       rae19='",l_rbe.rbe19t,"',",
             "       rae20='",l_rbe.rbe20t,"',",
             "       rae21='",l_rbe.rbe21t,"',",
             "       rae23='",l_rbe.rbe23t,"',",
             "       rae24='",l_rbe.rbe24t,"',",
             "       rae25='",l_rbe.rbe25t,"',",
             "       rae26='",l_rbe.rbe26t,"',",
             "       rae27='",l_rbe.rbe27t,"',",
             "       rae28='",l_rbe.rbe28t,"',",
             "       rae29='",l_rbe.rbe29t,"',",
             "       rae30='",l_rbe.rbe30t,"',",
             "       rae31='",l_rbe.rbe31t,"',",  
             "       raepos='",l_raepos, "'", #No:FUN-B40071                
             " WHERE rae01='",l_rbe.rbe01,"'",
             "   AND rae02='",l_rbe.rbe02,"'",
             "   AND raeplant='",l_rbe.rbeplant,"'"   
    TRY                        #FUN-AB0033 add        
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
       PREPARE t403sub_upd_rae FROM l_sql
       EXECUTE t403sub_upd_rae
    CATCH                        #FUN-AB0033 add
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
          LET g_success='N'
          RETURN
       END IF
    END TRY                        #FUN-AB0033 add
END FUNCTION


FUNCTION t403sub_raf_upd()
DEFINE l_rbf   RECORD LIKE rbf_file.*
DEFINE l_cnt   LIKE type_file.num10
   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbf_file'),
             "  WHERE rbf01='",l_rbe.rbe01,"'",
             "    AND rbf02='",l_rbe.rbe02,"'",
             "    AND rbf03='",l_rbe.rbe03,"'",
             "    AND rbf05='1' ",
             "    AND rbfplant='",l_rbe.rbeplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t403sub_sel_rbf FROM l_sql
      DECLARE rbf_cs_rbf CURSOR FOR t403sub_sel_rbf
      FOREACH rbf_cs_rbf INTO l_rbf.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raf_file'),
                   " WHERE raf01='",l_rbf.rbf01,"'",
                   "   AND raf02='",l_rbf.rbf02,"'",
                   "   AND raf03='",l_rbf.rbf06,"'",
                   "   AND rafplant='",l_rbf.rbfplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t403sub_sel_raf FROM l_sql
         EXECUTE t403sub_sel_raf INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raf_file'),
                      "   SET raf04='",l_rbf.rbf07,"',",
                      "       raf05='",l_rbf.rbf08,"',",
                      "       rafacti='",l_rbf.rbfacti,"'",
                      " WHERE raf01='",l_rbf.rbf01,"'",
                      "   AND raf02='",l_rbf.rbf02,"'",
                      "   AND raf03='",l_rbf.rbf06,"'",
                      "   AND rafplant='",l_rbf.rbfplant,"'"
            TRY                            #FUN-AB0033 add
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_upd_raf FROM l_sql
               EXECUTE t403sub_upd_raf
            CATCH                          #FUN-AB0033 add
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE raf_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
            END TRY                        #FUN-AB0033 add
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'raf_file'),
                        "(raf01,raf02,raf03,raf04,raf05,rafacti,",
                        " raflegal,rafplant) ", 
                        " VALUES('",l_rbf.rbf01,"','",l_rbf.rbf02,"','",l_rbf.rbf06,"',",
                        "       '",l_rbf.rbf07,"','",l_rbf.rbf08,"','",l_rbf.rbfacti,"',",
                        "       '",l_rbf.rbflegal,"','",l_rbf.rbfplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_ins_raf FROM l_sql
            EXECUTE t403sub_ins_raf
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO raf_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF         
      END FOREACH
END FUNCTION

FUNCTION t403sub_rag_upd()        
DEFINE l_rbg   RECORD LIKE rbg_file.*


   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbg_file'),
             "  WHERE rbg01='",l_rbe.rbe01,"'",
             "    AND rbg02='",l_rbe.rbe02,"'",
             "    AND rbg03='",l_rbe.rbe03,"'",
             "    AND rbg05='1' ",
             "    AND rbgplant='",l_rbe.rbeplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t403sub_sel_rbg FROM l_sql
      DECLARE rbg_cs_rbg CURSOR FOR t403sub_sel_rbg
      FOREACH rbg_cs_rbg INTO l_rbg.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rag_file'),
                   " WHERE rag01='",l_rbg.rbg01,"'",
                   "   AND rag02='",l_rbg.rbg02,"'",
                   "   AND rag03='",l_rbg.rbg06,"'",
                   "   AND rag04='",l_rbg.rbg07,"'",
                   "   AND rag05='",l_rbg.rbg08,"'", #TQC-B10003 
                   "   AND ragplant='",l_rbg.rbgplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t403sub_sel_rag FROM l_sql
         EXECUTE t403sub_sel_rag INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rag_file'),
                      "   SET rag05='",l_rbg.rbg08,"',",
                      "       rag06='",l_rbg.rbg09,"',",
                      "       ragacti='",l_rbg.rbgacti,"'",
                      " WHERE rag01='",l_rbg.rbg01,"'",
                      "   AND rag02='",l_rbg.rbg02,"'",
                      "   AND rag03='",l_rbg.rbg06,"'",
                      "   AND rag04='",l_rbg.rbg07,"'",
                      "   AND rag05='",l_rbg.rbg08,"'", #TQC-B10003
                      "   AND ragplant='",l_rbg.rbgplant,"'"
            TRY                            #FUN-AB0033 add
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_upd_rag FROM l_sql
               EXECUTE t403sub_upd_rag
            CATCH                          #FUN-AB0033 add
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE rag_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
            END TRY                        #FUN-AB0033 add
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rag_file'),
                        "(rag01,rag02,rag03,rag04,rag05,rag06,ragacti,raglegal,ragplant)", 
                        " VALUES('",l_rbg.rbg01,"','",l_rbg.rbg02,"','",l_rbg.rbg06,"',",
                        "       '",l_rbg.rbg07,"','",l_rbg.rbg08,"','",l_rbg.rbg09,"',",
                        "       '",l_rbg.rbgacti,"','",l_rbg.rbglegal,"','",l_rbg.rbgplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_ins_rag FROM l_sql
            EXECUTE t403sub_ins_rag
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rag_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF
      END FOREACH
END FUNCTION

FUNCTION t403sub_raq_upd()
DEFINE l_rbq   RECORD LIKE rbq_file.*
DEFINE l_raq06        LIKE raq_file.raq06  #FUN-BC0078 add
DEFINE l_raq07        LIKE raq_file.raq07  #FUN-BC0078 add


   LET l_raq06 = g_today   #FUN-BC0078 add
   LET l_raq07 = TIME      #FUN-BC0078 add

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbq_file'),
             "  WHERE rbq01='",l_rbe.rbe01,"'",
             "    AND rbq02='",l_rbe.rbe02,"'",
             "    AND rbq03='",l_rbe.rbe03,"'",
             "    AND rbq04='2' ",
             "    AND rbq06='1' ",
             "    AND rbqplant='",l_rbe.rbeplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t403sub_sel_rbq FROM l_sql
      DECLARE rbq_cs_rbq CURSOR FOR t403sub_sel_rbq
      FOREACH rbq_cs_rbq INTO l_rbq.*
         IF NOT cl_null(l_rbq.rbq09) THEN   #FUN-BC0078 add  #有攤位編號 
            LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                      " WHERE raq01='",l_rbq.rbq01,"'",
                      "   AND raq02='",l_rbq.rbq02,"'",
                      "   AND raq03='2'",
                      "   AND raq04='",l_rbq.rbq07,"'",
                      "   AND raq08 = '",l_rbq.rbq09,"'",   #FUN-BC0078 add
                      "   AND raqplant='",l_rbq.rbqplant,"'"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_sel_raq FROM l_sql
            EXECUTE t403sub_sel_raq INTO l_n
            IF SQLCA.sqlcode THEN
               LET g_success='N'
               RETURN
            END IF
            IF l_n>0 THEN    #此攤位編號已存在原促銷單中
               LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                         "   SET raq05='",l_rbq.rbq08,"',",
                         "       raq08='",l_rbq.rbq09,"',",  #FUN-BC0078 add
                         "       raqacti='",l_rbq.rbqacti,"'",
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='2'",
                         "   AND raq04='",l_rbq.rbq07,"'",
                         "   AND raq08='",l_rbq.rbq09,"'", #FUN-BC0078 add 
                         "   AND raqplant='",l_rbq.rbqplant,"'"
               TRY                        #FUN-AB0033 add          
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t403sub_upd_raq FROM l_sql
                  EXECUTE t403sub_upd_raq
               CATCH                       #FUN-AB0033 add
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('upd','','UPDATE raq_file:',SQLCA.sqlcode,1)
                     LET g_success='N'
                     RETURN
                  END IF
               END TRY                        #FUN-AB0033 add
            ELSE  #此攤位編號不存在於原促銷單中
              #FUN-BC0078 add START
               LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                         " WHERE raq01='",l_rbq.rbq01,"'",
                         "   AND raq02='",l_rbq.rbq02,"'",
                         "   AND raq03='2'",
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
                            "   AND raq03='2'",
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
              #FUN-BC0078 add END   #此攤位編號不存在於原促銷單,且沒有攤位編號為空
                  LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'raq_file'),
                              "(raq01,raq02,raq03,raq04,raq05,raqacti,raqlegal,raqplant) ", 
                              " VALUES('",l_rbq.rbq01,"','",l_rbq.rbq02,"','",l_rbq.rbq04,"',",
                              "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"','",l_rbq.rbqacti,"',",
                              "       '",l_rbq.rbqlegal,"','",l_rbq.rbqplant,"')"
                  CALL cl_replace_sqldb(l_sql) RETURNING l_sql
                  CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
                  PREPARE t403sub_ins_raq FROM l_sql
                  EXECUTE t403sub_ins_raq
                  IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                     CALL s_errmsg('ns','','INSERT INTO raq_file:',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                     RETURN
                  END IF 
               END IF   #FUN-BC0078 add
            END IF  #FUN-BC0078 add
       #FUN-BC0078 add START
         ELSE  #未有攤位編號
            LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'raq_file'),
                      " WHERE raq01='",l_rbq.rbq01,"'",
                      "   AND raq02='",l_rbq.rbq02,"'",
                      "   AND raq03='2'",
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
                         "   AND raq03='2'",
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
                         "   AND raq03='2'",
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
                            "   AND raq03='2'",
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
                              "       '",l_rbq.rbq07,"','",l_rbq.rbq08,"','",l_rbq.rbq09,"','",l_rbq.rbqacti,"',",
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
         #FUN-BC0078 add END
         END IF
         #FUN-BC0078 add START
         LET l_sql="UPDATE ",cl_get_target_table(l_plant,'raq_file'),
                   "   SET raq05='Y',",
                   "       raq06='",l_raq06,"',",      
                   "       raq07='",l_raq07,"' ",    
                   " WHERE raq01='",l_rbq.rbq01,"'",
                   "   AND raq02='",l_rbq.rbq02,"'",
                   "   AND raq03='2'",
                   "   AND raqplant='",l_rbq.rbqplant,"'"
         TRY                 #NO.MOD-AC0176
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
       #FUN-BC0078 add END
      END FOREACH
END FUNCTION

FUNCTION t403sub_rap_upd()
DEFINE l_rbp   RECORD LIKE rbp_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbp_file'),
             "  WHERE rbp01='",l_rbe.rbe01,"'",
             "    AND rbp02='",l_rbe.rbe02,"'",
             "    AND rbp03='",l_rbe.rbe03,"'",
             "    AND rbp04='2' ",
             "    AND rbp06='1' ",
             "    AND rbpplant='",l_rbe.rbeplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t403sub_sel_rbp FROM l_sql
      DECLARE rbp_cs_rbp CURSOR FOR t403sub_sel_rbp
      FOREACH rbp_cs_rbp INTO l_rbp.*
#MOD-AC0188--ADD--begin
      IF cl_null(l_rbp.rbp10) THEN
         LET l_rbp.rbp10 = 100
      END IF
#MOD-AC0188--ADD--end
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rap_file'),
                   " WHERE rap01='",l_rbp.rbp01,"'",
                   "   AND rap02='",l_rbp.rbp02,"'",
                   "   AND rap03='2' ",
                   "   AND rap04='",l_rbp.rbp07,"'",
                   "   AND rap05='",l_rbp.rbp08,"'",
                   "   AND rapplant='",l_rbp.rbpplant,"'",
                   "   AND rap09 = '",l_rbp.rbp12,"'"  #TQC-C20378 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t403sub_sel_rap FROM l_sql
         EXECUTE t403sub_sel_rap INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'rap_file'),
                      "   SET rap06='",l_rbp.rbp09,"',",
                      "       rap07='",l_rbp.rbp10,"',",
                      "       rap08='",l_rbp.rbp11,"',",
                      "       rap09='",l_rbp.rbp12,"',",  #FUN-BC0078 add
                      "       rapacti='",l_rbp.rbpacti,"'",
                      " WHERE rap01='",l_rbp.rbp01,"'",
                      "   AND rap02='",l_rbp.rbp02,"'",
                      "   AND rap03='2'",
                      "   AND rap04='",l_rbp.rbp07,"'",
                      "   AND rap05='",l_rbp.rbp08,"'",
                      "   AND rapplant='",l_rbp.rbpplant,"'", 
                      "   AND rap09 = '",l_rbp.rbp12,"'"  #TQC-C20378 add
            TRY                          #FUN-AB0033 add          
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_upd_rap FROM l_sql
               EXECUTE t403sub_upd_rap
            CATCH                        #FUN-AB0033 add
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE rap_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
            END TRY                       #FUN-AB0033 add
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rap_file'),
                        "(rap01,rap02,rap03,rap04,rap05,rap06,rap07,rap08,rap09,rapacti,",  #FUN-BC0078 add rap09
                        " raplegal,rapplant) ", 
                        " VALUES('",l_rbp.rbp01,"','",l_rbp.rbp02,"','",l_rbp.rbp04,"',",
                        "       '",l_rbp.rbp07,"','",l_rbp.rbp08,"','",l_rbp.rbp09,"',",
                        "       '",l_rbp.rbp10,"','",l_rbp.rbp11,"','",l_rbp.rbp12,"','",l_rbp.rbpacti,"',",  #FUN-BC0078 add rbp12
                        "       '",l_rbp.rbplegal,"','",l_rbp.rbpplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_ins_rap FROM l_sql
            EXECUTE t403sub_ins_rap
            IF SQLCA.sqlcode  OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rap_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF

      END FOREACH
END FUNCTION

FUNCTION t403sub_rar_upd()
DEFINE l_rbr   RECORD LIKE rbr_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbr_file'),
             "  WHERE rbr01='",l_rbe.rbe01,"'",
             "    AND rbr02='",l_rbe.rbe02,"'",
             "    AND rbr03='",l_rbe.rbe03,"'",
             "    AND rbr04='2' ",
             "    AND rbr06='1' ",
             "    AND rbrplant='",l_rbe.rbeplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t403sub_sel_rbr FROM l_sql
      DECLARE rbr_cs_rbr CURSOR FOR t403sub_sel_rbr
      FOREACH rbr_cs_rbr INTO l_rbr.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rar_file'),
                   " WHERE rar01='",l_rbr.rbr01,"'",
                   "   AND rar02='",l_rbr.rbr02,"'",
                   "   AND rar03=2 ",
                   "   AND rar04='",l_rbr.rbr07,"'",
                   "   AND rar05='",l_rbr.rbr08,"'",                  
                   "   AND rarplant='",l_rbr.rbrplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t403sub_sel_rar FROM l_sql
         EXECUTE t403sub_sel_rar INTO l_n
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
                      "   AND rar03 = 2 ",
                      "   AND rar04='",l_rbr.rbr07,"'",
                      "   AND rar05='",l_rbr.rbr08,"'",
                      "   AND rarplant='",l_rbr.rbrplant,"'"
            TRY                        #FUN-AB0033 add
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_upd_rar FROM l_sql
               EXECUTE t403sub_upd_rar
            CATCH                        #FUN-AB0033 add
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE rar_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
            END TRY                        #FUN-AB0033 add
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'rar_file'),
                        "(rar01,rar02,rar03,rar04,rar05,rar06,rar07,rar08,raracti,rarlegal,rarplant)", 
                        " VALUES('",l_rbr.rbr01,"','",l_rbr.rbr02,"','2','",l_rbr.rbr07,"',",
                        "       '",l_rbr.rbr08,"','",l_rbr.rbr09,"','",l_rbr.rbr10,"','",l_rbr.rbr11,"',",
                        "       '",l_rbr.rbracti,"','",l_rbr.rbrlegal,"','",l_rbr.rbrplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_ins_rar FROM l_sql
            EXECUTE t403sub_ins_rar
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rar_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF
      END FOREACH
END FUNCTION

FUNCTION t403sub_ras_upd()
DEFINE l_rbs   RECORD LIKE rbs_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbs_file'),
             "  WHERE rbs01='",l_rbe.rbe01,"'",
             "    AND rbs02='",l_rbe.rbe02,"'",
             "    AND rbs03='",l_rbe.rbe03,"'",
             "    AND rbs06='1' ",
             "    AND rbsplant='",l_rbe.rbeplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t403sub_sel_rbs FROM l_sql
      DECLARE rbs_cs_rbs CURSOR FOR t403sub_sel_rbs
      FOREACH rbs_cs_rbs INTO l_rbs.*
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'ras_file'),
                   " WHERE ras01='",l_rbs.rbs01,"'",
                   "   AND ras02='",l_rbs.rbs02,"'",
                   "   AND ras03='2'",
                   "   AND ras04='",l_rbs.rbs07,"'",
                   "   AND ras05='",l_rbs.rbs08,"'",
                   "   AND ras06='",l_rbs.rbs09,"'",
                   "   AND rasplant='",l_rbs.rbsplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t403sub_sel_ras FROM l_sql
         EXECUTE t403sub_sel_ras INTO l_n
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            RETURN
         END IF
         IF l_n>0 THEN
            LET l_sql="UPDATE ",cl_get_target_table(l_plant,'ras_file'),
                      "   SET ras07='",l_rbs.rbs10,"',",
                      "       ras08='",l_rbs.rbs11,"',",
                      "       ras09='",l_rbs.rbs12,"',",  #FUN-BC0078 add
                      "       rasacti='",l_rbs.rbsacti,"'",
                      " WHERE ras01='",l_rbs.rbs01,"'",
                      "   AND ras02='",l_rbs.rbs02,"'",
                      "   AND ras03='2'",
                      "   AND ras04='",l_rbs.rbs07,"'",
                      "   AND ras05='",l_rbs.rbs08,"'",
                      "   AND ras06='",l_rbs.rbs09,"'",
                      "   AND rasplant='",l_rbs.rbsplant,"'"
            TRY                        #FUN-AB0033 add          
               CALL cl_replace_sqldb(l_sql) RETURNING l_sql
               CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
               PREPARE t403sub_upd_ras FROM l_sql
               EXECUTE t403sub_upd_ras
            CATCH                        #FUN-AB0033 add
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
                  CALL s_errmsg('upd','','UPDATE ras_file:',SQLCA.sqlcode,1)
                  LET g_success='N'
                  RETURN
               END IF
            END TRY                        #FUN-AB0033 add
         ELSE
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_plant,'ras_file'),
                        "(ras01,ras02,ras03,ras04,ras05,ras06,ras07,ras08,ras09,rasacti,raslegal,rasplant)",   #FUN-BC0078 add ras09
                        " VALUES('",l_rbs.rbs01,"','",l_rbs.rbs02,"','2','",l_rbs.rbs07,"',",
                        "       '",l_rbs.rbs08,"','",l_rbs.rbs09,"','",l_rbs.rbs10,"','",l_rbs.rbs11,"','",l_rbs.rbs12,"',",  #FUN-BC0078 add rbs12
                        "       '",l_rbs.rbsacti,"','",l_rbs.rbslegal,"','",l_rbs.rbsplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_ins_ras FROM l_sql
            EXECUTE t403sub_ins_ras
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO ras_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF 
         END IF
      END FOREACH
END FUNCTION

FUNCTION  t403sub_repeat()
 DEFINE l_rae  RECORD LIKE rae_file.*
 DEFINE l_raf03   LIKE raf_file.raf03
  
   LET l_sql="SELECT raf03,rae_file.* FROM ",cl_get_target_table(l_plant,'rae_file'),
             "  LEFT OUTER JOIN ",cl_get_target_table(l_plant,'raf_file'),
             "    ON ( rae01=raf01 AND rae02=raf02 AND raeplant=rafplant)",
             " WHERE rae01='",l_rbe.rbe01,"'",
             "   AND rae02='",l_rbe.rbe02,"'",
             "   AND raeplant='",l_rbe.rbeplant,"'"
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql
   CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
   PREPARE t403sub_chk_rae FROM l_sql
   DECLARE rae_cs_rae CURSOR FOR t403sub_chk_rae
   FOREACH rae_cs_rae INTO l_raf03,l_rae.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('sel','','CHECK rae_file:',SQLCA.sqlcode,1)
         LET g_success='N'
         RETURN
      END IF
      #CALL t303sub_chk('2',l_plant,l_rae.rae01,l_rae.rae02,l_raf03,l_rae.rae04,l_rae.rae05,l_rae.rae06,l_rae.rae07)   #FUN-AB0033 mark      
   END FOREACH   
END FUNCTION
#FUN-A80104

#FUN-BC0078 add START
FUNCTION  t403sub_rak_upd()
DEFINE l_rbk   RECORD LIKE rbk_file.*

   LET l_sql=" SELECT * FROM ",cl_get_target_table(l_plant,'rbk_file'),
             "  WHERE rbk01='",l_rbe.rbe01,"'",
             "    AND rbk02='",l_rbe.rbe02,"'",
             "    AND rbk03='",l_rbe.rbe03,"'",
             "    AND rbk05='2' ",
             "    AND rbkplant='",l_rbe.rbeplant,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
      PREPARE t403sub_sel_rbk FROM l_sql
      DECLARE t403sub_sel_rbk_cs CURSOR FOR t403sub_sel_rbk
      FOREACH t403sub_sel_rbk_cs INTO l_rbk.*
         IF cl_null(l_rbk.rbk14) THEN LET l_rbk.rbk14 = ' ' END IF
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rak_file'),
                   " WHERE rak01='",l_rbk.rbk01,"'",
                   "   AND rak02='",l_rbk.rbk02,"'",
                   "   AND rak03='2'",
                   "   AND rak04='",l_rbk.rbk07,"'",
                   "   AND rak05='",l_rbk.rbk08,"'",
                   "   AND rakplant='",l_rbk.rbkplant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql
         CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
         PREPARE t403sub_sel_rak FROM l_sql
         EXECUTE t403sub_sel_rak INTO l_n
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
                      "   AND rak03='2' ",
                     #"   AND rak04=",l_rbk.rbk07,,"'",  #FUN-BC0126 mark
                     #"   AND rak05='",l_rbk.rbk08,"'",  #FUN-BC0126 mar
                      "   AND rak05=",l_rbk.rbk08,    #FUN-BC0126 add
                      "   AND rakplant='",l_rbk.rbkplant,"'"
            TRY                 #NO.MOD-AC0176
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_upd_rak FROM l_sql
            EXECUTE t403sub_upd_rak
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
                        "VALUES('",l_rbk.rbk01,"','",l_rbk.rbk02,"','2',",
                        "       '",l_rbk.rbk07,"','",l_rbk.rbk08,"','",l_rbk.rbk09,"',",
                        "       '",l_rbk.rbk10,"','",l_rbk.rbk11,"','",l_rbk.rbk12,"',",
                        "       '",l_rbk.rbk13,"','",l_rbk.rbk14,"',",
                        "       '",l_rbk.rbkacti,"','",l_rbk.rbklegal,"','",l_rbk.rbkplant,"')"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql
            CALL cl_parse_qry_sql(l_sql, l_plant) RETURNING l_sql
            PREPARE t403sub_ins_rak FROM l_sql
            EXECUTE t403sub_ins_rak
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
               CALL s_errmsg('ins','','INSERT INTO rak_file:',SQLCA.sqlcode,1)
               LET g_success = 'N'
               RETURN
            END IF
         END IF

      END FOREACH
END FUNCTION

#FUN-BC0078 add END


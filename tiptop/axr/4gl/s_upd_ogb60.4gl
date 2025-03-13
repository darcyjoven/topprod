# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Descripton.....: 出貨:發票刪除/作廢/開立時,更新出貨單單身ogb60的值
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/28 By hongmei 欄位類型轉換
# Modify.........: No.TQC-6B0151 06/12/08 By Smapmin 數量應抓取計價數量
# Modify.........: No.MOD-810062 08/01/31 By Smapmin 可能於必確認時就開發票,故不可加上已確認的條件
# Modify.........: No.TQC-860003 08/06/03 By lumx    修改銷退單的已開折讓數量
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整

DATABASE ds 
 
GLOBALS "../../config/top.global"
DEFINE tot     	   LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6)  
 
FUNCTION s_upd_ogb60(p_oma01)
  DEFINE p_oma01   LIKE oma_file.oma01,
         l_oma     RECORD LIKE oma_file.*,
         l_omb     RECORD LIKE omb_file.*,
         l_ogb     RECORD LIKE ogb_file.*,
         l_ohb     RECORD LIKE ohb_file.*     #TQC-860003
  DEFINE g_sql     STRING                     #FUN-A60056 
  WHENEVER ERROR CONTINUE
  IF cl_null(p_oma01) THEN RETURN END IF
  
  SELECT * INTO l_oma.* FROM oma_file WHERE oma01=p_oma01
  IF STATUS THEN 
#    CALL cl_err('sel oma:',STATUS,1)    #No.FUN-660116
     CALL cl_err3("sel","oma_file",p_oma01,"",STATUS,"","sel oma:",1)    #No.FUN-660116
     RETURN 
   END IF
  IF l_oma.oma02<=g_ooz.ooz09 THEN CALL cl_err('','axr-164',0) RETURN END IF
  IF l_oma.oma00 <> '12' THEN RETURN END IF
  
  DECLARE omb_curs CURSOR FOR 
     SELECT * FROM omb_file WHERE omb01 = p_oma01
  FOREACH omb_curs INTO l_omb.*
      IF NOT cl_null(l_omb.omb31) AND NOT cl_null(l_omb.omb32) THEN
         SELECT SUM(omb12) INTO tot FROM omb_file, oma_file
          WHERE omb31=l_omb.omb31 AND omb32=l_omb.omb32
            #AND omb01=oma01 AND omaconf='Y' AND omavoid='N'    #MOD-810062
            AND omb01=oma01 AND omavoid='N'    #MOD-810062
            AND oma00=l_oma.oma00
            AND oma10 IS NOT NULL AND oma10 != ' '
         IF cl_null(tot) THEN LET tot = 0 END IF
         IF l_omb.omb38 != 3 THEN   #TQC-860003
           #FUN-A60056--mod--str--
           #SELECT * INTO l_ogb.* FROM ogb_file
           # WHERE ogb01 = l_omb.omb31 AND ogb03 = l_omb.omb32
            LET g_sql = "SELECT * FROM ",cl_get_target_table(l_omb.omb44,'ogb_file'),
                        " WHERE ogb01 = '",l_omb.omb31,"' AND ogb03 = '",l_omb.omb32,"'"  
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omb.omb44) RETURNING g_sql
            PREPARE sel_ogb FROM g_sql 
            EXECUTE sel_ogb INTO l_ogb.*
           #FUN-A60056--mod--end
            IF STATUS THEN 
#              CALL cl_err('s_upd_ogb60:sel ogb',STATUS,1)   #No.FUN-660116
               CALL cl_err3("sel","ogb_file",l_omb.omb31,l_omb.omb32,STATUS,"","s_upd_ogb60:sel ogb",1)    #No.FUN-660116
               LET g_success = 'N' RETURN
            END IF
            #-----TQC-6B0151--------- 
            #IF cl_null(l_ogb.ogb12) THEN LET l_ogb.ogb12 = 0 END IF
            #IF tot > l_ogb.ogb12 THEN	
            #   CALL cl_err('s_upd_ogb60:omb12>ogb12','axr-174',1)
            IF cl_null(l_ogb.ogb917) THEN LET l_ogb.ogb917 = 0 END IF
            IF tot > l_ogb.ogb917 THEN	
               CALL cl_err('s_upd_ogb60:omb12>ogb917','axr-174',1)
            #-----END TQC-6B0151-----
               LET g_success = 'N' RETURN
            END IF
           #FUN-A60056--mod--str--
           #UPDATE ogb_file SET ogb60= tot
           # WHERE ogb01 = l_omb.omb31 AND ogb03 = l_omb.omb32
            LET g_sql = "UPDATE ",cl_get_target_table(l_omb.omb44,'ogb_file'),
                        "   SET ogb60= '",tot,"'",
                        " WHERE ogb01 = '",l_omb.omb31,"' AND ogb03 = '",l_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omb.omb44) RETURNING g_sql
            PREPARE upd_ogb60 FROM g_sql
            EXECUTE upd_ogb60
           #FUN-A60056--mod--end
            IF STATUS THEN
#              CALL cl_err('upd ogb60',STATUS,1)    #No.FUN-660116
               CALL cl_err3("upd","ogb_file",l_omb.omb31,l_omb.omb32,STATUS,"","upd ogb60",1)    #No.FUN-660116
               LET g_success = 'N' 
               RETURN
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err('upd ogb60','axr-134',1) LET g_success = 'N' RETURN
            END IF
        #TQC-860003---begin--
        ELSE
           #FUN-A60056--mod--str--
           #SELECT * INTO l_ohb.* FROM ohb_file
           # WHERE ohb01 = l_omb.omb31 AND ohb03 = l_omb.omb32
            LET g_sql = "SELECT * FROM ",cl_get_target_table(l_omb.omb44,'ohb_file'),
                        " WHERE ohb01 = '",l_omb.omb31,"'",
                        "   AND ohb03 = '",l_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omb.omb44) RETURNING g_sql
            PREPARE sel_ohb FROM g_sql
            EXECUTE sel_ohb INTO l_ohb.*
           #FUN-A60056--mod--end
            IF STATUS THEN 
               CALL cl_err3("sel","ohb_file",l_omb.omb31,l_omb.omb32,STATUS,"","s_upd_ogb60:sel ogb",1)    #No.FUN-660116
               LET g_success = 'N' RETURN
            END IF
            IF cl_null(l_ohb.ohb917) THEN LET l_ohb.ohb917 = 0 END IF
            IF tot > l_ohb.ohb917 THEN	
               CALL cl_err('s_upd_ogb60:omb12>ohb917','axr-174',1)
               LET g_success = 'N' RETURN
            END IF
           #FUN-A60056--mod--str--
           #UPDATE ohb_file SET ohb60= abs(tot)
           # WHERE ohb01 = l_omb.omb31 AND ohb03 = l_omb.omb32
            LET g_sql = "UPDATE ",cl_get_target_table(l_omb.omb44,'ohb_file'),
                        "   SET ohb60 = abs('",tot,"')",
                        " WHERE ohb01 = '",l_omb.omb31,"' AND ohb03 = '",l_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_omb.omb44) RETURNING g_sql
            PREPARE upd_ohb FROM g_sql
            EXECUTE upd_ohb 
           #FUN-A60056--mod--end
            IF STATUS THEN
               CALL cl_err3("upd","ohb_file",l_omb.omb31,l_omb.omb32,STATUS,"","upd ohb60",1)    #No.FUN-660116
               LET g_success = 'N' 
               RETURN
            END IF
            IF SQLCA.SQLERRD[3]=0 THEN
               CALL cl_err('upd ohb60','axr-134',1) LET g_success = 'N' RETURN
            END IF
         END IF
        #TQC-860003---begin--
 
      END IF
  END FOREACH 
 
END FUNCTION

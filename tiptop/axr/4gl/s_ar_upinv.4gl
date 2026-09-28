# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Modify ........: No.FUN-4B0079 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-530701 05/03/28 By Nicola 語法錯誤
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.MOD-6C0033 06/12/07 By Smapmin 銷退數量抓取計價數量
# Modify.........: No.TQC-6B0151 06/12/08 By Smapmin 數量應抓取計價數量
# Modify.........: No.FUN-710050 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-760035 07/06/13 By Smapmin 修改update oga54
# Modify.........: NO.MOD-760127 07/06/27 By Smapmin 取消update oha50
# Modify.........: No.MOD-850101 08/07/14 By wujie   調整對單據類型的判斷
# Modify.........: No.TQC-860003 08/07/22 By lumx 調整回寫ohb60為負數的情況`
# Modify.........: No.MOD-8A0224 08/10/30 By Sarah UPDATE oga54不需累加之前的oga54,直接將最後抓到的金額寫入
# Modify.........: No.MOD-910089 09/01/09 By Nicola s_ar_upinv 將計算 tot 的 SQL mark AND omb32=b_omb.omb32 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying 改為可從同法人下不同DB抓資料
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 
# Modify.........: No.FUN-A60056 10/07/02 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No:CHI-A70015 10/07/06 By Nicola 需考慮無訂單出貨
# Modify.........: No.MOD-B80353 11/09/01 By Polly 將omaconf = 'Y'判斷拿掉 
# Modify.........: No.MOD-C10061 12/01/08 By Polly 回寫oga54時，需判斷是否為內含稅
# Modify.........: No.MOD-C30842 12/03/23 By Polly ooz10/ooz16 都需要回寫至出貨單
# Modify.........: No.MOD-D20026 13/02/05 By apo 回寫ohb14/ohb14t時,加上abs讓金額為正值後再update

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_oma   RECORD LIKE oma_file.*
DEFINE b_omb   RECORD LIKE omb_file.*
DEFINE g_oga   RECORD LIKE oga_file.*
DEFINE g_ogb   RECORD LIKE ogb_file.*
DEFINE g_ohb   RECORD LIKE ohb_file.*
DEFINE g_oma01        LIKE oma_file.oma01        #No.FUN-680123 VARCHAR(16) #No.FUN-550071
DEFINE tot,tot1,tot2  LIKE type_file.num20_6     #No.FUN-680123 DEC(20,6) #FUN-4C0013
DEFINE l_dbs          LIKE type_file.chr21       #No.FUN-9C0014 Add
DEFINE g_sql          LIKE type_file.chr1000     #No.FUN-9C0014 Add
DEFINE l_plant        LIKE azp_file.azp01        #No.FUN-A50102
 
FUNCTION s_ar_upinv(p_oma01,p_plant)             #No.FUN-9C0014 Add p_dbs #No.FUN-A10104
  DEFINE p_flag       LIKE type_file.chr1        # 'y':確認  'z':取消確認  #No.FUN-680123 VARCHAR(1)
  DEFINE p_oma01      LIKE oma_file.oma01        #No.FUN-680123 VARCHAR(16) #No.FUN-550071#
 #DEFINE p_dbs        LIKE type_file.chr21       #No.FUN-9C0014 Add #No.FUN-A10104
  DEFINE p_plant      LIKE azp_file.azp01        #No.FUN-A10104
 
  WHENEVER ERROR CONTINUE
  IF cl_null(p_oma01) THEN RETURN 1 END IF
  LET g_oma01=p_oma01
  LET l_plant = p_plant     #FUN-A50102
#No.FUN-A10104 -BEGIN-----
# LET l_dbs = p_dbs                      #No.FUN-9C0014 Add
  IF cl_null(p_plant) THEN
     LET l_dbs = ''
  ELSE
     LET g_plant_new = p_plant
     CALL s_gettrandbs()
     LET l_dbs = g_dbs_tra
  END IF
#No.FUN-A10104 -END-------
  SELECT * INTO g_oma.* FROM oma_file WHERE oma01=g_oma01
  IF STATUS THEN 
#    CALL cl_err('sel oma:',STATUS,1)    #No.FUN-660116
#    CALL cl_err3("sel","oma_file",g_oma01,"",STATUS,"","sel oma:",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050-------begin
     IF g_bgerr THEN
        CALL s_errmsg('oma01',g_oma01,'sel oma:',STATUS,1)
     ELSE
        CALL cl_err3("sel","oma_file",g_oma01,"",STATUS,"","sel oma:",1)
     END IF
#NO.FUN-710050-------end
     RETURN 1 
  END IF
  IF g_oma.oma02<=g_ooz.ooz09 THEN CALL cl_err('','axr-164',0) RETURN 1 END IF
 
  DECLARE omb_curs CURSOR FOR 
     SELECT * FROM omb_file WHERE omb01 = ?
  FOREACH omb_curs USING g_oma01 INTO b_omb.*
     CALL s_ar_update()
  END FOREACH 
 
  IF g_success='N'
     THEN RETURN 1
     ELSE RETURN 0
  END IF
END FUNCTION
 
FUNCTION s_ar_update() 				#更新出貨單/銷退單身
   DEFINE l_oea61   LIKE oea_file.oea61    #No:FUN-A50103
   DEFINE l_oea1008 LIKE oea_file.oea1008  #No:FUN-A50103
   DEFINE l_oea261  LIKE oea_file.oea261   #No:FUN-A50103
   DEFINE l_oea262  LIKE oea_file.oea262   #No:FUN-A50103
   DEFINE l_oea263  LIKE oea_file.oea263   #No:FUN-A50103
   DEFINE l_oga RECORD  LIKE oga_file.*    #MOD-C30842 add
   DEFINE l_ogb RECORD  LIKE ogb_file.*    #MOD-C30842 add

#  IF g_oma.oma00 = '12' AND NOT cl_null(b_omb.omb31) THEN
   IF (g_oma.oma00 = '12' AND b_omb.omb38<>'3') AND NOT cl_null(b_omb.omb31) THEN    #No.MOD-850101  
      SELECT SUM(omb12) INTO tot FROM omb_file, oma_file
          WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
           #AND omb01=oma01 AND omaconf='Y' AND omavoid='N'     #No.MOD-B80353 mark
            AND omb01=oma01 AND omavoid='N'                     #No.MOD-B80353 add 
            AND oma00=g_oma.oma00
            AND oma10 IS NOT NULL AND oma10 != ' '# 98.08.10 Star 已開發票數量 
      IF cl_null(tot) THEN LET tot = 0 END IF
   #No.FUN-9C0014 BEGIN -----
   #  SELECT * INTO g_ogb.* FROM ogb_file
   #   WHERE ogb01 = b_omb.omb31 AND ogb03 = b_omb.omb32
      IF cl_null(l_dbs) THEN
#FUN-A60056--mod--str--
#        SELECT * INTO g_ogb.* FROM ogb_file
#         WHERE ogb01 = b_omb.omb31 AND ogb03 = b_omb.omb32
         LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                     " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ogb FROM g_sql
         EXECUTE sel_ogb INTO g_ogb.*
#FUN-A60056--mod--end
      ELSE
         #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"ogb_file ",
         LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'ogb_file'), #FUN-A50102
                     " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
        	 CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102            
         PREPARE sel_ogb_pre01 FROM g_sql
         EXECUTE sel_ogb_pre01 INTO g_ogb.*
      END IF
   #No.FUN-9C0014 END -----
      IF STATUS THEN 
#        CALL cl_err('s_ar_upinv:sel ogb',STATUS,1)   #No.FUN-660116
#        CALL cl_err3("sel","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050------begin
         IF g_bgerr THEN
            CALL s_errmsg('','','s_ar_upinv:sel ogb',STATUS,1)
         ELSE
            CALL cl_err3("sel","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)
         END IF
#NO.FUN-710050------end
         LET g_success = 'N' RETURN
      END IF
      #-----TQC-6B0151-----
      #IF cl_null(g_ogb.ogb12) THEN LET g_ogb.ogb12 = 0 END IF
      #IF tot > g_ogb.ogb12 THEN		# 發票數量大於出貨單數量
      #   CALL cl_err('s_ar_upinv:omb12>ogb12','axr-174',1)
      IF cl_null(g_ogb.ogb917) THEN LET g_ogb.ogb917 = 0 END IF
      IF tot > g_ogb.ogb917 THEN		# 發票數量大於出貨單數量
#        CALL cl_err('s_ar_upinv:omb12>ogb917','axr-174',1)           #NO.FUN-710050
#NO.FUN-710050------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','s_ar_upinv:omb12>ogb917','axr-174',1)
      ELSE
         CALL cl_err('s_ar_upinv:omb12>ogb917','axr-174',1)
     END IF
#NO.FUN-710050------end
      #-----END TQC-6B0151-----
         LET g_success = 'N' RETURN
      END IF

      #-----No:FUN-A50103-----
      SELECT oea61,oea1008,oea261,oea262,oea263
        INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
        FROM oea_file
       WHERE oea01 = g_oga.oga16
      #-----No:FUN-A50103 END-----

      #-----No:CHI-A70015-----
      IF STATUS THEN     #找不到訂單，表無訂單出貨
         LET l_oea61 = 100
         LET l_oea1008 = 100
         LET l_oea261 = 0
         LET l_oea262 = 100
         LET l_oea263 = 0
      END IF
      #-----No:CHI-A70015 END-----

      IF g_ooz.ooz16='Y' THEN 	# 發票確認時將發票單價更新回出貨單(Y/N)
         LET g_ogb.ogb13 = b_omb.omb13
### 98/07/24 modify by connie
#        LET g_ogb.ogb14 = b_omb.omb14  * g_ogb.ogb12  #/ b_omb.omb12
#        LET g_ogb.ogb14t= b_omb.omb14t * g_ogb.ogb12  #/ b_omb.omb12
         LET g_ogb.ogb14 = b_omb.omb14  
         LET g_ogb.ogb14t= b_omb.omb14t 
      END IF
      IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #FUN-A60056--mod--str--
        #UPDATE ogb_file SET
        #       ogb13=g_ogb.ogb13,
        #       ogb14=g_ogb.ogb14,
        #       ogb14t=g_ogb.ogb14t,
        #       ogb60= tot
        # WHERE ogb01 = b_omb.omb31 AND ogb03 = b_omb.omb32
         LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                     "   SET ogb13='",g_ogb.ogb13,"',",
                     "       ogb14='",g_ogb.ogb14,"',",
                     "       ogb14t='",g_ogb.ogb14t,"',",
                     "       ogb60= '",tot,"'",
                     " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
        CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
        CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql  
        PREPARE upd_ogb13 FROM g_sql
        EXECUTE upd_ogb13
        #FUN-A60056--mod--end
      #N#.FUN-9C0014 BEGIN -----
      ELSE
         #LET g_sql = "UPDATE ",l_dbs CLIPPED,"ogb_file",
         LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'ogb_file'), #FUN-A50102
                     "   SET ogb13='",g_ogb.ogb13,"',",
                     "       ogb14='",g_ogb.ogb14,"',",
                     "       ogb14t='",g_ogb.ogb14t,"',",
                     "       ogb60= '",tot,"'",
                     " WHERE ogb01 = '",b_omb.omb31,"' AND ogb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
         PREPARE upd_ogb_pre02 FROM g_sql
         EXECUTE upd_ogb_pre02
      END IF
      #No.FUN-9C0014 END -------
      IF STATUS THEN
#        CALL cl_err('upd ogb60',STATUS,1)     #No.FUN-660116
#        CALL cl_err3("sel","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--------begin
         IF g_bgerr THEN
            CALL s_errmsg('','','upd ogb60',STATUS,1)
         ELSE
            CALL cl_err3("sel","ogb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)
         END IF
#NO.FUN-710050--------end
         LET g_success = 'N' 
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd ogb60','axr-134',1) LET g_success = 'N' RETURN              #NO.FUN-710050
#NO.FUN-710050--------begin
         IF g_bgerr THEN
            CALL s_errmsg('','','upd ogb60','axr-134',1)
         ELSE
            CALL cl_err('upd ogb60','axr-134',1) 
         END IF
#NO.FUN-710050-------end
         LET g_success = 'N' RETURN
      END IF
      IF g_ooz.ooz16='Y' THEN 	# 發票確認時將發票金額更新回出貨單頭
         IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
        #FUN-A60056--mod--str--
        #SELECT * INTO g_oga.* FROM oga_file WHERE oga01 = b_omb.omb31
        #SELECT SUM(ogb14) INTO g_oga.oga50 FROM ogb_file
        #                                    WHERE ogb01 = b_omb.omb31
         LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'oga_file'),
                     " WHERE oga01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_oga FROM g_sql
         EXECUTE sel_oga INTO g_oga.*

         LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                     " WHERE ogb01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_sum_ogb14 FROM g_sql
         EXECUTE sel_sum_ogb14 INTO g_oga.oga50
        #FUN-A60056--mod--end
      #No.FUN-9C0014 BEGIN -----
         ELSE
            #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"oga_file ",
            LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102
                        " WHERE oga01 = '",b_omb.omb31,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
            PREPARE sel_oga_pre03 FROM g_sql
            EXECUTE sel_oga_pre03 INTO g_oga.*
            #LET g_sql = "SELECT SUM(ogb14) FROM ",l_dbs CLIPPED,"ogb_file",
            LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(l_plant,'ogb_file'), #FUN-A50102
                        " WHERE ogb01 = '",b_omb.omb31,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102            
            PREPARE sel_ogb_pre04 FROM g_sql
            EXECUTE sel_ogb_pre04 INTO g_oga.oga50
         END IF
      #No.FUN-9C0014 END -------
         IF cl_null(g_oga.oga50) THEN LET g_oga.oga50 = 0 END IF
         LET g_oga.oga21 = g_oma.oma21
         LET g_oga.oga211= g_oma.oma211
         LET g_oga.oga212= g_oma.oma212
         LET g_oga.oga213= g_oma.oma213
         LET g_oga.oga23 = g_oma.oma23
         LET g_oga.oga24 = g_oma.oma24
         #-----No:FUN-A50103-----
         IF g_oga.oga213 = 'Y' THEN
            LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea1008
            LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea1008
         ELSE
            LET g_oga.oga52 = g_oga.oga50 * l_oea261 / l_oea61
            LET g_oga.oga53 = g_oga.oga50 * (l_oea262+l_oea263) / l_oea61
         END IF
        #LET g_oga.oga52 = g_oga.oga50 * g_oga.oga161/100
        #LET g_oga.oga53 = g_oga.oga50 * (g_oga.oga162+g_oga.oga163)/100
         #-----No:FUN-A50103 END-----

      #No.FUN-9C0014 BEGIN -----
      #  UPDATE oga_file SET *=g_oga.* WHERE oga01 = g_oga.oga01
         IF cl_null(l_dbs) THEN
           #FUN-A60056--mod--str--
           #UPDATE oga_file SET *=g_oga.* WHERE oga01 = g_oga.oga01
            LET g_sql = "UPDATE ",cl_get_target_table(g_oga.ogaplant,'oga_file'),
                        "   SET oga50 = ?,oga21 = ?,oga211 = ?,",
                        "       oga212= ?,oga213= ?,oga23  = ?,",
                        "       oga24 = ?,oga52 = ?,oga53  = ? ",
                        " WHERE oga01 = '",g_oga.oga01,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
            CALL cl_parse_qry_sql(g_sql,g_oga.ogaplant) RETURNING g_sql
            PREPARE upd_oga50 FROM g_sql
            EXECUTE upd_oga50 USING g_oga.oga50,g_oga.oga21,g_oga.oga211,
                                    g_oga.oga212,g_oga.oga213,g_oga.oga23,
                                    g_oga.oga24,g_oga.oga52,g_oga.oga53
           #FUN-A60056--mod--end
         ELSE
            #LET g_sql = "UPDATE ",l_dbs CLIPPED,"oga_file ",
            LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102
                        "   SET oga50 = ?,oga21 = ?,oga211 = ?,",
                        "       oga212= ?,oga213= ?,oga23  = ?,",
                        "       oga24 = ?,oga52 = ?,oga53  = ? ",
                        " WHERE oga01 = '",g_oga.oga01,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		    CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102              
            PREPARE upd_oga_pre05 FROM g_sql
            EXECUTE upd_oga_pre05 USING g_oga.oga50,g_oga.oga21,g_oga.oga211,
                                        g_oga.oga212,g_oga.oga213,g_oga.oga23,
                                        g_oga.oga24,g_oga.oga52,g_oga.oga53
         END IF
      #No.FUN-9C0014 END -------
        #IF STATUS THEN 
         IF STATUS OR SQLCA.SQLCODE THEN 
#           CALL cl_err('upd oga50',SQLCA.SQLCODE,1)    #No.FUN-660116
#           CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","upd oga50",1)    #No.FUN-660116  #NO.FUN-710050
#NO.FUN-710050-------begin
         IF g_bgerr THEN   
            CALL s_errmsg('oga01',g_oga.oga01,'upd oga50',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err3("sel","oga_file",g_oga.oga01,"",SQLCA.sqlcode,"","upd oga50",1)
         END IF
#NO.FUN-710050-------end 
         END IF
      END IF
     #-----------------------------MOD-C30842------------------------start
      IF g_ooz.ooz16 ='Y' AND g_oga.oga09 = '8' THEN    #出貨單走簽收流程
        #發票確認時將發票單價更新回出貨單
         IF cl_null(l_dbs) THEN
            LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        " WHERE ogb01 = '",g_oga.oga011,"' AND ogb03 = '",b_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_ogb2 FROM g_sql
            EXECUTE sel_ogb2 INTO l_ogb.*
         ELSE
            LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'ogb_file'), #FUN-A50102
                        " WHERE ogb01 = '",g_oga.oga011,"' AND ogb03 = '",b_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
            PREPARE sel_ogb2_pre01 FROM g_sql
            EXECUTE sel_ogb2_pre01 INTO l_ogb.*
         END IF
         IF STATUS THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','s_ar_upinv:sel ogb',STATUS,1)
            ELSE
               CALL cl_err3("sel","ogb_file",g_oga.oga011,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)
            END IF
            LET g_success = 'N' RETURN
         END IF
         IF cl_null(l_ogb.ogb917) THEN LET l_ogb.ogb917 = 0 END IF
         IF tot > l_ogb.ogb917 THEN                # 發票數量大於出貨單數量
            IF g_bgerr THEN
               CALL s_errmsg('','','s_ar_upinv:omb12>ogb917','axr-174',1)
            ELSE
               CALL cl_err('s_ar_upinv:omb12>ogb917','axr-174',1)
            END IF
            LET g_success = 'N' RETURN
         END IF

         SELECT oea61,oea1008,oea261,oea262,oea263
           INTO l_oea61,l_oea1008,l_oea261,l_oea262,l_oea263
           FROM oea_file
          WHERE oea01 = l_oga.oga16

         IF STATUS THEN     #找不到訂單，表無訂單出貨
            LET l_oea61 = 100
            LET l_oea1008 = 100
            LET l_oea261 = 0
            LET l_oea262 = 100
            LET l_oea263 = 0
         END IF
         LET l_ogb.ogb13 = b_omb.omb13
         LET l_ogb.ogb14 = b_omb.omb14
         LET l_ogb.ogb14t= b_omb.omb14t

         IF cl_null(l_dbs) THEN
            LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        "   SET ogb13='",l_ogb.ogb13,"',",
                        "       ogb14='",l_ogb.ogb14,"',",
                        "       ogb14t='",l_ogb.ogb14t,"',",
                        "       ogb60= '",tot,"'",
                        " WHERE ogb01 = '",g_oga.oga011,"' AND ogb03 = '",b_omb.omb32,"'"
           CALL cl_replace_sqldb(g_sql) RETURNING g_sql
           CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
           PREPARE upd2_ogb13 FROM g_sql
           EXECUTE upd2_ogb13
         ELSE
            LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'ogb_file'),
                        "   SET ogb13='",l_ogb.ogb13,"',",
                        "       ogb14='",l_ogb.ogb14,"',",
                        "       ogb14t='",l_ogb.ogb14t,"',",
                        "       ogb60= '",tot,"'",
                        " WHERE ogb01 = '",g_oga.oga011,"' AND ogb03 = '",b_omb.omb32,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
            PREPARE upd_ogb2_pre02 FROM g_sql
            EXECUTE upd_ogb2_pre02
         END IF
         IF STATUS THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','upd ogb60',STATUS,1)
            ELSE
               CALL cl_err3("sel","ogb_file",g_oga.oga011,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)
            END IF
            LET g_success = 'N'
            RETURN
         END IF
         IF SQLCA.SQLERRD[3]=0 THEN
            IF g_bgerr THEN
               CALL s_errmsg('','','upd ogb60','axr-134',1)
            ELSE
               CALL cl_err('upd ogb60','axr-134',1)
            END IF
            LET g_success = 'N' RETURN
         END IF
        #發票確認時將發票金額更新回出貨單頭
         IF cl_null(l_dbs) THEN
            LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'oga_file'),
                        " WHERE oga01 = '",g_oga.oga011,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel2_oga FROM g_sql
            EXECUTE sel2_oga INTO l_oga.*

            LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(b_omb.omb44,'ogb_file'),
                        " WHERE ogb01 = '",g_oga.oga011,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
            PREPARE sel_sum2_ogb14 FROM g_sql
            EXECUTE sel_sum2_ogb14 INTO l_oga.oga50
         ELSE
            LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'oga_file'),
                        " WHERE oga01 = '",g_oga.oga011,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
            PREPARE sel_oga2_pre03 FROM g_sql
            EXECUTE sel_oga2_pre03 INTO l_oga.*

            LET g_sql = "SELECT SUM(ogb14) FROM ",cl_get_target_table(l_plant,'ogb_file'),
                        " WHERE ogb01 = '",g_oga.oga011,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
            PREPARE sel_ogb2_pre04 FROM g_sql
            EXECUTE sel_ogb2_pre04 INTO l_oga.oga50
         END IF
         IF cl_null(l_oga.oga50) THEN LET l_oga.oga50 = 0 END IF
         LET l_oga.oga21 = g_oma.oma21
         LET l_oga.oga211= g_oma.oma211
         LET l_oga.oga212= g_oma.oma212
         LET l_oga.oga213= g_oma.oma213
         LET l_oga.oga23 = g_oma.oma23
         LET l_oga.oga24 = g_oma.oma24
         IF l_oga.oga213 = 'Y' THEN
            LET l_oga.oga52 = l_oga.oga50 * l_oea261 / l_oea1008
            LET l_oga.oga53 = l_oga.oga50 * (l_oea262 + l_oea263) / l_oea1008
         ELSE
            LET l_oga.oga52 = l_oga.oga50 * l_oea261 / l_oea61
            LET l_oga.oga53 = l_oga.oga50 * (l_oea262 + l_oea263) / l_oea61
         END IF

         IF cl_null(l_dbs) THEN
            LET g_sql = "UPDATE ",cl_get_target_table(g_oga.ogaplant,'oga_file'),
                        "   SET oga50 = ?,oga21 = ?,oga211 = ?,",
                        "       oga212= ?,oga213= ?,oga23  = ?,",
                        "       oga24 = ?,oga52 = ?,oga53  = ? ",
                        " WHERE oga01 = '",l_oga.oga01,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,g_oga.ogaplant) RETURNING g_sql
            PREPARE upd2_oga50 FROM g_sql
            EXECUTE upd2_oga50 USING l_oga.oga50,l_oga.oga21,l_oga.oga211,
                                     l_oga.oga212,l_oga.oga213,l_oga.oga23,
                                     l_oga.oga24,l_oga.oga52,l_oga.oga53
         ELSE
            LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102
                        "   SET oga50 = ?,oga21 = ?,oga211 = ?,",
                        "       oga212= ?,oga213= ?,oga23  = ?,",
                        "       oga24 = ?,oga52 = ?,oga53  = ? ",
                        " WHERE oga01 = '",l_oga.oga01,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102
            PREPARE upd_oga2_pre05 FROM g_sql
            EXECUTE upd_oga2_pre05 USING l_oga.oga50,l_oga.oga21,l_oga.oga211,
                                         l_oga.oga212,l_oga.oga213,l_oga.oga23,
                                         l_oga.oga24,l_oga.oga52,l_oga.oga53
         END IF
         IF STATUS OR SQLCA.SQLCODE THEN
            IF g_bgerr THEN
               CALL s_errmsg('oga01',l_oga.oga01,'upd oga50',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err3("sel","oga_file",l_oga.oga01,"",SQLCA.sqlcode,"","upd oga50",1)
            END IF
         END IF
      END IF
     #-----------------------------MOD-C30842--------------------------end
      #未稅金額 * 出貨應收比率
     #SELECT SUM(omb14*oma162/100) INTO tot FROM omb_file, oma_file
      SELECT SUM(omb14) INTO tot FROM omb_file, oma_file    #No:FUN-A50103
       #WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omaconf='Y' AND omavoid='N'   #MOD-760035
        WHERE omb31=b_omb.omb31 AND omb01=oma01 AND omavoid='N'   #MOD-760035
        # AND omb32=b_omb.omb32   #MOD-760035   #No.MOD-910089 Mark
          AND oma00=g_oma.oma00
          AND oma10 IS NOT NULL AND oma10 != ' '#980810Star原幣已開發票未稅金額
      IF cl_null(tot) THEN LET tot = 0 END IF

      IF g_oga.oga213 = 'Y' THEN                                                   #MOD-C10061 add
         LET tot = tot * l_oea262 / l_oea1008                                      #MOD-C10061 add
      ELSE                                                                         #MOD-C10061 add
         LET tot = tot *  l_oea262 / l_oea61    #No:FUN-A50103
      END IF                                                                       #MOD-C10061 add

#     應開發票未稅金額
#     SELECT oga53 INTO tot2 FROM oga_file WHERE oga01 = b_omb.omb31
#     IF cl_null(tot2) THEN LET tot2 = 0 END IF
#     IF tot > tot2 THEN
#        CALL cl_err('tot>oga53','axr-174',1) LET g_success = 'N' RETURN
#     END IF
      #-----97/05/26 modify update發票號碼拿掉,到發票開立再update
    # UPDATE oga_file SET (oga10,oga54) = (g_oma.oma01,tot)
    #        WHERE oga01 = b_omb.omb31
      IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
   #FUN-A60056--mod--str--
   #  UPDATE oga_file SET (oga54) = (tot)   #MOD-760035       #MOD-8A0224 mark回復
   # #UPDATE oga_file SET oga54 = oga54 + tot    #MOD-760035  #MOD-8A0224 mark
   #         WHERE oga01 = b_omb.omb31
      LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oga_file'),
                  "   SET oga54 = '",tot,"'",
                  " WHERE oga01 = '",b_omb.omb31,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
      PREPARE upd_oga54 FROM g_sql
      EXECUTE upd_oga54
   #FUN-A60056--mod--end
    #No.FUN-9C0014 BEGIN -----
      ELSE
         #LET g_sql = "UPDATE ",l_dbs CLIPPED,"oga_file SET oga54 = '",tot,"'",
         LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'oga_file'), #FUN-A50102
                       " SET oga54 = '",tot,"'",
                     " WHERE oga01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102                 
         PREPARE upd_oga_pre06 FROM g_sql
         EXECUTE upd_oga_pre06
      END IF
    #No.FUN-9C0014 END -------
      IF STATUS THEN
#        CALL cl_err('upd oga54',STATUS,1)    #No.FUN-660116
#        CALL cl_err3("upd","oga_file",b_omb.omb31,"",STATUS,"","upd oga54",1)    #No.FUN-660116   #NO.FUN-710050
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         CALL s_errmsg('oga01','b_omb.omb31','upd oga54',STATUS,1)
      ELSE
         CALL cl_err3("upd","oga_file",b_omb.omb31,"",STATUS,"","upd oga54",1)
      END IF
#NO.FUN-710050--------end
         LET g_success = 'N' 
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd oga54','axr-134',1)          #NO.FUN-710050
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','upd oga54','axr-134',1)
      ELSE
         CALL cl_err('upd oga54','axr-134',1)
      END IF
#NO.FUN-710050--------end 
         LET g_success = 'N' RETURN
      END IF
   END IF
#  IF g_oma.oma00 = '21' AND NOT cl_null(b_omb.omb31) THEN
   IF (g_oma.oma00 = '21' OR b_omb.omb38='3') AND NOT cl_null(b_omb.omb31) THEN   #No.MOD-850101
     #---98/07/08 modify 確認時將單價更新回銷退單  
      SELECT SUM(omb12) INTO tot FROM omb_file, oma_file
       WHERE omb31=b_omb.omb31 AND omb32=b_omb.omb32
        #AND omb01=oma01 AND omaconf='Y' AND omavoid='N'      #No.MOD-B80353 mark
         AND omb01=oma01 AND omavoid='N'                      #No.MOD-B80353 add
         AND oma00=g_oma.oma00
      IF cl_null(tot) THEN LET tot = 0 END IF
   #No.FUN-9C0014 BEGIN -----
   #  SELECT * INTO g_ohb.* FROM ohb_file
   #   WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
      IF cl_null(l_dbs) THEN
        #FUN-A60056--mod--str--
        #SELECT * INTO g_ohb.* FROM ohb_file
        # WHERE ohb01 = b_omb.omb31 AND ohb03 = b_omb.omb32
         LET g_sql = "SELECT * FROM ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                     " WHERE ohb01 = '",b_omb.omb31,"'",
                     "   AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
         CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql
         PREPARE sel_ohb FROM  g_sql
         EXECUTE sel_ohb INTO g_ohb.*
        #FUN-A60056--mod--end
      ELSE
         #LET g_sql = "SELECT * FROM ",l_dbs CLIPPED,"ohb_file",
         LET g_sql = "SELECT * FROM ",cl_get_target_table(l_plant,'ohb_file'), #FUN-A50102
                     " WHERE ohb01 = '",b_omb.omb31,"' AND ohb03 = '",b_omb.omb32,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102    
         PREPARE sel_ohb_pre07 FROM g_sql
         EXECUTE sel_ohb_pre07 INTO g_ohb.*
      END IF
   #No.FUN-9C0014 END -------
      IF STATUS THEN 
#        CALL cl_err('s_ar_upinv:sel ogb',STATUS,1)   #No.FUN-660116
#        CALL cl_err3("sel","ohb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050-------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','s_ar_upinv:sel ogb',STATUS,1)
      ELSE
         CALL cl_err3("sel","ohb_file",b_omb.omb31,b_omb.omb32,STATUS,"","s_ar_upinv:sel ogb",1)
      END IF
#NO.FUN-710050-------end   
         LET g_success = 'N' RETURN
      END IF
      #-----MOD-6C0033---------
      #IF cl_null(g_ohb.ohb12) THEN LET g_ohb.ohb12 = 0 END IF
      #IF tot > g_ohb.ohb12 THEN
      #   CALL cl_err('tot>ohb12','axr-174',1) LET g_success = 'N' RETURN
      #END IF
      IF cl_null(g_ohb.ohb917) THEN LET g_ohb.ohb917 = 0 END IF
      IF tot > g_ohb.ohb917 THEN
#        CALL cl_err('tot>ohb917','axr-174',1)             #NO.FUN-710050
#NO.FUN-710050-------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','tot>ohb917','axr-174',1)
      ELSE
         CALL cl_err('tot>ohb917','axr-174',1)
      END IF
#NO.FUN-710050-------end
         LET g_success = 'N' RETURN
      END IF
      #-----END MOD-6C0033-----
      IF g_ooz.ooz16='Y' THEN 	# 發票確認時將發票單價更新回出貨單(Y/N)
         LET g_ohb.ohb13 = b_omb.omb13
 ### 98/08/03 by connie
 #       LET g_ohb.ohb14 = b_omb.omb14  * g_ohb.ohb12  #/ b_omb.omb12
 #       LET g_ohb.ohb14t= b_omb.omb14t * g_ohb.ohb12  #/ b_omb.omb12
         LET g_ohb.ohb13 = b_omb.omb13 
         LET g_ohb.ohb14 = b_omb.omb14  
         LET g_ohb.ohb14t= b_omb.omb14t 
      END IF
      #No.FUN-9C0014 BEGIN -----
       IF cl_null(l_dbs) THEN
#FUN-A60056--mod--str--
#      UPDATE ohb_file SET ohb13 = g_ohb.ohb13,     #No.MOD-530701
#                         ohb14 = g_ohb.ohb14,
#                         ohb14t = g_ohb.ohb14t,
##                         ohb60 = tot                    #TQC-860003
#                         ohb60 = abs(tot)               #TQC-860003
#      WHERE ohb01 = b_omb.omb31
#        AND ohb03 = b_omb.omb32
       LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'ohb_file'),
                   "   SET ohb13 = '",g_ohb.ohb13,"',",
                  #"       ohb14 = '",g_ohb.ohb14,"',",         #MOD-D20026 mark
                   "       ohb14 = abs('",g_ohb.ohb14,"'),",    #MOD-D20026
                  #"       ohb14t = '",g_ohb.ohb14t,"',",       #MOD-D20026 mark
                   "       ohb14t= abs('",g_ohb.ohb14t,"'),",   #MOD-D20026
                   "       ohb60 = abs('",tot,"')",
                   " WHERE ohb01 = '",b_omb.omb31,"'",
                   "   AND ohb03 = '",b_omb.omb32,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql            
       CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql 
       PREPARE upd_ohb13 FROM g_sql
       EXECUTE upd_ohb13
#FUN-A60056--mod--end
       ELSE
          #LET g_sql = "UPDATE ",l_dbs CLIPPED,"ohb_file ",
          LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'ohb_file'), #FUN-A50102
                      "   SET ohb13 = '",g_ohb.ohb13,"',",
                     #"       ohb14 = '",g_ohb.ohb14,"',",       #MOD-D20026 mark
                      "       ohb14 = abs('",g_ohb.ohb14,"'),",  #MOD-D20026
                     #"       ohb14t = '",g_ohb.ohb14t,"',",     #MOD-D20026 mark
                      "       ohb14t= abs('",g_ohb.ohb14t,"'),", #MOD-D20026
                      "       ohb60 = abs('",tot,"')",
                      " WHERE ohb01 = '",b_omb.omb31,"'",
                      "   AND ohb03 = '",b_omb.omb32,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		  CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102   
          PREPARE upd_ohb_pre08 FROM g_sql
          EXECUTE upd_ohb_pre08
       END IF
      #No.FUN-9C0014 END -------
 
      IF STATUS THEN
#        CALL cl_err('upd ogb60',STATUS,1)    #No.FUN-660116
#        CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,STATUS,"","upd ogb60",1)    #No.FUN-660116     #NO.FUN-710050
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','upd ogb60',STATUS,1)
      ELSE
         CALL cl_err3("upd","ohb_file",b_omb.omb31,b_omb.omb32,STATUS,"","upd ogb60",1)
      END IF
#NO.FUN-710050---------end
         LET g_success = 'N'
         RETURN
      END IF
 
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd ogb60','axr-134',1)       #NO.FUN-710050
#NO.FUN-710050--------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','upd ogb60','axr-134',1)    
      ELSE
         CALL cl_err('upd ogb60','axr-134',1)
      END IF
#NO.FUN-710050--------end
         LET g_success = 'N'
         RETURN
      END IF
 
      SELECT SUM(omb14) INTO tot FROM omb_file,oma_file
       WHERE omb31 = b_omb.omb31
         AND omb01 = oma01
        #AND omaconf = 'Y'           #No.MOD-B80353 mark
         AND omavoid = 'N'
         AND oma00 = g_oma.oma00
      IF cl_null(tot) THEN
         LET tot = 0
      END IF
#     SELECT oha53 INTO tot2 FROM oha_file WHERE oha01 = b_omb.omb31
#     IF cl_null(tot2) THEN LET tot2 = 0 END IF
#     IF tot > tot2 THEN
#        CALL cl_err('tot>oha53','axr-174',1) LET g_success = 'N' RETURN
#     END IF
### 98/08/03 add by connie,oha21,oha211,oha212,oha213,oha24
      IF cl_null(l_dbs) THEN    #No.FUN-9C0014 Add
#FUN-A60056--mod--str--
#     UPDATE oha_file SET oha21=g_oma.oma21,   oha211=g_oma.oma211,
#                         oha212=g_oma.oma212, oha213=g_oma.oma213,
#                         oha24=g_oma.oma24,   #oha50=tot,   #MOD-760127
#                         oha54=tot
#     WHERE oha01 = b_omb.omb31
      LET g_sql = "UPDATE ",cl_get_target_table(b_omb.omb44,'oha_file'),
                  "   SET oha21='",g_oma.oma21,"',",
                  "       oha211='",g_oma.oma211,"',",
                  "       oha212='",g_oma.oma212,"',",
                  "       oha213='",g_oma.oma213,"',",
                  "       oha24='",g_oma.oma24,"',",
                  "       oha54='",tot,"'",
                  " WHERE oha01 = '",b_omb.omb31,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql              
      CALL cl_parse_qry_sql(g_sql,b_omb.omb44) RETURNING g_sql 
      PREPARE upd_oha21 FROM g_sql
      EXECUTE upd_oha21
#FUN-A60056--mod--end
     #No.FUN-9C0014 BEGIN -----
      ELSE
         #LET g_sql = "UPDATE ",l_dbs CLIPPED,"oha_file ",
         LET g_sql = "UPDATE ",cl_get_target_table(l_plant,'oha_file'), #FUN-A50102
                     "   SET oha21='",g_oma.oma21,"',",
                     "       oha211='",g_oma.oma211,"',",
                     "       oha212='",g_oma.oma212,"',",
                     "       oha213='",g_oma.oma213,"',",
                     "       oha24='",g_oma.oma24,"',",
                     "       oha54='",tot,"'",
                     " WHERE oha01 = '",b_omb.omb31,"'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
		 CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql #FUN-A50102   
         PREPARE upd_oha_pre09 FROM g_sql
         EXECUTE upd_oha_pre09
      END IF
     #No.FUN-9C0014 END -------
      IF STATUS THEN
#        CALL cl_err('upd oha54',STATUS,1)   #No.FUN-660116
#        CALL cl_err3("upd","oha_file",b_omb.omb31,"",STATUS,"","upd ohb54",1)    #No.FUN-660116  #NO.FUN-710050
#NO.FUN-710050-------begin
      IF g_bgerr THEN
         CALL s_errmsg('oha01','b_omb.omb31','upd oha54',STATUS,1)
      ELSE
         CALL cl_err3("upd","oha_file",b_omb.omb31,"",STATUS,"","upd ohb54",1)
      END IF
#NO.FUN-710050-------end
         LET g_success = 'N' 
         RETURN
      END IF
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('upd oha54','axr-134',1)           #NO.FUN-710050
#NO.FUN-710050------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','upd oha54','axr-134',1) 
      ELSE
         CALL cl_err('upd oha54','axr-134',1)
      END IF
#NO.FUN-710050-------end
         LET g_success = 'N' RETURN
      END IF
   END IF
END FUNCTION

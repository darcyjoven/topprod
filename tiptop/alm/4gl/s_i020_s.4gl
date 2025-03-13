# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: s_i020_confirm/s_i020_unconfirm
# Descriptions...: 支出單審核/取消審核
# Date & Author..: 2009/07/14 By dongbg (FUN-960141)
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0067 09/12/15 By lutingting 沒有修改 只是為了將這支程序重新過單到32區 
# Modify.........: No.FUN-9C0139 09/12/22 By lutingting oow05應為axrt410單別
# Modify.........: No.FUN-9C0168 09/12/29 By lutingting 款別對應銀行改由axri060抓取,卡種對應科目改由axri050抓取
# Modify.........: No.FUN-A40076 10/07/02 By xiaofeizhu 更改ooa37的默認值，如果為Y改為2，N改為1
# Modify.........: No.FUN-A50102 10/07/08 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:FUN-A70118 10/07/29 BY shiwuying xxxlegal賦值
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file 
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_luc      RECORD LIKE luc_file.*
DEFINE g_ooa      RECORD LIKE ooa_file.*
DEFINE g_oob      RECORD LIKE oob_file.*
DEFINE b_oob      RECORD LIKE oob_file.*
DEFINE g_oow      RECORD LIKE oow_file.*
DEFINE g_flag1             LIKE type_file.chr1
DEFINE g_bookno1           LIKE aza_file.aza81
DEFINE g_bookno2           LIKE aza_file.aza82
DEFINE tot,tot1,tot2       LIKE type_file.num20_6
DEFINE tot3                LIKE type_file.num20_6
DEFINE g_sql      LIKE type_file.chr1000
DEFINE un_pay1,un_pay2     LIKE type_file.num20_6
 
# Usage..........: CALL s_i020_confirm(p_no)
# Input Parameter: p_no    支出單號
# Return Code....: g_flag  0:不成功
#                          1:成功            
#                  g_no    AR單號
FUNCTION s_i020_confirm(p_no)
DEFINE p_no       LIKE luc_file.luc01
DEFINE l_lud      RECORD LIKE lud_file.*
DEFINE l_cnt      LIKE type_file.num5
DEFINE l_sql      STRING
 
   SELECT * INTO g_luc.* FROM luc_file WHERE luc01=p_no
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('luc01',p_no,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN 0,''
   END IF
 
 
   SELECT * INTO g_oow.* FROM oow_file WHERE oow00 = '0'
   IF STATUS THEN
      CALL s_errmsg('',p_no,'','alm-998',1)
      LET g_success = 'N'
      RETURN 0,''
   END IF
 
   CALL s_i020_ins_ooa()
   IF g_success = 'N' THEN RETURN 0,'' END IF
 
   CALL s_i020_ins_oob()
   IF g_success = 'N' THEN RETURN 0,'' END IF
  
   CALL s_i020_gl()
   IF g_success = 'N' THEN RETURN 0,'' END IF
   
   CALL s_i020_y_upd()
   IF g_success = 'Y' THEN
      RETURN 1,g_ooa.ooa01
   ELSE
      RETURN 0,''
   END IF
END FUNCTION
 
FUNCTION s_i020_y_upd()                # when g_ooa.ooaconf='N' (Turn to 'Y')
DEFINE l_cnt  LIKE type_file.num5      #No.FUN-680123  SMALLINT
 
   SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
   IF g_ooa.ooa32d != g_ooa.ooa32c THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-203',1) 
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_ooa.ooa02 <= g_ooz.ooz09 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-164',1) 
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_cnt FROM oob_file WHERE oob01 = g_ooa.ooa01
   IF l_cnt = 0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','mfg-009',1) 
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ooz.ooz62='Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM oob_file
       WHERE oob01 = g_ooa.ooa01
         AND oob03 = '2'
         AND oob04 = '1'
         AND (oob06 IS NULL OR oob06 = ' ' OR oob15 IS NULL OR oob15 <= 0 )
 
      IF cl_null(l_cnt) THEN
         LET l_cnt = 0
      END IF
 
      IF l_cnt > 0 THEN
         CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-900',1) 
         LET g_success = 'N'
         RETURN
      END IF
   END IF
 
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt
     FROM oob_file,oma_file
    WHERE ( YEAR(oma02) > YEAR(g_ooa.ooa02)
       OR (YEAR(oma02) = YEAR(g_ooa.ooa02)
      AND MONTH(oma02) > MONTH(g_ooa.ooa02)) )
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = g_ooa.ooa01
 
   IF l_cnt >0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'','axr-371',1) 
      LET g_success = 'N'
      RETURN
   END IF
   IF g_ooy.ooydmy1 = 'Y' THEN
      CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
      IF g_aza.aza63='Y' AND g_success='Y' THEN
         CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
      END IF
      LET g_dbs_new = g_dbs CLIPPED,'.'
      LET g_plant_new = g_plant   #FUN-A50102
   END IF
 
   IF g_success = 'N' THEN RETURN END IF
   CALL s_i020_confirm_y1()
END FUNCTION
 
FUNCTION s_i020_confirm_y1()
   DEFINE n       LIKE type_file.num5      #SMALLINT
   DEFINE l_cnt   LIKE type_file.num5      #SMALLINT
   DEFINE l_flag  LIKE type_file.chr1      #VARCHAR(1)
 
   UPDATE ooa_file SET ooaconf = 'Y' WHERE ooa01 = g_ooa.ooa01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'upd ooaconf',STATUS,1)
      LET g_success = 'N'
      RETURN
   END IF
 
   CALL i020_hu2()
 
   IF g_success = 'N' THEN RETURN END IF
 
   DECLARE i020_y1_c CURSOR FOR
   SELECT * FROM oob_file WHERE oob01 = g_ooa.ooa01 ORDER BY oob02
 
   LET l_cnt = 1
   LET l_flag = '0'
   FOREACH i020_y1_c INTO b_oob.*
      IF STATUS THEN
         CALL s_errmsg('oob01',g_ooa.ooa01,'y1 foreach',STATUS,1)  #NO.FUN-710050
         LET g_success = 'N'
         RETURN
      END IF
 
      IF l_flag = '0' THEN
         LET l_flag = b_oob.oob03
      END IF
 
      IF l_flag != b_oob.oob03 THEN
         LET l_cnt = l_cnt + 1
      END IF
 
      IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
         CALL i020_bu_13('+')
      END IF
      #IF g_ooa.ooa37 = 'Y' THEN   #FUN-A40076 mark
      IF g_ooa.ooa37 = '2' THEN    #FUN-A40076 add
         IF b_oob.oob03 = '2' AND b_oob.oob04 = 'A' THEN
            CALL i020_bu_2A('+')
         END IF
      END IF
      LET l_cnt = l_cnt + 1
   END FOREACH
 
END FUNCTION
 
FUNCTION i020_hu2()            #最近交易日
DEFINE l_occ RECORD LIKE occ_file.*
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   IF STATUS THEN
      CALL s_errmsg('ooc01',g_ooa.ooa03,'s ccc',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=g_ooa.ooa02 END IF
   IF l_occ.occ174 IS NULL OR l_occ.occ174 < g_ooa.ooa02 THEN
      LET l_occ.occ174=g_ooa.ooa02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=g_ooa.ooa03
   IF STATUS THEN
      CALL s_errmsg('ooc01',g_ooa.ooa03,'u ccc',STATUS,1)
      LET g_success='N'
      RETURN
   END IF
END FUNCTION
 
FUNCTION i020_bu_2A(p_sw)
  DEFINE p_sw            LIKE type_file.chr1
  DEFINE l_nme  RECORD   LIKE nme_file.*
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
     IF p_sw = '+' THEN
	     LET l_nme.nme00 = '0'
	     LET l_nme.nme01 = b_oob.oob17
	     LET l_nme.nme02 = g_ooa.ooa02
	     LET l_nme.nme03 = b_oob.oob18
	     LET l_nme.nme04 = b_oob.oob10
	     LET l_nme.nme07 = g_ooa.ooa24
	     LET l_nme.nme08 = b_oob.oob09
	     LET l_nme.nme10 = g_ooa.ooa33
	     LET l_nme.nme12 = b_oob.oob01
	     LET l_nme.nme13 = g_ooa.ooa032
	     LET l_nme.nme14 = b_oob.oob21
	     LET l_nme.nme15 = b_oob.oob13
	     LET l_nme.nme16 = g_ooa.ooa02
	     LET l_nme.nmeacti='Y'
	     LET l_nme.nmeuser=g_user
	     LET l_nme.nmegrup=g_grup
	     LET l_nme.nmedate=TODAY
	     LET l_nme.nme21=b_oob.oob02
	     LET l_nme.nme22='01'
	     LET l_nme.nme23=b_oob.oob04
	     LET l_nme.nme24='9'
	     LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
	     LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04
             LET l_nme.nmelegal = g_legal    #No.FUN-A70118

#FUN-B30166--add--str
             LET l_date1 = g_today
             LET l_year = YEAR(l_date1)USING '&&&&'
             LET l_month = MONTH(l_date1) USING '&&'
             LET l_day = DAY(l_date1) USING  '&&'
             LET l_time = TIME(CURRENT)
             LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                          l_time[1,2],l_time[4,5],l_time[7,8]
             SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
              WHERE nme27[1,14] = l_dt
             IF cl_null(l_nme.nme27) THEN
                LET l_nme.nme27 = l_dt,'000001'
             END if
#FUN-B30166--add--end

	     INSERT INTO nme_file VALUES(l_nme.*)
	     IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                CALL s_errmsg('nme01',g_ooa.ooa01,'ins nme',STATUS,1)
	        LET g_success = 'N'
	        RETURN
	     END IF
       CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062  
  END IF
 
  IF p_sw = '-' THEN
     DELETE FROM nme_file WHERE nme12 = g_ooa.ooa01
     IF STATUS OR SQLCA.SQLCODE THEN
        CALL s_errmsg('nme01',g_ooa.ooa01,'del nme',STATUS,1)
        LET g_success = 'N'
     END IF
     #FUN-B40056--add--str--
     IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
        DELETE FROM tic_file WHERE tic04 = g_ooa.ooa01
        IF STATUS THEN
           CALL s_errmsg('luc01',g_ooa.ooa01,'',STATUS,1)
           LET g_success='N'
        END IF
     END IF
     #FUN-B40056--add--end--
  END IF
 
END FUNCTION
 
FUNCTION i020_bu_13(p_sw)                  #更新待抵帳款檔 (oma_file)
  DEFINE p_sw           LIKE type_file.chr1      #No.FUN-680123 VARCHAR(1)                  # +:更新 -:還原
  DEFINE l_omaconf      LIKE oma_file.omaconf,   #No.FUN-680123 VARCHAR(1),
         l_omavoid      LIKE oma_file.omavoid,   #No.FUN-680123 VARCHAR(1),
         l_cnt          LIKE type_file.num5      #No.FUN-680123 smallint
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE tot4,tot4t     LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #TQC-5B0171
  DEFINE tot5,tot6      LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #No.FUN-680022 add
  DEFINE tot8           LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #No.FUN-680022 add
  DEFINE l_omc10        LIKE omc_file.omc10,#No.FUN-680022 add
         l_omc11        LIKE omc_file.omc11,#No.FUN-680022 add
         l_omc13        LIKE omc_file.omc13 #No.FUN-680022 add
 
# 同參考單號若有一筆以上僅沖款一次即可 --------------
  SELECT COUNT(*) INTO l_cnt FROM oob_file
          WHERE oob01=b_oob.oob01
            AND oob02<b_oob.oob02
            AND oob03='1'
            AND oob04='3' 
            AND oob06=b_oob.oob06
  IF l_cnt>0 THEN RETURN END IF
 
 #預防在收款沖帳確認前,多沖待抵貨款
  SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob01=ooa01
     AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'     #No:9638
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
 
  IF p_sw='+' THEN
     SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
      WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
        AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'     #No:9638
       IF cl_null(tot5) THEN LET tot5 = 0 END IF
       IF cl_null(tot6) THEN LET tot6 = 0 END IF
  END IF
 
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  CALL cl_digcut(tot1,t_azi04) RETURNING tot1
  CALL cl_digcut(tot2,g_azi04) RETURNING tot2
  LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
            #"  FROM ",g_dbs_new CLIPPED,"oma_file",
            "  FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
            " WHERE oma01=?"
  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
  CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102          
  PREPARE i020_bu_13_p1 FROM g_sql
  DECLARE i020_bu_13_c1 CURSOR FOR i020_bu_13_p1
  OPEN i020_bu_13_c1 USING b_oob.oob06
  FETCH i020_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
    IF p_sw='+' AND l_omavoid='Y' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) LET g_success = 'N' RETURN   #NO.FUN-710050
    END IF
    IF p_sw='+' AND l_omaconf='N' THEN
       CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) LET g_success = 'N' RETURN   #NO.FUN-710050
    END IF
    IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
    IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
    #取得衝帳單的待扺金額
    CALL i020_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
    CALL cl_digcut(tot4,t_azi04) RETURNING tot4      #No.CHI-6A0004
    CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t    #No.CHI-6A0004
 
    IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
       IF p_sw='+' AND (un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t) THEN
       CALL s_errmsg(' ',' ','un_pay<pay#1','axr-196',1) LET g_success = 'N' RETURN
       END IF
    END IF
 
    SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
     WHERE oob06=b_oob.oob06 AND oob01=ooa01  AND ooaconf = 'Y'
       AND oob03='1'  AND oob04 = '3'
    IF cl_null(tot1) THEN LET tot1 = 0 END IF
    IF cl_null(tot2) THEN LET tot2 = 0 END IF
    IF p_sw='+' THEN
       SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
        WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
          AND ooaconf = 'Y' AND oob03='1'  AND oob04 = '3'
       IF cl_null(tot5) THEN LET tot5 = 0 END IF
       IF cl_null(tot6) THEN LET tot6 = 0 END IF
 
       SELECT omc10,omc11,omc13 INTO l_omc10,l_omc11,l_omc13 FROM omc_file
        WHERE omc01=b_oob.oob06 AND omc02 = b_oob.oob19
       IF cl_null(l_omc10) THEN LET l_omc10=0 END IF
       IF cl_null(l_omc11) THEN LET l_omc11=0 END IF
       IF cl_null(l_omc13) THEN LET l_omc13=0 END IF
     END IF
    IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
       #取得未沖金額
       CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
       #未衝金額扣除待扺
       LET tot3 = tot3 - tot4t
    ELSE
       LET tot3 = un_pay2 - tot2 - tot4t
    END IF
    #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"oma_file SET oma55=?,oma57=?,oma61=? ",
    LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
              " SET oma55=?,oma57=?,oma61=? ",
              " WHERE oma01=? "
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
    CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102              
    PREPARE i020_bu_13_p2 FROM g_sql
    LET tot1 = tot1 + tot4
    LET tot2 = tot2 + tot4t
    CALL cl_digcut(tot1,t_azi04) RETURNING tot1
    CALL cl_digcut(tot2,g_azi04) RETURNING tot2
 
    EXECUTE i020_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06
    IF STATUS THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)
       LET g_success = 'N'
       RETURN
    END IF
    IF SQLCA.SQLERRD[3]=0 THEN
       CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN
    END IF
    IF SQLCA.sqlcode = 0 THEN
       CALL i020_omc(p_sw)
    END IF
END FUNCTION
 
#取得衝帳單的待扺金額
FUNCTION i020_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t
 
   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION
 
FUNCTION i020_omc(p_sw)
DEFINE   l_omc10           LIKE omc_file.omc10
DEFINE   l_omc11           LIKE omc_file.omc11
DEFINE   l_omc13           LIKE omc_file.omc13
DEFINE   p_sw              LIKE type_file.chr1
DEFINE   l_oob09           LIKE oob_file.oob09
DEFINE   l_oob10           LIKE oob_file.oob10
 
  SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
   WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19
     AND oob01=ooa01  AND ooaconf = 'Y'
     AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))
  IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
  IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
  SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
  CALL cl_digcut(l_oob09,t_azi04) RETURNING l_oob09
  CALL cl_digcut(l_oob10,g_azi04) RETURNING l_oob10
     #LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc10=?,omc11=? ",
     LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
               " SET omc10=?,omc11=? ",
               " WHERE omc01=? AND omc02=? "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102           
     PREPARE i020_bu_13_p3 FROM g_sql
     EXECUTE i020_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
     #LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc13=omc09-omc11",
     LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
               " SET omc13=omc09-omc11",
               " WHERE omc01=? AND omc02=? "
     CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102           
     PREPARE i020_bu_13_p4 FROM g_sql
     EXECUTE i020_bu_13_p4 USING b_oob.oob06,b_oob.oob19
END FUNCTION
 
FUNCTION s_i020_ins_ooa()
DEFINE l_occ      RECORD LIKE occ_file.*
DEFINE g_cnt      LIKE type_file.num5
   INITIALIZE g_ooa.* TO NULL
   LET g_ooa.ooa00  = '1'
   LET g_ooa.ooa02  = g_today
   CALL s_get_bookno(year(g_ooa.ooa02)) RETURNING g_flag1,g_bookno1,g_bookno2
   IF g_flag1='1' THEN
      CALL s_errmsg('ooa02',g_ooa.ooa02,'','aoo-081',1)
      LET g_success = 'N'
      RETURN 
   END IF
   LET g_ooa.ooa021 = g_today
   LET g_ooa.ooa03  = g_luc.luc03
   LET g_ooa.ooa032 = g_luc.luc031
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   LET g_ooa.ooa13 = l_occ.occ67
   LET g_ooa.ooa14 = g_user
   LET g_ooa.ooa15 = g_grup
   LET g_ooa.ooa20 = 'Y'
   LET g_ooa.ooa23 = l_occ.occ42
   IF cl_null(g_ooa.ooa23) THEN
      LET g_ooa.ooa23 = g_aza.aza17
   END IF
   CALL s_curr3(g_ooa.ooa23,g_ooa.ooa02,'S') RETURNING g_ooa.ooa24
   LET g_ooa.ooa31d = 0
   LET g_ooa.ooa31c = 0
   LET g_ooa.ooa32d = 0
   LET g_ooa.ooa32c = 0
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_ooa.ooa23
   CALL cl_digcut(g_ooa.ooa31d,t_azi04) RETURNING g_ooa.ooa31d
   CALL cl_digcut(g_ooa.ooa31c,t_azi04) RETURNING g_ooa.ooa31c
   CALL cl_digcut(g_ooa.ooa32d,g_azi04) RETURNING g_ooa.ooa32d
   CALL cl_digcut(g_ooa.ooa32c,g_azi04) RETURNING g_ooa.ooa32c
   LET g_ooa.ooa33 = NULL
   LET g_ooa.ooa35 = "1"
   LET g_ooa.ooa36 = g_luc.luc01
   #LET g_ooa.ooa37 = 'Y'  #FUN-A40076 mark
   LET g_ooa.ooa37 = '2'   #FUN-A40076 add
   LET g_ooa.ooa38 = '1'
   LET g_ooa.ooaconf = 'Y'
   LET g_ooa.ooaprsw = 0
   LET g_ooa.ooauser = g_user
   LET g_ooa.ooagrup = g_grup
   LET g_ooa.ooadate = g_today
   SELECT oow05 INTO g_oow.oow05 FROM oow_file
    WHERE oow00 = '0'
   IF STATUS THEN
      CALL s_errmsg('oow05',g_luc.luc01,'','alm-998',1)
      LET g_success = 'N'
   END IF
   IF cl_null(g_oow.oow05) THEN
      CALL s_errmsg('oow05',g_luc.luc01,'','axr-149',1)
      LET g_success = 'N'
   END IF
   #CALL s_auto_assign_no("axr",g_oow.oow05,g_ooa.ooa02,"30","ooa_file","ooa01","","","")   #FUN-9C0139
   CALL s_auto_assign_no("axr",g_oow.oow05,g_ooa.ooa02,"32","ooa_file","ooa01","","","")   #FUN-9C0139
      RETURNING g_cnt,g_ooa.ooa01
 
   IF (NOT g_cnt) THEN
      CALL s_errmsg('oow05',g_luc.luc01,'','abm-621',1)
      LET g_success = 'N'
   END IF
 
   LET g_ooa.ooaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_ooa.ooaorig = g_grup      #No.FUN-980030 10/01/04
   LET g_ooa.ooalegal= g_legal     #No.FUN-A70118
   INSERT INTO ooa_file values(g_ooa.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('ooa01',g_ooa.ooa01,'ins ooa err',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION s_i020_ins_oob()
DEFINE i          LIKE type_file.num5
DEFINE l_sql      LIKE type_file.chr1000
#DEFINE l_ryd05    LIKE ryd_file.ryd05   #FUN-9C0168
DEFINE l_ooe02    LIKE ooe_file.ooe02    #FUN-9C0168
DEFINE l_aag05    LIKE aag_file.aag05
DEFINE l_lud      RECORD LIKE lud_file.*
DEFINE l_rxx      RECORD LIKE rxx_file.*
DEFINE l_rxy05    LIKE rxy_file.rxy05
DEFINE l_rxy12    LIKE rxy_file.rxy12
DEFINE l_rxy17    LIKE rxy_file.rxy17
 
 
   #借方根據支出單單身明細
   LET l_sql = "SELECT * FROM lud_file WHERE lud01 = '",g_luc.luc01 CLIPPED ,"'"
   PREPARE debit_prep FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lud01',g_luc.luc01,'pre lud ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE debit_cs CURSOR FOR debit_prep
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lud01',g_luc.luc01,'dec lud ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   LET i = 1
   FOREACH debit_cs INTO l_lud.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('lud01',g_luc.luc01,'for lud ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
      INITIALIZE g_oob.* TO NULL
      LET g_oob.oob01 = g_ooa.ooa01
      LET g_oob.oob02 = i
      LET g_oob.oob03 = '1'
      IF NOT cl_null(l_lud.lud03) THEN   #有費用單的支出單
         LET g_oob.oob04 = '3'
         SELECT oma19 INTO g_oob.oob06 FROM oma_file
          WHERE oma16=l_lud.lud03 AND omaconf='Y' AND oma00 = '15'
      ELSE                               #無費用單的支出單 
         LET g_oob.oob04 = 'F'
         LET g_oob.oob06 = NULL
      END IF
      LET g_oob.oob20 = 'N'
      LET g_oob.oob07 = g_ooa.ooa23
      LET g_oob.oob08 = g_ooa.ooa24
      LET g_oob.oob09 = l_lud.lud07
      SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob.oob07
      CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
      LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
      CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
      SELECT oaj04 INTO g_oob.oob11 FROM oaj_file WHERE oaj01=l_lud.lud05
      IF g_aza.aza63 = 'Y' THEN
         SELECT oaj041 INTO g_oob.oob111 FROM oaj_file WHERE oaj01=l_lud.lud05
      END IF
      LET g_oob.ooblegal = g_legal #No.FUN-A70118
      INSERT INTO oob_file values(g_oob.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('oob01',g_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
 
      UPDATE ooa_file SET ooa31d = ooa31d + g_oob.oob09, 
                          ooa32d = ooa32d + g_oob.oob10
       WHERE ooa01 = g_ooa.ooa01
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('oob01',g_oob.oob01,'upd ooa err',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
 
      LET i = i+1
   END FOREACH
 
   #貸方根據退款明細
   LET l_sql = "SELECT * FROM rxx_file where rxx01= '",g_luc.luc01 CLIPPED ,"'",
               "   AND rxxplant= '",g_luc.lucplant CLIPPED,"' AND rxx00='08'"
   PREPARE credit_prep FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rxx01',g_luc.luc01,'pre rxx ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   DECLARE credit_cs CURSOR FOR credit_prep
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rxx01',g_luc.luc01,'dec rxx ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   FOREACH credit_cs INTO l_rxx.*
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('rxx01',g_luc.luc01,'for rxx ',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
     INITIALIZE g_oob.* TO NULL
     #款別對應銀行
     #SELECT ryd05 INTO l_ryd05 FROM ryd_file WHERE ryd01=l_rxx.rxx02    #FUN-9C0168
     SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01 = l_rxx.rxx02   #FUN-9C0168
     LET g_oob.oob01 = g_ooa.ooa01
     LET g_oob.oob02 = i
     LET g_oob.oob03 = '2'
     LET g_oob.oob06 = NULL
     LET g_oob.oob20 = 'N'
     LET g_oob.oob07 = g_ooa.ooa23
     LET g_oob.oob08 = g_ooa.ooa24
     LET g_oob.oob09 = l_rxx.rxx04
     SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = g_oob.oob07
     CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
     LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
     CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
     IF l_rxx.rxx02 MATCHES '0[1238]' THEN
        LET g_oob.oob04 = 'A'
       #FUN-9C0168--mod--str--
       #IF NOT cl_null(l_ryd05) THEN
       #   LET g_oob.oob17 = l_ryd05
       #   SELECT nma05 INTO g_oob.oob11 FROM nma_file WHERE nma01=l_ryd05
       #   IF g_aza.aza63 = 'Y' THEN
       #      SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01=l_ryd05
        IF NOT cl_null(l_ooe02) THEN
           LET g_oob.oob17 = l_ooe02
           SELECT nma05 INTO g_oob.oob11 FROM nma_file WHERE nma01=l_ooe02
           IF g_aza.aza63 = 'Y' THEN
              SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01=l_ooe02
       #FUN-9C0168--mod--end
           ELSE
              LET g_oob.oob111 = NULL
           END IF
        ELSE
        ####-------wait-------##
        END IF
        IF cl_null(g_oow.oow04) THEN
           CALL s_errmsg('oob18',g_luc.luc01,'','axr-149',1)
           LET g_success = 'N'
           RETURN
        END IF 
        LET g_oob.oob18 = g_oow.oow04
        SELECT nmc05 INTO g_oob.oob21 FROM nmc_file WHERE nmc01=g_oob.oob18
     END IF
     IF l_rxx.rxx02 = '05' THEN
        LET g_oob.oob04 = 'E'
       #FUN-9C0168--mod--str--
       #IF NOT cl_null(l_ryd05) THEN
       #   LET g_oob.oob17 = l_ryd05
       #   SELECT nma05 INTO g_oob.oob11 FROM nma_file
       #      WHERE nma01=l_ryd05
       #   IF g_aza.aza63 = 'Y' THEN
       #     SELECT nma051 INTO g_oob.oob111 FROM nma_file
       #        WHERE nma01=l_ryd05
        IF NOT cl_null(l_ooe02) THEN
           LET g_oob.oob17 = l_ooe02
           SELECT nma05 INTO g_oob.oob11 FROM nma_file
            WHERE nma01=l_ooe02
           IF g_aza.aza63 = 'Y' THEN
              SELECT nma051 INTO g_oob.oob111 FROM nma_file
               WHERE nma01=l_ooe02
       #FUN-9C0168--mod--end
           ELSE
              LET g_oob.oob111 = NULL
           END IF
        ELSE
         #若銀行為空,則根據卡種抓科目(ood_file卡種對應科目維護作業)
         #根據rxy_file
           LET l_sql = "SELECT rxy05,rxy12,rxy17 FROM rxy_file ",
                       " WHERE rxy01 = '",g_luc.luc01 ,"'",
                       "   AND rxyplant = '", g_luc.lucplant,"'",
                       "   AND rxy03 = '05' AND rxy00 = '08' "
           PREPARE rxx02_05prep FROM l_sql
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('rxy01',g_luc.luc01,'pre rxy ',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
           END IF
           DECLARE rxx02_05cs CURSOR FOR rxx02_05prep
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('rxy01',g_luc.luc01,'dec rxy ',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
           END IF
           FOREACH rxx02_05cs INTO l_rxy05,l_rxy12,l_rxy17
           IF SQLCA.sqlcode THEN
              CALL s_errmsg('rxy01',g_luc.luc01,'for rxy ',SQLCA.sqlcode,1)
              LET g_success = 'N'
              RETURN
           END IF
              #FUN-9C0168--mod--str--
              #SELECT rxw04,rxw05 INTO g_oob.oob11,g_oob.oob111 FROM rxw_file
              # WHERE rxw01 = l_rxy12
               SELECT ood02,ood03 INTO g_oob.oob11,g_oob.oob111 FROM ood_file
                WHERE ood01 = l_rxy12
              #FUN-9C0168--mod--end
               IF g_aza.aza63 = 'N' THEN LET g_oob.oob111 = '' END IF
               LET g_oob.oob09 = l_rxy05
               LET g_oob.oob10 = g_oob.oob08 * g_oob.oob09
               SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_oob.oob11  AND aag00=g_bookno1
               IF l_aag05 ='Y' THEN
                  LET g_oob.oob13=g_ooa.ooa15
               ELSE
                  LET g_oob.oob13 = NULL
               END IF
               LET g_oob.ooblegal = g_legal #No.FUN-A70118
               INSERT INTO oob_file VALUES(g_oob.*)
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('oob01',g_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
 
               UPDATE ooa_file SET ooa31c = ooa31c + g_oob.oob09,
                                   ooa32c = ooa32c + g_oob.oob10
                WHERE ooa01 = g_ooa.ooa01
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                  CALL s_errmsg('oob01',g_oob.oob01,'upd ooa err',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
 
               LET i = i +1
           END FOREACH
           CONTINUE FOREACH
        END IF
     END IF
#    IF l_rxx.rxx02 = '04' THEN
#       LET g_oob.oob04 = 'Q'
#        #根據券類型抓科目(lpx_file券類型維護作業)
#        #根據rxy_file
#        ##add-----start---081023##
#        LET l_sql = "SELECT rxy05,rxy12,rxy17 FROM rxy_file ",
#            " WHERE rxy01 = '",g_luc.luc01, "'",
#            "   AND rxy930 = '",g_luc.plant_code,"'",
#            "   AND rxy03 = '04' AND rxy00 = '08' "
#        PREPARE rxx02_04prep FROM l_sql
#        IF STATUS THEN
#           CALL cl_err('rxx02_04prep:',status,0) EXIT PROGRAM
#           LET g_success = 'N'
#        END IF
#        DECLARE rxx02_04cs CURSOR FOR rxx02_04prep
#        FOREACH rxx02_04cs INTO l_rxy05,l_rxy12,l_rxy17
#            SELECT lpx19,lpx20 INTO g_oob.oob11,g_oob.oob111 FROM lpx_file
#             WHERE lpx01 = l_rxy12
#            IF g_aza.aza63 = 'N' THEN LET g_oob.oob111 = '' END IF
#            IF (cl_null(g_oob.oob11))
#               OR (g_aza.aza63 = 'Y' AND cl_null(g_oob.oob111)) THEN     #quan
#            #  SELECT ool31,ool311 INTO g_oob.oob11,g_oob.oob111
#               SELECT ool32,ool321 INTO g_oob.oob11,g_oob.oob111
#                FROM ool_file WHERE ool01=g_oma.oma13
#            END IF
#            LET g_oob.oob09 = l_rxy05
#            LET g_oob.oob10 = g_oob.oob08 * g_oob.oob09
#            IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
#               CALL cl_err('','axr-074',1)
#               LET g_success = 'N'
#            END IF
#            IF cl_null(g_oob.oob11) THEN
#               CALL cl_err('','axr-074',1)
#               LET g_success = 'N'
#            END IF
#            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_oob.oob11  AND aag00=g_bookno1
#                IF l_aag05 ='Y' THEN
#                   LET g_oob.oob13=g_ooa.ooa15
#                ELSE
#                   LET g_oob.oob13 = NULL
#                END IF
#            INSERT INTO oob_file VALUES(g_oob.*)
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#              CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"","ins oob",1)
#              LET g_success = 'N'
#            END IF
 
#            UPDATE ooa_file SET ooa31c = ooa31c + g_oob.oob09	WHERE ooa01 = g_ooa.ooa01
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#               CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
#               LET g_success = 'N'
#            END IF
  
#            UPDATE ooa_file SET ooa32c = ooa32c + g_oob.oob10 WHERE ooa01 = g_ooa.ooa01
#            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
#               CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
#               LET g_success = 'N'
#            END IF
#            LET i = i +1
#        END FOREACH
#        CONTINUE FOREACH
#    END IF
     SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_oob.oob11  AND aag00=g_bookno1
     IF l_aag05 ='Y' THEN
        LET g_oob.oob13=g_ooa.ooa15
     ELSE
        LET g_oob.oob13 = NULL
     END IF
     LET g_oob.ooblegal = g_legal #No.FUN-A70118
     INSERT INTO oob_file values(g_oob.*)
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('oob01',g_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF
 
     UPDATE ooa_file SET ooa31c = ooa31c + g_oob.oob09,
                         ooa32c = ooa32c + g_oob.oob10
      WHERE ooa01 = g_ooa.ooa01
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL s_errmsg('oob01',g_oob.oob01,'upd ooa err',SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF
 
     LET i = i +1
  END FOREACH
END FUNCTION
 
FUNCTION s_i020_gl()
DEFINE l_t1       LIKE ooy_file.ooyslip  #080821
    LET l_t1 = s_get_doc_no(g_ooa.ooa01)
    SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip = l_t1
    IF STATUS THEN
       CALL s_errmsg('ooyslip',l_t1,'sel ooy',STATUS,0)
       LET g_success = 'N'
       RETURN
    END IF
    IF g_ooy.ooydmy1 = 'Y' THEN
       CALL s_t400_gl(g_ooa.ooa01,'0')
       IF g_aza.aza63='Y' THEN
          CALL s_t400_gl(g_ooa.ooa01,'1')
       END IF
    END IF
END FUNCTION
# Usage..........: CALL s_i020_unconfirm(p_no)
# Input Parameter: p_no    支出單號
# Return Code....: g_flag  0:不成功
#                          1:成功            
FUNCTION s_i020_unconfirm(p_no)
DEFINE p_no       LIKE luc_file.luc01
DEFINE l_aba19    LIKE aba_file.aba19
DEFINE l_cnt      LIKE type_file.num5
DEFINE i          LIKE type_file.num5
DEFINE l_dbs      STRING
DEFINE l_sql      STRING
DEFINE g_t1       LIKE ooy_file.ooyslip  #080821
 
   WHENEVER ERROR CALL cl_err_msg_log
 
 
   SELECT * INTO g_luc.* FROM luc_file WHERE luc01=p_no
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('luc01',p_no,'',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN 0
   END IF
 
   SELECT * INTO g_ooa.* FROM ooa_file 
    WHERE ooa35 = '1' AND ooa36 = g_luc.luc01 
      #AND ooa37 = 'Y' AND ooa38 = '1'     #FUN-A40076 mark
      AND ooa37 = '2' AND ooa38 = '1'      #FUN-A40076 add
   IF STATUS THEN
      CALL s_errmsg('luc01',p_no,'','alm-725',1)
      LET g_success = 'N'
      RETURN 0
   END IF
 
 
   #取消確認時，若單據別設為"系統自動拋轉總帳",則可自動拋轉還原
   CALL s_get_doc_no(g_ooa.ooa01) RETURNING g_t1
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=g_t1
   IF NOT cl_null(g_ooa.ooa33) THEN
      IF NOT (g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y') THEN
         CALL s_errmsg('luc01',g_ooa.ooa01,'','axr-370',1)
         LET g_success='N'
         RETURN 0
      END IF
   END IF
 
 
   IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' THEN
      LET g_plant_new=g_ooz.ooz02p
      #CALL s_getdbs() LET l_dbs = g_dbs_new  #FUN-A50102
      #LET l_dbs = l_dbs.trimRight()          #FUN-A50102
      #LET l_sql = " SELECT aba19 FROM ",l_dbs,"aba_file",
      LET l_sql = " SELECT aba19 FROM ",cl_get_target_table(g_plant_new,'aba_file'), #FUN-A50102
                  "  WHERE aba00 = '",g_ooz.ooz02b,"'",
                  "    AND aba01 = '",g_ooa.ooa33,"'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
      CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102              
      PREPARE aba_pre FROM l_sql
      DECLARE aba_cs CURSOR FOR aba_pre
      OPEN aba_cs
      FETCH aba_cs INTO l_aba19
      IF l_aba19 = 'Y' THEN
         CALL s_errmsg('luc01',g_ooa.ooa33,'','axr-071',1)
         LET g_success='N'
         RETURN 0
      END IF
   END IF
 
   CALL s_i020_unconfirm_zvou()
   IF g_success ='N' THEN RETURN 0 END IF
 
   CALL s_i020_unconfirm_z1()
   IF SQLCA.sqlcode OR g_success='N' THEN
      LET g_success='N'
   END IF
   DELETE FROM ooa_file WHERE ooa01 = g_ooa.ooa01
   IF SQLCA.sqlcode OR g_success='N' THEN
      CALL s_errmsg('luc01',g_ooa.ooa01,'','alm-723',1)
      LET g_success='N'
   END IF
   DELETE FROM oob_file WHERE oob01 = g_ooa.ooa01
   IF SQLCA.sqlcode OR g_success='N' THEN
      CALL s_errmsg('luc01',g_ooa.ooa01,'','alm-724',1)
      LET g_success='N'
   END IF
   DELETE FROM npp_file WHERE npp01 = g_ooa.ooa01 AND nppsys = 'AR'
           AND npp00 = 3  AND npp011 = 1
   IF SQLCA.sqlcode OR g_success='N' THEN
      CALL s_errmsg('luc01',g_ooa.ooa01,'',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   DELETE FROM npq_file WHERE npq01 = g_ooa.ooa01 AND npqsys = 'AR'
           AND npq00 = 3 AND npq011 = 1
   IF SQLCA.sqlcode OR g_success='N' THEN
      CALL s_errmsg('luc01',g_ooa.ooa01,'',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF

   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_ooa.ooa01
   IF SQLCA.sqlcode OR g_success='N' THEN
      CALL s_errmsg('luc01',g_ooa.ooa01,'',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
   #FUN-B40056--add--end--
 
   IF g_success = 'N' THEN RETURN 0 ELSE RETURN 1 END IF
 
END FUNCTION
 
FUNCTION s_i020_unconfirm_zvou()     #取消拋轉
DEFINE l_cnt       LIKE type_file.num5
DEFINE g_str       LIKE type_file.chr1000
      IF g_ooy.ooydmy1 = 'Y' AND g_ooy.ooyglcr = 'Y' AND g_success = 'Y'
	       AND NOT cl_null(g_ooa.ooa33) THEN
         LET g_str="axrp591 '",g_ooz.ooz02p,"' '",g_ooz.ooz02b,"' '",g_ooa.ooa33,"' 'Y'"
         CALL cl_cmdrun_wait(g_str)
         SELECT ooa33 INTO g_ooa.ooa33 FROM ooa_file WHERE ooa35 = '1' AND
                 #ooa36 = g_luc.luc01 AND ooa37 = 'Y' AND ooa38 = '1'    #FUN-A40076 mark
                 ooa36 = g_luc.luc01 AND ooa37 = '2' AND ooa38 = '1'     #FUN-A40076 add
         IF NOT cl_null(g_ooa.ooa33) THEN
            CALL s_errmsg('luc01',g_ooa.ooa01,'','aap-929',1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
END FUNCTION
 
FUNCTION s_i020_unconfirm_z1()
   DEFINE n      LIKE type_file.num5      #No.FUN-680123 SMALLINT
   DEFINE l_cnt  LIKE type_file.num5      #No.FUN-680123 SMALLINT
   DEFINE l_n    LIKE type_file.num5     #No.FUN-880076
   DEFINE l_flag LIKE type_file.chr1      #No.FUN-680123 VARCHAR(1)
   UPDATE ooa_file SET ooaconf = 'N' WHERE ooa01 = g_ooa.ooa01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","upd ooaconf",1)  #No.FUN-660116
      LET g_success = 'N'
      RETURN
   END IF
 
   DECLARE i020_z1_c CURSOR FOR
         SELECT * FROM oob_file WHERE oob01 = g_ooa.ooa01 ORDER BY oob02
   LET l_cnt = 1
   LET l_n = 1    #No.FUN-880076
   LET l_flag = '0'
   FOREACH i020_z1_c INTO b_oob.*
    IF STATUS THEN
       CALL s_errmsg('oob01',g_ooa.ooa01,'z1 foreach',STATUS,1)
       LET g_success = 'N' RETURN
    END IF
    IF l_flag = '0' THEN LET l_flag = b_oob.oob03 END IF
    IF l_flag != b_oob.oob03 THEN
       LET l_cnt = l_cnt + 1
    END IF
    IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN CALL i020_bu_13('-') END IF
    #FUN-A40076 mark
    #IF g_ooa.ooa37 = 'Y' THEN     #審核時若g_ooa.ooa37 = 'Y'且單身有貸方(oob03 = '2')為TT(oob04 = 'A')的資料時,產生nme_file
    IF g_ooa.ooa37 = '2' THEN      #FUN-A40076 add
        IF b_oob.oob03 = '2' AND b_oob.oob04 = 'A' THEN
              CALL i020_bu_2A('-')
        END IF
    END IF
    LET l_cnt = l_cnt + 1
    LET l_n = l_n + 1
   END FOREACH
END FUNCTION
#FUN-9C0067

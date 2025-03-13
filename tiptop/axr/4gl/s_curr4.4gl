# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
##□ s_curr4
##SYNTAX	LET l_rate=s_curr4(p_curr,p_date,p_bs)
##DESCRIPTION	取得該幣別在該日期或該月份的買入或賣出匯率
##PARAMETERS	p_curr	幣別
##		p_date	日期
##		p_bs	B:買入/S:賣出 /C:海關
##		p_dbs   依資料庫來判斷
##RETURNING	l_rate	匯率
##NOTE		若g_chr='E'則無幣別資料或無每月匯率資料或無每日匯率資料
# Date & Author..: 98/12/08 By Linda
#
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A50102 10/09/29 By vealxu 跨db处理
 
DATABASE ds
GLOBALS
    DEFINE
        g_chr           LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(01)
        g_aza RECORD    LIKE aza_file.*
END GLOBALS
 
#FUNCTION s_curr4(p_curr,p_date,p_bs,p_dbs)       #FUN-A50102 mark
FUNCTION s_curr4(p_curr,p_date,p_bs,p_plant)      #FUN-A50102
DEFINE
    p_curr           LIKE azi_file.azi01,          # Prog. Version..: '5.30.06-13.03.12(04) #幣別
    p_date           LIKE type_file.dat,           #No.FUN-680123 DATE     #日期
    p_bs             LIKE type_file.chr1,          #No.FUN-680123 VARCHAR(1)  #B:買入/S:賣出
    p_dbs            LIKE type_file.chr21,         #No.FUN-680123 VARCHAR(21) #資料庫名稱 
    p_plant          LIKE type_file.chr21,         #FUN-A50102   
    l_aza RECORD     LIKE aza_file.*,
    l_rate           LIKE azj_file.azj03,
    l_sql            LIKE type_file.chr1000,       #No.FUN-680123 VARCHAR(600)
    l_r1,l_r2,l_r3   LIKE azj_file.azj03,
    l_ym             LIKE azj_file.azj02,          #No.FUN-680123 VARCHAR(6) #YYYYMM
    l_buf            LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(20)
 
    WHENEVER ERROR CONTINUE
    IF p_date IS NULL THEN LET p_date=MDY(12,31,9999) END IF
    IF p_dbs IS NULL THEN LET p_dbs='  ' END IF
#-----> Modify By Jones   -------92/12/02---------
# 捉出整體系統參數
    LET l_sql = "SELECT * ",
              # " FROM ",p_dbs CLIPPED,"aza_file " ,         #FUN-A50102 
                " FROM ",cl_get_target_table(p_plant,'aza_file'),    #FUN-A50102   
                " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
    CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql     #FUN-A50102
    PREPARE aza_pr2 FROM l_sql 
    IF STATUS THEN CALL cl_err('aza_pr2',STATUS,1) END IF
    DECLARE aza_cu2 CURSOR FOR aza_pr2
    OPEN aza_cu2
    FETCH aza_cu2 INTO l_aza.* 
    CLOSE aza_cu2
    IF p_curr = l_aza.aza17 THEN RETURN 1 END IF
#------------------------------------------------
    CASE
      WHEN l_aza.aza19 = '1'		#取每月匯率
          LET l_ym = p_date USING 'yyyymm'
          LET l_sql = "SELECT azj03,azj04 ",
                    # " FROM ",p_dbs CLIPPED,"azj_file ",                   #FUN-A50102 mark
                      " FROM ",cl_get_target_table(p_plant,'azj_file'),     #FUN-A50102 
                      " WHERE azj01 ='",p_curr,"' AND azj02 ='",l_ym,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql#FUN-A50102
          PREPARE azj_p1 FROM l_sql
          IF STATUS THEN CALL cl_err('azj_p1',STATUS,1) END IF
          DECLARE azj_c1 CURSOR FOR azj_p1
          OPEN azj_c1
          FETCH azj_c1 INTO l_r1,l_r2
          IF SQLCA.sqlcode THEN
              LET l_buf = p_curr,'+',l_ym
              CALL cl_err(l_buf,'aoo-056',0)
              LET l_r1=1.0 LET l_r2=1.0
          END IF
          CLOSE azj_c1 
      WHEN l_aza.aza19 = '2'		#取每日匯率
          LET l_sql = "SELECT azk03,azk04,azk05 ",
                    # " FROM ",p_dbs CLIPPED,"azk_file ",                #FUN-A50102 mark
                      " FROM ",cl_get_target_table(p_plant,'azk_file'),  #FUN-A50102 
                      " WHERE azk01 ='",p_curr,"' AND azk02 ='",p_date,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql#FUN-A50102 
          PREPARE azk_p1 FROM l_sql
          IF STATUS THEN CALL cl_err('azk_p1',STATUS,1) END IF
          DECLARE azk_c1 CURSOR FOR azk_p1
          OPEN azk_c1
          FETCH azk_c1 INTO l_r1,l_r2,l_r3
	  IF SQLCA.sqlcode THEN	#每日取不到時, 取最近匯率
              LET l_sql = "SELECT azk03,azk04,azk05 ",
                        # " FROM ",p_dbs CLIPPED,"azk_file ",           #FUN-A50102 mark
                          " FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                          " WHERE azk02 = (SELECT MAX(azk02) ",
                        # "                 FROM ",p_dbs CLIPPED,"azk_file ",   #FUN-A50102 
                          "                 FROM ",cl_get_target_table(p_plant,'azk_file'),  #FUN-A50102
                          "                 WHERE azk01='",p_curr,"' ",
                          "                   AND azk02 <='",p_date,"' ) "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql   #FUN-A50102
              PREPARE azk_p2 FROM l_sql
              IF STATUS THEN CALL cl_err('azk_p2',STATUS,1) END IF
              DECLARE azk_c2 CURSOR FOR azk_p2
              OPEN azk_c2
              FETCH azk_c2 INTO l_r1,l_r2,l_r3
              IF SQLCA.sqlcode THEN	#無最近匯率, 則設為一
		LET l_buf = p_curr CLIPPED,'+',p_date
		CALL cl_err(l_buf,'aoo-057',0)
		LET l_r1=1.0 LET l_r2=1.0
	      END IF
              CLOSE azk_c2
          END IF
          CLOSE azk_c1
      OTHERWISE LET l_r1 = 1 LET l_r2 = 1
    END CASE
    CASE
      WHEN p_bs = 'B' LET l_rate = l_r1
      WHEN p_bs = 'S' LET l_rate = l_r2
      WHEN p_bs = 'C' LET l_rate = l_r3
      OTHERWISE       LET l_rate = 1
    END CASE
    RETURN l_rate
END FUNCTION

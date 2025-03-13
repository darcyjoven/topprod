# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# 本FUNCTION copy from s_exrate()差異如下:
# Modify.........: No.FUN-640215 08/02/13 By Mandy 1.參數多傳資料庫(p_azp03),所以程式內所有抓匯率的地方都需改寫加上資料庫
#                                                  2.匯率抓法==>看整體參數aoos010抓1:月平均azj04(當月銷售平均匯率) 或 2:每日 
#                                                            
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-980020 09/09/02 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
GLOBALS "../../config/top.global"   #FUN-980020
 
#FUNCTION s_exrate_m(o_curr,d_curr,p_rate,p_azp03)  #FUN-980020 mark
FUNCTION s_exrate_m(o_curr,d_curr,p_rate,p_plant)   #FUN-980020
 DEFINE o_curr         VARCHAR(04)  # 來源幣別
 DEFINE d_curr          VARCHAR(04)  # 目的幣別
 DEFINE p_rate	        VARCHAR(01)  # B:銀行買入 S:銀行賣出 M:銀行中價
                                  # P:海關旬 C:海關買入D:海關賣出
 DEFINE p_exrate        LIKE azk_file.azk03 #FUN-4B0071
 DEFINE p_aza		RECORD LIKE aza_file.*
 DEFINE p_azk1	        RECORD LIKE azk_file.*
 DEFINE p_azk2	        RECORD LIKE azk_file.*
 DEFINE l_date          DATE
 DEFINE p_azp03         LIKE azp_file.azp03 
 DEFINE p_plant         LIKE type_file.chr10        #FUN-980020
 DEFINE l_dbs           VARCHAR(21)            
 DEFINE l_azj02         LIKE azj_file.azj02
 DEFINE l_azj04_o       LIKE azj_file.azj04
 DEFINE l_azj04_d       LIKE azj_file.azj04
 DEFINE #g_sql           VARCHAR(1000)
        g_sql           STRING      #NO.FUN-910082
 DEFINE g_buf           VARCHAR(20)
 
 WHENEVER ERROR CALL cl_err_msg_log
#FUN-A50102--mark--str-- 
#FUN-980020--begin
 #IF cl_null(p_plant) THEN 
 #    LET p_azp03 = NULL
 #ELSE
 #   LET g_plant_new = p_plant
 #    CALL s_getdbs()
 #   LET p_azp03 = g_dbs_new
 #END IF
#FUN-980020--end
 
 #IF NOT cl_null(p_azp03) THEN 
 #    LET l_dbs = s_dbstring(p_azp03 CLIPPED)
 #ELSE
 #    LET l_dbs = '' 
 #END IF
 #FUN-A50102--mark--end--
 LET g_sql =
            #"SELECT * FROM ",l_dbs CLIPPED,"aza_file",
            "SELECT * FROM ",cl_get_target_table(p_plant,'aza_file'), #FUN-A50102
            " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
 PREPARE aza_pre FROM g_sql
 DECLARE aza_cur CURSOR FOR aza_pre
 OPEN aza_cur
 FETCH aza_cur INTO p_aza.*
 IF STATUS <> 0 THEN RETURN 0 END IF
 IF o_curr = d_curr THEN 
    RETURN 1
 END IF
 LET l_date=TODAY
 
 
 IF p_aza.aza19 = '2' THEN #匯率採用(1)月平均匯率(2)每日匯率
     IF o_curr = p_aza.aza17 THEN #來源幣別=本幣
         LET p_azk1.azk03=1
         LET p_azk1.azk04=1
         LET p_azk1.azk041=1
         LET p_azk1.azk05=1
         LET p_azk1.azk051=1
         LET p_azk1.azk052=1
     ELSE
         LET g_sql = 
                    #"SELECT * FROM ",l_dbs CLIPPED,"azk_file ",
                    "SELECT * FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                    " WHERE azk01 = '",o_curr,"'",
                    "   AND azk02 <= '",l_date,"'",
                    " ORDER BY azk02 DESC"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE azk_pre1 FROM g_sql
         DECLARE azk_cur1 CURSOR FOR azk_pre1
         OPEN azk_cur1
         FETCH azk_cur1 INTO p_azk1.*
         IF STATUS <> 0 THEN
            CLOSE azk_cur1
            RETURN 0
         END IF
         CLOSE azk_cur1
     END IF
     IF d_curr = p_aza.aza17 THEN
         LET p_azk2.azk03=1
         LET p_azk2.azk04=1
         LET p_azk2.azk041=1
         LET p_azk2.azk05=1
         LET p_azk2.azk051=1
         LET p_azk2.azk052=1
     ELSE
         LET g_sql = 
                    #"SELECT * FROM ",l_dbs CLIPPED,"azk_file ",
                    "SELECT * FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                    " WHERE azk01 = '",d_curr,"'",
                    "   AND azk02 <= '",l_date,"'",
                    " ORDER BY azk02 DESC"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE azk_pre2 FROM g_sql
         DECLARE azk_cur2 CURSOR FOR azk_pre2
         OPEN azk_cur2
         FETCH azk_cur2 INTO p_azk2.*
         IF STATUS <> 0 THEN
            CLOSE azk_cur2
            RETURN 0
         END IF
         CLOSE azk_cur2
     END IF
     LET p_exrate=0
    
     #依oaz212 參數決定使用之匯率
     CASE WHEN p_rate='B' 
               IF p_azk2.azk03 <> 0 THEN
                  LET p_exrate=p_azk1.azk03/p_azk2.azk03
               END IF
          WHEN p_rate='S' 
               IF p_azk2.azk04 <> 0 THEN
                  LET p_exrate=p_azk1.azk04/p_azk2.azk04
               END IF
          WHEN p_rate='M' 
               IF p_azk2.azk041 <> 0 THEN
                  LET p_exrate=p_azk1.azk041/p_azk2.azk041
               END IF
          WHEN p_rate='P' 
               IF p_azk2.azk05 <> 0 THEN
                  LET p_exrate=p_azk1.azk05/p_azk2.azk05
               END IF
          WHEN p_rate='C' 
               IF p_azk2.azk051 <> 0 THEN
                  LET p_exrate=p_azk1.azk051/p_azk2.azk051
               END IF
          WHEN p_rate='D' 
               IF p_azk2.azk052 <> 0 THEN
                  LET p_exrate=p_azk1.azk052/p_azk2.azk052
               END IF
     END CASE
     RETURN  p_exrate
 ELSE
     IF o_curr = p_aza.aza17 THEN #來源幣別=本幣
         LET l_azj04_o = 1
     ELSE
         LET l_azj02 = YEAR(l_date) USING "&&&&" CLIPPED,MONTH(l_date) USING "&&" CLIPPED
         LET g_sql=
                   #"SELECT azj04 FROM ",l_dbs CLIPPED,"azj_file ",
                   "SELECT azj04 FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                   " WHERE azj01 = '",o_curr,"'",
                   "   AND azj02 = '",l_azj02,"'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE azj_pre1 FROM g_sql
         DECLARE azj_cur1 CURSOR FOR azj_pre1
         OPEN azj_cur1
         FETCH azj_cur1 INTO l_azj04_o
         IF STATUS <> 0 THEN
             LET g_buf = o_curr,'+',l_azj02
             #無此幣別的每月匯率資料, 匯率預設為 1
             CALL cl_err(g_buf,'aoo-056',0)
             CLOSE azj_cur1
             RETURN 1
         END IF
         CLOSE azj_cur1
     END IF
     IF d_curr = p_aza.aza17 THEN
         LET l_azj04_d = 1
     ELSE
         LET l_azj02 = YEAR(l_date) USING "&&&&" CLIPPED,MONTH(l_date) USING "&&" CLIPPED
         LET g_sql=
                   #"SELECT azj04 FROM ",l_dbs CLIPPED,"azj_file ",
                   "SELECT azj04 FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                   " WHERE azj01 = '",d_curr,"'",
                   "   AND azj02 = '",l_azj02,"'"
 	     CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
         CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql #FUN-A50102
         PREPARE azj_pre2 FROM g_sql
         DECLARE azj_cur2 CURSOR FOR azj_pre2
         OPEN azj_cur2
         FETCH azj_cur2 INTO l_azj04_d
         IF STATUS <> 0 THEN
             LET g_buf = d_curr,'+',l_azj02
             #無此幣別的每月匯率資料, 匯率預設為 1
             CALL cl_err(g_buf,'aoo-056',0)
             CLOSE azj_cur2
             RETURN 1
         END IF
         CLOSE azj_cur2
     END IF
     LET p_exrate=0
     LET p_exrate = l_azj04_o/l_azj04_d
     RETURN  p_exrate
 END IF
 
END FUNCTION
#FUN-640215

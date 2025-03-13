# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: s_currm.4gl
# Descriptions...: 取得該幣別在該日期或該月份的買入或賣出匯率
# Date & Author..: 98/12/08 By Linda
# Usage..........: LET l_rate=s_currm(p_curr,p_date,p_bs)
# Input Parameter: p_curr   幣別
#                  p_date   日期
#                  p_bs     B:買入/S:賣出 /C:海關
#                  p_dbs    依資料庫來判斷
# Return code....: l_rate   匯率
# Memo...........: 1.若g_chr='E'則無幣別資料或無每月匯率資料或無每日匯率資料
#                  2.copy自s_curr3.4gl, 改成多工廠
# Modify.........: No.FUN-640012 06/04/07 By kim GP3.0 匯率參數功能改善
# Modify.........: NO.FUN-640196 06/04/19 BY yiting 抓取欄位順序錯誤
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-720003 07/02/05 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.MOD-810051 08/01/07 By Smapmin 修改SQL語法
# Modify.........: No.FUN-980020 09/09/01 By douzh GP集團架構修改,sub相關參數
# Modify.........: No:MOD-A10190 10/01/28 By Dido SQL內有兩層的SELECT都有跨DB，必須改為兩次轉換後合併語法
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
#FUNCTION s_currm(p_curr,p_date,p_bs,p_dbs)        #No.FUN-980020 mark
FUNCTION s_currm(p_curr,p_date,p_bs,p_plant)       #No.FUN-980020
DEFINE
    p_curr           LIKE aza_file.aza17,          # Prog. Version..: '5.30.06-13.03.12(04)     #幣別
    p_date           LIKE type_file.dat,           #No.FUN-680147 DATE        #日期
    p_bs             LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(1)     #B:買入/S:賣出
    p_dbs            LIKE type_file.chr21,         #No.FUN-680147 VARCHAR(21)    #資料庫名稱 
    p_plant          LIKE type_file.chr10,         #No.FUN-980020
    l_aza RECORD LIKE aza_file.*,
    l_rate           LIKE azj_file.azj03,
   #l_sql            LIKE type_file.chr1000,       #No.FUN-680147 CHAR(1000) #MOD-A10190 mark
    l_sql            STRING,                       #MOD-A10190 
    l_r1,l_r2,l_r3   LIKE azj_file.azj03,
    l_r4,l_r5,l_r6   LIKE azj_file.azj03,
    l_ym             LIKE azj_file.azj02,          #No.FUN-680147 VARCHAR(6)      # YYYYMM
    l_buf            LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(20)
 
#FUN-980020--begin    
    IF cl_null(p_plant) THEN
       LET p_dbs = NULL
    ELSE
       LET g_plant_new = p_plant
       CALL s_getdbs()
       LET p_dbs = g_dbs_new
    END IF
#FUN-980020--end    
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF p_date IS NULL THEN LET p_date=MDY(12,31,9999) END IF
    IF p_dbs IS NULL THEN LET p_dbs='  ' END IF
#-----> Modify By Jones   -------92/12/02---------
# 捉出整體系統參數
    LET l_sql = "SELECT * ",
                #" FROM ",p_dbs CLIPPED,"aza_file " ,
                " FROM ",cl_get_target_table(p_plant,'aza_file'), #FUN-A50102
                " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
    PREPARE aza_pr2 FROM l_sql 
    IF STATUS THEN 
#NO.FUN-720003-------begin
       IF g_bgerr THEN
          CALL s_errmsg('aza01','','aza_pr2',STATUS,1)
       ELSE
          CALL cl_err('aza_pr2',STATUS,1) 
       END IF
#NO.FUN-720003-------end
    END IF
    DECLARE aza_cu2 CURSOR FOR aza_pr2
    OPEN aza_cu2
    FETCH aza_cu2 INTO l_aza.* 
    CLOSE aza_cu2
    IF p_curr = l_aza.aza17 THEN RETURN 1 END IF
#------------------------------------------------
    CASE
      WHEN l_aza.aza19 = '1'		#取每月匯率
          LET l_ym = p_date USING 'yyyymm'
         #FUN-640012...............begin
         #LET l_sql = "SELECT azj03,azj04 ",
         #            " FROM ",p_dbs CLIPPED,"azj_file ",
         #            " WHERE azj01 ='",p_curr,"' AND azj02 ='",l_ym,"' "
          #LET l_sql = "SELECT azj03,azj04,azj051,azj052,azj041,azj05",
          LET l_sql = "SELECT azj03,azj04,azj041,azj051,azj052,azj05",  #NO.FUN-640196
                      #" FROM ",p_dbs CLIPPED,"azj_file ",
                      " FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                      " WHERE azj01 ='",p_curr,"' AND azj02 ='",l_ym,"' "
         #FUN-640012...............end
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
          PREPARE azj_p1 FROM l_sql
          IF STATUS THEN  
#NO.FUN-720003------begin
            IF g_bgerr THEN
               CALL s_errmsg('azj01,azj02','','azj_p1',STATUS,1)
            ELSE
               CALL cl_err('azj_p1',STATUS,1) 
            END IF
#NO.FUN-720003------begin
          END IF
          DECLARE azj_c1 CURSOR FOR azj_p1
          OPEN azj_c1
          FETCH azj_c1 INTO l_r1,l_r2,l_r3,l_r4,l_r5,l_r6
          IF SQLCA.sqlcode THEN  #取不到時, 取最近匯率
              #FUN-640012...............begin
             #-MOD-A10190-add-
             #LET l_sql = "SELECT azj03,azj04,azj041,azj051,azj052,azj05 ",
             #            " FROM ",p_dbs CLIPPED,"azj_file ",
             #            " WHERE azj02 = (SELECT MAX(azj02) ",
             #            "                 FROM ",p_dbs CLIPPED,"azj_file ",
             #            "                 WHERE azj01='",p_curr,"' ",
             #            "                   AND azj02 <='",l_ym  ,"' ) ",
             #           #"  AND azj01='",l_ym  ,"' "   #MOD-810051
             #            "  AND azj01='",p_curr,"' "   #MOD-810051
              LET l_sql = "SELECT MAX(azj02) ",
                          #"  FROM ",p_dbs CLIPPED,"azj_file ",
                          "  FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                          " WHERE azj01='",p_curr,"' ",
                          "   AND azj02 <='",l_ym  ,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              LET l_sql = "SELECT azj03,azj04,azj041,azj051,azj052,azj05 ",
                          #"  FROM ",p_dbs CLIPPED,"azj_file ",
                          "  FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                          " WHERE azj02 = ( ",l_sql," )",
                          "   AND azj01='",p_curr,"' " 
             #-MOD-A10190-end-
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
              PREPARE azj_p2 FROM l_sql
              IF STATUS THEN 
#NO.FUN-720003------begin
                 IF g_bgerr THEN
                    CALL s_errmsg('zaj02,azj01','','azj_p2',STATUS,1)
                 ELSE
                    CALL cl_err('azj_p2',STATUS,1) 
                 END IF
              END IF
#NO.FUN-720003------end
              DECLARE azj_c2 CURSOR FOR azj_p2
              OPEN azj_c2
              FETCH azj_c2 INTO l_r1,l_r2,l_r3,l_r4,l_r5,l_r6
              #FUN-640012...............end
              IF SQLCA.sqlcode THEN
#NO.FUN-720003------begin
                 IF g_bgerr THEN
                    LET g_showmsg=p_curr,'/',l_ym
                    CALL s_errmsg('zaj02,azj01',g_showmsg,l_buf,'aoo-056',0)
                 ELSE
                    CALL cl_err(l_buf,'aoo-056',0)
                 END IF
#                LET l_buf = p_curr,'+',l_ym
#                CALL cl_err(l_buf,'aoo-056',0)
#NO.FUN-720003------end
                 LET l_r1=1.0 
                 LET l_r2=1.0
                 LET l_r3=1.0 #FUN-640012
                 LET l_r4=1.0 #FUN-640012
                 LET l_r5=1.0 #FUN-640012
                 LET l_r6=1.0 #FUN-640012
              END IF
              CLOSE azj_c2
          END IF
          CLOSE azj_c1 
      WHEN l_aza.aza19 = '2'		#取每日匯率
          LET l_sql = "SELECT azk03,azk04,azk041,azk051,azk052,azk05 ",
                      #" FROM ",p_dbs CLIPPED,"azk_file ",
                      " FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                      " WHERE azk01 ='",p_curr,"' AND azk02 ='",p_date,"' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
          PREPARE azk_p1 FROM l_sql
          IF STATUS THEN 
#NO.FUN-720003------begin
             IF g_bgerr THEN
                LET g_showmsg=p_curr,"/",p_date
                CALL s_errmsg('azk01,azk02',g_showmsg,'azk_p1',STATUS,1)
             ELSE
                CALL cl_err('azk_p1',STATUS,1) 
             END IF
          END IF
#NO.FUN-720003------end
          DECLARE azk_c1 CURSOR FOR azk_p1
          OPEN azk_c1
          FETCH azk_c1 INTO l_r1,l_r2,l_r3,l_r4,l_r5,l_r6
	        IF SQLCA.sqlcode THEN	#每日取不到時, 取最近匯率
             #-MOD-A10190-add-
             #LET l_sql = "SELECT azk03,azk04,azk041,azk051,azk052,azk05 ",
             #            " FROM ",p_dbs CLIPPED,"azk_file ",
             #            " WHERE azk02 = (SELECT MAX(azk02) ",
             #            "                 FROM ",p_dbs CLIPPED,"azk_file ",
             #            "                 WHERE azk01='",p_curr,"' ",
             #            "                   AND azk02 <='",p_date,"' ) ",
             #            "  AND azk01='",p_curr,"' "
              LET l_sql = "SELECT MAX(azk02) ",
                          #"  FROM ",p_dbs CLIPPED,"azk_file ",
                          "  FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                          " WHERE azk01='",p_curr,"' ",
                          "   AND azk02 <='",p_date ,"'"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql
              LET l_sql = "SELECT azk03,azk04,azk041,azk051,azk052,azk05 ",
                          #"  FROM ",p_dbs CLIPPED,"azk_file ",
                          "  FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                          " WHERE azk02 = ( ",l_sql," )",
                          "   AND azk01='",p_curr,"' " 
             #-MOD-A10190-end-
 	      CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
          CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
              PREPARE azk_p2 FROM l_sql
              IF STATUS THEN
#NO.FUN-720003------begin
                 IF g_bgerr THEN
                    LET g_showmsg=p_curr,"/",p_date 
                    CALL s_errmsg('azk01,azk02',g_showmsg,'azk_p2',STATUS,1)
                 ELSE
                    CALL cl_err('azk_p2',STATUS,1) 
                 END IF
#NO.FUN-720003-----end   
              END IF
              DECLARE azk_c2 CURSOR FOR azk_p2
              OPEN azk_c2
              FETCH azk_c2 INTO l_r1,l_r2,l_r3,l_r4,l_r5,l_r6
              IF SQLCA.sqlcode THEN	#無最近匯率, 則設為一
#NO.FUN-720003-----begin
                 IF g_bgerr THEN
                    LET g_showmsg=p_curr,"/",p_date
                    CALL s_errmsg('azk01,azk02',g_showmsg,l_buf,'aoo-057',0)
                 ELSE
                    CALL cl_err(l_buf,'aoo-057',0)
#                LET l_buf = p_curr CLIPPED,'+',p_date
#                CALL cl_err(l_buf,'aoo-057',0)
                 END IF
#NO.FUN-720003-----end
                 LET l_r1=1.0 LET l_r2=1.0
                 LET l_r3=1.0 LET l_r4=1.0
                 LET l_r5=1.0 LET l_r6=1.0
	            END IF
              CLOSE azk_c2
          END IF
          CLOSE azk_c1
      OTHERWISE LET l_r1=1 LET l_r2=1
                LET l_r3=1 LET l_r4=1
                LET l_r5=1 LET l_r6=1
    END CASE
    CASE
      WHEN p_bs = 'B' LET l_rate = l_r1
      WHEN p_bs = 'S' LET l_rate = l_r2
      WHEN p_bs = 'M' LET l_rate = l_r3
      WHEN p_bs = 'C' LET l_rate = l_r4
      WHEN p_bs = 'D' LET l_rate = l_r5
      WHEN p_bs = 'T' LET l_rate = l_r6
      OTHERWISE       LET l_rate = 1
    END CASE
    RETURN l_rate
END FUNCTION

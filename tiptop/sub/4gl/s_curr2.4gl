# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Pattern name...: s_curr2.4gl
# Descriptions...: 取得該幣別在該日期或該月份的買入或賣出匯率(多工廠)
# Date & Author..: 2009/11/27 BY lutingting FUN-9B0130 
# Usage..........: LET l_rate=s_curr2(p_curr,p_date,p_bs,p_plant)
# Input Parameter: p_curr    幣別
#                  p_date    日期
#                  p_bs      B:銀行買入 /S:銀行賣出 /C:海關買入 /D:海關賣出
#                  p_plant   營運中心
# Return code....: l_rate    匯率
# Memo...........: 若g_chr='E'則無幣別資料或無每月匯率資料或無每日匯率資料
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"  
 
GLOBALS
    DEFINE g_chr   LIKE type_file.chr1                
    DEFINE g_currflag LIKE type_file.num5              # WHEN TRUE  =>匯率檔取不到匯率資料 ,則匯率回傳1, 並將錯誤訊息回傳給g_errno,由呼叫的程式判斷g_errno,並決定如何處理
                                                       # WHEN FALSE =>匯率檔取不到匯率資料 ,則匯率回傳1, 不回傳任何訊息給g_errno,依照原有程式的處理方式
END GLOBALS
 
FUNCTION s_curr2(p_curr,p_date,p_bs,p_plant)
   DEFINE p_curr           LIKE aza_file.aza17,        #幣別
          p_date           LIKE type_file.dat,         #日期
          p_bs             LIKE type_file.chr1,        #B:買入/S:賣出
          p_plant          LIKE type_file.chr10,       #營運中心
          p_dbs            LIKE type_file.chr21,       #DB
          l_rate           LIKE azj_file.azj03,
          l_r1,l_r2        LIKE azj_file.azj03,
          l_r3,l_r4        LIKE azj_file.azj03,
          l_r5,l_r6        LIKE azj_file.azj03,
          l_r7             LIKE azj_file.azj07,        
          l_ym             LIKE azj_file.azj02,       
          l_msg            LIKE type_file.chr200,    
          l_buf            LIKE type_file.chr200,
          l_sql            LIKE type_file.chr1000    
 
   WHENEVER ERROR CALL cl_err_msg_log
   #FUN-A50102--mark--str--
   #IF cl_null(p_plant) THEN
   #   LET p_dbs = NULL
   #ELSE
   #   LET g_plant_new = p_plant
   #   CALL s_getdbs()
   #   LET p_dbs = g_dbs_new
   #END IF
   #FUN-A50102--mark--end-- 
   IF p_date IS NULL THEN
      LET p_date = MDY(12,31,9999)
   END IF
# 捉出整體系統參數
   #LET l_sql = "SELECT * FROM ",p_dbs CLIPPED,"aza_file ",
   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'aza_file'), #FUN-A50102
               " WHERE aza01 = '0' "
   CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
   CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE sel_aza_pre FROM l_sql
   EXECUTE sel_aza_pre INTO g_aza.*
   IF p_curr = g_aza.aza17 THEN
      RETURN 1
   END IF
#------------------------------------------------
   CASE
      WHEN g_aza.aza19 = '1'            #取每月匯率
         LET l_ym = p_date USING 'yyyymm'
         LET l_sql = "SELECT azj03,azj04,azj051,azj052,azj041,azj05 ",
                     #"  FROM ",p_dbs CLIPPED,"azj_file ",
                     "  FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                     " WHERE azj01 = '",p_curr,"' ",
                     "   AND azj02 = '",l_ym,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102            
         PREPARE sel_azj03_pre FROM l_sql
         EXECUTE sel_azj03_pre INTO l_r1,l_r2,l_r3,l_r4,l_r5,l_r6
         IF SQLCA.sqlcode THEN #取不到時, 取最近匯率
            LET l_sql = "SELECT azj03,azj04,azj051,azj052,azj041,azj05 ",
                        #"  FROM ",p_dbs CLIPPED,"azj_file ",
                        "  FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                        " WHERE azj01 = '",p_curr,"' ",
                        #"   AND azj02 = (SELECT MAX(azj02) FROM ",p_dbs CLIPPED,"azj_file",
                        "   AND azj02 = (SELECT MAX(azj02) FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                        "                 WHERE azj01 = '",p_curr,"' ",
                        "                   AND azj02 <= '",l_ym,"' )"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102 
            PREPARE sel_azj03_pre1 FROM l_sql
            EXECUTE sel_azj03_pre1 INTO l_r1,l_r2,l_r3,l_r4,l_r5,l_r6
            IF SQLCA.sqlcode THEN
               LET l_buf = p_curr,'+',l_ym
               IF g_currflag THEN
                  LET g_errno="aoo-056"
                  RETURN 1
               END IF
               IF g_bgerr THEN
                  CALL s_errmsg("azj01",p_curr,"","aoo-056",0)
               ELSE
                  CALL cl_getmsg('aoo-056',g_lang) RETURNING l_msg
                  LET l_msg=l_buf CLIPPED, " ",l_msg CLIPPED
                  CALL cl_msgany(1,1,l_msg)
               END IF
               LET l_r1 = 1.0
               LET l_r2 = 1.0
               LET l_r3 = 1.0    
               LET l_r4 = 1.0   
               LET l_r5 = 1.0  
               LET l_r6 = 1.0 
            END IF
         END IF
      WHEN g_aza.aza19 = '2'            #取每日匯率
         LET l_sql = "SELECT azk03,azk04,azk051,azk052,azk041,azk05 ",
                     #"  FROM ",p_dbs CLIPPED,"azk_file ",
                     "  FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                     " WHERE azk01 = '",p_curr,"' ",
                     "   AND azk02 = '",p_date,"' " 
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102            
         PREPARE sel_azk03_pre FROM l_sql
         EXECUTE sel_azk03_pre INTO l_r1,l_r2,l_r3,l_r4,l_r5,l_r6
         IF SQLCA.sqlcode THEN      #每日取不到時, 取最近匯率
            LET l_sql = "SELECT azk03,azk04,azk051,azk052,azk041,azk05",
                        #"  FROM ",p_dbs CLIPPED,"azk_file ",
                        "  FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                        " WHERE azk01 = '",p_curr,"' ",
                        #"   AND azk02 = (SELECT MAX(azk02) FROM ",p_dbs CLIPPED,"azk_file",
                        "   AND azk02 = (SELECT MAX(azk02) FROM ",cl_get_target_table(p_plant,'azk_file'), #FUN-A50102
                        "                 WHERE azk01 = '",p_curr,"' ",
                        "                   AND azk02 <= '",p_date,"' )"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
            CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102            
            PREPARE sel_azk03_pre1 FROM l_sql
            EXECUTE sel_azk03_pre1 INTO l_r1,l_r2,l_r3,l_r4,l_r5,l_r6
            IF SQLCA.sqlcode THEN      #無最近匯率, 則設為一
               LET l_buf = p_curr CLIPPED,'+',p_date
               IF g_currflag THEN
                  LET g_errno="aoo-057"
                  RETURN 1
               END IF
               IF g_bgerr THEN
                  CALL s_errmsg("azk01",p_curr,"","aoo-057",0)
               ELSE
                  CALL cl_getmsg('aoo-057',g_lang) RETURNING l_msg
                  LET l_msg=l_buf CLIPPED, " ",l_msg CLIPPED
                  CALL cl_msgany(1,1,l_msg)
               END IF
               LET l_r1 = 1.0
               LET l_r2 = 1.0
               LET l_r3 = 1.0
               LET l_r4 = 1.0
               LET l_r5 = 1.0  
               LET l_r6 = 1.0 
            END IF
         END IF
      OTHERWISE 
         LET l_r1 = 1
         LET l_r2 = 1
         LET l_r3 = 1
         LET l_r4 = 1
         LET l_r5 = 1   
         LET l_r6 = 1  
   END CASE
 
   CASE
      WHEN p_bs = 'B' LET l_rate = l_r1
      WHEN p_bs = 'S' LET l_rate = l_r2
      WHEN p_bs = 'C' LET l_rate = l_r3
      WHEN p_bs = 'D' LET l_rate = l_r4
      WHEN p_bs = 'M' LET l_rate = l_r5
      WHEN p_bs = 'R'   
         LET l_ym = p_date USING 'yyyymm'
         #LET l_sql = "SELECT azj07 FROM ",p_dbs CLIPPED,"azj_file ",
         LET l_sql = "SELECT azj07 FROM ",cl_get_target_table(p_plant,'azj_file'), #FUN-A50102
                     " WHERE azj01 = '",p_curr,"' ",
                     "   AND azj02 = '",l_ym,"' "
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
         PREPARE sel_azj07_pre FROM l_sql
         EXECUTE sel_azj07_pre INTO l_r7
         IF SQLCA.sqlcode THEN
            LET l_r7 = 1.0    
         END IF
          LET l_rate = l_r7       
      OTHERWISE       LET l_rate = 1
   END CASE
 
   RETURN l_rate
 
END FUNCTION
#FUN-9B0130 

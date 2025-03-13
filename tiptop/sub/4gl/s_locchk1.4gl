# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: s_locchk1.4gl
# Descriptions...: 檢查儲位的使用
# Date & Author..: 91/10/04 By Lee
# Usage..........: CALL s_locchk(p_part,p_ware,p_loc,p_dbs) RETURNING l_flag,l_act
# Input Parameter: p_part   料件編號
#                  p_ware   欲檢查之倉庫	 
#                  p_loc    欲檢查之儲位
#                  p_dbs    資料庫名稱
# Return code....: l_falg   1:Yes 0:No
#                  l_act    會計科目
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980059 09/09/10 By arman  將傳入的DB變數改成plant變數
# Modify.........: No:MOD-9B0126 09/11/24 By sabrina INSERT ime_file SQL語法錯誤
# Modify.........: No:FUN-9C0079 09/12/16 By bnlent ime_file 新贈字段賦值及SQL修改
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
 
DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
#FUNCTION s_locchk1(p_part,p_ware,p_loc,p_dbs)      #No.FUN-980059
FUNCTION s_locchk1(p_part,p_ware,p_loc,p_plant)     #No.FUN-980059
DEFINE
    p_part  LIKE ima_file.ima01, #料件
    p_ware  LIKE ime_file.ime01, #倉庫別
    p_loc   LIKE ime_file.ime02, #儲位別
    p_plant   LIKE type_file.chr21,     #No.FUN-980059
    p_dbs   LIKE azp_file.azp03,        #No.FUN-680147 VARCHAR(20)
    l_sql   LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(1000)
    l_imd RECORD LIKE imd_file.*,#倉庫別資料主檔
    l_ime RECORD LIKE ime_file.* #倉庫/存放位罝資料主檔
 
   IF p_loc IS NULL THEN LET p_loc =' ' END IF
 
   #FUN-A50102--mark--str--
   ##NO.FUN-980059 GP5.2 add begin
   #IF cl_null(p_plant) THEN
   #  LET p_dbs = NULL
   #ELSE
   #  LET g_plant_new = p_plant
   #  CALL s_getdbs()
   #  LET p_dbs = g_dbs_new
   #END IF
   ##NO.FUN-980059 GP5.2 add end
   #FUN-A50102--mark--end--
  #LET l_sql="SELECT ime08,ime09 FROM ",p_dbs CLIPPED,".ime_file",     #TQC-950050 MARK                                             
   #LET l_sql="SELECT ime08,ime09 FROM ",s_dbstring(p_dbs),"ime_file",  #TQC-950050 ADD
  LET l_sql="SELECT ime08,ime09 FROM ",cl_get_target_table(p_plant,'ime_file'), #FUN-A50102
             " WHERE ime01='",p_ware,"' AND ime02='",p_loc,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
   PREPARE ime_cur FROM l_sql
   DECLARE ime_curs CURSOR FOR ime_cur
   OPEN ime_curs
   FETCH ime_curs INTO l_ime.ime08,l_ime.ime09
 
   # 若抓不到資料則新增一筆 ime_file
   IF STATUS 
      THEN 
     #LET l_sql = "SELECT * FROM ",p_dbs CLIPPED,".imd_file",      #TQC-950050 MARK                                                 
      #LET l_sql = "SELECT * FROM ",s_dbstring(p_dbs),"imd_file",   #TQC-950050 ADD
    LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
                  " WHERE imd01='",p_ware CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE imd_cur FROM l_sql
      DECLARE imd_curs CURSOR FOR imd_cur
      OPEN imd_curs
      FETCH imd_curs INTO l_imd.*
      IF STATUS 
         THEN 
         CALL cl_err('sel imd_file','mfg9040',1)
         RETURN 0,'' 
      END IF
      INITIALIZE l_ime.* TO NULL
      LET l_ime.ime01 = p_ware
      LET l_ime.ime02 = p_loc
      LET l_ime.ime03 = p_loc
      LET l_ime.ime04 = l_imd.imd10
      LET l_ime.ime05 = l_imd.imd11
      LET l_ime.ime06 = l_imd.imd12
      LET l_ime.ime07 = l_imd.imd13
      LET l_ime.ime08 = '0'
      LET l_ime.ime09 = ''
      LET l_ime.ime10 = l_imd.imd14
      LET l_ime.ime11 = l_imd.imd15
      #No.FUN-9C0079 ..begin
      LET l_ime.ime091 = l_imd.imd081
      LET l_ime.ime13 = l_imd.imd21
      LET l_ime.ime131 = l_imd.imd211
      LET l_ime.ime17 = l_imd.imd17
      IF cl_null(l_ime.ime12) THEN LET l_ime.ime12 = '0' END IF
      IF cl_null(l_ime.ime17) THEN LET l_ime.ime17 = 'N' END IF
      #No.FUN-9C0079 ..end
   
    # LET l_sql="INSERT INTO ",p_dbs CLIPPED,".ime_file VALUES",    #TQC-950050 MARK                                                
      #LET l_sql="INSERT INTO ",s_dbstring(p_dbs),"ime_file VALUES", #TQC-950050 ADD
   LET l_sql="INSERT INTO ",cl_get_target_table(p_plant,'ime_file'),"  VALUES ",   #FUN-A50102    
   " (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,  ?)"      #No:MOD-9B0126 modify #No.FUN-9C0079
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE ime_ins_p FROM l_sql
      EXECUTE ime_ins_p USING l_ime.*
      IF SQLCA.sqlerrd[3]=0 OR STATUS
         THEN
         CALL cl_err('ins ime_file',STATUS,1)
         RETURN 0,''
      END IF
   END IF
   #取得會計科目使用方式及會計科目
   IF l_ime.ime08='1' 
      THEN
     #LET l_sql =" SELECT ima39 FROM ",p_dbs CLIPPED,".ima_file ",    #TQC-950050 MARK                                              
      #LET l_sql =" SELECT ima39 FROM ",s_dbstring(p_dbs),"ima_file ", #TQC-950050 ADD
      LET l_sql =" SELECT ima39 FROM ",cl_get_target_table(p_plant,'ima_file'), #FUN-A50102 
                 "  WHERE ima01='",p_part CLIPPED,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
      PREPARE ima_cur FROM l_sql
      DECLARE ima_curs CURSOR FOR ima_cur
      OPEN ima_curs
      FETCH ima_curs INTO l_ime.ime09
   ELSE
      IF l_ime.ime08='0' THEN LET l_ime.ime09='' END IF
   END IF
 
   RETURN 1,l_ime.ime09
 
END FUNCTION

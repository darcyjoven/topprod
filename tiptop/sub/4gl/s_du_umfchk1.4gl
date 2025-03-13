# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_du_umfchk1.4gl
# Descriptions...: 兩單位間之轉換率計算與檢查(Just For 雙單位)
# Date & Author..: 05/07/25 By Carrier
# Usage..........: CALL s_du_umfchk1(p_item,p_ware,p_lot,p_loc,p_img09,p_unit,
#                                    p_n,p_azp03)
#                       RETURNING l_fac
# Input Parameter: p_item  料件
#                  p_ware  倉庫
#                  p_lot   儲位
#                  p_loc   批號
#                  p_img09 目的單位
#                  p_unit  來源單位
#                  p_n     1.子單位(第一單位)  2.母單位  3.參考單位
#                  p_azp03
# Return code....: l_errno errno
#                  l_fac   轉換率
# Memo...........:
# ex. s_du_umfchk1('C001','','','','PCS','DOT','1','ds')  #只傳單位
# ex. s_du_umfchk1('C001','1001','','','','DOT','2','ds') #用倉儲批來select img09
# p_n 1.子單位一定要與img09有換算率
#     2.母單位一定要與img09有換算率
#     3.參考單位不一定要與img09有換算率
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換 
# Modify.........: No.FUN-6C0017 06/12/14 By jamie 程式開頭增加'database ds'
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring()  
# Modify.........: No.FUN-980059 09/09/10 By arman  將傳入的DB變數改成plant變數
# Modify.........: No.FUN-980094 09/09/24 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No:MOD-970044 09/11/26 By sabrina l_sql字串後應再加上 CALL cl_replace_sqldb(l_sql)
# Modify.........: No.FUN-A50102 10/06/25 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds        #FUN-6C0017
 
GLOBALS "../../config/top.global"    #FUN-7C0053
 
#FUNCTION s_du_umfchk1(p_item,p_ware,p_lot,p_loc,p_img09,p_unit,p_n,p_azp03)  #No.FUN-980059
FUNCTION s_du_umfchk1(p_item,p_ware,p_lot,p_loc,p_img09,p_unit,p_n,p_plant)   #No.FUN-980059
   DEFINE  p_item     LIKE img_file.img01,
           p_ware     LIKE img_file.img02,
           p_lot      LIKE img_file.img03,
           p_loc      LIKE img_file.img04,
           p_img09    LIKE img_file.img09,
           p_unit     LIKE img_file.img09,
           p_n        LIKE type_file.chr1,          #No.FUN-680147 VARCHAR(01)
           p_azp03    LIKE azp_file.azp03,
           p_azp03_tra    LIKE azp_file.azp03,      #No.FUN-980059
           p_plant    LIKE azp_file.azp01,          #No.FUN-980059   
           l_azp03    LIKE azp_file.azp03,
           l_azp01    LIKE azp_file.azp01,          #No.FUN-980059
           l_sql      LIKE type_file.chr1000,       #No.FUN-680147 VARCHAR(600)
           l_gfe      RECORD LIKE gfe_file.*,
           l_errno    LIKE cre_file.cre08,          #No.FUN-680147 VARCHAR(10)
           l_flag     LIKE type_file.num5,          #No.FUN-680147 SMALLINT
           l_factor   LIKE oeb_file.oeb12,          #No.FUN-680147 DECIMAL(16,8)
           l_su       LIKE oeb_file.oeb12,          #No.FUN-680147 DECIMAL(16,8)  #來源單位兌換數量
           l_tu       LIKE oeb_file.oeb12           #No.FUN-680147 DECIMAL(16,8)  #目的單位兌換數量
 
       ##NO.FUN-980059 GP5.2 add begin
        IF cl_null(p_plant) THEN
          LET p_azp03 = NULL
        ELSE
          LET g_plant_new = p_plant
          CALL s_getdbs()
          CALL s_gettrandbs()
          LET p_azp03 = g_dbs_new
          LET p_azp03_tra = g_dbs_tra
        END IF
       ##NO.FUN-980059 GP5.2 add end
     LET l_errno = ''
     #....加入MISC的判斷
     IF p_item[1,4]='MISC' THEN RETURN l_errno,1.0 END IF
     #無料號
     IF cl_null(p_item) THEN LET l_errno = 'aim-701' RETURN l_errno,0 END IF
     #倉庫與目的單位均為空
     IF cl_null(p_ware) AND cl_null(p_img09) THEN
        LET l_errno = 'aim-702'
        RETURN l_errno,0
     END IF
     #沒有傳來源單位
     IF cl_null(p_unit) THEN LET l_errno = 'aim-705' RETURN l_errno,0 END IF
 
     #倉庫確定的單位是不正確的
     IF cl_null(p_img09) THEN
      # LET l_sql=" SELECT img09 FROM ",p_azp03 CLIPPED,".img_file",   #TQC-950050 MARK                                             
        #LET l_sql=" SELECT img09 FROM ",s_dbstring(p_azp03),"img_file",#TQC-950050 ADD    #FUN-980094 mark   
        #LET l_sql=" SELECT img09 FROM ",p_azp03_tra,"img_file",#TQC-950050 ADD      #FUN-980094 add
        LET l_sql=" SELECT img09 FROM ",cl_get_target_table(p_plant,'img_file'), #FUN-A50102
                  "  WHERE img01='",p_item ,"'",
                  "    AND img02='",p_ware ,"'",
                  "    AND img04='",p_loc  ,"'",#No.FUN-570249
                  "    AND img03='",p_lot  ,"'" #No.FUN-570249
        CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #No:MOD-970044 add
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980094
        PREPARE s_pre1 FROM l_sql
        DECLARE s_cur1  CURSOR FOR s_pre1
        OPEN s_cur1 
        FETCH s_cur1 INTO p_img09 
        IF SQLCA.sqlcode THEN
           LET l_errno = 'aim-703'
           RETURN l_errno,0
        END IF
     END IF
     #目的單位不正確
    #LET l_sql="SELECT * FROM ",p_azp03 CLIPPED,".gfe_file",    #TQC-950050 MARK                                                    
     #LET l_sql="SELECT * FROM ",s_dbstring(p_azp03),"gfe_file", #TQC-950050 ADD
     LET l_sql="SELECT * FROM ",cl_get_target_table(p_plant,'gfe_file'), #FUN-A50102
               " WHERE gfe01 = '",p_img09,"' AND gfeacti ='Y'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #No:MOD-970044 add
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE s_pre2 FROM l_sql
     DECLARE s_cur2  CURSOR FOR s_pre2
     OPEN s_cur2 
     FETCH s_cur2 INTO l_gfe.* 
     IF SQLCA.sqlcode THEN
        LET l_errno = 'aim-704'
        RETURN l_errno,0
     END IF
     #來源單位不正確
    #LET l_sql="SELECT * FROM ",p_azp03 CLIPPED,".gfe_file",     #TQC-950050 MARK                                                   
     #LET l_sql="SELECT * FROM ",s_dbstring(p_azp03),"gfe_file",  #TQC-950050 ADD
     LET l_sql="SELECT * FROM ",cl_get_target_table(p_plant,'gfe_file'), #FUN-A50102
               " WHERE gfe01 = '",p_unit ,"' AND gfeacti ='Y'"
     CALL cl_replace_sqldb(l_sql) RETURNING l_sql    #No:MOD-970044 add
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
     PREPARE s_pre3 FROM l_sql
     DECLARE s_cur3  CURSOR FOR s_pre3
     OPEN s_cur3 
     FETCH s_cur3 INTO l_gfe.* 
     IF SQLCA.sqlcode THEN
        LET l_errno = 'aim-705'
        RETURN l_errno,0
     END IF
 
     IF p_img09 = p_unit THEN RETURN l_errno,1 END IF
     LET l_azp03 = s_madd_img_catstr(p_azp03)
     LET l_azp01 = s_madd_img_catstr(p_plant)     #No.FUN-980059
     #CALL s_umfchk1(p_item,p_unit,p_img09,l_azp01)    #No.FUN-980059 #FUN-980094 mark
     CALL s_umfchk1(p_item,p_unit,p_img09,p_plant)    #No.FUN-980059 #FUN-980094 add
          RETURNING l_flag,l_factor
 
     IF p_n = '1' OR p_n = '2' THEN   #子單位/母單位
        IF l_flag = 1 THEN
           IF g_prog MATCHES 'aim*' THEN
              LET l_errno = 'mfg3075'
           END IF
           IF g_prog MATCHES 'axm*' THEN
              LET l_errno = 'amr-074'
           END IF
           IF g_prog MATCHES 'apm*' THEN
              LET l_errno = 'apm-288'
           END IF
           RETURN l_errno,0
        ELSE
           RETURN l_errno,l_factor
        END IF
     ELSE                             #參考單位
        IF cl_null(l_factor) THEN
           LET l_factor = 1
        END IF
        RETURN l_errno,l_factor
     END IF
END FUNCTION

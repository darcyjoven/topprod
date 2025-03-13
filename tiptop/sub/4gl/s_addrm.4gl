# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Program name...: s_addrm.4gl
# Descriptions...: 
# Date & Author..: 
# Modify.........: No.FUN-560002 05/06/03 By wujie 單據編號修改
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-720014 07/04/09 By rainy 地址欄位擴充為5欄
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980020 09/08/31 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds   #FUN-7C0053
GLOBALS "../../config/top.global"   #FUN-980020
 
#FUNCTION s_addrm(p_no,p_cus_no,p_add_no,p_dbs)     #FUN-980020 mark
FUNCTION s_addrm(p_no,p_cus_no,p_add_no,p_plant)    #FUN-980020
    DEFINE p_no,p_cus_no,p_add_no	LIKE oap_file.oap01          #No.FUN-560002 	#No.FUN-680147 VARCHAR(16)
    DEFINE l_add1,l_add2,l_add3		LIKE occ_file.occ241         #No.FUN-680147  VARCHAR(36)
    DEFINE l_add4,l_add5		LIKE occ_file.occ241         #No.FUN-720014
    DEFINE p_dbs   LIKE type_file.chr21  	#No.FUN-680147 VARCHAR(21)
    DEFINE l_sql   LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(600)
    DEFINE p_plant LIKE type_file.chr10         #No.FUN-980020
 
#FUN-A50102--mark--str--
 #FUN-980020--begin
    #IF cl_null(p_plant) THEN
    #   LET p_dbs = NULL
    #ELSE
    #   LET g_plant_new = p_plant
    #   CALL s_getdbs()
    #   LET p_dbs = g_dbs_new
   # END IF
#FUN-980020--end
#FUN-A50102--mark--end--
 
    CASE WHEN p_add_no IS NULL  
           LET l_sql = " SELECT occ241,occ242,occ243,occ244,occ245 ", #FUN-720014
                       #" FROM ", p_dbs CLIPPED , " occ_file " ,
                       " FROM ", cl_get_target_table(p_plant,'occ_file'), #FUN-A50102
                       " WHERE  occ01 = '",p_cus_no ,"'"
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
           PREPARE occ_pre FROM l_sql
           IF STATUS THEN CALL cl_err('occ_pre',STATUS,1) END IF
           DECLARE occ_cus CURSOR FOR occ_pre
           OPEN occ_cus
           FETCH occ_cus INTO  l_add1,l_add2,l_add3,l_add4,l_add5  #FUN-720014
         WHEN p_add_no = 'MISC' 
           LET l_sql = " SELECT oap041,oap042,oap043,oap044,oap045 ",  #FUN-720014
                       #" FROM ", p_dbs CLIPPED , " oap_file " ,
                       " FROM ", cl_get_target_table(p_plant,'oap_file'), #FUN-A50102
                       " WHERE  oap01 = '",p_no ,"'"
           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
           PREPARE oap_pre FROM l_sql
           IF STATUS THEN CALL cl_err('oap_pre',STATUS,1) END IF
           DECLARE oap_cus CURSOR FOR oap_pre
           OPEN oap_cus
           FETCH oap_cus INTO  l_add1,l_add2,l_add3,l_add4,l_add5  #FUN-720014
         OTHERWISE 
           LET l_sql = " SELECT ocd221,ocd222,ocd223,ocd230,ocd231 ",  #FUN-720014
                       #" FROM ", p_dbs CLIPPED , " ocd_file " ,
                       " FROM ", cl_get_target_table(p_plant,'ocd_file'), #FUN-A50102
                       " WHERE  ocd01 = '",p_cus_no ,"'",
                       "   AND  ocd02 ='",p_add_no,"' "
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
           CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
           PREPARE ocd_pre FROM l_sql
           IF STATUS THEN CALL cl_err('ocd_pre',STATUS,1) END IF
           DECLARE ocd_cus CURSOR FOR ocd_pre
           OPEN ocd_cus
           FETCH ocd_cus INTO  l_add1,l_add2,l_add3,l_add4,l_add5  #FUN-720014
    END CASE
    RETURN l_add1,l_add2,l_add3,l_add4,l_add5   #FUN-720014
 
END FUNCTION

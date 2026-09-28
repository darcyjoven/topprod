# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: s_stkchk2.4gl
# Descriptions...: 檢查倉庫的使用
# Date & Author..: 95/06/28 by nick
# Usage..........: IF NOT s_stkchk2(p_plant,p_stock,p_type)
# Input Parameter: p_stock   欲檢查之倉庫	 
#                  p_type    是否使用預設倉庫
# Return code....: 1   Yes
#                  0   No
# Memo...........: 本隻程式增加多工廠的檢查,其它與原程式s_stkchk完全一樣
# Modify.........: No.FUN-680147 06/09/01 By hongmei 欄位類型轉換
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.TQC-950050 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.FUN-980020 09/09/08 By douzh GP集團架構修改,sub相關參數
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
FUNCTION s_stkchk2(p_plant,p_stock,p_type)
 
#DEFINE p_plant  LIKE azp_file.azp03,  #NO:4292 #FUN-980020 mark
DEFINE p_plant  LIKE azp_file.azp01,   #FUN-980020 
       p_dbs    LIKE azp_file.azp03,   #FUN-980020
       p_stock  LIKE imd_file.imd01,
       p_type   LIKE type_file.chr1,         #No.FUN-680147 VARCHAR(1) #倉庫性質
       l_sql    LIKE type_file.chr1000       #No.FUN-680147 VARCHAR(1000)
 
 #FUN-A50102--mark--str--
#FUN-980020--begin    
    #IF cl_null(p_plant) THEN
    #   LET p_dbs = NULL
    #ELSE
    #   LET g_plant_new = p_plant
    #   CALL s_getdbs()
    #   LET p_dbs = g_dbs_new
    #END IF
#FUN-980020--end 
#FUN-A50102--mark--end--   
 
    WHENEVER ERROR CALL cl_err_msg_log 
 
#系統參數允許隨時增加, 不做任何檢查,
#   IF g_sma.sma41 ='3' THEN
#       RETURN 1
#   END IF
 
    #系統參數設定為使用預先倉庫資料
    IF p_type = 'A' THEN
       #LET l_sql="SELECT imd01 FROM ",p_plant CLIPPED,".dbo.imd_file",     #TQC-950050 MARK                                            
       #LET l_sql="SELECT imd01 FROM ",s_dbstring(p_plant),"imd_file",  #TQC-950050 ADD #FUN-980020 mark 
        #LET l_sql="SELECT imd01 FROM ",p_dbs,"imd_file",    #FUN-980020 add
        LET l_sql="SELECT imd01 FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
			  " WHERE imd01='",p_stock,"' AND imdacti='Y'"
    ELSE
       #LET l_sql="SELECT imd01 FROM ",p_plant CLIPPED,".dbo.imd_file",       #TQC-950050 MARK                                          
       #LET l_sql="SELECT imd01 FROM ",s_dbstring(p_plant),"imd_file",    #TQC-950050 ADD #FUN-980020 mark     
        #LET l_sql="SELECT imd01 FROM ",p_dbs,"imd_file",      #FUN-980020 add
        LET l_sql="SELECT imd01 FROM ",cl_get_target_table(p_plant,'imd_file'), #FUN-A50102
              " WHERE imd01=p_stock AND imdacti='Y' AND",
                    " imd10='",p_type,"'"
    END IF
    CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
	PREPARE s_p FROM l_sql
        DECLARE s_pre CURSOR FOR s_p           
    IF SQLCA.sqlcode THEN
        RETURN 0
    END IF
    RETURN 1
END FUNCTION

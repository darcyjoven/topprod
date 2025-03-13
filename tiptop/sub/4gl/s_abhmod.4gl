# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Program name...: s_abhmod.4gl
# Descriptions...: 
# Date & Author..: 
# Usage..........: 
# Modify.........: No.FUN-640004 06/04/05 By Tracy  賬別位數擴大到5碼 
# Modify.........: NO.FUN-670091 06/08/01 BY rainy cl_err->cl_err3
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980020 08/08/30 By douzh GP集團架構
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: NO.MOD-AA0047 10/10/11 BY Dido 增加帳別條件
# Modify.........: NO.MOD-B50252 11/06/01 BY Dido 調整 USING 增加帳別 
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_abhmod(p_dbs_gl,p_bookno,p_aba01)   #FUN-980020  mark
FUNCTION s_abhmod(p_plant,p_bookno,p_aba01)     #FUN-980020
   DEFINE p_dbs_gl    LIKE type_file.chr21,     #GL工廠別 	#No.FUN-680147 VARCHAR(21)
          p_plant     LIKE type_file.chr10,     #營運中心       #FUN-980020
#         p_bookno    LIKE aba_file.aba18,      #GL帳別  	#No.FUN-680147 VARCHAR(2)
          p_bookno    LIKE abh_file.abh00,      #No.FUN-640004
          p_aba01     LIKE aba_file.aba01,      #傳票編號
          l_msg       LIKE type_file.chr1000,	#No.FUN-680147 VARCHAR(70)
          l_flag      LIKE type_file.chr1,   	#No.FUN-680147 VARCHAR(1)
          l_abg071    LIKE abg_file.abg071,
          l_abh       RECORD LIKE abh_file.*,
          l_abh09_2,l_abh09_3  LIKE abh_file.abh09,
          l_sql       LIKE type_file.chr1000	#No.FUN-680147 VARCHAR(1000)
 
#FUN-980020--begin
     LET g_plant_new =  p_plant 
     CALL s_getdbs()
     LET p_dbs_gl = g_dbs_new
#FUN-980020--end
 
     #LET l_sql = " SELECT sum(abh09) FROM ",p_dbs_gl,"abh_file",
     LET l_sql = " SELECT sum(abh09) FROM ",cl_get_target_table(g_plant_new,'abh_file'), #FUN-A50102
                 "  WHERE abhconf = ? AND abh07 = ? ",
                 "    AND abh08 = ? ",
                 "    AND abh00 = ? "                           #MOD-AA0047
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE abhmod_presum FROM l_sql
     DECLARE abhmod_cursum  CURSOR FOR  abhmod_presum
 
     #LET l_sql = " SELECT ",p_dbs_gl,"abh_file.* ",
     #            " FROM ",p_dbs_gl,"abh_file",
     LET l_sql = " SELECT ",cl_get_target_table(g_plant_new,'abh_file'),".*", #FUN-A50102
                 "   FROM ",cl_get_target_table(g_plant_new,'abh_file'),      #FUN-A50102
                 "  WHERE abh00 = '",p_bookno,"'",
                 "    AND abh01 = '",p_aba01 ,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
     PREPARE abhmod_pre FROM l_sql
     DECLARE abhmod_cur  CURSOR FOR abhmod_pre
 
     FOREACH abhmod_cur INTO l_abh.*
        IF SQLCA.sqlcode THEN 
           CALL cl_err('abh_mod',SQLCA.sqlcode,0)
           LET g_success = 'N'
           EXIT FOREACH 
        END IF     
        #-->delete abh_file
         #LET l_sql="DELETE FROM ",p_dbs_gl,"abh_file",
         LET l_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'abh_file'),      #FUN-A50102
                   "  WHERE abh00 = '",l_abh.abh00,"'",
                   "    AND abh01 = '",l_abh.abh01,"'",
                   "    AND abh02 = '",l_abh.abh02,"'",
                   "    AND abh06 = '",l_abh.abh06,"'",
                   "    AND abh07 = '",l_abh.abh07,"'",
                   "    AND abh08 = '",l_abh.abh08,"'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
         PREPARE abh_predel FROM l_sql
           IF SQLCA.sqlcode THEN 
             CALL cl_err('abh_predel',SQLCA.sqlcode,0)
             LET g_success = 'N'
             EXIT FOREACH 
           END IF     
         EXECUTE abh_predel
           IF SQLCA.sqlcode THEN 
             CALL cl_err('execute abh_predel',SQLCA.sqlcode,0)
             LET g_success = 'N'
             EXIT FOREACH 
           END IF     
 
         LET l_flag = 'Y'
         OPEN abhmod_cursum USING l_flag,l_abh.abh07,l_abh.abh08,p_bookno #MOD-AA0047 add p_bookno
         FETCH abhmod_cursum INTO l_abh09_2
         IF cl_null(l_abh09_2) THEN LET l_abh09_2 = 0 END IF
 
         LET l_flag = 'N'
         OPEN abhmod_cursum USING l_flag,l_abh.abh07,l_abh.abh08,p_bookno #MOD-B50252 add p_bookno
         FETCH abhmod_cursum INTO l_abh09_3
         IF cl_null(l_abh09_3) THEN LET l_abh09_3 = 0 END IF
 
         UPDATE abg_file SET abg072 = l_abh09_2,
                             abg073 = l_abh09_3
                         WHERE abg00 = p_bookno 
                           AND abg01 = l_abh.abh07
                           AND abg02 = l_abh.abh08
         IF SQLCA.sqlcode THEN 
            LET l_msg = l_abh.abh07,'-',l_abh.abh08 using '##&' clipped
            #CALL cl_err(l_msg,'agl-909',0)    #FUN-670091
            CALL cl_err3("upd","abg_file",l_abh.abh07,l_abh.abh08,'agl-909',"","",0) #FUN-670091
            LET g_success = 'N' 
            EXIT FOREACH 
         END IF
     END FOREACH 
END FUNCTION

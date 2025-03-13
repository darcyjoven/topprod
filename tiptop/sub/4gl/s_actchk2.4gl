# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Program name...: s_actchk2.4gl
# Descriptions...: 檢查總帳會計科目與會計說明
# Date & Author..: 92/12/16 By Pin
# Usage..........: CALL s_actchk2(p_act) RETURNNING l_status,l_aag02
# Input Parameter: p_act     欲檢查之會計科目
# Return Code....: l_status  檢查結果
#                     1        Yes
#                     0         No
#                   l_aag02   會計科目說明
# Modify.........: 99/08/03 By Kammy(加判斷sma87)
# Modify.........: No.MOD-650106 06/05/26 By Claire g_dbs[21,21]->p_dbs[21,21]
# Modify.........: No.FUN-680147 06/09/01 By johnray 欄位型態定義,改為LIKE
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-7B0012 07/11/07 By Carrier db分隔符,call s_dbstring()處理
# Modify.........: No.FUN-820017 08/02/15 By alex 修正 s_dbstring用法
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_actchk2(p_act,p_dbs,p_bookno)  #No.FUN-730020
FUNCTION s_actchk2(p_act,l_plant,p_bookno)   #FUN-A50102
DEFINE
    l_acti    LIKE aag_file.aagacti,      #No.FUN-680147 VARCHAR(1)
    l_sql     LIKE type_file.chr1000,     #No.FUN-680147 VARCHAR(1000)
    p_dbs     LIKE type_file.chr21,       #No.FUN-680147 VARCHAR(21)
    p_bookno  LIKE aag_file.aag00,        #No.FUN-730020
    p_act     LIKE aag_file.aag01,        #No.FUN-680147 VARCHAR(24)
    l_aag02   LIKE aag_file.aag02,
    l_plant   LIKE type_file.chr21       #No.FUN-A50102
 
    WHENEVER ERROR CALL cl_err_msg_log
    IF g_sma.sma87 IS NOT NULL AND g_sma.sma87 != g_plant THEN
       #SELECT azp03 INTO p_dbs FROM azp_file   #FUN-A50102
       # WHERE azp01=g_sma.sma87                #FUN-A50102
       #LET g_dbs[21,21]=':'  #MOD-650106 mark
        #No.FUN-7B0012  --Begin
        #LET p_dbs[21,21]=':'  #MOD-650106
        #LET p_dbs=p_dbs CLIPPED,s_dbstring()
        #LET p_dbs=s_dbstring(p_dbs CLIPPED)     #FUN-820017 #FUN-A50102
        #No.FUN-7B0012  --End
        LET l_plant = g_sma.sma87   #FUN-A50102
    ELSE
        #LET p_dbs=' '              #FUN-A50102
        LET l_plant = ' '           #FUN-A50102
    END IF
    #LET l_sql=" SELECT aagacti,aag02 FROM ",p_dbs CLIPPED,"aag_file",
    LET l_sql=" SELECT aagacti,aag02 FROM ",cl_get_target_table(l_plant,'aag_file'), #FUN-A50102
              " WHERE aag01='",p_act,"'",
              "   AND aag00='",p_bookno,"'"   #No.FUN-730020
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,l_plant) RETURNING l_sql #FUN-A50102
        PREPARE aag_scur FROM l_sql
        DECLARE aag_cur1 CURSOR FOR aag_scur      
        OPEN aag_cur1
        FETCH aag_cur1 INTO l_acti,l_aag02
	CASE
              WHEN SQLCA.SQLCODE = 100
                   LET g_errno='mfg9086'
              WHEN l_acti='N'
                   LET g_errno='9028'
              OTHERWISE
                   LET g_errno=SQLCA.sqlcode USING '----------'
        END CASE
        IF NOT cl_null(g_errno) THEN RETURN 0,' ' END IF
        RETURN 1,l_aag02
END FUNCTION

# Prog. Version..: '5.30.06-13.03.12(00005)'     #
#
# Pattern name...: s_mchkARAP.4gl
# Descriptions...: 多角貿易檢查各工廠是否已立AR/AP
# Date & Author..: 03/09/15 BY Kammy
# Usage..........: CALL s_mchkARAP(p_db,p_flow99) RETURNING l_rs
# Input Parameter: p_flow    流程代號
#                  p_flow99  多角序號
# Return code....: l_status  0:OK 1:NG 
# Modify.........: No.MOD-680014 06/08/11 claire 1.傳3(1)AR_prepare 多oma00='21(12)'此條件　＃21(12).退貨折讓待抵(入庫)
#                                             2.傳3(1)AP_prepare 多apa00='21(12)'此條件　＃21(12).折讓(入庫)
# Modify.........: No.TQC-680045 06/08/15 claire p_flow define like oma99
# Modify.........: No.TQC-680067 06/08/22 claire 傳1 AP_prepare 多apa00='(11)'此條件　＃(11).入庫
# Modify.........: No.FUN-680147 06/09/15 By czl 欄位型態定義,改為LIKE
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-980059 09/09/10 By arman  將傳入的DB變數改成plant變數
# Modify.........: No:MOD-9A0131 09/10/20 By Dido 增加跨資料庫語法
# Modify.........: No.FUN-A50102 10/06/29 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現 
 
DATABASE ds    #FUN-7C0053
 
GLOBALS "../../config/top.global"    #FUN-980059
 
#FUNCTION s_mchkARAP(p_db,p_flow99,p_code)   #檢查AP/AR   #MOD-680014 modify    #No.FUN-980059
FUNCTION s_mchkARAP(p_plant,p_flow99,p_code)   #檢查AP/AR   #MOD-680014 modify  #No.FUN-980059 
DEFINE  p_db     LIKE type_file.chr21,         #No.FUN-680147 VARCHAR(21)   #No.8900
        p_plant  LIKE type_file.chr21,     #No.FUN-980059
        p_code   LIKE type_file.chr1,          # Prog. Version..: '5.30.06-13.03.12(01)   #MOD-680014 add
        p_flow99 LIKE oma_file.oma99 #TQC-680045 modify VARCHAR(15)
DEFINE  l_count  LIKE type_file.num5,          #No.FUN-680147 SMALLINT
        l_code   LIKE oma_file.oma00,           # Prog. Version..: '5.30.06-13.03.12(02)   #MOD-680014 add
        l_sql    LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(500)
 
       ##NO.FUN-980059 GP5.2 add begin
        IF cl_null(p_plant) THEN
          LET p_db = NULL
        ELSE
          LET g_plant_new = p_plant
          CALL s_getdbs()
          CALL s_gettrandbs()
          LET p_db = g_dbs_new
        END IF
       ##NO.FUN-980059 GP5.2 add end
       #MOD-680014-begin-add
        CASE p_code
           WHEN '1' LET l_code='12'
           WHEN '3' LET l_code='21'
        END CASE 
       #MOD-680014-end-add
        LET l_count = 0
        #LET l_sql = "SELECT count(*) FROM ",p_db CLIPPED ,"oma_file ",
        LET l_sql = "SELECT count(*) FROM ",cl_get_target_table(p_plant,'oma_file'), #FUN-A50102
                    " WHERE oma99 = '",p_flow99,"'"
                   ,"   AND oma00 = '",l_code,"' "    #MOD-680014 add
	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#MOD-9A0131
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE AR_prepare FROM l_sql
        DECLARE AR_cs CURSOR FOR AR_prepare
        OPEN  AR_cs
        FETCH AR_cs INTO l_count
        CLOSE AR_cs
        IF l_count > 0 THEN
           CALL cl_err(p_db,'apm-256',1)  #已立帳
           RETURN 1
        END IF
 
       #MOD-680067-begin-add
        CASE p_code
           WHEN '1' LET l_code='11'  
           WHEN '3' LET l_code='21'
        END CASE 
       #MOD-680067-end-add
 
        #LET l_sql = "SELECT count(*) FROM ",p_db CLIPPED ,"apa_file",
        LET l_sql = "SELECT count(*) FROM ",cl_get_target_table(p_plant,'apa_file'), #FUN-A50102
                    " WHERE apa99 = '",p_flow99,"'"
                   ,"   AND apa00 = '",l_code,"'"    #MOD-680014 add
	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql		#MOD-9A0131
        CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
        PREPARE AP_prepare FROM l_sql
        DECLARE AP_cs CURSOR FOR AP_prepare
        OPEN  AP_cs
        FETCH AP_cs INTO l_count
        CLOSE AP_cs
        IF l_count > 0 THEN
            CALL cl_err(p_db,'apm-256',1)  #已立帳
            RETURN 1
        END IF
 
     RETURN 0
END FUNCTION

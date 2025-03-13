# Prog. Version..: '5.30.06-13.03.12(00006)'     #
#
# Pattern name...: s_m_aag.4gl
# Descriptions...: 多工廠環境總帳系統科目檢查
# Date & Author..: 
# Usage..........: CALL s_m_aag(p_dbs,p_actno) RETURNING l_act
# Input Parameter: p_dbs    總帳工廠 dbs name
#                  p_actno  會計科目
# Return code....: l_act    科目編號
# Memo...........: 檢查g_errno看是否有誤
# Modify.........: No.FUN-680147 06/09/04 By chen 類型轉換
# Modify.........: No.FUN-730020 07/03/15 By Carrier 會計科目加帳套
# Modify.........: No.TQC-740137 07/04/20 By Carrier 檢查科目性質及統制明細別
# Modify.........: No.FUN-7C0053 07/12/17 By alex 修改說明only
# Modify.........: No.FUN-990069 09/09/23 By baofei GP集團架構修改,sub相關參數 
# Modify.........: No.FUN-B90023 11/10/18 By xujing DEFINE l_aag02 LIKE nma_file.nma04改為LIKE aag_file.aag02
 
DATABASE ds
 
GLOBALS "../../config/top.global"   #FUN-7C0053
 
#FUNCTION s_m_aag(p_dbs,p_actno,p_bookno)  #No.FUN-730020
FUNCTION s_m_aag(p_plant,p_actno,p_bookno)  #No.FUN-730020  #FUN-980020
        DEFINE p_plant          LIKE type_file.chr10          #No.FUN-990069 
	DEFINE p_dbs		LIKE type_file.chr21          #No.FUN-680147 VARCHAR(21) 	#總帳工廠 dbs name
	DEFINE p_actno		LIKE aab_file.aab01           #No.FUN-680147 VARCHAR(24)					#
        DEFINE p_bookno         LIKE aag_file.aag00           #No.FUN-730020
	DEFINE l_sql		LIKE type_file.chr1000        #No.FUN-680147 VARCHAR(1000)
        DEFINE l_aag02 		LIKE aag_file.aag02           #No.FUN-680147 VARCHAR(30)     #FUN-B90023 MOD
        DEFINE l_aag03          LIKE aag_file.aag03           #No.TQC-740137
        DEFINE l_aag07          LIKE aag_file.aag07           #No.TQC-740137
        DEFINE l_aagacti        LIKE aag_file.aagacti         #No.FUN-680147 VARCHAR(1)
 
#FUN-990069--begin                                                                                                                  
    IF cl_null(p_plant) THEN                                                                                                        
       LET p_dbs = NULL                                                                                                             
    ELSE                                                                                                                            
       LET g_plant_new = p_plant                                                                                                    
       CALL s_getdbs()                                                                                                              
       LET p_dbs = g_dbs_new                                                                                                        
    END IF                                                                                                                          
#FUN-990069--end   
	WHENEVER ERROR CALL cl_err_msg_log
	LET g_errno = ' '
	LET l_sql = "SELECT aag02,aagacti,aag03,aag07 FROM ",p_dbs,  #No.TQC-740137
                     "aag_file WHERE aag01 = ?",
                     "  AND aag00 = ? "  #No.FUN-730020
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
	PREPARE s103_p1 FROM l_sql
	DECLARE s103_c1 CURSOR FOR s103_p1
	OPEN s103_c1 USING p_actno,p_bookno   #No.FUN-730020
	FETCH s103_c1 INTO l_aag02,l_aagacti,l_aag03,l_aag07   #No.TQC-740137
        #No.TQC-740137  --Begin
        CASE #WHEN SQLCA.SQLCODE = 0 
             #     IF l_aagacti = 'Y' THEN 
             #        EXIT CASE
             #     ELSE
             #        LET g_errno = '9028'
             #     END IF
             WHEN l_aag03 = '4'       LET g_errno = 'agl-177'
             WHEN l_aag07 = '1'       LET g_errno = 'agl-015'
             WHEN SQLCA.SQLCODE = 100 LET g_errno = 'anm-001'
             WHEN l_aagacti = 'N'     LET g_errno = '9028'
             WHEN SQLCA.SQLCODE != 0  LET g_errno = SQLCA.SQLCODE USING '-------'
        END CASE
        #No.TQC-740137  --End  
	RETURN l_aag02
END FUNCTION

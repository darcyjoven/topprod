# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Date & Author..: 05/07/25 By Elva 
# Modify.........: No.FUN-5A0124 05/10/20 By elva 刪除帳款資料時刪除oov_file
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680022 06/08/18 By Tracy 多帳期修改   
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-730032 07/03/20 By Elva 新增nme21,nme22,nme23,nme24
# Modify.........: No.TQC-7B0043 07/11/12 By wujie 取消審核時直接付款未更新omc13
# Modify.........: No.TQC-7B0092 07/11/16 By wujie 取消審核時直接付款未更新oma61
# Modify.........: No.FUN-960140 09/07/24 By lutingting取消審核時直接收款更新oma55,oma57,nmh17
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-9C0057 09/12/09 By Carrier 状况码赋值
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-B40056 11/06/07 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/18 By elva 现金流量表修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_trno           LIKE oma_file.oma01,
        g_ooa            RECORD LIKE ooa_file.*,
        g_oma            RECORD LIKE oma_file.*,
        g_sql            STRING, 
        b_oob            RECORD LIKE oob_file.*  #No.FUN-960140
 
FUNCTION s_t300_unconfirm(p_trno)
   DEFINE p_trno	LIKE oma_file.oma01
   DEFINE l_oma55       LIKE oma_file.oma55
   DEFINE l_oma57       LIKE oma_file.oma57
 
   LET g_success = 'N' 
   LET g_trno = p_trno CLIPPED
   IF cl_null(g_trno) THEN RETURN END IF
   
   #No.FUN-960140--------start--
   INITIALIZE  b_oob.* TO NULL
   DECLARE s_t300_z1_c CURSOR FOR
    SELECT * FROM oob_file WHERE oob01 = p_trno AND oob02 > 0 ORDER BY oob02
   FOREACH s_t300_z1_c INTO b_oob.*
     IF STATUS THEN
        IF g_bgerr THEN
            CALL s_errmsg('oob01',p_trno,'z1 foreach',STATUS,1)
         ELSE
            CALL cl_err('z1 foreach',STATUS,1)
         END IF
         LET g_success = 'N' RETURN
     END IF
     IF b_oob.oob03 = '1' and b_oob.oob04 = '3' THEN
        UPDATE oma_file SET oma55 = oma55 - b_oob.oob09,oma57 = oma57 - b_oob.oob10
         WHERE oma01 = b_oob.oob06
        #若已經update
        SELECT oma55,oma57 INTO l_oma55,l_oma57 FROM oma_file
         WHERE oma01 = b_oob.oob06
        IF l_oma55<0 OR l_oma57< 0 THEN
           UPDATE oma_file SET oma55 = 0,oma57 = 0
            WHERE oma01 = b_oob.oob06
        END IF
     END IF
     IF b_oob.oob03 = '1' and b_oob.oob04 = '1' THEN
        UPDATE nmh_file SET nmh17 = nmh17 - b_oob.oob09
           WHERE nmh01 = b_oob.oob06
     END IF
   END FOREACH
   #No.FUN-960140--------end
 
   # 取消已收款金額
   CALL s_t300_cancel_oma()
   IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
 
   # 新增票據
   CALL s_t300_del_nme()
   IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
 
   # 更新收款沖帳狀態
   CALL s_t300_upd_ooa()
   IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
 
   # 刪除溢收單
   CALL s_t300_del_oma()
   
   IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
   END IF
END FUNCTION
 
# 更新該張應收帳款之已收金額
FUNCTION s_t300_cancel_oma()
DEFINE l_oma      RECORD LIKE oma_file.*,
       l_ooa31d   LIKE ooa_file.ooa31d,
       l_ooa32d   LIKE ooa_file.ooa32d
DEFINE l_oob19    LIKE oob_file.oob19  #No.FUN-680022
DEFINE l_oob09    LIKE oob_file.oob09  #No.FUN-680022
DEFINE l_oob10    LIKE oob_file.oob10  #No.FUN-680022
 
   INITIALIZE l_oma.* TO NULL
   # 若已經存在沖帳金額，則需累計
   SELECT * INTO l_oma.* FROM oma_file 
    WHERE oma01 = g_trno
   IF STATUS THEN 
#     CALL cl_err('Sel oma:',STATUS,1)    #No.FUN-660116
      CALL cl_err3("sel","oma_file",g_trno,"",STATUS,"","Sel oma:",1)   #No.FUN-660116
      RETURN 
   END IF
   IF cl_null(l_oma.oma55) THEN LET l_oma.oma55 = 0 END IF
   IF cl_null(l_oma.oma57) THEN LET l_oma.oma57 = 0 END IF
   
   # 計算當前直接收款金額
   LET l_ooa31d = 0
   LET l_ooa32d = 0 
   SELECT ooa31d,ooa32d INTO l_ooa31d,l_ooa32d FROM ooa_file
    WHERE ooa01 = g_trno
   IF cl_null(l_ooa31d) THEN LET l_ooa31d = 0 END IF
   IF cl_null(l_ooa32d) THEN LET l_ooa32d = 0 END IF
 
   # 更新該應收帳款實際已收金額
   IF l_oma.oma55 - l_ooa31d < 0 OR l_oma.oma57 - l_ooa32d < 0 THEN
      UPDATE oma_file SET oma55 = 0,
                          oma57 = 0,
                          oma61 =oma56t           #No.TQC-7B0092
       WHERE oma01 = g_trno
   ELSE 
      UPDATE oma_file SET oma55 = l_oma.oma55 - l_ooa31d,
                          oma57 = l_oma.oma57 - l_ooa32d, 
                          oma61 =oma56t           #No.TQC-7B0092
       WHERE oma01 = g_trno
   END IF
#No.FUN-680022  --start--
   UPDATE omc_file SET omc10 = 0,
                       omc11 = 0,
                       omc13 = omc09     #No.TQC-7B0043
    WHERE omc01 = g_trno
#No.FUN-680022  --end--
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_trno,SQLCA.sqlcode,0)  #No.FUN-660116
      CALL cl_err3("upd","oma_file,omc_file",g_trno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116 #No.FUN-680022
      RETURN  
   ELSE 
      LET g_success = 'Y' 
   END IF
##No.FUN-680022  --start--
#   DECLARE s_t300_cancel_c CURSOR FOR                                                                                         
#      SELECT oob19,oob09,oob10 FROM oob_file                                                                               
#       WHERE oob06 =g_trno 
#   FOREACH s_t300_cancel_c INTO l_oob19,l_oob09,l_oob10  
#      IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
#      IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF              
#      UPDATE omc_file SET omc10=omc10-l_oob09,
#                          omc11=omc11-l_oob10,
#                          omc13=omc13+l_oob09
#       WHERE omc01=g_trno AND omc02=l_oob19    
#      IF SQLCA.sqlcode THEN
#         CALL cl_err3("upd","omc_file",g_trno,l_oob19,SQLCA.sqlcode,"","",0)   
#         RETURN  
#      ELSE 
#         LET g_success = 'Y' 
#      END IF  
#   END FOREACH                  
##No.FUN-680022  --end--
END FUNCTION
 
FUNCTION s_t300_del_nme()
   DEFINE l_n    LIKE type_file.num5           #No.FUN-680123  SMALLINT
   DEFINE l_nme24 LIKE nme_file.nme24   #FUN-730032
 
   IF g_ooz.ooz04 = 'N' THEN
      RETURN
   END IF
 
   SELECT COUNT(*) INTO l_n FROM oob_file                                       
    WHERE oob01=g_trno AND oob03 = '1' AND oob04 = '2'                                     
   IF l_n = 0 THEN                                                              
      RETURN                                                                    
   END IF 
   #FUN-730032 --begin
   #LET g_sql="SELECT nme24 FROM ",g_dbs_new,"nme_file",
   LET g_sql="SELECT nme24 FROM ",cl_get_target_table(g_plant_new,'nme_file'), #FUN-A50102
             " WHERE nme17='",g_trno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE s_t300_z_nme24_p FROM g_sql
   DECLARE s_t300_z_nme24_cs CURSOR FOR s_t300_z_nme24_p
   FOREACH s_t300_z_nme24_cs INTO l_nme24
      IF l_nme24 != '9' THEN
         CALL cl_err(g_trno,'anm-043',1)
         RETURN
      END IF
   END FOREACH
   #FUN-730032 --end
   #FUN-B40056 --begin
   IF g_nmz.nmz70 ='1' THEN #No.TQC-B70021
      LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'tic_file'), 
                " WHERE tic04 in (",
                "SELECT nme12 FROM nme_file ",
                " WHERE nme17 = '",g_trno,"')"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql       
        CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql 
      PREPARE s_t300_z_tic_p FROM g_sql
      EXECUTE s_t300_z_tic_p
      IF STATUS THEN
         CALL cl_err3("del","tic_file",g_trno,"",STATUS,"","del tic:",1) 
         LET g_success='N'
         RETURN
      END IF
   END IF
   #FUN-B40056 --end
   #LET g_sql="DELETE FROM ",g_dbs_new,"nme_file",
   LET g_sql="DELETE FROM ",cl_get_target_table(g_plant_new,'nme_file'), #FUN-A50102
             " WHERE nme17='",g_trno,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
   PREPARE s_t300_z_nme_p FROM g_sql
   EXECUTE s_t300_z_nme_p
   IF STATUS THEN
#     CALL cl_err('del nme:',STATUS,1)  #No.FUN-660116
      CALL cl_err3("del","nme_file",g_trno,"",STATUS,"","del nme:",1)   #No.FUN-660116
      LET g_success='N'
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('no nme deleted:','aap-161',1)
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION s_t300_upd_ooa()
 
   UPDATE ooa_file SET ooaconf = 'N',ooa34='0' WHERE ooa01 = g_trno  #No.TQC-9C0057
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_trno,SQLCA.sqlcode,0)   #No.FUN-660116
      CALL cl_err3("upd","ooa_file",g_trno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
      RETURN  
   ELSE 
      LET g_success = 'Y' 
   END IF
END FUNCTION
 
FUNCTION s_t300_del_oma()
DEFINE l_oma01   LIKE oma_file.oma01
 
   LET l_oma01 = NULL
 
   SELECT oob06 INTO l_oma01 FROM oob_file
    WHERE oob01 = g_trno 
      AND oob03 = '2' AND oob04 = '2'
      AND oob02 > 0
   IF cl_null(l_oma01) THEN
      RETURN
   ELSE 
      DELETE FROM oma_file WHERE oma01 = l_oma01
      IF SQLCA.SQLERRD[3]=0 THEN
#        CALL cl_err('no nme deleted:','aap-161',1)   #No.FUN-660116
         CALL cl_err3("del","oma_file",l_oma01,"","aap-161","","no nme deleted:",1)   #No.FUN-660116
         RETURN
      END IF
#No.FUN-680022  --start--                                                                                                           
      DELETE FROM omc_file WHERE omc01 = l_oma01                                                                                 
        IF STATUS THEN                                                                                                                 
          CALL cl_err3("del","omc_file",l_oma01,"",STATUS,"","del omc",1)                                                         
          LET g_success = 'N'                                                                                                         
       END IF                                                                                                                         
#No.FUN-680022  --end--    
      #FUN-5A0124  --begin
      DELETE FROM oov_file WHERE oov01 = l_oma01
      IF SQLCA.sqlcode THEN                                            
#        CALL cl_err('del oov',status,1)                                  #No.FUN-660116
         CALL cl_err3("del","oov_file",l_oma01,"",status,"","del oov",1)   #No.FUN-660116
         LET g_success='N'                                             
      END IF        
      #FUN-5A0124  --end
   END IF
 
   UPDATE oob_file SET oob06 = NULL
    WHERE oob01 = g_trno
      AND oob03 = '2' AND oob04 = '2' 
      AND oob02 > 0
   IF SQLCA.sqlcode THEN
#     CALL cl_err(g_trno,SQLCA.sqlcode,0)   #No.FUN-660116
      CALL cl_err3("upd","oob_file",g_trno,"",SQLCA.sqlcode,"","",0)   #No.FUN-660116
      RETURN  
   ELSE 
      LET g_success = 'Y' 
   END IF
 
   #DELETE FROM oob_file WHERE oob01 = g_trno      #FUN-960140 mark
   #                       AND oob03 = '2' AND oob04 = '2' AND oob02 > 0   #FUN-960140 mark
END FUNCTION
 

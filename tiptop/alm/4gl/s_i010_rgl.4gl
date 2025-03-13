# Prog. Version..: '5.30.06-13.03.12(00003)'     #
#
# Date & Author..: 2005/07/25 By Elva  因直接收款需重新生成分錄底稿
# Modify.........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.......... No.TQC-5B0080 05/11/28 By ice  生成分錄底稿時,貸項也應考慮oot_file
# Modify.........: No.FUN-5C0015 06/02/14 BY GILL   CALL s_def_npq() 依設定
#                                                   給摘要與異動碼預設值
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670047 06/07/13 By Rayven 新增使用多帳套功能 
# Modify.........: No.FUN-680123 06/09/19 By hongmei 欄位類型轉換
# Modify.........: No.FUN-710050 07/02/01 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-730062 07/03/19 By Smapmin 關係人代碼已改為npq37
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.TQC-740042 07/04/09 By bnlent 年度取帳套 
# Modify.........: No.MOD-740429 07/04/24 By Ray 直接收款后無法生成分錄
# Modify.........: No.MOD-750132 07/05/30 By Smapmin 調整關係人異動碼相關程式段
# Modify.........: No.TQC-7B0035 07/11/06 By wujie   做直接收款，如果沒有tna_file檔，生成分錄后時報錯。但tna_file是可以不存在的。
# Modify.........: No.TQC-7B0043 07/11/09 By wujie   產生oob負項次不應該在產生分錄時，應放在直接收款中產生，產生與每一項次對應的負項次
# Modify.........: No.MOD-820056 08/02/14 By Smapmin 分錄金額不可為0
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A70118 10/07/29 BY shiwuying xxxlegal賦值
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_oma	 	         RECORD LIKE oma_file.*
   DEFINE g_trno	         LIKE oma_file.oma01
   DEFINE g_type                 LIKE npp_file.npptype  #No.FUN-670047
   DEFINE l_oob09                LIKE oob_file.oob09
   DEFINE l_oob10                LIKE oob_file.oob10
   DEFINE g_sql,g_forupd_sql     STRING   #SELECT ... FOR UPDATE  SQL
 
FUNCTION s_i010_rgl(p_trno,p_npptype)  #No.FUN-670047 新增p_npptype
   DEFINE p_trno	LIKE oma_file.oma01
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-670047
   DEFINE p_bookno      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-680123 SMALLINT
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
 
   LET g_trno = p_trno
   LET g_type = p_npptype   #No.FUN-670047
   IF g_trno IS NULL THEN RETURN END IF
 
   SELECT oma_file.* INTO g_oma.* FROM oma_file WHERE oma01 = g_trno 
#No.TQC-7B0035 --begin
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_trno,'sel oma+ool',STATUS,1)
      ELSE
         CALL cl_err3("sel","oma_file",g_trno,"",STATUS,"","sel oma+ool",1)   #No.FUN-660116
      END IF
   END IF
#No.TQC-7B0035 --end
   #No.FUN-740009 --begin
   CALL s_get_bookno(YEAR(g_oma.oma02))   #TQC-740042
        RETURNING l_flag,l_bookno1,l_bookno2
   IF l_flag='1' THEN #抓不到帳別
      CALL cl_err(YEAR(g_oma.oma02),'aoo-081',1)
      LET g_success = 'N'
   END IF
   IF g_type = '0' THEN
      LET p_bookno = l_bookno1
   ELSE 
      LET p_bookno = l_bookno2
   END IF
   #No.FUN-740009 --end
#No.TQC-7B0035 --begin
#  IF STATUS THEN 
#     CALL cl_err('sel oma+ool',STATUS,1)   #No.FUN-660116
#NO.FUN-710050------begin
#      IF g_bgerr THEN
#         CALL s_errmsg('oma01',g_trno,'sel oma+ool',STATUS,1)
#      ELSE
#         CALL cl_err3("sel","oma_file",g_trno,"",STATUS,"","sel oma+ool",1)   #No.FUN-660116
#      END IF
#NO.FUN-710050------end
#  END IF
#No.TQC-7B0035 --end
 
   IF g_oma.oma02 <= g_ooz.ooz09 THEN CALL cl_err('','axr-164',0) RETURN END IF
 
   # 判斷已拋轉傳票不可再產生
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = g_trno 
      AND nppglno IS NOT NULL AND npp00=2
      AND nppsys = 'AR'       AND npp011 = 1   #異動序號
   IF l_n > 0 THEN
#NO.FUN-710050-----begin
     IF g_bgerr THEN
        CALL s_errmsg('','','sel npp','aap-122',0)
     ELSE
        CALL cl_err('sel npp','aap-122',0)
     END IF
#NO.FUN-710050-----end
      RETURN
   END IF
 
   CALL s_i010_gl(p_trno,g_type)  #No.FUN-670047 新增g_type
 
   # 借 oob03 = '1' 記錄當前直接收款之總金額
   SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file
    WHERE oob01 = g_oma.oma01 AND oob03='1'
      AND oob02 > 0 
   IF cl_null(l_oob09) THEN LET l_oob09= 0 END IF
   IF cl_null(l_oob10) THEN LET l_oob10= 0 END IF
 
   LET g_success = 'Y' 
   # 若直接收款 l_oob09 > 應收 oma54t，則生成溢收
   # 若直接收款 l_oob09 < 應收 oma54t，則更新原分錄借方明細
   # 若直接收款 l_oob09 = 應收 oma54t，則直接更新
CASE WHEN l_oob09 = g_oma.oma54t 
             CALL s_i010_rgl_d()
#            CALL s_i010_rgl_c("e")       #No.FUN-740009
             CALL s_i010_rgl_c("e",p_bookno)       #No.FUN-740009
             IF l_oob10 != g_oma.oma56t THEN   #匯兌損益
#               CALL s_i010_rgl_c("r")       #No.FUN-740009
                CALL s_i010_rgl_c("r",p_bookno)       #No.FUN-740009
             END IF
        WHEN l_oob09 < g_oma.oma54t CALL s_i010_rgl_u()
#                                   CALL s_i010_rgl_c("l")       #No.FUN-740009
                                    CALL s_i010_rgl_c("l",p_bookno)       #No.FUN-740009
        WHEN l_oob09 > g_oma.oma54t CALL s_i010_rgl_d()
#                                   CALL s_i010_rgl_c("e")       #No.FUN-740009
                                    CALL s_i010_rgl_c("e",p_bookno)       #No.FUN-740009
#                                   CALL s_i010_rgl_c("m")       #No.FUN-740009
                                    CALL s_i010_rgl_c("m",p_bookno)       #No.FUN-740009
   END CASE
    
END FUNCTION
 
# 刪除舊存在的借方明細
FUNCTION s_i010_rgl_d()
 
   DELETE FROM npq_file WHERE npq01  = g_trno AND npq00  = 2
                          AND npqsys = 'AR'   AND npq011 = 1 
                          AND npq06  = '1'
                          AND npqtype = g_type  #No.FUN-670047
                          AND npq23 = g_oma.oma01  #dongbg add
   IF SQLCA.sqlcode THEN 
      LET g_success = 'N'
      RETURN 
   END IF
   #FUN-B40056--add--srt--
   DELETE FROM tic_file WHERE tic04 = g_trno
   IF SQLCA.sqlcode THEN
      LET g_success = 'N'
      RETURN
   END IF
   #FUN-B40056--add--end--
END FUNCTION
 
# 若直接收款金額等于應收款金額處理
# 處理邏輯: 刪除原生成分錄底稿借方唯一筆資料
#           復制直接收款維護作業中借方所有相關資料
FUNCTION s_i010_rgl_u()
DEFINE  l_npq          RECORD LIKE npq_file.*,
        l_diff_npq07f  LIKE npq_file.npq07f,
        l_diff_npq07   LIKE npq_file.npq07 
DEFINE  l_cnt          LIKE type_file.num5    #No.FUN-680123 SMALLINT #No.TQC-5B0080
DEFINE  l_oot04t       LIKE oot_file.oot04t   #No.TQC-5B0080
DEFINE  l_oot05t       LIKE oot_file.oot05t   #No.TQC-5B0080
 
   #No.TQC-5B0080 --start--
   SELECT COUNT(*),SUM(oot04t),SUM(oot05t)
     INTO l_cnt,l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = g_oma.oma01
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
 
   IF l_cnt > 0 THEN
      LET l_diff_npq07f = g_oma.oma54t  - l_oob09 - l_oot04t
      LET l_diff_npq07  = g_oma.oma56t  - l_oob10 - l_oot05t
   ELSE
      LET l_diff_npq07f = g_oma.oma54t  - l_oob09
      LET l_diff_npq07  = g_oma.oma56t  - l_oob10
   END IF
   #No.TQC-5B0080 --end--
   IF cl_null(l_diff_npq07f) OR cl_null(l_diff_npq07) THEN
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_success = 'N' 
   LET g_forupd_sql = " SELECT * FROM npq_file ",
                      "  WHERE npqsys = ? AND npq00 = ? AND npq01 = ? ",
                      "    AND npq011 = ? AND npq06 = ? ",
                      "    AND npqtype = ? ",  #No.FUN-670047
                      "    FOR UPDATE  "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_i010_rgl_b CURSOR FROM g_forupd_sql     
 
   OPEN s_i010_rgl_b USING 'AR','2',g_oma.oma01,'1','1',g_type  #No.FUN-670047 新增g_type
   IF STATUS THEN
      CALL cl_err("OPEN s_i010_rgl_b:", STATUS, 1)
      CLOSE s_i010_rgl_b
      RETURN
   ELSE
      FETCH s_i010_rgl_b INTO l_npq.*
      IF SQLCA.sqlcode THEN
#NO.FUN-710050-------begin
         IF g_bgerr THEN
            LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'lock npq',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err('lock npq',SQLCA.sqlcode,1)
         END IF
#NO.FUN-710050------end
         LET g_success = 'N' 
         RETURN
      ELSE
         UPDATE npq_file
            SET npq07f = l_diff_npq07f, npq07= l_diff_npq07
          WHERE npqsys = l_npq.npqsys AND npq00 = l_npq.npq00 
	    AND npq01  = l_npq.npq01  AND npq011= l_npq.npq011 
	    AND npq02  = l_npq.npq02  AND npq06 = '1'
            AND npqtype = l_npq.npqtype  #No.FUN-670047
          IF SQLCA.sqlcode THEN
#            CALL cl_err('upd npq',SQLCA.sqlcode,1)   #No.FUN-660116
#NO.FUN-710050-------begin
             IF g_bgerr THEN
                CALL s_errmsg('','','upd npq',SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("upd","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","upd npq",1)   #No.FUN-660116
             END IF
#NO.FUN-710050-------end
             RETURN
          ELSE 
             LET g_success = 'Y'
          END IF
      END IF
   END IF
   CLOSE s_i010_rgl_b
END FUNCTION
 
# 將直接付款中維護資料復制為新分錄
# 復制直接付款中所有相關借方,貸方資料
FUNCTION s_i010_rgl_c(p_cmd,p_bookno)
 DEFINE  p_cmd        LIKE type_file.chr1,
         g_success1   LIKE type_file.chr1,
         p_bookno     LIKE aza_file.aza81,       #No.FUN-740009
         l_oob        RECORD LIKE oob_file.*,
         l_npq        RECORD LIKE npq_file.*,
         l_oob03      LIKE oob_file.oob03,
         l_aag05      LIKE aag_file.aag05,
         l_aag23      LIKE aag_file.aag23,
         #l_aag181     LIKE aag_file.aag181,   #MOD-750132
         l_aag371     LIKE aag_file.aag371,   #MOD-750132
         l_occ02      LIKE occ_file.occ02,
         l_occ37      LIKE occ_file.occ37
 
   LET g_success1 = 'N' 
   IF p_cmd NOT MATCHES '[elmr]' THEN RETURN END IF
   IF p_cmd MATCHES '[el]' THEN
      LET l_oob03 = '1'
   ELSE 
      LET l_oob03 = '2'
   END IF
   IF cl_null(l_oob03) THEN RETURN END IF
 
   # 選擇直接收款維護借方明細資料
   LET g_sql = " SELECT * FROM oob_file  ",
               "  WHERE oob01 = '",g_oma.oma01,
               "'   AND oob02 > 0 AND oob03 = ? "
   PREPARE s_i010_rgl_bp FROM g_sql
   IF STATUS THEN
#NO.FUN-710050------begin
      IF g_bgerr THEN
         CALL s_errmsg('','','Prepare s_i010_rgl:',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err('Prepare s_i010_rgl:',SQLCA.sqlcode,1)
      END IF
#NO.FUN-710050------end
   END IF
   DECLARE s_i010_rgl_c CURSOR FOR s_i010_rgl_bp
 
   FOREACH s_i010_rgl_c USING l_oob03 INTO l_oob.* 
      IF STATUS THEN CALL cl_err('SELECT npq',STATUS,1) EXIT FOREACH END IF
      INITIALIZE l_npq.* TO NULL
      LET l_npq.npqtype = g_type  #No.FUN-670047
      LET l_npq.npqsys = 'AR' 
      LET l_npq.npq00  = 2
      LET l_npq.npq01  = l_oob.oob01
      LET l_npq.npq011 = 1
      SELECT MAX(npq02)+1 INTO l_npq.npq02 FROM npq_file
       WHERE npqsys = 'AR'        AND npq00  = 2
         AND npq01  = l_oob.oob01 AND npq011 = 1
      IF cl_null(l_npq.npq02) THEN LET l_npq.npq02 = 1 END IF
      IF l_npq.npqtype = '0' THEN  #No.FUN-670047
         LET l_npq.npq03 = l_oob.oob11
      #No.FUN-670047 --start--
      ELSE
         LET l_npq.npq03 = l_oob.oob111
      END IF
      #No.FUN-670047 --end--
      LET l_npq.npq04  = l_oob.oob12
      LET l_npq.npq05  = l_oob.oob13
 
      # 是否做部門管理
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = p_bookno       #No.FUN-740009
      IF NOT cl_null(l_aag05) AND l_aag05 = 'N' THEN
         LET l_npq.npq05 = ' '
      END IF
 
      LET l_npq.npq06  = l_oob.oob03
      LET l_npq.npq07f = l_oob.oob09
      LET l_npq.npq07  = l_oob.oob10
      LET l_npq.npq24  = l_oob.oob07
      LET l_npq.npq25  = l_oob.oob08
      # 是否做專案
      LET l_aag23 = ''
      SELECT aag23 INTO l_aag23 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = p_bookno       #No.FUN-740009
      IF cl_null(l_aag23) THEN LET l_aag23 = 'N' END IF
      IF l_aag23 = 'Y' THEN
         LET l_npq.npq08 = g_oma.oma63      # 專案編號
      ELSE
         LET l_npq.npq08 = null
      END IF
    
      LET l_npq.npq21 = g_oma.oma03         # 客戶編號
      LET l_npq.npq22 = g_oma.oma032        # 客戶簡稱
      LET l_npq.npq23 = g_oma.oma01         # 立沖單號 
      #-----MOD-750132---------
      LET l_aag371 = ''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01 = l_npq.npq03
         AND aag00 = p_bookno  
      #LET l_aag181 = ''
      #SELECT aag181 INTO l_aag181 FROM aag_file
      # WHERE aag01 = l_npq.npq03
      #   AND aag00 = p_bookno       #No.FUN-740009
      #IF l_aag181 MATCHES '[23]' THEN
      #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
      #    WHERE occ01 = g_oma.oma03
      #   IF l_occ37='Y' THEN
      #      #LET l_npq.npq14 = l_occ02 CLIPPED    # 異動碼   #MOD-730062
      #      LET l_npq.npq37 = l_occ02 CLIPPED    # 異動碼   #MOD-730062
      #   END IF
      #END IF
      #-----END MOD-750132----- 
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
 
      # 若無科目，則缺省'-'
      IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
      LET l_npq.npq30 = g_dbs
 
      #FUN-5C0015 06/02/15 BY GILL --START
#     CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')       #No.FUN-740009
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',p_bookno)       #No.FUN-740009
      RETURNING l_npq.*
      #FUN-5C0015 06/02/15 BY GILL --END
      #-----MOD-750132---------
      IF l_aag371 MATCHES '[23]' THEN
         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
          WHERE occ01 = g_oma.oma03
         IF cl_null(l_npq.npq37) THEN 
            IF l_occ37='Y' THEN
               LET l_npq.npq37 = l_occ02 CLIPPED
            END IF
         END IF
      END IF
      #-----END MOD-750132----- 
      LET l_npq.npqlegal = g_legal   #No.FUN-A70118
      IF l_npq.npq07 <> 0 THEN   #MOD-820056 
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#1',SQLCA.SQLCODE,1)   #No.FUN-660116
#NO.FUN-710050--------begin
         IF g_bgerr THEN
            LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   #No.FUN-660116
         END IF
#NO.FUN-710050-------end
         EXIT FOREACH
      ELSE 
         LET g_success1 = 'Y'
      END IF
      END IF   #MOD-820056
   END FOREACH
   CALL s_flows('3','',l_npq.npq01,g_oma.oma02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021   
END FUNCTION
 
FUNCTION s_i010_rgl_resort(p_bookno)
DEFINE      l_npq    RECORD LIKE npq_file.*
DEFINE      l_npq02  LIKE npq_file.npq02
DEFINE      p_bookno LIKE aza_file.aza81       #No.FUN-740009
   DROP TABLE x
   SELECT * FROM npq_file WHERE npq01=g_trno AND npqsys='AR'
      AND npqtype = g_type  #No.FUN-670047
      AND npq00  = 2 AND npq011 = 1 INTO TEMP x
   
   DELETE FROM npq_file WHERE npq01=g_trno AND npqsys='AR'
      AND npq00  = 2 AND npq011 = 1
      AND npqtype = g_type  #No.FUN-670047 
   IF SQLCA.SQLERRD[3] = 0 THEN                                                 
#     CALL cl_err('del npq_file',SQLCA.SQLCODE,1)                                  #No.FUN-660116
#NO.FUN-710050-----begin
      IF g_bgerr THEN
         CALL s_errmsg('','','del npq_file',SQLCA.SQLCODE,1) 
       ELSE
         CALL cl_err3("del","npq_file",g_trno,"",SQLCA.sqlcode,"","del npq_file",1)   #No.FUN-660116
       END IF
#NO.FUN-710050-----end
      RETURN                                                                    
   END IF

   #FUN-B40056--add--srt--
   DELETE FROM tic_file WHERE tic04 = g_trno
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','del tic_file',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("del","tic_file",g_trno,"",SQLCA.sqlcode,"","del tic_file",1) 
      END IF
      RETURN
   END IF
   #FUN-B40056--add--end--

   DECLARE s_i010_rgl_st CURSOR FOR 
    SELECT * FROM x ORDER BY npq06,npq02
   LET l_npq02 = 0
   FOREACH s_i010_rgl_st INTO l_npq.*
      LET l_npq02=l_npq02+1
      LET l_npq.npq02 = l_npq02
      
      #FUN-5C0015 06/02/15 BY GILL --START
#     CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')       #No.FUN-740009
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',p_bookno)       #No.FUN-740009
      RETURNING l_npq.*
      #FUN-5C0015 06/02/15 BY GILL --END
      LET l_npq.npqlegal = g_legal   #No.FUN-A70118
      IF l_npq.npq07 <> 0 THEN   #MOD-820056 
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('npq resort',SQLCA.SQLCODE,1)   #No.FUN-660116
#NO.FUN-710050------begin
         IF g_bgerr THEN
            LET g_showmsg=l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq.npqsys,"/",l_npq.npq00
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'npq resort',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","",1)   #No.FUN-660116
         END IF
#NO.FUN-710050------end
         EXIT FOREACH
      END IF
      END IF   #MOD-820056
   END FOREACH
END FUNCTION

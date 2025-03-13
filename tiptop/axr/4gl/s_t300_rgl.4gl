# Prog. Version..: '5.30.07-13.05.16(00010)'     #
#
# Date & Author..: 2005/07/25 By Elva  因直接收款需重新生成分錄底稿
# Modify........: No.TQC-5A0134 05/10/31 By Rosayu VARCHAR-> CHAR
# Modify.........: No.TQC-5B0080 05/11/28 By ice  生成分錄底稿時,貸項也應考慮oot_file
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
# Modify.........: No.MOD-850261 08/05/28 By Sarah s_t300_rgl_d()在刪除借方科目資料,只需刪目前這筆應收帳款g_oma.oma01就好
# Modify.........: No.CHI-830037 08/10/16 By Jan 請調整將目前財務架構中使用關系人的地方,請統一使用"代碼",而非"簡稱"
# Modify.........: No.FUN-960141 09/06/26 By dongbg GP5.2修改:1,此function中不應該有事務 2,建臨時表的動作放到axrt300
#                                            后續若主程序要調用此FUNCTION 需在主程序中建臨時表
# Modify.........: No.FUN-980011 09/08/25 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9C0014 09/12/08 By shiwuying 跨庫處理
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No.FUN-A30077 10/03/23 By Carrier 按余额类型产生分录aag24='Y'时,分录方向要按设定来处理
# Modify.........: No.FUN-A60056 10/07/08 By lutingting GP5.2財務串前段問題整批調整 
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modidy.........: No.FUN-950053 10/08/18 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No.FUN-A50102 10/09/29 By vealxu 跨db处理
# Modify.........: No.FUN-AA0087 11/01/27 By chenmoyan 異動碼類型設定改善
# Modify.........: No.TQC-B20095 11/02/17 By elva 临时表MARK错误
# Modify.........: No.FUN-B40032 11/04/20 By baogc 應收賬款中券部份邏輯修改
# Modify.........: No:FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:MOD-B60166 11/06/20 By wujie 直接收款的参考单号取oob06
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-B70233 11/07/25 By suncx DROP TABLE動作導致正在進行的事務被提交，以至於後面即使要回滾也無法回滾
# Modify.........: No:FUN-B80170 11/08/30 By pauline  修改t_rxy05,t_rxy05x取值部分
# Modify.........: No:MOD-C40145 12/04/19 By Elise 因g_success1為null而return了，造成重產分錄底稿失敗
# Modify.........: No:MOD-C40200 12/04/30 By Elise 若直接收款後,無法產生傳票單身資料
# Modify.........: No.FUN-D10065 13/01/16 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40089 13/04/23 By zhangweib 批次審核的報錯,加show單據編號


DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_oma	 	         RECORD LIKE oma_file.*
   DEFINE g_trno	         LIKE oma_file.oma01
   DEFINE g_type                 LIKE npp_file.npptype  #No.FUN-670047
   DEFINE l_oob09                LIKE oob_file.oob09
   DEFINE l_oob10                LIKE oob_file.oob10
   DEFINE g_sql,g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
   DEFINE l_dbs                  LIKE type_file.chr21  #No.FUN-9C0014 Add
   DEFINE l_plant                LIKE type_file.chr21  #FUN-A50102
   DEFINE g_npq25                LIKE npq_file.npq25    #No.FUN-9A0036
   DEFINE g_success1    LIKE type_file.chr1   
 
FUNCTION s_t300_rgl(p_trno,p_npptype)  #No.FUN-670047 新增p_npptype #No.FUN-9C0014 Add p_dbs #No.FUN-A10104
   DEFINE p_trno	LIKE oma_file.oma01
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-670047
   DEFINE p_bookno      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-680123 SMALLINT
   DEFINE  l_flag         LIKE type_file.chr1       #No.FUN-740009
   DEFINE  l_bookno1      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE  l_bookno2      LIKE aza_file.aza82       #No.FUN-740009
#  DEFINE p_dbs           LIKE type_file.chr21      #No.FUN-9C0014 Add #No.FUN-A10104
 
   WHENEVER ERROR CONTINUE
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
#No.FUN-A10104 -BEGIN-----
#  LET l_dbs = p_dbs        #No.FUN-9C0014 Add
   IF cl_null(g_oma.oma66) THEN
      LET l_plant = ''   #FUN-A50102
      LET l_dbs = ''
   ELSE
      LET g_plant_new = g_oma.oma66
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
      LET l_plant = g_plant_new         #FUN-A50102
   END IF
#No.FUN-A10104 -END-------
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
       #CALL s_errmsg('','','sel npp','aap-122',0)   #No.FUN-D40089   Mark
        CALL s_errmsg('oma01',g_trno,'sel npp','aap-122',0)   #No.FUN-D40089   Add
     ELSE
        CALL cl_err('sel npp','aap-122',0)
     END IF
#NO.FUN-710050-----end
      RETURN
   END IF
 
   CALL s_t300_gl(p_trno,g_type)  #No.FUN-670047 新增g_type
 
   # 借 oob03 = '1' 記錄當前直接收款之總金額
   SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file
    WHERE oob01 = g_oma.oma01 AND oob03='1'
      AND oob02 > 0 
   IF cl_null(l_oob09) THEN LET l_oob09= 0 END IF
   IF cl_null(l_oob10) THEN LET l_oob10= 0 END IF
 
   LET g_success = 'Y' 
   LET g_success1 = 'N'  #MOD-C40145 add
   #BEGIN WORK              #FUN-960141 mark
   # 若直接收款 l_oob09 > 應收 oma54t，則生成溢收
   # 若直接收款 l_oob09 < 應收 oma54t，則更新原分錄借方明細
   # 若直接收款 l_oob09 = 應收 oma54t，則直接更新
CASE WHEN l_oob09 = g_oma.oma54t 
             CALL s_t300_rgl_d()
#            CALL s_t300_rgl_c("e")       #No.FUN-740009
             CALL s_t300_rgl_c("e",p_bookno)       #No.FUN-740009
             IF l_oob10 != g_oma.oma56t THEN   #匯兌損益
#               CALL s_t300_rgl_c("r")       #No.FUN-740009
                CALL s_t300_rgl_c("r",p_bookno)       #No.FUN-740009
             END IF
        WHEN l_oob09 < g_oma.oma54t CALL s_t300_rgl_u()
#                                   CALL s_t300_rgl_c("l")       #No.FUN-740009
                                    CALL s_t300_rgl_c("l",p_bookno)       #No.FUN-740009
        WHEN l_oob09 > g_oma.oma54t CALL s_t300_rgl_d()
#                                   CALL s_t300_rgl_c("e")       #No.FUN-740009
                                    CALL s_t300_rgl_c("e",p_bookno)       #No.FUN-740009
#                                   CALL s_t300_rgl_c("m")       #No.FUN-740009
                                    CALL s_t300_rgl_c("m",p_bookno)       #No.FUN-740009
   END CASE
 
   # 為保証axrt400中借貸相平，則需更新oob_file中負項次為貸方應收帳款
#  CALL s_t300_rgl_ins_oob()      #No.TQC-7B0043
 
   IF g_success = 'Y' AND g_success1 = 'Y' THEN 
      #FUN-960141 modify 
      #COMMIT WORK
      LET g_success = 'Y'
      #End
      MESSAGE "  Successfully!  "
   ELSE
      #FUN-960141 modify
      #ROLLBACK WORK 
      LET g_success = 'N'
      #End
      ERROR " Fail! "
      RETURN
   END IF
 
#  CALL s_t300_rgl_resort()  #項次重排       #No.FUN-740009
   CALL s_t300_rgl_resort(p_bookno)  #項次重排       #No.FUN-740009
   CALL s_t300_rgl_diff(p_bookno,p_npptype,p_trno)   #No.FUN-A40033
END FUNCTION
 
# 刪除舊存在的借方明細
FUNCTION s_t300_rgl_d()
 
   DELETE FROM npq_file WHERE npq01  = g_trno AND npq00  = 2
                          AND npqsys = 'AR'   AND npq011 = 1 
                          AND npq06  = '1'
                          AND npqtype = g_type  #No.FUN-670047
                          AND npq23  = g_oma.oma01   #MOD-850261 add
   IF SQLCA.sqlcode THEN 
      LET g_success = 'N'
      RETURN 
   END IF
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_trno
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      RETURN
   END IF
   #FUN-B40056--add--end--
END FUNCTION
 
# 若直接收款金額等于應收款金額處理
# 處理邏輯: 刪除原生成分錄底稿借方唯一筆資料
#           復制直接收款維護作業中借方所有相關資料
FUNCTION s_t300_rgl_u()
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
                      "   WHERE npqsys = ? AND npq00 = ? AND npq01 = ? ",
                      "    AND npq011 = ? AND npq06 = ? ",
                      "    AND npqtype = ? ",  #No.FUN-670047
                      "    FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE s_t300_rgl_b CURSOR FROM g_forupd_sql     
 
   OPEN s_t300_rgl_b USING 'AR','2',g_oma.oma01,'1','1',g_type  #No.FUN-670047 新增g_type
   IF STATUS THEN
      CALL cl_err("OPEN s_t300_rgl_b:", STATUS, 1)
      CLOSE s_t300_rgl_b
      RETURN
   ELSE
      FETCH s_t300_rgl_b INTO l_npq.*
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
               #CALL s_errmsg('','','upd npq',SQLCA.sqlcode,1)   #No.FUN-D40089   Mark
                CALL s_errmsg('oma01',l_npq.npq01,'upd npq',SQLCA.sqlcode,1)   #No.FUN-D40089   Add
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
   CLOSE s_t300_rgl_b
END FUNCTION
 
# 將直接付款中維護資料復制為新分錄
# 復制直接付款中所有相關借方,貸方資料
FUNCTION s_t300_rgl_c(p_cmd,p_bookno)
DEFINE   p_bookno     LIKE aza_file.aza81,       #No.FUN-740009
         l_oob        RECORD LIKE oob_file.*,
         l_npq        RECORD LIKE npq_file.*,
         l_oob03      LIKE oob_file.oob03,
         l_aag05      LIKE aag_file.aag05,
         l_aag23      LIKE aag_file.aag23,
         #l_aag181     LIKE aag_file.aag181,   #MOD-750132
         l_aag371     LIKE aag_file.aag371,   #MOD-750132
         l_occ02      LIKE occ_file.occ02,
         l_occ37      LIKE occ_file.occ37
DEFINE   l_bookno1,l_bookno2 LIKE aza_file.aza81 #No.FUN-9A0036
DEFINE   l_flag       LIKE type_file.chr1        #No.FUN-9A0036
DEFINE l_aaa03   LIKE aaa_file.aaa03 #FUN-A40067
DEFINE l_azi04_2 LIKE azi_file.azi04 #FUN-A40067
###-FUN-B40032- ADD - BEGIN ---------------------------------------------------
DEFINE   t_rxy05t     LIKE rxy_file.rxy05
DEFINE   t_rxy05      LIKE rxy_file.rxy05
DEFINE   t_rxy05x     LIKE rxy_file.rxy05
DEFINE   p_cmd        LIKE type_file.chr1  
###-FUN-B40032- ADD -  END  ---------------------------------------------------
 
  #LET g_success1 = 'N'    #MOD-850261 mark
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
   PREPARE s_t300_rgl_bp FROM g_sql
   IF STATUS THEN
#NO.FUN-710050------begin
      IF g_bgerr THEN
        #CALL s_errmsg('','','Prepare s_t300_rgl:',SQLCA.sqlcode,1)  #No.FUN-D40089   Mark
         CALL s_errmsg('oma01',g_oma.oma01,'Prepare s_t300_rgl:',SQLCA.sqlcode,1)  #No.FUN-D40089   Add
      ELSE
         CALL cl_err('Prepare s_t300_rgl:',SQLCA.sqlcode,1)
      END IF
#NO.FUN-710050------end
   END IF
   DECLARE s_t300_rgl_c CURSOR FOR s_t300_rgl_bp
 
   FOREACH s_t300_rgl_c USING l_oob03 INTO l_oob.* 
      IF STATUS THEN CALL cl_err('SELECT npq',STATUS,1) EXIT FOREACH END IF
      INITIALIZE l_npq.* TO NULL
      LET l_npq.npqtype = g_type   #No.FUN-670047
      LET l_npq.npqlegal = g_legal #FUN-980011 add
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
      #LET l_npq.npq04  = l_oob.oob12 #FUN-D10065 mark
      LET l_npq.npq04  = NULL         #FUN-D10065 add
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
###-FUN-B40032- ADD- BEGIN ----------------------------------------------------
      INITIALIZE t_rxy05t TO NULL
      LET g_sql = "SELECT SUM(rxy05) ",
                  "  FROM ",cl_get_target_table(g_plant_new,'rxy_file'),
                  " WHERE rxy00 = '02' ",
                  "   AND rxy01 IN (SELECT DISTINCT omb31 ",
                  "                   FROM ",cl_get_target_table(g_plant_new,'omb_file'),
                  "                  WHERE omb01 = '",g_oma.oma01,"')", 
                  "   AND rxy03 = '04'"
      PREPARE sel_rxy_pre FROM g_sql
      EXECUTE sel_rxy_pre INTO t_rxy05t
  #    LET t_rxy05 = cl_digcut((t_rxy05t / 1.05),g_azi04)    #FUN-B80170  mark
  #    LET t_rxy05x = t_rxy05t - t_rxy05                     #FUN-B80170  mark
#FUN-B80170 add START
      IF g_aza.aza26 = '0' THEN
         LET t_rxy05 = cl_digcut((t_rxy05t / 1.05),g_azi04)
         LET t_rxy05x = t_rxy05t - t_rxy05
      ELSE
         LET t_rxy05 = t_rxy05t
         LET t_rxy05x = 0
      END IF
#FUN-B80170 add END
      IF (g_oma.oma70 = '3') AND (t_rxy05x > 0) AND (l_oob.oob04 = 'Q') THEN
         LET l_npq.npq07f = l_npq.npq07f - t_rxy05x
         LET l_npq.npq07  = l_npq.npq07  - t_rxy05x
      END IF
###-FUN-B40032- ADD -  END  ---------------------------------------------------
      LET l_npq.npq24  = l_oob.oob07
      LET l_npq.npq25  = l_oob.oob08
      LET g_npq25      = l_npq.npq25      #No.FUN-9A0036
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
#     LET l_npq.npq23 = g_oma.oma01         # 立沖單號 
      LET l_npq.npq23 = l_oob.oob06         # 立沖單號   #No.MOD-B60166
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
   #FUN-D10065--add--str--
      IF cl_null(l_npq.npq04) THEN
         LET l_npq.npq04=l_oob.oob12
      END IF
   #FUN-D10065--add--end
#     CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')       #No.FUN-740009
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',p_bookno)       #No.FUN-740009
      RETURNING l_npq.*
      #FUN-5C0015 06/02/15 BY GILL --END
#     CALL s_def_npq31_npq34(l_npq.*,p_bookno)                  #FUN-AA0087
#     RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      #-----MOD-750132---------
    # IF l_aag371 MATCHES '[23]' THEN             #FUN-950053 mark
      IF l_aag371 MATCHES '[234]' THEN            #FUN-950053 add 
      #No.FUN-9C0014 BEGIN -----
      #  SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
      #   WHERE occ01=g_oma.oma03
      #  IF cl_null(l_dbs) THEN         #FUN-A50102
         IF cl_null(l_plant) THEN       #FUN-A50102
            SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
             WHERE occ01=g_oma.oma03
         ELSE
          # LET g_sql = "SELECT occ02,occ37 FROM ",l_dbs CLIPPED,"occ_file",            #FUN-A50102 
            LET g_sql = "SELECT occ02,occ37 FROM ",cl_get_target_table(l_plant,'occ_file'),   #FUN-A50102
                        " WHERE occ01='",g_oma.oma03,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql             #FUN-A50102
            CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql     #FUN-A50102
            PREPARE sel_occ_pre01 FROM g_sql
            EXECUTE sel_occ_pre01 INTO l_occ02,l_occ37
         END IF
      #No.FUN-9C0014 END -------
         IF cl_null(l_npq.npq37) THEN 
            IF l_occ37='Y' THEN
#              LET l_npq.npq37 = l_occ02 CLIPPED       #No.CHI-830037
               LET l_npq.npq37 = g_oma.oma03 CLIPPED    #No.CHI-830037
            END IF
         END IF
      END IF
      #-----END MOD-750132----- 
      IF l_npq.npq07 <> 0 THEN   #MOD-820056 
#No.FUN-9A0036 --Begin
         CALL s_get_bookno(YEAR(g_oma.oma02))
              RETURNING l_flag,l_bookno1,l_bookno2
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = l_bookno2
         SELECT azi04 INTO l_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         IF g_type = '1' THEN
            CALL s_newrate(l_bookno1,l_bookno2,l_npq.npq24,
                           g_npq25,g_oma.oma02)
            RETURNING l_npq.npq25
            LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
            LET l_npq.npq07 = cl_digcut(l_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
      #No.FUN-A30077  --Begin                                                   
      CALL s_t300_entry_direction(p_bookno,l_npq.npq03,l_npq.npq06,             
                                  l_npq.npq07,l_npq.npq07f)                     
           RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f                       
      #No.FUN-A30077  --End 
      LET l_npq.npq30 = g_oma.oma66   #FUN-A60056
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
 
#No.TQC-7B0043 --begin
# 為保証axrt400中借貸相平，則需更新oob_file中負項次
#FUNCTION s_t300_rgl_ins_oob()
#DEFINE  l_oob  RECORD LIKE oob_file.*,
#        l_ooa  RECORD LIKE ooa_file.*,
#        l_cnt  LIKE type_file.num5              #No.FUN-680123 SMALLINT
#
#   LET l_cnt = 0 
#   SELECT COUNT(*) INTO l_cnt FROM oob_file
#    WHERE oob01 = g_trno
#      AND oob02 = -1
#      AND oob03 = '2'
#      AND oob04 = '1'
#   IF l_cnt > 0 THEN 
#      DELETE FROM oob_file
#       WHERE oob01 = g_trno AND oob02 = -1
#         AND oob03 = '2'    AND oob04 = '1'
#   END IF
#
#   INITIALIZE l_oob.* TO NULL
#   INITIALIZE l_ooa.* TO NULL
#   SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_trno
#   IF cl_null(l_ooa.ooa01) THEN LET g_success = 'N' RETURN END IF
#      
#   LET l_oob.oob01 = g_trno
#   SELECT MIN(oob02) INTO l_oob.oob02 FROM oob_file 
#    WHERE oob01 = g_trno
#   IF cl_null(l_oob.oob02) OR l_oob.oob02 = 1 THEN
#      LET l_oob.oob02 = -1
#   ELSE 
#      LET l_oob.oob02 = l_oob.oob02 - 1
#   END IF 
#   LET l_oob.oob03 = '2'
#   LET l_oob.oob04 = '1'
#   LET l_oob.oob06 = g_trno
#   LET l_oob.oob07 = l_ooa.ooa23
#   LET l_oob.oob08 = l_ooa.ooa24
#   SELECT SUM(oob09) INTO l_oob.oob09 FROM oob_file
#    WHERE oob01 = g_trno AND oob03 = '1' AND oob02 > 0 
#   SELECT SUM(oob10) INTO l_oob.oob10 FROM oob_file
#    WHERE oob01 = g_trno AND oob03 = '1' AND oob02 > 0 
#   IF cl_null(l_oob.oob09) THEN LET l_oob.oob09 = 0 END IF
#   IF cl_null(l_oob.oob10) THEN LET l_oob.oob10 = 0 END IF
#   IF l_oob.oob09 > g_oma.oma54t THEN 
#      LET l_oob.oob09 = g_oma.oma54t
#      LET l_oob.oob10 = g_oma.oma56t
#   END IF
#   LET l_oob.oob13 = l_ooa.ooa15
#   INSERT INTO oob_file VALUES (l_oob.*)
#   IF STATUS OR SQLCA.SQLCODE THEN
##     CALL cl_err('ins oob#1',SQLCA.SQLCODE,1)   #No.FUN-660116
##NO.FUN-710050------begin
#      IF g_bgerr THEN
#         LET g_showmsg=l_oob.oob01,"/",l_oob.oob02
#         CALL s_errmsg('oob01,oob02',g_showmsg,'ins oob#1',SQLCA.SQLCODE,1)
#      ELSE
#         CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob#1",1)   #No.FUN-660116
#      END IF
##NO.FUN-710050-----end
#      LET g_success = 'N'
#   ELSE 
#      LET g_success = 'Y'
#   END IF
#END FUNCTION
#No.TQC-7B0043 --end
 
FUNCTION s_t300_rgl_resort(p_bookno)
DEFINE      l_npq    RECORD LIKE npq_file.*
DEFINE      l_npq02  LIKE npq_file.npq02
DEFINE      p_bookno LIKE aza_file.aza81       #No.FUN-740009
DEFINE      l_bookno1,l_bookno2  LIKE aza_file.aza81 #No.FUN-9A0036
DEFINE      l_flag               LIKE type_file.chr1 #No.FUN-9A0036
DEFINE      l_aaa03  LIKE aaa_file.aaa03  #FUN-A40067
DEFINE      l_azi04_2 LIKE azi_file.azi04 #FUN-A40067
 
   #MOD-B70233 mark begin--------------------
   #FUN-960141 modify
   #放到axrt300中建臨時表
   #TQC-B20095 去掉MARK
   #DROP TABLE x
   #SELECT * FROM npq_file WHERE npq01=g_trno AND npqsys='AR'
   #   AND npqtype = g_type  #No.FUN-670047
   #   AND npq00  = 2 AND npq011 = 1 INTO TEMP x
   #MOD-B70233 mark end----------------------
    DELETE FROM x
   #TQC-B20095-end
    INSERT INTO x SELECT * FROM npq_file WHERE npq01=g_trno AND npqsys='AR'
                     AND npqtype = g_type
                     AND npq00  = 2 AND npq011 = 1
   #FUN-960141 end 
   
   DELETE FROM npq_file WHERE npq01=g_trno AND npqsys='AR'
      AND npq00  = 2 AND npq011 = 1
      AND npqtype = g_type  #No.FUN-670047 
   IF SQLCA.SQLERRD[3] = 0 THEN                                                 
#     CALL cl_err('del npq_file',SQLCA.SQLCODE,1)                                  #No.FUN-660116
#NO.FUN-710050-----begin
      IF g_bgerr THEN
        #CALL s_errmsg('','','del npq_file',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
         CALL s_errmsg('oma01',g_trno,'del npq_file',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
       ELSE
         CALL cl_err3("del","npq_file",g_trno,"",SQLCA.sqlcode,"","del npq_file",1)   #No.FUN-660116
       END IF
#NO.FUN-710050-----end
      RETURN                                                                    
   END IF
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_trno
   IF SQLCA.sqlcode THEN                                                 
      IF g_bgerr THEN
        #CALL s_errmsg('','','del tic_file',SQLCA.SQLCODE,1)   #No.FUN-D40089   Mark
         CALL s_errmsg('oma01',g_trno,'del tic_file',SQLCA.SQLCODE,1)   #No.FUN-D40089   Add
       ELSE
         CALL cl_err3("del","tic_file",g_trno,"",SQLCA.sqlcode,"","del tic_file",1)   #No.FUN-660116
       END IF
      RETURN                                                                    
   END IF
   #FUN-B40056--add--end--
   DECLARE s_t300_rgl_st CURSOR FOR 
    SELECT * FROM x ORDER BY npq06,npq02
   LET l_npq02 = 0
   FOREACH s_t300_rgl_st INTO l_npq.*
      LET l_npq02=l_npq02+1
      LET l_npq.npq02 = l_npq02
      LET l_npq.npqlegal = g_legal #FUN-980011 add
      
      #FUN-5C0015 06/02/15 BY GILL --START
#     CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')       #No.FUN-740009
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',p_bookno)       #No.FUN-740009
      RETURNING l_npq.*
      #FUN-5C0015 06/02/15 BY GILL --END
      CALL s_def_npq31_npq34(l_npq.*,p_bookno)                  #FUN-AA0087  #MOD-C40200 remark
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087  #MOD-C40200 remark
 
      IF l_npq.npq07 <> 0 THEN   #MOD-820056 
#No.FUN-9A0036 --Begin
         CALL s_get_bookno(YEAR(g_oma.oma02))
              RETURNING l_flag,l_bookno1,l_bookno2
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = l_bookno2
         SELECT azi04 INTO l_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         IF g_type = '1' THEN
            CALL s_newrate(l_bookno1,l_bookno2,l_npq.npq24,
                           g_npq25,g_oma.oma02)
            RETURNING l_npq.npq25
            LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
            LET l_npq.npq07 = cl_digcut(l_npq.npq07,l_azi04_2)#FUN-A40067
         ELSE
            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
         END IF
#No.FUN-9A0036 --End
      #No.FUN-A30077  --Begin                                                   
      CALL s_t300_entry_direction(p_bookno,l_npq.npq03,l_npq.npq06,             
                                  l_npq.npq07,l_npq.npq07f)                     
           RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f                       
      #No.FUN-A30077  --End 
      LET l_npq.npq30 = g_oma.oma66   #FUN-A60056
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

#FUN-A40033 --Begin
FUNCTION s_t300_rgl_diff(p_bookno,p_npptype,p_trno)
DEFINE p_bookno         LIKE aza_file.aza81
DEFINE p_npptype        LIKE npp_file.npptype
DEFINE p_trno           LIKE npq_file.npq01
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   IF p_npptype = '1' THEN
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = p_bookno
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = 2
         AND npq01 = p_trno
         AND npq011= 1
         AND npqsys= 'AR'
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = 2
         AND npq01 = p_trno
         AND npq011= 1
         AND npqsys= 'AR'
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = 2
            AND npq01 = p_trno
            AND npq011= 1
            AND npqsys= 'AR'
         LET l_npq1.npqtype = p_npptype
         LET l_npq1.npq00 = 2
         LET l_npq1.npq01 = p_trno
         LET l_npq1.npq011= 1
         LET l_npq1.npqsys= 'AR'
         LET l_npq1.npq07 = l_sum_dr-l_sum_cr
         LET l_npq1.npq24 = l_aaa.aaa03
         LET l_npq1.npq25 = 1
         IF l_npq1.npq07 < 0 THEN
            LET l_npq1.npq03 = l_aaa.aaa11
            LET l_npq1.npq07 = l_npq1.npq07 * -1
            LET l_npq1.npq06 = '1'
         ELSE
            LET l_npq1.npq03 = l_aaa.aaa12
            LET l_npq1.npq06 = '2'
         END IF
         LET l_npq1.npq07f = l_npq1.npq07
         LET l_npq1.npqlegal=g_legal
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",p_trno,"",STATUS,"","",1)
            LET g_success = 'N'
            ROLLBACK WORK
         END IF
      END IF
   END IF
END FUNCTION
#FUN-A40033 --End

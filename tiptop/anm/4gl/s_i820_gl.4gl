# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify.........: No.FUN-5B0093 05/11/29 By Smapmin 定期存款的科目應該先抓取定存銀行其anmi030的科目
#                                                    如果不存在才抓取參數的定存科目
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680088 06/08/28 By Ray 多帳套處理
# Modify.........: No.FUN-680107 06/09/11 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-730032 07/04/04 By Ray 新增帳套
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善 
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空 


DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_gxf		RECORD LIKE gxf_file.*
   DEFINE g_npm		RECORD LIKE npm_file.*
   DEFINE g_nms		RECORD LIKE nms_file.*
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_nmd		RECORD LIKE nmd_file.*
   DEFINE g_trno	LIKE gxf_file.gxf011
   DEFINE g_msg         LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
   DEFINE g_flag         LIKE type_file.chr1       #No.FUN-730032
   DEFINE g_bookno1      LIKE aza_file.aza81       #No.FUN-730032
   DEFINE g_bookno2      LIKE aza_file.aza82       #No.FUN-730032
   DEFINE g_bookno3      LIKE aza_file.aza82       #No.FUN-730032
   DEFINE g_npq25        LIKE npq_file.npq25       #No.FUN-9A0036
   DEFINE g_azi04_2      LIKE azi_file.azi04       #FUN-A40067
   DEFINE g_aag44        LIKE aag_file.aag44       #FUN-D40118 add
 
FUNCTION s_i820_gl(p_trno,p_npptype)
   DEFINE p_trno	LIKE gxf_file.gxf011
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680088
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   WHENEVER ERROR CONTINUE
   LET g_trno = p_trno
   IF g_trno IS NULL THEN RETURN END IF
   SELECT gxf_file.* INTO g_gxf.* FROM gxf_file WHERE gxf011 = g_trno 
   IF STATUS THEN 
#     CALL cl_err('sel gxf',STATUS,1) FUN-660148
      CALL cl_err3("sel","gxf_file",g_trno,"",STATUS,"","sel gxf",1) #FUN-660148
   END IF
   SELECT COUNT(*) INTO l_n FROM npp_file 
    WHERE nppsys='NM' AND npp00=12 AND npp01=g_trno AND npp011=g_gxf.gxf03
      AND nppglno<>' ' AND nppglno IS NOT NULL  #表已拋傳票
   IF l_n > 0 THEN 
      CALL cl_err(p_trno,'aap-122',1) RETURN 
      LET g_success = 'N'      #No.FUN-680088
   END IF
  #SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
   DELETE FROM npp_file 
       WHERE nppsys= 'NM' AND npp00=12 AND npp01 = g_trno AND npp011=1
         AND npptype = p_npptype      #No.FUN-680088
   DELETE FROM npq_file 
       WHERE npqsys= 'NM' AND npq00=12 AND npq01 = g_trno AND npq011=1
         AND npqtype = p_npptype      #No.FUN-680088

   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_trno 
   #FUN-B40056--add--end--

   CALL s_i820_gl_11(p_npptype)      #No.FUN-680029
 # DELETE FROM npq_file WHERE npq01=g_trno AND npq03='-'
   CALL s_i820_diff()                 #No.FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021   
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION s_i820_gl_11(p_npptype)
   DEFINE p_npptype     LIKE npp_file.npptype      #No.FUN-680088
   DEFINE l_aaa03       LIKE aaa_file.aaa03        #FUN-A40067
   DEFINE l_flag        LIKE type_file.chr1        #FUN-D40118 add
 
   #分錄底稿單頭檔
   LET g_npp.nppsys= 'NM'
   LET g_npp.npp00 = 12
   LET g_npp.npp01 = g_gxf.gxf011
   LET g_npp.npp011= 1
   LET g_npp.npp02 = g_gxf.gxf03
   LET g_npp.npp03 = NULL
   LET g_npp.npptype = p_npptype      #No.FUN-680088
 
   #FUN-980005 add legal 
   LET g_npp.npplegal= g_legal
   #FUN-980005 end legal 
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660148
      CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp",1) #No.FUN-660148
      LET g_success='N' #no.5573
   END IF
 
   #分錄底稿單身檔
   LET g_npq.npqsys= 'NM' 
   LET g_npq.npq00 = 12
   LET g_npq.npq01 = g_gxf.gxf011
   LET g_npq.npq011= 1
   LET g_npq.npq02 = 1
   LET g_npq.npq24 = g_gxf.gxf24   #原幣幣別
   LET g_npq.npq25 = g_gxf.gxf25   #匯率
   LET g_npq25 = g_npq.npq25       #No.FUN-9A0036
   LET g_npq.npqtype = p_npptype   #No.FUN-680088
   #借方科目產生
   LET g_npq.npq06 = '1'
   #No.FUN-680088 --begin
   IF p_npptype = '0' THEN
      SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxf.gxf02 #銀存科目
   ELSE
      SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxf.gxf02 #銀存科目
   END IF
   #No.FUN-680088 --end
   IF status=100 OR cl_null(g_npq.npq03) THEN    #找不到才取參數
      #No.FUN-680088 --begin
      IF p_npptype = '0' THEN
         SELECT nms68 INTO g_npq.npq03 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)                  
      ELSE
         SELECT nms681 INTO g_npq.npq03 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)                  
      END IF
      #No.FUN-680088 --end
   END IF
   LET g_npq.npq07f= g_gxf.gxf021
   LET g_npq.npq07 = g_gxf.gxf26
 
  #SELECT aag05 INTO l_aag05 FROM aag_file   #是否做部門管理
  # WHERE aag01=g_npq.npq03
  #IF l_aag05 = 'Y' THEN
  #   LET g_npq.npq05 = g_nmd.nmd18 
  #ELSE
  #   LET g_npq.npq05 = ' '
  #END IF 
   #LET g_npq.npq04 = g_gxf.gxf12   #摘要  No:7348 #FUN-D10065 mark
   LET g_npq.npq04 = NULL   #FUN-D10065
   MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
   IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
   # NO.FUN-5C0015 --start--
   #No.FUN-730032 --begin
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
      LET g_success = 'N' 
   END IF
   IF g_npp.npptype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   #No.FUN-730032 --end
#  CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')       #No.FUN-730032
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
    RETURNING  g_npq.*
   #FUN-D10065--add--str--
   IF cl_null(g_npq.npq04) THEN
      LET g_npq.npq04 = g_gxf.gxf12   #摘要
   END IF
   #FUN-D10065--add--end
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3)  RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087 
   # NO.FUN-5C0015 ---end---
 
   #FUN-980005 add legal 
   LET g_npq.npqlegal= g_legal
   #FUN-980005 end legal 
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
#FUN-A40067 --Begin
      SELECT aaa03 INTO l_aaa03 FROM aaa_file
       WHERE aaa01 = g_bookno2
      SELECT azi04 INTO g_azi04_2 FROM azi_file
       WHERE azi01 = l_aaa03
#FUN-A40067 --End
       CALL s_newrate(g_bookno1,g_bookno2,
                      g_npq.npq24,g_npq25,g_npp.npp02)
       RETURNING g_npq.npq25
       LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
       LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
   ELSE
       LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
   END IF
#No.FUN-9A0036 --End
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = g_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
      CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
      IF l_flag = 'N'   THEN
         LET g_npq.npq03 = ''
      END IF
   END IF
   #FUN-D40118--add--end--
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN 
#     CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
      LET g_success='N' #no.5573
   END IF
 
   #貸方科目產生
   LET g_npq.npq02 = g_npq.npq02 + 1
   LET g_npq.npq06 = '2'
   LET g_npq.npq24 = g_gxf.gxf35   #原幣幣別
   LET g_npq.npq25 = g_gxf.gxf36   #匯率
   LET g_npq25 = g_npq.npq25       #No.FUN-9A0036
   #No.FUN-680088 --begin
   IF p_npptype = '0' THEN
      SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxf.gxf32 #銀存科目
   ELSE
      SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_gxf.gxf32 #銀存科目
   END IF
   #No.FUN-680088 --end
#FUN-5B0093
  IF status=100 OR cl_null(g_npq.npq03) THEN    #找不到才取參數
     #No.FUN-680088 --begin
     IF p_npptype = '0' THEN
        SELECT nms68 INTO g_npq.npq03 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)                  
     ELSE
        SELECT nms681 INTO g_npq.npq03 FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)                  
     END IF
     #No.FUN-680088 --end
  END IF
#END FUN-5B0093
   LET g_npq.npq07f= g_gxf.gxf33f
   LET g_npq.npq07 = g_gxf.gxf33
   #LET g_npq.npq04 = g_gxf.gxf37   #摘要 #FUN-D10065 mark
   LET g_npq.npq04 = NULL   #FUN-D10065
   MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
   IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
   # NO.FUN-5C0015 --start--
#  CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')       #No.FUN-730032
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)       #No.FUN-730032
    RETURNING  g_npq.*
   
   #FUN-D10065--add--str--
   IF cl_null(g_npq.npq04) THEN
      LET g_npq.npq04 = g_gxf.gxf37   #摘要
   END IF
   #FUN-D10065--add--end
   CALL s_def_npq31_npq34(g_npq.*,g_bookno3)  RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087 
   # NO.FUN-5C0015 ---end---
 
   #FUN-980005 add legal 
   LET g_npq.npqlegal= g_legal
   #FUN-980005 end legal 
#No.FUN-9A0036 --Begin
   IF p_npptype = '1' THEN
#FUN-A40067 --Begin
      SELECT aaa03 INTO l_aaa03 FROM aaa_file
       WHERE aaa01 = g_bookno2
      SELECT azi04 INTO g_azi04_2 FROM azi_file
       WHERE azi01 = l_aaa03
#FUN-A40067 --End
       CALL s_newrate(g_bookno1,g_bookno2,
                      g_npq.npq24,g_npq25,g_npp.npp02)
       RETURNING g_npq.npq25
       LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
       LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
   ELSE
       LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
   END IF
#No.FUN-9A0036 --End
   #FUN-D40118--add--str--
   SELECT aag44 INTO g_aag44 FROM aag_file
    WHERE aag00 = g_bookno3
      AND aag01 = g_npq.npq03
   IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
   END IF
   #FUN-D40118--add--end--
   INSERT INTO npq_file VALUES (g_npq.*)
   IF STATUS THEN 
#     CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
      CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
      LET g_success='N' #no.5573
   END IF
 
END FUNCTION
#FUN-A40033 --Begin
FUNCTION s_i820_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
         RETURN
      END IF
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = g_npp.npp00
         AND npq01 = g_npp.npp01
         AND npq011= g_npp.npp011
         AND npqsys= g_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = g_npp.npp00
            AND npq01 = g_npp.npp01
            AND npq011= g_npp.npp011
            AND npqsys= g_npp.nppsys
         LET l_npq1.npqtype = g_npp.npptype
         LET l_npq1.npq00 = g_npp.npp00
         LET l_npq1.npq01 = g_npp.npp01
         LET l_npq1.npq011= g_npp.npp011
         LET l_npq1.npqsys= g_npp.nppsys
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
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",g_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End

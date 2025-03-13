# Prog. Version..: '5.30.06-13.04.01(00009)'     #
#
# Modify.........: 99/07/27 By Carol:異動序號:0->依原單號異動序號 
#                :                   check科目是否做部門管理
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq: 抓取異動碼default值
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670088 06/08/14 By Sarah 依參數判斷,當aaz90='Y',aag05='Y'時,部門(npq05)寫入單頭成本中心,反之則寫入單頭部門
# Modify.........: No.FUN-670047 06/08/15 By day 多帳套修改
# Modify.........: No.FUN-680123 06/09/18 By hongmei 欄位類型轉換
# Modify.........: No.FUN-710050 07/01/29 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.FUN-980011 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-AA0087 11/01/27 By chenmoyan 異動碼類型設定改善
# Modify.........: No.FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-D10065 13/01/17 By wangrr 在調用s_def_npq前npq04=NULL
 
DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_ola	       RECORD LIKE ola_file.*
DEFINE g_ool	       RECORD LIKE ool_file.*
DEFINE g_npp	       RECORD LIKE npp_file.*
DEFINE g_npq	       RECORD LIKE npq_file.*
DEFINE g_trno	       LIKE ola_file.ola01
DEFINE g_chr           LIKE type_file.chr1     #No.FUN-680123 VARCHAR(1)
DEFINE g_msg           LIKE type_file.chr1     #No.FUN-680123 VARCHAR(72)
DEFINE g_aaz90         LIKE aaz_file.aaz90     #FUN-670088 add
DEFINE g_type          LIKE npp_file.npptype   #No.FUN-670047 
DEFINE g_npq25         LIKE npq_file.npq25     #NO.FUN-9A0036
 
#FUNCTION s_t200_gl(p_trno)                    #No.FUN-670047
FUNCTION s_t200_gl(p_trno,p_npptype,p_bookno)           #No.FUN-670047       #No.FUN-740009
   DEFINE p_trno	LIKE ola_file.ola01
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-670047
   DEFINE p_bookno      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-680123 SMALLINT
 
   WHENEVER ERROR CONTINUE
   LET g_trno = p_trno
   LET g_type = p_npptype   #No.FUN-670047
   IF g_trno IS NULL THEN RETURN END IF
   SELECT ola_file.*,ool_file.* INTO g_ola.*,g_ool.*
     FROM ola_file LEFT OUTER JOIN ool_file ON ola_file.ola32=ool_file.ool01 WHERE ola01 = g_trno 
   IF STATUS THEN 
#     CALL cl_err('sel ola+ool',STATUS,1)   #No.FUN-660116
#     CALL cl_err3("sel","ola_file,ool_file",g_trno,"",STATUS,"","sel ola+ool",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         CALL s_errmsg('ola01',g_trno,'sel ola+ool',STATUS,1)
      ELSE
         CALL cl_err3("sel","ola_file,ool_file",g_trno,"",STATUS,"","sel ola+ool",1)   
      END IF
#NO.FUN-710050--END
   END IF
   IF g_ola.ola02 <= g_ooz.ooz09 THEN RETURN END IF
   # 97/05/15 modify 判斷已拋轉傳票不可再產生
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = g_trno 
      AND nppglno IS NOT NULL 
      AND npp00=41
      AND nppsys='AR'
      AND npp011= g_ola.ola011  #異動序號
      AND npptype=g_type  #No.FUN-670047 
   IF l_n > 0 THEN
#     CALL cl_err('sel npp','aap-122',0)   #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         LET  g_showmsg=g_trno,"/",'41',"/",g_ola.ola011
         CALL s_errmsg('npp01,npp00,npp011',g_showmsg,'sel npp','app-122',0)
      ELSE
         CALL cl_err('sel npp','aap-122',0)
      END IF
#NO.FUN-710050--END
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM npq_file 
    WHERE npq01= g_trno 
      AND npq00= 41
      AND npqsys= 'AR'
      AND npq011= g_ola.ola011   #異動序號
      AND npqtype=g_type  #No.FUN-670047 
   IF l_n > 0 THEN
      IF g_type = '0' THEN
         IF NOT s_ask_entry(p_trno) THEN RETURN END IF #Genero
      END IF
   END IF
   DELETE FROM npp_file WHERE npp01 = g_trno AND npp00 = 41
                          AND nppsys = 'AR'  AND npp011 = g_ola.ola011 #異動序號
                          AND npptype=g_type  #No.FUN-670047 
   DELETE FROM npq_file WHERE npq01 = g_trno AND npq00 = 41
                          AND npqsys = 'AR'  AND npq011 = g_ola.ola011 #異動序號
                          AND npqtype=g_type  #No.FUN-670047 
#  CALL s_t200_gl_go()       #No.FUN-740009
   CALL s_t200_gl_go(p_bookno)       #No.FUN-740009
 
   DELETE FROM npq_file WHERE npq01=g_trno AND npq03='-' AND npq00 = 41
                          AND npqsys = 'AR' AND npq011 = g_ola.ola011 #異動序號
                          AND npqtype=g_type  #No.FUN-670047 
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_trno
   #FUN-B40056--add--end--
   CALL s_t200_diff(p_bookno)                 #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021 
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION s_t200_gl_go(p_bookno)       #No.FUN-740009
DEFINE l_occ02  LIKE occ_file.occ02
DEFINE l_aag05  LIKE aag_file.aag05
DEFINE l_year   LIKE type_file.chr1000 #No.FUN-680123 SMALLINT
DEFINE p_bookno LIKE aza_file.aza81       #No.FUN-740009
DEFINE l_bookno1,l_bookno2  LIKE aza_file.aza81    #No.FUN-9A0036
DEFINE l_flag1  LIKE type_file.chr1                #No.FUN-9A0036
DEFINE l_aaa03  LIKE aaa_file.aaa03                #FUN-A40067
DEFINE l_azi04_2 LIKE azi_file.azi04               #FUN-A40067
 
   LET g_npp.nppsys= 'AR'
   LET g_npp.npp00 = 41
   LET g_npp.npp01 = g_ola.ola01
   LET g_npp.npp011= g_ola.ola011 
   LET g_npp.npp02 = g_ola.ola02
   LET g_npp.npp03 = NULL
   LET g_npp.npptype = g_type   #No.FUN-670047
   LET g_npq.npqtype = g_type   #No.FUN-670047
 
   LET g_npp.npplegal = g_legal #FUN-980011 add
   LET g_npq.npqlegal = g_legal #FUN-980011 add
 
   INSERT INTO npp_file VALUES(g_npp.*)
  #No.+041 010330 by plum
  #IF STATUS THEN CALL cl_err('ins npp',STATUS,1) END IF
   IF STATUS OR SQLCA.SQLCODE THEN
#     CALL cl_err('ins npp',SQLCA.SQLCODE,1)    #No.FUN-660116
#     CALL cl_err3("ins","npp_file",g_npp.nppsys,g_npp.npp01,SQLCA.SQLCODE,"","ins npp",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         LET  g_showmsg='41',"/",g_ola.ola01,"/",g_ola.ola011
         CALL s_errmsg('npp00,npp01,npp011',g_showmsg,'ins npp',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("ins","npp_file",g_npp.nppsys,g_npp.npp01,SQLCA.SQLCODE,"","ins npp",1)    
      END IF
#NO.FUN-710050--END
      LET g_success='N' #no.5573
   END IF
  #No.+041..end
 
   LET l_occ02 = ' ' 
   SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_ola.ola05
   LET g_npq.npqsys= 'AR' 
   LET g_npq.npq00 = 41
   LET g_npq.npq01 = g_ola.ola01
   LET g_npq.npq011= 0
   LET g_npq.npq02 = 0
{
   LET g_npq.npq04 = l_occ02 CLIPPED,' ',g_ola.ola04 CLIPPED,' ',
                     g_ola.ola06 CLIPPED,' ',
                     g_ola.ola09 USING '#######&.#&' CLIPPED
}
 # LET g_npq.npq05 = g_ola.olagrup #部門
   LET g_npq.npq21 = g_ola.ola05 LET g_npq.npq22 = l_occ02
   LET g_npq.npq25 = g_ola.ola07 #匯率
   LET g_npq25     = g_npq.npq25 #No.FUN-9A0036 
   LET g_npq.npq24 = g_ola.ola06 
#--------------- (Dr:應收信用狀 Cr:存入信用狀) --------------
      #----------------------------------- (Dr:應收信用狀) --------
      LET g_npq.npq02 = g_npq.npq02 + 1
#.....check此科目是否要做部門管理...................................
      #No.FUN-670047--begin
#     LET g_npq.npq03 = g_ool.ool45
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = g_ool.ool45
      ELSE
         LET g_npq.npq03 = g_ool.ool451
      END IF
      #No.FUN-670047--end  
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03 
                                                AND aag00 = p_bookno       #No.FUN-740009
      CALL s_get_bookno(YEAR(g_ola.ola02)) RETURNING l_flag1,l_bookno1,l_bookno2
#FUN-A40067 --Begin
      SELECT aaa03 INTO l_aaa03 FROM aaa_file
       WHERE aaa01 = l_bookno2
      SELECT azi04 INTO l_azi04_2 FROM azi_file
       WHERE azi01 = l_aaa03
#FUN-A40067 --End
      IF l_aag05 MATCHES '[Yy]' THEN 
        #start FUN-670088 modify
        #當科目要作部門明細管理(aag05=Y),也使用利潤中心功能(aaz90=Y),
        #則分錄之部門欄位請寫入單頭成本中心,反之則寫入單頭部門
        #LET g_npq.npq05 = g_ola.olagrup #部門
         SELECT aaz90 INTO g_aaz90 FROM aaz_file
         IF STATUS OR SQLCA.SQLCODE THEN LET g_aaz90 = 'N' END IF
         IF g_aaz90 = 'Y' THEN
            LET g_npq.npq05 = g_ola.ola930   #成本中心
            IF cl_null(g_npq.npq05) THEN 
               LET g_npq.npq05 = g_ola.ola42 
            END IF
         ELSE
            LET g_npq.npq05 = g_ola.ola42    #部門
         END IF
        #end FUN-670088 modify
      ELSE 
         LET g_npq.npq05 = ' '
      END IF 
#...................................................................
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f = g_ola.ola09
      LET g_npq.npq07 = g_ola.ola09 * g_ola.ola07
      LET g_npq.npq23 = g_ola.ola01
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      LET g_npq.npq04=NULL  #FUN-D10065
      # NO.FUN-5C0015 --start--
#     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')        #No.FUN-740009
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',p_bookno)        #No.FUN-740009
       RETURNING  g_npq.*
      # NO.FUN-5C0015 ---end---
      CALL s_def_npq31_npq34(g_npq.*,p_bookno)                   #FUN-AA0087
       RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
#No.FUN-9A0036 --Begin
      IF g_type= '1' THEN
         CALL s_newrate(l_bookno1,l_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      INSERT INTO npq_file VALUES (g_npq.*)
     #No.+041 010330 by plum
     #IF STATUS THEN CALL cl_err('ins npq#1',STATUS,1) END IF
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#1',SQLCA.SQLCODE,1)    #No.FUN-660116
#        CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.SQLCODE,"","ins npq#1",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
         IF g_bgerr THEN
           LET  g_showmsg='41',"/",g_ola.ola01,"/",g_ola.ola011
           CALL s_errmsg('npp00,npp01,npp011',g_showmsg,'ins npp#1',SQLCA.SQLCODE,1)
         ELSE
           CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.SQLCODE,"","ins npq#1",1)    
         END IF
#NO.FUN-710050--END
         LET g_success='N' #no.5573
      END IF
     #No.+041..end
      #----------------------------------- (Cr:存入信用狀) --------
      LET g_npq.npq02 = g_npq.npq02 + 1
#.....check此科目是否要做部門管理...................................
      #No.FUN-670047--begin
#     LET g_npq.npq03 = g_ool.ool46
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = g_ool.ool46
      ELSE
         LET g_npq.npq03 = g_ool.ool461
      END IF
      #No.FUN-670047--end  
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03 
                                                AND aag00 = p_bookno       #No.FUN-740009
      IF l_aag05 MATCHES '[Yy]'  THEN 
        #start FUN-670088 modify
        #當科目要作部門明細管理(aag05=Y),也使用利潤中心功能(aaz90=Y),
        #則分錄之部門欄位請寫入單頭成本中心,反之則寫入單頭部門
        #LET g_npq.npq05 = g_ola.olagrup #部門
         SELECT aaz90 INTO g_aaz90 FROM aaz_file
         IF STATUS OR SQLCA.SQLCODE THEN LET g_aaz90 = 'N' END IF
         IF g_aaz90 = 'Y' THEN
            LET g_npq.npq05 = g_ola.ola930   #成本中心
            IF cl_null(g_npq.npq05) THEN 
               LET g_npq.npq05 = g_ola.ola42 
            END IF
         ELSE
            LET g_npq.npq05 = g_ola.ola42    #部門
         END IF
        #end FUN-670088 modify
      ELSE 
         LET g_npq.npq05 = ' '
      END IF 
#...................................................................
      LET g_npq.npq06 = '2'
      LET g_npq.npq07f = g_ola.ola09
      LET g_npq.npq07 = g_ola.ola09 * g_ola.ola07
      LET g_npq.npq23 = g_ola.ola01
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      LET g_npq.npq04=NULL  #FUN-D10065
      # NO.FUN-5C0015 --start--
#     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')        #No.FUN-740009
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',p_bookno)        #No.FUN-740009
       RETURNING  g_npq.*
      # NO.FUN-5C0015 ---end---
      CALL s_def_npq31_npq34(g_npq.*,p_bookno)                   #FUN-AA0087
       RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
#No.FUN-9A0036 --Begin
      IF g_type= '1' THEN
         CALL s_newrate(l_bookno1,l_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      INSERT INTO npq_file VALUES (g_npq.*)
     #No.+041 010330 by plum
     #IF STATUS THEN CALL cl_err('ins npq#2',STATUS,1) END IF
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#2',SQLCA.SQLCODE,1)    #No.FUN-660116
#        CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.SQLCODE,"","ins npq#2",1)    #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
         IF g_bgerr THEN
           LET  g_showmsg='41',"/",g_ola.ola01,"/",g_ola.ola011
           CALL s_errmsg('npp00,npp01,npp011',g_showmsg,'ins npp#1',SQLCA.SQLCODE,1)
         ELSE
           CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.SQLCODE,"","ins npq#2",1)    
         END IF
#NO.FUN-710050--END
         LET g_success='N' #no.5573
      END IF
     #No.+041..end
END FUNCTION
#FUN-A40033 --Begin
FUNCTION s_t200_diff(p_bookno)
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE p_bookno         LIKE aza_file.aza81
   IF g_npp.npptype = '1' THEN
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = p_bookno
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
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF STATUS OR SQLCA.SQLCODE THEN
            IF g_bgerr THEN
              LET  g_showmsg='41',"/",g_ola.ola01,"/",g_ola.ola011
              CALL s_errmsg('npp00,npp01,npp011',g_showmsg,'ins npp#1',SQLCA.SQLCODE,1)
            ELSE
              CALL cl_err3("ins","npq_file",l_npq1.npq01,l_npq1.npq02,SQLCA.SQLCODE,"","ins npq#2",1)
            END IF
            LET g_success='N'
         END IF
      END IF
   END IF
END FUNCTION
#FUN-A40033 --End

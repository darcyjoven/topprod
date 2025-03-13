# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670088 06/08/14 By Sarah 依參數判斷,當aaz90='Y',aag05='Y'時,部門(npq05)寫入單頭成本中心,反之則寫入單頭部門
# Modify.........: No.FUN-670047 06/08/16 By Ray 多帳套修改
# Modify.........: No.FUN-680123 06/09/18 By hongmei 欄位類型轉換 
# Modify.........: No.FUN-710050 07/01/29 By yjkhero 錯誤訊息匯整
# Modify.........: No.FUN-740009 07/04/03 By Ray 會計科目加帳套 
# Modify.........: No.FUN-980011 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-AA0087 11/01/30 By chenmoyan 異動碼類型設定改善
# Modify.........: No:MOD-B30006 11/03/01 By Dido 分錄金額須取位 
# Modify.........: No:FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-D10065 13/01/17 By wangrr 在調用s_def_npq前npq04=NULL
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_olc		RECORD LIKE olc_file.*
   DEFINE g_ool		RECORD LIKE ool_file.*
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_npptype     LIKE npp_file.npptype     #No.FUN-670047
   DEFINE g_trno	LIKE olc_file.olc29
   DEFINE g_type        LIKE olc_file.olc28
   DEFINE g_chr         LIKE type_file.chr1       #No.FUN-680123 VARCHAR(1)
   DEFINE g_msg         LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(72)
   DEFINE g_aaz90       LIKE aaz_file.aaz90       #FUN-670088 add
   DEFINE g_aag44       LIKE aag_file.aag44       #FUN-D40118 add
 
FUNCTION s_t210_gl(p_olc01,p_trno,p_type,p_npptype,p_bookno)     #No.FUN-670047
   DEFINE p_olc01	LIKE olc_file.olc01
   DEFINE p_trno	LIKE olc_file.olc29
   DEFINE p_type        LIKE olc_file.olc28
   DEFINE p_npptype     LIKE npp_file.npptype     #No.FUN-670047
   DEFINE p_bookno      LIKE aza_file.aza81       #No.FUN-740009
   DEFINE l_buf		LIKE type_file.chr1000    #No.FUN-680123 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5       #No.FUN-680123 SMALLINT
 
   WHENEVER ERROR CONTINUE
   LET g_trno = p_trno
   LET g_type = p_type 
   LET g_npptype = p_npptype 
   IF g_trno IS NULL THEN RETURN END IF
   SELECT olc_file.*,ool_file.* INTO g_olc.*,g_ool.*
     FROM olc_file, ola_file LEFT OUTER JOIN ool_file ON ola_file.ola32=ool_file.ool01 
    WHERE olc01 = p_olc01 AND olc04 = ola04 #1
   IF STATUS THEN 
#     CALL cl_err('sel olc+ool',STATUS,1)   #No.FUN-660116
#     CALL cl_err3("sel","olc_file,ool_file",p_olc01,"",STATUS,"","sel olc+ool",1)   #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         CALL s_errmsg('olc01',p_olc01,'sel olc+ool',STATUS,1)
      ELSE
         CALL cl_err3("sel","olc_file,ool_file",p_olc01,"",STATUS,"","sel olc+ool",1) 
      END IF
#NO.FUN-710050--END              
   END IF
   IF g_olc.olc12 <= g_ooz.ooz09 THEN RETURN END IF
   # 97/05/15 modify 判斷已拋轉傳票不可再產生
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = g_trno AND npp011 = p_type 
      AND nppglno IS NOT NULL AND nppglno != ' '  
      AND npp00=43 AND nppsys = 'AR'
      AND npptype = g_npptype     #No.FUN-670047
   IF l_n > 0 THEN
#     CALL cl_err('sel npp','aap-122',0) #NO.FUN710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         LET g_showmsg=g_trno,"/",p_type 
         CALL s_errmsg('npp01,npp011',g_showmsg,'sel npp','aap-122',0)
      ELSE
         CALL cl_err('sel npp','aap-122',0)
      END IF
#NO.FUN-710050--END              
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM npq_file 
    WHERE npq01 = g_trno AND npq011 = p_type
      AND npq00 = 43 AND npqsys = 'AR'
      AND npqtype = g_npptype     #No.FUN-670047
   IF l_n > 0 THEN
      IF p_npptype = '0' THEN     #No.FUN-670047
         IF NOT s_ask_entry(p_trno) THEN RETURN END IF #Genero
      END IF     #No.FUN-670047
   END IF
   DELETE FROM npp_file WHERE npp01 = g_trno AND npp011 = p_type
                          AND npp00 = 43 AND nppsys = 'AR' 
                          AND npptype = g_npptype     #No.FUN-670047
   DELETE FROM npq_file WHERE npq01=g_trno  AND npq011 = p_type
                          AND npq00 = 43 AND npqsys = 'AR'  
                          AND npqtype = g_npptype     #No.FUN-670047
#  CALL s_t210_gl_go()       #No.FUN-740009
   CALL s_t210_gl_go(p_bookno)       #No.FUN-740009
   DELETE FROM npq_file WHERE npq01=g_trno AND npq011 = p_type   #異動序號
                          AND npq00 = 43 AND npqsys = 'AR' 
                          AND npq03='-' 
                          AND npqtype = g_npptype     #No.FUN-670047
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_trno
   #FUN-B40056--add--end--
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION s_t210_gl_go(p_bookno)       #No.FUN-740009
DEFINE l_occ02 LIKE occ_file.occ02
DEFINE l_ola06 LIKE ola_file.ola06
DEFINE l_ola02 LIKE ola_file.ola02
DEFINE l_ola07 LIKE ola_file.ola07
DEFINE l_aag05 LIKE aag_file.aag05
DEFINE l_year   LIKE type_file.num5       #No.FUN-680123 SMALLINT 
DEFINE p_bookno LIKE aza_file.aza81       #No.FUN-740009
DEFINE l_flag   LIKE type_file.chr1       #FUN-D40118 add
 
   LET g_npp.nppsys = 'AR'
   LET g_npp.npp00 = 43
   LET g_npp.npp01 = g_trno 
   LET g_npp.npp011 = g_type
   LET g_npp.npp02 = g_olc.olc12
   LET g_npp.npp03 = NULL
   LET g_npp.npptype = g_npptype     #No.FUN-670047
   LET g_npp.npplegal = g_legal      #FUN-980011 add
   INSERT INTO npp_file VALUES(g_npp.*)
  #No.+041 010330 by plum
  #IF STATUS THEN CALL cl_err('ins npp',STATUS,1) END IF
   IF STATUS OR SQLCA.SQLCODE THEN
#     CALL cl_err('ins npp',SQLCA.SQLCODE,1)    #No.FUN-660116
#     CALL cl_err3("ins","npp_file",g_npp.nppsys,g_npp.npp01,SQLCA.SQLCODE,"","ins npp",1)   #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF  g_bgerr THEN  
        LET g_showmsg='43',"/",g_trno,"/",g_type,"/",g_olc.olc12                
        CALL s_errmsg('npp00,npp01,npp011,npp02',g_showmsg,'ins npp',SQLCA.SQLCODE,1)
      ELSE
        CALL cl_err3("ins","npp_file",g_npp.nppsys,g_npp.npp01,SQLCA.SQLCODE,"","ins npp",1)   
      END IF
#NO.FUN-710050--END               
      LET g_success='N' #No.5573
   END IF
  #No.+041..end
   LET l_occ02 = ' ' 
   SELECT occ02 INTO l_occ02 FROM occ_file WHERE occ01 = g_olc.olc05
   #-->依 L/C 取幣別
   LET l_ola06 = ' '  LET l_ola07 = ' '
   SELECT ola02,ola06,ola07 INTO l_ola02,l_ola06,l_ola07 FROM ola_file
    WHERE ola04 = g_olc.olc04
   IF SQLCA.sqlcode THEN LET l_ola06 = ' ' END IF 
   LET g_npq.npqsys = 'AR'
   LET g_npq.npq00 = 43
   LET g_npq.npq01 = g_trno 
  #LET g_npq.npq011 = 1
   LET g_npq.npq011 =g_type
   LET g_npq.npq02 = 0
   LET g_npq.npqtype = g_npptype     #No.FUN-670047
   LET g_npq.npqlegal = g_legal      #FUN-980011 add
{
   LET g_npq.npq04 = l_occ02 clipped,' ',g_olc.olc29 clipped,' ',
                     l_ola06 clipped,' ',
                     g_olc.olc11 using '<<<<<<<<.<<<'
}
 # LET g_npq.npq05 = g_olc.olcgrup   #部門
   LET g_npq.npq21 = g_olc.olc05 LET g_npq.npq22 = l_occ02
   LET g_npq.npq24 = l_ola06    
   LET g_npq.npq25 = l_ola07     #匯率
#--------------- (Dr:存入信用狀 Cr:應收信用狀 ) --------------
      #----------------------------------- (Dr:存入信用狀) --------
      LET g_npq.npq02 = g_npq.npq02 + 1
#.....check此科目是否要做部門管理...................................
      #No.FUN-670047 --begin
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = g_ool.ool46
      ELSE
         LET g_npq.npq03 = g_ool.ool461
      END IF
      #No.FUN-670047 --end
      LET g_npq.npq04=NULL  #FUN-D10065
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                AND aag00 = p_bookno       #No.FUN-740009
      IF l_aag05 MATCHES '[Yy]'  THEN
        #start FUN-670088 modify
        #當科目要作部門明細管理(aag05=Y),也使用利潤中心功能(aaz90=Y),
        #則分錄之部門欄位請寫入單頭成本中心,反之則寫入單頭部門
        #LET g_npq.npq05 = g_olc.olcgrup #部門
         SELECT aaz90 INTO g_aaz90 FROM aaz_file
         IF STATUS OR SQLCA.SQLCODE THEN LET g_aaz90 = 'N' END IF
         IF g_aaz90 = 'Y' THEN
            LET g_npq.npq05 = g_olc.olc930   #成本中心
            IF cl_null(g_npq.npq05) THEN
               LET g_npq.npq05 = g_olc.olc32
            END IF
         ELSE
            LET g_npq.npq05 = g_olc.olc32    #部門
         END IF
        #end FUN-670088 modify
      ELSE
         LET g_npq.npq05 = ' '
      END IF
#...................................................................
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f = g_olc.olc11
      LET g_npq.npq07 = g_olc.olc11 * l_ola07 
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #MOD-B30006
      LET g_npq.npq23 = g_olc.olc01
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      # NO.FUN-5C0015 --start--
#     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')       #No.FUN-740009
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',p_bookno)       #No.FUN-740009
       RETURNING  g_npq.*
      # NO.FUN-5C0015 ---end---
      CALL s_def_npq31_npq34(g_npq.*,p_bookno)                   #FUN-AA0087
       RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = p_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,p_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = p_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,p_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
     #No.+041 010330 by plum
     #IF STATUS THEN CALL cl_err('ins npq#1',STATUS,1) END IF
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#1',SQLCA.SQLCODE,1)    #No.FUN-660116
#        CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.SQLCODE,"","ins npq#1",1)   #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','ins npq#1',SQLCA.SQLCODE,1)
         ELSE
           CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.SQLCODE,"","ins npq#1",1)   
         END IF
#NO.FUN-710050--END    
         LET g_success='N' #no.5573
      END IF
     #No.+041..end
      #----------------------------------- (Cr:應收信用狀) --------
      LET g_npq.npq02 = g_npq.npq02 + 1
#.....check此科目是否要做部門管理...................................
      #No.FUN-670047 --begin
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = g_ool.ool45
      ELSE
         LET g_npq.npq03 = g_ool.ool451
      END IF
      #No.FUN-670047 --end
      LET g_npq.npq04=NULL  #FUN-D10065
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                AND aag00 = p_bookno       #No.FUN-740009
 
      IF l_aag05 MATCHES '[Yy]'  THEN
        #start FUN-670088 modify
        #當科目要作部門明細管理(aag05=Y),也使用利潤中心功能(aaz90=Y),
        #則分錄之部門欄位請寫入單頭成本中心,反之則寫入單頭部門
        #LET g_npq.npq05 = g_olc.olcgrup #部門
         SELECT aaz90 INTO g_aaz90 FROM aaz_file
         IF STATUS OR SQLCA.SQLCODE THEN LET g_aaz90 = 'N' END IF
         IF g_aaz90 = 'Y' THEN
            LET g_npq.npq05 = g_olc.olc930   #成本中心
            IF cl_null(g_npq.npq05) THEN
               LET g_npq.npq05 = g_olc.olc32
            END IF
         ELSE
            LET g_npq.npq05 = g_olc.olc32    #部門
         END IF
        #end FUN-670088 modify
      ELSE
         LET g_npq.npq05 = ' '
      END IF
#...................................................................
      LET g_npq.npq06 = '2'
      LET g_npq.npq07f = g_olc.olc11
      LET g_npq.npq07 = g_olc.olc11 * l_ola07
      LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #MOD-B30006
      LET g_npq.npq23 = g_olc.olc01
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      # NO.FUN-5C0015 --start--
#     CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')       #No.FUN-740009
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',p_bookno)       #No.FUN-740009
       RETURNING  g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,p_bookno)                   #FUN-AA0087
       RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
      # NO.FUN-5C0015 ---end---
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = p_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,p_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (g_npq.*)
     #No.+041 010330 by plum
     #IF STATUS THEN CALL cl_err('ins npq#2',STATUS,1) END IF
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#2',SQLCA.SQLCODE,1)      #No.FUN-660116
#        CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.SQLCODE,"","ins npq#2",1)   #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
         IF g_bgerr THEN
           CALL s_errmsg(' ',' ','ins npq#2',SQLCA.SQLCODE,1)
         ELSE
           CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.SQLCODE,"","ins npq#2",1)   
         END IF
#NO.FUN-710050--END    
         LET g_success='N' #no.5573
      END IF
     #No.+041..end
      CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION

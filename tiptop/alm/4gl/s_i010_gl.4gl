# Prog. Version..: '5.30.07-13.05.31(00004)'     #
#
# Modify ........: No.FUN-4C0013 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify ........: No.FUN-590100 05/09/01 By elva 新增紅衝功能
# Modify.......... No.TQC-5B0080 05/11/28 By ice  生成分錄底稿時,貸項也應考慮oot_file
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-680001 06/08/01 By kim GP3.5 利潤中心
# Modify.........: No.FUN-670047 06/08/09 By Ray 增加兩帳套功能
# Modify.........: No.FUN-680123 06/09/18 By hongmei 欄位類型轉換
# Modify.........: No.FUN-660073 06/11/24 By Nicola 訂單樣品修改
# Modify.........: No.MOD-690136 06/12/08 By Smapmin 已立待驗收入分錄者必須加以沖銷
# Modify.........: No.FUN-710050 07/01/20 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.MOD-730062 07/03/19 By Smapmin 關係人代碼已改為npq37
# Modify.........: No.FUN-740009 07/04/03 By Elva   會計科目加帳套
# Modify.........: No.TQC-740309 07/04/25 By Rayven 生成分錄底稿時分錄底稿二的銷項稅金科目錯誤,取的是科目一的銷項稅金科目
# Modify.........: No.MOD-750132 07/05/30 By Smapmin 調整關係人異動碼相關程式段
# Modify.........: No.MOD-780052 07/08/09 By Smapmin 將摘要(npq04)的舊值清空
# Modify.........: No.TQC-7B0035 07/11/06 By wujie   生成的分錄底稿二收入科目取錯，取的是科目一中的科目
# Modify.........: No.MOD-820056 08/02/14 By Smapmin 分錄金額不可為0
# Modify.........: No.FUN-810045 08/03/06 By Rainy  項目管理:WBS編碼放入異動碼9，費用原因(apb31)放入異動碼10
# Modify.........: No.MOD-840523 08/04/22 By Carrier 對樣品單身生成npq_file時,加上過濾條件單價為0的
# Modify.........: No.CHI-840048 08/05/05 By Smapmin 增加預收匯差的分錄
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A70118 10/07/29 BY shiwuying xxxlegal賦值
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-D40118 13/05/22 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
 
DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_oma		RECORD LIKE oma_file.*
   DEFINE g_ool		RECORD LIKE ool_file.*
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_trno	LIKE oma_file.oma01
   DEFINE g_type	LIKE npp_file.npptype  #FUN-670047
   DEFINE g_t1    	LIKE ooy_file.ooyslip  #FUN-590100 #No.FUN-680123 VARCHAR(5)   
   DEFINE g_ooydmy2     LIKE ooy_file.ooydmy2  #FUN-590100
   DEFINE g_aag05       LIKE aag_file.aag05
   #DEFINE l_aag181      LIKE aag_file.aag181   #No:9189   #MOD-750132
   DEFINE l_aag371      LIKE aag_file.aag371   #No:9189   #MOD-750132
   DEFINE g_aag23       LIKE aag_file.aag23
   DEFINE l_occ02       LIKE occ_file.occ02
   DEFINE l_occ37       LIKE occ_file.occ37
   DEFINE g_chr         LIKE type_file.chr1    #No.FUN-680123 VARCHAR(1)
   DEFINE g_msg         LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(72)
   DEFINE g_bookno1     LIKE aza_file.aza81      #No.FUN-740009
   DEFINE g_bookno2     LIKE aza_file.aza82      #No.FUN-740009
   DEFINE g_bookno3     LIKE aza_file.aza82      #No.FUN-740009
   DEFINE g_flag        LIKE type_file.chr1      #No.FUN-740009
 
FUNCTION s_i010_gl(p_trno,p_npptype)
   DEFINE p_trno	LIKE oma_file.oma01
   DEFINE p_npptype	LIKE npp_file.npptype  #No.FUN-670047
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-680123 VARCHAR(70)
   DEFINE l_n  	 	LIKE type_file.num5    #No.FUN-680123 SMALLINT
 
   LET g_trno = p_trno
   LET g_type = p_npptype     #No.FUN-670047
   IF g_trno IS NULL THEN RETURN END IF
   SELECT oma_file.*,ool_file.* INTO g_oma.*,g_ool.*
          FROM oma_file, OUTER ool_file WHERE oma01 = g_trno 
           AND oma13=ool_file.ool01        #FUN-590100
   IF STATUS THEN 
#     CALL cl_err('sel oma+ool',STATUS,1)    #No.FUN-660116
#No.FUN-710050--begin
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_trno,'sel oma+ool',STATUS,0)
      ELSE
         CALL cl_err3("sel","oma_file,ool_file",g_trno,"",STATUS,"","sel oma+ool",1)   #No.FUN-660116
      END IF   
#No.FUN-710050--end
   END IF
   IF g_oma.oma02 <= g_ooz.ooz09 THEN
#No.FUN-710050--begin
      IF g_bgerr THEN
         CALL s_errmsg('','','','axr-164',0)
      ELSE
         CALL cl_err('','axr-164',0)
      END IF   
#No.FUN-710050--end
      RETURN
   END IF
   # 97/05/15 modify 判斷已拋轉傳票不可再產生
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = g_trno 
      AND nppglno IS NOT NULL 
      AND npp00=2
      AND nppsys = 'AR'
      AND npp011 = 1   #異動序號
      AND npptype = g_type     #No.FUN-670047
   IF l_n > 0 THEN
#No.FUN-710050--begin
      IF g_bgerr THEN
         CALL s_errmsg('','','','axr-122',0)
      ELSE
         CALL cl_err('sel npp','aap-122',0)
      END IF   
#No.FUN-710050--end
      RETURN
   END IF
   SELECT COUNT(*) INTO l_n FROM npq_file 
    WHERE npq01 = g_trno 
      AND npq00 = 2
      AND npqsys = 'AR'
      AND npq011 = 1   #異動序號
      AND npqtype = g_type     #No.FUN-670047
   IF l_n > 0 THEN
      IF NOT s_ask_entry(p_trno) THEN RETURN END IF #Genero
   END IF

   #FUN-B40056--add--str--
   LET l_n = 0
   SELECT COUNT(*) INTO l_n FROM tic_file
    WHERE tic04 = g_trno
   IF l_n > 0 THEN
      IF NOT cl_confirm('sub-533') THEN
         RETURN
      END IF
   END IF
   DELETE FROM tic_file WHERE tic04 = g_trno
   #FUN-B40056--add--end--

   DELETE FROM npp_file WHERE npp01 = g_trno AND npp00 = 2
                          AND nppsys = 'AR'  AND npp011 = 1   #異動序號
                          AND npptype = g_type     #No.FUN-670047
   DELETE FROM npq_file WHERE npq01 = g_trno AND npq00 = 2
                          AND npqsys = 'AR'  AND npq011 = 1   #異動序號
                          AND npqtype = g_type     #No.FUN-670047
   #-----MOD-750132---------
   ##LET g_npq.npq14=''   #MOD-730062
   #LET g_npq.npq37=''   #MOD-730062
   ##-->for 合併報表-關係人
   #SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
   # WHERE occ01=g_oma.oma03
   ##IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED  END IF   #MOD-730062
   #IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED  END IF   #MOD-730062
   #-----END MOD-750132-----
   #FUN-590100  --begin
   CALL s_get_doc_no(g_oma.oma01) RETURNING g_t1     
   SELECT ooydmy2 INTO g_ooydmy2 FROM ooy_file WHERE ooyslip=g_t1  
   #FUN-590100  --end
 
   #No.FUN-740009  --Begin
   CALL s_get_bookno(YEAR(g_oma.oma02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(g_oma.oma02,'aoo-081',1)
      LET g_success = 'N'
      RETURN
   END IF
   IF p_npptype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   #No.FUN-740009  --End  
 
   CASE WHEN g_oma.oma00='12' CALL s_i010_gl_12()
        WHEN g_oma.oma00='13' CALL s_i010_gl_12()
        WHEN g_oma.oma00='14' CALL s_i010_gl_12()
        WHEN g_oma.oma00='15' CALL s_i010_gl_12()   #baofei
        WHEN g_oma.oma00='16' CALL s_i010_gl_12()   #baofei
        WHEN g_oma.oma00='17' CALL s_i010_gl_12()   #baofei 
        WHEN g_oma.oma00='18' CALL s_i010_gl_12()   #baofei
       #No.+009 010416 by plum add
       #FUN-590100  --begin
        WHEN g_oma.oma00 MATCHES '2[1,2,5,7]' 
             IF g_aza.aza26='2' AND g_ooydmy2='Y' THEN 
                CALL s_i010_gl_12()
             ELSE
                CALL s_i010_gl_21()
             END IF
   END CASE
   DELETE FROM npq_file WHERE npq01=g_trno AND npq03='-' AND npq00 = 2
                          AND npqsys = 'AR' AND npq011 = 1   #異動序號
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION s_i010_gl_12()
   DEFINE l_omb33               LIKE omb_file.omb33   #No.FUN-680123 VARCHAR(20)
   DEFINE l_omb40               LIKE omb_file.omb40   #No.FUN-660073
   DEFINE l_azf14               LIKE azf_file.azf14   #No.FUN-660073
   DEFINE l_omb14,l_omb16       LIKE omb_file.omb14   #FUN-4C0013 #No.FUN-680123 DEC(20,6)  
   #add 030625 NO.A083
   DEFINE l_cnt                 LIKE type_file.num5   #No.FUN-680123 SMALLINT
   DEFINE l_oot04               LIKE oot_file.oot04 
   DEFINE l_oot04x              LIKE oot_file.oot04x
   DEFINE l_oot04t              LIKE oot_file.oot04t
   DEFINE l_oot05               LIKE oot_file.oot05 
   DEFINE l_oot05x              LIKE oot_file.oot05x
   DEFINE l_oot05t              LIKE oot_file.oot05t
   DEFINE l_n                   LIKE type_file.num5   #No.FUN-680123 SMALLINT #No.TQC-5B0080
   DEFINE l_sql                 LIKE type_file.chr1000#No.FUN-680123 VARCHAR(1000)            #No.FUN-670047 
   #-----MOD-690136---------
   DEFINE l_omb03               LIKE omb_file.omb03
   DEFINE l_omb31               LIKE omb_file.omb31
   DEFINE l_oga07               LIKE oga_file.oga07
   DEFINE l_omb14_2             LIKE omb_file.omb14
   DEFINE l_omb16_2             LIKE omb_file.omb16
   DEFINE s_omb14               LIKE omb_file.omb14
   DEFINE s_omb16               LIKE omb_file.omb16
   #-----END MOD-690136-----
  #FUN-810045 add begin
   DEFINE l_omb41               LIKE omb_file.omb41,   #專案　
          l_omb42               LIKE omb_file.omb42    #WBS
  #FUN-810045 add end
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   LET g_npp.nppsys = 'AR'
   LET g_npp.npp00 = 2
   LET g_npp.npp01 = g_oma.oma01
   LET g_npp.npp011 =  1
   LET g_npp.npp02 = g_oma.oma02
   LET g_npp.npp03 = NULL
   LET g_npp.npptype = g_type     #No.FUN-670047
   LET g_npp.npplegal = g_legal   #No.FUN-A70118
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS OR SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         LET g_showmsg=g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00
         CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("ins","npp_file",g_npp.nppsys,g_npp.npp01,SQLCA.sqlcode,"","ins npp",1)   #No.FUN-660116
      END IF   
      LET g_success='N'
   END IF
 
   LET g_npq.npqsys = 'AR'
   LET g_npq.npq00 = 2
   LET g_npq.npq01 = g_oma.oma01
   LET g_npq.npq011 =  1
   LET g_npq.npq02 = 0
   LET g_npq.npqtype = g_type     #No.FUN-670047
   LET g_npq.npq04 = NULL        LET g_npq.npq05 = g_oma.oma15
   LET g_npq.npq21 = g_oma.oma03 LET g_npq.npq22 = g_oma.oma032
   LET g_npq.npq24 = g_oma.oma23 LET g_npq.npq25 = g_oma.oma24
#--------------- (如有預收發票訂金時 Dr:預收 Cr:銷貨收入) -------------------
   IF NOT cl_null(g_oma.oma19) THEN
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq03 = g_ool.ool21
      LET g_npq.npq05 = g_oma.oma15
      LET g_aag05 = NULL
      LET g_aag23 = NULL
      SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
       WHERE aag01 = g_npq.npq03
         AND aag00 = g_bookno3   #No.FUN-740009
      IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
         LET g_npq.npq05 = ' '
      ELSE
         IF g_aag05='Y' THEN
            LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
         END IF
      END IF
      LET g_npq.npq06 = '1'
      LET g_npq.npq21 = g_oma.oma03
      LET g_npq.npq22 = g_oma.oma032
      LET g_npq.npq23 = g_oma.oma19
      SELECT SUM(oma54),SUM(oma56) INTO g_npq.npq07f,g_npq.npq07 FROM oma_file
       WHERE oma19=g_oma.oma19
         AND oma16 IN (SELECT oga16 FROM oga_file WHERE oga01 = g_oma.oma16)
         AND oma00='11' AND omaconf='Y' AND omavoid='N'
      SELECT oma23,oma24 INTO g_npq.npq24,g_npq.npq25 FROM oma_file
       WHERE oma19=g_oma.oma19
         AND oma16 IN (SELECT oga16 FROM oga_file WHERE oga01 = g_oma.oma16)
         AND oma00='11' AND omaconf='Y' AND omavoid='N'
     #IF g_aza.aza87 = 'Y' THEN LET g_npq.npq07 = 0 LET g_npq.npq07f = 0 END IF
      IF g_aag23 = 'Y' THEN
         LET g_npq.npq08 = g_oma.oma63    # 專案
      ELSE
         LET g_npq.npq08 = null
      END IF
      LET l_aag371=' '
      LET g_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=g_npq.npq03
         AND aag00 = g_bookno3   
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      IF g_oma.oma00 MATCHES '2*' THEN
         LET g_npq.npq07 = (-1)*g_npq.npq07                                  
         LET g_npq.npq07f= (-1)*g_npq.npq07f  
      END IF
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
      RETURNING  g_npq.*
      IF l_aag371 MATCHES '[23]' THEN
         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
          WHERE occ01=g_oma.oma03
         IF cl_null(g_npq.npq37) THEN
            IF l_occ37='Y' THEN 
               LET g_npq.npq37=l_occ02 CLIPPED  
            END IF   
         END IF
      END IF
      IF g_npq.npq07 <> 0 THEN   #MOD-820056 
      LET g_npq.npqlegal = g_legal   #No.FUN-A70118
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
       #IF STATUS THEN CALL cl_err('ins npq#1',STATUS,1) LET g_success = 'N'
      IF STATUS OR SQLCA.SQLCODE THEN
         IF g_bgerr THEN
            LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
            CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#1',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   #No.FUN-660116
         END IF   
         LET g_success='N'
      END IF
      END IF   #MOD-820056
     #No.+041..end
 
      #-----CHI-840048---------
      #處理預收匯差分錄
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq04 = NULL
      LET g_npq.npq07f = 0
      LET g_npq.npq07  = g_npq.npq07  - g_oma.oma53
      LET g_npq.npq24 = g_aza.aza17
      LET g_npq.npq25 = 1
      IF g_npq.npq07 < 0 THEN  
         LET g_npq.npq07 = (-1)*g_npq.npq07                                  
         LET g_npq.npq06 = '1'
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = g_ool.ool52
         ELSE
            LET g_npq.npq03 = g_ool.ool521
         END IF
      ELSE
         LET g_npq.npq06 = '2'
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = g_ool.ool53
         ELSE
            LET g_npq.npq03 = g_ool.ool531
         END IF
      END IF
      LET g_aag05 = NULL
      LET g_aag23 = NULL
      SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
       WHERE aag01 = g_npq.npq03
         AND aag00 = g_bookno3   
      IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
         LET g_npq.npq05 = ' '
      ELSE
         IF g_aag05='Y' THEN
            LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
         END IF
      END IF
      IF g_aag23 = 'Y' THEN
         LET g_npq.npq08 = g_oma.oma63    
      ELSE
         LET g_npq.npq08 = null
      END IF
      LET l_aag371=' '
      LET g_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=g_npq.npq03
         AND aag00 = g_bookno3   
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) 
      RETURNING  g_npq.*
      IF l_aag371 MATCHES '[23]' THEN
         #-->for 合併報表-關係人
         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
          WHERE occ01=g_oma.oma03
         IF cl_null(g_npq.npq37) THEN
            IF l_occ37='Y' THEN 
               LET g_npq.npq37=g_oma.oma03 CLIPPED   
            END IF   
         END IF
      END IF
      LET g_npq.npqlegal = g_legal   #No.FUN-A70118
      IF g_npq.npq07 <> 0 THEN    
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS OR SQLCA.SQLCODE THEN
            IF g_bgerr THEN
               LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
               CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#2',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#2",1)   #No.FUN-660116
            END IF   
            LET g_success='N'
         END IF
      END IF   
      #-----END CHI-840048-----
 
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq04 = NULL   #MOD-780052
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = g_ool.ool41
      ELSE
         LET g_npq.npq03 = g_ool.ool411
      END IF
#No.TQC-7B0035 --end
##1999/07/26 modify by sophia  若不作部門管理
      LET g_aag05 = NULL
      LET g_aag23 = NULL
      SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
       WHERE aag01 = g_npq.npq03 
         AND aag00 = g_bookno3   #No.FUN-740009
      IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
         LET g_npq.npq05 = ' '
      ELSE
         #FUN-680001...............begin
         #LET g_npq.npq05 = g_oma.oma15
         IF g_aag05='Y' THEN
            LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
         END IF
         #FUN-680001...............end
      END IF
      IF g_aag23 = 'Y' THEN
         LET g_npq.npq08 = g_oma.oma63    # 專案
      ELSE
         LET g_npq.npq08 = null
      END IF
##----------------------------
      LET g_npq.npq06 = '2'
      LET g_npq.npq23 = g_oma.oma01
      #-----CHI-840048---------
      LET g_npq.npq07f = g_oma.oma52
      LET g_npq.npq07 = g_oma.oma53
      LET g_npq.npq24 = g_oma.oma23
      LET g_npq.npq25 = g_oma.oma24
      #-----END CHI-840048-----
        #No:9189
      #-----MOD-750132---------
      LET l_aag371=' '
      LET g_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=g_npq.npq03
         AND aag00 = g_bookno3   
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      IF g_oma.oma00 MATCHES '2*' THEN
         LET g_npq.npq07 = (-1)*g_npq.npq07                                  
         LET g_npq.npq07f= (-1)*g_npq.npq07f  
      END IF
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
      RETURNING  g_npq.*
      IF l_aag371 MATCHES '[23]' THEN
         #-->for 合併報表-關係人
         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
          WHERE occ01=g_oma.oma03
         IF cl_null(g_npq.npq37) THEN
            IF l_occ37='Y' THEN 
               LET g_npq.npq37=l_occ02 CLIPPED  
            END IF   
         END IF
      END IF
      LET g_npq.npqlegal = g_legal   #No.FUN-A70118
      #-----END MOD-750132-----
      IF g_npq.npq07 <> 0 THEN   #MOD-820056 
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
     #No.+041 010330 by plum
       #IF STATUS THEN CALL cl_err('ins npq#2',STATUS,1) LET g_success = 'N' 
      IF STATUS OR SQLCA.SQLCODE THEN
         IF g_bgerr THEN
            LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
            CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#2',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#2",1)   #No.FUN-660116
         END IF   
#No.FUN-710050--end
         LET g_success='N'
      END IF
      END IF   #MOD-820056
   END IF
#--------------- (Dr:應收 Cr:銷貨收入,稅) -------------------
      #----------------------------------- (Dr:應收) --------
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq04 = NULL   #MOD-780052
      IF g_type = '0' THEN
         LET g_npq.npq03 = g_oma.oma18
      ELSE
         LET g_npq.npq03 = g_oma.oma181
      END IF
      #FUN-670047  --end  
##1999/07/26 modify by sophia  若不作部門管理
      LET g_aag05 = NULL
      LET g_aag23 = NULL
      SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
       WHERE aag01 = g_npq.npq03
         AND aag00 = g_bookno3   #No.FUN-740009
      IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
         LET g_npq.npq05 = ' '
      ELSE
         #FUN-680001...............begin
         #LET g_npq.npq05 = g_oma.oma15
         IF g_aag05='Y' THEN
            LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
         END IF
         #FUN-680001...............end
      END IF
##----------------------------
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f= g_oma.oma54t
      LET g_npq.npq07 = g_oma.oma56t
      IF g_aag23 = 'Y' THEN
         LET g_npq.npq08 = g_oma.oma63    # 專案
      ELSE
         LET g_npq.npq08 = null
      END IF
      LET g_npq.npq23 = g_oma.oma01
      LET l_aag371=' '
      LET g_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=g_npq.npq03
         AND aag00 = g_bookno3   
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      IF g_oma.oma00 MATCHES '2*' THEN
         LET g_npq.npq07 = (-1)*g_npq.npq07                                  
         LET g_npq.npq07f= (-1)*g_npq.npq07f  
      END IF
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
      RETURNING  g_npq.*
      IF l_aag371 MATCHES '[23]' THEN
         #-->for 合併報表-關係人
         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
          WHERE occ01=g_oma.oma03
         IF cl_null(g_npq.npq37) THEN
            IF l_occ37='Y' THEN 
               LET g_npq.npq37=l_occ02 CLIPPED  
            END IF   
         END IF
      END IF
      LET g_npq.npqlegal = g_legal   #No.FUN-A70118
      #-----END MOD-750132-----
      IF g_npq.npq07 <> 0 THEN   #MOD-820056 
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
         IF g_bgerr THEN
            LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
            CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#3',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#3",1)   #No.FUN-660116
         END IF   
#No.FUN-710050--end
         LET g_success='N'
      END IF
      END IF   #MOD-820056
     #No.+041..end
      #----------------------------------- (Cr:銷貨收入) ----
      #No.FUN-670047 --begin
      IF g_type = '0' THEN
         LET l_sql = "SELECT omb33,omb40,omb41,omb42,SUM(omb14),SUM(omb16) FROM omb_file",    #FUN-810045 add omb40/41/42
                     " WHERE omb01='",g_oma.oma01,"'",
                     "   AND omb33 IS NOT NULL",
                     "   AND omb13 <> 0 ",   #No.MOD-840523
                     "  GROUP BY omb33,omb40,omb41,omb42"   #FUN-810045 add omb40/41/42
      ELSE 
         LET l_sql = "SELECT omb331,omb40,omb41,omb42,SUM(omb14),SUM(omb16) FROM omb_file",   #FUN-810045 add omb40/41/42
                     " WHERE omb01='",g_oma.oma01,"'",
                     "   AND omb331 IS NOT NULL",
                     "   AND omb13 <> 0 ",   #No.MOD-840523
                     "  GROUP BY omb331,omb40,omb41,omb42"   #FUN-810045 add omb40/41/42
      END IF
      PREPARE s_i010_gl_p2 FROM l_sql
      DECLARE s_i010_gl_c2 CURSOR FOR s_i010_gl_p2
      #若有退貨折讓待扺,把金額平均分攤
      IF l_cnt > 0 THEN
         IF g_type = '0' THEN
            SELECT COUNT(DISTINCT(omb33)) INTO l_n FROM omb_file
             WHERE omb01=g_oma.oma01 AND omb33 IS NOT NULL
         ELSE 
            SELECT COUNT(DISTINCT(omb331)) INTO l_n FROM omb_file
             WHERE omb01=g_oma.oma01 AND omb331 IS NOT NULL
         END IF
         #No.FUN-670047 --end
         IF l_n > 0 THEN
            LET  l_oot04t = l_oot04t / l_n
            LET  l_oot05t = l_oot05t / l_n
         END IF
      END IF
      #No.TQC-5B0080 --end-- 
      FOREACH s_i010_gl_c2 INTO l_omb33,l_omb40,l_omb41,l_omb42,l_omb14,l_omb16  #FUN-810045 add omb40/41/42
         IF STATUS THEN EXIT FOREACH END IF
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq04 = NULL   #MOD-780052
         LET g_npq.npq03 = l_omb33
##1999/07/26 modify by sophia  若不作部門管理
         LET g_aag05 = NULL
         LET g_aag23 = NULL
         SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
          WHERE aag01 = g_npq.npq03
            AND aag00 = g_bookno3   #No.FUN-740009
         IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
            LET g_npq.npq05 = ' '
         ELSE
            LET g_npq.npq05 = g_oma.oma15
            #FUN-680001...............begin
            IF g_aag05='Y' THEN
               LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
            END IF
            #FUN-680001...............end
         END IF
##----------------------------
         LET g_npq.npq06 = '2'
         #No.TQC-5B0080 --start--
         IF l_cnt > 0 THEN
            LET g_npq.npq07f = l_omb14 - l_oot04t
            LET g_npq.npq07 = l_omb16 - l_oot05t
         ELSE
            LET g_npq.npq07f = l_omb14 
            LET g_npq.npq07 = l_omb16 
         END IF
         LET g_npq.npq23 = g_oma.oma01
         LET l_aag371=' '
         LET g_npq.npq37=''
         SELECT aag371 INTO l_aag371 FROM aag_file
          WHERE aag01=g_npq.npq03
            AND aag00 = g_bookno3   
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
         #FUN-590100  --begin
         IF g_oma.oma00 MATCHES '2*' THEN
            LET g_npq.npq07 = (-1)*g_npq.npq07                                  
            LET g_npq.npq07f= (-1)*g_npq.npq07f  
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_omb03,'',g_bookno3) #No.FUN-740009
         RETURNING  g_npq.*
        IF l_aag371 MATCHES '[23]' THEN
           #-->for 合併報表-關係人
           SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            WHERE occ01=g_oma.oma03
           IF cl_null(g_npq.npq37) THEN
              IF l_occ37='Y' THEN 
                 LET g_npq.npq37=l_occ02 CLIPPED  
              END IF   
           END IF
        END IF
        #-----END MOD-750132-----
         #FUN-810045 add begin
          LET g_npq.npq08 = l_omb41  #專案
          LET g_npq.npq35 = l_omb42  #WBS
          LET g_npq.npq36 = l_omb40  #費用原因
         #FUN-810045 add end
         LET g_npq.npqlegal = g_legal   #No.FUN-A70118
         IF g_npq.npq07 <> 0 THEN   #MOD-820056 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
        #No.+041 010330 by plum
          #IF STATUS THEN CALL cl_err('ins npq#4',STATUS,1) LET g_success = 'N' 
         IF STATUS OR SQLCA.SQLCODE THEN
#           CALL cl_err('ins npq#4',SQLCA.SQLCODE,1)   #No.FUN-660116
#No.FUN-710050--begin
            IF g_bgerr THEN
               LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
               CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#4',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#4",1)   #No.FUN-660116
            END IF   
#No.FUN-710050--end
            LET g_success='N'
         END IF
         END IF   #MOD-820056
        #No.+041..end
         LET g_oma.oma54=g_oma.oma54-l_omb14
         LET g_oma.oma56=g_oma.oma56-l_omb16
         #No.TQC-5B0080 --start-- 
         IF l_cnt > 0 THEN
            LET g_oma.oma54=g_oma.oma54+l_oot04t
            LET g_oma.oma56=g_oma.oma56+l_oot05t
         END IF
         #No.TQC-5B0080 --end--
      END FOREACH
      #-----No.FUN-660073-----
      LET l_sql = "SELECT omb40,omb41,omb42,SUM(omb14),SUM(omb16),azf14", #FUN-810045 add omb41/42
                  "  FROM omb_file,azf_file",
                  " WHERE omb01='",g_oma.oma01,"'",
                  "   AND omb40 IS NOT NULL",
                  "   AND omb40 = azf01",
                  "   AND azf08 = 'Y'",
                  "   AND omb13 = 0 ",   #No.MOD-840523
                  "  GROUP BY omb40,omb41,omb42,azf14"   #FUN-810045 add omb41/42
 
      PREPARE s_i010_gl_p3 FROM l_sql
      DECLARE s_i010_gl_c3 CURSOR FOR s_i010_gl_p3
 
      FOREACH s_i010_gl_c3 INTO l_omb40,l_omb41,l_omb42,l_omb14,l_omb16,l_azf14   #FUN-810045 add omb41/42
         IF STATUS THEN
            EXIT FOREACH
         END IF
 
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq04 = NULL   #MOD-780052
         LET g_npq.npq03 = l_azf14
         LET g_aag05 = NULL
         LET g_aag23 = NULL
         SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
          WHERE aag01 = g_npq.npq03
            AND aag00 = g_bookno3   #No.FUN-740009
         IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
            LET g_npq.npq05 = ' '
         ELSE
            IF g_aag05='Y' THEN
               LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
            END IF
         END IF
         LET g_npq.npq06 = '2'
         IF l_cnt > 0 THEN 
            LET g_npq.npq07f= l_omb14 - l_oot04
            LET g_npq.npq07 = l_omb16 - l_oot05
         ELSE
            LET g_npq.npq07f= l_omb14
            LET g_npq.npq07 = l_omb16
         END IF
         LET g_npq.npq23 = g_oma.oma01
         LET l_aag371=' '
         LET g_npq.npq37=''
         SELECT aag371 INTO l_aag371 FROM aag_file
          WHERE aag01=g_npq.npq03
            AND aag00 = g_bookno3   
 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
 
         IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
 
         IF g_oma.oma00 MATCHES '2*' THEN
            LET g_npq.npq07 = (-1)*g_npq.npq07                                  
            LET g_npq.npq07f= (-1)*g_npq.npq07f  
         END IF
 
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
              RETURNING g_npq.*
 
         IF l_aag371 MATCHES '[23]' THEN
            #-->for 合併報表-關係人
            SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
             WHERE occ01=g_oma.oma03
            IF cl_null(g_npq.npq37) THEN
               IF l_occ37='Y' THEN 
                  LET g_npq.npq37=l_occ02 CLIPPED  
               END IF   
            END IF
         END IF
         LET g_npq.npq08 = l_omb41  #專案
         LET g_npq.npq35 = l_omb42  #WBS
         LET g_npq.npq36 = l_omb40　#費用原因
         LET g_npq.npqlegal = g_legal   #No.FUN-A70118
         IF g_npq.npq07 <> 0 THEN   #MOD-820056 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS OR SQLCA.SQLCODE THEN
            IF g_bgerr THEN
               LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
               CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#5',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#5",1)   #No.FUN-660116
            END IF   
            LET g_success='N'
         END IF
         END IF   #MOD-820056
 
         LET g_oma.oma54 = g_oma.oma54-l_omb14
         LET g_oma.oma56 = g_oma.oma56-l_omb16
         IF l_cnt > 0 THEN
            LET g_oma.oma54 = g_oma.oma54+l_oot04t
            LET g_oma.oma56 = g_oma.oma56+l_oot05t
         END IF
 
      END FOREACH
      #-----No.FUN-660073 END-----
 
      IF g_oma.oma56 > 0 THEN
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq04 = NULL   #MOD-780052
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = g_ool.ool41
         ELSE
            LET g_npq.npq03 = g_ool.ool411
         END IF
         LET g_aag05 = NULL
         LET g_aag23 = NULL
         SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
          WHERE aag01 = g_npq.npq03
            AND aag00 = g_bookno3   #No.FUN-740009
         IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
            LET g_npq.npq05 = ' '
         ELSE
            IF g_aag05='Y' THEN
               LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
            END IF
         END IF
         ##----------------------------
         LET g_npq.npq06 = '2'
         #modify 030625 NO.A083
         IF l_cnt > 0 THEN 
            LET g_npq.npq07f= g_oma.oma54 - l_oot04
            LET g_npq.npq07 = g_oma.oma56 - l_oot05
         ELSE
            LET g_npq.npq07f= g_oma.oma54
            LET g_npq.npq07 = g_oma.oma56
         END IF
         IF g_aag23 = 'Y' THEN
            LET g_npq.npq08 = g_oma.oma63    # 專案
         ELSE
            LET g_npq.npq08 = null
         END IF
       # LET g_npq.npq10 = g_oma.oma02
         LET g_npq.npq23 = g_oma.oma01
         #No:9189
         #-----MOD-750132---------
         LET l_aag371=' '
         LET g_npq.npq37=''
         SELECT aag371 INTO l_aag371 FROM aag_file
          WHERE aag01=g_npq.npq03
            AND aag00 = g_bookno3   
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
         IF g_oma.oma00 MATCHES '2*' THEN
            LET g_npq.npq07 = (-1)*g_npq.npq07                                  
            LET g_npq.npq07f= (-1)*g_npq.npq07f  
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
         RETURNING  g_npq.*
        #NO.FUN-5C0015 ---end---
         #-----MOD-750132---------
         IF l_aag371 MATCHES '[23]' THEN
            #-->for 合併報表-關係人
            SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
             WHERE occ01=g_oma.oma03
            IF cl_null(g_npq.npq37) THEN
               IF l_occ37='Y' THEN 
                  LET g_npq.npq37=l_occ02 CLIPPED  
               END IF   
            END IF
         END IF
         LET g_npq.npqlegal = g_legal   #No.FUN-A70118
         #-----END MOD-750132-----
         IF g_npq.npq07 <> 0 THEN   #MOD-820056 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
        #No.+041 010330 by plum
          #IF STATUS THEN CALL cl_err('ins npq#5',STATUS,1) LET g_success = 'N' 
         IF STATUS OR SQLCA.SQLCODE THEN
#           CALL cl_err('ins npq#5',SQLCA.SQLCODE,1)   #No.FUN-660116
#No.FUN-710050--begin
            IF g_bgerr THEN
               LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
               CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#5',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#5",1)   #No.FUN-660116
            END IF   
#No.FUN-710050--end
            LET g_success='N'
         END IF
         END IF   #MOD-820056
        #No.+041..end
      END IF
      #----------------------------------- (Cr:稅) ----------
      IF g_oma.oma54x > 0 THEN
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq04 = NULL   #MOD-780052
         IF g_npq.npqtype = '0' THEN   #No.TQC-740309
            LET g_npq.npq03 = g_ool.ool28
         #No.TQC-740309 --start--
         ELSE
            LET g_npq.npq03 = g_ool.ool281
         END IF
         #No.TQC-740309 --end--
##1999/07/26 modify by sophia  若不作部門管理
         LET g_aag05 = NULL
         LET g_aag23 = NULL
         SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
          WHERE aag01 = g_npq.npq03
            AND aag00 = g_bookno3   #No.FUN-740009
         IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
            LET g_npq.npq05 = ' '
         ELSE
            #FUN-680001...............begin
            #LET g_npq.npq05 = g_oma.oma15
            IF g_aag05='Y' THEN
               LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
            END IF
            #FUN-680001...............end
         END IF
##----------------------------
         LET g_npq.npq06 = '2'
         #modify 030625 NO.A083
         IF l_cnt > 0 THEN 
            LET g_npq.npq07f= g_oma.oma54x - l_oot04x
            LET g_npq.npq07 = g_oma.oma56x - l_oot05x
         ELSE
            LET g_npq.npq07f= g_oma.oma54x
            LET g_npq.npq07 = g_oma.oma56x
         END IF
         IF g_aag23 = 'Y' THEN
            LET g_npq.npq08 = g_oma.oma63    # 專案
         ELSE
            LET g_npq.npq08 = null
         END IF
       # LET g_npq.npq10 = g_oma.oma02
         LET g_npq.npq23 = g_oma.oma01
         #No:9189
         #-----MOD-750132---------
         LET l_aag371=' '
         LET g_npq.npq37=''
         SELECT aag371 INTO l_aag371 FROM aag_file
          WHERE aag01=g_npq.npq03
            AND aag00 = g_bookno3   
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
         IF g_oma.oma00 MATCHES '2*' THEN
            LET g_npq.npq07 = (-1)*g_npq.npq07                                  
            LET g_npq.npq07f= (-1)*g_npq.npq07f  
         END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
         RETURNING  g_npq.*
         IF l_aag371 MATCHES '[23]' THEN
            #-->for 合併報表-關係人
            SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
             WHERE occ01=g_oma.oma03
            IF cl_null(g_npq.npq37) THEN
               IF l_occ37='Y' THEN 
                  LET g_npq.npq37=l_occ02 CLIPPED  
               END IF   
            END IF
         END IF
         LET g_npq.npqlegal = g_legal   #No.FUN-A70118
         IF g_npq.npq07 <> 0 THEN   #MOD-820056 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
        #No.+041 010330 by plum
          #IF STATUS THEN CALL cl_err('ins npq#6',STATUS,1) LET g_success = 'N'
         IF STATUS OR SQLCA.SQLCODE THEN
#           CALL cl_err('ins npq#6',SQLCA.SQLCODE,1)   #No.FUN-660116
#No.FUN-710050--begin
            IF g_bgerr THEN
               LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
               CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#6',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#6",1)   #No.FUN-660116
            END IF   
#No.FUN-710050--end
            LET g_success='N'
         END IF
         END IF   #MOD-820056
        #No.+041..end
      END IF
END FUNCTION
 
#No.+009 010416 by plum add for oma00='2*'可產生分錄 ->  貸 oma18
FUNCTION s_i010_gl_21()
   DEFINE l_omb33               LIKE omb_file.omb33    #No.FUN-680123 VARCHAR(20)
   DEFINE l_omb14,l_omb16       LIKE omb_file.omb14    #No.FUN-680123 DEC(20,6)  #FUN-4C0013
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   LET g_npp.nppsys = 'AR'
   LET g_npp.npp00 = 2
   LET g_npp.npp01 = g_oma.oma01
   LET g_npp.npp011 =  1
   LET g_npp.npp02 = g_oma.oma02
   LET g_npp.npp03 = NULL
   LET g_npp.npptype = g_type     #No.FUN-670047
   LET g_npp.npplegal = g_legal   #No.FUN-A70118
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
#     CALL cl_err('ins npp',STATUS,1)   #No.FUN-660116
#No.FUN-710050--begin
      IF g_bgerr THEN
         LET g_showmsg=g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00
         CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("ins","npp_file",g_npp.nppsys,g_npp.npp01,STATUS,"","ins npp",1)   #No.FUN-660116
      END IF   
#No.FUN-710050--end
      LET g_success='N' 
   END IF
 
   LET g_npq.npqsys = 'AR'
   LET g_npq.npq00 = 2
   LET g_npq.npq01 = g_oma.oma01
   LET g_npq.npq011 =  1
   LET g_npq.npq02 = 0
   LET g_npq.npqtype = g_type     #No.FUN-670047
   LET g_npq.npq04 = NULL        LET g_npq.npq05 = g_oma.oma15
   LET g_npq.npq21 = g_oma.oma03 LET g_npq.npq22 = g_oma.oma032
   LET g_npq.npq24 = g_oma.oma23 LET g_npq.npq25 = g_oma.oma24
 
  #Dr:oma34=1,4->ool42;=5->ool47,稅   Cr:oma18(ool26)
  ##借方:ool42,ool47 貸方:oma18
     #-(Dr:銷退) ----------
       LET g_npq.npq06 = '1'
       LET g_npq.npq02 = g_npq.npq02 + 1
       CASE WHEN g_oma.oma00='21'
                 IF g_oma.oma34 ='5' THEN
                    LET g_npq.npq03=g_ool.ool47
                 ELSE
                    LET g_npq.npq03=g_ool.ool42
                 END IF
            WHEN g_oma.oma00='22'
                 LET g_npq.npq03=g_ool.ool25
            WHEN g_oma.oma00='25'
                 LET g_npq.npq03=g_ool.ool51
       END CASE
       LET g_npq.npq05 = g_oma.oma15
       LET g_aag05 = NULL
       LET g_aag23 = NULL
       SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
        WHERE aag01 = g_npq.npq03
          AND aag00 = g_bookno3   #No.FUN-740009
       IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
          LET g_npq.npq05 = ' '
       ELSE
          #FUN-680001...............begin
          #LET g_npq.npq05 = g_oma.oma15
          IF g_aag05='Y' THEN
             LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
          END IF
          #FUN-680001...............end
       END IF
       LET g_npq.npq07f= g_oma.oma54
       LET g_npq.npq07 = g_oma.oma56
       IF g_aag23 = 'Y' THEN
          LET g_npq.npq08 = g_oma.oma63    # 專案
       ELSE
          LET g_npq.npq08 = null
       END IF
       LET g_npq.npq23 = g_oma.oma01
       #No:9189
       #-----MOD-750132---------
       LET l_aag371=' '
       LET g_npq.npq37=''
       SELECT aag371 INTO l_aag371 FROM aag_file
        WHERE aag01=g_npq.npq03
          AND aag00 = g_bookno3   
       #LET l_aag181=' '
       ##LET g_npq.npq14=''   #MOD-730062
       #LET g_npq.npq37=''   #MOD-730062
       #SELECT aag181 INTO l_aag181 FROM aag_file
       # WHERE aag01=g_npq.npq03 
       #   AND aag00 = g_bookno3   #No.FUN-740009
       #IF l_aag181 MATCHES '[23]' THEN
       #   #-->for 合併報表-關係人
       #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
       #    WHERE occ01=g_oma.oma03
       #   #IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED  END IF   #MOD-730062
       #   IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED  END IF   #MOD-730062
       #END IF
       #-----END MOD-750132-----
       #End
       MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
       IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      #NO.FUN-5C0015 --start--
      #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','') #No.FUN-740009
       CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
       RETURNING  g_npq.*
      #NO.FUN-5C0015 ---end---
       #-----MOD-750132---------
       IF l_aag371 MATCHES '[23]' THEN
          #-->for 合併報表-關係人
          SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
           WHERE occ01=g_oma.oma03
          IF cl_null(g_npq.npq37) THEN
             IF l_occ37='Y' THEN 
                LET g_npq.npq37=l_occ02 CLIPPED  
             END IF   
          END IF
       END IF
       #-----END MOD-750132-----
       LET g_npq.npqlegal = g_legal   #No.FUN-A70118
       IF g_npq.npq07 <> 0 THEN   #MOD-820056 
      #FUN-D40118 ---Add--- Start
       SELECT aag44 INTO l_aag44 FROM aag_file
        WHERE aag00 = g_bookno3
          AND aag01 = g_npq.npq03
       IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
          CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
          IF l_flag = 'N'   THEN
             LET g_npq.npq03 = ''
          END IF
       END IF
      #FUN-D40118 ---Add--- End
       INSERT INTO npq_file VALUES (g_npq.*)
       IF STATUS THEN 
#         CALL cl_err('ins npq#1',STATUS,1)      #No.FUN-660116
#No.FUN-710050--begin
          IF g_bgerr THEN
             LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
             CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#1',SQLCA.SQLCODE,1)
          ELSE
             CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#1",1)   #No.FUN-660116
          END IF   
#No.FUN-710050--end
          LET g_success='N' 
       END IF
       END IF   #MOD-820056
       LET g_npq.npq04=NULL
     #-(Dr:稅) ----------
       IF g_oma.oma54x > 0 THEN
         LET g_npq.npq02 = g_npq.npq02 + 1
         IF g_npq.npqtype = '0' THEN   #No.TQC-740309
            LET g_npq.npq03 = g_ool.ool28
         #No.TQC-740309 --start--
         ELSE
            LET g_npq.npq03 = g_ool.ool281
         END IF
         #No.TQC-740309 --end--
         LET g_aag05 = NULL
         LET g_aag23 = NULL
         SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
          WHERE aag01 = g_npq.npq03
            AND aag00 = g_bookno3   #No.FUN-740009
         IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
            LET g_npq.npq05 = ' '
         ELSE
            #FUN-680001...............begin
            #LET g_npq.npq05 = g_oma.oma15
            IF g_aag05='Y' THEN
               LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
            END IF
            #FUN-680001...............end
         END IF
         LET g_npq.npq06 = '1'
         LET g_npq.npq07f= g_oma.oma54x
         LET g_npq.npq07 = g_oma.oma56x
         IF g_aag23 = 'Y' THEN
            LET g_npq.npq08 = g_oma.oma63    # 專案
         ELSE
            LET g_npq.npq08 = null
         END IF
         LET g_npq.npq23 = g_oma.oma01
         #No:9189
         #-----MOD-750132---------
         LET l_aag371=' '
         LET g_npq.npq37=''
         SELECT aag371 INTO l_aag371 FROM aag_file
          WHERE aag01=g_npq.npq03
            AND aag00 = g_bookno3   
         #LET l_aag181=' '
         ##LET g_npq.npq14=''   #MOD-730062
         #LET g_npq.npq37=''   #MOD-730062
         #SELECT aag181 INTO l_aag181 FROM aag_file
         # WHERE aag01=g_npq.npq03
         #   AND aag00 = g_bookno3   #No.FUN-740009
         #IF l_aag181 MATCHES '[23]' THEN
         #   #-->for 合併報表-關係人
         #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
         #    WHERE occ01=g_oma.oma03
         #   #IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED  END IF   #MOD-730062
         #   IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED  END IF   #MOD-730062
         #END IF
         #-----END MOD-750132-----
         #End
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
        #NO.FUN-5C0015 --start--
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','') #No.FUN-740009
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
         RETURNING  g_npq.*
        #NO.FUN-5C0015 ---end---
         #-----MOD-750132---------
         IF l_aag371 MATCHES '[23]' THEN
            #-->for 合併報表-關係人
            SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
             WHERE occ01=g_oma.oma03
            IF cl_null(g_npq.npq37) THEN
               IF l_occ37='Y' THEN 
                  LET g_npq.npq37=l_occ02 CLIPPED  
               END IF   
            END IF
         END IF
         LET g_npq.npqlegal = g_legal   #No.FUN-A70118
         #-----END MOD-750132-----
         IF g_npq.npq07 <> 0 THEN   #MOD-820056 
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
#           CALL cl_err('ins npq#2',STATUS,1)     #No.FUN-660116
#No.FUN-710050--begin
            IF g_bgerr THEN
               LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
               CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#2',SQLCA.SQLCODE,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#2",1)   #No.FUN-660116
            END IF   
#No.FUN-710050--end
            LET g_success='N'
         END IF
         END IF   #MOD-820056
      END IF
      LET g_npq.npq04=NULL
     #-(Cr:oma18) ----------
       LET g_npq.npq06 = '2'
       LET g_npq.npq02 = g_npq.npq02 + 1
       #No.FUN-670047 --begin
       IF g_npq.npqtype = '0' THEN
          LET g_npq.npq03 = g_oma.oma18
       ELSE
          LET g_npq.npq03 = g_oma.oma181
       END IF
       #No.FUN-670047 --end
       LET g_npq.npq05 = g_oma.oma15
       LET g_aag05 = NULL
       LET g_aag23 = NULL
       SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
        WHERE aag01 = g_npq.npq03
          AND aag00 = g_bookno3   #No.FUN-740009
       IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
          LET g_npq.npq05 = ' '
       ELSE
            #FUN-680001...............begin
            #LET g_npq.npq05 = g_oma.oma15
            IF g_aag05='Y' THEN
               LET g_npq.npq05=s_i010_gl_set_npq05(g_oma.oma15,g_oma.oma930)
            END IF
            #FUN-680001...............end
       END IF
       LET g_npq.npq07f= g_oma.oma54t
       LET g_npq.npq07 = g_oma.oma56t
       IF g_aag23 = 'Y' THEN
          LET g_npq.npq08 = g_oma.oma63    # 專案
       ELSE
          LET g_npq.npq08 = null
       END IF
       LET g_npq.npq23 = g_oma.oma01
       #No:9189
       #-----MOD-750132---------
       LET l_aag371=' '
       LET g_npq.npq37=''
       SELECT aag371 INTO l_aag371 FROM aag_file
        WHERE aag01=g_npq.npq03
          AND aag00 = g_bookno3   
       #LET l_aag181=' '
       ##LET g_npq.npq14=''   #MOD-730062
       #LET g_npq.npq37=''   #MOD-730062
       #SELECT aag181 INTO l_aag181 FROM aag_file
       # WHERE aag01=g_npq.npq03 
       #   AND aag00 = g_bookno3   #No.FUN-740009
       #IF l_aag181 MATCHES '[23]' THEN
       #   #-->for 合併報表-關係人
       #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
       #    WHERE occ01=g_oma.oma03
       #   #IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED  END IF   #MOD-730062
       #   IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED  END IF   #MOD-730062
       #END IF
       #-----END MOD-750132-----
       #End
       MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
       IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      #NO.FUN-5C0015 --start--
      #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','') #No.FUN-740009
       CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) #No.FUN-740009
       RETURNING  g_npq.*
      #NO.FUN-5C0015 ---end---
       #-----MOD-750132---------
       IF l_aag371 MATCHES '[23]' THEN
          #-->for 合併報表-關係人
          SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
           WHERE occ01=g_oma.oma03
          IF cl_null(g_npq.npq37) THEN
             IF l_occ37='Y' THEN 
                LET g_npq.npq37=l_occ02 CLIPPED  
             END IF   
          END IF
       END IF
       LET g_npq.npqlegal = g_legal   #No.FUN-A70118
       #-----END MOD-750132-----
       IF g_npq.npq07 <> 0 THEN   #MOD-820056 
      #FUN-D40118 ---Add--- Start
       SELECT aag44 INTO l_aag44 FROM aag_file
        WHERE aag00 = g_bookno3
          AND aag01 = g_npq.npq03
       IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
          CALL s_chk_ahk(g_npq.npq03,g_bookno3) RETURNING l_flag
          IF l_flag = 'N'   THEN
             LET g_npq.npq03 = ''
          END IF
       END IF
      #FUN-D40118 ---Add--- End
       INSERT INTO npq_file VALUES (g_npq.*)
       IF STATUS THEN 
#          CALL cl_err('ins npq#3',STATUS,1)      #No.FUN-660116
#No.FUN-710050--begin
           IF g_bgerr THEN
              LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npqsys,"/",g_npq.npq00
              CALL s_errmsg('npq01,npq011,npqsys,npq00',g_showmsg,'ins npq#3',SQLCA.SQLCODE,1)
           ELSE
              CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#3",1)   #No.FUN-660116
           END IF   
#No.FUN-710050--end
          LET g_success='N' 
       END IF
       END IF   #MOD-820056
END FUNCTION
 
#FUN-680001...............begin
FUNCTION s_i010_gl_set_npq05(p_dept,p_omb930)
DEFINE p_dept   LIKE gem_file.gem01,
       p_omb930 LIKE omb_file.omb930
       
   IF g_aaz.aaz90='Y' THEN
      RETURN p_omb930
   ELSE
      RETURN p_dept
   END IF
END FUNCTION
#FUN-680001...............end

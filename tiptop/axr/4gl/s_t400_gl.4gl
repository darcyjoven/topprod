# Prog. Version..: '5.30.07-13.06.04(00010)'     #
#
# Modify.........: No:7752 03/08/07 By Wiky 判斷aag151 is not....
# Modify.........: No:9189 04/03/10 By Kitty判斷aag181
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.FUN-660116 06/06/19 By ice cl_err --> cl_err3
# Modify.........: No.FUN-670047 06/08/15 By Ray 多帳套修改
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-710050 07/01/30 By yjkhero 錯誤訊息匯整  
# Modify.........: No.FUN-730073 07/04/02 By sherry  會計科目加帳套  
# Modify.........: No.MOD-750132 07/05/30 By Smapmin 調整關係人異動碼相關程式段
# Modify.........: No.TQC-810021 08/01/08 By chenl   1.修正一個變量錯誤
# Modify.........:                                   2.在判斷aag371,aag05的時候，分帳套取值
# Modify.........: No.CHI-830037 08/10/17 By jan請調整將目前財務架構中使用關系人的地方,請統一使用"代碼",而非"簡稱"
# Modify.........: No.FUN-8C0107 09/01/05 By jamie 產生分錄時，npq05依成本中心或部門給值
# Modify.........: No.MOD-910102 09/01/21 By Sarah 因為oob_file沒有成本中心的欄位,所以不需要判斷aaz90,npq05直接給oob13(部門)值
# Modify.........: No.FUN-960141 09/07/10 By dongbg GP5.2修改:當axrp304產生axrt410的時候,分錄底稿彈性設置g_prog傳axrt410
# Modify.........: No.FUN-980011 09/08/25 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-A20022 10/03/03 By sabrina 分錄底稿摘要彈性設定要能抓取單身資料
# Modify.........: No.FUN-A40076 10/05/12 By xiaofeizhu  應收調帳重新生成分錄，新增調帳部分的分錄
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-950053 10/08/18 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No.FUN-AA0088 11/01/30 By wujie  应收调帐修改
# Modify.........: No.FUN-AA0087 11/01/30 By chenmoyan 異動碼類型設定改善
# Modify.........: No.TQC-B30014 11/03/02 By wujie  调帐客户抓取修改
# Modify.........: No.FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.TQC-C20346 12/02/23 By lutingting待抵調帳修改
# Modify.........: No.TQC-C20464 12/02/24 By lutingting待抵調帳修改
# Modify.........: No:MOD-C90151 12/09/21 By Polly 調整批次產生分錄時，只詢問一次是否產生分錄即可
# Modify.........: No.FUN-D10065 13/01/16 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:MOD-D50243 13/06/01 By yinhy 關係人核算項依照npq21抓取

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_msg         LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(72)
   DEFINE g_chr         LIKE type_file.chr1      #No.FUN-680123 VARCHAR(01)
   DEFINE g_npptype     LIKE npp_file.npptype     #No.FUN-670047
   DEFINE g_bookno1     LIKE aza_file.aza81      #No.FUN-730073
   DEFINE g_ooz02p      LIKE ooz_file.ooz02p     #總帳所在營運中心      #No.TQC-810021 
   DEFINE g_ooz02b      LIKE ooz_file.ooz02b     #使用主帳套編號        #No.TQC-810021  
   DEFINE g_ooz02c      LIKE ooz_file.ooz02c     #使用次帳套編號        #No.TQC-810021  
   DEFINE g_dbs         LIKE azp_file.azp03      #總帳所在數據庫代碼    #No.TQC-810021 
   DEFINE g_sql         STRING
   DEFINE g_npq25       LIKE npq_file.npq25      #No.FUN-9A0036
   DEFINE g_aag44       LIKE aag_file.aag44      #FUN-D40118 add
 
FUNCTION s_t400_gl(p_trno,p_npptype)     #No.FUN-670047
   DEFINE p_trno	LIKE oob_file.oob01
   DEFINE p_npptype     LIKE npp_file.npptype     #No.FUN-670047
   #DEFINE l_aag181      LIKE aag_file.aag181       #No:9189   #MOD-750132
   DEFINE l_aag371      LIKE aag_file.aag371       #No:9189   #MOD-750132
   DEFINE l_buf		LIKE type_file.chr1000   #No.FUN-680123 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5      #No.FUN-680123 SMALLINT
   DEFINE l_ooa02 LIKE ooa_file.ooa02      #No.TQC-B70021 
    
   WHENEVER ERROR CONTINUE
   IF p_trno IS NULL THEN RETURN END IF
   LET g_npptype = p_npptype     #No.FUN-670047
   # 97/05/15 modify 判斷已拋轉傳票不可再產生
   SELECT COUNT(*) INTO l_n FROM npp_file 
   #WHERE npp01 = g_trno  AND nppglno IS NOT NULL   #No.TQC-810021 mark
    WHERE npp01 = p_trno  AND nppglno IS NOT NULL   #No.TQC-810021 
      AND npp00 = 3       AND nppsys = 'AR'
      AND npp011= 1
      AND npptype = g_npptype     #No.FUN-670047
   IF l_n > 0 THEN
#     CALL cl_err('sel npp','aap-122',0)  #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         LET g_showmsg='3',"/",'1'
         CALL s_errmsg('npp00,npp011',g_showmsg,'sel npp','aap-122',0)
      ELSE
         CALL cl_err('sel npp','aap-122',0)
      END IF
#NO.FUN-710050--END      
      RETURN
   END IF
  #------------------------MOD-C90151----------------mark
  #SELECT COUNT(*) INTO l_n FROM npq_file WHERE npq01 = p_trno AND npq00= 3
  #                                         AND npqsys = 'AR'  AND npq011=1
  #                                         AND npqtype = g_npptype     #No.FUN-670047
  #IF l_n > 0 THEN
  #   IF g_npptype='0' THEN
  #      IF NOT s_ask_entry(p_trno) THEN RETURN END IF #Genero
  #   END IF
  #END IF
  #------------------------MOD-C90151----------------mark
   DELETE FROM npp_file WHERE npp01 = p_trno AND npp00 = 3
                          AND nppsys = 'AR'  AND npp011= 1
                          AND npptype = g_npptype     #No.FUN-670047
   DELETE FROM npq_file WHERE npq01 = p_trno AND npq00 = 3
                          AND npqsys = 'AR'  AND npq011=1
                          AND npqtype = g_npptype     #No.FUN-670047
##No.      modify 1998/11/03假設分錄有AR-AP之間沖銷
##產生時機為拋轉傳票時確認
   DELETE FROM npp_file WHERE npp01 = p_trno AND npp00 = 3
                          AND nppsys = 'AP'  AND npp011= 1
                          AND npptype = g_npptype     #No.FUN-670047
   DELETE FROM npq_file WHERE npq01 = p_trno AND npq00 = 3
                          AND npqsys = 'AP'  AND npq011=1
                          AND npqtype = g_npptype     #No.FUN-670047
## ------------------------------------------------
   
  #No.TQC-810021--begin--
   LET g_ooz02p = NULL
   LET g_ooz02b = NULL
   LET g_ooz02c = NULL
 
   SELECT ooz02p,ooz02b,ooz02c INTO g_ooz02p,g_ooz02b,g_ooz02c FROM ooz_file
   LET g_plant_new = g_ooz02p
   #CALL s_getdbs()        #FUN-A50102
   #LET g_dbs = g_dbs_new  #FUN-A50102
  
  #No.TQC-810021---end---
 
   CALL s_t400_gl_1(p_trno)
   DELETE FROM npq_file WHERE npq01 = p_trno AND npq03='-' AND npq00 = 3
                          AND npqsys = 'AR'  AND npq011=1
                          AND npqtype = g_npptype     #No.FUN-670047
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = p_trno
   #FUN-B40056--add--end--     
   CALL s_t400_diff(p_npptype,p_trno)                 #FUN-A40033
#No.TQC-B70021 --begin 
   SELECT ooa02 INTO l_ooa02 FROM ooa_file LEFT OUTER JOIN ool_file ON ooa_File.ooa13=ool_file.ool01 
    WHERE ooa01 = p_trno 
      AND  ooaconf !='X' 
      
   CALL s_flows('3','',p_trno,l_ooa02,'N',p_npptype,TRUE)   
#No.TQC-B70021 --end
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION s_t400_gl_1(p_trno)
   DEFINE p_trno	LIKE oob_file.oob01
   DEFINE l_ooa		RECORD LIKE ooa_file.*
   DEFINE l_oob		RECORD LIKE oob_file.*
   DEFINE l_ool		RECORD LIKE ool_file.*
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_oof		RECORD LIKE oof_file.*        #FUN-A40076 Add 
   DEFINE l_aag05       LIKE aag_file.aag05
   #DEFINE l_aag181      LIKE aag_file.aag181    #No:9189   #MOD-750132
   DEFINE l_aag371      LIKE aag_file.aag371    #No:9189   #MOD-750132
   DEFINE l_occ02       LIKE occ_file.occ02
   DEFINE l_occ37       LIKE occ_file.occ37
   DEFINE l_aaa03       LIKE aaa_file.aaa03     #FUN-A40067
   DEFINE l_azi04_2     LIKE azi_file.azi04     #FUN-A40067
   DEFINE l_flag        LIKE type_file.chr1    #FUN-D40118 add
 
   SELECT ooa_file.*,ool_file.* INTO l_ooa.*,l_ool.*
          FROM ooa_file LEFT OUTER JOIN ool_file ON ooa_File.ooa13=ool_file.ool01 WHERE ooa01 = p_trno 
                                         AND  ooaconf !='X' #010803 增
   IF STATUS THEN 
#     CALL cl_err('sel ooa+ool',STATUS,1)  #No.FUN-660116
#     CALL cl_err3("sel","ooa_file,ool_file",p_trno,"",STATUS,"","sel ooa+ool",1)   #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',p_trno,'sel ooa+ool',STATUS,0)
      ELSE
         CALL cl_err3("sel","ooa_file,ool_file",p_trno,"",STATUS,"","sel ooa+ool",1)   
      END IF
#NO.FUN-710050--END      
   END IF
  
   #-->for 合併報表-關係人
   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
   WHERE occ01=l_ooa.ooa03
   #IF l_occ37='Y' THEN LET l_npq.npq14=l_occ02 CLIPPED  END IF   #No:7752
   #<--
 
   LET l_npp.nppsys = 'AR'
   LET l_npp.npp00 = '3'
   LET l_npp.npp01 = l_ooa.ooa01
   LET l_npp.npp011 = 1
   LET l_npp.npp02 = l_ooa.ooa02
   LET l_npp.npp03 = NULL
   LET l_npp.npptype = g_npptype     #No.FUN-670047
   LET l_npp.npplegal= g_legal       #FUN-980011 add
   INSERT INTO npp_file VALUES(l_npp.*)
  #No.+041 010330 by plum
    #IF STATUS THEN CALL cl_err('ins npp',STATUS,1)  
   IF STATUS OR SQLCA.SQLCODE THEN
#     CALL cl_err('ins npp',SQLCA.SQLCODE,1)   #No.FUN-660116
#     CALL cl_err3("ins","npp_file",l_npp.nppsys,l_npp.npp01,SQLCA.sqlcode,"","ins npp",1)   #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         LET g_showmsg='3',"/",l_ooa.ooa01,"/",'1',"/",l_ooa.ooa02
         CALL s_errmsg('npp00,npp01,npp011,npp02',g_showmsg,'ins npp',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("ins","npp_file",l_npp.nppsys,l_npp.npp01,SQLCA.sqlcode,"","ins npp",1)   
      END IF
#NO.FUN-710050--END      
      LET g_success='N' #no.5573
   END IF
  #No.+041..end
 
   LET l_npq.npqsys = 'AR'
   LET l_npq.npq00 = '3'
   LET l_npq.npq01 = l_ooa.ooa01
   LET l_npq.npq011 = 1
   LET l_npq.npqtype = g_npptype     #No.FUN-670047
   LET l_npq.npqlegal= g_legal       #FUN-980011 add
   LET l_npq.npq02 = 0
  #LET l_npq.npq10 = l_ooa.ooa02
   LET l_npq.npq21 = l_ooa.ooa03 LET l_npq.npq22 = l_ooa.ooa032
 #No.TQC-810021--begin-- modify
 #DECLARE t400_gl_1c CURSOR FOR
 #        SELECT * FROM oob_file
 #         WHERE oob01=p_trno AND oob11 IS NOT NULL AND oob11 != ' '
 #         ORDER BY oob02
  LET g_sql = " SELECT * FROM oob_file ",
              "  WHERE oob01='",p_trno CLIPPED,"' "
  IF g_npptype = '0' THEN 
     LET g_sql = g_sql," AND oob11 IS NOT NULL AND oob11 != ' ' "
  ELSE 
     LET g_sql = g_sql," AND oob111 IS NOT NULL AND oob111 != ' ' "
  END IF 
  LET g_sql = g_sql," ORDER BY oob02 "
  PREPARE t400_gl_1p FROM g_sql
  DECLARE t400_gl_1c CURSOR FOR t400_gl_1p
 #No.TQC-810021---end--- modify
  FOREACH t400_gl_1c INTO l_oob.*
      LET l_npq.npq02 = l_oob.oob02
      IF g_npptype='0' THEN              #No.FUN-670047 
         LET l_npq.npq03 = l_oob.oob11
      ELSE                               #No.FUN-670047
         LET l_npq.npq03 = l_oob.oob111  #No.FUN-670047
      END IF                             #No.FUN-670047
#No.FUN-AA0088 --begin
     #TQC-C20346--mod--str--
     #IF g_prog = 'axrt401' AND g_ooz.ooz29 ='Y' AND l_oob.oob03 = '1' THEN 
      IF (g_prog = 'axrt401' OR g_prog = 'axrp604') AND g_ooz.ooz29 ='Y'   #TQC-C20464 add axrp604 
         AND (l_ooa.ooa40 = '01' AND l_oob.oob03 = '1' OR(l_ooa.ooa40 = '02' AND l_oob.oob03 = '2'))  THEN 
     #TQC-C20346--mod--end
         IF g_npptype='0' THEN 
            SELECT ooc03 INTO l_npq.npq03 FROM ooc_file WHERE ooc01 = l_oob.oob26
         ELSE 
         	  SELECT ooc04 INTO l_npq.npq03 FROM ooc_file WHERE ooc01 = l_oob.oob26
         END IF 
      END IF 
#No.FUN-AA0088 --end
      #LET l_npq.npq04 = l_oob.oob12 #FUN-D10065 mark
      LET l_npq.npq04 = NULL         #FUN-D10065 add
      #No:7752  多此aag151判斷,異動碼4才不會全塞l_occ02值
      #-----MOD-750132---------
      ##No:9189 異動碼四應該判斷aag181
      # LET l_aag181=' '
      # LET l_aag05=' '
      # SELECT aag181,aag05 INTO l_aag181,l_aag05 FROM aag_file
      #  WHERE aag01=l_oob.oob11
      #No:9189 異動碼四應該判斷aag371
       LET l_aag371=' '
       LET l_aag05=' '
      #No.TQC-810021--begin--
      #SELECT aag371,aag05 INTO l_aag371,l_aag05 FROM aag_file
      # WHERE aag01=l_oob.oob11
       IF g_npptype = '0' THEN
          #LET g_sql = " SELECT aag371,aag05 FROM ",g_dbs,"aag_file ",
          LET g_sql = " SELECT aag371,aag05 FROM ",cl_get_target_table(g_plant_new,'aag_file'), #FUN-A50102
                      "  WHERE aag01 = '",l_oob.oob11 CLIPPED,"' ",
                      "    AND aag00 = '",g_ooz02b CLIPPED,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
          PREPARE t400_sel_aag_p1 FROM g_sql
          EXECUTE t400_sel_aag_p1 INTO l_aag371,l_aag05
       ELSE
          #LET g_sql = " SELECT aag371,aag05 FROM ",g_dbs,"aag_file ",
          LET g_sql = " SELECT aag371,aag05 FROM ",cl_get_target_table(g_plant_new,'aag_file'), #FUN-A50102
                      "  WHERE aag01 = '",l_oob.oob111 CLIPPED,"' ",
                      "    AND aag00 = '",g_ooz02c CLIPPED,"'"
 	 CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102
          PREPARE t400_sel_aag_p2 FROM g_sql
          EXECUTE t400_sel_aag_p2 INTO l_aag371,l_aag05
       END IF
      #No.TQC-810021---end---
      #-----END MOD-750132-----
 
       #-----MOD-750132---------
       #IF l_occ37='Y' AND l_aag181 MATCHES '[23]' THEN   #No:9189
       #   LET l_npq.npq14=l_occ02 CLIPPED
       #ELSE
       #   LET l_npq.npq14=NULL
       #END IF
       #-----END MOD-750132-----
      ##
 
      #-----NO:       modify in 99/07/26------
     #SELECT aag05 INTO l_aag05 FROM aag_file
     # WHERE aag01=l_npq.npq03
      IF l_aag05='Y' THEN
        #因為oob_file沒有成本中心的欄位,所以不需要判斷aaz90,
        #npq05直接給oob13(部門)值
        #IF g_aaz.aaz90 !='Y' THEN         #FUN-8C0107 add  #MOD-910102 mark
            LET l_npq.npq05 = l_oob.oob13
        #END IF                            #FUN-8C0107 add  #MOD-910102 mark
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      #----------------------------------------
      LET l_npq.npq06 = l_oob.oob03     
      LET l_npq.npq07f= l_oob.oob09
      LET l_npq.npq07 = l_oob.oob10
      LET l_npq.npq23 = l_oob.oob06
      LET l_npq.npq24 = l_oob.oob07
      LET l_npq.npq25 = l_oob.oob08
      LET g_npq25     = l_npq.npq25        #No.FUN-9A0036
      LET l_npq.npq21 = NULL                  #FUN-A40076 ADD
      LET l_npq.npq22 = NULL                  #FUN-A40076 ADD

 
      
      #No.+080 010425 by linda add 客戶抓單身參考單號之客戶
      CASE
#No.TQC-B30014 --begin
#No.FUN-AA0088 --begin
        #WHEN l_oob.oob03='1' AND g_prog ='axrt401'  #TQC-C20346
        WHEN (g_prog = 'axrt401' OR g_prog = 'axrp604') AND (l_ooa.ooa40 = '01' AND l_oob.oob03='1' OR (l_ooa.ooa40 = '02' AND l_oob.oob03 = '2'))  #TQC-C20346  #TQC-C20464 add axrp604 
             LET l_npq.npq21 = l_oob.oob24
             SELECT occ02 INTO l_npq.npq22 FROM occ_file WHERE occ01 = l_npq.npq21
        #WHEN l_oob.oob03='2' AND g_prog ='axrt401'  #TQC-C20346
        WHEN (g_prog = 'axrt401' OR g_prog = 'axrp604') AND (l_ooa.ooa40 = '01' AND l_oob.oob03='2' OR (l_ooa.ooa40 = '02' AND l_oob.oob03 = '1'))  #TQC-C20346 #TQC-C20464 add axrp604 
              LET l_npq.npq21 = l_ooa.ooa03 
              LET l_npq.npq22 = l_ooa.ooa032
#No.FUN-AA0088 --end
#No.TQC-B30014 --end
        WHEN l_oob.oob03='1' AND l_oob.oob04='1' 
            SELECT nmh11,nmh30 INTO l_npq.npq21,l_npq.npq22
              FROM nmh_file  WHERE nmh01=l_oob.oob06
        WHEN l_oob.oob03='1' AND l_oob.oob04='2' 
            SELECT nmg18,nmg19 INTO l_npq.npq21,l_npq.npq22
              FROM nmg_file  WHERE nmg00=l_oob.oob06 AND nmgconf <> 'X'
        WHEN l_oob.oob03='1' AND l_oob.oob04='3' 
            SELECT oma03,oma032 INTO l_npq.npq21,l_npq.npq22
              FROM oma_file  WHERE oma01=l_oob.oob06
        WHEN l_oob.oob03='1' AND l_oob.oob04='9' 
            SELECT apa06,apa07  INTO l_npq.npq21,l_npq.npq22
              FROM apa_file  WHERE apa01=l_oob.oob06 
        #FUN-A40076--Add--Begin       
        WHEN l_oob.oob03='1' AND l_oob.oob04='Z' 
             LET l_npq.npq21 = l_ooa.ooa39
            SELECT occ02 INTO l_npq.npq22
              FROM occ_file  WHERE occ01=l_npq.npq21
        #FUN-A40076--Add--END              
        WHEN l_oob.oob03='2' AND l_oob.oob04='1' 
            SELECT oma03,oma032 INTO l_npq.npq21,l_npq.npq22
              FROM oma_file  WHERE oma01=l_oob.oob06
        WHEN l_oob.oob03='2' AND l_oob.oob04='9' 
            SELECT apa06,apa07  INTO l_npq.npq21,l_npq.npq22
              FROM apa_file  WHERE apa01=l_oob.oob06
#No.TQC-B30014 --begin
#No.FUN-AA0088 --begin
#        WHEN l_oob.oob03='1' AND g_prog ='axrt401' 
#             LET l_npq.npq21 = l_oob.oob24
#             SELECT occ02 INTO l_npq.npq22 FROM occ_file WHERE occ01 = l_npq.npq21
#        WHEN l_oob.oob03='2' AND g_prog ='axrt401' 
#              LET l_npq.npq21 = l_ooa.ooa03 
#              LET l_npq.npq22 = l_ooa.ooa032
#No.FUN-AA0088 --end
#No.TQC-B30014 --end
        OTHERWISE 
              LET l_npq.npq21 = l_ooa.ooa03 
              LET l_npq.npq22 = l_ooa.ooa032
      END CASE         
      IF cl_null(l_npq.npq21) THEN LET l_npq.npq21=l_ooa.ooa03 END IF
      IF cl_null(l_npq.npq22) THEN LET l_npq.npq22=l_ooa.ooa032 END IF
      #No.+080 end----
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
      # NO.FUN-5C0015 --start--
#     CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')
     #No.TQC-810021--begin--
      IF g_npptype = '0' THEN
         LET g_bookno1 = g_ooz02b
      ELSE
         LET g_bookno1 = g_ooz02c
      END IF
     #No.TQC-810021---end---
      IF g_prog = 'axrp304' THEN  #FUN-960141
         CALL s_def_npq(l_npq.npq03,'axrt410',l_npq.*,l_npq.npq01,'','',g_bookno1)   #No.FUN--730073
         RETURNING  l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = l_oob.oob12
         END IF
         #FUN-D10065--add--end
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                  #FUN-AA0087
          RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      #FUN-960141 add
      ELSE
        #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)   #No.FUN--730073  #CHI-A20022 mark
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_oob.oob02,'',g_bookno1)           #CHI-A20022 add 
         RETURNING  l_npq.*
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = l_oob.oob12
         END IF
         #FUN-D10065--add--end
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                  #FUN-AA0087
          RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      END IF
      #End 
      # NO.FUN-5C0015 ---end---
      IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
      SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file   #MOD-D50243
       WHERE occ01=l_npq.npq21                                #MOD-D50243
      #-----MOD-750132---------
      #IF l_aag371 MATCHES '[23]' THEN               #FUN-950053 mark
      IF l_aag371 MATCHES '[234]' THEN              #FUN-950053 add  
         IF cl_null(l_npq.npq37) THEN 
            IF l_occ37='Y' THEN   
#              LET l_npq.npq37=l_occ02       #No.CHI-830037
               #LET l_npq.npq37=l_ooa.ooa03   #No.CHI-830037
               LET l_npq.npq37=l_npq.npq21    #No.MOD-D50243
            END IF
         END IF
      END IF
      #No.MOD-D50243  --Begin
      IF l_aag371 ='4' AND l_occ37 = 'N'  THEN
         LET l_npq.npq37 = ' '
      END IF
     #No.MOD-D50243  --End

      #-----END MOD-750132-----
#No.FUN-9A0036 --Begin
      IF g_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_ooz02c
         SELECT azi04 INTO l_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_ooz02b,g_ooz02c,
                        l_npq.npq24,g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,l_azi04_2)       #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno1
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno1) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (l_npq.*)
     #No.+041 010330 by plum
       #IF STATUS THEN CALL cl_err('ins npq#1',STATUS,1) LET g_success = 'N' 
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#1',SQLCA.SQLCODE,1)   #No.FUN-660116
#        CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   #No.FUN-660116 #NO.FUN-710050
#NO.FUN-710050--BEGIN
      IF g_bgerr THEN
         CALL s_errmsg('','','ins npq#1',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   
      END IF
#NO.FUN-710050--END      
         LET g_success='N'
      END IF
     #No.+041..end
  END FOREACH
  #FUN-A40076--Add--Begin
  LET g_sql = " SELECT * FROM oof_file ",
              "  WHERE oof01='",p_trno CLIPPED,"' "
  IF g_npptype = '0' THEN 
     LET g_sql = g_sql," AND oof10 IS NOT NULL AND oof10 != ' ' "
  ELSE 
     LET g_sql = g_sql," AND oof101 IS NOT NULL AND oof101 != ' ' "
  END IF 
  LET g_sql = g_sql," ORDER BY oof02 "
  PREPARE t400_gl_11p FROM g_sql
  DECLARE t400_gl_11c CURSOR FOR t400_gl_11p

  FOREACH t400_gl_11c INTO l_oof.*
      LET l_npq.npq02 = l_oob.oob02 + l_oof.oof02
      IF g_npptype='0' THEN             
         LET l_npq.npq03 = l_oof.oof10
      ELSE                               
         LET l_npq.npq03 = l_oof.oof101  
      END IF                             
      LET l_npq.npq04 = ' '
      LET l_npq.npq05 = ' '
      LET l_npq.npq06 = '1'
      LET l_npq.npq07f = l_oof.oof09f
      LET l_npq.npq07 = l_oof.oof09
      LET l_npq.npq23 = ' '
      LET l_npq.npq24 = l_oof.oof07
      LET l_npq.npq25 = l_oof.oof08
      LET g_npq25     = l_npq.npq25        #No.FUN-9A0036
      LET l_npq.npq37=  ' '

      LET l_npq.npq21 = l_oof.oof03 
      SELECT occ02 INTO l_npq.npq22 
        FROM occ_file 
       WHERE occ01 = l_oof.oof03       

      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03

      IF g_npptype = '0' THEN
         LET g_bookno1 = g_ooz02b
      ELSE
         LET g_bookno1 = g_ooz02c
      END IF

      IF g_prog = 'axrp304' THEN 
         CALL s_def_npq(l_npq.npq03,'axrt410',l_npq.*,l_npq.npq01,'','',g_bookno1)   
         RETURNING  l_npq.*
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                  #FUN-AA0087
          RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      ELSE
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_oof.oof02,'',g_bookno1)          
         RETURNING  l_npq.*
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                  #FUN-AA0087
          RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      END IF

      IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
   
#No.FUN-9A0036 --Begin
      IF g_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_ooz02c
         SELECT azi04 INTO l_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_ooz02b,g_ooz02c,
                        l_npq.npq24,g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,l_azi04_2)       #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)         #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno1
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno1) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (l_npq.*)

      IF STATUS OR SQLCA.SQLCODE THEN

      IF g_bgerr THEN
         CALL s_errmsg('','','ins npq#1',SQLCA.SQLCODE,1)
      ELSE
         CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   
      END IF     
         LET g_success='N'
      END IF

  END FOREACH  
  #FUN-A40076--Add--End
END FUNCTION
#FUN-A40033 --Begin
FUNCTION s_t400_diff(p_npptype,p_trno)
DEFINE p_npptype        LIKE npp_file.npptype
DEFINE p_trno           LIKE npq_file.npq01
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF p_npptype = '1' THEN
      SELECT ooz02p,ooz02b,ooz02c INTO g_ooz02p,g_ooz02b,g_ooz02c FROM ooz_file
      LET g_bookno1 = g_ooz02c
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno1
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = 3
         AND npq01 = p_trno
         AND npq011= 1
         AND npqsys= 'AR'
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = 3
         AND npq01 = p_trno
         AND npq011= 1
         AND npqsys= 'AR'
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = 3
            AND npq01 = p_trno
            AND npq011= 1
            AND npqsys= 'AR'
         LET l_npq1.npqtype = p_npptype
         LET l_npq1.npq00 = 3
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
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno1
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno1) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
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

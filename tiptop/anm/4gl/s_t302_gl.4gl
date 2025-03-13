# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify ........: No.FUN-590109 05/09/23 By Elva 新增紅衝功能
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/24 By Jackho 兩套帳修改
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-690105 06/09/29 By Sarah CALL s_def_npq()時,p_key2的地方改成傳npk01
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-710024 07/02/01 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-730032 07/04/05 By Ray 新增帳套
# Modify.........: No.MOD-750132 07/05/30 By Smapmin 調整關係人異動碼相關程式段
# Modify.........: No.CHI-830037 08/10/16 By Jan 請調整將目前財務架構中使用關系人的地方,請統一使用"代碼",而非"簡稱"
# Modify.........: No.FUN-8C0107 08/12/29 By jamie 產生分錄時，npq05依成本中心或部門給值
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40059 10/04/22 By Carrier 按余额类型产生分录aag24='Y'时,分录方向要按设定来处理
# Modify.........: No.MOD-A70057 10/07/07 By Dido 預設 npq23 參考單號為 npk01 
# Modify.........: No:CHI-A70018 10/07/20 By Summer 先判斷npk10是否有在agli121設定,若有則先以agli121為主,若沒有則再以npk10為主
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:MOD-AB0008 10/11/01 By Dido aag371 增加檢核 4 
# Modify.........: No.FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-BC0195 11/12/12 By Polly 和s_t250_glfunction名稱相同，造成重複問#題
# Modify.........: No:FUN-C80031 12/08/09 By minpp 科目如果做部門管理，取單身部門，單身取不到時去單頭部門
# Modify.........: No:FUN-C90127 12/09/28 By zhangwei 当入账类型选择1：厂商汇款出账时必须录入且是大陆版(aza26 = 2)時,
#                                                     產生分錄藉方是應付單號對應雜項資料
# Modify.........: No.FUN-D10065 13/01/16 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds

GLOBALS "../../config/top.global"
   DEFINE g_nmg		RECORD LIKE nmg_file.*
   DEFINE g_npk		RECORD LIKE npk_file.*
   DEFINE g_nms		RECORD LIKE nms_file.*
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_nmh		RECORD LIKE nmh_file.*
   DEFINE g_trno	LIKE nmg_file.nmg00
   DEFINE g_nmydmy5     LIKE nmy_file.nmydmy5  #FUN-590109
   DEFINE g_t1          LIKE nmy_file.nmyslip  #FUN-590109
   DEFINE l_occ02       LIKE occ_file.occ02
   DEFINE l_occ37       LIKE occ_file.occ37
   DEFINE l_pmc03       LIKE pmc_file.pmc03
   #DEFINE l_aag181      LIKE aag_file.aag181   #No:9189   #MOD-750132
   DEFINE l_aag371      LIKE aag_file.aag371   #No:9189   #MOD-750132
   DEFINE l_pmc903      LIKE pmc_file.pmc903
   DEFINE g_flag        LIKE type_file.chr1    #No.FUN-730032
   DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-730032
   DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-730032
   DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-730032
   DEFINE g_npq25       LIKE npq_file.npq25    #No.FUN-9A0036
   DEFINE g_azi04_2     LIKE azi_file.azi04    #FUN-A40067
   DEFINE g_aag44       LIKE aag_file.aag44    #FUN-D40118 add

DEFINE   g_msg          LIKE ze_file.ze03      #No.FUN-680107 VARCHAR(72)
FUNCTION s_t302_gl(p_trno,p_npptype)
   DEFINE p_trno	LIKE nmg_file.nmg00
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680034
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-680107 SMALLINT

   WHENEVER ERROR CALL cl_err_msg_log

   LET g_trno = p_trno
   IF g_trno IS NULL THEN RETURN END IF
   #modify by Lynn  97/05/27 若已拋轉總帳, 不可重新產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE nppsys= 'NM' AND npp00=3 AND npp01 = g_trno AND npp011=1
      AND nppglno != '' AND nppglno IS NOT NULL
   IF l_n > 0 THEN
#No.FUN-710024 --begin
      IF g_bgerr THEN
         CALL s_errmsg('','',p_trno,'aap-122',1)
      ELSE
         CALL cl_err(p_trno,'aap-122',1)
      END IF
#No.FUN-710024 --end
      LET g_success='N'                        #No.FUN-680034
      RETURN
   END IF
   SELECT nmg_file.* INTO g_nmg.* FROM nmg_file WHERE nmg00 = g_trno
   IF STATUS THEN
#     CALL cl_err('sel nmg',STATUS,1) FUN-660148
#No.FUN-710024 -begin
      IF g_bgerr THEN
         CALL s_errmsg('nmg00',g_trno,'sel nmg',STATUS,0)
      ELSE
         CALL cl_err3("sel","nmg_file",g_trno,"",STATUS,"","sel nmg",1) #FUN-660148
      END IF
#No.FUN-710024 --end

   END IF
   IF g_nmg.nmgconf = 'X' THEN
#No.FUN-710024 -begin
      IF g_bgerr THEN
         CALL s_errmsg('','','void:','9024',0)
      ELSE
         CALL cl_err('void:','9024',1)
      END IF
#No.FUN-710024 --end

      RETURN
   END IF

   SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
#                                             AND nms00=p_npptype               #No.FUN-680034        #No.FUN-730032
   DELETE FROM npp_file
       WHERE nppsys= 'NM' AND npp00=3 AND npp01 = g_trno AND npp011=1
             AND npptype=p_npptype                                              #No.FUN-680034
   DELETE FROM npq_file
       WHERE npqsys= 'NM' AND npq00=3 AND npq01 = g_trno AND npq011=1
             AND npqtype=p_npptype                                              #No.FUN-680034

   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_trno
   #FUN-B40056--add--end--

   #-----MOD-750132---------
   #LET g_npq.npq14 = ' '
   ##-->for 合併報表-關係人
   #IF g_nmg.nmg18 <> 'MISC' THEN
   #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
   #    WHERE occ01=g_nmg.nmg18
   #   CASE g_nmg.nmg20
   #     WHEN '21'
   #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
   #     WHEN '22'
   #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
   #     WHEN '1'
   #         SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
   #          WHERE pmc01=g_nmg.nmg18
   #         IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
   #     WHEN '0'
   #         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
   #          WHERE occ01=g_nmg.nmg18
   #         IF STATUS THEN
   #            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
   #            WHERE pmc01=g_nmg.nmg18
   #            IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
   #         ELSE
   #            IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
   #         END IF
   #
   #   END CASE
   #END IF
   #-----END MOD-750132-----
#No.FUN-680034--begin
#   CALL s_t302_gl_11()
    CALL s_t302_gl_11(p_npptype)
#No.FUN-680034--end
   #FUN-590109  --begin
   IF g_aza.aza26='2' AND g_nmydmy5='Y' THEN
#No.FUN-680034--begin
#      CALL s_t302_gl_resort()  #  項次重排
      CALL s_t302_gl_resort(p_npptype)
#No.FUN-680034--end
   END IF
   #FUN-590109  --end
  #CALL s_t250_diff()           #FUN-A40033 #MOD-BC0195 mark
   CALL s_t302_diff()           #MOD-BC0195 add
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION

FUNCTION s_t302_gl_11(p_npptype)
#No.FUN-680034--begin
   DEFINE p_npptype LIKE npp_file.npptype
   LET g_npp.npptype=p_npptype
   LET g_npq.npqtype=p_npptype
#No.FUN-680034--end
   LET g_npp.nppsys = 'NM'
   LET g_npp.npp00 = 3
   LET g_npp.npp01 = g_nmg.nmg00
   LET g_npp.npp011 =  1
   LET g_npp.npp02 = g_nmg.nmg01
   LET g_npp.npp03 = NULL

   #FUN-980005 add legal
   LET g_npp.npplegal= g_legal
   #FUN-980005 end legal
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660148
#No.FUN-710024 -begin
      IF g_bgerr THEN
         LET g_showmsg = g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00
         CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',STATUS,1)
      ELSE
         CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp",1) #No.FUN-660148
      END IF
#No.FUN-710024 --end

      LET g_success='N' #no.5573
   END IF

   LET g_npq.npqsys = 'NM'
   LET g_npq.npq00 = 3
   LET g_npq.npq01 = g_nmg.nmg00
   LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0
   LET g_npq.npq23 = g_nmg.nmg00       #MOD-A70057
#No.FUN-680034--begin
#   CALL s_t302_gl_a()       # 借、貸方產生
   IF p_npptype='0' THEN
      CALL s_t302_gl_a()
   ELSE
      CALL s_t302_gl_a_1()
   END IF
#No.FUN-680034--end
END FUNCTION

FUNCTION s_t302_gl_a()
  DEFINE l_aag05   LIKE aag_file.aag05
  DEFINE l_apa     RECORD LIKE apa_file.*  #No.FUN-C90127 Add
  DEFINE g_apydmy5 LIKE apy_file.apydmy5   #No.FUN-C90127 Add
  DEFINE l_aph23   LIKE aph_file.aph23     #No.FUN-C90127 Add
  DEFINE l_npk08   LIKE npk_file.npk08     #No.FUN-C90127 Add
  DEFINE l_npk09   LIKE npk_file.npk09     #No.FUN-C90127 Add
  DEFINE l_flag    LIKE type_file.chr1     #FUN-D40118 add

   DECLARE s_t302_gl_c3 CURSOR FOR
        SELECT * FROM npk_file WHERE npk00=g_nmg.nmg00
   FOREACH s_t302_gl_c3 INTO g_npk.*
     IF STATUS THEN EXIT FOREACH END IF
        #No.FUN-730032 --begin
        CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag = '1' THEN
           CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
        END IF
        IF g_npq.npqtype = '0' THEN
           LET g_bookno3 = g_bookno1
        ELSE
           LET g_bookno3 = g_bookno2
        END IF
        #No.FUN-730032 --end
        IF NOT cl_null(g_npk.npk07) OR
           (cl_null(g_npk.npk07) AND cl_null(g_npk.npk071))
           THEN
            LET g_npq.npq02 = g_npq.npq02 + 1
            LET g_npq.npq03 = g_npk.npk07
           #LET g_npq.npq04 = g_npk.npk10 #CHI-A70018 mark
            #CHI-A70018 add --start-- 
            #FUN-D10065--mark--str--
            #IF NOT cl_null(g_npk.npk10) THEN
            #   IF NOT chk_npq04() THEN
            #      LET g_npq.npq04 = g_npk.npk10
            #   END IF
            #ELSE
            #   LET g_npq.npq04 = g_npk.npk10
            #END IF
            #FUN-D10065--mark--end
            LET g_npq.npq04=NULL  #FUN-D10065
            #CHI-A70018 add --end--
            LET g_npq.npq05 = g_nmg.nmg11
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno3       #No.FUN-730032
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90 !='Y' THEN   #FUN-8C0107 add
                  #FUN-C80031---ADD--STR
                   IF g_aza.aza26='2' THEN
                      LET g_npq.npq05 = g_npk.npk16
                      IF cl_null(g_npq.npq05) THEN 
                         LET g_npq.npq05 = g_nmg.nmg11
                      END IF
                   END IF
                  #FUN-C80031---ADD--END 
                 # LET g_npq.npq05 = g_nmg.nmg11            #FUN-C80031
               END IF                      #FUN-8C0107 add
            ELSE
               LET g_npq.npq05 = ''
            END IF
            #No:7365
            IF g_npk.npk03 MATCHES '[12]' THEN
               LET g_npq.npq06 = g_npk.npk03
            ELSE
               IF g_npk.npk03='3' THEN
                  LET g_npq.npq06 = '1'
               ELSE
                  LET g_npq.npq06 = '2'
               END IF
            END IF
            #---
            LET g_npq.npq07f = g_npk.npk08
            LET g_npq.npq07 = g_npk.npk09
            LET g_npq.npq21 = g_nmg.nmg18
            LET g_npq.npq22 = g_nmg.nmg19
            LET g_npq.npq24 = g_npk.npk05
            LET g_npq.npq25 = g_npk.npk06
           #No:9189 Add
            #-----MOD-750132---------
            LET g_npq.npq37 = ' '
            LET l_aag371 = ' '
            SELECT aag371 INTO l_aag371 FROM aag_file
              WHERE aag01=g_npq.npq03
                AND aag00 = g_bookno3
            #LET g_npq.npq14 = ' '
            #LET l_aag181=' '
            #SELECT aag181 INTO l_aag181 FROM aag_file
            # WHERE aag01=g_npq.npq03
            #   AND aag00 = g_bookno3       #No.FUN-730032
            #IF l_aag181 MATCHES '[23]' THEN
            ##End 9189
            ##-->for 合併報表-關係人
            # IF g_nmg.nmg18 <> 'MISC' THEN
            #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            #    WHERE occ01=g_nmg.nmg18
            #   CASE g_nmg.nmg20
            #     WHEN '21'
            #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #     WHEN '22'
            #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #     WHEN '1'
            #         SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            #          WHERE pmc01=g_nmg.nmg18
            #         IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
            #    WHEN '0'
            #         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            #          WHERE occ01=g_nmg.nmg18
            #         IF STATUS THEN
            #            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            #            WHERE pmc01=g_nmg.nmg18
            #            IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
            #         ELSE
            #            IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #         END IF
            #
            #   END CASE
            #  END IF
            #END IF
            #-----END MOD-750132-----
     #<--
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
            #FUN-590109  --begin
            IF g_aza.aza26='2' THEN
               LET g_t1 = s_get_doc_no(g_trno)
               SELECT nmydmy5 INTO g_nmydmy5 FROM nmy_file WHERE nmyslip = g_t1
               IF g_nmydmy5='Y' THEN
                  LET g_npq.npq07 = (-1)*g_npq.npq07
                  LET g_npq.npq07f= (-1)*g_npq.npq07f
                  IF g_npq.npq06='1' THEN
                     LET g_npq.npq06='2'
                  ELSE
                     LET g_npq.npq06='1'
                  END IF
               END IF
            END IF
            #FUN-590109  --end
            # NO.FUN-5C0015 --start--
           #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #FUN-690105 mark
#           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npk.npk01,'')   #FUN-690105       #No.FUN-730032
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npk.npk01,'',g_bookno3)   #FUN-690105       #No.FUN-730032
             RETURNING  g_npq.*
            #FUN-D10065--add--str--
            IF cl_null(g_npq.npq04) THEN
               IF NOT cl_null(g_npk.npk10) THEN
                  IF NOT chk_npq04() THEN
                     LET g_npq.npq04 = g_npk.npk10
                  END IF
               ELSE
                  LET g_npq.npq04 = g_npk.npk10
               END IF
            END IF
            #FUN-D10065--add--end
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
            # NO.FUN-5C0015 ---end---
            #-----MOD-750132---------
           #IF l_aag371 MATCHES '[23]' THEN    #MOD-AB0008 mark
            IF l_aag371 MATCHES '[234]' THEN   #MOD-AB0008
               IF cl_null(g_npq.npq37) THEN
                  #-->for 合併報表-關係人
                  IF g_nmg.nmg18 <> 'MISC' THEN
                    SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
                     WHERE occ01=g_nmg.nmg18
                    CASE g_nmg.nmg20
                      WHEN '21'
#                         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF  #No.CHI-830037
                          IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF #No.CHI-830037
                      WHEN '22'
#                         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF  #No.CHI-830037
                          IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF #No.CHI-830037
                      WHEN '1'
                          SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                           WHERE pmc01=g_nmg.nmg18
#                         IF l_pmc903='Y' THEN LET g_npq.npq37=l_pmc03 CLIPPED END IF  #No.CHI-830037
                          IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF #No.CHI-830037
                      WHEN '0'
                          SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
                           WHERE occ01=g_nmg.nmg18
                          IF STATUS THEN
                             SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                             WHERE pmc01=g_nmg.nmg18
#                            IF l_pmc903='Y' THEN LET g_npq.npq37=l_pmc03 CLIPPED END IF   #No.CHI-830037
                             IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF    #No.CHI-830037
                          ELSE
#                            IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF  #No.CHI-830037
                             IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF     #No.CHI-830037
                          END IF

                    END CASE
                  END IF
               END IF
            END IF
            #-----END MOD-750132-----

            #FUN-980005 add legal
            LET g_npq.npqlegal= g_legal
            #FUN-980005 end legal
            #No.FUN-A40059  --Begin
            CALL t302_entry_direction(g_bookno3,g_npq.npq03,g_npq.npq06,
                                      g_npq.npq07,g_npq.npq07f)
                 RETURNING g_npq.npq06,g_npq.npq07,g_npq.npq07f
            #No.FUN-A40059  --End
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
#              CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
#No.FUN-710024 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9', STATUS,1)
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
               END IF
#No.FUN-710024 --end
               LET g_success='N' #no.5573
            END IF
        END IF

       #IF NOT cl_null(g_npk.npk071) THEN   #No.FUN-C90127   Mark
        IF NOT cl_null(g_npk.npk071) AND (g_aza.aza26 != '2' OR g_nmg.nmg20 != '1') THEN   #No.FUN-C90127   Add
            LET g_npq.npq02 = g_npq.npq02 + 1
            LET g_npq.npq03 = g_npk.npk071
           #LET g_npq.npq04 = g_npk.npk10 #CHI-A70018 mark
            #CHI-A70018 add --start-- 
            #FUN-D10065--mark--str--
            #IF NOT cl_null(g_npk.npk10) THEN
            #   IF NOT chk_npq04() THEN
            #      LET g_npq.npq04 = g_npk.npk10
            #   END IF
            #ELSE
            #   LET g_npq.npq04 = g_npk.npk10
            #END IF
            #FUN-D10065--mark--end
            LET g_npq.npq04=NULL  #FUN-D10065
            #CHI-A70018 add --end--
            LET g_npq.npq05 = g_nmg.nmg11
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno3       #No.FUN-730032
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90 !='Y' THEN   #FUN-8C0107 add
                  #FUN-C80031---ADD--STR
                   IF g_aza.aza26='2' THEN
                      LET g_npq.npq05 = g_npk.npk16
                      IF cl_null(g_npq.npq05) THEN
                         LET g_npq.npq05 = g_nmg.nmg11
                      END IF
                   END IF
                  #FUN-C80031---ADD--END
                 #LET g_npq.npq05 = g_nmg.nmg11           #FUN-C80031  
               END IF                      #FUN-8C0107 add
            ELSE
               LET g_npq.npq05 = ''
            END IF
            IF g_npk.npk03='1' OR g_npk.npk03='3' THEN   #No:7365
               LET g_npq.npq06 ='2'
            ELSE
               LET g_npq.npq06 ='1'
            END IF
            LET g_npq.npq07f = g_npk.npk08
            LET g_npq.npq07 = g_npk.npk09
            LET g_npq.npq21 = g_nmg.nmg18
            LET g_npq.npq22 = g_nmg.nmg19
            LET g_npq.npq24 = g_npk.npk05
            LET g_npq.npq25 = g_npk.npk06
           #No:9189 Add
            #-----MOD-750132---------
            LET g_npq.npq37 = ' '
            LET l_aag371 = ' '
            SELECT aag371 INTO l_aag371 FROM aag_file
              WHERE aag01=g_npq.npq03
                AND aag00 = g_bookno3
            #LET g_npq.npq14=' '
            #LET l_aag181=''
            #SELECT aag181 INTO l_aag181 FROM aag_file
            # WHERE aag01=g_npq.npq03
            #   AND aag00 = g_bookno3       #No.FUN-730032
            #IF l_aag181 MATCHES '[23]' THEN
            ##End 9189
            ##-->for 合併報表-關係人
            # IF g_nmg.nmg18 <> 'MISC' THEN
            #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            #    WHERE occ01=g_nmg.nmg18
            #   CASE g_nmg.nmg20
            #     WHEN '21'
            #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #     WHEN '22'
            #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #     WHEN '1'
            #         SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            #          WHERE pmc01=g_nmg.nmg18
            #         IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
            #     WHEN '0'
            #         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            #          WHERE occ01=g_nmg.nmg18
            #          IF STATUS THEN
            #            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            #            WHERE pmc01=g_nmg.nmg18
            #            IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
            #         ELSE
            #            IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #         END IF
            #
            #   END CASE
            #  END IF
            #END IF
            #-----MOD-750132-----
            #<--
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            #FUN-590109  --begin
            IF g_aza.aza26='2' THEN
               LET g_t1 = s_get_doc_no(g_trno)
               SELECT nmydmy5 INTO g_nmydmy5 FROM nmy_file WHERE nmyslip = g_t1
               IF g_nmydmy5='Y' THEN
                  LET g_npq.npq07 = (-1)*g_npq.npq07
                  LET g_npq.npq07f= (-1)*g_npq.npq07f
                  IF g_npq.npq06='1' THEN
                     LET g_npq.npq06='2'
                  ELSE
                     LET g_npq.npq06='1'
                  END IF
               END IF
            END IF
            #FUN-590109  --end
            # NO.FUN-5C0015 --start--
           #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #FUN-690105 mark
#           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npk.npk01,'')   #FUN-690105       #No.FUN-730032
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npk.npk01,'',g_bookno3)   #FUN-690105       #No.FUN-730032
             RETURNING  g_npq.*
            #FUN-D10065--add--str--
            IF cl_null(g_npq.npq04) THEN
               IF NOT cl_null(g_npk.npk10) THEN
                  IF NOT chk_npq04() THEN
                     LET g_npq.npq04 = g_npk.npk10
                  END IF
               ELSE
                  LET g_npq.npq04 = g_npk.npk10
               END IF
            END IF
            #FUN-D10065--add--end
            
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
            # NO.FUN-5C0015 ---end---
            #-----MOD-750132---------
           #IF l_aag371 MATCHES '[23]' THEN    #MOD-AB0008 mark
            IF l_aag371 MATCHES '[234]' THEN   #MOD-AB0008
               IF cl_null(g_npq.npq37) THEN
                  #-->for 合併報表-關係人
                  IF g_nmg.nmg18 <> 'MISC' THEN
                    SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
                     WHERE occ01=g_nmg.nmg18
                    CASE g_nmg.nmg20
                      WHEN '21'
#                         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF        #No.CHI-830037
                          IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18  CLIPPED END IF   #No.CHI-830037
                      WHEN '22'
#                         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF   #No.CHI-830037
                          IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF    #No.CHI-830037
                      WHEN '1'
                          SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                           WHERE pmc01=g_nmg.nmg18
#                         IF l_pmc903='Y' THEN LET g_npq.npq37=l_pmc03 CLIPPED END IF   #No.CHI-830037
                          IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF    #No.CHI-830037
                      WHEN '0'
                          SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
                           WHERE occ01=g_nmg.nmg18
                          IF STATUS THEN
                             SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                             WHERE pmc01=g_nmg.nmg18
#                            IF l_pmc903='Y' THEN LET g_npq.npq37=l_pmc03 CLIPPED END IF   #No.CHI-830037
                             IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF  #No.CHI-830037
                          ELSE
#                            IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF       #No.CHI-830037
                             IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF   #No.CHI-830037
                          END IF

                    END CASE
                  END IF
               END IF
            END IF
            #-----END MOD-750132-----

            #FUN-980005 add legal
            LET g_npq.npqlegal= g_legal
            #FUN-980005 end legal
            #No.FUN-A40059  --Begin
            CALL t302_entry_direction(g_bookno3,g_npq.npq03,g_npq.npq06,
                                      g_npq.npq07,g_npq.npq07f)
                 RETURNING g_npq.npq06,g_npq.npq07,g_npq.npq07f
            #No.FUN-A40059  --End
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
#              CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
#No.FUN-710024 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9', STATUS,1)
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
               END IF
#No.FUN-710024 --end
               LET g_success='N' #no.5573
            END IF
        END IF
   END FOREACH
  #No.FUN-C90127   ---start---   Add
   IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
      SELECT aph23 INTO l_aph23 FROM aph_file,apa_file WHERE apa01 = aph23 AND aph01 = g_nmg.nmg31
      SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = l_aph23
      SELECT SUM(npk08),SUM(npk09) INTO l_npk08,l_npk09 FROM npk_file
       WHERE npk03 = '2' AND npk00 = g_nmg.nmg00
      IF cl_null(l_npk08) THEN LET l_npk08 = 0 END IF
      IF cl_null(l_npk09) THEN LET l_npk09 = 0 END IF
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag = '1' THEN
           CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
        END IF
        IF g_npq.npqtype = '0' THEN
           LET g_bookno3 = g_bookno1
        ELSE
           LET g_bookno3 = g_bookno2
        END IF
        IF NOT cl_null(l_apa.apa54) THEN
            LET g_npq.npq02 = g_npq.npq02 + 1
            LET g_npq.npq03 = l_apa.apa54
            LET g_npq.npq04 = NULL  #FUN-D10065
            LET g_npq.npq05 = g_nmg.nmg11
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00 = g_bookno3
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90 !='Y' THEN
                   IF g_aza.aza26='2' THEN
                      LET g_npq.npq05 = l_apa.apa22
                      IF cl_null(g_npq.npq05) THEN
                         LET g_npq.npq05 = g_nmg.nmg11
                      END IF
                   END IF
               END IF
            ELSE
               LET g_npq.npq05 = ''
            END IF
            LET g_npq.npq06 = '1'
            LET g_npq.npq07f = l_npk08
            LET g_npq.npq07 = l_npk09
            LET g_npq.npq21 = g_nmg.nmg18
            LET g_npq.npq22 = g_nmg.nmg19
            LET g_npq.npq24 = l_apa.apa13
            LET g_npq.npq25 = l_apa.apa14
            LET g_npq.npq37 = ' '
            LET l_aag371 = ' '
            SELECT aag371 INTO l_aag371 FROM aag_file
              WHERE aag01=g_npq.npq03
                AND aag00 = g_bookno3
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
            IF g_aza.aza26='2' THEN
               LET g_t1 = s_get_doc_no(l_apa.apa01)
               SELECT apydmy5 INTO g_apydmy5 FROM apy_file WHERE apyslip = g_t1
               IF g_apydmy5='Y' THEN
                  LET g_npq.npq07 = (-1)*g_npq.npq07
                  LET g_npq.npq07f= (-1)*g_npq.npq07f
                  IF g_npq.npq06='1' THEN
                     LET g_npq.npq06='2'
                  ELSE
                     LET g_npq.npq06='1'
                  END IF
               END IF
            END IF
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_apa.apa01,'',g_bookno3)
             RETURNING  g_npq.*
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
            IF l_aag371 MATCHES '[234]' THEN
               IF cl_null(g_npq.npq37) THEN
                  #-->for 合併報表-關係人
                  IF g_nmg.nmg18 <> 'MISC' THEN
                     SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                      WHERE pmc01=g_nmg.nmg18
                     IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF
                  END IF
               END IF
            END IF
            LET g_npq.npqlegal= g_legal
            CALL t302_entry_direction(g_bookno3,g_npq.npq03,g_npq.npq06,
                                      g_npq.npq07,g_npq.npq07f)
                 RETURNING g_npq.npq06,g_npq.npq07,g_npq.npq07f
            LET g_npq.npq23 = l_apa.apa01
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
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9', STATUS,1)
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1)
               END IF
               LET g_success='N'
            END IF
        END IF
   END IF
  #No.FUN-C90127   ---end  ---   Add
END FUNCTION

#CHI-A70018 add --start--
FUNCTION chk_npq04()
DEFINE l_ahh      RECORD LIKE ahh_file.*
DEFINE ls_str     STRING
DEFINE lc_str     LIKE type_file.chr1000
DEFINE lt_str     base.StringTokenizer
DEFINE ls_str2    STRING
DEFINE l_npq04    LIKE npq_file.npq04

   SELECT * INTO  l_ahh.* FROM ahh_file
    WHERE ahh00=g_bookno3
      AND ahh01=g_npq.npq03
      AND ahh02=g_prog
   IF STATUS THEN RETURN FALSE END IF
   IF cl_null(l_ahh.ahh03) THEN
      RETURN FALSE
   END IF
   LET lt_str=base.StringTokenizer.create(l_ahh.ahh03 CLIPPED, ",")
   WHILE lt_str.hasMoreTokens()
      LET ls_str =''
      LET lc_str =''
      LET ls_str=lt_str.nextToken()
      IF cl_null(ls_str) THEN
         CONTINUE WHILE
      END IF
      LET ls_str=ls_str.trim()
      LET ls_str=ls_str.trimRight()
      IF ls_str.getIndexOf("@",1)  THEN
         LET ls_str2 = ls_str
         LET ls_str=ls_str.subString(2,ls_str.getLength())
         IF ls_str='npk10' THEN
            RETURN TRUE
         END IF
      END IF
   END WHILE

   RETURN FALSE
END FUNCTION
#CHI-A70018 add --end--

#No.FUN-680034--begin
FUNCTION s_t302_gl_a_1()
  DEFINE l_aag05   LIKE aag_file.aag05
  DEFINE l_aaa03   LIKE aaa_file.aaa03 #FUN-A40067
  DEFINE l_apa     RECORD LIKE apa_file.*  #No.FUN-C90127 Add
  DEFINE g_apydmy5 LIKE apy_file.apydmy5   #No.FUN-C90127 Add
  DEFINE l_aph23   LIKE aph_file.aph23     #No.FUN-C90127 Add
  DEFINE l_npk08   LIKE npk_file.npk08     #No.FUN-C90127 Add
  DEFINE l_npk09   LIKE npk_file.npk09     #No.FUN-C90127 Add
  DEFINE l_flag    LIKE type_file.chr1     #FUN-D40118 add

   DECLARE s_t302_gl_c4 CURSOR FOR
        SELECT * FROM npk_file WHERE npk00=g_nmg.nmg00
   FOREACH s_t302_gl_c4 INTO g_npk.*
     IF STATUS THEN EXIT FOREACH END IF
        #No.FUN-730032 --begin
        CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag = '1' THEN
           CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
        END IF
        IF g_npq.npqtype = '0' THEN
           LET g_bookno3 = g_bookno1
        ELSE
           LET g_bookno3 = g_bookno2
        END IF
        #No.FUN-730032 --end
#FUN-A40067 --Begin
        SELECT aaa03 INTO l_aaa03 FROM aaa_file
         WHERE aaa01 = g_bookno2
        SELECT azi04 INTO g_azi04_2 FROM azi_file
         WHERE azi01 = l_aaa03
#FUN-A40067 --End
        IF NOT cl_null(g_npk.npk072) OR (cl_null(g_npk.npk072) AND cl_null(g_npk.npk073))  THEN
            LET g_npq.npq02 = g_npq.npq02 + 1
            LET g_npq.npq03 = g_npk.npk072
           #LET g_npq.npq04 = g_npk.npk10 #CHI-A70018 mark
            #CHI-A70018 add --start-- 
            #FUN-D10065--mark--str--
            #IF NOT cl_null(g_npk.npk10) THEN
            #   IF NOT chk_npq04() THEN
            #      LET g_npq.npq04 = g_npk.npk10
            #   END IF
            #ELSE
            #   LET g_npq.npq04 = g_npk.npk10
            #END IF
            #FUN-D10065--mark--end
            LET g_npq.npq04=NULL   #FUN-D10065
            #CHI-A70018 add --end--
            LET g_npq.npq05 = g_nmg.nmg11
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno3       #No.FUN-730032
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90 !='Y' THEN   #FUN-8C0107 add
                  #FUN-C80031---ADD--STR
                  IF g_aza.aza26='2' THEN
                     LET g_npq.npq05 = g_npk.npk16
                     IF cl_null(g_npq.npq05) THEN
                        LET g_npq.npq05 = g_nmg.nmg11
                     END IF
                   END IF
                  #FUN-C80031---ADD--END
                #LET g_npq.npq05 = g_nmg.nmg11     #FUN-C80031
               END IF                      #FUN-8C0107 add
            ELSE
               LET g_npq.npq05 = ''
            END IF
            #No:7365
            IF g_npk.npk03 MATCHES '[12]' THEN
               LET g_npq.npq06 = g_npk.npk03
            ELSE
               IF g_npk.npk03='3' THEN
                  LET g_npq.npq06 = '1'
               ELSE
                  LET g_npq.npq06 = '2'
               END IF
            END IF
            #---
            LET g_npq.npq07f = g_npk.npk08
            LET g_npq.npq07 = g_npk.npk09
            LET g_npq.npq21 = g_nmg.nmg18
            LET g_npq.npq22 = g_nmg.nmg19
            LET g_npq.npq24 = g_npk.npk05
            LET g_npq.npq25 = g_npk.npk06
            LET g_npq25     = g_npq.npq25 #FUN-9A0036
           #No:9189 Add
            #-----MOD-750132---------
            LET g_npq.npq37 = ' '
            LET l_aag371 = ' '
            SELECT aag371 INTO l_aag371 FROM aag_file
              WHERE aag01=g_npq.npq03
                AND aag00 = g_bookno3
            #LET g_npq.npq14 = ' '
            #LET l_aag181=' '
            #SELECT aag181 INTO l_aag181 FROM aag_file
            # WHERE aag01=g_npq.npq03
            #   AND aag00 = g_bookno3       #No.FUN-730032
            #IF l_aag181 MATCHES '[23]' THEN
            ##End 9189
            ##-->for 合併報表-關係人
            # IF g_nmg.nmg18 <> 'MISC' THEN
            #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            #    WHERE occ01=g_nmg.nmg18
            #   CASE g_nmg.nmg20
            #     WHEN '21'
            #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #     WHEN '22'
            #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #     WHEN '1'
            #         SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            #          WHERE pmc01=g_nmg.nmg18
            #         IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
            #    WHEN '0'
            #         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            #          WHERE occ01=g_nmg.nmg18
            #         IF STATUS THEN
            #            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            #            WHERE pmc01=g_nmg.nmg18
            #            IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
            #         ELSE
            #            IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #         END IF
            #
            #   END CASE
            #  END IF
            #END IF
            #-----END MOD-750132-----
     #<--
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
            #FUN-590109  --begin
            IF g_aza.aza26='2' THEN
               LET g_t1 = s_get_doc_no(g_trno)
               SELECT nmydmy5 INTO g_nmydmy5 FROM nmy_file WHERE nmyslip = g_t1
               IF g_nmydmy5='Y' THEN
                  LET g_npq.npq07 = (-1)*g_npq.npq07
                  LET g_npq.npq07f= (-1)*g_npq.npq07f
                  IF g_npq.npq06='1' THEN
                     LET g_npq.npq06='2'
                  ELSE
                     LET g_npq.npq06='1'
                  END IF
               END IF
            END IF
            #FUN-590109  --end
            # NO.FUN-5C0015 --start--
           #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #FUN-690105 mark
#           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npk.npk01,'')   #FUN-690105       #No.FUN-730032
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npk.npk01,'',g_bookno3)   #FUN-690105       #No.FUN-730032
             RETURNING  g_npq.*
            #FUN-D10065--add--str--
            IF cl_null(g_npq.npq04) THEN
               IF NOT cl_null(g_npk.npk10) THEN
                  IF NOT chk_npq04() THEN
                     LET g_npq.npq04 = g_npk.npk10
                  END IF
               ELSE
                  LET g_npq.npq04 = g_npk.npk10
               END IF
            END IF
            #FUN-D10065--add--end
              
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
            # NO.FUN-5C0015 ---end---
            #-----MOD-750132---------
           #IF l_aag371 MATCHES '[23]' THEN    #MOD-AB0008 mark
            IF l_aag371 MATCHES '[234]' THEN   #MOD-AB0008
               IF cl_null(g_npq.npq37) THEN
                  #-->for 合併報表-關係人
                  IF g_nmg.nmg18 <> 'MISC' THEN
                    SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
                     WHERE occ01=g_nmg.nmg18
                    CASE g_nmg.nmg20
                      WHEN '21'
#                         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF  #No.CHI-830037
                          IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF  #No.CHI-830037
                      WHEN '22'
#                         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF  #No.CHI-830037
                          IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF   #No.CHI-830037
                     WHEN '1'
                          SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                           WHERE pmc01=g_nmg.nmg18
#                         IF l_pmc903='Y' THEN LET g_npq.npq37=l_pmc03 CLIPPED END IF   #No.CHI-830037
                          IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF #No.CHI-830037
                      WHEN '0'
                          SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
                           WHERE occ01=g_nmg.nmg18
                          IF STATUS THEN
                             SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                             WHERE pmc01=g_nmg.nmg18
#                            IF l_pmc903='Y' THEN LET g_npq.npq37=l_pmc03 CLIPPED END IF      #No.CHI-830037
                             IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF  #No.CHI-830037
                          ELSE
#                            IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF   #No.CHI-830037
                             IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF   #No.CHI-830037
                          END IF

                    END CASE
                  END IF
               END IF
            END IF
            #-----END MOD-750132-----

            #FUN-980005 add legal
            LET g_npq.npqlegal= g_legal
            #FUN-980005 end legal
#No.FUN-9A0036 --Begin
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
#No.FUN-9A0036 --End
            #No.FUN-A40059  --Begin
            CALL t302_entry_direction(g_bookno3,g_npq.npq03,g_npq.npq06,
                                      g_npq.npq07,g_npq.npq07f)
                 RETURNING g_npq.npq06,g_npq.npq07,g_npq.npq07f
            #No.FUN-A40059  --End
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
#              CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
#No.FUN-710024 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9', STATUS,1)
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
               END IF
#No.FUN-710024 --end
               LET g_success='N' #no.5573
            END IF
        END IF

       #IF NOT cl_null(g_npk.npk073) THEN   #.No.FUN-C90127   Mark
        IF NOT cl_null(g_npk.npk073) AND (g_aza.aza26 != '2' OR g_nmg.nmg20 != '1') THEN   #.No.FUN-C90127   Add
            LET g_npq.npq02 = g_npq.npq02 + 1
            LET g_npq.npq03 = g_npk.npk073
           #LET g_npq.npq04 = g_npk.npk10 #CHI-A70018 mark
            #CHI-A70018 add --start-- 
            #FUN-D10065--mark--str--
            #IF NOT cl_null(g_npk.npk10) THEN
            #   IF NOT chk_npq04() THEN
            #      LET g_npq.npq04 = g_npk.npk10
            #   END IF
            #ELSE
            #   LET g_npq.npq04 = g_npk.npk10
            #END IF
            #FUN-D10065--mark--end
            LET g_npq.npq04=NULL  #FUN-D10065
            #CHI-A70018 add --end--
            LET g_npq.npq05 = g_nmg.nmg11
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno3       #No.FUN-730032
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90 !='Y' THEN   #FUN-8C0107 add
                 #FUN-C80031---ADD--STR
                  IF g_aza.aza26='2' THEN
                     LET g_npq.npq05 = g_npk.npk16
                     IF cl_null(g_npq.npq05) THEN
                        LET g_npq.npq05 = g_nmg.nmg11
                     END IF
                  END IF
                  #FUN-C80031---ADD--END
                 #LET g_npq.npq05 = g_nmg.nmg11      #FUN-C80031
               END IF                      #FUN-8C0107 add
            ELSE
               LET g_npq.npq05 = ''
            END IF
            IF g_npk.npk03='1' OR g_npk.npk03='3' THEN   #No:7365
               LET g_npq.npq06 ='2'
            ELSE
               LET g_npq.npq06 ='1'
            END IF
            LET g_npq.npq07f = g_npk.npk08
            LET g_npq.npq07 = g_npk.npk09
            LET g_npq.npq21 = g_nmg.nmg18
            LET g_npq.npq22 = g_nmg.nmg19
            LET g_npq.npq24 = g_npk.npk05
            LET g_npq.npq25 = g_npk.npk06
            LET g_npq25     = g_npq.npq25 #FUN-9A0036

           #No:9189 Add
            #-----MOD-750132-----
            LET g_npq.npq37 = ' '
            LET l_aag371 = ' '
            SELECT aag371 INTO l_aag371 FROM aag_file
              WHERE aag01=g_npq.npq03
                AND aag00 = g_bookno3
            #LET g_npq.npq14=' '
            #LET l_aag181=''
            #SELECT aag181 INTO l_aag181 FROM aag_file
            # WHERE aag01=g_npq.npq03
            #   AND aag00 = g_bookno3       #No.FUN-730032
            #IF l_aag181 MATCHES '[23]' THEN
            ##End 9189
            ##-->for 合併報表-關係人
            # IF g_nmg.nmg18 <> 'MISC' THEN
            #   SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            #    WHERE occ01=g_nmg.nmg18
            #   CASE g_nmg.nmg20
            #     WHEN '21'
            #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #     WHEN '22'
            #         IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #     WHEN '1'
            #         SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            #          WHERE pmc01=g_nmg.nmg18
            #         IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
            #     WHEN '0'
            #         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
            #          WHERE occ01=g_nmg.nmg18
            #          IF STATUS THEN
            #            SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
            #            WHERE pmc01=g_nmg.nmg18
            #            IF l_pmc903='Y' THEN LET g_npq.npq14=l_pmc03 CLIPPED END IF
            #         ELSE
            #            IF l_occ37='Y' THEN LET g_npq.npq14=l_occ02 CLIPPED END IF
            #         END IF
            #
            #   END CASE
            #  END IF
            #END IF
            #-----END MOD-750132-----
            #<--
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            #FUN-590109  --begin
            IF g_aza.aza26='2' THEN
               LET g_t1 = s_get_doc_no(g_trno)
               SELECT nmydmy5 INTO g_nmydmy5 FROM nmy_file WHERE nmyslip = g_t1
               IF g_nmydmy5='Y' THEN
                  LET g_npq.npq07 = (-1)*g_npq.npq07
                  LET g_npq.npq07f= (-1)*g_npq.npq07f
                  IF g_npq.npq06='1' THEN
                     LET g_npq.npq06='2'
                  ELSE
                     LET g_npq.npq06='1'
                  END IF
               END IF
            END IF
            #FUN-590109  --end
            # NO.FUN-5C0015 --start--
           #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #FUN-690105 mark
#           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npk.npk01,'')   #FUN-690105       #No.FUN-730032
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npk.npk01,'',g_bookno3)   #FUN-690105       #No.FUN-730032
             RETURNING  g_npq.*
            #FUN-D10065--add--str--
            IF cl_null(g_npq.npq04) THEN
               IF NOT cl_null(g_npk.npk10) THEN
                  IF NOT chk_npq04() THEN
                     LET g_npq.npq04 = g_npk.npk10
                  END IF
               ELSE
                  LET g_npq.npq04 = g_npk.npk10
               END IF
            END IF
            #FUN-D10065--mark--end
             
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
            # NO.FUN-5C0015 ---end---
            #-----MOD-750132---------
           #IF l_aag371 MATCHES '[23]' THEN    #MOD-AB0008 mark
            IF l_aag371 MATCHES '[234]' THEN   #MOD-AB0008
               IF cl_null(g_npq.npq37) THEN
                  #-->for 合併報表-關係人
                  IF g_nmg.nmg18 <> 'MISC' THEN
                    SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
                     WHERE occ01=g_nmg.nmg18
                    CASE g_nmg.nmg20
                      WHEN '21'
#                         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF  #No.CHI-830037
                          IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF   #No.CHI-830037
                      WHEN '22'
#                         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF  #No.CHI-830037
                          IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF   #No.CHI-830037
                      WHEN '1'
                          SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                           WHERE pmc01=g_nmg.nmg18
#                         IF l_pmc903='Y' THEN LET g_npq.npq37=l_pmc03 CLIPPED END IF  #No.CHI-830037
                          IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF  #No.CHI-830037
                      WHEN '0'
                          SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
                           WHERE occ01=g_nmg.nmg18
                          IF STATUS THEN
                             SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                             WHERE pmc01=g_nmg.nmg18
#                            IF l_pmc903='Y' THEN LET g_npq.npq37=l_pmc03 CLIPPED END IF   #No.CHI-830037
                             IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF #No.CHI-830037
                          ELSE
#                            IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF   #No.CHI-830037
                             IF l_occ37='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF   #No.CHI-830037
                          END IF

                    END CASE
                  END IF
               END IF
            END IF
            #-----END MOD-750132-----

            #FUN-980005 add legal
            LET g_npq.npqlegal= g_legal
            #FUN-980005 end legal
            #No.FUN-A40059  --Begin
            CALL t302_entry_direction(g_bookno3,g_npq.npq03,g_npq.npq06,
                                      g_npq.npq07,g_npq.npq07f)
                 RETURNING g_npq.npq06,g_npq.npq07,g_npq.npq07f
            #No.FUN-A40059  --End
#No.FUN-9A0036 --Begin
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
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
#              CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
#No.FUN-710024 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9', STATUS,1)
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
               END IF
#No.FUN-710024 --end
               LET g_success='N' #no.5573
            END IF
        END IF
   END FOREACH
  #No.FUN-C90127   ---start---   Add
   IF g_aza.aza26 = '2' AND g_nmg.nmg20 = '1' THEN
      SELECT aph23 INTO l_aph23 FROM aph_file,apa_file WHERE apa01 = aph23 AND aph01 = g_nmg.nmg31
      SELECT * INTO l_apa.* FROM apa_file WHERE apa01 = l_aph23
      SELECT SUM(npk08),SUM(npk09) INTO l_npk08,l_npk09 FROM npk_file
       WHERE npk03 = '2' AND npk00 = g_nmg.nmg00
      IF cl_null(l_npk08) THEN LET l_npk08 = 0 END IF
      IF cl_null(l_npk09) THEN LET l_npk09 = 0 END IF
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
        IF g_flag = '1' THEN
           CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
        END IF
        IF g_npq.npqtype = '0' THEN
           LET g_bookno3 = g_bookno1
        ELSE
           LET g_bookno3 = g_bookno2
        END IF
        IF NOT cl_null(l_apa.apa54) THEN
            LET g_npq.npq02 = g_npq.npq02 + 1
            LET g_npq.npq03 = l_apa.apa54
            LET g_npq.npq04 = NULL  #FUN-D10065
            LET g_npq.npq05 = g_nmg.nmg11
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00 = g_bookno3
            IF l_aag05='Y' THEN
               IF g_aaz.aaz90 !='Y' THEN
                   IF g_aza.aza26='2' THEN
                      LET g_npq.npq05 = l_apa.apa22
                      IF cl_null(g_npq.npq05) THEN
                         LET g_npq.npq05 = g_nmg.nmg11
                      END IF
                   END IF
               END IF
            ELSE
               LET g_npq.npq05 = ''
            END IF
            LET g_npq.npq06 = '1'
            LET g_npq.npq07f = l_npk08
            LET g_npq.npq07 = l_npk09
            LET g_npq.npq21 = g_nmg.nmg18
            LET g_npq.npq22 = g_nmg.nmg19
            LET g_npq.npq24 = l_apa.apa13
            LET g_npq.npq25 = l_apa.apa14
            LET g_npq.npq37 = ' '
            LET l_aag371 = ' '
            SELECT aag371 INTO l_aag371 FROM aag_file
              WHERE aag01=g_npq.npq03
                AND aag00 = g_bookno3
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
            IF g_aza.aza26='2' THEN
               LET g_t1 = s_get_doc_no(l_apa.apa01)
               SELECT apydmy5 INTO g_apydmy5 FROM apy_file WHERE apyslip = g_t1
               IF g_apydmy5='Y' THEN
                  LET g_npq.npq07 = (-1)*g_npq.npq07
                  LET g_npq.npq07f= (-1)*g_npq.npq07f
                  IF g_npq.npq06='1' THEN
                     LET g_npq.npq06='2'
                  ELSE
                     LET g_npq.npq06='1'
                  END IF
               END IF
            END IF
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_apa.apa01,'',g_bookno3)
             RETURNING  g_npq.*
            CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
            IF l_aag371 MATCHES '[234]' THEN
               IF cl_null(g_npq.npq37) THEN
                  #-->for 合併報表-關係人
                  IF g_nmg.nmg18 <> 'MISC' THEN
                     SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
                      WHERE pmc01=g_nmg.nmg18
                     IF l_pmc903='Y' THEN LET g_npq.npq37=g_nmg.nmg18 CLIPPED END IF
                  END IF
               END IF
            END IF
            LET g_npq.npqlegal= g_legal
            CALL t302_entry_direction(g_bookno3,g_npq.npq03,g_npq.npq06,
                                      g_npq.npq07,g_npq.npq07f)
                 RETURNING g_npq.npq06,g_npq.npq07,g_npq.npq07f
            LET g_npq.npq23 = l_apa.apa01
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
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9', STATUS,1)
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1)
               END IF
               LET g_success='N'
            END IF
        END IF
   END IF
  #No.FUN-C90127   ---end  ---   Add
END FUNCTION
#No.FUN-680034--end

#FUN-590109  --begin
FUNCTION s_t302_gl_resort(p_npqtype)
DEFINE  p_npqtype LIKE npq_file.npqtype      #No.FUN-680034
DEFINE  l_npq     RECORD LIKE npq_file.*
DEFINE  l_npq02   LIKE npq_file.npq02
DEFINE l_aaa03     LIKE aaa_file.aaa03    #FUN-A40067
DEFINE l_flag      LIKE type_file.chr1    #FUN-D40118 add

   DROP TABLE x
   SELECT * FROM npq_file
    WHERE npqsys= 'NM' AND npq00=3 AND npq01 = g_trno AND npq011=1 AND npqtype=p_npqtype     #No.FUN-680034 add npqtype=p_npqtype
     INTO TEMP x

   DELETE FROM npq_file
       WHERE npqsys= 'NM' AND npq00=3 AND npq01 = g_trno AND npq011=1
#            AND npptype=p_npptype AND npqtype=p_npqtype       #No.FUN-680034        #No.FUN-730032
         AND npqtype=p_npqtype       #No.FUN-680034        #No.FUN-730032
   IF SQLCA.SQLERRD[3] = 0 THEN
#     CALL cl_err('del npq_file',SQLCA.SQLCODE,1)                                  #No.FUN-660148
#No.FUN-710024 -begin
      IF g_bgerr THEN
         LET g_showmsg = 'NM',"/",3,"/",g_trno,"/",1,"/",p_npqtype
         CALL s_errmsg('npqsys,npq00,npq01,npq011,npqtype',g_showmsg,'del npq_file',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("del","npq_file",g_trno,"",SQLCA.sqlcode,"","del npq_file",1) #No.FUN-660148
      END IF
#No.FUN-710024 --end
      RETURN
   END IF
   DECLARE s_t302_gl_st CURSOR FOR
    SELECT * FROM x ORDER BY npq06,npq02
   LET l_npq02 = 0
   FOREACH s_t302_gl_st INTO l_npq.*
      LET l_npq02=l_npq02+1
      LET l_npq.npq02 = l_npq02
     #start FUN-690105 mark
     #本段僅針對項次做重排的動作,不需再抓一次異動碼預設值
     ## NO.FUN-5C0015 --start--
     #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')
     # RETURNING  l_npq.*
     ## NO.FUN-5C0015 ---end---
     #end FUN-690105 mark

      #FUN-980005 add legal
      LET l_npq.npqlegal= g_legal
      #FUN-980005 end legal
      #No.FUN-A40059  --Begin
      CALL t302_entry_direction(g_bookno3,l_npq.npq03,l_npq.npq06,
                                l_npq.npq07,l_npq.npq07f)
           RETURNING l_npq.npq06,l_npq.npq07,l_npq.npq07f
      #No.FUN-A40059  --End
#FUN-9A0036 --Begin
      IF p_npqtype = '1' THEN
#FUN-A40067 --Begin
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = g_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,
                        l_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
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
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('npq resort',SQLCA.SQLCODE,1)   #No.FUN-660148
#No.FUN-710024 -begin
         IF g_bgerr THEN
            LET g_showmsg = l_npq.npq01,"/",l_npq.npq011,"/",l_npq.npq02,"/",l_npq. npqsys,"/",l_npq.npq00
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","npq resort",1) #No.FUN-660148
         END IF
#No.FUN-710024 --end

         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#FUN-590109  --end

#No.FUN-A40059  --Begin
FUNCTION t302_entry_direction(p_bookno,p_npq03,p_npq06,p_npq07,p_npq07f)
   DEFINE p_bookno  LIKE aag_file.aag00
   DEFINE p_npq03   LIKE npq_file.npq03
   DEFINE p_npq06   LIKE npq_file.npq06
   DEFINE p_npq07   LIKE npq_file.npq07
   DEFINE p_npq07f  LIKE npq_file.npq07f
   DEFINE l_aag06   LIKE aag_file.aag06
   DEFINE l_aag42   LIKE aag_file.aag42

   IF cl_null(p_npq03) THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF cl_null(p_npq06) OR p_npq06 NOT MATCHES '[12]' THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF

   IF cl_null(p_npq07)  THEN LET p_npq07  = 0 END IF
   IF cl_null(p_npq07f) THEN LET p_npq07f = 0 END IF
   IF p_npq07 = 0 AND p_npq07f = 0 THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF

   SELECT aag06,aag42 INTO l_aag06,l_aag42
     FROM aag_file
    WHERE aag00 = p_bookno
      AND aag01 = p_npq03
   IF cl_null(l_aag42) OR l_aag42 = 'N' THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF l_aag06 = '1' AND p_npq06 = '1' OR 
      l_aag06 = '2' AND p_npq06 = '2' THEN
      RETURN p_npq06,p_npq07,p_npq07f
   END IF
   IF p_npq06 = '1' THEN
      LET p_npq06 = '2'
   ELSE
      LET p_npq06 = '1'
   END IF
   LET p_npq07 = p_npq07 * -1
   LET p_npq07f= p_npq07f* -1
  
   RETURN p_npq06,p_npq07,p_npq07f
END FUNCTION
#No.FUN-A40059  --End  
#FUN-A40033 --Begin
#FUNCTION s_t250_diff()  #MOD-BC0195 mark
FUNCTION s_t302_diff()   #MOD-BC0195 add
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
      LET l_sum_dr = 0
      LET l_sum_cr = 0
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
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg = l_npq1.npq01,"/",l_npq1.npq011,"/",l_npq1.npq02,"/",l_npq1. npqsys,"/",l_npq1.npq00
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9', STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq1.npq00,l_npq1.npq01,STATUS,"","ins npq#9",1)
            END IF
            LET g_success='N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End

# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify.........: No:A099 04/06/29 By Danny 大陸折舊方式/減值準備/資產停用
# Modify.........: No.MOD-4A0174 04/10/13 By Kitty 分錄底稿產生有誤
# Modify.........: No.MOD-510119 05/03/07 By Kitty 分錄底稿產生有誤,增加部門的判斷
# Modify.........: No.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: No.FUN-5B0038 05/11/30 By Sarah 產生分錄底稿的時候，應收帳款與稅額的幣別和匯率應該要抓單頭的幣別和匯率
# Modify.........: No.FUN-5C0015 05/12/20 By alana CALL s_def_npq.4gl 抓取異動碼default值
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/18 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.CHI-6A0004 06/10/26 By Jackho  本（原）幣取位修改
# Modify.........: No.MOD-660078 06/11/30 By Smapmin 先抓取科目名稱,再依科目名稱做是否做部門管理的判斷
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah s_def_npq()時,p_key2的地方改成傳fbf02
# Modify.........: No.MOD-6C0187 06/12/29 By Smapmin 修改ora檔
# Modify.........: No.FUN-710028 07/02/02 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# Modify.........: No.MOD-770152 07/08/06 By Smapmin 修改含稅稅額計算
# Modify.........: No.TQC-780089 07/09/21 By Smapmin 修改累折金額
# Modify.........: No.MOD-810219 08/01/31 By Smapmin 幣別位數取位
# Modify.........: No.CHI-870008 08/07/24 By Sarah 當分錄的稅額加總後大於出售主檔的稅額時,需調整至最後一筆稅額
# Modify.........: No.MOD-910114 09/01/14 By Sarah 將客戶及簡稱塞到分錄底稿的npq21、npq22中
# Modify.........: No.FUN-910117 09/05/12 By jan 程式中用到feb03,fbe04的原本在簡稱都是抓取occ02 ，改以fbe031,fbe041取代
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-960235 09/08/17 By xiaofeizhu 計算固定資產清理科目的時候銷賬累折=累計折舊/數量*本次銷賬數量改為銷賬累折=（累計折舊-銷賬累折）/（數量-銷賬數量）*本次銷賬數量
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990191 09/09/21 By Sarah 當出售"費用"固定資產時,產生的分錄底稿應該只會有應收帳款與處份損益
# Modify.........: No.CHI-A30001 10/03/14 By Dido 當分錄的出售額加總後大於出售主檔的金額時,需調整至最後一筆出售金額 
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:MOD-AB0192 10/11/19 By Dido 累折科目需判斷 aag05 是否為 'Y' 才需抓取被分攤資料 
# Modify.........: No:FUN-AA0087 11/01/28 By Mengxw 移動碼類型設定的改善
# Modify.........: No.FUN-AB0088 11/04/01 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: NO.MOD-B40120 11/04/14 BY Dido 多部門分攤折舊金額需包含開帳部分 
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B60313 11/06/23 By Dido 語法調整 
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:MOD-BC0129 12/01/16 By Sakura 產生分錄底稿二的金額時，應抓取財二設定金額
# Modify.........: No:MOD-C30722 12/03/16 By xuxz 將分錄底稿的差異金額以淨額表達方式
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3處理的地方加npptype判斷
# Modify.........: No:MOD-C50060 12/05/15 By Elise 計算財簽二時,應改用 m_faj142/m_faj322
# Modify.........: No:TQC-C60223 12/06/26 By wujie MOD-C30722漏加faa29的条件
# Modify.........: No.MOD-D10111 13/01/14 By Dido 稅額與借方含稅金額如為最末筆時比對總金額調整尾差於金額最大筆中 
# Modify.........: No.MOD-D10260 13/01/29 By Polly 產生分錄底稿如科目有做門管理時，需自動帶部門欄位
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-C80087 13/05/07 By Lori fbz10/fbz101改用fbe19/fbe191
# Modify.........: No.MOD-D50075 13/05/10 By Polly 調整累計折舊計算
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
#  DEFINE g_no	        LIKE type_file.chr20            #No.FUN-680070 VARCHAR(10)
   DEFINE g_no	        LIKE type_file.chr20        #No.FUN-550034          #No.FUN-680070 VARCHAR(16)
   DEFINE g_date        LIKE type_file.dat          #No.FUN-680070 DATE
#  DEFINE l_azi04       LIKE azi_file.azi04        #No.CHI-6A0004 mark
   DEFINE g_chr         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE g_msg         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
   DEFINE g_bookno1     LIKE aza_file.aza81         #No.FUN-740033
   DEFINE g_bookno2     LIKE aza_file.aza82         #No.FUN-740033
   DEFINE g_bookno      LIKE aza_file.aza81         #No.FUN-740033
   DEFINE g_flag        LIKE type_file.chr1         #No.FUN-740033
   DEFINE g_npq25       LIKE npq_file.npq25         #No.FUN-9A0036
   DEFINE g_azi04_2     LIKE azi_file.azi04         #FUN-A40067
 
FUNCTION t110_gl(p_no,p_date,p_npptype)     #No.FUN-680028
#  DEFINE p_no    	LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
   DEFINE p_no    	LIKE type_file.chr20    #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
   DEFINE p_date  	LIKE type_file.dat           #No.FUN-680070 DATE
   DEFINE p_npptype     LIKE npp_file.npptype     #No.FUN-680028
   DEFINE l_buf		LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5         #No.FUN-680070 SMALLINT
#  DEFINE l_t1          LIKE type_file.chr3         #No.FUN-680070 VARCHAR(03)
   DEFINE l_t1          LIKE type_file.chr5      #No.FUN-550034          #No.FUN-680070 VARCHAR(05)
   DEFINE l_fahdmy3     LIKE fah_file.fahdmy3
 
   WHENEVER ERROR CONTINUE
   LET g_no = p_no LET g_date = p_date 
   IF cl_null(g_no) THEN RETURN END IF
   IF p_npptype = "0" THEN   #FUN-B60140   Add   
      IF p_date < g_faa.faa09 THEN   #立帳日期小於關帳日期
         CALL cl_err(g_no,'aap-176',1) RETURN 
      END IF
#FUN-B60140   ---start   Add
    ELSE
       IF p_date < g_faa.faa092 THEN   #立帳日期小於關帳日期
          CALL cl_err(g_no,'aap-176',1)
          RETURN
       END IF
    END IF
 #FUN-B60140   ---end     Add
#   LET l_t1 = p_no[1,3]
   LET l_t1 = s_get_doc_no(p_no)       #No.FUN-550034
   LET l_fahdmy3 = ' '
  #SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1 #FUN-C30313 mark
#FUN-C30313---add---START-----
   IF p_npptype = '0' THEN
      SELECT fahdmy3 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
   ELSE
      SELECT fahdmy32 INTO l_fahdmy3 FROM fah_file WHERE fahslip = l_t1
   END IF
#FUN-C30313---add---END-------
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('sel fah:',STATUS,0)  #No.FUN-660136
      CALL cl_err3("sel","fah_file",l_t1,"",STATUS,"","sel fah:",1)  #No.FUN-660136
   END IF
   #---->是否拋轉傳票
   IF l_fahdmy3 != 'Y' THEN  RETURN END IF
   SELECT COUNT(*) INTO l_n FROM npq_file WHERE npq01 = g_no 
                                            AND npqsys = 'FA'
                                            AND npq00 = 4
                                            AND npq011=1
   IF l_n > 0 THEN
      IF p_npptype = '0' THEN     #No.FUN-680028
         IF NOT s_ask_entry(g_no) THEN RETURN END IF #Genero
         #FUN-B40056--add--str--
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM tic_file
          WHERE tic04 = g_no
         IF l_n > 0 THEN
            IF NOT cl_confirm('sub-533') THEN
               RETURN
            END IF
         END IF
         #FUN-B40056--add--end--
      END IF     #No.FUN-680028
   END IF
   DELETE FROM npp_file WHERE npp01 = g_no
                          AND nppsys = 'FA'
                          AND npp00 = 4
                          AND npp011=1
                          AND npptype = p_npptype     #No.FUN-680028
   DELETE FROM npq_file WHERE npq01 = g_no
                          AND npqsys = 'FA'
                          AND npq00 = 4
                          AND npq011=1
                          AND npqtype = p_npptype     #No.FUN-680028
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_no
   #FUN-B40056--add--end--

   CALL s_t110(p_npptype)     #No.FUN-680028
   DELETE FROM npq_file WHERE npq01=g_no    AND npq03='-'
                          AND npqsys = 'FA' AND npq00 = 4
                          AND npq011=1
                          AND npqtype = p_npptype     #No.FUN-680028
   CALL t110_gen_diff() #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
   
FUNCTION s_t110(p_npptype) 
DEFINE p_npptype  LIKE npp_file.npptype     #No.FUN-680028 
DEFINE l_fbz10    LIKE fbz_file.fbz10,  
       l_fbz101   LIKE fbz_file.fbz101,     #No.FUN-680028  
       l_fbz11    LIKE fbz_file.fbz11,  
       l_fbz111   LIKE fbz_file.fbz111,     #No.FUN-680028  
       l_fbz12    LIKE fbz_file.fbz12,  
       l_fbz121   LIKE fbz_file.fbz121,     #No.FUN-680028  
       l_gec03    LIKE gec_file.gec03,  
       l_gec031   LIKE gec_file.gec031,     #No.FUN-680028  
       l_fbe      RECORD LIKE fbe_file.*,
       l_fbf      RECORD LIKE fbf_file.*,
       l_fbe08    LIKE fbe_file.fbe08,
       l_fbe08x   LIKE fbe_file.fbe08x,
       l_fbe08t   LIKE fbe_file.fbe08t,
       l_fbe09    LIKE fbe_file.fbe09,
       l_fbe09x   LIKE fbe_file.fbe09x,
       l_fbe09t   LIKE fbe_file.fbe09t,
       l_faj17    LIKE faj_file.faj17,
       l_faj23    LIKE faj_file.faj23,
       l_faj24    LIKE faj_file.faj24,
       l_faj53    LIKE faj_file.faj53,
       l_faj531   LIKE faj_file.faj531,     #No.FUN-680028
       l_faj54    LIKE faj_file.faj54,
       l_faj541   LIKE faj_file.faj541,     #No.FUN-680028
       l_faj32    LIKE faj_file.faj32,
       l_faj58    LIKE faj_file.faj58,
       l_faj59    LIKE faj_file.faj59,
       l_faj60    LIKE faj_file.faj60,      #MOD-960235
       l_faj14    LIKE faj_file.faj14,
       l_faj141   LIKE faj_file.faj141,
       l_faj09    LIKE faj_file.faj09,      #MOD-990191 add
       l_aag05    LIKE aag_file.aag05,      #No:7833
       l_sql      LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(600)
#No:A099
   DEFINE l_fab24    LIKE fab_file.fab24,
         l_fab241   LIKE fab_file.fab241,     #No.FUN-680028
         l_fbz18    LIKE fbz_file.fbz18,
         l_fbz181   LIKE fbz_file.fbz181,     #No.FUN-680028
         m_faj32    LIKE faj_file.faj32,
         m_faj322    LIKE faj_file.faj322, #MOD-BC0129 add
         m_faj14    LIKE faj_file.faj14,
         m_faj142    LIKE faj_file.faj142 #MOD-BC0129 add
  #end No:A099
   DEFINE l_sumtax   LIKE fbe_file.fbe08x      #CHI-870008 add
   DEFINE l_sumtax1  LIKE fbe_file.fbe09x      #CHI-870008 add
   DEFINE l_sum      LIKE fbf_file.fbf06       #CHI-A30001
   DEFINE l_sum1     LIKE fbf_file.fbf07       #CHI-A30001
   DEFINE l_aaa03    LIKE aaa_file.aaa03       #FUN-A40067
  #FUN-AB0088---add---str---
   DEFINE l_faj232   LIKE faj_file.faj232
   DEFINE l_faj242   LIKE faj_file.faj242
   DEFINE l_faj322   LIKE faj_file.faj322
   DEFINE l_faj142   LIKE faj_file.faj142
   DEFINE l_faj1412  LIKE faj_file.faj1412
   DEFINE l_faj592   LIKE faj_file.faj592
   DEFINE l_faj582   LIKE faj_file.faj582
   DEFINE l_faj602   LIKE faj_file.faj602
  #FUN-AB0088---add---end---
   DEFINE l_fbe10    LIKE fbe_file.fbe10       #MOD-C307222 add
   DEFINE l_cnt      LIKE type_file.num5       #MOD-D10111
   DEFINE l_cnt2     LIKE type_file.num5       #MOD-D10111
   DEFINE l_faj33    LIKE faj_file.faj33       #MOD-D50075 add
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   LET l_sum = 0     LET l_sum1 = 0         #CHI-A30001
   LET l_sumtax = 0  LET l_sumtax1 = 0      #CHI-870008 add
 
   #-------------(單頭)-----------------------------------
   LET g_npp.nppsys = 'FA'        LET g_npp.npp00 = 4 
   LET g_npp.npp01  = g_no        LET g_npp.npp011= 1
   LET g_npp.npp02  = g_date      LET g_npp.npp03  = g_date
   LET g_npp.npptype = p_npptype     #No.FUN-680028
   LET g_npp.npplegal= g_legal       #FUN-980003 add
 
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660136
      CALL cl_err3("ins","npp_file",g_npp.npp01,g_npp.nppsys,SQLCA.sqlcode,"","ins npp",1)  #No.FUN-660136
      LET g_success='N' #no.5573
   END IF
 
   #No.FUN-740033  --Begin
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(g_npp.npp02,'aoo-081',1)
      LET g_success = 'N'
   END IF
   #No.FUN-740033  --End  
   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF NOT cl_null(g_faa.faa02c) THEN LET g_bookno2 = g_faa.faa02c END IF 
   #FUN-AB0088---add---end---
   #-------------(單身)-----------------------------------
   LET g_npq.npqsys = 'FA'        LET g_npq.npq00 = 4 
   LET g_npq.npq01 = g_no         LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0            LET g_npq.npq04 = NULL        
   LET g_npq.npq21 = NULL         LET g_npq.npq22 = NULL 
   LET g_npq.npqlegal= g_legal       #FUN-980003 add
 
   LET g_npq.npqtype = p_npptype     #No.FUN-680028
  #LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1   #FUN-5B0038 mark
   #No.FUN-740033  --Begin
   IF g_npq.npqtype = '0' THEN
      LET g_bookno = g_bookno1
   ELSE
      LET g_bookno = g_bookno2
   END IF
   #No.FUN-740033  --End  
   LET g_npq25 = g_npq.npq25          #No.FUN-9A0036
   #No:A099
   SELECT fbz10,fbz101,fbz11,fbz111,fbz12,fbz121,fbz18,fbz181 INTO l_fbz10,l_fbz101,l_fbz11,l_fbz111,l_fbz12,l_fbz121,l_fbz18,l_fbz181     #No.FUN-680028
       FROM fbz_file WHERE fbz00 = '0' 
   IF SQLCA.sqlcode THEN 
      LET l_fbz10 = ' ' LET l_fbz11 = ' '  LET l_fbz12 = ' ' LET l_fbz18 = ' '
   END IF
   #end No:A099
   SELECT * INTO l_fbe.* FROM fbe_file 
    WHERE fbe01 = g_no
      AND fbeconf !='X' #010801增
   SELECT gec03,gec031 INTO l_gec03,l_gec031 FROM gec_file 
    WHERE  gec01 = l_fbe.fbe07
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = l_fbe.fbe05          #No.CHI-6A0004 l_azi-->t_azi
   #No:A099
 
  #-MOD-D10111-add-
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt 
     FROM fbf_file 
    WHERE fbf01 = g_no
   IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
   LET l_cnt2 = 1 
  #-MOD-D10111-end-

   LET l_sql = "SELECT fbf_file.*,faj17,faj23,faj24,faj53,faj531,",
               "       faj54,faj541,faj32,faj14,faj141,faj59,",                     #No.FUN-680028
              #"       faj58,faj60,fab24,fab241,faj09， ",                          #No.FUN-680028  #MOD-960235 Add faj60  #MOD-990191 add faj09 #TQC-B60313 mark
               "       faj58,faj60,fab24,fab241,faj09, ",                           #No.FUN-680028  #MOD-960235 Add faj60  #MOD-990191 add faj09  #TQC-B60313
              #"       faj232,faj242,faj322,faj142,faj1412,faj582,faj592,faj602 ",  #FUN-AB0088 #MOD-D50075 mark
               "       faj232,faj242,faj322,faj142,faj1412, ",                      #MOD-D50075 add
               "       faj582,faj592,faj602,faj33 ",                                #MOD-D50075 add faj33
               "  FROM fbf_file,faj_file LEFT OUTER JOIN fab_file ON faj04=fab01",
               " WHERE fbf01 = '",g_no,"'",
               "   AND fbf03  = faj02",
               "   AND fbf031 = faj022",
               "   ORDER BY fbf07 "       #MOD-D10111
   #end No:A099
   PREPARE t110_p FROM l_sql
   DECLARE t110_c CURSOR WITH HOLD FOR t110_p
   FOREACH t110_c INTO l_fbf.*,l_faj17,l_faj23,l_faj24,l_faj53,l_faj531,
                       l_faj54,l_faj541,l_faj32,l_faj14,l_faj141,l_faj59,                         #No.FUN-680028
                       l_faj58,l_faj60,l_fab24,l_fab241,l_faj09,   #No:A099                       #MOD-960235 Add l_faj60  #MOD-990191 add l_faj09      
                      #l_faj232,l_faj242,l_faj322,l_faj142,l_faj1412,l_faj582,l_faj592,l_faj602   #FUN-AB0088 #MOD-D50075 mark 
                       l_faj232,l_faj242,l_faj322,l_faj142,l_faj1412,                             #MOD-D50075 add
                       l_faj582,l_faj592,l_faj602,l_faj33                                         #MOD-D50075 add faj33  
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
      IF SQLCA.sqlcode THEN
#No.FUN-710028 -begin
         IF g_bgerr THEN
            CALL s_errmsg('fbf01',g_no,'t110_c',SQLCA.sqlcode,0)  #No.FUN-710028
         ELSE
            CALL cl_err('t110_c',SQLCA.sqlcode,0) 
         END IF
#No.FUN-710028 --end
         EXIT FOREACH 
      END IF
      IF cl_null(l_faj32) THEN LET l_faj32 = 0 END IF
      IF cl_null(l_faj322) THEN LET l_faj322 = 0 END IF   #FUN-AB0088
 
     #str MOD-910114 add
     #將客戶及簡稱塞到分錄底稿的npq21、npq22中
      LET g_npq.npq21 = l_fbe.fbe03
     #SELECT occ02 INTO g_npq.npq22 FROM occ_file WHERE occ01=l_fbe.fbe03 #FUN-910117
      SELECT fbe031 INTO g_npq.npq22 FROM fbe_file WHERE fbe01=g_no  #FUN-910117
     #end MOD-910114 add
      LET g_npq.npq04 = NULL          #FUN-D10065  add 
      #No:A099
      #-------Dr.: 固定資產清理科目(fbz18) -------------                        
       IF g_faa.faa29 = 'Y' AND g_aza.aza26='2' THEN      #轉入清理科目 No.MOD-4A0174
         LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1   #FUN-5B0038
         LET g_npq25 = g_npq.npq25          #No.FUN-9A0036
         LET g_npq.npq02 = g_npq.npq02 + 1                                      
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fbz18            #借:固定資產清理                  
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fbz18    
         ELSE
            LET g_npq.npq03 = l_fbz181
         END IF
         #No.FUN-680028 --end
         #-->單一部門分攤才給部門                                   
         IF g_npq.npqtype = '0' THEN   #FUN-AB0088              
            IF l_faj23 = '1' THEN                                                  
               SELECT aag05 INTO l_aag05 FROM aag_file                             
                WHERE aag01=g_npq.npq03                                            
                  AND aag00=g_bookno  #No.FUN-740033
               IF l_aag05='Y' THEN                                                 
                  LET g_npq.npq05 =l_faj24                                         
               ELSE                                                                
                  LET g_npq.npq05 = ' '                                            
               END IF                                                              
            ELSE LET g_npq.npq05 = NULL                                            
            END IF        
         #FUN-AB0088---add---str---
         ELSE
            IF l_faj232 = '1' THEN                                                  
               SELECT aag05 INTO l_aag05 FROM aag_file                             
                WHERE aag01=g_npq.npq03                                            
                  AND aag00=g_bookno 
               IF l_aag05='Y' THEN                                                 
                  LET g_npq.npq05 =l_faj242                                         
               ELSE                                                                
                  LET g_npq.npq05 = ' '                                            
               END IF                                                              
            ELSE LET g_npq.npq05 = NULL                                            
            END IF                                                             
         END IF
         #FUN-AB0088---add---end---                                                        
         LET g_npq.npq06 = '1'                                                  
         #成本   
         IF g_npq.npqtype = '0' THEN     #FUN-AB0088                                                               
            LET m_faj14= (l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)*l_fbf.fbf04  
         #FUN-AB0088---add---str---
         ELSE
            #LET m_faj14= (l_faj142+l_faj1412-l_faj592)/(l_faj17-l_faj582)*l_fbf.fbf04   #MOD-C50060 mark
             LET m_faj142= (l_faj142+l_faj1412-l_faj592)/(l_faj17-l_faj582)*l_fbf.fbf04  #MOD-C50060 
         END IF
         #FUN-AB0088---add---end--- 
         #累折 
         IF g_npq.npqtype = '0' THEN     #FUN-AB0088                                                        
#           LET m_faj32= (l_faj32/l_faj17)*l_fbf.fbf04                   #MOD-960235 Mark
            LET m_faj32= (l_faj32-l_faj60)/(l_faj17-l_faj58)*l_fbf.fbf04 #MOD-960235    
         #FUN-AB0088---add---str---
         ELSE
            #LET m_faj32= (l_faj322-l_faj602)/(l_faj17-l_faj582)*l_fbf.fbf04   #MOD-C50060 mark 
             LET m_faj322= (l_faj322-l_faj602)/(l_faj17-l_faj582)*l_fbf.fbf04  #MOD-C50060 
         END IF 
         #FUN-AB0088---add---end---                              
         IF g_npq.npqtype = '0' THEN   #MOD-BC0129 add       
         LET g_npq.npq07f= m_faj14 - (m_faj32 + l_fbf.fbf11)                    
         LET g_npq.npq07 = m_faj14 - (m_faj32 + l_fbf.fbf11)         
         #MOD-BC0129---begin add
         ELSE
            LET g_npq.npq07f= m_faj142 - (m_faj322 + l_fbf.fbf112)                    
            LET g_npq.npq07 = m_faj142 - (m_faj322 + l_fbf.fbf112)            
         END IF
         #MOD-BC0129---end add 
          IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
          IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
         CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f            
         CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07              
         LET g_npq.npq23 = ' '                                                  
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03                                
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
         #No.FUN-5C0015 ---end
         IF g_npq.npq07 != 0 THEN  #MOD-990191 add
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
          # LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25  #MOD-BC0129 mark
          # LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
            LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
            LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)
         END IF
#No.FUN-9A0036 --End
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (g_npq.*)                                  
            IF STATUS THEN                                                         
#              CALL cl_err('ins npq#10',STATUS,1)                                     #No.FUN-660136
#No.FUN-710028 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#10', STATUS,1)               #No.FUN-710028
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#10",1)  #No.FUN-660136 
               END IF
#No.FUN-710028 --end
#              LET g_success='N' EXIT FOREACH        #No.FUN-710028                                  
               LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
            END IF                                                                 
         END IF   #MOD-990191 add
      END IF                                                                    
      #end No:A099
      #-------Dr.: 累折科目 (faj54) -----------
      IF l_faj09 != '5' THEN   #MOD-990191 add
         #-->單一部門分攤才給部門
         LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1   #FUN-5B0038
         LET g_npq25=g_npq.npq25                              #No.FUN-9A0036 
        #-MOD-AB0192-add-
         LET l_aag05 = NULL
         IF g_npq.npqtype = '0' THEN
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=l_faj54
               AND aag00=g_bookno
         ELSE
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=l_faj541
               AND aag00=g_bookno
         END IF 
        #-MOD-AB0192-end-
         IF g_npq.npqtype = '1' THEN LET l_faj23 = l_faj232 END IF   #FUN-AB0088
        #IF l_faj23 = '1' THEN   # 分攤方式1.單一部門分攤2.多部門分攤                  #MOD-AB0192 mark
         IF l_faj23 = '1' OR l_aag05 = 'N' THEN   # 分攤方式1.單一部門分攤2.多部門分攤 #MOD-AB0192
            #-----MOD-660078---------
            IF g_npq.npqtype = '0' THEN
               LET g_npq.npq03 = l_faj54    
            ELSE
               LET g_npq.npq03 = l_faj541
            END IF
            #-----END MOD-660078-----
            LET g_npq.npq04 = NULL   #MOD-6C0140 add
            #No:7833
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno  #No.FUN-740033
            IF l_aag05='Y' THEN
               LET g_npq.npq05 =l_faj24
            ELSE
               LET g_npq.npq05 = ' '
            END IF
            ##
            LET g_npq.npq06 = '1'
            #No.FUN-680028 --begin
#           LET g_npq.npq03 = l_faj54   #累折科目
            #-----MOD-660078---------
            #IF g_npq.npqtype = '0' THEN
            #   LET g_npq.npq03 = l_faj54    
            #ELSE
            #   LET g_npq.npq03 = l_faj541
            #END IF
            #-----END MOD-660078-----
            #No.FUN-680028 --end
#           LET g_npq.npq07f= l_faj32   #累積折舊(dec)
#           LET g_npq.npq07 = l_faj32   #累積折舊
            #-----TQC-780089---------
            #LET g_npq.npq07f= (l_faj32/l_faj17)*l_fbf.fbf04   #累積折舊(dec)
            #LET g_npq.npq07 = (l_faj32/l_faj17)*l_fbf.fbf04   #累積折舊
            IF g_npq.npqtype ='0' THEN   #FUN-AB0088
               LET g_npq.npq07f=((l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)*
                                l_fbf.fbf04)-
                                (l_faj33/l_faj17*l_fbf.fbf04)                         #MOD-D50075 add 
                               #l_fbf.fbf08                                           #MOD-D50075 mark
               LET g_npq.npq07 =((l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)*
                                l_fbf.fbf04)-
                                (l_faj33/l_faj17*l_fbf.fbf04)                         #MOD-D50075 add 
                               #l_fbf.fbf08                                           #MOD-D50075 mark
            #-----END TQC-780089----- 
            #FUN-AB0088---add---str---
            ELSE
               LET g_npq.npq07f=((l_faj142+l_faj1412-l_faj592)/(l_faj17-l_faj582)*
                                l_fbf.fbf04)-
                                l_fbf.fbf082 #MOD-BC0129 fbf08-->fbf082
               LET g_npq.npq07 =((l_faj142+l_faj1412-l_faj592)/(l_faj17-l_faj582)*
                                l_fbf.fbf04)-
                                l_fbf.fbf082 #MOD-BC0129 fbf08-->fbf082
            END IF 
            #FUN-AB0088---add---end---
            IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
            IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
            CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f
            CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07
            LET g_npq.npq23 = ' ' 
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
    #       UPDATE npq_file SET npq07f = npq07f + g_npq.npq07f,
    #                        npq07  = npq07  + g_npq.npq07 
    #        WHERE npqsys = g_npq.npqsys
    #          AND npq00 = g_npq.npq00
    #          AND npq01 = g_npq.npq01
    #          AND npq011 = g_npq.npq011
    #          AND npq03 = g_npq.npq03   #科目 
    #       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
               LET g_npq.npq02 = g_npq.npq02 + 1
               #NO.FUN-5C0015 ---start
              #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
               CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
               RETURNING g_npq.*
               CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
               #No.FUN-5C0015 ---end
               IF g_npq.npq07 != 0 THEN  #MOD-990191 add
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
                  #  LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25  #MOD-BC0129 mark
                  #  LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
                     LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
                     LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
                  ELSE
                     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
                  END IF
#No.FUN-9A0036 --End
                 #FUN-D40118 ---Add--- Start
                  SELECT aag44 INTO l_aag44 FROM aag_file
                   WHERE aag00 = g_bookno
                     AND aag01 = g_npq.npq03
                  IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                     CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
                     IF l_flag = 'N'   THEN
                        LET g_npq.npq03 = ''
                     END IF
                  END IF
                 #FUN-D40118 ---Add--- End
                  INSERT INTO npq_file VALUES (g_npq.*)
                  IF STATUS THEN 
#                    CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
                     IF g_bgerr THEN
                        LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                        CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                #No.FUN-710028
                     ELSE
                        CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)  #No.FUN-660136 
                     END IF
#No.FUN-710028 --end
#                    LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                  
                     LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
                  END IF
               END IF   #MOD-990191 add
    #       END IF 
         ELSE 
            DECLARE fan_cur CURSOR FOR SELECT fan06,SUM(fan07) FROM fan_file
              WHERE fan01=l_fbf.fbf03
                AND fan02=l_fbf.fbf031
               #AND fan041 = '1'                   #MOD-B40120 mark
                AND (fan041 = '1' OR fan041 = '0') #MOD-B40120
                AND fan05='3'   #被分攤
              GROUP BY fan06
              ORDER BY fan06
             FOREACH fan_cur INTO g_npq.npq05,g_npq.npq07f
                #-----MOD-660078---------
                IF g_npq.npqtype = '0' THEN
                   LET g_npq.npq03 = l_faj54    
                ELSE
                   LET g_npq.npq03 = l_faj541
                END IF
                #-----END MOD-660078-----
                LET g_npq.npq04 = NULL   #MOD-6C0140 add
                 #No.MOD-510119
                IF g_npq.npqtype = '0' THEN   #FUN-AB0088
                   IF l_faj23 = '1' THEN                                                  
                      SELECT aag05 INTO l_aag05 FROM aag_file                             
                       WHERE aag01=g_npq.npq03                                            
                         AND aag00=g_bookno  #No.FUN-740033
                      IF l_aag05='Y' THEN                                                 
                         LET g_npq.npq05 =l_faj24                                         
                      ELSE                                                                
                         LET g_npq.npq05 = ' '                                            
                      END IF                                                              
                   ELSE
                      #LET g_npq.npq05 = ' '                     #MOD-AB0192 mark 
                   END IF   
                #FUN-AB0088---add---str---
                ELSE
                   IF l_faj232 = '1' THEN                                                  
                      SELECT aag05 INTO l_aag05 FROM aag_file                             
                       WHERE aag01=g_npq.npq03                                            
                         AND aag00=g_bookno 
                      IF l_aag05='Y' THEN                                                 
                         LET g_npq.npq05 =l_faj242                                         
                      ELSE                                                                
                         LET g_npq.npq05 = ' '                                            
                      END IF                                                              
                   ELSE
                      LET g_npq.npq05 = ' ' 
                   END IF                                                                 
                END IF
                #FUN-AB0088---add---end---                                                              
                #No.MOD-510119 end
                LET g_npq.npq06 = '1'
                #No.FUN-680028 --begin
#               LET g_npq.npq03 = l_faj54   #累折科目
                #-----MOD-660078---------
                #IF g_npq.npqtype = '0' THEN
                #   LET g_npq.npq03 = l_faj54    
                #ELSE
                #   LET g_npq.npq03 = l_faj541
                #END IF
                #-----END MOD-660078-----
                #No.FUN-680028 --end
                LET g_npq.npq07f= g_npq.npq07f/l_faj17*l_fbf.fbf04  #累積折舊(dec)
                LET g_npq.npq07 = g_npq.npq07f                    #累積折舊
                 IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
                 IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
                CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f
                CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07
                LET g_npq.npq23 = ' ' 
                MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
                LET g_npq.npq02 = g_npq.npq02 + 1
                #NO.FUN-5C0015 ---start
               #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
                CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
                RETURNING g_npq.*
                CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
                #No.FUN-5C0015 ---end
                IF g_npq.npq07 != 0 THEN  #MOD-990191 add
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
                   # LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25  #MOD-BC0129 mark
            #        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
                     LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
                     LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
                  ELSE
                     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
                  END IF
#No.FUN-9A0036 --End
                 #FUN-D40118 ---Add--- Start
                  SELECT aag44 INTO l_aag44 FROM aag_file
                   WHERE aag00 = g_bookno
                     AND aag01 = g_npq.npq03
                  IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                     CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
                     IF l_flag = 'N'   THEN
                        LET g_npq.npq03 = ''
                     END IF
                  END IF
                 #FUN-D40118 ---Add--- End
                   INSERT INTO npq_file VALUES (g_npq.*)
                   IF STATUS THEN 
#                     CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
                      IF g_bgerr THEN
                         LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                         CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                #No.FUN-710028
                      ELSE
                         CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)  #No.FUN-660136 
                      END IF
#No.FUN-710028 --end
#                     LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                  
                      LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
                   END IF
                END IF   #MOD-990191 add
             END FOREACH
         END IF
      END IF   #MOD-990191 add
      IF cl_null(l_fbf.fbf07) THEN LET l_fbf.fbf07=0 END IF
      IF cl_null(l_fbf.fbf072) THEN LET l_fbf.fbf072=0 END IF #MOD-BC0129 add
      #No:A099
      #-------Dr.: 資產之減值準備科目(fab24) -------------                      
      IF l_fbf.fbf11 > 0 THEN     #已提列減值準備                               
         LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1   #FUN-5B0038
         LET g_npq25 = g_npq.npq25                            #No.FUN-9A0036
         LET g_npq.npq02 = g_npq.npq02 + 1                                      
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fab24             #借:減值準備                     
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fab24    
         ELSE
            LET g_npq.npq03 = l_fab241
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         #-->單一部門分攤才給部門        
         IF g_npq.npqtype = '0' THEN   #FUN-AB0088                                       
            IF l_faj23 = '1' THEN                                                  
               SELECT aag05 INTO l_aag05 FROM aag_file                             
                WHERE aag01=g_npq.npq03                                            
                  AND aag00=g_bookno  #No.FUN-740033
               IF l_aag05='Y' THEN                                                 
                  LET g_npq.npq05 =l_faj24                                         
               ELSE                                                                
                  LET g_npq.npq05 = ' '                                            
               END IF                                                              
            ELSE LET g_npq.npq05 = NULL                                            
            END IF      
         #FUN-AB0088---add---str---
         ELSE
            IF l_faj232 = '1' THEN                                                  
               SELECT aag05 INTO l_aag05 FROM aag_file                             
                WHERE aag01=g_npq.npq03                                            
                  AND aag00=g_bookno 
               IF l_aag05='Y' THEN                                                 
                  LET g_npq.npq05 =l_faj242                                        
               ELSE                                                                
                  LET g_npq.npq05 = ' '                                            
               END IF                                                              
            ELSE LET g_npq.npq05 = NULL                                            
            END IF                                                                 
         END IF
         #FUN-AB0088---add---end---                                                           
         LET g_npq.npq06 = '1'                                                  
         IF g_npq.npqtype = '0' THEN  #MOD-BC0129 add        
         LET g_npq.npq07f= l_fbf.fbf11                                          
         LET g_npq.npq07 = l_fbf.fbf11                                          
         #MOD-BC0129---begin add
         ELSE
            LET g_npq.npq07f= l_fbf.fbf112                                          
            LET g_npq.npq07 = l_fbf.fbf112           
         END IF
         #MOD-BC0129---end add 
         IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
         IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
         CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f   #MOD-810219
         CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-810219
         LET g_npq.npq23 = ' '                                                  
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03                                
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
         #No.FUN-5C0015 ---end
         IF g_npq.npq07 != 0 THEN  #MOD-990191 add
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
             # LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25   #MOD-BC0129 mark
            #  LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
               LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
               LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
            ELSE
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (g_npq.*)     
            IF STATUS THEN                                                         
#              CALL cl_err('ins npq#12',STATUS,1)                                     #No.FUN-660136
#No.FUN-710028 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#12', STATUS,1)               #No.FUN-710028
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#12",1)  #No.FUN-660136 
               END IF
#No.FUN-710028 --end
#              LET g_success='N' EXIT FOREACH        #No.FUN-710028                                  
               LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
            END IF                                                                 
         END IF   #MOD-990191 add
      END IF                                                                    
      #end No:A099
       IF g_faa.faa29 = 'N' OR g_aza.aza26<>'2' THEN       #No:A099 No.MOD-4A0174
         #-------Dr.: A/R 科目 (fbz10) -----------
        #start FUN-5B0038
         LET g_npq.npq24 = l_fbe.fbe05    #單頭的幣別
         LET g_npq.npq25 = l_fbe.fbe06    #單頭的匯率
         LET g_npq25 = g_npq.npq25        #No.FUN-9A0036
        #end FUN-5B0038
         #-->單一部門分攤才給部門
         #-----MOD-660078---------
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fbz10       #FUN-C80087 mark
           #LET g_npq.npq03 = l_fbe.fbe19   #FUN-C80087 add
         ELSE
            LET g_npq.npq03 = l_fbz101      #FUN-C80087 mark
           #LET g_npq.npq03 = l_fbe.fbe191  #FUN-C80087 add
         END IF
         #-----END MOD-660078-----
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         IF g_npq.npqtype = '0' THEN   #FUN-AB0088
            IF l_faj23 = '1' THEN 
               #No:7833
               #No.FUN-680028 --begin
#              LET g_npq.npq03 = l_fbz10       #出售應收科目
               #-----MOD-660078---------
               #IF g_npq.npqtype = '0' THEN
               #   LET g_npq.npq03 = l_fbz10    
               #ELSE
               #   LET g_npq.npq03 = l_fbz101
               #END IF
               #-----END MOD-660078-----
               #No.FUN-680028 --end
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno  #No.FUN-740033
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
               ##
               ELSE LET g_npq.npq05 = NULL           
               END IF
         #FUN-AB0088---add---str---
         ELSE
            IF l_faj232 = '1' THEN 
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno 
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj242
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE
               LET g_npq.npq05 = NULL           
            END IF
         END IF 
         #FUN-AB0088---add---end--- 
         LET g_npq.npq06 = '1'
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fbz10       #出售應收科目
         #-----MOD-660078---------
         #IF g_npq.npqtype = '0' THEN
         #   LET g_npq.npq03 = l_fbz10    
         #ELSE
         #   LET g_npq.npq03 = l_fbz101
         #END IF
         #-----END MOD-660078-----
         #No.FUN-680028 --end
        ##1999/12/31小心千禧蟲發作
        #LET g_npq.npq07f= l_fbe.fbe08t  #本幣出售金額
        #LET g_npq.npq07 = l_fbe.fbe09t
         IF l_fbe.fbe073='N' THEN  #不含稅
            LET l_fbe08x=l_fbf.fbf06*l_fbe.fbe071/100
            CALL cl_digcut(l_fbe08x,t_azi04) RETURNING l_fbe08x                    #No.CHI-6A0004 l_azi-->t_azi
            LET l_fbe08t=l_fbf.fbf06+l_fbe08x
            IF g_npq.npqtype = '0' THEN #MOD-BC0129 add
            LET l_fbe09x=l_fbf.fbf07*l_fbe.fbe071/100
            #MOD-BC0129---begin add
            ELSE
               LET l_fbe09x=l_fbf.fbf072*l_fbe.fbe071/100            
            END IF
            #MOD-BC0129---end add
            CALL cl_digcut(l_fbe09x,g_azi04) RETURNING l_fbe09x
            IF g_npq.npqtype = '0' THEN #MOD-BC0129 add
            LET l_fbe09t=l_fbf.fbf07+l_fbe09x
            #MOD-BC0129---begin add
            ELSE
               LET l_fbe09t=l_fbf.fbf072+l_fbe09x            
            END IF
            #MOD-BC0129---begin add 
            CALL cl_digcut(l_fbe08t,t_azi04) RETURNING l_fbe08t                    #No.CHI-6A0004 l_azi-->t_azi
            CALL cl_digcut(l_fbe09t,g_azi04) RETURNING l_fbe09t
         ELSE   # 含稅
            LET l_fbe08t=l_fbf.fbf06
            IF g_npq.npqtype = '0' THEN #MOD-BC0129 add
            LET l_fbe09t=l_fbf.fbf07
            #MOD-BC0129---begin add
            ELSE
               LET l_fbe09t=l_fbf.fbf072            
            END IF
            #MOD-BC0129---end add
            IF l_fbe.fbe071 = 0 THEN   #零稅率,應設不含稅 
               LET l_fbe08x=l_fbf.fbf06*l_fbe.fbe071/100
               CALL cl_digcut(l_fbe08x,t_azi04) RETURNING l_fbe08x                 #No.CHI-6A0004 l_azi-->t_azi
              #LET l_fbe08t=l_fbf.fbf06+l_fbe08x
               IF g_npq.npqtype = '0' THEN #MOD-BC0129 add
               LET l_fbe09x=l_fbf.fbf07*l_fbe.fbe071/100
               #MOD-BC0129---begin add
               ELSE
                  LET l_fbe09x=l_fbf.fbf072*l_fbe.fbe071/100               
               END IF
               #MOD-BC0129---end add 
               CALL cl_digcut(l_fbe09x,g_azi04) RETURNING l_fbe09x
              #LET l_fbe09t=l_fbf.fbf07+l_fbe09x
               CALL cl_digcut(l_fbe08t,t_azi04) RETURNING l_fbe08t                 #No.CHI-6A0004 l_azi-->t_azi 
               CALL cl_digcut(l_fbe09t,g_azi04) RETURNING l_fbe09t
            ELSE  
               #LET l_fbe08x=l_fbf.fbf06 * (1-(100+l_fbe.fbe071)/100)    #MOD-770152
               LET l_fbe08x=l_fbf.fbf06 * (1-(1/((100+l_fbe.fbe071)/100)))   #MOD-770152Q
               CALL cl_digcut(l_fbe08x,t_azi04) RETURNING l_fbe08x
               #LET l_fbe09x=l_fbf.fbf07 * (1-(100+l_fbe.fbe071)/100)   #MOD-770152
               IF g_npq.npqtype = '0' THEN #MOD-BC0129 add
               LET l_fbe09x=l_fbf.fbf07 * (1-(1/((100+l_fbe.fbe071)/100)))   #MOD-770152
               #MOD-BC0129---begin add
               ELSE
                  LET l_fbe09x=l_fbf.fbf072 * (1-(1/((100+l_fbe.fbe071)/100)))               
               END IF
               #MOD-BC0129---begin add 
               CALL cl_digcut(l_fbe09x,g_azi04) RETURNING l_fbe09x
               CALL cl_digcut(l_fbe08t,t_azi04) RETURNING l_fbe08t
               CALL cl_digcut(l_fbe09t,g_azi04) RETURNING l_fbe09t
            END IF 
         END IF
        #-CHI-A30001-add-
        #累計出售額
         LET l_sum = l_sum + l_fbe08t
         LET l_sum1= l_sum1+ l_fbe09t
        #當累計的出售額 大於 出售單身檔的出售金額時需調整至最後一筆金額
        #IF l_sum > l_fbe.fbe08t OR l_sum1 > l_fbe.fbe09t THEN  #MOD-D10111 mark
         IF l_cnt = l_cnt2 AND l_fbe.fbe12 = 'N' THEN           #MOD-D10111
           #LET l_fbe08t = l_fbe08t - (l_sum - l_fbe.fbe08t)    #MOD-D10111 mark
            LET l_fbe08t = l_fbe08t + (l_fbe.fbe08t - l_sum)    #MOD-D10111
           #LET l_fbe09t = l_fbe09t - (l_sum1- l_fbe.fbe09t)    #MOD-D10111 mark
            LET l_fbe09t = l_fbe09t + (l_fbe.fbe09t - l_sum1)   #MOD-D10111
         END IF
        #-CHI-A30001-end-
         LET g_npq.npq07f= l_fbe08t  #本幣出售金額
         LET g_npq.npq07 = l_fbe09t
          IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
          IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
         LET g_npq.npq23 = ' '
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
       # UPDATE npq_file SET npq07f = g_npq.npq07f,
       #                     npq07  = g_npq.npq07 
       #  WHERE npqsys = g_npq.npqsys
       #    AND npq00 = g_npq.npq00
       #    AND npq01 = g_npq.npq01
       #    AND npq011 = g_npq.npq011
       #    AND npq03 = g_npq.npq03   #科目 
        #IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
            LET g_npq.npq02 = g_npq.npq02 + 1
            #NO.FUN-5C0015 ---start
           #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
            RETURNING g_npq.*
            CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
            #No.FUN-5C0015 ---end
            IF g_npq.npq07 != 0 THEN  #MOD-990191 add
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
                # LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25   #MOD-BC0129 mark
            #     LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
                  LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
                  LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
               ELSE
                  LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
               END IF
#No.FUN-9A0036 --End
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno
                  AND aag01 = g_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET g_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (g_npq.*)
               IF STATUS THEN 
#                 CALL cl_err('ins npq#2',STATUS,1)   #No.FUN-660136
#No.FUN-710028 -begin
                  IF g_bgerr THEN
                     LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                     CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#2', STATUS,1)                #No.FUN-710028
                  ELSE
                     CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#2",1)  #No.FUN-660136 
                  END IF
#No.FUN-710028 --end
#                 LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                  
                  LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
               END IF
            END IF   #MOD-990191 add
        #END IF 
         #----- 損失 (fbz12)------------
   #     IF (l_faj14+l_faj141-l_faj59) > (l_faj32+l_fbf.fbf07) THEN 
#  #MOD-C30722--mark--str
#        IF l_fbf.fbf09<0 THEN
#           #-----MOD-660078---------
#           IF g_npq.npqtype = '0' THEN
#              LET g_npq.npq03 = l_fbz12    
#           ELSE
#              LET g_npq.npq03 = l_fbz121
#           END IF
#           #-----END MOD-660078-----
#           LET g_npq.npq04 = NULL   #MOD-6C0140 add
#           #No:7833
#           IF g_npq.npqtype = '0' THEN    #FUN-AB0088
#              IF l_faj23 = '1' THEN
#                 SELECT aag05 INTO l_aag05 FROM aag_file
#                  WHERE aag01=g_npq.npq03
#                   AND aag00=g_bookno  #No.FUN-740033
#                 IF l_aag05='Y' THEN
#                    LET g_npq.npq05 =l_faj24
#                 ELSE
#                    LET g_npq.npq05 = ' '
#                 END IF
#              ELSE
#                 LET g_npq.npq05 = NULL
#              END IF
#           ##
#           #FUN-AB0088---add---str---
#           ELSE
#              IF l_faj232 = '1' THEN
#                 SELECT aag05 INTO l_aag05 FROM aag_file
#                  WHERE aag01=g_npq.npq03
#                    AND aag00=g_bookno  
#                 IF l_aag05='Y' THEN
#                    LET g_npq.npq05 =l_faj242
#                 ELSE
#                    LET g_npq.npq05 = ' '
#                 END IF
#              ELSE
#                 LET g_npq.npq05 = NULL
#              END IF
#           END IF 
#           #FUN-AB0088---add---end---
#           LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1   #FUN-5B0038
#           LET g_npq25 = g_npq.npq25        #No.FUN-9A0036
#           LET g_npq.npq06 = '1'
#           #No.FUN-680028 --begin
#           LET g_npq.npq03 = l_fbz12    
#           #-----MOD-660078---------
#           #IF g_npq.npqtype = '0' THEN
#           #   LET g_npq.npq03 = l_fbz12    
#           #ELSE
#           #   LET g_npq.npq03 = l_fbz121
#           #END IF
#           #-----END MOD-660078-----
#           #No.FUN-680028 --end
#           IF g_npq.npqtype = '0' THEN #MOD-BC0129 add
#           LET g_npq.npq07f=  l_fbf.fbf09 * (-1)
#           LET g_npq.npq07 =  l_fbf.fbf09 * (-1) 
#           #MOD-BC0129---begin add
#           ELSE
#              LET g_npq.npq07f=  l_fbf.fbf092 * (-1)
#              LET g_npq.npq07 =  l_fbf.fbf092 * (-1)            
#           END IF
#           #MOD-BC0129---end add 
#           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
#           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
#           CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f   #MOD-810219
#           CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-810219
#  #        LET g_npq.npq07f=  (l_faj14+l_faj141-l_faj59) - (l_faj32+l_fbf.fbf07) 
#  #        LET g_npq.npq07 =  (l_faj14+l_faj141-l_faj59) - (l_faj32+l_fbf.fbf07) 
#           LET g_npq.npq23 = ' ' 
#           MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
#         # UPDATE npq_file SET npq07f =  g_npq.npq07f,
#         #                     npq07  =  g_npq.npq07 
#         #  WHERE npqsys = g_npq.npqsys
#         #    AND npq00 = g_npq.npq00
#         #    AND npq01 = g_npq.npq01
#         #    AND npq011 = g_npq.npq011
#         #    AND npq03 = g_npq.npq03   #科目 
#         # IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
#              LET g_npq.npq02 = g_npq.npq02 + 1
#              #NO.FUN-5C0015 ---start
#             #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
#              CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
#              RETURNING g_npq.*
#              CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
#              #No.FUN-5C0015 ---end
#              IF g_npq.npq07 != 0 THEN  #MOD-990191 add
#No.FUN-9A0036 --Begin
#                 IF p_npptype = '1' THEN
#FUN-A40067 --Begin
#                    SELECT aaa03 INTO l_aaa03 FROM aaa_file
#                     WHERE aaa01 = g_bookno2
#                    SELECT azi04 INTO g_azi04_2 FROM azi_file
#                     WHERE azi01 = l_aaa03
#FUN-A40067 --End
#                    CALL s_newrate(g_bookno1,g_bookno2,
#                                   g_npq.npq24,g_npq25,g_npp.npp02)
#                    RETURNING g_npq.npq25
#                  # LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25   #MOD-BC0129 mark
#           #        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
#                    LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
#                    LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
#                 ELSE
#                    LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
#                 END IF
#No.FUN-9A0036 --End
#                 INSERT INTO npq_file VALUES (g_npq.*)
#                 IF STATUS THEN 
#                    CALL cl_err('ins npq#3',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
#                    IF g_bgerr THEN
#                       LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
#                       CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#3', STATUS,1)                #No.FUN-710028
#                    ELSE
#                       CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#3",1)  #No.FUN-660136 
#                    END IF
#No.FUN-710028 --end
#                    LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                  
#                    LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
#                 END IF
#              END IF   #MOD-990191 add
#          #END IF 
#        END IF
      #MOD-C30722--mark--end
      END IF       #end No:A099
      #-------Dr.: 資產之資產科目(faj53) -------
      IF l_faj09 != '5' THEN   #MOD-990191 add
      LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1   #FUN-5B0038
      LET g_npq25 = g_npq.npq25                            #FUN-9A0036
      LET g_npq.npq06 = '2'
      #No.FUN-680028 --begin
#     LET g_npq.npq03 = l_faj53
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = l_faj53    
      ELSE
         LET g_npq.npq03 = l_faj531
      END IF
      #No.FUN-680028 --end
      LET g_npq.npq04 = NULL   #MOD-6C0140 add
      #No:7833
      IF g_npq.npqtype = '0' THEN     #FUN-AB0088
         IF l_faj23 = '1' THEN
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno  #No.FUN-740033
            IF l_aag05='Y' THEN
               LET g_npq.npq05 =l_faj24
            ELSE
               LET g_npq.npq05 = ' '
            END IF
         ELSE
            LET g_npq.npq05 = NULL
         END IF
         ##
      #FUN-AB0088---add---str---
      ELSE
         IF l_faj232 = '1' THEN
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno 
            IF l_aag05='Y' THEN
               LET g_npq.npq05 =l_faj242
            ELSE
               LET g_npq.npq05 = ' '
            END IF
         ELSE
            LET g_npq.npq05 = NULL
         END IF
      END IF
      #FUN-AB0088---add---end--- 
      IF g_npq.npqtype = '0' THEN     #FUN-AB0088
         LET g_npq.npq07f= (l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)*l_fbf.fbf04
         LET g_npq.npq07 = (l_faj14+l_faj141-l_faj59)/(l_faj17-l_faj58)*l_fbf.fbf04
      #FUN-AB0088---add---str---
      ELSE
         LET g_npq.npq07f= (l_faj142+l_faj1412-l_faj592)/(l_faj17-l_faj582)*l_fbf.fbf04
         LET g_npq.npq07 = (l_faj142+l_faj1412-l_faj592)/(l_faj17-l_faj582)*l_fbf.fbf04
      END IF   
      #FUN-AB0088---add---end---
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
      IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
      CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f   #MOD-810219
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-810219
      LET g_npq.npq23 = ' '
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
    # UPDATE npq_file SET npq07f = g_npq.npq07f,
    #                     npq07  = g_npq.npq07 
    #  WHERE npqsys = g_npq.npqsys
    #    AND npq00 = g_npq.npq00
    #    AND npq01 = g_npq.npq01
    #    AND npq011 = g_npq.npq011
    #    AND npq03 = g_npq.npq03   #科目 
    # IF STATUS OR SQLCA.SQLERRD[3]=0 THEN 
         LET g_npq.npq02 = g_npq.npq02 + 1
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
         #No.FUN-5C0015 ---end
         IF g_npq.npq07 != 0 THEN  #MOD-990191 add
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
             # LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25   #MOD-BC0129 mark
            #  LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
               LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
               LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
            ELSE
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
           #FUN-D40118 ---Add--- Start
            SELECT aag44 INTO l_aag44 FROM aag_file
             WHERE aag00 = g_bookno
               AND aag01 = g_npq.npq03
            IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
               CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
               IF l_flag = 'N'   THEN
                  LET g_npq.npq03 = ''
               END IF
            END IF
           #FUN-D40118 ---Add--- End
            INSERT INTO npq_file VALUES (g_npq.*)
            IF STATUS THEN 
#              CALL cl_err('ins npq#4',STATUS,1)   #No.FUN-660136
#No.FUN-710028 -begin
               IF g_bgerr THEN
                  LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                  CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#4', STATUS,1)                #No.FUN-710028
               ELSE
                  CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#4",1)  #No.FUN-660136 
               END IF
#No.FUN-710028 --end
#              LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                  
               LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
            END IF
         END IF   #MOD-990191 add
    # END IF 
      END IF   #MOD-990191 add
       IF g_faa.faa29 = 'N' OR g_aza.aza26<>'2' THEN       #No:A099 No.MOD-4A0174
         ##No.3043 1999/03/19 modify
         #----- DR.:稅額 (fbe08x,fbe09x)----
         IF l_fbe08x > 0 OR l_fbe09x > 0 THEN
           #start FUN-5B0038
            LET g_npq.npq24 = l_fbe.fbe05    #單頭的幣別
            LET g_npq.npq25 = l_fbe.fbe06    #單頭的匯率
            LET g_npq25 = g_npq.npq25        #FUN-9A0036
           #end FUN-5B0038
            LET g_npq.npq06 = '2'
            #No.FUN-680028 --begin
#           LET g_npq.npq03 = l_gec03    
            IF g_npq.npqtype = '0' THEN
               LET g_npq.npq03 = l_gec03    
            ELSE
               LET g_npq.npq03 = l_gec031
            END IF
            #No.FUN-680028 --end
            LET g_npq.npq04 = NULL   #MOD-6C0140 add
            #No:7833
            IF l_faj23 = '1' THEN
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno  #No.FUN-740033
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE
               LET g_npq.npq05 = NULL
            END IF
            ##
           #str CHI-870008 add
           #累計稅額
            LET l_sumtax = l_sumtax + l_fbe08x
            LET l_sumtax1= l_sumtax1+ l_fbe09x
           #當累計的稅額 大於 出售主檔的出售稅額時需調整至最後一筆稅額
           #IF l_sumtax > l_fbe.fbe08x OR l_sumtax1 > l_fbe.fbe09x THEN  #MOD-D10111 mark
            IF l_cnt = l_cnt2 THEN                                       #MOD-D10111
              #LET l_fbe08x = l_fbe08x - (l_sumtax - l_fbe.fbe08x)       #MOD-D10111 mark
               LET l_fbe08x = l_fbe08x + (l_fbe.fbe08x - l_sumtax)       #MOD-D10111
              #LET l_fbe09x = l_fbe09x - (l_sumtax1- l_fbe.fbe09x)       #MOD-D10111 mark
               LET l_fbe09x = l_fbe09x + (l_fbe.fbe09x - l_sumtax1)      #MOD-D10111 
            END IF
           #end CHI-870008 add
            LET g_npq.npq07f=  l_fbe08x
            LET g_npq.npq07 =  l_fbe09x
             IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
             IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
            LET g_npq.npq23 = ' ' 
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            LET g_npq.npq02 = g_npq.npq02 + 1
            #NO.FUN-5C0015 ---start
           #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
            CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
            RETURNING g_npq.*
            CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
            #No.FUN-5C0015 ---end
            IF g_npq.npq07 != 0 THEN  #MOD-990191 add

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
            #  LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25   #MOD-BC0129 mark
            #  LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
               LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
               LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
            ELSE
               LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
            END IF
#No.FUN-9A0036 --End
              #FUN-D40118 ---Add--- Start
               SELECT aag44 INTO l_aag44 FROM aag_file
                WHERE aag00 = g_bookno
                  AND aag01 = g_npq.npq03
               IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
                  CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET g_npq.npq03 = ''
                  END IF
               END IF
              #FUN-D40118 ---Add--- End
               INSERT INTO npq_file VALUES (g_npq.*)
               IF STATUS THEN 
#                 CALL cl_err('ins npq#5',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
                  IF g_bgerr THEN
                     LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
                     CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#5', STATUS,1)                #No.FUN-710028
                  ELSE
                     CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#5",1)  #No.FUN-660136 
                  END IF
#No.FUN-710028 --end
#                 LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                  
                  LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
               END IF
            END IF   #MOD-990191 add
         END IF
         ##---------------------------------
         #----- DR.:收益 (fbz11)------------
#-------MOD-C30722--mark--str 
#        IF l_fbf.fbf09>0 THEN
#           LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1   #FUN-5B0038
#           LET g_npq25=g_npq.npq25                              #FUN-9A0036
#           LET g_npq.npq06 = '2'
#           #No.FUN-680028 --begin
#           LET g_npq.npq03 = l_fbz11    
#           IF g_npq.npqtype = '0' THEN
#              LET g_npq.npq03 = l_fbz11    
#           ELSE
#              LET g_npq.npq03 = l_fbz111
#           END IF
#           #No.FUN-680028 --end
#           LET g_npq.npq04 = NULL   #MOD-6C0140 add
#           #No:7833
#           IF g_npq.npqtype = '0' THEN   #FUN-AB0088
#              IF l_faj23 = '1' THEN
#                 SELECT aag05 INTO l_aag05 FROM aag_file
#                  WHERE aag01=g_npq.npq03
#                    AND aag00=g_bookno  #No.FUN-740033
#                 IF l_aag05='Y' THEN
#                    LET g_npq.npq05 =l_faj24
#                 ELSE
#                    LET g_npq.npq05 = ' '
#                 END IF
#              ELSE
#                 LET g_npq.npq05 = NULL
#              END IF
#             ##
#           #FUN-AB0088---add---str---
#           ELSE
#              IF l_faj232 = '1' THEN
#                 SELECT aag05 INTO l_aag05 FROM aag_file
#                  WHERE aag01=g_npq.npq03
#                    AND aag00=g_bookno  
#                 IF l_aag05='Y' THEN
#                    LET g_npq.npq05 =l_faj242
#                 ELSE
#                    LET g_npq.npq05 = ' '
#                 END IF
#              ELSE
#                 LET g_npq.npq05 = NULL
#              END IF
#           END IF
#           #FUN-AB0088---add---end---
#           IF g_npq.npqtype = '0' THEN #MOD-BC0129 add
#           LET g_npq.npq07f=  l_fbf.fbf09 
#           LET g_npq.npq07 =  l_fbf.fbf09
#           #MOD-BC0129--begin add
#           ELSE
#              LET g_npq.npq07f=  l_fbf.fbf092 
#              LET g_npq.npq07 =  l_fbf.fbf092            
#           END IF
#           #MOD-BC0129--end add 
#           IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     #No.MOD-4A0174
#           IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       #No.MOD-4A0174
#           CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f   #MOD-810219
#           CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-810219
#           LET g_npq.npq23 = ' ' 
#           MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
#           LET g_npq.npq02 = g_npq.npq02 + 1
#           #NO.FUN-5C0015 ---start
#          #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
#           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
#           RETURNING g_npq.*
#           CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
#           #No.FUN-5C0015 ---end
#           IF g_npq.npq07 != 0 THEN  #MOD-990191 add
#No.FUN-9A0036 --Begin
#           IF p_npptype = '1' THEN
#FUN-A40067 --Begin
#              SELECT aaa03 INTO l_aaa03 FROM aaa_file
#               WHERE aaa01 = g_bookno2
#              SELECT azi04 INTO g_azi04_2 FROM azi_file
#               WHERE azi01 = l_aaa03
#FUN-A40067 --End
#              CALL s_newrate(g_bookno1,g_bookno2,
#                             g_npq.npq24,g_npq25,g_npp.npp02)
#              RETURNING g_npq.npq25
#           #  LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25   #MOD-BC0129 mark
#           #  LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
#              LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  #MOD-BC0129 add
#              LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  #MOD-BC0129 add
#           ELSE
#              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
#           END IF
#No.FUN-9A0036 --End
#              INSERT INTO npq_file VALUES (g_npq.*)
#              IF STATUS THEN 
#                 CALL cl_err('ins npq#5',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
#                 IF g_bgerr THEN
#                    LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
#                    CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#5', STATUS,1)                #No.FUN-710028
#                 ELSE
#                    CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#5",1)  #No.FUN-660136 
#                 END IF
#No.FUN-710028 --end
#                 LET g_success='N' EXIT FOREACH        #no.5573 #No.FUN-710028                                  
#                 LET g_success='N' CONTINUE FOREACH    #No.FUN-710028                                  
#              END IF
#           END IF   #MOD-990191 add
#        END IF
#-----------MOD-C30722--mark--end
      END IF      #end No:A099
      LET l_cnt2 = l_cnt2 + 1   #MOD-D10111
   END FOREACH
   IF g_faa.faa29 = 'N' OR g_aza.aza26<>'2' THEN   #No.TQC-C60223
   #MOD-C30722--add--str
   LET l_fbe10 = 0 
   SELECT fbe10 INTO l_fbe10 FROM fbe_file 
    WHERE fbe01 = g_no
   IF l_fbe10 < 0 THEN 
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = l_fbz12    
      ELSE
         LET g_npq.npq03 = l_fbz121
      END IF
      LET g_npq.npq04 = NULL
     #----------------MOD-D10260--------(S)
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = g_npq.npq03
         AND aag00 = g_bookno
      IF l_aag05 = 'Y' THEN
         LET g_npq.npq05 = l_fbe.fbe17
      ELSE
         LET g_npq.npq05 = ' '
      END IF
     #LET g_npq.npq05 = ' '       #MOD-D10260 mark
     #----------------MOD-D10260--------(E)
      LET g_npq.npq24 = g_aza.aza17
      LET g_npq.npq25 = 1   
      LET g_npq25 = g_npq.npq25        
      LET g_npq.npq06 = '1'
      LET g_npq.npq07f = l_fbe10*(-1)
      LET g_npq.npq07 = l_fbe10*(-1)
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     
      IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       
      CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f   
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07
      LET g_npq.npq23 = ' ' 
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      LET g_npq.npq02 = g_npq.npq02 + 1
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   
         RETURNING g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno) 
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 
      IF g_npq.npq07 != 0 THEN  
         IF p_npptype = '1' THEN
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = g_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
            CALL s_newrate(g_bookno1,g_bookno2,g_npq.npq24,g_npq25,g_npp.npp02)
               RETURNING g_npq.npq25
	    LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  
            LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04)  
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   
         END IF
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
	 INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00 
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#3', STATUS,1)      
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#3",1)  
            END IF
            LET g_success='N' 
         END IF
      END IF   
   END IF
   IF l_fbe10 > 0 THEN 
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = l_fbz11    
      ELSE
         LET g_npq.npq03 = l_fbz111
      END IF
      LET g_npq.npq04 = NULL
     #----------------MOD-D10260--------(S)
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = g_npq.npq03
         AND aag00 = g_bookno
      IF l_aag05 = 'Y' THEN
         LET g_npq.npq05 = l_fbe.fbe17
      ELSE
         LET g_npq.npq05 = ' '
      END IF
     #LET g_npq.npq05 = ' '       #MOD-D10260 mark
     #----------------MOD-D10260--------(E)
      LET g_npq.npq24 = g_aza.aza17
      LET g_npq.npq25 = 1   
      LET g_npq25 = g_npq.npq25        
      LET g_npq.npq06 = '2'
      LET g_npq.npq07f = l_fbe10
      LET g_npq.npq07 = l_fbe10
      IF cl_null(g_npq.npq07f) THEN LET g_npq.npq07f=0 END IF     
      IF cl_null(g_npq.npq07) THEN LET g_npq.npq07=0 END IF       
      CALL cl_digcut(g_npq.npq07f,g_azi04) RETURNING g_npq.npq07f   #MOD-810219
      CALL cl_digcut(g_npq.npq07,g_azi04) RETURNING g_npq.npq07   #MOD-810219
      LET g_npq.npq23 = ' ' 
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      LET g_npq.npq02 = g_npq.npq02 + 1
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbf.fbf02,'',g_bookno)   
         RETURNING g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno)
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  
      IF g_npq.npq07 != 0 THEN  
         IF p_npptype = '1' THEN
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = g_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
            CALL s_newrate(g_bookno1,g_bookno2,g_npq.npq24,g_npq25,g_npp.npp02)
               RETURNING g_npq.npq25
            LET g_npq.npq07f= g_npq.npq07  / g_npq.npq25  
            LET g_npq.npq07f= cl_digcut(g_npq.npq07f,t_azi04) 
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  
         END IF
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = g_npq.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET g_npq.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#5', STATUS,1)                
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#5",1)  
            END IF
            LET g_success='N'                           
         END IF
      END IF  
   END IF
   #MOD-C30722--add--end
   END IF   #No.TQC-C60223
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 -end
 
END FUNCTION
#FUN-A40033 --Begin
FUNCTION t110_gen_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_fbe05          LIKE fbe_file.fbe05   #MOD-BC0129 add
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag =  '1' THEN
         CALL cl_err(g_npp.npp02,'aoo-081',1)
         RETURN
      END IF
 
      #FUN-AB0088---add---str---
      #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
      #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
      IF NOT cl_null(g_faa.faa02c) THEN LET g_bookno2 = g_faa.faa02c END IF 
      #FUN-AB0088---add---end---

      LET g_bookno = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
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
         LET l_npq1.npqlegal = g_legal
         #FUN-D10065--add--str--
         CALL s_def_npq3(g_bookno,l_npq1.npq03,g_prog,l_npq1.npq01,'','')
         RETURNING l_npq1.npq04
         #FUN-D10065--add--end--
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF STATUS THEN                                                         
            IF g_bgerr THEN
               LET g_showmsg = l_npq1.npq01,"/",l_npq1.npq011,"/",l_npq1.npq02,"/",l_npq1. npqsys,"/",l_npq1.npq00
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#10', STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#10",1)
            END IF
            LET g_success='N'
         END IF                                                                 
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
#MOD-6C0187

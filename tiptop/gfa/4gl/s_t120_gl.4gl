# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Date & Author..: 03/11/18 By Danny
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: FUN-5C0015 05/12/20 BY GILL (1)多Update 異動碼5~10, 關係人
#                  (2)若該科目有設彈性異動碼(agli120),則default帶出
#                     彈性異動碼的設定值(call s_def_npq: 抓取異動碼default值)
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/22 By Ray 多帳套修改
# Modify.........: No.FUN-690009 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.TQC-690113 06/12/06 By Smapmin 依據分錄單身判斷分錄是否存在
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah s_def_npq()時,p_key2的地方改成傳fbt02
# Modify.........: No.FUN-740026 07/04/10 By Judy 會計科目加帳套 
# Modify.........: No.MOD-980018 09/08/03 By mike gaft120分錄底搞的「借貸會科相反」   
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-AA0087 11/01/27 By chenmoyan 異動碼類弄設定改善
# Modify.........: No.FUN-AB0088 11/04/01 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3處理的地方加npptype判斷
# Modify.........: No:FUN-D40118 13/05/22 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
 
DATABASE ds
 
GLOBALS "../../config/top.global" 
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
#   DEFINE g_no	        VARCHAR(10) 
   DEFINE g_no	        LIKE npp_file.npp01     #NO.FUN-690009 VARCHAR(16)    #No.FUN-550034
   DEFINE g_date        LIKE type_file.dat      #NO.FUN-690009 DATE
   DEFINE g_chr         LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)                                                 
   DEFINE g_msg         LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(72)  
   DEFINE g_flag        LIKE type_file.chr1    #FUN-740026
   DEFINE g_bookno1     LIKE aza_file.aza81    #FUN-740026
   DEFINE g_bookno2     LIKE aza_file.aza82    #FUN-740026
   DEFINE g_bookno3     LIKE aza_file.aza82    #FUN-740026
   DEFINE g_npq25       LIKE npq_file.npq25    #No.FUN-9A0036
   DEFINE g_aag44       LIKE aag_file.aag44    #FUN-D40118 add
FUNCTION t120_gl(p_no,p_date,p_npptype)
#   DEFINE p_no     VARCHAR(10)
   DEFINE p_no    	LIKE npp_file.npp01     #NO.FUN-690009 VARCHAR(16)    #No.FUN-550034
   DEFINE p_date  	LIKE type_file.dat      #NO.FUN-690009 DATE 
   DEFINE p_npptype     LIKE npp_file.npptype   #No.FUN-680028
   DEFINE l_buf		LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5     #NO.FUN-690009 SMALLINT
#   DEFINE l_t1,l_fahdmy3  VARCHAR(03)
   DEFINE l_t1,l_fahdmy3  LIKE fah_file.fahslip   #NO.FUN-690009 VARCHAR(05)    #No.FUN-550034
 
   WHENEVER ERROR CONTINUE
   LET g_no = p_no LET g_date = p_date
   IF cl_null(g_no) THEN RETURN END IF
   IF p_date < g_faa.faa09 THEN   #立帳日期小於關帳日期
      CALL cl_err(g_no,'aap-176',1) RETURN 
   END IF
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
#     CALL cl_err('sel fah:',STATUS,0)  #No.FUN-660146
      CALL cl_err3("sel","fah_file",l_t1,"",STATUS,"","sel fah",0)   #No.FUN-660146
   END IF
   #----->是否拋轉傳票
   IF l_fahdmy3 != 'Y' THEN RETURN END IF
   #-----TQC-690113---------
   #SELECT COUNT(*) INTO l_n FROM npp_file WHERE nppsys = 'FA' AND npp00= 13
   #                                         AND npp01 = g_no
   #                                         AND npp011 = 1
   SELECT COUNT(*) INTO l_n FROM npq_file WHERE npqsys = 'FA' AND npq00= 13
                                            AND npq01 = g_no
                                            AND npq011 = 1
   #-----END TQC-690113-----
 
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
   DELETE FROM tic_file WHERE tic04 = g_no  #FUN-B40056
   DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00= 13
                          AND npp01 = g_no  
                          AND npp011 = 1
                          AND npptype = p_npptype     #No.FUN-680028
   DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00= 13
                          AND npq01 = g_no  
                          AND npq011 = 1
                          AND npqtype = p_npptype     #No.FUN-680028
   CALL s_t120(p_npptype)
   DELETE FROM npq_file WHERE npq01=g_no AND npq03='-'
                          AND npqtype = p_npptype     #No.FUN-680028
   CALL s_t120_diff()                                 #FUN-A40033 Add
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021 
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION s_t120(p_npptype)      #No.FUN-680028
DEFINE p_npptype  LIKE npp_file.npptype     #No.FUN-680028 
DEFINE l_fbz17    LIKE fbz_file.fbz17,  
       l_fbz171   LIKE fbz_file.fbz171,     #No.FUN-680028  
       l_fab24    LIKE fab_file.fab24,
       l_fab241   LIKE fab_file.fab241,     #No.FUN-680028
       l_fbt      RECORD LIKE fbt_file.*,
       l_faj23    LIKE faj_file.faj23,
       l_faj24    LIKE faj_file.faj24,
       l_aag05    LIKE aag_file.aag05,    
       l_sql      LIKE type_file.chr1000    #NO.FUN-690009 VARCHAR(600)
DEFINE l_aaa03    LIKE aaa_file.aaa03       #FUN-A40067
DEFINE l_azi04_2  LIKE azi_file.azi04       #FUN-A40067
#FUN-AB0088---add---str---
DEFINE l_faj232   LIKE faj_file.faj232
DEFINE l_faj242   LIKE faj_file.faj242
#FUN-AB0088---add---end---
DEFINE l_flag     LIKE type_file.chr1    #FUN-D40118 add

 
   #-------------(單頭)-----------------------------------
   LET g_npp.nppsys = 'FA'        LET g_npp.npp00 = 13  
   LET g_npp.npp01  = g_no        LET g_npp.npp011= 1
   LET g_npp.npp02  = g_date      LET g_npp.npp03 = NULL
   LET g_npp.npptype = p_npptype     #No.FUN-680028
   LET g_npp.npplegal= g_legal       #FUN-980011 add
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
#     CALL cl_err('ins npp',STATUS,1)   #No.FUN-660146
      CALL cl_err3("ins","npp_file",g_npp.npp01,g_npp.npp011,STATUS,"","ins npp",1)   #No.FUN-660146
      LET g_success='N' RETURN  
   END IF
 
   #-------------(單身)-----------------------------------
   LET g_npq.npqsys = 'FA'        LET g_npq.npq00 = 13  
   LET g_npq.npq01 = g_no         LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0            LET g_npq.npq04 = NULL        
   LET g_npq.npq21 = NULL         LET g_npq.npq22 = NULL 
   LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1          
   LET g_npq25     = g_npq.npq25     #No.FUN-9A0036
   LET g_npq.npqtype = p_npptype     #No.FUN-680028
   LET g_npq.npqlegal= g_legal       #FUN-980011 add
#FUN-740026.....begin
   CALL s_get_bookno(YEAR(g_date)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(g_date,'aoo-081',1)
      LET g_success = 'N'
      RETURN
   END IF

   #FUN-AB0088---add---str---
   #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
   #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
   IF NOT cl_null(g_faa.faa02c) THEN LET g_bookno2 = g_faa.faa02c END IF 
   #FUN-AB0088---add---end---

   IF p_npptype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
#FUN-740026.....end
#FUN-A40067 --Begin
   SELECT aaa03 INTO l_aaa03 FROM aaa_file
    WHERE aaa01 = g_bookno2
   SELECT azi04 INTO l_azi04_2 FROM azi_file
    WHERE azi01 = l_aaa03
#FUN-A40067 --End
   SELECT fbz17,fbz171 INTO l_fbz17,l_fbz171 FROM fbz_file WHERE fbz00 = '0'      #No.FUN-680028
   IF SQLCA.sqlcode THEN LET l_fbz17 = ' ' END IF
 
   LET l_sql = "SELECT fbt_file.*,faj23,faj24,fab24,fab241, ",     #No.FUN-680028
               "       faj232,faj242 ",                            #FUN-AB0088
               "  FROM fbt_file,faj_file LEFT OUTER JOIN fab_file ON faj_file.faj04=fab_file.fab01 ",
               " WHERE fbt01 = '",g_no,"'",
               "   AND fbt03 = faj02",
               "   AND fbt031= faj022" 
   PREPARE t120_p FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('t120_p',SQLCA.sqlcode,0) LET g_success = 'N' RETURN
   END IF
   DECLARE t120_c CURSOR WITH HOLD FOR t120_p
   FOREACH t120_c INTO l_fbt.*,l_faj23,l_faj24,l_fab24,l_fab241,     #No.FUN-680028
                       l_faj232,l_faj242                             #FUN-AB0088
      IF SQLCA.sqlcode THEN
         CALL cl_err('t120_c',SQLCA.sqlcode,0) LET g_success = 'N'
         EXIT FOREACH 
      END IF
 
      #固定資產減值時, 借記'固定資產減值準備' #MOD-980018 營業外支出-計提的固定資產減值准備-->固定資產減值准備 
      #(調減)          貸記'營業外支出-計提的固定資產減值準備' #MOD-980018 調增-->調減,固定資產減值准備-->營業外支出-計提的固定資產減值准備
      #如已計提減值準備的固定資產價值恢復時, 應
      #(調增）         借記'營業外支出-計提的固定資產減值準備' #MOD-980018 調減-->調增,固定資產減值准備-->營業外支出-計提的固定資產減值准備
      #                貸記'固定資產減值準備' #MOD-980018 營業外支出-計提的固定資產減值准備-->固定資產減值准備  
 
      IF l_fbt.fbt06 = '2' THEN    #MOD-980018 1-->2    
         #-------Dr.: 調增時, 減值準備對方科目(fbz17)--------
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq06 = '1'
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fbz17
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fbz17
         ELSE
            LET g_npq.npq03 = l_fbz171
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         LET g_npq.npq07f= l_fbt.fbt07
         LET g_npq.npq07 = l_fbt.fbt07
         #-->單一部門分攤才給部門
         IF g_npq.npqtype = '0' THEN   #FUN-AB0088  
            IF l_faj23 = '1' THEN 
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno3   #FUN-740026
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE 
               LET g_npq.npq05 = NULL           
            END IF
         #FUN-AB0088---add---str---
         ELSE
            IF l_faj232 = '1' THEN 
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno3
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
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
 
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbt.fbt02,'',g_bookno3)   #MOD-6C0140     #No.FUN-740026
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno3)                 #FUN-AA0087             
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
         #No.FUN-5C0015 ---end
 
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
                RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
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
#           CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#1",1)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH #no.5573
         END IF
         #-------Cr.: 調增時, 減值準備科目(fab24)--------
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq06 = '2'
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fab24
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
                  AND aag00=g_bookno3   #FUN-740026
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE 
               LET g_npq.npq05 = NULL           
            END IF
         #FUN-AB0088---add---str---
         ELSE
            IF l_faj232 = '1' THEN 
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno3 
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
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
 
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbt.fbt02,'',g_bookno3)   #MOD-6C0140   #No.FUN-740026
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno3)                 #FUN-AA0087             
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
         #No.FUN-5C0015 ---end
 
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
                RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
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
#           CALL cl_err('ins npq#2',STATUS,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#2",1)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH #no.5573
         END IF
      ELSE
         #-------Dr.: 調減時, 減值準備科目(fab24)--------
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq06 = '1'
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fab24
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fab24
         ELSE
            LET g_npq.npq03 = l_fab241
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         LET g_npq.npq07f= l_fbt.fbt07
         LET g_npq.npq07 = l_fbt.fbt07
         #-->單一部門分攤才給部門
         IF g_npq.npqtype = '0' THEN   #FUN-AB0088
            IF l_faj23 = '1' THEN 
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno3   #FUN-740026
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE 
               LET g_npq.npq05 = NULL           
            END IF
         #FUN-AB0088---add---str---
         ELSE
            IF l_faj232 = '1' THEN 
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno3   
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
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
 
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbt.fbt02,'',g_bookno3)   #MOD-6C0140     #No.FUN-740026
         RETURNING g_npq.*
         #No.FUN-5C0015 ---end
         CALL s_def_npq31_npq34(g_npq.*,g_bookno3)                 #FUN-AA0087             
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
 
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
                RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
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
#           CALL cl_err('ins npq#3',STATUS,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#3",1)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH #no.5573
         END IF
         #-------Cr.: 調減時, 減值準備對方科目(fbz17)--------
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq06 = '2'
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_fbz17
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_fbz17
         ELSE
            LET g_npq.npq03 = l_fbz171
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         #-->單一部門分攤才給部門
         IF g_npq.npqtype = '0' THEN   #FUN-AB0088
            IF l_faj23 = '1' THEN 
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno3   #FUN-740026
               IF l_aag05='Y' THEN
                  LET g_npq.npq05 =l_faj24
               ELSE
                  LET g_npq.npq05 = ' '
               END IF
            ELSE 
               LET g_npq.npq05 = NULL           
            END IF
        #FUN-AB0088---add---str---
        ELSE
            IF l_faj232 = '1' THEN 
               SELECT aag05 INTO l_aag05 FROM aag_file
                WHERE aag01=g_npq.npq03
                  AND aag00=g_bookno3 
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
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
 
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fbt.fbt02,'',g_bookno3)   #MOD-6C0140  #No.FUN-740026
         RETURNING g_npq.*
         #No.FUN-5C0015 ---end
         CALL s_def_npq31_npq34(g_npq.*,g_bookno3)                 #FUN-AA0087             
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
 
#No.FUN-9A0036 --Begin
         IF p_npptype = '1' THEN
            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
                RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#           LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,l_azi04_2)#FUN-A40067
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
#           CALL cl_err('ins npq#4',STATUS,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,STATUS,"","ins npq#4",1)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH #no.5573
         END IF
      END IF
   END FOREACH
END FUNCTION
#FUN-A40033 --Begin
FUNCTION s_t120_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_flag           LIKE type_file.chr1    #FUN-D40118 add
   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_date)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(g_date,'aoo-081',1)
         RETURN
      END IF

      #FUN-AB0088---add---str---
      #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
      #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
      IF NOT cl_null(g_faa.faa02c) THEN LET g_bookno2 = g_faa.faa02c END IF 
      #FUN-AB0088---add---end---
 
      LET g_bookno3=g_bookno2
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

# Prog. Version..: '5.30.07-13.05.31(00010)'     #
 
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: NO.FUN-5C0015 05/12/20 By alana
# call s_def_npq.4gl 抓取異動碼default值
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/18 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.MOD-690080 06/10/17 By Smapmin 依據分錄單身(npq_file)判斷分錄是否存在
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah s_def_npq()時,p_key2的地方改成傳faz02
# Modify.........: No.FUN-710028 07/02/01 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# Modify.........: No.FUN-980003 09/08/12 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-AA0087 11/01/28 By Mengxw 異動碼類型設定的改善 
# Modify.........: No.FUN-AB0088 11/04/01 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3處理的地方加npptype判斷
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值(追单)
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
 
DATABASE ds

GLOBALS "../../config/top.global"
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
#   DEFINE g_no	        LIKE type_file.chr20            #No.FUN-680070 VARCHAR(10)
   DEFINE g_no	        LIKE type_file.chr20     #No.FUN-550034          #No.FUN-680070 VARCHAR(16)
   DEFINE g_date        LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE g_chr         LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE g_msg         LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
   DEFINE g_bookno1     LIKE aza_file.aza81         #No.FUN-740033
   DEFINE g_bookno2     LIKE aza_file.aza82         #No.FUN-740033
   DEFINE g_bookno      LIKE aza_file.aza81         #No.FUN-740033
   DEFINE g_flag        LIKE type_file.chr1         #No.FUN-740033
   DEFINE g_npq25       LIKE npq_file.npq25         #FUN-9A0036
   DEFINE g_azi04_2     LIKE azi_file.azi04         #FUN-A40067
 
FUNCTION t105_gl(p_no,p_date,p_npptype)     #No.FUN-680028
#   DEFINE p_no    	LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
   DEFINE p_no    	LIKE type_file.chr20      #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
   DEFINE p_date  	LIKE type_file.dat           #No.FUN-680070 DATE
   DEFINE p_npptype     LIKE npp_file.npptype     #No.FUN-680028
   DEFINE l_buf		LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5         #No.FUN-680070 SMALLINT
#   DEFINE l_t1          LIKE type_file.chr3         #No.FUN-680070 VARCHAR(03)
   DEFINE l_t1          LIKE type_file.chr5      #No.FUN-550034          #No.FUN-680070 VARCHAR(05)
   DEFINE l_fahdmy3     LIKE fah_file.fahdmy3
 
   WHENEVER ERROR CONTINUE
   LET g_no = p_no LET g_date = p_date
   IF cl_null(g_no) THEN RETURN END IF
   IF p_npptype = "0" THEN    #FUN-B60140   Add
      IF p_date < g_faa.faa09 THEN  
         CALL cl_err(g_no,'aap-176',1) RETURN 
      END IF
    #FUN-B60140   ---start  Add
     ELSE
        IF p_date < g_faa.faa092 THEN   #立帳日期小於關帳日期
           CALL cl_err(g_no,'aap-176',1)
           RETURN
        END IF
     END IF
    #FUN-B60140   ---end    Add
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
#     CALL cl_err('sel fah:',STATUS,0)   #No.FUN-660136
      CALL cl_err3("sel","fah_file",l_t1,"",SQLCA.sqlcode,"","sel fah:",0)   #No.FUN-660136
   END IF
   IF l_fahdmy3 != 'Y' THEN  RETURN END IF
   #-----MOD-690080---------
   #SELECT COUNT(*) INTO l_n FROM npp_file WHERE nppsys = 'FA' AND npp00= 7
   #                                         AND npp01 = g_no
   #                                         AND npp011 = 1
   SELECT COUNT(*) INTO l_n FROM npq_file WHERE npqsys = 'FA' AND npq00= 7
                                            AND npq01 = g_no
                                            AND npq011 = 1
   #-----END MOD-690080-----
 
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
   DELETE FROM npp_file WHERE nppsys = 'FA' AND npp00= 7
                          AND npp01 = g_no  
                          AND npp011 = 1
                          AND npptype = p_npptype     #No.FUN-680028
   DELETE FROM npq_file WHERE npqsys = 'FA' AND npq00= 7
                          AND npq01 = g_no  
                          AND npq011 = 1
                          AND npqtype = p_npptype     #No.FUN-680028
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_no
   #FUN-B40056--add--end--
   CALL s_t105(p_npptype)
   DELETE FROM npq_file WHERE npq01=g_no  AND npq03='-'
                          AND npqsys='FA' AND npq00=7 
                          AND npq011=1
                          AND npqtype = p_npptype     #No.FUN-680028
   CALL s_t105_diff()  #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
   
FUNCTION s_t105(p_npptype)      #No.FUN-680028
DEFINE p_npptype  LIKE npp_file.npptype     #No.FUN-680028 
DEFINE l_fbz05    LIKE fbz_file.fbz05,  
       l_faz02    LIKE faz_file.faz02,      #MOD-6C0140 add
       l_faz08    LIKE faz_file.faz08,  
       l_fbz051   LIKE fbz_file.fbz051,     #No.FUN-680028  
       l_faj23    LIKE faj_file.faj23,
       l_faj24    LIKE faj_file.faj24,
       l_faj53    LIKE faj_file.faj53,
       l_faj531   LIKE faj_file.faj531,     #No.FUN-680028
       l_aag05    LIKE aag_file.aag05,      #No:7833
       l_sql      LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(600)
DEFINE l_aaa03    LIKE aaa_file.aaa03       #FUN-A40067
#FUN-AB0088---add---str-------------
DEFINE l_faj232   LIKE faj_file.faj232
DEFINE l_faj242   LIKE faj_file.faj242
DEFINE l_faz082   LIKE faz_file.faz082
#FUN-AB0088---add---end------------- 
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   #-------------(單頭)-----------------------------------
   LET g_npp.nppsys = 'FA'        LET g_npp.npp00 = 7   
   LET g_npp.npp01  = g_no        LET g_npp.npp011= 1
   LET g_npp.npp02  = g_date      LET g_npp.npp03 = NULL
   LET g_npp.npptype = p_npptype     #No.FUN-680028
   LET g_npp.npplegal= g_legal    #FUN-980003 add
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660136
      CALL cl_err3("ins","npp_file",g_npp.npp01,g_npp.nppsys,SQLCA.sqlcode,"","ins npp",1)   #No.FUN-660136
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
   LET g_bookno2 = g_faa.faa02c
   #FUN-AB0088---add---end---
  
   #-------------(單身)-----------------------------------
   LET g_npq.npqsys = 'FA'        LET g_npq.npq00 = 7   
   LET g_npq.npq01 = g_no         LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0            LET g_npq.npq04 = NULL        
   LET g_npq.npq21 = NULL         LET g_npq.npq22 = NULL 
   LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1          
   LET g_npq.npqtype = p_npptype     #No.FUN-680028
   LET g_npq.npqlegal= g_legal       #FUN-980003 add
   #No.FUN-740033  --Begin
   IF g_npq.npqtype = '0' THEN
      LET g_bookno = g_bookno1
   ELSE
      LET g_bookno = g_bookno2
   END IF
   #No.FUN-740033  --End  
   LET g_npq25 = g_npq.npq25  #FUN-9A0036
   SELECT fbz05,fbz051 INTO l_fbz05,l_fbz051 FROM fbz_file WHERE fbz00 = '0'      #No.FUN-680028
   IF SQLCA.sqlcode THEN LET l_fbz05 = ' ' END IF
 
   LET l_sql = "SELECT faz02,faz08,faj23,faj24,faj53,faj531, ",    #No.FUN-680028   #MOD-6C0140 add faz02
               "       faz082,faj232,faj242 ",                     #FUN-AB0088 add
               "  FROM faz_file LEFT OUTER JOIN faj_file ON faz03=faj02 AND faz031=faj022",
               " WHERE faz01 = '",g_no,"'"
   PREPARE t105_p FROM l_sql
   DECLARE t105_c CURSOR WITH HOLD FOR t105_p
   FOREACH t105_c INTO l_faz02,l_faz08,l_faj23,l_faj24,l_faj53,l_faj531,     #No.FUN-680028   #MOD-6C0140 add l_faz02
                       l_faz082,l_faj232,l_faj242     #FUN-AB0088 add
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
      LET g_npq.npq04 = NULL   #FUN-D10065  add 
      IF SQLCA.sqlcode THEN
#No.FUN-710028 -begin
         IF g_bgerr THEN
            CALL s_errmsg('faz01',g_no,'t105_c',SQLCA.sqlcode,0)  #No.FUN-710028
         ELSE
            CALL cl_err('t105_c',SQLCA.sqlcode,0)
         END IF
#No.FUN-710028 --end
         EXIT FOREACH 
      END IF
      #-------Dr.: 資產科目(faj53) -----------
      LET g_npq.npq02 = g_npq.npq02 + 1
      #-->單一部門分攤才給部門
      IF g_npq.npqtype = '0' THEN   #FUN-AB0088 add
         IF l_faj23 = '1' THEN 
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
        ELSE LET g_npq.npq05 = NULL           
        END IF
      #FUN-AB0088---add---str--------
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
      #FUN-AB0088---add---end--------   
      
      #No.FUN-680028 --begin
#     LET g_npq.npq03 = l_faj53    
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = l_faj53    
      ELSE
         LET g_npq.npq03 = l_faj531
      END IF
      #No.FUN-680028 --end
      LET g_npq.npq06 = '1'
      IF g_npq.npqtype = '0' THEN   #FUN-AB0088 add
         LET g_npq.npq07f= l_faz08
         LET g_npq.npq07 = l_faz08
      #FUN-AB0088---add---str----------
      ELSE
         LET g_npq.npq07f= l_faz082
         LET g_npq.npq07 = l_faz082
      END IF     
      #FUN-AB0088---add---end----------
      LET g_npq.npq23 = ' ' 
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      #NO.FUN-5C0015 ---start
     #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')        #MOD-6C0140 mark
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_faz02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
      RETURNING g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
      #No.FUN-5C0015 ---end
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
          CALL s_newrate(g_bookno1,g_bookno2,g_npq.npq24,
                         g_npq25,g_npp.npp02)
          RETURNING g_npq.npq25
          LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2) #FUN-A40067
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
#        CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
         IF g_bgerr THEN
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                #No.FUN-710028
         ELSE
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   #No.FUN-660136 
         END IF
#No.FUN-710028 --end
#        LET g_success='N' EXIT FOREACH      #no.5573 #No.FUN-710028
         LET g_success='N' CONTINUE FOREACH  #No.FUN-710028
 
      END IF
      #-------Cr.: 改良之對方科目(fbz05) -----
      LET g_npq.npq02 = g_npq.npq02 + 1
      #No.FUN-680028 --begin
#     LET g_npq.npq03 = l_fbz05
      IF g_npq.npqtype = '0' THEN
         LET g_npq.npq03 = l_fbz05    
      ELSE
         LET g_npq.npq03 = l_fbz051
      END IF
      #No.FUN-680028 --end
      LET g_npq.npq04 = NULL   #MOD-6C0140 add
      #No:7833
      IF g_npq.npqtype = '0' THEN   #FUN-AB0088 add
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
      #FUN-AB0088---add---str-----
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
      #FUN-AB0088---add---end-----  
      ##
      LET g_npq.npq06 = '2'
      IF g_npq.npqtype = '0' THEN   #FUN-AB0088 add
         LET g_npq.npq07f=l_faz08 
         LET g_npq.npq07 =l_faz08  
      #FUN-AB0088---add---str-----
      ELSE
        LET g_npq.npq07f=l_faz082 
        LET g_npq.npq07 =l_faz082
      END IF  
      #FUN-AB0088---add---end----- 
      LET g_npq.npq23 = ' '
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      #NO.FUN-5C0015 ---start
     #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')        #MOD-6C0140 mark
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_faz02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
      RETURNING g_npq.*
      CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
      #No.FUN-5C0015 ---end
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
          CALL s_newrate(g_bookno1,g_bookno2,g_npq.npq24,
                         g_npq25,g_npp.npp02)
          RETURNING g_npq.npq25
          LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
#         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
          LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2) #FUN-A40067
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
#        CALL cl_err('ins npq#2',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
         IF g_bgerr THEN
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#2', STATUS,1)                #No.FUN-710028
         ELSE
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#2",1)   #No.FUN-660136 
         END IF
#No.FUN-710028 --end
#        LET g_success='N' EXIT FOREACH      #no.5573 #No.FUN-710028
         LET g_success='N' CONTINUE FOREACH  #No.FUN-710028
      END IF
   END FOREACH
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 -end
 
END FUNCTION
#FUN-A40033 --Begin
FUNCTION s_t105_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
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
      LET g_bookno2 = g_faa.faa02c
      #FUN-AB0088---add---end--- 

      LET g_bookno = g_bookno2
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno
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
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#2', STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq1.npq01,l_npq1.npq02,SQLCA.sqlcode,"","ins npq#2",1)
            END IF
            LET g_success='N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End

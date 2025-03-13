# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify.........: NO.FUN-550034 05/05/23 By jackie 單據編號加大
# Modify.........: NO.FUN-5C0015 05/12/20 By alana call s_def_npq.4gl 抓取異動碼default值
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/18 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah s_def_npq()時,p_key2的地方改成傳fat02
# Modify.........: No.FUN-710028 07/02/01 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-740033 07/04/11 By Carrier 會計科目加帳套-財務
# Modify.........: No.TQC-7B0072 07/11/13 By Rayven 增加多部門分攤的情況
# Modify.........: No.FUN-980003 09/08/10 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:MOD-B10042 11/01/07 By Dido npq04 需先清空
# Modify.........: No:FUN-AA0087 11/01/28 By Mengxw 異動碼類型改善
# Modify.........: No.FUN-AB0088 11/04/02 By chenying 因固資拆出財二功能，原本寫入fap亦有新增欄位，增加對應處理
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:FUN-B60140 11/09/07 By minpp "財簽二二次改善" 追單
# Modify.........: No:FUN-BA0112 11/11/07 By Sakura 財簽二5.25與5.1程式比對不一致修改
# Modify.........: No:MOD-BB0225 11/11/26 By johung 科目也要移轉時，應借新科目/貸舊科目
# Modify.........: No:MOD-BB0242 11/11/22 By Sarah npq05給值段若是判斷l_faj23與l_faj232的,請改判斷l_fat.fat09與l_fat.fat092
# Modify.........: No:FUN-C30313 12/04/18 By Sakura 原使用fahdmy3處理的地方加npptype判斷
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No:MOD-D40006 13/04/01 By Lori npq05取值邏輯調整統一如MOD-BB0242
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
#   DEFINE g_no	        LIKE type_file.chr20            #No.FUN-680070 VARCHAR(10)
   DEFINE g_no	        LIKE type_file.chr20    #No.FUN-550034          #No.FUN-680070 VARCHAR(16)
   DEFINE g_date        LIKE type_file.dat          #No.FUN-680070 DATE
   DEFINE g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
   DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(72)
   DEFINE g_bookno1     LIKE aza_file.aza81         #No.FUN-740033
   DEFINE g_bookno2     LIKE aza_file.aza82         #No.FUN-740033
   DEFINE g_bookno      LIKE aza_file.aza81         #No.FUN-740033
   DEFINE g_flag        LIKE type_file.chr1         #No.FUN-740033
   DEFINE g_npq25       LIKE npq_file.npq25         #FUN-9A0036
   DEFINE g_azi04_2     LIKE azi_file.azi04         #FUN-A40067
 
FUNCTION t102_gl(p_no,p_date,p_npptype)     #No.FUN-680028
#   DEFINE p_no    	LIKE type_file.chr20        #No.FUN-680070 VARCHAR(10)
   DEFINE p_no    	LIKE type_file.chr20   #No.FUN-550034       #No.FUN-680070 VARCHAR(16)
   DEFINE p_date  	LIKE type_file.dat           #No.FUN-680070 DATE
   DEFINE p_npptype     LIKE npp_file.npptype     #No.FUN-680028
   DEFINE l_buf		LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5         #No.FUN-680070 SMALLINT
#   DEFINE l_t1          LIKE type_file.chr3         #No.FUN-680070 VARCHAR(3)
   DEFINE l_t1          LIKE type_file.chr5     #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
   DEFINE l_fahdmy3     LIKE fah_file.fahdmy3
 
   WHENEVER ERROR CONTINUE
   LET g_no = p_no LET g_date = p_date 
   IF cl_null(g_no) THEN RETURN END IF
   IF p_npptype = "0" THEN    #FUN-B60140   Add
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
      CALL cl_err3("sel","fah_file",l_t1,"",SQLCA.sqlcode,"","sel fah",0)   #No.FUN-660136
   END IF
   #---->是否拋轉傳票
   IF l_fahdmy3 != 'Y' THEN RETURN END IF
   SELECT COUNT(*) INTO l_n FROM npq_file WHERE npq01 = g_no 
                                            AND npqsys = 'FA'
                                            AND npq00 = 2
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
                          AND npp00 = 2
                          AND npp011=1
                          AND npptype = p_npptype     #No.FUN-680028
   DELETE FROM npq_file WHERE npq01 = g_no
                          AND npqsys = 'FA'
                          AND npq00 = 2
                          AND npq011=1
                          AND npqtype = p_npptype     #No.FUN-680028
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_no
   #FUN-B40056--add--end--
   CALL s_t102(p_npptype)     #No.FUN-680028
   DELETE FROM npq_file WHERE npq01=g_no    AND npq03='-'
                          AND npqsys = 'FA' AND npq00 = 2
                          AND npq011=1
                          AND npqtype = p_npptype     #No.FUN-680028
   CALL t102_gen_diff() #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021   
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
   
FUNCTION s_t102(p_npptype)                 #No.FUN-680028
DEFINE p_npptype  LIKE npp_file.npptype    #No.FUN-680028 
DEFINE l_fbz10    LIKE fbz_file.fbz10,  
       l_fbz11    LIKE fbz_file.fbz11,  
       l_fbz12    LIKE fbz_file.fbz12,  
       l_fat      RECORD LIKE fat_file.*,
       l_faj23    LIKE faj_file.faj23,
       l_faj24    LIKE faj_file.faj24,
       l_faj53    LIKE faj_file.faj53,     #資產科目
       l_faj54    LIKE faj_file.faj54,     #累折科目
       l_faj531   LIKE faj_file.faj531,    #資產科目
       l_faj541   LIKE faj_file.faj541,    #累折科目
       l_faj32    LIKE faj_file.faj32,     #累折
       l_faj14    LIKE faj_file.faj14,     #成本
       l_faj141   LIKE faj_file.faj141,    #調整成本
       l_aag05    LIKE aag_file.aag05,     #No:7833
       l_aag051   LIKE aag_file.aag05,     #MOD-BB0242 add
       l_sql      LIKE type_file.chr1000   #No.FUN-680070 VARCHAR(600)
DEFINE l_aaa03    LIKE aaa_file.aaa03      #FUN-A40067
#FUN-AB0088---add---str---
DEFINE l_faj142   LIKE faj_file.faj142   
DEFINE l_faj1412  LIKE faj_file.faj1412 
DEFINE l_faj232   LIKE faj_file.faj232
DEFINE l_faj242   LIKE faj_file.faj242
DEFINE l_faj322   LIKE faj_file.faj322
#FUN-AB0088---add---end---
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   #-------------(單頭)-----------------------------------
   LET g_npp.nppsys = 'FA'        LET g_npp.npp00 = 2 
   LET g_npp.npp01  = g_no        LET g_npp.npp011= 1
   LET g_npp.npp02  = g_date      LET g_npp.npp03  = g_date
   LET g_npp.npptype = p_npptype     #No.FUN-680028
   LET g_npp.npplegal= g_legal       #FUN-980003 add
 
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
   #LET g_bookno2 = g_faa.faa02c #No:FUN-BA0112 mark 
   #FUN-AB0088---add---end---
 
   #-------------(單身)-----------------------------------
   LET g_npq.npqsys = 'FA'        LET g_npq.npq00 = 2 
   LET g_npq.npq01 = g_no         LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0            LET g_npq.npq04 = NULL        
   LET g_npq.npq21 = NULL         LET g_npq.npq22 = NULL 
   LET g_npq.npq24 = g_aza.aza17  LET g_npq.npq25 = 1          
   LET g_npq.npqtype = p_npptype     #No.FUN-680028
   LET g_npq.npqlegal = g_legal     #FUN-980003 add
   LET g_npq25 = g_npq.npq25        #FUN-9A0036
 
   #No.FUN-740033  --Begin
   IF g_npq.npqtype = '0' THEN
      LET g_bookno = g_bookno1
   ELSE
     # LET g_bookno = g_bookno2 #No:FUN-BA0112 mark
     #FUN-BA0112---add---str---
     #固資已不和二套掛鉤，所以原本利用s_get_bookno取到賬別一及賬別二是用是否使用二套賬來判斷
     #此處取賬別二要重新處理，應取固資參數欄位財二賬套faa02c作為賬別二的賬套
     LET g_bookno2 = g_faa.faa02c  
     #FUN-BA0112---add---end---      
     LET g_bookno = g_bookno2   #No.FUN-D40118   Add
   END IF
   #No.FUN-740033  --End  
 
   LET l_sql = "SELECT fat_file.*,",
               " faj23, faj24, faj53, faj531, faj54, faj541, faj32, faj14, faj141, ",     #No.FUN-680028
               " faj142,faj1412,faj232,faj242,faj322 ",    #FUN-AB0088 
               "  FROM fat_file LEFT OUTER JOIN faj_file ON fat03=faj02 AND fat031=faj022",
               " WHERE fat01 = '",g_no,"'"
   PREPARE t102_p FROM l_sql
   DECLARE t102_c CURSOR WITH HOLD FOR t102_p
   FOREACH t102_c INTO l_fat.*,
                  l_faj23,l_faj24,l_faj53,l_faj531,l_faj54,l_faj541,l_faj32,l_faj14,l_faj141,     #No.FUN-680028
                  l_faj142,l_faj1412,l_faj232,l_faj242,l_faj322    #FUN-AB0088
#No.FUN-710028 --begin                                                                                                              
      IF g_success='N' THEN                                                                                                         
         LET g_totsuccess='N'                                                                                                       
         LET g_success="Y"                                                                                                          
      END IF                                                                                                                        
#No.FUN-710028 --end
 
      IF SQLCA.sqlcode THEN
#No.FUN-710028 --begin
         IF g_bgerr THEN
            CALL s_errmsg('fat01',g_no,'t102_c',SQLCA.sqlcode,0) #No.FUN-710028
         ELSE
            CALL cl_err('t102_c',SQLCA.sqlcode,0)
         END IF
#No.FUN-710028 --end
         EXIT FOREACH 
      END IF
      IF cl_null(l_faj32) THEN LET l_faj32 = 0 END IF
      IF cl_null(l_faj322) THEN LET l_faj322 = 0 END IF   #FUN-AB0088   
#     IF l_faj23 = '1' THEN  #No.TQC-7B0072 mark
         #-------Dr.: 資產科目 (faj53)  +  轉入折舊部門 
         LET g_npq.npq02 = g_npq.npq02 + 1
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_faj53       #資產科目 
         IF g_npq.npqtype = '0' THEN
           #LET g_npq.npq03 = l_faj53       #資產科目    #MOD-BB0225 mark
            LET g_npq.npq03 = l_fat.fat07                #MOD-BB0225
         ELSE
           #LET g_npq.npq03 = l_faj531      #資產科目    #MOD-BB0225 mark
            LET g_npq.npq03 = l_fat.fat071               #MOD-BB0225
         END IF
         LET g_npq.npq04 = NULL             #MOD-B10042
         #No.FUN-680028 --end
         #No:7833
         IF g_npq.npqtype = '0' THEN    #MOD-BB0242 add
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno   #No.FUN-740033
            IF l_aag05='Y' THEN
           #IF g_npq.npqtype = '0' THEN    #FUN-AB0088    #MOD-BB0242 mark
              #IF l_faj23 = '1' THEN  #No.TQC-7B0072      #MOD-BB0242 mark
               IF l_fat.fat09 = '1' THEN  #No.TQC-7B0072  #MOD-BB0242
                  LET g_npq.npq05 =l_fat.fat10
               #No.TQC-7B0072 --start--
               ELSE
                  LET g_npq.npq05 = l_fat.fat05
               END IF
               #No.TQC-7B0072 --end--
        #str MOD-BB0242 add
            ELSE
               LET g_npq.npq05 = ' '
            END IF
         END IF
         IF g_npq.npqtype = '1' THEN
            #財簽二的科目是否做部門管理,應該要另外抓取,不應該共用財簽一科目部門管理的變數
            SELECT aag05 INTO l_aag051 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno2
            IF l_aag051='Y' THEN
        #end MOD-BB0242 add
         #FUN-AB0088---add---str---
           #ELSE   #MOD-BB0242 mark
              #IF l_faj232 = '1' THEN      #MOD-BB0242 mark
               IF l_fat.fat092 = '1' THEN  #MOD-BB0242
                  LET g_npq.npq05 =l_fat.fat102
               ELSE
                  LET g_npq.npq05 = l_fat.fat05
               END IF
           #END IF   #MOD-BB0242 mark
            #FUN-AB0088---add---end---
            ELSE
               LET g_npq.npq05 = ' '
            END IF
         END IF   #MOD-BB0242 add
         ##

         LET g_npq.npq06 = '1'           #借貸
         IF g_npq.npqtype = '0' THEN    #FUN-AB0088 
            LET g_npq.npq07f= l_faj14+l_faj141       #原幣金額 
            LET g_npq.npq07 = l_faj14+l_faj141       #本幣金額
         #FUN-AB0088---add---str---
         ELSE
             LET g_npq.npq07f= l_faj142+l_faj1412    
             LET g_npq.npq07 = l_faj142+l_faj1412     
         END IF
         #FUN-AB0088---add---end---
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fat.fat02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
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
#            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
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
#           CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
         IF g_bgerr THEN
            LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
            CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                #No.FUN-710028
         ELSE
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   #No.FUN-660136 
         END IF
#No.FUN-710028 --end
 
#           LET g_success='N' EXIT FOREACH      #no.5573 #No.FUN-710028
            LET g_success='N' CONTINUE FOREACH  #No.FUN-710028
         END IF
         #-------Dr.: 累折科目 (faj54)  +  轉入折舊部門 
         LET g_npq.npq02 = g_npq.npq02 + 1
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_faj54       #累折科目 
         IF g_npq.npqtype = '0' THEN
           #LET g_npq.npq03 = l_faj54       #MOD-BB0225 mark
            LET g_npq.npq03 = l_fat.fat08   #MOD-BB0225
         ELSE
           #LET g_npq.npq03 = l_faj541      #MOD-BB0225 mark
            LET g_npq.npq03 = l_fat.fat081  #MOD-BB0225
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         #No:7833
         IF g_npq.npqtype = '0' THEN    #MOD-BB0242 add
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno   #No.FUN-740033
            IF l_aag05='Y' THEN
           #IF g_npq.npqtype = '0' THEN    #FUN-AB0088   #MOD-BB0242 mark
              #LET g_npq.npq05 =l_faj24   #MOD-D40006 mark
               #MOD-D40006 add begin---
               IF l_fat.fat09 = '1' THEN
                  LET g_npq.npq05 = l_fat.fat10
               ELSE
                  LET g_npq.npq05 = l_fat.fat05
               END IF
               #MOD-D40006 add end-----
        #str MOD-BB0242 add
            ELSE
               LET g_npq.npq05 = ' '
            END IF
         END IF
         IF g_npq.npqtype = '1' THEN
            #財簽二的科目是否做部門管理,應該要另外抓取,不應該共用財簽一科目部門管理的變數
            SELECT aag05 INTO l_aag051 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno2
            IF l_aag051='Y' THEN
        #end MOD-BB0242 add
            #FUN-AB0088---add---str---
           #ELSE   #MOD-BB0242 mark
              #LET g_npq.npq05 =l_faj242   #MOD-D40006 mark
               #MOD-D40006 add begin---
               IF l_fat.fat092 = '1' THEN
                  LET g_npq.npq05 = l_fat.fat102
               ELSE
                  LET g_npq.npq05 = l_fat.fat05
               END IF
               #MOD-D40006 add end----- 
           #END IF   #MOD-BB0242 mark
            #FUN-AB0088---add---end--- 
            ELSE
               LET g_npq.npq05 = ' '
            END IF
            ##
         END IF   #MOD-BB0242 add
         LET g_npq.npq06 = '1'           #借貸 
         IF g_npq.npqtype = '0' THEN    #FUN-AB0088
            LET g_npq.npq07f= l_faj32       #原幣金額(累折) 
            LET g_npq.npq07 = l_faj32       #本幣金額(累折)  
         #FUN-AB0088---add---str---
         ELSE
            LET g_npq.npq07f= l_faj322  
            LET g_npq.npq07 = l_faj322  
         END IF
         #FUN-AB0088---add---end--- 
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fat.fat02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) 
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34   #FUN-AA0087
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
#            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
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
#           CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                #No.FUN-710028
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   #No.FUN-660136 
            END IF
#No.FUN-710028 --end
#           LET g_success='N' EXIT FOREACH      #no.5573 #No.FUN-710028
            LET g_success='N' CONTINUE FOREACH  #No.FUN-710028
         END IF
         LET g_npq.npq02 = g_npq.npq02 + 1
#     END IF #No.TQC-7B0072 mark 
      #-------Dr.: A/R 科目 (fbz10) -----------
      #-->單一部門分攤才給部門
#     IF l_faj23 = '1' THEN  #No.TQC-7B0072 mark
         #-------Cr.: 資產科目 (faj53) + 轉出折舊部門
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_faj53       #資產科目
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_faj53
         ELSE
            LET g_npq.npq03 = l_faj531
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         #No:7833
         IF g_npq.npqtype = '0' THEN    #MOD-BB0242 add
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno   #No.FUN-740033
            IF l_aag05='Y' THEN
           #IF g_npq.npqtype = '0' THEN    #FUN-AB0088   #MOD-BB0242 mark
              #LET g_npq.npq05 =l_faj24   #MOD-D40006 mark
               #MOD-D40006 add begin---
               IF l_fat.fat09 = '1' THEN
                  LET g_npq.npq05 = l_fat.fat10
               ELSE
                  LET g_npq.npq05 = l_fat.fat05
               END IF
               #MOD-D40006 add end-----
        #str MOD-BB0242 add
            ELSE
               LET g_npq.npq05 = ' '
            END IF
         END IF
         IF g_npq.npqtype = '1' THEN
            #財簽二的科目是否做部門管理,應該要另外抓取,不應該共用財簽一科目部門管理的變數
            SELECT aag05 INTO l_aag051 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno2
            IF l_aag051='Y' THEN
        #end MOD-BB0242 add
            #FUN-AB0088---add---str---
           #ELSE   #MOD-BB0242 mark
              #LET g_npq.npq05 =l_faj242   #MOD-D40006 mark
               #MOD-D40006 add begin---
               IF l_fat.fat092 = '1' THEN
                  LET g_npq.npq05 = l_fat.fat102
               ELSE
                  LET g_npq.npq05 = l_fat.fat05
               END IF
               #MOD-D40006 add end----- 
           #END IF   #MOD-BB0242 mark
            #FUN-AB0088---add---end---
            ELSE
               LET g_npq.npq05 = ' '
            END IF
            ##
         END IF   #MOD-BB0242 add
         LET g_npq.npq06 = '2'           #借貸
         IF g_npq.npqtype = '0' THEN    #FUN-AB0088          
            LET g_npq.npq07f= l_faj14+l_faj141 #原幣金額 
            LET g_npq.npq07 = l_faj14+l_faj141 #本幣金額
         #FUN-AB0088---add---str---
         ELSE
            LET g_npq.npq07f= l_faj142+l_faj1412
            LET g_npq.npq07 = l_faj142+l_faj1412
         END IF
         #FUN-AB0088---add---end--- 
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fat.fat02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
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
#            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
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
#           CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                #No.FUN-710028
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   #No.FUN-660136 
            END IF
#No.FUN-710028 --end
#           LET g_success='N' EXIT FOREACH      #no.5573 #No.FUN-710028
            LET g_success='N' CONTINUE FOREACH  #No.FUN-710028
         END IF
         LET g_npq.npq02 = g_npq.npq02 + 1
 
         #-------Dr.: 累折科目 (faj54)  +  轉出折舊部門 
         #No.FUN-680028 --begin
#        LET g_npq.npq03 = l_faj54       #累折科目 
         IF g_npq.npqtype = '0' THEN
            LET g_npq.npq03 = l_faj54
         ELSE
            LET g_npq.npq03 = l_faj541
         END IF
         #No.FUN-680028 --end
         LET g_npq.npq04 = NULL   #MOD-6C0140 add
         #No:7833
         IF g_npq.npqtype = '0' THEN    #MOD-BB0242 add
            SELECT aag05 INTO l_aag05 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno   #No.FUN-740033
            IF l_aag05='Y' THEN
           #IF g_npq.npqtype = '0' THEN    #FUN-AB0088    #MOD-BB0242 mark
              #IF l_faj23 = '1' THEN  #No.TQC-7B0072      #MOD-BB0242 mark
               IF l_fat.fat09 = '1' THEN  #No.TQC-7B0072  #MOD-BB0242
                  LET g_npq.npq05 =l_fat.fat10
               #No.TQC-7B0072 --start--
               ELSE
                  LET g_npq.npq05 = l_fat.fat05
               END IF
               #No.TQC-7B0072 --end--
        #str MOD-BB0242 add
            ELSE
               LET g_npq.npq05 = ' '
            END IF
         END IF
         IF g_npq.npqtype = '1' THEN
            #財簽二的科目是否做部門管理,應該要另外抓取,不應該共用財簽一科目部門管理的變數
            SELECT aag05 INTO l_aag051 FROM aag_file
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno2
            IF l_aag051='Y' THEN
        #end MOD-BB0242 add
            #FUN-AB0088---add---str---
           #ELSE   #MOD-BB0242 mark
             #IF l_faj232 = '1' THEN      #MOD-BB0242 mark
              IF l_fat.fat092 = '1' THEN  #MOD-BB0242
                 LET g_npq.npq05 = l_fat.fat102
              ELSE
                 LET g_npq.npq05 = l_fat.fat05
              END IF
           #END IF  #MOD-BB0242 mark
            #FUN-AB0088---add---end---
            ELSE
               LET g_npq.npq05 = ' '
            END IF
            ##
         END IF  #MOD-BB0242 add
         LET g_npq.npq06 = '2'           #借貸
         IF g_npq.npqtype = '0' THEN    #FUN-AB0088 
            LET g_npq.npq07f= l_faj32       #原幣金額(累折) 
            LET g_npq.npq07 = l_faj32       #本幣金額(累折)
         #FUN-AB0088---add---str---
         ELSE
            LET g_npq.npq07f= l_faj322     
            LET g_npq.npq07 = l_faj322  
         END IF
         #FUN-AB0088---add---end---
         LET g_npq.npq23 = ' ' 
         MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
         #NO.FUN-5C0015 ---start
        #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,l_fat.fat02,'',g_bookno)   #MOD-6C0140  #No.FUN-740033
         RETURNING g_npq.*
         CALL s_def_npq31_npq34(g_npq.*,g_bookno) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
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
#            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)   #FUN-A40067
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
#           CALL cl_err('ins npq#1',STATUS,1)    #No.FUN-660136
#No.FUN-710028 -begin
            IF g_bgerr THEN
               LET g_showmsg = g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq. npqsys,"/",g_npq.npq00  #No.FUN-710028
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)                #No.FUN-710028
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq#1",1)   #No.FUN-660136 
            END IF
#No.FUN-710028 --end
#           LET g_success='N' EXIT FOREACH      #no.5573 #No.FUN-710028
            LET g_success='N' CONTINUE FOREACH  #No.FUN-710028
         END IF
#     END IF  #No.TQC-7B0072 mark
   END FOREACH
#No.FUN-710028 --begin                                                                                                              
   IF g_totsuccess="N" THEN                                                                                                        
      LET g_success="N"                                                                                                            
   END IF                                                                                                                          
#No.FUN-710028 -end
 
END FUNCTION
#FUN-A40033 --Begin
FUNCTION t102_gen_diff()
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
         #FUN-D10065--add---str
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
               CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#1', STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq1.npq01,l_npq1.npq02,SQLCA.sqlcode,"","ins npq#1",1)
            END IF
               LET g_success='N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
#FUN-AA0087

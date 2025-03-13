# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify ........: No.FUN-590109 05/09/23 By Elva 新增紅衝功能
# Modify.........: No.MOD-5A0249 05/10/24 By Smapmin 貸方科目應該是nms22(應收票據),而非nms15(應付票據)
# Modify.........: NO.FUN-5A0088 06/01/05 BY yiting 新增異動別為託收時的處理
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: NO.FUN-650072 06/05/12 BY elva 沒有建單頭科目時，以基本資料為主
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-6C0140 06/12/25 By Sarah s_def_npq()時,p_key2的地方改成傳npo02
# Modify.........: No.FUN-710024 07/02/01 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-730032 07/04/05 By Ray 新增帳套
# Modify.........: No.FUN-750141 07/05/30 By kim 增加對"票貼"的處理方式
# Modify.........: No.TQC-790177 07/09/29 By Carrier 去掉全型字符
# Modify.........: No.MOD-840051 08/04/08 By Carol npq04不給固定值
# Modify.........: No.MOD-8B0033 08/11/07 By Sarah 當npn03='4'時,借方科目預設nms25/nms251,貸方科目預設為nms22/nms221
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善 
# Modify.........: No:FUN-B40056 11/05/13 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-C20090 12/02/08 By Dido 若差異匯率為1不可認定為匯差科目,需自行定義 
# Modify.........: No:FUN-C80083 12/09/07 By minpp 产生分录底稿，借方抓托收银行对应的科目anmi030，手续费抓nms25,汇损抓nms13,
#..................................................贷方抓应收票据科目nmh26,为空抓nms22,汇盈抓nms12
# Modify.........: No:FUN-CA0083 12/10/11 By xuxz 轉付退票時npq21，npq22給npn14
# Modify.........: No:MOD-CA0107 12/10/18 By Polly 錯誤訊息的顯示調整為匯總方式
# Modify.........: No.FUN-D10065 13/01/16 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/22 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_npn		RECORD LIKE npn_file.*
   DEFINE g_npo		RECORD LIKE npo_file.*
   DEFINE g_nms		RECORD LIKE nms_file.*
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_nmh		RECORD LIKE nmh_file.*
   DEFINE g_trno	LIKE npn_file.npn01
   DEFINE g_nmydmy5     LIKE nmy_file.nmydmy5  #FUN-590109
   DEFINE g_t1          LIKE nmy_file.nmyslip  #FUN-590109
   DEFINE g_flag        LIKE type_file.chr1    #No.FUN-730032
   DEFINE g_bookno1     LIKE aza_file.aza81    #No.FUN-730032
   DEFINE g_bookno2     LIKE aza_file.aza82    #No.FUN-730032
   DEFINE g_bookno3     LIKE aza_file.aza82    #No.FUN-730032
   DEFINE g_npq25       LIKE npq_file.npq25    #No.FUN-9A0036
   DEFINE g_azi04_2     LIKE azi_file.azi04    #FUN-A40067
 
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
FUNCTION s_t250_gl(p_trno,p_npptype)           # No.FUN-680034   
   DEFINE p_npptype     LIKE npp_file.npptype  # No.FUN-680034	
   DEFINE p_trno	LIKE npn_file.npn01
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-680107 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_trno = p_trno
   IF g_trno IS NULL THEN RETURN END IF
   #modify by danny 97/05/14 若已拋轉總帳, 不可重新產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file 
    WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_trno AND npp011=g_npn.npn03
      AND nppglno != '' AND nppglno IS NOT NULL
   IF l_n > 0 THEN 
      #-----No.FUN-710024  --begin
      IF g_bgerr THEN
         LET g_showmsg=g_trno,"/",g_npn.npn03
         CALL s_errmsg('npp01,npp011',g_showmsg,p_trno,'aap-122',1)
         RETURN
      ELSE
         CALL cl_err(p_trno,'aap-122',1) RETURN 
      END IF
      #-----No.FUN-710024  --end
      LET g_success = 'N'                          # No.FUN-680034
   END IF
   SELECT npn_file.* INTO g_npn.* FROM npn_file WHERE npn01 = g_trno 
   IF STATUS THEN 
#     CALL cl_err('sel npn',STATUS,1) FUN-660148
      #-----No.FUN-710024  --begin
      IF g_bgerr THEN
         CALL s_errmsg('npn01',g_trno,'sel npn','aap-122',0)
      ELSE
         CALL cl_err3("sel","npn_file",g_trno,"",STATUS,"","sel npn",1) #FUN-660148
      END IF
      #-----No.FUN-710024  --end
   END IF
   IF g_npn.npnconf = 'X' THEN 
      #-----No.FUN-710024  --begin
      IF g_bgerr THEN
         CALL s_errmsg('','','void:','9024',0) RETURN
      ELSE
         CALL cl_err('void:','9024',0) RETURN
      END IF
      #-----No.FUN-710024  --end
   END IF
   SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
   DELETE FROM npp_file 
        WHERE nppsys= 'NM' AND npp00=2 AND npp01 = g_trno AND npp011=g_npn.npn03 AND npptype=p_npptype  # No.FUN-680034 
   DELETE FROM npq_file 
        WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_trno AND npq011=g_npn.npn03 AND npqtype=p_npptype  # No.FUN-680034 
   DELETE FROM tic_file WHERE tic04 = g_trno #FUN-B40056

   CALL s_t250_gl_11(p_npptype)                   # No.FUN-680034  add  p_npptype
   #FUN-590109  --begin
   IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
      CALL s_t250_gl_resort(p_npptype)  #項次重排  
   END IF
   #FUN-590109  --end
   CALL s_t250_diff()                   #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021 
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION s_t250_gl_11(p_npptype)              # No.FUN-680034  add  p_npptype
   DEFINE p_npptype  LIKE npp_file.npptype    # No.FUN-680034  
#   DEFINE p_npqtype  LIKE npq_file.npqtype    # No.FUN-680034  
   LET g_npp.npptype=p_npptype                # No.FUN-680034         
   LET g_npq.npqtype=p_npptype                # No.FUN-680034 
   LET g_npp.nppsys = 'NM'
   LET g_npp.npp00 = 2
   LET g_npp.npp01 = g_npn.npn01
   LET g_npp.npp011 =  g_npn.npn03
   LET g_npp.npp02 = g_npn.npn02
   LET g_npp.npp03 = NULL
 
   #FUN-980005 add legal 
   LET g_npp.npplegal= g_legal
   #FUN-980005 end legal 
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN 
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660148
      #-----No.FUN-710024  --begin
      IF g_bgerr THEN
         LET g_showmsg=g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00
         CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',STATUS,1) 
      ELSE
         CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp",1) #No.FUN-660148
      END IF
      #-----No.FUN-710024  --end
      LET g_success='N' #no.5573
   END IF
 
   LET g_npq.npqsys = 'NM' 
   LET g_npq.npq00 = 2
   LET g_npq.npq01 = g_npn.npn01
   LET g_npq.npq011 = g_npn.npn03
   LET g_npq.npq02 = 0
   LET g_npq.npq24 = g_npn.npn04 
   LET g_npq.npq25 = g_npn.npn05
   LET g_npq25     = g_npq.npq25      #No.FUN-9A0036
# No.FUN-680034 --start-- 
#   CALL s_t250_gl_a()       # 借、貸方產生
   CALL s_t250_gl_a(p_npptype)
# No.FUN-680034 ---end---   
END FUNCTION
 
FUNCTION s_t250_gl_a(p_npptype)            # No.FUN-680034  add  p_npptype    
#DEFINE l_oma24    LIKE oma_file.oma24
 DEFINE l_aag05    LIKE aag_file.aag05
 DEFINE p_npptype  LIKE npp_file.npptype   # No.FUN-680034   
 DEFINE l_aaa03    LIKE aaa_file.aaa03     #FUN-A40067
 DEFINE l_nms25    LIKE nms_file.nms25     #FUN-C80083
 DEFINE l_nmh15    LIKE nmh_file.nmh15     #FUN-C80083
 DEFINE l_npo09    LIKE npo_file.npo09     #FUN-C80083
 DEFINE l_npo10    LIKE npo_file.npo10     #FUN-C80083
 DEFINE p_npq      RECORD LIKE npq_file.*  #FUN-C80083
 DEFINE l_i        LIKE type_file.num5     #FUN-C80083
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   DROP TABLE X                                      #FUN-C80083
   SELECT * FROM npq_file where 1=2 INTO TEMP X      #FUN-C80083  
   DECLARE s_t250_gl_c3 CURSOR FOR
        SELECT * FROM npo_file WHERE npo01=g_npn.npn01 
   FOREACH s_t250_gl_c3 INTO g_npo.*
     IF STATUS THEN EXIT FOREACH END IF
#No.FUN-710024  --begin
           IF g_success='N' THEN                                                                                                          
              LET g_totsuccess='N'                                                                                                       
              LET g_success="Y"                                                                                                          
           END IF             
#No.FUN-710024  --end        
           SELECT * INTO g_nmh.* FROM nmh_file 
            WHERE nmh01=g_npo.npo03 AND nmh38 <> 'X'
           IF STATUS THEN INITIALIZE g_nmh.* TO NULL END IF
           LET g_npq.npq02 = g_npq.npq02 + 1
           LET g_npq.npq21 = g_nmh.nmh11 
           LET g_npq.npq22 = g_nmh.nmh30 
           #FUN-CA0083--add--str
           IF g_npn.npn03 = '9' OR g_npn.npn03 = '5'  THEN 
              LET g_npq.npq21 = g_npn.npn14
              SELECT pmc03 INTO g_npq.npq22
               FROM pmc_file WHERE pmc01 = g_npn.npn14
              IF cl_null(g_npq.npq22) THEN
                 SELECT occ02 INTO g_npq.npq22
                   FROM occ_file WHERE occ01=g_npn.npn14
                 IF cl_null(g_npq.npq22) THEN
                    LET g_npq.npq22 = ' '
                 END IF 
              END IF 
           END IF 
           #FUN-CA0083--add--end
           #借方科目產生
           #FUN-590109  --begin
           LET g_t1 = s_get_doc_no(g_trno)                                              
           SELECT nmydmy5 INTO g_nmydmy5 FROM nmy_file WHERE nmyslip = g_t1 
           IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
              LET g_npq.npq06 = '2'
              CALL s_npq03_c_def(p_npptype)      # No.FUN-680034  add  p_npptype
           ELSE 
              LET g_npq.npq06 = '1'
              CALL s_npq03_d_def(p_npptype)      # No.FUN-680034  add  p_npptype
           END IF
           #FUN-590109  --end
           #FUN-CA0083--add--str
           IF g_npq.npq06 = '2' AND g_npn.npn03 = '5' THEN 
              LET g_npq.npq21 = g_nmh.nmh11
              LET g_npq.npq22 = g_nmh.nmh30
           END IF 
           #FUN-CA0083--add--end
           LET g_npq.npq07f = g_npo.npo04
           LET g_npq.npq25 = g_npn.npn05  
           LET g_npq25     = g_npq.npq25      #No.FUN-9A0036
           LET g_npq.npq07 = g_npo.npo06 
           LET g_npq.npq24 = g_npn.npn04 
           #LET g_npq.npq04 = g_npn.npn08  #FUN-D10065 mark
           LET g_npq.npq04 = NULL          #FUN-D10065 add
           MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
           IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
           #FUN-590109  --begin
           IF g_aza.aza26='2' THEN
              IF g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                 LET g_npq.npq07 = (-1)*g_npq.npq07                                  
                 LET g_npq.npq07f= (-1)*g_npq.npq07f                                 
              END IF  
           END IF  
           #FUN-590109  --end
           #No.FUN-730032 --begin
           CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
           IF g_flag = '1' THEN
              IF g_bgerr THEN                                                     #MOD-CA0107 add
                 CALL s_errmsg('aza81,aza82','','','aoo-081',1)                   #MOD-CA0107 add
              ELSE                                                                #MOD-CA0107 add
                #CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)                       #MOD-CA0107 mark
                 CALL cl_err('aza81,aza82','aoo-081',1)                           #MOD-CA0107 add
              END IF                                                              #MOD-CA0107 add
              LET g_success = 'N'
           END IF
           IF g_npq.npqtype = '0' THEN
              LET g_bookno3 = g_bookno1
           ELSE
              LET g_bookno3 = g_bookno2
           END IF
           #No.FUN-730032 --end
           # NO.FUN-5C0015 --start--
          #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
#          CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npo.npo02,'')   #MOD-6C0140       #No.FUN-730032
           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npo.npo02,'',g_bookno3)   #MOD-6C0140       #No.FUN-730032
            RETURNING  g_npq.*
           #FUN-D10065--add--str--
           IF cl_null(g_npq.npq04) THEN
              LET g_npq.npq04 = g_npn.npn08
           END IF
           #FUN-D10065--add--end
           CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
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
              LET g_npq.npq07 = g_npq.npq07 - g_npo.npo09                      #FUN-C80083
              LET g_npq.npq07f = g_npq.npq07f - g_npo.npo10                    #FUN-C80083
              LET g_npq.npq07f = cl_digcut(g_npq.npq07f,t_azi04)               #FUN-C80083
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
           ELSE
              #FUN-C80083--ADD--STR
              LET g_npq.npq07 = g_npq.npq07 - g_npo.npo09
              LET g_npq.npq07f = g_npq.npq07f-g_npo.npo10
              LET g_npq.npq07f = cl_digcut(g_npq.npq07f,g_azi04)
              #FUN-C80083--ADD--end
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
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
          #INSERT INTO npq_file VALUES (g_npq.*)   #FUN-C80083
           INSERT INTO X  VALUES (g_npq.*)         #FUN-C80083
           IF STATUS THEN 
#            #CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
              IF g_bgerr THEN                                                                                    #MOD-CA0107 add
                 LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00     #MOD-CA0107 add
                 CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9',STATUS,1)                 #MOD-CA0107 add
              ELSE                                                                                               #MOD-CA0107 add
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1)                  #No.FUN-660148
              END IF                                                                                             #MOD-CA0107 add
              LET g_success='N' #no.5573
           END IF
 
           #貸方科目產生
           LET g_npq.npq02 = g_npq.npq02 + 1
           #FUN-590109  --begin
           IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
              LET g_npq.npq06 = '1'
              CALL s_npq03_d_def(p_npptype)       # No.FUN-680034  add  p_npptype
           ELSE 
              LET g_npq.npq06 = '2'
              CALL s_npq03_c_def(p_npptype)       # No.FUN-680034  add  p_npptype
           END IF
           #FUN-590109  --end
           #FUN-CA0083--add--str
           IF g_npq.npq06 = '2' AND g_npn.npn03 = '5' THEN
              LET g_npq.npq21 = g_nmh.nmh11
              LET g_npq.npq22 = g_nmh.nmh30
           END IF
           #FUN-CA0083--add--end
           LET g_npq.npq07f = g_npo.npo04
           LET g_npq.npq25 = g_nmh.nmh28 
           LET g_npq25     = g_npq.npq25      #No.FUN-9A0036
           LET g_npq.npq07 = g_npo.npo05 
           LET g_npq.npq24 = g_npn.npn04 
           #LET g_npq.npq04 = g_npn.npn08   #FUN-D10065 mark
           LET g_npq.npq04 = NULL           #FUN-D10065 add
           MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
           IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
           #FUN-590109  --begin
           IF g_aza.aza26='2' THEN
              IF g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                 LET g_npq.npq07 = (-1)*g_npq.npq07                                  
                 LET g_npq.npq07f= (-1)*g_npq.npq07f                                 
              END IF  
           END IF  
           #FUN-590109  --end
           # NO.FUN-5C0015 --start--
          #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
#          CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npo.npo02,'')   #MOD-6C0140       #No.FUN-730032
           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npo.npo02,'',g_bookno3)   #MOD-6C0140       #No.FUN-730032
            RETURNING  g_npq.*
          #FUN-D10065--add--str--
          IF cl_null(g_npq.npq04) THEN
             LET g_npq.npq04 = g_npn.npn08
          END IF
          #FUN-D10065--add--end
           
           CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
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
#             LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
           ELSE
              LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
           END IF
#No.FUN-9A0036 --End
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
          #INSERT INTO npq_file VALUES (g_npq.*)    #FUN-C80083
           INSERT INTO X  VALUES (g_npq.*)         #FUN-C80083
           IF STATUS THEN 
#             CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
           #-----No.FUN-710024  --begin
              IF g_bgerr THEN
                 LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00
                 CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#9',STATUS,1)
              ELSE
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
              END IF
           #-----No.FUN-710024  --end
              LET g_success='N' #no.5573
           END IF
 
           #匯差產生
           LET g_npq.npq07 = g_npo.npo06  - g_npo.npo05
           IF g_npq.npq25 <> 1 THEN          #MOD-C20090
              LET g_npq.npq24 = g_aza.aza17  #MOD-C20090
              LET g_npq.npq25 = 1            #MOD-C20090
              LET g_npq.npq07f = 0           #MOD-C20090
              #FUN-590109  --begin
              IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                 IF g_npq.npq07 > 0 THEN 
                    LET g_npq.npq06 = '1'
                    LET g_npq.npq03 = g_nms.nms13
                    LET g_npq.npq07 = -1 * g_npq.npq07
                 ELSE
                    LET g_npq.npq06 = '2'
                    LET g_npq.npq03 = g_nms.nms12
                 END IF
              ELSE
                 IF g_npq.npq07 > 0 THEN 
                    LET g_npq.npq06 = '2'
                    LET g_npq.npq03 = g_nms.nms12
                 ELSE
                    LET g_npq.npq06 = '1'
                    LET g_npq.npq03 = g_nms.nms13
                    LET g_npq.npq07 = -1 * g_npq.npq07
                 END IF
              END IF
              #FUN-590109  --end
          #-MOD-C20090-add-
           ELSE
              LET g_npq.npq03 = '' 
              LET g_npq.npq07f = g_npq.npq07
           END IF   
          #-MOD-C20090-end-
           #No.FUN-730032 --begin
           CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
           IF g_flag = '1' THEN
              IF g_bgerr THEN                                                     #MOD-CA0107 add
                 CALL s_errmsg('aza81,aza82','','','aoo-081',1)                   #MOD-CA0107 add
              ELSE                                                                #MOD-CA0107 add
                #CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)                       #MOD-CA0107 mark
                 CALL cl_err('aza81,aza82','aoo-081',1)                           #MOD-CA0107 add
              END IF                                                              #MOD-CA0107 add
           END IF
           IF g_npq.npqtype ='0' THEN
              LET g_bookno3 = g_bookno1
           ELSE
              LET g_bookno3 = g_bookno2
           END IF
           #No.FUN-730032 --end
            LET l_aag05 = NULL
            SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                      AND aag00 = g_bookno3       #No.FUN-730032
            IF l_aag05='Y' THEN
               LET g_npq.npq05 = g_nmh.nmh15 
            ELSE
               LET g_npq.npq05 = ''
            END IF
          #LET g_npq.npq07f = 0   #MOD-C20090 mark
          #LET g_npq.npq04 = g_npn.npn08 #MOD-840051-modify #FUN-D10065 mark
           LET g_npq.npq04 = NULL        #FUN-D10065
           MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
           IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
           IF g_npq.npq07<>0 OR g_npq.npq07f<>0 THEN
              LET g_npq.npq02 = g_npq.npq02 + 1
              # NO.FUN-5C0015 --start--
             #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #MOD-6C0140 mark
#             CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npo.npo02,'')   #MOD-6C0140       #No.FUN-730032
              CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npo.npo02,'',g_bookno3)   #MOD-6C0140       #No.FUN-730032
               RETURNING  g_npq.*
              #FUN-D10065--add--str--
              IF cl_null(g_npq.npq04) THEN
                 LET g_npq.npq04 = g_npn.npn08
              END IF
              #FUN-D10065--add--end
               
              CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34  #FUN-AA0087
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
#                LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
                 LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
              ELSE
                 LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
              END IF
#No.FUN-9A0036 --End
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
             #INSERT INTO npq_file VALUES (g_npq.*)   #FUN-C80083
              INSERT INTO X  VALUES (g_npq.*)         #FUN-C80083
              IF STATUS THEN 
#                CALL cl_err('ins npq#10',STATUS,1)    #No.FUN-660148
           #-----No.FUN-710024  --begin
              IF g_bgerr THEN
                 LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00
                 CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#10',STATUS,1)
              ELSE
                 CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#10",1) #No.FUN-660148
              END IF
           #-----No.FUN-710024  --end
                 LET g_success='N' #no.5573
              END IF
           END IF
           #FUN-C80083---ADD---STR
           #手续费
           SELECT npo09,npo10 INTO l_npo09,l_npo10 FROM npo_file WHERE npo03= g_npo.npo03
           IF l_npo09 <> 0 THEN
              LET g_npq.npq07 = l_npo09
              LET g_npq.npq07f = l_npo10
              LET g_npq.npq24 = g_npn.npn04
              LET g_npq.npq25 = g_npn.npn05
              SELECT nmh15 INTO l_nmh15 FROM nmh_file WHERE nmh01 = g_npo.npo03
              SELECT nms25 INTO l_nms25 FROM nms_file WHERE nms01 = l_nmh15     #科目
              LET g_npq.npq03 = l_nms25
              IF cl_null(g_npq.npq03) THEN LET g_npq.npq03=g_nms.nms25 END IF
              LET g_npq.npq06 = '1'
              CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
              IF g_flag = '1' THEN
                 IF g_bgerr THEN                                                     #MOD-CA0107 add
                    CALL s_errmsg('aza81,aza82','','','aoo-081',1)                   #MOD-CA0107 add
                 ELSE                                                                #MOD-CA0107 add
                   #CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)                       #MOD-CA0107 mark
                    CALL cl_err('aza81,aza82','aoo-081',1)                           #MOD-CA0107 add
                 END IF                                                              #MOD-CA0107 add
              END IF
              IF g_npq.npqtype ='0' THEN
                 LET g_bookno3 = g_bookno1
              ELSE
                 LET g_bookno3 = g_bookno2
              END IF
              LET l_aag05 = NULL
              SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                                        AND aag00 = g_bookno3
              IF l_aag05='Y' THEN
                 LET g_npq.npq05 = g_nmh.nmh15
              ELSE
                 LET g_npq.npq05 = ''
              END IF
           #LET g_npq.npq04 = g_npn.npn08  #FUN-D10065 mark
           LET g_npq.npq04 = NULL          #FUN-D10065 add
              MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
              IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
              IF g_npq.npq07<>0 OR g_npq.npq07f<>0 THEN
                 LET g_npq.npq02 = g_npq.npq02 + 1
                 CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npo.npo02,'',g_bookno3)
                 RETURNING  g_npq.*      
           #FUN-D10065--add--str--
           IF cl_null(g_npq.npq04) THEN
              LET g_npq.npq04 = g_npn.npn08
           END IF
           #FUN-D10065--add--end
                 CALL s_def_npq31_npq34(g_npq.*,g_bookno3) RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34
                 LET g_npq.npqlegal= g_legal
                 IF p_npptype = '1' THEN
                    SELECT aaa03 INTO l_aaa03 FROM aaa_file
                     WHERE aaa01 = g_bookno2
                    SELECT azi04 INTO t_azi04 FROM azi_file
                     WHERE azi01 = l_aaa03
                    CALL s_newrate(g_bookno1,g_bookno2,
                                   g_npq.npq24,g_npq.npq25,g_npp.npp02)
                    RETURNING g_npq.npq25
                    LET g_npq.npq07 = g_npq.npq07f * g_npq25
                    LET g_npq.npq07 = cl_digcut(g_npq.npq07,t_azi04)
                 ELSE
                    LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)
                 END IF
                 INSERT INTO X  VALUES (g_npq.*)
                 IF STATUS THEN
                    IF g_bgerr THEN
                       LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq02,"/",g_npq.npqsys,"/",g_npq.npq00
                       CALL s_errmsg('npq01,npq011,npq02,npqsys,npq00',g_showmsg,'ins npq#10',STATUS,1)
                    ELSE
                       CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#10",1)
                    END IF
                 END IF
              END IF
           END IF
    #FUN-C80083--ADD--END   
   END FOREACH
   #FUN-C80083---ADD---STR
   LET p_npq.npq02=1
   DECLARE t250_temp_curs CURSOR FOR
   SELECT npqsys,npq00,npq01,npq011,'',npq03,npq04,npq05,npq06,
  #SUM(npq07f) npq07f,SUM(npq07) npq07,'','','','','','',npq21,#FUN-CA0083 mark
   SUM(npq07f) npq07f,SUM(npq07) npq07,npq08,npq11,npq12,npq13,npq14,npq15,npq21,#FUN-CA0083 add
   npq22,'',npq24,npq25,'','','','','','','','','','',
   '','','',npqtype,npqlegal
   FROM X
   GROUP BY npqsys,npq00,npq01,npq011,npq03,npq04,npq05,npq06,
            npq08,npq11,npq12,npq13,npq14,npq15, #FUN-CA0083 add
   npq21,npq22,npq24,npq25,npqtype,npqlegal
   ORDER BY npq06

   LET l_i=1
   FOREACH t250_temp_curs INTO p_npq.*
      LET p_npq.npq02=l_i
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
      INSERT INTO npq_file VALUES(p_npq.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('npq_file','insert',g_npo.npo01,SQLCA.sqlcode,1)
         LET g_totsuccess="N"
         EXIT FOREACH
      END IF
      LET l_i=l_i+1
   END FOREACH

   #FUN-C80083---ADD---END
#No.FUN-710024  --begin
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
#No.FUN-710024  --end  
END FUNCTION
   
FUNCTION s_npq03_d_def(p_npptype)    #借方會計科目default 
 DEFINE l_aag05    LIKE aag_file.aag05
 DEFINE p_npptype  LIKE npp_file.npptype   # No.FUN-680034 
# No.FUN-680034 --start--
 IF p_npptype = '0' THEN  
  IF g_npn.npn03='8' OR g_npn.npn03='4' THEN  #兌現抓銀行檔科目  #FUN-C80083 add 4
     SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmh.nmh21
     IF STATUS THEN LET g_npq.npq03 = '-' END IF
  ELSE
     IF NOT cl_null(g_npn.npn06) THEN LET g_npq.npq03 = g_npn.npn06 
     ELSE
        CASE
           WHEN g_npn.npn03='1'  LET g_npq.npq03 = g_nmh.nmh26 #收票 
           #NO.FUN-5A0088 START--
           WHEN g_npn.npn03='2'  LET g_npq.npq03 = g_nms.nms23 #托收
           #NO.FUN-5A0088 END----
           WHEN g_npn.npn03='3'  LET g_npq.npq03 = g_nms.nms24 #質押 
          #WHEN g_npn.npn03='4'  LET g_npq.npq03 = g_nms.nms25 #票貼 #FUN-750141  #FUN-C80083
           #FUN-590109  --begin
           WHEN g_npn.npn03='6'  
                IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                   LET g_npq.npq03 = g_nmh.nmh26 #撤票 
                ELSE
                   LET g_npq.npq03 = g_nms.nms27 #撤票 
                END IF
           WHEN g_npn.npn03='7'  #LET g_npq.npq03 = g_nms.nms26 #退票 
                IF g_aza.aza26!='2' OR g_nmydmy5!='Y' OR g_npn.npn03 NOT MATCHES '[67]' THEN
                   LET g_npq.npq03 = g_nms.nms26 #退票 
                END IF
                #FUN-650072  --begin
                IF g_aza.aza26 ='2' AND g_nmydmy5 ='Y' THEN
                   IF g_npo.npo07='8' THEN  #原票況為'8'
                      SELECT nma05 INTO g_npq.npq03 
                        FROM nma_file WHERE nma01=g_nmh.nmh21
                      IF STATUS THEN LET g_npq.npq03 = '-' END IF
                   ELSE 
                      LET g_npq.npq03 = g_nmh.nmh26 
                   END IF
                END IF
                #FUN-650072  --end
           #FUN-590109  --end
        END CASE
     END IF
  END IF
 ELSE
   IF g_npn.npn03='8' OR g_npn.npn03='4' THEN  #兌現抓銀行檔科目  #FUN-C80083 add 4
     SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmh.nmh21
     IF STATUS THEN LET g_npq.npq03 = '-' END IF
  ELSE
     IF NOT cl_null(g_npn.npn061) THEN LET g_npq.npq03 = g_npn.npn061 
     ELSE
        CASE
           WHEN g_npn.npn03='1'  LET g_npq.npq03 = g_nmh.nmh261 #收票 
           #NO.FUN-5A0088 START--
           WHEN g_npn.npn03='2'  LET g_npq.npq03 = g_nms.nms231 #托收
           #NO.FUN-5A0088 END----
           WHEN g_npn.npn03='3'  LET g_npq.npq03 = g_nms.nms241 #質押 
           #WHEN g_npn.npn03='4'  LET g_npq.npq03 = g_nms.nms251 #票貼 #MOD-8B0033 add    #FUN-C80083
           #FUN-590109  --begin
           WHEN g_npn.npn03='6'  
                IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                   LET g_npq.npq03 = g_nmh.nmh261 #撤票 
                ELSE
                   LET g_npq.npq03 = g_nms.nms271 #撤票 
                END IF
           WHEN g_npn.npn03='7'  #LET g_npq.npq03 = g_nms.nms26 #退票 
                IF g_aza.aza26!='2' OR g_nmydmy5!='Y' OR g_npn.npn03 NOT MATCHES '[67]' THEN
                   LET g_npq.npq03 = g_nms.nms261 #退票 
                END IF
                #FUN-650072  --begin
                IF g_aza.aza26 ='2' AND g_nmydmy5 ='Y' THEN
                   IF g_npo.npo07='8' THEN  #原票況為'8'
                      SELECT nma051 INTO g_npq.npq03 
                        FROM nma_file WHERE nma01=g_nmh.nmh21
                      IF STATUS THEN LET g_npq.npq03 = '-' END IF
                   ELSE 
                      LET g_npq.npq03 = g_nmh.nmh261 
                   END IF
                END IF
                #FUN-650072  --end
           #FUN-590109  --end
        END CASE
     END IF
  END IF
 END IF 
# No.FUN-680034 ---end---	 
   #No.FUN-730032 --begin
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      IF g_bgerr THEN                                                     #MOD-CA0107 add
         CALL s_errmsg('aza81,aza82','','','aoo-081',1)                   #MOD-CA0107 add
      ELSE                                                                #MOD-CA0107 add
        #CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)                       #MOD-CA0107 mark
         CALL cl_err('aza81,aza82','aoo-081',1)                           #MOD-CA0107 add
      END IF                                                              #MOD-CA0107 add
   END IF
   IF g_npq.npqtype ='0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   #No.FUN-730032 --end
   LET l_aag05 = NULL
   SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                             AND aag00 = g_bookno3       #No.FUN-730032
   IF l_aag05='Y' THEN
      LET g_npq.npq05 = g_nmh.nmh15 
   ELSE
      LET g_npq.npq05 = ''
   END IF
END FUNCTION
   
FUNCTION s_npq03_c_def(p_npptype)    #貸方會計科目default 
 DEFINE l_aag05    LIKE aag_file.aag05
 DEFINE p_npptype  LIKE npp_file.npptype   # No.FUN-680034 
# No.FUN-680034 --start--
 IF p_npptype = '0' THEN 
  IF g_npn.npn03='7' THEN #退票
     #FUN-650072  --begin
     IF g_aza.aza26!='2' OR g_nmydmy5='N' THEN
        IF g_npo.npo07='8' THEN  #原票況為'8'
           SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmh.nmh21
           IF STATUS THEN LET g_npq.npq03 = '-' END IF
        ELSE
           LET g_npq.npq03 = g_nmh.nmh26 
        END IF
     ELSE
        LET g_npq.npq03 = g_nms.nms26 #退票                          
     END IF
     #FUN-650072  --end
  ELSE
     IF NOT cl_null(g_npn.npn07) THEN LET g_npq.npq03=g_npn.npn07
     ELSE
        CASE
          WHEN g_npn.npn03='1'  LET g_npq.npq03 = g_nmh.nmh27 #收票 
          #NO.FUN-5A0088 START--
          WHEN g_npn.npn03='2'  LET g_npq.npq03 = g_nms.nms22 #托收貸方
          #NO.FUN-5A0088 END----
#         WHEN g_npn.npn03='3'  LET g_npq.npq03 = g_nms.nms15 #質押  #MOD-5A0249
          WHEN g_npn.npn03='3'  LET g_npq.npq03 = g_nms.nms22 #質押  #MOD-5A0249
         #WHEN g_npn.npn03='4'  LET g_npq.npq03 = g_nmh.nmh26 #票貼  #FUN-750141   #MOD-8B0033 mark
         #WHEN g_npn.npn03='4'  LET g_npq.npq03 = g_nms.nms22 #票貼  #FUN-750141   #MOD-8B0033  #FUN-C80083
         #FUN-C80083---add---str
          WHEN g_npn.npn03='4'
             IF NOT cl_null(g_nmh.nmh26) THEN
                LET g_npq.npq03 = g_nmh.nmh26
             ELSE
                LET g_npq.npq03 = g_nms.nms22
             END IF
          #FUN-C80083--add---end
          #FUN-590109  --begin
          WHEN g_npn.npn03='6'  #LET g_npq.npq03 = g_nmh.nmh26 #撤票 
               IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                  LET g_npq.npq03 = g_nms.nms27 #撤票 
               ELSE
                  LET g_npq.npq03 = g_nmh.nmh26 #撤票 
               END IF
          WHEN g_npn.npn03='7'  
               IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                  LET g_npq.npq03 = g_nms.nms26 #退票 
               END IF
          #FUN-590109  --end
          WHEN g_npn.npn03='8' 
               IF g_nmh.nmh24 = '3' THEN 
                    LET g_npq.npq03 = g_nms.nms24 #質押
               ELSE LET g_npq.npq03 = g_nmh.nmh26 #兌現
               END IF
        END CASE
     END IF
  END IF
 ELSE
  IF g_npn.npn03='7' THEN #退票
     #FUN-650072  --begin
     IF g_aza.aza26!='2' OR g_nmydmy5='N' THEN
        IF g_npo.npo07='8' THEN  #原票況為'8'
           SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmh.nmh21
           IF STATUS THEN LET g_npq.npq03 = '-' END IF
        ELSE
           LET g_npq.npq03 = g_nmh.nmh261 
        END IF
     ELSE
        LET g_npq.npq03 = g_nms.nms261 #退票                          
     END IF
     #FUN-650072  --end
  ELSE
     IF NOT cl_null(g_npn.npn071) THEN LET g_npq.npq03=g_npn.npn071
     ELSE
        CASE
          WHEN g_npn.npn03='1'  LET g_npq.npq03 = g_nmh.nmh271 #收票 
          #NO.FUN-5A0088 START--
          WHEN g_npn.npn03='2'  LET g_npq.npq03 = g_nms.nms221 #托收貸方
          #NO.FUN-5A0088 END----
#          WHEN g_npn.npn03='3'  LET g_npq.npq03 = g_nms.nms15 #質押  #MOD-5A0249
          WHEN g_npn.npn03='3'  LET g_npq.npq03 = g_nms.nms221 #質押  #MOD-5A0249
          WHEN g_npn.npn03='4'  LET g_npq.npq03 = g_nms.nms221 #票貼  #MOD-8B0033 add
          #FUN-590109  --begin
          WHEN g_npn.npn03='6'  #LET g_npq.npq03 = g_nmh.nmh26 #撤票 
               IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                  LET g_npq.npq03 = g_nms.nms271 #撤票 
               ELSE
                  LET g_npq.npq03 = g_nmh.nmh261 #撤票 
               END IF
          WHEN g_npn.npn03='7'  
               IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npn.npn03 MATCHES '[67]' THEN
                  LET g_npq.npq03 = g_nms.nms261 #退票 
               END IF
          #FUN-590109  --end
          WHEN g_npn.npn03='8' 
               IF g_nmh.nmh24 = '3' THEN 
                    LET g_npq.npq03 = g_nms.nms241 #質押
               ELSE LET g_npq.npq03 = g_nmh.nmh261 #兌現
               END IF
        END CASE
     END IF
  END IF
 END IF
# No.FUN-680034 ---end---  	 
   #No.FUN-730032 --begin
   CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      IF g_bgerr THEN                                                     #MOD-CA0107 add
         CALL s_errmsg('aza81,aza82','','','aoo-081',1)                   #MOD-CA0107 add
      ELSE                                                                #MOD-CA0107 add
        #CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)                       #MOD-CA0107 mark
         CALL cl_err('aza81,aza82','aoo-081',1)                           #MOD-CA0107 add
      END IF                                                              #MOD-CA0107 add
   END IF
   IF g_npq.npqtype ='0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   #No.FUN-730032 --end
   LET l_aag05 = NULL
   SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=g_npq.npq03
                                             AND aag00 = g_bookno3       #No.FUN-730032
   IF l_aag05='Y' THEN
      LET g_npq.npq05 = g_nmh.nmh15 
   ELSE
      LET g_npq.npq05 = ''
   END IF
END FUNCTION
 
#FUN-590109  --begin
FUNCTION s_t250_gl_resort(p_npptype)
DEFINE      p_npptype    LIKE  npp_file.npptype
DEFINE      p_npqtype    LIKE  npq_file.npqtype
DEFINE      l_npq        RECORD LIKE npq_file.*
DEFINE      l_npq02      LIKE npq_file.npq02
DEFINE      l_aaa03      LIKE aaa_file.aaa03 #FUN-A40067
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   DROP TABLE x
   SELECT * FROM npq_file 
    WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_trno AND npq011=g_npn.npn03 AND npqtype=p_npptype      # No.FUN-680034  add  "AND npqtype=p_npptype"
     INTO TEMP x
   
   DELETE FROM npq_file 
        WHERE npqsys= 'NM' AND npq00=2 AND npq01 = g_trno AND npq011=g_npn.npn03 AND npqtype=p_npptype  # No.FUN-680034  add  "AND npqtype=p_npptype"
   IF SQLCA.SQLERRD[3] = 0 THEN                                                 
#     CALL cl_err('del npq_file',SQLCA.SQLCODE,1)                                  #No.FUN-660148
      #-----No.FUN-710024  --begin
      IF g_bgerr THEN
         CALL s_errmsg('npq01',g_trno,'delete npq_file',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("del","npq_file",g_trno,g_npn.npn03,SQLCA.sqlcode,"","del npq_file",1) #No.FUN-660148
      END IF
      #-----No.FUN-710024  --end
      RETURN                                                                    
   END IF
   DECLARE s_t250_gl_st CURSOR FOR 
    SELECT * FROM x ORDER BY npq06,npq02
   LET l_npq02 = 0
   FOREACH s_t250_gl_st INTO l_npq.*
      LET l_npq02=l_npq02+1
      LET l_npq.npq02 = l_npq02
     #start MOD-6C0140 mark
     #本段僅針對項次做重排的動作,不需再抓一次異動碼預設值
     ## NO.FUN-5C0015 --start--
     #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')
     # RETURNING  l_npq.*
     ## NO.FUN-5C0015 ---end---
     #end MOD-6C0140 mark
 
      #FUN-980005 add legal 
      LET l_npq.npqlegal= g_legal
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
#        LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04_2)#FUN-A40067
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno3
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES (l_npq.*)
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('npq resort',SQLCA.SQLCODE,1)   #No.FUN-660148
      #-----No.FUN-710024  --begin
         IF g_bgerr THEN
            CALL s_errmsg('npq01',l_npq.npq01,'npq resort',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","npq resort",1) #No.FUN-660148
         END IF
      #-----No.FUN-710024  --end
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#FUN-590109  --end
#TQC-790177
#FUN-A40033 --Begin
FUNCTION s_t250_diff()
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   IF g_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         IF g_bgerr THEN                                                     #MOD-CA0107 add
            CALL s_errmsg('aza81,aza82','','','aoo-081',1)                   #MOD-CA0107 add
         ELSE                                                                #MOD-CA0107 add
           #CALL cl_err(YEAR(g_npn.npn02),'aoo-081',1)                       #MOD-CA0107 mark
            CALL cl_err('aza81,aza82','aoo-081',1)                           #MOD-CA0107 add
         END IF                                                              #MOD-CA0107 add
         LET g_success = 'N'
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
        #FUN-D40118 ---Add--- Start
         SELECT aag44 INTO l_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF STATUS OR SQLCA.SQLCODE THEN
            IF g_bgerr THEN
               CALL s_errmsg('npq01',l_npq1.npq01,'npq resort',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","npq_file",l_npq1.npq00,l_npq1.npq01,SQLCA.sqlcode,"","npq diff",1)
            END IF
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End

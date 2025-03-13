# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify.........: No.MOD-4B0026 04/11/17 By Nicola 匯率與本幣金額的抓法剛好相反
# Modify ........: No.FUN-590109 05/09/26 By Elva 新增紅衝功能
# Modify.........: No.MOD-5A0286 05/11/30 By Smapmin 若應付票據是兌現後作廢,銀行存款會增加,
#                                                    所以分錄產生的借方應該抓取銀行的存款科目
#                                                    若應付票據是未兌現就直接作廢,不影響銀行存款,
#                                                    分錄產生的借方才是如現有程式所抓取的應付票據科
# Modify.........: NO.FUN-5C0015 05/12/20 By TSD.Sideny call s_def_npq:抓取異動碼default值
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/22 By flowld 兩套帳修改及alter table -- ANM模塊,前端基礎數據,融資
# Modify.........: No.FUN-680107 06/09/08 By Hellen 欄位類型修改
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.FUN-690105 06/12/15 By Sarah s_def_npq()時,p_key2的地方改成傳npm02
# Modify.........: No.FUN-710024 07/01/25 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-730032 07/04/04 By Ray 新增帳套
# Modify.........: No.FUN-740028 07/04/11 By lora 會計科目加帳套
# Modify.........: No.MOD-840051 08/04/08 By Carol npq04不給固定值
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/04 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/08/04 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/08/04 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-AA0087 11/01/29 By Mengxw 異動碼類型設定的改善 
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-C80205 12/09/14 By Polly 為開立或匯率為1，不應有匯差損失
# Modify.........: No.FUN-CB0045 12/12/27 By wangrr 大陸版本當票據類型為8:兌現,貸方科目抓取實際銀行科目,合併借方科目
# Modify.........: No.FUN-D10065 13/03/07 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.MOD-D80148 13/08/23 By yinhy 兌現時npq03抓取修改

DATABASE ds
 
GLOBALS "../../config/top.global"
   DEFINE g_npl		RECORD LIKE npl_file.*
   DEFINE g_npm		RECORD LIKE npm_file.*
   DEFINE g_nms		RECORD LIKE nms_file.*
   DEFINE g_npp		RECORD LIKE npp_file.*
   DEFINE g_npq		RECORD LIKE npq_file.*
   DEFINE g_nmd		RECORD LIKE nmd_file.*
   DEFINE g_trno	LIKE npl_file.npl01
   DEFINE g_nmydmy5     LIKE nmy_file.nmydmy5  #FUN-590109
   DEFINE g_t1          LIKE nmy_file.nmyslip  #FUN-590109
   DEFINE g_flag        LIKE type_file.chr1       #No.FUN-730032
   DEFINE g_bookno1     LIKE aza_file.aza81       #No.FUN-730032
   DEFINE g_bookno2     LIKE aza_file.aza82       #No.FUN-730032
   DEFINE g_bookno3     LIKE aza_file.aza82       #No.FUN-730032
   DEFINE g_npq25       LIKE npq_file.npq25       #No.FUN-9A0036               
   DEFINE   g_azi04_2   LIKE azi_file.azi04       #FUN-A40067
   DEFINE g_aag44       LIKE aag_file.aag44       #FUN-D40118 add
 
 
DEFINE   g_msg          LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(72)
FUNCTION s_t150_gl(p_trno,p_npptype)           # No.FUN-680034
   DEFINE p_trno	LIKE npl_file.npl01
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-680107 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-680107 SMALLINT
   DEFINE p_npptype     LIKE npp_file.npptype  # No.FUN-680034
   DEFINE p_npqtype     LIKE npq_file.npqtype  # No.FUN-680034
   WHENEVER ERROR CALL cl_err_msg_log
  
   LET g_trno = p_trno
   IF g_trno IS NULL THEN RETURN END IF
   SELECT npl_file.* INTO g_npl.* FROM npl_file WHERE npl01 = g_trno 
   IF STATUS THEN 
#     CALL cl_err('sel npl',STATUS,1) FUN-660148
#-----No.FUN-710024-----begin
      IF g_bgerr THEN
         CALL s_errmsg('npl01',g_trno,'sel npl',STATUS,0)
      ELSE
         CALL cl_err3("sel","npl_file",g_trno,"",STATUS,"","sel npl",1) #FUN-660148
      END IF
#-----No.FUN-710024 -----end
   END IF
   IF g_npl.nplconf = 'X' THEN RETURN END IF
   #modify by danny 97/05/14 若已拋轉總帳, 不可重新產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file 
    WHERE nppsys= 'NM' AND npp00=1 AND npp01 = g_trno AND npp011=g_npl.npl03
      AND nppglno != '' AND nppglno IS NOT NULL
   IF l_n > 0 THEN 
#-----No.FUN-710024-----begin
      IF g_bgerr THEN
         LET g_showmsg=g_trno,"/",g_npl.npl03
         CALL s_errmsg('npp01,npp011',g_showmsg,p_trno,'aap-122',1)
      ELSE
         CALL cl_err(p_trno,'aap-122',1) RETURN
      END IF
#-----No.FUN-710024 -----end
      LET g_success = 'N'    # No.FUN-680034 
   END IF
   SELECT * INTO g_nms.* FROM nms_file WHERE (nms01 = ' ' OR nms01 IS NULL)
   DELETE FROM npp_file 
       WHERE nppsys= 'NM' AND npp00=1 AND npp01 = g_trno AND npp011=g_npl.npl03 AND npptype=p_npptype  # No.FUN-680034 
   DELETE FROM npq_file 
       WHERE npqsys= 'NM' AND npq00=1 AND npq01 = g_trno AND npq011=g_npl.npl03 AND npqtype=p_npptype  # No.FUN-680034 

   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_trno
   #FUN-B40056--add--end--

 # No.FUN-680034 --start-- 
 #  CALL s_t150_gl_11()
    CALL s_t150_gl_11(p_npptype)
   #FUN-590109  --begin
   IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npl.npl03 MATCHES '[67]' THEN
 
 #     CALL s_t150_gl_resort()  #項次重排  
       CALL s_t150_gl_resort(p_npptype) 
 # No.FUN-680034 ---end---     
   END IF
   #FUN-590109  --end
   CALL s_t150_diff()           #FUN-A40033
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021 
   CALL cl_getmsg('axr-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION s_t150_gl_11(p_npptype)      # No.FUN-680034
  DEFINE  p_npptype    LIKE npp_file.npptype   # No.FUN-680034
  DEFINE  p_npqtype    LIKE npq_file.npqtype   # No.FUN-680034
   LET g_npp.npptype = p_npptype      # No.FUN-680034
   LET g_npq.npqtype = p_npptype      # No.FUN-680034 
   LET g_npp.nppsys = 'NM'
   LET g_npp.npp00 = 1
   LET g_npp.npp01 = g_npl.npl01
   LET g_npp.npp011= g_npl.npl03
   LET g_npp.npp02 = g_npl.npl02
   LET g_npp.npp03 = NULL
 
   #FUN-980005 add legal 
   LET g_npp.npplegal= g_legal
   #FUN-980005 end legal 
   INSERT INTO npp_file VALUES(g_npp.*)
   IF STATUS THEN
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660148
#-----No.FUN-710024-----begin
      IF g_bgerr THEN
         LET g_showmsg=g_npp.npp01,"/",g_npp.npp011,"/",g_npp.nppsys,"/",g_npp.npp00
         CALL s_errmsg('npp01,npp011,nppsys,npp00',g_showmsg,'ins npp',STATUS,1)
      ELSE
         CALL cl_err3("ins","npp_file",g_npp.npp00,g_npp.npp01,STATUS,"","ins npp",1) #No.FUN-660148
      END IF
#-----No.FUN-710024 -----end
      LET g_success='N' #no.5573
   END IF
 
   LET g_npq.npqsys = 'NM' 
   LET g_npq.npq00 = 1
   LET g_npq.npq01 = g_npl.npl01
   LET g_npq.npq011= g_npl.npl03
   LET g_npq.npq02 = 0
   LET g_npq.npq24 = g_npl.npl04 
   LET g_npq.npq25 = g_npl.npl05
   LET g_npq25     = g_npq.npq25        #No.FUN-9A0036
 # No.FUN-680034 --start--
  # CALL s_t150_gl_a()       # 借、貸方產生
#FUN-CB0045--add--str--
#合併借方科目
   IF g_aza.aza26='2' AND g_npl.npl03='8' THEN
      CALL s_t150_gl_b(p_npptype) 
   ELSE
#FUN-CB0045--add--end
    CALL s_t150_gl_a(p_npptype) 
   END IF   #FUN-CB0045 
 # No.FUN-680034 ---end---
END FUNCTION
 
FUNCTION s_t150_gl_a(p_npptype)         # No.FUN-680034    add  p_npptype
 DEFINE l_aag05    LIKE aag_file.aag05
 DEFINE p_npptype  LIKE npp_file.npptype   # No.FUN-680034
 DEFINE p_npqtype  LIKE npq_file.npqtype   # No.FUN-680034
 DEFINE l_aaa03    LIKE aaa_file.aaa03     #FUN-A40067
 DEFINE l_flag     LIKE type_file.chr1     #FUN-D40118 add
   DECLARE s_t150_gl_c3 CURSOR FOR
        SELECT * FROM npm_file WHERE npm01=g_npl.npl01 
   FOREACH s_t150_gl_c3 INTO g_npm.*
     IF STATUS THEN EXIT FOREACH END IF
           SELECT * INTO g_nmd.* FROM nmd_file 
             WHERE nmd01=g_npm.npm03 AND nmd30 <> 'X'
           IF STATUS THEN
              INITIALIZE g_nmd.* TO NULL
           END IF
           LET g_npq.npq02 = g_npq.npq02 + 1
           LET g_npq.npq21 = g_nmd.nmd08 
           LET g_npq.npq22 = g_nmd.nmd24 
           #借方科目產生
           #FUN-590109  --begin
           LET g_t1 = s_get_doc_no(g_trno)                                              
           SELECT nmydmy5 INTO g_nmydmy5 FROM nmy_file WHERE nmyslip = g_t1 
           IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npl.npl03 MATCHES '[67]' THEN
              LET g_npq.npq06 = '2'
             CALL s_npq03_c_def(p_npptype)    # No.FUN-680034  add  p_npptype
           ELSE
              LET g_npq.npq06 = '1'
              CALL s_npq03_d_def(p_npptype)    # No.FUN-680034  add  p_npptype
           END IF
           #FUN-590109  --end
            LET g_npq.npq07f = g_npm.npm04
           LET g_npq.npq24 = g_npl.npl04 
            #-----No.MOD-4B0026-----
           IF g_npl.npl03="7" THEN                          
              LET g_npq.npq07 = g_npm.npm06 
              LET g_npq.npq25 = g_npl.npl05
           ELSE
              LET g_npq.npq25 = g_nmd.nmd19 
              LET g_npq.npq07 = g_npm.npm05 
           END IF
           LET g_npq25     = g_npq.npq25        #No.FUN-9A0036
            #-----No.MOD-4B0026 END-----
           #No.FUN-740028 --begin                                                                                                   
           CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
           IF g_flag = '1' THEN                                                                                                     
              CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
           END IF
           #No.FUN-740028 --END
           SELECT aag05 INTO l_aag05 FROM aag_file   #是否做部門管理
            WHERE aag01=g_npq.npq03
              AND aag00=g_bookno1     #No.FUN-740028
           IF l_aag05 = 'Y' THEN
              LET g_npq.npq05 = g_nmd.nmd18 
           ELSE
              LET g_npq.npq05 = ' '
           END IF 
           #LET g_npq.npq04 = g_npl.npl08 #FUN-D10065 mark
           LET g_npq.npq04 = NULL         #FUN-D10065
           MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
           IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
           #FUN-590109  --begin
           IF g_aza.aza26='2' THEN
              IF g_nmydmy5='Y' AND g_npl.npl03 MATCHES '[67]' THEN
                 LET g_npq.npq07 = (-1)*g_npq.npq07                                  
                 LET g_npq.npq07f= (-1)*g_npq.npq07f                                 
              END IF  
           END IF  
           #FUN-590109  --end
           #No.FUN-730032 --begin
           CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
           IF g_flag = '1' THEN
              CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
              LET g_success = 'N'
           END IF
           IF g_npp.npptype = '0' THEN
              LET g_bookno3 = g_bookno1
           ELSE
              LET g_bookno3 = g_bookno2
           END IF
           #No.FUN-730032 --end
           # NO.FUN-5C0015 --start--
          #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #FUN-690105 mark
#          CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npm.npm02,'')   #FUN-690105       #No.FUN-730032
           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npm.npm02,'',g_bookno3)   #FUN-690105       #No.FUN-730032
            RETURNING  g_npq.*
           #FUN-D10065--add--str--
           IF cl_null(g_npq.npq04) THEN
              LET g_npq.npq04 = g_npl.npl08
           END IF
           #FUN-D10065--add--end
           CALL s_def_npq31_npq34(g_npq.*,g_bookno3)  RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
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
#             CALL cl_err('ins npq#9',STATUS,1)    #No.FUN-660148
#-----No.FUN-710024-----begin
                 IF g_bgerr THEN
                    LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq03
                    CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#9',STATUS,1)
                 ELSE
                    CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
                 END IF
#-----No.FUN-710024 -----end
              LET g_success='N' #no.5573
           END IF
 
           #貸方科目產生
            LET g_npq.npq02 = g_npq.npq02 + 1
            #FUN-590109  --begin
            IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npl.npl03 MATCHES '[67]' THEN
               LET g_npq.npq06 = '1'
               CALL s_npq03_d_def(p_npptype)   # No.FUN-680034  add  p_npptype
            ELSE
               LET g_npq.npq06 = '2'
               CALL s_npq03_c_def(p_npptype)   # No.FUN-680034  add  p_npptype
            END IF
            #FUN-590109  --end
            LET g_npq.npq07f = g_npm.npm04
             #-----No.MOD-4B0026-----
           #IF g_npl.npl03="7" THEN                           #MOD-C80205 mark
            IF g_npl.npl03 = "7"  OR g_npl.npl03 = "1" THEN   #MOD-C80205 add
               LET g_npq.npq25 = g_nmd.nmd19 
               LET g_npq.npq07 = g_npm.npm05 
            ELSE
               LET g_npq.npq07 = g_npm.npm06 
               LET g_npq.npq25 = g_npl.npl05
            END IF
            LET g_npq25     = g_npq.npq25        #No.FUN-9A0036
             #-----No.MOD-4B0026 END-----
            LET g_npq.npq24 = g_npl.npl04
            #No.FUN-740028 --begin                                                                                                   
           CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
           IF g_flag = '1' THEN                                                                                                     
              CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)                                                                            
           END IF                                                                                                                   
           #No.FUN-740028 --END  
            SELECT aag05 INTO l_aag05 FROM aag_file   #是否做部門管理
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno1     #No.FUN-740028   
            IF l_aag05 = 'Y' THEN
               LET g_npq.npq05 = g_nmd.nmd18 
            ELSE
               LET g_npq.npq05 = ' '
            END IF 
            #LET g_npq.npq04 = g_npl.npl08  #FUN-D10065 mark
            LET g_npq.npq04 = NULL          #FUN-D10065
            MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
            IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
            #FUN-590109  --begin
            IF g_aza.aza26='2' THEN
               IF g_nmydmy5='Y' AND g_npl.npl03 MATCHES '[67]' THEN
                  LET g_npq.npq07 = (-1)*g_npq.npq07                                  
                  LET g_npq.npq07f= (-1)*g_npq.npq07f                                 
               END IF  
            END IF  
            #FUN-590109  --end
           # NO.FUN-5C0015 --start--
          #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #FUN-690105 mark
#          CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npm.npm02,'')   #FUN-690105       #No.FUN-730032
           CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npm.npm02,'',g_bookno3)   #FUN-690105       #No.FUN-730032
            RETURNING  g_npq.*
           #FUN-D10065--add--str--
           IF cl_null(g_npq.npq04) THEN
              LET g_npq.npq04 = g_npl.npl08
           END IF
           #FUN-D10065--add--end
            
           CALL s_def_npq31_npq34(g_npq.*,g_bookno3)  RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
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
#-----No.FUN-710024-----begin
                 IF g_bgerr THEN
                    LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq03
                    CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#9',STATUS,1)
                 ELSE
                    CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
                 END IF
#-----No.FUN-710024 -----end
               LET g_success='N' #no.5573
            END IF
 
           #匯差產生
           IF g_npl.npl05 = 1 OR g_npl.npl03 = 1 THEN          #MOD-C80205 add
              LET g_npq.npq07 = 0                              #MOD-C80205 add
           ELSE                                                #MOD-C80205 add
              LET g_npq.npq07 = g_npm.npm05  - g_npm.npm06
           END IF                                              #MOD-C80205 add
             #-----No.MOD-4B0026-----
            IF g_npl.npl03="7" THEN
               IF g_npq.npq07 < 0 THEN  
                  LET g_npq.npq06 = '2'
                  LET g_npq.npq03 = g_nms.nms12
                  LET g_npq.npq07 = -1 * g_npq.npq07
               ELSE
                  LET g_npq.npq06 = '1'
                  LET g_npq.npq03 = g_nms.nms13
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
             #-----No.MOD-4B0026 END-----
            #No.FUN-740028 --begin                                                                                                   
           CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
           IF g_flag = '1' THEN                                                                                                     
              CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)                                                                            
           END IF                                                                                                                   
           #No.FUN-740028 --END 
            SELECT aag05 INTO l_aag05 FROM aag_file   #是否做部門管理
             WHERE aag01=g_npq.npq03
               AND aag00=g_bookno1    #No.FUN-740028
            IF l_aag05 = 'Y' THEN
               LET g_npq.npq05 = g_nmd.nmd18 
            ELSE
               LET g_npq.npq05 = ' '
            END IF 
           LET g_npq.npq07f = 0
           #LET g_npq.npq04 = g_npl.npl08   #MOD-840051-modify #FUN-D10065 mark
           LET g_npq.npq04 = NULL    #FUN-D10065
           MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
           IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
           IF g_npq.npq07<>0 OR g_npq.npq07f<>0 THEN
              LET g_npq.npq02 = g_npq.npq02 + 1
              # NO.FUN-5C0015 --start--
             #CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','')            #FUN-690105 mark
#             CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npm.npm02,'')   #FUN-690105       #No.FUN-730032
              CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npm.npm02,'',g_bookno3)   #FUN-690105       #No.FUN-730032
               RETURNING  g_npq.*
              #FUN-D10065--add--str--
              IF cl_null(g_npq.npq04) THEN
                 LET g_npq.npq04 = g_npl.npl08
              END IF
              #FUN-D10065--add--end
               
              CALL s_def_npq31_npq34(g_npq.*,g_bookno3)  RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 #FUN-AA0087
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
#                CALL cl_err('ins npq#10',STATUS,1)    #No.FUN-660148
#-----No.FUN-710024-----begin
                 IF g_bgerr THEN
                    LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq03
                    CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#10',STATUS,1)
                 ELSE
                    CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#10",1) #No.FUN-660148
                 END IF
#-----No.FUN-710024 -----end
                 LET g_success='N' #no.5573
              END IF
           END IF
   END FOREACH
END FUNCTION
 
# No.FUN-680034 --start--
#FUNCTION s_npq03_d_def()    #借方會計科目default 
 FUNCTION s_npq03_d_def(p_npptype) 
 DEFINE p_npptype  LIKE npp_file.npptype 
 DEFINE p_npqtype  LIKE npq_file.npqtype 
# No.FUN-680034 ---end--- 
 CASE
# No.FUN-680034 --start-- 
   WHEN g_npl.npl03='1'		# 開票
      IF p_npptype = '0' THEN
        IF cl_null(g_npl.npl06) THEN
           LET g_npq.npq03 = g_nms.nms14
        ELSE
           LET g_npq.npq03 = g_npl.npl06
        END IF
     ELSE
        IF cl_null(g_npl.npl061) THEN
           LET g_npq.npq03 = g_nms.nms141
        ELSE
           LET g_npq.npq03 = g_npl.npl061
        END IF
     END IF
# No.FUN-680034 ---end---            	 	    
#   WHEN g_npl.npl03 MATCHES '[689]'  #撤票、退票、兌現、作廢   #MOD-5A0286
   WHEN g_npl.npl03 MATCHES '[68]'  #撤票、退票、兌現、作廢   #MOD-5A0286
# No.FUN-680034 --start-- 
       IF p_npptype = '0' THEN 
              
        LET g_npq.npq03 = g_nmd.nmd23 
       ELSE
       	LET g_npq.npq03 = g_nmd.nmd231
       END IF	
        #FUN-590109  --begin
        IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npl.npl03 = '6' THEN
         IF p_npptype = '0'  THEN
           LET g_npq.npq03 = g_nms.nms17
         ELSE
           LET g_npq.npq03 = g_nms.nms171
         END IF
# No.FUN-680034 ---end---            	
        END IF
        #FUN-590109  --end
#MOD-5A0286
# No.FUN-680034 --start-- 
  WHEN g_npl.npl03 = '9'
       IF g_nmd.nmd12 = '8' THEN
         IF p_npptype = '0'  THEN
          SELECT nma05 INTO g_npq.npq03 FROM nma_file
             WHERE nma01 = g_nmd.nmd03
         ELSE
          SELECT nma051 INTO g_npq.npq03 FROM nma_file
             WHERE nma01 = g_nmd.nmd03
         END IF     	    
       ELSE
         
        IF p_npptype = '0' THEN                
          LET g_npq.npq03 = g_nmd.nmd23
        ELSE 
          LET g_npq.npq03 = g_nmd.nmd231
        END IF  	 
# No.FUN-680034 ---end---       
       END IF
       IF g_aza.aza26='2' AND g_nmydmy5='Y' AND g_npl.npl03 = '6' THEN
# No.FUN-680034 --start--  
         IF p_npptype = '0' THEN     
          LET g_npq.npq03 = g_nms.nms17
        ELSE
          LET g_npq.npq03 = g_nms.nms171
        END IF   	
# No.FUN-680034 ---end---        
       END IF
#END MOD-5A0286
   WHEN g_npl.npl03 = '7'       #退票
# No.FUN-680034 --start--
       IF p_npptype = '0'  THEN
        SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01 = g_nmd.nmd03
       ELSE
       	SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01 = g_nmd.nmd03
       END IF 	
        #FUN-590109  --begin
        IF g_aza.aza26='2' AND g_nmydmy5='Y' THEN
          IF p_npptype = '0'  THEN
            LET g_npq.npq03 = g_nms.nms16
          ELSE
            LET g_npq.npq03 = g_nms.nms161
          END IF   	 
        END IF
# No.FUN-680034 ---end---        
        #FUN-590109  --end
# No.FUN-680034 --start--
   WHEN g_npl.npl03 ='C'	# Clear
      IF p_npptype = '0'  THEN
        SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmd.nmd03
      ELSE
      	SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmd.nmd03
      END IF
# No.FUN-680034 ---end---      	
        IF g_npq.npq03 IS NULL THEN LET g_npq.npq03 = '-' END IF
 END CASE
END FUNCTION
 
# No.FUN-680034 --start--
#FUNCTION s_npq03_c_def()    #貸方會計科目default 
 FUNCTION s_npq03_c_def(p_npptype)
  DEFINE p_npptype  LIKE npp_file.npptype
  DEFINE p_npqtype  LIKE npq_file.npqtype
 CASE
   WHEN g_npl.npl03='1'  #開票
      IF p_npptype = '0'  THEN
        IF cl_null(g_npl.npl07) THEN
           LET g_npq.npq03 = g_nmd.nmd23
        ELSE
           LET g_npq.npq03 = g_npl.npl07
        END IF
      ELSE 
      	 IF cl_null(g_npl.npl071) THEN
      	   LET g_npq.npq03 = g_nmd.nmd231
      	 ELSE
      	   LET g_npq.npq03 = g_npl.npl071
      	 END IF
      END IF	
         	    
   WHEN g_npl.npl03='6'  #撤票
      IF p_npptype = '0'  THEN
        IF cl_null(g_npl.npl07) THEN
           LET g_npq.npq03 = g_nms.nms17
           #FUN-590109  --begin
           IF g_aza.aza26='2' AND g_nmydmy5='Y' THEN
              LET g_npq.npq03 = g_nmd.nmd23 
           END IF
           #FUN-590109  --end
        ELSE
           LET g_npq.npq03 = g_npl.npl07
        END IF
      ELSE
      	 IF cl_null(g_npl.npl071) THEN
           LET g_npq.npq03 = g_nms.nms171
           IF g_aza.aza26='2' AND g_nmydmy5='Y' THEN
              LET g_npq.npq03 = g_nmd.nmd231 
           END IF
         ELSE
           LET g_npq.npq03 = g_npl.npl071
         END IF
       END IF	
   WHEN g_npl.npl03='7'  #退票    
       IF p_npptype = '0'  THEN
        IF cl_null(g_npl.npl07) THEN
           LET g_npq.npq03 = g_nms.nms16
           #FUN-590109  --begin
           IF g_aza.aza26='2' AND g_nmydmy5='Y' THEN
              SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01 = g_nmd.nmd03
           END IF
           #FUN-590109  --end
        ELSE
           LET g_npq.npq03 = g_npl.npl07
        END IF
       ELSE
       	  IF cl_null(g_npl.npl071) THEN
           LET g_npq.npq03 = g_nms.nms161
           IF g_aza.aza26='2' AND g_nmydmy5='Y' THEN
              SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01 = g_nmd.nmd03
           END IF
          ELSE
           LET g_npq.npq03 = g_npl.npl071
          END IF
      END IF  
   WHEN g_npl.npl03='8'  #兌現
      LET g_npq.npq03 = NULL     #MOD-D80148
      IF p_npptype = '0'  THEN
         #FUN-CB0045--add--str--
         #IF g_aza.aza26='2' THEN
         IF g_aza.aza26='2' AND NOT cl_null(g_npm.npm09) THEN   #MOD-D80148
            SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_npm.npm09
         #ELSE         #MOD-D80148 mark
         END IF        #MOD-D80148
         #FUN-CB0045--add--end
         IF cl_null(g_npq.npq03) THEN #MOD-D80148
            SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmd.nmd03
         END IF   #FUN-CB0045
      ELSE
         #FUN-CB0045--add--str--
         #IF g_aza.aza26='2' THEN
         IF g_aza.aza26='2' AND NOT cl_null(g_npm.npm09) THEN   #MOD-D80148
            SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_npm.npm09
         #ELSE         #MOD-D80148 mark
         END IF        #MOD-D80148
         #FUN-CB0045--add--end
         IF cl_null(g_npq.npq03) THEN  #MOD-D80148
            SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmd.nmd03
         END IF   #FUN-CB0045 
      END IF     
        IF g_npq.npq03 IS NULL THEN
           LET g_npq.npq03 = '-'
        END IF
   WHEN g_npl.npl03='9'  #作廢
      IF p_npptype = '0'  THEN
        IF cl_null(g_npl.npl07) THEN
           LET g_npq.npq03 = g_nms.nms18
        ELSE
           LET g_npq.npq03 = g_npl.npl07
        END IF
      ELSE
      	 IF cl_null(g_npl.npl071) THEN
           LET g_npq.npq03 = g_nms.nms181
        ELSE
           LET g_npq.npq03 = g_npl.npl071
        END IF
      END IF   
   WHEN g_npl.npl03 ='C'	# Clear
      IF p_npptype = '0'  THEN
        SELECT nma05 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmd.nmd03
      ELSE
      	SELECT nma051 INTO g_npq.npq03 FROM nma_file WHERE nma01=g_nmd.nmd03 
      END IF	 
        IF g_npq.npq03 IS NULL THEN LET g_npq.npq03 = '-' END IF
 END CASE
END FUNCTION
# No.FUN-680034 ---end---
 
#FUN-590109  --begin
FUNCTION s_t150_gl_resort(p_npptype)           # No.FUN-680034  add p_npptype
DEFINE      p_npptype   LIKE npp_file.npptype  # No.FUN-680034 
DEFINE      p_npqtype   LIKE npq_file.npqtype  # No.FUN-680034 
DEFINE      l_npq       RECORD LIKE npq_file.*
DEFINE      l_npq02     LIKE npq_file.npq02
DEFINE      l_aaa03     LIKE aaa_file.aaa03     #FUN-A40067
DEFINE      l_flag      LIKE type_file.chr1    #FUN-D40118 add
 
   DROP TABLE x
   SELECT * FROM npq_file 
    WHERE npqsys= 'NM' AND npq00=1 AND npq01 = g_trno AND npq011=g_npl.npl03 AND npqtype=p_npqtype     # No.FUN-680034  add  "AND npqtype=p_npqtype"
     INTO TEMP x
   
   DELETE FROM npq_file 
       WHERE npqsys= 'NM' AND npq00=1 AND npq01 = g_trno AND npq011=g_npl.npl03 AND npqtype=p_npqtype    # No.FUN-680034  add  "AND npqtype=p_npqtype"
   IF SQLCA.SQLERRD[3] = 0 THEN                                                 
#     CALL cl_err('del npq_file',SQLCA.SQLCODE,1)                                  #No.FUN-660148
#-----No.FUN-710024-----begin
      IF g_bgerr THEN
         LET g_showmsg=g_trno,"/",g_npl.npl03
         CALL s_errmsg('npq01,npq011',g_showmsg,'del npq_file',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("del","npq_file",g_trno,g_npl.npl03,SQLCA.sqlcode,"","del npq_file",1) #No.FUN-660148
      END IF
#-----No.FUN-710024 -----end
      RETURN                                                                    
   END IF
   DECLARE s_t250_gl_st CURSOR FOR 
    SELECT * FROM x ORDER BY npq06,npq02
   LET l_npq02 = 0
   FOREACH s_t250_gl_st INTO l_npq.*
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
#-----No.FUN-710024-----begin
      IF g_bgerr THEN
         LET g_showmsg=l_npq.npq01,"/",l_npq.npq011
         CALL s_errmsg('npq01,npq011',g_showmsg,'npq resort',SQLCA.sqlcode,0)
      ELSE
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","npq resort",1) #No.FUN-660148
      END IF
#-----No.FUN-710024 -----end
         EXIT FOREACH
      END IF
   END FOREACH
END FUNCTION
#FUN-590109  --end
#FUN-A40033 --Begin
FUNCTION s_t150_diff()
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
         IF STATUS THEN 
            IF g_bgerr THEN
               LET g_showmsg=l_npq1.npq01,"/",l_npq1.npq011,"/",l_npq1.npq03
               CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#9',STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
            END IF
            LET g_success='N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End

#FUN-CB0045--add--str--
#合併借方
FUNCTION s_t150_gl_b(p_npptype) 
   DEFINE l_aag05    LIKE aag_file.aag05
   DEFINE p_npptype  LIKE npp_file.npptype   
   DEFINE p_npqtype  LIKE npq_file.npqtype   
   DEFINE l_aaa03    LIKE aaa_file.aaa03 
   DEFINE l_sql      STRING
   DEFINE l_nmd23    LIKE nmd_file.nmd23,
          l_nmd08    LIKE nmd_file.nmd08,
          l_nmd24    LIKE nmd_file.nmd24,
          l_nmd18    LIKE nmd_file.nmd18,
          l_nmd19    LIKE nmd_file.nmd19,
          l_npm04    LIKE npm_file.npm04,
          l_npm05    LIKE npm_file.npm05
          
   #借方科目產生
   IF p_npptype = '0' THEN   
      LET l_sql="SELECT nmd23,nmd08,nmd24,nmd18,nmd19,SUM(npm04),SUM(npm05)"
   ELSE
      LET l_sql="SELECT nmd231,nmd08,nmd24,nmd18,nmd19,SUM(npm04),SUM(npm05)" 
   END IF
   LET l_sql=l_sql,"  FROM npm_file,nmd_file ",
             " WHERE npm03=nmd01 AND nmd30 <> 'X'",
             "   AND npm01='",g_npl.npl01,"'"
   IF p_npptype = '0' THEN
      LET l_sql=l_sql," GROUP BY nmd23,nmd08,nmd24,nmd18,nmd19 "
   ELSE
      LET l_sql=l_sql," GROUP BY nmd231,nmd08,nmd24,nmd18,nmd19 "
   END IF
   PREPARE sel_pr FROM l_sql
   DECLARE sel_cr CURSOR FOR sel_pr
   FOREACH sel_cr INTO l_nmd23,l_nmd08,l_nmd24,l_nmd18,l_nmd19,l_npm04,l_npm05   
      IF STATUS THEN
         EXIT FOREACH
      END IF
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq21 = l_nmd08 
      LET g_npq.npq22 = l_nmd24 

      LET g_t1 = s_get_doc_no(g_trno)                                              
      SELECT nmydmy5 INTO g_nmydmy5 FROM nmy_file WHERE nmyslip = g_t1 
      LET g_npq.npq06 = '1'

      LET g_npq.npq03 = l_nmd23 

      LET g_npq.npq07f = l_npm04
      LET g_npq.npq24 = g_npl.npl04 
      LET g_npq.npq25 = l_nmd19 
      LET g_npq.npq07 = l_npm05
      LET g_npq25     = g_npq.npq25                                                                                                      
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
      IF g_flag = '1' THEN                                                                                                     
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
      END IF
      SELECT aag05 INTO l_aag05 FROM aag_file 
       WHERE aag01=g_npq.npq03 AND aag00=g_bookno1   
      IF l_aag05 = 'Y' THEN
         LET g_npq.npq05 = l_nmd18  
      ELSE
         LET g_npq.npq05 = ' '
      END IF 
      #LET g_npq.npq04 = g_npl.npl08  #FUN-D10065 mark
      LET g_npq.npq04 = NULL          #FUN-D10065
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
      IF g_flag = '1' THEN
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)
         LET g_success = 'N'
      END IF
      IF g_npp.npptype = '0' THEN
         LET g_bookno3 = g_bookno1
      ELSE
         LET g_bookno3 = g_bookno2
      END IF
      
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) 
         RETURNING  g_npq.*
      #FUN-D10065--add--str--
      IF cl_null(g_npq.npq04) THEN
         LET g_npq.npq04 = g_npl.npl08
      END IF
      #FUN-D10065--add--end
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3)  
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 
   
      LET g_npq.npqlegal= g_legal
   
      IF p_npptype = '1' THEN
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO t_azi04 FROM azi_file  
          WHERE azi01 = l_aaa03
   
         CALL s_newrate(g_bookno1,g_bookno2, g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,t_azi04)
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)
      END IF
   
      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN 
         IF g_bgerr THEN
            LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq03
            CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#9',STATUS,1)
         ELSE
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1)
         END IF
         LET g_success='N'
      END IF
   END FOREACH
   
   #貸方科目逐筆產生
   DECLARE s_t150_gl_cr1 CURSOR FOR
        SELECT * FROM npm_file WHERE npm01=g_npl.npl01 
   FOREACH s_t150_gl_cr1 INTO g_npm.*
      IF STATUS THEN 
         EXIT FOREACH
      END IF
      SELECT * INTO g_nmd.* FROM nmd_file 
        WHERE nmd01=g_npm.npm03 AND nmd30 <> 'X'
      IF STATUS THEN
         INITIALIZE g_nmd.* TO NULL
      END IF
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq21 = g_nmd.nmd08 
      LET g_npq.npq22 = g_nmd.nmd24 
      
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq06 = '2'
      CALL s_npq03_c_def(p_npptype) 

      LET g_npq.npq07f = g_npm.npm04
      LET g_npq.npq07 = g_npm.npm06 
      LET g_npq.npq25 = g_npl.npl05
      LET g_npq25     = g_npq.npq25  

      LET g_npq.npq24 = g_npl.npl04
                                                                                            
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
      IF g_flag = '1' THEN                                                                                                     
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)                                                                            
      END IF                                                                                                                   

      SELECT aag05 INTO l_aag05 FROM aag_file   #是否做部門管理
       WHERE aag01=g_npq.npq03
         AND aag00=g_bookno1      
      IF l_aag05 = 'Y' THEN
         LET g_npq.npq05 = g_nmd.nmd18 
      ELSE
         LET g_npq.npq05 = ' '
      END IF 
      #LET g_npq.npq04 = g_npl.npl08  #FUN-D10065 mark
      LET g_npq.npq04 = NULL          #FUN-D10065
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      IF g_aza.aza26='2' THEN
         IF g_nmydmy5='Y' AND g_npl.npl03 MATCHES '[67]' THEN
            LET g_npq.npq07 = (-1)*g_npq.npq07                                  
            LET g_npq.npq07f= (-1)*g_npq.npq07f                                 
         END IF  
      END IF  
      
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npm.npm02,'',g_bookno3)  
        RETURNING  g_npq.*
       
      #FUN-D10065--add--str--
      IF cl_null(g_npq.npq04) THEN
         LET g_npq.npq04 = g_npl.npl08
      END IF
      #FUN-D10065--add--end
      CALL s_def_npq31_npq34(g_npq.*,g_bookno3)  
        RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 

      LET g_npq.npqlegal= g_legal

      IF p_npptype = '1' THEN
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO t_azi04 FROM azi_file       
          WHERE azi01 = l_aaa03

         CALL s_newrate(g_bookno1,g_bookno2,
                        g_npq.npq24,g_npq25,g_npp.npp02)
         RETURNING g_npq.npq25
         LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25

         LET g_npq.npq07 = cl_digcut(g_npq.npq07,t_azi04)
      ELSE
         LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04) 
      END IF

      INSERT INTO npq_file VALUES (g_npq.*)
      IF STATUS THEN
         IF g_bgerr THEN
            LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq03
            CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#9',STATUS,1)
         ELSE
            CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#9",1) #No.FUN-660148
         END IF
         LET g_success='N' 
      END IF
 
      #匯差產生
      LET g_npq.npq07 = g_npm.npm05  - g_npm.npm06
      IF g_npl.npl03="7" THEN
         IF g_npq.npq07 < 0 THEN  
            LET g_npq.npq06 = '2'
            LET g_npq.npq03 = g_nms.nms12
            LET g_npq.npq07 = -1 * g_npq.npq07
         ELSE
            LET g_npq.npq06 = '1'
            LET g_npq.npq03 = g_nms.nms13
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
                                                                                             
      CALL s_get_bookno(YEAR(g_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                
      IF g_flag = '1' THEN                                                                                                     
         CALL cl_err(YEAR(g_npp.npp02),'aoo-081',1)                                                                            
      END IF               
      SELECT aag05 INTO l_aag05 FROM aag_file   #是否做部門管理
       WHERE aag01=g_npq.npq03
         AND aag00=g_bookno1   
      IF l_aag05 = 'Y' THEN
         LET g_npq.npq05 = g_nmd.nmd18 
      ELSE
         LET g_npq.npq05 = ' '
      END IF 
      LET g_npq.npq07f = 0
      #LET g_npq.npq04 = g_npl.npl08 #FUN-D10065 mark
      LET g_npq.npq04 = NULL         #FUN-D10065
      MESSAGE '>',g_npq.npq02,' ',g_npq.npq03
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      IF g_npq.npq07<>0 OR g_npq.npq07f<>0 THEN
         LET g_npq.npq02 = g_npq.npq02 + 1
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,g_npm.npm02,'',g_bookno3)  
          RETURNING  g_npq.*
         #FUN-D10065--add--str--
         IF cl_null(g_npq.npq04) THEN
            LET g_npq.npq04 = g_npl.npl08
         END IF
         #FUN-D10065--add--end
         CALL s_def_npq31_npq34(g_npq.*,g_bookno3)
         RETURNING g_npq.npq31,g_npq.npq32,g_npq.npq33,g_npq.npq34 

         LET g_npq.npqlegal= g_legal

         IF p_npptype = '1' THEN

            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = g_bookno2
            SELECT azi04 INTO t_azi04 FROM azi_file 
             WHERE azi01 = l_aaa03

            CALL s_newrate(g_bookno1,g_bookno2,
                           g_npq.npq24,g_npq25,g_npp.npp02)
            RETURNING g_npq.npq25
            LET g_npq.npq07 = g_npq.npq07f * g_npq.npq25

            LET g_npq.npq07 = cl_digcut(g_npq.npq07,t_azi04)
         ELSE
            LET g_npq.npq07 = cl_digcut(g_npq.npq07,g_azi04)  
         END IF

         INSERT INTO npq_file VALUES (g_npq.*)
         IF STATUS THEN 

            IF g_bgerr THEN
               LET g_showmsg=g_npq.npq01,"/",g_npq.npq011,"/",g_npq.npq03
               CALL s_errmsg('npq01,npq011,npq03',g_showmsg,'ins npq#10',STATUS,1)
            ELSE
               CALL cl_err3("ins","npq_file",g_npq.npq00,g_npq.npq01,STATUS,"","ins npq#10",1) 
            END IF

            LET g_success='N' 
         END IF
      END IF
   END FOREACH
END FUNCTION 
#FUN-CB0045--add--end

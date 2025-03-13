# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify.........: NO.FUN-5C0015 05/12/20 By alana
# call s_def_npq.4gl 抓取異動碼default值
# Modify..........: No.TQC-630118 06/04/06 By Smapmin 分錄修改
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680029 06/08/16 By Rayven 新增參數:分錄底稿類型
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify..........: No.MOD-680083 06/12/08 By Smapmin當貸方科目為空時,要抓取待抵帳款之單身科目與金額
# Modify.........: No.MOD-730115 07/03/27 By Smapmin 當借方科目為空時,要抓取應付帳款之單身科目
# Modify.........: No.FUN-730064 07/04/04 By dxfwo   會計科目加帳套
# Modify.........: No.MOD-740011 07/04/09 By Smapmin 分錄修改
# Modify.........: No.MOD-740499 07/05/09 By Carrier UPDATE npq_file時出現-217錯誤
# Modify.........: No.MOD-750025 07/05/11 By Smapmin 修正MOD-680083
# Modify.........: No.FUN-840006 08/04/02 By hellen  項目管理，去掉預算編號相關欄位
# Modify.........: No.MOD-850153 08/05/19 By Smapmin 分錄金額應維持正數
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0030 09/10/15 By sabrina 最後一筆差異檢核有誤
# Modify.........: No.FUN-9A0036 10/07/28 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/28 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/28 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No:CHI-AA0005 10/10/13 By Summer CALL s_def_npq時多傳aqb02
# Modify.........: No.FUN-AA0087 11/01/28 By Mengxw 異動碼類型設定的改善 
# Modify.........: No:FUN-B40056 11/05/10 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.MOD-B80077 11/08/09 By Polly 修正分錄底稿未取來源單aapt120單身部門別資料產生分錄
# Modify.........: No.MOD-B90088 11/09/14 By Polly 修正分錄底稿未取來源單aapt110單身部門別資料產生分錄
# Modify.........: No.MOD-C30890 12/03/29 By Polly 增加傳遞參數 l_ware,l_loc
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
#DEFINE   g_sql          LIKE type_file.chr1000 #No.FUN-680029  #No.FUN-690028 VARCHAR(1000) #No.MOD-B80077 mark
DEFINE   g_sql           STRING                 #No.MOD-B80077 add
DEFINE g_bookno1         LIKE aza_file.aza81    #No.FUN-730064                                                                     
DEFINE g_bookno2         LIKE aza_file.aza82    #No.FUN-730064                                                                     
DEFINE g_bookno3         LIKE aza_file.aza82    #No.FUN-730064
DEFINE   g_flag          LIKE type_file.chr1    #No.FUN-730064
DEFINE   g_npq25         LIKE npq_file.npq25    #FUN-9A0036
DEFINE   g_azi04_2       LIKE azi_file.azi04    #FUN-A40067

FUNCTION t900_g_gl(p_apno,p_npptype) #No.FUN-680029 新增p_npptype
   DEFINE p_apno	LIKE aqa_file.aqa01
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(60)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   WHENEVER ERROR CALL cl_err_msg_log
   #No:8009 add 若已拋轉總帳, 不可重新產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = p_apno AND nppglno != '' AND nppglno IS NOT NULL
      AND nppsys = 'AP'  AND npp00 = 4     AND npp011 = 1
      AND npptype = p_npptype  #No.FUN-680029
   IF l_n > 0 THEN
      CALL cl_err(p_apno,'aap-122',1) RETURN
   END IF
   #---No:8009 end
 
   SELECT COUNT(*) INTO l_n FROM npp_file WHERE nppsys = 'AP' AND npp00 = 4 
                                            AND npp01  = p_apno
                                            AND npp011 = 1 
                                            AND npptype = p_npptype  #No.FUN-680029
   IF l_n > 0 AND p_npptype = '0' THEN
      IF NOT s_ask_entry(p_apno) THEN RETURN END IF #Genero
      #FUN-B40056--add--str--
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM tic_file
       WHERE tic04 = p_apno
      IF l_n > 0 THEN
         IF NOT cl_confirm('sub-533') THEN
            RETURN
         ELSE
            DELETE FROM tic_file WHERE tic04 = p_apno
         END IF
      END IF
      #FUN-B40056--add--end--
      DELETE FROM npp_file WHERE nppsys = 'AP' AND npp00 = 4 #no.7277
                             AND npp01  = p_apno
                             AND npp011 = 1 
              #              AND npptype = p_npptype  #No.FUN-680029
      DELETE FROM npq_file WHERE npqsys = 'AP' AND npq00 = 4 #no.7277
                             AND npq01  = p_apno
                             AND npq011 = 1 
              #              AND npqtype = p_npptype  #No.FUN-680029
   END IF
   CALL t900_g_gl_1(p_apno,p_npptype)  #No.FUN-680029 新增p_npptype
END FUNCTION
 
FUNCTION t900_g_gl_1(p_apno,p_npptype) #No.FUN-680029 新增p_npptype
   DEFINE p_apno	LIKE aqa_file.aqa01
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag21       LIKE aag_file.aag21
   DEFINE l_aag23       LIKE aag_file.aag23
   DEFINE l_aqb04       LIKE aqb_file.aqb04
   DEFINE l_apa51       LIKE apa_file.apa51
  #DEFINE l_apa511      LIKE apa_file.apa511  #No.FUN-680029
   DEFINE l_aqb04_2     LIKE aqb_file.aqb04
   DEFINE l_apa51_2     LIKE apa_file.apa51
   DEFINE l_aqb02_2     LIKE aqb_file.aqb02
   DEFINE l_apa06_2     LIKE apa_file.apa06
   DEFINE l_apa07_2     LIKE apa_file.apa07
   DEFINE l_apa22_2     LIKE apa_file.apa22
   DEFINE l_apa06       LIKE apa_file.apa06
   DEFINE l_apa07       LIKE apa_file.apa07
   DEFINE l_apa22       LIKE apa_file.apa22
   DEFINE l_apa66       LIKE apa_file.apa66   
   DEFINE l_apa67       LIKE apa_file.apa67   
   DEFINE l_apa68       LIKE apa_file.apa68   
   DEFINE l_apa69       LIKE apa_file.apa69   
   DEFINE l_apa70       LIKE apa_file.apa70   
#  DEFINE l_apa71       LIKE apa_file.apa71       #No.FUN-840006 去掉apa71
   DEFINE l_sum_api05   LIKE api_file.api05
   DEFINE l_amt_api05   LIKE api_file.api05       #計算攤算後的金額
   DEFINE l_sum_api05_2 LIKE api_file.api05
   DEFINE l_amt_api05_2 LIKE api_file.api05       #計算攤算後的金額
   DEFINE l_sum_apb10_2 LIKE apb_file.apb10
   DEFINE l_amt_apb10_2 LIKE apb_file.apb10       #計算攤算後的金額
   DEFINE l_aqa		RECORD LIKE aqa_file.*
   DEFINE l_apb_2       RECORD LIKE apb_file.*
   DEFINE l_aqc		RECORD LIKE aqc_file.*
   DEFINE l_api		RECORD LIKE api_file.*
   DEFINE l_api_2       RECORD LIKE api_file.*
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_dept	LIKE type_file.chr6        # No.FUN-690028 VARCHAR(6)
   DEFINE l_actno,l_actno2 LIKE ima_file.ima39      # No.FUN-690028 VARCHAR(24)           
   DEFINE l_amt		LIKE aqa_file.aqa04
   DEFINE l_amtf        LIKE aqa_file.aqa04
  #DEFINE l_sql         LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)  #No.MOD-B80077 mark
   DEFINE l_sql         STRING                 #No.MOD-B80077 add
   DEFINE l_opendate,l_duedate	LIKE type_file.dat     #No.FUN-690028 DATE
   DEFINE l_aaa03       LIKE aaa_file.aaa03    #FUN-A40067
   DEFINE l_apb26       LIKE apb_file.apb26    #MOD-B90088
   DEFINE l_apa930      LIKE apa_file.apa930   #MOD-B90088 add
   DEFINE l_apb930      LIKE apb_file.apb930   #MOD-B90088 add
   DEFINE l_apb21       LIKE apb_file.apb21    #MOD-C30890 add
   DEFINE l_apb22       LIKE apb_file.apb22    #MOD-C30890 add
   DEFINE l_ware        LIKE ime_file.ime01    #MOD-C30890 add
   DEFINE l_loc         LIKE ime_file.ime02    #MOD-C30890 add
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
   SELECT * INTO l_aqa.* FROM aqa_file WHERE aqa01 = p_apno
   IF STATUS THEN RETURN END IF
 
   #No.FUN-730064  --Begin                                                                                                          
   CALL s_get_bookno(YEAR(l_aqa.aqa02)) RETURNING g_flag,g_bookno1,g_bookno2                                                        
   IF g_flag =  '1' THEN  #抓不到帳別                                                                                               
      CALL cl_err(l_aqa.aqa02,'aoo-081',1)                                                                                          
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
   IF p_npptype = '0' THEN                                                                                                          
      LET g_bookno3 = g_bookno1                                                                                                     
   ELSE                                                                                                                             
      LET g_bookno3 = g_bookno2                                                                                                     
   END IF                                                                                                                           
   #No.FUN-730064  --End
 
   LET l_npp.npptype = p_npptype  #No.FUN-680029
   LET l_npq.npqtype = p_npptype  #No.FUN-680029
 
   #-->單頭
   LET l_npp.nppsys = 'AP'
   LET l_npp.npp00  = 4 #no.7277
   LET l_npp.npp01  = l_aqa.aqa01 
   LET l_npp.npp011 = 1 
   LET l_npp.npp02  = l_aqa.aqa02
   LET l_npp.npp03  = NULL
   LET l_npp.npp05  = NULL
   LET l_npp.nppglno= NULL
   LET l_npp.npplegal= g_legal #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF SQLCA.sqlcode THEN 
#     CALL cl_err('insert npp_file',SQLCA.sqlcode,0)   #No.FUN-660122
      CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,SQLCA.sqlcode,"","insert npp_file",1)  #No.FUN-660122
      LET g_success = 'N' 
   END IF
   #-->單身
   LET l_npq.npqsys = 'AP'
   LET l_npq.npq00  = 4  #no.7277
   LET l_npq.npq01  = l_aqa.aqa01 
   LET l_npq.npq011 = 1 
   LET l_npq.npq21 = ' '
   LET l_npq.npq22 = ' '
# ------------------------------------ 借方 : 材料或是原料
  #No.8009 借方改取原單據借方科目，且判斷 MISC,STOCK 的狀況
  #SELECT unique apa51 INTO l_apa51 FROM apa_file,aqc_file
  # WHERE aqc01=l_aqa.aqa01
  #   AND aqc02=apa01
  #SELECT SUM(aqb04) INTO l_aqb04 FROM aqb_file,apa_file
  # WHERE aqb01=l_aqa.aqa01
  #   AND aqb02=apa01
  #   AND apa00='23'
  #No.8009 add
   LET l_npq.npq02 = 1
   DECLARE a_curs CURSOR FOR 
    SELECT * FROM aqc_file 
     WHERE aqc01 = l_aqa.aqa01
   FOREACH a_curs INTO l_aqc.* 
      IF SQLCA.sqlcode THEN
         CALL cl_err('a_curs:',SQLCA.sqlcode,1)    
         LET g_success='N' 
         EXIT FOREACH
      END IF
      IF p_npptype = '0' THEN  #No.FUN-680029
        #SELECT apa06,apa07,apa51,apa22 INTO l_apa06,l_apa07,l_apa51,l_apa22                  #MOD-B90088 mark
         SELECT apa06,apa07,apa51,apa22,apa930 INTO l_apa06,l_apa07,l_apa51,l_apa22,l_apa930  #MOD-B90088 add
           FROM apa_file
          WHERE apa01=l_aqc.aqc02
      #No.FUN-680029 --start--
      ELSE
         SELECT apa06,apa07,apa511,apa22 INTO l_apa06,l_apa07,l_apa51,l_apa22
           FROM apa_file
          WHERE apa01=l_aqc.aqc02
      END IF
      #No.FUN-680029 --end--
   #---->單一借方
      IF NOT cl_null(l_apa51) AND l_apa51 != 'UNAP' AND
         l_apa51 != 'MISC' AND l_apa51 != 'STOCK' THEN
          LET l_npq.npq03 = l_apa51
          SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23 FROM aag_file
           WHERE aag01=l_npq.npq03
             AND aag00 = g_bookno3   #No.FUN-730064  
          LET l_npq.npq04 = ' '
          IF l_aag05='Y' THEN
             IF g_aaz.aaz90='N' THEN        #MOD-B90088 add
                LET l_npq.npq05 = l_apa22 
             ELSE                           #MOD-B90088 add
                LET l_npq.npq05 = l_apa930  #MOD-B90088 add
             END IF                         #MOD-B90088 add
          ELSE
             LET l_npq.npq05 = ''           
          END IF
          LET l_npq.npq06 = '1'    
          LET l_npq.npq21 = l_apa06    
          LET l_npq.npq22 = l_apa07    
          LET l_npq.npq23 = l_aqc.aqc02
          LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
          LET l_npq.npq25 = 1                        #匯率
          LET g_npq25  = l_npq.npq25  #FUN-9A0036
          LET l_npq.npq07f= l_aqc.aqc08-l_aqc.aqc06
          LET l_npq.npq07 = l_aqc.aqc08-l_aqc.aqc06
          IF cl_null(l_npq.npq07) THEN 
             LET l_npq.npq07=0
          END IF
          IF cl_null(l_npq.npq07f) THEN 
             LET l_npq.npq07f=0
          END IF
          #NO.FUN-5C0015 ---start
#         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')   #No.FUN-730064
         #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.FUN-730064 #CHI-AA0005 mark
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  #CHI-AA0005
          RETURNING l_npq.*
          CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq34,l_npq.npq34     #FUN-AA0087
          #No.FUN-5C0015 ---end
          #-----MOD-850153---------
          IF g_aza.aza26 <> '2' THEN
             IF l_npq.npq07 < 0 THEN
                LET l_npq.npq06 = '2' 
                LET l_npq.npq07f= l_npq.npq07f* -1
                LET l_npq.npq07 = l_npq.npq07 * -1
             END IF
          END IF
#No.FUN-9A0036 --Begin
          IF p_npptype = '1' THEN
#FUN-A40067 --Begin
             SELECT aaa03 INTO l_aaa03 FROM aaa_file
              WHERE aaa01 = g_bookno2
             SELECT azi04 INTO g_azi04_2 FROM azi_file
              WHERE azi01 = l_aaa03
#FUN-A40067 --End
             CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                            g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
             LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067
          ELSE
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
          END IF
#No.FUN-9A0036 --End
          #-----END MOD-850153-----
          LET l_npq.npqlegal = g_legal #FUN-980001 add
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
          MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                      l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN
#           CALL cl_err('a_curs ins:',SQLCA.sqlcode,1)    #No.FUN-660122
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","a_curs ins:",1)  #No.FUN-660122
            LET g_success='N'
         END IF
     END IF
     #-----MOD-730115---------
     #---->借方科目為空
     IF cl_null(l_apa51) THEN
       #SELECT apb25 INTO l_apa51 FROM apb_file,aqc_file                               #MOD-B90088 mark
        SELECT apb25,apb26,apb930 INTO l_apa51,l_apb26,l_apb930 FROM apb_file,aqc_file #MOD-B90088 add
          WHERE aqc01 = l_aqa.aqa01
            AND aqc02 = l_aqc.aqc02
            AND apb01 = l_aqc.aqc02
            AND apb02 = l_aqc.aqc03
         LET l_npq.npq03 = l_apa51
         SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23 FROM aag_file
          WHERE aag01=l_npq.npq03
            AND aag00 = g_bookno3   #No.FUN-730064           
         LET l_npq.npq04 = ' '
         IF l_aag05='Y' THEN
           #LET l_npq.npq05 = l_apa22          #No.MOD-B90088 mark
            IF g_aaz.aaz90='N' THEN            #MOD-B90088 add
               LET l_npq.npq05 = l_apb26       #No.MOD-B90088 add
            ELSE                               #MOD-B90088 add
               LET l_npq.npq05 = l_apb930      #MOD-B90088 add
            END IF                             #MOD-B90088 add 
         ELSE
            LET l_npq.npq05 = ''           
         END IF
         LET l_npq.npq06 = '1'    
         LET l_npq.npq21 = l_apa06    
         LET l_npq.npq22 = l_apa07    
         LET l_npq.npq23 = l_aqc.aqc02
         LET l_npq.npq24 = g_aza.aza17              
         LET l_npq.npq25 = 1                        
         LET g_npq25  = l_npq.npq25  #FUN-9A0036
         LET l_npq.npq07f= l_aqc.aqc08-l_aqc.aqc06
         LET l_npq.npq07 = l_aqc.aqc08-l_aqc.aqc06
         IF cl_null(l_npq.npq07) THEN 
            LET l_npq.npq07=0
         END IF
         IF cl_null(l_npq.npq07f) THEN 
            LET l_npq.npq07f=0
         END IF
         #-----MOD-850153---------
         IF g_aza.aza26 <> '2' THEN
            IF l_npq.npq07 < 0 THEN
               LET l_npq.npq06 = '2' 
               LET l_npq.npq07f= l_npq.npq07f* -1
               LET l_npq.npq07 = l_npq.npq07 * -1
            END IF
         END IF
         #-----END MOD-850153-----
#No.FUN-9A0036 --Begin
          IF p_npptype = '1' THEN
#FUN-A40067 --Begin
            SELECT aaa03 INTO l_aaa03 FROM aaa_file
             WHERE aaa01 = g_bookno2
            SELECT azi04 INTO g_azi04_2 FROM azi_file
             WHERE azi01 = l_aaa03
#FUN-A40067 --End
             CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                            g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
             LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
         ELSE
            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
          END IF
#No.FUN-9A0036 --End
         LET l_npq.npqlegal = g_legal #FUN-980001 add
         #FUN-D10065--add--str--
         LET l_npq.npq04 = NULL
         CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','')
         RETURNING l_npq.npq04
         #FUN-D10065--add--end--
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
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                     l_npq.npq06,' ',l_npq.npq07
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","ins npq",1) 
           LET g_success='N'
        END IF
     END IF
     #-----END MOD-730115-----
     #--->MISC/UNAP
     IF l_apa51 = 'MISC' OR l_apa51 = 'UNAP' THEN
        #--計算總合
        SELECT SUM(api05) INTO l_sum_api05 FROM api_file
         WHERE api01=l_aqc.aqc02
        IF cl_null(l_sum_api05) THEN LET l_sum_api05=0 END IF
        LET l_amt_api05 = 0
        #--計算每筆
        DECLARE b_curs CURSOR FOR
           SELECT * FROM api_file WHERE api01 = l_aqc.aqc02
        FOREACH b_curs INTO l_api.*
           IF STATUS THEN 
              CALL cl_err('b_curs:',SQLCA.sqlcode,1)    
              LET g_success='N' 
              EXIT FOREACH
           END IF
           IF p_npptype = '0' THEN  #No.FUN-680029
              LET l_npq.npq03 = l_api.api04
           #No.FUN-680029 --start--
           ELSE
              LET l_npq.npq03 = l_api.api041
           END IF
           #No.FUN-680029 --end--
           LET l_npq.npq04 = NULL          #FUN-D10065  add
          #LET l_npq.npq04 = l_api.api06    #FUN-D10065 mark
           LET l_npq.npq06 = '1'
           LET l_npq.npq21 = l_apa06    
           LET l_npq.npq22 = l_apa07    
           LET l_npq.npq23 = l_aqc.aqc02
           LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
           LET l_npq.npq25 = 1                        #匯率
           LET g_npq25  = l_npq.npq25                 #FUN-9A0036
           IF l_sum_api05!=0 THEN
              LET l_npq.npq07 = (l_aqc.aqc08-l_aqc.aqc06)*l_api.api05/l_sum_api05
              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
           ELSE
              LET l_npq.npq07 = 0
           END IF
           LET l_npq.npq07f=l_npq.npq07      
           IF cl_null(l_npq.npq07) THEN 
              LET l_npq.npq07=0
           END IF
           IF cl_null(l_npq.npq07f) THEN 
              LET l_npq.npq07f=0
           END IF
           LET l_amt_api05 = l_amt_api05 + l_npq.npq07
           SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23 FROM aag_file
            WHERE aag01=l_npq.npq03
              AND aag00 = g_bookno3   #No.FUN-730064
           IF l_aag23 = 'Y' THEN
              LET l_npq.npq08 = l_api.api26    # 專案
           ELSE
              LET l_npq.npq08 = null
           END IF
           #No.FUN-840006 mark 080402 --begin
#          IF l_aag21='Y' THEN
#             LET l_npq.npq15 = l_api.api25    # 預算
#          END IF
           #No.FUN-840006 mark 080402 --end
           IF l_aag05='Y' THEN
              IF g_aaz.aaz90='N' THEN                       #MOD-B90088 add
                 LET l_npq.npq05 = l_api.api07
              ELSE                                          #MOD-B90088 add
                 LET l_npq.npq05 = l_api.api930             #MOD-B90088 add
              END IF                                        #MOD-B90088 add
           ELSE
              LET l_npq.npq05 = ''           
           END IF
           LET l_npq.npq11=l_api.api21
           LET l_npq.npq12=l_api.api22
           LET l_npq.npq13=l_api.api23
           LET l_npq.npq14=l_api.api24
           SELECT apa06,apa07 INTO l_apa06,l_apa07 FROM apa_file
            WHERE apa01=l_aqc.aqc02
           LET l_npq.npq21 = l_apa06    
           LET l_npq.npq22 = l_apa07    
           LET l_npq.npq23 = l_aqc.aqc02
           ##
           IF l_npq.npq07!=0 THEN 
              #NO.FUN-5C0015 ---start
#             CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')  #No.FUN-730064
             #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.FUN-730064 #CHI-AA0005 mark
              CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  #CHI-AA0005
              RETURNING l_npq.*
              #FUN-D10065--add--str--
              IF cl_null(l_npq.npq04) THEN
                 LET l_npq.npq04 = l_api.api06
              END IF
              #FUN-D10065--add--end--
              CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
              #No.FUN-5C0015 ---end
              #-----MOD-850153---------
              IF g_aza.aza26 <> '2' THEN
                 IF l_npq.npq07 < 0 THEN
                    LET l_npq.npq06 = '2' 
                    LET l_npq.npq07f= l_npq.npq07f* -1
                    LET l_npq.npq07 = l_npq.npq07 * -1
                 END IF
              END IF
              #-----END MOD-850153-----
#No.FUN-9A0036 --Begin
          IF p_npptype = '1' THEN
#FUN-A40067 --Begin
                 SELECT aaa03 INTO l_aaa03 FROM aaa_file
                  WHERE aaa01 = g_bookno2
                 SELECT azi04 INTO g_azi04_2 FROM azi_file
                  WHERE azi01 = l_aaa03
#FUN-A40067 --End
             CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                            g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
             LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#                LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
              ELSE
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
          END IF
#No.FUN-9A0036 --End
              LET l_npq.npqlegal = g_legal #FUN-980001 add
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
              MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                      l_npq.npq07
              IF STATUS THEN 
#                CALL cl_err('t900 b_curs ins:',STATUS,1)    #No.FUN-660122
                 CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t900 b_curs ins:",1)  #No.FUN-660122
                 LET g_success='N' 
                 EXIT FOREACH 
              ELSE
                 LET l_npq.npq02 = l_npq.npq02 + 1
              END IF
           END IF
          END FOREACH
          #--差異歸到最後一筆,與aapt810原則相同
          #LET l_npq.npq07 = l_npq.npq07 + (l_sum_api05 - l_amt_api05)   #MOD-740011
          LET l_npq.npq07 = l_npq.npq07 + ((l_aqc.aqc08-l_aqc.aqc06) - l_amt_api05)   #MOD-740011
          LET l_npq.npq07f = l_npq.npq07
          UPDATE npq_file SET npq07 = l_npq.npq07,npq07f =l_npq.npq07f
            WHERE npq01 = l_npq.npq01 AND npq02 = l_npq.npq02-1    #因為剛才npq02已先加一了,所以要減掉才會是最後一筆
              AND npq00 = 4 AND npqsys='AP'
#             AND npqtype = npptype        #No.FUN-680029  #No.MOD-740499
              AND npqtype = l_npq.npqtype  #No.FUN-680029  #No.MOD-740499
          IF STATUS THEN 
#         CALL cl_err('upd npq:',SQLCA.sqlcode,1) #No.FUN-660122
          CALL cl_err3("upd","npq_file",l_npq.npq01,l_npq.npq02-1,SQLCA.sqlcode,"","upd npq:",1)  #No.FUN-660122
          LET g_success = 'N' END IF
       END IF
   #--->STOCK
   IF l_apa51 = 'STOCK' THEN
     #-----TQC-630118---------
     #SELECT apb25 INTO l_npq.npq03 FROM apb_file
     # WHERE apb01=l_aqc.aqc02 AND apb02=l_aqc.aqc03
     #------------------------------MOD-C30890------------------------------------------(S)
       SELECT apb21,apb22 INTO l_apb21,l_apb22 FROM apb_file
        WHERE apb01 = l_aqc.aqc02
          AND apb02 = l_aqc.aqc03
       SELECT rvv32,rvv33 INTO l_ware,l_loc FROM rvv_file
        WHERE rvv01 = l_apb21
          AND rvv02 = l_apb22
      CALL t910_stock_act(l_aqc.aqc02,l_aqc.aqc03,p_npptype,l_ware,l_loc)
     #CALL t910_stock_act(l_aqc.aqc02,l_aqc.aqc03,p_npptype) #No.FUN-680029 新增p_npptype  #MOD-C30890 mark
     #------------------------------MOD-C30890-------------------------------------------(E)
      RETURNING l_npq.npq03
     #-----END TQC-630118-----
      LET l_npq.npq04 = ' '
      SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23 FROM aag_file
       WHERE aag01=l_npq.npq03
         AND aag00 = g_bookno3   #No.FUN-730064
     #SELECT apa06,apa07,apa22 INTO l_apa06,l_apa07,l_apa22 FROM apa_file                  #MOD-B90088 mark
      SELECT apa06,apa07,apa22,apa930 INTO l_apa06,l_apa07,l_apa22,l_apa930 FROM apa_file  #MOD-B90088 add
       WHERE apa01=l_aqc.aqc02
      IF l_aag05='Y' THEN
         IF g_aaz.aaz90='N' THEN            #MOD-B90088 add
            LET l_npq.npq05 = l_apa22 
         ELSE                               #MOD-B90088 add
            LET l_npq.npq05 = l_apa930      #MOD-B90088 add
         END IF                             #MOD-B90088 add
      ELSE
         LET l_npq.npq05 = ''           
      END IF
      LET l_npq.npq06 = '1'    
      LET l_npq.npq21 = l_apa06    
      LET l_npq.npq22 = l_apa07    
      LET l_npq.npq23 = l_aqc.aqc02
      LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
      LET l_npq.npq25 = 1                        #匯率
      LET g_npq25  = l_npq.npq25                 #FUN-9A0036
      LET l_npq.npq07f= l_aqc.aqc08-l_aqc.aqc06
      LET l_npq.npq07 = l_aqc.aqc08-l_aqc.aqc06
      IF cl_null(l_npq.npq07) THEN 
         LET l_npq.npq07=0
      END IF
      IF cl_null(l_npq.npq07f) THEN 
         LET l_npq.npq07f=0
      END IF
      #NO.FUN-5C0015 ---start
#     CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')   #No.FUN-730064
     #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.FUN-730064 #CHI-AA005 mark
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  #CHI-AA0005
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34  #FUN-AA0087
      #No.FUN-5C0015 ---end
      #-----MOD-850153---------
      IF g_aza.aza26 <> '2' THEN
         IF l_npq.npq07 < 0 THEN
            LET l_npq.npq06 = '2' 
            LET l_npq.npq07f= l_npq.npq07f* -1
            LET l_npq.npq07 = l_npq.npq07 * -1
         END IF
      END IF
      #-----END MOD-850153-----
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
      END IF
#No.FUN-9A0036 --End
      LET l_npq.npqlegal = g_legal #FUN-980001 add
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
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                  l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN
#        CALL cl_err('d:stock ins:',SQLCA.sqlcode,1)    #No.FUN-660122
         CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","d:stock ins:",1)  #No.FUN-660122
         LET g_success='N'
      END IF
    END IF
    LET l_npq.npq02 = l_npq.npq02 + 1
  END FOREACH
  #No.8009 add (end)
# ------------------------------------ 貸方 : 費用或預付
#No.FUN-680029 --start--
#  DECLARE t900_gl_c2 CURSOR FOR
#     SELECT aqb02,apa06,apa07,aqb04,apa51,apa22,apa66,apa67,apa68,
#            apa69,apa70,apa71
#       FROM aqb_file,apa_file
#      WHERE aqb01 = l_aqa.aqa01 
#        AND aqb02 = apa01
#     #  AND apa00 = '23'       #No:8009不限23的才產生分錄
#      ORDER BY 1
   IF p_npptype = '0' THEN
      LET g_sql = " SELECT aqb02,apa06,apa07,aqb04,apa51,apa22,",
                  "        apa66,apa67,apa68,apa69,apa70,apa930 ",     #No.FUN-840006 去掉apa71字段 #MOD-B90088 add apa930
                  "   FROM aqb_file,apa_file ",
                  "  WHERE aqb01 = '",l_aqa.aqa01,"'",
                  "    AND aqb02 = apa01 ",
                  "  ORDER BY aqb02 "
   ELSE
      LET g_sql = " SELECT aqb02,apa06,apa07,aqb04,apa511,apa22,",
                  "        apa66,apa67,apa68,apa69,apa70,apa930 ",     #No.FUN-840006 去掉apa71字段 #MOD-B90088 add apa930
                  "   FROM aqb_file,apa_file ",
                  "  WHERE aqb01 = '",l_aqa.aqa01,"'",
                  "    AND aqb02 = apa01 ",
                  "  ORDER BY aqb02 "
   END IF
   PREPARE t900_gl_p2 FROM g_sql
   DECLARE t900_gl_c2 CURSOR FOR t900_gl_p2
#No.FUN-680029 --end--
   FOREACH t900_gl_c2 INTO l_aqb02_2,l_apa06_2,l_apa07_2,l_aqb04_2,
                           l_apa51_2,l_apa22_2,l_apa66,l_apa67,l_apa68,
                           l_apa69,l_apa70,l_apa930     #No.FUN-840006 去掉l_apa71 #MOD-B90088 add l_apa930
   #---->單一借方
      IF NOT cl_null(l_apa51_2) AND l_apa51_2 != 'UNAP' AND
         l_apa51_2 != 'MISC' AND l_apa51_2 != 'STOCK' THEN
          LET l_npq.npq03 = l_apa51_2
          LET l_npq.npq04 = ' '
          SELECT aag05 INTO l_aag05 FROM aag_file
           WHERE aag01=l_npq.npq03
             AND aag00 = g_bookno3   #No.FUN-730064
          IF l_aag05='Y' THEN
             IF g_aaz.aaz90='N' THEN            #MOD-B90088 add
                LET l_npq.npq05 = l_apa22_2
             ELSE                               #MOD-B90088 add
                LET l_npq.npq05 = l_apa930      #MOD-B90088 add
             END IF                             #MOD-B90088 add
          ELSE
             LET l_npq.npq05 = ' '     
          END IF
          LET l_npq.npq06 = '2'    
          LET l_npq.npq21 = l_apa06_2
          LET l_npq.npq22 = l_apa07_2
          LET l_npq.npq23 = l_aqb02_2
          LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
          LET l_npq.npq25 = 1                        #匯率
          LET g_npq25  = l_npq.npq25                 #FUN-9A0036
          LET l_npq.npq07f= l_aqb04_2
          LET l_npq.npq07 = l_aqb04_2
          IF cl_null(l_npq.npq07) THEN 
             LET l_npq.npq07=0
          END IF
          IF cl_null(l_npq.npq07f) THEN 
             LET l_npq.npq07f=0
          END IF
          #NO.FUN-5C0015 ---start
#         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')   #No.FUN-730064
         #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.FUN-730064 #CHI-AA0005 mark
          CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  #CHI-AA0005
          RETURNING l_npq.*
          CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34    #FUN-AA0087
          #No.FUN-5C0015 ---end
          #-----MOD-850153---------
          IF g_aza.aza26 <> '2' THEN
             IF l_npq.npq07 < 0 THEN
                LET l_npq.npq06 = '1' 
                LET l_npq.npq07f= l_npq.npq07f* -1
                LET l_npq.npq07 = l_npq.npq07 * -1
             END IF
          END IF
          #-----END MOD-850153-----
#No.FUN-9A0036 --Begin
          IF p_npptype = '1' THEN
#FUN-A40067 --Begin
             SELECT aaa03 INTO l_aaa03 FROM aaa_file
              WHERE aaa01 = g_bookno2
             SELECT azi04 INTO g_azi04_2 FROM azi_file
              WHERE azi01 = l_aaa03
#FUN-A40067 --End
             CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                            g_npq25,l_npp.npp02)
             RETURNING l_npq.npq25
             LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067
          ELSE
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
          END IF
#No.FUN-9A0036 --End
          LET l_npq.npqlegal = g_legal #FUN-980001 add
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
          MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                      l_npq.npq06,' ',l_npq.npq07
         IF SQLCA.sqlcode THEN
#           CALL cl_err('gl_c2 ins:',SQLCA.sqlcode,1)    #No.FUN-660122
            CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","gl_c2 ins:",1)  #No.FUN-660122
            LET g_success='N'
         END IF
     END IF
     #-----MOD-680083---------
     #---->貸方科目為空
     IF cl_null(l_apa51_2) THEN
        CALL t900_gl_ins_npq(p_apno,l_aqb02_2,g_aza.aza17,1,l_npq.npq02,l_aqb04_2,l_apa06_2,l_apa07_2,l_apa22_2,p_npptype)
             RETURNING l_npq.npq02
        CONTINUE FOREACH
     END IF
     #-----END MOD-680083-----
     #--->MISC/UNAP
     IF l_apa51_2 = 'MISC' OR l_apa51_2 = 'UNAP' THEN
        #--計算總合
        IF p_npptype = '0' THEN  #No.FUN-680029
           SELECT SUM(api05) INTO l_sum_api05_2 FROM api_file
            WHERE api01=l_aqb02_2   
        #No.FUN-680029 --start--
              AND (api04 IS NOT NULL AND api04 <> ' ')
        ELSE
           SELECT SUM(api05) INTO l_sum_api05_2 FROM api_file
            WHERE api01=l_aqb02_2   
              AND (api041 IS NOT NULL AND api041 <> ' ')
        END IF
        #No.FUN-680029 --end--
        IF cl_null(l_sum_api05_2) THEN LET l_sum_api05_2=0 END IF
        LET l_amt_api05_2 = 0
        #--計算每筆
#No.FUN-680029 --start--
#       DECLARE b_curs_2 CURSOR FOR
#          SELECT * FROM api_file WHERE api01 = l_aqb02_2   
        IF p_npptype = '0' THEN
           LET g_sql = " SELECT * FROM api_file ",
                       "  WHERE api01 = '",l_aqb02_2,"'",
                       "    AND (api04 IS NOT NULL AND api04 <> ' ')"
        ELSE
           LET g_sql = " SELECT * FROM api_file ",
                       "  WHERE api01 = '",l_aqb02_2,"'",
                       "    AND (api041 IS NOT NULL AND api041 <> ' ')"
        END IF
        PREPARE b_pre_2 FROM g_sql
        DECLARE b_curs_2 CURSOR FOR b_pre_2
#No.FUN-680029 --end--
        FOREACH b_curs_2 INTO l_api_2.*
           IF STATUS THEN 
              CALL cl_err('b_curs_2:',SQLCA.sqlcode,1)    
              LET g_success='N' 
              EXIT FOREACH
           END IF
           IF p_npptype = '0' THEN  #No.FUN-680029
              LET l_npq.npq03 = l_api_2.api04
           #No.FUN-680029 --start--
           ELSE
              LET l_npq.npq03 = l_api_2.api041
           END IF
           #No.FUN-680029 --end--
          #LET l_npq.npq04 = l_api_2.api06    #FUN-D10065 mark
           LET l_npq.npq04 = NULL            #FUN-D10065  add
           LET l_npq.npq06 = '2'
           SELECT apa06,apa07 INTO l_apa06_2,l_apa07_2 FROM apa_file
            WHERE apa01=l_aqb02_2
           LET l_npq.npq21 = l_apa06_2
           LET l_npq.npq22 = l_apa07_2
           LET l_npq.npq23 = l_aqb02_2
           LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
           LET l_npq.npq25 = 1                        #匯率
           LET g_npq25  = l_npq.npq25                 #FUN-9A0036
           IF l_sum_api05_2!=0 THEN
              LET l_npq.npq07 = l_aqb04_2*l_api_2.api05/l_sum_api05_2
              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
           ELSE
              LET l_npq.npq07 = 0
           END IF
           LET l_npq.npq07f=l_npq.npq07      
           IF cl_null(l_npq.npq07) THEN 
              LET l_npq.npq07=0
           END IF
           IF cl_null(l_npq.npq07f) THEN 
              LET l_npq.npq07f=0
           END IF
           LET l_amt_api05_2 = l_amt_api05_2 + l_npq.npq07
           SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23 FROM aag_file
            WHERE aag01=l_npq.npq03
              AND aag00 = g_bookno3   #No.FUN-730064
           IF l_aag23 = 'Y' THEN
              LET l_npq.npq08 = l_api_2.api26    # 專案
           ELSE
              LET l_npq.npq08 = null
           END IF
           #No.FUN-840006 mark 080402 --begin
#          IF l_aag21='Y' THEN
#             LET l_npq.npq15 = l_api_2.api25    # 預算
#          END IF
           #No.FUN-840006 mark 080402 --end
           IF l_aag05='Y' THEN
              IF g_aaz.aaz90='N' THEN              #MOD-B90088 add
                 LET l_npq.npq05 = l_api_2.api07
              ELSE                                 #MOD-B90088 add
                 LET l_npq.npq05 = l_api_2.api930  #MOD-B90088 add
              END IF                               #MOD-B90088 add
           ELSE
              LET l_npq.npq05 = ''           
           END IF
           LET l_npq.npq11=l_api_2.api21
           LET l_npq.npq12=l_api_2.api22
           LET l_npq.npq13=l_api_2.api23
           LET l_npq.npq14=l_api_2.api24
           ##
           IF l_npq.npq07!=0 THEN 
              #NO.FUN-5C0015 ---start
#             CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')    #No.FUN-730064
             #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.FUN-730064 #CHI-AA0005 mark
              CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  #CHI-AA0005
              RETURNING l_npq.*
              #FUN-D10065--add--str--
              IF cl_null(l_npq.npq04) THEN
                 LET l_npq.npq04 = l_api_2.api06
              END IF
              #FUN-D10065--add--end--
              CALL s_def_npq31_npq34(l_npq.*,g_bookno3)  RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34     #FUN-AA0087
              #No.FUN-5C0015 ---end
              #-----MOD-850153---------
              IF g_aza.aza26 <> '2' THEN
                 IF l_npq.npq07 < 0 THEN
                    LET l_npq.npq06 = '1' 
                    LET l_npq.npq07f= l_npq.npq07f* -1
                    LET l_npq.npq07 = l_npq.npq07 * -1
                 END IF
              END IF
              #-----END MOD-850153-----
#No.FUN-9A0036 --Begin
              IF p_npptype = '1' THEN
#FUN-A40067 --Begin
                 SELECT aaa03 INTO l_aaa03 FROM aaa_file
                  WHERE aaa01 = g_bookno2
                 SELECT azi04 INTO g_azi04_2 FROM azi_file
                  WHERE azi01 = l_aaa03
#FUN-A40067 --End
                 CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                                g_npq25,l_npp.npp02)
                 RETURNING l_npq.npq25
                 LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#                LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067
              ELSE
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
              END IF
#No.FUN-9A0036 --End
              LET l_npq.npqlegal = g_legal #FUN-980001 add
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
              MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                      l_npq.npq07
              IF STATUS THEN 
#                CALL cl_err('t900 b_curs_2 ins:',STATUS,1)    #No.FUN-660122
                 CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t900 b_curs_2 ins:",1)  #No.FUN-660122
                 LET g_success='N' 
                 EXIT FOREACH 
              ELSE
                 LET l_npq.npq02 = l_npq.npq02 + 1
              END IF
           END IF
          END FOREACH
          #--差異歸到最後一筆,與aapt810原則相同
          #LET l_npq.npq07 = l_npq.npq07 + (l_sum_api05_2 - l_amt_api05_2)   #MOD-740011
          LET l_npq.npq07 = l_npq.npq07 + (l_aqb04_2 - l_amt_api05_2)   #MOD-740011
          LET l_npq.npq07f = l_npq.npq07
          UPDATE npq_file SET npq07 = l_npq.npq07,npq07f =l_npq.npq07f
            WHERE npq01 = l_npq.npq01 AND npq02 = l_npq.npq02-1    #因為剛才npq02已先加一了,所以要減掉才會是最後一筆
              AND npq00 = 4 AND npqsys='AP'
#             AND npqtype = npptype        #No.FUN-680029  #No.MOD-740499
              AND npqtype = l_npq.npqtype  #No.FUN-680029  #No.MOD-740499
          IF STATUS THEN 
#         CALL cl_err('upd npq#2:',SQLCA.sqlcode,1) #No.FUN-660122
          CALL cl_err3("upd","npq_file",l_npq.npq01,l_npq.npq02-1,SQLCA.sqlcode,"","upd npq#2:",1)  #No.FUN-660122
          LET g_success = 'N' END IF
     END IF
   #--->STOCK
   #IF l_apa51_2 = 'STOCK' THEN     #No:B065   #TQC-630118
   #IF l_apa51_2 = 'STOCK' OR cl_null(l_apa51_2) THEN    #TQC-630118   #TQC-680083
   IF l_apa51_2 = 'STOCK' THEN    #TQC-630118   #TQC-680083
      #--計算總合
      SELECT SUM(apb10) INTO l_sum_apb10_2 FROM apb_file
       WHERE apb01=l_aqb02_2   
        IF cl_null(l_sum_apb10_2) THEN LET l_sum_apb10_2=0 END IF
        LET l_amt_apb10_2 = 0
        #--計算每筆
        DECLARE c_curs_2 CURSOR FOR
           SELECT * FROM apb_file WHERE apb01 = l_aqb02_2   
        FOREACH c_curs_2 INTO l_apb_2.*
           IF STATUS THEN 
              CALL cl_err('c_curs_2:',SQLCA.sqlcode,1)   
              LET g_success='N' 
              EXIT FOREACH
           END IF
           IF p_npptype = '0' THEN  #No.FUN-680029
              LET l_npq.npq03 = l_apb_2.apb25
           #No.FUN-680029 --start--
           ELSE
              LET l_npq.npq03 = l_apb_2.apb251
           END IF
           #No.FUN-680029 --end--
           LET l_npq.npq04 = ' '
           LET l_npq.npq06 = '2'
           SELECT apa06,apa07 INTO l_apa06_2,l_apa07_2 FROM apa_file
            WHERE apa01=l_aqb02_2
           LET l_npq.npq21 = l_apa06_2
           LET l_npq.npq22 = l_apa07_2
           LET l_npq.npq23 = l_aqb02_2
           LET l_npq.npq24 = g_aza.aza17              #幣別為本幣
           LET l_npq.npq25 = 1                        #匯率
           LET g_npq25  = l_npq.npq25                 #FUN-9A0036
           IF l_sum_apb10_2!=0 THEN
              LET l_npq.npq07 = l_aqb04_2*l_apb_2.apb10/l_sum_apb10_2
              LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
           ELSE
              LET l_npq.npq07 = 0
           END IF
           LET l_npq.npq07f=l_npq.npq07      
           IF cl_null(l_npq.npq07) THEN 
              LET l_npq.npq07=0
           END IF
           IF cl_null(l_npq.npq07f) THEN 
              LET l_npq.npq07f=0
           END IF
           LET l_amt_apb10_2 = l_amt_apb10_2 + l_npq.npq07
           SELECT aag05,aag21,aag23 INTO l_aag05,l_aag21,l_aag23 FROM aag_file
            WHERE aag01=l_npq.npq03 
              AND aag00 = g_bookno3   #No.FUN-730064
           IF l_aag23 = 'Y' THEN
              LET l_npq.npq08 = l_apa66    # 專案
           ELSE
              LET l_npq.npq08 = null
           END IF
           #No.FUN-840006 mark 080402 --begin
#          IF l_aag21='Y' THEN
#             LET l_npq.npq15 = l_apa71    # 預算
#          END IF
           #No.FUN-840006 mark 080402 --end
           IF l_aag05='Y' THEN
             #LET l_npq.npq05 = l_apa22_2             #MOD-B90088 mark
              IF g_aaz.aaz90='N' THEN                 #MOD-B90088 add
                 LET l_npq.npq05 = l_apb_2.apb26      #MOD-B90088 add
              ELSE                                    #MOD-B90088 add
                 LET l_npq.npq05 = l_apb_2.apb930     #MOD-B90088 add
              END IF                                  #MOD-B90088 add
           ELSE
              LET l_npq.npq05 = ''           
           END IF
           LET l_npq.npq11=l_apa67
           LET l_npq.npq12=l_apa68
           LET l_npq.npq13=l_apa69
           LET l_npq.npq14=l_apa70
           ##
           IF l_npq.npq07!=0 THEN 
              #NO.FUN-5C0015 ---start
#             CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')   #No.FUN-730064
             #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.FUN-730064 #CHI-AA0005 mark
              CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_aqb02_2,'',g_bookno3)  #CHI-AA0005
              RETURNING l_npq.*
              CALL s_def_npq31_npq34(l_npq.*,g_bookno3) RETURNING  l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34     #FUN-AA0087
              #No.FUN-5C0015 ---end
              #-----MOD-850153---------
              IF g_aza.aza26 <> '2' THEN
                 IF l_npq.npq07 < 0 THEN
                    LET l_npq.npq06 = '1' 
                    LET l_npq.npq07f= l_npq.npq07f* -1
                    LET l_npq.npq07 = l_npq.npq07 * -1
                 END IF
              END IF
              #-----END MOD-850153-----
#No.FUN-9A0036 --Begin
              IF p_npptype = '1' THEN
#FUN-A40067 --Begin
                 SELECT aaa03 INTO l_aaa03 FROM aaa_file                        
                  WHERE aaa01 = g_bookno2
                 SELECT azi04 INTO g_azi04_2 FROM azi_file                      
                  WHERE azi01 = l_aaa03
#FUN-A40067 --End
                 CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,                
                                g_npq25,l_npp.npp02)
                 RETURNING l_npq.npq25
                 LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#                LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
              ELSE
                 LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
              END IF
#No.FUN-9A0036 --End
              LET l_npq.npqlegal = g_legal #FUN-980001 add
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
              MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',
                      l_npq.npq07
              IF STATUS THEN 
#                CALL cl_err('t900 b_curs_3 ins:',STATUS,1)    #No.FUN-660122
                 CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,STATUS,"","t900 b_curs_3 ins:",1)  #No.FUN-660122
                 LET g_success='N' 
                 EXIT FOREACH 
              ELSE
                 LET l_npq.npq02 = l_npq.npq02 + 1
              END IF
           END IF
          END FOREACH
          #--差異歸到最後一筆,與aapt810原則相同
         #LET l_npq.npq07 = l_npq.npq07 + (l_sum_apb10_2 - l_amt_apb10_2)      #MOD-9A0030 mark
          LET l_npq.npq07 = l_npq.npq07 + (l_aqb04_2 - l_amt_apb10_2)          #MOD-9A0030 add
          LET l_npq.npq07f = l_npq.npq07
          UPDATE npq_file SET npq07 = l_npq.npq07,npq07f =l_npq.npq07f
            WHERE npq01 = l_npq.npq01 AND npq02 = l_npq.npq02-1    #因為剛才npq02已先加一了,所以要減掉才會是最後一筆
              AND npq00 = 4 AND npqsys='AP'
              AND npqtype = p_npptype  #No.FUN-680029
          IF STATUS THEN 
#         CALL cl_err('upd npq#3:',SQLCA.sqlcode,1) #No.FUN-660122
          CALL cl_err3("upd","npq_file",l_npq.npq01,l_npq.npq02-1,SQLCA.sqlcode,"","upd npq#3:",1)  #No.FUN-660122
          LET g_success = 'N' END IF
       END IF
       LET l_npq.npq02 = l_npq.npq02 + 1
     END FOREACH
# ------------------------------------
   CALL t110_gen_diff(l_npp.*) #FUN-A40033
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
#-----TQC-630118---------
#FUNCTION t910_stock_act(p_apb01,p_apb02,p_npptype)  #No.FUN-680029 新增p_npptype  #MOD-C30890 mark
FUNCTION t910_stock_act(p_apb01,p_apb02,p_npptype,p_ware,p_loc)  #MOD-C30890 add
  DEFINE p_apb01    LIKE apb_file.apb01
  DEFINE p_apb02    LIKE apb_file.apb02
  DEFINE p_npptype  LIKE npp_file.npptype  #No.FUN-680029
  DEFINE p_item     LIKE ima_file.ima01
  DEFINE p_ware     LIKE ime_file.ime01
  DEFINE p_loc      LIKE ime_file.ime02
  DEFINE l_actno    LIKE aag_file.aag01
  DEFINE g_ccz07    LIKE ccz_file.ccz07
 
  SELECT apb12 INTO p_item
    FROM apb_file
   WHERE apb01=p_apb01 AND apb02=p_apb02
 
  SELECT ccz07 INTO g_ccz07 FROM ccz_file WHERE ccz00='0'
 
  CASE WHEN g_ccz07='1' IF p_npptype = '0' THEN  #No.FUN-680029
                           SELECT ima39 INTO l_actno FROM ima_file
                            WHERE ima01=p_item
                        #No.FUN-680029 --start--
                        ELSE
                           SELECT ima391 INTO l_actno FROM ima_file
                            WHERE ima01=p_item
                        END IF
                        #No.FUN-680029 --end--
       WHEN g_ccz07='2' IF p_npptype = '0' THEN  #No.FUN-680029
                           SELECT imz39 INTO l_actno
                             FROM ima_file,imz_file
                            WHERE ima01=p_item AND ima06=imz01
                        #No.FUN-680029 --start--
                        ELSE
                           SELECT imz391 INTO l_actno
                             FROM ima_file,imz_file
                            WHERE ima01=p_item AND ima06=imz01
                        END IF
                        #No.FUN-680029 --end--
       WHEN g_ccz07='3' IF p_npptype = '0' THEN  #No.FUN-680029
                           SELECT imd08 INTO l_actno FROM imd_file
                            WHERE imd01=p_ware
                        #No.FUN-680029 --start--
                        ELSE
                           SELECT imd081 INTO l_actno FROM imd_file
                            WHERE imd01=p_ware
                        END IF
                        #No.FUN-680029 --end--
       WHEN g_ccz07='4' IF p_npptype = '0' THEN  #No.FUN-680029
                           SELECT ime09 INTO l_actno FROM ime_file
                            WHERE ime01=p_ware AND ime02=p_loc
                        #No.FUN-680029 --start--
                        ELSE
                           SELECT ime091 INTO l_actno FROM ime_file
                            WHERE ime01=p_ware AND ime02=p_loc
                        END IF
                        #No.FUN-680029 --end--
       OTHERWISE        LET l_actno='STOCK'
  END CASE
  RETURN l_actno
END FUNCTION
#-----END TQC-630118-----
#-----MOD-680083---------
FUNCTION t900_gl_ins_npq(p_apno,l_actno,l_curr,l_rate,l_npq02,l_npq07,l_apa06,l_apa07,l_apa22,p_npptype)
  DEFINE l_aqa     RECORD LIKE aqa_file.*
  DEFINE l_npq     RECORD LIKE npq_file.*
  DEFINE p_apno     LIKE aqa_file.aqa01
  DEFINE l_actno    LIKE apa_file.apa01
  DEFINE l_curr     LIKE npq_file.npq24
  DEFINE l_rate     LIKE npq_file.npq25
  DEFINE l_npq02    LIKE npq_file.npq02
  DEFINE l_npq07    LIKE npq_file.npq07
  DEFINE l_apa06    LIKE apa_file.apa06
  DEFINE l_apa07    LIKE apa_file.apa07
  DEFINE l_apa22    LIKE apa_file.apa22
  DEFINE l_apb25    LIKE apb_file.apb25
  DEFINE l_apb26    LIKE apb_file.apb26           #No.MOD-B80077 add
  DEFINE l_apb10    LIKE apb_file.apb10
  DEFINE l_apa31    LIKE apa_file.apa31
  DEFINE s_npq07    LIKE npq_file.npq07
  DEFINE l_aag05    LIKE aag_file.aag05
  DEFINE l_cnt,l_cnt2 LIKE type_file.num5
  DEFINE p_npptype  LIKE npp_file.npptype  
  DEFINE l_apa00    LIKE apa_file.apa00   #MOD-750025
  DEFINE l_sql      STRING   #MOD-750025
  DEFINE l_apa02    LIKE apa_file.apa02   #FUN-9A0036
  DEFINE l_aaa03    LIKE aaa_file.aaa03   #FUN-A40067
  DEFINE l_apb930   LIKE apb_file.apb930  #MOD-B90088 add
  DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
  DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
  LET l_npq.npqsys = 'AP'
  LET l_npq.npq00 = 4
  LET l_npq.npq011 = 1
  LET l_npq.npq02 = l_npq02
  LET l_npq.npqtype = p_npptype
 
  LET l_npq.npq01  = p_apno
  LET l_cnt = 0
  #-----MOD-750025--------- 
  #SELECT COUNT(*) INTO l_cnt FROM apb_file
  #   WHERE apb01 = (SELECT apa08 FROM apa_file WHERE apa01 = l_actno)
  #
  #   IF p_npptype = '0' THEN
  #      LET g_sql = " SELECT apb25,apb10 FROM apb_file ",
  #                  "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
  #                  "  WHERE apa01 = '",l_actno,"')"
  #   ELSE
  #      LET g_sql = " SELECT apb251,apb10 FROM apb_file ",
  #                  "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
  #                  "  WHERE apa01 = '",l_actno,"')"
  #   END IF
  #   PREPARE t900_gl_p3 FROM g_sql
  #   DECLARE t900_gl_c3 CURSOR FOR t900_gl_p3
  LET l_apa00 = ''
  SELECT apa00,apa02 INTO l_apa00,l_apa02 FROM apa_file WHERE apa01 = l_actno #FUN-9A0036 add apa02
  IF l_apa00 = '23' THEN
     SELECT COUNT(*) INTO l_cnt FROM apb_file
        WHERE apb01 = (SELECT apa08 FROM apa_file WHERE apa01 = l_actno)
     IF p_npptype = '0' THEN
       #LET l_sql = " SELECT apb25,apb10 FROM apb_file ",              #No.MOD-B80077 mark
       #LET l_sql = " SELECT apb25,apb10,apb26 FROM apb_file ",        #No.MOD-B80077 add #MOD-B90088 mark
        LET l_sql = " SELECT apb25,apb10,apb26,apb930 FROM apb_file ", #No.MOD-B90088 add 
                    "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
                    "  WHERE apa01 = '",l_actno,"')"
     ELSE
       #LET l_sql = " SELECT apb251,apb10 FROM apb_file ",             #No.MOD-B80077 mark
       #LET l_sql = " SELECT apb251,apb10,apb26 FROM apb_file ",       #No.MOD-B80077 add #MOD-B90088 mark
        LET l_sql = " SELECT apb251,apb10,apb26,apb930 FROM apb_file ",#No.MOD-B90088 add
                    "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
                    "  WHERE apa01 = '",l_actno,"')"
     END IF
  ELSE
     SELECT COUNT(*) INTO l_cnt FROM apb_file
        WHERE apb01 = l_actno
     IF p_npptype = '0' THEN
       #LET l_sql = " SELECT apb25,apb10 FROM apb_file ",               #No.MOD-B80077 mark
       #LET l_sql = " SELECT apb25,apb10,apb26 FROM apb_file ",         #No.MOD-B80077 add #MOD-B90088 mark
        LET l_sql = " SELECT apb25,apb10,apb26,apb930 FROM apb_file ",  #No.MOD-B90088 add
                    "  WHERE apb01 = '",l_actno,"'"
     ELSE
       #LET l_sql = " SELECT apb251,apb10 FROM apb_file ",              #No.MOD-B80077 mark
       #LET l_sql = " SELECT apb251,apb10,apb26 FROM apb_file ",        #No.MOD-B80077 add #MOD-B90088 mark
        LET l_sql = " SELECT apb251,apb10,apb26,apb930 FROM apb_file ", #No.MOD-B90088 add
                    "  WHERE apb01 = '",l_actno,"'"
     END IF
  END IF
  PREPARE t900_gl_p3 FROM l_sql
  DECLARE t900_gl_c3 CURSOR FOR t900_gl_p3
  #-----END MOD-750025-----
  LET l_apa31 = 0
 #FOREACH t900_gl_c3 INTO l_apb25,l_apb10                                #No.MOD-B80077 mark
 #FOREACH t900_gl_c3 INTO l_apb25,l_apb10,l_apb26                        #No.MOD-B80077 add  #MOD-B90088 mark
  FOREACH t900_gl_c3 INTO l_apb25,l_apb10,l_apb26,l_apb930               #No.MOD-B90088 add
    LET l_apa31 = l_apa31 + l_apb10
  END FOREACH
  LET l_cnt2 = 1
  LET s_npq07 = 0
 #FOREACH t900_gl_c3 INTO l_apb25,l_apb10                                #No.MOD-B80077 mark
 #FOREACH t900_gl_c3 INTO l_apb25,l_apb10,l_apb26                        #No.MOD-B80077 add #MOD-B90088 mark
  FOREACH t900_gl_c3 INTO l_apb25,l_apb10,l_apb26,l_apb930               #No.MOD-B90088 add
     IF l_cnt2 = l_cnt THEN
        LET l_npq.npq07 = l_npq07 - s_npq07
     ELSE
        LET l_npq.npq07 = l_apb10 * (l_npq07/l_apa31)
     END IF
     LET l_npq.npq03 = l_apb25
     LET l_npq.npq23 = l_actno
     LET l_npq.npq04 = ' '
     LET l_npq.npq06 = '2'
     LET l_npq.npq24 = l_curr
     LET l_npq.npq25 = l_rate
     LET g_npq25  = l_npq.npq25                 #FUN-9A0036
     LET l_npq.npq21 = l_apa06
     LET l_npq.npq22 = l_apa07
     SELECT aag05 INTO l_aag05 FROM aag_file
        WHERE aag01=l_npq.npq03
          AND aag00 = g_bookno3   #No.FUN-730064 
     IF l_aag05 = 'Y' THEN
        IF g_aaz.aaz90='N' THEN            #MOD-B90088 add
          #LET l_npq.npq05 = l_apa22       #No.MOD-B80077 mark
           LET l_npq.npq05 = l_apb26       #No.MOD-B80077 add
        ELSE                               #MOD-B90088 add
           LET l_npq.npq05 = l_apb930      #MOD-B90088 add
        END IF                             #MOD-B90088 add
     ELSE
        LET l_npq.npq05 = ' '
     END IF
     LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
     LET l_npq.npq07f = l_npq.npq07
     #-----MOD-850153---------
     IF g_aza.aza26 <> '2' THEN
        IF l_npq.npq07 < 0 THEN
           LET l_npq.npq06 = '1' 
           LET l_npq.npq07f= l_npq.npq07f* -1
           LET l_npq.npq07 = l_npq.npq07 * -1
        END IF
     END IF
     #-----END MOD-850153-----
#No.FUN-9A0036 --Begin
     IF p_npptype = '1' THEN
#FUN-A40067 --Begin
        SELECT aaa03 INTO l_aaa03 FROM aaa_file
         WHERE aaa01 = g_bookno2
        SELECT azi04 INTO g_azi04_2 FROM azi_file
         WHERE azi01 = l_aaa03
#FUN-A40067 --End
        CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                       g_npq25,l_apa02)
        RETURNING l_npq.npq25
        LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#       LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)#FUN-A40067
     ELSE
        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)  #FUN-A40067
     END IF
#No.FUN-9A0036 --End
     LET l_npq.npqlegal = g_legal #FUN-980001 add
     #FUN-D10065--add--str--
     CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','')
     RETURNING l_npq.npq04
     #FUN-D10065--add--end--
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
     IF SQLCA.sqlcode THEN
        CALL cl_err('ins npq',SQLCA.sqlcode,1)
        LET g_success = 'N' EXIT FOREACH
     END IF
     LET l_npq.npq02 = l_npq.npq02 + 1
     LET l_cnt2 = l_cnt2 + 1
     LET s_npq07 = s_npq07 + l_npq.npq07
  END FOREACH
  RETURN l_npq.npq02
END FUNCTION
#-----END MOD-680083-----
#No.FUN-A40033 --Begin
FUNCTION t110_gen_diff(p_npp)
DEFINE p_npp   RECORD LIKE npp_file.*
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add

   IF p_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(p_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2                                                        
      IF g_flag =  '1' THEN
         CALL cl_err(p_npp.npp02,'aoo-081',1)                                                                                          
         RETURN                                                                                                                        
      END IF                                                                                                                           
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0
      LET l_sum_dr = 0
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = p_npp.npp00
         AND npq01 = p_npp.npp01
         AND npq011= p_npp.npp011
         AND npqsys= p_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = p_npp.npp00
            AND npq01 = p_npp.npp01
            AND npq011= p_npp.npp011
            AND npqsys= p_npp.nppsys
         LET l_npq1.npqtype = p_npp.npptype
         LET l_npq1.npq00 = p_npp.npp00
         LET l_npq1.npq01 = p_npp.npp01
         LET l_npq1.npq011= p_npp.npp011
         LET l_npq1.npqsys= p_npp.nppsys
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
         CALL s_def_npq3(g_bookno1,l_npq1.npq03,g_prog,l_npq1.npq01,'','')
         RETURNING l_npq1.npq04
         #FUN-D10065--add--end--
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
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","npq_file",p_npp.npp01,"",STATUS,"","",1)
            LET g_success = 'N'
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
 

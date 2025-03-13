# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Modify.........: FUN-5C0015 05/12/20 BY GILL (1)多Update 異動碼5~10, 關係人
#                  (2)若該科目有設彈性異動碼(agli120),則default帶出
#                     彈性異動碼的設定值(call s_def_npq: 抓取異動碼default值)
# Modify.........: No.FUN-660167 06/06/26 By wujie cl_err --> cl_err3
# Modify.........: No.FUN-680137 06/09/04 By flowld 欄位型態定義,改為LIKE
# Modify.........: No.CHI-6A0004 06/10/23 By hongmei g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.MOD-690136 06/12/08 By Smapmin 借方科目應抓取待驗收入科目
# Modify.........: No.FUN-730057 07/03/30 By Carrier 會計科目加帳套
# Modify.........: No.MOD-770099 07/07/20 By claire 條件式給 !=''表示為空字串而非NOT NULL
# Modify.........: No.MOD-810153 08/01/21 By Smapmin 抓取 npp02 規則,若結關日(oga021)為空時,改抓出貨日期(oga02)
# Modify.........: No.MOD-830192 08/03/25 By cliare 本幣金額未依小數取位
# Modify.........: No.FUN-840012 08/10/13 By kim eBarcode功能
# Modify.........: No.MOD-930290 09/03/30 By Sarah 如有預收發票訂金時,產生的訂金分錄金額應抓oga52
# Modify.........: No.FUN-980010 09/08/25 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A30188 10/03/24 By Smapmin 關係人代碼的default值,要先由彈性設定抓取,再來才是客戶代碼
# Modify.........: No.FUN-A60056 10/06/29 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-9A0036 10/09/14 By chenmoyan 勾選二套帳時,分錄底稿二的匯率,應依帳別二的設定幣別進行換算
# Modify.........: No:CHI-AC0002 10/12/13 By Summer 增加分錄底稿二
# Modify.........: No.FUN-AA0087 11/01/27 By chenmoyan 異動碼類型設定改善
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-C50257 12/06/08 By Elise 於每個npq02 + 1 之後增加 LET l_npq.npq04 = NULL
# Modify.........: No:CHI-C30023 12/07/06 By Dido 待驗暫估金額與銷貨收入金額應為出貨金額
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(72)
DEFINE   g_bookno        LIKE aza_file.aza81          #CHI-AC0002 add
DEFINE   g_bookno1       LIKE aza_file.aza81          #No.FUN-730057
DEFINE   g_bookno2       LIKE aza_file.aza82          #No.FUN-730057
DEFINE   g_flag          LIKE type_file.chr1          #No.FUN-730057
DEFINE   g_azi04_2       LIKE azi_file.azi04          #CHI-AC0002 add
DEFINE   g_aag44         LIKE aag_file.aag44          #FUN-D40118 add
FUNCTION s_t600_gl(p_trno,p_npptype) #CHI-AC0002 add p_npptype
   DEFINE p_trno	LIKE oga_file.oga01
   DEFINE p_npptype     LIKE npp_file.npptype        #CHI-AC0002 add
   DEFINE l_buf		LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(70)
   DEFINE l_n  		LIKE type_file.num5          #No.FUN-680137 SMALLINT
   WHENEVER ERROR CONTINUE
   IF p_trno IS NULL THEN RETURN END IF
   # 97/05/19 modify by Lynn 判斷已拋轉傳票不可再產生分錄底稿
   SELECT COUNT(*) INTO l_n FROM npp_file 
    WHERE nppsys= 'AR' AND npp00=1 AND npp01 = p_trno AND npp011=1
   #MOD-770099-begin-add
   #  AND nppglno != '' AND nppglno IS NOT NULL
      AND nppglno IS NOT NULL
   #MOD-770099-end-add
   IF l_n > 0 THEN
      CALL cl_err('sel npp','axm-275',0)
      RETURN
   END IF
   IF p_npptype = '0' THEN #CHI-AC0002 add
      SELECT COUNT(*) INTO l_n FROM npq_file 
       WHERE npqsys= 'AR' AND npq00=1 AND npq01 = p_trno AND npq011=1
         AND npqtype = p_npptype #CHI-AC0002 add
      IF l_n > 0 THEN
         IF NOT s_ask_entry(p_trno) THEN RETURN END IF #Genero
      END IF

      #FUN-B40056--add--str--
      LET l_n = 0
      SELECT COUNT(*) INTO l_n FROM tic_file
       WHERE tic04 = p_trno
      IF l_n > 0 THEN
         IF NOT cl_confirm('sub-533') THEN
            RETURN
         END IF
      END IF
      #FUN-B40056--add--end--

   END IF #CHI-AC0002 add

   DELETE FROM tic_file WHERE tic04 = p_trno  #FUN-B40056

   DELETE FROM npp_file 
      WHERE nppsys= 'AR' AND npp00=1 AND npp01 = p_trno AND npp011=1
        AND npptype = p_npptype #CHI-AC0002 add
   DELETE FROM npq_file 
      WHERE npqsys= 'AR' AND npq00=1 AND npq01 = p_trno AND npq011=1
        AND npqtype = p_npptype #CHI-AC0002 add
   CALL s_t600_gl_1(p_trno,p_npptype) #CHI-AC0002 add p_npptype
   CALL cl_getmsg('axm-055',g_lang) RETURNING g_msg
   CALL cl_msg(g_msg)
END FUNCTION
 
FUNCTION s_t600_gl_1(p_trno,p_npptype) #CHI-AC0002 add p_npptype
   DEFINE p_trno	LIKE oga_file.oga01
   DEFINE p_npptype     LIKE npp_file.npptype        #CHI-AC0002 add
   DEFINE l_oga		RECORD LIKE oga_file.*
   DEFINE l_ool		RECORD LIKE ool_file.*
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
#  DEFINE t_azi04       LIKE azi_file.azi04   #金額小數位數    #No.CHI-6A0004
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag371      LIKE aag_file.aag371  #MOD-A30188
   DEFINE l_occ37       LIKE occ_file.occ37   #MOD-A30188
   DEFINE l_aaa03       LIKE aaa_file.aaa03   #CHI-AC0002 add
   DEFINE l_flag        LIKE type_file.chr1   #FUN-D40118 add
 
   #99/06/22本幣依幣別取位
   SELECT azi04 INTO t_azi04 FROM azi_file         #No.CHI-6A0004 
   WHERE azi01 = g_oga.oga23 
   	
   SELECT oga_file.*,ool_file.* INTO l_oga.*,l_ool.*
          FROM oga_file, OUTER ool_file WHERE oga01 = p_trno AND oga_file.oga13=ool_file.ool01
#  IF STATUS THEN CALL cl_err('sel oga+ool',STATUS,1) END IF
   IF STATUS THEN CALL cl_err3("sel","oga_file,ool_file",p_trno,"",STATUS,"","sel oga+ool",1)  END IF   #No.FUN-660167
  #MOD-830192-begin-add
   SELECT azi04 INTO t_azi04 FROM azi_file         
   WHERE azi01 = l_oga.oga23 
  #MOD-830192-end-add
   LET l_npp.nppsys = 'AR'
   LET l_npp.npp00 = 1
   LET l_npp.npp01 = l_oga.oga01
   LET l_npp.npp011 = 1
   LET l_npp.npp02 = l_oga.oga021
   #-----MOD-810153---------
   IF cl_null(l_npp.npp02) THEN
      LET l_npp.npp02 = l_oga.oga02
   END IF 
   #-----END MOD-810153-----
   LET l_npp.npp03 = NULL
  #LET l_npp.npptype = '0'   #MOD-690136 #CHI-AC0002 mark
   LET l_npp.npptype = p_npptype         #CHI-AC0002
 
   #FUN-980010 add plant & legal 
   LET l_npp.npplegal = g_legal 
   #FUN-980010 end plant & legal 
 
   INSERT INTO npp_file VALUES(l_npp.*)
  #No.+042 010330 by plum
  #IF STATUS THEN CALL cl_err('ins npp',STATUS,1) END IF
   IF STATUS OR SQLCA.SQLCODE THEN
#     CALL cl_err('ins npp',SQLCA.SQLCODE,1)
      CALL cl_err3("ins","npp_file",l_npp.npp01,"",SQLCA.SQLCODE,"","ins npp",1)   #No.FUN-660167
   END IF
  #No.+042 ..end
 
   #No.FUN-730057  --Begin
   CALL s_get_bookno(YEAR(l_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(l_npp.npp02,'aoo-081',1)
   END IF
   #No.FUN-730057  --End  
   #CHI-AC0002 add --start--
   IF p_npptype = '0' THEN
      LET g_bookno = g_bookno1
   ELSE
      LET g_bookno = g_bookno2
   END IF
   #CHI-AC0002 add --end--
  #LET l_npq.npqtype = '0'   #MOD-690136 #CHI-AC0002 mark
   LET l_npq.npqtype = p_npptype         #CHI-AC0002
   LET l_npq.npqsys = 'AR'
   LET l_npq.npq00 = 1
   LET l_npq.npq01 = l_oga.oga01
   LET l_npq.npq011 = 1
   LET l_npq.npq02 = 0
   LET l_npq.npq04 = NULL        LET l_npq.npq05 = l_oga.oga15
   LET l_npq.npq21 = l_oga.oga03 LET l_npq.npq22 = l_oga.oga032
   LET l_npq.npq24 = l_oga.oga23 LET l_npq.npq25 = l_oga.oga24
#--------------- (如有預收發票訂金時 Dr:預收 Cr:銷貨收入) -------------------
   IF NOT cl_null(l_oga.oga19) THEN
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq04 = NULL   #MOD-C50257 add
      IF p_npptype = '0' THEN #CHI-AC0002 add
         LET l_npq.npq03 = l_ool.ool21
      #CHI-AC0002 add --start--
      ELSE
         LET l_npq.npq03 = l_ool.ool211
      END IF
      #CHI-AC0002 add --end--
      LET l_npq.npq05 = l_oga.oga15
      LET l_npq.npq06 = '1'
     #LET l_npq.npq07f= l_oga.oga50   #MOD-930290 mark
      LET l_npq.npq07f= l_oga.oga52   #MOD-930290
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_npq.npq03
                                                AND aag00=g_bookno     #No.FUN-730057 #CHI-AC0002 mod g_bookno1->g_bookno
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_oga.oga15 
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      #99/06/22本幣依幣別取位
      #CALL cl_digcut(l_oga.oga50,t_azi04) RETURNING l_oga.oga50     #No.CHI-6A0004  #MOD-830192 mark
     #LET l_npq.npq07 = l_oga.oga50	# 必為本幣   #MOD-930290 mark
      LET l_npq.npq07 = l_oga.oga52	# 必為本幣   #MOD-930290
      #MOD-830192-begin-add
      CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f   
      CALL cl_digcut(l_npq.npq07 ,g_azi04) RETURNING l_npq.npq07   
      #MOD-830192-end-add
      LET l_npq.npq21 = l_oga.oga03
      LET l_npq.npq22 = l_oga.oga032
      LET l_npq.npq23 = l_oga.oga19
      LET l_npq.npq24 = l_oga.oga23
      LET l_npq.npq25 = l_oga.oga24
      #-----MOD-A30188---------
      LET l_aag371=' '
      LET l_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=l_npq.npq03
         AND aag00=g_bookno #CHI-AC0002 mod g_bookno1->g_bookno       
      #-----END MOD-A30188-----
      LET g_msg = '>',l_npq.npq02,' ',l_npq.npq03
      CALL cl_msg(g_msg)
      IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)  #No.FUN-730057 #CHI-AC0002 mod g_bookno1->g_bookno
      RETURNING l_npq.*
      #No.FUN-5C0015 ---end
      CALL s_def_npq31_npq34(l_npq.*,g_bookno)                  #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
      #-----MOD-A30188---------
      IF l_aag371 MATCHES '[234]' THEN          
        #-->for 合併報表-關係人
        SELECT occ37 INTO l_occ37 FROM occ_file
         WHERE occ01=l_oga.oga03
        IF cl_null(l_npq.npq37) THEN
           IF l_occ37='Y' THEN 
              LET l_npq.npq37=l_oga.oga03 CLIPPED    
           END IF   
        END IF
      END IF
      #-----END MOD-A30188-----

      #FUN-980010 add plant & legal 
      LET l_npq.npqlegal = g_legal 
      #FUN-980010 end plant & legal 
      LET l_npq.npq30 = g_plant   #FUN-A60056 

#No.FUN-9A0036 --Begin
            IF l_npq.npqtype = '1' THEN
               #CHI-AC0002 add --start--
               SELECT aaa03 INTO l_aaa03 FROM aaa_file
                WHERE aaa01 = g_bookno2
               SELECT azi04 INTO g_azi04_2 FROM azi_file
                WHERE azi01 = l_aaa03
               #CHI-AC0002 add --end--
               CALL s_newrate(g_bookno1,g_bookno2,
                              l_npq.npq24,l_npq.npq25,l_npp.npp02)
               RETURNING l_npq.npq25
               LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
            #CHI-AC0002 add --start--
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
            ELSE
               LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
            #CHI-AC0002 add --end--
            END IF
#No.FUN-9A0036 --End
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (l_npq.*)
     #No.+042 010330 by plum
     #IF STATUS THEN CALL cl_err('ins npq#1',STATUS,1) END IF
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#1',SQLCA.SQLCODE,1)
         CALL cl_err3("ins","npp_file",l_npp.npp01,"",SQLCA.SQLCODE,"","ins npq#1",1)   #No.FUN-660167
      END IF
     #No.+042 ..end
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq04 = NULL   #MOD-C50257 add
      IF p_npptype = '0' THEN #CHI-AC0002 add
         LET l_npq.npq03 = l_ool.ool41
      #CHI-AC0002 add --start--
      ELSE
         LET l_npq.npq03 = l_ool.ool411
      END IF
      #CHI-AC0002 add --end--
      LET l_npq.npq06 = '2'
      LET l_npq.npq23 = l_oga.oga01
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_npq.npq03
                                                AND aag00=g_bookno   #No.FUN-730057 #CHI-AC0002 mod g_bookno1->g_bookno
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_oga.oga15 
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      #-----MOD-A30188---------
      LET l_aag371=' '
      LET l_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=l_npq.npq03
         AND aag00=g_bookno #CHI-AC0002 mod g_bookno1->g_bookno      
      #-----END MOD-A30188-----
      LET g_msg= '>',l_npq.npq02,' ',l_npq.npq03
      CALL cl_msg(g_msg)
      IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)  #No.FUN-730057 #CHI-AC0002 mod g_bookno1->g_bookno
      RETURNING l_npq.*
      #No.FUN-5C0015 ---end
      CALL s_def_npq31_npq34(l_npq.*,g_bookno)                  #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
      #-----MOD-A30188---------
      IF l_aag371 MATCHES '[234]' THEN          
        #-->for 合併報表-關係人
        SELECT occ37 INTO l_occ37 FROM occ_file
         WHERE occ01=l_oga.oga03
        IF cl_null(l_npq.npq37) THEN
           IF l_occ37='Y' THEN 
              LET l_npq.npq37=l_oga.oga03 CLIPPED    
           END IF   
        END IF
      END IF
      #-----END MOD-A30188-----

      #FUN-980010 add plant & legal 
      LET l_npq.npqlegal = g_legal 
      #FUN-980010 end plant & legal 
      LET l_npq.npq30 = g_plant  #FUN-A60056 

#No.FUN-9A0036 --Begin
      IF l_npq.npqtype = '1' THEN
         #CHI-AC0002 add --start--
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
         #CHI-AC0002 add --end--
         CALL s_newrate(g_bookno1,g_bookno2,
                        l_npq.npq24,l_npq.npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
      #CHI-AC0002 add --start--
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
      #CHI-AC0002 add --end--
      END IF
#No.FUN-9A0036 --End
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (l_npq.*)
     #No.+042 010330 by plum
     #IF STATUS THEN CALL cl_err('ins npq#2',STATUS,1) END IF
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#2',SQLCA.SQLCODE,1)
         CALL cl_err3("ins","npp_file",l_npp.npp01,"",SQLCA.SQLCODE,"","ins npq#2",1)   #No.FUN-660167
      END IF
     #No.+042 ..end
   END IF
#--------------- (Dr:應收-待驗 Cr:銷貨收入) -------------------
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq04 = NULL   #MOD-C50257 add
      #LET l_npq.npq03 = l_ool.ool11   #MOD-690136
      IF p_npptype = '0' THEN #CHI-AC0002 add
         LET l_npq.npq03 = l_ool.ool15   #MOD-690136
      #CHI-AC0002 add --start--
      ELSE
         LET l_npq.npq03 = l_ool.ool151
      END IF
      #CHI-AC0002 add --end-- 
      LET l_npq.npq06 = '1'
     #LET l_npq.npq07f= l_oga.oga53                 #CHI-C30023 mark
      LET l_npq.npq07f= l_oga.oga50                 #CHI-C30023
     #LET l_npq.npq07 = l_oga.oga53 * l_oga.oga24   #CHI-C30023 mark
      LET l_npq.npq07 = l_oga.oga50 * l_oga.oga24   #CHI-C30023
      #MOD-830192-begin-add
      CALL cl_digcut(l_npq.npq07f,t_azi04) RETURNING l_npq.npq07f   
      CALL cl_digcut(l_npq.npq07 ,g_azi04) RETURNING l_npq.npq07   
      #MOD-830192-end-add
      LET l_npq.npq23 = l_oga.oga01
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_npq.npq03
                                                AND aag00=g_bookno     #No.FUN-730057 #CHI-AC0002 mod g_bookno1->g_bookno
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_oga.oga15 
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      #-----MOD-A30188---------
      LET l_aag371=' '
      LET l_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=l_npq.npq03
         AND aag00=g_bookno   #CHI-AC0002 mod g_bookno1->g_bookno    
      #-----END MOD-A30188-----
      LET g_msg = '>',l_npq.npq02,' ',l_npq.npq03
      CALL cl_msg(g_msg)
      IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)  #No.FUN-730057 #CHI-AC0002 mod g_bookno1->g_bookno
      RETURNING l_npq.*
      #No.FUN-5C0015 ---end
      CALL s_def_npq31_npq34(l_npq.*,g_bookno)                  #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
      #-----MOD-A30188---------
      IF l_aag371 MATCHES '[234]' THEN          
        #-->for 合併報表-關係人
        SELECT occ37 INTO l_occ37 FROM occ_file
         WHERE occ01=l_oga.oga03
        IF cl_null(l_npq.npq37) THEN
           IF l_occ37='Y' THEN 
              LET l_npq.npq37=l_oga.oga03 CLIPPED    
           END IF   
        END IF
      END IF
      #-----END MOD-A30188-----

      #FUN-980010 add plant & legal 
      LET l_npq.npqlegal = g_legal 
      #FUN-980010 end plant & legal 
      LET l_npq.npq30 = g_plant  #FUN-A60056
 
#No.FUN-9A0036 --Begin
      IF l_npq.npqtype = '1' THEN
         #CHI-AC0002 add --start--
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
         #CHI-AC0002 add --end--
         CALL s_newrate(g_bookno1,g_bookno2,
                        l_npq.npq24,l_npq.npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
      #CHI-AC0002 add --start--
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
      #CHI-AC0002 add --end--
      END IF
#No.FUN-9A0036 --End
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (l_npq.*)
     #No.+042 010330 by plum
     #IF STATUS THEN CALL cl_err('ins npq#1',STATUS,1) END IF
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#1',SQLCA.SQLCODE,1)
         CALL cl_err3("ins","npp_file",l_npp.npp01,"",SQLCA.SQLCODE,"","ins npq#3",1)   #No.FUN-660167
      END IF
     #No.+042 ..end
      LET l_npq.npq02 = l_npq.npq02 + 1
      LET l_npq.npq04 = NULL   #MOD-C50257 add
      IF p_npptype = '0' THEN #CHI-AC0002 add
         LET l_npq.npq03 = l_ool.ool41
      #CHI-AC0002 add --start--
      ELSE
         LET l_npq.npq03 = l_ool.ool411
      END IF
      #CHI-AC0002 add --end--
      LET l_npq.npq06 = '2'
      LET l_npq.npq23 = l_oga.oga01
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_npq.npq03
                                                AND aag00=g_bookno   #No.FUN-730057 #CHI-AC0002 mod g_bookno1->g_bookno
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_oga.oga15 
      ELSE
         LET l_npq.npq05 = ' '
      END IF
      #-----MOD-A30188---------
      LET l_aag371=' '
      LET l_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=l_npq.npq03
         AND aag00=g_bookno  #CHI-AC0002 mod g_bookno1->g_bookno       
      #-----END MOD-A30188-----
      LET g_msg = '>',l_npq.npq02,' ',l_npq.npq03
      CALL cl_msg(g_msg)
      IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
      #NO.FUN-5C0015 ---start
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno)  #No.FUN-730057 #CHI-AC0002 mod g_bookno1->g_bookno
      RETURNING l_npq.*
      #No.FUN-5C0015 ---end
      CALL s_def_npq31_npq34(l_npq.*,g_bookno)                  #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
      #-----MOD-A30188---------
      IF l_aag371 MATCHES '[234]' THEN          
        #-->for 合併報表-關係人
        SELECT occ37 INTO l_occ37 FROM occ_file
         WHERE occ01=l_oga.oga03
        IF cl_null(l_npq.npq37) THEN
           IF l_occ37='Y' THEN 
              LET l_npq.npq37=l_oga.oga03 CLIPPED    
           END IF   
        END IF
      END IF
      #-----END MOD-A30188-----

      #FUN-980010 add plant & legal 
      LET l_npq.npqlegal = g_legal 
      #FUN-980010 end plant & legal 
      LET l_npq.npq30 = g_plant  #FUN-A60056
 
#No.FUN-9A0036 --Begin
      IF l_npq.npqtype = '1' THEN
         #CHI-AC0002 add --start--
         SELECT aaa03 INTO l_aaa03 FROM aaa_file
          WHERE aaa01 = g_bookno2
         SELECT azi04 INTO g_azi04_2 FROM azi_file
          WHERE azi01 = l_aaa03
         #CHI-AC0002 add --end--
         CALL s_newrate(g_bookno1,g_bookno2,
                        l_npq.npq24,l_npq.npq25,l_npp.npp02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
      #CHI-AC0002 add --start--
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2)
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)
      #CHI-AC0002 add --end--
      END IF
#No.FUN-9A0036 --End
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = l_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(l_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET l_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES (l_npq.*)
     #No.+042 010330 by plum
     #IF STATUS THEN CALL cl_err('ins npq#2',STATUS,1) END IF
      IF STATUS OR SQLCA.SQLCODE THEN
#        CALL cl_err('ins npq#2',SQLCA.SQLCODE,1)
         CALL cl_err3("ins","npp_file",l_npp.npp01,"",SQLCA.SQLCODE,"","ins npq#2",1)   #No.FUN-660167
      END IF
     #No.+042 ..end
     CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION
#FUN-840012

# Prog. Version..: '5.30.07-13.06.04(00010)'     #
#
# Modify.........: No.MOD-490105 04/10/20 By kitty aph06不使用
# Modify.........: No.MOD-5A0274 05/11/24 By Smapmin 判斷科目是否做異動碼控管Q
# Modify.........: NO.MOD-5C0012 05/12/06 By Smapmin 不需因設定強制摘要為空白
# Modify.........: NO.FUN-5C0015 05/12/20 By alana
#                  call s_def_npq.4gl 抓取異動碼、摘要default值
# Modify.........: No.TQC-630017 06/03/07 By Smapmin "預付"分錄產生方式修改為跟aapt150產生分錄的邏輯相同
# Modify.........: No.FUN-660122 06/06/16 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-660117 06/06/21 By Rainy Char改為 Like
# Modify.........: No.FUN-680029 06/08/16 By Rayven 新增參數:分錄底稿類型
# Modify.........: No.FUN-690028 06/09/12 By flowld 欄位型態用LIKE定義
# Modify.........: No.MOD-680083 06/08/29 By Smapmin 延續TQC-630017做修正
# Modify.........: No.MOD-710067 07/01/10 By Smapmin npq04已經值,不需再清空
# Modify.........: No.FUN-730064 07/04/03 By dxfwo   會計科目加帳套
# Modify.........: No.FUN-740184 07/04/24 By Carrier 當付款年度和帳款年度不一時,帳款資料科目要做科目轉換-by aooi120中設置
# Modify.........: No.TQC-750027 07/05/21 By Smapmin 付款部份暫付帳款分錄無法產生
# Modify.........: No.MOD-750132 07/05/30 By Smapmin 調整關係人異動碼相關程式段
# Modify.........: No.CHI-760007 07/06/13 By Smapmin 增加預設關係人異動碼功能
# Modify.........: No.TQC-810082 08/02/01 By chenl   在暫付情況下，增加對匯率和幣種的賦值。
# Modify.........: NO.MOD-870152 08/07/16 BY yiting 產生暫付款分錄時，匯率(npq25)應以apf09/apf09f再取azi07  
# Modify.........: No.MOD-870155 08/07/22 By Smapmin 帳款部份的匯率依apz27來判斷抓取apa14 or apa72
# Modify.........: No.CHI-830037 08/10/16 By Jan 請調整將目前財務架構中使用關系人的地方,請統一使用"代碼",而非"簡稱"
# Modify.........: No.MOD-8A0274 08/10/31 By Sarah l_npq.npq07取位應用g_azi04,l_npq.npq07f取位應用t_azi04
# Modify.........: No.MOD-970273 09/07/30 By mike 目前會先判斷aph03 = "1"時,才為再判斷apz44來決定如何帶出摘要,請改為aph03="1" OR aph
# Modify.........: No.FUN-980001 09/08/10 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
                                                                                     
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 09/12/16 By vealxu 精簡程式碼
# Modify.........: No.CHI-A20022 10/03/03 By sabrina 分錄底稿摘要彈性設定要能抓取單身資料
# Modify.........: No.FUN-A40003 10/05/06 By wujie  借方日期，科目，币别汇率抓取方式增加apg07 =1，2的情况
# Modify.........: No.FUN-A60024 10/06/08 By wujie  增加应付转销的情况
# Modify.........: No.FUN-A50102 10/07/22 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-9A0036 10/07/27 By chenmoyan 勾選二套帳，分錄底稿二的匯率及本幣金額，應依帳別二進行換算
# Modify.........: No.FUN-A40033 10/07/27 By chenmoyan 二套帳時如果第二套帳幣別和本幣不相同，借貸不平衡產生匯損益時要切立科目
# Modify.........: No.FUN-A40067 10/07/27 By chenmoyan 處理二套帳中本幣金額取位
# Modify.........: No.FUN-950053 10/08/18 By vealxu 廠商基本資料的關係人設定搭配異動碼彈性設定
# Modify.........: No.FUN-A80111 10/09/02 By wujie  增加溢退的处理
# Modify.........: No.FUN-A90007 10/10/19 By wujie  增加调帐的处理
# Modify.........: No.FUN-AA0087 11/01/30 By chenmoyan 異動碼類型設定改善
# Modify.........: No.FUN-B40011 11/04/20 By guoch 付款類型為D.收票轉付時，分錄底稿科目抓取ool12
# Modify.........: No:FUN-B40056 11/05/10 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:TQC-B80071 11/08/04 By guoch 分录二时科目取值
# Modify.........: No:MOD-BC0019 11/12/02 By yinhy 付款類型為收票轉付時，分錄底稿錯誤
# Modify.........: No:MOD-C90060 12/09/10 Ny Polly 調整批次產生分錄時，只詢問一次是否產生分錄即可
# Modify.........: No:FUN-C90027 12/09/25 By xuxz 分录的修改
# Modify.........: No:TQC-C10094 12/10/09 By yinhy 付款類型為D.收票轉付時，帳套二科目抓取因為ool121
# Modify.........: No:FUN-C90122 12/10/16 By wangrr 付款類型為F已開票據，分錄科目抓取nmd23、nmd231
# Modify.........: No.FUN-C90044 12/10/18 By minpp  修改退款溢收借貸方向以及科目取值
# Modify.........: No:MOD-C90214 12/10/23 By wujie 付款单身类型是转付时应该从应收票据档带出客户
# Modify.........: No.FUN-CB0065 12/12/27 By wangrr 檔付款類型為G:員工借支修改科目取值
# Modify.........: No:MOD-D10098 13/01/10 By yinhy 分錄底稿自動帶出彈性設置摘要
# Modify.........: No:MOD-D10147 13/01/16 By Polly 相關呼叫s_get_bookno傳入變數改用付款日期(apf02)
# Modify.........: No.FUN-D10065 13/03/07 By minpp 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.MOD-D40164 13/04/23 By yinhy 產生貸方分錄時給npq11賦值
# Modify.........: No.FUN-D40089 13/04/24 By lujh 批次審核的報錯,加show單據編號
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No.MOD-D50048 13/06/04 By yinhy 收票轉付抓取的是anmt250單身中的nhm11客戶編號，應根據此客戶編號查occ_file中資料

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   g_chr           LIKE type_file.chr1    #No.FUN-690028 VARCHAR(1)
DEFINE   g_msg           LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(72)
DEFINE   g_sql           LIKE type_file.chr1000 #No.FUN-680029  #No.FUN-690028 VARCHAR(1000)
DEFINE   g_bookno1       LIKE aza_file.aza81    #No.FUN-730064                                                                     
DEFINE   g_bookno2       LIKE aza_file.aza82    #No.FUN-730064                                                                     
DEFINE   g_bookno3       LIKE aza_file.aza82    #No.FUN-730064
DEFINE   g_flag          LIKE type_file.chr1    #No.FUN-730064
DEFINE   g_apf02         LIKE apf_file.apf02    #No.FUN-740184
DEFINE   g_apa02         LIKE apa_file.apa02    #No.FUN-740184
DEFINE   g_npq25         LIKE npq_file.npq25    #FUN-9A0036                     
DEFINE   g_azi04_2       LIKE azi_file.azi04    #FUN-A40067
FUNCTION t310_g_gl(p_aptype,p_apno,p_npptype)  #No.FUN-680029 新增p_npptype
   DEFINE p_aptype	LIKE apf_file.apf00
   DEFINE p_apno	LIKE apf_file.apf01
   DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680029
   DEFINE l_buf		LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(60)
   DEFINE l_n  		LIKE type_file.num5    #No.FUN-690028 SMALLINT
 
   WHENEVER ERROR CONTINUE
   SELECT COUNT(*) INTO l_n FROM npp_file WHERE nppsys = 'AP' AND npp00 = 3
                                            AND npp01  = p_apno
                                            AND npp011 = 1 
                                            AND npptype = p_npptype #No.FUN-680029
   IF l_n > 0 THEN
      IF p_npptype = '0' THEN
        #IF NOT s_ask_entry(p_apno) THEN RETURN END IF #Genero #MOD-C90060 mark
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
         DELETE FROM npp_file WHERE nppsys = 'AP' AND npp00 = 3
                                AND npp01  = p_apno
                                AND npp011 = 1 
         DELETE FROM npq_file WHERE npqsys = 'AP' AND npq00 = 3
                                AND npq01  = p_apno
                                AND npq011 = 1 
      END IF
   END IF
   CALL t310_g_gl_1(p_aptype,p_apno,p_npptype)  #No.FUN-680029 新增p_npptype
END FUNCTION
 
FUNCTION t310_g_gl_1(p_aptype,p_apno,p_npptype) #No.FUN-680029 新增p_npptype
   DEFINE p_aptype	LIKE apf_file.apf00
   DEFINE p_apno	LIKE apf_file.apf01
   DEFINE p_npptype     LIKE npp_file.npptype   #No.FUN-680029
   DEFINE l_aag05       LIKE aag_file.aag05
   DEFINE l_aag371      LIKE aag_file.aag371   #MOD-750132
   DEFINE l_apf		RECORD LIKE apf_file.*
   DEFINE l_npp		RECORD LIKE npp_file.*
   DEFINE l_npq		RECORD LIKE npq_file.*
   DEFINE l_dept	LIKE apa_file.apa22  #FUN-660117
   DEFINE l_actno,l_actno2	LIKE apa_file.apa54  #FUN-660117 
   DEFINE l_actno1	LIKE apa_file.apa54  #No.FUN-680029
   DEFINE l_aph02	LIKE aph_file.aph02
   DEFINE l_aph03	LIKE aph_file.aph03
   DEFINE l_aph08	LIKE aph_file.aph08
   DEFINE l_amt		LIKE aph_file.aph05
   DEFINE l_amtf        LIKE aph_file.aph05f
   DEFINE l_sql         LIKE type_file.chr1000 #No.FUN-690028 VARCHAR(400)
   DEFINE l_apg03	LIKE apg_file.apg03
   DEFINE l_apg04	LIKE apg_file.apg04
   DEFINE l_apg05	LIKE apg_file.apg05
   DEFINE l_apg05f	LIKE apg_file.apg05f
   DEFINE l_opendate,l_duedate	LIKE type_file.dat     #No.FUN-690028 DATE
   DEFINE l_curr        LIKE npq_file.npq24
   DEFINE l_rate        LIKE npq_file.npq25
   DEFINE l_pmc03       LIKE pmc_file.pmc03
   DEFINE l_pmc903      LIKE pmc_file.pmc903
   DEFINE l_bookno      LIKE aag_file.aag00    #No.FUN-740184
   DEFINE l_apa02       LIKE apa_file.apa02    #No.FUN-740184
   DEFINE l_apg02	LIKE apg_file.apg02    #CHI-A20022 add
#No.FUN-A40003 --begin
   DEFINE l_nmg           RECORD LIKE nmg_file.*
   DEFINE l_npk           RECORD LIKE npk_file.*
   DEFINE l_nmydmy3       LIKE nmy_file.nmydmy3
   DEFINE l_nmh           RECORD LIKE nmh_file.* 
   DEFINE l_nmz20         LIKE nmz_file.nmz20
   DEFINE l_nmz59         LIKE nmz_file.nmz59
   DEFINE l_aph17         LIKE aph_file.aph17
   DEFINE l_acc           LIKE aag_file.aag01
#No.FUN-A40003 --end 
   DEFINE l_aaa03         LIKE aaa_file.aaa03    #FUN-A40067
#No.FUN-A90007 --begin
   DEFINE l_aph04         LIKE aph_file.aph04
   DEFINE l_aph041        LIKE aph_file.aph041
   DEFINE l_aph21         LIKE aph_file.aph21
#No.FUN-A90007 --end
   DEFINE l_ool12         LIKE ool_file.ool12    #FUN-B40011
   DEFINE l_ool121        LIKE ool_file.ool121   #TQC-C10094
   DEFINE l_nmd23         LIKE nmd_file.nmd23    #FUN-C90122
   DEFINE l_nmd231        LIKE nmd_file.nmd23    #FUN-C90122
   DEFINE l_aag44         LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag          LIKE type_file.chr1    #No.FUN-D40118   Add
    
   SELECT * INTO l_apf.* FROM apf_file WHERE apf01 = p_apno
   IF l_apf.apf41 = 'X' THEN CALL cl_err("apf41='X'",'aap-165',0) RETURN END IF
   IF STATUS THEN RETURN END IF
 
   CALL s_get_bookno(YEAR(l_apf.apf02)) RETURNING g_flag,g_bookno1,g_bookno2                                                        
   IF g_flag =  '1' THEN  #抓不到帳別                                                                                               
      #CALL cl_err(l_apf.apf02,'aoo-081',1)                      #FUN-D40089 mark
      CALL s_errmsg('',l_apf.apf01,l_apf.apf02,'aoo-081',1)      #FUN-D40089 add   
      LET g_success = 'N'                                                                                                           
      RETURN                                                                                                                        
   END IF                                                                                                                           
   IF p_npptype = '0' THEN                                                                                                          
      LET g_bookno3 = g_bookno1                                                                                                     
   ELSE                                                                                                                             
      LET g_bookno3 = g_bookno2                                                                                                     
   END IF                                                                                                                           
 
   LET l_npp.npptype = p_npptype  #No.FUN-680029
   LET l_npq.npqtype = p_npptype  #No.FUN-680029
 
   #-->單頭
   LET l_npp.nppsys = 'AP'
   LET l_npp.npp00  = 3
   LET l_npp.npp01  = l_apf.apf01 
   LET l_npp.npp011 = 1 
   LET l_npp.npp02  = l_apf.apf02
   LET g_apf02      = l_apf.apf02   #No.FUN-740184
   LET l_npp.npp03  = NULL
   LET l_npp.npp05  = NULL
   LET l_npp.nppglno= NULL
   LET l_npp.npplegal= g_legal  #FUN-980001 add
   INSERT INTO npp_file VALUES (l_npp.*)
   IF SQLCA.sqlcode THEN 
      #CALL cl_err3("ins","npp_file",l_npp.npp00,l_npp.npp01,SQLCA.sqlcode,"","insert npp_file",1)  #No.FUN-660122  #FUN-D40089 mark
      CALL s_errmsg('',l_npp.npp00,l_npp.npp01,SQLCA.sqlcode,1)      #FUN-D40089 add
      LET g_success = 'N' 
   END IF
   #-->單身
   LET l_npq.npqsys = 'AP'
   LET l_npq.npq00  = 3
   LET l_npq.npq01  = l_apf.apf01 
   LET l_npq.npq011 = 1 
   LET l_npq.npq01 = l_apf.apf01
   LET l_npq.npq21 = l_apf.apf03
   LET l_npq.npq22 = l_apf.apf12
# ------------------------------------ D : A/P
   DECLARE t310_gl_c1 CURSOR FOR
      SELECT apg02,apg03,apg04,apg05,apg05f FROM apg_file         #CHI-A20022 add apg02 
            WHERE apg01 = l_apf.apf01
   LET l_npq.npq02 = 1
   FOREACH t310_gl_c1 INTO l_apg02,l_apg03,l_apg04,l_apg05,l_apg05f   #CHI-A20022 add l_apg02  
      IF SQLCA.sqlcode THEN
         #CALL cl_err('t310_g_gl(ckp#1)',SQLCA.sqlcode,1)                      #FUN-D40089 mark
         CALL s_errmsg('',l_apf.apf01,'t310_g_gl(ckp#1)',SQLCA.sqlcode,1)      #FUN-D40089 add    
      END IF
  	  LET g_plant_new = l_apg03
  	  CALL s_getdbs()
      IF p_npptype = '0' THEN  #No.FUN-680029
         IF g_apz.apz27 = 'N' THEN   #MOD-870155
            LET l_sql= "SELECT apa02,apa22,apa54,apa13,apa14 ",  #No.FUN-740184 add apa02
                     # " FROM  ",g_dbs_new CLIPPED," apa_file ",            #FUN-A50102 mark
                       " FROM  ",cl_get_target_table(l_apg03,'apa_file'),   #FUN-A50102 
                       " WHERE apa01 ='",l_apg04,"'"
         ELSE
            LET l_sql= "SELECT apa02,apa22,apa54,apa13,apa72 ",  #No.FUN-740184 add apa02
                     # " FROM  ",g_dbs_new CLIPPED," apa_file ",            #FUN-A50102 mark
                       " FROM  ",cl_get_target_table(l_apg03,'apa_file'),   #FUN-A50102
                       " WHERE apa01 ='",l_apg04,"'"
         END IF
      ELSE
         IF g_apz.apz27 = 'N' THEN   #MOD-870155
            LET l_sql= "SELECT apa02,apa22,apa541,apa13,apa14 ",  #No.FUN-740184 add apa02
                     # " FROM  ",g_dbs_new CLIPPED," apa_file ",            #FUN-A50102 mark
                       " FROM  ",cl_get_target_table(l_apg03,'apa_file'),   #FUN-A50102
                       " WHERE apa01 ='",l_apg04,"'"
         ELSE
            LET l_sql= "SELECT apa02,apa22,apa541,apa13,apa72 ",  #No.FUN-740184 add apa02
                     # " FROM  ",g_dbs_new CLIPPED," apa_file ",            #FUN-A50102 mark
                       " FROM  ",cl_get_target_table(l_apg03,'apa_file'),   #FUN-A50102
                       " WHERE apa01 ='",l_apg04,"'"
         END IF
      END IF
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql          #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_apg03) RETURNING l_sql  #FUN-A50102
      PREPARE t310_gl_d FROM l_sql 
      IF SQLCA.sqlcode THEN 
         #CALL cl_err('t310_gl_d',SQLCA.sqlcode,0)                      #FUN-D40089 mark
         CALL s_errmsg('',l_apf.apf01,'t310_gl_d',SQLCA.sqlcode,1)      #FUN-D40089 add
      END IF
      DECLARE t310_cs_gl CURSOR FOR t310_gl_d
      OPEN t310_cs_gl  
      FETCH t310_cs_gl INTO l_apa02,l_dept,l_actno,l_curr,l_rate  #No.FUN-740184
      CLOSE t310_cs_gl  
      LET l_npq.npq03 = l_actno
     #CALL s_get_bookno(YEAR(l_apa02)) RETURNING g_flag,g_bookno1,g_bookno2            #MOD-D10147 mark
      CALL s_get_bookno(YEAR(l_apf.apf02)) RETURNING g_flag,g_bookno1,g_bookno2        #MOD-D10147 add
      IF g_flag='1' THEN
         #CALL cl_err(l_apa02,'aoo-081',1)                      #FUN-D40089 mark
         CALL s_errmsg('',l_apf.apf01,l_apa02,'aoo-081',1)      #FUN-D40089 add
         LET g_success = 'N'
      END IF
      IF p_npptype = '0' THEN                                                                                                          
         LET g_bookno3 = g_bookno1                                                                                                     
      ELSE                                                                                                                             
         LET g_bookno3 = g_bookno2                                                                                                     
      END IF                                                                                                                           
      SELECT aag05,aag371 INTO l_aag05,l_aag371 FROM aag_file    #MOD-5A0274   #MOD-750132
           WHERE aag01=l_npq.npq03   #MOD-5A0274
             AND aag00= g_bookno3    #No.FUN-730064
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_dept
      ELSE
         LET l_npq.npq05 = ' '     
      END IF
#FUN-C90027--mark--str 
#No.FUN-A40003 --begin
#     IF p_aptype = '32' THEN 
#        LET l_npq.npq06 = '2'
#     ELSE
#        LET l_npq.npq06 = '1'
#     END IF  
#No.FUN-A40003 --end
#FUN-C90027--mark--end
#No.FUN-C90027--BEGIN
      IF p_aptype = '32' THEN
         LET l_npq.npq06 = '2'
      ELSE
         IF p_aptype = '36' AND l_apf.apf47 = '2' THEN
            LET l_npq.npq06 = '2'
         ELSE
            LET l_npq.npq06 = '1'
         END IF
      END IF
#No.FUN-C90027--END
      LET l_npq.npq07f= l_apg05f
      LET l_npq.npq07 = l_apg05
      LET l_npq.npq23 = l_apg04
      LET l_npq.npq24 = l_curr
      #LET l_npq.npq25 = l_rate  #mark by dengsy170306
      SELECT round(l_apg05/l_apg05f,6) INTO l_npq.npq25  FROM dual  #add by dengsy170306
      LET g_npq25 = l_npq.npq25  #FUN-9A0036
      LET l_npq.npq04 = ''
      LET l_npq.npq11 = ''
      LET l_npq.npq12 = ''
      LET l_npq.npq13 = ''
      LET l_npq.npq14 = ''
      LET l_npq.npq31 = ''
      LET l_npq.npq32 = ''
      LET l_npq.npq33 = ''
      LET l_npq.npq34 = ''
      LET l_npq.npq35 = ''
      LET l_npq.npq36 = ''
      LET l_npq.npq37 = ''
      #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.FUN-730064   #CHI-A20022 mark
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_apg02,'',g_bookno3)              #CHI-A20022 add
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno3)                 #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
         
      IF YEAR(l_npp.npp02) <> YEAR(l_apa02) THEN
         CALL s_tag(YEAR(l_npp.npp02),g_bookno3,l_npq.npq03)
              RETURNING l_bookno,l_npq.npq03
      END IF
    # IF l_aag371 MATCHES '[23]' THEN            #FUN-950053 mark 
      IF l_aag371 MATCHES '[234]' THEN           #FUN-950053 add
        #-->for 合併報表-關係人
        SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
         WHERE pmc01=l_apf.apf03
        IF cl_null(l_npq.npq37) THEN
           IF l_pmc903 = 'Y' THEN 
              LET l_npq.npq37 = l_apf.apf03 CLIPPED   #No.CHI-830037
           END IF
        END IF
      END IF
      LET l_npq.npqlegal= g_legal  #FUN-980001 add
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
#            LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
          ELSE
             LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
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
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',
                  l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN
         #CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq02,SQLCA.sqlcode,"","t310_g_gl(ckp#2)",1)  #No.FUN-660122 #FUN-D40089 mark
         CALL s_errmsg('',l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,1)      #FUN-D40089 add
         LET g_success='N' EXIT FOREACH #no.5573
      END IF
      LET l_npq.npq02 = l_npq.npq02 + 1
   END FOREACH
#------------------------------------ D : 暫付
   IF l_apf.apf09 > 0 THEN
      LET l_npq.npq03 = ''
#No.FUN-A80111 --begin
      IF p_aptype = '32' THEN 
         IF g_apz.apz13 = 'Y' THEN
            IF p_npptype = '0' THEN  #No.FUN-680029
               SELECT aps61 INTO l_npq.npq03 FROM aps_file WHERE aps01 = l_apf.apf05
            ELSE
               SELECT aps611 INTO l_npq.npq03 FROM aps_file WHERE aps01 = l_apf.apf05
            END IF
         ELSE
            IF p_npptype = '0' THEN  #No.FUN-680029
               SELECT aps61 INTO l_npq.npq03 FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
            ELSE
               SELECT aps611 INTO l_npq.npq03 FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
            END IF
         END IF
         LET l_npq.npq06 = '2'
      ELSE
         IF g_apz.apz13 = 'Y' THEN
            IF p_npptype = '0' THEN  #No.FUN-680029
               SELECT aps13 INTO l_npq.npq03 FROM aps_file WHERE aps01 = l_apf.apf05
            ELSE
               SELECT aps131 INTO l_npq.npq03 FROM aps_file WHERE aps01 = l_apf.apf05
            END IF
         ELSE
            IF p_npptype = '0' THEN  #No.FUN-680029
               SELECT aps13 INTO l_npq.npq03 FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
            ELSE
               SELECT aps131 INTO l_npq.npq03 FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
            END IF
         END IF
         LET l_npq.npq06 = '1'
      END IF  
#No.FUN-A80111 --end
      LET l_npq.npq07f= l_apf.apf09f
      LET l_npq.npq07 = l_apf.apf09
      LET l_npq.npq23 = l_apf.apf01
      LET l_npq.npq24 = l_apf.apf06
 
      LET l_npq.npq25 = l_apf.apf09/l_apf.apf09f 
        SELECT azi07 INTO t_azi07 FROM azi_file
           WHERE azi01 = l_npq.npq24
      LET l_npq.npq25 = cl_digcut(l_npq.npq25,t_azi07)
 
      LET g_npq25 = l_npq.npq25  #FUN-9A0036 
      CALL s_get_bookno(YEAR(g_apf02)) RETURNING g_flag,g_bookno1,g_bookno2                                                        
      IF g_flag =  '1' THEN  #抓不到帳別                                                                                               
         CALL cl_err(g_apf02,'aoo-081',1)                                                                                          
         LET g_success = 'N'                                                                                                           
         RETURN                                                                                                                        
      END IF                                                                                                                           
      IF p_npptype = '0' THEN                                                                                                          
         LET g_bookno3 = g_bookno1                                                                                                     
      ELSE                                                                                                                             
         LET g_bookno3 = g_bookno2                                                                                                     
      END IF                                                                                                                           
      SELECT aag05,aag371 INTO l_aag05,l_aag371 FROM aag_file    #MOD-5A0274   #MOD-750132
           WHERE aag01=l_npq.npq03   #MOD-5A0274
             AND aag00=g_bookno3     #No.FUN-730064   
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apf.apf05
      ELSE
         LET l_npq.npq05 = ' '     
      END IF
      LET l_npq.npq04 = ''
      LET l_npq.npq11 = ''
      LET l_npq.npq12 = ''
      LET l_npq.npq13 = ''
      LET l_npq.npq14 = ''
      LET l_npq.npq31 = ''
      LET l_npq.npq32 = ''
      LET l_npq.npq33 = ''
      LET l_npq.npq34 = ''
      LET l_npq.npq35 = ''
      LET l_npq.npq36 = ''
      LET l_npq.npq37 = ''
     #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.FUN-730064   #CHI-A20022 mark
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_apg02,'',g_bookno3)              #CHI-A20022 add
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno3)                 #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
    # IF l_aag371 MATCHES '[23]' THEN                #FUN-950053 mark
      IF l_aag371 MATCHES '[234]' THEN               #FUN-950053 add 
        #-->for 合併報表-關係人
        SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
         #WHERE pmc01=l_apf.apf03     #MOD-D50038 mark
         WHERE pmc01=l_npq.npq21      #MOD-D50048
        #No.MOD-D50048  --Begin 
        IF STATUS THEN
            IF l_aph03 = 'D' THEN
               SELECT occ02,occ37 INTO l_pmc03,l_pmc903 FROM occ_file
                WHERE occ01 = l_npq.npq21
            END IF
        END IF
        #No.MOD-D50048  --End
        IF cl_null(l_npq.npq37) THEN
           IF l_pmc903 = 'Y' THEN 
              #LET l_npq.npq37 = l_apf.apf03 CLIPPED   #No.CHI-830037  #MOD-D50048 mark
              LET l_npq.npq37 = l_npq.npq21  CLIPPED   #MOD-D50048
           END IF
        END IF
      END IF
      LET l_npq.npqlegal= g_legal  #FUN-980001 add
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
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
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
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN
         #CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t310_g_gl(ckp#2)",1)  #No.FUN-660122 #FUN-D40089 mark
         CALL s_errmsg('',l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,1)      #FUN-D40089 add
         LET g_success='N' #no.5573
      END IF
      LET l_npq.npq02 = l_npq.npq02 + 1
   END IF
# ------------------------------------ C : CASH, N/P, 折讓/預付
 
   IF p_npptype = '0' THEN
      LET g_sql = " SELECT aph02,aph03,aph08,aph04,apa54,aph05,",
                  "         aph05f,aph06,aph07,aph13,aph14,aph17 ",               #No.FUN-A40003 add aph17
                  "   FROM apf_file,aph_file LEFT OUTER JOIN apa_file ON aph_file.aph04 = apa_file.apa01",    #No.FUN-A60024
                  "  WHERE aph01 = '",l_apf.apf01,"'",
                  "    AND apf00 <> '36' AND apf01 = aph01",                       #No.FUN-A60024
                  "  ORDER BY aph02 "
   ELSE
    #  LET g_sql = " SELECT aph02,aph03,aph08,aph04,apa541,aph05,",              #No.TQC-B80071 mark
      LET g_sql = " SELECT aph02,aph03,aph08,aph041,apa541,aph05,",              #No.TQC-B80071 add 
                  "         aph05f,aph06,aph07,aph13,aph14,aph17 ",              #No.FUN-A40003 add aph17
                  "   FROM apf_file,aph_file LEFT OUTER JOIN apa_file ON aph_file.aph04 = apa_file.apa01",    #No.FUN-A60024
                  "  WHERE aph01 = '",l_apf.apf01,"'",
                  "    AND apf00 <> '36' AND apf01 = aph01",                       #No.FUN-A60024
                  "  ORDER BY aph02 "
   END IF
   PREPARE t310_gl_p2 FROM g_sql
   DECLARE t310_gl_c2 CURSOR FOR t310_gl_p2
   FOREACH t310_gl_c2 INTO l_aph02,l_aph03,l_aph08,l_actno,l_actno2,  #No.FUN-680029 新增l_actno1
                           l_amt,l_amtf,l_opendate,l_duedate,l_curr,l_rate,l_aph17   #No.FUN-A40003 add aph17
      IF l_aph03 MATCHES "[6789G]"  THEN  #FUN-CB0065 add G
         IF l_aph03 = '8' AND cl_null(l_actno2) THEN   #TQC-750027
            CALL t310_gl_ins_npq(p_apno,l_actno,l_aph03,l_duedate,l_curr,l_rate,l_npq.npq02,l_amt,l_amtf,p_npptype) #No.FUN-680029 新增p_npptype   #MOD-680083
                 RETURNING l_npq.npq02
            CONTINUE FOREACH
         END IF
         SELECT apa02 INTO g_apa02 FROM apa_file WHERE apa01 = l_actno 
        #CALL s_get_bookno(YEAR(g_apa02)) RETURNING g_flag,g_bookno1,g_bookno2      #MOD-D10147 mark
         CALL s_get_bookno(YEAR(g_apf02)) RETURNING g_flag,g_bookno1,g_bookno2      #MOD-D10147 add
         IF g_flag='1' THEN
            #CALL cl_err(g_apa02,'aoo-081',1)                      #FUN-D40089 mark
            CALL s_errmsg('',l_apf.apf01,g_apa02,'aoo-081',1)      #FUN-D40089 add
         END IF
         IF p_npptype = '0' THEN                                                                                                          
            LET g_bookno3 = g_bookno1                                                                                                     
         ELSE                                                                                                                             
            LET g_bookno3 = g_bookno2                                                                                                     
         END IF                                                                                                                           
         LET l_npq.npq03 = l_actno2		# Cash, N/P
         LET l_npq.npq23 = l_actno
         LET l_apa02 = g_apa02      #No.FUN-740184
      ELSE
#No.FUN-A40003 --begin 
         IF p_aptype ='32' THEN 
            IF l_aph03 ='2' THEN
               SELECT nmg_file.* INTO l_nmg.*  FROM nmg_file
                      WHERE nmg00= l_actno
                        AND nmg23 > nmg24
                        AND nmgconf <> 'X'
#                        AND (nmg20='21' OR nmg20='22')
#                        AND (nmg29 !='Y')    #NO:4181

               #---->為防止收支單輸入兩筆單身
               LET l_sql = "SELECT npk_file.* FROM npk_file ",
                           " WHERE npk00= '",l_actno,"'",
                           "       AND npk01 ='",l_aph17,"'"   
               PREPARE t310_aph04_npk FROM l_sql
               DECLARE t310_aph04_npk_c1 CURSOR FOR t310_aph04_npk
               FOREACH t310_aph04_npk_c1 INTO l_npk.*
                 IF SQLCA.sqlcode THEN
                    LET g_errno = SQLCA.sqlcode EXIT FOREACH
                 END IF    
                 IF l_nmg.nmg29='Y' THEN
                    IF p_npptype = '0' THEN 
                       LET l_acc =l_npk.npk071  #科目編號        
                    ELSE                                
                       LET l_acc =l_npk.npk073  #科目二編號   
                    END IF                                               
                 ELSE
                 	  IF p_npptype = '0' THEN
                       LET l_acc =l_npk.npk07   #科目編號
                    ELSE                               
                       LET l_acc =l_npk.npk072  #科目二編號   
                    END IF                                                
                 END IF 
               END FOREACH 
            END IF 
            IF l_aph03 ='1' THEN 
               LET l_sql="SELECT nmh_file.*,nmydmy3 FROM nmh_file,nmy_file ",
                         " WHERE nmh01= '",l_actno,"'",
                         "   AND nmh01[1,",g_doc_len,"]=nmyslip"
               PREPARE t310_ins_aph08_2_p FROM l_sql
               DECLARE t310_ins_aph08_2 CURSOR FOR t310_ins_aph08_2_p
               OPEN t310_ins_aph08_2
               FETCH t310_ins_aph08_2 INTO l_nmh.*,l_nmydmy3
               
               IF l_nmydmy3='Y' THEN
                  IF p_npptype = '0' THEN 
                     LET l_acc = l_nmh.nmh27
                  ELSE 
                     LET l_acc = l_nmh.nmh271
                  END IF    
               ELSE 
               	  IF p_npptype = '0' THEN 
                     LET l_acc = l_nmh.nmh26 
                  ELSE   
                     LET l_acc = l_nmh.nmh261   
                  END IF 
               END IF
            END IF
            #FUN-C90044--add--str--
            IF l_aph03 = 'E' THEN
               LET l_npq.npq03 =  l_actno
               LET l_npq.npq23 = ''
            ELSE
            #FUN-C90044--add--end 
               LET l_npq.npq03 = l_acc
               LET l_npq.npq23 = l_actno       #FUN-C90044
            END IF                             #FUN-C90044
            #LET l_npq.npq23 = l_actno           #FUN-C90044 mark
         ELSE 
#No.FUN-A40003 --end 
#No.FUN-B40011 --begin
            IF l_aph03 ='D' THEN
               LET l_sql="SELECT nmh_file.*,nmydmy3 FROM nmh_file,nmy_file",
                         " WHERE nmh01= '",l_actno,"'",
                         "   AND SUBSTR(nmh01,1,",g_doc_len,")=nmyslip"
               PREPARE t310_ins_aph03_D_p FROM l_sql
               DECLARE t310_ins_aph03_D CURSOR FOR t310_ins_aph03_D_p
               OPEN t310_ins_aph03_D
               FETCH t310_ins_aph03_D INTO l_nmh.*,l_nmydmy3
               
               #No.MOD-BC0019  --Begin
               #IF l_nmydmy3='Y' THEN
               #   IF p_npptype = '0' THEN 
               #      LET l_actno = l_nmh.nmh27
               #   ELSE 
               #      LET l_actno = l_nmh.nmh271
               #   END IF    
               #ELSE 
               #	  IF p_npptype = '0' THEN 
               #      LET l_actno = l_nmh.nmh26 
               #   ELSE   
               #      LET l_actno = l_nmh.nmh261   
               #   END IF 
               #END IF
               IF p_npptype = '0' THEN 
                  LET l_actno = l_nmh.nmh26
               ELSE 
                  LET l_actno = l_nmh.nmh261
               END IF
               #No.MOD-BC0019  --End
               
               IF cl_null(l_actno) THEN
                  LET l_sql="SELECT ool12,ool121 FROM ool_file,ooz_file",  #QC-C10094 add oll121
                            " WHERE ool01 = ooz08"
                  PREPARE t310_sel_ool12_p FROM l_sql
                  DECLARE t310_sel_ool12 CURSOR FOR t310_sel_ool12_p
                  OPEN t310_sel_ool12
                  FETCH t310_sel_ool12 INTO l_ool12,l_ool121
                  IF p_npptype = '0' THEN   #TQC-C10094
                     LET l_actno = l_ool12
                  ELSE                      #TQC-C10094
                     LET l_actno = l_ool121 #TQC-C10094
                  END IF                    #TQC-C10094
               END IF
            END IF
#No.FUN-B40011 --end
           #FUN-C90122--add--str--
           IF p_aptype ='33' AND l_aph03='F' THEN
              SELECT nmd23,nmd231 INTO l_nmd23,l_nmd231 FROM nmd_file
              WHERE nmd01=l_actno
              IF p_npptype = '0' THEN
                  LET l_actno = l_nmd23
               ELSE
                  LET l_actno = l_nmd231
               END IF
               IF cl_null(l_actno) THEN
                  IF g_apz.apz13 = 'Y' THEN
                     IF p_npptype = '0' THEN
                        SELECT aps24 INTO l_actno FROM aps_file WHERE aps01 = l_apf.apf05
                     ELSE
                        SELECT aps241 INTO l_actno FROM aps_file WHERE aps01 = l_apf.apf05
                     END IF
                  ELSE
                     IF p_npptype = '0' THEN
                        SELECT aps24 INTO l_actno FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
                     ELSE
                        SELECT aps241 INTO l_actno FROM aps_file WHERE (aps01 = ' ' OR aps01 IS NULL)
                     END IF
                  END IF
               END IF
           END IF
           #FUN-C90122--add--end
            LET l_npq.npq03 = l_actno			# 折讓/預付
            LET l_npq.npq23 = l_apf.apf01
            LET l_apa02 = g_apf02
            CALL s_get_bookno(YEAR(g_apf02)) RETURNING g_flag,g_bookno1,g_bookno2                                                        
            IF g_flag =  '1' THEN  #抓不到帳別                                                                                               
               #CALL cl_err(g_apf02,'aoo-081',1)                      #FUN-D40089 mark
               CALL s_errmsg('',l_apf.apf01,g_apa02,'aoo-081',1)      #FUN-D40089 add               
               LET g_success = 'N'                                                                                                           
               RETURN                                                                                                                        
            END IF                                                                                                                           
            IF p_npptype = '0' THEN                                                                                                          
               LET g_bookno3 = g_bookno1                                                                                                     
            ELSE                                                                                                                             
               LET g_bookno3 = g_bookno2                                                                                                     
            END IF  
         END IF           #No.FUN-A40003                                                                                                                         
      END IF
      LET l_npq.npq04 = NULL
      IF l_aph03 = "1" OR l_aph03 = "2" THEN #MOD-970273 
         CASE WHEN g_apz.apz44 = '1' 
                   LET l_npq.npq04=l_apf.apf03 CLIPPED,' ',l_apf.apf12
              WHEN g_apz.apz44 = '2' 
                   LET l_npq.npq04=l_apf.apf03 CLIPPED,' ',l_apf.apf12,' ',
                                   l_duedate
         END CASE
      END IF
#No.FUN-A40003 --begin
      IF p_aptype = '32' THEN
         #FUN-C90044--add--str--
         IF l_aph03 ='E' THEN     #溢收科目應在貸方
            LET l_npq.npq06 = '2'
         ELSE
         #FUN-C90044--add--end 
            LET l_npq.npq06 = '1'
         END IF  #FUN-C90044
      ELSE
         LET l_npq.npq06 = '2'
      END IF  
#No.FUN-A40003 --end
      LET l_npq.npq07 = l_amt
      LET l_npq.npq07f= l_amtf
      LET l_npq.npq24 = l_curr
      LET l_npq.npq25 = l_rate
      LET g_npq25 = l_npq.npq25  #FUN-9A0036
      IF l_aph03 MATCHES '[AB]' THEN    #貸方科目
         IF l_aph08 IS NOT NULL AND l_aph08 <> ' ' THEN
            LET l_npq.npq21 = l_aph08
            SELECT nma02 INTO l_npq.npq22 FROM nma_file WHERE nma01 = l_aph08
         ELSE
            LET l_npq.npq21 = l_apf.apf03
            LET l_npq.npq22 = l_apf.apf12
         END IF
      ELSE
#No.MOD-C90214 --begin
         IF l_aph03 = 'D' THEN
            LET l_npq.npq21 = l_nmh.nmh11
            LET l_npq.npq22 = l_nmh.nmh30
         ELSE
            LET l_npq.npq21 = l_apf.apf03
            LET l_npq.npq22 = l_apf.apf12
         END IF        
#         LET l_npq.npq21 = l_apf.apf03
#         LET l_npq.npq22 = l_apf.apf12
#No.MOD-C90214 --end
      END IF
##--------------------------
      IF l_npq.npq07 < 0 THEN		# 本幣匯兌損益為負者, 須變號
         LET l_npq.npq07 = l_npq.npq07 * -1
         IF l_aph03<>'E' THEN   #FUN-C90044
            LET l_npq.npq06 = '1'
         END IF   #FUN-C90044
      END IF
      IF l_npq.npq07f < 0 THEN		# 原幣匯兌損益為負者, 須變號
         LET l_npq.npq07f = l_npq.npq07f * -1
         IF l_aph03<>'E' THEN   #FUN-C90044
            LET l_npq.npq06 = '1'
         END IF  #FUN-C90044
      END IF
      SELECT aag05,aag371 INTO l_aag05,l_aag371 FROM aag_file   #CHI-760007
       WHERE aag01=l_npq.npq03
         AND aag00=g_bookno3     #No.FUN-730064   
      IF l_aag05='Y' THEN
         LET l_npq.npq05 = l_apf.apf05
      ELSE
         LET l_npq.npq05 = ' '     
      END IF
      LET l_npq.npq11 = ''
      LET l_npq.npq12 = ''
      LET l_npq.npq13 = ''
      LET l_npq.npq14 = ''
      LET l_npq.npq31 = ''
      LET l_npq.npq32 = ''
      LET l_npq.npq33 = ''
      LET l_npq.npq34 = ''
      LET l_npq.npq35 = ''
      LET l_npq.npq36 = ''
      LET l_npq.npq37 = ''
     #CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)   #No.FUN-730064    #CHI-A20022 mark
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_apg02,l_aph02,g_bookno3)           #CHI-A20022 add 
      RETURNING l_npq.*
      CALL s_def_npq31_npq34(l_npq.*,g_bookno3)                 #FUN-AA0087
      RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
      IF YEAR(g_apf02) <> YEAR(l_apa02) THEN
         CALL s_tag(YEAR(g_apf02),g_bookno3,l_npq.npq03)
              RETURNING l_bookno,l_npq.npq03
      END IF
    # IF l_aag371 MATCHES '[23]' THEN                  #FUN-950053 mark
      IF l_aag371 MATCHES '[234]' THEN                 #FUN-950053 add
        #-->for 合併報表-關係人
        SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
         WHERE pmc01=l_apf.apf03
        IF cl_null(l_npq.npq37) THEN
           IF l_pmc903 = 'Y' THEN
              LET l_npq.npq37 = l_apf.apf03 CLIPPED   #No.CHI-830037
           END IF
        END IF
      END IF
      LET l_npq.npqlegal= g_legal  #FUN-980001 add
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
#        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
      ELSE
         LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
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
      MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
      IF SQLCA.sqlcode THEN
         #CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t310_g_gl(ckp#2)",1)  #No.FUN-660122 #FUN-D40089 mark
         CALL s_errmsg('',l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,1)      #FUN-D40089 add
         LET g_success='N' EXIT FOREACH #no.5573
      END IF
      LET l_npq.npq02 = l_npq.npq02 + 1
   END FOREACH
   
#No.FUN-A60024 --begin

   LET g_sql = " SELECT aph02,aph03,aph13,aph14,aph21,aph04,aph041,aph05,aph05f",   #No.FUN-A90007 add aph21 aph04 aph041 #MOD-D10098 add aph02
               "   FROM aph_file,apf_file",
               "  WHERE aph01 = '",l_apf.apf01,"'",
               "    AND apf01 = aph01 AND apf00 ='36'"

               
   PREPARE t310_gl_p4 FROM g_sql
   DECLARE t310_gl_c4 CURSOR FOR t310_gl_p4
   FOREACH t310_gl_c4 INTO l_aph02,l_aph03,l_curr,l_rate,l_aph21,l_aph04,l_aph041,l_amt,l_amtf     #No.FUN-A90007 add aph21 aph04 aph041 #MOD-D10098 add aph02                                                                                                                    
      IF p_npptype = '0' THEN
         LET l_npq.npq03 = l_aph04
      ELSE 
         LET l_npq.npq03 = l_aph041
      END IF           
      LET l_npq.npq04 = NULL
    # LET l_npq.npq06 = '2'#FUN-C90027 mark
#No.FUN-C90027--BEGIN
     IF p_aptype = '36' AND l_apf.apf47 = '2' THEN
        LET l_npq.npq06 = '1'
     ELSE
        LET l_npq.npq06 = '2'
     END IF
#No.FUN-C90027--END
      LET l_npq.npq07 = l_amt
      LET l_npq.npq07f= l_amtf
      LET l_npq.npq24 = l_curr
      LET l_npq.npq25 = l_rate
      LET g_npq25 = l_npq.npq25  #FUN-9A0036
#No.FUN-A90007 --begin
      LET l_npq.npq21 = l_aph21
      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file WHERE pmc01 = l_aph21
#      LET l_npq.npq21 = l_apf.apf46
#      SELECT pmc03 INTO l_npq.npq22 FROM pmc_file WHERE pmc01 = l_apf.apf46
#No.FUN-A90007 --end
      LET l_npq.npq05 = ' '     
      LET l_npq.npq11 = ''
      LET l_npq.npq12 = ''
      LET l_npq.npq13 = ''
      LET l_npq.npq14 = ''
      LET l_npq.npq23 = ''
      LET l_npq.npq31 = ''
      LET l_npq.npq32 = ''
      LET l_npq.npq33 = ''
      LET l_npq.npq34 = ''
      LET l_npq.npq35 = ''
      LET l_npq.npq36 = ''
      LET l_npq.npq37 = ''
      LET l_npq.npqlegal= g_legal  
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
           SELECT aaa03 INTO l_aaa03 FROM aaa_file
            WHERE aaa01 = g_bookno2
           SELECT azi04 INTO g_azi04_2 FROM azi_file
            WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_apf.apf02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
        ELSE
           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
     END IF
#No.FUN-9A0036 --End
      CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,l_apg02,l_aph02,g_bookno3)             #MOD-D40164
      RETURNING l_npq.*                                                                            #MOD-D40164
     #No.MOD-D10098  --Begin
     IF cl_null(l_npq.npq04) THEN 
        CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,l_apg02,l_aph02)  #摘要 
        RETURNING l_npq.npq04
     END IF
     #FUN-D10065--add--str--
      CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','')
      RETURNING l_npq.npq04
      #FUN-D10065--add--end--
     #No.MOD-D10098  --Begin
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
      LET l_npq.npq02 = l_npq.npq02 + 1
   END FOREACH
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
#No.FUN-A60024 --end
   CALL t310_gen_diff(l_npp.*)         #FUN-A40033 Add
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021    
   CALL cl_getmsg('aap-055',g_lang) RETURNING g_msg
   MESSAGE g_msg CLIPPED
END FUNCTION
 
FUNCTION t310_gl_ins_npq(p_apno,l_actno,l_aph03,l_duedate,l_curr,l_rate,l_npq02,l_npq07,l_npq07f,p_npptype) #No.FUN-680029 新增p_npptype
  DEFINE p_apno        LIKE apf_file.apf01
  DEFINE l_aag05       LIKE aag_file.aag05
  DEFINE l_aag371      LIKE aag_file.aag371   #CHI-760007
  DEFINE l_apf         RECORD LIKE apf_file.*
  DEFINE l_npq         RECORD LIKE npq_file.*
  DEFINE l_actno       LIKE apa_file.apa54     #FUN-660117
  DEFINE l_aph03       LIKE aph_file.aph03
  DEFINE l_duedate     LIKE type_file.dat     #No.FUN-690028 DATE
  DEFINE l_curr        LIKE npq_file.npq24
  DEFINE l_rate        LIKE npq_file.npq25
  DEFINE l_apb25       LIKE apb_file.apb25
  DEFINE l_apb24       LIKE apb_file.apb24
  DEFINE l_apb10       LIKE apb_file.apb10
  DEFINE l_npq02       LIKE npq_file.npq02
  DEFINE l_npq07       LIKE npq_file.npq07
  DEFINE l_npq07f      LIKE npq_file.npq07f
  DEFINE s_npq07       LIKE npq_file.npq07
  DEFINE s_npq07f      LIKE npq_file.npq07f
  DEFINE l_apa31       LIKE apa_file.apa31
  DEFINE l_apa31f      LIKE apa_file.apa31f
  DEFINE p_npptype     LIKE npp_file.npptype   #No.FUN-680029
  DEFINE l_cnt         LIKE type_file.num5    #No.FUN-690028 SMALLINT
  DEFINE l_cnt2        LIKE type_file.num5    #No.FUN-690028 SMALLINT
  DEFINE l_bookno      LIKE aag_file.aag00    #No.FUN-740184
  DEFINE l_pmc03       LIKE pmc_file.pmc03   #CHI-760007
  DEFINE l_pmc903      LIKE pmc_file.pmc903  #CHI-760007
  DEFINE l_aaa03       LIKE aaa_file.aaa03    #FUN-A40067
  DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add 
  DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
  LET l_npq.npqsys = 'AP'
  LET l_npq.npq00  = 3
  LET l_npq.npq011 = 1
  LET l_npq.npq02 = l_npq02
  LET l_npq.npqtype = p_npptype  #MOD-680083
  SELECT * INTO l_apf.* FROM apf_file WHERE apf01 = p_apno
  LET l_npq.npq01  = l_apf.apf01
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM apb_file
      WHERE apb01 = (SELECT apa08 FROM apa_file WHERE apa01 = l_actno)
 
  SELECT apa02 INTO g_apa02 FROM apa_file WHERE apa01 = l_actno 
 #CALL s_get_bookno(YEAR(g_apa02)) RETURNING g_flag,g_bookno1,g_bookno2      #MOD-D10147 mark
  CALL s_get_bookno(YEAR(g_apf02)) RETURNING g_flag,g_bookno1,g_bookno2      #MOD-D10147 add
  IF g_flag='1' THEN
     #CALL cl_err(g_apa02,'aoo-081',1)                      #FUN-D40089 mark
     CALL s_errmsg('',l_apf.apf01,g_apa02,'aoo-081',1)      #FUN-D40089 add
  END IF
  IF p_npptype = '0' THEN                                                                                                          
     LET g_bookno3 = g_bookno1                                                                                                     
  ELSE                                                                                                                             
     LET g_bookno3 = g_bookno2                                                                                                     
  END IF                                                                                                                           
 
     IF p_npptype = '0' THEN
        LET g_sql = " SELECT apb25,apb24,apb10 FROM apb_file ",
                    "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
                    "  WHERE apa01 = '",l_actno,"')"
     ELSE
        LET g_sql = " SELECT apb251,apb24,apb10 FROM apb_file ",
                    "  WHERE apb01 = (SELECT apa08 FROM apa_file ",
                    "  WHERE apa01 = '",l_actno,"')"
     END IF
     PREPARE t310_gl_p3 FROM g_sql
     DECLARE t310_gl_c3 CURSOR FOR t310_gl_p3
     LET l_apa31 = 0
     LET l_apa31f = 0
     FOREACH t310_gl_c3 INTO l_apb25,l_apb24,l_apb10
        LET l_apa31 = l_apa31 + l_apb10   #MOD-680083
        LET l_apa31f = l_apa31f + l_apb24   #MOD-680083
     END FOREACH
     LET l_cnt2 = 1
     LET s_npq07 = 0
     LET s_npq07f = 0
     FOREACH t310_gl_c3 INTO l_apb25,l_apb24,l_apb10
        IF l_cnt2 = l_cnt THEN
           LET l_npq.npq07 = l_npq07 - s_npq07
           LET l_npq.npq07f = l_npq07f - s_npq07f
        ELSE
           LET l_npq.npq07 = l_apb10 * (l_npq07/l_apa31)   #MOD-680083
           LET l_npq.npq07f= l_apb24 * (l_npq07f/l_apa31f)   #MOD-680083
        END IF
        LET l_npq.npq03 = l_apb25
        LET l_npq.npq23 = l_actno
        LET l_npq.npq04 = NULL
       #FUN-D10065---mark--str	
       #IF l_aph03 = "1" OR l_aph03 = "2" THEN     #MOD-970273   
       #   CASE WHEN g_apz.apz44 = '1'
       #             LET l_npq.npq04=l_apf.apf03 CLIPPED,' ',l_apf.apf12
       #        WHEN g_apz.apz44 = '2'
       #             LET l_npq.npq04=l_apf.apf03 CLIPPED,' ',l_apf.apf12,' ',
       #                             l_duedate
       #   END CASE
       #END IF
       #FUN-D10065---mark--end
        LET l_npq.npq06 = '2'
        LET l_npq.npq24 = l_curr
        SELECT azi04 INTO t_azi04 FROM azi_file
           WHERE azi01 = l_curr
        LET l_npq.npq25 = l_rate
        LET l_npq.npq21 = l_apf.apf03
        LET l_npq.npq22 = l_apf.apf12
        IF l_npq.npq07 < 0 THEN                # 本幣匯兌損益為負者, 須變號
           LET l_npq.npq07 = l_npq.npq07 * -1
           LET l_npq.npq06 = '1'
        END IF
        IF l_npq.npq07f < 0 THEN               # 原幣匯兌損益為負者, 須變號
           LET l_npq.npq07f = l_npq.npq07f * -1
           LET l_npq.npq06 = '1'
        END IF
        SELECT aag05,aag371 INTO l_aag05,l_aag371 FROM aag_file   #CHI-760007
         WHERE aag01=l_npq.npq03
           AND aag00=g_bookno3   #No.FUN-730064
        IF l_aag05='Y' THEN
           LET l_npq.npq05 = l_apf.apf05
        ELSE
           LET l_npq.npq05 = ' '
        END IF
        LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)    #MOD-8A0274 mod t_azi04->g_azi04
        LET l_npq.npq07f = cl_digcut(l_npq.npq07f,t_azi04)  #MOD-8A0274 mod g_azi04->t_azi04
        IF YEAR(g_apf02) <> YEAR(g_apa02) THEN
           CALL s_tag(YEAR(g_apf02),g_bookno3,l_npq.npq03)
                RETURNING l_bookno,l_npq.npq03
        END IF
      # IF l_aag371 MATCHES '[23]' THEN            #FUN-950053 mark
        IF l_aag371 MATCHES '[234]' THEN           #FUN-950053 add 
          #-->for 合併報表-關係人
          SELECT pmc03,pmc903 INTO l_pmc03,l_pmc903 FROM pmc_file
           WHERE pmc01=l_apf.apf03
          IF cl_null(l_npq.npq37) THEN
             IF l_pmc903 = 'Y' THEN
                LET l_npq.npq37 = l_apf.apf03 CLIPPED   #No.CHI-830037
             END IF
          END IF
        END IF
        LET l_npq.npqlegal= g_legal  #FUN-980001 add
#No.FUN-9A0036 --Begin
      IF p_npptype = '1' THEN
#FUN-A40067 --Begin
           SELECT aaa03 INTO l_aaa03 FROM aaa_file
            WHERE aaa01 = g_bookno2
           SELECT azi04 INTO g_azi04_2 FROM azi_file
            WHERE azi01 = l_aaa03
#FUN-A40067 --End
         CALL s_newrate(g_bookno1,g_bookno2,l_npq.npq24,
                        g_npq25,l_apf.apf02)
         RETURNING l_npq.npq25
         LET l_npq.npq07 = l_npq.npq07f * l_npq.npq25
#          LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04_2) #FUN-A40067
        ELSE
           LET l_npq.npq07 = cl_digcut(l_npq.npq07,g_azi04)   #FUN-A40067
      END IF
#No.FUN-9A0036 --End
        #FUN-D10065--add--str--
        CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','')
        RETURNING l_npq.npq04
        IF l_aph03 = "1" OR l_aph03 = "2" THEN
           CASE WHEN g_apz.apz44 = '1'
                     LET l_npq.npq04=l_apf.apf03 CLIPPED,' ',l_apf.apf12
                WHEN g_apz.apz44 = '2'
                     LET l_npq.npq04=l_apf.apf03 CLIPPED,' ',l_apf.apf12,' ',
                                     l_duedate
           END CASE
        END IF
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
        MESSAGE '>',l_npq.npq02,' ',l_npq.npq03,' ',l_npq.npq06,' ',l_npq.npq07
        IF SQLCA.sqlcode THEN
           #CALL cl_err3("ins","npq_file",l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,"","t310_g_gl(ckp#2)",1)  #No.FUN-660122 #FUN-D40089 mark
           CALL s_errmsg('',l_npq.npq00,l_npq.npq01,SQLCA.sqlcode,1)      #FUN-D40089 add
           LET g_success='N' EXIT FOREACH
        END IF
        LET l_npq.npq02 = l_npq.npq02 + 1
        LET l_cnt2 = l_cnt2 + 1
        LET s_npq07 = s_npq07 + l_npq.npq07
        LET s_npq07f = s_npq07f + l_npq.npq07f
     END FOREACH
     RETURN l_npq.npq02
END FUNCTION
#No.FUN-A40033 --Begin
FUNCTION t310_gen_diff(l_npp)
DEFINE l_npp   RECORD LIKE npp_file.*
DEFINE l_aaa   RECORD LIKE aaa_file.*
DEFINE l_npq1           RECORD LIKE npq_file.*
DEFINE l_sum_cr         LIKE npq_file.npq07
DEFINE l_sum_dr         LIKE npq_file.npq07
DEFINE l_aag44          LIKE aag_file.aag44  #No.FUN-D40118   Add
DEFINE l_flag           LIKE type_file.chr1  #No.FUN-D40118   Add
   IF l_npp.npptype = '1' THEN
      CALL s_get_bookno(YEAR(g_apf02)) 
         RETURNING g_flag,g_bookno1,g_bookno2                                                        
      IF g_flag =  '1' THEN
         #CALL cl_err(g_apf02,'aoo-081',1)                      #FUN-D40089 mark
         CALL s_errmsg('',l_npp.npp01,g_apf02,'aoo-081',1)      #FUN-D40089 add    
         RETURN                                                                                                                        
      END IF                                                                                                                           
      LET g_bookno3 = g_bookno2
      SELECT * INTO l_aaa.* FROM aaa_file WHERE aaa01 = g_bookno3
      LET l_sum_cr = 0 
      LET l_sum_dr = 0 
      SELECT SUM(npq07) INTO l_sum_dr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = l_npp.npp00
         AND npq01 = l_npp.npp01
         AND npq011= l_npp.npp011
         AND npqsys= l_npp.nppsys
         AND npq06 = '1'
      SELECT SUM(npq07) INTO l_sum_cr
        FROM npq_file
       WHERE npqtype = '1'
         AND npq00 = l_npp.npp00
         AND npq01 = l_npp.npp01
         AND npq011= l_npp.npp011
         AND npqsys= l_npp.nppsys
         AND npq06 = '2'
      IF l_sum_dr <> l_sum_cr THEN
         SELECT MAX(npq02)+1 INTO l_npq1.npq02
           FROM npq_file
          WHERE npqtype = '1'
            AND npq00 = l_npp.npp00
            AND npq01 = l_npp.npp01
            AND npq011= l_npp.npp011
            AND npqsys= l_npp.nppsys
         LET l_npq1.npqtype = l_npp.npptype
         LET l_npq1.npq00 = l_npp.npp00
         LET l_npq1.npq01 = l_npp.npp01
         LET l_npq1.npq011= l_npp.npp011
         LET l_npq1.npqsys= l_npp.nppsys
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
          WHERE aag00 = g_bookno2
            AND aag01 = l_npq1.npq03
         IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq1.npq03,g_bookno2) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq1.npq03 = ''
            END IF
         END IF
        #FUN-D40118 ---Add--- End
         INSERT INTO npq_file VALUES(l_npq1.*)
         IF SQLCA.sqlcode THEN
            #CALL cl_err3("ins","npq_file",l_npp.npp01,"",STATUS,"","",1) #FUN-670091 #FUN-D40089 mark
            CALL s_errmsg('',l_npp.npp01,'',STATUS,1)      #FUN-D40089 add    
            LET g_success = 'N'
            ROLLBACK WORK
         END IF
      END IF
   END IF   
END FUNCTION
#No.FUN-A40033 --End
#No.FUN-9C0072 精簡程式碼

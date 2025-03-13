# Prog. Version..: '5.30.06-13.04.02(00010)'     #
#
# Pattern name...: s_card.4gl
# Descriptions...: 儲值卡銷售/儲值卡充值
# Date & Author..: 09/07/08 By dongbg #FUN-960141 
# Usage..........: CALL s_card_in(p_no,p_sw)
# Input Parameter: p_no    儲值卡銷售/充值單號   
#                  p_sw    1:儲值卡銷售
#                          2:儲值卡充值
# Return Code....: g_flag  0:不成功
#                          1:成功            
#                  g_no    AR單號
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/09 By douzh GP5.2集團架構sub傳參修改
# Modify.........: No.FUN-9B0106 09/11/19 By kevin 用s_dbstring(l_dbs CLIPPED) 判斷跨資料庫
# Modify.........: No.FUN-9C0028 09/12/04 By lutingting 修改應收金額
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying s_t300_gl,s_t300_rgl增加一參數
# Modify.........: No.FUN-9C0061 09/12/11 By lutingting cl_err3第一個參數不可以為空
# Modify.........: No.FUN-9C0086 09/12/17 By lutingting 發卡應收金額應為應付款金額合計而不應該為卡內金額
# Modify.........: No.FUN-9C0109 09/12/21 By lutingting 儲值卡發卡邏輯更改
# Modify.........: No.FUN-9C0168 10/01/04 By lutingting 款別對應銀行改由axri060抓取
# Modify.........: No.TQC-A10133 10/01/19 By lutingting almt610審核報錯 
# Modify.........: No:FUN-A10104 10/01/20 By shiwuying s_t300_gl
# Modify.........: No.TQC-A10136 10/01/22 By lutingting1：若購卡不充值得話則不生成18得單據;
#                                                      2：折扣科目取axri090轉費用科目,現在取得是款別對應銀行得科目
# Modify.........: No:FUN-A40076 10/07/02 By xiaofeizhu 更改ooa37的默認值，如果為Y改為2，N改為1
# Modify.........: No:TQC-A70012 10/07/06 BY houlia 賦值g_legal
# Modify.........: No:FUN-A70118 10/07/29 BY shiwuying xxxlegal賦值,重新過單
# Modify.........: No:MOD-A90013 10/09/03 By lilingyu 審核時報錯:無法更新AR檔
# Modify.........: No.TQC-AB0068 10/11/23 by destiny oma_file增加預設值 
# Modify.........: No.TQC-AC0089 10/12/09 By huangtao 儲值卡銷售不需要產生nme_file
# Modify.........: No.TQC-AC0115 10/12/15 By huangtao l_ool.ool35未賦值
# Modify.........: No.TQC-AC0229 10/12/16 by destiny 重新过单           
# Modify.........: No:FUN-AB0034 10/12/16 By wujie   oma73/oma73f预设0
# Modify.........: No:TQC-AC0127 11/01/07 By shiwuying ooaconf=Y
# Modify.........: No:TQC-B10130 11/01/13 By huangtao 修正TQC-AC0089
# Modify.........: No:TQC-B10270 11/01/27 By yinhy 流通財務拋轉時產生的票據資料nmh41改為'N'，nmh21默認值=axri060支票對應銀行
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: NO.MOD-B40159 11/04/19 By zhangll 修正缺少oow資料時，程序跳出現象
# Modify.........: NO.FUN-B40011 11/04/20 By guoch   add nmh42
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file   
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0

DATABASE ds
 
GLOBALS "../../config/top.global"
DEFINE g_lps RECORD LIKE lps_file.*,
       g_lpu RECORD LIKE lpu_file.*,
       g_oma RECORD LIKE oma_file.*,
       g_omb RECORD LIKE omb_file.*,
       g_omc RECORD LIKE omc_file.*,
       g_ooa RECORD LIKE ooa_file.*,
       g_oob RECORD LIKE oob_file.*,
       g_nmh RECORD LIKE nmh_file.*,
       g_oow RECORD LIKE oow_file.*,
       g_nms RECORD LIKE nms_file.*,
       g_flag       LIKE type_file.chr1,
       g_dbs2       LIKE type_file.chr21,
       g_plant2     LIKE type_file.chr10,    #FUN-980020
       g_trno       LIKE oma_file.oma01,
       g_net        LIKE oox_file.oox10,
       g_chr        LIKE oma_file.oma20,
       g_cnt        LIKE type_file.num5,
       g_dept       LIKE nmh_file.nmh15,
       g_bookno1    LIKE aza_file.aza81,
       g_bookno2    LIKE aza_file.aza82,
       g_sql        LIKE type_file.chr1000,
       g_flag1      LIKE type_file.chr1,
       li_result    LIKE type_file.num5
FUNCTION s_card_in(p_no,p_sw)
DEFINE p_no         LIKE lps_file.lps01,
       p_sw         LIKE type_file.chr1,
       l_cnt        LIKE type_file.num5,
       l_cardno     LIKE lpt_file.lpt02,
       #l_ryd05      LIKE ryd_file.ryd05,   #FUN-9C0168
       l_ooe02      LIKE ooe_file.ooe02,    #FUN-9C0168
       l_rxx02      LIKE rxx_file.rxx02,
       l_rxx04      LIKE rxx_file.rxx04,
       l_t1         LIKE oma_file.oma01,
       l_ool RECORD LIKE ool_file.*,
       l_rxy RECORD LIKE rxy_file.*,
       l_occ RECORD LIKE occ_file.*,
       l_omc RECORD LIKE omc_file.*
#FUN-9C0109--add--str--
DEFINE l_cardno1  LIKE lpt_file.lpt02    #结束卡号
DEFINE l_lpt03    LIKE lpt_file.lpt03    #卡种
DEFINE l_lph33    LIKE lph_file.lph33    #固定编号位数
DEFINE l_lpt09    LIKE lpt_file.lpt09    #单张卡内金额
DEFINE l_length   LIKE type_file.num20
DEFINE l_amt      LIKE lps_file.lps05    #折扣金額
DEFINE l_oma      RECORD LIKE oma_file.*
DEFINE l_oob01    LIKE oob_file.oob01
DEFINE l_aag05    LIKE aag_file.aag05 
#FUN-9C0109--add--end
DEFINE l_ooe02_1  LIKE ooe_file.ooe02   #TQC-B10270

 
   INITIALIZE g_oma.* TO NULL
   INITIALIZE g_omb.* TO NULL
   INITIALIZE g_lps.* TO NULL
   INITIALIZE g_lpu.* TO NULL
   INITIALIZE g_omc.* TO NULL
   INITIALIZE g_ooa.* TO NULL
   INITIALIZE g_oob.* TO NULL
   INITIALIZE g_nmh.* TO NULL
   INITIALIZE g_nms.* TO NULL
   INITIALIZE g_oow.* TO NULL
   INITIALIZE l_ool.* TO NULL
   INITIALIZE l_rxy.* TO NULL
   INITIALIZE l_occ.* TO NULL
   INITIALIZE l_omc.* TO NULL
   IF cl_null(p_no) THEN RETURN 0,g_oma.oma01 END IF
   IF p_sw = '1' THEN
      SELECT * INTO g_lps.* FROM lps_file WHERE lps01 = p_no AND lpsacti = 'Y'
   ELSE
      SELECT * INTO g_lpu.* FROM lpu_file WHERE lpu01 = p_no AND lpuacti = 'Y'
   END IF
   IF STATUS THEN RETURN 0,g_oma.oma01 END IF
   
   SELECT * INTO g_oow.* FROM oow_file WHERE oow00 = '0'
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('oob07',p_no,'','alm-998',1)
      ELSE
         CALL cl_err3("sel","oow_file","","","alm-998","","sel oow",1)                                        
      END IF
      LET g_success = 'N'
      RETURN 0,g_oma.oma01 #MOD-B40159 add
   END IF
   IF cl_null(g_oow.oow09) THEN
      IF g_bgerr THEN
         CALL s_errmsg('oob07',p_no,'','axr-149',1)
      ELSE
         CALL cl_err3("sel","oow_file","","","axr-149","","oow09 is null",1)                                        
      END IF
      LET g_success = 'N'
      RETURN 0,g_oma.oma01 #MOD-B40159 add
   END IF
   #FUN-9C0109--add--str--    #若為儲值卡發卡 且有卡費時 產生一筆17得應收 
   IF cl_null(g_oow.oow16) THEN
      IF g_bgerr THEN
         CALL s_errmsg('oob07',p_no,'','axr-149',1)
      ELSE
         CALL cl_err3("sel","oow_file","","","axr-149","","oow16 is null",1)                                        
      END IF
      LET g_success = 'N'
      RETURN 0,g_oma.oma01 #MOD-B40159 add
   END IF
   IF cl_null(g_oow.oow14) THEN
      IF g_bgerr THEN
         CALL s_errmsg('oob07',p_no,'','axr-149',1)
      ELSE
         CALL cl_err3("sel","oow_file","","","axr-149","","oow14 is null",1)                                        
      END IF
      LET g_success = 'N'
      RETURN 0,g_oma.oma01 #MOD-B40159 add
   END IF
   #MOD-B40159 add
   IF cl_null(g_oow.oow22) THEN
      IF g_bgerr THEN
         CALL s_errmsg('oob07',p_no,'','axr-149',1)
      ELSE
         CALL cl_err3("sel","oow_file","","","axr-149","","oow22 is null",1)
      END IF
      LET g_success = 'N'
      RETURN 0,g_oma.oma01
   END IF
   #MOD-B40159 add--end
#TQC-AC0089 -------------STA
    IF g_lps.lps07 = 0 THEN
       RETURN 1,g_oma.oma01
    END IF
#TQC-AC0089 -------------END
#MOD-A90013 --BEGIN--
    IF p_sw = '1' AND g_lps.lps16>0 THEN 
#TQC-AC0089 ------------mark
#   IF p_sw = '1' THEN
#      IF g_lps.lps16 = 0 THEN                   
#         RETURN 1,g_oma.oma01
#      END IF 
#TQC-AC0089 ------------mark
#MOD-A90013 --END--
      CALL gen_17_omab(p_no)
      ######產生分錄底稿   (若單別設置產生分錄)
      IF g_success = 'Y' AND g_ooy.ooydmy1='Y' THEN
         CALL s_t300_gl(g_oma.oma01,'0')     
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_t300_gl(g_oma.oma01,'1') 
         END IF
         CALL i010_y_chk()
      END IF
   END IF
   IF p_sw = '2' OR (p_sw = '1' AND g_lps.lps05>0) THEN    #若只購卡不充值就不生成18得單據   #TQC-A10136
      INITIALIZE g_oma.* TO NULL
      INITIALIZE g_omb.* TO NULL
      INITIALIZE g_omc.* TO NULL
      INITIALIZE g_ooa.* TO NULL
      INITIALIZE g_oob.* TO NULL
      INITIALIZE g_nmh.* TO NULL
      INITIALIZE g_nms.* TO NULL
      INITIALIZE l_ool.* TO NULL
      INITIALIZE l_rxy.* TO NULL
      INITIALIZE l_occ.* TO NULL
      INITIALIZE l_omc.* TO NULL
   #FUN-9C0109--add--end

      LET g_oma.oma00='18'
      CALL s_auto_assign_no("AXR",g_oow.oow09,g_today,g_oma.oma00,"oma_file","oma01","","","")
         RETURNING li_result,g_oma.oma01
      IF (NOT li_result) THEN
         IF g_bgerr THEN
            CALL s_errmsg('oow09',p_no,'','abm-621',1)
         ELSE
            #CALL cl_err3("","oow_ile","","","abm-621","","",1)  #FUN-9C0061
            CALL cl_err3("sel","oow_ile","","","abm-621","","",1)  #FUN-9C0061                                      
         END IF
         LET g_success = 'N'
      END IF
      CALL s_get_doc_no(g_oma.oma01) RETURNING l_t1
      SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=l_t1
      SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'                                                                              
      SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0' 
      LET g_oma.oma02=g_today
      CALL s_get_bookno(year(g_oma.oma02))                                                                                   
         RETURNING g_flag1,g_bookno1,g_bookno2
      IF g_flag1='1' THEN #抓不到帳別                                                                                        
         IF g_bgerr THEN
            CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
         ELSE
            #CALL cl_err3("","oma_file",g_oma.oma02,"","aoo-081","","",1)   #FUN-9C0061
            CALL cl_err3("sel","oma_file",g_oma.oma02,"","aoo-081","","",1)   #FUN-9C0061                                     
         END IF
         LET g_success = 'N'
      END IF 
      LET g_oma.oma03='MISCCARD'
      LET g_oma.oma032='MISC'
      SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oma.oma03
      LET g_oma.oma68 = l_occ.occ07
      SELECT occ02 INTO g_oma.oma69 FROM occ_file WHERE occ01 = g_oma.oma68
      LET g_oma.oma04 = g_oma.oma03 LET g_oma.oma05 = l_occ.occ08
      LET g_oma.oma21 = l_occ.occ41 LET g_oma.oma23 = l_occ.occ42
      IF cl_null(g_oma.oma23) THEN LET g_oma.oma23=g_aza.aza17 END IF
      LET g_oma.oma40 = l_occ.occ37 LET g_oma.oma25 = l_occ.occ43
      LET g_oma.oma32 = l_occ.occ45 LET g_oma.oma042= l_occ.occ11
      LET g_oma.oma043= l_occ.occ18 LET g_oma.oma044= l_occ.occ231
      LET g_oma.oma51f = 0 LET g_oma.oma51 = 0
      LET g_plant2 = g_plant                      #FUN-980020
      LET g_dbs2 = s_dbstring(g_dbs CLIPPED)      #FUN-9B0106

#     CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_dbs2) RETURNING g_oma.oma11,g_oma.oma12     #FUN-980020 mark    
      CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant2) RETURNING g_oma.oma11,g_oma.oma12   #FUN-980020 
      SELECT gec04,gec05,gec07 INTO g_oma.oma211,g_oma.oma212,g_oma.oma213                                                          
         FROM gec_file WHERE gec01=g_oma.oma21 AND gec011='2'                                                                      
      LET g_oma.oma08  = '1'                                                                                                        
      IF cl_null(g_oma.oma211) THEN LET g_oma.oma211=0 END IF                                                                       
      IF g_oma.oma23=g_aza.aza17 THEN                                                                                               
         LET g_oma.oma24=1                                                                                                          
         LET g_oma.oma58=1                                                                                                          
      ELSE                                                                                                                          
         CALL s_curr3(g_oma.oma23,g_oma.oma02,g_ooz.ooz17) RETURNING g_oma.oma24                                                    
         CALL s_curr3(g_oma.oma23,g_oma.oma09,g_ooz.ooz17) RETURNING g_oma.oma58                                                    
      END IF                                                                                                                        
      SELECT occ67 INTO g_oma.oma13 FROM occ_file                                                                                   
         WHERE occ01 = g_oma.oma03                                                                                                  
      IF cl_null(g_oma.oma13) THEN LET g_oma.oma13 = g_ooz.ooz08 END IF                             
      LET g_oma.oma14 = g_user
      LET g_oma.oma15 = g_grup
      SELECT * INTO l_ool.* FROM ool_file WHERE ool01=g_oma.oma13
      LET g_oma.oma18 = l_ool.ool11
      IF g_aza.aza63 = 'Y' THEN LET g_oma.oma181 = l_ool.ool111 END IF
      IF p_sw = '1' THEN                #儲值卡銷售
         #LET g_oma.omaplant=g_lps.lpsplant    #FUN-960141 090824 mark
         LET g_oma.oma66 = g_lps.lpsplant      #FUN-960141 090824 add
         #LET g_oma.oma54t=g_lps.lps05   #卡金額合計   #FUN-9C0086
         #LET g_oma.oma54t=g_lps.lps07    #應付款金額合計   #FUN-9C0086   #FUN-9C0109
         #LET g_oma.oma54t =g_lps.lps07-g_lps.lps16   #FUN-9C0109
         LET g_oma.oma54t=g_lps.lps05   #卡金額合計   #FUN-9C0109
      ELSE
         #LET g_oma.omaplant=g_lpu.lpuplant    #FUN-960141 090824 mark
         LET g_oma.oma66 = g_lpu.lpuplant      #FUN-960141 090824 add 
         #LET g_oma.oma54t=g_lpu.lpu05   #卡金額合計
         #LET g_oma.oma54t = g_lpu.lpu07   #luttb   #FUN-9C0028
         LET g_oma.oma54t=g_lpu.lpu05   #卡金額合計 #FUN-9C0028
      END IF
      IF cl_null(g_oma.oma54t) THEN LET g_oma.oma54t=0 END IF
      CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t
      LET g_oma.oma70 = '1'
      LET g_oma.oma50 = 0
      LET g_oma.oma50t= 0
      LET g_oma.oma52 = 0
      LET g_oma.oma53 = 0
      LET g_oma.oma56t=g_oma.oma54t*g_oma.oma24
      IF cl_null(g_oma.oma56t) THEN LET g_oma.oma56t=0 END IF
      CALL cl_digcut(g_oma.oma50,t_azi04) RETURNING g_oma.oma50
      CALL cl_digcut(g_oma.oma50t,t_azi04) RETURNING g_oma.oma50t
      CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52
      CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53
      CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t
      IF g_oma.oma213 = 'N' THEN
         LET g_oma.oma54 = g_oma.oma54t
         LET g_oma.oma56 = g_oma.oma56t
      ELSE
         LET g_oma.oma54 = g_oma.oma54t/(1+g_oma.oma211/100)
         LET g_oma.oma56 = g_oma.oma56t/(1+g_oma.oma211/100)
      END IF
      IF cl_null(g_oma.oma54) THEN LET g_oma.oma54 = 0 END IF
      IF cl_null(g_oma.oma56) THEN LET g_oma.oma56 = 0 END IF
      CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54
      CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56
      LET g_oma.oma54x = g_oma.oma54t - g_oma.oma54
      LET g_oma.oma56x = g_oma.oma56t - g_oma.oma56
      LET g_oma.oma55 = 0
      LET g_oma.oma57 = 0
      LET g_oma.oma65 = '2'
      LET g_oma.omaconf = 'Y'
      LET g_oma.omavoid = 'N'
      LET g_oma.omauser = g_user
      LET g_oma.omagrup = g_grup
      LET g_oma.oma64 = '0'
      CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x
      CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x
      CALL cl_digcut(g_oma.oma55,t_azi04) RETURNING g_oma.oma55
      CALL cl_digcut(g_oma.oma57,g_azi04) RETURNING g_oma.oma57
      LET g_oma.oma16 = p_no    #FUN-9C0139
      LET g_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
      LET g_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
      IF cl_null(g_oma.omalegal) THEN LET g_oma.omalegal = g_legal END IF     #TQC-A70012 houlia
      IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 = 0 END IF #TQC-AB0068     #TQC-AC0229--mark
      IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f = 0 END IF #TQC-AB0068   #TQC-AC0229--mark
      IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF   #No.FUN-AB0034
      INSERT INTO oma_file VALUES(g_oma.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN  
            CALL s_errmsg('oma01',g_oma.oma01,'ins oma err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","oma_file",g_oma.oma01,g_oma.oma02,SQLCA.sqlcode,"","ins oma",1)                                        
         END IF
         LET g_success = 'N'
      END IF
###2:產生omb_file
      IF p_sw = '1' THEN    ###儲值卡銷售 根據單身產生omb_file      一對一
         LET g_sql = "SELECT lpt02,lpt021,lpt03,lpt09 FROM lpt_file WHERE lpt01 = '",p_no,"'"   #FUN-9C0109 add lpt021 lpt03 lpt09
      ELSE                  ###儲值卡充值 根據lpu_file產生omb_file  只有一筆
         LET g_sql = "SELECT lpu03,'','','' FROM lpu_file WHERE lpu01 = '",p_no,"'"  #FUN-9C0109 add '','',''
      END IF
      PREPARE l_pb1 FROM g_sql
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('oma01',g_oma.oma01,'pre err',SQLCA.sqlcode,1) 
         ELSE
            CALL cl_err3("pre","",p_no,"",SQLCA.sqlcode,"","pre",1)                                        
         END IF
         LET g_success = 'N'
      END IF
      DECLARE l_cs1 SCROLL CURSOR FOR l_pb1
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('oma01',g_oma.oma01,'declare err',SQLCA.sqlcode,1) 
         ELSE
            CALL cl_err3("dec","",p_no,"",SQLCA.sqlcode,"","dec",1)                                        
         END IF
         LET g_success = 'N'
      END IF
      FOREACH l_cs1 INTO l_cardno,l_cardno1,l_lpt03,l_lpt09
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('oma01',g_oma.oma01,'foreach err',SQLCA.sqlcode,1) 
         ELSE
            CALL cl_err3("for","",p_no,"",SQLCA.sqlcode,"","for",1)                                        
         END IF
         LET g_success = 'N'
      END IF
         LET g_omb.omb06 = l_cardno
         LET g_omb.omb00 = g_oma.oma00
         LET g_omb.omb01 = g_oma.oma01
         SELECT MAX(omb03)+1 INTO g_omb.omb03 FROM omb_file WHERE omb01=g_oma.oma01
         IF cl_null(g_omb.omb03) THEN LET g_omb.omb03=1 END IF
         LET g_omb.omb04 = 'MISCCARD'
         #FUN-9C0109--add--str--
         IF p_sw = '1' THEN   #数量为发卡数量
            LET l_length = LENGTH(l_cardno)
            SELECT lph33 INTO l_lph33 FROM lph_file
             WHERE lph01 = l_lpt03
            LET g_omb.omb12 = l_cardno1[l_lph33+1,l_length] - l_cardno[l_lph33+1,l_length]+1
         ELSE       	 
         #FUN-9C0109--add--end 
            LET g_omb.omb12 = 1
         END IF    #FUN-9C0109
         IF p_sw = '1' THEN
            #LET g_omb.omb13 = g_lps.lps04   #FUN-9C0109
            LET g_omb.omb13 = l_lpt09        #FUN-9C0109 
         ELSE
            LET g_omb.omb13 = g_lpu.lpu05
         END IF
         IF cl_null(g_omb.omb13) THEN LET g_omb.omb13=0 END IF
         CALL cl_digcut(g_omb.omb13,t_azi03) RETURNING g_omb.omb13
         LET g_omb.omb39 = 'N'
         LET g_omb.omb38 = '07'
         LET g_omb.omb34 = 0
         LET g_omb.omb35 = 0
         LET g_omb.omb36 = 0
         LET g_omb.omb37 = 0
         CALL cl_digcut(g_omb.omb34,t_azi04) RETURNING g_omb.omb34
         CALL cl_digcut(g_omb.omb35,g_azi04) RETURNING g_omb.omb35
         CALL cl_digcut(g_omb.omb37,t_azi04) RETURNING g_omb.omb37
         IF g_oma.oma213 = 'N' THEN
            LET g_omb.omb14 = g_omb.omb12 * g_omb.omb13
            CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14
            LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
            IF cl_null(g_omb.omb14t) THEN LET g_omb.omb14t=0 END IF
            CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t
         ELSE
            LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
            CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t
            LET g_omb.omb14 = g_omb.omb14t / (1 + g_oma.oma211 / 100)
            IF cl_null(g_omb.omb14) THEN LET g_omb.omb14=0 END IF
            CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14
         END IF
         LET g_omb.omb15 = g_omb.omb13 * g_oma.oma24
         LET g_omb.omb16 = g_omb.omb14 * g_oma.oma24
         LET g_omb.omb16t = g_omb.omb14t * g_oma.oma24
         LET g_omb.omb17 = g_omb.omb13 * g_oma.oma58
         LET g_omb.omb18 = g_omb.omb14 * g_oma.oma58
         LET g_omb.omb18t = g_omb.omb14t * g_oma.oma58
         IF cl_null(g_omb.omb15) THEN LET g_omb.omb15=0 END IF
         IF cl_null(g_omb.omb16) THEN LET g_omb.omb16=0 END IF
         IF cl_null(g_omb.omb16t) THEN LET g_omb.omb16t=0 END IF
         CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15
         CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16
         CALL cl_digcut(g_omb.omb16t,g_azi04) RETURNING g_omb.omb16t
         CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17
         CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18
         CALL cl_digcut(g_omb.omb18t,g_azi04) RETURNING g_omb.omb18t
    
         IF cl_null(g_omb.omblegal) THEN LET g_omb.omblegal= g_legal END IF    #TQC-A70012 houlia
         LET g_omb.omb48 = 0   #FUN-D10101 add
         INSERT INTO omb_file VALUES(g_omb.*)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            IF g_bgerr THEN
               CALL s_errmsg('omb01',g_oma.oma01,'ins omb err',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","omb_file",g_oma.oma01,g_oma.oma02,SQLCA.sqlcode,"","ins omb",1)                                        
            END IF
            LET g_success = 'N'
         END IF
      END FOREACH
###3:產生多賬期資料 產生一筆即可
      CALL s_ar_oox03(g_oma.oma01) RETURNING g_net
      LET l_omc.omc01 = g_oma.oma01
      LET l_omc.omc02 = 1
      LET l_omc.omc03 = g_oma.oma32
      LET l_omc.omc04 = g_oma.oma11
      LET l_omc.omc05 = g_oma.oma12
      LET l_omc.omc06 = g_oma.oma24
      LET l_omc.omc07 = g_oma.oma60
      LET l_omc.omc08 = g_oma.oma54t
      LET l_omc.omc09 = g_oma.oma56t
      LET l_omc.omc10 = 0
      LET l_omc.omc11 = 0
      LET l_omc.omc12 = g_oma.oma10
      LET l_omc.omc13 = l_omc.omc09-l_omc.omc11+g_net
      LET l_omc.omc14 = 0
      LET l_omc.omc15 = 0
      CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08
      CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09
      CALL cl_digcut(l_omc.omc13,g_azi04) RETURNING l_omc.omc13
      CALL cl_digcut(l_omc.omc14,t_azi04) RETURNING l_omc.omc14
      CALL cl_digcut(l_omc.omc15,g_azi04) RETURNING l_omc.omc15
      #LET l_omc.omcplant = g_oma.omaplant   #FUN-960140 mark 090824
      IF cl_null(l_omc.omclegal) THEN LET l_omc.omclegal= g_legal END IF    #TQC-A70012 houlia
      INSERT INTO omc_file VALUES(l_omc.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('omc01',g_oma.oma01,'ins omc err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","omc_file",g_oma.oma01,g_oma.oma02,SQLCA.sqlcode,"","ins omc",1)
         END IF
         LET g_success = 'N'
      END IF
   END IF    #TQC-A10136
###4:儲值卡充值根據收款匯總產生直接收款資料,儲值卡銷售產生axrt400單身借方資料   #FUN-9C0139
###產生oob_file
###
###若購卡時有折扣 折扣金額轉費用
   SELECT * INTO l_ool.* FROM ool_file WHERE ool01=g_oma.oma13        #TQC-AC0115 add
   #FUN-9C0139--mod--str--
   INITIALIZE g_oob.* TO NULL
   LET l_amt = g_lps.lps16+g_lps.lps05-g_lps.lps07    #折扣金額
   IF cl_null(l_amt) THEN LET l_amt = 0 END IF
   #TQC-A10133--add--str--
   IF p_sw = '1' AND l_amt<=0 THEN    #為almt610且沒有折扣
      LET g_oma.oma65 = '1'
      UPDATE oma_file SET oma65 = g_oma.oma65 WHERE oma01 = g_oma.oma01
   END IF 
   #TQC-A10133--add--end
   IF (p_sw = '1' AND l_amt > 0) OR (p_sw = '2' AND g_lpu.lpu07 > 0 ) THEN
   #IF (p_sw = '1' AND g_lps.lps06 > 0) OR (p_sw = '2' AND g_lpu.lpu07 > 0 ) THEN
   #FUN-9C0139--mod--end
      LET g_oob.oob01 = g_oma.oma01
      SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01=g_oma.oma01
      IF cl_null(g_oob.oob02) THEN LET g_oob.oob02=1 END IF
      LET g_oob.oob03 = '1'
      LET g_oob.oob04 = 'F'
      LET g_oob.oob06 = g_oma.oma01
      LET g_oob.oob08 = g_oma.oma24
      IF cl_null(g_oob.oob08) THEN
         LET g_oob.oob08 = 1
      END IF
      IF p_sw = '1' THEN
         #LET g_oob.oob09=g_lps.lps06   #FUN-9C0109
         LET g_oob.oob09 = l_amt        #FUN-9C0109
      ELSE
         LET g_oob.oob09=g_lpu.lpu07
      END IF
      CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
      LET g_oob.oob10=g_oob.oob08 * g_oob.oob09
      CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
      LET g_oob.oob22 = g_oob.oob09   #FUN-9C0109
      LET g_oob.oob13 = g_oma.oma15
      LET g_oob.oob17 = g_oow.oow13
      IF p_sw = '1' THEN
         LET g_oob.oob18 = g_oow.oow10
      ELSE
         LET g_oob.oob18 = g_oow.oow11
      END IF
     #TQC-A10136--mod--str--
     #SELECT nma05,nma10 INTO g_oob.oob11, g_oob.oob07 FROM nma_file WHERE nma01 = g_oob.oob17
     #IF g_aza.aza63 = 'Y' THEN
     #   SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01 = g_oob.oob17
     #END IF
      SELECT nma10 INTO g_oob.oob07 FROM nma_file WHERE nma01 = g_oob.oob17
      LET g_oob.oob11 = l_ool.ool34
      IF g_aza.aza63 = 'Y' THEN
         LET g_oob.oob111 = l_ool.ool341
      END IF 
     #TQC-A10136--mod--end
      LET g_oob.oob19 = '1'
      IF cl_null(g_oob.oob17) THEN
         IF g_bgerr THEN
            CALL s_errmsg('oob17',g_oma.oma01,'oob17 is null','alm-732',1)
         ELSE
            #CALL cl_err3("","oob_file",g_oob.oob01,"","alm-732","oob17 is null","",1)  #FUN-9C0061
            CALL cl_err3("sel","oob_file",g_oob.oob01,"","alm-732","oob17 is null","",1)  #FUN-9C0061
         END IF
         LET g_success = 'N'
      END IF
      IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
         IF g_bgerr THEN
            CALL s_errmsg('oob111',g_oob.oob01,'oob111 is null','axr-076',1)
         ELSE
            #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
            CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
         END IF
         LET g_success = 'N'
      END IF
      IF cl_null(g_oob.oob11) THEN
         IF g_bgerr THEN
            CALL s_errmsg('oob11',g_oob.oob01,'oob11 is null','axr-076',1)
         ELSE
            #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)   #FUN-9C0061
            CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)   #FUN-9C0061
         END IF
         LET g_success = 'N'
      END IF
      IF cl_null(g_oob.ooblegal) THEN LET g_oob.ooblegal = g_legal END IF  #TQC-A70012 houlia
      INSERT INTO oob_file VALUES(g_oob.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('oob01',g_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
         END IF
         LET g_success = 'N'
      END IF
      IF p_sw = '2'  THEN    #FUN-9C0109
         LET g_oob.oob02=-1*g_oob.oob02
         LET g_oob.oob03='2'
         LET g_oob.oob04='1'
         LET g_oob.oob06=g_oma.oma01
         IF cl_null(g_oob.oob17) THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob17',g_oma.oma01,'oob17 is null','alm-732',1)
            ELSE
               #CALL cl_err3("","oob_file",g_oob.oob01,"","alm-732","oob17 is null","",1)   #FUN-9C0061
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","alm-732","oob17 is null","",1)   #FUN-9C0061
            END IF
            LET g_success = 'N'
         END IF
         IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob111',g_oob.oob01,'oob111 is null','axr-076',1)
            ELSE
               #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)   #FUN-9C0061
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)   #FUN-9C0061
            END IF
            LET g_success = 'N'
         END IF
         IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob111',g_oob.oob01,'oob111 is null','axr-076',1)
            ELSE
               #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)   #FUN-9C0061
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)   #FUN-9C0061
            END IF
            LET g_success = 'N'
         END IF
         IF cl_null(g_oob.oob11) THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob11',g_oob.oob01,'oob11 is null','axr-076',1)
            ELSE
               #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob17 is null","",1)  #FUN-9C0061
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob17 is null","",1)  #FUN-9C0061
            END IF
            LET g_success = 'N'
         END IF

         IF cl_null(g_oob.ooblegal) THEN LET g_oob.ooblegal= g_legal END IF    #TQC-A70012houlia
         INSERT INTO oob_file VALUES(g_oob.*)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob01',g_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
            END IF
            LET g_success = 'N'
         END IF
       END IF   #FUN-9C0109
   END IF


   IF p_sw = '1' THEN     #儲值卡銷售
     #FUN-9C0168--mod--str--
     #LET g_sql = "SELECT rxx02,rxx04,ryd05 FROM rxx_file LEFT JOIN ryd_file ",
     #            "    ON rxx02 = ryd01",
      LET g_sql = "SELECT rxx02,rxx04,ooe02 FROM rxx_file LEFT JOIN ooe_file ",
                  "    ON rxx02 = ooe01",
     #FUN-9C0168--mod--end
                  " WHERE rxx00 = '20' AND rxx01= '",g_lps.lps01,"' ",
                  "   AND rxxplant='",g_lps.lpsplant,"'"
   ELSE                   #儲值卡充值
     #FUN-9C0168--mod--str--
     #LET g_sql = "SELECT rxx02,rxx04,ryd05 FROM rxx_file LEFT JOIN ryd_file ",
     #            "    ON rxx02 = ryd01",
      LET g_sql = "SELECT rxx02,rxx04,ooe02 FROM rxx_file LEFT JOIN ooe_file ",
                  "    ON rxx02 = ooe01",
     #FUN-9C0168--mod--end
                  " WHERE rxx00 = '21' AND rxx01='",g_lpu.lpu01,"' ",
                  "   AND rxxplant='",g_lpu.lpuplant,"'"
   END IF
   PREPARE l_pb2 FROM g_sql
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('rxx01',g_oma.oma01,'pre err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("pre","rxx_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",1)
      END IF
      LET g_success = 'N'
   END IF
   DECLARE l_cs2 SCROLL CURSOR FOR l_pb2
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('rxx01',g_oma.oma01,'dec err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("dec","rxx_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",1)
      END IF
      LET g_success = 'N'
   END IF
   FOREACH l_cs2 INTO l_rxx02,l_rxx04,l_ooe02   #FUN-9C0168 l_ryd05->l_ooe02
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('rxx01',g_oma.oma01,'for err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("dec","rxx_file",g_lpu.lpu01,"",SQLCA.sqlcode,"","",1)
      END IF
      LET g_success = 'N'
   END IF
      INITIALIZE g_oob.* TO NULL
      #FUN-9C0109--mod--str--
      IF p_sw = '1' THEN 
         CALL s_auto_assign_no("AXR",g_oow.oow14,g_today,"30","oob_file","oob01","","","")
             RETURNING li_result,l_oob01
         IF (NOT li_result) THEN
             LET g_success='N'
         END IF
         LET g_oob.oob01 = l_oob01
      ELSE  
      #FUN-9C0109 --mod--end 
         LET g_oob.oob01 = g_oma.oma01    #直接收款  
      END IF    #FUN-9C0109
      #SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01=g_oma.oma01   #FUN-9C0109
      SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01=g_oob.oob01    #FUN-9C0109
      IF cl_null(g_oob.oob02) THEN LET g_oob.oob02=1 END IF
      LET g_oob.oob03 = '1'
      LET g_oob.oob08 = g_oma.oma24
      IF cl_null(g_oob.oob08) THEN
         LET g_oob.oob08 = 1
      END IF
      LET g_oob.oob13 = g_oma.oma15
      #LET g_oob.oob17 = l_ryd05   #FUN-9C0168
      LET g_oob.oob17 = l_ooe02   #FUN-9C0168
      IF p_sw = '1' THEN
         LET g_oob.oob18 = g_oow.oow10
      ELSE 
         LET g_oob.oob18 = g_oow.oow11
      END IF
      IF NOT cl_null(g_oob.oob17) THEN
         #SELECT nma05,nma10 INTO g_oob.oob11, g_oob.oob07 FROM nma_file WHERE nma01 = l_ryd05  #FUN-9C0168
         SELECT nma05,nma10 INTO g_oob.oob11, g_oob.oob07 FROM nma_file WHERE nma01 = l_ooe02   #FUN-9C0168
         IF g_aza.aza63 = 'Y' THEN
            #SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01 = l_ryd05   #FUN-9C0168
            SELECT nma051 INTO g_oob.oob111 FROM nma_file WHERE nma01 = l_ooe02    #FUN-9C0168
         END IF
      END IF
      #LET g_oob.oobplant = g_oma.omaplant     #FUN-960141 mark 090824
      LET g_oob.oob19 = '1'
      IF l_rxx02 = '03' THEN   #支票
         LET g_oob.oob04 = '1'
         IF p_sw = '1' THEN
            LET g_sql = "SELECT * FROM rxy_file ",
                        "WHERE rxy01 = '",g_lps.lps01,"' AND rxyplant='",g_lps.lpsplant,
                        "' AND rxy00 = '20' and rxy03 = '03' and rxy04 = '1' and rxy05 > 0"
         ELSE
            LET g_sql = "SELECT * FROM rxy_file ",
                        "WHERE rxy01 = '",g_lpu.lpu01,"' AND rxyplant='",g_lpu.lpuplant,
                        "' AND rxy00 = '21' and rxy03 = '03' and rxy04 = '1' and rxy05 > 0"
         END IF
         PREPARE l_pb3 FROM g_sql
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg('rxy01',g_oma.oma01,'pre err',SQLCA.sqlcode,1) 
            ELSE
               CALL cl_err3("pre","rxy_file",g_lpu.lpu01,"03",SQLCA.sqlcode,"","",1)
            END IF 
            LET g_success = 'N'
         END IF
         DECLARE l_cs3 SCROLL CURSOR FOR l_pb3
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg('rxy01',g_oma.oma01,'dec err',SQLCA.sqlcode,1) 
            ELSE
               CALL cl_err3("dec","rxy_file",g_lpu.lpu01,"03",SQLCA.sqlcode,"","",1)
            END IF
            LET g_success = 'N'
         END IF
         FOREACH l_cs3 INTO l_rxy.*
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg('rxy01',g_oma.oma01,'for err',SQLCA.sqlcode,1) 
            ELSE
               CALL cl_err3("dec","rxy_file",g_lpu.lpu01,"03",SQLCA.sqlcode,"","",1)
            END IF
            LET g_success = 'N'
         END IF
            ###產生anmt200的資料
            CALL s_auto_assign_no("ANM",g_oow.oow22,g_today,"2","nmh_file","nmh01","","","")
                  RETURNING li_result,g_nmh.nmh01
            IF (NOT li_result) THEN
               IF g_bgerr THEN
                  CALL s_errmsg('oow22',p_no,'','abm-621',1)
               ELSE
                  #CALL cl_err3("","",p_no,"","abm-621","","",1)    #FUN-9C0061
                  CALL cl_err3("sel","",p_no,"","abm-621","","",1)    #FUN-9C0061
               END IF
               LET g_success = 'N'
            END IF
            LET g_nmh.nmh02 = l_rxy.rxy09
            CALL cl_digcut(g_nmh.nmh02,t_azi04) RETURNING g_nmh.nmh02
            LET g_nmh.nmh03 = g_oow.oow25
            LET g_nmh.nmh04 = l_rxy.rxy10
            LET g_nmh.nmh05 = l_rxy.rxy10
            #No.TQC-B10270  --Begin
            #LET g_nmh.nmh21 = g_oob.oob17 
            LET l_ooe02_1 = ' '
            SELECT ooe02 INTO l_ooe02_1 FROM ooe_file WHERE ooe01='03'
            LET g_nmh.nmh21 = l_ooe02_1
            #No.TQC-B10270  --End
            LET g_nmh.nmh07 = l_rxy.rxy06
            LET g_nmh.nmh08 = 0
            LET g_nmh.nmh11 = 'MISCCARD'
            LET g_nmh.nmh12 = g_oow.oow27
            LET g_nmh.nmh13 = 'N'
            LET g_nmh.nmh15 = g_oow.oow24
            LET g_nmh.nmh17 = l_rxy.rxy09
            CALL cl_digcut(g_nmh.nmh17,t_azi04) RETURNING g_nmh.nmh17
            LET g_nmh.nmh21 = l_ooe02
            LET g_nmh.nmh24 = '2'
            LET g_nmh.nmh25 = TODAY
            LET g_nmh.nmh28 = 1
            LET g_nmh.nmh38 = 'Y'
            LET g_nmh.nmh39 = 0
            LET g_nmh.nmh40 = 0
            CALL cl_digcut(g_nmh.nmh40,g_azi04) RETURNING g_nmh.nmh40
            IF g_nmz.nmz11 = 'Y' THEN LET g_dept = g_nmh.nmh15 ELSE LET g_dept = ' ' END IF
            SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
            LET g_nmh.nmh26  = g_nms.nms22
            LET g_nmh.nmh261 = g_nms.nms22
            LET g_nmh.nmh27  = g_nms.nms21
            LET g_nmh.nmh271 = g_nms.nms21
            LET g_nmh.nmh41 = 'N'   #FUN-9C0109
            LET g_nmh.nmhoriu = g_user      #No.FUN-980030 10/01/04
            LET g_nmh.nmhorig = g_grup      #No.FUN-980030 10/01/04
            IF cl_null(g_nmh.nmhlegal) THEN LET g_nmh.nmhlegal = g_legal END IF     #TQC-A70012 houlia
            IF cl_null(g_nmh.nmh42) THEN LET g_nmh.nmh42 = 0 END IF   #No.FUN-B40011
            INSERT INTO nmh_file VALUES(g_nmh.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               IF g_bgerr THEN
                  CALL s_errmsg('nmh01',g_oma.oma01,'ins nmh err',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"ins nmh","",1)
               END IF
               LET g_success = 'N'
            END IF
          ###oob的資料
            LET g_oob.oob04 = '1'
            LET g_oob.oob17 = NULL
            LET g_oob.oob18 = NULL  
            LET g_oob.oob06 = g_nmh.nmh01
            SELECT ool12,ool121 INTO g_oob.oob11,g_oob.oob111 FROM ool_file
             WHERE ool01 = g_oma.oma13
            #SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01=g_oma.oma01  #FUN-9C0109
            SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01=g_oob.oob01  #FUN-9C0109
            IF cl_null(g_oob.oob02) THEN LET g_oob.oob02=1 END IF
            LET g_oob.oob03 = '1'
            LET g_oob.oob06 = g_nmh.nmh01
            LET g_oob.oob09 = l_rxy.rxy09  
            CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
            LET g_oob.oob22 = g_oob.oob09    #FUN-9C0109
            LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
            CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
            IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN 
               IF g_bgerr THEN
                  CALL s_errmsg('oob111',g_oob.oob01,'oob111 is null','axr-076',1)
               ELSE
                  #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
                  CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
               END IF 
               LET g_success = 'N'
            END IF                       
            IF cl_null(g_oob.oob11) THEN
               IF g_bgerr THEN
                  CALL s_errmsg('oob11',g_oob.oob01,'oob11 is null','axr-076',1)
               ELSE
                  #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob11 is null","",1)  #FUN-9C0061
                  CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob11 is null","",1)  #FUN-9C0061
               END IF
               LET g_success = 'N'
            END IF
            LET g_oob.ooblegal = g_legal    #TQC-A70012houlia
            INSERT INTO oob_file VALUES(g_oob.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               IF g_bgerr THEN
                  CALL s_errmsg('oma01',g_oma.oma01,'ins oob err',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
               END IF
               LET g_success = 'N'
            END IF
            IF p_sw = '2' THEN    #儲值卡充值   #FUN-9C0109
               LET g_oob.oob02=-1*g_oob.oob02
               LET g_oob.oob03='2'
               LET g_oob.oob04='1'
               LET g_oob.oob06=g_oma.oma01
               LET g_oob.ooblegal = g_legal    #TQC-A70012houlia
               INSERT INTO oob_file VALUES(g_oob.*)
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  IF g_bgerr THEN 
                     CALL s_errmsg('oma01',g_oma.oma01,'ins oob err',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
                  END IF
                  LET g_success = 'N'
               END IF
            END IF   #FUN-9C0109
            #FUN-9C0109--add--str--若有溢收則產生一筆轉收入 
            IF l_rxy.rxy17>0 THEN
               IF p_sw = '1' THEN
                  LET g_oob.oob01 = l_oob01
               ELSE
                  LET g_oob.oob01 = g_oma.oma01    #直接收款
               END IF   
               SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file 
                WHERE oob01=g_oob.oob01   
               IF cl_null(g_oob.oob02) THEN LET g_oob.oob02=1 END IF
               LET g_oob.oob03 = '2'
               LET g_oob.oob04 = 'B' 
               LET g_oob.oob19 = '1'
               LET g_oob.oob06 = g_oma.oma01
               LET g_oob.oob07 = g_oma.oma23
               LET g_oob.oob08 = g_oma.oma24
               IF cl_null(g_oob.oob08) THEN
                  LET g_oob.oob08 = 1
               END IF
               LET g_oob.oob09 = l_rxy.rxy17
               IF cl_null(g_oob.oob09) THEN LET g_oob.oob09=0 END IF
               CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
               LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
               IF cl_null(g_oob.oob10) THEN LET g_oob.oob10=0 END IF
               CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
               LET g_oob.oob17 = NULL
               LET g_oob.oob18 = NULL
               LET g_oob.oob21 = NULL
               LET g_oob.oob13 = g_oma.oma15
               LET g_oob.oob11 = l_ool.ool35
               IF g_aza.aza63 = 'Y' THEN
                 LET g_oob.oob111 = l_ool.ool351
               END IF
               CALL s_get_bookno(year(g_oma.oma02))
                    RETURNING g_flag1,g_bookno1,g_bookno2
               IF g_flag1='1' THEN #抓不到帳別
                  IF g_bgerr THEN
                     CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
                  ELSE
                     CALL cl_err3("sel","oma_file",g_oma.oma02,"","aoo-081","","",1)   
                  END IF
                  LET g_success = 'N'
               END IF
               LET g_oob.oob22 = g_oob.oob09
               LET g_oob.oob07 = g_oma.oma23
               IF cl_null(g_oob.oob07) THEN LET g_oob.oob07 = g_aza.aza17 END IF
               IF g_oob.oob07 !=g_oma.oma23 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('oob07',g_oob.oob07,'','axr-144',1)
                  ELSE
                     CALL cl_err3("","oob_file",g_oob.oob07,"","axr-144","","",1)
                  END IF
                  LET g_success = 'N'
               END IF
               LET g_oob.ooblegal = g_legal    #TQC-A70012houlia
               INSERT INTO oob_file VALUES(g_oob.*)
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                  END IF
                  LET g_success = 'N'
                  RETURN g_success
               END IF
            END IF 
            #FUN-9C0109--add--end
         END FOREACH
      ELSE
         LET g_oob.oob04 = '2'   
         LET g_oob.oob06 = g_oma.oma01   
         LET g_oob.oob09=l_rxx04
         CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
         LET g_oob.oob22 = g_oob.oob09    #FUN-9C0109
         LET g_oob.oob10=g_oob.oob08 * g_oob.oob09
         CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
         IF cl_null(g_oob.oob17) THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob17',g_oma.oma01,'oob17 is null','alm-732',1)
            ELSE  
               #CALL cl_err3("","oob_file",g_oob.oob01,"","alm-732","oob17 is null","",1)  #FUN-9C0061
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","alm-732","oob17 is null","",1)  #FUN-9C0061
            END IF
            LET g_success = 'N'
         END IF
         IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN 
            IF g_bgerr THEN
               CALL s_errmsg('oob111',g_oob.oob01,'oob111 is null','axr-076',1)
            ELSE
               #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
            END IF
            LET g_success = 'N'
         END IF                       
         IF cl_null(g_oob.oob11) THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob11',g_oob.oob01,'oob11 is null','axr-076',1)
            ELSE
               #CALL cl_err3("","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1)  #FUN-9C0061
            END IF
            LET g_success = 'N'
         END IF
         IF cl_null(g_oob.ooblegal) THEN LET g_oob.ooblegal = g_legal END IF  #TQC-A70012 houlia
         INSERT INTO oob_file VALUES(g_oob.*)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            IF g_bgerr THEN 
               CALL s_errmsg('oob01',g_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
            ELSE 
               CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
            END IF
            LET g_success = 'N'
         END IF
         CALL s_ins_nme(p_sw)
         IF p_sw = '2'   THEN #儲值卡充值   #FUN-9C0139
            LET g_oob.oob02=-1*g_oob.oob02
            LET g_oob.oob03='2'
            LET g_oob.oob04='1'
            LET g_oob.oob06=g_oma.oma01
            LET g_oob.ooblegal = g_legal    #TQC-A70012houlia
            INSERT INTO oob_file VALUES(g_oob.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               IF g_bgerr THEN
                  CALL s_errmsg('oob01',g_oob.oob01,'ins oob err',SQLCA.sqlcode,1)
               ELSE 
                  CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
               END IF
               LET g_success = 'N'
            END IF
         END IF   #FUN-9C0109
      END IF
   END FOREACH

   IF (p_sw = '1' AND l_amt>0) OR p_sw = '2' THEN #FUN-9C0109 #儲值卡充值要生成直接收款,儲值卡銷售只有在有折扣得情況下才生成直接收款
      LET g_ooa.ooa00  = '2'
      LET g_ooa.ooa01 = g_oma.oma01
      LET g_ooa.ooa02  = g_oma.oma02
      LET g_ooa.ooa021 = g_today
      LET g_ooa.ooa03  = g_oma.oma03
      LET g_ooa.ooa032 = g_oma.oma032
      LET g_ooa.ooa13  = g_oma.oma13
      LET g_ooa.ooa14  = g_user
      LET g_ooa.ooa15  = g_grup
      LET g_ooa.ooa20  = 'Y'
      LET g_ooa.ooa23  = g_oma.oma23
      LET g_ooa.ooa24  = g_oma.oma24
      LET g_ooa.ooa34  = '1'  
      LET g_ooa.ooa31d = 0 LET g_ooa.ooa31c = 0
      LET g_ooa.ooa32d = 0 LET g_ooa.ooa32c = 0
      SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31d,g_ooa.ooa32d
        FROM oob_file WHERE oob01=g_oma.oma01 AND oob03='1'
                             AND oob02>0
      SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31c,g_ooa.ooa32c
        FROM oob_file WHERE oob01=g_oma.oma01 AND oob03='2'
                          AND oob02 > 0
      IF cl_null(g_ooa.ooa31d) THEN LET g_ooa.ooa31d=0 END IF
      IF cl_null(g_ooa.ooa32d) THEN LET g_ooa.ooa32d=0 END IF
      IF cl_null(g_ooa.ooa31c) THEN
         LET g_ooa.ooa31c=g_oma.oma54t
      ELSE
         LET g_ooa.ooa31c=g_oma.oma54t + g_ooa.ooa31c
      END IF
      IF cl_null(g_ooa.ooa32c) THEN
         LET g_ooa.ooa32c=g_oma.oma56t
      ELSE
         LET g_ooa.ooa32c=g_oma.oma56t + g_ooa.ooa32c
      END IF
   
      IF g_ooa.ooa31d < g_ooa.ooa31c THEN
         LET g_ooa.ooa31c=g_ooa.ooa31d
         LET g_ooa.ooa32c=g_ooa.ooa32d
      END IF
      LET g_ooa.ooa32d = cl_digcut(g_ooa.ooa32d,t_azi04)
      LET g_ooa.ooa32c = cl_digcut(g_ooa.ooa32c,t_azi04)
     #LET g_ooa.ooaconf= 'N' #TQC-AC0127
      LET g_ooa.ooaconf= 'Y' #TQC-AC0127
      LET g_ooa.ooa34  = '1' #TQC-AC0127
      LET g_ooa.ooaprsw= 0
      LET g_ooa.ooauser= g_user
      LET g_ooa.ooagrup= g_grup
      LET g_ooa.ooadate= g_today
      #LET g_ooa.ooaplant= g_oma.omaplant   #FUN-960141 mark 090824
      #LET g_ooa.ooa37= 'N'           #FUN-A40076 mark
      LET g_ooa.ooa37= '1'            #FUN-A40076 add
      LET g_ooa.ooa38= '1'
      LET g_ooa.ooaoriu = g_user      #No.FUN-980030 10/01/04
      LET g_ooa.ooaorig = g_grup      #No.FUN-980030 10/01/04
      IF cl_null(g_ooa.ooalegal) THEN LET g_ooa.ooalegal = g_legal END IF #TQC-A70012 houlia
      INSERT INTO ooa_file VALUES(g_ooa.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('ooa01',g_ooa.ooa01,'ins ooa err',SQLCA.sqlcode,1)
         ELSE 
            CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"ins ooa","",1)
         END IF
         LET g_success='N'
      END IF
   END IF   #FUN-9C0109

###5:產生分錄底稿   (若單別設置產生分錄)
  IF p_sw = '2' OR (p_sw='1' AND g_lps.lps05>0) THEN  #TQC-A10136 若只發卡不充值就不產生18得單據相應也不必產生18得分錄
   IF g_ooy.ooydmy1='Y' THEN
      IF g_oma.oma65 != '2' THEN
         CALL s_t300_gl(g_oma.oma01,'0')        #No.FUN-9C0014 #No.FUN-A10104
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_t300_gl(g_oma.oma01,'1')     #No.FUN-9C0014 #No.FUN-A10104
         END IF
         CALL i010_y_chk()
      ELSE
         CALL s_t300_rgl(g_oma.oma01,'0')       #No.FUN-9C0014 #No.FUN-A10104
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_t300_rgl(g_oma.oma01,'1')    #No.FUN-9C0014 #No.FUN-A10104
         END IF
         CALL i010_y_chk()
      END IF
   END IF
  END IF   #TQC-A10136
###6:更新已收金額oma55
   IF p_sw = '1' THEN   #FUN-9C0109
      IF cl_null(g_ooa.ooa31c) THEN LET g_ooa.ooa31c = 0  END IF    #TQC-A10133
      IF cl_null(g_ooa.ooa32c) THEN LET g_ooa.ooa32c = 0  END IF    #TQC-A10133
      UPDATE oma_file set oma55=g_ooa.ooa31c,
                          oma57=g_ooa.ooa32c
       WHERE oma01=g_oma.oma01
   ELSE
   #FUN-9C0109--add--str--
      UPDATE oma_file set oma55 = g_oma.oma54t,
                          oma57 = g_oma.oma56t
      WHERE oma01 = g_oma.oma01
   END IF 
   #FUN-9C0109--add--end
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_ooa.ooa01,'upd oma err',SQLCA.sqlcode,1)
      ELSE 
         CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"upd oma","",1)
      END IF
      LET g_success='N'
   END IF
#FUN-9C0139--add--str--
###儲值卡銷售產生axrt400貸方資料(用應收)以及單頭資料 
   IF p_sw = '1' THEN   
      INITIALIZE l_oma.* TO NULL 
      INITIALIZE g_oob.* TO NULL 
      LET g_sql = "SELECT * FROM oma_file WHERE oma16 = '",p_no,"' "
      PREPARE sel_oma_pre FROM g_sql
      DECLARE sel_oma_cs CURSOR FOR sel_oma_pre
      FOREACH sel_oma_cs INTO l_oma.*
         IF SQLCA.sqlcode THEN
            IF g_bgerr THEN
               CALL s_errmsg('oma01',l_oma.oma01,'foreach err',SQLCA.sqlcode,1) 
            ELSE
               CALL cl_err3("for","",p_no,"",SQLCA.sqlcode,"","for",1)                                        
            END IF
            LET g_success = 'N'
         END IF
         LET g_oob.oob01 = l_oob01
         SELECT MAX(oob02) + 1 INTO g_oob.oob02 FROM oob_file WHERE oob01=l_oob01
         IF cl_null(g_oob.oob02) THEN LET g_oob.oob02=1 END IF
         LET g_oob.oob03 = '2'
         LET g_oob.oob08 = l_oma.oma24
         IF cl_null(g_oob.oob08) THEN
            LET g_oob.oob08 = 1
         END IF
         LET g_oob.oob13 = l_oma.oma15
         SELECT ool11 INTO g_oob.oob11 FROM ool_file WHERE ool01 = l_oma.oma13
         IF g_aza.aza63 = 'Y' THEN
            SELECT ool111 INTO g_oob.oob111 FROM ool_file
             WHERE ool01 = l_oma.oma13
         END IF 
         LET g_oob.oob19 = '1'  
         LET g_oob.oob04 = '1'
         LET g_oob.oob17 = NULL
         LET g_oob.oob18 = NULL  
         LET g_oob.oob06 = l_oma.oma01
         LET g_oob.oob07 = l_oma.oma23  
         IF l_oma.oma00 = '18' THEN
            LET g_oob.oob09 = l_oma.oma54t-l_oma.oma55 
         ELSE 
            LET g_oob.oob09 = l_oma.oma54t
         END IF 
         CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
         LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
         CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
         IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN 
            IF g_bgerr THEN
               CALL s_errmsg('oob111',g_oob.oob01,'oob111 is null','axr-076',1)
            ELSE
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob111 is null","",1) 
            END IF 
            LET g_success = 'N'
         END IF                       
         IF cl_null(g_oob.oob11) THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob11',g_oob.oob01,'oob11 is null','axr-076',1)
            ELSE
               CALL cl_err3("sel","oob_file",g_oob.oob01,"","axr-076","oob11 is null","",1) 
            END IF
            LET g_success = 'N'
         END IF
          
         IF cl_null(g_oob.ooblegal) THEN LET g_oob.ooblegal= g_legal END IF    #houlia
         INSERT INTO oob_file VALUES(g_oob.*)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            IF g_bgerr THEN
               CALL s_errmsg('oma01',g_oma.oma01,'ins oob err',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err3("ins","oob_file",g_oob.oob01,"",SQLCA.sqlcode,"ins oob","",1)
            END IF
            LET g_success = 'N'
         ELSE
            UPDATE oma_file set oma55=oma55+g_oob.oob09,
                                oma57=oma57+g_oob.oob10
             WHERE oma01=l_oma.oma01
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               IF g_bgerr THEN
                  CALL s_errmsg('oma01',g_ooa.ooa01,'upd oma err',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"upd oma","",1)
               END IF
               LET g_success='N'
            END IF
         END IF
      END FOREACH
###產生ooa_file 產生axrt400單頭
      LET g_ooa.ooa00 = '1'
      LET g_ooa.ooa01 = l_oob01
      LET g_ooa.ooa02 = g_oma.oma02
      LET g_ooa.ooa021 = g_today
      LET g_ooa.ooa03  = g_oma.oma03
      LET g_ooa.ooa032 = g_oma.oma032
      LET g_ooa.ooa13  = g_oma.oma13
      LET g_ooa.ooa14  = g_user
      LET g_ooa.ooa15  = g_grup
      LET g_ooa.ooa20  = 'Y'
      LET g_ooa.ooa23  = g_oma.oma23
      LET g_ooa.ooa24  = g_oma.oma24
      LET g_ooa.ooa34  = '1'
      LET g_ooa.ooaconf= 'Y'
      LET g_ooa.ooaprsw= 0
      LET g_ooa.ooauser= g_user
      LET g_ooa.ooagrup= g_grup
      LET g_ooa.ooadate= g_today
      #LET g_ooa.ooa37= 'N'       #FUN-A40076 mark
      LET g_ooa.ooa37= '1'        #FUN-A40076 add
      LET g_ooa.ooa38= '1'
      SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31d,g_ooa.ooa32d
        FROM oob_file WHERE oob01=l_oob01 AND oob03='1'
                          AND oob02>0
      SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31c,g_ooa.ooa32c
        FROM oob_file WHERE oob01=l_oob01 AND oob03='2'
                          AND oob02 > 0
      IF cl_null(g_ooa.ooa31d) THEN LET g_ooa.ooa31d=0 END IF
      IF cl_null(g_ooa.ooa32d) THEN LET g_ooa.ooa32d=0 END IF
     
      IF cl_null(g_ooa.ooalegal) THEN LET g_ooa.ooalegal= g_legal END IF    #houlia
      INSERT INTO ooa_file VALUES(g_ooa.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('ooa01',g_ooa.ooa01,'ins ooa err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"ins ooa","",1)
         END IF
         LET g_success='N'
      END IF 
  
###產生axrt400得分錄底稿 
     SELECT ooydmy1 INTO g_ooy.ooydmy1 FROM ooy_file 
      WHERE ooyslip = g_oow.oow14
     IF g_ooy.ooydmy1 = 'Y' THEN     
        CALL s_t400_gl(l_oob01,'0')
        IF g_aza.aza63='Y' THEN
           CALL s_t400_gl(l_oob01,'1')
        END IF
        IF g_success = 'Y' THEN
           CALL s_chknpq(l_oob01,'AR',1,'0',g_bookno1)
           IF g_aza.aza63='Y' AND g_success='Y' THEN
              CALL s_chknpq(l_oob01,'AR',1,'1',g_bookno2)
           END IF
        END IF
     END IF
   END IF 
#FUN-9C0139--add--end 

###7:18性質的單據生成一張26的單據(根據oow19編碼) 參考s_ar_conf.4gl 15的單據生成26的單據段
   IF g_oma.oma00 = '18' THEN
      CALL s_yz_hu4('+')   
   END IF
   IF g_success='Y' THEN
      RETURN 1,g_oma.oma01           
   ELSE
      RETURN 0,g_oma.oma01 
   END IF
END FUNCTION
 
FUNCTION s_ins_nme(p_sw) 
   DEFINE l_nme     RECORD LIKE nme_file.*,
          l_ooa     RECORD LIKE ooa_file.*,
          l_oob     RECORD LIKE oob_file.*,
          p_sw      LIKE   type_file.num5 

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end

#TQC-B10130 -----------mark
##TQC-AC0089 ---------STA
#  IF p_sw = '1' THEN
#     RETURN
#  END IF
##TQC-AC0089 ---------END
#TQC-B10130 -----------mark
   LET l_ooa.* = g_ooa.*
   LET l_oob.* = g_oob.*
#TQC-B10130 -----------STA
   IF p_sw = '1' AND l_oob.oob04 <> '2' THEN
      RETURN
   END IF
#TQC-B10130 -----------END 
   IF l_oob.oob03='1' AND l_oob.oob04='2' THEN
      INITIALIZE l_nme.* TO NULL
      DISPLAY "INS_NME NOW...."
      LET l_nme.nme00 = 0
      LET l_nme.nme01 = l_oob.oob17
      LET l_nme.nme02 = g_oma.oma02
      LET l_nme.nme03 = l_oob.oob18
      LET l_nme.nme04 = l_oob.oob09
      LET l_nme.nme07 = l_oob.oob08
      LET l_nme.nme08 = l_oob.oob10
      LET l_nme.nme10 = l_ooa.ooa33
      IF cl_null(l_nme.nme10) THEN LET l_nme.nme10 = ' ' END IF
      LET l_nme.nme11 = ' '
      LET l_nme.nme12 = l_oob.oob06
      LET l_nme.nme13 = l_ooa.ooa032
      SELECT nmc05 INTO l_nme.nme14 FROM nmc_file
       WHERE nmc01 = l_nme.nme03
      LET l_nme.nme15 = l_ooa.ooa15
      LET l_nme.nme16 = g_oma.oma02
      LET l_nme.nme17 = g_trno
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=TODAY
      LET l_nme.nme21 = l_oob.oob02
      LET l_nme.nme22 = '08'
      LET l_nme.nme24 = '9'
      LET l_nme.nme25 = l_ooa.ooa03
      LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
      LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04
      IF cl_null(l_nme.nmelegal) THEN LET l_nme.nmelegal = g_legal END IF #TQC-A70012 houlia

#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end

      INSERT INTO nme_file VALUES(l_nme.*)                                                                                          
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('nme01',g_ooa.ooa01,'ins nme err',SQLCA.sqlcode,1)
         ELSE 
            CALL cl_err3("ins","nme_file",l_nme.nme01,l_nme.nme02,SQLCA.sqlcode,"","ins nme",1)                                        
         END IF
         LET g_success = 'N'
      END IF                                                                                                                        
      CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062   
   END IF          
 
END FUNCTION
 
FUNCTION s_yz_hu4(p_cmd)   
 
  DEFINE l_cnt          LIKE type_file.num5
  DEFINE p_cmd          LIKE type_file.chr1   
  DEFINE l_oma		      RECORD LIKE oma_file.*
  DEFINE l_omc		      RECORD LIKE omc_file.*
  DEFINE l_buf          LIKE type_file.chr3
  DEFINE l_str          STRING
  DEFINE l_oow19        LIKE oow_file.oow19

  LET l_str = "bu_22:",g_oma.oma01 CLIPPED,' ',g_oma.oma02 CLIPPED
  CALL cl_msg(l_str)
  
  INITIALIZE l_oma.* TO NULL
  IF p_cmd = '+' THEN
     LET l_oma.* = g_oma.*
     LET l_oma.oma70 = '1'
     SELECT oow19 INTO l_oow19 FROM oow_file
      WHERE oow00 = '0'
     IF STATUS OR cl_null(l_oow19) THEN
        IF g_bgerr THEN
           CALL s_errmsg('oob07',g_oma.oma01,'','axr-149',1)
        ELSE
           CALL cl_err3("sel","oow_file",l_oow19,"",STATUS,"","sel oow",1)
        END IF
        LET g_success = 'N'
        RETURN
     END IF
     CALL s_auto_assign_no("axr",l_oow19,l_oma.oma02,"26","oma_file","oma01","","","")
       RETURNING li_result,l_oma.oma01
     IF (NOT li_result) THEN
        IF g_bgerr THEN
           CALL s_errmsg('oow19',l_oma.oma01,'','abm-621',1)
        ELSE
           #CALL cl_err3("","oma_file",l_oow19,"","abm-621","","",1)  #FUN-9C0061
           CALL cl_err3("sel","oma_file",l_oow19,"","abm-621","","",1)  #FUN-9C0061
        END IF
        LET g_success = 'N'
        RETURN
     END IF
     CALL cl_msg(l_oma.oma01)
     LET l_oma.oma00 = '26'
     LET l_oma.oma18 = NULL
     SELECT ool21 INTO l_oma.oma18 FROM ool_file
      WHERE ool01 = g_oma.oma13
     IF g_aza.aza63 = 'Y' THEN
        SELECT ool211 INTO l_oma.oma181 FROM ool_file
         WHERE ool01 = g_oma.oma13
     END IF
     LET l_oma.oma21=NULL
     LET l_oma.oma211=0
     LET l_oma.oma213='N'
     LET l_oma.oma54x=0
     LET l_oma.oma56x=0
     LET l_oma.oma54t=g_oma.oma54
     LET l_oma.oma56t=g_oma.oma56 
     LET l_oma.oma55=0
     LET l_oma.oma57=0
     LET l_oma.oma60=l_oma.oma24
     LET l_oma.oma61=l_oma.oma56t-l_oma.oma57
     LET l_oma.omaconf='Y' LET l_oma.omavoid='N'
     LET l_oma.omauser=g_user
     LET l_oma.omadate=g_today
     LET l_oma.oma65 = '1'
     LET l_oma.oma66= g_oma.oma66
     LET l_oma.oma67 = NULL LET l_oma.oma16 = g_oma.oma01
     IF g_aaz.aaz90='Y' THEN
        IF cl_null(l_oma.oma15) THEN
           LET l_oma.oma15=g_grup
        END IF
        LET l_oma.oma930=s_costcenter(l_oma.oma15)
     END IF
     LET l_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
     LET l_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
     LET l_oma.omalegal = g_legal    #TQC-A70012houlia #No.FUN-A70118
     IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 = 0 END IF #FUN-AB0034
     IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f = 0 END IF #FUN-AB0034
     IF cl_null(l_oma.oma74) THEN LET l_oma.oma74 ='1' END IF  #No.FUN-AB0034
     INSERT INTO oma_file VALUES(l_oma.*)
     IF STATUS OR SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg('oma01',l_oma.oma01,'ins oma',SQLCA.SQLCODE,1)
        ELSE
           CALL cl_err3("ins","oma_file",l_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)
        END IF
        LET g_success = 'N'
        RETURN
     END IF
     LET l_omc.omc01 = l_oma.oma01
     LET l_omc.omc02 = 1
     LET l_omc.omc03 = l_oma.oma32
     LET l_omc.omc04 = l_oma.oma11
     LET l_omc.omc05 = l_oma.oma12
     LET l_omc.omc06 = l_oma.oma24
     LET l_omc.omc07 = l_oma.oma60
     LET l_omc.omc08 = l_oma.oma54t
     LET l_omc.omc09 = l_oma.oma56t
     LET l_omc.omc10 = 0
     LET l_omc.omc11 = 0
     LET l_omc.omc12 = l_oma.oma10
     LET l_omc.omc13 = l_omc.omc09 - l_omc.omc11
     LET l_omc.omc14 = 0
     LET l_omc.omc15 = 0
     #LET l_omc.omcplant = l_oma.omaplant    #FUN-960140 mark 090824
 
     IF cl_null(l_omc.omclegal) THEN LET l_omc.omclegal = g_legal END IF     #TQC-A70012 houlia
     INSERT INTO omc_file VALUES(l_omc.*)
     IF STATUS OR SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           LET g_showmsg=l_omc.omc01,"/",l_omc.omc02
           CALL s_errmsg('omc01,omc02',g_showmsg,"ins omc",SQLCA.sqlcode,1)
        ELSE
           CALL cl_err3("ins","omc_file",l_omc.omc01,"",SQLCA.sqlcode,"","ins omc",1)
        END IF
        LET g_success = 'N'
        RETURN
     END IF
     UPDATE oma_file SET oma19=l_oma.oma01 WHERE oma01=g_oma.oma01
     IF STATUS OR SQLCA.SQLCODE THEN
        IF g_bgerr THEN
           CALL s_errmsg('oma01',g_oma.oma01,'upd oma19',SQLCA.SQLCODE,1)
        ELSE
           CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd oma19",1)
        END IF
        LET g_success = 'N'
        RETURN
     END IF
  END IF
END FUNCTION
 
FUNCTION i010_y_chk()
   DEFINE l_occ     RECORD LIKE occ_file.*
   DEFINE l_cnt     LIKE type_file.num5
   DEFINE l_oot05t  LIKE oot_file.oot05t
   DEFINE l_oov04f  LIKE oov_file.oov04f
   DEFINE l_oov04   LIKE oov_file.oov04
   DEFINE l_omc08   LIKE omc_file.omc08
   DEFINE l_omc09   LIKE omc_file.omc09
   DEFINE l_npq07   LIKE npq_file.npq07
   DEFINE l_npq07_1 LIKE npq_file.npq07
   DEFINE l_npq07f  LIKE npq_file.npq07f
   DEFINE l_oob09   LIKE oob_file.oob09
   DEFINE l_status  LIKE type_file.chr1
   DEFINE l_oma54x  LIKE oma_file.oma54x
 
   IF g_ooy.ooydmy1 = 'Y' THEN  
      CALL s_chknpq(g_oma.oma01,'AR',1,'0',g_bookno1)
      IF g_aza.aza63='Y' AND g_success='Y' THEN
         CALL s_chknpq(g_oma.oma01,'AR',1,'1',g_bookno2)
      END IF
 
      IF g_aza.aza26='2' AND g_ooy.ooydmy2='Y' AND g_oma.oma00 MATCHES '2*' THEN  
         LET l_status='1'     
      ELSE
         LET l_status='2'    
      END IF
      IF g_oma.oma00 MATCHES '2*' THEN   
         SELECT SUM(npq07) INTO l_npq07 FROM npq_file
          WHERE npq01 = g_oma.oma01 AND npq06 = l_status  
           AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma18         
            AND npqtype = '0'  #FUN-670047
         IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
         IF l_npq07<0 THEN LET l_npq07 = (-1)*l_npq07  END IF  
         IF l_npq07 != g_oma.oma56t THEN   
            CALL s_errmsg("npq07",l_npq07,"","aap-278",1)
            LET g_success = 'N'
         END IF
         IF g_aza.aza63 = 'Y' THEN
            SELECT SUM(npq07) INTO l_npq07_1 FROM npq_file
            WHERE npq01 = g_oma.oma01 AND npq06 = l_status
             AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma181
              AND npqtype = '1'
            IF cl_null(l_npq07_1) THEN LET l_npq07_1=0 END IF
            IF l_npq07_1<0 THEN LET l_npq07_1 = (-1)*l_npq07_1  END IF
            IF l_npq07_1 != g_oma.oma56t THEN   #FUN-530061
               CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)
               LET g_success = 'N'
            END IF
         END IF
      ELSE
         IF g_oma.oma65 != '2' THEN
            SELECT SUM(npq07) INTO l_npq07 FROM npq_file
             WHERE npq01 = g_oma.oma01 AND npq06 = '1'                
              AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma18
               AND npqtype = '0' #FUN-670047
            IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
            IF l_cnt > 0 THEN
               IF l_npq07 != (g_oma.oma56t-l_oot05t) THEN 
                  CALL s_errmsg("npq07",l_npq07,"","aap-278",1)
                  LET g_success = 'N'
               END IF
            ELSE
               IF l_npq07 != g_oma.oma56t THEN
                  CALL s_errmsg("npq07",l_npq07,"","aap-278",1)
                  LET g_success = 'N'
               END IF
            END IF
            IF g_aza.aza63 = 'Y' THEN
               SELECT SUM(npq07) INTO l_npq07_1 FROM npq_file
                WHERE npq01 = g_oma.oma01 AND npq06 = '1' 
                 AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma181  
                  AND npqtype = '1'
               IF cl_null(l_npq07_1) THEN LET l_npq07_1=0 END IF
               IF l_cnt > 0 THEN
                  IF l_npq07_1 != (g_oma.oma56t-l_oot05t) THEN  
                     CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)
                     LET g_success = 'N'
                  END IF
               ELSE
                  IF l_npq07_1 != g_oma.oma56t THEN
                     CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)
                     LET g_success = 'N'
                  END IF
               END IF
            END IF
         END IF
      END IF
      IF g_success='Y' THEN
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM npp_file,oma_file
          WHERE oma01=g_oma.oma01   #FUN-530061
           AND npp01=oma01 AND nppsys='AR' AND npp011=1 AND npp00=2
            AND ( YEAR(oma02) != YEAR(npp02) OR
             (YEAR(oma02)  = YEAR(npp02) AND MONTH(oma02) != MONTH(npp02)))
         IF g_cnt >0 THEN
            LET g_showmsg=g_oma.oma01,"/",'AR',"/",1,"/",2     
            CALL s_errmsg('oma01,nppsys,npp011,npp00',g_showmsg,'','aap-279',1)  
            LET g_success = 'N'
         END IF
      END IF
      IF g_success='Y' THEN
         IF g_oma.oma213='N' THEN
            LET l_oma54x=g_oma.oma54*g_oma.oma211/100
            CALL cl_digcut(l_oma54x,t_azi04) RETURNING l_oma54x  
         ELSE
            LET l_oma54x=g_oma.oma54t*g_oma.oma211/(100+g_oma.oma211)
            CALL cl_digcut(l_oma54x,t_azi04) RETURNING l_oma54x 
         END IF
         IF l_oma54x != g_oma.oma54x THEN
            CALL s_errmsg("oma54x",l_oma54x,"","aap-757",0)
         END IF
      END IF
   END IF
 
   IF g_ooy.ooydmy2='Y' THEN
      SELECT COUNT(*) INTO l_cnt FROM npq_file
       WHERE npq01 = g_oma.oma01
         AND npq011 =  1
         AND npqsys = 'AR'
         AND npq00 = 2
         AND npqtype = '0'
         AND npq03 = g_oma.oma18
         AND npq06 = '1'
 
      IF l_cnt > 0 THEN
         LET l_npq07f = 0
         LET l_oob09 = 0
         SELECT SUM(oob09) INTO l_oob09 FROM oob_file, ooa_file
          WHERE oob01=g_oma.oma01 AND oob01=ooa01 AND ooaconf<>'X'
            AND oob03='1'  AND oob04='2'
            AND oob02 > 0
 
         SELECT npq07f INTO l_npq07f FROM npq_file
          WHERE npq01 = g_oma.oma01
            AND npq011 =  1
            AND npqsys = 'AR'
            AND npq00 = 2
            AND npqtype = '0'
            AND npq03 = g_oma.oma18
            AND npq06 = '1'
 
         IF l_npq07f <> (g_oma.oma54t - l_oob09) THEN
            CALL cl_err('','axr-111',0)
            LET g_success = 'N'
            RETURN
         END IF
      ELSE
         CALL cl_err('','aap-995',0)
         LET g_success = 'N'
         RETURN
      END IF
      IF g_aza.aza63 = 'Y' THEN
         SELECT COUNT(*) INTO l_cnt FROM npq_file
          WHERE npq01 = g_oma.oma01
            AND npq011 =  1
            AND npqsys = 'AR'
            AND npq00 = 2
            AND npqtype = '1'
            AND npq03 = g_oma.oma181
            AND npq06 = '1'
 
         IF l_cnt > 0 THEN
            LET l_npq07f = 0
            LET l_oob09 = 0
            SELECT SUM(oob09) INTO l_oob09 FROM oob_file, ooa_file
             WHERE oob01=g_oma.oma01 AND oob01=ooa01 AND ooaconf<>'X'
               AND oob03='1'  AND oob04='2'
               AND oob02 > 0
 
            SELECT npq07f INTO l_npq07f FROM npq_file
             WHERE npq01 = g_oma.oma01
               AND npq011 =  1
               AND npqsys = 'AR'
               AND npq00 = 2
               AND npqtype = '1'
               AND npq03 = g_oma.oma181
               AND npq06 = '1'
 
            IF l_npq07f <> (g_oma.oma54t - l_oob09) THEN
               CALL cl_err('','axr-112',0)
               LET g_success = 'N'
               RETURN
            END IF
         ELSE
            CALL cl_err('','aap-975',0)
            LET g_success = 'N'
           RETURN
         END IF
      END IF
   END IF
   SELECT * INTO g_oma.* FROM oma_file
    WHERE oma01 = g_oma.oma01
 
   SELECT SUM(omc08),SUM(omc09) INTO l_omc08,l_omc09 FROM omc_file
    WHERE omc01 =g_oma.oma01
   IF l_omc08 <>g_oma.oma54t OR l_omc09 <>g_oma.oma56t THEN
      CALL cl_err('','axr-025',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01 = g_oma.oma03
   IF l_occ.occacti = 'N' THEN
      CALL cl_err(l_occ.occ01,'9028',0)
      LET g_success = 'N'
      RETURN
   END IF
 
   IF g_aza.aza26 = '2' AND g_oma.oma00[1,1]='2' THEN
      IF g_ooy.ooydmy2='Y' THEN
         SELECT SUM(oov04),SUM(oov04f) INTO l_oov04,l_oov04f
           FROM oov_file
          WHERE oov01=g_oma.oma01
         IF cl_null(l_oov04) THEN LET l_oov04 = 0 END IF
         IF cl_null(l_oov04f) THEN LET l_oov04f = 0 END IF
         IF l_oov04<>g_oma.oma56t OR l_oov04f <> g_oma.oma54t THEN
            CALL cl_err('','aap-912',0)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION
#FUN-960141

#FUN-9C0109--add--str--
FUNCTION gen_17_omab(p_no)   
DEFINE p_no       LIKE lps_file.lps01
DEFINE l_occ      RECORD LIKE occ_file.*
DEFINE l_t1       LIKE oma_file.oma01
DEFINE l_ool      RECORD LIKE ool_file.*
DEFINE l_cardno   LIKE lpt_file.lpt02    #开始卡号
DEFINE l_cardno1  LIKE lpt_file.lpt02    #结束卡号
DEFINE l_lpt03    LIKE lpt_file.lpt03    #卡种
DEFINE l_lph33    LIKE lph_file.lph33    #固定编号位数
DEFINE l_lpt06    LIKE lpt_file.lpt06    #卡费
DEFINE l_length   LIKE type_file.num20
DEFINE l_omc      RECORD LIKE omc_file.*

   INITIALIZE l_omc.* TO NULL
   INITIALIZE g_oma.* TO NULL
   
   LET g_oma.oma00='17'
   CALL s_auto_assign_no("AXR",g_oow.oow16,g_today,g_oma.oma00,"oma_file","oma01","","","")
      RETURNING li_result,g_oma.oma01
   IF (NOT li_result) THEN
      IF g_bgerr THEN
         CALL s_errmsg('oow09',p_no,'','abm-621',1)
      ELSE
         CALL cl_err3("sel","oow_ile","","","abm-621","","",1)                                     
      END IF
      LET g_success = 'N'
   END IF
   CALL s_get_doc_no(g_oma.oma01) RETURNING l_t1
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=l_t1
   SELECT * INTO g_ooz.* FROM ooz_file WHERE ooz00='0'                                                                              
   SELECT * INTO g_nmz.* FROM nmz_file WHERE nmz00='0' 
   LET g_oma.oma02=g_today
   CALL s_get_bookno(year(g_oma.oma02))                                                                                   
      RETURNING g_flag1,g_bookno1,g_bookno2
   IF g_flag1='1' THEN #抓不到帳別                                                                                        
      IF g_bgerr THEN
         CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
      ELSE
         CALL cl_err3("sel","oma_file",g_oma.oma02,"","aoo-081","","",1)                                       
      END IF
      LET g_success = 'N'
   END IF 
   LET g_oma.oma03='MISCCARD'
   LET g_oma.oma032='MISC'
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oma.oma03
   LET g_oma.oma68 = l_occ.occ07
   SELECT occ02 INTO g_oma.oma69 FROM occ_file WHERE occ01 = g_oma.oma68
   LET g_oma.oma04 = g_oma.oma03 LET g_oma.oma05 = l_occ.occ08
   LET g_oma.oma21 = l_occ.occ41 LET g_oma.oma23 = l_occ.occ42
   IF cl_null(g_oma.oma23) THEN LET g_oma.oma23=g_aza.aza17 END IF
   LET g_oma.oma40 = l_occ.occ37 LET g_oma.oma25 = l_occ.occ43
   LET g_oma.oma32 = l_occ.occ45 LET g_oma.oma042= l_occ.occ11
   LET g_oma.oma043= l_occ.occ18 LET g_oma.oma044= l_occ.occ231
   LET g_oma.oma51f = 0 LET g_oma.oma51 = 0
   LET g_plant2 = g_plant                      
   LET g_dbs2 = s_dbstring(g_dbs CLIPPED)      


   CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant2) RETURNING g_oma.oma11,g_oma.oma12 
   SELECT gec04,gec05,gec07 INTO g_oma.oma211,g_oma.oma212,g_oma.oma213                                                          
      FROM gec_file WHERE gec01=g_oma.oma21 AND gec011='2'                                                                      
   LET g_oma.oma08  = '1'                                                                                                        
   IF cl_null(g_oma.oma211) THEN LET g_oma.oma211=0 END IF                                                                       
   IF g_oma.oma23=g_aza.aza17 THEN                                                                                               
      LET g_oma.oma24=1                                                                                                          
      LET g_oma.oma58=1                                                                                                          
   ELSE                                                                                                                          
      CALL s_curr3(g_oma.oma23,g_oma.oma02,g_ooz.ooz17) RETURNING g_oma.oma24                                                    
      CALL s_curr3(g_oma.oma23,g_oma.oma09,g_ooz.ooz17) RETURNING g_oma.oma58                                                    
   END IF                                                                                                                        
   SELECT occ67 INTO g_oma.oma13 FROM occ_file                                                                                   
      WHERE occ01 = g_oma.oma03                                                                                                  
   IF cl_null(g_oma.oma13) THEN LET g_oma.oma13 = g_ooz.ooz08 END IF                             
   LET g_oma.oma14 = g_user
   LET g_oma.oma15 = g_grup
   SELECT * INTO l_ool.* FROM ool_file WHERE ool01=g_oma.oma13
   LET g_oma.oma18 = l_ool.ool11
   IF g_aza.aza63 = 'Y' THEN LET g_oma.oma181 = l_ool.ool111 END IF
   LET g_oma.oma66 = g_lps.lpsplant      
   LET g_oma.oma54t=g_lps.lps16   #购卡金额合计
   IF cl_null(g_oma.oma54t) THEN LET g_oma.oma54t=0 END IF
   CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t
   LET g_oma.oma70 = '1'
   LET g_oma.oma50 = 0
   LET g_oma.oma50t= 0
   LET g_oma.oma52 = 0
   LET g_oma.oma53 = 0
   LET g_oma.oma56t=g_oma.oma54t*g_oma.oma24
   IF cl_null(g_oma.oma56t) THEN LET g_oma.oma56t=0 END IF
   CALL cl_digcut(g_oma.oma50,t_azi04) RETURNING g_oma.oma50
   CALL cl_digcut(g_oma.oma50t,t_azi04) RETURNING g_oma.oma50t
   CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52
   CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53
   CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t
   IF g_oma.oma213 = 'N' THEN
      LET g_oma.oma54 = g_oma.oma54t
      LET g_oma.oma56 = g_oma.oma56t
   ELSE
      LET g_oma.oma54 = g_oma.oma54t/(1+g_oma.oma211/100)
      LET g_oma.oma56 = g_oma.oma56t/(1+g_oma.oma211/100)
   END IF
   IF cl_null(g_oma.oma54) THEN LET g_oma.oma54 = 0 END IF
   IF cl_null(g_oma.oma56) THEN LET g_oma.oma56 = 0 END IF
   CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54
   CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56
   LET g_oma.oma54x = g_oma.oma54t - g_oma.oma54
   LET g_oma.oma56x = g_oma.oma56t - g_oma.oma56
   LET g_oma.oma55 = 0
   LET g_oma.oma57 = 0
   LET g_oma.oma65 = '1'
   LET g_oma.omaconf = 'Y'
   LET g_oma.omavoid = 'N'
   LET g_oma.omauser = g_user
   LET g_oma.omagrup = g_grup
   LET g_oma.oma64 = '0'
   CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x
   CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x
   CALL cl_digcut(g_oma.oma55,t_azi04)  RETURNING g_oma.oma55
   CALL cl_digcut(g_oma.oma57,g_azi04)  RETURNING g_oma.oma57
   LET g_oma.oma16 = p_no
   LET g_oma.omaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_oma.omaorig = g_grup      #No.FUN-980030 10/01/04
   LET g_oma.omalegal = g_legal     #houlia #No.FUN-A70118
   IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 = 0 END IF #FUN-AB0034
   IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f = 0 END IF #FUN-AB0034
   IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF  #No.FUN-AB0034
   INSERT INTO oma_file VALUES(g_oma.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      IF g_bgerr THEN  
         CALL s_errmsg('oma01',g_oma.oma01,'ins oma err',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","oma_file",g_oma.oma01,g_oma.oma02,SQLCA.sqlcode,"","ins oma",1)                                        
      END IF
      LET g_success = 'N'
   END IF
   
   ###產生omb_file
   LET g_sql = "SELECT lpt02,lpt021,lpt03,lpt06 FROM lpt_file WHERE lpt01 = '",p_no,"'"
   PREPARE l_pb4 FROM g_sql
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_oma.oma01,'pre err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("pre","",p_no,"",SQLCA.sqlcode,"","pre",1)                                        
      END IF
      LET g_success = 'N'
   END IF
   DECLARE l_cs4 SCROLL CURSOR FOR l_pb4
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_oma.oma01,'declare err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("dec","",p_no,"",SQLCA.sqlcode,"","dec",1)                                        
      END IF
      LET g_success = 'N'
   END IF
   FOREACH l_cs4 INTO l_cardno,l_cardno1,l_lpt03,l_lpt06
   IF SQLCA.sqlcode THEN
      IF g_bgerr THEN
         CALL s_errmsg('oma01',g_oma.oma01,'foreach err',SQLCA.sqlcode,1) 
      ELSE
         CALL cl_err3("for","",p_no,"",SQLCA.sqlcode,"","for",1)                                        
      END IF
      LET g_success = 'N'
   END IF
      LET g_omb.omb06 = l_cardno
      LET g_omb.omb00 = g_oma.oma00
      LET g_omb.omb01 = g_oma.oma01
      SELECT MAX(omb03)+1 INTO g_omb.omb03 FROM omb_file WHERE omb01=g_oma.oma01
      IF cl_null(g_omb.omb03) THEN LET g_omb.omb03=1 END IF
      LET g_omb.omb04 = 'MISCCARD'
      LET l_length = LENGTH(l_cardno)
      SELECT lph33 INTO l_lph33 FROM lph_file
       WHERE lph01 = l_lpt03
      LET g_omb.omb12 = l_cardno1[l_lph33+1,l_length] - l_cardno[l_lph33+1,l_length]+1
      LET g_omb.omb13 = l_lpt06
      IF cl_null(g_omb.omb13) THEN LET g_omb.omb13=0 END IF
      CALL cl_digcut(g_omb.omb13,t_azi03) RETURNING g_omb.omb13
      LET g_omb.omb39 = 'N'
      LET g_omb.omb38 = '07'
      LET g_omb.omb34 = 0
      LET g_omb.omb35 = 0
      LET g_omb.omb36 = 0
      LET g_omb.omb37 = 0
      CALL cl_digcut(g_omb.omb34,t_azi04) RETURNING g_omb.omb34
      CALL cl_digcut(g_omb.omb35,g_azi04) RETURNING g_omb.omb35
      CALL cl_digcut(g_omb.omb37,t_azi04) RETURNING g_omb.omb37
      IF g_oma.oma213 = 'N' THEN
         LET g_omb.omb14 = g_omb.omb12 * g_omb.omb13
         CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14
         LET g_omb.omb14t=g_omb.omb14*(1+g_oma.oma211/100)
         IF cl_null(g_omb.omb14t) THEN LET g_omb.omb14t=0 END IF
         CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t
      ELSE
         LET g_omb.omb14t=g_omb.omb12*g_omb.omb13
         CALL cl_digcut(g_omb.omb14t,t_azi04) RETURNING g_omb.omb14t
         LET g_omb.omb14 = g_omb.omb14t / (1 + g_oma.oma211 / 100)
         IF cl_null(g_omb.omb14) THEN LET g_omb.omb14=0 END IF
         CALL cl_digcut(g_omb.omb14,t_azi04) RETURNING g_omb.omb14
      END IF
      LET g_omb.omb15 = g_omb.omb13 * g_oma.oma24
      LET g_omb.omb16 = g_omb.omb14 * g_oma.oma24
      LET g_omb.omb16t = g_omb.omb14t * g_oma.oma24
      LET g_omb.omb17 = g_omb.omb13 * g_oma.oma58
      LET g_omb.omb18 = g_omb.omb14 * g_oma.oma58
      LET g_omb.omb18t = g_omb.omb14t * g_oma.oma58
      IF cl_null(g_omb.omb15) THEN LET g_omb.omb15=0 END IF
      IF cl_null(g_omb.omb16) THEN LET g_omb.omb16=0 END IF
      IF cl_null(g_omb.omb16t) THEN LET g_omb.omb16t=0 END IF
      CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15
      CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16
      CALL cl_digcut(g_omb.omb16t,g_azi04) RETURNING g_omb.omb16t
      CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17
      CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18
      CALL cl_digcut(g_omb.omb18t,g_azi04) RETURNING g_omb.omb18t
      LET g_omb.omblegal = g_legal        #TQC-A70012houlia
      LET g_omb.omb48 = 0   #FUN-D10101 add
      INSERT INTO omb_file VALUES(g_omb.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('omb01',g_oma.oma01,'ins omb err',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","omb_file",g_oma.oma01,g_oma.oma02,SQLCA.sqlcode,"","ins omb",1)                                        
         END IF
         LET g_success = 'N'
      END IF
   END FOREACH
###產生多賬期資料 產生一筆即可
   CALL s_ar_oox03(g_oma.oma01) RETURNING g_net
   LET l_omc.omc01 = g_oma.oma01
   LET l_omc.omc02 = 1
   LET l_omc.omc03 = g_oma.oma32
   LET l_omc.omc04 = g_oma.oma11
   LET l_omc.omc05 = g_oma.oma12
   LET l_omc.omc06 = g_oma.oma24
   LET l_omc.omc07 = g_oma.oma60
   LET l_omc.omc08 = g_oma.oma54t
   LET l_omc.omc09 = g_oma.oma56t
   LET l_omc.omc10 = 0
   LET l_omc.omc11 = 0
   LET l_omc.omc12 = g_oma.oma10
   LET l_omc.omc13 = l_omc.omc09-l_omc.omc11+g_net
   LET l_omc.omc14 = 0
   LET l_omc.omc15 = 0
   CALL cl_digcut(l_omc.omc08,t_azi04) RETURNING l_omc.omc08
   CALL cl_digcut(l_omc.omc09,g_azi04) RETURNING l_omc.omc09
   CALL cl_digcut(l_omc.omc13,g_azi04) RETURNING l_omc.omc13
   CALL cl_digcut(l_omc.omc14,t_azi04) RETURNING l_omc.omc14
   CALL cl_digcut(l_omc.omc15,g_azi04) RETURNING l_omc.omc15
   IF cl_null(l_omc.omclegal) THEN LET l_omc.omclegal= g_legal END IF    #TQC-A70012 houlia
   INSERT INTO omc_file VALUES(l_omc.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('omc01',g_oma.oma01,'ins omc err',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","omc_file",g_oma.oma01,g_oma.oma02,SQLCA.sqlcode,"","ins omc",1)
      END IF
      LET g_success = 'N'
   END IF
END FUNCTION 
#FUN-9C0109--add--end

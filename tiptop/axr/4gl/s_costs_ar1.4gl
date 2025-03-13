# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: s_costs_ar1.4gl
# Descriptions...: 押金轉應收                                          
# Date & Author..: #TQC-AC0127     2010/12/21 By wuxj                 
# Modify.........: No.TQC-B10270 11/01/27 By yinhy 通財務拋轉時產生的票據資料nmh41改為'N'，nmh21默認值=axri060支票對應銀行
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: NO.FUN-B40011 11/04/19 By guoch     nmh_file add nmh42
# Modify.........: No.FUN-B40056 11/05/12 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file  
# Modify.........: No.FUN-BA0109 11/11/22 By yinhy 更改omb33取值
# Modify.........: No.FUN-C30038 12/03/27 By JinJJ INSERT INTO nmh_file赋值修改.nmh06 = rxy11
# Modify.........: No.FUN-D10101 13/01/22 By lujh axrt300單身新增已開票數量欄位，賦默認值0
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE       g_oma         RECORD LIKE oma_file.*,
             g_omb         RECORD LIKE omb_file.*,
             g_npq         RECORD LIKE npq_file.*,
             g_ooa         RECORD LIKE ooa_file.*,
             g_ool         RECORD LIKE ool_file.*,
             g_oow         RECORD LIKE oow_file.*,
             g_oob         RECORD LIKE oob_file.*,
             g_npp         RECORD LIKE npp_file.*,
             g_nmh         RECORD LIKE nmh_file.*,
             g_nms         RECORD LIKE nms_file.*,
             g_rxr         RECORD LIKE rxr_file.*,
             li_result     LIKE type_file.num5,
             g_cnt         LIKE type_file.num10,
             g_flag        LIKE type_file.chr1,
             g_bookno1     LIKE type_file.chr20,
             g_bookno2     LIKE type_file.chr20,
             g_bookno3     LIKE type_file.chr20,
             g_net         LIKE type_file.num5,
             g_aag05       LIKE aag_file.aag05,
             g_aag23       LIKE aag_file.aag23,
             l_ac          LIKE type_file.num5,
             g_sql1        LIKE type_file.chr1000,
             g_omc         RECORD LIKE omc_file.*,
             g_dbs2        LIKE type_file.chr30
DEFINE       g_plant2      LIKE type_file.chr10     
DEFINE       g_sql         STRING                     #FUN-BA0109
DEFINE       g_aag44       LIKE aag_file.aag44   #FUN-D40118 add
 
 
 
FUNCTION s_costs_ar1(p_no)  #p_no
  DEFINE  p_no      LIKE    rxr_file.rxr01,
          l_amt1    LIKE oma_file.oma55,
          l_amt2    LIKE oma_file.oma55,
          l_flag    VARCHAR(1),
          l_t1      LIKE type_file.chr20,
          l_ooydmy1 LIKE ooy_file.ooydmy1,
          l_oob     RECORD LIKE oob_file.*,
          l_n       LIKE type_file.num5
 
   IF cl_null(p_no) THEN RETURN ' ' END IF
 
   INITIALIZE g_rxr.*   TO NULL
 
   SELECT * INTO g_rxr.* FROM rxr_file WHERE rxr01 = p_no
   #CALL s_showmsg_init()
 
   CALL s_ar_gen_oma()
 
   IF g_success = 'Y' THEN 
      CALL s_get_bookno(YEAR(g_oma.oma02)) RETURNING l_flag,g_bookno1,g_bookno2
      IF l_flag =  '1' THEN
         IF g_bgerr THEN
            CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
         ELSE
            CALL cl_err(g_oma.oma02,'aoo-081',1)
         END IF 
         LET g_success = 'N'
      END IF
      LET g_bookno3 = g_bookno1
   END IF
 
   IF g_success = 'Y' THEN
      CALL s_ar_gen_omb()
   END IF
 
   IF g_success = 'Y' THEN
      CALL s_ar_gen_omc()
   END IF
 
   IF g_flag='1' AND g_success = 'Y' THEN
      CALL s_ins_w('13',g_rxr.rxr01,g_oma.oma01,1,g_rxr.rxrplant) RETURNING g_success
#     CALL s_ar_gen_oob()
#     CALL s_ar_gen_ooa()
      IF g_success = 'Y' THEN
         SELECT COUNT(*) INTO l_n FROM ooa_file WHERE ooa01 = g_oma.oma01
         IF l_n > 0 THEN  
            SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_oma.oma01
            UPDATE oma_file SET oma55 = g_ooa.ooa31c,oma57 = g_ooa.ooa32c,omaconf = 'Y'
             WHERE oma01 = g_oma.oma01
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("upd","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd oma",1)
               LET g_success = 'N'
            END IF 
           #TQC-AC0127 Begin---  By shi
            IF g_success = 'Y' THEN
               LET g_ooa.ooaconf='Y'
               LET g_ooa.ooa34 = '1'
               CALL cl_flow_notify(g_ooa.ooa01,'Y')
            ELSE 
               LET g_ooa.ooaconf='N'
               LET g_ooa.ooa34 = '0'
            END IF
            UPDATE ooa_file SET ooaconf=g_ooa.ooaconf,ooa34=g_ooa.ooa34
             WHERE ooa01=g_oma.oma01
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err3("upd","ooa_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd ooa",1)
               LET g_success = 'N' 
            END IF
           #TQC-AC0127 End-----
         END IF 
      END IF  
   END IF
 
   CALL s_get_doc_no(g_oma.oma01) RETURNING l_t1
 
   SELECT ooydmy1 INTO l_ooydmy1 FROM ooy_file WHERE ooyslip=l_t1
   CALL s_get_doc_no(g_oma.oma01) RETURNING l_t1
   SELECT * INTO g_ooy.* FROM ooy_file WHERE ooyslip=l_t1
 
   IF g_ooy.ooydmy1='Y' AND g_success = 'Y' THEN
      IF g_oma.oma65 != '2' THEN
         CALL s_t300_gl(g_oma.oma01,'0') 
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_t300_gl(g_oma.oma01,'1') 
         END IF
         CALL s_ar_y_chk()
      ELSE
         CALL s_t300_rgl(g_oma.oma01,'0')  
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
            CALL s_t300_rgl(g_oma.oma01,'1') 
         END IF
         CALL s_ar_y_chk()
      END IF
   END IF
 
   IF g_oma.oma00 = '15' THEN
      CALL s_yz_hu1('+')
   END IF
 
   LET g_sql1 = "SELECT * FROM oob_file",
                " WHERE oob01 ='", g_oma.oma01,"' AND oob04 = '3' ",
                "   AND oob03 = '1' AND oob06 IS NOT NULL AND oob09 > 0"
   PREPARE s_costs_pb4 FROM g_sql1
   DECLARE s_costs_cs4 SCROLL CURSOR FOR s_costs_pb4
   FOREACH s_costs_cs4 INTO l_oob.*
      IF SQLCA.sqlcode THEN
          LET g_success = 'N'
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      UPDATE oma_file 
         SET oma55 = oma55 + l_oob.oob09,
             oma57 = oma57 + l_oob.oob10
       WHERE oma01 = l_oob.oob06
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("UPDATE","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","upd oma",1)
         LET g_success = 'N'
      END IF
 
      SELECT  oma54t - oma55, oma56t - oma57 
        INTO l_amt1,l_amt2 FROM oma_file
       WHERE oma01 = l_oob.oob06
      IF l_amt1<0 OR l_amt2 <0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','','alm-023',1)
         ELSE 
            CALL cl_err('','alm-023',1)
         END IF 
         LET g_success = 'N'
      END IF
   END FOREACH
   RETURN  g_oma.oma01
END FUNCTION
 
 
FUNCTION s_ar_gen_oma()
DEFINE  l_sum        LIKE type_file.num5,
        l_occ RECORD LIKE occ_file.*,
        l_ool RECORD LIKE ool_file.*,
        l_slip    LIKE oow_file.oow02

   INITIALIZE g_oma.* TO NULL
 
   SELECT SUM(COALESCE(rxx04,0)) + SUM(COALESCE(rxx05,0)) 
     INTO l_sum FROM rxx_file
    WHERE rxx01=g_rxr.rxr01 and rxxplant=g_rxr.rxrplant and rxx00='05'
 
   IF cl_null(l_sum) THEN LET l_sum=0 END IF
 
   IF l_sum > 0 THEN
      LET g_flag = '1'
      LET g_oma.oma65 = '2'
   ELSE
      LET g_flag = '0'
      LET g_oma.oma65 = '1'
   END IF
 
   SELECT * INTO g_oow.* FROM oow_file 
    WHERE oow00 = '0'
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','err','alm-998',1)
      ELSE 
         CALL cl_err('err','alm-998',1)
      END IF 
      LET g_success = 'N'
      RETURN
   END IF
   
   CASE g_rxr.rxr00 
      WHEN '1'
         LET g_oma.oma00 = '15'
         IF cl_null(g_oow.oow02) THEN                                                                                                
            IF g_bgerr THEN                                                                                                          
               CALL s_errmsg('oow02',g_oow.oow02,'','axr-149',1)                                                                     
            ELSE                                                                                                                     
               CALL cl_err('oow02','axr-149',1)                                                                                      
            END IF                                                                                                                   
            LET g_success = 'N' 
         ELSE
            LET l_slip=g_oow.oow02
         END IF 
      WHEN '2'
         LET g_oma.oma00 = '26'
         IF cl_null(g_oow.oow03) THEN                                                                                                
            IF g_bgerr THEN                                                                                                          
               CALL s_errmsg('oow03',g_oow.oow03,'','axr-149',1)                                                                     
            ELSE                                                                                                                     
               CALL cl_err('oow03','axr-149',1)                                                                                      
            END IF                                                                                                                   
            LET g_success = 'N' 
         ELSE
            LET l_slip=g_oow.oow03
         END IF 
   END CASE
 
      #####自動編號 
      CALL s_auto_assign_no("AXR",l_slip,g_today,g_oma.oma00,"oma_file","oma01","","","")
      RETURNING li_result,g_oma.oma01
      IF (NOT li_result) THEN
         LET g_success = 'N'
         RETURN
      END IF
 
      LET g_oma.oma02 = g_today
      LET g_oma.oma03 = 'MISC'
      LET g_oma.oma032 = g_rxr.rxr06
      LET g_oma.oma66 = g_rxr.rxrplant
      LET g_oma.oma54t = g_rxr.rxr11
      LET g_oma.oma56t = g_rxr.rxr11
      LET g_oma.oma32 = ''
      LET g_oma.oma16 = g_rxr.rxr01
      SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_oma.oma03
      LET g_oma.oma68 = l_occ.occ07
 
      IF g_oma.oma03 = 'MISC' THEN
         LET g_oma.oma69 = g_oma.oma032  
      ELSE
         SELECT occ02 INTO g_oma.oma69 FROM occ_file WHERE occ01 = g_oma.oma68
      END IF
 
      LET g_oma.oma14 = g_user
 
      SELECT gem01 INTO g_oma.oma15 FROM gen_file,gem_file
       WHERE gen01 = g_oma.oma14
         AND gen03 = gem01
 
      LET g_oma.oma04 = g_oma.oma03 
      LET g_oma.oma05 = l_occ.occ08
      LET g_oma.oma21 =''
      LET g_oma.oma211 = 0
      LET g_oma.oma213 =' '
      LET g_oma.oma23 = l_occ.occ42
      IF cl_null(g_oma.oma23) THEN LET g_oma.oma23=g_aza.aza17 END IF
      LET g_oma.oma40 = l_occ.occ37
      LET g_oma.oma25 = l_occ.occ43
      LET g_oma.oma32 = l_occ.occ45 
      LET g_oma.oma042= l_occ.occ11
      LET g_oma.oma043= l_occ.occ18 
      LET g_oma.oma044= l_occ.occ231
      LET g_oma.oma51f = 0 
      LET g_oma.oma51 = 0  
 
      LET g_plant2 = g_plant
      LET g_dbs2 = s_dbstring(g_dbs CLIPPED)     
 
      CALL s_rdatem(g_oma.oma03,g_oma.oma32,g_oma.oma02,g_oma.oma09,g_oma.oma02,g_plant2)
           RETURNING g_oma.oma11,g_oma.oma12
 
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
 
      IF cl_null(g_oma.oma13) THEN
         LET g_oma.oma13 = g_ooz.ooz08
      END IF
 
      LET g_oma.oma70 = '1'
      LET g_oma.oma50 = 0 
      LET g_oma.oma50t = 0
      LET g_oma.oma52 = 0
      LET g_oma.oma53 = 0
      CALL cl_digcut(g_oma.oma50,t_azi04) RETURNING g_oma.oma50
      CALL cl_digcut(g_oma.oma50t,t_azi04) RETURNING g_oma.oma50t
      CALL cl_digcut(g_oma.oma52,t_azi04) RETURNING g_oma.oma52
      CALL cl_digcut(g_oma.oma53,g_azi04) RETURNING g_oma.oma53
      IF g_flag ! = '1' THEN    
         LET l_sum = g_rxr.rxr11
      END IF
 
      IF cl_null(g_rxr.rxr11) THEN 
         LET g_rxr.rxr11 =0
      END IF
 
      LET g_oma.oma54 = g_rxr.rxr11
      LET g_oma.oma56 = g_rxr.rxr11*g_oma.oma24
      CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56
      LET g_oma.oma54t=g_rxr.rxr11 
      LET g_oma.oma56t=g_rxr.rxr11*g_oma.oma24
      LET g_oma.oma54x=0                                    
      LET g_oma.oma56x=0                                        
      CALL cl_digcut(g_oma.oma54x,t_azi04) RETURNING g_oma.oma54x
      CALL cl_digcut(g_oma.oma54,t_azi04) RETURNING g_oma.oma54
      CALL cl_digcut(g_oma.oma56,g_azi04) RETURNING g_oma.oma56
      CALL cl_digcut(g_oma.oma54t,t_azi04) RETURNING g_oma.oma54t
      CALL cl_digcut(g_oma.oma56t,g_azi04) RETURNING g_oma.oma56t
      CALL cl_digcut(g_oma.oma56x,g_azi04) RETURNING g_oma.oma56x

      SELECT * INTO l_ool.* FROM ool_file WHERE ool01=g_oma.oma13
 
      IF g_oma.oma00='15' THEN
         LET g_oma.oma18 = l_ool.ool11
         LET g_oma.oma181 = l_ool.ool111
      END IF
 
      LET g_oma.oma55 = 0 
      LET g_oma.oma57 = 0
      CALL cl_digcut(g_oma.oma55,t_azi04) RETURNING g_oma.oma55
      LET g_oma.omaconf = 'Y' 
      LET g_oma.omavoid = 'N'
      LET g_oma.omauser = g_user 
      LET g_oma.omaoriu = g_user
      LET g_oma.omaorig = g_grup
      LET g_oma.omagrup = g_grup 
      LET g_oma.oma64 = '0'
      LET g_oma.omalegal = g_legal 
      IF cl_null(g_oma.oma73) THEN LET g_oma.oma73 =0 END IF
      IF cl_null(g_oma.oma73f) THEN LET g_oma.oma73f =0 END IF
      IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF

      INSERT INTO oma_file VALUES(g_oma.*)
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('oma01',g_oma.oma01,'ins oma_file',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","oma_file",g_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)
         END IF 
         LET g_success = 'N'
      END IF
END FUNCTION
 
FUNCTION s_ar_gen_omb()
DEFINE  l_azf20   LIKE azf_file.azf20  #FUN-BA0109
DEFINE  l_azf201  LIKE azf_file.azf201 #FUN-BA0109
 
       INITIALIZE g_omb.* TO NULL
 
       LET g_omb.omb00 = g_oma.oma00
       LET g_omb.omb01 = g_oma.oma01
       LET g_omb.omb03 = 1
       LET g_omb.omb04 = 'MISC'
       LET g_omb.omb12 = 1
 
       IF cl_null(g_rxr.rxr11) THEN
          LET g_rxr.rxr11 = 0
       END IF
       LET g_omb.omb13 = g_rxr.rxr11 
 
       CALL cl_digcut(g_omb.omb13,t_azi03) RETURNING g_omb.omb13
 
 
       LET g_omb.omb14 = g_rxr.rxr11 
       LET g_omb.omb14t = g_rxr.rxr11
 
       LET g_omb.omb15 = g_omb.omb13 * g_oma.oma24
       CALL cl_digcut(g_omb.omb15,g_azi03) RETURNING g_omb.omb15
 
       LET g_omb.omb16 = g_omb.omb14 * g_oma.oma24
       CALL cl_digcut(g_omb.omb16,g_azi04) RETURNING g_omb.omb16
 
       LET g_omb.omb16t= g_omb.omb14t*g_oma.oma24
       CALL cl_digcut(g_omb.omb16t,g_azi04) RETURNING g_omb.omb16t
 
       LET g_omb.omb17 = g_omb.omb13*g_oma.oma58
       CALL cl_digcut(g_omb.omb17,g_azi03) RETURNING g_omb.omb17
 
       LET g_omb.omb18 = g_omb.omb14*g_oma.oma58
       CALL cl_digcut(g_omb.omb18,g_azi04) RETURNING g_omb.omb18
 
       LET g_omb.omb18t= g_omb.omb14t*g_oma.oma58
       CALL cl_digcut(g_omb.omb18t,g_azi04) RETURNING g_omb.omb18t
 
       LET g_omb.omb31 = g_rxr.rxr01
 
       LET  g_omb.omb34 = 0
       CALL cl_digcut(g_omb.omb34,g_azi04) RETURNING g_omb.omb34
 
       LET g_omb.omb35 = 0
       CALL cl_digcut(g_omb.omb35,g_azi04) RETURNING g_omb.omb35
 
       LET g_omb.omb36 = 0
       LET g_omb.omb37 = 0
       CALL cl_digcut(g_omb.omb37,g_azi04) RETURNING g_omb.omb37
 
       LET g_omb.omb38 = '06'
       LET g_omb.omb39 = 'N'
       LET g_omb.omblegal = g_legal     
       #No.FUN-BA0109  --Begin 
       LET g_omb.omb40 = g_rxr.rxr14  #FUN-BA0109
       IF NOT cl_null(g_omb.omb40) THEN
          LET g_sql = "SELECT azf20,azf201 ",
                     "  FROM ",cl_get_target_table(g_plant_new,'azf_file'),
                     " WHERE azf01='",g_omb.omb40,"' AND azf02='2' AND azfacti='Y'"
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql
	     CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql
         PREPARE sel_azf_pre11 FROM g_sql
         EXECUTE sel_azf_pre11 INTO l_azf20,l_azf201
         IF NOT cl_null(l_azf20) THEN LET g_omb.omb33=l_azf20 END IF
         IF g_aza.aza63='Y' AND cl_null(g_omb.omb331) THEN
            IF NOT cl_null(l_azf201) THEN LET g_omb.omb331=l_azf201 END IF
         END IF
       END IF
       #No.FUN-BA0109  --End
       LET g_omb.omb48 = 0   #FUN-D10101 add
       INSERT INTO omb_file VALUES(g_omb.*)
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         IF g_bgerr THEN
            CALL s_errmsg('omb01',g_omb.omb01,'ins omb_file',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("ins","omb_file",g_omb.omb01,g_omb.omb03,SQLCA.sqlcode,"","ins omb",1)
         END IF 
         LET g_success = 'N'
       END IF
END FUNCTION
 
FUNCTION s_ar_gen_omc()
   CALL s_ar_oox03(g_oma.oma01) RETURNING g_net
 
   LET g_omc.omc01 = g_oma.oma01
   LET g_omc.omc02 = 1
   LET g_omc.omc03 = g_oma.oma32
   LET g_omc.omc04 = g_oma.oma11
   LET g_omc.omc05 = g_oma.oma12
   LET g_omc.omc06 = g_oma.oma24
   LET g_omc.omc07 = g_oma.oma60
   LET g_omc.omc08 = g_oma.oma54t
   CALL cl_digcut(g_omc.omc08,t_azi04) RETURNING g_omc.omc08
   LET g_omc.omc09 = g_oma.oma56t
   CALL cl_digcut(g_omc.omc09,g_azi04) RETURNING g_omc.omc09
   LET g_omc.omc10 = 0
   CALL cl_digcut(g_omc.omc10,t_azi04) RETURNING g_omc.omc10
   LET g_omc.omc11 = 0
   CALL cl_digcut(g_omc.omc11,g_azi04) RETURNING g_omc.omc11
   LET g_omc.omc12 = g_oma.oma10
   LET g_omc.omc13 = g_omc.omc09-g_omc.omc11+g_net
   CALL cl_digcut(g_omc.omc13,g_azi04) RETURNING g_omc.omc13
   LET g_omc.omc14 = 0
   CALL cl_digcut(g_omc.omc14,t_azi04) RETURNING g_omc.omc14
   LET g_omc.omc15 = 0
   CALL cl_digcut(g_omc.omc15,g_azi04) RETURNING g_omc.omc15

   LET g_omc.omclegal = g_legal   
   INSERT INTO omc_file VALUES(g_omc.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('omc01',g_omc.omc01,'ins omc_file',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("ins","omc_file",g_omc.omc01,g_omc.omc02,SQLCA.sqlcode,"","ins omc",1)
      END IF 
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION s_ar_gen_oob()
DEFINE l_ooe02      LIKE ooe_file.ooe02,
       l_amt        LIKE oma_file.oma55,
       l_amt1       LIKE oma_file.oma55,
       l_wc         LIKE oma_file.oma55,
       l_oma01      LIKE oma_file.oma01,
       l_dept       LIKE type_file.chr10,
       l_rxx RECORD LIKE rxx_file.*,
       l_rxy RECORD LIKE rxy_file.*,
       l_oob RECORD LIKE oob_file.*,
       l_ooa RECORD LIKE ooa_file.*,
       l_rxy05      LIKE rxy_file.rxy05,
       l_rxy12      LIKE rxy_file.rxy12,
       l_rxy17      LIKE rxy_file.rxy17,
       l_sql_q      LIKE type_file.chr1000,
       l_sql_k      LIKE type_file.chr1000,
       l_ooe02_1    LIKE ooe_file.ooe02     #TQC-B10270 
 
 
#a:借方明細單身  (根據不同的付款方式)
   LET l_ac = 1
   LET g_sql1 = "SELECT * FROM rxx_file WHERE rxx01 = '",g_rxr.rxr01,
            "' AND rxxplant ='",g_rxr.rxrplant,"' AND rxx00 = '05' AND rxx04 > 0"
   PREPARE s_costs_pb2 FROM g_sql1
   DECLARE s_costs_cs2 SCROLL CURSOR WITH HOLD FOR s_costs_pb2
   FOREACH s_costs_cs2 INTO l_rxx.*
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
   INITIALIZE g_oob.*   TO NULL 
   INITIALIZE l_oob.*   TO NULL 
   IF cl_null(l_rxx.rxx04) THEN LET l_rxx.rxx04 = 0 END IF
   IF cl_null(l_rxx.rxx05) THEN LET l_rxx.rxx05 = 0 END IF
 
   SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01 = l_rxx.rxx02
   LET g_oob.oob01 = g_oma.oma01
   LET g_oob.oob02 = l_ac
   LET g_oob.oob03 = '1'
   CASE l_rxx.rxx02
    WHEN '06'  #如果是儲值卡,需衝預收款 根據帳款日期先后順序衝預收l_oma01   若預收金額不夠衝儲值卡交款金額，則按預收帳款日期先后來衝
      LET g_oob.oob04 = '3'
      LET l_wc = l_rxx.rxx04
    WHEN '03' #支票
      LET g_oob.oob04 = '1'
    WHEN '05' #聯盟卡
      LET g_oob.oob04 = 'E'
    OTHERWISE LET g_oob.oob04 = '2'
  END CASE
 
   LET g_oob.oob08 =g_oma.oma24
   IF cl_null(g_oob.oob08) THEN
      LET g_oob.oob08 = 1
   END IF
   LET g_oob.oob13 = g_oma.oma15
   LET g_oob.oob17 = l_ooe02   
   IF cl_null(g_oow.oow01) THEN                                                                                               
      IF g_bgerr THEN                                                                                                         
         CALL s_errmsg('oow01',g_oow.oow01,'','axr-149',1)                                                                    
      ELSE                                                                                                                    
        CALL cl_err('oow01','axr-149',1)                                                                                     
      END IF                                                                                                                  
      LET g_success = 'N'                                                                                                     
   END IF 
   LET g_oob.oob18 = g_oow.oow01      #
   LET g_oob.oob19 = 1

   IF cl_null(g_oob.oob17) THEN
      IF l_rxx.rxx02='02' THEN  #銀聯卡
      ###若是銀聯卡,直接報錯
         IF g_bgerr THEN
            CALL s_errmsg('rxx02',l_rxx.rxx02,'','axr-077',1)
         ELSE
            CALL cl_err('','axr-077',1)
         END IF 
         LET g_success = 'N'
      END IF
   ELSE
      SELECT nma05,nma051,nma10 INTO g_oob.oob11,g_oob.oob111,g_oob.oob07
        FROM nma_file 
       WHERE nma01 = g_oob.oob17
      IF g_aza.aza63 = 'N' THEN LET g_oob.oob111 = '' END IF
   END IF
 
   CASE
      WHEN l_rxx.rxx02 = '05'      #聯盟卡
         IF cl_null(g_oob.oob17) THEN              #根據卡中抓科目
            LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM rxy_file ",
                         " WHERE rxy01 = '",g_rxr.rxr01,"' ",
                         "   AND rxyplant ='",g_rxr.rxrplant,"' ", 
                         "   AND rxy03 = '05' ",
                         "   AND rxy00 = '07' "
            PREPARE s_k_pb FROM l_sql_k
            DECLARE s_k_cs SCROLL CURSOR FOR s_k_pb
            FOREACH s_k_cs INTO l_rxy05,l_rxy12,l_rxy17
               IF cl_null(l_rxy17) THEN LET l_rxy17 = 0 END IF
               IF cl_null(l_rxy05) THEN LET l_rxy05 = 0 END IF
               SELECT ood02,ood03 INTO g_oob.oob11,g_oob.oob111 FROM ood_file
                WHERE ood01 = l_rxy12
               IF g_aza.aza63 = 'N' THEN LET g_oob.oob111 = '' END IF
               LET g_oob.oob02 = l_ac
               LET g_oob.oob06 = g_oma.oma01
               LET g_oob.oob09 = l_rxy17 + l_rxy05   #含溢收金額
               CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
               LET g_oob.oob22 = g_oob.oob09         
               LET g_oob.oob10 = g_oob.oob08 * g_oob.oob09
               CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10                                                                       
 
               IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','','axr-076',1)
                  ELSE 
                     CALL cl_err('','axr-076',1)   
                  END IF                                                                                     
                  LET g_success = 'N'                                                                                               
               END IF
 
               IF cl_null(g_oob.oob11) THEN  
                  IF g_bgerr THEN
                     CALL s_errmsg('','','','axr-076',1)
                  ELSE 
                     CALL cl_err('','axr-076',1)   
                  END IF  
                  LET g_success = 'N'
               END IF 
 
               LET g_oob.oob18 = NULL 
               LET g_oob.ooblegal = g_legal
               INSERT INTO oob_file VALUES(g_oob.*)
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN          
                  IF g_bgerr THEN
                     CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                  ELSE                                                              
                     CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)        
                  END IF                        
                  LET g_success = 'N'
               END IF
               LET l_ac = l_ac + 1
            END FOREACH
         ELSE
            SELECT nma05,nma051,nma10 INTO g_oob.oob11,g_oob.oob111,g_oob.oob07
              FROM nma_file
             WHERE nma01 = g_oob.oob17 
            IF g_aza.aza63 = 'N' THEN LET g_oob.oob111 = '' END IF 
            LET g_oob.oob02 = l_ac
            LET g_oob.oob06 = g_oma.oma01
            LET g_oob.oob09 = l_rxx.rxx04 + l_rxx.rxx05    #含溢收金額
            CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09       
            LET g_oob.oob22 = g_oob.oob09         
            LET g_oob.oob10 = g_oob.oob08 * g_oob.oob09
            CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10                                                                        
            IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
               IF g_bgerr THEN
                  CALL s_errmsg('','','','axr-076',1)
               ELSE
                  CALL cl_err('','axr-076',1)     
               END IF                                                                                   
               LET g_success = 'N'                                                                                               
            END IF
            IF cl_null(g_oob.oob11) THEN 
               IF g_bgerr THEN  
                  CALL s_errmsg('','','','axr-076',1)
               ELSE
                  CALL cl_err('','axr-076',1)  
               END IF   
               LET g_success = 'N'
            END IF  
            LET g_oob.oob17 = NULL 
            LET g_oob.oob18 = NULL
            LET g_oob.ooblegal = g_legal 
            INSERT INTO oob_file VALUES(g_oob.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                                                                       
               IF g_bgerr THEN
                  CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
               ELSE 
                  CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)                              
               END IF  
               LET g_success = 'N'
            END IF
            LET l_ac = l_ac + 1
        END IF
      WHEN  l_rxx.rxx02 = '06'      #儲值卡交款
         LET g_sql1 = "SELECT oma01,oma54t-oma55 FROM oma_file",
                     " WHERE oma03='MISCCARD' and oma00='26' AND (oma54t - oma55 > 0) order by oma02 "
         PREPARE s_costs_pb3 FROM g_sql1
         DECLARE s_costs_cs3 SCROLL CURSOR FOR s_costs_pb3
         FOREACH s_costs_cs3 INTO l_oma01,l_amt
            IF SQLCA.sqlcode THEN
               CALL cl_err('foreach:',SQLCA.sqlcode,1)
               EXIT FOREACH
            END IF
            CALL s_up_money(l_oma01)  RETURNING l_amt1    # 已衝金額
            LET l_amt = l_amt-l_amt1     ##減去未審核的金額
            IF l_amt<=0 THEN
               CONTINUE FOREACH
            END IF
            IF l_wc <= 0 THEN EXIT FOREACH END IF
            IF l_wc >= l_amt THEN
               LET g_oob.oob02 = l_ac
               LET l_wc = l_wc - l_amt
               LET g_oob.oob06 = l_oma01
               LET g_oob.oob09 = l_amt
               CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
               LET g_oob.oob22 = g_oob.oob09          
               LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
               CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
               LET g_oob.oob17 = NULL
               LET g_oob.oob18 = NULL 
               IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','','axr-076',1)
                  ELSE
                     CALL cl_err('','axr-076',1)
                  END IF 
                  LET g_success = 'N'
               END IF
               IF cl_null(g_oob.oob11) THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','','axr-076',1)
                  ELSE
                     CALL cl_err('','axr-076',1)
                  END IF 
                  LET g_success = 'N'
               END IF
               LET g_oob.ooblegal = g_legal 
               INSERT INTO oob_file VALUES(g_oob.*)
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                  END IF 
                  LET g_success = 'N'
               END IF
               LET l_ac = l_ac + 1
               CONTINUE FOREACH
            ELSE
               LET g_oob.oob02 = l_ac
               LET g_oob.oob06 = l_oma01
               LET g_oob.oob09 = l_wc
               CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
               LET g_oob.oob22 = g_oob.oob09         
               LET l_wc = 0
               LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
               CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
               LET g_oob.oob17 = NULL
               LET g_oob.oob18 = NULL
               IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','','axr-076',1)
                  ELSE
                     CALL cl_err('','axr-076',1)
                  END IF 
                  LET g_success = 'N'
               END IF
               IF cl_null(g_oob.oob11) THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','','axr-076',1)
                  ELSE
                     CALL cl_err('','axr-076',1)
                  END IF 
                  LET g_success = 'N'
               END IF
               LET g_oob.ooblegal = g_legal 
               INSERT INTO oob_file VALUES(g_oob.*)
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                  END IF 
                  LET g_success = 'N'
               END IF
               LET l_ac = l_ac + 1
               CONTINUE FOREACH
           END IF
        END FOREACH
 
     WHEN l_rxx.rxx02 = '03'     #支票
        LET g_sql1 = "SELECT * FROM rxy_file",
                    " WHERE rxy01 ='", g_rxr.rxr01,"' AND rxyplant='",g_rxr.rxrplant,"' AND rxy00 = '07'",
                    " AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
        PREPARE s_costs_pb5 FROM g_sql1
        DECLARE s_costs_cs5 SCROLL CURSOR FOR s_costs_pb5
        FOREACH s_costs_cs5 INTO l_rxy.*
           IF SQLCA.sqlcode THEN
              CALL cl_err('foreach:',SQLCA.sqlcode,1)
              EXIT FOREACH
           END IF
           IF cl_null(l_rxy.rxy05) THEN LET l_rxy.rxy05=0 END IF
           IF cl_null(l_rxy.rxy07) THEN LET l_rxy.rxy07=0 END IF
           IF cl_null(l_rxy.rxy08) THEN LET l_rxy.rxy08=0 END IF
           IF cl_null(l_rxy.rxy09) THEN LET l_rxy.rxy09=0 END IF
           IF cl_null(l_rxy.rxy16) THEN LET l_rxy.rxy16=0 END IF
           IF cl_null(l_rxy.rxy17) THEN LET l_rxy.rxy17=0 END IF
###產生anmt200的資料
           IF cl_null(g_oow.oow22) THEN                                                                                                
              IF g_bgerr THEN                                                                                                          
                 CALL s_errmsg('oow22',g_oow.oow22,'','axr-149',1)                                                                     
              ELSE                                                                                                                     
                 CALL cl_err('oow22','axr-149',1)                                                                                      
              END IF                                                                                                                   
              LET g_success = 'N' 
           END IF 
            CALL s_auto_assign_no("ANM",g_oow.oow22,l_rxy.rxy10,"2","nmh_file","nmh01","","","")  
              RETURNING li_result,g_nmh.nmh01
           IF (NOT li_result) THEN
              LET g_success = 'N'
              RETURN
           END IF
           LET g_nmh.nmh02 = l_rxy.rxy09
           IF cl_null(g_oow.oow25) THEN                                                                                                
              IF g_bgerr THEN                                                                                                          
                 CALL s_errmsg('oow25',g_oow.oow25,'','axr-149',1)                                                                     
              ELSE                                                                                                                     
                 CALL cl_err('oow25','axr-149',1)                                                                                      
              END IF                                                                                                                   
              LET g_success = 'N' 
           END IF 
           LET g_nmh.nmh03 = g_oow.oow25
           LET g_nmh.nmh04 = l_rxy.rxy10
           LET g_nmh.nmh05 = l_rxy.rxy10
           LET g_nmh.nmh07 = l_rxy.rxy06
           LET g_nmh.nmh08 = 0
           LET g_nmh.nmh11 = g_rxr.rxr06
           IF cl_null(g_oow.oow23) THEN                                                                                                
              IF g_bgerr THEN                                                                                                          
                 CALL s_errmsg('oow23',g_oow.oow23,'','axr-149',1)                                                                     
              ELSE                                                                                                                     
                 CALL cl_err('oow23','axr-149',1)                                                                                      
              END IF                                                                                                                   
              LET g_success = 'N' 
           END IF 
           LET g_nmh.nmh12 = g_oow.oow23
           LET g_nmh.nmh13 = 'N'
           IF cl_null(g_oow.oow24) THEN                                                                                                
              IF g_bgerr THEN                                                                                                          
                 CALL s_errmsg('oow24',g_oow.oow24,'','axr-149',1)                                                                     
              ELSE                                                                                                                     
                 CALL cl_err('oow24','axr-149',1)                                                                                      
              END IF                                                                                                                   
           END IF 
           #TQC-B10270  --Begin    #nmh21默認值=axri060支票對應銀行
           LET l_ooe02_1 = ' '
           SELECT ooe02 INTO l_ooe02_1 FROM ooe_file WHERE ooe01 = '03'
           LET g_nmh.nmh21 = l_ooe02_1
           #TQC-B10270  --End
           LET g_success = 'N' 
           LET g_nmh.nmh15 = g_oow.oow24
           LET g_nmh.nmh17 = l_rxy.rxy09
           LET g_nmh.nmh24 = '1'
           LET g_nmh.nmh25 = TODAY
           LET g_nmh.nmh28 = 1
           LET g_nmh.nmh38 = 'Y'
           LET g_nmh.nmh39 = 0
           LET g_nmh.nmh40 = 0
           CALL cl_digcut(g_nmh.nmh40,g_azi04) RETURNING g_nmh.nmh40
 
           IF g_nmz.nmz11 = 'Y' THEN LET l_dept = g_nmh.nmh15 ELSE LET l_dept = ' ' END IF
           SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = l_dept
           LET g_nmh.nmh26  = g_nms.nms22
           LET g_nmh.nmh261 = g_nms.nms22
           LET g_nmh.nmh27  = g_nms.nms21
           LET g_nmh.nmh271 = g_nms.nms21
           LET g_nmh.nmh06 = l_rxy.rxy11   #FUN-C30038  ADD
           #LET g_nmh.nmh41 = ' '          #TQC-B10270 
           LET g_nmh.nmh41 = 'N'           #TQC-B10270 
           LET g_nmh.nmhoriu = g_user    
           LET g_nmh.nmhorig = g_grup   
           LET g_nmh.nmhlegal = g_legal
           IF cl_null(g_nmh.nmh42) THEN LET g_nmh.nmh42 = 0 END IF   #No.FUN-B40011
           INSERT INTO nmh_file VALUES(g_nmh.*)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("ins","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","ins nmh",1)
              LET g_success = 'N'
           END IF
###oob的資料
           LET g_oob.oob04 = '1' 
           LET g_oob.oob17 = NULL
           LET g_oob.oob18 = NULL
           LET g_oob.oob06 = g_nmh.nmh01
           SELECT ool12,ool121 INTO g_oob.oob11,g_oob.oob111 FROM ool_file
            WHERE ool01 = g_oma.oma13 
 
           LET g_oob.oob09 = l_rxy.rxy09
           CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
 
           LET g_oob.oob22 = g_oob.oob09         
           LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
           CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
 
           IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
              IF g_bgerr THEN
                 CALL s_errmsg('','','','axr-076',1)
              ELSE
                 CALL cl_err('','axr-076',1)
              END IF 
              LET g_success = 'N'
           END IF
 
           IF cl_null(g_oob.oob11) THEN
              IF g_bgerr THEN
                 CALL s_errmsg('','','','axr-076',1)
              ELSE
                 CALL cl_err('','axr-076',1)
              END IF 
              LET g_success = 'N'
           END IF
 
           LET g_oob.ooblegal = g_legal 
           INSERT INTO oob_file VALUES(g_oob.*)
           IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
              CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
              LET g_success = 'N'
           END IF
           LET l_ac = l_ac + 1
        END FOREACH
 
     OTHERWISE
        LET g_oob.oob06 = g_oma.oma01
        LET g_oob.oob09 = l_rxx.rxx04
        CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
        LET g_oob.oob22 = g_oob.oob09         
        LET g_oob.oob10 = g_oob.oob08*g_oob.oob09
        CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
 
        IF cl_null(g_oob.oob17) THEN
           IF g_bgerr THEN
              CALL s_errmsg('','','','axr-077',1)
           ELSE
              CALL cl_err('','axr-077',1)
           END IF 
           LET g_success = 'N'
        END IF
 
        IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
           IF g_bgerr THEN
              CALL s_errmsg('','','','axr-076',1)
           ELSE
              CALL cl_err('','axr-076',1)
           END IF 
           LET g_success = 'N'
        END IF
 
        IF cl_null(g_oob.oob11) THEN
           IF g_bgerr THEN
              CALL s_errmsg('','','','axr-076',1)
           ELSE
              CALL cl_err('','axr-076',1)
           END IF 
           LET g_success = 'N'
        END IF
        LET g_oob.ooblegal = g_legal 
        INSERT INTO oob_file VALUES(g_oob.*)
        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
           IF g_bgerr THEN
              CALL s_errmsg('oob01',g_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
           ELSE
              CALL cl_err3("ins","oob_file",g_oob.oob01,g_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
           END IF 
           LET g_success = 'N'
        END IF
 
        LET l_ac = l_ac + 1
       END CASE
       CALL s_ar_gen_nme()
    END FOREACH
 
# b:貸方資料
    DELETE FROM oob_file WHERE oob01 = g_oma.oma01 AND oob02 <0 AND oob03 = '2' AND oob04 = '1'
    INITIALIZE l_oob.* TO NULL
    INITIALIZE l_ooa.* TO NULL
    SELECT * INTO l_ooa.* FROM ooa_file WHERE ooa01 = g_oma.oma01
    DECLARE s_costs_sel_oob_cur CURSOR FOR
       SELECT * FROM oob_file
        WHERE oob01 =g_oma.oma01
    FOREACH s_costs_sel_oob_cur INTO l_oob.*
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_oob.oob02 = l_oob.oob02*(-1)
       LET l_oob.oob03 = '2'
       LET l_oob.oob04 = '1' LET l_oob.oob06 = g_oma.oma01
       IF cl_null(l_oob.oob09) THEN LET l_oob.oob09 = 0 END IF
       CALL cl_digcut(g_oob.oob09,t_azi04) RETURNING g_oob.oob09
 
       LET g_oob.oob22 = g_oob.oob09         
       IF cl_null(l_oob.oob10) THEN LET l_oob.oob10 = 0 END IF
       CALL cl_digcut(g_oob.oob10,g_azi04) RETURNING g_oob.oob10
 
       IF cl_null(g_oob.oob17) THEN
          IF g_bgerr THEN
             CALL s_errmsg('','','','axr-077',1)
          ELSE
             CALL cl_err('','axr-077',1)
          END IF 
          LET g_success = 'N'
       END IF
 
       IF g_aza.aza63='Y' AND cl_null(g_oob.oob111) THEN
          IF g_bgerr THEN
             CALL s_errmsg('','','','axr-076',1)
          ELSE
             CALL cl_err('','axr-076',1)
          END IF 
          LET g_success = 'N'
       END IF
 
       IF cl_null(g_oob.oob11) THEN
          IF g_bgerr THEN
             CALL s_errmsg('','','','axr-076',1)
          ELSE
             CALL cl_err('','axr-076',1)
          END IF 
          LET g_success = 'N'
       END IF
       LET l_oob.ooblegal = g_legal
       INSERT INTO oob_file VALUES (l_oob.*)
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
          CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
          LET g_success = 'N'
       END IF
    END FOREACH
END FUNCTION
 
FUNCTION s_ar_gen_ooa()
 
   INITIALIZE g_ooa.* TO NULL
 
   LET g_ooa.ooa00 = '2'
   LET g_ooa.ooa01 = g_oma.oma01
   LET g_ooa.ooa02 = g_oma.oma02
   LET g_ooa.ooa021= g_today
   LET g_ooa.ooa03 = g_oma.oma03
   LET g_ooa.ooa032= g_oma.oma032
   LET g_ooa.ooa13 = g_oma.oma13
   LET g_ooa.ooa14 = g_user
   LET g_ooa.ooa15 = g_grup
   LET g_ooa.ooa20 = 'Y'
   LET g_ooa.ooa23 = g_oma.oma23
   LET g_ooa.ooa24 = g_oma.oma24
 
   LET g_ooa.ooa31d = 0 LET g_ooa.ooa31c = 0
   LET g_ooa.ooa32d = 0 LET g_ooa.ooa32c = 0
   SELECT SUM(oob09),SUM(oob10)
     INTO g_ooa.ooa31d,g_ooa.ooa32d
     FROM oob_file
    WHERE oob01=g_oma.oma01 
      AND oob03='1'  AND oob02>0 
 
   SELECT SUM(oob09),SUM(oob10) 
     INTO g_ooa.ooa31c,g_ooa.ooa32c
     FROM oob_file 
    WHERE oob01=g_oma.oma01 
      AND oob03='2' AND oob02 > 0
 
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
 
   LET g_ooa.ooaconf = 'N'
   LET g_ooa.ooaprsw = 0
   LET g_ooa.ooauser = g_user
   LET g_ooa.ooagrup = g_grup
   LET g_ooa.ooadate = g_today
   LET g_ooa.ooa37 = '1' 
   LET g_ooa.ooaoriu = g_user  
   LET g_ooa.ooaorig = g_grup 
   LET g_ooa.ooalegal = g_legal
   INSERT INTO ooa_file values(g_ooa.*)
 
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","ins ooa",1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION s_ar_gen_npp()
   DEFINE l_flag    LIKE type_file.chr1
 
   DELETE FROM npp_file WHERE npp01 = g_oma.oma01
      AND npp00 = 2 AND nppsys = 'AR'  
      AND npp011 = 1 AND npptype = '0'
 
   DELETE FROM npq_file WHERE npq01 = g_oma.oma01
      AND npq00 = 2 AND npqsys = 'AR'  
      AND npq011 = 1 AND npqtype = '0'
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = g_oma.oma01
   #FUN-B40056--add--end--
 
   CALL s_get_bookno(YEAR(g_oma.oma02)) RETURNING l_flag,g_bookno1,g_bookno2
 
   IF l_flag =  '1' THEN  #抓不到帳別
      IF g_bgerr THEN
         CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
      ELSE
         CALL cl_err(g_oma.oma02,'aoo-081',1)
      END IF 
      LET g_success = 'N'
   END IF
 
   LET g_bookno3 = g_bookno1
 
###產生npp_file
   LET g_npp.nppsys = 'AR'
   LET g_npp.npp00 = 2 
   LET g_npp.npp01 = g_oma.oma01
   LET g_npp.npp011 =  1   
   LET g_npp.npp02 = g_oma.oma02 
   LET g_npp.npp03 = NULL
   LET g_npp.npptype = '0'
   LET g_npp.npplegal = g_legal 
   INSERT INTO npp_file VALUES(g_npp.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL cl_err3("ins","npp_file",g_npp.nppsys,g_npp.npp01,SQLCA.sqlcode,"","ins npp",1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION s_yz_hu1(p_sw)
 
  DEFINE l_cnt          LIKE type_file.num5
  DEFINE p_sw		LIKE type_file.chr1
  DEFINE l_oma01        LIKE oma_file.oma01
  DEFINE l_oma		RECORD LIKE oma_file.*
  DEFINE g_omc		RECORD LIKE omc_file.*
  DEFINE l_buf          LIKE type_file.chr3
  DEFINE l_str          LIKE type_file.chr1000
 
  LET l_str = "bu_22:",g_oma.oma01 CLIPPED,' ',g_oma.oma02 CLIPPED
  CALL cl_msg(l_str)
 
  INITIALIZE l_oma.* TO NULL
 
  LET l_oma.* = g_oma.*
  IF p_sw = '-' THEN
     SELECT * INTO l_oma.* FROM oma_file WHERE oma01=g_oma.oma19
     IF l_oma.oma55 > 0 OR l_oma.oma57 > 0 THEN
        IF g_bgerr THEN
           CALL s_errmsg('oma01',g_oma.oma19,'oma55,57>0','axr-206',1)
        ELSE
           CALL cl_err('oma55,57>0','axr-206',1)
        END IF
        LET g_success = 'N'
        RETURN
     END IF
 
     DELETE FROM oma_file WHERE oma01 = g_oma.oma19
     IF STATUS THEN
        IF g_bgerr THEN
           CALL s_errmsg('oma01',g_oma.oma19,'del oma',STATUS,1)
        ELSE
           CALL cl_err3("del","oma_file",g_oma.oma19,"",STATUS,"","del oma",1)
        END IF
        LET g_success = 'N'
        RETURN
     END IF
 
     DELETE FROM omc_file WHERE omc01 = g_oma.oma19
     IF STATUS THEN
        IF g_bgerr THEN
           CALL s_errmsg('omc',g_oma.oma19,"del omc",STATUS,1)
        ELSE
           CALL cl_err3("del","omc_file",g_oma.oma01,"",STATUS,"","del omc",1)
        END IF
        LET g_success = 'N'
        RETURN
     END IF
 
     DELETE FROM oov_file WHERE oov01 = g_oma.oma19
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
           CALl s_errmsg('oov01',g_oma.oma19,'del oov',status,1)
        ELSE
           CALL cl_err3("del","oov_file",g_oma.oma19,"",STATUS,"","del oov",1)
        END IF
        LET g_success='N'
     END IF
 
     UPDATE oma_file SET oma19 = '' WHERE oma01=g_oma.oma01
     IF SQLCA.sqlcode THEN
        IF g_bgerr THEN
           CALL s_errmsg('oma01',g_oma.oma01,'upd oma',status,1)
        ELSE
           CALL cl_err3("upd","oma_file",g_oma.oma01,"",STATUS,"","upd oma",1)
        END IF
        LET g_success='N'
     END IF
  END IF
 
  IF p_sw = '+' THEN
     LET l_oma.* = g_oma.*
     IF cl_null(g_oma.oma19) THEN
        IF cl_null(g_oow.oow19) THEN
           IF g_bgerr THEN 
              CALL s_errmsg('oow19',g_oow.oow19,'','axr-149',1)  
           ELSE
              CALL cl_err('oow19','axr-149',1)
           END IF 
           LET g_success = 'N'
        ELSE
           LET l_oma.oma01 = g_oow.oow19,'-'
        END IF 
     ELSE 
        LET l_oma.oma01 = g_oma.oma19
     END IF
 
    CALL s_auto_assign_no("axr",l_oma.oma01,g_today,"26","oma_file","oma01","","","")
    RETURNING li_result,l_oma.oma01
    IF (NOT li_result) THEN
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
    LET l_oma.omaconf='Y' 
    LET l_oma.omavoid='N'
    LET l_oma.omauser=g_user
    LET l_oma.omadate=g_today
    LET l_oma.oma65 = '1'
    LET l_oma.oma66= g_oma.oma66
    LET l_oma.oma67 = NULL
    LET l_oma.oma16 = g_rxr.rxr01 
 
    IF g_aaz.aaz90='Y' THEN
       IF cl_null(l_oma.oma15) THEN
          LET l_oma.oma15=g_grup
       END IF
       LET l_oma.oma66 = s_costcenter(l_oma.oma15)    
    END IF
 
    LET l_oma.omaoriu = g_user     
    LET l_oma.omaorig = g_grup    
    LET l_oma.omalegal = g_legal 
    IF cl_null(l_oma.oma73) THEN LET l_oma.oma73 =0 END IF
    IF cl_null(l_oma.oma73f) THEN LET l_oma.oma73f =0 END IF
    IF cl_null(g_oma.oma74) THEN LET g_oma.oma74 ='1' END IF

    INSERT INTO oma_file VALUES(l_oma.*)
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       IF g_bgerr THEN
          CALL s_errmsg('oma01',l_oma.oma01,'ins oma',SQLCA.SQLCODE,1)
       ELSE
          CALL cl_err3("ins","oma_file",l_oma.oma01,"",SQLCA.sqlcode,"","ins oma",1)
      END IF
      LET g_success = 'N'
      RETURN
    END IF
 
    LET g_omc.omc01 = l_oma.oma01
    LET g_omc.omc02 = 1
    LET g_omc.omc03 = l_oma.oma32
    LET g_omc.omc04 = l_oma.oma11
    LET g_omc.omc05 = l_oma.oma12
    LET g_omc.omc06 = l_oma.oma24
    LET g_omc.omc07 = l_oma.oma60
    LET g_omc.omc08 = l_oma.oma54t
    LET g_omc.omc09 = l_oma.oma56t
    LET g_omc.omc10 = 0
    LET g_omc.omc11 = 0
    LET g_omc.omc12 = l_oma.oma10
    LET g_omc.omc13 = g_omc.omc09 - g_omc.omc11
    LET g_omc.omc14 = 0
    LET g_omc.omc15 = 0

    LET g_omc.omclegal = g_legal  
    INSERT INTO omc_file VALUES(g_omc.*)
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
       IF g_bgerr THEN
          LET g_showmsg=g_omc.omc01,"/",g_omc.omc02
          CALL s_errmsg('omc01,omc02',g_showmsg,"ins omc",SQLCA.sqlcode,1)
       ELSE
          CALL cl_err3("ins","omc_file",g_omc.omc01,"",SQLCA.sqlcode,"","ins omc",1)
       END IF
       LET g_success = 'N'
       RETURN
    END IF
 
    UPDATE oma_file SET oma19=l_oma.oma01 WHERE oma01=g_oma.oma01
    IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
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
 
FUNCTION s_ar_gen_nme()
 DEFINE l_nme  RECORD LIKE nme_file.*
 DEFINE l_oob  RECORD LIKE oob_file.*
 DEFINE l_ooa  RECORD LIKE ooa_file.*
 DEFINE l_rxxplant    LIKE   rxx_file.rxxplant

#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
 LET l_ooa.* = g_ooa.*
 LET l_oob.* = g_oob.*
 IF l_oob.oob03='1' AND l_oob.oob04='2' THEN
 
    INITIALIZE l_nme.* TO NULL
    DISPLAY "INS_NME NOW...."
 
      LET l_nme.nme00 = 0
      LET l_nme.nme01 = l_oob.oob17
      LET l_nme.nme02 = l_ooa.ooa02
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
      LET l_nme.nme16 = l_ooa.ooa02
      LET l_nme.nme17 = g_oma.oma01
      LET l_nme.nmeacti='Y'
      LET l_nme.nmeuser=g_user
      LET l_nme.nmegrup=g_grup
      LET l_nme.nmedate=TODAY
      LET l_nme.nme21 = l_oob.oob02
      LET l_nme.nme22 = '08'   #直接收款
      LET l_nme.nme24 = '9'    #未轉
      LET l_nme.nme25 = l_ooa.ooa03    #客戶編號
 
      LET l_nme.nmeoriu = g_user      
      LET l_nme.nmeorig = g_grup     
      LET l_nme.nmelegal = g_legal

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
         CALL cl_err3("ins","nme_file",l_nme.nme01,l_nme.nme02,SQLCA.sqlcode,"","ins nme",1)
         LET g_success = 'N'
      END IF
      CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062    
   END IF
END FUNCTION
 
 
FUNCTION s_ar_y_chk()
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
      IF g_oma.oma65 != '2' THEN
         CALL s_chknpq(g_oma.oma01,'AR',1,'0',g_bookno1) 
         IF g_aza.aza63='Y' AND g_success='Y' THEN
            CALL s_chknpq(g_oma.oma01,'AR',1,'1',g_bookno2)  
         END IF
      END IF
 
      #檢查單頭金額與分錄金額借方科目是否相符
      IF g_aza.aza26='2' AND g_ooy.ooydmy2='Y' AND g_oma.oma00 MATCHES '2*' THEN   
         LET l_status='1'      #借
      ELSE
         LET l_status='2'      #貸
      END IF
      IF g_oma.oma00 MATCHES '2*' THEN   
         SELECT SUM(npq07) INTO l_npq07 FROM npq_file
          WHERE npq01 = g_oma.oma01 AND npq06 = l_status  
           AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma18      
            AND npqtype = '0' 
         IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
         IF l_npq07<0 THEN LET l_npq07 = (-1)*l_npq07  END IF  
         IF l_npq07 != g_oma.oma56t THEN  
            IF g_bgerr THEN
               CALL s_errmsg("npq07",l_npq07,"","aap-278",1)
            ELSE
               CALL cl_err(l_npq07,'aap-278',1)
            END IF 
            LET g_success = 'N'
         END IF
         IF g_aza.aza63 = 'Y' THEN
            SELECT SUM(npq07) INTO l_npq07_1 FROM npq_file
             WHERE npq01 = g_oma.oma01 AND npq06 = l_status
               AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma181   
               AND npqtype = '1'
            IF cl_null(l_npq07_1) THEN LET l_npq07_1=0 END IF
            IF l_npq07_1<0 THEN LET l_npq07_1 = (-1)*l_npq07_1  END IF
            IF l_npq07_1 != g_oma.oma56t THEN 
               IF g_bgerr THEN 
                  CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)
               ELSE
                  CALL cl_err(l_npq07_1,'aap-278',1)
               END IF 
               LET g_success = 'N'
            END IF
         END IF
      ELSE
         IF g_oma.oma65 != '2' THEN  
            SELECT SUM(npq07) INTO l_npq07 FROM npq_file
             WHERE npq01 = g_oma.oma01 AND npq06 = '1'         
              AND npqsys= 'AR' AND npq011 = 1 AND npq03=g_oma.oma18
               AND npqtype = '0'
            IF cl_null(l_npq07) THEN LET l_npq07=0 END IF
            IF l_cnt > 0 THEN
               IF l_npq07 != (g_oma.oma56t-l_oot05t) THEN  
                  IF g_bgerr THEN 
                     CALL s_errmsg("npq07",l_npq07,"","aap-278",1)
                  ELSE
                     CALL cl_err(l_npq07,'aap-278',1)
                  END IF 
                  LET g_success = 'N'
               END IF
            ELSE
               IF l_npq07 != g_oma.oma56t THEN
                  IF g_bgerr THEN
                     CALL s_errmsg("npq07",l_npq07,"","aap-278",1)
                  ELSE
                     CALL cl_err(l_npq07,'aap-278',1)
                  END IF 
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
                     IF g_bgerr THEN
                        CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)
                     ELSE
                        CALL cl_err(l_npq07_1,'aap-278',1)
                     END IF 
                     LET g_success = 'N'
                  END IF
               ELSE
                  IF l_npq07_1 != g_oma.oma56t THEN 
                     IF g_bgerr THEN 
                        CALL s_errmsg("npq07",l_npq07_1,"","aap-278",1)
                     ELSE
                        CALL cl_err(l_npq07_1,'aap-278',1)
                     END IF 
                     LET g_success = 'N'
                  END IF
               END IF
            END IF
         END IF
      END IF
      IF g_success='Y' THEN
         LET g_cnt=0
         SELECT COUNT(*) INTO g_cnt FROM npp_file,oma_file
          WHERE oma01=g_oma.oma01  
           AND npp01=oma01 AND nppsys='AR' AND npp011=1 AND npp00=2
           AND ( YEAR(oma02) != YEAR(npp02) OR
               (YEAR(oma02)  = YEAR(npp02) AND MONTH(oma02) != MONTH(npp02)))
         IF g_cnt >0 THEN
            IF g_bgerr THEN
               LET g_showmsg=g_oma.oma01,"/",'AR',"/",1,"/",2        
               CALL s_errmsg('oma01,nppsys,npp011,npp00',g_showmsg,'','aap-279',1)  
            ELSE
               CALL cl_err(g_oma.oma01,'aap-279',1)
            END IF 
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
            IF g_bgerr THEN
               CALL s_errmsg("oma54x",l_oma54x,"","aap-757",0)
            ELSE
               CALL cl_err(l_oma54x,'aap-757',1)
            END IF 
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
        IF g_bgerr THEN
           CALL s_errmsg('','','','axr-111',0)
        ELSE
           CALL cl_err('','axr-111',0)
        END IF 
        LET g_success = 'N'
        RETURN
     END IF
   ELSE
     IF g_bgerr THEN
        CALL s_errmsg('','','','aap-995',0)
     ELSE
        CALL cl_err('','aap-995',0)
     END IF 
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
          IF g_bgerr THEN
             CALL s_errmsg('','','','axr-112',0)
          ELSE
             CALL cl_err('','axr-112',0)
          END IF 
          LET g_success = 'N'
          RETURN
       END IF
     ELSE
       IF g_bgerr THEN
          CALL s_errmsg('','','','aap-975',0)
       ELSE
          CALL cl_err('','aap-975',0)
       END IF 
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
      IF g_bgerr THEN
         CALL s_errmsg('','','','axr-025',1)
      ELSE
         CALL cl_err('','axr-025',1)
      END IF 
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
            IF g_bgerr THEN
               CALL s_errmsg('','','','aap-912',0)
            ELSE
               CALL cl_err('','aap-912',0)
            END IF 
            LET g_success = 'N'
            RETURN
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION s_ar_gen_npq()
DEFINE l_aag371 LIKE aag_file.aag371,
       l_occ02  LIKE occ_file.occ02,
       l_occ37  LIKE occ_file.occ37,
       l_oob09  LIKE oob_file.oob09,
       l_oob10  LIKE oob_file.oob10
DEFINE l_flag   LIKE type_file.chr1    #FUN-D40118 add
 
   INITIALIZE g_npq.* TO NULL
   LET g_npq.npqsys = 'AR'
   LET g_npq.npq00 = 2
   LET g_npq.npq01 = g_oma.oma01
   LET g_npq.npq011 = 1
   LET g_npq.npq02 = 0
   LET g_npq.npqtype = 0
   LET g_npq.npq04 = NULL
   LET g_npq.npq05 = g_oma.oma15
   LET g_npq.npq21 = g_oma.oma03
   LET g_npq.npq22 = g_oma.oma032
   LET g_npq.npq24 = g_oma.oma23
   LET g_npq.npq25 = g_oma.oma24
   LET g_npq.npq02 = g_npq.npq02 + 1
   LET g_npq.npq03 = g_oma.oma18
 
   ###是否做部門管理
   LET g_aag05 = NULL  LET g_aag23 = NULL
   SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file WHERE aag01 = g_npq.npq03
      AND aag00 = g_bookno3
   IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN LET g_npq.npq05 = ' ' END IF
 
   IF g_aag05='Y' THEN  LET g_npq.npq05=s_t300_gl_set_npq05(g_oma.oma15,g_oma.oma66) END IF
 
   LET g_npq.npq06 = '1'
   LET g_npq.npq07f = g_oma.oma54t 
   LET g_npq.npq07 = g_oma.oma56t
 
   IF g_aag23 = 'Y' THEN 
      LET g_npq.npq08 = g_oma.oma63
   ELSE
      LET g_npq.npq08 = null 
   END IF #專案
 
   LET g_npq.npq23 = g_oma.oma01
   LET l_aag371=' ' LET g_npq.npq37=''
   SELECT aag371 INTO l_aag371 FROM aag_file
    WHERE aag01=g_npq.npq03
      AND aag00 = g_bookno3
   IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
   CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3) 
        RETURNING  g_npq.*
   IF l_aag371 MATCHES '[23]' THEN
      SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file WHERE occ01=g_oma.oma03
      IF cl_null(g_npq.npq37) THEN
         IF l_occ37='Y' THEN LET g_npq.npq37=l_occ02 CLIPPED END IF
      END IF
   END IF
   LET g_npq.npqlegal = g_legal 
   IF g_npq.npq07 <> 0 THEN  
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
      INSERT INTO npq_file VALUES (g_npq.*)  END IF
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq",1)
         LET g_success = 'N'
      END IF
 
      SELECT oma_file.*,ool_file.* INTO g_oma.*,g_ool.*
        FROM oma_file, OUTER ool_file WHERE oma01 = g_trno
         AND oma13=ool_file.ool01
      LET g_npq.npq02 = g_npq.npq02 + 1
      LET g_npq.npq04 = NULL
      LET g_npq.npq03 = g_ool.ool21
      LET g_npq.npq06 = '2'
      LET g_npq.npq07f = g_oma.oma54
      LET g_npq.npq07 = g_oma.oma56
      LET g_npq.npq23 = g_oma.oma19
      ###是否做部門管理
      LET g_aag05 = NULL
      LET g_aag23 = NULL
      SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
       WHERE aag01 = g_npq.npq03
         AND aag00 = g_bookno3
      IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
         LET g_npq.npq05 = ' ' 
      END IF
      IF g_aag05='Y' THEN 
         LET g_npq.npq05=s_t300_gl_set_npq05(g_oma.oma15,g_oma.oma66)
      END IF
 
      IF g_aag23 = 'Y' THEN
         LET g_npq.npq08 = g_oma.oma63
      ELSE 
         LET g_npq.npq08 = null
      END IF
 
      LET l_aag371=' ' LET g_npq.npq37=''
      SELECT aag371 INTO l_aag371 FROM aag_file
       WHERE aag01=g_npq.npq03
         AND aag00 = g_bookno3
 
      IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
      CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)
           RETURNING  g_npq.*
      IF l_aag371 MATCHES '[23]' THEN
         #-->for 合并報表-關系人
         SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
          WHERE occ01=g_oma.oma03
         IF cl_null(g_npq.npq37) THEN
            IF l_occ37='Y' THEN
               LET g_npq.npq37=l_occ02 CLIPPED
            END IF
         END IF
      END IF
 
      IF g_npq.npq07 <> 0 THEN
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
      END IF
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq",1)
         LET g_success = 'N'
      END IF
 
   ###稅:
      IF g_oma.oma54x > 0 THEN
         LET g_npq.npq02 = g_npq.npq02 + 1
         LET g_npq.npq04 = NULL
         LET g_npq.npq03 = g_ool.ool28
         LET g_npq.npq06 = '2'
         LET g_npq.npq07f = g_oma.oma54x
         LET g_npq.npq07 = g_oma.oma56x
         LET g_npq.npq23 = g_oma.oma01
         LET g_aag05 = NULL
         LET g_aag23 = NULL
         SELECT aag05,aag23 INTO g_aag05,g_aag23 FROM aag_file
          WHERE aag01 = g_npq.npq03
           AND aag00 = g_bookno3
         IF NOT cl_null(g_aag05) AND g_aag05 = 'N' THEN
            LET g_npq.npq05 = ' '
         END IF
         IF g_aag05='Y' THEN 
            LET g_npq.npq05=s_t300_gl_set_npq05(g_oma.oma15,g_oma.oma66)
         END IF
 
         IF g_aag23 = 'Y' THEN 
            LET g_npq.npq08 = g_oma.oma63
         ELSE
            LET g_npq.npq08 = null
         END IF
 
         LET l_aag371=' ' LET g_npq.npq37=''
         SELECT aag371 INTO l_aag371 FROM aag_file
          WHERE aag01=g_npq.npq03
            AND aag00 = g_bookno3
         IF cl_null(g_npq.npq03) THEN LET g_npq.npq03='-' END IF
         CALL s_def_npq(g_npq.npq03,g_prog,g_npq.*,g_npq.npq01,'','',g_bookno3)
              RETURNING  g_npq.*
         IF l_aag371 MATCHES '[23]' THEN
            #-->for 合并報表-關系人
            SELECT occ02,occ37 INTO l_occ02,l_occ37 FROM occ_file
              WHERE occ01=g_oma.oma03
            IF cl_null(g_npq.npq37) THEN
               IF l_occ37='Y' THEN
                  LET g_npq.npq37=l_occ02 CLIPPED
               END IF
            END IF
         END IF
         IF g_npq.npq07 <> 0 THEN 
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
         END IF
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
            CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npq02,SQLCA.sqlcode,"","ins npq",1)
            LET g_success = 'N'
         END IF
      END IF
      DELETE FROM npq_file 
       WHERE npq01=g_trno 
         AND npq03='-' AND npq00 = 2
         AND npqsys = 'AR' AND npq011 = 1
     #FUN-B40056--add--str--
      DELETE FROM tic_file WHERE tic04 = g_trno
     #FUN-B40056--add--end--
   ###稅結束
 
 
   ###若存在直接收款
   ###借 oob03 = '1' 記錄當前直接收款之總金額
        SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file
         WHERE oob01 = g_oma.oma01 AND oob03='1'
        IF cl_null(l_oob09) THEN LET l_oob09= 0 END IF
        IF cl_null(l_oob10) THEN LET l_oob10= 0 END IF
 
   ###開始
        CALL s_t300_rgl_d()
        CALL s_t300_rgl_c("e",g_bookno3)
        IF l_oob10 != g_oma.oma56t THEN   #匯兌損益
           CALL s_t300_rgl_c("r",g_bookno3)
        END IF
        CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021   
END FUNCTION
 
#TQC-AC0127   add  

# Prog. Version..: '5.30.06-13.04.12(00010)'     #
#
# Pattern name...: s_ins_w.4gl
# Descriptions...: 自動產生直接收款用
# Date & Author..: #FUN-960140 2009/06/23 By lutingting
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0041 09/12/08 By lutingting交款方式為券時交款金額要加上溢收得金額
# Modify.........: No:FUN-9C0014 09/12/09 By shiwuying 改為可從同法人下不同DB抓資料
# Modify.........: No:TQC-9C0057 09/12/09 By Carrier 状况码赋值
# Modify.........: No.FUN-9C0168 10/01/04 By lutingting 款別對應銀行改由axri060抓取,卡種對應科目改由axri050抓取
# Modify.........: No:FUN-A10104 10/01/19 By shiwuying 函數傳參部份修改
# Modify.........: No.FUN-A60052 10/06/17 By lutingting lpx19,lpx20改抓oog02,oog03
# Modify.........: No.FUN-A50102 10/06/22 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A40076 10/07/02 By xiaofeizhu ooa037 = 'N'改為ooa37 = '1'
# Modify.........: No.FUN-A60056 10/07/06 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.MOD-AA0080 10/10/14 By wujie      预设ooblegal的初始值
# Modify.........: No.TQC-AC0155 10/12/15 By suncx ooblegal的值為空，導致向oob插入資料時報錯
# Modify.........: No.TQC-AC0127 10/12/22 By wuxj  新增類型為13的情況,修改储值卡FOREACH的时候的值
# Modify.........: No.FUN-B10058 11/01/25 By lutingting 流通财务改善
# Modify.........: No.TQC-B10270 11/01/27 By yinhy 流通財務拋轉時產生的票據資料nmh41改為'N'，nmh21默認值=axri060支票對應銀行
# Modify.........: NO.FUN-B40011 11/04/11 By guoch  nmh_file add nmh42
# Modify.........: NO.MOD-B60099 11/06/16 By wujie  储值卡应收直接收款应分明细冲
# Modify.........: No.TQC-C20565 12/03/01 By zhangweib 若單身有分攤折價時，則歸入到直接收款轉費用類型
# Modify.........: NO:TQC-C30177 12/03/09 By zhangweib 支票收款將rxy06維護的支票號碼寫到oob14和nmh31
# Modify.........: NO:MOD-C30425 12/03/12 By zhangweib 修改TQC-C30177處理的BUG, 將g_oob修改成l_oob
# Modify.........: No.FUN-C30038 12/03/27 By JinJJ INSERT INTO nmh_file赋值修改.nmh06 = rxy11
# Modify.........: No.FUN-C30296 12/03/27 By xuxz 若出貨單有'收款折讓'rxx02 = '10',這部份金額進入轉費用
# Modify.........: No:FUN-CB0025 12/11/09 By shiwuying 订金冲预收的rxy分摊到其他款别，用rxy33冲预收否来区分
# Modify.........: No:MOD-D40050 13/04/09 By apo 將程式中使用到l_oma的部分改為g_oma

DATABASE ds 
 
GLOBALS "../../config/top.global"
DEFINE g_oma  RECORD LIKE oma_file.*,
       g_ooa  RECORD LIKE ooa_file.*,
       g_oow  RECORD LIKE oow_file.*,
       g_ool  RECORD LIKE ool_file.*,    
       g_nmh  RECORD LIKE nmh_file.*,
       g_nms  RECORD LIKE nms_file.*,
       g_dept        LIKE nmh_file.nmh15,
       g_flag1       LIKE type_file.chr1,
       g_bookno1     LIKE aza_file.aza81,
       g_bookno2     LIKE aza_file.aza82
DEFINE l_dbs         LIKE type_file.chr21        #No.FUN-9C0014 Add
DEFINE g_sql         LIKE type_file.chr1000      #No.FUN-9C0014 Add
DEFINE g_oma01       LIKE oma_file.oma01         #TQC-AC0127  add
 
FUNCTION s_ins_w(p_type,p_no1,p_no2,p_sum_sel,p_plant)   #p_type  11:訂金  #No.FUN-9C0014 Add p_dbs #No.FUN-A10104
                                                 #        12:出貨
                                                 #p_no1   訂單號/出貨單號
                                                 #p_no2   單據號(oma01)
                                                 #p_sum_sel   是否需要匯總直接收款資料  1:需要 0:不需要
                                                 #g_success   成功與否
#DEFINE p_dbs        LIKE type_file.chr21         #No.FUN-9C0014 Add
DEFINE p_plant      LIKE azp_file.azp01          #No.FUN-A10104
DEFINE p_type       LIKE oma_file.oma00 
DEFINE p_no1        LIKE omb_file.omb31
DEFINE p_no2        LIKE oma_file.oma01
DEFINE p_sum_sel    LIKE type_file.chr1
DEFINE p_success    LIKE type_file.chr1
DEFINE l_oma23      LIKE oma_file.oma23
#DEFINE l_ryd05      LIKE ryd_file.ryd05   #FUN-9C0168
DEFINE l_ooe02      LIKE ooe_file.ooe02    #FUN-9C0168
DEFINE l_ooe02_1    LIKE ooe_file.ooe02    #TQC-B10270
DEFINE l_aag05      LIKE aag_file.aag05
DEFINE l_wc         LIKE rxx_file.rxx04
DEFINE l_sel        LIKE type_file.num5
DEFINE l_ac         LIKE type_file.num5
DEFINE l_amt        LIKE oma_file.oma55
DEFINE l_amt1       LIKE oma_file.oma55
DEFINE l_amt2       LIKE oma_file.oma55
DEFINE l_amt3       LIKE oma_file.oma55
DEFINE l_amt4       LIKE oma_file.oma55
DEFINE l_oga213     LIKE oga_file.oga213
DEFINE l_oga211     LIKE oga_file.oga211
DEFINE l_str        LIKE type_file.chr1000
DEFINE l_sql        LIKE type_file.chr1000
DEFINE li_result    LIKE type_file.num5
DEFINE l_rxx RECORD LIKE rxx_file.*
DEFINE l_rxy RECORD LIKE rxy_file.*
DEFINE l_oob RECORD LIKE oob_file.*
DEFINE l_cnt        LIKE type_file.num5
DEFINE l_rxy05      LIKE rxy_file.rxy05
DEFINE l_rxy12      LIKE rxy_file.rxy12
DEFINE l_rxy17      LIKE rxy_file.rxy17
DEFINE l_sql_q      LIKE type_file.chr1000
DEFINE l_sql_k      LIKE type_file.chr1000
DEFINE l_oma01      LIKE oma_file.oma01
DEFINE l_oga03      LIKE oga_file.oga03    #NO.TQC-C20565   Add

   INITIALIZE g_oma.* TO NULL
   INITIALIZE g_ooa.* TO NULL
   INITIALIZE g_oow.* TO NULL
   INITIALIZE g_ool.* TO NULL   
   INITIALIZE g_nmh.* TO NULL
   INITIALIZE g_nms.* TO NULL
   INITIALIZE l_rxx.* TO NULL
   INITIALIZE l_rxy.* TO NULL
   INITIALIZE l_oob.* TO NULL
   WHENEVER ERROR CALL cl_err_msg_log
   SELECT * INTO g_oma.* FROM oma_file WHERE oma01 = p_no2
  #DELETE FROM ooa_file WHERE ooa01 = g_oma.oma01  #No.FUN-9C0014
  #DELETE FROM oob_file WHERE oob01 = g_oma.oma01  #No.FUN-9C0014
   SELECT MAX(oob02)+1 INTO l_ac FROM oob_file WHERE oob01=p_no2
   IF cl_null(l_ac) THEN LET l_ac=1 END IF
   LET l_str = ''
#No.FUN-A10104 -BEGIN-----
#  LET l_dbs = p_dbs        #No.FUN-9C0014 Add
   IF cl_null(p_plant) THEN
      LET l_dbs = ''
   ELSE
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
   END IF
#No.FUN-A10104 -END-------
  #FUN-A60056--mark--str--
  #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
  #IF p_type = '11' THEN
  #   LET l_sql = "SELECT * FROM rxx_file where rxx00 = '01' and rxx01 = '",p_no1,"' and rxx03 = '1'"
  #   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxx_file'),
  #               " WHERE rxx00 = '01' and rxx01 = '",p_no1,"' and rxx03 = '1'"
  #ELSE
  #   LET l_sql = "SELECT * FROM rxx_file where rxx00 = '02' and rxx01 = '",p_no1,"' and rxx03 = '1'"
  #   LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxx_file'),
  #               " WHERE rxx00 = '02' AND rxx01 = '",p_no1,"' AND rxx03 = '1'"
  #END IF
  ##No.FUN-9C0014 BEGIN -----
  #ELSE
  #FUN-A60056--mark--end
#TQC-AC0127  ---begin---
#     IF p_type = '11' THEN
#        #LET l_sql = "SELECT * FROM ",l_dbs CLIPPED,"rxx_file ",
#        LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxx_file'), #FUN-A50102
#                    " WHERE rxx00 = '01' and rxx01 = '",p_no1,"' and rxx03 = '1'"
#     ELSE
#        #LET l_sql = "SELECT * FROM ",l_dbs CLIPPED,"rxx_file ",
#        LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxx_file'), #FUN-A50102
#                    " WHERE rxx00 = '02' and rxx01 = '",p_no1,"' and rxx03 = '1'"
#     END IF
      CASE p_type
         WHEN '11' 
            LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxx_file'),
                        " WHERE rxx00 = '01' and rxx01 = '",p_no1,"' and rxx03 = '1'"
         WHEN '12' 
            LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxx_file'),
                        " WHERE rxx00 = '02' and rxx01 = '",p_no1,"' and rxx03 = '1'"
         WHEN '13'
            LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxx_file'),
                        " WHERE rxx00 = '05' and rxx01 = '",p_no1,"' and rxx03 = '1'"
         #FUN-B10058--add--str--
         WHEN '19'
            LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxx_file'),
                        " WHERE rxx00 = '02' and rxx01 = '",p_no1,"' and rxx03 = '1'"
         #FUN-B10058--add--end
      END CASE
#TQC-AC0127 ---end---
  
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
	  CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102
  #END IF    #FUN-A60056
  #No.FUN-9C0014 END -------
   SELECT * INTO g_oow.* FROM oow_file 
   IF STATUS THEN
      IF g_bgerr THEN
         CALL s_errmsg('','','sel oow','alm-998',1)
      ELSE
         CALL cl_err('','alm-998',1) 
      END IF 
      LET g_success = 'N'
      RETURN g_success
   END IF
   SELECT * INTO g_ool.* FROM ool_file WHERE ool01 = g_oma.oma13    
   PREPARE w_pre1 FROM l_sql
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','pre rxx',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("pre","rxx_file","","",SQLCA.sqlcode,"","",1)
         END IF
         LET g_success = 'N'
      END IF
   DECLARE w_cl1 CURSOR FOR w_pre1
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','dec rxx',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("dec","rxx_file","","",SQLCA.sqlcode,"","",1)
         END IF
         LET g_success = 'N'
      END IF
   FOREACH w_cl1 INTO l_rxx.*
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg('','','for rxx',SQLCA.sqlcode,1)
         ELSE
            CALL cl_err3("for","rxx_file","","",SQLCA.sqlcode,"","",1)
         END IF
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF cl_null(l_rxx.rxx05) THEN LET l_rxx.rxx05 = 0  END IF
      IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
      #SELECT ryd05 INTO l_ryd05 FROM ryd_file WHERE ryd01=l_rxx.rxx02   #FUN-9C0168
      SELECT ooe02 INTO l_ooe02 FROM ooe_file WHERE ooe01=l_rxx.rxx02   #FUN-9C0168      
     #No.FUN-9C0014 BEGIN -----
      ELSE
         #LET g_sql = "SELECT ryd05 FROM ",l_dbs CLIPPED,"ryd_file WHERE ryd01='",l_rxx.rxx02,"'"  #FUN-9C0168
         #LET g_sql = "SELECT ooe02 FROM ",l_dbs CLIPPED,"ooe_file WHERE ooe01='",l_rxx.rxx02,"'"  #FUN-9C0168
         LET g_sql = "SELECT ooe02 FROM ",cl_get_target_table(p_plant,'ooe_file'), #FUN-A50102
                     " WHERE ooe01='",l_rxx.rxx02,"'" 
         CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	     CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102
         PREPARE sel_ryd_pre01 FROM g_sql
         #EXECUTE sel_ryd_pre01 INTO l_ryd05   #FUN-9C0168
         EXECUTE sel_ryd_pre01 INTO l_ooe02   #FUN-9C0168
      END IF
     #No.FUN-9C0014 END -------
      LET l_oob.oob01 = g_oma.oma01
      LET l_oob.oob02 = l_ac
      LET l_oob.oob03 = '1'
      LET l_oob.oob08 = g_oma.oma24
      IF cl_null(l_oob.oob08) THEN
         LET l_oob.oob08 = '1'
      END IF
      LET l_oob.oob13 = g_oma.oma15
      #LET l_oob.oob17 = l_ryd05          #銀行編號   #FUN-9C0168
      LET l_oob.oob17 = l_ooe02          #銀行編號    #FUN-9C0168
      LET l_oob.oob18 = g_oow.oow08
      #LET l_oob.oobplant = g_oma.omaplant   #FUN-960140 mark 090824
      LET l_oob.ooblegal = g_oma.omalegal
      LET l_oob.oob19 = 1
      CASE l_rxx.rxx02
        WHEN '04'    #券交款
           LET l_oob.oob04 = 'Q'
           LET l_oob.oob18 = NULL
        WHEN '05'    #聯盟卡 
           LET l_oob.oob04 = 'E'
           LET l_oob.oob18 = NULL
        WHEN '06'    #儲值卡
           LET l_oob.oob04 = '3'
           LET l_wc = l_rxx.rxx04
           LET l_oob.oob18 = NULL
        WHEN '07'    ##充預收款
           LET l_oob.oob04 = '3'
           LET l_oob.oob18 = NULL
        #FUN-C30296--add--str
        WHEN '10'    ##折让
           LET l_oob.oob04 = 'F'
           LET l_oob.oob18 = NULL
	#FUN-C30296--add--end
        OTHERWISE 
           LET l_oob.oob04 = '2'
     END CASE
     IF l_rxx.rxx02 = '04' THEN    #券交款
        LET l_oob.oob07 = g_aza.aza17
        IF l_oob.oob07 !=g_oma.oma23 THEN
           IF g_bgerr THEN
              CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1)
           ELSE
              CALL cl_err3("","rxx_file",l_oob.oob07,"","axr-144","","",1)
           END IF 
           LET g_success = 'N' 
        END IF
     ELSE
        IF cl_null(l_oob.oob17) THEN
           IF l_rxx.rxx02='02' THEN  #銀聯卡
              IF g_bgerr THEN
                 CALL s_errmsg('rxx02',l_rxx.rxx02,'','axr-075',1)
              ELSE
                 CALL cl_err3("","rxx_file",l_rxx.rxx02,"","axr-075","","",1)
              END IF 
              LET g_success = 'N' 
           END IF 
        ELSE
           SELECT nma05,nma051,nma10 INTO l_oob.oob11,l_oob.oob111,l_oob.oob07 FROM nma_file
             WHERE nma01 = l_oob.oob17
           IF l_oob.oob07 !=g_oma.oma23 THEN
              IF g_bgerr THEN 
                 CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1)
              ELSE
                 CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
              END IF 
              LET g_success = 'N' 
           END IF
           IF g_aza.aza63 = 'N' THEN LET l_oob.oob111 = '' END IF 
        END IF
     END IF
     SELECT azi04 INTO t_azi04 FROM azi_file where azi01=l_oob.oob07
     CASE  
        #FUN-C30296--add--str
        WHEN l_rxx.rxx02 = '10'      #折让
              CASE p_type
                 WHEN '11'
                    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '10' ",
                                 "   AND rxy00 = '01' "
                 WHEN '12'
                    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '10' ",
                                 "   AND rxy33 = 'N' ",  #FUN-CB0025
                                 "   AND rxy00 = '02' "
                 WHEN '13'
                    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '10' ",
                                 "   AND rxy00 = '05' "
                 WHEN '19'
                    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '10' ",
                                 "   AND rxy00 = '02' "

              END CASE
              CALL cl_replace_sqldb(l_sql_q) RETURNING l_sql_q             						
	      CALL cl_parse_qry_sql(l_sql_q,p_plant) RETURNING l_sql_q      
           PREPARE s_q_pb_10 FROM l_sql_q
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('','','pre rxy',SQLCA.sqlcode,1)
                 ELSE
                   CALL cl_err3("pre","rxy_file","","",SQLCA.sqlcode,"","",1)
                 END IF
                 LET g_success = 'N'
              END IF
           DECLARE s_q_cs_10 SCROLL CURSOR FOR s_q_pb_10
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('','','dec rxy',SQLCA.sqlcode,1)
                 ELSE
                   CALL cl_err3("dec","rxy_file","","",SQLCA.sqlcode,"","",1)
                 END IF
                 LET g_success = 'N'
              END IF
           FOREACH s_q_cs_10 INTO l_rxy05,l_rxy12,l_rxy17
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('','','for rxy',SQLCA.sqlcode,1)
                 ELSE
                   CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                 END IF
                 LET g_success = 'N'
              END IF
              IF cl_null(l_rxy17) THEN LET l_rxy17 = 0 END IF
              LET l_oob.oob11 = g_ool.ool34
              LET l_oob.oob111 = g_ool.ool341
              IF g_aza.aza63 = 'N' THEN LET l_oob.oob111 = '' END IF
              IF (cl_null(l_oob.oob11)) 
                 OR (g_aza.aza63 = 'Y' AND cl_null(l_oob.oob111)) THEN    
                 SELECT ool31,ool311 INTO l_oob.oob11,l_oob.oob111 
                  #FROM ool_file WHERE ool01=l_oma.oma13   #MOD-D40050 mark
                   FROM ool_file WHERE ool01=g_oma.oma13   #MOD-D40050 
              END IF  
              LET l_oob.oob02 = l_ac
              LET l_oob.oob06 = g_oma.oma01
              LET l_oob.oob09 =  l_rxy05+l_rxy17   
              CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09                                                                        
              LET l_oob.oob10 = l_oob.oob08 * l_oob.oob09
              CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10                
              LET l_oob.oob22 = l_oob.oob09                                                              
              IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('','','','axr-076',1)
                 ELSE
                    CALL cl_err3("","oob_file","","","axr-076","","",1)
                 END IF 
                 LET g_success = 'N'                                                                                               
              END IF
              IF cl_null(l_oob.oob11) THEN 
                 IF g_bgerr THEN 
                    CALL s_errmsg('','','','axr-076',1) 
                 ELSE
                    CALL cl_err3("","oob_file","","","axr-076","","",1)
                 END IF 
                 LET g_success = 'N'
              END IF
              IF NOT cl_null(l_oob.oob111) THEN
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                              
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                            
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
              ELSE
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                              
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                            
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11
              END IF 
              IF p_sum_sel = '1'  AND l_sel > 0 THEN     #需要匯總直接收款
                 IF NOT cl_null(l_oob.oob111) THEN 
                    UPDATE oob_file set oob09 = oob09 + l_oob.oob09,
                                        oob10 = oob10 + l_oob.oob10,
                                        oob22 = oob22 + l_oob.oob22
                     WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                       AND oob04 = l_oob.oob04                                                                                         
                       AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
                 ELSE
                    UPDATE oob_file set oob09 = oob09 + l_oob.oob09,                                                                
                                        oob10 = oob10 + l_oob.oob10,                                                                
                                        oob22 = oob22 + l_oob.oob22
                     WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                       AND oob04 = l_oob.oob04                                                                                         
                       AND oob11 = l_oob.oob11
                 END IF 
              ELSE
                 LET l_oob.oob17 = NULL
                 IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
                 IF l_oob.oob07 !=g_oma.oma23 THEN
                    IF g_bgerr THEN
                       CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1) 
                    ELSE
                       CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                    END IF 
                    LET g_success = 'N' 
                    RETURN g_success          
                 END IF
    
                 INSERT INTO oob_file VALUES(l_oob.*)
                 IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                    IF g_bgerr THEN 
                       CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1) 
                    ELSE
                       CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                    END IF  
                    LET g_success = 'N' 
                    RETURN g_success   
                 END IF   
                 LET l_ac = l_ac + 1 
              END IF           
           END FOREACH 
        #FUN-C30296--add--end
      WHEN l_rxx.rxx02 = '04'      #券
          #FUN-A60056--mark--str--
          #IF cl_null(l_dbs) THEN   #No.FUN-9C0014 Add
          #IF p_type = '11' THEN
          #   LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM rxy_file ",  
          #                " WHERE rxy01 = '",p_no1,"' ",
          #                "   AND rxy03 = '04' ",
          #                "   AND rxy00 = '01' "
          #ELSE 
          #    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM rxy_file ",  
          #                 " WHERE rxy01 = '",p_no1,"' ",
          #                 "   AND rxy03 = '04' ",
          #                 "   AND rxy00 = '02' "
          #END IF 
          ##No.FUN-9C0014 BEGIN -----
          #ELSE
          #FUN-A60056--mark--end
#TQC-AC0127   ---begin---
#             IF p_type = '11' THEN
#                #LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",l_dbs CLIPPED,"rxy_file ",
#                LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'), #FUN-A50102
#                             " WHERE rxy01 = '",p_no1,"' ",
#                             "   AND rxy03 = '04' ",
#                             "   AND rxy00 = '01' "
#             ELSE
#                #LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",l_dbs CLIPPED,"rxy_file ",
#                LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'), #FUN-A50102
#                             " WHERE rxy01 = '",p_no1,"' ",
#                             "   AND rxy03 = '04' ",
#                             "   AND rxy00 = '02' "
#             END IF
              CASE p_type
                 WHEN '11'
                    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '04' ",
                                 "   AND rxy00 = '01' "
                 WHEN '12'
                    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '04' ",
                                 "   AND rxy33 = 'N' ",  #FUN-CB0025
                                 "   AND rxy00 = '02' "
                 WHEN '13'
                    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '04' ",
                                 "   AND rxy00 = '05' "
                 #FUN-B10158--add-str--
                 WHEN '19'
                    LET l_sql_q= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '04' ",
                                 "   AND rxy00 = '02' "
                    
                 #FUN-B10058--add--end
              END CASE
#TQC-AC0127 ---end---
              CALL cl_replace_sqldb(l_sql_q) RETURNING l_sql_q              #FUN-A50102							
	          CALL cl_parse_qry_sql(l_sql_q,p_plant) RETURNING l_sql_q      #FUN-A50102
          #END IF   #FUN-A60056
        #No.FUN-9C0014 END -------
           PREPARE s_q_pb FROM l_sql_q
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('','','pre rxy',SQLCA.sqlcode,1)
                 ELSE
                   CALL cl_err3("pre","rxy_file","","",SQLCA.sqlcode,"","",1)
                 END IF
                 LET g_success = 'N'
              END IF
           DECLARE s_q_cs SCROLL CURSOR FOR s_q_pb
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('','','dec rxy',SQLCA.sqlcode,1)
                 ELSE
                   CALL cl_err3("dec","rxy_file","","",SQLCA.sqlcode,"","",1)
                 END IF
                 LET g_success = 'N'
              END IF
           FOREACH s_q_cs INTO l_rxy05,l_rxy12,l_rxy17
              IF SQLCA.sqlcode THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('','','for rxy',SQLCA.sqlcode,1)
                 ELSE
                   CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                 END IF
                 LET g_success = 'N'
              END IF
              IF cl_null(l_rxy17) THEN LET l_rxy17 = 0 END IF
              IF cl_null(l_rxy05) THEN LET l_rxy05 = 0 END IF
           #No.FUN-9C0014 BEGIN -----
           #  SELECT lpx19,lpx20 INTO l_oob.oob11,l_oob.oob111 FROM lpx_file
           #   WHERE lpx01 = l_rxy12
             #FUN-A60052--mod--str--
             #IF cl_null(l_dbs) THEN
             #   SELECT lpx19,lpx20 INTO l_oob.oob11,l_oob.oob111 FROM lpx_file
             #    WHERE lpx01 = l_rxy12
             #ELSE
             #   LET g_sql = "SELECT lpx19,lpx20 FROM ",l_dbs CLIPPED,"lpx_file",
             #               " WHERE lpx01 = '",l_rxy12,"'"
              #LET g_sql = "SELECT oog02,oog03 FROM ",l_dbs CLIPPED,"oog_file",
              LET g_sql = "SELECT oog02,oog03 FROM ",cl_get_target_table(p_plant,'oog_file'), #FUN-A50102
                          " WHERE oog01 = '",l_rxy12,"'"
             #FUN-A60052--mod--end
                 CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	             CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102
                 PREPARE sel_lpx_pre02 FROM g_sql
                 EXECUTE sel_lpx_pre02 INTO l_oob.oob11,l_oob.oob111
             #END IF   #FUN-A60052
           #No.FUN-9C0014 END -------
              IF g_aza.aza63 = 'N' THEN LET l_oob.oob111 = '' END IF
              IF (cl_null(l_oob.oob11)) 
                 OR (g_aza.aza63 = 'Y' AND cl_null(l_oob.oob111)) THEN     #券種沒有抓到科目
                 SELECT ool31,ool311 INTO l_oob.oob11,l_oob.oob111 
                  #FROM ool_file WHERE ool01=l_oma.oma13   #MOD-D40050 mark
                   FROM ool_file WHERE ool01=g_oma.oma13   #MOD-D40050 
              END IF  
              LET l_oob.oob02 = l_ac
              LET l_oob.oob06 = g_oma.oma01
              #LET l_oob.oob09 =  l_rxy05 #FUN-9C0041
              LET l_oob.oob09 =  l_rxy05+l_rxy17    #FUN-9C0041
              CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09                                                                        
              LET l_oob.oob10 = l_oob.oob08 * l_oob.oob09
              CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10                
              LET l_oob.oob22 = l_oob.oob09                                                              
              IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                 IF g_bgerr THEN
                    CALL s_errmsg('','','','axr-076',1)
                 ELSE
                    CALL cl_err3("","oob_file","","","axr-076","","",1)
                 END IF 
                 LET g_success = 'N'                                                                                               
              END IF
              IF cl_null(l_oob.oob11) THEN 
                 IF g_bgerr THEN 
                    CALL s_errmsg('','','','axr-076',1) 
                 ELSE
                    CALL cl_err3("","oob_file","","","axr-076","","",1)
                 END IF 
                 LET g_success = 'N'
              END IF
              IF NOT cl_null(l_oob.oob111) THEN
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                              
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                            
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
              ELSE
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                              
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                            
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11
              END IF 
              IF p_sum_sel = '1'  AND l_sel > 0 THEN     #需要匯總直接收款
                 IF NOT cl_null(l_oob.oob111) THEN 
                    UPDATE oob_file set oob09 = oob09 + l_oob.oob09,
                                        oob10 = oob10 + l_oob.oob10,
                                        oob22 = oob22 + l_oob.oob22
                     WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                       AND oob04 = l_oob.oob04                                                                                         
                       AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
                 ELSE
                    UPDATE oob_file set oob09 = oob09 + l_oob.oob09,                                                                
                                        oob10 = oob10 + l_oob.oob10,                                                                
                                        oob22 = oob22 + l_oob.oob22
                     WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                       AND oob04 = l_oob.oob04                                                                                         
                       AND oob11 = l_oob.oob11
                 END IF 
              ELSE
                 LET l_oob.oob17 = NULL
                #此段在上面有檢查過,應該不需要了
                #IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                #   IF g_bgerr THEN
                #      CALL s_errmsg('','','','axr-076',1)
                #   ELSE
                #      CALL cl_err('','axr-076',1)
                #   END IF 
                #   LET g_success = 'N'           
                #   RETURN g_success             
                #END IF                         
                #IF cl_null(l_oob.oob11) THEN 
                #   IF g_bgerr THEN 
                #      CALL s_errmsg('','','','axr-076',1)
                #   ELSE
                #      CALL cl_err('','axr-076',1)
                #   END IF 
                #   LET g_success = 'N'       
                #   RETURN g_success         
                #END IF              
                 IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
                 IF l_oob.oob07 !=g_oma.oma23 THEN
                    IF g_bgerr THEN
                       CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1) 
                    ELSE
                       CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                    END IF 
                    LET g_success = 'N' 
                    RETURN g_success          
                 END IF
    
                 INSERT INTO oob_file VALUES(l_oob.*)
                 IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                    IF g_bgerr THEN 
                       CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1) 
                    ELSE
                       CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                    END IF  
                    LET g_success = 'N' 
                    RETURN g_success   
                 END IF   
                 LET l_ac = l_ac + 1 
              END IF           
           END FOREACH 
      WHEN l_rxx.rxx02 = '05'      #聯盟卡
         IF cl_null(l_oob.oob17) THEN              #根據卡中抓科目
           #FUN-A60056--mark--str--
           #IF cl_null(l_dbs) THEN      #No.FUN-9C0014 Add
           #IF p_type = '11' THEN
           #   LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM rxy_file ", 
           #                " WHERE rxy01 = '",p_no1,"' ", 
           #                "   AND rxy03 = '05' ",
           #                "   AND rxy00 = '01' "
           #ELSE 
           #   LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM rxy_file ", 
           #                " WHERE rxy01 = '",p_no1,"' ", 
           #                "   AND rxy03 = '05' ",
           #                "   AND rxy00 = '02' "
           #END IF             	 
           #No.FUN-9C0014 BEGIN -----
           #ELSE
           #FUN-A60056--mark--end
#TQC-AC0127   ---begin----
#              IF p_type = '11' THEN
#                 #LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM ",l_dbs CLIPPED,"rxy_file ",
#                 LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'), #FUN-A50102
#                              " WHERE rxy01 = '",p_no1,"' ",
#                              "   AND rxy03 = '05' ",
#                              "   AND rxy00 = '01' "
#              ELSE
#                 #LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM ",l_dbs CLIPPED,"rxy_file ",
#                 LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'), #FUN-A50102
#                              " WHERE rxy01 = '",p_no1,"' ",
#                              "   AND rxy03 = '05' ",
#                              "   AND rxy00 = '02' "
#              END IF
               CASE p_type
                  WHEN '11'
                     LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                  " WHERE rxy01 = '",p_no1,"' ",
                                  "   AND rxy03 = '05' ",
                                  "   AND rxy00 = '01' "
                  WHEN '12'
                     LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                  " WHERE rxy01 = '",p_no1,"' ",
                                  "   AND rxy03 = '05' ",
                                  "   AND rxy33 = 'N' ",  #FUN-CB0025
                                  "   AND rxy00 = '02' "
                  WHEN '13'
                     LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                  " WHERE rxy01 = '",p_no1,"' ",
                                  "   AND rxy03 = '05' ",
                                  "   AND rxy00 = '05' "
                 #FUN-B10158--add-str--
                 WHEN '19'
                    LET l_sql_k= "SELECT rxy05,rxy12,rxy17 FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                 " WHERE rxy01 = '",p_no1,"' ",
                                 "   AND rxy03 = '05' ",
                                 "   AND rxy00 = '02' "
                 #FUN-B10058--add--end
               END CASE
#TQC-AC0127   ---END---
               CALL cl_replace_sqldb(l_sql_k) RETURNING l_sql_k              #FUN-A50102							
	           CALL cl_parse_qry_sql(l_sql_k,p_plant) RETURNING l_sql_k      #FUN-A50102
           #END IF   #FUN-A60056
         #No.FUN-9C0014 END -------
            PREPARE s_k_pb FROM l_sql_k
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','for rxy',SQLCA.sqlcode,1)
                  ELSE
                    CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_success = 'N'
               END IF
            DECLARE s_k_cs SCROLL CURSOR FOR s_k_pb
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','for rxy',SQLCA.sqlcode,1)
                  ELSE
                    CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_success = 'N'
               END IF
            FOREACH s_k_cs INTO l_rxy05,l_rxy12,l_rxy17
               IF SQLCA.sqlcode THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','for rxy',SQLCA.sqlcode,1)
                  ELSE
                    CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                  END IF
                  LET g_success = 'N'
               END IF
               IF cl_null(l_rxy17) THEN LET l_rxy17 = 0 END IF
               IF cl_null(l_rxy05) THEN LET l_rxy05 = 0 END IF
            #No.FUN-9C0014 BEGIN -----
            #  SELECT rxw04,rxw05 INTO l_oob.oob11,l_oob.oob111 FROM rxw_file
            #   WHERE rxw01 = l_rxy12
               IF cl_null(l_dbs) THEN
                 #FUN-9C0168--mod--str--
                 #SELECT rxw04,rxw05 INTO l_oob.oob11,l_oob.oob111 FROM rxw_file
                 # WHERE rxw01 = l_rxy12
                  SELECT ood02,ood03 INTO l_oob.oob11,l_oob.oob111 FROM ood_file
                   WHERE ood01 = l_rxy12
                 #FUN-9C0168--mod--end
               ELSE
                 #FUN-9C0168--mod--str--
                 #LET g_sql = "SELECT rxw04,rxw05 FROM ",l_dbs CLIPPED,"rxw_file ",
                 #            " WHERE rxw01 = '",l_rxy12,"'"
                 #PREPARE sel_rxw_pre03 FROM g_sql
                 #EXECUTE sel_rxw_pre03 INTO l_oob.oob11,l_oob.oob111
                  #LET g_sql = "SELECT ood02,ood03 FROM ",l_dbs CLIPPED,"ood_file ",
                  LET g_sql = "SELECT ood02,ood03 FROM ",cl_get_target_table(p_plant,'ood_file'), #FUN-A50102
                              " WHERE ood01 = '",l_rxy12,"'"
                  CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
	              CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102            
                  PREPARE sel_ood_pre03 FROM g_sql
                  EXECUTE sel_ood_pre03 INTO l_oob.oob11,l_oob.oob111
                 #FUN-9C0168--mod--end
               END IF
            #No.FUN-9C0014 END -------
               IF g_aza.aza63 = 'N' THEN LET l_oob.oob111 = '' END IF
               LET l_oob.oob02 = l_ac
               LET l_oob.oob06 = g_oma.oma01
               LET l_oob.oob09 =  l_rxy05  
               CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09                                                                        
               LET l_oob.oob10 = l_oob.oob08 * l_oob.oob09
               CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10
               LET l_oob.oob22 = l_rxy05
               IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('','','','axr-076',1)
                  ELSE
                     CALL cl_err3("","oob_file","","","axr-076","","",1)
                  END IF 
                  LET g_success = 'N'                                                                                               
               END IF
               IF cl_null(l_oob.oob11) THEN  
                  IF g_bgerr THEN
                     CALL s_errmsg('','','','axr-076',1) 
                  ELSE
                     CALL cl_err3("","oob_file","","","axr-076","","",1)
                  END IF 
                  LET g_success = 'N'
               END IF 
               IF NOT cl_null(l_oob.oob111) THEN                                                                                     
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111                                                               
               ELSE                                                                                                                  
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11  
               END IF 
               IF p_sum_sel = '1'  AND l_sel > 0 THEN     #需要匯總直接收款
                  IF NOT cl_null(l_oob.oob111) THEN
                     UPDATE oob_file set oob09 = oob09 + l_oob.oob09,
                                         oob10 = oob10 + l_oob.oob10,
                                         oob22 = oob22 + l_oob.oob22
                      WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                        AND oob04 = l_oob.oob04                                                                                         
                        AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
                  ELSE
                     UPDATE oob_file set oob09 = oob09 + l_oob.oob09,                                                               
                                         oob10 = oob10 + l_oob.oob10,                                                               
                                         oob22 = oob22 + l_oob.oob22
                      WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                        AND oob04 = l_oob.oob04                                                                                         
                        AND oob11 = l_oob.oob11
                  END IF 
               ELSE
                  LET l_oob.oob17 = NULL
                  #IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                  #   IF g_bgerr THEN
                  #      CALL s_errmsg('','','','axr-076',1) 
                  #   ELSE
                  #      CALL cl_err3("","oob_file","","","axr-076","","",1)
                  #   END IF 
                  #   LET g_success = 'N'           
                  #   RETURN g_success             
                  #END IF                         
                  #IF cl_null(l_oob.oob11) THEN 
                  #   IF g_bgerr THEN 
                  #      CALL s_errmsg('','','','axr-076',1)
                  #   ELSE
                  #      CALL cl_err('','axr-076',1)
                  #   END IF 
                  #   LET g_success = 'N'       
                  #   RETURN g_success         
                  #END IF              
                  IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
                  IF l_oob.oob07 !=g_oma.oma23 THEN
                     IF g_bgerr THEN
                        CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1)
                     ELSE
                        CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                     END IF  
                     LET g_success = 'N' 
                     RETURN g_success          
                  END IF
                  INSERT INTO oob_file VALUES(l_oob.*)
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                     IF g_bgerr THEN
                        CALL s_errmsg('oob01','l_oob.oob01','ins oob_file',SQLCA.sqlcode,1) 
                     ELSE
                        CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                     END IF 
                     LET g_success = 'N' 
                     RETURN g_success   
                  END IF   
                  LET l_ac = l_ac + 1 
                END IF             
            END FOREACH
         ELSE
            SELECT nma05,nma051,nma10 INTO l_oob.oob11,l_oob.oob111,l_oob.oob07
              FROM nma_file
             WHERE nma01 = l_oob.oob17 
            IF l_oob.oob07 !=g_oma.oma23 THEN 
               IF g_bgerr THEN
                  CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1) 
               ELSE
                  CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
               END IF 
               LET g_success = 'N' 
               RETURN g_success          
            END IF
            IF g_aza.aza63 = 'N' THEN LET l_oob.oob111 = '' END IF 
            LET l_oob.oob02 = l_ac
            LET l_oob.oob06 = g_oma.oma01
            LET l_oob.oob09 = l_rxx.rxx04 
            CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09   
            LET l_oob.oob22 = l_rxx.rxx04                                                                     
            LET l_oob.oob10 = l_oob.oob08 * l_oob.oob09
            CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10                                                                        
            IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
               IF g_bgerr THEN
                  CALL s_errmsg('','','','axr-076',1)           
               ELSE
                  CALL cl_err3("","oob_file","","","axr-076","","",1)
               END IF                                                                      
               LET g_success = 'N'                                                                                               
            END IF
            IF cl_null(l_oob.oob11) THEN   
               IF g_bgerr THEN
                  CALL s_errmsg('','','','axr-076',1) 
               ELSE 
                  CALL cl_err3("","oob_file","","","axr-076","","",1)
               END IF 
               LET g_success = 'N'
            END IF  
            IF NOT cl_null(l_oob.oob111) THEN                                                                                     
               SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                  AND oob04 = l_oob.oob04 
                  AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111                                                               
            ELSE                                                                                                                  
               SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                  AND oob04 = l_oob.oob04 
                  AND oob11 = l_oob.oob11                                                                                         
            END IF 
            IF p_sum_sel = '1'  AND l_sel > 0 THEN     #需要匯總直接收款
               IF NOT cl_null(l_oob.oob111) THEN 
                  UPDATE oob_file set oob09 = oob09 + l_oob.oob09,
                                      oob10 = oob10 + l_oob.oob10,
                                      oob22 = oob22 + l_oob.oob22
                   WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                           
                     AND oob04 = l_oob.oob04                                                                                           
                     AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
               ELSE
                  UPDATE oob_file set oob09 = oob09 + l_oob.oob09,                                                                  
                                      oob10 = oob10 + l_oob.oob10,                                                                  
                                      oob22 = oob22 + l_oob.oob22
                   WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                           
                     AND oob04 = l_oob.oob04                                                                                           
                     AND oob11 = l_oob.oob11
               END IF 
            ELSE
               LET l_oob.oob17 = NULL
              #IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
              #   IF g_bgerr THEN 
              #      CALL s_errmsg('','','','axr-076',1)
              #   ELSE
              #      CALL cl_err('','axr-076',1)
              #   END IF 
              #   LET g_success = 'N'           
              #   RETURN g_success             
              #END IF                         
              #IF cl_null(l_oob.oob11) THEN 
              #   IF g_bgerr THEN  
              #      CALL s_errmsg('','','','axr-076',1)
              #   ELSE
              #      CALL cl_err('','axr-076',1)
              #   END IF 
              #   LET g_success = 'N'       
              #   RETURN g_success         
              #END IF              
               IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
               IF l_oob.oob07 !=g_oma.oma23 THEN
                  IF g_bgerr THEN 
                     CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1)
                  ELSE
                     CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                  END IF   
                  LET g_success = 'N' 
                  RETURN g_success          
               END IF
               INSERT INTO oob_file VALUES(l_oob.*)
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN 
                  IF g_bgerr THEN
                     CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file','SQLCA.sqlcode',1) 
                  ELSE
                     CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                  END IF 
                  LET g_success = 'N' 
                  RETURN g_success   
               END IF   
               LET l_ac = l_ac + 1 
            END IF
            CONTINUE FOREACH
        END IF
       WHEN  l_rxx.rxx02 = '06'      #儲值卡交款
          LET l_sql = "SELECT oma01,oma54t-oma55 FROM oma_file ",
                      "WHERE oma03='MISCCARD' AND oma00='26' AND (oma54t - oma55 > 0) ORDER BY oma02 "
          PREPARE w_pre2 FROM l_sql
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','pre oma',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("pre","oma_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
             END IF
          DECLARE w_cl2 CURSOR FOR w_pre2
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','dec oma',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("dec","oma_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
             END IF
         #FOREACH w_cl2 INTO g_oma.oma01,l_amt   #TQC-AC0127  mark
          FOREACH w_cl2 INTO g_oma01,l_amt       #TQC-AC0127  add 
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','for oma',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("for","oma_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
             END IF
             #CALL s_up_money(g_oma.oma01) RETURNING l_amt1    #已衝金額
             LET l_amt1 = 0
             LET l_amt = l_amt - l_amt1   ##減去未審核的金額
             IF l_amt < 0 THEN CONTINUE FOREACH END IF
             IF l_wc <= 0 THEN EXIT FOREACH END IF
             IF l_wc >= l_amt THEN 
                LET l_wc = l_wc - l_amt
               #LET l_oob.oob06 = g_oma.oma01   #TQC-AC0127  MARK
                LET l_oob.oob06 = g_oma01       #TQC-AC0127  add 
                LET l_oob.oob09 = l_amt
                LET l_oob.oob02 = l_ac
                IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
                CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09 
                LET l_oob.oob10 = l_oob.oob08*l_oob.oob09
                IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF
                CALL cl_digcut(l_oob.oob09,g_azi04) RETURNING l_oob.oob09 
                LET l_oob.oob22 = l_oob.oob09
                IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('','','','axr-076',1)           
                   ELSE
                      CALL cl_err3("","oob_file","","","axr-076","","",1)
                   END IF                                                                      
                   LET g_success = 'N'                                                                                               
                END IF
                IF cl_null(l_oob.oob11) THEN   
                   IF g_bgerr THEN
                      CALL s_errmsg('','','','axr-076',1) 
                   ELSE 
                      CALL cl_err3("","oob_file","","","axr-076","","",1)
                   END IF 
                   LET g_success = 'N'
                END IF  
                IF NOT cl_null(l_oob.oob111) THEN                                                                                     
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111                                                               
                ELSE                                                                                                                  
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11                                                                                         
                END IF
#No.MOD-B60099 --begin
#               IF p_sum_sel = '1'  AND l_sel > 0 THEN     #需要匯總直接收款
#                  IF NOT cl_null(l_oob.oob111) THEN
#                     UPDATE oob_file set oob09 = oob09 + l_oob.oob09,
#                                         oob10 = oob10 + l_oob.oob10,
#                                         oob22 = oob22 + l_oob.oob22
#                      WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
#                        AND oob04 = l_oob.oob04                                                                                         
#                        AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
#                  ELSE
#                     UPDATE oob_file set oob09 = oob09 + l_oob.oob09,                                                              
#                                         oob10 = oob10 + l_oob.oob10,                                                              
#                                         oob22 = oob22 + l_oob.oob22
#                      WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
#                        AND oob04 = l_oob.oob04                                                                                         
#                        AND oob11 = l_oob.oob11
#                  END IF 
#               ELSE
#No.MOD-B60099 --end
                   LET l_oob.oob17 = NULL
                #  IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                #     IF g_bgerr THEN
                #        CALL s_errmsg('','','','axr-076',1)     
                #     ELSE
                #        CALL cl_err('','axr-076',1)
                #     END IF        
                #     LET g_success = 'N'           
                #     RETURN g_success             
                #  END IF                         
                #  IF cl_null(l_oob.oob11) THEN 
                #     IF g_bgerr THEN 
                #        CALL s_errmsg('','','','axr-076',1)
                #     ELSE
                #        CALL cl_err('','axr-076',1)
                #     END IF 
                #     LET g_success = 'N'       
                #     RETURN g_success         
                #  END IF              
                   IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
                   IF l_oob.oob07 !=g_oma.oma23 THEN
                      IF g_bgerr THEN
                         CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1)
                      ELSE
                         CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                      END IF   
                      LET g_success = 'N' 
                      RETURN g_success          
                   END IF
                   INSERT INTO oob_file VALUES(l_oob.*)
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                      IF g_bgerr THEN
                         CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                      ELSE 
                         CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                      END IF  
                      LET g_success = 'N' 
                      RETURN g_success   
                   END IF   
                   LET l_ac = l_ac + 1 
#               END IF   #No.MOD-B60099
                CONTINUE FOREACH
             ELSE
              # LET l_oob.oob06 = g_oma.oma01     #TQC-AC0127  mark 
                LET l_oob.oob06 = g_oma01         #TQC-AC0127  add
                LET l_oob.oob02 = l_ac            #No.MOD-B60099
                LET l_oob.oob09 = l_wc	
                IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
                CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09 
                LET l_wc = 0	
                LET l_oob.oob10 = l_oob.oob08*l_oob.oob09	
                IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF
                CALL cl_digcut(l_oob.oob09,g_azi04) RETURNING l_oob.oob09 
                LET l_oob.oob22 = l_oob.oob09
                IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('','','','axr-076',1)           
                   ELSE
                      CALL cl_err3("","oob_file","","","axr-076","","",1)
                   END IF                                                                      
                   LET g_success = 'N'                                                                                               
                END IF
                IF cl_null(l_oob.oob11) THEN   
                   IF g_bgerr THEN
                      CALL s_errmsg('','','','axr-076',1) 
                   ELSE 
                      CALL cl_err3("","oob_file","","","axr-076","","",1)
                   END IF 
                   LET g_success = 'N'
                END IF  
                IF NOT cl_null(l_oob.oob111) THEN                                                                                     
                   SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                    WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                      AND oob04 = l_oob.oob04 
                      AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111                                                               
                ELSE                                                                                                                  
                   SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                    WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                      AND oob04 = l_oob.oob04 
                      AND oob11 = l_oob.oob11                                                                                         
                END IF
#No.MOD-B60099 --begin
#               IF p_sum_sel = '1'  AND l_sel > 0 THEN     #需要匯總直接收款
#                  IF NOT cl_null(l_oob.oob111) THEN
#                     UPDATE oob_file set oob09 = oob09 + l_oob.oob09,
#                                         oob10 = oob10 + l_oob.oob10,
#                                         oob22 = oob22 + l_oob.oob22 
#                      WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                       
#                        AND oob04 = l_oob.oob04                                                                                       
#                        AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
#                  ELSE
#                     UPDATE oob_file set oob09 = oob09 + l_oob.oob09,                                                              
#                                         oob10 = oob10 + l_oob.oob10,                                                              
#                                         oob22 = oob22 + l_oob.oob22 
#                      WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                       
#                        AND oob04 = l_oob.oob04                                                                                       
#                        AND oob11 = l_oob.oob11
#                  END IF 
#               ELSE
#No.MOD-B60099 --end
                   LET l_oob.oob17 = NULL
                #  IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                #     IF g_bgerr THEN
                #        CALL s_errmsg('','','','axr-076',1)
                #     ELSE
                #        CALL cl_err('','axr-076',1)
                #     END IF 
                #     LET g_success = 'N'           
                #     RETURN g_success             
                #  END IF                         
                #  IF cl_null(l_oob.oob11) THEN
                #     IF g_bgerr THEN 
                #        CALL s_errmsg('','','','axr-076',1) 
                #     ELSE
                #        CALL cl_err('','axr-076',1)
                #     END IF 
                #     LET g_success = 'N'       
                #     RETURN g_success         
                #  END IF              
                   IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
                   IF l_oob.oob07 !=g_oma.oma23 THEN
                      IF g_bgerr THEN 
                         CALL s_errmsg('oob07',l_oob.oob07,'axr-144','',1)
                      ELSE
                         CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                      END IF 
                      LET g_success = 'N' 
                      RETURN g_success          
                   END IF
                   INSERT INTO oob_file VALUES(l_oob.*)
                   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                      IF g_bgerr THEN 
                         CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                      ELSE 
                         CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                      END IF  
                      LET g_success = 'N' 
                      RETURN g_success   
                   END IF   
	           LET l_ac = l_ac + 1 
#               END IF #No.MOD-B60099
                CONTINUE FOREACH	
             END IF	  
          END FOREACH
          IF l_wc > 0 THEN 
             IF g_bgerr THEN 
                CALL s_errmsg('',l_wc,'','alm-260',1)
             ELSE 
                CALL cl_err3("","oma_file",l_wc,"","alm-260","","",1)
             END IF  
             LET g_success = 'N' 
             RETURN g_success   
          END IF   
 
       WHEN l_rxx.rxx02 = '07' #充預收 出貨時		
         #FUN-A60056--mark--str--
         #IF cl_null(l_dbs) THEN    #No.FUN-9C0014
         #LET l_sql = "SELECT * FROM rxy_file ",
         #            "WHERE rxy00 = '02' and rxy01 = '",p_no1,"' ",
         #            "AND rxy03 = '07' AND rxy04 = '1' AND rxy05 > 0"		
         ##No.FUN-9C0014 BEGIN -----
         #ELSE
         #FUN-A60056--mark--end 
             #LET l_sql = "SELECT * FROM ",l_dbs CLIPPED,"rxy_file ",
             LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxy_file'), #FUN-A50102
                         " WHERE rxy00 = '02' and rxy01 = '",p_no1,"' ",
                        #FUN-CB0025 Begin---
                        #"   AND rxy03 = '07' AND rxy04 = '1' AND rxy05 > 0"
                         "   AND (rxy03 = '07' OR rxy33 = 'Y') ",
                         "   AND rxy04 = '1' AND rxy05 > 0"
                        #FUN-CB0025 End-----
             CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
             CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102              
         #END IF   #FUN-A60056
       #No.FUN-9C0014 END -------
          PREPARE w_pre3 FROM l_sql
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','pre rxy',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
             END IF
          DECLARE w_cl3 CURSOR FOR w_pre3
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','dec rxy',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("dec","rxy_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
             END IF
          FOREACH w_cl3 INTO l_rxy.*		
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','for rxy',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
                EXIT FOREACH
             END IF
             IF l_rxy.rxy19 = '1' THEN
                #SELECT oma23,oma01,oma54t - oma55 INTO l_oma23,g_oma.oma01,l_amt 
                SELECT oma23,oma01,oma54t - oma55 INTO l_oma23,l_oma01,l_amt    #FUN-960140 090915
                  FROM oma_file 
                 WHERE oma00 = '23' 
                   AND oma16 = l_rxy.rxy06
                   AND oma54t -oma55 >0		
                IF status = 100 THEN 
                   LET l_str=l_str,' ',l_rxy.rxy06
                END IF 		
             ELSE
                #SELECT oma23,oma01,oma54t-oma55 INTO l_oma23,g_oma.oma01,l_amt 
                SELECT oma23,oma01,oma54t-oma55 INTO l_oma23,l_oma01,l_amt   #FUN-960140 090915
                  FROM oma_file 
                 WHERE oma00 = '24' AND oma54t-oma55 >0 AND oma01 = l_rxy.rxy06 
                IF STATUS THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('rxy01',l_rxy.rxy01,'',STATUS,1) 
                   ELSE
                      CALL cl_err3("","rxy_file",l_rxy.rxy01,"",STATUS,"","",1)
                   END IF 
                   LET g_success = 'N'
                   RETURN g_success
                END IF
             END IF	
 
             LET l_oob.oob07 = l_oma23         # 充預收時幣別根據預收款單帶  
             IF l_oob.oob07 !=g_oma.oma23 THEN
                IF g_bgerr THEN
                   CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1) 
                ELSE
                   CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                END IF 
                LET g_success = 'N' 
                RETURN g_success          
             END IF
             #科目根據ool21
             SELECT ool21,ool211 INTO l_oob.oob11,l_oob.oob111
               FROM ool_file WHERE ool01 = g_oma.oma13
             IF g_aza.aza63 = 'N' THEN LET l_oob.oob111 = '' END IF  
             #CALL s_up_money(g_oma.oma01) RETURNING l_amt1    #已衝金額		
             #CALL s_up_money(l_oma01) RETURNING l_amt1    #已衝金額  #FUN-960140 090915
             LET l_amt1 = 0
             LET l_amt = l_amt - l_amt1   ##減去未審核的金額	
             IF l_amt <0 THEN
                IF g_bgerr THEN 
                   CALL s_errmsg('','','','axr-043',1)
                ELSE
                   CALL cl_err3("","oma_file",l_amt,"","axr-043","","",1)
                END IF 
                LET g_success = 'N'
                RETURN g_success
             END IF 		
             #LET l_oob.oob06 = g_oma.oma01	
             LET l_oob.oob06 = l_oma01  #FUN-960140 090915 
             LET l_oob.oob02 = l_ac
             LET l_oob.oob09 = l_rxy.rxy05	
             IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
             CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09 
             LET l_oob.oob10 = l_oob.oob08*l_oob.oob09	
             IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF
             CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10 
             LET l_oob.oob22 = l_oob.oob09
             IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','','axr-076',1)           
                ELSE
                   CALL cl_err3("","oob_file","","","axr-076","","",1)
                END IF                                                                      
                LET g_success = 'N'                                                                                               
             END IF
             IF cl_null(l_oob.oob11) THEN   
                IF g_bgerr THEN
                   CALL s_errmsg('','','','axr-076',1) 
                ELSE 
                   CALL cl_err3("","oob_file","","","axr-076","","",1)
                END IF 
                LET g_success = 'N'
             END IF  
             IF NOT cl_null(l_oob.oob111) THEN
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111                                                               
             ELSE                                                                                                                  
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11                                                                                         
             END IF	
             IF p_sum_sel = '1'  AND l_sel > 0 THEN     #需要匯總直接收款
                IF NOT cl_null(l_oob.oob111) THEN   
                   UPDATE oob_file SET oob09 = oob09 + l_oob.oob09,
                                       oob10 = oob10 + l_oob.oob10,
                                       oob22 = oob22 + l_oob.oob22 
                    WHERE oob01 = g_oma.oma01 
                      AND oob03 = '1' 
                      AND oob04 = l_oob.oob04 
                      AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
                ELSE
                   UPDATE oob_file SET oob09 = oob09 + l_oob.oob09,                                                                 
                                       oob10 = oob10 + l_oob.oob10,                                                                 
                                       oob22 = oob22 + l_oob.oob22
                    WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                      AND oob04 = l_oob.oob04                                                                                         
                      AND oob11 = l_oob.oob11
                END IF 
             ELSE
                LET l_oob.oob17 = NULL
             #  IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
             #     IF g_bgerr THEN
             #        CALL s_errmsg('','','','axr-076',1)
             #     ELSE
             #        CALL cl_err('','axr-076',1)
             #     END IF 
             #     LET g_success = 'N' 
             #     RETURN g_success
             #  END IF
             #  IF cl_null(l_oob.oob11) THEN
             #     IF g_bgerr THEN
             #        CALL s_errmsg('','','','axr-076',1)
             #     ELSE
             #        CALL cl_err('','axr-076',1)
             #     END IF 
             #     LET g_success = 'N'
             #     RETURN g_success
             #  END IF
                LET l_oob.oob02 = l_ac  
                IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF
                IF l_oob.oob07 !=g_oma.oma23 THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1)
                   ELSE
                      CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                   END IF  
                   LET g_success = 'N' 
                   RETURN g_success          
                END IF
                INSERT INTO oob_file VALUES(l_oob.*)
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                   END IF 
                   LET g_success = 'N'
                   RETURN g_success
                END IF  
                LET l_ac = l_ac + 1 
             END IF
          END FOREACH	
          WHEN l_rxx.rxx02 = '03'     #支票	
            #FUN-A60056--mark--str--
            #IF cl_null(l_dbs) THEN   #No.FUN-9C0014
            #IF p_type = '11' THEN 
            #   LET l_sql = "SELECT * FROM rxy_file ",
            #               "WHERE rxy01 = '",p_no1,"' AND rxy00 = '01' ",
            #               "AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"	
            #ELSE 
            #   LET l_sql = "SELECT * FROM rxy_file ",
            #               "WHERE rxy01 = '",p_no1,"' AND rxy00 = '02' ",
            #               "AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0" 
            #END IF	
            ##No.FUN-9C0014 BEGIN -----
            #ELSE
            #FUN-A60056--mark--end
#TQC-AC0127   ---begin----
#               IF p_type = '11' THEN
#                  #LET l_sql = "SELECT * FROM ",l_dbs CLIPPED,"rxy_file ",
#                  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxy_file'), #FUN-A50102
#                              " WHERE rxy01 = '",p_no1,"' AND rxy00 = '01' ",
#                              "   AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
#               ELSE
#                  #LET l_sql = "SELECT * FROM ",l_dbs CLIPPED,"rxy_file ",
#                  LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxy_file'), #FUN-A50102
#                              " WHERE rxy01 = '",p_no1,"' AND rxy00 = '02' ",
#                              "   AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
#               END IF
                CASE p_type
                   WHEN '11' 
                      LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                  " WHERE rxy01 = '",p_no1,"' AND rxy00 = '01' ",
                                  "   AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
                   WHEN '12'
                      LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                  " WHERE rxy01 = '",p_no1,"' AND rxy00 = '02' ",
                                  "   AND rxy33 = 'N' ",  #FUN-CB0025
                                  "   AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
                   WHEN '13'
                      LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                  " WHERE rxy01 = '",p_no1,"' AND rxy00 = '05' ",
                                  "   AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
                   #FUN-B10058--add--str--
                   WHEN '19'
                      LET l_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'rxy_file'),
                                  " WHERE rxy01 = '",p_no1,"' AND rxy00 = '02' ",
                                  "   AND rxy03 = '03' AND rxy04 = '1' AND rxy05 > 0"
                   #FUN-B10058--add--end
                END CASE
#TQC-AC0127   ---end----
                CALL cl_replace_sqldb(l_sql) RETURNING l_sql              #FUN-A50102							
                CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql      #FUN-A50102 
            #END IF    #FUN-A60056
          #No.FUN-9C0014 END -------
             PREPARE w_pre4 FROM l_sql
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','pre rxy',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
             END IF
             DECLARE w_cs4 CURSOR FOR w_pre4
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','dec rxy',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("dec","rxy_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
             END IF
             FOREACH w_cs4 INTO l_rxy.*
             IF SQLCA.sqlcode THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','for rxy',SQLCA.sqlcode,1)
                ELSE
                  CALL cl_err3("for","rxy_file","","",SQLCA.sqlcode,"","",1)
                END IF
                LET g_success = 'N'
             END IF
      ###產生anmt200的資料
                IF cl_null(g_oow.oow22) THEN
                   IF g_bgerr THEN 
                      CALL s_errmsg('oow22','','sel oow22','axr-149',1)
                   ELSE
                      CALL cl_err3("sel","oow_file","","","axr-149","","",1)
                   END IF 
                   LET g_success = 'N'
                   RETURN g_success
                END IF 
                CALL s_auto_assign_no("ANM",g_oow.oow22,g_today,"2","nmh_file","nmh01","","","")
                     RETURNING li_result,g_nmh.nmh01
                IF (NOT li_result) THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('oow22','','','abm-621',1)
                   ELSE
                      CALL cl_err3("","oow_ile","","","abm-621","","",1)                                        
                   END IF
                   LET g_success = 'N'
                   RETURN g_success
                END IF
                LET g_nmh.nmh02 = l_rxy.rxy09
                IF cl_null(g_oow.oow25) THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('oow25','','','alm-998',1)
                   ELSE
                      CALL cl_err3("","oow_file","","","alm-998","","",1)                                        
                   END IF 
                   LET g_success = 'N'
                   RETURN g_success
                ELSE 
                   LET g_nmh.nmh03 = g_oow.oow25
                END IF 
                LET g_nmh.nmh04 = l_rxy.rxy10
                LET g_nmh.nmh05 = l_rxy.rxy10
                LET g_nmh.nmh07 = l_rxy.rxy06
                LET g_nmh.nmh31 = l_rxy.rxy06   #No.TQC-C30177   Add
                LET g_nmh.nmh08 = 0
               #FUN-A60056--mark--str--
               #IF cl_null(l_dbs) THEN   #No.FUN-9C0014
               #IF p_type = '11' THEN
               #   SELECT oea03 INTO g_nmh.nmh11 FROM oea_file WHERE oea01=p_no1
               #ELSE
               #   SELECT oga03 INTO g_nmh.nmh11 FROM oga_file WHERE oga01=p_no1
               #END IF
               ##No.FUN-9C0014 BEGIN -----
               #ELSE
               #FUN-A60056--mark--end
                   IF p_type = '11' THEN
                      #LET g_sql = "SELECT oea03 FROM ",l_dbs CLIPPED,"oea_file ",
                      LET g_sql = "SELECT oea03 FROM ",cl_get_target_table(p_plant,'oea_file'), #FUN-A50102
                                  " WHERE oea01='",p_no1,"'"
                   ELSE
                      #LET g_sql = "SELECT oga03 FROM ",l_dbs CLIPPED,"oga_file ",
                      LET g_sql = "SELECT oga03 FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                                  " WHERE oga01='",p_no1,"'"
                   END IF
                   CALL cl_replace_sqldb(g_sql) RETURNING g_sql              #FUN-A50102							
                   CALL cl_parse_qry_sql(g_sql,p_plant) RETURNING g_sql      #FUN-A50102 
                   PREPARE sel_oea_pre05 FROM g_sql
                   EXECUTE sel_oea_pre05 INTO g_nmh.nmh11
               #END IF    #FUN-A60056
             #No.FUN-9C0014 END -------
                IF cl_null(g_oow.oow23) THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('oow23','','','alm-998',1)
                   ELSE
                      CALL cl_err3("","oow_file","","","alm-998","","",1)                                        
                   END IF 
                   LET g_success = 'N'
                   RETURN g_success
                ELSE  
                   LET g_nmh.nmh12 = g_oow.oow23
                END IF 
                LET g_nmh.nmh13 = 'N'
                IF cl_null(g_oow.oow24) THEN                                                                                       
                   IF g_bgerr THEN 
                      CALL s_errmsg('oow24','','','alm-998',1)        
                   ELSE
                      CALL cl_err3("","oow_file","","","alm-998","","",1)                                        
                   END IF                                                                  
                   LET g_success = 'N'                                                                                              
                   RETURN g_success                                                                                                 
                ELSE
                   LET g_nmh.nmh15 = g_oow.oow24
                END IF 
                LET g_nmh.nmh17 = 0
                #TQC-B10270  --Begin    #nmh21默認值=axri060支票對應銀行
                LET l_ooe02_1 = ' '
                SELECT ooe02 INTO l_ooe02_1 FROM ooe_file WHERE ooe01 = '03'
                LET g_nmh.nmh21 = l_ooe02_1
                #TQC-B10270  --End
                LET g_nmh.nmh24 = '2'
                LET g_nmh.nmh25 = TODAY
                LET g_nmh.nmh28 = 1
                LET g_nmh.nmh32 = g_nmh.nmh02  
                #LET g_nmh.nmh06 = l_oob.oob17  #FUN-C30038  MARK
                LET g_nmh.nmh06 = l_rxy.rxy11   #FUN-C30038  ADD
                LET g_nmh.nmh38 = 'Y'
                LET g_nmh.nmh39 = 0
                LET g_nmh.nmh40 = 0
                #LET g_nmh.nmh41 = 'Y'   #TQC-B10270
                LET g_nmh.nmh41 = 'N'    #TQC-B10270 
                IF g_nmz.nmz11 = 'Y' THEN 
                   LET g_dept = g_nmh.nmh15 
                ELSE 
                   LET g_dept = ' ' 
                END IF
                SELECT * INTO g_nms.* FROM nms_file WHERE nms01 = g_dept
                LET g_nmh.nmh26  = g_nms.nms22
                LET g_nmh.nmh261 = g_nms.nms22
                LET g_nmh.nmh27  = g_nms.nms21
                LET g_nmh.nmh271 = g_nms.nms21
                CALL cl_digcut(g_nmh.nmh02,t_azi04) RETURNING g_nmh.nmh02
                CALL cl_digcut(g_nmh.nmh17,t_azi04) RETURNING g_nmh.nmh17
                CALL cl_digcut(g_nmh.nmh40,g_azi04) RETURNING g_nmh.nmh40
                LET g_nmh.nmhlegal = g_oma.omalegal 
                LET g_nmh.nmhoriu = g_user      #No.FUN-980030 10/01/04
                LET g_nmh.nmhorig = g_grup      #No.FUN-980030 10/01/04
                IF cl_null(g_nmh.nmh42) THEN LET g_nmh.nmh42 = 0 END IF   #No.FUN-B40011
                INSERT INTO nmh_file VALUES(g_nmh.*)
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('nmh01',g_nmh.nmh01,'ins nmh_file',SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("ins","nmh_file",g_nmh.nmh01,"",SQLCA.sqlcode,"","ins nmh",1)
                   END IF 
                   LET g_success = 'N'
                   RETURN g_success
                END IF  
             ###oob的資料
                LET l_oob.oob04 = '1'  
               #LET g_oob.oob14 = l_rxy.rxy06   #No.TQC-C30177   Add
                LET l_oob.oob14 = l_rxy.rxy06   #No.MOD-C30425   Add
                LET l_oob.oob17 = NULL 
                LET l_oob.oob18 = NULL 
                LET l_oob.oob06 = g_nmh.nmh01
                SELECT ool12,ool121 INTO l_oob.oob11,l_oob.oob111 FROM ool_file
                 WHERE ool01 = g_oma.oma13
                LET l_oob.oob09 = l_rxy.rxy09	
                LET l_oob.oob02 = l_ac
                IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
                CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09 
 
                LET l_oob.oob10 = l_oob.oob08*l_oob.oob09	
                IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF
                CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10 
                LET l_oob.oob22 = l_rxy.rxy09    #包含溢收 
                IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('','','','axr-076',1)
                   ELSE
                      CALL cl_err3("","oob_file","","","axr-076","","",1)
                   END IF 
                   LET g_success = 'N' 
                   RETURN g_success
                END IF
                IF cl_null(l_oob.oob11) THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('','','','axr-076',1)
                   ELSE
                      CALL cl_err3("","oob_file","","","axr-076","","",1)
                   END IF 
                   LET g_success = 'N'
                   RETURN g_success
                END IF
                IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
                IF l_oob.oob07 !=g_oma.oma23 THEN
                   IF g_bgerr THEN
                      CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1) 
                   ELSE
                      CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
                   END IF 
                   LET g_success = 'N' 
                   RETURN g_success          
                END IF
                INSERT INTO oob_file VALUES(l_oob.*)	
                IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                   IF g_bgerr THEN 
                      CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                   ELSE
                      CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                   END IF  
                   LET g_success = 'N'
                   RETURN g_success
                END IF  
                LET l_ac = l_ac + 1	
             END FOREACH	
          OTHERWISE 	
             LET l_oob.oob06 = g_oma.oma01	
             LET l_oob.oob09 = l_rxx.rxx04	
             IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
             CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09 
             LET l_oob.oob10 = l_oob.oob08*l_oob.oob09	
             IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF
             CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10 
             LET l_oob.oob22 = l_oob.oob09
             IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','','axr-076',1)
                ELSE
                   CALL cl_err3("","oob_file","","","axr-076","","",1)
                END IF 
                LET g_success = 'N' 
                RETURN g_success
             END IF
             IF cl_null(l_oob.oob11) THEN
                IF g_bgerr THEN
                   CALL s_errmsg('','','','axr-076',1)
                ELSE
                   CALL cl_err3("","oob_file","","","axr-076","","",1)
                END IF 
                LET g_success = 'N'
             END IF
             IF NOT cl_null(l_oob.oob111) THEN
                 SELECT COUNT(*) INTO l_sel FROM oob_file 
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1' 
                    AND oob04 = l_oob.oob04
                    AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111                                                               
             ELSE                                                                                                                  
                 SELECT COUNT(*) INTO l_sel FROM oob_file                                                                           
                  WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                    AND oob04 = l_oob.oob04 
                    AND oob11 = l_oob.oob11                                                                                         
             END IF	
             IF p_sum_sel = '1'  AND l_sel > 0 THEN     #需要匯總直接收款
                IF NOT cl_null(l_oob.oob111) THEN  
                   UPDATE oob_file SET oob09 = oob09 + l_oob.oob09,
                                       oob10 = oob10 + l_oob.oob10,
                                       oob22 = oob22 + l_oob.oob22 
                    WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                      AND oob04 = l_oob.oob04                                                                                         
                      AND oob11 = l_oob.oob11 AND oob111 = l_oob.oob111
                ELSE
                   UPDATE oob_file SET oob09 = oob09 + l_oob.oob09,                                                                 
                                       oob10 = oob10 + l_oob.oob10,                                                                 
                                       oob22 = oob22 + l_oob.oob22
                    WHERE oob01 = g_oma.oma01 AND oob03 = '1'                                                                         
                      AND oob04 = l_oob.oob04                                                                                         
                      AND oob11 = l_oob.oob11
                END IF 
             ELSE
            #   IF cl_null(l_oob.oob17) THEN
            #      IF g_bgerr THEN
            #         CALL s_errmsg('','','','axr-075',1)
            #      ELSE
            #         CALL cl_err('','axr-075',1)
            #      END IF 
            #      LET g_success = 'N'
            #      RETURN g_success
            #   END IF 
            #   IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
            #      IF g_bgerr THEN
            #         CALL s_errmsg('','','','axr-076',1)
            #      ELSE
            #         CALL cl_err('','axr-076',1)
            #      END IF  
            #      LET g_success = 'N' 
            #      RETURN g_success
            #   END IF
            #   IF cl_null(l_oob.oob11) THEN
            #      IF g_bgerr THEN
            #         CALL s_errmsg('','','','axr-076',1)
            #      ELSE
            #         CALL cl_err('','axr-076',1)
            #      END IF 
            #      LET g_success = 'N'
            #      RETURN g_success
            #   END IF
                IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
                IF l_oob.oob07 !=g_oma.oma23 THEN
                   IF g_bgerr THEN 
                      CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1)
                   ELSE
                      CALL cl_err3("","oob_file","","","axr-144","","",1)
                   END IF 
                   LET g_success = 'N' 
                   RETURN g_success          
                END IF
               INSERT INTO oob_file VALUES(l_oob.*)
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                  END IF  
                  LET g_success = 'N'
                  RETURN g_success
               END IF  
               LET l_ac = l_ac + 1 
            END IF
       END CASE	
       IF NOT cl_null(l_str) THEN
          IF g_bgerr THEN
             CALL s_errmsg('l_str','','','axr-044',1)
          ELSE
             CALL cl_err(l_str,'axr-044',1)
          END IF 
          LET g_success = 'N'
       END IF
       
    END FOREACH	
###借方結束
#No.TQC-C20565 ---start---   ReMark
#FUN-960140 090915--MARK--STR   不考慮轉費用
#####若是出貨 考慮折扣轉費用(借方)
    INITIALIZE l_oob.* TO NULL
    IF p_type='12' THEN
      #SELECT SUM(ogb47) INTO l_oob.oob09 FROM ogb_file WHERE ogb01=p_no1                         #No.TQC-C20565   Mark
       SELECT SUM(ogb47) INTO l_oob.oob09 FROM ogb_file WHERE ogb01=p_no1 AND ogb04 = 'MISCCARD'  #No.TQC-C20565   Add
       IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
       CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09
       SELECT oga213,oga211 INTO l_oga213,l_oga211 FROM oga_file WHERE oga01=p_no1
   #No.TQC-C20565 ---start---   Mark
   #ELSE
   #   SELECT SUM(oeb47) INTO l_oob.oob09 FROM oeb_file WHERE oeb01=p_no1
   #   IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
   #   CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09
   #   SELECT oea213,oea211 INTO l_oga213,l_oga211 FROM oea_file WHERE oea01=p_no1
   #No.TQC-C20565 ---end---     Mark
    END IF 
       IF l_oob.oob09 > 0 THEN
          LET l_oob.oob01=g_oma.oma01
         SELECT MAX(oob02)+1 INTO l_oob.oob02 FROM oob_file WHERE oob01=g_oma.oma01
         IF cl_null(l_oob.oob02) THEN LET l_oob.oob02=0 END IF
         LET l_oob.oob03 = '1'
         LET l_oob.oob04 = 'F'
         LET l_oob.oob06 = g_oma.oma01
         LET l_oob.oob08 = g_oma.oma24 
         LET l_oob.oob11 = g_ool.ool34
         LET l_oob.oob111 = g_ool.ool341
         LET l_oob.oob19 = '1'
 
         IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
            IF g_bgerr THEN 
               CALL s_errmsg('','','','axr-076',1) 
            ELSE
               CALL cl_err3("","oob_file","","","axr-076","","",1)
            END IF 
            LET g_success = 'N'    
            RETURN g_success        
         END IF                      
         IF cl_null(l_oob.oob11) THEN
            IF g_bgerr THEN 
               CALL s_errmsg('','','','axr-076',1) 
            ELSE
               CALL cl_err3("","oob_file","","","axr-076","","",1)
            END IF  
            LET g_success = 'N'
            RETURN g_success  
         END IF                
         LET l_oob.oob07 = g_oma.oma23
         IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF
         IF l_oob.oob07 !=g_oma.oma23 THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1) 
            ELSE
               CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
            END IF 
            LET g_success = 'N' 
            RETURN g_success          
         END IF
         IF cl_null(l_oob.oob09) THEN LET l_oob.oob09 = 0 END IF   
         IF cl_null(l_oob.oob10) THEN LET l_oob.oob10 = 0 END IF  
         IF cl_null(l_oob.oob22) THEN LET l_oob.oob22 = 0 END IF
 
 
         IF l_oga213='N' THEN
            LET l_oob.oob09=l_oob.oob09*(1+l_oga211)
            IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF
            CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09
         END IF
 
         LET l_oob.oob10 = l_oob.oob08*l_oob.oob09
         IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF
         CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10
 
         IF l_oob.oob09 > 0 THEN
            LET l_oob.oob22 = l_oob.oob09
            SELECT COUNT(*) INTO l_sel FROM oob_file WHERE oob01=g_oma.oma01 AND oob04='F'
            IF cl_null(l_sel) THEN LET l_sel=0 END IF
            IF l_sel>0 THEN
               UPDATE oob_file SET oob09=oob09+l_oob.oob09,
                                   oob10=oob10+l_oob.oob10,
                                   oob22=oob22+l_oob.oob22
                WHERE oob01=g_oma.oma01 AND oob02=-1
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                  END IF 
                  LET g_success = 'N'
                  RETURN g_success
               END IF 
            ELSE
               IF cl_null(l_oob.ooblegal) THEN LET l_oob.ooblegal = g_oma.omalegal END IF  #No.TQC-C20565 Add
               INSERT INTO oob_file VALUES (l_oob.*)
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  IF g_bgerr THEN
                     CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
                  ELSE
                     CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
                  END IF 
                  LET g_success = 'N'
                  RETURN g_success
               END IF
            END IF
         END IF  
      END IF 
#FUN-960140 090915 mark end      
#No.TQC-C20565 ---end---     ReMark
 
      SELECT SUM(oob09) INTO l_amt2 FROM oob_file 
       WHERE oob01=g_oma.oma01
         AND oob02 >0
         AND oob03 = '1' 
      IF cl_null(l_amt2) THEN LET l_amt2=0 END IF
      IF l_amt2>g_oma.oma54t THEN
         INITIALIZE l_oob.* TO NULL
         SELECT MAX(oob02)+1 INTO l_oob.oob02 FROM oob_file WHERE oob01=g_oma.oma01
         LET l_oob.oob01 = g_oma.oma01
         LET l_oob.ooblegal = g_oma.omalegal     #TQC-AC0155 add
         LET l_oob.oob03 = '2'
         LET l_oob.oob04 = 'B'
         LET l_oob.oob19 = 1  #FUN-9C0041 #by elva
       # LET l_oob.oob06 = NULL  #FUN-9C0041 #by elva
         LET l_oob.oob06 = g_oma.oma01  #FUN-9C0041 #by elva
         LET l_oob.oob07 = g_oma.oma23
         IF l_oob.oob07 !=g_oma.oma23 THEN
            IF g_bgerr THEN
               CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1) 
            ELSE
               CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
            END IF 
            LET g_success = 'N' 
            RETURN g_success          
         END IF
         LET l_oob.oob08 = g_oma.oma24
         LET l_oob.oob09 = l_amt2-g_oma.oma54t
         IF cl_null(l_oob.oob09) THEN LET l_oob.oob09=0 END IF                                                               
         CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09                                                           
         LET l_oob.oob10 = l_oob.oob08*l_oob.oob09                                                                           
         IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF                                                               
         CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10  
         LET l_oob.oob17 = NULL
         LET l_oob.oob18 = NULL
         LET l_oob.oob21 = NULL
         LET l_oob.oob11 = g_ool.ool35     
         IF g_aza.aza63 = 'Y' THEN
            LET l_oob.oob111 = g_ool.ool351 
         END IF
 
         CALL s_get_bookno(year(g_oma.oma02))
                    RETURNING g_flag1,g_bookno1,g_bookno2
         IF g_flag1='1' THEN #抓不到帳別
            IF g_bgerr THEN
               CALL s_errmsg('oma02',g_oma.oma02,'','aoo-081',1)
            ELSE
               CALL cl_err(g_oma.oma02,'aoo-081',1)
            END IF 
            LET g_success='N'
            RETURN g_success
         END IF 
         SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01=l_oob.oob11  AND aag00=g_bookno1  
         IF l_aag05 = 'Y' THEN
            LET l_oob.oob13 = g_ooa.ooa15
         ELSE
            LET l_oob.oob13 = ''
         END IF
         LET l_oob.oob22 = l_oob.oob09 
         LET l_oob.oob07 = g_oma.oma23
         IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF
         IF l_oob.oob07 !=g_oma.oma23 THEN
            IF g_bgerr THEN  
               CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1)
            ELSE
               CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
            END IF 
            LET g_success = 'N' 
            RETURN g_success          
         END IF
         INSERT INTO oob_file VALUES(l_oob.*)
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                        
            IF g_bgerr THEN 
               CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)    
            ELSE
               CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
            END IF                                     
            LET g_success = 'N'                                                                                        
            RETURN g_success                                                                                           
         END IF       
      END IF
    SELECT count(*) INTO l_cnt FROM ooa_file WHERE ooa01=g_oma.oma01
    IF l_cnt=0 THEN
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
      # LET g_ooa.ooa37 = 'N'    #FUN-A40076 mark 
       LET g_ooa.ooa37 = '1'     #FUN-A40076 add
       LET g_ooa.ooa23 = g_oma.oma23
       LET g_ooa.ooa24 = g_oma.oma24
       LET g_ooa.ooa31c = 0
       LET g_ooa.ooa31d = 0
       LET g_ooa.ooa32c = 0
       LET g_ooa.ooa32d = 0
       LET g_ooa.ooaconf = 'N'
       LET g_ooa.ooa34 = '0'    #No.TQC-9C0057
       LET g_ooa.ooaprsw = 0
       LET g_ooa.ooauser = g_user
       LET g_ooa.ooaoriu = g_user #FUN-980030
       LET g_ooa.ooaorig = g_grup #FUN-980030
       LET g_ooa.ooagrup = g_grup
       LET g_ooa.ooadate = g_today
       #LET g_ooa.ooaplant = g_oma.omaplant   #FUN-960140 mark 090824
       LEt g_ooa.ooalegal = g_oma.omalegal
    
       INSERT INTO ooa_file values(g_ooa.*)
       IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
          IF g_bgerr THEN
             CALL s_errmsg('ooa01',g_ooa.ooa01,'ins ooa_file',SQLCA.sqlcode,1)
          ELSE
             CALL cl_err3("ins","ooa_file",g_ooa.ooa01,g_ooa.ooa02,SQLCA.sqlcode,"","ins ooa",1)
          END IF 
          LET g_success = 'N'
          RETURN g_success
       END IF  
    END IF
    
    DELETE FROM oob_file WHERE oob01 = g_oma.oma01 AND oob02 <0 AND oob03 = '2' AND oob04 = '1'	
    INITIALIZE l_oob.* TO NULL
    LET l_oob.oob01 = g_oma.oma01  
 
    LET l_oob.oob02 = -1
    LET l_oob.oob03 = '2'
    LET l_oob.oob04 = '1' 
    LET l_oob.oob06 = g_oma.oma01
    LET l_oob.oob07 = g_oma.oma23  
    LET l_oob.oob08 = g_oma.oma24
    LET l_oob.oob11 = g_oma.oma18
    LET l_oob.oob111 = g_oma.oma181
    IF cl_null(l_oob.oob09) THEN LET l_oob.oob09 = 0 END IF
    IF cl_null(l_oob.oob10) THEN LET l_oob.oob10 = 0 END IF
    IF cl_null(l_oob.oob22) THEN LET l_oob.oob22 = 0 END IF
    LET l_oob.ooblegal = g_oma.omalegal   #No.MOD-AA0080
 
    SELECT SUM(oob09) INTO l_amt3 FROM oob_file 
     WHERE oob01 = g_oma.oma01 AND oob03 = '1' AND oob02 > 0 
    IF cl_null(l_amt3) THEN LET l_amt3=0 END IF 
 
    SELECT SUM(oob09) INTO l_amt4 FROM oob_file 
     WHERE oob01 = g_oma.oma01 AND oob02>0 AND oob03 = '2' #ND oob04 = '1'
    IF cl_null(l_amt4) THEN LET l_amt4=0 END IF
    LET l_oob.oob09 = l_amt3-l_amt4                                                               
 
    CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09                                                           
    LET l_oob.oob10 = l_oob.oob08*l_oob.oob09                                                                           
    IF cl_null(l_oob.oob10) THEN LET l_oob.oob10=0 END IF                                                               
    CALL cl_digcut(l_oob.oob09,g_azi04) RETURNING l_oob.oob09 
 
    IF g_aza.aza63='Y' AND cl_null(l_oob.oob111) THEN
       IF g_bgerr THEN
          CALL s_errmsg('','','','axr-076',1)
       ELSE
          CALL cl_err3("","oob_file","","","axr-076","","",1)
       END IF 
       LET g_success = 'N' 
       RETURN g_success
    END IF
    IF cl_null(l_oob.oob11) THEN
        IF g_bgerr THEN
           CALL s_errmsg('','','','axr-076',1)
        ELSE
           CALL cl_err3("","oob_file","","","axr-076","","",1)
        END IF 
        LET g_success = 'N'
        RETURN g_success
    END IF
    LET l_oob.oob07 = g_oma.oma23
    IF cl_null(l_oob.oob07) THEN LET l_oob.oob07 = g_aza.aza17 END IF 
    IF l_oob.oob07 !=g_oma.oma23 THEN
       IF g_bgerr THEN 
          CALL s_errmsg('oob07',l_oob.oob07,'','axr-144',1) 
       ELSE
          CALL cl_err3("","oob_file",l_oob.oob07,"","axr-144","","",1)
       END IF 
       LET g_success = 'N' 
       RETURN g_success          
    END IF
       
    IF l_oob.oob09 > 0 THEN 
       LET l_oob.oob22 = l_oob.oob09
       SELECT COUNT(*) INTO l_sel FROM oob_file WHERE oob01=g_oma.oma01 AND oob02=-1
       IF cl_null(l_sel) THEN LET l_sel=0 END IF                                                                                 
       IF l_sel>0 THEN                                                                                                           
          UPDATE oob_file SET oob09=oob09+l_oob.oob09,                                                                           
                              oob10=oob10+l_oob.oob10,                                                                           
                              oob22=oob22+l_oob.oob22                                                                            
           WHERE oob01=g_oma.oma01 AND oob02=-1                                                                                   
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN                       
             IF g_bgerr THEN
                CALL s_errmsg('oob01',l_oob.oob01,'upd oob_file',SQLCA.sqlcode,1)                                                  
             ELSE
                CALL cl_err3("upd","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
             END IF 
             LET g_success = 'N'                                                                                                 
             RETURN g_success                                                                                                    
          END IF                                                                                                                 
       ELSE      
          INSERT INTO oob_file VALUES (l_oob.*)
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
             IF g_bgerr THEN
                CALL s_errmsg('oob01',l_oob.oob01,'ins oob_file',SQLCA.sqlcode,1)
             ELSE
                CALL cl_err3("ins","oob_file",l_oob.oob01,l_oob.oob02,SQLCA.sqlcode,"","ins oob",1)
             END IF 
             LET g_success = 'N'
             RETURN g_success
          END IF 
       END IF
    END IF 
    CALL s_t300_ins_bu()
    IF g_success = 'Y' THEN
       UPDATE oma_file SET oma65='2'
        WHERE oma01=p_no2
       LET g_oma.oma65='2'
    END IF
    RETURN g_success
END FUNCTION
 
FUNCTION s_t300_ins_bu()
   LET g_ooa.ooa31d = 0 LET g_ooa.ooa31c = 0
   LET g_ooa.ooa32d = 0 LET g_ooa.ooa32c = 0
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31d,g_ooa.ooa32d
     FROM oob_file 
    WHERE oob01=g_oma.oma01 AND oob03='1'
      AND oob02>0
   SELECT SUM(oob09),SUM(oob10) INTO g_ooa.ooa31c,g_ooa.ooa32c
     FROM oob_file
    WHERE oob01=g_oma.oma01 AND oob03='2'
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
 
   UPDATE ooa_file 
      SET ooa31d=g_ooa.ooa31d,ooa31c=g_ooa.ooa31c,
          ooa32d=g_ooa.ooa32d,ooa32c=g_ooa.ooa32c
    WHERE ooa01=g_oma.oma01
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('ooa01',g_ooa.ooa01,'upd ooa_file',SQLCA.sqlcode,1)
      ELSE
         CALL cl_err3("upd","ooa_file",g_ooa.ooa01,"",SQLCA.sqlcode,"","upd ood31,32",1)
      END IF 
      LET g_success = 'N'
   END IF
 
END FUNCTION
#FUN-960140

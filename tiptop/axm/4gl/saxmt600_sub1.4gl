# Prog. Version..: '5.30.06-13.04.18(00010)'     #
#
# Pattern name...: saxmt600_sub1.4gl
# Descriptions...: 产生入库单/仓退单和杂发/杂收单且审核过账
# Input Parameter: p_type    #1:出货单  2:销退单  3:對帳單
#                : p_oga01   #单号
# Date & Author..: No:FUN-B40098 11/05/10 By shiwuying
# Modify.........: No:TQC-B60065 11/06/16 By shiwuying 增加虛擬類型rvu27
# Modify.........: No:FUN-B60150 11/06/30 By baogc 經營方式為(2-成本代銷)且成本代銷控制參數sma146為(2-非成本倉)時也產生雜發/收和入庫/倉退單
# Modify.........: No:FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除
# Modify.........: No:TQC-B90235 11/09/29 By baogc 出貨單產生入庫單/倉退單單據時日期使用出貨單的出貨日期
# Modify.........: No.FUN-BB0044 11/11/08 By baogc 扣率代銷或者成本代銷入非成本倉，銷退產生倉退單時，開立折讓單rvu10默認給Y
# Modify.........: No:FUN-BA0087 11/11/09 By pauline 調整Code，及修正倉退的異動命令.
# Modify.........: No.FUN-BB0072 11/11/15 By baogc 扣率代銷或成本代銷入非成本倉時，出貨單單身為負，產生倉退單和雜收單，銷退單為負時產生入庫單和雜發單
# Modify.........: No.TQC-BB0131 11/11/29 By pauline 為出貨單或銷退單時讓rvu21 = '1',為銷退時update rvu13,rvu14
# Modify.........: No.TQC-BB0161 11/11/29 By pauline plant/legal應該以單據上的plant/legal處理
# Modify.........: No.TQC-BB0268 12/01/30 By pauline 修改代銷倉退寫入tlf_file項目
# Modify.........: No.FUN-C10007 12/01/30 By pauline 當代銷產品的銷售金額為0, 但數量>0時調整
# Modify.........: No.FUN-BC0104 12/01/31 By xianghui 數量異動回寫qco20
# Modify.........: No:MOD-C60093 12/06/18 By ck2yuan 給tlf901值
# Modify.........: No:FUN-C50090 12/06/26 By baogc 雜發雜收異動img前先檢查是否在img資料
# Modify.........: No:FUN-C80045 12/08/17 By nanbing 根據是否是POS調用抓取單別
# Modify.........: No:FUN-C90049 12/10/19 By Lori 預設成本倉與非成本倉改從s_get_defstore取
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No:FUN-CB0087 12/12/20 By qiull 庫存單據理由碼改善,xujing:inb_file
# Modify.........: No:FUN-BC0062 13/02/27 By lixh1 過帳同時計算移動加權平均成本

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE g_oga         RECORD LIKE oga_file.*
DEFINE g_ogb         RECORD LIKE ogb_file.*
DEFINE g_oha         RECORD LIKE oha_file.*
DEFINE g_ohb         RECORD LIKE ohb_file.*
DEFINE g_sql         LIKE type_file.chr1000
DEFINE g_rvu04       LIKE rvu_file.rvu04
#FUN-B60150 ADD - BEGIN --------------------
DEFINE g_rvc         RECORD LIKE rvc_file.*
DEFINE g_rvg         RECORD
                   rvg03    LIKE rvg_file.rvg03,
                   ogb04    LIKE ogb_file.ogb04,
                   ogb05    LIKE ogb_file.ogb05,
                   rvg08    LIKE rvg_file.rvg08,
                   ogb14t   LIKE ogb_file.ogb14t
                     END RECORD
DEFINE g_rvv39t      LIKE rvv_file.rvv39t
DEFINE g_rvf08       LIKE rvf_file.rvf08
DEFINE g_rvu114      LIKE rvu_file.rvu114
DEFINE g_rvv17       LIKE rvv_file.rvv17
#FUN-B60150 ADD -  END  --------------------
DEFINE g_alter_date  LIKE type_file.dat   #TQC-B90235 Add
DEFINE g_azw01       LIKE azw_file.azw01  #TQC-BB0161 add 
DEFINE g_azw02       LIKE azw_file.azw02  #TQC-BB0161 add  
FUNCTION t620sub1_post(p_type,p_oga01)
   DEFINE p_oga01    LIKE oga_file.oga01
   DEFINE p_type     LIKE type_file.chr1
   DEFINE l_rty05    LIKE rty_file.rty05
#FUN-B60150 ADD - BEGIN ----------------------------
   DEFINE l_rvg      RECORD 
                   rvg02    LIKE rvg_file.rvg02,
                   rvg03    LIKE rvg_file.rvg03,
                   rvg04    LIKE rvg_file.rvg04,
                   rvg05    LIKE rvg_file.rvg05,
                   rvg06    LIKE rvg_file.rvg06,
                   ogb04    LIKE ogb_file.ogb04,
                   ogb05    LIKE ogb_file.ogb05,
                   ogb14t   LIKE ogb_file.ogb14t,
                   rvg08    LIKE rvg_file.rvg08
                  END RECORD
   DEFINE l_ogb12  LIKE ogb_file.ogb12
#FUN-B60150 ADD -  END  ----------------------------


   WHENEVER ERROR CONTINUE

   IF cl_null(p_oga01) THEN RETURN END IF
   IF g_azw.azw04 <> '2' THEN RETURN END IF
   LET g_rvu04 = ''
   IF p_type = '1' THEN   #出貨單
      SELECT * INTO g_oga.* FROM  oga_file 
       WHERE oga01 = p_oga01
      LET g_alter_date = g_oga.oga02  #TQC-B90235 Add 
      LET g_azw01 = g_oga.ogaplant                #TQC-BB0161 add
      CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
      LET g_sql = "SELECT rty05,ogb_file.* FROM ogb_file,rty_file ",
                  " WHERE ogb01 = '",p_oga01,"'",
                  "   AND ogb44 = '3' ",
                  "   AND rty01 = '",g_oga.ogaplant,"'",
                  "   AND rty02 = ogb04 ",
                  " ORDER BY rty05 "
      PREPARE t620sub1_sel_ogb FROM g_sql
      DECLARE t620sub1_sel_ogb_c CURSOR FOR t620sub1_sel_ogb
      FOREACH t620sub1_sel_ogb_c INTO l_rty05,g_ogb.*
        #产生杂发/杂收单
         CALL t620sub1_insinainb(p_type)
         IF g_success = 'N' THEN RETURN END IF
        
        #产生入库单
        #FUN-BB0072 Add Begin ---
        #根據出貨金額，若為正產生入庫單，反之則產生倉退單
         IF g_ogb.ogb14t > 0 THEN
        #FUN-BB0072 Add End -----
            CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
        #FUN-BB0072 Add Begin ---
         ELSE
            CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
         END IF
        #FUN-BB0072 Add End -----
         IF g_success = 'N' THEN RETURN END IF
      END FOREACH
#FUN-B60150 - ADD - BEGIN -------------------------------------------
      IF g_sma.sma146 = '2' THEN
         INITIALIZE g_oga.* TO NULL
         SELECT * INTO g_oga.* FROM  oga_file
          WHERE oga01 = p_oga01
         LET g_azw01 = g_oga.ogaplant                #TQC-BB0161 add
         CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
         LET g_sql = "SELECT rty05,ogb_file.* FROM ogb_file,rty_file ",
                     " WHERE ogb01 = '",p_oga01,"'",
                     "   AND ogb44 = '2' ",
                     "   AND rty01 = '",g_oga.ogaplant,"'",
                     "   AND rty02 = ogb04 ",
                     " ORDER BY rty05 "
         PREPARE t620sub1_sel_ogb2 FROM g_sql
         DECLARE t620sub1_sel_ogb_c2 CURSOR FOR t620sub1_sel_ogb2
         FOREACH t620sub1_sel_ogb_c2 INTO l_rty05,g_ogb.*
           #- < 取採購協議中的單價 > -#
            SELECT rtt06t INTO g_ogb.ogb13 FROM rtt_file,rts_file,rto_file
             WHERE rts01 = rtt01 AND rts02 = rtt02 
               AND rttplant = rtsplant AND rttplant = g_oga.ogaplant
               AND rto01 = rts04 AND rtoplant = rtsplant
               AND rto05 = l_rty05 AND rtsacti = 'Y' AND rtsconf = 'Y'
               AND rto08<=g_oga.oga02 AND rto09>=g_oga.oga02 
               AND rtt04 = g_ogb.ogb04 AND rtt05 = g_ogb.ogb05 AND rtt15 = 'Y'
            LET g_ogb.ogb14t = g_ogb.ogb13 * g_ogb.ogb12
           #产生杂发/杂收单
            CALL t620sub1_insinainb(p_type)
            IF g_success = 'N' THEN RETURN END IF

           #产生入库单
           #FUN-BB0072 Add Begin ---
           #根據出貨金額，若為正產生入庫單，反之則產生倉退單
            IF g_ogb.ogb14t > 0 THEN
           #FUN-BB0072 Add End -----
               CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
           #FUN-BB0072 Add Begin ---
            ELSE
               CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
            END IF
           #FUN-BB0072 Add End -----
            IF g_success = 'N' THEN RETURN END IF
         END FOREACH
      END IF
   #TQC-BB0131 add START
      IF g_ogb.ogb44 = '3' OR (g_ogb.ogb44 = '2' AND g_sma.sma146 = '2') THEN
         CALL t620sub1_updruv13(p_oga01)
         IF g_success = 'N' THEN RETURN END IF
      END IF
   #TQC-BB0131 add END
#FUN-B60150 - ADD -  END  -------------------------------------------
  #ELSE                  #FUN-B60150 MARK
   END IF                #FUN-B60150 ADD
   IF p_type = '2' THEN  #FUN-B60150 ADD   #銷退
      SELECT * INTO g_oha.* FROM oha_file
      WHERE oha01 = p_oga01
      LET g_azw01 = g_oha.ohaplant                #TQC-BB0161 add
      CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
      LET g_alter_date = g_oha.oha02  #TQC-B90235 Add
      LET g_sql = " SELECT rty05,ohb_file.* FROM ohb_file,rty_file ",
                  " WHERE ohb01 = '",p_oga01,"'",
                  "   AND ohb64 = '3' ",
                  "   AND rty01 = '",g_oha.ohaplant,"'",
                  "   AND rty02 = ohb04 ",
                  " ORDER BY rty05 "
      PREPARE t620sub1_sel_ohb FROM g_sql
      DECLARE t620sub1_sel_ohb_c CURSOR FOR t620sub1_sel_ohb
      FOREACH t620sub1_sel_ohb_c INTO l_rty05,g_ohb.*
        #产生杂发/杂收单
         CALL t620sub1_insinainb(p_type)
         IF g_success = 'N' THEN RETURN END IF
        
        #产生仓退单
        #FUN-BB0072 Add Begin ---
        #根據銷退金額，若為正產生倉退單，反之則產生入庫單
         IF g_ohb.ohb14t > 0 THEN
        #FUN-BB0072 Add End -----
            CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
        #FUN-BB0072 Add Begin ---
         ELSE
            CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
         END IF
        #FUN-BB0072 Add End -----
         IF g_success = 'N' THEN RETURN END IF
      END FOREACH
#FUN-B60150 - ADD - BEGIN -------------------------------------------
      IF g_sma.sma146 = '2' THEN
         INITIALIZE g_oha.* TO NULL
         SELECT * INTO g_oha.* FROM oha_file
         WHERE oha01 = p_oga01
         LET g_azw01 = g_oha.ohaplant                #TQC-BB0161 add
         CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
         LET g_sql = " SELECT rty05,ohb_file.* FROM ohb_file,rty_file ",
                     " WHERE ohb01 = '",p_oga01,"'",
                     "   AND ohb64 = '2' ",
                     "   AND rty01 = '",g_oha.ohaplant,"'",
                     "   AND rty02 = ohb04 ",
                     " ORDER BY rty05 "
         PREPARE t620sub1_sel_ohb2 FROM g_sql
         DECLARE t620sub1_sel_ohb_c2 CURSOR FOR t620sub1_sel_ohb2
         FOREACH t620sub1_sel_ohb_c2 INTO l_rty05,g_ohb.*
           #- < 取採購協議中的單價 > -#
            SELECT rtt06t INTO g_ohb.ohb13 FROM rtt_file,rts_file,rto_file
             WHERE rts01 = rtt01 AND rts02 = rtt02 
               AND rttplant = rtsplant AND rttplant = g_oha.ohaplant
               AND rto01 = rts04 AND rtoplant = rtsplant
               AND rto05 = l_rty05 AND rtsacti = 'Y' AND rtsconf = 'Y'
               AND rto08<=g_oha.oha02 AND rto09>=g_oha.oha02 
               AND rtt04 = g_ohb.ohb04 AND rtt05 = g_ohb.ohb05 AND rtt15 = 'Y'
            LET g_ohb.ohb14t = g_ohb.ohb13 * g_ohb.ohb12
           #产生杂发/杂收单
            CALL t620sub1_insinainb(p_type)
            IF g_success = 'N' THEN RETURN END IF

           #产生仓退单
           #FUN-BB0072 Add Begin ---
           #根據銷退金額，若為正產生倉退單，反之則產生入庫單
            IF g_ohb.ohb14t > 0 THEN
           #FUN-BB0072 Add End -----
               CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
            ELSE
               CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
            END IF
           #FUN-BB0072 Add End -----
            IF g_success = 'N' THEN RETURN END IF
         END FOREACH
      END IF
   #TQC-BB0131 add START
      IF g_ohb.ohb64 = '3' OR (g_ohb.ohb64 = '2' AND g_sma.sma146 = '2') THEN
         CALL t620sub1_updruv13(p_oga01)
         IF g_success = 'N' THEN RETURN END IF
      END IF
   #TQC-BB0131 add END
#FUN-B60150 - ADD -  END  -------------------------------------------
   END IF
#FUN-B60150 - ADD - BEGIN -------------------------------------------
   IF p_type = '3' THEN
      SELECT rvg02,rvg03,rvg04,rvg05,rvg06,ogb04,ogb05,ogb14t,rvg08
        FROM rvg_file,ogb_file
       WHERE 1=0
        INTO TEMP t620_rvg_temp
      DELETE FROM t620_rvg_temp
      SELECT * INTO g_rvc.* FROM rvc_file WHERE rvc01 = p_oga01
      LET g_alter_date = g_rvc.rvc05 #TQC-B90235 Add
      LET g_azw01 = g_rvc.rvcplant                #TQC-BB0161 add
      CALL s_getlegal(g_azw01) RETURNING g_azw02  #TQC-BB0161 add
      LET g_sql = " SELECT rvg02,rvg03,rvg04,rvg05,rvg06,'','','',rvg08,'' ",
               "   FROM rvg_file",
               "  WHERE rvg01='",g_rvc.rvc01,"' ",
               "    AND rvg00='2' AND rvg07='Y'"
      PREPARE t620_sel_rvg FROM g_sql
      DECLARE t620_sel_rvg_cs CURSOR FOR t620_sel_rvg
      FOREACH t620_sel_rvg_cs INTO l_rvg.*
         IF l_rvg.rvg04='1' THEN
            LET g_sql = "SELECT ogb04,ogb05,ogb14t,ogb12 ",
                        "   FROM ",cl_get_target_table(l_rvg.rvg03, 'ogb_file'),
                        "  WHERE ogb01 = '",l_rvg.rvg05,"'",
                        "    AND ogb03 = '",l_rvg.rvg06,"'"
         ELSE
            LET g_sql = "SELECT ohb04,ohb05,ohb14t*(-1),ohb12 ",
                        "   FROM ",cl_get_target_table(l_rvg.rvg03, 'ohb_file'),
                        "  WHERE ohb01 = '",l_rvg.rvg05,"'",
                        "    AND ohb03 = '",l_rvg.rvg06,"'"
         END IF
         PREPARE t620_sel_ogb FROM g_sql
         EXECUTE t620_sel_ogb INTO l_rvg.ogb04,l_rvg.ogb05,l_rvg.ogb14t,l_ogb12
         IF NOT cl_null(l_rvg.ogb14t) THEN
            LET l_rvg.ogb14t = l_rvg.ogb14t * l_rvg.rvg08 / l_ogb12
         END IF
         INSERT INTO t620_rvg_temp VALUES(l_rvg.rvg02,l_rvg.rvg03,l_rvg.rvg04,l_rvg.rvg05,
                                          l_rvg.rvg06,l_rvg.ogb04,l_rvg.ogb05,
                                          l_rvg.ogb14t,l_rvg.rvg08)
      END FOREACH
      UPDATE t620_rvg_temp SET rvg08 = rvg08 * (-1) WHERE rvg04='2'
      LET g_sql = " SELECT rvg03,ogb04,ogb05,SUM(rvg08),SUM(ogb14t) FROM t620_rvg_temp",
                  "  GROUP BY rvg03,ogb04,ogb05",
                  "  ORDER BY rvg03,ogb04,ogb05"
      PREPARE t620_sel_rvg_temp FROM g_sql
      DECLARE t620_sel_rvg_temp_cs CURSOR FOR t620_sel_rvg_temp

      FOREACH t620_sel_rvg_temp_cs INTO g_rvg.*
         SELECT rty05 INTO l_rty05 FROM rty_file WHERE rty01 = g_rvg.rvg03 AND rty02 = g_rvg.ogb04
         LET g_rvv39t = 0
         LET g_rvf08  = 0
         LET g_rvv17  = 0
         LET g_rvu114 = NULL
         LET g_sql = "SELECT SUM(CASE rvv03 WHEN '1' THEN rvv39t WHEN '3' THEN rvv39t*(-1) END),",
                     "       SUM(CASE rvv03 WHEN '1' THEN rvv17 WHEN '3' THEN rvv17*(-1) END),  ",
                     "       SUM(CASE rvv03 WHEN '1' THEN rvf08 WHEN '3' THEN rvf08*(-1) END),  ",
                     "       rvu114 ",
                     "  FROM rvv_file,rvf_file,rvu_file ",
                     " WHERE rvv01 = rvf05 AND rvv02 = rvf06 ",
                     "   AND rvf01 = '",g_rvc.rvc01,"' AND rvu01 = rvv01",
                     "   AND rvf00 = '2' AND rvv31 = '",g_rvg.ogb04,"' ",
                     " GROUP BY rvu114 "
         PREPARE t620_sel_sum_rvv_pre FROM g_sql
         EXECUTE t620_sel_sum_rvv_pre INTO g_rvv39t,g_rvv17,g_rvf08,g_rvu114
         IF cl_null(g_rvu114) THEN
           LET g_rvu114 = 1
         END IF
         LET g_rvv39t = g_rvv39t * g_rvf08 / g_rvv17
         LET g_prog = "apmt720"
         CALL t620sub1_insrvurvv(p_type,'1',l_rty05)
         CALL t620sub1_insrvurvv(p_type,'3',l_rty05)
         LET g_prog = "artt551"
      END FOREACH
   END IF
#FUN-B60150 - ADD -  END  -------------------------------------------
END FUNCTION

FUNCTION t620sub1_insinainb(p_type)
 DEFINE p_type     LIKE type_file.chr1
 DEFINE l_ina      RECORD LIKE ina_file.*
 DEFINE l_inb      RECORD LIKE inb_file.*
 DEFINE l_cnt      LIKE type_file.num5
 DEFINE li_result  LIKE type_file.num5
 DEFINE l_img09    LIKE img_file.img09
 DEFINE l_factor   LIKE type_file.num5
 DEFINE l_type     LIKE type_file.num5
 DEFINE l_ima906   LIKE ima_file.ima906
 DEFINE l_ima25    LIKE ima_file.ima25
 DEFINE l_imgg21   LIKE imgg_file.imgg21
 DEFINE l_imd10    LIKE imd_file.imd10
 DEFINE l_inbi     RECORD LIKE inbi_file.* #FUN-B70074 add

   IF p_type = '1' THEN
     #FUN-BB0072 Add&Mark Begin ---
     #SELECT * INTO l_ina.* FROM ina_file
     # WHERE ina10 = g_oga.oga01

      IF g_ogb.ogb14t < 0 THEN
        #出貨金額小於0，檢查是否存在雜收單
         SELECT * INTO l_ina.* FROM ina_file
          WHERE ina10 = g_oga.oga01 AND (ina00 = '3' OR ina00 = '4')
      ELSE
        #出貨金額大於0，檢查是否存在雜發單
         SELECT * INTO l_ina.* FROM ina_file
          WHERE ina10 = g_oga.oga01 AND (ina00 = '1' OR ina00 = '2')
      END IF
     #FUN-BB0072 Add&Mark End -----
   ELSE
     #FUN-BB0072 Add&Mark Begin ---
     #SELECT * INTO l_ina.* FROM ina_file
     # WHERE ina10 = g_oha.oha01

      IF g_ohb.ohb14t < 0 THEN
        #銷退金額小於0，檢查是否存在雜發單
         SELECT * INTO l_ina.* FROM ina_file
          WHERE ina10 = g_oha.oha01 AND (ina00 = '1' OR ina00 = '2')
      ELSE
        #銷退金額大於0，檢查是否存在雜收單
         SELECT * INTO l_ina.* FROM ina_file
          WHERE ina10 = g_oha.oha01 AND (ina00 = '3' OR ina00 = '4')
      END IF
     #FUN-BB0072 Add&Mark End -----
   END IF
   IF cl_null(l_ina.ina01) THEN
      SELECT imd10 INTO l_imd10 FROM imd_file,rtz_file
       WHERE imd01 = rtz08
         #AND rtz01 = g_plant  #TQC-BB0161 mark 
          AND rtz01 = g_azw01  #TQC-BB0161 add  
     #IF p_type MATCHES '[1]' THEN #FUN-BB0072 Mark
     #IF (p_type MATCHES '[1]' AND g_ogb.ogb14t > 0) OR   #FUN-BB0072 Add   #FUN-C10007 mark
     #   (p_type MATCHES '[2]' AND g_ohb.ohb14t < 0) THEN #FUN-BB0072 Add   #FUN-C10007 mark
      IF (p_type MATCHES '[1]' AND g_ogb.ogb14t >= 0) OR   #FUN-C10007 add
         (p_type MATCHES '[2]' AND g_ohb.ohb14t <= 0) THEN #FUN-C10007 add
         LET l_ina.ina00 = '1'
         IF l_imd10 = 'W' THEN
            LET l_ina.ina00 = '2'
         END IF
         IF g_prog !='apcp200' THEN #FUN-C80045 add
            #FUN-C90050 mark begin---
            #SELECT rye03 INTO l_ina.ina01 FROM rye_file 
            # WHERE rye01 = 'aim' 
            #   AND rye02 = '1'
            #FUN-C90050 mark end-----

            CALL s_get_defslip('aim','1',g_plant,'N') RETURNING l_ina.ina01    #FUN-C90050 add

         #FUN-C80045 add sta
         ELSE
            #FUN-C90050 mark begin---
            #SELECT rye04 INTO l_ina.ina01 FROM rye_file
            # WHERE rye01 = 'aim'
            #   AND rye02 = '1'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('aim','1',g_plant,'Y') RETURNING l_ina.ina01    #FUN-C90050 add
         END IF  
         #FUN-C80045 add end
         IF cl_null(l_ina.ina01) THEN
            CALL s_errmsg('ina01',l_ina.ina01,'sel_rye','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_auto_assign_no("aim",l_ina.ina01,g_today,'1',"ina_file","ina01","","","")
            RETURNING li_result,l_ina.ina01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
     #ELSE   #FUN-BB0072 Mark
      END IF #FUN-BB0072 Add
      IF (p_type MATCHES '[1]' AND g_ogb.ogb14t < 0) OR   #FUN-BB0072 Add
         (p_type MATCHES '[2]' AND g_ohb.ohb14t > 0) THEN #FUN-BB0072 Add
         LET l_ina.ina00 = '3'
         IF l_imd10 = 'W' THEN
            LET l_ina.ina00 = '4'
         END IF
         IF g_prog !='apcp200' THEN #FUN-C80045 add
            #FUN-C90050 mark begin---
            #SELECT rye03 INTO l_ina.ina01 FROM rye_file
            # WHERE rye01 = 'aim'
            #   AND rye02 = '2'
            #FUN-C90050 mark end----

            CALL s_get_defslip('aim','2',g_plant,'N') RETURNING l_ina.ina01   #FUN-C90050 add

         #FUN-C80045 add sta      
         ELSE 
            #FUN-C90050 mark begin---
            #SELECT rye04 INTO l_ina.ina01 FROM rye_file
            # WHERE rye01 = 'aim'
            #   AND rye02 = '2'  
            #FUN-C90050 mark end----- 
            CALL s_get_defslip('aim','2',g_plant,'Y') RETURNING l_ina.ina01   #FUN-C90050 add
         END IF 
         #FUN-C80045 add end      
         IF cl_null(l_ina.ina01) THEN
            CALL s_errmsg('ina01',l_ina.ina01,'sel_rye','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_auto_assign_no("aim",l_ina.ina01,g_today,'2',"ina_file","ina01","","","")
            RETURNING li_result,l_ina.ina01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF
     #LET l_ina.ina02 = g_today       #TQC-B90235 Mark
      LET l_ina.ina02 = g_alter_date  #TQC-B90235 Add
      LET l_ina.ina03 = g_today 
      LET l_ina.ina04 = g_grup
      LET l_ina.ina08 = '1'
      LET l_ina.inaprsw = 0
      LET l_ina.inapost = 'Y'
      LET l_ina.inauser = g_user
      LET l_ina.inagrup = g_grup
      LET l_ina.inadate = g_today
      LET l_ina.inamksg = 'N'
      LET l_ina.inaconu = g_user
      LET l_ina.inacond = g_today
      LET l_ina.inacont = TIME
      LET l_ina.inaconf = 'Y'
      IF p_type = '1' THEN
         LET l_ina.ina10 = g_oga.oga01
      ELSE
         LET l_ina.ina10 = g_oha.oha01
      END IF
      LET l_ina.ina11 = g_user
      LET l_ina.inaspc = 0
      LET l_ina.ina103 = ''
     #LET l_ina.inaplant = g_plant   #TQC-BB0161 mark
     #LET l_ina.inalegal = g_legal   #TQC-BB0161 mark
      LET l_ina.inaplant = g_azw01   #TQC-BB0161 add
      LET l_ina.inalegal = g_azw02   #TQC-BB0161 add
      LET l_ina.ina12   = 'N'
      LET l_ina.inapos  = 'N'
      LET l_ina.inaoriu = g_user
      LET l_ina.inaorig = g_grup
      LET l_ina.ina1013 = NULL
      LET l_ina.ina1014 = NULL
      LET l_ina.ina102  = NULL
      LET l_ina.inaud13 = NULL
      LET l_ina.inaud14 = NULL
      LET l_ina.inaud15 = NULL
      INSERT INTO ina_file VALUES (l_ina.*)
      IF STATUS THEN
         CALL s_errmsg('ina01',l_ina.ina01,'ina_ins',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
     
   LET l_inb.inb01 = l_ina.ina01
   SELECT MAX(inb03)+1 INTO l_inb.inb03
     FROM inb_file
    WHERE inb01 = l_inb.inb01
   IF cl_null(l_inb.inb03) THEN
      LET l_inb.inb03 = 1
   END IF
   IF p_type = '1' THEN
      LET l_inb.inb04 = g_ogb.ogb04
      #FUN-C90049 mark begin---
      #SELECT rtz08 INTO l_inb.inb05 FROM rtz_file
      # WHERE rtz01 = g_oga.ogaplant
      #FUN-C90049 mark end-----
      CALL s_get_noncoststore(g_oga.ogaplant,l_inb.inb04) RETURNING l_inb.inb05    #FUN-C90049 add
      LET l_inb.inb08 = g_ogb.ogb05
   ELSE
      LET l_inb.inb04 = g_ohb.ohb04
      #FUN-C90049 mark begin---
      #SELECT rtz08 INTO l_inb.inb05 FROM rtz_file
      # WHERE rtz01 = g_oha.ohaplant
      #FUN-C90049 mark end----
      CALL s_get_noncoststore(g_oha.ohaplant,l_inb.inb04) RETURNING l_inb.inb05    #FUN-C90049 add
      LET l_inb.inb08 = g_ohb.ohb05
   END IF
   LET l_inb.inb06 = ' '
   LET l_inb.inb07 = ' '
   
   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01 = l_inb.inb04
      AND img02 = l_inb.inb05
      AND img03 = l_inb.inb06
      AND img04 = l_inb.inb07
   IF p_type = '1' THEN
      CALL s_umfchk(l_inb.inb04,g_ogb.ogb05,l_img09)
         RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN LET l_factor = 1 END IF
      LET l_inb.inb08_fac = l_factor
     #LET l_inb.inb09 = g_ogb.ogb12        #FUN-BB0072 Mark
      LET l_inb.inb09 = s_abs(g_ogb.ogb12) #FUN-BB0072 Add
      LET l_inb.inb902 = g_ogb.ogb910
      
      CALL s_umfchk(l_inb.inb04,l_inb.inb902,l_img09)
         RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN LET l_factor = 1 END IF
      LET l_inb.inb903 = l_factor
      LET l_inb.inb904 = g_ogb.ogb912
      LET l_inb.inb905 = g_ogb.ogb913
      LET l_inb.inb907 = g_ogb.ogb915
   ELSE
      CALL s_umfchk(l_inb.inb04,g_ohb.ohb05,l_img09)
         RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN LET l_factor = 1 END IF
      LET l_inb.inb08_fac = l_factor
     #LET l_inb.inb09 = g_ohb.ohb12        #FUN-BB0072 Mark
      LET l_inb.inb09 = s_abs(g_ohb.ohb12) #FUN-BB0072 Add
      LET l_inb.inb902 = g_ohb.ohb910
      
      CALL s_umfchk(l_inb.inb04,l_inb.inb902,l_img09)
         RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN LET l_factor = 1 END IF
      LET l_inb.inb903 = l_factor
      LET l_inb.inb904 = g_ohb.ohb912
      LET l_inb.inb905 = g_ohb.ohb913
      LET l_inb.inb907 = g_ohb.ohb915
   END IF
   LET l_inb.inb10 = 'N'
   
   CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_img09)
      RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN LET l_factor = 1 END IF
   LET l_inb.inb906 = l_factor
   LET l_inb.inb930 = s_costcenter(l_ina.ina04)
   LET l_inb.inb16 = l_inb.inb09
   LET l_inb.inb922 = l_inb.inb902
   LET l_inb.inb923 = l_inb.inb903
   LET l_inb.inb924 = l_inb.inb904
   LET l_inb.inb925 = l_inb.inb905
   LET l_inb.inb926 = l_inb.inb906
   LET l_inb.inb927 = l_inb.inb907
  #LET l_inb.inbplant = g_plant   #TQC-BB0161 mark
  #LET l_inb.inblegal = g_legal   #TQC-BB0161 mark
   LET l_inb.inbplant = g_azw01   #TQC-BB0161 add
   LET l_inb.inblegal = g_azw02   #TQC-BB0161 add 
   LET l_inb.inbud13 = NULL
   LET l_inb.inbud14 = NULL
   LET l_inb.inbud15 = NULL
   
   #FUN-CB0087-xj---add---str
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(l_ina.ina01,l_ina.ina10,'',l_inb.inb04,l_inb.inb05,l_ina.ina04,l_ina.ina11) RETURNING l_inb.inb15
      IF cl_null(l_inb.inb15) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   #FUN-CB0087-xj---add---end

   INSERT INTO inb_file VALUES(l_inb.*)
   IF STATUS THEN
      CALL s_errmsg('inb01',l_ina.ina01,'inb_ins',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_inbi.* TO NULL
         LET l_inbi.inbi01 = l_inb.inb01
         LET l_inbi.inbi03 = l_inb.inb03
         IF NOT s_ins_inbi(l_inbi.*,l_inb.inbplant) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF 
#FUN-B70074--add--insert--
   END IF
   IF l_ina.ina00 MATCHES '[12]' THEN
      LET l_type = -1
   ELSE
      LET l_type = 1
   END IF

   #FUN-C50090 Add Begin ---
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM img_file
    WHERE img01 = l_inb.inb04 AND img02 = l_inb.inb05
      AND img03 = l_inb.inb06 AND img04 = l_inb.inb07
   IF l_cnt = 0 THEN 
       CALL s_add_img(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,l_inb.inb01,l_inb.inb03,l_ina.ina02)
       IF g_errno = 'N' THEN
          LET g_success = 'N'
          RETURN
       END IF
   END IF
   #FUN-C50090 Add End -----

   CALL s_upimg(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                l_type,l_inb.inb09*l_inb.inb08_fac,l_ina.ina02,'','','','',
                l_inb.inb01,l_inb.inb03,'','','','','','','','','','','','')
   IF l_ina.ina00 MATCHES '[12]' THEN 
      CALL t620sub1_tlf(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                        l_inb.inb09*l_inb.inb08_fac,'2',              
                        l_inb.inb11,'',l_inb.inb01,l_inb.inb03,
                        l_inb.inb08,l_inb.inb08_fac,l_ina.ina04)
   END IF 
   IF l_ina.ina00 MATCHES '[34]'  THEN                  
      CALL t620sub1_tlf(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                        l_inb.inb09*l_inb.inb08_fac,'1',
                        l_inb.inb01,l_inb.inb03,l_inb.inb11,'',
                        l_inb.inb08,l_inb.inb08_fac,l_ina.ina04)
   END IF                    
   #多單位處理
   SELECT ima906,ima25 INTO l_ima906,l_ima25 FROM ima_file WHERE ima01 =  l_inb.inb04
   IF l_ima906 = '2' THEN
      IF NOT cl_null(l_inb.inb905) THEN
         CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
                       l_inb.inb07,l_inb.inb905,l_type,
                       l_inb.inb907,l_ina.ina02,l_inb.inb04,
                       l_inb.inb05,l_inb.inb06,l_inb.inb07,
                       '',l_ina.ina01,l_inb.inb03,'',l_inb.inb905,
                       '',l_imgg21,'','','','','','','',l_inb.inb906)
         IF l_ina.ina00 MATCHES '[12]' THEN 
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'2',
                               l_inb.inb01,l_inb.inb03,l_inb.inb11,'',
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
         IF l_ina.ina00 MATCHES '[34]' THEN                  
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'1',
                               l_inb.inb11,'',l_inb.inb01,l_inb.inb03,
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
      END IF
      IF NOT cl_null(l_inb.inb902) THEN
         CALL s_umfchk(l_inb.inb04,l_inb.inb902,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
                       l_inb.inb07,l_inb.inb902,l_type,
                       l_inb.inb904,l_ina.ina02,l_inb.inb04,
                       l_inb.inb05,l_inb.inb06,l_inb.inb07,
                       '',l_ina.ina01,l_inb.inb03,'',l_inb.inb902,
                       '',l_imgg21,'','','','','','','',l_inb.inb903)
         IF l_ina.ina00 MATCHES '[12]' THEN 
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'2',
                               l_inb.inb01,l_inb.inb03,l_inb.inb11,'',
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
         IF l_ina.ina00 MATCHES '[34]' THEN                  
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'1',
                               l_inb.inb11,'',l_inb.inb01,l_inb.inb03,
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
      END IF
   END IF
   IF l_ima906 = '3' THEN
      IF NOT cl_null(l_inb.inb905) THEN
         CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
           l_inb.inb07,l_inb.inb905,l_type,l_inb.inb907,
           l_ina.ina02,l_inb.inb04,l_inb.inb05,
           l_inb.inb06,l_inb.inb07,'',l_ina.ina01,
           l_inb.inb03,'',l_inb.inb905,'',l_imgg21,'',
           '','','','','','',l_inb.inb906)
         IF l_ina.ina00 MATCHES '[12]' THEN 
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'2',
                               l_inb.inb01,l_inb.inb03,l_inb.inb11,'',
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
         IF l_ina.ina00 MATCHES '[34]' THEN                  
            CALL t620sub1_tlff(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                               l_inb.inb09*l_inb.inb08_fac,'1',
                               l_inb.inb11,'',l_inb.inb01,l_inb.inb03,
                               l_inb.inb08,l_inb.inb08_fac,l_ina.ina04,'')
         END IF 
      END IF
   END IF
END FUNCTION

FUNCTION t620sub1_tlf(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_factor,p_gov)
 DEFINE p_part   LIKE img_file.img01,   ##料件編號(p_part)
        p_ware   LIKE img_file.img02,   ##倉庫
        p_loca   LIKE img_file.img03,   ##儲位
        p_lot    LIKE img_file.img04,   ##批號
        p_qty    LIKE img_file.img10,   ##數量
        p_sta    LIKE type_file.chr1,   ##1.雜收2.雜發3.收貨4.入庫5.倉退
        p_no     LIKE inb_file.inb01,   ##单据编号
        p_no1    LIKE inb_file.inb03,   ##单据项次
        p_no2    LIKE inb_file.inb11,   ##单据编号(参考号码) 
        p_no3    LIKE inb_file.inb03,   ##单据项次
        p_factor LIKE ima_file.ima31_fac,  ##轉換率
        p_unit   LIKE ima_file.ima25,   ##單位
        p_gov    LIKE ina_file.ina04,   ##部門    
        l_ima25  LIKE ima_file.ima25,
        l_ima86  LIKE ima_file.ima86,
        l_sta    LIKE type_file.num5,
        l_cnt    LIKE type_file.num5
   
   INITIALIZE g_tlf.* TO NULL
   LET g_tlf.tlf01=p_part        #異動料件編號
   SELECT ima25,ima86 INTO l_ima25,l_ima86 FROM ima_file WHERE ima01 = p_part
   CASE p_sta
      WHEN '1'  #雜收
       LET g_tlf.tlf02=90
       LET g_tlf.tlf026=p_no
       LET g_tlf.tlf03=50
      #LET g_tlf.tlf030=g_plant  #TQC-BB0161 mark
       LET g_tlf.tlf030=g_azw01  #TQC-BB0161 add
       LET g_tlf.tlf031=p_ware 
       LET g_tlf.tlf032=p_loca 
       LET g_tlf.tlf033=p_lot 
       LET g_tlf.tlf035=p_unit
       LET g_tlf.tlf036=p_no
       LET g_tlf.tlf037=p_no1        
       LET g_tlf.tlf026=p_no2
      WHEN '2'  #雜發
       LET g_tlf.tlf02=50          
      #LET g_tlf.tlf020=g_plant  #TQC-BB0161 mark
       LET g_tlf.tlf020=g_azw01  #TQC-BB0161 add
       LET g_tlf.tlf021=p_ware     
       LET g_tlf.tlf022=p_loca      
       LET g_tlf.tlf023=p_lot      
       LET g_tlf.tlf024=' '
       LET g_tlf.tlf025=p_unit     
       LET g_tlf.tlf026=p_no2      
       LET g_tlf.tlf027=p_no3      
       LET g_tlf.tlf03=90          
      #LET g_tlf.tlf030=g_plant    #TQC-BB0161 mark
       LET g_tlf.tlf030=g_azw01    #TQC-BB0161 add
       LET g_tlf.tlf031=' '        
       LET g_tlf.tlf032=' '        
       LET g_tlf.tlf033=' '        
       LET g_tlf.tlf034=' '
       LET g_tlf.tlf035=' '        
       LET g_tlf.tlf036=p_no       
       LET g_tlf.tlf037=' '
      WHEN '3'  #收貨
       LET g_tlf.tlf02=11
      #LET g_tlf.tlf020=g_plant    #TQC-BB0161 mark
       LET g_tlf.tlf020=g_azw01    #TQC-BB0161 add
       LET g_tlf.tlf021=' '
       LET g_tlf.tlf022=' '
       LET g_tlf.tlf023=' '
       LET g_tlf.tlf024=' '
       LET g_tlf.tlf025=' '
       LET g_tlf.tlf03=20
      #LET g_tlf.tlf030=g_plant    #TQC-BB0161 mark
       LET g_tlf.tlf030=g_azw01    #TQC-BB0161 add
       LET g_tlf.tlf031=p_ware
       LET g_tlf.tlf032=p_loca 
       LET g_tlf.tlf033=p_lot
       LET g_tlf.tlf034='' 
       LET g_tlf.tlf035='' 
       LET g_tlf.tlf036=p_no2
       LET g_tlf.tlf037=p_no3
      WHEN '4'  #入庫
       LET g_tlf.tlf02=20
      #LET g_tlf.tlf020=g_plant   #TQC-BB0161  mark
       LET g_tlf.tlf020=g_azw01   #TQC-BB0161 add
       LET g_tlf.tlf021=' '
       LET g_tlf.tlf022=' '
       LET g_tlf.tlf023=' '
       LET g_tlf.tlf024=' '
       LET g_tlf.tlf025=' '
       LET g_tlf.tlf026=p_no
       LET g_tlf.tlf027=p_no1
       LET g_tlf.tlf03=50
       LET g_tlf.tlf031=p_ware 
       LET g_tlf.tlf032=p_loca
       LET g_tlf.tlf033=p_lot 
       LET g_tlf.tlf034 = ' '
       LET g_tlf.tlf035 = l_ima25
       LET g_tlf.tlf036=p_no2
       LET g_tlf.tlf037=p_no3
      WHEN '5'  #倉退
       LET g_tlf.tlf02 = 50
      #LET g_tlf.tlf020=g_plant   #TQC-BB0161 mark
       LET g_tlf.tlf020=g_azw01   #TQC-BB0161 add 
       LET g_tlf.tlf021=p_ware 
       LET g_tlf.tlf022=p_loca
       LET g_tlf.tlf023=p_lot 
       LET g_tlf.tlf024 = ' '
       LET g_tlf.tlf025 = l_ima25
       LET g_tlf.tlf026=p_no
       LET g_tlf.tlf027=p_no1
       LET g_tlf.tlf03=31
       LET g_tlf.tlf031=' '
       LET g_tlf.tlf032=' '
       LET g_tlf.tlf033=' '
       LET g_tlf.tlf034=' '
       LET g_tlf.tlf035=' '
       LET g_tlf.tlf036=p_no2
       LET g_tlf.tlf037=p_no3
   END CASE
   LET g_tlf.tlf04= ' '
   LET g_tlf.tlf05= ' ' 
  #TQC-B90235 Add&Mark Begin ---
  #LET g_tlf.tlf06=g_today
  #LET g_tlf.tlf07=g_today

   LET g_tlf.tlf06=g_alter_date
  #LET g_tlf.tlf07=g_alter_date #FUN-C50090 Mark
   LET g_tlf.tlf07=g_today      #FUN-C50090 Add
  #TQC-B90235 Add&Mark End -----
   LET g_tlf.tlf08=TIME
   LET g_tlf.tlf09=g_user
   LET g_tlf.tlf10=p_qty

   CASE p_sta
      WHEN '1'  #雜收
         LET g_tlf.tlf11=p_unit
         LET g_tlf.tlf12=p_factor
      WHEN '2'  #雜發
         LET g_tlf.tlf11=p_unit
         LET g_tlf.tlf12=p_factor
      WHEN '3'  #收貨
         LET g_tlf.tlf11=p_unit
         LET g_tlf.tlf12=p_factor
      WHEN '4'  #入庫
         LET g_tlf.tlf11=p_unit
         LET g_tlf.tlf12=p_factor
      WHEN '5'  #倉退
         LET g_tlf.tlf11=p_unit
         LET g_tlf.tlf12=p_factor
   END CASE

   CASE p_sta
      WHEN '1'  #雜收
         LET g_tlf.tlf13='aimt302'
      WHEN '2'  #雜發
         LET g_tlf.tlf13='aimt301'
      WHEN '3'  #收貨
         LET g_tlf.tlf13='apmt1101'
      WHEN '4'  #入庫
         LET g_tlf.tlf13='apmt150'
      WHEN '5'  #倉退
    #     LET g_tlf.tlf13='apmt150'      #FUN-BA0087 mark
        #LET g_tlf.tlf13='apmt1702'      #FUN-BA0087 add   #TQC-BB0268 mark
         LET g_tlf.tlf13='apmt1072'      #TQC-BB0268 add
   END CASE

   LET g_tlf.tlf17=' '

   CASE p_sta
      WHEN '1'  #雜收
         LET g_tlf.tlf19=p_gov  
         LET g_tlf.tlf60=p_factor
      WHEN '2'  #雜發 
         LET g_tlf.tlf19=p_gov
         LET g_tlf.tlf60=p_factor
      WHEN '3'  #收貨
         LET g_tlf.tlf19=p_gov
         LET g_tlf.tlf60=p_factor
      WHEN '4'  #入庫
         LET g_tlf.tlf19=p_gov
         LET g_tlf.tlf60=p_factor
      WHEN '5'  #倉退
        LET g_tlf.tlf19=p_gov
        LET g_tlf.tlf60=p_factor
   END CASE

   LET g_tlf.tlf20=' '
   LET g_tlf.tlf61= l_ima86

   CASE
      WHEN g_tlf.tlf02=50 
         LET g_tlf.tlf902=g_tlf.tlf021
         LET g_tlf.tlf903=g_tlf.tlf022
         LET g_tlf.tlf904=g_tlf.tlf023
         LET g_tlf.tlf905=g_tlf.tlf026
         LET g_tlf.tlf906=g_tlf.tlf027
         LET g_tlf.tlf907=-1
      WHEN g_tlf.tlf03=50 
         LET g_tlf.tlf902=g_tlf.tlf031
         LET g_tlf.tlf903=g_tlf.tlf032
         LET g_tlf.tlf904=g_tlf.tlf033
         LET g_tlf.tlf905=g_tlf.tlf036
         LET g_tlf.tlf906=g_tlf.tlf037
         LET g_tlf.tlf907=1
      OTHERWISE
         LET g_tlf.tlf902=' '
         LET g_tlf.tlf903=' '
         LET g_tlf.tlf904=' '
         LET g_tlf.tlf905=' '
         LET g_tlf.tlf906=' '
         LET g_tlf.tlf907=0
   END CASE

  #MOD-C60093 str add-----
   IF NOT cl_null(g_tlf.tlf902) THEN
     SELECT imd09 INTO g_tlf.tlf901
       FROM imd_file
      WHERE imd01=g_tlf.tlf902
        AND imdacti = 'Y'
      
     IF g_tlf.tlf901 IS NULL THEN LET g_tlf.tlf901=' ' END IF
   ELSE
     LET g_tlf.tlf901=' '
   END IF
  #MOD-C60093 end add-----

  #LET g_tlf.tlfplant= g_plant    #TQC-BB0161 mark
  #LET g_tlf.tlflegal= g_legal    #TQC-BB0161 mark
   LET g_tlf.tlfplant= g_azw01    #TQC-BB0161 add
   LET g_tlf.tlflegal= g_azw02    #TQC-BB0161 add    

   IF (g_tlf.tlf02=50 OR g_tlf.tlf03=50) THEN
     #IF NOT s_tlfidle(g_plant,g_tlf.*) THEN        #更新呆滯日期    #TQC-BB0161 mark
      IF NOT s_tlfidle(g_azw01,g_tlf.*) THEN        #更新呆滯日期    #TQC-BB0161 add
         CALL cl_err('upd ima902:','9050',1)
         LET g_success='N'
      END IF
   END IF
   LET g_tlf.tlf012=' '
   LET g_tlf.tlf013=0
   SELECT sma53 INTO g_sma.sma53 FROM sma_file
   IF g_sma.sma53 IS NOT NULL AND g_tlf.tlf06 <= g_sma.sma53 THEN
      CALL cl_err('','mfg9999',1)
      LET g_success = 'N'
   END IF
   INSERT INTO tlf_file VALUES (g_tlf.*)
   IF SQLCA.sqlcode THEN
     #CALL cl_err3("ins","tlf_file",'','',SQLCA.sqlcode,"","",1)
      CALL s_errmsg('tlf01',g_tlf.tlf01,'tlf_ins',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF      
   #FUN-BC0062 ------Begin------
   IF NOT s_tlf_mvcost('') THEN
      RETURN
   END IF
   #FUN-BC0062 ------End--------
END FUNCTION

FUNCTION t620sub1_tlff(p_part,p_ware,p_loca,p_lot,p_qty,p_sta,p_no,p_no1,p_no2,p_no3,p_unit,p_fac,p_gov,p_tlff219)
 DEFINE p_part     LIKE img_file.img01,   ##料件編號(p_part)
        p_ware     LIKE img_file.img02,   ##倉庫
        p_loca     LIKE img_file.img03,   ##儲位
        p_lot      LIKE img_file.img04,   ##批號
        p_qty      LIKE img_file.img10,   ##數量
        p_sta      LIKE type_file.chr1,   ##1.雜收2.雜發3.收貨4.入庫5.倉退
        p_no       LIKE inb_file.inb01,   ##单据编号
        p_no1      LIKE inb_file.inb03,   ##单据项次
        p_no2      LIKE inb_file.inb11,   ##单据编号(参考号码) 
        p_no3      LIKE inb_file.inb03,   ##单据项次
        p_fac      LIKE ima_file.ima31_fac,  ##轉換率
        p_unit     LIKE ima_file.ima25,   ##單位
        p_gov      LIKE ina_file.ina04,   ##部門 
        p_tlff219  LIKE tlff_file.tlff219, ##單位別(1.第二單位   2.第一單位)   
        l_ima25    LIKE ima_file.ima25,
        l_imgg10   LIKE imgg_file.imgg10,
        l_sta      LIKE type_file.num5,
        l_cnt      LIKE type_file.num5

   LET g_tlff.tlff01=p_part
   SELECT imgg10 INTO l_imgg10 FROM img_file
    WHERE img01 = p_part
      AND img02 = p_ware
      AND img03 = p_loca
      AND img04 = p_lot
   CASE p_sta
      WHEN '1'  #雜收
         LET g_tlff.tlff02=90
         LET g_tlff.tlff026=p_no
         LET g_tlff.tlff03=50
        #LET g_tlff.tlff030=g_plant   #TQC-BB0161 mark
         LET g_tlff.tlff030=g_azw01   #TQC-BB0161 add 
         LET g_tlff.tlff031=p_ware 
         LET g_tlff.tlff032=p_loca 
         LET g_tlff.tlff033=p_lot 
         LET g_tlff.tlff035=p_unit
         LET g_tlff.tlff036=p_no2
         LET g_tlff.tlff037=p_no3         
      WHEN '2'  #雜發
         LET g_tlff.tlff02=50
        #LET g_tlff.tlff020=g_plant   #TQC-BB0161 mark
         LET g_tlff.tlff020=g_azw01   #TQC-BB0161 add 
         LET g_tlff.tlff021=p_ware
         LET g_tlff.tlff022=p_loca
         LET g_tlff.tlff023=p_lot
         LET g_tlff.tlff024=l_imgg10
         LET g_tlff.tlff025=p_unit
         LET g_tlff.tlff026=p_no
         LET g_tlff.tlff027=p_no1
         LET g_tlff.tlff03=50
         LET g_tlff.tlff036=p_no2
      WHEN '3'  #收貨
         LET g_tlff.tlff02=11
        #LET g_tlff.tlff020=g_plant   #TQC-BB0161 mark
         LET g_tlff.tlff020=g_azw01   #TQC-BB0161 add  
         LET g_tlff.tlff021=''
         LET g_tlff.tlff022=''
         LET g_tlff.tlff023=''
         LET g_tlff.tlff024=''
         LET g_tlff.tlff025=''
         LET g_tlff.tlff026=p_no
         LET g_tlff.tlff027=p_no1
         LET g_tlff.tlff03 =20
        #LET g_tlff.tlff030=g_plant   #TQC-BB0161 mark
         LET g_tlff.tlff030=g_azw01   #TQC-BB0161 add 
         LET g_tlff.tlff031=p_ware
         LET g_tlff.tlff032=p_loca
         LET g_tlff.tlff033=p_lot
         LET g_tlff.tlff034=''
         LET g_tlff.tlff035=''
         LET g_tlff.tlff036=p_no2
         LET g_tlff.tlff037=p_no3
      WHEN '4'  #入庫
        #LET g_tlff.tlff020=g_plant   #TQC-BB0161 mark
         LET g_tlff.tlff020=g_azw01   #TQC-BB0161 add 
         LET g_tlff.tlff02  = 20
         LET g_tlff.tlff021 = ' '
         LET g_tlff.tlff022 = ' '
         LET g_tlff.tlff023 = ' '
         LET g_tlff.tlff024 = ' '
         LET g_tlff.tlff025 = ' '
         LET g_tlff.tlff026 = p_no
         LET g_tlff.tlff027 = p_no1
         LET g_tlff.tlff03=50 
         LET g_tlff.tlff031=p_ware
         LET g_tlff.tlff032=p_loca
         LET g_tlff.tlff033=p_lot
         LET g_tlff.tlff035=l_ima25
         LET g_tlff.tlff036=p_no2
         LET g_tlff.tlff037=p_no3
      WHEN '5'  #倉退
        #LET g_tlff.tlff020=g_plant   #TQC-BB0161 mark
         LET g_tlff.tlff020=g_azw01   #TQC-BB0161 add 
         LET g_tlff.tlff02 = 50
         LET g_tlff.tlff021=p_ware
         LET g_tlff.tlff022=p_loca
         LET g_tlff.tlff023=p_lot
         LET g_tlff.tlff025 = l_ima25
         LET g_tlff.tlff026 = p_no
         LET g_tlff.tlff027 = p_no1
         LET g_tlff.tlff03=31
         LET g_tlff.tlff031=' '
         LET g_tlff.tlff032=' '
         LET g_tlff.tlff033=' '
         LET g_tlff.tlff035=' '
         LET g_tlff.tlff036=p_no2
         LET g_tlff.tlff037=p_no3
   END CASE
     
   LET g_tlff.tlff04= ' '
   LET g_tlff.tlff05= ' '
  #TQC-B90235 Add&Mark Begin ---
  #LET g_tlff.tlff06=g_today
  #LET g_tlff.tlff07=g_today

   LET g_tlff.tlff06=g_alter_date
   LET g_tlff.tlff07=g_alter_date
  #TQC-B90235 Add&Mark End -----
   LET g_tlff.tlff08=TIME
   LET g_tlff.tlff09=g_user
   LET g_tlff.tlff10=p_qty
   LET g_tlff.tlff11=p_unit
   LET g_tlff.tlff12=p_fac
   LET g_tlff.tlff219=p_tlff219
   LET g_tlff.tlff220=p_unit
     
   CASE p_sta
      WHEN '1'  #雜收
         LET g_tlff.tlff13='aimt302'
      WHEN '2'  #雜發
         LET g_tlff.tlff13='aimt301'
      WHEN '3'  #收貨
         LET g_tlff.tlff13='apmt1101'
      WHEN '4'  #入庫
         LET g_tlff.tlff13='apmt150'
      WHEN '5'  #倉退
         LET g_tlff.tlff13='apmt150'
   END CASE
     
   LET g_tlff.tlff14=' '
   LET g_tlff.tlff17=' '
     
   CASE p_sta
      WHEN '1'  #雜收
         LET g_tlff.tlff19=p_gov
      WHEN '2'  #雜發
         LET g_tlff.tlff19=p_gov
      WHEN '3'  #收貨
         LET g_tlff.tlff19=p_gov
      WHEN '4'  #入庫
         LET g_tlff.tlff19=p_gov
      WHEN '5'  #倉退
         LET g_tlff.tlff19=p_gov
   END CASE
   LET g_tlff.tlff20=' '
   LET g_tlff.tlff60=1
   CASE
       WHEN g_tlff.tlff02=50 
          LET g_tlff.tlff902=g_tlff.tlff021
          LET g_tlff.tlff903=g_tlff.tlff022
          LET g_tlff.tlff904=g_tlff.tlff023
          LET g_tlff.tlff905=g_tlff.tlff026
          LET g_tlff.tlff906=g_tlff.tlff027
          LET g_tlff.tlff907=-1
       WHEN g_tlff.tlff03=50 
          LET g_tlff.tlff902=g_tlff.tlff031
          LET g_tlff.tlff903=g_tlff.tlff032
          LET g_tlff.tlff904=g_tlff.tlff033
          LET g_tlff.tlff905=g_tlff.tlff036
          LET g_tlff.tlff906=g_tlff.tlff037
          LET g_tlff.tlff907=1
       OTHERWISE
          LET g_tlff.tlff902=' '
          LET g_tlff.tlff903=' '
          LET g_tlff.tlff904=' '
          LET g_tlff.tlff905=' '
          LET g_tlff.tlff906=0
          LET g_tlff.tlff907=0
   END CASE
     
  #LET g_tlff.tlffplant= g_plant    #TQC-BB0161 mark
  #LET g_tlff.tlfflegal= g_legal    #TQC-BB0161 mark
   LET g_tlff.tlffplant= g_azw01    #TQC-BB0161 add
   LET g_tlff.tlfflegal= g_azw02    #TQC-BB0161 add
   LET g_tlff.tlff012=' '
   LET g_tlff.tlff013=0
   INSERT INTO tlff_file VALUES (g_tlff.*)
END FUNCTION      

FUNCTION t620sub1_insrvurvv(p_type,p_rvu00,p_rty05)
 DEFINE p_type       LIKE type_file.chr1
 DEFINE p_rvu00      LIKE rvu_file.rvu01
 DEFINE p_rty05      LIKE rty_file.rty05
 DEFINE p_pmc        RECORD LIKE pmc_file.*
 DEFINE l_rvu        RECORD LIKE rvu_file.*
 DEFINE l_rvv        RECORD LIKE rvv_file.*
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE li_result    LIKE type_file.num5
 DEFINE l_img09      LIKE img_file.img09
 DEFINE l_type       LIKE type_file.num5
 DEFINE l_ima25      LIKE ima_file.ima25
 DEFINE l_ima906     LIKE ima_file.ima906
 DEFINE l_imd10      LIKE imd_file.imd10
 DEFINE l_imd11      LIKE imd_file.imd11
 DEFINE l_imd12      LIKE imd_file.imd12
 DEFINE l_imd13      LIKE imd_file.imd13
 DEFINE l_imd14      LIKE imd_file.imd14
 DEFINE l_imd15      LIKE imd_file.imd15
 DEFINE l_imgg21     LIKE imgg_file.imgg21
 DEFINE l_ima02      LIKE ima_file.ima02
 DEFINE l_ima44      LIKE ima_file.ima44
 DEFINE l_ima908     LIKE ima_file.ima908
 DEFINE l_factor     LIKE type_file.num5
 DEFINE l_azi10      LIKE azi_file.azi10 #FUN-B60150 ADD

   IF p_type = '1' THEN
      LET g_sql = "SELECT * ",
                 #"  FROM ",cl_get_target_table(g_plant,'rvu_file'),   #TQC-BB0161 mark
                  "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),   #TQC-BB0161 add
                  " WHERE rvu00 = '",p_rvu00,"'",
                  "   AND rvu25 = '",g_oga.oga01,"'",
                  "   AND rvu04 = '",p_rty05,"' "
  #ELSE    #FUN-B60150 MARK
   END IF  #FUN-B60150 ADD
   IF p_type = '2' THEN  #FUN-B60150 ADD
      LET g_sql = "SELECT * ",
                 #"  FROM ",cl_get_target_table(g_plant,'rvu_file'),   #TQC-BB0161 mark
                  "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),   #TQC-BB0161 add 
                  " WHERE rvu00 = '",p_rvu00,"'",
                  "   AND rvu25 = '",g_oha.oha01,"'",
                  "   AND rvu04 = '",p_rty05,"' "
   END IF

#FUN-B60150 ADD - BEGIN -------------------------------------------
   IF p_type = '3' THEN
      LET g_sql = "SELECT * ",
                 #"  FROM ",cl_get_target_table(g_plant,'rvu_file'),   #TQC-BB0161 mark
                  "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),   #TQC-BB0161 add
                  " WHERE rvu00 = '",p_rvu00,"'",
                  "   AND rvu25 = '",g_rvc.rvc01,"'",
                  "   AND rvu04 = '",p_rty05,"' "
   END IF
#FUN-B60150 ADD -  END  -------------------------------------------
    
   PREPARE t620sub1_sel_rvu FROM g_sql
   EXECUTE t620sub1_sel_rvu INTO l_rvu.*
  #IF cl_null(g_rvu04) OR p_rty05 <> g_rvu04 THEN     #FUN-B60150 MARK
   IF cl_null(g_rvu04) OR p_rty05 <> g_rvu04 OR cl_null(l_rvu.rvu04) THEN     #FUN-B60150 ADD
     #IF p_type MATCHES '[1]' THEN #FUN-BB0072 Mark
     #IF (p_type ='1' AND g_ogb.ogb14t > 0) OR (p_type = '2' AND g_ohb.ohb14t < 0) THEN #FUN-BB0072 Add  #FUN-C10007 mark
      IF (p_type ='1' AND g_ogb.ogb14t >= 0) OR (p_type = '2' AND g_ohb.ohb14t <= 0) THEN   #FUN-C10007 add
         LET l_rvu.rvu00 = '1'
         IF g_prog !='apcp200' THEN #FUN-C80045 add
            #FUN-C90050 mark begin---
            #SELECT rye03 INTO l_rvu.rvu01 FROM rye_file
            # WHERE rye01 = 'apm'
            #   AND rye02 = '7'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('apm','7',g_plant,'N') RETURNING l_rvu.rvu01   #FUN-C90050 add
         #FUN-C80045 add sta
         ELSE
            #FUN-C90050 mark begin--- 
            #SELECT rye04 INTO l_rvu.rvu01 FROM rye_file
            # WHERE rye01 = 'apm'
            #   AND rye02 = '7'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('apm','7',g_plant,'Y') RETURNING l_rvu.rvu01   #FUN-C90050 add
         END IF 
         #FUN-C80045 add end           
         IF cl_null(l_rvu.rvu01) THEN
            CALL s_errmsg('rvu01',l_rvu.rvu01,'sel_rye','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'7',"rvu_file","rvu01","","","")
            RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
     #ELSE    #FUN-B60150 MARK
      END IF  #FUN-B60150 ADD
     #IF p_type = '2' THEN #FUN-B60150 ADD #FUN-BB0072 Mark
      IF (p_type = '2' AND g_ohb.ohb14t > 0) OR (p_type ='1' AND g_ogb.ogb14t < 0) THEN #FUN-BB0072 Add
         LET l_rvu.rvu00 = '3'
         IF g_prog !='apcp200' THEN #FUN-C80045 add
            #FUN-C90050 mark begin---
            #SELECT rye03 INTO l_rvu.rvu01 FROM rye_file
            # WHERE rye01 = 'apm'
            #   AND rye02 = '4'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('apm','4',g_plant,'N') RETURNING l_rvu.rvu01   #FUN-C90050 add
         #FUN-C80045 add sta
         ELSE 
            #FUN-C90050 mark begin---
            #SELECT rye04 INTO l_rvu.rvu01 FROM rye_file
            # WHERE rye01 = 'apm'
            #   AND rye02 = '4'
            #FUN-C90050 mark end-----
            CALL s_get_defslip('apm','4',g_plant,'Y') RETURNING l_rvu.rvu01   #FUN-C90050 add
         END IF 
         #FUN-C80045 add end      
        #PREPARE t620sub1_sel_rye3 FROM g_sql               #FUN-C90050 mark
        #EXECUTE t620sub1_sel_rye3 INTO l_rvu.rvu01         #FUN-C90050 mark
         IF cl_null(l_rvu.rvu01) THEN
            CALL s_errmsg('rvu01',l_rvu.rvu01,'sel_rye','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF
         CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'4',"rvu_file","rvu01","","","")
             RETURNING li_result,l_rvu.rvu01
         IF (NOT li_result) THEN
            LET g_success = 'N'
            RETURN
         END IF
      END IF

#FUN-B60150 ADD - BEGIN -------------------------------------
      IF p_type = '3' THEN
         IF p_rvu00 = '1' THEN
            LET l_rvu.rvu00 = '1'
            IF g_prog !='apcp200' THEN #FUN-C80045 add
               #FUN-C90050 mark bebegin---
               #SELECT rye03 INTO l_rvu.rvu01 FROM rye_file
               # WHERE rye01 = 'apm'
               #   AND rye02 = '7'
               #FUN-C90050 mark end-----

               CALL s_get_defslip('apm','7',g_plant,'N') RETURNING l_rvu.rvu01    #FUN-C90050 add
            #FUN-C80045 add sta
            ELSE
               #FUN-C90050 mark begin---
               #SELECT rye04 INTO l_rvu.rvu01 FROM rye_file
               # WHERE rye01 = 'apm'
               #   AND rye02 = '7'
               #FUN-C90050 mark end-----
               CALL s_get_defslip('apm','7',g_plant,'Y') RETURNING l_rvu.rvu01    #FUN-C90050 add
            END IF     
            #FUN-C80045 add end      
            IF cl_null(l_rvu.rvu01) THEN
               CALL s_errmsg('rvu01',l_rvu.rvu01,'sel_rye','art-330',1)
               LET g_success = 'N'
               RETURN
            END IF
            CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'7',"rvu_file","rvu01","","","")
               RETURNING li_result,l_rvu.rvu01
            IF (NOT li_result) THEN
               LET g_success = 'N'
               RETURN
            END IF
         ELSE
            LET l_rvu.rvu00 = '3'
            IF g_prog !='apcp200' THEN #FUN-C80045 add
               #FUN-C90050 mark begin---
               #SELECT rye03 INTO l_rvu.rvu01 FROM rye_file
               # WHERE rye01 = 'apm'
               #   AND rye02 = '4'
               #FUN-C90050 mark end-----

               CALL s_get_defslip('apm','4',g_plant,'N') RETURNING l_rvu.rvu01   #FUN-C90050 add
            #FUN-C80045 add sta      
            ELSE
               #FUN-C90050 mark begin--- 
               #SELECT rye04 INTO l_rvu.rvu01 FROM rye_file
               # WHERE rye01 = 'apm'
               #   AND rye02 = '4'    
               #FUN-C90050 mark end-----
               CALL s_get_defslip('apm','4',g_plant,'Y') RETURNING l_rvu.rvu01   #FUN-C90050 add
            END IF
            #FUN-C80045 add end      
            IF cl_null(l_rvu.rvu01) THEN
               CALL s_errmsg('rvu01',l_rvu.rvu01,'sel_rye','art-330',1)
               LET g_success = 'N'
               RETURN
            END IF
            CALL s_auto_assign_no("apm",l_rvu.rvu01,g_today,'4',"rvu_file","rvu01","","","")
                RETURNING li_result,l_rvu.rvu01
            IF (NOT li_result) THEN
               LET g_success = 'N'
               RETURN
            END IF
         END IF
      END IF
#FUN-B60150 ADD -  END  -------------------------------------
      
      LET g_rvu04 = p_rty05
      LET l_rvu.rvu04 = p_rty05
      SELECT pmc03,pmc17,pmc49,pmc22,pmc47
        INTO l_rvu.rvu05,l_rvu.rvu111,l_rvu.rvu112,
             l_rvu.rvu113,l_rvu.rvu115
        FROM pmc_file
       WHERE pmc01=l_rvu.rvu04
      
      SELECT gec04 INTO l_rvu.rvu12 FROM gec_file
       WHERE gec01=l_rvu.rvu115
         AND gec011='1'
      
     #SELECT rty12,rty04 INTO l_rvu.rvu22,l_rvu.rvu23
     #  FROM rty_file
     # WHERE rty01 = g_oga.ogaplant
     #   AND rty02 = p_rvg.ogb04
      
      LET l_rvu.rvupos = 'N'
      LET l_rvu.rvu02 = ''
     #LET l_rvu.rvu03 = g_today       #TQC-B90235 Mark
      LET l_rvu.rvu03 = g_alter_date  #TQC-B90235 Add
      LET l_rvu.rvu06 = g_grup
      LET l_rvu.rvu07 = g_user
      LET l_rvu.rvu08 = 'REG'
      LET l_rvu.rvu09 = ''
     #FUN-BB0044 Add&Mark Begin ---
     #LET l_rvu.rvu10 = 'N'

      IF p_rvu00 = '3'  THEN
         LET l_rvu.rvu10 = 'Y'
      ELSE
         LET l_rvu.rvu10 = 'N'
      END IF
     #FUN-BB0044 Add&Mark End -----
      LET l_rvu.rvu11 = NULL
      LET l_rvu.rvu102= NULL
      LET l_rvu.rvuud13 = NULL
      LET l_rvu.rvuud14 = NULL
      LET l_rvu.rvuud15 = NULL
      LET l_rvu.rvu20 = 'N'
      LET l_rvu.rvuconf = 'Y'
      LET l_rvu.rvucond = g_today
      LET l_rvu.rvuconu = g_user
      LET l_rvu.rvucont = TIME
      LET l_rvu.rvucrat = g_today
      LET l_rvu.rvuacti = 'Y'
      LET l_rvu.rvuuser = g_user
      LET l_rvu.rvugrup = g_grup
      LET l_rvu.rvudate = NULL
      IF g_aza.aza17 = l_rvu.rvu113 THEN
         LET l_rvu.rvu114 = 1
      ELSE
         CALL s_curr3(l_rvu.rvu113,g_today,g_sma.sma904)
            RETURNING l_rvu.rvu114
      END IF
      LET l_rvu.rvu116 = '1'
      LET l_rvu.rvu117 = ''
     #LET l_rvu.rvu21 = '3'   #FUN-B60150 MARK
#FUN-B60150 - ADD - BEGIN -----------------------------------
      IF p_type = '1' OR p_type = '2' THEN
         LET l_rvu.rvu21 = '1'        #TQC-BB0131 add
         IF g_ogb.ogb44 = '2' OR g_ohb.ohb64 = '2' THEN
           #LET l_rvu.rvu21 = '2' #FUN-BB0072 Mark
          # LET l_rvu.rvu21 = '1' #FUN-BB0072 Add   #TQC-BB0131 mark
            LET l_rvu.rvu27 = '2'
         END IF
         IF g_ogb.ogb44 = '3' OR g_ohb.ohb64 = '3' THEN
           #LET l_rvu.rvu21 = '3' #FUN-BB0072 Mark
          # LET l_rvu.rvu21 = '1' #FUN-BB0072 Add   #TQC-BB0131 mark
            LET l_rvu.rvu27 = '3'
         END IF
      END IF
      IF p_type = '3' THEN
         IF (l_rvu.rvu00 = '1' AND (g_rvg.ogb14t > 0))
            OR (l_rvu.rvu00 = '3' AND (g_rvg.ogb14t < 0)) THEN
            LET l_rvu.rvu21 = '1'
            LET l_rvu.rvu27 = '2'
         END IF
         IF (l_rvu.rvu00 = '3' AND (g_rvg.ogb14t > 0))
            OR (l_rvu.rvu00 = '1' AND (g_rvg.ogb14t < 0)) THEN
            LET l_rvu.rvu21 = '2'
            LET l_rvu.rvu27 = '2'
         END IF
      END IF
#FUN-B60150 - ADD -  END  -----------------------------------
      LET l_rvu.rvu900 = '1'
      LET l_rvu.rvu17  = '1'
      LET l_rvu.rvumksg = 'N'
      IF p_type = '1' THEN
         LET l_rvu.rvu25 = g_oga.oga01
     #ELSE  #FUN-B60150 MARK
      END IF                 #FUN-B60150 ADD
      IF p_type = '2' THEN   #FUN-B60150 ADD
         LET l_rvu.rvu25 = g_oha.oha01
      END IF
#FUN-B60150 ADD - BEGIN ---------------------
      IF p_type = '3' THEN
         LET l_rvu.rvu25 = g_rvc.rvc01
      END IF
#FUN-B60150 ADD -  END  ---------------------
     #LET l_rvu.rvuplant = g_plant    #TQC-BB0161 mark
     #LET l_rvu.rvulegal = g_legal    #TQC-BB0161 mark
      LET l_rvu.rvuplant = g_azw01    #TQC-BB0161 add
      LET l_rvu.rvulegal = g_azw02    #TQC-BB0161 add
      LET l_rvu.rvuoriu = g_user
      LET l_rvu.rvuorig = g_grup
     #LET l_rvu.rvu27   = '3'    #TQC-B60065  #FUN-B60150 MARK

      INSERT INTO rvu_file VALUES(l_rvu.*)
      IF STATUS THEN
         CALL s_errmsg('rvu01',l_rvu.rvu01,'rvu_ins',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   LET l_rvv.rvv01 = l_rvu.rvu01

   SELECT MAX(rvv02)+1 INTO l_rvv.rvv02
     FROM rvv_file
    WHERE rvv01 = l_rvv.rvv01
   IF cl_null(l_rvv.rvv02) THEN
      LET l_rvv.rvv02 = 1
   END IF
   LET l_rvv.rvv03 = l_rvu.rvu00
   LET l_rvv.rvv04 = ''
   LET l_rvv.rvv05 = ''
   LET l_rvv.rvv06 = l_rvu.rvu04
  #LET l_rvv.rvv09 = g_today       #TQC-B90235 Mark
   LET l_rvv.rvv09 = g_alter_date  #TQC-B90235 Add
   LET l_rvv.rvv18 = ''
   LET l_rvv.rvv23 = 0
   LET l_rvv.rvv25 = 'N'
   LET l_rvv.rvv26 = ''
   IF p_type = '1' THEN
     #LET l_rvv.rvv17 = g_ogb.ogb12        #FUN-BB0072 Mark
      LET l_rvv.rvv17 = s_abs(g_ogb.ogb12) #FUN-BB0072 Add
      LET l_rvv.rvv31 = g_ogb.ogb04
      LET l_rvv.rvv031 = g_ogb.ogb06
      LET l_rvv.rvv35 = g_ogb.ogb05
  #ELSE  #FUN-B60150 MARK
   END IF #FUN-B60150 ADD
   IF p_type = '2' THEN  #FUN-B60150 ADD
     #LET l_rvv.rvv17 = g_ohb.ohb12        #FUN-BB0072 Mark
      LET l_rvv.rvv17 = s_abs(g_ohb.ohb12) #FUN-BB0072 Add
      LET l_rvv.rvv31 = g_ohb.ohb04
      LET l_rvv.rvv031 = g_ohb.ohb06
      LET l_rvv.rvv35 = g_ohb.ohb05
   END IF
#FUN-B60150 ADD - BEGIN -------------------------
   IF p_type = '3' THEN
      LET l_rvv.rvv17 = g_rvg.rvg08
      LET l_rvv.rvv31 = g_rvg.ogb04
      LET g_sql = "SELECT ima02 ", 
                  "  FROM ",cl_get_target_table(g_rvg.rvg03, 'ima_file'),
                  " WHERE ima01='",g_rvg.ogb04,"'"
      PREPARE t620_sel_ima FROM g_sql
      EXECUTE t620_sel_ima INTO l_rvv.rvv031
      LET l_rvv.rvv32=''
      LET l_rvv.rvv35 = g_rvg.ogb05
   END IF
#FUN-B60150 ADD -  END  -------------------------
   IF p_type = '1' THEN
      SELECT rtz07 INTO l_rvv.rvv32 FROM rtz_file
       WHERE rtz01 = g_oga.ogaplant
  #ELSE  #FUN-B60150 MARK
   END IF #FUN-B60150 ADD
   IF p_type = '2' THEN  #FUN-B60150 ADD
      SELECT rtz07 INTO l_rvv.rvv32 FROM rtz_file
       WHERE rtz01 = g_oha.ohaplant
   END IF
#FUN-B60150 ADD - BEGIN -------------------------
   IF p_type = '3' THEN
     SELECT rtz07 INTO l_rvv.rvv32 FROM rtz_file
       WHERE rtz01 = g_rvg.rvg03
   END IF 
#FUN-B60150 ADD -  END  -------------------------
   LET l_rvv.rvv33 = ' '
   LET l_rvv.rvv34 = ' '
   CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv35,l_ima44)
      RETURNING l_cnt,l_factor
   IF l_cnt = 1 THEN LET l_factor = 1 END IF
   LET l_rvv.rvv35_fac = l_factor
   LET l_rvv.rvv36 = ''
   LET l_rvv.rvv37 = ''
   LET l_rvv.rvv40 = 'N'
   LET l_rvv.rvv41 = ''
   IF p_type = '1' THEN
      LET l_rvv.rvv80 = g_ogb.ogb910
      LET l_rvv.rvv81 = g_ogb.ogb911
      LET l_rvv.rvv82 = g_ogb.ogb912
      LET l_rvv.rvv83 = g_ogb.ogb913
      LET l_rvv.rvv84 = g_ogb.ogb914
      LET l_rvv.rvv85 = g_ogb.ogb915
      LET l_rvv.rvv86 = g_ogb.ogb916
     #LET l_rvv.rvv87 = g_ogb.ogb917        #FUN-BB0072 Mark
      LET l_rvv.rvv87 = s_abs(g_ogb.ogb917) #FUN-BB0072 Add
  #ELSE   #FUN-B60150 MARK
   END IF #FUN-B60150 ADD
   IF p_type = '2' THEN #FUN-B60150 ADD
      LET l_rvv.rvv80 = g_ohb.ohb910
      LET l_rvv.rvv81 = g_ohb.ohb911
      LET l_rvv.rvv82 = g_ohb.ohb912
      LET l_rvv.rvv83 = g_ohb.ohb913
      LET l_rvv.rvv84 = g_ohb.ohb914
      LET l_rvv.rvv85 = g_ohb.ohb915
      LET l_rvv.rvv86 = g_ohb.ohb916
     #LET l_rvv.rvv87 = g_ohb.ohb917        #FUN-BB0072 Mark
      LET l_rvv.rvv87 = s_abs(g_ohb.ohb917) #FUN-BB0072 Add
   END IF
#FUN-B60150 ADD - BEGIN -------------------------
   IF p_type = '3' THEN
      LET l_rvv.rvv80 = g_rvg.ogb05
      LET l_rvv.rvv81 = 1
      LET l_rvv.rvv82 = g_rvg.rvg08
      LET l_rvv.rvv83 = g_rvg.ogb05
      LET l_rvv.rvv84 = 1
      LET l_rvv.rvv85 = g_rvg.rvg08
      LET l_rvv.rvv86 = g_rvg.ogb05
      LET l_rvv.rvv87 = g_rvg.rvg08
   END IF
#FUN-B60150 ADD -  END  -------------------------
   SELECT azi03,azi04,azi10 INTO t_azi03,t_azi04,l_azi10
     FROM azi_file
    WHERE azi01=l_rvu.rvu113
   IF cl_null(t_azi03) THEN LET t_azi03=0 END IF
   IF cl_null(t_azi04) THEN LET t_azi04=0 END IF
  #CALL s_defprice_new(l_rvv.rvv31,l_rvu.rvu04,l_rvu.rvu113,g_today,l_rvv.rvv87,'',
  #                    l_rvu.rvu115,l_rvu.rvu12,'1',l_rvv.rvv86,'',l_rvu.rvu112,
  #                    l_rvu.rvu111,g_plant)
  #   RETURNING l_rvv.rvv38,l_rvv.rvv38t,l_rvv.rvv10,l_rvv.rvv11
   IF cl_null(l_rvv.rvv10) THEN LET l_rvv.rvv10 = '4' END IF
   IF p_type = '1' THEN
      #FUN-B60150 ADD - BEGIN --------------------------
      IF g_ogb.ogb44 = '2' AND g_sma.sma146 = '2' THEN
        #LET l_rvv.rvv39t = g_ogb.ogb14t        #FUN-BB0072 Mark
         LET l_rvv.rvv39t = s_abs(g_ogb.ogb14t) #FUN-BB0072 Add
         LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
         LET l_rvv.rvv38t = g_ogb.ogb13
         LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
      ELSE
      #FUN-B60150 ADD - END ----------------------------
         LET l_rvv.rvv39t = g_ogb.ogb14t*(g_oga.oga24/l_rvu.rvu114)*(1-g_ogb.ogb46/100)
         LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
         LET l_rvv.rvv39t = s_abs(l_rvv.rvv39t) #FUN-BB0072 Add
         LET l_rvv.rvv38t = l_rvv.rvv39t/g_ogb.ogb12
         LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
      END IF #FUN-B60150 ADD
  #ELSE   #FUN-B60150 MARK
   END IF #FUN-B60150 ADD
   IF p_type = '2' THEN #FUN-B60150 ADD
      #FUN-B60150 ADD - BEGIN --------------------------
      IF g_ohb.ohb64 = '2' AND g_sma.sma146 = '2' THEN
        #LET l_rvv.rvv39t = g_ohb.ohb14t        #FUN-BB0072 Mark
         LET l_rvv.rvv39t = s_abs(g_ohb.ohb14t) #FUN-BB0072 Add
         LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
         LET l_rvv.rvv38t = g_ohb.ohb13
         LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
      ELSE
      #FUN-B60150 ADD - END ----------------------------
         LET l_rvv.rvv39t = g_ohb.ohb14t*(g_oha.oha24/l_rvu.rvu114)*(1-g_ohb.ohb66/100)
         LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
         LET l_rvv.rvv39t = s_abs(l_rvv.rvv39t) #FUN-BB0072 Add
         LET l_rvv.rvv38t = l_rvv.rvv39t/g_ohb.ohb12
         LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
      END IF #FUN-B60150 ADD
   END IF
#FUN-B60150 ADD - BEGIN -------------------------------
   IF p_type = '3' THEN 
      LET l_rvv.rvv39t = g_rvv39t
      LET l_rvv.rvv39t= cl_digcut(l_rvv.rvv39t, t_azi04)
      LET l_rvv.rvv38t = l_rvv.rvv39t/g_rvf08
      LET l_rvv.rvv38t= cl_digcut(l_rvv.rvv38t, t_azi03)
   END IF
#FUN-B60150 ADD -  END  -------------------------------

   LET l_rvv.rvv39 = l_rvv.rvv39t / ( 1 + l_rvu.rvu12/100)
   LET l_rvv.rvv39 = cl_digcut(l_rvv.rvv39 , t_azi04)
   LET l_rvv.rvv38 = l_rvv.rvv38t / ( 1 + l_rvu.rvu12/100)
   LET l_rvv.rvv38 = cl_digcut( l_rvv.rvv38 , t_azi03)

   LET l_rvv.rvv88  = 0
   LET l_rvv.rvv89 = 'N'
   LET l_rvv.rvv930=s_costcenter(l_rvu.rvu06)
  #LET l_rvv.rvvplant = g_plant   #TQC-BB0161 mark
  #LET l_rvv.rvvlegal = g_legal   #TQC-BB0161 mark
   LET l_rvv.rvvplant = g_azw01   #TQC-BB0161 add
   LET l_rvv.rvvlegal = g_azw02   #TQC-BB0161 add
   LET l_rvv.rvvud13 = NULL
   LET l_rvv.rvvud14 = NULL
   LET l_rvv.rvvud15 = NULL
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      CALL s_reason_code(l_rvv.rvv01,l_rvv.rvv04,'',l_rvv.rvv31,l_rvv.rvv32,l_rvu.rvu07,l_rvu.rvu06) RETURNING l_rvv.rvv26
      IF cl_null(l_rvv.rvv26) THEN
         CALL cl_err('','aim-425',1)
         LET g_success = 'N'
         RETURN 
      END IF
   END IF
   #FUN-CB0087---add---end---
   
   INSERT INTO rvv_file VALUES(l_rvv.*)
   IF STATUS THEN
      CALL s_errmsg('rvv01',l_rvu.rvu01,'rvv_ins',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file 
    WHERE ima01 = l_rvv.rvv31
   SELECT imd10,imd11,imd12,imd13,imd14,imd15
     INTO l_imd10,l_imd11,l_imd12,l_imd13,l_imd14,l_imd15
     FROM imd_file 
    WHERE imd01 = l_rvv.rvv32
   IF l_rvu.rvu00 = '1' THEN 
      SELECT COUNT(*) INTO l_cnt FROM img_file 
       WHERE img01=l_rvv.rvv31
         AND img02=l_rvv.rvv32
         AND img03=l_rvv.rvv33
         AND img04=l_rvv.rvv34
      IF l_cnt = 0  THEN 
         INSERT INTO img_file(img01,img02,img03,img04,img09,img10,img17,
                              img18,img20,img21,img22,img23,img24,img25,
                              img27,img28,imgplant,imglegal)
         VALUES(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                l_ima25,0,g_today,g_lastdat,1,1,
                l_imd10,l_imd11,l_imd12,l_imd13,l_imd14,l_imd15,
               #g_plant,g_legal)    #TQC-BB0161 mark
                g_azw01,g_azw02)    #TQC-BB0161 add
      END IF 
      CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,+1,
                   l_rvv.rvv17*l_rvv.rvv35_fac,l_rvu.rvu03,l_rvv.rvv31,
                   l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv01,
                   l_rvv.rvv02,l_rvv.rvv35,l_rvv.rvv17,l_ima25,l_rvv.rvv35_fac,
                   1,'','','','','','','')
#      IF l_rvu.rvu00 = '1' THEN    #FUN-BA0087 mark
         CALL t620sub1_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
                           l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
                           l_rvv.rvv35_fac,l_rvv.rvv06)
#FUN-BA0087 mark START
#      END IF                       
#      IF l_rvu.rvu00 = '3' THEN 
#         CALL t620sub1_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
#                           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv01,
#                           l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
#                           l_rvv.rvv35_fac,l_rvv.rvv06)
#      END IF
#FUN-BA0087 mark END
   ELSE
      CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,0,
                   l_rvv.rvv17*l_rvv.rvv35_fac,l_rvv.rvv09,'','','',
                   '',l_rvv.rvv01,l_rvv.rvv02,'','','','','','','','',
                   0,0,'','')
#FUN-BA0087 mark START
#      IF l_rvu.rvu00 = '1' THEN
#         CALL t620sub1_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
#                           l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
#                           l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
#                           l_rvv.rvv35_fac,l_rvv.rvv06)
#      END IF 
#FUN-BA0087 mark END
      IF l_rvu.rvu00 = '3' THEN 
         CALL t620sub1_tlf(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                          l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
                          l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
                          l_rvv.rvv35_fac,l_rvv.rvv06)
      END IF
   END IF     
  #多單位處理
   IF l_rvu.rvu00='1' THEN
      LET l_type = +1
   ELSE
      LET l_type = 0
   END IF
   IF l_ima906 = '2' THEN  #子母單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
                       l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
                       '','','',l_rvv.rvv84)
         IF l_rvu.rvu00 = '1' THEN
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
                               l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
                               l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
            l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
            l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
            l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
      END IF
      IF NOT cl_null(l_rvv.rvv80) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv80,l_type,l_rvv.rvv82,l_rvu.rvu02,l_rvv.rvv31,
                       l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,'','','','',
                       l_rvv.rvv80,'',l_imgg21,'','','','','','','',
                       l_rvv.rvv81)
         IF l_rvu.rvu00 = '1' THEN
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
                               l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
                               l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                               l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
                               l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
                               l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF
      END IF
   END IF
   IF l_ima906 = '3' THEN  #參考單位
      IF NOT cl_null(l_rvv.rvv83) THEN
         CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
         CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
                       l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                       '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
                       '','','',l_rvv.rvv84)
         IF l_rvu.rvu00 = '1' THEN
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv17*l_rvv.rvv35_fac,'4',l_rvv.rvv04,
                              l_rvv.rvv05,l_rvv.rvv01,l_rvv.rvv02,l_rvv.rvv35,
                              l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
         IF l_rvu.rvu00 = '3' THEN 
            CALL t620sub1_tlff(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                              l_rvv.rvv17*l_rvv.rvv35_fac,'5',l_rvv.rvv01,
                              l_rvv.rvv02,l_rvv.rvv04,l_rvv.rvv05,l_rvv.rvv35,
                              l_rvv.rvv35_fac,l_rvv.rvv06,'')
         END IF 
      END IF
   END IF
END FUNCTION

FUNCTION t620sub1_z(p_type,p_oga01)
 DEFINE p_type   LIKE type_file.chr1
 DEFINE p_oga01  LIKE oga_file.oga01
 DEFINE l_cnt    LIKE type_file.num5
 DEFINE l_cnt1   LIKE type_file.num5
 DEFINE l_cnt2   LIKE type_file.num5
 DEFINE l_cnt3   LIKE type_file.num5   #FUN-B60150 ADD
 
   LET g_success = 'Y'
   LET l_cnt = 0
   LET l_cnt3 = 0  #FUN-B60150 ADD
   IF p_type = '1' THEN
      SELECT COUNT(*) INTO l_cnt FROM ogb_file
       WHERE ogb01 = p_oga01
         AND ogb44 = '3'
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM ohb_file
       WHERE ohb01 = p_oga01
         AND ohb64 = '3'
   END IF

#FUN-B60150 ADD - BEGIN ---------------------------
   IF g_sma.sma146 = '2' THEN
      IF p_type = '1' THEN
         SELECT COUNT(*) INTO l_cnt3 FROM ogb_file
          WHERE ogb01 = p_oga01
            AND ogb44 = '2'
      ELSE
         SELECT COUNT(*) INTO l_cnt3 FROM ohb_file
          WHERE ohb01 = p_oga01
            AND ohb64 = '2'
      END IF
   END IF
#FUN-B60150 ADD -  END  ---------------------------

  #IF l_cnt = 0 THEN RETURN END IF
   IF l_cnt = 0 AND l_cnt3 = 0 THEN RETURN END IF
   SELECT COUNT(*) INTO l_cnt
     FROM rvu_file
    WHERE rvu25 = p_oga01
   SELECT COUNT(*) INTO l_cnt1
     FROM rvw_file,rvu_file
    WHERE rvw08 = rvu01
      AND rvu25 = p_oga01
   SELECT COUNT(*) INTO l_cnt2
     FROM apb_file,rvu_file
    WHERE apb21 = rvu01
      AND rvu25 = p_oga01
   IF l_cnt > 0 THEN
      IF l_cnt1 > 0 OR l_cnt2 > 0 THEN
         CALL s_errmsg('rvu01','','rvu_file','asf-199',1)
         LET g_success = 'N'
         RETURN
      ELSE
         CALL t620sub1_z1(p_type,p_oga01)
         IF g_success = 'N' THEN RETURN END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION t620sub1_z1(p_type,p_oga01)
 DEFINE p_type       LIKE type_file.chr1
 DEFINE p_oga01      LIKE oga_file.oga01
 DEFINE l_rvu        RECORD LIKE rvu_file.*
 DEFINE l_rvv        RECORD LIKE rvv_file.*
 DEFINE l_ina        RECORD LIKE ina_file.*
 DEFINE l_inb        RECORD LIKE INb_file.* 
 DEFINE l_ina01      LIKE ina_file.ina01
 DEFINE l_rvu01      LIKE rvu_file.rvu01
 DEFINE l_rvuconf    LIKE rvu_file.rvuconf
 DEFINE l_rvaconf    LIKE rva_file.rvaconf
 DEFINE l_inapost    LIKE ina_file.inapost
 DEFINE l_cmd        LIKE type_file.chr1000
 DEFINE l_type       LIKE type_file.num5
 DEFINE l_ima25      LIKE ima_file.ima25
 DEFINE l_ima906     LIKE ima_file.ima906
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE l_imgg21     LIKE imgg_file.imgg21
 #FUN-BC0104-add-str--
 DEFINE l_rvv04  LIKE rvv_file.rvv04,
        l_rvv05  LIKE rvv_file.rvv05,
        l_rvv45  LIKE rvv_file.rvv45,
        l_rvv46  LIKE rvv_file.rvv46,
        l_rvv47  LIKE rvv_file.rvv47,
        l_flagg  LIKE type_file.chr1,
        l_rvv02  LIKE rvv_file.rvv02,
        l_qcl05  LIKE qcl_file.qcl05,
        l_type1  LIKE type_file.chr1
 DEFINE l_cn     LIKE  type_file.num5
 DEFINE l_c      LIKE  type_file.num5
 DEFINE l_rvv_a  DYNAMIC ARRAY OF RECORD
        rvv04    LIKE  rvv_file.rvv04,
        rvv05    LIKE  rvv_file.rvv05,
        rvv45    LIKE  rvv_file.rvv45,
        rvv46    LIKE  rvv_file.rvv46,
        rvv47    LIKE  rvv_file.rvv47,
        flagg    LIKE  type_file.chr1
                 END RECORD
 DEFINE l_inb01  LIKE inb_file.inb01
 DEFINE l_inb03  LIKE inb_file.inb03
 DEFINE l_inb46  LIKE inb_file.inb46
 DEFINE l_inb47  LIKE inb_file.inb47
 DEFINE l_inb48  LIKE inb_file.inb48
 DEFINE l_inb_a  DYNAMIC ARRAY OF RECORD
        inb01    LIKE  inb_file.inb01,
        inb03    LIKE  inb_file.inb03,
        inb48    LIKE  inb_file.inb48,
        inb46    LIKE  inb_file.inb46,
        inb47    LIKE  inb_file.inb47,
        flagg    LIKE  type_file.chr1
                 END RECORD
 #FUN-BC0104-add-end--

   DECLARE t620sub1_rvu2 CURSOR FOR 
   SELECT * INTO l_rvu.* FROM rvu_file WHERE rvu25=p_oga01
   DECLARE t620sub1_ina2 CURSOR FOR                                           
   SELECT * INTO l_ina.* FROM ina_file WHERE ina10 = p_oga01
  
  #還原入庫/退貨單
   FOREACH t620sub1_rvu2 INTO l_rvu.*
      DECLARE t620sub1_rvv2 CURSOR FOR 
       SELECT * INTO l_rvv.* FROM rvv_file WHERE rvv01=l_rvu.rvu01
      FOREACH t620sub1_rvv2 INTO l_rvv.*
         IF l_rvu.rvu00 = '1' THEN 
            CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,-1,
                         l_rvv.rvv17*l_rvv.rvv35_fac,l_rvu.rvu03,l_rvv.rvv31,
                         l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,l_rvv.rvv01,
                         l_rvv.rvv02,l_rvv.rvv35,l_rvv.rvv17,l_ima25,l_rvv.rvv35_fac,
                         1,'','','','','','','')
         ELSE 
            CALL s_upimg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,1,
                         l_rvv.rvv17*l_rvv.rvv35_fac,l_rvv.rvv09,'','','',
                         '',l_rvv.rvv01,l_rvv.rvv02,'','','','','','','','',
                         0,0,'','') 
         END IF                                       
        
         DELETE FROM tlf_file
          WHERE tlf01 =l_rvv.rvv31
            AND ((tlf026=l_rvu.rvu01 AND tlf027=l_rvv.rvv02) OR
                (tlf036=l_rvu.rvu01 AND tlf037=l_rvv.rvv02)) #異動單號/項次
         SELECT ima25,ima906 INTO l_ima25,l_ima906 FROM ima_file 
          WHERE ima01 = l_rvv.rvv31
        #多單位處理
         IF l_rvu.rvu00='1' THEN
            LET l_type = -1
         ELSE
            LET l_type = 1
         END IF                 
         IF l_ima906 = '2' THEN  #子母單位
            IF NOT cl_null(l_rvv.rvv83) THEN 
               CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
               CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                             l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
                             l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                             '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
                              '','','',l_rvv.rvv84)
            END IF                                         
            IF NOT cl_null(l_rvv.rvv80) THEN
               CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv80,l_ima25) RETURNING l_cnt,l_imgg21
               CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                             l_rvv.rvv80,l_type,l_rvv.rvv82,l_rvu.rvu02,l_rvv.rvv31,
                             l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,'','','','',
                             l_rvv.rvv80,'',l_imgg21,'','','','','','','',
                             l_rvv.rvv81)
            END IF 
         END IF 
         IF l_ima906 = '3' THEN  #參考單位
            IF NOT cl_null(l_rvv.rvv83) THEN
               CALL s_umfchk(l_rvv.rvv31,l_rvv.rvv83,l_ima25) RETURNING l_cnt,l_imgg21
               CALL s_upimgg(l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                             l_rvv.rvv83,l_type,l_rvv.rvv85,l_rvu.rvu02,
                             l_rvv.rvv31,l_rvv.rvv32,l_rvv.rvv33,l_rvv.rvv34,
                             '','','','',l_rvv.rvv83,'',l_imgg21,'','','','',
                             '','','',l_rvv.rvv84)  
            END IF 
         END IF    
         DELETE FROM tlff_file
          WHERE tlff01 =l_rvv.rvv31
            AND ((tlff026=l_rvu.rvu01 AND tlff027=l_rvv.rvv02) OR
                (tlff036=l_rvu.rvu01 AND tlff037=l_rvv.rvv02)) #異動單號/項次
      END FOREACH                                                                 
      DELETE FROM rvu_file WHERE rvu01 = l_rvu.rvu01
      IF STATUS THEN LET g_success = 'N' RETURN END IF
      #FUN-BC0104-add-str--
      LET l_cn = 1
      DECLARE upd_rvv_qco20 CURSOR FOR
       SELECT rvv02 FROM rvv_file WHERE rvv01=l_rvu.rvu01
      FOREACH upd_rvv_qco20 INTO l_rvv02
         CALL s_iqctype_rvv(l_rvu.rvu01,l_rvv02) RETURNING l_rvv04,l_rvv05,l_rvv45,l_rvv46,l_rvv47,l_flagg
         LET l_rvv_a[l_cn].rvv04 = l_rvv04
         LET l_rvv_a[l_cn].rvv05 = l_rvv05
         LET l_rvv_a[l_cn].rvv45 = l_rvv45
         LET l_rvv_a[l_cn].rvv46 = l_rvv46
         LET l_rvv_a[l_cn].rvv47 = l_rvv47
         LET l_rvv_a[l_cn].flagg = l_flagg
         LET l_cn = l_cn + 1
      END FOREACH
      #FUN-BC0104-add-end--
      DELETE FROM rvv_file WHERE rvv01 = l_rvu.rvu01
      IF STATUS THEN LET g_success = 'N' RETURN END IF
      #FUN-BC0104-add-str--
      FOR l_c=1 TO l_cn-1
         IF l_rvv_a[l_cn].flagg = 'Y' THEN
            CALL s_qcl05_sel(l_rvv_a[l_c].rvv46) RETURNING l_qcl05
            IF l_qcl05 ='1' THEN LET l_type1='5' ELSE LET l_type1 ='1' END IF
            IF NOT s_iqctype_upd_qco20(l_rvv_a[l_c].rvv04,l_rvv_a[l_c].rvv05,l_rvv_a[l_c].rvv45,l_rvv_a[l_c].rvv47,l_type1) THEN
               LET g_success ='N'
               RETURN
            END IF
         END IF
      END FOR
      #FUN-BC0104-add-end--
   END FOREACH      

  #還原雜收/發單
   FOREACH t620sub1_ina2 INTO l_ina.*
      DECLARE t620sub1_inb2 CURSOR FOR 
       SELECT * INTO l_inb.* FROM inb_file WHERE inb01=l_ina.ina01   
      FOREACH t620sub1_inb2 INTO l_inb.*
         IF l_ina.ina00 MATCHES '[12]' THEN
            LET l_type = 1
         ELSE
            LET l_type = -1
         END IF
         CALL s_upimg(l_inb.inb04,l_inb.inb05,l_inb.inb06,l_inb.inb07,
                      l_type,l_inb.inb09*l_inb.inb08_fac,l_ina.ina02,'','','','',
                      l_inb.inb01,l_inb.inb03,'','','','','','','','','','','','')  
         DELETE FROM tlf_file
          WHERE tlf01 =l_inb.inb04
            AND ((tlf026=l_ina.ina01 AND tlf027=l_inb.inb03) OR
                (tlf036=l_ina.ina01 AND tlf037=l_inb.inb03)) #異動單號/項次
            AND tlf06 =l_ina.ina02
         #多單位處理
         SELECT ima906,ima25 INTO l_ima906,l_ima25 FROM ima_file WHERE ima01 =  l_inb.inb04
         IF l_ima906 = '2' THEN
            IF NOT cl_null(l_inb.inb905) THEN
               CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_ima25) RETURNING l_cnt,l_imgg21
               CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
                 l_inb.inb07,l_inb.inb905,l_type,
                 l_inb.inb907,l_ina.ina02,l_inb.inb04,
                 l_inb.inb05,l_inb.inb06,l_inb.inb07,
                 '',l_ina.ina01,l_inb.inb03,'',l_inb.inb905,
                 '',l_imgg21,'','','','','','','',l_inb.inb906)
            END IF
            IF NOT cl_null(l_inb.inb902) THEN
               CALL s_umfchk(l_inb.inb04,l_inb.inb902,l_ima25) RETURNING l_cnt,l_imgg21
               CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
                 l_inb.inb07,l_inb.inb902,l_type,
                 l_inb.inb904,l_ina.ina02,l_inb.inb04,
                 l_inb.inb05,l_inb.inb06,l_inb.inb07,
                 '',l_ina.ina01,l_inb.inb03,'',l_inb.inb902,
                 '',l_imgg21,'','','','','','','',l_inb.inb903)
            END IF
         END IF
         IF l_ima906 = '3' THEN
            IF NOT cl_null(l_inb.inb905) THEN
               CALL s_umfchk(l_inb.inb04,l_inb.inb905,l_ima25) RETURNING l_cnt,l_imgg21
               CALL s_upimgg(l_inb.inb04,l_inb.inb05,l_inb.inb06,
                 l_inb.inb07,l_inb.inb905,l_type,l_inb.inb907,
                 l_ina.ina02,l_inb.inb04,l_inb.inb05,
                 l_inb.inb06,l_inb.inb07,'',l_ina.ina01,
                 l_inb.inb03,'',l_inb.inb905,'',l_imgg21,'',
                 '','','','','','',l_inb.inb906) 
            END IF
         END IF   
         DELETE FROM tlff_file
          WHERE tlff01 =l_inb.inb04
            AND ((tlff026=l_ina.ina01 AND tlff027=l_inb.inb03) OR
           (tlff036=l_ina.ina01 AND tlff037=l_inb.inb03)) #異動單號/項次
            AND tlff06 =l_ina.ina02 #異動日期
      END FOREACH             
      DELETE FROM ina_file WHERE ina01 = l_ina.ina01
      IF STATUS THEN LET g_success = 'N' RETURN END IF
      #FUN-BC0104-add-str--
      LET l_cn =1
      LET l_flagg =''
      DECLARE upd_inb_qco20 CURSOR FOR
       SELECT inb03 FROM inb_file WHERE inb01 = l_ina.ina01
      FOREACH upd_inb_qco20 INTO l_inb03
         CALL s_iqctype_inb(l_ina.ina01,l_inb03) RETURNING l_inb01,l_inb03,l_inb46,l_inb48,l_inb47,l_flagg
         LET l_inb_a[l_cn].inb01 = l_inb01
         LET l_inb_a[l_cn].inb03 = l_inb03
         LET l_inb_a[l_cn].inb46 = l_inb46
         LET l_inb_a[l_cn].inb48 = l_inb48
         LET l_inb_a[l_cn].inb47 = l_inb47
         LET l_inb_a[l_cn].flagg = l_flagg
         LET l_cn = l_cn + 1
      END FOREACH
      #FUN-BC0104-add-end--
      DELETE FROM inb_file WHERE inb01 = l_ina.ina01
      IF STATUS THEN 
         LET g_success = 'N' 
         RETURN 
#FUN-B70074-add-delete--
      ELSE 
         #FUN-BC0104-add-str--
         FOR l_c=1 TO l_cn-1
            IF l_inb_a[l_c].flagg = 'Y' THEN
               CALL s_qcl05_sel(l_inb_a[l_c].inb46) RETURNING l_qcl05
               IF l_qcl05='1' THEN LET l_type1='6' ELSE LET l_type1='4' END IF
               IF NOT s_iqctype_upd_qco20(l_inb_a[l_c].inb01,l_inb_a[l_c].inb03,l_inb_a[l_c].inb48,l_inb_a[l_c].inb47,l_type1) THEN
                  LET g_success="N"
                  RETURN
               END IF
            END IF
         END FOR
       #FUN-BC0104-add-end--
         IF NOT s_industry('std') THEN 
            IF NOT s_del_inbi(l_ina.ina01,'','') THEN 
               LET g_success="N" 
               RETURN 
            END IF 
         END IF
#FUN-B70074-add-end--
      END IF
   END FOREACH
END FUNCTION
#TQC-BB0131 add START
FUNCTION t620sub1_updruv13(p_oga01)
 DEFINE p_oga01      LIKE oga_file.oga01 
 DEFINE l_rvu13      LIKE rvu_file.rvu13
 DEFINE l_rvu14      LIKE rvu_file.rvu14 
 DEFINE l_rvu        RECORD LIKE rvu_file.* 
 DEFINE l_sql        STRING
 DEFINE l_cnt        LIKE type_file.num5
 DEFINE l_cnt2       LIKE type_file.num5

   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM rvu_file
        WHERE rvu00 = '3' AND rvu25 = p_oga01
   IF l_cnt <= 0  OR cl_null(l_cnt)THEN
      RETURN
   END IF
   LET l_sql = "SELECT * ",
   #            "  FROM ",cl_get_target_table(g_plant,'rvu_file'),  #TQC-BB0161 mark
               "  FROM ",cl_get_target_table(g_azw01,'rvu_file'),   #TQC-BB0161 add
               " WHERE rvu00 = '3'",   #倉退
               "   AND rvu25 = '",p_oga01,"'"
    PREPARE t620sub1_sel_rvu1 FROM l_sql
    DECLARE t620sub1_sel_rvu1_c CURSOR FOR t620sub1_sel_rvu1
    FOREACH t620sub1_sel_rvu1_c INTO l_rvu.*
       IF cl_null(l_rvu.rvu01) THEN RETURN END IF

       IF l_rvu.rvu10 = 'Y' THEN
          SELECT SUM(rvv39) INTO l_rvu13 FROM rvv_file
                 WHERE rvv01 = l_rvu.rvu01
          IF l_rvu13 IS NULL OR cl_null(l_rvu13)THEN 
             LET l_rvu13 = 0 
          END IF
          LET l_rvu14=l_rvu13*l_rvu.rvu12/100
          UPDATE rvu_file 
                 SET rvu13 = l_rvu13, rvu14 = l_rvu14
               WHERE rvu01 = l_rvu.rvu01 
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('upd rvu:',SQLCA.SQLCODE,0)
             LET g_success='N'
             RETURN
          END IF
       END IF
    END FOREACH 
END FUNCTION 
#TQC-BB0131 add END
#FUN-B40098

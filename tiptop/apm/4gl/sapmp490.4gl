# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: sapmp490.4gl
# Descriptions...:
# Date & Author..: 08/06/20 By hongmei
# Modify.........: No.FUN-870124 08/08/19 By jan 服飾業
# Modify.........: No.FUN-880072 08/08/19 By jan 服飾業過單
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.TQC-8C0063 09/01/12 By jan 加入特性BOM,下階料展BOM時，特性代碼抓ima910
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-940183 09/04/30 By Carrier rowid定義規範化
# Modify.........: No.FUN-940008 09/05/06 By hongmei GP5.2發料改善
# Modify.........: No.FUN-980006 09/08/14 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870007 09/08/19 By Zhangyajun 流通零售修改
# Modify.........: No.TQC-980142 09/08/22 By Dido 調整 inset into 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0164 09/10/28 By xiaofeizhu 標準SQL修改
# Modify.........: No:FUN-9B0023 09/11/02 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N' 
# Modify.........: No.TQC-9B0022 09/11/05 By xiaofeizhu 標準SQL修改
# Modify.........: No.FUN-9C0071 09/12/15 By huangrh
# Modify.........: No:MOD-A20055 10/02/08 By Smapmin 將多餘的程式段拿掉
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26*
# Modify.........: No:FUN-A70034 10/07/21 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:FUN-A90063 10/09/27 By rainy INSERT INTO p630_tmp時，應給 plant/legal值
# Modify.........: No:MOD-B40094 11/04/13 By zhangll 廠牌賦值無意義，為不再引起困擾故取消
# Modify.........: No:MOD-BB0285 11/11/25 By suncx 依訂單整批轉請購單BUG修正
# Modify.........: No:MOD-BB0302 11/11/25 By suncx 依訂單整批轉請購單BUG修正
# Modify.........: No:FUN-BB0086 11/12/05 By tanxc 增加數量欄位小數取位
# Modify.........: No:MOD-C10139 12/01/16 By suncx 抓取已轉請購量、採購量等值
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No:MOD-C80223 12/09/20 By jt_chen 不再判斷PCS的條件做進位動作
# Modify.........: No:MOD-C80149 12/10/18 By Nina 增加串bma_file,並排除無效BOM
# Modify.........: No:MOD-CA0216 13/01/31 By Elise 調整依料號將數量加總,寫入sfamm_file_temp時取消sfa08這個key值條件
# Modify.........: No:MOD-D10173 13/03/12 By jt_chen 調整不自動進位為整數

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
   g_oea09         LIKE oea_file.oea09,
   g_pml2          RECORD LIKE pml_file.*,
   g_pmk           RECORD LIKE pmk_file.*,
   g_oeb           RECORD LIKE oeb_file.*,     
   g_oeb01         LIKE oeb_file.oeb01,
   g_oeb03         LIKE oeb_file.oeb03,
   g_oebislk01     STRING,                 #LIKE type_file.chr1000,
   g_pnl           RECORD LIKE pnl_file.*,     
   g_pml_arrno     LIKE type_file.num5,
   g_pml_sarrno    LIKE type_file.num5,
   g_pml_pageno    LIKE type_file.num5,
    
   g_pml           ARRAY[600] of RECORD
                   sele        LIKE type_file.chr1,   #選擇
                   pml02       LIKE pml_file.pml02,   #項次
                   pml42       LIKE pml_file.pml42,   #替代碼
                   pml04       LIKE pml_file.pml04,   #料件編號
                   pml041      LIKE pml_file.pml041,  #品名規格
                   pml08       LIKE pml_file.pml08,   #庫存單位
                   pml45       LIKE pml_file.pml45,   #制單號
                   req_qty     LIKE pml_file.pml20,   #本次需求
                   in_qty      LIKE pml_file.pml20,   #投入量
                   su_qty      LIKE pml_file.pml20,   #本次請購
                   sh_qty      LIKE pml_file.pml20,   #結余量
                   ima27       LIKE pml_file.pml20,   #安全庫存量
                   al_qty      LIKE pml_file.pml20,   #分配量
#                   ima262      LIKE pml_file.pml20,   #庫存可用量#FUN-A20044
                   avl_stk      LIKE type_file.num15_3,   #FUN-A20044
                   pr_qty      LIKE pml_file.pml20,   #已請購量
                   po_qty      LIKE pml_file.pml20,   #采購量
                   qc_qty      LIKE pml_file.pml20,   #檢驗量
                   wo_qty      LIKE pml_file.pml20,   #在制量
                   pml35       LIKE pml_file.pml35    #到庫日期
                   END RECORD,
   g_pml_t         RECORD
                   sele        LIKE type_file.chr1,
                   pml02       LIKE pml_file.pml02,
                   pml42       LIKE pml_file.pml42,
                   pml04       LIKE pml_file.pml04,
                   pml041      LIKE pml_file.pml041,
                   pml08       LIKE pml_file.pml08,
                   pml45       LIKE pml_file.pml45,
                   req_qty     LIKE pml_file.pml20,
                   in_qty      LIKE pml_file.pml20,
                   su_qty      LIKE pml_file.pml20,
                   sh_qty      LIKE pml_file.pml20,
                   ima27       LIKE pml_file.pml20,
                   al_qty      LIKE pml_file.pml20,
#                   ima262      LIKE pml_file.pml20,  #FUN-A20044
                   avl_stk      LIKE type_file.num15_3,  #FUN-A20044
                   pr_qty      LIKE pml_file.pml20,
                   po_qty      LIKE pml_file.pml20,
                   qc_qty      LIKE pml_file.pml20,
                   wo_qty      LIKE pml_file.pml20,
                   pml35       LIKE pml_file.pml35
                   END RECORD,
               tm  RECORD 
                   oeb01       LIKE oeb_file.oeb01,     #訂單單號
                   oeb03       LIKE oeb_file.oeb03,     #訂單項次
                 oebislk01     LIKE type_file.chr1000,  #制單號
                 bmb09         LIKE bmb_file.bmb09,     #作業編號
                 bmb03         LIKE bmb_file.bmb03,     #元件料件編號
                   wc             STRING,           #NO.FUN-910082
                   bdate       DATE,                    #起始供應日期
                   sudate      DATE,                    #供給截至日期
                   a           LIKE type_file.chr1,     #庫存可用量
                   b           LIKE type_file.chr1,     #檢驗量
                   c           LIKE type_file.chr1,     #請購量
                   d           LIKE type_file.chr1,     #采購量
                   e           LIKE type_file.chr1,     #在制量
                   f           LIKE type_file.chr1,     #已備料量
                   g           LIKE type_file.chr1,     #建議量是否考慮安全庫存
                   k           LIKE type_file.chr1,     #是否計算加載比率
                   add         LIKE type_file.chr1      #是否為追加記錄
                   END RECORD,
   g_argv1         LIKE type_file.chr1, 
   g_sw            LIKE type_file.chr1, 
   g_wc            LIKE type_file.chr1000,           #NO.FUN-910082
   g_wc2           STRING,           #NO.FUN-910082
   g_wc3           STRING,           #NO.FUN-910082
   g_sql           STRING,           #NO.FUN-910082
   g_seq           LIKE type_file.num5,
   g_cnt           LIKE type_file.num5,
   g_i             LIKE type_file.num5,
   g_status        LIKE type_file.num5,
   g_rec_b         LIKE type_file.num5,
   l_ac            LIKE type_file.num5,
   l_sl            LIKE type_file.num5,
   p_row,p_col     LIKE type_file.num5
DEFINE
   g_sfa           RECORD LIKE sfa_file.*,
   g_opseq         LIKE sfa_file.sfa08,
   g_offset        LIKE sfa_file.sfa09,
   g_ima55         LIKE ima_file.ima55,
   g_ima55_fac     LIKE ima_file.ima55_fac,
   g_ima86         LIKE ima_file.ima86,
   g_ima86_fac     LIKE ima_file.ima86_fac,
   l_oeb22         LIKE oeb_file.oeb22,
   g_btflg         LIKE type_file.chr1,
   g_y             LIKE type_file.chr1,
   g_wo            LIKE type_file.chr18,
   g_wotype        LIKE type_file.num5,
   g_level         LIKE type_file.num5,
   g_ccc           LIKE type_file.num5,
   g_SOUCode       LIKE type_file.chr1,
   g_mps           LIKE type_file.chr1,
   g_yld           LIKE type_file.chr1,
   g_minopseq      LIKE ecb_file.ecb03,
   g_factor        LIKE type_file.num26_10,
   p_woq           LIKE type_file.num26_10,
   g_bmb09,g_bmb09_t LIKE type_file.chr1000,
   g_bmb03,g_bmb03_t LIKE type_file.chr1000,
   g_flag         LIKE type_file.chr1
DEFINE g_where    STRING
DEFINE g_forupd_sql STRING
    
DEFINE g_pml02    LIKE pml_file.pml02
 
FUNCTION p490(p_argv1,p_argv2,p_argv3)
   DEFINE l_time     LIKE type_file.chr8,
          #l_sql      LIKE type_file.chr1000,
          l_sql        STRING,       #NO.FUN-910082   
          p_argv1    LIKE type_file.chr1,
          p_argv2    LIKE pmm_file.pmm01,
          p_argv3    LIKE type_file.chr1,
          l_pnl01    LIKE pnl_file.pnl01,
          l_wo       LIKE sfa_file.sfa01,
          l_part     LIKE sfa_file.sfa03
 
   WHENEVER ERROR CONTINUE
   IF p_argv2 IS NULL OR p_argv2 = ' ' THEN 
      CALL cl_err(p_argv2,'mfg3527',0) 
      RETURN
   END IF
   LET g_flag = p_argv3
   LET g_sw = 'Y'
   LET g_argv1      = p_argv1
   LET g_pmk.pmk01  = p_argv2
   LET g_pml_pageno = 1
   LET g_pml_arrno  = 600 
   LET g_pml_sarrno = 3
   DELETE FROM apm_p470
   SELECT count(*) INTO g_pml02 FROM pml_file
    WHERE pml01 = g_pmk.pmk01
   IF cl_null(g_pml02) THEN LET g_pml02 = 0 END IF
    
   DROP TABLE pml_file_temp
   SELECT * FROM pml_file WHERE pml01 = g_pmk.pmk01
     INTO TEMP pml_file_temp
    
    
  WHILE TRUE 
    IF p_argv1 = 'G' THEN 
      IF g_sw != 'N' THEN 
        
        OPEN WINDOW p490_g WITH FORM "apm/42f/apmp490_a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
        CALL cl_ui_locale("apmp490_a")
 
        #No.FUN-870124--BEGIN--                                                                                                             
        IF NOT s_industry('slk') THEN                                                                                                   
           CALL cl_set_comp_visible("oebislk01",FALSE)                                                                                 
        END IF                                                                                                                          
        #No.FUN-870124--END----
        #       CALL cl_set_comp_visible("a,b,c,d,e,f,g,group02",FALSE)
      END IF
      CALL p490_tm() 
      IF INT_FLAG THEN 
        CLOSE WINDOW p490_g 
        EXIT WHILE 
      END IF
      DROP TABLE sfamm_file_temp;
      SELECT * FROM SFA_FILE WHERE sfa01 = g_pmk.pmk01  #MOD-BB0285
        INTO TEMP sfamm_file_temp                       #MOD-BB0285
#MOD-BB0285 mark begin---------------
#LET l_sql="SELECT TOP 1 * FROM sfa_file",
#          "INTO TEMP sfamm_file_temp"                              #TQC-9A0164 Add
#      PREPARE p490_pbsfamm FROM  l_sql
#      DECLARE p490_cssfamm CURSOR FROM l_sql
#      EXECUTE p490_cssfamm
#MOD-BB0285 mark end-----------------
      
      DELETE FROM pnl_file WHERE pnl01 = g_pmk.pmk01
      INSERT INTO pnl_file VALUES(g_pmk.pmk01,g_wc,tm.bdate,tm.sudate,
                                  tm.a,tm.b,tm.c,tm.d,
                                  tm.e,tm.f,tm.g,g_user,g_plant,g_legal, g_user, g_grup) #FUN-980006 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
    ELSE 
      SELECT pnl_file.* INTO l_pnl01,g_wc,tm.bdate,tm.sudate,
                             tm.a,tm.b,tm.c,tm.d,
                             tm.e,tm.f,tm.g,g_user
        FROM pnl_file WHERE pnl01 = g_pmk.pmk01
      IF SQLCA.sqlcode THEN 
        CALL cl_err(g_pmk.pmk01,'mfg3545',0)
        LET INT_FLAG = 1  EXIT WHILE
      END IF
      IF g_wc IS NULL OR g_wc = ' ' THEN LET g_wc = " 1=1 "  END IF
    END IF 
    CALL cl_err('','apm1017',0)   #No.FUN-870124      
    CALL cl_wait()
    CALL p490_inssfamm()
    CALL p490_g() 
    IF g_sw = 'N' THEN 
      CALL cl_err(g_pmk.pmk01,'mfg2601',0)
      CONTINUE WHILE
    END IF
    ERROR ""
    EXIT WHILE
  END WHILE
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CLOSE WINDOW p490_g
 
   OPEN WINDOW p490_w WITH FORM "apm/42f/apmp490"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("apmp490")
 
   SELECT pmk02,pmk04 INTO g_pmk.pmk02,g_pmk.pmk04 
     FROM pmk_file
    WHERE pmk01 = g_pmk.pmk01
   DISPLAY BY NAME g_pmk.pmk01 #ATTRIBUTE(YELLOW)   #TQC-8C0076
   DISPLAY BY NAME g_pmk.pmk02 #ATTRIBUTE(YELLOW)   #TQC-8C0076
   DISPLAY BY NAME g_pmk.pmk04 #ATTRIBUTE(YELLOW)   #TQC-8C0076
 
   CALL p490_b_fill("")
   CALL p490_b()
   CALL p490_deb()
 
   CLOSE WINDOW p490_w
END FUNCTION
   
 
FUNCTION p490_tm()
  DEFINE  l_cnt       LIKE type_file.num5,
          l_succ      LIKE type_file.chr1,
          l_wobdate   DATE,
          l_woedate   DATE,
          l_oeb01     LIKE oeb_file.oeb01,
          l_oeb04     LIKE oeb_file.oeb04,
          l_oeb03     LIKE oeb_file.oeb03,
          l_oebislk01 LIKE oebi_file.oebislk01,
          l_sql        STRING,       #NO.FUN-910082  
          l_where     LIKE type_file.chr1000,
          l_bmb09     LIKE bmb_file.bmb09,
          l_part      LIKE oeb_file.oeb04
 
   LET g_bmb09 = ''
   LET g_bmb03 = ''
   
  INPUT BY NAME tm.oebislk01,tm.bmb09,tm.bmb03
  
    AFTER FIELD oebislk01 
      IF cl_null(tm.oebislk01) THEN NEXT FIELD oebislk01 END IF 
      LET l_cnt = 0
      LET g_where = tm.oebislk01
      SELECT REPLACE(tm.oebislk01,"|","','") INTO l_where FROM dual
      LET l_where = "('",l_where,"')"
      LET l_sql = "SELECT COUNT(*) FROM oebi_file WHERE oebislk01 IN ",l_where
      PREPARE p_tm FROM l_sql
      DECLARE p_cur CURSOR FOR p_tm
      OPEN p_cur
      FETCH p_cur INTO l_cnt
      CLOSE p_cur
      IF l_cnt <= 0 THEN
        CALL cl_err('','apm1018',0)
        NEXT FIELD oebislk01
      END IF
      
      LET g_oebislk01 = l_where CLIPPED
    
    AFTER FIELD bmb09
      IF NOT  cl_null(tm.bmb09) THEN
        SELECT REPLACE(tm.bmb09,"|","','") INTO l_bmb09 FROM bmb_file
        LET g_bmb09 = " bmb09 IN ('",l_bmb09,"')"
      END IF
 
    AFTER FIELD bmb03 
      IF NOT cl_null(tm.bmb03) THEN
        SELECT REPLACE(tm.bmb03,"|","','") INTO g_bmb03 FROM bmb_file
        LET g_bmb03 = " bmb03 IN ('",g_bmb03,"')"
      END IF
      
      ON ACTION about  
        CALL cl_about()    
         
      ON ACTION help         
        CALL cl_show_help() 
 
      ON ACTION controlg
        CALL cl_cmdask()
            
    ON ACTION CONTROLP
      CASE
        WHEN INFIELD(oebislk01)
          CALL cl_init_qry_var()
          LET g_qryparam.form = "q_oebislk01"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          LET tm.oebislk01 = g_qryparam.multiret
          DISPLAY tm.oebislk01 TO oebislk01
          NEXT FIELD oebislk01
        WHEN INFIELD(bmb09)
          CALL cl_init_qry_var()
          LET g_qryparam.form = "q_ecd3"
          LET g_qryparam.state = 'c'
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          LET tm.bmb09 = g_qryparam.multiret
          DISPLAY tm.bmb09 TO bmb09
          NEXT FIELD bmb09
 
        WHEN INFIELD(bmb03)
          LET l_part = ''
          LET l_sql = " SELECT MAX(oeb04[1,8]) ",                           #TQC-9B0022 Add
                        " FROM oebi_file,oeb_file ",
                       " WHERE oebislk01 = oeb01 AND oebislk01 IN ",l_where
          PREPARE p_tm3 FROM l_sql
          DECLARE p_cur3 CURSOR FOR p_tm3
          OPEN p_cur3
          FETCH p_cur3 INTO l_part
          CLOSE p_cur3
          
          CALL cl_init_qry_var()
          LET g_qryparam.form = "q_bmb2"
          LET g_qryparam.arg1 = l_part
          LET g_qryparam.state = "c"
          CALL cl_create_qry() RETURNING g_qryparam.multiret
          LET tm.bmb03 = g_qryparam.multiret
          DISPLAY g_qryparam.multiret TO bmb03
          NEXT FIELD bmb03         
        OTHERWISE EXIT CASE
      END CASE    
    IF INT_FLAG THEN RETURN END IF  
  END INPUT
  LET g_bmb09_t = g_bmb09
  LET g_bmb03_t = g_bmb03
   
   CONSTRUCT BY NAME g_wc2 ON oeb01,oeb03
    ON ACTION about  
      CALL cl_about()    
      
    ON ACTION help         
      CALL cl_show_help() 
 
    ON ACTION controlg
      CALL cl_cmdask()
      
    ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oeb01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oea11"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oeb01
               NEXT FIELD oeb01
          OTHERWISE EXIT CASE
      END CASE
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
   IF cl_null(g_wc2) THEN LET g_wc2 = '1=1' END IF
   CALL cl_wait() 
   INITIALIZE tm.* TO NULL      # Default condition 
   LET tm.a = 'N'   
   LET tm.b = 'N'
   LET tm.c = 'N'  
   LET tm.d = 'N'
   LET tm.e = 'N'   
   LET tm.f = 'N'
   LET tm.g = 'N'   
   LET tm.k = 'N'
   LET tm.add    = 'N' 
   LET tm.bdate  = TODAY
   LET tm.sudate = TODAY
   INPUT BY NAME tm.bdate,tm.sudate,tm.a,tm.b,tm.c,  
                 tm.d,tm.e,tm.f,tm.g,tm.k,tm.add
                 WITHOUT DEFAULTS HELP 1
      
      AFTER FIELD bdate 
         IF tm.bdate IS NULL OR tm.bdate = ' ' THEN
            NEXT FIELD bdate
         ELSE 
            LET tm.sudate = tm.bdate
         END IF
      AFTER FIELD sudate  
         IF tm.sudate IS NULL OR tm.sudate = ' ' THEN NEXT FIELD sudate END IF
 
      AFTER FIELD a
         IF tm.a IS NULL OR tm.a NOT MATCHES'[YN]' THEN NEXT FIELD a END IF 
      AFTER FIELD b 
         IF tm.b IS NULL OR tm.b NOT MATCHES'[YN]' THEN NEXT FIELD b END IF 
      AFTER FIELD c 
         IF tm.c IS NULL OR tm.c NOT MATCHES'[YN]' THEN NEXT FIELD c END IF 
      AFTER FIELD d 
         IF tm.d IS NULL OR tm.d NOT MATCHES'[YN]' THEN NEXT FIELD d END IF 
      AFTER FIELD e 
         IF tm.e IS NULL OR tm.e NOT MATCHES'[YN]' THEN NEXT FIELD e END IF 
      AFTER FIELD f 
         IF tm.f IS NULL OR tm.f NOT MATCHES'[YN]' THEN NEXT FIELD f END IF 
      AFTER FIELD g 
         IF tm.g IS NULL OR tm.g NOT MATCHES'[YN]' THEN NEXT FIELD g END IF 
      AFTER FIELD k
         IF tm.k IS NULL OR tm.k NOT MATCHES'[YN]' THEN NEXT FIELD k END IF
      AFTER FIELD add
         IF tm.add IS NULL OR tm.add NOT MATCHES'[YN]'
         THEN NEXT FIELD add END IF
         
      ON KEY(CONTROL-G)
         CALL cl_cmdask()
 
      AFTER INPUT 
         IF INT_FLAG THEN EXIT INPUT END IF
   END INPUT
   IF INT_FLAG THEN RETURN END IF
END FUNCTION
 
#FUNCTION p490_cur()
#   DEFINE l_sql        STRING       #NO.FUN-910082  
# 
#   LET l_sql = " SELECT sum(sfa05-sfa06-sfa065) ",
#               "   FROM sfamm_file_temp ",
#               "  WHERE sfa01 = '",g_pmk.pmk01,"'",
#               "    AND sfa03 = ? " 
#   PREPARE p490_presfa  FROM l_sql
#   DECLARE p490_cssfa  CURSOR WITH HOLD FOR p490_presfa
# 
#   LET l_sql = " SELECT sum(rpc13-rpc131-rpc14) ",
#               "   FROM rpc_file WHERE rpc01 = ? ",
#               "    AND rpc12 <='",tm.sudate,"'"
#   PREPARE p490_prerpc  FROM l_sql
#   DECLARE p490_csrpc  CURSOR WITH HOLD FOR p490_prerpc
# 
#   LET l_sql = " SELECT sum(pml20-pml21) FROM pml_file,pmk_file ",
#               "  WHERE pmk01=pml01 AND pmk18 = 'Y' ",
#               "    AND pml04 = ? ",
#               "    AND pml16 < '6' ",
#               "    AND (pml011 = 'REG' OR pml011 = 'IPO') ",
#               "    AND pml01 != '",g_pmk.pmk01,"'",
#               "    AND pml35 <= '",tm.sudate,"'"
#    PREPARE p490_prepml  FROM l_sql
#    DECLARE p490_cspml  CURSOR WITH HOLD FOR p490_prepml
# 
#   LET l_sql = " SELECT sum((pmn20-(pmn50-pmn55))/pmn62) ",
#               "   FROM pmn_file,pmm_file ",
#               "  WHERE pmm01=pmn01 AND pmm18 = 'Y' ",
#               "    AND pmn61 = ? ",
#               "    AND pmn16 < '6' ",
#               "    AND (pmn011 = 'REG' OR pmn011 = 'IPO') ",
#               "    AND (pmn20-(pmn50-pmn55)) > 0 ",
#               "    AND pmn35 <= '",tm.sudate,"'"
#    PREPARE p490_prepmn  FROM l_sql
#    DECLARE p490_cspmn  CURSOR WITH HOLD FOR p490_prepmn
# 
#   LET l_sql = " SELECT sum(rvb31) ",
#               "   FROM rvb_file,rva_file   ",
#               "  WHERE rva01=rvb01 AND rvaconf = 'Y' ",
#               "    AND rvb05 = ?  "
#   PREPARE p490_prervb FROM l_sql
#   DECLARE p490_csrvb  CURSOR WITH HOLD FOR p490_prervb 
#END FUNCTION
 
FUNCTION p490_g()
   DEFINE  #l_sql      LIKE type_file.chr1000,
           l_sql        STRING,       #NO.FUN-910082  
           l_sfa91    LIKE sfa_file.sfa91,
           l_sfa92    LIKE sfa_file.sfa92,
           l_sfa03    LIKE sfa_file.sfa03,
           l_sfa26    LIKE sfa_file.sfa26,
           req_qty    LIKE pml_file.pml20,
           al_qty     LIKE pml_file.pml20,
           rpc_qty    LIKE pml_file.pml20,
           pr_qty     LIKE pml_file.pml20,
           po_qty     LIKE pml_file.pml20,
           qc_qty     LIKE pml_file.pml20,
           wo_qty     LIKE pml_file.pml20,
           su_qty     LIKE pml_file.pml20,
           sh_qty     LIKE pml_file.pml20,
#           l_ima262   LIKE ima_file.ima262, #FUN-A20044
           l_avl_stk   LIKE type_file.num15_3, #FUN-A20044
           l_ima27    LIKE ima_file.ima27,
           l_ima45    LIKE ima_file.ima45,
           l_ima46    LIKE ima_file.ima46,
           l_supply   LIKE pml_file.pml20,
           l_pan      LIKE type_file.num10,
           l_double   LIKE type_file.num10,
           l_sfa03_t  LIKE sfa_file.sfa03,
           l_sfa03_a  LIKE sfa_file.sfa03,
           l_req_qry  LIKE type_file.num10
 
   LET l_sql = "SELECT  sfa91,sfa92, sfa03,sfa26,sfa05-sfa06-sfa065 ",
               "  FROM sfamm_file_temp,ima_file",
               " WHERE sfa03 = ima01  ",
               " ORDER BY sfa03,sfa91,sfa92" 
 
   PREPARE p490_prepare FROM l_sql
   DECLARE p490_cs CURSOR WITH HOLD FOR p490_prepare
   IF g_argv1 = 'G' THEN 
      CALL p490_pmlini()
      SELECT max(pml02)+1 INTO g_seq FROM pml_file WHERE pml01 = g_pmk.pmk01
      IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0 THEN
         LET g_seq = 1
      END IF
   END IF
   LET g_sw = 'Y' 
   LET g_success = 'Y'
   BEGIN WORK
    
   IF tm.add = 'N' THEN
      DELETE FROM pml_file WHERE pml01 = g_pmk.pmk01
      #No.FUN-870124--BEGIN--
      IF NOT s_industry('std') THEN
         IF NOT s_del_pmli(g_pmk.pmk01,'','') THEN
            ROLLBACK WORK
         END IF
      END IF
      LET g_pml2.pml02 = 1
      LET g_seq = 1
      LET g_pml02 = 0
   END IF
   
   FOREACH p490_cs INTO l_sfa91,l_sfa92,l_sfa03,l_sfa26,req_qty
      IF SQLCA.sqlcode THEN 
         CALL cl_err('p490_cs',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      IF cl_null(l_sfa03_t) THEN
         LET l_sfa03_t = l_sfa03
      END IF
      IF l_sfa03 != l_sfa03_t THEN
         LET l_sfa03_t = l_sfa03
         LET al_qty = 0
      END IF
      LET g_sw = 'Y' 
      #MOD-C10139 add begin---------------
      LET l_sql = " SELECT sum((pml20-pml21)*pml09) FROM pml_file,pmk_file ",
                  " WHERE pmk01=pml01 AND pmk18 != 'X' ",
                  "   AND pml04 = ? ",
                  "   AND (pml16 < '6' OR pml16 = 'S' OR pml16 = 'R' OR pml16 = 'W') ",
                  "   AND (pml011 = 'REG' OR pml011 = 'IPO') ",
                  "   AND pml01 != '",g_pmk.pmk01,"'",
                  "   AND pml35 <= '",tm.sudate,"'"
      PREPARE p490_prepml  FROM l_sql
      DECLARE p490_cspml  CURSOR WITH HOLD FOR p490_prepml

      OPEN p490_cspml USING l_sfa03
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p490_cspml",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p490_cspml",0)
            EXIT FOREACH
         END IF
      END IF
      FETCH p490_cspml INTO pr_qty

       #--->讀取採購量(採購量-已交量)/檢驗量(pmn51)(日期區間)
      LET l_sql = " SELECT sum(((pmn20-(pmn50-pmn55))/pmn62)*pmn09) ",
                  "   FROM pmn_file,pmm_file ",
                  "  WHERE pmm01=pmn01 AND pmm18 != 'X' ",
                  "    AND pmn61 = ? ",
                  "    AND (pmn16 < '6' OR pmn16 = 'S' OR pmn16 = 'R' OR pmn16 = 'W') ",
                  "    AND (pmn011 = 'REG' OR pmn011 = 'IPO') ",
                  "    AND (pmn20-(pmn50-pmn55)) > 0 ",
                  "    AND pmn35 <= '",tm.sudate,"'"
      PREPARE p490_prepmn  FROM l_sql
      DECLARE p490_cspmn  CURSOR WITH HOLD FOR p490_prepmn

      #--->產生採購數量
      OPEN p490_cspmn USING l_sfa03
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p490_cspmn",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p490_cspmn",0)
            EXIT FOREACH
         END IF
      END IF
      FETCH p490_cspmn INTO po_qty
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p490_cspmn",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p490_cspmn",0)
            EXIT FOREACH
         END IF
      END IF

      #--->讀取在驗量(rvb_file)不考慮日期
      LET l_sql = " SELECT sum((rvb07-rvb29-rvb30)*pmn09) ",
                  "   FROM rvb_file,rva_file,pmn_file   ",
                  "  WHERE rva01=rvb01 AND rvaconf = 'Y' ",
                  "   AND rvb04=pmn01 ",
                  "   AND rvb03=pmn02 ",
                  "   AND rva10 = 'SUB' ",
                  "   AND rvb07 > (rvb29+rvb30) ",
                  "    AND rvb05 = ?  "
      PREPARE p490_prervb FROM l_sql
      DECLARE p490_csrvb  CURSOR WITH HOLD FOR p490_prervb
      #--->產生採購檢驗量
      OPEN p490_csrvb  USING l_sfa03
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p490_csrvb",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p490_csrvb",0)
            EXIT FOREACH
         END IF
      END IF
      FETCH p490_csrvb INTO qc_qty
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p490_csrvb",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p490_csrvb",0)
            EXIT FOREACH
         END IF
      END IF

      #--->讀取工單量(生產數量-入庫量-報廢量)(日期區間)
      LET l_sql = " SELECT sum((sfb08-sfb09-sfb12)*ima55_fac) ",
                  "   FROM sfb_file,ima_file ",
                  "  WHERE sfb05 = ? ",
                  "    AND ima01=sfb05 ",
                  "    AND sfb04 != '8' ",
                  "    AND sfb02 != '2' AND sfb02 != '11' AND sfb87!='X' ",
                  "    AND sfb15 <= '",tm.sudate,"'"
      PREPARE p490_p_sfb  FROM l_sql
      DECLARE p490_c_sfb  CURSOR WITH HOLD FOR p490_p_sfb
      #--->產生工單數量
      OPEN p490_c_sfb USING l_sfa03
      IF SQLCA.sqlcode THEN
         IF g_bgerr THEN
            CALL s_errmsg("","","p490_c_sfb",SQLCA.sqlcode,1)
            CONTINUE FOREACH
         ELSE
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p490_c_sfb",0)
            EXIT FOREACH
         END IF
      END IF
      FETCH p490_c_sfb INTO wo_qty
      #MOD-C10139 add end-----------------
      IF req_qty IS NULL OR req_qty = ' ' THEN LET req_qty = 0 END IF
      IF al_qty  IS NULL OR al_qty = ' '  THEN LET al_qty = 0  END IF
      IF rpc_qty IS NULL OR rpc_qty = ' ' THEN LET rpc_qty = 0 END IF
      IF pr_qty  IS NULL OR pr_qty = ' '  THEN LET pr_qty = 0  END IF
      IF po_qty  IS NULL OR po_qty = ' '  THEN LET po_qty = 0  END IF
      IF qc_qty  IS NULL OR qc_qty = ' '  THEN LET qc_qty = 0  END IF
      IF wo_qty  IS NULL OR wo_qty = ' '  THEN LET wo_qty = 0  END IF
      LET al_qty = (al_qty + rpc_qty) - req_qty
      IF  al_qty < 0 THEN LET al_qty = 0 END IF          
      LET l_sfa03_a = l_sfa03,l_sfa91
      INSERT INTO apm_p470 VALUES(l_sfa03_a,l_sfa26,g_today,req_qty,al_qty,
                                  pr_qty,po_qty,qc_qty,wo_qty)
      IF g_argv1 = 'G' THEN 
         CALL p490_ins_pml(l_sfa03,l_sfa26,req_qty,qc_qty,
                           po_qty,pr_qty,wo_qty,al_qty,l_sfa91,l_sfa92)
         IF g_success = 'N' THEN EXIT FOREACH END IF 
      END IF  
   END FOREACH  
   IF g_success = 'Y' THEN
      COMMIT WORK 
   ELSE
      ROLLBACK WORK 
   END IF
END FUNCTION
 
FUNCTION p490_b()
  DEFINE
      l_str           LIKE type_file.chr1000, 
      l_sum           LIKE pml_file.pml20,
      l_ac_t          LIKE type_file.num5,
      l_n,l_k         LIKE type_file.num5,
      l_modify_flag   LIKE type_file.chr1,
      l_lock_sw       LIKE type_file.chr1,
      l_exit_sw       LIKE type_file.chr1,
      p_cmd           LIKE type_file.chr1,
      l_ima55         LIKE ima_file.ima55,
      l_factor        LIKE type_file.num26_10,
      l_flag          LIKE type_file.chr1,
      l_pml07         LIKE pml_file.pml07,
      l_insert        LIKE type_file.chr1,
      l_update        LIKE type_file.chr1,
      l_jump          LIKE type_file.num5,
      l_i             LIKE type_file.num5
   DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044  
   IF s_shut(0) THEN RETURN END IF
   IF g_pmk.pmk01 IS NULL OR g_pmk.pmk01 = ' ' THEN RETURN END IF
   LET l_insert='Y'
   LET l_update='Y'
   CALL cl_opmsg('b')
   LET g_forupd_sql=" SELECT 'Y',pml02,pml42,pml04,pml041,pml08,",
                    " pml45,0,0,pml20,0,0,",
#                    " 0,ima262,0,0,0,0,pml35", #FUN-A20044
                    " 0,0,0,0,0,0,pml35", #FUN-A20044
#                    " FROM pml_file,ima_file",  #FUN-A20044
                    " FROM pml_file",  #FUN-A20044
#                    "  WHERE ima01 = pml04", #FUN-A20044
                    "  WHERE ", #FUN-A20044
                    " AND pml01= ? ",
                    " AND pml02= ? ",
                    " FOR UPDATE"
  LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
  DECLARE p490_bcl CURSOR FROM g_forupd_sql
   LET l_ac_t = 0
   WHILE TRUE
    LET l_exit_sw = "y"
    LET g_pml_pageno = 1
    INPUT ARRAY g_pml WITHOUT DEFAULTS FROM s_pml.*
       ATTRIBUTE (APPEND ROW = false,INSERT ROW = false) 
 
      BEFORE INPUT
        CALL cl_set_act_visible("insert",FALSE)
        IF g_flag = 'F' THEN
          CALL cl_set_comp_entry("pml02",FALSE)
          CALL cl_set_comp_entry("su_qty,pml35",FALSE)
          CALL cl_set_act_visible("delete",FALSE)  
        ELSE
          CALL cl_set_comp_entry("pml04,req_qty,su_qty,pml35",TRUE)
          CALL cl_set_act_visible("delete",TRUE) 
        END IF
            
      BEFORE ROW
        LET l_ac = ARR_CURR()
        LET g_pml_t.* = g_pml[l_ac].*  #BACKUP
        IF l_ac < l_ac_t THEN
          let l_jump = 1
          NEXT FIELD su_qty
        ELSE
          LET l_ac_t = 0
          let l_jump = 0
        END IF
        LET l_modify_flag = 'N'
        LET l_lock_sw = 'N'
        LET l_sl = SCR_LINE()
        LET l_n  = ARR_COUNT()
        BEGIN WORK
        IF g_pml_t.pml02 IS NOT NULL THEN
          LET p_cmd='u'
          OPEN p490_bcl USING g_pmk.pmk01,g_pml_t.pml02
          FETCH p490_bcl INTO g_pml[l_ac].*      
          CALL s_getstock(g_pml[l_ac].pml04,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044                           
          IF SQLCA.sqlcode THEN
            CALL cl_err(g_pml_t.pml02,SQLCA.sqlcode,1)
            LET l_lock_sw = "Y"
          END IF
          LET g_pml[l_ac].sele = g_pml_t.sele
                    
          LET g_pml[l_ac].in_qty = 0
          SELECT SUM(pml20) INTO g_pml[l_ac].in_qty FROM pml_file
           WHERE pml04 = g_pml[l_ac].pml04 AND pml45 = g_pml[l_ac].pml45
             AND pml16 != '9' AND pml01 <> g_pmk.pmk01
          IF cl_null(g_pml[l_ac].in_qty) THEN LET g_pml[l_ac].in_qty = 0 END IF
        ELSE
          LET p_cmd='a'
          INITIALIZE g_pml[l_ac].* TO NULL  #900423
        END IF
        IF l_ac <= l_n then           
          CALL p490_qty()     
          DISPLAY g_pml[l_ac].* TO s_pml[l_sl].* #ATTRIBUTE (YELLOW)
        END IF
        NEXT FIELD sele
 
      BEFORE INSERT
        LET l_n = ARR_COUNT()
        LET p_cmd='a'
        INITIALIZE g_pml[l_ac].* TO NULL
        LET g_pml_t.* = g_pml[l_ac].*
        DISPLAY g_pml[l_ac].* TO s_pml[l_sl].* #ATTRIBUTE (YELLOW)       
        NEXT FIELD sele
        
         BEFORE FIELD su_qty
            LET l_modify_flag = 'Y'
            IF (g_pml_t.pml02 IS NOT NULL AND l_update='N') THEN
               LET l_modify_flag = 'N'
            END IF
            IF (l_lock_sw = 'Y') THEN LET l_modify_flag = 'N' END IF
            IF (l_modify_flag = 'N') THEN
               LET g_pml[l_ac].pml02 = g_pml_t.pml02
               DISPLAY g_pml[l_ac].pml02 TO s_pml[l_sl].pml02
               NEXT FIELD su_qty
            END IF  
       
      BEFORE DELETE
        IF g_pml_t.pml02 > 0 AND g_pml_t.pml02 IS NOT NULL THEN
          IF NOT cl_delb(0,0) THEN
            LET l_exit_sw = "n"
            LET l_ac_t = l_ac
            EXIT INPUT
          END IF
          DELETE FROM pml_file
          WHERE pml01 = g_pmk.pmk01 AND pml02 = g_pml_t.pml02
          IF SQLCA.sqlcode THEN
            CALL cl_err(g_pml_t.pml02,SQLCA.sqlcode,0)
            LET l_exit_sw = "n"
            LET l_ac_t = l_ac
            EXIT INPUT
          END IF
             IF NOT s_industry('std') THEN
                IF NOT s_del_pmli(g_pmk.pmk01,g_pml_t.pml02,'') THEN
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
             END IF
          COMMIT WORK 
        END IF
 
      AFTER DELETE
        LET l_n = ARR_COUNT()
        INITIALIZE g_pml[l_n+1].* TO NULL
        LET l_jump = 1
 
      AFTER ROW
        IF NOT l_jump THEN
          IF g_pml[l_ac+1].pml02 IS NOT NULL THEN
            DISPLAY g_pml[l_ac].* TO s_pml[l_sl].* #ATTRIBUTE (YELLOW)
          END IF
          IF INT_FLAG THEN                
            CALL cl_err('',9001,0)
            #LET INT_FLAG = 0
            LET g_pml[l_ac].* = g_pml_t.*
            DISPLAY g_pml[l_ac].* TO s_pml[l_sl].* #ATTRIBUTE (YELLOW)
            EXIT INPUT
          END IF
          IF g_pml[l_ac].pml02 IS NOT NULL THEN
            IF g_pml_t.pml02 IS NOT NULL AND
            (g_pml[l_ac].su_qty != g_pml_t.su_qty OR   
            g_pml[l_ac].pml35 != g_pml_t.pml35) THEN
              #------------
              SELECT ima55,pml07 INTO l_ima55,l_pml07 FROM pml_file,ima_file
               WHERE ima01=pml04 
                 AND pml01 = g_pmk.pmk01 AND pml02 = g_pml[l_ac].pml02
              CALL s_umfchk(g_pml[l_ac].pml04,l_ima55,l_pml07) RETURNING l_flag,l_factor    
              IF l_flag THEN 
                CALL cl_err(l_pml07,'mfg1206',0)
              ELSE
                LET g_pml[l_ac].su_qty=g_pml[l_ac].su_qty*l_factor
                LET g_pml[l_ac].su_qty = s_digqty(g_pml[l_ac].su_qty,l_pml07)   #No.FUN-BB0086
              END IF
              UPDATE pml_file SET pml20 = g_pml[l_ac].su_qty,
                                  pml87 = g_pml[l_ac].su_qty,
                                  pml35 = g_pml[l_ac].pml35
               WHERE  pml01 = g_pmk.pmk01 
                 AND pml02 = g_pml[l_ac].pml02
              IF SQLCA.sqlcode THEN
                CALL cl_err(g_pml[l_ac].pml02,SQLCA.sqlcode,0)
                LET g_pml[l_ac].* = g_pml_t.*
                DISPLAY g_pml[l_ac].* TO s_pml[l_sl].* #ATTRIBUTE (YELLOW)
              ELSE
                MESSAGE 'UPDATE O.K'
                COMMIT WORK 
              END IF
            END IF
          END IF
          LET g_pml_t.* = g_pml[l_ac].*        
        END IF
 
         ON ACTION select_all
            FOR l_i = 1 TO g_rec_b
               LET g_pml[l_i].sele = 'Y'
               DISPLAY g_pml[l_i].sele TO s_pml[l_i].sele
            END FOR
           
         ON ACTION un_select_all
            FOR l_i = 1 TO g_rec_b
               LET g_pml[l_i].sele = 'N'
               DISPLAY g_pml[l_i].sele TO s_pml[l_i].sele
            END FOR
        
         ON KEY(CONTROL-N)
          LET l_exit_sw = "n"
          EXIT INPUT
 
         AFTER INPUT
          IF INT_FLAG THEN EXIT INPUT END IF
 
         ON KEY(CONTROL-G)
          CALL cl_cmdask()
 
         ON KEY(CONTROL-F)
            CASE
               WHEN INFIELD(pml02) CALL cl_fldhlp('pml02')
               WHEN INFIELD(pml04) CALL cl_fldhlp('pml04')
               OTHERWISE           CALL cl_fldhlp('    ')
            END CASE
     END INPUT
     IF l_exit_sw = "y" THEN
        EXIT WHILE
     ELSE
        CONTINUE WHILE
     END IF
  END WHILE
 
  CLOSE p490_bcl
  COMMIT WORK 
END FUNCTION
 
FUNCTION p490_qty() 
#   DEFINE  l_ima262  LIKE ima_file.ima262, #FUN-A20044
   DEFINE  l_avl_stk  LIKE type_file.num15_3, #FUN-A20044
           l_ima27   LIKE ima_file.ima27,
           l_req_qty LIKE pml_file.pml20,
           l_al_qty  LIKE pml_file.pml20,
           l_pr_qty  LIKE pml_file.pml20,
           l_po_qty  LIKE pml_file.pml20,
           l_qc_qty  LIKE pml_file.pml20,
           l_wo_qty  LIKE pml_file.pml20,
           l_supply  LIKE pml_file.pml20,
           l_demand  LIKE pml_file.pml20,
           l_sfa03   LIKE sfa_file.sfa03
 
   SELECT ima27 INTO l_ima27 FROM ima_file 
    WHERE ima01 = g_pml[l_ac].pml04
   IF l_ima27 IS NULL OR l_ima27 = ' ' THEN LET l_ima27 = 0 END IF
   LET g_pml[l_ac].ima27 = l_ima27
   LET l_sfa03 = g_pml[l_ac].pml04,g_pml[l_ac].pml45
   SELECT req_qty,al_qty,pr_qty,po_qty,qc_qty,wo_qty 
     INTO l_req_qty,l_al_qty,l_pr_qty,l_po_qty,l_qc_qty,l_wo_qty 
     FROM apm_p470 WHERE part = l_sfa03
   
   IF l_req_qty IS NULL OR l_req_qty = ' ' THEN LET l_req_qty = 0 END IF
   IF l_al_qty  IS NULL OR l_al_qty = ' '  THEN LET l_al_qty = 0 END IF
   IF l_pr_qty  IS NULL OR l_pr_qty = ' '  THEN LET l_pr_qty = 0 END IF
   IF l_po_qty  IS NULL OR l_po_qty = ' '  THEN LET l_po_qty = 0 END IF
   IF l_qc_qty  IS NULL OR l_qc_qty = ' '  THEN LET l_qc_qty = 0 END IF
   IF l_wo_qty  IS NULL OR l_wo_qty = ' '  THEN LET l_wo_qty = 0 END IF
   LET g_pml[l_ac].req_qty= l_req_qty
   LET g_pml[l_ac].al_qty= l_al_qty
   LET g_pml[l_ac].pr_qty= l_pr_qty
   LET g_pml[l_ac].po_qty= l_po_qty
   LET g_pml[l_ac].qc_qty= l_qc_qty
   LET g_pml[l_ac].wo_qty= l_wo_qty
#   IF tm.a = 'N' THEN LET g_pml[l_ac].ima262 = 0 END IF #FUN-A20044
   IF tm.a = 'N' THEN LET g_pml[l_ac].avl_stk = 0 END IF #FUN-A20044
   IF tm.b = 'N' THEN LET g_pml[l_ac].qc_qty = 0 END IF
   IF tm.c = 'N' THEN LET g_pml[l_ac].pr_qty = 0 END IF
   IF tm.d = 'N' THEN LET g_pml[l_ac].po_qty = 0 END IF
   IF tm.e = 'N' THEN LET g_pml[l_ac].wo_qty = 0 END IF
   IF tm.f = 'N' THEN LET g_pml[l_ac].al_qty = 0 END IF
#   LET l_supply= g_pml[l_ac].ima262 + g_pml[l_ac].qc_qty + #FUN-A20044
   LET l_supply= g_pml[l_ac].avl_stk + g_pml[l_ac].qc_qty + #FUN-A20044
                 g_pml[l_ac].po_qty + g_pml[l_ac].pr_qty + 
                 g_pml[l_ac].wo_qty 
 
   LET g_pml[l_ac].sh_qty = l_supply - (g_pml[l_ac].req_qty + g_pml[l_ac].al_qty)
   DISPLAY g_pml[l_ac].avl_stk  TO s_pml[l_sl].avl_stk  #ATTRIBUTE (YELLOW)#FUN-A20044
   DISPLAY g_pml[l_ac].ima27   TO s_pml[l_sl].ima27   #ATTRIBUTE (YELLOW)
   DISPLAY g_pml[l_ac].req_qty TO s_pml[l_sl].req_qty #ATTRIBUTE (YELLOW)
   DISPLAY g_pml[l_ac].al_qty  TO s_pml[l_sl].al_qty  #ATTRIBUTE (YELLOW)
   DISPLAY g_pml[l_ac].pr_qty  TO s_pml[l_sl].pr_qty  #ATTRIBUTE (YELLOW)
   DISPLAY g_pml[l_ac].po_qty  TO s_pml[l_sl].po_qty  #ATTRIBUTE (YELLOW)
   DISPLAY g_pml[l_ac].qc_qty  TO s_pml[l_sl].qc_qty  #ATTRIBUTE (YELLOW)
   DISPLAY g_pml[l_ac].wo_qty  TO s_pml[l_sl].wo_qty  #ATTRIBUTE (YELLOW)
   DISPLAY g_pml[l_ac].sh_qty  TO s_pml[l_sl].sh_qty  #ATTRIBUTE (YELLOW)
END FUNCTION
 
FUNCTION p490_b_fill(p_wc2)              #BODY FILL UP
   DEFINE p_wc2             STRING,           #NO.FUN-910082
         l_supply  LIKE pml_file.pml20,
#         l_ima262  LIKE ima_file.ima262,  #FUN-A20044
         l_avl_stk  LIKE type_file.num15_3,  #FUN-A20044
         l_demand  LIKE pml_file.pml20,
         l_pml20   LIKE pml_file.pml20
   DEFINE l_avl_stk_mpsmrp,l_unavl_stk LIKE type_file.num15_3 
   
   LET g_sql =
       " SELECT 'Y',pml02,pml42,pml04,pml041,pml08,",
#       "        pml45,req_qty,0,pml20,0,ima27,al_qty,ima262, ",    #FUN-A20044
       "        pml45,req_qty,0,pml20,0,ima27,al_qty,0, ",    #FUN-A20044
       "        pr_qty,po_qty,qc_qty,wo_qty,pml35 ",
       "   FROM  pml_file,OUTER ima_file,OUTER apm_p470 ",
       "  WHERE pml04 = ima_file.ima01", 
       "    AND apm_p470.part =(pml04 || pml45) ", 
       "    AND pml01 = '",g_pmk.pmk01,"'",
       "    AND pml02 > ",g_pml02
 
   PREPARE p490_pb FROM g_sql
   DECLARE pml_curs  CURSOR WITH HOLD FOR p490_pb
   FOR g_cnt = 1 TO g_pml_arrno
      INITIALIZE g_pml[g_cnt].* TO NULL 
      LET g_pml[g_cnt].sele = 'Y'
   END FOR
   LET g_rec_b = 0
   LET g_cnt = 1
   FOREACH pml_curs INTO g_pml[g_cnt].*
   CALL s_getstock(g_pml[g_cnt].pml04,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
   LET g_pml[g_cnt].avl_stk = l_avl_stk #FUN-A20044 
    IF SQLCA.sqlcode THEN
      CALL cl_err('foreach:',SQLCA.sqlcode,1)
      EXIT FOREACH
    END IF
 
#      IF tm.a = 'N' THEN LET g_pml[g_cnt].ima262 = 0 END IF #FUN-A20044
      IF tm.a = 'N' THEN LET g_pml[g_cnt].avl_stk = 0 END IF #FUN-A20044
      IF tm.b = 'N' THEN LET g_pml[g_cnt].qc_qty = 0 END IF
      IF tm.c = 'N' THEN LET g_pml[g_cnt].pr_qty = 0 END IF
      IF tm.d = 'N' THEN LET g_pml[g_cnt].po_qty = 0 END IF
      IF tm.e = 'N' THEN LET g_pml[g_cnt].wo_qty = 0 END IF
      IF tm.f = 'N' THEN LET g_pml[g_cnt].al_qty = 0 END IF
      IF tm.g = 'N' THEN LET g_pml[g_cnt].ima27  = 0 END IF
#      LET l_supply= g_pml[g_cnt].ima262 + g_pml[g_cnt].qc_qty + #FUN-A20044
      LET l_supply= g_pml[g_cnt].avl_stk + g_pml[g_cnt].qc_qty + #FUN-A20044

                    g_pml[g_cnt].po_qty + g_pml[g_cnt].pr_qty + 
                    g_pml[g_cnt].wo_qty 
      LET l_demand= g_pml[g_cnt].req_qty + g_pml[g_cnt].al_qty
      LET g_pml[g_cnt].sh_qty = l_supply - l_demand
       
      LET l_pml20 = 0
      SELECT SUM(pml20) INTO l_pml20 FROM pml_file
       WHERE pml04 = g_pml[g_cnt].pml04 AND pml45 = g_pml[g_cnt].pml45
         AND pml16 != '9' AND pml01 <> g_pmk.pmk01
      IF cl_null(l_pml20) THEN LET l_pml20 = 0 END IF
       
      LET g_pml[g_cnt].in_qty = l_pml20
      LET g_pml[g_cnt].su_qty = g_pml[g_cnt].su_qty - l_pml20
      IF g_pml[g_cnt].su_qty < 0 THEN LET g_pml[g_cnt].su_qty = 0 END IF
      BEGIN WORK
      UPDATE pml_file SET pml20 = g_pml[g_cnt].su_qty,
                          pml87 = g_pml[g_cnt].su_qty
       WHERE pml04 = g_pml[g_cnt].pml04 
         AND pml45 = g_pml[g_cnt].pml45
         AND pml01 = g_pmk.pmk01
      IF SQLCA.SQLCODE THEN
         CALL cl_err('upd',SQLCA.SQLCODE,0)
         ROLLBACK WORK
         EXIT FOREACH
      ELSE
         COMMIT WORK
      END IF       
       
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_pml_arrno THEN
         CALL cl_err('',9035,0)
         EXIT FOREACH
      END IF
   END FOREACH
   CALL SET_COUNT(g_cnt-1)
   LET g_rec_b=g_cnt-1
END FUNCTION
 
FUNCTION p490_bp(p_ud)
  DEFINE
     p_ud            LIKE type_file.chr1,
     l_i,l_j         LIKE type_file.num5
 
   CASE p_ud
      WHEN 'U'
         IF g_pml_pageno > 1 THEN
            LET g_pml_pageno = g_pml_pageno - 1
            FOR l_i = 1 TO g_pml_sarrno
               LET l_j = g_pml_sarrno * (g_pml_pageno - 1) + l_i
               DISPLAY g_pml[l_j].* TO s_pml[l_i].* #ATTRIBUTE (YELLOW)
            END FOR
         END IF
      WHEN 'D'
         IF g_pml_pageno < g_pml_arrno/g_pml_sarrno THEN
            LET g_pml_pageno = g_pml_pageno + 1
            FOR l_i = 1 TO g_pml_sarrno
                LET l_j = g_pml_sarrno * (g_pml_pageno - 1) + l_i
                DISPLAY g_pml[l_j].* TO s_pml[l_i].* #ATTRIBUTE (YELLOW)
            END FOR
         END IF
      WHEN 'N'
         LET g_pml_pageno = 1
         FOR l_i = 1 TO g_pml_sarrno
             LET l_j = g_pml_sarrno * (g_pml_pageno - 1) + l_i
             DISPLAY g_pml[l_j].* TO s_pml[l_i].* #ATTRIBUTE (YELLOW)
         END FOR
    END CASE
END FUNCTION
 
FUNCTION p490_pmlini()
   SELECT pmk02,pmk25,pmk45,pmk13 INTO g_pmk.pmk02,g_pmk.pmk25,g_pmk.pmk45 ,g_pmk.pmk13 
     FROM pmk_file WHERE pmk01 = g_pmk.pmk01 
   LET g_pml2.pml01 = g_pmk.pmk01 
   LET g_pml2.pml011 =g_pmk.pmk02
   LET g_pml2.pml16 = g_pmk.pmk25
   LET g_pml2.pml14 = g_sma.sma886[1,1]     
   LET g_pml2.pml15  =g_sma.sma886[2,2]
   LET g_pml2.pml23 = 'Y'             
   LET g_pml2.pml38 = g_pmk.pmk45    
   LET g_pml2.pml43 = 0 
   LET g_pml2.pml431 = 0  
   LET g_pml2.pml11 = 'N'            
   LET g_pml2.pml13  = 0 
   LET g_pml2.pml21  = 0          
   LET g_pml2.pml16 = g_pmk.pmk25
   LET g_pml2.pml30 = 0                 
   LET g_pml2.pml32 = 0
END FUNCTION
 
FUNCTION p490_ins_pml(p_sfa03,p_sfa26,p_req_qty,p_qc_qty,p_po_qty,
                      p_pr_qty,p_wo_qty,p_al_qty,p_sfa91,p_sfa92)
   DEFINE p_sfa03     LIKE sfa_file.sfa03,
          p_sfa26     LIKE type_file.chr1,
          p_sfa91     LIKE sfa_file.sfa91,
          p_sfa92     LIKE sfa_file.sfa92,
          p_req_qty   LIKE pml_file.pml20,
          p_qc_qty    LIKE pml_file.pml20,
          p_po_qty    LIKE pml_file.pml20,
          p_pr_qty    LIKE pml_file.pml20,
          p_wo_qty    LIKE pml_file.pml20,
          p_al_qty    LIKE pml_file.pml20,
          su_qty      LIKE pml_file.pml20,
          sh_qty      LIKE pml_file.pml20,
          l_ima01     LIKE ima_file.ima01,
          l_ima02     LIKE ima_file.ima02,
          l_ima05     LIKE ima_file.ima05,
          l_ima25     LIKE ima_file.ima25,
          l_ima27     LIKE ima_file.ima27,
#          l_ima262    LIKE ima_file.ima262, #FUN-A20044
          l_avl_stk    LIKE type_file.num15_3, #FUN-A20044
          l_avl_stk_mpsmrp LIKE type_file.num15_3, #FUN-A20044
          l_unavl_stk      LIKE type_file.num15_3, #FUN-A20044
          l_ima44     LIKE ima_file.ima44,
          l_ima44_fac LIKE ima_file.ima44_fac,
          l_ima45     LIKE ima_file.ima45,
          l_ima46     LIKE ima_file.ima46,
          l_ima49     LIKE ima_file.ima49,
          l_ima491    LIKE ima_file.ima491,
          l_ima55     LIKE ima_file.ima55,
          l_factor    LIKE type_file.num26_10,
          l_flag      LIKE type_file.chr1,
          l_supply    LIKE pml_file.pml20,
          l_demand    LIKE pml_file.pml20,
          l_pan       LIKE type_file.num10,
          l_double    LIKE type_file.num10,
          l_pml20     LIKE type_file.num10
  
  DEFINE li_cnt       LIKE type_file.num10 
  DEFINE l_tok        base.stringTokenizer
  DEFINE field_array  DYNAMIC ARRAY OF LIKE type_file.chr1000
  DEFINE i,k          LIKE type_file.num5
  DEFINE l_n          LIKE type_file.num5
  DEFINE l_pmli        RECORD LIKE pmli_file.*    #No.FUN-870124
  DEFINE l_pml07      LIKE pml_file.pml07     #No.FUN-BB0086
  
#   SELECT ima01,ima02,ima05,ima25,ima262,ima27,ima44,ima44_fac, #FUN-A20044
   SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, #FUN-A20044
          ima45,ima46,ima49,ima491,ima55
#     INTO l_ima01,l_ima02,l_ima05,l_ima25,l_ima262,l_ima27, #FUN-A20044
     INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27, #FUN-A20044
          l_ima44,l_ima44_fac,l_ima45,l_ima46,l_ima49,l_ima491,l_ima55
     FROM ima_file 
    WHERE ima01 = p_sfa03
    CALL s_getstock(p_sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
   IF SQLCA.sqlcode THEN 
      CALL cl_err('sel ima',SQLCA.sqlcode,0)
      LET g_success = 'N'
      RETURN
   END IF 
   LET g_pml2.pml06 = ''
   LET g_pml2.pml18 = ''
   LET g_pml2.pml02 = g_seq 
   LET g_pml2.pml04 = l_ima01
   LET g_pml2.pml041= l_ima02          
   LET g_pml2.pml05 = NULL 
   LET g_pml2.pml07 = l_ima44          
   LET g_pml2.pml08 = l_ima25
   LET g_pml2.pml09 = l_ima44_fac      
   LET g_pml2.pml42 = p_sfa26
   IF g_pml2.pml42  = '2' THEN LET g_pml2.pml42 = '1' END IF
   IF g_pml2.pml42  = '7' THEN LET g_pml2.pml42 = '1' END IF   #FUN-A20037
   IF g_pml2.pml42  = 'S' THEN LET g_pml2.pml42 = '0' END IF
   IF g_pml2.pml42  = 'Z' THEN LET g_pml2.pml42 = '0' END IF   #FUN-A20037
   IF g_pml2.pml42  = 'U' THEN LET g_pml2.pml42 = '0' END IF
#   IF tm.a = 'N' THEN LET l_ima262 = 0 END IF #FUN-A20044
   IF tm.a = 'N' THEN LET l_avl_stk = 0 END IF #FUN-A20044
   IF tm.b = 'N' THEN LET p_qc_qty = 0 END IF
   IF tm.c = 'N' THEN LET p_pr_qty = 0 END IF
   IF tm.d = 'N' THEN LET p_po_qty = 0 END IF
   IF tm.e = 'N' THEN LET p_wo_qty = 0 END IF
   IF tm.f = 'N' THEN LET p_al_qty = 0 END IF
   LET sh_qty = p_req_qty + p_al_qty - 
#                (l_ima262 + p_qc_qty + p_po_qty + p_pr_qty + p_wo_qty ) #FUN-A20037
                (l_avl_stk + p_qc_qty + p_po_qty + p_pr_qty + p_wo_qty ) #FUN-A20037
   IF sh_qty > p_req_qty THEN 
      LET su_qty = p_req_qty 
   ELSE 
    LET su_qty = sh_qty 
   END IF
   IF tm.g = 'Y' AND su_qty > 0 THEN LET su_qty = su_qty  +  l_ima27 END IF
   IF su_qty > 0 THEN 
      LET g_pml2.pml20 = su_qty
   ELSE 
      LET g_pml2.pml20 = 0
   END IF
   CALL s_umfchk(g_pml2.pml04,l_ima55,g_pml2.pml07) RETURNING l_flag,l_factor    
   IF l_flag THEN 
      CALL cl_err(g_pml2.pml07,'mfg1206',0)
   ELSE
      LET g_pml2.pml20=g_pml2.pml20*l_factor
   END IF
   LET g_pml2.pml35 = tm.bdate
   IF NOT cl_null(l_ima491) AND l_ima491 !=0 THEN 
      CALL s_wkday3(g_pml2.pml35,l_ima491) RETURNING g_pml2.pml34
   ELSE 
    LET g_pml2.pml34 = g_pml2.pml35
   END IF
   LET g_pml2.pml33 = g_pml2.pml34 - l_ima49
   LET g_pml2.pml45 = p_sfa91
   LET g_pml2.pml86 = g_pml2.pml07
   LET g_pml2.pml87 = g_pml2.pml20 
   LET g_pml2.pml190 = 'N' 
   IF g_pml2.pml07='PCS' THEN
      LET g_pml2.pml20 = g_pml2.pml20 + 0.999  
      LET l_pml20 = g_pml2.pml20
      LET g_pml2.pml20 = l_pml20
   END IF
   LET g_pml2.pml87 = g_pml2.pml20 
   LET g_pml2.pml930=s_costcenter(g_pmk.pmk13)  
   SELECT COUNT(*) INTO li_cnt FROM pml_file 
                               WHERE pml45 = g_pml2.pml45 
                                 AND pml04 = g_pml2.pml04
                                 AND pml01 = g_pml2.pml01
  IF li_cnt <= 0 THEN 
      LET g_pml2.pml49 = '1' #No.FUN-870007
      LET g_pml2.pml50 = '1' #No.FUN-870007
      LET g_pml2.pml54 = '2' #No.FUN-870007
      LET g_pml2.pml56 = '1' #No.FUN-870007
      LET g_pml2.pmlplant = g_plant #FUN-980006 add
      LET g_pml2.pmllegal = g_legal #FUN-980006 add
      LET g_pml2.pml92 = 'N' #FUN-9B0023
      IF cl_null(g_pml2.pml91) THEN LET g_pml2.pml91 = ' ' END IF   #MOD-BB0302
      INSERT INTO pml_file VALUES(g_pml2.*)
      IF SQLCA.SQLCODE THEN
         ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
      ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_pmli.* TO NULL
           LET l_pmli.pmli01 = g_pml2.pml01
           LET l_pmli.pmli02 = g_pml2.pml02
           LET l_pmli.pmlislk01 = g_pml2.pml45
           IF NOT s_ins_pmli(l_pmli.*,'') THEN
              ERROR 'ALC2: Insert Failed because of ',SQLCA.SQLCODE
            END IF
         END IF
      END IF 
  ELSE
     #No.FUN-BB0086--add---start---
     SELECT pml07 INTO l_pml07 FROM pml_file 
      WHERE pml45 = g_pml2.pml45 and pml04 = g_pml2.pml04 
        AND pml01 = g_pml2.pml01 and rownum < 2
     LET g_pml2.pml20 = s_digqty(g_pml2.pml20,l_pml07)
     #No.FUN-BB0086--add---end---
      UPDATE pml_file set pml20 = pml20 + g_pml2.pml20 
       WHERE pml45 = g_pml2.pml45 and pml04 = g_pml2.pml04 
         AND pml01 = g_pml2.pml01 and rownum < 2
  end if
 
   IF SQLCA.sqlcode THEN 
      CALL cl_err('ins pml2',SQLCA.sqlcode,0)
      LET g_success = 'N'
   END IF
   LET g_seq = g_seq + 1
END FUNCTION
 
FUNCTION p490_inssfamm()
   DEFINE l_oeb01      LIKE oeb_file.oeb01,
          l_oeb03      LIKE oeb_file.oeb03, 
          l_oeb04      LIKE oeb_file.oeb04,
          l_oebislk01  LIKE oebi_file.oebislk01,
          l_oeb12      LIKE oeb_file.oeb12           
 
    DELETE FROM sfamm_file_temp
        
    LET g_sql = " SELECT oeb01,oeb03, oeb04,oeb12*oeb05_fac,oeb22,",
                "        oebislk01,oea09 FROM oeb_file,oebi_file,oea_file",
                "  WHERE oea01 = oeb01 and oebi01=oeb01 AND oebi03=oeb03",
                "    AND oebislk01 IN ",g_oebislk01.trim() ," and ",g_wc2
    PREPARE g_pre2 FROM g_sql
    DECLARE g_cur2 CURSOR FOR g_pre2
    FOREACH g_cur2 INTO l_oeb01,l_oeb03,l_oeb04,l_oeb12,
                        l_oeb22,l_oebislk01,g_oea09
       IF SQLCA.sqlcode THEN
          CALL cl_err('prepare2:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF        
            
       CALL s_ycralc5(g_pmk.pmk01,l_oeb04,g_sma.sma29,l_oeb12,'Y',
                      g_sma.sma71,l_oebislk01)
   END FOREACH
END FUNCTION
 
FUNCTION s_ycralc5(p_wo,p_part,p_btflg,p_woq,p_mps,p_yld,p_so)
  DEFINE ls_err    LIKE type_file.chr50
  DEFINE
      p_wo         LIKE type_file.chr18, #work order DEC
      p_part       LIKE type_file.chr50, #part DEC
      p_y          LIKE type_file.chr1,
      p_btflg      LIKE type_file.chr1, #blow through flag
      p_woq        LIKE type_file.num26_10, #work order quantity
      p_mps        LIKE type_file.chr1, #if MPS phantom, blow through flag (Y/N)
      p_yld        LIKE type_file.chr1, #inflate yield factor (Y/N)
      l_ima562     LIKE ima_file.ima562,
      l_ima910     LIKE ima_file.ima910, #TQC-8C0063
      p_so         LIKE oebi_file.oebislk01,
      p_oeb22      LIKE oeb_file.oeb22
      
   WHENEVER ERROR CONTINUE
   MESSAGE ' Allocating ' #ATTRIBUTE(REVERSE)
 
   LET g_ccc=0
   LET g_btflg=p_btflg
   LET g_wo=p_wo
   LET g_opseq=' '
   LET g_offset=0
   LET g_mps=p_mps
   LET g_yld=p_yld
   LET g_errno=' '
   IF STATUS THEN CALL cl_err('sel sfb:',STATUS,1) RETURN 0 END IF
   SELECT ima562,ima55,ima55_fac,ima86,ima86_fac,ima910    #TQC-8C0063 add ima910
     INTO l_ima562,g_ima55,g_ima55_fac,g_ima86,g_ima86_fac,l_ima910 #TQC-8C0063
     FROM ima_file
    WHERE ima01=p_part AND imaacti='Y'
   IF SQLCA.sqlcode THEN 
      let ls_err = p_part,'在aimi100中沒有該料見編號'
      CALL cl_err(ls_err,p_part,1)
      RETURN
   END IF
   IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
   IF cl_null(l_ima910) THEN LET l_ima910 = ' ' END IF    #TQC-8C0063
 
   LET g_bmb09 = g_bmb09_t
   LET g_bmb03 = g_bmb03_t
   CALL p490_cralc_bom(0,p_part,l_ima910,p_woq,1,p_so)   #TQC-8C0063 add l_ima910,cralc_bom-->p490_cralc_bom
 
   IF g_ccc=0 THEN
      LET g_errno='asf-014'
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION p490_cralc_bom(p_level,p_key,p_key3,p_total,p_QPA,p_key2) #TQC-8C0063 add p_key3,cralc_bom-->p490_cralc_bom
#No.FUN-A70034  --Begin
DEFINE l_total_1   LIKE sfa_file.sfa06
DEFINE l_QPA_1     LIKE bmb_file.bmb06
#No.FUN-A70034  --End  
  DEFINE
     p_level        LIKE type_file.num5, #level code
     p_total        LIKE type_file.num26_10,
     p_QPA          LIKE type_file.num26_10,
     l_QPA          LIKE type_file.num26_10,
     l_total        LIKE type_file.num26_10,
     l_total2       LIKE type_file.num26_10,
     p_key          LIKE type_file.chr50, 
     p_key2         LIKE oebi_file.oebislk01,
     p_key3         LIKE bma_file.bma06,   #TQC-8C0063
     l_ac,l_i,l_x,l_s LIKE type_file.num5,
     arrno          LIKE type_file.num5,
     b_seq,l_double LIKE type_file.num10,
     sr ARRAY[500]  OF RECORD
        bmb02       LIKE bmb_file.bmb02,
        bmb03       LIKE bmb_file.bmb03,
        bmb10       LIKE bmb_file.bmb10,
        bmb10_fac   LIKE bmb_file.bmb10_fac,
        bmb10_fac2  LIKE bmb_file.bmb10_fac2,
        bmb15       LIKE bmb_file.bmb15,
        bmb16       LIKE bmb_file.bmb16,
        bmb06       LIKE bmb_file.bmb06,
        bmb08       LIKE bmb_file.bmb08,
        bmb09       LIKE bmb_file.bmb09,
        bmb18       LIKE bmb_file.bmb18,
        bmb19       LIKE bmb_file.bmb19,
        bmb28       LIKE bmb_file.bmb28,
        ima08       LIKE ima_file.ima08,
        ima37       LIKE ima_file.ima37,
        ima25       LIKE ima_file.ima25,
        ima55       LIKE ima_file.ima55,
        ima86       LIKE ima_file.ima86,
        ima86_fac   LIKE ima_file.ima86_fac,
        bmb07       LIKE bmb_file.bmb07,
        bma01       LIKE bma_file.bma01,
        #No.FUN-A70034  --Begin
        bmb081      LIKE bmb_file.bmb081,
        bmb082      LIKE bmb_file.bmb082 
        #No.FUN-A70034  --End  
                    END RECORD,
     l_ima02        LIKE ima_file.ima02,
     l_ima08        LIKE ima_file.ima08,
#     l_ima26        LIKE ima_file.ima26, #FUN-A20044
     l_avl_stk_mpsmrp        LIKE type_file.num15_3, #FUN-A20044
     l_unavl_stk             LIKE type_file.num15_3, #FUN-A20044
#     l_ima262       LIKE ima_file.ima262, #FUN-A20044
     l_avl_stk       LIKE type_file.num15_3, #FUN-A20044
     l_SafetyStock  LIKE ima_file.ima27,
     l_SSqty        LIKE ima_file.ima27,
     l_ima37        LIKE ima_file.ima37,
     l_ima108       LIKE ima_file.ima108,
     l_ima64        LIKE ima_file.ima64,
     l_ima103       LIKE ima_file.ima103,
     l_ima641       LIKE ima_file.ima641,
     l_uom          LIKE ima_file.ima25,
     l_chr          LIKE type_file.chr1,
     l_sfa03        LIKE sfa_file.sfa03,
     l_sfa11        LIKE sfa_file.sfa11,
#     l_qty          LIKE ima_file.ima26, #FUN-A20044
     l_qty          LIKE type_file.num15_3, #FUN-A20044
     l_sfaqty       LIKE sfa_file.sfa05,
     l_gfe03        LIKE gfe_file.gfe03,
#     l_bal          LIKE ima_file.ima26, #FUN-A20044
     l_bal          LIKE type_file.num15_3, #FUN-A20044
     l_ActualQPA    LIKE sfa_file.sfa161,
     l_bmb06        LIKE bmb_file.bmb06, 
     l_sfa12        LIKE sfa_file.sfa12,
     l_sfa13        LIKE sfa_file.sfa13,
    #l_bml04        LIKE bml_file.bml04,   #Mark MOD-B40094
     l_insert       LIKE type_file.chr1,
     g_sw           LIKE type_file.chr1,
     l_unaloc,l_uuc LIKE sfa_file.sfa25,
     l_cnt,l_c      LIKE type_file.num5,
     l_cmd          LIKE type_file.chr1000,
     l_count        LIKE type_file.num5
    
  DEFINE l_pml20    LIKE type_file.num10
  DEFINE l_ima910    DYNAMIC ARRAY OF LIKE ima_file.ima910          #TQC-8C0063 
 
  LET p_level = p_level + 1
  IF cl_null(g_bmb09) THEN LET g_bmb09 = '1=1' END IF
  IF cl_null(g_bmb03) THEN LET g_bmb03 = ' 1=1' END IF
  LET arrno = 500
  IF cl_null(g_wc) THEN 
      LET l_cmd=
          "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
          "       bmb15,bmb16,bmb06,bmb08,bmb09,bmb18,bmb19,bmb28,",
          "       ima08,ima37,ima25,ima55,",
          "       ima86,ima86_fac,bmb07,'',",
          "       bmb081,bmb082 ",             #No.FUN-A70034
          #"  FROM bmb_file,ima_file",         #MOD-C80149 mark
          "  FROM bmb_file,ima_file,bma_file", #MOD-C80149 add
          " WHERE bmb01='", p_key,"' ",
          "   AND bmb03 = ima01",
          "   AND bmb01 = bma01",              #MOD-C80149 add
          "   AND bmaacti = 'Y'",              #MOD-C80149 add
          "   AND bmb09 <> 'WK003'",
          "   AND bmb29 = '", p_key3,"' ",   #No.FUN-870124 #TQC-8C0063
          "   AND (bmb04 <='",g_today,
          "'   OR bmb04 IS NULL) AND (bmb05 >'",g_today,
          "'   OR bmb05 IS NULL)",
          "   AND bmb14 <> '4' " ,
          "   AND ",g_bmb09 CLIPPED,
          "   AND ",g_bmb03 CLIPPED,
          " ORDER BY 1"
  ELSE
      LET l_cmd=
          "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
          "       bmb15,bmb16,bmb06,bmb08,bmb09,bmb18,bmb19,bmb28,",
          "       ima08,ima37,ima25,ima55,",
          "       ima86,ima86_fac,bmb07,'',",
          "       bmb081,bmb082 ",             #No.FUN-A70034
          #"  FROM bmb_file,ima_file",         #MOD-C80149 mark
          "  FROM bmb_file,ima_file,bma_file", #MOD-C80149 add
          " WHERE bmb01='", p_key,"'",
          "   AND bmb03 = ima01",
          "   AND bmb01 = bma01",              #MOD-C80149 add
          "   AND bmaacti = 'Y'",              #MOD-C80149 add
          "   AND bmb09 <> 'WK003'",
          "   AND bmb29 = '", p_key3,"'",   #TQC-8C0063
          "   AND (bmb04 <='",g_today,
          "'   OR bmb04 IS NULL) AND (bmb05 >'",g_today,
          "'   OR bmb05 IS NULL)",
          "   AND bmb14 <> '4' ", 
          "   AND ",g_wc CLIPPED,
          "   AND ",g_bmb09 CLIPPED,
          "   AND ",g_bmb03 CLIPPED,
          " ORDER BY 1"
   END IF 
  PREPARE cralc_ppp FROM l_cmd
  IF SQLCA.sqlcode THEN
    CALL cl_err('P1:',SQLCA.sqlcode,1)
    RETURN 0
  END IF
  DECLARE cralc_cur CURSOR FOR cralc_ppp
 
   LET b_seq=0
   WHILE TRUE
      LET l_ac = 1
      FOREACH cralc_cur  INTO sr[l_ac].*
          MESSAGE p_key CLIPPED,'-',sr[l_ac].bmb03 CLIPPED
          IF sr[l_ac].ima08 = 'D' THEN CONTINUE FOREACH END IF
      IF sr[l_ac].bmb10_fac IS NULL OR sr[l_ac].bmb10_fac=0 THEN
         LET sr[l_ac].bmb10_fac=1
      END IF
      IF sr[l_ac].bmb16 IS NULL THEN
         LET sr[l_ac].bmb16='0'
      END IF
       LET l_ima910[l_ac]=''
       SELECT ima910 INTO l_ima910[l_ac] FROM ima_file WHERE ima01=sr[l_ac].bmb03
       IF cl_null(l_ima910[l_ac]) THEN LET l_ima910[l_ac]=' ' END IF
      LET l_ac = l_ac + 1
      IF l_ac > arrno THEN EXIT FOREACH END IF
      END FOREACH
      LET l_x=l_ac-1
 
      FOR l_i = 1 TO l_x

         IF sr[l_i].bmb09 IS NOT NULL THEN
            LET g_level=p_level
            LET g_opseq=sr[l_i].bmb09
            LET g_offset=sr[l_i].bmb18
         END IF
 
         IF g_opseq IS NULL THEN LET g_opseq=' ' END IF
         IF g_offset IS NULL THEN LET g_offset=0 END IF
         #No.FUN-A70034  --Begin
         #IF g_yld='N' THEN LET sr[l_i].bmb08=0 END IF
         #LET l_bmb06 = sr[l_i].bmb06 / sr[l_i].bmb07
         #LET l_ActualQPA=(l_bmb06*(1+sr[l_i].bmb08/100))*p_QPA
         #LET l_QPA=l_bmb06 * p_QPA     
         #LET l_total=l_bmb06*p_total*((100+sr[l_i].bmb08))/100            


         CALL cralc_rate(p_key,sr[l_i].bmb03,p_total,sr[l_i].bmb081,sr[l_i].bmb08,sr[l_i].bmb082,
                         sr[l_i].bmb06/sr[l_i].bmb07,p_QPA)
              RETURNING l_total_1,l_QPA,l_ActualQPA
         LET l_QPA_1 = l_ActualQPA
         LET l_total = l_total_1
         #No.FUN-A70034  --End  
           
         LET l_total2=l_total
         LET l_sfa11='N'
         IF sr[l_i].ima08='R' THEN #routable part
            LET l_sfa11='R'
         ELSE
            IF sr[l_i].bmb15='Y' THEN #comsumable
               LET l_sfa11='E'
            ELSE
               IF sr[l_i].ima08 MATCHES '[UV]' THEN 
                LET l_sfa11=sr[l_i].ima08
               END IF
            END IF #consumable
         END IF
 
         IF g_sma.sma78='1' THEN
            LET sr[l_i].bmb10=sr[l_i].ima25
            LET l_total=l_total*sr[l_i].bmb10_fac
            LET l_total2=l_total2*sr[l_i].bmb10_fac
            LET l_QPA_1 = l_QPA_1 * sr[l_i].bmb10_fac   #No.FUN-A70034
            LET sr[l_i].bmb10_fac=1
         END IF
         LET l_ima103 =''
         SELECT ima103 INTO l_ima103 FROM ima_file
          WHERE ima01  = sr[l_i].bmb03
            AND bmaacti = 'Y'   #MOD-C80149 add
         IF STATUS THEN LET l_ima103 = '' END IF 
         SELECT  * FROM bma_file WHERE bma01=sr[l_i].bmb03
         SELECT bma01 INTO sr[l_i].bma01 FROM bma_file 
          WHERE bma01=sr[l_i].bmb03
         IF STATUS THEN 
             LET l_insert = 'Y'
         ELSE
          IF sr[l_i].bma01 IS NOT NULL THEN
          LET g_bmb09 = ' 1=1'
          LET g_bmb03 = ' 1=1'
          CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,
                        sr[l_i].ima55) RETURNING g_status,g_factor
          #No.FUN-A70034  --Begin
          #LET sr[l_i].bmb06 = sr[l_i].bmb06*g_factor/sr[l_i].bmb07
          #LET l_ActualQPA = (sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
          #CALL p490_cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],p_total*sr[l_i].bmb06, #TQC-8C0063
          #               l_ActualQPA,p_key2)

          LET l_QPA_1 = l_QPA_1 * g_factor
          LET l_total = l_total * g_factor
          CALL p490_cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_total,
                         l_QPA_1,p_key2)

          #No.FUN-A70034  --End 
          LET l_insert = 'N'
        END IF 
      END IF 
 
      IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
        LET l_uuc=0            
            
     #IF sr[l_i].bmb10='PCS' THEN   #MOD-C80223 mark
       #MOD-D10173 mark start -----
       #LET l_total = l_total + 0.999  
       #LET l_pml20 = l_total
       #LET l_total = l_pml20
       #
       #LET l_total2 = l_total2 + 0.999 
       #LET l_pml20 = l_total2
       #LET l_total2 = l_pml20
       #MOD-D10173 mark end   -----
     #END IF                        #MOD-C80223 mark
      
      IF l_insert = 'Y' THEN
        INITIALIZE g_sfa.* TO NULL
        LET g_sfa.sfa01 =g_wo
        LET g_sfa.sfa02 =g_wotype
        LET g_sfa.sfa03 =sr[l_i].bmb03
        LET g_sfa.sfa04 =l_total
        LET g_sfa.sfa05 =l_total2
        LET g_sfa.sfa06 =0
        LET g_sfa.sfa061=0
        LET g_sfa.sfa062=0
        LET g_sfa.sfa063=0
        LET g_sfa.sfa064=0
        LET g_sfa.sfa065=0
        LET g_sfa.sfa066=0
        LET g_sfa.sfa08 =g_opseq
        IF cl_null(g_sfa.sfa08) THEN LET g_sfa.sfa08=' ' END IF
        LET g_sfa.sfa09 =g_offset
        LET g_sfa.sfa11 =l_sfa11
        LET g_sfa.sfa12 =sr[l_i].bmb10
        LET g_sfa.sfa13 =sr[l_i].bmb10_fac
        LET g_sfa.sfa14 =sr[l_i].ima86
        LET g_sfa.sfa15 =sr[l_i].bmb10_fac2
        LET g_sfa.sfa16 =l_QPA
        LET g_sfa.sfa161=l_ActualQPA
        LET g_sfa.sfa25 =l_uuc
        LET g_sfa.sfa26 =sr[l_i].bmb16
        LET g_sfa.sfa27 =sr[l_i].bmb03
        LET g_sfa.sfa28 =1
        LET g_sfa.sfa29 =p_key
       #LET g_sfa.sfa31 =l_bml04  #Mark MOD-B40094
        LET g_sfa.sfaacti ='Y'
        LET g_sfa.sfa91 = p_key2
        LET g_sfa.sfa100 =sr[l_i].bmb28
        IF cl_null(g_sfa.sfa100) THEN LET g_sfa.sfa100 = 0 END IF
        LET g_sfa.sfa161=g_sfa.sfa05/p_woq
        LET g_sfa.sfaplant = g_plant  #FUN-A90063
        LET g_sfa.sfalegal = g_legal  #FUN-A90063
        LET g_sfa.sfa012 = ' '    #MOD-BB0302
        LET g_sfa.sfa013 = 0      #MOD-BB0302
        LET l_count = 0
        SELECT COUNT(*) INTO l_count FROM sfamm_file_temp
         WHERE sfa01 = g_sfa.sfa01 AND sfa03 = g_sfa.sfa03
          #AND sfa08 = g_sfa.sfa08 AND sfa12 = g_sfa.sfa12 #MOD-CA0216 mark
           AND sfa12 = g_sfa.sfa12                         #MOD-CA0216 add
           AND sfa91 = g_sfa.sfa91
        IF l_count <= 0 THEN
          INSERT INTO sfamm_file_temp VALUES(g_sfa.*)
               IF SQLCA.SQLCODE THEN    #Duplicate
#                 IF SQLCA.SQLCODE=-239 THEN #CHI-C30115 mark
                  IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
                     SELECT sfa13 INTO l_sfa13
                       FROM sfamm_file_temp
                      WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                       #AND sfa08=g_opseq AND sfa91 = g_sfa.sfa91 #MOD-CA0216 mark
                        AND sfa91 = g_sfa.sfa91                   #MOD-CA0216 add
                     LET l_sfa13=sr[l_i].bmb10_fac/l_sfa13
                     LET l_total=l_total*l_sfa13
                     LET l_total2=l_total2*l_sfa13
                     UPDATE sfamm_file_temp SET sfa04=sfa04+l_total,
                                                sfa05=sfa05+l_total2,
                                                sfa16=sfa16+l_QPA,
                                                sfa161=g_sfa.sfa161
                                               ,sfa08=' ' #MOD-CA0216 add
                      WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                       #AND sfa08=g_opseq  #MOD-CA0216 mark
                        AND sfa12=sr[l_i].bmb10
                        AND sfa91 = g_sfa.sfa91
                     IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
                        ERROR 'ALC2: Insert Failed because of ',SQLCA.sqlcode
                        CONTINUE FOR
                     END IF
                  END IF
               END IF
            ELSE
          UPDATE sfamm_file_temp SET sfa04 = sfa04 + g_sfa.sfa04,
                                     sfa05 = sfa05 + g_sfa.sfa05 
                                    ,sfa08 = ' '             #MOD-CA0216 add
           WHERE sfa01 = g_sfa.sfa01 AND sfa03 = g_sfa.sfa03
            #AND sfa08 = g_sfa.sfa08 AND sfa12 = g_sfa.sfa12 #MOD-CA0216 mark
             AND sfa12 = g_sfa.sfa12                         #MOD-CA0216 add
             AND sfa91 = g_sfa.sfa91
         END IF 
        LET g_ccc = g_ccc + 1
         END IF
         IF g_level=p_level THEN
            LET g_opseq=' '
            LET g_offset=''
         END IF
      END FOR
    IF l_x < arrno OR l_ac=1 THEN #nothing left
       EXIT WHILE
    ELSE
       LET b_seq = sr[l_x].bmb02
    END IF
   END WHILE
   
   IF p_level >1 THEN RETURN END IF
 
   DECLARE cr_cr2 CURSOR FOR
   SELECT sfamm_file_temp.*,
#          ima08,ima262,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
          ima08,0,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
     FROM sfamm_file_temp,OUTER ima_file
    WHERE sfa01=g_wo AND ima_file.ima01=sfa03
#   FOREACH cr_cr2 INTO g_sfa.*,l_ima08,l_ima262, #FUN-A20044
   FOREACH cr_cr2 INTO g_sfa.*,l_ima08,l_avl_stk, #FUN-A20044
                       l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641,l_uom
    CALL s_getstock( g_sfa.sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    LET g_opseq=g_sfa.sfa08
   #IF g_sfa.sfa26 MATCHES '[SUT]' THEN CONTINUE FOREACH END IF   #FUN-A20037
    IF g_sfa.sfa26 MATCHES '[SUTZ]' THEN CONTINUE FOREACH END IF  #FUN-A20037 
    IF l_ima08 = 'D' THEN CONTINUE FOREACH END IF 
    MESSAGE '--> ',g_sfa.sfa03,g_sfa.sfa08
    LET l_sfa03 = g_sfa.sfa03
    
    #Inflate With Minimum Issue Qty And Issue Pansize
    IF l_ima641 != 0 AND g_sfa.sfa05 < l_ima641 THEN
      LET g_sfa.sfa05=l_ima641
    END IF
    IF l_ima64!=0 THEN
      LET l_double=(g_sfa.sfa05/l_ima64)+ 0.999999
      LET g_sfa.sfa05=l_double*l_ima64
    END IF
    
    SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_sfa.sfa12
    IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
    CALL cl_digcut(g_sfa.sfa05,l_gfe03) RETURNING l_sfaqty
    LET g_sfa.sfa05 =  l_sfaqty
    
#    IF cl_null(l_ima262) THEN LET l_ima262=0 END IF
 #   LET l_ima26=l_ima262 #FUN-A20044
#    IF l_ima26<0 THEN LET l_ima26=0 END IF #FUN-A20044
    IF l_avl_stk_mpsmrp<0 THEN LET l_avl_stk_mpsmrp=0 END IF #FUN-A20044
   END FOREACH
   
END FUNCTION

#-----MOD-A20055--------- 
#FUNCTION cralc_sou(p_part,p_sou,p_offset,p_qpa,
#                   p_isuom,p_i2s,p_i2c,p_needqty,p_consumable,p_upart)
#  DEFINE
#      p_part       LIKE ima_file.ima01,
#      p_upart      LIKE ima_file.ima01,
#      p_sou        LIKE type_file.chr1,
#      p_offset     LIKE bmb_file.bmb18,
#      p_qpa        LIKE bmb_file.bmb06,
#      p_isuom      LIKE bmb_file.bmb10,
#      p_i2s        LIKE bmb_file.bmb10_fac,
#      p_i2c        LIKE bmb_file.bmb10_fac2,
#      p_needqty    LIKE ima_file.ima26,
#      p_consumable LIKE bmb_file.bmb15,
#      l_bmd03      LIKE bmd_file.bmd03,
#      l_bmd04      LIKE bmd_file.bmd04,
#      l_bmd07      LIKE bmd_file.bmd07,
#      l_qoh        LIKE ima_file.ima262,
#      l_ima262     LIKE ima_file.ima262,
#      l_ima27      LIKE ima_file.ima27,
#      l_sc         LIKE ima_file.ima08,
#      l_qty,l_sqty LIKE ima_file.ima262,
#      l_total      LIKE sfa_file.sfa05,
#      l_sfa26      LIKE sfa_file.sfa26,
#      l_sfa11      LIKE sfa_file.sfa11,
#      l_sfa13      LIKE sfa_file.sfa13,
#      l_first      LIKE type_file.chr1,
#      l_i          LIKE type_file.num5,
#      ss_qty,tt_qty      LIKE type_file.num26_10,
#      l_unaloc,l_uqty    LIKE sfa_file.sfa25
# 
#  LET l_unaloc=p_needqty #unallocated qty
#  DECLARE sou_cur CURSOR FOR
#  SELECT bmd03,bmd04,bmd07,ima262,ima27,ima08
#    FROM bmd_file,OUTER ima_file
#   WHERE ima_file.ima01=bmd04 AND bmd01=p_part
#     AND bmd02=p_sou AND (bmd08=p_upart OR bmd08='ALL')
#     AND (bmd05<=g_today OR bmd05 IS NULL)    #effective date
#     AND (bmd06>=g_today OR bmd06 IS NULL)    #ineffective date
#     AND bmdacti = 'Y'                                           #CHI-910021
#  ORDER BY 1
# 
#   IF p_sou='1' THEN
#      LET l_sfa26='U'
#   ELSE
#      LET l_sfa26='S'
#   END IF
# 
#  LET l_i=0
#  FOREACH sou_cur INTO l_bmd03,l_bmd04,l_bmd07,l_ima262,l_ima27,l_sc
#    IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
# 
#    IF l_bmd07 IS NULL OR l_bmd07 <=0 THEN LET l_bmd07=1 END IF
#    IF cl_null(l_ima262) THEN LET l_ima262=0 END IF
#    IF cl_null(l_ima27)  THEN LET l_ima27=0  END IF
#    LET l_qoh=l_ima262
#    IF p_sou='1' THEN
#         LET l_qoh=l_ima262-l_ima27
#    END IF
#    IF l_qoh <=0 OR l_qoh IS NULL THEN CONTINUE FOREACH END IF
#    SELECT SUM(sfa05-sfa06) INTO l_qty FROM sfamm_file_temp
#     WHERE sfa03=l_bmd04 AND sfa05>sfa06 AND sfa01<>g_wo
#    IF l_qty IS NULL THEN LET l_qty=0 END IF
#    LET l_qoh=l_qoh-l_qty
#    IF l_qoh <=0 THEN CONTINUE FOREACH END IF
#    
#    LET l_unaloc=l_unaloc*l_bmd07
#    IF l_qoh >= l_unaloc  THEN
#         LET l_total=l_unaloc
#         LET l_unaloc=0
#      ELSE
#         LET l_total=l_qoh
#         LET l_unaloc=l_unaloc-l_qoh
#      END IF
# 
#    LET l_sfa11='N'
#    IF p_consumable='E' THEN
#      LET l_sfa11='E'
#    ELSE
#      IF l_sc MATCHES '[UVR]' THEN
#         LET l_sfa11=l_sc
#      END IF
#    END IF
#    LET ss_qty=l_sqty/p_i2s
#    LET tt_qty=l_uqty/p_i2s
#    IF cl_null(g_opseq) THEN LET g_opseq=' ' END IF
#    IF g_offset IS NULL THEN LET g_offset = 0 END IF
#    SELECT ima86 INTO g_ima86 FROM ima_file WHERE ima01 = l_bmb04
#    LET g_sfa.sfa01 =g_wo
#    LET g_sfa.sfa02 =g_wotype
#    LET g_sfa.sfa03 =l_bmd04
#    LET g_sfa.sfa04 =0
#    LET g_sfa.sfa05 =l_total
#    LET g_sfa.sfa06 =0
#    LET g_sfa.sfa061=0
#    LET g_sfa.sfa062=0
#    LET g_sfa.sfa063=0
#    LET g_sfa.sfa064=0
#    LET g_sfa.sfa065=0
#    LET g_sfa.sfa066=0
#    LET g_sfa.sfa08 =g_opseq
#    IF cl_null(g_sfa.sfa08) THEN LET g_sfa.sfa08=' ' END IF
#    LET g_sfa.sfa09 =p_offset
#    LET g_sfa.sfa11 =l_sfa11
#    LET g_sfa.sfa12 =p_isuom
#    LET g_sfa.sfa13 =p_i2s
#    LET g_sfa.sfa14 =g_ima86
#    LET g_sfa.sfa15 =p_i2c
#    LET g_sfa.sfa16 =0
#    LET g_sfa.sfa161=0
#    LET g_sfa.sfa25 =l_total
#    LET g_sfa.sfa26 =l_sfa26
#    LET g_sfa.sfa27 =p_part
#    LET g_sfa.sfa28 =l_bmd07
#    LET g_sfa.sfa29 =p_upart
#    IF cl_null(g_sfa.sfa100) THEN LET g_sfa.sfa100 = 0  END IF
#    LET g_sfa.sfaacti ='Y'
#    INSERT INTO sfamm_file_temp VALUES(g_sfa.*)
#    IF SQLCA.SQLCODE THEN
#      IF SQLCA.SQLCODE=-239 THEN
#        LET l_sfa13 = 0
#        SELECT sfa13 INTO l_sfa13
#          FROM sfamm_file_temp
#         WHERE sfa01=g_wo AND sfa03=l_bmd04
#           AND sfa08=g_opseq AND sfa91 = g_sfa.sfa91
#        LET l_sfa13=p_i2s/l_sfa13
#        LET l_total=l_total*l_sfa13
#        UPDATE sfamm_file_temp SET sfa05=sfa05+l_total,
#                                   sfa25=sfa25+l_total,
#                                   sfa28=sfa28+l_bmd07,
#                                   sfa161=g_sfa.sfa161  #NO.3494
#         WHERE sfa01=g_wo AND sfa03=l_bmd04
#           AND sfa08=g_opseq and sfa91 = g_sfa.sfa91
#         ELSE
#            CALL cl_err('ins sfa(3)',STATUS,1)
#      END IF
#    END IF
#    LET g_ccc=g_ccc+1
#    LET l_i=l_i+1
#    IF l_sfa26='U' THEN 
#      LET l_unaloc=l_unaloc/l_bmd07
#      EXIT FOREACH
#    END IF
#      IF l_unaloc = 0 THEN
#        EXIT FOREACH
#      ELSE
#        LET l_unaloc=l_unaloc/l_bmd07
#      END IF
#  END FOREACH
#   RETURN l_unaloc,l_i
#END FUNCTION
#-----END MOD-A20055-----
 
FUNCTION p490_deb()
   DEFINE l_pml20     LIKE pml_file.pml20,
          l_pml_file  RECORD LIKE pml_file.*
   DEFINE r,i,j       LIKE type_file.num10
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_pml02     DYNAMIC ARRAY OF LIKE pml_file.pml02 #No.FUN-870124
   DEFINE l_i1        LIKE type_file.num5    #No.FUN-870124
 
   BEGIN WORK
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DELETE FROM pml_file WHERE pml01 = g_pmk.pmk01
      IF STATUS THEN
         CALL cl_err('delete',STATUS,1)
         LET g_success = 'N'
      ELSE
         IF NOT s_industry('std') THEN                                                                                                 
            IF NOT s_del_pmli(g_pmk.pmk01,'','') THEN                                                                                  
               LET g_success = 'N'
               ROLLBACK WORK                                                                                                           
            END IF                                                                                                                     
         END IF                                                                                                                        
      END IF
      LET l_i = 0
      SELECT count(*) INTO l_i FROM pml_file_temp WHERE pml01 = g_pmk.pmk01
      IF l_i > 0 THEN
        INSERT INTO pml_file SELECT * FROM pml_file_temp WHERE pml01 = g_pmk.pmk01
        IF STATUS THEN
           CALL cl_err('insert',STATUS,1)
           LET g_success = 'N'
        END IF
        IF NOT s_industry('std') THEN
        INSERT INTO pmli_file SELECT pml01,pml02,' ',pmlplant,pmllegal FROM pml_file_temp WHERE pml01 = g_pmk.pmk01	#FUN-980006 add pmlplant,pmllegal	#TQC-980142
        IF STATUS THEN
           CALL cl_err('insert',STATUS,1)
           LET g_success = 'N'
        END IF
        END IF
      END IF
   ELSE
    FOR l_i = 1 TO g_rec_b
      IF g_pml[l_i].sele = 'N' THEN
        DELETE FROM pml_file WHERE pml01 = g_pmk.pmk01 AND pml02 = g_pml[l_i].pml02
        IF STATUS THEN
          CALL cl_err('delete',STATUS,1)
          LET g_success = 'N'
        END IF
      IF NOT s_industry('std') THEN                                                                                                 
         IF NOT s_del_pmli(g_pmk.pmk01,g_pml[l_i].pml02,'') THEN                                                                                  
            ROLLBACK WORK                                                                                                           
         END IF                                                                                                                     
      END IF                                                                                                                        
    END IF
    END FOR
    IF NOT s_industry('std') THEN                                                                                                   
    DECLARE pml_cury CURSOR FOR                                                                                                     
      SELECT pml02 FROM pml_file                                                                                                    
       WHERE pml01 = g_pmk.pmk01                                                                                                    
         AND pml20 = 0                                                                                                              
      LET l_i1 = 1                                                                                                                   
      FOREACH pml_cury INTO l_pml02[l_i1]                                                                                            
         IF NOT s_del_pmli(g_pmk.pmk01,l_pml02[l_i1],'') THEN                                                                        
            LET g_success = 'N'
            ROLLBACK WORK                                                                                                           
         END IF                                                                                                                     
      LET l_i1 = l_i1 + 1                                                                                                             
      END FOREACH                                                                                                                   
    END IF
      DELETE FROM pml_file WHERE pml01 = g_pmk.pmk01 AND pml20 = 0
      IF STATUS THEN
         CALL cl_err('delete',STATUS,1)
         LET g_success = 'N'
      END IF
      
     IF tm.add = 'Y' THEN
       DECLARE p490_b_r CURSOR FOR
        SELECT * FROM pml_file_temp 
         WHERE pml01 = g_pmk.pmk01
       ORDER BY pml02
       FOREACH p490_b_r INTO l_pml_file.*
        IF STATUS THEN
             CALL cl_err('foreach',STATUS,1)
             LET g_success = 'N'
             EXIT FOREACH
          END IF
    
        UPDATE pml_file SET * = l_pml_file.*
         WHERE pml01 = l_pml_file.pml01 AND pml04 = l_pml_file.pml04
           AND pml_file.pml45 = l_pml_file.pml45
          IF STATUS THEN
             CALL cl_err('upd reset',STATUS,1) 
             LET g_success = 'N'
             EXIT FOREACH
          END IF
       END FOREACH
     END IF   
   END IF
 
   IF SQLCA.SQLCODE OR g_success = 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
 
   DECLARE p490_b_c CURSOR FOR 
   SELECT pml02 FROM pml_file 
    WHERE pml01 = g_pmk.pmk01
    ORDER BY pml02
 
   BEGIN WORK
   LET g_success = 'Y'
   LET i = 0
 
   FOREACH p490_b_c INTO j
      IF STATUS THEN
         CALL cl_err('foreach',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET i = i + 1
      UPDATE pml_file SET pml02 = i
      #WHERE pml01 = g_pmk.pmk01 AND pml02 = g_pml[l_ac].pml02
       WHERE pml01 = g_pmk.pmk01 AND pml02 = g_pml[j].pml02    #MOD-BB0302
      IF STATUS THEN
         CALL cl_err('upd pml02',STATUS,1) 
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF NOT s_industry('std') THEN
         UPDATE pmli_file SET pmli02 = i
          WHERE pmli01 = g_pmk.pmk01
            AND pmli02 = j
         IF STATUS THEN
            CALL cl_err('upd pmli02',STATUS,1) 
            LET g_success = 'N'
            EXIT FOREACH
         END IF
      END IF
   END FOREACH
 
   IF g_success = 'Y' THEN
      COMMIT WORK 
   ELSE
      ROLLBACK WORK
      RETURN
   END IF
   CALL cl_set_act_visible("insert,delete",TRUE)
END FUNCTION
#No.FUN-9C0071-------精簡程式--------

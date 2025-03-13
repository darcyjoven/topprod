# Prog. Version..: '5.30.06-13.03.20(00010)'     #
#
# Pattern name...: sapmp500.4gl
# Descriptions...:
# Date & Author..: 10/02/21 By liuxqa 
# Modify.........: No:FUN-A20039 10/02/21 By liuxqa 依产品订单展BOM请购
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-A70056 10/07/13 By liuxqa 功能改善
# Modify.........: No:FUN-A70034 10/07/23 By Carrier 平行工艺-分量损耗运用
# Modify.........: No:FUN-A80016 10/08/02 By houlia 加傳參數接收QBE資料
# Modify.........: No:FUN-A90063 10/09/27 By rainy INSERT INTO p630_tmp時，應給 plant/legal值
# Modify.........: No:TQC-AB0397 10/11/30 By wangxin 給pml91默認值
# Modify.........: No:FUN-B10047 11/01/19 By wangxin 修改p500（）函數中第三個參數的類型  
# Modify.........: No:MOD-B40094 11/04/13 By zhangll 廠牌賦值無意義，為不再引起困擾故取消
# Modify.........: No:MOD-B50130 11/05/16 By lilingyu 根據訂單+BOM轉請購需求,沒有考慮發料單位
# Modify.........: No:MOD-B90127 11/09/16 By 如果是axmt410調用該程式，則不可有transaction和created、drop table的動作
# Modify.........: No:FUN-BB0086 11/12/07 By tanxc 增加數量欄位小數取位
# Modify.........: No:MOD-C30383 12/03/16 By dongsz 增加對請購單的作廢檢查，排除已作廢數量 
# Modify.........: No:TQC-C50077 12/05/02 By zhuhao 增加欄位ima021
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No:MOD-C70076 12/07/06 By SunLM 添加采购料件单位与发料单位转换率
# Modify.........: No:MOD-C70202 12/07/19 By Elise 程式段目前沒有用到,mark掉DECLARE cr_cr2 CURSOR段程式
# Modify.........: No:MOD-C80212 12/09/03 By Vampire 單位轉換後才做最少採購量/倍量計算
# Modify.........: No:MOD-C80225 12/09/20 By jt_chen 還原 MOD-C70076 修改
# Modify.........: No:MOD-C80223 12/09/20 By jt_chen 不再判斷PCS的條件做進位動作
# Modify.........: No:MOD-C80149 12/10/18 By Nina 增加串bma_file,並排除無效BOM
# Modify.........: No:MOD-CA0216 13/01/31 By Elise 調整依料號將數量加總,寫入sfamm_file_temp時取消sfa08這個key值條件
# Modify.........: No:MOD-CA0054 13/02/01 By Elise (1) 多角訂單比照MOD-B90127處理
#                                                  (2) 因行業別關係,請修正判斷g_prog改用g_prog[1,7]判斷
# Modify.........: No:MOD-CA0158 13/02/01 By Elise 增加判斷項次
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
   g_pnl           RECORD LIKE pnl_file.*,     
   g_pml_arrno     LIKE type_file.num5,
   g_pml_sarrno    LIKE type_file.num5,
   g_pml_pageno    LIKE type_file.num5,
    
   g_pml           DYNAMIC ARRAY of RECORD
                   pml02       LIKE pml_file.pml02,   #項次
                   pml42       LIKE pml_file.pml42,   #替代碼
                   pml04       LIKE pml_file.pml04,   #料件編號
                   pml041      LIKE pml_file.pml041,  #品名規格
                   ima021      LIKE ima_file.ima021,  #規格     #TQC-C50077 add
                   pml08       LIKE pml_file.pml08,   #庫存單位
                   req_qty     LIKE pml_file.pml20,   #本次需求量
                   ima27       LIKE pml_file.pml20,   #安全庫存量
                   al_qty      LIKE pml_file.pml20,   #分配量
#                   ima262      LIKE pml_file.pml20,   #庫存可用量 #FUN-A20044
                   avl_stk      LIKE type_file.num15_3,   #庫存可用量 #FUN-A20044
                   qc_qty      LIKE pml_file.pml20,   #檢驗量
                   po_qty      LIKE pml_file.pml20,   #採購量
                   pr_qty      LIKE pml_file.pml20,   #請購量
                   wo_qty      LIKE pml_file.pml20,   #在制量
                   sh_qty      LIKE pml_file.pml20,   #缺料量
                   pml07       LIKE pml_file.pml07,   #請購單位
                   pml09       LIKE pml_file.pml09,   #換算率
                   su_qty      LIKE pml_file.pml20,   #建議量
                   pml35       LIKE pml_file.pml35    #到庫日期
                   END RECORD,
   g_pml_t         RECORD
                   pml02       LIKE pml_file.pml02,   #項次
                   pml42       LIKE pml_file.pml42,   #替代碼
                   pml04       LIKE pml_file.pml04,   #料件編號
                   pml041      LIKE pml_file.pml041,  #品名規格
                   ima021      LIKE ima_file.ima021,  #規格     #TQC-C50077 add
                   pml08       LIKE pml_file.pml08,   #庫存單位
                   req_qty     LIKE pml_file.pml20,   #本次需求量
                   ima27       LIKE pml_file.pml20,   #安全庫存量
                   al_qty      LIKE pml_file.pml20,   #分配量
#                   ima262      LIKE pml_file.pml20,   #庫存可用量 #FUN-A20044
                   avl_stk      LIKE type_file.num15_3,   #庫存可用量 #FUN-A20044
                   qc_qty      LIKE pml_file.pml20,   #檢驗量
                   po_qty      LIKE pml_file.pml20,   #採購量
                   pr_qty      LIKE pml_file.pml20,   #請購量
                   wo_qty      LIKE pml_file.pml20,   #在制量
                   sh_qty      LIKE pml_file.pml20,   #缺料量
                   pml07       LIKE pml_file.pml07,   #請購單位
                   pml09       LIKE pml_file.pml09,   #換算率
                   su_qty      LIKE pml_file.pml20,   #建議量
                   pml35       LIKE pml_file.pml35    #到庫日期
                   END RECORD,
               tm  RECORD 
                   oeb01       LIKE oeb_file.oeb01,     #訂單單號
                   oeb03       LIKE oeb_file.oeb03,     #訂單項次
                   oea03       LIKE oea_file.oea03,     #客户编号 
                   oea14       LIKE oea_file.oea14,     #业务员
                   wc             STRING,  
                   bdate       DATE,         
                   sudate      DATE,                    #供給截至日期
                   a           LIKE type_file.chr1,     #庫存可用量
                   b           LIKE type_file.chr1,     #檢驗量
                   c           LIKE type_file.chr1,     #請購量
                   d           LIKE type_file.chr1,     #采購量
                   e           LIKE type_file.chr1,     #在制量
                   f           LIKE type_file.chr1,     #已備料量
                   g           LIKE type_file.chr1     #建議量是否考慮安全庫存
                   END RECORD,
   t_pml           RECORD LIKE pml_file.*,
   g_ima25         LIKE ima_file.ima25,
   g_ima44         LIKE ima_file.ima44,
   g_ima906        LIKE ima_file.ima906,
   g_ima907        LIKE ima_file.ima907,
   g_argv1         LIKE type_file.chr1, 
   g_sw            LIKE type_file.chr1, 
   g_wc            LIKE type_file.chr1000,           #NO.FUN-910082
   g_wc2           STRING,           
   g_wc3           STRING,           
   g_sql           STRING,          
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
   g_flag         LIKE type_file.chr1
DEFINE g_where    STRING
DEFINE g_forupd_sql STRING
    
DEFINE g_pml02    LIKE pml_file.pml02
 
#FUN-A80016 --modify  加傳參數接收QBE資料
#FUNCTION p500(p_argv1,p_argv2)
FUNCTION p500(p_argv1,p_argv2,p_argv3)     #FUN-A80016
   DEFINE l_time     LIKE type_file.chr8,
          l_sql      STRING,       #NO.FUN-910082   
          p_argv1    LIKE type_file.chr1,
          p_argv2    LIKE pmm_file.pmm01,
          #p_argv3   LIKE type_file.chr1,      #FUN-A80016  #FUN-B10047 amrk
          p_argv3    STRING,                                #FUN-B10047 add
          l_pnl01    LIKE pnl_file.pnl01,
          l_wo       LIKE sfa_file.sfa01,
          l_part     LIKE sfa_file.sfa03
 
   WHENEVER ERROR CONTINUE
   IF p_argv2 IS NULL OR p_argv2 = ' ' THEN 
      CALL cl_err(p_argv2,'mfg3527',0) 
      RETURN
   END IF
   LET g_sw = 'Y'
   LET g_argv1      = p_argv1
   LET g_pmk.pmk01  = p_argv2
   LET g_wc2 = p_argv3          #FUN-A80016 --add
   DELETE FROM apm_p470
   SELECT count(*) INTO g_pml02 FROM pml_file
    WHERE pml01 = g_pmk.pmk01
   IF cl_null(g_pml02) THEN LET g_pml02 = 0 END IF
   
  #IF g_prog != 'axmt410' THEN #MOD-B90127  #MOD-CA0054 mark
   IF g_prog[1,7] != 'axmt410' THEN         #MOD-CA0054 add
      IF g_prog[1,7] != 'axmt810' THEN      #MOD-CA0054 add
         DROP TABLE pml_file_temp
         SELECT * FROM pml_file WHERE pml01 = g_pmk.pmk01
           INTO TEMP pml_file_temp
#TQC-A70056 add --begin
         DROP TABLE sfamm_file_temp
         SELECT  * FROM SFA_FILE WHERE sfa01 = g_pmk.pmk01 
           INTO TEMP sfamm_file_temp        
      END IF                                #MOD-CA0054 add
   END IF #MOD-B90127
   INITIALIZE tm.* TO NULL      # Default condition
   LET tm.a = 'Y'
   LET tm.b = 'Y'
   LET tm.c = 'Y'
   LET tm.d = 'Y'
   LET tm.e = 'Y'
   LET tm.f = 'Y'
   LET tm.g = 'Y'
   LET tm.bdate  = TODAY
   LET tm.sudate = TODAY

#TQC-A70056 add --end    
  WHILE TRUE
    IF p_argv1 = 'G' THEN 
      IF g_sw != 'N' THEN 
        
        OPEN WINDOW p500_g WITH FORM "apm/42f/apmp500_a"
          ATTRIBUTE (STYLE = g_win_style CLIPPED)
        CALL cl_ui_locale("apmp500_a")
 
      END IF
      CALL p500_tm() 
      IF INT_FLAG THEN 
        CLOSE WINDOW p500_g 
        EXIT WHILE 
      END IF
#TQC-A70056 mark --begin
#      DROP TABLE sfamm_file_temp
#      SELECT  * FROM SFA_FILE WHERE sfa01 = g_pmk.pmk01 
#          INTO TEMP sfamm_file_temp                             
#         #PREPARE p500_pbsfamm FROM l_sql
#         #DECLARE p500_cssfamm CURSOR FROM l_sql
#         #EXECUTE p500_cssfamm
#TQC-A70056 mark --end
    ELSE 
         IF g_wc2 IS NULL OR g_wc2 = ' ' THEN LET g_wc2 = " 1=1 "  END IF
    END IF
    CALL cl_wait()
    CALL p500_inssfamm()
    CALL p500_g() 
    IF g_sw = 'N' THEN 
      CALL cl_err(g_pmk.pmk01,'mfg2601',0)
      CONTINUE WHILE
    END IF
    ERROR ""
    EXIT WHILE
  END WHILE
   IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
   CLOSE WINDOW p500_g
 
   OPEN WINDOW p500_w WITH FORM "apm/42f/apmp500_b"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) 
   CALL cl_ui_locale("apmp500_b")
 
   SELECT pmk02,pmk04 INTO g_pmk.pmk02,g_pmk.pmk04 
     FROM pmk_file
    WHERE pmk01 = g_pmk.pmk01
   DISPLAY BY NAME g_pmk.pmk01 #ATTRIBUTE(YELLOW)   #TQC-8C0076
   DISPLAY BY NAME g_pmk.pmk02 #ATTRIBUTE(YELLOW)   #TQC-8C0076
   DISPLAY BY NAME g_pmk.pmk04 #ATTRIBUTE(YELLOW)   #TQC-8C0076
 
   CALL p500_b_fill("")
   CALL p500_b()
   CALL p500_deb()
 
   CLOSE WINDOW p500_w
END FUNCTION
   
 
FUNCTION p500_tm()
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
 
   
   CONSTRUCT BY NAME g_wc2 ON oeb01,oeb03,oea03,oea14
   BEFORE CONSTRUCT
      CALL cl_qbe_init()

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
            WHEN INFIELD(oea03)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_occ3"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea03
               NEXT FIELD oea03
            WHEN INFIELD(oea14)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.state = 'c'
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oea14
               NEXT FIELD oea14
          OTHERWISE EXIT CASE
      END CASE
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
   END CONSTRUCT
   LET g_wc2 = g_wc2 CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
   IF cl_null(g_wc2) THEN LET g_wc2 = '1=1' END IF
   CALL cl_wait() 
   INITIALIZE tm.* TO NULL      # Default condition 
   LET tm.a = 'Y'   
   LET tm.b = 'Y'
   LET tm.c = 'Y'  
   LET tm.d = 'Y'
   LET tm.e = 'Y'   
   LET tm.f = 'Y'
   LET tm.g = 'Y'   
   LET tm.bdate  = TODAY
   LET tm.sudate = TODAY
   INPUT BY NAME tm.sudate,tm.a,tm.b,tm.c,  
                 tm.d,tm.e,tm.f,tm.g
                 WITHOUT DEFAULTS HELP 1
      
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
         
      ON KEY(CONTROL-G)
         CALL cl_cmdask()
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      AFTER INPUT 
         IF tm.sudate IS NULL AND tm.sudate = ' '
         THEN NEXT FIELD sudate
         END IF
         IF INT_FLAG THEN EXIT INPUT END IF

   END INPUT
   IF INT_FLAG THEN RETURN END IF
END FUNCTION
 
FUNCTION p500_cur()
   DEFINE l_sql        STRING       #NO.FUN-910082  

#---->讀取備料量(應發量-已發量)
   LET l_sql = " SELECT sum((sfa05-sfa06-sfa065)*sfa13) ",
               "   FROM sfa_file,sfb_file ",
               "  WHERE sfa01 = sfb01",
               "    AND sfa03 = ? " ,
               "    AND sfb04 !='8' ",
               "    AND sfb02 !='2' AND sfb02 != '11' AND sfb87!='X' ",
               "    AND sfb13 <='",tm.sudate,"'"
   PREPARE p500_presfa  FROM l_sql
   DECLARE p500_cssfa  CURSOR WITH HOLD FOR p500_presfa

#---->讀取獨立性需求量(工單最晚完工日) 
   LET l_sql = " SELECT sum((rpc13-rpc131)*rpc16_fac) ",
               "   FROM rpc_file WHERE rpc01 = ? ",
               "    AND rpc12 <='",tm.sudate,"'"
   PREPARE p500_prerpc  FROM l_sql
   DECLARE p500_csrpc  CURSOR WITH HOLD FOR p500_prerpc

#---->讀取請購量(請購量-已轉採購量)(日期區間)
   LET l_sql = " SELECT sum((pml20-pml21)*pml09) FROM pml_file,pmk_file ",
               "  WHERE pmk01=pml01 AND pmk18 != 'X' ",
               "    AND pml04 = ? ",
               "    AND (pml16 < '6' OR pml16 = 'S' OR pml16='R' OR pml16='W') ",
               "    AND (pml011 = 'REG' OR pml011 = 'IPO') ",
               "    AND pml01 != '",g_pmk.pmk01,"'",
               "    AND pml35 <= '",tm.sudate,"'",
               "    AND (pmk25 < '6' OR pmk25 = 'S' OR pmk25='R' OR pmk25='W') " #MOD-C30383 add
    PREPARE p500_prepml  FROM l_sql
    DECLARE p500_cspml  CURSOR WITH HOLD FOR p500_prepml
 
#---->讀取採購量(採購量-已交量)/檢驗量(pmn51)(日期區間)
   LET l_sql = " SELECT sum(((pmn20-(pmn50-pmn55))/pmn62)*pmn09) ",
               "   FROM pmn_file,pmm_file ",
               "  WHERE pmm01=pmn01 AND pmm18 != 'X' ",
               "    AND pmn61 = ? ",
               "    AND (pmn16 < '6' OR pmn16 = 'S' OR pmn16='R' OR pmn16='W') ",
               "    AND (pmn011 = 'REG' OR pmn011 = 'IPO') ",
               "    AND (pmn20-(pmn50-pmn55)) > 0 ",
               "    AND pmn35 <= '",tm.sudate,"'"
    PREPARE p500_prepmn  FROM l_sql
    DECLARE p500_cspmn  CURSOR WITH HOLD FOR p500_prepmn

#---->讀取在驗量(rvb_file)不考慮日期 
   LET l_sql = " SELECT sum((rvb07-rvb29-rvb30)*pmn09) ",
               "   FROM rvb_file,rva_file,pmn_file   ",
               "  WHERE rva01=rvb01 AND rvaconf = 'Y' ",
               "    AND rvb04=pmn01 ",               
               "    AND rvb03=pmn02 ",
               "    AND rvb05 = ?  "
   PREPARE p500_prervb FROM l_sql
   DECLARE p500_csrvb  CURSOR WITH HOLD FOR p500_prervb

#--->讀取工單量(生產數量-入庫量-報廢量)(日期區間)
     LET l_sql = " SELECT sum((sfb08-sfb09-sfb12)*ima55_fac) ", 
                 "   FROM sfb_file,ima_file ",
                 "  WHERE sfb05 = ? ",
                 "    AND ima01=sfb05 ",      
                 "    AND sfb04 != '8' ",
                 "    AND sfb02 != '2' AND sfb02 != '11' AND sfb87!='X' ",
                 "    AND sfb15 <= '",tm.sudate,"'"
     PREPARE p500_p_sfb  FROM l_sql
     DECLARE p500_c_sfb  CURSOR WITH HOLD FOR p500_p_sfb
 
END FUNCTION
 
FUNCTION p500_g()
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
           l_req_qry  LIKE type_file.num10,
           l_cn       LIKE type_file.num5
#DEFINE     l_sfa12    LIKE sfa_file.sfa12, #MOD-C70076 add   #MOD-C80225 mark
DEFINE     l_status   LIKE type_file.num5,                   #MOD-C80225 add DEFINE 
           l_factor   LIKE ima_file.ima31_fac,
           l_ima44    LIKE ima_file.ima44  
   LET l_sql = "SELECT  sfa03,sfa26,sfa05-sfa06-sfa065 ",  ##MOD-C70076 add sfa12   #MOD-C80225 remove ,sfa12
               "  FROM sfamm_file_temp,ima_file",
               " WHERE sfa03 = ima01  ",
               " ORDER BY sfa03" 
 
   PREPARE p500_prepare FROM l_sql
   DECLARE p500_cs CURSOR WITH HOLD FOR p500_prepare
#-->相關數據讀取
   CALL p500_cur()
#--->請購單身預設值
#   IF g_argv1 = 'G' THEN   #TQC-A70056 mark
      CALL p500_pmlini()
      SELECT max(pml02)+1 INTO g_seq FROM pml_file WHERE pml01 = g_pmk.pmk01
      IF g_seq IS NULL OR g_seq = ' ' OR g_seq = 0 THEN
         LET g_seq = 1
      END IF
#   END IF             #TQC-A70056 mark

   LET g_sw = 'Y' 
   LET g_success = 'Y'
   
  #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
   IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
      IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
         BEGIN WORK
      END IF #MOD-CA0054 add 
   END IF #MOD-B90127
 
   FOREACH p500_cs INTO l_sfa03,l_sfa26,req_qty    ##MOD-C70076 add sfa12   #TQC-C70094 mod l_sfa12 -> sfa12   #MOD-C80225 remove ,sfa12
      IF SQLCA.sqlcode THEN
         LET g_success = 'N'
         IF g_bgerr THEN
            CALL s_errmsg("","","p500_cs",SQLCA.sqlcode,1)
         ELSE 
            CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_cs",0)
         END IF
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
          #--->產生備料數量
          OPEN p500_cssfa USING l_sfa03
          IF SQLCA.sqlcode THEN
          IF g_bgerr THEN
             CALL s_errmsg("","","p500_cssfa",SQLCA.sqlcode,1)
             CONTINUE FOREACH
          ELSE
             CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_cssfa",0)
             EXIT FOREACH
          END IF
          END IF
          FETCH p500_cssfa INTO al_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_cssfa",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_cssfa",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生獨立性數量
          OPEN p500_csrpc USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_csrpc",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_csrpc",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p500_csrpc INTO rpc_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_csrpc",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_csrpc",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生請購數量
          OPEN p500_cspml USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_cspml",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_cspml",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p500_cspml INTO pr_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_cspml",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_cspml",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生採購數量
          OPEN p500_cspmn USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_cspmn",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_cspmn",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p500_cspmn INTO po_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_cspmn",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_cspmn",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生採購檢驗量
          OPEN p500_csrvb  USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_csrvb",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_csrvb",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p500_csrvb INTO qc_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_csrvb",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_csrvb",0)
                EXIT FOREACH
             END IF
          END IF
          #--->產生在制量
          OPEN p500_c_sfb USING l_sfa03
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_c_sfb",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_c_sfb",0)
                EXIT FOREACH
             END IF
          END IF
          FETCH p500_c_sfb INTO wo_qty
          IF SQLCA.sqlcode THEN
             IF g_bgerr THEN
                CALL s_errmsg("","","p500_c_sfb",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("","","","",SQLCA.sqlcode,"","p500_c_sfb",0)
                EXIT FOREACH
             END IF
          END IF
      IF req_qty IS NULL OR req_qty = ' ' THEN LET req_qty = 0 END IF
      IF al_qty  IS NULL OR al_qty = ' '  THEN LET al_qty = 0  END IF
      IF rpc_qty IS NULL OR rpc_qty = ' ' THEN LET rpc_qty = 0 END IF
      IF pr_qty  IS NULL OR pr_qty = ' '  THEN LET pr_qty = 0  END IF
      IF po_qty  IS NULL OR po_qty = ' '  THEN LET po_qty = 0  END IF
      IF qc_qty  IS NULL OR qc_qty = ' '  THEN LET qc_qty = 0  END IF
      IF wo_qty  IS NULL OR wo_qty = ' '  THEN LET wo_qty = 0  END IF
      LET al_qty = al_qty + rpc_qty 
      IF  al_qty < 0 THEN LET al_qty = 0 END IF   
     #MOD-C80225 -- mark start --
     ##添加转换率
     ##MOD-C70076 add begin---------
     #SELECT ima44 INTO l_ima44 FROM ima_file
     # WHERE ima01 = l_sfa03
     #CALL s_umfchk(l_sfa03,l_sfa12,l_ima44) 
     #     RETURNING l_status,l_factor   
     #LET req_qty = req_qty*l_factor
     ##添加转换率
     ##MOD-C70076 add end---------              
     #MOD-C80225 -- mark end --
      INSERT INTO apm_p470 VALUES(l_sfa03,' ',l_sfa26,g_today,req_qty,al_qty,
                                  pr_qty,po_qty,qc_qty,wo_qty)
          IF SQLCA.sqlcode THEN
             LET g_success = 'N'
             IF g_bgerr THEN
                CALL s_errmsg("sfa03",l_sfa03,"insert",SQLCA.sqlcode,1)
                CONTINUE FOREACH
             ELSE
                CALL cl_err3("ins","apm_p470",l_sfa03,"",SQLCA.sqlcode,"","insert",0)
                EXIT FOREACH
             END IF
          END IF

      #IF g_argv1 = 'G' THEN    #TQC-A70056 mark
#--->產生請購單身檔 
         CALL p500_ins_pml(l_sfa03,l_sfa26,req_qty,qc_qty,
                           po_qty,pr_qty,wo_qty,al_qty)
         IF g_success = 'N' THEN EXIT FOREACH END IF 
      #END IF                   #TQC-A70056 mark
   END FOREACH 
   IF g_totsuccess ='N' THEN
      LET g_success='N'
   END IF

   CALL s_showmsg()
 
  #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
   IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
      IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
         IF g_success = 'Y' THEN
            COMMIT WORK 
         ELSE
            ROLLBACK WORK 
         END IF
      END IF                               #MOD-CA0054 add
   END IF #MOD-B90127
END FUNCTION
 
FUNCTION p500_b()
DEFINE
    l_str           LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(80)
    l_sum           LIKE pml_file.pml20,
    l_ac_t          LIKE type_file.num5,    #No.FUN-680136 SMALLINT #未取消的ARRAY CNT
    l_n,l_k         LIKE type_file.num5,    #No.FUN-680136 SMALLINT #檢查重複用
    l_modify_flag   LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  #單身更改否
    l_lock_sw       LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  #單身鎖住否
    p_cmd           LIKE type_file.chr1,    #No.FUN-680136 VARCHAR(1)  #處理狀態
    l_ima55     LIKE ima_file.ima55,
    l_ima49     LIKE ima_file.ima49,        #MOD-4B0224
    l_ima491    LIKE ima_file.ima491,       #MOD-4B0224
    l_pml33     LIKE pml_file.pml33,        #MOD-4B0224
    l_pml34     LIKE pml_file.pml34,        #MOD-4B0224
    l_factor    LIKE ima_file.ima31_fac,    #No.FUN-680136 DEC(16,8)
    l_flag      LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(01)
    l_pml07     LIKE pml_file.pml07,        #No.FUN-680136 VARCHAR(04)
    l_insert    LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(01) #可新增否
    l_update    LIKE type_file.chr1,        #No.FUN-680136 VARCHAR(01) #可更改否 (含取消)
    l_jump      LIKE type_file.num5         #No.FUN-680136 SMALLINT #判斷是否跳過AFTER ROW的處理
    
    IF s_shut(0) THEN RETURN END IF        
    IF g_pmk.pmk01 IS NULL OR g_pmk.pmk01 = ' '
    THEN RETURN
    END IF
    LET l_insert='Y'
    LET l_update='Y'
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql =
     "  SELECT pml02,pml42,pml04,pml041,'',pml08,0,0,0,0,0, ",      #TQC-C50077 add
     "         0,0,0,0,pml07,pml09,pml20,pml35  ",
     "  FROM pml_file  ",
     "   WHERE pml01= ? ",
     "    AND pml02= ? ",
     "  FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE p500_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
     LET l_ac_t = 0
     INPUT ARRAY g_pml WITHOUT DEFAULTS FROM s_pml.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=FALSE,DELETE ROW=FALSE,
                   APPEND ROW=FALSE)
 
     BEFORE ROW
         LET p_cmd = ''
         LET l_lock_sw = 'N'            #DEFAULT
         LET l_ac = ARR_CURR()
         LET l_n  = ARR_COUNT()
        #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
         IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
            IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
               BEGIN WORK
            END IF #MOD-CA0054 add
         END IF #MOD-B90127
         IF g_rec_b >= l_ac THEN
             LET p_cmd='u'
             LET g_pml_t.* = g_pml[l_ac].*  #BACKUP
             OPEN p500_bcl USING g_pmk.pmk01,g_pml_t.pml02  #表示更改狀態
             IF STATUS THEN
                CALL cl_err("OPEN p500_bcl",STATUS,1)   #No.FUN-660129
                LET l_lock_sw = 'Y'
             ELSE
               FETCH p500_bcl INTO g_pml[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err(g_pml_t.pml02,SQLCA.sqlcode,1)   #No.FUN-660129
                   LET l_lock_sw = "Y"
               END IF
             END IF
            #TQC-C50077 -- add -- begin
             SELECT ima021 INTO g_pml[l_ac].ima021 FROM ima_file
              WHERE ima01 = g_pml[l_ac].pml04
            #TQC-C50077 -- add -- end
             CALL p500_qty(l_ac) #MOD-780156
             CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
     BEFORE DELETE                            #是否取消單身
         IF g_pml_t.pml02 > 0 AND
            g_pml_t.pml02 IS NOT NULL THEN
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             DELETE FROM pml_file
                 WHERE pml01 = g_pmk.pmk01 AND
                       pml02 = g_pml_t.pml02
             IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","pml_file",g_pmk.pmk01,g_pml_t.pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
                 IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
                    IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
                       ROLLBACK WORK
                    END IF #MOD-CA0054 add
                 END IF #MOD-B90127
                 CANCEL DELETE
             END IF
             IF NOT s_industry('std') THEN                                   
                IF NOT s_del_pmli(g_pmk.pmk01,g_pml_t.pml02,'') THEN              
                  #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
                   IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
                      IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
                         ROLLBACK WORK
                      END IF #MOD-CA0054 add
                   END IF #MOD-B90127
                   CANCEL DELETE
                END IF                                                       
             END IF                                                          
         END IF
 
     ON ROW CHANGE
          IF INT_FLAG THEN                 #900423
             CALL cl_err('',9001,0)
             LET INT_FLAG = 0
             LET g_pml[l_ac].* = g_pml_t.*
             EXIT INPUT
          END IF
          IF l_lock_sw = 'Y' THEN
             CALL cl_err(g_pml[l_ac].pml02,-263,1)
             LET g_pml[l_ac].* = g_pml_t.*
          ELSE
            #畫面上已經增加"請購單位"與"換算率"，所以建議數量不須在乘上轉換率
            LET l_ima49 = ''
            LET l_ima491 = ''
            SELECT ima49,ima491 INTO l_ima49,l_ima491 FROM ima_file
              WHERE ima01 = g_pml[l_ac].pml04
             IF NOT cl_null(l_ima491) AND l_ima491 !=0 THEN
                CALL s_wkday3(g_pml[l_ac].pml35,l_ima491) RETURNING l_pml34
             ELSE
                 LET l_pml34 = g_pml[l_ac].pml35
             END IF
             LET l_pml33 = l_pml34 - l_ima49       #交貨日期
             SELECT * INTO t_pml.* FROM pml_file
              WHERE pml01=g_pmk.pmk01 AND pml02=g_pml_t.pml02
             SELECT ima25,ima44,ima906,ima907 
               INTO g_ima25,g_ima44,g_ima906,g_ima907
               FROM ima_file WHERE ima01=t_pml.pml04
             IF SQLCA.sqlcode =100 THEN                                                  
                IF t_pml.pml04 MATCHES 'MISC*' THEN                                
                   SELECT ima25,ima44,ima906,ima907 
                     INTO g_ima25,g_ima44,g_ima906,g_ima907                               
                     FROM ima_file WHERE ima01='MISC'                                    
                END IF                                                                   
             END IF                                                                      
             IF cl_null(g_ima44) THEN LET g_ima44 = g_ima25 END IF
             IF g_ima906 = '3' THEN
                LET g_factor = 1
                CALL s_umfchk(t_pml.pml04,t_pml.pml80,t_pml.pml83)
                     RETURNING g_cnt,g_factor
                IF g_cnt = 1 THEN
                   LET g_factor = 1
                END IF
                LET t_pml.pml85 = g_pml[l_ac].su_qty*g_factor
                LET t_pml.pml85 = s_digqty(t_pml.pml85,t_pml.pml83)   #No.FUN-BB0086--add-
             END IF
            #判斷若使用多單位時，單位一的數量default建議請購量
            #否則單位一數量不default任何值
             IF g_sma.sma115 = 'Y' THEN 
                LET g_pml[l_ac].su_qty = s_digqty(g_pml[l_ac].su_qty,g_pml[l_ac].pml07)   #No.FUN-BB0086
                LET t_pml.pml82 = g_pml[l_ac].su_qty
             ELSE 
                LET t_pml.pml82 = NULL
             END IF
            
             CALL p500_set_pml87(t_pml.pml04,t_pml.pml07,
                               t_pml.pml86,g_pml[l_ac].su_qty)
                               RETURNING t_pml.pml87

             UPDATE pml_file SET pml20 = g_pml[l_ac].su_qty,
                                 pml82 = t_pml.pml82,        #No.TQC-6B0124 modify
                                 pml87 = t_pml.pml87,        #No.TQC-6B0124 modify 
                                 pml85 = t_pml.pml85,        #No.FUN-560084
                                 pml33 = l_pml33,  #MOD-4B0224
                                 pml34 = l_pml34,  #No.MOD-6B0018 add
                                 pml35 = g_pml[l_ac].pml35
                           WHERE CURRENT OF p500_bcl
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","pml_file",g_pmk.pmk01,g_pml_t.pml02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                   LET g_pml[l_ac].* = g_pml_t.*
                ELSE
                   MESSAGE 'UPDATE O.K'
                  #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
                   IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add 
                      IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
                         COMMIT WORK
                      END IF #MOD-CA0054 add
                   END IF
                END IF
          END IF
 
    AFTER ROW
          LET l_ac = ARR_CURR()
          LET l_ac_t = l_ac
          IF INT_FLAG THEN
             CALL cl_err('',9001,0)
             IF p_cmd = 'u' THEN
                LET g_pml_t.* = g_pml[l_ac].*
             END IF
             CLOSE p500_bcl
            #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
             IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
                IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
                   ROLLBACK WORK
                END IF #MOD-CA0054 add
             END IF #MOD-B90127
             EXIT INPUT
          END IF
          CLOSE p500_bcl
         #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
          IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
             IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
                COMMIT WORK
             END IF #MOD-CA0054 mark
          END IF #MOD-B90127
 
 
    AFTER INPUT
      IF INT_FLAG THEN EXIT INPUT END IF
 
     ON KEY(CONTROL-G)
      CALL cl_cmdask()
 
     ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
     ON KEY(CONTROL-F)
       CASE
          WHEN INFIELD(pml02) CALL cl_fldhlp('pml02')
          WHEN INFIELD(pml04) CALL cl_fldhlp('pml04')
          OTHERWISE          CALL cl_fldhlp('    ')
       END CASE
   END INPUT
 
  CLOSE p500_bcl
 #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
  IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
     IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
        COMMIT WORK
     END IF #MOD-CA0054 mark
  END IF #MOD-B90127
END FUNCTION
  
FUNCTION p500_qty(l_i) #MOD-780156
#   DEFINE l_ima262  LIKE ima_file.ima262, #FUN-A20044
   DEFINE l_avl_stk  LIKE type_file.num15_3, #FUN-A20044
          l_avl_stk_mpsmrp   LIKE type_file.num15_3, #FUN-A20044 
          l_unavl_stk        LIKE type_file.num15_3, #FUN-A20044
          l_ima27   LIKE ima_file.ima27,
          l_req_qty LIKE pml_file.pml20,
          l_al_qty  LIKE pml_file.pml20,
          l_pr_qty  LIKE pml_file.pml20,
          l_po_qty  LIKE pml_file.pml20,
          l_qc_qty  LIKE pml_file.pml20,
          l_wo_qty  LIKE pml_file.pml20,
          l_supply  LIKE pml_file.pml20,
          l_demand  LIKE pml_file.pml20,
          l_i       LIKE type_file.num5 #MOD-780156
  
#   SELECT ima262,ima27 INTO l_ima262,l_ima27 FROM ima_file #FUN-A20044
   SELECT ima27 INTO l_ima27 FROM ima_file #FUN-A20044
    WHERE ima01 = g_pml[l_i].pml04
    CALL s_getstock(g_pml[l_i].pml04,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 
#   IF l_ima262 IS NULL OR l_ima262 = ' ' THEN #FUN-A20044
#      LET l_ima262 = 0  #FUN-A20044
#   END IF #FUN-A20044
    IF l_avl_stk IS NULL OR l_avl_stk  = ' ' THEN #FUN-A20044
       LET l_avl_stk = 0  #FUN-A20044
    END IF #FUN-A20044
   IF l_ima27 IS NULL OR l_ima27 = ' ' THEN
      LET l_ima27 = 0
   END IF
 
#   LET g_pml[l_i].ima262 = l_ima262 #FUN-A20044
   LET g_pml[l_i].avl_stk = l_avl_stk #FUN-A20044
   LET g_pml[l_i].ima27 = l_ima27
 
   SELECT req_qty,al_qty,pr_qty,po_qty,qc_qty,wo_qty
     INTO l_req_qty,l_al_qty,l_pr_qty,l_po_qty,l_qc_qty,l_wo_qty
     FROM apm_p470
    WHERE part = g_pml[l_i].pml04
 
   IF l_req_qty IS NULL OR l_req_qty = ' ' THEN LET l_req_qty = 0 END IF
   IF l_al_qty  IS NULL OR l_al_qty = ' '  THEN LET l_al_qty = 0 END IF
   IF l_pr_qty  IS NULL OR l_pr_qty = ' '  THEN LET l_pr_qty = 0 END IF
   IF l_po_qty  IS NULL OR l_po_qty = ' '  THEN LET l_po_qty = 0 END IF
   IF l_qc_qty  IS NULL OR l_qc_qty = ' '  THEN LET l_qc_qty = 0 END IF
   IF l_wo_qty  IS NULL OR l_wo_qty = ' '  THEN LET l_wo_qty = 0 END IF
   LET g_pml[l_i].req_qty= l_req_qty
   LET g_pml[l_i].al_qty= l_al_qty
   LET g_pml[l_i].pr_qty= l_pr_qty
   LET g_pml[l_i].po_qty= l_po_qty
   LET g_pml[l_i].qc_qty= l_qc_qty
   LET g_pml[l_i].wo_qty= l_wo_qty
   #-->不包含現有庫存
#   IF tm.a = 'N' THEN LET g_pml[l_i].ima262 = 0 END IF #FUN-A20044
   IF tm.a = 'N' THEN LET g_pml[l_i].avl_stk = 0 END IF #FUN-A20044
   #-->不包含請購量
   IF tm.b = 'N' THEN LET g_pml[l_i].qc_qty = 0 END IF
   #-->不包含採購量
   IF tm.c = 'N' THEN LET g_pml[l_i].pr_qty = 0 END IF
   #-->不包含檢驗量
   IF tm.d = 'N' THEN LET g_pml[l_i].po_qty = 0 END IF
   #-->不包含工單量
   IF tm.e = 'N' THEN LET g_pml[l_i].wo_qty = 0 END IF
   #-->不包含已備料
   IF tm.f = 'N' THEN LET g_pml[l_i].al_qty = 0 END IF
   #-->缺料量 = 本次需求- [ 庫存可用- 已備料量+ QC + PO + PR + WO]
#   LET l_supply= g_pml[l_i].ima262 + g_pml[l_i].qc_qty + #FUN-A20044
   LET l_supply= g_pml[l_i].avl_stk + g_pml[l_i].qc_qty + #FUN-A20044
                 g_pml[l_i].po_qty + g_pml[l_i].pr_qty +
                 g_pml[l_i].wo_qty
 
   #BugNo:4711     結餘量 = 供給     -  需求 #(若供給>需求應顯示正數,反之則負數)
   LET g_pml[l_i].sh_qty = l_supply - (g_pml[l_i].req_qty + g_pml[l_i].al_qty)
 
END FUNCTION

FUNCTION p500_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2     LIKE type_file.chr1000, #No.FUN-680136 VARCHAR(200)
       l_supply  LIKE pml_file.pml20,
       l_demand  LIKE pml_file.pml20
DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044 
    LET g_sql =
        "SELECT pml02,pml42,pml04,pml041,ima021,pml08,",      #TQC-C50077 add ima021
#        " req_qty,ima27,al_qty,ima262,qc_qty,po_qty, ", #FUN-A20044
        " req_qty,ima27,al_qty,0,qc_qty,po_qty, ", #FUN-A20044
        " pr_qty,wo_qty,0,pml07,pml09,pml20,pml35 ",
        " FROM  pml_file LEFT OUTER JOIN ima_file ON ima01=pml04 LEFT OUTER JOIN apm_p470 ON pml04=part",
        " WHERE pml01 = '",g_pmk.pmk01,"'",  #MOD-CA0158 add ,
        "   AND pml02 > ",g_pml02            #MOD-CA0158 add

    display g_sql
 
    PREPARE p500_pb FROM g_sql
    display 'status = ',sqlca.sqlcode
    display 'sqlca.sqlcode = ',sqlca.sqlcode
    DECLARE pml_curs  CURSOR FOR p500_pb
    CALL g_pml.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH pml_curs INTO g_pml[g_cnt].*   #單身 ARRAY 填充
    CALL s_getstock(g_pml[g_cnt].pml04,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        #-->不包含現有庫存
#        IF tm.a = 'N' THEN LET g_pml[g_cnt].ima262 = 0 END IF  #FUN-A20044
        IF tm.a = 'N' THEN LET g_pml[g_cnt].avl_stk = 0 END IF  #FUN-A20044
        #-->不包含檢驗量
        IF tm.b = 'N' THEN LET g_pml[g_cnt].qc_qty = 0 END IF
        #-->不包含請購量
        IF tm.c = 'N' THEN LET g_pml[g_cnt].pr_qty = 0 END IF
        #-->不包含採購量
        IF tm.d = 'N' THEN LET g_pml[g_cnt].po_qty = 0 END IF
        #-->不包含工單量
        IF tm.e = 'N' THEN LET g_pml[g_cnt].wo_qty = 0 END IF
        #-->不包含已分配
        IF tm.f = 'N' THEN LET g_pml[g_cnt].al_qty = 0 END IF
        #-->不包含安全庫存
        IF tm.g = 'N' THEN LET g_pml[g_cnt].ima27  = 0 END IF
        #-->缺料量 = 本次需求 + 已備料量 - [ 庫存可用 + QC + PO + PR + WO]
#        LET l_supply= g_pml[g_cnt].ima262 + g_pml[g_cnt].qc_qty + #FUN-A20044
        LET l_supply= g_pml[g_cnt].avl_stk + g_pml[g_cnt].qc_qty + #FUN-A20044
                      g_pml[g_cnt].po_qty + g_pml[g_cnt].pr_qty +
                      g_pml[g_cnt].wo_qty
        LET l_demand= g_pml[g_cnt].req_qty + g_pml[g_cnt].al_qty
       #BugNo:4711       結餘量 = 供給     - 需求 #(若供給>需求應顯示正數,反之則負數)
        LET g_pml[g_cnt].sh_qty = l_supply - l_demand
 
        CALL p500_qty(g_cnt) #MOD-780156
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
        END IF
    END FOREACH
    CALL g_pml.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    display 'g_rec_b=',g_rec_b
END FUNCTION
  
FUNCTION p500_bp(p_ud)
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
 
FUNCTION p500_pmlini()
   SELECT pmk02,pmk25,pmk45,pmk13 INTO g_pmk.pmk02,g_pmk.pmk25,g_pmk.pmk45 ,g_pmk.pmk13 
     FROM pmk_file WHERE pmk01 = g_pmk.pmk01 
   LET g_pml2.pml01 = g_pmk.pmk01 
   LET g_pml2.pml011 =g_pmk.pmk02 
   LET g_pml2.pml12 = g_pmk.pmk05	
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
   LET g_pml2.pml18 = ' '
END FUNCTION
 
FUNCTION p500_ins_pml(p_sfa03,p_sfa26,p_req_qty,p_qc_qty,p_po_qty,
                      p_pr_qty,p_wo_qty,p_al_qty)  
  DEFINE p_sfa03     LIKE sfa_file.sfa03,
         p_sfa26     LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(01)
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
#         l_ima262    LIKE ima_file.ima262, #FUN-A20044
         l_avl_stk_mpsmrp LIKE type_file.num15_3, #FUN-A20044
         l_unavl_stk      LIKE type_file.num15_3, #FUN-A20044
         l_avl_stk    LIKE type_file.num15_3, #FUN-A20044
         l_ima44     LIKE ima_file.ima44,
         l_ima44_fac LIKE ima_file.ima44_fac,
         l_ima45     LIKE ima_file.ima45,
         l_ima46     LIKE ima_file.ima46,
         l_ima49     LIKE ima_file.ima49,
         l_ima491    LIKE ima_file.ima491,
         l_ima55     LIKE ima_file.ima55,
         l_factor    LIKE ima_file.ima31_fac,  #No.FUN-680136 DEC(16,8)
         l_flag      LIKE type_file.chr1,      #No.FUN-680136 VARCHAR(01)
         l_supply    LIKE pml_file.pml20,
         l_demand    LIKE pml_file.pml20,
         l_pan       LIKE type_file.num10,     #No.FUN-680136 INTEGER
         l_double    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE  l_cnt        LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE  l_ima906     LIKE ima_file.ima906
DEFINE  l_ima907     LIKE ima_file.ima907
DEFINE  l_ima908     LIKE ima_file.ima908    #No.TQC-6B0124 add
DEFINE  l_ima63      LIKE ima_file.ima63     #MOD-B50130 
 
#   SELECT ima01,ima02,ima05,ima25,ima262,ima27,ima44,ima44_fac, #FUN-A20044
   SELECT ima01,ima02,ima05,ima25,0,ima27,ima44,ima44_fac, #FUN-A20044
          ima45,ima46,ima49,ima491,ima25,ima908   #No.MOD-6B0157 modify
     INTO l_ima01,l_ima02,l_ima05,l_ima25,l_avl_stk,l_ima27,  #No.TQC-6B0124 add ima908
          l_ima44,l_ima44_fac,l_ima45,l_ima46,
          l_ima49,l_ima491,l_ima25,l_ima908    #No.MOD-6B0157 modify
     FROM ima_file
    WHERE ima01 = p_sfa03
    CALL s_getstock(p_sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044 
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ima_file",p_sfa03,"",SQLCA.sqlcode,"","sel ima",1)  #No.FUN-660129
      LET g_success = 'N'
      RETURN
   END IF
 
   LET g_pml2.pml02 = g_seq
   LET g_pml2.pml04 = l_ima01
   LET g_pml2.pml041= l_ima02
   LET g_pml2.pml05 = NULL  #no.4649
   LET g_pml2.pml07 = l_ima44
   LET g_pml2.pml08 = l_ima25
   CALL s_umfchk(g_pml2.pml04,g_pml2.pml07,l_ima25) RETURNING l_cnt,g_pml2.pml09
   IF l_cnt = 1 THEN LET g_pml2.pml09=1 END IF
   LET g_pml2.pml42 = p_sfa26
   IF g_pml2.pml42  = '2' THEN LET g_pml2.pml42 = '1' END IF
   IF g_pml2.pml42  = 'S' THEN LET g_pml2.pml42 = '0' END IF
   IF g_pml2.pml42  = 'U' THEN LET g_pml2.pml42 = '0' END IF
   #-->不包含現有庫存
#   IF tm.a = 'N' THEN LET l_ima262 = 0 END IF #FUN-A20044
   IF tm.a = 'N' THEN LET l_avl_stk = 0 END IF #FUN-A20044
   #-->不包含檢驗量
   IF tm.b = 'N' THEN LET p_qc_qty = 0 END IF
   #-->不包含請購量
   IF tm.c = 'N' THEN LET p_pr_qty = 0 END IF
   #-->不包含採購量
   IF tm.d = 'N' THEN LET p_po_qty = 0 END IF
   #-->不包含工單量
   IF tm.e = 'N' THEN LET p_wo_qty = 0 END IF
   #-->不包含已備料
   IF tm.f = 'N' THEN LET p_al_qty = 0 END IF
   #-->缺料量 = 本次需求 + 已備料量 - [ 庫存可用 + QC + PO + PR + WO]
   LET sh_qty = p_req_qty + p_al_qty -
#                (l_ima262 + p_qc_qty + p_po_qty + p_pr_qty + p_wo_qty ) #FUN-A20044
                (l_avl_stk + p_qc_qty + p_po_qty + p_pr_qty + p_wo_qty ) #FUN-A20044
 
   #-->缺料量如大於本次需求則以本次需求為主
   IF sh_qty > p_req_qty THEN
      LET su_qty = p_req_qty
   ELSE 
      LET su_qty = sh_qty
   END IF
 
   #-->建議量 = 缺料量 + 安全庫存量
   IF tm.g = 'Y' AND su_qty > 0 THEN 
      LET su_qty = su_qty  +  l_ima27
   END IF
 
   #MOD-C80212 mark start ------
   ##-->考慮最少採購量/倍量
   #IF su_qty > 0 THEN
   #   IF su_qty < l_ima46 THEN
   #      LET g_pml2.pml20 = l_ima46
   #   ELSE
   #      IF l_ima45 > 0 THEN
   #         LET l_pan = (su_qty*1000) MOD (l_ima45 *1000)
   #         IF l_pan !=0
   #         THEN LET l_double = (su_qty/l_ima45) + 1
   #         ELSE LET l_double = su_qty/l_ima45
   #         END IF
   #         LET g_pml2.pml20  = l_double * l_ima45
   #      ELSE
   #         LET g_pml2.pml20 = su_qty
   #      END IF
   #   END IF
   #ELSE
   #   LET g_pml2.pml20 = 0
   #END IF
   #MOD-C80212 mark end   ------

   #MOD-C80212 add start -----
   IF su_qty > 0 THEN
      LET g_pml2.pml20 = su_qty
   ELSE
      LET g_pml2.pml20 = 0
   END IF
   #MOD-C80212 add end   -----
 
#MOD-B50130 --begin--
#  CALL s_umfchk(g_pml2.pml04,l_ima25,g_pml2.pml07) RETURNING l_flag,l_factor    
   SELECT ima63 INTO l_ima63 FROM ima_file WHERE ima01 = g_pml2.pml04
   CALL s_umfchk(g_pml2.pml04,l_ima63,g_pml2.pml07) RETURNING l_flag,l_factor    
#MOD-B50130 --end--
   IF l_flag THEN
      CALL cl_err(g_pml2.pml07,'mfg1206',0)
   ELSE
      LET g_pml2.pml20=g_pml2.pml20*l_factor
   END IF

#MOD-B50130 --begin--
        IF cl_null(l_ima45) THEN LET l_ima45 = 0 END IF
        IF cl_null(l_ima46) THEN LET l_ima46 = 0 END IF
           #-->考慮最少採購量/倍量
         IF g_pml2.pml20 > 0 THEN
            IF g_pml2.pml20 > l_ima46 THEN
               IF l_ima45 > 0 THEN
                  IF ((g_pml2.pml20*1000) MOD (l_ima45*1000)) != 0 THEN 
                     LET l_double = (g_pml2.pml20/l_ima45) + 1
                     LET g_pml2.pml20=l_double*l_ima45
                  END IF
               END IF
             ELSE 
                 LET g_pml2.pml20=l_ima46
            END IF
           ELSE
              LET g_pml2.pml20=0
           END IF
#MOD-B50130 --end-- 

   LET g_pml2.pml35 = tm.bdate 
   CALL s_aday(g_pml2.pml35,-1,l_ima491) RETURNING g_pml2.pml34
   CALL s_aday(g_pml2.pml34,-1,l_ima49) RETURNING g_pml2.pml33
 
   IF g_sma.sma115 = 'Y' THEN
      SELECT ima44,ima906,ima907 INTO l_ima44,l_ima906,l_ima907
        FROM ima_file 
       WHERE ima01 = g_pml2.pml04
      LET g_pml2.pml80 = g_pml2.pml07
      LET l_factor = 1
      CALL s_umfchk(g_pml2.pml04,g_pml2.pml80,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET g_pml2.pml81=l_factor
      LET g_pml2.pml82=g_pml2.pml20
      LET g_pml2.pml83=l_ima907
      LET l_factor = 1
      CALL s_umfchk(g_pml2.pml04,g_pml2.pml83,l_ima44)
           RETURNING l_cnt,l_factor
      IF l_cnt = 1 THEN
         LET l_factor = 1
      END IF
      LET g_pml2.pml84=l_factor
      LET g_pml2.pml85=0
      IF l_ima906 = '3' THEN
         LET g_pml2.pml84=l_factor
         LET l_factor = 1
         CALL s_umfchk(g_pml2.pml04,g_pml2.pml80,g_pml2.pml83)
              RETURNING l_cnt,l_factor
         IF l_cnt = 1 THEN
            LET l_factor = 1
         END IF
         LET g_pml2.pml85=g_pml2.pml82*l_factor
      END IF
   END IF
   IF cl_null(l_ima908) THEN LET l_ima908 = g_pml2.pml07 END IF
 
   IF g_sma.sma116 NOT MATCHES '[13]' THEN
      LET g_pml2.pml86 = g_pml2.pml07
   ELSE
      LET g_pml2.pml86 = l_ima908
   END IF
   CALL p500_set_pml87(g_pml2.pml04,g_pml2.pml07,
                       g_pml2.pml86,g_pml2.pml20) RETURNING g_pml2.pml87
   #預設統購否pml190
   IF cl_null(g_pml2.pml190) THEN
        SELECT ima913,ima914 INTO g_pml2.pml190,g_pml2.pml191    #NO.CHI-6A0016
         FROM ima_file
        WHERE ima01 = g_pml2.pml04
       IF STATUS = 100 THEN
          #LET g_pml2.pml04 = 'N'  #TQC-6A0011
           LET g_pml2.pml190 = 'N' #TQC-6A0011
       END IF
   END IF
   LET g_pml2.pml930=s_costcenter(g_pmk.pmk13)
   LET g_pml2.pml192 = 'N'         #NO.CHI-6A0016  #拋轉否
   INITIALIZE g_pml2.pml25 TO NULL  #No.MOD-870161
   LET g_pml2.pmlplant = g_plant #FUN-980006 add
   LET g_pml2.pmllegal = g_legal #FUN-980006 add
   IF cl_null(g_pml2.pml91) THEN LET g_pml2.pml91 = 'N' END IF   #TQC-980136  #TQC-AB0397 add 'N'
   LET g_pml2.pml49 = '1' #No.FUN-870007
   LET g_pml2.pml50 = '1' #No.FUN-870007
   LET g_pml2.pml54 = '2' #No.FUN-870007
   LET g_pml2.pml56 = '1' #No.FUN-870007
   LET g_pml2.pml92 = 'N' #FUN-9B0023
   INSERT INTO pml_file VALUES(g_pml2.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","pml_file",g_pml2.pml01,"",SQLCA.sqlcode,"","ins pml2",1)  #No.FUN-660129
      LET g_success = 'N'
   END IF
 
   LET g_seq = g_seq + 1
 
END FUNCTION

FUNCTION p500_set_pml87(p_pml04,p_pml07,p_pml86,p_pml20)
   DEFINE   l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE img_file.img21
   DEFINE   p_pml04  LIKE pml_file.pml04,
            p_pml07  LIKE pml_file.pml07,
            p_pml86  LIKE pml_file.pml86,
            p_pml20  LIKE pml_file.pml20 
 
    SELECT ima25,ima44 INTO l_ima25,l_ima44
      FROM ima_file WHERE ima01=p_pml04
    IF SQLCA.sqlcode =100 THEN
       IF p_pml04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44 INTO l_ima25,l_ima44
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac1=1
    LET l_qty1=p_pml20
    CALL s_umfchk(p_pml04,p_pml07,l_ima44)
          RETURNING g_cnt,l_fac1
    IF g_cnt = 1 THEN
       LET l_fac1 = 1
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
 
    LET l_tot=l_qty1*l_fac1
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
 
    LET l_factor = 1
    CALL s_umfchk(p_pml04,l_ima44,p_pml86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
    LET l_tot = s_digqty(l_tot,p_pml86)   #No.FUN-BB0086
 
    RETURN l_tot
END FUNCTION
 
FUNCTION p500_inssfamm()
   DEFINE l_oeb01      LIKE oeb_file.oeb01,
          l_oeb03      LIKE oeb_file.oeb03, 
          l_oeb04      LIKE oeb_file.oeb04,
          l_oebislk01  LIKE oebi_file.oebislk01,
          l_oeb12      LIKE oeb_file.oeb12           
 
    DELETE FROM sfamm_file_temp
        
    #LET g_sql = " SELECT oeb01,oeb03,oeb04,oeb12*oeb05_fac,oeb22,",     #mark by sx210508
	LET g_sql = " SELECT DISTINCT oeb01,oeb03,oeb04,sfb08*oeb05_fac,oeb22,", #add by sx210508
                "        oea09 FROM oeb_file,oea_file,sfb_file",
                "  WHERE oea01 = oeb01 and oeb01=sfb22 and oeb03=sfb221 ",
                "   and ",g_wc2
    PREPARE g_pre2 FROM g_sql
    DECLARE g_cur2 CURSOR FOR g_pre2
    FOREACH g_cur2 INTO l_oeb01,l_oeb03,l_oeb04,l_oeb12,
                        l_oeb22,g_oea09
       IF SQLCA.sqlcode THEN
          CALL cl_err('prepare2:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF        
            
       CALL s_ycralc6(g_pmk.pmk01,l_oeb04,g_sma.sma29,l_oeb12,'Y',
                      g_sma.sma71)
   END FOREACH
END FUNCTION
 
FUNCTION s_ycralc6(p_wo,p_part,p_btflg,p_woq,p_mps,p_yld)
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
      let ls_err = p_part,'not exist this item no.'
      CALL cl_err(ls_err,'abm-202',1)
      RETURN
   END IF
   IF l_ima562 IS NULL THEN LET l_ima562=0 END IF
   IF cl_null(l_ima910) THEN LET l_ima910 = ' ' END IF    #TQC-8C0063
 
   CALL p500_cralc_bom(0,p_part,l_ima910,p_woq,1)   #TQC-8C0063 add l_ima910,cralc_bom-->p500_cralc_bom
 
   IF g_ccc=0 THEN
      LET g_errno='asf-014'
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION p500_cralc_bom(p_level,p_key,p_key3,p_total,p_QPA) #TQC-8C0063 add p_key3,cralc_bom-->p500_cralc_bom
#No.FUN-A70034  --Begin
   DEFINE l_total_1    LIKE sfa_file.sfa05     #总用量
   DEFINE l_QPA_1      LIKE bmb_file.bmb06
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
     sr DYNAMIC ARRAY  OF RECORD
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
        bmb081 LIKE bmb_file.bmb081,
        bmb082 LIKE bmb_file.bmb082
        #No.FUN-A70034  --End  
                    END RECORD,
     l_ima02        LIKE ima_file.ima02,
     l_ima08        LIKE ima_file.ima08,
#     l_ima26        LIKE ima_file.ima26, #FUN-A20044
     l_avl_stk_mpsmrp        LIKE type_file.num15_3, #FUN-A20044
     l_unavl_stk     LIKE type_file.num15_3, #FUN-A20044
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
     l_bal          LIKE  type_file.num15_3, #FUN-A20044
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
  LET arrno = 500
      LET l_cmd=
          "SELECT bmb02,bmb03,bmb10,bmb10_fac,bmb10_fac2,",
          "       bmb15,bmb16,bmb06,bmb08,bmb09,bmb18,bmb19,bmb28,",
          "       ima08,ima37,ima25,ima55,",
          "       ima86,ima86_fac,bmb07,'',",
          "       bmb081,bmb082 ",              #No.FUN-A70034
          #"  FROM bmb_file,ima_file",          #MOD-C80149 mark
          "  FROM bmb_file,ima_file,bma_file",  #MOD-C80149 add
          " WHERE bmb01='", p_key,"' ",
          "   AND bmb03 = ima01",
          "   AND bmb01 = bma01",               #MOD-C80149 add
          "   AND bmaacti = 'Y'",               #MOD-C80149 add
          "   AND bmb29 = '", p_key3,"' ",   #No.FUN-870124 #TQC-8C0063
          "   AND (bmb04 <='",g_today,
          "'   OR bmb04 IS NULL) AND (bmb05 >'",g_today,
          "'   OR bmb05 IS NULL)",
          " ORDER BY 1"
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
              sr[l_i].bmb06/sr[l_i].bmb07,0)
              RETURNING l_total_1,l_QPA,l_ActualQPA
         LET l_total=l_total_1
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
          CALL s_umfchk(sr[l_i].bmb03,sr[l_i].bmb10,
                        sr[l_i].ima55) RETURNING g_status,g_factor
          #No.FUN-A70034  --Begin
          #LET sr[l_i].bmb06 = sr[l_i].bmb06*g_factor/sr[l_i].bmb07
          #LET l_ActualQPA = (sr[l_i].bmb06+sr[l_i].bmb08/100)*p_QPA
          #CALL p500_cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],p_total*sr[l_i].bmb06, #TQC-8C0063
          #               l_ActualQPA)

          LET l_total_1 = l_total_1*g_factor
          LET l_QPA_1   = l_ActualQPA * g_factor
          CALL p500_cralc_bom(p_level,sr[l_i].bmb03,l_ima910[l_i],l_total_1,l_QPA_1)
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
        LET g_sfa.sfa91 = ''
        LET g_sfa.sfa100 =sr[l_i].bmb28
        IF cl_null(g_sfa.sfa100) THEN LET g_sfa.sfa100 = 0 END IF
        LET g_sfa.sfa161=g_sfa.sfa05/p_woq
        LET g_sfa.sfaplant = g_plant           #TQC-A70056 add
        LET g_sfa.sfalegal = g_legal           #TQC-A70056 add
        LET g_sfa.sfa012 = ' '              #TQC-A70056 add
        LET g_sfa.sfa013 = 0                #TQC-A70056 add
        LET l_count = 0
        LET g_sfa.sfaplant = g_plant   #FUN-A90063
        LET g_sfa.sfalegal = g_legal   #FUN-A90063

        SELECT COUNT(*) INTO l_count FROM sfamm_file_temp
         WHERE sfa01 = g_sfa.sfa01 AND sfa03 = g_sfa.sfa03
          #AND sfa08 = g_sfa.sfa08 AND sfa12 = g_sfa.sfa12  #MOD-CA0216 mark
           AND sfa12 = g_sfa.sfa12                          #MOD-CA0216 add
           AND sfa27 = g_sfa.sfa27
        IF l_count <= 0 THEN
          INSERT INTO sfamm_file_temp VALUES(g_sfa.*)
               IF SQLCA.SQLCODE THEN    #Duplicate
#                 IF SQLCA.SQLCODE=-239 THEN #CHI-C30115 mark
                  IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
                     SELECT sfa13 INTO l_sfa13
                       FROM sfamm_file_temp
                      WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                       #AND sfa08=g_opseq AND sfa91 = g_sfa.sfa91  #MOD-CA0216 mark
                        AND sfa91 = g_sfa.sfa91                    #MOD-CA0216 add
                     LET l_sfa13=sr[l_i].bmb10_fac/l_sfa13
                     LET l_total=l_total*l_sfa13
                     LET l_total2=l_total2*l_sfa13
                     UPDATE sfamm_file_temp SET sfa04=sfa04+l_total,
                                                sfa05=sfa05+l_total2,
                                                sfa16=sfa16+l_QPA,
                                                sfa161=g_sfa.sfa161
                                               ,sfa08=' ' #MOD-CA0216 add
                      WHERE sfa01=g_wo AND sfa03=sr[l_i].bmb03
                       #AND sfa08=g_opseq   #MOD-CA0216 mark
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
                                    ,sfa08 = ' '              #MOD-CA0216 add
           WHERE sfa01 = g_sfa.sfa01 AND sfa03 = g_sfa.sfa03
            #AND sfa08 = g_sfa.sfa08 AND sfa12 = g_sfa.sfa12  #MOD-CA0216 mark
             AND sfa12 = g_sfa.sfa12 #MOD-CA0216 add
             AND sfa27 = g_sfa.sfa27
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
  
  #MOD-C70202----mark----s----
  #DECLARE cr_cr2 CURSOR FOR
  #SELECT sfamm_file_temp.*,
# #        ima08,ima262,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
  #       ima08,0,ima27,ima37,ima108,ima64,ima641,ima25 #FUN-A20044
  #  FROM sfamm_file_temp LEFT OUTER JOIN ima_file ON ima01=sfa03
  # WHERE sfa01=g_wo 
# #  FOREACH cr_cr2 INTO g_sfa.*,l_ima08,l_ima262, #FUN-A20044
  # FOREACH cr_cr2 INTO g_sfa.*,l_ima08,l_avl_stk, #FUN-A20044
  #                    l_SafetyStock,l_ima37,l_ima108,l_ima64,l_ima641,l_uom
  # CALL s_getstock(g_sfa.sfa03,g_plant)RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk  #FUN-A20044
  # IF SQLCA.sqlcode THEN EXIT FOREACH END IF
  # LET g_opseq=g_sfa.sfa08
  # IF g_sfa.sfa26 MATCHES '[SUT]' THEN CONTINUE FOREACH END IF 
  # IF l_ima08 = 'D' THEN CONTINUE FOREACH END IF 
  # MESSAGE '--> ',g_sfa.sfa03,g_sfa.sfa08
  # LET l_sfa03 = g_sfa.sfa03
  # 
  # #Inflate With Minimum Issue Qty And Issue Pansize
  # IF l_ima641 != 0 AND g_sfa.sfa05 < l_ima641 THEN
  #   LET g_sfa.sfa05=l_ima641
  # END IF
  # IF l_ima64!=0 THEN
  #   LET l_double=(g_sfa.sfa05/l_ima64)+ 0.999999
  #   LET g_sfa.sfa05=l_double*l_ima64
  # END IF
  # 
  # SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_sfa.sfa12
  # IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
  # CALL cl_digcut(g_sfa.sfa05,l_gfe03) RETURNING l_sfaqty
  # LET g_sfa.sfa05 =  l_sfaqty
  # 
# #  IF cl_null(l_ima262) THEN LET l_ima262=0 END IF #FUN-A20044
  # IF cl_null(l_avl_stk) THEN LET l_avl_stk=0 END IF #FUN-A20044
# #  LET l_ima26=l_ima262 #FUN-A20044
  # LET l_avl_stk_mpsmrp=l_avl_stk #FUN-A20044
# #  IF l_ima26<0 THEN LET l_ima26=0 END IF #FUN-A20044
  # IF l_avl_stk_mpsmrp<0 THEN LET l_avl_stk_mpsmrp=0 END IF #FUN-A20044
  #END FOREACH
  #MOD-C70202----mark----e----   
END FUNCTION

FUNCTION p500_deb()
   DEFINE l_pml20     LIKE pml_file.pml20,
          l_pml_file  RECORD LIKE pml_file.*
   DEFINE r,i,j       LIKE type_file.num10
   DEFINE l_i         LIKE type_file.num5
   DEFINE l_pml02     DYNAMIC ARRAY OF LIKE pml_file.pml02 #No.FUN-870124
   DEFINE l_i1        LIKE type_file.num5    #No.FUN-870124
 
  #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
   IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add 
      IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
         BEGIN WORK
      END IF #MOD-CA0054 add
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      DELETE FROM pml_file WHERE pml01 = g_pmk.pmk01
      IF STATUS THEN
         CALL cl_err('delete',STATUS,1)
         LET g_success = 'N'                                                                                                             
      END IF
      LET l_i = 0
      SELECT count(*) INTO l_i FROM pml_file_temp WHERE pml01 = g_pmk.pmk01
      IF l_i > 0 THEN
        INSERT INTO pml_file SELECT * FROM pml_file_temp WHERE pml01 = g_pmk.pmk01
        IF STATUS THEN
           CALL cl_err('insert',STATUS,1)
           LET g_success = 'N'
        END IF
      END IF
   ELSE
      DELETE FROM pml_file WHERE pml01 = g_pmk.pmk01 AND pml20 = 0
      IF STATUS THEN
         CALL cl_err('delete',STATUS,1)
         LET g_success = 'N'
      END IF
   END IF
 
  #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark 
   IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add 
      IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
         IF SQLCA.SQLCODE OR g_success = 'N' THEN
            ROLLBACK WORK
         ELSE
            COMMIT WORK
         END IF
      END IF #MOD-CA0054 add
   END IF #MOD-B90127
 
   DECLARE p500_b_c CURSOR FOR 
   SELECT pml02 FROM pml_file 
    WHERE pml01 = g_pmk.pmk01
    ORDER BY pml02
 
  #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark 
   IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
      IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
         BEGIN WORK
      END IF #MOD-CA0054 add
   END IF #MOD-B90127
   LET g_success = 'Y'
   LET i = 0
 
   FOREACH p500_b_c INTO j
      IF STATUS THEN
         CALL cl_err('foreach',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      LET i = i + 1
      UPDATE pml_file SET pml02 = i
       WHERE pml01 = g_pmk.pmk01 AND pml02 = j
      IF STATUS THEN
         CALL cl_err('upd pml02',STATUS,1) 
         LET g_success = 'N'
         EXIT FOREACH
      END IF
   END FOREACH
    IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF
 
   CALL s_showmsg()       #No.FUN-710030

   IF g_success = 'Y' THEN
     #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
      IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
         IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
            COMMIT WORK 
         END IF #MOD-CA0054
      END IF  #MOD-B90127
   ELSE
     #IF g_prog != 'axmt410' THEN #MOD-B90127 #MOD-CA0054 mark
      IF g_prog[1,7] != 'axmt410' THEN        #MOD-CA0054 add
         IF g_prog[1,7] != 'axmt810' THEN     #MOD-CA0054 add
            ROLLBACK WORK
         END IF #MOD-CA0054
      END IF #MOD-B90127 
      RETURN
   END IF
#   CALL cl_set_act_visible("insert,delete",TRUE)
END FUNCTION
#FUN-A20039 --add --end


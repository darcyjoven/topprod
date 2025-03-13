# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: axcp191.4gl
# Descriptions...: 成本分錄底稿產生
# Date & Author..: 05/02/02 By Carol
# Modify.........: No.FUN-510041 05/02/18 By Carol 新增成本拋轉傳票功能
# Modify.........: No.FUN-530038 05/03/24 By Carol axcp191產生分錄底稿時,
#                                                  在取雜項異動時理由對應科目時,分錄的部門請以上述的部門為主而非原先的雜項異動部門
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-590106 05/09/27 By Sarah 替換inb902-->inb908,inb903-->inb909
# Modify.........: No.MOD-610047 06/01/11 By Claire OTHERWISE 取消
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次背景執行
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680086 06/08/25 By Ray 多帳套修改
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換 
# Modify.........: No.FUN-660073 06/09/20 By Nicola 訂單樣品處理
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.MOD-710146 07/01/25 By Smapmin 分錄底稿的異動日期應為畫面輸入年月的最後一天
# Modify.........: No.FUN-730057 07/04/02 By bnlent 會計科目加帳套
# Modify.........: No.MOD-710128 07/04/09 By pengu 應該包含 aimt303,amt313 的費用
# Modify.........: No.TQC-770001 07/07/02 By sherry 點擊"幫助"按鈕無效
# Modify.........: No.MOD-780265 07/09/19 By Pengu 製程轉委外時因無tlf,所以算不到製程中委外的金額
# Modify.........: No.MOD-830218 08/04/19 By Pengu 如果金額=0不要產生分錄，否則拋到總帳回不來
# Modify.........: No.MOD-870078 08/07/17 By Sarah 1.將g_bookno給值的程式段,搬到p191()段前面
#                                                  2.調整借貸不平衡的尾差
# Modify.........: No.MOD-890126 08/09/18 By Pengu  加工費轉在製若為暫估時未排除沖暫估資料
# Modify.........: No.TQC-8C0076 09/01/09 By clover mark #ATTRIBUTE(YELLOW)
# Modify.........: No.MOD-920121 09/02/16 By Pengu 產生成本分錄時,如果盤虧的時候,會無法根據ccz_file來抓取科目
# Modify.........: No.MOD-920328 09/03/05 By Pengu 結存調整成本分錄切錯
# Modify.........: No.MOD-930153 09/03/13 By shiwuying CASE 語法錯誤
# Modify.........: No.CHI-930032 09/05/25 By Pengu 抓單據別科目設定(axci010)的會計科目借貸方抓相反
# Modify.........: No.MOD-940173 09/05/25 By Pengu 1.當ccz09 = Y工單差異轉出對應科目應為 ima39
#                                                  2.拆件工單差異轉出在製科目取錯
# Modify.........: No.TQC-970138 09/07/20 By xiaofeizhu 多賬套時，賬套二的分攤部門取g_ccz.ccz231
# Modify.........: No.FUN-980009 09/08/20 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0005 09/10/07 By Smapmin 異動碼預設為NULL而非一個空白
# Modify.........: No:MOD-960313 09/10/20 By Pengu 出售退回的異動命令抓錯
# Modify.........: No:MOD-960321 09/10/20 By Pengu 人工/製費尾差處理的對方科目應抓ccz17才合理
# Modify.........: No:MOD-960341 09/10/20 By Pengu 應該排除工單下階報廢資料
# Modify.........: No:MOD-960363 09/10/20 By Pengu axci101單據分類都設為3會取不到會計科目
# Modify.........: No:MOD-990241 09/10/21 By mike 在select azf07的值之前先对g_azf07 default为NULL 
# Modify.........: No.CHI-970017 09/11/03 By jan 目前程式只有制費1的處理增加制費2-5的處理
# Modify.........: No:MOD-980204 09/11/12 By sabrina 工單差異轉出的ima39沒有值
# Modify.........: No:MOD-990013 09/11/12 By sabrina 單據編號應default為NULL
# Modify.........: No.FUN-9C0073 10/01/11 By chenls  程序精簡
# Modify.........: No:MOD-A80002 10/08/02 By sabrina N p191_cmi04_a製費欄位抓錯
# Modify.........: No:CHI-A70057 10/08/11 By Summer l_cxi03給值的判斷增加atmt260,atmt261
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:CHI-9B0024 10/12/10 By Summer 應該使用ima12做為抓取存貨科目的依據
# Modify.........: No:MOD-B10079 11/01/11 By sabrina 工單結案轉出科目有誤。借貸方顛倒
# Modify.........: No:MOD-B20128 11/02/23 By sabrina 轉銷貨成本傳票，應再加上排除簽收之出貨單 
# Modify.........: No:MOD-B20148 11/02/25 By sabrina 取日期改用s_azm() 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B40056 11/05/13 By guoch 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-B40203 11/07/27 By Summer p191_cs CURSOR在抓imz131的值時，應抓ima131
# Modify.........: No:CHI-C50004 12/05/16 By ck2yuan aimt306、aimt309、aimt307應不列入雜項異動,需在axci010維護對應的會科
# Modify.........: No:MOD-C50163 12/05/22 By ck2yuan sr1.npq05在call p191_chk_aag05前先給值 ccz23 
# Modify.........: No:MOD-B50101 12/06/18 By ck2yuan 1.拆件式工單結案借貸分錄科目錯誤
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:CHI-C80002 12/09/28 By bart 改善效能 1.NOT IN 改為 NOT EXISTS
# Modify.........: No:FUN-C70119 12/11/30 By bart 將p191_tmp改為實體table(cdn_file)
# Modify.........: No:FUN-C80092 12/12/05 By xujing 成本相關作業程式日誌
# Modify.........: No:MOD-D10043 13/01/07 By bart 原抓azf07改抓azf14
# Modify.........: No:CHI-B80042 13/01/22 By Alberti 當部門抓不到時，tlf905改由l_tlf14變數接收
# Modify.........: No:FUN-D40103 13/05/09 By lixh1 增加儲位有效性檢查
# Modify.........: No:FUN-D40118 13/05/22 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
  DEFINE g_wc,g_sql      STRING
  DEFINE tm RECORD
         yy              LIKE type_file.num5,     #No.FUN-680122SMALLINT,            #年度
         mm              LIKE type_file.num5,     #No.FUN-680122SMALLINT,            #月份
         v_no            LIKE npp_file.npp01  #單據號碼
         END RECORD
  DEFINE g_npp           RECORD LIKE npp_file.*
  DEFINE g_npq           RECORD LIKE npq_file.*
  DEFINE g_cnt           LIKE type_file.num5      #No.FUN-680122SMALLINT
  DEFINE g_i             LIKE type_file.num5    #No.FUN-680122 SMALLINT
  DEFINE g_flag          LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
  DEFINE g_gl            LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
  DEFINE l_flag          LIKE type_file.chr1,     #No.FUN-570153  #No.FUN-680122 VARCHAR(1)
         g_change_lang   LIKE type_file.chr1,   #No.FUN-680122 VARCHAR(01),               #是否有做語言切換 No.FUN-570153
         ls_date         STRING                  #->No.FUN-570153
  #DEFINE g_azf07         LIKE azf_file.azf07  #No.FUN-660073  #MOD-D10043
  DEFINE g_azf14         LIKE azf_file.azf14  #MOD-D10043
  DEFINE g_flag1         LIKE type_file.chr1  #No.FUN-730057
  DEFINE g_bookno1       LIKE aag_file.aag00  #No.FUN-730057
  DEFINE g_bookno2       LIKE aag_file.aag00  #No.FUN-730057
  DEFINE g_bookno        LIKE aag_file.aag00  #No.FUN-730057
  DEFINE g_cka00         LIKE cka_file.cka00  #FUN-C80092 add
  DEFINE g_cka09         LIKE cka_file.cka09  #FUN-C80092 add 
  DEFINE g_aag44         LIKE aag_file.aag44  #FUN-D40118 add
  
MAIN
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.yy = ARG_VAL(1)                      
   LET tm.mm = ARG_VAL(2)                      
   LET tm.v_no = ARG_VAL(3)                      
   LET g_bgjob = ARG_VAL(4)                
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = "N" THEN
         CALL p191_ask()
         IF cl_sure(18,20) THEN 
            LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm,";g_bgjob='",g_bgjob,"'"                             #FUN-C80092 add
            CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 add
            BEGIN WORK
            CALL p191('0')
            IF g_aza.aza63 = 'Y' AND g_success = 'Y' AND g_gl = 'Y' THEN
               CALL p191('1')
            END IF
            CASE
                 WHEN g_success = 'Y' AND g_gl = 'Y'
                      COMMIT WORK
                      CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
                      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
                 WHEN g_success = 'Y' AND g_gl = 'N'
                      ROLLBACK WORK
                      CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
                      CALL cl_err('','axc-034',1)             #無資料產生
                      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
                 OTHERWISE
                      ROLLBACK WORK
                      CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
                      CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END CASE
         ELSE
            CONTINUE WHILE
         END IF
     
         IF l_flag THEN
            CONTINUE WHILE
         ELSE
            CLOSE WINDOW p191_w
            EXIT WHILE
         END IF
         CLOSE WINDOW p191_w
      ELSE
         LET g_cka09 = "yy=",tm.yy,";mm=",tm.mm,";g_bgjob='",g_bgjob,"'"   #FUN-C80092 add
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00   #FUN-C80092 ad
         BEGIN WORK
         CALL p191('0')
         IF g_aza.aza63 = 'Y' AND g_success = 'Y' AND g_gl = 'Y' THEN
            CALL p191('1')
         END IF
         CASE
             WHEN g_success = 'Y' AND g_gl = 'Y'
                  COMMIT WORK
                  CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
             OTHERWISE
                  ROLLBACK WORK
                  CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         END CASE
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p191_ask()
  DEFINE l_za05        LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(40)
  DEFINE l_cnt         LIKE type_file.num5    #No.FUN-680122 SMALLINT
  DEFINE lc_cmd        LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(500)            #No.FUN-570153
 
    OPEN WINDOW p191_w WITH FORM "axc/42f/axcp191"
         ATTRIBUTE (STYLE = g_win_style CLIPPED)
    CALL cl_ui_init()
 
    CLEAR FORM
    #讀取成本現行結算年月
    SELECT ccz01,ccz02 INTO tm.yy,tm.mm FROM ccz_file
     WHERE ccz00='0'
    LET g_bgjob = 'N'
    CALL s_get_bookno(tm.yy) RETURNING g_flag1,g_bookno1,g_bookno2
    IF g_flag1 = '1' THEN
       CALL cl_err(tm.yy,'aoo-081',1)
    END IF
    LET tm.v_no = NULL    #No:MOD-990013 add
    WHILE TRUE
    INPUT BY NAME tm.yy,tm.mm,g_bgjob WITHOUT DEFAULTS HELP 1
           AFTER FIELD yy
              IF cl_null(tm.yy) THEN
                 NEXT FIELD yy
              END IF
           AFTER FIELD mm
              IF cl_null(tm.mm) THEN
                 NEXT FIELD mm
              END IF
              IF cl_null(tm.v_no) THEN
                 LET tm.v_no = tm.yy USING '&&&&',tm.mm USING '&&','0001'
              END IF
              DISPLAY BY NAME tm.v_no #ATTRIBUTE(YELLOW)    #TQC-8C0076
              IF NOT cl_null(tm.v_no) THEN
                 #-->check 是否存在
                  SELECT count(*) INTO l_cnt FROM npp_file
                   WHERE npp00  = 1
                     AND npp01  = tm.v_no
                     AND npp011 = 1
                     AND nppsys = 'CA'
                  IF cl_null(l_cnt) THEN
                     LET l_cnt = 0
                  END IF
                  IF l_cnt > 0 THEN
                     CALL cl_err(tm.v_no,'afa-368',0)
                  END IF
              END IF
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION help          #No.TQC-770001                                       
            CALL cl_show_help()  #No.TQC-770001	  
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         BEFORE INPUT
             CALL cl_qbe_init()
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
         ON ACTION locale                          #FUN-570153
            LET g_change_lang = TRUE
            EXIT INPUT                      
 
    END INPUT
    IF INT_FLAG THEN 
       LET INT_FLAG = 0
       CLOSE WINDOW p191_w     
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM           
    END IF
 
    IF g_change_lang THEN
       LET g_change_lang = FALSE
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
       CONTINUE WHILE
    END IF
 
    IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "axcp191"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('axcp191','9031',1)   
       ELSE
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",tm.yy CLIPPED ,"'",
                       " '",tm.mm CLIPPED ,"'",
                       " '",tm.v_no CLIPPED ,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('axcp191',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p191_w
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
       EXIT PROGRAM
    END IF
    EXIT WHILE
 END WHILE
END FUNCTION
 
FUNCTION p191(p_npptype)
  DEFINE p_npptype     LIKE npp_file.npptype  #No.FUN-680086
  DEFINE l_doc         LIKE smy_file.smyslip
  DEFINE l_type        LIKE type_file.chr1    #No.FUN-680122 VARCHAR(01)
  DEFINE l_cxg03       LIKE cxg_file.cxg03
  DEFINE l_cxg04       LIKE cxg_file.cxg04
  DEFINE l_ima39       LIKE ima_file.ima39
  DEFINE l_ccz18       LIKE ccz_file.ccz18    #No.MOD-940173 add
  DEFINE l_ccz181      LIKE ccz_file.ccz181   #No:MOD-980204 add
  DEFINE l_ima391      LIKE ima_file.ima391   #No:MOD-980204 add
  DEFINE l_msg         STRING
  DEFINE l_za05        LIKE type_file.chr1000 #No.FUN-680122 VARCHAR(40)
  DEFINE l_name        LIKE type_file.chr20   #No.FUN-680122 VARCHAR(20)
  DEFINE l_cnt         LIKE type_file.num5,   #No.FUN-680122 SMALLINT
         l_aag05       LIKE aag_file.aag05
  DEFINE l_cxi03       LIKE cxi_file.cxi03
  DEFINE l_cxi05       LIKE cxi_file.cxi05
  DEFINE l_cmi04       LIKE cmi_file.cmi04
  DEFINE l_cmi06       LIKE cmi_file.cmi06
  DEFINE l_cmi08       LIKE cmi_file.cmi08
  DEFINE l_azf05       LIKE azf_file.azf05
  DEFINE l_ima12       LIKE ima_file.ima12
  DEFINE l_cch22b      LIKE cch_file.cch22b
  DEFINE l_cch22c      LIKE cch_file.cch22c
  DEFINE l_amt         LIKE tlf_file.tlf21
  DEFINE sr     RECORD
         tlf01         LIKE tlf_file.tlf01,
         tlf21         LIKE tlf_file.tlf21,
         tlf19         LIKE tlf_file.tlf19,
         tlf13         LIKE tlf_file.tlf13,
         tlf910        LIKE tlf_file.tlf910,
         ima39         LIKE ima_file.ima39,
         ima06         LIKE ima_file.ima06,
         ima12         LIKE ima_file.ima12,
         imz131        LIKE imz_file.imz131,
         cxi04         LIKE cxi_file.cxi04,
         tlf14         LIKE tlf_file.tlf14,
         tlf02         LIKE tlf_file.tlf02,
         tlf03         LIKE tlf_file.tlf03,
         tlf905        LIKE tlf_file.tlf905,
         tlf62         LIKE tlf_file.tlf62,
         tlf036        LIKE tlf_file.tlf036,
         tlf021        LIKE tlf_file.tlf021,
         tlf022        LIKE tlf_file.tlf022,
         tlf906        LIKE tlf_file.tlf906,
         tlf907        LIKE tlf_file.tlf907
         END RECORD
  DEFINE bdate,edate     LIKE tlf_file.tlf06     #No.FUN-680122 DATE
  DEFINE l_exp_tot       LIKE npq_file.npq07
  DEFINE amt,amt2        LIKE apb_file.apb101
  DEFINE l_sfb02         LIKE sfb_file.sfb02
  DEFINE l_sfb82         LIKE sfb_file.sfb82
  DEFINE l_oea15         LIKE oea_file.oea15
  DEFINE l_apb26         LIKE apb_file.apb26
  DEFINE l_apa22         LIKE apa_file.apa22
  DEFINE sr1  RECORD
         tlf905          LIKE tlf_file.tlf905,   #單號
         npq03           LIKE npq_file.npq03,    #科目
         npq04           LIKE npq_file.npq04,    #摘要
         npq05           LIKE npq_file.npq05,    #部門
         npq06           LIKE npq_file.npq06,    #借貸(1/2)
         npq07f          LIKE npq_file.npq07f,   #原幣金額
         npq07           LIKE npq_file.npq07,    #本幣金額
         npq031          LIKE npq_file.npq03     #對方科目   #MOD-870078 add
         END RECORD
  DEFINE l_smydmy2       LIKE smy_file.smydmy2   #No.FUN-660073
  DEFINE l_date          LIKE type_file.dat      #MOD-710146
  DEFINE l_edate         LIKE type_file.dat      #MOD-B20148 add
  DEFINE l_flag          LIKE type_file.chr1     #MOD-B20148 add
  DEFINE l_ccz           RECORD LIKE ccz_file.*, #MOD-870078 add
         l_diff_f        LIKE npq_file.npq07f,   #MOD-870078 add
         l_diff          LIKE npq_file.npq07,    #MOD-870078 add
         l_npq07f_d      LIKE npq_file.npq07f,   #MOD-870078 add
         l_npq07f_c      LIKE npq_file.npq07f,   #MOD-870078 add
         l_npq07_d       LIKE npq_file.npq07,    #MOD-870078 add
         l_npq07_c       LIKE npq_file.npq07     #MOD-870078 add
  DEFINE l_tlf14         LIKE tlf_file.tlf905    #CHI-B80042 add
 
 
    #成本會計系統參數檔
    SELECT * INTO l_ccz.* FROM ccz_file WHERE ccz00='0'   #MOD-870078 add
 
    DECLARE p191_za CURSOR FOR
       SELECT za02,za05 FROM za_file
        WHERE za01 = "axcp191" AND za03 = g_rlang
    FOREACH p191_za INTO g_i,l_za05
       LET g_x[g_i] = l_za05
    END FOREACH
    SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = 'axcp191'
    IF g_len = 0 OR g_len IS NULL THEN LET g_len = 80  END IF
    FOR g_i = 1 TO g_len LET g_dash[g_i,g_i] = '=' END FOR
 
 
 
    IF cl_null(tm.v_no) THEN
       LET tm.v_no = tm.yy USING '&&&&',tm.mm USING '&&','0001'
    END IF
 
 
    CALL cl_outnam('axcp191') RETURNING l_name
    START REPORT axcp191_rep TO l_name
 
    LET g_bookno = g_bookno1
    IF p_npptype = '0' THEN
       LET g_bookno = g_bookno1
    ELSE
       LET g_bookno = g_bookno2
       LET g_ccz.ccz23 = g_ccz.ccz231           #TQC-970138
    END IF
#FUN-C70119---begin 
#    DROP TABLE p191_tmp
#    CREATE TEMP TABLE p191_tmp(
#         tlf905  LIKE tlf_file.tlf905,  #CHAR(16),   #No.FUN-550025
#         npq03   LIKE npq_file.npq03,   #CHAR(20),   #科目
#         npq04   LIKE npq_file.npq04,   #CHAR(40),   #摘要    #FUN-560011
#         npq05   LIKE npq_file.npq05,   #CHAR(6),    #部門
#         npq06   LIKE npq_file.npq06,   #CHAR(1),    #借貸(1/2)
#         npq07f  LIKE npq_file.npq07f,  #DEC(20,6),  #原幣金額
#         npq07   LIKE npq_file.npq07,   #DEC(20,6)   #本幣金額
#         npq031  LIKE npq_file.npq03);               #對方科目   #MOD-870078 add
#
#    DROP TABLE p191_tmp2
#    CREATE TEMP TABLE p191_tmp2(
#         tlf905  LIKE tlf_file.tlf905,  #CHAR(16),   #No.FUN-550025
#         npq03   LIKE npq_file.npq03,   #CHAR(20),   #科目
#         npq04   LIKE npq_file.npq04,   #CHAR(40),   #摘要    #FUN-560011
#         npq05   LIKE npq_file.npq05,   #CHAR(6),    #部門
#         npq06   LIKE npq_file.npq06,   #CHAR(1),    #借貸(1/2)
#         npq07f  LIKE npq_file.npq07f,  #DEC(20,6),  #原幣金額
#         npq07   LIKE npq_file.npq07,   #DEC(20,6)   #本幣金額
#         npq031  LIKE npq_file.npq03);               #對方科目
#FUN-C70119---end 
     DELETE FROM cdn_file WHERE cdn01 = tm.yy AND cdn02 = tm.mm  #FUN-C70119
#insert npp_file,npq_file 單頭/單身資料 --------------------------------
 
       LET g_npp.nppsys ='CA'
       LET g_npp.npp00  = 1
       LET g_npp.npp01  =tm.v_no
       LET g_npp.npp011 = 1
      #LET l_date = MDY(tm.mm,1,tm.yy)                           #MOD-B20148 mark
       CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,l_date,l_edate   #MOD-B20148 add
       LET g_npp.npp02 = s_last(l_date) 
       LET g_npp.npp03  = NULL
       LET g_npp.npp06  = g_plant
       LET g_npp.nppglno= NULL
       LET g_npp.npptype = p_npptype     #No.FUN-680086
       LET g_npp.npplegal = g_legal  #FUN-980009 add
 
       DELETE FROM npp_file
        WHERE nppsys = 'CA'
          AND npp00 = 1
          AND npp01= tm.v_no
          AND npp011 = 1
          AND (nppglno=' ' OR nppglno IS NULL)
          AND npptype = p_npptype     #No.FUN-680086
 
       INSERT INTO npp_file VALUES(g_npp.*)
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
          LET g_success = 'N'
          RETURN
       END IF
       IF g_bgjob = 'N' THEN  #NO.FUN-570153 
           MESSAGE g_npp.npp01
       END IF
   #insert npq_file 單身
       DELETE FROM npq_file
        WHERE npqsys = 'CA'
          AND npq00 = 1
          AND npq01= tm.v_no
          AND npq011 = 1
          AND npqtype = p_npptype     #No.FUN-680086
 
       IF STATUS THEN LET g_success = 'N' RETURN END IF
   #FUN-B40056 --Begin
       DELETE FROM tic_file WHERE tic04 = tm.v_no
  
       IF STATUS THEN LET g_success = 'N' RETURN END IF
   #FUN-B40056 --End
       LET g_npq.npqsys ='CA'
       LET g_npq.npq00  = 1
       LET g_npq.npq01  =tm.v_no
       LET g_npq.npq011 = 1
       LET g_npq.npq02 = 0
       LET g_npq.npq24 = g_aza.aza17   #本幣幣別
       LET g_npq.npq25 = 1
       LET g_npq.npqtype = p_npptype     #No.FUN-680086
 
      #CALL s_ymtodate(tm.yy,tm.mm,tm.yy,tm.mm) RETURNING bdate,edate           #MOD-B20148 mark
       CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,bdate,edate                     #MOD-B20148 add
 
# 分錄產生範圍 ( 191-A -- 191-F )                                                                                                   
                                                                                                                                    
# 191-A.處理異動作業的分錄--處理tlf_file------                                                                                      
 
       LET g_sql="SELECT tlf01,SUM(tlf907*tlf21),",
                #" tlf19,tlf13,tlf910,ima39,ima06,ima12,'','',tlf14,",             #MOD-B40203 mark
                 " tlf19,tlf13,tlf910,ima39,ima06,ima12,ima131,'',tlf14,",         #MOD-B40203 add
                 " tlf02,tlf03,tlf905,tlf62,tlf036,tlf021,tlf022,tlf906,tlf907,smydmy2",   #No.FUN-660073
                 "  FROM tlf_file,smy_file,ima_file  ",
                 " WHERE tlf01 = ima01 ",
                 "   AND tlf61 = smyslip ",
                 "   AND smydmy1 = 'Y' ",
                 "   AND tlf21*tlf907 != 0 ",
                 "   AND tlf06 BETWEEN '",bdate,"' AND '",edate,"' ",
                 "   AND tlf13 NOT IN ('apmt150','apmt1072','apmt230','asft670') ",     #No:MOD-960341 modify
                 #不應包含倉庫調撥
                 "   AND tlf13 NOT IN ('aimt324','aimt720') ",
                 #"   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)", #JIT除外  #CHI-C80002
                 "   AND NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = tlf902)",  #CHI-C80002
                 "   AND tlf905 IS NOT NULL ",
                 " GROUP BY tlf01,tlf19,tlf13,tlf910,ima39,ima06,ima12,ima131,tlf14, ",         #MOD-B40203 add ima131
                 "       tlf02,tlf03,tlf905,tlf62,tlf036,tlf021,tlf022,tlf906,tlf907,smydmy2 ",   #No.FUN-660073
                 " ORDER BY tlf01,tlf910,tlf14 "
#display 'g_sql:',g_sql                  #CHI-A70049 mark
 
       PREPARE p191_prepare FROM g_sql
       DECLARE p191_cs CURSOR WITH HOLD FOR p191_prepare
       IF g_bgjob = 'N' THEN  #NO.FUN-570153 
           MESSAGE 'Working!! Wait Moment..'
       END IF
       FOREACH p191_cs INTO sr.*,l_smydmy2   #No.FUN-660073
          IF STATUS THEN
             CALL cl_err('p191(foreach):',STATUS,1) EXIT FOREACH
          END IF
 
          IF sr.tlf21 IS NULL OR sr.tlf21 = 0 THEN
             CONTINUE FOREACH
          END IF
 
#存貨科目依參數(ccz07)判斷--------------------------
 #(1)取自料件主檔   ima39
 #(2)取自料件分群檔 imz39
 #(3)取自倉庫檔     imd08
 #(4)取自倉庫儲位檔 ime09
 
          CASE g_ccz.ccz07
               WHEN '2'
                    IF p_npptype = '0' THEN
                       SELECT imz39 INTO sr.ima39 FROM imz_file
                        WHERE imz01 = sr.ima12
                    ELSE
                       SELECT imz391 INTO sr.ima39 FROM imz_file
                        WHERE imz01 = sr.ima12
                    END IF
               WHEN '3'
                    IF p_npptype = '0' THEN
                       SELECT imd08 INTO sr.ima39 FROM imd_file
                        WHERE imd01 = sr.tlf021
                    ELSE
                       SELECT imd081 INTO sr.ima39 FROM imd_file
                        WHERE imd01 = sr.tlf021
                    END IF
               WHEN '4'
                    IF p_npptype = '0' THEN
                       SELECT ime09 INTO sr.ima39 FROM ime_file
                        WHERE ime01 = sr.tlf021
                          AND ime02 = sr.tlf022
                          AND imeacti = 'Y'    #FUN-D40103
                    ELSE
                       SELECT ime091 INTO sr.ima39 FROM ime_file
                        WHERE ime01 = sr.tlf021
                          AND ime02 = sr.tlf022
                          AND imeacti = 'Y'    #FUN-D40103 
                    END IF
         END CASE
         IF sr.ima39 IS NULL THEN LET sr.ima39=' ' END IF
 
         IF sr.tlf13[1,5] = 'axmt6' THEN  #排除出至境外倉的出貨
            LET g_cnt = 0
            SELECT COUNT(*) INTO g_cnt FROM oga_file
            #WHERE oga01 = sr.tlf905 AND oga00 = '3'                       #MOD-B20128 mark
             WHERE oga01 = sr.tlf905 AND (oga00 = '3' OR oga65 = 'Y')      #MOD-B20128 add
            IF g_cnt > 0 THEN CONTINUE FOREACH END IF
         END IF
         IF g_bgjob = 'N' THEN  #NO.FUN-570153 
             DISPLAY sr.tlf13,' ',sr.tlf905,' ',sr.tlf21
         END IF
         IF cl_null(sr.tlf910) THEN LET sr.tlf910 = 'N' END IF
 
 
#對方科目(cxi04)的取得--------------------------------------
 
     # 1.取雜收/發的科目,依原因碼+部門別
 
#display 'sr.tlf13=',sr.tlf13 CLIPPED,'- sr.tlf905=',sr.tlf905 CLIPPED    #CHI-A70049 mark
 
       #IF sr.tlf13 LIKE 'aimt3%' THEN #CHI-A70057 mark
      #IF sr.tlf13 LIKE 'aimt3%' OR sr.tlf13 LIKE 'atmt26%' THEN #CHI-A70057            #CHI-C50004 mark
       IF (sr.tlf13 LIKE 'aimt3%' AND sr.tlf13 != 'aimt306' AND sr.tlf13 != 'aimt307'   #CHI-C50004 add
           AND sr.tlf13 != 'aimt309') OR sr.tlf13 LIKE 'atmt26%' THEN                   #CHI-C50004 add
            IF cl_null(sr.tlf19) THEN
               SELECT ina04 INTO sr.tlf19 FROM ina_file
                WHERE ina01 = sr.tlf905
            END IF
 
            CASE WHEN  sr.tlf13 = 'aimt301' OR sr.tlf13 = 'aimt311' OR        #No.MOD-930153
                       sr.tlf13 = 'aimt303' OR sr.tlf13 = 'aimt313'           #No.MOD-930153
                       LET l_cxi03 = '2'
                 WHEN  sr.tlf13 = 'aimt302' OR sr.tlf13 = 'aimt312'           #No.MOD-930153
                       LET l_cxi03 = '1'
                 #CHI-A70057 add --start--
                 WHEN  sr.tlf13 = 'atmt260'
                       LET l_cxi03 = '4'
                 WHEN  sr.tlf13 = 'atmt261'
                       LET l_cxi03 = '5'
                 #CHI-A70057 add --end--
            END CASE
 
            IF p_npptype = '0' THEN
               SELECT cxi04,cxi05 INTO sr.cxi04,l_cxi05 FROM cxi_file
                WHERE cxi01 = sr.tlf19
                  AND cxi02 = sr.tlf14
                  AND cxi03 = l_cxi03
               IF STATUS = 100 THEN
                  SELECT cxi04,cxi05 INTO sr.cxi04,l_cxi05 FROM cxi_file
                   WHERE cxi01 = sr.tlf19
                     AND cxi02 = sr.tlf14
                     AND cxi03 = '3'
               END IF
            ELSE
               SELECT cxi041,cxi05 INTO sr.cxi04,l_cxi05 FROM cxi_file
                WHERE cxi01 = sr.tlf19
                  AND cxi02 = sr.tlf14
                  AND cxi03 = l_cxi03
               IF STATUS = 100 THEN
                  SELECT cxi041,cxi05 INTO sr.cxi04,l_cxi05 FROM cxi_file
                   WHERE cxi01 = sr.tlf19
                     AND cxi02 = sr.tlf14
                     AND cxi03 = '3'
               END IF
            END IF
 
            IF STATUS = 100 THEN
               LET g_npq.npq05 = 'cxc001'   #部門
               IF NOT cl_null(sr.tlf19) THEN
                 # LET sr.tlf905 = sr.tlf14,'-',sr.tlf19 CLIPPED,'-',sr.cxi04  #CHI-B80042 mark
                  LET l_tlf14 = sr.tlf14,'-',sr.tlf19 CLIPPED,'-',sr.cxi04     #CHI-B80042 add
               END IF
            ELSE
               LET g_npq.npq05 = l_cxi05   #(取得成本歸屬部門)
            END IF
 
       ELSE
 
       # 2.盤點單  (tlf02 < 10)
         # tlf907 < 0 --> 借: 盤虧->材料盤虧(ccz24)
         # tlf907 > 0 --> 貸: 盤盈->材料盤盈(ccz25)
         IF sr.tlf02 < 10 OR sr.tlf03 < 10 THEN
            IF p_npptype = '0' THEN
               IF sr.tlf907 < 0  THEN
                  LET sr.cxi04 = g_ccz.ccz24
               ELSE
                  LET sr.cxi04 = g_ccz.ccz25
               END IF
            ELSE
               IF sr.tlf907 < 0  THEN
                  LET sr.cxi04 = g_ccz.ccz241
               ELSE
                  LET sr.cxi04 = g_ccz.ccz251
               END IF
            END IF
 
         ELSE
 
    # 3.其他=> 依單別設定的對方科目(cxg05)
          CALL s_get_doc_no(sr.tlf905) RETURNING l_doc
          IF sr.tlf21 > 0 THEN
             LET l_type = '2'   #No.CHI-930032 add
          ELSE
             LET l_type = '1'   #No.CHI-930032 add
          END IF
 
         #依據各單別種類來源(cxg03)的設定取出科目
          SELECT UNIQUE cxg03 INTO l_cxg03 FROM cxg_file
           WHERE cxg01 = l_doc
             AND cxg02 = l_type
 
         #依cxg03類別取科目
         #0.單一科目
         #1.成本分群
         #2.主分群碼
         #3.產品分類
         #4.依成本參數(ccz07)設定
 
          IF l_cxg03 ='4' THEN
            #依存貨科目參數(ccz07)判斷--------------------------
            #(1)取自料件主檔   ima39
            #(2)取自料件分群檔 imz39
            #(3)取自倉庫檔     imd08
            #(4)取自倉庫儲位檔 ime09
 
             CASE g_ccz.ccz07
                  WHEN '1'
                        LET sr.cxi04 = sr.ima39
                  WHEN '2'
                        IF p_npptype = '0' THEN
                           SELECT imz39 INTO sr.cxi04 FROM imz_file
                            WHERE imz01 = sr.ima12
                        ELSE
                           SELECT imz391 INTO sr.cxi04 FROM imz_file
                            WHERE imz01 = sr.ima12
                        END IF
                  WHEN '3'
                        IF p_npptype = '0' THEN
                           SELECT imd08 INTO sr.cxi04 FROM imd_file
                            WHERE imd01 = sr.tlf021
                        ELSE
                           SELECT imd081 INTO sr.cxi04 FROM imd_file
                            WHERE imd01 = sr.tlf021
                        END IF
                  WHEN '4'
                        IF p_npptype = '0' THEN
                           SELECT ime09 INTO sr.cxi04 FROM ime_file
                            WHERE ime01 = sr.tlf021
                              AND ime02 = sr.tlf022
                               AND imeacti = 'Y'    #FUN-D40103
                        ELSE
                           SELECT ime091 INTO sr.cxi04 FROM ime_file
                            WHERE ime01 = sr.tlf021
                              AND ime02 = sr.tlf022
                               AND imeacti = 'Y'    #FUN-D40103
                        END IF
             END CASE
          ELSE
             #依cxg03類別取科目
             #0.單一科目
             #1.成本分群
             #2.主分群碼
             #3.產品分類
             CASE WHEN l_cxg03 = '0'  LET l_cxg04 = 'XXXXX'
                  WHEN l_cxg03 = '1'  LET l_cxg04 = sr.ima12
                  WHEN l_cxg03 = '2'  LET l_cxg04 = sr.ima06
                  WHEN l_cxg03 = '3'  LET l_cxg04 = sr.imz131
             END CASE
             IF p_npptype = '0' THEN
                 SELECT cxg05 INTO sr.cxi04 FROM cxg_file
                  WHERE cxg01 = l_doc
                    AND cxg02 = l_type
                    AND cxg03 = l_cxg03
                    AND cxg04 = l_cxg04
             ELSE
                 SELECT cxg051 INTO sr.cxi04 FROM cxg_file
                  WHERE cxg01 = l_doc
                    AND cxg02 = l_type
                    AND cxg03 = l_cxg03
                    AND cxg04 = l_cxg04
             END IF
          END IF
 
 
          IF sr.tlf13[1,5] = 'asft6' AND (sr.tlf02 = 65 OR sr.tlf03 =65)
             #'拆件式工單入庫'
             OR (sr.tlf13[1,5] = 'asfi5' AND sr.tlf02 = 50) #'工單領用'
             OR (sr.tlf13[1,5] = 'asfi5' AND sr.tlf03 = 50) #'工單領用退料'
          THEN
             LET l_sfb82=''
 
             SELECT sfb02 INTO l_sfb02 FROM sfb_file WHERE sfb01=sr.tlf62
 
             IF sr.tlf13[1,5] = 'asft6' THEN
               IF l_sfb02 = '7' or l_sfb02 = '8' THEN
                  SELECT rvu06 INTO l_sfb82 FROM rvu_file
                   WHERE rvu01 = sr.tlf036
               ELSE
                  SELECT sfu04 INTO l_sfb82 FROM sfu_file
                   WHERE sfu01 = sr.tlf905
               END IF
             END IF
             IF sr.tlf13[1,5] = 'asfi5' THEN
               IF (l_sfb02 = '7' or l_sfb02 = '8') AND sr.tlf03 = '18' THEN
                   SELECT rvu06 INTO l_sfb82 FROM rvu_file
                    WHERE  rvu01 = sr.tlf036
               ELSE
                   SELECT sfp07 INTO l_sfb82 FROM sfp_file
                    WHERE sfp01 = sr.tlf905
               END IF
             END IF
 
 
             IF cl_null(l_sfb82) THEN
            #==> 若未輸入部門則列印 "   工單未輸入部門無法"
                LET g_npq.npq05 = 'cxc002'
                LET sr.tlf905 = sr.tlf62
             ELSE
                LET g_npq.npq05 = l_sfb82  #(取得部門)
             END IF
 
             IF sr.cxi04 = ' ' THEN
                LET g_npq.npq05 = 'cxc001'
             END IF
          END IF
 
          IF sr.tlf13 = 'aomt800'  #  '銷單退貨入庫'
             OR (sr.tlf13[1,5] = 'axmt6' AND sr.tlf02 = 50) #'出售'
             OR (sr.tlf13[1,5] = 'axmt6' AND sr.tlf03 = 50) THEN #'出售退回'
             LET l_oea15=''
             IF sr.tlf13 = 'aomt800' THEN
                SELECT oha15 INTO l_oea15 FROM oha_file
                 WHERE oha01 = sr.tlf905
                IF STATUS = 100 THEN
                   SELECT oha15 INTO l_oea15 FROM oha_file
                    WHERE oha01 = sr.tlf905
                END IF
             ELSE
                SELECT oga15 INTO l_oea15 FROM oga_file
                 WHERE oga01 = sr.tlf905
             END IF
             IF cl_null(l_oea15) THEN
            #==> 若未輸入部門則列印 "訂單未輸入部門無法"
                LET g_npq.npq05 = 'cxc003'
             ELSE
                LET g_npq.npq05 = l_oea15  #(取得部門)
             END IF
          END IF
 
         END IF
       END IF
        #-------------------------------------------------------
        #給摘要npq04(異動類別)
#            異動分類(xx)+成本分群(ima12)
#            異動分類如下:
#            銷售   => S1 出售     S2 出售退回
#            工單   => W1 發料     W2 發料退回  W3 入庫
#            雜收   => O1 雜發
#            雜發   => O2 雜收
#            以上皆不是=>其他異動
 
         CASE
             WHEN sr.tlf13 = 'asfi511'
               OR sr.tlf13 = 'asfi512'
               OR sr.tlf13 = 'asfi513'
               OR sr.tlf13 = 'asfi514'
               OR sr.tlf13 = 'asfi519'                    #FUN-C70014
                  LET sr1.npq04 = 'W1 ',g_x[09] CLIPPED   #工單發料
             WHEN sr.tlf13 = 'asfi526'
               OR sr.tlf13 = 'asfi527'
               OR sr.tlf13 = 'asfi528'
               OR sr.tlf13 = 'asfi529'
                  LET sr1.npq04 = 'W2 ',g_x[10] CLIPPED   #工單發料退回
             WHEN sr.tlf13 MATCHES 'asft6*'
                  LET sr1.npq04 = 'W3 ',g_x[11] CLIPPED   #工單入庫
             WHEN sr.tlf13 = 'aomt800'    #No:MOD-960313 modify
                  LET sr1.npq04 = 'S2 ',g_x[13] CLIPPED   #出售退回
             WHEN sr.tlf13 = 'axmt620'
               OR sr.tlf13 = 'axmt650'
               OR sr.tlf13 = 'axmt820'
                  LET sr1.npq04 = 'S1 ',g_x[12] CLIPPED   #出售
             WHEN sr.tlf13 = 'aimt301'
               OR sr.tlf13 = 'aimt311'
                  SELECT COUNT(*) INTO l_cnt FROM inb_file
                  #替換inb902-->inb908,inb903-->inb909
                   WHERE inb908 = tm.yy
                     AND inb909 = tm.mm
                     AND inb01  = sr.tlf905
                     AND inb03  = sr.tlf906
                IF l_cnt > 0 THEN
                   LET l_exp_tot = l_exp_tot + sr.tlf21*-1
                   LET sr1.npq04 ="O11 ",'EXP-',g_x[14] CLIPPED  #'EXP-雜發
                ELSE
                   LET sr1.npq04 ="O11 ",g_x[14] CLIPPED         #雜發
                END IF
             WHEN sr.tlf13 = 'aimt302'                           #雜收
               OR sr.tlf13 = 'aimt312'
                  LET sr1.npq04 = 'O2 ',g_x[15] CLIPPED
 
             WHEN sr.tlf13 = 'aimp880' AND sr.tlf03 = 50        #盤盈
                  LET sr1.npq04 = 'P1 ',g_x[17] CLIPPED
             WHEN sr.tlf13 = 'aimp880' AND sr.tlf02 = 50        #盤虧
                  LET sr1.npq04 = 'P2 ',g_x[18] CLIPPED
             OTHERWISE
                  LET sr1.npq04 = 'OTHER ',g_x[16] CLIPPED      #其他
         END CASE
 
         LET sr1.npq04 = sr1.npq04 CLIPPED,p191_get_ima12(sr.ima12)
 
         LET sr1.npq07f = 0
         LET sr1.npq07  = 0
         #CHI-B80042---modify---start---
         #LET sr1.tlf905 = sr.tlf905
         IF g_npq.npq05 != 'cxc001' THEN
            LET sr1.tlf905 = sr.tlf905 
         ELSE
            LET sr1.tlf905=l_tlf14
         END IF
        #CHI-B80042---modify---end---
         #判斷存貨科目借貸方(sr.tlf21 > 0為借方，< 0 為貸方)
         IF sr.tlf21 < 0 THEN
              #--對方科目(借)---------------------------
              IF l_smydmy2 = "2" THEN
                 #MOD-D10043---begin mark
                 #LET g_azf07 = '' #MOD-990241   
                 #SELECT azf07 INTO g_azf07 FROM azf_file
                 # WHERE azf01 = sr.tlf14
                 #   AND azf08 = "Y"
                 #IF NOT cl_null(g_azf07) THEN
                 #   LET sr1.npq03 =g_azf07
                 #MOD-D10043---end
                 #MOD-D10043---begin
                 LET g_azf14 = ''   
                 SELECT azf14 INTO g_azf14 FROM azf_file
                  WHERE azf01 = sr.tlf14
                    AND azf08 = "Y"
                 IF NOT cl_null(g_azf14) THEN
                    LET sr1.npq03 =g_azf14
                 #MOD-D10043---end
                 ELSE
                    LET sr1.npq03 =sr.cxi04
                 END IF
              ELSE
                 LET sr1.npq03 =sr.cxi04
              END IF
              LET sr1.npq031=sr.ima39   #MOD-870078 add
              #若要做部門管理
              LET sr1.npq05 =g_npq.npq05
              LET sr1.npq05 =p191_chk_aag05(sr1.npq03,sr1.npq05)
              LET sr1.npq06 ='1'
	      LET sr1.npq07f=sr.tlf21 * -1
              LET sr1.npq07 =sr.tlf21 * -1
              IF cl_null(sr1.npq03) THEN
                 IF g_bgjob = 'N' THEN    #NO.FUN-570153 
                    DISPLAY sr1.npq04,sr.tlf905
                 END IF
              END IF
              LET l_msg = g_x[20] CLIPPED  #A.tlf_file處理之對方科目
              OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
              LET sr1.npq05 =p191_chk_aag05(sr1.npq03,sr1.npq05)
              CALL p191_get_test(sr1.npq03)
              #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
              INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                            VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
              IF SQLCA.SQLCODE != 0 THEN 
                 IF g_bgjob= 'N' THEN #NO.FUN-570153 
                    ERROR 'error d1  ' 
                 END IF
              END IF
 
              #--存貨科目(貸)---------------------------
              LET sr1.npq03 =sr.ima39
              LET sr1.npq031=sr.cxi04   #MOD-870078 add
              #若要做部門管理
              LET sr1.npq05 =sr.tlf19
              LET sr1.npq05 =p191_chk_aag05(sr1.npq03,sr1.npq05)
              LET sr1.npq06 ='2'
	      LET sr1.npq07f=sr.tlf21 * -1
              LET sr1.npq07 =sr.tlf21 * -1
              IF cl_null(sr1.npq03) THEN
                 IF g_bgjob = 'N' THEN    #NO.FUN-570153 
                    DISPLAY sr1.npq04,sr.tlf905
                 END IF
              END IF
              LET l_msg = g_x[21] CLIPPED   #A.tlf_file處理之存貨科目
              OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
              CALL p191_get_test(sr1.npq03)
              #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
              INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                            VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
              IF SQLCA.SQLCODE != 0 THEN 
                 IF g_bgjob= 'N' THEN #NO.FUN-570153 
                    ERROR 'error d2  ' 
                 END IF
              END IF
 
           END IF
           IF sr.tlf21 > 0 THEN
              #--存貨科目(借)---------------------------
              LET sr1.npq03 =sr.ima39
              LET sr1.npq031=sr.cxi04   #MOD-870078 add
              LET sr1.npq05 =sr.tlf19
              LET sr1.npq05 =p191_chk_aag05(sr1.npq03,sr1.npq05)
              LET sr1.npq06 ='1'
	      LET sr1.npq07f=sr.tlf21
              LET sr1.npq07 =sr.tlf21
              IF cl_null(sr1.npq03) THEN
                 IF g_bgjob = 'N' THEN    #NO.FUN-570153 
                    DISPLAY sr1.npq04,sr.tlf905
                 END IF
              END IF
              LET l_msg = g_x[21] CLIPPED     #A.tlf_file處理之存貨科目
              OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
              #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
              INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                            VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
              IF SQLCA.SQLCODE != 0 THEN 
                  IF g_bgjob= 'N' THEN #NO.FUN-570153 
                      ERROR   'error d3  ' 
                  END IF
              END IF
              #--對方科目(貸)---------------------------
              IF l_smydmy2 = "2" THEN
                 #MOD-D10043---begin mark
                 #LET g_azf07 = '' #MOD-990241   
                 #SELECT azf07 INTO g_azf07 FROM azf_file
                 # WHERE azf01 = sr.tlf14
                 #   AND azf08 = "Y"
                 #IF NOT cl_null(g_azf07) THEN
                 #   LET sr1.npq03 =g_azf07
                 #MOD-D10043---end
                 #MOD-D10043---begin
                 LET g_azf14 = '' #MOD-990241   
                 SELECT azf14 INTO g_azf14 FROM azf_file
                  WHERE azf01 = sr.tlf14
                    AND azf08 = "Y"
                 IF NOT cl_null(g_azf14) THEN
                    LET sr1.npq03 =g_azf14
                 #MOD-D10043---end
                 ELSE
                    LET sr1.npq03 =sr.cxi04
                 END IF
              ELSE
                 LET sr1.npq03 =sr.cxi04
              END IF
              LET sr1.npq031=sr.ima39   #MOD-870078 add
              # 011211 By Star 若要做部門管理, 則依tlf19 的部門帶入
              LET l_aag05 = NULL
              LET sr1.npq05 =g_npq.npq05
              LET sr1.npq05 =p191_chk_aag05(sr1.npq03,sr1.npq05)
              LET sr1.npq06 ='2'
	      LET sr1.npq07f=sr.tlf21
              LET sr1.npq07 =sr.tlf21
              IF cl_null(sr1.npq03) THEN
                 IF g_bgjob = 'N' THEN    #NO.FUN-570153 
                    DISPLAY sr1.npq04,sr.tlf905
                 END IF
              END IF
              LET l_msg = g_x[20] CLIPPED   #A.tlf_file處理之對方科目
              CALL p191_get_test(sr1.npq03)
              OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
              #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
              INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                            VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
              IF SQLCA.SQLCODE != 0 THEN 
                  IF g_bgjob= 'N' THEN #NO.FUN-570153 
                      ERROR   'error d4  ' 
                  END IF
              END IF
           END IF
   END FOREACH
 
   LET sr1.tlf905 = ' '
 
# 191-B.處理加工費--------------------------------------------------------
#    借:在製品(ccz17)
#       貸:加工費(ccz16)
#    資料來源.apb_file
#       先取AP 的加工費 ,若取不到則取入庫單的金額
#       以AP 單身的部門 ,若單身無部門取單頭的部門
 
 
   IF g_bgjob = 'N' THEN    #NO.FUN-570153 
       DISPLAY '加工費轉在製!!'
   END IF
   LET amt = 0
   LET amt2 = 0
   LET l_apb26=''
   LET l_apa22=''
 
   DECLARE pmm_curs CURSOR WITH HOLD FOR
    SELECT SUM(apb101),apb26,apa22     #No.FUN-680086
    FROM pmn_file,apb_file,apa_file,rvv_file,pmm_file       #委外入庫   #No.MOD-780265 del tlf_file
      WHERE pmn01=apb06
        AND pmn02=apb07
        AND apb29 = '1'
        AND apb01=apa01
        AND apb21=rvv01
        AND apb22=rvv02
        AND apa02 BETWEEN bdate AND edate   #No.MOD-890126 add
        AND apb34 <> 'Y'                    #No.MOD-890126 add
        AND pmm01= pmn01
        AND pmm02 ='SUB'
        #AND (rvv32 NOT IN (SELECT jce02 FROM jce_file) OR rvv32 = ' ')  #CHI-C80002
        AND (NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32) OR rvv32 = ' ')  #CHI-C80002
        AND rvv09 BETWEEN bdate AND edate
        AND pmn65='1'
      GROUP BY apb26,apa22
 
   FOREACH pmm_curs INTO amt,l_apb26,l_apa22     #No.FUN-680086
 
    #配合成本分攤aapt900 apb10->apb101
     LET amt2 = 0
     IF NOT cl_null(l_apb26) THEN
        SELECT SUM(apb101) INTO amt2
          FROM pmn_file,apb_file,apa_file,rvv_file,pmm_file  # 委外退貨 #No.MOD-780265 del tlf_file
         WHERE pmn01=apb06
           AND pmn02=apb07
           AND apb29 = '3'
           AND apb21=rvv01
           AND apb22=rvv02
           AND apa02 BETWEEN bdate AND edate   #No.MOD-890126 add
           AND apb34 <> 'Y'                    #No.MOD-890126 add
           AND pmm01= pmn01
           AND pmm02= 'SUB'
           AND rvv09 BETWEEN bdate AND edate
           #AND (rvv32 NOT IN (SELECT jce02 FROM jce_file) OR rvv32 = ' ')  #CHI-C80002
           AND (NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32) OR rvv32 = ' ')  #CHI-C80002
           AND apb01 = apa01
           AND apa42 = 'N'
           AND apa58 = '2'
           AND pmn65 = '1'
           GROUP BY apb26,apa22   #No.MOD-780265 add
     ELSE
        SELECT SUM(apb101) INTO amt2
          FROM pmn_file,apb_file,apa_file,rvv_file,pmm_file  # 委外退貨  #No.MOD-780265 del tlf_file
         WHERE pmn01=apb06
           AND pmn02=apb07
           AND apb29 = '3'
           AND apb21=rvv01
           AND apb22=rvv02
           AND apa02 BETWEEN bdate AND edate   #No.MOD-890126 add
           AND apb34 <> 'Y'                    #No.MOD-890126 add
           AND pmm01= pmn01
           AND pmm02= 'SUB'
           AND rvv09 BETWEEN bdate AND edate
           #AND (rvv32 NOT IN (SELECT jce02 FROM jce_file) OR rvv32 = ' ')  #CHI-C80002 
           AND (NOT EXISTS(SELECT 1 FROM jce_file WHERE jce02 = rvv32) OR rvv32 = ' ')  #CHI-C80002
           AND apb01 = apa01
           AND apa42 = 'N'
           AND apa58 = '2'
           AND pmn65 ='1'
           AND apa22 = l_apa22
           GROUP BY apb26,apa22   #No.MOD-780265 add
     END IF
 
     IF amt  IS NULL THEN LET amt =0 END IF
     IF amt2 IS NULL THEN LET amt2=0 END IF
     LET amt = amt - amt2
 
     #借:在製品
      IF p_npptype = '0' THEN
         LET sr1.npq03 = g_ccz.ccz17 
         LET sr1.npq031= g_ccz.ccz16     #MOD-870078 add
      ELSE
         LET sr1.npq03 = g_ccz.ccz171    #No.FUN-680086
         LET sr1.npq031= g_ccz.ccz161    #MOD-870078 add
      END IF
      LET sr1.npq04 = g_x[22] CLIPPED    #'加工費投入在製'
      LET sr1.npq05 = NULL
      LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
      LET sr1.npq06 = '1'
      LET sr1.npq07f= amt
      LET sr1.npq07 = amt
 
      LET l_msg = g_x[23]  CLIPPED    #"B.加工費處理之在製品科目(ccz17)"
      OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
      #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
      INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                    VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
 
     #貸:加工費
      IF p_npptype = '0' THEN
         LET sr1.npq03 = g_ccz.ccz16
         LET sr1.npq031= g_ccz.ccz17     #MOD-870078 add
      ELSE
         LET sr1.npq03 = g_ccz.ccz161    #No.FUN-680086
         LET sr1.npq031= g_ccz.ccz171    #MOD-870078 add
      END IF
      LET sr1.npq06 ='2'
      LET sr1.npq07f=amt
      LET sr1.npq07 =amt
 
      SELECT aag05 INTO l_aag05 FROM aag_file
       WHERE aag01 = g_ccz.ccz16
         AND aag00 = g_bookno1       #No.FUN-730057
      IF cl_null(l_aag05) THEN LET l_aag05 = ' ' END IF
 
      #要作部門管理
      #以AP 單身的部門 ,若單身無部門取單頭的部門
      IF l_aag05 = 'Y' THEN
         IF NOT cl_null(l_apb26) THEN
            LET sr1.npq05= l_apb26
         ELSE
            LET sr1.npq05= l_apa22
         END IF
      ELSE
         LET sr1.npq05=' '
      END IF
 
      LET sr1.npq05 =p191_chk_aag05(sr1.npq03,sr1.npq05)
 
      LET l_msg = g_x[24] CLIPPED    #"B.加工費處理之加工費科目(ccz16)"
      OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
      #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
      INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                    VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
   END FOREACH
 
 
# 191-C.人工/製費彙總-------------------------------------------------------
  # 191-C01.人工
  # 191-C02.製費
  # 191-C03.人工/製費尾差處理
 
 #g_ccz.ccz10=1 OR " " -->人工/製費由人工輸入,所以不自動產生傳票,不處理人工製費
 #'1.人工/製費由人工輸入,所以不自動產生傳票
  IF g_ccz.ccz10 = '1' OR g_ccz.ccz10 = '' THEN
     LET l_msg = g_x[25] CLIPPED
     INITIALIZE sr1.* TO NULL
     OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
     LET l_msg = g_x[26] CLIPPED     #'2.不處理人工/製費'
     OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
  END IF
 
 
 #成本參數ccz10 = '2'才作業
  #資料來源cmi_file --> cmi04: 類別 1.人工  2.製費
 
  IF g_ccz.ccz10 = '2' THEN
     DECLARE ccz_curs CURSOR WITH HOLD FOR
       SELECT cmi04,cmi06,SUM(cmi08)  FROM cmi_file
        WHERE cmi01 = tm.yy AND cmi02 = tm.mm
        GROUP BY cmi04,cmi06
     FOREACH ccz_curs INTO l_cmi04,l_cmi06,l_cmi08
 
  # 191-C01.人工
        IF l_cmi04 = '1' THEN
           #借:在製品(ccz17)
              #貸:人工(ccz14) = SUM(cmi08)
           LET sr1.npq04 = g_x[27] CLIPPED     #'直接人工投入在製'
           IF p_npptype = '0' THEN
              LET sr1.npq03 = g_ccz.ccz17
              LET sr1.npq031= g_ccz.ccz14     #MOD-870078 add
           ELSE
              LET sr1.npq03 = g_ccz.ccz171
              LET sr1.npq031= g_ccz.ccz141    #MOD-870078 add
           END IF
           LET sr1.npq06 = '1'
           LET sr1.npq07f= l_cmi08
           LET sr1.npq07 = l_cmi08
           LET sr1.npq05 = NULL
           LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
 
           LET l_msg = g_x[28] CLIPPED         #"C.人工費處理之在製品科目(ccz17)"
           OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
           #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
           INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                         VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119 
           IF p_npptype = '0' THEN
              LET sr1.npq03 = g_ccz.ccz14
              LET sr1.npq031= g_ccz.ccz17     #MOD-870078 add
           ELSE
              LET sr1.npq03 = g_ccz.ccz141
              LET sr1.npq031= g_ccz.ccz171    #MOD-870078 add
           END IF
           LET sr1.npq06 = '2'
           LET sr1.npq07f= l_cmi08
           LET sr1.npq07 = l_cmi08
           LET sr1.npq05 = l_cmi06
           LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
 
           LET l_msg = g_x[29] CLIPPED        #"C.人工費處理之人工科目(ccz14)"
           OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
           #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
           INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                         VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
        END IF
 
  # 191-C02.製費
 





       IF l_cmi04 = '2' THEN
          CALL p191_cmi04(sr1.*,g_ccz.ccz15,g_ccz.ccz151,l_cmi08,l_cmi06,p_npptype,l_cmi04)
       END IF
       IF l_cmi04 = '3' THEN
          CALL p191_cmi04(sr1.*,g_ccz.ccz33,g_ccz.ccz331,l_cmi08,l_cmi06,p_npptype,l_cmi04)
       END IF
       IF l_cmi04 = '4' THEN
          CALL p191_cmi04(sr1.*,g_ccz.ccz34,g_ccz.ccz341,l_cmi08,l_cmi06,p_npptype,l_cmi04)
       END IF
       IF l_cmi04 = '5' THEN
          CALL p191_cmi04(sr1.*,g_ccz.ccz35,g_ccz.ccz351,l_cmi08,l_cmi06,p_npptype,l_cmi04)
       END IF
       IF l_cmi04 = '6' THEN
          CALL p191_cmi04(sr1.*,g_ccz.ccz36,g_ccz.ccz361,l_cmi08,l_cmi06,p_npptype,l_cmi04)
       END IF
     END FOREACH
 
  # 191-C03.人工/製費尾差處理
     #2.人工製費的多分攤 / 少分攤
     #人工 (尾差分攤部門(ccz23)兩個都用這個部門)
     SELECT SUM(cch22b) INTO l_cch22b FROM cch_file
      WHERE cch02 = tm.yy  AND cch03= tm.mm
        AND cch04 = ' DL+OH+SUB'
 
     DECLARE ccz1_curs CURSOR WITH HOLD FOR
       SELECT SUM(cmi08)  FROM cmi_file
         WHERE cmi01 = tm.yy AND cmi02 = tm.mm AND cmi04='1'
 
     LET l_amt=0
     LET l_cmi04=''
     LET l_cmi06=''
     LET l_cmi08=0
     FOREACH ccz1_curs INTO l_cmi08
        LET l_amt =l_cmi08 - l_cch22b
        IF l_amt > 0 THEN
        #借:人工分攤尾差科目:(ccz20)
        #貸:在製 = l_amt = (GROUP SUM(cmi08) where cmi04='1')  -l_cch22b
            LET sr1.npq04 = g_x[33] CLIPPED     #'人工費用少分攤'
            IF p_npptype = '0' THEN
               LET sr1.npq03 = g_ccz.ccz20
               LET sr1.npq031= g_ccz.ccz17      #MOD-870078 add   #No:MOD-960321 modify
            ELSE
               LET sr1.npq03 = g_ccz.ccz201
               LET sr1.npq031= g_ccz.ccz171     #MOD-870078 add   #No:MOD-960321 modify
            END IF
            LET sr1.npq06 = '1'
            LET sr1.npq07f= l_amt
            LET sr1.npq07 = l_amt
            LET sr1.npq05 = NULL
            LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
 
            LET l_msg = g_x[34] CLIPPED         #"C.人工費處理之人工分攤尾差科目(ccz20)"
            OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
            #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
            INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                          VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119 
            IF p_npptype = '0' THEN
               LET sr1.npq03 = g_ccz.ccz17      #No:MOD-960321 modify
               LET sr1.npq031= g_ccz.ccz20      #MOD-870078 add
            ELSE
               LET sr1.npq03 = g_ccz.ccz171     #No:MOD-960321 modify
               LET sr1.npq031= g_ccz.ccz201     #MOD-870078 add
            END IF
            LET sr1.npq05 = g_ccz.ccz23
            LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
            LET sr1.npq06 = '2'
            LET sr1.npq07f= l_amt
            LET sr1.npq07 = l_amt
 
            LET l_msg = g_x[35] CLIPPED         #"C.人工費處理之分攤尾差在製科目(ccz16)"
            OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
            #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
            INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                          VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
        ELSE
           #借:在製 = l_amt (ccz16)
              #貸:人工分攤尾差科目:(ccz20)
            LET sr1.npq04 = g_x[36] CLIPPED     #'人工費用多分攤'
            IF p_npptype = '0' THEN
               LET sr1.npq03 = g_ccz.ccz20
               LET sr1.npq031= g_ccz.ccz17      #MOD-870078 add  #No:MOD-960321 modify
            ELSE
               LET sr1.npq03 = g_ccz.ccz201
               LET sr1.npq031= g_ccz.ccz171     #MOD-870078 add  #No:MOD-960321 modify
            END IF
            LET sr1.npq05 = NULL
            LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
            LET sr1.npq06 = '2'
            LET sr1.npq07f= l_amt * -1
            LET sr1.npq07 = l_amt * -1
 
            LET l_msg = g_x[34] CLIPPED        #"C.人工費處理之人工分攤尾差科目(ccz20)"
            OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
            #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
            INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                          VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119 
            IF p_npptype = '0' THEN
               LET sr1.npq03 = g_ccz.ccz17      #No:MOD-960321 modify
               LET sr1.npq031= g_ccz.ccz20      #MOD-870078 add
            ELSE
               LET sr1.npq03 = g_ccz.ccz171     #No:MOD-960321 modify
               LET sr1.npq031= g_ccz.ccz201     #MOD-870078 add
            END IF
            LET sr1.npq05 = g_ccz.ccz23
            LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
            LET sr1.npq06 = '1'
            LET sr1.npq07f= l_amt * -1
            LET sr1.npq07 = l_amt * -1
 
            LET l_msg = g_x[35] CLIPPED       #"C.人工費處理之分攤尾差在製科目(ccz16)"
            OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
            #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
            INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                          VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
        END IF
     END FOREACH
 
     CALL p191_cmi04_a(sr1.*,'2',p_npptype,g_ccz.ccz21,g_ccz.ccz211)
     CALL p191_cmi04_a(sr1.*,'3',p_npptype,g_ccz.ccz37,g_ccz.ccz371)
     CALL p191_cmi04_a(sr1.*,'4',p_npptype,g_ccz.ccz38,g_ccz.ccz381)
     CALL p191_cmi04_a(sr1.*,'5',p_npptype,g_ccz.ccz39,g_ccz.ccz391)
     CALL p191_cmi04_a(sr1.*,'6',p_npptype,g_ccz.ccz40,g_ccz.ccz401)
  END IF
 
 #處理 EXP
  SELECT SUM(cmi08) INTO l_cmi08 FROM cmi_file
   WHERE cmi01 = tm.yy AND cmi02 = tm.mm
     AND cmi05 = "EXP"
  IF cl_null(l_cmi08) THEN LET l_cmi08 = 0 END IF
  IF cl_null(l_exp_tot) THEN LET l_exp_tot = 0 END IF
  LET sr1.npq04 = "EXP"       #尾差
  IF p_npptype = '0' THEN
     LET sr1.npq03 = g_ccz.ccz21
  ELSE
     LET sr1.npq03 = g_ccz.ccz211
  END IF
  LET sr1.npq05 = "EXP"
  LET sr1.npq06 = '2'
  LET sr1.npq07f= l_cmi08
  LET sr1.npq07 = l_exp_tot
  OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
# 191-D.非拆件式工單結案轉出------------------------------------------------
#  針對 差異轉出金額(ccg42!=0) OR
#       (本月轉出數量(ccg31=0) AND 本月轉出金額(ccg32!=0))
#  借:工單結案在製轉出差異科目(ccz18) 部門使用 (ccz23)
#     貸:在製品 = SUM(ccg42)
 
   IF g_ccz.ccz09 = 'N' THEN
      LET g_sql =
          " SELECT sfb02,'','',SUM(ccg32+ccg42) FROM ccg_file,sfb_file ",
          "  WHERE ccg02 = ",tm.yy,
          "    AND ccg03 = ",tm.mm ,
          "    AND ccg01 = sfb_file.sfb01 ",
          "    AND sfb02 != '11' ",
          "    AND ((ccg32 != 0 AND ccg31 = 0) OR ccg42 != 0) ", #沒入庫
          "  GROUP BY sfb02 "
 
   ELSE
      IF g_ccz.ccz07 = '2' THEN
            LET g_sql= 
                " SELECT sfb02,imz39,imz391,SUM(ccg32+ccg42) ",
                       "   FROM ccg_file,sfb_file,ima_file,imz_file ",
                       "  WHERE ccg02 = ",tm.yy,
                       "    AND ccg03 = ",tm.mm,
                       "    AND ccg01 = sfb_file.sfb01 ",
                       "    AND sfb02 != '11' ",
                       "    AND ((ccg32 != 0 AND ccg31 = 0) OR ccg42 != 0) ", #沒入庫
                       "    AND sfb05 = ima01  ",
                       "    AND ima12 = imz01  ",
                       "  GROUP BY sfb02,imz39,imz391 "
      ELSE
            LET g_sql= 
                " SELECT sfb02,ima39,ima391,SUM(ccg32+ccg42) ",
                       "   FROM ccg_file,sfb_file,ima_file ",
                       "  WHERE ccg02 = ",tm.yy,
                       "    AND ccg03 = ",tm.mm,
                       "    AND ccg01 = sfb_file.sfb01 ",
                       "    AND sfb02 != '11' ",
                       "    AND ((ccg32 != 0 AND ccg31 = 0) OR ccg42 != 0) ", #沒入庫
                       "    AND sfb05 = ima01  ",
                       "  GROUP BY sfb02,ima39,ima391 "
      END IF
   END IF
 
   PREPARE ccg_prepare FROM g_sql
   DECLARE ccg_curs CURSOR WITH HOLD FOR ccg_prepare
 
   LET sr.ima39 = ' '
   LET sr.tlf21 = 0
   LET sr1.npq04 = ' '
   FOREACH ccg_curs INTO l_sfb02,sr.ima39,l_ima391,sr.tlf21    #No:MOD-980204 modify
       IF SQLCA.SQLCODE THEN
	  IF g_bgjob = 'N' THEN    #NO.FUN-570153 
              DISPLAY 'error diff'
          END IF
          EXIT FOREACH
       END IF
 
       IF g_bgjob = 'N' THEN    #NO.FUN-570153 
           DISPLAY l_sfb02,'工單結案轉出!! '
       END IF
       CASE l_sfb02
           WHEN '1' LET sr1.npq04 = g_x[39] CLIPPED   #'一般'
           WHEN '5' LET sr1.npq04 = g_x[40] CLIPPED   #'再加工'
           WHEN '8' LET sr1.npq04 = g_x[41] CLIPPED   #'委外重工'
           WHEN '7' LET sr1.npq04 = g_x[42] CLIPPED   #'委外'
           WHEN '13' LET sr1.npq04 = g_x[43] CLIPPED  #'預測性'
           WHEN '15' LET sr1.npq04 = g_x[44] CLIPPED  #'試產性'
       END CASE
 
       IF sr.tlf21 IS NULL THEN LET sr.tlf21 = 0 END IF
       IF sr.tlf21 = 0 THEN CONTINUE FOREACH END IF
       #借:工單結案在製轉出差異科目(ccz18) 部門使用 (ccz23)
       #貸:在製品 = SUM(ccg42)
 
       IF g_ccz.ccz09 = 'Y' THEN
          LET l_ccz18 = sr.ima39
          LET l_ccz181= l_ima391     #No:MOD-980204 add
       ELSE 
          LET l_ccz18 = g_ccz.ccz18
          LET l_ccz181= g_ccz.ccz181 #No:MOD-980204 add
       END IF
 
       IF sr.tlf21 < 0 THEN
         #MOD-B10079---modify---start---
         #IF p_npptype = '0' THEN
         #   LET sr1.npq03 = g_ccz.ccz17      #MOD-870078 mod ccz16->ccz17
         #   LET sr1.npq031= l_ccz18          #No.MOD-940173 add 
         #ELSE
         #   LET sr1.npq03 = g_ccz.ccz171     #MOD-870078 mod ccz161->ccz171
         #   LET sr1.npq031= l_ccz181     #MOD-870078 add   #No:MOD-980204 modify
         #END IF
          IF p_npptype = '0' THEN
             LET sr1.npq03 = l_ccz18 
             LET sr1.npq031= g_ccz.ccz17 
          ELSE
             LET sr1.npq03 = l_ccz181
             LET sr1.npq031= g_ccz.ccz171
          END IF
         #MOD-B10079---modify---end---
          LET sr1.npq04 = sr1.npq04 CLIPPED ,g_x[45] CLIPPED   #'在製工單結案轉出'
          LET sr1.npq06 = '1'
          LET sr1.npq07f= sr.tlf21 * -1
          LET sr1.npq07 = sr1.npq07f
          LET sr1.npq05 = g_ccz.ccz23     #MOD-870078 add
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
 
          LET l_msg = g_x[46] CLIPPED,g_x[47] CLIPPED   #"D.非拆件式在製工單結案轉出之在製品科目(ccz16)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
         #MOD-B10079---modify---start--- 
         #IF p_npptype = '0' THEN
         #   LET sr1.npq03 = l_ccz18          #No.MOD-940173 add
         #   LET sr1.npq031= g_ccz.ccz17      #MOD-870078 add
         #ELSE
         #   LET sr1.npq03 = l_ccz181         #No:MOD-980204 modify
         #   LET sr1.npq031= g_ccz.ccz171     #MOD-870078 add
         #END IF
          IF p_npptype = '0' THEN
             LET sr1.npq03 = g_ccz.ccz17 
             LET sr1.npq031= l_ccz18
          ELSE
             LET sr1.npq03 = g_ccz.ccz171 
             LET sr1.npq031= l_ccz181
          END IF
         #MOD-B10079---modify---end---
          LET sr1.npq05 = g_ccz.ccz23
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
          LET sr1.npq06 = '2'
          LET sr1.npq07f= sr.tlf21 * -1
          LET sr1.npq07 = sr1.npq07f
 
          LET l_msg = g_x[48] CLIPPED,g_x[49] CLIPPED    #"D.非拆件式在製工單結案轉出之差異科目(ccz18)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
       ELSE
          LET sr1.npq04 = sr1.npq04 CLIPPED,g_x[45] CLIPPED     #'在製工單結案轉出'
         #MOD-B10079---modify---start---
         #IF p_npptype = '0' THEN
         #   LET sr1.npq03 = l_ccz18        #No.MOD-940173 add
         #   LET sr1.npq031= g_ccz.ccz17      #MOD-870078 add
         #ELSE
         #   LET sr1.npq03 = l_ccz181         #No:MOD-980204 modify
         #   LET sr1.npq031= g_ccz.ccz171     #MOD-870078 add
         #END IF
          IF p_npptype = '0' THEN
             LET sr1.npq03 = g_ccz.ccz17 
             LET sr1.npq031= l_ccz18
          ELSE
             LET sr1.npq03 = g_ccz.ccz171
             LET sr1.npq031= l_ccz181
          END IF
         #MOD-B10079---modify---end---
          LET sr1.npq05 = g_ccz.ccz23
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
          LET sr1.npq06 = '1'
          LET sr1.npq07f= sr.tlf21
          LET sr1.npq07 = sr1.npq07f
 
          LET l_msg = g_x[48] CLIPPED,g_x[49] CLIPPED     #"D.非拆件式在製工單結案轉出之差異科目(ccz18)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
         #MOD-B10079---modify---start--- 
         #IF p_npptype = '0' THEN
         #   LET sr1.npq03 = g_ccz.ccz17      #MOD-870078 mod ccz16->ccz17
         #   LET sr1.npq031= l_ccz18          #No.MOD-940173 add 
         #ELSE
         #   LET sr1.npq03 = g_ccz.ccz171     #MOD-870078 mod ccz161->ccz171
         #   LET sr1.npq031= l_ccz181     #MOD-870078 add    #MOD-980204 modify
         #END IF
          IF p_npptype = '0' THEN
             LET sr1.npq03 = l_ccz18 
             LET sr1.npq031= g_ccz.ccz17
          ELSE
             LET sr1.npq03 = l_ccz181
             LET sr1.npq031= g_ccz.ccz171
          END IF
         #MOD-B10079---modify---end---
          LET sr1.npq06 = '2'
          LET sr1.npq05 = g_ccz.ccz23   #MOD-870078 add
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
          LET sr1.npq07f= sr.tlf21
          LET sr1.npq07 = sr1.npq07f
 
          LET l_msg = g_x[46] CLIPPED,g_x[47] CLIPPED     #"D.非拆件式在製工單結案轉出之在製品科目(ccz16)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
       END IF
   END FOREACH
 
 
# 191-E.拆件式工單結案轉出-----------------------------------------------------
#   針對 差異轉出金額(cct42!=0) OR
#         (本月轉出數量(cct31=0) AND 本月轉出金額(cct32!=0))
#   借:拆件式工結案轉出科目(ccz19)    部門使用 (ccz23)
#      貸:在製品 = SUM(cct42)
 
   LET g_sql =
       " SELECT sfb02,SUM(ccg42) FROM ccg_file,ima_file,sfb_file ",
       "  WHERE ccg02 = ",tm.yy,
       "    AND ccg03 = ",tm.mm ,
       "    AND ccg01 = sfb_file.sfb01 ",
       "    AND sfb02 = '11' ",
       "    AND ccg04 = ima_file.ima01 ",
       "    AND ccg42 != 0 ", #沒入庫
       "  GROUP BY sfb02 "
 
   PREPARE ccg1_prepare FROM g_sql
   DECLARE ccg1_curs CURSOR WITH HOLD FOR ccg1_prepare
 
   LET sr.ima39 = ' '
   LET sr.tlf21 = 0
   FOREACH ccg1_curs INTO l_sfb02,sr.tlf21
       IF SQLCA.SQLCODE THEN
          IF g_bgjob = 'N' THEN    #NO.FUN-570153 
              DISPLAY 'error diff'
          END IF
          EXIT FOREACH
       END IF
 
        IF g_bgjob = 'N' THEN    #NO.FUN-570153 
           DISPLAY l_sfb02,'工單結案轉出!! '
        END IF
        CASE l_sfb02
            WHEN '1'  LET sr1.npq04 =g_x[39] CLIPPED     #'一般'
            WHEN '5'  LET sr1.npq04 =g_x[40] CLIPPED     #'再加工'
            WHEN '7'  LET sr1.npq04 =g_x[41] CLIPPED     #'委外'
            WHEN '11' LET sr1.npq04 =g_x[80] CLIPPED     #'拆件性'   #No:MOD-B50101 modify
            WHEN '11' LET sr1.npq04 =g_x[42] CLIPPED     #'拆件性'
            WHEN '13' LET sr1.npq04 =g_x[43] CLIPPED     #'預測性'
            WHEN '15' LET sr1.npq04 =g_x[44] CLIPPED     #'試產性'
        END CASE
 
       IF sr.tlf21 IS NULL THEN LET sr.tlf21 = 0 END IF
       IF sr.tlf21 = 0 THEN CONTINUE FOREACH END IF
       IF sr.tlf21 < 0 THEN
          LET sr1.npq04 = sr1.npq04 CLIPPED ,g_x[45] CLIPPED  #'在製工單結案轉出'
         #----------------No:MOD-B50101 modify
         #IF p_npptype = '0' THEN
         #   LET sr1.npq03 = g_ccz.ccz17      #No.MOD-940173 add
         #   LET sr1.npq031= g_ccz.ccz19      #MOD-870078 add
         #ELSE
         #   LET sr1.npq03 = g_ccz.ccz171     #No.MOD-940173 add
         #   LET sr1.npq031= g_ccz.ccz191     #MOD-870078 add
         #END IF
          IF p_npptype = '0' THEN
             LET sr1.npq03 = g_ccz.ccz19      #MOD-870078 add
             LET sr1.npq031= g_ccz.ccz17      #No:MOD-940173 modify
          ELSE
             LET sr1.npq03 = g_ccz.ccz191     #MOD-870078 add
             LET sr1.npq031= g_ccz.ccz171     #No:MOD-940173 modify
          END IF
         #----------------No:MOD-B50101 end   
          LET sr1.npq06 = '1'
          LET sr1.npq07f= sr.tlf21 * -1
          LET sr1.npq07 = sr1.npq07f
          LET sr1.npq05 = g_ccz.ccz23   #MOD-870078 add
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
 
          LET l_msg = g_x[50] CLIPPED,g_x[51] CLIPPED     #"E.拆件式在製工單結案轉出之在製品科目(ccz16)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
         #----------------No:MOD-B50101 modify 
         #IF p_npptype = '0' THEN
         #   LET sr1.npq03 = g_ccz.ccz19
         #   LET sr1.npq031= g_ccz.ccz17      #No.MOD-940173 add
         #ELSE
         #   LET sr1.npq03 = g_ccz.ccz191
         #   LET sr1.npq031= g_ccz.ccz171     #No.MOD-940173 add
         #END IF
          IF p_npptype = '0' THEN
             LET sr1.npq03 = g_ccz.ccz17      #No:MOD-940173 add   
             LET sr1.npq031= g_ccz.ccz19
          ELSE
             LET sr1.npq03 = g_ccz.ccz171     #No:MOD-940173 add   
             LET sr1.npq031= g_ccz.ccz191
          END IF
         #----------------No:MOD-B50101 add 
          LET sr1.npq05 = g_ccz.ccz23
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
          LET sr1.npq06 = '2'
          LET sr1.npq07f= sr.tlf21 * -1
          LET sr1.npq07 = sr1.npq07f
 
          LET l_msg = g_x[52] CLIPPED    #"E.拆件式在製工單結案轉出之差異科目(ccz19)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
       ELSE
          LET sr1.npq04 = sr1.npq04 CLIPPED ,g_x[45] CLIPPED  #'在製工單結案轉出'
         #----------------No:MOD-B50101 modify
         #IF p_npptype = '0' THEN
         #   LET sr1.npq03 = g_ccz.ccz19
         #   LET sr1.npq031= g_ccz.ccz17      #No.MOD-940173 add
         #ELSE
         #   LET sr1.npq03 = g_ccz.ccz191
         #   LET sr1.npq031= g_ccz.ccz171     #No.MOD-940173 add
         #END IF
          IF p_npptype = '0' THEN
             LET sr1.npq03 = g_ccz.ccz17      #No:MOD-940173 add   
             LET sr1.npq031= g_ccz.ccz19
          ELSE
             LET sr1.npq03 = g_ccz.ccz171     #No:MOD-940173 add   
             LET sr1.npq031= g_ccz.ccz191
          END IF
         #----------------No:MOD-B50101 end   
          LET sr1.npq05 = g_ccz.ccz23
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
          LET sr1.npq06 = '1'
          LET sr1.npq07f= sr.tlf21
          LET sr1.npq07 = sr1.npq07f
 
          LET l_msg = g_x[52] CLIPPED  #"E.拆件式在製工單結案轉出之差異科目(ccz19)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
         #----------------No:MOD-B50101 modify 
         #IF p_npptype = '0' THEN
         #   LET sr1.npq03 = g_ccz.ccz17      #No.MOD-940173 add
         #   LET sr1.npq031= g_ccz.ccz19      #MOD-870078 add
         #ELSE
         #   LET sr1.npq03 = g_ccz.ccz171     #No.MOD-940173 add
         #   LET sr1.npq031= g_ccz.ccz191     #MOD-870078 add
         #END IF
          IF p_npptype = '0' THEN
             LET sr1.npq03 = g_ccz.ccz19      #MOD-870078 add
             LET sr1.npq031= g_ccz.ccz17      #No:MOD-940173 add   
          ELSE
             LET sr1.npq03 = g_ccz.ccz191     #MOD-870078 add
             LET sr1.npq031= g_ccz.ccz171     #No:MOD-940173 add   
          END IF
         #----------------No:MOD-B50101 modify
          LET sr1.npq06 = '2'
          LET sr1.npq07f= sr.tlf21
          LET sr1.npq07 = sr1.npq07f
          LET sr1.npq05 = g_ccz.ccz23   #MOD-870078 add
          LET sr1.npq05 =  p191_chk_aag05(sr1.npq03,sr1.npq05)
 
          LET l_msg = g_x[50] CLIPPED,g_x[51] CLIPPED     #"E.拆件式在製工單結案轉出之在製品科目(ccz16)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
       END IF
   END FOREACH
 
# 191-F.成本計算尾差轉銷貨成本-------------------------------------------
#  針對 ccc93 != 0  做處理
#       BY 料件的成本分群做 group sum
#  借:成本計算尾差(azf05)  = SUM(ccc93)  部門使用 (ccz23)
#       貸: 看 ccz07 存貨科目是從哪邊取得
            #依存貨科目參數(ccz07)判斷--------------------------
            #(1)取自料件主檔   ima39
            #(2)取自料件分群檔 imz39
            #(3)取自倉庫檔     imd08  --> 用(1)的計算方式
            #(4)取自倉庫儲位檔 ime09  --> 用(1)的計算方式
 
   IF g_ccz.ccz07 = '2' THEN
      IF p_npptype = '0' THEN
         LET g_sql= " SELECT ima12,imz39,sum(ccc93) ",
                    "   FROM ccc_file,ima_file,imz_file ",
                    "  WHERE ccc02 = ",tm.yy,
                    "    AND ccc03 = ",tm.mm,
                    "    AND ccc01 = ima01 AND ccc93 != 0 ",
                    "    AND ima12 = imz_file.imz01  ",     #No:CHI-9B0024 modify ima06->ima12
                    "  GROUP BY ima12,imz39 "
      ELSE
         LET g_sql= " SELECT ima12,imz391,sum(ccc93) ",
                    "   FROM ccc_file,ima_file,imz_file ",
                    "  WHERE ccc02 = ",tm.yy,
                    "    AND ccc03 = ",tm.mm,
                    "    AND ccc01 = ima01 AND ccc93 != 0 ",
                    "    AND ima12 = imz_file.imz01  ",     #No:CHI-9B0024 modify ima06->ima12
                    "  GROUP BY ima12,imz391 "
      END IF
   ELSE
      IF p_npptype = '0' THEN
         LET g_sql= " SELECT ima12,ima39,sum(ccc93) ",
                    "   FROM ccc_file,ima_file ",
                    "  WHERE ccc02 = ",tm.yy,
                    "    AND ccc03 = ",tm.mm,
                    "    AND ccc01 = ima01 AND ccc93 != 0 ",
                    "  GROUP BY ima12,ima39 "
      ELSE
         LET g_sql= " SELECT ima12,ima391,sum(ccc93) ",
                    "   FROM ccc_file,ima_file ",
                    "  WHERE ccc02 = ",tm.yy,
                    "    AND ccc03 = ",tm.mm,
                    "    AND ccc01 = ima01 AND ccc93 != 0 ",
                    "  GROUP BY ima12,ima391 "
      END IF
   END IF
 
   PREPARE ccc_prepare FROM g_sql
   DECLARE ccc_curs CURSOR WITH HOLD FOR ccc_prepare
 
   LET sr.ima39=' '
   LET sr.tlf21 = 0
   FOREACH ccc_curs INTO l_ima12,l_ima39,sr.tlf21
       IF SQLCA.SQLCODE THEN
          IF g_bgjob = 'N' THEN    #NO.FUN-570153 
              DISPLAY 'error diff'
          END IF
          EXIT FOREACH
       END IF
 
       IF p_npptype = '0' THEN
          SELECT azf05 INTO l_azf05 FROM azf_file
           WHERE azf01 = l_ima12
             AND azf02 = 'G'
       ELSE
          SELECT azf051 INTO l_azf05 FROM azf_file
           WHERE azf01 = l_ima12
             AND azf02 = 'G'
       END IF
 
       IF g_bgjob = 'N' THEN    #NO.FUN-570153 
          DISPLAY '成本計算尾差轉銷貨成本!! '
       END IF
       IF sr.tlf21 IS NULL THEN LET sr.tlf21 = 0 END IF
       IF sr.tlf21 = 0 THEN CONTINUE FOREACH END IF
       IF sr.tlf21 > 0 THEN
          LET sr1.npq04 = '+',g_x[53] CLIPPED     #'成本計算尾差轉銷貨成本'
          LET sr1.npq03 = l_ima39
          LET sr1.npq031= l_azf05       #MOD-870078 add
          LET sr1.npq06 = '1'
          LET sr1.npq07f= sr.tlf21
          LET sr1.npq07 = sr1.npq07f
          LET sr1.npq05 = g_ccz.ccz23
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
 
          LET l_msg = g_x[54] CLIPPED,'-',l_azf05 CLIPPED      #"F.成本計算尾差之銷貨成本科目(azf05)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119 
          LET sr1.npq03 = l_azf05
          LET sr1.npq031= l_ima39      
          LET sr1.npq05 = g_ccz.ccz23                          #MOD-C50163 add
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
          LET sr1.npq06 = '2'
          LET sr1.npq07f= sr.tlf21
          LET sr1.npq07 = sr1.npq07f
 
          LET l_msg = g_x[55] CLIPPED,'-',l_ima39 CLIPPED  #"F.成本計算尾差之存貨科目(ima39)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
       ELSE
          LET sr1.npq04 = '-',g_x[53] CLIPPED     #'成本計算尾差轉銷貨成本'
          LET sr1.npq03 = l_azf05
          LET sr1.npq031= l_ima39      
          LET sr1.npq06 = '1'
          LET sr1.npq07f= sr.tlf21 * -1
          LET sr1.npq07 = sr1.npq07f
          LET l_msg = g_x[55] CLIPPED,'-',l_ima39 CLIPPED  #"F.成本計算尾差之存貨科目(ima39)"
          LET sr1.npq05 = g_ccz.ccz23
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119 
          LET sr1.npq03 = l_ima39
          LET sr1.npq031= l_azf05      
          LET sr1.npq05 = g_ccz.ccz23
          LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
          LET sr1.npq06 = '2'
          LET sr1.npq07f= sr.tlf21 * -1
          LET sr1.npq07 = sr1.npq07f
 
          LET l_msg = g_x[54] CLIPPED,'-',l_azf05 CLIPPED #"F.成本計算尾差之銷貨成本科目(azf05)"
          OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
 
          #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
          INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                        VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
       END IF
   END FOREACH
 
##FUN-8B0047 處理閒置製費轉銷貨成本
#    借:銷貨成本(ccz29)
#       貸:加工費(ccz15)
#    資料來源.cdc_file
 
 
   IF g_bgjob = 'N' THEN    #NO.FUN-570153 
       DISPLAY 'Idle Overhead!'
   END IF
   LET amt = 0
   LET amt2 = 0
   LET l_apb26=''
   LET l_apa22=''
 
   DECLARE cdc_curs CURSOR WITH HOLD FOR
    SELECT SUM(cdc05),cdc03 INTO amt,l_apb26
    FROM cdc_file
      WHERE cdc041='OH-FIXED'
        AND cdc01=tm.yy
        AND cdc02=tm.mm
      GROUP BY cdc03
 
   FOREACH cdc_curs INTO amt,l_apb26
     IF amt  IS NULL THEN LET amt =0 END IF
     #借
      IF p_npptype = '0' THEN
         LET sr1.npq03 = g_ccz.ccz29 
         LET sr1.npq031= g_ccz.ccz15     #MOD-870078 add
      ELSE
         LET sr1.npq03 = g_ccz.ccz291    #No.FUN-680086
         LET sr1.npq031= g_ccz.ccz151    #MOD-870078 add
      END IF
      LET l_msg=cl_getmsg('axc-040',g_lang)
      LET sr1.npq04 = l_msg CLIPPED    #'閒置製費
      LET sr1.npq05 = l_apb26
      LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
      LET sr1.npq06 = '1'
      LET sr1.npq07f= amt
      LET sr1.npq07 = amt
      OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
      #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
      INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                    VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119 
     #貸
      IF p_npptype = '0' THEN
         LET sr1.npq03 = g_ccz.ccz15
         LET sr1.npq031= g_ccz.ccz29     #MOD-870078 add
      ELSE
         LET sr1.npq03 = g_ccz.ccz151    #No.FUN-680086
         LET sr1.npq031= g_ccz.ccz291    #MOD-870078 add
      END IF
      LET sr1.npq04 = l_msg CLIPPED    #'閒置製費
      LET sr1.npq05= l_apb26
      LET sr1.npq05 =p191_chk_aag05(sr1.npq03,sr1.npq05)
      LET sr1.npq06 ='2'
      LET sr1.npq07f=amt
      LET sr1.npq07 =amt
      OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
      #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
      INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                    VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
   END FOREACH
#FUN-C70119---begin
#  #處理尾差
#   DECLARE p191_tmpcs2 CURSOR FOR
#     SELECT '',npq03,npq04,npq05,npq06,sum(npq07f),sum(npq07),npq031
#       FROM p191_tmp
#      GROUP BY npq06,npq04,npq03,npq05,npq031
#      ORDER BY npq04,npq06,npq03,npq05,npq031
# 
#   INITIALIZE sr1.* TO NULL
#   LET g_gl = 'N'
# 
#   FOREACH p191_tmpcs2 INTO sr1.*
#      CALL cl_digcut(sr1.npq07f,g_azi04) RETURNING g_npq.npq07f
#      CALL cl_digcut(sr1.npq07 ,g_azi04) RETURNING g_npq.npq07
#      LET sr1.npq07f = g_npq.npq07f
#      LET sr1.npq07  = g_npq.npq07
#     #070716 TSC.Jana(S)---金額是0的就不新增至分錄
#      IF sr1.npq07 = 0 THEN
#         CONTINUE FOREACH
#      END IF
#     #070716 TSC.Jana(E)---金額是0的就不新增至分錄
#      INSERT INTO p191_tmp2 VALUES(sr1.*)
#   END FOREACH
#FUN-C70119---end 
   #FUN-C70119---begin
   #DECLARE p191_tmpcs CURSOR FOR
   #  SELECT '',npq03,npq04,npq05,npq06,sum(npq07f),sum(npq07)
   #    FROM p191_tmp
   #   GROUP BY npq06,npq04,npq03,npq05
   #   ORDER BY npq04,npq06,npq03,npq05
   #FUN-C70119---end
   #FUN-C70119---begin
   DECLARE p191_tmpcs CURSOR FOR
     SELECT '',cdn03,cdn04,cdn05,cdn06,SUM(cdn07f),SUM(cdn07),''
       FROM cdn_file
      WHERE cdn01 = tm.yy
        AND cdn02 = tm.mm
      GROUP BY cdn06,cdn04,cdn03,cdn05
      ORDER BY cdn04,cdn06,cdn03,cdn05   
   #FUN-C70119---end
   INITIALIZE sr1.* TO NULL
   LET g_gl = 'N'
 
   FOREACH p191_tmpcs INTO sr1.*
      IF STATUS THEN
        CALL cl_err('foreach temp table',STATUS,1)   
         EXIT FOREACH
      END IF
      CALL cl_digcut(sr1.npq07f,g_azi04) RETURNING g_npq.npq07f 
      CALL cl_digcut(sr1.npq07 ,g_azi04) RETURNING g_npq.npq07
      IF g_npq.npq07f = 0 OR g_npq.npq07 = 0 THEN
         CONTINUE FOREACH
      END IF
      LET g_gl = 'Y'   #判斷有無產生成本分錄資料
      LET g_npq.npq02=g_npq.npq02+1
      LET g_npq.npq03=sr1.npq03   #科目
      LET g_npq.npq04=sr1.npq04   #摘要
      LET g_npq.npq05=sr1.npq05   #部門
      LET g_npq.npq06  = sr1.npq06 #借/貸
      LET g_npq.npq08  = ' '  LET g_npq.npq11  =''   #MOD-9A0005
      LET g_npq.npq12  =''    LET g_npq.npq13  =''   #MOD-9A0005
      LET g_npq.npq14  =''    LET g_npq.npq15  =' '
      LET g_npq.npq21  =' '    LET g_npq.npq22  =' '
      LET g_npq.npq23  = NULL
      LET g_npq.npq24  =g_aza.aza17
      LET g_npq.npq25  = 1
      LET g_npq.npq30  = g_plant
      LET g_npq.npqlegal = g_legal  #FUN-980009 add
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES(g_npq.*)
      IF STATUS THEN
         LET l_msg = 'INSERT npq_file Fail..'
         OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
         IF g_bgjob = 'N' THEN    #NO.FUN-570153 
             DISPLAY 'INSERT npq_file Fail..'
         END IF
      END IF
   END FOREACH
 
  #處理整張分錄的尾差
   #借方金額
   SELECT sum(npq07f),sum(npq07) INTO l_npq07f_d,l_npq07_d FROM npq_file
    WHERE npqsys= 'CA'
      AND npq00 = 1
      AND npq01 = tm.v_no
      AND npq011= 1
      AND npq06 = 1
  
   #貸方金額
   SELECT sum(npq07f),sum(npq07) INTO l_npq07f_c,l_npq07_c FROM npq_file
    WHERE npqsys= 'CA'
      AND npq00 = 1
      AND npq01 = tm.v_no
      AND npq011= 1
      AND npq06 = 2
  
   LET l_diff_f = l_npq07f_d - l_npq07f_c
   LET l_diff   = l_npq07_d - l_npq07_c
   
   IF l_diff != 0 THEN
      #借-貸 > 0 將尾差科目產生在貸方 , < 0 則產生在借方
      IF l_diff > 0 THEN
         LET g_npq.npq06 = '2'
      ELSE
         LET l_diff_f = l_diff_f * -1
         LET l_diff   = l_diff   * -1
         LET g_npq.npq06 = '1'
      END IF
      LET g_npq.npq02=g_npq.npq02+1
      LET g_npq.npq03=g_ccz.ccz22           #科目
      LET g_npq.npq04='其他分攤尾差'        #摘要
      LET g_npq.npq05=g_ccz.ccz23           #部門
      CALL cl_digcut(l_diff_f,g_azi04) RETURNING g_npq.npq07f
      CALL cl_digcut(l_diff,g_azi04) RETURNING g_npq.npq07
      LET g_npq.npq08  =' '   LET g_npq.npq11  =''   #MOD-9A0005
      LET g_npq.npq12  =''    LET g_npq.npq13  =''   #MOD-9A0005
      LET g_npq.npq14  =''    LET g_npq.npq15  =' '  #MOD-9A0005
      LET g_npq.npq21  =' '    LET g_npq.npq22  =' '
      LET g_npq.npq23  = NULL
      LET g_npq.npq24  = g_aza.aza17
      LET g_npq.npq25  = 1
      LET g_npq.npq30  = g_plant
      LET g_npq.npqlegal = g_legal  #FUN-980009 add
      #FUN-D40118--add--str--
      SELECT aag44 INTO g_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
      #FUN-D40118--add--end--
      INSERT INTO npq_file VALUES(g_npq.*)
      IF STATUS THEN
         LET l_msg = 'INSERT npq_file Fail..'
         OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)
         IF g_bgjob = 'N' THEN
            DISPLAY 'INSERT npq_file Fail..'
         END IF
      END IF
   END IF
    
  FINISH REPORT axcp191_rep
   CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021
  IF g_bgjob = 'N' THEN 
     DISPLAY ' '
  END IF 
 
 
  IF g_success = 'N' AND g_bgjob = 'N' THEN
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
  END IF
END FUNCTION
 
FUNCTION p191_cmi04(sr1,p_ccz15,p_ccz151,p_cmi08,p_cmi06,p_npptype1,p_cmi04)
  DEFINE sr1  RECORD
         tlf905          LIKE tlf_file.tlf905,   #單號
         npq03           LIKE npq_file.npq03,    #科目
         npq04           LIKE npq_file.npq04,    #摘要
         npq05           LIKE npq_file.npq05,    #部門
         npq06           LIKE npq_file.npq06,    #借貸(1/2)
         npq07f          LIKE npq_file.npq07f,   #原幣金額
         npq07           LIKE npq_file.npq07,    #本幣金額
         npq031          LIKE npq_file.npq03     #對方科目   #MOD-870078 add
         END RECORD
  DEFINE p_cmi08         LIKE cmi_file.cmi08
  DEFINE p_cmi06         LIKE cmi_file.cmi06
  DEFINE p_cmi04         LIKE cmi_file.cmi04
  DEFINE p_npptype1      LIKE npp_file.npptype
  DEFINE l_msg           STRING
  DEFINE p_ccz15         LIKE ccz_file.ccz15
  DEFINE p_ccz151        LIKE ccz_file.ccz151

           #借:在製品(ccz17)
              #貸:製費(ccz15) = l_cmi08
           IF p_cmi04 = '2' THEN
              LET sr1.npq04 = g_x[30] CLIPPED     #'製費一投入在製'
           END IF
           IF p_cmi04 = '3' THEN
              LET sr1.npq04 = g_x[72] CLIPPED     #'製費二投入在製'
           END IF
           IF p_cmi04 = '4' THEN
              LET sr1.npq04 = g_x[73] CLIPPED     #'製費三投入在製'
           END IF
           IF p_cmi04 = '5' THEN
              LET sr1.npq04 = g_x[74] CLIPPED     #'製費四投入在製'
           END IF
           IF p_cmi04 = '6' THEN
              LET sr1.npq04 = g_x[75] CLIPPED     #'製費五投入在製'
           END IF
           IF p_npptype1 = '0' THEN
              LET sr1.npq03 = g_ccz.ccz17
              LET sr1.npq031= p_ccz15
           ELSE
              LET sr1.npq03 = g_ccz.ccz171
              LET sr1.npq031= p_ccz151
           END IF
           LET sr1.npq06 = '1'
           LET sr1.npq07f= p_cmi08
           LET sr1.npq07 = p_cmi08
           LET sr1.npq05 = NULL
           LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)

           LET l_msg = g_x[31] CLIPPED         #"C.製費處理之在製品科目(ccz17)"
           OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)

           #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
           INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                         VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
           IF p_npptype1 = '0' THEN
              LET sr1.npq03 = p_ccz15
              LET sr1.npq031= g_ccz.ccz17 
           ELSE
              LET sr1.npq03 = p_ccz151
              LET sr1.npq031= g_ccz.ccz171 
           END IF
           LET sr1.npq06 = '2'
           LET sr1.npq07f= p_cmi08
           LET sr1.npq07 = p_cmi08
           LET sr1.npq05 = p_cmi06
           LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)

           LET l_msg = g_x[32] CLIPPED      #"C.製費處理之製費科目(ccz15)"
           OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)

           #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
           INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                         VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
END FUNCTION

FUNCTION p191_cmi04_a(sr1,p_type,p_npptype1,p_ccz21,p_ccz211)
  DEFINE sr1  RECORD
         tlf905          LIKE tlf_file.tlf905,   #單號
         npq03           LIKE npq_file.npq03,    #科目
         npq04           LIKE npq_file.npq04,    #摘要
         npq05           LIKE npq_file.npq05,    #部門
         npq06           LIKE npq_file.npq06,    #借貸(1/2)
         npq07f          LIKE npq_file.npq07f,   #原幣金額
         npq07           LIKE npq_file.npq07,    #本幣金額
         npq031          LIKE npq_file.npq03     #對方科目   #MOD-870078 add
         END RECORD
  DEFINE p_type          LIKE type_file.chr1
  DEFINE p_npptype1      LIKE npp_file.npptype   
  DEFINE p_ccz21         LIKE ccz_file.ccz21
  DEFINE p_ccz211        LIKE ccz_file.ccz211
  DEFINE l_cch22c        LIKE cch_file.cch22c
  DEFINE l_cch22e        LIKE cch_file.cch22e    #MOD-A80002 add
  DEFINE l_cch22f        LIKE cch_file.cch22f    #MOD-A80002 add
  DEFINE l_cch22g        LIKE cch_file.cch22g    #MOD-A80002 add
  DEFINE l_cch22h        LIKE cch_file.cch22h    #MOD-A80002 add
  DEFINE l_cmi04         LIKE cmi_file.cmi04
  DEFINE l_cmi06         LIKE cmi_file.cmi06
  DEFINE l_cmi08         LIKE cmi_file.cmi08
  DEFINE l_amt           LIKE tlf_file.tlf21
  DEFINE l_msg           STRING

     #製費(尾差分攤部門(ccz23)兩個都用這各部門)
    #MOD-A80002---modify---start---
    #SELECT SUM(cch22c) INTO l_cch22c FROM cch_file
     SELECT SUM(cch22c),SUM(cch22e),SUM(cch22f),SUM(cch22g),SUM(cch22h) INTO l_cch22c,l_cch22e,l_cch22f,l_cch22g,l_cch22h 
       FROM cch_file
    #MOD-A80002---modify---end---
      WHERE cch02 = tm.yy  AND cch03= tm.mm
        AND cch04 = ' DL+OH+SUB'

     DECLARE ccz2_curs CURSOR WITH HOLD FOR
       SELECT SUM(cmi08)  FROM cmi_file
         WHERE cmi01 = tm.yy AND cmi02 = tm.mm AND cmi04=p_type

     LET l_amt=0
     LET l_cmi04=''
     LET l_cmi06=''
     LET l_cmi08=0
     FOREACH ccz2_curs INTO l_cmi08
        #借:製費分攤尾差科目:(ccz21)
        #貸:在製 = l_amt = (GROUP SUM(cmi08) where cmi04='2')  -l_cch22c
       #MOD-A80002---modify---start---
       #LET l_amt =l_cmi08 - l_cch22c
        IF p_type='2' THEN LET l_amt=l_cmi08 - l_cch22c END IF
        IF p_type='3' THEN LET l_amt=l_cmi08 - l_cch22e END IF
        IF p_type='4' THEN LET l_amt=l_cmi08 - l_cch22f END IF
        IF p_type='5' THEN LET l_amt=l_cmi08 - l_cch22g END IF
        IF p_type='6' THEN LET l_amt=l_cmi08 - l_cch22h END IF
       #MOD-A80002---modify---end---
        IF l_amt > 0 THEN
            #借:製費分攤尾差科目:(ccz21)
            #   貸:在製 = l_amt
         
            IF p_type = '2' THEN
               LET sr1.npq04 = g_x[37] CLIPPED     #'製造費用一少分攤'
            END IF
            IF p_type = '3' THEN
               LET sr1.npq04 = g_x[76] CLIPPED     #'製造費用二少分攤'
            END IF
            IF p_type = '4' THEN
               LET sr1.npq04 = g_x[77] CLIPPED     #'製造費用三少分攤'
            END IF
            IF p_type = '5' THEN
               LET sr1.npq04 = g_x[78] CLIPPED     #'製造費用四少分攤'
            END IF
            IF p_type = '6' THEN
               LET sr1.npq04 = g_x[79] CLIPPED     #'製造費用五少分攤'
            END IF
            IF p_npptype1 = '0' THEN
               LET sr1.npq03 = p_ccz21
               LET sr1.npq031= g_ccz.ccz17
            ELSE
               LET sr1.npq03 = p_ccz211
               LET sr1.npq031= g_ccz.ccz171
            END IF
            LET sr1.npq05 = g_ccz.ccz23
            LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
            LET sr1.npq06 = '1'
            LET sr1.npq07f= l_amt
            LET sr1.npq07 = l_amt

            LET l_msg = g_x[38] CLIPPED       #"C.製費處理之分攤尾差科目(ccz21)"
            OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)

            #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
            INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                          VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
            IF p_npptype1 = '0' THEN
               LET sr1.npq03 = g_ccz.ccz17
               LET sr1.npq031= p_ccz21
            ELSE
               LET sr1.npq03 = g_ccz.ccz171
               LET sr1.npq031= p_ccz211
            END IF
            LET sr1.npq05 = g_ccz.ccz23
            LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
            LET sr1.npq06 = '2'
            LET sr1.npq07f= l_amt
            LET sr1.npq07 = l_amt

            LET l_msg = g_x[35] CLIPPED     #"C.製費處理之分攤尾差在製科目(ccz16)"
            OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)

            #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
            INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                          VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
        ELSE
            #借:在製 = l_amt (ccz16)
            #貸:製費分攤尾差科目:(ccz21)
            LET sr1.npq04 = '製造費用多分攤'
            IF p_npptype1 = '0' THEN
               LET sr1.npq03 = p_ccz21
               LET sr1.npq031= g_ccz.ccz17 
            ELSE
               LET sr1.npq03 = p_ccz211
               LET sr1.npq031= g_ccz.ccz171 
            END IF
            LET sr1.npq05 = g_ccz.ccz23
            LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
            LET sr1.npq06 = '2'
            LET sr1.npq07f= l_amt * -1
            LET sr1.npq07 = l_amt * -1

            LET l_msg = g_x[38] CLIPPED     #"C.製費處理之分攤尾差科目(ccz21)"
            OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)

            #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
            INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                          VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
            IF p_npptype1 = '0' THEN
               LET sr1.npq03 = g_ccz.ccz17 
               LET sr1.npq031= p_ccz21
            ELSE
               LET sr1.npq03 = g_ccz.ccz171 
               LET sr1.npq031= p_ccz211
            END IF
            LET sr1.npq05 = g_ccz.ccz23
            LET sr1.npq05 = p191_chk_aag05(sr1.npq03,sr1.npq05)
            LET sr1.npq06 = '1'
            LET sr1.npq07f= l_amt * -1
            LET sr1.npq07 = l_amt * -1

            LET l_msg = g_x[35] CLIPPED     #"C.製費處理之分攤尾差在製科目(ccz16)"
            OUTPUT TO REPORT axcp191_rep(sr1.*,l_msg)

            #INSERT INTO p191_tmp VALUES(sr1.*)  #FUN-C70119
            INSERT INTO cdn_file(cdn01,cdn02,cdn03,cdn031,cdn04,cdn05,cdn06,cdn07,cdn07f,cdn08)  #FUN-C70119
                          VALUES(tm.yy,tm.mm,sr1.npq03,sr1.npq031,sr1.npq04,sr1.npq05,sr1.npq06,sr1.npq07,sr1.npq07f,sr1.tlf905)  #FUN-C70119
        END IF
     END FOREACH
END FUNCTION

REPORT axcp191_rep(sr,l_msg)
   DEFINE l_last_sw    LIKE type_file.chr1,     #No.FUN-680122 VARCHAR(1) ,
          l_aag05      LIKE aag_file.aag05,
          l_msg        STRING
   DEFINE sr   RECORD
          tlf905  LIKE tlf_file.tlf905, #單號
          npq03   LIKE npq_file.npq03,   #科目
          npq04   LIKE npq_file.npq04,   #摘要
          npq05   LIKE npq_file.npq05,   #部門
          npq06   LIKE npq_file.npq06,   #借貸(1/2)
          npq07f  LIKE npq_file.npq07f,  #原幣金額
          npq07   LIKE npq_file.npq07,   #本幣金額
          npq031  LIKE npq_file.npq03    #對方科目   #MOD-870078 add
          END RECORD
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER EXTERNAL BY sr.npq06,sr.npq04,sr.npq03,sr.npq05
 
  FORMAT
 
  PAGE HEADER
     PRINT (g_len-FGL_WIDTH(g_x[1]))/2 SPACES,g_x[1] CLIPPED
     IF g_towhom IS NULL OR g_towhom = ' ' THEN
        PRINT '';
     ELSE
        PRINT 'TO:',g_towhom;
     END IF
 
     PRINT COLUMN (g_len-FGL_WIDTH(g_user)-5),'FROM:',g_user CLIPPED
     PRINT g_dash
 
  ON EVERY ROW
     IF cl_null(sr.npq03) THEN
        LET sr.npq03=' '
 
        PRINT  g_x[68] CLIPPED,sr.tlf905,
               g_x[69] CLIPPED,sr.npq03,
               g_x[70] CLIPPED,sr.npq05,
               g_x[71] CLIPPED,sr.npq04,
               COLUMN 100,l_msg CLIPPED
     END IF
 
     IF sr.npq05 = 'cxc001' THEN
        LET l_msg = g_x[57] CLIPPED,g_x[58] CLIPPED    #'理由碼-部門無對方科目,無法產生成本分錄!(cxc001) '
        PRINT  g_x[56] CLIPPED
        PRINT  g_x[68] CLIPPED,sr.tlf905,
               g_x[69] CLIPPED,sr.npq03,
               g_x[70] CLIPPED,sr.npq05,
               g_x[71] CLIPPED,sr.npq04,
               COLUMN 100,l_msg CLIPPED
        PRINT ''
     END IF
 
     IF sr.npq05 = 'cxc002' THEN
        LET l_msg = g_x[59] CLIPPED,g_x[60] CLIPPED    #'理由碼-部門無對方科目,無法產生成本分錄!(cxc001) '
        PRINT  g_x[56] CLIPPED
        PRINT  g_x[68] CLIPPED,sr.tlf905,
               g_x[69] CLIPPED,sr.npq03,
               g_x[70] CLIPPED,sr.npq05,
               g_x[71] CLIPPED,sr.npq04,
               COLUMN 100,l_msg CLIPPED
        PRINT ''
     END IF
     IF sr.npq05 = 'cxc003' THEN
        LET l_msg = g_x[56] CLIPPED,sr.tlf905 CLIPPED,'   ',
                    g_x[61] CLIPPED,g_x[62] CLIPPED    #此訂單未輸入部門，無法產生成本分錄!(cxc003)'
        PRINT l_msg CLIPPED
        PRINT ''
     END IF
     IF sr.npq05 = 'EXP' THEN
        LET l_msg = g_x[65] CLIPPED,sr.npq07f,'    ',g_x[66] CLIPPED,sr.npq07
        PRINT  g_x[68] CLIPPED,sr.tlf905,
               g_x[69] CLIPPED,sr.npq03,
               g_x[70] CLIPPED,sr.npq05,
               g_x[71] CLIPPED,sr.npq04,
               COLUMN 100,l_msg CLIPPED
        LET l_msg = g_x[67] CLIPPED,sr.npq07 - sr.npq07f
        PRINT  COLUMN 100,l_msg CLIPPED
        PRINT ''
     END  IF
 
  PAGE TRAILER
      IF g_ccz.ccz10=1 OR cl_null(g_ccz.ccz10) THEN
         PRINT g_x[63] CLIPPED,g_x[64] CLIPPED    #"人工/製費由人工輸入,所以不自動產生傳票,不處理人工製費"
      ELSE
         PRINT " "
      END IF
      PRINT g_dash[1,g_len]
END REPORT
 
FUNCTION p191_chk_aag05(l_npq03,l_npq05)
    DEFINE l_npq05 LIKE npq_file.npq05
    DEFINE l_aag05 LIKE aag_file.aag05
    DEFINE l_npq03 LIKE npq_file.npq03
 
     LET l_aag05 = ''
     SELECT aag05 INTO l_aag05 FROM aag_file
      WHERE aag01 = l_npq03
        AND aag00 = g_bookno    #No.FUN-730057
     IF cl_null(l_aag05) THEN LET l_aag05 = NULL END IF
     IF l_aag05 = 'N' THEN
       LET l_npq05=NULL
     END IF
 
     RETURN l_npq05
END FUNCTION
 
FUNCTION p191_get_ima12(l_ima12)
 DEFINE l_ima12 LIKE ima_file.ima12
 DEFINE l_azf03 LIKE azf_file.azf03
 
    SELECT azf03 INTO l_azf03 FROM azf_file
     WHERE azf01 = l_ima12 AND azf02 = 'G'
 
    RETURN l_azf03
 
END FUNCTION
 
FUNCTION p191_get_test(l_npq03)
 DEFINE l_npq03 LIKE npq_file.npq03
 
 
END FUNCTION
#No.FUN-9C0073 ---------------By chenls  10/01/11 

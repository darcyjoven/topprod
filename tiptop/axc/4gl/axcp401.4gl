# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axcp401.4gl
# Descriptions...: 工單結案自動設定作業
# Input parameter: 
# Return code....: 
# Date & Author..: 96/01/30 By Roger
# Modify.........: No.FUN-4C0099 05/01/10 By kim 報表轉XML功能
# Modify.........: No.MOD-540065 05/04/27 By kim 工單自動結案預設為 N
# Modify.........: No.FUN-560172 05/06/21 By day 單據編號修改        
# Modify.........: No.FUN-560238 05/07/28 By elva 成會期間由按月份改成按期別抓
# Modify.........: No.FUN-570117 06/03/14 By yiting 批次作業修改
# Modify.........: No.TQC-650050 06/05/12 By kim 報表沒有表尾結束線
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-680122 06/08/30 By zdyllq 類型轉換
# Modify.........: No.FUN-650116 06/10/13 By Sarah 檢查是否有未過完帳的單據,若有則產出報表,不予結案
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.MOD-810202 08/03/23 By Pengu 工單在判斷是否有未過帳相關單據時應排除作廢單據
# Modify.........: No.MOD-830236 08/04/19 By Pengu 若遇到有未過帳的單據時應是show報表告知但不應整個rollback work
# Modify.........: No.MOD-840472 08/04/25 By Sarah 工單3月設定結案(前端,成本未結案),4月輸入工時(ccj_file),執行axcp401時應增加判斷ccj有無資料,沒有的話才結案
# Modify.........: No.MOD-850139 08/07/15 By Pengu 調整當sw_1='Y'時才跑p401_doc_chk()
# Modify.........: No.MOD-860059 08/06/05 By chenl 若sw_1<>'Y'時，不必參考臨時表資料。 
# Modify.........: No.MOD-8A0082 08/11/21 By liuxqa 結案日期按照最后一筆tlf異動時間來寫入，這樣如果一張工單的最后一筆異動在八月，10月才進行工單結案，
#                                            這樣在成會結案的時候成會日期就會變成八月，10月份月結的時候就算不到此張工單，
#                                            應該按照輸入的年度別的最后一天作為結案日期。
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-8B0208 09/02/20 By liuxqa 將工藝的最后報工日期和下階料的最后報工日期考慮在內。
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-970106 09/10/20 By Pengu 檢查供單入庫位作廢的SQL有誤
# Modify.........: No:MOD-980208 09/11/25 By sabrina 1.輸入年月應管控不可以小於成本結案年月
#                                                    2.在畫面上修改年月後,下的成會結案日期沒有即時update正確日期顯示
# Modify.........: No.FUN-9C0073 10/01/11 By chenls 程序精簡
# Modify.........: No:MOD-A40037 10/04/08 By wujie chk时抓取的条件应和p401_1()一致 
# Modify.........: No:MOD-A40085 10/04/16 By Sarah axc-588應以tm.sma53與g_edate比較
# Modify.........: No:MOD-A40107 10/04/20 By Sarah 修正MOD-840472,ccj01應與g_edate比較
# Modify.........: No:CHI-880004 10/11/26 By Summer 若工單工時日期的會計期別若大於工單結案日的會計期別時則不允許結案
# Modify.........: No:CHI-980063 11/01/06 By sabrina 在p401_2()裡判斷asft300、asft700、asft670的日期是否有大於sma53 
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-AC0074 11/04/26 BY shenyang 考慮是否有備置未發量，有產生退備單
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:MOD-B80137 11/08/16 By Vampire 抓 tlf06 時應只撈取 asf
# Modify.........: No.CHI-C20055 12/05/11 By bart 工單結案請將委外採購單一併結案
# Modify.........: No:MOD-C50029 12/05/07 By Elise 工單結案作業不會檢核該工單的報工單期別，造成axct311分攤人工製費會分攤到金額，但成本計算卻不會算到因為工單已結案 
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:CHI-C80002 12/09/28 By bart 改善效能 1.NOT IN 改為 NOT EXISTS 2.declare cursor 搬到foreach 外面
# Modify.........: No:MOD-CA0145 12/11/06 By Elise 將重新計算的邏輯mark掉
# Modify.........: No:FUN-C80092 12/12/04 By fengrui 成本相關作業增加日誌功能
# Modify.........: No:CHI-C80041 13/01/03 By bart 作廢判斷
# Modify.........: No:MOD-D10044 13/01/09 By Alberti 會依畫面上輸入的值回傳
# Modify.........: No:CHI-AB0038 13/01/10 By Alberti 在update前需再從抓sfb_file資料，並免同時執行結案而錯誤
# Modify.........: No:MOD-D10084 13/01/25 By bart 結案日期不可小於最後入庫日期
# Modify.........: No:MOD-D30107 13/03/12 By bart mark commit
# Modify.........: No:MOD-D30185 13/03/22 By ck2yuan 生管結案日必須小於當期最後一天>者才做成會結案 
# Modify.........: No:CHI-D40028 13/04/16 By bart 修改結案日期條件
# Modify.........: No:MOD-DB0178 13/11/27 By suncx 逐笔报错改为s_showmsg的方式,于程序结束前统一报错

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE bno,eno		LIKE sfb_file.sfb01          #No.FUN-680122 VARCHAR(16)  #No.FUN-560172
DEFINE g_flag		LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE sw_1		LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE sw_2		LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE tm   RECORD
                yy      LIKE ccz_file.ccz01,          
                mm      LIKE ccz_file.ccz02,
             sma53      LIKE sma_file.sma53  
            END RECORD
 
DEFINE sr   RECORD
          	sw	LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
         	no	LIKE sfb_file.sfb01,         #No.FUN-680122 VARCHAR(16),  #No.FUN-560172
         	dd	LIKE type_file.dat           #No.FUN-680122 DATE
            END RECORD
DEFINE g_bdate,g_edate  LIKE type_file.dat           #MOD-8A0082  add by liuxqa
DEFINE b_date,e_date    LIKE type_file.dat           #No.FUN-680122 DATE
DEFINE g_change_lang    LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)   #FUN-570153
DEFINE g_i              LIKE type_file.num5          #count/index for any purpose        #No.FUN-680122 SMALLINT
DEFINE g_cka00         LIKE cka_file.cka00           #FUN-C80092 add
DEFINE g_cka09         LIKE cka_file.cka09           #FUN-C80092 add
 
MAIN
   DEFINE l_name        LIKE type_file.chr20         #No.FUN-680122 VARCHAR(20)
   DEFINE l_yy,l_mm     LIKE type_file.num5          #No.FUN-680122 SMALLINT 
   DEFINE l_za05        LIKE za_file.za05
   DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_sql         STRING                       #No:CHI-AB0038 add
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				 
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET bno     = ARG_VAL(1)
   LET eno     = ARG_VAL(2)
   LET sw_1    = ARG_VAL(3)
   LET sw_2    = ARG_VAL(4)
   LET tm.yy   = ARG_VAL(5)  #No.MOD-8A0082
   LET tm.mm   = ARG_VAL(6)  #No.MOD-8A0082
   LET g_bgjob = ARG_VAL(7)
 
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
  #---------No:CHI-AB0038 add
   LET l_sql = " SELECT * FROM sfb_file WHERE sfb01 = ? FOR UPDATE "
   LET l_sql = cl_forupd_sql(l_sql)
   DECLARE p401_2_cl CURSOR FROM l_sql                 # LOCK CURSOR
  #---------No:CHI-AB0038 end
 
   WHILE TRUE
      LET g_success = 'Y'
      LET g_change_lang = FALSE
      SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
      CALL cl_outnam('axcp401') RETURNING l_name
 
      #增加現行成會結算年月之判斷 
     #MOD-D10044add
      IF tm.yy IS NOT NULL AND tm.mm IS NOT NULL THEN         
         CALL s_azn01(tm.yy,tm.mm) RETURNING b_date,e_date    
      ELSE
         CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING b_date,e_date
      END IF 
     #MOD-D10044add    
     #CALL s_azn01(g_ccz.ccz01,g_ccz.ccz02) RETURNING b_date,e_date #MOD-D10044
     #MOD-CA0145---mark---S
     #LET b_date = MDY(g_ccz.ccz02,1,g_ccz.ccz01)  
     #LET l_mm = g_ccz.ccz02 + 1
     #LET l_yy = g_ccz.ccz01
     #IF l_mm > 12 THEN LET l_mm = 1 LET l_yy = l_yy + 1 END IF
     #LET e_date = MDY(l_mm,1,l_yy)-1
     #MOD-CA0145---mark---E
 
      IF g_bgjob = 'N' THEN
         CALL p401_ask()
         IF cl_sure(0,0) THEN 
            CALL cl_wait()
            #FUN-C80092--add--str--
            LET g_cka09 = " bno='",bno,"'; eno='",eno,"'; sw_1='",sw_1,"' sw_2='",sw_2,
                          "' tm.yy='",tm.yy,"'; tm.mm='",tm.mm,"'; g_bgjob='",g_bgjob,"'"
            CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00
            #FUN-C80092--add--end--
            BEGIN WORK 
            CALL cl_outnam(g_prog) RETURNING l_name   #No.MOD-830236 add
           #檢查是否有未過完帳的單據，若有則產出報表，不予結案
            IF sw_1 ='Y' THEN      #No.MOD-850139 add
               CALL p401_doc_chk()
            END IF                 #No.MOD-850139 add
            CALL s_showmsg()        #No.FUN-710027  
            LET g_success = 'Y'   #No.MOD-830236 add
               START REPORT axcp401_rep TO l_name
               LET g_pageno = 0
               CALL s_showmsg_init() #MOD-DB0178 
               IF sw_1='Y' THEN CALL p401_1() END IF
               IF sw_2='Y' THEN CALL p401_2() END IF
               CALL s_showmsg()   #MOD-DB0178
               FINISH REPORT axcp401_rep
               CALL cl_prt(l_name,'',1,80)
            END IF   #FUN-650116 add
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
               CALL cl_end2(1) RETURNING g_flag #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
               CALL cl_end2(2) RETURNING g_flag #批次作業失敗
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p401_w
               EXIT WHILE
            END IF
         CLOSE WINDOW p401_w
      ELSE
         #FUN-C80092--add--str--
         LET g_cka09 = " bno='",bno,"'; eno='",eno,"'; sw_1='",sw_1,"' sw_2='",sw_2,
                       "' tm.yy='",tm.yy,"'; tm.mm='",tm.mm,"'; g_bgjob='",g_bgjob,"'"
         CALL s_log_ins(g_prog,tm.yy,tm.mm,'',g_cka09) RETURNING g_cka00
         #FUN-C80092--add--end--  
         START REPORT axcp401_rep TO l_name
         LET g_pageno = 0
         IF sw_1 ='Y' THEN      #No.MOD-850139 add
            CALL p401_doc_chk()   #No.MOD-830236 add
         END IF                 #No.MOD-850139 add
         BEGIN WORK 
         IF sw_1='Y' THEN 
            CALL p401_1() 
            CALL s_showmsg()        #No.FUN-710027  
         END IF
         IF sw_2='Y' THEN 
            CALL p401_2()
            CALL s_showmsg()        #No.FUN-710027  
         END IF
         FINISH REPORT axcp401_rep
 
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')  #FUN-C80092 add
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p401_ask()
   DEFINE c              LIKE cre_file.cre08       #No.FUN-680122 VARCHAR(10) 
   DEFINE lc_cmd         LIKE type_file.chr1000    #No.FUN-680122 VARCHAR(500)     #FUN-570153
   DEFINE p_row,p_col    LIKE type_file.num5       #FUN-570153   #No.FUN-680122 SMALLINT
 
   LET p_row = 1 LET p_col = 1  
 
   OPEN WINDOW p401_w AT p_row,p_col WITH FORM "axc/42f/axcp401" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   LET bno='0'
   LET eno='z'
   LET sw_1='N' #MOD-540065
   LET sw_2='Y'
   LET g_bgjob = 'N'   #FUN-570153
   INITIALIZE tm.* TO NULL
   SELECT ccz01,ccz02 INTO tm.yy,tm.mm FROM ccz_file
   CALL s_azm(tm.yy,tm.mm) RETURNING g_flag,g_bdate,g_edate
   LET tm.sma53 = g_edate
 
  WHILE TRUE
   INPUT BY NAME bno,eno, sw_1, sw_2,tm.yy,tm.mm,tm.sma53,g_bgjob WITHOUT DEFAULTS   #NO.FUN-571053 #No.MOD-8A0082 add by liuxqa
      AFTER FIELD yy
         IF cl_null(tm.yy) THEN
            NEXT FIELD yy
         ELSE
            CALL s_azm(tm.yy,tm.mm) RETURNING g_flag,g_bdate,g_edate
            LET tm.sma53 = g_edate
            DISPLAY BY NAME tm.sma53
         LET tm.sma53 = g_edate
         END IF
      AFTER FIELD mm
         IF cl_null(tm.mm) THEN
            NEXT FIELD mm
         ELSE
            CALL s_azm(tm.yy,tm.mm) RETURNING g_flag,g_bdate,g_edate
            LET tm.sma53 = g_edate
            DISPLAY BY NAME tm.sma53
         LET tm.sma53 = g_edate
         END IF
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()	# Command execution
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit            #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
      ON ACTION locale          #genero
         LET g_change_lang = TRUE                   #FUN-570153
         EXIT INPUT
 
      BEFORE INPUT
         CALL cl_qbe_init()
 
      AFTER INPUT
         IF tm.yy*12+tm.mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
            CALL cl_err('','axc-196','1')
            NEXT FIELD yy
         END IF

      ON ACTION qbe_select
         CALL cl_qbe_select()
 
      ON ACTION qbe_save
         CALL cl_qbe_save()
 
   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p401_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
 
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axcp401'
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('axcp401','9031',1)   
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",bno CLIPPED,"'",
                      " '",eno CLIPPED,"'",
                      " '",sw_1 CLIPPED,"'",
                      " '",sw_2 CLIPPED,"'",
                      " '",tm.yy CLIPPED,"'",  #No.MOD-8A0082
                      " '",tm.mm CLIPPED,"'", #No.MOD-8A0082
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('axcp401',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p401_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
  END WHILE
 
 
END FUNCTION
 
FUNCTION p401_1() # 1.將已完工(預計產量=已入庫量)的工單自動結案之
DEFINE g_sfb	RECORD LIKE sfb_file.*
DEFINE l_tlf06  LIKE tlf_file.tlf06
DEFINE l_cci01  LIKE cci_file.cci01    #No:CHI-880004 add
DEFINE l_cnt    LIKE type_file.num5   #MOD-840472 add
DEFINE l_sfk02  LIKE sfk_file.sfk02   #No.MOD-8B0208 add by liuxqa 
DEFINE l_shb03  LIKE sfb_file.sfb03   #No.MOD-8B0208 add by liuxqa 
DEFINE l_sie11 LIKE sie_file.sie11          #FUN-AC0074
DEFINE l_sql    STRING   #CHI-C80002
DEFINE l_rvu03  LIKE rvu_file.rvu03  #MOD-D10084

   DECLARE c1 CURSOR FOR
      #CHI-C80002---begin
      SELECT * FROM sfb_file b
       WHERE b.sfb04!='8' AND b.sfb08<=b.sfb09 AND b.sfb09>0
         AND b.sfb01 BETWEEN bno AND eno
         AND b.sfb81 <= e_date 
         AND NOT EXISTS(SELECT 1 FROM p401_temp t WHERE t.sfb01 = b.sfb01)
       ORDER BY b.sfb81
      #CHI-C80002---end
      #CHI-C80002---begin mark
      #SELECT * FROM sfb_file
      # WHERE sfb04!='8' AND sfb08<=sfb09 AND sfb09>0
      #   AND sfb01 BETWEEN bno AND eno
      #   AND sfb81 <= e_date 
      #   AND sfb01 NOT IN (SELECT sfb01 FROM p401_temp)   #No.MOD-830236 add
      # ORDER BY sfb81
      #CHI-C80002---end
   #CHI-C80002---begin
   LET l_sql = " UPDATE sfb_file SET sfb04='8' WHERE sfb01=? "
   PREPARE upd_sfb04_prep FROM l_sql

   LET l_sql = " UPDATE pmm_file SET pmm25 = '6' WHERE pmm01 = ? "
   PREPARE upd_pmm25_prep FROM l_sql

   LET l_sql = " UPDATE pmn_file SET pmn16 = '6' WHERE pmn41 = ? "
   PREPARE upd_pmn16_prep FROM l_sql     
   #CHI-C80002---end
      
   FOREACH c1 INTO g_sfb.*
#增加現行成會結算年月之判斷   
      SELECT max(tlf06) INTO l_tlf06 FROM tlf_file
       WHERE tlf62=g_sfb.sfb01 
         AND (tlf02=50 OR tlf03=50)
         AND tlf13[1,3]='asf'       #MOD-B80137 add
      IF l_tlf06 > e_date THEN CONTINUE FOREACH END IF
     #--------------No:CHI-880004 add
      #判斷工單報工日期是否等於現行會計年度
      LET l_cci01 = NULL
      SELECT max(cci01) INTO l_cci01 FROM cci_file,ccj_file 
                        WHERE ccj04 = g_sfb.sfb01 
                          AND ccj01 = cci01
                          AND ccj02 = cci02 
                          AND cciacti = 'Y'
                          AND ccifirm <> 'X'  #CHI-C80041
      IF NOT cl_null(l_cci01) THEN
         IF l_cci01 > e_date THEN
           #CALL cl_err(g_sfb.sfb01,'axc-037',1)                #MOD-DB0178
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','axc-037',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF
      END IF
      #CHI-D40028---begin
      IF g_sfb.sfb28 = '1' THEN
         IF e_date < g_sfb.sfb36 THEN
           #CALL cl_err(g_sfb.sfb01,'asf-352',1)
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','asf-352',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF 
      END IF 
      IF g_sfb.sfb28 = '2' THEN
         IF e_date < g_sfb.sfb37 THEN
           #CALL cl_err(g_sfb.sfb01,'asf-353',1)
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','asf-353',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF 
      END IF 
      #CHI-D40028---end
     #--------------No:CHI-880004 end
     #查此工單是否在ccj_file輸入大於現行成會結算年月的工時資料,有則不結案
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ccj_file 
       WHERE ccj04=g_sfb.sfb01 AND ccj01>g_edate   #MOD-A40107 mod
      IF l_cnt > 0 THEN CONTINUE FOREACH END IF
#判斷工單的下階料的最后報廢日期是否大于現行會計年度，有則不結案。
      LET l_sfk02 = NULL
      SELECT max(sfk02) INTO l_sfk02 FROM sfk_file,sfl_file
                             WHERE sfl02 = g_sfb.sfb01
                               AND sfl01 = sfk01
                               AND sfkconf = 'Y' 
                               AND sfkpost = 'Y'
      IF NOT cl_null(l_sfk02) THEN
         IF l_sfk02 > e_date THEN 
           #CALL cl_err(g_sfb.sfb01,'axc-039',1)
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','axc-039',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF
      END IF
 
#判斷工單的工藝的最后報工日期是否大于現行會計年度，有則不結案。
      LET l_shb03 = NULL
      SELECT max(shb03) INTO l_shb03 FROM shb_file
                          WHERE shb05 = g_sfb.sfb01
                         #AND shbacti = 'Y'    #MOD-C50029 mark
                         #AND shbconf = 'Y'    #FUN-A70095  #MOD-C50029 mark
                          AND shbconf != 'X'   #MOD-C50029
      IF NOT cl_null(l_shb03) THEN
         IF l_shb03 > e_date THEN
           #CALL cl_err(g_sfb.sfb01,'axc-038',1)
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','axc-038',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF
      END IF
      #MOD-D10084---begin
      #結案日期不可小於最後入庫日期
      SELECT MAX(rvu03) INTO l_rvu03
        FROM rvv_file,rvu_file
       WHERE rvv01 = rvu01 
         AND rvu08 = 'SUB'
         AND rvv18 = g_sfb.sfb01
         AND rvuconf <> 'X'
      IF NOT cl_null(l_rvu03) THEN
         IF e_date < l_rvu03 THEN
           #CALL cl_err(g_sfb.sfb01,'asf-247',1)
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','asf-247',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF 
      END IF 
      #MOD-D10084---end
      #UPDATE sfb_file SET sfb04='8' WHERE sfb01=g_sfb.sfb01  #CHI-C80002
      EXECUTE upd_sfb04_prep USING g_sfb.sfb01  #CHI-C80002
      IF SQLCA.SQLCODE THEN
         #CALL cl_err3("upd","sfb_file",g_sfb.sfb01,"",SQLCA.SQLCODE,"","",1)   #No.FUN-660127
          CALL s_errmsg('sfb01',g_sfb.sfb01,'Update sfb04 fail',SQLCA.SQLCODE,1)   #MOD-DB0178
          LET g_success='N' 
          RETURN
      END IF
      #CHI-C20055---begin
      SELECT COUNT(*) INTO l_cnt FROM pmm_file WHERE pmm01 = g_sfb.sfb01
      IF cl_null(l_cnt) THEN
         LET l_cnt = 0
      END IF 
      IF l_cnt > 0 THEN 
         #UPDATE pmm_file SET pmm25 = '6' WHERE pmm01 = g_sfb.sfb01 #CHI-C80002
         EXECUTE upd_pmm25_prep USING g_sfb.sfb01  #CHI-C80002
         IF SQLCA.SQLCODE THEN
            #CALL cl_err3("upd","pmm_file",g_sfb.sfb01,"",SQLCA.SQLCODE,"","",1)
             CALL s_errmsg('sfb01',g_sfb.sfb01,'Update pmm25 fail',SQLCA.SQLCODE,1)   #MOD-DB0178
             LET g_success='N' 
             RETURN
         END IF
       END IF 
       #UPDATE pmn_file            #CHI-C80002
       #   SET pmn16 = '6'         #CHI-C80002
       # WHERE pmn41 = g_sfb.sfb01 #CHI-C80002
       EXECUTE upd_pmn16_prep USING g_sfb.sfb01  #CHI-C80002
       IF SQLCA.sqlcode THEN
         #CALL cl_err3("upd","pmn_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","",1)
          CALL s_errmsg('sfb01',g_sfb.sfb01,'Update pmn16 fail',SQLCA.SQLCODE,1)   #MOD-DB0178
          LET g_success='N'  #MOD-D30107
          RETURN             #MOD-D30107
       #ELSE                 #MOD-D30107
       #   COMMIT WORK       #MOD-D30107
       END IF 
      #CHI-C20055---end
   #FUN-AC0074--add--begin
   SELECT  SUM(sie11) INTO l_sie11 FROM sie_file
     WHERE sie05 = g_sfb.sfb01
   IF l_sie11 >0 THEN
      CALL p401_yes(g_sfb.sfb05,g_sfb.sfb01)
   END IF
   #FUN-AC0074--add--end
      IF g_bgjob = 'N' THEN  #NO.FUN-570153 
          message '1: ',g_sfb.sfb01
          CALL ui.Interface.refresh()
      END IF
      OUTPUT TO REPORT axcp401_rep('1', g_sfb.sfb01, '')
    END FOREACH
END FUNCTION

#FUN-AC0074--add--begin
FUNCTION p401_yes(p_sfb05,p_sfb01)
DEFINE  l_sia  RECORD LIKE sia_file.*
DEFINE  p_sfb05 LIKE sfb_file.sfb05
DEFINE  p_sfb01 LIKE sfb_file.sfb01
DEFINE  l_sie   DYNAMIC ARRAY OF RECORD
                sie01   LIKE sie_file.sie01,
                sie02   LIKE sie_file.sie02,
                sie03   LIKE sie_file.sie03,
                sie04   LIKE sie_file.sie04,
                sie05   LIKE sie_file.sie05,
                sie06   LIKE sie_file.sie06,
                sie07   LIKE sie_file.sie07,
                sie08   LIKE sie_file.sie08,
                sie09   LIKE sie_file.sie09,
                sie10   LIKE sie_file.sie10,
                sie11   LIKE sie_file.sie11,
                sie12   LIKE sie_file.sie12,
                sie13   LIKE sie_file.sie13,
                sie14   LIKE sie_file.sie14,
                sie15   LIKE sie_file.sie15,
                sie16   LIKE sie_file.sie16,
                 sie012  LIKE sie_file.sie012,
                sie013  LIKE sie_file.sie013
                END RECORD
DEFINE l_ac             LIKE type_file.num5
DEFINE g_sql            STRING
DEFINE li_result    LIKE type_file.num5
DEFINE l_err        STRING
DEFINE l_flag      LIKE type_file.chr1 
DEFINE l_ima25     LIKE ima_file.ima25
DEFINE l_fac       LIKE ima_file.ima31_fac
DEFINE l_sic07_fac LIKE sic_file.sic07_fac
DEFINE l_sic02     LIKE sic_file.sic02

      LET l_sia.sia04 ='2'
      LET l_sia.sia05 = '2'
      LET l_sia.sia06 = g_grup
      LET l_sia.sia02 =g_today
      LET l_sia.sia03 =g_today
      LET l_sia.siaacti = 'Y'
      LET l_sia.siaconf = 'N'
      LET l_sia.siauser = g_user
      LET l_sia.siaplant = g_plant
      LET l_sia.siadate = g_today
      LET l_sia.sialegal = g_legal
      LET l_sia.siagrup = g_grup
      LET l_sia.siaoriu = g_user
      LET l_sia.siaorig = g_grup
         LET g_sql=" SELECT MAX(smyslip) FROM smy_file",
                   "  WHERE smysys = 'asf' AND smykind='5' ",
                   "    AND length(smyslip) = ",g_doc_len
         PREPARE p410_smy FROM g_sql
         EXECUTE p410_smy INTO l_sia.sia01
        CALL s_auto_assign_no("asf",l_sia.sia01,l_sia.sia02,"","sia_file","sia01","","","")
            RETURNING li_result,l_sia.sia01
        IF (NOT li_result) THEN
            LET g_success='N'
            RETURN
        END IF
      INSERT INTO sia_file(sia01,sia02,sia03,sia04,sia05,sia06,siaacti,
                    siaconf,siauser,siaplant,
                     siadate,sialegal,siagrup,siaoriu,siaorig)
             VALUES (l_sia.sia01,l_sia.sia02,l_sia.sia03,l_sia.sia04,l_sia.sia05,g_grup,l_sia.siaacti,
                     l_sia.siaconf,l_sia.siauser,l_sia.siaplant,
                     l_sia.siadate,l_sia.sialegal,l_sia.siagrup,l_sia.siaoriu,l_sia.siaorig)

      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
        #CALL cl_err3("ins","sia_file",l_sia.sia01,l_sia.sia02,l_err,"","ins sia:",1)  
         CALL s_errmsg('sia01',l_sia.sia01,'Insert sia_file fail',SQLCA.SQLCODE,1)   #MOD-DB0178
         LET g_success='N'
         RETURN
      END IF
      LET l_ac =1
      LET g_sql =
             "SELECT sie01,sie02,sie03,sie04,sie05,sie06,sie07,sie08,sie09,sie10,sie11,sie12,sie13,sie14,sie15,sie16,sie012,sie013", 
             " FROM sie_file",
             " WHERE sie05 = '",p_sfb01,"' AND sie11 > 0"
      PREPARE p400_pb2 FROM g_sql
      DECLARE sie_curs2 CURSOR FOR p400_pb2

      #CHI-C80002---begin
      LET g_sql = " INSERT INTO sic_file(sic01,sic02,sic03,sic04,sic05,sic06,sic07,sic08,sic09, ",
                  " sic10,sic11,sic012,sic013,sic15,sic12,siclegal,sicplant,sic07_fac) ",
                  " VALUES (?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?) "
      PREPARE p400_inssic_p1 FROM g_sql
      #CHI-C80002---end
      FOREACH sie_curs2  INTO l_sie[l_ac].*
         SELECT ima25 INTO l_ima25 FROM ima_file
           WHERE ima01 = l_sie[l_ac].sie08
           CALL s_umfchk(l_sie[l_ac].sie08,l_sie[l_ac].sie07,l_ima25)
              RETURNING l_flag,l_fac
           IF l_flag THEN 
              CALL cl_err('','',0)
              LET g_success = 'N'
              RETURN
           ELSE 
              LET l_sic07_fac = l_fac 
           END IF
           SELECT max(sic02)+1 INTO l_sic02 FROM sic_file
           WHERE sic01 = l_sia.sia01
         IF cl_NULL(l_sic02) THEN
            LET l_sic02 =1
         END IF
         #CHI-C80002---begin mark
         #INSERT INTO sic_file(sic01,sic02,sic03,sic04,sic05,
         #           sic06,sic07,sic08,sic09,
         #            sic10,sic11,sic012,sic013,sic15,sic12,siclegal,sicplant,sic07_fac)
         #    VALUES (l_sia.sia01,l_sic02,l_sie[l_ac].sie05,l_sie[l_ac].sie08,l_sie[l_ac].sie01,
         #            l_sie[l_ac].sie11,l_sie[l_ac].sie07,l_sie[l_ac].sie02,l_sie[l_ac].sie03,
         #            l_sie[l_ac].sie04,l_sie[l_ac].sie06,l_sie[l_ac].sie012,l_sie[l_ac].sie013,
         #            l_sie[l_ac].sie15,'',g_legal,g_plant,l_sic07_fac)
         #CHI-C80002---end
         #CHI-C80002---begin         
         EXECUTE p400_inssic_p1 USING l_sia.sia01,l_sic02,l_sie[l_ac].sie05,l_sie[l_ac].sie08,l_sie[l_ac].sie01,
                     l_sie[l_ac].sie11,l_sie[l_ac].sie07,l_sie[l_ac].sie02,l_sie[l_ac].sie03,
                     l_sie[l_ac].sie04,l_sie[l_ac].sie06,l_sie[l_ac].sie012,l_sie[l_ac].sie013,
                     l_sie[l_ac].sie15,'',g_legal,g_plant,l_sic07_fac
         #CHI-C80002---end  
      IF SQLCA.sqlcode THEN
         LET l_err = SQLCA.sqlcode
        #CALL cl_err3("ins","sic_file",l_sia.sia01,l_sie[l_ac].sie15,l_err,"","ins sic:",1)  
         CALL s_errmsg('sia01',l_sia.sia01,'Insert sic_file fail',SQLCA.SQLCODE,1)   #MOD-DB0178
         LET g_success='N'
         RETURN
      END IF
      LET l_ac= l_ac+1
     END  FOREACH
     CALL i610sub_y_chk(l_sia.sia01)
     IF g_success = "Y" THEN
        CALL i610sub_y_upd(l_sia.sia01,'',TRUE)  RETURNING l_sia.*
     END IF
END FUNCTION
#FUN-AC0074 --add--end
 
FUNCTION p401_2() # 2.將已結案的工單自動設定結案日
DEFINE g_sfb      RECORD LIKE sfb_file.*
DEFINE l_tlf06    LIKE type_file.dat       #No.FUN-680122 date,
DEFINE l_date     LIKE type_file.dat       #No.FUN-680122 date,
DEFINE l_yy,l_mm  LIKE type_file.num5      #No.FUN-680122 smallint
DEFINE l_cnt      LIKE type_file.num5      #MOD-840472 add
DEFINE l_sql      STRING                   #No.MOD-860059 add
DEFINE l_cci01    LIKE cci_file.cci01      #No:CHI-880004
DEFINE l_flag     LIKE type_file.chr1
DEFINE l_sfk02    LIKE sfk_file.sfk02          #CHI-980063 add
DEFINE l_shb03    LIKE shb_file.shb03          #CHI-980063 add
DEFINE l_srf02    LIKE srf_file.srf02          #CHI-980063 add
DEFINE l_rvu03    LIKE rvu_file.rvu03  #MOD-D10084

   CALL s_azm(tm.yy,tm.mm) RETURNING l_flag,g_bdate,g_edate #得出修改后的起始日期與截止日
   IF l_flag !='0' THEN
      LET g_success = 'N'
          RETURN
      ELSE
          LET tm.sma53 = g_edate
   END IF
   #CHI-C80002---begin
   LET l_sql = " UPDATE sfb_file SET sfb28='3', ",
               " sfb38=? ",
               " WHERE sfb01=? "
   PREPARE p401_upd_sfb28_p1 FROM l_sql
   #CHI-C80002---end 
   #CHI-C80002---begin mark
   #LET l_sql = "SELECT * FROM sfb_file ",
   #            " WHERE sfb04='8' AND sfb38 is null ",
   #            " AND sfb01 BETWEEN '",bno,"' AND  '",eno,"'"
   #CHI-C80002---end
   #CHI-C80002---begin
   LET l_sql = "SELECT * FROM sfb_file b ",
               " WHERE b.sfb04='8' AND b.sfb38 is null ",
               " AND (sfb36 <= '",g_edate,"' OR sfb36 is null)",     #MOD-D30185
               " AND b.sfb01 BETWEEN '",bno,"' AND  '",eno,"'"
   #CHI-C80002---end
   IF sw_1 = 'Y' THEN 
      #LET l_sql = l_sql , " AND sfb01 NOT IN (SELECT sfb01 FROM p401_temp) " #CHI-C80002
      LET l_sql = l_sql , " AND NOT EXISTS(SELECT 1 FROM p401_temp t WHERE t.sfb01 = b.sfb01) "  #CHI-C80002
   END IF 
   #LET l_sql = l_sql ," ORDER BY sfb81 "  #CHI-C80002
   LET l_sql = l_sql ," ORDER BY b.sfb81 "  #CHI-C80002
   PREPARE p401_prep2 FROM l_sql
   DECLARE c2 CURSOR FOR p401_prep2
   FOREACH c2 INTO g_sfb.*
   #------------------No:CHI-AB0038 add
      OPEN p401_2_cl USING g_sfb.sfb01
      IF STATUS THEN 
         CONTINUE FOREACH
      END IF
      FETCH p401_2_cl INTO g_sfb.*               # 對DB鎖定
      IF g_sfb.sfb04 != '8' THEN CONTINUE FOREACH END IF
     #------------------No:CHI-AB0038 end
      SELECT max(tlf06) INTO l_tlf06 FROM tlf_file
       WHERE tlf62=g_sfb.sfb01 AND (tlf02=50 OR tlf03=50)
         AND tlf13[1,3]='asf'       #MOD-B80137 add
      IF l_tlf06 IS NULL THEN LET l_tlf06=g_sfb.sfb81 END IF
      IF l_tlf06 IS NULL THEN LET l_tlf06=g_sfb.sfb13 END IF
      IF tm.sma53 < l_tlf06 THEN
         CONTINUE FOREACH
      ELSE
         LET g_sfb.sfb38 = tm.sma53
      END IF
     #IF tm.sma53 <> e_date THEN    #MOD-A40085 mark
      IF tm.sma53 <> g_edate THEN   #MOD-A40085
        #CALL cl_err(tm.sma53,'axc-588',1)
         CALL s_errmsg('',tm.sma53,'','axc-588',1)   #MOD-DB0178
      END IF
     #--------------No:CHI-880004 add
      #判斷工單報工日期是否等於現行會計年度
      LET l_cci01 = NULL
      SELECT max(cci01) INTO l_cci01 FROM cci_file,ccj_file 
                        WHERE ccj04 = g_sfb.sfb01 
                          AND ccj01 = cci01
                          AND ccj02 = cci02 
                          AND cciacti = 'Y'
                          AND ccifirm <> 'X' #CHI-C80041
      IF NOT cl_null(l_cci01) THEN
         IF l_cci01 > e_date THEN
           #CALL cl_err(g_sfb.sfb01,'axc-037',1)
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','axc-037',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF
      END IF
     #--------------No:CHI-880004 end
     #CHI-980063---add---start---
     #判斷工單下階料最後報廢日期是否等於現行會計年度
      LET l_sfk02 = NULL
      SELECT max(sfk02) INTO l_sfk02 FROM sfk_file,sfl_file
                        WHERE sfl02 = g_sfb.sfb01
                           AND sfl01 = sfk01
                           AND sfkconf = 'Y'
                           AND sfkpost = 'Y'
      IF NOT cl_null(l_sfk02) THEN
         IF l_sfk02 > tm.sma53 THEN
            CONTINUE FOREACH
         ELSE
            LET g_sfb.sfb38 = tm.sma53
         END IF
      END IF
      #CHI-D40028---begin
      IF g_sfb.sfb28 = '1' THEN
         IF e_date < g_sfb.sfb36 THEN
           #CALL cl_err(g_sfb.sfb01,'asf-352',1)
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','asf-352',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF 
      END IF 
      IF g_sfb.sfb28 = '2' THEN
         IF e_date < g_sfb.sfb37 THEN
           #CALL cl_err(g_sfb.sfb01,'asf-353',1)
            CALL s_errmsg('sfb01',g_sfb.sfb01,'','asf-353',1)   #MOD-DB0178
            CONTINUE FOREACH
         END IF 
      END IF 
      #CHI-D40028---end
     #判斷工單製程最後報工日期是否等於現行會計年度(有走製程)
      LET l_shb03 = NULL
      SELECT max(shb03) INTO l_shb03 FROM shb_file
                         WHERE shb05 = g_sfb.sfb01
                        #AND shbacti = 'Y'  #MOD-C50029 mark
                        #AND shbconf = 'Y'  #FUN-A70095  #MOD-C50029 mark
                         AND shbconf != 'X' #MOD-C50029
      IF NOT cl_null(l_shb03) THEN
         IF l_shb03 > tm.sma53 THEN
           CONTINUE FOREACH
         ELSE
            LET g_sfb.sfb38 = tm.sma53
         END IF
      END IF
     #判斷工單的報工日期是否等於現行會計年度(不走製程)
      LET l_srf02 = NULL
      SELECT max(srf02) INTO l_srf02 FROM srf_file,srg_file
                         WHERE srf01 = srg01
                           AND srg16 = g_sfb.sfb01 
                          #AND srfconf = 'Y'  #MOD-C50029 mark
                           AND srfconf != 'X' #MOD-C50029
      IF NOT cl_null(l_srf02) THEN
         IF l_srf02 > tm.sma53 THEN
           CONTINUE FOREACH
         ELSE
            LET g_sfb.sfb38 = tm.sma53
         END IF
      END IF
     #CHI-980063---add---end---
     #查此工單是否在ccj_file輸入大於現行成會結算年月的工時資料,有則不結案
      LET l_cnt = 0
      SELECT COUNT(*) INTO l_cnt FROM ccj_file 
       WHERE ccj04=g_sfb.sfb01 AND ccj01>g_edate   #MOD-A40107 mod
      IF l_cnt > 0 THEN CONTINUE FOREACH END IF
      #CHI-C80002---begin mark
      #UPDATE sfb_file SET sfb28='3',      #工單結案狀態
      #                   #sfb36=l_tlf06,
      #                   #sfb37=l_tlf06,
      #                    sfb38=g_sfb.sfb38
      #              WHERE sfb01=g_sfb.sfb01
      #CHI-C80002---end
      #MOD-D10084---begin
      #結案日期不可小於最後入庫日期
      SELECT MAX(rvu03) INTO l_rvu03
        FROM rvv_file,rvu_file
       WHERE rvv01 = rvu01 
         AND rvu08 = 'SUB'
         AND rvv18 = g_sfb.sfb01
         AND rvuconf <> 'X'
      IF NOT cl_null(l_rvu03) THEN
         IF tm.sma53 < l_rvu03 THEN
            CONTINUE FOREACH
         ELSE
            LET g_sfb.sfb38 = tm.sma53
         END IF 
      END IF 
      #MOD-D10084---end
      EXECUTE p401_upd_sfb28_p1 USING g_sfb.sfb38,g_sfb.sfb01  #CHI-C80002
      IF SQLCA.SQLCODE THEN
         #CALL cl_err3("upd","sfb_file",g_sfb.sfb01,"",SQLCA.SQLCODE,"","",1)   #No.FUN-660127
          CALL s_errmsg('sfb01',g_sfb.sfb01,'Update sfb28 fail',SQLCA.SQLCODE,1)   #MOD-DB0178
          LET g_success='N' 
          RETURN
      END IF
      IF g_bgjob = 'N' THEN #NO.FUN-570153 
          message '2: ',g_sfb.sfb01,' ',l_tlf06
          CALL ui.Interface.refresh()
      END IF
      CLOSE p401_2_cl    #No:CHI-AB0038 add
      OUTPUT TO REPORT axcp401_rep('2', g_sfb.sfb01, g_sfb.sfb38)
    END FOREACH
END FUNCTION
 
REPORT axcp401_rep(sr)
  DEFINE sr    RECORD
         	sw	LIKE type_file.chr1,           #No.FUN-680122 VARCHAR(1),
         	no	LIKE sfb_file.sfb01,           #No.FUN-680122 VARCHAR(16),   #No.FUN-560172
         	dd	LIKE type_file.dat             #No.FUN-680122 DATE  
               END RECORD,
         l_last_sw      LIKE type_file.chr1            #No.FUN-680122 VARCHAR(1) #TQC-650050
 
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
  ORDER BY sr.sw, sr.no
 
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED,pageno_total
      PRINT 
      PRINT g_dash
      PRINT g_x[31],g_x[32],g_x[33]
      PRINT g_dash1
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],sr.sw,
            COLUMN g_c[32],sr.no,
            COLUMN g_c[33],sr.dd
  ON LAST ROW
     PRINT g_dash
     LET l_last_sw = 'y'
     PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[7] CLIPPED
 
  PAGE TRAILER
     IF l_last_sw = 'n'
        THEN PRINT g_dash
             PRINT g_x[4],g_x[5] CLIPPED,COLUMN (g_len-9),g_x[6] CLIPPED
        ELSE SKIP 2 LINE
     END IF
END REPORT
 
FUNCTION p401_doc_chk()
   DEFINE l_i      LIKE type_file.num5,  
          l_cnt    LIKE type_file.num5,  
          l_sql    LIKE type_file.chr1000,
          l_docno  LIKE sfb_file.sfb01, 
          l_sfb    RECORD LIKE sfb_file.*
 
   DROP TABLE p401_temp;
   CREATE TEMP TABLE p401_temp(
       sfb01     LIKE sfb_file.sfb01,
       type      LIKE type_file.chr1,  
       docno     LIKE sfp_file.sfp01);
   CREATE INDEX p401_index ON p401_temp(sfb01)  #CHI-C80002
 
   LET l_sql= "INSERT INTO p401_temp (sfb01,type,docno) ",
              "               VALUES (    ?,   ?,    ?) "
   PREPARE p401_ins_p1 FROM l_sql
   IF SQLCA.SQLCODE THEN CALL cl_err('p401_ins_p1',SQLCA.SQLCODE,1)
      CALL s_log_upd(g_cka00,'N')  #FUN-C80092 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF

   #CHI-C80002---begin
   LET l_sql= " SELECT COUNT(sfp01),sfp01 FROM sfp_file,sfs_file ",
              " WHERE sfp01=sfs01 ",
              " AND sfs03=? ", 
              " AND sfp04!='Y' ",
              " AND sfpconf != 'X' ",      
              " AND sfp06 IN ('1','2','3','4','D') ",
              " GROUP BY sfp01 "
   PREPARE p401_chk_p1 FROM l_sql
   DECLARE p401_chk_c1 CURSOR FOR p401_chk_p1

   LET l_sql= " SELECT COUNT(sfp01),sfp01 FROM sfp_file,sfs_file ",
              " WHERE sfp01=sfs01 ",
              " AND sfs03=? ",
              " AND sfp04!='Y' ",
              " AND sfp06 IN ('6','7','8','9') ",
              " AND sfpconf != 'X' ",    
              " GROUP BY sfp01 "
   PREPARE p401_chk_p2 FROM l_sql
   DECLARE p401_chk_c2 CURSOR FOR p401_chk_p2

   LET l_sql= " SELECT COUNT(sfu01),sfu01 FROM sfu_file,sfv_file ",
              " WHERE sfu01=sfv01 ",
              " AND sfv11=? ",
              " AND sfupost!='Y' ",
              " AND sfuconf != 'X' ",      
              " GROUP BY sfu01 "
   PREPARE p401_chk_p3 FROM l_sql
   DECLARE p401_chk_c3 CURSOR FOR p401_chk_p3
   #CHI-C80002---end
 
   DECLARE c0 CURSOR FOR
      SELECT * FROM sfb_file
       WHERE sfb04 != '8' AND (sfb28 != '3' OR sfb28 IS NULL)
         AND sfb87 != 'X'
         AND sfb01 BETWEEN bno AND eno
         AND sfb81 <= e_date 
         AND sfb08<=sfb09 AND sfb09>0   #No.MOD-A40037 
       ORDER BY sfb81
 
   CALL s_showmsg_init()   #No.FUN-710027 
   FOREACH c0 INTO l_sfb.*
 
   #若發料單、退料單、完工入庫單有單據未過帳，則出報表
      #發料單
      LET l_cnt = 0
      #CHI-C80002---begin mark
      #DECLARE p401_chk_c1 CURSOR FOR
      #   SELECT COUNT(sfp01),sfp01 FROM sfp_file,sfs_file
      #    WHERE sfp01=sfs01 
      #      AND sfs03=l_sfb.sfb01 
      #      AND sfp04!='Y'
      #      AND sfpconf != 'X'        #No.MOD-810202 add
      #      AND sfp06 IN ('1','2','3','4','D')        #FUN-C70014 add 'D'
      #    GROUP BY sfp01
      #FOREACH p401_chk_c1 INTO l_cnt,l_docno
      #CHI-C80002---end
      FOREACH p401_chk_c1 USING l_sfb.sfb01 INTO l_cnt,l_docno #CHI-C80002
         IF STATUS THEN
            CALL cl_err('for sfs:',STATUS,0)          #No.FUN-710027
            LET g_success='N' 
            EXIT FOREACH
         END IF
 
         IF l_cnt > 0 THEN 
            EXECUTE p401_ins_p1 USING l_sfb.sfb01,'1',l_docno
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
                CALL cl_err('INSERT p401_temp',SQLCA.SQLCODE,0)  #No.FUN-710027
            END IF
         END IF
      END FOREACH
 
      #退料單
      LET l_cnt = 0
      #CHI-C80002---begin mark
      #DECLARE p401_chk_c2 CURSOR FOR
      #   SELECT COUNT(sfp01),sfp01 FROM sfp_file,sfs_file
      #    WHERE sfp01=sfs01 
      #      AND sfs03=l_sfb.sfb01
      #      AND sfp04!='Y'
      #      AND sfp06 IN ('6','7','8','9')
      #      AND sfpconf != 'X'        #No.MOD-810202 add
      #    GROUP BY sfp01
      #FOREACH p401_chk_c2 INTO l_cnt,l_docno
      #CHI-C80002---end
      FOREACH p401_chk_c2 USING l_sfb.sfb01 INTO l_cnt,l_docno #CHI-C80002
         IF STATUS THEN
             CALL cl_err('for sfs:',STATUS,0)                    #No.FUN-710027
          EXIT FOREACH
         END IF
 
         IF l_cnt > 0 THEN 
            EXECUTE p401_ins_p1 USING l_sfb.sfb01,'2',l_docno
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
               CALL cl_err('INSERT p401_temp',SQLCA.SQLCODE,0)   #No.MOD-830236 modify
            END IF
         END IF
      END FOREACH
      
      #完工入庫單
      LET l_cnt = 0
      #CHI-C80002---begin mark
      #DECLARE p401_chk_c3 CURSOR FOR
      #   SELECT COUNT(sfu01),sfu01 FROM sfu_file,sfv_file
      #    WHERE sfu01=sfv01 
      #      AND sfv11=l_sfb.sfb01 
      #      AND sfupost!='Y'
      #      AND sfuconf != 'X'        #No:MOD-810202 add    #No:MOD-970106 modify
      #    GROUP BY sfu01
      #FOREACH p401_chk_c3 INTO l_cnt,l_docno
      #CHI-C80002---end
      FOREACH p401_chk_c3 USING l_sfb.sfb01 INTO l_cnt,l_docno  #CHI-C80002
         IF STATUS THEN
             CALL cl_err('for sfu:',STATUS,0)         #No.FUN-710027
            EXIT FOREACH
         END IF
 
         IF l_cnt > 0 THEN 
            EXECUTE p401_ins_p1 USING l_sfb.sfb01,'3',l_docno
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] =0 THEN
               CALL cl_err('INSERT p401_temp',SQLCA.SQLCODE,0)         #No.FUN-710027
            END IF
         END IF
      END FOREACH
   END FOREACH
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM p401_temp
   IF l_cnt > 0 AND g_bgjob = 'N' THEN        #No.MOD-830236 modify
      CALL axcp401_out1()
   END IF
 
END FUNCTION
 
FUNCTION axcp401_out1()
   DEFINE l_name   LIKE type_file.chr20, 
          l_sql    STRING,     #NO.FUN-910082
          l_str1   LIKE type_file.chr1000,    #No.MOD-830236 add
          l_str2   LIKE type_file.chr1000,    #No.MOD-830236 add
          sr       RECORD
                    sfb01     LIKE sfb_file.sfb01,
                    type      LIKE type_file.chr1,  
                    docno     LIKE sfb_file.sfb01
                   END RECORD
 
 
   # 組合出 SQL 指令
   LET l_sql = "SELECT sfb01,type,docno ",
               "  FROM p401_temp ",
               " ORDER BY sfb01,type"
   PREPARE p401_pre FROM l_sql                     # RUNTIME 編譯
   DECLARE p401_cur CURSOR FOR p401_pre
 
 
 
   FOREACH p401_cur INTO sr.*
      CASE sr.type
         WHEN '1' LET l_str1 = g_x[52] CLIPPED 
         WHEN '2' LET l_str1 = g_x[53] CLIPPED 
         WHEN '3' LET l_str1 = g_x[54] CLIPPED 
      END CASE
 
      LET l_str2 = sr.sfb01,g_x[51],"->",l_str1
      CALL s_errmsg('','',l_str2,'',1) 
      LET l_str1 = NULL
      LET l_str2 = NULL
   END FOREACH
 
END FUNCTION
#No.FUN-9C0073 ---------------By chenls  10/01/11

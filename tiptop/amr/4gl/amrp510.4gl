# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: amrp510.4gl
# Descriptions...: MRP 請購單產生作業
# Date & Author..: 96/06/10 By Roger
# Modify.........: 00/08/06 By Carol:轉PR時check單位換算
# Modify.........: NO.MOD-4C0101 04/12/17  by pengu 修改報表檔案產生模式
# Modify.........: No.MOD-520052 04/05/05 By Melody UPDATE mss_file...應不能remark
# Modify.........: No.FUN-510046 05/02/24 By pengu 報表轉XML
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550055 05/05/25 By Will 單據編號放大
# Modify.........: No.FUN-550002 05/06/06 By Trisy 單據編號加大
# Modify.........: No.FUN-560084 05/06/18 By Carrier 雙單位內容修改
# Modify.........: No.FUN-580005 05/08/03 By ice 2.0憑證類報表原則修改,並轉XML格式
# Modify.........: No.MOD-580222 05/08/23 By Rosayu cl_used只可以在main的進入點跟退出點呼叫兩次
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: No.FUN-5B0014 05/11/01 By Claire 料號/品名/規格長度放大
# Modify.........: NO.TQC-5B0061 05/11/08 BY yiting 不要default單別
# Modify.........: NO.FUN-590118 06/01/12 By Rosayu 將項次改成'###&'
# Modify.........: NO.MOD-610115 06/01/19 BY kevin 重新定義l_ima43
# Modify.........: No.FUN-610076 06/01/20 By Nicola 計價單位功能改善
# Modify.........: No.FUN-570125 06/03/07 By yiting 批次作業背景執行
# Modify.........: No.FUN-630040 06/03/23 By Nicola 產生的請購單單身多三欄位
# Modify.........: No.FUN-660107 06/06/14 By CZH cl_err-->cl_err3
# Modify.........: No.TQC-670008 06/07/05 By kim 將 g_sys 變數改成寫死系統別(要大寫)
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680082 06/08/25 By Dxfwo 欄位類型定義-改為LIKE 
# Modify.........: No.FUN-660020 06/09/08 By kim #1.轉請購單時,抓取料件的主要供應商為請購單的預設供應商
                                                 #2.匯總選項加一選擇: 供應商
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0011 06/12/04 By Sarah 沒有列印(amrp510)、(接下頁)、(結束)等表尾字樣
# Modify.........: No.FUN-6B0064 07/01/25 By rainy 無資料時要秀訊息，不可show 執行成功
# Modify.........: No.MOD-740053 07/04/24 By pengu mrp轉請購單時pml190應default為'N'
# Modify.........: No.TQC-770018 07/07/03 By wujie 打印報表時報錯，錯誤代碼（lib-301)
#                                                  請購單最大項次未控管，錄入負數仍然能生成
# Modify.........: No.TQC-770073 07/07/12 By chenl 增加廠商編號開窗查詢功能。
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-840139 08/04/19 By Pengu 放大pml41的欄位值
# Modify.........: No.MOD-840589 08/07/10 By Pengu 如果沒有經過pmk01此欄位，直接按下確定按鈕會無法新增 pmk_file
# Modify.........: No.MOD-8A0124 08/10/14 By chenl 修正多人操作時，程序有卡住的情況。
# Modify.........: No.FUN-920183 09/03/20 By shiwuying MRP功能改善
# Modify.........: No.FUN-950106 09/06/05 By jan 加入條件選擇2 groupbox以及相關處理
# Modify.........: No.MOD-960201 09/07/08 By Smapmin 匯總方式依主供應商時,產生請購不會將料件主供應商帶到請購單單頭
# Modify.........: No.FUN-980004 09/08/12 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980092 09/09/18 By TSD.apple GP5.2 跨資料庫語法修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-960188 09/10/20 By Pengu 參數使用計價單位時產生的計價單位數量會異常
# Modify.........: No:CHI-9A0046 09/10/27 By Smapmin pmk09為'-'時,default為' '
# Modify.........: No:FUN-9B0023 09/11/02 By baofei 寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: No:MOD-A40176 10/04/29 By Sarah 廠商編號若有值,應依供應商基本資料檔帶出基本資料 
# Modify.........: No:MOD-A60091 10/06/14 By Sarah ON LAST ROW段應補上列印選擇條件
# Modify.........: No.FUN-A50102 10/07/09 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A80150 10/09/07 By sabrina 新增"計畫批號"(lot_no1)欄位
# Modify.........: No.FUN-A90057 10/09/27 By kim GP5.25號機管理
# Modify.........: No.FUN-AA0059 10/10/28 By lixh1  全系統料號的開窗都改為CALL q_sel_ima()	
# Modify.........: No:MOD-AB0070 10/11/09 By zhangll change pml13 using s_overate
# Modify.........: No:CHI-880032 10/11/26 By Summer 當請購單別設定要簽核且也需自動確認時，確認碼不應給'Y'
# Modify.........: No:MOD-AC0058 10/12/08 By sabrina 若有錯誤時應改變g_success的值而不是直接離開程式
# Modify.........: No:TQC-AC0232 10/12/16 By jan pmk01預設值改寫抓法
# Modify.........: No:TQC-AC0234 10/12/16 By zhangweib 生成報表時首行多一行空行
# Modify.........: No:CHI-AC0040 10/12/30 By sabrina 無法同時多人執行程式 
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No:MOD-B50091 11/05/13 By Summer 請購單需管制時需對供應商管制
# Modify.........: No.MOD-B80037 11/08/03 By Carrier g_bgjob='Y'时,少了cl_outnam
# Modify.........: No.FUN-910088 11/11/22 By chenjing 增加數量欄位小數取位
# Modify.........: No.TQC-BB0272 12/02/13 By Carrier 多营运中心MRP产生未勾选,则不应该弹出报表信息
# Modify.........: No.MOD-C40217 12/04/30 By Elise 報表中l_order所接的值對應的欄位都是10碼，程式中只抓前6碼
# Modify.........: No.MOD-BA0198 12/06/15 By ck2yuan 將p510_upd_mss()移到g_success裡執行

DATABASE ds
GLOBALS "../../config/top.global"
GLOBALS
  DEFINE g_zaa04_value  LIKE zaa_file.zaa04
  DEFINE g_zaa10_value  LIKE zaa_file.zaa10
  DEFINE g_zaa11_value  LIKE zaa_file.zaa11
  DEFINE g_zaa17_value  LIKE zaa_file.zaa17             #FUN-560079
  DEFINE g_seq_item     LIKE type_file.num5    #NO.FUN-680082 SMALLINT 
END GLOBALS
 
DEFINE mss		RECORD LIKE mss_file.*
DEFINE pmk		RECORD LIKE pmk_file.*
DEFINE pml		RECORD LIKE pml_file.*
DEFINE ver_no           LIKE mss_file.mss_v      #NO.FUN-680082 VARCHAR(2)
DEFINE g_msr          RECORD LIKE msr_file.*    #FUN-A80150 add  #FUN-A90057
DEFINE mxno             LIKE type_file.num10     #NO.FUN-680082 INTEGER
DEFINE summary_flag     LIKE type_file.chr1      #NO.FUN-680082 VARCHAR(1)
DEFINE tm               RECORD                           #BUGNO:7248
                         msm06 LIKE msm_file.msm06,
                         muti     LIKE type_file.chr1,  #FUN-950106
                         muti_v   LIKE msv_file.msv000, #FUN-950106
                         muti_pln LIKE azp_file.azp01,  #FUN-950106
                         muti_doc LIKE pmk_file.pmk01   #FUN-950106
                        END RECORD
DEFINE g_t1             LIKE smy_file.smyslip     #NO.FUN-680082 VARCHAR(5)
DEFINE g_t2             LIKE smy_file.smyslip    #NO.FUN-950106
DEFINE l_za05           LIKE type_file.chr1000    #NO.FUN-680082 VARCHAR(40)
DEFINE g_wc,g_sql	LIKE type_file.chr1000           #No.FUN-580092 HCN
DEFINE i,j,k            LIKE type_file.num10      #NO.FUN-680082 INTEGER
DEFINE g_pmkmksg        LIKE pmk_file.pmkmksg 
DEFINE g_pmksign        LIKE pmk_file.pmksign
DEFINE g_pmkdays        LIKE pmk_file.pmkdays
DEFINE g_pmkprit        LIKE pmk_file.pmkprit
DEFINE g_flag           LIKE type_file.chr1       #NO.FUN-680082 VARCHAR(01)
DEFINE   g_i            LIKE type_file.num5       #NO.FUN-680082 SMALLINT     #count/index for any purpose
DEFINE   g_msg          LIKE type_file.chr1000    #NO.FUN-680082 VARCHAR(72)
DEFINE   g_pmk01        LIKE pmk_file.pmk01             #No.FUN-550002
DEFINE  l_dbs,l_dbs_tra      LIKE type_file.chr21       #FUN-980092
DEFINE g_ima44           LIKE ima_file.ima44
DEFINE g_ima25           LIKE ima_file.ima25
DEFINE g_ima906          LIKE ima_file.ima906
DEFINE g_ima907          LIKE ima_file.ima907
DEFINE g_cnt             LIKE type_file.num10 
DEFINE g_factor          LIKE img_file.img21
DEFINE   g_sma115        LIKE sma_file.sma115
DEFINE   g_sma116        LIKE sma_file.sma116
DEFINE g_change_lang         LIKE type_file.chr1    #NO.FUN-680082 VARCHAR(1)       
DEFINE   p_row,p_col         LIKE type_file.num5    #NO.FUN-680082 SMALLINT
DEFINE g_name        LIKE type_file.chr20         #No.MOD-8A0124
DEFINE g_mss_arr         DYNAMIC ARRAY OF RECORD
                         mss_v LIKE mss_file.mss_v,
                         mss00 LIKE mss_file.mss00
                         END RECORD
DEFINE g_pmk09           LIKE pmk_file.pmk09      #MOD-B50091 add
DEFINE g_pmk22           LIKE pmk_file.pmk22      #MOD-B50091 add
DEFINE g_pml04           LIKE pml_file.pml04      #MOD-B50091 add
DEFINE g_ima915          LIKE ima_file.ima915     #MOD-B50091 add
 
MAIN
   DEFINE   l_flag    LIKE type_file.chr1          #NO.FUN-680082 VARCHAR(01) 
   DEFINE   ls_date   STRING
   DEFINE   ls_cmd    STRING
   DEFINE   li_result LIKE type_file.num5          #NO.FUN-680082 SMALLINT
   DEFINE   l_sql     STRING                       #CHI-AC0040 add
   DEFINE   l_pmk01   LIKE pmk_file.pmk01          #CHI-AC0040 add
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)             #QBE條件
   LET ver_no = ARG_VAL(2)
   LET ls_date = ARG_VAL(3)
   LET pmk.pmk04 = cl_batch_bg_date_convert(ls_date)
   LET pmk.pmk01 = ARG_VAL(4)
   LET pmk.pmk12 = ARG_VAL(5)
   LET pmk.pmk13 = ARG_VAL(6)
   LET summary_flag = ARG_VAL(7)
   LET mxno = ARG_VAL(8)
   LET tm.msm06 = ARG_VAL(9)
   LET tm.muti      = ARG_VAL(10)     #FUN-950106
   LET tm.muti_v    = ARG_VAL(11)     #FUN-950106
   LET tm.muti_pln  = ARG_VAL(12)     #FUN-950106
   LET tm.muti_doc  = ARG_VAL(13)     #FUN-950106
   LET g_bgjob = ARG_VAL(14)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   
   #FUN-A90057(S)
   IF NOT cl_null(ver_no) THEN
      SELECT msr919 INTO g_msr.msr919 FROM msr_file
       WHERE msr_v = ver_no
   END IF         
   #FUN-A90057(E)
   
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AMR")) THEN
      EXIT PROGRAM
   END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
 
 
 
   LET pmk.pmk04 = TODAY
   LET pmk.pmk12 = g_user
   LET summary_flag= '1'
   LET mxno      = 20
   SELECT gen03 INTO pmk.pmk13 FROM gen_file WHERE gen01=g_user
 
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
 
   WHILE TRUE
     #CHI-AC0040---add---start---
      DROP TABLE pmk_tmp_file
 
      #MOD-B80037 将pml_file->pmk_file
      CREATE TEMP TABLE pmk_tmp_file(
         pmk01      LIKE pmk_file.pmk01)
     #CHI-AC0040---add---end---
      IF g_bgjob = "N" THEN
        #TQC-AC0232--begin--modify--------
        #SELECT MAX(smyslip) INTO pmk.pmk01 FROM smy_file
        # WHERE smysys='apm' AND smykind='1'
         LET g_sql=" SELECT MAX(smyslip) FROM smy_file",
                   "  WHERE smysys = 'apm' AND smykind='1' ",
                   "    AND length(smyslip) = ",g_doc_len
         PREPARE r510_smy FROM g_sql
         EXECUTE r510_smy INTO pmk.pmk01
        #TQC-AC0232--end--modify--------
         LET pmk.pmk04 = TODAY
         LET pmk.pmk12 = g_user
         LET summary_flag= '1'
         LET mxno      = 20
         SELECT gen03 INTO pmk.pmk13 FROM gen_file WHERE gen01=g_user
 
         CALL p510_ask()               # Ask for first_flag, data range or exist
         IF cl_sure(18,20) THEN
            LET g_success = 'Y'
            CALL cl_outnam('amrp510') RETURNING g_name   #No.MOD-8A0124
            CALL g_mss_arr.clear()  #FUN-950106
            BEGIN WORK
            CALL p510()
            IF g_success = 'Y' THEN
               IF tm.muti = 'Y' THEN #No.TQC-BB0272
                  CALL cl_outnam('amrp510') RETURNING g_name  #FUN-950106
                  CALL p510_multi() #FUN-950106
                 #CALL p510_upd_mss() #FUN-950106   #MOD-BA0198 mark
                 #CHI-AC0040---add---start---
                  CALL cl_prt(g_name,' ','1',g_len)
               END IF                #No.TQC-BB0272
               IF g_success = 'Y' THEN
                  CALL cl_getmsg('amr-007',g_lang) RETURNING g_msg
                  IF cl_prompt(16,10,g_msg) THEN
                     LET g_success = 'Y' 
                  ELSE
                     LET g_success = 'N'
                  END IF
               END IF
               BEGIN WORK                
              #CHI-AC0040---add---end---
               IF g_success='Y' THEN
                  CALL p510_upd_mss()               #MOD-BA0198 add
                  COMMIT WORK
                  CALL cl_end2(1) RETURNING l_flag
               ELSE
                  ROLLBACK WORK
                 #CHI-AC0040---add---start---
                  LET l_pmk01 = NULL
                  LET l_sql = "SELECT pmk01 FROM pmk_tmp_file "
                  PREPARE pmk_pre FROM l_sql
                  DECLARE pmk_cs SCROLL CURSOR FOR pmk_pre
                  FOREACH pmk_cs INTO l_pmk01
                     DELETE FROM pmk_file WHERE pmk01 =  l_pmk01
                     DELETE FROM pml_file WHERE pml01 =  l_pmk01
                     DELETE FROM pmli_file WHERE pmli01 =  l_pmk01
                  END FOREACH
                 #CHI-AC0040---add---end---
                  CALL cl_end2(2) RETURNING l_flag
               END IF
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p510
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL g_mss_arr.clear()  #FUN-950106
         CALL cl_outnam('amrp510') RETURNING g_name   #No.MOD-B80037
         BEGIN WORK
         CALL p510()
         IF g_success = "Y" THEN
            IF tm.muti = 'Y' THEN #No.TQC-BB0272
               CALL cl_outnam('amrp510') RETURNING g_name   #No.MOD-B80037
               CALL p510_multi() #FUN-950106
              #CALL p510_upd_mss() #FUN-950106    #MOD-BA0198 mark
               CALL cl_prt(g_name,' ','1',g_len)           #CHI-AC0040 add
            END IF                #No.TQC-BB0272
            IF g_success='Y' THEN
               CALL p510_upd_mss()               #MOD-BA0198 add
               COMMIT WORK
            ELSE
               ROLLBACK WORK
              #CHI-AC0040---add---start---
               LET l_pmk01 = NULL
               LET l_sql = "SELECT pmk01 FROM pmk_tmp_file "
               PREPARE pmk_pre2 FROM l_sql
               DECLARE pmk_cs2 SCROLL CURSOR FOR pmk_pre2
               FOREACH pmk_cs2 INTO l_pmk01
                  DELETE FROM pmk_file WHERE pmk01 =  l_pmk01
                  DELETE FROM pml_file WHERE pml01 =  l_pmk01
                  DELETE FROM pmli_file WHERE pmli01 =  l_pmk01
               END FOREACH
              #CHI-AC0040---add---end---
            END IF
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
 END WHILE
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION p510_ask()
   DEFINE   l_gen02     LIKE gen_file.gen02,
            l_gen03     LIKE gen_file.gen03,
            l_gem02     LIKE gem_file.gem02,
            l_n         LIKE type_file.num5          #NO.FUN-680082 SMALLINT
   DEFINE   li_result   LIKE type_file.num5          #NO.FUN-680082 SMALLINT
   DEFINE   l_chk       LIKE type_file. chr1         #No.MOD-840589 add 
   DEFINE   l_chk1      LIKE type_file. chr1         #No.FUN-950106 add
   DEFINE   lc_cmd      LIKE type_file.chr1000       #NO.FUN-680082 VARCHAR(500)
   DEFINE   p_row,p_col LIKE type_file.num5
   DEFINE   l_gev04     LIKE gev_file.gev04          #FUN-950106
   DEFINE   l_sql       STRING                       #FUN-950106
   DEFINE   l_azp03     LIKE azp_file.azp03          #FUN-950106  
 
   LET p_row = 2 LET p_col = 23
   LET l_chk = 'N'                #No.MOD-840589 add
   LET l_chk1 = 'N'               #No.FUN-950106 add
   OPEN WINDOW p510 AT p_row,p_col WITH FORM "amr/42f/amrp510"
        ATTRIBUTE (STYLE = g_win_style)
 
   CALL cl_ui_init()
   CALL cl_opmsg('z')
   CALL cl_set_comp_visible("msr919",g_sma.sma1421='Y')     #FUN-A80150 add  #FUN-A90057
 
WHILE TRUE
 
   CONSTRUCT BY NAME g_wc ON mss01, ima06,ima08, ima67, ima54, mss02, mss03, mss11 #FUN-660020 #darcy:2023/03/30 add ima06
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
     ON ACTION CONTROLP
        CASE
          WHEN INFIELD(mss01)
#FUN-AA0059 --Begin--
         #  CALL cl_init_qry_var()
         #  LET g_qryparam.form = "q_ima"
         #  LET g_qryparam.state = "c"
         #  LET g_qryparam.default1 = mss.mss01
         #  CALL cl_create_qry() RETURNING g_qryparam.multiret
           CALL q_sel_ima( TRUE, "q_ima","",mss.mss01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059 --End--
           DISPLAY g_qryparam.multiret TO mss01
            NEXT FIELD mss01
          #darcy:2023/03/30 add s---
          when infield(ima06)
            call cl_init_qry_var()
            let g_qryparam.form ="q_ima06"
            let g_qryparam.state = "c"
            call cl_create_qry() returning g_qryparam.multiret
            display g_qryparam.multiret to ima06
            next field ima06
          #darcy:2023/03/30 add e---
          WHEN INFIELD(ima54)                       #供應商
            CALL cl_init_qry_var()
            LET g_qryparam.form ="q_pmc1"
            LET g_qryparam.state = "c"
            CALL cl_create_qry() RETURNING g_qryparam.multiret
            DISPLAY g_qryparam.multiret TO ima54
            NEXT FIELD ima54
          WHEN INFIELD(mss02)                                                                                                       
            CALL cl_init_qry_var()                                                                                                  
            LET g_qryparam.form = "q_pmc2"                                                                                          
            LET g_qryparam.state="c"                                                                                                
            LET g_qryparam.default1 = mss.mss02                                                                                     
            CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                      
            DISPLAY g_qryparam.multiret TO mss02                                                                                    
            NEXT FIELD mss02                                                                                                        
         OTHERWISE
            EXIT CASE
       END CASE
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         EXIT CONSTRUCT
      ON ACTION locale                    #genero
          LET g_change_lang = TRUE       #->No.FUN-570125
          EXIT CONSTRUCT
 
       ON ACTION exit              #加離開功能genero
         LET INT_FLAG = 1
         EXIT CONSTRUCT
 
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
   END CONSTRUCT
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p510
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
 
   LET g_bgjob = "N"  #NO.FUN-570125  
   INPUT BY NAME
      ver_no,g_msr.msr919,pmk.pmk04,pmk.pmk01,pmk.pmk12,pmk.pmk13,        #FUN-A80150 add lot_no1  #FUN-A90057
      summary_flag,mxno,tm.msm06,
      tm.muti,tm.muti_pln,tm.muti_v,tm.muti_doc,   #FUN-950106
      g_bgjob         #BUGNO:7248  #NO.FUN-570125
      WITHOUT DEFAULTS
 
      BEFORE INPUT
        LET tm.muti = 'N'
        DISPLAY BY NAME tm.muti
        CALL cl_set_comp_entry("muti_v,muti_pln,muti_doc",FALSE)
        CALL cl_set_comp_required("muti_v,muti_pln,muti_doc",FALSE)
      
     #FUN-A80150---add---start---
      AFTER FIELD ver_no
         IF NOT cl_null(ver_no) THEN
            LET l_sql = "SELECT msr919 FROM msr_file ",  #FUN-A90057
                    " WHERE msr_v= '",ver_no, "'"
            PREPARE ver_pre FROM l_sql
            EXECUTE ver_pre INTO g_msr.msr919
            DISPLAY BY NAME g_msr.msr919  #FUN-A90057
         END IF
     #FUN-A80150---add---end---

      AFTER FIELD pmk01
         IF NOT cl_null(pmk.pmk01) THEN
            CALL s_check_no("apm",pmk.pmk01,"","1","pmk_file","pmk01","")
              RETURNING li_result,pmk.pmk01
            DISPLAY BY NAME pmk.pmk01
            IF (NOT li_result) THEN
               NEXT FIELD pmk01
            END IF
 
            LET g_t1=pmk.pmk01[1,g_doc_len]                     #No.FUN-550002
 
            CALL s_auto_assign_no("apm",pmk.pmk01,pmk.pmk04,"1","pmk_file","pmk01","","","")
              RETURNING li_result,pmk.pmk01
            DISPLAY BY NAME pmk.pmk01
            SELECT smyapr,smysign,smydays,smyprit
              INTO g_pmkmksg,g_pmksign,g_pmkdays,g_pmkprit
              FROM smy_file
            WHERE smyslip=g_t1
            IF STATUS THEN
               LET g_pmkmksg = 'N'
               LET g_pmksign = ''
               LET g_pmkdays = 0
               LET g_pmkprit = ''
            END IF
            IF cl_null(g_pmkmksg) THEN
               LET g_pmkmksg = 'N'
            END IF
            LET l_chk = 'Y'         #No.MOD-840589 add
         END IF
      AFTER FIELD pmk12
         IF NOT cl_null(pmk.pmk12) THEN
            SELECT gen02,gen03 INTO l_gen02,l_gen03
              FROM gen_file   WHERE gen01 = pmk.pmk12
               AND genacti = 'Y'
            IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","gen_file",pmk.pmk12,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660107
               DISPLAY BY NAME pmk.pmk13
               NEXT FIELD pmk12
            END IF
         END IF
 
      BEFORE FIELD pmk13
         IF cl_null(pmk.pmk13) THEN
            LET pmk.pmk13 = l_gen03
         END IF
 
      AFTER FIELD pmk13
         IF NOT cl_null(pmk.pmk13) THEN
            SELECT gem02 INTO l_gem02
              FROM gem_file  WHERE gem01 = pmk.pmk13
               AND gemacti = 'Y'
            IF SQLCA.sqlcode THEN
                CALL cl_err3("sel","gem_file",pmk.pmk13,"",SQLCA.SQLCODE,"","",0)        #NO.FUN-660107
               DISPLAY BY NAME pmk.pmk13
               NEXT FIELD pmk13
            END IF
         END IF
 
      AFTER FIELD msm06        #BUGNO:7248
         IF NOT cl_null(tm.msm06) THEN
            SELECT COUNT(*) INTO l_n FROM gem_file WHERE gem01 = tm.msm06
            IF l_n = 0 THEN
               CALL cl_err(tm.msm06,100,0)
               NEXT FIELD msm06
            END IF
         END IF
 
      AFTER FIELD mxno                                                                                                              
         IF NOT cl_null(mxno) THEN                                                                                                  
            IF mxno <0 THEN                                                                                                         
               LET mxno =0                                                                                                          
               NEXT FIELD mxno                                                                                                      
            END IF                                                                                                                  
         END IF                                                                                                                     
  
     ON CHANGE muti
       IF tm.muti = 'N' THEN
          LET tm.muti_v = NULL
          LET tm.muti_pln = NULL
          LET tm.muti_doc = NULL
          DISPLAY BY NAME tm.muti_v
          DISPLAY BY NAME tm.muti_pln
          DISPLAY BY NAME tm.muti_doc
          CALL cl_set_comp_entry("muti_v,muti_pln,muti_doc",FALSE)
          CALL cl_set_comp_required("muti_v,muti_pln,muti_doc",FALSE)
       ELSE
          CALL cl_set_comp_entry("muti_v,muti_pln,muti_doc",TRUE)
          CALL cl_set_comp_required("muti_v,muti_pln,muti_doc",TRUE)
       END IF
 
     AFTER FIELD muti
       IF tm.muti = 'N' THEN
          CALL cl_set_comp_entry("muti_v,muti_pln,muti_doc",FALSE)
          CALL cl_set_comp_required("muti_v,muti_pln,muti_doc",FALSE)
       ELSE
          CALL cl_set_comp_entry("muti_v,muti_pln,muti_doc",TRUE)
          CALL cl_set_comp_required("muti_v,muti_pln,muti_doc",TRUE)
       END IF
 
     BEFORE FIELD muti_v
       IF cl_null(tm.muti_pln) THEN
          NEXT FIELD muti_pln
       END IF
 
     AFTER FIELD muti_v
       IF NOT cl_null(tm.muti_v) THEN
          SELECT azp03 INTO l_azp03 FROM azp_file
           WHERE azp01 = tm.muti_pln
          LET l_n = 0
          LET l_azp03 = s_dbstring (l_azp03)
          LET l_sql = "SELECT COUNT(*) ",
                      #"  FROM ",l_azp03 CLIPPED," msw_file",
                      "  FROM ",cl_get_target_table(tm.muti_pln,'msw_file'), #FUN-A50102
                      " WHERE msw000 = '",tm.muti_v,"'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,tm.muti_pln) RETURNING l_sql #FUN-A50102
          PREPARE prep_count FROM l_sql
          EXECUTE prep_count INTO l_n
          IF l_n <= 0 THEN
             CALL cl_err('','zl-998',0)
             NEXT FIELD muti_v
          END IF
       END IF
 
     AFTER FIELD muti_pln
      IF NOT cl_null(tm.muti_pln) THEN                                                                                  
         LET l_n = 0 
         SELECT COUNT(*) INTO l_n FROM azp_file
          WHERE azp01 = tm.muti_pln
         IF l_n <= 0 THEN
            CALL cl_err(tm.muti_pln,'aap-025',0)
            NEXT FIELD muti_pln                                                                                                
         END IF                                                                                                                                                                                                   
      END IF
      
     AFTER FIELD muti_doc
       IF NOT cl_null(tm.muti_doc) THEN
            CALL s_check_no("apm",tm.muti_doc,"","1","pmk_file","pmk01","")
              RETURNING li_result,tm.muti_doc
            DISPLAY BY NAME tm.muti_doc
            IF (NOT li_result) THEN
               NEXT FIELD muti_doc
            END IF
 
            LET g_t2=tm.muti_doc[1,g_doc_len]                     #No.FUN-550002
 
            CALL s_auto_assign_no("apm",tm.muti_doc,pmk.pmk04,"1","pmk_file","pmk01","","","")
              RETURNING li_result,tm.muti_doc
            DISPLAY BY NAME tm.muti_doc
            SELECT smyapr,smysign,smydays,smyprit
              INTO g_pmkmksg,g_pmksign,g_pmkdays,g_pmkprit
              FROM smy_file
            WHERE smyslip=g_t2
            IF STATUS THEN
               LET g_pmkmksg = 'N'
               LET g_pmksign = ''
               LET g_pmkdays = 0
               LET g_pmkprit = ''
            END IF
            IF cl_null(g_pmkmksg) THEN
               LET g_pmkmksg = 'N'
            END IF
            LET l_chk1 = 'Y'         
         END IF
 
   AFTER INPUT
      IF l_chk ='N' THEN 
         CALL s_check_no("apm",pmk.pmk01,"","1","pmk_file","pmk01","")
           RETURNING li_result,pmk.pmk01
         DISPLAY BY NAME pmk.pmk01
         IF (NOT li_result) THEN
            NEXT FIELD pmk01
         END IF
         LET g_t1=pmk.pmk01[1,g_doc_len]      
         SELECT smyapr,smysign,smydays,smyprit
           INTO g_pmkmksg,g_pmksign,g_pmkdays,g_pmkprit
           FROM smy_file
         WHERE smyslip=g_t1
         IF STATUS THEN
            LET g_pmkmksg = 'N'
            LET g_pmksign = ''
            LET g_pmkdays = 0
            LET g_pmkprit = ''
         END IF
         IF cl_null(g_pmkmksg) THEN
            LET g_pmkmksg = 'N'
         END IF
      END IF
     IF NOT INT_FLAG AND tm.muti = 'Y' THEN
      IF l_chk1 ='N' THEN 
         CALL s_check_no("apm",tm.muti_doc,"","1","pmk_file","pmk01","")                                                      
              RETURNING li_result,tm.muti_doc
         DISPLAY BY NAME tm.muti_doc
         IF (NOT li_result) THEN
            NEXT FIELD muti_doc
         END IF
         LET g_t2=tm.muti_doc[1,g_doc_len]      
         SELECT smyapr,smysign,smydays,smyprit
           INTO g_pmkmksg,g_pmksign,g_pmkdays,g_pmkprit
           FROM smy_file
         WHERE smyslip=g_t2
         IF STATUS THEN
            LET g_pmkmksg = 'N'
            LET g_pmksign = ''
            LET g_pmkdays = 0
            LET g_pmkprit = ''
         END IF
         IF cl_null(g_pmkmksg) THEN
            LET g_pmkmksg = 'N'
         END IF
      END IF
     END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmk01) #order nubmer
                LET g_t1=pmk.pmk01[1,g_doc_len]             #No.FUN-550002
               CALL q_smy(FALSE,FALSE,g_t1,'APM','1') RETURNING g_t1 #TQC-670008
               LET pmk.pmk01=g_t1                     #No.FUN-550055
               DISPLAY BY NAME pmk.pmk01
               NEXT FIELD pmk01
            WHEN INFIELD(pmk12) #請購員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = pmk.pmk12
               CALL cl_create_qry() RETURNING pmk.pmk12
               DISPLAY BY NAME pmk.pmk12
               NEXT FIELD pmk12
            WHEN INFIELD(pmk13) #請購Dept
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = pmk.pmk13
               CALL cl_create_qry() RETURNING pmk.pmk13
               DISPLAY BY NAME pmk.pmk13
               NEXT FIELD pmk13
            WHEN INFIELD(msm06) #生產部門
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gem"
               LET g_qryparam.default1 = tm.msm06
               CALL cl_create_qry() RETURNING tm.msm06
               DISPLAY BY NAME tm.msm06
               NEXT FIELD msm06
             WHEN INFIELD(muti_doc) #order nubmer
               LET g_t2=tm.muti_doc[1,g_doc_len]
               CALL q_smy(FALSE,FALSE,g_t2,'APM','1') RETURNING g_t2
               LET tm.muti_doc=g_t2
               DISPLAY BY NAME tm.muti_doc
               NEXT FIELD muti_doc
             WHEN INFIELD(muti_pln)
               CALL cl_init_qry_var()                                                                                       
               LET g_qryparam.form = "q_azp"                                                                                
               LET g_qryparam.default1 = tm.muti_pln
               CALL cl_create_qry() RETURNING tm.muti_pln                                                                       
               DISPLAY BY NAME tm.muti_pln                                                                                      
               NEXT FIELD muti_pln
            OTHERWISE EXIT CASE
         END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      ON ACTION exit  #加離開功能genero
         LET INT_FLAG = 1
         EXIT INPUT
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
     ON ACTION locale
        LET g_change_lang = TRUE        #->No.FUN-570125
        EXIT INPUT
 
   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CONTINUE WHILE
   END IF
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW p510
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   LET g_t1=pmk.pmk01[1,g_doc_len] #FUN-950106
   LET g_t2=tm.muti_doc[1,g_doc_len] #FUN-950106
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "amrp510"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('amrp510','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " '",g_wc CLIPPED,"'",
                      " '",ver_no CLIPPED,"'",
                      " '",pmk.pmk04 CLIPPED,"'",
                      " '",pmk.pmk01 CLIPPED,"'",
                      " '",pmk.pmk12 CLIPPED,"'",
                      " '",pmk.pmk13 CLIPPED,"'",
                      " '",summary_flag CLIPPED,"'",
                      " '",mxno CLIPPED,"'",
                      " '",tm.msm06 CLIPPED,"'",
                      " '",tm.muti CLIPPED,"'",     #FUN-950106
                      " '",tm.muti_v CLIPPED,"'",   #FUN-950106
                      " '",tm.muti_pln CLIPPED,"'", #FUN-950106
                      " '",tm.muti_doc CLIPPED,"'", #FUN-950106
                      " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('amrp510',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p510
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
END WHILE
END FUNCTION
 
FUNCTION p510()
   DEFINE l_name        LIKE type_file.chr20         #NO.FUN-680082 VARCHAR(20)
   DEFINE l_order	LIKE pmk_file.pmk09          #NO.FUN-680082 VARCHAR(10)
   DEFINE l_ima06	LIKE ima_file.ima06          #NO.FUN-680082 VARCHAR(6)
   DEFINE l_ima43       LIKE ima_file.ima43          #MOD-610115
   DEFINE l_pmc15       LIKE pmc_file.pmc15
   DEFINE l_pmk10       LIKE pmk_file.pmk10
   DEFINE l_ima54       LIKE ima_file.ima54  #FUN-660020
   DEFINE l_i,l_cnt     LIKE type_file.num5          #NO.FUN-680082 SMALLINT
   DEFINE l_zaa02       LIKE zaa_file.zaa02          #No.FUN-580005
   DEFINE l_cnt0        LIKE type_file.num5          #NO.FUN-6B0064
   DEFINE l_msv13       LIKE msv_file.msv13          #FUN-950106
   DEFINE l_sql         STRING                       #FUN-950106
   DEFINE l_azp03       LIKE azp_file.azp03          #FUN-950106
 
   LET g_sql="SELECT mss_file.*, ima06, ima43,pmc15,ima54", #FUN-660020
             "  FROM mss_file LEFT OUTER JOIN pmc_file ON mss_file.mss02=pmc_file.pmc01, ima_file ",
             " WHERE mss01 NOT LIKE 'K%' AND  mss01=ima01 AND mss09 > 0 AND mss10='N'",
             " AND mss_v='",ver_no,"'",
             "   AND ",g_wc CLIPPED
   CASE WHEN summary_flag='1'
        LET g_sql = g_sql CLIPPED," ORDER BY ima43,mss01, mss03"
        WHEN summary_flag='2'
        LET g_sql = g_sql CLIPPED," ORDER BY ima06,mss01, mss03"
        WHEN summary_flag='3'
        LET g_sql = g_sql CLIPPED," ORDER BY pmc15,mss01, mss03"
        WHEN summary_flag='4'
        LET g_sql = g_sql CLIPPED," ORDER BY ima54,mss01, mss03"
        OTHERWISE
        LET g_sql = g_sql CLIPPED," ORDER BY mss01, mss03"
   END CASE
   PREPARE p510_p FROM g_sql
   DECLARE p510_c CURSOR FOR p510_p
    LET l_name = g_name  #No.MOD-8A0124  
     SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
     IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
        LET g_zaa[37].zaa06 = "Y"
        LET g_zaa[38].zaa06 = "Y"
        LET g_zaa[40].zaa06 = "N"
        LET g_zaa[41].zaa06 = "N"
     ELSE
        LET g_zaa[37].zaa06 = "N"
        LET g_zaa[38].zaa06 = "N"
        LET g_zaa[40].zaa06 = "Y"
        LET g_zaa[41].zaa06 = "Y"
     END IF
     IF g_sma115 = "Y" OR g_sma116 MATCHES '[13]' THEN    #No.FUN-610076
        LET g_zaa[39].zaa06 = "N"
     ELSE
        LET g_zaa[39].zaa06 = "Y"
     END IF
     CALL cl_prt_pos_len()
   LET l_cnt0 = 0   #FUN-6B0064
   START REPORT p510_rep TO l_name
   FOREACH p510_c INTO mss.*, l_ima06, l_ima43,l_pmc15,l_ima54 #FUN-660020
      IF tm.muti='Y' THEN
 
 
        LET g_plant_new = tm.muti_pln CLIPPED
        CALL s_getdbs()
        LET l_dbs = g_dbs_new          #BASE DB
 
        CALL s_gettrandbs()
        LET l_dbs_tra = g_dbs_tra      #TRAN DB
 
 
         LET l_msv13 = 0
         LET l_sql ="SELECT msv13 ",
                    #"  FROM ",l_dbs_tra CLIPPED," msv_file ",  #FUN-980092
                    "  FROM ",cl_get_target_table(g_plant_new,'msv_file'), #FUN-A50102
                    " WHERE msv000='",tm.muti_v,"'",
                    "   AND msv01 ='",mss.mss01,"'",
                    "   AND msv02 ='",mss.mss02,"'",
                    "   AND msv03 ='",mss.mss03,"'",
                    "   AND msv031='",g_plant,"'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql  
         CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-980092
         PREPARE p510_muti_p1 FROM l_sql
         DECLARE p510_muti_c1 CURSOR FOR p510_muti_p1
         FOREACH p510_muti_c1 INTO l_msv13
            EXIT FOREACH
         END FOREACH
         IF cl_null(l_msv13) THEN
            LET l_msv13 = 0
         END IF
         IF l_msv13 > 0 THEN
            IF mss.mss09 - l_msv13 > 0 THEN
               LET mss.mss09 = mss.mss09 - l_msv13              
            ELSE
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      
   LET l_pmk10 = ' '
   IF NOT cl_null(tm.msm06) THEN        #BUGNO:7248
     SELECT msm02 INTO l_pmk10 FROM msm_file    # 地址代碼
      WHERE msm01 = mss.mss01
        AND msm06 = tm.msm06                    # 生產部門
     IF NOT cl_null(l_pmk10) THEN
       LET l_pmc15 = l_pmk10
     END IF
   END IF
   IF l_pmc15 IS NULL THEN LET l_pmc15=' ' END IF
 
   CALL p500_pmk_default(l_pmc15,FALSE) #FUN-950106
      CASE WHEN summary_flag='1' LET l_order=l_ima43
           WHEN summary_flag='2' LET l_order=l_ima06
           WHEN summary_flag='3' LET l_order=l_pmc15
           WHEN summary_flag='4' LET l_order=l_ima54
           OTHERWISE             LET l_order=' '
      END CASE

      #MOD-B50091 add --start--
      #請購料件/供應商控制
      LET g_pml04 = mss.mss01
      LET g_pmk09 = mss.mss02
      IF (g_pml04 != 'MISC') THEN
         IF summary_flag='4' THEN
            LET g_pmk09 = l_order
         END IF
         #廠商編號(pmk09)若有值,應依供應商基本資料檔帶出基本資料
         IF NOT cl_null(g_pmk09) AND g_pmk09 != ' ' THEN
            SELECT pmc22 INTO g_pmk22
              FROM pmc_file
             WHERE pmc01 = g_pmk09 AND pmc30 IN ('1','3')
             IF SQLCA.sqlcode THEN
                LET g_pmk22=NULL 
             END IF
         END IF
         SELECT ima915 INTO g_ima915 FROM ima_file WHERE ima01=g_pml04 
         IF g_ima915='1' OR g_ima915='3' AND NOT cl_null(g_pmk09) AND NOT cl_null(g_pmk22) THEN
            CALL p510_pmh()
            IF NOT cl_null(g_errno) THEN
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      #MOD-B50091 add--end--

      OUTPUT TO REPORT p510_rep(l_order,mss.*,FALSE) #FUN-950106
      LET l_cnt0 = l_cnt0 + 1  #FUN-6B0064
   END FOREACH
   FINISH REPORT p510_rep
  #CHI-AC0040---add---start---
    IF g_success = 'Y' THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
  #CHI-AC0040---add---end---
   CALL cl_prt(l_name,' ','1',g_len)
  #CHI-AC0040---mark---start---
  #IF l_cnt0 > 0 AND g_success = 'Y' THEN  #FUN-950106 add     #MOD-AC0058 add g_success='Y'
  #   CALL cl_getmsg('amr-077',g_lang) RETURNING g_msg
  #   IF cl_prompt(16,10,g_msg) THEN
  #      LET g_success='Y'
  #   ELSE
  #      LET g_success='N'
  #   END IF
  #END IF    #FUN-950106
  #CHI-AC0040---mark---end---
END FUNCTION

#MOD-B50091 add --start--
#系統參數設料件/供應商須存在
FUNCTION p510_pmh()  #供應廠商
   DEFINE l_pmhacti   LIKE pmh_file.pmhacti
   DEFINE l_pmh05     LIKE pmh_file.pmh05

   LET g_errno = " "

   SELECT pmhacti,pmh05 INTO l_pmhacti,l_pmh05
     FROM pmh_file
    WHERE pmh01 = g_pml04
      AND pmh02 = g_pmk09
      AND pmh13 = g_pmk22
      AND pmh22 = '1' AND pmh21 =' '
      AND pmh23 = ' '        
      AND pmhacti = 'Y' 

   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg0031'
         LET l_pmhacti = NULL
      WHEN l_pmhacti = 'N'
         LET g_errno = '9028'
      WHEN l_pmh05 MATCHES '[12]'
         LET g_errno = 'mfg3043' 
      OTHERWISE
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE

END FUNCTION
#MOD-B50091 add --end--
 
REPORT p510_rep(l_order, mss, p_multi)  #FUN-950106
  DEFINE mss		RECORD LIKE mss_file.*
  DEFINE l_order	LIKE pmk_file.pmk09          #NO.FUN-680082 VARCHAR(10)
  DEFINE l_ima49        LIKE ima_file.ima49
  DEFINE l_ima491       LIKE ima_file.ima491
  DEFINE l_date         LIKE type_file.dat           #NO.FUN-680082 DATE
  DEFINE l_pml85        LIKE pml_file.pml85
  DEFINE l_pml82        LIKE pml_file.pml82
  DEFINE l_pml87        LIKE pml_file.pml87
  DEFINE l_str2         LIKE type_file.chr1000       #NO.FUN-680082 VARCHAR(100) 
  DEFINE l_ima906       LIKE ima_file.ima906
  DEFINE l_last_sw      LIKE type_file.chr1          #TQC-6B0011 add
  DEFINE l_pmli         RECORD LIKE pmli_file.*      #NO.FUN-7B0018
  DEFINE l_cnt          LIKE type_file.num5           #FUN-950106
  DEFINE p_multi        LIKE type_file.num5           #FUN-950106        
 
  OUTPUT
     TOP MARGIN g_top_margin
     LEFT MARGIN g_left_margin 
     BOTTOM MARGIN g_bottom_margin
     PAGE LENGTH g_page_line   #No.MOD-580242
 
  ORDER EXTERNAL BY l_order, mss.mss01, mss.mss03
  FORMAT
    PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company))/2)+1,g_company
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno=g_pageno+1
      LET pageno_total=PAGENO USING '<<<',"/pageno"
      PRINT g_head CLIPPED,pageno_total
      PRINT g_dash[1,g_len]
      PRINT g_x[31] CLIPPED,g_x[32] CLIPPED,g_x[33] CLIPPED,g_x[34] CLIPPED,
            g_x[35] CLIPPED,g_x[36] CLIPPED,g_x[37] CLIPPED,g_x[38] CLIPPED,
            g_x[39] CLIPPED,g_x[40] CLIPPED,g_x[41] CLIPPED,g_x[42] CLIPPED   #No.FUN-580005
      PRINT g_dash1
      LET l_last_sw = 'n'   #TQC-6B0011 add
 
    BEFORE GROUP OF l_order
      IF summary_flag='4' THEN
         LET pmk.pmk09 = l_order
      END IF
      CALL ins_pmk(p_multi) #FUN-950106
#     PRINT                                     #No:TQC-AC0234 
      PRINT COLUMN g_c[31],g_pmk01,             #No.FUN-550002
           #COLUMN g_c[32],l_order[1,6];        #MOD-C40217 mark
            COLUMN g_c[32],l_order[1,10];       #MOD-C40217
 
    ON EVERY ROW
      IF pml.pml02>=mxno THEN
        IF summary_flag='4' THEN
           LET pmk.pmk09 = l_order
        END IF
         CALL ins_pmk(p_multi) #FUN-950106
         PRINT
         PRINT COLUMN g_c[31],g_pmk01,          #No.FUN-550002
              #COLUMN g_c[32],l_order[1,6];     #MOD-C40217 mark
               COLUMN g_c[32],l_order[1,10];    #MOD-C40217
      END IF
      LET pml.pml02 =pml.pml02+1
      IF g_bgjob = 'N' THEN #NO.FUN-570125 
          MESSAGE 'ins pml:',pml.pml01,' ',pml.pml02
          CALL ui.Interface.refresh()
      END IF
      LET pml.pml04 =mss.mss01
      LET pml.pml041=NULL
      LET pml.pml07 =NULL
      LET pml.pml08 =NULL
      LET pml.pml09 =1
      SELECT ima02,ima39,ima44,ima25,ima44_fac,ima907,ima908,         #No.FUN-580005
             ima913,ima914   #No.FUN-630040
         INTO pml.pml041,pml.pml40,pml.pml07,pml.pml08,pml.pml09,pml.pml83,pml.pml86,    #No.FUN-580005
              pml.pml190,pml.pml191   #No.FUN-630040
             FROM ima_file WHERE ima01=pml.pml04
      IF cl_null(pml.pml190) THEN LET pml.pml190 = 'N' END IF   #No.MOD-740053 add
      LET pml.pml192 = "N"   #No.FUN-630040
      IF pml.pml07 != pml.pml08 THEN    # 00/08/06 add by Carol
         LET mss.mss09=mss.mss09 / pml.pml09
      END IF
      LET pml.pml11 ='N'
     #LET pml.pml13 =g_sma.sma401
      CALL s_overate(pml.pml04) RETURNING pml.pml13   #Mod MOD-AB0070
      LET pml.pml14 =g_sma.sma886[1,1]         #部份交貨
      LET pml.pml15 =g_sma.sma886[2,2]         #提前交貨
      IF g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN   #立即確認   #No:CHI-880032 modify
         LET pml.pml16='1'
      ELSE
         LET pml.pml16='0'
      END IF
      LET pml.pml18=mss.mss03
      CALL s_aday(pml.pml18,-1,0) RETURNING pml.pml18       #BUGNO:7248
 
 
      LET pml.pml123=mss.mss02
      LET pml.pml20=mss.mss09
      LET pml.pml20=s_digqty(pml.pml20,pml.pml07)   #FUN-910088--add--
      LET pml.pml21=0
      LET pml.pml30=0
      LET pml.pml31=0
      LET pml.pml32=0
      SELECT ima49,ima491 INTO l_ima49,l_ima491
       FROM ima_file WHERE ima01=pml.pml04
      IF cl_null(l_ima49) THEN LET l_ima49=0 END IF
      IF cl_null(l_ima491) THEN LET l_ima491=0 END IF
 
      LET pml.pml35=pml.pml18
      CALL s_aday(pml.pml35,-1,l_ima491) RETURNING pml.pml34
 
 
 
 
      CALL s_aday(pml.pml34,-1,l_ima49) RETURNING pml.pml33
      LET pml.pml38='Y'
      LET pml.pml41=mss.mss_v,'-',mss.mss00 USING '&&&&&&'
      LET pml.pml42='0'
      LET pml.pml44=0
      SELECT ima906 INTO l_ima906 FROM ima_file
                   WHERE ima01=pml.pml04
      IF g_sma.sma115 = 'Y' THEN
         SELECT ima25,ima44,ima906,ima907 
           INTO g_ima25,g_ima44,g_ima906,g_ima907
           FROM ima_file
          WHERE ima01=pml.pml04
         IF SQLCA.sqlcode =100 THEN                                                  
            IF pml.pml04 MATCHES 'MISC*' THEN                                
               SELECT ima25,ima44,ima906,ima907 
                 INTO g_ima25,g_ima44,g_ima906,g_ima907                               
                 FROM ima_file WHERE ima01='MISC'                                    
            END IF                                                                   
         END IF                                                                      
         IF cl_null(g_ima44) THEN LET g_ima44 = g_ima25 END IF
         LET pml.pml80=pml.pml07
         LET g_factor = 1
         CALL s_umfchk(pml.pml04,pml.pml80,g_ima44)
           RETURNING g_cnt,g_factor
         IF g_cnt = 1 THEN
            LET g_factor = 1
         END IF
         LET pml.pml81=g_factor
         LET pml.pml82=pml.pml20
         LET pml.pml83=g_ima907
         LET g_factor = 1
         CALL s_umfchk(pml.pml04,pml.pml83,g_ima44)
           RETURNING g_cnt,g_factor
         IF g_cnt = 1 THEN
            LET g_factor = 1
         END IF
         LET pml.pml84=g_factor
         LET pml.pml85=0
         IF g_ima906 = '3' THEN
            LET g_factor = 1
            CALL s_umfchk(pml.pml04,pml.pml80,pml.pml83)
              RETURNING g_cnt,g_factor
            IF g_cnt = 1 THEN
               LET g_factor = 1
            END IF
            LET pml.pml85=pml.pml82*g_factor
            LET pml.pml85=s_digqty(pml.pml85,pml.pml83)   #FUN-910088--add--
         END IF
      END IF
      IF g_sma.sma116 MATCHES '[02]' THEN    #No:MOD-960188  add
         LET pml.pml86=pml.pml07
         LET pml.pml87=pml.pml20
      END IF                                 #No:MOD-960188  add                                                       
      LET l_str2 = ""
       IF g_sma115 = "Y" THEN
         CASE l_ima906
            WHEN "2"
               CALL cl_remove_zero(pml.pml85) RETURNING pml.pml85
               LET l_str2 = l_pml85,pml.pml83 CLIPPED
               IF cl_null(pml.pml85) OR pml.pml85 = 0 THEN
                  CALL cl_remove_zero(pml.pml82) RETURNING l_pml82
                  LET l_str2 = l_pml82,pml.pml80 CLIPPED
               ELSE
                  IF NOT cl_null(pml.pml82) AND pml.pml82 > 0 THEN
                     CALL cl_remove_zero(pml.pml82) RETURNING l_pml82
                     LET l_str2 = l_str2 CLIPPED,',',l_pml82,pml.pml80 CLIPPED
                  END IF
              END IF
            WHEN "3"
              IF NOT cl_null(pml.pml85) AND pml.pml85 > 0 THEN
                 CALL cl_remove_zero(pml.pml85) RETURNING l_pml85
                 LET l_str2 = l_pml85,pml.pml83 CLIPPED
              END IF
         END CASE
      END IF
      CALL p510_set_pml87()     #No:MOD-960188  add
      IF g_sma.sma116 MATCHES '[13]' THEN    #No.FUN-610076
         IF pml.pml80 <> pml.pml86 THEN
            CALL cl_remove_zero(pml.pml87) RETURNING l_pml87
            LET l_str2 = l_str2 CLIPPED,"(",l_pml87,pml.pml86 CLIPPED,")"
         END IF
      END IF
      PRINT COLUMN g_c[33],pml.pml41 CLIPPED,
            COLUMN g_c[34],pml.pml02 USING '###&', #FUN-590118
            COLUMN g_c[35],pml.pml04 CLIPPED, #FUN-5B0014   [1,20] CLIPPED,
            COLUMN g_c[36],pml.pml041 CLIPPED, #FUN-5B0014  [1,30] CLIPPED,
            COLUMN g_c[37],pml.pml07 CLIPPED,
            COLUMN g_c[38],cl_numfor(pml.pml20,38,3),
            COLUMN g_c[39],l_str2 CLIPPED,
            COLUMN g_c[40],pml.pml86 CLIPPED,
            COLUMN g_c[41],cl_numfor(pml.pml87,41,3),
            COLUMN g_c[42],pml.pml33 CLIPPED
      LET pml.pml930=s_costcenter(pmk.pmk13) #FUN-670061
      IF mss.mss11 < g_today THEN            #No.FUN-920183
         LET pml.pml91 = 'Y'                 #No.FUN-920183
      ELSE                                   #No.FUN-920183
         LET pml.pml91 = 'N'                 #No.FUN-920183
      END IF                                 #No.FUN-920183
      LET pml.pmlplant = g_plant     #FUN-980004 add
      LET pml.pmllegal = g_legal     #FUN-980004 add
      LET pml.pml49 = '1'  #No.FUN-870007
      LET pml.pml50 = '1'  #No.FUN-870007
      LET pml.pml54 = '2'  #No.FUN-870007
      LET pml.pml56 = '1'  #No.FUN-870007
      LET pml.pml92 = 'N'  #FUN-9B0023
      LET pml.pml919 = g_msr.msr919     #FUN-A80150  add  #FUN-A90057
      INSERT INTO pml_file VALUES(pml.*)
      IF STATUS THEN 
       CALL cl_err3("ins","pml_file",pml.pml01,pml.pml02,STATUS,"","ins pml:",1)        #NO.FUN-660107 
       CALL cl_batch_bg_javamail("N")     # No.FUN-570125
      #EXIT PROGRAM           #MOD-AC0058 mark 
       LET g_success = 'N'    #MOD-AC0058 add
      END IF
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmli.* TO NULL
         LET l_pmli.pmli01 = pml.pml01
         LET l_pmli.pmli02 = pml.pml02
         IF NOT s_ins_pmli(l_pmli.*,'') THEN
            CALL cl_batch_bg_javamail("N")
           #EXIT PROGRAM           #MOD-AC0058 mark 
            LET g_success = 'N'    #MOD-AC0058 add
         END IF
      END IF
 
      LET l_cnt = g_mss_arr.getlength()
      LET l_cnt = l_cnt + 1
      LET g_mss_arr[l_cnt].mss_v = mss.mss_v
      LET g_mss_arr[l_cnt].mss00 = mss.mss00
 
     ON LAST ROW
       #str MOD-A60091 add
        IF g_zz05 = 'Y' THEN
           CALL cl_wcchp(g_wc,'mss01,ima06,ima08,ima67,ima54,mss02,mss03,mss11') #darcy:2023/03/30 add ima06
                RETURNING g_wc
           PRINT g_dash[1,g_len]
           CALL cl_prt_pos_wc(g_wc)
        END IF
       #end MOD-A60091 add
        PRINT g_dash[1,g_len]
        LET l_last_sw = 'y'
        PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
 
     PAGE TRAILER
        IF l_last_sw = 'n'
           THEN PRINT g_dash[1,g_len]
                PRINT g_x[4] CLIPPED,g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
           ELSE SKIP 2 LINE
        END IF
 
END REPORT
 
 FUNCTION p510_set_pml87()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac  #No.FUN-680136 DECIMAL(16,8)
 
    SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
      FROM ima_file WHERE ima01=pml.pml04
    IF SQLCA.sqlcode =100 THEN
       IF pml.pml04 MATCHES 'MISC*' THEN
          SELECT ima25,ima44,ima906 INTO l_ima25,l_ima44,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima44) THEN LET l_ima44 = l_ima25 END IF
 
    LET l_fac2=pml.pml84
    LET l_qty2=pml.pml85
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=pml.pml81
       LET l_qty1=pml.pml82
    ELSE
       LET l_fac1=1
       LET l_qty1=pml.pml20
       CALL s_umfchk(pml.pml04,pml.pml07,l_ima44)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
    IF g_sma.sma115 = 'Y' THEN
       CASE l_ima906
          WHEN '1' LET l_tot=l_qty1*l_fac1
          WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
          WHEN '3' LET l_tot=l_qty1*l_fac1
       END CASE
    ELSE  #不使用雙單位
       LET l_tot=l_qty1*l_fac1
    END IF
    IF cl_null(l_tot) THEN LET l_tot = 0 END IF
    LET l_factor = 1
    CALL s_umfchk(pml.pml04,l_ima44,pml.pml86)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET pml.pml87 = l_tot
    LET pml.pml87 = s_digqty(pml.pml87,pml.pml86)   #FUN-910088--add--
 END FUNCTION
 
FUNCTION p500_pmk_default(p_pmc15,p_multi) #FUN-950106
   DEFINE    p_pmc15       LIKE    pmc_file.pmc15
   DEFINE    p_multi      LIKE type_file.num5   #FUN-950106
   
   IF p_multi THEN
      LET pmk.pmk02='TAP'
   ELSE
      LET pmk.pmk02='REG'
   END IF
      LET pmk.pmk10=p_pmc15
      LET pmk.pmk09=mss.mss02
      IF pmk.pmk09='-' THEN LET pmk.pmk09=' ' END IF   #CHI-9A0046
      IF g_smy.smydmy4='Y' AND g_smy.smyapr <> 'Y' THEN   #立即確認   #No:CHI-880032 modify
         LET pmk.pmk18='Y'
         LET pmk.pmk25='1'
      ELSE
         LET pmk.pmk18='N'
         LET pmk.pmk25='0'
      END IF
      LET pmk.pmk27=TODAY
      LET pmk.pmk30='Y'
      LET pmk.pmk31=YEAR(pmk.pmk04)
      LET pmk.pmk32=MONTH(pmk.pmk04)
      LET pmk.pmk40=0
      LET pmk.pmk401=0
      LET pmk.pmk42=1
      LET pmk.pmk43=0
      LET pmk.pmk45='Y'
      LET pmk.pmkprsw='Y'
      LET pmk.pmkprno=0
      LET pmk.pmkmksg=g_pmkmksg  #bugno:5881 改為 g_pmkmksg
      LET pmk.pmksign=g_pmksign  #bugno:5881 add
      LET pmk.pmkdays=g_pmkdays  #bugno:5881 add
      LET pmk.pmkprit=g_pmkprit  #bugno:5881 add
      LET pmk.pmkacti='Y'
      LET pmk.pmkuser=g_user
      LET pmk.pmkgrup=g_grup
      LET pmk.pmkdate=TODAY
END FUNCTION
 
FUNCTION ins_pmk(p_multi)  #FUN-950106
DEFINE li_result   LIKE type_file.num5          #NO.FUN-680082 SMALLINT
DEFINE p_multi     LIKE type_file.num5   #FUN-950106
 
   IF p_multi THEN
      LET pmk.pmk01 = g_t2
   ELSE
      LET pmk.pmk01 = g_t1
   END IF
   CALL s_auto_assign_no("apm",pmk.pmk01,pmk.pmk04,"1","pmk_file","pmk01", "","","")
   RETURNING li_result,pmk.pmk01
   IF (NOT li_result) THEN
      IF p_multi THEN
         DISPLAY pmk.pmk01 TO tm.muti_doc
      ELSE
         DISPLAY BY NAME pmk.pmk01
      END IF
   END IF
 
   LET pmk.pmkplant = g_plant #FUN-980004 add
   LET pmk.pmklegal = g_legal #FUN-980004 add
   LET pmk.pmk46='1'          #No.FUN-870007
   LET pmk.pmkoriu = g_user   #No.FUN-980030 10/01/04
   LET pmk.pmkorig = g_grup   #No.FUN-980030 10/01/04

  #str MOD-A40176 add
   #廠商編號(pmk09)若有值,應依供應商基本資料檔帶出基本資料
   IF NOT cl_null(pmk.pmk09) AND pmk.pmk09 != ' ' THEN
      #帳單地址/付款方式/稅別/幣別/價格條件
      SELECT pmc16,pmc17,pmc47,pmc22,pmc49
        INTO pmk.pmk11,pmk.pmk20,pmk.pmk21,pmk.pmk22,pmk.pmk41
        FROM pmc_file
       WHERE pmc01 = pmk.pmk09 AND pmc30 MATCHES '[13]'
      #匯率
      IF NOT cl_null(pmk.pmk22) THEN
         IF g_aza.aza17 = pmk.pmk22 THEN   #本幣
            LET pmk.pmk42 = 1
         ELSE
            CALL s_curr3(pmk.pmk22,pmk.pmk04,g_sma.sma904) RETURNING pmk.pmk42
         END IF
      END IF
      #稅率
      IF NOT cl_null(pmk.pmk21) THEN
         LET pmk.pmk43=0
         SELECT gec04 INTO pmk.pmk43 FROM gec_file
          WHERE gec01 = pmk.pmk21 AND gec011 = '1'  #進項
         IF cl_null(pmk.pmk43) THEN LET pmk.pmk43=0 END IF
      END IF
   END IF
  #end MOD-A40176 add

   INSERT INTO pmk_file VALUES(pmk.*)
   IF STATUS THEN 
      CALL cl_err3("ins","pmk_file",pmk.pmk01,"",STATUS,"","ins pmk:",1)        #NO.FUN-660107 
      CALL cl_batch_bg_javamail("N")     # No.FUN-570125
      LET g_success='N'  #FUN-950106 add 
   END IF
   INSERT INTO pmk_tmp_file VALUES(pmk.pmk01)       #CHI-AC0040 add
   LET pml.pml01=pmk.pmk01
   LET pml.pml011=pmk.pmk02
   LET pml.pml02=0
   LET g_pmk01 = pmk.pmk01        #No.FUN-550002
END FUNCTION
 
FUNCTION p510_multi()
   DEFINE l_name        LIKE type_file.chr20   
   DEFINE l_order	      LIKE pmk_file.pmk09          
   DEFINE l_ima06	      LIKE ima_file.ima06          
   DEFINE l_ima43       LIKE ima_file.ima43    
   DEFINE l_pmc15       LIKE pmc_file.pmc15
   DEFINE l_pmk10       LIKE pmk_file.pmk10
   DEFINE l_ima54       LIKE ima_file.ima54    
   DEFINE l_i,l_cnt     LIKE type_file.num5    
   DEFINE l_zaa02       LIKE zaa_file.zaa02    
   DEFINE l_cnt0        LIKE type_file.num5    
   DEFINE p_multi       LIKE type_file.num5    
   DEFINE l_old_pmk01   LIKE pmk_file.pmk01
   DEFINE l_msv13       LIKE msv_file.msv13
   DEFINE l_azp03       LIKE azp_file.azp03
   DEFINE l_sql         STRING
 
   IF tm.muti = 'N' OR tm.muti IS NULL THEN
      RETURN
   END IF
 
   LET g_sql="SELECT mss_file.*, ima06, ima43,pmc15,ima54,msv13",
             #"  FROM ",l_dbs_tra CLIPPED,"msv_file,ima_file,mss_file ",  #FUN-980092
             "  FROM ",cl_get_target_table(g_plant_new,'msv_file'),",ima_file,mss_file ", #FUN-A50102             
             "  LEFT OUTER JOIN pmc_file ON (pmc01=mss02)",
             " WHERE mss01=ima01 AND mss10='N'",
             "   AND msv000='",tm.muti_v,"'",
             "   AND msv01 = mss01",
             "   AND msv02 = mss02",
             "   AND msv03 = mss03",
             "   AND msv031='",g_plant,"'",
             "   AND msv13 > 0 ",
             "   AND mss_v='",ver_no,"'",
             "   AND mss10 = 'N'",
             "   AND ",g_wc CLIPPED
 
   CASE WHEN summary_flag='1'
      LET g_sql = g_sql CLIPPED," ORDER BY ima43,mss01, mss03"
      WHEN summary_flag='2'
      LET g_sql = g_sql CLIPPED," ORDER BY ima06,mss01, mss03"
      WHEN summary_flag='3'
      LET g_sql = g_sql CLIPPED," ORDER BY pmc15,mss01, mss03"
      WHEN summary_flag='4'
      LET g_sql = g_sql CLIPPED," ORDER BY ima54,mss01, mss03"
      OTHERWISE
      LET g_sql = g_sql CLIPPED," ORDER BY mss01, mss03"
   END CASE
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql  
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-980092
 
   PREPARE p510_multi_p FROM g_sql
   DECLARE p510_multi_c CURSOR FOR p510_multi_p
   LET l_name = g_name
 
   SELECT sma115,sma116 INTO g_sma115,g_sma116 FROM sma_file  
   IF g_sma.sma116 MATCHES '[13]' THEN
      LET g_zaa[37].zaa06 = "Y"
      LET g_zaa[38].zaa06 = "Y"
      LET g_zaa[40].zaa06 = "N"
      LET g_zaa[41].zaa06 = "N"
   ELSE
      LET g_zaa[37].zaa06 = "N"
      LET g_zaa[38].zaa06 = "N"
      LET g_zaa[40].zaa06 = "Y"
      LET g_zaa[41].zaa06 = "Y"
   END IF
   
   IF g_sma115 = "Y" OR g_sma116 MATCHES '[13]' THEN
      LET g_zaa[39].zaa06 = "N"
   ELSE
      LET g_zaa[39].zaa06 = "Y"
   END IF
   CALL cl_prt_pos_len()
 
   LET l_cnt0 = 0
   START REPORT p510_rep TO l_name
   FOREACH p510_multi_c INTO mss.*, l_ima06, l_ima43,l_pmc15,l_ima54,l_msv13
 
      LET mss.mss09 = l_msv13
 
      LET l_pmk10 = ' '
      IF NOT cl_null(tm.msm06) THEN
        SELECT msm02 INTO l_pmk10 FROM msm_file
        WHERE msm01 = mss.mss01
          AND msm06 = tm.msm06 
        IF NOT cl_null(l_pmk10) THEN
          LET l_pmc15 = l_pmk10
        END IF
      END IF
      IF l_pmc15 IS NULL THEN LET l_pmc15=' ' END IF
 
      CALL p500_pmk_default(l_pmc15,TRUE)
      CASE WHEN summary_flag='1' LET l_order=l_ima43
           WHEN summary_flag='2' LET l_order=l_ima06
           WHEN summary_flag='3' LET l_order=l_pmc15
           WHEN summary_flag='4' LET l_order=l_ima54
           OTHERWISE             LET l_order=' '
      END CASE

      #MOD-B50091 add --start--
      #請購料件/供應商控制
      LET g_pml04 = mss.mss01
      LET g_pmk09 = mss.mss02
      IF (g_pml04 != 'MISC') THEN
         IF summary_flag='4' THEN
            LET g_pmk09 = l_order
         END IF
         #廠商編號(pmk09)若有值,應依供應商基本資料檔帶出基本資料
         IF NOT cl_null(g_pmk09) AND g_pmk09 != ' ' THEN
            SELECT pmc22 INTO g_pmk22
              FROM pmc_file
             WHERE pmc01 = g_pmk09 AND pmc30 IN ('1','3')
             IF SQLCA.sqlcode THEN
                LET g_pmk22=NULL 
             END IF
         END IF
         SELECT ima915 INTO g_ima915 FROM ima_file WHERE ima01=g_pml04 
         IF g_ima915='1' OR g_ima915='3' AND NOT cl_null(g_pmk09) AND NOT cl_null(g_pmk22) THEN
            CALL p510_pmh()
            IF NOT cl_null(g_errno) THEN
               CONTINUE FOREACH
            END IF
         END IF
      END IF
      #MOD-B50091 add--end--

      OUTPUT TO REPORT p510_rep(l_order,mss.*,TRUE)
      LET l_cnt0 = l_cnt0 + 1
   END FOREACH
   FINISH REPORT p510_rep
  #CHI-AC0040---mark---start--- 
  #CALL cl_prt(l_name,' ','1',g_len)
  # 
  #IF l_cnt0 > 0 AND g_success = 'Y' THEN   #MOD-AC0058 add g_success='Y'
  #   CALL cl_getmsg('amr-007',g_lang) RETURNING g_msg
  #   IF cl_prompt(16,10,g_msg) THEN
  #      LET g_success='Y'
  #   ELSE
  #      LET g_success='N'
  #   END IF
  #END IF
  #CHI-AC0040---mark---end---
END FUNCTION
 
FUNCTION p510_upd_mss()
DEFINE l_i    LIKE type_file.num10
 
   FOR l_i = 1 TO g_mss_arr.getlength()
      UPDATE mss_file SET mss10='Y'
        WHERE mss_v=g_mss_arr[l_i].mss_v 
          AND mss00=g_mss_arr[l_i].mss00
      IF SQLCA.sqlerrd[3] = 0 THEN 
         CALL cl_err3("upd","mss_file",mss.mss_v,mss.mss00,STATUS,"","ins pml:",1)
         CALL cl_batch_bg_javamail("N")
         LET g_success='N'
      END IF
   END FOR
   CALL g_mss_arr.clear()
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14

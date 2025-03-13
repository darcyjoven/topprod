# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: axcp510.4gl
# Descriptions...: 庫存及在製成本計算作業
# Date & Author..: 96/02/24 By Roger
# Remark.........: 舊客戶調整:單位換算(請執行axcp112, 再修改本程式:
#                                      將'select tlf10'改為'sel tlf10*tlf60')
#                  modify by Ostrich 010503 將select tlf10'改為'sel tlf10*tlf60'
# 暫時以sfp02 取套數 應為sfp03(發料日)
# V2.0版注意:1.沒有smy53,smy54
#            2.tlf21,tlf211,tlf212 未定義為成本/日期 (請設ccz06='N')
# 註:xx代表中文"開"字
# Modify by DS/P 新增工單製程在製成本計算段
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: No.MOD-4C0005 04/12/01 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.FUN-5C0001 06/01/06 by Yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No.FUN-570153 06/03/14 By yiting 批次作業修改
# Modify.........: No.FUN-660142 06/06/20 By Ching GP 3.1 製程成本改善
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660180 06/06/26 By kim GP 3.1 製程成本改善
# Modify.........: No.FUN-660206 06/06/30 By kim GP 3.1 製程成本改善
# Modify.........: No.FUN-670016 06/07/10 By Sarah GP3.1成本改善-製程成本(項次27)
# Modify.........: No.FUN-670037 06/07/13 By Sarah 1.work_2_22(),work_wo_dl_oh()計算標準工時程式段,改成抓SUM(cam10),SUM(cam11)
#                                                  2.重流轉入的數量與金額未寫入
#                                                  3.當出項合計數量大於入項合計數量時(因為有BONUS的問題),出項合計金額會變成大於入項合計金額,需調整差異於轉下製程金額
# Modify.........: No.FUN-670065 06/07/19 By Sarah 人工/製費的計算,沒有依照所投入之工時去分攤,導致金額Double
# Modify.........: No.FUN-670084 06/07/20 By Sarah 人工/製費分攤完之後,尾差chk_cxh22()放在全部都算完後調整在其中一張工單
# Modify.........: No.FUN-680044 06/08/16 By Sarah GP3.1成本改善-工單轉入、工單轉出之成本計算
# Modify.........: No.FUN-680122 06/09/07 By zdyllq 類型轉換 
# Modify.........: No.FUN-6A0146 06/10/26 By bnlent l_time轉g_time
# Modify.........: No.TQC-6B0092 06/11/16 By Sarah UPDATE cxz_file寫入cxz04,cxz05出現null,造成dl_oh_ins_cai()在寫入cai_file時計算有誤
# Modify.........: No.FUN-710027 07/01/17 By atsea 增加修改單身批處理錯誤統整功能
# Modify.........: No.TQC-790087 07/09/13 By Sarah 修正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: NO.TQC-790122 07/09/21 By Mandy ora中文刪除
# Modify.........: No.TQC-7B0027 07/11/06 By Sarah 1.FOREACH前有用到"OPEN CURSOR USING 參數"的語法,會造成錯誤!請改成"FOREACH CURSOR USING 參數 INTO 變數"這樣的寫法
#                                                  2.執行時出現null值無法寫入的情況
# Modify.........: No.TQC-7C0126 07/12/10 By Carrier 1.SELECT apb時,用絕對值  2.去除衝暫估單據,否則有重復
# Modify.........: No.FUN-7C0028 08/01/31 By Sarah 
# 5.1成本改善：1.改為依年度+月份+料號+計算類別+類別編號計算
#              2.製費劃分為五種，分攤方式改為1.實際工時 2.標準工時 3.標準機時 4.產出數量*分攤係數
#              3.新增tlfc_file記錄依"成本計算類別"的異動成本,在每一個有異動tlf_file的地方,寫完tlf_file之後,INSERT(OR UPDATE)tlfc_file
#              4.ccb_file,ccc_file,cce_file,ccf_file,ccg_file,cch_file,ccl_file,cct_file,ccu_file,cxa_file,cxb_file,cxc_file,cxd_file寫入成本計算類型、製費三、製費四、製費五
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.CHI-940027 09/04/23 By ve007 制費分為5大類
# Modify.........: No.CHI-970021 09/08/21 By jan 1.拿掉caa_file的join,where條件，2.caa04-->caa041
# Modify.........: No.FUN-980009 09/08/31 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將程式段多餘的DISPLAY給MARK
# Modify.........: No.CHI-9A0021 09/10/15 By Lilan 將YEAR/MONTH的語法改成用BETWEEN語法
# Modify.........: No.TQC-9B0021 09/11/05 By Carrier SQL STANDARDIZE
# Modify.........: No:FUN-9C0009 09/12/02 by dxfwo  GP5.2 變更檔案權限時應使用 os.Path.chrwx 指令
# Modify.........: No.FUN-9C0073 10/01/18 By chenls 程序精簡
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模組TABLE重新分類,相關INSERT語法修改
# Modify.........: No.FUN-A60095 10/07/10 By kim GP5.25 平行工藝-製程報工加入製程段
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
# Modify.........: No.FUN-AA0059 10/10/28 By chenying 料號開窗控管
# Modify.........: No:FUN-A90065 10/10/14 By kim 分攤方式(cae08)加上4(分攤權數)和5(實際機時)的處理
# Modify.........: No:FUN-AB0025 10/11/10 By chenying FUNCTION p510_ask() 中的 g_wc 加上企業料號條件
# Modify.........: No:FUN-AB0089 11/02/25 By shenyang  修改本月平均單價
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No.FUN-A70095 11/06/14 By lixh1 撈取報工單(shb_file)的所有處理作業,必須過濾是已確認的單據
# Modify.........: No:FUN-BC0062 12/02/20 By lilingyu 成本計算類型(axcs010)不可選擇【6.移動加權平均成本】
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:MOD-C80242 12/11/30 By Elise 排除非成本庫的資料
# Modify.........: No:FUN-C80092 12/12/04 By xujing 成本相關作業程式日誌
# Modify.........: No:CHI-C80041 13/01/31 By bart 排除作廢
# Modify.........: No:CHI-D10020 13/02/18 By bart 預計修改方式為成本計算時，改抓工單之已發套數-sum(前期已發)
# Modify.........: No:MOD-D30006 13/03/01 By wujie 增加插入ccg时，ccg311 =0
# Modify.........: No:CHI-CB0001 13/03/05 By Alberti 針對aimt306/aimt309處理的部分與axcp500同步
# Modify.........: No:TQC-D30050 13/03/20 By lixh1 處理編譯報錯問題
# Modify.........: No:FUN-D40103 13/05/08 By lixh1 增加儲位有效性檢查
# Modify.........: No:FUN-D70038 13/07/10 By bart asms270的sma129='N'時，依CHI-D10020修改方式抓取，sma129="Y"時，維持產程式抓取方式

IMPORT os   #No.FUN-9C0009 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE yy             LIKE type_file.num5,    #No.FUN-680122 SMALLINT, #TQC-790122
       mm             LIKE type_file.num5,    #No.FUN-680122 SMALLINT,
       type           LIKE type_file.chr1,    #FUN-7C0028 add
       sw             LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(1),#NO.FUN-5C0001 ADD 
       last_yy        LIKE type_file.num5,    #No.FUN-680122 SMALLINT,
       last_mm        LIKE type_file.num5,    #No.FUN-680122 SMALLINT,
       g_cost_v       LIKE ccp_file.ccp03,    #No.FUN-680122 VARCHAR(4),
       g_ima57_t      LIKE ima_file.ima57,
       g_ima57        LIKE ima_file.ima57,
       g_ima01        LIKE ima_file.ima01,    #No.MOD-490217
       g_ima01_t      LIKE ima_file.ima01,    #No.MOD-490217
       g_tlfcost      LIKE tlf_file.tlfcost,  #FUN-7C0028 add
       g_misc         LIKE type_file.chr1,    #No.FUN-680122 VARCHAR(01),
       g_sql          STRING,                 #No.FUN-580092 HCN
       g_wc           STRING,                 #No.FUN-580092 HCN
       amta,amtb,amtc,amtd,amte LIKE ccc_file.ccc23a,
       amtf,amtg,amth           LIKE ccc_file.ccc22a,   #FUN-7C0028 add
       amt                      LIKE ccc_file.ccc23,
       gg_cxh21       LIKE cxh_file.cxh21,
       gg_cxh26       LIKE cxh_file.cxh26,
       gg_cxh28       LIKE cxh_file.cxh28,
       gg_cxh31       LIKE cxh_file.cxh31,
       gg_cxh33       LIKE cxh_file.cxh33,
       gg_cxh35       LIKE cxh_file.cxh35,
       gg_cxh37       LIKE cxh_file.cxh37,
       gg_cxh39       LIKE cxh_file.cxh39,
       gg_ecm03,ecm03_max,ecm03_min,first_cal_ecm03   LIKE ecm_file.ecm03,
       gg_ecm04,ecm04_max,ecm04_min,first_cal_ecm04   LIKE ecm_file.ecm04,
       gg_out         LIKE cxh_file.cxh11,
       g_cck   RECORD LIKE cck_file.*,
       g_ccc   RECORD LIKE ccc_file.*,
       g_cch   RECORD LIKE cch_file.*,
       g_cxh   RECORD LIKE cxh_file.*,
       g_ccu   RECORD LIKE ccu_file.*,
       g_ccs   RECORD LIKE ccs_file.*,
       g_sfb   RECORD LIKE sfb_file.*,
       g_ecm   RECORD LIKE ecm_file.*,
       g_caf   RECORD LIKE caf_file.*,
       g_shb   RECORD LIKE shb_file.*,
       mccg    RECORD LIKE ccg_file.*,
       mcch    RECORD LIKE cch_file.*,
       g_cxh21        LIKE cxh_file.cxh21,
       g_ecm03        LIKE ecm_file.ecm03,
       g_ecm04        LIKE ecm_file.ecm04,
       mcct    RECORD LIKE cct_file.*,
       mccu    RECORD LIKE ccu_file.*,
       g_cca23a       LIKE cca_file.cca23a, #使用此變數, 請考慮清楚(dennon lai)
       g_ccd03        LIKE ccd_file.ccd03,        #No.FUN-680122 VARCHAR(1),                #zzz
       g_ima16        LIKE ima_file.ima16,
       g_tothour      LIKE cck_file.cck05,
       g_totdl        LIKE cck_file.cck03,
       g_totoh        LIKE cck_file.cck03,
       q_tlf_rowid    LIKE type_file.row_id,  #chr18, FUN-A70120
       q_tlf RECORD
             tlf01    LIKE tlf_file.tlf01,  #料號
             tlf06    LIKE tlf_file.tlf06,  #單據日期
             tlf07    LIKE tlf_file.tlf07,  #產生日期
             tlf10    LIKE tlf_file.tlf10,  #異動數量
             tlf020   LIKE tlf_file.tlf020, #來源廠商
             tlf02    LIKE tlf_file.tlf02,  #來源狀況
             tlf021   LIKE tlf_file.tlf021, #倉庫別
             tlf022   LIKE tlf_file.tlf022, #存放位置
             tlf023   LIKE tlf_file.tlf023, #批號
             tlf026   LIKE tlf_file.tlf026, #
             tlf027   LIKE tlf_file.tlf027, #
             tlf030   LIKE tlf_file.tlf030, #目的廠商
             tlf03    LIKE tlf_file.tlf03,  #目的狀況
             tlf031   LIKE tlf_file.tlf031, #倉庫別
             tlf032   LIKE tlf_file.tlf032, #存放位置
             tlf033   LIKE tlf_file.tlf033, #批號
             tlf036   LIKE tlf_file.tlf036, #
             tlf037   LIKE tlf_file.tlf037, #
             tlf13    LIKE tlf_file.tlf13,  #
             tlf62    LIKE tlf_file.tlf62   #工單單號
             END RECORD,
       g_ima08        LIKE ima_file.ima08,
       g_bdate        LIKE type_file.dat,          #No.FUN-680122 DATE,
       g_edate        LIKE type_file.dat,          #No.FUN-680122 DATE,
#      qty,qty2       LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
       qty,qty2       LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
       up,amt2        LIKE tlf_file.tlf21,         #No.FUN-680122 DEC(20,6),   #MOD-4C0005
#      g_make_qty     LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
#      g_make_qty2    LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
       g_make_qty     LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
       g_make_qty2    LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
       g_sfb99        LIKE sfb_file.sfb99,
       g_sfb01_old2,g_sfb01_old3,g_sfb01_old8  LIKE sfb_file.sfb01,
       g_cxh22b       LIKE cxh_file.cxh22b,
       g_cxh22c       LIKE cxh_file.cxh22c,
       g_cxh22e       LIKE cxh_file.cxh22e,        #FUN-7C0028 add
       g_cxh22f       LIKE cxh_file.cxh22f,        #FUN-7C0028 add
       g_cxh22g       LIKE cxh_file.cxh22g,        #FUN-7C0028 add
       g_cxh22h       LIKE cxh_file.cxh22h,        #FUN-7C0028 add
       xxx            LIKE type_file.chr5,         #TQC-D30050 
       xxx1           LIKE tlf_file.tlf026,        #No.FUN-680122 VARCHAR(16),       #No.FUN-550025
       xxx2           LIKE type_file.num5,         #No.FUN-680122 SMALLINT,
       u_sign         LIKE type_file.num5,         #No.FUN-680122 SMALLINT,       # 1:入 -1:退
       u_flag         LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(1)
       ii             LIKE type_file.num10,        #No.FUN-680122 INTEGER,
       no_tot,p1      LIKE type_file.num10,        #No.FUN-680122 INTEGER,
       no_ok,no_ok2   LIKE type_file.num10,        #No.FUN-680122 INTEGER,
       g_cxh31        LIKE cxh_file.cxh31,
       g_cxh39        LIKE cxh_file.cxh39,
       g_cxh33        LIKE cxh_file.cxh33,
       g_cxh37        LIKE cxh_file.cxh37,
       g_cxh35        LIKE cxh_file.cxh35,
       start_date     LIKE type_file.dat,          #No.FUN-680122 DATE,
       start_time     LIKE type_file.chr8,         #No.FUN-680122 VARCHAR(5),
       t_time         LIKE type_file.chr8,         #No.FUN-680122 VARCHAR(8),
       g_smydmy1      LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(01),
       g_smy53        LIKE smy_file.smy53,
       g_smy54        LIKE smy_file.smy54 #98.09.28 Star Chang Type
DEFINE g_change_lang  LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)     #FUN-570153
DEFINE g_chr          LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE g_cnt          LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_msg          LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(72)
DEFINE g_flag         LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE ecm012_max       LIKE ecm_file.ecm012       #FUN-A60095
DEFINE ecm012_min       LIKE ecm_file.ecm012       #FUN-A60095
DEFINE first_cal_ecm012 LIKE ecm_file.ecm012       #FUN-A60095
DEFINE gg_ecm012        LIKE ecm_file.ecm012       #FUN-A60095
DEFINE g_cka00        LIKE cka_file.cka00          #FUN-C80092
DEFINE g_cka09        LIKE cka_file.cka09          #FUN-C80092
#CHI-CB0001---add---S
DEFINE g_msg1           LIKE type_file.chr1000      
DEFINE g_msg2           LIKE type_file.chr1000      
DEFINE g_msg3           LIKE type_file.chr1000  
#CHI-CB0001---add---E

MAIN
 
DEFINE p_row,p_col   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc    = ARG_VAL(1)
   LET yy      = ARG_VAL(2)
   LET mm      = ARG_VAL(3)
   LET type    = ARG_VAL(4)   #FUN-7C0028 add
   LET g_bgjob = ARG_VAL(5)
  
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_time = TIME    #No.FUN-6A0146
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
 
   LET g_success = 'Y'
   LET g_change_lang = FALSE
   LET start_date=TODAY
   LET t_time = TIME
   LET start_time=t_time
   WHILE TRUE  

#FUN-BC0062 --begin--
       IF g_ccz.ccz28 = '6' THEN
          CALL cl_err('','axc-026',1)
          EXIT WHILE
       END IF
#FUN-BC0062 --end--

      IF g_bgjob = 'N' THEN
         LET ii=0
         IF s_shut(0) THEN EXIT WHILE END IF
         LET g_flag = 'Y'
         CALL p510_ask()
         IF cl_sure(20,20) THEN 
            CALL cl_wait() 
            CALL work_create_tmp()  #FUN-A60095
            LET g_cka09="yy=",yy,";mm=",mm,";type='",type,"';sw='",sw,"';g_bgjob='",g_bgjob,"'"  #FUN-C80092 add
            CALL s_log_ins(g_prog,yy,mm,g_wc,g_cka09) RETURNING g_cka00   #FUN-C80092 add
            BEGIN WORK 
            CALL p510() 
            CALL s_showmsg()        #No.FUN-710027 
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
               CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
               CALL p510_out()
            ELSE
               ROLLBACK WORK
               CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
               CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
            END IF
            IF g_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW p510_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         CLOSE WINDOW p510_w
      ELSE
         CALL work_create_tmp()  #FUN-A60095
         LET g_cka09="yy=",yy,";mm=",mm,";type='",type,"';sw='",sw,"';g_bgjob='",g_bgjob,"'"  #FUN-C80092 add
         CALL s_log_ins(g_prog,yy,mm,g_wc,g_cka09) RETURNING g_cka00   #FUN-C80092 add
         BEGIN WORK 
         CALL s_showmsg()        #No.FUN-710027 
         CALL p510() 
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL s_log_upd(g_cka00,'Y')          #FUN-C80092 add
            CALL p510_out()
         ELSE
            ROLLBACK WORK
            CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION p510_ask()
   DEFINE c             LIKE cre_file.cre08          #No.FUN-680122 VARCHAR(10)
   DEFINE lc_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(500)       #FUN-570153
   DEFINE p_row,p_col   LIKE type_file.num5          #FUN-570153        #No.FUN-680122 SMALLINT
 
   LET p_row = 3 LET p_col = 25
 
   OPEN WINDOW p510_w AT p_row,p_col WITH FORM "axc/42f/axcp510"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('q')
   LET yy   = g_ccz.ccz01 
   LET mm   = g_ccz.ccz02 
   LET type = g_ccz.ccz28   #FUN-7C0028 add
   LET sw   = 'N'
   DISPLAY BY NAME yy,mm,type,sw     #NO.FUN-5C0001 add sw   #FUN-7C0028 add type
   WHILE TRUE
 
     CONSTRUCT BY NAME g_wc ON ima01,ima57,ima08,ima06,ima09,ima10,ima11,ima12
        BEFORE CONSTRUCT
           CALL cl_qbe_init()
 
        ON ACTION CONTROLP
           CASE
             WHEN INFIELD(ima01)
#FUN-AA0059---------mod------------str-----------------   
#              CALL cl_init_qry_var()
#              LET g_qryparam.form = "q_ima"
#              LET g_qryparam.state = "c"
#              LET g_qryparam.default1 = g_ima01
#              CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","",g_ima01,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end------------------
               DISPLAY g_qryparam.multiret TO ima01
               NEXT FIELD ima01
            OTHERWISE
               EXIT CASE
          END CASE
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()        # Command execution
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE CONSTRUCT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION locale                    #genero
           LET g_change_lang = TRUE                  #FUN-570153
           EXIT CONSTRUCT
 
        ON ACTION exit              #加離開功能genero
           LET INT_FLAG = 1
           EXIT CONSTRUCT
 
        ON ACTION qbe_select
           CALL cl_qbe_select()
 
     END CONSTRUCT
     LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imauser', 'imagrup') #FUN-980030
 
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p510_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
 
     LET g_wc=g_wc CLIPPED,
              " AND ima01 NOT MATCHES 'MISC*'",
              " AND (ima120='1' OR ima120=' ' OR ima120 IS NULL) "  #FUN-AB0025 add 
     LET g_bgjob = 'N'     #FUN-570153
   
     INPUT BY NAME yy,mm,type,sw,g_bgjob WITHOUT DEFAULTS #NO.FUN-570153  #FUN-7C0028 add type
        ON CHANGE g_bgjob
           IF g_bgjob = "Y" THEN
              LET sw = "N"
              DISPLAY BY NAME sw
              CALL cl_set_comp_entry("sw",FALSE)
           ELSE
              CALL cl_set_comp_entry("sw",TRUE)
           END IF
 
        AFTER INPUT
           IF INT_FLAG THEN 
              LET INT_FLAG = 0
              CLOSE WINDOW p510_w
              CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
              EXIT PROGRAM
           END IF
 
           IF yy*12+mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
              CALL cl_err('','axc-196','1')
              NEXT FIELD yy
           END IF
           SELECT ccp03 INTO g_cost_v FROM ccp_file WHERE ccp01=yy AND ccp02=mm
 
        AFTER FIELD type     #成本計算類型
           IF type IS NULL OR type NOT MATCHES "[12345]" THEN
              NEXT FIELD type
           END IF
 
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
 
        ON ACTION locale                     #FUN-570153
           LET g_change_lang = TRUE          #FUN-570153
           EXIT INPUT                        #FUN-570153
     END INPUT
     IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLOSE WINDOW p510_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
 
     IF g_change_lang THEN
        LET g_change_lang = FALSE
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
        CONTINUE WHILE
     END IF
 
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'axcp510'
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('axcp510','9031',1)
        ELSE
           LET g_wc = cl_replace_str(g_wc,"'","\"")
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",g_wc CLIPPED,"'",
                        " '",yy CLIPPED,"'",
                        " '",mm CLIPPED,"'",
                        " '",type CLIPPED,"'",   #FUN-7C0028 add
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('axcp510',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p510_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
        EXIT PROGRAM
     END IF
     EXIT WHILE
   END WHILE
END FUNCTION
 
FUNCTION p510()
DEFINE l_sw     LIKE type_file.num5    #No.FUN-680122 SMALLINT #NO.FUN-5C0001 ADD
DEFINE l_cnt1   LIKE type_file.num5    #NO.FUN-5C0001 ADD      #No.FUN-680122 SMALLINT
DEFINE l_sw_tot LIKE type_file.num5    #No.FUN-680122 SMALLINT #NO.FUN-5C0001 ADD
DEFINE l_count  LIKE type_file.num5    #No.FUN-680122 SMALLINT #NO.FUN-5C0001 ADD
 
   CALL p510_get_date() IF g_success = 'N' THEN RETURN END IF
   #取上期結存轉本月期初
   CALL p510_last0()
 
   DROP TABLE tlf_temp
 
   #取本期有異動之料件計算
   LET g_sql = "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
               " ima09,ima10,ima11,ima12,tlfcost ",      #tlf
               "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,tlf_file ",
               "  WHERE ",g_wc CLIPPED,
               "   AND ima01 = tlf01",
               "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
               "   AND tlf902 NOT IN (SELECT jce02 FROM jce_file)", #JIT
               "   AND tlf907 != 0 ",
               " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12,tlfcost",   #FUN-7C0028 add tlfcost
               " UNION  ",
 "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
 " ima09,ima10,ima11,ima12,' ' ",
 "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, cam_file,sfb_file ",
 "  WHERE ",g_wc CLIPPED,
 " AND ima01 = sfb05",
 " AND cam01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
 " AND cam04 = sfb01",
               " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12",
               " UNION  ",
               "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
               " ima09,ima10,ima11,ima12,' ' ",
               "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, cam_file,sfb_file,sfa_file ",
               "  WHERE ",g_wc CLIPPED,
                  " AND ima01 = sfa03",
                  " AND cam01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  " AND cam04 = sfb01",
                  " AND sfb01 = sfa01",
                  " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12",
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,ccg07 ",   #ccg
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01, ccg_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = ccg04 ",
                  "   AND ccg02= ",last_yy," AND ccg03= ",last_mm,
                  "   AND ccg06='",type,"'",
                  "   AND (ccg91  !=0  OR  ccg92  !=0 ",
                  "    OR  ccg92a !=0  OR  ccg92b !=0 ",
                  "    OR  ccg92c !=0  OR  ccg92d !=0 ",
                  "    OR  ccg92e !=0  OR  ccg92f !=0 ",
                  "    OR  ccg92g !=0  OR  ccg92h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12,ccg07",   #FUN-7C0028 add ccg07
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,cch07 ",
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,cch_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = cch04 ",
                  "   AND cch02= ",last_yy," AND cch03= ",last_mm,
                  "   AND cch06='",type,"'",
                  "   AND (cch91  !=0  OR  cch92  !=0 ",
                  "    OR  cch92a !=0  OR  cch92b !=0 ",
                  "    OR  cch92c !=0  OR  cch92d !=0 ",
                  "    OR  cch92e !=0  OR  cch92f !=0 ",
                  "    OR  cch92g !=0  OR  cch92h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12,cch07",   #FUN-7C0028 add cch07
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,cca07 ",   #ccg
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,cca_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND ima01 = cca01 ",
                  "   AND cca02= ",last_yy," AND cca03= ",last_mm,
                  "   AND cca06='",type,"'",
                  "   AND cca06='",type,"'",   #FUN-7C0028 add
                  " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12,cca07",   #FUN-7C0028 add cca07
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,cxf07 ",   #ccf Wip
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,cxf_file,sfb_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND cxf01 = sfb01 ",
                  "   AND ima01 = sfb05 ",
                  "   AND cxf02= ",last_yy," AND cxf03= ",last_mm,
                  "   AND cxf06='",type,"'",
                  "   AND (cxf11  !=0  OR  cxf12  !=0 ",
                  "    OR  cxf12a !=0  OR  cxf12b !=0 ",
                  "    OR  cxf12c !=0  OR  cxf12d !=0 ",
                  "    OR  cxf12e !=0  OR  cxf12f !=0 ",
                  "    OR  cxf12g !=0  OR  cxf12h !=0) ",
                  " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12,cxf07",   #FUN-7C0028 add cxf07
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,cxl07 ",
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,cxl_file,sfb_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND cxl01 = sfb01 ",
                  "   AND ima01 = sfb05 ",
                  "   AND cxl02= ",yy," AND cxl03= ",mm,
                  "   AND cxl06='",type,"'",
                  "   AND cxl06='",type,"'",   #FUN-7C0028 add
                  " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12,cxl07",   #FUN-7C0028 add cxl07
                 #應考慮下階材料是否有投料異動
                  " UNION  ",
                  "SELECT ima57,ima01,ccd03,ima16,ima08,ima06,",
                  " ima09,ima10,ima11,ima12,tlfcost ",
                  "  FROM ima_file LEFT OUTER JOIN ccd_file ON ima57=ccd_file.ccd01,tlf_file,sfb_file ",
                  " WHERE ",g_wc CLIPPED,
                  "   AND (sfb38 BETWEEN '",g_bdate,"' AND '",g_edate ,"' ",
                  "    OR  sfb38 IS NULL ) ",
                  "   AND ima01 = sfb05 ",
                  "   AND tlf06 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
                  "   AND tlf62 = sfb01",
                  "   and tlf13[1,5] = 'asfi5'",  #No.TQC-9B0021
                  " GROUP BY ima57,ima01,ccd03,ima16,ima08,ima06,ima09,ima10,ima11,ima12,tlfcost",   #FUN-7C0028 add tlfcost
                  " INTO TEMP tlf_temp WITH NO LOG "
 
   PREPARE p510_trx_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('trx_prep:',STATUS,0)
      RETURN
   END IF
   EXECUTE p510_trx_prep
 
   LET no_tot = sqlca.sqlerrd[3]
   IF g_bgjob = 'N' THEN             #FUN-570153
      DISPLAY BY NAME no_tot
   END IF
   IF sw = 'N' THEN
      LET l_count = 1
      LET g_sql = "SELECT UNIQUE ima57,ima01,ccd03,ima16,tlfcost ",   #FUN-7C0028 add tlfcost
                  "  FROM tlf_temp",
                  " ORDER BY ima57 DESC,ima16,ima01,tlfcost "  # 依成本階數由下往上累算   #FUN-7C0028 add tlfcost
      PREPARE p510_cnt_p1 FROM g_sql
      DECLARE p510_cnt_c1 CURSOR WITH HOLD FOR p510_cnt_p1
      FOREACH p510_cnt_c1 INTO g_ima57,g_ima01,g_ccd03,g_ima16,g_tlfcost   #FUN-7C0028 add g_tlfcost
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','#?',STATUS,0)          #No.FUN-710027
            LET g_success='N' 
            RETURN
         END IF
         LET l_sw_tot = l_sw_tot + 1
      END FOREACH
 
      IF l_sw_tot>0 THEN
         IF l_sw_tot > 10 THEN
            LET l_sw = l_sw_tot /10
            CALL cl_progress_bar(10)
         ELSE
            CALL cl_progress_bar(l_sw_tot)
         END IF
      END IF
   END IF
 
  #CALL work_create_tmp()  #FUN-A60095
 
   DELETE FROM cxz_file WHERE 1=1
 
  #S1.先把成本項目金額全攤到每一張工單,
  #S2.再SUM(人工)/SUM(製費)與axct300比較,
  #S3.若不平,則自動將尾數攤入其中一筆工單做尾差歸屬
   LET g_sql = "SELECT UNIQUE ima57,ima01,ccd03,ima16,tlfcost ",   #FUN-7C0028 add tlfcost
               "  FROM tlf_temp",
               " ORDER BY ima57 DESC,ima16,ima01,tlfcost "  # 依成本階數由下往上累算成本   #FUN-7C0028 add tlfcost
   PREPARE p510_p1 FROM g_sql
   DECLARE p510_c1 CURSOR WITH HOLD FOR p510_p1
   FOREACH p510_c1 INTO g_ima57,g_ima01,g_ccd03,g_ima16,g_tlfcost   #FUN-7C0028 add g_tlfcost
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','#?',STATUS,0)         #No.FUN-710027
         LET g_success='N'
         IF sw = 'N' THEN CALL cl_close_progress_bar() END IF #NO.FUN-5C0001
         RETURN
      END IF
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
      #成本階為99 表示為Purchase part 不須處理 WIP 在製成本
      IF g_ima57 !='99' THEN
         #先將tmp10_file/tmp11_file產生
         CALL p510_wip_prepare()
 
         DECLARE work_c33 CURSOR FOR
          SELECT sfb_file.*,caf_file.*
            FROM sfb_file LEFT OUTER JOIN caf_file ON sfb01 = caf01 AND caf02=yy AND caf03=mm
           WHERE sfb05 =g_ima01
             #基本上不走製程的工單根本就沒有作業編號
             #所以如果一旦ccz06 !='1''2',
             #不走製程的工單在人工製費的收集就會有問題
             #幸好一般情況下,客戶應該有製程就全部走製程
             AND sfb02 !='13' AND sfb02 != '11'
            #重工工單亦要收集人工/製費
            # AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N')
             AND (sfb38 IS NULL OR sfb38 >= g_bdate)  # 工單成會結案日
             AND (sfb81 IS NULL OR sfb81 <= g_edate)  # 工單開立日期
           ORDER BY caftime
         LET g_sfb01_old8=' '
         FOREACH work_c33 INTO g_sfb.*,g_caf.*
            CALL work_wo_dl_oh()
         END FOREACH
      END IF
   END FOREACH
 
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
 
   DELETE FROM cxy_file WHERE 1=1
 
   CALL dl_oh_check()   #將cxz_file與axct300比較,若不平則將尾差隨便歸其一張工單
   CALL dl_oh_ins_cai() #塞到cai_file
 
   LET g_ima57_t=NULL
   LET no_ok=0
   LET g_tothour = 0 LET g_totdl = 0 LET g_totoh = 0
   FOREACH p510_c1 INTO g_ima57,g_ima01,g_ccd03,g_ima16,g_tlfcost   #FUN-7C0028 add g_tlfcost
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','#?',STATUS,0)                   #No.FUN-710027
         LET g_success='N'
         IF sw = 'N' THEN CALL cl_close_progress_bar() END IF #NO.FUN-5C0001
         RETURN
      END IF
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
      LET l_cnt1 = l_cnt1 + 1
      #成本階不同, 對於 rework 部份, 進行第二次處理
      IF g_ima57 != g_ima57_t AND g_ima57_t IS NOT NULL THEN
         LET g_ima01_t = g_ima01
         CALL p510_rework()
         LET g_ima01 = g_ima01_t
      END IF
      LET g_ima57_t = g_ima57
      LET g_misc = 'Y'
      LET no_ok=no_ok+1
      IF g_bgjob = 'N' THEN             #FUN-570153
         DISPLAY no_ok,g_ima57,g_ima01 TO no_ok,p1,p2
      END IF 
      SELECT * INTO g_ccc.* FROM ccc_file
       WHERE ccc01 = g_ima01 AND ccc02 = yy AND ccc03 = mm
         AND ccc07 = type    AND ccc08 = g_tlfcost   #FUN-7C0028 add
      #將 g_ccc.* 歸 0
      CALL p510_ccc_0()
      CALL p510_last()
 
      #-->成本階為99 表示為Purchase part 不須處理 WIP 在製成本
      IF g_ima57 !='99' THEN
         CALL p510_wip()         # 先處理 WIP 在製成本 (工單性質=1/7)
         CALL p510_wip2()        #先處理製程 WIP 在製成本 (工單性質=1/7)
      END IF
      CALL p510_tlf()           # 由 tlf_file 計算各類入出庫數量, 採購成本
      CALL p510_ccb_cost()      # 加上入庫調整金額
      IF g_ima57!='99' THEN
         CALL p510_ccg_cost()   # 加上WIP入庫金額
      END IF
      CALL p510_ccc_tot('1')    # 計算所有出庫成本及結存
      CALL p510_ccc_ins()       # Insert ccc_file
      IF sw = 'N' THEN
         IF l_sw_tot > 10 THEN  #筆數合計
            IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
               CALL cl_progressing(" ")
            END IF
            IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數時
                CALL cl_progressing(" ")
                LET l_count = l_count + 1
            END IF
         ELSE
            CALL cl_progressing(" ")
         END IF
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
 
   IF g_ima01_t IS NULL THEN LET g_ima01_t = 0 END IF
   IF g_ima57_t IS NULL THEN LET g_ima57_t = 0 END IF
   CALL p510_rework()           # 對於 rework 部份, 進行第二次處理
   CALL chk_cxh22()      #FUN-670084 add
   UPDATE ccz_file SET ccz01 = yy,ccz02 = mm WHERE ccz00 = '0'
   IF STATUS THEN
      CALL cl_err('upd ccz:',STATUS,0) LET g_success='N' RETURN
   END IF
END FUNCTION
 
FUNCTION p510_rework()
   DEFINE l_ccd03      LIKE ccd_file.ccd03        #No.FUN-680122 VARCHAR(1)
   SELECT ccd03 INTO l_ccd03 FROM ccd_file WHERE ccd01=g_ima57_t
   LET g_tothour = 0 LET g_totdl = 0 LET g_totoh = 0
   IF l_ccd03='Y' THEN
      CALL p510_rework1()  # 先算 WIP 及 完成品入庫
      CALL p510_rework2()  # 再算所有出庫成本及結存
      CALL p510_wipx0()    # 記錄WIP-拆件式工單 在製成本 (工單性質=11)
                           # 因為要取重工後單價
   END IF
END FUNCTION
 
FUNCTION p510_rework1()
   LET g_sql = "SELECT ima01 FROM tlf_temp",
               "  WHERE ",g_wc CLIPPED," AND ima57=",g_ima57_t
   PREPARE p510_rework_p1 FROM g_sql
   IF STATUS THEN
      CALL cl_err('rework1 prep:',STATUS,0)             #No.FUN-710027
      CALL s_errmsg('','','rework1 prep:',STATUS,0)     #No.FUN-710027
   END IF
   DECLARE p510_rework_c1 CURSOR WITH HOLD FOR p510_rework_p1
   LET no_ok2=0
   FOREACH p510_rework_c1 INTO g_ima01
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','p510_rework',SQLCA.sqlcode,0)     #No.FUN-710027    
         EXIT FOREACH                                         
      END IF
      SELECT * INTO g_ccc.* FROM ccc_file
       WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
         AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS THEN CALL p510_ccc_0() END IF
      LET no_ok2=no_ok2+1
      IF g_bgjob = 'N' THEN             #FUN-570153
         DISPLAY no_ok2,g_ima57_t TO no_ok2,p3
      END IF
      CALL p510_wip_rework()    # 處理 WIP 重工成本 (重工sfb99='Y')
      CALL p510_work_rework()   # 重工段走製程
   END FOREACH
   CLOSE p510_rework_c1
END FUNCTION
 
FUNCTION p510_rework2()
   LET g_sql = "SELECT ima01 FROM tlf_temp",
               "  WHERE ",g_wc CLIPPED," AND ima57 = ",g_ima57_t
 
   PREPARE p510_rework2_p1 FROM g_sql
   IF STATUS THEN
      CALL s_errmsg('','','rework2 prep:',STATUS,0) #No.FUN-710027
      RETURN
   END IF
   DECLARE p510_rework2_c1 CURSOR WITH HOLD FOR p510_rework2_p1
   LET no_ok2=0
   FOREACH p510_rework2_c1 INTO g_ima01
      SELECT * INTO g_ccc.* FROM ccc_file
       WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
         AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS THEN CALL p510_ccc_0() END IF
      LET no_ok2=no_ok2+1
      IF g_bgjob = 'N' THEN             #FUN-570153
         DISPLAY no_ok2,g_ima57_t TO no_ok2,p3
      END IF
      CALL p510_ccg2_cost()     # 加上WIP重工入庫金額
      CALL p510_ccc_tot('2')    # 計算所有出庫成本及結存
      CALL p510_ckp_ccc() #MOD-4A0263 CHECK ccc_file做NOT NULL欄位的判斷
      CALL p510_ccc_upd()       # Update ccc_file
   END FOREACH
   CLOSE p510_rework2_c1
END FUNCTION
 
FUNCTION p510_wipx0()
   LET g_sql = "SELECT ima01 FROM tlf_temp",
               "  WHERE ",g_wc CLIPPED," AND ima57 = ",g_ima57_t
 
   PREPARE p510_wipx0_p1 FROM g_sql
   IF STATUS THEN
      CALL s_errmsg('','','wipx0 prep:',STATUS,0)  #No.FUN-710027
      RETURN
   END IF
   DECLARE p510_wipx0_c1 CURSOR WITH HOLD FOR p510_wipx0_p1
   FOREACH p510_wipx0_c1 INTO g_ima01
      SELECT * INTO g_ccc.* FROM ccc_file
       WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
         AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
      IF STATUS THEN CALL p510_ccc_0() END IF
      CALL p510_wipx()
   END FOREACH
END FUNCTION
 
FUNCTION p510_get_date()
   DEFINE l_correct    LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   CALL s_azm(yy,mm) RETURNING l_correct, g_bdate, g_edate #得出起始日與截止日
   IF l_correct != '0' THEN LET g_success = 'N' RETURN END IF
   IF mm = 1 THEN
      IF g_aza.aza02 = '1' THEN
         LET last_mm = 12 LET last_yy = yy - 1
      ELSE 
         LET last_mm = 13 LET last_yy = yy - 1
      END IF
   ELSE 
      LET last_mm = mm - 1 LET last_yy = yy
   END IF
END FUNCTION
 
FUNCTION p510_ccc_0()
   LET g_ccc.ccc01 = g_ima01
   LET g_ccc.ccc02 = yy
   LET g_ccc.ccc03 = mm
   LET g_ccc.ccc04 = g_ima57
   LET g_ccc.ccc07 = type        #FUN-7C0028 add
   LET g_ccc.ccc08 = g_tlfcost   #FUN-7C0028 add
   LET g_ccc.ccc11 = 0
   LET g_ccc.ccc12 = 0 LET g_ccc.ccc12a= 0
   LET g_ccc.ccc12b= 0 LET g_ccc.ccc12c= 0
   LET g_ccc.ccc12d= 0 LET g_ccc.ccc12e= 0
   LET g_ccc.ccc12f= 0 LET g_ccc.ccc12g= 0 LET g_ccc.ccc12h= 0  #FUN-7C0028 add
   LET g_ccc.ccc21 = 0
   LET g_ccc.ccc22 = 0 LET g_ccc.ccc22a= 0
   LET g_ccc.ccc22b= 0 LET g_ccc.ccc22c= 0
   LET g_ccc.ccc22d= 0 LET g_ccc.ccc22e= 0
   LET g_ccc.ccc22f= 0 LET g_ccc.ccc22g= 0 LET g_ccc.ccc22h= 0  #FUN-7C0028 add
   LET g_ccc.ccc25 = 0
   LET g_ccc.ccc26 = 0 LET g_ccc.ccc26a= 0
   LET g_ccc.ccc26b= 0 LET g_ccc.ccc26c= 0
   LET g_ccc.ccc26d= 0 LET g_ccc.ccc26e= 0
   LET g_ccc.ccc26f= 0 LET g_ccc.ccc26g= 0 LET g_ccc.ccc26h= 0  #FUN-7C0028 add
   LET g_ccc.ccc27 = 0
   LET g_ccc.ccc28 = 0 LET g_ccc.ccc28a= 0
   LET g_ccc.ccc28b= 0 LET g_ccc.ccc28c= 0
   LET g_ccc.ccc28d= 0 LET g_ccc.ccc28e= 0
   LET g_ccc.ccc28f= 0 LET g_ccc.ccc28g= 0 LET g_ccc.ccc28h= 0  #FUN-7C0028 add
   LET g_ccc.ccc23 = 0 LET g_ccc.ccc23a= 0
   LET g_ccc.ccc23b= 0 LET g_ccc.ccc23c= 0
   LET g_ccc.ccc23d= 0 LET g_ccc.ccc23e= 0
   LET g_ccc.ccc23f= 0 LET g_ccc.ccc23g= 0 LET g_ccc.ccc23h= 0  #FUN-7C0028 add
   LET g_ccc.ccc31 = 0 LET g_ccc.ccc32 = 0
   LET g_ccc.ccc41 = 0 LET g_ccc.ccc42 = 0
   LET g_ccc.ccc43 = 0 LET g_ccc.ccc44 = 0
   LET g_ccc.ccc51 = 0 LET g_ccc.ccc52 = 0
   LET g_ccc.ccc61 = 0 LET g_ccc.ccc63 = 0
   LET g_ccc.ccc62 = 0 LET g_ccc.ccc62a= 0
   LET g_ccc.ccc62b= 0 LET g_ccc.ccc62c= 0
   LET g_ccc.ccc62d= 0 LET g_ccc.ccc62e= 0
   LET g_ccc.ccc62f= 0 LET g_ccc.ccc62g= 0 LET g_ccc.ccc62h= 0  #FUN-7C0028 add
   LET g_ccc.ccc64 = 0 LET g_ccc.ccc65 = 0
   LET g_ccc.ccc66 = 0 LET g_ccc.ccc66a= 0
   LET g_ccc.ccc66b= 0 LET g_ccc.ccc66c= 0
   LET g_ccc.ccc66d= 0 LET g_ccc.ccc66e= 0
   LET g_ccc.ccc66f= 0 LET g_ccc.ccc66g= 0 LET g_ccc.ccc66h= 0  #FUN-7C0028 add
   LET g_ccc.ccc71 = 0 LET g_ccc.ccc72 = 0
   LET g_ccc.ccc91 = 0
   LET g_ccc.ccc92 = 0 LET g_ccc.ccc92a= 0
   LET g_ccc.ccc92b= 0 LET g_ccc.ccc92c= 0
   LET g_ccc.ccc92d= 0 LET g_ccc.ccc92e= 0
   LET g_ccc.ccc92f= 0 LET g_ccc.ccc92g= 0 LET g_ccc.ccc92h= 0  #FUN-7C0028 add
   LET g_ccc.ccc93 = 0 LET g_ccc.ccc93a= 0
   LET g_ccc.ccc93b= 0 LET g_ccc.ccc93c= 0
   LET g_ccc.ccc93d= 0 LET g_ccc.ccc93e= 0
   LET g_ccc.ccc93f= 0 LET g_ccc.ccc93g= 0 LET g_ccc.ccc93h= 0  #FUN-7C0028 add
   LET g_ccc.cccuser=g_user
   LET g_ccc.cccdate=TODAY
   LET t_time = TIME
   LET g_ccc.ccctime=t_time
END FUNCTION
 
FUNCTION p510_last0()            # 取上期結存轉本月期初
   DEFINE l_cca    RECORD LIKE cca_file.*
   DEFINE l_sql    LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(600)
   DEFINE l_ima01  LIKE ima_file.ima01
   DEFINE l_cxf    RECORD LIKE cxf_file.*
 
   LET l_sql = "DELETE FROM ccc_file",
               " WHERE ccc02=",yy," AND ccc03=",mm,
               "   AND ccc07='",type,"'",   #FUN-7C0028 add
               "   AND ccc01 IN(SELECT ima01 FROM ima_file",
                               " WHERE ",g_wc CLIPPED,")"
   PREPARE last0_del_prep FROM l_sql
   IF SQLCA.sqlcode THEN
      CALL cl_err('last0 delp:',STATUS,0)
      CALL cl_batch_bg_javamail('N')         #FUN-570153
      CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXECUTE last0_del_prep
 
   LET l_sql = "SELECT ima01      FROM ccc_file,ima_file",
               " WHERE ccc02=",last_yy," AND ccc03=",last_mm,
               "   AND ccc07='",type,"'",   #FUN-7C0028 add
               "   AND ccc01=ima01 ",
               "   AND ",g_wc,
               " UNION ",
               "SELECT ima01      FROM cca_file,ima_file",
               " WHERE cca02=",last_yy," AND cca03=",last_mm,
               "   AND cca06='",type,"'",   #FUN-7C0028 add
               "   AND cca01=ima01 ",
               "   AND ",g_wc
   PREPARE last0_prep FROM l_sql
   IF STATUS THEN
      CALL cl_err('last0 prep:',STATUS,0)
      CALL cl_batch_bg_javamail('N')         #FUN-570153
      CALL s_log_upd(g_cka00,'N')          #FUN-C80092 add
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   DECLARE last0_cs CURSOR FOR last0_prep
 
   CALL s_showmsg_init()   #No.FUN-710027  
 
   #-->庫存成本期初
   FOREACH last0_cs INTO l_ima01
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
 
      CALL p510_ccc_0()
      SELECT * INTO g_ccc.* FROM ccc_file WHERE ccc01 = l_ima01
         AND ccc02=last_yy AND ccc03=last_mm
         AND ccc07=type   #FUN-7C0028 add
      IF g_bgjob = 'N' THEN             #FUN-570153
         MESSAGE g_ccc.ccc01
         CALL ui.Interface.refresh()
      END IF
      #-->取期初帳轉本月期初(讀不到沒影響)
      SELECT * INTO l_cca.* FROM cca_file
       WHERE cca01=g_ccc.ccc01 AND cca02=last_yy AND cca03=last_mm
         AND cca06=type   #FUN-7C0028 add
      IF SQLCA.SQLCODE=100 THEN #無帳數
         LET g_ccc.ccc11=g_ccc.ccc91
         LET g_ccc.ccc12=g_ccc.ccc92
         LET g_ccc.ccc12a=g_ccc.ccc92a
         LET g_ccc.ccc12b=g_ccc.ccc92b
         LET g_ccc.ccc12c=g_ccc.ccc92c
         LET g_ccc.ccc12d=g_ccc.ccc92d
         LET g_ccc.ccc12e=g_ccc.ccc92e
         LET g_ccc.ccc12f=g_ccc.ccc92f   #FUN-7C0028 add
         LET g_ccc.ccc12g=g_ccc.ccc92g   #FUN-7C0028 add
         LET g_ccc.ccc12h=g_ccc.ccc92h   #FUN-7C0028 add
      ELSE
         IF SQLCA.SQLCODE=0 THEN
            LET g_ccc.ccc01 =l_ima01
            LET g_ccc.ccc91 =l_cca.cca11
            LET g_ccc.ccc92 =l_cca.cca12
            LET g_ccc.ccc92a=l_cca.cca12a
            LET g_ccc.ccc92b=l_cca.cca12b
            LET g_ccc.ccc92c=l_cca.cca12c
            LET g_ccc.ccc92d=l_cca.cca12d
            LET g_ccc.ccc92e=l_cca.cca12e
            LET g_ccc.ccc92f=l_cca.cca12f   #FUN-7C0028 add
            LET g_ccc.ccc92g=l_cca.cca12g   #FUN-7C0028 add
            LET g_ccc.ccc92h=l_cca.cca12h   #FUN-7C0028 add
            LET g_ccc.ccc23 =l_cca.cca23
            LET g_ccc.ccc23a=l_cca.cca23a
            LET g_ccc.ccc23b=l_cca.cca23b
            LET g_ccc.ccc23c=l_cca.cca23c
            LET g_ccc.ccc23d=l_cca.cca23d
            LET g_ccc.ccc23e=l_cca.cca23e
            LET g_ccc.ccc23f=l_cca.cca23f   #FUN-7C0028 add
            LET g_ccc.ccc23g=l_cca.cca23g   #FUN-7C0028 add
            LET g_ccc.ccc23h=l_cca.cca23h   #FUN-7C0028 add
            LET g_ccc.ccc11 =g_ccc.ccc91
            LET g_ccc.ccc12 =g_ccc.ccc92
            LET g_ccc.ccc12a=g_ccc.ccc92a
            LET g_ccc.ccc12b=g_ccc.ccc92b
            LET g_ccc.ccc12c=g_ccc.ccc92c
            LET g_ccc.ccc12d=g_ccc.ccc92d
            LET g_ccc.ccc12e=g_ccc.ccc92e
            LET g_ccc.ccc12f=g_ccc.ccc92f   #FUN-7C0028 add
            LET g_ccc.ccc12g=g_ccc.ccc92g   #FUN-7C0028 add
            LET g_ccc.ccc12h=g_ccc.ccc92h   #FUN-7C0028 add
         ELSE
            CALL cl_err('last0:',SQLCA.SQLCODE,0)
         END IF
      END IF
      LET g_ccc.ccc02 = yy
      LET g_ccc.ccc03 = mm
      SELECT ima57 INTO g_ccc.ccc04 FROM ima_file WHERE ima01=g_ccc.ccc01
      LET g_ccc.ccc21 = 0
      LET g_ccc.ccc22 = 0 LET g_ccc.ccc22a= 0
      LET g_ccc.ccc22b= 0 LET g_ccc.ccc22c= 0
      LET g_ccc.ccc22d= 0 LET g_ccc.ccc22e= 0
      LET g_ccc.ccc22f= 0 LET g_ccc.ccc22g= 0 LET g_ccc.ccc22h= 0   #FUN-7C0028 add
      LET g_ccc.ccc25 = 0
      LET g_ccc.ccc26 = 0 LET g_ccc.ccc26a= 0
      LET g_ccc.ccc26b= 0 LET g_ccc.ccc26c= 0
      LET g_ccc.ccc26d= 0 LET g_ccc.ccc26e= 0
      LET g_ccc.ccc26f= 0 LET g_ccc.ccc26g= 0 LET g_ccc.ccc26h= 0   #FUN-7C0028 add
      LET g_ccc.ccc27 = 0
      LET g_ccc.ccc28 = 0 LET g_ccc.ccc28a= 0
      LET g_ccc.ccc28b= 0 LET g_ccc.ccc28c= 0
      LET g_ccc.ccc28d= 0 LET g_ccc.ccc28e= 0
      LET g_ccc.ccc28f= 0 LET g_ccc.ccc28g= 0 LET g_ccc.ccc28h= 0   #FUN-7C0028 add
      LET g_ccc.ccc31 = 0 LET g_ccc.ccc32 = 0
      LET g_ccc.ccc41 = 0 LET g_ccc.ccc42 = 0
      LET g_ccc.ccc43 = 0 LET g_ccc.ccc44 = 0
      LET g_ccc.ccc51 = 0 LET g_ccc.ccc52 = 0
      LET g_ccc.ccc61 = 0 LET g_ccc.ccc63 = 0
      LET g_ccc.ccc62 = 0 LET g_ccc.ccc62a= 0
      LET g_ccc.ccc62b= 0 LET g_ccc.ccc62c= 0
      LET g_ccc.ccc62d= 0 LET g_ccc.ccc62e= 0
      LET g_ccc.ccc62f= 0 LET g_ccc.ccc62g= 0 LET g_ccc.ccc62h= 0   #FUN-7C0028 add
      LET g_ccc.ccc64 = 0 LET g_ccc.ccc65 = 0
      LET g_ccc.ccc66 = 0 LET g_ccc.ccc66a= 0
      LET g_ccc.ccc66b= 0 LET g_ccc.ccc66c= 0
      LET g_ccc.ccc66d= 0 LET g_ccc.ccc66e= 0
      LET g_ccc.ccc66f= 0 LET g_ccc.ccc66g= 0 LET g_ccc.ccc66h= 0   #FUN-7C0028 add
      LET g_ccc.ccc71 = 0 LET g_ccc.ccc72 = 0
      LET g_ccc.ccc93 = 0 LET g_ccc.ccc93a= 0
      LET g_ccc.ccc93b= 0 LET g_ccc.ccc93c= 0
      LET g_ccc.ccc93d= 0 LET g_ccc.ccc93e= 0
      LET g_ccc.ccc93f= 0 LET g_ccc.ccc93g= 0 LET g_ccc.ccc93h= 0   #FUN-7C0028 add
      LET g_ccc.cccuser=g_user
      LET g_ccc.cccdate=TODAY
      LET g_ccc.ccctime=TIME
      LET g_ccc.ccc01  =l_ima01
      CALL p510_ckp_ccc() #MOD-4A0263 CHECK ccc_file做NOT NULL欄位的判斷
      LET g_ccc.cccoriu = g_user      #No.FUN-980030 10/01/04
      LET g_ccc.cccorig = g_grup      #No.FUN-980030 10/01/04
      LET g_ccc.ccclegal = g_legal     #FUN-A50075
      INSERT INTO ccc_file VALUES (g_ccc.*)
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #TQC-790087
         UPDATE ccc_file SET *=(g_ccc.*)
          WHERE ccc01=g_ccc.ccc01 AND ccc02=g_ccc.ccc02
            AND ccc03=g_ccc.ccc03
            AND ccc07=g_ccc.ccc07 AND ccc08=g_ccc.ccc08   #FUN-7C0028 add
         IF STATUS THEN
            LET g_showmsg = g_ccc.ccc01,"/",g_ccc.ccc02                                                                #No.FUN-710027
            CALL s_errmsg('ccc01,ccc02',g_showmsg,'last0 upd ccc_file',SQLCA.sqlcode,1)                                #No.FUN-710027
         END IF
      ELSE
         IF SQLCA.sqlcode != 0 THEN
            LET g_showmsg = g_ccc.ccc01,"/",g_ccc.ccc02                                                                #No.FUN-710027
            CALL s_errmsg('ccc01,ccc02',g_showmsg,'last0 ins ccc_file',SQLCA.sqlcode,1)                                #No.FUN-710027
         END IF
      END IF
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
 
   #-->在製成本(上階)期初
   LET l_sql="SELECT ccg_file.* FROM ccg_file,ima_file",
             " WHERE ccg02=? AND ccg03=?",
             "   AND ccg06=? ",   #FUN-7C0028 add
             "   AND (ccg91<>0 OR ccg92a<>0 OR ccg92b<>0 OR ccg92c<>0 ",
                             " OR ccg92d<>0 OR ccg92e<>0 ",
                             " OR ccg92f<>0 OR ccg92g<>0 OR ccg92h<>0) ",   #FUN-7C0028 add
             "   AND ccg04 =ima01",
             "   AND ",g_wc CLIPPED
   PREPARE last0_prep1 FROM l_sql
   IF STATUS THEN
      CALL cl_err('last0 prep c1',STATUS,0)
      RETURN
   END IF
   DECLARE last0_c1 CURSOR FOR last0_prep1
   IF STATUS THEN
      CALL cl_err('last0 dcl c1',STATUS,0)
      RETURN
   END IF
   #-->在製成本(下階)期初
   LET l_sql="SELECT * FROM cch_file",
             " WHERE cch01=? ",
             "   AND cch02=",last_yy," AND cch03=",last_mm clipped
            ,"   AND cch06=? "   #FUN-7C0028 add
   PREPARE last0_prep2 FROM l_sql
   IF STATUS THEN
      CALL cl_err('last0 prep2',STATUS,0)
      RETURN
   END IF
   DECLARE last0_c2 CURSOR FOR last0_prep2
   IF STATUS THEN
      CALL cl_err('last0 dcl c2',STATUS,0)
      RETURN
   END IF
 
   FOREACH last0_c1 USING last_yy,last_mm,type INTO mccg.*   #FUN-7C0028 add type
      IF g_success='N' THEN  
         LET g_totsuccess='N'  
         LET g_success="Y"   
      END IF 
      IF g_bgjob = 'N' THEN             #FUN-570153
         MESSAGE mccg.ccg01
         CALL ui.Interface.refresh()
      END IF
      LET mccg.ccg02 =yy
      LET mccg.ccg03 =mm
      LET mccg.ccg11 =mccg.ccg91
      LET mccg.ccg12 =mccg.ccg92
      LET mccg.ccg12a=mccg.ccg92a
      LET mccg.ccg12b=mccg.ccg92b
      LET mccg.ccg12c=mccg.ccg92c
      LET mccg.ccg12d=mccg.ccg92d
      LET mccg.ccg12e=mccg.ccg92e
      LET mccg.ccg12f=mccg.ccg92f   #FUN-7C0028 add
      LET mccg.ccg12g=mccg.ccg92g   #FUN-7C0028 add
      LET mccg.ccg12h=mccg.ccg92h   #FUN-7C0028 add
      LET mccg.ccg20 =0
      LET mccg.ccg21 =0
      LET mccg.ccg22 =0 LET mccg.ccg22a=0 LET mccg.ccg22b=0
      LET mccg.ccg22c=0 LET mccg.ccg22d=0 LET mccg.ccg22e=0
      LET mccg.ccg22f=0 LET mccg.ccg22g=0 LET mccg.ccg22h=0   #FUN-7C0028 add
      LET mccg.ccg23 =0 LET mccg.ccg23a=0 LET mccg.ccg23b=0
      LET mccg.ccg23c=0 LET mccg.ccg23d=0 LET mccg.ccg23e=0
      LET mccg.ccg23f=0 LET mccg.ccg23g=0 LET mccg.ccg23h=0   #FUN-7C0028 add
      LET mccg.ccg31 =0
      LET mccg.ccg32 =0 LET mccg.ccg32a=0 LET mccg.ccg32b=0
      LET mccg.ccg32c=0 LET mccg.ccg32d=0 LET mccg.ccg32e=0
      LET mccg.ccg32f=0 LET mccg.ccg32g=0 LET mccg.ccg32h=0   #FUN-7C0028 add
      LET mccg.ccg41 =0
      LET mccg.ccg42 =0 LET mccg.ccg42a=0 LET mccg.ccg42b=0
      LET mccg.ccg42c=0 LET mccg.ccg42d=0 LET mccg.ccg42e=0
      LET mccg.ccg42f=0 LET mccg.ccg42g=0 LET mccg.ccg42h=0   #FUN-7C0028 add
      LET mccg.ccguser=g_user LET mccg.ccgdate=TODAY LET mccg.ccgtime=TIME
     #LET mccg.ccgplant = g_plant #FUN-980009 add     #FUN-A50075
      LET mccg.ccglegal = g_legal #FUN-980009 add
      LET mccg.ccg311 = 0         #No.MOD-D30006
      DELETE FROM ccg_file
       WHERE ccg01=mccg.ccg01 AND ccg02=yy AND ccg03=mm
         AND ccg06=mccg.ccg06 AND ccg07=mccg.ccg07  #FUN-7C0028 add
      LET mccg.ccgoriu = g_user      #No.FUN-980030 10/01/04
      LET mccg.ccgorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO ccg_file VALUES(mccg.*)
      IF STATUS THEN
         LET g_showmsg = mccg.ccg01,"/",mccg.ccg02                                                            #No.FUN-710027
         CALL s_errmsg('ccg01,ccg02',g_showmsg,'last ins ccg',STATUS,1)                                        #No.FUN-710027  
         CALL cl_batch_bg_javamail('N')         #FUN-570153
         CONTINUE FOREACH      #No.FUN-710027
      END IF
      DELETE FROM cch_file
       WHERE cch01=mccg.ccg01 AND cch02=yy AND cch03=mm
         AND cch06=mccg.ccg06 AND cch07=mccg.ccg07   #FUN-7C0028 add
 
      FOREACH last0_c2 USING mccg.ccg01,mccg.ccg06 INTO g_cch.*   #FUN-7C0028 add
         LET g_cch.cch02 = yy
         LET g_cch.cch03 = mm
         LET g_cch.cch11 = g_cch.cch91
         LET g_cch.cch12 = g_cch.cch92
         LET g_cch.cch12a= g_cch.cch92a
         LET g_cch.cch12b= g_cch.cch92b
         LET g_cch.cch12c= g_cch.cch92c
         LET g_cch.cch12d= g_cch.cch92d
         LET g_cch.cch12e= g_cch.cch92e
         LET g_cch.cch12f= g_cch.cch92f   #FUN-7C0028 add
         LET g_cch.cch12g= g_cch.cch92g   #FUN-7C0028 add
         LET g_cch.cch12h= g_cch.cch92h   #FUN-7C0028 add
         LET g_cch.cch21 =0
         LET g_cch.cch22 =0 LET g_cch.cch22a=0 LET g_cch.cch22b=0
         LET g_cch.cch22c=0 LET g_cch.cch22d=0 LET g_cch.cch22e=0
         LET g_cch.cch22f=0 LET g_cch.cch22g=0 LET g_cch.cch22h=0   #FUN-7C0028 add
         LET g_cch.cch31 =0
         LET g_cch.cch311=0 #FUN-660206
         LET g_cch.cch32 =0 LET g_cch.cch32a=0 LET g_cch.cch32b=0
         LET g_cch.cch32c=0 LET g_cch.cch32d=0 LET g_cch.cch32e=0
         LET g_cch.cch32f=0 LET g_cch.cch32g=0 LET g_cch.cch32h=0   #FUN-7C0028 add
         LET g_cch.cch41 =0
         LET g_cch.cch42 =0 LET g_cch.cch42a=0 LET g_cch.cch42b=0
         LET g_cch.cch42c=0 LET g_cch.cch42d=0 LET g_cch.cch42e=0
         LET g_cch.cch42f=0 LET g_cch.cch42g=0 LET g_cch.cch42h=0   #FUN-7C0028 add
         LET g_cch.cch53 =0
         LET g_cch.cch54 =0 LET g_cch.cch54a=0 LET g_cch.cch54b=0
         LET g_cch.cch54c=0 LET g_cch.cch54d=0 LET g_cch.cch54e=0
         LET g_cch.cch54f=0 LET g_cch.cch54g=0 LET g_cch.cch54h=0   #FUN-7C0028 add
         LET g_cch.cchdate = g_today
        #LET g_cch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
         LET g_cch.cchlegal = g_legal #FUN-980009 add
         LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
         LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO cch_file VALUES (g_cch.*)
         IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
            LET g_showmsg = g_cch.cch01,"/",g_cch.cch02                                                                      #No.FUN-710027
            CALL s_errmsg('cch01,cch02',g_showmsg,'last ins cch(2)::',SQLCA.SQLCODE,1)                                       #No.FUN-710027
         END IF
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
            UPDATE cch_file SET cch_file.*=g_cch.*
             WHERE cch01=mccg.ccg01 AND cch02=yy AND cch03=mm
               AND cch04=g_cch.cch04
               AND cch06=g_cch.cch06 AND cch07=g_cch.cch07   #FUN-7C0028 add
            IF STATUS THEN 
               LET g_showmsg=mccg.ccg01,"/",yy                                                                       #No.FUN-710027
               CALL s_errmsg('cch01,cch02',g_showmsg,'last0 upd cch(2)',SQLCA.SQLCODE,1)                             #No.FUN-710027
            END IF
         END IF
      END FOREACH
      CLOSE last0_c2
   END FOREACH
   IF g_totsuccess="N" THEN
      LET g_success="N"
   END IF 
   CLOSE last0_c1
END FUNCTION
 
FUNCTION p510_last()
   SELECT ccc91,ccc92,ccc92a,ccc92b,ccc92c,ccc92d,ccc92e,
                      ccc92f,ccc92g,ccc92h,ccc05   #FUN-7C0028 add ccc92f,g,h
     INTO g_ccc.ccc11,g_ccc.ccc12,g_ccc.ccc12a,g_ccc.ccc12b,
          g_ccc.ccc12c,g_ccc.ccc12d,g_ccc.ccc12e,
          g_ccc.ccc12f,g_ccc.ccc12g,g_ccc.ccc12h,g_ccc.ccc05   #FUN-7C0028 add ccc.ccc12f,g,h
     FROM ccc_file           # 取上期結存轉本月期初
    WHERE ccc01=g_ima01 AND ccc02=last_yy AND ccc03=last_mm
      AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
    IF g_ccc.ccc11=0 THEN
       LET g_ccc.ccc12 = 0
       LET g_ccc.ccc12a= 0
       LET g_ccc.ccc12b= 0
       LET g_ccc.ccc12c= 0
       LET g_ccc.ccc12d= 0
       LET g_ccc.ccc12e= 0
       LET g_ccc.ccc12f= 0   #FUN-7C0028 add
       LET g_ccc.ccc12g= 0   #FUN-7C0028 add
       LET g_ccc.ccc12h= 0   #FUN-7C0028 add
   END IF
   SELECT cca11,cca12,cca12a,cca12b,cca12c,cca12d,cca12e,
                      cca12f,cca12g,cca12h,                    #FUN-7C0028 add
                      cca23a
     INTO g_ccc.ccc11,g_ccc.ccc12,g_ccc.ccc12a,g_ccc.ccc12b,
                      g_ccc.ccc12c,g_ccc.ccc12d,g_ccc.ccc12e,
                      g_ccc.ccc12f,g_ccc.ccc12g,g_ccc.ccc12h,  #FUN-7C0028 add
                      g_cca23a
     FROM cca_file           # 取期初帳轉本月期初(讀不到沒影響)
    WHERE cca01=g_ima01 AND cca02=last_yy AND cca03=last_mm
      AND cca06=type    AND cca07=g_tlfcost   #FUN-7C0028 add
   IF cl_null(g_ccc.ccc11)  THEN LET g_ccc.ccc11 = 0 END IF
   IF cl_null(g_ccc.ccc12)  THEN LET g_ccc.ccc12 = 0 END IF
   IF cl_null(g_ccc.ccc12a) THEN LET g_ccc.ccc12a= 0 END IF
   IF cl_null(g_ccc.ccc12b) THEN LET g_ccc.ccc12b= 0 END IF
   IF cl_null(g_ccc.ccc12c) THEN LET g_ccc.ccc12c= 0 END IF
   IF cl_null(g_ccc.ccc12d) THEN LET g_ccc.ccc12d= 0 END IF
   IF cl_null(g_ccc.ccc12e) THEN LET g_ccc.ccc12e= 0 END IF
   IF cl_null(g_ccc.ccc12f) THEN LET g_ccc.ccc12f= 0 END IF  #FUN-7C0028 add
   IF cl_null(g_ccc.ccc12g) THEN LET g_ccc.ccc12g= 0 END IF  #FUN-7C0028 add
   IF cl_null(g_ccc.ccc12h) THEN LET g_ccc.ccc12h= 0 END IF  #FUN-7C0028 add
   IF cl_null(g_ccc.ccc05)  THEN LET g_ccc.ccc05 = 0 END IF
   IF cl_null(g_cca23a)     THEN LET g_cca23a    = 0 END IF
END FUNCTION
 
FUNCTION p510_tlf()             # 由 tlf_file 計算各類入出庫數量
   DEFINE l_ima57       LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_sfb38       LIKE sfb_file.sfb38
   DEFINE l_sfb02       LIKE sfb_file.sfb02
   DEFINE l_sfb05       LIKE sfb_file.sfb05
 
   IF g_bgjob = 'N' THEN             #FUN-570153
      MESSAGE '_tlf ...'
      CALL ui.Interface.refresh()
   END IF
   DECLARE p510_c2 CURSOR WITH HOLD FOR
             SELECT tlf_file.rowid,
                    tlf01,tlf06,tlf07,tlf10*tlf60,
                    tlf020,tlf02,tlf021,tlf022,tlf023,tlf026,tlf027,
                    tlf030,tlf03,tlf031,tlf032,tlf033,tlf036,tlf037,
                    tlf13,tlf62, sfb38,sfb99,''   ,sfb02,sfb05
       FROM tlf_file LEFT OUTER JOIN sfb_file ON tlf62=sfb_file.sfb01
       WHERE tlf01 = g_ima01 
         AND ((tlf02 BETWEEN 50 AND 59) OR (tlf03 BETWEEN 50 AND 59))
         AND NOT (tlf02 = 651 OR tlf03 = 651) # 98.07.04 For 拆件式報廢
         AND tlf06 BETWEEN g_bdate AND g_edate
         AND tlf902 NOT IN(SELECT jce02 FROM jce_file)
         AND tlf907 != 0
         AND tlfcost = g_tlfcost   #FUN-7C0028 add
       ORDER BY tlf13
 
   FOREACH p510_c2 INTO q_tlf_rowid, q_tlf.*, l_sfb38, g_sfb99, l_ima57,l_sfb02,l_sfb05
      IF STATUS THEN
         CALL s_errmsg('','','fore tlf!',STATUS,0)   #No.FUN-710027
         LET g_success = 'N' 
         EXIT FOREACH
      END IF
      LET l_ima57=''
      SELECT ima57 INTO l_ima57 FROM ima_file WHERE ima01=l_sfb05
      IF cl_null(q_tlf.tlf02) AND cl_null(q_tlf.tlf03) THEN
         CONTINUE FOREACH
      END IF
      IF q_tlf.tlf13 MATCHES 'asf*' AND
        (YEAR(q_tlf.tlf06)*12 + MONTH(q_tlf.tlf06) >
         YEAR(l_sfb38)    *12 + MONTH(l_sfb38)    ) THEN
         LET g_msg="料號:",g_ima01 CLIPPED,' ',
                   "工單:",q_tlf.tlf62," 異動月份超出工單結案月份:",l_sfb38
         LET t_time = TIME
         LET g_time=t_time
        #FUN-A50075--mod--str-- ccy_file del plant&legal
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
        #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                       VALUES(TODAY,g_time,g_user,g_msg)
        #FUN-A50075--mod--end
      END IF
      LET xxx=NULL
#-------------------------------------------------------------->出庫
      IF (q_tlf.tlf02 = 50 OR q_tlf.tlf02 = 57)  THEN
         CALL s_get_doc_no(q_tlf.tlf026) RETURNING xxx
         LET xxx1=q_tlf.tlf026 LET xxx2=q_tlf.tlf027
         LET u_sign=-1
      END IF
#-------------------------------------------------------------->入庫
      IF (q_tlf.tlf03 = 50 OR q_tlf.tlf03 = 57)  THEN
         CALL s_get_doc_no(q_tlf.tlf036) RETURNING xxx
         LET xxx1=q_tlf.tlf036 LET xxx2=q_tlf.tlf037
         LET u_sign=1
      END IF
#-------------------------------------------------------------->二階段調撥(出)
       IF (q_tlf.tlf02 = 50 AND q_tlf.tlf03 = 57)  THEN
          CALL s_get_doc_no(q_tlf.tlf026) RETURNING xxx
          LET xxx1=q_tlf.tlf026 LET xxx2=q_tlf.tlf027
          LET u_sign=-1
       END IF
#-------------------------------------------------------------->取成會分類
      IF xxx IS NULL THEN CONTINUE FOREACH END IF
      LET u_flag='' LET g_smydmy1=''
      SELECT smydmy2,smydmy1,smy53,smy54 INTO u_flag,g_smydmy1,g_smy53,g_smy54
        FROM smy_file WHERE smyslip=xxx
      IF STATUS THEN            # V2.0版沒有smy53,smy54
         SELECT smydmy2,smydmy1 INTO u_flag,g_smydmy1
           FROM smy_file WHERE smyslip=xxx
      END IF
      IF g_smydmy1='N' THEN CONTINUE FOREACH END IF
 
      IF q_tlf.tlf13='aimp880' THEN LET u_flag='6' END IF
      IF u_flag NOT MATCHES "[12356]" OR u_flag IS NULL THEN
         CONTINUE FOREACH
      END IF
#--------------------------------------------------------------
      IF u_flag='3' AND (g_sfb99 IS NULL OR g_sfb99 = ' ' OR g_sfb99 = 'N') AND
         g_tlf.tlf13 NOT MATCHES 'aimt3*' AND    #No.3564 add
         g_ima57_t <= l_ima57 THEN
         LET g_msg="料號:",g_ima01 CLIPPED,' ',
                   "工單:",q_tlf.tlf62," 下階碼小於上階碼但工單未設重工"
         LET t_time = TIME
         LET g_time=t_time
        #FUN-A50075--mod--str-- ccy_file del plant&legal
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
        #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                       VALUES(TODAY,g_time,g_user,g_msg)
        #FUN-A50075--mod--end
         LET g_sfb99 = 'Y'
      END IF
      IF q_tlf.tlf13[1,5]='asfi5' AND g_sfb99='Y' AND l_ima57<g_ima57_t THEN
         LET g_sfb99='N'
      END IF
      IF q_tlf.tlf10 = 0 THEN CONTINUE FOREACH END IF
#-------------------------------------------------------------->分類統計
      CASE WHEN q_tlf.tlf13[1,4]='axmt' OR q_tlf.tlf13 = 'aomt800'   #銷貨領出
                LET g_ccc.ccc61=g_ccc.ccc61+q_tlf.tlf10*u_sign
                CALL p510_ccc63_cost(u_sign)
                IF u_sign = 1 THEN
                   LET g_ccc.ccc64=g_ccc.ccc64+q_tlf.tlf10*u_sign
                END IF
           WHEN q_tlf.tlf13='aimt301' OR q_tlf.tlf13='aimt311'
               #(aimt303,aimt313)應列入雜發異動中
                OR q_tlf.tlf13 = 'aimt303' OR q_tlf.tlf13 = 'aimt313'
                LET g_ccc.ccc41=g_ccc.ccc41+q_tlf.tlf10*u_sign
           WHEN q_tlf.tlf13[1,5]='asfi5'   #工單發料
                IF g_sfb99='Y' THEN        #重工領出
                   LET g_ccc.ccc25=g_ccc.ccc25+q_tlf.tlf10*u_sign
                ELSE                       #一般工單領出
                   LET g_ccc.ccc31=g_ccc.ccc31+q_tlf.tlf10*u_sign
                END IF
           WHEN q_tlf.tlf13[1,5]='asft6'   #工單入庫
                IF q_tlf.tlf02 = 65 OR q_tlf.tlf03 = 65 THEN # 拆件工單
                   LET g_ccc.ccc31=g_ccc.ccc31+q_tlf.tlf10*u_sign
                ELSE
                   IF g_sfb99='Y' THEN     #重工入庫
                 # IF g_sfb99='Y' AND l_sfb02<>'7' THEN     #重工入庫
                      LET g_ccc.ccc27=g_ccc.ccc27+q_tlf.tlf10*u_sign
                   ELSE                    #一般入庫
                      LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                      CALL p510_ccc22_cost()
                   END IF
                END IF
           #------------------------------------------------
           WHEN q_tlf.tlf13[1,7]='asft700'  #當站下線
                LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10
                CALL p510_ccc22_cost2()  #統計當站下線成本
           #------------------------------------------------
           WHEN q_tlf.tlf13 = 'aimt302' OR q_tlf.tlf13 = 'aimt312'
                LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10
                LET g_ccc.ccc43=g_ccc.ccc43+q_tlf.tlf10
                CALL p510_ccc22_cost()
          #CHI-CB0001---add---S
           WHEN q_tlf.tlf13 = 'aimt306' OR q_tlf.tlf13 = 'aimt309'   #借還料
                   LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                   LET g_ccc.ccc43=g_ccc.ccc43+q_tlf.tlf10*u_sign
                   CALL p510_ccc22_cost()
          #CHI-CB0001---add---E
           WHEN u_flag='1'                 #一般工單入庫,採購入,倉退
                LET g_ccc.ccc21=g_ccc.ccc21+q_tlf.tlf10*u_sign
                CALL p510_ccc22_cost()
           WHEN u_flag='5'                 #調整
                LET g_ccc.ccc51=g_ccc.ccc51+q_tlf.tlf10*u_sign
           WHEN u_flag='6'                 #盤差
                LET g_ccc.ccc71=g_ccc.ccc71+q_tlf.tlf10*u_sign
           OTHERWISE CONTINUE FOREACH
      END CASE
      CALL p510_tlf15_upd()
 
      #新增tlfc_file記錄依 "成本計算類別"  的異動成本
      CALL p510_ins_tlfc(q_tlf_rowid)   #FUN-7C0028 add
   END FOREACH
   CLOSE p510_c2
END FUNCTION
 
#統計當站下線成本
FUNCTION p510_ccc22_cost2()
  DEFINE l_cah08   LIKE cah_file.cah08
  DEFINE l_cah08a  LIKE cah_file.cah08a
  DEFINE l_cah08b  LIKE cah_file.cah08b
  DEFINE l_cah08c  LIKE cah_file.cah08c
  DEFINE l_cah08d  LIKE cah_file.cah08d
  DEFINE l_cah08e  LIKE cah_file.cah08e
 
  DECLARE cah_cur CURSOR FOR
    SELECT SUM(cah08)*-1,SUM(cah08a)*-1,SUM(cah08b)*-1,
           SUM(cah08c)*-1,SUM(cah08d)*-1,SUM(cah08e)*-1
      FROM cah_file  WHERE cah01=q_tlf.tlf62
       AND cah02=yy  AND cah03=mm  AND cah04=q_tlf.tlf01
  FOREACH cah_cur INTO l_cah08,l_cah08a,l_cah08b,l_cah08c,l_cah08d,l_cah08e
     IF STATUS THEN CALL cl_err('cah_for',STATUS,0) EXIT FOREACH END IF
     LET g_ccc.ccc22 =g_ccc.ccc22 +l_cah08
     LET g_ccc.ccc22a=g_ccc.ccc22a+l_cah08a
     LET g_ccc.ccc22b=g_ccc.ccc22b+l_cah08b
     LET g_ccc.ccc22c=g_ccc.ccc22c+l_cah08c
     LET g_ccc.ccc22d=g_ccc.ccc22d+l_cah08d
     LET g_ccc.ccc22e=g_ccc.ccc22e+l_cah08e
  END FOREACH
END FUNCTION
 
FUNCTION p510_ccc22_cost()
   DEFINE l_pmm02                 LIKE pmm_file.pmm02,    #No.FUN-680122 VARCHAR(3),
          l_pmm22                 LIKE pmm_file.pmm22,
          l_pmm42                 LIKE pmm_file.pmm42,
          l_ccc23                 LIKE ccc_file.ccc23,
          l_ccc23a                LIKE ccc_file.ccc23a,
          l_ccc23b                LIKE ccc_file.ccc23b,
          l_ccc23c                LIKE ccc_file.ccc23c,
          l_ccc23d                LIKE ccc_file.ccc23d,
          l_ccc23e                LIKE ccc_file.ccc23e,
          l_ccc23f                LIKE ccc_file.ccc23f,   #FUN-7C0028 add
          l_ccc23g                LIKE ccc_file.ccc23g,   #FUN-7C0028 add
          l_ccc23h                LIKE ccc_file.ccc23h,   #FUN-7C0028 add
          l_rva06                 LIKE rva_file.rva06,
          l_exrate1,l_exrate2     LIKE pmm_file.pmm42,
          l_c23a,l_c23b,l_c23c    LIKE ccc_file.ccc23,
          x_flag                  LIKE type_file.chr1,          #No.FUN-680122 VARCHAR(1)
          l_rvv                   RECORD LIKE rvv_file.*,
          l_apa44                 LIKE apa_file.apa44,
          amt_1,amt_2,amtx        LIKE type_file.num20_6,      #No.FUN-680122 DEC(20,6),                 #MOD-4C0005
          l_qty                   LIKE tlf_file.tlf10
 
   IF q_tlf.tlf13 MATCHES 'asf*' THEN RETURN END IF
   #工單入庫成本應由WIP轉入,故加工費於 wip_2_22() 計算時歸入投入成本,再轉入庫
   IF q_tlf.tlf13 matches 'apmt107*' THEN
      LET l_pmm02=NULL
      SELECT pmm02 INTO l_pmm02 FROM pmm_file 
       WHERE pmm01=q_tlf.tlf036 AND pmm18 <> 'X'
      IF l_pmm02='SUB' THEN RETURN END IF               #-->委外退庫亦由WIP轉出
   END IF
   LET amt=0  LET amta = 0 LET amtb = 0 LET amtc = 0 LET amtd = 0 LET amte = 0
   LET amtf=0 LET amtg = 0 LET amth = 0   #FUN-7C0028 add
   IF g_ccz.ccz03='2' THEN              # 實際成本制
      CASE WHEN q_tlf.tlf13 MATCHES 'aimt30*'                   #雜項入zzz
              #1.人工維護 2.當月(包含開帳) 3.上月單價
              CALL p510_ccc44_cost() RETURNING l_ccc23,l_ccc23a,l_ccc23b,
                                               l_ccc23c,l_ccc23d,l_ccc23e
                                              ,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-7C0028 add
              LET amt=l_ccc23 * q_tlf.tlf10 * u_sign
              LET amta=l_ccc23a * q_tlf.tlf10 * u_sign
              LET amtb=l_ccc23b * q_tlf.tlf10 * u_sign
              LET amtc=l_ccc23c * q_tlf.tlf10 * u_sign
              LET amtd=l_ccc23d * q_tlf.tlf10 * u_sign
              LET amte=l_ccc23e * q_tlf.tlf10 * u_sign
              LET amtf=l_ccc23f * q_tlf.tlf10 * u_sign   #FUN-7C0028 add
              LET amtg=l_ccc23g * q_tlf.tlf10 * u_sign   #FUN-7C0028 add
              LET amth=l_ccc23h * q_tlf.tlf10 * u_sign   #FUN-7C0028 add
              LET g_ccc.ccc44 = g_ccc.ccc44 + amt
           WHEN q_tlf.tlf13 = 'aimt720' OR #調撥入庫
                q_tlf.tlf13 = 'aimp700' OR q_tlf.tlf13 = 'aimp701'
              LET amt  = g_ccc.ccc23 * q_tlf.tlf10
              LET amta = g_ccc.ccc23a * q_tlf.tlf10
              LET amtb = g_ccc.ccc23b * q_tlf.tlf10
              LET amtc = g_ccc.ccc23c * q_tlf.tlf10
              LET amtd = g_ccc.ccc23d * q_tlf.tlf10
              LET amtf = g_ccc.ccc23f * q_tlf.tlf10   #FUN-7C0028 add
              LET amtg = g_ccc.ccc23g * q_tlf.tlf10   #FUN-7C0028 add
              LET amth = g_ccc.ccc23h * q_tlf.tlf10   #FUN-7C0028 add
           OTHERWISE
                #-->發票請款立帳
                LET l_apa44 = ''
                LET amt_1 = 0 LET amt_2 = 0 LET x_flag = 'N'
                DECLARE apa_cursor CURSOR FOR
                 SELECT apa44,SUM(ABS(apb101))   #No.TQC-7C0126
                  FROM apb_file,apa_file
                 WHERE apb21=xxx1 AND apb22=xxx2 AND apb01=apa01
                   AND apa00 = '11' AND apa75 != 'Y'
                   AND apa42 = 'N'
                   AND apa02 BETWEEN g_bdate AND g_edate
                   AND apb34 <> 'Y'  #No.TQC-7C0126
                  GROUP BY apa44
                LET amtx = 0
                FOREACH apa_cursor INTO l_apa44,amtx
                   LET amt_1 = amt_1 + amtx  LET x_flag = 'Y'
                END FOREACH
                IF amt_1 IS NULL THEN LET amt_1 = 0 END IF
                #-->扣除折讓部份(退貨)
                DECLARE apa_cursor1 CURSOR FOR
                 SELECT apa44,SUM(ABS(apb101))   #No.TQC-7C0126
                  FROM apb_file,apa_file
                 WHERE apb21=xxx1 AND apb22=xxx2 AND apb01=apa01
                   AND apa00 = '21' AND apa58 = '2' AND apa75 != 'Y'
                   AND apa42 = 'N'
                   AND apa02 BETWEEN g_bdate AND g_edate
                   AND apb34 <> 'Y'  #No.TQC-7C0126
                  GROUP BY apa44
                LET amtx = 0
                FOREACH apa_cursor1 INTO l_apa44,amtx
                   LET amt_2 = amt_2 + amtx LET x_flag = 'Y'
                END FOREACH
                IF amt_2 IS NULL THEN LET amt_2 = 0 END IF
                LET amt = amt_1-amt_2
                #-->不決定正負數
                IF amt < 0 THEN LET amt = amt * -1 END IF
                IF x_flag = 'N' THEN
                   DECLARE ale_cursor CURSOR FOR
                   SELECT alk72,SUM(ale09)  #INTO amt
                     FROM ale_file ,alk_file
                    WHERE ale16=xxx1 AND ale17=xxx2 AND ale01=alk01
                      AND alkfirm <> 'X'  #CHI-C80041
                    GROUP BY alk72
                   LET amtx = 0
                   FOREACH ale_cursor INTO l_apa44,amtx
                      LET amt = amt + amtx LET x_flag = 'Y'
                   END FOREACH
                   #--> 供月中暫估成本使用
                   IF x_flag = 'N' THEN
                      SELECT * INTO l_rvv.* FROM rvv_file
                       WHERE rvv01=xxx1 AND rvv02=xxx2
                         AND rvv25 != 'Y'
                      IF STATUS = 0 THEN
                         #--> 直接取 P/O 上的匯率
                         SELECT pmm22,rva06,pmm42 INTO l_pmm22,l_rva06,l_pmm42
                           FROM rvb_file,pmm_file,rva_file
                          WHERE rvb01=l_rvv.rvv04 AND rvb02=l_rvv.rvv05
                            AND pmm01=rvb04 AND rva01 = rvb01
                            AND rvaconf <> 'X' AND pmm18 <> 'X'
                         IF STATUS <> 0 THEN
                            LET l_pmm22=' '
                            LET l_pmm42= 1
                         END IF
                         IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                         LET amt=l_rvv.rvv39*l_pmm42
                      END IF
                      IF amt IS NULL THEN LET amt=0 END IF
                   END IF
                END IF
 
                IF (l_apa44 IS NULL OR l_apa44 = ' ') THEN
                   LET l_apa44 = 'UNAP'
                END IF
                # 進料退出, 調整金額
          LET amta = amt
      END CASE
      IF amt IS NULL THEN LET amt=0 END IF
      IF amta IS NULL THEN LET amta=0 END IF
      IF amtb IS NULL THEN LET amtb=0 END IF
      IF amtc IS NULL THEN LET amtc=0 END IF
      IF amtd IS NULL THEN LET amtd=0 END IF
      IF amte IS NULL THEN LET amte=0 END IF
      IF amtf IS NULL THEN LET amtf=0 END IF   #FUN-7C0028 add
      IF amtg IS NULL THEN LET amtg=0 END IF   #FUN-7C0028 add
      IF amth IS NULL THEN LET amth=0 END IF   #FUN-7C0028 add
      LET g_ccc.ccc22 =g_ccc.ccc22 +amt*u_sign
      LET g_ccc.ccc22a=g_ccc.ccc22a+amta*u_sign
      LET g_ccc.ccc22b=g_ccc.ccc22b+amtb*u_sign
      LET g_ccc.ccc22c=g_ccc.ccc22c+amtc*u_sign
      LET g_ccc.ccc22d=g_ccc.ccc22d+amtd*u_sign
      LET g_ccc.ccc22e=g_ccc.ccc22e+amte*u_sign
      LET g_ccc.ccc22f=g_ccc.ccc22f+amtf*u_sign   #FUN-7C0028 add
      LET g_ccc.ccc22g=g_ccc.ccc22g+amtg*u_sign   #FUN-7C0028 add
      LET g_ccc.ccc22h=g_ccc.ccc22h+amth*u_sign   #FUN-7C0028 add
   END IF
   #--->更新
   LET t_time = TIME
   LET g_time=t_time
 
   IF q_tlf.tlf13 != 'aimt302' and q_tlf.tlf13 != 'aimt312' THEN
      UPDATE tlf_file SET tlf21  =amt,
                          tlf221 =amta,
                          tlf222 =amtb,
                          tlf2231=amtc,
                          tlf2232=amtd,
                          tlf224 =amte,
                          tlf2241=amtf,   #FUN-7C0028 add
                          tlf2242=amtg,   #FUN-7C0028 add
                          tlf2243=amth,   #FUN-7C0028 add
                          tlf211 =TODAY,
                          tlf212 =g_time,
                          tlf65  =l_apa44
             WHERE rowid=q_tlf_rowid    #zzz
      IF STATUS THEN 
         CALL cl_err3("upd","tlf_file","","",STATUS,"","upd tlf21:",0)   #No.FUN-660127
      END IF
   END IF
   LET l_apa44 = '' LET x_flag = ''
END FUNCTION
 
FUNCTION p510_ccc44_cost() #雜入成本
   DEFINE l_qty LIKE tlf_file.tlf10,
          l_inb13  LIKE inb_file.inb13,
#FUN-AB0089--add--begin
          l_inb132 LIKE inb_file.inb132,
          l_inb133 LIKE inb_file.inb133,
          l_inb134 LIKE inb_file.inb134,
          l_inb135 LIKE inb_file.inb135,
          l_inb136 LIKE inb_file.inb136,
          l_inb137 LIKE inb_file.inb137,
          l_inb138 LIKE inb_file.inb138,
#FUN-AB0089--add--end
          l_ccc23  LIKE ccc_file.ccc23,
          l_ccc23a LIKE ccc_file.ccc23a,
          l_ccc23b LIKE ccc_file.ccc23b,
          l_ccc23c LIKE ccc_file.ccc23c,
          l_ccc23d LIKE ccc_file.ccc23d,
          l_ccc23e LIKE ccc_file.ccc23e,
          l_ccc23f LIKE ccc_file.ccc23f,   #FUN-7C0028 add
          l_ccc23g LIKE ccc_file.ccc23g,   #FUN-7C0028 add
          l_ccc23h LIKE ccc_file.ccc23h,    #FUN-7C0028 add  #CHI-CB0001 add,
         #CHI-CB0001---add---S 
          l_inb04  LIKE inb_file.inb04,    
          l_inb08  LIKE inb_file.inb08,    
          l_ima25  LIKE ima_file.ima25,  
          l_sw     LIKE type_file.chr1, 
          l_fac    LIKE inb_file.inb08_fac,
          l_imp09  LIKE imp_file.imp09   
         #CHI-CB0001---add---E
 
   LET l_qty = g_ccc.ccc11+g_ccc.ccc21
   #--->(2)先取本月單價

  #CHI-CB0001---add---S
   IF q_tlf.tlf13 MATCHES 'aimt30*'
      OR q_tlf.tlf13 MATCHES 'aimt31*'  THEN
      IF q_tlf.tlf13 !='aimt306' AND q_tlf.tlf13 != 'aimt309' THEN  
         IF g_ccc.ccc11 = 0 AND g_ccc.ccc21 = 0 AND q_tlf.tlf10 = 0 THEN 
  #CHI-CB0001---add---E
   #IF l_qty=0 THEN
         LET l_ccc23 =0 LET l_ccc23a=0 LET l_ccc23b=0
         LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
         LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0   #FUN-7C0028 add
      ELSE
         SELECT inb13,inb132,inb133,inb134,inb135,inb136,inb137,inb138                                     #FUN-AB0089
             INTO l_inb13,l_inb132,l_inb133,l_inb134,l_inb135,l_inb136,l_inb137,l_inb138 FROM inb_file  #FUN-AB0089
          WHERE inb01 = xxx1 AND inb03 = xxx2
         IF cl_null(l_inb13) THEN LET l_inb13 = 0 END IF
         IF cl_null(l_inb132) THEN LET l_inb132 = 0 END IF
         IF cl_null(l_inb133) THEN LET l_inb133 = 0 END IF
         IF cl_null(l_inb134) THEN LET l_inb134 = 0 END IF
         IF cl_null(l_inb135) THEN LET l_inb135 = 0 END IF
         IF cl_null(l_inb136) THEN LET l_inb136 = 0 END IF
         IF cl_null(l_inb137) THEN LET l_inb137 = 0 END IF
         IF cl_null(l_inb138) THEN LET l_inb138 = 0 END IF
         LET l_ccc23a=l_inb13
         #CHI-CB0001---add---S
            IF cl_null(l_inb04) THEN LET l_inb04 = ' ' END IF
            IF cl_null(l_inb08) THEN LET l_inb08 = ' ' END IF
            SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=l_inb04
            IF STATUS THEN LET l_ima25 = ' '  END IF
            CALL s_umfchk(l_inb04,l_inb08,l_ima25) RETURNING l_sw,l_fac
            IF l_sw THEN
               LET l_inb13  = 0
               LET l_inb132 = 0
               LET l_inb133 = 0
               LET l_inb134 = 0
               LET l_inb135 = 0
               LET l_inb136 = 0
               LET l_inb137 = 0
               LET l_inb138 = 0
            ELSE
               LET l_inb13  = l_inb13  / l_fac
               LET l_inb132 = l_inb132 / l_fac
               LET l_inb133 = l_inb133 / l_fac
               LET l_inb134 = l_inb134 / l_fac
               LET l_inb135 = l_inb135 / l_fac
               LET l_inb136 = l_inb136 / l_fac
               LET l_inb137 = l_inb137 / l_fac
               LET l_inb138 = l_inb138 / l_fac
            END IF
           #CHI-CB0001---add---E
#FUN-AB0089--mark--begin
#     LET l_ccc23b=0
#     LET l_ccc23c=0
#     LET l_ccc23d=0
#     LET l_ccc23e=0
#     LET l_ccc23f=0   #FUN-7C0028 add
#     LET l_ccc23g=0   #FUN-7C0028 add
#     LET l_ccc23h=0   #FUN-7C0028 add
#FUN-AB0089--mark--end
#FUN-AB0089--add--begiin
           LET l_ccc23b=l_inb132
           LET l_ccc23c=l_inb133
           LET l_ccc23d=l_inb134
           LET l_ccc23e=l_inb135
           LET l_ccc23f=l_inb136   
           LET l_ccc23g=l_inb137 
           LET l_ccc23h=l_inb138
#FUN-AB0089--add--end
           LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e
                  +l_ccc23f+l_ccc23g+l_ccc23h   #FUN-7C0028 add
           
           IF STATUS OR cl_null(l_ccc23) OR l_ccc23 = 0 THEN
              LET g_msg="料號:",g_ccc.ccc01 CLIPPED,' ',
                     "無雜收單價請輸入雜收單價:(axcti500)"
              LET t_time = TIME
              LET g_time=t_time
            #FUN-A50075--mod--str-- ccy_file del plant&legal
            #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
            #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
            INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                            VALUES(TODAY,g_time,g_user,g_msg)
            #FUN-A50075--mod--end
           END IF
         END IF             #CHI-CB0001 
      END IF                #CHI-CB0001 
   END IF                   #CHI-CB0001  
   
   #CHI-CB0001---add---S
   #將下面這段抓借還料aimt306,aimt309的異動成本部份獨立出來,
   #           不然當碰到原數償還時,ccc11與ccc21會是0,這樣永遠都進不來這段
   #借還料
   IF q_tlf.tlf13 = 'aimt306' THEN   #借料
      LET l_imp09 = 0
      LET l_ccc23a= 0
      SELECT imp09 INTO l_imp09 FROM imp_file
       WHERE imp01 = q_tlf.tlf036    #借料單號
         AND imp02 = q_tlf.tlf037    #借料項次
      IF cl_null(l_imp09) THEN LET l_imp09 = 0 END IF
      LET l_ccc23a=l_imp09 LET l_ccc23b=0
      LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
      LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0  
      LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e
                          +l_ccc23f+l_ccc23g+l_ccc23h   

      #將訊息從下面搬上來
      IF STATUS OR cl_null(l_ccc23) OR l_ccc23 = 0 THEN
         CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
         CALL cl_getmsg('axc-512',g_lang) RETURNING g_msg2
         LET g_msg=g_msg1 CLIPPED,g_ccc.ccc01 CLIPPED,' ',
                   g_msg2 CLIPPED,":(aimt306)"  

         LET t_time = TIME
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                       VALUES(TODAY,t_time,g_user,g_msg) 
      END IF
   END IF

   IF q_tlf.tlf13 = 'aimt309' THEN   #還料
      LET l_imp09 = 0
      LET l_ccc23a= 0
      SELECT imp09 INTO l_imp09 FROM imp_file
       WHERE imp01 = q_tlf.tlf036    #借料單號
         AND imp02 = q_tlf.tlf037    #借料項次
      IF cl_null(l_imp09) THEN LET l_imp09 = 0 END IF
      LET l_ccc23a=l_imp09 LET l_ccc23b=0
      LET l_ccc23c=0 LET l_ccc23d=0 LET l_ccc23e=0
      LET l_ccc23f=0 LET l_ccc23g=0 LET l_ccc23h=0  
      LET l_ccc23=l_ccc23a+l_ccc23b+l_ccc23c+l_ccc23d+l_ccc23e
                          +l_ccc23f+l_ccc23g+l_ccc23h   

     #將訊息從下面搬上來
     IF STATUS OR cl_null(l_ccc23) OR l_ccc23 = 0 THEN
        CALL cl_getmsg('axc-521',g_lang) RETURNING g_msg1
        CALL cl_getmsg('axc-512',g_lang) RETURNING g_msg2
        LET g_msg=g_msg1 CLIPPED,g_ccc.ccc01 CLIPPED,' ',
                  g_msg2 CLIPPED,":(aimt309)"   

        LET t_time = TIME
        INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      VALUES(TODAY,t_time,g_user,g_msg)  
     END IF
   END IF
  #CHI-CB0001---add---E
   RETURN l_ccc23,l_ccc23a,l_ccc23b,l_ccc23c,l_ccc23d,l_ccc23e
                 ,l_ccc23f,l_ccc23g,l_ccc23h   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_ccc63_cost(l_tlf907)  #銷貨收入
   DEFINE l_tlf907  LIKE tlf_file.tlf907
 
   LET amt=0
   IF l_tlf907 = -1 THEN
      SELECT SUM(omb16) INTO amt #本幣未稅金額
        FROM omb_file,oma_file
       WHERE omb31=xxx1 AND omb32=xxx2 AND oma00 MATCHES '1*'
         AND oma01 = omb01
      IF amt IS NULL THEN LET amt=0 END IF
      IF q_tlf.tlf10 < 0 THEN LET amt = amt * -1 END IF
   ELSE
      SELECT SUM(omb16) INTO amt #本幣未稅金額
        FROM omb_file,oma_file
       WHERE omb31=xxx1 AND omb32=xxx2 AND oma00 MATCHES '2*'
         AND oma01 = omb01 AND omb12 != 0
      IF amt IS NULL THEN LET amt=0 END IF
      LET amt = amt * -1
   END IF
      LET g_ccc.ccc63 = g_ccc.ccc63 + amt
   IF l_tlf907 = 1 THEN #銷貨退回
      LET amt = amt * -1
      LET g_ccc.ccc65 = g_ccc.ccc65 + amt
   END IF
END FUNCTION
 
FUNCTION p510_ccb_cost()        # 加上入庫調整金額
   DEFINE l_ccb         RECORD LIKE ccb_file.*
   SELECT SUM(ccb22),SUM(ccb22a),SUM(ccb22b),SUM(ccb22c),SUM(ccb22d),SUM(ccb22e)
                    ,SUM(ccb22f),SUM(ccb22g),SUM(ccb22h)   #FUN-7C0028 add
     INTO l_ccb.ccb22, l_ccb.ccb22a,l_ccb.ccb22b,
          l_ccb.ccb22c,l_ccb.ccb22d,l_ccb.ccb22e 
         ,l_ccb.ccb22f,l_ccb.ccb22g,l_ccb.ccb22h           #FUN-7C0028 add
     FROM ccb_file
    WHERE ccb01=g_ima01 AND ccb02=yy AND ccb03=mm
      AND ccb06=type    AND ccb07=g_tlfcost                #FUN-7C0028 add
   IF l_ccb.ccb22 IS NULL THEN
      LET l_ccb.ccb22 =0 LET l_ccb.ccb22a=0 LET l_ccb.ccb22b=0
      LET l_ccb.ccb22c=0 LET l_ccb.ccb22d=0 LET l_ccb.ccb22e=0
      LET l_ccb.ccb22f=0 LET l_ccb.ccb22g=0 LET l_ccb.ccb22h=0   #FUN-7C0028 add
   END IF
   LET g_ccc.ccc22 =g_ccc.ccc22 +l_ccb.ccb22
   LET g_ccc.ccc22a=g_ccc.ccc22a+l_ccb.ccb22a
   LET g_ccc.ccc22b=g_ccc.ccc22b+l_ccb.ccb22b
   LET g_ccc.ccc22c=g_ccc.ccc22c+l_ccb.ccb22c
   LET g_ccc.ccc22d=g_ccc.ccc22d+l_ccb.ccb22d
   LET g_ccc.ccc22e=g_ccc.ccc22e+l_ccb.ccb22e
   LET g_ccc.ccc22f=g_ccc.ccc22f+l_ccb.ccb22f    #FUN-7C0028 add
   LET g_ccc.ccc22g=g_ccc.ccc22g+l_ccb.ccb22g    #FUN-7C0028 add
   LET g_ccc.ccc22h=g_ccc.ccc22h+l_ccb.ccb22h    #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_ccg_cost()        # 加上WIP入庫金額
   DEFINE l_ccg         RECORD LIKE ccg_file.*
   DEFINE l_cah08   LIKE cah_file.cah08
   DEFINE l_cah08a  LIKE cah_file.cah08a
   DEFINE l_cah08b  LIKE cah_file.cah08b
   DEFINE l_cah08c  LIKE cah_file.cah08c
   DEFINE l_cah08d  LIKE cah_file.cah08d
   DEFINE l_cah08e  LIKE cah_file.cah08e
 
   SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
          SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
         ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
     INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
          l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
         ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h         #FUN-7C0028 add
     FROM ccg_file, sfb_file
    WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
      AND ccg06=type    AND ccg07=g_tlfcost              #FUN-7C0028 add
      AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11'
      AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N' ) #OR sfb02 = '7')
   IF l_ccg.ccg32 IS NULL THEN
      LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
      LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
      LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
   END IF
   LET g_ccc.ccc22 =g_ccc.ccc22 +l_ccg.ccg32
   LET g_ccc.ccc22a=g_ccc.ccc22a+l_ccg.ccg32a
   LET g_ccc.ccc22b=g_ccc.ccc22b+l_ccg.ccg32b
   LET g_ccc.ccc22c=g_ccc.ccc22c+l_ccg.ccg32c
   LET g_ccc.ccc22d=g_ccc.ccc22d+l_ccg.ccg32d
   LET g_ccc.ccc22e=g_ccc.ccc22e+l_ccg.ccg32e
   LET g_ccc.ccc22f=g_ccc.ccc22f+l_ccg.ccg32f   #FUN-7C0028 add
   LET g_ccc.ccc22g=g_ccc.ccc22g+l_ccg.ccg32g   #FUN-7C0028 add
   LET g_ccc.ccc22h=g_ccc.ccc22h+l_ccg.ccg32h   #FUN-7C0028 add
   
   #入庫金額必須扣除下線金額
   LET l_cah08=0
   LET l_cah08a=0
   LET l_cah08b=0
   LET l_cah08c=0
   LET l_cah08d=0
   LET l_cah08e=0
   SELECT SUM(cah08)*-1,SUM(cah08a)*-1,SUM(cah08b)*-1,
          SUM(cah08c)*-1,SUM(cah08d)*-1,SUM(cah08e)*-1
     INTO l_cah08,l_cah08a,l_cah08b,l_cah08c,l_cah08d,l_cah08e
     FROM cah_file,sfb_file
    WHERE cah01=sfb01
      AND sfb05=g_ima01
      AND cah02=yy  AND cah03=mm
   IF cl_null(l_cah08 ) THEN LET l_cah08 =0 END IF
   IF cl_null(l_cah08a) THEN LET l_cah08a=0 END IF
   IF cl_null(l_cah08b) THEN LET l_cah08b=0 END IF
   IF cl_null(l_cah08c) THEN LET l_cah08c=0 END IF
   IF cl_null(l_cah08d) THEN LET l_cah08d=0 END IF
   IF cl_null(l_cah08e) THEN LET l_cah08e=0 END IF
   LET g_ccc.ccc22 =g_ccc.ccc22 -l_cah08
   LET g_ccc.ccc22a=g_ccc.ccc22a-l_cah08a
   LET g_ccc.ccc22b=g_ccc.ccc22b-l_cah08b
   LET g_ccc.ccc22c=g_ccc.ccc22c-l_cah08c
   LET g_ccc.ccc22d=g_ccc.ccc22d-l_cah08d
   LET g_ccc.ccc22e=g_ccc.ccc22e-l_cah08e
END FUNCTION
 
FUNCTION p510_ccg2_cost()       # 加上WIP重工入庫金額
   DEFINE l_ccg         RECORD LIKE ccg_file.*
   SELECT SUM(ccg32 *-1),SUM(ccg32a*-1),SUM(ccg32b*-1),
          SUM(ccg32c*-1),SUM(ccg32d*-1),SUM(ccg32e*-1)
         ,SUM(ccg32f*-1),SUM(ccg32g*-1),SUM(ccg32h*-1)   #FUN-7C0028 add
     INTO l_ccg.ccg32, l_ccg.ccg32a,l_ccg.ccg32b,
          l_ccg.ccg32c,l_ccg.ccg32d,l_ccg.ccg32e
         ,l_ccg.ccg32f,l_ccg.ccg32g,l_ccg.ccg32h         #FUN-7C0028 add
     FROM ccg_file, sfb_file
    WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
      AND ccg06=type    AND ccg07=g_tlfcost              #FUN-7C0028 add
      AND ccg01=sfb01 AND sfb02 != '13' AND sfb02 != '11' AND sfb99 = 'Y'
   IF l_ccg.ccg32 IS NULL THEN
      LET l_ccg.ccg32 =0 LET l_ccg.ccg32a=0 LET l_ccg.ccg32b=0
      LET l_ccg.ccg32c=0 LET l_ccg.ccg32d=0 LET l_ccg.ccg32e=0
      LET l_ccg.ccg32f=0 LET l_ccg.ccg32g=0 LET l_ccg.ccg32h=0   #FUN-7C0028 add
   END IF
   LET g_ccc.ccc28 =g_ccc.ccc28 +l_ccg.ccg32
   LET g_ccc.ccc28a=g_ccc.ccc28a+l_ccg.ccg32a
   LET g_ccc.ccc28b=g_ccc.ccc28b+l_ccg.ccg32b
   LET g_ccc.ccc28c=g_ccc.ccc28c+l_ccg.ccg32c
   LET g_ccc.ccc28d=g_ccc.ccc28d+l_ccg.ccg32d
   LET g_ccc.ccc28e=g_ccc.ccc28e+l_ccg.ccg32e
   LET g_ccc.ccc28f=g_ccc.ccc28f+l_ccg.ccg32f   #FUN-7C0028 add
   LET g_ccc.ccc28g=g_ccc.ccc28g+l_ccg.ccg32g   #FUN-7C0028 add
   LET g_ccc.ccc28h=g_ccc.ccc28h+l_ccg.ccg32h   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_tlf15_upd()       #更新會計科目
   DEFINE l_invno,actno_d,actno_c       LIKE ima_file.ima39       #No.FUN-680122 VARCHAR(24)
   DEFINE l_ware,l_loc                  LIKE imd_file.imd01       #No.FUN-680122 VARCHAR(10)
 
   IF g_smy53='N' OR g_smy53 IS NULL THEN RETURN END IF
 
   IF q_tlf.tlf02 = 50
      THEN LET l_ware=q_tlf.tlf021 LET l_loc=q_tlf.tlf022
      ELSE LET l_ware=q_tlf.tlf031 LET l_loc=q_tlf.tlf032
   END IF
   CASE WHEN g_ccz.ccz07='1' SELECT ima39 INTO l_invno FROM ima_file
                              WHERE ima01=q_tlf.tlf01
        WHEN g_ccz.ccz07='2' SELECT imz39 INTO l_invno FROM ima_file,imz_file
                              WHERE ima01=q_tlf.tlf01 AND ima06=imz01
        WHEN g_ccz.ccz07='3' SELECT imd08 INTO l_invno FROM imd_file
                              WHERE imd01=l_ware
        WHEN g_ccz.ccz07='4' SELECT ime09 INTO l_invno FROM ime_file
                              WHERE ime01=l_ware AND ime02=l_loc
                              AND imeacti = 'Y'    #FUN-D40103
   END CASE
   IF q_tlf.tlf03 = 50   #NO:3508
      THEN LET actno_d=l_invno LET actno_c=g_smy54
      ELSE LET actno_d=g_smy54 LET actno_c=l_invno
   END IF
   UPDATE tlf_file SET tlf15=actno_d,
                       tlf16=actno_c
          WHERE rowid=q_tlf_rowid
   IF STATUS THEN 
      CALL s_errmsg('','','upd tlf15:',STATUS,1)                                     #No.FUN-710027
   END IF
END FUNCTION
 
FUNCTION p510_ccc_tot(p_sw)     # 計算所有出庫成本及結存
  DEFINE p_sw   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
  # 1:第一階段,先不處理重工 2:第二階段,處理重工
  IF p_sw='2' THEN CALL p510_ccc_ccc26() END IF
  CALL p510_ccc_ccc23()
  IF (p_sw='1' AND g_ccd03='N') OR (p_sw='2') THEN
        LET g_ccc.ccc32 = 0 # 工單領料
        LET g_ccc.ccc42 = 0 # 雜項領料
        LET g_ccc.ccc52 = 0 # 其他調整
        LET g_ccc.ccc62 = 0 # 銷貨成本
        LET g_ccc.ccc72 = 0 # 盤點盈虧
        LET g_ccc.ccc62a= 0 # 銷貨成本-材料
        LET g_ccc.ccc62b= 0 # 銷貨成本-人工
        LET g_ccc.ccc62c= 0 # 銷貨成本-製費一
        LET g_ccc.ccc62d= 0 # 銷貨成本-加工
        LET g_ccc.ccc62e= 0 # 銷貨成本-製費二
        LET g_ccc.ccc62f= 0 # 銷貨成本-製費三   #FUN-7C0028 add
        LET g_ccc.ccc62g= 0 # 銷貨成本-製費四   #FUN-7C0028 add
        LET g_ccc.ccc62h= 0 # 銷貨成本-製費五   #FUN-7C0028 add
        LET g_ccc.ccc66 = 0 # 銷退成本
        LET g_ccc.ccc66a= 0 # 銷退成本-材料
        LET g_ccc.ccc66b= 0 # 銷退成本-人工
        LET g_ccc.ccc66c= 0 # 銷退成本-製費一
        LET g_ccc.ccc66d= 0 # 銷退成本-加工
        LET g_ccc.ccc66e= 0 # 銷退成本-製費二
        LET g_ccc.ccc66f= 0 # 銷退成本-製費三   #FUN-7C0028 add
        LET g_ccc.ccc66g= 0 # 銷退成本-製費四   #FUN-7C0028 add
        LET g_ccc.ccc66h= 0 # 銷退成本-製費五   #FUN-7C0028 add
        CALL p510_tlf21_upd()
  END IF
 
  LET g_ccc.ccc91 = g_ccc.ccc11 + g_ccc.ccc21 + g_ccc.ccc25 + g_ccc.ccc27 +
      g_ccc.ccc31 + g_ccc.ccc41 + g_ccc.ccc51 + g_ccc.ccc61 + g_ccc.ccc71
  LET g_ccc.ccc92 = g_ccc.ccc12 + g_ccc.ccc22 + g_ccc.ccc26 + g_ccc.ccc28 +
      g_ccc.ccc32 + g_ccc.ccc42 + g_ccc.ccc52 + g_ccc.ccc62 + g_ccc.ccc72
  LET g_ccc.ccc92a= g_ccc.ccc91 * g_ccc.ccc23a
  LET g_ccc.ccc92b= g_ccc.ccc91 * g_ccc.ccc23b
  LET g_ccc.ccc92c= g_ccc.ccc91 * g_ccc.ccc23c
  LET g_ccc.ccc92d= g_ccc.ccc91 * g_ccc.ccc23d
  LET g_ccc.ccc92e= g_ccc.ccc91 * g_ccc.ccc23e
  LET g_ccc.ccc92f= g_ccc.ccc91 * g_ccc.ccc23f   #FUN-7C0028 add
  LET g_ccc.ccc92g= g_ccc.ccc91 * g_ccc.ccc23g   #FUN-7C0028 add
  LET g_ccc.ccc92h= g_ccc.ccc91 * g_ccc.ccc23h   #FUN-7C0028 add
  # 以下這段是為了使金額平衡
  LET g_ccc.ccc92a= g_ccc.ccc92 - g_ccc.ccc92b - g_ccc.ccc92c
                                - g_ccc.ccc92d - g_ccc.ccc92e
                                - g_ccc.ccc92f - g_ccc.ccc92g - g_ccc.ccc92h   #FUN-7C0028 add
  #- 將金額更新回 tlf21, 以便以後製表方便
  # 差異成本存入
  LET g_ccc.ccc93 = g_ccc.ccc91 * g_ccc.ccc23a
  LET g_ccc.ccc93 = g_ccc.ccc93 - g_ccc.ccc92a
  LET g_ccc.ccc92a= g_ccc.ccc91 * g_ccc.ccc23a
  LET g_ccc.ccc92b= g_ccc.ccc91 * g_ccc.ccc23b
  LET g_ccc.ccc92c= g_ccc.ccc91 * g_ccc.ccc23c
  LET g_ccc.ccc92d= g_ccc.ccc91 * g_ccc.ccc23d
  LET g_ccc.ccc92e= g_ccc.ccc91 * g_ccc.ccc23e
  LET g_ccc.ccc92f= g_ccc.ccc91 * g_ccc.ccc23f   #FUN-7C0028 add
  LET g_ccc.ccc92g= g_ccc.ccc91 * g_ccc.ccc23g   #FUN-7C0028 add
  LET g_ccc.ccc92h= g_ccc.ccc91 * g_ccc.ccc23h   #FUN-7C0028 add
  LET g_ccc.ccc92 = g_ccc.ccc92a + g_ccc.ccc92b + g_ccc.ccc92c +
                    g_ccc.ccc92d + g_ccc.ccc92e
                   +g_ccc.ccc92f + g_ccc.ccc92g + g_ccc.ccc92h   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_ccc_ccc26()
DEFINE l_ccc25  LIKE ccc_file.ccc25
DEFINE l_ccc26  LIKE ccc_file.ccc26
DEFINE l_ccc26a LIKE ccc_file.ccc26a
DEFINE l_ccc26b LIKE ccc_file.ccc26b
DEFINE l_ccc26c LIKE ccc_file.ccc26c
DEFINE l_ccc26d LIKE ccc_file.ccc26d
DEFINE l_ccc26e LIKE ccc_file.ccc26e
DEFINE l_ccc26f LIKE ccc_file.ccc26f   #FUN-7C0028 add
DEFINE l_ccc26g LIKE ccc_file.ccc26g   #FUN-7C0028 add
DEFINE l_ccc26h LIKE ccc_file.ccc26h   #FUN-7C0028 add
 
  SELECT SUM(cch22a*-1),SUM(cch22b*-1),SUM(cch22c*-1),
         SUM(cch22d*-1),SUM(cch22e*-1),
         SUM(cch22f*-1),SUM(cch22g*-1),SUM(cch2h*-1),   #FUN-7C0028 add
         SUM(cch22 *-1),SUM(cch21*-1)
    INTO g_ccc.ccc26a, g_ccc.ccc26b, g_ccc.ccc26c,
         g_ccc.ccc26d, g_ccc.ccc26e,
         g_ccc.ccc26f, g_ccc.ccc26g, g_ccc.ccc26h,      #FUN-7C0028 add
         g_ccc.ccc26,l_ccc25
    FROM cch_file
   WHERE cch04=g_ccc.ccc01 AND cch02=yy AND cch03=mm AND cch05='R'
     AND cch06=g_ccc.ccc07 AND cch07=g_ccc.ccc08   #FUN-7C0028 add
  IF cl_null(g_ccc.ccc26a) THEN
     LET g_ccc.ccc26 = 0 LET g_ccc.ccc26a= 0 LET g_ccc.ccc26b= 0 
     LET g_ccc.ccc26c= 0 LET g_ccc.ccc26d= 0 LET g_ccc.ccc26e= 0
     LET g_ccc.ccc26f= 0 LET g_ccc.ccc26g= 0 LET g_ccc.ccc26h= 0  #FUN-7C0028 add
  END IF
  # 拆件式
  # 拆件式的領出
  LET l_ccc26  = 0 LET l_ccc26a = 0 LET l_ccc26b = 0
  LET l_ccc26c = 0 LET l_ccc26d = 0 LET l_ccc26e = 0
  LET l_ccc26f = 0 LET l_ccc26g = 0 LET l_ccc26h = 0    #FUN-7C0028 add
  SELECT SUM(ccu22 *-1),SUM(ccu22a*-1),SUM(ccu22b*-1),
         SUM(ccu22c*-1),SUM(ccu22d*-1),SUM(ccu22e*-1)
        ,SUM(ccu22f*-1),SUM(ccu22g*-1),SUM(ccu22h*-1)   #FUN-7C0028 add
    INTO l_ccc26,  l_ccc26a, l_ccc26b,
         l_ccc26c, l_ccc26d, l_ccc26e
        ,l_ccc26f, l_ccc26g, l_ccc26h    #FUN-7C0028 add
    FROM ccu_file
   WHERE ccu04=g_ccc.ccc01 AND ccu02=yy AND ccu03=mm AND ccu05='R'
     AND ccu06=g_ccc.ccc07 AND ccu07=g_ccc.ccc08   #FUN-7C0028 add
  IF l_ccc26a IS NULL THEN
     LET l_ccc26 = 0 LET l_ccc26a= 0 LET l_ccc26b= 0 
     LET l_ccc26c= 0 LET l_ccc26d= 0 LET l_ccc26e= 0
     LET l_ccc26f= 0 LET l_ccc26g= 0 LET l_ccc26h= 0  #FUN-7C0028 add
  END IF
 
  LET g_ccc.ccc26 = g_ccc.ccc26 + l_ccc26
  LET g_ccc.ccc26a = g_ccc.ccc26a + l_ccc26a
  LET g_ccc.ccc26b = g_ccc.ccc26b + l_ccc26b
  LET g_ccc.ccc26c = g_ccc.ccc26c + l_ccc26c
  LET g_ccc.ccc26d = g_ccc.ccc26d + l_ccc26d
  LET g_ccc.ccc26e = g_ccc.ccc26e + l_ccc26e
  LET g_ccc.ccc26f = g_ccc.ccc26f + l_ccc26f   #FUN-7C0028 add
  LET g_ccc.ccc26g = g_ccc.ccc26g + l_ccc26g   #FUN-7C0028 add
  LET g_ccc.ccc26h = g_ccc.ccc26h + l_ccc26h   #FUN-7C0028 add
END FUNCTION
 
#---->重工領部份
FUNCTION p510_ccc_ccc23()
# DEFINE qty    LIKE ima_file.ima26         #No.FUN-680122 DEC(15,3)
  DEFINE qty    LIKE type_file.num15_3      ###GP5.2  #NO.FUN-A20044
  DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE ccc_file.ccc23
  DEFINE l_c23f,l_c23g,l_c23h                     LIKE ccc_file.ccc23   #FUN-7C0028 add
 
  LET l_c23 = g_ccc.ccc23
  LET l_c23a = g_ccc.ccc23a
  LET l_c23b = g_ccc.ccc23b
  LET l_c23c = g_ccc.ccc23c
  LET l_c23d = g_ccc.ccc23d
  LET l_c23e = g_ccc.ccc23e
  LET l_c23f = g_ccc.ccc23f   #FUN-7C0028 add
  LET l_c23g = g_ccc.ccc23g   #FUN-7C0028 add
  LET l_c23h = g_ccc.ccc23h   #FUN-7C0028 add
  LET qty=g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc25+g_ccc.ccc27
  IF qty=0 THEN                 # get unit cost from last month
     #若因重工領或入而將數量清為零
     IF (g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27) != 0 THEN
        LET g_ccc.ccc23a=(g_ccc.ccc12a+g_ccc.ccc22a+g_ccc.ccc28a)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23b=(g_ccc.ccc12b+g_ccc.ccc22b+g_ccc.ccc28b)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23c=(g_ccc.ccc12c+g_ccc.ccc22c+g_ccc.ccc28c)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23d=(g_ccc.ccc12d+g_ccc.ccc22d+g_ccc.ccc28d)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23e=(g_ccc.ccc12e+g_ccc.ccc22e+g_ccc.ccc28e)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23f=(g_ccc.ccc12f+g_ccc.ccc22f+g_ccc.ccc28f)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23g=(g_ccc.ccc12g+g_ccc.ccc22g+g_ccc.ccc28g)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23h=(g_ccc.ccc12h+g_ccc.ccc22h+g_ccc.ccc28h)
                        /(g_ccc.ccc11+g_ccc.ccc21+g_ccc.ccc27)
        LET g_ccc.ccc23=g_ccc.ccc23a+ g_ccc.ccc23b+ g_ccc.ccc23c
                       +g_ccc.ccc23d+ g_ccc.ccc23e
                       +g_ccc.ccc23f+g_ccc.ccc23g+g_ccc.ccc23h   #FUN-7C0028 add
     END IF  #無論如何, 若沒單價則取xx帳或上期
     IF g_ccc.ccc23 = 0 THEN
        #-->先取期初開帳再取上月
        SELECT cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,cca23g,cca23h,cca23  #FUN-7C0028 add cca23f,g,h
          INTO g_ccc.ccc23a,g_ccc.ccc23b,g_ccc.ccc23c,
               g_ccc.ccc23d,g_ccc.ccc23e,
               g_ccc.ccc23f,g_ccc.ccc23g,g_ccc.ccc23h,   #FUN-7C0028 add
               g_ccc.ccc23
          FROM cca_file
         WHERE cca01=g_ccc.ccc01 AND cca02=last_yy AND cca03=last_mm
           AND cca06=g_ccc.ccc07 AND cca07=g_ccc.ccc08   #FUN-7C0028 add
        IF STATUS OR g_ccc.ccc23 IS NULL THEN
           SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
             INTO g_ccc.ccc23a,g_ccc.ccc23b,g_ccc.ccc23c,
                  g_ccc.ccc23d,g_ccc.ccc23e,
                  g_ccc.ccc23f,g_ccc.ccc23g,g_ccc.ccc23h,   #FUN-7C0028 add
                  g_ccc.ccc23
             FROM ccc_file
            WHERE ccc01=g_ccc.ccc01 AND ccc02=last_yy AND ccc03=last_mm
              AND ccc07=g_ccc.ccc07 AND ccc08=g_ccc.ccc08   #FUN-7C0028 add
           IF STATUS OR g_ccc.ccc23 IS NULL THEN
              LET g_ccc.ccc23a=0 LET g_ccc.ccc23b=0 LET g_ccc.ccc23c=0
              LET g_ccc.ccc23d=0 LET g_ccc.ccc23e=0 LET g_ccc.ccc23=0
              LET g_ccc.ccc23f=0 LET g_ccc.ccc23g=0 LET g_ccc.ccc23h=0   #FUN-7C0028 add
           END IF
        END IF
     END IF
     IF g_ccc.ccc23 = 0 THEN
        LET g_ccc.ccc23a = l_c23a
        LET g_ccc.ccc23b = l_c23b
        LET g_ccc.ccc23c = l_c23c
        LET g_ccc.ccc23d = l_c23d
        LET g_ccc.ccc23e = l_c23e
        LET g_ccc.ccc23f = l_c23f   #FUN-7C0028 add
        LET g_ccc.ccc23g = l_c23g   #FUN-7C0028 add
        LET g_ccc.ccc23h = l_c23h   #FUN-7C0028 add
        LET g_ccc.ccc23  = l_c23
     END IF
  ELSE                          # 平均單位成本計算
     IF qty != 0 THEN
        LET g_ccc.ccc23a=(g_ccc.ccc12a+g_ccc.ccc22a+g_ccc.ccc26a+g_ccc.ccc28a)/qty
        LET g_ccc.ccc23b=(g_ccc.ccc12b+g_ccc.ccc22b+g_ccc.ccc26b+g_ccc.ccc28b)/qty
        LET g_ccc.ccc23c=(g_ccc.ccc12c+g_ccc.ccc22c+g_ccc.ccc26c+g_ccc.ccc28c)/qty
        LET g_ccc.ccc23d=(g_ccc.ccc12d+g_ccc.ccc22d+g_ccc.ccc26d+g_ccc.ccc28d)/qty
        LET g_ccc.ccc23e=(g_ccc.ccc12e+g_ccc.ccc22e+g_ccc.ccc26e+g_ccc.ccc28e)/qty
        LET g_ccc.ccc23f=(g_ccc.ccc12f+g_ccc.ccc22f+g_ccc.ccc26f+g_ccc.ccc28f)/qty   #FUN-7C0028 add
        LET g_ccc.ccc23g=(g_ccc.ccc12g+g_ccc.ccc22g+g_ccc.ccc26g+g_ccc.ccc28g)/qty   #FUN-7C0028 add
        LET g_ccc.ccc23h=(g_ccc.ccc12h+g_ccc.ccc22h+g_ccc.ccc26h+g_ccc.ccc28h)/qty   #FUN-7C0028 add
        LET g_ccc.ccc23=g_ccc.ccc23a+g_ccc.ccc23b+g_ccc.ccc23c+
                        g_ccc.ccc23d+g_ccc.ccc23e
                       +g_ccc.ccc23f+g_ccc.ccc23g+g_ccc.ccc23h   #FUN-7C0028 add
     END IF
  END IF
END FUNCTION
 
FUNCTION p510_tlf21_upd()                       #zzz
   DEFINE l_ima57               LIKE type_file.num5        #No.FUN-680122 SMALLINT
   DEFINE l_sfb38               LIKE type_file.dat         #No.FUN-680122 DATE
   DEFINE l_sfb01               LIKE sfb_file.sfb01
   DEFINE l_tlf10               LIKE tlf_file.tlf10         #No.FUN-680122 DEC(15,3)
   DEFINE l_c21,l_c22,l_c23     LIKE ccc_file.ccc11         #No.FUN-680122 DEC(15,5)
   DEFINE l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE type_file.num20_6    #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h               LIKE type_file.num20_6    #FUN-7C0028 add
   DEFINE l_c22a,l_c22b,l_c22c,l_c22d,l_c22e LIKE type_file.num20_6    #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h               LIKE type_file.num20_6    #FUN-7C0028 add
   DEFINE l_oha09               LIKE oha_file.oha09
   DEFINE l_tlf62               LIKE tlf_file.tlf62
   DEFINE l_tlf907              LIKE tlf_file.tlf907
 
   DECLARE tlf21_c CURSOR WITH HOLD FOR
      SELECT tlf_file.rowid,
             tlf01,tlf06,tlf07,tlf10*tlf60,
             tlf020,tlf02,tlf021,tlf022,tlf023,tlf026,tlf027,
             tlf030,tlf03,tlf031,tlf032,tlf033,tlf036,tlf037,
             tlf13,tlf62, sfb38,sfb99,ima57,sfb01,tlf907
        FROM tlf_file LEFT OUTER JOIN sfb_file ON tlf62=sfb_file.sfb01 LEFT OUTER JOIN ima_file ON sfb05=ima01
       WHERE tlf01 = g_ima01
         AND ((tlf02 BETWEEN 50 AND 59) OR (tlf03 BETWEEN 50 AND 59))
         AND tlf06 BETWEEN g_bdate AND g_edate
         AND tlf902 NOT IN(SELECT jce02 FROM jce_file)
         AND tlf907 != 0
         AND tlfcost = g_tlfcost   #FUN-7C0028 add
   FOREACH tlf21_c INTO q_tlf_rowid, q_tlf.*, l_sfb38, g_sfb99, l_ima57,l_sfb01,
                        l_tlf907
      IF STATUS THEN
         CALL s_errmsg('','','fore tlf!',STATUS,0)  #No.FUN-710027
         LET g_success = 'N' EXIT FOREACH         
      END IF
      IF cl_null(q_tlf.tlf02) AND cl_null(q_tlf.tlf03) THEN
         CONTINUE FOREACH
      END IF
      #--------------------------------------------------------->出庫
      IF (q_tlf.tlf02 = 50 OR q_tlf.tlf02 = 57)  THEN
         CALL s_get_doc_no(q_tlf.tlf026) RETURNING xxx
         LET xxx1=q_tlf.tlf026 LET xxx2=q_tlf.tlf027
         LET u_sign=-1
      END IF
      #--------------------------------------------------------->入庫
      IF (q_tlf.tlf03 = 50 OR q_tlf.tlf03 = 57)  THEN
         CALL s_get_doc_no(q_tlf.tlf036) RETURNING xxx
         LET xxx1=q_tlf.tlf036 LET xxx2=q_tlf.tlf037
         LET u_sign=1
      END IF
      #--------------------------------------------------------->二階段調撥(出)
       IF (q_tlf.tlf02 = 50 AND q_tlf.tlf03 = 57)  THEN
          CALL s_get_doc_no(q_tlf.tlf026) RETURNING xxx
          LET xxx1=q_tlf.tlf026 LET xxx2=q_tlf.tlf027
          LET u_sign=-1
       END IF
      #--------------------------------------------------------->二階段調撥(出)
       IF (q_tlf.tlf03 = 50 AND q_tlf.tlf02 = 57)  THEN
          CALL s_get_doc_no(q_tlf.tlf036) RETURNING xxx
          LET xxx1=q_tlf.tlf036 LET xxx2=q_tlf.tlf037
          LET u_sign=1
       END IF
      #--------------------------------------------------------->取成會分類
      IF xxx IS NULL THEN CONTINUE FOREACH END IF
      LET u_flag='' LET g_smydmy1=''
      SELECT smydmy2,smydmy1 INTO u_flag,g_smydmy1
        FROM smy_file WHERE smyslip=xxx
      IF g_smydmy1='N' THEN CONTINUE FOREACH END IF
      IF q_tlf.tlf13='aimp880' THEN LET u_flag='6' END IF
      IF u_flag NOT MATCHES "[123456]" OR u_flag IS NULL THEN
         CONTINUE FOREACH
      END IF
 
      IF q_tlf.tlf13[1,5]='asfi5' AND g_sfb99='Y' AND l_ima57<g_ima57_t THEN
         LET g_sfb99='N'
      END IF
      #當 sfb99 is null, 就表示非W/O類, 不必特別判斷
      LET amt = 0 LET amta = 0 LET amtb = 0 LET amtc = 0 LET amtd = 0 LET amte=0
      LET amtf= 0 LET amtg = 0 LET amth = 0    #FUN-7C0028 add
 
#雜收異動成本不須由此function 決定
       CASE WHEN q_tlf.tlf13='aimt301' OR q_tlf.tlf13='aimt311' #雜出
# 報廢異動(aimt303,aimt313)應列入雜發異動中
                 OR q_tlf.tlf13 = 'aimt303' OR q_tlf.tlf13 = 'aimt313'
# 雜發依參數ccz08決定取價方式
              IF g_ccz.ccz08 = '1' THEN       #1.系統認定 2.人工認定(axct500)
                 LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                 LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                 LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                 LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                 LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                 LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                 LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                 LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
                 LET g_ccc.ccc42 = g_ccc.ccc42 + (amt*l_tlf907)
              ELSE
                #SELECT inb14 INTO amta FROM inb_file  #FUN-AB0089
                 SELECT  inb13 *inb09,inb132*inb09,inb133*inb09,inb134*inb09,
                         inb135*inb09,inb136*inb09,inb137*inb09,inb138*inb09
                 INTO amta,amtb,amtc,amtd,amte,amtf,amtg,amth 
                   FROM inb_file
                  WHERE inb01 = xxx1
                    AND inb03 = xxx2
                 IF cl_null(amta) THEN LET amta = 0 END IF
       #FUN-AB0089--add--begin
                 LET amta = cl_digcut(amta,g_ccz.ccz26)
                 LET amtb = cl_digcut(amtb,g_ccz.ccz26)
                 LET amtc = cl_digcut(amtc,g_ccz.ccz26)
                 LET amtd = cl_digcut(amtd,g_ccz.ccz26)
                 LET amte = cl_digcut(amte,g_ccz.ccz26)
                 LET amtf = cl_digcut(amtf,g_ccz.ccz26)
                 LET amtg = cl_digcut(amtg,g_ccz.ccz26)
                 LET amth = cl_digcut(amth,g_ccz.ccz26)
       #FUN-AB0089--add--end
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
                 LET g_ccc.ccc42 = g_ccc.ccc42 + (amt*l_tlf907)
                 CONTINUE FOREACH
              END IF
            WHEN q_tlf.tlf13[1,5]='asft6' AND g_sfb99='N' # 製造入庫
            # 要存明細的入庫金額
            IF NOT cl_null(q_tlf.tlf62) THEN
               LET l_c23 = 0  LET l_c22 = 0 LET l_c21 = 0
               LET l_c22a=0 LET l_c22b=0 LET l_c22c=0 LET l_c22d=0 LET l_c22e=0
               LET l_c22f=0 LET l_c22g=0 LET l_c22h=0    #FUN-7C0028 add
               SELECT ccg31,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e
                                 ,ccg32f,ccg32g,ccg32h   #FUN-7C0028 add
                 INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                 ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                 FROM ccg_file
                WHERE ccg01=q_tlf.tlf62 AND ccg04=q_tlf.tlf01
                  AND ccg02=yy   AND ccg03=mm
                  AND ccg06=type AND ccg07=g_tlfcost   #FUN-7C0028 add
               IF l_c21 IS NULL THEN LET l_c21 = 0 END IF
               IF l_c22 IS NULL THEN LET l_c22 = 0 END IF
               IF l_c22a IS NULL THEN LET l_c22a = 0 END IF
               IF l_c22b IS NULL THEN LET l_c22b = 0 END IF
               IF l_c22c IS NULL THEN LET l_c22c = 0 END IF
               IF l_c22d IS NULL THEN LET l_c22d = 0 END IF
               IF l_c22e IS NULL THEN LET l_c22e = 0 END IF
               IF l_c22f IS NULL THEN LET l_c22f = 0 END IF   #FUN-7C0028 add
               IF l_c22g IS NULL THEN LET l_c22g = 0 END IF   #FUN-7C0028 add
               IF l_c22h IS NULL THEN LET l_c22h = 0 END IF   #FUN-7C0028 add
               IF l_c21 != 0 THEN
                  LET l_c23 = l_c22 / l_c21
                  LET l_c23a= l_c22a/ l_c21
                  LET l_c23b= l_c22b/ l_c21
                  LET l_c23c= l_c22c/ l_c21
                  LET l_c23d= l_c22d/ l_c21
                  LET l_c23e= l_c22e/ l_c21
                  LET l_c23f= l_c22f/ l_c21   #FUN-7C0028 add
                  LET l_c23g= l_c22g/ l_c21   #FUN-7C0028 add
                  LET l_c23h= l_c22h/ l_c21   #FUN-7C0028 add
               ELSE
                  LET l_c23 = 0
                  LET l_c23a= 0
                  LET l_c23b= 0
                  LET l_c23c= 0
                  LET l_c23d= 0
                  LET l_c23e= 0
                  LET l_c23f= 0   #FUN-7C0028 add
                  LET l_c23g= 0   #FUN-7C0028 add
                  LET l_c23h= 0   #FUN-7C0028 add
               END IF
               LET amta=amta + (q_tlf.tlf10*l_c23a)
               LET amtb=amtb + (q_tlf.tlf10*l_c23b)
               LET amtc=amtc + (q_tlf.tlf10*l_c23c)
               LET amtd=amtd + (q_tlf.tlf10*l_c23d)
               LET amte=amte + (q_tlf.tlf10*l_c23e)
               LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
               LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
               LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
               LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
            END IF
         WHEN q_tlf.tlf13[1,5]='asfi5' AND g_sfb99='Y'       # 重工入庫
              AND l_ima57>g_ima57_t                          # 子階領父階
              IF NOT cl_null(q_tlf.tlf62) THEN
                 LET l_c23 = 0  LET l_c22 = 0 LET l_c21 = 0
                 LET l_c22a=0 LET l_c22b=0 LET l_c22c=0 LET l_c22d=0 LET l_c22e=0
                 LET l_c22f=0 LET l_c22g=0 LET l_c22h=0    #FUN-7C0028 add
                 SELECT cch21,cch22,cch22a,cch22b,cch22c,cch22d,cch22e
                                   ,cch22f,cch22g,cch22h   #FUN-7C0028 add
                      INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                      FROM cch_file
                     WHERE cch01=q_tlf.tlf62 AND cch04=q_tlf.tlf01
                       AND cch02=yy   AND cch03=mm
                       AND cch06=type AND cch07=g_tlfcost   #FUN-7C0028 add
                    IF l_c21 IS NULL THEN LET l_c21 = 0 END IF
                    IF l_c22 IS NULL THEN LET l_c22 = 0 END IF
                    IF l_c22a IS NULL THEN LET l_c22a = 0 END IF
                    IF l_c22b IS NULL THEN LET l_c22b = 0 END IF
                    IF l_c22c IS NULL THEN LET l_c22c = 0 END IF
                    IF l_c22d IS NULL THEN LET l_c22d = 0 END IF
                    IF l_c22e IS NULL THEN LET l_c22e = 0 END IF
                    IF l_c22f IS NULL THEN LET l_c22f = 0 END IF   #FUN-7C0028 add
                    IF l_c22g IS NULL THEN LET l_c22g = 0 END IF   #FUN-7C0028 add
                    IF l_c22h IS NULL THEN LET l_c22h = 0 END IF   #FUN-7C0028 add
                    IF l_c21 != 0 THEN
                       LET l_c23 = l_c22 / l_c21
                       LET l_c23a= l_c22a/ l_c21
                       LET l_c23b= l_c22b/ l_c21
                       LET l_c23c= l_c22c/ l_c21
                       LET l_c23d= l_c22d/ l_c21
                       LET l_c23e= l_c22e/ l_c21
                       LET l_c23f= l_c22f/ l_c21   #FUN-7C0028 add
                       LET l_c23g= l_c22g/ l_c21   #FUN-7C0028 add
                       LET l_c23h= l_c22h/ l_c21   #FUN-7C0028 add
                    ELSE
                       LET l_c23 = 0
                       LET l_c23a= 0
                       LET l_c23b= 0
                       LET l_c23c= 0
                       LET l_c23d= 0
                       LET l_c23e= 0
                       LET l_c23f= 0   #FUN-7C0028 add
                       LET l_c23g= 0   #FUN-7C0028 add
                       LET l_c23h= 0   #FUN-7C0028 add
                    END IF
                    LET amta=amta + (q_tlf.tlf10*l_c23a)
                    LET amtb=amtb + (q_tlf.tlf10*l_c23b)
                    LET amtc=amtc + (q_tlf.tlf10*l_c23c)
                    LET amtd=amtd + (q_tlf.tlf10*l_c23d)
                    LET amte=amte + (q_tlf.tlf10*l_c23e)
                    LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
                    LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
                    LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
                    LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
                 END IF
         WHEN q_tlf.tlf13[1,5]='asft6' AND g_sfb99='Y'       # 重工入庫
              AND NOT (q_tlf.tlf02 = 65 OR q_tlf.tlf03 = 65) # 非拆件工單
                 IF NOT cl_null(q_tlf.tlf62) THEN
                    LET l_c23 = 0  LET l_c22 = 0 LET l_c21 = 0
                    LET l_c22a=0 LET l_c22b=0 LET l_c22c=0 LET l_c22d=0 LET l_c22e=0
                    LET l_c22f=0 LET l_c22g=0 LET l_c22h=0    #FUN-7C0028 add
                    SELECT ccg31,ccg32,ccg32a,ccg32b,ccg32c,ccg32d,ccg32e
                                      ,ccg32f,ccg32g,ccg32h   #FUN-7C0028 add
                      INTO l_c21,l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                                      ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
                      FROM ccg_file
                     WHERE ccg01=q_tlf.tlf62 AND ccg04=q_tlf.tlf01
                       AND ccg02=yy   AND ccg03=mm
                       AND ccg06=type AND ccg07=g_tlfcost   #FUN-7C0028 add
                    IF l_c21 IS NULL THEN LET l_c21 = 0 END IF
                    IF l_c22 IS NULL THEN LET l_c22 = 0 END IF
                    IF l_c22a IS NULL THEN LET l_c22a = 0 END IF
                    IF l_c22b IS NULL THEN LET l_c22b = 0 END IF
                    IF l_c22c IS NULL THEN LET l_c22c = 0 END IF
                    IF l_c22d IS NULL THEN LET l_c22d = 0 END IF
                    IF l_c22e IS NULL THEN LET l_c22e = 0 END IF
                    IF l_c22f IS NULL THEN LET l_c22f = 0 END IF   #FUN-7C0028 add
                    IF l_c22g IS NULL THEN LET l_c22g = 0 END IF   #FUN-7C0028 add
                    IF l_c22h IS NULL THEN LET l_c22h = 0 END IF   #FUN-7C0028 add
                    IF l_c21 != 0 THEN
                       LET l_c23 = l_c22 / l_c21
                       LET l_c23a= l_c22a/ l_c21
                       LET l_c23b= l_c22b/ l_c21
                       LET l_c23c= l_c22c/ l_c21
                       LET l_c23d= l_c22d/ l_c21
                       LET l_c23e= l_c22e/ l_c21
                       LET l_c23f= l_c22f/ l_c21   #FUN-7C0028 add
                       LET l_c23g= l_c22g/ l_c21   #FUN-7C0028 add
                       LET l_c23h= l_c22h/ l_c21   #FUN-7C0028 add
                    ELSE
                       LET l_c23 = 0
                       LET l_c23a= 0
                       LET l_c23b= 0
                       LET l_c23c= 0
                       LET l_c23d= 0
                       LET l_c23e= 0
                       LET l_c23f= 0   #FUN-7C0028 add
                       LET l_c23g= 0   #FUN-7C0028 add
                       LET l_c23h= 0   #FUN-7C0028 add
                    END IF
                    LET amta=amta + (q_tlf.tlf10*l_c23a)
                    LET amtb=amtb + (q_tlf.tlf10*l_c23b)
                    LET amtc=amtc + (q_tlf.tlf10*l_c23c)
                    LET amtd=amtd + (q_tlf.tlf10*l_c23d)
                    LET amte=amte + (q_tlf.tlf10*l_c23e)
                    LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
                    LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
                    LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
                    LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
                 END IF
            WHEN q_tlf.tlf13[1,5]='asfi5' AND g_sfb99='Y' # 重工領出
              SELECT ccc12a+ccc22a, ccc12b+ccc22b, ccc12c+ccc22c,
                     ccc12d+ccc22d, ccc12e+ccc22e,
                     ccc12f+ccc22f, ccc12g+ccc22g, ccc12h+ccc22h,   #FUN-7C0028 add
                     ccc12 +ccc22 , ccc11 +ccc21
                INTO l_c22a,l_c22b,l_c22c,l_c22d,l_c22e,
                     l_c22f,l_c22g,l_c22h,   #FUN-7C0028 add
                     l_c22,l_c21
                FROM ccc_file
               WHERE ccc01=q_tlf.tlf01 AND ccc02=yy AND ccc03=mm
                 AND ccc07=type        AND ccc08=g_tlfcost   #FUN-7C0028 add
              IF g_ccc.ccc11 + g_ccc.ccc21 = 0 THEN
                 LET l_c23a=0 LET l_c23b=0 LET l_c23c=0
                 LET l_c23d=0 LET l_c23e=0 LET l_c23 =0
                 LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
              ELSE
                 LET l_c23 =(g_ccc.ccc12 +g_ccc.ccc22 )/(g_ccc.ccc11+g_ccc.ccc21)
                 LET l_c23a=(g_ccc.ccc12a+g_ccc.ccc22a)/(g_ccc.ccc11+g_ccc.ccc21)
                 LET l_c23b=(g_ccc.ccc12b+g_ccc.ccc22b)/(g_ccc.ccc11+g_ccc.ccc21)
                 LET l_c23c=(g_ccc.ccc12c+g_ccc.ccc22c)/(g_ccc.ccc11+g_ccc.ccc21)
                 LET l_c23d=(g_ccc.ccc12d+g_ccc.ccc22d)/(g_ccc.ccc11+g_ccc.ccc21)
                 LET l_c23e=(g_ccc.ccc12e+g_ccc.ccc22e)/(g_ccc.ccc11+g_ccc.ccc21)
                 LET l_c23f=(g_ccc.ccc12f+g_ccc.ccc22f)/(g_ccc.ccc11+g_ccc.ccc21)   #FUN-7C0028 add
                 LET l_c23g=(g_ccc.ccc12g+g_ccc.ccc22g)/(g_ccc.ccc11+g_ccc.ccc21)   #FUN-7C0028 add
                 LET l_c23h=(g_ccc.ccc12h+g_ccc.ccc22h)/(g_ccc.ccc11+g_ccc.ccc21)   #FUN-7C0028 add
              END IF
              IF l_c23a = 0 AND l_c23b = 0 AND l_c23c = 0 AND l_c23d = 0 AND l_c23e = 0
                            AND l_c23f = 0 AND l_c23g = 0 AND l_c23h = 0 THEN   #FUN-7C0028 add
                  SELECT cca23a,cca23b,cca23c,cca23d,cca23e,cca23f,cca23g,cca23h,cca23   #FUN-7C0028 add cca23f,g,h
                    INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                    FROM cca_file
                   WHERE cca01=q_tlf.tlf01 AND cca02=last_yy AND cca03=last_mm
                     AND cca06=type        AND cca07=g_tlfcost   #FUN-7C0028 add
                 #  若上期仍無單價, 則取上期xx帳單價
                  IF SQLCA.sqlcode
              OR (l_c23a = 0 AND l_c23b = 0 AND l_c23c = 0 AND l_c23d = 0 AND l_c23e = 0
                             AND l_c23f = 0 AND l_c23g = 0 AND l_c23h = 0) THEN
                    SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
                      INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                      FROM ccc_file
                     WHERE ccc01=q_tlf.tlf01 AND ccc02=last_yy AND ccc03=last_mm
                       AND ccc07=type        AND ccc08=g_tlfcost   #FUN-7C0028 add
                  END IF
              END IF
                 LET amta=amta + (q_tlf.tlf10*l_c23a)
                 LET amtb=amtb + (q_tlf.tlf10*l_c23b)
                 LET amtc=amtc + (q_tlf.tlf10*l_c23c)
                 LET amtd=amtd + (q_tlf.tlf10*l_c23d)
                 LET amte=amte + (q_tlf.tlf10*l_c23e)
                 LET amtf=amtf + (q_tlf.tlf10*l_c23f)   #FUN-7C0028 add
                 LET amtg=amtg + (q_tlf.tlf10*l_c23g)   #FUN-7C0028 add
                 LET amth=amth + (q_tlf.tlf10*l_c23h)   #FUN-7C0028 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
            WHEN q_tlf.tlf13[1,5]='asfi5'             #一般工單出
                 LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                 LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                 LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                 LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                 LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                 LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                 LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                 LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
                 LET g_ccc.ccc32 = g_ccc.ccc32 + (amt*l_tlf907)
            WHEN q_tlf.tlf13[1,5]='asft6' AND       #拆件重工入庫
                 (q_tlf.tlf02 = 65 OR q_tlf.tlf03 = 65)
                 IF l_ima57<=g_ima57_t THEN                     # 子階領父階
                    LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                    LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                    LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                    LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                    LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                    LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                    LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                    LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 ELSE
# 應取其單價,因為ccu32可能是兩筆以上彙總而得
                     SELECT -ccu32a/ccu31,-ccu32b/ccu31,-ccu32c/ccu31,
                            -ccu32d/ccu31,-ccu32e/ccu31
                           ,-ccu32f/ccu31,-ccu32g/ccu31,-ccu32h/ccu31   #FUN-7C0028 add
                       INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e
                                  ,l_c23f,l_c23g,l_c23h   #FUN-7C0028 add
                       FROM ccu_file
                       WHERE ccu01=q_tlf.tlf62
                         AND ccu02=yy AND ccu03=mm
                         AND ccu04=q_tlf.tlf01
                         AND ccu06=type        #FUN-7C0028 add
                         AND ccu07=g_tlfcost   #FUN-7C0028 add
                    LET amta=amta - (l_c23a*q_tlf.tlf10)
                    LET amtb=amtb - (l_c23b*q_tlf.tlf10)
                    LET amtc=amtc - (l_c23c*q_tlf.tlf10)
                    LET amtd=amtd - (l_c23d*q_tlf.tlf10)
                    LET amte=amte - (l_c23e*q_tlf.tlf10)
                    LET amtf=amtf - (l_c23f*q_tlf.tlf10)   #FUN-7C0028 add
                    LET amtg=amtg - (l_c23g*q_tlf.tlf10)   #FUN-7C0028 add
                    LET amth=amth - (l_c23h*q_tlf.tlf10)   #FUN-7C0028 add
                 END IF
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
                 LET g_ccc.ccc32 = g_ccc.ccc32 + (amt*l_tlf907)
            WHEN u_flag='5'
                 LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                 LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                 LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                 LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                 LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                 LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                 LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                 LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
                 LET g_ccc.ccc52 = g_ccc.ccc52 + (amt*l_tlf907)
            WHEN q_tlf.tlf13[1,5]='axmt6' OR q_tlf.tlf13 = 'aomt800' #銷售
                 LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                 LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                 LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                 LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                 LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                 LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                 LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                 LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
 
                 LET g_ccc.ccc62 = g_ccc.ccc62 + (amt*l_tlf907)
                 LET g_ccc.ccc62a = g_ccc.ccc62a + (amta*l_tlf907)
                 LET g_ccc.ccc62b = g_ccc.ccc62b + (amtb*l_tlf907)
                 LET g_ccc.ccc62c = g_ccc.ccc62c + (amtc*l_tlf907)
                 LET g_ccc.ccc62d = g_ccc.ccc62d + (amtd*l_tlf907)
                 LET g_ccc.ccc62e = g_ccc.ccc62e + (amte*l_tlf907)
                 LET g_ccc.ccc62f = g_ccc.ccc62f + (amtf*l_tlf907)   #FUN-7C0028 add
                 LET g_ccc.ccc62g = g_ccc.ccc62g + (amtg*l_tlf907)   #FUN-7C0028 add
                 LET g_ccc.ccc62h = g_ccc.ccc62h + (amth*l_tlf907)   #FUN-7C0028 add
 
                 # 儲存銷退成本
                 IF l_tlf907 = 1 THEN
                    LET g_ccc.ccc66 = g_ccc.ccc66 + (amt*l_tlf907)
                    LET g_ccc.ccc66a = g_ccc.ccc66a + (amta*l_tlf907)
                    LET g_ccc.ccc66b = g_ccc.ccc66b + (amtb*l_tlf907)
                    LET g_ccc.ccc66c = g_ccc.ccc66c + (amtc*l_tlf907)
                    LET g_ccc.ccc66d = g_ccc.ccc66d + (amtd*l_tlf907)
                    LET g_ccc.ccc66e = g_ccc.ccc66e + (amte*l_tlf907)
                    LET g_ccc.ccc66f = g_ccc.ccc66f + (amtf*l_tlf907)   #FUN-7C0028 add
                    LET g_ccc.ccc66g = g_ccc.ccc66g + (amtg*l_tlf907)   #FUN-7C0028 add
                    LET g_ccc.ccc66h = g_ccc.ccc66h + (amth*l_tlf907)   #FUN-7C0028 add
                 END IF
            WHEN u_flag='6'
                 LET amta=amta + (q_tlf.tlf10*g_ccc.ccc23a)
                 LET amtb=amtb + (q_tlf.tlf10*g_ccc.ccc23b)
                 LET amtc=amtc + (q_tlf.tlf10*g_ccc.ccc23c)
                 LET amtd=amtd + (q_tlf.tlf10*g_ccc.ccc23d)
                 LET amte=amte + (q_tlf.tlf10*g_ccc.ccc23e)
                 LET amtf=amtf + (q_tlf.tlf10*g_ccc.ccc23f)   #FUN-7C0028 add
                 LET amtg=amtg + (q_tlf.tlf10*g_ccc.ccc23g)   #FUN-7C0028 add
                 LET amth=amth + (q_tlf.tlf10*g_ccc.ccc23h)   #FUN-7C0028 add
                 LET amt=amta+amtb+amtc+amtd+amte+amtf+amtg+amth   #FUN-7C0028 add amtf,amtg,amth
                 LET g_ccc.ccc72 = g_ccc.ccc72 + (amt*l_tlf907)
            OTHERWISE CONTINUE FOREACH
       END CASE
       LET t_time = TIME
       LET g_time=t_time
       UPDATE tlf_file SET tlf21  =amt,
                           tlf221 =amta,
                           tlf222 =amtb,
                           tlf2231=amtc,
                           tlf2232=amtd,
                           tlf224 =amte,
                           tlf2241=amtf,   #FUN-7C0028 add
                           tlf2242=amtg,   #FUN-7C0028 add
                           tlf2243=amth,   #FUN-7C0028 add
                           tlf211 =TODAY,
                           tlf212 =g_time
              WHERE rowid=q_tlf_rowid
       IF STATUS THEN 
          CALL s_errmsg('','','upd tlf21:',STATUS,1)                                      #No.FUN-710027
       END IF
 
       #新增tlfc_file記錄依 "成本計算類別"  的異動成本
       CALL p510_ins_tlfc(q_tlf_rowid)   #FUN-7C0028 add
   END FOREACH
 
   CLOSE tlf21_c
END FUNCTION
 
FUNCTION p510_ins_tlfc(p_tlf_rowid)
   DEFINE p_tlf_rowid           LIKE type_file.row_id,   #chr18,  FUN-A70120
          l_cnt                 LIKE type_file.num5,
          l_tlf                 RECORD LIKE tlf_file.*,
          l_tlfc                RECORD LIKE tlfc_file.*
 
   SELECT * INTO l_tlf.* FROM tlf_file WHERE rowid=p_tlf_rowid
 
   #先判斷資料是否已存在tlfc_file
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM tlfc_file 
    WHERE tlfc01  =l_tlf.tlf01  AND tlfc02  =l_tlf.tlf02
      AND tlfc03  =l_tlf.tlf03  AND tlfc06  =l_tlf.tlf06
      AND tlfc13  =l_tlf.tlf13
      AND tlfc902 =l_tlf.tlf902 AND tlfc903 =l_tlf.tlf903
      AND tlfc904 =l_tlf.tlf904 AND tlfc905 =l_tlf.tlf905
      AND tlfc906 =l_tlf.tlf906 AND tlfc907 =l_tlf.tlf907
      AND tlfctype=type         AND tlfccost=l_tlf.tlfcost
 
   LET l_tlfc.tlfc01   = l_tlf.tlf01         #異動料件編號
   LET l_tlfc.tlfc02   = l_tlf.tlf02         #來源狀況
   LET l_tlfc.tlfc026  = l_tlf.tlf026        #單據編號
   LET l_tlfc.tlfc027  = l_tlf.tlf027        #單據項次
   LET l_tlfc.tlfc03   = l_tlf.tlf03         #目的狀況
   LET l_tlfc.tlfc036  = l_tlf.tlf036        #單據編號
   LET l_tlfc.tlfc037  = l_tlf.tlf037        #單據項次
   LET l_tlfc.tlfc06   = l_tlf.tlf06         #單據日期
   LET l_tlfc.tlfc07   = l_tlf.tlf07         #產生日期
   LET l_tlfc.tlfc08   = l_tlf.tlf08         #異動資料產生時間
   LET l_tlfc.tlfc09   = l_tlf.tlf09         #異動資料發出者
   LET l_tlfc.tlfc13   = l_tlf.tlf13         #異動命令代號
   LET l_tlfc.tlfc15   = l_tlf.tlf15         #借方會計科目
   LET l_tlfc.tlfc151  = l_tlf.tlf151        #借方會計科目二
   LET l_tlfc.tlfc16   = l_tlf.tlf16         #貸方會計科目
   LET l_tlfc.tlfc161  = l_tlf.tlf161        #貸方會計科目二
   LET l_tlfc.tlfc211  = l_tlf.tlf211        #成會計算日期
   LET l_tlfc.tlfc212  = l_tlf.tlf212        #成會計算時間
   LET l_tlfc.tlfc2131 = 0                   #No Use
   LET l_tlfc.tlfc2132 = 0                   #No Use
   LET l_tlfc.tlfc214  = 0                   #No Use
   LET l_tlfc.tlfc215  = 0                   #No Use
   LET l_tlfc.tlfc2151 = 0                   #No Use
   LET l_tlfc.tlfc216  = 0                   #No Use
   LET l_tlfc.tlfc2171 = 0                   #No Use
   LET l_tlfc.tlfc2172 = 0                   #No Use
   IF l_cnt >0 THEN   #已存在表示要UPDATE tlfc_file
      LET l_tlfc.tlfc21   = l_tlfc.tlfc21   + l_tlf.tlf21         #成會異動成本
      LET l_tlfc.tlfc221  = l_tlfc.tlfc221  + l_tlf.tlf221        #材料成本
      LET l_tlfc.tlfc222  = l_tlfc.tlfc222  + l_tlf.tlf222        #人工成本
      LET l_tlfc.tlfc2231 = l_tlfc.tlfc2231 + l_tlf.tlf2231       #製費一成本
      LET l_tlfc.tlfc2232 = l_tlfc.tlfc2232 + l_tlf.tlf2232       #加工成本
      LET l_tlfc.tlfc224  = l_tlfc.tlfc224  + l_tlf.tlf224        #製費二成本
      LET l_tlfc.tlfc2241 = l_tlfc.tlfc2241 + l_tlf.tlf2241       #製費三成本
      LET l_tlfc.tlfc2242 = l_tlfc.tlfc2242 + l_tlf.tlf2242       #製費四成本
      LET l_tlfc.tlfc2243 = l_tlfc.tlfc2243 + l_tlf.tlf2243       #製費五成本
   ELSE               #不存在表示要INSERT tlfc_file
      LET l_tlfc.tlfc21   = l_tlf.tlf21         #成會異動成本
      LET l_tlfc.tlfc221  = l_tlf.tlf221        #材料成本
      LET l_tlfc.tlfc222  = l_tlf.tlf222        #人工成本
      LET l_tlfc.tlfc2231 = l_tlf.tlf2231       #製費一成本
      LET l_tlfc.tlfc2232 = l_tlf.tlf2232       #加工成本
      LET l_tlfc.tlfc224  = l_tlf.tlf224        #製費二成本
      LET l_tlfc.tlfc2241 = l_tlf.tlf2241       #製費三成本
      LET l_tlfc.tlfc2242 = l_tlf.tlf2242       #製費四成本
      LET l_tlfc.tlfc2243 = l_tlf.tlf2243       #製費五成本
   END IF
   LET l_tlfc.tlfc225  = 0                   #No Use
   LET l_tlfc.tlfc2251 = 0                   #No Use
   LET l_tlfc.tlfc226  = 0                   #No Use
   LET l_tlfc.tlfc2271 = 0                   #No Use
   LET l_tlfc.tlfc2272 = 0                   #No Use
   LET l_tlfc.tlfc229  = 0                   #No Use
   LET l_tlfc.tlfc230  = 0                   #No Use
   LET l_tlfc.tlfc231  = 0                   #No Use
   LET l_tlfc.tlfc902  = l_tlf.tlf902        #倉庫
   LET l_tlfc.tlfc903  = l_tlf.tlf903        #儲位
   LET l_tlfc.tlfc904  = l_tlf.tlf904        #批號
   LET l_tlfc.tlfc905  = l_tlf.tlf905        #單號
   LET l_tlfc.tlfc906  = l_tlf.tlf906        #項次
   LET l_tlfc.tlfc907  = l_tlf.tlf907        #入出庫碼
   LET l_tlfc.tlfctype = type                #成本計算類型
   LET l_tlfc.tlfccost = l_tlf.tlfcost       #成本計算類型編號
  #LET l_tlfc.tlfcplant = g_plant #FUN-980009 add    #FUN-A50075
   LET l_tlfc.tlfclegal = g_legal #FUN-980009 add
 
   IF l_cnt >0 THEN   #已存在表示要UPDATE tlfc_file
      UPDATE tlfc_file SET tlfc_file.*=l_tlfc.*
       WHERE tlfc01  =l_tlfc.tlfc01   AND tlfc02  =l_tlfc.tlfc02
         AND tlfc03  =l_tlfc.tlfc03   AND tlfc06  =l_tlfc.tlfc06
         AND tlfc13  =l_tlfc.tlfc13
         AND tlfc902 =l_tlfc.tlfc902  AND tlfc903 =l_tlfc.tlfc903
         AND tlfc904 =l_tlfc.tlfc904  AND tlfc905 =l_tlfc.tlfc905
         AND tlfc906 =l_tlfc.tlfc906  AND tlfc907 =l_tlfc.tlfc907
         AND tlfctype=l_tlfc.tlfctype AND tlfccost=l_tlfc.tlfccost
      IF STATUS THEN 
         CALL cl_err3("upd","tlfc_file",l_tlfc.tlfctype,l_tlfc.tlfccost,STATUS,"","upd_tlfc:",1)
      END IF
   ELSE               #不存在表示要INSERT tlfc_file
      INSERT INTO tlfc_file VALUES(l_tlfc.*)
      IF STATUS THEN
         CALL cl_err3("ins","tlfc_file",l_tlfc.tlfctype,l_tlfc.tlfccost,STATUS,"","ins_tlfc:",1)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p510_ccc_ins() # Insert ccc_file
 DEFINE amtx  LIKE type_file.num20_6       #No.FUN-680122 DEC(20,6),     #MOD-4C0005
 DEFINE l_ccc23,l_ccc23a,l_ccc23b   LIKE ccc_file.ccc23
 DEFINE l_ccc23c,l_ccc23d,l_ccc23e  LIKE ccc_file.ccc23
 DEFINE l_ccc23f,l_ccc23g,l_ccc23h  LIKE ccc_file.ccc23   #FUN-7C0028 add
 
  #折讓部份另外扣除..
 
  #雜出入, 取價計算
 
  IF g_ccc.ccc11=0 AND g_ccc.ccc12=0 AND
     g_ccc.ccc21=0 AND g_ccc.ccc22=0 AND
     g_ccc.ccc25=0 AND g_ccc.ccc26=0 AND
     g_ccc.ccc27=0 AND g_ccc.ccc28=0 AND g_ccc.ccc23=0 AND
     g_ccc.ccc31=0 AND g_ccc.ccc32=0 AND
     g_ccc.ccc41=0 AND g_ccc.ccc42=0 AND
     g_ccc.ccc51=0 AND g_ccc.ccc52=0 AND
     g_ccc.ccc61=0 AND g_ccc.ccc62=0 AND g_ccc.ccc63=0 AND
     g_ccc.ccc71=0 AND g_ccc.ccc72=0 AND
     g_ccc.ccc91=0 AND g_ccc.ccc92=0
    #防止工單未入庫即結案或只有在製
     AND mccg.ccg92 = 0 AND mccg.ccg32 = 0
     AND mccg.ccg91 = 0 AND mccg.ccg31 = 0 #FUN-660142
   THEN LET SQLCA.SQLCODE=0        #若無異動量/成本則不必 Insert
   ELSE
      CALL p510_ckp_ccc() #MOD-4A0263 CHECK ccc_file做NOT NULL欄位的判斷
      UPDATE ccc_file SET ccc_file.*=g_ccc.*
       WHERE ccc01=g_ima01 AND ccc02=yy AND ccc03=mm
         AND ccc07=g_ccc.ccc07 AND ccc08=g_ccc.ccc08   #FUN-7C0028 add
      IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
         CALL p510_ckp_ccc() #MOD-4A0263 CHECK ccc_file做NOT NULL欄位的判斷
         LET g_ccc.cccoriu = g_user      #No.FUN-980030 10/01/04
         LET g_ccc.cccorig = g_grup      #No.FUN-980030 10/01/04
         LET g_ccc.ccclegal = g_legal    #FUN-A50075
         INSERT INTO ccc_file VALUES (g_ccc.*)
      END IF
  END IF
  IF SQLCA.SQLCODE THEN
     LET g_showmsg= g_ccc.ccc01,"/",g_ccc.ccc02                                                                    #No.FUN-710027
     CALL s_errmsg('ccc01,ccc02',g_showmsg,'ins ccc_file:',SQLCA.sqlcode,1)                                         #No.FUN-710027
     LET g_success='N'
  END IF
END FUNCTION
 
FUNCTION p510_ccc_upd() # UPDATE ccc_file
  UPDATE ccc_file SET * = g_ccc.*
   WHERE ccc01 = g_ima01 AND ccc02 = yy AND ccc03 = mm
     AND ccc07 = g_ccc.ccc07 AND ccc08 = g_ccc.ccc08   #FUN-7C0028 add
  IF SQLCA.SQLCODE THEN
     LET g_showmsg = g_ima01,"/",yy                                                                  #No.FUN-710027
     CALL s_errmsg('ccc01,ccc02',g_showmsg,'upd ccc_file:',STATUS,1)                                 #No.FUN-710027
     LET g_success='N'
  END IF
END FUNCTION
 
FUNCTION p510_mccg_0()
   LET mccg.ccg01 =g_sfb.sfb01
   LET mccg.ccg02 =yy
   LET mccg.ccg03 =mm
   LET mccg.ccg04 =g_sfb.sfb05
   LET mccg.ccg06 =type        #FUN-7C0028 add
   LET mccg.ccg07 =g_tlfcost   #FUN-7C0028 add
   LET mccg.ccg11 =0
   LET mccg.ccg12 =0 LET mccg.ccg12a=0 LET mccg.ccg12b=0
   LET mccg.ccg12c=0 LET mccg.ccg12d=0 LET mccg.ccg12e=0
   LET mccg.ccg12f=0 LET mccg.ccg12g=0 LET mccg.ccg12h=0   #FUN-7C0028 add
   LET mccg.ccg20 =0
   LET mccg.ccg21 =0
   LET mccg.ccg22 =0 LET mccg.ccg22a=0 LET mccg.ccg22b=0
   LET mccg.ccg22c=0 LET mccg.ccg22d=0 LET mccg.ccg22e=0
   LET mccg.ccg22f=0 LET mccg.ccg22g=0 LET mccg.ccg22h=0   #FUN-7C0028 add
   LET mccg.ccg23 =0 LET mccg.ccg23a=0 LET mccg.ccg23b=0
   LET mccg.ccg23c=0 LET mccg.ccg23d=0 LET mccg.ccg23e=0
   LET mccg.ccg23f=0 LET mccg.ccg23g=0 LET mccg.ccg23h=0   #FUN-7C0028 add
   LET mccg.ccg31 =0
   LET mccg.ccg32 =0 LET mccg.ccg32a=0 LET mccg.ccg32b=0
   LET mccg.ccg32c=0 LET mccg.ccg32d=0 LET mccg.ccg32e=0
   LET mccg.ccg32f=0 LET mccg.ccg32g=0 LET mccg.ccg32h=0   #FUN-7C0028 add
   LET mccg.ccg41 =0
   LET mccg.ccg42 =0 LET mccg.ccg42a=0 LET mccg.ccg42b=0
   LET mccg.ccg42c=0 LET mccg.ccg42d=0 LET mccg.ccg42e=0
   LET mccg.ccg42f=0 LET mccg.ccg42g=0 LET mccg.ccg42h=0   #FUN-7C0028 add
   LET mccg.ccg91 =0
   LET mccg.ccg92 =0 LET mccg.ccg92a=0 LET mccg.ccg92b=0
   LET mccg.ccg92c=0 LET mccg.ccg92d=0 LET mccg.ccg92e=0
   LET mccg.ccg92f=0 LET mccg.ccg92g=0 LET mccg.ccg92h=0   #FUN-7C0028 add
   LET t_time = TIME
   LET mccg.ccguser=g_user LET mccg.ccgdate=TODAY LET mccg.ccgtime=t_time
END FUNCTION
 
FUNCTION p510_mcch_0()
   LET mcch.cch02 =yy
   LET mcch.cch03 =mm
   LET mcch.cch11 =0
   LET mcch.cch12 =0 LET mcch.cch12a=0 LET mcch.cch12b=0
   LET mcch.cch12c=0 LET mcch.cch12d=0 LET mcch.cch12e=0
   LET mcch.cch12f=0 LET mcch.cch12g=0 LET mcch.cch12h=0   #FUN-7C0028 add
   LET mcch.cch21 =0
   LET mcch.cch22 =0 LET mcch.cch22a=0 LET mcch.cch22b=0
   LET mcch.cch22c=0 LET mcch.cch22d=0 LET mcch.cch22e=0
   LET mcch.cch22f=0 LET mcch.cch22g=0 LET mcch.cch22h=0   #FUN-7C0028 add
   LET mcch.cch31 =0
   LET mcch.cch311=0 #FUN-660206
   LET mcch.cch32 =0 LET mcch.cch32a=0 LET mcch.cch32b=0
   LET mcch.cch32c=0 LET mcch.cch32d=0 LET mcch.cch32e=0
   LET mcch.cch32f=0 LET mcch.cch32g=0 LET mcch.cch32h=0   #FUN-7C0028 add
   LET mcch.cch41 =0
   LET mcch.cch42 =0 LET mcch.cch42a=0 LET mcch.cch42b=0
   LET mcch.cch42c=0 LET mcch.cch42d=0 LET mcch.cch42e=0
   LET mcch.cch42f=0 LET mcch.cch42g=0 LET mcch.cch42h=0   #FUN-7C0028 add
   LET mcch.cch91 =0
   LET mcch.cch92 =0 LET mcch.cch92a=0 LET mcch.cch92b=0
   LET mcch.cch92c=0 LET mcch.cch92d=0 LET mcch.cch92e=0
   LET mcch.cch92f=0 LET mcch.cch92g=0 LET mcch.cch92h=0   #FUN-7C0028 add
 
   #-->累計投入
   LET mcch.cch51 =0
   LET mcch.cch52 =0 LET mcch.cch52a=0 LET mcch.cch52b=0
   LET mcch.cch52c=0 LET mcch.cch52d=0 LET mcch.cch52e=0
   LET mcch.cch52f=0 LET mcch.cch52g=0 LET mcch.cch52h=0   #FUN-7C0028 add
 
   #-->累計轉出
   LET mcch.cch53 =0
   LET mcch.cch54 =0 LET mcch.cch54a=0 LET mcch.cch54b=0
   LET mcch.cch54c=0 LET mcch.cch54d=0 LET mcch.cch54e=0
   LET mcch.cch54f=0 LET mcch.cch54g=0 LET mcch.cch54h=0   #FUN-7C0028 add
 
   #-->累計超領退
   LET mcch.cch55 =0
   LET mcch.cch56 =0 LET mcch.cch56a=0 LET mcch.cch56b=0
   LET mcch.cch56c=0 LET mcch.cch56d=0 LET mcch.cch56e=0
   LET mcch.cch56f=0 LET mcch.cch56g=0 LET mcch.cch56h=0   #FUN-7C0028 add
 
   LET mcch.cch57= 0
   LET mcch.cch58 =0 LET mcch.cch58a=0 LET mcch.cch58b=0
   LET mcch.cch58c=0 LET mcch.cch58d=0 LET mcch.cch58e=0
   LET mcch.cch58f=0 LET mcch.cch58g=0 LET mcch.cch58h=0   #FUN-7C0028 add
 
   LET mcch.cch59=0
   LET mcch.cch60=0  LET mcch.cch60a=0 LET mcch.cch60b=0
   LET mcch.cch60c=0 LET mcch.cch60d=0 LET mcch.cch60e=0
   LET mcch.cch60f=0 LET mcch.cch60g=0 LET mcch.cch60h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_cch_0()           # 依上月期末轉本月期初, 其餘歸零
   LET g_cch.cch02 = yy
   LET g_cch.cch03 = mm
   LET g_cch.cch11 = g_cch.cch91
   LET g_cch.cch12 = g_cch.cch92
   LET g_cch.cch12a= g_cch.cch92a
   LET g_cch.cch12b= g_cch.cch92b
   LET g_cch.cch12c= g_cch.cch92c
   LET g_cch.cch12d= g_cch.cch92d
   LET g_cch.cch12e= g_cch.cch92e
   LET g_cch.cch12f= g_cch.cch92f   #FUN-7C0028 add
   LET g_cch.cch12g= g_cch.cch92g   #FUN-7C0028 add
   LET g_cch.cch12h= g_cch.cch92h   #FUN-7C0028 add
   LET g_cch.cch21 =0
   LET g_cch.cch22 =0 LET g_cch.cch22a=0 LET g_cch.cch22b=0
   LET g_cch.cch22c=0 LET g_cch.cch22d=0 LET g_cch.cch22e=0
   LET g_cch.cch22f=0 LET g_cch.cch22g=0 LET g_cch.cch22h=0   #FUN-7C0028 add
   LET g_cch.cch31 =0
   LET g_cch.cch311=0 #FUN-660206
   LET g_cch.cch32 =0 LET g_cch.cch32a=0 LET g_cch.cch32b=0
   LET g_cch.cch32c=0 LET g_cch.cch32d=0 LET g_cch.cch32e=0
   LET g_cch.cch32f=0 LET g_cch.cch32g=0 LET g_cch.cch32h=0   #FUN-7C0028 add
   LET g_cch.cch41 =0
   LET g_cch.cch42 =0 LET g_cch.cch42a=0 LET g_cch.cch42b=0
   LET g_cch.cch42c=0 LET g_cch.cch42d=0 LET g_cch.cch42e=0
   LET g_cch.cch42f=0 LET g_cch.cch42g=0 LET g_cch.cch42h=0   #FUN-7C0028 add
   LET g_cch.cch91 =0
   LET g_cch.cch92 =0 LET g_cch.cch92a=0 LET g_cch.cch92b=0
   LET g_cch.cch92c=0 LET g_cch.cch92d=0 LET g_cch.cch92e=0
   LET g_cch.cch92f=0 LET g_cch.cch92g=0 LET g_cch.cch92h=0   #FUN-7C0028 add
 
   #-->累計投入
   LET g_cch.cch51 = g_cch.cch51
   LET g_cch.cch52 = g_cch.cch52  LET g_cch.cch52a=g_cch.cch52a
   LET g_cch.cch52b= g_cch.cch52b LET g_cch.cch52c=g_cch.cch52c
   LET g_cch.cch52d= g_cch.cch52d LET g_cch.cch52e=g_cch.cch52e
   LET g_cch.cch52f= g_cch.cch52f LET g_cch.cch52g=g_cch.cch52g   #FUN-7C0028 add
   LET g_cch.cch52h= g_cch.cch52g                                 #FUN-7C0028 add
   IF cl_null(g_cch.cch51)  THEN LET g_cch.cch51  = 0 END IF
   IF cl_null(g_cch.cch52)  THEN LET g_cch.cch52  = 0 END IF
   IF cl_null(g_cch.cch52a) THEN LET g_cch.cch52a = 0 END IF
   IF cl_null(g_cch.cch52b) THEN LET g_cch.cch52b = 0 END IF
   IF cl_null(g_cch.cch52c) THEN LET g_cch.cch52c = 0 END IF
   IF cl_null(g_cch.cch52d) THEN LET g_cch.cch52d = 0 END IF
   IF cl_null(g_cch.cch52e) THEN LET g_cch.cch52e = 0 END IF
   IF cl_null(g_cch.cch52f) THEN LET g_cch.cch52f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch52g) THEN LET g_cch.cch52g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch52h) THEN LET g_cch.cch52h = 0 END IF   #FUN-7C0028 add
 
   #-->累計轉出
   LET g_cch.cch53 = g_cch.cch53
   LET g_cch.cch54 = g_cch.cch54  LET g_cch.cch54a=g_cch.cch54a
   LET g_cch.cch54b= g_cch.cch54b LET g_cch.cch54c=g_cch.cch54c
   LET g_cch.cch54d= g_cch.cch54d LET g_cch.cch54e=g_cch.cch54e
   LET g_cch.cch54f= g_cch.cch54f LET g_cch.cch54g=g_cch.cch54g   #FUN-7C0028 add
   LET g_cch.cch54h= g_cch.cch54g                                 #FUN-7C0028 add
   IF cl_null(g_cch.cch53)  THEN LET g_cch.cch53  = 0 END IF
   IF cl_null(g_cch.cch54)  THEN LET g_cch.cch54  = 0 END IF
   IF cl_null(g_cch.cch54a) THEN LET g_cch.cch54a = 0 END IF
   IF cl_null(g_cch.cch54b) THEN LET g_cch.cch54b = 0 END IF
   IF cl_null(g_cch.cch54c) THEN LET g_cch.cch54c = 0 END IF
   IF cl_null(g_cch.cch54d) THEN LET g_cch.cch54d = 0 END IF
   IF cl_null(g_cch.cch54e) THEN LET g_cch.cch54e = 0 END IF
   IF cl_null(g_cch.cch54f) THEN LET g_cch.cch54f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch54g) THEN LET g_cch.cch54g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch54h) THEN LET g_cch.cch54h = 0 END IF   #FUN-7C0028 add
 
   #-->累計超領退
   LET g_cch.cch55 = g_cch.cch55
   LET g_cch.cch56 = g_cch.cch56  LET g_cch.cch56a=g_cch.cch56a
   LET g_cch.cch56b= g_cch.cch56b LET g_cch.cch56c=g_cch.cch56c
   LET g_cch.cch56d= g_cch.cch56d LET g_cch.cch56e=g_cch.cch56e
   LET g_cch.cch56f= g_cch.cch56f LET g_cch.cch56g=g_cch.cch56g   #FUN-7C0028 add
   LET g_cch.cch56h= g_cch.cch56g                                 #FUN-7C0028 add
   IF cl_null(g_cch.cch55)  THEN LET g_cch.cch55  = 0 END IF
   IF cl_null(g_cch.cch56)  THEN LET g_cch.cch56  = 0 END IF
   IF cl_null(g_cch.cch56a) THEN LET g_cch.cch56a = 0 END IF
   IF cl_null(g_cch.cch56b) THEN LET g_cch.cch54b = 0 END IF
   IF cl_null(g_cch.cch56c) THEN LET g_cch.cch56c = 0 END IF
   IF cl_null(g_cch.cch56d) THEN LET g_cch.cch56d = 0 END IF
   IF cl_null(g_cch.cch56e) THEN LET g_cch.cch56e = 0 END IF
   IF cl_null(g_cch.cch56f) THEN LET g_cch.cch56f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch56g) THEN LET g_cch.cch56g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cch.cch56h) THEN LET g_cch.cch56h = 0 END IF   #FUN-7C0028 add
 
   LET g_cch.cch57= 0
   LET g_cch.cch58=0  LET g_cch.cch58a=0 LET g_cch.cch58b=0
   LET g_cch.cch58c=0 LET g_cch.cch58d=0 LET g_cch.cch58e=0
   LET g_cch.cch58f=0 LET g_cch.cch58g=0 LET g_cch.cch58h=0   #FUN-7C0028 add
 
   LET g_cch.cch59=0
   LET g_cch.cch60=0  LET g_cch.cch60a=0 LET g_cch.cch60b=0
   LET g_cch.cch60c=0 LET g_cch.cch60d=0 LET g_cch.cch60e=0
   LET g_cch.cch60f=0 LET g_cch.cch60g=0 LET g_cch.cch60h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_cxh_0()           # 依上月期末轉本月期初, 其餘歸零
   LET g_cxh.cxh02 = yy
   LET g_cxh.cxh03 = mm
   LET g_cxh.cxh11 = g_cxh.cxh91
   LET g_cxh.cxh12 = g_cxh.cxh92
   LET g_cxh.cxh12a= g_cxh.cxh92a
   LET g_cxh.cxh12b= g_cxh.cxh92b
   LET g_cxh.cxh12c= g_cxh.cxh92c
   LET g_cxh.cxh12d= g_cxh.cxh92d
   LET g_cxh.cxh12e= g_cxh.cxh92e
   LET g_cxh.cxh12f= g_cxh.cxh92f   #FUN-7C0028 add
   LET g_cxh.cxh12g= g_cxh.cxh92g   #FUN-7C0028 add
   LET g_cxh.cxh12h= g_cxh.cxh92h   #FUN-7C0028 add
   LET g_cxh.cxh21 =0
   LET g_cxh.cxh22 =0 LET g_cxh.cxh22a=0 LET g_cxh.cxh22b=0
   LET g_cxh.cxh22c=0 LET g_cxh.cxh22d=0 LET g_cxh.cxh22e=0
   LET g_cxh.cxh22f=0 LET g_cxh.cxh22g=0 LET g_cxh.cxh22h=0   #FUN-7C0028 add
   LET g_cxh.cxh24 =0
   LET g_cxh.cxh25 =0 LET g_cxh.cxh25a=0 LET g_cxh.cxh25b=0
   LET g_cxh.cxh25c=0 LET g_cxh.cxh25d=0 LET g_cxh.cxh25e=0
   LET g_cxh.cxh25f=0 LET g_cxh.cxh25g=0 LET g_cxh.cxh25h=0   #FUN-7C0028 add
   LET g_cxh.cxh26 =0
   LET g_cxh.cxh27 =0 LET g_cxh.cxh27a=0 LET g_cxh.cxh27b=0
   LET g_cxh.cxh27c=0 LET g_cxh.cxh27d=0 LET g_cxh.cxh27e=0
   LET g_cxh.cxh27f=0 LET g_cxh.cxh27g=0 LET g_cxh.cxh27h=0   #FUN-7C0028 add
   LET g_cxh.cxh28 =0
   LET g_cxh.cxh29 =0 LET g_cxh.cxh29a=0 LET g_cxh.cxh29b=0
   LET g_cxh.cxh29c=0 LET g_cxh.cxh29d=0 LET g_cxh.cxh29e=0
   LET g_cxh.cxh29f=0 LET g_cxh.cxh29g=0 LET g_cxh.cxh29h=0   #FUN-7C0028 add
   LET g_cxh.cxh31 =0
   LET g_cxh.cxh32 =0 LET g_cxh.cxh32a=0 LET g_cxh.cxh32b=0
   LET g_cxh.cxh32c=0 LET g_cxh.cxh32d=0 LET g_cxh.cxh32e=0
   LET g_cxh.cxh32f=0 LET g_cxh.cxh32g=0 LET g_cxh.cxh32h=0   #FUN-7C0028 add
   LET g_cxh.cxh33 =0
   LET g_cxh.cxh34 =0 LET g_cxh.cxh34a=0 LET g_cxh.cxh34b=0
   LET g_cxh.cxh34c=0 LET g_cxh.cxh34d=0 LET g_cxh.cxh34e=0
   LET g_cxh.cxh34f=0 LET g_cxh.cxh34g=0 LET g_cxh.cxh34h=0   #FUN-7C0028 add
   LET g_cxh.cxh35 =0
   LET g_cxh.cxh36 =0 LET g_cxh.cxh36a=0 LET g_cxh.cxh36b=0
   LET g_cxh.cxh36c=0 LET g_cxh.cxh36d=0 LET g_cxh.cxh36e=0
   LET g_cxh.cxh36f=0 LET g_cxh.cxh36g=0 LET g_cxh.cxh36h=0   #FUN-7C0028 add
   LET g_cxh.cxh37 =0
   LET g_cxh.cxh38 =0 LET g_cxh.cxh38a=0 LET g_cxh.cxh38b=0
   LET g_cxh.cxh38c=0 LET g_cxh.cxh38d=0 LET g_cxh.cxh38e=0
   LET g_cxh.cxh38f=0 LET g_cxh.cxh38g=0 LET g_cxh.cxh38h=0   #FUN-7C0028 add
   LET g_cxh.cxh39 =0
   LET g_cxh.cxh40 =0 LET g_cxh.cxh40a=0 LET g_cxh.cxh40b=0
   LET g_cxh.cxh40c=0 LET g_cxh.cxh40d=0 LET g_cxh.cxh40e=0
   LET g_cxh.cxh40f=0 LET g_cxh.cxh40g=0 LET g_cxh.cxh40h=0   #FUN-7C0028 add
   LET g_cxh.cxh41 =0
   LET g_cxh.cxh42 =0 LET g_cxh.cxh42a=0 LET g_cxh.cxh42b=0
   LET g_cxh.cxh42c=0 LET g_cxh.cxh42d=0 LET g_cxh.cxh42e=0
   LET g_cxh.cxh42f=0 LET g_cxh.cxh42g=0 LET g_cxh.cxh42h=0   #FUN-7C0028 add
 
   #-->累計投入
   LET g_cxh.cxh51 = g_cxh.cxh51
   LET g_cxh.cxh52 = g_cxh.cxh52  LET g_cxh.cxh52a=g_cxh.cxh52a
   LET g_cxh.cxh52b= g_cxh.cxh52b LET g_cxh.cxh52c=g_cxh.cxh52c
   LET g_cxh.cxh52d= g_cxh.cxh52d LET g_cxh.cxh52e=g_cxh.cxh52e
   LET g_cxh.cxh52f= g_cxh.cxh52f LET g_cxh.cxh52g=g_cxh.cxh52g   #FUN-7C0028 add
   LET g_cxh.cxh52h= g_cxh.cxh52g                                 #FUN-7C0028 add
   IF cl_null(g_cxh.cxh51)  THEN LET g_cxh.cxh51  = 0 END IF
   IF cl_null(g_cxh.cxh52)  THEN LET g_cxh.cxh52  = 0 END IF
   IF cl_null(g_cxh.cxh52a) THEN LET g_cxh.cxh52a = 0 END IF
   IF cl_null(g_cxh.cxh52b) THEN LET g_cxh.cxh52b = 0 END IF
   IF cl_null(g_cxh.cxh52c) THEN LET g_cxh.cxh52c = 0 END IF
   IF cl_null(g_cxh.cxh52d) THEN LET g_cxh.cxh52d = 0 END IF
   IF cl_null(g_cxh.cxh52e) THEN LET g_cxh.cxh52e = 0 END IF
   IF cl_null(g_cxh.cxh52f) THEN LET g_cxh.cxh52f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cxh.cxh52g) THEN LET g_cxh.cxh52g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cxh.cxh52h) THEN LET g_cxh.cxh52h = 0 END IF   #FUN-7C0028 add
 
   #-->累計轉出
   LET g_cxh.cxh53 = g_cxh.cxh53
   LET g_cxh.cxh54 = g_cxh.cxh54  LET g_cxh.cxh54a=g_cxh.cxh54a
   LET g_cxh.cxh54b= g_cxh.cxh54b LET g_cxh.cxh54c=g_cxh.cxh54c
   LET g_cxh.cxh54d= g_cxh.cxh54d LET g_cxh.cxh54e=g_cxh.cxh54e
   LET g_cxh.cxh54f= g_cxh.cxh54f LET g_cxh.cxh54g=g_cxh.cxh54g   #FUN-7C0028 add
   LET g_cxh.cxh54h= g_cxh.cxh54g                                 #FUN-7C0028 add
   IF cl_null(g_cxh.cxh53)  THEN LET g_cxh.cxh53  = 0 END IF
   IF cl_null(g_cxh.cxh54)  THEN LET g_cxh.cxh54  = 0 END IF
   IF cl_null(g_cxh.cxh54a) THEN LET g_cxh.cxh54a = 0 END IF
   IF cl_null(g_cxh.cxh54b) THEN LET g_cxh.cxh54b = 0 END IF
   IF cl_null(g_cxh.cxh54c) THEN LET g_cxh.cxh54c = 0 END IF
   IF cl_null(g_cxh.cxh54d) THEN LET g_cxh.cxh54d = 0 END IF
   IF cl_null(g_cxh.cxh54e) THEN LET g_cxh.cxh54e = 0 END IF
   IF cl_null(g_cxh.cxh54f) THEN LET g_cxh.cxh54f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cxh.cxh54g) THEN LET g_cxh.cxh54g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cxh.cxh54h) THEN LET g_cxh.cxh54h = 0 END IF   #FUN-7C0028 add
 
   #-->累計超領退
   LET g_cxh.cxh55 = g_cxh.cxh55
   LET g_cxh.cxh56 = g_cxh.cxh56  LET g_cxh.cxh56a=g_cxh.cxh56a
   LET g_cxh.cxh56b= g_cxh.cxh56b LET g_cxh.cxh56c=g_cxh.cxh56c
   LET g_cxh.cxh56d= g_cxh.cxh56d LET g_cxh.cxh56e=g_cxh.cxh56e
   LET g_cxh.cxh56f= g_cxh.cxh56f LET g_cxh.cxh56g=g_cxh.cxh56g   #FUN-7C0028 add
   LET g_cxh.cxh56h= g_cxh.cxh56g                                 #FUN-7C0028 add
   IF cl_null(g_cxh.cxh55)  THEN LET g_cxh.cxh55  = 0 END IF
   IF cl_null(g_cxh.cxh56)  THEN LET g_cxh.cxh56  = 0 END IF
   IF cl_null(g_cxh.cxh56a) THEN LET g_cxh.cxh56a = 0 END IF
   IF cl_null(g_cxh.cxh56b) THEN LET g_cxh.cxh56b = 0 END IF
   IF cl_null(g_cxh.cxh56c) THEN LET g_cxh.cxh56c = 0 END IF
   IF cl_null(g_cxh.cxh56d) THEN LET g_cxh.cxh56d = 0 END IF
   IF cl_null(g_cxh.cxh56e) THEN LET g_cxh.cxh56e = 0 END IF
   IF cl_null(g_cxh.cxh56f) THEN LET g_cxh.cxh56f = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cxh.cxh56g) THEN LET g_cxh.cxh56g = 0 END IF   #FUN-7C0028 add
   IF cl_null(g_cxh.cxh56h) THEN LET g_cxh.cxh56h = 0 END IF   #FUN-7C0028 add
 
   LET g_cxh.cxh57 =0
   LET g_cxh.cxh58 =0 LET g_cxh.cxh58a=0 LET g_cxh.cxh58b=0
   LET g_cxh.cxh58c=0 LET g_cxh.cxh58d=0 LET g_cxh.cxh58e=0
   LET g_cxh.cxh58f=0 LET g_cxh.cxh58g=0 LET g_cxh.cxh58h=0   #FUN-7C0028 add
 
   LET g_cxh.cxh59 =0
   LET g_cxh.cxh60 =0 LET g_cxh.cxh60a=0 LET g_cxh.cxh60b=0
   LET g_cxh.cxh60c=0 LET g_cxh.cxh60d=0 LET g_cxh.cxh60e=0
   LET g_cxh.cxh60f=0 LET g_cxh.cxh60g=0 LET g_cxh.cxh60h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_cch_01()          # 全部歸零
   LET g_cch.cch02 =yy
   LET g_cch.cch03 =mm
   LET g_cch.cch11 =0
   LET g_cch.cch12 =0 LET g_cch.cch12a=0 LET g_cch.cch12b=0
   LET g_cch.cch12c=0 LET g_cch.cch12d=0 LET g_cch.cch12e=0
   LET g_cch.cch12f=0 LET g_cch.cch12g=0 LET g_cch.cch12h=0   #FUN-7C0028 add
   LET g_cch.cch21 =0
   LET g_cch.cch22 =0 LET g_cch.cch22a=0 LET g_cch.cch22b=0
   LET g_cch.cch22c=0 LET g_cch.cch22d=0 LET g_cch.cch22e=0
   LET g_cch.cch22f=0 LET g_cch.cch22g=0 LET g_cch.cch22h=0   #FUN-7C0028 add
   LET g_cch.cch31 =0
   LET g_cch.cch311=0 #FUN-660206
   LET g_cch.cch32 =0 LET g_cch.cch32a=0 LET g_cch.cch32b=0
   LET g_cch.cch32c=0 LET g_cch.cch32d=0 LET g_cch.cch32e=0
   LET g_cch.cch32f=0 LET g_cch.cch32g=0 LET g_cch.cch32h=0   #FUN-7C0028 add
   LET g_cch.cch41 =0
   LET g_cch.cch42 =0 LET g_cch.cch42a=0 LET g_cch.cch42b=0
   LET g_cch.cch42c=0 LET g_cch.cch42d=0 LET g_cch.cch42e=0
   LET g_cch.cch42f=0 LET g_cch.cch42g=0 LET g_cch.cch42h=0   #FUN-7C0028 add
   LET g_cch.cch51 =0
   LET g_cch.cch52 =0 LET g_cch.cch52a=0 LET g_cch.cch52b=0
   LET g_cch.cch52c=0 LET g_cch.cch52d=0 LET g_cch.cch52e=0
   LET g_cch.cch52f=0 LET g_cch.cch52g=0 LET g_cch.cch52h=0   #FUN-7C0028 add
   LET g_cch.cch53 =0
   LET g_cch.cch54 =0 LET g_cch.cch54a=0 LET g_cch.cch54b=0
   LET g_cch.cch54c=0 LET g_cch.cch54d=0 LET g_cch.cch54e=0
   LET g_cch.cch54f=0 LET g_cch.cch54g=0 LET g_cch.cch54h=0   #FUN-7C0028 add
   LET g_cch.cch55 =0
   LET g_cch.cch56 =0 LET g_cch.cch56a=0 LET g_cch.cch56b=0
   LET g_cch.cch56c=0 LET g_cch.cch56d=0 LET g_cch.cch56e=0
   LET g_cch.cch56f=0 LET g_cch.cch56g=0 LET g_cch.cch56h=0   #FUN-7C0028 add
   LET g_cch.cch57 =0
   LET g_cch.cch58 =0 LET g_cch.cch58a=0 LET g_cch.cch58b=0
   LET g_cch.cch58c=0 LET g_cch.cch58d=0 LET g_cch.cch58e=0
   LET g_cch.cch58f=0 LET g_cch.cch58g=0 LET g_cch.cch58h=0   #FUN-7C0028 add
   LET g_cch.cch59 =0
   LET g_cch.cch60 =0 LET g_cch.cch60a=0 LET g_cch.cch60b=0
   LET g_cch.cch60c=0 LET g_cch.cch60d=0 LET g_cch.cch60e=0
   LET g_cch.cch60f=0 LET g_cch.cch60g=0 LET g_cch.cch60h=0   #FUN-7C0028 add
   LET g_cch.cch91 =0
   LET g_cch.cch92 =0 LET g_cch.cch92a=0 LET g_cch.cch92b=0
   LET g_cch.cch92c=0 LET g_cch.cch92d=0 LET g_cch.cch92e=0
   LET g_cch.cch92f=0 LET g_cch.cch92g=0 LET g_cch.cch92h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_cxh_01()        #全部歸零
   CALL p510_get_cxh011()
   LET g_cxh.cxh02 =yy
   LET g_cxh.cxh03 =mm
   LET g_cxh.cxh11 =0
   LET g_cxh.cxh12 =0 LET g_cxh.cxh12a=0 LET g_cxh.cxh12b=0
   LET g_cxh.cxh12c=0 LET g_cxh.cxh12d=0 LET g_cxh.cxh12e=0
   LET g_cxh.cxh12f=0 LET g_cxh.cxh12g=0 LET g_cxh.cxh12h=0   #FUN-7C0028 add
   LET g_cxh.cxh21 =0
   LET g_cxh.cxh22 =0 LET g_cxh.cxh22a=0 LET g_cxh.cxh22b=0
   LET g_cxh.cxh22c=0 LET g_cxh.cxh22d=0 LET g_cxh.cxh22e=0
   LET g_cxh.cxh22f=0 LET g_cxh.cxh22g=0 LET g_cxh.cxh22h=0   #FUN-7C0028 add
   LET g_cxh.cxh24 =0
   LET g_cxh.cxh25 =0 LET g_cxh.cxh25a=0 LET g_cxh.cxh25b=0
   LET g_cxh.cxh25c=0 LET g_cxh.cxh25d=0 LET g_cxh.cxh25e=0
   LET g_cxh.cxh25f=0 LET g_cxh.cxh25g=0 LET g_cxh.cxh25h=0   #FUN-7C0028 add
   LET g_cxh.cxh26 =0
   LET g_cxh.cxh27 =0 LET g_cxh.cxh27a=0 LET g_cxh.cxh27b=0
   LET g_cxh.cxh27c=0 LET g_cxh.cxh27d=0 LET g_cxh.cxh27e=0
   LET g_cxh.cxh27f=0 LET g_cxh.cxh27g=0 LET g_cxh.cxh27h=0   #FUN-7C0028 add
   LET g_cxh.cxh28 =0
   LET g_cxh.cxh29 =0 LET g_cxh.cxh29a=0 LET g_cxh.cxh29b=0
   LET g_cxh.cxh29c=0 LET g_cxh.cxh29d=0 LET g_cxh.cxh29e=0
   LET g_cxh.cxh29f=0 LET g_cxh.cxh29g=0 LET g_cxh.cxh29h=0   #FUN-7C0028 add
   LET g_cxh.cxh31 =0
   LET g_cxh.cxh32 =0 LET g_cxh.cxh32a=0 LET g_cxh.cxh32b=0
   LET g_cxh.cxh32c=0 LET g_cxh.cxh32d=0 LET g_cxh.cxh32e=0
   LET g_cxh.cxh32f=0 LET g_cxh.cxh32g=0 LET g_cxh.cxh32h=0   #FUN-7C0028 add
   LET g_cxh.cxh33 =0
   LET g_cxh.cxh34 =0 LET g_cxh.cxh34a=0 LET g_cxh.cxh34b=0
   LET g_cxh.cxh34c=0 LET g_cxh.cxh34d=0 LET g_cxh.cxh34e=0
   LET g_cxh.cxh34f=0 LET g_cxh.cxh34g=0 LET g_cxh.cxh34h=0   #FUN-7C0028 add
   LET g_cxh.cxh35 =0
   LET g_cxh.cxh36 =0 LET g_cxh.cxh36a=0 LET g_cxh.cxh36b=0
   LET g_cxh.cxh36c=0 LET g_cxh.cxh36d=0 LET g_cxh.cxh36e=0
   LET g_cxh.cxh36f=0 LET g_cxh.cxh36g=0 LET g_cxh.cxh36h=0   #FUN-7C0028 add
   LET g_cxh.cxh37 =0
   LET g_cxh.cxh38 =0 LET g_cxh.cxh38a=0 LET g_cxh.cxh38b=0
   LET g_cxh.cxh38c=0 LET g_cxh.cxh38d=0 LET g_cxh.cxh38e=0
   LET g_cxh.cxh38f=0 LET g_cxh.cxh38g=0 LET g_cxh.cxh38h=0   #FUN-7C0028 add
   LET g_cxh.cxh39 =0
   LET g_cxh.cxh40 =0 LET g_cxh.cxh40a=0 LET g_cxh.cxh40b=0
   LET g_cxh.cxh40c=0 LET g_cxh.cxh40d=0 LET g_cxh.cxh40e=0
   LET g_cxh.cxh40f=0 LET g_cxh.cxh40g=0 LET g_cxh.cxh40h=0   #FUN-7C0028 add
   LET g_cxh.cxh41 =0
   LET g_cxh.cxh42 =0 LET g_cxh.cxh42a=0 LET g_cxh.cxh42b=0
   LET g_cxh.cxh42c=0 LET g_cxh.cxh42d=0 LET g_cxh.cxh42e=0
   LET g_cxh.cxh42f=0 LET g_cxh.cxh42g=0 LET g_cxh.cxh42h=0   #FUN-7C0028 add
   LET g_cxh.cxh51 =0
   LET g_cxh.cxh52 =0 LET g_cxh.cxh52a=0 LET g_cxh.cxh52b=0
   LET g_cxh.cxh52c=0 LET g_cxh.cxh52d=0 LET g_cxh.cxh52e=0
   LET g_cxh.cxh52f=0 LET g_cxh.cxh52g=0 LET g_cxh.cxh52h=0   #FUN-7C0028 add
   LET g_cxh.cxh53 =0
   LET g_cxh.cxh54 =0 LET g_cxh.cxh54a=0 LET g_cxh.cxh54b=0
   LET g_cxh.cxh54c=0 LET g_cxh.cxh54d=0 LET g_cxh.cxh54e=0
   LET g_cxh.cxh54f=0 LET g_cxh.cxh54g=0 LET g_cxh.cxh54h=0   #FUN-7C0028 add
   LET g_cxh.cxh55 =0
   LET g_cxh.cxh56 =0 LET g_cxh.cxh56a=0 LET g_cxh.cxh56b=0
   LET g_cxh.cxh56c=0 LET g_cxh.cxh56d=0 LET g_cxh.cxh56e=0
   LET g_cxh.cxh56f=0 LET g_cxh.cxh56g=0 LET g_cxh.cxh56h=0   #FUN-7C0028 add
   LET g_cxh.cxh57 =0
   LET g_cxh.cxh58 =0 LET g_cxh.cxh58a=0 LET g_cxh.cxh58b=0
   LET g_cxh.cxh58c=0 LET g_cxh.cxh58d=0 LET g_cxh.cxh58e=0
   LET g_cxh.cxh58f=0 LET g_cxh.cxh58g=0 LET g_cxh.cxh58h=0   #FUN-7C0028 add
   LET g_cxh.cxh59 =0
   LET g_cxh.cxh60 =0 LET g_cxh.cxh60a=0 LET g_cxh.cxh60b=0
   LET g_cxh.cxh60c=0 LET g_cxh.cxh60d=0 LET g_cxh.cxh60e=0
   LET g_cxh.cxh60f=0 LET g_cxh.cxh60g=0 LET g_cxh.cxh60h=0   #FUN-7C0028 add
   LET g_cxh.cxh91 =0
   LET g_cxh.cxh92 =0 LET g_cxh.cxh92a=0 LET g_cxh.cxh92b=0
   LET g_cxh.cxh92c=0 LET g_cxh.cxh92d=0 LET g_cxh.cxh92e=0
   LET g_cxh.cxh92f=0 LET g_cxh.cxh92g=0 LET g_cxh.cxh92h=0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION wip_del()
   DEFINE wo_no         LIKE ccg_file.ccg01       #No.FUN-680122 VARCHAR(16)    #No.FUN-550025
   DECLARE p110_wip_del_c1 CURSOR FOR
       SELECT ccg01 FROM ccg_file
        WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
          AND ccg06=type    AND ccg07=g_tlfcost   #FUN-7C0028 add
   FOREACH p110_wip_del_c1 INTO wo_no
      IF SQLCA.sqlcode THEN
         CALL cl_err('p110_wip_del_c1',SQLCA.sqlcode,0)
         EXIT FOREACH
      END IF
      DELETE FROM cch_file WHERE cch01=wo_no AND cch02=yy AND cch03=mm
                             AND cch06=type  AND cch07=g_tlfcost   #FUN-7C0028 add
      DELETE FROM ccg_file WHERE ccg01=wo_no AND ccg02=yy AND ccg03=mm
                             AND ccg06=type  AND ccg07=g_tlfcost   #FUN-7C0028 add
   END FOREACH
   CLOSE p110_wip_del_c1
END FUNCTION
 
FUNCTION work_del3()
   DELETE FROM cxh_file WHERE cxh01=g_sfb.sfb01 AND cxh02=yy AND cxh03=mm
                          AND cxh06=type  AND cxh07=g_tlfcost   #FUN-7C0028 add
   DELETE FROM cch_file WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
                          AND cch06=type  AND cch07=g_tlfcost   #FUN-7C0028 add
   DELETE FROM ccg_file WHERE ccg01=g_sfb.sfb01 AND ccg02=yy AND ccg03=mm
                          AND ccg06=type  AND ccg07=g_tlfcost   #FUN-7C0028 add
END FUNCTION
 
FUNCTION work_del2()
   DEFINE wo_no         LIKE ccg_file.ccg01       #No.FUN-680122 VARCHAR(16)      #No.FUN-550025
   DECLARE p110_work_del_c2 CURSOR FOR
       SELECT ccg01 FROM ccg_file, sfb_file
             WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
               AND ccg06=type    AND ccg07=g_tlfcost   #FUN-7C0028 add
               AND ccg01=sfb01   AND sfb02 != '13'
               AND sfb02 != '11' AND sfb99='Y' AND sfb93='Y'
   FOREACH p110_work_del_c2 INTO wo_no
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','p110_work_del_c2',SQLCA.sqlcode,0)   #No.FUN-710027
        EXIT FOREACH
     END IF
     DELETE FROM cch_file WHERE cch01=wo_no AND cch02=yy AND cch03=mm
                            AND cch06=type  AND cch07=g_tlfcost   #FUN-7C0028 add
     DELETE FROM ccg_file WHERE ccg01=wo_no AND ccg02=yy AND ccg03=mm
                            AND ccg06=type  AND ccg07=g_tlfcost   #FUN-7C0028 add
   END FOREACH
   CLOSE p110_work_del_c2
END FUNCTION
 
FUNCTION wip_del2()
   DEFINE wo_no         LIKE ccg_file.ccg01       #No.FUN-680122 VARCHAR(16)     #No.FUN-550025
   DECLARE p110_wip_del_c2 CURSOR FOR
       SELECT ccg01 FROM ccg_file, sfb_file
             WHERE ccg04=g_ima01 AND ccg02=yy AND ccg03=mm
               AND ccg06=type    AND ccg07=g_tlfcost   #FUN-7C0028 add
               AND ccg01=sfb01   AND sfb02 != '13'
               AND sfb02 != '11' AND sfb99='Y' AND sfb93='N'
   FOREACH p110_wip_del_c2 INTO wo_no
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','p110_wip_del_c2',SQLCA.sqlcode,0)   #No.FUN-710027
        EXIT FOREACH
     END IF
     DELETE FROM cch_file WHERE cch01=wo_no AND cch02=yy AND cch03=mm
                            AND cch06=type  AND cch07=g_tlfcost   #FUN-7C0028 add
     DELETE FROM ccg_file WHERE ccg01=wo_no AND ccg02=yy AND ccg03=mm
                            AND ccg06=type  AND ccg07=g_tlfcost   #FUN-7C0028 add
   END FOREACH
   CLOSE p110_wip_del_c2
END FUNCTION
 
FUNCTION p510_wip()     # 處理 WIP 在製成本 (工單性質=1/7)
   DEFINE l_sql STRING   #FUN-7C0028 add
 
   IF g_bgjob = 'N' THEN             #FUN-570153
      MESSAGE '_wip ...'
      CALL ui.Interface.refresh()
   END IF
   CALL wip_del()       # 先 delete ccg_file, cch_file 該主件相關資料
   LET l_sql="SELECT * FROM sfb_file",
             " WHERE sfb05 ='",g_ima01,"' AND sfb93='N'",
             "   AND sfb02!= '13' AND sfb02 != '11'",
             "   AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N')",
             "   AND (sfb38 IS NULL OR sfb38 >='",g_bdate,"')",  # 工單成會結案日
             "   AND (sfb81 IS NULL OR sfb81 <='",g_edate,"')"   # 工單xx立日期
   IF type = '4' THEN   #個別認定-專案成本
      LET l_sql=l_sql,"   AND sfb27='",g_tlfcost,"'"
   END IF
   LET l_sql=l_sql," ORDER BY sfb01"
   DECLARE wip_c1 CURSOR FROM l_sql
 
   FOREACH wip_c1 INTO g_sfb.*
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','wip_c1',SQLCA.sqlcode,0)  #No.FUN-710027
        EXIT FOREACH
     END IF
     CALL wip_del()       # 先 delete ccg_file, cch_file 該主件相關資料
     IF g_bgjob = 'N' THEN             #FUN-570153
        MESSAGE 'wo:',g_sfb.sfb01," #1"
        CALL ui.Interface.refresh()
     END IF
     CALL wip_1()       # 計算每張工單的 WIP-主件 部份 成本 (ccg)
     IF g_bgjob = 'N' THEN             #FUN-570153
        MESSAGE 'wo:',g_sfb.sfb01," #2"
        CALL ui.Interface.refresh()
     END IF
     CALL wip_2()       # 計算每張工單的 WIP-元件 投入 成本 (cch)
     IF g_bgjob = 'N' THEN             #FUN-570153
        MESSAGE 'wo:',g_sfb.sfb01," #3"
        CALL ui.Interface.refresh()
     END IF
     CALL wip_3()       # 計算每張工單的 WIP-元件 轉出 成本 (cch)
     IF g_bgjob = 'N' THEN             #FUN-570153
        MESSAGE 'wo:',g_sfb.sfb01," #4"
        CALL ui.Interface.refresh()
     END IF
     CALL wip_4()       # 計算每張工單的 WIP-主件 SUM  成本 (ccg)
   END FOREACH
   CLOSE wip_c1
END FUNCTION
 
FUNCTION p510_wip_prepare()
 
   LET g_cxh31=0  LET g_cxh39=0   LET g_cxh33=0
   LET g_cxh37=0  LET g_cxh35=0
   DECLARE work_c10 CURSOR FOR
      SELECT sfb_file.*,caf_file.* FROM sfb_file ,caf_file
       WHERE sfb05 =g_ima01
         AND sfb93 ='Y'
         AND sfb01 =caf01
         AND caf02 = yy  AND caf03=mm
         AND sfb02 !='13' AND sfb02 != '11'
         AND (sfb38 IS NULL OR sfb38 >= g_bdate)  # 工單成會結案日
         AND (sfb81 IS NULL OR sfb81 <= g_edate)  # 工單開立日期
    ORDER BY sfb01
   FOREACH work_c10 INTO g_sfb.*,g_caf.*
      CALL work_get_tmp8()
   END FOREACH
END FUNCTION
 
#處理 製程段在製
FUNCTION p510_wip2()       #處理 WIP 在製成本 (工單性質=1/7)
   DEFINE l_sfb01_old  LIKE sfb_file.sfb01
   DEFINE l_cnt        LIKE type_file.num5      #No.FUN-680122 SMALLINT
   DEFINE l_wip_qty    LIKE shb_file.shb111
   DEFINE l_sql        STRING        #FUN-7C0028 add
 
   IF g_bgjob = 'N' THEN             #FUN-570153
      MESSAGE '_work ...'
      CALL ui.Interface.refresh()
   END IF
 
   DELETE FROM cxy_file WHERE 1=1 #只為foreach中同一工單否判斷用
 
   LET l_sfb01_old=' '
   DECLARE work_c11 CURSOR FOR
      SELECT *
        FROM sfb_file,ecm_file
       WHERE sfb05 =g_ima01                     #但未投入工時
         AND sfb93 ='Y'
         AND sfb01 =ecm01
         AND sfb02 !='13' AND sfb02 != '11'
         AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N')
         AND (sfb38 IS NULL OR sfb38 >= g_bdate)  # 工單成會結案日
         AND (sfb81 IS NULL OR sfb81 <= g_edate)  # 工單開立日期
       ORDER BY sfb01,ecm012,ecm03  #FUN-A60095
   LET g_sfb01_old2=' '
   LET g_sfb01_old3=' '
   LET g_cxh22b=0  LET g_cxh22c=0
   FOREACH work_c11 INTO g_sfb.*,g_ecm.*
     LET ii=ii+1
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','work_c11',SQLCA.sqlcode,0)  #No.FUN-710027
        EXIT FOREACH
     END IF
 
     INITIALIZE g_caf.* TO NULL
     SELECT * INTO g_caf.* FROM caf_file
      WHERE caf05=g_ecm.ecm03
        AND caf01=g_sfb.sfb01 
        AND caf_file.caf02=yy 
        AND caf_file.caf03=mm
        AND caf012=g_ecm.ecm012 #FUN-A60095
 
     CALL work_get_cxh()  # WIP-製程元件部份 成本
 
     SELECT COUNT(*) INTO g_cnt FROM cxy_file WHERE cxy01=g_sfb.sfb01
     IF g_cnt=0 THEN
        CALL work_del3()
        CALL work_1('1')       #WIP-主件部份 成本 (ccg20/ccg31)
        CALL work_ccg21('1')   #主件投入數量
        CALL work_1_1()        #取得最後一站製程序
       #INSERT INTO cxy_file VALUES(g_sfb.sfb01,g_plant,g_legal) #FUN-980009 add g_plant,g_legal    #FUN-A50075
       INSERT INTO cxy_file VALUES(g_sfb.sfb01,g_legal)     #FUN-A50075
     END IF
     CALL work_ccg21('1')   #主件投入數量
     CALL work_2()       # 計算每張工單的 WIP-元件 投入 成本 (cxh)
     LET g_sfb01_old3=g_sfb.sfb01
     CALL work_3()       # 計算每張工單的 WIP-元件 轉出 成本 (cxh)
   END FOREACH
 
   LET ii=0
   DELETE FROM cxy_file WHERE 1=1
   LET l_sql="SELECT * FROM sfb_file",
             " WHERE sfb05 ='",g_ima01,"'",
             "   AND sfb93 = 'Y'",
             "   AND sfb02!= '13' AND sfb02 != '11'",
             "   AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='N')",
             "   AND (sfb38 IS NULL OR sfb38 >='",g_bdate,"')",  # 工單成會結案日
             "   AND (sfb81 IS NULL OR sfb81 <='",g_edate,"')"   # 工單xx立日期
   IF type = '4' THEN   #個別認定-專案成本
      LET l_sql=l_sql,"   AND sfb27='",g_tlfcost,"'"
   END IF
   LET l_sql=l_sql," ORDER BY sfb01"
   DECLARE work_c11_1 CURSOR FROM l_sql
 
   LET g_sfb01_old2=' '
   LET g_sfb01_old3=' '
   INITIALIZE g_ecm.* TO NULL
   FOREACH work_c11_1 INTO g_sfb.*
     LET ii=ii+1
     CALL work_1_1()      # 取得最後一站製程序
     ##資料抓出來重新處理------------------------
     SELECT COUNT(*) INTO g_cnt FROM cxy_file WHERE cxy01=g_sfb.sfb01
     IF g_cnt=0 THEN
        CALL work_1('2')
        CALL work_ccg21('2') # 主件投入數量
        DECLARE work_2_22_c CURSOR FOR
        SELECT * FROM ecm_file
         WHERE ecm01 = g_sfb.sfb01
         ORDER BY ecm012,ecm03 #FUN-A60095
        FOREACH work_2_22_c INTO g_ecm.*
           CALL work_2_22_3()
        END FOREACH
       #INSERT INTO cxy_file VALUES(g_sfb.sfb01,g_plant,g_legal) #FUN-980009 add g_plant,g_legal   #FUN-A50075 mark
        INSERT INTO cxy_file VALUES(g_sfb.sfb01,g_legal)         #FUN-A50075
     END IF
     CALL work_4()        # 計算每張工單的 WIP-元件 SUM  成本 (cch)
     CALL work_41()       # 計算每張工單的 當站入庫轉出  #FUN-660142 add
     CALL work_5()        # 計算每張工單的 WIP-主件 SUM  成本 (ccg)
   END FOREACH
   CLOSE work_c11_1
END FUNCTION
 
FUNCTION chk_cxh22()   #檢查人工/製費分攤後有沒有尾差,有的話,調在隨便一筆
   DEFINE l_sql   STRING
   DEFINE l_cxh011   LIKE cxh_file.cxh011   #成本中心編號
   DEFINE l_cxh22b   LIKE cxh_file.cxh22b   #人工
   DEFINE l_cxh22c   LIKE cxh_file.cxh22c   #製費一 
   DEFINE l_cxh22e   LIKE cxh_file.cxh22e   #製費二   #FUN-7C0028 add
   DEFINE l_cxh22f   LIKE cxh_file.cxh22f   #製費三   #FUN-7C0028 add
   DEFINE l_cxh22g   LIKE cxh_file.cxh22g   #製費四   #FUN-7C0028 add
   DEFINE l_cxh22h   LIKE cxh_file.cxh22h   #製費五   #FUN-7C0028 add
   DEFINE l_cae05    LIKE cae_file.cae05    #成本
   DEFINE l_cxh      RECORD LIKE cxh_file.*
   DEFINE l_cae041   LIKE cae_file.cae041   #CHI-970021
 
   #先將這次計算範圍內的人工/製費金額SUM起來
   LET l_sql="SELECT cxh011,SUM(cxh22b),SUM(cxh22c)",
             "             ,SUM(cxh22e),SUM(cxh22f)",   #FUN-7C0028 add
             "             ,SUM(cxh22g),SUM(cxh22h)",   #FUN-7C0028 add
             "  FROM cxh_file,ccg_file,ima_file",
             " WHERE cxh02=",yy,
             "   AND cxh03=",mm,
             "   AND cxh06='",type,"'",        #FUN-7C0028 add
             "   AND cxh07='",g_tlfcost,"'",   #FUN-7C0028 add
             "   AND cxh01=ccg01 AND cxh02=ccg02 AND cxh03=ccg03",
             "   AND cxh06=ccg06 AND cxh07=ccg07 ",   #FUN-7C0028 add
             "   AND ccg04=ima01",
             "   AND ",g_wc CLIPPED,
             " GROUP BY cxh011",
             " ORDER BY cxh011"
   PREPARE chk_cxh22_pre FROM l_sql
   DECLARE chk_cxh22_cur CURSOR FOR chk_cxh22_pre
   FOREACH chk_cxh22_cur INTO l_cxh011,l_cxh22b,l_cxh22c
                             ,l_cxh22e,l_cxh22f,l_cxh22g,l_cxh22h   #FUN-7C0028 add
      IF l_cxh22b!=0 OR l_cxh22c!=0 
                     OR l_cxh22e!=0 OR l_cxh22f!=0 OR l_cxh22g!=0 OR l_cxh22h!=0 THEN   #FUN-7C0028 add
         #抓取"每月人工/製費檔"裡,各個成本中心的總成本
         LET l_sql="SELECT cae041,SUM(cae05)",     #CHI-970021
                   "  FROM cae_file  #,caa_file",  #CHI-970021
                   " WHERE cae01=",yy,   #CHI-970021
                   "   AND cae02=",mm,
                   "   AND cae03='",l_cxh011,"'",
                   " GROUP BY cae041",    #CHI-970021
                   " ORDER BY cae041"     #CHI-970021
         PREPARE chk_cxh22_p1 FROM l_sql
         DECLARE chk_cxh22_c1 CURSOR FOR chk_cxh22_p1
         FOREACH chk_cxh22_c1 INTO l_cae041,l_cae05  #CHI-970021
            CASE l_cae041   #CHI-970021
              WHEN '1'   #人工
                IF l_cxh22b != l_cae05 THEN
                   #隨便抓一筆將差異金額調進去
                   LET l_sql="SELECT * FROM cxh_file",
                             " WHERE cxh011='",l_cxh011,"'",
                             "   AND cxh02 =",yy,
                             "   AND cxh03 =",mm,
                             "   AND cxh06 ='",type,"'",       #FUN-7C0028 add
                             "   AND cxh07 ='",g_tlfcost,"'",  #FUN-7C0028 add
                             "   AND cxh22b!=0",
                             " ORDER BY cxh01,cxh013,cxh014,cxh012,cxh04" #FUN-A60095
                   PREPARE chk_cxh22_p1_1 FROM l_sql
                   DECLARE chk_cxh22_c1_1 CURSOR FOR chk_cxh22_p1_1
                   OPEN chk_cxh22_c1_1
                   FETCH chk_cxh22_c1_1 INTO l_cxh.*
                   UPDATE cxh_file SET cxh22b=cxh22b+(l_cae05-l_cxh22b),
                                       cxh22 =cxh22 +(l_cae05-l_cxh22b),
                                       cxh52b=cxh52b+(l_cae05-l_cxh22b),
                                       cxh52 =cxh52 +(l_cae05-l_cxh22b),
                                       cxh92b=cxh92b+(l_cae05-l_cxh22b),
                                       cxh92 =cxh92 +(l_cae05-l_cxh22b) 
                    WHERE cxh01 =l_cxh.cxh01
                      AND cxh011=l_cxh.cxh011 AND cxh012=l_cxh.cxh012
                      AND cxh02 =l_cxh.cxh02  AND cxh03 =l_cxh.cxh03
                      AND cxh04 =l_cxh.cxh04
                      AND cxh06 =l_cxh.cxh06  AND cxh07 =l_cxh.cxh07   #FUN-7C0028 add
                      AND cxh013=l_cxh.cxh013 AND cxh014=l_cxh.cxh014  #FUN-A60095
                   IF SQLCA.sqlerrd[3]=0 THEN 
                      LET g_showmsg=l_cxh.cxh01,"/",l_cxh.cxh02                                        #No.FUN-710027
                      CALL s_errmsg('cxh01,cxh02',g_showmsg,'upd cxh22b',STATUS,1)                     #No.FUN-710027 
                   END IF
                END IF
              OTHERWISE    #製費1-5   #NO.CHI-940027
                IF l_cxh22c != l_cae05 THEN
                   #隨便抓一筆將差異金額調進去
                   LET l_sql="SELECT * FROM cxh_file",
                             " WHERE cxh011='",l_cxh011,"'",
                             "   AND cxh02 =",yy,
                             "   AND cxh03 =",mm,
                             "   AND cxh06 ='",type,"'",       #FUN-7C0028 add
                             "   AND cxh07 ='",g_tlfcost,"'",  #FUN-7C0028 add
                             "   AND cxh22c!=0",
                             " ORDER BY cxh01,cxh013,cxh014,cxh012,cxh04"  #FUN-A60095
                   PREPARE chk_cxh22_p1_2 FROM l_sql
                   DECLARE chk_cxh22_c1_2 CURSOR FOR chk_cxh22_p1_2
                   OPEN chk_cxh22_c1_2
                   FETCH chk_cxh22_c1_2 INTO l_cxh.*
                   UPDATE cxh_file SET cxh22c=cxh22c+(l_cae05-l_cxh22c),
                                       cxh22 =cxh22 +(l_cae05-l_cxh22c),
                                       cxh52c=cxh52c+(l_cae05-l_cxh22c),
                                       cxh52 =cxh52 +(l_cae05-l_cxh22c),
                                       cxh92c=cxh92c+(l_cae05-l_cxh22c),
                                       cxh92 =cxh92 +(l_cae05-l_cxh22c) 
                    WHERE cxh01 =l_cxh.cxh01
                      AND cxh011=l_cxh.cxh011 AND cxh012=l_cxh.cxh012
                      AND cxh02 =l_cxh.cxh02  AND cxh03 =l_cxh.cxh03
                      AND cxh04 =l_cxh.cxh04
                      AND cxh06 =l_cxh.cxh06  AND cxh07 =l_cxh.cxh07   #FUN-7C0028 add
                      AND cxh013=l_cxh.cxh013 AND cxh014=l_cxh.cxh014  #FUN-A60095
                   IF SQLCA.sqlerrd[3]=0 THEN 
                      LET g_showmsg=l_cxh.cxh01,"/",l_cxh.cxh02                                        #No.FUN-710027
                      CALL s_errmsg('cxh01,cxh02',g_showmsg,'upd cxh22c',STATUS,1)                     #No.FUN-710027 
                   END IF
                END IF
            END CASE
         END FOREACH
      END IF
   END FOREACH
 
END FUNCTION
 
FUNCTION dl_oh_check()
  DEFINE l_cxz01   LIKE cxz_file.cxz01
  DEFINE l_cxz02   LIKE cxz_file.cxz02
  DEFINE l_cxz03   LIKE cxz_file.cxz03
  DEFINE l_cxz04   LIKE cxz_file.cxz04
  DEFINE l_cxz05   LIKE cxz_file.cxz05
  DEFINE l_cxz06   LIKE cxz_file.cxz06
  DEFINE l_cxz07   LIKE cxz_file.cxz07
  DEFINE l_cae06_1 LIKE cae_file.cae06
  DEFINE l_cae06_2 LIKE cae_file.cae06
  DEFINE l_chr     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
  DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(300)
  DEFINE l_diff1,l_diff2,dl_t,oh_t LIKE ccc_file.ccc21
 
   LET l_sql="SELECT cxz01 FROM cxz_file WHERE cxz02=? AND cxz03=? " CLIPPED
   PREPARE any_wo_cur_pre FROM l_sql
   DECLARE any_wo_cur CURSOR FOR any_wo_cur_pre
 
   LET l_sql="SELECT SUM(cae05) FROM cae_file ",           #CHI-970021
             " WHERE cae01=",yy," AND cae02=",mm,
             "   AND cae041=? AND cae03=? AND cae04= ? "  CLIPPED  #CHI-970021 caa04-->cae041
   PREPARE dl_oh_check_pre FROM l_sql
   DECLARE dl_oh_check_cur CURSOR FOR dl_oh_check_pre
 
   DECLARE work_wo_cur CURSOR FOR
     SELECT cxz02,cxz03,SUM(cxz04),SUM(cxz05),SUM(cxz06),SUM(cxz07)
       FROM cxz_file
      GROUP BY cxz02,cxz03
      ORDER BY cxz02,cxz03
   LET dl_t=0  LET oh_t=0
   FOREACH work_wo_cur INTO l_cxz02,l_cxz03,l_cxz04,l_cxz05,l_cxz06,l_cxz07
     IF STATUS THEN CALL cl_err('work_wo_for',STATUS,0) EXIT FOREACH END IF
    #此段為避免只重計某個料號時用.
    #若投入指標總數不等與total wo 就不管尾差的問題了
     SELECT SUM(cae06) INTO l_cae06_1 #人工總指標總數
       FROM cae_file  #,caa_file   #CHI-970021
      WHERE cae01=yy AND cae02=mm
        AND cae03=l_cxz02 AND cae04=l_cxz03
        AND cae041='1'           #CHI-970021
     
     SELECT SUM(cae06) INTO l_cae06_2 #製費總指標總數
       FROM cae_file #,caa_file  #CHI-970021
      WHERE cae01=yy ANd cae02=mm
        AND cae03=l_cxz02 AND cae04=l_cxz03
        AND cae041<>'1'       #NO.CHI-940027#CHI-970021 a04-->e041
     
     IF l_cae06_1 IS NULL THEN LET l_cae06_1=0 END IF
     IF l_cae06_2 IS NULL THEN LET l_cae06_2=0 END IF
     IF l_cae06_1 !=l_cxz06 THEN CONTINUE FOREACH END IF
     IF l_cae06_2 !=l_cxz07 THEN CONTINUE FOREACH END IF
 
     LET l_chr='1'
     OPEN dl_oh_check_cur USING l_chr,l_cxz02,l_cxz03
     FETCH dl_oh_check_cur INTO dl_t
      LET l_sql = "SELECT SUM(cae05) FROM cae_file ",           #CHI-970021
                  " WHERE cae01 = ",yy," AND cae02 =",mm,
                  " AND cae041 <> '1' AND cae03 = '",l_cxz02,"' AND cae04 = '",l_cxz03 CLIPPED,"'" #CHI-970021 a04-->e041
      PREPARE d1_oh_check_pre_1 FROM l_sql
      DECLARE d1_oh_check_cur_1 CURSOR FOR d1_oh_check_pre_1
      OPEN d1_oh_check_cur_1
      FETCH d1_oh_check_cur_1 INTO oh_t
      CLOSE d1_oh_check_cur_1         
     IF dl_t IS NULL THEN LET dl_t=0 END IF
     IF oh_t IS NULL THEN LET oh_t=0 END IF
 
     IF (l_cxz04=dl_t and l_cxz05=oh_t) THEN CONTINUE FOREACH END IF
 
     IF l_cxz04 !=dl_t THEN LET l_diff1=dl_t-l_cxz04 END IF
     IF l_cxz05 !=oh_t THEN LET l_diff2=oh_t-l_cxz05 END IF
 
     IF cl_null(l_diff1) THEN LET l_diff1 = 0 END IF   #TQC-6B0092 add
     IF cl_null(l_diff2) THEN LET l_diff2 = 0 END IF   #TQC-6B0092 add
 
     IF l_diff1 <0 THEN
        #此情況異常,表示攤到工單的總金額大於該成本項目總可攤金額
        LET t_time = TIME
        LET g_time=t_time
        LET g_msg=''
        LET g_msg='攤到工單',l_cxz01,'的總人工金額',dl_t using '######&.#&',
                  '大於該成本項目',l_cxz03,'總可攤人工金額',
                                                 l_cxz04 using '######&.#&'
       #FUN-A50075--mod--str-- ccy_file del plant&legal
       #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
       #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
        INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      VALUES(TODAY,g_time,g_user,g_msg)
       #FUN-A50075--mod--end
     END IF
     IF l_diff2 <0 THEN
        LET t_time = TIME
        LET g_time=t_time
        LET g_msg=''
        LET g_msg='攤到工單',l_cxz01,'的總製費金額',oh_t using '########&.#&',
                  '大於該成本項目',l_cxz03,'總可攤製費金額',
                                                 l_cxz05 using '########&.#&'
       #FUN-A50075--mod--str-- ccy_file del plant&legal
       #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
       #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
        INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      VALUES(TODAY,g_time,g_user,g_msg)
       #FUN-A50075--mod--end
     END IF
     OPEN any_wo_cur USING l_cxz02,l_cxz03
     FETCH any_wo_cur INTO l_cxz01
     UPDATE cxz_file SET cxz04=cxz04+l_diff1,cxz05=cxz05+l_diff2
      WHERE cxz01=l_cxz01 and cxz02=l_cxz02 and cxz03=l_cxz03
     IF SQLCA.sqlerrd[3]=0 THEN 
      CALL cl_err3("upd","cxz_file",l_cxz01,l_cxz02,STATUS,"","upd cxz04/cxz05",0)   #No.FUN-660127
     END IF
   END FOREACH
   CLOSE any_wo_cur
END FUNCTION
 
FUNCTION dl_oh_ins_cai()
   DEFINE l_cxz01  LIKE cxz_file.cxz01
   DEFINE l_cxz02  LIKE cxz_file.cxz02
   DEFINE l_cxz03  LIKE cxz_file.cxz03
   DEFINE l_sfb05  LIKE sfb_file.sfb05
   DEFINE l_sum   LIKE type_file.num20_6       #No.FUN-680122 DEC(20,6)           #MOD-4C0005
   DEFINE l_cai   RECORD LIKE cai_file.*              #FUN-980009 add
   DEFINE l_cxz08  LIKE cxz_file.cxz08                #FUN-980009 add
  
 
  DECLARE dl_oh_ins_cai_cur CURSOR FOR
    SELECT cxz01,cxz02,cxz03,cxz08,SUM(cxz04+cxz05) #FUN-980009 add cxz08
      FROM cxz_file  #WHERE cxz01=sfb01
      GROUP BY cxz01,cxz02,cxz03,cxz08  #FUN-980009 add cxz08
  FOREACH dl_oh_ins_cai_cur INTO l_cxz01,l_cxz02,l_cxz03,l_cxz08,l_sum #FUN-980009 add cxz08
     SELECT sfb05 INTO l_sfb05 FROM sfb_file WHERE sfb01=l_cxz01
 
     LET l_cai.cai01 = l_cxz01 
     LET l_cai.cai02 = yy
     LET l_cai.cai03 = mm
     LET l_cai.cai04 = l_sfb05
     LET l_cai.cai05 = l_cxz02 
     LET l_cai.cai06 = l_cxz03 
     LET l_cai.cai07 = l_sum
     LET l_cai.cai08 = l_cxz08 
    #LET l_cai.caiplant = g_plant     #FUN-A50075 
     LET l_cai.cailegal = g_legal 
     INSERT INTO cai_file VALUES(l_cai.*)
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
        UPDATE cai_file SET cai07=l_sum
         WHERE cai01=l_cxz01 AND cai02=yy AND cai03=mm AND cai04=l_sfb05
           AND cai05=l_cxz02 AND cai06=l_cxz03
        IF STATUS <0 THEN 
         CALL cl_err3("upd","cai_file",l_cxz01,yy,SQLCA.SQLCODE,"","UPD cai",0)   #No.FUN-660127
        EXIT FOREACH END IF
     ELSE
        IF SQLCA.SQLCODE <0 THEN 
           CALL cl_err('UPD cai',SQLCA.SQLCODE,0) EXIT FOREACH 
        END IF
     END IF
  END FOREACH
END FUNCTION
 
FUNCTION p510_dec_cur1()
 
  LET g_sql=" SELECT SUM(ecb19),SUM(ecb21) FROM ecb_file ",
            "   WHERE ecb08= ? " CLIPPED  #成本中心
  PREPARE ecb_pre FROM g_sql
  DECLARE ecb_cur CURSOR WITH HOLD FOR ecb_pre
END FUNCTION
 
FUNCTION work_1_1()
   #取得最後一站製程序
   LET ecm03_max=''   #FUN-A60095
  #LET ecm04_max=' '  #FUN-A60095 mark
   LET ecm012_max=' ' #FUN-A60095
   #FUN-A60095(S)
   CALL s_schdat_max_ecm03(g_sfb.sfb01) RETURNING ecm03_max,ecm012_max
  #SELECT ecm03,ecm04 INTO ecm03_max,ecm04_max FROM ecm_file
  # WHERE ecm01=g_sfb.sfb01
  #   AND ecm03=(SELECT MAX(ecm03) FROM ecm_file WHERE ecm01=g_sfb.sfb01)
   #FUN-A60095(E)
   IF STATUS THEN 
      CALL s_errmsg('ecm01',g_sfb.sfb01,'sel ecm03_max',STATUS,1)                                  #No.FUN-710027 
   END IF

   #取得第一站製程序
   LET ecm03_min=''   #FUN-A60095
  #LET ecm04_min=' '  #FUN-A60095 mark
   LET ecm012_min=' ' #FUN-A60095
   #FUN-A60095(S)
   CALL s_schdat_min_ecm03(g_sfb.sfb01) RETURNING ecm03_min,ecm012_min
  #SELECT ecm03,ecm04 INTO ecm03_min,ecm04_min FROM ecm_file
  # WHERE ecm01=g_sfb.sfb01
  #   AND ecm03=(SELECT MIN(ecm03) FROM ecm_file WHERE ecm01=g_sfb.sfb01)
   #FUN-A60095(E)
   IF STATUS THEN 
      CALL s_errmsg('ecm01',g_sfb.sfb01,'sel ecm03_minx',STATUS,1)                                   #No.FUN-710027 
   END IF
   LET first_cal_ecm03=''    #FUN-A60095
  #LET first_cal_ecm04=' '   #FUN-A60095 mark
   LET first_cal_ecm012=' '  #FUN-A60095

   SELECT DISTINCT caf05,caf012  #FUN-A60095
     INTO first_cal_ecm03,first_cal_ecm012  #FUN-A60095
     FROM caf_file
    WHERE caf01=g_sfb.sfb01 AND caf02=yy AND caf03=mm
      AND caftime=(SELECT MIN(caftime) FROM caf_file
                    WHERE caf01=g_sfb.sfb01 AND caf02=yy AND caf03=mm)
   IF STATUS !=100 AND STATUS THEN
      LET g_showmsg=g_sfb.sfb01,"/",yy                                                                   #No.FUN-710027
      CALL s_errmsg('caf01,cag02',g_showmsg,'sel first_cal_ecm03',STATUS,1)                              #No.FUN-710027
   ELSE
     #僅有投入材料,並未投入人工/製費
   END IF
 
END FUNCTION
 
#先把成本項目全攤完到每一張工單,再SUM(人工)/SUM(製費)與axct300比較,
#若不平,則自動將尾數攤入其中一筆工單做尾差歸屬
FUNCTION work_wo_dl_oh()
  DEFINE dl_t        LIKE cxz_file.cxz04
  DEFINE oh_t        LIKE cxz_file.cxz05
  DEFINE cam08_sum   LIKE cam_file.cam08          #No.FUN-680122 DEC(15,5)
 #DEFINE cam07_sum   LIKE type_file.num10         #No.FUN-680122 INT  #FUN-A90065 mark no use
  DEFINE l_index_dl  LIKE cxz_file.cxz06
  DEFINE l_index_oh  LIKE cxz_file.cxz07
  DEFINE l_qty       LIKE type_file.num10         #No.FUN-680122 INT
  DEFINE l_caf01     LIKE caf_file.caf01
  DEFINE l_caf05     LIKE caf_file.caf05
  DEFINE l_caf06     LIKE caf_file.caf06
  DEFINE l_ecb19     LIKE ecb_file.ecb19
  DEFINE l_ecb21     LIKE ecb_file.ecb21
  DEFINE l_cac03     LIKE cac_file.cac03
  DEFINE l_cak03     LIKE cak_file.cak03
  DEFINE l_cae03     LIKE cae_file.cae03
  DEFINE l_cae04     LIKE cae_file.cae04
  DEFINE l_cae05     LIKE cae_file.cae05
  DEFINE l_cae07     LIKE cae_file.cae07
  DEFINE l_cae08     LIKE cae_file.cae08
  DEFINE l_cae041    LIKE cae_file.cae041    #CHI-970021 a04-->e041
  DEFINE lr_cxz      RECORD LIKE cxz_file.*  #CHI-970021
  DEFINE l_cam01_b   LIKE cam_file.cam01     #FUN-A90065
  DEFINE l_cam01_e   LIKE cam_file.cam01     #FUN-A90065
  DEFINE l_correct   LIKE type_file.chr1     #CHI-9A0021 add
  DEFINE l_caf012    LIKE caf_file.caf012    #FUN-A60095
  
  CALL p510_dec_cur1()

 #當月起始日與截止日              
  CALL s_azm(yy,mm) RETURNING l_correct,l_cam01_b,l_cam01_e   #CHI-9A0021 add  #FUN-A90065
 
  IF g_sfb.sfb93='Y' THEN
     LET g_sql=" SELECT cae03,cae04,cae05,cae07,cae041,cae08  ", #CHI-970021 a04-->e041
               " FROM cae_file ",             #CHI-970041
               " WHERE cae01='",yy,"' AND cae02='",mm,"' ",
               "   AND cae03=?  AND cae04=?  ",
               " ORDER BY cae041,cae08 " #CGI-970021
               
     PREPARE cae_pre_11 FROM g_sql
     DECLARE cae_cur_11 CURSOR FOR cae_pre_11
 
     LET dl_t=0  LET l_index_dl=0
     LET oh_t=0  LET l_index_oh=0
 
 
     CASE
       WHEN g_ccz.ccz06='1' OR g_ccz.ccz06='2' #年月/年月成本中心
         DECLARE work_cost_item_cur CURSOR FOR
          SELECT cak03 FROM cak_file
           WHERE cak01=(SELECT ima131 FROM ima_file WHERE ima01=g_sfb.sfb05)
             AND cak02=g_sfb.sfb98
         FOREACH work_cost_item_cur INTO l_cak03 #成本項目
            IF STATUS THEN 
               CALL s_errmsg('','','work_cost_item_cur',STATUS,0)  #No.FUN-710027         
               EXIT FOREACH
               LET g_success='N'
            END IF
            LET l_index_dl=0   #CHI-970021
            LET l_index_oh=0   #CHI-970021
            FOREACH cae_cur_11 USING g_sfb.sfb98,l_cak03   #TQC-7B0027
               INTO l_cae03,l_cae04,l_cae05,l_cae07,l_cae041,l_cae08  #CHI-970021 a04-->e041
               #    成本中心/成本項目/單位成本/成本分類/分攤方式 
               IF STATUS THEN 
                  CALL s_errmsg('','','cae_cur_11',STATUS,0)  #No.FUN-710027               
                  EXIT FOREACH  LET g_success='N'
               END IF
               LET dl_t=0 #CHI-970021
               LET oh_t=0 #CHI-970021
               #FUN-A90065(S)
               CALL p510_dis(g_sfb.sfb01,l_cam01_b,l_cam01_e, l_cae03,
                             l_cae041,l_cae07,l_cae08) 
                             RETURNING dl_t,oh_t
               #FUN-A90065(E)
               IF dl_t IS NULL THEN LET dl_t=0 END IF
               IF oh_t IS NULL THEN LET oh_t=0 END IF
               LET l_index_dl = l_index_dl + dl_t
               LET l_index_oh = l_index_oh + oh_t 
               LET lr_cxz.cxz01 = g_sfb.sfb01
               LET lr_cxz.cxz02 = l_cae03
               LET lr_cxz.cxz03 = l_cae04
               LET lr_cxz.cxz04 = dl_t
               LET lr_cxz.cxz05 = oh_t
               LET lr_cxz.cxz06 = l_index_dl
               LET lr_cxz.cxz07 = l_index_oh
               LET lr_cxz.cxz08 = l_cae041
              #LET lr_cxz.cxzplant = g_plant #FUN-980009 add     #FUN-A50075
               LET lr_cxz.cxzlegal = g_legal #FUN-980009 add
               INSERT INTO cxz_file VALUES(lr_cxz.*)
            END FOREACH
            IF l_index_dl > 0 OR l_index_oh > 0 THEN
               UPDATE cxz_file SET cxz06 = l_index_dl ,
                                   cxz07 = l_index_oh
                             WHERE cxz01 = g_sfb.sfb01
                               AND cxz02 = l_cae03
                               AND cxz03 = l_cae04
            END IF
         END FOREACH
       WHEN g_ccz.ccz06='3'            #年月作業編號
         DECLARE caf_cur2 CURSOR FOR
          SELECT caf01,caf05,caf06,caf012 FROM caf_file  #FUN-A60095
           WHERE caf01=g_sfb.sfb01
         FOREACH caf_cur2 INTO l_caf01,l_caf05,l_caf06,l_caf012 #每一成本中心  #FUN-A60095
            IF STATUS THEN 
               CALL s_errmsg('','','work_cost_item_cur',STATUS,1)      #No.FUN-710027
               EXIT FOREACH
               LET g_success='N'
            END IF
            DECLARE work_cost_item_cur2 CURSOR FOR
             SELECT cak03 FROM cak_file
              WHERE cak01=(SELECT ima131 FROM ima_file WHERE ima01=g_sfb.sfb05)
                AND cak02=l_caf06
            FOREACH work_cost_item_cur2 INTO l_cak03 #成本項目
               IF STATUS THEN 
                  CALL s_errmsg('','','work_cost_item_cur',STATUS,0)  #No.FUN-710027
                  EXIT FOREACH
                  LET g_success='N'
               END IF
               LET l_index_dl=0  #CHI-970021
               LET l_index_oh=0  #CHI-970021
               FOREACH cae_cur_11 USING l_caf06,l_cak03   #TQC-7B0027
                  INTO l_cae03,l_cae04,l_cae05,l_cae07,l_cae041,l_cae08  #CHI-970021 a04-->e041
                  #    成本中心/成本項目/單位成本/成本分類/分攤方式)
                  IF STATUS THEN 
                     CALL s_errmsg('','','cae_cur_11',STATUS,0)   #No.FUN-710027
                     EXIT FOREACH  
                     LET g_success='N'
                  END IF
                  LET dl_t=0  #CHI-970021
                  LET oh_t=0  #CHI-970021
                  #FUN-A90065(S)
                  CALL p510_dis(g_sfb.sfb01,l_cam01_b,l_cam01_e, l_cae03,
                                l_cae041,l_cae07,l_cae08) 
                                RETURNING dl_t,oh_t
                  #FUN-A90065(E)
                  IF dl_t IS NULL THEN LET dl_t=0 END IF
                  IF oh_t IS NULL THEN LET oh_t=0 END IF
                  LET l_index_dl = l_index_dl + dl_t
                  LET l_index_oh = l_index_oh + oh_t 
                  LET lr_cxz.cxz01 = g_sfb.sfb01
                  LET lr_cxz.cxz02 = l_cae03
                  LET lr_cxz.cxz03 = l_cae04
                  LET lr_cxz.cxz04 = dl_t
                  LET lr_cxz.cxz05 = oh_t
                  LET lr_cxz.cxz06 = l_index_dl
                  LET lr_cxz.cxz07 = l_index_oh
                  LET lr_cxz.cxz08 = l_cae041
                  LET lr_cxz.cxz08 = l_cae041
                 #LET lr_cxz.cxzplant = g_plant #FUN-980009 add    #FUN-A50075
                  LET lr_cxz.cxzlegal = g_legal #FUN-980009 add
                  INSERT INTO cxz_file VALUES(lr_cxz.*)
               END FOREACH     #同一成本項目不同分攤方式->此情況應不存在->預防用
               IF l_index_dl > 0 OR l_index_oh > 0 THEN
                  UPDATE cxz_file SET cxz06 = l_index_dl ,
                                      cxz07 = l_index_oh
                                WHERE cxz01 = g_sfb.sfb01
                                  AND cxz02 = l_cae03
                                  AND cxz03 = l_cae04
               END IF
            END FOREACH  #成本項目
         END FOREACH #成本中心
       WHEN g_ccz.ccz06='4'            #年月工作中心
         DECLARE caf_cur3 CURSOR FOR
          SELECT UNIQUE(ecm06) FROM caf_file,ecm_file
           WHERE caf01=g_sfb.sfb01 AND caf01=ecm01
             AND caf05=ecm03 AND caf06=ecm04
             AND caf012=ecm012  #FUN-A60095
         FOREACH caf_cur3 INTO l_cae03       #每一成本中心
            IF STATUS THEN 
               CALL s_errmsg('','','work_cost_item_cur',STATUS,0)    #No.FUN-710027
               EXIT FOREACH
               LET g_success='N'
            END IF
            DECLARE work_cost_item_cur3 CURSOR FOR
             SELECT cak03 FROM cak_file
              WHERE cak01=(SELECT ima131 FROM ima_file WHERE ima01=g_sfb.sfb05)
                AND cak02=l_cae03
            FOREACH work_cost_item_cur3 INTO l_cak03 #成本項目
               IF STATUS THEN 
                  CALL s_errmsg('','','work_cost_item_cur',STATUS,0)   #No.FUN-710027
                  EXIT FOREACH
                  LET g_success='N'
               END IF
               LET l_index_dl=0  LET l_index_oh=0
               FOREACH cae_cur_11 USING l_cae03,l_cak03   #TQC-7B0027
                  INTO l_cae03,l_cae04,l_cae05,l_cae07,l_cae041,l_cae08 #CHI-970021
                  #    成本中心/成本項目/單位成本/成本分類/分攤方式)
                  IF STATUS THEN 
                     CALL s_errmsg('','','cae_cur_11',STATUS,0)        #No.FUN-710027
                     EXIT FOREACH 
                     LET g_success='N'
                  END IF
                  LET dl_t=0  LET oh_t=0 #CHI-970021
                  #FUN-A90065(S)
                  CALL p510_dis(g_sfb.sfb01,l_cam01_b,l_cam01_e, l_cae03,
                                l_cae041,l_cae07,l_cae08) 
                                RETURNING dl_t,oh_t
                  #FUN-A90065(E)
                  IF dl_t IS NULL THEN LET dl_t=0 END IF
                  IF oh_t IS NULL THEN LET oh_t=0 END IF
                  LET l_index_dl = l_index_dl + dl_t
                  LET l_index_oh = l_index_oh + oh_t 
                  LET lr_cxz.cxz01 = g_sfb.sfb01
                  LET lr_cxz.cxz02 = l_cae03
                  LET lr_cxz.cxz03 = l_cae04
                  LET lr_cxz.cxz04 = dl_t
                  LET lr_cxz.cxz05 = oh_t
                  LET lr_cxz.cxz06 = l_index_dl
                  LET lr_cxz.cxz07 = l_index_oh
                  LET lr_cxz.cxz08 = l_cae041
                 #LET lr_cxz.cxzplant = g_plant #FUN-980009 add     #FUN-A50075
                  LET lr_cxz.cxzlegal = g_legal #FUN-980009 add
                  INSERT INTO cxz_file VALUES(lr_cxz.*)
               END FOREACH
               IF l_index_dl > 0 OR l_index_oh > 0 THEN
                  UPDATE cxz_file SET cxz06 = l_index_dl ,
                                      cxz07 = l_index_oh
                                WHERE cxz01 = g_sfb.sfb01
                                  AND cxz02 = l_cae03
                                  AND cxz03 = l_cae04
               END IF
            END FOREACH  #成本項目
         END FOREACH #成本中心
      EXIT CASE
     END CASE
  END IF
 
  IF g_sfb.sfb93='N' THEN  #不走製程
     LET g_sql=" SELECT cae03,cae04,cae05,cae07,cae041,cae08  ", #CHI-970021 a04==>e041
               " FROM cae_file ",            #CHI-970021
               " WHERE cae01='",yy,"' AND cae02='",mm,"' ",
               "   AND cae03=?  AND cae04=?  ",
               " ORDER BY cae041,cae08" #CHI-970021
     PREPARE cae_pre_12 FROM g_sql
     DECLARE cae_cur_12 CURSOR FOR cae_pre_12
 
     LET dl_t=0  LET l_index_dl=0
     LET oh_t=0  LET l_index_oh=0
     CASE
        WHEN g_ccz.ccz06='1' OR g_ccz.ccz06='2'  #年月/年月成本中心
           DECLARE work_cost_item_cur4 CURSOR FOR
            SELECT cak03 FROM cak_file
             WHERE cak01=(SELECT ima131 FROM ima_file WHERE ima01=g_sfb.sfb05)
               AND cak02=g_sfb.sfb98
           FOREACH work_cost_item_cur4 INTO l_cak03 #成本項目
              IF STATUS THEN 
                 CALL s_errmsg ('','','work_cost_item_cur',STATUS,0)      #No.FUN-710027
                 EXIT FOREACH
                 LET g_success='N'
              END IF
              LET l_index_dl=0 #CHI-970021
              LET l_index_oh=0 #CHI-970021
              FOREACH cae_cur_12 USING g_sfb.sfb98,l_cak03   #TQC-7B0027
                 INTO l_cae03,l_cae04,l_cae05,l_cae07,l_cae041,l_cae08 #CHI-970021 a04-->e041
                     #成本中心/成本項目/單位成本/成本分類/分攤方式)
                 IF STATUS THEN 
                    CALL s_errmsg('','','cae_cur_11',STATUS,0)  #No.FUN-710027 
                    EXIT FOREACH  LET g_success='N'
                 END IF
                 LET dl_t=0 #CHI-970021
                 LET oh_t=0 #CHI-970021
                 #FUN-A90065(S)
                 CALL p510_dis(g_sfb.sfb01,l_cam01_b,l_cam01_e, l_cae03,
                               l_cae041,l_cae07,l_cae08) 
                               RETURNING dl_t,oh_t
                 #FUN-A90065(E)
                 IF dl_t IS NULL THEN LET dl_t=0 END IF
                 IF oh_t IS NULL THEN LET oh_t=0 END IF
                 LET l_index_dl = l_index_dl + dl_t
                 LET l_index_oh = l_index_oh + oh_t 
                 LET lr_cxz.cxz01 = g_sfb.sfb01
                 LET lr_cxz.cxz02 = l_cae03
                 LET lr_cxz.cxz03 = l_cae04
                 LET lr_cxz.cxz04 = dl_t
                 LET lr_cxz.cxz05 = oh_t
                 LET lr_cxz.cxz06 = l_index_dl
                 LET lr_cxz.cxz07 = l_index_oh
                 LET lr_cxz.cxz08 = l_cae041
                #LET lr_cxz.cxzplant = g_plant #FUN-980009 add   #FUN-A50075
                 LET lr_cxz.cxzlegal = g_legal #FUN-980009 add
                 INSERT INTO cxz_file VALUES(lr_cxz.*)
              END FOREACH
               IF l_index_dl > 0 OR l_index_oh > 0 THEN
                  UPDATE cxz_file SET cxz06 = l_index_dl ,
                                      cxz07 = l_index_oh
                                WHERE cxz01 = g_sfb.sfb01
                                  AND cxz02 = l_cae03
                                  AND cxz03 = l_cae04
              END IF
           END FOREACH
        EXIT CASE
     END CASE
  END IF
END FUNCTION
 
FUNCTION work_create_tmp()
 
  DROP TABLE tmp8_file
  IF STATUS =-206 THEN
     CREATE TEMP TABLE tmp8_file(
     p01  LIKE cxh_file.cxh01,
     p011 LIKE ima_file.ima01,
     p02  LIKE type_file.num5,  
     p03  LIKE cxh_file.cxh012,
     p04  LIKE cxh_file.cxh39,
     p05  LIKE cxh_file.cxh41,
     p06  LIKE cxh_file.cxh51,
     p07  LIKE cxh_file.cxh31,
     p08  LIKE cxh_file.cxh33,
     p09  LIKE cxh_file.cxh35,
     p10  LIKE cxh_file.cxh37);
  create unique index tmp8_01 on tmp8_file (p01,p02,p03);
  END IF
 
  DROP TABLE tmp10_file
  IF STATUS =-206 THEN
     CREATE TEMP TABLE tmp10_file
     ( p01  LIKE cxh_file.cxh01,
       p02  LIKE type_file.num5,  
       p03  LIKE cxh_file.cxh012,
       p04  LIKE cxh_file.cxh11,
       p05  LIKE type_file.num5,
       po13 LIKE cxh_file.cxh013,   #FUN-A60095 轉出製程段
       pi13 LIKE cxh_file.cxh013);  #FUN-A60095 轉入製程段
  END IF
 
  DROP TABLE tmp11_file
  IF STATUS =-206 THEN
     CREATE TEMP TABLE tmp11_file
     ( p01  LIKE cxh_file.cxh01,
       p02  LIKE type_file.num5,  
       p03  LIKE cxh_file.cxh012,
       p04  LIKE cxh_file.cxh11,
       p05  LIKE sfb_file.sfb01,
       p06  LIKE caf_file.caf05,
       p07  LIKE caf_file.caf06,
       po13 LIKE cxh_file.cxh013,   #FUN-A60095 轉出製程段
       pi13 LIKE cxh_file.cxh013);  #FUN-A60095 轉入製程段
  END IF
END FUNCTION
 
FUNCTION work_get_tmp8()
  DEFINE l_ecm01     LIKE ecm_file.ecm01,
         l_ecm03     LIKE ecm_file.ecm03,
         l_ecm04     LIKE ecm_file.ecm04,
         l_cam07     LIKE cam_file.cam07,
         g_cxh39     LIKE cxh_file.cxh39,
         g_cxh33     LIKE cxh_file.cxh33,
         g_cxh37     LIKE cxh_file.cxh37,
         g_cxh35     LIKE cxh_file.cxh35,
         shb113_tot  LIKE shb_file.shb113,
         l_shb12     LIKE shb_file.shb12,
         l_shb121    LIKE shb_file.shb121,  #FUN-A60095
         l_shb113    LIKE shb_file.shb113,
         l_cag01     LIKE cag_file.cag01,
         l_cag05     LIKE cag_file.cag05,
         l_cag06     LIKE cag_file.cag06,   #FUN-670016 add
         l_cag20     LIKE cag_file.cag20,
         cag20_tot   LIKE cag_file.cag20,
         caf11_tot   LIKE caf_file.caf11,
         caf12_tot   LIKE caf_file.caf12,
         caf13_tot   LIKE caf_file.caf13,
         caf16_tot   LIKE caf_file.caf16,
         caf18_tot   LIKE caf_file.caf18,
         caf17_tot   LIKE caf_file.caf17
  DEFINE l_bdate     LIKE type_file.dat   #CHI-9A0021 add
  DEFINE l_edate     LIKE type_file.dat   #CHI-9A0021 add
  DEFINE l_correct   LIKE type_file.chr1  #CHI-9A0021 add
  DEFINE l_cag012    LIKE cag_file.cag012 #FUN-A60095
    #當月起始日與截止日
    CALL s_azm(yy,mm) RETURNING l_correct,l_bdate,l_edate   #CHI-9A0021 add
 
    #--重流轉出--------------------------
    DECLARE shb_cur2 CURSOR FOR
      SELECT shb121,shb12,SUM(shb113) FROM shb_file  #FUN-A60095
       WHERE shb05=g_sfb.sfb01 AND shb06=g_caf.caf05
         AND shb012=g_caf.caf012  #FUN-A60095
         AND shb03 BETWEEN l_bdate AND l_edate   #CHI-9A0021
         AND shb113 > 0
         AND shbconf = 'Y'    #FUN-A70095
       GROUP BY shb121,shb12  #FUN-A60095
    LET shb113_tot=0
    FOREACH shb_cur2 INTO l_shb121,l_shb12,l_shb113  #FUN-A60095
       IF STATUS THEN 
          CALL s_errmsg('','','shb_for',STATUS,0)  #No.FUN-710027
          EXIT FOREACH 
       END IF
       INSERT INTO tmp10_file VALUES(g_caf.caf01,g_caf.caf05,g_caf.caf06,
                                     l_shb113,l_shb12,g_caf.caf012,l_shb121)  #FUN-A60095
       IF STATUS THEN 
          CALL s_errmsg('','','INS tmp10',STATUS,0)  #No.FUN-710027
          LET t_time = TIME
          LET g_time=t_time
          LET g_msg='' LET g_msg='INSERT INTO tmp10_file 產生錯誤!'
         #FUN-A50075--mod--str-- ccy_file del plant&legal
         #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
         #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
          INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                        VALUES(TODAY,g_time,g_user,g_msg)
         #FUN-A50075--mod--end
          EXIT FOREACH
       END IF
       LET shb113_tot=shb113_tot+l_shb113
    END FOREACH
 
    #--工單轉出----------------------------------
    DECLARE cag_cur CURSOR FOR
      SELECT cag01,cag012,cag05,cag06,SUM(cag20) FROM cag_file   #FUN-670016 add cag06  #FUN-A60095
       WHERE cag11=g_sfb.sfb01 AND cag15=g_caf.caf05 AND cag16=g_caf.caf06
         AND cag121=g_caf.caf012  #FUN-A60095
        GROUP BY cag01,cag012,cag05,cag06   #FUN-A60095
    LET cag20_tot=0
 
    FOREACH cag_cur INTO l_cag01,l_cag012,l_cag05,l_cag06,l_cag20  #FUN-670016 add l_cag06  #FUN-A60095
       IF STATUS THEN 
          CALL s_errmsg('','','cag_cur',STATUS,0)   #No.FUN-710027
          EXIT FOREACH 
       END IF
       IF l_cag20 IS NULL OR l_cag20=0 THEN CONTINUE FOREACH END IF
       INSERT INTO tmp11_file
            VALUES (g_caf.caf01,g_caf.caf05,g_caf.caf06,l_cag20, 
                    l_cag01,l_cag05,l_cag06,g_caf.caf012,l_cag012)   #FUN-670016 add l_cag06  #FUN-A60095
       IF STATUS THEN 
          CALL s_errmsg('','','INS tmp11',STATUS,0)   #No.FUN-710027
          LET t_time = TIME
          LET g_time=t_time
          LET g_msg='' LET g_msg='INSERT INTO tmp11_file 產生錯誤!'
         #FUN-A50075--mod--str-- ccy_file del plant&legal
         #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
         #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
          INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                        VALUES(TODAY,g_time,g_user,g_msg)
         #FUN-A50075--mod--end
          EXIT FOREACH
       END IF
       LET cag20_tot=cag20_tot+l_cag20
    END FOREACH
END FUNCTION
 
FUNCTION p510_wip_rework()      # 處理 WIP-Rework 在製成本 (重工sfb99='Y')
   DEFINE l_sql STRING   #FUN-7C0028 add
 
   IF g_bgjob = 'N' THEN             #FUN-570153
      MESSAGE '_wip_rework ...'
      CALL ui.Interface.refresh()
   END IF
   CALL wip_del2()      # 先 delete ccg_file, cch_file 該主件相關資料
   LET l_sql="SELECT * FROM sfb_file",
             " WHERE sfb05 ='",g_ima01,"'",
             "   AND sfb99 ='Y'",
             "   AND sfb93 ='N'",
             "   AND sfb02 != '13' AND sfb02 != '11'",
             "   AND (sfb38 IS NULL OR sfb38 >='",g_bdate,"')",  # 工單成會結案日
             "   AND (sfb81 IS NULL OR sfb81 <='",g_edate,"')"   # 工單xx立日期
   IF type = '4' THEN   #個別認定-專案成本
      LET l_sql=l_sql,"   AND sfb27='",g_tlfcost,"'"
   END IF
   LET l_sql=l_sql," ORDER BY sfb01"
   DECLARE p510_r_wip_c1 CURSOR FROM l_sql
 
   FOREACH p510_r_wip_c1 INTO g_sfb.*
      CALL wip_1()       # 計算每張工單的 WIP-主件 部份 成本 (ccg)
      CALL wip_2()       # 計算每張工單的 WIP-元件 投入 成本 (cch)
      CALL wip_3()       # 計算每張工單的 WIP-元件 轉出 成本 (cch)
      CALL wip_4()       # 計算每張工單的 WIP-主件 SUM  成本 (ccg)
   END FOREACH
   CLOSE p510_r_wip_c1
END FUNCTION
 
FUNCTION p510_work_rework()      # 處理 在製成本 (重工sfb99='Y')
   DEFINE l_sfb01_old LIKE sfb_file.sfb01
   DEFINE l_cnt       LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_wip_qty   LIKE shb_file.shb111
   DEFINE l_sql       STRING                       #FUN-7C0028 add
 
   IF g_bgjob = 'N' THEN             #FUN-570153
      MESSAGE '_work_rework ...'
      CALL ui.Interface.refresh()
   END IF
   CALL work_del2()      # 先 delete ccg_file, cch_file 該主件相關資料
 
 
   LET l_sfb01_old=' '
   DECLARE p510_rework_c11_0 CURSOR FOR
      SELECT *
        FROM sfb_file,ecm_file LEFT OUTER JOIN caf_file ON ecm01=caf01 AND caf02=yy AND caf03=mm 
                                                       AND ecm03=caf05 AND ecm012=caf012  #FUN-A60095
       WHERE sfb05 =g_ima01
         AND sfb99 = 'Y'   #FUN-660142 add
         AND sfb93 ='Y'
         AND sfb01=ecm01
        #AND ecm03=caf05  #FUN-A60095 mark
         AND sfb02 !='13' AND sfb02 != '11'
         AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='Y')
         AND (sfb38 IS NULL OR sfb38 >= g_bdate)  # 工單成會結案日
         AND (sfb81 IS NULL OR sfb81 <= g_edate)  # 工單開立日期
      #ORDER BY caf01,caf05   #,caftime #FUN-A60095 mark
       ORDER BY ecm01,ecm012,ecm03  #FUN-A60095
   LET g_sfb01_old2=' '
   LET g_sfb01_old3=' '
   LET l_sfb01_old=' '
   LET g_cxh22b=0  LET g_cxh22c=0
   LET g_cxh22e=0  LET g_cxh22f=0  LET g_cxh22g=0  LET g_cxh22h=0   #FUN-7C0028 add
   FOREACH p510_rework_c11_0 INTO g_sfb.*,g_ecm.*,g_caf.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('work_c11',SQLCA.sqlcode,0)
        EXIT FOREACH
     END IF
     CALL work_get_cxh()  # WIP-製程元件部份 成本
     SELECT COUNT(*) INTO g_cnt FROM cxy_file WHERE cxy01=g_sfb.sfb01
     IF g_cnt=0 THEN
        CALL work_del3()
        CALL work_1('1')       #WIP-主件部份 成本 (ccg20/ccg31)
        CALL work_ccg21('1')   #主件投入數量
        CALL work_1_1()        #取得最後一站製程序
       #INSERT INTO cxy_file VALUES(g_sfb.sfb01,g_plant,g_legal) #FUN-980009 add g_plant,g_legal   #FUN-A50075
        INSERT INTO cxy_file VALUES(g_sfb.sfb01,g_legal)         #FUN-A50075
     END IF
     CALL work_2()       # 計算每張工單的 WIP-元件 投入 成本 (cxh)
     CALL work_3()       # 計算每張工單的 WIP-元件 轉出 成本 (cxh)
   END FOREACH
 
   DELETE FROM cxy_file WHERE 1=1
   LET l_sql="SELECT * FROM sfb_file",
             " WHERE sfb05 ='",g_ima01,"'",
             "   AND sfb99 ='Y'",  #FUN-660142 add
             "   AND sfb93 ='Y'",
             "   AND sfb02 !='13' AND sfb02 != '11'",
             "   AND (sfb99 IS NULL OR sfb99 = ' ' OR sfb99='Y')",
             "   AND (sfb38 IS NULL OR sfb38 >='",g_bdate,"')",  # 工單成會結案日
             "   AND (sfb81 IS NULL OR sfb81 <='",g_edate,"')"   # 工單開立日期
   IF type = '4' THEN   #個別認定-專案成本
      LET l_sql=l_sql,"   AND sfb27='",g_tlfcost,"'"
   END IF
   LET l_sql=l_sql," ORDER BY sfb01"
   DECLARE p510_rework_c11_1 CURSOR FROM l_sql
 
   LET g_sfb01_old2=' '
   LET g_sfb01_old3=' '
   FOREACH p510_rework_c11_1 INTO g_sfb.*   #FUN-660142 modify
     ##資料抓出來重新處理
     SELECT COUNT(*) INTO g_cnt FROM cxy_file WHERE cxy01=g_sfb.sfb01
     IF g_cnt=0 THEN
       CALL work_1('2')
       CALL work_1_1()      # 取得最後一站製程序
       CALL work_ccg21('2') # 主件投入數量
       CALL work_2_22_2()
       CALL work_2_22_3()
      #INSERT INTO cxy_file VALUES(g_sfb.sfb01,g_plant,g_legal) #FUN-980009 add g_plant,g_legal     #FUN-A50075
       INSERT INTO cxy_file VALUES(g_sfb.sfb01,g_legal) #FUN-A50075
     END IF
     CALL work_4()        # 計算每張工單的 WIP-元件 SUM  成本 (cch)
     CALL work_5()        # 計算每張工單的 WIP-主件 SUM  成本 (ccg)
   END FOREACH
   CLOSE p510_rework_c11_1
END FUNCTION
 
FUNCTION wip_1()        # 計算每張工單的 WIP-主件 部份 成本 (ccg)
   CALL p510_mccg_0()   # 將 mccg 歸 0
   LET mccg.ccg01 =g_sfb.sfb01
   LET mccg.ccg02 =yy
   LET mccg.ccg03 =mm
   LET mccg.ccg04 =g_sfb.sfb05
   LET mccg.ccg06 =type        #FUN-7C0028 add
   LET mccg.ccg07 =g_tlfcost   #FUN-7C0028 add
   SELECT ccg91 INTO mccg.ccg11 FROM ccg_file   # WIP 主件 上期期末轉本期期初
    WHERE ccg01=g_sfb.sfb01 AND ccg02=last_yy AND ccg03=last_mm
      AND ccg06=type        AND ccg07=g_tlfcost   #FUN-7C0028 add
   SELECT cxf11 INTO mccg.ccg11 FROM cxf_file   # WIP 主件 上期期末轉本期期初
    WHERE cxf01=g_sfb.sfb01 AND cxf02=last_yy AND cxf03=last_mm
      AND cxf06=type        AND cxf07=g_tlfcost   #FUN-7C0028 add
      AND (cxf04=' ' OR cxf04 IS NULL)
   CALL wip_ccg20()     # 工時統計
   CALL wip_ccg31()     # 計算每張工單的 WIP-主件 轉出數量
   LET mccg.ccg311 = 0         #No.MOD-D30006
  #LET mccg.ccgplant = g_plant #FUN-980009 add
   LET mccg.ccglegal = g_legal #FUN-980009 add
   LET mccg.ccgoriu = g_user      #No.FUN-980030 10/01/04
   LET mccg.ccgorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ccg_file VALUES (mccg.*)
   IF STATUS THEN 
      LET g_showmsg = mccg.ccg01,"/",mccg.ccg02                                                          #No.FUN-710027
      CALL s_errmsg('ccg01,ccg02',g_showmsg,'wip_1:ins ccg',STATUS,1)                                    #No.FUN-710027
      RETURN 
   END IF
END FUNCTION
 
FUNCTION work_1(p_cmd)     #計算每張工單的 WIP-主件 部份 成本 (ccg)
  DEFINE l_cai   RECORD LIKE cai_file.*
  DEFINE l_cnt   LIKE type_file.num5         #No.FUN-680122 SMALLINT
  DEFINE p_cmd   LIKE type_file.chr1         #No.FUN-680122 VARCHAR(1)
  DEFINE l_cae03 LIKE cae_file.cae03
  DEFINE l_cae04 LIKE cae_file.cae04
  DEFINE l_cae05 LIKE cae_file.cae05
  DEFINE l_cae07 LIKE cae_file.cae07
  DEFINE l_cae08 LIKE cae_file.cae08
  DEFINE g_msg   LIKE type_file.chr1000      #No.FUN-680122 VARCHAR(300)
  DEFINE l_p01,l_p02 LIKE cxh_file.cxh01,    #No.FUN-680122 VARCHAR(16),     #No.FUN-550025
#        l_p03       LIKE ima_file.ima26     #No.FUN-680122 DEC(15,3)
         l_p03       LIKE type_file.num15_3  ###GP5.2  #NO.FUN-A20044
 
   CALL p510_mccg_0()   # 將 mccg 歸 0
   LET mccg.ccg01 =g_sfb.sfb01
   LET mccg.ccg02 =yy
   LET mccg.ccg03 =mm
   LET mccg.ccg04 =g_sfb.sfb05
   LET mccg.ccg06 =type        #FUN-7C0028 add
   LET mccg.ccg07 =g_tlfcost   #FUN-7C0028 add
   LET gg_cxh26   =0
   LET gg_cxh28   =0
 
   #上期期末轉本期期初
   SELECT ccg91 INTO mccg.ccg11 FROM ccg_file
    WHERE ccg01=g_sfb.sfb01 AND ccg02=last_yy AND ccg03=last_mm
      AND ccg06=type        AND ccg07=g_tlfcost   #FUN-7C0028 add
   #上期在製期初開帳資料檔
   SELECT cxf11 INTO mccg.ccg11 FROM cxf_file
    WHERE cxf01=g_sfb.sfb01 AND cxf02=last_yy AND cxf03=last_mm
      AND cxf06=type        AND cxf07=g_tlfcost   #FUN-7C0028 add
      AND (cxf04=' ' OR cxf04 IS NULL)
   CALL wip_ccg20()     # 工時統計
   CALL wip_ccg31()     # 計算每張工單的 WIP-主件 轉出數量
  #LET mccg.ccgplant = g_plant #FUN-980009 add
   LET mccg.ccglegal = g_legal #FUN-980009 add
   IF p_cmd='2' THEN
      LET mccg.ccgoriu = g_user      #No.FUN-980030 10/01/04
      LET mccg.ccgorig = g_grup      #No.FUN-980030 10/01/04
      LET mccg.ccg311 = 0         #No.MOD-D30006
      INSERT INTO ccg_file VALUES (mccg.*)
      IF (NOT cl_sql_dup_value(SQLCA.SQLCODE)) AND SQLCA.SQLCODE <0 THEN   #TQC-790087
         LET g_showmsg = mccg.ccg01,"/",mccg.ccg02                                                                  #No.FUN-710027
         CALL s_errmsg('ccg01,ccg02',g_showmsg,'work_1:ins ccg',SQLCA.SQLCODE,1)                                    #No.FUN-710027
         RETURN
      END IF
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
         UPDATE ccg_file SET ccg_file.* = mccg.*
          WHERE ccg01=mccg.ccg01 AND ccg02=mccg.ccg02 AND ccg03=mccg.ccg03
            AND ccg06=mccg.ccg06 AND ccg07=mccg.ccg07   #FUN-7C0028 add
         IF STATUS THEN 
            LET g_showmsg = mccg.ccg01,"/",mccg.ccg02                                                              #No.FUN-710027
            CALL s_errmsg('ccg01,ccg02',g_showmsg,'work_1:upd ccg',SQLCA.SQLCODE,1)                                #No.FUN-710027
         END IF
      END IF
 
     #-----在製成本下階期初轉本期----------------
     DECLARE cch_cur8 CURSOR FOR
      SELECT * FROM cch_file
       WHERE cch01=g_sfb.sfb01 AND cch02=last_yy AND cch03=last_mm
         AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
     FOREACH cch_cur8 INTO mcch.*
         LET mcch.cch02=yy
         LET mcch.cch03=mm
         LET mcch.cch06=type        #FUN-7C0028 add
         LET mcch.cch07=g_tlfcost   #FUN-7C0028 add 
         LET mcch.cch11=  mcch.cch91
         LET mcch.cch12=  mcch.cch92
         LET mcch.cch12a= mcch.cch92a
         LET mcch.cch12b= mcch.cch92b
         LET mcch.cch12c= mcch.cch92c
         LET mcch.cch12d= mcch.cch92d
         LET mcch.cch12e= mcch.cch92e
         LET mcch.cch12f= mcch.cch92f   #FUN-7C0028 add
         LET mcch.cch12g= mcch.cch92g   #FUN-7C0028 add
         LET mcch.cch12h= mcch.cch92h   #FUN-7C0028 add
         LET mcch.cch21 =0
         LET mcch.cch22 =0 LET mcch.cch22a=0 LET mcch.cch22b=0
         LET mcch.cch22c=0 LET mcch.cch22d=0 LET mcch.cch22e=0
         LET mcch.cch22f=0 LET mcch.cch22g=0 LET mcch.cch22h=0   #FUN-7C0028 add
         LET mcch.cch31 =0
         LET mcch.cch311=0 #FUN-660206
         LET mcch.cch32 =0 LET mcch.cch32a=0 LET mcch.cch32b=0
         LET mcch.cch32c=0 LET mcch.cch32d=0 LET mcch.cch32e=0
         LET mcch.cch32f=0 LET mcch.cch32g=0 LET mcch.cch32h=0   #FUN-7C0028 add 
         LET mcch.cch41 =0
         LET mcch.cch42 =0 LET mcch.cch42a=0 LET mcch.cch42b=0
         LET mcch.cch42c=0 LET mcch.cch42d=0 LET mcch.cch42e=0
         LET mcch.cch42f=0 LET mcch.cch42g=0 LET mcch.cch42h=0   #FUN-7C0028 add 
         LET mcch.cch53 =0
         LET mcch.cch54 =0 LET mcch.cch54a=0 LET mcch.cch54b=0
         LET mcch.cch54c=0 LET mcch.cch54e=0
         LET mcch.cch54f=0 LET mcch.cch54g=0 LET mcch.cch54h=0   #FUN-7C0028 add 
         LET mcch.cchdate = g_today
 
        #LET mcch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
         LET mcch.cchlegal = g_legal #FUN-980009 add
         LET mcch.cchoriu = g_user      #No.FUN-980030 10/01/04
         LET mcch.cchorig = g_grup      #No.FUN-980030 10/01/04
         INSERT INTO cch_file VALUES(mcch.*)
         IF (NOT cl_sql_dup_value(SQLCA.SQLCODE)) AND SQLCA.SQLCODE <0 THEN   #TQC-790087
            LET g_showmsg=mcch.cch01,"/",mcch.cch02                                                                   #No.FUN-710027
            CALL s_errmsg('cch01,cch02',g_showmsg,'work_1:ins cch',SQLCA.SQLCODE,1)                                   #No.FUN-710027
            RETURN
         END IF
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
            UPDATE cch_file SET cch_file.*=mcch.*
             WHERE cch01=mcch.cch01 AND cch02=yy AND cch03=mm
               AND cch04=mcch.cch04
               AND cch06=mcch.cch06 AND cch07=mcch.cch07   #FUN-7C0028 add
            IF STATUS THEN 
               LET g_showmsg = mcch.cch01,"/",yy                                                                    #No.FUN-710027
               CALL s_errmsg('cch01,cch02',g_showmsg,'work_1:upd cch:',SQLCA.SQLCODE,1)                             #No.FUN-710027
            END IF
         END IF
     END FOREACH
   END IF
END FUNCTION
 
FUNCTION work_get_cxh()
  IF g_sfb.sfb93='N' THEN RETURN END IF
  IF g_caf.caf01 IS NULL THEN
     LET gg_out  =0
     LET gg_cxh26=0                        #工單轉入
     LET gg_cxh28=0                        #重流轉入
     LET gg_cxh31=0                        #轉下製程
     LET gg_cxh33=0                        #本月報廢
     LET gg_cxh35=0                        #工單轉出
     LET gg_cxh37=0                        #當站下線
     LET gg_cxh39=0                        #重流出
  ELSE
     LET gg_cxh26=g_caf.caf12              #工單轉入
     LET gg_cxh28=g_caf.caf11              #重流轉入
     LET gg_out=g_caf.caf13+g_caf.caf14+g_caf.caf15+g_caf.caf16+g_caf.caf17+
                g_caf.caf18                #總轉出量
     LET gg_cxh31=g_caf.caf13+g_caf.caf14  #轉下製程
     LET gg_cxh33=g_caf.caf16              #本月報廢
     LET gg_cxh35=g_caf.caf18              #工單轉出
     LET gg_cxh37=g_caf.caf17              #當站下線
     LET gg_cxh39=g_caf.caf15              #重流出
  END IF
 
  #本站投入數量 gg_cxh21
  #取得前製程序號
  LET gg_ecm03=NULL #FUN-A60095  
  LET gg_ecm04=' '
 #FUN-A60095(S) 
 #SELECT ecm03,ecm04 INTO gg_ecm03,gg_ecm04 FROM ecm_file
 # WHERE ecm01=g_sfb.sfb01
 #   AND ecm03=(SELECT MAX(ecm03) FROM ecm_file WHERE ecm01=g_sfb.sfb01
 #                 AND ecm03< g_ecm.ecm03)   #g_caf.caf05)
  CALL s_schdat_previous_ecm03(g_sfb.sfb01,g_ecm.ecm012,g_ecm.ecm03) RETURNING gg_ecm012,gg_ecm03
  IF gg_ecm03 IS NOT NULL THEN
     SELECT ecm04 INTO gg_ecm04 FROM ecm_file 
                 WHERE ecm01=g_sfb.sfb01
                   AND ecm012=gg_ecm012
                   AND ecm03=gg_ecm03
  END IF
 #FUN-A60095(E) 
  IF gg_ecm03 IS NULL THEN  #僅製程第一站,有投入量
     SELECT SUM(sfq03) INTO gg_cxh21 FROM sfq_file,sfp_file
      WHERE sfq02=g_sfb.sfb01 AND sfp06 IN('1','D')           #FUN-C70014 sfp06='1' -> sfp06 IN('1','D') 
        AND sfq01=sfp01 AND sfp04='Y'
        AND sfp03 BETWEEN g_bdate AND g_edate
  ELSE
     LET gg_cxh21=0
  END IF
END FUNCTION
 
FUNCTION wip_ccg20()    # 工時統計
  SELECT SUM(cam08) INTO mccg.ccg20 FROM cam_file      # 工時統計
   WHERE cam04=g_sfb.sfb01 AND cam01 BETWEEN g_bdate AND g_edate
  IF mccg.ccg20 IS NULL THEN LET mccg.ccg20=0 END IF
END FUNCTION
 
FUNCTION wip_ccg31()    # 計算每張工單的 WIP-主件 轉出數量
   SELECT SUM(tlf10*tlf60) INTO g_make_qty FROM tlf_file      # 當月成品入庫量
             WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND (tlf03 = 50)
               AND tlf13 MATCHES 'asft6*'
               AND (tlf01=g_sfb.sfb05)
               AND tlfcost=g_tlfcost   #FUN-7C0028 add
               AND tlf902 NOT IN(SELECT jce02 FROM jce_file)  #MOD-C80242 add
   IF g_make_qty IS NULL THEN LET g_make_qty=0 END IF
   SELECT SUM(tlf10*tlf60) INTO g_make_qty2 FROM tlf_file     # 當月成品退庫量
             WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND (tlf02 = 50)
               AND tlf13 MATCHES 'asft6*'
               AND (tlf01=g_sfb.sfb05)
               AND tlfcost=g_tlfcost   #FUN-7C0028 add
               AND tlf902 NOT IN(SELECT jce02 FROM jce_file)  #MOD-C80242 add
   IF g_make_qty2 IS NULL THEN LET g_make_qty2=0 END IF
   LET g_make_qty=g_make_qty2-g_make_qty        # 轉出以負數表示
   LET mccg.ccg31=g_make_qty
END FUNCTION
 
FUNCTION work_ccg21(p_cmd)    #主件 投入數量
   DEFINE qty1,qty2  LIKE type_file.num10   #No.FUN-680122 INTEGER
   DEFINE p_cmd      LIKE type_file.chr1    #No.FUN-680122 VARCHAR(1)
   DEFINE l_ecm04    LIKE ecm_file.ecm04    #FUN-660142 add
   DEFINE l_ecm012   LIKE ecm_file.ecm012   #FUN-A60095
   DEFINE l_ecm03    LIKE ecm_file.ecm03    #FUN-A60095

   IF p_cmd='1' THEN
      LET l_ecm04=g_ecm.ecm04
   ELSE
      LET l_ecm04=' ' #FUN-A60095
     #FUN-A60095(S)
     #SELECT ecm04 INTO l_ecm04 FROM ecm_file
     # WHERE ecm01=mccg.ccg01
     #   AND ecm03 = (SELECT MIN(ecm03) FROM ecm_file 
     #                 WHERE ecm01=mccg.ccg01)
      CALL s_schdat_min_ecm03(mccg.ccg01) RETURNING l_ecm012,l_ecm03
      SELECT ecm04 INTO l_ecm04 FROM ecm_file
       WHERE ecm01=mccg.ccg01
         AND ecm012=l_ecm012
         AND ecm03=l_ecm03
     #FUN-A60095(E)
   END IF
 
   IF mccg.ccg11 + mccg.ccg21 = 0 THEN LET qty1 = g_sfb.sfb08 END IF
   IF g_sma.sma129 = 'Y' THEN   #FUN-D70038
   #FUN-D70038---begin  remark
   #CHI-D10020---begin mark
      SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
       WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06 IN('1','D')  AND sfp04='Y'   #FUN-C70014 sfp06='1' -> sfp06 IN('1','D')
         AND (sfp03 >= g_bdate AND sfp03 <= g_edate)
         AND sfq04=l_ecm04   #FUN-660142 add
   
      SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
       WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
         AND (sfp03 >= g_bdate AND sfp03 <= g_edate)
         AND sfq04=l_ecm04   #FUN-660142 add
   #CHI-D10020---end
   #FUN-D70038---end
   ELSE  #FUN-D70038
   #CHI-D10020---begin
      SELECT sfb081 INTO qty1
        FROM sfb_file
       WHERE sfb01 = mccg.ccg01
      SELECT SUM(ccg21) INTO qty2
        FROM ccg_file
       WHERE ccg01 = mccg.ccg01
         AND ((ccg02 = yy AND ccg03 < mm)
         OR (ccg02 < yy))
   #CHI-D10020---end
   END IF  #FUN-D70038
   IF qty1 IS NULL THEN LET qty1=0 END IF
   IF qty2 IS NULL THEN LET qty2=0 END IF
   LET mccg.ccg21 = qty1-qty2
 
   #工單成會結案,
   IF g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate AND
      mccg.ccg21 != (mccg.ccg11+mccg.ccg31) * -1 THEN
      IF p_cmd='1' THEN  #避免訊息重覆寫入
         LET g_msg="工單:",g_sfb.sfb01," (work_ccg21)因工單成會結案,則依轉出計算投入(",
         mccg.ccg21 USING '------&','<-',(mccg.ccg11+mccg.ccg31) USING '------&)'
         LET t_time = TIME
         LET g_time=t_time
        #FUN-A50075--mod--str-- ccy_file del plant&legal
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
        #             VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      VALUES(TODAY,g_time,g_user,g_msg)
        #FUN-A50075--mod--end
      END IF
      LET mccg.ccg41 = (mccg.ccg11+mccg.ccg21+mccg.ccg31) * -1
   ELSE
      #投入套數小於轉出.. 需勾稽
      IF (mccg.ccg11 + mccg.ccg21) < mccg.ccg31*-1 THEN
         IF p_cmd='1' THEN  #避免訊息重覆寫入
            LET g_msg="工單:",g_sfb.sfb01," 投入套數小於轉出.. 需勾稽",
            mccg.ccg21 USING '------&','<-',(mccg.ccg11+mccg.ccg31) USING '------&)'
            LET t_time = TIME
            LET g_time=t_time
           #FUN-A50075--mod--str--
           #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
           #             VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
            INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                         VALUES(TODAY,g_time,g_user,g_msg)
           #FUN-A50075--mod--end
         END IF
      END IF
   END IF
END FUNCTION
 
FUNCTION wip_ccg21()    # 計算每張工單的 WIP-主件 投入數量
   DEFINE qty1,qty2     LIKE type_file.num10         #No.FUN-680122 INTEGER
 
   IF mccg.ccg11 + mccg.ccg21 = 0 THEN LET qty1 = g_sfb.sfb08 END IF
   IF g_sma.sma129 = 'Y' THEN   #FUN-D70038
   #FUN-D70038---begin  remark
   #CHI-D10020---begin mark
      SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
       WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06 IN('1','D') AND sfp04='Y'   #FUN-C70014 sfp06='1' -> sfp06 IN('1','D')
         AND (sfp03 >= g_bdate AND sfp03 <= g_edate)
   
      SELECT SUM(sfq03) INTO qty2 FROM sfq_file, sfp_file
       WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
         AND (sfp03 >= g_bdate AND sfp03 <= g_edate)
   #CHI-D10020---end
   #FUN-D70038---end
   ELSE  #FUN-D70038
   #CHI-D10020---begin
      SELECT sfb081 INTO qty1
        FROM sfb_file
       WHERE sfb01 = mccg.ccg01
      SELECT SUM(ccg21) INTO qty2
        FROM ccg_file
       WHERE ccg01 = mccg.ccg01
         AND ((ccg02 = yy AND ccg03 < mm)
          OR (ccg02 < yy))
   #CHI-D10020---end 
   END IF  #FUN-D70038
   IF qty1 IS NULL THEN LET qty1=0 END IF
   IF qty2 IS NULL THEN LET qty2=0 END IF
   LET mccg.ccg21 = qty1-qty2
 
   IF g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate AND   #工單成會結案
      mccg.ccg21 != (mccg.ccg11+mccg.ccg31) * -1 THEN         #則轉出視為投入
      LET g_msg="工單:",g_sfb.sfb01," wip_ccg21因工單成會結案, 則依轉出計算投入(",
      mccg.ccg21 USING '------&','<-',(mccg.ccg11+mccg.ccg31) USING '------&)'
      LET t_time = TIME
      LET g_time=t_time
     #FUN-A50075--mod--str-- ccy_file del plant&legal
     #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
     #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
      INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                    VALUES(TODAY,g_time,g_user,g_msg)
     #FUN-A50075--mod--end
      LET mccg.ccg41 = (mccg.ccg11+mccg.ccg21+mccg.ccg31) * -1
   ELSE
      IF (mccg.ccg11 + mccg.ccg21) < mccg.ccg31*-1 THEN
         LET g_msg="工單:",g_sfb.sfb01," 投入套數小於轉出.. 需勾稽",
         mccg.ccg21 USING '------&','<-',(mccg.ccg11+mccg.ccg31) USING '------&)'
         LET t_time = TIME
         LET g_time=t_time
        #FUN-A50075--mod--str-- ccy_file del plant&legal
        #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
        #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
         INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                       VALUES(TODAY,g_time,g_user,g_msg)
        #FUN-A50075--mod--end
      END IF
   END IF
END FUNCTION
 
FUNCTION wip_2()        # 計算每張工單的 WIP-元件'期初,本期投入'成本 (cch)
   CALL wip_2_1()       # WIP-元件 上期期末轉本期期初
   CALL wip_2_21()      # WIP-元件 本期投入材料 (依工單發料/退料檔)
   CALL wip_ccg21()     #    計算每張工單的 WIP-主件 投入數量 -> 有爭議
   CALL wip_2_22()      # WIP-元件 本期投入人工製費
   CALL wip_2_23()      # WIP-元件 本期投入調整成本
END FUNCTION
 
FUNCTION work_2()
   CALL work_2_1()       # 上期期末轉本期期初 (cxh)
   CALL work_2_21()      # 本期投入材料 (依工單發料/退料檔 by 站別統計)
   CALL work_2_22()      # 本期投入人工製費(cxh)
   CALL work_2_23()      # 調整成本
END FUNCTION
 
FUNCTION wip_2_1()      # WIP-元件 上期期末轉本期期初
   DEFINE l_cxf         RECORD LIKE cxf_file.*
   DECLARE wip_c2 CURSOR FOR
      SELECT * FROM cch_file
       WHERE cch01=g_sfb.sfb01 AND cch02=last_yy AND cch03=last_mm
         AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add 
   FOREACH wip_c2 INTO g_cch.*
     CALL p510_cch_0()  # 上期期末轉本期期初, 將 cch 歸 0
     LET g_cch.cchdate = g_today
    #LET g_cch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
     LET g_cch.cchlegal = g_legal #FUN-980009 add
     LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO cch_file VALUES (g_cch.*)
     IF STATUS THEN 
        LET g_showmsg =g_cch.cch01,"/",g_cch.cch02                                                           #No.FUN-710027
        CALL s_errmsg('cch01,cch02',g_showmsg,'ins cch(1):',STATUS,1)                                                #No.FUN-710027 
     END IF
   END FOREACH
   CLOSE wip_c2
 
   DECLARE wip_c2_cxf CURSOR FOR        # WIP-元件 期初開帳轉本期期初
     SELECT * FROM cxf_file
      WHERE cxf01=g_sfb.sfb01 AND cxf02=last_yy AND cxf03=last_mm
        AND cxf06=type        AND cxf07=g_tlfcost   #FUN-7C0028 add
        AND (cxf04!=' ' AND cxf04 IS NOT NULL)
       #AND (cxf012 IS NULL OR cxf012=' ')   #FUN-670016 mark
   FOREACH wip_c2_cxf INTO l_cxf.*
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','wip_c2_cxf',SQLCA.sqlcode,0)    #No.FUN-710027 
        EXIT FOREACH
     END IF
     CALL p510_cch_01() # 將 cch 歸 0
     LET g_cch.cch01=g_sfb.sfb01
     LET g_cch.cch02=yy
　　 LET g_cch.cch03=mm
     LET g_cch.cch04=l_cxf.cxf04
     LET g_cch.cch05=l_cxf.cxf05
     LET g_cch.cch06 =type          #FUN-7C0028 add
     LET g_cch.cch07 =l_cxf.cxf07   #FUN-7C0028 add 
     LET g_cch.cch11 =l_cxf.cxf11
     LET g_cch.cch12 =l_cxf.cxf12
     LET g_cch.cch12a=l_cxf.cxf12a
     LET g_cch.cch12b=l_cxf.cxf12b
     LET g_cch.cch12c=l_cxf.cxf12c
     LET g_cch.cch12d=l_cxf.cxf12d
     LET g_cch.cch12e=l_cxf.cxf12e
     LET g_cch.cch91 =l_cxf.cxf11
     LET g_cch.cch92 =l_cxf.cxf12
     LET g_cch.cch92a=l_cxf.cxf12a
     LET g_cch.cch92b=l_cxf.cxf12b
     LET g_cch.cch92c=l_cxf.cxf12c
     LET g_cch.cch92d=l_cxf.cxf12d
     LET g_cch.cch92e=l_cxf.cxf12e
     LET g_cch.cchdate = g_today
 
    #LET g_cch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
     LET g_cch.cchlegal = g_legal #FUN-980009 add
     INSERT INTO cch_file VALUES (g_cch.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
        LET g_showmsg =g_cch.cch01,"/",g_cch.cch02                                                       #No.FUN-710027
        CALL s_errmsg('cch01,cch02',g_showmsg,'wip_2_1() ins cch::',SQLCA.SQLCODE,1)                     #No.FUN-710027 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
        UPDATE cch_file SET cch_file.*=g_cch.*
         WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
           AND cch04=l_cxf.cxf04
           AND cch06=g_cch.cch06 AND cch07=g_cch.cch07   #FUN-7C0028 add
        IF STATUS THEN 
           LET g_showmsg =g_cch.cch01,"/",g_cch.cch02                                                       #No.FUN-710027
           CALL s_errmsg('cch01,cch02',g_showmsg,'wip_2_1() upd cch::',SQLCA.SQLCODE,1)                     #No.FUN-710027 
        END IF
     END IF
   END FOREACH
   CLOSE wip_c2_cxf
END FUNCTION
 
#資料再重新
FUNCTION work_2_22_2()
  DEFINE l_p01          LIKE cxh_file.cxh01,         #No.FUN-680122 VARCHAR(16),     #No.FUN-550025
         l_p02          LIKE type_file.num5,         #No.FUN-680122 SMALLINT,
         l_p03          LIKE cxh_file.cxh012,        #No.FUN-680122 VARCHAR(6),
#        l_source_out,l_source_out2  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
         l_source_out,l_source_out2  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
         l_rate         LIKE cac_file.cac03,         #No.FUN-680122 DEC(9,3),
         l_p04          LIKE type_file.chr20         #No.FUN-680122 VARCHAR(10)
  DEFINE l_cxh          RECORD LIKE cxh_file.*
  DEFINE l_cxh01        LIKE cxh_file.cxh01,
         l_cxh011       LIKE cxh_file.cxh011,
         l_cxh012       LIKE cxh_file.cxh012,
         l_cxh02        LIKE cxh_file.cxh02,
         l_cxh03        LIKE cxh_file.cxh03,
         l_cxh04        LIKE cxh_file.cxh04
  DEFINE p_cxh04        LIKE cxh_file.cxh04
  DEFINE p_cxh011       LIKE cxh_file.cxh011
  DEFINE l_ecm03        LIKE ecm_file.ecm03
  DEFINE pre_cxh011     LIKE cxh_file.cxh011
  DEFINE pre_cxh012     LIKE cxh_file.cxh012
  DEFINE x_cxh24        LIKE cxh_file.cxh24,
         x_cxh25        LIKE cxh_file.cxh25,
         x_cxh25a       LIKE cxh_file.cxh25a,
         x_cxh25b       LIKE cxh_file.cxh25b,
         x_cxh25c       LIKE cxh_file.cxh25c,
         x_cxh25d       LIKE cxh_file.cxh25d,
         x_cxh25e       LIKE cxh_file.cxh25e,
         x_cxh25f       LIKE cxh_file.cxh25f,   #FUN-7C0028 add
         x_cxh25g       LIKE cxh_file.cxh25g,   #FUN-7C0028 add
         x_cxh25h       LIKE cxh_file.cxh25h    #FUN-7C0028 add
  DEFINE x_cxh26        LIKE cxh_file.cxh26,
         x_cxh27        LIKE cxh_file.cxh27,
         x_cxh27a       LIKE cxh_file.cxh27a,
         x_cxh27b       LIKE cxh_file.cxh27b,
         x_cxh27c       LIKE cxh_file.cxh27c,
         x_cxh27d       LIKE cxh_file.cxh27d,
         x_cxh27e       LIKE cxh_file.cxh27e,
         x_cxh27f       LIKE cxh_file.cxh27f,   #FUN-7C0028 add
         x_cxh27g       LIKE cxh_file.cxh27g,   #FUN-7C0028 add
         x_cxh27h       LIKE cxh_file.cxh27h    #FUN-7C0028 add
  DEFINE x_cxh28        LIKE cxh_file.cxh28,
         x_cxh29        LIKE cxh_file.cxh29,
         x_cxh29a       LIKE cxh_file.cxh29a,
         x_cxh29b       LIKE cxh_file.cxh29b,
         x_cxh29c       LIKE cxh_file.cxh29c,
         x_cxh29d       LIKE cxh_file.cxh29d,
         x_cxh29e       LIKE cxh_file.cxh29e,
         x_cxh29f       LIKE cxh_file.cxh29f,   #FUN-7C0028 add
         x_cxh29g       LIKE cxh_file.cxh29g,   #FUN-7C0028 add
         x_cxh29h       LIKE cxh_file.cxh29h    #FUN-7C0028 add
  DEFINE pre_cxh013     LIKE cxh_file.cxh013    #FUN-A60095
  DEFINE pre_cxh014     LIKE cxh_file.cxh014    #FUN-A60095
  DEFINE l_po13         LIKE cxh_file.cxh013    #FUN-A60095
 
  DECLARE work_2_22_2_cur CURSOR FOR
     SELECT * FROM cxh_file
      WHERE cxh01=g_sfb.sfb01
        AND cxh02=yy
        AND cxh03=mm
        AND cxh06=type        #FUN-7C0028 add
        AND cxh07=g_tlfcost   #FUN-7C0028 add
   ORDER BY cxh01,cxh013,cxh014,cxh012  #FUN-A60095
   LET pre_cxh011=' '
   LET pre_cxh012=' '
   LET pre_cxh013=NULL   #FUN-A60095
   LET pre_cxh014=NULL   #FUN-A60095
   
  FOREACH work_2_22_2_cur INTO l_cxh.*
  #FUN-A60095(S)
  #SELECT UNIQUE ecm03 INTO l_ecm03 FROM ecm_file
  # WHERE ecm01=l_cxh.cxh01 AND ecm04=l_cxh.cxh012
  #IF STATUS THEN 
  #   LET g_showmsg=l_cxh.cxh01,"/",l_cxh.cxh012                                                                    #No.FUN-710027
  #   CALL s_errmsg('cxh01,cxh012',g_showmsg,'work_2_22_2:sel ecm03',STATUS,1)                                      #No.FUN-710027
  #END IF
   LET l_ecm03 = l_cxh.cxh014
  #FUN-A60095(E)
   LET x_cxh24  =0  LET x_cxh25  =0  
   LET x_cxh25a =0  LET x_cxh25b =0 
   LET x_cxh25c =0  LET x_cxh25d =0 LET x_cxh25e =0
   LET x_cxh25f =0  LET x_cxh25g =0 LET x_cxh25h =0   #FUN-7C0028 add
   LET x_cxh26  =0  LET x_cxh27  =0
   LET x_cxh27a =0  LET x_cxh27b =0
   LET x_cxh27c =0  LET x_cxh27d =0 LET x_cxh27e =0  
   LET x_cxh27f =0  LET x_cxh27g =0 LET x_cxh27h =0   #FUN-7C0028 add
   LET x_cxh28  =0  LET x_cxh29  =0 
   LET x_cxh29a =0  LET x_cxh29b =0 
   LET x_cxh29c =0  LET x_cxh29d =0 LET x_cxh29e =0
   LET x_cxh29f =0  LET x_cxh29g =0 LET x_cxh29h =0   #FUN-7C0028 add
 
   #取得前製程序號
   LET gg_ecm03=NULL #FUN-A60095  
   LET gg_ecm04=' '
   #FUN-A60095(S)
   #SELECT ecm03,ecm04 INTO gg_ecm03,gg_ecm04 FROM ecm_file
   # WHERE ecm01=g_sfb.sfb01
   #   AND ecm03=(SELECT MAX(ecm03) FROM ecm_file
   #              WHERE ecm01=g_sfb.sfb01 AND ecm03< l_ecm03)
   CALL s_schdat_previous_ecm03(g_sfb.sfb01,g_ecm.ecm012,g_ecm.ecm03) RETURNING gg_ecm012,gg_ecm03
   IF gg_ecm03 IS NOT NULL THEN
      SELECT ecm04 INTO gg_ecm04 FROM ecm_file
                  WHERE ecm01=g_sfb.sfb01
                    AND ecm012=gg_ecm012
                    AND ecm03=gg_ecm03
   END IF
   #FUN-A60095(E)
   IF gg_ecm03 IS NOT NULL THEN      #有前製程轉入數 #FUN-A60095
      IF l_cxh.cxh04 !=' DL+OH+SUB' THEN
         SELECT cxh011,cxh04 INTO p_cxh011,p_cxh04
           FROM cxh_file 
          WHERE cxh01 =l_cxh.cxh01
            AND cxh02 =l_cxh.cxh02 AND cxh03 =l_cxh.cxh03
            AND cxh011=pre_cxh011  AND cxh012=pre_cxh012
            AND cxh04!=' DL+OH+SUB'
            AND cxh06 =l_cxh.cxh06 AND cxh07 =l_cxh.cxh07   #FUN-7C0028 add
            AND cxh013=pre_cxh013 AND cxh014=pre_cxh014  #FUN-A60095
      ELSE
         LET p_cxh04=' DL+OH+SUB'
      END IF
      LET g_sql=" SELECT cxh31,cxh32,cxh32a,cxh32b,cxh32c,cxh32d,cxh32e  ",
                "                   ,cxh32f,cxh32g,cxh32h ",   #FUN-7C0028 add
                " FROM cxh_file ",
                "WHERE cxh01='",l_cxh.cxh01,"' AND cxh012='",gg_ecm04,"' ",
                "  AND cxh02='",yy,"' AND cxh03 ='",mm,"' AND cxh31 !=0  ",
                "  AND cxh06='",l_cxh.cxh06,"'",   #FUN-7C0028 add
                "  AND cxh07='",l_cxh.cxh07,"'",   #FUN-7C0028 add
                "  AND cxh04 ='",p_cxh04,"' ",
                "  AND cxh013='",gg_ecm012,"' AND cxh014='",gg_ecm03,"'" CLIPPED  #FUN-A60095
      PREPARE xxx_pre FROM g_sql
      DECLARE work_c22_2_cxh1 CURSOR FOR xxx_pre
      FOREACH work_c22_2_cxh1 INTO x_cxh24,x_cxh25,x_cxh25a,x_cxh25b,x_cxh25c,
                                   x_cxh25d,x_cxh25e      # 有前製程資料
                                  ,x_cxh25f,x_cxh25g,x_cxh25h   #FUN-7C0028 add
             LET x_cxh24=x_cxh24*-1
             LET x_cxh25=x_cxh25*-1
             LET x_cxh25a=x_cxh25a*-1
             LET x_cxh25b=x_cxh25b*-1
             LET x_cxh25c=x_cxh25c*-1
             LET x_cxh25d=x_cxh25d*-1
             LET x_cxh25e=x_cxh25e*-1
             LET x_cxh25f=x_cxh25f*-1   #FUN-7C0028 add
             LET x_cxh25g=x_cxh25g*-1   #FUN-7C0028 add
             LET x_cxh25h=x_cxh25h*-1   #FUN-7C0028 add
 
             UPDATE cxh_file
                SET cxh24  =x_cxh24,
                    cxh25  =x_cxh25,
                    cxh25a =x_cxh25a,
                    cxh25b =x_cxh25b,
                    cxh25c =x_cxh25c,
                    cxh25d =x_cxh25d,
                    cxh25e =x_cxh25e,
                    cxh25f =x_cxh25f,   #FUN-7C0028 add
                    cxh25g =x_cxh25g,   #FUN-7C0028 add
                    cxh25h =x_cxh25h    #FUN-7C0028 add
                WHERE cxh01=l_cxh.cxh01 AND cxh012=l_cxh.cxh012
                  AND cxh02=yy AND cxh03=mm
                  AND cxh04=l_cxh.cxh04 AND cxh011=l_cxh.cxh011
                  AND cxh06=l_cxh.cxh06 AND cxh07 =l_cxh.cxh07  #FUN-7C0028 add
                  AND cxh013=l_cxh.cxh013 AND cxh014=l_cxh.cxh014  #FUN-A60095
             IF STATUS THEN 
                LET g_showmsg=l_cxh.cxh01,"/",l_cxh.cxh012                                                           #No.FUN-710027
                CALL s_errmsg('cxh01,cxh02',g_showmsg,'upd cxh(4):',STATUS,1)                                        #No.FUN-710027
             END IF
       END FOREACH
    END IF
    IF l_cxh.cxh04 !=' DL+OH+SUB' THEN
       LET pre_cxh011=l_cxh.cxh011
       LET pre_cxh012=l_cxh.cxh012
       LET pre_cxh013=l_cxh.cxh013  #FUN-A60095
       LET pre_cxh014=l_cxh.cxh014  #FUN-A60095
    END IF
 
    ## WIP-元件 其它工單轉入
    ##         (只能轉依工單投料的元件以及前製程轉入的資料)
       DECLARE work_c22_1_cxh2 CURSOR FOR     # 取得轉入前之原工單資料
          SELECT p01,p02,p03,p04,po13   #FUN-A60095
            FROM tmp11_file 
           WHERE p05=g_sfb.sfb01  
             AND p06=l_ecm03
             AND p07=l_cxh.cxh012   #FUN-670016 add
             AND pi13=l_cxh.cxh013  #FUN-A60095
       IF STATUS THEN
          CALL s_errmsg('','','Declare wip_c22_1_cxh2 error:',STATUS,1)                                                      #No.FUN-710027
          RETURN
       END IF
       FOREACH work_c22_1_cxh2 INTO l_p01,l_p02,l_p03,l_p04,l_po13  #FUN-A60095
                              #來源工單/製程/作編 工單轉出量
 
          SELECT SUM(p04) INTO l_source_out   # 來源工單之總工單轉出量
            FROM tmp11_file
           WHERE p01=l_p01 AND p02=l_p02 AND p03=l_p03
             AND po13=l_po13  #FUN-A60095
          IF cl_null(l_source_out) THEN
             LET g_msg = g_sfb.sfb01 CLIPPED,' 工單轉出前之其他工單轉出量有誤'
             CALL s_errmsg('','',g_msg,STATUS,0) #No.FUN-710027
             EXIT FOREACH
          END IF
          LET l_rate = l_p04/l_source_out         # 來源工單轉出比率
          DECLARE wip_c2_1_cxh2_12 CURSOR FOR     # 本工單的資料
             SELECT cxh35,cxh36,cxh36a,cxh36b,cxh36c,cxh36d,cxh36e
                               ,cxh36f,cxh36g,cxh36h   #FUN-7C0028 add
               FROM cxh_file
              WHERE cxh01=l_p01  AND cxh012=l_p03
                AND cxh02=yy  AND cxh03 = mm AND cxh35 !=0
                AND cxh06=l_cxh.cxh06   #FUN-7C0028 add
                AND cxh07=l_cxh.cxh07   #FUN-7C0028 add
                AND cxh04=l_cxh.cxh04
                AND cxh013=l_po13  #FUN-A60095
                AND cxh014=l_p02   #FUN-A60095
          FOREACH wip_c2_1_cxh2_12 INTO x_cxh26,x_cxh27,x_cxh27a,x_cxh27b,
                                        x_cxh27c,x_cxh27d,x_cxh27e
                                       ,x_cxh27f,x_cxh27g,x_cxh27h   #FUN-7C0028 add
            LET x_cxh26=x_cxh26*-1*l_rate
            LET x_cxh27=x_cxh27*-1*l_rate
            LET x_cxh27a=x_cxh27a*-1*l_rate
            LET x_cxh27b=x_cxh27b*-1*l_rate
            LET x_cxh27c=x_cxh27c*-1*l_rate
            LET x_cxh27d=x_cxh27d*-1*l_rate
            LET x_cxh27e=x_cxh27e*-1*l_rate
            LET x_cxh27f=x_cxh27f*-1*l_rate   #FUN-7C0028 add
            LET x_cxh27g=x_cxh27g*-1*l_rate   #FUN-7C0028 add
            LET x_cxh27h=x_cxh27h*-1*l_rate   #FUN-7C0028 add
            #其他工單轉入
            UPDATE cxh_file
               SET cxh26 = x_cxh26,
                   cxh27 = x_cxh27,
                   cxh27a= x_cxh27a,
                   cxh27b= x_cxh27b,
                   cxh27c= x_cxh27c,
                   cxh27d= x_cxh27d,
                   cxh27e= x_cxh27e,
                   cxh27f =x_cxh27f,   #FUN-7C0028 add
                   cxh27g =x_cxh27g,   #FUN-7C0028 add
                   cxh27h =x_cxh27h    #FUN-7C0028 add
             WHERE cxh01 = l_cxh.cxh01
               AND cxh011= l_cxh.cxh011
               AND cxh012= l_cxh.cxh012
               AND cxh02 = yy 
               AND cxh03 = mm
               AND cxh04 = l_cxh.cxh04
               AND cxh06 = l_cxh.cxh06   #FUN-7C0028 add
               AND cxh07 = l_cxh.cxh07   #FUN-7C0028 add
               AND cxh013= l_cxh.cxh013  #FUN-A60095
               AND cxh014= l_cxh.cxh014  #FUN-A60095
            IF STATUS THEN 
               LET g_showmsg=l_cxh.cxh01,"/",l_cxh.cxh011                                   #No.FUN-710027
               CALL s_errmsg('cxh01,cxh011',g_showmsg,'upd cxh(4)',STATUS,1)                #No.FUN-710027
            END IF
          END FOREACH
       END FOREACH
    #END IF

    SELECT SUM(caf11) INTO x_cxh28 FROM caf_file
     WHERE caf01=l_cxh.cxh01 AND caf02=yy AND caf03=mm
       AND caf06=l_cxh.cxh012
       AND caf012 = l_cxh.cxh013 #FUN-A60095
       AND caf05 = l_cxh.cxh014  #FUN-A60095
       
    IF x_cxh28 IS NULL THEN LET x_cxh28=0 END IF
 
   #差異轉出量/結存重算
   IF ((l_cxh.cxh11+l_cxh.cxh21+x_cxh24+x_cxh26+x_cxh28)+
       (l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35
       +l_cxh.cxh37+l_cxh.cxh39)) != 0 THEN
      IF mccg.ccg41 !=0 THEN
         LET l_cxh.cxh41=mccg.ccg41
         LET l_cxh.cxh42a = ((l_cxh.cxh12a + l_cxh.cxh22a + x_cxh25a
                           + x_cxh27a + x_cxh29a)
                           + (l_cxh.cxh32a + l_cxh.cxh34a + l_cxh.cxh36a
                           + l_cxh.cxh38a + l_cxh.cxh40a))*-1
         LET l_cxh.cxh42b = ((l_cxh.cxh12b + l_cxh.cxh22b + x_cxh25b
                           + x_cxh27b + x_cxh29b)
                           + (l_cxh.cxh32b + l_cxh.cxh34b + l_cxh.cxh36b
                           + l_cxh.cxh38b + l_cxh.cxh40b))*-1
         LET l_cxh.cxh42c = ((l_cxh.cxh12c + l_cxh.cxh22c + x_cxh25c
                           + x_cxh27c + x_cxh29c)
                           + (l_cxh.cxh32c + l_cxh.cxh34c + l_cxh.cxh36c
                           + l_cxh.cxh38c + l_cxh.cxh40c))*-1
         LET l_cxh.cxh42d = ((l_cxh.cxh12d + l_cxh.cxh22d + x_cxh25d
                           + x_cxh27d + x_cxh29d)
                           + (l_cxh.cxh32d + l_cxh.cxh34d + l_cxh.cxh36d
                           + l_cxh.cxh38d + l_cxh.cxh40d))*-1
         LET l_cxh.cxh42e = ((l_cxh.cxh12e + l_cxh.cxh22e + x_cxh25e
                           + x_cxh27e + x_cxh29e)
                           + (l_cxh.cxh32e + l_cxh.cxh34e + l_cxh.cxh36e
                           + l_cxh.cxh38e + l_cxh.cxh40e))*-1
         LET l_cxh.cxh42f = ((l_cxh.cxh12f + l_cxh.cxh22f + x_cxh25f
                           + x_cxh27f + x_cxh29f)
                           + (l_cxh.cxh32f + l_cxh.cxh34f + l_cxh.cxh36f
                           + l_cxh.cxh38f + l_cxh.cxh40f))*-1
         LET l_cxh.cxh42g = ((l_cxh.cxh12g + l_cxh.cxh22g + x_cxh25g
                           + x_cxh27g + x_cxh29g)
                           + (l_cxh.cxh32g + l_cxh.cxh34g + l_cxh.cxh36g
                           + l_cxh.cxh38g + l_cxh.cxh40g))*-1
         LET l_cxh.cxh42h = ((l_cxh.cxh12h + l_cxh.cxh22h + x_cxh25h
                           + x_cxh27h + x_cxh29h)
                           + (l_cxh.cxh32h + l_cxh.cxh34h + l_cxh.cxh36h
                           + l_cxh.cxh38h + l_cxh.cxh40h))*-1
         LET l_cxh.cxh42=l_cxh.cxh42a+l_cxh.cxh42b+l_cxh.cxh42c+
                         l_cxh.cxh42d+l_cxh.cxh42e
                        +l_cxh.cxh42f+l_cxh.cxh42g+l_cxh.cxh42h   #FUN-7C0028 add
      ELSE
         LET l_cxh.cxh41=0
         LET l_cxh.cxh42=0
         LET l_cxh.cxh42a=0
         LET l_cxh.cxh42b=0
         LET l_cxh.cxh42c=0
         LET l_cxh.cxh42d=0
         LET l_cxh.cxh42e=0
         LET l_cxh.cxh42f=0   #FUN-7C0028 add
         LET l_cxh.cxh42g=0   #FUN-7C0028 add
         LET l_cxh.cxh42h=0   #FUN-7C0028 add
      END IF
   END IF
 
   # WIP-元件 本期結存成本
   LET l_cxh.cxh91 = l_cxh.cxh11 + l_cxh.cxh21 + x_cxh24
                     + x_cxh26 + x_cxh28
                     + l_cxh.cxh31 + l_cxh.cxh33 + l_cxh.cxh35
                     + l_cxh.cxh37 + l_cxh.cxh39
                     + l_cxh.cxh41 + l_cxh.cxh59
   LET l_cxh.cxh92 = l_cxh.cxh12 + l_cxh.cxh22 + x_cxh25
                     + x_cxh27 + x_cxh29
                     + l_cxh.cxh32 + l_cxh.cxh34
                     + l_cxh.cxh36 + l_cxh.cxh38
                     + l_cxh.cxh40 + l_cxh.cxh42+l_cxh.cxh60
   LET l_cxh.cxh92a = l_cxh.cxh12a + l_cxh.cxh22a + x_cxh25a
                      + x_cxh27a + x_cxh29a
                      + l_cxh.cxh32a + l_cxh.cxh34a
                      + l_cxh.cxh36a + l_cxh.cxh38a
                      + l_cxh.cxh40a + l_cxh.cxh42a+l_cxh.cxh60a
   LET l_cxh.cxh92b = l_cxh.cxh12b + l_cxh.cxh22b + x_cxh25b
                      + x_cxh27b + x_cxh29b
                      + l_cxh.cxh32b + l_cxh.cxh34b
                      + l_cxh.cxh36b + l_cxh.cxh38b
                      + l_cxh.cxh40b + l_cxh.cxh42b+l_cxh.cxh60b
   LET l_cxh.cxh92c = l_cxh.cxh12c + l_cxh.cxh22c + x_cxh25c
                      + x_cxh27c + x_cxh29c
                      + l_cxh.cxh32c + l_cxh.cxh34c
                      + l_cxh.cxh36c + l_cxh.cxh38c
                      + l_cxh.cxh40c + l_cxh.cxh42c+l_cxh.cxh60c
   LET l_cxh.cxh92d = l_cxh.cxh12d + l_cxh.cxh22d + x_cxh25d
                      + x_cxh27d + x_cxh29d
                      + l_cxh.cxh32d + l_cxh.cxh34d
                      + l_cxh.cxh36d + l_cxh.cxh38d
                      + l_cxh.cxh40d + l_cxh.cxh42d + l_cxh.cxh60d
   LET l_cxh.cxh92e = l_cxh.cxh12e + l_cxh.cxh22e + x_cxh25e
                      + x_cxh27e + x_cxh29e
                      + l_cxh.cxh32e + l_cxh.cxh34e
                      + l_cxh.cxh36e + l_cxh.cxh38e
                      + l_cxh.cxh40e + l_cxh.cxh42e + l_cxh.cxh60e
   LET l_cxh.cxh92f = l_cxh.cxh12f + l_cxh.cxh22f + x_cxh25f
                      + x_cxh27f + x_cxh29f
                      + l_cxh.cxh32f + l_cxh.cxh34f
                      + l_cxh.cxh36f + l_cxh.cxh38f
                      + l_cxh.cxh40f + l_cxh.cxh42f + l_cxh.cxh60f
   LET l_cxh.cxh92g = l_cxh.cxh12g + l_cxh.cxh22g + x_cxh25g
                      + x_cxh27g + x_cxh29g
                      + l_cxh.cxh32g + l_cxh.cxh34g
                      + l_cxh.cxh36g + l_cxh.cxh38g
                      + l_cxh.cxh40g + l_cxh.cxh42g + l_cxh.cxh60g
   LET l_cxh.cxh92h = l_cxh.cxh12h + l_cxh.cxh22h + x_cxh25h
                      + x_cxh27h + x_cxh29h
                      + l_cxh.cxh32h + l_cxh.cxh34h
                      + l_cxh.cxh36h + l_cxh.cxh38h
                      + l_cxh.cxh40h + l_cxh.cxh42h + l_cxh.cxh60h
   IF l_cxh.cxh91 < 0  THEN LET l_cxh.cxh91  = 0 END IF
   IF l_cxh.cxh92 < 0  THEN LET l_cxh.cxh92  = 0 END IF
   IF l_cxh.cxh92a < 0 THEN LET l_cxh.cxh92a = 0 END IF
   IF l_cxh.cxh92b < 0 THEN LET l_cxh.cxh92b = 0 END IF
   IF l_cxh.cxh92c < 0 THEN LET l_cxh.cxh92c = 0 END IF
   IF l_cxh.cxh92d < 0 THEN LET l_cxh.cxh92d = 0 END IF
   IF l_cxh.cxh92e < 0 THEN LET l_cxh.cxh92e = 0 END IF
   IF l_cxh.cxh92f < 0 THEN LET l_cxh.cxh92f = 0 END IF   #FUN-7C0028 add
   IF l_cxh.cxh92g < 0 THEN LET l_cxh.cxh92g = 0 END IF   #FUN-7C0028 add
   IF l_cxh.cxh92h < 0 THEN LET l_cxh.cxh92h = 0 END IF   #FUN-7C0028 add
 
     UPDATE cxh_file
        SET cxh41=l_cxh.cxh41,
            cxh42=l_cxh.cxh42,
            cxh42a=l_cxh.cxh42a,
            cxh42b=l_cxh.cxh42b,
            cxh42c=l_cxh.cxh42c,
            cxh42d=l_cxh.cxh42d,
            cxh42e=l_cxh.cxh42e,
            cxh42f=l_cxh.cxh42f,   #FUN-7C0028 add
            cxh42g=l_cxh.cxh42g,   #FUN-7C0028 add
            cxh42h=l_cxh.cxh42h,   #FUN-7C0028 add
            cxh91=l_cxh.cxh91,
            cxh92=l_cxh.cxh92,
            cxh92a=l_cxh.cxh92a,
            cxh92b=l_cxh.cxh92b,
            cxh92c=l_cxh.cxh92c,
            cxh92d=l_cxh.cxh92d,
            cxh92e=l_cxh.cxh92e,
            cxh92f=l_cxh.cxh92f,   #FUN-7C0028 add
            cxh92g=l_cxh.cxh92g,   #FUN-7C0028 add
            cxh92h=l_cxh.cxh92h    #FUN-7C0028 add
      WHERE cxh01 =l_cxh.cxh01
        AND cxh011=l_cxh.cxh011
        AND cxh012=l_cxh.cxh012
        AND cxh02 =yy AND cxh03 =mm
        AND cxh04 =l_cxh.cxh04
        AND cxh06 =l_cxh.cxh06   #FUN-7C0028 add
        AND cxh07 =l_cxh.cxh07   #FUN-7C0028 add
        AND cxh013=l_cxh.cxh013  #FUN-A60095
        AND cxh014=l_cxh.cxh014  #FUN-A60095        
    IF STATUS THEN 
       LET g_showmsg=l_cxh.cxh01,"/",l_cxh.cxh011                                    #No.FUN-710027
       CALL s_errmsg('cxh01,cxh011',g_showmsg,'work_2_22_2:upd cxh41-91:',STATUS,1)  #No.FUN-710027
    END IF
  END FOREACH
END FUNCTION
 
FUNCTION work_2_22_3()
  DEFINE l_cxh22b           LIKE cxh_file.cxh22b
  DEFINE l_cxh22c           LIKE cxh_file.cxh22c
  DEFINE l_ecm04            LIKE ecm_file.ecm04
  DEFINE l_ccg20            LIKE ccg_file.ccg20
  DEFINE l_dept             LIKE sfb_file.sfb98         #No.FUN-680122 VARCHAR(10)
  DEFINE l_sql              LIKE type_file.chr1000      #No.FUN-680122 VARCHAR(600)
  DEFINE l_cam02            LIKE cam_file.cam02
  DEFINE l_sfa              RECORD LIKE sfa_file.*
  DEFINE l_cxh41            LIKE cxh_file.cxh41
  DEFINE l_sfa161           LIKE sfa_file.sfa161
  DEFINE pre_cxh011         LIKE cxh_file.cxh011
  DEFINE pre_cxh012         LIKE cxh_file.cxh012
  DEFINE ecm03_pre          LIKE ecm_file.ecm03
  DEFINE ecm04_pre          LIKE ecm_file.ecm04
  DEFINE l_tmp8             RECORD
                             p01  LIKE oea_file.oea01,        #No.FUN-680122 VARCHAR(16), #工單          #No.FUN-550025
                             p011 LIKE ima_file.ima01,     #TQC-660116 VARCHAR(20), #主件料號
                             p02  LIKE type_file.num5,         #No.FUN-680122 SMALLINT, #製程序
                             p03  LIKE aab_file.aab02,         #No.FUN-680122 VARCHAR(6),  #作業編號
#                            p04  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#重流轉出(cxh39)
#                            p05  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#重流轉入
#                            p06  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#工單轉入
#                            p07  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#轉下製程(cxh31)
#                            p08  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#報廢數量(cxh33)
#                            p09  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#工單轉出(cxh35)
#                            p10  LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3) #當站下線(cxh37)
                             p04  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
                             p05  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
                             p06  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
                             p07  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
                             p08  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
                             p09  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
                             p10  LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
                            END RECORD
  DEFINE l_cxh              RECORD LIKE cxh_file.*
  DEFINE cost,costa,costb,costc,costd,coste    LIKE abb_file.abb25         #No.FUN-680122DEC(18,10)
  DEFINE l_cnt              LIKE type_file.num5          #No.FUN-680122 SMALLINT
  DEFINE l_unissue          LIKE sfa_file.sfa05
  DEFINE l_sfm03            LIKE sfm_file.sfm03
  DEFINE l_sfm04            LIKE sfm_file.sfm04
  DEFINE l_sfm05            LIKE sfm_file.sfm05
  DEFINE l_sfm06,l_woqty    LIKE sfm_file.sfm07
  DEFINE l_dif,l_chg        LIKE sfm_file.sfm07
# DEFINE l_tot_out,l_tot_in LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
  DEFINE l_tot_out,l_tot_in LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
  DEFINE l_sfb08            LIKE sfb_file.sfb08
  DEFINE l_cam06            LIKE cam_file.cam06
# DEFINE g_tot_1,g_tot_2    LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
  DEFINE g_tot_1,g_tot_2    LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
  DEFINE l_cxh33            LIKE cxh_file.cxh33
  DEFINE l_sharerate        LIKE fid_file.fid03          #No.FUN-680122 DEC(8,3)
  DEFINE l_cam07            LIKE cam_file.cam07
# DEFINE l_inpercentb       LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
#        l_inpercentc       LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
#        l_inpercentd       LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
  DEFINE l_inpercentb       LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
         l_inpercentc       LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
         l_inpercentd       LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044

  DEFINE l_shb12            LIKE shb_file.shb12,  #FUN-660180
         l_shb113           LIKE shb_file.shb113, #FUN-660180
         l_cxh011           LIKE cxh_file.cxh011, #FUN-660180
         l_cxh012           LIKE cxh_file.cxh012  #FUN-660180
  DEFINE l_cag              RECORD LIKE cag_file.*,   #FUN-670016 add
         l_cxh01_old        LIKE cxh_file.cxh01       #FUN-670016 add
  DEFINE l_cxh26            LIKE cxh_file.cxh26,    #FUN-680044 add
         l_cxh27a           LIKE cxh_file.cxh27a,   #FUN-680044 add
         l_cxh27b           LIKE cxh_file.cxh27b,   #FUN-680044 add
         l_cxh27c           LIKE cxh_file.cxh27c,   #FUN-680044 add
         l_cxh27d           LIKE cxh_file.cxh27d,   #FUN-680044 add
         l_cxh27e           LIKE cxh_file.cxh27e,   #FUN-680044 add
         l_cxh27            LIKE cxh_file.cxh27     #FUN-680044 add
  DEFINE l_shb121           LIKE shb_file.shb121    #FUN-A60095
  DECLARE work_2_22_3_cur CURSOR FOR
     SELECT cxh_file.*,ecm_file.*,caf_file.*
       FROM cxh_file LEFT OUTER JOIN caf_file ON cxh02=caf02 AND cxh03=caf03 AND cxh01=caf01 AND cxh012=caf06
                                             AND cxh013=caf012 AND cxh014=caf05  #FUN-A60095
       , ecm_file
      WHERE cxh01=g_sfb.sfb01
        AND cxh012=g_ecm.ecm04  #FUN-650160
        AND cxh013=g_ecm.ecm012 #FUN-A60095
        AND cxh014=g_ecm.ecm03  #FUN-A60095
        AND cxh02=yy
        AND cxh03=mm
        AND cxh06=type        #FUN-7C0028 add
        AND cxh07=g_tlfcost   #FUN-7C0028 add
        AND ecm01=cxh01
        AND ecm04=cxh012
        AND ecm012=cxh013  #FUN-A60095
        AND ecm03=cxh014   #FUN-A60095
   ORDER BY cxh01,cxh013,cxh014,cxh012  #FUN-A60095
   let pre_cxh011=' '
   let pre_cxh012=' '
  FOREACH work_2_22_3_cur INTO l_cxh.*,g_ecm.*,g_caf.*
     #因為下面的work_2_22_cxh31()會更新其他作業編號的cxh_file的資料,所以這裡要再重抓一次
      SELECT * INTO l_cxh.* FROM cxh_file
                           WHERE cxh01=l_cxh.cxh01
                             AND cxh011=l_cxh.cxh011
                             AND cxh012=l_cxh.cxh012
                             AND cxh02=l_cxh.cxh02 
                             AND cxh03=l_cxh.cxh03 
                             AND cxh04=l_cxh.cxh04 
                             AND cxh06=l_cxh.cxh06   #FUN-7C0028 add
                             AND cxh07=l_cxh.cxh07   #FUN-7C0028 add
                             AND cxh013=l_cxh.cxh013   #FUN-A60095
                             AND cxh014=l_cxh.cxh014   #FUN-A60095
      CALL work_get_cxh()

      #-總轉出量--
      LET l_tot_out=gg_out
 
      SELECT sfa161 INTO l_sfa161 FROM sfa_file
       WHERE sfa01=l_cxh.cxh01 AND sfa03=l_cxh.cxh04
         AND sfa012=l_cxh.cxh013 AND sfa013=l_cxh.cxh014  #FUN-A60095
 
      SELECT * INTO l_sfa.* FROM sfa_file
       WHERE sfa01=l_cxh.cxh01 AND sfa03=l_cxh.cxh04
         AND sfa012=l_cxh.cxh013 AND sfa013=l_cxh.cxh014  #FUN-A60095
      IF l_sfa.sfa26 MATCHES '[SUZ]' THEN    #FUN-A20037 add 'Z'
         SELECT sfa161 INTO l_sfa161 FROM sfa_file
          WHERE sfa03=l_sfa.sfa27 AND sfa01=g_sfb.sfb01
            AND sfa012=l_sfa.sfa012 AND sfa013=l_sfa.sfa013  #FUN-A60095
      END IF
      IF cl_null(l_sfa161) THEN LET l_sfa161 = 1 END IF
      IF l_cxh.cxh04 =' DL+OH+SUB' THEN LET l_sfa161=1  END IF

      LET l_cxh.cxh26 = gg_cxh26 * l_sfa161*-1    # 工單轉入   #FUN-670016 add
      LET l_cxh.cxh31 = gg_cxh31 * l_sfa161*-1    # 轉下製程
      LET l_cxh.cxh33 = gg_cxh33 * l_sfa161*-1    # 報廢量
      LET l_cxh.cxh35 = gg_cxh35 * l_sfa161*-1    # 工單轉出
      LET l_cxh.cxh37 = gg_cxh37 * l_sfa161*-1    # 當站下線
 
      LET l_cxh.cxh39 = gg_cxh39 * l_sfa161*-1    # 重流轉出
 
       IF cl_null(l_cxh.cxh26) THEN LET l_cxh.cxh26 = 0 END IF   #FUN-670016 add
       IF cl_null(l_cxh.cxh31) THEN LET l_cxh.cxh31 = 0 END IF
       IF cl_null(l_cxh.cxh33) THEN LET l_cxh.cxh33 = 0 END IF
       IF cl_null(l_cxh.cxh34) THEN LET l_cxh.cxh34 = 0 END IF
       IF cl_null(l_cxh.cxh35) THEN LET l_cxh.cxh35 = 0 END IF   #FUN-670016 add
       IF cl_null(l_cxh.cxh36) THEN LET l_cxh.cxh36 = 0 END IF
       IF cl_null(l_cxh.cxh38) THEN LET l_cxh.cxh38 = 0 END IF
 
       #工單轉入
       LET l_cnt = 0
       SELECT COUNT(*) INTO l_cnt FROM shj_file WHERE shj11=l_cxh.cxh01
       IF l_cnt > 0 THEN   #先檢查"生產日報表工單轉出維護檔"裡有沒有轉入這張工單的
          #先抓轉出工單的工單轉出數量、金額
          CASE
            WHEN g_ccz.ccz06='1' OR g_ccz.ccz06='2'

              SELECT (cxh35*-1),(cxh36a*-1),(cxh36b*-1),(cxh36c*-1),
                     (cxh36d*-1),(cxh36e*-1),(cxh36*-1)
                INTO l_cxh26,l_cxh27a,l_cxh27b,l_cxh27c,l_cxh27d,l_cxh27e,l_cxh27
                FROM cxh_file,shi_file,shb_file
               WHERE cxh01 =l_cxh.cxh01   #FUN-A60095
                 AND cxh011=l_cxh.cxh011  #FUN-A60095
                 AND cxh012=l_cxh.cxh012  #FUN-A60095
                 AND cxh02 =l_cxh.cxh02
                 AND cxh03 =l_cxh.cxh03
                 AND cxh04 =l_cxh.cxh04
                 AND cxh06 =l_cxh.cxh06   #FUN-7C0028 add
                 AND cxh07 =l_cxh.cxh07   #FUN-7C0028 add
                 AND cxh013=l_cxh.cxh013  #FUN-A60095
                 AND cxh014=l_cxh.cxh014  #FUN-A60095
                 AND shi01 =shb01         
                 AND shi02 =cxh01
                 AND shi03 =cxh012
                 AND shi04 =cxh014        #FUN-A60095
                 AND shi012=cxh013        #FUN-A60095
                 AND shbconf = 'Y'        #FUN-A70095
            WHEN g_ccz.ccz06='3'
              SELECT (cxh35*-1),(cxh36a*-1),(cxh36b*-1),(cxh36c*-1),
                     (cxh36d*-1),(cxh36e*-1),(cxh36*-1)
                INTO l_cxh26,l_cxh27a,l_cxh27b,l_cxh27c,l_cxh27d,l_cxh27e,l_cxh27
                FROM cxh_file,shi_file    #FUN-A60095 mark shb_file
               WHERE cxh01 =l_cxh.cxh01   #FUN-A60095
                 AND cxh011=l_cxh.cxh011  #FUN-A60095
                 AND cxh012=l_cxh.cxh012  #FUN-A60095
                 AND cxh02 =l_cxh.cxh02
                 AND cxh03 =l_cxh.cxh03
                 AND cxh04 =l_cxh.cxh04
                 AND cxh06 =l_cxh.cxh06   #FUN-7C0028 add
                 AND cxh07 =l_cxh.cxh07   #FUN-7C0028 add
                 AND cxh013=l_cxh.cxh013  #FUN-A60095
                 AND cxh014=l_cxh.cxh014  #FUN-A60095
               # AND shi01 =shb01         
                 AND shi02 =cxh01
                 AND shi03 =cxh012
                 AND shi04 =cxh014        #FUN-A60095
                 AND shi012=cxh013        #FUN-A60095
            WHEN g_ccz.ccz06='4'
              SELECT (cxh35*-1),(cxh36a*-1),(cxh36b*-1),(cxh36c*-1),
                     (cxh36d*-1),(cxh36e*-1),(cxh36*-1)
                INTO l_cxh26,l_cxh27a,l_cxh27b,l_cxh27c,l_cxh27d,l_cxh27e,l_cxh27
                FROM cxh_file,shi_file,shb_file,ecm_file
               WHERE cxh01 =l_cxh.cxh01   #FUN-A60095
                 AND cxh011=l_cxh.cxh011  #FUN-A60095
                 AND cxh012=l_cxh.cxh012  #FUN-A60095
                 AND cxh02 =l_cxh.cxh02
                 AND cxh03 =l_cxh.cxh03
                 AND cxh04 =l_cxh.cxh04
                 AND cxh06 =l_cxh.cxh06   #FUN-7C0028 add
                 AND cxh07 =l_cxh.cxh07   #FUN-7C0028 add
                 AND cxh013=l_cxh.cxh013  #FUN-A60095
                 AND cxh014=l_cxh.cxh014  #FUN-A60095
                 AND shi01 =shb01         
                 AND shi02 =cxh01
                 AND shi03 =cxh012
                 AND shi04 =cxh014        #FUN-A60095
                 AND shi012=cxh013        #FUN-A60095
                 AND ecm06 =cxh011        #FUN-A60095
                 AND shi02 =ecm01
                 AND shi04 =ecm03                 
                 AND shbconf = 'Y'        #FUN-A70095
          END CASE
          IF cl_null(l_cxh26)  THEN LET l_cxh26 =0 END IF
          IF cl_null(l_cxh27a) THEN LET l_cxh27a=0 END IF
          IF cl_null(l_cxh27b) THEN LET l_cxh27b=0 END IF
          IF cl_null(l_cxh27c) THEN LET l_cxh27c=0 END IF
          IF cl_null(l_cxh27d) THEN LET l_cxh27d=0 END IF
          IF cl_null(l_cxh27e) THEN LET l_cxh27e=0 END IF
 
          #工單轉入數量
          SELECT shj12 INTO l_cxh.cxh26 FROM shj_file WHERE shj11=l_cxh.cxh01
          #按照比例計算金額
          LET l_cxh.cxh27a = l_cxh27a * l_cxh.cxh26 / l_cxh26
          LET l_cxh.cxh27b = l_cxh27b * l_cxh.cxh26 / l_cxh26
          LET l_cxh.cxh27c = l_cxh27c * l_cxh.cxh26 / l_cxh26
          LET l_cxh.cxh27d = l_cxh27d * l_cxh.cxh26 / l_cxh26
          LET l_cxh.cxh27e = l_cxh27e * l_cxh.cxh26 / l_cxh26
          LET l_cxh.cxh27  = l_cxh27  * l_cxh.cxh26 / l_cxh26
          IF cl_null(l_cxh.cxh26)  THEN LET l_cxh.cxh26 =0 END IF
          IF cl_null(l_cxh.cxh27a) THEN LET l_cxh.cxh27a=0 END IF
          IF cl_null(l_cxh.cxh27b) THEN LET l_cxh.cxh27b=0 END IF
          IF cl_null(l_cxh.cxh27c) THEN LET l_cxh.cxh27c=0 END IF
          IF cl_null(l_cxh.cxh27d) THEN LET l_cxh.cxh27d=0 END IF
          IF cl_null(l_cxh.cxh27e) THEN LET l_cxh.cxh27e=0 END IF
       END IF
 
       #抓取工單轉入資料檔
       SELECT * INTO l_cag.* from cag_file
        WHERE cag11=l_cxh.cxh01 
          AND cag15=g_ecm.ecm03 
          AND cag16=l_cxh.cxh012
          AND cag012=l_cxh.cxh013  #FUN-A60095          
       IF NOT cl_null(l_cag.cag01) THEN
          SELECT ecm06 INTO l_cxh011 FROM ecm_file
           WHERE ecm01 = l_cag.cag01
             AND ecm03 = l_cag.cag05
             AND ecm012= l_cag.cag012  #FUN-A60095
          LET l_cnt = 0
          SELECT COUNT(*) INTO l_cnt FROM cxh_file
           WHERE cxh01 = l_cag.cag01
             AND cxh011= l_cxh011
             AND cxh012= l_cag.cag06
             AND cxh02 = l_cxh.cxh02
             AND cxh03 = l_cxh.cxh03
             AND cxh04 = l_cxh.cxh04
             AND cxh06 = l_cxh.cxh06   #FUN-7C0028 add
             AND cxh07 = l_cxh.cxh07   #FUN-7C0028 add
             AND cxh013= l_cag.cag012  #FUN-A60095
             AND cxh014= l_cag.cag05   #FUN-A60095
          IF l_cnt = 0 THEN
             LET l_cxh01_old = l_cxh.cxh01
             LET l_cxh.cxh01 = l_cag.cag01
             LET l_cxh012 = l_cag.cag06
             CALL work_2_22_cxh31('4',l_cxh.*,l_cxh011,l_cxh012,0)
             LET l_cxh.cxh01 = l_cxh01_old
          END IF
       END IF
 
       #轉下製程 (入項金額*轉出比率)
       #當出項合計數量大於入項合計數量時(因為有BONUS的問題),
       #出項合計金額會變成大於入項合計金額,需調整差異於轉下製程金額
       IF (l_cxh.cxh31+l_cxh.cxh35+l_cxh.cxh37+l_cxh.cxh39)*(-1) > 
          (l_cxh.cxh11+l_cxh.cxh21+l_cxh.cxh24+l_cxh.cxh26) THEN  
          LET l_cxh.cxh32 =(l_cxh.cxh12+l_cxh.cxh22+l_cxh.cxh25+l_cxh.cxh27)
                            *(l_cxh.cxh31/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                           l_cxh.cxh26))
          LET l_cxh.cxh32a=l_cxh.cxh32a-
                           (l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)
                          +(l_cxh.cxh36a+l_cxh.cxh38a+l_cxh.cxh40a)
          LET l_cxh.cxh32b=l_cxh.cxh32b-
                           (l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b + l_cxh.cxh27b)
                          +(l_cxh.cxh36b+l_cxh.cxh38b+l_cxh.cxh40b)
          LET l_cxh.cxh32c=l_cxh.cxh32c-
                           (l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+ l_cxh.cxh27c)
                          +(l_cxh.cxh36c+l_cxh.cxh38c+l_cxh.cxh40c)
          LET l_cxh.cxh32d=l_cxh.cxh32d-
                           (l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d)
                          +(l_cxh.cxh36d+l_cxh.cxh38d+l_cxh.cxh40d)
          LET l_cxh.cxh32e=l_cxh.cxh32e-
                           (l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e+l_cxh.cxh27e)
                          +(l_cxh.cxh36e+l_cxh.cxh38e+l_cxh.cxh40e)
       ELSE
          LET l_cxh.cxh32 =(l_cxh.cxh12+l_cxh.cxh22+l_cxh.cxh25+l_cxh.cxh27)
                            *(l_cxh.cxh31/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                           l_cxh.cxh26))
          LET l_cxh.cxh32a=(l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)
                            *(l_cxh.cxh31/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                          l_cxh.cxh26))
          LET l_cxh.cxh32b=(l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b + l_cxh.cxh27b)
                            *(l_cxh.cxh31/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                          l_cxh.cxh26))
          LET l_cxh.cxh32c = (l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+ l_cxh.cxh27c)
                            *(l_cxh.cxh31/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                          l_cxh.cxh26))
          LET l_cxh.cxh32d =(l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d)
                            *(l_cxh.cxh31/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                          l_cxh.cxh26))
          LET l_cxh.cxh32e = (l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e+l_cxh.cxh27e)
                            *(l_cxh.cxh31/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                          l_cxh.cxh26))
       END IF 
 
       CALL work_2_22_cxh31('1',l_cxh.*,'','',0)    #FUN-660142 add
 
       # 報廢
       LET l_cxh.cxh34 = (l_cxh.cxh12 + l_cxh.cxh22+l_cxh.cxh25+l_cxh.cxh27)
                         *(l_cxh.cxh33/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                       l_cxh.cxh26))
       LET l_cxh.cxh34a =(l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)
                         *(l_cxh.cxh33/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                       l_cxh.cxh26))
       LET l_cxh.cxh34b = (l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b+l_cxh.cxh27b)
                         *(l_cxh.cxh33/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                       l_cxh.cxh26))
       LET l_cxh.cxh34c =(l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+l_cxh.cxh27c)
                         *(l_cxh.cxh33/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                       l_cxh.cxh26))
       LET l_cxh.cxh34d = (l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d)
                         *(l_cxh.cxh33/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                       l_cxh.cxh26))
       LET l_cxh.cxh34e = (l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e +l_cxh.cxh27e)
                         *(l_cxh.cxh33/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+
                                       l_cxh.cxh26))
 
       CALL work_2_22_cxh31('2',l_cxh.*,'','',0)    #FUN-660142 add
 
       #工單轉出量
       LET l_cxh.cxh36 =(l_cxh.cxh12+l_cxh.cxh22+l_cxh.cxh25+l_cxh.cxh27) *
           (l_cxh.cxh35/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh36a=(l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)*
           (l_cxh.cxh35/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh36b=(l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b+l_cxh.cxh27b)*
           (l_cxh.cxh35/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh36c=(l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+l_cxh.cxh27c)*
           (l_cxh.cxh35/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh36d=(l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d) *
           (l_cxh.cxh35/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh36e=(l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e+l_cxh.cxh27e)*
           (l_cxh.cxh35/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
 
       #當站下線
       LET l_cxh.cxh38 = (l_cxh.cxh12+l_cxh.cxh22+l_cxh.cxh25 + l_cxh.cxh27)
          *(l_cxh.cxh37/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh38a =(l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)
          *(l_cxh.cxh37/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh38b = (l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b+l_cxh.cxh27b)
          *(l_cxh.cxh37/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh38c =(l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+l_cxh.cxh27c)
          *(l_cxh.cxh37/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh38d = (l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d)
          *(l_cxh.cxh37/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh38e = (l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e+l_cxh.cxh27e)
          *(l_cxh.cxh37/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
 
 
       #重工轉出的料工費,會被其它轉出量分攤掉了
       LET l_cxh.cxh40=0
       LET l_cxh.cxh40a=0
       LET l_cxh.cxh40b=0
       LET l_cxh.cxh40c=0
       LET l_cxh.cxh40d=0
       LET l_cxh.cxh40e=0
 
       #FUN-660180...............begin
       #重流轉出
       LET l_cxh.cxh40 = (l_cxh.cxh12+l_cxh.cxh22+l_cxh.cxh25 + l_cxh.cxh27)
          *(l_cxh.cxh39/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh40a =(l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)
          *(l_cxh.cxh39/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh40b = (l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b+l_cxh.cxh27b)
          *(l_cxh.cxh39/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh40c =(l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+l_cxh.cxh27c)
          *(l_cxh.cxh39/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh40d = (l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d)
          *(l_cxh.cxh39/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       LET l_cxh.cxh40e = (l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e+l_cxh.cxh27e)
          *(l_cxh.cxh39/(l_cxh.cxh11+l_cxh.cxh21+ l_cxh.cxh24+l_cxh.cxh26))
       #重流轉出數量
       IF l_cxh.cxh39<>0 THEN
          DECLARE work_2_22_3_c1 CURSOR FOR SELECT shb121,shb12,SUM(shb113)  #FUN-A60095
                                            FROM shb_file
                                           WHERE shb05=l_cxh.cxh01
                                             AND shb081=l_cxh.cxh012
                                             AND shb012=l_cxh.cxh013  #FUN-A60095
                                             AND shb06 =l_cxh.cxh014  #FUN-A60095
                                             AND shb113 IS NOT NULL
                                             AND shb113>0
                                             AND shbconf = 'Y'   #FUN-A70095  
                                           GROUP BY shb121,shb12,shb081 #FUN-A60095
          FOREACH work_2_22_3_c1 INTO l_shb121,l_shb12,l_shb113  #FUN-A60095
             CASE g_ccz.ccz06 #取成本中心
               WHEN '1' LET l_cxh011=g_sfb.sfb98  #年月
               WHEN '2' LET l_cxh011=g_sfb.sfb98  #成本中心
               WHEN '3' SELECT ecm04 INTO l_cxh011 FROM ecm_file
                            WHERE ecm01=g_sfb.sfb01
                              AND ecm03=l_shb12
                              AND ecm012=l_shb121  #FUN-A60095
               WHEN '4' SELECT ecm06 INTO l_cxh011 FROM ecm_file
                            WHERE ecm01=g_sfb.sfb01
                              AND ecm03=l_shb12
                              AND ecm012=l_shb121  #FUN-A60095
               EXIT CASE
             END CASE
             #取作業編號
             SELECT ecm04 INTO l_cxh012 FROM ecm_file
                            WHERE ecm01=g_sfb.sfb01
                              AND ecm03=l_shb12 
                              AND ecm012=l_shb121  #FUN-A60095
             CALL work_2_22_cxh31('3',l_cxh.*,l_cxh011,l_cxh012,l_shb113) 
          END FOREACH
       END IF
       IF cl_null(l_cxh.cxh32a) THEN LET l_cxh.cxh32a = 0 END IF
       IF cl_null(l_cxh.cxh32b) THEN LET l_cxh.cxh32b = 0 END IF
       IF cl_null(l_cxh.cxh32c) THEN LET l_cxh.cxh32c = 0 END IF
       IF cl_null(l_cxh.cxh32d) THEN LET l_cxh.cxh32d = 0 END IF
       IF cl_null(l_cxh.cxh32e) THEN LET l_cxh.cxh32e = 0 END IF
 
       IF cl_null(l_cxh.cxh34a) THEN LET l_cxh.cxh34a = 0 END IF
       IF cl_null(l_cxh.cxh34b) THEN LET l_cxh.cxh34b = 0 END IF
       IF cl_null(l_cxh.cxh34c) THEN LET l_cxh.cxh34c = 0 END IF
       IF cl_null(l_cxh.cxh34d) THEN LET l_cxh.cxh34d = 0 END IF
       IF cl_null(l_cxh.cxh34e) THEN LET l_cxh.cxh34e = 0 END IF
 
       IF cl_null(l_cxh.cxh36a) THEN LET l_cxh.cxh36a = 0 END IF
       IF cl_null(l_cxh.cxh36b) THEN LET l_cxh.cxh36b = 0 END IF
       IF cl_null(l_cxh.cxh36c) THEN LET l_cxh.cxh36c = 0 END IF
       IF cl_null(l_cxh.cxh36d) THEN LET l_cxh.cxh36d = 0 END IF
       IF cl_null(l_cxh.cxh36e) THEN LET l_cxh.cxh36e = 0 END IF
 
       IF cl_null(l_cxh.cxh38a) THEN LET l_cxh.cxh38a = 0 END IF
       IF cl_null(l_cxh.cxh38b) THEN LET l_cxh.cxh38b = 0 END IF
       IF cl_null(l_cxh.cxh38c) THEN LET l_cxh.cxh38c = 0 END IF
       IF cl_null(l_cxh.cxh38d) THEN LET l_cxh.cxh38d = 0 END IF
       IF cl_null(l_cxh.cxh38e) THEN LET l_cxh.cxh38e = 0 END IF
 
 
       IF cl_null(l_cxh.cxh40a) THEN LET l_cxh.cxh40a = 0 END IF
       IF cl_null(l_cxh.cxh40b) THEN LET l_cxh.cxh40b = 0 END IF
       IF cl_null(l_cxh.cxh40c) THEN LET l_cxh.cxh40c = 0 END IF
       IF cl_null(l_cxh.cxh40d) THEN LET l_cxh.cxh40d = 0 END IF
       IF cl_null(l_cxh.cxh40e) THEN LET l_cxh.cxh40e = 0 END IF
       LET l_cxh.cxh32 = l_cxh.cxh32a + l_cxh.cxh32b + l_cxh.cxh32c
                         + l_cxh.cxh32d + l_cxh.cxh32e
       LET l_cxh.cxh34 = l_cxh.cxh34a + l_cxh.cxh34b + l_cxh.cxh34c
                         + l_cxh.cxh34d + l_cxh.cxh34e
       LET l_cxh.cxh36 = l_cxh.cxh36a + l_cxh.cxh36b + l_cxh.cxh36c
                         + l_cxh.cxh36d + l_cxh.cxh36e
       LET l_cxh.cxh38 = l_cxh.cxh38a + l_cxh.cxh38b + l_cxh.cxh38c
                         + l_cxh.cxh38d + l_cxh.cxh38e
       LET l_cxh.cxh40 = l_cxh.cxh40a + l_cxh.cxh40b + l_cxh.cxh40c
                         + l_cxh.cxh40d + l_cxh.cxh40e
 
   #差異轉出量/結存重算
        #此判斷拿掉,避免只有料,但未投入工時的情況(未轉下製程cxh11-cxh39=0)
          IF mccg.ccg41 !=0 THEN
            LET l_cxh.cxh41=((l_cxh.cxh11 + l_cxh.cxh21 + l_cxh.cxh24+
                              l_cxh.cxh26 + l_cxh.cxh28)+
                              (l_cxh.cxh31 + l_cxh.cxh33 + l_cxh.cxh35+
                               l_cxh.cxh37 + l_cxh.cxh39))*-1
           LET l_cxh.cxh42a = ((l_cxh.cxh12a + l_cxh.cxh22a + l_cxh.cxh25a
                             + l_cxh.cxh27a + l_cxh.cxh29a)
                             + (l_cxh.cxh32a + l_cxh.cxh34a + l_cxh.cxh36a
                             + l_cxh.cxh38a + l_cxh.cxh40a))*-1
           LET l_cxh.cxh42b = ((l_cxh.cxh12b + l_cxh.cxh22b + l_cxh.cxh25b
                             + l_cxh.cxh27b + l_cxh.cxh29b)
                             + (l_cxh.cxh32b + l_cxh.cxh34b + l_cxh.cxh36b
                             + l_cxh.cxh38b + l_cxh.cxh40b))*-1
           LET l_cxh.cxh42c = ((l_cxh.cxh12c + l_cxh.cxh22c + l_cxh.cxh25c
                             + l_cxh.cxh27c + l_cxh.cxh29c)
                             + (l_cxh.cxh32c + l_cxh.cxh34c + l_cxh.cxh36c
                             + l_cxh.cxh38c + l_cxh.cxh40c))*-1
           LET l_cxh.cxh42d = ((l_cxh.cxh12d + l_cxh.cxh22d + l_cxh.cxh25d
                             + l_cxh.cxh27d + l_cxh.cxh29d)
                             + (l_cxh.cxh32d + l_cxh.cxh34d + l_cxh.cxh36d
                             + l_cxh.cxh38d + l_cxh.cxh40d))*-1
           LET l_cxh.cxh42e = ((l_cxh.cxh12e + l_cxh.cxh22e + l_cxh.cxh25e
                             + l_cxh.cxh27e + l_cxh.cxh29e)
                             + (l_cxh.cxh32e + l_cxh.cxh34e + l_cxh.cxh36e
                             + l_cxh.cxh38e + l_cxh.cxh40e))*-1
           LET l_cxh.cxh42=l_cxh.cxh42a+l_cxh.cxh42b+l_cxh.cxh42c+l_cxh.cxh42d+
                             l_cxh.cxh42e
        ELSE
            LET l_cxh.cxh41=0
            LET l_cxh.cxh42=0
            LET l_cxh.cxh42a=0
            LET l_cxh.cxh42b=0
            LET l_cxh.cxh42c=0
            LET l_cxh.cxh42d=0
            LET l_cxh.cxh42e=0
        END IF
 
       # WIP-元件 本期結存成本
       LET l_cxh.cxh91 = l_cxh.cxh11 + l_cxh.cxh21 + l_cxh.cxh24
                         + l_cxh.cxh26 + l_cxh.cxh28
                         + l_cxh.cxh31 + l_cxh.cxh33 + l_cxh.cxh35
                         + l_cxh.cxh37 + l_cxh.cxh39
                         + l_cxh.cxh41 + l_cxh.cxh59
       LET l_cxh.cxh92 = l_cxh.cxh12 + l_cxh.cxh22 + l_cxh.cxh25
                         + l_cxh.cxh27 + l_cxh.cxh29
                         + l_cxh.cxh32 + l_cxh.cxh34
                         + l_cxh.cxh36 + l_cxh.cxh38
                         + l_cxh.cxh40 + l_cxh.cxh42+l_cxh.cxh60
       LET l_cxh.cxh92a = l_cxh.cxh12a + l_cxh.cxh22a + l_cxh.cxh25a
                          + l_cxh.cxh27a + l_cxh.cxh29a
                          + l_cxh.cxh32a + l_cxh.cxh34a
                          + l_cxh.cxh36a + l_cxh.cxh38a
                          + l_cxh.cxh40a + l_cxh.cxh42a+l_cxh.cxh60a
       LET l_cxh.cxh92b = l_cxh.cxh12b + l_cxh.cxh22b + l_cxh.cxh25b
                          + l_cxh.cxh27b + l_cxh.cxh29b
                          + l_cxh.cxh32b + l_cxh.cxh34b
                          + l_cxh.cxh36b + l_cxh.cxh38b
                          + l_cxh.cxh40b + l_cxh.cxh42b+l_cxh.cxh60b
       LET l_cxh.cxh92c = l_cxh.cxh12c + l_cxh.cxh22c + l_cxh.cxh25c
                          + l_cxh.cxh27c + l_cxh.cxh29c
                          + l_cxh.cxh32c + l_cxh.cxh34c
                          + l_cxh.cxh36c + l_cxh.cxh38c
                          + l_cxh.cxh40c + l_cxh.cxh42c+l_cxh.cxh60c
       LET l_cxh.cxh92d = l_cxh.cxh12d + l_cxh.cxh22d + l_cxh.cxh25d
                          + l_cxh.cxh27d + l_cxh.cxh29d
                          + l_cxh.cxh32d + l_cxh.cxh34d
                          + l_cxh.cxh36d + l_cxh.cxh38d
                          + l_cxh.cxh40d + l_cxh.cxh42d + l_cxh.cxh60d
       LET l_cxh.cxh92e = l_cxh.cxh12e + l_cxh.cxh22e + l_cxh.cxh25e
                          + l_cxh.cxh27e + l_cxh.cxh29e
                          + l_cxh.cxh32e + l_cxh.cxh34e
                          + l_cxh.cxh36e + l_cxh.cxh38e
                          + l_cxh.cxh40e + l_cxh.cxh42e + l_cxh.cxh60e
       IF l_cxh.cxh91 < 0 THEN LET l_cxh.cxh91 = 0 END IF
       IF l_cxh.cxh92 < 0 THEN LET l_cxh.cxh92 = 0 END IF
       IF l_cxh.cxh92a < 0 THEN LET l_cxh.cxh92a = 0 END IF
       IF l_cxh.cxh92b < 0 THEN LET l_cxh.cxh92b = 0 END IF
       IF l_cxh.cxh92c < 0 THEN LET l_cxh.cxh92c = 0 END IF
       IF l_cxh.cxh92d < 0 THEN LET l_cxh.cxh92d = 0 END IF
       IF l_cxh.cxh92e < 0 THEN LET l_cxh.cxh92e = 0 END IF
 
       # 累計轉出 = 累計發料 - 期末在製
       LET l_cxh.cxh53 = l_cxh.cxh91 - l_cxh.cxh51
       LET l_cxh.cxh54 = l_cxh.cxh92 - l_cxh.cxh52
       LET l_cxh.cxh54a = l_cxh.cxh92a - l_cxh.cxh52a
       LET l_cxh.cxh54b = l_cxh.cxh92b - l_cxh.cxh52b
       LET l_cxh.cxh54c = l_cxh.cxh92c - l_cxh.cxh52c
       LET l_cxh.cxh54d = l_cxh.cxh92d - l_cxh.cxh52d
       LET l_cxh.cxh54e = l_cxh.cxh92e - l_cxh.cxh52e
 
       IF cl_null(l_cxh.cxh27) THEN LET l_cxh.cxh27 = 0 END IF   #TQC-7B0027 add
       IF cl_null(l_cxh.cxh54) THEN LET l_cxh.cxh54 = 0 END IF   #TQC-7B0027 add
       IF cl_null(l_cxh.cxh92) THEN LET l_cxh.cxh92 = 0 END IF   #TQC-7B0027 add
 
       UPDATE cxh_file SET * = l_cxh.*
          WHERE cxh01 = l_cxh.cxh01 #FUN-660180 add
            AND cxh011= l_cxh.cxh011 #FUN-660180 add
            AND cxh012= l_cxh.cxh012 #g_caf.caf06
            AND cxh02 = yy AND cxh03 = mm AND cxh04 = l_cxh.cxh04
            AND cxh06 = l_cxh.cxh06   #FUN-7C0028 add
            AND cxh07 = l_cxh.cxh07   #FUN-7C0028 add
            AND cxh013= l_cxh.cxh013  #FUN-A60095
            AND cxh014= l_cxh.cxh014  #FUN-A60095
       IF STATUS THEN 
          LET g_showmsg=l_cxh.cxh01,"/",l_cxh.cxh02                    #No.FUN-710027                                                          #No.FUN-710027
          CALL s_errmsg('cxh01,cxh02',g_showmsg,'upd cxh.*',STATUS,1)  #No.FUN-710027
       RETURN END IF
       IF l_cxh.cxh11 = 0 AND l_cxh.cxh12a = 0 AND l_cxh.cxh12b = 0 AND
          l_cxh.cxh12 = 0 AND l_cxh.cxh12c = 0 AND l_cxh.cxh12d = 0 AND
          l_cxh.cxh21 = 0 AND l_cxh.cxh22a = 0 AND l_cxh.cxh22b = 0 AND
          l_cxh.cxh22 = 0 AND l_cxh.cxh22c = 0 AND l_cxh.cxh22d = 0 AND
          l_cxh.cxh24 = 0 AND l_cxh.cxh25a = 0 AND l_cxh.cxh25b = 0 AND
          l_cxh.cxh25 = 0 AND l_cxh.cxh25c = 0 AND l_cxh.cxh25d = 0 AND
          l_cxh.cxh26 = 0 AND l_cxh.cxh27a = 0 AND l_cxh.cxh27b = 0 AND
          l_cxh.cxh27 = 0 AND l_cxh.cxh27c = 0 AND l_cxh.cxh27d = 0 AND
          l_cxh.cxh28 = 0 AND l_cxh.cxh29a = 0 AND l_cxh.cxh29b = 0 AND
          l_cxh.cxh29 = 0 AND l_cxh.cxh29c = 0 AND l_cxh.cxh29d = 0 AND
          l_cxh.cxh31 = 0 AND l_cxh.cxh32a = 0 AND l_cxh.cxh32b = 0 AND
          l_cxh.cxh32 = 0 AND l_cxh.cxh32c = 0 AND l_cxh.cxh32d = 0 AND
          l_cxh.cxh33 = 0 AND l_cxh.cxh34a = 0 AND l_cxh.cxh34b = 0 AND
          l_cxh.cxh34 = 0 AND l_cxh.cxh34c = 0 AND l_cxh.cxh34d = 0 AND
          l_cxh.cxh35 = 0 AND l_cxh.cxh36a = 0 AND l_cxh.cxh36b = 0 AND
          l_cxh.cxh36 = 0 AND l_cxh.cxh36c = 0 AND l_cxh.cxh36d = 0 AND
          l_cxh.cxh37 = 0 AND l_cxh.cxh38a = 0 AND l_cxh.cxh38b = 0 AND
          l_cxh.cxh38 = 0 AND l_cxh.cxh38c = 0 AND l_cxh.cxh38d = 0 AND
          l_cxh.cxh39 = 0 AND l_cxh.cxh40a = 0 AND l_cxh.cxh40b = 0 AND
          l_cxh.cxh40 = 0 AND l_cxh.cxh40c = 0 AND l_cxh.cxh40d = 0 AND
          l_cxh.cxh57 = 0 AND l_cxh.cxh58a = 0 AND l_cxh.cxh58b = 0 AND
          l_cxh.cxh58 = 0 AND l_cxh.cxh58c = 0 AND l_cxh.cxh58d = 0 AND
          l_cxh.cxh59 = 0 AND l_cxh.cxh60a = 0 AND l_cxh.cxh60b = 0 AND
          l_cxh.cxh60 = 0 AND l_cxh.cxh60c = 0 AND l_cxh.cxh60d = 0 AND
          l_cxh.cxh91 = 0 AND l_cxh.cxh92a = 0 AND l_cxh.cxh92b = 0 AND
          l_cxh.cxh92 = 0 AND l_cxh.cxh92c = 0 AND l_cxh.cxh92d = 0 THEN
          DELETE FROM cxh_file
           WHERE cxh01=g_sfb.sfb01 AND cxh012 =l_cxh.cxh012 #g_caf.caf06
             AND cxh02=yy   AND cxh03=mm AND cxh04=l_cxh.cxh04
             AND cxh06=type AND cxh07=g_tlfcost   #FUN-7C0028 add
             AND cxh013= l_cxh.cxh013  #FUN-A60095
             AND cxh014= l_cxh.cxh014  #FUN-A60095
       END IF
    END FOREACH
    CLOSE work_2_22_3_cur
END FUNCTION
 
FUNCTION work_2_22_cxh31(p_char,p_cxh,p_cxh011,p_cxh012,p_cxh28)
 DEFINE nex_cxh011 LIKE cxh_file.cxh011
 DEFINE nex_cxh012 LIKE cxh_file.cxh012
 DEFINE p_cxh011   LIKE cxh_file.cxh011 #FUN-660180 本次重工轉入的工作中心
 DEFINE p_cxh012   LIKE cxh_file.cxh012 #FUN-660180 本次重工轉入的作業編號
 DEFINE p_cxh28    LIKE cxh_file.cxh28  #FUN-660180 本次重工轉入的數量
 DEFINE p_char     LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
 DEFINE p_cxh      RECORD LIKE cxh_file.*
 DEFINE l_cxh2     RECORD LIKE cxh_file.*
 DEFINE nex_ecm012 LIKE ecm_file.ecm012 #FUN-A60095 
 DEFINE nex_ecm03  LIKE ecm_file.ecm03  #FUN-A60095 
    IF p_char='1' THEN
       IF p_cxh.cxh31 >= 0 THEN RETURN END IF
    END IF
    IF p_char='2' THEN
       IF p_cxh.cxh33 >= 0 THEN RETURN END IF
    END IF
    IF p_char='3' THEN
       IF p_cxh.cxh39 = 0 THEN RETURN END IF
    END IF
    IF p_char='4' THEN
       IF p_cxh.cxh26 = 0 THEN RETURN END IF
    END IF
    INITIALIZE l_cxh2.* TO NULL
 
    ### 上月結存
    LET l_cxh2.cxh11  = 0
    LET l_cxh2.cxh12  = 0 LET l_cxh2.cxh12a = 0 LET l_cxh2.cxh12b = 0
    LET l_cxh2.cxh12c = 0 LET l_cxh2.cxh12d = 0 LET l_cxh2.cxh12e = 0
    LET l_cxh2.cxh12f = 0 LET l_cxh2.cxh12g = 0 LET l_cxh2.cxh12h = 0   #FUN-7C0028 add
    # 本月投入
    LET l_cxh2.cxh21  = 0
    LET l_cxh2.cxh22  = 0 LET l_cxh2.cxh22a = 0 LET l_cxh2.cxh22b = 0
    LET l_cxh2.cxh22c = 0 LET l_cxh2.cxh22d = 0 LET l_cxh2.cxh22e = 0
    LET l_cxh2.cxh22f = 0 LET l_cxh2.cxh22g = 0 LET l_cxh2.cxh22h = 0   #FUN-7C0028 add
    # 本月前製程入
    LET l_cxh2.cxh24  = 0
    LET l_cxh2.cxh25  = 0 LET l_cxh2.cxh25a = 0 LET l_cxh2.cxh25b = 0 
    LET l_cxh2.cxh25c = 0 LET l_cxh2.cxh25d = 0 LET l_cxh2.cxh25e = 0
    LET l_cxh2.cxh25f = 0 LET l_cxh2.cxh25g = 0 LET l_cxh2.cxh25h = 0   #FUN-7C0028 add
    # 其他 工單轉入
    LET l_cxh2.cxh26  = 0
    LET l_cxh2.cxh27  = 0 LET l_cxh2.cxh27a = 0 LET l_cxh2.cxh27b = 0
    LET l_cxh2.cxh27c = 0 LET l_cxh2.cxh27d = 0 LET l_cxh2.cxh27e = 0
    LET l_cxh2.cxh27f = 0 LET l_cxh2.cxh27g = 0 LET l_cxh2.cxh27h = 0   #FUN-7C0028 add
    # 製程重工轉入
    LET l_cxh2.cxh28  = 0
    LET l_cxh2.cxh29  = 0 LET l_cxh2.cxh29a = 0 LET l_cxh2.cxh29b = 0
    LET l_cxh2.cxh29c = 0 LET l_cxh2.cxh29d = 0 LET l_cxh2.cxh29e = 0
    LET l_cxh2.cxh29f = 0 LET l_cxh2.cxh29g = 0 LET l_cxh2.cxh29h = 0   #FUN-7C0028 add
    # 本月轉下製程
    LET l_cxh2.cxh31  = 0
    LET l_cxh2.cxh32  = 0 LET l_cxh2.cxh32a = 0 LET l_cxh2.cxh32b = 0
    LET l_cxh2.cxh32c = 0 LET l_cxh2.cxh32d = 0 LET l_cxh2.cxh32e = 0
    LET l_cxh2.cxh32f = 0 LET l_cxh2.cxh32g = 0 LET l_cxh2.cxh32h = 0   #FUN-7C0028 add
    # 本月報廢
    LET l_cxh2.cxh33  = 0
    LET l_cxh2.cxh34  = 0 LET l_cxh2.cxh34a = 0 LET l_cxh2.cxh34b = 0
    LET l_cxh2.cxh34c = 0 LET l_cxh2.cxh34d = 0 LET l_cxh2.cxh34e = 0
    LET l_cxh2.cxh34f = 0 LET l_cxh2.cxh34g = 0 LET l_cxh2.cxh34h = 0   #FUN-7C0028 add
    #工單轉出
    LET l_cxh2.cxh35  = 0
    LET l_cxh2.cxh36  = 0 LET l_cxh2.cxh36a = 0 LET l_cxh2.cxh36b = 0
    LET l_cxh2.cxh36c = 0 LET l_cxh2.cxh36d = 0 LET l_cxh2.cxh36e = 0
    LET l_cxh2.cxh36f = 0 LET l_cxh2.cxh36g = 0 LET l_cxh2.cxh36h = 0   #FUN-7C0028 add
    # 當站下線
    LET l_cxh2.cxh37  = 0
    LET l_cxh2.cxh38  = 0 LET l_cxh2.cxh38a = 0 LET l_cxh2.cxh38b = 0
    LET l_cxh2.cxh38c = 0 LET l_cxh2.cxh38d = 0 LET l_cxh2.cxh38e = 0
    LET l_cxh2.cxh38f = 0 LET l_cxh2.cxh38g = 0 LET l_cxh2.cxh38h = 0   #FUN-7C0028 add
    # 重工轉出
    LET l_cxh2.cxh39  = 0
    LET l_cxh2.cxh40  = 0 LET l_cxh2.cxh40a = 0 LET l_cxh2.cxh40b = 0
    LET l_cxh2.cxh40c = 0 LET l_cxh2.cxh40d = 0 LET l_cxh2.cxh40e = 0
    LET l_cxh2.cxh40f = 0 LET l_cxh2.cxh40g = 0 LET l_cxh2.cxh40h = 0   #FUN-7C0028 add
    # 本月差異轉出
    LET l_cxh2.cxh41  = 0
    LET l_cxh2.cxh42  = 0 LET l_cxh2.cxh42a = 0 LET l_cxh2.cxh42b = 0
    LET l_cxh2.cxh42c = 0 LET l_cxh2.cxh42d = 0 LET l_cxh2.cxh42e = 0
    LET l_cxh2.cxh42f = 0 LET l_cxh2.cxh42g = 0 LET l_cxh2.cxh42h = 0   #FUN-7C0028 add
    # 累計投入
    LET l_cxh2.cxh51  = 0
    LET l_cxh2.cxh52  = 0 LET l_cxh2.cxh52a = 0 LET l_cxh2.cxh52b = 0
    LET l_cxh2.cxh52c = 0 LET l_cxh2.cxh52d = 0 LET l_cxh2.cxh52e = 0
    LET l_cxh2.cxh52f = 0 LET l_cxh2.cxh52g = 0 LET l_cxh2.cxh52h = 0   #FUN-7C0028 add
    # 累計轉出
    LET l_cxh2.cxh53  = 0
    LET l_cxh2.cxh54  = 0 LET l_cxh2.cxh54a = 0 LET l_cxh2.cxh54b = 0
    LET l_cxh2.cxh54c = 0 LET l_cxh2.cxh54d = 0 LET l_cxh2.cxh54e = 0
    LET l_cxh2.cxh54f = 0 LET l_cxh2.cxh54g = 0 LET l_cxh2.cxh54h = 0   #FUN-7C0028 add
    # 累計超領退
    LET l_cxh2.cxh55  = 0
    LET l_cxh2.cxh56  = 0 LET l_cxh2.cxh56a = 0 LET l_cxh2.cxh56b = 0
    LET l_cxh2.cxh56c = 0 LET l_cxh2.cxh56d = 0 LET l_cxh2.cxh56e = 0
    LET l_cxh2.cxh56f = 0 LET l_cxh2.cxh56g = 0 LET l_cxh2.cxh56h = 0   #FUN-7C0028 add
    # 本月超領退
    LET l_cxh2.cxh57  = 0
    LET l_cxh2.cxh58  = 0 LET l_cxh2.cxh58a = 0 LET l_cxh2.cxh58b = 0
    LET l_cxh2.cxh58c = 0 LET l_cxh2.cxh58d = 0 LET l_cxh2.cxh58e = 0
    LET l_cxh2.cxh58f = 0 LET l_cxh2.cxh58g = 0 LET l_cxh2.cxh58h = 0   #FUN-7C0028 add
    # 盤差
    LET l_cxh2.cxh59  = 0
    LET l_cxh2.cxh60  = 0 LET l_cxh2.cxh60a = 0 LET l_cxh2.cxh60b = 0
    LET l_cxh2.cxh60c = 0 LET l_cxh2.cxh60d = 0 LET l_cxh2.cxh60e = 0
    LET l_cxh2.cxh60f = 0 LET l_cxh2.cxh60g = 0 LET l_cxh2.cxh60h = 0   #FUN-7C0028 add
    # 本月結存
    LET l_cxh2.cxh91  = 0
    LET l_cxh2.cxh92  = 0 LET l_cxh2.cxh92a = 0 LET l_cxh2.cxh92b = 0
    LET l_cxh2.cxh92c = 0 LET l_cxh2.cxh92d = 0 LET l_cxh2.cxh92e = 0
    LET l_cxh2.cxh92f = 0 LET l_cxh2.cxh92g = 0 LET l_cxh2.cxh92h = 0   #FUN-7C0028 add
 
    LET nex_cxh012=''
   #FUN-A60095(S) 
   #SELECT ecm04 INTO nex_cxh012 FROM ecm_file
   # WHERE ecm01=g_sfb.sfb01
   #   AND ecm03=(SELECT MIN(ecm03) FROM ecm_file
   #               WHERE ecm01=g_sfb.sfb01
   #                 AND ecm03> g_ecm.ecm03)
    CALL s_schdat_next_ecm03(g_sfb.sfb01,g_ecm.ecm012,g_ecm.ecm03)
         RETURNING nex_ecm012,nex_ecm03
    SELECT ecm04 INTO nex_cxh012 FROM ecm_file
     WHERE ecm01=g_sfb.sfb01
       AND ecm012=nex_ecm012
       AND ecm03 =nex_ecm03
   #FUN-A60095(E) 
 
    #FUN-660180...............begin
     ## 人工製費工時輸入方式1.年月成本中心2.年月作業編號
     ##                     3.年月工作中心
     CASE
        WHEN p_char MATCHES '[1,2]'
           CASE g_ccz.ccz06
             WHEN '1' LET nex_cxh011=g_sfb.sfb98  #年月
             WHEN '2' LET nex_cxh011=g_sfb.sfb98  #成本中心
             WHEN '3' 
                     #FUN-A60095(S)
                     #SELECT ecm04 INTO nex_cxh011 FROM ecm_file
                     #    WHERE ecm01=g_sfb.sfb01
                     #      AND ecm03=(SELECT MIN(ecm03) FROM ecm_file
                     #                  WHERE ecm01=g_sfb.sfb01
                     #                    AND ecm03> g_ecm.ecm03)
                     CALL s_schdat_next_ecm03(g_sfb.sfb01,g_ecm.ecm012,g_ecm.ecm03)
                          RETURNING nex_ecm012,nex_ecm03
                     SELECT ecm04 INTO nex_cxh011 FROM ecm_file
                      WHERE ecm01=g_sfb.sfb01
                        AND ecm012=nex_ecm012
                        AND ecm03 =nex_ecm03
                     #FUN-A60095(E)
             WHEN '4' 
                     #FUN-A60095(S)
                     #SELECT ecm06 INTO nex_cxh011 FROM ecm_file
                     #    WHERE ecm01=g_sfb.sfb01
                     #      AND ecm03=(SELECT MIN(ecm03) FROM ecm_file
                     #                  WHERE ecm01=g_sfb.sfb01
                     #                    AND ecm03> g_ecm.ecm03)
                     CALL s_schdat_next_ecm03(g_sfb.sfb01,g_ecm.ecm012,g_ecm.ecm03)
                          RETURNING nex_ecm012,nex_ecm03
                     SELECT ecm06 INTO nex_cxh011 FROM ecm_file
                      WHERE ecm01=g_sfb.sfb01
                        AND ecm012=nex_ecm012
                        AND ecm03 =nex_ecm03
                     #FUN-A60095(E)
             EXIT CASE
           END CASE
        WHEN p_char MATCHES '[3,4]'   #FUN-670016 add 4
           LET nex_cxh011=p_cxh011
           LET nex_cxh012=p_cxh012
     END CASE
   IF cl_null(nex_cxh012) THEN LET nex_cxh012=' ' END IF
   IF (p_cxh.cxh31 < 0  AND nex_cxh012 <> ' ') OR p_char='3' OR p_char='4' THEN   #FUN-670016   #FUN-680044
       LET l_cxh2.cxh01  =  p_cxh.cxh01
       LET l_cxh2.cxh011 =  nex_cxh011 #FUN-660180
       LET l_cxh2.cxh012 =  nex_cxh012
       LET l_cxh2.cxh02  =  p_cxh.cxh02
       LET l_cxh2.cxh03  =  p_cxh.cxh03
       LET l_cxh2.cxh04  =  p_cxh.cxh04
       LET l_cxh2.cxh05  =  p_cxh.cxh05
       LET l_cxh2.cxh06  =  p_cxh.cxh06   #FUN-7C0028 add
       LET l_cxh2.cxh07  =  p_cxh.cxh07   #FUN-7C0028 add
       LET l_cxh2.cxh013 =  g_ecm.ecm012  #FUN-A60095
       LET l_cxh2.cxh014 =  g_ecm.ecm03   #FUN-A60095

       SELECT COUNT(*) INTO g_cnt FROM cxh_file
        WHERE cxh01  =  l_cxh2.cxh01
          AND cxh011 =  l_cxh2.cxh011
          AND cxh012 =  l_cxh2.cxh012
          AND cxh02  =  l_cxh2.cxh02
          AND cxh03  =  l_cxh2.cxh03
          AND cxh04  =  l_cxh2.cxh04
          AND cxh06  =  l_cxh2.cxh06   #FUN-7C0028 add
          AND cxh07  =  l_cxh2.cxh07   #FUN-7C0028 add
          AND cxh013 =  l_cxh2.cxh013  #FUN-A60095
          AND cxh014 =  l_cxh2.cxh014  #FUN-A60095
       IF g_cnt > 0 THEN
          SELECT * INTO l_cxh2.* FROM cxh_file
           WHERE cxh01  =  l_cxh2.cxh01
             AND cxh011 =  l_cxh2.cxh011
             AND cxh012 =  l_cxh2.cxh012
             AND cxh02  =  l_cxh2.cxh02
             AND cxh03  =  l_cxh2.cxh03
             AND cxh04  =  l_cxh2.cxh04
             AND cxh06  =  l_cxh2.cxh06   #FUN-7C0028 add
             AND cxh07  =  l_cxh2.cxh07   #FUN-7C0028 add
             AND cxh013 =  l_cxh2.cxh013  #FUN-A60095
             AND cxh014 =  l_cxh2.cxh014  #FUN-A60095
       END IF
       IF p_char='1' THEN  #前製程轉入
         LET l_cxh2.cxh24  = l_cxh2.cxh24  + p_cxh.cxh31*-1
         LET l_cxh2.cxh25  = l_cxh2.cxh25  + p_cxh.cxh32*-1
         LET l_cxh2.cxh25a = l_cxh2.cxh25a + p_cxh.cxh32a*-1
         LET l_cxh2.cxh25b = l_cxh2.cxh25b + p_cxh.cxh32b*-1
         LET l_cxh2.cxh25c = l_cxh2.cxh25c + p_cxh.cxh32c*-1
         LET l_cxh2.cxh25d = l_cxh2.cxh25d + p_cxh.cxh32d*-1
         LET l_cxh2.cxh25e = l_cxh2.cxh25e + p_cxh.cxh32e*-1
         LET l_cxh2.cxh25f = l_cxh2.cxh25f + p_cxh.cxh32f*-1   #FUN-7C0028 add
         LET l_cxh2.cxh25g = l_cxh2.cxh25g + p_cxh.cxh32g*-1   #FUN-7C0028 add
         LET l_cxh2.cxh25h = l_cxh2.cxh25h + p_cxh.cxh32h*-1   #FUN-7C0028 add
       END IF
       IF p_char='2' THEN  #報廢轉入
         LET l_cxh2.cxh25  = l_cxh2.cxh25  + p_cxh.cxh34*-1
         LET l_cxh2.cxh25a = l_cxh2.cxh25a + p_cxh.cxh34a*-1
         LET l_cxh2.cxh25b = l_cxh2.cxh25b + p_cxh.cxh34b*-1
         LET l_cxh2.cxh25c = l_cxh2.cxh25c + p_cxh.cxh34c*-1
         LET l_cxh2.cxh25d = l_cxh2.cxh25d + p_cxh.cxh34d*-1
         LET l_cxh2.cxh25e = l_cxh2.cxh25e + p_cxh.cxh34e*-1
         LET l_cxh2.cxh25f = l_cxh2.cxh25f + p_cxh.cxh34f*-1   #FUN-7C0028 add
         LET l_cxh2.cxh25g = l_cxh2.cxh25g + p_cxh.cxh34g*-1   #FUN-7C0028 add
         LET l_cxh2.cxh25h = l_cxh2.cxh25h + p_cxh.cxh34h*-1   #FUN-7C0028 add
       END IF
       IF p_char='3' THEN  #重工轉入
         LET l_cxh2.cxh28  = l_cxh2.cxh28  + p_cxh28  #p_cxh.cxh39*-1
         LET l_cxh2.cxh29  = l_cxh2.cxh29  + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40 *-1
         LET l_cxh2.cxh29a = l_cxh2.cxh29a + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40a*-1
         LET l_cxh2.cxh29b = l_cxh2.cxh29b + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40b*-1
         LET l_cxh2.cxh29c = l_cxh2.cxh29c + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40c*-1
         LET l_cxh2.cxh29d = l_cxh2.cxh29d + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40d*-1
         LET l_cxh2.cxh29e = l_cxh2.cxh29e + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40e*-1
         LET l_cxh2.cxh29f = l_cxh2.cxh29f + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40f*-1   #FUN-7C0028 add
         LET l_cxh2.cxh29g = l_cxh2.cxh29g + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40g*-1   #FUN-7C0028 add
         LET l_cxh2.cxh29h = l_cxh2.cxh29h + (p_cxh28/p_cxh.cxh39*-1)*p_cxh.cxh40h*-1   #FUN-7C0028 add
       END IF
       IF p_char='4' THEN  #工單轉入
         LET l_cxh2.cxh26  = l_cxh2.cxh26  + p_cxh.cxh26
         LET l_cxh2.cxh27  = l_cxh2.cxh27  + p_cxh.cxh27
         LET l_cxh2.cxh27a = l_cxh2.cxh27a + p_cxh.cxh27a
         LET l_cxh2.cxh27b = l_cxh2.cxh27b + p_cxh.cxh27b
         LET l_cxh2.cxh27c = l_cxh2.cxh27c + p_cxh.cxh27c
         LET l_cxh2.cxh27d = l_cxh2.cxh27d + p_cxh.cxh27d
         LET l_cxh2.cxh27e = l_cxh2.cxh27e + p_cxh.cxh27e
         LET l_cxh2.cxh27f = l_cxh2.cxh27f + p_cxh.cxh27f   #FUN-7C0028 add
         LET l_cxh2.cxh27g = l_cxh2.cxh27g + p_cxh.cxh27g   #FUN-7C0028 add
         LET l_cxh2.cxh27h = l_cxh2.cxh27h + p_cxh.cxh27h   #FUN-7C0028 add
       END IF
       # WIP-元件 本期結存成本
       LET l_cxh2.cxh91 = l_cxh2.cxh11  + l_cxh2.cxh21  + l_cxh2.cxh24
                        + l_cxh2.cxh26  + l_cxh2.cxh28
                        + l_cxh2.cxh31  + l_cxh2.cxh33  + l_cxh2.cxh35
                        + l_cxh2.cxh37  + l_cxh2.cxh39
                        + l_cxh2.cxh41  + l_cxh2.cxh59
       LET l_cxh2.cxh92 = l_cxh2.cxh12  + l_cxh2.cxh22  + l_cxh2.cxh25
                        + l_cxh2.cxh27  + l_cxh2.cxh29
                        + l_cxh2.cxh32  + l_cxh2.cxh34
                        + l_cxh2.cxh36  + l_cxh2.cxh38
                        + l_cxh2.cxh40  + l_cxh2.cxh42  + l_cxh2.cxh60
       LET l_cxh2.cxh92a= l_cxh2.cxh12a + l_cxh2.cxh22a + l_cxh2.cxh25a
                        + l_cxh2.cxh27a + l_cxh2.cxh29a
                        + l_cxh2.cxh32a + l_cxh2.cxh34a
                        + l_cxh2.cxh36a + l_cxh2.cxh38a
                        + l_cxh2.cxh40a + l_cxh2.cxh42a + l_cxh2.cxh60a
       LET l_cxh2.cxh92b= l_cxh2.cxh12b + l_cxh2.cxh22b + l_cxh2.cxh25b
                        + l_cxh2.cxh27b + l_cxh2.cxh29b
                        + l_cxh2.cxh32b + l_cxh2.cxh34b
                        + l_cxh2.cxh36b + l_cxh2.cxh38b
                        + l_cxh2.cxh40b + l_cxh2.cxh42b + l_cxh2.cxh60b
       LET l_cxh2.cxh92c= l_cxh2.cxh12c + l_cxh2.cxh22c + l_cxh2.cxh25c
                        + l_cxh2.cxh27c + l_cxh2.cxh29c
                        + l_cxh2.cxh32c + l_cxh2.cxh34c
                        + l_cxh2.cxh36c + l_cxh2.cxh38c
                        + l_cxh2.cxh40c + l_cxh2.cxh42c + l_cxh2.cxh60c
       LET l_cxh2.cxh92d= l_cxh2.cxh12d + l_cxh2.cxh22d + l_cxh2.cxh25d
                        + l_cxh2.cxh27d + l_cxh2.cxh29d
                        + l_cxh2.cxh32d + l_cxh2.cxh34d
                        + l_cxh2.cxh36d + l_cxh2.cxh38d
                        + l_cxh2.cxh40d + l_cxh2.cxh42d + l_cxh2.cxh60d
       LET l_cxh2.cxh92e= l_cxh2.cxh12e + l_cxh2.cxh22e + l_cxh2.cxh25e
                        + l_cxh2.cxh27e + l_cxh2.cxh29e
                        + l_cxh2.cxh32e + l_cxh2.cxh34e
                        + l_cxh2.cxh36e + l_cxh2.cxh38e
                        + l_cxh2.cxh40e + l_cxh2.cxh42e + l_cxh2.cxh60e
       LET l_cxh2.cxh92f= l_cxh2.cxh12f + l_cxh2.cxh22f + l_cxh2.cxh25f
                        + l_cxh2.cxh27f + l_cxh2.cxh29f
                        + l_cxh2.cxh32f + l_cxh2.cxh34f
                        + l_cxh2.cxh36f + l_cxh2.cxh38f
                        + l_cxh2.cxh40f + l_cxh2.cxh42f + l_cxh2.cxh60f
       LET l_cxh2.cxh92g= l_cxh2.cxh12g + l_cxh2.cxh22g + l_cxh2.cxh25g
                        + l_cxh2.cxh27g + l_cxh2.cxh29g
                        + l_cxh2.cxh32g + l_cxh2.cxh34g
                        + l_cxh2.cxh36g + l_cxh2.cxh38g
                        + l_cxh2.cxh40g + l_cxh2.cxh42g + l_cxh2.cxh60g
       LET l_cxh2.cxh92h= l_cxh2.cxh12h + l_cxh2.cxh22h + l_cxh2.cxh25h
                        + l_cxh2.cxh27h + l_cxh2.cxh29h
                        + l_cxh2.cxh32h + l_cxh2.cxh34h
                        + l_cxh2.cxh36h + l_cxh2.cxh38h
                        + l_cxh2.cxh40h + l_cxh2.cxh42h + l_cxh2.cxh60h
 
       IF l_cxh2.cxh91 < 0  THEN LET l_cxh2.cxh91 = 0  END IF
       IF l_cxh2.cxh92 < 0  THEN LET l_cxh2.cxh92 = 0  END IF
       IF l_cxh2.cxh92a < 0 THEN LET l_cxh2.cxh92a = 0 END IF
       IF l_cxh2.cxh92b < 0 THEN LET l_cxh2.cxh92b = 0 END IF
       IF l_cxh2.cxh92c < 0 THEN LET l_cxh2.cxh92c = 0 END IF
       IF l_cxh2.cxh92d < 0 THEN LET l_cxh2.cxh92d = 0 END IF
       IF l_cxh2.cxh92e < 0 THEN LET l_cxh2.cxh92e = 0 END IF
       IF l_cxh2.cxh92f < 0 THEN LET l_cxh2.cxh92f = 0 END IF   #FUN-7C0028 add
       IF l_cxh2.cxh92g < 0 THEN LET l_cxh2.cxh92g = 0 END IF   #FUN-7C0028 add
       IF l_cxh2.cxh92h < 0 THEN LET l_cxh2.cxh92h = 0 END IF   #FUN-7C0028 add
 
       # 累計轉出 = 累計發料 - 期末在製
       LET l_cxh2.cxh53  = l_cxh2.cxh91 - l_cxh2.cxh51
       LET l_cxh2.cxh54  = l_cxh2.cxh92 - l_cxh2.cxh52
       LET l_cxh2.cxh54a = l_cxh2.cxh92a - l_cxh2.cxh52a
       LET l_cxh2.cxh54b = l_cxh2.cxh92b - l_cxh2.cxh52b
       LET l_cxh2.cxh54c = l_cxh2.cxh92c - l_cxh2.cxh52c
       LET l_cxh2.cxh54d = l_cxh2.cxh92d - l_cxh2.cxh52d
       LET l_cxh2.cxh54e = l_cxh2.cxh92e - l_cxh2.cxh52e
       LET l_cxh2.cxh54f = l_cxh2.cxh92f - l_cxh2.cxh52f   #FUN-7C0028 add
       LET l_cxh2.cxh54g = l_cxh2.cxh92g - l_cxh2.cxh52g   #FUN-7C0028 add
       LET l_cxh2.cxh54h = l_cxh2.cxh92h - l_cxh2.cxh52h   #FUN-7C0028 add
 
      #LET l_cxh2.cxhplant = g_plant #FUN-980009 add       #FUN-A50075
       LET l_cxh2.cxhlegal = g_legal #FUN-980009 add
       IF g_cnt > 0 THEN
          UPDATE cxh_file SET * = l_cxh2.*
             WHERE cxh01  = l_cxh2.cxh01
               AND cxh011 = l_cxh2.cxh011
               AND cxh012 = l_cxh2.cxh012
               AND cxh02  = l_cxh2.cxh02
               AND cxh03  = l_cxh2.cxh03
               AND cxh04  = l_cxh2.cxh04
               AND cxh06  = l_cxh2.cxh06   #FUN-7C0028 add
               AND cxh07  = l_cxh2.cxh07   #FUN-7C0028 add
               AND cxh013 = l_cxh2.cxh013  #FUN-A60095
               AND cxh014 = l_cxh2.cxh014  #FUN-A60095
          #FUN-A60095(S)
          IF SQLCA.sqlerrd[3]=0 THEN 
             LET g_showmsg=l_cxh2.cxh01,"/",l_cxh2.cxh011
             CALL s_errmsg('cxh01,cxh011',g_showmsg,'upd or ins cxh.*',STATUS,1)
             RETURN 
          END IF 
          #FUN-A60095(E)
       ELSE
          LET l_cxh2.cxhoriu = g_user      #No.FUN-980030 10/01/04
          LET l_cxh2.cxhorig = g_grup      #No.FUN-980030 10/01/04
          IF l_cxh2.cxh013 IS NULL THEN LET l_cxh2.cxh013=' ' END IF #FUN-A60095
          IF l_cxh2.cxh014 IS NULL THEN LET l_cxh2.cxh014=0   END IF #FUN-A60095
          INSERT INTO cxh_file VALUES (l_cxh2.*)
          IF STATUS THEN 
             LET g_showmsg=l_cxh2.cxh01,"/",l_cxh2.cxh011                                                                #No.FUN-710027
             CALL s_errmsg('cxh01,cxh011',g_showmsg,'upd or ins cxh.*',STATUS,1)                                         #No.FUN-710027
             RETURN 
          END IF 
       END IF
   END IF
END FUNCTION
 
FUNCTION work_2_1()      # WIP-元件 上期期末轉本期期初
   DEFINE l_cxf         RECORD LIKE cxf_file.*
   DEFINE l_sql         LIKE type_file.chr1000	        #No.FUN-680122 VARCHAR(300)
   DEFINE l_p01         LIKE cxh_file.cxh01,         #No.FUN-680122 VARCHAR(16),      #No.FUN-550025
          l_p02         LIKE type_file.num5,         #No.FUN-680122 SMALLINT,
          l_p03         LIKE cxh_file.cxh012,         #No.FUN-680122 VARCHAR(6),
#         l_source_out,l_source_out2  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
          l_source_out,l_source_out2  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          l_rate        LIKE ima_file.ima18,         #No.FUN-680122 DEC(9,3),
          l_p04         LIKE type_file.chr20         #No.FUN-680122 VARCHAR(10)
   DEFINE l_po13        LIKE cxh_file.cxh013  #FUN-A60095

   DECLARE work_c2 CURSOR FOR
      SELECT * FROM cxh_file
       WHERE cxh01=g_sfb.sfb01
         AND cxh02=last_yy AND cxh03=last_mm
         AND cxh06=type    AND cxh07=g_tlfcost   #FUN-7C0028 add
         AND cxh012=g_ecm.ecm04   #g_caf.caf06    #作業編號
         AND cxh013=g_ecm.ecm012  #FUN-A60095
         AND cxh014=g_ecm.ecm03   #FUN-A60095
   FOREACH work_c2 INTO g_cxh.*
     CALL p510_cxh_0()  # 上期期末轉本期期初, 將 cch 歸 0
     LET g_cxh.cxhdate = g_today
    #LET g_cxh.cxhplant = g_plant #FUN-980009 add    #FUN-A50075
     LET g_cxh.cxhlegal = g_legal #FUN-980009 add
     LET g_cxh.cxhoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cxh.cxhorig = g_grup      #No.FUN-980030 10/01/04
     IF g_cxh.cxh013 IS NULL THEN LET g_cxh.cxh013=' ' END IF #FUN-A60095
     IF g_cxh.cxh014 IS NULL THEN LET g_cxh.cxh014=0   END IF #FUN-A60095
     INSERT INTO cxh_file VALUES (g_cxh.*)
     IF STATUS THEN 
        LET g_showmsg=g_cxh.cxh01,"/",g_cxh.cxh011                                                          #No.FUN-710027
        CALL s_errmsg('cxh01,cxh011',g_showmsg,'ins cxh(1)',STATUS,1)                                       #No.FUN-710027 
     END IF
   END FOREACH
   CLOSE work_c2
 
   # WIP-元件 期初開帳轉本期期初
   LET l_sql=" SELECT * FROM cxf_file WHERE cxf01='",g_sfb.sfb01,"' ",
             "  AND cxf02=",last_yy," AND cxf03=",last_mm,
             "  AND cxf06='",type,"'  AND cxf07='",g_tlfcost,"'",   #FUN-7C0028 add
             "  AND (cxf04 !=' ' AND cxf04 IS NOT NULL) ",
             "  AND cxf012='",g_ecm.ecm04,"' "CLIPPED
   PREPARE work_c2_pre FROM l_sql
   DECLARE work_c2_cxf CURSOR FOR work_c2_pre
 
   FOREACH work_c2_cxf INTO l_cxf.*
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','wip_c2_cxf',SQLCA.sqlcode,0)   #No.FUN-710027 
        EXIT FOREACH
     END IF
     CALL p510_cxh_01() # 將 cch 歸 0
     LET g_cxh.cxh01 =g_sfb.sfb01
     LET g_cxh.cxh02 =yy
     LET g_cxh.cxh03 =mm
     LET g_cxh.cxh06 =type           #FUN-7C0028 add
     LET g_cxh.cxh07 =l_cxf.cxf07    #FUN-7C0028 add
     LET g_cxh.cxh012=g_ecm.ecm04    #g_caf.caf06
     LET g_cxh.cxh04 =l_cxf.cxf04
     LET g_cxh.cxh05 =l_cxf.cxf05
     LET g_cxh.cxh11 =l_cxf.cxf11
     LET g_cxh.cxh12 =l_cxf.cxf12
     LET g_cxh.cxh12a=l_cxf.cxf12a
     LET g_cxh.cxh12b=l_cxf.cxf12b
     LET g_cxh.cxh12c=l_cxf.cxf12c
     LET g_cxh.cxh12d=l_cxf.cxf12d
     LET g_cxh.cxh12e=l_cxf.cxf12e
     LET g_cxh.cxh12f=l_cxf.cxf12f   #FUN-7C0028 add
     LET g_cxh.cxh12g=l_cxf.cxf12g   #FUN-7C0028 add
     LET g_cxh.cxh12h=l_cxf.cxf12h   #FUN-7C0028 add
     LET g_cxh.cxh91 =l_cxf.cxf11
     LET g_cxh.cxh92 =l_cxf.cxf12
     LET g_cxh.cxh92a=l_cxf.cxf12a
     LET g_cxh.cxh92b=l_cxf.cxf12b
     LET g_cxh.cxh92c=l_cxf.cxf12c
     LET g_cxh.cxh92d=l_cxf.cxf12d
     LET g_cxh.cxh92e=l_cxf.cxf12e
     LET g_cxh.cxh92f=l_cxf.cxf12f   #FUN-7C0028 add
     LET g_cxh.cxh92g=l_cxf.cxf12g   #FUN-7C0028 add
     LET g_cxh.cxh92h=l_cxf.cxf12h   #FUN-7C0028 add
     LET g_cxh.cxhdate = g_today
    #LET g_cxh.cxhplant = g_plant #FUN-980009 add    #FUN-A50075
     LET g_cxh.cxhlegal = g_legal #FUN-980009 add
     LET g_cxh.cxh013=g_ecm.ecm012   #FUN-A60095
     LET g_cxh.cxh014=g_ecm.ecm03    #FUN-A60095
     IF g_cxh.cxh013 IS NULL THEN LET g_cxh.cxh013=' ' END IF #FUN-A60095
     IF g_cxh.cxh014 IS NULL THEN LET g_cxh.cxh014=0   END IF #FUN-A60095
     INSERT INTO cxh_file VALUES (g_cxh.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
        LET g_showmsg=g_cxh.cxh01,"/",g_cxh.cxh011                                                                        #No.FUN-710027
        CALL s_errmsg('cxh01,cxh011',g_showmsg,'wip_2_1() ins cxh:',SQLCA.SQLCODE,1)                                      #No.FUN-710027 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
        UPDATE cxh_file SET cxh_file.*=g_cxh.*
         WHERE cxh01=g_sfb.sfb01 AND cxh02=yy AND cxh03=mm
           AND cxh06=l_cxf.cxf06 AND cxh07=l_cxf.cxf07   #FUN-7C0028 add
           AND cxh04=l_cxf.cxf04 AND cxh012=l_cxf.cxf012
           AND cxh012=g_ecm.ecm04    #FUN-A60095
           AND cxh013=g_ecm.ecm012   #FUN-A60095
           AND cxh014=g_ecm.ecm03    #FUN-A60095           
        IF STATUS THEN 
           LET g_showmsg=g_sfb.sfb01,"/",yy                                                                 #No.FUN-710027 
           CALL s_errmsg('cxh01,cxh02',g_showmsg,'upd cxh(21):',SQLCA.SQLCODE,1)                            #No.FUN-710027
        END IF
     END IF
   END FOREACH
   CLOSE work_c2_cxf
 
   ## WIP-元件 前製程轉入
  #IF gg_ecm03 != ' ' THEN      #有前製程轉入數 #FUN-A60095 mark
   IF gg_ecm03 IS NOT NULL THEN      #有前製程轉入數 #FUN-A60095 mark
      DECLARE work_c2_1_cxh1 CURSOR FOR
         SELECT * FROM cxh_file
         WHERE cxh01=g_sfb.sfb01 AND cxh012=gg_ecm04
           AND cxh02=yy   AND cxh03=mm AND cxh31 >0
           AND cxh06=type AND cxh07=g_tlfcost   #FUN-7C0028 add
           AND cxh013=gg_ecm012 AND cxh014=gg_ecm03  #FUN-A60095
      FOREACH work_c2_1_cxh1 INTO g_cxh.*                   # 有前製程資料
         CALL p510_cxh_02()
         LET g_cxh.cxh01 = g_sfb.sfb01                   # 工單編號
         LET g_cxh.cxh012= g_ecm.ecm04  #g_caf.caf06
         LET g_cxh.cxhdate = g_today
         LET g_cxh.cxhuser = g_user
         LET g_cxh.cxhtime = TIME
        #LET g_cxh.cxhplant = g_plant #FUN-980009 add    #FUN-A50075
         LET g_cxh.cxhlegal = g_legal #FUN-980009 add
         LET g_cxh.cxh013= g_ecm.ecm012 #FUN-A60095
         LET g_cxh.cxh014= g_ecm.ecm03  #FUN-A60095
         IF g_cxh.cxh013 IS NULL THEN LET g_cxh.cxh013=' ' END IF #FUN-A60095
         IF g_cxh.cxh014 IS NULL THEN LET g_cxh.cxh014=0   END IF #FUN-A60095
         INSERT INTO cxh_file VALUES (g_cxh.*)
         IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
            LET g_showmsg=g_cxh.cxh01,"/",g_cxh.cxh011                                                      #No.FUN-710027
            CALL s_errmsg('cxh01,cxh011',g_showmsg,'ins cxh:',SQLCA.SQLCODE,1)                              #No.FUN-710027
         END IF
         IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
            UPDATE cxh_file
               SET cxh24  = g_cxh.cxh24,
                   cxh25  = g_cxh.cxh25,
                   cxh25a = g_cxh.cxh25a,
                   cxh25b = g_cxh.cxh25b,
                   cxh25c = g_cxh.cxh25c,
                   cxh25d = g_cxh.cxh25d,
                   cxh25e = g_cxh.cxh25e,
                   cxh25f = g_cxh.cxh25f,   #FUN-7C0028 add
                   cxh25g = g_cxh.cxh25g,   #FUN-7C0028 add
                   cxh25h = g_cxh.cxh25h    #FUN-7C0028 add
               WHERE cxh01=g_sfb.sfb01 AND cxh012=g_ecm.ecm04 #g_caf.caf06
                 AND cxh02=yy AND cxh03=mm AND cxh04=g_cxh.cxh04
                 AND cxh06=g_cxh.cxh06 AND cxh07=g_cxh.cxh07  #FUN-7C0028 add
                 AND cxh013=g_ecm.ecm012 AND cxh014=g_ecm.ecm03  #FUN-A60095
            IF SQLCA.sqlerrd[3]=0 THEN  #FUN-A60095
               LET g_showmsg=g_sfb.sfb01,"/",g_ecm.ecm04                                                          #No.FUN-710027
               CALL s_errmsg('cxh01,cxh012',g_showmsg,'upd cxh(3):',SQLCA.SQLCODE,1)                                     #No.FUN-710027
            END IF
         END IF
      END FOREACH
   END IF
 
   ## WIP-元件 其它工單轉入
   ##         (只能轉依工單投料的元件以及前製程轉入的資料)
   IF gg_cxh26 > 0 THEN          # 工單轉入量大於 0,
      DECLARE work_c2_1_cxh2 CURSOR FOR     # 取得轉入前之原工單資料
         SELECT p01,p02,p03,p04,po13  #FUN-A60095
           FROM tmp11_file
          WHERE p05=g_sfb.sfb01 AND p06=g_ecm.ecm03  #g_caf.caf05
            AND pi13=g_ecm.ecm012  #FUN-A60095
      IF STATUS THEN
         CALL s_errmsg('','','Declare wip_c2_cxh2_11 error:',STATUS,1)                                        #No.FUN-710027
         RETURN
      END IF
      FOREACH work_c2_1_cxh2 INTO l_p01,l_p02,l_p03,l_p04,l_po13  #FUN-A60095
                             #來源工單/製程/作編 工單轉出量
         SELECT SUM(p04) INTO l_source_out   # 來源工單之總工單轉出量
           FROM tmp11_file
          WHERE p01=l_p01  AND p02=l_p02 AND p03=l_p03
            AND po13=l_po13 #FUN-A60095
         IF cl_null(l_source_out) THEN
            LET g_msg = g_sfb.sfb01 CLIPPED,' 工單轉出前之其他工單轉出量有誤'
            CALL s_errmsg('','','sel tmp11_file',STATUS,1)                           #No.FUN-710027       
            EXIT FOREACH
         END IF
         LET l_rate = l_p04/l_source_out       # 來源工單轉出比率
         DECLARE wip_c2_1_cxh2_122 CURSOR FOR     # 本工單的資料
            SELECT * FROM cxh_file
             WHERE cxh01=l_p01  AND cxh012=l_p03
               AND cxh02=yy   AND cxh03=mm AND cxh35 > 0
               AND cxh06=type AND cxh07=g_tlfcost   #FUN-7C0028 add
               AND cxh013=l_po13 AND cxh014=p02  #FUN-A60095
         FOREACH wip_c2_1_cxh2_122 INTO g_cxh.*
            CALL p510_cxh_03()
            LET g_cxh.cxh01 = g_sfb.sfb01              # 工單編號
            LET g_cxh.cxh02 = yy
            LET g_cxh.cxh03 = mm
            LET g_cxh.cxh06 = type        #FUN-7C0028 add
            LET g_cxh.cxh07 = g_tlfcost   #FUN-7C0028 add
            LET g_cxh.cxh012= g_ecm.ecm04  #g_caf.caf06
            LET g_cxh.cxhdate = g_today
            LET g_cxh.cxhuser = g_user
            LET g_cxh.cxhtime = TIME
            LET g_cxh.cxh26 = g_cxh.cxh26 * l_rate
            LET g_cxh.cxh27 = g_cxh.cxh27 * l_rate
            LET g_cxh.cxh27a= g_cxh.cxh27a * l_rate
            LET g_cxh.cxh27b= g_cxh.cxh27b * l_rate
            LET g_cxh.cxh27c= g_cxh.cxh27c * l_rate
            LET g_cxh.cxh27d= g_cxh.cxh27d * l_rate
            LET g_cxh.cxh27e= g_cxh.cxh27e * l_rate
            LET g_cxh.cxh27f= g_cxh.cxh27f * l_rate   #FUN-7C0028 add
            LET g_cxh.cxh27g= g_cxh.cxh27g * l_rate   #FUN-7C0028 add
            LET g_cxh.cxh27h= g_cxh.cxh27h * l_rate   #FUN-7C0028 add
           #LET g_cxh.cxhplant = g_plant #FUN-980009 add    #FUN-A50075
            LET g_cxh.cxhlegal = g_legal #FUN-980009 add
            LET g_cxh.cxh013= g_ecm.ecm012 #FUN-A60095
            LET g_cxh.cxh014= g_ecm.ecm03  #FUN-A60095
            IF g_cxh.cxh013 IS NULL THEN LET g_cxh.cxh013=' ' END IF #FUN-A60095
            IF g_cxh.cxh014 IS NULL THEN LET g_cxh.cxh014=0   END IF #FUN-A60095
            INSERT INTO cxh_file VALUES (g_cxh.*)
            IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
               LET g_showmsg=g_cxh.cxh01,"/",g_cxh.cxh02                                                                            #No.FUN-710027
               CALL s_errmsg('cxh01,cxh02',g_showmsg,'wip_2_1() ins cxh2_1:',SQLCA.SQLCODE,1)                                      #No.FUN-710027
            END IF
 
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
               UPDATE cxh_file
                  SET cxh26 = cxh26 + g_cxh.cxh26,
                      cxh27 = cxh27 + g_cxh.cxh27,
                      cxh27a = cxh27a + g_cxh.cxh27a,
                      cxh27b = cxh27b + g_cxh.cxh27b,
                      cxh27c = cxh27c + g_cxh.cxh27c,
                      cxh27d = cxh27d + g_cxh.cxh27d,
                      cxh27e = cxh27e + g_cxh.cxh27e,
                      cxh27f = cxh27f + g_cxh.cxh27f,   #FUN-7C0028 add 
                      cxh27g = cxh27g + g_cxh.cxh27g,   #FUN-7C0028 add 
                      cxh27h = cxh27h + g_cxh.cxh27h    #FUN-7C0028 add 
                WHERE cxh01=g_sfb.sfb01
                  AND cxh012=g_cxh.cxh012
                  AND cxh02 =yy AND cxh03 = mm
                  AND cxh04 =g_cxh.cxh04
                  AND cxh06 =g_cxh.cxh06   #FUN-7C0028 add
                  AND cxh07 =g_cxh.cxh07   #FUN-7C0028 add
                  AND cxh013=g_cxh.cxh013  #FUN-A60095
                  AND cxh014=g_cxh.cxh014  #FUN-A60095
               IF SQLCA.sqlerrd[3]=0 THEN   #FUN-A60095
                  LET g_showmsg=g_sfb.sfb01,"/",g_cxh.cxh012                                                      #No.FUN-710027
                  CALL s_errmsg('cxh01,cxh012',g_showmsg,'upd cxh(4):',SQLCA.SQLCODE,1)                                  #No.FUN-710027
               END IF
            END IF
         END FOREACH
      END FOREACH
   END IF
 
   ## WIP-元件 重流轉入
   IF gg_cxh28 > 0 THEN          # 重流轉入量大於 0,
      DECLARE work_c2_1_cxh22 CURSOR FOR     # 取得重流轉入前之資料
         SELECT p01,p02,p03,p04,po13  #FUN-A60095
           FROM tmp10_file
          WHERE p01=g_sfb.sfb01 AND p05=g_ecm.ecm03 #g_caf.caf05
            AND pi13=g_ecm.ecm012  #FUN-A60095
      IF STATUS THEN
          CALL s_errmsg('','','Declare wip_c2_cxh22 error',STATUS,1)                                         #No.FUN-710027
         RETURN
      END IF
      FOREACH work_c2_1_cxh22 INTO l_p01,l_p02,l_p03,l_p04,l_po13  #FUN-A60095
         SELECT SUM(p04) INTO l_source_out2   # 原來製程之總重工轉出量
           FROM tmp10_file
          WHERE p01=l_p01  AND p02=l_p02 AND p03=l_p03
            AND po13=l_po13  #FUN-A60095
         IF cl_null(l_source_out2) THEN
            LET g_msg = g_sfb.sfb01 CLIPPED,' 工單轉出前之其他工單轉出量有誤'
            CALL s_errmsg('','',g_msg,STATUS,0)          #No.FUN-710027
            EXIT FOREACH
         END IF
         LET l_rate = l_p04/l_source_out2       # 來源站別轉入比率
         DECLARE wip_c22_1_cxh2_1211 CURSOR FOR
            SELECT * FROM cxh_file
             WHERE cxh01=l_p01 AND cxh012=l_p03
               AND cxh02=yy    AND cxh03=mm AND cxh39 !=0
               AND cxh06=type  AND cxh07=g_tlfcost   #FUN-7C0028 add
               AND cxh013=l_po13 AND cxh014=l_p02  #FUN-A60095
         FOREACH wip_c22_1_cxh2_1211 INTO g_cxh.*
            CALL p510_cxh_04()
            LET g_cxh.cxh01 = g_sfb.sfb01              # 工單編號
            LET g_cxh.cxh02 = yy
            LET g_cxh.cxh03 = mm
            LET g_cxh.cxh06 = type        #FUN-7C0028 add
            LET g_cxh.cxh07 = g_tlfcost   #FUN-7C0028 add
            LET g_cxh.cxh012= g_caf.caf06
            LET g_cxh.cxhdate = g_today
            LET g_cxh.cxhuser = g_user
            LET g_cxh.cxhtime = TIME
            LET g_cxh.cxh28 = g_cxh.cxh28 * l_rate
            LET g_cxh.cxh29 = g_cxh.cxh29 * l_rate
            LET g_cxh.cxh29a = g_cxh.cxh29a * l_rate
            LET g_cxh.cxh29b = g_cxh.cxh29b * l_rate
            LET g_cxh.cxh29c = g_cxh.cxh29c * l_rate
            LET g_cxh.cxh29d = g_cxh.cxh29d * l_rate
            LET g_cxh.cxh29e = g_cxh.cxh29e * l_rate
            LET g_cxh.cxh29f = g_cxh.cxh29f * l_rate   #FUN-7C0028 add
            LET g_cxh.cxh29g = g_cxh.cxh29g * l_rate   #FUN-7C0028 add
            LET g_cxh.cxh29h = g_cxh.cxh29h * l_rate   #FUN-7C0028 add
           #LET g_cxh.cxhplant = g_plant #FUN-980009 add     #FUN-A50075
            LET g_cxh.cxhlegal = g_legal #FUN-980009 add
            LET g_cxh.cxh013= g_caf.caf012  #FUN-A60095
            LET g_cxh.cxh014= g_caf.caf05   #FUN-A60095
            IF g_cxh.cxh013 IS NULL THEN LET g_cxh.cxh013=' ' END IF #FUN-A60095
            IF g_cxh.cxh014 IS NULL THEN LET g_cxh.cxh014=0   END IF #FUN-A60095
            INSERT INTO cxh_file VALUES (g_cxh.*)
            IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
               LET g_showmsg=g_cxh.cxh01,"/",g_cxh.cxh012                                                                    #No.FUN-710027
               CALL s_errmsg('cxh01,cxh02',g_showmsg,'wip_2_1() ins cxh2_1',SQLCA.SQLCODE,1)                                        #No.FUN-710027
            END IF
            IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
               UPDATE cxh_file
                  SET cxh28 = cxh28 + g_cxh.cxh28,
                      cxh29 = cxh29 + g_cxh.cxh29,
                      cxh29a = cxh29a + g_cxh.cxh29a,
                      cxh29b = cxh29b + g_cxh.cxh29b,
                      cxh29c = cxh29c + g_cxh.cxh29c,
                      cxh29d = cxh29d + g_cxh.cxh29d,
                      cxh29e = cxh29e + g_cxh.cxh29e,
                      cxh29f = cxh29f + g_cxh.cxh29f,   #FUN-7C0028 add 
                      cxh29g = cxh29g + g_cxh.cxh29g,   #FUN-7C0028 add 
                      cxh29h = cxh29h + g_cxh.cxh29h    #FUN-7C0028 add 
                WHERE cxh01 =g_cxh.cxh01
                  AND cxh012=g_cxh.cxh012
                  AND cxh02 =yy 
                  AND cxh03 =mm
                  AND cxh04 =g_cxh.cxh04
                  AND cxh06 =g_cxh.cxh06   #FUN-7C0028 add
                  AND cxh07 =g_cxh.cxh07   #FUN-7C0028 add
                  AND cxh013=g_cxh.cxh013  #FUN-A60095
                  AND cxh014=g_cxh.cxh014  #FUN-A60095
               IF SQLCA.sqlerrd[3]=0 THEN  #FUN-A60095
                 LET g_showmsg=g_cxh.cxh01,"/",g_cxh.cxh012                                                           #No.FUN-710027
                 CALL s_errmsg('cxh01,cxh02',g_showmsg,'upd cxh(4)',SQLCA.SQLCODE,1)                                         #No.FUN-710027
               END IF
            END IF
         END FOREACH
      END FOREACH
   END IF
END FUNCTION
 
# 其他工單轉出   轉其他工單轉入, 其餘全部歸零
FUNCTION p510_cxh_03()
    CALL p510_get_cxh011()
    # 上月結存
    LET g_cxh.cxh11 = 0
    LET g_cxh.cxh12 = 0 LET g_cxh.cxh12a = 0 LET g_cxh.cxh12b = 0
    LET g_cxh.cxh12c= 0 LET g_cxh.cxh12d = 0 LET g_cxh.cxh12e = 0
    LET g_cxh.cxh12f= 0 LET g_cxh.cxh12g = 0 LET g_cxh.cxh12h = 0   #FUN-7C0028 add
    # 本月投入
    LET g_cxh.cxh21 = 0
    LET g_cxh.cxh22 = 0 LET g_cxh.cxh22a = 0 LET g_cxh.cxh22b = 0
    LET g_cxh.cxh22c= 0 LET g_cxh.cxh22d = 0 LET g_cxh.cxh22e = 0
    LET g_cxh.cxh22f= 0 LET g_cxh.cxh22g = 0 LET g_cxh.cxh22h = 0   #FUN-7C0028 add
    # 本月前製程入
    LET g_cxh.cxh24 = 0
    LET g_cxh.cxh25 = 0 LET g_cxh.cxh25a = 0 LET g_cxh.cxh25b = 0
    LET g_cxh.cxh25c= 0 LET g_cxh.cxh25d = 0 LET g_cxh.cxh25e = 0
    LET g_cxh.cxh25f= 0 LET g_cxh.cxh25g = 0 LET g_cxh.cxh25h = 0   #FUN-7C0028 add
    # 其他 工單轉入
    LET g_cxh.cxh26 = g_cxh.cxh35 * -1
    LET g_cxh.cxh27 = g_cxh.cxh36 * -1
    LET g_cxh.cxh27a= g_cxh.cxh36a * -1
    LET g_cxh.cxh27b= g_cxh.cxh36b * -1
    LET g_cxh.cxh27c= g_cxh.cxh36c * -1
    LET g_cxh.cxh27d= g_cxh.cxh36d * -1
    LET g_cxh.cxh27e= g_cxh.cxh36e * -1
    LET g_cxh.cxh27f= g_cxh.cxh36f * -1   #FUN-7C0028 add
    LET g_cxh.cxh27g= g_cxh.cxh36g * -1   #FUN-7C0028 add
    LET g_cxh.cxh27h= g_cxh.cxh36h * -1   #FUN-7C0028 add
    # 重工轉入
    LET g_cxh.cxh28 = 0
    LET g_cxh.cxh29 = 0 LET g_cxh.cxh29a = 0 LET g_cxh.cxh29b = 0
    LET g_cxh.cxh29c= 0 LET g_cxh.cxh29d = 0 LET g_cxh.cxh29e = 0
    LET g_cxh.cxh29f= 0 LET g_cxh.cxh29g = 0 LET g_cxh.cxh29h = 0   #FUN-7C0028 add
    # 本月轉下製程
    LET g_cxh.cxh31 = 0
    LET g_cxh.cxh32 = 0 LET g_cxh.cxh32a = 0 LET g_cxh.cxh32b = 0
    LET g_cxh.cxh32c= 0 LET g_cxh.cxh32d = 0 LET g_cxh.cxh32e = 0
    LET g_cxh.cxh32f= 0 LET g_cxh.cxh32g = 0 LET g_cxh.cxh32h = 0   #FUN-7C0028 add
    # 本月報廢
    LET g_cxh.cxh33 = 0
    LET g_cxh.cxh34 = 0 LET g_cxh.cxh34a = 0 LET g_cxh.cxh34b = 0
    LET g_cxh.cxh34c= 0 LET g_cxh.cxh34d = 0 LET g_cxh.cxh34e = 0
    LET g_cxh.cxh34f= 0 LET g_cxh.cxh34g = 0 LET g_cxh.cxh34h = 0   #FUN-7C0028 add
    # 轉其他工單
    LET g_cxh.cxh35 = 0
    LET g_cxh.cxh36 = 0 LET g_cxh.cxh36a = 0 LET g_cxh.cxh36b = 0
    LET g_cxh.cxh36c= 0 LET g_cxh.cxh36d = 0 LET g_cxh.cxh36e = 0
    LET g_cxh.cxh36f= 0 LET g_cxh.cxh36g = 0 LET g_cxh.cxh36h = 0   #FUN-7C0028 add
    #當站下線
    LET g_cxh.cxh37 = 0
    LET g_cxh.cxh38 = 0 LET g_cxh.cxh38a = 0 LET g_cxh.cxh38b = 0
    LET g_cxh.cxh38c= 0 LET g_cxh.cxh38d = 0 LET g_cxh.cxh38e = 0
    LET g_cxh.cxh38f= 0 LET g_cxh.cxh38g = 0 LET g_cxh.cxh38h = 0   #FUN-7C0028 add
    #重流轉出
    LET g_cxh.cxh39 = 0
    LET g_cxh.cxh40 = 0 LET g_cxh.cxh40a = 0 LET g_cxh.cxh40b = 0
    LET g_cxh.cxh40c= 0 LET g_cxh.cxh40d = 0 LET g_cxh.cxh40e = 0
    LET g_cxh.cxh40f= 0 LET g_cxh.cxh40g = 0 LET g_cxh.cxh40h = 0   #FUN-7C0028 add
    # 本月差異轉出
    LET g_cxh.cxh41 = 0
    LET g_cxh.cxh42 = 0 LET g_cxh.cxh42a = 0 LET g_cxh.cxh42b = 0
    LET g_cxh.cxh42c= 0 LET g_cxh.cxh42d = 0 LET g_cxh.cxh42e = 0
    LET g_cxh.cxh42f= 0 LET g_cxh.cxh42g = 0 LET g_cxh.cxh42h = 0   #FUN-7C0028 add
    # 累計投入
    LET g_cxh.cxh51 = 0
    LET g_cxh.cxh52 = 0 LET g_cxh.cxh52a = 0 LET g_cxh.cxh52b = 0
    LET g_cxh.cxh52c= 0 LET g_cxh.cxh52d = 0 LET g_cxh.cxh52e = 0
    LET g_cxh.cxh52f= 0 LET g_cxh.cxh52g = 0 LET g_cxh.cxh52h = 0   #FUN-7C0028 add
    # 累計轉出
    LET g_cxh.cxh53 = 0
    LET g_cxh.cxh54 = 0 LET g_cxh.cxh54a = 0 LET g_cxh.cxh54b = 0
    LET g_cxh.cxh54c= 0 LET g_cxh.cxh54d = 0 LET g_cxh.cxh54e = 0
    LET g_cxh.cxh54f= 0 LET g_cxh.cxh54g = 0 LET g_cxh.cxh54h = 0   #FUN-7C0028 add
    # 累計超領退
    LET g_cxh.cxh55 = 0
    LET g_cxh.cxh56 = 0 LET g_cxh.cxh56a = 0 LET g_cxh.cxh56b = 0
    LET g_cxh.cxh56c= 0 LET g_cxh.cxh56d = 0 LET g_cxh.cxh56e = 0
    LET g_cxh.cxh56f= 0 LET g_cxh.cxh56g = 0 LET g_cxh.cxh56h = 0   #FUN-7C0028 add
    # 本月超領退
    LET g_cxh.cxh57 = 0
    LET g_cxh.cxh58 = 0 LET g_cxh.cxh58a = 0 LET g_cxh.cxh58b = 0
    LET g_cxh.cxh58c= 0 LET g_cxh.cxh58d = 0 LET g_cxh.cxh58e = 0
    LET g_cxh.cxh58f= 0 LET g_cxh.cxh58g = 0 LET g_cxh.cxh58h = 0   #FUN-7C0028 add
    # 盤差
    LET g_cxh.cxh59 = 0
    LET g_cxh.cxh60 = 0 LET g_cxh.cxh60a = 0 LET g_cxh.cxh60b = 0
    LET g_cxh.cxh60c= 0 LET g_cxh.cxh60d = 0 LET g_cxh.cxh60e = 0
    LET g_cxh.cxh60f= 0 LET g_cxh.cxh60g = 0 LET g_cxh.cxh60h = 0   #FUN-7C0028 add
    # 本月結存
    LET g_cxh.cxh91 = 0
    LET g_cxh.cxh92 = 0 LET g_cxh.cxh92a = 0 LET g_cxh.cxh92b = 0
    LET g_cxh.cxh92c= 0 LET g_cxh.cxh92d = 0 LET g_cxh.cxh92e = 0
    LET g_cxh.cxh92f= 0 LET g_cxh.cxh92g = 0 LET g_cxh.cxh92h = 0   #FUN-7C0028 add
END FUNCTION
 
# 重工轉出   轉重工入, 其餘全部歸零
FUNCTION p510_cxh_04()
    CALL p510_get_cxh011()
    # 上月結存
    LET g_cxh.cxh11 = 0
    LET g_cxh.cxh12 = 0 LET g_cxh.cxh12a = 0 LET g_cxh.cxh12b = 0
    LET g_cxh.cxh12c= 0 LET g_cxh.cxh12d = 0 LET g_cxh.cxh12e = 0
    LET g_cxh.cxh12f= 0 LET g_cxh.cxh12g = 0 LET g_cxh.cxh12h = 0   #FUN-7C0028 add
    # 本月投入
    LET g_cxh.cxh21 = 0
    LET g_cxh.cxh22 = 0 LET g_cxh.cxh22a = 0 LET g_cxh.cxh22b = 0
    LET g_cxh.cxh22c= 0 LET g_cxh.cxh22d = 0 LET g_cxh.cxh22e = 0
    LET g_cxh.cxh22f= 0 LET g_cxh.cxh22g = 0 LET g_cxh.cxh22h = 0   #FUN-7C0028 add
    # 本月前製程入
    LET g_cxh.cxh24 = 0
    LET g_cxh.cxh25 = 0 LET g_cxh.cxh25a = 0 LET g_cxh.cxh25b = 0
    LET g_cxh.cxh25c= 0 LET g_cxh.cxh25d = 0 LET g_cxh.cxh25e = 0
    LET g_cxh.cxh25f= 0 LET g_cxh.cxh25g = 0 LET g_cxh.cxh25h = 0   #FUN-7C0028 add
    # 其他 工單轉入
    LET g_cxh.cxh26 = 0
    LET g_cxh.cxh27 = 0 LET g_cxh.cxh27a = 0 LET g_cxh.cxh27b = 0
    LET g_cxh.cxh27c= 0 LET g_cxh.cxh27d = 0 LET g_cxh.cxh27e = 0
    LET g_cxh.cxh27f= 0 LET g_cxh.cxh27g = 0 LET g_cxh.cxh27h = 0   #FUN-7C0028 add
    # 重工轉入
    LET g_cxh.cxh28 = g_cxh.cxh39 *-1
    LET g_cxh.cxh29 = g_cxh.cxh40 *-1
    LET g_cxh.cxh29a= g_cxh.cxh40a*-1
    LET g_cxh.cxh29b= g_cxh.cxh40b*-1
    LET g_cxh.cxh29c= g_cxh.cxh40c*-1
    LET g_cxh.cxh29d= g_cxh.cxh40d*-1
    LET g_cxh.cxh29e= g_cxh.cxh40e*-1
    LET g_cxh.cxh29f= g_cxh.cxh40f*-1   #FUN-7C0028 add
    LET g_cxh.cxh29g= g_cxh.cxh40g*-1   #FUN-7C0028 add
    LET g_cxh.cxh29h= g_cxh.cxh40h*-1   #FUN-7C0028 add
    # 本月轉下製程
    LET g_cxh.cxh31 = 0
    LET g_cxh.cxh32 = 0 LET g_cxh.cxh32a = 0 LET g_cxh.cxh32b = 0
    LET g_cxh.cxh32c= 0 LET g_cxh.cxh32d = 0 LET g_cxh.cxh32e = 0
    LET g_cxh.cxh32f= 0 LET g_cxh.cxh32g = 0 LET g_cxh.cxh32h = 0   #FUN-7C0028 add
    # 本月報廢
    LET g_cxh.cxh33 = 0
    LET g_cxh.cxh34 = 0 LET g_cxh.cxh34a = 0 LET g_cxh.cxh34b = 0
    LET g_cxh.cxh34c= 0 LET g_cxh.cxh34d = 0 LET g_cxh.cxh34e = 0
    LET g_cxh.cxh34f= 0 LET g_cxh.cxh34g = 0 LET g_cxh.cxh34h = 0   #FUN-7C0028 add
    # 轉其他工單
    LET g_cxh.cxh35 = 0
    LET g_cxh.cxh36 = 0 LET g_cxh.cxh36a = 0 LET g_cxh.cxh36b = 0
    LET g_cxh.cxh36c= 0 LET g_cxh.cxh36d = 0 LET g_cxh.cxh36e = 0
    LET g_cxh.cxh36f= 0 LET g_cxh.cxh36g = 0 LET g_cxh.cxh36h = 0   #FUN-7C0028 add
    #當站下線
    LET g_cxh.cxh37 = 0
    LET g_cxh.cxh38 = 0 LET g_cxh.cxh38a = 0 LET g_cxh.cxh38b = 0
    LET g_cxh.cxh38c= 0 LET g_cxh.cxh38d = 0 LET g_cxh.cxh38e = 0
    LET g_cxh.cxh38f= 0 LET g_cxh.cxh38g = 0 LET g_cxh.cxh38h = 0   #FUN-7C0028 add
    #重流轉出
    LET g_cxh.cxh39 = 0
    LET g_cxh.cxh40 = 0 LET g_cxh.cxh40a = 0 LET g_cxh.cxh40b = 0
    LET g_cxh.cxh40c= 0 LET g_cxh.cxh40d = 0 LET g_cxh.cxh40e = 0
    LET g_cxh.cxh40f= 0 LET g_cxh.cxh40g = 0 LET g_cxh.cxh40h = 0   #FUN-7C0028 add
    # 本月差異轉出
    LET g_cxh.cxh41 = 0
    LET g_cxh.cxh42 = 0 LET g_cxh.cxh42a = 0 LET g_cxh.cxh42b = 0
    LET g_cxh.cxh42c= 0 LET g_cxh.cxh42d = 0 LET g_cxh.cxh42e = 0
    LET g_cxh.cxh42f= 0 LET g_cxh.cxh42g = 0 LET g_cxh.cxh42h = 0   #FUN-7C0028 add
    # 累計投入
    LET g_cxh.cxh51 = 0
    LET g_cxh.cxh52 = 0 LET g_cxh.cxh52a = 0 LET g_cxh.cxh52b = 0
    LET g_cxh.cxh52c= 0 LET g_cxh.cxh52d = 0 LET g_cxh.cxh52e = 0
    LET g_cxh.cxh52f= 0 LET g_cxh.cxh52g = 0 LET g_cxh.cxh52h = 0   #FUN-7C0028 add
    # 累計轉出
    LET g_cxh.cxh53 = 0
    LET g_cxh.cxh54 = 0 LET g_cxh.cxh54a = 0 LET g_cxh.cxh54b = 0
    LET g_cxh.cxh54c= 0 LET g_cxh.cxh54d = 0 LET g_cxh.cxh54e = 0
    LET g_cxh.cxh54f= 0 LET g_cxh.cxh54g = 0 LET g_cxh.cxh54h = 0   #FUN-7C0028 add
    # 累計超領退
    LET g_cxh.cxh55 = 0
    LET g_cxh.cxh56 = 0 LET g_cxh.cxh56a = 0 LET g_cxh.cxh56b = 0
    LET g_cxh.cxh56c= 0 LET g_cxh.cxh56d = 0 LET g_cxh.cxh56e = 0
    LET g_cxh.cxh56f= 0 LET g_cxh.cxh56g = 0 LET g_cxh.cxh56h = 0   #FUN-7C0028 add
    # 本月超領退
    LET g_cxh.cxh57 = 0
    LET g_cxh.cxh58 = 0 LET g_cxh.cxh58a = 0 LET g_cxh.cxh58b = 0
    LET g_cxh.cxh58c= 0 LET g_cxh.cxh58d = 0 LET g_cxh.cxh58e = 0
    LET g_cxh.cxh58f= 0 LET g_cxh.cxh58g = 0 LET g_cxh.cxh58h = 0   #FUN-7C0028 add
    # 盤差
    LET g_cxh.cxh59 = 0
    LET g_cxh.cxh60 = 0 LET g_cxh.cxh60a = 0 LET g_cxh.cxh60b = 0
    LET g_cxh.cxh60c= 0 LET g_cxh.cxh60d = 0 LET g_cxh.cxh60e = 0
    LET g_cxh.cxh60f= 0 LET g_cxh.cxh60g = 0 LET g_cxh.cxh60h = 0   #FUN-7C0028 add
    # 本月結存
    LET g_cxh.cxh91 = 0
    LET g_cxh.cxh92 = 0 LET g_cxh.cxh92a = 0 LET g_cxh.cxh92b = 0
    LET g_cxh.cxh92c= 0 LET g_cxh.cxh92d = 0 LET g_cxh.cxh92e = 0
    LET g_cxh.cxh92f= 0 LET g_cxh.cxh92g = 0 LET g_cxh.cxh92h = 0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION p510_get_cxh011()
     ## 人工製費工時輸入方式1.年月成本中心2.年月作業編號
     ##                     3.年月工作中心
     CASE g_ccz.ccz06
       WHEN '1' LET g_cxh.cxh011=g_sfb.sfb98  #年月
       WHEN '2' LET g_cxh.cxh011=g_sfb.sfb98  #成本中心
       WHEN '3' LET g_cxh.cxh011=g_ecm.ecm04  #g_caf.caf06  #作業編號
       WHEN '4' SELECT ecm06 INTO g_cxh.cxh011 FROM ecm_file
                 WHERE ecm01=g_sfb.sfb01  #g_caf.caf01   #FUN-670016 modify
                   AND ecm03=g_ecm.ecm03  #g_caf.caf05
                   AND ecm04=g_ecm.ecm04  #g_caf.caf06
                   AND ecm012=g_ecm.ecm012 #FUN-A60095
                EXIT CASE
     END CASE
END FUNCTION
 
#前製程轉出轉本製程轉入, 其餘全部歸零
FUNCTION p510_cxh_02()
    ### 上月結存
    CALL p510_get_cxh011()
    LET g_cxh.cxh11 = 0
    LET g_cxh.cxh12 = 0 LET g_cxh.cxh12a = 0 LET g_cxh.cxh12b = 0
    LET g_cxh.cxh12c= 0 LET g_cxh.cxh12d = 0 LET g_cxh.cxh12e = 0
    LET g_cxh.cxh12f= 0 LET g_cxh.cxh12g = 0 LET g_cxh.cxh12g = 0   #FUN-7C0028 add
    # 本月投入
    LET g_cxh.cxh21 = 0
    LET g_cxh.cxh22 = 0 LET g_cxh.cxh22a = 0 LET g_cxh.cxh22b = 0
    LET g_cxh.cxh22c= 0 LET g_cxh.cxh22d = 0 LET g_cxh.cxh22e = 0
    LET g_cxh.cxh22f= 0 LET g_cxh.cxh22g = 0 LET g_cxh.cxh22g = 0   #FUN-7C0028 add
    # 本月前製程入
    LET g_cxh.cxh24 = g_cxh.cxh31 * -1
    LET g_cxh.cxh25 = g_cxh.cxh32 * -1
    LET g_cxh.cxh25a= g_cxh.cxh32a * -1
    LET g_cxh.cxh25b= g_cxh.cxh32b * -1
    LET g_cxh.cxh25c= g_cxh.cxh32c * -1
    LET g_cxh.cxh25d= g_cxh.cxh32d * -1
    LET g_cxh.cxh25e= g_cxh.cxh32e * -1
    LET g_cxh.cxh25f= g_cxh.cxh32f * -1   #FUN-7C0028 add
    LET g_cxh.cxh25g= g_cxh.cxh32g * -1   #FUN-7C0028 add
    LET g_cxh.cxh25h= g_cxh.cxh32h * -1   #FUN-7C0028 add
    # 其他 工單轉入
    LET g_cxh.cxh26 = 0
    LET g_cxh.cxh27 = 0 LET g_cxh.cxh27a = 0 LET g_cxh.cxh27b = 0
    LET g_cxh.cxh27c= 0 LET g_cxh.cxh27d = 0 LET g_cxh.cxh27e = 0
    LET g_cxh.cxh27f= 0 LET g_cxh.cxh27g = 0 LET g_cxh.cxh27g = 0   #FUN-7C0028 add
    # 製程重工轉入
    LET g_cxh.cxh28 = 0
    LET g_cxh.cxh29 = 0 LET g_cxh.cxh29a = 0 LET g_cxh.cxh29b = 0
    LET g_cxh.cxh29c= 0 LET g_cxh.cxh29d = 0 LET g_cxh.cxh29e = 0
    LET g_cxh.cxh29f= 0 LET g_cxh.cxh29g = 0 LET g_cxh.cxh29g = 0   #FUN-7C0028 add
    # 本月轉下製程
    LET g_cxh.cxh31 = 0
    LET g_cxh.cxh32 = 0 LET g_cxh.cxh32a = 0 LET g_cxh.cxh32b = 0
    LET g_cxh.cxh32c= 0 LET g_cxh.cxh32d = 0 LET g_cxh.cxh32e = 0
    LET g_cxh.cxh32f= 0 LET g_cxh.cxh32g = 0 LET g_cxh.cxh32g = 0   #FUN-7C0028 add
    # 本月報廢
    LET g_cxh.cxh33 = 0
    LET g_cxh.cxh34 = 0 LET g_cxh.cxh34a = 0 LET g_cxh.cxh34b = 0
    LET g_cxh.cxh34c= 0 LET g_cxh.cxh34d = 0 LET g_cxh.cxh34e = 0
    LET g_cxh.cxh34f= 0 LET g_cxh.cxh34g = 0 LET g_cxh.cxh34g = 0   #FUN-7C0028 add
    #工單轉出
    LET g_cxh.cxh35 = 0
    LET g_cxh.cxh36 = 0 LET g_cxh.cxh36a = 0 LET g_cxh.cxh36b = 0
    LET g_cxh.cxh36c= 0 LET g_cxh.cxh36d = 0 LET g_cxh.cxh36e = 0
    LET g_cxh.cxh36f= 0 LET g_cxh.cxh36g = 0 LET g_cxh.cxh36g = 0   #FUN-7C0028 add
    # 當站下線
    LET g_cxh.cxh37 = 0
    LET g_cxh.cxh38 = 0 LET g_cxh.cxh38a = 0 LET g_cxh.cxh38b = 0
    LET g_cxh.cxh38c= 0 LET g_cxh.cxh38d = 0 LET g_cxh.cxh38e = 0
    LET g_cxh.cxh38f= 0 LET g_cxh.cxh38g = 0 LET g_cxh.cxh38g = 0   #FUN-7C0028 add
    # 重工轉出
    LET g_cxh.cxh39 = 0
    LET g_cxh.cxh40 = 0 LET g_cxh.cxh40a = 0 LET g_cxh.cxh40b = 0
    LET g_cxh.cxh40c= 0 LET g_cxh.cxh40d = 0 LET g_cxh.cxh40e = 0
    LET g_cxh.cxh40f= 0 LET g_cxh.cxh40g = 0 LET g_cxh.cxh40g = 0   #FUN-7C0028 add
    # 本月差異轉出
    LET g_cxh.cxh41 = 0
    LET g_cxh.cxh42 = 0 LET g_cxh.cxh42a = 0 LET g_cxh.cxh42b = 0
    LET g_cxh.cxh42c= 0 LET g_cxh.cxh42d = 0 LET g_cxh.cxh42e = 0
    LET g_cxh.cxh42f= 0 LET g_cxh.cxh42g = 0 LET g_cxh.cxh42g = 0   #FUN-7C0028 add
    # 累計投入
    LET g_cxh.cxh51 = 0
    LET g_cxh.cxh52 = 0 LET g_cxh.cxh52a = 0 LET g_cxh.cxh52b = 0
    LET g_cxh.cxh52c= 0 LET g_cxh.cxh52d = 0 LET g_cxh.cxh52e = 0
    LET g_cxh.cxh52f= 0 LET g_cxh.cxh52g = 0 LET g_cxh.cxh52g = 0   #FUN-7C0028 add
    # 累計轉出
    LET g_cxh.cxh53 = 0
    LET g_cxh.cxh54 = 0 LET g_cxh.cxh54a = 0 LET g_cxh.cxh54b = 0
    LET g_cxh.cxh54c= 0 LET g_cxh.cxh54d = 0 LET g_cxh.cxh54e = 0
    LET g_cxh.cxh54f= 0 LET g_cxh.cxh54g = 0 LET g_cxh.cxh54g = 0   #FUN-7C0028 add
    # 累計超領退
    LET g_cxh.cxh55 = 0
    LET g_cxh.cxh56 = 0 LET g_cxh.cxh56a = 0 LET g_cxh.cxh56b = 0
    LET g_cxh.cxh56c= 0 LET g_cxh.cxh56d = 0 LET g_cxh.cxh56e = 0
    LET g_cxh.cxh56f= 0 LET g_cxh.cxh56g = 0 LET g_cxh.cxh56g = 0   #FUN-7C0028 add
    # 本月超領退
    LET g_cxh.cxh57 = 0
    LET g_cxh.cxh58 = 0 LET g_cxh.cxh58a = 0 LET g_cxh.cxh58b = 0
    LET g_cxh.cxh58c= 0 LET g_cxh.cxh58d = 0 LET g_cxh.cxh58e = 0
    LET g_cxh.cxh58f= 0 LET g_cxh.cxh58g = 0 LET g_cxh.cxh58g = 0   #FUN-7C0028 add
    # 盤差
    LET g_cxh.cxh59 = 0
    LET g_cxh.cxh60 = 0 LET g_cxh.cxh60a = 0 LET g_cxh.cxh60b = 0
    LET g_cxh.cxh60c= 0 LET g_cxh.cxh60d = 0 LET g_cxh.cxh60e = 0
    LET g_cxh.cxh60f= 0 LET g_cxh.cxh60g = 0 LET g_cxh.cxh60g = 0   #FUN-7C0028 add
    # 本月結存
    LET g_cxh.cxh91 = 0
    LET g_cxh.cxh92 = 0 LET g_cxh.cxh92a = 0 LET g_cxh.cxh92b = 0
    LET g_cxh.cxh92c= 0 LET g_cxh.cxh92d = 0 LET g_cxh.cxh92e = 0
    LET g_cxh.cxh92f= 0 LET g_cxh.cxh92g = 0 LET g_cxh.cxh92g = 0   #FUN-7C0028 add
END FUNCTION
 
FUNCTION wip_2_21()    #WIP-元件 本期投入材料 (依工單發料/退料檔)
   DEFINE l_ima08               LIKE ima_file.ima08    #No.FUN-680122 VARCHAR(1)
   DEFINE l_ima57               LIKE type_file.num5    #No.FUN-680122 SMALLINT
   DEFINE l_tlf01               LIKE tlf_file.tlf01    #No.MOD-490217
   DEFINE l_tlf02,l_tlf03       LIKE type_file.num5    #No.FUN-680122 SMALLINT
   DEFINE l_tlf10               LIKE tlf_file.tlf10    #No.FUN-680122 DEC(15,3)
   DEFINE l_tlf13               LIKE tlf_file.tlf13
   DEFINE l_c21                 LIKE ccc_file.ccc21    #No.FUN-680122 DEC(15,5)
   DEFINE l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                     LIKE type_file.num20_6   #FUN-7C0028 add 
   DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                     LIKE type_file.num20_6   #FUN-7C0028 add 
   DEFINE l_tlf62               LIKE tlf_file.tlf62
   DEFINE l_sfa161              LIKE sfa_file.sfa161
   DEFINE l_tlf21,l_tlf221,l_tlf222,l_tlf2231      LIKE tlf_file.tlf21
   DEFINE l_tlf2232,l_tlf224                       LIKE tlf_file.tlf21      #No.A102
   DEFINE l_tlf2241,l_tlf2242,l_tlf2243            LIKE tlf_file.tlf21      #FUN-7C0028 add
 
   DECLARE wip_c3 CURSOR FOR
   SELECT tlf01,ima08,ima57,tlf02,tlf03,tlf13,SUM(tlf10*tlf60*tlf907*-1),
             SUM(tlf21*tlf907*-1),SUM(tlf221*tlf907*-1),SUM(tlf222*tlf907*-1),
             SUM(tlf2231*tlf907*-1),SUM(tlf2232*tlf907*-1),SUM(tlf224*tlf907*-1)    #No.A102
            ,SUM(tlf2241*tlf907*-1),SUM(tlf2242*tlf907*-1),SUM(tlf2243*tlf907*-1)   #FUN-7C0028 add
              FROM tlf_file,ima_file
             WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
               AND ((tlf02=50 AND tlf03 BETWEEN 60 AND 69) OR
                   (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
               AND tlf13 MATCHES 'asfi5*' #工單發退料者
               AND tlf907 != 0
               AND tlfcost=g_tlfcost   #FUN-7C0028 add
             GROUP BY tlf01,ima08,ima57,tlf02,tlf03,tlf13
   FOREACH wip_c3 INTO l_tlf01,l_ima08,l_ima57,l_tlf02,l_tlf03,l_tlf13,l_tlf10,
                       l_tlf21,l_tlf221,l_tlf222,l_tlf2231,l_tlf2232,l_tlf224   #No.A102
                      ,l_tlf2241,l_tlf2242,l_tlf2243   #FUN-7C0028 add 
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','wip_c3',SQLCA.sqlcode,0)   #No.FUN-710027        
        EXIT FOREACH
     END IF
     IF l_ima08 IS NULL THEN LET l_ima08='P' END IF
     IF l_tlf01=g_sfb.sfb05 THEN LET l_ima08='R' END IF #主/元料號同表重工
     IF l_ima57 = g_ima57_t THEN LET l_ima08='R' END IF #成本階相等表重工
     IF l_ima57 < g_ima57_t THEN LET l_ima08='W' END IF #成本階較低表上階重工
     LET l_c23=0
     LET l_c23a=0 LET l_c23b=0 LET l_c23c=0 LET l_c23d=0 LET l_c23e=0
     LET l_c23f=0 LET l_c23g=0 LET l_c23h=0    #FUN-7C0028 add
 
     CASE                        # 取發料單價
        WHEN l_ima08 MATCHES '[RW]' # (本階重工者取重工前庫存月平均)
            SELECT ccc12a+ccc22a, ccc12b+ccc22b, ccc12c+ccc22c,
                   ccc12d+ccc22d, ccc12e+ccc22e,
                   ccc12f+ccc22f, ccc12g+ccc22g, ccc12h+ccc22h,  #FUN-7C0028 add
                   ccc12 +ccc22 , ccc11 +ccc21
              INTO l_c22a,l_c22b,l_c22c,l_c22d,l_c22e,
                   l_c22f,l_c22g,l_c22h,  #FUN-7C0028 add
                   l_c22,l_c21
              FROM ccc_file
             WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
               AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
                    # (上階重工者取上月庫存月平均)
           IF l_ima08='W' OR STATUS OR l_c21 = 0 OR l_c21 IS NULL THEN
              LET l_c23a=0 LET l_c23b=0 LET l_c23c=0
              LET l_c23d=0 LET l_c23e=0 LET l_c23 =0
              LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add 
           ELSE
              LET l_c23a=l_c22a/l_c21
              LET l_c23b=l_c22b/l_c21
              LET l_c23c=l_c22c/l_c21
              LET l_c23d=l_c22d/l_c21
              LET l_c23e=l_c22e/l_c21
              LET l_c23f=l_c22f/l_c21   #FUN-7C0028 add
              LET l_c23g=l_c22g/l_c21   #FUN-7C0028 add
              LET l_c23h=l_c22h/l_c21   #FUN-7C0028 add 
              LET l_c23 =l_c22 /l_c21
           END IF
           #------ (無單價再取上月庫存月平均)
           IF l_c23a=0 AND l_c23b=0 AND l_c23c=0 AND l_c23d=0 AND l_c23e=0
                       AND l_c23f=0 AND l_c23g=0 AND l_c23h=0 THEN   #FUN-7C0028 add l_c23f,g,h
                 SELECT cca23a,cca23b,cca23c,cca23d,cca23e,
                        cca23f,cca23g,cca23h,cca23   #FUN-7C0028 add cca23f,g,h
                   INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                        l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                   FROM cca_file
                  WHERE cca01=l_tlf01 AND cca02=last_yy AND cca03=last_mm
                    AND cca06=type    AND cca07=g_tlfcost   #FUN-7C0028 add 
                 #  若上期仍無單價, 則取上期開帳單價
              IF SQLCA.sqlcode OR
                 (l_c23a=0 AND l_c23b=0 AND l_c23c=0 AND l_c23d=0 AND l_c23e
                           AND l_c23f=0 AND l_c23g=0 AND l_c23h=0) THEN   #FUN-7C0028 add l_c23f,g,h 
                    SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                           ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
                      INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                           l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
                      FROM ccc_file
                     WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
                       AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
                 IF STATUS THEN
                    LET g_msg=l_tlf01,"子階領父階，須給開帳成本單價"
                    LET t_time = TIME
                    LET g_time=t_time
                   #FUN-A50075--mod--str-- ccy_file del plant&legal
                   #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
                   #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
                    INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                                  VALUES(TODAY,g_time,g_user,g_msg)
                   #FUN-A50075--mod--end
                    LET l_c23a=9999.9999
                    LET l_c23 =l_c23a
                 END IF
              END IF
           END IF
      OTHERWISE                   # (取當月庫存月平均檔)
           SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                  ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
             INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                  l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h
             FROM ccc_file
            WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
              AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
     END CASE
 
     CALL p510_cch_01() # 將 cch 歸 0
     LET g_cch.cch01 =g_sfb.sfb01
     LET g_cch.cch04 =l_tlf01
     LET g_cch.cch06 =type        #FUN-7C0028 add
     LET g_cch.cch07 =g_tlfcost   #FUN-7C0028 add 
     IF l_ima08 = 'W' THEN LET l_ima08='R' END IF
     LET g_cch.cch05 =l_ima08
     LET g_cch.cch21 =l_tlf10
     LET g_cch.cch22a=l_tlf10*l_c23a
     LET g_cch.cch22b=l_tlf10*l_c23b
     LET g_cch.cch22c=l_tlf10*l_c23c
     LET g_cch.cch22d=l_tlf10*l_c23d
     LET g_cch.cch22e=l_tlf10*l_c23e
     LET g_cch.cch22f=l_tlf10*l_c23f   #FUN-7C0028 add
     LET g_cch.cch22g=l_tlf10*l_c23g   #FUN-7C0028 add 
     LET g_cch.cch22h=l_tlf10*l_c23h   #FUN-7C0028 add 
     LET g_cch.cch22 =g_cch.cch22a+g_cch.cch22b+g_cch.cch22c+
                      g_cch.cch22d+g_cch.cch22e
                     +g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add 
 
   #-->本期超領退 modify by apple
     IF l_tlf13 = 'asfi512' OR l_tlf13 = 'asfi527' THEN
        LET g_cch.cch57 =l_tlf10
        LET g_cch.cch58a=l_tlf10*l_c23a
        LET g_cch.cch58b=l_tlf10*l_c23b
        LET g_cch.cch58c=l_tlf10*l_c23c
        LET g_cch.cch58d=l_tlf10*l_c23d
        LET g_cch.cch58e=l_tlf10*l_c23e
        LET g_cch.cch58f=l_tlf10*l_c23f   #FUN-7C0028 add
        LET g_cch.cch58g=l_tlf10*l_c23g   #FUN-7C0028 add
        LET g_cch.cch58h=l_tlf10*l_c23h   #FUN-7C0028 add 
        LET g_cch.cch58 =g_cch.cch58a+g_cch.cch58b+g_cch.cch58c+
                         g_cch.cch58d+g_cch.cch58e
                        +g_cch.cch58f+g_cch.cch58g+g_cch.cch58h   #FUN-7C0028 add 
        #-->累計超領退
         LET g_cch.cch55  = g_cch.cch57
         LET g_cch.cch56  = g_cch.cch58
         LET g_cch.cch56a = g_cch.cch58a
         LET g_cch.cch56b = g_cch.cch58b
         LET g_cch.cch56c = g_cch.cch58c
         LET g_cch.cch56d = g_cch.cch58d
         LET g_cch.cch56e = g_cch.cch58e
         LET g_cch.cch56f = g_cch.cch58f   #FUN-7C0028 add
         LET g_cch.cch56g = g_cch.cch58g   #FUN-7C0028 add
         LET g_cch.cch56h = g_cch.cch58h   #FUN-7C0028 add 
     END IF
     #-->累計投入  modify by apple
     LET g_cch.cch51  =g_cch.cch51 +g_cch.cch21
     LET g_cch.cch52a =g_cch.cch52a+g_cch.cch22a
     LET g_cch.cch52b =g_cch.cch52b+g_cch.cch22b
     LET g_cch.cch52c =g_cch.cch52c+g_cch.cch22c
     LET g_cch.cch52d =g_cch.cch52d+g_cch.cch22d
     LET g_cch.cch52e =g_cch.cch52e+g_cch.cch22e
     LET g_cch.cch52f =g_cch.cch52f+g_cch.cch22f   #FUN-7C0028 add
     LET g_cch.cch52g =g_cch.cch52g+g_cch.cch22g   #FUN-7C0028 add
     LET g_cch.cch52h =g_cch.cch52h+g_cch.cch22h   #FUN-7C0028 add 
     LET g_cch.cch52  =g_cch.cch52a+g_cch.cch52b+g_cch.cch52c+
                       g_cch.cch52d+g_cch.cch52e
                      +g_cch.cch52f+g_cch.cch52g+g_cch.cch52h   #FUN-7C0028 add 
     LET g_cch.cchdate = g_today
    #LET g_cch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
     LET g_cch.cchlegal = g_legal #FUN-980009 add
 
     LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO cch_file VALUES(g_cch.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
        LET g_showmsg=g_cch.cch01,"/",g_cch.cch02                                                                    #No.FUN-710027
        CALL s_errmsg('cch01,cch02',g_showmsg,'wip_2_21() ins cch:',SQLCA.SQLCODE,1)                                        #No.FUN-710027
        LET g_msg=g_cch.cch01,g_cch.cch04
        CALL s_errmsg('cch01,cch02',g_msg,'',SQLCA.SQLCODE,1)                                      #No.FUN-710027
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
        UPDATE cch_file SET cch05=g_cch.cch05,
                            cch21=cch21+g_cch.cch21,
                            cch22=cch22+g_cch.cch22,
                            cch22a=cch22a+g_cch.cch22a,
                            cch22b=cch22b+g_cch.cch22b,
                            cch22c=cch22c+g_cch.cch22c,
                            cch22d=cch22d+g_cch.cch22d,
                            cch22e=cch22e+g_cch.cch22e,
                            cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                            cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                            cch22h=cch22h+g_cch.cch22h,   #FUN-7C0028 add 
                            cch51=cch51  +g_cch.cch21,    #modify by apple
                            cch52=cch52  +g_cch.cch22,
                            cch52a=cch52a+g_cch.cch22a,
                            cch52b=cch52b+g_cch.cch22b,
                            cch52c=cch52c+g_cch.cch22c,
                            cch52d=cch52d+g_cch.cch22d,
                            cch52e=cch52e+g_cch.cch22e,
                            cch52f=cch52f+g_cch.cch52f,   #FUN-7C0028 add
                            cch52g=cch52g+g_cch.cch52g,   #FUN-7C0028 add
                            cch52h=cch52h+g_cch.cch52h,   #FUN-7C0028 add 
                            cch55 =cch55  +g_cch.cch55,    #modify by apple
                            cch56 =cch56  +g_cch.cch56,
                            cch56a=cch56a+g_cch.cch56a,
                            cch56b=cch56b+g_cch.cch56b,
                            cch56c=cch56c+g_cch.cch56c,
                            cch56d=cch56d+g_cch.cch56d,
                            cch56e=cch56e+g_cch.cch56e,
                            cch56f=cch56f+g_cch.cch56f,   #FUN-7C0028 add
                            cch56g=cch56g+g_cch.cch56g,   #FUN-7C0028 add
                            cch56h=cch56h+g_cch.cch56h,   #FUN-7C0028 add 
                            cch57 =cch57+g_cch.cch57,     #modify by apple
                            cch58 =cch58+g_cch.cch58,
                            cch58a=cch58a+g_cch.cch58a,
                            cch58b=cch58b+g_cch.cch58b,
                            cch58c=cch58c+g_cch.cch58c,
                            cch58d=cch58d+g_cch.cch58d,
                            cch58e=cch58e+g_cch.cch58e,
                            cch58f=cch58f+g_cch.cch58f,   #FUN-7C0028 add
                            cch58g=cch58g+g_cch.cch58g,   #FUN-7C0028 add
                            cch58h=cch58h+g_cch.cch58h    #FUN-7C0028 add 
            WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
              AND cch04=l_tlf01
              AND cch06=g_cch.cch06 AND cch07=g_cch.cch07   #FUN-7C0028 add 
     END IF
   END FOREACH
   CLOSE wip_c3
END FUNCTION
 
#WIP-元件 本期投入材料 (依工單發料/退料檔)
FUNCTION work_2_21()
   DEFINE l_ima08               LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   DEFINE l_ima57               LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_tlf01               LIKE tlf_file.tlf01          #No.MOD-490217
   DEFINE l_tlf02,l_tlf03       LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_tlf10               LIKE cch_file.cch21          #No.FUN-680122 DEC(15,3)
   DEFINE l_tlf13               LIKE tlf_file.tlf13
   DEFINE l_c21                 LIKE cae_file.cae07          #No.FUN-680122 DEC(15,5)
   DEFINE l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6) #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                     LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6) #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                     LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE caf06_backup          LIKE caf_file.caf06
   DEFINE l_tlf62               LIKE tlf_file.tlf62
   DEFINE l_p01                 LIKE oea_file.oea01,         #No.FUN-680122 VARCHAR(16),     #No.FUN-550025
          l_p02                 LIKE type_file.num5,         #No.FUN-680122 SMALLINT,
          l_p03                 LIKE aab_file.aab02,         #No.FUN-680122 VARCHAR(6),
#         l_source_out,l_source_out2  LIKE ima_file.ima26,   #No.FUN-680122 DEC(15,3),
          l_source_out,l_source_out2  LIKE type_file.num15_3,###GP5.2  #NO.FUN-A20044
          l_rate                LIKE ima_file.ima18,         #No.FUN-680122 DEC(9,3),
          l_p04                 LIKE type_file.chr20         #No.FUN-680122 VARCHAR(10)
   DEFINE x_cxh31               LIKE cxh_file.cxh31 ,
          x_cxh32               LIKE cxh_file.cxh32,
          x_cxh32a              LIKE cxh_file.cxh32a,
          x_cxh32b              LIKE cxh_file.cxh32b,
          x_cxh32c              LIKE cxh_file.cxh32c,
          x_cxh32d              LIKE cxh_file.cxh32d,
          x_cxh32e              LIKE cxh_file.cxh32e,
          x_cxh32f              LIKE cxh_file.cxh32f,   #FUN-7C0028 add
          x_cxh32g              LIKE cxh_file.cxh32g,   #FUN-7C0028 add
          x_cxh32h              LIKE cxh_file.cxh32h    #FUN-7C0028 add
   DEFINE x_cxh35               LIKE cxh_file.cxh35 ,
          x_cxh36               LIKE cxh_file.cxh36,
          x_cxh36a              LIKE cxh_file.cxh36a,
          x_cxh36b              LIKE cxh_file.cxh36b,
          x_cxh36c              LIKE cxh_file.cxh36c,
          x_cxh36d              LIKE cxh_file.cxh36d,
          x_cxh36e              LIKE cxh_file.cxh36e,
          x_cxh36f              LIKE cxh_file.cxh36f,   #FUN-7C0028 add
          x_cxh36g              LIKE cxh_file.cxh36g,   #FUN-7C0028 add
          x_cxh36h              LIKE cxh_file.cxh36h    #FUN-7C0028 add
   DEFINE x_cxh39               LIKE cxh_file.cxh39,
          x_cxh40               LIKE cxh_file.cxh40,
          x_cxh40a              LIKE cxh_file.cxh40a,
          x_cxh40b              LIKE cxh_file.cxh40b,
          x_cxh40c              LIKE cxh_file.cxh40c,
          x_cxh40d              LIKE cxh_file.cxh40d,
          x_cxh40e              LIKE cxh_file.cxh40e,
          x_cxh40f              LIKE cxh_file.cxh40f,   #FUN-7C0028 add
          x_cxh40g              LIKE cxh_file.cxh40g,   #FUN-7C0028 add
          x_cxh40h              LIKE cxh_file.cxh40h    #FUN-7C0028 add
   DEFINE l_cae07               LIKE cae_file.cae07   #
   DEFINE l_rvv01               LIKE rvv_file.rvv01,
          l_rvv02               LIKE rvv_file.rvv02,
          l_rvv39               LIKE rvv_file.rvv39,
          l_rvb01               LIKE rvb_file.rvb01,
          l_rvb02               LIKE rvb_file.rvb02
   DEFINE l_cae08               LIKE cae_file.cae08
   DEFINE l_sfa161              LIKE sfa_file.sfa161
   DEFINE l_tlf21,l_tlf221,l_tlf222,l_tlf2231    LIKE tlf_file.tlf21
   DEFINE l_tlf224,l_tlf2241,l_tlf2242,l_tlf2243 LIKE tlf_file.tlf21   #FUN-7C0028 add
 
   #重工工單因備料未指定製程站,故材料成本一律歸入第一站
   IF g_sfb.sfb02='5' THEN
     #IF g_caf.caf05 !=ecm03_min THEN RETURN END IF #FUN-A60095 mark
      IF NOT (g_caf.caf05=ecm03_min AND g_caf.caf012=ecm012_min) THEN RETURN END IF #FUN-A60095
      LET caf06_backup=g_caf.caf06
      LET g_caf.caf06=''
   END IF
 
   DECLARE work_c3 CURSOR FOR
     SELECT tlf01,ima08,ima57,tlf02,tlf03,tlf13,SUM(tlf10*tlf60*tlf907*-1),
            SUM(tlf21*tlf907*-1),SUM(tlf221*tlf907*-1),SUM(tlf222*tlf907*-1),
            SUM(tlf2231*tlf907*-1)
           ,SUM(tlf224*tlf907*-1),SUM(tlf2241*tlf907*-1),SUM(tlf2242*tlf907*-1),SUM(tlf2243*tlf907*-1)   #FUN-7C0028 add
       FROM tlf_file,ima_file
      WHERE tlf62=g_sfb.sfb01
        AND tlf06 BETWEEN g_bdate AND g_edate
        AND ((tlf02=50 AND tlf03 BETWEEN 60 AND 69) OR
            (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
        AND tlf13 MATCHES 'asfi5*' #工單發退料者
        AND tlf05=g_ecm.ecm04      #g_caf.caf06  #作業編號
        AND tlf907 != 0
        AND tlfcost=g_tlfcost   #FUN-7C0028 add
      GROUP BY tlf01,ima08,ima57,tlf02,tlf03,tlf13
   FOREACH work_c3 INTO l_tlf01,l_ima08,l_ima57,l_tlf02,l_tlf03,
                        l_tlf13,l_tlf10,l_tlf21,l_tlf221,l_tlf222,l_tlf2231
                       ,l_tlf224,l_tlf2241,l_tlf2242,l_tlf2243   #FUN-7C0028 add
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','wip_c3',SQLCA.sqlcode,0) #No.FUN-710027
        EXIT FOREACH
     END IF
     IF l_ima08 IS NULL THEN LET l_ima08='P' END IF
     IF l_tlf01=g_sfb.sfb05 THEN LET l_ima08='R' END IF #主/元料號同表重工
     IF l_ima57 = g_ima57_t THEN LET l_ima08='R' END IF #成本階相等表重工
     IF l_ima57 < g_ima57_t THEN LET l_ima08='W' END IF #成本階較低表上階重工
     LET l_c23=0
     LET l_c23a=0 LET l_c23b=0 LET l_c23c=0 LET l_c23d=0 LET l_c23e=0
     LET l_c23f=0 LET l_c23g=0 LET l_c23h=0    #FUN-7C0028 add
 
     LET g_caf.caf06=caf06_backup
     CASE                           # 取發料單價
        WHEN l_ima08 MATCHES '[RW]' # (本階重工者取重工前庫存月平均)
           SELECT ccc12a+ccc22a, ccc12b+ccc22b, ccc12c+ccc22c,
                  ccc12d+ccc22d, ccc12e+ccc22e,
                  ccc12f+ccc22f, ccc12g+ccc22g, ccc12h+ccc22h,   #FUN-7C0028 add
                  ccc12 +ccc22 , ccc11 +ccc21
              INTO l_c22a,l_c22b,l_c22c,l_c22d,l_c22e,
                   l_c22f,l_c22g,l_c22h,    #FUN-7C0028 add
                   l_c22,l_c21
              FROM ccc_file
              WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
                AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
                    # (上階重工者取上月庫存月平均)
           IF l_ima08='W' OR STATUS OR l_c21 = 0 OR l_c21 IS NULL THEN
              LET l_c23a=0 LET l_c23b=0 LET l_c23c=0
              LET l_c23d=0 LET l_c23e=0 LET l_c23 =0
              LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
           ELSE
              LET l_c23a=l_c22a/l_c21
              LET l_c23b=l_c22b/l_c21
              LET l_c23c=l_c22c/l_c21
              LET l_c23d=l_c22d/l_c21
              LET l_c23e=l_c22e/l_c21
              LET l_c23f=l_c22f/l_c21   #FUN-7C0028 add
              LET l_c23g=l_c22g/l_c21   #FUN-7C0028 add
              LET l_c23h=l_c22h/l_c21   #FUN-7C0028 add
              LET l_c23 =l_c22 /l_c21
           END IF
           #------ (無單價再取上月庫存月平均)
           IF l_c23a = 0 AND l_c23b = 0 AND l_c23c = 0 AND l_c23d = 0 AND 
              l_c23e = 0 AND l_c23f = 0 AND l_c23g = 0 AND l_c23h = 0 THEN   #FUN-7C0028 add
              SELECT cca23a,cca23b,cca23c,cca23d,cca23e,
                     cca23f,cca23g,cca23h,cca23    #FUN-7C0028 add cca23f,g,h
                INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                     l_c23f,l_c23g,l_c23h,l_c23    #FUN-7C0028 add l_c23f,g,h
                FROM cca_file
               WHERE cca01=l_tlf01 AND cca02=last_yy AND cca03=last_mm
                 AND cca06=type    AND cca07=g_tlfcost   #FUN-7C0028 add
                 # 若上期仍無單價, 則取上期開帳單價
              IF SQLCA.sqlcode OR
                 (l_c23a = 0 AND l_c23b = 0 AND l_c23c = 0 AND l_c23d = 0 AND
                  l_c23e = 0 AND l_c23f = 0 AND l_c23g = 0 AND l_c23h = 0) THEN   #FUN-7C0028 add
                 SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                        ccc23f,ccc23g,ccc23h,ccc23    #FUN-7C0028 add ccc23f,g,h
                   INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                        l_c23f,l_c23g,l_c23h,l_c23    #FUN-7C0028 add l_c23f,g,h
                   FROM ccc_file
                  WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
                    AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
                 IF STATUS THEN
                    LET g_msg=l_tlf01,"子階領父階，須給開帳成本單價"
                    LET t_time = TIME
                    LET g_time=t_time
                   #FUN-A50075--mod--str-- ccy_file del plant&legal
                   #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
                   #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
                    INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                                  VALUES(TODAY,g_time,g_user,g_msg)
                   #FUN-A50075--mod--end
                    LET l_c23a=9999.9999
                    LET l_c23 =l_c23a
                 END IF
              END IF
           END IF
      OTHERWISE                   # (取當月庫存月平均檔)
           SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                  ccc23f,ccc23g,ccc23h,ccc23    #FUN-7C0028 add ccc23f,g,h
             INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                  l_c23f,l_c23g,l_c23h,l_c23    #FUN-7C0028 add l_c23f,g,h
             FROM ccc_file
            WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
              AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add
     END CASE
 
     CALL p510_cxh_01() # 將 cxh 歸 0
     LET g_cxh.cxh01 =g_sfb.sfb01
     LET g_cxh.cxh012=g_ecm.ecm04  #g_caf.caf06
     LET g_cxh.cxh013=g_ecm.ecm012 #FUN-A60095
     LET g_cxh.cxh014=g_ecm.ecm03  #FUN-A60095
     LET g_cxh.cxh04 =l_tlf01
     IF l_ima08 = 'W' THEN LET l_ima08='R' END IF
     LET g_cxh.cxh05 =l_ima08
     LET g_cxh.cxh06 =type        #FUN-7C0028 add
     LET g_cxh.cxh07 =g_tlfcost   #FUN-7C0028 add
    #IF g_cxh.cxh012 =ecm04_min THEN #只有第一站有投入量  #FUN-A60095
     IF (g_cxh.cxh013 =ecm012_min) AND (g_cxh.cxh014 =ecm03_min) THEN #只有第一站有投入量  #FUN-A60095
        LET g_cxh.cxh21 =l_tlf10
     ELSE
        LET g_cxh.cxh21 =0
     END IF
     LET g_cxh.cxh21 =l_tlf10 #FUN-660142
     LET g_cxh.cxh22a=l_tlf10*l_c23a
     LET g_cxh.cxh22b=l_tlf10*l_c23b
     LET g_cxh.cxh22c=l_tlf10*l_c23c
     LET g_cxh.cxh22d=l_tlf10*l_c23d
     LET g_cxh.cxh22e=l_tlf10*l_c23e
     LET g_cxh.cxh22f=l_tlf10*l_c23f   #FUN-7C0028 add
     LET g_cxh.cxh22g=l_tlf10*l_c23g   #FUN-7C0028 add
     LET g_cxh.cxh22h=l_tlf10*l_c23h   #FUN-7C0028 add
     LET g_cxh.cxh22 =g_cxh.cxh22a+g_cxh.cxh22b+g_cxh.cxh22c+
                      g_cxh.cxh22d+g_cxh.cxh22e
                     +g_cxh.cxh22f+g_cxh.cxh22g+g_cxh.cxh22h   #FUN-7C0028 add
     IF g_cxh.cxh22=0 THEN  RETURN END IF
 
     ## 超領退應為 asfi512&asfi527
     IF l_tlf13 = 'asfi512' OR l_tlf13 = 'asfi527' THEN
        LET g_cxh.cxh57 =l_tlf10
        LET g_cxh.cxh58a=l_tlf10*l_c23a
        LET g_cxh.cxh58b=l_tlf10*l_c23b
        LET g_cxh.cxh58c=l_tlf10*l_c23c
        LET g_cxh.cxh58d=l_tlf10*l_c23d
        LET g_cxh.cxh58e=l_tlf10*l_c23e
        LET g_cxh.cxh58f=l_tlf10*l_c23f   #FUN-7C0028 add
        LET g_cxh.cxh58g=l_tlf10*l_c23g   #FUN-7C0028 add
        LET g_cxh.cxh58h=l_tlf10*l_c23h   #FUN-7C0028 add
        LET g_cxh.cxh58 =g_cxh.cxh58a+g_cxh.cxh58b+g_cxh.cxh58c+
                         g_cxh.cxh58d+g_cxh.cxh58e
                        +g_cxh.cxh58f+g_cxh.cxh58g+g_cxh.cxh58h   #FUN-7C0028 add
        #-->累計超領退
         LET g_cxh.cxh55  = g_cxh.cxh57
         LET g_cxh.cxh56  = g_cxh.cxh58
         LET g_cxh.cxh56a = g_cxh.cxh58a
         LET g_cxh.cxh56b = g_cxh.cxh58b
         LET g_cxh.cxh56c = g_cxh.cxh58c
         LET g_cxh.cxh56d = g_cxh.cxh58d
         LET g_cxh.cxh56e = g_cxh.cxh58e
         LET g_cxh.cxh56f = g_cxh.cxh58f   #FUN-7C0028 add
         LET g_cxh.cxh56g = g_cxh.cxh58g   #FUN-7C0028 add
         LET g_cxh.cxh56h = g_cxh.cxh58h   #FUN-7C0028 add
     END IF
     #-->累計投入  modify by apple
     LET g_cxh.cxh51  =g_cxh.cxh51 +g_cxh.cxh21
     LET g_cxh.cxh52a =g_cxh.cxh52a+g_cxh.cxh22a
     LET g_cxh.cxh52b =g_cxh.cxh52b+g_cxh.cxh22b
     LET g_cxh.cxh52c =g_cxh.cxh52c+g_cxh.cxh22c
     LET g_cxh.cxh52d =g_cxh.cxh52d+g_cxh.cxh22d
     LET g_cxh.cxh52e =g_cxh.cxh52e+g_cxh.cxh22e
     LET g_cxh.cxh52f =g_cxh.cxh52f+g_cxh.cxh22f   #FUN-7C0028 add
     LET g_cxh.cxh52g =g_cxh.cxh52g+g_cxh.cxh22g   #FUN-7C0028 add
     LET g_cxh.cxh52h =g_cxh.cxh52h+g_cxh.cxh22h   #FUN-7C0028 add
     LET g_cxh.cxh52  =g_cxh.cxh52a+g_cxh.cxh52b+g_cxh.cxh52c+
                       g_cxh.cxh52d+g_cxh.cxh52e
                      +g_cxh.cxh52f+g_cxh.cxh52g+g_cxh.cxh52h   #FUN-7C0028 add
     LET g_cxh.cxhdate = g_today
     LET g_cxh.cxhuser = g_user
     LET g_cxh.cxhtime = TIME
    #LET g_cxh.cxhplant = g_plant #FUN-980009 add    #FUN-A50075
     LET g_cxh.cxhlegal = g_legal #FUN-980009 add
 
     LET g_cxh.cxhoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cxh.cxhorig = g_grup      #No.FUN-980030 10/01/04
     IF g_cxh.cxh013 IS NULL THEN LET g_cxh.cxh013=' ' END IF #FUN-A60095
     IF g_cxh.cxh014 IS NULL THEN LET g_cxh.cxh014=0   END IF #FUN-A60095
     INSERT INTO cxh_file VALUES(g_cxh.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
        LET g_showmsg=g_cxh.cxh01,"/",g_cxh.cxh02                                                                  #No.FUN-710027
        CALL s_errmsg('cxh01,cxh02',g_showmsg,'wip_2_21() ins cxh:',SQLCA.SQLCODE,1)                                      #No.FUN-710027  
        LET g_msg=g_cxh.cxh01,g_cxh.cxh04
        CALL s_errmsg('',g_msg,'ins cxh',SQLCA.SQLCODE,1)                               #No.FUN-710027        
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
        UPDATE cxh_file SET cxh05=g_cxh.cxh05,
        		    cxh21=cxh21+g_cxh.cxh21,
        		    cxh22=cxh22+g_cxh.cxh22,
        		    cxh22a=cxh22a+g_cxh.cxh22a,
        		    cxh22b=cxh22b+g_cxh.cxh22b,
        		    cxh22c=cxh22c+g_cxh.cxh22c,
        		    cxh22d=cxh22d+g_cxh.cxh22d,
        		    cxh22e=cxh22e+g_cxh.cxh22e,
                cxh22f=cxh22f+g_cxh.cxh22f,   #FUN-7C0028 add 
                cxh22g=cxh22g+g_cxh.cxh22g,   #FUN-7C0028 add 
                cxh22h=cxh22h+g_cxh.cxh22h,   #FUN-7C0028 add 
        		    cxh24 =g_cxh.cxh24,
        		    cxh25 =g_cxh.cxh25,
        		    cxh25a=g_cxh.cxh25a,
        		    cxh25b=g_cxh.cxh25b,
        		    cxh25c=g_cxh.cxh25c,
        		    cxh25d=g_cxh.cxh25d,
        		    cxh25e=g_cxh.cxh25e,
        		    cxh25f=g_cxh.cxh25f,   #FUN-7C0028 add
        		    cxh25g=g_cxh.cxh25g,   #FUN-7C0028 add
        		    cxh25h=g_cxh.cxh25h,   #FUN-7C0028 add
        		    cxh26 =g_cxh.cxh26,
        		    cxh27 =g_cxh.cxh27,
        		    cxh27a=g_cxh.cxh27a,
        		    cxh27b=g_cxh.cxh27b,
        		    cxh27c=g_cxh.cxh27c,
        		    cxh27d=g_cxh.cxh27d,
        		    cxh27e=g_cxh.cxh27e,
        		    cxh27f=g_cxh.cxh27f,   #FUN-7C0028 add
        		    cxh27g=g_cxh.cxh27g,   #FUN-7C0028 add
        		    cxh27h=g_cxh.cxh27h,   #FUN-7C0028 add
        		    cxh28 =g_cxh.cxh28,
        		    cxh29 =g_cxh.cxh29,
        		    cxh29a=g_cxh.cxh29a,
        		    cxh29b=g_cxh.cxh29b,
        		    cxh29c=g_cxh.cxh29c,
        		    cxh29d=g_cxh.cxh29d,
        		    cxh29e=g_cxh.cxh29e,
        		    cxh29f=g_cxh.cxh29f,   #FUN-7C0028 add
        		    cxh29g=g_cxh.cxh29g,   #FUN-7C0028 add
        		    cxh29h=g_cxh.cxh29h,   #FUN-7C0028 add
        		    cxh51=cxh51  +g_cxh.cxh21,
        		    cxh52=cxh52  +g_cxh.cxh22,
        		    cxh52a=cxh52a+g_cxh.cxh22a,
        		    cxh52b=cxh52b+g_cxh.cxh22b,
        		    cxh52c=cxh52c+g_cxh.cxh22c,
        		    cxh52d=cxh52d+g_cxh.cxh22d,
        		    cxh52e=cxh52e+g_cxh.cxh22e,
        		    cxh52f=cxh52f+g_cxh.cxh22f,   #FUN-7C0028 add
        		    cxh52g=cxh52g+g_cxh.cxh22g,   #FUN-7C0028 add
        		    cxh52h=cxh52h+g_cxh.cxh22h,   #FUN-7C0028 add
        		    cxh55 =cxh55 +g_cxh.cxh55,
        		    cxh56 =cxh56 +g_cxh.cxh56,
        		    cxh56a=cxh56a+g_cxh.cxh56a,
        		    cxh56b=cxh56b+g_cxh.cxh56b,
        		    cxh56c=cxh56c+g_cxh.cxh56c,
        		    cxh56d=cxh56d+g_cxh.cxh56d,
        		    cxh56e=cxh56e+g_cxh.cxh56e,
        		    cxh56f=cxh56f+g_cxh.cxh56f,   #FUN-7C0028 add
        		    cxh56g=cxh56g+g_cxh.cxh56g,   #FUN-7C0028 add
        		    cxh56h=cxh56h+g_cxh.cxh56h,   #FUN-7C0028 add
        		    cxh57 =cxh57 +g_cxh.cxh57,
        		    cxh58 =cxh58 +g_cxh.cxh58,
        		    cxh58a=cxh58a+g_cxh.cxh58a,
        		    cxh58b=cxh58b+g_cxh.cxh58b,
        		    cxh58c=cxh58c+g_cxh.cxh58c,
        		    cxh58d=cxh58d+g_cxh.cxh58d,
        		    cxh58e=cxh58e+g_cxh.cxh58e,
        		    cxh58f=cxh58f+g_cxh.cxh58f,   #FUN-7C0028 add
        		    cxh58g=cxh58g+g_cxh.cxh58g,   #FUN-7C0028 add
        		    cxh58h=cxh58h+g_cxh.cxh58h    #FUN-7C0028 add
            WHERE cxh01=g_sfb.sfb01 AND cxh02=yy AND cxh03=mm
              AND cxh04=l_tlf01 
             #AND cxh012=g_caf.caf06   #FUN-670016 mark
              AND cxh012=g_ecm.ecm04   #FUN-670016
              AND cxh06 =g_cxh.cxh06   #FUN-7C0028 add
              AND cxh07 =g_cxh.cxh07   #FUN-7C0028 add
              AND cxh013=g_ecm.ecm012  #FUN-A60095
              AND cxh014=g_ecm.ecm03   #FUN-A60095
     END IF
   END FOREACH
   CLOSE work_c3
END FUNCTION
 
FUNCTION wip_2_22()     #  2-2. WIP-元件 本期投入人工製費
  DEFINE  l_cch22b  LIKE cch_file.cch22b
  DEFINE  l_cch22c  LIKE cch_file.cch22c
  DEFINE  l_cch22e  LIKE cch_file.cch22e     #FUN-7C0028 add
  DEFINE  l_cch22f  LIKE cch_file.cch22f     #FUN-7C0028 add
  DEFINE  l_cch22g  LIKE cch_file.cch22g     #FUN-7C0028 add
  DEFINE  l_cch22h  LIKE cch_file.cch22h     #FUN-7C0028 add
  DEFINE  l_ecm04   LIKE ecm_file.ecm04
  DEFINE  l_ccg20   LIKE ccg_file.ccg20
  DEFINE  l_dept    LIKE cre_file.cre08          #No.FUN-680122 VARCHAR(10)
  DEFINE  l_sql     LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400) 
  DEFINE  l_wo      RECORD LIKE cxz_file.*
  DEFINE  cam08_sum LIKE cam_file.cam08
  DEFINE  l_ecb19   LIKE ecb_file.ecb19
  DEFINE  l_ecb21   LIKE ecb_file.ecb21
  DEFINE  l_cac03   LIKE cac_file.cac03
  DEFINE  l_cae03   LIKE cae_file.cae03
  DEFINE  l_qty     LIKE cam_file.cam07
  DEFINE  l_cae07   LIKE cae_file.cae07
  DEFINE  l_cae08   LIKE cae_file.cae08
  DEFINE  l_cae041  LIKE cae_file.cae041   #CHI-970021
  DEFINE  l_cam02   LIKE cam_file.cam02
  DEFINE  l_cam01_b LIKE cam_file.cam01     #FUN-A90065
  DEFINE  l_cam01_e LIKE cam_file.cam01     #FUN-A90065
  DEFINE  l_correct LIKE type_file.chr1    #CHI-9A0021 add
  DEFINE  l_cae04   LIKE cae_file.cae04    #FUN-A90065
  DEFINE  l_cae05   LIKE cae_file.cae05    #FUN-A90065
  DEFINE  dl_t      LIKE cxz_file.cxz04    #FUN-A90065
  DEFINE  oh_t      LIKE cxz_file.cxz05    #FUN-A90065

   CALL p510_cch_01()   # 將 cch 歸 0
   LET g_cch.cch01 =g_sfb.sfb01
   LET g_cch.cch04 =' DL+OH+SUB'        # 料號為 ' DL+OH+SUB'
   LET g_cch.cch05 ='P'
   LET g_cch.cch06 =type        #FUN-7C0028 add
   LET g_cch.cch07 =g_tlfcost   #FUN-7C0028 add 
   LET g_cch.cch21 =mccg.ccg20

   #當月起始日與截止日
   CALL s_azm(yy,mm) RETURNING l_correct,l_cam01_b,l_cam01_e   #CHI-9A0021 add  #FUN-A90065
 
   #-->依年月/成本中心
   DECLARE wo_cur11 CURSOR FOR
    SELECT cxz_file.*,cae03,cae04,cae05,cae07,cae041,cae08   #FUN-A90065
      FROM cxz_file,cae_file   #,caa_file  #CHI-970021
     WHERE cxz01=g_sfb.sfb01
       AND cxz02=g_sfb.sfb98
       AND cxz02=cae03 AND cxz03=cae04
       AND cae01=yy AND cae02=mm
   LET l_cch22b=0
   LET l_cch22c=0
   FOREACH wo_cur11 INTO l_wo.*,l_cae03,l_cae04,l_cae05,l_cae07,l_cae041,l_cae08  #FUN-A90065
     IF STATUS THEN 
        CALL s_errmsg('','','wo_for11',STATUS,0)  #No.FUN-710027
        LET g_success='N'
        EXIT FOREACH
     END IF
      #FUN-A90065(S)
      LET dl_t=0
      LET oh_t=0
      CALL p510_dis(g_sfb.sfb01,l_cam01_b,l_cam01_e,l_cae03,
                    l_cae041,l_cae07,l_cae08) 
                    RETURNING dl_t,oh_t
      IF dl_t IS NULL THEN LET dl_t=0 END IF
      IF oh_t IS NULL THEN LET oh_t=0 END IF
      LET l_cch22b=l_cch22b + dl_t
      LET l_cch22c=l_cch22c + oh_t
      #FUN-A90065(E)
   END FOREACH 	
   LET g_cch.cch22b=l_cch22b
   LET g_cch.cch22c=l_cch22c 
 
   SELECT SUM(ABS(apb101)) INTO amt FROM pmn_file,apb_file,rvv_file   # 委外入庫   #No.TQC-7C0126
      WHERE pmn41=g_sfb.sfb01 AND pmn04=g_sfb.sfb05             # 剔除代買料
        AND pmn01=apb06 AND pmn02=apb07 AND apb29 = '1'
        AND apb21=rvv01 AND apb22=rvv02
        AND rvv09 BETWEEN g_bdate AND g_edate
        AND apb34 <> 'Y'  #No.TQC-7C0126
 
   SELECT SUM(ABS(apb101)) INTO amt2   #No.TQC-7C0126
     FROM pmn_file,apb_file,apa_file,rvv_file  # 委外退貨
      WHERE pmn41=g_sfb.sfb01 AND pmn04=g_sfb.sfb05             # 剔除代買料
        AND pmn01=apb06 AND pmn02=apb07 AND apb29 = '3'
        AND apb21=rvv01 AND apb22=rvv02
        AND rvv09 BETWEEN g_bdate AND g_edate
        AND apb01 = apa01
        AND apa42 = 'N'
        AND apa58 = '2' #991213 Star
        AND apb34 <> 'Y'  #No.TQC-7C0126
   IF amt  IS NULL THEN LET amt =0 END IF
   IF amt2 IS NULL THEN LET amt2=0 END IF
   LET g_cch.cch22d = amt - amt2                                # 委外加工成本
 
   LET g_cch.cch52d = g_cch.cch52d + g_cch.cch22d
   LET g_cch.cch52  = g_cch.cch52a+g_cch.cch52b+g_cch.cch52c+
                      g_cch.cch52d+g_cch.cch52e
                     +g_cch.cch52f+g_cch.cch52g+g_cch.cch52h   #FUN-7C0028 add 
   LET g_cch.cch22 =g_cch.cch22b+g_cch.cch22c+g_cch.cch22d
                   +g_cch.cch22e+g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add 
 
  #LET g_cch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
   LET g_cch.cchlegal = g_legal #FUN-980009 add
   IF g_cch.cch22 = 0 THEN LET g_cch.cch21 = 0 RETURN END IF
     LET g_cch.cchdate = g_today
     LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
     LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO cch_file VALUES(g_cch.*)
     IF STATUS THEN                     # 可能有上期轉入資料造成重複
        UPDATE cch_file SET cch21=cch21+g_cch.cch21,
                            cch22=cch22+g_cch.cch22,
                            cch22b=cch22b+g_cch.cch22b,
                            cch22c=cch22c+g_cch.cch22c,
                            cch22d=cch22d+g_cch.cch22d,
                            cch52d=cch52d+g_cch.cch22d,
                            cch22e=cch22e+g_cch.cch22e,
                            cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                            cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                            cch22h=cch22h+g_cch.cch22h,   #FUN-7C0028 add 
                            cch52 =g_cch.cch52
            WHERE cch01=g_cch.cch01 AND cch02=yy AND cch03=mm
              AND cch04=g_cch.cch04
              AND cch06=g_cch.cch06 AND cch07=g_cch.cch07   #FUN-7C0028 add 
     END IF
END FUNCTION
 
# WIP本期投入人工-製費-加工
FUNCTION work_2_22()
  DEFINE l_cxh22b  LIKE cxh_file.cxh22b
  DEFINE l_cxh22c  LIKE cxh_file.cxh22c
  DEFINE l_cxh22e  LIKE cxh_file.cxh22e   #FUN-7C0028 add
  DEFINE l_cxh22f  LIKE cxh_file.cxh22f   #FUN-7C0028 add
  DEFINE l_cxh22g  LIKE cxh_file.cxh22g   #FUN-7C0028 add
  DEFINE l_cxh22h  LIKE cxh_file.cxh22h   #FUN-7C0028 add
  DEFINE l_ecm04   LIKE ecm_file.ecm04
  DEFINE l_ccg20   LIKE ccg_file.ccg20
  DEFINE l_dept    LIKE type_file.chr20         #No.FUN-680122 VARCHAR(10)
  DEFINE l_wo      RECORD LIKE cxz_file.*
  DEFINE l_qty     LIKE cam_file.cam07
  DEFINE l_ecb19   LIKE ecb_file.ecb19
  DEFINE l_ecb21   LIKE ecb_file.ecb21
  DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(400) 
  DEFINE l_cnt,xxx_cnt LIKE type_file.num5      #No.FUN-680122 SMALLINT
  DEFINE l_cam02   LIKE cam_file.cam02
  DEFINE l_cae07   LIKE cae_file.cae07
  DEFINE l_cae041  LIKE cae_file.cae041   #CHI-970021 a04-->e041
  DEFINE l_cae03   LIKE cae_file.cae03
  DEFINE l_cae01   LIKE cae_file.cae01
  DEFINE l_cak03   LIKE cak_file.cak03
  DEFINE l_cae05   LIKE cae_file.cae05
  DEFINE l_cae04   LIKE cae_file.cae04
  DEFINE l_cae08   LIKE cae_file.cae08
  DEFINE l_p01     LIKE oea_file.oea01,        #No.FUN-680122 VARCHAR(16),                #No.FUN-550025
         l_p02     LIKE type_file.num5,        #No.FUN-680122 SMALLINT,
         l_p03     LIKE aab_file.aab02,        #No.FUN-680122 VARCHAR(6),
#        l_source_out,l_source_out2  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
         l_source_out,l_source_out2  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
         l_rate    LIKE ima_file.ima18,         #No.FUN-680122 DEC(9,3),
         l_p04     LIKE type_file.chr20         #No.FUN-680122 VARCHAR(10)
  DEFINE x_cxh31   LIKE cxh_file.cxh31 ,
         x_cxh32   LIKE cxh_file.cxh32,
         x_cxh32a  LIKE cxh_file.cxh32a,
         x_cxh32b  LIKE cxh_file.cxh32b,
         x_cxh32c  LIKE cxh_file.cxh32c,
         x_cxh32d  LIKE cxh_file.cxh32d,
         x_cxh32e  LIKE cxh_file.cxh32e,
         x_cxh32f  LIKE cxh_file.cxh32f,   #FUN-7C0028 add
         x_cxh32g  LIKE cxh_file.cxh32g,   #FUN-7C0028 add
         x_cxh32h  LIKE cxh_file.cxh32h    #FUN-7C0028 add
  DEFINE x_cxh35   LIKE cxh_file.cxh35 ,
         x_cxh36   LIKE cxh_file.cxh36,
         x_cxh36a  LIKE cxh_file.cxh36a,
         x_cxh36b  LIKE cxh_file.cxh36b,
         x_cxh36c  LIKE cxh_file.cxh36c,
         x_cxh36d  LIKE cxh_file.cxh36d,
         x_cxh36e  LIKE cxh_file.cxh36e,
         x_cxh36f  LIKE cxh_file.cxh36f,   #FUN-7C0028 add
         x_cxh36g  LIKE cxh_file.cxh36g,   #FUN-7C0028 add
         x_cxh36h  LIKE cxh_file.cxh36h    #FUN-7C0028 add
  DEFINE x_cxh39   LIKE cxh_file.cxh39 ,
         x_cxh40   LIKE cxh_file.cxh40,
         x_cxh40a  LIKE cxh_file.cxh40a,
         x_cxh40b  LIKE cxh_file.cxh40b,
         x_cxh40c  LIKE cxh_file.cxh40c,
         x_cxh40d  LIKE cxh_file.cxh40d,
         x_cxh40e  LIKE cxh_file.cxh40e,
         x_cxh40f  LIKE cxh_file.cxh40f,   #FUN-7C0028 add
         x_cxh40g  LIKE cxh_file.cxh40g,   #FUN-7C0028 add
         x_cxh40h  LIKE cxh_file.cxh40h    #FUN-7C0028 add
 #DEFINE cam07_sum LIKE cam_file.cam07     #FUN-A90065 mark no use
  DEFINE cam08_sum LIKE cam_file.cam08
  DEFINE l_cxh22d  LIKE cxh_file.cxh22d
  DEFINE l_rvv01   LIKE rvv_file.rvv01
  DEFINE l_rvv02   LIKE rvv_file.rvv02
  DEFINE l_rvv39   LIKE rvv_file.rvv39
  DEFINE l_rvb01   LIKE rvb_file.rvb01
  DEFINE l_rvb02   LIKE rvb_file.rvb02
  DEFINE x_flag    LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
  DEFINE l_rvv     RECORD LIKE rvv_file.*
  DEFINE l_pmm22   LIKE pmm_file.pmm22
  DEFINE l_pmm42   LIKE pmm_file.pmm42
  DEFINE l_rva06   LIKE rva_file.rva06
  DEFINE l_cai     RECORD LIKE cai_file.*
  DEFINE amt_1,amt_2,amtx  LIKE type_file.num20_6       #No.FUN-680122 DEC(20,6)     #MOD-4C0005
  DEFINE l_cac03   LIKE cac_file.cac03
  DEFINE l_cam10   LIKE cam_file.cam10   #FUN-670037 add
  DEFINE l_cam11   LIKE cam_file.cam11   #FUN-670037 add
  DEFINE l_cam01_b LIKE cam_file.cam01   #FUN-A90065
  DEFINE l_cam01_e LIKE cam_file.cam01   #FUN-A90065
  DEFINE l_correct LIKE type_file.chr1   #CHI-9A0021 add
  DEFINE dl_t      LIKE cxz_file.cxz04   #FUN-A90065
  DEFINE oh_t      LIKE cxz_file.cxz05   #FUN-A90065

   #年月/年月成本中心
  CALL p510_cxh_01()
  IF g_ccz.ccz06='1' OR g_ccz.ccz06='2' THEN
    LET g_cxh.cxh01 =g_sfb.sfb01
    LET g_cxh.cxh011=g_sfb.sfb98
    LET g_cxh.cxh012=g_ecm.ecm04     #g_caf.caf06    #作業編號
    LET g_cxh.cxh013=g_ecm.ecm012    #FUN-A60095
    LET g_cxh.cxh014=g_ecm.ecm03     #FUN-A60095
    LET g_cxh.cxh04 =' DL+OH+SUB'      # 料號為 ' DL+OH+SUB'
    LET g_cxh.cxh05 ='P'
    LET g_cxh.cxh06 =type        #FUN-7C0028 add
    LET g_cxh.cxh07 =g_tlfcost   #FUN-7C0028 add
   #IF g_cxh.cxh012=ecm04_min THEN  #第一站才有投入量 #FUN-A60095
    IF (g_cxh.cxh013 =ecm012_min) AND (g_cxh.cxh014 =ecm03_min) THEN #只有第一站有投入量  #FUN-A60095
      LET g_cxh.cxh21 =mccg.ccg21
    ELSE
      LET g_cxh.cxh21 =0
    END IF
    LET g_cxh.cxh21 =mccg.ccg21 #FUN-640142
 
   #當月起始日與截止日
    CALL s_azm(yy,mm) RETURNING l_correct,l_cam01_b,l_cam01_e   #CHI-9A0021 add  #FUN-A90065

    DECLARE wo_cur8 CURSOR FOR
      SELECT cxz_file.*,cae07,cae08,cae041,cae03,cae04 #CHI-970021 a04-->e041
        FROM cxz_file,cae_file #,caa_file  #CHI-970021
       WHERE cxz01=g_sfb.sfb01
         AND cxz02=g_sfb.sfb98
         AND cxz02=cae03 AND cxz03=cae04
         AND cae01=yy AND cae02=mm
    LET l_cxh22b=0 LET l_cxh22c=0
    LET l_cxh22e=0 LET l_cxh22f=0 LET l_cxh22g=0 LET l_cxh22h=0   #FUN-7C0028 add
    FOREACH wo_cur8 INTO l_wo.*,l_cae07,l_cae08,l_cae041,l_cae03,l_cae04 #CHI-970021 a04-->e041
       IF STATUS THEN 
          CALL s_errmsg('','','wo_for8',STATUS,0) #No.FUN-710027
          LET g_success='N'
          EXIT FOREACH
       END IF
       #FUN-A90065(S)
       LET dl_t=0
       LET oh_t=0
       CALL p510_dis(g_sfb.sfb01,l_cam01_b,l_cam01_e,l_cae03,
                     l_cae041,l_cae07,l_cae08) 
                     RETURNING dl_t,oh_t
       IF dl_t IS NULL THEN LET dl_t=0 END IF
       IF oh_t IS NULL THEN LET oh_t=0 END IF
       LET l_cxh22b=l_cxh22b + dl_t
       LET l_cxh22c=l_cxh22c + oh_t
       #FUN-A90065(E)
    END FOREACH 	
 
 
    #加工費收集-----------------------------------
    #有製程依該站的製程委外採購單追當月加工費請款金額
     DECLARE rvv_cur1 CURSOR FOR
       SELECT rvv01,rvv02,rvv39,rvb01,rvb02
         FROM rvv_file,rvu_file,rva_file,rvb_file,pmm_file,pmn_file
        WHERE 1=1  #FUN-640142
          AND rvv04 = rvb01  AND rvv05 = rvb02
          AND rvaconf !='X'
          AND pmn41=g_sfb.sfb01 AND pmn43=g_ecm.ecm03 AND pmn011='SUB'
          AND (pmm25='2' OR pmm25 = '6') AND rvv36 = pmn01 AND rvv37 = pmn02
          AND rvu01 = rvv01 AND rvuconf='Y' AND rva01=rvb01 AND pmn01=pmm01
          AND pmn012=g_ecm.ecm012  #FUN-A60095
      ORDER BY 1,2
    LET l_cxh22d=0
    FOREACH rvv_cur1 INTO l_rvv01,l_rvv02,l_rvv39,l_rvb01,l_rvb02
       #-->發票請款立帳
       LET amt_1= 0 LET amt_2= 0 LET x_flag = 'N'
       DECLARE apa_cursor3a CURSOR FOR  #FUN-640142
       SELECT SUM(ABS(apb101))   #No.TQC-7C0126
         FROM apb_file,apa_file
        WHERE apb21=l_rvv01 AND apb22=l_rvv02 AND apb01=apa01
          AND apa00 = '11' AND apa75 != 'Y'
          AND apa42 = 'N'
          AND apa02 BETWEEN g_bdate AND g_edate
          AND apb34 <> 'Y'  #No.TQC-7C0126
        LET amtx = 0
       FOREACH apa_cursor3a INTO amtx   #FUN-640142
          LET amt_1=amt_1 + amtx  LET x_flag = 'Y'
       END FOREACH
       IF amt_1 IS NULL THEN LET amt_1 = 0 END IF
       #-->扣除折讓部份(退貨)
       #配合成本分攤aapt900 apb10->apb101
       DECLARE apa_cursor3 CURSOR FOR
         SELECT SUM(ABS(apb101))   #No.TQC-7C0126
           FROM apb_file,apa_file
           WHERE apb21=l_rvv01 AND apb22=l_rvv02 AND apb01=apa01
             AND apa00 = '21' AND apa58 = '2' AND apa75 != 'Y'
             AND apa42 = 'N'
             AND apa02 BETWEEN g_bdate AND g_edate
             AND apb34 <> 'Y'  #No.TQC-7C0126
        LET amtx = 0
        FOREACH apa_cursor3 INTO amtx
           LET amt_2 = amt_2 + amtx LET x_flag = 'Y'
        END FOREACH
        IF amt_2 IS NULL THEN LET amt_2 = 0 END IF
        LET amt = amt_1-amt_2
        #-->不決定正負數
        IF amt < 0 THEN LET amt=amt * -1 END IF
        IF x_flag = 'N' THEN
           DECLARE ale_cursor3 CURSOR FOR
              SELECT SUM(ale09)
                FROM ale_file ,alk_file
               WHERE ale16=l_rvv01 AND ale17=l_rvv02 AND ale01=alk01
                 AND alkfirm <> 'X'  #CHI-C80041
           LET amtx = 0
           FOREACH ale_cursor3 INTO amtx
              LET amt = amt + amtx LET x_flag = 'Y'
           END FOREACH
           # 供月中暫估成本使用
           IF x_flag = 'N' THEN
              SELECT * INTO l_rvv.* FROM rvv_file
               WHERE rvv01=l_rvv01 AND rvv02=l_rvv02
                 AND rvv25 != 'Y'
              IF STATUS = 0 THEN
                 #直接取 P/O 上的匯率
                 SELECT pmm22,rva06,pmm42 INTO l_pmm22,l_rva06,l_pmm42
                   FROM rvb_file,pmm_file,rva_file
                  WHERE rvb01=l_rvb01 AND rvb02=l_rvb02
                    AND pmm01=rvb04 AND rva01 = rvb01
                    AND rvaconf <> 'X' AND pmm18 <> 'X'
                 IF STATUS <> 0 THEN
                    LET l_pmm22=' '
                    LET l_pmm42= 1
                 END IF
                 IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                 LET amt=l_rvv39*l_pmm42
                 IF amt IS NULL THEN LET amt=0 END IF
              END IF
           END IF
        END IF
        IF amt IS NULL THEN LET amt=0 END IF
        LET l_cxh22d = l_cxh22d+ amt
    END FOREACH
   #end--加工費收集--------------------------------
  END IF   #ccz06='1'/'2'
 
  IF g_ccz.ccz06='3' THEN  #年月/作業編號
    LET g_cxh.cxh01 =g_sfb.sfb01
    LET g_cxh.cxh011=g_ecm.ecm04   #g_caf.caf06
    LET g_cxh.cxh012=g_ecm.ecm04   #g_caf.caf06
    LET g_cxh.cxh013=g_ecm.ecm012  #FUN-A60095
    LET g_cxh.cxh014=g_ecm.ecm03   #FUN-A60095
    LET g_cxh.cxh04 =' DL+OH+SUB'
    LET g_cxh.cxh05 ='P'
    LET g_cxh.cxh06 =type        #FUN-7C0028 add
    LET g_cxh.cxh07 =g_tlfcost   #FUN-7C0028 add
   #IF g_cxh.cxh012=ecm04_min THEN #第一站才有投入量 #FUN-A60095
    IF (g_cxh.cxh013 =ecm012_min) AND (g_cxh.cxh014 =ecm03_min) THEN #只有第一站有投入量  #FUN-A60095
       LET g_cxh.cxh21 =mccg.ccg21
    ELSE
       LET g_cxh.cxh21 =0
    END IF
    LET g_cxh.cxh21 =mccg.ccg21 #FUN-650160
 
    DECLARE wo_cur9 CURSOR FOR
       SELECT * FROM cxz_file
        WHERE cxz01=g_sfb.sfb01
          AND cxz02=g_ecm.ecm04   #g_caf.caf06
    LET l_cxh22b=0 LET l_cxh22c=0
    LET l_cxh22e=0 LET l_cxh22f=0 LET l_cxh22g=0 LET l_cxh22h=0   #FUN-7C0028 add
    FOREACH wo_cur9 INTO l_wo.*
       IF STATUS THEN 
          CALL s_errmsg('','','wo_for9',STATUS,0)  #No.FUN-710027
          LET g_success='N'
          EXIT FOREACH
       END IF
       IF l_wo.cxz04 !='0' THEN
          LET l_cxh22b=l_cxh22b+l_wo.cxz04
       END IF
       IF l_wo.cxz05 !='0' THEN
          LET l_cxh22c=l_cxh22c+l_wo.cxz05
       END IF
    END FOREACH
 
    #加工費收集-----------------------------------
    #有製程依該站的製程委外採購單追當月加工費請款金額
    #基本
    DECLARE rvv_cur2 CURSOR FOR
       SELECT rvv01,rvv02,rvv39,rvb01,rvb02
         FROM rvv_file,rvu_file,rva_file,rvb_file,pmm_file,pmn_file
        WHERE 1=1  #FUN-640142
          AND rvv04 = rvb01  AND rvv05 = rvb02
          AND rvaconf !='X'
          AND pmn41=g_sfb.sfb01 AND pmn43=g_ecm.ecm03 AND pmn011='SUB'
          AND (pmm25='2' OR pmm25 = '6') AND rvv36 = pmn01 AND rvv37 = pmn02
          AND rvu01 = rvv01 AND rvuconf='Y' AND rva01=rvb01 AND pmn01=pmm01
          AND pmn012=g_ecm.ecm012  #FUN-A60095
      ORDER BY 1,2
    LET l_cxh22d=0
    FOREACH rvv_cur2 INTO l_rvv01,l_rvv02,l_rvv39,l_rvb01,l_rvb02
       #-->發票請款立帳
       LET amt_1= 0 LET amt_2= 0 LET x_flag = 'N'
       DECLARE apa_cursor_2a CURSOR FOR
          SELECT SUM(ABS(apb101))   #No.TQC-7C0126
            FROM apb_file,apa_file
           WHERE apb21=l_rvv01 AND apb22=l_rvv02 AND apb01=apa01
             AND apa00 = '11' AND apa75 != 'Y'
             AND apa42 = 'N'
             AND apa02 BETWEEN g_bdate AND g_edate
             AND apb34 <> 'Y'  #No.TQC-7C0126
       LET amtx = 0
       FOREACH apa_cursor_2a INTO amtx
          LET amt_1=amt_1 + amtx  LET x_flag = 'Y'
       END FOREACH
       IF amt_1 IS NULL THEN LET amt_1 = 0 END IF
       #-->扣除折讓部份(退貨)
       #配合成本分攤aapt900 apb10->apb101
       DECLARE apa_cursor2 CURSOR FOR
         SELECT SUM(ABS(apb101))   #No.TQC-7C0126
           FROM apb_file,apa_file
           WHERE apb21=l_rvv01 AND apb22=l_rvv02 AND apb01=apa01
             AND apa00 = '21' AND apa58 = '2' AND apa75 != 'Y'
             AND apa42 = 'N'
             AND apa02 BETWEEN g_bdate AND g_edate
             AND apb34 <> 'Y'  #No.TQC-7C0126
        LET amtx = 0
        FOREACH apa_cursor2 INTO amtx
           LET amt_2 = amt_2 + amtx LET x_flag = 'Y'
        END FOREACH
        IF amt_2 IS NULL THEN LET amt_2 = 0 END IF
        LET amt = amt_1-amt_2
        #-->不決定正負數
        IF amt < 0 THEN LET amt=amt * -1 END IF
        IF x_flag = 'N' THEN
            DECLARE ale_cursor2 CURSOR FOR
             SELECT SUM(ale09)
               FROM ale_file ,alk_file
              WHERE ale16=l_rvv01 AND ale17=l_rvv02 AND ale01=alk01
                AND alkfirm <> 'X'  #CHI-C80041
            LET amtx = 0
            FOREACH ale_cursor2 INTO amtx
               LET amt = amt + amtx LET x_flag = 'Y'
            END FOREACH
            # 供月中暫估成本使用
            IF x_flag = 'N' THEN
              SELECT * INTO l_rvv.* FROM rvv_file
               WHERE rvv01=l_rvv01 AND rvv02=l_rvv02
                 AND rvv25 != 'Y'
              IF STATUS = 0 THEN
                #直接取 P/O 上的匯率
                SELECT pmm22,rva06,pmm42 INTO l_pmm22,l_rva06,l_pmm42
                  FROM rvb_file,pmm_file,rva_file
                 WHERE rvb01=l_rvb01 AND rvb02=l_rvb02
                   AND pmm01=rvb04 AND rva01 = rvb01
                   AND rvaconf <> 'X' AND pmm18 <> 'X'
                IF STATUS <> 0 THEN
                   LET l_pmm22=' '
                   LET l_pmm42= 1
                END IF
                IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                LET amt=l_rvv39*l_pmm42
                IF amt IS NULL THEN LET amt=0 END IF
              END IF
            END IF
         END IF
       IF amt IS NULL THEN LET amt=0 END IF
       LET l_cxh22d = l_cxh22d+ amt
    END FOREACH
   #end--加工費收集--------------------------------
  END IF  #ccz06='3'
 
  #年月工作中心
  IF g_ccz.ccz06='4' THEN
    LET g_cxh.cxh01 =g_sfb.sfb01
    LET g_cxh.cxh011=g_ecm.ecm06   #g_caf.caf06
    LET g_cxh.cxh012=g_ecm.ecm04   #g_caf.caf06
    LET g_cxh.cxh013=g_ecm.ecm012  #FUN-A60095
    LET g_cxh.cxh014=g_ecm.ecm03   #FUN-A60095
    LET g_cxh.cxh04 =' DL+OH+SUB'
    LET g_cxh.cxh05 ='P'
    LET g_cxh.cxh06 =type        #FUN-7C0028 add
    LET g_cxh.cxh07 =g_tlfcost   #FUN-7C0028 add
   #IF g_cxh.cxh012=ecm04_min THEN #第一站才有投入量 #FUN-A60095
    IF (g_cxh.cxh013 =ecm012_min) AND (g_cxh.cxh014 =ecm03_min) THEN #只有第一站有投入量  #FUN-A60095
       LET g_cxh.cxh21 =mccg.ccg21
    ELSE
       LET g_cxh.cxh21 =0
    END IF
    LET g_cxh.cxh21 =mccg.ccg21 #FUN-650160
 
    DECLARE wo_cur10 CURSOR FOR
 
      SELECT cxz_file.*,cae07,cae08,cae041,cae03,cae04  #CHI-970021 a04-->e041
        FROM cxz_file,cae_file #,caa_file  #CHI-970021
       WHERE cxz01=g_sfb.sfb01
         AND cxz02=g_cxh.cxh011
         AND cxz02=cae03 AND cxz03=cae04
         AND cae01=yy AND cae02=mm
    LET l_cxh22b=0 LET l_cxh22c=0
    LET l_cxh22e=0 LET l_cxh22f=0 LET l_cxh22g=0 LET l_cxh22h=0   #FUN-7C0028 add
    FOREACH wo_cur10 INTO l_wo.*,l_cae07,l_cae08,l_cae041,l_cae03,l_cae04 #CHI-970021 a04-->e041
       IF STATUS THEN 
         CALL s_errmsg('','','wo_for10',STATUS,0) #No.FUN-710027            
         LET g_success='N'
         EXIT FOREACH
       END IF
       #FUN-A90065(S)
       LET dl_t=0
       LET oh_t=0
       CALL p510_dis(g_sfb.sfb01,l_cam01_b,l_cam01_e,l_cae03,
                     l_cae041,l_cae07,l_cae08) 
                     RETURNING dl_t,oh_t
       IF dl_t IS NULL THEN LET dl_t=0 END IF
       IF oh_t IS NULL THEN LET oh_t=0 END IF
       LET l_cxh22b=l_cxh22b + dl_t
       LET l_cxh22c=l_cxh22c + oh_t
       #FUN-A90065(E)
    END FOREACH
    
    #加工費收集-----------------------------------
    #有製程依該站的製程委外採購單追當月加工費請款金額
    #基本
    DECLARE rvv_cur3 CURSOR FOR
       SELECT rvv01,rvv02,rvv39,rvb01,rvb02
         FROM rvv_file,rvu_file,rva_file,rvb_file,pmm_file,pmn_file
        WHERE 1=1  #FUN-640142
          AND rvv04 = rvb01  AND rvv05 = rvb02
          AND rvaconf !='X'
          AND pmn41=g_sfb.sfb01 AND pmn43=g_ecm.ecm03 AND pmn011='SUB'
          AND (pmm25='2' OR pmm25 = '6') AND rvv36 = pmn01 AND rvv37 = pmn02
          AND rvu01 = rvv01 AND rvuconf='Y' AND rva01=rvb01 AND pmn01=pmm01
          AND pmn012=g_ecm.ecm012  #FUN-A60095
      ORDER BY 1,2
    LET l_cxh22d=0
    FOREACH rvv_cur3 INTO l_rvv01,l_rvv02,l_rvv39,l_rvb01,l_rvb02
       #-->發票請款立帳
       LET amt_1= 0 LET amt_2= 0 LET x_flag = 'N'
       DECLARE apa_cursor_3a CURSOR FOR
          SELECT SUM(ABS(apb101))   #No.TQC-7C0126
            FROM apb_file,apa_file
           WHERE apb21=l_rvv01 AND apb22=l_rvv02 AND apb01=apa01
             AND apa00 = '11' AND apa75 != 'Y'
             AND apa42 = 'N'
             AND apa02 BETWEEN g_bdate AND g_edate
             AND apb34 <> 'Y'  #No.TQC-7C0126
       LET amtx = 0
       FOREACH apa_cursor_3a INTO amtx
          LET amt_1=amt_1 + amtx  LET x_flag = 'Y'
       END FOREACH
       IF amt_1 IS NULL THEN LET amt_1 = 0 END IF
       #-->扣除折讓部份(退貨)
       #配合成本分攤aapt900 apb10->apb101
       DECLARE apa_cursor5 CURSOR FOR
         SELECT SUM(ABS(apb101))   #No.TQC-7C0126
           FROM apb_file,apa_file
           WHERE apb21=l_rvv01 AND apb22=l_rvv02 AND apb01=apa01
             AND apa00 = '21' AND apa58 = '2' AND apa75 != 'Y'
             AND apa42 = 'N'
             AND apa02 BETWEEN g_bdate AND g_edate
             AND apb34 <> 'Y'  #No.TQC-7C0126
        LET amtx = 0
        FOREACH apa_cursor5 INTO amtx
           LET amt_2 = amt_2 + amtx LET x_flag = 'Y'
        END FOREACH
        IF amt_2 IS NULL THEN LET amt_2 = 0 END IF
        LET amt = amt_1-amt_2
        #-->不決定正負數
        IF amt < 0 THEN LET amt=amt * -1 END IF
        IF x_flag = 'N' THEN
            DECLARE ale_cursor4 CURSOR FOR
             SELECT SUM(ale09)
               FROM ale_file ,alk_file
              WHERE ale16=l_rvv01 AND ale17=l_rvv02 AND ale01=alk01
                AND alkfirm <> 'X'  #CHI-C80041
            LET amtx = 0
            FOREACH ale_cursor4 INTO amtx
               LET amt = amt + amtx LET x_flag = 'Y'
            END FOREACH
            # 供月中暫估成本使用
            IF x_flag = 'N' THEN
              SELECT * INTO l_rvv.* FROM rvv_file
               WHERE rvv01=l_rvv01 AND rvv02=l_rvv02
                 AND rvv25 != 'Y'
              IF STATUS = 0 THEN
                #直接取 P/O 上的匯率
                SELECT pmm22,rva06,pmm42 INTO l_pmm22,l_rva06,l_pmm42
                  FROM rvb_file,pmm_file,rva_file
                 WHERE rvb01=l_rvb01 AND rvb02=l_rvb02
                   AND pmm01=rvb04 AND rva01 = rvb01
                   AND rvaconf <> 'X' AND pmm18 <> 'X'
                IF STATUS <> 0 THEN
                   LET l_pmm22=' '
                   LET l_pmm42= 1
                END IF
                IF l_pmm42 IS NULL THEN LET l_pmm42=1 END IF
                LET amt=l_rvv39*l_pmm42
                IF amt IS NULL THEN LET amt=0 END IF
              END IF
            END IF
         END IF
       IF amt IS NULL THEN LET amt=0 END IF
       LET l_cxh22d = l_cxh22d+ amt
    END FOREACH
   #end--加工費收集--------------------------------
  END IF
 
    IF l_cxh22b IS NULL THEN LET l_cxh22b=0 END IF
    IF l_cxh22c IS NULL THEN LET l_cxh22c=0 END IF
    IF l_cxh22d IS NULL THEN LET l_cxh22d=0 END IF   #TQC-650114 add
    IF l_cxh22e IS NULL THEN LET l_cxh22e=0 END IF   #FUN-7C0028 add
    IF l_cxh22f IS NULL THEN LET l_cxh22f=0 END IF   #FUN-7C0028 add
    IF l_cxh22g IS NULL THEN LET l_cxh22g=0 END IF   #FUN-7C0028 add
    IF l_cxh22h IS NULL THEN LET l_cxh22h=0 END IF   #FUN-7C0028 add
    LET g_cxh.cxh22a=0
    LET g_cxh.cxh22b=l_cxh22b   #人工
    LET g_cxh.cxh22c=l_cxh22c   #製費一
    LET g_cxh.cxh22d=l_cxh22d   #加工
    LET g_cxh.cxh22e=l_cxh22e   #製費二   #FUN-7C0028 add
    LET g_cxh.cxh22f=l_cxh22f   #製費三   #FUN-7C0028 add
    LET g_cxh.cxh22g=l_cxh22g   #製費四   #FUN-7C0028 add
    LET g_cxh.cxh22h=l_cxh22h   #製費五   #FUN-7C0028 add
 
 
    LET g_cxh.cxh52b =g_cxh.cxh52b +g_cxh.cxh22b
    LET g_cxh.cxh52c =g_cxh.cxh52c +g_cxh.cxh22c
    LET g_cxh.cxh52d =g_cxh.cxh52d +g_cxh.cxh22d
    LET g_cxh.cxh52e =g_cxh.cxh52e +g_cxh.cxh22e   #FUN-7C0028 add
    LET g_cxh.cxh52f =g_cxh.cxh52f +g_cxh.cxh22f   #FUN-7C0028 add
    LET g_cxh.cxh52g =g_cxh.cxh52g +g_cxh.cxh22g   #FUN-7C0028 add
    LET g_cxh.cxh52h =g_cxh.cxh52h +g_cxh.cxh22h   #FUN-7C0028 add
    LET g_cxh.cxh52  =g_cxh.cxh52a+g_cxh.cxh52b+g_cxh.cxh52c+
                      g_cxh.cxh52d+g_cxh.cxh52e
                     +g_cxh.cxh52f+g_cxh.cxh52g+g_cxh.cxh52h   #FUN-7C0028 add
    LET g_cxh.cxh22  =g_cxh.cxh22a+g_cxh.cxh22b+g_cxh.cxh22c+
                      g_cxh.cxh22d+g_cxh.cxh22e
                     +g_cxh.cxh22f+g_cxh.cxh22g+g_cxh.cxh22h   #FUN-7C0028 add
    IF g_cxh.cxh22 = 0 THEN 
       LET g_cxh.cxh21 = 0 
      #RETURN   #FUN-670037 mark
    END IF
    LET g_cxh.cxhdate = g_today
    LET g_cxh.cxhuser = g_user
    LET g_cxh.cxhtime = TIME
 
    #若非第一站,需將本月投入(cxh21)數量歸零,否則數量重複
   #IF g_cxh.cxh012 != ecm04_min THEN LET g_cxh.cxh21 = 0 END IF #FUN-A60095
    #FUN-A60095(S)
    IF NOT ((g_cxh.cxh013 =ecm012_min) AND (g_cxh.cxh014 =ecm03_min)) THEN 
       LET g_cxh.cxh21 = 0
    END IF
    #FUN-A60095(E)
   #LET g_cxh.cxhplant = g_plant #FUN-980009 add     #FUN-A50075
    LET g_cxh.cxhlegal = g_legal #FUN-980009 add
 
    LET g_cxh.cxhoriu = g_user      #No.FUN-980030 10/01/04
    LET g_cxh.cxhorig = g_grup      #No.FUN-980030 10/01/04
    IF g_cxh.cxh011 IS NULL THEN LET g_cxh.cxh011=' ' END IF #FUN-A60095
    IF g_cxh.cxh013 IS NULL THEN LET g_cxh.cxh013=' ' END IF #FUN-A60095
    IF g_cxh.cxh014 IS NULL THEN LET g_cxh.cxh014=0   END IF #FUN-A60095
    INSERT INTO cxh_file VALUES(g_cxh.*)
    IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
       LET g_showmsg=g_cxh.cxh01,"/",g_cxh.cxh02                              #No.FUN-710027
       CALL s_errmsg('cxh01,cxh02',g_showmsg,'wip_2_22() ins cxh:',SQLCA.SQLCODE,1)  #No.FUN-710027
       LET g_msg=g_cxh.cxh01,g_cxh.cxh04
       CALL s_errmsg('',g_msg,'ins cxh_file',SQLCA.SQLCODE,1)                          #No.FUN-710027
    END IF
    IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
       UPDATE cxh_file SET cxh05=g_cxh.cxh05,
                           cxh21=cxh21+g_cxh.cxh21,
                           cxh22=cxh22+g_cxh.cxh22,
                           cxh22a=cxh22a+g_cxh.cxh22a,
                           cxh22b=cxh22b+g_cxh.cxh22b,
                           cxh22c=cxh22c+g_cxh.cxh22c,
                           cxh22d=cxh22d+g_cxh.cxh22d,
                           cxh22e=cxh22e+g_cxh.cxh22e,
                           cxh22f=cxh22f+g_cxh.cxh22f,   #FUN-7C0028 add
                           cxh22g=cxh22g+g_cxh.cxh22g,   #FUN-7C0028 add
                           cxh22h=cxh22h+g_cxh.cxh22h,   #FUN-7C0028 add
                           cxh24 =g_cxh.cxh24,
                           cxh25 =g_cxh.cxh25,
                           cxh25a=g_cxh.cxh25a,
                           cxh25b=g_cxh.cxh25b,
                           cxh25c=g_cxh.cxh25c,
                           cxh25d=g_cxh.cxh25d,
                           cxh25e=g_cxh.cxh25e,
       		                 cxh25f=g_cxh.cxh25f,   #FUN-7C0028 add
       		                 cxh25g=g_cxh.cxh25g,   #FUN-7C0028 add
       		                 cxh25h=g_cxh.cxh25h,   #FUN-7C0028 add
                           cxh26 =g_cxh.cxh26,
                           cxh27 =g_cxh.cxh27,
                           cxh27a=g_cxh.cxh27a,
                           cxh27b=g_cxh.cxh27b,
                           cxh27c=g_cxh.cxh27c,
                           cxh27d=g_cxh.cxh27d,
                           cxh27e=g_cxh.cxh27e,
       		                 cxh27f=g_cxh.cxh27f,   #FUN-7C0028 add
       		                 cxh27g=g_cxh.cxh27g,   #FUN-7C0028 add
       		                 cxh27h=g_cxh.cxh27h,   #FUN-7C0028 add
                           cxh28 =g_cxh.cxh28,
                           cxh29 =g_cxh.cxh29,
                           cxh29a=g_cxh.cxh29a,
                           cxh29b=g_cxh.cxh29b,
                           cxh29c=g_cxh.cxh29c,
                           cxh29d=g_cxh.cxh29d,
                           cxh29e=g_cxh.cxh29e,
       		                 cxh29f=g_cxh.cxh29f,   #FUN-7C0028 add
       		                 cxh29g=g_cxh.cxh29g,   #FUN-7C0028 add
       		                 cxh29h=g_cxh.cxh29h,   #FUN-7C0028 add
                           #累計投入
                           cxh52 =cxh52 +g_cxh.cxh52,
                           cxh52a=cxh52a+g_cxh.cxh52a,
                           cxh52b=cxh52b+g_cxh.cxh52b,
                           cxh52c=cxh52c+g_cxh.cxh52c,
                           cxh52d=cxh52d+g_cxh.cxh52d,
                           cxh52e=cxh52e+g_cxh.cxh52e,
       		                 cxh52f=cxh52f+g_cxh.cxh52f,   #FUN-7C0028 add
       		                 cxh52g=cxh52g+g_cxh.cxh52g,   #FUN-7C0028 add
       		                 cxh52h=cxh52h+g_cxh.cxh52h    #FUN-7C0028 add
           WHERE cxh01=g_sfb.sfb01 AND cxh02=yy AND cxh03=mm
            #AND cxh04=l_tlf01     AND cxh012=g_cxh.cxh012   #TQC-7B0027 mark
             AND cxh04=g_cxh.cxh04 AND cxh012=g_cxh.cxh012   #TQC-7B0027
             AND cxh06=g_cxh.cxh06 AND cxh07 =g_cxh.cxh07    #FUN-7C0028 add
             AND cxh013=g_cxh.cxh013 AND cxh014=g_cxh.cxh014  #FUN-A60095
    END IF
END FUNCTION
 
FUNCTION work_3()
  DEFINE l_cxh22b  LIKE cxh_file.cxh22b
  DEFINE l_cxh22c  LIKE cxh_file.cxh22c
  DEFINE l_cxh22e  LIKE cxh_file.cxh22e   #FUN-7C0028 add
  DEFINE l_cxh22f  LIKE cxh_file.cxh22f   #FUN-7C0028 add
  DEFINE l_cxh22g  LIKE cxh_file.cxh22g   #FUN-7C0028 add
  DEFINE l_cxh22h  LIKE cxh_file.cxh22h   #FUN-7C0028 add
  DEFINE l_ccg20   LIKE ccg_file.ccg20
  DEFINE l_dept    LIKE cre_file.cre08          #No.FUN-680122 VARCHAR(10)
  DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(600)
  DEFINE l_cam02   LIKE cam_file.cam02
  DEFINE l_sfa     RECORD LIKE sfa_file.*
  DEFINE l_cxh41   LIKE cxh_file.cxh41
  DEFINE ecm03_pre LIKE ecm_file.ecm03
  DEFINE ecm04_pre LIKE ecm_file.ecm04
  DEFINE l_tmp8 RECORD
          p01  LIKE oea_file.oea01,          #No.FUN-680122 VARCHAR(16), #工單         #No.FUN-550025
          p011 LIKE ima_file.ima01,    #TQC-660116 VARCHAR(20), #主件料號
          p02  LIKE type_file.num5,         #No.FUN-680122 SMALLINT, #製程序
          p03  LIKE aab_file.aab02,         #No.FUN-680122 VARCHAR(6),  #作業編號
#         p04  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#重流轉出(cxh39)
#         p05  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#重流轉入
#         p06  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#工單轉入
#         p07  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#轉下製程(cxh31)
#         p08  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#報廢數量(cxh33)
#         p09  LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),#工單轉出(cxh35)
#         p10  LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3) #當站下線(cxh37)
          p04  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          p05  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          p06  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          p07  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          p08  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          p09  LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          p10  LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
               END RECORD
   DEFINE l_cxh                    RECORD LIKE cxh_file.*
   DEFINE cost,costa,costb,costc,costd,coste LIKE fan_file.fan16   #No.FUN-680122 DEC(20,10)   #MOD-4C0005
   DEFINE costf,costg,costh                  LIKE fan_file.fan16   #FUN-7C0028 add
   DEFINE l_cnt                    LIKE type_file.num5             #No.FUN-680122 SMALLINT
   DEFINE l_unissue                LIKE sfa_file.sfa05
   DEFINE l_sfm03                  LIKE sfm_file.sfm03
   DEFINE l_sfm04                  LIKE sfm_file.sfm04
   DEFINE l_sfm05                  LIKE sfm_file.sfm05
   DEFINE l_sfm06,l_woqty          LIKE sfm_file.sfm07
   DEFINE l_dif,l_chg              LIKE sfm_file.sfm07
#  DEFINE l_tot_out,l_tot_in       LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
   DEFINE l_tot_out,l_tot_in       LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
   DEFINE l_sfb08                  LIKE sfb_file.sfb08
   DEFINE l_cam06                  LIKE cam_file.cam06
#  DEFINE g_tot_1,g_tot_2          LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
   DEFINE g_tot_1,g_tot_2          LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
   DEFINE l_cxh33                  LIKE cxh_file.cxh33
   DEFINE l_sharerate              LIKE fid_file.fid03          #No.FUN-680122 DEC(8,3)
   DEFINE l_cam07                  LIKE cam_file.cam07
#  DEFINE l_inpercentb             LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
#         l_inpercentc             LIKE ima_file.ima26,         #No.FUN-680122 DEC(15,3),
#         l_inpercentd             LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
   DEFINE l_inpercentb             LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          l_inpercentc             LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
          l_inpercentd             LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
 
   #取原工單在此工作站的備料資料
   LET l_sql="SELECT sfa_file.*,cxh_file.* ",
             "  FROM sfa_file, cxh_file ",
             " WHERE sfa01='",g_sfb.sfb01,"' ",
             "   AND sfa06 != 0 ",
             "   AND cxh01 = sfa01  AND cxh012 = sfa08 ",
             "   AND cxh02 = '",yy,"' AND cxh03 ='",mm,"' ",
             "   AND cxh06 ='",type,"' AND cxh07='",g_tlfcost,"'",   #FUN-7C0028 add
             "   AND cxh04=sfa03 ",
             "   AND cxh012='",g_caf.caf06,"' ",
             "   AND cxh013=sfa012 AND cxh014=sfa013 ", #FUN-A60095
             "   AND cxh013='",g_caf.caf012,"'",   #FUN-A60095
             "   AND cxh014= ",g_caf.caf05,   #FUN-A60095
             " UNION ",
       # 取工單在此工作站的人工與製費/調整成本之資料
             "SELECT sfa_file.*,cxh_file.* ",
             "  FROM cxh_file,sfa_file ",
             " WHERE cxh01 ='",g_sfb.sfb01,"' ",
             "   AND cxh02 ='",yy,"' AND cxh03 ='",mm,"' ",
             "   AND cxh06 ='",type,"' AND cxh07='",g_tlfcost,"'",
             "   AND (cxh04 = ' DL+OH+SUB' OR cxh04 = ' ADJUST') ",
             "   AND sfa_file.sfa01 = cxh01 AND sfa08 = cxh012 ",
             "   AND cxh012='",g_caf.caf06,"' ",
             "   AND cxh013=sfa012 AND cxh014=sfa013 ", #FUN-A60095
             "   AND cxh013='",g_caf.caf012,"'",   #FUN-A60095
             "   AND cxh014= ",g_caf.caf05,   #FUN-A60095
             " ORDER BY 25,1  "  CLIPPED
    PREPARE wip_32_p11 FROM l_sql
    DECLARE wip_32_c11 CURSOR FOR wip_32_p11
 
    FOREACH wip_32_c11 INTO l_sfa.*,l_cxh.*
      IF SQLCA.sqlcode THEN 
        CALL s_errmsg('','','wip_32_f11',STATUS,0) #No.FUN-710027
        EXIT FOREACH
      END IF
      #-總轉出量--
      LET l_tot_out=gg_out
 
      IF l_sfa.sfa161 IS NULL THEN LET l_sfa.sfa161 = 1 END IF
      LET l_cxh.cxh31 = gg_cxh31 * l_sfa.sfa161*-1    # 轉下製程
      LET l_cxh.cxh33 = gg_cxh33 * l_sfa.sfa161*-1    # 報廢量
      LET l_cxh.cxh35 = gg_cxh35 * l_sfa.sfa161*-1    # 工單轉出
      LET l_cxh.cxh37 = gg_cxh37 * l_sfa.sfa161*-1    # 當站下線
      LET l_cxh.cxh39 = gg_cxh39 * l_sfa.sfa161*-1    # 重流轉出
 
      IF ((l_cxh.cxh11+l_cxh.cxh21+l_cxh.cxh24+l_cxh.cxh26+l_cxh.cxh28)+
          (l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37+l_cxh.cxh39)) != 0 THEN
         #差異轉出數量
         IF mccg.ccg41 !=0 THEN
            LET l_cxh.cxh41=((l_cxh.cxh11+l_cxh.cxh21+l_cxh.cxh24+
                              l_cxh.cxh26+l_cxh.cxh28)+
                             (l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                              l_cxh.cxh37+l_cxh.cxh39))*-1
         END IF
      END IF
 
      IF cl_null(l_cxh.cxh31) THEN LET l_cxh.cxh31 = 0 END IF
      IF cl_null(l_cxh.cxh33) THEN LET l_cxh.cxh33 = 0 END IF
      IF cl_null(l_cxh.cxh34) THEN LET l_cxh.cxh34 = 0 END IF
      IF cl_null(l_cxh.cxh36) THEN LET l_cxh.cxh36 = 0 END IF
      IF cl_null(l_cxh.cxh38) THEN LET l_cxh.cxh38 = 0 END IF
 
      #轉下製程 (入項金額*轉出比率)
      LET l_cxh.cxh32 =(l_cxh.cxh12+l_cxh.cxh22+l_cxh.cxh25+l_cxh.cxh27)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      LET l_cxh.cxh32a=(l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      LET l_cxh.cxh32b=(l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b+l_cxh.cxh27b)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      LET l_cxh.cxh32c=(l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+l_cxh.cxh27c)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      LET l_cxh.cxh32d=(l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      LET l_cxh.cxh32e=(l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e+l_cxh.cxh27e)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      LET l_cxh.cxh32f=(l_cxh.cxh12f+l_cxh.cxh22f+l_cxh.cxh25f+l_cxh.cxh27f)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      LET l_cxh.cxh32g=(l_cxh.cxh12g+l_cxh.cxh22g+l_cxh.cxh25g+l_cxh.cxh27g)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      LET l_cxh.cxh32h=(l_cxh.cxh12h+l_cxh.cxh22h+l_cxh.cxh25h+l_cxh.cxh27h)
                        *(l_cxh.cxh31/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39))*-1
      # 報廢
      LET l_cxh.cxh34 =(l_cxh.cxh12 + l_cxh.cxh22+l_cxh.cxh25+l_cxh.cxh27)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      LET l_cxh.cxh34a=(l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      LET l_cxh.cxh34b=(l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b+l_cxh.cxh27b)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      LET l_cxh.cxh34c=(l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+l_cxh.cxh27c)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      LET l_cxh.cxh34d=(l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      LET l_cxh.cxh34e=(l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e +l_cxh.cxh27e)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      LET l_cxh.cxh34f=(l_cxh.cxh12f+l_cxh.cxh22f+l_cxh.cxh25f+l_cxh.cxh27f)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      LET l_cxh.cxh34g=(l_cxh.cxh12g+l_cxh.cxh22g+l_cxh.cxh25g+l_cxh.cxh27g)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      LET l_cxh.cxh34h=(l_cxh.cxh12h+l_cxh.cxh22h+l_cxh.cxh25h+l_cxh.cxh27h)
                        *(l_cxh.cxh33/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+
                                       l_cxh.cxh37+l_cxh.cxh39)*-1)
      #工單轉出量
      LET l_cxh.cxh36 =(l_cxh.cxh12+l_cxh.cxh25+l_cxh.cxh27)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh36a=(l_cxh.cxh12a+l_cxh.cxh25a+l_cxh.cxh27a)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh36b=(l_cxh.cxh12b+l_cxh.cxh25b+l_cxh.cxh27b)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh36c=(l_cxh.cxh12c+l_cxh.cxh25c+l_cxh.cxh27c)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh36d=(l_cxh.cxh12d+l_cxh.cxh25d+l_cxh.cxh27d)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh36e=(l_cxh.cxh12e+l_cxh.cxh25e+l_cxh.cxh27e)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh36f=(l_cxh.cxh12f+l_cxh.cxh25f+l_cxh.cxh27f)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh36g=(l_cxh.cxh12g+l_cxh.cxh25g+l_cxh.cxh27g)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh36h=(l_cxh.cxh12h+l_cxh.cxh25h+l_cxh.cxh27h)*
          (l_cxh.cxh35/(l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37)*-1)
      #當站下線
      LET l_cxh.cxh38 =(l_cxh.cxh12+l_cxh.cxh22+l_cxh.cxh25+l_cxh.cxh27)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh38a=(l_cxh.cxh12a+l_cxh.cxh22a+l_cxh.cxh25a+l_cxh.cxh27a)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh38b=(l_cxh.cxh12b+l_cxh.cxh22b+l_cxh.cxh25b+l_cxh.cxh27b)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh38c=(l_cxh.cxh12c+l_cxh.cxh22c+l_cxh.cxh25c+l_cxh.cxh27c)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh38d=(l_cxh.cxh12d+l_cxh.cxh22d+l_cxh.cxh25d+l_cxh.cxh27d)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh38e=(l_cxh.cxh12e+l_cxh.cxh22e+l_cxh.cxh25e+l_cxh.cxh27e)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh38f=(l_cxh.cxh12f+l_cxh.cxh22f+l_cxh.cxh25f+l_cxh.cxh27f)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh38g=(l_cxh.cxh12g+l_cxh.cxh22g+l_cxh.cxh25g+l_cxh.cxh27g)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
      LET l_cxh.cxh38h=(l_cxh.cxh12h+l_cxh.cxh22h+l_cxh.cxh25h+l_cxh.cxh27h)
                        *(l_cxh.cxh37/(l_cxh.cxh31+l_cxh.cxh33
                                      +l_cxh.cxh35+l_cxh.cxh37)*-1)
 
      # 重工轉出量
      #重工轉出的料工費,會被其它轉出量分攤掉了
      LET l_cxh.cxh40=0
      LET l_cxh.cxh40a=0
      LET l_cxh.cxh40b=0
      LET l_cxh.cxh40c=0
      LET l_cxh.cxh40d=0
      LET l_cxh.cxh40e=0
      LET l_cxh.cxh40f=0   #FUN-7C0028 add
      LET l_cxh.cxh40g=0   #FUN-7C0028 add
      LET l_cxh.cxh40h=0   #FUN-7C0028 add
       
       IF cl_null(l_cxh.cxh32a) THEN LET l_cxh.cxh32a = 0 END IF
       IF cl_null(l_cxh.cxh32b) THEN LET l_cxh.cxh32b = 0 END IF
       IF cl_null(l_cxh.cxh32c) THEN LET l_cxh.cxh32c = 0 END IF
       IF cl_null(l_cxh.cxh32d) THEN LET l_cxh.cxh32d = 0 END IF
       IF cl_null(l_cxh.cxh32e) THEN LET l_cxh.cxh32e = 0 END IF
       IF cl_null(l_cxh.cxh32f) THEN LET l_cxh.cxh32f = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh32g) THEN LET l_cxh.cxh32g = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh32h) THEN LET l_cxh.cxh32h = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh34a) THEN LET l_cxh.cxh34a = 0 END IF
       IF cl_null(l_cxh.cxh34b) THEN LET l_cxh.cxh34b = 0 END IF
       IF cl_null(l_cxh.cxh34c) THEN LET l_cxh.cxh34c = 0 END IF
       IF cl_null(l_cxh.cxh34d) THEN LET l_cxh.cxh34d = 0 END IF
       IF cl_null(l_cxh.cxh34e) THEN LET l_cxh.cxh34e = 0 END IF
       IF cl_null(l_cxh.cxh34f) THEN LET l_cxh.cxh34f = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh34g) THEN LET l_cxh.cxh34g = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh34h) THEN LET l_cxh.cxh34h = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh36a) THEN LET l_cxh.cxh36a = 0 END IF
       IF cl_null(l_cxh.cxh36b) THEN LET l_cxh.cxh36b = 0 END IF
       IF cl_null(l_cxh.cxh36c) THEN LET l_cxh.cxh36c = 0 END IF
       IF cl_null(l_cxh.cxh36d) THEN LET l_cxh.cxh36d = 0 END IF
       IF cl_null(l_cxh.cxh36e) THEN LET l_cxh.cxh36e = 0 END IF
       IF cl_null(l_cxh.cxh36f) THEN LET l_cxh.cxh36f = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh36g) THEN LET l_cxh.cxh36g = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh36h) THEN LET l_cxh.cxh36h = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh38a) THEN LET l_cxh.cxh38a = 0 END IF
       IF cl_null(l_cxh.cxh38b) THEN LET l_cxh.cxh38b = 0 END IF
       IF cl_null(l_cxh.cxh38c) THEN LET l_cxh.cxh38c = 0 END IF
       IF cl_null(l_cxh.cxh38d) THEN LET l_cxh.cxh38d = 0 END IF
       IF cl_null(l_cxh.cxh38e) THEN LET l_cxh.cxh38e = 0 END IF
       IF cl_null(l_cxh.cxh38f) THEN LET l_cxh.cxh38f = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh38g) THEN LET l_cxh.cxh38g = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh38h) THEN LET l_cxh.cxh38h = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh40a) THEN LET l_cxh.cxh40a = 0 END IF
       IF cl_null(l_cxh.cxh40b) THEN LET l_cxh.cxh40b = 0 END IF
       IF cl_null(l_cxh.cxh40c) THEN LET l_cxh.cxh40c = 0 END IF
       IF cl_null(l_cxh.cxh40d) THEN LET l_cxh.cxh40d = 0 END IF
       IF cl_null(l_cxh.cxh40e) THEN LET l_cxh.cxh40e = 0 END IF
       IF cl_null(l_cxh.cxh40f) THEN LET l_cxh.cxh40f = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh40g) THEN LET l_cxh.cxh40g = 0 END IF   #FUN-7C0028 add
       IF cl_null(l_cxh.cxh40h) THEN LET l_cxh.cxh40h = 0 END IF   #FUN-7C0028 add
       LET l_cxh.cxh32 = l_cxh.cxh32a + l_cxh.cxh32b + l_cxh.cxh32c
                       + l_cxh.cxh32d + l_cxh.cxh32e
                       + l_cxh.cxh32f + l_cxh.cxh32g + l_cxh.cxh32h   #FUN-7C0028 add
       LET l_cxh.cxh34 = l_cxh.cxh34a + l_cxh.cxh34b + l_cxh.cxh34c
                       + l_cxh.cxh34d + l_cxh.cxh34e
                       + l_cxh.cxh34f + l_cxh.cxh34g + l_cxh.cxh34h   #FUN-7C0028 add
       LET l_cxh.cxh36 = l_cxh.cxh36a + l_cxh.cxh36b + l_cxh.cxh36c
                       + l_cxh.cxh36d + l_cxh.cxh36e
                       + l_cxh.cxh36f + l_cxh.cxh36g + l_cxh.cxh36h   #FUN-7C0028 add
       LET l_cxh.cxh38 = l_cxh.cxh38a + l_cxh.cxh38b + l_cxh.cxh38c
                       + l_cxh.cxh38d + l_cxh.cxh38e
                       + l_cxh.cxh38f + l_cxh.cxh38g + l_cxh.cxh38h   #FUN-7C0028 add
       LET l_cxh.cxh40 = l_cxh.cxh40a + l_cxh.cxh40b + l_cxh.cxh40c
                       + l_cxh.cxh40d + l_cxh.cxh40e
                       + l_cxh.cxh40f + l_cxh.cxh40g + l_cxh.cxh40h   #FUN-7C0028 add
 
       #差異轉出量
       IF ((l_cxh.cxh11+l_cxh.cxh21+l_cxh.cxh24+l_cxh.cxh26+l_cxh.cxh28)+
           (l_cxh.cxh31+l_cxh.cxh33+l_cxh.cxh35+l_cxh.cxh37+l_cxh.cxh39))!=0 THEN
          IF mccg.ccg41 !=0 THEN
             LET l_cxh.cxh42a =((l_cxh.cxh12a + l_cxh.cxh22a + l_cxh.cxh25a
                               + l_cxh.cxh27a + l_cxh.cxh29a)
                               +(l_cxh.cxh32a + l_cxh.cxh34a + l_cxh.cxh36a
                               + l_cxh.cxh38a + l_cxh.cxh40a))*-1
             LET l_cxh.cxh42b =((l_cxh.cxh12b + l_cxh.cxh22b + l_cxh.cxh25b
                               + l_cxh.cxh27b + l_cxh.cxh29b)
                               +(l_cxh.cxh32b + l_cxh.cxh34b + l_cxh.cxh36b
                               + l_cxh.cxh38b + l_cxh.cxh40b))*-1
             LET l_cxh.cxh42c =((l_cxh.cxh12c + l_cxh.cxh22c + l_cxh.cxh25c
                               + l_cxh.cxh27c + l_cxh.cxh29c)
                               +(l_cxh.cxh32c + l_cxh.cxh34c + l_cxh.cxh36c
                               + l_cxh.cxh38c + l_cxh.cxh40c))*-1
             LET l_cxh.cxh42d =((l_cxh.cxh12d + l_cxh.cxh22d + l_cxh.cxh25d
                               + l_cxh.cxh27d + l_cxh.cxh29d)
                               +(l_cxh.cxh32d + l_cxh.cxh34d + l_cxh.cxh36d
                               + l_cxh.cxh38d + l_cxh.cxh40d))*-1
             LET l_cxh.cxh42e =((l_cxh.cxh12e + l_cxh.cxh22e + l_cxh.cxh25e
                               + l_cxh.cxh27e + l_cxh.cxh29e)
                               +(l_cxh.cxh32e + l_cxh.cxh34e + l_cxh.cxh36e
                               + l_cxh.cxh38e + l_cxh.cxh40e))*-1
             LET l_cxh.cxh42f =((l_cxh.cxh12f + l_cxh.cxh22f + l_cxh.cxh25f
                               + l_cxh.cxh27f + l_cxh.cxh29f)
                               +(l_cxh.cxh32f + l_cxh.cxh34f + l_cxh.cxh36f
                               + l_cxh.cxh38f + l_cxh.cxh40f))*-1
             LET l_cxh.cxh42g =((l_cxh.cxh12g + l_cxh.cxh22g + l_cxh.cxh25g
                               + l_cxh.cxh27g + l_cxh.cxh29g)
                               +(l_cxh.cxh32g + l_cxh.cxh34g + l_cxh.cxh36g
                               + l_cxh.cxh38g + l_cxh.cxh40g))*-1
             LET l_cxh.cxh42h =((l_cxh.cxh12h + l_cxh.cxh22h + l_cxh.cxh25h
                               + l_cxh.cxh27h + l_cxh.cxh29h)
                               +(l_cxh.cxh32h + l_cxh.cxh34h + l_cxh.cxh36h
                               + l_cxh.cxh38h + l_cxh.cxh40h))*-1
             LET l_cxh.cxh42=l_cxh.cxh42a+l_cxh.cxh42b+l_cxh.cxh42c+
                             l_cxh.cxh42d+l_cxh.cxh42e
                            +l_cxh.cxh42f+l_cxh.cxh42g+l_cxh.cxh42h   #FUN-7C0028 add
          ELSE
             LET l_cxh.cxh42=0
             LET l_cxh.cxh42a=0
             LET l_cxh.cxh42b=0
             LET l_cxh.cxh42c=0
             LET l_cxh.cxh42d=0
             LET l_cxh.cxh42e=0
             LET l_cxh.cxh42f=0   #FUN-7C0028 add
             LET l_cxh.cxh42g=0   #FUN-7C0028 add
             LET l_cxh.cxh42h=0   #FUN-7C0028 add
          END IF
        END IF
 
       # WIP-元件 本期結存成本
       LET l_cxh.cxh91 = l_cxh.cxh11 + l_cxh.cxh21 + l_cxh.cxh24
                       + l_cxh.cxh26 + l_cxh.cxh28
                       + l_cxh.cxh31 + l_cxh.cxh33 + l_cxh.cxh35
                       + l_cxh.cxh37 + l_cxh.cxh39
                       + l_cxh.cxh41 + l_cxh.cxh59
       LET l_cxh.cxh92 = l_cxh.cxh12 + l_cxh.cxh22 + l_cxh.cxh25
                       + l_cxh.cxh27 + l_cxh.cxh29
                       + l_cxh.cxh32 + l_cxh.cxh34
                       + l_cxh.cxh36 + l_cxh.cxh38
                       + l_cxh.cxh40 + l_cxh.cxh42+l_cxh.cxh60
       LET l_cxh.cxh92a= l_cxh.cxh12a + l_cxh.cxh22a + l_cxh.cxh25a
                       + l_cxh.cxh27a + l_cxh.cxh29a
                       + l_cxh.cxh32a + l_cxh.cxh34a
                       + l_cxh.cxh36a + l_cxh.cxh38a
                       + l_cxh.cxh40a + l_cxh.cxh42a+l_cxh.cxh60a
       LET l_cxh.cxh92b= l_cxh.cxh12b + l_cxh.cxh22b + l_cxh.cxh25b
                       + l_cxh.cxh27b + l_cxh.cxh29b
                       + l_cxh.cxh32b + l_cxh.cxh34b
                       + l_cxh.cxh36b + l_cxh.cxh38b
                       + l_cxh.cxh40b + l_cxh.cxh42b+l_cxh.cxh60b
       LET l_cxh.cxh92c= l_cxh.cxh12c + l_cxh.cxh22c + l_cxh.cxh25c
                       + l_cxh.cxh27c + l_cxh.cxh29c
                       + l_cxh.cxh32c + l_cxh.cxh34c
                       + l_cxh.cxh36c + l_cxh.cxh38c
                       + l_cxh.cxh40c + l_cxh.cxh42c+l_cxh.cxh60c
       LET l_cxh.cxh92d= l_cxh.cxh12d + l_cxh.cxh22d + l_cxh.cxh25d
                       + l_cxh.cxh27d + l_cxh.cxh29d
                       + l_cxh.cxh32d + l_cxh.cxh34d
                       + l_cxh.cxh36d + l_cxh.cxh38d
                       + l_cxh.cxh40d + l_cxh.cxh42d + l_cxh.cxh60d
       LET l_cxh.cxh92e= l_cxh.cxh12e + l_cxh.cxh22e + l_cxh.cxh25e
                       + l_cxh.cxh27e + l_cxh.cxh29e
                       + l_cxh.cxh32e + l_cxh.cxh34e
                       + l_cxh.cxh36e + l_cxh.cxh38e
                       + l_cxh.cxh40e + l_cxh.cxh42e + l_cxh.cxh60e
       LET l_cxh.cxh92f= l_cxh.cxh12f + l_cxh.cxh22f + l_cxh.cxh25f
                       + l_cxh.cxh27f + l_cxh.cxh29f
                       + l_cxh.cxh32f + l_cxh.cxh34f
                       + l_cxh.cxh36f + l_cxh.cxh38f
                       + l_cxh.cxh40f + l_cxh.cxh42f + l_cxh.cxh60f
       LET l_cxh.cxh92g= l_cxh.cxh12g + l_cxh.cxh22g + l_cxh.cxh25g
                       + l_cxh.cxh27g + l_cxh.cxh29g
                       + l_cxh.cxh32g + l_cxh.cxh34g
                       + l_cxh.cxh36g + l_cxh.cxh38g
                       + l_cxh.cxh40g + l_cxh.cxh42g + l_cxh.cxh60g
       LET l_cxh.cxh92h= l_cxh.cxh12h + l_cxh.cxh22h + l_cxh.cxh25h
                       + l_cxh.cxh27h + l_cxh.cxh29h
                       + l_cxh.cxh32h + l_cxh.cxh34h
                       + l_cxh.cxh36h + l_cxh.cxh38h
                       + l_cxh.cxh40h + l_cxh.cxh42h + l_cxh.cxh60h
       IF l_cxh.cxh91 < 0 THEN LET l_cxh.cxh91 = 0 END IF
       IF l_cxh.cxh92 < 0 THEN LET l_cxh.cxh92 = 0 END IF
       IF l_cxh.cxh92a < 0 THEN LET l_cxh.cxh92a = 0 END IF
       IF l_cxh.cxh92b < 0 THEN LET l_cxh.cxh92b = 0 END IF
       IF l_cxh.cxh92c < 0 THEN LET l_cxh.cxh92c = 0 END IF
       IF l_cxh.cxh92d < 0 THEN LET l_cxh.cxh92d = 0 END IF
       IF l_cxh.cxh92e < 0 THEN LET l_cxh.cxh92e = 0 END IF
       IF l_cxh.cxh92f < 0 THEN LET l_cxh.cxh92f = 0 END IF   #FUN-7C0028 add
       IF l_cxh.cxh92g < 0 THEN LET l_cxh.cxh92g = 0 END IF   #FUN-7C0028 add
       IF l_cxh.cxh92h < 0 THEN LET l_cxh.cxh92h = 0 END IF   #FUN-7C0028 add
 
       # 累計轉出 = 累計發料 - 期末在製
       LET l_cxh.cxh53 = l_cxh.cxh91 - l_cxh.cxh51
       LET l_cxh.cxh54 = l_cxh.cxh92 - l_cxh.cxh52
       LET l_cxh.cxh54a = l_cxh.cxh92a - l_cxh.cxh52a
       LET l_cxh.cxh54b = l_cxh.cxh92b - l_cxh.cxh52b
       LET l_cxh.cxh54c = l_cxh.cxh92c - l_cxh.cxh52c
       LET l_cxh.cxh54d = l_cxh.cxh92d - l_cxh.cxh52d
       LET l_cxh.cxh54e = l_cxh.cxh92e - l_cxh.cxh52e
       LET l_cxh.cxh54f = l_cxh.cxh92f - l_cxh.cxh52f   #FUN-7C0028 add
       LET l_cxh.cxh54g = l_cxh.cxh92g - l_cxh.cxh52g   #FUN-7C0028 add
       LET l_cxh.cxh54h = l_cxh.cxh92h - l_cxh.cxh52h   #FUN-7C0028 add
 
       UPDATE cxh_file SET * = l_cxh.*
        WHERE cxh01 = g_sfb.sfb01 AND cxh012 =l_cxh.cxh012 #g_caf.caf06
          AND cxh02 = yy AND cxh03 = mm AND cxh04 = l_cxh.cxh04
          AND cxh06 = l_cxh.cxh06 AND cxh07 = l_cxh.cxh07  #FUN-7C0028 add
          AND cxh013 =l_cxh.cxh013 AND cxh014 =l_cxh.cxh014  #FUN-A60095
       IF STATUS THEN 
          LET g_showmsg=g_sfb.sfb01,"/",l_cxh.cxh012                                                         #No.FUN-710027
          CALL s_errmsg('cxh01,cxh012',g_showmsg,'upd cxh.*:',STATUS,1)                                      #No.FUN-710027         
          RETURN 
       END IF
       IF l_cxh.cxh11 =0 AND l_cxh.cxh12a=0 AND l_cxh.cxh12b=0 AND
          l_cxh.cxh12 =0 AND l_cxh.cxh12c=0 AND l_cxh.cxh12d=0 AND
          l_cxh.cxh12e=0 AND l_cxh.cxh12f=0 AND l_cxh.cxh12g=0 AND l_cxh.cxh12h=0 AND   #FUN-7C0028 add
          l_cxh.cxh21 =0 AND l_cxh.cxh22a=0 AND l_cxh.cxh22b=0 AND
          l_cxh.cxh22 =0 AND l_cxh.cxh22c=0 AND l_cxh.cxh22d=0 AND
          l_cxh.cxh22e=0 AND l_cxh.cxh22f=0 AND l_cxh.cxh22g=0 AND l_cxh.cxh22h=0 AND   #FUN-7C0028 add
          l_cxh.cxh24 =0 AND l_cxh.cxh25a=0 AND l_cxh.cxh25b=0 AND
          l_cxh.cxh25 =0 AND l_cxh.cxh25c=0 AND l_cxh.cxh25d=0 AND
          l_cxh.cxh25e=0 AND l_cxh.cxh25f=0 AND l_cxh.cxh25g=0 AND l_cxh.cxh25h=0 AND   #FUN-7C0028 add
          l_cxh.cxh26 =0 AND l_cxh.cxh27a=0 AND l_cxh.cxh27b=0 AND
          l_cxh.cxh27 =0 AND l_cxh.cxh27c=0 AND l_cxh.cxh27d=0 AND
          l_cxh.cxh27e=0 AND l_cxh.cxh27f=0 AND l_cxh.cxh27g=0 AND l_cxh.cxh27h=0 AND   #FUN-7C0028 add
          l_cxh.cxh28 =0 AND l_cxh.cxh29a=0 AND l_cxh.cxh29b=0 AND
          l_cxh.cxh29 =0 AND l_cxh.cxh29c=0 AND l_cxh.cxh29d=0 AND
          l_cxh.cxh29e=0 AND l_cxh.cxh29f=0 AND l_cxh.cxh29g=0 AND l_cxh.cxh29h=0 AND   #FUN-7C0028 add
          l_cxh.cxh31 =0 AND l_cxh.cxh32a=0 AND l_cxh.cxh32b=0 AND
          l_cxh.cxh32 =0 AND l_cxh.cxh32c=0 AND l_cxh.cxh32d=0 AND
          l_cxh.cxh32e=0 AND l_cxh.cxh32f=0 AND l_cxh.cxh32g=0 AND l_cxh.cxh32h=0 AND   #FUN-7C0028 add
          l_cxh.cxh33 =0 AND l_cxh.cxh34a=0 AND l_cxh.cxh34b=0 AND
          l_cxh.cxh34 =0 AND l_cxh.cxh34c=0 AND l_cxh.cxh34d=0 AND
          l_cxh.cxh34e=0 AND l_cxh.cxh34f=0 AND l_cxh.cxh34g=0 AND l_cxh.cxh34h=0 AND   #FUN-7C0028 add
          l_cxh.cxh35 =0 AND l_cxh.cxh36a=0 AND l_cxh.cxh36b=0 AND
          l_cxh.cxh36 =0 AND l_cxh.cxh36c=0 AND l_cxh.cxh36d=0 AND
          l_cxh.cxh36e=0 AND l_cxh.cxh36f=0 AND l_cxh.cxh36g=0 AND l_cxh.cxh36h=0 AND   #FUN-7C0028 add
          l_cxh.cxh37 =0 AND l_cxh.cxh38a=0 AND l_cxh.cxh38b=0 AND
          l_cxh.cxh38 =0 AND l_cxh.cxh38c=0 AND l_cxh.cxh38d=0 AND
          l_cxh.cxh38e=0 AND l_cxh.cxh38f=0 AND l_cxh.cxh38g=0 AND l_cxh.cxh38h=0 AND   #FUN-7C0028 add
          l_cxh.cxh39 =0 AND l_cxh.cxh40a=0 AND l_cxh.cxh40b=0 AND
          l_cxh.cxh40 =0 AND l_cxh.cxh40c=0 AND l_cxh.cxh40d=0 AND
          l_cxh.cxh40e=0 AND l_cxh.cxh40f=0 AND l_cxh.cxh40g=0 AND l_cxh.cxh40h=0 AND   #FUN-7C0028 add
          l_cxh.cxh57 =0 AND l_cxh.cxh58a=0 AND l_cxh.cxh58b=0 AND
          l_cxh.cxh58 =0 AND l_cxh.cxh58c=0 AND l_cxh.cxh58d=0 AND
          l_cxh.cxh58e=0 AND l_cxh.cxh58f=0 AND l_cxh.cxh58g=0 AND l_cxh.cxh58h=0 AND   #FUN-7C0028 add
          l_cxh.cxh59 =0 AND l_cxh.cxh60a=0 AND l_cxh.cxh60b=0 AND
          l_cxh.cxh60 =0 AND l_cxh.cxh60c=0 AND l_cxh.cxh60d=0 AND
          l_cxh.cxh60e=0 AND l_cxh.cxh60f=0 AND l_cxh.cxh60g=0 AND l_cxh.cxh60h=0 AND   #FUN-7C0028 add
          l_cxh.cxh91 =0 AND l_cxh.cxh92a=0 AND l_cxh.cxh92b=0 AND
          l_cxh.cxh92 =0 AND l_cxh.cxh92c=0 AND l_cxh.cxh92d=0 AND
          l_cxh.cxh92e=0 AND l_cxh.cxh92f=0 AND l_cxh.cxh92g=0 AND l_cxh.cxh92h=0 THEN  #FUN-7C0028 add
          DELETE FROM cxh_file
           WHERE cxh01 = g_sfb.sfb01  AND cxh012 =l_cxh.cxh012 #g_caf.caf06
             AND cxh02 = yy   AND cxh03 = mm AND cxh04 = l_cxh.cxh04
             AND cxh06 = type AND cxh07 = g_tlfcost   #FUN-7C0028 add
             AND cxh013 =l_cxh.cxh013 AND cxh014 =l_cxh.cxh014  #FUN-A60095
       END IF
    END FOREACH
    CLOSE wip_32_c11
END FUNCTION
 
FUNCTION wip_2_23()     #  2-3. WIP-元件 本期投入調整成本
   CALL p510_cch_01()   # 將 cch 歸 0
   LET g_cch.cch01 =g_sfb.sfb01
   LET g_cch.cch04 =' ADJUST'   # 料號為 ' ADJUST'
   LET g_cch.cch05 ='P'
   LET g_cch.cch06 =type        #FUN-7C0028 add
   LET g_cch.cch07 =g_tlfcost   #FUN-7C0028 add
 
   # 使調整成本歸入半成品
   LET g_chr=''
   SELECT MAX(ccl05) INTO g_chr FROM ccl_file
    WHERE ccl01=g_sfb.sfb01 AND ccl02=yy AND ccl03=mm AND ccl05='M'
      AND ccl06=type        AND ccl07=g_tlfcost   #FUN-7C0028 add
   IF g_chr='M' THEN LET g_cch.cch05 ='M' END IF
 
   LET g_cch.cch21 =mccg.ccg21
   SELECT SUM(ccl21),
          SUM(ccl22a), SUM(ccl22b), SUM(ccl22c), SUM(ccl22d), SUM(ccl22e)
         ,SUM(ccl22f), SUM(ccl22g), SUM(ccl22h)   #FUN-7C0028 add 
     INTO g_cch.cch21,
          g_cch.cch22a,g_cch.cch22b,g_cch.cch22c,g_cch.cch22d,g_cch.cch22e
         ,g_cch.cch22f,g_cch.cch22g,g_cch.cch22h  #FUN-7C0028 add 
     FROM ccl_file
    WHERE ccl01=g_sfb.sfb01 AND ccl02=yy AND ccl03=mm
      AND ccl06=type        AND ccl07=g_tlfcost   #FUN-7C0028 add
 
   IF g_cch.cch21  IS NULL THEN LET g_cch.cch21 = 0 END IF
   IF g_cch.cch22a IS NULL THEN
      LET g_cch.cch22a = 0 LET g_cch.cch22b = 0 LET g_cch.cch22c = 0
      LET g_cch.cch22d = 0 LET g_cch.cch22e = 0
      LET g_cch.cch22f = 0 LET g_cch.cch22g = 0 LET g_cch.cch22h = 0   #FUN-7C0028 add 
   END IF
   LET g_cch.cch22 =g_cch.cch22a+g_cch.cch22b+g_cch.cch22c
                                +g_cch.cch22d+g_cch.cch22e
                                +g_cch.cch22f+g_cch.cch22g+g_cch.cch22h   #FUN-7C0028 add 
   IF g_cch.cch22 = 0 THEN LET g_cch.cch21 = 0 RETURN END IF
   LET g_cch.cchdate = g_today
  #LET g_cch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
   LET g_cch.cchlegal = g_legal #FUN-980009 add
   LET g_cch.cchoriu = g_user      #No.FUN-980030 10/01/04
   LET g_cch.cchorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO cch_file VALUES(g_cch.*)
     IF STATUS THEN                     # 可能有上期轉入資料造成重複
        UPDATE cch_file SET cch21=cch21+g_cch.cch21,
                            cch22=cch22+g_cch.cch22,
                            cch22a=cch22a+g_cch.cch22a,
                            cch22b=cch22b+g_cch.cch22b,
                            cch22c=cch22c+g_cch.cch22c,
                            cch22d=cch22d+g_cch.cch22d,
                            cch22e=cch22e+g_cch.cch22e, 
                            cch22f=cch22f+g_cch.cch22f,   #FUN-7C0028 add
                            cch22g=cch22g+g_cch.cch22g,   #FUN-7C0028 add
                            cch22h=cch22h+g_cch.cch22h    #FUN-7C0028 add
         WHERE cch01=g_cch.cch01 AND cch02=yy AND cch03=mm
           AND cch04=g_cch.cch04
           AND cch06=g_cch.cch06 AND cch07=g_cch.cch07   #FUN-7C0028 add 
     END IF
END FUNCTION
 
## 製程元件本期投入調整成本
FUNCTION work_2_23()
   CALL p510_cxh_01()   # 將 cxh 歸 0
   LET g_cxh.cxh01 =g_sfb.sfb01
   LET g_cxh.cxh012=g_caf.caf06
   LET g_cxh.cxh013=g_caf.caf012  #FUN-A60095
   LET g_cxh.cxh014=g_caf.caf05   #FUN-A60095
   LET g_cxh.cxh04 =' ADJUST'   # 料號為 ' ADJUST'
   LET g_cxh.cxh05 ='P'
   LET g_cxh.cxh06 =type        #FUN-7C0028 add
   LET g_cxh.cxh07 =g_tlfcost   #FUN-7C0028 add 
 
   #--使調整成本歸入半成品
   LET g_chr=''
   SELECT MAX(cxl05) INTO g_chr FROM cxl_file
    WHERE cxl01=g_sfb.sfb01 AND cxl02=yy AND cxl03=mm AND cxl05='M'
      AND cxl012=g_caf.caf06
   IF g_chr='M' THEN LET g_cxh.cxh05 ='M' END IF
 
   LET g_cxh.cxh21 =gg_cxh21                 #mccg.ccg21
   SELECT SUM(cxl21),
          SUM(cxl22a), SUM(cxl22b), SUM(cxl22c), SUM(cxl22d), SUM(cxl22e)
         ,SUM(cxl22f), SUM(cxl22g), SUM(cxl22h)    #FUN-7C0028 add
     INTO g_cxh.cxh21,
          g_cxh.cxh22a,g_cxh.cxh22b,g_cxh.cxh22c,g_cxh.cxh22d,g_cxh.cxh22e
         ,g_cxh.cxh22f,g_cxh.cxh22g,g_cxh.cxh22h   #FUN-7C0028 add
     FROM cxl_file
    WHERE cxl01=g_sfb.sfb01 AND cxl02=yy AND cxl03=mm AND cxl012=g_caf.caf06
      AND cxl06=type        AND cxl07=g_tlfcost    #FUN-7C0028 add
   IF g_cxh.cxh21  IS NULL THEN LET g_cxh.cxh21 = 0 END IF
   IF g_cxh.cxh22a IS NULL THEN
      LET g_cxh.cxh22a = 0 LET g_cxh.cxh22b = 0 LET g_cxh.cxh22c = 0
      LET g_cxh.cxh22d = 0 LET g_cxh.cxh22e = 0
      LET g_cxh.cxh22f = 0 LET g_cxh.cxh22g = 0 LET g_cxh.cxh22h = 0   #FUN-7C0028 add
   END IF
   LET g_cxh.cxh22 =g_cxh.cxh22a+g_cxh.cxh22b+g_cxh.cxh22c+
                    g_cxh.cxh22d+g_cxh.cxh22e
                   +g_cxh.cxh22f+g_cxh.cxh22g+g_cxh.cxh22h   #FUN-7C0028 add
   IF g_cxh.cxh22 = 0 THEN LET g_cxh.cxh21 = 0 RETURN END IF
   LET g_cxh.cxhdate = g_today
  #LET g_cxh.cxhplant = g_plant #FUN-980009 add    #FUN-A50075
   LET g_cxh.cxhlegal = g_legal #FUN-980009 add
   LET g_cxh.cxhoriu = g_user      #No.FUN-980030 10/01/04
   LET g_cxh.cxhorig = g_grup      #No.FUN-980030 10/01/04
   IF g_cxh.cxh013 IS NULL THEN LET g_cxh.cxh013=' ' END IF #FUN-A60095
   IF g_cxh.cxh014 IS NULL THEN LET g_cxh.cxh014=0   END IF #FUN-A60095
   INSERT INTO cxh_file VALUES(g_cxh.*)
     IF STATUS THEN                     # 可能有上期轉入資料造成重複
        UPDATE cxh_file SET cxh21=cxh21+g_cxh.cxh21,
                            cxh22=cxh22+g_cxh.cxh22,
                            cxh22a=cxh22a+g_cxh.cxh22a,
                            cxh22b=cxh22b+g_cxh.cxh22b,
                            cxh22c=cxh22c+g_cxh.cxh22c,
                            cxh22d=cxh22d+g_cxh.cxh22d,
                            cxh22e=cxh22e+g_cxh.cxh22e,
        		    cxh22f=cxh22f+g_cxh.cxh22f,   #FUN-7C0028 add
        		    cxh22g=cxh22g+g_cxh.cxh22g,   #FUN-7C0028 add
        		    cxh22h=cxh22h+g_cxh.cxh22h    #FUN-7C0028 add
            WHERE cxh01=g_cxh.cxh01 AND cxh02=yy AND cxh03=mm
              AND cxh04=g_cxh.cxh04 AND cxh012=g_cxh.cxh012
              AND cxh06=g_cxh.cxh06 AND cxh07 =g_cxh.cxh07  #FUN-7C0028 add
              AND cxh013=g_cxh.cxh013 AND cxh014=g_cxh.cxh014  #FUN-A60095
        IF STATUS THEN 
           LET g_showmsg=g_cxh.cxh01,"/",yy                                                           #No.FUN-710027
           CALL s_errmsg('cxh01,cxh02',g_showmsg,'upd cxh',STATUS,1)                                 #No.FUN-710027
        END IF
     END IF
END FUNCTION
 
# 以下計算 WIP-元件 本期轉出成本
# 若為實際成本制, 則標準 QPA 由工單備料檔讀出, 不計算標準差異
FUNCTION wip_3()        # step 3. WIP-元件 本期轉出成本
   IF g_ccz.ccz04='2' THEN CALL wip_32() END IF
END FUNCTION
 
FUNCTION wip_32()       # step 3. WIP-元件 本期轉出成本 (實際成本制)
   DEFINE l_ccg RECORD LIKE ccg_file.*
   DEFINE l_cch RECORD LIKE cch_file.*
   DEFINE l_sfa RECORD LIKE sfa_file.*
   DEFINE cost,costa,costb,costc,costd,coste LIKE abb_file.abb25   #No.FUN-680122 DEC(18,10)
   DEFINE costf,costg,costh                  LIKE abb_file.abb25   #FUN-7C0028 add 
   DEFINE last_cch RECORD LIKE cch_file.*
#  DEFINE last_qty      LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
#  DEFINE l_sub_qty     LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
   DEFINE last_qty      LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
   DEFINE l_sub_qty     LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
   DEFINE ccg31_tot     LIKE ccg_file.ccg31          #No.FUN-680122 DEC(15,3)
   DEFINE cch31_tot     LIKE cch_file.cch31          #No.FUN-680122 DEC(15,3)
   DEFINE l_sfv09       LIKE sfv_file.sfv09          #No.FUN-680122 DEC(15,3)    #TQC-840066
   DEFINE l_unit        LIKE type_file.num20_6       #No.FUN-680122 DEC(20,6)    #MOD-4C0005
   DEFINE l_cnt         LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(800)
   DEFINE l_cch31       LIKE cch_file.cch31
   DEFINE l_unissue     LIKE sfa_file.sfa05
   DEFINE l_oldccg01    LIKE ccg_file.ccg01
   DEFINE l_sfm03       LIKE sfm_file.sfm03
   DEFINE l_sfm04       LIKE sfm_file.sfm04
   DEFINE l_sfm05       LIKE sfm_file.sfm05
   DEFINE l_sfm06,l_woqty   LIKE sfm_file.sfm07
   DEFINE l_dif,l_chg   LIKE sfm_file.sfm07
   DEFINE l_sfb08       LIKE sfb_file.sfb08
   DEFINE l_cam07       LIKE cam_file.cam07
   DEFINE l_sharerate   LIKE fid_file.fid03          #No.FUN-680122 DEC(8,3)
 
   #原替代料轉出判斷,若被替代料無投入記錄, 則其替代料無法轉出.
   #在此針對此問題做處理
   DECLARE wip_32_c1SUB CURSOR FOR
     SELECT sfa_file.*, ccg_file.*
       FROM sfa_file,ccg_file
      WHERE ccg01=g_sfb.sfb01 AND ccg02=yy AND ccg03=mm
        AND ccg06=type        AND ccg07=g_tlfcost   #FUN-7C0028 add
        AND sfa01=ccg01
        AND sfa26 IN ('3','4','8')  #FUN-A20037 add '8'
        AND sfa03 NOT IN
           (SELECT cch04 FROM cch_file
             WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
               AND cch06=type        AND cch07=g_tlfcost)   #FUN-7C0028 add 
      ORDER BY sfa26                    #先處理非替代料
   DELETE FROM sub_tmp
   IF STATUS=-206 THEN
      CREATE TEMP TABLE sub_tmp(
          tmp01         LIKE ima_file.ima01,
#         tmp02         LIKE ima_file.ima26
          tmp02         LIKE type_file.num15_3)
          #DEC(15,3))              # 替代轉出量
   END IF
   FOREACH wip_32_c1SUB INTO l_sfa.*,l_ccg.*
     IF l_sfa.sfa161 IS NULL THEN LET l_sfa.sfa161 = 0 END IF
     #以標準QPA計算轉出量
     LET l_cch.cch31 =mccg.ccg31*l_sfa.sfa161
     #特別處理'被替代料(sfa26=3/4)及'替代料(sfa26=S/U)'
     LET l_sub_qty = 0 - (l_cch.cch31*-1)
     CALL p510_sub(l_sfa.sfa01,l_sfa.sfa03,l_sub_qty)
   END FOREACH
 
   # 取生產量
     LET l_sql = " SELECT sfm03,sfm04,sfm05,sfm06 FROM sfm_file  ",
                 " WHERE  sfm01 =  ?  AND sfm10 = '1'",
                 "   and  sfm03 <='",g_edate,"'",
                 "  ORDER BY sfm03,sfm04"
     PREPARE wip_32_presfm FROM l_sql
     DECLARE wip_32_sfmcur CURSOR FOR wip_32_presfm
 
   LET l_sql=  
              "SELECT sfa_file.*,cch_file.*, ccg_file.*  ",
              "  FROM sfa_file LEFT OUTER JOIN cch_file ON cch01=sfa01 AND cch04=sfa03 LEFT OUTER JOIN ccg_file ON sfa01 = ccg01 ",
              " WHERE sfa01= ?  ",
              "   AND cch_file.cch02=? ",
              "   AND cch_file.cch03=? ",
              "   AND cch_file.cch06=? ",   #FUN-7C0028 add 
              "   AND cch_file.cch07=? ",   #FUN-7C0028 add 
              "   AND ccg_file.ccg02 =? ",
              "   AND ccg_file.ccg03 =? ",
              "   AND ccg_file.ccg06 =? ",   #FUN-7C0028 add 
              "   AND ccg_file.ccg07 =? ",   #FUN-7C0028 add 
              " UNION ",
              "SELECT sfa_file.*,cch_file.*, ccg_file.* ",
              "  FROM cch_file LEFT OUTER JOIN sfa_file ON cch01=sfa01 LEFT OUTER JOIN ccg_file ON cch01 = ccg01 AND cch02 = ccg02 AND cch03 = ccg03 AND cch06 = ccg06 AND cch07 = ccg07 ",           #FUN-660142
              " WHERE cch01= ? ",
              "   AND cch02= ? ",
              "   AND cch03= ? ",
              "   AND cch06= ? ",   #FUN-7C0028 add 
              "   AND cch07= ? ",   #FUN-7C0028 add 
              "   AND (cch04=' DL+OH+SUB' OR cch04 = ' ADJUST') ",
              " ORDER BY sfa27,sfa01 " #FUN-660142    
   DECLARE wip_32_c1 CURSOR FROM l_sql
   LET l_oldccg01 = ' '
   FOREACH wip_32_c1
    #USING g_sfb.sfb01,yy,mm,yy,mm,g_sfb.sfb01,yy,mm  #genero   #FUN-7C0028 mark
     USING g_sfb.sfb01,yy,mm,type,g_tlfcost,                    #FUN-7C0028 mod
                       yy,mm,type,g_tlfcost,                    #FUN-7C0028 mod
           g_sfb.sfb01,yy,mm,type,g_tlfcost           #genero   #FUN-7C0028 mod 
      INTO l_sfa.*,l_cch.*, l_ccg.*
      IF l_sfa.sfa161 IS NULL THEN LET l_sfa.sfa161 = 0 END IF
      #(取本月之報廢量)
      IF l_ccg.ccg01 != l_oldccg01 THEN
         LET l_chg = 0    LET l_cnt = 0
         FOREACH wip_32_sfmcur USING l_ccg.ccg01
                                INTO l_sfm03,l_sfm04,l_sfm05,l_sfm06
            LET l_dif = l_sfm06 - l_sfm05
            LET l_chg = l_chg + l_dif
            LET l_cnt = l_cnt + 1
         END FOREACH
         SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = l_ccg.ccg01
         IF cl_null(l_sfb08) THEN LET l_sfb08 = 0 END IF
         LET l_woqty = l_sfb08 - l_chg
      END IF
      LET l_oldccg01 = l_ccg.ccg01
      #未發需求
      IF l_sfa.sfa05 = 0 AND l_woqty != 0  AND l_cch.cch21=0
                         AND l_cch.cch22=0 AND l_cch.cch12=0 THEN 
         CONTINUE FOREACH
      END IF
      LET l_unissue = l_sfa.sfa05 - l_sfa.sfa06
      IF cl_null(l_unissue) then let l_unissue = 0 end if
 
     # qpa以工單備料為準,不再重新計算
     # 元件轉出取整數(四捨五入)
     LET l_cch31 =mccg.ccg31*l_sfa.sfa161   # 以標準 QPA 計算轉出量
     LET l_cch.cch31 =l_cch31
 
     IF l_cch.cch04 = ' DL+OH+SUB' THEN
        CASE WHEN g_ccz.ccz05='1'
                  SELECT SUM(ccg31) INTO ccg31_tot FROM ccg_file
                   WHERE ccg01=g_sfb.sfb01 AND (ccg02*12+ccg03)<=(yy*12+mm)
                     AND ccg06=type        AND ccg07=g_tlfcost   #FUN-7C0028 add
                  IF ccg31_tot IS NULL THEN LET ccg31_tot = 0 END IF
                  DROP TABLE axcp510_tmp
                  # 約當量需相同
                  DECLARE cam_curs CURSOR FOR
                   SELECT UNIQUE cam07 FROM cam_file ,cal_file
                    WHERE cam04=g_sfb.sfb01 AND cam01 <= g_edate
                      AND cam01=cal01 AND cam02=cal02
                      AND calfirm = 'Y'
                  FOREACH cam_curs INTO l_cam07 END FOREACH
                  IF l_cam07 IS NULL THEN LET l_cam07 = 0 END IF
                  # 本張工單的約當量為零(若製程為工單獨立定義的)
                  IF l_cam07 = 0 THEN LET l_cam07 = mccg.ccg31*-1 END IF
                  LET l_sharerate = mccg.ccg31 / l_cam07
                  IF l_sharerate IS NULL THEN LET l_sharerate = 0 END IF
                  IF l_sharerate > 0 THEN LET l_sharerate = 0 END IF
                  IF l_sharerate <-1 THEN LET l_sharerate = -1 END IF
                 IF cl_null(l_cch.cch31) THEN LET l_cch.cch31 = 0 END IF
             WHEN g_ccz.ccz05='2'
                  LET l_cch.cch31 = mccg.ccg20*mccg.ccg31/mccg.ccg21
             WHEN g_ccz.ccz05='3'
                  # 當月如果沒有完工入庫但有人工製費則先不轉出,先放在製
                  LET l_sfv09 = 0
                  SELECT SUM(sfv09) INTO l_sfv09 FROM sfu_file,sfv_file
                   WHERE sfu01=sfv01 AND sfv11 = g_sfb.sfb01
                     AND sfu00 = '1'
                     AND sfu02 >= g_bdate AND sfu02 <= g_edate AND sfupost='Y'
                  IF l_sfv09 > 0 THEN
                     LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21)*-1
                  END IF
        END CASE
     END IF
     IF l_cch.cch04 = ' ADJUST'    THEN
        LET l_sfa.sfa161 = 1
        LET l_cch.cch31 =mccg.ccg31*l_sfa.sfa161
     END IF
     # 特別處理'被替代料(sfa26=3/4)及'替代料(sfa26=S/U)'
     IF l_sfa.sfa26 MATCHES '[348]' AND                      #FUN-A20037 add '8'
        (l_cch.cch11+l_cch.cch21) < l_cch.cch31*-1 THEN
        LET l_sub_qty = (l_cch.cch11+l_cch.cch21) - l_cch.cch31*-1
        LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21) * -1
        CALL p510_sub(l_cch.cch01,l_cch.cch04,l_sub_qty)
     END IF
     IF l_sfa.sfa26 MATCHES '[SUZ]' THEN                     #FUN-A20037 add 'Z'
        LET l_cch.cch31 = 0
        SELECT tmp02 INTO l_cch.cch31 FROM sub_tmp WHERE tmp01=l_cch.cch04
        IF l_cch.cch31 IS NULL THEN LET l_cch.cch31 = 0 END IF
     END IF
     LET qty2= mccg.ccg11+ mccg.ccg21
     LET qty =l_cch.cch11+l_cch.cch21
     LET cost=0  LET costa=0 LET costb=0 LET costc=0 LET costd=0 LET coste=0
     LET costf=0 LET costg=0 LET costh=0   #FUN-7C0028 add 
 
     IF qty!=0 THEN
        LET cost = (l_cch.cch12 +l_cch.cch22 )/qty
        LET costa= (l_cch.cch12a+l_cch.cch22a)/qty
        LET costb= (l_cch.cch12b+l_cch.cch22b)/qty
        LET costc= (l_cch.cch12c+l_cch.cch22c)/qty
        LET costd= (l_cch.cch12d+l_cch.cch22d)/qty
        LET coste= (l_cch.cch12e+l_cch.cch22e)/qty
        LET costf= (l_cch.cch12f+l_cch.cch22f)/qty   #FUN-7C0028 add
        LET costg= (l_cch.cch12g+l_cch.cch22g)/qty   #FUN-7C0028 add
        LET costh= (l_cch.cch12h+l_cch.cch22h)/qty   #FUN-7C0028 add
 
     END IF
     # 成品淨退庫時, 若當期無單位成本, 則取前期
     IF mccg.ccg31 > 0 AND cost=0 THEN
        DECLARE wip_32_c2 CURSOR FOR
          SELECT * FROM cch_file
           WHERE cch01=l_cch.cch01 AND (cch02*12+cch03) < (yy*12+mm)
             AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
             AND cch04=l_cch.cch04
           ORDER BY cch02 DESC,cch03 DESC
        FOREACH wip_32_c2 INTO last_cch.*
          LET last_qty =last_cch.cch11+last_cch.cch21
          IF last_qty!=0 THEN
             LET cost = (last_cch.cch12 +last_cch.cch22 )/last_qty
             LET costa= (last_cch.cch12a+last_cch.cch22a)/last_qty
             LET costb= (last_cch.cch12b+last_cch.cch22b)/last_qty
             LET costc= (last_cch.cch12c+last_cch.cch22c)/last_qty
             LET costd= (last_cch.cch12d+last_cch.cch22d)/last_qty
             LET coste= (last_cch.cch12e+last_cch.cch22e)/last_qty
             LET costf= (last_cch.cch12f+last_cch.cch22f)/last_qty   #FUN-7C0028 add
             LET costg= (last_cch.cch12g+last_cch.cch22g)/last_qty   #FUN-7C0028 add
             LET costh= (last_cch.cch12h+last_cch.cch22h)/last_qty   #FUN-7C0028 add
          END IF
          IF cost <> 0 THEN
             LET g_msg="工單:",l_cch.cch01," ",l_cch.cch04 CLIPPED,
                      " 取前期單位成本"
             LET t_time = TIME
             LET g_time=t_time
            #FUN-A50075--mod--str-- ccy_file del plant&legal
            #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
            #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
             INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                           VALUES(TODAY,g_time,g_user,g_msg)
            #FUN-A50075--mod--end
             EXIT FOREACH
          END IF
        END FOREACH
     END IF
     ## 若拆件式工單用退料方式入庫, 則.
     IF (l_cch.cch11+l_cch.cch21) < 0 THEN
        LET l_cch.cch31 = l_cch.cch31 * -1
     END IF
 
     ## 若期初+本期無投入,..
     IF (l_cch.cch11+l_cch.cch21) = 0 THEN
        LET l_cch.cch31 = 0
     END IF
 
     ### 若生產 = 完工入庫套數 則下階料全數轉出 99.02.24 Star
     IF mccg.ccg11+mccg.ccg21+mccg.ccg31 = 0 AND mccg.ccg31 != 0 THEN
        LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21) * -1
     END IF
 
     ### 98.04.03 Star  依上列判斷決定本月轉出數量後, 再計算下列金額
     IF l_cch.cch04=' DL+OH+SUB' AND g_ccz.ccz05='1' THEN
        LET l_cch.cch31 =(l_cch.cch11+l_cch.cch21)   * l_sharerate
        LET l_cch.cch32b=(l_cch.cch12b+l_cch.cch22b) * l_sharerate
        LET l_cch.cch32c=(l_cch.cch12c+l_cch.cch22c) * l_sharerate
        # Star For 製程委外, 有可能為製程中某一站委外, 則按比率轉出
        LET l_cch.cch32d=(l_cch.cch12d+l_cch.cch22d) * l_sharerate
        LET l_cch.cch32e=(l_cch.cch12e+l_cch.cch22e) * l_sharerate   #FUN-7C0028 add
        LET l_cch.cch32f=(l_cch.cch12f+l_cch.cch22f) * l_sharerate   #FUN-7C0028 add
        LET l_cch.cch32g=(l_cch.cch12g+l_cch.cch22g) * l_sharerate   #FUN-7C0028 add
        LET l_cch.cch32h=(l_cch.cch12h+l_cch.cch22h) * l_sharerate   #FUN-7C0028 add
     ELSE
        IF l_cch.cch31 * -1 > (l_cch.cch11 + l_cch.cch21) THEN
           LET l_cch.cch31 = (l_cch.cch11 + l_cch.cch21) * -1
        END IF
        LET l_cch.cch32 =l_cch.cch31*cost
        LET l_cch.cch32a=l_cch.cch31*costa
        LET l_cch.cch32b=l_cch.cch31*costb
        LET l_cch.cch32c=l_cch.cch31*costc
        LET l_cch.cch32d=l_cch.cch31*costd
        LET l_cch.cch32e=l_cch.cch31*coste
        LET l_cch.cch32f=l_cch.cch31*costf   #FUN-7C0028 add
        LET l_cch.cch32g=l_cch.cch31*costg   #FUN-7C0028 add
        LET l_cch.cch32h=l_cch.cch31*costh   #FUN-7C0028 add
     END IF
     IF l_cch.cch04=' DL+OH+SUB' THEN
        IF g_sfb.sfb24 = 'N' THEN
           LET l_cch.cch32d=l_cch.cch22d*-1
        END IF
     END IF
     #若本期僅發生加工費且完工入庫了. 應要全數轉出,造成有入庫數量但無金額
     # 若本期僅發生加工費且完工入庫了. 應要全數轉出
     IF (g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate)
     OR (mccg.ccg11+mccg.ccg21+mccg.ccg31 = 0 AND mccg.ccg31 != 0
     AND l_cch.cch04 = ' DL+OH+SUB') THEN
        LET l_cch.cch31 =(l_cch.cch11 +l_cch.cch21 )*-1
        LET l_cch.cch32 =(l_cch.cch12 +l_cch.cch22 )*-1
        LET l_cch.cch32a=(l_cch.cch12a+l_cch.cch22a)*-1
        LET l_cch.cch32b=(l_cch.cch12b+l_cch.cch22b)*-1
        LET l_cch.cch32c=(l_cch.cch12c+l_cch.cch22c)*-1
        LET l_cch.cch32d=(l_cch.cch12d+l_cch.cch22d)*-1
        LET l_cch.cch32e=(l_cch.cch12e+l_cch.cch22e)*-1
        LET l_cch.cch32f=(l_cch.cch12f+l_cch.cch22f)*-1   #FUN-7C0028 add
        LET l_cch.cch32g=(l_cch.cch12g+l_cch.cch22g)*-1   #FUN-7C0028 add
        LET l_cch.cch32h=(l_cch.cch12h+l_cch.cch22h)*-1   #FUN-7C0028 add 
     END IF
     LET l_cch.cch32 =l_cch.cch32a+l_cch.cch32b+l_cch.cch32c+
                      l_cch.cch32d+l_cch.cch32e
                     +l_cch.cch32f+l_cch.cch32g+l_cch.cch32h   #FUN-7C0028 add
 
  # 差異成本歸屬方式參數化(ccz09)
  IF g_ccz.ccz09 = 'N' THEN
    ## 若當期未轉出即結案 , 則歸差異成本
     IF (g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate)
        AND mccg.ccg31 = 0 THEN
        LET l_cch.cch41 = l_cch.cch31
        LET l_cch.cch42 = l_cch.cch32
        LET l_cch.cch42a = l_cch.cch32a
        LET l_cch.cch42b = l_cch.cch32b
        LET l_cch.cch42c = l_cch.cch32c
        LET l_cch.cch42d = l_cch.cch32d
        LET l_cch.cch42e = l_cch.cch32e
        LET l_cch.cch42f = l_cch.cch32f   #FUN-7C0028 add
        LET l_cch.cch42g = l_cch.cch32g   #FUN-7C0028 add
        LET l_cch.cch42h = l_cch.cch32h   #FUN-7C0028 add
        LET l_cch.cch31 = 0
        LET l_cch.cch32 = 0
        LET l_cch.cch32a= 0
        LET l_cch.cch32b= 0
        LET l_cch.cch32c= 0
        LET l_cch.cch32d= 0
        LET l_cch.cch32e= 0
        LET l_cch.cch32f= 0   #FUN-7C0028 add
        LET l_cch.cch32g= 0   #FUN-7C0028 add
        LET l_cch.cch32h= 0   #FUN-7C0028 add
     END IF
  END IF
 
   # WIP-元件 本期結存成本
     LET l_cch.cch91 =l_cch.cch11 +l_cch.cch21 +l_cch.cch31 +l_cch.cch41
                     +l_cch.cch59
     LET l_cch.cch92 =l_cch.cch12 +l_cch.cch22 +l_cch.cch32 +l_cch.cch42
                     +l_cch.cch60
     LET l_cch.cch92a=l_cch.cch12a+l_cch.cch22a+l_cch.cch32a+l_cch.cch42a
                     +l_cch.cch60a
     LET l_cch.cch92b=l_cch.cch12b+l_cch.cch22b+l_cch.cch32b+l_cch.cch42b
                     +l_cch.cch60b
     LET l_cch.cch92c=l_cch.cch12c+l_cch.cch22c+l_cch.cch32c+l_cch.cch42c
                     +l_cch.cch60c
     LET l_cch.cch92d=l_cch.cch12d+l_cch.cch22d+l_cch.cch32d+l_cch.cch42d
                     +l_cch.cch60d
     LET l_cch.cch92e=l_cch.cch12e+l_cch.cch22e+l_cch.cch32e+l_cch.cch42e
                     +l_cch.cch60e
     LET l_cch.cch92f=l_cch.cch12f+l_cch.cch22f+l_cch.cch32f+l_cch.cch42f
                     +l_cch.cch60f
     LET l_cch.cch92g=l_cch.cch12g+l_cch.cch22g+l_cch.cch32g+l_cch.cch42g
                     +l_cch.cch60g
     LET l_cch.cch92h=l_cch.cch12h+l_cch.cch22h+l_cch.cch32h+l_cch.cch42h
                     +l_cch.cch60h
 
     #-->累計轉出 = 累計發料 - 期末在製
     LET l_cch.cch53  =  l_cch.cch91  - l_cch.cch51
     LET l_cch.cch54  =  l_cch.cch92  - l_cch.cch52
     LET l_cch.cch54a =  l_cch.cch92a - l_cch.cch52a
     LET l_cch.cch54b =  l_cch.cch92b - l_cch.cch52b
     LET l_cch.cch54c =  l_cch.cch92c - l_cch.cch52c
     LET l_cch.cch54d =  l_cch.cch92d - l_cch.cch52d
     LET l_cch.cch54e =  l_cch.cch92e - l_cch.cch52e
     LET l_cch.cch54f =  l_cch.cch92f - l_cch.cch52f   #FUN-7C0028 add
     LET l_cch.cch54g =  l_cch.cch92g - l_cch.cch52g   #FUN-7C0028 add
     LET l_cch.cch54h =  l_cch.cch92h - l_cch.cch52h   #FUN-7C0028 add
 
     UPDATE cch_file SET * = l_cch.*
      WHERE cch01=l_cch.cch01 AND cch02=yy AND cch03=mm AND cch04=l_cch.cch04
        AND cch06=l_cch.cch06 AND cch07=l_cch.cch07   #FUN-7C0028 add
     IF STATUS THEN  
        LET g_showmsg=l_cch.cch01,"/",yy                                                         #No.FUN-710027
        CALL s_errmsg('cch01,cch02',g_showmsg,'upd cch.*:',STATUS,1)                             #No.FUN-710027
        RETURN 
     END IF
     IF l_cch.cch11 =0 AND l_cch.cch12a=0 AND l_cch.cch12b=0 AND
        l_cch.cch12 =0 AND l_cch.cch12c=0 AND l_cch.cch12d=0 AND
        l_cch.cch12e=0 AND l_cch.cch12f=0 AND l_cch.cch12g=0 AND l_cch.cch12h=0 AND   #FUN-7C0028 add
        l_cch.cch21 =0 AND l_cch.cch22a=0 AND l_cch.cch22b=0 AND
        l_cch.cch22 =0 AND l_cch.cch22c=0 AND l_cch.cch22d=0 AND
        l_cch.cch22e=0 AND l_cch.cch22f=0 AND l_cch.cch22g=0 AND l_cch.cch22h=0 AND   #FUN-7C0028 add
        l_cch.cch31 =0 AND l_cch.cch32a=0 AND l_cch.cch32b=0 AND
        l_cch.cch32 =0 AND l_cch.cch32c=0 AND l_cch.cch32d=0 AND
        l_cch.cch32e=0 AND l_cch.cch32f=0 AND l_cch.cch32g=0 AND l_cch.cch32h=0 AND   #FUN-7C0028 add
        l_cch.cch41 =0 AND l_cch.cch42a=0 AND l_cch.cch42b=0 AND
        l_cch.cch42 =0 AND l_cch.cch42c=0 AND l_cch.cch42d=0 AND
        l_cch.cch42e=0 AND l_cch.cch42f=0 AND l_cch.cch42g=0 AND l_cch.cch42h=0 AND   #FUN-7C0028 add
        l_cch.cch59 =0 AND l_cch.cch60a=0 AND l_cch.cch60b=0 AND
        l_cch.cch60 =0 AND l_cch.cch60c=0 AND l_cch.cch60d=0 AND
        l_cch.cch60e=0 AND l_cch.cch60f=0 AND l_cch.cch60g=0 AND l_cch.cch60h=0 AND   #FUN-7C0028 add
        l_cch.cch91 =0 AND l_cch.cch92a=0 AND l_cch.cch92b=0 AND
        l_cch.cch92 =0 AND l_cch.cch92c=0 AND l_cch.cch92d=0 AND
        l_cch.cch92e=0 AND l_cch.cch92f=0 AND l_cch.cch92g=0 AND l_cch.cch92h=0 THEN  #FUN-7C0028 add
        DELETE FROM cch_file
        WHERE cch01=l_cch.cch01 AND cch02=yy AND cch03=mm AND cch04=l_cch.cch04
          AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
     END IF
   END FOREACH
   CLOSE wip_32_c1
END FUNCTION
 
FUNCTION p510_sub2(p_sfa01,p_sfa27,p_sub_qty)
   DEFINE p_sfa01       LIKE type_file.chr20      #No.FUN-680122 VARCHAR(20)
   DEFINE p_sfa27       LIKE sfa_file.sfa27       #No.MOD-490217
#  DEFINE p_sub_qty     LIKE ima_file.ima26       #No.FUN-680122 DEC(15,3)
   DEFINE p_sub_qty     LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE l_sfa         RECORD LIKE sfa_file.*
   DEFINE l_cxh         RECORD LIKE cxh_file.*
 
   DECLARE p510_sub_c2 CURSOR FOR
     SELECT * FROM sfa_file, cxh_file
      WHERE sfa01=p_sfa01 AND sfa27=p_sfa27 AND sfa26 IN ('S','U','Z')  #FUN-A20037 add 'Z'
        AND sfa01=cxh01 AND cxh02=yy AND cxh03=mm AND sfa03=cxh04
        AND cxh06=type  AND cxh07=g_tlfcost   #FUN-7C0028 add
        AND cxh013=sfa012 AND cxh014=sfa013   #FUN-A60095
      ORDER BY sfa03,sfa012,sfa013  #FUN-A60095
   FOREACH p510_sub_c2 INTO l_sfa.*, l_cxh.*
     LET p_sub_qty = p_sub_qty * l_sfa.sfa28
     IF ((l_cxh.cxh11+l_cxh.cxh21) >= p_sub_qty*-1) OR
         (l_cxh.cxh11 IS NULL AND l_cxh.cxh21 IS NULL) THEN
        LET l_cxh.cxh31 = p_sub_qty
        INSERT INTO sub_tmp VALUES(l_sfa.sfa03,l_cxh.cxh31)
        IF STATUS THEN
           CALL cl_err3("ins","sub_tmp","","",STATUS,"","ins sub_tmp",0)   #No.FUN-660127
        END IF
        #EXIT FOREACH
     ELSE
        LET l_cxh.cxh31 = (l_cxh.cxh11+l_cxh.cxh21)*-1
        INSERT INTO sub_tmp VALUES(l_sfa.sfa03,l_cxh.cxh31)
        IF STATUS THEN 
           CALL cl_err3("ins","sub_tmp","","",STATUS,"","ins sub_tmp",0)   #No.FUN-660127
        END IF
        IF cl_null(l_cxh.cxh11) THEN LET l_cxh.cxh11 = 0 END IF
        IF cl_null(l_cxh.cxh21) THEN LET l_cxh.cxh21 = 0 END IF
        LET p_sub_qty = p_sub_qty + (l_cxh.cxh11+l_cxh.cxh21)
        LET p_sub_qty = p_sub_qty / l_sfa.sfa28
     END IF
   END FOREACH
   CLOSE p510_sub_c2
END FUNCTION
 
FUNCTION p510_sub(p_sfa01,p_sfa27,p_sub_qty)
   DEFINE p_sfa01       LIKE type_file.chr20      #No.FUN-680122 VARCHAR(20)
   DEFINE p_sfa27       LIKE sfa_file.sfa27       #No.MOD-490217
#  DEFINE p_sub_qty     LIKE ima_file.ima26       #No.FUN-680122 DEC(15,3)
   DEFINE p_sub_qty     LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
   DEFINE l_sfa         RECORD LIKE sfa_file.*
   DEFINE l_cch         RECORD LIKE cch_file.*
 
   DECLARE p510_sub_c1 CURSOR FOR
     SELECT * FROM sfa_file, cch_file
      WHERE sfa01=p_sfa01 AND sfa27=p_sfa27 AND sfa26 IN ('S','U','Z')  #FUN-A20037 add 'Z'
        AND sfa01=cch01 AND cch02=yy AND cch03=mm AND sfa03=cch04
        AND cch06=type  AND cch07=g_tlfcost   #FUN-7C0028 add
      ORDER BY sfa03
   FOREACH p510_sub_c1 INTO l_sfa.*, l_cch.*
     LET p_sub_qty = p_sub_qty * l_sfa.sfa28
     IF ((l_cch.cch11+l_cch.cch21) >= p_sub_qty*-1)
     OR (l_cch.cch11 IS NULL AND l_cch.cch21 IS NULL)
        THEN LET l_cch.cch31 = p_sub_qty
             INSERT INTO sub_tmp VALUES(l_sfa.sfa03,l_cch.cch31)
             IF STATUS THEN 
                CALL s_errmsg('','','ins sub_tmp',STATUS,1)                                     #No.FUN-710027 
             END IF
             EXIT FOREACH
        ELSE LET l_cch.cch31 = (l_cch.cch11+l_cch.cch21)*-1
             INSERT INTO sub_tmp VALUES(l_sfa.sfa03,l_cch.cch31)
             IF STATUS THEN 
                CALL s_errmsg('','','ins sub_tmp',STATUS,1)                                      #No.FUN-710027 
             END IF
             IF cl_null(l_cch.cch11) THEN LET l_cch.cch11 = 0 END IF
             IF cl_null(l_cch.cch21) THEN LET l_cch.cch21 = 0 END IF
             LET p_sub_qty = p_sub_qty + (l_cch.cch11+l_cch.cch21)
             LET p_sub_qty = p_sub_qty / l_sfa.sfa28
     END IF
   END FOREACH
   CLOSE p510_sub_c1
END FUNCTION
 
FUNCTION wip_4()        # 計算每張工單的 WIP-主件 成本 (ccg)
   SELECT SUM(cch12),SUM(cch12a),SUM(cch12b),SUM(cch12c),SUM(cch12d),SUM(cch12e),
                     SUM(cch12f),SUM(cch12g),SUM(cch12h),   #FUN-7C0028 add
          SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),
                     SUM(cch22f),SUM(cch22g),SUM(cch22h),   #FUN-7C0028 add
          SUM(cch32),SUM(cch32a),SUM(cch32b),SUM(cch32c),SUM(cch32d),SUM(cch32e),
                     SUM(cch32f),SUM(cch32g),SUM(cch32h),   #FUN-7C0028 add
          SUM(cch42),SUM(cch42a),SUM(cch42b),SUM(cch42c),SUM(cch42d),SUM(cch42e),
                     SUM(cch42f),SUM(cch42g),SUM(cch42h),   #FUN-7C0028 add
          SUM(cch92),SUM(cch92a),SUM(cch92b),SUM(cch92c),SUM(cch92d),SUM(cch92e)
                    ,SUM(cch92f),SUM(cch92g),SUM(cch92h)    #FUN-7C0028 add
     INTO mccg.ccg12,mccg.ccg12a,mccg.ccg12b,mccg.ccg12c,mccg.ccg12d,mccg.ccg12e,
                     mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,   #FUN-7C0028 add
          mccg.ccg22,mccg.ccg22a,mccg.ccg22b,mccg.ccg22c,mccg.ccg22d,mccg.ccg22e,
                     mccg.ccg22f,mccg.ccg22g,mccg.ccg22h,   #FUN-7C0028 add
          mccg.ccg32,mccg.ccg32a,mccg.ccg32b,mccg.ccg32c,mccg.ccg32d,mccg.ccg32e,
                     mccg.ccg32f,mccg.ccg32g,mccg.ccg32h,   #FUN-7C0028 add
          mccg.ccg42,mccg.ccg42a,mccg.ccg42b,mccg.ccg42c,mccg.ccg42d,mccg.ccg42e,
                     mccg.ccg42f,mccg.ccg42g,mccg.ccg42h,   #FUN-7C0028 add
          mccg.ccg92,mccg.ccg92a,mccg.ccg92b,mccg.ccg92c,mccg.ccg92d,mccg.ccg92e
                    ,mccg.ccg92f,mccg.ccg92g,mccg.ccg92h    #FUN-7C0028 add
     FROM cch_file
    WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
      AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
   IF mccg.ccg12 IS NULL THEN
      LET mccg.ccg12 = 0 LET mccg.ccg12a= 0 LET mccg.ccg12b= 0
      LET mccg.ccg12c= 0 LET mccg.ccg12d= 0 LET mccg.ccg12e= 0
      LET mccg.ccg12f= 0 LET mccg.ccg12g= 0 LET mccg.ccg12h= 0   #FUN-7C0028 add
      LET mccg.ccg22 = 0 LET mccg.ccg22a= 0 LET mccg.ccg22b= 0
      LET mccg.ccg22c= 0 LET mccg.ccg22d= 0 LET mccg.ccg22e= 0
      LET mccg.ccg22f= 0 LET mccg.ccg22g= 0 LET mccg.ccg22h= 0   #FUN-7C0028 add
      LET mccg.ccg32 = 0 LET mccg.ccg32a= 0 LET mccg.ccg32b= 0
      LET mccg.ccg32c= 0 LET mccg.ccg32d= 0 LET mccg.ccg32e= 0
      LET mccg.ccg32f= 0 LET mccg.ccg32g= 0 LET mccg.ccg32h= 0   #FUN-7C0028 add
      LET mccg.ccg42 = 0 LET mccg.ccg42a= 0 LET mccg.ccg42b= 0
      LET mccg.ccg42c= 0 LET mccg.ccg42d= 0 LET mccg.ccg42e= 0
      LET mccg.ccg42f= 0 LET mccg.ccg42g= 0 LET mccg.ccg42h= 0   #FUN-7C0028 add
      LET mccg.ccg92 = 0 LET mccg.ccg92a= 0 LET mccg.ccg92b= 0
      LET mccg.ccg92c= 0 LET mccg.ccg92d= 0 LET mccg.ccg92e= 0
      LET mccg.ccg92f= 0 LET mccg.ccg92g= 0 LET mccg.ccg92h= 0   #FUN-7C0028 add
   END IF
   #--->取半成品
   SELECT SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e)
                    ,SUM(cch22f),SUM(cch22g),SUM(cch22h)   #FUN-7C0028 add
     INTO mccg.ccg23,mccg.ccg23a,mccg.ccg23b,mccg.ccg23c,mccg.ccg23d,mccg.ccg23e
                    ,mccg.ccg23f,mccg.ccg23g,mccg.ccg23h   #FUN-7C0028 add
       FROM cch_file
    WHERE cch01=g_cch.cch01 AND cch02=g_cch.cch02 AND cch03=g_cch.cch03
      AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
      AND cch05 IN ('M','R')
   IF mccg.ccg23 IS NULL THEN
      LET mccg.ccg23 = 0 LET mccg.ccg23a= 0 LET mccg.ccg23b= 0
      LET mccg.ccg23c= 0 LET mccg.ccg23d= 0 LET mccg.ccg23e= 0
      LET mccg.ccg23f= 0 LET mccg.ccg23g= 0 LET mccg.ccg23h= 0   #FUN-7C0028 add 
   END IF
   LET mccg.ccg22 =mccg.ccg22 -mccg.ccg23
   LET mccg.ccg22a=mccg.ccg22a-mccg.ccg23a
   LET mccg.ccg22b=mccg.ccg22b-mccg.ccg23b
   LET mccg.ccg22c=mccg.ccg22c-mccg.ccg23c
   LET mccg.ccg22d=mccg.ccg22d-mccg.ccg23d
   LET mccg.ccg22e=mccg.ccg22e-mccg.ccg23e
   LET mccg.ccg22f=mccg.ccg22f-mccg.ccg23f   #FUN-7C0028 add
   LET mccg.ccg22g=mccg.ccg22g-mccg.ccg23g   #FUN-7C0028 add 
   LET mccg.ccg22h=mccg.ccg22h-mccg.ccg23h   #FUN-7C0028 add 
   LET mccg.ccg91 =mccg.ccg11 + mccg.ccg21 + mccg.ccg31 + mccg.ccg41
   LET t_time = TIME
   LET mccg.ccguser=g_user LET mccg.ccgdate=TODAY LET mccg.ccgtime=t_time
 
   UPDATE ccg_file SET ccg_file.* = mccg.*
    WHERE ccg01=mccg.ccg01 AND ccg02=mccg.ccg02 AND ccg03=mccg.ccg03
      AND ccg06=mccg.ccg06 AND ccg07=mccg.ccg07   #FUN-7C0028 add
   IF STATUS THEN 
      LET g_showmsg = mccg.ccg01,"/",mccg.ccg02                                                        #No.FUN-710027 
      CALL s_errmsg('ccg01,ccg02',g_showmsg,'upd ccg.*',STATUS,1)                                     #No.FUN-710027 
      RETURN 
   END IF
   SELECT COUNT(*) INTO g_cnt FROM cch_file
    WHERE cch01=mccg.ccg01 AND cch02=yy AND cch03=mm
      AND cch06=mccg.ccg06 AND cch07=mccg.ccg07   #FUN-7C0028 add
   IF g_cnt=0 AND
　    mccg.ccg11 =0 AND mccg.ccg12 =0 AND mccg.ccg12a=0 AND
      mccg.ccg12b=0 AND mccg.ccg12c=0 AND mccg.ccg12d=0 AND
　    mccg.ccg12e=0 AND mccg.ccg12f=0 AND mccg.ccg12g=0 AND mccg.ccg12h=0 AND   #FUN-7C0028 add
      mccg.ccg20 =0 AND
      mccg.ccg21 =0 AND mccg.ccg22 =0 AND mccg.ccg22a=0 AND
      mccg.ccg22b=0 AND mccg.ccg22c=0 AND mccg.ccg22d=0 AND
      mccg.ccg22e=0 AND mccg.ccg22f=0 AND mccg.ccg22g=0 AND mccg.ccg22h=0 AND   #FUN-7C0028 add
      mccg.ccg23 =0 AND mccg.ccg23a=0 AND mccg.ccg23b=0 AND
      mccg.ccg23c=0 AND mccg.ccg23d=0 AND
      mccg.ccg23e=0 AND mccg.ccg23f=0 AND mccg.ccg23g=0 AND mccg.ccg23h=0 AND   #FUN-7C0028 add
      mccg.ccg31 =0 AND mccg.ccg32 =0 AND mccg.ccg32a=0 AND
      mccg.ccg32b=0 AND mccg.ccg32c=0 AND mccg.ccg32d=0 AND
      mccg.ccg32e=0 AND mccg.ccg32f=0 AND mccg.ccg32g=0 AND mccg.ccg32h=0 AND   #FUN-7C0028 add
      mccg.ccg41 =0 AND mccg.ccg42 =0 AND mccg.ccg42a=0 AND
      mccg.ccg42b=0 AND mccg.ccg42c=0 AND mccg.ccg42d=0 AND
      mccg.ccg42e=0 AND mccg.ccg42f=0 AND mccg.ccg42g=0 AND mccg.ccg42h=0 AND   #FUN-7C0028 add
      mccg.ccg91 =0 AND mccg.ccg92 =0 AND mccg.ccg92a=0 AND
      mccg.ccg92b=0 AND mccg.ccg92c=0 AND mccg.ccg92d=0 AND
      mccg.ccg92e=0 AND mccg.ccg92f=0 AND mccg.ccg92g=0 AND mccg.ccg92h=0 THEN  #FUN-7C0028 add
      DELETE FROM ccg_file
      WHERE ccg01=mccg.ccg01 AND ccg02=yy AND ccg03=mm
        AND ccg06=type       AND ccg07=g_tlfcost   #FUN-7C0028 add
   END IF
END FUNCTION
 
FUNCTION work_4()     # 計算每張工單的 WIP-元件 成本 (cch)
 DEFINE l_p01       LIKE aab_file.aab02          #No.FUN-680122 VARCHAR(06)
 DEFINE l_p02       LIKE aab_file.aab02          #No.FUN-680122 VARCHAR(06)
#DEFINE l_p03       LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)	
 DEFINE l_p03       LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
 DEFINE l_sfa       RECORD LIKE sfa_file.*
 DEFINE l_ccg       RECORD LIKE ccg_file.*
 DEFINE l_cai       RECORD LIKE cai_file.*
#DEFINE l_sub_qty   LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
 DEFINE l_sub_qty   LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
 DEFINE l_cxh01     LIKE cxh_file.cxh01
 DEFINE cost,costa,costb,costc,costd,coste    LIKE abb_file.abb25          #No.FUN-680122DEC(20,10)   #MOD-4C0005
 DEFINE costf,costg,costh                     LIKE abb_file.abb25          #FUN-7C0028 add
 DEFINE qty1,qty2   LIKE sfq_file.sfq03
 DEFINE l_cxh02     LIKE cxh_file.cxh02
 DEFINE l_cxh03     LIKE cxh_file.cxh03
 DEFINE l_cxh04     LIKE cxh_file.cxh04
 DEFINE l_cxh05     LIKE cxh_file.cxh05
 DEFINE l_cxh011    LIKE cxh_file.cxh011
 DEFINE last_cch    RECORD LIKE cch_file.*
#DEFINE last_qty    LIKE ima_file.ima26          #No.FUN-680122 DEC(15,3)
 DEFINE last_qty    LIKE type_file.num15_3       ###GP5.2  #NO.FUN-A20044
 DEFINE l_cam07     LIKE cam_file.cam07
 DEFINE l_sfv09     LIKE sfv_file.sfv09
 DEFINE l_sharerate LIKE fid_file.fid03          #No.FUN-680122 DEC(8,3)
 DEFINE l_sql       LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(300)
 DEFINE l_cxh012    LIKE cxh_file.cxh012
 DEFINE l_cxh38,l_cxh38a,l_cxh38b    LIKE cxh_file.cxh38a
 DEFINE l_cxh38c,l_cxh38d,l_cxh38e   LIKE cxh_file.cxh38a
 DEFINE l_cxh38f,l_cxh38g,l_cxh38h   LIKE cxh_file.cxh38a   #FUN-7C0028 add
 DEFINE l_cah       RECORD LIKE cah_file.*
 DEFINE l_sfa161    LIKE sfa_file.sfa161
 DEFINE l_oldcxh012 LIKE cxh_file.cxh012
 DEFINE l_cch23     LIKE cch_file.cch22
 DEFINE l_cch31     LIKE cch_file.cch22
 DEFINE l_cch23a    LIKE cch_file.cch22a
 DEFINE l_cch23b    LIKE cch_file.cch22b
 DEFINE l_cch23c    LIKE cch_file.cch22c
 DEFINE l_cch23d    LIKE cch_file.cch22d
 DEFINE l_cch23e    LIKE cch_file.cch22e
 DEFINE l_cch23f    LIKE cch_file.cch22f    #FUN-7C0028 add
 DEFINE l_cch23g    LIKE cch_file.cch22g    #FUN-7C0028 add
 DEFINE l_cch23h    LIKE cch_file.cch22h    #FUN-7C0028 add
 DEFINE l_ecm04     LIKE ecm_file.ecm04     #FUN-660142 add
 DEFINE l_cxh2      RECORD LIKE cxh_file.*  #FUN-660142 add
 DEFINE l_cxh013    LIKE cxh_file.cxh013    #FUN-A60095
 DEFINE l_cxh014    LIKE cxh_file.cxh014    #FUN-A60095
 DEFINE l_oldcxh013 LIKE cxh_file.cxh013    #FUN-A60095
 DEFINE l_oldcxh014 LIKE cxh_file.cxh014    #FUN-A60095
 DEFINE l_ecm012    LIKE ecm_file.ecm012    #FUN-A60095
 DEFINE l_ecm03     LIKE ecm_file.ecm03     #FUN-A60095
 
 DECLARE cch_work_4_cur CURSOR FOR
   SELECT cxh01,cxh012,cxh02,cxh03,cxh04,cxh05,cxh013,cxh014  #FUN-A60095   
     FROM cxh_file
    WHERE cxh01=g_sfb.sfb01
      AND cxh02=yy   AND cxh03=mm
      AND cxh06=type AND cxh07=g_tlfcost   #FUN-7C0028 add
 IF STATUS THEN 
    LET g_showmsg=g_sfb.sfb01,"/",yy                                                             #No.FUN-710027
    CALL s_errmsg('cxh01,cxh02',g_showmsg,'sel cch_file cch_work_4_cur',STATUS,1)                #No.FUN-710027
 LET g_success='N' END IF
 LET l_oldcxh012=' '
 LET l_oldcxh013=NULL  #FUN-A60095
 LET l_oldcxh014=' '   #FUN-A60095
 FOREACH cch_work_4_cur INTO l_cxh01,l_cxh012,l_cxh02,l_cxh03,l_cxh04,l_cxh05,l_cxh013,l_cxh014
  IF STATUS THEN 
      CALL s_errmsg('','','cch_work_4_for',STATUS,0)  #No.FUN-710027
      EXIT FOREACH
  END IF
  SELECT sfa161 INTO l_sfa161 FROM sfa_file WHERE sfa01=l_cxh01
                                              AND sfa03=l_cxh04
                                              AND sfa012=l_cxh013  #FUN-A60095
                                              AND sfa013=l_cxh014  #FUN-A60095
  IF l_sfa161 IS NULL THEN LET l_sfa161=0  END IF
  SELECT * INTO mcch.* FROM cch_file WHERE cch01=l_cxh01
     AND cch02=yy   AND cch03=mm AND cch04=l_cxh04
     AND cch06=type AND cch07=g_tlfcost   #FUN-7C0028 add
  IF STATUS=100 THEN  #若上期沒有資料
    CALL p510_mcch_0()   # 將 mcch 歸 0	
    LET mcch.cch01=l_cxh01
    LET mcch.cch04=l_cxh04
    LET mcch.cch05=l_cxh05
    LET mcch.cch06=type        #FUN-7C0028 add
    LET mcch.cch07=g_tlfcost   #FUN-7C0028 add
    LET mcch.cchuser=g_user
    LET mcch.cchdate=g_today
    LET mcch.cchtime=TIME
  END IF
  LET mcch.cch21=mccg.ccg21
 #LET mcch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
  LET mcch.cchlegal = g_legal #FUN-980009 add
  LET mcch.cchoriu = g_user      #No.FUN-980030 10/01/04
  LET mcch.cchorig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO cch_file VALUES(mcch.*)
  IF (NOT cl_sql_dup_value(SQLCA.SQLCODE)) AND SQLCA.SQLCODE <0 THEN   #TQC-790087
      LET g_showmsg=mcch.cch01,"/",mcch.cch02                                                               #No.FUN-710027
      CALL s_errmsg('cch01,cch02',g_showmsg,'work_4:ins cch:',SQLCA.SQLCODE,1)                                     #No.FUN-710027
      RETURN 
   END IF                                                                           
 
  SELECT SUM(cxh12), SUM(cxh12a),SUM(cxh12b),
         SUM(cxh12c),SUM(cxh12d),SUM(cxh12e),
         SUM(cxh12f),SUM(cxh12g),SUM(cxh12h),   #FUN-7C0028 add
         SUM(cxh22), SUM(cxh22a),SUM(cxh22b),
         SUM(cxh22c),SUM(cxh22d),SUM(cxh22e),
         SUM(cxh22f),SUM(cxh22g),SUM(cxh22h),   #FUN-7C0028 add
         SUM(cxh51),
         SUM(cxh52), SUM(cxh52a),SUM(cxh52b),
         SUM(cxh52c),SUM(cxh52d),SUM(cxh52e),
         SUM(cxh52f),SUM(cxh52g),SUM(cxh52h),   #FUN-7C0028 add
         SUM(cxh54), SUM(cxh54a),SUM(cxh54b),
         SUM(cxh54c),SUM(cxh54d),SUM(cxh54e),
         SUM(cxh54f),SUM(cxh54g),SUM(cxh54h),   #FUN-7C0028 add
         SUM(cxh56), SUM(cxh56a),SUM(cxh56b),
         SUM(cxh56c),SUM(cxh56d),SUM(cxh56e),
         SUM(cxh56f),SUM(cxh56g),SUM(cxh56h),   #FUN-7C0028 add
         SUM(cxh58), SUM(cxh58a),SUM(cxh58b),
         SUM(cxh58c),SUM(cxh58d),SUM(cxh58e),
         SUM(cxh58f),SUM(cxh58g),SUM(cxh58h),   #FUN-7C0028 add
         SUM(cxh60), SUM(cxh60a),SUM(cxh60b),
         SUM(cxh60c),SUM(cxh60d),SUM(cxh60e),
         SUM(cxh60f),SUM(cxh60g),SUM(cxh60h),   #FUN-7C0028 add
         SUM(cxh92), SUM(cxh92a),SUM(cxh92b),
         SUM(cxh92c),SUM(cxh92d),SUM(cxh92e),
         SUM(cxh92f),SUM(cxh92g),SUM(cxh92h)    #FUN-7C0028 add
    INTO mcch.cch12,mcch.cch12a,mcch.cch12b,mcch.cch12c,mcch.cch12d,mcch.cch12e,
                    mcch.cch12f,mcch.cch12g,mcch.cch12h,   #FUN-7C0028 add
         mcch.cch22,mcch.cch22a,mcch.cch22b,mcch.cch22c,mcch.cch22d,mcch.cch22e,
                    mcch.cch22f,mcch.cch22g,mcch.cch22h,   #FUN-7C0028 add
         mcch.cch51,
         mcch.cch52,mcch.cch52a,mcch.cch52b,mcch.cch52c,mcch.cch52d,mcch.cch52e,
                    mcch.cch52f,mcch.cch52g,mcch.cch52h,   #FUN-7C0028 add
         mcch.cch54,mcch.cch54a,mcch.cch54b,mcch.cch54c,mcch.cch54d,mcch.cch54e,
                    mcch.cch54f,mcch.cch54g,mcch.cch54h,   #FUN-7C0028 add
         mcch.cch56,mcch.cch56a,mcch.cch56b,mcch.cch56c,mcch.cch56d,mcch.cch56e,
                    mcch.cch56f,mcch.cch56g,mcch.cch56h,   #FUN-7C0028 add
         mcch.cch58,mcch.cch58a,mcch.cch58b,mcch.cch58c,mcch.cch58d,mcch.cch58e,
                    mcch.cch58f,mcch.cch58g,mcch.cch58h,   #FUN-7C0028 add
         mcch.cch60,mcch.cch60a,mcch.cch60b,mcch.cch60c,mcch.cch60d,mcch.cch60e,
                    mcch.cch60f,mcch.cch60g,mcch.cch60h,   #FUN-7C0028 add
         mcch.cch92,mcch.cch92a,mcch.cch92b,mcch.cch92c,mcch.cch92d,mcch.cch92e,
                    mcch.cch92f,mcch.cch92g,mcch.cch92h    #FUN-7C0028 add
    FROM cxh_file
   WHERE cxh01=l_cxh01 AND cxh02=l_cxh02 AND cxh03=l_cxh03
     AND cxh04=l_cxh04
     AND cxh06=type    AND cxh07=g_tlfcost   #FUN-7C0028 add
     AND cxh012=l_cxh012 AND cxh013=l_cxh013 AND cxh014=l_cxh014  #FUN-A60095
  IF STATUS THEN 
     LET g_showmsg=l_cxh01,"/",l_cxh02                                                       #No.FUN-710027
     CALL s_errmsg('cxh01,cxh02',g_showmsg,'sel cxh:SUM(cxh)',STATUS,1)                      #No.FUN-710027
     LET g_success='N' END IF
     IF mcch.cch12 IS NULL THEN
        LET mcch.cch12 = 0 LET mcch.cch12a= 0 LET mcch.cch12b= 0
        LET mcch.cch12c= 0 LET mcch.cch12d= 0 LET mcch.cch12e= 0
        LET mcch.cch12f= 0 LET mcch.cch12g= 0 LET mcch.cch12h= 0   #FUN-7C0028 add
        LET mcch.cch22 = 0 LET mcch.cch22a= 0 LET mcch.cch22b= 0
        LET mcch.cch22c= 0 LET mcch.cch22d= 0 LET mcch.cch22e= 0
        LET mcch.cch22f= 0 LET mcch.cch22g= 0 LET mcch.cch22h= 0   #FUN-7C0028 add
        LET mcch.cch51 = 0
        LET mcch.cch52 = 0 LET mcch.cch52a= 0 LET mcch.cch52b= 0
        LET mcch.cch52c= 0 LET mcch.cch52d= 0 LET mcch.cch52e= 0
        LET mcch.cch52f= 0 LET mcch.cch52g= 0 LET mcch.cch52h= 0   #FUN-7C0028 add
        LET mcch.cch54 = 0 LET mcch.cch54a= 0 LET mcch.cch54b= 0
        LET mcch.cch54c= 0 LET mcch.cch54d= 0 LET mcch.cch54e= 0
        LET mcch.cch54f= 0 LET mcch.cch54g= 0 LET mcch.cch54h= 0   #FUN-7C0028 add
        LET mcch.cch56 = 0 LET mcch.cch56a= 0 LET mcch.cch56b= 0
        LET mcch.cch56c= 0 LET mcch.cch56d= 0 LET mcch.cch56e= 0
        LET mcch.cch56f= 0 LET mcch.cch56g= 0 LET mcch.cch56h= 0   #FUN-7C0028 add
        LET mcch.cch58 = 0 LET mcch.cch58a= 0 LET mcch.cch58b= 0
        LET mcch.cch58c= 0 LET mcch.cch58d= 0 LET mcch.cch58e= 0
        LET mcch.cch58f= 0 LET mcch.cch58g= 0 LET mcch.cch58h= 0   #FUN-7C0028 add
        LET mcch.cch60 = 0 LET mcch.cch60a= 0 LET mcch.cch60b= 0
        LET mcch.cch60c= 0 LET mcch.cch60d= 0 LET mcch.cch60e= 0
        LET mcch.cch60f= 0 LET mcch.cch60g= 0 LET mcch.cch60h= 0   #FUN-7C0028 add
        LET mcch.cch92 = 0 LET mcch.cch92a= 0 LET mcch.cch92b= 0
        LET mcch.cch92c= 0 LET mcch.cch92d= 0 LET mcch.cch92e= 0
        LET mcch.cch92f= 0 LET mcch.cch92g= 0 LET mcch.cch92h= 0   #FUN-7C0028 add
     END IF
 
   #當站下線量cxh38 !=0------------------------------------------
  #IF l_oldcxh012 !=l_cxh012 THEN  #FUN-A60095 mark
   IF NOT ((l_oldcxh013 =l_cxh013) AND (l_oldcxh014 =l_cxh014)) THEN  #FUN-A60095 mark
      SELECT SUM(cxh38a),SUM(cxh38b),SUM(cxh38c),SUM(cxh38d),SUM(cxh38e)
                        ,SUM(cxh38f),SUM(cxh38g),SUM(cxh38h)   #FUN-7C0028 add
        INTO l_cxh38a,l_cxh38b,l_cxh38c,l_cxh38d,l_cxh38e
                     ,l_cxh38f,l_cxh38g,l_cxh38h   #FUN-7C0028 add
        FROM cxh_file
       WHERE cxh01 =l_cxh01 AND cxh02=l_cxh02 AND cxh03=l_cxh03
         AND cxh012=l_cxh012 AND cxh37 !=0 AND cxh38 !=0
         AND cxh06=type      AND cxh07=g_tlfcost   #FUN-7C0028 add
         AND cxh012=l_cxh012 AND cxh013=l_cxh013 AND cxh014=l_cxh014  #FUN-A60095
      IF l_cxh38a IS NULL THEN LET l_cxh38a=0 END IF
      IF l_cxh38b IS NULL THEN LET l_cxh38b=0 END IF
      IF l_cxh38c IS NULL THEN LET l_cxh38c=0 END IF
      IF l_cxh38d IS NULL THEN LET l_cxh38d=0 END IF
      IF l_cxh38e IS NULL THEN LET l_cxh38e=0 END IF
      IF l_cxh38f IS NULL THEN LET l_cxh38f=0 END IF   #FUN-7C0028 add
      IF l_cxh38g IS NULL THEN LET l_cxh38g=0 END IF   #FUN-7C0028 add
      IF l_cxh38h IS NULL THEN LET l_cxh38h=0 END IF   #FUN-7C0028 add
 
      DECLARE cah_cur8 CURSOR FOR
       SELECT * FROM cah_file
        WHERE cah01=l_cxh01 AND cah02=l_cxh02
          AND cah03=l_cxh03 AND cah06=l_cxh012
          AND cah012=l_cxh013 AND cah05=l_cxh014  #FUN-A60095
      FOREACH cah_cur8 INTO l_cah.*
         LET l_cxh38=l_cxh38a+l_cxh38b+l_cxh38c+l_cxh38d+l_cxh38e
                    +l_cxh38f+l_cxh38g+l_cxh38h   #FUN-7C0028 add
         UPDATE cah_file 
            SET cah08 =l_cxh38, cah08a=l_cxh38a,cah08b=l_cxh38b,
                cah08c=l_cxh38c,cah08d=l_cxh38d,cah08e=l_cxh38e
         WHERE cah01=l_cah.cah01 AND cah02=l_cah.cah02 AND cah03=l_cah.cah03
           AND cah06=l_cah.cah06 AND cah04=l_cah.cah04
           AND cah012=l_cah.cah012 AND cah05=l_cah.cah05  #FUN-A60095
      END FOREACH
   END IF
   LET l_oldcxh012=l_cxh012
   LET l_oldcxh013=l_cxh013  #FUN-A60095
   LET l_oldcxh014=l_cxh014  #FUN-A60095
 
   #-->元件轉出取整數(四捨五入)
   LET l_cch31 =mccg.ccg31*l_sfa161 # 以標準 QPA 計算轉出量
   LET mcch.cch31 =l_cch31
 
   IF mcch.cch04 = ' DL+OH+SUB' THEN
      CASE WHEN g_ccz.ccz05='1' # 約當量需相同
                DECLARE cam_curs8 CURSOR FOR
                 SELECT UNIQUE cam07 FROM cam_file ,cal_file
                  WHERE cam04=g_sfb.sfb01
                    AND cam06=ecm03_max
                    AND cam012=ecm012_max #FUN-A60095
                    AND YEAR(cam01)=yy
                    AND MONTH(cam01)=mm    #cam01 <= g_edate
                    AND cam01=cal01 AND cam02=cal02
                    AND calfirm = 'Y'
                  GROUP BY cam07
                FOREACH cam_curs8 INTO l_cam07 END FOREACH
                IF l_cam07 IS NULL THEN LET l_cam07 = 0 END IF
                # IF 本張工單的約當量為零->全數轉出
                IF l_cam07 = 0 THEN LET l_cam07 = mccg.ccg31*-1 END IF
                IF mccg.ccg31 !=0 THEN
                  LET l_sharerate = mccg.ccg31 / l_cam07
                  IF l_sharerate IS NULL THEN LET l_sharerate = 0 END IF
                  IF l_sharerate > 0 THEN LET l_sharerate = 0 END IF
                  IF l_sharerate <-1 THEN LET l_sharerate = -1 END IF
                  #if 約當數量=0 時,mcch.cch31 = NUll
                  IF cl_null(mcch.cch31) THEN LET mcch.cch31 = 0 END IF
                  LET mcch.cch31 =(mcch.cch11+mcch.cch21) * l_sharerate * -1
                ELSE
                  #終站轉出量mccg.ccg31=0-->則暫不轉出放在製
                  LET l_sharerate=0
                  LET mcch.cch31 =(mcch.cch11+mcch.cch21) * l_sharerate * -1
                END IF
           WHEN g_ccz.ccz05='2'
                LET mcch.cch31 = mccg.ccg20*mccg.ccg31/mccg.ccg21
           WHEN g_ccz.ccz05='3'
                # 當月如果沒有完工入庫但有人工製費則先不轉出,先放在製
                LET l_sfv09 = 0
                SELECT SUM(sfv09) INTO l_sfv09 FROM sfu_file,sfv_file
                 WHERE sfu01=sfv01 AND sfv11 = g_sfb.sfb01
                   AND sfu00 = '1' AND sfu02 >= g_bdate
                   AND sfu02 <= g_edate AND sfupost='Y'
                IF l_sfv09 > 0 THEN
                   LET mcch.cch31 = (mcch.cch11+mcch.cch21)*-1
                END IF
      END CASE
   END IF
   IF mcch.cch04 = ' ADJUST'    THEN
      LET l_sfa.sfa161 = 1
      LET mcch.cch31 =mccg.ccg31*l_sfa.sfa161
   END IF
 
   LET qty =mcch.cch11+mcch.cch21
   LET cost =0 LET costa=0 LET costb=0 LET costc=0 LET costd=0 LET coste=0
   LET costf=0 LET costg=0 LET costh=0   #FUN-7C0028 add
 
   IF qty !=0 THEN
      LET cost = (mcch.cch12 +mcch.cch22 )/qty
      LET costa= (mcch.cch12a+mcch.cch22a)/qty
      LET costb= (mcch.cch12b+mcch.cch22b)/qty
      LET costc= (mcch.cch12c+mcch.cch22c)/qty
      LET costd= (mcch.cch12d+mcch.cch22d)/qty
      LET coste= (mcch.cch12e+mcch.cch22e)/qty
      LET costf= (mcch.cch12f+mcch.cch22f)/qty   #FUN-7C0028 add
      LET costg= (mcch.cch12g+mcch.cch22g)/qty   #FUN-7C0028 add
      LET costh= (mcch.cch12h+mcch.cch22h)/qty   #FUN-7C0028 add
   END IF
 
   #若當月有轉出,但上月結存+本月投入=0,則單位成本取前期
   IF mcch.cch31 > 0 AND cost=0 THEN
      DECLARE work_4_c2 CURSOR FOR
        SELECT * FROM cch_file
         WHERE cch01=l_cxh01
           AND cch02=last_yy AND cch03=last_mm AND cch04=l_cxh04
           AND cch06=type    AND cch07=g_tlfcost   #FUN-7C0028 add
      FOREACH work_4_c2 INTO last_cch.*
        LET last_qty =last_cch.cch11+last_cch.cch21
        IF last_qty !=0 THEN
           LET cost = (last_cch.cch12 +last_cch.cch22 )/last_qty
           LET costa= (last_cch.cch12a+last_cch.cch22a)/last_qty
           LET costb= (last_cch.cch12b+last_cch.cch22b)/last_qty
           LET costc= (last_cch.cch12c+last_cch.cch22c)/last_qty
           LET costd= (last_cch.cch12d+last_cch.cch22d)/last_qty
           LET coste= (last_cch.cch12e+last_cch.cch22e)/last_qty
           LET costf= (last_cch.cch12f+last_cch.cch22f)/last_qty   #FUN-7C0028 add
           LET costg= (last_cch.cch12g+last_cch.cch22g)/last_qty   #FUN-7C0028 add
           LET costh= (last_cch.cch12h+last_cch.cch22h)/last_qty   #FUN-7C0028 add
        END IF
        IF cost <> 0 THEN
           LET g_msg="工單:",l_cxh01," ",l_cxh04 CLIPPED,
                    " 取前期單位成本"
           LET t_time = TIME
           LET g_time=t_time
          #FUN-A50075--mod--str--ccy_file del plant&legal
          #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
          #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
           INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                         VALUES(TODAY,g_time,g_user,g_msg)
          #FUN-A50075--mod--end
           EXIT FOREACH
        END IF
      END FOREACH
   END IF
 
   ## 若期初+本期無投入,..
   IF (mcch.cch11+mcch.cch21) = 0 THEN LET mcch.cch31 = 0 END IF
 
   ### 若生產=完工入庫套數 則下階料全數轉出 99.02.24 Star
   IF mccg.ccg11+mccg.ccg21+mccg.ccg31=0 AND mccg.ccg31 != 0 THEN
      LET mcch.cch31 = (mcch.cch11+mcch.cch21) * -1
   END IF
 
   LET l_ecm04=' '
  #FUN-A60095(S)
  #SELECT ecm04 INTO l_ecm04 FROM ecm_file
  # WHERE ecm01=g_sfb.sfb01
  #   AND ecm03 = (SELECT MAX(ecm03) FROM ecm_file 
  #                  WHERE ecm01=g_sfb.sfb01)
   LET l_ecm03=NULL
   LET l_ecm012=' '
   CALL s_schdat_max_ecm03(g_sfb.sfb01) RETURNING l_ecm012,l_ecm03
   SELECT ecm04 INTO l_ecm04 FROM ecm_file
    WHERE ecm01=g_sfb.sfb01
      AND ecm012= l_ecm012
      AND ecm03 = l_ecm03   
  #FUN-A60095(E)
   INITIALIZE l_cxh2.* TO NULL
   SELECT SUM(cxh31),
          SUM(cxh32+cxh34),
          SUM(cxh32a + cxh34a), 
          SUM(cxh32b + cxh34b),
          SUM(cxh32c + cxh34c),
          SUM(cxh32d + cxh34d),
          SUM(cxh32e + cxh34e),
          SUM(cxh32f + cxh34f),   #FUN-7C0028 add
          SUM(cxh32g + cxh34g),   #FUN-7C0028 add
          SUM(cxh32h + cxh34h)    #FUN-7C0028 add
     INTO l_cxh2.cxh31,l_cxh2.cxh32,l_cxh2.cxh32a,
          l_cxh2.cxh32b,l_cxh2.cxh32c,l_cxh2.cxh32d,l_cxh2.cxh32e
                       ,l_cxh2.cxh32f,l_cxh2.cxh32g,l_cxh2.cxh32h   #FUN-7C0028 add
     FROM cxh_file
    WHERE cxh01=g_sfb.sfb01
      AND cxh02=yy 
      AND cxh03=mm
      AND cxh06=type        #FUN-7C0028 add
      AND cxh07=g_tlfcost   #FUN-7C0028 add
      AND cxh012=l_ecm04
      AND cxh04 =mcch.cch04 
      AND cxh013=l_ecm012   #FUN-A60095
      AND cxh014=l_ecm03    #FUN-A60095
   IF cl_null(l_cxh2.cxh31  ) THEN LET l_cxh2.cxh31  = 0 END IF
   IF cl_null(l_cxh2.cxh32  ) THEN LET l_cxh2.cxh32  = 0 END IF
   IF cl_null(l_cxh2.cxh32a ) THEN LET l_cxh2.cxh32a = 0 END IF
   IF cl_null(l_cxh2.cxh32b ) THEN LET l_cxh2.cxh32b = 0 END IF
   IF cl_null(l_cxh2.cxh32c ) THEN LET l_cxh2.cxh32c = 0 END IF
   IF cl_null(l_cxh2.cxh32d ) THEN LET l_cxh2.cxh32d = 0 END IF
   IF cl_null(l_cxh2.cxh32e ) THEN LET l_cxh2.cxh32e = 0 END IF
   IF cl_null(l_cxh2.cxh32f ) THEN LET l_cxh2.cxh32f = 0 END IF   #FUN-7C0028 add
   IF cl_null(l_cxh2.cxh32g ) THEN LET l_cxh2.cxh32g = 0 END IF   #FUN-7C0028 add
   IF cl_null(l_cxh2.cxh32h ) THEN LET l_cxh2.cxh32h = 0 END IF   #FUN-7C0028 add
   IF mcch.cch04=' DL+OH+SUB'  THEN
      LET mcch.cch31 =l_cxh2.cxh31
   END IF
   LET mcch.cch32 =l_cxh2.cxh32
   LET mcch.cch32a=l_cxh2.cxh32a
   LET mcch.cch32b=l_cxh2.cxh32b
   LET mcch.cch32c=l_cxh2.cxh32c
   LET mcch.cch32d=l_cxh2.cxh32d
   LET mcch.cch32e=l_cxh2.cxh32e
   LET mcch.cch32f=l_cxh2.cxh32f   #FUN-7C0028 add
   LET mcch.cch32g=l_cxh2.cxh32g   #FUN-7C0028 add
   LET mcch.cch32h=l_cxh2.cxh32h   #FUN-7C0028 add
 
     ##若本期僅發生加工費且完工入庫了.
     ##應要全數轉出,造成有入庫數量但無金額
 
     ##若本期僅發生加工費且完工入庫了. 應要全數轉出
     IF (g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate)
     OR (mccg.ccg11+mccg.ccg21+mccg.ccg31 = 0 AND mccg.ccg31 != 0
     AND mcch.cch04 = ' DL+OH+SUB') THEN
        LET mcch.cch31 =(mcch.cch11 +mcch.cch21 )*-1
        LET mcch.cch32 =(mcch.cch12 +mcch.cch22 )*-1
        LET mcch.cch32a=(mcch.cch12a+mcch.cch22a)*-1
        LET mcch.cch32b=(mcch.cch12b+mcch.cch22b)*-1
        LET mcch.cch32c=(mcch.cch12c+mcch.cch22c)*-1
        LET mcch.cch32d=(mcch.cch12d+mcch.cch22d)*-1
        LET mcch.cch32e=(mcch.cch12e+mcch.cch22e)*-1
        LET mcch.cch32f=(mcch.cch12f+mcch.cch22f)*-1   #FUN-7C0028 add
        LET mcch.cch32g=(mcch.cch12g+mcch.cch22g)*-1   #FUN-7C0028 add
        LET mcch.cch32h=(mcch.cch12h+mcch.cch22h)*-1   #FUN-7C0028 add
     END IF
     LET mcch.cch32 =mcch.cch32a+mcch.cch32b+mcch.cch32c+
                     mcch.cch32d+mcch.cch32e
                    +mcch.cch32f+mcch.cch32g+mcch.cch32h   #FUN-7C0028 add
 
     #ccz09:工單結案在製轉出差異是否轉入主件當期入庫
     IF g_ccz.ccz09 = 'N' THEN
        ## 若當期未轉出即結案 , 則歸差異成本
        IF (g_sfb.sfb38 >= g_bdate AND g_sfb.sfb38 <= g_edate)
           AND mccg.ccg31 = 0 THEN
           LET mcch.cch41 = mcch.cch31
           LET mcch.cch42 = mcch.cch32
           LET mcch.cch42a= mcch.cch32a
           LET mcch.cch42b= mcch.cch32b
           LET mcch.cch42c= mcch.cch32c
           LET mcch.cch42d= mcch.cch32d
           LET mcch.cch42e= mcch.cch32e
           LET mcch.cch42f= mcch.cch32f   #FUN-7C0028 add
           LET mcch.cch42g= mcch.cch32g   #FUN-7C0028 add 
           LET mcch.cch42h= mcch.cch32h   #FUN-7C0028 add
           LET mcch.cch31 = 0
           LET mcch.cch32 = 0
           LET mcch.cch32a= 0
           LET mcch.cch32b= 0
           LET mcch.cch32c= 0
           LET mcch.cch32d= 0
           LET mcch.cch32e= 0
           LET mcch.cch32f= 0   #FUN-7C0028 add
           LET mcch.cch32g= 0   #FUN-7C0028 add
           LET mcch.cch32h= 0   #FUN-7C0028 add
        END IF
     END IF
 
     #--->取半成品
     SELECT SUM(cxh22), SUM(cxh22a),SUM(cxh22b),
            SUM(cxh22c),SUM(cxh22d),SUM(cxh22e)
           ,SUM(cxh22f),SUM(cxh22g),SUM(cxh22h)   #FUN-7C0028 add
       INTO l_cch23,l_cch23a,l_cch23b,l_cch23c,l_cch23d,l_cch23e
                   ,l_cch23f,l_cch23g,l_cch23h    #FUN-7C0028 add
       FROM cxh_file
      WHERE cxh01=l_cxh.cxh01 AND cxh02=l_cxh.cxh02 AND cxh03=l_cxh.cxh03
        AND cxh06=type        AND cxh07=g_tlfcost   #FUN-7C0028 add
        AND cxh05 IN ('M','R')
     IF l_cch23 IS NULL THEN
        LET l_cch23 = 0 LET l_cch23a= 0 LET l_cch23b= 0
        LET l_cch23c= 0 LET l_cch23d= 0 LET l_cch23e= 0
        LET l_cch23f= 0 LET l_cch23g= 0 LET l_cch23h= 0   #FUN-7C0028 add
     END IF
     LET mcch.cch22 =mcch.cch22 -l_cch23
     LET mcch.cch22a=mcch.cch22a-l_cch23a
     LET mcch.cch22b=mcch.cch22b-l_cch23b
     LET mcch.cch22c=mcch.cch22c-l_cch23c
     LET mcch.cch22d=mcch.cch22d-l_cch23d
     LET mcch.cch22e=mcch.cch22e-l_cch23e
     LET mcch.cch22f=mcch.cch22f-l_cch23f   #FUN-7C0028 add
     LET mcch.cch22g=mcch.cch22g-l_cch23g   #FUN-7C0028 add
     LET mcch.cch22h=mcch.cch22h-l_cch23h   #FUN-7C0028 add
 
     #本期僅投入料,累計投入會為零
     IF mcch.cch51=0 THEN
        IF g_sma.sma129 = 'Y' THEN   #FUN-D70038
        #FUN-D70038---begin  remark
        #CHI-D10020---begin mark
           SELECT SUM(sfq03) INTO qty1 FROM sfq_file, sfp_file
            WHERE sfq02=mccg.ccg01 AND sfq01=sfp01
              AND sfp06 IN('1','D') AND sfp04='Y'              #FUN-C70014 sfp06='1' -> sfp06 IN('1','D')
              AND (sfp03 >= g_bdate AND sfp03 <= g_edate)
           SELECT SUM(sfq03) INTO qty2
             FROM sfq_file, sfp_file
            WHERE sfq02=mccg.ccg01 AND sfq01=sfp01 AND sfp06='6' AND sfp04='Y'
              AND (sfp03 >= g_bdate AND sfp03 <= g_edate)
        #CHI-D10020---end    
        ELSE   #FUN-D70038
        #CHI-D10020---begin
           SELECT sfb081 INTO qty1
             FROM sfb_file
            WHERE sfb01 = mccg.ccg01
           SELECT SUM(ccg21) INTO qty2
             FROM ccg_file
            WHERE ccg01 = mccg.ccg01
              AND ((ccg02 = yy AND ccg03 < mm)
               OR (ccg02 < yy))
        #CHI-D10020---end 
        END IF  #FUN-D70038
        IF qty1 IS NULL THEN LET qty1=0 END IF
        IF qty2 IS NULL THEN LET qty2=0 END IF
        LET mcch.cch51=qty1-qty2
     END IF
 
     LET mcch.cch91 =mcch.cch11+mcch.cch21+mcch.cch31+mcch.cch41
     LET mcch.cch92 =mcch.cch12+mcch.cch22+mcch.cch32+mcch.cch42
     LET mcch.cch92a =mcch.cch12a+mcch.cch22a+mcch.cch32a+mcch.cch42a
     LET mcch.cch92b =mcch.cch12b+mcch.cch22b+mcch.cch32b+mcch.cch42b
     LET mcch.cch92c =mcch.cch12c+mcch.cch22c+mcch.cch32c+mcch.cch42c
     LET mcch.cch92d =mcch.cch12d+mcch.cch22d+mcch.cch32d+mcch.cch42d
     LET mcch.cch92e =mcch.cch12e+mcch.cch22e+mcch.cch32e+mcch.cch42e
     LET mcch.cch92f =mcch.cch12f+mcch.cch22f+mcch.cch32f+mcch.cch42f   #FUN-7C0028 add
     LET mcch.cch92g =mcch.cch12g+mcch.cch22g+mcch.cch32g+mcch.cch42g   #FUN-7C0028 add 
     LET mcch.cch92h =mcch.cch12h+mcch.cch22h+mcch.cch32h+mcch.cch42h   #FUN-7C0028 add 
     #03-17 累計轉出 = 累計發料 - 期末在製
     LET mcch.cch53  =  mcch.cch91  - mcch.cch51
     LET mcch.cch54  =  mcch.cch92  - mcch.cch52
     LET mcch.cch54a =  mcch.cch92a - mcch.cch52a
     LET mcch.cch54b =  mcch.cch92b - mcch.cch52b
     LET mcch.cch54c =  mcch.cch92c - mcch.cch52c
     LET mcch.cch54d =  mcch.cch92d - mcch.cch52d
     LET mcch.cch54e =  mcch.cch92e - mcch.cch52e
     LET mcch.cch54f =  mcch.cch92f - mcch.cch52f   #FUN-7C0028 add
     LET mcch.cch54g =  mcch.cch92g - mcch.cch52g   #FUN-7C0028 add
     LET mcch.cch54h =  mcch.cch92h - mcch.cch52h   #FUN-7C0028 add
     LET t_time = TIME
     LET mcch.cchuser=g_user
     LET mcch.cchdate=g_today
     LET mcch.cchtime=g_time
    #LET mcch.cchplant = g_plant #FUN-980009 add    #FUN-A50075
     LET mcch.cchlegal = g_legal #FUN-980009 add
 
     INSERT INTO cch_file VALUES(mcch.*)
     IF (NOT cl_sql_dup_value(SQLCA.SQLCODE)) AND SQLCA.SQLCODE <0 THEN   #TQC-790087
        LET g_msg=l_cxh01,' ',l_cxh04
        LET g_msg=g_msg,' work_4:upd cch' CLIPPED
        LET l_sql="cat ",mcch.*," >> pp.txt"
        LET g_showmsg=mcch.cch01,"/",mcch.cch01                                               #No.FUN-710027  
        CALL s_errmsg('cch01,cch02',g_showmsg,'work_4:upd cch',SQLCA.SQLCODE,1)                      #No.FUN-710027
        RETURN
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
        UPDATE cch_file SET cch_file.* = mcch.*
         WHERE cch01=mcch.cch01 AND cch02=mcch.cch02 AND cch03=mcch.cch03
           AND cch04=mcch.cch04
           AND cch06=mcch.cch06 AND cch07=mcch.cch07   #FUN-7C0028 add
        IF STATUS THEN 
           LET g_showmsg=mcch.cch01,"/",mcch.cch01                                               #No.FUN-710027  
           CALL s_errmsg('cch01,cch02',g_showmsg,'upd cch',SQLCA.SQLCODE,1)                             #No.FUN-710027
           RETURN 
        END IF
     END IF
     SELECT COUNT(*) INTO g_cnt FROM cxh_file
      WHERE cxh01=mcch.cch01 AND cxh02=yy AND cxh03=mm AND cxh04=mcch.cch04
        AND cxh06=type       AND cxh07=g_tlfcost   #FUN-7C0028 add
     IF g_cnt=0 AND
        mcch.cch11 =0 AND mcch.cch12 =0 AND mcch.cch12a=0 AND
        mcch.cch12b=0 AND mcch.cch12c=0 AND mcch.cch12d=0 AND
        mcch.cch12e=0 AND mcch.cch12f=0 AND mcch.cch12g=0 AND mcch.cch12h=0 AND   #FUN-7C0028 add
        mcch.cch21 =0 AND mcch.cch22 =0 AND mcch.cch22a=0 AND
        mcch.cch22b=0 AND mcch.cch22c=0 AND mcch.cch22d=0 AND
        mcch.cch22e=0 AND mcch.cch22f=0 AND mcch.cch22g=0 AND mcch.cch22h=0 AND   #FUN-7C0028 add
        mcch.cch31 =0 AND mcch.cch32 =0 AND mcch.cch32a=0 AND
        mcch.cch32b=0 AND mcch.cch32c=0 AND mcch.cch32d=0 AND
        mcch.cch32e=0 AND mcch.cch32f=0 AND mcch.cch32g=0 AND mcch.cch32h=0 AND   #FUN-7C0028 add
        mcch.cch41 =0 AND mcch.cch42 =0 AND mcch.cch42a=0 AND
        mcch.cch42b=0 AND mcch.cch42c=0 AND mcch.cch42d=0 AND
        mcch.cch42e=0 AND mcch.cch42f=0 AND mcch.cch42g=0 AND mcch.cch42h=0 AND   #FUN-7C0028 add
        mcch.cch91 =0 AND mcch.cch92 =0 AND mcch.cch92a=0 AND
        mcch.cch92b=0 AND mcch.cch92c=0 AND mcch.cch92d=0 AND
        mcch.cch92e=0 AND mcch.cch92f=0 AND mcch.cch92g=0 AND mcch.cch92h=0 THEN  #FUN-7C0028 add
        DELETE FROM cch_file
         WHERE cch01=mcch.cch01 AND cch02=yy AND cch03=mm AND cch04=mcch.cch04
           AND cch06=type       AND cch07=g_tlfcost   #FUN-7C0028 add
     END IF
  END FOREACH
END FUNCTION
 
FUNCTION work_41()  # 計算每張工單的 當站入庫轉出
 DEFINE l_cxh01     LIKE cxh_file.cxh01
 DEFINE l_cxh02     LIKE cxh_file.cxh02
 DEFINE l_cxh03     LIKE cxh_file.cxh03
 DEFINE l_cxh04     LIKE cxh_file.cxh04
 DEFINE l_cxh06     LIKE cxh_file.cxh06    #FUN-7C0028 add
 DEFINE l_cxh07     LIKE cxh_file.cxh07    #FUN-7C0028 add
 DEFINE l_cxh37     LIKE cxh_file.cxh37
 DEFINE l_cxh38     LIKE cxh_file.cxh38
 DEFINE l_cxh38a    LIKE cxh_file.cxh38a
 DEFINE l_cxh38b    LIKE cxh_file.cxh38b
 DEFINE l_cxh38c    LIKE cxh_file.cxh38c
 DEFINE l_cxh38d    LIKE cxh_file.cxh38d
 DEFINE l_cxh38e    LIKE cxh_file.cxh38e
 DEFINE l_cxh38f    LIKE cxh_file.cxh38f   #FUN-7C0028 add
 DEFINE l_cxh38g    LIKE cxh_file.cxh38g   #FUN-7C0028 add
 DEFINE l_cxh38h    LIKE cxh_file.cxh38h   #FUN-7C0028 add
 DEFINE l_caf17     LIKE caf_file.caf17
 
   DECLARE cxh_work_41_cur CURSOR FOR
     SELECT cxh01,cxh02,cxh03,cxh04,cxh06,cxh07,   #FUN-7C0028 add cxh06,07
            SUM(cxh37),SUM(cxh38),
            SUM(cxh38a),SUM(cxh38b),SUM(cxh38c),
            SUM(cxh38d),SUM(cxh38e),
            SUM(cxh38f),SUM(cxh38g),SUM(cxh38h)   #FUN-7C0028 add
       FROM cxh_file
      WHERE cxh01=g_sfb.sfb01
        AND cxh02=yy   AND cxh03=mm
        AND cxh06=type AND cxh07=g_tlfcost   #FUN-7C0028 add
     GROUP BY cxh01,cxh02,cxh03,cxh04,cxh06,cxh07   #FUN-7C0028 add cxh06,07
     ORDER BY cxh01,cxh02,cxh03,cxh04,cxh06,cxh07   #FUN-7C0028 add cxh06,07
   IF STATUS THEN 
      LET g_showmsg=g_sfb.sfb01,"/",yy                                                                #No.FUN-710027 
      CALL s_errmsg('cxh01,cxh02',g_showmsg,'cxh_work_41_cur',STATUS,1)                             #No.FUN-710027 
      LET g_success='N' 
   END IF
   FOREACH cxh_work_41_cur INTO l_cxh01,l_cxh02,l_cxh03,l_cxh04,
                                l_cxh06,l_cxh07,   #FUN-7C0028 add
                                l_cxh37,l_cxh38,
                                l_cxh38a,l_cxh38b,l_cxh38c,l_cxh38d,l_cxh38e
                               ,l_cxh38f,l_cxh38g,l_cxh38h  #FUN-7C0028 add
      IF STATUS THEN 
         CALL s_errmsg('','','cxh_work_41_for',STATUS,0)     #No.FUN-710027
         EXIT FOREACH
      END IF
      IF l_cxh37   IS NULL THEN LET l_cxh37  =0 END IF
      IF l_cxh38   IS NULL THEN LET l_cxh38  =0 END IF
      IF l_cxh38a  IS NULL THEN LET l_cxh38a =0 END IF
      IF l_cxh38b  IS NULL THEN LET l_cxh38b =0 END IF
      IF l_cxh38c  IS NULL THEN LET l_cxh38c =0 END IF
      IF l_cxh38d  IS NULL THEN LET l_cxh38d =0 END IF
      IF l_cxh38e  IS NULL THEN LET l_cxh38e =0 END IF
      IF l_cxh38f  IS NULL THEN LET l_cxh38f =0 END IF   #FUN-7C0028 add
      IF l_cxh38g  IS NULL THEN LET l_cxh38g =0 END IF   #FUN-7C0028 add 
      IF l_cxh38h  IS NULL THEN LET l_cxh38h =0 END IF   #FUN-7C0028 add 
 
      UPDATE cch_file 
         SET cch31 =cch31  + l_cxh37,
             cch32 =cch32  + l_cxh38,
             cch32a=cch32a + l_cxh38a,
             cch32b=cch32b + l_cxh38b,
             cch32c=cch32c + l_cxh38c,
             cch32d=cch32d + l_cxh38d,
             cch32e=cch32e + l_cxh38e,
             cch32f=cch32f + l_cxh38f,   #FUN-7C0028 add
             cch32g=cch32g + l_cxh38g,   #FUN-7C0028 add
             cch32h=cch32h + l_cxh38h,   #FUN-7C0028 add
             cch91 =cch91  + l_cxh37,
             cch92 =cch92  + l_cxh38,
             cch92a=cch92a + l_cxh38a,
             cch92b=cch92b + l_cxh38b,
             cch92c=cch92c + l_cxh38c,
             cch92d=cch92d + l_cxh38d,
             cch92e=cch92e + l_cxh38e,
             cch92f=cch92f + l_cxh38f,   #FUN-7C0028 add
             cch92g=cch92g + l_cxh38g,   #FUN-7C0028 add
             cch92h=cch92h + l_cxh38h    #FUN-7C0028 add 
       WHERE cch01=l_cxh01 AND cch02=l_cxh02 AND cch03=l_cxh03   
         AND cch04=l_cxh04
         AND cch06=l_cxh06 AND cch07=l_cxh07   #FUN-7C0028 add
      IF STATUS THEN 
         LET g_showmsg=l_cxh01,"/",l_cxh02                                                        #No.FUN-710027 
         CALL s_errmsg('cch01,cch02',g_showmsg,'upd cch.*',STATUS,1)                              #No.FUN-710027
         RETURN 
      END IF
   END FOREACH
 
   LET l_caf17=''
   SELECT SUM(caf17*-1) INTO l_caf17 FROM caf_file
    WHERE caf01=g_sfb.sfb01
      AND caf02=yy
      AND caf03=mm
   IF l_caf17 IS NULL THEN LET l_caf17=0 END IF
 
   LET mccg.ccg31=mccg.ccg31+l_caf17
   IF STATUS THEN 
      CALL s_errmsg('','','upd ccg.*:',STATUS,0)  #No.FUN-710027  
      RETURN 
   END IF
END FUNCTION
 
FUNCTION work_5()        # 計算每張工單的 WIP-主件 成本 (ccg)
 SELECT SUM(cch12),SUM(cch12a),SUM(cch12b),SUM(cch12c),SUM(cch12d),SUM(cch12e),
                   SUM(cch12f),SUM(cch12g),SUM(cch12h),   #FUN-7C0028 add
        SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e),
                   SUM(cch22f),SUM(cch22g),SUM(cch22h),   #FUN-7C0028 add
        SUM(cch32),SUM(cch32a),SUM(cch32b),SUM(cch32c),SUM(cch32d),SUM(cch32e),
                   SUM(cch32f),SUM(cch32g),SUM(cch32h),   #FUN-7C0028 add
        SUM(cch42),SUM(cch42a),SUM(cch42b),SUM(cch42c),SUM(cch42d),SUM(cch42e),
                   SUM(cch42f),SUM(cch42g),SUM(cch42h),   #FUN-7C0028 add
        SUM(cch92),SUM(cch92a),SUM(cch92b),SUM(cch92c),SUM(cch92d),SUM(cch92e)
                  ,SUM(cch92f),SUM(cch92g),SUM(cch92h)    #FUN-7C0028 add
   INTO mccg.ccg12,mccg.ccg12a,mccg.ccg12b,mccg.ccg12c,mccg.ccg12d,mccg.ccg12e,
                   mccg.ccg12f,mccg.ccg12g,mccg.ccg12h,   #FUN-7C0028 add
        mccg.ccg22,mccg.ccg22a,mccg.ccg22b,mccg.ccg22c,mccg.ccg22d,mccg.ccg22e,
                   mccg.ccg22f,mccg.ccg22g,mccg.ccg22h,   #FUN-7C0028 add
        mccg.ccg32,mccg.ccg32a,mccg.ccg32b,mccg.ccg32c,mccg.ccg32d,mccg.ccg32e,
                   mccg.ccg32f,mccg.ccg32g,mccg.ccg32h,   #FUN-7C0028 add
        mccg.ccg42,mccg.ccg42a,mccg.ccg42b,mccg.ccg42c,mccg.ccg42d,mccg.ccg42e,
                   mccg.ccg42f,mccg.ccg42g,mccg.ccg42h,   #FUN-7C0028 add
        mccg.ccg92,mccg.ccg92a,mccg.ccg92b,mccg.ccg92c,mccg.ccg92d,mccg.ccg92e
                  ,mccg.ccg92f,mccg.ccg92g,mccg.ccg92h    #FUN-7C0028 add
   FROM cch_file
  WHERE cch01=g_sfb.sfb01 AND cch02=yy AND cch03=mm
    AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
 IF mccg.ccg12 IS NULL THEN
    LET mccg.ccg12 = 0 LET mccg.ccg12a= 0 LET mccg.ccg12b= 0
    LET mccg.ccg12c= 0 LET mccg.ccg12d= 0 LET mccg.ccg12e= 0
    LET mccg.ccg12f= 0 LET mccg.ccg12g= 0 LET mccg.ccg12h= 0   #FUN-7C0028 add
    LET mccg.ccg22 = 0 LET mccg.ccg22a= 0 LET mccg.ccg22b= 0
    LET mccg.ccg22c= 0 LET mccg.ccg22d= 0 LET mccg.ccg22e= 0
    LET mccg.ccg22f= 0 LET mccg.ccg22g= 0 LET mccg.ccg22h= 0   #FUN-7C0028 add
    LET mccg.ccg32 = 0 LET mccg.ccg32a= 0 LET mccg.ccg32b= 0
    LET mccg.ccg32c= 0 LET mccg.ccg32d= 0 LET mccg.ccg32e= 0
    LET mccg.ccg32f= 0 LET mccg.ccg32g= 0 LET mccg.ccg32h= 0   #FUN-7C0028 add
    LET mccg.ccg42 = 0 LET mccg.ccg42a= 0 LET mccg.ccg42b= 0
    LET mccg.ccg42c= 0 LET mccg.ccg42d= 0 LET mccg.ccg42e= 0
    LET mccg.ccg42f= 0 LET mccg.ccg42g= 0 LET mccg.ccg42h= 0   #FUN-7C0028 add
    LET mccg.ccg92 = 0 LET mccg.ccg92a= 0 LET mccg.ccg92b= 0
    LET mccg.ccg92c= 0 LET mccg.ccg92d= 0 LET mccg.ccg92e= 0
    LET mccg.ccg92f= 0 LET mccg.ccg92g= 0 LET mccg.ccg92h= 0   #FUN-7C0028 add 
 END IF
 
 #--->取半成品
 SELECT SUM(cch22),SUM(cch22a),SUM(cch22b),SUM(cch22c),SUM(cch22d),SUM(cch22e)
                  ,SUM(cch22f),SUM(cch12g),SUM(cch12h)   #FUN-7C0028 add
   INTO mccg.ccg23,mccg.ccg23a,mccg.ccg23b,mccg.ccg23c,mccg.ccg23d,mccg.ccg23e
                  ,mccg.ccg23f,mccg.ccg23g,mccg.ccg23h   #FUN-7C0028 add 
     FROM cch_file
   WHERE cch01=g_cch.cch01 AND cch02=g_cch.cch02 AND cch03=g_cch.cch03
     AND cch06=type        AND cch07=g_tlfcost   #FUN-7C0028 add
     AND cch05 IN ('M','R')
     IF mccg.ccg23 IS NULL THEN
        LET mccg.ccg23 = 0 LET mccg.ccg23a= 0 LET mccg.ccg23b= 0
        LET mccg.ccg23c= 0 LET mccg.ccg23d= 0 LET mccg.ccg23e= 0
　　    LET mccg.ccg23f= 0 LET mccg.ccg23g= 0 LET mccg.ccg23h= 0   #FUN-7C0028 add 
     END IF
     LET mccg.ccg22 =mccg.ccg22 -mccg.ccg23
     LET mccg.ccg22a=mccg.ccg22a-mccg.ccg23a
     LET mccg.ccg22b=mccg.ccg22b-mccg.ccg23b
     LET mccg.ccg22c=mccg.ccg22c-mccg.ccg23c
     LET mccg.ccg22d=mccg.ccg22d-mccg.ccg23d
     LET mccg.ccg22e=mccg.ccg22e-mccg.ccg23e
     LET mccg.ccg22f=mccg.ccg22f-mccg.ccg23f   #FUN-7C0028 add
　　 LET mccg.ccg22g=mccg.ccg22g-mccg.ccg23g   #FUN-7C0028 add
　　 LET mccg.ccg22h=mccg.ccg22h-mccg.ccg23h   #FUN-7C0028 add 
     LET mccg.ccg91 =mccg.ccg11 + mccg.ccg21 + mccg.ccg31 + mccg.ccg41
     LET t_time = TIME
     LET mccg.ccguser=g_user LET mccg.ccgdate=TODAY LET mccg.ccgtime=t_time
     UPDATE ccg_file SET ccg_file.* = mccg.*
      WHERE ccg01=mccg.ccg01 AND ccg02=mccg.ccg02 AND ccg03=mccg.ccg03
        AND ccg06=mccg.ccg06 AND ccg07=mccg.ccg07   #FUN-7C0028 add 
     IF STATUS THEN 
        LET g_showmsg=mccg.ccg01,"/",mccg.ccg02                                                         #No.FUN-710027                                  
        CALL s_errmsg('ccg01,ccg02',g_showmsg,'upd ccg.*',STATUS,1)                                     #No.FUN-710027
        RETURN 
     END IF
 
     SELECT COUNT(*) INTO g_cnt FROM cch_file
      WHERE cch01=mccg.ccg01 AND cch02=yy AND cch03=mm
        AND cch06=type       AND cch07=g_tlfcost   #FUN-7C0028 add
     IF g_cnt=0 AND
　　    mccg.ccg11 =0 AND mccg.ccg12 =0 AND mccg.ccg12a=0 AND
        mccg.ccg12b=0 AND mccg.ccg12c=0 AND mccg.ccg12d=0 AND
　　    mccg.ccg12e=0 AND mccg.ccg12f=0 AND mccg.ccg12g=0 AND mccg.ccg12h=0 AND   #FUN-7C0028 add 
        mccg.ccg20=0 AND
　　    mccg.ccg21 =0 AND mccg.ccg22 =0 AND mccg.ccg22a=0 AND
        mccg.ccg22b=0 AND mccg.ccg22c=0 AND mccg.ccg22d=0 AND
　　    mccg.ccg22e=0 AND mccg.ccg22f=0 AND mccg.ccg22g=0 AND mccg.ccg22h=0 AND   #FUN-7C0028 add 
　　    mccg.ccg23 =0 AND mccg.ccg23a=0 AND mccg.ccg23b=0 AND
        mccg.ccg23c=0 AND mccg.ccg23d=0 AND
　　    mccg.ccg23e=0 AND mccg.ccg23f=0 AND mccg.ccg23g=0 AND mccg.ccg23h=0 AND   #FUN-7C0028 add
　　    mccg.ccg31 =0 AND mccg.ccg32 =0 AND mccg.ccg32a=0 AND
        mccg.ccg32b=0 AND mccg.ccg32c=0 AND mccg.ccg32d=0 AND
　　    mccg.ccg32e=0 AND mccg.ccg32f=0 AND mccg.ccg32g=0 AND mccg.ccg32h=0 AND   #FUN-7C0028 add 
　　    mccg.ccg41 =0 AND mccg.ccg42 =0 AND mccg.ccg42a=0 AND
        mccg.ccg42b=0 AND mccg.ccg42c=0 AND mccg.ccg42d=0 AND
　　    mccg.ccg42e=0 AND mccg.ccg42f=0 AND mccg.ccg42g=0 AND mccg.ccg42h=0 AND   #FUN-7C0028 add 
　　    mccg.ccg91 =0 AND mccg.ccg92 =0 AND mccg.ccg92a=0 AND
        mccg.ccg92b=0 AND mccg.ccg92c=0 AND mccg.ccg92d=0 AND
        mccg.ccg92e=0 AND mccg.ccg92f=0 AND mccg.ccg92g=0 AND mccg.ccg92h=0 THEN  #FUN-7C0028 add 
        DELETE FROM ccg_file
        WHERE ccg01=mccg.ccg01 AND ccg02=yy AND ccg03=mm
          AND ccg06=type       AND ccg07=g_tlfcost   #FUN-7C0028 add
     END IF
END FUNCTION
 
# 記錄拆件式工單的投入及拆件轉出
FUNCTION p510_wipx()     # 處理 WIP 在製成本 (工單性質=1/7)
   DEFINE l_cnt LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_sql STRING                       #FUN-7C0028 add
 
   CALL wipx_del()       # 先 delete cct_file, ccu_file 該主件相關資料
 
   LET l_sql="SELECT * FROM sfb_file",
             " WHERE sfb05 ='",g_ima01,"'",
             "   AND sfb02 ='11'",
             "   AND (sfb38 IS NULL OR sfb38 >='",g_bdate,"')",  # 工單成會結案日
             "   AND (sfb81 IS NULL OR sfb81 <='",g_edate,"')"   # 工單xx立日期
   IF type = '4' THEN   #個別認定-專案成本
      LET l_sql=l_sql,"   AND sfb27='",g_tlfcost,"'"
   END IF
   LET l_sql=l_sql," ORDER BY sfb01"
   DECLARE wipx_c1 CURSOR FROM l_sql
 
   LET l_cnt = 0
   FOREACH wipx_c1 INTO g_sfb.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('wipx_c1',SQLCA.sqlcode,0)
        EXIT FOREACH
     END IF
     LET l_cnt =l_cnt + 1
     CALL wipx_1()       # 計算每張工單的 WIP-主件 部份 成本 (cct)
     CALL wipx_2()       # 計算每張工單的 WIP-元件 投入 成本 (ccu)
     CALL wipx_3()       # 計算每張工單的 WIP-元件 轉出 成本 (ccu)
     CALL wipx_4()       # 計算每張工單的 WIP-主件 SUM  成本 (cct)
   END FOREACH
   CLOSE wipx_c1
   IF l_cnt > 0 THEN
      CALL p510_ccc_tot('2')    # 計算所有出庫成本及結存
      CALL p510_ckp_ccc() #MOD-4A0263 CHECK ccc_file做NOT NULL欄位的判斷
      CALL p510_ccc_upd()       # Update ccc_file
   END IF
END FUNCTION
 
FUNCTION wipx_del()
   DEFINE wo_no        LIKE cct_file.cct01          #No.FUN-680122 VARCHAR(16)   #No.FUN-550025
   DECLARE p110_wipx_del_c1 CURSOR FOR
      SELECT cct01 FROM cct_file
       WHERE cct04=g_ima01 AND cct02=yy AND cct03=mm
         AND cct06=type    AND cct07=g_tlfcost   #FUN-7C0028 add 
   FOREACH p110_wipx_del_c1 INTO wo_no
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','p110_wipx_del_c1',SQLCA.sqlcode,0) #No.FUN-710027
        EXIT FOREACH
     END IF
     DELETE FROM ccu_file WHERE ccu01=wo_no AND ccu02=yy AND ccu03=mm
                            AND ccu06=type  AND ccu07=g_tlfcost   #FUN-7C0028 add 
     DELETE FROM cct_file WHERE cct01=wo_no AND cct02=yy AND cct03=mm
                            AND cct06=type  AND cct07=g_tlfcost   #FUN-7C0028 add 
   END FOREACH
   CLOSE p110_wipx_del_c1
END FUNCTION
 
FUNCTION wipx_1()        # 計算每張拆件式工單的 WIP-主件 部份 成本 (cct)
   CALL p510_mcct_0()   # 將 mcct 歸 0
   LET mcct.cct01 =g_sfb.sfb01
   LET mcct.cct02 =yy
   LET mcct.cct03 =mm
   LET mcct.cct04 =g_sfb.sfb05
   LET mcct.cct06 =type        #FUN-7C0028 add
   LET mcct.cct07 =g_tlfcost   #FUN-7C0028 add 
   CALL wipx_cct20()     # 工時統計
  #LET mcct.cctplant = g_plant #FUN-980009 add    #FUN-A50075
   LET mcct.cctlegal = g_legal #FUN-980009 add
   LET mcct.cctoriu = g_user      #No.FUN-980030 10/01/04
   LET mcct.cctorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO cct_file VALUES (mcct.*)
   IF STATUS THEN 
      LET g_showmsg=mcct.cct01,"/",mcct.cct02                                                         #No.FUN-710027
      CALL s_errmsg('cct01,cct02',g_showmsg,'ins cct:',STATUS,1)                                      #No.FUN-710027
      RETURN 
   END IF
END FUNCTION
 
FUNCTION wipx_cct20()    # 工時統計
   SELECT SUM(cam08) INTO mcct.cct20 FROM cam_file      # 工時統計
    WHERE cam04=g_sfb.sfb01 AND cam01 BETWEEN g_bdate AND g_edate
   IF mcct.cct20 IS NULL THEN LET mcct.cct20=0 END IF
END FUNCTION
 
FUNCTION wipx_2()    # 計算每張拆件式工單的 WIP-元件'期初,本期投入'成本 (ccu)
   CALL wipx_2_1()   # step 1. WIP-元件 上期期末轉本期期初
   CALL wipx_2_21()  # step 2-1. WIP-元件 本期投入材料 (依拆件式工單發料/退料檔)
   CALL wipx_2_22()  # step 2-2. WIP-元件 本期投入人工製費
   CALL wipx_2_23()  # step 2-3. WIP-元件 本期投入調整成本
END FUNCTION
 
FUNCTION wipx_2_1()      #  1. WIP-元件 上期期末轉本期期初
   DEFINE l_cxf         RECORD LIKE cxf_file.*
   DECLARE wipx_c2 CURSOR FOR SELECT * FROM ccu_file
     WHERE ccu01=g_sfb.sfb01 AND ccu02=last_yy AND ccu03=last_mm
       AND ccu06=type        AND ccu07=g_tlfcost   #FUN-7C0028 add 
   FOREACH wipx_c2 INTO g_ccu.*
      CALL p510_ccu_0()  # 上期期末轉本期期初, 將 ccu 歸 0
      LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
      LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO ccu_file VALUES (g_ccu.*)
      IF STATUS THEN 
         LET g_showmsg = g_ccu.ccu01,"/",g_ccu.ccu02                                                         #No.FUN-710027
         CALL s_errmsg('ccu01,ccu02',g_showmsg,'ins ccu(1):',STATUS,1)                                       #No.FUN-710027
      END IF
   END FOREACH
   CLOSE wipx_c2
 
   DECLARE wipx_c2_cxf CURSOR FOR        # WIP-元件 期初xx帳轉本期期初
    SELECT * FROM cxf_file
     WHERE cxf01=g_sfb.sfb01 AND cxf02=last_yy AND cxf03=last_mm
       AND cxf06=type        AND cxf07=g_tlfcost   #FUN-7C0028 add 
       AND (cxf04!=' ' AND cxf04 IS NOT NULL)
   FOREACH wipx_c2_cxf INTO l_cxf.*
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','wipx_c2_cxf',SQLCA.sqlcode,0)  #No.FUN-710027
         EXIT FOREACH
      END IF
      CALL p510_ccu_01() # 將 ccu 歸 0
      LET g_ccu.ccu01 =g_sfb.sfb01
      LET g_ccu.ccu02 =yy
　　  LET g_ccu.ccu03 =mm
      LET g_ccu.ccu04 =l_cxf.cxf04
      LET g_ccu.ccu05 =l_cxf.cxf05
      LET g_ccu.ccu06 =type          #FUN-7C0028 add
      LET g_ccu.ccu07 =l_cxf.cxf07   #FUN-7C0028 add 
      LET g_ccu.ccu11 =l_cxf.cxf11
      LET g_ccu.ccu12 =l_cxf.cxf12
      LET g_ccu.ccu12a=l_cxf.cxf12a
      LET g_ccu.ccu12b=l_cxf.cxf12b
      LET g_ccu.ccu12c=l_cxf.cxf12c
      LET g_ccu.ccu12d=l_cxf.cxf12d
      LET g_ccu.ccu12e=l_cxf.cxf12e
      LET g_ccu.ccu12f=l_cxf.cxf12f   #FUN-7C0028 add
      LET g_ccu.ccu12g=l_cxf.cxf12g   #FUN-7C0028 add
      LET g_ccu.ccu12h=l_cxf.cxf12h   #FUN-7C0028 add 
     #LET g_ccu.ccuplant = g_plant #FUN-980009 add    #FUN-A50075
      LET g_ccu.cculegal = g_legal #FUN-980009 add
 
      INSERT INTO ccu_file VALUES (g_ccu.*)
      IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
         LET g_showmsg=g_ccu.ccu01,"/",g_ccu.ccu02                                                                  #No.FUN-710027
         CALL s_errmsg('ccu01,ccu02',g_showmsg,'wipx_2_1() ins ccu:',SQLCA.SQLCODE,1)                                      #No.FUN-710027
      END IF
      IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
         UPDATE ccu_file SET ccu_file.*=g_ccu.*
          WHERE ccu01=g_sfb.sfb01 AND ccu02=yy AND ccu03=mm
            AND ccu04=l_cxf.cxf04
            AND ccu06=g_ccu.ccu06 AND ccu07=g_ccu.ccu07   #FUN-7C0028 add 
         IF SQLCA.SQLCODE THEN 
            LET g_showmsg= g_sfb.sfb01,"/",yy                                  #No.FUN-710027
            CALL s_errmsg('ccu01,ccu02',g_showmsg,'upd ccu(2):',SQLCA.SQLCODE,1)      #No.FUN-710027
         END IF
      END IF
   END FOREACH
   CLOSE wipx_c2_cxf
END FUNCTION
 
FUNCTION wipx_2_21()   #  2-1. WIP-元件 本期投入拆件品(依拆件式工單發料/退料檔)
   DEFINE l_ima08               LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   DEFINE l_ima57               LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_tlf01               LIKE tlf_file.tlf01  #No.MOD-490217
   DEFINE l_tlf02,l_tlf03       LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_tlf10               LIKE tlf_file.tlf10          #No.FUN-680122 DEC(15,3) #TQC-840066
   DEFINE l_c21                 LIKE cmc_file.cmc04          #No.FUN-680122 DEC(15,5)
   DEFINE l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e LIKE type_file.num20_6       #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                     LIKE type_file.num20_6       #FUN-7C0028 add 
   DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e LIKE type_file.num20_6       #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                     LIKE type_file.num20_6    #FUN-7C0028 add 
   DEFINE l_tlf62               LIKE tlf_file.tlf62
   DEFINE l_sfa161              LIKE sfa_file.sfa161
 
   DECLARE wipx_c3 CURSOR FOR
     SELECT tlf01,ima08,ima57,tlf02,tlf03,SUM(tlf10*tlf60*tlf907*-1)
      FROM tlf_file LEFT OUTER JOIN ima_file ON tlf01=ima01
     WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
       AND ((tlf02=50 AND tlf03 BETWEEN 60 AND 69) OR
           (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
       AND tlf13 NOT MATCHES 'asft6*'
       AND tlf907 != 0
       AND tlfcost=g_tlfcost   #FUN-7C0028 add
     GROUP BY tlf01,ima08,ima57,tlf02,tlf03
   FOREACH wipx_c3 INTO l_tlf01,l_ima08,l_ima57,l_tlf02,l_tlf03,l_tlf10
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','wipx_c3',SQLCA.sqlcode,0) #No.FUN-710027
        EXIT FOREACH
     END IF
     IF l_ima08 IS NULL THEN LET l_ima08='P' END IF
     IF l_tlf01=g_sfb.sfb05 THEN LET l_ima08='R' END IF #主/元料號同表重工
     IF l_ima57 = g_ima57_t THEN LET l_ima08='R' END IF #成本階相等表重工
     IF l_ima57 < g_ima57_t THEN LET l_ima08='W' END IF #成本階較低表上階重工
     LET l_c23=0
     LET l_c23a=0 LET l_c23b=0 LET l_c23c=0 LET l_c23d=0 LET l_c23e=0
     LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add 
 
     CASE                        # 取發料單價
      WHEN l_ima08 MATCHES '[W]' # (上階重工者取上月庫存月平均)
           SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                  ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
             INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                  l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h 
             FROM ccc_file
            WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
              AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
           LET g_msg="拆件式工單:",g_sfb.sfb01," 上階重工..取上期單價"
           LET t_time = TIME
           LET g_time=t_time
          #FUN-A50075--mod--str--  ccy_file del plant&legal
          #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
          #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
           INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                         VALUES(TODAY,g_time,g_user,g_msg)
          #FUN-A50075--mod--end
      WHEN l_ima08 MATCHES '[R]' # (本階重工者取重工前庫存月平均)
           SELECT ccc12a+ccc22a, ccc12b+ccc22b, ccc12c+ccc22c,
                  ccc12d+ccc22d, ccc12e+ccc22e,
                  ccc12f+ccc22f, ccc12g+ccc22g, ccc12h+ccc22h,   #FUN-7C0028 add
                  ccc12 +ccc22 , ccc11 +ccc21
             INTO l_c22a,l_c22b,l_c22c,l_c22d,l_c22e
                               ,l_c22f,l_c22g,l_c22h   #FUN-7C0028 add
　　　　　 　　　　　　　　　　,l_c22,l_c21
             FROM ccc_file
            WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
              AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
           IF l_c21 = 0 OR l_c21 IS NULL THEN
              LET l_c23a=0 LET l_c23b=0 LET l_c23c=0
              LET l_c23d=0 LET l_c23e=0 LET l_c23 =0
              LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
           ELSE 
              LET l_c23a=l_c22a/l_c21
              LET l_c23b=l_c22b/l_c21
              LET l_c23c=l_c22c/l_c21
              LET l_c23d=l_c22d/l_c21
              LET l_c23e=l_c22e/l_c21
              LET l_c23f=l_c22f/l_c21   #FUN-7C0028 add
              LET l_c23g=l_c22g/l_c21   #FUN-7C0028 add
              LET l_c23h=l_c22h/l_c21   #FUN-7C0028 add
              LET l_c23 =l_c22 /l_c21
           END IF
 
           # (無單價再取上月庫存月平均)
           IF l_c23a=0 AND l_c23b=0 AND l_c23c=0 AND l_c23d=0
          AND l_c23e=0 AND l_c23f=0 AND l_c23g=0 AND l_c23h=0 THEN   #FUN-7C0028 add 
              SELECT cca23a,cca23b,cca23c,cca23d,cca23e,
                     cca23f,cca23g,cca23h,cca23   #FUN-7C0028 add cca23f,g,h
                INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                     l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h 
                FROM cca_file
               WHERE cca01=l_tlf01 AND cca02=last_yy AND cca03=last_mm
                 AND cca06=type    AND cca07=g_tlfcost   #FUN-7C0028 add 
              #若上期仍無單價, 則取上期xx帳單價
              IF SQLCA.sqlcode
              OR (l_c23a=0 AND l_c23b=0 AND l_c23c=0 AND l_c23d=0
              AND l_c23e=0 AND l_c23f=0 AND l_c23g=0 AND l_c23h=0) THEN   #FUN-7C0028 add 
                 SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                        ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
                   INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                        l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h 
                   FROM ccc_file
                  WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
                    AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
              END IF
           END IF
      OTHERWISE                   # (取當月庫存月平均檔)
           SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
                  ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
             INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
                  l_c23f,l_c23g,l_c23h,l_c23   #FUN-7C0028 add l_c23f,g,h 
             FROM ccc_file
            WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
              AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
     END CASE
     CALL p510_ccu_01() # 將 ccu 歸 0
 
     LET g_ccu.ccu01 =g_sfb.sfb01
     LET g_ccu.ccu04 =l_tlf01
     LET g_ccu.ccu06 =type        #FUN-7C0028 add
     LET g_ccu.ccu07 =g_tlfcost   #FUN-7C0028 add 
     IF l_ima08 = 'W' THEN LET l_ima08='R' END IF
     LET g_ccu.ccu05 =l_ima08
     LET g_ccu.ccu21 =l_tlf10
     LET g_ccu.ccu22a=l_tlf10*l_c23a
     LET g_ccu.ccu22b=l_tlf10*l_c23b
     LET g_ccu.ccu22c=l_tlf10*l_c23c
     LET g_ccu.ccu22d=l_tlf10*l_c23d
     LET g_ccu.ccu22e=l_tlf10*l_c23e
     LET g_ccu.ccu22f=l_tlf10*l_c23f   #FUN-7C0028 add
     LET g_ccu.ccu22g=l_tlf10*l_c23g   #FUN-7C0028 add
     LET g_ccu.ccu22h=l_tlf10*l_c23h   #FUN-7C0028 add 
     LET g_ccu.ccu22 =g_ccu.ccu22a+g_ccu.ccu22b+g_ccu.ccu22c+
                      g_ccu.ccu22d+g_ccu.ccu22e
                     +g_ccu.ccu22f+g_ccu.ccu22g+g_ccu.ccu22h   #FUN-7C0028 add 
 
     #判斷有無結案, 若結案則歸差異成本
     IF g_sfb.sfb38 IS NOT NULL AND g_sfb.sfb38 >= g_bdate
    AND g_sfb.sfb38 <= g_edate THEN
        LET g_ccu.ccu41 = (g_ccu.ccu11 + g_ccu.ccu21 + g_ccu.ccu31)*-1
        LET g_ccu.ccu42 = (g_ccu.ccu12 + g_ccu.ccu22 + g_ccu.ccu32 )*-1
        LET g_ccu.ccu42a= (g_ccu.ccu12a+ g_ccu.ccu22a+ g_ccu.ccu32a)*-1
        LET g_ccu.ccu42b= (g_ccu.ccu12b+ g_ccu.ccu22b+ g_ccu.ccu32b)*-1
        LET g_ccu.ccu42c= (g_ccu.ccu12c+ g_ccu.ccu22c+ g_ccu.ccu32c)*-1
        LET g_ccu.ccu42d= (g_ccu.ccu12d+ g_ccu.ccu22d+ g_ccu.ccu32d)*-1
        LET g_ccu.ccu42e= (g_ccu.ccu12e+ g_ccu.ccu22e+ g_ccu.ccu32e)*-1
        LET g_ccu.ccu42f= (g_ccu.ccu12f+ g_ccu.ccu22f+ g_ccu.ccu32f)*-1   #FUN-7C0028 add
        LET g_ccu.ccu42g= (g_ccu.ccu12g+ g_ccu.ccu22g+ g_ccu.ccu32g)*-1   #FUN-7C0028 add
        LET g_ccu.ccu42h= (g_ccu.ccu12h+ g_ccu.ccu22h+ g_ccu.ccu32h)*-1   #FUN-7C0028 add 
        LET g_ccu.ccu91 = 0
        LET g_ccu.ccu92a= 0
        LET g_ccu.ccu92b= 0
        LET g_ccu.ccu92c= 0
        LET g_ccu.ccu92d= 0
        LET g_ccu.ccu92e= 0
        LET g_ccu.ccu92f= 0   #FUN-7C0028 add
        LET g_ccu.ccu92g= 0   #FUN-7C0028 add
        LET g_ccu.ccu92h= 0   #FUN-7C0028 add 
     ELSE
        LET g_ccu.ccu91 = g_ccu.ccu11 + g_ccu.ccu21 + g_ccu.ccu31
        LET g_ccu.ccu92 = g_ccu.ccu12 + g_ccu.ccu22 + g_ccu.ccu32
        LET g_ccu.ccu92a= g_ccu.ccu12a+ g_ccu.ccu22a+ g_ccu.ccu32a
        LET g_ccu.ccu92b= g_ccu.ccu12b+ g_ccu.ccu22b+ g_ccu.ccu32b
        LET g_ccu.ccu92c= g_ccu.ccu12c+ g_ccu.ccu22c+ g_ccu.ccu32c
        LET g_ccu.ccu92d= g_ccu.ccu12d+ g_ccu.ccu22d+ g_ccu.ccu32d
        LET g_ccu.ccu92e= g_ccu.ccu12e+ g_ccu.ccu22e+ g_ccu.ccu32e
        LET g_ccu.ccu92f= g_ccu.ccu12f+ g_ccu.ccu22f+ g_ccu.ccu32f   #FUN-7C0028 add
        LET g_ccu.ccu92g= g_ccu.ccu12g+ g_ccu.ccu22g+ g_ccu.ccu32g   #FUN-7C0028 add
        LET g_ccu.ccu92g= g_ccu.ccu12h+ g_ccu.ccu22h+ g_ccu.ccu32h   #FUN-7C0028 add 
        LET g_ccu.ccu41 = 0
        LET g_ccu.ccu42a= 0
        LET g_ccu.ccu42b= 0
        LET g_ccu.ccu42c= 0
        LET g_ccu.ccu42d= 0
        LET g_ccu.ccu42e= 0
        LET g_ccu.ccu42f= 0   #FUN-7C0028 add
        LET g_ccu.ccu42g= 0   #FUN-7C0028 add
        LET g_ccu.ccu42h= 0   #FUN-7C0028 add 
     END IF
 
    #LET g_ccu.ccuplant = g_plant #FUN-980009 add    #FUN-A50075
     LET g_ccu.cculegal = g_legal #FUN-980009 add
     LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
     LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO ccu_file VALUES(g_ccu.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
        LET g_showmsg=g_ccu.ccu01,"/",g_ccu.ccu02                                                                   #No.FUN-710027 
        CALL s_errmsg('ccu01,ccu02',g_showmsg,'wipx_2_21() ins ccu:',SQLCA.SQLCODE,1)                                      #No.FUN-710027
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
        UPDATE ccu_file SET ccu21=ccu21+g_ccu.ccu21,
                            ccu22=ccu22+g_ccu.ccu22,
                            ccu22a=ccu22a+g_ccu.ccu22a,
                            ccu22b=ccu22b+g_ccu.ccu22b,
                            ccu22c=ccu22c+g_ccu.ccu22c,
                            ccu22d=ccu22d+g_ccu.ccu22d,
                            ccu22e=ccu22e+g_ccu.ccu22e,
                            ccu22f=ccu22f+g_ccu.ccu22f,   #FUN-7C0028 add
                            ccu22g=ccu22g+g_ccu.ccu22g,   #FUN-7C0028 add
                            ccu22h=ccu22h+g_ccu.ccu22h    #FUN-7C0028 add 
            WHERE ccu01=g_sfb.sfb01 AND ccu02=yy AND ccu03=mm
              AND ccu06=g_ccu.ccu06 AND ccu07=g_ccu.ccu07   #FUN-7C0028 add 
              AND ccu04=l_tlf01
     END IF
   END FOREACH
   CLOSE wipx_c3
END FUNCTION
 
FUNCTION wipx_2_22()     #  2-2. WIP-元件 本期投入人工製費
 DEFINE l_dept  LIKE sfb_file.sfb98          #No.FUN-680122 VARCHAR(10)
 
   CALL p510_ccu_01()   # 將 ccu 歸 0
   LET g_ccu.ccu01 =g_sfb.sfb01
   LET g_ccu.ccu04 =' DL+OH+SUB'        # 料號為 ' DL+OH+SUB'
   LET g_ccu.ccu05 ='P'
   LET g_ccu.ccu06 =type        #FUN-7C0028 add
   LET g_ccu.ccu07 =g_tlfcost   #FUN-7C0028 add 
   LET g_ccu.ccu21 =mcct.cct20
   IF g_ccz.ccz06 = '1' OR g_ccz.ccz06 = '2' THEN LET l_dept = g_sfb.sfb98 END IF
 
   SELECT * INTO g_cck.* FROM cck_file WHERE cck01=yy AND cck02=mm
                                         AND cck_w = l_dept
   IF g_cck.cck05 > 0 THEN
      LET g_ccu.ccu22b=mcct.cct20*g_cck.cck03/g_cck.cck05       # 人工成本
      LET g_ccu.ccu22c=mcct.cct20*g_cck.cck04/g_cck.cck05       # 製費成本
   END IF
   LET g_ccu.ccu22=g_ccu.ccu22b+g_ccu.ccu22c+g_ccu.ccu22d
   IF g_ccu.ccu22 = 0 THEN LET g_ccu.ccu21 = 0 RETURN END IF
  #LET g_ccu.ccuplant = g_plant #FUN-980009 add    #FUN-A50075
   LET g_ccu.cculegal = g_legal #FUN-980009 add
   LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
   LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ccu_file VALUES(g_ccu.*)
   IF STATUS THEN                     # 可能有上期轉入資料造成重複
      UPDATE ccu_file SET ccu21=ccu21+g_ccu.ccu21,
                          ccu22=ccu22+g_ccu.ccu22,
                          ccu22b=ccu22b+g_ccu.ccu22b,
                          ccu22c=ccu22c+g_ccu.ccu22c,
                          ccu22d=ccu22d+g_ccu.ccu22d,
                          ccu22e=ccu22e+g_ccu.ccu22e,   #FUN-7C0028 add
                          ccu22f=ccu22f+g_ccu.ccu22f,   #FUN-7C0028 add
                          ccu22g=ccu22g+g_ccu.ccu22g,   #FUN-7C0028 add
                          ccu22h=ccu22h+g_ccu.ccu22h    #FUN-7C0028 add 
       WHERE ccu01=g_ccu.ccu01 AND ccu02=yy AND ccu03=mm
         AND ccu06=g_ccu.ccu06 AND ccu07=g_ccu.ccu07   #FUN-7C0028 add 
         AND ccu04=g_ccu.ccu04
   END IF
END FUNCTION
 
FUNCTION wipx_2_23()     #  2-3. WIP-元件 本期投入調整成本
   CALL p510_ccu_01()   # 將 ccu 歸 0
   LET g_ccu.ccu01 =g_sfb.sfb01
   LET g_ccu.ccu04 =' ADJUST'   # 料號為 ' ADJUST'
   LET g_ccu.ccu05 ='P'
   LET g_ccu.ccu06 =type        #FUN-7C0028 add
   LET g_ccu.ccu07 =g_tlfcost   #FUN-7C0028 add 
   # 使調整成本歸入半成品
   LET g_chr=''
   SELECT MAX(ccl05) INTO g_chr FROM ccl_file
    WHERE ccl01=g_sfb.sfb01 AND ccl02=yy AND ccl03=mm AND ccl05='M'
      AND ccl06=type        AND ccl07=g_tlfcost   #FUN-7C0028 add 
   IF g_chr='M' THEN LET g_ccu.ccu05 ='M' END IF
   LET g_ccu.ccu21 =mcct.cct21
   SELECT SUM(ccl21),
          SUM(ccl22a), SUM(ccl22b), SUM(ccl22c), SUM(ccl22d), SUM(ccl22e)
         ,SUM(ccl22f), SUM(ccl22g), SUM(ccl22h)    #FUN-7C0028 add 
     INTO g_ccu.ccu21,
          g_ccu.ccu22a,g_ccu.ccu22b,g_ccu.ccu22c,g_ccu.ccu22d,g_ccu.ccu22e
         ,g_ccu.ccu22f,g_ccu.ccu22g,g_ccu.ccu22h   #FUN-7C0028 add 
     FROM ccl_file
    WHERE ccl01=g_sfb.sfb01 AND ccl02=yy AND ccl03=mm
      AND ccl06=type        AND ccl07=g_tlfcost   #FUN-7C0028 add 
   IF g_ccu.ccu21  IS NULL THEN LET g_ccu.ccu21 = 0 END IF
   IF g_ccu.ccu22a IS NULL THEN
      LET g_ccu.ccu22a = 0 LET g_ccu.ccu22b = 0 LET g_ccu.ccu22c = 0
      LET g_ccu.ccu22d = 0 LET g_ccu.ccu22e = 0
      LET g_ccu.ccu22f = 0 LET g_ccu.ccu22g = 0 LET g_ccu.ccu22h = 0   #FUN-7C0028 add 
   END IF
   LET g_ccu.ccu22 =g_ccu.ccu22a+g_ccu.ccu22b+g_ccu.ccu22c
                                +g_ccu.ccu22d+g_ccu.ccu22e
                                +g_ccu.ccu22f+g_ccu.ccu22g+g_ccu.ccu22h   #FUN-7C0028 add 
   IF g_ccu.ccu22 = 0 THEN LET g_ccu.ccu21 = 0 RETURN END IF
   LET g_ccu.ccu91  = g_ccu.ccu21
   LET g_ccu.ccu92a = g_ccu.ccu22a
   LET g_ccu.ccu92b = g_ccu.ccu22b
   LET g_ccu.ccu92c = g_ccu.ccu22c
   LET g_ccu.ccu92d = g_ccu.ccu22d
   LET g_ccu.ccu92e = g_ccu.ccu22e
   LET g_ccu.ccu92f = g_ccu.ccu22f   #FUN-7C0028 add
   LET g_ccu.ccu92g = g_ccu.ccu22g   #FUN-7C0028 add
   LET g_ccu.ccu92h = g_ccu.ccu22h   #FUN-7C0028 add
   LET g_ccu.ccu92  = g_ccu.ccu22
  #LET g_ccu.ccuplant = g_plant #FUN-980009 add    #FUN-A50075
   LET g_ccu.cculegal = g_legal #FUN-980009 add
 
   LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
   LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ccu_file VALUES(g_ccu.*)
   IF STATUS THEN                     # 可能有上期轉入資料造成重複
      UPDATE ccu_file SET ccu21=ccu21+g_ccu.ccu21,
                          ccu22=ccu22+g_ccu.ccu22,
                          ccu22a=ccu22a+g_ccu.ccu22a,
                          ccu22b=ccu22b+g_ccu.ccu22b,
                          ccu22c=ccu22c+g_ccu.ccu22c,
                          ccu22d=ccu22d+g_ccu.ccu22d,
                          ccu22e=ccu22e+g_ccu.ccu22e,   #FUN-7C0028 add
                          ccu22f=ccu22f+g_ccu.ccu22f,   #FUN-7C0028 add
                          ccu22g=ccu22g+g_ccu.ccu22g,   #FUN-7C0028 add
                          ccu22h=ccu22h+g_ccu.ccu22h,   #FUN-7C0028 add
                          ccu91a=ccu92a+g_ccu.ccu92a,   #MOD-4B0205
                          ccu92b=ccu92b+g_ccu.ccu92b,   #MOD-4B0205
                          ccu92c=ccu92c+g_ccu.ccu92c,   #MOD-4B0205
                          ccu92d=ccu92d+g_ccu.ccu92d,   #MOD-4B0205
                          ccu92e=ccu92e+g_ccu.ccu92e,   #MOD-4B0205
                          ccu92f=ccu92f+g_ccu.ccu92f,   #FUN-7C0028 add
                          ccu92g=ccu92g+g_ccu.ccu92g,   #FUN-7C0028 add
                          ccu92h=ccu92h+g_ccu.ccu92g,   #FUN-7C0028 add
                          ccu92 =ccu92 +g_ccu.ccu92     #MOD-4B0205
       WHERE ccu01=g_ccu.ccu01 AND ccu02=yy AND ccu03=mm
         AND ccu06=g_ccu.ccu06 AND ccu07=g_ccu.ccu07   #FUN-7C0028 add 
         AND ccu04=g_ccu.ccu04
   END IF
END FUNCTION
 
# 以下計算 WIP(拆件式)-元件 本期拆出成本
FUNCTION wipx_3()        # step 3. WIP-元件 本期轉出成本
   DEFINE l_ima08               LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
   DEFINE l_ima57               LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_tlf01               LIKE tlf_file.tlf01          #No.MOD-490217
   DEFINE l_tlf02,l_tlf03       LIKE type_file.num5          #No.FUN-680122 SMALLINT
   DEFINE l_tlf10               LIKE tlf_file.tlf10          #No.FUN-680122 DEC(15,3) #TQC-840066
   DEFINE l_c21                 LIKE cmc_file.cmc04          #No.FUN-680122 DEC(15,5)
   DEFINE l_c22,l_c22a,l_c22b,l_c22c,l_c22d,l_c22e  LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c22f,l_c22g,l_c22h                      LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_c23,l_c23a,l_c23b,l_c23c,l_c23d,l_c23e  LIKE type_file.num20_6   #No.FUN-680122 DEC(20,6)  #MOD-4C0005
   DEFINE l_c23f,l_c23g,l_c23h                      LIKE type_file.num20_6   #FUN-7C0028 add
   DEFINE l_tlf62               LIKE tlf_file.tlf62
   DEFINE l_sfa161              LIKE sfa_file.sfa161
 
   DECLARE wipx_c3x CURSOR FOR     #拆件轉出
     SELECT tlf01,ima08,ima57,tlf02,tlf03,SUM(tlf10*tlf60*tlf907*-1)
      FROM tlf_file LEFT OUTER JOIN ima_file ON tlf01=ima01
     WHERE tlf62=g_sfb.sfb01 AND tlf06 BETWEEN g_bdate AND g_edate
       AND ((tlf02=50 AND tlf03 BETWEEN 60 AND 69) OR
           (tlf03=50 AND tlf02 BETWEEN 60 AND 69))
       AND tlf13 MATCHES 'asft6*'
       AND tlf907 != 0
       AND tlfcost=g_tlfcost   #FUN-7C0028 add
     GROUP BY tlf01,ima08,ima57,tlf02,tlf03
   FOREACH wipx_c3x INTO l_tlf01,l_ima08,l_ima57,l_tlf02,l_tlf03,l_tlf10
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','wipx_c3x',SQLCA.sqlcode,0)  #No.FUN-710027
        EXIT FOREACH
     END IF
     IF l_ima57 = 99 OR l_ima57 = 98
     THEN LET l_ima08 = 'P' ELSE LET l_ima08 = 'M'
     END IF
     LET l_c23=0
     LET l_c23a=0 LET l_c23b=0 LET l_c23c=0 LET l_c23d=0 LET l_c23e=0
     LET l_c23f=0 LET l_c23g=0 LET l_c23h=0   #FUN-7C0028 add
 
     # (取當月庫存月平均檔) 拆出元件取本月算出加權平均單價
     SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
            ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
       INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
            l_c23f,l_c23g,l_c23h,l_c23    #FUN-7C0028 add l_c23f,g,h
       FROM ccc_file
      WHERE ccc01=l_tlf01 AND ccc02=yy AND ccc03=mm
        AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
     IF SQLCA.SQLCODE!=0 THEN
        SELECT ccc23a,ccc23b,ccc23c,ccc23d,ccc23e,
               ccc23f,ccc23g,ccc23h,ccc23   #FUN-7C0028 add ccc23f,g,h
          INTO l_c23a,l_c23b,l_c23c,l_c23d,l_c23e,
               l_c23f,l_c23g,l_c23h,l_c23    #FUN-7C0028 add l_c23f,g,h 
           FROM ccc_file
           WHERE ccc01=l_tlf01 AND ccc02=last_yy AND ccc03=last_mm
             AND ccc07=type    AND ccc08=g_tlfcost   #FUN-7C0028 add 
        LET g_msg="拆件式工單:",g_sfb.sfb01," 上階重工..取上期單價",
                  "(",l_tlf01 CLIPPED,")"
        LET t_time = TIME
        LET g_time=t_time
       #FUN-A50075--mod--str-- ccy_file del plant&legal
       #INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04,ccyplant,ccylegal)   #No.MOD-470041 #FUN-980009 add ccyplant,ccylegal
       #              VALUES(TODAY,g_time,g_user,g_msg,g_plant,g_legal) #FUN-980009 add g_plant,g_legal
        INSERT INTO ccy_file(ccy01,ccy02,ccy03,ccy04)
                      VALUES(TODAY,g_time,g_user,g_msg)
       #FUN-A50075--mod--end
     END IF
     CALL p510_ccu_01() # 將 ccu 歸 0
     LET g_ccu.ccu01 =g_sfb.sfb01
     LET g_ccu.ccu04 =l_tlf01
     LET g_ccu.ccu05 =l_ima08
     LET g_ccu.ccu06 =type        #FUN-7C0028 add
     LET g_ccu.ccu07 =g_tlfcost   #FUN-7C0028 add 
     LET g_ccu.ccu31 =l_tlf10
     LET g_ccu.ccu32a=l_tlf10*l_c23a
     LET g_ccu.ccu32b=l_tlf10*l_c23b
     LET g_ccu.ccu32c=l_tlf10*l_c23c
     LET g_ccu.ccu32d=l_tlf10*l_c23d
     LET g_ccu.ccu32e=l_tlf10*l_c23e
     LET g_ccu.ccu32f=l_tlf10*l_c23f   #FUN-7C0028 add
     LET g_ccu.ccu32g=l_tlf10*l_c23g   #FUN-7C0028 add
     LET g_ccu.ccu32h=l_tlf10*l_c23h   #FUN-7C0028 add 
     LET g_ccu.ccu32 =g_ccu.ccu32a+g_ccu.ccu32b+g_ccu.ccu32c+
                      g_ccu.ccu32d+g_ccu.ccu32e
                     +g_ccu.ccu32f+g_ccu.ccu32g+g_ccu.ccu32h   #FUN-7C0028 add 
 
    #LET g_ccu.ccuplant = g_plant #FUN-980009 add    #FUN-A50075
     LET g_ccu.cculegal = g_legal #FUN-980009 add
     LET g_ccu.ccuoriu = g_user      #No.FUN-980030 10/01/04
     LET g_ccu.ccuorig = g_grup      #No.FUN-980030 10/01/04
     INSERT INTO ccu_file VALUES(g_ccu.*)
     IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #TQC-790087
        LET g_showmsg=g_ccu.ccu01,"/",g_ccu.ccu02                                                                    #No.FUN-710027
        CALL s_errmsg('ccu10,ccu02',g_showmsg,'wipx_2_21() ins ccu:',SQLCA.SQLCODE,1)                                       #No.FUN-710027 
     END IF
     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #TQC-790087
        UPDATE ccu_file SET ccu31=ccu31+g_ccu.ccu31,
                            ccu32=ccu32+g_ccu.ccu32,
                            ccu32a=ccu32a+g_ccu.ccu32a,
                            ccu32b=ccu32b+g_ccu.ccu32b,
                            ccu32c=ccu32c+g_ccu.ccu32c,
                            ccu32d=ccu32d+g_ccu.ccu32d,
                            ccu32e=ccu32e+g_ccu.ccu32e,
                            ccu32f=ccu32f+g_ccu.ccu32f,   #FUN-7C0028 add
                            ccu32g=ccu32g+g_ccu.ccu32g,   #FUN-7C0028 add
                            ccu32h=ccu32h+g_ccu.ccu32h    #FUN-7C0028 add 
            WHERE ccu01=g_sfb.sfb01 AND ccu02=yy AND ccu03=mm
              AND ccu06=g_ccu.ccu06 AND ccu07=g_ccu.ccu07   #FUN-7C0028 add 
              AND ccu04=l_tlf01
     END IF
   END FOREACH
   CLOSE wipx_c3x
   CALL wipx_2_24()   #整理該歸期未或差異
END FUNCTION
 
FUNCTION wipx_2_24()   #整理該歸期未或差異
   DECLARE wipx_c2_24 CURSOR FOR
    SELECT ccu_file.* FROM ccu_file
     WHERE ccu01=g_sfb.sfb01 AND ccu02 = yy AND ccu03 = mm
       AND ccu06=type        AND ccu07=g_tlfcost   #FUN-7C0028 add 
       AND ccu04 != ' DL+OH+SU' AND ccu04 != ' ADJUST'
   FOREACH wipx_c2_24 INTO mccu.*
     IF SQLCA.sqlcode THEN
        CALL s_errmsg('','','wipx_c2_24',SQLCA.sqlcode,0)      #No.FUN-710027
        EXIT FOREACH
     END IF
     #判斷有無結案, 若結案則歸差異成本
     IF g_sfb.sfb38 IS NOT NULL AND g_sfb.sfb38 >= g_bdate
    AND g_sfb.sfb38 <= g_edate THEN
        LET mccu.ccu41 = (mccu.ccu11 + mccu.ccu21 + mccu.ccu31 )*-1
        LET mccu.ccu42 = (mccu.ccu12 + mccu.ccu22 + mccu.ccu32 )*-1
        LET mccu.ccu42a= (mccu.ccu12a+ mccu.ccu22a+ mccu.ccu32a)*-1
        LET mccu.ccu42b= (mccu.ccu12b+ mccu.ccu22b+ mccu.ccu32b)*-1
        LET mccu.ccu42c= (mccu.ccu12c+ mccu.ccu22c+ mccu.ccu32c)*-1
        LET mccu.ccu42d= (mccu.ccu12d+ mccu.ccu22d+ mccu.ccu32d)*-1
        LET mccu.ccu42e= (mccu.ccu12e+ mccu.ccu22e+ mccu.ccu32e)*-1
        LET mccu.ccu42f= (mccu.ccu12f+ mccu.ccu22f+ mccu.ccu32f)*-1   #FUN-7C0028 add
        LET mccu.ccu42g= (mccu.ccu12g+ mccu.ccu22g+ mccu.ccu32g)*-1   #FUN-7C0028 add
        LET mccu.ccu42h= (mccu.ccu12h+ mccu.ccu22h+ mccu.ccu32h)*-1   #FUN-7C0028 add 
        LET mccu.ccu91 = 0
        LET mccu.ccu92 = 0
        LET mccu.ccu92a= 0
        LET mccu.ccu92b= 0
        LET mccu.ccu92c= 0
        LET mccu.ccu92d= 0
        LET mccu.ccu92e= 0
        LET mccu.ccu92f= 0   #FUN-7C0028 add
        LET mccu.ccu92g= 0   #FUN-7C0028 add
        LET mccu.ccu92h= 0   #FUN-7C0028 add 
     ELSE
        LET mccu.ccu91 = mccu.ccu11 + mccu.ccu21 + mccu.ccu31
        LET mccu.ccu92 = mccu.ccu12 + mccu.ccu22 + mccu.ccu32
        LET mccu.ccu92a= mccu.ccu12a+ mccu.ccu22a+ mccu.ccu32a
        LET mccu.ccu92b= mccu.ccu12b+ mccu.ccu22b+ mccu.ccu32b
        LET mccu.ccu92c= mccu.ccu12c+ mccu.ccu22c+ mccu.ccu32c
        LET mccu.ccu92d= mccu.ccu12d+ mccu.ccu22d+ mccu.ccu32d
        LET mccu.ccu92e= mccu.ccu12e+ mccu.ccu22e+ mccu.ccu32e
        LET mccu.ccu92f= mccu.ccu12f+ mccu.ccu22f+ mccu.ccu32f   #FUN-7C0028 add
        LET mccu.ccu92g= mccu.ccu12g+ mccu.ccu22g+ mccu.ccu32g   #FUN-7C0028 add
        LET mccu.ccu92h= mccu.ccu12h+ mccu.ccu22h+ mccu.ccu32h   #FUN-7C0028 add 
        LET mccu.ccu41 = 0
        LET mccu.ccu42 = 0
        LET mccu.ccu42a= 0
        LET mccu.ccu42b= 0
        LET mccu.ccu42c= 0
        LET mccu.ccu42d= 0
        LET mccu.ccu42e= 0
        LET mccu.ccu42f= 0   #FUN-7C0028 add
        LET mccu.ccu42g= 0   #FUN-7C0028 add
        LET mccu.ccu42h= 0   #FUN-7C0028 add 
     END IF
 
     UPDATE ccu_file SET ccu41 = mccu.ccu41,
                         ccu42 = mccu.ccu42 ,
                         ccu42a= mccu.ccu42a,
                         ccu42b= mccu.ccu42b,
                         ccu42c= mccu.ccu42c,
                         ccu42d= mccu.ccu42d,
                         ccu42e= mccu.ccu42e,
                         ccu42f= mccu.ccu42f,   #FUN-7C0028 add
                         ccu42g= mccu.ccu42g,   #FUN-7C0028 add
                         ccu42h= mccu.ccu42h,   #FUN-7C0028 add 
                         ccu91 = mccu.ccu91,
                         ccu92 = mccu.ccu92 ,
                         ccu92a= mccu.ccu92a,
                         ccu92b= mccu.ccu92b,
                         ccu92c= mccu.ccu92c,
                         ccu92d= mccu.ccu92d,
                         ccu92e= mccu.ccu92e,
                         ccu92f= mccu.ccu92f,   #FUN-7C0028 add
                         ccu92g= mccu.ccu92g,   #FUN-7C0028 add
                         ccu92h= mccu.ccu92h    #FUN-7C0028 add 
      WHERE ccu01 = g_sfb.sfb01 AND ccu02 = yy AND ccu03 = mm
        AND ccu04 = mccu.ccu04
        AND ccu06 = mccu.ccu06 AND ccu07 = mccu.ccu07   #FUN-7C0028 add 
   END FOREACH
   CLOSE wipx_c2_24
END FUNCTION
 
FUNCTION wipx_4()        # 計算每張拆件式工單的 WIP-主件 成本 (cct)
 SELECT SUM(ccu12),SUM(ccu12a),SUM(ccu12b),SUM(ccu12c),SUM(ccu12d),SUM(ccu12e),
                   SUM(ccu12f),SUM(ccu12g),SUM(ccu12h),   #FUN-7C0028 add
        SUM(ccu22),SUM(ccu22a),SUM(ccu22b),SUM(ccu22c),SUM(ccu22d),SUM(ccu22e),
                   SUM(ccu22f),SUM(ccu22g),SUM(ccu22h),   #FUN-7C0028 add
        SUM(ccu32),SUM(ccu32a),SUM(ccu32b),SUM(ccu32c),SUM(ccu32d),SUM(ccu32e),
                   SUM(ccu32f),SUM(ccu32g),SUM(ccu32h),   #FUN-7C0028 add
        SUM(ccu42),SUM(ccu42a),SUM(ccu42b),SUM(ccu42c),SUM(ccu42d),SUM(ccu42e),
                   SUM(ccu42f),SUM(ccu42g),SUM(ccu42h),   #FUN-7C0028 add
        SUM(ccu92),SUM(ccu92a),SUM(ccu92b),SUM(ccu92c),SUM(ccu92d),SUM(ccu92e)
                  ,SUM(ccu92f),SUM(ccu92g),SUM(ccu92h)    #FUN-7C0028 add
   INTO mcct.cct12,mcct.cct12a,mcct.cct12b,mcct.cct12c,mcct.cct12d,mcct.cct12e,
                   mcct.cct12f,mcct.cct12g,mcct.cct12h,   #FUN-7C0028 add
        mcct.cct22,mcct.cct22a,mcct.cct22b,mcct.cct22c,mcct.cct22d,mcct.cct22e,
                   mcct.cct22f,mcct.cct22g,mcct.cct22h,   #FUN-7C0028 add
        mcct.cct32,mcct.cct32a,mcct.cct32b,mcct.cct32c,mcct.cct32d,mcct.cct32e,
                   mcct.cct32f,mcct.cct32g,mcct.cct32h,   #FUN-7C0028 add
        mcct.cct42,mcct.cct42a,mcct.cct42b,mcct.cct42c,mcct.cct42d,mcct.cct42e,
                   mcct.cct42f,mcct.cct42g,mcct.cct42h,   #FUN-7C0028 add
        mcct.cct92,mcct.cct92a,mcct.cct92b,mcct.cct92c,mcct.cct92d,mcct.cct92e
                  ,mcct.cct92f,mcct.cct92g,mcct.cct92h    #FUN-7C0028 add
   FROM ccu_file
  WHERE ccu01=g_sfb.sfb01 AND ccu02=yy AND ccu03=mm
    AND ccu06=type        AND ccu07=g_tlfcost   #FUN-7C0028 add 
 IF mcct.cct12 IS NULL THEN
    LET mcct.cct12 = 0 LET mcct.cct12a= 0 LET mcct.cct12b= 0
    LET mcct.cct12c= 0 LET mcct.cct12d= 0 LET mcct.cct12e= 0
    LET mcct.cct12f= 0 LET mcct.cct12g= 0 LET mcct.cct12h= 0   #FUN-7C0028 add 
    LET mcct.cct22 = 0 LET mcct.cct22a= 0 LET mcct.cct22b= 0
    LET mcct.cct22c= 0 LET mcct.cct22d= 0 LET mcct.cct22e= 0
    LET mcct.cct22f= 0 LET mcct.cct22g= 0 LET mcct.cct22h= 0   #FUN-7C0028 add 
    LET mcct.cct32 = 0 LET mcct.cct32a= 0 LET mcct.cct32b= 0
    LET mcct.cct32c= 0 LET mcct.cct32d= 0 LET mcct.cct32e= 0
    LET mcct.cct32f= 0 LET mcct.cct32g= 0 LET mcct.cct32h= 0   #FUN-7C0028 add 
    LET mcct.cct42 = 0 LET mcct.cct42a= 0 LET mcct.cct42b= 0
    LET mcct.cct42c= 0 LET mcct.cct42d= 0 LET mcct.cct42e= 0
    LET mcct.cct42f= 0 LET mcct.cct42g= 0 LET mcct.cct42h= 0   #FUN-7C0028 add 
    LET mcct.cct92 = 0 LET mcct.cct92a= 0 LET mcct.cct92b= 0
    LET mcct.cct92c= 0 LET mcct.cct92d= 0 LET mcct.cct92e= 0
    LET mcct.cct92f= 0 LET mcct.cct92g= 0 LET mcct.cct92h= 0   #FUN-7C0028 add 
 END IF
 LET t_time = TIME
 LET mcct.cctuser=g_user LET mcct.cctdate=TODAY LET mcct.ccttime=t_time
 UPDATE cct_file SET cct_file.* = mcct.*
  WHERE cct01=mcct.cct01 AND cct02=mcct.cct02 AND cct03=mcct.cct03
    AND cct06=mcct.cct06 AND cct07=mcct.cct07   #FUN-7C0028 add 
 IF STATUS THEN 
    LET g_showmsg= mcct.cct01,"/",mcct.cct02                                                         #No.FUN-710027
    CALL s_errmsg('cct01,cct02',g_showmsg,'upd cct.*',STATUS,1)                                      #No.FUN-710027
    RETURN
 END IF
    SELECT COUNT(*) INTO g_cnt FROM ccu_file
     WHERE ccu01=mcct.cct01 AND ccu02=yy AND ccu03=mm
       AND cct06=mcct.cct06 AND cct07=mcct.cct07   #FUN-7C0028 add 
    IF g_cnt=0 AND
       mcct.cct11 =0 AND mcct.cct12a=0 AND mcct.cct12b=0 AND
       mcct.cct12 =0 AND mcct.cct12c=0 AND mcct.cct12d=0 AND
       mcct.cct12e=0 AND mcct.cct12f=0 AND mcct.cct12g=0 AND mcct.cct12h=0 AND   #FUN-7C0028 add 
       mcct.cct20 =0 AND
       mcct.cct21 =0 AND mcct.cct22a=0 AND mcct.cct22b=0 AND
       mcct.cct22 =0 AND mcct.cct22c=0 AND mcct.cct22d=0 AND
       mcct.cct22e=0 AND mcct.cct22f=0 AND mcct.cct22g=0 AND mcct.cct22h=0 AND   #FUN-7C0028 add 
       mcct.cct23 =0 AND mcct.cct23a=0 AND mcct.cct23b=0 AND
       mcct.cct23c=0 AND mcct.cct23d=0 AND
       mcct.cct23e=0 AND mcct.cct23f=0 AND mcct.cct23g=0 AND mcct.cct23h=0 AND   #FUN-7C0028 add 
       mcct.cct31 =0 AND mcct.cct32a=0 AND mcct.cct32b=0 AND
       mcct.cct32 =0 AND mcct.cct32c=0 AND mcct.cct32d=0 AND
       mcct.cct32e=0 AND mcct.cct32f=0 AND mcct.cct32g=0 AND mcct.cct32h=0 AND   #FUN-7C0028 add 
       mcct.cct41 =0 AND mcct.cct42a=0 AND mcct.cct42b=0 AND
       mcct.cct42 =0 AND mcct.cct42c=0 AND mcct.cct42d=0 AND
       mcct.cct42e=0 AND mcct.cct42f=0 AND mcct.cct42g=0 AND mcct.cct42h=0 AND   #FUN-7C0028 add 
       mcct.cct91 =0 AND mcct.cct92a=0 AND mcct.cct92b=0 AND
       mcct.cct92 =0 AND mcct.cct92c=0 AND mcct.cct92d=0 AND
       mcct.cct92e=0 AND mcct.cct92f=0 AND mcct.cct92g=0 AND mcct.cct92h=0 THEN  #FUN-7C0028 add 
       DELETE FROM cct_file
       WHERE cct01=mcct.cct01 AND cct02=yy AND cct03=mm
         AND cct06=type       AND cct07=g_tlfcost   #FUN-7C0028 add 
    END IF
END FUNCTION
 
FUNCTION p510_mcct_0()
   LET mcct.cct01 =g_sfb.sfb01
   LET mcct.cct02 =yy
   LET mcct.cct03 =mm
   LET mcct.cct04 =g_sfb.sfb05
   LET mcct.cct06 =type        #FUN-7C0028 add
   LET mcct.cct07 =g_tlfcost   #FUN-7C0028 add 
   LET mcct.cct11 =0
   LET mcct.cct12 =0 LET mcct.cct12a=0 LET mcct.cct12b=0
   LET mcct.cct12c=0 LET mcct.cct12d=0 LET mcct.cct12e=0
   LET mcct.cct12f=0 LET mcct.cct12g=0 LET mcct.cct12h=0   #FUN-7C0028 add 
   LET mcct.cct20 =0
   LET mcct.cct21 =0
   LET mcct.cct22 =0 LET mcct.cct22a=0 LET mcct.cct22b=0
   LET mcct.cct22c=0 LET mcct.cct22d=0 LET mcct.cct22e=0
   LET mcct.cct22f=0 LET mcct.cct22g=0 LET mcct.cct22h=0   #FUN-7C0028 add 
   LET mcct.cct23 =0 LET mcct.cct23a=0 LET mcct.cct23b=0
   LET mcct.cct23c=0 LET mcct.cct23d=0 LET mcct.cct23e=0
   LET mcct.cct23f=0 LET mcct.cct23g=0 LET mcct.cct23h=0   #FUN-7C0028 add 
   LET mcct.cct31 =0
   LET mcct.cct32 =0 LET mcct.cct32a=0 LET mcct.cct32b=0
   LET mcct.cct32c=0 LET mcct.cct32d=0 LET mcct.cct32e=0
   LET mcct.cct32f=0 LET mcct.cct32g=0 LET mcct.cct32h=0   #FUN-7C0028 add 
   LET mcct.cct41 =0
   LET mcct.cct42 =0 LET mcct.cct42a=0 LET mcct.cct42b=0
   LET mcct.cct42c=0 LET mcct.cct42d=0 LET mcct.cct42e=0
   LET mcct.cct42f=0 LET mcct.cct42g=0 LET mcct.cct42h=0   #FUN-7C0028 add 
 
   #  盤點盈虧
   LET mcct.cct52 =0 LET mcct.cct52a=0 LET mcct.cct52b=0
   LET mcct.cct52c=0 LET mcct.cct52d=0 LET mcct.cct52e=0
   LET mcct.cct53 =0 LET mcct.cct53a=0 LET mcct.cct53b=0
   LET mcct.cct53c=0 LET mcct.cct53d=0 LET mcct.cct53e=0
   LET mcct.cct91 =0
   LET mcct.cct92 =0 LET mcct.cct92a=0 LET mcct.cct92b=0
   LET mcct.cct92c=0 LET mcct.cct92d=0 LET mcct.cct92e=0
   LET mcct.cct92f=0 LET mcct.cct92g=0 LET mcct.cct92h=0   #FUN-7C0028 add 
 
   LET t_time = TIME
   LET mcct.cctuser=g_user LET mcct.cctdate=TODAY LET mcct.ccttime=t_time
END FUNCTION
 
FUNCTION p510_ccu_0()           # 依上月期末轉本月期初, 其餘歸零
   LET g_ccu.ccu02 =yy
   LET g_ccu.ccu03 =mm
   LET g_ccu.ccu06 =type        #FUN-7C0028 add
   LET g_ccu.ccu07 =g_tlfcost   #FUN-7C0028 add 
   LET g_ccu.ccu11 =g_ccu.ccu91
   LET g_ccu.ccu12 =g_ccu.ccu92
   LET g_ccu.ccu12a=g_ccu.ccu92a
   LET g_ccu.ccu12b=g_ccu.ccu92b
   LET g_ccu.ccu12c=g_ccu.ccu92c
   LET g_ccu.ccu12d=g_ccu.ccu92d
   LET g_ccu.ccu12e=g_ccu.ccu92e
   LET g_ccu.ccu12f=g_ccu.ccu92f   #FUN-7C0028 add
   LET g_ccu.ccu12g=g_ccu.ccu92g   #FUN-7C0028 add
   LET g_ccu.ccu12h=g_ccu.ccu92h   #FUN-7C0028 add 
   LET g_ccu.ccu21 =0
   LET g_ccu.ccu22 =0 LET g_ccu.ccu22a=0 LET g_ccu.ccu22b=0
   LET g_ccu.ccu22c=0 LET g_ccu.ccu22d=0 LET g_ccu.ccu22e=0
   LET g_ccu.ccu22f=0 LET g_ccu.ccu22g=0 LET g_ccu.ccu22h=0   #FUN-7C0028 add 
   LET g_ccu.ccu31 =0
   LET g_ccu.ccu32 =0 LET g_ccu.ccu32a=0 LET g_ccu.ccu32b=0
   LET g_ccu.ccu32c=0 LET g_ccu.ccu32d=0 LET g_ccu.ccu32e=0
   LET g_ccu.ccu32f=0 LET g_ccu.ccu32g=0 LET g_ccu.ccu32h=0   #FUN-7C0028 add 
   LET g_ccu.ccu41 =0
   LET g_ccu.ccu42 =0 LET g_ccu.ccu42a=0 LET g_ccu.ccu42b=0
   LET g_ccu.ccu42c=0 LET g_ccu.ccu42d=0 LET g_ccu.ccu42e=0
   LET g_ccu.ccu42f=0 LET g_ccu.ccu42g=0 LET g_ccu.ccu42h=0   #FUN-7C0028 add 
 
   # 盤點盈虧
   LET g_ccu.ccu51 =0
   LET g_ccu.ccu52 =0 LET g_ccu.ccu52a=0 LET g_ccu.ccu52b=0
   LET g_ccu.ccu52c=0 LET g_ccu.ccu52d=0 LET g_ccu.ccu52e=0
   LET g_ccu.ccu91 =0
   LET g_ccu.ccu92 =0 LET g_ccu.ccu92a=0 LET g_ccu.ccu92b=0
   LET g_ccu.ccu92c=0 LET g_ccu.ccu92d=0 LET g_ccu.ccu92e=0
   LET g_ccu.ccu92f=0 LET g_ccu.ccu92g=0 LET g_ccu.ccu92h=0   #FUN-7C0028 add 
  #LET g_ccu.ccuplant = g_plant #FUN-980009 add    #FUN-A50075
   LET g_ccu.cculegal = g_legal #FUN-980009 add
END FUNCTION
 
FUNCTION p510_ccu_01()          # 全部歸零
   LET g_ccu.ccu02 =yy
   LET g_ccu.ccu03 =mm
   LET g_ccu.ccu06 =type        #FUN-7C0028 add
   LET g_ccu.ccu07 =g_tlfcost   #FUN-7C0028 add 
   LET g_ccu.ccu11 =0
   LET g_ccu.ccu12 =0 LET g_ccu.ccu12a=0 LET g_ccu.ccu12b=0
   LET g_ccu.ccu12c=0 LET g_ccu.ccu12d=0 LET g_ccu.ccu12e=0
   LET g_ccu.ccu12f=0 LET g_ccu.ccu12g=0 LET g_ccu.ccu12h=0   #FUN-7C0028 add 
   LET g_ccu.ccu21 =0
   LET g_ccu.ccu22 =0 LET g_ccu.ccu22a=0 LET g_ccu.ccu22b=0
   LET g_ccu.ccu22c=0 LET g_ccu.ccu22d=0 LET g_ccu.ccu22e=0
   LET g_ccu.ccu22f=0 LET g_ccu.ccu22g=0 LET g_ccu.ccu22h=0   #FUN-7C0028 add 
   LET g_ccu.ccu31 =0
   LET g_ccu.ccu32 =0 LET g_ccu.ccu32a=0 LET g_ccu.ccu32b=0
   LET g_ccu.ccu32c=0 LET g_ccu.ccu32d=0 LET g_ccu.ccu32e=0
   LET g_ccu.ccu32f=0 LET g_ccu.ccu32g=0 LET g_ccu.ccu32h=0   #FUN-7C0028 add 
   LET g_ccu.ccu41 =0
   LET g_ccu.ccu42 =0 LET g_ccu.ccu42a=0 LET g_ccu.ccu42b=0
   LET g_ccu.ccu42c=0 LET g_ccu.ccu42d=0 LET g_ccu.ccu42e=0
   LET g_ccu.ccu42f=0 LET g_ccu.ccu42g=0 LET g_ccu.ccu42h=0   #FUN-7C0028 add
   LET g_ccu.ccu51 =0
   LET g_ccu.ccu52 =0 LET g_ccu.ccu52a=0 LET g_ccu.ccu52b=0
   LET g_ccu.ccu52c=0 LET g_ccu.ccu52d=0 LET g_ccu.ccu52e=0
   LET g_ccu.ccu91 =0
   LET g_ccu.ccu92 =0 LET g_ccu.ccu92a=0 LET g_ccu.ccu92b=0
   LET g_ccu.ccu92c=0 LET g_ccu.ccu92d=0 LET g_ccu.ccu92e=0
   LET g_ccu.ccu92f=0 LET g_ccu.ccu92g=0 LET g_ccu.ccu92h=0   #FUN-7C0028 add 
END FUNCTION
 
FUNCTION p510_out()
   DEFINE l_cmd        LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
   DEFINE l_name       LIKE type_file.chr20         #No.FUN-680122 VARCHAR(20)
   DEFINE l_ccy        RECORD LIKE ccy_file.*
   DEFINE n            LIKE type_file.num10         #No.FUN-680122 INTEGER
   CALL cl_outnam('axcp510') RETURNING l_name
   DECLARE p510_co CURSOR FOR
      SELECT * FROM ccy_file
       WHERE ccy01>start_date OR (ccy01=start_date AND ccy02>=start_time)
   START REPORT p510_rep TO l_name
   LET l_ccy.ccy04=start_date,' ',start_time,' begin...'
   OUTPUT TO REPORT p510_rep(l_ccy.*)
   LET n=0
   FOREACH p510_co INTO l_ccy.*
     LET n=n+1
     OUTPUT TO REPORT p510_rep(l_ccy.*)
   END FOREACH
   LET l_ccy.ccy04=TODAY,' ',TIME,' end  ...'
   OUTPUT TO REPORT p510_rep(l_ccy.*)
   FINISH REPORT p510_rep
   IF n>0 THEN
      CALL cl_prt(l_name,' ','1',g_len)
   ELSE
       IF os.Path.chrwx(l_name CLIPPED,511) THEN END IF   #No.FUN-9C0009
   END IF
   CLOSE p510_co
END FUNCTION
 
REPORT p510_rep(l_ccy)
   DEFINE l_ccy         RECORD LIKE ccy_file.*
   OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   FORMAT ON EVERY ROW PRINT l_ccy.ccy04 CLIPPED
END REPORT
 
FUNCTION p510_ckp_ccc()
IF cl_null(g_ccc.ccc08)  THEN LET g_ccc.ccc08  = ' ' END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc11)  THEN LET g_ccc.ccc11  = 0 END IF
IF cl_null(g_ccc.ccc12)  THEN LET g_ccc.ccc12  = 0 END IF
IF cl_null(g_ccc.ccc12a) THEN LET g_ccc.ccc12a = 0 END IF
IF cl_null(g_ccc.ccc12b) THEN LET g_ccc.ccc12b = 0 END IF
IF cl_null(g_ccc.ccc12c) THEN LET g_ccc.ccc12c = 0 END IF
IF cl_null(g_ccc.ccc12d) THEN LET g_ccc.ccc12d = 0 END IF
IF cl_null(g_ccc.ccc12e) THEN LET g_ccc.ccc12e = 0 END IF
IF cl_null(g_ccc.ccc12f) THEN LET g_ccc.ccc12f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc12g) THEN LET g_ccc.ccc12g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc12h) THEN LET g_ccc.ccc12h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc21)  THEN LET g_ccc.ccc21  = 0 END IF
IF cl_null(g_ccc.ccc22)  THEN LET g_ccc.ccc22  = 0 END IF
IF cl_null(g_ccc.ccc22a) THEN LET g_ccc.ccc22a = 0 END IF
IF cl_null(g_ccc.ccc22b) THEN LET g_ccc.ccc22b = 0 END IF
IF cl_null(g_ccc.ccc22c) THEN LET g_ccc.ccc22c = 0 END IF
IF cl_null(g_ccc.ccc22d) THEN LET g_ccc.ccc22d = 0 END IF
IF cl_null(g_ccc.ccc22e) THEN LET g_ccc.ccc22e = 0 END IF
IF cl_null(g_ccc.ccc22f) THEN LET g_ccc.ccc22f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g) THEN LET g_ccc.ccc22g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h) THEN LET g_ccc.ccc22h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc23)  THEN LET g_ccc.ccc23  = 0 END IF
IF cl_null(g_ccc.ccc23a) THEN LET g_ccc.ccc23a = 0 END IF
IF cl_null(g_ccc.ccc23b) THEN LET g_ccc.ccc23b = 0 END IF
IF cl_null(g_ccc.ccc23c) THEN LET g_ccc.ccc23c = 0 END IF
IF cl_null(g_ccc.ccc23d) THEN LET g_ccc.ccc23d = 0 END IF
IF cl_null(g_ccc.ccc23e) THEN LET g_ccc.ccc23e = 0 END IF
IF cl_null(g_ccc.ccc23f) THEN LET g_ccc.ccc23f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc23g) THEN LET g_ccc.ccc23g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc23h) THEN LET g_ccc.ccc23h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc25)  THEN LET g_ccc.ccc25  = 0 END IF
IF cl_null(g_ccc.ccc26)  THEN LET g_ccc.ccc26  = 0 END IF
IF cl_null(g_ccc.ccc26a) THEN LET g_ccc.ccc26a = 0 END IF
IF cl_null(g_ccc.ccc26b) THEN LET g_ccc.ccc26b = 0 END IF
IF cl_null(g_ccc.ccc26c) THEN LET g_ccc.ccc26c = 0 END IF
IF cl_null(g_ccc.ccc26d) THEN LET g_ccc.ccc26d = 0 END IF
IF cl_null(g_ccc.ccc26e) THEN LET g_ccc.ccc26e = 0 END IF
IF cl_null(g_ccc.ccc26f) THEN LET g_ccc.ccc26f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc26g) THEN LET g_ccc.ccc26g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc26h) THEN LET g_ccc.ccc26h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc27)  THEN LET g_ccc.ccc27  = 0 END IF
IF cl_null(g_ccc.ccc28)  THEN LET g_ccc.ccc28  = 0 END IF
IF cl_null(g_ccc.ccc28a) THEN LET g_ccc.ccc28a = 0 END IF
IF cl_null(g_ccc.ccc28b) THEN LET g_ccc.ccc28b = 0 END IF
IF cl_null(g_ccc.ccc28c) THEN LET g_ccc.ccc28c = 0 END IF
IF cl_null(g_ccc.ccc28d) THEN LET g_ccc.ccc28d = 0 END IF
IF cl_null(g_ccc.ccc28e) THEN LET g_ccc.ccc28e = 0 END IF
IF cl_null(g_ccc.ccc28f) THEN LET g_ccc.ccc28f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc28g) THEN LET g_ccc.ccc28g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc28h) THEN LET g_ccc.ccc28h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc31)  THEN LET g_ccc.ccc31  = 0 END IF
IF cl_null(g_ccc.ccc32)  THEN LET g_ccc.ccc32  = 0 END IF
IF cl_null(g_ccc.ccc41)  THEN LET g_ccc.ccc41  = 0 END IF
IF cl_null(g_ccc.ccc42)  THEN LET g_ccc.ccc42  = 0 END IF
IF cl_null(g_ccc.ccc43)  THEN LET g_ccc.ccc43  = 0 END IF
IF cl_null(g_ccc.ccc44)  THEN LET g_ccc.ccc44  = 0 END IF
IF cl_null(g_ccc.ccc51)  THEN LET g_ccc.ccc51  = 0 END IF
IF cl_null(g_ccc.ccc52)  THEN LET g_ccc.ccc52  = 0 END IF
IF cl_null(g_ccc.ccc61)  THEN LET g_ccc.ccc61  = 0 END IF
IF cl_null(g_ccc.ccc62)  THEN LET g_ccc.ccc62  = 0 END IF
IF cl_null(g_ccc.ccc62a) THEN LET g_ccc.ccc62a = 0 END IF
IF cl_null(g_ccc.ccc62b) THEN LET g_ccc.ccc62b = 0 END IF
IF cl_null(g_ccc.ccc62c) THEN LET g_ccc.ccc62c = 0 END IF
IF cl_null(g_ccc.ccc62d) THEN LET g_ccc.ccc62d = 0 END IF
IF cl_null(g_ccc.ccc62e) THEN LET g_ccc.ccc62e = 0 END IF
IF cl_null(g_ccc.ccc62f) THEN LET g_ccc.ccc62f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc62g) THEN LET g_ccc.ccc62g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc62h) THEN LET g_ccc.ccc62h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc63)  THEN LET g_ccc.ccc63  = 0 END IF
IF cl_null(g_ccc.ccc64)  THEN LET g_ccc.ccc64  = 0 END IF
IF cl_null(g_ccc.ccc65)  THEN LET g_ccc.ccc65  = 0 END IF
IF cl_null(g_ccc.ccc66)  THEN LET g_ccc.ccc66  = 0 END IF
IF cl_null(g_ccc.ccc66a) THEN LET g_ccc.ccc66a = 0 END IF
IF cl_null(g_ccc.ccc66b) THEN LET g_ccc.ccc66b = 0 END IF
IF cl_null(g_ccc.ccc66c) THEN LET g_ccc.ccc66c = 0 END IF
IF cl_null(g_ccc.ccc66d) THEN LET g_ccc.ccc66d = 0 END IF
IF cl_null(g_ccc.ccc66e) THEN LET g_ccc.ccc66e = 0 END IF
IF cl_null(g_ccc.ccc66f) THEN LET g_ccc.ccc66f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc66g) THEN LET g_ccc.ccc66g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc66h) THEN LET g_ccc.ccc66h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc71)  THEN LET g_ccc.ccc71  = 0 END IF
IF cl_null(g_ccc.ccc72)  THEN LET g_ccc.ccc72  = 0 END IF
IF cl_null(g_ccc.ccc81)  THEN LET g_ccc.ccc81  = 0 END IF
IF cl_null(g_ccc.ccc82)  THEN LET g_ccc.ccc82  = 0 END IF
IF cl_null(g_ccc.ccc82a) THEN LET g_ccc.ccc82a = 0 END IF
IF cl_null(g_ccc.ccc82b) THEN LET g_ccc.ccc82b = 0 END IF
IF cl_null(g_ccc.ccc82c) THEN LET g_ccc.ccc82c = 0 END IF
IF cl_null(g_ccc.ccc82d) THEN LET g_ccc.ccc82d = 0 END IF
IF cl_null(g_ccc.ccc82e) THEN LET g_ccc.ccc82e = 0 END IF
IF cl_null(g_ccc.ccc82f) THEN LET g_ccc.ccc82f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc82g) THEN LET g_ccc.ccc82g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc82h) THEN LET g_ccc.ccc82h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc91)  THEN LET g_ccc.ccc91  = 0 END IF
IF cl_null(g_ccc.ccc92)  THEN LET g_ccc.ccc92  = 0 END IF
IF cl_null(g_ccc.ccc92a) THEN LET g_ccc.ccc92a = 0 END IF
IF cl_null(g_ccc.ccc92b) THEN LET g_ccc.ccc92b = 0 END IF
IF cl_null(g_ccc.ccc92c) THEN LET g_ccc.ccc92c = 0 END IF
IF cl_null(g_ccc.ccc92d) THEN LET g_ccc.ccc92d = 0 END IF
IF cl_null(g_ccc.ccc92e) THEN LET g_ccc.ccc92e = 0 END IF
IF cl_null(g_ccc.ccc92f) THEN LET g_ccc.ccc92f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc92g) THEN LET g_ccc.ccc92g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc92h) THEN LET g_ccc.ccc92h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc93)  THEN LET g_ccc.ccc93  = 0 END IF
IF cl_null(g_ccc.ccc93a) THEN LET g_ccc.ccc93a = 0 END IF
IF cl_null(g_ccc.ccc93b) THEN LET g_ccc.ccc93b = 0 END IF
IF cl_null(g_ccc.ccc93c) THEN LET g_ccc.ccc93c = 0 END IF
IF cl_null(g_ccc.ccc93d) THEN LET g_ccc.ccc93d = 0 END IF
IF cl_null(g_ccc.ccc93e) THEN LET g_ccc.ccc93e = 0 END IF
IF cl_null(g_ccc.ccc93f) THEN LET g_ccc.ccc93f = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc93g) THEN LET g_ccc.ccc93g = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc93h) THEN LET g_ccc.ccc93h = 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc211)  THEN LET g_ccc.ccc211 = 0 END IF
IF cl_null(g_ccc.ccc212)  THEN LET g_ccc.ccc212 = 0 END IF
IF cl_null(g_ccc.ccc213)  THEN LET g_ccc.ccc213 = 0 END IF
IF cl_null(g_ccc.ccc214)  THEN LET g_ccc.ccc214 = 0 END IF
IF cl_null(g_ccc.ccc215)  THEN LET g_ccc.ccc215 = 0 END IF
IF cl_null(g_ccc.ccc221)  THEN LET g_ccc.ccc221 = 0 END IF
IF cl_null(g_ccc.ccc22a1) THEN LET g_ccc.ccc22a1= 0 END IF
IF cl_null(g_ccc.ccc22b1) THEN LET g_ccc.ccc22b1= 0 END IF
IF cl_null(g_ccc.ccc22c1) THEN LET g_ccc.ccc22c1= 0 END IF
IF cl_null(g_ccc.ccc22d1) THEN LET g_ccc.ccc22d1= 0 END IF
IF cl_null(g_ccc.ccc22e1) THEN LET g_ccc.ccc22e1= 0 END IF
IF cl_null(g_ccc.ccc22f1) THEN LET g_ccc.ccc22f1= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g1) THEN LET g_ccc.ccc22g1= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h1) THEN LET g_ccc.ccc22h1= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc222)  THEN LET g_ccc.ccc222 = 0 END IF
IF cl_null(g_ccc.ccc22a2) THEN LET g_ccc.ccc22a2= 0 END IF
IF cl_null(g_ccc.ccc22b2) THEN LET g_ccc.ccc22b2= 0 END IF
IF cl_null(g_ccc.ccc22c2) THEN LET g_ccc.ccc22c2= 0 END IF
IF cl_null(g_ccc.ccc22d2) THEN LET g_ccc.ccc22d2= 0 END IF
IF cl_null(g_ccc.ccc22e2) THEN LET g_ccc.ccc22e2= 0 END IF
IF cl_null(g_ccc.ccc22f2) THEN LET g_ccc.ccc22f2= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g2) THEN LET g_ccc.ccc22g2= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h2) THEN LET g_ccc.ccc22h2= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc223)  THEN LET g_ccc.ccc223 = 0 END IF
IF cl_null(g_ccc.ccc22a3) THEN LET g_ccc.ccc22a3= 0 END IF
IF cl_null(g_ccc.ccc22b3) THEN LET g_ccc.ccc22b3= 0 END IF
IF cl_null(g_ccc.ccc22c3) THEN LET g_ccc.ccc22c3= 0 END IF
IF cl_null(g_ccc.ccc22d3) THEN LET g_ccc.ccc22d3= 0 END IF
IF cl_null(g_ccc.ccc22e3) THEN LET g_ccc.ccc22e3= 0 END IF
IF cl_null(g_ccc.ccc22f3) THEN LET g_ccc.ccc22f3= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g3) THEN LET g_ccc.ccc22g3= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h3) THEN LET g_ccc.ccc22h3= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc224)  THEN LET g_ccc.ccc224 = 0 END IF
IF cl_null(g_ccc.ccc22a4) THEN LET g_ccc.ccc22a4= 0 END IF
IF cl_null(g_ccc.ccc22b4) THEN LET g_ccc.ccc22b4= 0 END IF
IF cl_null(g_ccc.ccc22c4) THEN LET g_ccc.ccc22c4= 0 END IF
IF cl_null(g_ccc.ccc22d4) THEN LET g_ccc.ccc22d4= 0 END IF
IF cl_null(g_ccc.ccc22e4) THEN LET g_ccc.ccc22e4= 0 END IF
IF cl_null(g_ccc.ccc22f4) THEN LET g_ccc.ccc22f4= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g4) THEN LET g_ccc.ccc22g4= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h4) THEN LET g_ccc.ccc22h4= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc225)  THEN LET g_ccc.ccc225 = 0 END IF
IF cl_null(g_ccc.ccc22a5) THEN LET g_ccc.ccc22a5= 0 END IF
IF cl_null(g_ccc.ccc22b5) THEN LET g_ccc.ccc22b5= 0 END IF
IF cl_null(g_ccc.ccc22c5) THEN LET g_ccc.ccc22c5= 0 END IF
IF cl_null(g_ccc.ccc22d5) THEN LET g_ccc.ccc22d5= 0 END IF
IF cl_null(g_ccc.ccc22e5) THEN LET g_ccc.ccc22e5= 0 END IF
IF cl_null(g_ccc.ccc22f5) THEN LET g_ccc.ccc22f5= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22g5) THEN LET g_ccc.ccc22g5= 0 END IF   #FUN-7C0028 add
IF cl_null(g_ccc.ccc22h5) THEN LET g_ccc.ccc22h5= 0 END IF   #FUN-7C0028 add
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/18

#FUN-A90065(S)
FUNCTION p510_dis(p_sfb01,l_cam01_b,l_cam01_e,l_cae03,l_cae041,l_cae07,l_cae08)
   DEFINE cam08_sum   LIKE cam_file.cam08 
   DEFINE l_qty       LIKE type_file.num10
   DEFINE dl_t        LIKE cxz_file.cxz04
   DEFINE oh_t        LIKE cxz_file.cxz05
   DEFINE p_sfb01     LIKE sfb_file.sfb01
   DEFINE l_cam01_b   LIKE cam_file.cam01 
   DEFINE l_cam01_e   LIKE cam_file.cam01 
   DEFINE l_cae03     LIKE cae_file.cae03
   DEFINE l_cae041    LIKE cae_file.cae041
   DEFINE l_cae07     LIKE cae_file.cae07
   DEFINE l_cae08     LIKE cae_file.cae08
   DEFINE l_cac03     LIKE cac_file.cac03

   LET cam08_sum = 0   
   CASE l_cae08 #分攤方式
      WHEN '1' #實際工時
         SELECT SUM(cam08) INTO cam08_sum FROM cam_file,cal_file
          WHERE cam02=l_cae03 AND cam04=g_sfb.sfb01
             AND cam01 BETWEEN l_cam01_b AND l_cam01_e
             AND cal01=cam01 AND cal02=cam02          
            AND calfirm='Y'                          
         IF cam08_sum IS NULL THEN LET cam08_sum=0 END IF
         CASE l_cae041
            WHEN '1'
               LET dl_t=l_cae07*cam08_sum
            OTHERWISE
               LET oh_t=l_cae07*cam08_sum
         END CASE
      WHEN '2' #標準工時
        #start FUN-670037 modify
        #SELECT SUM(cam07) INTO l_qty FROM cam_file
        # WHERE YEAR(cam01)=yy AND MONTH(cam01)=mm
        #   AND cam02=l_cae03  AND cam04=g_sfb.sfb01
        #IF l_qty IS NULL THEN LET l_qty=0 END IF
        #
        ##統計總標準工時
        #OPEN ecb_cur USING l_cae03
        #FETCH ecb_cur INTO l_ecb19,l_ecb21
        #IF STATUS THEN CALL cl_err('ecb_cur',STATUS,0)
        #   LET g_success='N' END IF
        ##CLOSE ecb_cur
        #IF l_ecb19 IS NULL THEN LET l_ecb19=0 END IF
      
        #IF l_ecb21 IS NULL THEN LET l_ecb21=0 END IF
        #CASE l_caa04
        #  WHEN '1'  LET l_index_dl=l_qty*l_ecb19
        #            LET  dl_t=l_index_dl*l_cae07   #人工
        #  WHEN '2'  LET l_index_oh=l_qty*l_ecb21
        #            LET  oh_t=l_index_oh*l_cae07   #製費
        #  EXIT CASE
        #END CASE
         #FUN-A90065(S)
          SELECT SUM(cam10) INTO cam08_sum FROM cal_file,cam_file
           WHERE cam01 BETWEEN l_cam01_b AND l_cam01_e
             AND cam02=l_cae03  AND cam04=g_sfb.sfb01
             AND cal01=cam01 AND cal02=cam02 AND calfirm='Y'
          IF cl_null(cam08_sum) THEN LET cam08_sum = 0 END IF
         #FUN-A90065(E)
         CASE l_cae041
            WHEN '1'    #人工
               LET  dl_t=cam08_sum*l_cae07    #人工
             OTHERWISE   #製費1-5
               LET  oh_t=cam08_sum*l_cae07    #製費
         END CASE
      #FUN-A90065(S)
      WHEN '3'  #標準機時  
         SELECT SUM(cam11) INTO cam08_sum FROM cal_file,cam_file
          WHERE cam01 BETWEEN l_cam01_b AND l_cam01_e
            AND cam02=l_cae03  AND cam04=g_sfb.sfb01
            AND cal01=cam01 AND cal02=cam02 AND calfirm='Y'
         IF cl_null(cam08_sum) THEN LET cam08_sum = 0 END IF
         CASE l_cae041
            WHEN '1'    #人工
               LET  dl_t=cam08_sum*l_cae07    #人工
            OTHERWISE   #製費1-5
               LET  oh_t=cam08_sum*l_cae07    #製費
         END CASE
      #FUN-A90065(E)
      WHEN '4'  #產出數量x分攤權數    #FUN-A90065
         SELECT SUM(cam07) INTO l_qty  FROM cal_file,cam_file
          WHERE cam02=l_cae03 AND cam04=g_sfb.sfb01
            AND cam01 BETWEEN l_cam01_b AND l_cam01_e
            AND cal01=cam01 AND cal02=cam02 AND calfirm='Y'
         IF l_qty IS NULL THEN LET l_qty=0 END IF
         SELECT cac03 INTO l_cac03 FROM cac_file
          WHERE cac01=l_cae03 AND cac02=l_cae04
         IF l_cac03 IS NULL THEN LET l_cac03=0 END IF
         CASE l_cae041
            WHEN '1'
               LET dl_t=l_qty*l_cac03*l_cae07
           OTHERWISE
               LET oh_t=l_qty*l_cac03*l_cae07
         END CASE
      #FUN-A90065(S)
      WHEN '5'   #實際機時  
         SELECT SUM(cam081) INTO cam08_sum FROM cal_file,cam_file
          WHERE cam01 BETWEEN l_cam01_b AND l_cam01_e
            AND cam02=l_cae03  AND cam04=g_sfb.sfb01
            AND cal01=cam01 AND cal02=cam02 AND calfirm='Y'
         IF cl_null(cam08_sum) THEN LET cam08_sum = 0 END IF
         CASE l_cae041
            WHEN '1'     #人工
               LET dl_t=cam08_sum*l_cae07    #人工
             OTHERWISE   #製費1-5
               LET oh_t=cam08_sum*l_cae07    #製費
         END CASE
      #FUN-A90065(E)
   END CASE
   RETURN dl_t,oh_t
END FUNCTION
#FUN-A90065(E)

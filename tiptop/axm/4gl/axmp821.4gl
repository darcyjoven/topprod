# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp821.4gl
# Descriptions...: 三角貿易出貨通知單拋轉作業
# Date & Author..: 06/08/09 BY yiting 
# Modify.........: No.FUN-680137 06/09/08 By ice 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/11/06 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-670007 BY yiting 
# Modify.........: No.FUN-710046 07/01/23 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-740042 07/04/19 By claire 考慮單身合併訂單狀況
# Modify.........: no.MOD-780191 07/08/29 by Yiting 拋轉時需檢查單別設定 
# MOdify.........: No.CHI-790001 07/09/02 By Nicole 修正Insert Into Error
# Modify.........: No.MOD-7A0051 07/10/09 By Claire Invoice單身應以(計價數量*單價)而非(數量*單價)
# Modify.........: No.FUN-7B0091 07/11/19 By Sarah oga65預設值抓oea65
# Modify.........: No.TQC-7C0064 07/12/08 By Beryl 判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: No.MOD-860201 08/06/19 By claire INSERT INTO ofb_file時,g_ofb.ofb13為null
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.MOD-940299 09/05/07 By Dido 科目別改用多角流程設定
# Modify.........: No.MOD-960050 09/06/04 By Carrier 拋轉不成功，由于l_dbs_new無值對應
# Modify.........: No.FUN-980010 09/08/28 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980253 09/08/28 By Dido 語法調整
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980092 09/09/21 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-950020 09/10/21 By chenmoyan 将自定义栏位的值抛转各站
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No:MOD-9C0139 09/12/19 By Dido 增加 rvbs13 為 0 
# Modify.........: No:MOD-9C0268 09/12/19 By Dido l_sql 宣告改為 STRING 
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:FUN-9C0071 10/01/15 By huangrh 精簡程式
# Modify.........: No:CHI-940042 10/01/19 By Dido 參考 oea18 設定出通與invoice匯率 
# Modify.........: No:CHI-A10025 10/01/25 By Dido 訊息調整;增加ofb916,ofb917;金額邏輯調整 
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:MOD-A50103 10/05/17 By Smapmin oga55沒有一併拋轉
# Modify.........: No:TQC-A50138 10/05/25 By houlia 出貨單號增加開窗查詢
# Modify.........: No:-A50138 10/05/25 By houlia
# Modify.........: No:FUN-A50102 10/06/09 by lixh1  跨庫統一用cl_get_target_table()實現
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.MOD-B30267 11/03/12 By chenying invoice取價時，單別改抓poy48
# Modify.........: No:FUN-B90012 11/09/15 By lixh1 多角增加ICD行業
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No:MOD-C30663 12/03/14 By ck2yuan tlfs07單位應寫img09
# Modify.........: No.CHI-C40031 12/05/24 By Sakura 走多倉出貨改為抓取ogc、ogg轉換率,若為多倉儲時,rvbs022 應累增
# Modify.........: No:CHI-C50021 12/06/12 By Sakura INSERT INTO oga_file前加入 LET l_oga.oga69=g_oga.oga69
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No.CHI-C80009 12/08/15 By Sakura 出貨通知單由來原營運中心拋到目的運中心時，倉儲批應該與目的一致
# Modify.........: No.CHI-C80009 12/08/15 By Sakura 一批號多DATECODE功能時,FOREACH需多傳倉儲批
# Modify.........: No.FUN-C50136 12/08/27 By xianghui 拋磚時如果做信用管控要做信用管控處理
# Modify.........: No.FUN-C80001 12/08/29 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oga   RECORD LIKE oga_file.*    #出貨單(來源)
DEFINE g_ogb   RECORD LIKE ogb_file.*    #出貨單(來源)
DEFINE l_oga   RECORD LIKE oga_file.*    #出貨單(各廠)
DEFINE l_ogb   RECORD LIKE ogb_file.*    #出貨單(各廠)
DEFINE t_oga   RECORD LIKE oga_file.*    #出貨通知單(來源)
DEFINE t_ogb   RECORD LIKE ogb_file.*    #出貨通知單(來源)
DEFINE x_oga   RECORD LIKE oga_file.*    #出貨通知單(各廠)
DEFINE x_ogb   RECORD LIKE ogb_file.*    #出貨通知單(各廠)
DEFINE g_ogd   RECORD LIKE ogd_file.*
DEFINE g_ofa   RECORD LIKE ofa_file.*
DEFINE g_ofb   RECORD LIKE ofb_file.*
DEFINE l_oea   RECORD LIKE oea_file.*
DEFINE l_oeb   RECORD LIKE oeb_file.*
DEFINE l_rvb   RECORD LIKE rvb_file.*
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE g_oan   RECORD LIKE oan_file.*
DEFINE l_oha   RECORD LIKE oha_file.*    #NO.FUN-620024
DEFINE l_ohb   RECORD LIKE ohb_file.*    #NO.FUN-620024
DEFINE g_poz   RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.7993
DEFINE g_poy   RECORD LIKE poy_file.*    #流程代碼資料(單身) No.7993
DEFINE s_poy   RECORD LIKE poy_file.*    #來源流程資料(單身) No.7993
DEFINE tm RECORD
          wc    LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(600) 
       END RECORD
DEFINE p_pmm09  LIKE pmm_file.pmm09,    #廠商代號
       p_oea03  LIKE oea_file.oea03,    #客戶代號
       p_poy04  LIKE poy_file.poy04,    #工廠編號
       p_poz03  LIKE poz_file.poz03,    #申報方式
       p_poy06  LIKE poy_file.poy06,    #付款條件
       p_poy07  LIKE poy_file.poy07,    #收款條件
       p_poy08  LIKE poy_file.poy08,    #SO稅別
       p_poy09  LIKE poy_file.poy09,    #PO稅別
       p_poy10  LIKE poy_file.poy10,    #銷售分類
       p_poy12  LIKE poy_file.poy12,    #發票別
       p_poy16  LIKE poy_file.poy16,    #AR科目類別 #MOD-940299
       p_poy28  LIKE poy_file.poy28,    #出貨理由碼 #NO.FUN-620024
       p_poy29  LIKE poy_file.poy29,    #代送商編號 #NO.FUN-620024
       p_pox03  LIKE pox_file.pox03,    #計價基準
       p_pox05  LIKE pox_file.pox05,    #計價方式
       p_pox06  LIKE pox_file.pox06,    #計價比率
       p_azi01  LIKE azi_file.azi01,    #計價幣別 
       p_imd01  LIKE imd_file.imd01,    #各廠預設倉庫
       s_imd01  LIKE imd_file.imd01,    #各廠預設倉庫(來源)
       p_oea911 LIKE oea_file.oea911,   #送貨客戶代號
       p_cnt    LIKE type_file.num5     #計價方式符合筆數 #No.FUN-680137 SMALLINT
  DEFINE g_flow99 LIKE oga_file.oga99   #多角序號   #FUN-560043 #No.FUN-680137 VARCHAR(17)
  DEFINE t_dbs    LIKE type_file.chr21  #來源廠 DataBase Name #No.FUN-680137 VARCHAR(21)
  DEFINE t_plant  LIKE type_file.chr10  #來源廠 Plant #No.FUN-980020
  DEFINE s_dbs_new LIKE type_file.chr21 #New DataBase Name #No.FUN-680137 VARCHAR(21)
  DEFINE s_plant_new LIKE type_file.chr10  #FUN-980020
  DEFINE l_dbs_new LIKE type_file.chr21  #New DataBase Name #No.FUN-680137 VARCHAR(21)
  DEFINE l_aza  RECORD LIKE aza_file.*
  DEFINE s_aza  RECORD LIKE aza_file.*
  DEFINE s_azp  RECORD LIKE azp_file.*
  DEFINE l_azp  RECORD LIKE azp_file.*
  DEFINE s_azi  RECORD LIKE azi_file.*
  DEFINE l_azi  RECORD LIKE azi_file.*
  DEFINE g_sw   LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
  DEFINE g_argv1  LIKE oga_file.oga01
  DEFINE p_last   LIKE type_file.num5   #流程之最後家數 #No.FUN-680137 SMALLINT
  DEFINE p_last_plant LIKE azp_file.azp01 #No.FUN-680137 VARCHAR(10)
  DEFINE g_t1     LIKE oay_file.oayslip  #No.FUN-550070 #No.FUN-680137 VARCHAR(05)
  DEFINE l_t      LIKE oay_file.oayslip  #No.FUN-620024   #No.FUN-680137 VARCHAR(05)
  DEFINE oga_t1   LIKE oay_file.oayslip  #No.FUN-550070   #No.FUN-680137 VARCHAR(05)
  DEFINE rva_t1   LIKE oay_file.oayslip   #No.FUN-550070   #No.FUN-680137 VARCHAR(05)
  DEFINE rvu_t1   LIKE oay_file.oayslip   #No.FUN-550070   #No.FUN-680137 VARCHAR(05)
  DEFINE g_ima906 LIKE ima_file.ima906   #FUN-560043
  DEFINE g_oha01  LIKE oha_file.oha01    #銷退單號   #NO.FUN-620024
  DEFINE g_oay18  LIKE oay_file.oay18    #銷退理由碼 #NO.FUN-620024
 
DEFINE g_cnt      LIKE type_file.num10   #No.FUN-680137 INTEGER
DEFINE g_msg      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE g_oea99    LIKE oea_file.oea99    #MOD-740042  #合併訂單出貨
DEFINE g_ima918   LIKE ima_file.ima918  #No.FUN-850100
DEFINE g_ima921   LIKE ima_file.ima921  #No.FUN-850100
DEFINE l_rvbs     RECORD LIKE rvbs_file.*  #No.FUN-850100
DEFINE gp_legal   LIKE azw_file.azw02    #FUN-980010 add
DEFINE gp_plant   LIKE azp_file.azp01    #FUN-980010 add
DEFINE l_dbs_tra  LIKE azw_file.azw05    #FUN-980092 add
DEFINE s_dbs_tra  LIKE azw_file.azw05    #FUN-980092 add
DEFINE g_ogg      RECORD LIKE ogg_file.*  #CHI-C40031 add
DEFINE g_ogc      RECORD LIKE ogc_file.*  #CHI-C40031 add
 
MAIN
   OPTIONS                               #改變一些系統預設值
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT                      #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_argv1 = ARG_VAL(1)
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
      CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818   #NO.CHI-6A0094 
    IF cl_null(g_oax.oax01) THEN       #三角貿易使用匯率
       LET g_oax.oax01='S'
    END IF
    LET t_plant = g_plant              #FUN-980020
    LET t_dbs = g_dbs CLIPPED,':'
    #若有傳參數則不用輸入畫面
    IF cl_null(g_argv1) THEN
       CALL p821_p1()
       CLOSE WINDOW p821_w
    ELSE
       OPEN WINDOW p821_w WITH FORM "axm/42f/axmp821" 
             ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
       CALL cl_ui_init()
       LET tm.wc = " oga01='",g_argv1,"' " 
 
       CALL p821_p2()
 
       CLOSE WINDOW p821_w
    END IF
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818   #NO.CHI-6A0094 
END MAIN
 
FUNCTION p821_p1()
 DEFINE l_ac   LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
    OPEN WINDOW p821_w WITH FORM "axm/42f/axmp821" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
    
 
    CALL cl_opmsg('z')
 
 WHILE TRUE
    LET g_action_choice = ''
 
    CONSTRUCT BY NAME tm.wc ON oga01,oga02 
 
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
#TQC-A50138 --add
       ON ACTION controlp
           CASE
              WHEN INFIELD(oga01)   #出貨單號
                   CALL cl_init_qry_var()
                   LET g_qryparam.form ="q_oga_01"
                   LET g_qryparam.default1 = g_oga.oga01
                   CALL cl_create_qry() RETURNING g_oga.oga01
                   DISPLAY BY NAME g_oga.oga01
                   NEXT FIELD oga01
            END CASE
#TQC-A50138 --end
 
       ON ACTION locale
          LET g_action_choice='locale'
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          EXIT CONSTRUCT
       ON ACTION exit
          LET INT_FLAG = 1
          EXIT CONSTRUCT
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
    
         ON ACTION qbe_select
            CALL cl_qbe_select()
 
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
    END CONSTRUCT
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
    IF g_action_choice = 'locale' THEN
       CALL cl_dynamic_locale()
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    IF cl_sure(0,0) THEN
       CALL p821_p2()
       IF g_success = 'Y' THEN
          CALL cl_end2(1) RETURNING l_flag
       ELSE
          CALL cl_end2(2) RETURNING l_flag
       END IF
       IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
    END IF
 END WHILE
 CLOSE WINDOW p821_w
END FUNCTION
 
FUNCTION p821_p2()
  DEFINE l_pmm  RECORD LIKE pmm_file.*
  DEFINE l_pmn  RECORD LIKE pmn_file.*
  DEFINE l_occ  RECORD LIKE occ_file.*
  DEFINE l_pmc  RECORD LIKE pmc_file.*
  DEFINE l_gec  RECORD LIKE gec_file.*
  DEFINE l_ima  RECORD LIKE ima_file.*
  DEFINE #l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
         l_sql,l_sql1,l_sql2    STRING     #NO.FUN-910082
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_j    LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_msg  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
  DEFINE l_oea62 LIKE oea_file.oea62
  DEFINE s_oea62 LIKE oea_file.oea62
  DEFINE l_oeb24 LIKE oeb_file.oeb24 
  DEFINE l_occ02 LIKE occ_file.occ02,
         l_occ08 LIKE occ_file.occ08,
         l_occ11 LIKE occ_file.occ11
  DEFINE p_i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_no    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13,
         l_currm LIKE pmm_file.pmm42,      #計價幣別依原始來源廠的匯率
         x_currm LIKE pmm_file.pmm42,
         l_curr  LIKE pmm_file.pmm22      #No.FUN-680137 VARCHAR(04)
  DEFINE l_x     LIKE type_file.chr3     #No.FUN-620024   #No.FUN-680137 VARCHAR(3)
  DEFINE p_oeb   RECORD LIKE oeb_file.*
  DEFINE l_ogd01 LIKE ogd_file.ogd01       #包裝單號
  DEFINE g_ogd01 LIKE ogd_file.ogd01       #包裝單號
  DEFINE l_ofa01 LIKE ofa_file.ofa01       #INVOICE 單號
  DEFINE l_ogdi  RECORD LIKE ogdi_file.*   #NO.FUN-7B0018
  DEFINE l_oea99 LIKE oea_file.oea99       #MOD-860201 add
  DEFINE li_result LIKE type_file.num5     #TQC-9B0013
 
  CALL cl_wait() 
  BEGIN WORK 
  LET g_success='Y'
  CREATE TEMP TABLE p821_file(
         p_no       LIKE type_file.num5,  
         pab_no     LIKE ogb_file.ogb01,    #No.FUN-550018
         pab_item   LIKE ogb_file.ogb03,
         pab_price  LIKE ogb_file.ogb13,    #FUN-4C0006
         pab_curr   LIKE oga_file.oga23,
         pab_type   LIKE type_file.chr1); #1->出貨單  2->Invoice
  DELETE FROM p821_file
 #-CHI-A10025-add-
  LET l_cnt = 0                                                                                                       
  LET l_sql = "SELECT COUNT(*) FROM oga_file ",                                                           
              " WHERE oga909='Y' ",    #三角貿易出貨單
               " AND oga905='N'  ",    #拋轉否
               " AND oga906='Y' ",     #必須為起始出貨單
               " AND oga09='5'  ",     #單據別=5三角貿易出貨通知單
               " AND ",tm.wc CLIPPED
  IF cl_null(g_argv1) THEN LET l_sql = l_sql ," AND ogaconf = 'Y'" END IF
  PREPARE oga_p FROM l_sql                                                                                         
  EXECUTE oga_p INTO l_cnt                                                                                         
  IF l_cnt=0 THEN
     LET g_success = 'N'  
     CALL cl_err('','mfg9169',1) 
     RETURN
  END IF
 #-CHI-A10025-end-
  #讀取符合條件之三角貿易訂單資料
  LET l_sql="SELECT * FROM oga_file ",
            " WHERE oga909='Y' ",    #三角貿易出貨單
             " AND oga905='N'  ",    #拋轉否
             " AND oga906='Y' ",     #必須為起始出貨單
             " AND oga09='5'  ",     #單據別=5三角貿易出貨通知單
             " AND ",tm.wc CLIPPED
  IF cl_null(g_argv1) THEN LET l_sql = l_sql ," AND ogaconf = 'Y'" END IF
  PREPARE p821_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('pre1',SQLCA.SQLCODE,1) END IF
  DECLARE p821_curs1 CURSOR FOR p821_p1
  CALL s_showmsg_init()   #No.FUN-710046
  FOREACH p821_curs1 INTO g_oga.*
     IF SQLCA.SQLCODE <> 0 THEN   
        LET g_success='N'            #CHI-A10025 
        EXIT FOREACH
     END IF
     IF g_success='N' THEN                                                                                                         
        LET g_totsuccess='N'                                                                                                       
        LET g_success="Y"                                                                                                          
     END IF                                                                                                                        
 
     IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
        #只讀取第一筆訂單之資料
        LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                    "  WHERE oea01 = ogb31 ",
                    "    AND ogb01 = '",g_oga.oga01,"'",
                    "    AND oeaconf = 'Y' "  #01/08/16 mandy
        PREPARE oea_pre FROM l_sql1
        DECLARE oea_f CURSOR FOR oea_pre
        OPEN oea_f 
        FETCH oea_f INTO g_oea.*
     ELSE
        #讀取該出貨單之訂單
        SELECT * INTO g_oea.*
          FROM oea_file
         WHERE oea01 = g_oga.oga16
           AND oeaconf = 'Y' #01/08/16 mandy
     END IF
     #檢查各工廠關帳日(sma53)
     IF s_mchksma53(g_oea.oea904,g_oga.oga02) THEN
        LET g_success='N' 
        CONTINUE FOREACH #No.FUN-710046
     END IF
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 AND poz00='1'
     IF SQLCA.sqlcode THEN
         LET g_showmsg = g_oea.oea904,"/",'0'                             #No.FUN-710046
         CALL s_errmsg('poz01,poz00',g_showmsg,g_oea.oea904,'axm-418',1)  #No.FUN-710046
         LET g_success = 'N'
         CONTINUE FOREACH #No.FUN-710046
     END IF
     IF g_poz.pozacti = 'N' THEN 
         CALL s_errmsg('','',g_oea.oea904,'tri-009',1) #No.FUN-710046
         LET g_success = 'N'
         CONTINUE FOREACH #No.FUN-710046
     END IF
     IF g_poz.poz011 = '2' THEN
        CALL s_errmsg('','','','axm-411',1)  #No.FUN-710046
        LET g_success = 'N'
        CONTINUE FOREACH #No.FUN-710046
     END IF
     CALL p821_flow99()                                   #No.7993 取得多角序號
     CALL s_mtrade_last_plant(g_oea.oea904) 
                 RETURNING p_last,p_last_plant    #記錄最後一筆之家數
     LET s_oea62=0
     #依流程代碼最多6層
     FOR i = 0 TO p_last
         IF i = 0 THEN CONTINUE FOR END IF
         #得到廠商/客戶代碼及database
         CALL p821_azp(i)      
 
         LET gp_plant = s_poy.poy04                    #FUN-980010 add
         CALL s_getlegal(gp_plant) RETURNING gp_legal  #FUN-980010 add
 
         #LET l_sql2 = "INSERT INTO ",s_dbs_tra CLIPPED,"rvbs_file",  #No.MOD-960050 #FUN-980092 add  #FUN-A50102
         LET l_sql2 = "INSERT INTO ",cl_get_target_table(s_plant_new,'rvbs_file'),    #FUN-A50102
                      "(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,",
                      " rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,rvbs13,",         #MOD-9C0139  
                      " rvbsplant,rvbslegal) ", #FUN-980010	#MOD-980253
                      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?) "  #FUN-980010    #MOD-9C0139
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
         PREPARE ins_rvbs FROM l_sql2
 
             LET g_t1 = s_get_doc_no(g_oga.oga01)         #No.FUN-550070 
             CALL s_mutislip('4','',g_t1,g_poz.poz01,i)                      
                  RETURNING g_sw,oga_t1,rva_t1,rvu_t1,l_x,l_x   #No.7993
             IF g_sw THEN 
                LET g_success = 'N' EXIT FOREACH 
             END IF 
             IF cl_null(oga_t1) THEN
                 CALL cl_err('','axm4014',1)
                 LET g_success = 'N'
                 EXIT FOREACH
             ELSE                                                                                                                   
                LET l_cnt = 0                                                                                                       
 #               LET l_sql = "SELECT COUNT(*) FROM ",s_dbs_new,"oay_file ",  #No.MOD-960050   #FUN-A50102
                LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(s_plant_new, 'oay_file' ),  #FUN-A50102
                " WHERE oayslip = '",oga_t1,"'"                                                                         
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, s_plant_new ) RETURNING l_sql     #FUN-A50102   
                PREPARE oay_pre1 FROM l_sql                                                                                         
                EXECUTE oay_pre1 INTO l_cnt                                                                                         
                IF l_cnt = 0 THEN                                                                                                   
                   LET g_msg = s_dbs_new CLIPPED,oga_t1 CLIPPED    #No.MOD-960050
                   CALL cl_err(g_msg,'axm-931',1)                  #No.MOD-960050
                   LET g_success = 'N'                                                                                              
                   EXIT FOREACH                                                                                                     
                END IF                                                                                                              
             END IF
         CALL p821_chk99()                       #No.7993
         CALL p820_azi(g_oea.oea23,s_dbs_new)              #讀取幣別資料  #FUN-670007
         CALL p821_oea911(i) RETURNING p_oea911  #讀取送貨客戶
         #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
         IF s_aza.aza50 ='N' THEN     #NO.FUN-620024
            CALL s_pox(g_oea.oea904,i,g_oga.oga02)
                 RETURNING p_pox03,p_pox05,p_pox06,p_cnt
         END IF                       #NO.FUN-620024
         #新增出貨通知單單單頭檔(oga_file)
         CALL p821_ogains() 
         LET l_oea62=0
 
         #讀取出貨通知單身檔(ogb_file)
         DECLARE  ogb_cus CURSOR FOR
            SELECT ogb_file.*,oea_file.oea99 #MOD-740042 modify oea99  
              FROM ogb_file,oea_file         #MOD-740042 modify oea_file
             WHERE ogb01 = g_oga.oga01
               AND ogb1005='1' #TQC-650089
               AND ogb31 = oea01             #MOD-740042 add
         FOREACH ogb_cus INTO g_ogb.* ,g_oea99  #MOD-740042
            IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF 
 
            SELECT ima906 INTO g_ima906 FROM ima_file 
             WHERE ima01 = g_ogb.ogb04
 
            #新增出貨通知單單身檔(ogb_file)
            CALL p821_ogbins(i) 
         END FOREACH
         #---------------- 是否拋轉 Packing List ----------------------
         IF g_oax.oax05='Y' AND g_oaz.oaz67 ='1' THEN   #NO.FUN-670007
            SELECT COUNT(*) INTO l_cnt FROM ogd_file,oga_file
             WHERE ogd01=oga01 AND oga16=g_oga.oga16 AND oga30='Y'
            IF l_cnt > 0  AND g_oaz.oaz67 = '1' THEN  #有輸入Packing List才拋轉
                 LET l_ogd01 = l_oga.oga01    #No.7993
                 LET g_ogd01 = g_oga.oga01
              DECLARE ogd_cs CURSOR FOR 
               SELECT * FROM ogd_file 
                WHERE ogd01=g_ogd01
              FOREACH ogd_cs INTO g_ogd.*
                 IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF 
                 #新增Packing List
                 LET g_ogd.ogd01 = l_ogd01
                 IF cl_null(g_ogd.ogd01) THEN LET g_ogd.ogd01=' ' END IF
 
               #  LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"ogd_file",  #FUN-980092 add    #FUN-A50102
                 LET l_sql2="INSERT INTO ",cl_get_target_table( s_plant_new, 'ogd_file' ),    #FUN-A50102
                  "(ogd01,ogd03,ogd04,ogd08,ogd09, ",
                            " ogd10,ogd11,ogd12b,ogd12e,ogd13, ",
                            " ogd14,ogd15,ogd16,ogd14t,ogd15t, ",
                            " ogd16t,",
                            " ogdplant,ogdlegal) ",  #FUN-980010
                            " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                            "         ?,  ?,? )"     #FUN-980010
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, s_plant_new ) RETURNING l_sql2   #FUN-A50102 
                 PREPARE ins_ogd FROM l_sql2
                 EXECUTE ins_ogd USING 
                  g_ogd.ogd01,g_ogd.ogd03,g_ogd.ogd04,g_ogd.ogd08,g_ogd.ogd09,
                  g_ogd.ogd10,g_ogd.ogd11,g_ogd.ogd12b,g_ogd.ogd12e,
                  g_ogd.ogd13,
                  g_ogd.ogd14,g_ogd.ogd15,g_ogd.ogd16,g_ogd.ogd14t,
                  g_ogd.ogd15t,g_ogd.ogd16t,
                  gp_plant,gp_legal   #FUN-980010
                  IF SQLCA.sqlcode<>0 THEN
                     LET g_showmsg = g_ogd.ogd01,"/",g_ogd.ogd03,"/",g_ogd.ogd04             #No.FUN-710046
                     CALL s_errmsg('ogd01,ogd03,ogd04',g_showmsg,'ins ogd:',SQLCA.sqlcode,1) #No.FUN-710046
                     LET g_success = 'N' EXIT FOREACH 
                  END IF
                 IF NOT s_industry('std') THEN
                    INITIALIZE l_ogdi.* TO NULL
                    LET l_ogdi.ogdi01 = g_ogd.ogd01
                    LET l_ogdi.ogdi03 = g_ogd.ogd03
                    LET l_ogdi.ogdi04 = g_ogd.ogd04
                    IF NOT s_ins_ogdi(l_ogdi.*,s_plant_new) THEN #FUN-980092 add
                       LET g_success = 'N'
                    END IF
                 END IF
              END FOREACH
              #更新包裝單確認碼
              #LET l_sql2="UPDATE ",s_dbs_tra CLIPPED,"oga_file",   #FUN-980092 add   #FUN-A50102
              LET l_sql2="UPDATE ",cl_get_target_table( s_plant_new, 'oga_file' ),    #FUN-A50102
               " SET oga30 = 'Y' ",
                         " WHERE oga01 = ?  "
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
              PREPARE upd_oga30 FROM l_sql2
              EXECUTE upd_oga30 USING l_ogd01
              IF SQLCA.sqlcode<>0 THEN
                 CALL s_errmsg('oga01',l_ogd01,'upd oga30:',SQLCA.sqlcode,1) #No.FUN-710046
                 LET g_success = 'N' EXIT FOR
              END IF
            END IF
         END IF
         #------------- 是否拋轉 Invoice --------------------------
         IF g_oax.oax04='Y' AND g_oaz.oaz67 = '1'  THEN  #NO.FUN-670007
             SELECT COUNT(*) INTO l_cnt FROM ofa_file,ofb_file
              WHERE ofa01=g_oga.oga27 AND ofaconf='Y'
             IF l_cnt = 0 THEN
                LET g_showmsg = g_oga.oga27,"/",'Y'     #No.FUN-710046
                CALL s_errmsg('ofa01,ofaconf',g_showmsg,'sel ofa:',SQLCA.SQLCODE,1) #No.FUN-710046
                LET g_success='N' EXIT FOR
             ELSE
                #---INSERT Invoice 單頭檔
                SELECT * INTO g_ofa.* FROM ofa_file
                 WHERE ofa01 = g_oga.oga27
                LET g_t1 = s_get_doc_no(g_poy.poy48)         #No.FUN-550070  #MOD-B30267 g_oga.oga27-->g_poy.poy48
                    CALL s_auto_assign_no("axm",g_t1,g_ofa.ofa02,"","ofa_file","ofa01",s_plant_new,"","") #NO.FUN-620024 #FUN-980092 add
                    RETURNING li_result,l_ofa01
                IF (NOT li_result) THEN 
                   LET g_msg = s_plant_new CLIPPED,l_ofa01
                   CALL s_errmsg("ofa01",l_ofa01,g_msg CLIPPED,"mfg3046",1) 
                   LET g_success ='N'
                   RETURN
                END IF   
                LET g_ofa.ofa03=l_oea.oea03
                # 取得帳款客戶之 BILL TO 相關資料
                #LET l_sql = " SELECT * FROM ",s_dbs_new CLIPPED,"occ_file ",   #FUN-A50102
                LET l_sql = " SELECT * FROM ",cl_get_target_table( s_plant_new, 'occ_file' ),   #FUN-A50102
                  "  WHERE occ01 = '",g_ofa.ofa03,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, s_plant_new ) RETURNING l_sql     #FUN-A50102 
                PREPARE occ_pre FROM l_sql
                DECLARE occ_cs CURSOR FOR occ_pre
                OPEN occ_cs 
                FETCH occ_cs INTO l_occ.*
                IF SQLCA.SQLCODE THEN
                   CALL s_errmsg('','',s_dbs_new CLIPPED,'anm-045',1)  #No.FUN-710046
                   DISPLAy "17"
                   LET g_success = 'N' EXIT FOR
                END IF
                LET g_ofa.ofa032  = l_occ.occ02
                LET g_ofa.ofa0351 = l_occ.occ18
                LET g_ofa.ofa0352 = l_occ.occ19
                LET g_ofa.ofa0353 = l_occ.occ231
                LET g_ofa.ofa0354 = l_occ.occ232
                LET g_ofa.ofa0355 = l_occ.occ233
                LET g_ofa.ofa04=l_oga.oga04   #FUN-670007
                LET g_ofa.ofa23=l_oga.oga23
                LET g_ofa.ofa24=l_oga.oga24
               #-CHI-940042-add-  
                IF l_oea.oea18 IS NOT NULL AND l_oea.oea18='Y' THEN
                   LET g_ofa.ofa24 = l_oea.oea24
                END IF
                IF cl_null(g_ofa.ofa24) THEN LET g_ofa.ofa24=1 END IF
               #-CHI-940042-end-  
                LET g_ofa.ofa99=g_flow99         #No.7993
                LET g_ofa.ofa32=p_poy07
                LET g_ofa.ofa011=l_oga.oga01   
              # LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"ofa_file",  #FUN-980092 add   #FUN-A50102
                LET l_sql2="INSERT INTO ",cl_get_target_table( s_plant_new, 'ofa_file' ),   #FUN-A50102
                            " (ofa00,ofa01,ofa011,ofa02,ofa03,",
                            "  ofa032,ofa033,ofa0351,ofa0352,ofa0353,",
                            "  ofa0354,ofa0355,ofa04,ofa044,ofa0451, ",
                            "  ofa0452,ofa0453,ofa0454,ofa0455,ofa08, ",
                            "  ofa10,ofa16,ofa18,ofa21,ofa211, ",
                            "  ofa212,ofa213,ofa23,ofa24,ofa25, ",
                            "  ofa26,ofa27,ofa28,ofa29,ofa30, ",
                            "  ofa31,ofa32,ofa33,ofa35,ofa36, ",
                            "  ofa37,ofa38,ofa39,ofa41,ofa99, ", #No.7993
                            "  ofa42,ofa43,ofa44,ofa45,ofa46, ",
                            "  ofa47,ofa48,ofa49,ofa50,ofa61, ",
                            "  ofa62,ofa63,ofa71,ofa72,ofa73, ",
                            "  ofa741,ofa742,ofa743,ofa75,ofa76, ",
                            "  ofa77,ofa78,ofa79,ofa908,ofaconf, ",
                            "  ofaprsw,ofauser,ofagrup,ofamodu,ofadate, ",
                            "  ofaplant,ofalegal , ",
                            "  ofaud01,ofaud02,ofaud03,ofaud04,ofaud05,",
                            "  ofaud06,ofaud07,ofaud08,ofaud09,ofaud10,",
                            "  ofaud11,ofaud12,ofaud13,ofaud14,ofaud15,ofaoriu,ofaorig)", #FUN-A10036
                            " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                            "        ?,?,?,?,?, ?,?,?,?,?, ",
                            "        ?,?,?,?,?, ?,?,?,?,?, ",
                            "        ?,?,?,?,?, ?,?,?,?,?, ",
                            "        ?,?,?,?,?, ?,?,?,?,?, ",
                            "        ?,?,?,?,?, ?,?,?,?,?, ",
                            "        ?,?,?,?,?, ?,?,?,?,?,  ",
                            "        ?,?,?,?,?, ?,?,?,?,?, ", #No.CHI-950020
                            "        ?,?,?,?,?,  ",           #No.CHI-950020
                            "        ?,?,?,?,?, ?,?,?,?) "    #FUN-980010#FUN-A10036
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, s_plant_new ) RETURNING l_sql2   #FUN-A50102
                 PREPARE ins_ofa FROM l_sql2
                 EXECUTE ins_ofa USING 
                          g_ofa.ofa00,l_ofa01,g_ofa.ofa011,g_ofa.ofa02,
                          g_ofa.ofa03,
                          g_ofa.ofa032,g_ofa.ofa033,g_ofa.ofa0351,
                          g_ofa.ofa0352,g_ofa.ofa0353,
                          g_ofa.ofa0354,g_ofa.ofa0355,g_ofa.ofa04,
                          g_ofa.ofa044,g_ofa.ofa0451,
                          g_ofa.ofa0452,g_ofa.ofa0453,g_ofa.ofa0454,
                          g_ofa.ofa0455,g_ofa.ofa08,
                          g_ofa.ofa10,g_ofa.ofa16,g_ofa.ofa18,g_ofa.ofa21,
                          g_ofa.ofa211,
                          g_ofa.ofa212,g_ofa.ofa213,g_ofa.ofa23,g_ofa.ofa24,
                          g_ofa.ofa25,
                          g_ofa.ofa26,g_ofa.ofa27,g_ofa.ofa28,g_ofa.ofa29,
                          g_ofa.ofa30,
                          g_ofa.ofa31,g_ofa.ofa32,g_ofa.ofa33,g_ofa.ofa35,
                          g_ofa.ofa36,
                          g_ofa.ofa37,g_ofa.ofa38,g_ofa.ofa39,
                          g_ofa.ofa41,g_ofa.ofa99,
                          g_ofa.ofa42,g_ofa.ofa43,g_ofa.ofa44,g_ofa.ofa45,
                          g_ofa.ofa46,
                          g_ofa.ofa47,g_ofa.ofa48,g_ofa.ofa49,g_ofa.ofa50,
                          g_ofa.ofa61,
                          g_ofa.ofa62,g_ofa.ofa63,g_ofa.ofa71,g_ofa.ofa72,
                          g_ofa.ofa73,
                          g_ofa.ofa741,g_ofa.ofa742,g_ofa.ofa743,g_ofa.ofa75,
                          g_ofa.ofa76,
                          g_ofa.ofa77,g_ofa.ofa78,g_ofa.ofa79,g_ofa.ofa908,
                          g_ofa.ofaconf,
                          g_ofa.ofaprsw,g_ofa.ofauser,g_ofa.ofagrup,
                          g_ofa.ofamodu,g_ofa.ofadate,
                          gp_plant,gp_legal   #FUN-980010
                         ,g_ofa.ofaud01,g_ofa.ofaud02,g_ofa.ofaud03,
                          g_ofa.ofaud04,g_ofa.ofaud05,g_ofa.ofaud06,
                          g_ofa.ofaud07,g_ofa.ofaud08,g_ofa.ofaud09,
                          g_ofa.ofaud10,g_ofa.ofaud11,g_ofa.ofaud12,
                          g_ofa.ofaud13,g_ofa.ofaud14,g_ofa.ofaud15,g_user,g_grup #FUN-A10036
                    IF SQLCA.sqlcode<>0 THEN
                       CALL s_errmsg('ofa01',l_ofa01,'ins ofa:',SQLCA.sqlcode,1)  #No.FUN-710046
                       LET g_success = 'N' EXIT FOREACH 
                    END IF
                DECLARE ofb_cs CURSOR FOR
                 SELECT ofb_file.*,oea_file.oea99 FROM ofb_file,oea_file   #MOD-860201 add
                  WHERE ofb01=g_ofa.ofa01 AND ofb31=oea01                  #MOD-860201 add
                FOREACH ofb_cs INTO g_ofb.*,l_oea99                        #MOD-860201 add oea99
                    LET l_sql1 = "SELECT oeb_file.* ",  #FUN-980092 add
                               #  "  FROM ",s_dbs_tra CLIPPED,"oeb_file,",  #FUN-980092 add   #FUN-A50102
                                 " FROM ", cl_get_target_table( s_plant_new, 'oeb_file' ),"," ,   #FUN-A50102
                                          # s_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 add   #FUN-A50102
                                           cl_get_target_table( s_plant_new, 'oea_file' ),    #FUN-A50102
                                 " WHERE oeb01=oea01 ",
                                 "   AND oea99 ='",l_oea99,"'",                            
                                 "   AND oeb03=",g_ofb.ofb32
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, s_plant_new ) RETURNING l_sql1  #FUN-A50102
         CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
                    PREPARE oeb_p3 FROM l_sql1
                    IF SQLCA.SQLCODE THEN 
                       LET g_showmsg = g_ofb.ofb31,"/",g_ofb.ofb32  #No.FUN-710046
                       CALL s_errmsg('oeb01,oeb03',g_showmsg,'oeb_p3',SQLCA.SQLCODE,1)  #No.FUN-710046
                       LET g_success = 'N' EXIT FOREACH
                    END IF
                    DECLARE oeb_c3 CURSOR FOR oeb_p3
                    OPEN oeb_c3
                    FETCH oeb_c3 INTO p_oeb.*
                    CLOSE oeb_c3
                    LET g_ofb.ofb13=p_oeb.oeb13
                    IF g_ofa.ofa213 = 'N' THEN
                        LET g_ofb.ofb14 =g_ofb.ofb917*g_ofb.ofb13  #MOD-7A0051 ofb12->ofb917
                        LET g_ofb.ofb14t=g_ofb.ofb14*(1+g_ofa.ofa211/100)
                    ELSE
                        LET g_ofb.ofb14t=g_ofb.ofb917*g_ofb.ofb13   #MOD-7A0051 ofb12->ofb917
                        LET g_ofb.ofb14 =g_ofb.ofb14t/(1+g_ofa.ofa211/100)
                    END IF
                    CALL cl_digcut(g_ofb.ofb14,l_azi.azi04) RETURNING g_ofb.ofb14    #MOD-7A0051 add
                    CALL cl_digcut(g_ofb.ofb14t,l_azi.azi04) RETURNING g_ofb.ofb14t  #MOD-7A0051 add
                    #LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"ofb_file",  #FUN-980092 add   #FUN-A50102
                    LET l_sql2="INSERT INTO ",cl_get_target_table( s_plant_new, 'ofb_file' ),   #FUN-A50102
                               "(ofb01,ofb03,ofb04,ofb05,ofb06,",
                               " ofb07,ofb11,ofb12,ofb13,",
                               " ofb14,ofb14t,ofb31,ofb32,ofb33,",
                              #" ofb34,ofb35,ofbplant,ofblegal,",               #CHI-A10025 mark
                               " ofb34,ofb35,ofbplant,ofblegal,ofb910,",        #CHI-A10025
                               " ofb911,ofb912,ofb913,ofb914,ofb915,  ",        #CHI-A10025 
                               " ofb916,ofb917,                       ",        #CHI-A10025 
                               " ofbud01,ofbud02,ofbud03,ofbud04,ofbud05,",
                               " ofbud06,ofbud07,ofbud08,ofbud09,ofbud10,",
                               " ofbud11,ofbud12,ofbud13,ofbud14,ofbud15)",
                               " VALUES(?,?,?,?,?, ?,?,?,?,   ",
                               "        ?,?,?,?,?, ?,?,?,?,?, ",                #CHI-A10025
                               "        ?,?,?,?,?, ?,?,       ",                #CHI-A10025
                               "        ?,?,?,?,?, ?,?,?,?,?, ",                #No.CHI-950020
                               "        ?,?,?,?,? ) "                           #FUN-980010
 	            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032

                    CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
                    PREPARE ins_ofb FROM l_sql2
                    EXECUTE ins_ofb USING 
                    l_ofa01,g_ofb.ofb03,g_ofb.ofb04,g_ofb.ofb05,g_ofb.ofb06,
                    g_ofb.ofb07,g_ofb.ofb11,g_ofb.ofb12,g_ofb.ofb13,
                    g_ofb.ofb14,g_ofb.ofb14t,g_ofb.ofb31,g_ofb.ofb32,g_ofb.ofb33,
                   #g_ofb.ofb34,g_ofb.ofb35,gp_plant,gp_legal     #FUN-980010         #CHI-A10025 mark
                    g_ofb.ofb34,g_ofb.ofb35,gp_plant,gp_legal,g_ofb.ofb910,           #CHI-A10025
                    g_ofb.ofb911,g_ofb.ofb912,g_ofb.ofb913,g_ofb.ofb914,g_ofb.ofb915, #CHI-A10025 
                    g_ofb.ofb916,g_ofb.ofb917,                                        #CHI-A10025 
                    g_ofb.ofbud01,g_ofb.ofbud02,g_ofb.ofbud03,
                    g_ofb.ofbud04,g_ofb.ofbud05,g_ofb.ofbud06,
                    g_ofb.ofbud07,g_ofb.ofbud08,g_ofb.ofbud09,
                    g_ofb.ofbud10,g_ofb.ofbud11,g_ofb.ofbud12,
                    g_ofb.ofbud13,g_ofb.ofbud14,g_ofb.ofbud15
                    IF SQLCA.sqlcode<>0 THEN
                       LET g_showmsg = l_ofa01,"/",g_ofb.ofb03  #No.FUN-710046
                       CALL s_errmsg('ofb01,ofb03',g_showmsg,'ins ofb:',SQLCA.sqlcode,1)  #No.FUN-710046
                       LET g_success = 'N' EXIT FOREACH 
                    END IF
                    #新增至暫存檔中
                    INSERT INTO p821_file VALUES(i,l_ofa01,g_ofb.ofb03,
                                          g_ofb.ofb13,g_ofa.ofa23,'2')   
                    IF SQLCA.sqlcode<>0 THEN
                       CALL s_errmsg('','','ins p821_file',SQLCA.sqlcode,1)   #No.FUN-710046
                       LET g_success = 'N'
                    END IF
                END FOREACH
                #-------- 重計單頭金額 ---------------
               # LET l_sql ="SELECT SUM(ofb14) FROM ",s_dbs_tra CLIPPED,  #FUN-980092 add   #FUN-A50102
                          # " ofb_file ",     #FUN-A50102
                LET l_sql ="SELECT SUM(ofb14) FROM ",cl_get_target_table( s_plant_new, 'ofb_file' ),   #FUN-A50102          
                           " WHERE ofb01 ='", l_ofa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
                PREPARE ofa50_pre FROM l_sql
                DECLARE ofa50_cs CURSOR FOR ofa50_pre
                OPEN ofa50_cs
                FETCH ofa50_cs INTO g_ofa.ofa50
                IF SQLCA.SQLCODE THEN
                   CALL s_errmsg('ofb01',l_ofa01,'sum ofa14:',SQLCA.SQLCODE,1) #No.FUN-710046
                   LET g_success='N'
                END IF
                #LET l_sql =" UPDATE ",s_dbs_tra CLIPPED," ofa_file ",  #FUN-980092 add  #FUN-A50102
                LET l_sql =" UPDATE ",cl_get_target_table( s_plant_new, 'ofa_file' ),    #FUN-A50102
                           "    SET ofa50 =",g_ofa.ofa50,
                           " WHERE ofa01 = '",l_ofa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
                PREPARE upofa50_pre FROM l_sql
                EXECUTE upofa50_pre
                IF SQLCA.SQLCODE THEN
                   CALL s_errmsg('ofa01',l_ofa01,'upd ofa50:',SQLCA.SQLCODE,0)  #No.FUN-710046
                END IF
                #出貨通知單
               # LET l_sql = "UPDATE ",s_dbs_tra CLIPPED, "oga_file",  #FUN-980092 add    #FUN-A50102
               LET l_sql = "UPDATE ",cl_get_target_table( s_plant_new, 'oga_file' ),      #FUN-A50102
                            "  SET oga27  =  ? ",
                            " WHERE oga01 = '",l_oga.oga01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
                PREPARE ofa27_upd2 FROM l_sql
                EXECUTE ofa27_upd2 USING l_ofa01
              END IF
           END IF
     END FOR  {一個訂單流程代碼結束}   
 
     MESSAGE ""
     #更新起始出貨通知單單頭檔之拋轉否='Y'
     UPDATE oga_file
        SET oga905='Y',
            oga906='Y'
       WHERE oga01=g_oga.oga01
     IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
        CALL s_errmsg('oga01',g_oga.oga01,'upd pmm',STATUS,1)   #No.FUN-710046
        LET g_success='N'
        CONTINUE FOREACH   #No.FUN-710046
     END IF
  END FOREACH     
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
  CALL s_showmsg()    #No.FUN-710046
  IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
  END IF
  DROP TABLE p821_file
END FUNCTION
 
#判斷目前之下游廠商為何,並得知S/O及P/O之客戶/廠商代碼 
FUNCTION p821_azp(l_n)
  DEFINE l_source LIKE type_file.num5,   #來源站別 #No.FUN-680137 SMALLINT
         l_n      LIKE type_file.num5,   #當站站別  #No.FUN-680137 SMALLINT
         l_sql1   STRING                                             #MOD-9C0268 
 
     LET l_source = l_n - 1
     ##-------------取得資料庫(出通單)-----------------
     SELECT * INTO s_poy.* FROM poy_file 
      WHERE poy01 = g_poz.poz01 AND poy02 = l_n
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
     LET s_plant_new = s_azp.azp01                     #FUN-980020
     LET s_dbs_new = s_azp.azp03 CLIPPED,"."
 
     #---GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = s_azp.azp01
     LET s_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET s_dbs_tra = g_dbs_tra
 
     LET l_sql1 = "SELECT * ",                         #取得來源本幣
                  #" FROM ",s_dbs_new CLIPPED,"aza_file ",    #FUN-A50102
                  " FROM ",cl_get_target_table( s_plant_new, 'aza_file' ),   #FUN-A50102
                  " WHERE aza01 = '0' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, s_plant_new ) RETURNING l_sql1   #FUN-A50102
     PREPARE aza_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN CALL cl_err('aza_p2',SQLCA.SQLCODE,1) END IF
     DECLARE aza_c1  CURSOR FOR aza_p1
     OPEN aza_c1 
     FETCH aza_c1 INTO s_aza.* 
     CLOSE aza_c1

     SELECT poy03 INTO p_oea03
       FROM poy_file
      WHERE poy01 = g_poz.poz01
        AND poy02 = l_source
     LET s_imd01 = s_poy.poy11
     LET p_pmm09 = s_poy.poy03    #供應廠商
     LET p_poz03 = s_poy.poy20    #營業額申報方式
     LET p_poy04 = s_poy.poy04    #工廠編號
     IF g_poz.poz09 = 'Y' THEN    #指定幣別
        LET p_azi01 = s_poy.poy05 #流程幣別
     ELSE
        LET p_azi01 = g_oea.oea23 #接單幣別
     END IF
     LET p_poy06 = s_poy.poy06    #付款條件
     LET p_poy07 = s_poy.poy07    #收款條件
     LET p_poy08 = s_poy.poy08    #S/O 稅別
     LET p_poy09 = s_poy.poy09    #P/O 稅別
     LET p_poy10 = s_poy.poy10    #銷售分類
     LET p_poy12 = s_poy.poy12    #發票別 
     LET p_poy16 = s_poy.poy16    #AR科目類別 #MOD-940299
     LET p_poy28 = s_poy.poy28    #NO.FUN-620024
     LET p_poy29 = s_poy.poy29    #NO.FUN-620024
END FUNCTION
 
#讀取幣別檔之資料
FUNCTION p820_azi(l_oga23,l_dbs)  
  DEFINE l_sql1  STRING                                             #MOD-9C0268 
  DEFINE l_oga23 LIKE oga_file.oga23
  DEFINE l_dbs   LIKE type_file.chr21  
 
   #讀取之本幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs CLIPPED,"azi_file ",  #FUN-A50102
                " FROM ",cl_get_target_table( s_plant_new, 'azi_file' ),  #FUN-A50102
                " WHERE azi01='",s_aza.aza17,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, s_plant_new ) RETURNING l_sql1        #FUN-A50102
   PREPARE azi_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','azi_p1',SQLCA.SQLCODE,0)  #No.FUN-710046
   END IF
   DECLARE azi_c1 CURSOR FOR azi_p1
   OPEN azi_c1
   FETCH azi_c1 INTO s_azi.* 
   CLOSE azi_c1
   #讀取s_dbs_new 之原幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs CLIPPED,"azi_file ",   #FUN-A50102
                " FROM ",cl_get_target_table( s_plant_new, 'azi_file' ),  #FUN-A50102
                " WHERE azi01='",l_oga23,"' " 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql( l_sql1, s_plant_new ) RETURNING l_sql1        #FUN-A50102
   PREPARE azi_p2 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','azi_p2',SQLCA.SQLCODE,0) #No.FUN-710046
   END IF
   DECLARE azi_c2 CURSOR FOR azi_p2
   OPEN azi_c2
   FETCH azi_c2 INTO l_azi.* 
   CLOSE azi_c2
END FUNCTION
 
FUNCTION p821_ogains()
  DEFINE l_sql,l_sql1,l_sql2    STRING                                #MOD-9C0268
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE li_result LIKE type_file.num5 #TQC-9B0013
   
  #讀取該流程代碼之銷單資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",s_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 add  #FUN-A50102
                " FROM ", cl_get_target_table( s_plant_new, 'oea_file' ),  #FUN-A50102
                " WHERE oea99='",g_oea.oea99,"' ",  
                "   AND oeaconf = 'Y' " #01/08/16 mandy
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE oea_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      CALL s_errmsg('','','oea_p1',SQLCA.SQLCODE,0) #No.FUN-710046
   END IF
   DECLARE oea_c1 CURSOR FOR oea_p1
   OPEN oea_c1
   FETCH oea_c1 INTO l_oea.*
   IF SQLCA.SQLCODE <> 0 THEN
      LET g_success='N'
      RETURN
   END IF
   CLOSE oea_c1
 
  #新增出貨通知單單頭檔(oga_file)
        CALL s_auto_assign_no("axm",oga_t1,g_oga.oga02,"","oga_file","oga01",s_plant_new,"","") #FUN-980092 add
            RETURNING li_result,l_oga.oga01
        IF (NOT li_result) THEN 
           LET g_msg = s_plant_new CLIPPED,l_oga.oga01
           CALL s_errmsg("oga01",l_oga.oga01,g_msg CLIPPED,"mfg3046",1) 
           LET g_success ='N'
           RETURN
        END IF   
    LET l_oga.oga011= ''                 #出貨單號
    LET l_oga.oga00 = l_oea.oea00        #出貨別
    LET l_oga.oga02 = g_oga.oga02        #出貨日期
    LET l_oga.oga021= g_oga.oga021       #結關日期
    LET l_oga.oga022= g_oga.oga022       #裝船日期
    LET l_oga.oga03 = l_oea.oea03
    LET l_oga.oga032= l_oea.oea032
    LET l_oga.oga033= l_oea.oea033
    LET l_oga.oga04 = l_oea.oea04
    LET l_oga.oga044= l_oea.oea044
    LET l_oga.oga05 = l_oea.oea05
    LET l_oga.oga06 = l_oea.oea06
    LET l_oga.oga07 = l_oea.oea07
    LET l_oga.oga08 = l_oea.oea08
    LET l_oga.oga09 = '5'
    LET l_oga.oga10 = null
    LET l_oga.oga11 = null
    LET l_oga.oga12 = null
    LET l_oga.oga13 = p_poy16        #MOD-940299 add    
    LET l_oga.oga14 = l_oea.oea14
    LET l_oga.oga15 = l_oea.oea15
    LET l_oga.oga16 = l_oea.oea01                     #NO.FUN-620024
    LET l_oga.oga161= l_oea.oea161
    LET l_oga.oga162= l_oea.oea162
    LET l_oga.oga163= l_oea.oea163
    LET l_oga.oga18 = l_oea.oea17
    LET l_oga.oga19 = null
    LET l_oga.oga20 = 'Y'
    LET l_oga.oga21 = l_oea.oea21
    LET l_oga.oga211= l_oea.oea211
    LET l_oga.oga212= l_oea.oea212
    LET l_oga.oga213= l_oea.oea213
    LET l_oga.oga23 = l_oea.oea23
    CALL p820_azi(g_oea.oea23,s_dbs_new)              #讀取幣別資料  
 
    #出貨時重新抓取匯率
    CALL s_currm(l_oga.oga23,l_oga.oga02,g_oax.oax01,s_plant_new)    
        RETURNING l_oga.oga24
 
    #若出貨單頭之幣別=本幣幣別, 則匯率給1, (COI美金立帳, 99.03.05)
    IF l_oga.oga23 = l_aza.aza17 THEN
       LET l_oga.oga24=1
    END IF
    IF cl_null(l_oga.oga24) THEN LET l_oga.oga24=l_oea.oea24 END IF
   #-CHI-940042-add-  
    IF l_oea.oea18 IS NOT NULL AND l_oea.oea18='Y' THEN
       LET l_oga.oga24 = l_oea.oea24
    END IF
    IF cl_null(l_oga.oga24) THEN LET l_oga.oga24=1 END IF
   #-CHI-940042-end-  
    LET l_oga.oga25 = l_oea.oea25
    LET l_oga.oga26 = l_oea.oea26
    LET l_oga.oga27 = g_oga.oga27
    LET l_oga.oga28 = l_oea.oea18
    LET l_oga.oga29 = 0
    LET l_oga.oga30 = 'N'
    LET l_oga.oga31 = l_oea.oea31
    LET l_oga.oga32 = l_oea.oea32
    LET l_oga.oga33 = l_oea.oea33
    LET l_oga.oga34 = 0
    LET l_oga.oga35 = g_oga.oga35
    LET l_oga.oga36 = g_oga.oga36
    LET l_oga.oga37 = g_oga.oga37
    LET l_oga.oga38 = g_oga.oga38
    LET l_oga.oga39 = g_oga.oga39
    LET l_oga.oga40 = l_oea.oea19
    LET l_oga.oga41 = l_oea.oea41
    LET l_oga.oga42 = l_oea.oea42
    LET l_oga.oga43 = l_oea.oea43
    LET l_oga.oga44 = l_oea.oea44
    LET l_oga.oga45 = l_oea.oea45
    LET l_oga.oga46 = l_oea.oea46
    LET l_oga.oga47 = g_oga.oga47
    LET l_oga.oga48 = g_oga.oga48
    LET l_oga.oga49 = g_oga.oga49
    LET l_oga.oga50 = 0
    LET l_oga.oga52 = 0
    LET l_oga.oga53 = 0
    LET l_oga.oga54 = 0
    LET l_oga.oga69 = g_oga.oga69   #CHI-C50021 add
    LET l_oga.oga65 = l_oea.oea65   #FUN-7B0091 add
    LET l_oga.oga99 = g_flow99      #No.7993
    LET l_oga.oga901='N'
    LET l_oga.oga905='Y'
    LET l_oga.oga906='N'
    LET l_oga.oga909='Y'
    IF s_aza.aza50 = 'Y' THEN
       LET l_oga.oga1001 = l_oea.oea1001  #收款客戶編號
       LET l_oga.oga1002 = l_oea.oea1002  #債權代碼
       LET l_oga.oga1003 = l_oea.oea1003  #業績歸屬方
       LET l_oga.oga1004 = l_oea.oea1004  #代送商
       LET l_oga.oga1005 = l_oea.oea1005  #是否計算業績
       LET l_oga.oga1006 = l_oea.oea1006  #未稅金額
       LET l_oga.oga1007 = l_oea.oea1007  #含稅金額
       LET l_oga.oga1008 = 0              #出貨總含稅金額
       LET l_oga.oga1009 = l_oea.oea1009  #客戶所屬渠道
       LET l_oga.oga1010 = l_oea.oea1010  #客戶所屬方
       LET l_oga.oga1011 = l_oea.oea1011  #開票客戶
       LET l_oga.oga1012 = ''             #銷退單單號
       LET l_oga.oga1013 = 'N'            #已打印提單否
       LET l_oga.oga1014 = 'N'            #是否對應代送銷退單
       LET l_oga.oga1015 = '0'            #導物流狀況碼
    END IF
    LET l_oga.ogaconf='Y'
    LET l_oga.oga55='1'    #MOD-A50103
    LET l_oga.oga57 = '1'  #FUN-AC0055 add
    LET l_oga.ogaprsw=0
    LET l_oga.ogauser=g_user
    LET l_oga.ogagrup=g_grup
    LET l_oga.ogamodu=null
    LET l_oga.ogadate=null
    LET l_oga.ogaud01 = g_oga.ogaud01
    LET l_oga.ogaud02 = g_oga.ogaud02
    LET l_oga.ogaud03 = g_oga.ogaud03
    LET l_oga.ogaud04 = g_oga.ogaud04
    LET l_oga.ogaud05 = g_oga.ogaud05
    LET l_oga.ogaud06 = g_oga.ogaud06
    LET l_oga.ogaud07 = g_oga.ogaud07
    LET l_oga.ogaud08 = g_oga.ogaud08
    LET l_oga.ogaud09 = g_oga.ogaud09
    LET l_oga.ogaud10 = g_oga.ogaud10
    LET l_oga.ogaud11 = g_oga.ogaud11
    LET l_oga.ogaud12 = g_oga.ogaud12
    LET l_oga.ogaud13 = g_oga.ogaud13
    LET l_oga.ogaud14 = g_oga.ogaud14
    LET l_oga.ogaud15 = g_oga.ogaud15
 
    #新增出貨通知單頭檔(oga_file)
    #LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"oga_file",  #FUN-980092 add   #FUN-A50102
    LET l_sql2="INSERT INTO ",cl_get_target_table( s_plant_new, 'oga_file' ),   #FUN-A50102
               "( oga00,oga01,oga011,oga02, ",
               "  oga021,oga022,oga03,oga032,",
               "  oga033,oga04,oga044,oga05,",
               "  oga06,oga07,oga08,oga09,",
               "  oga10,oga11,oga12,oga13,",
               "  oga14,oga15,oga16,oga161,",
               "  oga162,oga163,oga17,oga18,",
               "  oga19,oga20,oga21,oga211,",
               "  oga212,oga213,oga23,oga24,",
               "  oga25,oga26,oga27,oga28,",
               "  oga29,oga30,oga31,oga32,",
               "  oga33,oga34,oga35,",
               "  oga36,oga37,oga38,oga39,",
               "  oga40,oga41,oga42,oga43,",
               "  oga44,oga45,oga46,oga47,",
               "  oga48,oga49,oga50,oga52,",
               "  oga53,oga54,oga69,oga65,oga99,",          #No.7993   #FUN-7B0091 add oga65 #CHI-C50021 add oga69
               "  oga901,oga902,",
               "  oga903,oga904,oga905,oga906,",
               "  oga907,oga908,oga909,oga1001,",     #NO.FUN-620024
               "  oga1002,oga1003,oga1004,oga1005,",  #NO.FUN-620024               
               "  oga1006,oga1007,oga1008,oga1009,",  #NO.FUN-620024
               "  oga1010,oga1011,oga1012,oga1013,",  #NO.FUN-620024
               "  oga1014,oga1015,ogaconf,oga55,oga57,",          #NO.FUN-620024   #MOD-A50103 add oga55  #FUN-AC0055 add oga57
               "  ogapost,ogaprsw,ogauser,ogagrup,",
               "  ogamodu,ogadate,ogaplant,ogalegal, ",
               "  ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
               "  ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
               "  ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,ogaoriu,ogaorig)",#FUN-A10036
               " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",    #NO.FUN-620024
                        "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #No.CHI-950020
                        "?,?,?, ?,?,?,?,?, ?) "   #FUN-7B0091 add ?  #FUN-980010   #MOD-A50103 add ? #CHI-C50021 add ?
           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
           CALL cl_parse_qry_sql( l_sql2, s_plant_new ) RETURNING l_sql2    #FUN-A50102
           PREPARE ins_oga FROM l_sql2
           EXECUTE ins_oga USING 
                 l_oga.oga00,l_oga.oga01,l_oga.oga011,l_oga.oga02, 
                 l_oga.oga021,l_oga.oga022,l_oga.oga03,l_oga.oga032,
                 l_oga.oga033,l_oga.oga04,l_oga.oga044,l_oga.oga05,
                 l_oga.oga06,l_oga.oga07,l_oga.oga08,l_oga.oga09,
                 l_oga.oga10,l_oga.oga11,l_oga.oga12,l_oga.oga13,
                 l_oga.oga14,l_oga.oga15,l_oga.oga16,l_oga.oga161,
                 l_oga.oga162,l_oga.oga163,l_oga.oga17,l_oga.oga18,
                 l_oga.oga19,l_oga.oga20,l_oga.oga21,l_oga.oga211,
                 l_oga.oga212,l_oga.oga213,l_oga.oga23,l_oga.oga24,
                 l_oga.oga25,l_oga.oga26,l_oga.oga27,l_oga.oga28,
                 l_oga.oga29,l_oga.oga30,l_oga.oga31,l_oga.oga32,
                 l_oga.oga33,l_oga.oga34,l_oga.oga35,
                 l_oga.oga36,l_oga.oga37,l_oga.oga38,l_oga.oga39,
                 l_oga.oga40,l_oga.oga41,l_oga.oga42,l_oga.oga43,
                 l_oga.oga44,l_oga.oga45,l_oga.oga46,l_oga.oga47,
                 l_oga.oga48,l_oga.oga49,l_oga.oga50,l_oga.oga52,
                 l_oga.oga53,l_oga.oga54,l_oga.oga69,l_oga.oga65,l_oga.oga99,    #No.7993   #FUN-7B0091 add oga65 #CHI-C50021 add oga69   
                 l_oga.oga901,l_oga.oga902,
                 l_oga.oga903,l_oga.oga904,l_oga.oga905,l_oga.oga906,
                 l_oga.oga907,l_oga.oga908,l_oga.oga909,l_oga.oga1001,    #NO.FUN-620024
                 l_oga.oga1002,l_oga.oga1003,l_oga.oga1004,l_oga.oga1005, #NO.FUN-620024
                 l_oga.oga1006,l_oga.oga1007,l_oga.oga1008,l_oga.oga1009, #NO.FUN-620024
                 l_oga.oga1010,l_oga.oga1011,l_oga.oga1012,l_oga.oga1013, #NO.FUN-620024
                 l_oga.oga1014,l_oga.oga1015,l_oga.ogaconf,l_oga.oga55,l_oga.oga57,               #NO.FUN-620024   #MOD-A50103 add oga55  #FUN-AC0055 add l_oga.oga57 
                 l_oga.ogapost,l_oga.ogaprsw,l_oga.ogauser,l_oga.ogagrup,
                 l_oga.ogamodu,l_oga.ogadate,
                 gp_plant,gp_legal   #FUN-980010
                ,l_oga.ogaud01,l_oga.ogaud02,l_oga.ogaud03,
                 l_oga.ogaud04,l_oga.ogaud05,l_oga.ogaud06,
                 l_oga.ogaud07,l_oga.ogaud08,l_oga.ogaud09,
                 l_oga.ogaud10,l_oga.ogaud11,l_oga.ogaud12,
                 l_oga.ogaud13,l_oga.ogaud14,l_oga.ogaud15,g_user,g_grup #FUN-A10036
              IF SQLCA.sqlcode<>0 THEN
                 CALL s_errmsg('oga01',l_oga.oga01,'ins oga:',SQLCA.sqlcode,1)  #No.FUN-710046
                 LET g_success = 'N'
              END IF
END FUNCTION
 
#出貨單身檔
FUNCTION p821_ogbins(p_i)
  DEFINE l_sql,l_sql1,l_sql2,l_sql3    STRING                         #MOD-9C0268
  DEFINE p_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_no   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_price LIKE ogb_file.ogb13
  DEFINE i,l_i   LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
  DEFINE l_chr   LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)
         l_currm LIKE pmm_file.pmm42,   #依計價幣別抓來源廠的匯率
         x_currm LIKE pmm_file.pmm42,
         l_curr  LIKE pmm_file.pmm22      #No.FUN-680137 VARCHAR(04)
  DEFINE l_ima02 LIKE ima_file.ima02
  DEFINE l_ima25 LIKE ima_file.ima25
 # DEFINE l_imaqty LIKE ima_file.ima262 #FUN-A20044
  DEFINE l_imaqty LIKE type_file.num15_3 #FUN-A20044
  DEFINE l_ima86 LIKE ima_file.ima86
  DEFINE l_ima39 LIKE ima_file.ima39
  DEFINE l_ima35 LIKE ima_file.ima35
  DEFINE l_ima36 LIKE ima_file.ima36
  DEFINE l_sql4  STRING                                                                  #MOD-9C0268
  DEFINE l_ogbi  RECORD LIKE ogbi_file.*  #No.FUN-7B0018
  DEFINE l_oaz81 LIKE oaz_file.oaz81  #No.FUN-850100
  DEFINE l_idd   RECORD LIKE idd_file.*            #FUN-B90012 
  #DEFINE l_imaicd08  LIKE imaicd_file.imaicd08     #FUN-B90012   #FUN-BA0051 mark
  DEFINE l_flag      LIKE type_file.num10          #FUN-B90012
  DEFINE l_ogbiicd028   LIKE ogbi_file.ogbiicd028  #FUN-B90012
  DEFINE l_ogbiicd029   LIKE ogbi_file.ogbiicd029  #FUN-B90012
  DEFINE l_cnt          LIKE type_file.num5        #CHI-C40031 add
 #DEFINE l_oia07   LIKE oia_file.oia07 #FUN-C50136
  DEFINE l_fac   LIKE ima_file.ima31_fac  #FUN-C80001
  DEFINE l_img09 LIKE img_file.img09      #FUN-C80001
  DEFINE l_idb   RECORD LIKE idb_file.*   #FUN-C80001 
 
     #讀取訂單單身檔(oeb_file)
     #LET l_sql1 = "SELECT ",s_dbs_tra CLIPPED,"oeb_file.* ", #FUN-980092 add   #FUN-A50102
     LET l_sql1 = "SELECT ",cl_get_target_table( s_plant_new, 'oeb_file.*' ),      #FUN-A50102
                  #"  FROM ",s_dbs_tra CLIPPED,"oeb_file,",s_dbs_tra CLIPPED,"oea_file", #FUN-980092 add   #FUN-A50102
                  "  FROM ",cl_get_target_table( s_plant_new, 'oeb_file' ), ",",         #FUN-A50102
                            cl_get_target_table( s_plant_new, 'oea_file' ),              #FUN-A50102
                  " WHERE oeb01 = oea01",
                  "   AND oea99 ='",g_oea99,"'",     #MOD-740042 modify
                  "   AND oeb03 =",g_ogb.ogb32
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
     PREPARE oeb_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN CALL cl_err('oeb_p1',SQLCA.SQLCODE,1) END IF
     DECLARE oeb_c1 CURSOR FOR oeb_p1
     OPEN oeb_c1
     FETCH oeb_c1 INTO l_oeb.*
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success='N'
        RETURN
     END IF
     CLOSE oeb_c1
     #新增出貨單身檔[ogb_file]
     LET l_ogb.ogb01 = l_oga.oga01      #出貨單號 No.7993
     LET l_ogb.ogb03 = g_ogb.ogb03      #項次
     LET l_ogb.ogb04 = g_ogb.ogb04      #產品編號 No.7742
     LET l_ogb.ogb05 = g_ogb.ogb05      #銷售單位 No.7742
     LET l_ogb.ogb05_fac= g_ogb.ogb05_fac  #換算率No.7742
     LET l_ogb.ogb06 = g_ogb.ogb06      #品名規格 No.7742
     LET l_ogb.ogb07 = g_ogb.ogb07      #額外品名編號 No.7742
     LET l_ogb.ogb08 = l_oeb.oeb08      #出貨工廠
     CALL p821_ima(l_ogb.ogb04,s_plant_new) #FUN-980092 add
        RETURNING l_ima02,l_ima25,l_imaqty,l_ima86,l_ima39,l_ima35,l_ima36
     IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
     IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF
     IF NOT cl_null(p_imd01) THEN
        CALL p821_imd(p_imd01,s_plant_new) #FUN-980092 add
        LET l_ogb.ogb09 = p_imd01          #出貨倉庫
        LET l_ogb.ogb091= ' '              #出貨儲位
        LET l_ogb.ogb092= ' '              #出貨批號
     ELSE
        IF NOT cl_null(l_ima35) THEN
           LET l_ogb.ogb09 = l_ima35          #出貨倉庫
           LET l_ogb.ogb091= l_ima36          #出貨儲位
           LET l_ogb.ogb092= ' '              #出貨批號
        ELSE
           LET l_ogb.ogb09 = l_oeb.oeb09
           LET l_ogb.ogb091= l_oeb.oeb091
           LET l_ogb.ogb092= l_oeb.oeb092      #No.MOD-630019 modify
        END IF
     END IF
     IF cl_null(l_ogb.ogb091) THEN LET l_ogb.ogb091=' ' END IF  #FUN-C80001
    #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
        LET l_ogb.ogb092= g_ogb.ogb092 #FUN-C80001
     END IF                            #FUN-C80001
     LET l_ogb.ogb11 = g_ogb.ogb11      #客戶產品編號 No.7742
     LET l_ogb.ogb12 = g_ogb.ogb12      #實際出貨數量
     IF g_oax.oax03 = 'N' OR s_aza.aza50 = 'Y' THEN     #NO.FUN-670007   
        LET l_ogb.ogb13 = l_oeb.oeb13      #原幣單價
     ELSE
        #出貨必須重新計算價格, 因為分批出貨時, 有可能計價方式亦改變了
        #依計價方式來判斷價格
              CASE p_pox05
                 WHEN '1'
                    IF p_pox03='1' THEN   #依來源工廠 
                       #單價*比率
                       # (換算匯率) 
                       IF g_oea.oea23 = l_oga.oga23 THEN
                          LET l_ogb.ogb13 = g_ogb.ogb13 * p_pox06 /100
                       END IF
                       IF g_oea.oea23 <> l_oga.oga23 THEN  
                          LET l_price = g_ogb.ogb13 * g_oga.oga24 #先換算本幣
                          #依計價幣別抓來源工廠的匯率  no:3463
                          CALL s_currm(l_oga.oga23,l_oga.oga02,
                                       g_oax.oax01,t_plant)   #NO.FUN-980020      
                               RETURNING l_currm
                          LET l_ogb.ogb13= l_price/l_currm * p_pox06/100  
                       END IF
                    ELSE
                       #依上游廠商計算, 先讀取S/O價格
                       IF p_i=1 THEN
                         #單價*比率
                         #modi 00/01/23 (換算匯率) NO:1218
                         IF g_oea.oea23 = l_oga.oga23 THEN
                            LET l_ogb.ogb13 = g_ogb.ogb13 * p_pox06 /100
                         END IF
                         IF g_oea.oea23 <> l_oga.oga23 THEN  
                            LET l_price = g_ogb.ogb13 * g_oga.oga24 #先換算本幣
                            #依計價幣別抓來源工廠的匯率 no:3463
                            CALL s_currm(l_oga.oga23,l_oga.oga02,
                                         g_oax.oax01,t_plant) #No.FUN-980020   
                                 RETURNING l_currm
                            LET l_ogb.ogb13= l_price/l_currm * p_pox06/100  
                         END IF
                       ELSE
                          LET l_no = p_i-1
                          SELECT pab_price,pab_curr INTO l_price,l_curr   
                            FROM p821_file
                           WHERE p_no = l_no
                             AND pab_no = l_ogb.ogb01
                             AND pab_item=g_ogb.ogb03
                             AND pab_type='1'
                          IF l_curr != l_oga.oga23 THEN
                             CALL s_currm(l_curr,l_oga.oga02,
                                          g_oax.oax01,t_plant) #No.FUN-980020
                              RETURNING x_currm
                             LET l_price = l_price * x_currm   #換算成本幣
                             #依計價幣別抓來源廠的匯率 no:3463
                             CALL s_currm(l_oga.oga23,l_oga.oga02,
                                          g_oax.oax01,t_plant) #No.FUN-980020  
                              RETURNING l_currm
                             LET l_ogb.ogb13 = l_price / l_currm * p_pox06/100
                          ELSE
                             #單價*比率
                             LET l_ogb.ogb13= l_price * p_pox06/100
                          END IF
                        END IF  
                    END IF
                    CALL cl_digcut(l_ogb.ogb13,l_azi.azi03) 
                          RETURNING l_ogb.ogb13
                 WHEN '2'
                    #讀取合乎料件條件之價格
                    CALL s_pow(g_oea.oea904,l_ogb.ogb04,p_poy04,g_oga.oga02)
                           RETURNING g_sw,l_ogb.ogb13
                     IF g_sw='N' THEN
                       CALL cl_err('sel pow:','axm-333',1)
                       LET g_success = 'N'
                     END IF
                 WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                     IF g_ogb.ogb13 <> 0 THEN
                        CALL s_pow(g_oea.oea904,l_ogb.ogb04,p_poy04,g_oga.oga02)
                           RETURNING g_sw,l_ogb.ogb13
                        IF g_sw='N' THEN
                          CALL cl_err('sel pow:','axm-333',1)
                          LET g_success = 'N'
                        END IF
                     ELSE
                        LET l_ogb.ogb13 = 0
                     END IF
              END CASE
              IF l_ogb.ogb13 IS NULL THEN LET l_ogb.ogb13 =0 END IF
     END IF
     LET l_ogb.ogb917 = g_ogb.ogb917                                   #CHI-A10025
     #未稅金額/含稅金額 : oeb14/oeb14t
     IF l_oga.oga213 = 'N' THEN
       #LET l_ogb.ogb14=l_ogb.ogb12*l_ogb.ogb13                        #CHI-A10025 mark
        LET l_ogb.ogb14=l_ogb.ogb917*l_ogb.ogb13                       #CHI-A10025 
        CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14  #CHI-A10025 
        LET l_ogb.ogb14t=l_ogb.ogb14*(1+l_oga.oga211/100)
        CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t #CHI-A10025 
     ELSE 
       #LET l_ogb.ogb14t=l_ogb.ogb12*l_ogb.ogb13                       #CHI-A10025 mark
        LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13                      #CHI-A10025 
        CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t #CHI-A10025
        LET l_ogb.ogb14=l_ogb.ogb14t/(1+l_oga.oga211/100)
        CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14  #CHI-A10025 
     END IF
     LET l_ogb.ogb15 = l_ogb.ogb05 #No.7742
     LET l_ogb.ogb15_fac = l_ogb.ogb05_fac #MOD-4B0148
     LET l_ogb.ogb16 = l_ogb.ogb12
    #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
     IF g_pod.pod08 = 'Y' THEN         #FUN-D30099 
        LET l_ogb.ogb17 = g_ogb.ogb17  #FUN-C80001
     ELSE                              #FUN-C80001
        LET l_ogb.ogb17 = 'N'
     END IF                            #FUN-C80001
     LET l_ogb.ogb18 = l_ogb.ogb12
     LET l_ogb.ogb19 = g_ogb.ogb19  #檢驗否 #NO.FUN-620024
     LET l_ogb.ogb20 =' '
     LET l_ogb.ogb31 = l_oeb.oeb01
     LET l_ogb.ogb32 = l_oeb.oeb03
     LET l_ogb.ogb60 =0
     LET l_ogb.ogb63 =0
     LET l_ogb.ogb64 =0
     LET l_ogb.ogb910 = g_ogb.ogb910
     LET l_ogb.ogb911 = g_ogb.ogb911
     LET l_ogb.ogb912 = g_ogb.ogb912
     LET l_ogb.ogb913 = g_ogb.ogb913
     LET l_ogb.ogb914 = g_ogb.ogb914
     LET l_ogb.ogb915 = g_ogb.ogb915
     LET l_ogb.ogb916 = g_ogb.ogb916
    #LET l_ogb.ogb917 = g_ogb.ogb917       #CHI-A10025 mark
     IF s_aza.aza50 = 'Y' THEN   
        LET l_ogb.ogb1001 = l_oeb.oeb1001  #原因碼
        LET l_ogb.ogb1002 = l_oeb.oeb1002  #訂價編號
        LET l_ogb.ogb1003 = l_oeb.oeb15    #預計出貨日期
        LET l_ogb.ogb1004 = l_oeb.oeb1004  #提案編號
        LET l_ogb.ogb1005 = l_oeb.oeb1003  #作業方式
        LET l_ogb.ogb1007 = ''             #現金折扣單號
        LET l_ogb.ogb1008 = ''             #稅種
        LET l_ogb.ogb1009 = ''             #稅率
        LET l_ogb.ogb1010 = ''             #含稅否
        LET l_ogb.ogb1011 = ''             #非直營KAB
        LET l_ogb.ogb1006 = l_oeb.oeb1006  #折扣率
        LET l_ogb.ogb1012 = l_oeb.oeb1012  #搭贈
     END IF
    #CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14    #CHI-A10025 mark
    #CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t   #CHI-A10025 mark
     IF l_ogb.ogb1012 = 'Y' THEN   #NO.FUN-620024
        LET l_ogb.ogb14 =0         #NO.FUN-620024
        LET l_ogb.ogb14t=0         #NO.FUN-620024
     END IF                        #NO.FUN-620024
     LET l_ogb.ogbud01 = g_ogb.ogbud01
     LET l_ogb.ogbud02 = g_ogb.ogbud02
     LET l_ogb.ogbud03 = g_ogb.ogbud03
     LET l_ogb.ogbud04 = g_ogb.ogbud04
     LET l_ogb.ogbud05 = g_ogb.ogbud05
     LET l_ogb.ogbud06 = g_ogb.ogbud06
     LET l_ogb.ogbud07 = g_ogb.ogbud07
     LET l_ogb.ogbud08 = g_ogb.ogbud08
     LET l_ogb.ogbud09 = g_ogb.ogbud09
     LET l_ogb.ogbud10 = g_ogb.ogbud10
     LET l_ogb.ogbud11 = g_ogb.ogbud11
     LET l_ogb.ogbud12 = g_ogb.ogbud12
     LET l_ogb.ogbud13 = g_ogb.ogbud13
     LET l_ogb.ogbud14 = g_ogb.ogbud14
     LET l_ogb.ogbud15 = g_ogb.ogbud15
     #No.7742 備品時金額、單價應為零
     IF p821_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
        LET l_ogb.ogb13 = 0 
        LET l_ogb.ogb14 = 0 
        LET l_ogb.ogb14t= 0 
     END IF
     IF g_aza.aza50 = 'N' THEN LET l_ogb.ogb1005 = '1' END IF 
#FUN-AB0061 -----------add start----------------                             
     IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
        LET l_ogb.ogb37=l_ogb.ogb13                         
     END IF                                                                             
#FUN-AB0061 -----------add end----------------  
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 	----------add start------------
#     IF cl_null(l_ogb.ogb50) THEN
#        LET g_ogb.ogb50 = '1'
#     END IF
##FUN-AB0096 -------------add end--------------  
#FUN-AC0055 mark ----------------------end------------------------
     #FUN-C50097 ADD BEGIN-----
     IF cl_null(l_ogb.ogb50) THEN 
       LET l_ogb.ogb50 = 0
     END IF 
     IF cl_null(l_ogb.ogb51) THEN 
       LET l_ogb.ogb51 = 0
     END IF 
     IF cl_null(l_ogb.ogb52) THEN 
       LET l_ogb.ogb52 = 0
     END IF                                      
     IF cl_null(l_ogb.ogb53) THEN 
       LET l_ogb.ogb53 = 0
     END IF 
     IF cl_null(l_ogb.ogb54) THEN 
       LET l_ogb.ogb54 = 0
     END IF 
     IF cl_null(l_ogb.ogb55) THEN 
       LET l_ogb.ogb55 = 0
     END IF
     #FUN-C50097 ADD END------- 
     #新增出貨通知單身檔
     #LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"ogb_file",  #FUN-980092 add  #FUN-A50102
     LET l_sql2="INSERT INTO ",cl_get_target_table( s_plant_new, 'ogb_file' ),  #FUN-A50102
      "(ogb01,ogb03,ogb04,ogb05, ",
      " ogb05_fac,ogb06,ogb07,ogb08, ",
      " ogb09,ogb091,ogb092,ogb11, ",
      " ogb12,ogb37,ogb13,ogb14,ogb14t,",#FUN-AB0061 
      " ogb15,ogb15_fac,ogb16,ogb17, ",
      " ogb18,ogb19,ogb20,ogb31,",
      " ogb32,ogb60,ogb63,ogb64,",
      " ogb901,ogb902,ogb903,ogb904,",
      " ogb905,ogb906,ogb907,ogb908,",
      " ogb909,ogb910,ogb911,ogb912,",   #FUN-560043
      " ogb913,ogb914,ogb915,ogb916,",   #FUN-560043
      " ogb917,ogb1001,ogb1002,ogb1003,", #NO.FUN-620024
      " ogb1004,ogb1005,ogb1007,ogb1008,",#NO.FUN-620024
      " ogb1009,ogb1010,ogb1011,ogb1012,ogb1006,",       #NO.FUN-620024
      " ogbplant,ogblegal , ",       #FUN-980010 
      " ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
      " ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
      " ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",  #FUN-AB0096 add ogb50  #FUN-C50097 ADD 50,51,52
      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ",  #NO.FUN-620024
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",             #No.CHI-950020
      "         ?,?,?,?, ?,?,?,?, ?,?,?,?,?,  ?,?,?,  ?,?,?,  ?,?,?) "   #FUN-560043  #FUN-980010#FUN-AB0061  #FUN-AB0096 add ? #FUN-C50097 ADD 50,51,52
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, s_plant_new ) RETURNING l_sql2   #FUN-A50102
     PREPARE ins_ogb FROM l_sql2
     EXECUTE ins_ogb USING 
       l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb05, 
       l_ogb.ogb05_fac,l_ogb.ogb06,l_ogb.ogb07,l_ogb.ogb08, 
       l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb11, 
       l_ogb.ogb12,l_ogb.ogb37,l_ogb.ogb13,l_ogb.ogb14,l_ogb.ogb14t,#FUN-AB0061 
       l_ogb.ogb15,l_ogb.ogb15_fac,l_ogb.ogb16,l_ogb.ogb17, 
       l_ogb.ogb18,l_ogb.ogb19,l_ogb.ogb20,l_ogb.ogb31,
       l_ogb.ogb32,l_ogb.ogb60,l_ogb.ogb63,l_ogb.ogb64,
       l_ogb.ogb901,l_ogb.ogb902,l_ogb.ogb903,l_ogb.ogb904,
       l_ogb.ogb905,l_ogb.ogb906,l_ogb.ogb907,l_ogb.ogb908,
       l_ogb.ogb909,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,   #FUN-560043
       l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_ogb.ogb916,   #FUN-560043
       l_ogb.ogb917,l_ogb.ogb1001,l_ogb.ogb1002,l_ogb.ogb1003,  #NO.FUN-620024
       l_ogb.ogb1004,l_ogb.ogb1005,l_ogb.ogb1007,l_ogb.ogb1008, #NO.FUN-620024 
       l_ogb.ogb1009,l_ogb.ogb1010,l_ogb.ogb1011,l_ogb.ogb1012,l_ogb.ogb1006,#NO.FUN-620024
       gp_plant,gp_legal   #FUN-980010
      ,l_ogb.ogbud01,l_ogb.ogbud02,l_ogb.ogbud03,l_ogb.ogbud04,l_ogb.ogbud05,
       l_ogb.ogbud06,l_ogb.ogbud07,l_ogb.ogbud08,l_ogb.ogbud09,l_ogb.ogbud10,
       l_ogb.ogbud11,l_ogb.ogbud12,l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,
       l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55  #FUN-C50097 ADD 50,51,52
 
     IF SQLCA.sqlcode<>0 THEN
        CALL cl_err('ins ogb:',SQLCA.sqlcode,1)
        LET g_success = 'N'
     ELSE
        IF NOT s_industry('std') THEN
           INITIALIZE l_ogbi.* TO NULL
           LET l_ogbi.ogbi01 = l_ogb.ogb01
           LET l_ogbi.ogbi03 = l_ogb.ogb03
           IF NOT s_ins_ogbi(l_ogbi.*,s_plant_new) THEN #FUN-980092 add
              LET g_success = 'N'
           END IF
        END IF
#       #FUN-C50136----add----str----
#       IF g_oaz.oaz96 ='Y' THEN
#          CALL s_ccc_oia07('C',l_oga.oga03) RETURNING l_oia07
#          IF l_oia07 = '0' THEN
#             CALL s_ccc_oia(l_oga.oga03,'C',l_oga.oga01,0,s_plant_new)
#          END IF
#       END IF
#       #FUN-C50136----add----end----
     END IF

#FUN-C80001---begin
    IF l_ogb.ogb17='Y' THEN
       IF g_sma.sma115 = 'Y' THEN
          DECLARE p821_g_ogg1 CURSOR FOR 
             SELECT ogg17,ogg092,ogg20 FROM ogg_file
              WHERE ogg01= g_oga.oga01
                AND ogg03= g_ogb.ogb03
              GROUP BY ogg17,ogg092,ogg20 

          FOREACH p821_g_ogg1 INTO g_ogg.ogg17,g_ogg.ogg092,g_ogg.ogg20
             IF STATUS THEN
                CALL cl_err('ogg1',STATUS,1)
             END IF

             SELECT * INTO g_ogg.* FROM ogg_file
              WHERE ogg01= g_oga.oga01
                AND ogg03= g_ogb.ogb03
                AND ogg17= g_ogg.ogg17
                AND ogg092= g_ogg.ogg092
                AND ogg20= g_ogg.ogg20
  
             SELECT SUM(ogg12) INTO g_ogg.ogg12 FROM ogg_file
              WHERE ogg01= g_oga.oga01
                AND ogg03= g_ogb.ogb03
                AND ogg092= g_ogg.ogg092    
                AND ogg20= g_ogg.ogg20
              GROUP BY ogg17,ogg092

              LET l_fac = 1
              SELECT img09 INTO l_img09 FROM img_file
               WHERE img01 = l_ogb.ogb04
                 AND img02 = g_ogg.ogg09
                 AND img03 = g_ogg.ogg091
                 AND img04 = g_ogg.ogg092
              IF l_ogb.ogb05 <> l_img09 THEN
                 CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) 
                      RETURNING l_flag,l_fac
                 IF l_flag = 1 THEN
                    CALL cl_err('','mfg3075',1)
                    LET l_fac = 1
                 END IF
              END IF
              LET g_ogg.ogg16 = g_ogg.ogg12 * l_fac
               
             LET g_ogg.ogg01 = l_oga.oga01
             LET g_ogg.ogg09 = l_ogb.ogb09
             LET g_ogg.ogg091= l_ogb.ogb091
          
             LET l_sql2 = "INSERT INTO ",cl_get_target_table(s_plant_new,'ogg_file'),   
                          "(ogg01,ogg03,ogg09,ogg091,ogg092,ogg10,",
                          " ogg12,ogg15,ogg15_fac,ogg16,ogg20,ogg17,ogg18,",           
                          " oggplant,ogglegal,ogg13) ", 
                          " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "  

	         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
             CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
             PREPARE ins_ogg FROM l_sql2
          
             EXECUTE ins_ogg USING g_ogg.ogg01,g_ogg.ogg03,g_ogg.ogg09,g_ogg.ogg091,g_ogg.ogg092,g_ogg.ogg10,
                                   g_ogg.ogg12,g_ogg.ogg15,g_ogg.ogg15_fac,g_ogg.ogg16,g_ogg.ogg20,g_ogg.ogg17,g_ogg.ogg18,
                                   gp_plant,gp_legal,g_ogg.ogg13  
       
             IF STATUS OR SQLCA.SQLCODE THEN
                LET g_showmsg = g_oga.oga01,"/",g_ogb.ogb03
                CALL s_errmsg('oga01,oga03',g_showmsg,'ins ogg:',SQLCA.sqlcode,1) 
                LET g_success='N'
             END IF     
          END FOREACH 
       ELSE
          DECLARE p821_g_ogc1 CURSOR FOR
             SELECT ogc17,ogc092 FROM ogc_file  
              WHERE ogc01= g_oga.oga01
                AND ogc03= g_ogb.ogb03
              GROUP BY ogc17,ogc092

          FOREACH p821_g_ogc1 INTO g_ogc.ogc17,g_ogc.ogc092
             IF STATUS THEN
                CALL cl_err('ogc1',STATUS,1)
             END IF
             SELECT * INTO g_ogc.* FROM ogc_file
              WHERE ogc01= g_oga.oga01
                AND ogc03= g_ogb.ogb03
                AND ogc17= g_ogc.ogc17
                AND ogc092= g_ogc.ogc092
             
             SELECT SUM(ogc12) INTO g_ogc.ogc12 FROM ogc_file
              WHERE ogc01= g_oga.oga01
                AND ogc03= l_ogb.ogb03
                AND ogc092= g_ogc.ogc092   
              GROUP BY ogc17,ogc092 

              LET l_fac = 1
              SELECT img09 INTO l_img09 FROM img_file
               WHERE img01 = l_ogb.ogb04
                 AND img02 = g_ogc.ogc09
                 AND img03 = g_ogc.ogc091
                 AND img04 = g_ogc.ogc092
              IF l_ogb.ogb05 <> l_img09 THEN
                 CALL s_umfchk(l_ogb.ogb04,l_ogb.ogb05,l_img09) 
                      RETURNING l_flag,l_fac
                 IF l_flag = 1 THEN
                    CALL cl_err('','mfg3075',1)
                    LET l_fac = 1
                 END IF
              END IF
              LET g_ogc.ogc16 = g_ogc.ogc12 * l_fac
           
             LET g_ogc.ogc01 = l_oga.oga01
             LET g_ogc.ogc09 = l_ogb.ogb09
             LET g_ogc.ogc091= l_ogb.ogb091
          
             LET l_sql2 = "INSERT INTO ",cl_get_target_table(s_plant_new,'ogc_file'),   
                          "(ogc01,ogc03,ogc09,ogc091,ogc092,",
                          " ogc12,ogc15,ogc15_fac,ogc16,ogc17,ogc18,",           
                          " ogcplant,ogclegal,ogc13) ", 
                          " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "  

	         CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
             CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
             PREPARE ins_ogc FROM l_sql2
          
             EXECUTE ins_ogc USING g_ogc.ogc01,g_ogc.ogc03,g_ogc.ogc09,g_ogc.ogc091,g_ogc.ogc092,
                                g_ogc.ogc12,g_ogc.ogc15,g_ogc.ogc15_fac,g_ogc.ogc16,g_ogc.ogc17,g_ogc.ogc18,
                                gp_plant,gp_legal,g_ogc.ogc13  
       
             IF STATUS OR SQLCA.SQLCODE THEN
                LET g_showmsg = g_oga.oga01,"/",g_ogb.ogb03
                CALL s_errmsg('oga01,oga03',g_showmsg,'ins ogc:',SQLCA.sqlcode,1) 
                LET g_success='N'
             END IF    
          END FOREACH        
       END IF 
    END IF 
#FUN-C80001---end
    
    # LET l_sql2 = "SELECT ima918,ima921 FROM ",s_dbs_new CLIPPED,"ima_file",  #No.MOD-960050   #FUN-A50102
     LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table( s_plant_new, 'ima_file' ),   #FUN-A50102
                  " WHERE ima01 = '",l_ogb.ogb04,"'",
                  "   AND imaacti = 'Y'"
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, s_plant_new ) RETURNING l_sql2   #FUN-A50102
     PREPARE ima_ogb FROM l_sql2
 
     EXECUTE ima_ogb INTO g_ima918,g_ima921                                                                             
     
    # LET l_sql2 = "SELECT oaz81 FROM ",s_dbs_new CLIPPED,"oaz_file",  #No.MOD-960050   #FUN-A50102
     LET l_sql2 = "SELECT oaz81 FROM ",cl_get_target_table( s_plant_new, 'oaz_file' ),   #FUN-A50102
                  " WHERE oaz00 = '0'"
     
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, s_plant_new ) RETURNING l_sql2   #FUN-A50102
     PREPARE oaz_rvb FROM l_sql2
     
     EXECUTE oaz_rvb INTO l_oaz81
     
     IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
        IF l_oaz81 = "Y" THEN
        
           DECLARE p821_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                             WHERE rvbs01 = g_oga.oga01
                                               AND rvbs02 = g_ogb.ogb03
           LET l_cnt = 0 #CHI-C40031 add
           FOREACH p821_g_rvbs INTO l_rvbs.*
              IF STATUS THEN
                 CALL cl_err('rvbs',STATUS,1)
              END IF
     
              LET l_rvbs.rvbs00 = "axmt850"
           
              LET l_rvbs.rvbs01 = l_ogb.ogb01

              LET l_cnt = l_cnt + 1      #CHI-C40031 add
              LET l_rvbs.rvbs022 = l_cnt #CHI-C40031 add
              
             #IF g_sma.sma96 <> 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
              IF g_pod.pod08 <> 'Y' THEN   #FUN-D30099
              #LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ogb.ogb05_fac #CHI-C40031 mark
        
            #CHI-C40031---add---START
                 IF g_ogb.ogb17='Y' THEN        #多倉儲出貨
                    IF g_sma.sma115 = 'Y' THEN  #多單位
                       LET l_sql = " SELECT * FROM ogg_file ",
                                    "  WHERE ogg01 = '",g_oga.oga01,"'",
                                    "    AND ogg03 = '",g_ogb.ogb03,"'",
                                    "    AND ogg18 = ? "
                       DECLARE p821_g_ogg CURSOR FROM l_sql
                       OPEN p821_g_ogg USING l_rvbs.rvbs13
                       FETCH p821_g_ogg INTO g_ogg.*
                          IF STATUS THEN
                             CALL cl_err('ogg',STATUS,1)
                          END IF
                          IF g_ima906 = '3' AND g_ogg.ogg20 = '2' THEN
                             LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * 1
                          ELSE
                             LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * g_ogg.ogg15_fac
                          END IF
                    ELSE
                       LET l_sql = " SELECT * FROM ogc_file ",
                                   "  WHERE ogc01 = '",g_oga.oga01,"'",
                                   "    AND ogc03 = '",g_ogb.ogb03,"'",
                                   "    AND ogc18 = ? "
                       DECLARE p821_g_ogc CURSOR FROM l_sql
                       OPEN p821_g_ogc USING l_rvbs.rvbs13
                       FETCH p821_g_ogc INTO g_ogc.*
                          IF STATUS THEN
                             CALL cl_err('ogc',STATUS,1)
                          END IF
                          LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * g_ogc.ogc15_fac
                    END IF
                 ELSE
                    LET l_rvbs.rvbs06 = l_rvbs.rvbs06 * l_ogb.ogb05_fac
                 END IF
            #CHI-C40031---add-----END
              END IF   #FUN-C80001
              
              LET l_rvbs.rvbs09 = -1
 
              IF cl_null(l_rvbs.rvbs06) THEN
                 LET l_rvbs.rvbs06 = 0
              END IF
             #IF g_sma.sma96 <> 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
              IF g_pod.pod08 <> 'Y' THEN   #FUN-D30099 
                 LET l_rvbs.rvbs13 = 0    #MOD-9C0139
              END IF                       #FUN-C80001
              #新增批/序號資料檔
              EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                     l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                     l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                     l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,l_rvbs.rvbs13,   #MOD-9C0139
                                     gp_plant,gp_legal   #FUN-980010
        
              IF STATUS OR SQLCA.SQLCODE THEN
                 LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
                 CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
                 LET g_success='N'
              END IF
           
              CALL p821_imgs(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_oga.oga02,l_rvbs.*)
     
           END FOREACH
        END IF
     END IF
 
#FUN-B90012 -------------------------Begin-------------------------
     IF s_industry('icd') THEN 
        #FUN-BA0051 --START mark--
        #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(s_plant_new,'imaicd_file'),",",
        #                                     cl_get_target_table(s_plant_new,'ima_file'),
        #             " WHERE imaicd00 = '",l_ogb.ogb04,"'",
        #             "   AND ima01 = imaicd00 ",
        #             "   AND imaacti = 'Y'"
        #          
        #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
        #CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
        #PREPARE p821_ogb_imaicd08 FROM l_sql2
        #  
        #EXECUTE p821_ogb_imaicd08 INTO l_imaicd08
        #FUN-BA0051 --END mark-- 
#FUN-C80001---begin mark
#        DECLARE p821_g_idd CURSOR FOR SELECT * FROM idd_file
#                            WHERE idd10 = g_oga.oga01
#                              AND idd11 = g_ogb.ogb03
#        
#        #IF l_imaicd08 = 'Y' THEN   #FUN-BA0051 mark
#        IF s_icdbin_multi(l_ogb.ogb04,s_plant_new) THEN   #FUN-BA0051        
#           FOREACH p821_g_idd INTO l_idd.*
#              LET l_idd.idd10 = l_ogb.ogb01
#              LET l_idd.idd11 = l_ogb.ogb03
#        #CHI-C80009---add---START
#              LET l_idd.idd02 = l_ogb.ogb09
#              LET l_idd.idd03 = l_ogb.ogb091
#              LET l_idd.idd04 = l_ogb.ogb092
#        #CHI-C80009---add-----END
#              CALL icd_idb(l_idd.*,s_plant_new)
#           END FOREACH  
#        END IF
#        LET l_sql1 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(s_plant_new,'ogbi_file'),
#                     " WHERE ogbi01 = '",l_ogb.ogb01,"'",
#                     "   AND ogbi03 =  ",l_ogb.ogb03
#        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
#        CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1
#        PREPARE p821_ogbi FROM l_sql1
#        EXECUTE p821_ogbi INTO l_ogbiicd028,l_ogbiicd029
#        CALL s_icdpost(12,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,l_ogb.ogb01,l_ogb.ogb03,
#                       l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,s_plant_new)
#             RETURNING l_flag
#        IF l_flag = 0 THEN
#           LET g_success = 'N'
#        END IF 
#FUN-C80001---end
#FUN-C80001---begin
        LET l_sql2 = "INSERT INTO ",cl_get_target_table(s_plant_new,'idb_file'),   
                     "(idb01,idb02,idb03,idb04,idb05,idb06,idb07,idb08,idb09,idb10,",
                     " idb11,idb12,idb13,idb14,idb15,idb16,idb17,idb18,idb19,idb20,",           
                     " idb21,idb22,idb23,idb24,idb25,idbplant,idblegal,idb26,idb27) ", 
                     " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                     "         ?,?,?,?,?, ?,?,?,?) " 
                       
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
        CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 
        PREPARE ins_idb FROM l_sql2
        
        INITIALIZE l_idb.* TO NULL
        
       #IF l_ogb.ogb17 = 'Y' AND g_sma.sma96 = 'Y' THEN  #FUN-D30099 mark
        IF l_ogb.ogb17 = 'Y' AND g_pod.pod08 = 'Y' THEN  #FUN-D30099
              DECLARE p821_g_idb CURSOR FOR 
               SELECT idb04,idb05,idb06 
                 FROM idb_file
                WHERE idb07= g_oga.oga01
                  AND idb08= g_ogb.ogb03
                GROUP BY idb04,idb05,idb06
                
              FOREACH p821_g_idb INTO l_idb.idb04,l_idb.idb05,l_idb.idb06
                 DECLARE p821_g_idb2 CURSOR FOR SELECT * FROM idb_file
                                                 WHERE idb07 = g_oga.oga01
                                                   AND idb08 = g_ogb.ogb03
                                                   AND idb04 = l_idb.idb04
                                                   AND idb05 = l_idb.idb05
                                                   AND idb06 = l_idb.idb06
                 
                 OPEN p821_g_idb2
                 FETCH p821_g_idb2 INTO l_idb.*
                 CLOSE p821_g_idb2

                 SELECT SUM(idb11),SUM(idb16),SUM(idb17) 
                   INTO l_idb.idb11,l_idb.idb16,l_idb.idb17
                   FROM idb_file
                  WHERE idb07= g_oga.oga01
                    AND idb08= g_ogb.ogb03
                    AND idb04 = l_idb.idb04
                    AND idb05 = l_idb.idb05
                    AND idb06 = l_idb.idb06
                  GROUP BY idb04,idb05,idb06

                  LET l_idb.idb10 = l_idb.idb11
                  LET l_idb.idb07 = l_oga.oga01
                  LET l_idb.idb08 = l_ogb.ogb03
                  LET l_idb.idb02 = l_ogb.ogb09
                  LET l_idb.idb03 = l_ogb.ogb091
                  EXECUTE ins_idb USING l_idb.idb01,l_idb.idb02,l_idb.idb03,l_idb.idb04,l_idb.idb05,
                                        l_idb.idb06,l_idb.idb07,l_idb.idb08,l_idb.idb09,l_idb.idb10,
                                        l_idb.idb11,l_idb.idb12,l_idb.idb13,l_idb.idb14,l_idb.idb15,
                                        l_idb.idb16,l_idb.idb17,l_idb.idb18,l_idb.idb19,l_idb.idb20,
                                        l_idb.idb21,l_idb.idb22,l_idb.idb23,l_idb.idb24,l_idb.idb25,
                                        gp_plant,gp_legal,l_idb.idb26,l_idb.idb27
              END FOREACH 
        ELSE      
           DECLARE p821_g_idb1 CURSOR FOR SELECT * FROM idb_file
                                           WHERE idb07 = g_oga.oga01
                                             AND idb08 = g_ogb.ogb03
           FOREACH p821_g_idb1 INTO l_idb.*
              LET l_idb.idb07 = l_ogb.ogb01
              LET l_idb.idb02 = l_ogb.ogb09
              LET l_idb.idb03 = l_ogb.ogb091
             #IF g_sma.sma96 <> 'Y' THEN  #FUN-D30099 mark
              IF g_pod.pod08 <> 'Y' THEN  #FUN-D30099
                 LET l_idb.idb04 = l_ogb.ogb092
              END IF 
              EXECUTE ins_idb USING l_idb.idb01,l_idb.idb02,l_idb.idb03,l_idb.idb04,l_idb.idb05,
                                    l_idb.idb06,l_idb.idb07,l_idb.idb08,l_idb.idb09,l_idb.idb10,
                                    l_idb.idb11,l_idb.idb12,l_idb.idb13,l_idb.idb14,l_idb.idb15,
                                    l_idb.idb16,l_idb.idb17,l_idb.idb18,l_idb.idb19,l_idb.idb20,
                                    l_idb.idb21,l_idb.idb22,l_idb.idb23,l_idb.idb24,l_idb.idb25,
                                    gp_plant,gp_legal,l_idb.idb26,l_idb.idb27
           END FOREACH                 
        END IF                                
#FUN-C80001---end
     END IF   
#FUN-B90012 -------------------------End---------------------------

     #新增至暫存檔中
     INSERT INTO p821_file VALUES(p_i,l_ogb.ogb01,g_ogb.ogb03,
                                         l_ogb.ogb13,l_oga.oga23,'1')   
     IF SQLCA.sqlcode<>0 THEN 
        CALL cl_err3("ins","p821_file","","",SQLCA.sqlcode,"","ins p821_file",1)   #No.FUN-660167
        LET g_success = 'N'
     END IF
     #單頭之出貨金額
     LET l_oga.oga50 =l_oga.oga50 + l_ogb.ogb14   #原幣出貨金額(未稅)
     LET l_oga.oga51 =l_oga.oga51 + l_ogb.ogb14t  #原幣出貨金額(含稅)
     LET l_oga.oga52 = l_oga.oga50 * l_oga.oga161/100
     LET l_oga.oga53 = l_oga.oga50 * (l_oga.oga162+l_oga.oga163)/100
 
     IF s_aza.aza50 = 'Y' THEN     #使用分銷功能
     #單頭之含稅出貨總金額
        LET l_oga.oga1008 =l_oga.oga1008 + l_ogb.ogb14t   #原幣出貨金額(含稅)
      # LET l_sql4="UPDATE ",s_dbs_tra CLIPPED,"oga_file",   #FUN-980092 add    #FUN-A50102
        LET l_sql4="UPDATE ",cl_get_target_table( s_plant_new, 'oga_file' ),    #FUN-A50102
                   "   SET oga1008 = ? ",
                   " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,s_plant_new) RETURNING l_sql4 #FUN-980092
        PREPARE upd_oga1008 FROM l_sql4
        EXECUTE upd_oga1008 USING l_oga.oga1008,l_oga.oga01
        IF SQLCA.sqlcode<>0 THEN
           CALL cl_err('upd oga:',SQLCA.sqlcode,1)
           LET g_success = 'N'
        END IF
     END IF
 
    # LET l_sql3="UPDATE ",s_dbs_tra CLIPPED,"oga_file",  #FUN-980092 add   #FUN-A50102
      LET l_sql3="UPDATE ",cl_get_target_table( s_plant_new, 'oga_file' ),  #FUN-A50102
                "   SET oga50 = ?, ",
                "       oga51 = ?, ",
                "       oga52 = ?, ",
                "       oga53 = ? ",
                " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,s_plant_new) RETURNING l_sql3 #FUN-980092
     PREPARE upd_oga50 FROM l_sql3
     EXECUTE upd_oga50 USING l_oga.oga50,l_oga.oga51,l_oga.oga52,
                             l_oga.oga53,l_oga.oga01
     IF SQLCA.sqlcode<>0 THEN
        CALL cl_err('upd oga:',SQLCA.sqlcode,1)
        LET g_success = 'N'
     END IF
END FUNCTION
 
#讀取其送貨客戶資料
FUNCTION p821_oea911(l_i)
   DEFINE l_i LIKE type_file.num5    #No.FUN-680137 SMALLINT
      CASE l_i
        WHEN 1    LET p_oea911= g_oea.oea911
        WHEN 2    LET p_oea911= g_oea.oea912
        WHEN 3    LET p_oea911= g_oea.oea913
        WHEN 4    LET p_oea911= g_oea.oea914
        WHEN 5    LET p_oea911= g_oea.oea915
        WHEN 6    LET p_oea911= g_oea.oea916
      END CASE
  RETURN p_oea911
END FUNCTION
 
FUNCTION p821_ima(p_part,p_plant)
 DEFINE p_part  LIKE ima_file.ima01
 DEFINE l_ima02 LIKE ima_file.ima02
 DEFINE l_ima25 LIKE ima_file.ima25
# DEFINE l_qoh   LIKE ima_file.ima262 #FUN-A20044
 DEFINE l_qoh   LIKE type_file.num15_3 #FUN-A20044
 DEFINE l_ima86 LIKE ima_file.ima86
 DEFINE l_ima39 LIKE ima_file.ima39
 DEFINE l_ima35 LIKE ima_file.ima35
 DEFINE l_ima36 LIKE ima_file.ima36
 DEFINE l_sql1  STRING                                                 #MOD-9C0268 
 DEFINE p_plant LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)
 DEFINE l_msg   LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(50)
 DEFINE p_dbs   LIKE azp_file.azp03    #FUN-980092 add
 DEFINE p_dbs_tra   LIKE azw_file.azw05    #FUN-980092 add
 DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044
     #------GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
 
 
     #抓取料件相關資料
    # LET l_sql1 = "SELECT ima02,ima25,ima261+ima262,ima86,ima39,", #FUN-A20044
     LET l_sql1 = "SELECT ima02,ima25,0,ima86,ima39,", #FUN-A20044
                  "       ima35,ima36 ",
                 # " FROM ",p_dbs CLIPPED,"ima_file ",  #FUN-980092 add     #FUN-A50102
                  " FROM ",cl_get_target_table( p_plant, 'ima_file' ),   #FUN-A50102
                  " WHERE ima01='",p_part,"' " 
     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1     #FUN-A50102 
     CALL cl_parse_qry_sql( l_sql1, p_plant ) RETURNING l_sql1   #FUN-A50102
     PREPARE ima_pre1 FROM l_sql1
     IF SQLCA.SQLCODE THEN CALL cl_err('ima_pre',SQLCA.SQLCODE,1) END IF
     DECLARE ima_cs CURSOR FOR ima_pre1
     OPEN ima_cs
     FETCH ima_cs INTO l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
     CALL s_getstock(p_part,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
      LET l_qoh = l_unavl_stk + l_avl_stk #FUN-A20044
      IF SQLCA.SQLCODE <> 0 THEN
        LET l_msg = p_dbs,":",p_part       #FUN-980092 add
        CALL cl_err(l_msg,'axm-297',1)  #No.7742 錯誤訊息加強
        CALL cl_err('sel ima:',SQLCA.SQLCODE,1) 
        LET g_success='N'
     END IF
     CLOSE ima_cs
     RETURN l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
END FUNCTION
 
FUNCTION p821_imd(p_imd01,p_plant) #FUN-980092 add
  DEFINE p_imd01   LIKE imd_file.imd01,
         l_imd11   LIKE imd_file.imd11,
         p_dbs     LIKE type_file.chr21,  #No.FUN-680137 VARCHAR(21)
         l_sql     STRING                                                 #MOD-9C0268
  DEFINE p_plant   LIKE azp_file.azp01    #FUN-980092 add
  DEFINE p_dbs_tra LIKE azw_file.azw05    #FUN-980092 add
 
     #------GP5.2 Modify #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
 
   LET g_errno=''
 #  LET l_sql="SELECT imd11  FROM ",p_dbs CLIPPED," imd_file",   #FUN-A50102
   LET l_sql="SELECT imd11  FROM ",cl_get_target_table( p_plant, 'imd_file' ),   #FUN-A50102
             " WHERE imd01 = '",p_imd01,"'",
             "   AND imd10 = 'S' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql( l_sql, p_plant ) RETURNING l_sql   #FUN-A50102
   PREPARE imd_pre FROM l_sql
   DECLARE imd_cs CURSOR FOR imd_pre
   OPEN imd_cs
   FETCH imd_cs INTO l_imd11
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg4020'
        WHEN l_imd11 ='N'         LET g_errno = 'mfg6080'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(p_dbs,g_errno,1) LET g_success = 'N' 
   END IF
   CLOSE imd_cs
END FUNCTION
 
FUNCTION p821_chkoeo(p_oeo01,p_oeo03,p_oeo04)
  DEFINE p_oeo01 LIKE oeo_file.oeo01
  DEFINE p_oeo03 LIKE oeo_file.oeo03
  DEFINE p_oeo04 LIKE oeo_file.oeo04
  DEFINE l_sql   STRING                                                 #MOD-9C0268
 
#  LET l_sql=" SELECT COUNT(*) FROM ",s_dbs_tra,"oeo_file ",  #FUN-980092 add   #FUN-A50102
  LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table( s_plant_new, 'oeo_file' ),  #FUN-A50102
            "  WHERE oeo01 = '",p_oeo01,"'",
            "    AND oeo03 = '",p_oeo03,"'",
            "    AND oeo04 = '",p_oeo04,"'",
            "    AND oeo08 = '2' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
  PREPARE chkoeo_pre FROM l_sql
  DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
  OPEN chkoeo_cs 
  FETCH chkoeo_cs INTO g_cnt
  IF g_cnt > 0 THEN RETURN 1 ELSE RETURN 0 END IF
END FUNCTION 
 
# 取得多角序號
FUNCTION p821_flow99()
 
     IF cl_null(g_oga.oga99) THEN
        CALL s_flowauno('oga',g_oea.oea904,g_oga.oga02)
             RETURNING g_sw,g_flow99
        IF g_sw THEN
           CALL s_errmsg('','','','tri-011',1) #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
        UPDATE oga_file SET oga99 = g_flow99 WHERE oga01 = g_oga.oga01
        IF SQLCA.SQLCODE THEN
           CALL s_errmsg('oga01',g_oga.oga01,'upd oga99',SQLCA.sqlcode,1)                  #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
        #更新INVOICE ofa99
        IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' AND g_oaz.oaz67 = '1' THEN
           UPDATE ofa_file SET ofa99= g_flow99
            WHERE ofa01 = g_oga.oga27
           IF SQLCA.SQLCODE THEN
              CALL s_errmsg('ofa01',g_oga.oga27,'upd ofa99',SQLCA.sqlcode,1)               #No.FUN-710046
              LET g_success = 'N'
              RETURN
           END IF
        END IF
        #馬上檢查是否有搶號
        LET g_cnt = 0 
        SELECT COUNT(*) INTO g_cnt FROM oga_file 
         WHERE oga99 = g_flow99 AND oga09 = '5'
        IF g_cnt > 1 THEN
           CALL s_errmsg('','','','tri-011',1)  #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
     END IF
END FUNCTION 
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p821_chk99()
  DEFINE l_sql STRING                                                #MOD-9C0268
 
#     LET l_sql = " SELECT COUNT(*) FROM ",s_dbs_tra CLIPPED,"oga_file ",  #FUN-980092 add   #FUN-A50102
     LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table( s_plant_new, 'oga_file' ),    #FUN-A50102
                 "  WHERE oga99 ='",g_flow99,"'",
                 "    AND oga09 = '5' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-980092
     PREPARE ogacnt_pre FROM l_sql
     DECLARE ogacnt_cs CURSOR FOR ogacnt_pre
     OPEN ogacnt_cs 
     FETCH ogacnt_cs INTO g_cnt                                #出貨單
     IF g_cnt > 0 THEN
        LET g_msg = s_dbs_tra CLIPPED,'oga99 duplicate'   #FUN-980092 add
        CALL s_errmsg('','',g_msg,'tri-011',1) #No.FUN-710046
        LET g_success = 'N'
     END IF
END FUNCTION
 
FUNCTION p821_imgs(p_ware,p_loca,p_lot,p_date,p_rvbs)
   DEFINE p_rvbs   RECORD LIKE rvbs_file.*
   DEFINE p_ware   LIKE imgs_file.imgs02
   DEFINE p_loca   LIKE imgs_file.imgs03
   DEFINE p_lot    LIKE imgs_file.imgs04
   DEFINE p_date   LIKE tlfs_file.tlfs111
   DEFINE l_imgs   RECORD LIKE imgs_file.*
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_ima25  LIKE ima_file.ima25
   DEFINE l_sql1,l_sql2    STRING                  #MOD-9C0268
   DEFINE l_n      LIKE type_file.num5
 
   LET l_sql1 = "SELECT COUNT(*) ",
            #   "  FROM ",s_dbs_tra CLIPPED,"imgs_file ",  #No.MOD-960050   #FUN-980092 add  #FUN-A50102
                "  FROM ",cl_get_target_table( s_plant_new, 'imgs_file' ),   #FUN-A50102
                " WHERE imgs01='",p_rvbs.rvbs021,"' ",
                "   AND imgs02='",p_ware,"'",
                "   AND imgs03='",p_loca,"'",
                "   AND imgs04='",p_lot,"'",
                "   AND imgs05='",p_rvbs.rvbs03,"'",
                "   AND imgs06='",p_rvbs.rvbs04,"'",
                "   AND imgs11='",p_rvbs.rvbs08,"'"
  
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE imgs_pre1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
         LET  g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
         CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_pre',SQLCA.SQLCODE,1)
      ELSE
        CALL cl_err('imgs_pre',SQLCA.SQLCODE,1)
      END IF
   END IF
  
   DECLARE imgs_cs CURSOR FOR imgs_pre1
  
   OPEN imgs_cs
   FETCH imgs_cs INTO l_n
  
   IF l_n = 0 THEN
      LET l_imgs.imgs01 = p_rvbs.rvbs021
      LET l_imgs.imgs02 = p_ware
      LET l_imgs.imgs03 = p_loca
      LET l_imgs.imgs04 = p_lot
      LET l_imgs.imgs05 = p_rvbs.rvbs03
      LET l_imgs.imgs06 = p_rvbs.rvbs04
      LET l_imgs.imgs07 = l_ima25
      LET l_imgs.imgs08 = 0
      LET l_imgs.imgs09 = p_rvbs.rvbs05
      LET l_imgs.imgs10 = p_rvbs.rvbs07
      LET l_imgs.imgs11 = p_rvbs.rvbs08
  
 #    LET l_sql2 = "INSERT INTO ",s_dbs_tra CLIPPED,"imgs_file",  #No.MOD-960050  #FUN-980092 add   #FUN-A50102
      LET l_sql2 = "INSERT INTO ",cl_get_target_table( s_plant_new, 'imgs_file' ),   #FUN-A50102
                   "(imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,",
                   " imgs07,imgs08,imgs09,imgs10,imgs11,",
                   " imgsplant,imgslegal)",   #FUN-980010
                   " VALUES( ?,?,?,?,?,?, ?,?,?,?,?,  ?,?)"  #FUN-980010
  
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, s_plant_new ) RETURNING l_sql2   #FUN-A50102
      PREPARE ins_imgs FROM l_sql2
  
      EXECUTE ins_imgs USING l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,
                             l_imgs.imgs04,l_imgs.imgs05,l_imgs.imgs06,
                             l_imgs.imgs07,l_imgs.imgs08,l_imgs.imgs09,
                             l_imgs.imgs10,l_imgs.imgs11,
                             gp_plant,gp_legal   #FUN-980010
      IF SQLCA.sqlcode<>0 THEN
         LET g_msg = s_dbs_tra CLIPPED,'ins imgs'  #No.MOD-960050  #FUN-980092 add
         IF g_bgerr THEN
            LET g_showmsg=p_rvbs.rvbs021,"/",p_ware,"/",p_loca,"/",p_lot,"/",p_rvbs.rvbs03,"/",p_rvbs.rvbs04           
            CALL s_errmsg('imgs01,imgs02,imgs03,imgs04,imgs05,imgs06',g_showmsg,'imgs_ins',SQLCA.SQLCODE,1)
         ELSE
            CALL cl_err("imgs_ins",SQLCA.sqlcode,1)
         END IF
         LET g_success = 'N'
      END IF
   END IF  
 
   LET l_tlfs.tlfs01 = p_rvbs.rvbs021       #異動料件編號
   LET l_tlfs.tlfs02 = p_ware                #倉庫
   LET l_tlfs.tlfs03 = p_loca                #儲位
   LET l_tlfs.tlfs04 = p_lot                 #批號
   LET l_tlfs.tlfs05 = p_rvbs.rvbs03         #序號
   LET l_tlfs.tlfs06 = p_rvbs.rvbs04         #外部批號
  #MOD-C30663 str------
  #LET l_tlfs.tlfs07=l_ima25
   SELECT img09 INTO l_tlfs.tlfs07 FROM img_file
    WHERE img01 = l_tlfs.tlfs01 AND img02 = l_tlfs.tlfs02
      AND img03 = l_tlfs.tlfs03 AND img04 = l_tlfs.tlfs04
  #MOD-C30663 end------
   LET l_tlfs.tlfs08 = p_rvbs.rvbs00
   LET l_tlfs.tlfs09 = 0
   LET l_tlfs.tlfs10 = p_rvbs.rvbs01
   LET l_tlfs.tlfs11 = p_rvbs.rvbs02
   LET l_tlfs.tlfs111 = p_date
   LET l_tlfs.tlfs12 = g_today
   LET l_tlfs.tlfs13 = p_rvbs.rvbs06
   LET l_tlfs.tlfs14 = p_rvbs.rvbs07
   LET l_tlfs.tlfs15 = p_rvbs.rvbs08
 
#  LET l_sql2 = "INSERT INTO ",s_dbs_tra CLIPPED,"tlfs_file",  #No.MOD-960050   #FUN-980092 add    #FUN-A50102
   LET l_sql2 = "INSERT INTO ",cl_get_target_table( s_plant_new, 'tlfs_file' ),    #FUN-A50102
                "(tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,",
                " tlfs06,tlfs07,tlfs08,tlfs09,tlfs10,",
                " tlfs11,tlfs12,tlfs13,tlfs14,tlfs15,",
                " tlfs111,tlfsplant,tlfslegal)",   #FUN-980010
                " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"  #FUN-980010
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql( l_sql2, s_plant_new ) RETURNING l_sql2     #FUN-A50102
   PREPARE ins_tlfs FROM l_sql2
 
   EXECUTE ins_tlfs USING l_tlfs.tlfs01,l_tlfs.tlfs02,l_tlfs.tlfs03,
                          l_tlfs.tlfs04,l_tlfs.tlfs05,l_tlfs.tlfs06,
                          l_tlfs.tlfs07,l_tlfs.tlfs08,l_tlfs.tlfs09,
                          l_tlfs.tlfs10,l_tlfs.tlfs11,l_tlfs.tlfs12,
                          l_tlfs.tlfs13,l_tlfs.tlfs14,l_tlfs.tlfs15,
                          l_tlfs.tlfs111,
                          gp_plant,gp_legal   #FUN-980010
 
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
        LET g_showmsg=l_tlfs.tlfs01,"/",l_tlfs.tlfs12
        CALL s_errmsg('tlfs01,tlfs06',g_showmsg,'ins tlfs:',SQLCA.sqlcode,1)
      ELSE
        CALL cl_err('ins tlfs:',SQLCA.sqlcode,1) 
      END IF
      LET g_success = 'N'
   END IF
   
END FUNCTION
#No:FUN-9C0071--------精簡程式----- 

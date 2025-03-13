# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: axmp910.4gl
# Descriptions...: 三角貿易出貨通知單拋轉作業(反向)
# Date & Author..: NO.FUN-670007 2006/08/10 BY yiting 
# Modify.........: No.FUN-680137 06/09/11 By bnlent 欄位型態用LIKE定義
# Modify.........: No.FUN-6A0094 06/10/31 By yjkhero l_time轉g_time
# Modify.........: NO.FUN-710019 07/01/15 by yiting 
# Modify.........: No.FUN-710046 07/01/23 By yjkhero 錯誤訊息匯整
# Modify.........: No.MOD-740042 07/04/19 By claire 考慮單身合併訂單狀況
# Modify.........: NO.MOD-740423 07/04/26 BY yiting oaz32取法應與出貨單拋轉相同 
# Modify.........: NO.TQC-760191 07/06/26 BY jamie 無法轉換語言別
# Modify.........: NO.MOD-780191 07/08/29 by yiting 拋轉時需檢查單別設定資料
# MOdify.........: No.CHI-790001 07/09/02 By Nicole 修正Insert Into ogd_file Error
# Modify.........: No.MOD-7A0051 07/10/09 By Claire Invoice單身應以(計價數量*單價)而非(數量*單價)
# Modify.........: No.FUN-7B0091 07/11/19 By Sarah oga65預設值抓oea65
# Modify.........: No.TQC-7C0064 07/12/08 By Beryl 判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.........: No.TQC-7C0093 07/12/08 By Davidzv 增加出貨單開窗查詢
# Modify.........: NO.CHI-7B0041 07/12/09 BY claire 中斷點的出貨單不可拋轉
# Modify.........: No.MOD-7C0189 07/12/25 By claire ofb34取ofa011即可
# Modify.........: No.MOD-810043 08/01/04 By claire 來源站不需產生invoice及packing
# Modify.........: No.MOD-810094 08/01/11 By claire (1)合併出貨拋轉訂單資料有問題
#                                                   (2)Invoice 要重取號 
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-840018 08/04/02 By claire ogaconf='Y' 被mark要取消應列入條件
# Modify.........: No.FUN-850100 08/05/19 By Nicola 批/序號管理第二階段
# Modify.........: NO.MOD-860057 08/06/13 BY claire 送貨址址碼(oga044) 價格條件(oga31) 起運地(oga41) 到達地(oga42) 交運方式(oga43) 嘜頭編號(oga44) 皆改為取自出通單
# Modify.........: No.MOD-870278 08/07/24 By claire axm-026改為axm-934
# Modify.........: No.FUN-8A0086 08/10/22 By lutingting完善錯誤循序匯總
# Modify.........: No.MOD-8A0165 08/10/22 By claire 稅別ofa21應取出通單各站的稅別,非來源站的資料
# Modify.........: No.TQC-8B0046 08/11/24 By claire 代採逆拋第0站不需設定出貨資料
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.TQC-930155 09/04/14 By dongbg open cursor或fetch cursor失敗時不要rollback,給g_success賦值
# Modify.........: No.MOD-940204 09/04/15 By Dido 調整 ofa211/ofa212/ofa213 預設值
# Modify.........: No.MOD-940299 09/05/07 By Dido 科目別改用多角流程設定
# Modify.........: No.TQC-950020 09/05/13 By mike 跨庫的SQL語句一律使用s_dbstring()的寫法
# Modify.........: No.FUN-980010 09/08/31 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-8C0125 09/09/09 By chenmoyan INVOICE單別從apmi000中抓
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980092 09/09/22 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-950020 09/10/21 By chenmoyan 将自定义栏位的值抛转各站
# Modify.........: No:MOD-9C0139 09/12/19 By Dido 增加 rvbs13 為 0 
# Modify.........: No:MOD-9C0390 09/12/24 By Dido ogb14 計算邏輯調整;insert ofb916,ofb917 相關欄位  
# Modify.........: No:FUN-9C0073 10/01/06 By chenls 程序精簡
# Modify.........: No.FUN-A10036 10/01/18 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位
# Modify.........: No:CHI-940042 10/01/19 By Dido 參考 oea18 設定出通與invoice匯率 
# Modify.........: No:MOD-A20062 10/02/10 By Dido 檢核資料是否與流程類別相同
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No:MOD-A50103 10/05/17 By Smapmin oga55沒有一併拋轉
# Modify.........: No.FUN-A50102 10/06/18 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No:MOD-A60124 10/07/30 By Smapmin 修改訊息匯總
# Modify.........: No:MOD-A80177 10/10/22 By Smapmin INVOICE的收款條件,應抓取出通單上的資訊
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu  因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga57,ogb50欄位預設值修正
# Modify.........: No.MOD-B30490 11/03/15 By baogc Bug修改
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B90012 11/09/15 By lixh1 多角增加ICD行業
# Modify.........: No.FUN-BA0051 11/11/09 By jason 一批號多DATECODE功能
# Modify.........: No.CHI-C40031 12/05/24 By Sakura 走多倉出貨改為抓取ogc、ogg轉換率,若為多倉儲時,rvbs022 應累增
# Modify.........: No:CHI-C50021 12/06/12 By Sakura 將LET l_oga.oga69=g_today 改成 LET l_oga.oga69=g_oga.oga69
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52
# Modify.........: No.FUN-C50136 12/08/14 BY xianghui 出貨通知單逆拋時如果做信用管控，要進行對oib_file,oic_file的處理
# Modify.........: No.CHI-C80009 12/08/15 By Sakura 一批號多DATECODE功能時,FOREACH需多傳倉儲批
# Modify.........: No.FUN-C80001 12/08/29 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea          RECORD LIKE oea_file.*
DEFINE g_oeb          RECORD LIKE oeb_file.*
DEFINE g_oga          RECORD LIKE oga_file.*    #出貨通知單(來源)
DEFINE g_ogb          RECORD LIKE ogb_file.*    #出貨通知單(來源)
DEFINE l_oga          RECORD LIKE oga_file.*    #出貨通知單(各廠)
DEFINE l_ogb          RECORD LIKE ogb_file.*    #出貨通知單(各廠)
DEFINE g_ogd          RECORD LIKE ogd_file.*
DEFINE g_ofa          RECORD LIKE ofa_file.*
DEFINE g_ofb          RECORD LIKE ofb_file.*
DEFINE l_oea          RECORD LIKE oea_file.*
DEFINE l_oeb          RECORD LIKE oeb_file.*
DEFINE l_rva          RECORD LIKE rva_file.*
DEFINE l_rvb          RECORD LIKE rvb_file.*
DEFINE l_rvu          RECORD LIKE rvu_file.*
DEFINE l_rvv          RECORD LIKE rvv_file.*
DEFINE g_pmm          RECORD LIKE pmm_file.*
DEFINE g_pmn          RECORD LIKE pmn_file.*
DEFINE g_oan          RECORD LIKE oan_file.*
DEFINE l_oha          RECORD LIKE oha_file.*    #NO.FUN-620024
DEFINE l_ohb          RECORD LIKE ohb_file.*    #NO.FUN-620024
DEFINE g_poz          RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.8047
DEFINE g_poy          RECORD LIKE poy_file.*    #流程代碼資料(單身) No.8047
DEFINE s_poy          RECORD LIKE poy_file.*    #來源流程資料(單身) No.8047
DEFINE tm             RECORD
                         oga09 LIKE oga_file.oga09, #FUN-680137  VARCHAR(1),
                         wc    LIKE type_file.chr1000 #No.FUN-680137  VARCHAR(600) 
                      END RECORD
DEFINE p_pmm09        LIKE pmm_file.pmm09,    #廠商代號
       p_poy04        LIKE poy_file.poy04,    #工廠編號
       p_oea03        LIKE oea_file.oea03,    #客戶代號
       p_imd01        LIKE imd_file.imd01,    #各廠預設倉庫
       s_imd01        LIKE imd_file.imd01,    #各廠預設倉庫(來源)
       p_poy16        LIKE poy_file.poy16,    #AR科目類別 #MOD-940299                             
       p_poy28        LIKE poy_file.poy28,    #出貨理由碼 #NO.FUN-620024                             
       p_poy29        LIKE poy_file.poy29,    #代送商編號 #NO.FUN-620024 
       p_poy07        LIKE poy_file.poy07
DEFINE g_flow99       LIKE oga_file.oga99    #No.FUN-680137 VARCHAR(17)    #多角序號    #FUN-560043
DEFINE g_oaz32        LIKE oaz_file.oaz32    #No.FUN-680137 VARCHAR(1)     #匯率方式
DEFINE l_dbs_new      LIKE type_file.chr21   #No.FUN-680137 VARCHAR(21)    #New DataBase Name
DEFINE l_plant_new    LIKE type_file.chr10   #No.FUN-980020
DEFINE l_aza          RECORD LIKE aza_file.*
DEFINE s_aza          RECORD LIKE aza_file.*
DEFINE s_azp          RECORD LIKE azp_file.*
DEFINE l_azp          RECORD LIKE azp_file.*
DEFINE l_azi          RECORD LIKE azi_file.*
DEFINE g_sw           LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
DEFINE g_argv1        LIKE oga_file.oga01
DEFINE g_argv2        LIKE oga_file.oga09
DEFINE p_last         LIKE type_file.num5    #No.FUN-680137 SMALLINT                #流程之最後家數
DEFINE p_last_plant   LIKE cre_file.cre08    #No.FUN-680137 VARCHAR(10)
DEFINE s_price        LIKE ogb_file.ogb13     #來源工廠單價
DEFINE s_oal11        LIKE oal_file.oal11     #記錄下游工廠計價方式
DEFINE s_oal12        LIKE oal_file.oal12     #記錄下游工廠計價方式
DEFINE g_t1           LIKE oay_file.oayslip  #No.FUN-550070  #No.FUN-680137 VARCHAR(05)
DEFINE l_t            LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(05)    #NO.FUN-620024 
DEFINE oga_t1         LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)
DEFINE rva_t1         LIKE oay_file.oayslip  #No.FUN-680137  VARCHAR(5)
DEFINE rvu_t1         LIKE oay_file.oayslip  #No.FUN-680137  VARCHAR(5)
DEFINE p_row,p_col    LIKE type_file.num5    #No.FUN-680137 SMALLINT
DEFINE g_ima906       LIKE ima_file.ima906   #FUN-560043
DEFINE g_oha01        LIKE oha_file.oha01    #銷退單號   #NO.FUN-620024
DEFINE g_oay18        LIKE oay_file.oay18    #銷退理由碼 #NO.FUN-620024
DEFINE g_cnt          LIKE type_file.num10      #No.FUN-680137 INTEGER
DEFINE g_msg          LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(72)
DEFINE p_oga01        LIKE oga_file.oga01 #No.FUN-620054
DEFINE p_oga09        LIKE oga_file.oga09, #No.FUN-620054
       p_pox03  LIKE pox_file.pox03,    #計價基準
       p_pox05  LIKE pox_file.pox05,    #計價方式
       p_pox06  LIKE pox_file.pox06     #計價比率
DEFINE l_poy02  LIKE poy_file.poy02     #FUN-710019 
DEFINE l_c      LIKE type_file.num5     #FUN-710019
DEFINE g_oea99  LIKE oea_file.oea99     #MOD-740042  #合併訂單出貨
DEFINE g_ima918   LIKE ima_file.ima918  #No.FUN-850100
DEFINE g_ima921   LIKE ima_file.ima921  #No.FUN-850100
DEFINE l_rvbs     RECORD LIKE rvbs_file.*  #No.FUN-850100
DEFINE gp_legal   LIKE azw_file.azw02    #FUN-980010 add
DEFINE gp_plant   LIKE azp_file.azp01    #FUN-980010 add
DEFINE l_dbs_tra  LIKE azw_file.azw05    #FUN-980092 add
DEFINE g_ogg      RECORD LIKE ogg_file.*  #CHI-C40031 add
DEFINE g_ogc      RECORD LIKE ogc_file.*  #CHI-C40031 add
 
 
FUNCTION p910(p_argv1,p_argv2)
   DEFINE p_argv1     LIKE oga_file.oga01
   DEFINE p_argv2     LIKE oga_file.oga09
 
   WHENEVER ERROR CONTINUE
  
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
 
   CREATE TEMP TABLE p910_file(
       p_no        LIKE type_file.chr1000,
       pab_no      LIKE oea_file.oea01,
       pab_item    LIKE type_file.num5,  
       pab_price   LIKE type_file.num20_6)
 
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
 
   #若有傳參數則不用輸入畫面
   IF cl_null(g_argv1) THEN 
      CALL p910_p1()
   ELSE
      LET tm.wc = " oga01='",g_argv1,"' " 
      #要判斷來源為銷售或代採買段--
      LET tm.oga09 = g_argv2
 
      OPEN WINDOW win AT 10,5 WITH 6 ROWS,70 COLUMNS 
      CALL p910_p2('','','')        #No.FUN-620054
 
      DROP TABLE p910_file   
 
      CLOSE WINDOW win
   END IF
 
END FUNCTION
 
FUNCTION p910_p1()
   DEFINE l_flag  LIKE type_file.num5    #No.FUN-680137  SMALLINT
 
   LET p_row = 5 LET p_col = 16
 
   OPEN WINDOW p910_w AT p_row,p_col
     WITH FORM "axm/42f/axmp910"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
 
   WHILE TRUE
      LET g_action_choice = ''
      
      CONSTRUCT BY NAME tm.wc ON oga01,oga02 
      
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
 
         ON ACTION locale
            LET g_action_choice='locale'
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
 
         ON ACTION controlp
            CASE WHEN INFIELD(oga01)
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_oga13" 
               LET g_qryparam.state = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret to oga01
               NEXT FIELD oga01
            END CASE
 
      END CONSTRUCT
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup') #FUN-980030
 
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      INPUT BY NAME tm.oga09 WITHOUT DEFAULTS 
 
         AFTER FIELD oga09
            IF cl_null(tm.oga09) THEN
               NEXT FIELD oga09
            END IF
            IF tm.oga09 NOT MATCHES '[46]' THEN
               NEXT FIELD oga09 
            END IF
            #取得多角貿易使用匯率
            IF tm.oga09 = '4' THEN
               LET g_oaz32 = g_oax.oax01     
            ELSE
               SELECT pod01 INTO g_oaz32 FROM pod_file
                WHERE pod00 = '0'
            END IF
            IF cl_null(g_oaz32) THEN 
               LET g_oaz32 = 'S'
            END IF
      
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
         
         ON ACTION CONTROLG 
            CALL cl_cmdask()
         
         ON ACTION locale
            LET g_action_choice='locale'
            EXIT INPUT 
         
         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
         
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
         
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
      
         ON ACTION qbe_save
            CALL cl_qbe_save()
 
      END INPUT
 
      IF g_action_choice = 'locale' THEN
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN 
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      IF cl_sure(0,0) THEN 
         CALL p910_p2('','','')        #No.FUN-620054
         IF g_success = 'Y' THEN
            CALL cl_end2(1) RETURNING l_flag
         ELSE
            CALL cl_end2(2) RETURNING l_flag
         END IF
 
         IF l_flag THEN 
            CONTINUE WHILE
         ELSE
            EXIT WHILE
         END IF
      END IF
   END WHILE
 
   CLOSE WINDOW p910_w
 
END FUNCTION
 
FUNCTION p910_p2(p_oga01,p_oga09,p_plant)          #No.FUN-620054  #FUN-980092 add
   DEFINE l_ogb01    LIKE ogb_file.ogb01  #MOD-620053 add
   DEFINE l_ogb03    LIKE ogb_file.ogb03  #MOD-620053 add
   DEFINE l_ogb31    LIKE ogb_file.ogb31  #MOD-620053 add
   DEFINE l_ogb32    LIKE ogb_file.ogb32  #MOD-620053 add
   DEFINE l_tlf99    LIKE tlf_file.tlf99  #MOD-620053 add
   DEFINE p_oga01            LIKE oga_file.oga01 #No.FUN-620054
   DEFINE p_oga09            LIKE oga_file.oga09 #No.FUN-620054
   DEFINE p_dbs       LIKE type_file.chr21   #No.FUN-680137       VARCHAR(21)            #No.FUN-620054
   DEFINE l_pmm       RECORD LIKE pmm_file.*
   DEFINE l_pmn       RECORD LIKE pmn_file.*
   DEFINE l_occ       RECORD LIKE occ_file.*
   DEFINE l_pmc       RECORD LIKE pmc_file.*
   DEFINE l_oal       RECORD LIKE oal_file.*
   DEFINE l_oam       RECORD LIKE oam_file.*
   DEFINE l_gec       RECORD LIKE gec_file.*
   DEFINE l_ima       RECORD LIKE ima_file.*
   DEFINE #l_sql       LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
           l_sql,l_sql1,l_sql2    STRING     #NO.FUN-910082 
   DEFINE i,l_i       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE o_oal11     LIKE oal_file.oal11     #計價方式
   DEFINE diff_azi    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(1)     #若為Y表示單身計價方式有所不同
          l_cnt       LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          azi_oal11   LIKE oal_file.oal11,   #記錄單頭該用之計價方式
          min_oeb15   LIKE oeb_file.oeb15    #記錄該訂單之最小預交日
   DEFINE l_j         LIKE type_file.num5,    #No.FUN-680137 SMALLINT
          l_msg       LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
   DEFINE l_oea62     LIKE oea_file.oea62
   DEFINE s_oea62     LIKE oea_file.oea62
   DEFINE l_oeb24     LIKE oeb_file.oeb24 
   DEFINE l_x         LIKE oay_file.oayslip  #No.FUN-680137 VARCHAR(5)                   #No.FUN-550070
   DEFINE p_oeb       RECORD LIKE oeb_file.*  
   DEFINE l_ogd01     LIKE ogd_file.ogd01       #包裝單號
   DEFINE g_ogd01     LIKE ogd_file.ogd01       #包裝單號
   DEFINE l_ofa01     LIKE ofa_file.ofa01       #INVOICE 單號
   DEFINE l_slip      LIKE ofa_file.ofa01       #INVOICE 單號
   DEFINE li_result   LIKE type_file.num5     #FUN-560043  #No.FUN-680137 SMALLINT
   DEFINE l_oga01     LIKE oga_file.oga01       #FUN-630053 add
   DEFINE l_no    LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_price LIKE ogb_file.ogb13,
          l_currm LIKE pmm_file.pmm42,      #計價幣別依原始來源廠的匯率
          x_currm LIKE pmm_file.pmm42,
          l_curr  LIKE pmm_file.pmm22      #No.FUN-680137 VARCHAR(04)
   DEFINE l_poz01     LIKE poz_file.poz01,
          l_poz18     LIKE poz_file.poz18,
          l_poz19     LIKE poz_file.poz19,
          l_c         LIKE type_file.num5
   DEFINE l_ogdi  RECORD LIKE ogdi_file.*  #NO.FUN-7B0018
   DEFINE p_plant LIKE azp_file.azp01     #FUN-980092 add
   DEFINE l_dbs   LIKE azp_file.azp03     #FUN-980092 add
   DEFINE l_azp03 LIKE azp_file.azp03     #FUN-980092 add
 
   
   CALL cl_wait() 
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      BEGIN WORK 
   END IF
 
   #改抓Transaction DB
   IF NOT cl_null(p_plant) THEN
      SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
      LET p_dbs = s_dbstring(l_azp03)
 
      LET g_plant_new = p_plant
      CALL s_gettrandbs()
      LET l_dbs = g_dbs_tra
   END IF
 
   LET g_success='Y'
   CALL s_showmsg_init()        #MOD-A60124
   DELETE FROM p910_file
   LET g_cnt=0
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql= "SELECT COUNT(*) FROM oga_file ",
                 " WHERE oga909='Y' ",    #三角貿易出貨單
                 "   AND oga905='N'  ",    #拋轉否
                 "   AND oga906='Y' ",     #必須為起始出貨單
                 "   AND ogaconf='Y' ",    #必須為已確認單   #MOD-840018 cancle mark
                 "   AND oga09 = '5'",
                 "   AND ",tm.wc CLIPPED
   ELSE
      #LET l_sql= "SELECT COUNT(*) FROM ",l_dbs CLIPPED,"oga_file ",  #FUN-980092 add
      LET l_sql= "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                 " WHERE oga909='Y' ",    #三角貿易出貨單
                 "   AND oga905='N'  ",    #拋轉否
                 "   AND oga906='Y' ",     #必須為起始出貨單
                 "   AND ogaconf='Y' ",    #必須為已確認單
                 "   AND oga01 = '",p_oga01,"' ",
                 "   AND oga09 = '5'"
   END IF
   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
   PREPARE p910_p2 FROM l_sql
   DECLARE p910_curs2 CURSOR FOR p910_p2
   
   OPEN p910_curs2
   FETCH p910_curs2 INTO g_cnt
   CLOSE p910_curs2
   
   IF g_cnt=0 THEN
      LET g_success = 'N'   #FUN-560043
      CALL cl_err('','mfg9169',1) 
      RETURN
   END IF
   
   #讀取符合條件之三角貿易訂單資料
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      LET l_sql= "SELECT * FROM oga_file ",
                 " WHERE oga909='Y' ",    #三角貿易出貨單
                 "   AND oga905='N'  ",    #拋轉否
                 "   AND oga906='Y' ",     #必須為起始出貨單
                 "   AND oga09 = '5'" ,
                 "   AND ",tm.wc CLIPPED
   
   ELSE
      #LET l_sql= "SELECT * FROM ",l_dbs CLIPPED,"oga_file ",
      LET l_sql= "SELECT * FROM ",cl_get_target_table(p_plant,'oga_file'), #FUN-A50102
                 " WHERE oga909='Y' ",    #三角貿易出貨單
                 "   AND oga905='N'  ",    #拋轉否
                 "   AND oga906='Y' ",     #必須為起始出貨單
                 "   AND ogaconf='Y' ",    #必須為已確認單
                 "   AND oga01 = '",p_oga01,"' ",
                 "   AND oga09 = '5' "
   END IF
   
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
   PREPARE p910_p1 FROM l_sql 
   IF SQLCA.SQLCODE THEN 
      CALL cl_err('pre1',SQLCA.SQLCODE,1) 
   END IF
   
   DECLARE p910_curs1 CURSOR FOR p910_p1
   FOREACH p910_curs1 INTO g_oga.*
       IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
       END IF                                                     
      IF SQLCA.SQLCODE <> 0 THEN
         LET g_success = 'N'                  #No.FUN-8A0086
         EXIT FOREACH
      END IF
   
      IF cl_null(g_oga.oga16) THEN     #modi in 00/02/24 by kammy
         #只讀取第一筆訂單之資料
         IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
            LET l_sql1= " SELECT * FROM oea_file,ogb_file ",
                        "  WHERE oea01 = ogb31 ",
                        "    AND ogb01 = '",g_oga.oga01,"'"
         ELSE
            LET l_sql1= " SELECT * ",
                        #"   FROM ",l_dbs CLIPPED,"oea_file,",l_dbs CLIPPED,"ogb_file ",  #FUN-980092 add
                        "   FROM ",cl_get_target_table(p_plant,'oea_file'),",", #FUN-A50102
                                   cl_get_target_table(p_plant,'ogb_file'),     #FUN-A50102
                        "  WHERE oea01 = ogb31 ",
                        "    AND ogb01 = '",g_oga.oga01,"'"
         END IF
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092
         PREPARE oea_pre FROM l_sql1
         DECLARE oea_f CURSOR FOR oea_pre
         OPEN oea_f
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            IF g_bgerr THEN
               CALL s_errmsg('oga01',g_oga.oga01,' ',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_oga.oga01,SQLCA.sqlcode,1)
            END IF
            CONTINUE FOREACH
         END IF
         FETCH oea_f INTO g_oea.*
         IF SQLCA.sqlcode THEN
            LET g_success = 'N'
            IF g_bgerr THEN
               CALL s_errmsg('oga01',g_oga.oga01,' ',SQLCA.sqlcode,1)
            ELSE
               CALL cl_err(g_oga.oga01,SQLCA.sqlcode,1)
            END IF
            CONTINUE FOREACH
         END IF
 
      ELSE
         #讀取該出貨單之訂單
         IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
            SELECT * INTO g_oea.*
              FROM oea_file
             WHERE oea01 = g_oga.oga16
         ELSE
            LET l_sql1 = " SELECT * ",
                         #"   FROM ",p_dbs CLIPPED,"oea_file ",
                         "   FROM ",cl_get_target_table(p_plant,'oea_file'),     #FUN-A50102
                         "  WHERE oea01 = '",g_oga.oga16,"' "
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
            PREPARE oea_pre2 FROM l_sql1
            EXECUTE oea_pre2 INTO g_oea.*
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg('oga01',g_oga.oga16,' ',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err(g_oga.oga16,SQLCA.sqlcode,1)
               END IF
               CONTINUE FOREACH
            END IF
         END IF
      END IF
     
     #判斷是否為中斷點
      SELECT poz01,poz18,poz19 INTO l_poz01,l_poz18,l_poz19  
        FROM poz_file
       WHERE poz01  = g_oea.oea904
      
      LET l_c = 0
     IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN    #已設立中斷點
         SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設>
           FROM poy_file
         WHERE poy01 = l_poz01
           AND poy04 = l_poz18
     END IF 
     IF l_c > 0 THEN
        IF g_bgerr THEN
          CALL s_errmsg('oga01',g_oga.oga01,' ','axm-950',1)  
        END IF
         LET g_success = 'N'
         CONTINUE FOREACH                          
     END IF
 
   
      IF g_oea.oea902 = 'N' THEN
         IF g_bgerr THEN   
           CALL s_errmsg('oea01',g_oga.oga16,' ','axm-934',1)   #MOD-870278 modify  
         ELSE
           CALL cl_err('','axm-934',1)   #MOD-870278 modify
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH                                #NO.FUN-710046  
      END IF
   
      #檢查各工廠關帳日(sma53)
      IF s_mchksma53(g_oea.oea904,g_oga.oga02) THEN
      IF g_bgerr THEN  
         CALL s_errmsg('oea01',g_oga.oga16,' ',' ',1)
      END IF
         LET g_success = 'N'
         CONTINUE FOREACH                           #NO.FUN-710046  
      END IF
   
      #讀取三角貿易流程代碼資料
      SELECT * INTO g_poz.*
        FROM poz_file
       WHERE poz01=g_oea.oea904   #內部流程代碼
      IF SQLCA.sqlcode THEN
         IF  g_bgerr THEN  
           CALL s_errmsg('poz01',g_oea.oea904,' ','axm-318',0)              
         ELSE 
          CALL cl_err3("sel","poz_file",g_oea.oea904,"","axm-318","","",0)
         END  IF
         LET g_success = 'N'
         CONTINUE FOREACH                                                   #NO.FUN-710046                
      END IF
   
     #-MOD-A20062-add-   
      IF tm.oga09 = '4' AND g_poz.poz00='2' THEN
         IF g_bgerr THEN
           CALL s_errmsg('poz01',g_oea.oea904,g_oea.oea904,'tri-008',1) 
         ELSE 
           CALL cl_err(g_oea.oea904,'tri-008',1) 
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH        
      END IF
   
      IF tm.oga09 = '6' AND g_poz.poz00='1' THEN
         IF g_bgerr THEN
           CALL s_errmsg('poz01',g_oea.oea904,g_oea.oea904,'tri-008',1)    
         ELSE 
           CALL cl_err(g_oea.oea904,'tri-008',1)
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH         
      END IF
     #-MOD-A20062-end-   

      #No.9508
      #取得多角貿易使用匯率
      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
          IF tm.oga09 = '4' THEN           #NO.MOD-740423
              LET g_oaz32 = g_oax.oax01    #NO.FUN-670007
          ELSE
              SELECT pod01 INTO g_oaz32 FROM pod_file
               WHERE pod00 = '0'
          END IF
      ELSE
          IF tm.oga09 = '4' THEN           #NO.MOD-740423
              LET g_oaz32= g_oax.oax01    #NO.FUN-670007
          ELSE
              LET l_sql = "SELECT pod01 ",
                          #"  FROM ",p_dbs CLIPPED,"pod_file ",
                          "  FROM ",cl_get_target_table(p_plant,'pod_file'), #FUN-A50102
                          " WHERE pod00 = '0' "
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
              PREPARE pod01_pre FROM l_sql
              EXECUTE pod01_pre INTO g_oaz32
          END IF
      END IF
      IF cl_null(g_oaz32) THEN
          LET g_oaz32 = 'S'
      END IF
 
      IF g_poz.pozacti = 'N' THEN 
         IF g_bgerr THEN 
           CALL s_errmsg('pod01',0,g_oea.oea904,'tri-009',1) 
         ELSE
           CALL cl_err(g_oea.oea904,'tri-009',1)
         END IF 
         LET g_success = 'N'
         CONTINUE FOREACH                       #NO.FUN-710046 
      END IF
   
      IF g_poz.poz011 = '1' THEN
         IF g_bgerr THEN   
           CALL s_errmsg('pod01',0,g_oea.oea904,'tri-009',1) 
         ELSE
           CALL cl_err('','axm-412',1)   
         END IF
         LET g_success = 'N'
         CONTINUE FOREACH                       #NO.FUN-710046 
      END IF
   
      CALL p910_flow99()                           #No.8047 取得多角序號
      IF NOT cl_null(p_oga01) AND NOT cl_null(p_oga09) THEN
         IF cl_null(g_flow99) THEN 
            LET g_flow99 = g_oga.oga99
            LET tm.oga09 = '5'
         END IF
      END IF
      CALL s_mtrade_last_plant(g_oea.oea904) 
                     RETURNING p_last,p_last_plant    #記錄最後一筆之家數
      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
         IF p_last_plant != g_plant THEN
            CALL cl_err('','axm-410',1)
            CLOSE WINDOW p910_w
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
            EXIT PROGRAM
         END IF
      END IF
      LET s_oea62=0
      #依流程代碼最多6層
      FOR i = p_last TO 0 STEP -1  
         #因為反相拋轉，銷售段來源廠必須 insert 一筆出貨通知單(採購段不用)
         ##若為最終工廠則不須再 insert 出貨通知單
         IF i = p_last THEN
            CONTINUE FOR 
         END IF
   
         #得到廠商/客戶代碼及database
         CALL p910_azp(i)
 
         LET gp_plant = g_poy.poy04                    #FUN-980010 add
         CALL s_getlegal(gp_plant) RETURNING gp_legal  #FUN-980010 add
 
         CALL p910_chk99()            #No.8047       
         CALL p910_azi(g_oea.oea23,l_plant_new)              #讀取幣別資料  #FUN-980092 add
 
         #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"rvbs_file",   #FUN-980092 add
         LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'rvbs_file'), #FUN-A50102
                      "(rvbs00,rvbs01,rvbs02,rvbs021,rvbs022,rvbs03,",
                      " rvbs04,rvbs05,rvbs06,rvbs07,rvbs08,rvbs09,rvbs13,",          #MOD-9C0139
                      " rvbsplant,rvbslegal) ",  #FUN-980010
                      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?,  ?,?,?) "  #FUN-980010    #MOD-9C0139
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
         PREPARE ins_rvbs FROM l_sql2
 
         #抓取單別拋轉設定檔
         LET g_t1 = s_get_doc_no(g_oga.oga01)         #No.FUN-550070
         CALL s_mutislip('4','',g_t1,g_poz.poz01,i)                      
             RETURNING g_sw,oga_t1,rva_t1,rvu_t1,l_x,l_x   #No.8047
         IF g_sw THEN 
             LET g_success = 'N'
             EXIT FOREACH 
         END IF 
         IF g_poz.poz00 != '2' AND i <> 0 THEN   #NO.TQC-8B0046 add代採段第0站無出貨單資料，不需檢查
         IF cl_null(oga_t1) THEN
             LET g_msg = l_dbs_tra CLIPPED,oga_t1 CLIPPED  #FUN-980092 add
             IF g_bgerr THEN
                CALL s_errmsg("","","g_msg",'axm4014',1)
             ELSE
                CALL cl_err3("","","","",'axm4014',"","g_msg",1)
             END IF
             LET g_success = 'N'
             EXIT FOREACH
         ELSE                                                                                                                   
            LET l_cnt = 0                                                                                                       
            #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"oay_file ",
            LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102          
                        " WHERE oayslip = '",oga_t1,"'"                                                                         
 	        CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
            CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
            PREPARE oay_pre1 FROM l_sql                                                                                         
            EXECUTE oay_pre1 INTO l_cnt                                                                                         
            IF l_cnt = 0 THEN                                                                                                   
              LET g_msg = l_dbs_new CLIPPED,oga_t1 CLIPPED                                                                     
              IF g_bgerr THEN                                            
                 CALL s_errmsg("","","g_msg",'axm-931',1)                
              ELSE                                                       
                 CALL cl_err3("","","","",'axm-931',"","g_msg",1)        
              END IF 
              LET g_success = 'N'                                                                                              
              EXIT FOREACH                                                                                                     
           END IF                                                                                                              
        END IF
        END IF                        #No.TQC-8B0046 add
         SELECT poy02 INTO l_poy02
           FROM poy_file
          WHERE poy01 = g_poz.poz01
            AND poy04 = g_poz.poz18
         LET l_c = 0
         SELECT COUNT(*) INTO l_c   #check poz18設定的中斷營運中心是否存在單身設>
           FROM poy_file
         WHERE poy01 = g_poz.poz01
           AND poy04 = g_poz.poz18
         IF (g_poz.poz19 = 'Y' AND l_c > 0) THEN    #己設立中斷點
             IF g_poy.poy02 <= l_poy02 THEN         #目前站別>中斷點站別時繼續拋轉 
                 EXIT FOR 
             END IF
         END IF
         #新增出貨通知單單頭檔(oga_file)
         IF tm.oga09 = '4' OR (tm.oga09 = '6' AND i <> 0) #No.8047
            OR (tm.oga09 = '6' AND g_oea.oea37="Y" AND i = 0 
            AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN   #No.FUN-630006 No.FUN-620054   #No.FUN-640025   #NO.TQC-640134
            CALL p910_ogains(i)      #No.FUN-620054
         END IF
         IF g_success='N' THEN
            EXIT FOR
         END IF
   
         LET l_oea62=0
   
         #讀取出貨通知單身檔(ogb_file)
         IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
            LET l_sql = " SELECT ogb_file.*,oea_file.oea99 ",
                        "   FROM ogb_file,oea_file ",
                        "  WHERE ogb01 = '",g_oga.oga01,"' ",
                        "    AND ogb31 = oea01",     
                        "    AND ogb1005 = '1'" 
         ELSE
            #LET l_sql = " SELECT ogb_file.*,oea_file.oea99 FROM ",l_dbs CLIPPED,"ogb_file, ",   #FUN-980092 add
            #                             l_dbs CLIPPED,"oea_file ",                            #FUN-980092 add
            LET l_sql = " SELECT ogb_file.*,oea_file.oea99 FROM ",cl_get_target_table(p_plant,'ogb_file'),",", #FUN-A50102 
                                                                  cl_get_target_table(p_plant,'oea_file'),     #FUN-A50102
                        "  WHERE ogb01 = '",g_oga.oga01,"' ",
                        "    AND ogb31 = oea01",     
                        "    AND ogb1005 = '1'" 
         END IF
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
         PREPARE ogb_pre FROM l_sql
         DECLARE ogb_cus CURSOR FOR ogb_pre
         FOREACH ogb_cus INTO g_ogb.* ,g_oea99   #MOD-740042 modify
            IF SQLCA.SQLCODE <>0 THEN
               EXIT FOREACH
            END IF 
            IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
               SELECT ima906 INTO g_ima906 FROM ima_file
                WHERE ima01 = g_ogb.ogb04
            ELSE
               LET l_sql = "SELECT ima906 ",
                           #"  FROM ",p_dbs CLIPPED,"ima_file ",
                           "  FROM ",cl_get_target_table(p_plant,'ima_file'),     #FUN-A50102
                           " WHERE ima01 = '",g_ogb.ogb04,"' "
 	           CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
               CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-A50102
               PREPARE ima906_pre FROM l_sql
               EXECUTE ima906_pre INTO g_ima906
            END IF
 
            # 單身訂單多角序號
            LET l_sql1= " SELECT * ",
                        #"   FROM ",l_dbs CLIPPED,"oea_file ",   #FUN-980092 add
                        "   FROM ",cl_get_target_table(p_plant,'oea_file'),     #FUN-A50102
                        "  WHERE oea01 = '",g_ogb.ogb31,"'"
 	     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-980092
            PREPARE oea99_pre FROM l_sql1
            DECLARE oea99_cus CURSOR FOR oea99_pre
            OPEN oea99_cus
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg('oea01',g_ogb.ogb31,' ',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err(g_ogb.ogb31,SQLCA.sqlcode,1)
               END IF
               CONTINUE FOREACH
            END IF
            FETCH oea99_cus INTO g_oea.*
            IF SQLCA.sqlcode THEN
               LET g_success = 'N'
               IF g_bgerr THEN
                  CALL s_errmsg('oea01',g_ogb.ogb31,' ',SQLCA.sqlcode,1)
               ELSE
                  CALL cl_err(g_ogb.ogb31,SQLCA.sqlcode,1)
               END IF
               CONTINUE FOREACH
            END IF
            # 單身訂單多角序號
 
            #---- 新增出貨單通知單身檔(ogb_file)----
            IF tm.oga09 = '4' OR (tm.oga09 = '6' AND i <> 0) #No.8047
            OR (tm.oga09 = '6' AND g_oea.oea37="Y" AND i = 0 
            AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN   #No.FUN-630006 No.FUN-620054   #No.FUN-640025   #NO.TQC-640134
               CALL p910_ogbins(i,l_plant_new)  #No.FUN-620054 #FUN-980092 add
            END IF
          END FOREACH
         IF tm.oga09 = '4' OR (tm.oga09 = '6' AND i <> 0) 
            OR (tm.oga09 = '6' AND g_oea.oea37="Y" AND i = 0 
            AND cl_null(p_oga01) AND g_oaz.oaz19 = 'Y') THEN  
          #---------------- 是否拋轉 Packing List ----------------------
          IF g_oax.oax05='Y' AND g_oaz.oaz67 = '1'  THEN  #NO.FUN-670007
             IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                SELECT COUNT(*) INTO l_cnt FROM ogd_file,oga_file
                 WHERE ogd01 = oga01
                   AND (oga16 = g_oga.oga16 OR oga16 IS NULL)
                   AND oga30='Y'  
                   AND oga01=g_oga.oga01
             ELSE
                 LET l_sql = "SELECT COUNT(*) ",
                             #"  FROM ",l_dbs CLIPPED,"ogd_file,",l_dbs CLIPPED,"oga_file ",   #FUN-980092 add
                             "  FROM ",cl_get_target_table(p_plant,'ogd_file'),",", #FUN-A50102
                                       cl_get_target_table(p_plant,'oga_file'),     #FUN-A50102
                             " WHERE ogd01 = oga01 ",
                             "   AND (oga16 = '",g_oga.oga16,"' OR oga16 IS NULL) "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
                 PREPARE ogd_pre FROM l_sql
                 EXECUTE ogd_pre INTO l_cnt
             END IF
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
                  #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ogd_file",  #FUN-980092 add
                  LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogd_file'),     #FUN-A50102
                             "(ogd01,ogd03,ogd04,ogd08,ogd09, ",
                             " ogd10,ogd11,ogd12b,ogd12e,ogd13, ",
                             " ogd14,ogd15,ogd16,ogd14t,ogd15t, ",
                             " ogd16t, ogdplant,ogdlegal)",  #FUN-980010
                             " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                             "         ?, ?,? )"   #FUN-980010
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                  PREPARE ins_ogd FROM l_sql2
                  EXECUTE ins_ogd USING 
                   g_ogd.ogd01,g_ogd.ogd03,g_ogd.ogd04,g_ogd.ogd08,g_ogd.ogd09,
                   g_ogd.ogd10,g_ogd.ogd11,g_ogd.ogd12b,g_ogd.ogd12e,
                   g_ogd.ogd13,
                   g_ogd.ogd14,g_ogd.ogd15,g_ogd.ogd16,g_ogd.ogd14t,
                   g_ogd.ogd15t,g_ogd.ogd16t,
                   gp_plant,gp_legal   #FUN-980010
                   IF SQLCA.sqlcode<>0 THEN
                      IF  g_bgerr THEN
                        LET g_showmsg=g_ogd.ogd01,"/",g_ogd.ogd03,"/",g_ogd.ogd04               
                        CALL s_errmsg('ogd01,ogd03,ogd04',g_showmsg,'ins ogd:',SQLCA.sqlcode,1) 
                      ELSE
                        CALL cl_err('ins ogd:',SQLCA.sqlcode,1)
                      END IF
                      LET g_success = 'N' EXIT FOREACH 
                   END IF
                   IF NOT s_industry('std') THEN
                      INITIALIZE l_ogdi.* TO NULL
                      LET l_ogdi.ogdi01 = g_ogd.ogd01
                      LET l_ogdi.ogdi03 = g_ogd.ogd03
                      LET l_ogdi.ogdi04 = g_ogd.ogd04
                      IF NOT s_ins_ogdi(l_ogdi.*,l_plant_new) THEN #FUN-980092 add
                         LET g_success = 'N'
                      END IF
                   END IF
               END FOREACH
               #更新包裝單確認碼
               #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oga_file",   #FUN-980092 add
               LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                          " SET oga30 = 'Y' ",
                          " WHERE oga01 = ?  "
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE upd_oga30 FROM l_sql2
               EXECUTE upd_oga30 USING l_ogd01
               IF SQLCA.sqlcode<>0 OR sqlca.sqlerrd[3]=0  THEN  #MOD-810094 modify [3]
                  IF g_bgerr THEN    
                    CALL s_errmsg('oga01',l_ogd01,'upd oga30:',SQLCA.sqlcode,1) 
                  ELSE
                    CALL cl_err('upd oga30:',SQLCA.sqlcode,1)
                  END IF 
                  LET g_success = 'N' EXIT FOR
               END IF
             END IF
          END IF
          #------------- 是否拋轉 Invoice --------------------------
          IF g_oax.oax04='Y' AND g_oaz.oaz67 = '1'  THEN  #NO.FUN-670007
             LET l_slip = g_oga.oga27
              IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
                  SELECT COUNT(*) INTO l_cnt FROM ofa_file,ofb_file
                   WHERE ofa01=l_slip      AND ofaconf='Y'
                     AND ofa01=ofb01
              ELSE
                  LET l_sql = "SELECT COUNT(*) ",
                              #"  FROM ",l_dbs CLIPPED,"ofa_file,",l_dbs CLIPPED,"ofb_file ",   #FUN-980092 add
                              "  FROM ",cl_get_target_table(p_plant,'ofa_file'),",", #FUN-A50102
                                        cl_get_target_table(p_plant,'ofb_file'),     #FUN-A50102
                              " WHERE ofa01='",l_slip,"'  ",
                              "   AND ofa01=ofb01 ",
                              "   AND ofaconf='Y' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
                  PREPARE ofa_pre3 FROM l_sql
                  EXECUTE ofa_pre3 INTO l_cnt
              END IF
              IF l_cnt = 0 THEN
               IF g_bgerr THEN 
                LET g_showmsg=g_oga.oga27,"/",'Y'                
                CALL s_errmsg('ofa01,ofaconf',g_showmsg,'sel ofa:',SQLCA.SQLCODE,1)  
               ELSE 
                CALL cl_err('sel ofa:',SQLCA.SQLCODE,1)
               END IF 
                LET g_success='N' EXIT FOR
              ELSE
                 SELECT * INTO g_ofa.* FROM ofa_file
                  WHERE ofa01 = g_oga.oga27
                           SELECT poy48 INTO g_t1 FROM poy_file 
                            WHERE poy01=g_poz.poz01
                              AND poy02=i
                           IF SQLCA.sqlcode=100 THEN
                              CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,1)
                              LET g_success = 'N'
                           END IF
# 重新取號
                 CALL s_auto_assign_no("axm",g_t1,g_ofa.ofa02,"","ofa_file","ofa01",l_plant_new,"","") #NO.FUN-620024   #FUN-980092 add
                 RETURNING g_sw,l_ofa01
# 以來源INVOICE單號拋轉
                 LET g_ofa.ofa03=l_oea.oea03   #FUN-670007
                 # 取得帳款客戶之 BILL TO 相關資料
                 #LET l_sql = " SELECT * FROM ",l_dbs_new CLIPPED,"occ_file ",
                 LET l_sql = " SELECT * FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102
                             "  WHERE occ01 = '",g_ofa.ofa03,"'"
 	             CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                 PREPARE occ_pre FROM l_sql
                 DECLARE occ_cs CURSOR FOR occ_pre
                 OPEN occ_cs 
                 IF SQLCA.sqlcode THEN
                    LET g_success = 'N'
                    IF g_bgerr THEN
                       CALL s_errmsg('occ01',g_ofa.ofa03,l_dbs_new CLIPPED,'anm-045',1)
                    ELSE
                       CALL cl_err(l_dbs_new CLIPPED,'anm-045',1)
                    END IF
                    EXIT FOR
                 END IF
                 FETCH occ_cs INTO l_occ.*
                 IF SQLCA.SQLCODE THEN
                    IF g_bgerr  THEN
                     CALL s_errmsg('occ01',g_ofa.ofa03,l_dbs_new CLIPPED,'anm-045',1)  
                    ELSE
                     CALL cl_err(l_dbs_new CLIPPED,'anm-045',1)
                    END IF
                    LET g_success = 'N' EXIT FOR
                 END IF
                 
                 # 重取單頭訂單單號 
                  IF NOT cl_null(g_ofa.ofa16) THEN
                     LET l_sql  = "SELECT oea01 ",                          
                                  #"  FROM ",l_dbs_tra CLIPPED,"oea_file ",    #FUN-980092 add
                                  "  FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                                  " WHERE oea99 ='",g_oea.oea99,"'"   
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                     PREPARE ofa16_pre FROM l_sql                          
                     DECLARE ofa16_cs CURSOR FOR ofa16_pre
                     OPEN ofa16_cs
                     IF SQLCA.sqlcode THEN
                        LET g_success = 'N'
                        IF g_bgerr THEN
                           CALL s_errmsg('oea99',g_oea.oea99,l_dbs_tra CLIPPED,SQLCA.sqlcode,1)  #FUN-980092 add
                        ELSE
                           CALL cl_err(l_dbs_tra CLIPPED,SQLCA.sqlcode,0)  #FUN-980092 add
                        END IF
                        EXIT FOR
                     END IF
                     FETCH ofa16_cs INTO g_ofa.ofa16
                     IF SQLCA.sqlcode THEN
                        LET g_success = 'N'
                        IF g_bgerr THEN
                           CALL s_errmsg('oea99',g_oea.oea99,l_dbs_tra CLIPPED,SQLCA.sqlcode,1)  #FUN-980092 add
                        ELSE
                           CALL cl_err(l_dbs_tra CLIPPED,SQLCA.sqlcode,0)  #FUN-980092 add
                        END IF
                        EXIT FOR
                     END IF
                  END IF
                 #  重取單頭訂單單號 
 
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
                 #LET g_ofa.ofa32=p_poy07   #MOD-A80177
                 LET g_ofa.ofa32=l_oga.oga32   #MOD-A80177
                 LET g_ofa.ofa011= l_oga.oga01
                 LET g_ofa.ofa21 = l_oga.oga21   #MOD-8A0165 add
                 LET g_ofa.ofa211 = l_oga.oga211  #MOD-940204 add
                 LET g_ofa.ofa212 = l_oga.oga212  #MOD-940204 add
                 LET g_ofa.ofa213 = l_oga.oga213  #MOD-940204 add
                 #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ofa_file",   #FUN-980092 add
                 LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ofa_file'), #FUN-A50102
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
                             "  ofaplant,ofalegal, ",
                             "  ofaud01,ofaud02,ofaud03,ofaud04,ofaud05,",
                             "  ofaud06,ofaud07,ofaud08,ofaud09,ofaud10,",
                             "  ofaud11,ofaud12,ofaud13,ofaud14,ofaud15,ofaoriu,ofaorig)",  #FUN-A10036
                             " VALUES(?,?,?,?,?, ?,?,?,?,?, ",
                             "        ?,?,?,?,?, ?,?,?,?,?, ",
                             "        ?,?,?,?,?, ?,?,?,?,?, ",
                             "        ?,?,?,?,?, ?,?,?,?,?, ",
                             "        ?,?,?,?,?, ?,?,?,?,?, ",
                             "        ?,?,?,?,?, ?,?,?,?,?, ",
                             "        ?,?,?,?,?, ?,?,?,?,?,  ",
                             "        ?,?,?,?,?, ?,?,?,?,?,  ", #No.CHI-950020
                             "        ?,?,?,?,?,   ",           #No.CHI-950020 
                             "        ?,?,?,?,?, ?,?,?,?) "   #FUN-980010 #FUN-A10036
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
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
                        IF g_bgerr THEN       
                          LET g_showmsg=l_ofa01,"/",g_ofa.ofa02,"/",g_ofa.ofa03 
                          CALL s_errmsg('ofa01,ofa02,ofa03',g_showmsg,'ins ofa:',SQLCA.sqlcode,1)
                        ELSE
                          CALL cl_err('ins ofa:',SQLCA.sqlcode,1)  
                        END IF
                        LET g_success = 'N' EXIT FOREACH 
                     END IF
                 #---INSERT Invoice 單身檔
                 DECLARE ofb_cs CURSOR FOR
                   SELECT ofb_file.*,oea_file.oea99 FROM ofb_file,oea_file WHERE ofb01=g_ofa.ofa01
                     AND ofb31=oea01  ORDER BY ofb03 ASC
                 FOREACH ofb_cs INTO g_ofb.*,g_oea99   #MOD-810094 add g_oea99
                     LET l_sql1 = "SELECT oeb_file.* ", #FUN-980092 add
                                  #"  FROM ",l_dbs_tra CLIPPED,"oeb_file,", #FUN-980092 add
                                  #          l_dbs_tra CLIPPED,"oea_file ", #FUN-980092 add
                                  "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),",", #FUN-A50102
                                            cl_get_target_table(l_plant_new,'oea_file'),     #FUN-A50102
                                  " WHERE oeb01=oea01 ",
                                  "   AND oea99 ='",g_oea99,"'",                            
                                  "   AND oeb03=",g_ofb.ofb32
 	     CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
                     PREPARE oeb_p3 FROM l_sql1
                     IF SQLCA.SQLCODE THEN 
                        IF g_bgerr THEN         
                          LET g_showmsg=g_ofb.ofb31,"/",g_ofb.ofb32        
                          CALL s_errmsg('oeb01,oeb03',g_showmsg,'oeb_p3',SQLCA.SQLCODE,1)   
                        ELSE
                          CALL cl_err('oeb_p3',SQLCA.SQLCODE,1)
                        END IF
                        LET g_success = 'N' EXIT FOREACH
                     END IF
                     DECLARE oeb_c3 CURSOR FOR oeb_p3
                     OPEN oeb_c3
                     IF SQLCA.SQLCODE THEN
                        IF g_bgerr THEN
                          LET g_showmsg=g_ofb.ofb31,"/",g_ofb.ofb32
                          CALL s_errmsg('oeb01,oeb03',g_showmsg,'oeb_p3',SQLCA.SQLCODE,1)
                        ELSE
                          CALL cl_err('oeb_p3',SQLCA.SQLCODE,1)
                        END IF
                        LET g_success = 'N' EXIT FOREACH
                     END IF
                     FETCH oeb_c3 INTO p_oeb.*
                     IF SQLCA.SQLCODE THEN
                        IF g_bgerr THEN
                          LET g_showmsg=g_ofb.ofb31,"/",g_ofb.ofb32
                          CALL s_errmsg('oeb01,oeb03',g_showmsg,'oeb_p3',SQLCA.SQLCODE,1)
                        ELSE
                          CALL cl_err('oeb_p3',SQLCA.SQLCODE,1)
                        END IF
                        LET g_success = 'N' EXIT FOREACH
                     END IF
                     CLOSE oeb_c3
                     LET g_ofb.ofb13=p_oeb.oeb13
                     IF g_ofa.ofa213 = 'N' THEN
                         LET g_ofb.ofb14 =g_ofb.ofb917*g_ofb.ofb13  #MOD-7A0051 ofb12->ofb917
                         LET g_ofb.ofb14t=g_ofb.ofb14*(1+g_ofa.ofa211/100)
                     ELSE
                         LET g_ofb.ofb14t=g_ofb.ofb917*g_ofb.ofb13   #MOD-7A0051 ofb12->ofb917
                         LET g_ofb.ofb14 =g_ofb.ofb14t/(1+g_ofa.ofa211/100)
                     END IF
                     CALL cl_digcut(g_ofb.ofb14,l_azi.azi04) RETURNING g_ofb.ofb14   #MOD-7A0051 add
                     CALL cl_digcut(g_ofb.ofb14t,l_azi.azi04) RETURNING g_ofb.ofb14t  #MOD-7A0051 add
                     #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ofb_file",  #FUN-980092 add
                     LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ofb_file'), #FUN-A50102
                                " (ofb01,ofb03,ofb04,ofb05,ofb06,",
                                "  ofb07,ofb11,ofb12,ofb13,",
                                "  ofb14,ofb14t,ofb31,ofb32,ofb33,",
                                "  ofb34,ofb35, ofbplant,ofblegal ,",
                                "  ofb910,ofb911,ofb912,ofb913,ofb914,",           #MOD-9C0390
                                "  ofb915,ofb916,ofb917,",                         #MOD-9C0390
                                "  ofbud01,ofbud02,ofbud03,ofbud04,ofbud05,",
                                "  ofbud06,ofbud07,ofbud08,ofbud09,ofbud10,",
                                "  ofbud11,ofbud12,ofbud13,ofbud14,ofbud15)",
                                " VALUES(?,?,?,?,?, ?,?,?,?, ",
                                "        ?,?,?,?,?, ?,?,?,?,   ?,?,?,?,?, ?,?,?,", #CHI-950020 #MOD-9C0390
                                "        ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?)"         #FUN-980010
 	     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                     PREPARE ins_ofb FROM l_sql2
                     EXECUTE ins_ofb USING 
                     l_ofa01,g_ofb.ofb03,g_ofb.ofb04,g_ofb.ofb05,g_ofb.ofb06,
                     g_ofb.ofb07,g_ofb.ofb11,g_ofb.ofb12,g_ofb.ofb13,
                     g_ofb.ofb14,g_ofb.ofb14t,p_oeb.oeb01,p_oeb.oeb03,g_ofb.ofb33, #MOD-810094 add
                     g_ofa.ofa011,g_ofb.ofb35, #MOD-7C0189 
                     gp_plant,gp_legal,        #FUN-980010
                     g_ofb.ofb910,g_ofb.ofb911,g_ofb.ofb912,g_ofb.ofb913,g_ofb.ofb914, #MOD-9C0390 
                     g_ofb.ofb915,g_ofb.ofb916,g_ofb.ofb917,                           #MOD-9C0390  
                     g_ofb.ofbud01,g_ofb.ofbud02,g_ofb.ofbud03,
                     g_ofb.ofbud04,g_ofb.ofbud05,g_ofb.ofbud06,
                     g_ofb.ofbud07,g_ofb.ofbud08,g_ofb.ofbud09,
                     g_ofb.ofbud10,g_ofb.ofbud11,g_ofb.ofbud12,
                     g_ofb.ofbud13,g_ofb.ofbud14,g_ofb.ofbud15
                     IF SQLCA.sqlcode<>0 THEN
                        IF  g_bgerr THEN    
                          LET g_showmsg=l_ofa01,"/",g_ofb.ofb31                     
                          CALL s_errmsg('ofb01,ofb03',g_showmsg,'ins ofb:',SQLCA.sqlcode,1) 
                        ELSE 
                          CALL cl_err('ins ofb:',SQLCA.sqlcode,1)
                        END IF
                        LET g_success = 'N' EXIT FOREACH 
                     END IF
                     #新增至暫存檔中
                     INSERT INTO p910_file VALUES(i,l_ofa01,g_ofb.ofb03,
                                       g_ofb.ofb13)
                     IF SQLCA.sqlcode<>0 THEN
                        IF  g_bgerr THEN
                          LET g_showmsg=i,"/",l_ofa01,"/",g_ofb.ofb03,"/",g_ofb.ofb13                      
                          CALL s_errmsg('p_no,nab_no,pab_item,pab_price',g_showmsg,'',SQLCA.sqlcode,1)   
                         ELSE
                          CALL cl_err3("ins","p910_file","","",SQLCA.sqlcode,"","ins p910_file",1)
                         END IF
                        LET g_success = 'N'
                     END IF
                 END FOREACH
                 #--------  重計單頭金額 ---------------
                 #LET l_sql ="SELECT SUM(ofb14) FROM ",l_dbs_tra CLIPPED,  #FUN-980092 add
                 #           " ofb_file ",
                 LET l_sql ="SELECT SUM(ofb14) FROM ",cl_get_target_table(l_plant_new,'ofb_file'), #FUN-A50102                            
                            " WHERE ofb01 ='", l_ofa01,"'"
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE ofa50_pre FROM l_sql
                 DECLARE ofa50_cs CURSOR FOR ofa50_pre
                 OPEN ofa50_cs
                 IF SQLCA.SQLCODE THEN
                    IF g_bgerr THEN
                       CALL s_errmsg('ofb01',l_ofa01,'sum ofa14:',SQLCA.SQLCODE,1)
                    ELSE
                       CALL cl_err('sum ofa14:',SQLCA.SQLCODE,1)
                    END IF
                    LET g_success='N'
                 END IF
                 FETCH ofa50_cs INTO g_ofa.ofa50
                 IF SQLCA.SQLCODE THEN
                    IF  g_bgerr   THEN      
                      CALL s_errmsg('ofb01',l_ofa01,'sum ofa14:',SQLCA.SQLCODE,1)
                    ELSE 
                      CALL cl_err('sum ofa14:',SQLCA.SQLCODE,1)
                    END IF
                    LET g_success='N'
                 END IF
                 #LET l_sql =" UPDATE ",l_dbs_tra CLIPPED," ofa_file ",  #FUN-980092 add
                 LET l_sql =" UPDATE ",cl_get_target_table(l_plant_new,'ofa_file'), #FUN-A50102
                            "    SET ofa50 =",g_ofa.ofa50,
                            " WHERE ofa01 = '",l_ofa01,"'"
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE upofa50_pre FROM l_sql
                 EXECUTE upofa50_pre
                 IF SQLCA.SQLCODE OR sqlca.sqlerrd[3]=0  THEN   #MOD-810094 modify[3]
                    IF  g_bgerr   THEN   
                      CALL s_errmsg('ofa01',l_ofa01,'upd ofa50:',SQLCA.SQLCODE,1) 
                    ELSE
                      CALL cl_err('upd ofa50:',SQLCA.SQLCODE,1)
                    END IF
                    LET g_success = 'N'     #TQC-930155 add
                 END IF
                 #出貨通知單
                 #LET l_sql = "UPDATE ",l_dbs_tra CLIPPED, "oga_file",  #FUN-980092 add
                 LET l_sql = "UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
                             "  SET oga27  =  ? ",
                             " WHERE oga01 = '",l_oga.oga01,"'"  #MOD-810079 modify g_oga.oga27->l_oga.oga27
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
                 PREPARE ofa27_upd2 FROM l_sql
                 EXECUTE ofa27_upd2 USING l_ofa01
                 IF SQLCA.SQLCODE OR sqlca.sqlerrd[3]=0 THEN
                     LET g_msg = l_dbs_new CLIPPED,'upd oga27'
                     IF g_bgerr THEN
                        CALL s_errmsg('oga01',l_oga.oga01,g_msg,SQLCA.SQLCODE,1)
                     ELSE
                         CALL cl_err(g_msg,SQLCA.SQLCODE,1)
                     END IF
                     LET g_success='N'
                 END IF
             END IF
          END IF
         END IF  #MOD-810043 add
      END FOR  {一個訂單流程代碼結束}
     
      MESSAGE ""
    
      IF g_success='N' THEN
         EXIT FOREACH 
      END IF
 
      #更新起始出貨通知單單頭檔之拋轉否='Y'
      IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
         UPDATE oga_file SET oga905='Y',
                             oga906='Y' 
          WHERE oga01=g_oga.oga01
      ELSE
         #LET l_sql = "UPDATE ",l_dbs CLIPPED,"oga_file SET oga905='Y', ",
         LET l_sql = "UPDATE ",cl_get_target_table(p_plant,'oga_file')," SET oga905='Y', ",#FUN-A50102
                     "                                     oga906='Y'  ",
                     "                               WHERE oga01='",g_oga.oga01,"' "
 	     CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,p_plant) RETURNING l_sql #FUN-980092
         PREPARE oga_upd_pre FROM l_sql
         EXECUTE oga_upd_pre
      END IF
      IF SQLCA.SQLCODE <> 0 OR SQLCA.SQLERRD[3]=0 THEN
         IF g_bgerr   THEN    
          CALL s_errmsg('oga01',g_oga.oga01,'upd oga905',SQLCA.SQLCODE,1) 
         ELSE 
          CALL cl_err('upd oga905',SQLCA.SQLCODE,1)
         END IF
         LET g_success='N' 
      END IF
   END FOREACH     
  IF g_totsuccess="N" THEN                                                        
     LET g_success="N"                                                           
  END IF                                                                          
  CALL s_showmsg()              #NO.FUN-710046 #MOD-A20062 mark   #MOD-A60124 取消mark
   IF cl_null(p_oga01) OR cl_null(p_oga09) THEN
      IF g_success = 'Y' THEN 
         COMMIT WORK
      ELSE 
         ROLLBACK WORK
      END IF
   END IF
END FUNCTION
 
FUNCTION p910_azp(l_n)
   DEFINE l_source LIKE type_file.num5,      #No.FUN-680137 SMALLINT    #來源站別
          l_n      LIKE type_file.num5,      #當站站別  #No.FUN-680137 SMALLINT
          l_n2     LIKE type_file.num5,      #當站站別  #No.FUN-680137 SMALLINT
         #l_sql1   LIKE type_file.chr1000,   #No.FUN-680137 VARCHAR(800)   #CHI-940042 mark
          l_sql1   STRING,                   #CHI-940042 
          l_next   LIKE type_file.num5,      #當站站別  #No.FUN-680137 SMALLINT
          l_front  LIKE type_file.num5       #當站站別  #No.FUN-680137 SMALLINT
    
   
   ##-------------取得前站資料庫----------------------
   LET l_source = l_n -1
   SELECT * INTO s_poy.* FROM poy_file    
    WHERE poy01 = g_poz.poz01 AND poy02 = l_source
   LET p_oea03 = s_poy.poy03
 
   ##-------------取得當站資料庫----------------------
   SELECT * INTO g_poy.* FROM poy_file               #取得當站流程設定
    WHERE poy01 = g_poz.poz01 AND poy02 = l_n
 
   SELECT * INTO l_azp.* FROM azp_file
    WHERE azp01=g_poy.poy04
 
   LET l_plant_new = l_azp.azp01             #FUN-980020
   LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED) #TQC-950020     
 
   LET g_plant_new = l_azp.azp01
   LET l_plant_new = g_plant_new
   CALL s_gettrandbs()
   LET l_dbs_tra = g_dbs_tra
 
   LET l_sql1 = "SELECT * ",                         #取得來源本幣
                #"  FROM ",l_dbs_new CLIPPED,"aza_file ",
                "  FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102
                " WHERE aza01 = '0' "
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE aza_p2 FROM l_sql1
   IF SQLCA.SQLCODE THEN
      IF g_bgerr THEN
       CALL s_errmsg('aza01',0,'aza_p2',SQLCA.SQLCODE,1)
      ELSE
       CALL cl_err('aza_p2',SQLCA.SQLCODE,1)
      END IF       
   END IF
 
   DECLARE aza_c2 CURSOR FOR aza_p2
 
   OPEN aza_c2
   FETCH aza_c2 INTO s_aza.*    #No.FUN-620054
   CLOSE aza_c2
   LET p_poy07 = g_poy.poy07 
   LET p_imd01 = g_poy.poy11    #倉庫別 #No.8858
   LET p_poy16 = g_poy.poy16    #MOD-940299
   LET p_poy28 = g_poy.poy28    #NO.FUN-620024
   LET p_poy29 = g_poy.poy29    #NO.FUN-620024
 
END FUNCTION
 
#讀取幣別檔之資料
FUNCTION p910_azi(l_oga23,p_plant) #FUN-980092 add
  #DEFINE l_sql1  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(800)   #CHI-940042 mark
   DEFINE l_sql1  STRING                 #CHI-940042 
   DEFINE l_oga23 LIKE oga_file.oga23
   DEFINE l_dbs   LIKE type_file.chr21  
   DEFINE l_azp03 LIKE azp_file.azp03  #FUN-980092 add
   DEFINE p_plant LIKE azp_file.azp01  #FUN-980092 add
   DEFINE p_dbs   LIKE azp_file.azp03  #FUN-980092 add
 
    # 改抓Transaction DB
    IF NOT cl_null(p_plant) THEN
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
       LET l_dbs = s_dbstring(l_azp03)
 
       LET g_plant_new = p_plant
       CALL s_gettrandbs()
       LET p_dbs = g_dbs_tra
    END IF
 
   #讀取l_dbs_new 之原幣資料
   LET l_sql1 = "SELECT * ",
                #"  FROM ",l_dbs CLIPPED,"azi_file ",
                "  FROM ",cl_get_target_table(p_plant,'azi_file'), #FUN-A50102
                " WHERE azi01='",l_oga23,"' " 
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,p_plant) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p2 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN        
        CALL s_errmsg('azi01',l_oga23,'azi_p2',SQLCA.SQLCODE,1) 
      ELSE
        CALL cl_err('azi_p2',SQLCA.SQLCODE,1)   
      END IF
   END IF
 
   DECLARE azi_c2 CURSOR FOR azi_p2
 
   OPEN azi_c2
   FETCH azi_c2 INTO l_azi.* 
   CLOSE azi_c2
 
END FUNCTION
 
FUNCTION p910_ogains(i)                   #No.FUN620054
  #DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)   #CHI-940042 mark 
  #DEFINE l_sql1    LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)    #CHI-940042 mark
   DEFINE l_sql,l_sql1,l_sql2 STRING       #No.CHI-950020 #CHI-940042 
   DEFINE i,l_i     LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE li_result LIKE type_file.num5     #FUN-560043  #No.FUN-680137 SMALLINT
   DEFINE l_pmn24   LIKE pmn_file.pmn24   #No.FUN-630006
    
   IF tm.oga09 = '6' AND g_oea.oea37="Y" AND i = 0  AND g_oaz.oaz19 = 'Y' THEN   #No.FUN-640025  #NO.TQC-640134
      #LET l_sql1 = "SELECT ",l_dbs_tra CLIPPED,"pmn_file.pmn24 ",    #FUN-980092 add               
      #             "  FROM ",l_dbs_tra CLIPPED,"pmn_file,",          #FUN-980092 add
      #                       l_dbs_tra CLIPPED,"pmm_file",           #FUN-980092 add
      LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'pmn_file'),".pmn24", #FUN-A50102               
                   "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",",       #FUN-A50102
                             cl_get_target_table(l_plant_new,'pmm_file'),          #FUN-A50102 
                   " WHERE pmn01 = pmm01",                                       
                   "   AND pmm99 ='",g_oea.oea99,"'",                            
                   "   AND pmn02 =",g_ogb.ogb32
      
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
      PREPARE pmn24_p1 FROM l_sql1
      IF SQLCA.SQLCODE THEN
         IF  g_bgerr THEN  
           LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32 
           CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn24_p1',SQLCA.SQLCODE,1) 
         ELSE
           CALL cl_err('pmn24_p1',SQLCA.SQLCODE,1)
         END IF
      END IF
      
      DECLARE pmn24_c1 CURSOR FOR pmn24_p1
      
      OPEN pmn24_c1
      IF SQLCA.SQLCODE <> 0 THEN
         LET g_success='N'
         RETURN
      END IF
      FETCH pmn24_c1 INTO l_pmn24
      IF SQLCA.SQLCODE <> 0 THEN
         LET g_success='N'
         RETURN
      END IF
 
      #讀取該流程代碼之銷單資料
      LET l_sql1 = "SELECT * ",
                   #"  FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 add
                   "  FROM ",cl_get_target_table(l_plant_new,'oea_file'),   #FUN-A50102 
                   " WHERE oea01='",l_pmn24,"' "
   ELSE
      #讀取該流程代碼之銷單資料
      LET l_sql1 = "SELECT * ",
                   #"  FROM ",l_dbs_tra CLIPPED,"oea_file ",  #FUN-980092 add
                   "  FROM ",cl_get_target_table(l_plant_new,'oea_file'),   #FUN-A50102 
                   " WHERE oea99='",g_oea.oea99,"' "      #NO.FUN-620024
   END IF
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE oea_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN
       IF  g_bgerr THEN  
         CALL s_errmsg('oea99',g_oea.oea99,'oea_p1',SQLCA.SQLCODE,1) 
       ELSE
         CALL cl_err('oea_p1',SQLCA.SQLCODE,1)
       END IF
   END IF
 
   DECLARE oea_c1 CURSOR FOR oea_p1
 
   OPEN oea_c1
   IF SQLCA.SQLCODE <> 0 THEN
      IF  g_bgerr THEN
       CALL s_errmsg('oea99',g_oea.oea99,'oea_c1',SQLCA.SQLCODE,1)
      END IF
      LET g_success='N'
      RETURN
   END IF
   FETCH oea_c1 INTO l_oea.*
   IF SQLCA.SQLCODE <> 0 THEN
      IF  g_bgerr THEN  
       CALL s_errmsg('oea99',g_oea.oea99,'oea_c1',SQLCA.SQLCODE,1) 
      END IF
      LET g_success='N'
      RETURN
   END IF
 
   CLOSE oea_c1
 
   #新增出貨單單頭檔(oga_file)
   LET l_oga.oga00 = l_oea.oea00        #出貨別
       CALL s_auto_assign_no("axm",oga_t1,g_oga.oga02,"","oga_file","oga01",l_plant_new,"","")  #NO.FUN-620024  #FUN-980092 add
            RETURNING li_result,l_oga.oga01
   LET l_oga.oga011= ''                 #出貨通知單號
   LET l_oga.oga02 = g_oga.oga02        #出貨日期
   LET l_oga.oga021= g_oga.oga021       #結關日期
   LET l_oga.oga022= g_oga.oga022       #裝船日期
   LET l_oga.oga03 = l_oea.oea03
   LET l_oga.oga032= l_oea.oea032
   LET l_oga.oga033= l_oea.oea033
   LET l_oga.oga04 = l_oea.oea04
   LET l_oga.oga044= g_oga.oga044
   LET l_oga.oga05 = l_oea.oea05
   LET l_oga.oga06 = l_oea.oea06
   LET l_oga.oga07 = l_oea.oea07
   LET l_oga.oga08 = l_oea.oea08
   LET l_oga.oga09 = '5'           #No.8047
   LET l_oga.oga10 = null
   LET l_oga.oga11 = null
   LET l_oga.oga12 = null
   LET l_oga.oga13 = p_poy16           	#MOD-940299 add
   LET l_oga.oga14 = l_oea.oea14
   LET l_oga.oga15 = l_oea.oea15
   #來源出貨單單頭若無訂單號,拋轉後也不應有訂單號
   IF cl_null(g_oga.oga16) THEN
      LET l_oga.oga16 = null                              
   ELSE 
      LET l_oga.oga16 = l_oea.oea01     #NO.FUN-620024
   END IF
   IF cl_null(l_oea.oea161) THEN
      LET l_oea.oea161 = 0
   END IF
   IF cl_null(l_oea.oea162) THEN
      LET l_oea.oea162 = 100
   END IF
   IF cl_null(l_oea.oea163) THEN
      LET l_oea.oea163 = 0
   END IF
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
   CALL p910_azi(g_oea.oea23,l_plant_new)              #讀取幣別資料  #FUN-980092 add
   #出貨時重新抓取匯率
   CALL s_currm(l_oga.oga23,l_oga.oga02,g_oaz32,l_plant_new)  #FUN-980020 
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
   LET l_oga.oga31 = g_oga.oga31
   LET l_oga.oga32 = l_oea.oea32
   LET l_oga.oga33 = l_oea.oea33
   LET l_oga.oga34 = 0
   LET l_oga.oga35 = g_oga.oga35
   LET l_oga.oga36 = g_oga.oga36
   LET l_oga.oga37 = g_oga.oga37
   LET l_oga.oga38 = g_oga.oga38
   LET l_oga.oga39 = g_oga.oga39
   LET l_oga.oga40 = l_oea.oea19
   LET l_oga.oga41 = g_oga.oga41
   LET l_oga.oga42 = g_oga.oga42
   LET l_oga.oga43 = g_oga.oga43
   LET l_oga.oga44 = g_oga.oga44
   LET l_oga.oga45 = l_oea.oea45
   LET l_oga.oga46 = l_oea.oea46
   LET l_oga.oga47 = g_oga.oga47
   LET l_oga.oga48 = g_oga.oga48
   LET l_oga.oga49 = g_oga.oga49
   LET l_oga.oga50 = 0
   LET l_oga.oga52 = 0
   LET l_oga.oga53 = 0
   LET l_oga.oga54 = 0
  #LET l_oga.oga69 = g_today       #CHI-C50021 mark
   LET l_oga.oga69 = g_oga.oga69   #CHI-C50021 add
   LET l_oga.oga65 = l_oea.oea65   #FUN-7B0091 add
   LET l_oga.oga99 = g_flow99      #No.8047
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
      LET l_oga.oga1006 = 0              #未稅金額                                         
      LET l_oga.oga1007 = 0              #含稅金額                                         
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
   LET l_oga.oga57 = '1'           #FUN-AC0055 add
   LET l_oga.ogaprsw=0
   LET l_oga.ogauser=g_user
   LET l_oga.ogagrup=g_grup
   LET l_oga.ogamodu=null
   LET l_oga.ogadate=null
 
   CALL p910_chk99()   #FUN-5A0155
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
   #新增出貨單頭檔(oga_file)
   #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
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
              "  oga53,oga54,oga65,oga99,",          #No.8047   #FUN-7B0091 add oga65
              "  oga69,",               
              "  oga901,oga902,",
              "  oga903,oga904,oga905,oga906,",
              "  oga907,oga908,oga909,oga1001,",     #NO.FUN-620024               
              "  oga1002,oga1003,oga1004,oga1005,",  #NO.FUN-620024               
              "  oga1006,oga1007,oga1008,oga1009,",  #NO.FUN-620024               
              "  oga1010,oga1011,oga1012,oga1013,",  #NO.FUN-620024               
              "  oga1014,oga1015,ogaconf,oga55,oga57,",          #NO.FUN-620024   #MOD-A50103   #FUN-AC0055 add oga57
              "  ogapost,ogaprsw,ogauser,ogagrup,",
              "  ogamodu,ogadate, ",
              "  ogaplant,ogalegal, ",
              "  ogaud01,ogaud02,ogaud03,ogaud04,ogaud05,",
              "  ogaud06,ogaud07,ogaud08,ogaud09,ogaud10,",
              "  ogaud11,ogaud12,ogaud13,ogaud14,ogaud15,ogaoriu,ogaorig)", #FUN-A10036
              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",    #No.CHI-950020
                       "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",    #NO.FUN-620024
                       "?,?,?,?, ?,?,?,?,?) "   #FUN-7B0091 add ?  #FUN-980010 #FUN-A10036   #MOD-A50103 add ?
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
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
         l_oga.oga53,l_oga.oga54,l_oga.oga65,l_oga.oga99,     #No.8047   #FUN-7B0091 add oga65
         l_oga.oga69, 
         l_oga.oga901,l_oga.oga902,
         l_oga.oga903,l_oga.oga904,l_oga.oga905,l_oga.oga906,
         l_oga.oga907,l_oga.oga908,l_oga.oga909,l_oga.oga1001,    #NO.FUN-620024
         l_oga.oga1002,l_oga.oga1003,l_oga.oga1004,l_oga.oga1005, #NO.FUN-620024
         l_oga.oga1006,l_oga.oga1007,l_oga.oga1008,l_oga.oga1009, #NO.FUN-620024
         l_oga.oga1010,l_oga.oga1011,l_oga.oga1012,l_oga.oga1013, #NO.FUN-620024
         l_oga.oga1014,l_oga.oga1015,l_oga.ogaconf,l_oga.oga55,l_oga.oga57,  #FUN-AC0055 add l_oga.oga57   #NO.FUN-620024   #MOD-A50103
         l_oga.ogapost,l_oga.ogaprsw,l_oga.ogauser,l_oga.ogagrup,
         l_oga.ogamodu,l_oga.ogadate,
         gp_plant,gp_legal   #FUN-980010
        ,l_oga.ogaud01,l_oga.ogaud02,l_oga.ogaud03,l_oga.ogaud04,l_oga.ogaud05,
         l_oga.ogaud06,l_oga.ogaud07,l_oga.ogaud08,l_oga.ogaud09,l_oga.ogaud10,
         l_oga.ogaud11,l_oga.ogaud12,l_oga.ogaud13,l_oga.ogaud14,l_oga.ogaud15,g_user,g_grup #FUN-A10036
 
   IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3] = 0 THEN
      LET g_msg = l_dbs_tra CLIPPED,'ins l_oga'   #FUN-980092 add
      IF  g_bgerr THEN
        CALL s_errmsg(' ', ' ',g_msg,SQLCA.sqlcode,1)
      ELSE 
        CALL cl_err(g_msg,SQLCA.sqlcode,1)
      END IF      
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
#出貨單身檔
FUNCTION p910_ogbins(p_i,p_plant)                       #No.FUN-620054 #FUN-980092 add
   DEFINE p_dbs      LIKE type_file.chr21   #No.FUN-680137  VARCHAR(21)   #No.FUN-620054
  #DEFINE l_sql      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)  #CHI-940042 mark
  #DEFINE l_sql1     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)   #CHI-940042 mark
  #DEFINE l_sql2     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)  #CHI-940042 mark
  #DEFINE l_sql3     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(400)   #CHI-940042 mark
   DEFINE p_i        LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_no       LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_price    LIKE ogb_file.ogb13
   DEFINE i,l_i      LIKE type_file.num5    #No.FUN-680137 SMALLINT
   DEFINE l_msg      LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(80)
   DEFINE l_chr      LIKE type_file.chr1    #No.FUN-680137 VARCHAR(1)
   DEFINE l_ima02    LIKE ima_file.ima02
   DEFINE l_ima25    LIKE ima_file.ima25
 #  DEFINE l_imaqty   LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_imaqty   LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_ima86    LIKE ima_file.ima86
   DEFINE l_ima39    LIKE ima_file.ima39
   DEFINE l_ima35    LIKE ima_file.ima35
   DEFINE l_ima36    LIKE ima_file.ima36
  #DEFINE l_sql4    LIKE type_file.chr1000#NO.FUN-620024  #No.FUN-680137 VARCHAR(600)   #CHI-940042 mark
   DEFINE l_sql,l_sql1,l_sql2,l_sql3,l_sql4 STRING        #CHI-940042 
   DEFINE l_pmn24   LIKE pmn_file.pmn24   #No.FUN-630006
   DEFINE l_pmn25   LIKE pmn_file.pmn25   #No.FUN-630006
   DEFINE l_ogbi    RECORD LIKE ogbi_file.* #No.FUN-7B0018 
   DEFINE l_oaz81 LIKE oaz_file.oaz81  #No.FUN-850100
   DEFINE p_plant LIKE azp_file.azp01     #FUN-980092 add
   DEFINE l_dbs   LIKE azp_file.azp03     #FUN-980092 add
   DEFINE l_azp03 LIKE azp_file.azp03     #FUN-980092 add
   DEFINE l_idd   RECORD LIKE idd_file.*            #FUN-B90012
   #DEFINE l_imaicd08     LIKE imaicd_file.imaicd08  #FUN-B90012 #FUN-BA0051 mark
   DEFINE l_flag         LIKE type_file.num10       #FUN-B90012
   DEFINE l_ogbiicd028   LIKE ogbi_file.ogbiicd028  #FUN-B90012
   DEFINE l_ogbiicd029   LIKE ogbi_file.ogbiicd029  #FUN-B90012
   DEFINE l_cnt          LIKE type_file.num5        #CHI-C40031 add
#  DEFINE l_oia07   LIKE oia_file.oia07   #FUN-C50136
   DEFINE l_fac     LIKE ima_file.ima31_fac  #FUN-C80001
   DEFINE l_img09   LIKE img_file.img09      #FUN-C80001
   DEFINE l_idb   RECORD LIKE idb_file.*   #FUN-C80001 
  
    #改抓Transaction DB
    IF NOT cl_null(p_plant) THEN
       SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01 = p_plant
       LET p_dbs = s_dbstring(l_azp03)
 
       LET g_plant_new = p_plant
       CALL s_gettrandbs()
       LET l_dbs = g_dbs_tra
    END IF
   
   #讀取訂單單身檔(oeb_file)
   LET i = p_i                                              #No.FUN-620054
   IF tm.oga09 = '6' AND g_oea.oea37="Y" AND i = 0  AND g_oaz.oaz19 = 'Y' THEN   #No.FUN-640025  #NO.TQC-640134
      #LET l_sql1 = "SELECT ",l_dbs_tra CLIPPED,"pmn_file.pmn24, ",  #FUN-980092 add
      #                       l_dbs_tra CLIPPED,"pmn_file.pmn25 ",   #FUN-980092 add
      #             "  FROM ",l_dbs_tra CLIPPED,"pmn_file,",         #FUN-980092 add
      #                       l_dbs_tra CLIPPED,"pmm_file",          #FUN-980092 add
      LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'pmn_file'),".pmn24, ", #FUN-A50102
                             cl_get_target_table(l_plant_new,'pmn_file'),".pmn25 ",  #FUN-A50102
                   "  FROM ",cl_get_target_table(l_plant_new,'pmn_file'),",",        #FUN-A50102
                             cl_get_target_table(l_plant_new,'pmm_file'),            #FUN-A50102
                   " WHERE pmn01 = pmm01",                                       
                   "   AND pmm99 ='",g_oea99,"'",        #MOD-740042 modify                    
                   "   AND pmn02 =",g_ogb.ogb32
      
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
      PREPARE pmn24_p2 FROM l_sql1
      IF SQLCA.SQLCODE THEN
         IF g_bgerr THEN
           LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32 
           CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn24_p1',SQLCA.SQLCODE,1) 
         ELSE
           CALL cl_err('pmn24_p1',SQLCA.SQLCODE,1)   
         END IF
      END IF
      DECLARE pmn24_c2 CURSOR FOR pmn24_p2
      OPEN pmn24_c2
      IF SQLCA.SQLCODE <> 0 THEN
         IF g_bgerr THEN
            LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32
            CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn24_p1',SQLCA.SQLCODE,1)
         END IF
         LET g_success='N'
         RETURN
      END IF
      FETCH pmn24_c2 INTO l_pmn24,l_pmn25
      IF SQLCA.SQLCODE <> 0 THEN
        IF g_bgerr THEN  
         LET g_showmsg=g_oea.oea99,"/",g_ogb.ogb32                         
         CALL s_errmsg('pmm99,pmn02',g_showmsg,'pmn24_p1',SQLCA.SQLCODE,1) 
        END IF
         LET g_success='N'
         RETURN
      END IF
 
      #LET l_sql1 = "SELECT ",l_dbs_tra CLIPPED,"oeb_file.* ",  #FUN-980092 add                  
      #             "  FROM ",l_dbs_tra CLIPPED,"oeb_file,",    #FUN-980092 add
      #                       l_dbs_tra CLIPPED,"oea_file",     #FUN-980092 add
      LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'oeb_file'),".*", #FUN-A50102                  
                   "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),",",  #FUN-A50102
                             cl_get_target_table(l_plant_new,'oea_file'),      #FUN-A50102
                   " WHERE oeb01 = oea01",                                       
                   "   AND oea99 ='",l_pmn24,"'",                            
                   "  AND oeb03 =",l_pmn25
   ELSE
      #LET l_sql1 = "SELECT ",l_dbs_tra CLIPPED,"oeb_file.* ",      #FUN-980092 add              
      #             "  FROM ",l_dbs_tra CLIPPED,"oeb_file,",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add
      LET l_sql1 = "SELECT ",cl_get_target_table(l_plant_new,'oeb_file'),".*", #FUN-A50102           
                   "  FROM ",cl_get_target_table(l_plant_new,'oeb_file'),",",  #FUN-A50102
                             cl_get_target_table(l_plant_new,'oea_file'),      #FUN-A50102
                   " WHERE oeb01 = oea01",                                       
                   "   AND oea99 ='",g_oea.oea99,"'",                            
                   "  AND oeb03 =",g_ogb.ogb32
   END IF
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
   PREPARE oeb_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN 
      IF g_bgerr THEN 
        CALL s_errmsg('oeb01',g_oea.oea99,'oeb_p1',SQLCA.SQLCODE,1)   
      ELSE
        CALL cl_err('oeb_p1',SQLCA.SQLCODE,1)
      END IF          
   END IF
 
   DECLARE oeb_c1 CURSOR FOR oeb_p1
 
   OPEN oeb_c1
   IF SQLCA.SQLCODE <> 0 THEN
      IF g_bgerr THEN
         CALL s_errmsg('oeb01',g_oea.oea99,' ',SQLCA.SQLCODE,1)
      END IF
      LET g_success='N'
      RETURN
   END IF
   FETCH oeb_c1 INTO l_oeb.*              #MOD-B30490 ADD
   IF SQLCA.SQLCODE <> 0 THEN
     IF g_bgerr THEN 
      CALL s_errmsg('oeb01',g_oea.oea99,' ',SQLCA.SQLCODE,1)   
     END IF
      LET g_success='N'
      RETURN
   END IF
   CLOSE oeb_c1
 
   CALL p910_ima(l_oeb.oeb04)
      RETURNING l_ima02,l_ima25,l_imaqty,l_ima86,l_ima39,l_ima35,l_ima36
   IF cl_null(l_ima35) THEN LET l_ima35=' ' END IF
   IF cl_null(l_ima36) THEN LET l_ima36=' ' END IF
 
   #新增出貨單身檔[ogb_file]
   LET l_ogb.ogb01 = l_oga.oga01      #出貨單號     No.8047
   LET l_ogb.ogb03 = g_ogb.ogb03      #項次
   LET l_ogb.ogb04 = g_ogb.ogb04      #產品編號     No.7742
   LET l_ogb.ogb05 = g_ogb.ogb05      #銷售單位     No.7742
   LET l_ogb.ogb05_fac= g_ogb.ogb05_fac  #換算率    No.7742
   LET l_ogb.ogb06 = g_ogb.ogb06      #品名規格     No.7742
   LET l_ogb.ogb07 = g_ogb.ogb07      #額外品名編號 No.7742
   LET l_ogb.ogb08 = l_oeb.oeb08      #出貨工廠
   IF NOT cl_null(p_imd01) THEN
      CALL p910_imd(p_imd01,l_plant_new) #FUN-980092 add
      LET l_ogb.ogb09 = p_imd01          #出貨倉庫
      LET l_ogb.ogb091= ' '              #出貨儲位
      LET l_ogb.ogb092= ' '              #出貨批號
   ELSE
      IF NOT cl_null(l_ima35) THEN
         LET l_ogb.ogb09 = l_ima35          #出貨倉庫
         LET l_ogb.ogb091= l_ima36          #出貨儲位
         LET l_ogb.ogb092= ' '              #出貨批號
      ELSE
         LET l_ogb.ogb09 = g_ogb.ogb09
         LET l_ogb.ogb091= g_ogb.ogb091
         LET l_ogb.ogb092= g_ogb.ogb092  #No.9337
      END IF
   END IF
   IF cl_null(l_ogb.ogb091) THEN LET l_ogb.ogb091=' ' END IF  #FUN-C80001
  #IF g_sma.sma96 = 'Y' THEN          #FUN-C80001 #FUN-D30099 mark
   IF g_pod.pod08 = 'Y' THEN          #FUN-D30099
      LET l_ogb.ogb092= g_ogb.ogb092  #FUN-C80001
   END IF                             #FUN-C80001
   LET l_ogb.ogb11 = g_ogb.ogb11      #客戶產品編號 No.7742
   LET l_ogb.ogb12 = g_ogb.ogb12      #實際出貨數量
   LET l_ogb.ogb13 = l_oeb.oeb13      #原幣單價
   LET l_ogb.ogb917 = g_ogb.ogb917    #MOD-9C0390
 
   #未稅金額/含稅金額 : oeb14/oeb14t
   IF l_oga.oga213 = 'N' THEN
      LET l_ogb.ogb14=l_ogb.ogb917*l_ogb.ogb13                       #MOD-9C0390
      CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14  #MOD-9C0390
      LET l_ogb.ogb14t=l_ogb.ogb14*(1+l_oga.oga211/100)
      CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t #MOD-9C0390
   ELSE 
      LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13                      #MOD-9C0390
      CALL cl_digcut(l_ogb.ogb14t,l_azi.azi04)RETURNING l_ogb.ogb14t #MOD-9C0390
      LET l_ogb.ogb14=l_ogb.ogb14t/(1+l_oga.oga211/100)
      CALL cl_digcut(l_ogb.ogb14,l_azi.azi04) RETURNING l_ogb.ogb14  #MOD-9C0390
   END IF
   LET l_ogb.ogb15 = l_ogb.ogb05    #No.7742
   LET l_ogb.ogb15_fac = 1
   LET l_ogb.ogb16 = l_ogb.ogb12
  #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
   IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
      LET l_ogb.ogb17 = g_ogb.ogb17  #FUN-C80001
   ELSE                              #FUN-C80001
      LET l_ogb.ogb17 = 'N'
   END IF                            #FUN-C80001
   LET l_ogb.ogb18 = l_ogb.ogb12
   LET l_ogb.ogb19 = g_ogb.ogb19  #NO.FUN-620024
   LET l_ogb.ogb20 =' '
   LET l_ogb.ogb31 = l_oeb.oeb01
   LET l_ogb.ogb32 = l_oeb.oeb03
   LET l_ogb.ogb60 =0
   LET l_ogb.ogb63 =0
   LET l_ogb.ogb64 =0
   # 備品時金額、單價應為零
   IF p910_chkoeo(l_ogb.ogb31,l_ogb.ogb32,l_ogb.ogb04) THEN
      LET l_ogb.ogb13 = 0 
      LET l_ogb.ogb14 = 0 
      LET l_ogb.ogb14t= 0 
   END IF
   LET l_ogb.ogb910 = g_ogb.ogb910
   LET l_ogb.ogb911 = g_ogb.ogb911
   LET l_ogb.ogb912 = g_ogb.ogb912
   LET l_ogb.ogb913 = g_ogb.ogb913
   LET l_ogb.ogb914 = g_ogb.ogb914
   LET l_ogb.ogb915 = g_ogb.ogb915
   LET l_ogb.ogb916 = g_ogb.ogb916
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
   IF l_ogb.ogb1012 = 'Y' THEN
      LET l_ogb.ogb14 = 0
      LET l_ogb.ogb14t= 0
   END IF
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
   IF g_aza.aza50 = 'N' THEN LET l_ogb.ogb1005 = '1' END IF   #FUN-670007
#FUN-AB0061 -----------add start---------------- 
    LET l_ogb.ogb37 = l_oeb.oeb37                             
    IF cl_null(l_ogb.ogb37) OR l_ogb.ogb37=0 THEN           
       LET l_ogb.ogb37=l_ogb.ogb13                         
    END IF                                                                             
#FUN-AB0061 -----------add end----------------  
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 ------------add start-----------
#    IF cl_null(l_ogb.ogb50) THEN
#       LET l_ogb.ogb50 = '1'
#    END IF
##FUN-AB0096 -------------add end----------------  
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
   #新增出貨單身檔
   #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"ogb_file",  #FUN-980092 add
   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'ogb_file'), #FUN-A50102
              "(ogb01,ogb03,ogb04,ogb05, ",
              " ogb05_fac,ogb06,ogb07,ogb08, ",
              " ogb09,ogb091,ogb092,ogb11, ",
              " ogb12,ogb37,ogb13,ogb14,ogb14t,",#FUN-AB0061 
              " ogb15,ogb15_fac,ogb16,ogb17, ",
              " ogb18,ogb19,ogb20,ogb31,",
              " ogb32,ogb60,ogb63,ogb64,",
              " ogb901,ogb902,ogb903,ogb904,",
              " ogb905,ogb906,ogb907,ogb908,",
              " ogb909,ogb910,ogb911,ogb912,",
              " ogb913,ogb914,ogb915,ogb916,",
              " ogb917,ogb1001,ogb1002,ogb1003,", #NO.FUN-620024                           
              " ogb1004,ogb1005,ogb1007,ogb1008,",#NO.FUN-620024                           
              " ogb1009,ogb1010,ogb1011,ogb1012,ogb1006,",       #NO.FUN-620024 
              " ogbplant,ogblegal ,",
              " ogbud01,ogbud02,ogbud03,ogbud04,ogbud05,",
              " ogbud06,ogbud07,ogbud08,ogbud09,ogbud10,",
              " ogbud11,ogbud12,ogbud13,ogbud14,ogbud15,ogb50,ogb51,ogb52,ogb53,ogb54,ogb55)",     ##FUN-C50097 ADD 50,51,52
              " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",     #No.CHI-950020
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ",  #NO.FUN-620024 FUN-620054
              "         ?,?,?,?, ?,?,?,?, ?,?,?,?,   ?,?,?,?, ?,?,?,?, ?,?) "  #No.FUN0054 #FUN-980010#FUN-AB0061  #FUN-AB0096 add? #FUN-C50097 ADD 50,51,52
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ins_ogb FROM l_sql2
   EXECUTE ins_ogb USING l_ogb.ogb01,l_ogb.ogb03,l_ogb.ogb04,l_ogb.ogb05, 
                         l_ogb.ogb05_fac,l_ogb.ogb06,l_ogb.ogb07,l_ogb.ogb08, 
                         l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb11, 
                         l_ogb.ogb12,l_ogb.ogb37,l_ogb.ogb13,l_ogb.ogb14,l_ogb.ogb14t,#FUN-AB0061 
                         l_ogb.ogb15,l_ogb.ogb15_fac,l_ogb.ogb16,l_ogb.ogb17, 
                         l_ogb.ogb18,l_ogb.ogb19,l_ogb.ogb20,l_ogb.ogb31,
                         l_ogb.ogb32,l_ogb.ogb60,l_ogb.ogb63,l_ogb.ogb64,
                         l_ogb.ogb901,l_ogb.ogb902,l_ogb.ogb903,l_ogb.ogb904,
                         l_ogb.ogb905,l_ogb.ogb906,l_ogb.ogb907,l_ogb.ogb908,
                         l_ogb.ogb909,l_ogb.ogb910,l_ogb.ogb911,l_ogb.ogb912,
                         l_ogb.ogb913,l_ogb.ogb914,l_ogb.ogb915,l_ogb.ogb916,
                         l_ogb.ogb917,l_ogb.ogb1001,l_ogb.ogb1002,l_ogb.ogb1003,  #NO.FUN-620024     
                         l_ogb.ogb1004,l_ogb.ogb1005,l_ogb.ogb1007,l_ogb.ogb1008, #NO.FUN-620024     
                         l_ogb.ogb1009,l_ogb.ogb1010,l_ogb.ogb1011,l_ogb.ogb1012,l_ogb.ogb1006, #NO.FUN-620024 
                          gp_plant,gp_legal   #FUN-980010
                        ,l_ogb.ogbud01,l_ogb.ogbud02,l_ogb.ogbud03,
                         l_ogb.ogbud04,l_ogb.ogbud05,l_ogb.ogbud06,
                         l_ogb.ogbud07,l_ogb.ogbud08,l_ogb.ogbud09,
                         l_ogb.ogbud10,l_ogb.ogbud11,l_ogb.ogbud12,
                         l_ogb.ogbud13,l_ogb.ogbud14,l_ogb.ogbud15,
                         l_ogb.ogb50,l_ogb.ogb51,l_ogb.ogb52,l_ogb.ogb53,l_ogb.ogb54,l_ogb.ogb55   #FUN-C50097 ADD 50,51,52
 
   IF SQLCA.sqlcode<>0 OR SQLCA.SQLERRD[3]=0 THEN
      LET g_msg = l_dbs_tra CLIPPED,'ins l_ogb'   #FUN-980092 add
      IF g_bgerr THEN
        LET g_showmsg=l_ogb.ogb01,"/",l_ogb.ogb03,"/",l_ogb.ogb04                        
        CALL s_errmsg('ogb01,ogb03,ogb04',g_showmsg,g_msg,SQLCA.sqlcode,1) 
      ELSE
       CALL cl_err(g_msg,SQLCA.sqlcode,1)                                     
      END IF
      LET g_success = 'N'
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_ogbi.* TO NULL
         LET l_ogbi.ogbi01 = l_ogb.ogb01
         LET l_ogbi.ogbi03 = l_ogb.ogb03
         IF NOT s_ins_ogbi(l_ogbi.*,l_plant_new) THEN #FUN-980092 add
            LET g_success = 'N'
         END IF
      END IF
#     #FUN-C50136----add----str----
#     IF g_oaz.oaz96 ='Y' THEN
#        CALL s_ccc_oia07('D',l_oga.oga03) RETURNING l_oia07
#        IF l_oia07 = '0' THEN
#           CALL s_ccc_oia(l_oga.oga03,'D',l_oga.oga01,0,l_plant_new)
#        END IF
#     END IF
#     #FUN-C50136----add----end----
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
           
              LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogg_file'),   
                           "(ogg01,ogg03,ogg09,ogg091,ogg092,ogg10,",
                           " ogg12,ogg15,ogg15_fac,ogg16,ogg20,ogg17,ogg18,",           
                           " oggplant,ogglegal,ogg13) ", 
                           " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?) "  
 
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
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
           
              LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'ogc_file'),   
                           "(ogc01,ogc03,ogc09,ogc091,ogc092,",
                           " ogc12,ogc15,ogc15_fac,ogc16,ogc17,ogc18,",           
                           " ogcplant,ogclegal,ogc13) ", 
                           " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?) "  
 
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
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
 
   #LET l_sql2 = "SELECT ima918,ima921 FROM ",l_dbs_new CLIPPED,"ima_file",
   LET l_sql2 = "SELECT ima918,ima921 FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                " WHERE ima01 = '",l_ogb.ogb04,"'",
                "   AND imaacti = 'Y'"
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE ima_ogb FROM l_sql2
 
   EXECUTE ima_ogb INTO g_ima918,g_ima921                                                                             
     
   #LET l_sql2 = "SELECT oaz81 FROM ",l_dbs_new CLIPPED,"oaz_file",
   LET l_sql2 = "SELECT oaz81 FROM ",cl_get_target_table(l_plant_new,'oaz_file'), #FUN-A50102
                " WHERE oaz00 = '0'"
   
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
   PREPARE oaz_rvb FROM l_sql2
   
   EXECUTE oaz_rvb INTO l_oaz81
     
   IF g_ima918 = "Y" OR g_ima921 = "Y" THEN
      IF l_oaz81 = "Y" THEN
      
         DECLARE p910_g_rvbs CURSOR FOR SELECT * FROM rvbs_file
                                           WHERE rvbs01 = g_oga.oga01
                                             AND rvbs02 = g_ogb.ogb03
         LET l_cnt = 0 #CHI-C40031 add
         FOREACH p910_g_rvbs INTO l_rvbs.*
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
                     DECLARE p910_g_ogg CURSOR FROM l_sql
                     OPEN p910_g_ogg USING l_rvbs.rvbs13
                     FETCH p910_g_ogg INTO g_ogg.*
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
                     DECLARE p910_g_ogc CURSOR FROM l_sql
                     OPEN p910_g_ogc USING l_rvbs.rvbs13
                     FETCH p910_g_ogc INTO g_ogc.*
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
            IF cl_null(l_rvbs.rvbs06) THEN
               LET l_rvbs.rvbs06 = 0
            END IF
   
            LET l_rvbs.rvbs09 = -1
           #IF g_sma.sma96 <> 'Y' THEN   #FUN-C80001 #FUN-D30099 mark
            IF g_pod.pod08 <> 'Y' THEN   #FUN-D30099 
               LET l_rvbs.rvbs13 = 0    #MOD-9C0139
            END IF                       #FUN-C80001
            #新增批/序號資料檔
            EXECUTE ins_rvbs USING l_rvbs.rvbs00,l_rvbs.rvbs01,l_rvbs.rvbs02,
                                   l_rvbs.rvbs021,l_rvbs.rvbs022,l_rvbs.rvbs03,
                                   l_rvbs.rvbs04,l_rvbs.rvbs05,l_rvbs.rvbs06,
                                   l_rvbs.rvbs07,l_rvbs.rvbs08,l_rvbs.rvbs09,l_rvbs.rvbs13,     #MOD-9C0139
                                   gp_plant,gp_legal   #FUN-980010
      
            IF STATUS OR SQLCA.SQLCODE THEN
               LET g_showmsg = l_rvbs.rvbs01,"/",l_rvbs.rvbs03
               CALL s_errmsg('rvbs01,rvbs03',g_showmsg,'ins rvbs:',SQLCA.sqlcode,1) 
               LET g_success='N'
            END IF
         
            CALL p910_imgs(l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_oga.oga02,l_rvbs.*)
   
         END FOREACH
      END IF
   END IF
#FUN-B90012 ------------------Begin------------------------
   IF s_industry('icd') THEN 
      #FUN-BA0051 --START mark--
      #LET l_sql2 = "SELECT imaicd08 FROM ",cl_get_target_table(l_plant_new,'imaicd_file'),",",
      #                                     cl_get_target_table(l_plant_new,'ima_file'),
      #             " WHERE imaicd00 = '",l_ogb.ogb04,"'",
      #             "   AND ima01 = imaicd00 ",
      #             "   AND imaacti = 'Y'"
      #CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
      #CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
      #PREPARE p910_ogb_imaicd08 FROM l_sql2
      #EXECUTE p910_ogb_imaicd08 INTO l_imaicd08 
      #IF l_imaicd08 = 'Y' THEN 
      #FUN-BA0051 --END mark--
#FUN-C80001---begin mark
#      DECLARE p910_g_idd CURSOR FOR SELECT * FROM idd_file
#                          WHERE idd10 = g_oga.oga01
#                            AND idd11 = g_ogb.ogb03
#      
#      IF s_icdbin_multi(l_ogb.ogb04,l_plant_new) THEN   #FUN-BA0051      
#         FOREACH p910_g_idd INTO l_idd.*
#            LET l_idd.idd10 = l_ogb.ogb01
#            LET l_idd.idd11 = l_ogb.ogb03
#      #CHI-C80009---add---START
#            LET l_idd.idd02 = l_ogb.ogb09
#            LET l_idd.idd03 = l_ogb.ogb091
#            LET l_idd.idd04 = l_ogb.ogb092
#      #CHI-C80009---add-----END
#            CALL icd_idb(l_idd.*,l_plant_new)
#         END FOREACH  
#      END IF
#      LET l_sql1 = "SELECT ogbiicd028,ogbiicd029 FROM ",cl_get_target_table(l_plant_new,'ogbi_file'),
#                   " WHERE ogbi01 = '",l_ogb.ogb01,"'",
#                   "   AND ogbi03 =  ",l_ogb.ogb03
#      CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1
#      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1
#      PREPARE p910_ogbi FROM l_sql
#      EXECUTE p910_ogbi INTO l_ogbiicd028,l_ogbiicd029
#      CALL s_icdpost(12,l_ogb.ogb04,l_ogb.ogb09,l_ogb.ogb091,l_ogb.ogb092,l_ogb.ogb05,l_ogb.ogb12,l_ogb.ogb01,l_ogb.ogb03,
#                     l_oga.oga02,'Y','','',l_ogbiicd029,l_ogbiicd028,l_plant_new)
#           RETURNING l_flag
#      IF l_flag = 0 THEN
#         LET g_success = 'N'
#      END IF   
#FUN-C80001---end   
#FUN-C80001---begin
        LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'idb_file'),   
                     "(idb01,idb02,idb03,idb04,idb05,idb06,idb07,idb08,idb09,idb10,",
                     " idb11,idb12,idb13,idb14,idb15,idb16,idb17,idb18,idb19,idb20,",           
                     " idb21,idb22,idb23,idb24,idb25,idbplant,idblegal,idb26,idb27) ", 
                     " VALUES( ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
                     "         ?,?,?,?,?, ?,?,?,?) " 
                       
        CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        
        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
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
#FUN-B90012 ------------------End--------------------------
   #新增至暫存檔中
   INSERT INTO p910_file VALUES(p_i,g_ogb.ogb01,g_ogb.ogb03,
                                       l_ogb.ogb13)
   IF SQLCA.sqlcode<>0 THEN
      IF g_bgerr THEN
        CALL s_errmsg(' ',' ',' ',SQLCA.sqlcode,1)  
      ELSE 
        CALL cl_err3("ins","p910_file",g_ogb.ogb01,g_ogb.ogb03,SQLCA.sqlcode,"","ins p910_file",1)   
      END IF
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
      #LET l_sql4="UPDATE ",l_dbs_tra CLIPPED,"oga_file",   #FUN-980092 add
      LET l_sql4="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102  
                 "   SET oga1008 = ? ",                                       
                 " WHERE oga01 = ? "                                          
 	 CALL cl_replace_sqldb(l_sql4) RETURNING l_sql4        #FUN-920032
         CALL cl_parse_qry_sql(l_sql4,l_plant_new) RETURNING l_sql4 #FUN-980092
      PREPARE upd_oga1008 FROM l_sql4                                         
      EXECUTE upd_oga1008 USING l_oga.oga1008,l_oga.oga01                     
      IF SQLCA.sqlcode<>0 THEN                                                
       IF g_bgerr THEN 
         CALL s_errmsg('oga01',l_oga.oga01,'upd oga:',SQLCA.sqlcode,1)  
       ELSE
         CALL cl_err('upd oga:',SQLCA.sqlcode,1)
       END IF
         LET g_success = 'N'                                                  
      END IF                                                                  
   END IF                                                                     
 
   #LET l_sql3="UPDATE ",l_dbs_tra CLIPPED,"oga_file",  #FUN-980092 add
   LET l_sql3="UPDATE ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102  
              "   SET oga50 = ? ,",
              "       oga51 = ? ,",
              "       oga52 = ? ,",
              "       oga53 = ? ",
              " WHERE oga01 = ? "
 	 CALL cl_replace_sqldb(l_sql3) RETURNING l_sql3        #FUN-920032
         CALL cl_parse_qry_sql(l_sql3,l_plant_new) RETURNING l_sql3 #FUN-980092
   PREPARE upd_oga50 FROM l_sql3
 
   EXECUTE upd_oga50 USING l_oga.oga50,l_oga.oga51,l_oga.oga52,
                           l_oga.oga53,l_oga.oga01
   IF SQLCA.sqlcode<>0 THEN
     IF g_bgerr THEN
      CALL s_errmsg('oga01',l_oga.oga01,'upd oga:',SQLCA.sqlcode,1) 
     ELSE
      CALL cl_err('upd oga:',SQLCA.sqlcode,1)
     END IF     
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION p910_imd(p_imd01,p_plant)   
   DEFINE p_imd01   LIKE imd_file.imd01,
          l_imd11   LIKE imd_file.imd11,
          p_dbs     LIKE type_file.chr21,   #No.FUN-680137 VARCHAR(21)
         #l_sql     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(400)   #CHI-940042 mark
          l_sql     STRING                 #CHI-940042 
  DEFINE p_plant   LIKE azp_file.azp01    #FUN-980092 add
  DEFINE p_dbs_tra LIKE azw_file.azw05    #FUN-980092 add
 
   LET g_errno=''#FUN-980092 add
 
     #改抓Transaction DB
     LET g_plant_new = p_plant
     CALL s_getdbs()
     LET p_dbs = g_dbs_new
     CALL s_gettrandbs()
     LET p_dbs_tra = g_dbs_tra
 
 
   #LET l_sql="SELECT imd11  FROM ",p_dbs CLIPPED," imd_file",
   LET l_sql="SELECT imd11  FROM ",cl_get_target_table(g_plant_new,'imd_file'), #FUN-A50102 
             " WHERE imd01 = '",p_imd01,"'",
             "   AND imd10 = 'S' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
     CALL cl_parse_qry_sql(l_sql,g_plant_new) RETURNING l_sql #FUN-A50102
   PREPARE imd_pre FROM l_sql
 
   DECLARE imd_cs CURSOR FOR imd_pre
 
   OPEN imd_cs
   FETCH imd_cs INTO l_imd11
 
   CASE
      WHEN SQLCA.SQLCODE = 100
         LET g_errno = 'mfg4020'
      WHEN l_imd11 = 'N'
         LET g_errno = 'mfg6080'
      OTHERWISE 
         LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
 
   IF NOT cl_null(g_errno) THEN
      CALL cl_err(p_dbs,g_errno,1)
      LET g_success = 'N'
   END IF
 
   CLOSE imd_cs
 
END FUNCTION
 
FUNCTION p910_ima(p_part)
   DEFINE p_part    LIKE ima_file.ima01
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_ima25   LIKE ima_file.ima25
#   DEFINE l_qoh     LIKE ima_file.ima262 #FUN-A20044
   DEFINE l_qoh     LIKE type_file.num15_3 #FUN-A20044
   DEFINE l_ima86   LIKE ima_file.ima86
   DEFINE l_ima39   LIKE ima_file.ima39
   DEFINE l_ima35   LIKE ima_file.ima35
   DEFINE l_ima36   LIKE ima_file.ima36
  #DEFINE l_sql1    LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)   #CHI-940042 mark
   DEFINE l_sql1    STRING                 #CHI-940042 
   DEFINE l_msg     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(50)
   DEFINE l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk LIKE type_file.num15_3 #FUN-A20044 
 
   #抓取料件相關資料
#   LET l_sql1 = "SELECT ima02,ima25,ima261+ima262,ima86,ima39,", #FUN-A20044
   LET l_sql1 = "SELECT ima02,ima25,0,ima86,ima39,", #FUN-A20044
                "       ima35,ima36 ",
                #" FROM ",l_dbs_new CLIPPED,"ima_file ",
                " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                " WHERE ima01='",p_part,"' " 
 
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE ima_pre FROM l_sql1
   IF SQLCA.SQLCODE THEN 
     IF g_bgerr THEN
      CALL s_errmsg('ima01',p_part,'ima_pre',SQLCA.SQLCODE,1) 
     ELSE
      CALL cl_err('ima_pre',SQLCA.SQLCODE,1)
     END IF
   END IF
 
   DECLARE ima_cs CURSOR FOR ima_pre
 
   OPEN ima_cs
 
   FETCH ima_cs INTO l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
   CALL s_getstock(p_part,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk #FUN-A20044
   LET l_qoh = l_unavl_stk + l_avl_stk  #FUN-A20044
   IF SQLCA.SQLCODE <> 0 THEN
     LET l_msg = l_dbs_new,":",p_part
     IF g_bgerr THEN
      CALL s_errmsg('ima01',p_part,l_msg,'axm-297',1)   
     ELSE 
      CALL cl_err(l_msg,'axm-297',1)
     END IF
      LET g_success='N'
   END IF
 
   CLOSE ima_cs
 
   RETURN l_ima02,l_ima25,l_qoh,l_ima86,l_ima39,l_ima35,l_ima36
 
END FUNCTION
 
FUNCTION p910_chkoeo(p_oeo01,p_oeo03,p_oeo04)
   DEFINE p_oeo01   LIKE oeo_file.oeo01
   DEFINE p_oeo03   LIKE oeo_file.oeo03
   DEFINE p_oeo04   LIKE oeo_file.oeo04
  #DEFINE l_sql     LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)   #CHI-940042 mark
   DEFINE l_sql     STRING                 #CHI-940042 
   
   #LET l_sql=" SELECT COUNT(*) FROM ",l_dbs_tra,"oeo_file ",  #FUN-980092 add
   LET l_sql=" SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oeo_file'), #FUN-A50102
             "  WHERE oeo01 = '",p_oeo01,"'",
             "    AND oeo03 = '",p_oeo03,"'",
             "    AND oeo04 = '",p_oeo04,"'",
             "    AND oeo08 = '2' "
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
   PREPARE chkoeo_pre FROM l_sql
 
   DECLARE chkoeo_cs CURSOR FOR chkoeo_pre
 
   OPEN chkoeo_cs 
   FETCH chkoeo_cs INTO g_cnt
 
   IF g_cnt > 0 THEN
      RETURN 1 
   ELSE
      RETURN 0
   END IF
 
END FUNCTION 
 
# 取得多角序號
FUNCTION p910_flow99()
     
   IF cl_null(g_oga.oga99) THEN
      CALL s_flowauno('oga',g_oea.oea904,g_oga.oga02)
           RETURNING g_sw,g_flow99
      IF g_sw THEN
        IF g_bgerr THEN
           CALL s_errmsg(' ',' ',' ','tri-011',1)   
        ELSE
           CALL cl_err('','tri-011',1)
        END IF
         LET g_success = 'N' RETURN
      END IF
 
      UPDATE oga_file SET oga99 = g_flow99
       WHERE oga01 = g_oga.oga01
      IF SQLCA.SQLCODE THEN
        IF g_bgerr THEN     
          CALL s_errmsg('oga01',g_oga.oga01,' ',SQLCA.sqlcode,1)                
        ELSE
          CALL cl_err3("upd","oga_file",g_oga.oga01,"",SQLCA.SQLCODE,"","upd oga99",1)
        END  IF
         LET g_success = 'N'
         RETURN
      END IF
 
      #更新INVOICE ofa99
      IF NOT cl_null(g_oga.oga27) AND g_oax.oax04='Y' AND g_oaz.oaz67 = '1' THEN
         UPDATE ofa_file SET ofa99= g_flow99
          WHERE ofa01 = g_oga.oga27
         IF SQLCA.SQLCODE THEN
            IF g_bgerr THEN      
              CALL s_errmsg('ofa01',g_oga.oga27,'upd ofa_file',SQLCA.sqlcode,1)  
            ELSE
              CALL cl_err3("upd","ofa_file",g_oga.oga27,"",SQLCA.SQLCODE,"","upd ofa99",1) 
            END IF
            LET g_success = 'N'
            RETURN
         END IF
      END IF
 
      #馬上檢查是否有搶號
      LET g_cnt = 0 
      SELECT COUNT(*) INTO g_cnt FROM oga_file 
       WHERE oga99 = g_flow99
         AND oga09 = '5'
      IF g_cnt > 1 THEN
         IF g_bgerr THEN
          LET g_showmsg=g_flow99,"/",5    
          CALL s_errmsg('oga99,oga09',g_showmsg,'','tri-011',1) 
         ELSE
          CALL cl_err('','tri-011',1)
         END IF
         LET g_success = 'N'
         RETURN
      END IF
   END IF
 
END FUNCTION 
 
#因為各單據的xxx99欄位在資料庫非Unique,
#所以為了安全還是給它檢查一下
FUNCTION p910_chk99()
  #DEFINE l_sql LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(500)   #CHI-940042 mark
   DEFINE l_sql STRING                 #CHI-940042 
 
   #LET l_sql = " SELECT COUNT(*) FROM ",l_dbs_tra CLIPPED,"oga_file ",  #FUN-980092 add
   LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oga_file'), #FUN-A50102
               "  WHERE oga99 ='",g_flow99,"'",
               "    AND oga09 = '5'"
 
 	 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
         CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-980092
   PREPARE ogacnt_pre FROM l_sql
 
   DECLARE ogacnt_cs CURSOR FOR ogacnt_pre
 
   OPEN ogacnt_cs 
   FETCH ogacnt_cs INTO g_cnt                                #出貨單
 
   IF g_cnt > 0 THEN
      LET g_msg = l_dbs_tra CLIPPED,'oga99 duplicate'   #FUN-980092 add
      IF g_bgerr THEN
        CALL s_errmsg('oga09',5, g_msg,'tri-011',1)    
      ELSE
        CALL cl_err(g_msg,'tri-011',1)
      END IF
      LET g_success = 'N'
   END IF
 
END FUNCTION
 
FUNCTION p910_imgs(p_ware,p_loca,p_lot,p_date,p_rvbs)
   DEFINE p_rvbs   RECORD LIKE rvbs_file.*
   DEFINE p_ware   LIKE imgs_file.imgs02
   DEFINE p_loca   LIKE imgs_file.imgs03
   DEFINE p_lot    LIKE imgs_file.imgs04
   DEFINE p_date   LIKE tlfs_file.tlfs111
   DEFINE l_imgs   RECORD LIKE imgs_file.*
   DEFINE l_tlfs   RECORD LIKE tlfs_file.*
   DEFINE l_ima25  LIKE ima_file.ima25
  #DEFINE l_sql1   LIKE type_file.chr1000   #CHI-940042 mark
  #DEFINE l_sql2   LIKE type_file.chr1000   #CHI-940042 mark
   DEFINE l_sql1,l_sql2 STRING              #CHI-940042 
   DEFINE l_n      LIKE type_file.num5
 
   LET l_sql1 = "SELECT COUNT(*) ",
                #"  FROM ",l_dbs_tra CLIPPED,"imgs_file ",  #FUN-980092 add
                "  FROM ",cl_get_target_table(l_plant_new,'imgs_file'), #FUN-A50102
                " WHERE imgs01='",p_rvbs.rvbs021,"' ",
                "   AND imgs02='",p_ware,"'",
                "   AND imgs03='",p_loca,"'",
                "   AND imgs04='",p_lot,"'",
                "   AND imgs05='",p_rvbs.rvbs03,"'",
                "   AND imgs06='",p_rvbs.rvbs04,"'",
                "   AND imgs11='",p_rvbs.rvbs08,"'"
  
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
         CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-980092
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
  
      #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"imgs_file",  #FUN-980092 add
      LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'imgs_file'), #FUN-A50102
                   "(imgs01,imgs02,imgs03,imgs04,imgs05,imgs06,",
                   " imgs07,imgs08,imgs09,imgs10,imgs11,",
                   " imgsplant,imgslegal)",    #FUN-980010
                   " VALUES( ?,?,?,?,?,?, ?,?,?,?,?,  ?,?)"   #FUN-980010
  
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
      PREPARE ins_imgs FROM l_sql2
  
      EXECUTE ins_imgs USING l_imgs.imgs01,l_imgs.imgs02,l_imgs.imgs03,
                             l_imgs.imgs04,l_imgs.imgs05,l_imgs.imgs06,
                             l_imgs.imgs07,l_imgs.imgs08,l_imgs.imgs09,
                             l_imgs.imgs10,l_imgs.imgs11,
                             gp_plant,gp_legal   #FUN-980010
      IF SQLCA.sqlcode<>0 THEN
         LET g_msg = l_dbs_tra CLIPPED,'ins imgs'  #FUN-980092 add
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
   LET l_tlfs.tlfs07 = l_ima25
   LET l_tlfs.tlfs08 = p_rvbs.rvbs00
   LET l_tlfs.tlfs09 = 0
   LET l_tlfs.tlfs10 = p_rvbs.rvbs01
   LET l_tlfs.tlfs11 = p_rvbs.rvbs02
   LET l_tlfs.tlfs111 = p_date
   LET l_tlfs.tlfs12 = g_today
   LET l_tlfs.tlfs13 = p_rvbs.rvbs06
   LET l_tlfs.tlfs14 = p_rvbs.rvbs07
   LET l_tlfs.tlfs15 = p_rvbs.rvbs08
 
   #LET l_sql2 = "INSERT INTO ",l_dbs_tra CLIPPED,"tlfs_file",  #FUN-980092 add
   LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'tlfs_file'), #FUN-A50102
                "(tlfs01,tlfs02,tlfs03,tlfs04,tlfs05,tlfs06,tlfs07,",
                " tlfs08,tlfs09,tlfs10,tlfs11,tlfs12,tlfs13,tlfs14,",
                " tlfs15,tlfs111,",
                " tlfsplant,tlfslegal)",
                " VALUES( ?,?,?,?,?,?,?, ?,?,?,?,?,?,?, ?,?, ?,?)"  #FUN-980010
 
 	 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
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
# No.FUN-9C0073 --------------By chenls 10/01/06 

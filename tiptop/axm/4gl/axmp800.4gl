# Prog. Version..: '5.30.06-13.04.19(00010)'     #
#
# Pattern name...: axmp800.4gl
# Descriptions...: 三角貿易訂單拋轉作業
# Date & Author..: 98/12/08 By Linda
# Modify.........: No.7963 03/08/28 Kammy 1.流程抓取方式修改(poz_file,poy_file)
#                                         2.拋轉訂單Memo資料否(poz10) 
# Modify.........: No.9706 04/06/30 ching update oao 錯誤
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: NO.FUN-560043 05/06/15 By Smapmin 根據雙單位做調整,多角序號放大,單號放大
# Modify.........: NO.FUN-5A0105 05/10/20 By Claire 將原始客戶訂單號碼拋轉給下游廠商
# Modify.........: NO.MOD-590239 05/09/29 By Yiting 計算採購單總金額pmm40的時候,做digcut時保留了本幣的金額位數而不是原幣的,
# Modify.........: NO.MOD-5C0064 05/12/13 By Nicola 工廠別錯誤
# Modify.........: No.FUN-610018 06/01/17 By ice 增加含稅金額pmm40t
# Modify.........: No.FUN-620024 06/02/11 By Rayven 增加對訂單，采購單單別的獲取
# Modify.........: No.FUN-630006 06/03/06 By Nicola 預設pmm909="1"
# Modify.........: NO.TQC-640078 06/04/09 BY yiting 拋轉其它區工場時，訂單金額不對
# Modify.........: NO.TQC-650089 06/05/24 BY elva 選取訂單時過濾掉返利的訂單
# Modify.........: NO.TQC-650127 06/05/29 BY sam_lin [mrp計算否為Y] / [發票扣抵區分為可扣抵進貨及費用]
# Modify.........: No.FUN-640248 06/05/26 By Echo 自動執行確認功能
# Modify.........: No.FUN-660167 06/06/23 By Ray cl_err --> cl_err3
# Modify.........: No.MOD-660103 06/06/28 By Pengu 重新拋轉已拋轉資料之pmm03 版本未更新到  
# Modify.........: NO.FUN-670007 06/07/27 BY yiting 1. oaz32->oax01,oaz07->oax02,oaz105->oax06
#                                                   2. 多角拋轉後，相關訂單單頭資料來源寫入7.多角銷售轉入
#                                                   3. s_mutislip新傳入流程代碼/站別參數
#                                                   4. p800_azp()修改                                                      
# Modify.........: NO.FUN-660068 06/08/28 BY yiting pmn122要拋到本區採購單單身
# Modify.........: No.FUN-680137 06/09/08 By ice 欄位型態用LIKE定義
# Modify.........: NO.TQC-680107 06/09/11 BY wujie  s_fetch_price2應取來源工廠在本站庫內的定價
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0065 06/11/21 By Ray atmi217并入aooi313(azf09,10,11,12,13取代tqe03,04,05,11,08)
# Modify.........: NO.TQC-6A0084 06/12/05 By Nicola 含稅金額、未稅金額調整
# Modify.........: No.FUN-710046 07/01/23 By cheunl 錯誤訊息匯整
# Modify.........: NO.MOD-710074 07/01/31 BY claire 多角拋轉時各站送貨客戶要同第一站
# Modify.........: NO.FUN-6B0064 07/02/02 BY rainy 批次無資料時要秀訊息,不能顯示執行成功
# Modify.........: No.FUN-720037 07/03/20 By Nicola 依參數判斷取價日期
# Modify.........: No.FUN-740016 07/04/17 By Nicola 借出管理
# Modify.........: NO.TQC-740104 07/04/18 BY yiting pmn90取出單價未處理，拋轉時給予和pmn31相同default值
# Modify.........: NO.MOD-740192 07/04/22 BY yiting insert oao_file需寫入當站的單號
# Modify.........: NO.MOD-740222 07/05/09 BY yiting update pmn_file時，少了一個逗號，造成update error
# Modify.........: NO.TQC-760054 07/06/06 By xufeng azf_file的index是azf_01(azf01,azf02),但是在抓‘中文說明’內容時，WHERE條件卻只有 azf01 = g_xxx
# Modify.........: No.MOD-780030 07/08/08 By claire 訂單拋備註時其它站的單號要取該站為主而非來源站
# Modify.........: No.MOD-780143 07/08/23 By claire 訂單拋採購單的含稅單價未做取位
# Modify.........: No.MOD-760026 07/08/24 By claire 新增的訂單變更單項次拋轉時僅更新本站並未更新其它站
# Modify.........: No.MOD-760123 07/08/24 By claire 新增的訂單變更單項次拋轉會失敗因g_oea.oea99沒有值
# Modify.........: No.MOD-780046 07/08/24 By claire 新增的訂單變更單項次若為1時會有問題,造成單頭會insert一筆新訂單
# Modify.........: NO.MOD-780191 07/08/29 BY yiting 拋轉時需檢核單別設定資料是否齊全
# Modify.........: No.TQC-790002 07/09/03 By Sarah Primary Key：複合key在INSERT INTO table前需增加判斷，如果是NULL就給值blank(字串型態) or 0(數值型態)
# Modify.........: No.FUN-7B0091 07/11/19 By Sarah oea65預設值給N
# Modify.........: No.MOD-7B0224 07/11/27 By claire 設二站(ds1->ds2)的銷售拋轉第一站(ds2)沒有確認料號是否存在
# Modify.........: No.TQC-7B0152 07/11/29 By Judy  當產品價格檔中沒有該筆產品時，程式彈出的報錯信息為重復顯示2遍
# Modify.........: No.TQC-7C0064 07/12/08 By Beryl 拋轉時判斷單別在拋轉資料庫是否存在，如果不存在，則報錯，批處理運行不成功．提示user單據別無效或不存在其資料庫中
# Modify.........: No.TQC-7C0093 07/12/08 By Davidzv 增加訂單查詢開窗
# Modify.........: NO.TQC-7C0155 07/12/19 BY yiting 多角訂單拋轉不應該LET oea00 = '6'
# Modify.........: No.FUN-7B0018 08/02/29 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: NO.MOD-850099 08/05/09 BY claire pmm906值錯給
# Modify.........: NO.MOD-850243 08/05/29 BY claire poy10未建檔給錯誤訊息
# Modify.........: No.MOD-860168 08/06/19 By claire 採購單別設定應check當下產生PO的DB
# Modify.........: No.MOD-860042 08/07/15 By Pengu INSERT oeb_file時oeb28應該要default 0
# Modify.........: No.FUN-8A0086 08/10/21 By lutingting完善錯誤訊息匯總
# Modify.........: No.MOD-910077 09/01/09 By claire 採購未稅含稅金額依幣別取位
# Modify.........: NO.MOD-830134 09/02/03 BY claire 給pmn38變數值由pmm45給予
# Modify.........: No.MOD-930292 09/03/27 By chenyu 多角訂單拋轉采購單的時候，直接把訂單單身的價格oeb13給pmn31，沒有考慮oeb13是含稅單價還是未稅單價
# Modify.........: No.MOD-940252 09/04/20 By Dido 無論 g_sw 是否有抓取正常皆須檢核 oax02
# Modify.........: No.FUN-940083 09/05/18 By zhaijie調整批處理賦值
# Modify.........: No.MOD-960023 09/06/05 By Dido 若 oea905 = 'N' 應檢核單身須為無結案的訂單才可拋轉
# Modify.........: No.FUN-980010 09/08/31 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980224 09/08/26 By sherry  l_stu_p_h在下一站之前未清空，會導致拋不進去         
# Modify.........: No.TQC-980152 09/08/31 By lilingyu "流程代碼"欄位需開窗
# Modify.........: No.FUN-980020 09/09/01 By douzh GP5.2架構重整，修改sub相關傳參
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990054 09/09/07 By Dido 計數變數調整
# Modify.........: No.FUN-980059 09/09/09 By arman GP5.2架構,修改Sub相關傳入參數
# Modify.........: No.FUN-8C0125 09/09/10 By chenmoyan 改pmmmplant為pmmplant
# Modify.........: No.FUN-980092 09/09/21 By TSD.sar2436  GP5.2 跨資料庫語法修改
# Modify.........: No.CHI-950020 09/10/06 By chenmoyan 將自定義欄位的值拋轉各站
# Modify.........: No.TQC-980236 09/08/25 By Carrier 单别检查错误时,将g_success = 'N' 
# Modify.........: No:TQC-9B0013 09/11/27 By Dido 單別於建檔刪除後,應控卡不可產生拋轉
# Modify.........: No:TQC-9C0054 09/12/08 By Carrier 出现-254的错误
# Modify.........: No:MOD-9C0287 09/12/19 By Dido 若此DB為流通配銷取價所帶的資料庫有誤
# Modify.........: No:MOD-9C0379 09/12/24 By Dido 增加更新 oeb11 
# Modify.........: No.FUN-A10036 10/01/13 By baofei 手動修改INSERT INTO xxx_file ，增加xxx_file xxxoriu, xxxorig這二個欄位 
# Modify.........: No:FUN-9C0071 10/01/15 By huangrh 精簡程式
# Modify.........: No:MOD-A10123 10/02/03 By Smapmin oeb1006若為空時,default 100
# Modify.........: No.FUN-A50102 10/06/12 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A80102 10/08/20 By kim GP5.25號機管理
# Modify.........: No.FUN-A80054 10/08/26 By jan GP5.25工單合拼
# Modify.........: No:MOD-A90149 10/09/28 By Smapmin 目的站沒有送貨客戶編號,即控卡不可拋轉.
# Modify.........: No:MOD-A80157 10/10/22 By Smapmin 重拋時,未將新增的備註資料新增到其他站
# Modify.........: No:MOD-AB0083 10/11/10 By Smapmin 計算未稅或含稅金額時,要先取位再計算未稅或含稅金額.
# Modify.........: No.FUN-AB0061 10/11/16 By vealxu 訂單、出貨單、銷退單加基礎單價字段(oeb37,ogb37,ohb37)
# Modify.........: No.TQC-AC0244 10/12/17 By wuxj   抛转时应该是产生上站的采购单和本站的订单，l_aza.aza50-->s_aza.aza50
# Modify.........: No:MOD-B10100 11/01/14 By Summer 從DS1拋到DS2產生的多角訂單，其業務員oea14與oea15應該是抓DS2的客戶對應之業務員與部門編號
# Modify.........: No:MOD-B30176 11/03/12 By suncx 已拋轉訂單重複拋轉BUG修正
# Modify.........: No:MOD-B30491 11/03/17 By Summer 未將訂單轉換成未稅金額再計算 
# Modify.........: No:FUN-B20060 11/04/07 By zhangll  增加oeb72賦值
# Modify.........: No:MOD-B80172 11/08/17 By suncx 按比率計算時採購單未稅金額與訂單不一致
# Modify.........: No:MOD-B90047 11/09/08 By johung 拋轉寫入oeb_file時重抓oeb05_fac
# Modify.........: No:FUN-C40072 12/05/29 By Sakura oea65依起拋單據資料拋轉
# Modify.........: No:MOD-C60122 12/06/19 By Elise 增加更新oea10與oea43欄位
# Modify.........: No:MOD-C60235 12/07/19 By Vampire 在寫入單身金額之後,重算單頭oea261,oea262,oea263
# Modify.........: No.FUN-C50136 12/08/08 By xianghui 多角訂單拋磚時，如果已確認則需進行對oib_file和oic_file的插入與更新
# Modify.........: No:CHI-C80009 12/08/09 By Sakura ICD多角拋轉時,需一併拋轉icd相關值
# Modify.......... No:CHI-C80060 12/08/27 By pauline 令oeb72預設值為null
# Modify.........: No.FUN-C80001 12/08/29 By bart 多角拋轉時，批號需一併拋轉sma96
# Modify.........: No:MOD-C90136 12/09/20 By SunLM 對t_plant进行赋值,原來t_plant為NULL
# Modify.........: No:MOD-D10124 13/01/31 By Elise 調整增加回寫oea31
# Modify.........: No:FUN-D30099 13/03/29 By Elise 將asms230的sma96搬到apms010,欄位改為pod08
# Modify.........: No:TQC-D40030 13/04/16 By SunLM 税率l_taxrate为空,应该采用pmm43;调整尾差
# Modify.........: No.TQC-D40064 13/06/19 By fengrui  理由碼調整
# Modify.........: No:MOD-D60237 13/06/28 By SunLM 將create temp table移動到事物外面

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_oea   RECORD LIKE oea_file.*
DEFINE g_oeb   RECORD LIKE oeb_file.*
DEFINE g_oebi  RECORD LIKE oebi_file.*  #CHI-C80009 add
DEFINE g_pmm   RECORD LIKE pmm_file.*
DEFINE g_pmn   RECORD LIKE pmn_file.*
DEFINE tm RECORD
          wc     LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(600)
          oea905 LIKE oea_file.oea905
       END RECORD
DEFINE g_poz  RECORD LIKE poz_file.*    #流程代碼資料(單頭) No.7963
DEFINE g_poy  RECORD LIKE poy_file.*    #流程代碼資料(單身) No.7963
DEFINE s_poy  RECORD LIKE poy_file.*    #來源流程資料(單身) No.7963
DEFINE p_pmm09  LIKE pmm_file.pmm09,    #廠商代號
       p_oea03  LIKE oea_file.oea03,    #客戶代號
       p_oea903 LIKE oea_file.oea903,   #營業稅申報方式
       p_poy04  LIKE poy_file.poy04,    #工廠編號
       p_poz03  LIKE poz_file.poz03,    #申報方式
       p_poy06  LIKE poy_file.poy06,    #付款條件
       p_poy07  LIKE poy_file.poy07,    #收款條件
       p_poy08  LIKE poy_file.poy08,    #SO稅別
       p_poy09  LIKE poy_file.poy09,    #PO稅別
       p_poy12  LIKE poy_file.poy12,    #發票別
       p_poy10  LIKE poy_file.poy10,    #銷售分類
       p_poy26  LIKE poy_file.poy26,    #是否計算業績 
       p_poy27  LIKE poy_file.poy27,    #業績歸屬方
       p_poy28  LIKE poy_file.poy28,    #出貨理由碼
       p_poy29  LIKE poy_file.poy29,    #代送商編號
       p_poy33  LIKE poy_file.poy33,    #債權代碼 
       p_pox03  LIKE pox_file.pox03,    #計價基準
       p_pox05  LIKE pox_file.pox05,    #計價方式
       p_pox06  LIKE pox_file.pox06,    #計價比率
       p_azi01  LIKE azi_file.azi01,    #計價幣別 
       p_cnt    LIKE type_file.num5     #計價方式符合筆數 #No.FUN-680137 SMALLINT
  DEFINE g_flow99 LIKE oga_file.oga99   #多角序號   #FUN-560043 #No.FUN-680137 VARCHAR(17)
  DEFINE t_dbs    LIKE type_file.chr21  #No.FUN-680137 VARCHAR(21)
  DEFINE t_plant  LIKE type_file.chr10  #No.FUN-980020
  DEFINE s_dbs_new LIKE type_file.chr21   #New DataBase Name #No.FUN-680137 VARCHAR(21)
  DEFINE s_plant_new LIKE type_file.chr10 #No.FUN-980020
  DEFINE l_dbs_new LIKE type_file.chr21   #New DataBase Name #No.FUN-680137 VARCHAR(21)
  DEFINE l_plant_new LIKE type_file.chr10 #No.FUN-980020
  DEFINE l_aza  RECORD LIKE aza_file.*
  DEFINE s_aza  RECORD LIKE aza_file.*
  DEFINE l_sma  RECORD LIKE sma_file.*  #NO.FUN-620024
  DEFINE s_azp  RECORD LIKE azp_file.*
  DEFINE l_azp  RECORD LIKE azp_file.*
  DEFINE s_azi  RECORD LIKE azi_file.*
  DEFINE l_azi  RECORD LIKE azi_file.*
  DEFINE g_sw   LIKE type_file.chr1     #No.FUN-680137 VARCHAR(1)
  DEFINE g_argv1  LIKE oea_file.oea01
DEFINE   g_cnt     LIKE type_file.num10    #No.FUN-680137 INTEGER
DEFINE   g_i       LIKE type_file.num5     #count/index for any purpose  #No.FUN-680137 SMALLINT
DEFINE   g_msg     LIKE type_file.chr1000  #No.FUN-680137 VARCHAR(72)
DEFINE   g_t1      LIKE apy_file.apyslip   #NO.FUN-620024 #No.FUN-680137 VARCHAR(03)
DEFINE   p_success LIKE type_file.chr4     #NO.FUN-620024 #No.FUN-680137 VARCHAR(04)
DEFINE   g_oea905  LIKE oea_file.oea905    #NO.FUN-620024 #No.FUN-680137 VARCHAR(01)
DEFINE sp_legal,gp_legal   LIKE azw_file.azw02    #FUN-980010 add
DEFINE sp_plant,gp_plant   LIKE azp_file.azp01    #FUN-980010 add
DEFINE l_dbs_tra   LIKE azw_file.azw05   #FUN-980092 add
DEFINE s_dbs_tra   LIKE azw_file.azw05   #FUN-980092 add
DEFINE g_oeb13_h   LIKE oeb_file.oeb13   #MOD-B80172 add 
 
MAIN
   IF FGL_GETENV("FGLGUI") <> "0" THEN
      OPTIONS                                #改變一些系統預設值
           INPUT NO WRAP,
           FIELD ORDER FORM
      DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
 
    LET g_argv1 = ARG_VAL(1)
    LET tm.oea905 = ARG_VAL(2)         #是否重新拋轉
    IF cl_null(g_oax.oax01) THEN       #三角貿易使用匯率
       LET g_oax.oax01='S'
    END IF
    LET t_dbs = g_plant                #FUN-980020
    LET t_dbs = s_dbstring(g_dbs CLIPPED)
    #若有傳參數則不用輸入畫面
    IF cl_null(g_argv1) THEN 
       CALL p800_p1()
    ELSE
       LET tm.wc = " oea01='",g_argv1,"' "
       IF cl_null(tm.oea905) THEN LET tm.oea905='N' END IF
       CALL p800_p2()
    END IF
 
    IF g_bgjob='N' OR cl_null(g_bgjob) THEN
       CLOSE WINDOW p800_w
    END IF
 
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
END MAIN
 
FUNCTION p800_p1()
 DEFINE l_ac   LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_i    LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_cnt  LIKE type_file.num5    #No.FUN-680137 SMALLINT
 DEFINE l_flag LIKE type_file.num5    #No.FUN-680137 SMALLINT
 
    OPEN WINDOW p800_w WITH FORM "axm/42f/axmp800" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
    CALL cl_opmsg('z')
 LET tm.oea905='N'
 DISPLAY BY NAME tm.oea905
 WHILE TRUE
    LET g_action_choice = ''
    CONSTRUCT BY NAME tm.wc ON oea01,oea02,oea904 
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
        CASE
         WHEN INFIELD(oea01)       
         CALL cl_init_qry_var() 
         LET g_qryparam.form = "q_oea15"                                                                                      
         LET g_qryparam.state = "c"                                                                                           
         CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
         DISPLAY g_qryparam.multiret to oea01                                                                                 
         NEXT FIELD oea01
 
         WHEN INFIELD(oea904) 
             CALL cl_init_qry_var() 
             LET g_qryparam.form = "q_oea904"                                                                                      
             LET g_qryparam.state = "c"                                                                                           
             CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
             DISPLAY g_qryparam.multiret to oea904                                                                                 
             NEXT FIELD oea904             
         END CASE     
      #No.TQC-7C0093---end---
    END CONSTRUCT
    LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('oeauser', 'oeagrup') #FUN-980030
    IF g_action_choice = 'locale' THEN
       CALL cl_dynamic_locale()
       CALL cl_show_fld_cont()   #FUN-550037(smin)
       CONTINUE WHILE
    END IF
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    LET tm.oea905='N'
    INPUT BY NAME tm.oea905  WITHOUT DEFAULTS  
 
         AFTER FIELD oea905
            IF cl_null(tm.oea905) OR tm.oea905 NOT MATCHES '[YN]' THEN
               NEXT FIELD oea905
            END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG 
         call cl_cmdask()
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
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   IF cl_sure(0,0) THEN 
      CALL p800_p2()
      IF g_success = 'Y' THEN
         CALL cl_end2(1) RETURNING l_flag
      ELSE
         CALL cl_end2(2) RETURNING l_flag
      END IF
      IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
   END IF
 END WHILE
END FUNCTION
 
FUNCTION p800_p2()
  DEFINE l_oea  RECORD LIKE oea_file.*
  DEFINE l_oeb  RECORD LIKE oeb_file.*
  DEFINE l_oeo  RECORD LIKE oeo_file.*
  DEFINE l_oao  RECORD LIKE oao_file.*
  DEFINE l_pmm  RECORD LIKE pmm_file.*
  DEFINE l_pmn  RECORD LIKE pmn_file.*
  DEFINE l_occ  RECORD LIKE occ_file.*
  DEFINE l_pmc  RECORD LIKE pmc_file.*
  DEFINE l_pox  RECORD LIKE pox_file.*
  DEFINE l_gec  RECORD LIKE gec_file.*
  DEFINE l_ima  RECORD LIKE ima_file.*
  DEFINE l_sql  LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1200)
  DEFINE l_sql1 LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(600)
  DEFINE l_sql2 STRING  #FUN-670007    #用chr1000太小了 只有char(1000)#LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(1600)
  DEFINE l_sql3 LIKE type_file.chr1000 #NO.FUN-620024 #No.FUN-680137 VARCHAR(1200)
  DEFINE i,l_i  LIKE type_file.num5    #No.FUN-680137 SMALLINT
  DEFINE o_pox05 LIKE pox_file.pox05   #計價方式
  DEFINE p_last LIKE type_file.num5    #流程之最後家數  #No.FUN-680137 SMALLINT
  DEFINE p_last_plant LIKE azp_file.azp01 #No.FUN-680137 VARCHAR(10)
  DEFINE diff_azi LIKE type_file.chr1,   #若為Y表示單身計價方式有所不同 #No.FUN-680137 VARCHAR(1)
         l_cnt    LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_cnt0   LIKE type_file.num5,   #No.FUN-6B0064 add
         azi_pox05 LIKE pox_file.pox05,  #記錄單頭該用之計價方式
         min_oeb15 LIKE oeb_file.oeb15   #記錄該訂單之最小預交日
  DEFINE l_j      LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_msg    LIKE type_file.chr1000 #No.FUN-680137 VARCHAR(60)
  DEFINE l_occ02 LIKE occ_file.occ02,
         l_occ04 LIKE occ_file.occ04,     #負責業務員代號 #MOD-B10100 add
         l_occ08 LIKE occ_file.occ08,
         l_occ11 LIKE occ_file.occ11,
         l_occ1006 LIKE occ_file.occ1006, #所屬渠道
         l_occ1005 LIKE occ_file.occ1005, #所屬方
         l_occ1022 LIKE occ_file.occ1022, #發票客戶編號
         l_azf10 LIKE azf_file.azf10,     #是否搭贈     #No.FUN-6B0065
         l_price LIKE oeb_file.oeb13,
         l_no    LIKE type_file.num5,     #No.FUN-680137 SMALLINT
         l_currm LIKE pmm_file.pmm42,
         l_curr  LIKE pmm_file.pmm22      #No.FUN-680137 VARCHAR(04)
  DEFINE l_unit    LIKE oeb_file.oeb05    #NO.FUN-620024
  DEFINE l_oea_t1  LIKE oan_file.oan01    #NO.FUN-620024
  DEFINE l_pmm_t1  LIKE oan_file.oan02    #NO.FUN-620024
  DEFINE l_x       LIKE oan_file.oan03    #NO.FUN-620024
  DEFINE l_a       LIKE oea_file.oea1013  #NO.FUN-620024
  DEFINE l_b       LIKE oea_file.oea1014  #NO.FUN-620024
  DEFINE l_sum1    LIKE oea_file.oea1013  #NO.FUN-620024
  DEFINE l_sum2    LIKE oea_file.oea1014  #NO.FUN-620024
  DEFINE li_result LIKE type_file.num5    #NO.FUN-620024 #No.FUN-680137 SMALLINT
  DEFINE l_stu_p   LIKE type_file.chr1    #NO.FUN-620024 #No.FUN-680137 VARCHAR(01)
  DEFINE l_stu_o   LIKE type_file.chr1    #NO.FUN-620024 #No.FUN-680137 VARCHAR(01)
  DEFINE l_stu_p_h LIKE type_file.chr1    #MOD-760026 add                           
  DEFINE l_stu_o_h LIKE type_file.chr1    #MOD-760026 add
  DEFINE l_poy02   LIKE poy_file.poy02    #NO.FUN-670047
  DEFINE l_numlast LIKE type_file.chr1000 #NO.TQC-7B0152
  DEFINE l_oebi    RECORD LIKE oebi_file.* #No.FUN-7B0018
  DEFINE l_pmni    RECORD LIKE pmni_file.* #No.FUN-7B0018
  DEFINE l_incltax LIKE oea_file.oea213,   #MOD-B30491 add
         l_taxrate LIKE oea_file.oea211    #MOD-B30491 add
  DEFINE l_check   LIKE type_file.chr1     #MOD-B90047 add
  DEFINE l_oea61   LIKE oea_file.oea61     #MOD-C60235 add
  DEFINE l_oea1008 LIKE oea_file.oea1008   #MOD-C60235 add
# DEFINE l_oia07   LIKE oia_file.oia07     #FUN-C50136 add
 
   CALL cl_wait() 
#MOD-D60237 add begin--------
  CREATE TEMP TABLE p800_file(
         p_no       LIKE type_file.num5,  
         so_no      LIKE oea_file.oea01,   
         so_item    LIKE oeb_file.oeb03,
         so_price   LIKE oeb_file.oeb13,  
         so_curr    LIKE oea_file.oea23,    #MOD-B30491 mod
         so_incltax LIKE oea_file.oea213,   #MOD-B30491 add
         so_taxrate LIKE oea_file.oea211);  #MOD-B30491 add
  DELETE FROM p800_file
#MOD-D60237 add end-----------   
   BEGIN WORK 
   LET g_success='Y'
   LET g_oea905 = 'N'       #NO.FUN-620024
   LET l_cnt0 = 0   #FUN-6B0064 add
#MOD-D60237 mark begin--------   
#  CREATE TEMP TABLE p800_file(
#         p_no       LIKE type_file.num5,  
#         so_no      LIKE oea_file.oea01,   
#         so_item    LIKE oeb_file.oeb03,
#         so_price   LIKE oeb_file.oeb13,  
#         so_curr    LIKE oea_file.oea23,    #MOD-B30491 mod
#         so_incltax LIKE oea_file.oea213,   #MOD-B30491 add
#         so_taxrate LIKE oea_file.oea211);  #MOD-B30491 add
#  DELETE FROM p800_file
#MOD-D60237 mark end-----------       
  #讀取符合條件之三角貿易訂單資料
  LET l_sql="SELECT * FROM oea_file ",
            " WHERE oea901='Y' ",
             " AND oea905='",tm.oea905,"' ",
             " AND oeaconf='Y' ",     #已確認之訂單才可轉
###萬一如需重拋訂單時, 請將上行mark即可(dennon lai)
             " AND oea902='N' ",     #非最終訂單
             " AND ",tm.wc CLIPPED    
  PREPARE p800_p1 FROM l_sql 
  IF SQLCA.SQLCODE THEN CALL cl_err('pre1',SQLCA.SQLCODE,1) END IF
  LET g_success='Y' 
  LET l_stu_p_h=' ' #MOD-760026 add
  LET l_stu_o_h=' ' #MOD-760026 add
  DECLARE p800_curs1 CURSOR FOR p800_p1
  CALL s_showmsg_init()                        #No.FUN-710046
  FOREACH p800_curs1 INTO g_oea.*
     IF SQLCA.SQLCODE <> 0 THEN
        LET g_success = 'N'             #No.FUN-8A0086
        EXIT FOREACH
     END IF
 
     IF tm.oea905 = 'N' THEN
        LET l_cnt = 0                                                                                                       
        SELECT count(*) INTO l_cnt
          FROM oea_file,oeb_file
         WHERE oea01 = oeb01 AND oea01 = g_oea.oea01 AND oeb70 = 'Y'
        IF l_cnt > 0 THEN
           CALL s_errmsg("oea01",g_oea.oea01,"SEL oea_file","axd-048",1) 
           LET g_success = 'N'      
           CONTINUE FOREACH   
        END IF
     END IF
 
     IF g_success = "N" THEN                                                                                                        
        LET g_totsuccess = "N"                                                                                                      
        LET g_success = "Y"                                                                                                         
     END IF                                                                                                                         
     #讀取三角貿易流程代碼資料
     SELECT * INTO g_poz.*
       FROM poz_file
      WHERE poz01=g_oea.oea904 AND poz00='1'
     IF SQLCA.sqlcode THEN
         CALL s_errmsg("poz01",g_oea.oea904,"SEL poz_file",SQLCA.sqlcode,1) #No.FUN-710046
         LET g_success = 'N'
         CONTINUE FOREACH   #No.FUN-710046
     END IF
 
     LET g_oea905 = g_oea.oea905
     IF g_poz.pozacti = 'N' THEN 
         CALL s_errmsg('','',g_oea.oea904,"tri-009",1) #No.FUN-710046
         LET g_success = 'N'
         CONTINUE FOREACH       #No.FUN-710046
     END IF
     CALL p800_flow99()                           #No.7963 取得多角序號
     CALL s_mtrade_last_plant(g_oea.oea904) 
           RETURNING p_last,p_last_plant          #取得最後一筆之家數
     #依流程代碼最多6層
           #得到廠商/客戶代碼及database
     LET l_numlast = 0   #TQC-7B0152
     FOR i = 0 TO p_last   
           IF i = 0 THEN CONTINUE FOR END IF   #FUN-670007
           CALL p800_azp(i)    
 
           LET sp_plant = s_poy.poy04                
           CALL s_getlegal(sp_plant) RETURNING sp_legal
 
           LET gp_plant = g_poy.poy04                  
           CALL s_getlegal(gp_plant) RETURNING gp_legal
 
 
           CALL p800_azi(g_oea.oea23)   #讀取幣別資料
           LET l_stu_p_h = ''   #TQC-980224 add         
           LET l_stu_o_h = ''   #TQC-980224 add    
           #針對每一符合條件之訂單轉成該廠之P/O
           #新增採購單單頭檔(pmm_file)
 
            IF g_oax.oax06 ='N' THEN   #非一單到底   #NO.FUN-670007
                LET g_t1 = g_oea.oea01[1, g_doc_len]
                CALL s_mutislip('3','1',g_t1,g_poz.poz01,i)
                RETURNING g_sw,l_oea_t1,l_pmm_t1,l_x,l_x,l_x
                IF g_sw THEN
                    LET g_success = 'N' 
                    EXIT FOREACH 
                END IF
                IF cl_null(l_pmm_t1) THEN
                    CALL cl_err('','apm1010',1) 
                    LET g_success = 'N'
                    EXIT FOREACH
                ELSE                                                                                                                   
                   LET l_cnt = 0                                                                                                       
                   #LET l_sql = "SELECT COUNT(*) FROM ",s_dbs_new,"smy_file ",        #MOD-860168 modify l_dbs_new->s_dbs_new 
                   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(s_plant_new,'smy_file'), #FUN-A50102                     
                               " WHERE smyslip = '",l_pmm_t1,"'"                                                                                  
 	                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql,s_plant_new) RETURNING l_sql #FUN-A50102
                   PREPARE smy_pre1 FROM l_sql                                                                                         
                   EXECUTE smy_pre1 INTO l_cnt                                                                                         
                   IF l_cnt = 0 THEN                                                                                                   
                      LET g_msg = l_dbs_new CLIPPED,l_pmm_t1 CLIPPED                                                                     
                      CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                 
                      LET g_success = 'N'                                                                                              
                      EXIT FOREACH                                                                                                     
                   END IF                                                                                                              
                END IF
                IF cl_null(l_oea_t1) THEN
                    CALL cl_err('','apm1011',1)
                    LET g_success = 'N' 
                    EXIT FOREACH
                ELSE                                                                                                                   
                   LET l_cnt = 0                                                                                                       
                   #LET l_sql = "SELECT COUNT(*) FROM ",l_dbs_new,"oay_file ",  
                   LET l_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant_new,'oay_file'), #FUN-A50102  
                               " WHERE oayslip = '",l_oea_t1,"'"                                                                                   
 	               CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                   CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                   PREPARE oay_pre1 FROM l_sql                                                                                         
                   EXECUTE oay_pre1 INTO l_cnt                                                                                         
                   IF l_cnt = 0 THEN                                                                                                   
                      LET g_msg = l_dbs_new CLIPPED,l_oea_t1 CLIPPED                                                                     
                      CALL cl_err3("","","","",'axm-931',"","g_msg",1)                                                                 
                      LET g_success = 'N'                                                                                              
                      EXIT FOREACH                                                                                                     
                   END IF                                                                                                              
                END IF
            END IF
            IF g_oax.oax06 = 'N' THEN      #非一單到底     #NO.FUN-670007                                                                                      
               CALL s_auto_assign_no("APM",l_pmm_t1,g_oea.oea02,"2","pmm_file","pmm01",s_plant_new,"","")#FUN-980092 add 
                  RETURNING li_result,l_pmm.pmm01                                                                                   
               IF (NOT li_result) THEN                                                                                              
                  LET g_msg = s_plant_new CLIPPED,l_pmm.pmm01                      #TQC-9B0013
                  CALL s_errmsg("pmm01",l_pmm.pmm01,g_msg CLIPPED,"mfg3046",1)     #TQC-9B0013
                  LET g_success = 'N'        #No.TQC-980236
                  EXIT FOR                   #No.FUN-710046                                                                                      
               END IF                                                                                                               
            ELSE                                                                                                                    
               LET l_pmm.pmm01=g_oea.oea01  #一單到底                                                                                        
            END IF                                                                                                                  
            LET l_pmm.pmm02= 'TRI'           #單據性質
            LET l_pmm.pmm03=g_oea.oea06      #更動序號
            LET l_pmm.pmm04=g_oea.oea02      #採購日期???
            LET l_pmm.pmm05=null             #專案號碼
            LET l_pmm.pmm06=null             #預算號碼
            LET l_pmm.pmm07=null             #單據分類
            LET l_pmm.pmm08=null             #PBI 批號
            LET l_pmm.pmm09=p_pmm09          #供應廠商
            LET l_pmm.pmm10=null             #送貨地址BugNo:4364
            LET l_pmm.pmm11=null              #帳單地址
            LET l_pmm.pmm12= g_oea.oea14      #採購員
            LET l_pmm.pmm13= g_oea.oea15      #採購部門
            LET l_pmm.pmm14= ' '              #收貨部門
            LET l_pmm.pmm15= g_user           #確認人
            LET l_pmm.pmm16= g_oea.oea43      #運送方式
            LET l_pmm.pmm17=null              #代理商
            LET l_pmm.pmm18='Y'               #確認碼
            LET l_pmm.pmmud01 = g_oea.oeaud01
            LET l_pmm.pmmud02 = g_oea.oeaud02
            LET l_pmm.pmmud03 = g_oea.oeaud03
            LET l_pmm.pmmud04 = g_oea.oeaud04
            LET l_pmm.pmmud05 = g_oea.oeaud05
            LET l_pmm.pmmud06 = g_oea.oeaud06
            LET l_pmm.pmmud07 = g_oea.oeaud07
            LET l_pmm.pmmud08 = g_oea.oeaud08
            LET l_pmm.pmmud09 = g_oea.oeaud09
            LET l_pmm.pmmud10 = g_oea.oeaud10
            LET l_pmm.pmmud11 = g_oea.oeaud11
            LET l_pmm.pmmud12 = g_oea.oeaud12
            LET l_pmm.pmmud13 = g_oea.oeaud13
            LET l_pmm.pmmud14 = g_oea.oeaud14
            LET l_pmm.pmmud15 = g_oea.oeaud15
            #讀取廠商相關資料
            LET l_sql1 = "SELECT * ",
                         #" FROM ",s_dbs_new CLIPPED,"pmc_file ",
                         " FROM ",cl_get_target_table(s_plant_new,'pmc_file'), #FUN-A50102
                         " WHERE pmc01='",l_pmm.pmm09,"' ",
                         "   AND pmcacti='Y' "
 	        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-A50102
            PREPARE pmc_p1 FROM l_sql1
            IF SQLCA.SQLCODE THEN CALL cl_err('pmm_p1',SQLCA.SQLCODE,1) END IF
            DECLARE pmc_c1 CURSOR FOR pmc_p1
            OPEN pmc_c1
            FETCH pmc_c1 INTO l_pmc.*
            IF SQLCA.SQLCODE=100 THEN
               LET g_msg = s_dbs_new CLIPPED,l_pmm.pmm09 CLIPPED #No.7963  #MOD-7B0224 cancel mark
               CALL s_errmsg('','',g_msg CLIPPED,"mfg3001",1)      #No.FUN-710046
               LET g_success='N'  EXIT FOR
            END IF
            CLOSE pmc_c1
            IF cl_null(l_pmc.pmc49) THEN
               LET g_msg = l_dbs_new CLIPPED,l_pmm.pmm09 CLIPPED   #FUN-670007
               CALL s_errmsg('','',g_msg CLIPPED,"tri-010",1)      #No.FUN-710046
               LET g_success = 'N' EXIT FOR
            END IF
 
            LET l_pmm.pmm20=p_poy06         #付款方式: 
            LET l_pmm.pmm21=p_poy09         #稅別: 
            #因為必須以計價方式來判斷幣別,故先給訂單幣別,單身新增完後再給
            LET l_pmm.pmm22 = g_oea.oea23   #幣別
            LET l_pmm.pmm25= '2'            #狀況碼: '2'(發出採購單)
            LET l_pmm.pmm26=null            #理由碼: null ???
            LET l_pmm.pmm27=null            #狀況異動日期: null 
            LET l_pmm.pmm28=null            #會計分類: null
            LET l_pmm.pmm29=null            #會計科目: null ???
            LET l_pmm.pmm30='N'             #驗收單列印否 : 'N'
            #讀取會計年度, 期間 
            LET l_sql1 = "SELECT azn02,azn04 ",
                         #" FROM ",s_dbs_new CLIPPED,"azn_file ",
                         " FROM ",cl_get_target_table(s_plant_new,'azn_file'), #FUN-A50102
                         " WHERE azn01='",l_pmm.pmm04,"' "
 	        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-A50102
            PREPARE azn_p1 FROM l_sql1
            IF SQLCA.SQLCODE THEN CALL cl_err('pmm_p1',SQLCA.SQLCODE,1) END IF
            DECLARE azn_c1 CURSOR FOR azn_p1
            OPEN azn_c1
            FETCH azn_c1 INTO l_pmm.pmm31,l_pmm.pmm32
            CLOSE azn_c1
            LET l_pmm.pmm40=0                #總金額:  l_tot_pmm40
            LET l_pmm.pmm40t=0               #總金額:  l_tot_pmm40t  #No.FUN-610018
            LET l_pmm.pmm401=0               #代買總金額: 0 
            LET l_pmm.pmm41=l_pmc.pmc49      #價格條件: ???
            LET l_pmm.pmm42=1                #匯率: 在單身結束後再判斷
            #讀取稅別資料
            LET l_sql1 = "SELECT * ",
                         #" FROM ",s_dbs_new CLIPPED,"gec_file ",
                         " FROM ",cl_get_target_table(s_plant_new,'gec_file'), #FUN-A50102
                         " WHERE gec01='",l_pmm.pmm21,"' ",
                         "   AND gec011='1' "    #依進項
 	        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-A50102
            PREPARE gec_p1 FROM l_sql1
            IF SQLCA.SQLCODE THEN CALL cl_err('pmm_p1',SQLCA.SQLCODE,1) END IF
            DECLARE gec_c1 CURSOR FOR gec_p1
            OPEN gec_c1
            FETCH gec_c1 INTO l_gec.*
            IF SQLCA.SQLCODE THEN
               LET g_msg=s_dbs_new CLIPPED,l_pmm.pmm21 CLIPPED  #FUN-6700007 
               CALL s_errmsg('','',g_msg CLIPPED,"mfg3044",1)   #No.FUN-710046
               LET g_success = 'N'
            END IF
            CLOSE gec_c1
            IF l_gec.gec04 IS NULL THEN
               LET l_gec.gec04=0
            END IF
 
            LET l_pmm.pmm43 = l_gec.gec04        #稅率
         #  LET l_pmm.pmm45 ='N'                 #可用/不可用          NO.TQC-650127
            LET l_pmm.pmm44 = '1'                #稅處理:1發票扣抵     NO.TQC-650127 
            LET l_pmm.pmm45 ='Y'                 #可用                 NO.TQC-650127
            LET l_pmm.pmm46 =0                   #預付比率
            LET l_pmm.pmm47 =0                   #預付金額: 
            LET l_pmm.pmm48 =0              #已結帳金額
            LET l_pmm.pmm49='N'             #預付發票否(Y/N) 
            LET l_pmm.pmm99  = g_flow99     #多角序號  No.7963
            LET l_pmm.pmm901 = 'Y'          #多角貿易否 
            IF i = p_last THEN              #最終採購單否
                LET l_pmm.pmm902 = 'Y'
            ELSE
                LET l_pmm.pmm902 = 'N'
            END IF 
            LET l_pmm.pmm904 = g_oea.oea904 #流程代碼
            LET l_pmm.pmm905 = 'Y'          #多角拋轉否
            LET l_pmm.pmm906 = 'N'          #來源單否
            LET l_pmm.pmm909="1"              #No.FUN-630006
            LET l_pmm.pmmprsw='N'           #列印抑制: 'N' or 'Y' 
            LET l_pmm.pmmprno=0             #已列印次數: 0
            LET l_pmm.pmmprdt=null          #最後列印日期:null
            LET l_pmm.pmmmksg='N'           #是否簽核: 'N' ???
            LET l_pmm.pmmsign=null          #簽核等級: null
            LET l_pmm.pmmdays=0             #簽核完成天數: 0
            LET l_pmm.pmmprit=0             #簽核優先等級: 0
            LET l_pmm.pmmsseq=0             #已簽核順序: 0
            LET l_pmm.pmmsmax=0             #應簽核順序: 0
            LET l_pmm.pmmacti='Y'           #資料有效碼: 'Y' 
            LET l_pmm.pmmuser=g_user        #資料所有者: g_user
            LET l_pmm.pmmgrup=g_grup        #資料所有部門: g_grup
            LET l_pmm.pmmmodu=null          #資料修改者: null
            LET l_pmm.pmmdate=null          #最近修改日: null
 
            #判斷幣別
            CALL p800_curr(i,g_oea.oea01,g_oea.oea23) RETURNING l_pmm.pmm22
            CALL p800_azi(l_pmm.pmm22)   #讀取幣別資料
            #pmm42匯率:
            #判斷是否為本幣
             IF l_pmm.pmm22 <> s_aza.aza17 THEN
                #注意database必須為s_azp.azp03
                CALL s_currm(l_pmm.pmm22,l_pmm.pmm04,g_oax.oax01,s_plant_new)   #NO.FUN-980020
                        RETURNING l_pmm.pmm42
             ELSE
                LET l_pmm.pmm42 = 1
             END IF
             IF l_pmm.pmm42 IS NULL THEN LET l_pmm.pmm42=1 END IF
          
           #新增訂單單頭檔(oea_file)(by 下游廠商,即P/O廠商)
           #新增之database為l_dbs_new
            LET l_oea.* = g_oea.*
            
            LET l_oea.oea02=g_oea.oea02     #訂單日期: ???
            LET l_oea.oea03=p_oea03         #帳款客戶編號
            CALL p800_oea03(l_dbs_new,l_oea.oea03) 
                 RETURNING l_occ02,l_occ04,l_occ08,l_occ11,         #NO.FUN-620024 #MOD-B10100 add l_occ04
                           l_occ1005,l_occ1006,l_occ1022            #NO.FUN-620024
 
            IF g_oax.oax06 = 'N' THEN                               #NO.FUN-670007
               CALL s_auto_assign_no("AXM",l_oea_t1,g_oea.oea02,"30","oea_file","oea01",l_plant_new,"","")   #FUN-980092 add
                    RETURNING li_result,l_oea.oea01                                                                                           
               IF (NOT li_result) THEN                                                                                                     
                  LET g_msg = l_plant_new CLIPPED,l_oea.oea01                      #TQC-9B0013
                  CALL s_errmsg("oea01",l_oea.oea01,g_msg CLIPPED,"mfg3046",1)     #TQC-9B0013
                  LET g_success = 'N'   #No.TQC-980236
                  EXIT FOR              #No.FUN-710046                                                                                                   
               END IF
               LET l_oea.oea00 = '1'          #NO.TQC-7C0155
               LET l_oea.oea1002 = p_poy33    #多角貿易流程代碼此站工廠所設置之債權
               LET l_oea.oea1003 = p_poy27    #多角貿易流程代碼此站工廠所設置之業績歸屬方
               LET l_oea.oea1004 = p_poy29    #代送商
               LET l_oea.oea1005 = p_poy26    #是否計算業績
               LET l_oea.oea1006 = 0          #未稅金額
               LET l_oea.oea1007 = 0          #含稅金額
               LET l_oea.oea1008 = 0          #訂單總含稅金額
               LET l_oea.oea1009 = l_occ1006  #客戶所屬渠道
               LET l_oea.oea1010 = l_occ1005  #客戶所屬方
               LET l_oea.oea1011 = l_occ1022  #開票客戶
               LET l_oea.oea1012 = 'N'        #自提否
               LET l_oea.oea1013= 0           #重量                                                                            
               LET l_oea.oea1014= 0           #體積                                               
            ELSE                                                                                                                     
               LET l_oea.oea00 = '1'                                                                                                  
               LET l_oea.oea01 = g_oea.oea01
            END IF
 
            LET l_oea.oea032=l_occ02        #帳款客戶簡稱
            LET l_oea.oea033=l_occ11        #帳款客戶統一編號
            LET l_oea.oea04 =g_oea.oea04    #送貨客戶編號          #NO.FUN-620024  #MOD-710074 cancel mark
            IF cl_null(l_oea.oea04)  THEN                          #NO.FUN-620024  #MOD-710074 cancel mark
               LET l_oea.oea04 =l_oea.oea03
            END IF                                                 #NO.FUN-620024  #MOD-710074 cancel mark
            #-----MOD-A90149---------
            LET l_cnt = 0
            LET l_sql = "SELECT COUNT(*) ",
                        " FROM ",cl_get_target_table(l_plant_new,'occ_file'),  
                        " WHERE occ01 ='",l_oea.oea04,"'",
                        "   AND occacti ='Y'"
 	    CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
            CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
            PREPARE occ_p FROM l_sql
            EXECUTE occ_p INTO l_cnt
            IF l_cnt = 0 THEN
               LET g_msg=l_dbs_new CLIPPED,l_oea.oea04 CLIPPED
               CALL s_errmsg('','',g_msg CLIPPED,"axm_100",1) 
               LET g_success = 'N'
            END IF
            #-----END MOD-A90149-----
            LET l_oea.oea05=p_poy12         #No.7963
            LET l_oea.oea07='N'             #出貨是否計入未開發票的銷貨待驗收入 
            LET l_oea.oea10=g_oea.oea10     #客戶訂單單號(來源) #FUN-5A0105
            LET l_oea.oea11='7'             #訂單來源  7.多角銷售轉入
            #MOD-B10100 add --start--
            LET l_oea.oea14=l_occ04         #負責業務員
            LET l_oea.oea15=''              #部門
            IF NOT cl_null(l_oea.oea14) THEN
               LET l_sql = "SELECT gen03 ",
                           " FROM ",cl_get_target_table(l_plant_new,'gen_file'),
                           " WHERE gen01 ='",l_oea.oea14,"'"
 	       CALL cl_replace_sqldb(l_sql) RETURNING l_sql     
               CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql 
               PREPARE gen_p FROM l_sql
               EXECUTE gen_p INTO l_oea.oea15
               IF cl_null(l_oea.oea15) THEN LET l_oea.oea15='' END IF
            END IF
            #MOD-B10100 add --end--
            LET l_oea.oea17=l_oea.oea03     #收款客戶編號
            LET l_oea.oea20='Y'             #是否直送客戶
            LET l_oea.oea21 = p_poy08       #稅別
            #讀取稅別資料
            LET l_sql1 = "SELECT * ",
                         #" FROM ",l_dbs_new CLIPPED,"gec_file ",
                         " FROM ",cl_get_target_table(l_plant_new,'gec_file'), #FUN-A50102 
                         " WHERE gec01='",l_oea.oea21,"' ",
                         "   AND gec011='2' "    #依進項   
 	        CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
            CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
            PREPARE gec_p2 FROM l_sql1
            IF SQLCA.SQLCODE THEN CALL cl_err('gec_p2',SQLCA.SQLCODE,1) END IF
            DECLARE gec_c2 CURSOR FOR gec_p2
            OPEN gec_c2
            FETCH gec_c2 INTO l_gec.*
            IF SQLCA.SQLCODE THEN
               LET g_msg=l_dbs_new CLIPPED,l_oea.oea21 CLIPPED
               CALL s_errmsg('','',g_msg CLIPPED,"mfg3044",1) #No.FUN-710046
               LET g_success = 'N'
            END IF
            CLOSE gec_c2
            IF l_gec.gec04 IS NULL THEN
               LET l_gec.gec04=0
            END IF
            LET l_oea.oea211 = l_gec.gec04   #稅率
            LET l_oea.oea212 = l_gec.gec05   #聯數
            LET l_oea.oea213 = l_gec.gec07   #含稅否
            LET l_oea.oea23  = l_pmm.pmm22   #幣別
            #判斷是否為本幣
            IF l_oea.oea23 <> l_aza.aza17 THEN
                #注意database必須為l_azp.azp03
               CALL s_currm(l_oea.oea23,l_oea.oea02,g_oax.oax01,l_plant_new) #NO.FUN-980020
                              RETURNING l_oea.oea24
            ELSE
               LET l_oea.oea24=1
            END IF
            IF l_oea.oea24 IS NULL THEN LET l_oea.oea24=1 END IF
            IF cl_null(p_poy10)  THEN
               LET g_success = 'N' 
               LET g_msg=l_dbs_new CLIPPED,l_oea.oea01 CLIPPED
               CALL s_errmsg('','',g_msg CLIPPED,"mfg4100",1)
            END IF 
            LET l_oea.oea25= p_poy10       #No.7963 
            LET l_oea.oea32= p_poy07       #No.7963
            LET l_oea.oea61=0              #訂單總未稅金額
            LET l_oea.oea62=0              #已出貨未稅金額
            LET l_oea.oea63=0              #被結案未稅金額
            LET l_oea.oea72=g_today        #首次確認日
            LET l_oea.oea99=g_flow99       #多角序號 No.7963
            LET l_oea.oea901='Y'           #三角貿易否: 'Y'
            IF i = p_last THEN
               LET l_oea.oea902='Y'        #是否為最終訂單
            ELSE
               LET l_oea.oea902='N'
            END IF
            LET l_oea.oea905='Y'           #拋轉否
            LET l_oea.oea906='N'           #是否為三角貿易之起始訂單
            LET l_oea.oeamksg='N'          #是否簽核
            LET l_oea.oeasign=' '          #簽核等級
            LET l_oea.oeadays=0            #簽核完成天數
            LET l_oea.oeaprit=0            #簽核優先等級
            LET l_oea.oeasseq=0            #已簽人數
            LET l_oea.oeasmax=0            #應簽人數
            LET l_oea.oeaconf='Y'          #確認否
            LET	l_oea.oeaprsw=0            #訂單列印次數
            LET l_oea.oeauser=g_user       #資料所有者
            LET l_oea.oeagrup=g_grup       #資料所有部門
            LET l_oea.oeamodu=null         #資料修改者
            LET l_oea.oeadate=null         #最近修改日
 
           LET l_cnt = 0 
           LET l_sum1 = 0  #NO.FUN-620024  
           LET l_sum2 = 0  #NO.FUN-620024
           LET diff_azi = 'N'
           #讀取訂單單身檔(oeb_file)
           DECLARE  oeb_cus CURSOR FOR
              SELECT *
                FROM oeb_file
               WHERE oeb01 = g_oea.oea01
                 AND oeb1003 = '1'  #TQC-650089
           FOREACH oeb_cus INTO g_oeb.* 
              IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF 
              LET l_cnt=l_cnt+1
              #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
             #IF l_aza.aza50 ='N' THEN   #NO.FUN-620024  #NO.TQC-AC0244   mark 
              IF s_aza.aza50 ='N' THEN   #NO.TQC-AC0244  add
                 IF g_oax.oax08 = "1" THEN
                    CALL s_pox(g_oea.oea904,i,g_oea.oea02)
                      RETURNING p_pox03,p_pox05,p_pox06,p_cnt
                 ELSE
                    CALL s_pox(g_oea.oea904,i,g_oeb.oeb15)
                      RETURNING p_pox03,p_pox05,p_pox06,p_cnt
                 END IF
                 IF p_cnt = 0 THEN
                    LET l_numlast = i CLIPPED,s_dbs_new CLIPPED    #TQC-7B0152
                    CALL s_errmsg('','',l_numlast CLIPPED,"tri-007",1)  #TQC-7B0152
                    LET g_success = 'N'
                    EXIT FOREACH
                 END IF
                 IF l_cnt=1 THEN
                    IF g_oax.oax08 = "1" THEN
                       LET min_oeb15 = g_oea.oea02
                    ELSE
                       LET min_oeb15 = g_oeb.oeb15
                    END IF
                    LET o_pox05 = p_pox05
                 END IF   
                 #判斷單身之計價方式是否有不同 
                 IF o_pox05 <> p_pox05 THEN
                    LET diff_azi='Y'
                 END IF
                 LET o_pox05=p_pox05
                 #記錄最小預計交貨日之計價方式(單頭幣別之依據)
                 IF g_oax.oax08 = "1" THEN
                    IF g_oea.oea02 < min_oeb15 THEN
                       LET min_oeb15 = g_oea.oea02
                       LET azi_pox05 = p_pox05
                    END IF
                 ELSE
                    IF g_oeb.oeb15 < min_oeb15 THEN
                       LET min_oeb15 = g_oeb.oeb15
                       LET azi_pox05 = p_pox05
                    END IF
                 END IF
              END IF   #NO.FUN-620024
              #新增採購單單身檔(pmn_file)
              LET l_pmn.pmn01=l_pmm.pmm01     #採購單號
              LET l_pmn.pmn011=l_pmm.pmm02    #單據性質
              LET l_pmn.pmn02=g_oeb.oeb03     #項次
              LET l_pmn.pmn03=' '             #詢價單號
              LET l_pmn.pmn04=g_oeb.oeb04     #料件編號
              LET l_pmn.pmn041=g_oeb.oeb06    #品名規格
              LET l_pmn.pmn05=' '             #料號使用版本
              LET l_pmn.pmn06=' '             #廠商料件編號
              LET l_pmn.pmn07=g_oeb.oeb05     #採購單位
              LET l_pmn.pmnud01=g_oeb.oebud01
              LET l_pmn.pmnud02=g_oeb.oebud02
              LET l_pmn.pmnud03=g_oeb.oebud03
              LET l_pmn.pmnud04=g_oeb.oebud04
              LET l_pmn.pmnud05=g_oeb.oebud05
              LET l_pmn.pmnud06=g_oeb.oebud06
              LET l_pmn.pmnud07=g_oeb.oebud07
              LET l_pmn.pmnud08=g_oeb.oebud08
              LET l_pmn.pmnud09=g_oeb.oebud09
              LET l_pmn.pmnud10=g_oeb.oebud10
              LET l_pmn.pmnud11=g_oeb.oebud11
              LET l_pmn.pmnud12=g_oeb.oebud12
              LET l_pmn.pmnud13=g_oeb.oebud13
              LET l_pmn.pmnud14=g_oeb.oebud14
              LET l_pmn.pmnud15=g_oeb.oebud15
              #讀取料件基本資料
              LET l_sql1 = "SELECT * ",
                           #" FROM ",s_dbs_new CLIPPED,"ima_file ",   #No.MOD-5C0064   #FUN-670007
                           " FROM ",cl_get_target_table(s_plant_new,'ima_file'), #FUN-A50102
                           " WHERE ima01='",l_pmn.pmn04,"' " 
 	          CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
              CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-A50102
              PREPARE ima_p1 FROM l_sql1
              IF SQLCA.SQLCODE THEN CALL cl_err('pmn_p1',SQLCA.SQLCODE,1) END IF
              DECLARE ima_c1 CURSOR FOR ima_p1
              OPEN ima_c1
              FETCH ima_c1 INTO l_ima.*
              IF SQLCA.SQLCODE THEN
                 LET g_msg=s_dbs_new CLIPPED,l_pmn.pmn04 CLIPPED   #No.MOD-5C0064  #MOD-7B0224 
                 CALL s_errmsg('','',g_msg CLIPPED,"mfg3403",1)    #No.FUN-710046
                 LET g_success = 'N'
              END IF
              CLOSE ima_c1
              LET l_pmn.pmn08=l_ima.ima25    #庫存單位
              IF l_pmn.pmn08 IS NULL OR l_pmn.pmn08=' ' THEN
                 LET l_pmn.pmn08 = l_pmn.pmn07
              END IF
              #轉換因子: 
              IF l_pmn.pmn04[1,4] = 'MISC'  OR l_pmn.pmn07 = l_pmn.pmn08 THEN
                 LET l_pmn.pmn09=1
              ELSE
                 CALL s_umfchkm(l_pmn.pmn04,l_pmn.pmn07,l_pmn.pmn08,s_plant_new)#FUN-980020
                              RETURNING g_sw,l_pmn.pmn09
              END IF
              IF l_pmn.pmn09 IS NULL THEN
                 LET l_pmn.pmn09 = 1
              END IF
              LET l_pmn.pmn10= null             #BUGNo:4757 pmn10改為NO USE
              LET l_pmn.pmn11='N'               #凍結碼
              LET l_pmn.pmn121=1                #轉換因子: 1
              LET l_pmn.pmn122=null             #No use: null
              IF s_dbs_new = t_dbs THEN
                  LET l_pmn.pmn122=g_oea.oea46      #NO.FUN-660068
              ELSE
                  LET l_pmn.pmn122 = NULL
              END IF
              LET l_pmn.pmn123=null             #廠牌: null
              LET l_pmn.pmn13=0                 #超/短交限率
              LET l_pmn.pmn14=g_sma.sma886[1,1] #部份交貨(Y/N)
              LET l_pmn.pmn15=g_sma.sma886[2,2] #提前交貨(Y/N)
              LET l_pmn.pmn16=l_pmm.pmm25       #狀況碼 同單頭
              LET l_pmn.pmn18=null
              LET l_pmn.pmn20=g_oeb.oeb12       #採購量
              LET l_pmn.pmn23=' '               #送貨地址
              LET l_pmn.pmn24=g_oea.oea01       #請購單號
              LET l_pmn.pmn25=g_oeb.oeb03       #請購單號項次
              LET l_pmn.pmn30=g_oeb.oeb13*g_oea.oea24  #標準價格: (S/O本幣)
              LET l_pmn.pmn80=g_oeb.oeb910
              LET l_pmn.pmn81=g_oeb.oeb911
              LET l_pmn.pmn82=g_oeb.oeb912
              LET l_pmn.pmn83=g_oeb.oeb913
              LET l_pmn.pmn84=g_oeb.oeb914
              LET l_pmn.pmn85=g_oeb.oeb915
              LET l_pmn.pmn86=g_oeb.oeb916
              LET l_pmn.pmn87=g_oeb.oeb917
              LET l_pmn.pmn919=g_oeb.oeb919  #FUN-A80102
              IF s_aza.aza50 = 'Y' THEN     #MOD-9C0287
                 IF l_sma.sma116 MATCHES '[23]' THEN
                    LET l_unit = l_pmn.pmn86
                 ELSE
                    LET l_unit = l_pmn.pmn07
                 END IF
                  CALL s_fetch_price2(g_poy.poy03,l_pmn.pmn04,l_unit,l_pmm.pmm04,'4',s_plant_new,l_pmm.pmm22)  #No.TQC-680107  #FUN-670007 #No.FUN-980059 
                      RETURNING l_x,l_pmn.pmn31,p_success
                 IF p_success = 'N' AND  i <> p_last THEN    #TQC-680107
                    CALL s_errmsg('','',"p_success","axm-043",1) #No.FUN-710046
                 END IF
                 IF l_pmn.pmn86 IS NULL THEN
                    LET l_pmn.pmn87 = l_pmn.pmn20
                 END IF
              ELSE   
              #單價: 
              #先判斷訂單單身的價格是含稅單價還是未稅單價，如果是含稅單價轉成未稅單價
              IF g_oea.oea213 = 'Y' THEN
                 LET g_oeb13_h = g_oeb.oeb13   #MOD-B80172  #記錄含稅單價以便下面計算訂單的含稅單價、含税金额、未稅單價、未稅金額
                 LET g_oeb.oeb13 = g_oeb.oeb13/(1+ g_oea.oea211/100)
                 IF cl_null(l_azi.azi03) THEN LET l_azi.azi03=5 END IF
                 CALL cl_digcut(g_oeb.oeb13,l_azi.azi03) 
                      RETURNING g_oeb.oeb13
              END IF
              #計價方式來判斷
                 CASE p_pox05
                    WHEN '1'
                       IF p_pox03='1' THEN   #依來源工廠 
                         #單價*比率
                          IF g_oea.oea23 = l_oea.oea23 THEN
                             #MOD-B80172 BEGIN-------------------
                             IF g_oea.oea213 = 'Y' THEN #MOD-B80172
                                LET l_pmn.pmn31t = g_oeb13_h * p_pox06/100 #MOD-B80172 先計算出含稅單價
                             ELSE 
                             #MOD-B80172 END----------------------
                                LET l_pmn.pmn31 = g_oeb.oeb13 * p_pox06/100
                             END IF  #MOD-B80172
                          END IF
                          IF g_oea.oea23 <> l_oea.oea23 THEN
                             #MOD-B80172 BEGIN-------------------
                             IF g_oea.oea213 = 'Y' THEN
                                LET l_price = g_oeb13_h * g_oea.oea24            #用含稅單價做匯率轉換
                             ELSE
                             #MOD-B80172 END----------------------
                                LET l_price = g_oeb.oeb13 * g_oea.oea24 #先換算本幣
                             END IF  #MOD-B80172  
                             ##以來源廠的匯率計算 no:3463
                             CALL s_currm(l_pmm.pmm22,l_oea.oea02,
                                          g_oax.oax01,t_plant) #No.FUN-980020
                                    RETURNING l_currm
                             #MOD-B80172 BEGIN-------------------
                             IF g_oea.oea213 = 'Y' THEN
                                LET l_pmn.pmn31t= l_price /l_currm * p_pox06/100 #MOD-B80172 先計算出含稅單價
                             ELSE
                             #MOD-B80172 END----------------------
                                LET l_pmn.pmn31= l_price /l_currm * p_pox06/100 
                             END IF  #MOD-B80172  
                          END IF 
                          IF cl_null(l_azi.azi03) THEN 
                             LET l_azi.azi03=5
                          END IF
                          #MOD-B80172 mark begin-----------------
                          #CALL cl_digcut(l_pmn.pmn31,l_azi.azi03) 
                          #       RETURNING l_pmn.pmn31
                          #MOD-B80172 mark end ------------------
                          LET l_taxrate = g_oea.oea211 ##MOD-B80172 add
                       ELSE
                          #依上游廠商計算, 先讀取S/O價格
                          IF i=1 THEN
                             #單價*比率
                            IF g_oea.oea23 = l_oea.oea23 THEN
                               #MOD-B80172 BEGIN-------------------
                               IF g_oea.oea213 = 'Y' THEN
                                  LET l_pmn.pmn31t = g_oeb13_h * p_pox06/100 #MOD-B80172 先計算出含稅單價
                               ELSE
                               #MOD-B80172 END----------------------
                                  LET l_pmn.pmn31 = g_oeb.oeb13 * p_pox06/100
                               END IF  #MOD-B80172 
                            END IF
                            IF g_oea.oea23 <> l_oea.oea23 THEN
                               #MOD-B80172 BEGIN-------------------
                               IF g_oea.oea213 = 'Y' THEN
                                  LET l_price = g_oeb13_h * g_oea.oea24            #MOD-B80172 用含稅單價做匯率轉換
                               ELSE
                               #MOD-B80172 END----------------------
                                  LET l_price = g_oeb.oeb13 * g_oea.oea24 #先換算本幣
                               END IF  #MOD-B80172
                               ##以來源廠的匯率計算  #no:3463
                               CALL s_currm(l_pmm.pmm22,l_oea.oea02,
                                            g_oax.oax01,t_plant) RETURNING l_currm  #NO.FUN-980020
                               #MOD-B80172 BEGIN-------------------
                               IF g_oea.oea213 = 'Y' THEN
                                  LET l_pmn.pmn31t= l_price /l_currm * p_pox06/100 #MOD-B80172 先計算出含稅單價
                               ELSE
                               #MOD-B80172 END----------------------
                                  LET l_pmn.pmn31= l_price/l_currm * p_pox06/100
                               END IF  #MOD-B80172
                            END IF
                          ELSE
                             LET l_no = i-1
                            #SELECT so_price,so_curr INTO l_price,l_curr #MOD-B30491 mark
                             SELECT so_price,so_curr,so_incltax,so_taxrate INTO l_price,l_curr,l_incltax,l_taxrate #MOD-B30491
                               FROM p800_file
                              WHERE p_no = l_no
                                AND so_no = g_oea.oea01
                                AND so_item=g_oeb.oeb03
                             #MOD-B30491 add --start--
                             IF l_incltax = 'Y' THEN
                                LET l_price = l_price  #MOD-B80172
                             ELSE  #MOD-B80172
                                LET l_price = l_price/(1+ l_taxrate/100)
                                #MOD-B80172 BEGIN-------------------
                                #IF cl_null(l_azi.azi03) THEN LET l_azi.azi03=5 END IF
                                #CALL cl_digcut(l_price,l_azi.azi03) 
                                #     RETURNING l_price
                                #MOD-B80172 END----------------------
                             END IF
                             #MOD-B80172 BEGIN-------------------
                             IF cl_null(l_azi.azi03) THEN LET l_azi.azi03=5 END IF
                             CALL cl_digcut(l_price,l_azi.azi03) 
                                    RETURNING l_price
                             #MOD-B80172 END----------------------
                             #MOD-B30491 add --end--
                             IF l_curr != l_pmm.pmm22 THEN
                                CALL s_currm(l_curr,l_oea.oea02,g_oax.oax01,t_plant)   #NO.FUN-980020
                                         RETURNING l_currm
                                LET l_price = l_price * l_currm   #換算成本幣
                                #以來源廠的匯率來計算 no:3463
                                CALL s_currm(l_pmm.pmm22,l_oea.oea02,g_oax.oax01,    #NO.FUN-670007
                                   t_plant) RETURNING l_currm                        #FUN-980020
                                #MOD-B80172 BEGIN-------------------
                                IF l_incltax = 'Y' THEN
                                   LET l_pmn.pmn31t = l_price / l_currm * p_pox06/100  #MOD-B80172 先計算出含稅單價
                                ELSE
                                #MOD-B80172 END----------------------
                                   LET l_pmn.pmn31 = l_price / l_currm
                                                               * p_pox06/100
                                END IF  #MOD-B80172      
                             ELSE
                                #單價*比率
                                #MOD-B80172 BEGIN-------------------
                                IF l_incltax = 'Y' THEN
                                   LET l_pmn.pmn31t = l_price * p_pox06/100   #MOD-B80172 先計算出含稅單價
                                ELSE
                                #MOD-B80172 END----------------------
                                   LET l_pmn.pmn31= l_price * p_pox06/100
                                END IF  #MOD-B80172
                             END IF
                           END IF  
                       END IF
                       #MOD-B80172 mark begin ------------------
                       #   CALL cl_digcut(l_pmn.pmn31,l_azi.azi03) 
                       #             RETURNING l_pmn.pmn31
                       #MOD-B80172 mark end --------------------
                       #MOD-B80172 begin------------------
                       IF l_incltax = 'Y' OR g_oea.oea213 = 'Y' THEN   
                          CALL cl_digcut(l_pmn.pmn31t,l_azi.azi03)
                                RETURNING l_pmn.pmn31t
                          LET l_pmn.pmn88t = l_pmn.pmn31t * l_pmn.pmn87
                          #LET l_pmn.pmn88 = l_pmn.pmn88t/(1+l_taxrate/100) #TQC-D40030 mark
                          LET l_pmn.pmn88 = l_pmn.pmn88t/(1+l_pmm.pmm43/100) #TQC-D40030 add                         
                          LET l_pmn.pmn31 = l_pmn.pmn88/l_pmn.pmn87
                          CALL cl_digcut(l_pmn.pmn31,l_azi.azi03)
                                RETURNING l_pmn.pmn31
                       ELSE
                          CALL cl_digcut(l_pmn.pmn31,l_azi.azi03)
                                RETURNING l_pmn.pmn31
                          LET l_pmn.pmn88 = l_pmn.pmn31 * l_pmn.pmn87
                          #LET l_pmn.pmn88t = l_pmn.pmn88 * (1+l_taxrate/100) #TQC-D40030 mark
                          LET l_pmn.pmn88t = l_pmn.pmn88*(1+l_pmm.pmm43/100) #TQC-D40030 add
                          LET l_pmn.pmn31t = l_pmn.pmn88t/l_pmn.pmn87
                          CALL cl_digcut(l_pmn.pmn31t,l_azi.azi03)
                                RETURNING l_pmn.pmn31t
                       END IF
                       #MOD-B80172 end--------------------
                    WHEN '2'
                       #讀取合乎料件條件之價格
                       IF g_oax.oax08 = "1" THEN
                          CALL s_pow(g_oea.oea904,g_oeb.oeb04,p_poy04,g_oea.oea02)
                                 RETURNING g_sw,l_pmn.pmn31
                       ELSE
                          CALL s_pow(g_oea.oea904,g_oeb.oeb04,p_poy04,g_oeb.oeb15)
                                 RETURNING g_sw,l_pmn.pmn31
                       END IF
                        IF g_sw='N' THEN
                           IF g_oax.oax02 = 'N' THEN    #不允許訂單取不到單價   #NO.FUN-670007
                              CALL s_errmsg('','',"SEL pow:","axm-333",1) #No.FUN-710046
                              LET g_success = 'N'
                           END IF
                           LET l_pmn.pmn31 =0 
                        ELSE
                            IF g_oax.oax02 = 'N' AND l_pmn.pmn31 = 0 THEN  
                               CALL s_errmsg('','',"SEL pow:","mfg3523",1) 
                               LET g_success = 'N'
                            END IF
                        END IF
                    WHEN '3'   #單價若為0, 則給0, 否則抓料件之固定價格
                        IF g_oeb.oeb13 <> 0 THEN
                           IF g_oax.oax08 = "1" THEN
                              CALL s_pow(g_oea.oea904,g_oeb.oeb04,p_poy04,g_oea.oea02)
                                 RETURNING g_sw,l_pmn.pmn31
                           ELSE
                              CALL s_pow(g_oea.oea904,g_oeb.oeb04,p_poy04,g_oeb.oeb15)
                                 RETURNING g_sw,l_pmn.pmn31
                           END IF
                           IF g_sw='N' THEN
                              IF g_oax.oax02 = 'N' THEN   #NO.FUN-670007
                                 CALL s_errmsg('','',"SEL pow:","axm-333",1) #No.FUN-710046
                                 LET g_success = 'N'
                              END IF
                              LET l_pmn.pmn31 = 0
                           ELSE
                              IF g_oax.oax02 = 'N' AND l_pmn.pmn31 = 0 THEN  
                                 CALL s_errmsg('','',"SEL pow:","mfg3523",1) 
                                 LET g_success = 'N'
                              END IF
                           END IF
                        ELSE
                           LET l_pmn.pmn31 = 0
                        END IF
                 END CASE
              END IF                #NO.FUN-620024
              IF l_pmn.pmn31 IS NULL THEN LET l_pmn.pmn31 =0 END IF
              LET l_pmn.pmn31t=l_pmn.pmn31 * (1+l_pmm.pmm43/100) #no.7259
              CALL cl_digcut(l_pmn.pmn31t,l_azi.azi03) RETURNING l_pmn.pmn31t #MOD-780143 add
              LET l_pmn.pmn32=null
              LET l_pmn.pmn33=g_oeb.oeb15    #原始交貨日期
              LET l_pmn.pmn34=g_oeb.oeb15    #原始到廠日期
              LET l_pmn.pmn35=g_oeb.oeb15    #原始到庫日期
              LET l_pmn.pmn36=g_oeb.oeb15    #最近確認交貨日期
              LET l_pmn.pmn37=null           #最後一次到廠日期
              LET l_pmn.pmn38=l_pmm.pmm45    #可用/不可用  #MOD-830134-modify  #FUN-670007
              LET l_pmn.pmn40=null           #會計科目
              LET l_pmn.pmn41=null           #工單號碼
              LET l_pmn.pmn42='0'            #替代碼 
              LET l_pmn.pmn43=0              #作業序號
              LET l_pmn.pmn431=0             #下一站作業序號
              LET l_pmn.pmn44=l_pmn.pmn31 * l_pmm.pmm42  #本幣單價=單價*匯率 
                  CALL cl_digcut(l_pmn.pmn44,s_azi.azi03) 
                                 RETURNING l_pmn.pmn44
              LET l_pmn.pmn45=null           #NO:7190
              LET l_pmn.pmn46=null           #No Use
              LET l_pmn.pmn50=0              #交貨量
              LET l_pmn.pmn51=0              #在驗量
              LET l_pmn.pmn52=null           #倉庫
              LET l_pmn.pmn53=0              #入庫量
              LET l_pmn.pmn54=null           #儲位
              LET l_pmn.pmn55=0              #驗退量
             #IF g_sma.sma96 = 'Y' THEN      #FUN-C80001 #FUN-D30099 mark
              IF g_pod.pod08 = 'Y' THEN      #FUN-D30099
                 LET l_pmn.pmn56=g_oeb.oeb092 #FUN-C80001
              ELSE                           #FUN-C80001
                 LET l_pmn.pmn56=' '            #批號
              END IF                         #FUN-C80001
              LET l_pmn.pmn57=0              #超短交量
              LET l_pmn.pmn58=0              #倉退量
              LET l_pmn.pmn59=null           #退貨單號
              LET l_pmn.pmn60=null           #項次
              LET l_pmn.pmn61=l_pmn.pmn04    #被替代料號
              LET l_pmn.pmn62=1              #替代率
              LET l_pmn.pmn63='N'            #急料否
              LET l_pmn.pmn64='N'            #保稅否
              LET l_pmn.pmn65='1'            #代買性質
 
              #LET l_pmn.pmn88=l_pmn.pmn87*l_pmn.pmn31  #TQC-D40030 mark
              #LET l_pmn.pmn88t=l_pmn.pmn87*l_pmn.pmn31t #TQC-D40030 mark
              #TQC-D40030 add begin
              IF cl_null(l_pmn.pmn88) THEN 
                 LET l_pmn.pmn88=l_pmn.pmn87*l_pmn.pmn31
              END IF 
              IF cl_null(l_pmn.pmn88t) THEN 
                 LET l_pmn.pmn88t=l_pmn.pmn87*l_pmn.pmn31t
              END IF 
              #TQC-D40030 add end              
              CALL cl_digcut(l_pmn.pmn88,l_azi.azi04) RETURNING l_pmn.pmn88
              CALL cl_digcut(l_pmn.pmn88t,l_azi.azi04) RETURNING l_pmn.pmn88t
 
#--各站抓apmi000設定的採購成本中心--
              SELECT poy46 INTO l_pmn.pmn930
                FROM poy_file
               WHERE poy01 = g_poz.poz01
                 AND poy02 = i 
              LET l_pmn.pmn90 = l_pmn.pmn31     #NO.TQC-740104
              LET l_pmn.pmn89 = 'N'             #NO.FUN-940083 add
 
              #新增採購單身檔
              #CALL p800_iou(g_oea.oea99,tm.oea905,s_dbs_new,'pmm')  #NO.FUN-620024
              #CALL p800_iou(g_oea.oea99,tm.oea905,s_dbs_new,'pmm_file') #FUN-A50102 #MOD-B30176 mark
              CALL p800_iou(g_oea.oea99,tm.oea905,s_plant_new,'pmm_file') #MOD-B30176 
                 RETURNING l_stu_p                                  #NO.FUN-620024
              IF NOT cl_null(g_oea.oea99) THEN   #MOD-760123 add
               LET l_sql2 = "SELECT pmm01 ",                               
                            #" FROM ",s_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 add
                            " FROM ",cl_get_target_table(s_plant_new,'pmm_file'), #FUN-A50102
                            " WHERE pmm99= '",g_oea.oea99,"'"                   
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
              CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
               PREPARE pmm_p2 FROM l_sql2                                  
               IF SQLCA.SQLCODE THEN 
                  CALL cl_err('pmm_p1',SQLCA.sqlcode,1) 
               END IF
               DECLARE pmm_c2 CURSOR FOR pmm_p2                            
               OPEN pmm_c2                                                 
               FETCH pmm_c2 INTO l_pmn.pmn01                               
               CLOSE pmm_c2
              END IF                            #MOD-760123 add
              IF cl_null(l_stu_p_h) THEN LET l_stu_p_h=l_stu_p END IF  #MOD-760026 add
              IF l_stu_p ='U' THEN LET l_stu_p_h='U' END IF            #MOD-780046 add
              IF l_stu_p='I' THEN                                   #NO.FUN-620024
                 IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF   #TQC-790002 add
                 #LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"pmn_file",  #FUN-980092 add
                 LET l_sql2="INSERT INTO ",cl_get_target_table(s_plant_new,'pmn_file'), #FUN-A50102 
                  "(pmn01 ,pmn011 ,pmn02 ,pmn03,",
                  " pmn04 ,pmn041 ,pmn05 ,pmn06 ,",
                  " pmn07 ,pmn08 ,pmn09 , pmn10,",
                  " pmn11 ,pmn121 ,pmn122 ,pmn123 ,",
                  " pmn13 ,pmn14 ,pmn15 ,pmn16 ,",
                  " pmn18 ,pmn20 ,pmn23 ,pmn24,",
                  " pmn25 ,pmn30 ,pmn31 ,pmn32 ,",
                  " pmn33 ,pmn34 ,pmn35 ,pmn36,",
                  " pmn37 ,pmn38 ,pmn40 ,pmn41,",
                  " pmn42 ,pmn43 ,pmn431 ,pmn44,",
                  " pmn45 ,pmn46 ,pmn50 ,pmn51,",
                  " pmn52 ,pmn53 ,pmn54 ,pmn55,",
                  " pmn56 ,pmn57 ,pmn58 ,pmn59,",
                  " pmn60 ,pmn61 ,pmn62 ,pmn63,",
                  " pmn64 ,pmn65 ,pmn31t,",   #FUN-560043  
                  " pmn80,pmn81,pmn82,pmn83,pmn84,pmn85,pmn86,pmn87,pmn930,pmn88,pmn88t," ,   #FUN-560043  #NO.FUN-670007 add pmn930   #No.TQC-6A0084
                  " pmn90,pmn89,pmn919, ",   #NO.TQC-740104 #FUN-940083 add pmn89  #FUN-A80102
                  " pmnplant,pmnlegal , ",
                  " pmnud01,pmnud02,pmnud03,pmnud04,pmnud05,",
                  " pmnud06,pmnud07,pmnud08,pmnud09,pmnud10,",
                  " pmnud11,pmnud12,pmnud13,pmnud14,pmnud15 )",
                  " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                  "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                  "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                  "         ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,", #CHI-950020  #FUN-A80102
                  "         ?,?,?,?, ?,?,?,?, ?,?,?, ?,?,?,?,?,?,?,?,?,?,?,?,?,",   #FUN-560043  #No.TQC-6A0084 #FUN-940083
                  "         ?,?) "             #FUN-980010
 	             CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                 CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-A50102
                 PREPARE ins_pmn FROM l_sql2
                 EXECUTE ins_pmn USING 
                   l_pmn.pmn01 ,l_pmn.pmn011 ,l_pmn.pmn02 ,l_pmn.pmn03,
                   l_pmn.pmn04 ,l_pmn.pmn041 ,l_pmn.pmn05 ,l_pmn.pmn06 ,
                   l_pmn.pmn07 ,l_pmn.pmn08 ,l_pmn.pmn09 , l_pmn.pmn10,
                   l_pmn.pmn11 ,l_pmn.pmn121 ,l_pmn.pmn122 ,l_pmn.pmn123 ,
                   l_pmn.pmn13 ,l_pmn.pmn14 ,l_pmn.pmn15 ,l_pmn.pmn16 ,
                   l_pmn.pmn18 ,l_pmn.pmn20 ,l_pmn.pmn23 ,l_pmn.pmn24,
                   l_pmn.pmn25 ,l_pmn.pmn30 ,l_pmn.pmn31 ,l_pmn.pmn32 ,
                   l_pmn.pmn33 ,l_pmn.pmn34 ,l_pmn.pmn35 ,l_pmn.pmn36,
                   l_pmn.pmn37 ,l_pmn.pmn38 ,l_pmn.pmn40 ,l_pmn.pmn41,
                   l_pmn.pmn42 ,l_pmn.pmn43 ,l_pmn.pmn431 ,l_pmn.pmn44,
                   l_pmn.pmn45 ,l_pmn.pmn46 ,l_pmn.pmn50 ,l_pmn.pmn51,
                   l_pmn.pmn52 ,l_pmn.pmn53 ,l_pmn.pmn54 ,l_pmn.pmn55,
                   l_pmn.pmn56 ,l_pmn.pmn57 ,l_pmn.pmn58 ,l_pmn.pmn59,
                   l_pmn.pmn60 ,l_pmn.pmn61 ,l_pmn.pmn62 ,l_pmn.pmn63,
                   l_pmn.pmn64 ,l_pmn.pmn65 ,
                   l_pmn.pmn31t,  #no.7259
                   l_pmn.pmn80 ,l_pmn.pmn81 ,l_pmn.pmn82 ,l_pmn.pmn83,   #FUN-560043
                   l_pmn.pmn84 ,l_pmn.pmn85 ,l_pmn.pmn86 ,l_pmn.pmn87,   #FUN-560043
                   l_pmn.pmn930,l_pmn.pmn88 ,l_pmn.pmn88t,    #NO.FUN-670007 #No.TQC-6A0084
                   l_pmn.pmn90,l_pmn.pmn89,l_pmn.pmn919,  #NO.TQC-740104  #FUN-940083 add pmn89  #FUN-A80102
                   sp_plant,sp_legal   #FUN-980010
                  ,l_pmn.pmnud01,l_pmn.pmnud02,l_pmn.pmnud03,l_pmn.pmnud04,l_pmn.pmnud05,
                   l_pmn.pmnud06,l_pmn.pmnud07,l_pmn.pmnud08,l_pmn.pmnud09,l_pmn.pmnud10,     
                   l_pmn.pmnud11,l_pmn.pmnud12,l_pmn.pmnud13,l_pmn.pmnud14,l_pmn.pmnud15
 
                   IF SQLCA.sqlcode<>0 THEN
                      CALL s_errmsg('','',"INS pmn",SQLCA.sqlcode,1) #No.FUN-710046
                      LET g_success = 'N'
                   ELSE
                      IF NOT s_industry('std') THEN
                         INITIALIZE l_pmni.* TO NULL
                         LET l_pmni.pmni01 = l_pmn.pmn01
                         LET l_pmni.pmni02 = l_pmn.pmn02
                      #CHI-C80009---add---START
                         DECLARE  oebi_cus CURSOR FOR
                           SELECT * FROM oebi_file
                             WHERE oebi01 = g_oeb.oeb01
                               AND oebi03 = g_oeb.oeb03
                         FOREACH oebi_cus INTO g_oebi.*
                           IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF
                         END FOREACH
                         LET l_pmni.pmniicd14 = g_oebi.oebiicd01  #內編母體料號
                      #CHI-C80009---add-----END
                         IF NOT s_ins_pmni(l_pmni.*,s_plant_new) THEN     #FUN-980092 add
                            LET g_success='N'                                                                      #NO.FUN-710026
                         END IF
                      END IF
                   END IF
              #重新拋轉時,只針對訂單變更的欄位更新
              ELSE
                IF l_stu_p='U' THEN
                   IF g_oax.oax06 ='N' THEN                              #NO.FUN-670007            
                      LET l_sql2 = "SELECT pmm01 ",                               
                                   #" FROM ",s_dbs_tra CLIPPED,"pmm_file ",  #FUN-980092 add 
                                   " FROM ",cl_get_target_table(s_plant_new,'pmm_file'), #FUN-A50102   
                                   " WHERE pmm99= '",g_oea.oea99,"'"                   
 	                  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
                      PREPARE pmm_p1 FROM l_sql2                                  
                      IF SQLCA.SQLCODE THEN 
                         CALL s_errmsg('','',"pmn_p1",SQLCA.sqlcode,0) #No.FUN-710046
                      END IF
                      DECLARE pmm_c1 CURSOR FOR pmm_p1                            
                      OPEN pmm_c1                                                 
                      FETCH pmm_c1 INTO l_pmn.pmn01                               
                      CLOSE pmm_c1
                   END IF
                     #更新採購單身檔
                     #LET l_sql2="UPDATE ",s_dbs_tra CLIPPED,"pmn_file",   #FUN-980092 add
                     LET l_sql2="UPDATE ",cl_get_target_table(s_plant_new,'pmn_file'), #FUN-A50102   
                      " SET pmn04 = ?,pmn041 = ?,pmn07 = ?,", 
                      "     pmn08 = ?,pmn09  = ?,pmn20 = ?,",
                      "     pmn31 = ?,pmn33  = ?,pmn34 = ?,",
                      "     pmn35 = ?,pmn36  = ?,pmn44 = ?,",
                      "     pmn31t= ?,pmn80  = ?,pmn81 = ?,",   #FUN-560043
                      "     pmn82 = ?,pmn83  = ?,pmn84 = ?,",   #FUN-560043
                      "     pmn85 = ?,pmn86  = ?,pmn87 = ?, ",   #FUN-560043  #NO.MOD-740222 少了一個,
                      "     pmn88 = ?,pmn88t = ? ",   #FUN-560043  #No.TQC-6A0084
                      " WHERE pmn01=? AND pmn02=? "   
 	                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
                     PREPARE upd_pmn FROM l_sql2
                     EXECUTE upd_pmn USING 
                       l_pmn.pmn04 ,l_pmn.pmn041,l_pmn.pmn07 ,l_pmn.pmn08,
                       l_pmn.pmn09 ,l_pmn.pmn20 ,l_pmn.pmn31 ,l_pmn.pmn33 ,
                       l_pmn.pmn34 ,l_pmn.pmn35 ,l_pmn.pmn36 ,l_pmn.pmn44,
                       l_pmn.pmn31t,l_pmn.pmn80,l_pmn.pmn81,l_pmn.pmn82,   #FUN-560043
                       l_pmn.pmn83,l_pmn.pmn84,l_pmn.pmn85,l_pmn.pmn86,    #FUN-560043
                       l_pmn.pmn87,l_pmn.pmn88,l_pmn.pmn88t,   #FUN-560043  #No.TQC-6A0084
                       l_pmn.pmn01 ,l_pmn.pmn02
                     IF SQLCA.sqlcode THEN
                         CALL s_errmsg('','',"UPD pmn:",SQLCA.sqlcode,1) #No.FUN-710046 
                         LET g_success = 'N'
                     END IF
                ELSE                                       #NO.FUN-620024
                   IF l_stu_p='F' THEN                     #NO.FUN-620024     
                      CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1)           #No.FUN-710046
                      LET g_success = 'N'                  #NO.FUN-620024     
                   END IF                                  #NO.FUN-620024
                END IF
              END IF         #NO.FUN-620024
              #採購單頭總金額
              #LET l_pmm.pmm40 = l_pmm.pmm40 + l_pmn.pmn31*l_pmn.pmn87  #No.TQC-6A0084  #TQC-D40030 mark
              #LET l_pmm.pmm40t= l_pmm.pmm40t+ l_pmn.pmn31t*l_pmn.pmn87  #No.FUN-610018  #No.TQC-6A0084  #TQC-D40030 mark
              #TQC-D40030 add begin
              #用單價*數量,容易造成尾差
              LET l_pmm.pmm40 = l_pmm.pmm40 + l_pmn.pmn88
              LET l_pmm.pmm40t= l_pmm.pmm40t + l_pmn.pmn88t
              #TQC-D40030 add end              
                   CALL cl_digcut(l_pmm.pmm40,l_azi.azi04)  #NO.MOD-590239
                                 RETURNING l_pmm.pmm40
                   CALL cl_digcut(l_pmm.pmm40t,l_azi.azi04)  #No.FUN-610018
                                 RETURNING l_pmm.pmm40t
 
               #新增訂單單身檔(oeb_file)(by 下游廠商,即P/O廠商)
               LET l_oeb.* = g_oeb.*
               LET l_oeb.oeb08 =null    #出貨工廠
               LET l_oeb.oeb09 =g_poy.poy11          #NO.FUN-620024
               LET l_oeb.oeb091=null    #出貨儲位
              #IF g_sma.sma96 = 'Y' THEN         #FUN-C80001 #FUN-D30099 mark
               IF g_pod.pod08 = 'Y' THEN         #FUN-D30099
                  LET l_oeb.oeb092=g_oeb.oeb092  #FUN-C80001
               ELSE                              #FUN-C80001
                  LET l_oeb.oeb092=null    #出貨批號
               END IF                            #FUN-C80001
               IF l_oea.oea213 = 'N' THEN
                  LET l_oeb.oeb13=l_pmn.pmn31
               ELSE
                  LET l_oeb.oeb13=l_pmn.pmn31t
               END IF
               LET l_oeb.oeb17=l_oeb.oeb13     #no.7150
               #未稅金額/含稅金額 : oeb14/oeb14t
 
               IF l_oea.oea213 = 'N' THEN                  #NO.FUN-620024
                  LET l_oeb.oeb14=l_oeb.oeb917*l_oeb.oeb13  #NO.FUN-620024  #No.TQC-6A0084
                  CALL cl_digcut(l_oeb.oeb14,l_azi.azi04) RETURNING l_oeb.oeb14   #MOD-AB0083
                  LET l_oeb.oeb14t=l_oeb.oeb14*(1+l_oea.oea211/100)  #NO.FUN-620024
                  CALL cl_digcut(l_oeb.oeb14t,l_azi.azi04) RETURNING l_oeb.oeb14t   #MOD-AB0083
               ELSE                                        #NO.FUN-620024
                  LET l_oeb.oeb14t=l_oeb.oeb917*l_oeb.oeb13 #NO.FUN-620024  #No.TQC-6A0084
                  CALL cl_digcut(l_oeb.oeb14t,l_azi.azi04) RETURNING l_oeb.oeb14t   #MOD-AB0083
                  LET l_oeb.oeb14=l_oeb.oeb14t/(1+l_oea.oea211/100)  #NO.FUN-620024
                  CALL cl_digcut(l_oeb.oeb14,l_azi.azi04) RETURNING l_oeb.oeb14   #MOD-AB0083
               END IF
               LET l_oeb.oeb23=0          #待出貨數量
               LET l_oeb.oeb24=0          #已出貨數量
               LET l_oeb.oeb25=0          #已銷退數量
               LET l_oeb.oeb26=0          #被結案數量
               LET l_oeb.oeb28=0          #No.MOD-860042 add
               LET l_oeb.oeb70='N'        #結案否
               LET l_oeb.oeb901=0         #已包裝數
               LET l_oeb.oeb905=0         #no.7182
                #-----MOD-AB0083---------
                #取位動作往上移
                #CALL cl_digcut(l_oeb.oeb14,l_azi.azi04) 
                #                 RETURNING l_oeb.oeb14
                #CALL cl_digcut(l_oeb.oeb14t,l_azi.azi04) 
                #                 RETURNING l_oeb.oeb14t
                #-----END MOD-AB0083-----
                    
               IF l_aza.aza50='Y' THEN 
                  IF l_sma.sma116 MATCHES '[23]' THEN
                     LET l_unit = l_oeb.oeb916   #計價單位
                  ELSE
                     LET l_unit = l_oeb.oeb05    #銷售單位
                  END IF
                  CALL s_fetch_price2(l_oea.oea03,l_oeb.oeb04,l_unit,l_oea.oea02,'4',l_plant_new,l_oea.oea23)  #No.TQC-680107 By Rayven  #No.FUN-980059
                       RETURNING l_oeb.oeb1002,l_oeb.oeb13,p_success
                  IF p_success = 'N' THEN
                     CALL s_errmsg('','',"p_success","axm-043",0) #No.FUN-710046 
                  END IF
                  IF l_oeb.oeb916 IS NULL THEN
                     LET l_oeb.oeb917 = l_oeb.oeb12
                  END IF
                  IF l_oea.oea213 = 'N' THEN       #表示不含稅
                     LET l_oeb.oeb14 = l_oeb.oeb917*l_oeb.oeb13  #No.TQC-6A0084
                     CALL cl_digcut(l_oeb.oeb14,l_azi.azi04) RETURNING l_oeb.oeb14   #MOD-AB0083
                     LET l_oeb.oeb14t = l_oeb.oeb14*(1+l_oea.oea211/100)
                     CALL cl_digcut(l_oeb.oeb14t,l_azi.azi04) RETURNING l_oeb.oeb14t   #MOD-AB0083
                  ELSE
                     LET l_oeb.oeb13 = l_oeb.oeb13*(1+l_oea.oea211/100)
                     LET l_oeb.oeb14t = l_oeb.oeb917*l_oeb.oeb13  #No.TQC-6A0084
                     CALL cl_digcut(l_oeb.oeb14t,l_azi.azi04) RETURNING l_oeb.oeb14t   #MOD-AB0083
                     LET l_oeb.oeb14 = l_oeb.oeb14t/(1+l_oea.oea211/100)
                     CALL cl_digcut(l_oeb.oeb14,l_azi.azi04) RETURNING l_oeb.oeb14   #MOD-AB0083
                  END IF
                  IF l_oeb.oeb1012 = 'Y' THEN      #搭贈
                     LET l_oeb.oeb14 = 0
                     LET l_oeb.oeb14t= 0
                  END IF
   
                  #LET l_oeb.oeb1001 = p_poy28      #原因碼  #TQC-D40064 mark
 
                  #LET l_sql ="SELECT azf10 FROM ",l_dbs_new,"azf_file ",
                  LET l_sql ="SELECT azf10 FROM ",cl_get_target_table(l_plant_new,'azf_file'), #FUN-A50102 
                             " WHERE azf01 ='",l_oeb.oeb1001,"'",
                             "   AND azf02 = '2'"    #No.TQC-760054        
 	              CALL cl_replace_sqldb(l_sql) RETURNING l_sql        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql,l_plant_new) RETURNING l_sql #FUN-A50102
                  PREPARE azf_pre1 FROM l_sql
                  DECLARE azf_cs1 CURSOR FOR azf_pre1
                  OPEN azf_cs1
                  FETCH azf_cs1 INTO l_azf10
 
                  IF l_azf10 = 'Y' THEN     #No.FUN-6B0065
                     LET l_oeb.oeb14 = 0
                     LET l_oeb.oeb14t = 0
                  END IF
                  LET l_oeb.oeb1003 = '1'
                  LET l_oeb.oeb1004 = ''
                  LET l_oeb.oeb1005 = ''
                  LET l_oeb.oeb1006 = 100
                  LET l_oeb.oeb1007 = ''
                  LET l_oeb.oeb1008 = ''
                  LET l_oeb.oeb1009 = ''
                  LET l_oeb.oeb1010 = ''
                  LET l_oeb.oeb1011 = ''
                  LET l_oeb.oeb1012 = l_azf10     #No.FUN-6B0065
               END IF
               LET l_oeb.oeb1001 = p_poy28      #原因碼  #TQC-D40064 add
               LET l_oeb.oeb01 = l_oea.oea01
              #讀取料件基本資料
              LET l_sql1 = "SELECT * ",
                           #" FROM ",l_dbs_new CLIPPED,"ima_file ", 
                           " FROM ",cl_get_target_table(l_plant_new,'ima_file'), #FUN-A50102
                           " WHERE ima01='",l_pmn.pmn04,"' "           
              CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
              CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
              PREPARE ima_oeb_p1 FROM l_sql1
              IF SQLCA.SQLCODE THEN CALL cl_err('ima_oeb_p1',SQLCA.SQLCODE,1) END IF
              DECLARE ima_oeb_c1 CURSOR FOR ima_oeb_p1
              OPEN ima_oeb_c1
              FETCH ima_oeb_c1 INTO l_ima.*
              IF SQLCA.SQLCODE THEN
                 LET g_msg=l_dbs_new CLIPPED,l_pmn.pmn04 CLIPPED 
                 CALL s_errmsg('','',g_msg CLIPPED,"mfg3403",1)   
                 LET g_success = 'N'
              END IF
              CLOSE ima_oeb_c1
               LET l_oeb.oeb04 = g_oeb.oeb04
               LET l_oeb.oeb05 = g_oeb.oeb05
#MOD-B90047 -- begin --
               CALL s_umfchk(l_oeb.oeb04,l_oeb.oeb05,l_ima.ima25)
                       RETURNING l_check,l_oeb.oeb05_fac
               IF l_check = 1 THEN LET l_oeb.oeb05_fac = 1 END IF
#MOD-B90047 -- end --
               LET l_oeb.oeb12 = g_oeb.oeb12
               LET l_oeb.oeb918= g_oeb.oeb918  #FUN-A80054
               LET l_oeb.oeb919= g_oeb.oeb919  #FUN-A80102
               CALL s_weight_cubage(l_oeb.oeb04,l_oeb.oeb05,l_oeb.oeb12)
                    RETURNING l_a,l_b
               LET l_sum1 = l_sum1+l_a
               LET l_sum2 = l_sum2+l_b
#-抓各站設定的訂單成本中心--
              SELECT poy45 INTO l_oeb.oeb930
                FROM poy_file
               WHERE poy01 = g_poz.poz01
                 AND poy02 = i
 
               #新增訂單單身檔
               #CALL p800_iou(g_oea.oea99,tm.oea905,l_plant_new,'oea')   #NO.FUN-62002  #FUN-980092 add
               CALL p800_iou(g_oea.oea99,tm.oea905,l_plant_new,'oea_file') #FUN-A50102
                  RETURNING l_stu_o                                   #NO.FUN-620025                
              IF NOT cl_null(g_oea.oea99) THEN   #MOD-760123 add
                LET l_sql2 = "SELECT oea01 ",                          
                             #" FROM ",l_dbs_tra CLIPPED,"oea_file ",   #FUN-980092 add
                             " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102
                             " WHERE oea99= '",g_oea.oea99,"'"                        
 	            CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                PREPARE oea_p2 FROM l_sql2                             
                IF SQLCA.SQLCODE THEN 
                   CALL cl_err('oea_p1',SQLCA.sqlcode,1)
                END IF
                DECLARE oea_c2 CURSOR FOR oea_p2                       
                OPEN oea_c2                                            
                FETCH oea_c2 INTO l_oeb.oeb01                          
                CLOSE oea_c2                                           
              END IF    #MOD-760123 add
               IF cl_null(l_stu_o_h) THEN LET l_stu_o_h=l_stu_o END IF  #MOD-760026 add
               IF l_stu_o ='U' THEN LET l_stu_o_h='U' END IF            #MOD-780046 add
               IF l_stu_o='I' THEN                                    #NO.FUN-620025
                  IF cl_null(l_oeb.oeb1006) THEN LET l_oeb.oeb1006 = 100 END IF    #MOD-A10123
                  IF cl_null(l_oeb.oeb37) OR l_oeb.oeb37 = 0 THEN LET l_oeb.oeb37 = l_oeb.oeb13  END IF       #FUN-AB0061  
                  #Add FUN-B20060
                 #CHI-C80060 mark START
                 #IF NOT cl_null(l_oeb.oeb15) AND cl_null(l_oeb.oeb72) THEN
                 #   LET l_oeb.oeb72 = l_oeb.oeb15
                 #END IF
                 #CHI-C80060 mark END
                 #CHI-C80060 add START
                  IF cl_null(l_oeb.oeb72) THEN
                     LET l_oeb.oeb72 = NULL     
                  END IF
                 #CHI-C80060 add END
                  #End Add FUN-B20060
                  #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add
                  LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102 
                      "( oeb01,oeb03,oeb04,oeb05,",
                      "  oeb05_fac,oeb06,oeb07,oeb08, ",
                      "  oeb09,oeb091,oeb092,oeb11, ",
                      "  oeb12,oeb13,oeb14,oeb14t, ",
                      "  oeb15,oeb16,oeb17,oeb18, ",
                      "  oeb19,oeb20,oeb21,oeb22, ",
                      "  oeb23,oeb24,oeb25,oeb26, ",
                      "  oeb28,oeb37, ",                            #No.MOD-860042 add     #FUN-AB0061 add oeb37
                      "  oeb70,oeb70d,oeb71,oeb72, ",
                      "  oeb901,oeb902,oeb903,oeb904,",
                      "  oeb905,oeb906,oeb907,oeb908,",
                      "  oeb909,oeb910,oeb911,oeb912,",   #FUN-560043
                      "  oeb913,oeb914,oeb915,oeb916,",   #FUN-560043
                      "  oeb917,oeb918,oeb919,oeb1001,oeb1002,oeb1003,", #NO.FUN-620024  #FUN-A80102 #FUN-A80054
                      "  oeb1004,oeb1005,oeb1006,oeb1007,oeb1008,", #NO.FUN-620024
                      "  oeb1009,oeb1010,oeb1011,oeb1012,oeb930, ",   #NO.FUN-620024  #FUN-670007 add oeb930
                      "  oebplant,oeblegal , ",
                      "  oebud01,oebud02,oebud03,oebud04,oebud05, ",
                      "  oebud06,oebud07,oebud08,oebud09,oebud10, ",
                      "  oebud11,oebud12,oebud13,oebud14,oebud15 ) ",
                      " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                               "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                               "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",      #CHI-950020 #FUN-A80102 #FUN-A80054
                               "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,", #NO.FUN-620024
                               "?,?,?,?,?,?,?,?,?,?,?,?,?,?," ,  #NO.FUN-620024   #No.MOD-860042 add
                               "?,?,? ) "    #FUN-980010         #FUN-AB0061 add ?
 	              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
                  PREPARE ins_oeb FROM l_sql2
                  EXECUTE ins_oeb USING 
                        l_oeb.oeb01,l_oeb.oeb03,l_oeb.oeb04,l_oeb.oeb05,
                        l_oeb.oeb05_fac,l_oeb.oeb06,l_oeb.oeb07,l_oeb.oeb08, 
                        l_oeb.oeb09,l_oeb.oeb091,l_oeb.oeb092,l_oeb.oeb11, 
                        l_oeb.oeb12,l_oeb.oeb13,l_oeb.oeb14,l_oeb.oeb14t, 
                        l_oeb.oeb15,l_oeb.oeb16,l_oeb.oeb17,l_oeb.oeb18, 
                        l_oeb.oeb19,l_oeb.oeb20,l_oeb.oeb21,l_oeb.oeb22, 
                        l_oeb.oeb23,l_oeb.oeb24,l_oeb.oeb25,l_oeb.oeb26, 
                        l_oeb.oeb28,l_oeb.oeb37,                             #No.MOD-860042 add    #FUN-AB0061 add oeb37
                        l_oeb.oeb70,l_oeb.oeb70d,l_oeb.oeb71,l_oeb.oeb72, 
                        l_oeb.oeb901,l_oeb.oeb902,l_oeb.oeb903,l_oeb.oeb904,
                        l_oeb.oeb905,l_oeb.oeb906,l_oeb.oeb907,l_oeb.oeb908,
                        l_oeb.oeb909,l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,   #FUN-560043
                        l_oeb.oeb913,l_oeb.oeb914,l_oeb.oeb915,l_oeb.oeb916,   #FUN-560043
                        l_oeb.oeb917,l_oeb.oeb918,l_oeb.oeb919,     #FUN-560043  #FUN-A80102 #FUN-A80054
                        l_oeb.oeb1001,l_oeb.oeb1002,l_oeb.oeb1003,l_oeb.oeb1004, #NO.FUN-620024
                        l_oeb.oeb1005,l_oeb.oeb1006,l_oeb.oeb1007,l_oeb.oeb1008, #NO.FUN-620024
                        l_oeb.oeb1009,l_oeb.oeb1010,l_oeb.oeb1011,l_oeb.oeb1012,  #NO.FUN-620024
                        l_oeb.oeb930,                                            #NO.FUN-670007 
                        gp_plant,gp_legal   #FUN-980010
                       ,l_oeb.oebud01,l_oeb.oebud02,l_oeb.oebud03,l_oeb.oebud04,l_oeb.oebud05,
                        l_oeb.oebud06,l_oeb.oebud07,l_oeb.oebud08,l_oeb.oebud09,l_oeb.oebud10,
                        l_oeb.oebud11,l_oeb.oebud12,l_oeb.oebud13,l_oeb.oebud14,l_oeb.oebud15
                    IF SQLCA.sqlcode<>0 THEN
                       CALL s_errmsg('','',"INS oeb:",SQLCA.sqlcode,0) #No.FUN-710046
                       LET g_success = 'N'
                    ELSE
                       IF NOT s_industry('std') THEN
                          INITIALIZE l_oebi.* TO NULL
                          LET l_oebi.oebi01 = l_oeb.oeb01
                          LET l_oebi.oebi03 = l_oeb.oeb03
                       #CHI-C80009---add---START
                          LET l_oebi.oebiicd01 = g_oebi.oebiicd01  #內編母體料號     
                          LET l_oebi.oebiicd07 = g_oebi.oebiicd07  #End User   
                       #CHI-C80009---add-----END
                          IF NOT s_ins_oebi(l_oebi.*,l_plant_new) THEN  #FUN-980092 add
                             LET g_success = 'N'
                          END IF
                       END IF
                    END IF
 
               ELSE
                  IF l_stu_o='U' THEN    
                     IF g_oax.oax06 = 'N' THEN                                   #NO.FUN-670007
                        LET l_sql2 = "SELECT oea01 ",                          
                                     #" FROM ",l_dbs_tra CLIPPED,"oea_file ",    #FUN-980092 add
                                     " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102 
                                     " WHERE oea99= '",g_oea.oea99,"'"              
 	                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                        PREPARE oea_p1 FROM l_sql2                             
                        IF SQLCA.SQLCODE THEN 
                           CALL s_errmsg('','',"oea_p1",SQLCA.sqlcode,0) #No.FUN-710046
                        END IF
                        DECLARE oea_c1 CURSOR FOR oea_p1                       
                        OPEN oea_c1                                            
                        FETCH oea_c1 INTO l_oeb.oeb01                          
                        CLOSE oea_c1                                           
                     END IF
                      #更新訂單單身檔
                      #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oeb_file",  #FUN-980092 add
                      LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oeb_file'), #FUN-A50102  
                      " SET  oeb04=?,oeb05=?,oeb06 =?,oeb11=?,oeb12=?, ",              #MOD-9C0379 
                      "      oeb13=?,oeb14=?,oeb14t=?,oeb15=?, ",
                      "      oeb910=?,oeb911=?,oeb912=?,oeb913=?, ",   #FUN-560043
                      "      oeb914=?,oeb915=?,oeb916=?,oeb917=?, ",    #FUN-560043
                      "      oeb1001=?,oeb1002=?,oeb1003=?,oeb1004=?, ", #NO.FUN-620024
                      "      oeb1005=?,oeb1007=?,oeb1008=?,oeb1009=?, ", #NO.FUN-620024
                      "      oeb1010=?,oeb1011=?,oeb1012=? ", #NO.FUN-620024
                       " WHERE oeb01 = ? AND oeb03 = ? "
 	                  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                      PREPARE upd_oeb FROM l_sql2
                      EXECUTE upd_oeb USING 
                        l_oeb.oeb04,l_oeb.oeb05,l_oeb.oeb06,l_oeb.oeb11,l_oeb.oeb12,   #MOD-9C0379
                        l_oeb.oeb13,l_oeb.oeb14,l_oeb.oeb14t,l_oeb.oeb15, 
                        l_oeb.oeb910,l_oeb.oeb911,l_oeb.oeb912,l_oeb.oeb913,   #FUN-560043
                        l_oeb.oeb914,l_oeb.oeb915,l_oeb.oeb916,l_oeb.oeb917,   #FUN-560043
                        l_oeb.oeb1001,l_oeb.oeb1002,l_oeb.oeb1003,l_oeb.oeb1004, #NO.FUN-620024
                        l_oeb.oeb1005,l_oeb.oeb1007,l_oeb.oeb1008,l_oeb.oeb1009, #NO.FUN-620024
                        l_oeb.oeb1010,l_oeb.oeb1011,l_oeb.oeb1012,  #NO.FUN-620024
                        l_oeb.oeb01,l_oeb.oeb03
                       IF SQLCA.SQLCODE THEN
                          CALL s_errmsg('','',"UPD oeb:",SQLCA.sqlcode,1)  #No.FUN-710046
                          LET g_success = 'N'
                      END IF
                  ELSE                                            #NO.FUN-620024
                     IF l_stu_o='F' THEN                          #NO.FUN-620024  
                        CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1)              #No.FUN-710046
                        LET g_success = 'N'                       #NO.FUN-620024  
                     END IF                                       #NO.FUN-620024
                  END IF
               END IF                    #NO.FUN-620024
               # (拋轉選配件/備品檔)
               DECLARE oeo_cs CURSOR FOR
                 SELECT * FROM oeo_file
                  WHERE oeo01 = l_oeb.oeb01 AND oeo03 = l_oeb.oeb03
               FOREACH oeo_cs INTO l_oeo.*
                IF l_stu_o_h='I' THEN      #MOD-760026 add
                   #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oeo_file",  #FUN-980092 add
                   LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oeo_file'), #FUN-A50102  
                              "( oeo01,oeo03,oeo04,oeo05,",
                              "  oeo06,oeo07,oeo08,oeo09,",
                              "  oeoplant,oeolegal) ",   #FUN-980010
                              " VALUES( ?,?,?,?, ?,?,?,?,  ?,?) "   #FUN-980010       
                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                   CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                   PREPARE ins_oeo FROM l_sql2
                   EXECUTE ins_oeo USING 
                     l_oeo.oeo01,l_oeo.oeo03,l_oeo.oeo04,l_oeo.oeo05,
                     l_oeo.oeo06,l_oeo.oeo07,l_oeo.oeo08,l_oeo.oeo09,
                     gp_plant,gp_legal   #FUN-980010
                      IF SQLCA.sqlcode<>0 THEN
                         CALL s_errmsg('','',"INS oeo:",SQLCA.sqlcode,1) #No.FUN-710046
                         LET g_success = 'N'
                      END IF
                ELSE
                   IF l_stu_o_h='U' THEN   #MOD-760026 add
                      IF g_oax.oax06 = 'N' THEN                              #NO.FUN-670007       
                         LET l_sql2 = "SELECT oea01 ",                              
                                      #" FROM ",l_dbs_tra CLIPPED,"oea_file ",    #FUN-980092 add  
                                      " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102    
                                      " WHERE oea99= '",g_oea.oea99,"'"                            
 	                     CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                         CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                         PREPARE oeo_p1 FROM l_sql2                                 
                         IF SQLCA.SQLCODE THEN
                            CALL cl_err('oeo_p1',SQLCA.sqlcode,1)
                         END IF
                         DECLARE oeo_c1 CURSOR FOR oeo_p1                              
                         OPEN oeo_c1                                                   
                         FETCH oeo_c1 INTO l_oeo.oeo01                                 
                         CLOSE oeo_c1                                                  
                      END IF
          
                      #更新訂單選配件/備品
                      #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oeo_file",  #FUN-980092 add
                      LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oeo_file'), #FUN-A50102  
                                 " SET  oeo05 = ?,oeo06 = ?,",
                                 "      oeo07 = ?,oeo08 = ?,",
                                 "      oeo09 = ? ",
                                 " WHERE oeo01 = ? AND oeo03 = ? ",
                                 "   AND oeo04 = ?"          
 	                  CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                      CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                      PREPARE upd_oeo FROM l_sql2
                      EXECUTE upd_oeo USING 
                         l_oeo.oeo05,l_oeo.oeo06,l_oeo.oeo07,l_oeo.oeo08, 
                         l_oeo.oeo09,
                         l_oeo.oeo01,l_oeo.oeo03,l_oeo.oeo04
                      IF SQLCA.SQLCODE THEN
                         CALL s_errmsg('','',"UPD oeo:",SQLCA.sqlcode,1)        #No.FUN-710046
                         LET g_success = 'N'
                      END IF
                   ELSE                                         #NO.FUN-620024
                      IF l_stu_o_h='F' THEN                     #MOD-760026 add
                         CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1)           #No.FUN-710046
                         LET g_success = 'N'                    #NO.FUN-620024  
                      END IF                                    #NO.FUN-620024
                   END IF
                END IF              #NO.FUN-620024
               END FOREACH
              #新增至暫存檔中
               INSERT INTO p800_file VALUES(i,g_oea.oea01,g_oeb.oeb03,
                                        #l_oeb.oeb13,l_oea.oea23) #MOD-B30491 mark
                                         l_oeb.oeb13,l_oea.oea23,l_oea.oea213,l_oea.oea211) #MOD-B30491
                 IF SQLCA.sqlcode<>0 THEN
                   CALL s_errmsg('','',"INS p800_file",SQLCA.sqlcode,1)                      #No.FUN-710046
                   LET g_success = 'N'
                 END IF
        
              #訂單單頭總金額
              LET l_oea.oea61 = l_oea.oea61 + l_oeb.oeb14 
              CALL cl_digcut(l_oea.oea61,l_azi.azi04) RETURNING l_oea.oea61
 
              #在分銷系統中，訂單單頭未稅總金額                                                                                     
              #IF l_aza.aza50 = 'Y' THEN  #TQC-D40030 mark                                                                                            
                 LET l_oea.oea1008 = l_oea.oea1008 + l_oeb.oeb14t                                                                   
                     CALL cl_digcut(l_oea.oea1008,l_azi.azi04)                                                                      
                                    RETURNING l_oea.oea1008                                                                         
              #END IF                     #TQC-D40030 mark                                                                                                              
           END FOREACH {oeb_cus}
 
           #新增採購單頭檔
           IF l_stu_p_h='I' THEN        #MOD-760026  
              #LET l_sql2="INSERT INTO ",s_dbs_tra CLIPPED,"pmm_file",  #FUN-980092 add
              LET l_sql2="INSERT INTO ",cl_get_target_table(s_plant_new,'pmm_file'), #FUN-A50102
                  "( pmm01,",
                  " pmm02,pmm03,pmm04,pmm05,",
                  " pmm06,pmm07,pmm08,pmm09,",
                  " pmm10,pmm11,pmm12,pmm13,",
                  " pmm14,pmm15,pmm16,pmm17,",
                  " pmm18,pmm20,pmm21,pmm22,",
                  " pmm25,pmm26,pmm27,pmm28,",
                  " pmm29,pmm30,pmm31,pmm32,",
                  " pmm40,pmm40t,pmm401,pmm41,pmm42,",   #No.FUN-610018
                  " pmm43,pmm44,pmm45,pmm46,",
                  " pmm47,pmm48,pmm49,pmm99,",
                  " pmm901,pmm902,pmm903,pmm904, ",
                  " pmm905,pmm906, ",
                  " pmmprsw,pmmprno,pmmprdt,pmmmksg,",
                  " pmmsign,pmmdays,pmmprit,pmmsseq,",
                  " pmmsmax,pmmacti,pmmuser,pmmgrup,",
                  " pmmmodu,pmmdate, ",
                  " pmmplant,pmmlegal, ",
                  " pmmud01,pmmud02,pmmud03,pmmud04,pmmud05,",
                  " pmmud06,pmmud07,pmmud08,pmmud09,",
                  " pmmud10,pmmud11,pmmud12,pmmud13,pmmud14,pmmud15,pmmoriu,pmmorig ) ",  #FUN-A10036
                  " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",   #No.FUN-610018
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",       #CHI-950020
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,  ?,?,?,? ) "  #FUN-980010     #FUN-A10036   
 	          CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
              CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-A50102
              PREPARE ins_pmm FROM l_sql2
              EXECUTE ins_pmm USING l_pmm.pmm01,
                  l_pmm.pmm02,l_pmm.pmm03,l_pmm.pmm04,l_pmm.pmm05,
                  l_pmm.pmm06,l_pmm.pmm07,l_pmm.pmm08,l_pmm.pmm09,
                  l_pmm.pmm10,l_pmm.pmm11,l_pmm.pmm12,l_pmm.pmm13,
                  l_pmm.pmm14,l_pmm.pmm15,l_pmm.pmm16,l_pmm.pmm17,
                  l_pmm.pmm18,l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm22,
                  l_pmm.pmm25,l_pmm.pmm26,l_pmm.pmm27,l_pmm.pmm28,
                  l_pmm.pmm29,l_pmm.pmm30,l_pmm.pmm31,l_pmm.pmm32,
                  l_pmm.pmm40,l_pmm.pmm40t,l_pmm.pmm401,l_pmm.pmm41,l_pmm.pmm42,   #No.FUN-610018
                  l_pmm.pmm43,l_pmm.pmm44,l_pmm.pmm45,l_pmm.pmm46,
                  l_pmm.pmm47,l_pmm.pmm48,l_pmm.pmm49,l_pmm.pmm99,
                  l_pmm.pmm901,l_pmm.pmm902,l_pmm.pmm903,l_pmm.pmm904,
                  l_pmm.pmm905,l_pmm.pmm906,   #MOD-850099
                  l_pmm.pmmprsw,l_pmm.pmmprno,l_pmm.pmmprdt,l_pmm.pmmmksg,
                  l_pmm.pmmsign,l_pmm.pmmdays,l_pmm.pmmprit,l_pmm.pmmsseq,
                  l_pmm.pmmsmax,l_pmm.pmmacti,l_pmm.pmmuser,l_pmm.pmmgrup,
                  l_pmm.pmmmodu,l_pmm.pmmdate,
                  sp_plant,sp_legal   #FUN-980010
                 ,l_pmm.pmmud01,l_pmm.pmmud02,l_pmm.pmmud03,l_pmm.pmmud04,l_pmm.pmmud05,
                  l_pmm.pmmud06,l_pmm.pmmud07,l_pmm.pmmud08,l_pmm.pmmud09,l_pmm.pmmud10,
                  l_pmm.pmmud11,l_pmm.pmmud12,l_pmm.pmmud13,l_pmm.pmmud14,l_pmm.pmmud15,g_user,g_grup   #FN-A10036
                 IF SQLCA.sqlcode<>0 THEN
                    CALL s_errmsg('','',"INS pmm:",SQLCA.sqlcode,1) #No.FUN-710046
                    LET g_success = 'N' EXIT FOREACH
                 END IF
           ELSE       #NO.FUN-620024
              IF l_stu_p_h='U' THEN        #MOD-760026  
                  #更新採購單頭檔
                  #LET l_sql2="UPDATE ",s_dbs_tra CLIPPED,"pmm_file",  #FUN-980092 add
                  LET l_sql2="UPDATE ",cl_get_target_table(s_plant_new,'pmm_file'), #FUN-A50102
                      "  SET pmm09=?,pmm10=?,pmm20=?,pmm21=?,pmm03=?,",   #No.MOD-660103 modify
                      "      pmm22=?,pmm40=?,pmm40t=?,pmm42=?,pmm43=? ",  #No.FUN-610018
                      " WHERE pmm99 = ? "       #NO.FUN-620024
 	              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,s_plant_new) RETURNING l_sql2 #FUN-980092
                  PREPARE upd_pmm FROM l_sql2
                  EXECUTE upd_pmm USING l_pmm.pmm09,l_pmm.pmm10,
                      l_pmm.pmm20,l_pmm.pmm21,l_pmm.pmm03,   #No.MOD-660103 modify
                      l_pmm.pmm22,l_pmm.pmm40,l_pmm.pmm40t,  #No.FUN-610018
                      l_pmm.pmm42,l_pmm.pmm43,
                      l_pmm.pmm99               #NO.FUN-620024
                   IF SQLCA.SQLCODE THEN
                      CALL s_errmsg('','',"UPD pmm:",SQLCA.sqlcode,1)         #No.FUN-710046
                      LET g_success = 'N' EXIT FOREACH
                  END IF
              ELSE                                            #NO.FUN-620024
                 IF l_stu_p_h='F' THEN        #MOD-760026  
                    CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1)              #No.FUN-710046     
                    LET g_success = 'N'                       #NO.FUN-620024    
                 END IF                                       #NO.FUN-620024 
              END IF
           END IF                               #NO.FUN-620024
          
           # 新增訂單 Memo 檔
           IF g_poz.poz10 = 'Y' THEN
              DECLARE oao_cs CURSOR FOR
               SELECT * FROM oao_file WHERE oao01 = g_oea.oea01
              FOREACH oao_cs INTO l_oao.* 
                  IF l_stu_p_h='I' THEN        #MOD-760026  
                     LET l_oao.oao01 = l_oea.oea01  #NO.MOD-740192
                     #LET l_sql2 = "INSERT INTO ",l_dbs_new CLIPPED,"oao_file",
                     LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'oao_file'), #FUN-A50102
                                  "     (oao01,oao03,oao04,oao05,oao06) ",
                                  " VALUES(?,?,?,?,?) "         
 	                 CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                     CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
                     PREPARE ins_oao FROM l_sql2
                     EXECUTE ins_oao USING l_oea.oea01,l_oao.oao03,  #MOD-780030 
                                           l_oao.oao04,l_oao.oao05,
                                           l_oao.oao06
                       IF SQLCA.sqlcode<>0 THEN
                          LET g_msg = l_dbs_new CLIPPED,"ins oao"
                          CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)  #No.FUN-710046
                          LET g_success = 'N'
                       END IF
                  ELSE
                     IF l_stu_p_h='U' THEN        #MOD-760026  
                        IF g_oax.oax06 = 'N' THEN                      #NO.FUN-670007                
                           LET l_sql2 = "SELECT oea01 ",                              
                                        #" FROM ",l_dbs_tra CLIPPED,"oea_file ",   #FUN-980092 add  
                                         " FROM ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102 
                                        " WHERE oea99= '",g_oea.oea99,"'"                            
 	                       CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                           PREPARE oao_p1 FROM l_sql2                                 
                           IF SQLCA.SQLCODE THEN
                              CALL s_errmsg('','',"oao_p1",SQLCA.sqlcode,0) #No.FUN-710046
                           END IF
                           DECLARE oao_c1 CURSOR FOR oao_p1                              
                           OPEN oao_c1                                                   
                           FETCH oao_c1 INTO l_oao.oao01                                 
                           CLOSE oao_c1                                                  
                        END IF
                        #LET l_sql2 = " UPDATE ",l_dbs_new CLIPPED,"oao_file",
                        LET l_sql2 = " UPDATE ",cl_get_target_table(l_plant_new,'oao_file'), #FUN-A50102 
                                     "    SET oao06=? ",
                                     "  WHERE oao01 = ? AND oao03 = ? ",
                                     "    AND oao04 = ? AND oao05 = ? "           
 	                    CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                        CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                        PREPARE upd_oao FROM l_sql2
                        EXECUTE upd_oao USING l_oao.oao06,
                                              l_oao.oao01,l_oao.oao03,
                                              l_oao.oao04,l_oao.oao05
                        IF SQLCA.SQLCODE THEN
                           LET g_msg = l_dbs_new CLIPPED,"upd oao"
                           CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)   #No.FUN-710046
                           LET g_success = 'N'
                        END IF
                        #-----MOD-A80157---------
                        IF SQLCA.SQLERRD[3]=0 THEN 
                           LET l_sql2 = "INSERT INTO ",cl_get_target_table(l_plant_new,'oao_file'), 
                                        "     (oao01,oao03,oao04,oao05,oao06) ",
                                        " VALUES(?,?,?,?,?) "
	                   CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
                           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 
                           PREPARE ins_oao2 FROM l_sql2
                           EXECUTE ins_oao2 USING l_oao.oao01,l_oao.oao03,  
                                                 l_oao.oao04,l_oao.oao05,
                                                 l_oao.oao06
                                 
                           IF SQLCA.SQLCODE THEN
                              LET g_msg = l_dbs_new CLIPPED,"ins oao2"
                              CALL s_errmsg('','',g_msg,SQLCA.sqlcode,1)  
                              LET g_success = 'N'
                           END IF
                        END IF
                        #-----END MOD-A80157-----
                     ELSE                                       #NO.FUN-620024
                        IF l_stu_p_h='F' THEN        #MOD-760026  
                           CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1)          #No.FUN-710046
                           LET g_success = 'N'                  #NO.FUN-620024      
                        END IF                                  #NO.FUN-620024
                     END IF                      
                  END IF                #NO.FUN-620024
              END FOREACH
           END IF
           #新增訂單單頭檔
           LET l_oea.oea1013 = l_sum1   #NO.FUN-620024
           LET l_oea.oea1014 = l_sum2   #NO.FUN-620024
           LET l_oea.oea46 = NULL       #NO.FUN-660068
          #LET l_oea.oea65 = 'N'        #FUN-7B0091 add   #客戶出貨簽收否 #FUN-C40072 mark
           LET l_oea.oea903 = p_oea903  #NO.FUN-670007 

           #MOD-C60235 add start -----
           LET l_sql2 = "SELECT SUM(oeb14),SUM(oeb14t) ",
                        " FROM ",cl_get_target_table(l_plant_new,'oeb_file'),
                        " WHERE oeb01= '",l_oea.oea01,"'"
           CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2
           CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2
           PREPARE oea_p3 FROM l_sql2
           IF SQLCA.SQLCODE THEN
              CALL s_errmsg('','',"oea_p3",SQLCA.sqlcode,0)
           END IF
           DECLARE oea_c3 CURSOR FOR oea_p3
           OPEN oea_c3
           FETCH oea_c3 INTO l_oea61,l_oea1008

           IF cl_null(l_oea61) THEN LET l_oea61 = 0 END IF
           IF cl_null(l_oea1008) THEN LET l_oea1008 = 0 END IF

           CALL cl_digcut(l_oea61,t_azi04) RETURNING l_oea61
           CALL cl_digcut(l_oea1008,t_azi04) RETURNING l_oea1008

           IF l_oea.oea213 = 'Y' THEN
              LET l_oea.oea261 = l_oea1008 * l_oea.oea161/100
           ELSE
              LET l_oea.oea261 = l_oea61 * l_oea.oea161/100
           END IF
           CALL cl_digcut(l_oea.oea261,t_azi04)  RETURNING l_oea.oea261

           IF l_oea.oea213 = 'Y' THEN
              LET l_oea.oea262 = l_oea1008 * l_oea.oea162/100
           ELSE
              LET l_oea.oea262 = l_oea61 * l_oea.oea162/100
           END IF
           CALL cl_digcut(l_oea.oea262,t_azi04)  RETURNING l_oea.oea262

           IF l_oea.oea213 = 'Y' THEN
              LET l_oea.oea263 = l_oea1008 - l_oea.oea261 - l_oea.oea262
           ELSE
              LET l_oea.oea263 = l_oea61 - l_oea.oea261 - l_oea.oea262
           END IF

           CLOSE oea_c3
           #MOD-C60235 add end   -----

           IF l_stu_o_h='I' THEN        #MOD-760026  
              #LET l_sql2="INSERT INTO ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add
              LET l_sql2="INSERT INTO ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102 
                  "( oea00,oea01,oea02,oea03,",
                  "  oea032,oea033,oea04,oea044, ",
                  "  oea05, oea06, oea07, oea08, ",
                  "  oea09, oea10, oea11, oea12, ",
                  "  oea14, oea15, oea161,oea162, ",
                  "  oea163,oea17, oea18, oea19, ",
                  "  oea20, oea21, oea211,oea212, ",
                  "  oea213,oea23, oea24, oea25, ",
                  "  oea26, oea27, oea28, oea29, ",
                  "  oea30, oea31, oea32, oea33, ",
                  "  oea34, oea35, oea36, oea37, oea38, ",  #No.TQC-680107 add oea37 By Rayven
                  "  oea41, oea42, oea43, oea44, ",
                  "  oea45, oea46, oea47, oea48, ",
                  "  oea49, oea50, oea51, oea52, ",
                  "  oea53, oea54, oea55, oea56, ",
                  "  oea57, oea58, oea59, oea61, ",
                  "  oea62, oea63, oea71, oea72, ",
                  "  oea99, oea901,oea902,oea903,",
                  "  oea904,oea905,oea906,oea907,",
                  "  oea908,oea909,oea911,oea912,",
                  "  oea913,oea914,oea915,oea916,",
                  "  oea261,oea262,oea263,",    #MOD-C60235 add
                  "  oea1001,oea1002,oea1003,", #NO.FUN-620024
                  "  oea1004,oea1005,oea1006,", #NO.FUN-620024
                  "  oea1007,oea1008,oea1009,", #NO.FUN-620024
                  "  oea1010,oea1011,oea1012,", #NO.FUN-620024
                  "  oea1013,oea1014,",         #NO.FUN-620024
                  "  oea65,",                   #No.TQC-680107 By Rayven
                  "  oeamksg,oeasign,oeadays,oeaprit,",
                  "  oeasseq,oeasmax,oeahold,oeaconf,",
                  "  oeaprsw,oeauser,oeagrup,oeamodu,",
                  "  oeadate, ",
                  "  oeaplant,oealegal, ",
                  "  oeaud01,oeaud02,oeaud03,oeaud04,oeaud05,",                 
                  "  oeaud06,oeaud07,oeaud08,oeaud09,",                         
                  "  oeaud10,oeaud11,oeaud12,oeaud13,oeaud14,oeaud15,oeaoriu,oeaorig )", #FUN-A10036        
                  " VALUES( ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,",        #No.CHI-950020
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,?,",  #No.TQC-680107 add ?,?, By Rayven
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,",
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?,?,",  #NO.FUN-620024 #MOD-C60235 add ?,?,?,
                           "?,?,?,?, ?,?,?,?, ?,?,?,?, ?,?,?,?, ?,  ?,?,?,?)"   #FUN-980010     #FUN-A10036       
              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
              CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-A50102
              PREPARE ins_oea FROM l_sql2
              EXECUTE ins_oea USING 
                    l_oea.oea00,l_oea.oea01,l_oea.oea02,l_oea.oea03,
                    l_oea.oea032,l_oea.oea033,l_oea.oea04,l_oea.oea044, 
                    l_oea.oea05, l_oea.oea06, l_oea.oea07, l_oea.oea08, 
                    l_oea.oea09, l_oea.oea10, l_oea.oea11, l_oea.oea12, 
                    l_oea.oea14, l_oea.oea15, l_oea.oea161,l_oea.oea162, 
                    l_oea.oea163,l_oea.oea17, l_oea.oea18, l_oea.oea19, 
                    l_oea.oea20, l_oea.oea21, l_oea.oea211,l_oea.oea212, 
                    l_oea.oea213,l_oea.oea23, l_oea.oea24, l_oea.oea25, 
                    l_oea.oea26, l_oea.oea27, l_oea.oea28, l_oea.oea29, 
                    l_oea.oea30, l_oea.oea31, l_oea.oea32, l_oea.oea33, 
                    l_oea.oea34, l_oea.oea35, l_oea.oea36, l_oea.oea37, l_oea.oea38, #No.TQC-680107 add oea37
                    l_oea.oea41, l_oea.oea42, l_oea.oea43, l_oea.oea44, 
                    l_oea.oea45, l_oea.oea46, l_oea.oea47, l_oea.oea48, 
                    l_oea.oea49, l_oea.oea50, l_oea.oea51, l_oea.oea52, 
                    l_oea.oea53, l_oea.oea54, l_oea.oea55, l_oea.oea56, 
                    l_oea.oea57, l_oea.oea58, l_oea.oea59, l_oea.oea61, 
                    l_oea.oea62, l_oea.oea63, l_oea.oea71, l_oea.oea72,
                    l_oea.oea99, l_oea.oea901,l_oea.oea902,p_poz03,
                    l_oea.oea904,l_oea.oea905,l_oea.oea906,l_oea.oea907,
                    l_oea.oea908,l_oea.oea909,l_oea.oea911,l_oea.oea912,
                    l_oea.oea913,l_oea.oea914,l_oea.oea915,l_oea.oea916,
                    l_oea.oea261,l_oea.oea262,l_oea.oea263,                  #MOD-C60235 add
                    l_oea.oea1001,l_oea.oea1002,l_oea.oea1003,l_oea.oea1004, #NO.FUN-620024
                    l_oea.oea1005,l_oea.oea1006,l_oea.oea1007,l_oea.oea1008, #NO.FUN-620024
                    l_oea.oea1009,l_oea.oea1010,l_oea.oea1011,l_oea.oea1012, #NO.FUN-620024
                    l_oea.oea1013,l_oea.oea1014,                             #NO.FUN-620024
                    l_oea.oea65,                                             #No.TQC-680107 By Rayven
                    l_oea.oeamksg,l_oea.oeasign,l_oea.oeadays,l_oea.oeaprit,
                    l_oea.oeasseq,l_oea.oeasmax,l_oea.oeahold,l_oea.oeaconf,
                    l_oea.oeaprsw,l_oea.oeauser,l_oea.oeagrup,l_oea.oeamodu,
                    l_oea.oeadate, 
                    gp_plant,gp_legal   #FUN-980010
                   ,l_oea.oeaud01,l_oea.oeaud02,l_oea.oeaud03,l_oea.oeaud04,
                    l_oea.oeaud05,l_oea.oeaud06,l_oea.oeaud07,l_oea.oeaud08,
                    l_oea.oeaud09,l_oea.oeaud10,l_oea.oeaud11,l_oea.oeaud12,
                    l_oea.oeaud13,l_oea.oeaud14,l_oea.oeaud15,g_user,g_grup                   
                 IF SQLCA.sqlcode<>0 THEN
                    CALL s_errmsg('','',"ins oea:",SQLCA.sqlcode,1)   #No.FUN-710046
                    LET g_success = 'N'
                 END IF
#                #FUN-C50136----add----str----
#                IF g_oaz.oaz96 ='Y' THEN
#                   CALL s_ccc_oia07('A',l_oea.oea03) RETURNING l_oia07
#                   IF l_oia07 = '0' THEN
#                      CALL s_ccc_oia(l_oea.oea03,'A',l_oea.oea01,0,l_plant_new)
#                   END IF
#                END IF                  
#                #FUN-C50136----add----end----
           ELSE        #NO.FUN-620024
              IF l_stu_o_h='U' THEN        #MOD-760026  
                  #LET l_sql2="UPDATE ",l_dbs_tra CLIPPED,"oea_file",  #FUN-980092 add
                  LET l_sql2="UPDATE ",cl_get_target_table(l_plant_new,'oea_file'), #FUN-A50102  
                  " SET oea04 =?,oea044=?,oea06 =?,oea21=?,",
                  "     oea211=?,oea212=?,oea213=?,oea32=?,",
                 #"     oea61 =?",                   #MOD-C60122 mark
                 #"     oea61 =?,oea10 =?,oea43 =?", #MOD-C60122   #MOD-D10124 mark
                  "     oea61 =?,oea10 =?,oea43 =?, oea31=?,",      #MOD-D10124 add
                  "     oea1008 = ?",  #TQC-D40030 add                  
                  " WHERE oea99 = ? "     #NO.FUN-620024
 	              CALL cl_replace_sqldb(l_sql2) RETURNING l_sql2        #FUN-920032
                  CALL cl_parse_qry_sql(l_sql2,l_plant_new) RETURNING l_sql2 #FUN-980092
                  PREPARE upd_oea FROM l_sql2
                  EXECUTE upd_oea USING 
                    l_oea.oea04, l_oea.oea044,l_oea.oea06, l_oea.oea21,
                    l_oea.oea211,l_oea.oea212,l_oea.oea213,l_oea.oea32, 
                   #l_oea.oea61, l_oea.oea99     #NO.FUN-620024       #MOD-C60122 mark
                   #l_oea.oea61, l_oea.oea10,l_oea.oea43,l_oea.oea99  #MOD-C60122 #MOD-D10124 mark
                    l_oea.oea61, l_oea.oea10,l_oea.oea43,l_oea.oea31,l_oea.oea1008,l_oea.oea99  #MOD-D10124 add #TQC-D40030 add oea1008
                   IF SQLCA.SQLCODE THEN
                      CALL s_errmsg('','',"UPD oea:",SQLCA.sqlcode,1)  #No.FUN-710046
                      LET g_success = 'N'
                  END IF
              ELSE                                          #NO.FUN-620024 
                 IF l_stu_o_h='F' THEN        #MOD-760026  
                    CALL s_errmsg('','',g_pmm.pmm99,"apm-803",1)             #No.FUN-710046  
                    LET g_success = 'N'                     #NO.FUN-620024       
                 END IF                                     #NO.FUN-620024
              END IF
           END IF         #NO.FUN-620024
           #若單身之計價方式有所不同時, 提出警告訊息
           IF diff_azi='Y'  THEN
              LET l_msg = cl_getmsg('axm-303',g_lang)
              LET l_msg=l_msg CLIPPED,"(",g_oea.oea01,"+",p_poy04,"):"
              CALL cl_msgany(10,20,l_msg)
           END IF
     END FOR  {一個訂單流程代碼結束}
     #更新訂單檔之三角貿易拋轉否='Y',起始訂單否='Y'
     LET g_i=g_i
     UPDATE oea_file
       SET oea905='Y',
           oea906='Y'
     WHERE oea01=g_oea.oea01
     IF SQLCA.SQLCODE <> 0 OR sqlca.sqlerrd[3]=0 THEN
        CALL s_errmsg("oea01",g_oea.oea01,"UPD oea_file",SQLCA.sqlcode,1)     #No.FUN-710046
        LET g_success='N' 
     END IF
     LET l_cnt0 = l_cnt0 + 1  #FUN-6B0064 add
  END FOREACH     
  IF l_cnt0 = 0 THEN
     LET g_success = 'N'
     CALL cl_err('','mfg3160',1)
  END IF
 
   IF g_totsuccess = 'N' THEN                                                                                                       
      LET g_success = 'N'                                                                                                           
   END IF                                                                                                                           
   CALL s_showmsg()                 #No.FUN-710046
   IF g_success = 'Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK
   END IF
   DROP TABLE p800_file
END FUNCTION
 
#判斷目前之下游廠商為何,並得知S/O及P/O之客戶/廠商代碼
FUNCTION p800_azp(l_n)
  DEFINE l_source LIKE type_file.num5,   #來源站別 #No.FUN-680137 SMALLINT
         l_n      LIKE type_file.num5,   #當站站別 #No.FUN-680137 SMALLINT
         l_sql1   LIKE type_file.chr1000,#No.FUN-680137 VARCHAR(800)
         l_next   LIKE type_file.num5,   #SMALLINT               #FUN-670007
         l_front  LIKE type_file.num5,   #SMALLINT               #FUN-670007
         l_poy03  LIKE poy_file.poy03  
  
     ##-------------取得前一資料庫(PO)-----------------
    
     LET l_next = l_n + 1      #FUN-670007 
     LET l_front = l_n -1      #FUN-670007
        SELECT * INTO s_poy.* FROM poy_file 
         WHERE poy01 = g_poz.poz01 AND poy02 = l_front
 
     SELECT * INTO s_azp.* FROM azp_file WHERE azp01 = s_poy.poy04
     LET s_plant_new = s_azp.azp01                     #FUN-980020
     LET s_dbs_new = s_dbstring(s_azp.azp03 CLIPPED)
     LET g_plant_new = s_azp.azp01
     LET s_plant_new = g_plant_new
     LET t_plant = s_azp.azp01 #add  by MOD-C90136
     CALL s_gettrandbs()
     LET s_dbs_tra = g_dbs_tra
 
     LET l_sql1 = "SELECT * ",                         #取得來源本幣
                  #" FROM ",s_dbs_new CLIPPED,"aza_file ",
                  " FROM ",cl_get_target_table(s_plant_new,'aza_file'), #FUN-A50102
                  " WHERE aza01 = '0' "           
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-A50102
     PREPARE aza_p1 FROM l_sql1
     IF SQLCA.SQLCODE THEN CALL cl_err('aza_p2',SQLCA.SQLCODE,1) END IF
     DECLARE aza_c1  CURSOR FOR aza_p1
     OPEN aza_c1 
     FETCH aza_c1 INTO s_aza.* 
     CLOSE aza_c1
 
     ##-------------取得當站資料庫(SO)-----------------
      SELECT * INTO g_poy.* FROM poy_file               #取得當站流程設定
       WHERE poy01 = g_poz.poz01 AND poy02 = l_n
      SELECT * INTO l_azp.* FROM azp_file WHERE azp01=g_poy.poy04
      LET l_plant_new = l_azp.azp01                     #FUN-980020
      LET l_dbs_new = s_dbstring(l_azp.azp03 CLIPPED)
 
     LET g_plant_new = l_azp.azp01
     LET l_plant_new = g_plant_new
     CALL s_gettrandbs()
     LET l_dbs_tra = g_dbs_tra
 
      LET l_sql1 = "SELECT * ",
                   #" FROM ",l_dbs_new CLIPPED,"aza_file ",
                   " FROM ",cl_get_target_table(l_plant_new,'aza_file'), #FUN-A50102
                   " WHERE aza01 = '0' "
             
 	  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
      PREPARE aza_p2 FROM l_sql1
      IF SQLCA.SQLCODE THEN CALL cl_err('aza_p2',SQLCA.SQLCODE,1) END IF
      DECLARE aza_c2 CURSOR FOR aza_p2
      OPEN aza_c2
      FETCH aza_c2 INTO l_aza.* 
      CLOSE aza_c2
      LET l_sql1 = "SELECT * ",                                                                                                      
                   #" FROM ",l_dbs_new CLIPPED,"sma_file ", 
                   " FROM ",cl_get_target_table(l_plant_new,'sma_file'), #FUN-A50102                    
                   " WHERE sma00= '0' "                                                                                                         
 	  CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
      CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
      PREPARE sma_p1 FROM l_sql1                                                                                                     
      IF SQLCA.SQLCODE THEN CALL cl_err('sma_p1',SQLCA.sqlcode,1) END IF                                                             
      DECLARE sma_c1 CURSOR FOR sma_p1                                                                                               
      OPEN sma_c1                                                                                                                    
      FETCH sma_c1 INTO l_sma.*                                                                                                      
      CLOSE sma_c1                                                                                                                   
      LET p_oea03 = s_poy.poy03        #帳款客戶(上游廠商)
      LET p_pmm09 = g_poy.poy03    #下游廠商  
      LET p_poz03 = g_poy.poy20    #營業額申報方式
      LET p_poy04 = g_poy.poy04    #工廠編號
      IF g_poz.poz09 = 'Y' THEN    #指定幣別
         LET p_azi01 = g_poy.poy05 #流程幣別
      ELSE
         LET p_azi01 = g_oea.oea23 #接單幣別
      END IF
      LET p_poy06 = g_poy.poy06    #付款條件
      LET p_poy07 = g_poy.poy07    #收款條件
      LET p_poy08 = g_poy.poy08    #S/O 稅別
      LET p_poy09 = g_poy.poy09    #P/O 稅別
      LET p_poy10 = g_poy.poy10    #銷售分類
      LET p_poy12 = g_poy.poy12    #發票別
      LET p_poy26 = g_poy.poy26    #是否計算業績
      LET p_poy27 = g_poy.poy27    #業績歸屬方
      LET p_poy28 = g_poy.poy28    #出貨理由碼
      LET p_poy29 = g_poy.poy29    #代送商編號
      LET p_poy33 = g_poy.poy33    #債權代碼
      LET p_oea903 = g_poy.poy20   #營業稅申報方式
END FUNCTION
 
#確定單頭所使用之幣別 ,匯率
FUNCTION p800_curr(l_i,l_oea01,l_oea23)
  DEFINE l_i     LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_oea01 LIKE oea_file.oea01,
         l_oea23 LIKE oea_file.oea23,
         l_cnt   LIKE type_file.num5,   #No.FUN-680137 SMALLINT
         l_azi01 LIKE azi_file.azi01,
         l_pox05 LIKE pox_file.pox05,   #計價方式
         l_oeb15 LIKE oeb_file.oeb15,
         min_oeb15 LIKE oeb_file.oeb15 
 
   IF g_oax.oax08 = "1" THEN
      IF l_aza.aza50 = 'N' THEN   #NO.FUN-620024
         CALL s_pox(g_oea.oea904,l_i,g_oea.oea02)
              RETURNING p_pox03,p_pox05,p_pox06,p_cnt
         IF p_cnt = 0 THEN
            CALL cl_err('','tri-007',1) 
            LET g_success = 'N'
         END IF
         IF p_cnt=1 THEN	#MOD-990054
            LET min_oeb15 = g_oea.oea02
            LET l_pox05 = p_pox05
         END IF   
         #記錄最小預計交貨日之計價方式(單頭幣別之依據)
         IF g_oea.oea02 < min_oeb15 THEN
            LET min_oeb15 = g_oea.oea02
            LET l_pox05 = p_pox05
         END IF
      END IF
   ELSE
      LET l_cnt = 0
      #讀取訂單單身檔(oeb_file)
      DECLARE  oeb_cus3 CURSOR FOR
         SELECT oeb15
           FROM oeb_file
          WHERE oeb01 = l_oea01
      FOREACH oeb_cus3 INTO l_oeb15
         IF SQLCA.SQLCODE <>0 THEN EXIT FOREACH END IF 
         LET l_cnt=l_cnt+1
         #讀取該料號之計價方式(依流程代碼+生效日期+廠商)
         IF l_aza.aza50 = 'N' THEN   #NO.FUN-620024
            CALL s_pox(g_oea.oea904,l_i,l_oeb15)
                 RETURNING p_pox03,p_pox05,p_pox06,p_cnt
            IF p_cnt = 0 THEN
               CALL s_errmsg('','','',"tri-007",1)  #No.FUN-710046
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            IF l_cnt=1 THEN
               LET min_oeb15 = l_oeb15
               LET l_pox05 = p_pox05
            END IF   
            #記錄最小預計交貨日之計價方式(單頭幣別之依據)
            IF g_oeb.oeb15 < min_oeb15 THEN
               LET min_oeb15 = g_oeb.oeb15
               LET l_pox05 = p_pox05
            END IF
         END IF   #NO.FUN-620024
      END FOREACH
   END IF
 
   LET l_azi01 = p_azi01      # add NO:1218
   RETURN l_azi01
 
END FUNCTION
 
#讀取幣別檔之資料
FUNCTION p800_azi(l_oea23)
  DEFINE l_sql1  LIKE type_file.chr1000#No.FUN-680137 VARCHAR(800)
  DEFINE l_oea23 LIKE oea_file.oea23
   #讀取s_dbs_new 之本幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",s_dbs_new CLIPPED,"azi_file ",
                " FROM ",cl_get_target_table(s_plant_new,'azi_file'), #FUN-A50102
                " WHERE azi01='",s_aza.aza17,"' "         
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,s_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN CALL cl_err('azi_p1',SQLCA.SQLCODE,1) END IF
   DECLARE azi_c1 CURSOR FOR azi_p1
   OPEN azi_c1
   FETCH azi_c1 INTO s_azi.* 
   CLOSE azi_c1
   #讀取l_dbs_new 之原幣資料
   LET l_sql1 = "SELECT * ",
                #" FROM ",l_dbs_new CLIPPED,"azi_file ",
                " FROM ",cl_get_target_table(l_plant_new,'azi_file'), #FUN-A50102
                " WHERE azi01='",l_oea23,"' "            
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE azi_p2 FROM l_sql1
   IF SQLCA.SQLCODE THEN CALL cl_err('azi_p2',SQLCA.SQLCODE,1) END IF
   DECLARE azi_c2 CURSOR FOR azi_p2
   OPEN azi_c2
   FETCH azi_c2 INTO l_azi.* 
   CLOSE azi_c2
END FUNCTION
 
#讀取帳款客戶相關之資料
FUNCTION p800_oea03(l_dbs,l_occ01)
  DEFINE l_sql1  LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(800)
         l_dbs   LIKE type_file.chr21,   #No.FUN-680137 VARCHAR(21)
         l_occ01 LIKE occ_file.occ01,
         l_occ02 LIKE occ_file.occ02,
         l_occ04 LIKE occ_file.occ04, #MOD-B10100 add
         l_occ08 LIKE occ_file.occ08,
         l_occ11 LIKE occ_file.occ11
  DEFINE l_occ1005 LIKE occ_file.occ1005,                                       
         l_occ1006 LIKE occ_file.occ1006,                                       
         l_occ1022 LIKE occ_file.occ1022
 
   LET l_occ02=''  LET l_occ08=' ' LET l_occ11=' '
   LET l_occ1005='' LET l_occ1006='' LET l_occ1022=''     #NO.FUN-620024
   LET l_occ04='' #MOD-B10100 add
 
   LET l_sql1 = "SELECT occ02,occ04,occ08,occ11,",        #NO.FUN-620024 #MOD-B10100 add occ04
                "       occ1005,occ1006,occ1022",         #NO.FUN-620024
                #" FROM ",l_dbs CLIPPED,"occ_file ",
                " FROM ",cl_get_target_table(l_plant_new,'occ_file'), #FUN-A50102 
                " WHERE occ01='",l_occ01,"' "           
 	 CALL cl_replace_sqldb(l_sql1) RETURNING l_sql1        #FUN-920032
     CALL cl_parse_qry_sql(l_sql1,l_plant_new) RETURNING l_sql1 #FUN-A50102
   PREPARE occ_p1 FROM l_sql1
   IF SQLCA.SQLCODE THEN CALL cl_err('occ_p1',SQLCA.SQLCODE,1) END IF
   DECLARE occ_c1 CURSOR FOR occ_p1
   OPEN occ_c1
   FETCH occ_c1 INTO  l_occ02,l_occ04,l_occ08,l_occ11,l_occ1005,  #NO.FUN-620024 #MOD-B10100 add occ04
                      l_occ1006,l_occ1022                 #NO.FUN-620024
   IF SQLCA.SQLCODE THEN
      LET g_msg=l_dbs CLIPPED,l_occ01 CLIPPED
      CALL s_errmsg('','',g_msg CLIPPED,"mfg4106",1)   #No.FUN-710046
      LET g_success = 'N'
   END IF
   IF cl_null(l_occ04) THEN LET l_occ04='' END IF #MOD-B10100 add
   CLOSE occ_c1
   RETURN l_occ02,l_occ04,l_occ08,l_occ11,l_occ1005,l_occ1006,    #NO.FUN-620024 #MOD-B10100 add occ04
          l_occ1022                                       #NO.FUN-620024
END FUNCTION
 
# 取得多角序號
FUNCTION p800_flow99()
     
     IF NOT cl_null(g_oea.oea99) THEN   #若訂單重拋時，不重取序號
        LET g_flow99 = g_oea.oea99 
     END IF
     IF cl_null(g_oea.oea99) AND tm.oea905='N' THEN
        CALL s_flowauno('oea',g_oea.oea904,g_oea.oea02)
             RETURNING g_sw,g_flow99
        IF g_sw THEN
           CALL s_errmsg('','','',"tri-011",1)   #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
        UPDATE oea_file SET oea99 = g_flow99 WHERE oea01 = g_oea.oea01
        IF SQLCA.SQLCODE THEN
           CALL s_errmsg("oea01",g_oea.oea01,"UPD oea_file",SQLCA.sqlcode,1)              #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
        #馬上檢查是否有搶號
        LET g_cnt = 0 
        SELECT COUNT(*) INTO g_cnt FROM oea_file WHERE oea99 = g_flow99
        IF g_cnt > 1 THEN
           CALL s_errmsg('','','',"tri011",1)   #No.FUN-710046
           LET g_success = 'N' RETURN
        END IF
     END IF
END FUNCTION 
 
#插入更新前對當前數據庫中的流程序號進行判斷                                     
FUNCTION p800_iou(p_oea99,p_oea905,p_plant,p_table)  #FUN-980092 add                            
DEFINE p_oea99  LIKE oea_file.oea99,                                            
       p_oea905 LIKE oea_file.oea905                                            
DEFINE p_stu    LIKE type_file.chr1,    #No.FUN-680137 VARCHAR(01)
       p_dbs    LIKE oea_file.oea10,    #No.FUN-680137 VARCHAR(31)
       p_sql    LIKE type_file.chr1000, #No.FUN-680137 VARCHAR(1000)
       p_table  LIKE smh_file.smh01,    #No.FUN-680137 VARCHAR(10)
       p_n      LIKE type_file.num5     #No.FUN-680137 SMALLINT
DEFINE p_plant  LIKE azp_file.azp01   #FUN-980092 mark
                                                                                
  LET g_plant_new = p_plant
  CALL s_gettrandbs()
  LET p_dbs = g_dbs_tra
  IF NOT cl_null(p_oea99) THEN                                                  
     #IF p_table='oea'THEN   #MOD-B30176 mark
     IF p_table='oea_file'THEN  #MOD-B30176
        LET p_sql = " SELECT COUNT(*) ",
                    #" FROM ",p_dbs CLIPPED,p_table CLIPPED,"_file,",
                    #  p_dbs CLIPPED,"oeb_file",
                    " FROM ",cl_get_target_table(p_plant,p_table),",",    #FUN-A50102
                             cl_get_target_table(p_plant,'oeb_file'),     #FUN-A50102
                    #" WHERE ",p_table CLIPPED,"99='",p_oea99,"'",    #MOD-B30176 mark
                    " WHERE oea99='",p_oea99,"'",    #MOD-B30176 add
                    "   AND oea01= oeb01",
                    "   AND oeb03= '",g_oeb.oeb03,"'"
     ELSE
        #IF p_table='pmm' THEN  #MOD-B30176 mark
        IF p_table='pmm_file' THEN  #MOD-B30176
          LET p_sql = " SELECT COUNT(*) ",
                      #" FROM ",p_dbs CLIPPED,p_table CLIPPED,"_file, ",
                      #  p_dbs CLIPPED,"pmn_file",
                      " FROM ",cl_get_target_table(p_plant,p_table),",",    #FUN-A50102
                               cl_get_target_table(p_plant,'pmn_file'),     #FUN-A50102
                      #" WHERE ",p_table CLIPPED,"99='",p_oea99,"'",   #MOD-B30176 mark
                      " WHERE pmm99='",p_oea99,"'",    #MOD-B30176 add
                      "   AND pmm01=pmn01",
                      "   AND pmn02= '",g_oeb.oeb03,"'"
        END IF
     END IF
 	 CALL cl_replace_sqldb(p_sql) RETURNING p_sql        #FUN-920032
     CALL cl_parse_qry_sql(p_sql,p_plant) RETURNING p_sql #FUN-980092
     PREPARE iou_p1 FROM p_sql                                                  
     IF STATUS THEN CALL cl_err('iou_p1',STATUS,1) END IF                       
     DECLARE iou_c1 CURSOR FOR iou_p1                                           
     OPEN iou_c1                                                                
     FETCH iou_c1 INTO p_n                                                      
     CLOSE iou_c1
     IF p_n=0 AND p_oea905='N' THEN     #判斷插入條件                           
        LET p_stu='I'                                                           
     ELSE                                                                       
        IF p_n=1 AND p_oea905='Y' THEN  #判斷更新條件                           
           LET p_stu='U'                                                        
        ELSE                                                                    
          IF p_n=0 AND p_oea905='Y' THEN  #判斷更新條件                           
             LET p_stu='I'                                                        
          ELSE 
             LET p_stu='F'                                                        
          END IF 
        END IF                                                                  
     END IF                                                                     
  ELSE                                                                          
     LET p_stu='I'                                                              
  END IF                                                                        
                                                                                
   RETURN p_stu                                                                 
                                                                                
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

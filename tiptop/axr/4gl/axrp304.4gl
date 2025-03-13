# Prog. Version..: '5.30.06-13.04.08(00010)'     #
#
# Pattern name...: axrp304.4gl
# Descriptions...: 銷退折讓帳款產生
# Date & Author..: 95/01/21 By Roger
# Remark ........: 本程式 Copy from axrp302
#                  改 oga->oha
#                  改 oma161-> xx
#                  改 oea01 not in oma16 -> oga53>oga54
#                  改 call s_g_ar(..,'11',..) -> (..,'21',..)
# Modify.........: 97-04-17 1.改為不列印檢查表, 因原邏輯產生之資料錯誤
#                           2.劃面增加單別,可自動編號(原用銷退單號)
#                             s_g_ar.4gl 改傳六個參數
#                           3.增加判斷只抓銷退處理方式為'1'者
# Modify.........: 01-04-16 銷退處理方式改為抓 1,4,5 三種,增加defalut值
#                  銷退單要已扣庫存才可轉待抵帳款
# Modify.........: No:7837 03/08/19 By Wiky 呼叫自動取單號時應在 Transction中
# Modify.........: No:8870 03/12/11 By ching called by axmt700 ooz13='2' 需詢問
# Modify.........: No.FUN-550071 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-560070 05/06/16 By Smapmin 修正SQL語法
# Modify.........: No.FUN-570156 06/03/07 By saki 批次背景執行
# Modify.........: NO.FUN-630043 06/03/14 By Melody 多工廠帳務中心功能修改
# Modify.........: NO.MOD-640434 06/04/12 By Nicola 銷退單無法直接產生 AR
# Modify.........: No.FUN-660116 06/06/16 By ice cl_err --> cl_err3
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670047 06/08/15 By Ray 增加兩帳套功能
# Modify.........: No.FUN-680123 06/08/29 By hongmei 欄位類型轉換
# Modify.........: No.FUN-6A0095 06/10/25 By xumin l_time轉g_time
# Modify.........: No.FUN-710050 07/01/20 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-740009 07/04/03 By Elva   會計科目加帳套
# Modify.........: No.MOD-750142 07/05/31 By Smapmin 依ooz13來判斷何時要update oha10
# Modify.........: No.MOD-760136 07/06/28 By Smapmin 修改錯誤訊息
# Modify.........: No.TQC-770021 07/07/03 By Rayven 折讓單別無效未控管
# Modify.........: No.MOD-790047 07/09/13 By Smapmin g_azi->t_azi
# Modify.........: No.MOD-7B0011 07/11/05 By Smapmin 還原MOD-750142修改部份
# Modify.........: No.TQC-7C0110 07/12/08 By Beryl 檢驗單號若不通過給個提示
# Modify.........: NO.MOD-860078 08/06/09 by Yiting ON IDLE處理
# Modify.........: No.MOD-8A0278 08/10/31 By Sarah p304_p()段,LET g_date = NULL這行應拿掉,不可清空畫面輸入的值
# Modify.........: No.MOD-940106 09/04/09 By lilingyu 程式未作若g_oha01為空的判斷,就算是空的也跑執行成功的訊息
# Modify.........: No.FUN-960141 09/06/26 By dongbg GP5.2修改:1 :銷退單若有付款則產生的待扺單為審核的,且一并產生
#                                            應退衝賬axrt410的資料 2:若沒有付款 邏輯不變
# Modify.........: No.TQC-960456 09/07/03 By lilingyu 當未成功轉折讓單后，給出一個提示訊息
# Modify.........: No.MOD-980004 09/08/03 By mike 若銷退單未確認時，在拋轉銷退折讓，目前系統出現執行成功的訊息，                    
#                                                 應該要提示錯誤訊息，無符合資料之類的..    
# Modify.........: No.MOD-950317 09/07/02 By wujie    拋轉不成功
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.FUN-990031 09/10/21 By lutingtingGP5.2財務營運中心欄位調整,營運中心要控制在同一法人下
#                                            QBE条件新增来源机构,控制在同一法人下，条件选项资料来源中心隐藏
# Modify.........: No.TQC-9B0050 09/11/13 By wujie   把4gl过到32区同步
# Modify.........: No:FUN-9C0014 09/12/07 By shiwuying s_g_ar加一參數
# Modify.........: No:TQC-9C0057 09/12/09 By Carrier 状况码赋值
# Modify.........: No.FUN-9C0139 09/12/22 By lutingting oow15單別使用31
# Modify.........: No.FUN-9C0168 10/01/04 By lutingting 款別對應銀行改由axri060抓取
# Modify.........: No.FUN-A10019 10/01/05 By lutingting axr-371處得sql寫法有問題
# Modify.........: No:FUN-A10104 10/01/20 By shiwuying s_t300_gl
# Modify.........: No.FUN-A40041 10/04/20 By wujie     g_sys->AXR
# Modify.........: No.MOD-A50030 10/05/06 By sabrina MOD-950317修改有誤
# Modify.........: No:FUN-A50103 10/06/03 By Nicola 訂單多帳期 s_g_ar多傳期別參數
# Modify.........: No.MOD-A60103 10/06/15 By Dido 科目類別請先給客戶慣用科目類別occ67,否則再帶ooz08 
# Modify.........: No.FUN-A40076 10/07/02 By xiaofeizhu ooa37 = 'Y' 改成 ooa37 = '2' 
# Modify.........: No.FUN-A50102 10/07/07 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A60056 10/07/09 By lutingting GP5.2財務串前段問題整批調整
# Modify.........: No.FUN-A70139 10/07/29 By lutingting 修正FUN-A60056問題
# Modify.........: No.MOD-AA0192 10/10/29 By Dido mark DISPLAY g_n_oma01 
# Modify.........: No.TQC-AC0321 10/12/21 By houlia 給g_wc2賦值
# Modify.........: No:FUN-AC0025 10/12/16 By zhangll 流通整合之財務
# Modify.........: No:MOD-B10017 11/01/04 By Dido 中斷點的多角銷退單應可產生應收帳款
# Modify.........: No.FUN-AB0110 11/01/24 By chenmoyan 自動產生應收且自動確認時,先判斷是否產生遞延收入檔再做確認
# Modify.........: No.FUN-B10058 11/01/25 By lutigting 流通财务改善
# Modify.........: No:MOD-B20042 11/02/14 By Dido oma02 需檢核 ooz09
# Modify.........: NO.FUN-B30166 11/03/29 By zhangweib nme_file add nme27
# Modify.........: No:FUN-B30211 11/04/01 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-B60103 11/06/15 By belle 將程式段移入IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN 判斷式內
# Modify.........: No:MOD-B90003 11/09/02 By Dido 起始編號有誤 
# Modify.........: No:TQC-B90048 11/09/06 By guoch 字体切换时，while true会被执行的逻辑错误
# Modify.........: No:TQC-B90076 11/09/09 By guoch 单号截取处理
# Modify.........: No.FUN-B90062 11/09/15 By wujie 产生nme_file时同时产生tic_file    
# Modify.........: No:MOD-B90128 11/09/20 By Polly 調整編碼長度不符的錯誤
# Modify.........: No.MOD-BB0151 11/11/14 By Dido 若為背景呼叫則須給予 g_wc/g_type 預設值
# Modify.........: No:MOD-BC0101 11/12/28 By Summer 為多角單據時沒有訊息提示,故增加錯誤訊息提示 
# Modify.........: No.TQC-BC0017 12/01/16 By pauline 產生退款單前增加付款金額>0的條件符合才能夠產生退款單
# Modify.........: No:MOD-C20223 12/02/27 By yinhy 銷退單對應的款別明細為儲值卡時，銷退單無貸方科目
# Modify.........: No:MOD-C30863 12/03/26 By yinhy 改用自動編號,不直接使用銷退單號
# Modify.........: No.TQC-BA0171 12/14/10 By SunLM 從銷退單轉待抵賬款式，拋轉失敗
# Modify.........: No:FUN-C60036 12/06/14 By xuxz oaz92 = 'Y' and aza26 = '2'
# Modify.........: No:FUN-C60036 12/06/29 By minpp 增加omf00查询条件
# Modify.........: No:TQC-C80148 12/08/23 By lujh 點退出時，關閉畫面
# Modify.........: No:TQC-CA0024 12/10/11 By dongsz 若銷售和應收單據別中沒有維護相同的單別，應提示在axri010中維護
# Modify.........: No:FUN-C90122 12/10/16 By wangrr 銷退單號oha01開窗
# Modify.........: No:FUN-CA0084 12/10/19 By minpp 走开票流程时按照开票日期omf03立账
# Modify.........: No:FUN-CB0057 12/11/14 By xuxz 合併立賬
# Modify.........: No:MOD-CB0276 12/11/30 By yinhy 按照營運中心挑選銷退單號
# Modify.........: No.CHI-C20015 12/12/11 By pauline 調整axmt700「轉待扺帳款」功能，可挑選待扺AR單別
# Modify.........: No.FUN-C80066 13/01/10 By Lori 為POS銷退單時，要複製單身稅別明細和實際交易稅別明細
# Modify.........: No.TQC-D20046 13/02/28 By qiull 修改發出商品相關問題
# Modify.........: No.MOD-D20134 13/03/15 By Vampire 多角單據走一般銷退/倉退後,屬於一般單據應可產生
# Modify.........: No.MOD-D30271 13/03/29 By apo 改以l_flag2判斷g_date是否為空
# Modify.........: No.SunLM      13/03/29 By SunLM 調整FUN-C80066 的修改，還原
# Modify.........: No.MOD-D60125 13/06/15 By yinhy oaz92欄位值為Y時，axrp330中QBE條件二中的信息隱藏
# Modify.........: No.TQC-DA0032 13/10/23 By yangxf “銷退單號範圍”，“稅種範圍”，“部門編號”範圍欄位增加開窗，且支持多選,“銷退單類型範圍”栏位调整为下拉框

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql       string  #No.FUN-580092 HCN
#DEFINE source           LIKE azp_file.azp01           #No.FUN-680123 VARCHAR(10) #FUN-630043   #FUN-A60056
DEFINE g_date           LIKE oha_file.oha02           #No.FUN-680123 DATE       
DEFINE g_oha01          LIKE oha_file.oha01           #No.FUN-680123 VARCHAR(16)      #No.FUN-550071
#DEFINE g_oha94          LIKE oha_file.oha94           #FUN-C80066 add
DEFINE g_ohaplant       LIKE oha_file.ohaplant        #FUN-960141
DEFINE g_ooa            RECORD LIKE  ooa_file.*       #FUN-960141
DEFINE b_oob            RECORD LIKE  oob_file.*       #FUN-960141
DEFINE tot,tot1,tot2    LIKE type_file.num20_6        #FUN-960141
DEFINE tot3             LIKE type_file.num20_6        #FUN-960141
DEFINE un_pay1,un_pay2  LIKE type_file.num20_6        #FUN-960141
DEFINE g_oma            RECORD LIKE  oma_file.*
DEFINE begin_no         LIKE oma_file.oma01           #No.FUN-680123 VARCHAR(10) #MOD-B90003 mod azp01 -> oma01 
#DEFINE g_start,g_end   VARCHAR(10)                      #FUN-560070
DEFINE g_start,g_end    LIKE oma_file.oma01           #No.FUN-680123 VARCHAR(16)    #FUN-560070
DEFINE g_no             LIKE azp_file.azp01           #No.FUN-680123 VARCHAR(10)
DEFINE g_quick          LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)
DEFINE g_flag           LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)
DEFINE g_no1            LIKE oay_file.oayslip         #No.FUN-680123 VARCHAR(5)       # 97-04-17 add    #No.FUN-550071
DEFINE g_no2            LIKE oay_file.oayslip         #No.FUN-B10058
DEFINE g_type           LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1)       # 01-04-16 add 銷退方式:1,4,5
DEFINE g_way            LIKE ooz_file.ooz08           #No.FUN-680123 VARCHAR(4)       # 01-04-16 add 科目分類:ool
DEFINE g_n_oma01        LIKE oma_file.oma01           # 97-04-17 add
DEFINE g_argv1		LIKE oha_file.oha01           #No.FUN-680123 VARCHAR(16)               #No.FUN-550071
DEFINE g_argv2		LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)
DEFINE p_row,p_col      LIKE type_file.num5           #No.FUN-680123 SMALLINT
 
DEFINE   g_cnt          LIKE type_file.num10          #No.FUN-680123 INTEGER   
DEFINE   g_cnt2         LIKE type_file.num10          #Add No.FUN-AC0025
DEFINE   g_occ73        LIKE occ_file.occ73           #Add No.FUN-AC0025
DEFINE   g_i            LIKE type_file.num5           #No.FUN-680123 SMALLINT   #count/index for any purpose
DEFINE   i              LIKE type_file.num5           #No.FUN-680123 SMALLINT
DEFINE   g_change_lang  LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)   #是否有做語言切換 No.FUN-570156
DEFINE g_bookno1        LIKE aza_file.aza81           #No.FUN-740009
DEFINE g_bookno2        LIKE aza_file.aza82           #No.FUN-740009
DEFINE g_wc2            STRING                        #FUN-A60056 
DEFINE l_plant          LIKE azw_file.azw01           #FUN-A60056
DEFINE g_wc3            STRING                        #FUN-C60036 add
#FUN-C60036 add--str
DEFINE g_oaz92         LIKE oaz_file.oaz92      
DEFINE g_oaz93         LIKE oaz_file.oaz93   
DEFINE g_omf01         LIKE omf_file.omf01
DEFINE g_omf02         LIKE omf_file.omf02
DEFINE g_omf00         LIKE omf_file.omf00            #FUN-C60036 minpp
DEFINE g_prog_type     STRING
#DEFINE g_mTax          LIKE type_file.chr1            #FUN-C80066 add
#FUN-C60036 add--end

MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0095
   DEFINE ls_date       STRING                        #No.FUN-570156 
   DEFINE l_flag        LIKE type_file.chr1           #No.FUN-680123 VARCHAR(1) #No.FUN-570156 
   DEFINE l_open_axrp304a LIKE type_file.chr1    #CHI-C20015 add
   DEFINE l_oha01         LIKE oha_file.oha01    #CHI-C20015 add
 
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #No.FUN-570156 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_argv1  = ARG_VAL(1)       #參數一
   LET g_argv2  = ARG_VAL(2)       #參數二
  #FUN-A60056--mod--str--
  #LET g_wc     = ARG_VAL(3)       #QBE條件
  #LET ls_date  = ARG_VAL(4)
  #LET g_date   = cl_batch_bg_date_convert(ls_date)   #日期
  #LET g_no1    = ARG_VAL(5)       #退貨折讓單別
  #LET g_type   = ARG_VAL(6)       #折讓條件
  #LET g_way    = ARG_VAL(7)       #科目類別
  #LET g_bgjob = ARG_VAL(8)     #背景作業
   LET l_plant = ARG_VAL(3)     #FUN-A60056 營運中心
   LET g_wc     = ARG_VAL(4)       #QBE條件
   LET ls_date  = ARG_VAL(5)
   LET g_date   = cl_batch_bg_date_convert(ls_date)   #日期 
   LET g_no1    = ARG_VAL(6)       #退貨折讓單別 
   LET g_type   = ARG_VAL(7)       #折讓條件 
   LET g_way    = ARG_VAL(8)       #科目類別 
   LET g_bgjob = ARG_VAL(9)     #背景作業 
   LET l_open_axrp304a = ARG_VAL(10)     #CHI-C20015 add 是否開放選取單別
  #FUN-A60056--mod--end
   LET g_no2 = ARG_VAL(10)  #FUN-B10058
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #No.FUN-570156 ---end---
   LET g_wc3    = ARG_VAL(11)  #FUN-C60036 add
   LET g_wc3    = cl_replace_str(g_wc3, "\\\"", "'") #FUN-C60036 add
   LET g_prog_type = ARG_VAL(12) #FUN-C60036 add 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   #FUN-C60036--add--str
   SELECT oaz92,oaz93 INTO g_oaz92,g_oaz93 FROM oaz_file
   #FUN-C60036--add--end
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AXR")) THEN
      EXIT PROGRAM
   END IF
 
   #No.FUN-570156 --start--
#  LET g_argv1 = ARG_VAL(1)
#  LET g_argv2 = ARG_VAL(2)
   #No.FUN-570156 ---end---
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211
 
   LET p_row = 4 LET p_col =13 
  #-MOD-BB0151-add-
   IF NOT cl_null(g_argv1) THEN
      LET g_wc=" oha01='",g_argv1,"'"
      LET g_type=g_argv2
   END IF
  #-MOD-BB0151-end-
  #IF (NOT cl_null(g_argv1) AND g_bgjob = "N") OR (NOT cl_null(g_prog_type))  THEN       #No.FUN-570156#FUN-CA0084 mark
   IF (NOT cl_null(g_argv1) AND g_bgjob = "N") OR (NOT cl_null(g_prog_type)) OR (g_oaz92 = 'Y' AND g_aza.aza26 = '2' AND NOT cl_null(g_wc3)) THEN #FUN-CA0084 add
      #FUN-C60036-add--str
      SELECT oaz92 INTO g_oaz.oaz92 FROM oaz_file
      IF g_oaz.oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
         LET g_wc =  " 1=1"
         CALL p304_axrt320()
      ELSE
   #FUN-C60036--add--end
      OPEN WINDOW p304a_w AT p_row,p_col WITH FORM "axr/42f/axrp304a"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
      CALL cl_ui_locale("axrp304a")
      CALL cl_load_act_sys("axrp304a")
      CALL cl_load_act_list("axrp304a")
       CALL cl_set_comp_visible("g_no1",FALSE)                        
     #LET g_way=g_ooz.ooz08        #MOD-A60103 mark
     #-MOD-A60103-add-
     #FUN-A60056--mod--str--
     #SELECT occ67 INTO g_way 
     #  FROM occ_file,oha_file
     # WHERE occ01 = oha03
     #   AND oha01 = g_argv1 
      LET g_sql = "SELECT occ67,occ73 ",   #Mod No.FUN-AC0025 add occ73
                  "  FROM ",cl_get_target_table(l_plant,'occ_file'),",",
                  "       ",cl_get_target_table(l_plant,'oha_file'),
                  " WHERE occ01 = oha03 AND oha01 = '",g_argv1,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql
      PREPARE sel_occ67 FROM g_sql
      EXECUTE sel_occ67 INTO g_way,g_occ73  #Mod No.FUN-AC0025 add occ73
     #FUN-A60056--mod--end
      IF cl_null(g_way) THEN 
         LET g_way=g_ooz.ooz08
      END IF
     #-MOD-A60103-add-
      LET l_oha01 = g_argv1    #CHI-C20015 add 
      DISPLAY g_argv1,g_way TO oma01,oma13
     #INPUT g_way WITHOUT DEFAULTS FROM oma13       #CHI-C20015 mark
      INPUT l_oha01,g_way WITHOUT DEFAULTS FROM oma01,oma13   #CHI-C20015  add

       #CHI-C20015 add START
        BEFORE INPUT
          IF l_open_axrp304a = 'Y' THEN
             CALL cl_set_comp_entry("oma01",TRUE)
          ELSE
             CALL cl_set_comp_entry("oma01",FALSE)
          END IF
       #CHI-C20015 add END 
 
        AFTER FIELD oma13
          IF g_way IS NULL THEN NEXT FIELD oma13 END IF
          SELECT COUNT(*) INTO g_cnt FROM ool_file WHERE ool01=g_way
          IF g_cnt =0 THEN
             CALL cl_err(g_way,'axr-917',0)   #MOD-760136
             NEXT FIELD oma13
          END IF
 
       ON ACTION CONTROLP
          CASE
             WHEN INFIELD(g_way) # Class
#               CALL q_ool(05,11,g_way) RETURNING g_way
#               CALL FGL_DIALOG_SETBUFFER( g_way )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ool"
                LET g_qryparam.default1 = g_way
                CALL cl_create_qry() RETURNING g_way
#                CALL FGL_DIALOG_SETBUFFER( g_way )
                DISPLAY g_way TO oma13

            #CHI-C20015 add START
             WHEN INFIELD(oma01)
                CALL q_ooy(FALSE,FALSE,l_oha01,'21','AXR') RETURNING l_oha01 
                DISPLAY l_oha01 TO oma01
            #CHI-C20015 add END

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
 
      
      END INPUT
      IF INT_FLAG THEN CLOSE WINDOW p304_wa EXIT PROGRAM END IF
 
      LET g_wc=" oha01='",g_argv1,"'"
     #FUN-A60056--mod--str--
     #SELECT oha02 INTO g_date FROM oha_file WHERE oha01=g_argv1
      LET g_sql = "SELECT oha02 FROM ",cl_get_target_table(l_plant,'oha_file'),
                  " WHERE oha01='",g_argv1,"'"
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,l_plant) RETURNING g_sql  
      PREPARE sel_oha02 FROM g_sql
      EXECUTE sel_oha02 INTO g_date
     #FUN-A60056--mod--end
      IF STATUS THEN 
#        CALL cl_err('sel oha:',STATUS,1)   #No.FUN-660116
         CALL cl_err3("sel","oha_file",g_argv1,"",STATUS,"","sel oha:",1)   #No.FUN-660116
         EXIT PROGRAM 
      END IF
     #LET g_no1=NULL  #CHI-C20015 mark 
     #CHI-C20015 add START
      IF NOT cl_null(l_oha01) AND l_oha01 = g_argv1 THEN
         LET g_no1 = NULL
      ELSE
         LET g_no1 = l_oha01
      END IF
     #CHI-C20015 add END
      LET g_no2=NULL  #FUN-B10058
      LET g_type=g_argv2
      #Add No.FUN-AC0025
      LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(l_plant,'rxx_file'),
                  " WHERE rxx01 = '",g_argv1,"' AND rxx00 = '03'",
                  "   AND rxx04 > 0"    #TQC-BC0017 add
      CALL cl_replace_sqldb(g_sql) RETURNING g_sql
      CALL cl_parse_qry_sql(g_sql,g_ohaplant) RETURNING g_sql
      PREPARE sel_cou_rxx FROM g_sql
      EXECUTE sel_cou_rxx INTO g_cnt2
      #End Add No.FUN-AC0025
      #No.8870
      END IF #FUN-C60036 add
      IF g_ooz.ooz13 = '2' THEN
         #Add No.FUN-AC0025  #增加此种情况下不需提示确认否就能自动审核
         IF g_cnt2>0 AND g_occ73='Y' THEN
            LET g_quick='Y'
         ELSE
         #End Add No.FUN-AC0025
            IF cl_confirm('axr-246') THEN
               LET g_quick='Y'
            ELSE
               LET g_quick='N'
            END IF
         END IF  #Add NO.FUN-AC0025
      END IF
      CALL p304_p()
      #-----No.MOD-640434-----
      CALL s_showmsg()          #No.FUN-710050
      IF g_success = "Y" THEN
         CALL cl_err('','abm-019',1)#FUN-CA0084 add 20121031
         COMMIT WORK
      ELSE
         CALL cl_err('','axm-093',1)     #TQC-960456  	
         ROLLBACK WORK
      END IF
      #-----No.MOD-640434 END-----
      CLOSE WINDOW p304a_w
      EXIT PROGRAM
   END IF
 
   #No.FUN-570156 --start--
#  OPEN WINDOW p304_w AT p_row,p_col WITH FORM "axr/42f/axrp304"
#   ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#  CALL cl_ui_init()
 
#    CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
#  #WHILE TRUE
#     CALL p304()
#     #IF INT_FLAG THEN EXIT WHILE END IF
#  #END WHILE
#  CLOSE WINDOW p304_w
 
   WHILE TRUE
      IF g_bgjob = "N" THEN
         CALL p304()
         IF cl_sure(18,20) THEN 
            LET g_success = 'Y'
            CALL p304_1()
            CALL s_showmsg()          #No.FUN-710050
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag
            ELSE
               CALL cl_err('','axm-093',1)     #TQC-960456  	            	
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag
            END IF
            IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         LET g_success = 'Y'
         CALL p304_1()
         CALL s_showmsg()          #No.FUN-710050
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            CALL cl_err('','axm-093',1)     #TQC-960456  	         	
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END IF
   END WHILE
   #No.FUN-570156 ---end---
#FUN-A60056--mark--str--
#  #FUN-630043
#  IF g_aza.aza52='Y' AND source!=g_plant THEN
#     DATABASE g_dbs      
##      CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#     CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
#  END IF
#  #FUN-630043
#FUN-A60056--mark--end
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0095
END MAIN
 
FUNCTION p304()
   DEFINE   l_flag    LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)
#No.FUN-550071--begin
   DEFINE   li_result LIKE type_file.num5           #No.FUN-680123 SMALLINT
#No.FUN-550071--end   
   DEFINE   lc_cmd    LIKE type_file.chr1000        #No.FUN-680123 VARCHAR(500)      #No.FUN-570156
   DEFINE l_azp02     LIKE azp_file.azp02           #FUN-630043
   DEFINE l_azp03     LIKE azp_file.azp03           #FUN-630043
   DEFINE l_ooyacti   LIKE ooy_file.ooyacti         #No.TQC-770021
   DEFINE l_azw01_str STRING                        #MOD-CB0276 
 
   #No.FUN-570156 --start--
   OPEN WINDOW p304_w AT p_row,p_col WITH FORM "axr/42f/axrp304"
        ATTRIBUTE (STYLE = g_win_style)
   CALL cl_ui_init()
   #No.FUN-570156 ---end---
   CALL cl_set_comp_visible("group03", FALSE)   #FUN-990031
   #FUN-B10058--add--str--
   IF g_azw.azw04 <> '2' THEN
      CALL cl_set_comp_visible("g_no2",FALSE)
   END IF 
   #FUN-B10058--add--end
   #No.MOD-D60125  --Begin
   IF g_oaz92='Y' AND g_aza.aza26='2' THEN
     CALL cl_set_comp_visible("group01",FALSE)
   ELSE
      CALL cl_set_comp_visible("group04",FALSE)
   END IF
   #No.MOD-D60125  --End
   CLEAR FORM
 
#FUN-A60056--mark--str--
#     #FUN-630043
#     LET source=g_plant 
#     LET l_azp02=''
#     DISPLAY BY NAME source
#     SELECT azp02 INTO l_azp02 FROM azp_file WHERE azp01=source
#     DISPLAY l_azp02 TO FORMONLY.azp02
#     IF g_aza.aza52='Y' THEN
#        INPUT BY NAME source WITHOUT DEFAULTS
#        AFTER FIELD source 
#           LET l_azp02=''
#           SELECT azp02 INTO l_azp02 FROM azp_file
#              WHERE azp01=source
#           IF STATUS THEN
##              CALL cl_err(source,'100',0)   #No.FUN-660116
#              CALL cl_err3("sel","azp_file",source,"","100","","",0)   #No.FUN-660116
#              NEXT FIELD source
#           END IF
#           DISPLAY l_azp02 TO FORMONLY.azp02
#
#        AFTER INPUT
#           IF INT_FLAG THEN EXIT INPUT END IF  
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(source)
#                 CALL cl_init_qry_var()
#                 LET g_qryparam.form = "q_azp"
#                 LET g_qryparam.default1 = source
#                 CALL cl_create_qry() RETURNING source 
#                 DISPLAY BY NAME source
#                 NEXT FIELD source
#           END CASE
#
#        ON ACTION exit              #加離開功能genero
#           LET INT_FLAG = 1
#           EXIT INPUT
 
##--NO.MOD-860078 ------
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about         
#           CALL cl_about()      
#
#        ON ACTION help          
#           CALL cl_show_help()  
#
#        ON ACTION controlg      
#           CALL cl_cmdask()     
##--NO.MOD-860078 end-------
#     END INPUT
#
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0 
#        CLOSE WINDOW p304_w 
#        EXIT PROGRAM
#     END IF
#
#     IF source!=g_plant THEN
#        SELECT azp03 INTO l_azp03 FROM azp_file WHERE azp01=source
#        IF STATUS THEN LET l_azp03=g_dbs END IF
#        DATABASE l_azp03    
##         CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#        CALL cl_ins_del_sid(1,source) #FUN-980030  #FUN-990069
#     END IF
#  END IF
#     #FUN-630043
#FUN-A60056--mark--end
     #FUN-C60036--add--str
      IF g_oaz92 !='Y' OR g_aza.aza26 != '2'  THEN
         CALL cl_set_comp_visible("group04", FALSE)
      END IF 
      #FUN-C60036--add--end
   WHILE TRUE
      CALL cl_opmsg('w')
      
#FUN-A60056--add--str--
      CONSTRUCT BY NAME g_wc2 ON azw01

         ON ACTION locale
            LET g_change_lang = TRUE
            EXIT CONSTRUCT

         BEFORE CONSTRUCT
            CALL cl_qbe_init()
            LET l_azw01_str = "'",g_plant CLIPPED,"'"             #MOD-CB0276
            DISPLAY g_plant TO azw01      #MOD-B90003

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT CONSTRUCT

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_select()

         ON ACTION CONTROLP
            CASE
              WHEN INFIELD(azw01)   #來源營運中心
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_azw"
                   LET g_qryparam.where = "azw02 = '",g_legal,"' "
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO azw01
                   LET l_azw01_str = g_qryparam.multiret                     #MOD-CB0276
                   LET l_azw01_str = cl_replace_str(l_azw01_str,"|","','")   #MOD-CB0276
                   LET l_azw01_str = "'",l_azw01_str CLIPPED,"'"             #MOD-CB0276
                   NEXT FIELD azw01
            END CASE
      END CONSTRUCT

      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
        # EXIT WHILE     #TQC-B90048 mark
         CONTINUE WHILE  #TQC-B90048 add
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p304_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
#FUN-A60056--add--end

     #CONSTRUCT BY NAME g_wc ON oha01,oha02,oha21,oha05,oha15,ohaplant   #FUN-990031 add ohaplant #FUN-A60056
    IF g_oaz92 = 'N' OR cl_null(g_oaz92) THEN     #MOD-D60125
      CONSTRUCT BY NAME g_wc ON oha01,oha02,oha21,oha05,oha15            #FUN-A60056 
 
         ON ACTION locale
#           #FUN-A60056   LET g_action_choice = "locale"       #No.FUN-570156
#           CALL cl_show_fld_cont()              #No.FUN-550037 hmf   No.FUN-570156
            LET g_change_lang = TRUE             #No.FUN-570156
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
         
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
#FUN-A60056--mark--str--
#        #FUN-990031--add--str--
#        ON ACTION CONTROLP
#           CASE
#             WHEN INFIELD(ohaplant)
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_azw"
#               LET g_qryparam.where = "azw02 = '",g_legal,"' "   
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
#               DISPLAY g_qryparam.multiret TO ohaplant
#               NEXT FIELD ohaplant
#           END CASE
#        #FUN-990031--add--end
#FUN-A60056--mark--end
      #FUN-C90122--add--str--
      ON ACTION CONTROLP
         CASE
           WHEN INFIELD(oha01)   #銷退單號
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oha3"
                LET g_qryparam.state = "c"
                 #No.MOD-CB0276  --Begin
                 IF cl_null(l_azw01_str) THEN
                    LET g_qryparam.arg1 = "'%'"
                 ELSE
                    LET g_qryparam.arg1 = l_azw01_str
                 END IF
                 #No.MOD-CB0276  --End
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oha01
                NEXT FIELD oha01
#TQC-DA0032 add begin ---
           WHEN INFIELD(oha21)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oha21"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oha21
                NEXT FIELD oha21
           WHEN INFIELD(oha15)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_oha15"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO oha15
                NEXT FIELD oha15
#TQC-DA0032 add end -----
         END CASE
      #FUN-C90122--add--end 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('ohauser', 'ohagrup') #FUN-980030
      #No.FUN-570156 --start--
      #IF g_action_choice = "locale" THEN
      #   LET g_action_choice = ""
      #   CALL cl_dynamic_locale()
      #   CONTINUE WHILE
      #END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()
         CONTINUE WHILE
      END IF
      #No.FUN-570156 ---end---
      IF INT_FLAG THEN
         #No.FUN-570156 --start--
         CLOSE WINDOW p304_w 
#FUN-A60056--mark--str--
#        #FUN-630043
#        IF g_aza.aza52='Y' AND source!=g_plant THEN
#           DATABASE g_dbs 
##            CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#           CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
#        END IF
#        #FUN-630043
#FUN-A60056--mark--end
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
         #RETURN
         #No.FUN-570156 ---end---
      END IF
      IF g_wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      #ELSE
      #   EXIT WHILE
      END IF
      #FUN-C60036--add--str
   END IF  #MOD-D60125
   IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
      LET g_wc = ' 1=1'   #MOD-D60125   
      CONSTRUCT BY NAME g_wc3 ON omf00,omf01,omf02   #	FUN-C60036 add-omf00
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about         
            CALL cl_about()     

         ON ACTION help         
            CALL cl_show_help()  

         ON ACTION controlg      
            CALL cl_cmdask()    


         ON ACTION locale         
            LET g_change_lang = TRUE
            EXIT CONSTRUCT

         ON ACTION exit              
              LET INT_FLAG = 1
              EXIT CONSTRUCT
         ON ACTION controlp
            CASE 
             #FUN-C60036---ADD--STR
              WHEN INFIELD(omf00)
                  #No.yinhy130515  --Begin
                  #CALL cl_init_qry_var()
                  #LET g_qryparam.state = "c"
                  #LET g_qryparam.form ="q_omf"
                  #CALL cl_create_qry() RETURNING g_qryparam.multiret        
                  CALL q_omf1(TRUE,TRUE,'','0') RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omf00
                  NEXT FIELD omf00
                  #No.yinhy130515  --End
             #FUN-C60036---ADD---END
               WHEN INFIELD(omf01)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_omf01"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omf01
                  NEXT FIELD omf01
               WHEN INFIELD(omf02)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = "c"
                  LET g_qryparam.form ="q_omf02"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO omf02
                  NEXT FIELD omf02
            END CASE
      END CONSTRUCT
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()              
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW gisp101_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time 
         EXIT PROGRAM
      END IF
   END IF
   #FUN-C60036--add--end
   #END WHILE
   LET g_date=g_today
   LET g_type='1'
   LET g_way=g_ooz.ooz08
   DISPLAY BY NAME g_date,g_type,g_way
   CALL cl_opmsg('a')
   LET g_bgjob = "N"
 
  #No.+009 010416 by plum
  #INPUT BY NAME g_date,g_no1 WITHOUT DEFAULTS 
   INPUT BY NAME g_date,g_no1,g_no2,g_type,g_way,g_bgjob WITHOUT DEFAULTS      #No.FUN-570156 #FUN-B10058 add g_no2
  #No.+009 ..end
 
      AFTER FIELD g_no1   
         IF NOT cl_null(g_no1) THEN
            #No.TQC-770021 --start--
            LET l_ooyacti = NULL
            SELECT ooyacti INTO l_ooyacti FROM ooy_file
             WHERE ooyslip = g_no1
            IF l_ooyacti <> 'Y' THEN
               CALL cl_err(g_no1,'axr-956',1)
               NEXT FIELD g_no1
            END IF
            #No.TQC-770021 --end--
#No.FUN-550071--begin
#           CALL s_check_no(g_sys,g_no1,"","21","","","")
            CALL s_check_no("axr",g_no1,"","21","","","")   #No.FUN-A40041
            RETURNING li_result,g_no1
            #LET g_no1 = s_get_doc_no(g_no1)     #FUN-560070
           #DISPLAY BY NAME g_no1
            IF (NOT li_result) THEN
               NEXT FIELD g_no1
            END IF
#            CALL s_axrslip(g_no1,'21',g_sys)        #檢查單別
#           IF NOT cl_null(g_errno)THEN              #抱歉, 有問題
#              CALL cl_err(g_no1,g_errno,0)
#              NEXT FIELD g_no1 
#           END IF
#No.FUN-550071--end   
         END IF
     #FUN-B10058--add--str--
      AFTER FIELD g_no2
         IF NOT cl_null(g_no2) THEN
            LET l_ooyacti = NULL
            SELECT ooyacti INTO l_ooyacti FROM ooy_file
             WHERE ooyslip = g_no2
            IF l_ooyacti <> 'Y' THEN
               CALL cl_err(g_no2,'axr-956',1)
               NEXT FIELD g_no2
            END IF
            CALL s_check_no("axr",g_no2,"","28","","","")   #No.FUN-A40041
            RETURNING li_result,g_no2
            IF (NOT li_result) THEN
               NEXT FIELD g_no2
            END IF
         END IF     
     #FUN-B10058--add--end
 
     #No.+009 010416 by plum
      AFTER FIELD g_type
         IF cl_null(g_type) OR g_type NOT MATCHES '[145]' THEN
            CALL cl_err(g_type,'axr-063',0)
            NEXT FIELD g_type
         END IF
 
      AFTER FIELD g_way
         IF cl_null(g_way) THEN
            NEXT FIELD g_way
         END IF
         SELECT COUNT(*) INTO g_cnt FROM ool_file
          WHERE ool01=g_way
         IF g_cnt=0 THEN
            CALL cl_err(g_way,'axr-917',0)   #MOD-760136
            NEXT FIELD g_way
         END IF
 
      AFTER INPUT
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         LET l_flag='N'
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         IF cl_null(g_type) THEN
            LET l_flag='Y'
         END IF
         IF cl_null(g_way)  THEN
            LET l_flag='Y'
         END IF
         IF l_flag='Y' THEN
            CALL cl_err('','9033',0)
            NEXT FIELD g_type
         END IF
    #No.+009 ..end
 
     ON ACTION CONTROLR
        CALL cl_show_req_fields()
 
     ON ACTION CONTROLG
        CALL cl_cmdask()
 
     ON ACTION CONTROLP
         CASE
             WHEN INFIELD(g_no1) # Class
               #CALL q_ooy(FALSE,FALSE,g_no1,'21',g_sys) RETURNING g_no1   #TQC-670008
                CALL q_ooy(FALSE,FALSE,g_no1,'21','AXR') RETURNING g_no1   #TQC-670008
#                CALL FGL_DIALOG_SETBUFFER( g_no1 )
                DISPLAY BY NAME g_no1 
             #FUN-B10058--add--str--
             WHEN INFIELD(g_no2)
                CALL q_ooy(FALSE,FALSE,g_no2,'28','AXR') RETURNING g_no2
                DISPLAY BY NAME g_no2
             #FUN-B10058--add--end
             WHEN INFIELD(g_way) # Class
#               CALL q_ool(FALSE,FALSE,g_way) RETURNING g_way
#               CALL FGL_DIALOG_SETBUFFER( g_way )
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_ool"
                LET g_qryparam.default1 = g_way
                CALL cl_create_qry() RETURNING g_way
#                CALL FGL_DIALOG_SETBUFFER( g_way )
                DISPLAY BY NAME g_way
            END CASE
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   
   END INPUT
 
   IF INT_FLAG THEN
      #RETURN                 #TQC-C80148  mark
      CLOSE WINDOW p304_wa    #TQC-C80148  add
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  #TQC-C80148  add
      EXIT PROGRAM            #TQC-C80148  add
   END IF
 
   #No.FUN-570156 --start--
   IF g_bgjob = "Y" THEN
      SELECT zz08 INTO lc_cmd FROM zz_file
       WHERE zz01 = "axrp304"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('axrp304','9031',1)
      ELSE
         LET g_wc=cl_replace_str(g_wc, "'", "\"")
         LET lc_cmd = lc_cmd CLIPPED,
                      " ''",
                      " ''",
                      " '",l_plant CLIPPED,"'",     #FUN-A60056
                      " '",g_wc    CLIPPED,"'",
                      " '",g_date  CLIPPED,"'",
                      " '",g_no1   CLIPPED,"'",
                      " '",g_type  CLIPPED,"'",
                      " '",g_way   CLIPPED,"'",
                      " '",g_bgjob CLIPPED,"'"
                     ," '",g_no2   CLIPPED,"'"    #FUN-B10058
         CALL cl_cmdat('axrp304',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p304_w
#FUN-A60056--mark--str--
#        #FUN-630043
#        IF g_aza.aza52='Y' AND source!=g_plant THEN
#           DATABASE g_dbs 
##            CALL cl_ins_del_sid(1) #FUN-980030  #FUN-990069
#           CALL cl_ins_del_sid(1,g_plant) #FUN-980030  #FUN-990069
#        END IF
#        #FUN-630043
#FUN-A60056--mark--end
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM
   END IF
   EXIT WHILE
#  IF cl_sure(21,21) THEN
#     IF g_ooz.ooz13='2' THEN
#        IF cl_confirm('axr-246') THEN
#           LET g_quick='Y'
#        ELSE 
#           LET g_quick='N'    #bugno:5861
#        END IF     
#     END IF
#     CALL p304_p()
#     IF g_flag THEN
#        CONTINUE WHILE
#     ELSE
#        EXIT WHILE
#     END IF
#  END IF
   #No.FUN-570156 ---end---
   END WHILE
END FUNCTION
 
#No.FUN-570156 --start--
FUNCTION p304_1()
   IF g_ooz.ooz13='2' THEN
      IF cl_confirm('axr-246') THEN
         LET g_quick='Y'
      ELSE 
         LET g_quick='N'    #bugno:5861
      END IF     
   END IF
   CALL p304_p()
END FUNCTION
#No.FUN-570156 ---end---
 
FUNCTION p304_p()
   DEFINE l_flag            LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)
   DEFINE l_flag1           LIKE type_file.chr1           #No.FUN-680123 VARCHAR(01)
   DEFINE g_t1              LIKE aba_file.aba00           #No.FUN-680123 VARCHAR(05)   #No.FUN-550071
   DEFINE l_yy,l_mm,l_cnt   LIKE type_file.num5           #No.FUN-680123 SMALLINT
   DEFINE l_cn              LIKE type_file.num5           #No.FUN-680123 SMALLINT
   DEFINE l_ooydmy1         LIKE ooy_file.ooydmy1
   DEFINE li_result         LIKE type_file.num5           #No.FUN-680123 SMALLINT   #No.FUN-550071
   DEFINE l_azw01           LIKE azw_file.azw01           #FUN-A60056 
   DEFINE l_poz18           LIKE poz_file.poz18           #MOD-B10017
   DEFINE l_poz19           LIKE poz_file.poz19           #MOD-B10017
   DEFINE l_poz01           LIKE poz_file.poz01           #MOD-B10017
   DEFINE l_cnt2            LIKE type_file.num5           #MOD-B10017
   DEFINE l_oma00           LIKE oma_file.oma00           #FUN-AB0110
   DEFINE l_oha57           LIKE oha_file.oha57           #FUN-B10058
   DEFINE l_t1              LIKE aba_file.aba00           #MOD-B90128 add
   DEFINE   ls_n,ls_n2     LIKE type_file.num10 #FUN-C60036 add xuxz
   DEFINE l_oay11           LIKE oay_file.oay11    #FUN-CA0084 add 20121031
   DEFINE l_omf00           LIKE omf_file.omf00    #FUN-CB0057 add
   DEFINE l_oma01           LIKE oma_file.oma01    #FUN-CB0057 add
   DEFINE l_oha01           LIKE oha_file.oha01    #FUN-CB0057 add
   #DEFINE l_n               LIKE type_file.num5           #FUN-C80066 add
   DEFINE l_slip            LIKE oay_file.oayslip  #TQC-D20046 add
   DEFINE l_oha41           LIKE oha_file.oha41           #MOD-D20134 add
   DEFINE l_flag2           LIKE type_file.chr1           #MOD-D30271

   #FUN-C60036--add--str--
   IF cl_null(g_wc3) THEN LET g_wc3 = " 1=1" END IF 
   #FUN-C60036--add--end
#FUN-A60056--add--str--
#TQC-AC0321  --modify
 IF cl_null(g_wc2) THEN
    LET g_wc2 = ' 1=1'
 END IF 
#TQC-AC0321  --end

#TQC-BA0171 --begin--
 IF cl_null(g_wc) THEN
    LET g_wc = " 1=1"
 END IF 
#TQC-BA0171 --end--
 IF cl_null(g_date) THEN LET l_flag2 = 'Y' END IF   #MOD-D30271
 LET g_sql = "SELECT azw01 FROM azw_file ",
             " WHERE azwacti = 'Y' AND azw02 = '",g_legal,"'",
             "   AND ",g_wc2 CLIPPED
 PREPARE sel_azw01_pre1 FROM g_sql
 DECLARE sel_azw01_cur1 CURSOR FOR sel_azw01_pre1
 FOREACH sel_azw01_cur1 INTO l_azw01
#FUN-A60056--add--end
   #--- 97-04-17 增加判斷銷退處理方式為'1'者
   #No.B369 010417 by plum add check 銷退單據年月要和立帳年月同
   #IF NOT cl_null(g_date) THEN#FUN-CB0057 mark
    IF NOT cl_null(g_date) AND NOT (g_aza.aza26 = '2' AND g_oaz92 = 'Y') THEN #FUN-CB0057 add
       LET g_sql="SELECT UNIQUE YEAR(oha02),MONTH(oha02) ",
                #"  FROM oha_file,oay_file ",   #FUN-A60056
                 "  FROM ",cl_get_target_table(l_azw01,'oha_file'),",",  #FUN-A60056
                 "       ",cl_get_target_table(l_azw01,'oay_file'),      #FUN-A60056
                 " WHERE ",g_wc CLIPPED,
                 "  AND ohaconf='Y' AND oha53>oha54 ",
                 "  AND oha09='",g_type,"' ",
                 "  AND ( YEAR(oha02) != YEAR('",g_date,"') ",
                 "   OR  (YEAR(oha02)  = YEAR('",g_date,"') ",
                 "  AND   MONTH(oha02)!= MONTH('",g_date,"'))) ",
                 "  AND (oha10 IS NULL OR oha10 = ' ')",
                #No.+249 010712 by plum 銷退單要已扣帳才可立待抵
                 "  AND ohapost = 'Y' ",
                #No.+249..end
             #    "  AND oha01[1,3]=oayslip AND oay11='Y'"
                 #"  AND  s_get_doc_no(oha01) =oayslip AND oay11='Y'"   #No.FUN-550071   #FUN-560070
                  " AND oha01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   #FUN-560070 #TQC-9B0050
       #FUN-C60013--add--str--
       IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN
          LET g_sql = g_sql CLIPPED," AND oha01 IN(SELECT omf11 FROM omf_file
                                      WHERE ",g_wc3 CLIPPED,")"
       END IF
       #FUN-C60013--add--end
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A60056
       CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql    #FUN-A60056
       PREPARE p304_prepare0 FROM g_sql
       DECLARE p304_cs0 CURSOR WITH HOLD FOR p304_prepare0
       LET l_flag='N'
       FOREACH p304_cs0 INTO l_yy,l_mm
         LET l_flag='Y' EXIT FOREACH
       END FOREACH
       IF l_flag='Y' THEN
          CALL cl_err('','axr-064',1)
          LET g_success='N'     #->No.FUN-570156
          RETURN
       END IF
    END IF
 END FOREACH   #FUN-A60056
   #No.B369..end

#FUN-A70139--add--str--
 LET g_success = 'Y'
 LET begin_no  = NULL
 LET l_cnt=0
 CALL s_showmsg_init()  
#FUN-A70139--add--end

 #FUN-C60036--add--str--
       BEGIN WORK
 #FUN-C60036--add--end
#FUN-A60056--add--str--按照畫面QBE條件產生資料
 LET g_sql = "SELECT azw01 FROM azw_file ",
             " WHERE azwacti = 'Y' AND azw02 = '",g_legal,"'",
             "   AND ",g_wc2 CLIPPED
 PREPARE sel_azw01_pre2 FROM g_sql
 DECLARE sel_azw01_cur2 CURSOR FOR sel_azw01_pre2
 FOREACH sel_azw01_cur2 INTO l_azw01 
#FUN-A60056--add--end 
   ## No.2713 modify 1998/11/05 已產生之銷退單不可重複產生
   #No.+112 010510 b plum
   #LET g_sql="SELECT oha01 FROM oha_file,oay_file WHERE ",g_wc CLIPPED,
   #LET g_sql="SELECT oha01,azi03,azi04 FROM oha_file LEFT OUTER JOIN azi_file ON oha_file.oha23=azi_file.azi01,oay_file ",     #FUN-960141
   #FUN-A60056--mod--str--	
   #LET g_sql="SELECT oha01,ohaplant,azi03,azi04 FROM oha_file LEFT OUTER JOIN azi_file ON oha_file.oha23=azi_file.azi01,oay_file ",  #FUN-960141 add ohaplant
   #FUN-C60036--add--str
   LET ls_n = 0
   LET g_sql = " SELECT COUNT(*) FROM omf_file ",
               "  WHERE omf10 = '9' ",
               "    AND ",g_wc3
   PREPARE omf10_per FROM g_sql
   EXECUTE omf10_per INTO ls_n
   LET ls_n2 = 0
   LET g_sql = " SELECT COUNT(*) FROM omf_file ",
               "  WHERE omf10! = '9' ",
               "    AND ",g_wc3
   PREPARE omf10_per2 FROM g_sql
   EXECUTE omf10_per2 INTO ls_n2
   IF g_oaz92 = 'Y' AND g_aza.aza26 = '2' THEN 
      IF ls_n > 0 THEN 
         LET g_sql="SELECT DISTINCT omf00,omf01,omf02,oha01,ohaplant,azi03,azi04,oha57 ",     #FUN-C80066 add oha94
                   "  FROM omf_file LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'oha_file'),
                   "    ON omf11 = oha01 AND ohaconf='Y' AND oha53>oha54 ",
                   "   AND oha09='",g_type,"' ", 
                   "   AND oha01 IN (SELECT DISTINCT omf11 FROM omf_File ",
                               " WHERE omf08 = 'Y' AND omf10 = '2' ",
                               "   AND omf04 IS NULL ",
                               "   AND omf09 = '",l_azw01,"'",
                               "   AND ",g_wc3
         IF g_oaz.oaz93 = 'Y' AND ls_n2 >0  THEN LET g_sql = g_sql CLIPPED," AND omfpost = 'Y' " END IF
         LET g_sql = g_sql CLIPPED," ) ",
                   "   AND ohapost = 'Y' LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'azi_file'),
                   "    ON oha_file.oha23=azi_file.azi01 LEFT OUTER JOIN ",
                  # cl_get_target_table(l_azw01,'oay_file')," ON oha01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'",  #TQC-D20046---mark---
                   cl_get_target_table(l_azw01,'oay_file')," ON oha01 like ltrim(rtrim(oayslip)) || '-%' ",                #TQC-D20046---add---
                   " WHERE omf09 = '",l_azw01,"'",
                   "   AND omf04 IS NULL ",
                   "   AND omf08 = 'Y' ",
                   "   AND ",g_wc3," ORDER BY omf00,omf01,omf02"
                   
      ELSE
     #LET g_sql="SELECT omf01,omf02,oha01,ohaplant,azi03,azi04,oha57 ",         #FUN-C60036 minpp MARK
      LET g_sql="SELECT DISTINCT omf00,omf01,omf02,oha01,ohaplant,azi03,azi04,oha57 ",   #FUN-C60036 minpp add   #FUN-C80066 add oha94
              "  FROM ",cl_get_target_table(l_azw01,'oha_file'),
              "  LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'azi_file'),
              "    ON oha_file.oha23=azi_file.azi01 ",
              "      ,",cl_get_target_table(l_azw01,'oay_file'),  
              "  ,omf_file ",  
              "  WHERE ",g_wc CLIPPED,
              "  AND ohaconf='Y' AND oha53>oha54 ",
              "  AND oha09='",g_type,"' ",
              "  AND ohapost = 'Y' ",
              #" AND oha01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'",    #TQC-D20046---mark---
              " AND oha01 like ltrim(rtrim(oayslip)) || '-%' ",                  #TQC-D20046---add---
              "   AND oha01 = omf11 ",
              "   AND ",g_wc3,
              "   AND oha01 IN (SELECT DISTINCT omf11 FROM omf_File ",
                               " WHERE omf08 = 'Y' AND omf10 = '2' ",
                               "   AND omf04 IS NULL ",
                               "   AND omf09 = '",l_azw01,"'",
                               "   AND ",g_wc3
     IF g_oaz.oaz93 = 'Y' THEN LET g_sql = g_sql CLIPPED," AND omfpost = 'Y' " END IF 
     LET g_sql = g_sql CLIPPED," ) ", 
     " ORDER BY omf00,omf01,omf02"       #FUN-C60036 minpp add--omf00
     END IF
   ELSE 
   #FUn-C60036--add--end
    LET g_sql="SELECT '','','',oha01,ohaplant,azi03,azi04,oha57 ",   #FUN-B10058 add oha57 #FUN-C60036 add '','', #minpp add ''    #FUN-C80066 add oha94
              "  FROM ",cl_get_target_table(l_azw01,'oha_file'),
              "  LEFT OUTER JOIN ",cl_get_target_table(l_azw01,'azi_file'),
              "    ON oha_file.oha23=azi_file.azi01 ",
              "      ,",cl_get_target_table(l_azw01,'oay_file'),    
   #FUN-A60056--mod--end
              "  WHERE ",g_wc CLIPPED,
          #  "  AND ohaconf='Y' AND oha53>oha54 AND oha09='1' ",
          #No.+057 010410 by linda mod
          #No.+009 010416 by plum mod
          #  "  AND ohaconf='Y' AND oha53>oha54 AND (oha09='1' OR oha09='4') ",
             "  AND ohaconf='Y' AND oha53>oha54 ",
             "  AND oha09='",g_type,"' ",
          #No.+249 010712 by plum 銷退單要已扣帳才可立待抵
             "  AND ohapost = 'Y' ",
          #No.+249..end
          #No.+009 ..end
             "  AND (oha10 IS NULL OR oha10 = ' ')",
       #      "  AND oha01[1,3]=oayslip AND oay11='Y'"
             #"  AND  s_get_doc_no(oha01) =oayslip AND oay11='Y'"   #No.FUN-550071   #FUN-560070
             # " AND oha01 like ltrim(rtrim(oayslip)) || '-%' AND oay11='Y'"   #FUN-560070  #TQC-D20046---mark---
              " AND oha01 like ltrim(rtrim(oayslip)) || '-%' "                 #TQC-D20046---add---
##------------------------------------------------------
   END IF #FUN-C60036 add
    CALL cl_replace_sqldb(g_sql) RETURNING g_sql   #FUN-A60056
    CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql   #FUN-A60056
    PREPARE p304_prepare FROM g_sql
    DECLARE p304_cs CURSOR WITH HOLD FOR p304_prepare
   #FUN-A70139--mark--str--變臉初始化拉到最外層FOREACH外
   #LET g_success = 'Y'
   #LET begin_no  = NULL
   #LET l_cnt=0
   #FUN-A70139--mark--end

   BEGIN WORK    #FUN-C60036 BEGIN WORK不應該放在循環裏面
   #FOREACH p304_cs INTO g_oha01  No.+112 
   #CALL s_showmsg_init()   #No.FUN-710050   #FUN-A70139
    #FOREACH p304_cs INTO g_oha01,g_azi03,g_azi04   #MOD-790047
    #FOREACH p304_cs INTO g_oha01,t_azi03,t_azi04   #MOD-790047 #FUN-960141
    #FOREACH p304_cs INTO g_omf01,g_omf02,g_oha01,g_ohaplant,t_azi03,t_azi04,l_oha57                    #MOD-790047 #FUN-960141  #FUN-B10058 add oha57  #FUN-C60036 minpp--mark
     FOREACH p304_cs INTO g_omf00,g_omf01,g_omf02,g_oha01,g_ohaplant,t_azi03,t_azi04,l_oha57    #FUN-C60036 minpp--add--omf00    #FUN-C80066 add oha94
       IF STATUS THEN 
          CALL cl_err('p304(foreach):',STATUS,1) 
          LET g_success='N'
          EXIT FOREACH 
       END IF
       #TQC-D20046---add---str---
         IF NOT cl_null(g_oha01) THEN
            LET l_slip = s_get_doc_no(g_oha01)
            LET g_sql = "SELECT oay11 ",
                        "  FROM ",cl_get_target_table(l_azw01,'oay_file'),
                        " WHERE oayslip= '",l_slip,"'"
            CALL cl_replace_sqldb(g_sql) RETURNING g_sql
            CALL cl_parse_qry_sql(g_sql,l_azw01) RETURNING g_sql
            PREPARE sel_oay11_pre FROM g_sql
            EXECUTE sel_oay11_pre INTO l_oay11
            IF l_oay11 != 'Y' THEN
               CALL s_errmsg('','',l_slip,'axr-422',1)
               LET g_success='N'
               EXIT FOREACH
            END IF
         END IF
         #TQC-D20046---add---end---
  #No.FUN-710050--begin
       IF g_success='N' THEN                                                                                                          
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF             
  #No.FUN-710050--end      
       #FUN-CA0084--add--str--20121031
         IF NOT cl_null(g_omf00) AND g_success = 'Y' THEN
            LET g_sql= "SELECT oay11 FROM oay_file,omf_file ",
                 " WHERE omf00 like ltrim(rtrim(oayslip))||'-%' AND omf00 = '",g_omf00,"'"
            PREPARE p330_oay11_prepare FROM g_sql
            EXECUTE p330_oay11_prepare INTO l_oay11
            IF l_oay11 != 'Y' THEN
               CALL s_errmsg('omf00',g_omf00,'','axr-372',1)
               LET g_success = 'N'
               CONTINUE FOREACH
            END IF
         END IF
        #FUN-CA0084--add--end--20121031
   #MOD-940106  --begin--
       IF g_oha01 IS NULL  AND g_oaz.oaz92 = 'N' THEN 
          CALL cl_err('','axr-042',0)
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF 
#MOD-940106  --end             
       #FUN-B10058--add--str--
       IF l_oha57 = '2' AND cl_null(g_no2) THEN
          LET g_success = 'N'
          CALL cl_err('oha57','axr-375',1)
          EXIT FOREACH
       END IF 
       #FUN-B10058--add--end
      #IF g_date IS NULL OR g_date = ' ' THEN   #MOD-D30271 mark
       IF l_flag2 = 'Y' THEN                    #MOD-D30271 
         #FUN-A60056--mod--str--
         #SELECT oha02 INTO g_date FROM oha_file WHERE oha01 = g_oha01
          LET g_sql = "SELECT oha02 FROM ",cl_get_target_table(g_ohaplant,'oha_file'),
                      " WHERE oha01 = '",g_oha01,"'"
          CALL cl_replace_sqldb(g_sql) RETURNING g_sql
          CALL cl_parse_qry_sql(g_sql,g_ohaplant) RETURNING g_sql
          PREPARE sel_oha02_pre1 FROM g_sql
          EXECUTE sel_oha02_pre1 INTO g_date
         #FUN-A60056--mod--end
          IF STATUS THEN 
#            CALL cl_err('sel oha',STATUS,1)   #No.FUN-660116
#No.FUN-710050--begin
#            CALL cl_err3("sel","oha_file",g_oha01,"",STATUS,"","sel oha",1)    #No.FUN-660116
             CALL s_errmsg('oha01',g_oha01,'sel oha',STATUS,0)
#No.FUN-710050--end
          END IF
       END IF
       #--- 97-04-17 增加輸入單別並自動編號
  
      #-MOD-B10017-add-
      #若非中斷點的銷退單要剔除
       LET l_poz01=''
       LET g_sql = "SELECT poz01,poz18,poz19 ", 
                   "  FROM poz_file,",
                           cl_get_target_table(g_ohaplant,'ogb_file'),",",
                           cl_get_target_table(g_ohaplant,'oea_file'),",",
                           cl_get_target_table(g_ohaplant,'ohb_file'),
                   " WHERE oea904 = poz01 ",
                   "   AND ohb01  = '",g_oha01,"'",
                   "   AND ogb31 = oea01 ",
                   "   AND ogb01 = ohb31 "
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ohaplant) RETURNING g_sql
       PREPARE sel_poz_pre FROM g_sql
       EXECUTE sel_poz_pre INTO l_poz01,l_poz18,l_poz19 
      #MOD-D20134 add start -----
       LET g_sql = "SELECT oha41 ",
                   "  FROM ",cl_get_target_table(g_ohaplant,'oha_file'),"",
                   "  WHERE oha01  = '",g_oha01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ohaplant) RETURNING g_sql
       PREPARE sel_oha41_pre FROM g_sql
       EXECUTE sel_oha41_pre INTO l_oha41
       IF l_oha41 = 'Y' THEN
      #MOD-D20134 add end   -----
          IF NOT cl_null(l_poz01) THEN
             LET l_cnt2 = 0
             IF l_poz19 = 'Y'  AND g_plant=l_poz18 THEN    #已設立中斷點
                SELECT COUNT(*) INTO l_cnt2   #check poz18設定的中斷營運中心是否存在單身設定
                  FROM poy_file
                 WHERE poy01 = l_poz01
                   AND poy04 = l_poz18
             END IF 
             IF l_cnt2 = 0 THEN
                CALL s_errmsg('oha01',g_oha01,'','axr-162',1) #MOD-BC0101 add
                CONTINUE FOREACH   #表示出貨單為多角單據不可由此程式處理
             END IF 
          END IF
       END IF #MOD-D20134 add
      #-MOD-B10017-end-
 
      #-MOD-B20042-add-
       IF g_date < g_ooz.ooz09 THEN
          CALL s_errmsg('oha01',g_oha01,'','axr-164',1)
          LET g_success = 'N'
          CONTINUE FOREACH
       END IF
      #-MOD-B20042-end-
       IF NOT (g_aza.aza26 = '2' AND g_oaz92 = 'Y' AND g_omf00 = l_omf00) OR cl_null(l_omf00) THEN #FUN-CB0057 add 
          #FUN-B10058--add--str--
          IF l_oha57 = '2' THEN
             CALL  s_auto_assign_no("axr",g_no2,g_date,"28","oma_file","oma01",
                       "","","")
                       RETURNING li_result,g_n_oma01
             IF (NOT li_result) THEN
                LET g_success = 'N'
             END IF
          ELSE
          #FUN-B10058--add--end
             IF g_no1 IS NULL THEN
                LET g_n_oma01=g_oha01 
                LET l_t1 = s_get_doc_no(g_n_oma01)                               #MOD-B90128 add
                LET g_n_oma01=s_get_doc_no(g_n_oma01)  #TQC-B90076 add
               #No.FUN-550071 --start--
               #CALL s_check_no("axr",g_n_oma01,"","21","oma_file","oma01","")   #No.MOD-950317     #MOD-A50030 取消mar #MOD-B90128 mark
                CALL s_check_no("axr",l_t1,"","21","oma_file","oma01","")        #MOD-B90128 add
               #CALL s_check_no("axm",g_n_oma01,"","60","oma_file","oma01","")   #No.MOD-950317     #MOD-A50030 mark  
                RETURNING li_result,g_n_oma01
               #DISPLAY BY NAME g_n_oma01        #MOD-AA0192 mark 
               #----------------------No.MOD-B90128----------------------start
                DISPLAY  g_n_oma01 TO ar_slip
                LET g_n_oma01 = g_oha01
                LET l_t1 = g_oha01
               #----------------------No.MOD-B90128----------------------end
               IF (NOT li_result) THEN
               #  CALL cl_err('','sub-141',1)     #TQC-7C0110   #TQC-CA0024 mark
                  CALL cl_err('','sub-288',1)     #TQC-CA0024 add
                  LET g_success='N' 
##                NEXT FIELD g_n_oma01
               END IF
               #No.MOD-C30863  --Begin
               CALL s_auto_assign_no("axr",l_t1,g_date,"21","oma_file","oma01","","","")
               RETURNING li_result,g_n_oma01
               LET g_no1 = l_t1
               #No.MOD-C30863  --End
##             LET g_t1=g_n_oma01[1,3]
##             CALL s_axrslip(g_t1,'21',g_sys)          #檢查單別
##             IF NOT cl_null(g_errno)THEN              #抱歉, 有問題
##                CALL cl_err(g_t1,g_errno,1)
##                LET g_success='N' 
##                CALL cl_rbmsg('1') ROLLBACK WORK RETURN
##             END IF
              #No.FUN-550071 --end--  
            ELSE
            #No:7837
            #No.FUN-550071 --start--
              #FUN-C60036 add str
               IF cl_null(g_date) THEN 
                  LET g_sql = " SELECT DISTINCT omf03 FROM omf_file ",
                              "  WHERE ",g_wc3
                 PREPARE p304_omf03_pre FROM g_sql
                  EXECUTE p304_omf03_pre INTO g_date
               
               END IF
               #FUN-C60036 add  end
               CALL  s_auto_assign_no("axr",g_no1,g_date,"21","oma_file","oma01",
                    "","","")
                   RETURNING li_result,g_n_oma01
               IF (NOT li_result) THEN
                  LET g_success = 'N'
##                CONTINUE WHILE
               END IF
  
##             CALL s_axrauno(g_no1,g_date,'21') RETURNING g_i,g_n_oma01
##             IF g_i THEN    #有問題
##                CALL cl_err('','mfg-059',1)
##                LET g_success = 'N'
##                RETURN
##             END IF
            #No.FUN-550071 --end--  
             ##
             END IF
          END IF  #FUN-B10058
       END IF #FUN-CB0057 add
      #No.+009 010418 by plum mod
      #CALL s_g_ar(g_oha01,'21',g_date,g_date,'',g_n_oma01)
      #CALL s_g_ar(g_oha01,'21',g_date,g_date,'',g_n_oma01,g_way,source)  #FUN-630043 #No.FUN-9C0014
      #CALL s_g_ar(g_oha01,0,'21',g_date,g_date,'',g_n_oma01,g_way,source,'') #No.FUN-9C0014    #No:FUN-A50103  #FUN-A60056
      #FUN-CA0084--add--str
       IF g_oaz.oaz92='Y' THEN
          LET g_sql="SELECT omf03 FROM omf_file ",
                    " WHERE ",g_wc3 CLIPPED
          PREPARE p304_omf03_prep FROM g_sql
          EXECUTE p304_omf03_prep INTO g_date
        END IF
       #FUN-CA0084--add--end
       IF NOT (g_aza.aza26 = '2' AND g_oaz92 = 'Y' AND g_omf00 = l_omf00) OR cl_null(l_omf00) THEN #FUN-CB0057 add
         #FUN-B10058--add--str--
          IF l_oha57 = '2' THEN
             CALL s_g_ar(g_oha01,0,'28',g_date,g_date,'',g_n_oma01,g_way,'',l_azw01,g_omf00,g_omf01,g_omf02)  #FUN-C60036 add omf01,omf02 #minpp add omf00 
                  RETURNING g_start,g_end
          ELSE
          #FUN-B10058--add--end
             CALL s_g_ar(g_oha01,0,'21',g_date,g_date,'',g_n_oma01,g_way,'',l_azw01,g_omf00,g_omf01,g_omf02)   #FUN-A60056 #FUN-C60036 add omf01,omf02 #minpp add omf00
                  RETURNING g_start,g_end
          END IF   #FUN-B10058
          LET l_omf00 = g_omf00 #FUN-CB0057 add
          LET l_oha01 = g_oha01 #FUN-CB0057 add
          LET l_oma01 = g_n_oma01 #FUN-CB0057 add
       END IF #FUN-CB0057 add
      #No.+009..end
       IF g_success='N' THEN
          CALL cl_rbmsg('1')
          ROLLBACK WORK
          RETURN
       END IF
      #No.+009 010418 by plum add
       IF g_ooy.ooydmy1='Y' THEN
          #No.FUN-670047 --begin
          CALL s_t300_gl(g_n_oma01,'0')       #No.FUN-9C0014 #No.FUN-A10104
          IF g_aza.aza63 = 'Y' AND  g_success = 'Y' THEN
             CALL s_t300_gl(g_n_oma01,'1')    #No.FUN-9C0014 #No.FUN-A10104
          END IF
          #No.FUN-670047 --begin
          IF g_success='N' THEN
             CALL cl_rbmsg('1') ROLLBACK WORK   RETURN
          END IF
       END IF
      #No.+009..end
      #FUN-960141 add begin GP5.2判斷有無退款
       LET l_cn = 0
      #FUN-A60056--mod--str--
      #SELECT COUNT(*) INTO l_cn FROM rxx_file
      # WHERE rxx01 = g_oha01 AND rxx00 = '03'
      #   AND rxxplant=g_ohaplant
       LET g_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(g_ohaplant,'rxx_file'),
                   " WHERE rxx01 = '",g_oha01,"' AND rxx00 = '03'",
                   "   AND rxx04 > 0"    #TQC-BC0017 add
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ohaplant) RETURNING g_sql
       PREPARE sel_cou_pre FROM g_sql
       EXECUTE sel_cou_pre INTO l_cn
      #FUN-A60056--mod--end
      #FUN-960141 add end
      #IF g_ooz.ooz13='1' OR g_quick='Y' THEN  #FUN-960141 mark
       IF g_ooz.ooz13='1' OR g_quick='Y' OR l_cn > 0 THEN #FUN-960141 若有付款也需審核
        # CALL s_ar_conf('y',g_oha01) RETURNING i
         #No.+009 010418 by plum ,直接確認前若此單別要拋傳票->chk分錄底稿
          IF g_ooy.ooydmy1='Y' THEN
             #No.FUN-740009  --Begin
             CALL s_get_bookno(YEAR(g_date)) RETURNING g_flag,g_bookno1,g_bookno2
             IF g_flag =  '1' THEN  #抓不到帳別
                CALL cl_err(g_date,'aoo-081',1)
                LET g_success = 'N'
                CALL cl_rbmsg('1') ROLLBACK WORK   RETURN
             END IF
             #No.FUN-740009  --End  
              #No.FUN-670047 --begin
             #CALL s_chknpq(g_n_oma01,'AR',1,'0') #No.FUN-740009 
              CALL s_chknpq(g_n_oma01,'AR',1,'0',g_bookno1) #No.FUN-740009 
              IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                #CALL s_chknpq(g_n_oma01,'AR',1,'1')  #No.FUN-740009 
                 CALL s_chknpq(g_n_oma01,'AR',1,'1',g_bookno2)  #No.FUN-740009 
              END IF
              #No.FUN-670047 --end
              IF g_success='N' THEN
                 CALL cl_rbmsg('1') ROLLBACK WORK   RETURN
              END IF
          END IF
         #No.+009..end
#---FUN-AB0110 --Begin
          IF g_ooy.ooydmy1 = 'Y' AND g_success = 'Y' THEN
              SELECT oma00 INTO l_oma00 FROM oma_file WHERE oma01 = g_n_oma01
              CALL s_t300_ins_oct(g_n_oma01,l_oma00,'0') RETURNING i
              IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN
                  CALL s_t300_ins_oct(g_n_oma01,l_oma00,'1') RETURNING i
                  IF i = 0 THEN LET g_success = 'N' END IF         #No.TQC-B60103 mod
                  IF g_success = 'N' THEN RETURN END IF            #No.TQC-B60103 mod
              END IF
             #IF i = 0 THEN LET g_success = 'N' END IF         #No.TQC-B60103 mark
             #IF g_success = 'N' THEN RETURN END IF            #No.TQC-B60103 mark
          END IF
#---FUN-AB0110 --End
         #CALL s_ar_conf('y',g_n_oma01) RETURNING i    #No.FUN-9C0014
          CALL s_ar_conf('y',g_n_oma01,'') RETURNING i #No.FUN-9C0014
          IF g_success='N' THEN 
             CALL cl_rbmsg('1')
             #ROLLBACK WORK     #No.FUN-570156
             RETURN
          END IF
          #Add No:FUN-AC0025
          CALL s_t300_w1('+',g_n_oma01)
          IF g_success='N' THEN
             CALL cl_rbmsg('1')
             RETURN
          END IF
          #End Add No:FUN-AC0025
       END IF
      #FUN-A60056--mod--str--
      #UPDATE oha_file SET oha10=g_n_oma01 WHERE oha01=g_oha01
       LET g_sql = "UPDATE ",cl_get_target_table(g_ohaplant,'oha_file'),
                   "   SET oha10='",g_n_oma01,"'",
                   " WHERE oha01='",g_oha01,"'"
       CALL cl_replace_sqldb(g_sql) RETURNING g_sql
       CALL cl_parse_qry_sql(g_sql,g_ohaplant) RETURNING g_sql
       PREPARE upd_oha_pre FROM g_sql
       EXECUTE upd_oha_pre
      #FUN-A60056--mod--end
      #No.+041 010330 by plum
      #IF STATUS THEN 
        #   CALL cl_err('upd oha_file',STATUS,1) 
       IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 AND NOT cl_null(g_oha01) THEN
#         CALL cl_err('upd oha_file',SQLCA.SQLCODE,1)   #No.FUN-660116
#No.FUN-710050--begin
#         CALL cl_err3("upd","oha_file",g_oha01,"",SQLCA.sqlcode,"","upd oha_file",1)   #No.FUN-660116
          CALL s_errmsg('oha01',g_oha01,'upd oha_file',SQLCA.SQLCODE,1)
#No.FUN-710050--end
          LET g_success='N'
          CALL cl_rbmsg('1')
          #ROLLBACK WORK        #No.FUN-570156
          RETURN
       END IF
      #FUN-CB0057-add--str
       IF l_omf00 = g_omf00 AND g_n_oma01 = l_oma01 AND g_oha01 <> l_oha01 THEN
          UPDATE oma_file SET oma16 = '' WHERE oma01 = g_n_oma01
       END IF
      #FUN-CB0057--add--end
      #No.+041..end
      #FUN-960141 add begin
      #若有付款 產生axrt410
       IF l_cn > 0 AND g_success = 'Y' THEN
          INITIALIZE g_oma.* TO NULL
          SELECT * INTO g_oma.*  FROM oma_file
           WHERE oma01 = g_n_oma01
          IF STATUS THEN
             CALL s_errmsg('oma01',g_n_oma01,'sel oma_file',STATUS,1)
             LET g_success = 'N'
             RETURN
          END IF
          IF g_success = 'Y' THEN
             CALL p304_ins_ooa()    #單    頭.. 
          END IF
          IF g_success = 'Y' THEN
             CALL p304_ins_oob_1()  #單身借方..
          END IF
          IF g_success = 'Y' THEN
             CALL p304_ins_oob_2()  #單身貸方..
          END IF
          IF g_success = 'Y' THEN
             CALL p304_upd_ooa()    #跟新單身..
          END IF
          IF g_success = 'Y' THEN
             CALL p304_g_entry()    #分錄底稿..
          END IF
          IF g_success = 'Y' THEN
             CALL p304_y_upd()      #審    核..
          END IF
          IF g_success = 'N' THEN RETURN END IF
       END IF   
      #FUN-960141 add end
      #-MOD-B90003-add-
       LET l_cnt=l_cnt+1   
       IF l_cnt = 1 THEN
          LET begin_no = g_start
       END IF
      #-MOD-B90003-end-
       IF begin_no IS NULL THEN LET begin_no = g_start END IF
       IF cl_null(g_argv1) THEN
          IF g_bgjob = "N" THEN            #No.FUN-570156
            #MESSAGE g_start,'-',g_end     #MOD-B90003 mark
             MESSAGE begin_no,'-',g_end    #MOD-B90003
             CALL ui.Interface.refresh() #CKP 
          END IF                           #No.FUN-570156
       END IF
      #LET g_date = NULL   #MOD-8A0278 mark
      #LET l_cnt=l_cnt+1   #MOD-B90003 mark
    END FOREACH

   #FUN-C80066 add begin---
#   IF g_oha94 = 'Y' THEN
#      LET g_mTax = TRUE
#   ELSE
#      SELECT COUNT(*) INTO l_cnt FROM ogk_file WHERE ogk01 = g_oma.oma16
#      IF l_cnt > 0 THEN
#         LET g_mTax = TRUE
#      ELSE
#         LET g_mTax = FALSE
#      END IF
#   END IF
#
#   IF g_mTax = TRUE THEN
#       ###-將銷退單單身稅別明細複製到應收單身稅別明細-###
#       LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'ogk_file') ,
#                   " WHERE ogk01 = '",g_oha01,"'"
#       PREPARE ogk_cnt1 FROM g_sql
#       EXECUTE ogk_cnt1 INTO l_n
#       LET g_sql =
#          "INSERT INTO oml_file (oml01,oml02,oml03,oml04,oml05,oml06,oml07,  ",
#          "                      oml08,oml08t,oml09,omldate,omlgrup,         ",
#          "                      omllegal,omlmodu,omlorig,omloriu,omluser)   ",
#          "SELECT '",g_n_oma01,"'",",ogk02,ogk03,ogk04,ogk05,ogk06,        ",
#          "            ogk07,ogk08,ogk08t,ogk09,'','",g_grup,"','",g_legal,"'",
#          "                        ,'','",g_grup,"','",g_user,"','",g_user,"'",
#          "  FROM ",cl_get_target_table(g_plant_new,'ogk_file'),
#          " WHERE ogk01 = '",g_oha01,"'"
#       PREPARE ins_oml_pre3 FROM g_sql
#       EXECUTE ins_oml_pre3
#       IF SQLCA.SQLCODE THEN
#          IF g_bgerr THEN
#             LET g_showmsg=g_oma.oma01
#             CALL s_errmsg('oml01',g_showmsg,'ins oml',SQLCA.SQLCODE,1)
#          ELSE
#             CALL cl_err3("ins","oml_file",g_oma.oma01,"",SQLCA.sqlcode,"","ins oml",1)
#          END IF
#          LET g_success='N'
#          RETURN
#       END IF
#
#      ###-將銷退單單身稅別明細複製到應收實際交易稅別明細資料檔-###
#      LET g_sql = "SELECT count(*) FROM ",cl_get_target_table(g_plant_new,'ogj_file')," WHERE ogj01 = '",g_oha01,"'"
#      PREPARE ogj_cnt1 FROM g_sql
#      EXECUTE ogj_cnt1 INTO l_n
#      IF l_n > 0 THEN
#         LET g_sql =
#            "INSERT INTO omk_file (omk01,omk02,omk03,omk04,omk05,omk06,omk07,  ",
#            "                      omk07t,omk08,omk09,omkdate,omkgrup,         ",
#            "                      omklegal,omkmodu,omkorig,omkoriu,omkuser)   ",
#            "SELECT '",g_n_oma01,"'",",ogj02,ogj03,ogj04,ogj05,ogj06,ogj07,  ",
#            "                  ogj07t,ogj08,ogj09,'','",g_grup,"','",g_legal,"'",
#            "                        ,'','",g_grup,"','",g_user,"','",g_user,"'",
#            "  FROM ",cl_get_target_table(g_plant_new,'ogj_file'),
#            " WHERE ogj01 = '",g_oha01,"'"
#         PREPARE ins_omk_pre4 FROM g_sql
#         EXECUTE ins_omk_pre4
#         IF SQLCA.SQLCODE THEN
#            IF g_bgerr THEN
#               LET g_showmsg=g_oma.oma01
#               CALL s_errmsg('omk01',g_showmsg,'ins omk',SQLCA.SQLCODE,1)
#            ELSE
#               CALL cl_err3("ins","omk_file",g_oma.oma01,"",SQLCA.sqlcode,"","ins omk",1)
#            END IF
#            LET g_success='N'
#            RETURN
#         END IF
#      END IF
#   END IF
   #FUN-C80066 add end-----

 END FOREACH   #FUN-A60056
#MOD-980004   ---start                                                                                                              
    IF NOT cl_null(g_argv1) THEN    #外部程式串過來                                                                                 
       IF l_cnt=0 THEN                                                                                                              
          CALL s_errmsg('','','','aap-129',1)                                                                                       
          LET g_success = 'N'                                                                                                       
          RETURN                                                                                                                    
       END IF                                                                                                                       
    END IF                                                                                                                          
    IF l_cnt=0 THEN                 #本程式單獨run判斷  
       IF NOT cl_null(g_oha01) THEN  #yinhy130515                                                                            
          CALL s_errmsg('','','','aap-129',1)                                                                                          
          LET g_success = 'N'    
       END IF                #yinhy130515                                                                                                      
    END IF                                                                                                                          
#MOD-980004   ---end           
#No.FUN-710050--begin
    IF g_totsuccess="N" THEN                                                                                                         
       LET g_success="N"                                                                                                             
    END IF 
#No.FUN-710050--end
  
   #DISPLAY 'Invoice from ',begin_no,' to ',g_end AT 1,1 #MOD-B90003 mark 
   ##No.FUN-570156 --start--
   #IF NOT cl_null(g_argv1) THEN   # 外部程式串過來
   #   IF l_cnt=0 THEN
   #      CALL cl_err('','aap-129',1)
   #      ROLLBACK WORK
   #      RETURN
   #   END IF
   #   IF g_success='Y' THEN
   #       COMMIT WORK
   #   ELSE
   #       ROLLBACK WORK
   #   END IF 
   #   CALL cl_end(20,20)
   #   RETURN
   #END IF         
   #IF l_cnt=0 THEN                 #本程式單獨run判段
   #   CALL cl_err('','aap-129',1)
   #   LET g_success = "N"          #No.FUN-570156
   #   #ROLLBACK WORK               #No.FUN-570156
   #   CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
   #ELSE
   #   IF g_success='Y' THEN
   #      COMMIT WORK
   #      CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
   #   ELSE
   #      ROLLBACK WORK
   #      CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
   #   END IF
   #END IF
   ##No.FUN-570156 ---end---
    #---97-04-17 改為不列印檢查表, 因原邏輯產生之資料錯誤
    #LET g_wc='"',"oma01 BETWEEN '",begin_no,"' AND '",g_end,"'", '"'
    #CALL p304_out()
    #CALL cl_end(20,20)
END FUNCTION
#MOD-7B0011
#FUN-960141 add begin
FUNCTION p304_ins_ooa() 
   DEFINE  li_result   LIKE  type_file.num5 
   DEFINE  l_oow15     LIKE  oow_file.oow15
 
   SELECT oow15 INTO l_oow15 FROM oow_file 
    WHERE oow00 = '0'
   IF STATUS OR cl_null(l_oow15) THEN
      CALL s_errmsg('oma15',g_n_oma01,'sel oow_file','axr-149',1)            
      LET g_success = 'N'
      RETURN
   END IF  
   #CALL s_auto_assign_no(g_sys,l_oow15,g_oma.oma02,'30','ooy_file','ooyslip','','','')   #FUN-9C0139
#  CALL s_auto_assign_no(g_sys,l_oow15,g_oma.oma02,'32','ooy_file','ooyslip','','','')   #FUN-9C0139
   CALL s_auto_assign_no("axr",l_oow15,g_oma.oma02,'32','ooy_file','ooyslip','','','')   #FUN-9C0139  FUN-A40041
   RETURNING  li_result,g_ooa.ooa01
   IF (NOT li_result) THEN
      LET g_success = 'N'
      RETURN
   END IF   
   LET g_ooa.ooa00 = '1'
   LET g_ooa.ooa02 = g_oma.oma02
   LET g_ooa.ooa03 = g_oma.oma03
   LET g_ooa.ooa032= g_oma.oma032
   LET g_ooa.ooa13 = g_oma.oma13
   LET g_ooa.ooa14 = g_oma.oma14
   LET g_ooa.ooa15 = g_oma.oma15
   LET g_ooa.ooa20 = 'Y'
   LET g_ooa.ooa23 = g_oma.oma23
   LET g_ooa.ooa24 = g_oma.oma24
   LET g_ooa.ooa25 = '0'
   LET g_ooa.ooa31d = 0
   LET g_ooa.ooa31c = 0
   LET g_ooa.ooa32d = 0
   LET g_ooa.ooa32c = 0
   LET g_ooa.ooaconf = 'N'
   LET g_ooa.ooa34 = '0'              #No.TQC-9C0057
   LET g_ooa.ooa38 = '2'              #No.FUN-9C0014 Add
   LET g_ooa.ooaprsw = 0
   LET g_ooa.ooauser = g_oma.omauser
   LET g_ooa.ooagrup = g_oma.omagrup
   LET g_ooa.ooadate = g_oma.omadate
   LET g_ooa.ooamksg = 'N'
   LET g_ooa.ooa35 = '4' 
   LET g_ooa.ooa36 = g_oha01
#  LET g_ooa.ooa37 = 'Y'              #FUN-A40076 Mark 
   LET g_ooa.ooa37 = '2'              #FUN-A40076 Add 
   LET g_ooa.ooa38 = '2'
   LET g_ooa.ooalegal = g_legal #FUN-980011 add
 
   LET g_ooa.ooaoriu = g_user      #No.FUN-980030 10/01/04
   LET g_ooa.ooaorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO ooa_file VALUES(g_ooa.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('','','ins ooa err',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN 
   END IF
END FUNCTION
 
FUNCTION p304_ins_oob_1()     
   DEFINE l_oob   RECORD LIKE oob_file.*
   INITIALIZE l_oob.* TO NULL
 
   SELECT azi03,azi04 INTO t_azi03,t_azi04  FROM azi_file
    WHERE azi01 = g_oma.oma23
 
   LET l_oob.oob01 = g_ooa.ooa01
   SELECT MAX(oob02)+1 INTO l_oob.oob02 FROM oob_file WHERE oob01 = g_ooa.ooa01  
   IF cl_null(l_oob.oob02) THEN
      LET l_oob.oob02 = 1
   END IF
   LET l_oob.oob07 = g_oma.oma23
   LET l_oob.oob08 = g_oma.oma24
   LET l_oob.oob03 = '1'
   LET l_oob.oob04 = '3' 
   LET l_oob.oob06 = g_oma.oma01
  #FUN-A60056--mod-str--
  #SELECT SUM(rxx04) INTO l_oob.oob09 FROM rxx_file
  # WHERE rxx00 = '03' AND rxx01 = g_oha01  AND rxx03 = '-1'
  #   AND rxxplant = g_ohaplant 
   LET g_sql = "SELECT SUM(rxx04) FROM ",cl_get_target_table(g_ohaplant,'rxx_file'),
               " WHERE rxx00 = '03' AND rxx01 = '",g_oha01,"' AND rxx03 = '-1'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ohaplant) RETURNING g_sql
   PREPARE sel_rxx04 FROM g_sql
   EXECUTE sel_rxx04 INTO l_oob.oob09
  #FUN-A60056--mod--end
   IF cl_null(l_oob.oob09) THEN LET l_oob.oob09 = 0 END IF
   CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09
   LET l_oob.oob10 = l_oob.oob08 * l_oob.oob09
   CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10
   LET l_oob.oob11 = g_oma.oma18
   IF g_aza.aza63 = 'Y' THEN LET l_oob.oob111 = g_oma.oma181 END IF
   LET l_oob.oob20 = 'N'
   LET l_oob.oob22 = 0
   LET l_oob.ooblegal = g_legal #FUN-980011 add
  
   INSERT INTO oob_file VALUES(l_oob.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('','','ins oob err',SQLCA.SQLCODE,1)
      LET g_success = 'N'
      RETURN 
   END IF
END FUNCTION
 
FUNCTION p304_ins_oob_2()
   DEFINE l_oob   RECORD LIKE oob_file.*
   DEFINE l_rxx   RECORD LIKE rxx_file.*
   #DEFINE l_ryd05 LIKE ryd_file.ryd05  #FUN-9C0168
   DEFINE l_ooe02 LIKE ooe_file.ooe02  #FUN-9C0168
   DEFINE l_oow17 LIKE oow_file.oow17
   DEFINE l_aag05 LIKE aag_file.aag05
  
   INITIALIZE l_rxx.* TO NULL
 
   CALL s_get_bookno(year(g_ooa.ooa02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL s_errmsg('ooa02','',g_ooa.ooa02,'aoo-081',1)
      LET g_success = 'N'
      RETURN
   END IF
 
#FUN-A60056--mod--str--
#  DECLARE p304_oob_cs CURSOR FOR
#     SELECT * FROM rxx_file WHERE rxx01 = g_oha01
#                              AND rxx00 = '03' 
#                              AND rxx03 = '-1' AND rxxplant = g_ohaplant
   LET g_sql = "SELECT * FROM ",cl_get_target_table(g_ohaplant,'rxx_file'),
               " WHERE rxx01 = '",g_oha01,"'",
               "   AND rxx00 = '03' AND rxx03 = '-1'"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_ohaplant) RETURNING g_sql
   PREPARE p304_oob_pre FROM g_sql
   DECLARE p304_oob_cs CURSOR FOR p304_oob_pre
#FUN-A60056--mod--end
   FOREACH p304_oob_cs INTO l_rxx.*
      IF STATUS THEN
         CALL s_errmsg('','','foreach rxx err',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF 
      INITIALIZE l_oob.* TO NULL
      IF cl_null(l_rxx.rxx04) THEN LET l_rxx.rxx04 = 0 END IF
      SELECT MAX(oob02)+1 INTO l_oob.oob02 FROM oob_file WHERE oob01 = g_ooa.ooa01 
      IF cl_null(l_oob.oob02) THEN LET l_oob.oob02 = 1 END IF
     #FUN-9C0168--mod--str-- 
     #SELECT ryd05 INTO l_ryd05 FROM ryd_file
     # WHERE ryd01 = l_rxx.rxx02
      SELECT ooe02 INTO l_ooe02 FROM ooe_file
       WHERE ooe01 = l_rxx.rxx02
     #FUN-9C0168--mod--end
      LET l_oob.oob01 = g_ooa.ooa01
      LET l_oob.oob07 = g_oma.oma23
      LET l_oob.oob08 = g_oma.oma24
      LET l_oob.oob03 = '2'
      LET l_oob.oob06 = NULL
      LET l_oob.oob09 = l_rxx.rxx04
      LET l_oob.oob22 = l_rxx.rxx04
      LET l_oob.oob20 = 'N'
      LET l_oob.ooblegal = g_legal #FUN-980011 add
 
      CALL cl_digcut(l_oob.oob09,t_azi04) RETURNING l_oob.oob09
      CALL cl_digcut(l_oob.oob22,t_azi04) RETURNING l_oob.oob22
      LET l_oob.oob10 = l_oob.oob08 * l_oob.oob09
      IF cl_null(l_oob.oob10) THEN LET l_oob.oob10 = 0 END IF
      CALL cl_digcut(l_oob.oob10,g_azi04) RETURNING l_oob.oob10
 
      IF l_rxx.rxx02 MATCHES '0[1268]'  THEN     #TT（不含支票）  #MOD-C20223 add 6
         LET l_oob.oob04 = 'A'
        #FUN-9C0168--mod--str--
        #IF l_ryd05 IS NOT NULL THEN  #款別有對應的沒默認銀行
        #   LET l_oob.oob17 = l_ryd05
        #   SELECT nma05 INTO l_oob.oob11 FROM nma_file
        #    WHERE nma01 = l_ryd05
        #   IF g_aza.aza63 = 'Y' THEN
        #       SELECT nma051 INTO l_oob.oob111 FROM nma_file
        #        WHERE nma01 = l_ryd05
         IF l_ooe02 IS NOT NULL THEN  #款別有對應的沒默認銀行
            LET l_oob.oob17 = l_ooe02
            SELECT nma05 INTO l_oob.oob11 FROM nma_file
             WHERE nma01 = l_ooe02
            IF g_aza.aza63 = 'Y' THEN
                SELECT nma051 INTO l_oob.oob111 FROM nma_file
                 WHERE nma01 = l_ooe02
        #FUN-9C0168--mod--end
            END IF
         ELSE
            #CALL s_errmsg('ryd05','A','sel ryd05 err','alm-732',1)   #FUN-9C0168
            CALL s_errmsg('ooe02','A','sel ooe02 err','alm-732',1)   #FUN-9C0168         
            LET g_success = 'N'
         END IF 
         SELECT oow17 INTO l_oow17 FROM oow_file WHERE oow00 = '0'
         IF STATUS OR cl_null(l_oow17) THEN
            CALL s_errmsg('oow17',g_n_oma01,'sel oow_file','axr-149',1)            
            LET g_success = 'N'
            RETURN
         END IF  
         LET l_oob.oob18 = l_oow17
         SELECT nmc05 INTO l_oob.oob21 FROM nmc_file WHERE nmc01 = l_oob.oob18
      END IF 
      IF l_rxx.rxx02 = '05' THEN      
         LET l_oob.oob04 = 'E' 
        #FUN-9C0168--mod--str--
        #IF l_ryd05 IS NOT NULL THEN   #有款別對應的銀行
        #   LET l_oob.oob17 = l_ryd05
        #   SELECT nma05 INTO l_oob.oob11 FROM nma_file
        #    WHERE nma01 = l_ryd05
        #   IF g_aza.aza63 = 'Y' THEN
        #       SELECT nma051 INTO l_oob.oob111 FROM nma_file
        #        WHERE nma01 = l_ryd05
         IF l_ooe02 IS NOT NULL THEN   #有款別對應的銀行
            LET l_oob.oob17 = l_ooe02
            SELECT nma05 INTO l_oob.oob11 FROM nma_file
             WHERE nma01 = l_ooe02
            IF g_aza.aza63 = 'Y' THEN
                SELECT nma051 INTO l_oob.oob111 FROM nma_file
                 WHERE nma01 = l_ooe02
        #FUN-9C0168--mod--end
            END IF
         ELSE
            #CALL s_errmsg('ryd05','A','sel ryd05 err','alm-732',1) #FUN-9C0168
            CALL s_errmsg('ooe02','A','sel ooe02 err','alm-732',1) #FUN-9C0168           
            LET g_success = 'N'
         END IF 
      END IF
      IF l_rxx.rxx02 = '04' THEN #券 
         LET l_oob.oob04 = 'Q'
        #FUN-9C0168--mod--str--
        #IF l_ryd05 IS NOT NULL THEN   #有款別對應的銀行
        #   LET l_oob.oob17 = l_ryd05
        #   SELECT nma05 INTO l_oob.oob11 FROM nma_file
        #    WHERE nma01 = l_ryd05
        #   IF g_aza.aza63 = 'Y' THEN
        #       SELECT nma051 INTO l_oob.oob111 FROM nma_file
        #        WHERE nma01 = l_ryd05
         IF l_ooe02 IS NOT NULL THEN   #有款別對應的銀行
            LET l_oob.oob17 = l_ooe02
            SELECT nma05 INTO l_oob.oob11 FROM nma_file
             WHERE nma01 = l_ooe02
            IF g_aza.aza63 = 'Y' THEN
                SELECT nma051 INTO l_oob.oob111 FROM nma_file
                 WHERE nma01 = l_ooe02
        #FUN-9C0168--mod--end
            END IF
         ELSE
            #CALL s_errmsg('ryd05','A','sel ryd05 err','alm-732',1) #FUN-9C0168
            CALL s_errmsg('ooe02','A','sel ooe02 err','alm-732',1) #FUN-9C0168           
            LET g_success = 'N'
         END IF 
      END IF
      SELECT aag05 INTO l_aag05 FROM aag_file WHERE aag01 = l_oob.oob11 AND aag00 = g_bookno1    
      IF l_aag05 = 'Y' THEN
         LET l_oob.oob13 = g_ooa.ooa15
      ELSE
         LET l_oob.oob13 = NULL        
      END IF
 
      INSERT INTO oob_file VALUES(l_oob.*)
      IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
         CALL s_errmsg('','','ins oob err',SQLCA.SQLCODE,1)
         LET g_success = 'N'
         RETURN 
      END IF
 
   END FOREACH
END FUNCTION
 
FUNCTION p304_upd_ooa()
   DEFINE  l_ooa31d      LIKE   ooa_file.ooa31d
   DEFINE  l_ooa31c      LIKE   ooa_file.ooa31c
   DEFINE  l_ooa32d      LIKE   ooa_file.ooa32d
   DEFINE  l_ooa32c      LIKE   ooa_file.ooa32c
 
   SELECT azi03,azi04 INTO t_azi03,t_azi04  FROM azi_file
    WHERE azi01 = g_oma.oma23
   SELECT SUM(oob09),SUM(oob10) INTO l_ooa31d,l_ooa32d
     FROM oob_file  WHERE oob01 = g_ooa.ooa01 AND oob03 = '1'
   CALL cl_digcut(l_ooa31d,t_azi04) RETURNING l_ooa31d
   CALL cl_digcut(l_ooa32d,g_azi04) RETURNING l_ooa32d
   SELECT SUM(oob09),SUM(oob10) INTO l_ooa31c,l_ooa32c
     FROM oob_file  WHERE oob01 = g_ooa.ooa01 AND oob03 = '2'
   CALL cl_digcut(l_ooa31c,t_azi04) RETURNING l_ooa31c
   CALL cl_digcut(l_ooa32c,g_azi04) RETURNING l_ooa32c
 
   UPDATE ooa_file SET ooa31d = l_ooa31d,
                       ooa31c = l_ooa31c,
                       ooa32d = l_ooa32d,
                       ooa32c = l_ooa32c
                 WHERE ooa01 = g_ooa.ooa01
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('oha01',g_oha01,'upd ooa_file',SQLCA.SQLCODE,1)
      LET g_success = 'N'
   END IF
END FUNCTION
 
FUNCTION p304_g_entry()
   DEFINE  l_t        LIKE    ooy_file.ooyslip
   DEFINE  l_ooydmy1  LIKE    ooy_file.ooydmy1
 
     LET l_t = s_get_doc_no(g_ooa.ooa01)
     SELECT * INTO g_ooy.*  FROM ooy_file  WHERE  ooyslip = l_t
     LET l_ooydmy1 = ''
     SELECT ooydmy1  INTO l_ooydmy1  FROM ooy_file
      WHERE ooyslip = l_t
     IF STATUS  THEN
        CALL cl_err(l_t,STATUS,0)
     END IF
     IF l_ooydmy1 = 'Y' THEN
        CALL s_t400_gl(g_ooa.ooa01,'0')
        IF g_aza.aza63 = 'Y' THEN
           CALL s_t400_gl(g_ooa.ooa01,'1')
        END IF
     END IF
END FUNCTION
 
FUNCTION p304_y_upd()
    DEFINE   l_cnt  LIKE    type_file.num5
 
    SELECT * INTO g_ooa.* FROM ooa_file WHERE ooa01 = g_ooa.ooa01
    IF g_ooa.ooa32d != g_ooa.ooa32c THEN
       CALL s_errmsg('',g_oha01,'','axr-203',1) 
       LET g_success = 'N'
       RETURN
    END IF
 
    IF g_ooa.ooa02 <= g_ooz.ooz09 THEN
       CALL s_errmsg('',g_oha01,'','axr-164',1) 
       LET g_success = 'N'
       RETURN
    END IF
    
    SELECT COUNT(*) INTO l_cnt FROM oob_file
     WHERE oob01 = g_ooa.ooa01
    IF l_cnt = 0 THEN
       CALL s_errmsg('',g_oha01,'','mfg-009',1) 
       LET g_success = 'N'
       RETURN
    END IF 
 
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt
      FROM oob_file,oma_file
#FUN-A10019--mod--str--
#  WHERE ( YEAR(oma02) > YEAR(g_ooa.ooa02)
#     OR (YEAR(oma02) = YEAR(g_ooa.ooa02)
#    AND MONTH(oma02) > MONTH(g_ooa.ooa02)) )
    WHERE oma02>g_ooa.ooa02
#FUN-A10019--mod--end
      AND oob03 = '2'
      AND oob04 = '1'
      AND oob06 = oma01
      AND oob01 = g_ooa.ooa01
   #IF l_cnt = 0 THEN   #FUN-A10019
   IF l_cnt > 0 THEN    #FUN-A10019
      CALL s_errmsg('',g_oha01,'','axr-371',1)
      LET g_success = 'N'
      RETURN
   END IF
 
    IF g_ooy.ooydmy1 = 'Y' THEN
       CALL s_chknpq(g_ooa.ooa01,'AR',1,'0',g_bookno1)
       IF g_aza.aza63='Y' AND g_success='Y' THEN
          CALL s_chknpq(g_ooa.ooa01,'AR',1,'1',g_bookno2)
       END IF
       LET g_dbs_new = g_dbs CLIPPED,'.'
       LET g_plant_new = g_plant    #FUN-A50102
    END IF 
 
    IF g_success = 'N' THEN RETURN END IF
    CALL p304_y1()
END FUNCTION
      
FUNCTION p304_y1()
   DEFINE  n         LIKE       type_file.num5
   DEFINE  l_cnt     LIKE       type_file.num5
   DEFINE  l_flag    LIKE       type_file.chr1
 
     UPDATE  ooa_file  SET ooaconf = 'Y',ooa34 = '1'  WHERE ooa01 = g_ooa.ooa01  #No.TQC-9C0057
     IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
        CALL s_errmsg('',g_oha01,'upd ooa err',STATUS,1)
        LET g_success = 'N'
        RETURN
     END IF
     CALL p304_hu2()
     IF g_success = 'N' THEN
        RETURN
     END IF
 
     INITIALIZE b_oob.* TO NULL
     DECLARE  p304_y1_c  CURSOR FOR
     SELECT * FROM oob_file  WHERE  oob01 = g_ooa.ooa01 ORDER BY oob02
     LET l_cnt = 1
     LET l_flag = '0'
     CALL s_showmsg_init()
     FOREACH p304_y1_c  INTO b_oob.*
        IF STATUS THEN
           CALL s_errmsg('oob01',g_ooa.ooa01,'foreach',STATUS,1)
           LET g_success = 'N'
           RETURN 
        END IF
 
        IF b_oob.oob03 = '1' AND b_oob.oob04 = '3' THEN
           CALL p304_bu_13()
        END IF
#       IF g_ooa.ooa37 = 'Y'  THEN  #  a生nme_file   #FUN-A40076 Mark
        IF g_ooa.ooa37 = '2'  THEN                   #FUN-A40076 Add
           IF b_oob.oob03 = '2' AND b_oob.oob04 = 'A'  THEN
              CALL p304_bu_2A()
           END IF
        END IF
     END FOREACH
END FUNCTION
 
FUNCTION p304_hu2()            #最近交易日
   DEFINE l_occ RECORD LIKE occ_file.*
 
   SELECT * INTO l_occ.* FROM occ_file WHERE occ01=g_ooa.ooa03
   IF STATUS THEN 
      CALL s_errmsg('ooc01',g_ooa.ooa03,'sel ooc err',STATUS,1)
      LET g_success='N' 
      RETURN 
   END IF
   IF l_occ.occ16 IS NULL THEN LET l_occ.occ16=g_ooa.ooa02 END IF
   IF l_occ.occ174 IS NULL OR l_occ.occ174 < g_ooa.ooa02 THEN
      LET l_occ.occ174=g_ooa.ooa02
   END IF
   UPDATE occ_file SET * = l_occ.* WHERE occ01=g_ooa.ooa03
   IF STATUS THEN 
      CALL s_errmsg('ooc01',g_ooa.ooa03,'upd ooc err',STATUS,1)
      LET g_success='N' 
      RETURN
   END IF
END FUNCTION
 
FUNCTION p304_bu_13()                  #更新待抵帳款檔 (oma_file)
  DEFINE l_omaconf      LIKE oma_file.omaconf,   #No.FUN-680123 VARCHAR(1),            #
         l_omavoid      LIKE oma_file.omavoid,   #No.FUN-680123 VARCHAR(1),
         l_cnt          LIKE type_file.num5      #No.FUN-680123 smallint
  DEFINE l_oma00        LIKE oma_file.oma00
  DEFINE tot4,tot4t     LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #TQC-5B0171
  DEFINE tot5,tot6      LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #No.FUN-680022 add
  DEFINE tot8           LIKE type_file.num20_6   #No.FUN-680123 DEC(20,6)  #No.FUN-680022 add
  DEFINE l_omc10        LIKE omc_file.omc10,#No.FUN-680022 add
         l_omc11        LIKE omc_file.omc11,#No.FUN-680022 add
         l_omc13        LIKE omc_file.omc13 #No.FUN-680022 add
 
#  同參考單號若有一筆以上僅沖款一次即可 --------------
   SELECT COUNT(*) INTO l_cnt FROM oob_file
    WHERE oob01=b_oob.oob01
      AND oob02<b_oob.oob02
      AND oob03='1'
      AND oob04='3'  
      AND oob06=b_oob.oob06
   IF l_cnt>0 THEN RETURN END IF
 
#  預防在收款沖帳確認前,多沖待抵貨款
   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file,ooa_file
    WHERE oob06=b_oob.oob06 AND oob01=ooa01
      AND oob03='1' AND oob04 = '3' AND ooaconf='Y'
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF
 
   SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
      AND oob03='1'  AND oob04 = '3' AND ooaconf='Y'
   IF cl_null(tot5) THEN LET tot5 = 0 END IF
   IF cl_null(tot6) THEN LET tot6 = 0 END IF
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = b_oob.oob07
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2
 
   LET g_sql="SELECT oma00,omavoid,omaconf,oma54t,oma56t ",
             #"  FROM ",g_dbs_new CLIPPED,"oma_file",
             "  FROM ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
             " WHERE oma01=?"
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102  
   PREPARE p304_bu_13_p1 FROM g_sql
   DECLARE p304_bu_13_c1 CURSOR FOR p304_bu_13_p1
   OPEN p304_bu_13_c1 USING b_oob.oob06
   FETCH p304_bu_13_c1 INTO l_oma00,l_omavoid,l_omaconf,un_pay1,un_pay2
   IF l_omavoid='Y' THEN
      CALL s_errmsg(' ',' ','b_oob.oob06','axr-103',1) LET g_success = 'N' RETURN   #NO.FUN-710050
   END IF
   IF l_omaconf='N' THEN
      CALL s_errmsg(' ',' ','b_oob.oob06','axr-104',1) LET g_success = 'N' RETURN   #NO.FUN-710050
   END IF
   IF cl_null(un_pay1) THEN LET un_pay1 = 0 END IF
   IF cl_null(un_pay2) THEN LET un_pay2 = 0 END IF
   #取得衝帳單的待扺金額
   CALL p304_mntn_offset_inv(b_oob.oob06) RETURNING tot4,tot4t
   CALL cl_digcut(tot4,t_azi04) RETURNING tot4
   CALL cl_digcut(tot4t,g_azi04) RETURNING tot4t
   IF g_ooz.ooz07 ='N' OR b_oob.oob07 = g_aza.aza17 THEN
      IF un_pay1 < tot1+tot4 OR un_pay2 < tot2+tot4t THEN
      CALL s_errmsg(' ',' ','un_pay<pay#1','axr-196',1) LET g_success = 'N' RETURN   #NO.FUN-710050
      END IF
   END IF
 
   SELECT SUM(oob09),SUM(oob10) INTO tot1,tot2 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06 AND oob01=ooa01  AND ooaconf = 'Y'
      AND oob03='1'  AND oob04 = '3'
   IF cl_null(tot1) THEN LET tot1 = 0 END IF
   IF cl_null(tot2) THEN LET tot2 = 0 END IF
   	
   SELECT SUM(oob09),SUM(oob10) INTO tot5,tot6 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06 AND oob01=ooa01 AND oob19=b_oob.oob19
      AND ooaconf = 'Y' AND oob03='1'  AND oob04 = '3'
   IF cl_null(tot5) THEN LET tot5 = 0 END IF
   IF cl_null(tot6) THEN LET tot6 = 0 END IF
       
   SELECT omc10,omc11,omc13 INTO l_omc10,l_omc11,l_omc13 FROM omc_file 
    WHERE omc01=b_oob.oob06 AND omc02 = b_oob.oob19
   IF cl_null(l_omc10) THEN LET l_omc10=0 END IF
   IF cl_null(l_omc11) THEN LET l_omc11=0 END IF
   IF cl_null(l_omc13) THEN LET l_omc13=0 END IF
   IF g_ooz.ooz07 ='Y' AND b_oob.oob07 != g_aza.aza17 THEN
      #取得未沖金額
      CALL s_g_np('1',l_oma00,b_oob.oob06,0          ) RETURNING tot3
      #未衝金額扣除待扺
      LET tot3 = tot3 - tot4t
   ELSE
      LET tot3 = un_pay2 - tot2 - tot4t
   END IF
   #LET g_sql="UPDATE ",g_dbs_new CLIPPED,"oma_file SET oma55=?,oma57=?,oma61=? ",
   LET g_sql="UPDATE ",cl_get_target_table(g_plant_new,'oma_file'), #FUN-A50102
             " SET oma55=?,oma57=?,oma61=? ",
             " WHERE oma01=? "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql 
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
   PREPARE p304_bu_13_p2 FROM g_sql
   LET tot1 = tot1 + tot4
   LET tot2 = tot2 + tot4t
   CALL cl_digcut(tot1,t_azi04) RETURNING tot1     
   CALL cl_digcut(tot2,g_azi04) RETURNING tot2 
   EXECUTE p304_bu_13_p2 USING tot1, tot2, tot3, b_oob.oob06  #NO.A048
   IF STATUS THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57',STATUS,1)              #NO.FUN-710050
      LET g_success = 'N' 
      RETURN
   END IF
   IF SQLCA.SQLERRD[3]=0 THEN
      CALL s_errmsg('oma01',b_oob.oob06,'upd oma55,57','axr-198',1) LET g_success = 'N' RETURN   #NO.FUN-710050
   END IF
   IF SQLCA.sqlcode = 0 THEN
      CALL p304_omc(l_oma00)   #No.MOD-930140
   END IF
END FUNCTION
 
FUNCTION p304_mntn_offset_inv(p_oob06)
   DEFINE p_oob06   LIKE oob_file.oob06,
          l_oot04t  LIKE oot_file.oot04t,
          l_oot05t  LIKE oot_file.oot05t
 
   SELECT SUM(oot04t),SUM(oot05t) INTO l_oot04t,l_oot05t
     FROM oot_file
    WHERE oot03 = p_oob06
   IF cl_null(l_oot04t) THEN LET l_oot04t = 0 END IF
   IF cl_null(l_oot05t) THEN LET l_oot05t = 0 END IF
   RETURN l_oot04t,l_oot05t
END FUNCTION
 
FUNCTION p304_omc(p_oma00) 
DEFINE   l_omc10           LIKE omc_file.omc10
DEFINE   l_omc11           LIKE omc_file.omc11
DEFINE   l_omc13           LIKE omc_file.omc13
DEFINE   l_oob09           LIKE oob_file.oob09   #MOD-830097
DEFINE   l_oob10           LIKE oob_file.oob10   #MOD-830097
DEFINE   l_oox10           LIKE oox_file.oox10   #No.MOD-930140
DEFINE   p_oma00           LIKE oma_file.oma00   #No.MOD-930140
 
   LET l_oox10 = 0 
   SELECT SUM(oox10) INTO l_oox10 FROM oox_file 
    WHERE oox00 = 'AR'
      AND oox03 = b_oob.oob06 
      AND oox041 = b_oob.oob19
   IF cl_null(l_oox10) THEN LET l_oox10 = 0 END IF 
   SELECT SUM(oob09),SUM(oob10) INTO l_oob09,l_oob10 FROM oob_file, ooa_file
    WHERE oob06=b_oob.oob06 AND oob19 = b_oob.oob19 
      AND oob01=ooa01  AND ooaconf = 'Y'
      AND ((oob03='1' AND oob04='3') OR (oob03='2' AND oob04='1'))
   IF cl_null(l_oob09) THEN LET l_oob09 = 0 END IF
   IF cl_null(l_oob10) THEN LET l_oob10 = 0 END IF
   #LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc10=?,omc11=? ", 
  LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
            " SET omc10=?,omc11=? ",  
             " WHERE omc01=? AND omc02=? "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102  
   PREPARE p304_bu_13_p3 FROM g_sql
   EXECUTE p304_bu_13_p3 USING l_oob09,l_oob10,b_oob.oob06,b_oob.oob19
   #LET g_sql=" UPDATE ",g_dbs_new CLIPPED,"omc_file SET omc13=omc09-omc11+ ",l_oox10,   #No.MOD-930140 
   LET g_sql=" UPDATE ",cl_get_target_table(g_plant_new,'omc_file'), #FUN-A50102
             " SET omc13=omc09-omc11+ ",l_oox10,
             " WHERE omc01=? AND omc02=? "
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql        #FUN-920032
   CALL cl_parse_qry_sql(g_sql,g_plant_new) RETURNING g_sql #FUN-A50102 
   PREPARE p304_bu_13_p4 FROM g_sql
   EXECUTE p304_bu_13_p4 USING b_oob.oob06,b_oob.oob19
END FUNCTION
 
FUNCTION p304_bu_2A() 
   DEFINE l_nme  RECORD   LIKE nme_file.* 
#FUN-B30166--add--str
   DEFINE l_year     LIKE type_file.chr4
   DEFINE l_month    LIKE type_file.chr4
   DEFINE l_day      LIKE type_file.chr4
   DEFINE l_dt       LIKE type_file.chr20
   DEFINE l_date1    LIKE type_file.chr20
   DEFINE l_time     LIKE type_file.chr20
   DEFINE l_nme27    LIKE nme_file.nme27
#FUN-B30166--add--end
 
   INITIALIZE l_nme.* TO NULL
   LET l_nme.nme00 = '0' 
   LET l_nme.nme01 = b_oob.oob17
   LET l_nme.nme02 = g_ooa.ooa02
   LET l_nme.nme03 = b_oob.oob18
   LET l_nme.nme04 = b_oob.oob09
   LET l_nme.nme05 = b_oob.oob12  
   LET l_nme.nme07 = g_ooa.ooa24
   LET l_nme.nme08 = b_oob.oob10
   LET l_nme.nme10 = g_ooa.ooa33
   LET l_nme.nme12 = b_oob.oob01
   LET l_nme.nme13 = g_ooa.ooa032
   LET l_nme.nme14 = b_oob.oob21
   LET l_nme.nme15 = b_oob.oob13
   LET l_nme.nme16 = g_ooa.ooa02
   LET l_nme.nmeacti='Y'
   LET l_nme.nmeuser=g_user
   LET l_nme.nmegrup=g_grup
   LET l_nme.nmedate=TODAY
   LET l_nme.nme21=b_oob.oob02
   LET l_nme.nme22='01'
   LET l_nme.nme23=b_oob.oob04
   LET l_nme.nme24='9'
   LET l_nme.nmelegal = g_legal #FUN-980011 add
 
   LET l_nme.nmeoriu = g_user      #No.FUN-980030 10/01/04
   LET l_nme.nmeorig = g_grup      #No.FUN-980030 10/01/04
#FUN-B30166--add--str
   LET l_date1 = g_today
   LET l_year = YEAR(l_date1)USING '&&&&'
   LET l_month = MONTH(l_date1) USING '&&'
   LET l_day = DAY(l_date1) USING  '&&'
   LET l_time = TIME(CURRENT)
   LET l_dt   = l_year CLIPPED,l_month CLIPPED,l_day CLIPPED,
                l_time[1,2],l_time[4,5],l_time[7,8]
   SELECT MAX(nme27) + 1 INTO l_nme.nme27 FROM nme_file
    WHERE nme27[1,14] = l_dt
   IF cl_null(l_nme.nme27) THEN
      LET l_nme.nme27 = l_dt,'000001'
   END if
#FUN-B30166--add--end
   INSERT INTO nme_file VALUES(l_nme.*)
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
      CALL s_errmsg('oob06','','ins nme',SQLCA.sqlcode,1)
      LET g_success = 'N'
   END IF
   CALL s_flows_nme(l_nme.*,'1',g_plant)   #No.FUN-B90062     
END FUNCTION
#FUN-960141 add end
#FUN-C60036--add--str
FUNCTION p304_axrt320()
   DEFINE l_ooyacti LIKE ooy_file.ooyacti
   DEFINE   li_result LIKE type_file.num5
   OPEN WINDOW p304a_w AT p_row,p_col WITH FORM "axr/42f/axrp304a"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("axrp304a")
   CALL cl_load_act_sys("axrp304a")
   CALL cl_load_act_list("axrp304a")
   CALL cl_set_comp_visible("oma01,oma13",FALSE)
   CLEAR FORM
   INPUT BY NAME g_no1 WITHOUT DEFAULTS    
      
      AFTER FIELD g_no1
         IF NOT cl_null(g_no1) THEN
            LET l_ooyacti = NULL
            SELECT ooyacti INTO l_ooyacti FROM ooy_file
             WHERE ooyslip = g_no1
            IF l_ooyacti <> 'Y' THEN
               CALL cl_err(g_no1,'axr-956',1)
               NEXT FIELD g_no1
            END IF
            CALL s_check_no("axr",g_no1,"","21","","","")   
            RETURNING li_result,g_no1
            
            IF (NOT li_result) THEN
               NEXT FIELD g_no1
            END IF
         END IF
      ON ACTION CONTROLR
        CALL cl_show_req_fields()

      ON ACTION CONTROLG
        CALL cl_cmdask()
      ON ACTION CONTROLP
         CASE
             WHEN INFIELD(g_no1) 
                CALL q_ooy(FALSE,FALSE,g_no1,'21','AXR') RETURNING g_no1   
                DISPLAY BY NAME g_no1
            END CASE

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      ON ACTION about         
         CALL cl_about()      

      ON ACTION help         
         CALL cl_show_help()  

      ON ACTION exit                            
         LET INT_FLAG = 1
         EXIT INPUT

   END INPUT

   IF INT_FLAG THEN
      CLOSE WINDOW p304a_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time
      EXIT PROGRAM
   END IF
   CLOSE WINDOW p304a_w
END FUNCTION 
#FUN-C60036--add--end

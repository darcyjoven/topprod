# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: sasrt300.4gl
# Descriptions...: 生產報工維護作業
# Date & Author..: 06/01/24 By kim
# Modify.........: No.TQC-630072 06/03/07 By Melody 指定單據編號、執行功能(g_argv3)
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: No.FUN-660110 06/06/15 By Sarah 輸入srg16工單號碼時需檢查是否為15.試產工單,若是需警告並要求重新輸入
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.FUN-670103 06/07/28 By kim   GP3.5 利潤中心
# Modify.........: No.TQC-680008 06/08/17 By kim   asrt300a的欄位輸入控制
# Modify.........: No.FUN-680010 06/08/29 by Joe   SPC整合專案-自動新增 QC 單據
# Modify.........: No.FUN-680130 06/09/19 By Xufeng 字段類型定義改為LIKE     
# Modify.........: No.FUN-6A0166 06/11/10 By jamie FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.FUN-6B0061 06/11/27 By kim 增加列印功能
# Modify.........: No.CHI-6C0001 06/12/01 By kim 列印的功能修改
# Modify.........: No.CHI-710057 07/01/30 By kim 檢查工單是否發料,應該排除倒扣料
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730075 07/03/30 By kim 行業別架構
# Modify.........: No.MOD-740195 07/04/23 By kim 良品數+不良數+報廢數目前判斷不可大於發料套數，應改為同生產入庫單不可大於最小套數，不然會不能報工但可以入庫的狀況
# Modify.........: No.TQC-740154 07/05/04 By kim 工單報工時,單據別抓ASF系統的J報工單
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760063 07/06/15 By rainy 新增後馬上列印無法印出，需重新查出才能印
# Modify.........: No.MOD-7B0001 07/10/31 By Pengu 單身有填報廢量時,並沒有回寫asfi301單頭的報廢數量
# Modify.........: No.MOD-7B0122 07/11/13 By Pengu 取消確認時應卡報工日期不可小於關帳日期
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/16 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.MOD-7B0141 07/11/20 By Carol 數量計算SQL邏輯調整
# Modify.........: No.TQC-7C0117 07/12/08 By Rayven 單身不可選委外工單做報工
# Modify.........: No.FUN-7C0034 07/12/11 By sherry 報表改由CR輸出
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.CHI-830023 08/03/17 By Sarah asft300無法列印
# Modify.........: No.FUN-840042 08/04/16 By TSD.Wind 自定欄位功能修改
# Modify.........: No.FUN-840148 08/06/12 By Sherry 可轉拆件入庫功能修改
# Modify.........: No.MOD-860102 08/06/13 By claire asft300轉FQC會失敗
# Modify.........: No.FUN-860069 08/06/18 By Sherry 增加輸入日期(sfu14,ksc14)
# Modify.........: No.MOD-830181 08/07/04 By Pengu 產生入庫單時不判斷srg18的合理性
# Modify.........: No.FUN-840232 08/08/01 By sherry 報工單(asft300) 確認時,增加回寫實際開工日
# Modify.........: No.FUN-860032 08/08/04 By sherry 增加選擇列印單筆
# Modify.........: No.MOD-880048 08/08/12 By Pengu srg04開窗查詢時應改呼叫q_gfe
# Modify.........: No.TQC-890055 08/09/26 By claire s_newaql加傳入pmh21,pmh22
# Modify.........: No.CHI-8A0001 08/11/04 By tsai_yen 寫ora取代"只能使用相同群的資料"的MATCHES字串
# Modify.........: No.MOD-8B0086 08/11/10 By chenyu 工單沒有取替代時，讓sfs27=sfa27
# Modify.........: No.MOD-8A0059 08/11/15 By Pengu tm.choice1 default值應參考sma896參數
# Modify.........: No.MOD-8B0206 08/11/20 By claire asf-990 新增,判斷有run card資料時,不可自動產生入庫單
# Modify.........: No.TQC-8B0053 08/11/27 By claire 調整程式
# Modify.........: No.MOD-8C0260 08/12/29 By claire 刪除時,未將不良原因檔刪除
# Modify.........: No.FUN-910076 09/02/02 By jan 增加srg19欄位
# Modify.........: No.MOD-920096 09/02/06 By claire 新增後按放棄時,會將單身資料清空
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153
# Modify.........: No.MOD-920226 09/02/19 By claire qcf36-qcf41沒有值應帶出
# Modify.........: No.FUN-910079 09/02/20 By ve007 增加品管類型的邏輯
# Modify.........: No.FUN-960007 09/06/03 By chenmoyan global檔內沒有定義rowid變量
# Modify.........: No.MOD-960134 09/06/10 By mike 將l_wc=g_wc CLIPPED改為l_wc=l_wc CLIPPED
# Modify.........: No.TQC-970372 09/08/06 By lilingyu 工單編號錄入無效值,仍然可以保存,需控管錄入之存在于sfb_file
# Modify.........: No.FUN-980008 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-990034 09/09/04 By mike t300_b()段中,l_sfbacti的like field有異.請修正   
# Modify.........: No:CHI-990050 09/11/02 By Smapmin 報工日期必須大於等於開單日期
# Modify.........: No:MOD-980050 09/11/25 By sabrina 單身選(srg13)2.聯產品時,srg14(入庫產品料號)所開窗查詢資料應以q_bmm為主
# Modify.........: No:CHI-880008 09/11/25 By sabrina 已結案工單不允許在報工
# Modify.........: No:FUN-9C0073 10/01/05 By chenls  程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20037 10/03/15 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:TQC-A30099 10/03/19 By destiny  当为报工维护作业时将choice1设为'N'
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:MOD-A40057 10/04/13 By Sarah 新增FQC單時,qcf09及qcf091皆未給預設值
# Modify.........: No:MOD-A50150 10/05/24 By Sarah 若已產生入庫單後再點選轉FQC/入庫單時應提示訊息且不開啟畫面
# Modify.........: No:FUN-A60027 10/06/17 by sunchenxu 製造功能優化-平行制程（批量修改）
# Modify.........: No:MOD-A80032 10/08/06 By sabrina 新增時，生產日期應default today
# Modify.........: No:MOD-A90174 10/09/28 By sabrina 輸入的工單不可為"預測工單"
# Modify.........: No.FUN-AA0059 10/10/27 By chenying 料號開窗控管
# Modify.........: No.FUN-AA0062 10/11/05 By yinhy 倉庫開窗控
# Modify.........: No:TQC-AB0307 10/12/06 by jan 領料單別開窗應只開出領料單
# Modify.........: No:CHI-980043 10/12/10 By Summer 新增入庫單時應判斷是否為新的料倉儲批
# Modify.........: No:TQC-AC0255 10/12/17 By jan srf01自動編碼有誤
# Modify.........: NO.TQC-AC0294 10/12/20 By liweie sfu01開窗/檢查要排除smy73='Y'的單據
# Modify.........: No:TQC-B30027 11/03/09 By destiny 生产报工时如果料件需检验则在生成入库单时提示需先生成FQC单
# Modify.........: No:MOD-B30043 11/03/17 By wujie   存在每日工时资料时不可删除
# Modify.........: No.FUN-A80128 11/03/22 By Mandy 因asft620 新增EasyFlow整合功能影響INSERT INTO sfu_file
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 因asfi510 新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No:FUN-B10037 11/05/11 By abby 與MES整合時，不允許使用產生入庫/FQC(ACTION)的功能
# Modify.........: No:MOD-B40144 11/05/11 By vmpire 領料單開窗的資料有誤。應call q_sfp1
# Modify.........: No.CHI-B40058 11/05/18 By JoHung 修改有使用到apy/gpy模組p_ze資料的程式
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.TQC-B60062 11/06/13 By lixia 修改生成FQC單的提示
# Modify.........: No.TQC-B60090 11/06/19 By lixh 報錯后增加管控
# Modify.........: No.FUN-B60124 11/06/30 By xianghui 新增時給單身欄位srg13預設值為1
# Modify.........: No:FUN-B70074 11/07/21 By fengrui 添加行業別表的新增於刪除(sfsi_file by lixh1(sfsi_file by lixh1))
# Modify.........: No.FUN-B80063 11/08/05 By fanbj ROLLBACK WORK下方的SQLCA.sqlcode是另外一組的,在五行以外
# Modify.........: No:TQC-B70054 11/08/04 By Carrier asrt300a中的choice1生成FQC及choice2生成入库单不能同时勾选
# Modify.........: No.FUN-910088 11/12/09 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0085 11/12/13 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-BB0084 11/12/14 By lixh1 增加數量欄位小數取位(sfs_file)
# Modify.........: No:FUN-BB0086 12/01/05 By tanxc 增加數量欄位小數取位
# Modify.........: NO.FUN-BC0104 12/01/11 By xianghui 增加是否依QC結果產生入庫單
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: NO.TQC-C20240 12/02/17 By xianghui 依QC產生入庫單時應FOREACH每筆單身產生入庫單
# Modify.........: NO.TQC-C20248 12/02/21 By lixh1 回寫srg11(入庫單號)
# Modify.........: No.TQC-C20239 12/02/21 By xianghui 領料單產生ACTION若果產生失敗,第二次點擊此ACTION時會產生一個
#                                                     領料單號,但實際沒有產生的領料單
# Modify.........: No.TQC-C20183 12/02/21 By fengrui 數量欄位小數取位處理
# Modify.........: No.TQC-C20428 12/02/23 By lixh1 執行“轉FQC/入庫單”時，程式down出  
# Modify.........: No.TQC-C20465 12/02/24 By lixh1 INSERT INTO sfv_file 時如果倉儲批為null則給' '
# MOdify.........: No.MOD-C30662 12/03/14 By chenjing 調整開啟FQC/入庫單時一般入庫單別和拆件入庫單別同時輸入問題
# Modify.........: No:CHI-C30124 12/04/18 By ck2yuan 轉入庫單預設倉庫若為空,應先抓sfb30,若再沒有則帶ima35
# Modify.........: No:CHI-C30044 12/05/11 By bart "轉FQC/入庫單"Action 加判斷轉FQC的數量加該工單已產生之FQC數量不可大於工單生產量
# Modify.........: No.CHI-C30002 12/05/24 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.MOD-C60065 12/06/07 By suncx 新增缺省庫位開窗
# Modify.........: No.CHI-C30107 12/06/13 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.TQC-C70008 12/07/02 By jan 修正sql錯誤
# Modify.........: No.TQC-C70095 12/07/16 By fengrui 修改程式點選FQC等按鈕down出問題
# Modify.........: No.FUN-C70014 12/07/16 By suncx 新增sfs014
# Modify.........: No.FUN-C70037 12/08/16 By lixh1 CALL s_minp增加傳入日期參數
# Modify.........: No.FUN-C90077 12/09/18 By lixh1 數量欄位和審核時增加對數量的控管
# Modify.........: No.TQC-C90111 12/09/28 By lixh1 精簡程式
# Modify.........: No.MOD-C90077 12/10/26 By Elise 轉FQC單時，qc單單身的檢驗量沒有自動帶出值來
# Modify.........: No.MOD-CA0187 12/11/06 By Elise 推算抽驗量應考慮級數
# Modify.........: No:CHI-C80041 12/12/19 By bart 刪除單頭
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善
# Modify.........: No.CHI-CA0048 13/01/11 By Elise 在確認段加上asf-041控卡
# Modify.........: No.MOD-D10074 13/01/17 By bart 控卡sfb28<'2'才可報工
# Modify.........: No.MOD-D10197 13/01/25 By bart 130122 可輸入24:00，且工時與機時不可小於0。
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action  
# Modify.........: No:MOD-D20111 13/02/26 By Alberti 修改轉FQC/入庫單送驗量qcf22的部份
# Modify.........: No:DEV-D30045 13/03/26 By TSD.JIE 
#                  1.條碼產生時機點相關程式-增加"條碼查詢"
#                  2.條碼產生時機點相關程式-增加"條碼列印"
#                  3.條碼產生時機點相關程式-增加"條碼產生"
#                  3.調整確認自動產生barcode
#                  4.調整取消確認自動作廢barcode
# Modify.........: No:FUN-D40030 13/04/08 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No.DEV-D30043 13/04/17 By TSD.JIE 調整條碼自動編號(s_gen_barcode2)與條碼手動編號(s_diy_barcode)產生先後順序
# Modify.........: No.DEV-D40015 13/04/18 By Nina 調整取消確認時條碼作廢的檢核與Transaction
# Modify.........: No.MOD-D90079 13/09/16 By suncx 倒扣料工单管控良品数量不能大于工单生成数量

DATABASE ds
 
GLOBALS "../../config/top.global"
GLOBALS "../4gl/sasrt300.global"

DEFINE g_srg04_t   LIKE srg_file.srg04   #No.FUN-BB0086

FUNCTION sasrt300(p_argv1,p_argv2,p_argv3)
DEFINE l_time LIKE type_file.chr8 ,      
       p_argv1  LIKE type_file.chr1,   #1:重複性生產報工  2:工單生產報工 #No.FUN-680130 VARCHAR(1)  
       p_argv2  LIKE sfu_file.sfu01,
       p_argv3  STRING
   WHENEVER ERROR CONTINUE
 
   LET g_forupd_sql = " SELECT * FROM srf_file WHERE srf01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t300_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1 = p_argv1
   LET g_argv2 = p_argv2
   LET g_argv3 = p_argv3
   
   CASE g_argv1
      WHEN "1"
         CALL cl_set_comp_visible("srg16",FALSE)
         
      WHEN "2"
         CALL cl_set_comp_entry("srg03",FALSE)
         CALL cl_set_comp_visible("srg17,srg18",FALSE)
      
   END CASE
   IF (g_aaz.aaz90='Y') AND (g_argv1='2') THEN
      CALL cl_set_comp_entry("srg930",FALSE)
   END IF
   CALL cl_set_comp_visible("srg930,gem02c",g_aaz.aaz90='Y') #FUN-670103
 
   IF g_aza.aza64 matches '[ Nn]' THEN
      CALL cl_set_comp_visible("srfspc",FALSE)
      CALL cl_set_act_visible("trans_spc",FALSE)
   ELSE 
      CALL cl_set_act_visible("trans_store_fqc",FALSE)
   END IF

   #DEV-D30045--add--begin
   IF g_prog <> 'asft300' OR g_aza.aza131 = 'N' THEN
      CALL cl_set_act_visible("barcode_gen,barcode_query,barcode_output", FALSE)
   END IF
   #DEV-D30045--add--end
 
   IF cl_null(g_argv3) THEN
   ELSE
      CASE g_argv3
         WHEN "query"
            LET g_action_choice = "query"
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
         WHEN "insert"
            LET g_action_choice = "insert"
            IF cl_chk_act_auth() THEN
               CALL t300_a()
            END IF
         OTHERWISE
               CALL t300_q()
      END CASE
   END IF
   
   CALL t300_menu()
END FUNCTION
 
FUNCTION t300_cs()
  DEFINE lc_qbe_sn   LIKE gbm_file.gbm01
 
  CLEAR FORM                             #清除畫面
  CALL g_srg.clear()
  IF NOT cl_null(g_argv2) THEN
     LET g_wc = " srf01 = '",g_argv2,"'"
     LET g_wc2 = " 1=1"
  ELSE 
     CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_srf.* TO NULL    #No.FUN-750051
     CONSTRUCT BY NAME g_wc ON            # 螢幕上取單頭條件
       srf01,srf02,srf03,srf04,srf05,srfconf,srfspc, #FUN-680010
       srf06,srfuser,srfgrup,srfmodu,srfdate, 
       srfud01,srfud02,srfud03,srfud04,srfud05,
       srfud06,srfud07,srfud08,srfud09,srfud10,
       srfud11,srfud12,srfud13,srfud14,srfud15
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(srf01)    #查詢單據性質
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_srf"
                IF g_argv1='1' THEN
                   LET g_qryparam.where = " srf07='1'" 
                ELSE
                   LET g_qryparam.where = " srf07='2'" 
                END IF
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srf01
                NEXT FIELD srf01
             WHEN INFIELD(srf03)    #查詢機台
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_eci"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srf03
             WHEN INFIELD(srf04) #班別
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_ecg"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srf04
             WHEN INFIELD(srf06) #領料單號
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
               #LET g_qryparam.form = "q_ecg"     #MOD-B40144 mark
                LET g_qryparam.form = "q_sfp1"    #MOD-B40144 add
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srf06
             OTHERWISE
                EXIT CASE
	  END CASE
 
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
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
 
     END CONSTRUCT
     IF INT_FLAG THEN RETURN END IF
 
     CONSTRUCT g_wc2 ON srg02,srg16,srg03,srg04,srg15,srg05,srg06,srg07,
                        srg08,srg09,srg10,srg19,srg11,srg12,srg13,srg14,srg930  #FUN-670103 #FUN-910076 add srg19
                        ,srgud01,srgud02,srgud03,srgud04,srgud05
                        ,srgud06,srgud07,srgud08,srgud09,srgud10
                        ,srgud11,srgud12,srgud13,srgud14,srgud15
             FROM s_srg[1].srg02,s_srg[1].srg16,s_srg[1].srg03,
                  s_srg[1].srg04,s_srg[1].srg15,s_srg[1].srg05,
                  s_srg[1].srg06,s_srg[1].srg07,s_srg[1].srg08,
                  s_srg[1].srg09,s_srg[1].srg10,s_srg[1].srg19,s_srg[1].srg11,  #FUN-910076
                  s_srg[1].srg12,s_srg[1].srg13,s_srg[1].srg14,
                  s_srg[1].srg930  #FUN-670103
                  ,s_srg[1].srgud01,s_srg[1].srgud02,s_srg[1].srgud03
                  ,s_srg[1].srgud04,s_srg[1].srgud05,s_srg[1].srgud06
                  ,s_srg[1].srgud07,s_srg[1].srgud08,s_srg[1].srgud09
                  ,s_srg[1].srgud10,s_srg[1].srgud11,s_srg[1].srgud12
                  ,s_srg[1].srgud13,s_srg[1].srgud14,s_srg[1].srgud15
 
       BEFORE CONSTRUCT
           CALL cl_qbe_display_condition(lc_qbe_sn)
 
       ON ACTION controlp
          CASE
             WHEN INFIELD(srg16)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form ="q_sfb05"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srg16
                NEXT FIELD srg16
             WHEN INFIELD(srg03)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO srg03
                NEXT FIELD srg03
             WHEN INFIELD(srg04)
                CALL cl_init_qry_var()
                LET g_qryparam.form = "q_gfe"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srg04
                NEXT FIELD srg04
             WHEN INFIELD(srg11)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_sfp"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srg11
                NEXT FIELD srg11
             WHEN INFIELD(srg12)
                CALL cl_init_qry_var()
                LET g_qryparam.state= "c"
                LET g_qryparam.form = "q_qcf1"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srg12
                NEXT FIELD srg12
             WHEN INFIELD(srg14)
#FUN-AA0059---------mod------------str-----------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form = "q_ima"
#               LET g_qryparam.state = "c"
#               CALL cl_create_qry() RETURNING g_qryparam.multiret
                CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------

                DISPLAY g_qryparam.multiret TO srg14
                NEXT FIELD srg14
             WHEN INFIELD(srg930)
                CALL cl_init_qry_var()
                LET g_qryparam.form  = "q_gem4"
                LET g_qryparam.state = "c"   #多選
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO srg930
                NEXT FIELD srg930
             OTHERWISE
                EXIT CASE
          END CASE
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
       ON ACTION about
          CALL cl_about()
 
       ON ACTION help
          CALL cl_show_help()
 
       ON ACTION controlg
          CALL cl_cmdask()
 
       ON ACTION qbe_save
           CALL cl_qbe_save()
 
     END CONSTRUCT
     IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
  END IF
 
  #資料權限的檢查
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('srfuser', 'srfgrup')
 
  IF NOT cl_null(g_argv1) THEN
     LET g_wc=g_wc," AND srf07='",g_argv1,"'"
  END IF
 
  IF g_wc2 = " 1=1" THEN		# 若單身未輸入條件
     LET g_sql = "SELECT  srf01 FROM srf_file",
                 " WHERE ", g_wc CLIPPED,
                 " ORDER BY srf01"
  ELSE					# 若單身有輸入條件
     LET g_sql = "SELECT UNIQUE srf_file. srf01 ",
                 "  FROM srf_file, srg_file",
                 " WHERE srf01 = srg01",
                 "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                 " ORDER BY srf01"
  END IF
 
  PREPARE t300_prepare FROM g_sql
  DECLARE t300_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR t300_prepare
 
  IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM srf_file WHERE ",g_wc CLIPPED
  ELSE
      LET g_sql="SELECT COUNT(DISTINCT srf01) FROM srf_file,srg_file",
                " WHERE srg01 = srf01 ",
                "   AND ",g_wc CLIPPED,
                "   AND ",g_wc2 CLIPPED
  END IF
  PREPARE t300_count_pre FROM g_sql
  DECLARE t300_count CURSOR FOR t300_count_pre
END FUNCTION
 
FUNCTION t300_menu()
DEFINE l_str STRING
 
   WHILE TRUE
      CALL t300_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t300_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t300_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t300_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t300_y()
            END IF
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t300_z()
            END IF
         WHEN "trans_store_fqc"
            IF cl_chk_act_auth() THEN
               IF g_aza.aza90 matches '[Yy]' AND g_srf.srf07 = '2' THEN      #FUN-B10037 add
                  CALL cl_err(' ','asr-060',0)                               #FUN-B10037 add
               ELSE                                                          #FUN-B10037 add
                  CALL t300_w()
               END IF                                                        #FUN-B10037 add
            #TQC-C20428 -------Begin------
               IF g_success = 'Y' THEN
                  CALL t300_show()
               END IF
            #TQC-C20428 -------End--------
            END IF
         WHEN "trans_fqc"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_srf.srf01) AND (g_argv1='1') THEN
                  LET l_str= "asrt310 '",g_srf.srf01,"'"
                  CALL cl_cmdrun_wait(l_str)
               END IF
               IF NOT cl_null(l_ac) AND l_ac > 0 THEN  #TQC-C70095 add
                  IF NOT cl_null(g_srg[l_ac].srg12) AND (g_argv1='2') THEN
                     LET l_str= "aqct410 '",g_srg[l_ac].srg12,"'"
                     CALL cl_cmdrun_wait(l_str)
                  END IF
               END IF  #TQC-C70095
            END IF
         WHEN "trans_store"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(l_ac) AND l_ac > 0 THEN  #TQC-C70095 add
                  IF NOT cl_null(g_srg[l_ac].srg11) THEN
                     CASE g_argv1
                        WHEN "1"
                           LET l_str= "asrt320 '",g_srg[l_ac].srg11,"'"
                        WHEN "2"
                           LET g_cnt=0
                           SELECT COUNT(*) INTO g_cnt FROM sfb_file
                            WHERE sfb01=g_srg[l_ac].srg16
                              AND sfb02<> '11'
                           IF g_cnt>0 THEN
                              LET l_str= "asft620 '",g_srg[l_ac].srg11,"'"
                           ELSE
                              LET l_str= "asft622 '",g_srg[l_ac].srg11,"'"
                           END IF
                     END CASE
                     CALL cl_cmdrun_wait(l_str)
                  END IF
               END IF  #TQC-C70095
            END IF
         WHEN "gen_receive"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_srf.srf01) THEN
                  CASE g_argv1
                     WHEN "1"
                        CALL t300_v()
                     WHEN "2"
                        CALL t300_t620_k()
                  END CASE
               END IF
            END IF
         WHEN "maintain_receive"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_srf.srf06) THEN
                  CASE g_argv1
                     WHEN "1"
                        LET l_str= "asri230 '",g_srf.srf06,"'"
                     WHEN "2"
                        LET l_str= "asfi510", " '4' " ," '",g_srf.srf06,"'"
                  END CASE
                  CALL cl_cmdrun_wait(l_str)
               END IF
            END IF
         WHEN "def_wk"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_srf.srf01) THEN
                  LET l_str= "asrt3001 '",g_srf.srf01,"'"
                  CALL cl_cmdrun_wait(l_str)
               END IF
            END IF
         WHEN "bad_maintain"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_srf.srf01) THEN
                  LET l_str= "asrt3002 '",g_srf.srf01,"'"
                  CALL cl_cmdrun_wait(l_str)
               END IF
            END IF
         WHEN "lab_rep"
            IF cl_chk_act_auth() THEN
               IF NOT cl_null(g_srf.srf01) THEN
                  LET l_str= "asrt3003 '",g_srf.srf01,"'"
                  CALL cl_cmdrun_wait(l_str)
               END IF
            END IF
         WHEN "related_document"
           IF cl_chk_act_auth() THEN
              IF g_srf.srf01 IS NOT NULL THEN
                 LET g_doc.column1 = "srf01"
                 LET g_doc.value1 = g_srf.srf01
                 CALL cl_doc()
              END IF
           END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_srg),'','')
            END IF
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t300_x()                 #CHI-D20010
                CALL t300_x(1)                 #CHI-D20010
            END IF
         #CHI-D20010----add---str
         #取消作廢
         WHEN "undo_void"
         IF cl_chk_act_auth() THEN
           #CALL t300_x()                 #CHI-D20010
            CALL t300_x(2)                 #CHI-D20010
         END IF 
         #CHI-D20010----add---end
         WHEN "trans_spc"         
            IF cl_chk_act_auth() THEN
               CALL t300_spc()
            END IF
        WHEN "output"
           IF cl_chk_act_auth() THEN
              CALL t300_out()
           END IF
        #DEV-D30045--add--begin
         WHEN "barcode_gen"     #條碼產生
             IF cl_chk_act_auth() THEN
                CALL t300_barcode_gen(g_srf.srf01,'Y')
             END IF

         WHEN "barcode_query"   #條碼查詢
             IF cl_chk_act_auth() THEN
                LET g_msg = "abaq100 '",g_srf.srf01,"' "
                CALL cl_cmdrun_wait(g_msg)
             END IF

         WHEN "barcode_output"  #條碼列印
             IF cl_chk_act_auth() THEN
                CALL t300_barcode_out()
             END IF
        #DEV-D30045--add--end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t300_a()
DEFINE li_result   LIKE type_file.num5    #No.FUN-680130 SMALLINT
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_srg.clear()
    INITIALIZE g_srf.* TO NULL
    LET g_srf01_t = NULL
    LET g_srf_o.* = g_srf.*
    LET g_srf_t.* = g_srf.*
 
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_srf.srf02  =g_today
        LET g_srf.srfconf='N'
        LET g_srf.srfspc ='0'    #FUN-680010
        LET g_srf.srfuser=g_user
        LET g_srf.srforiu = g_user #FUN-980030
        LET g_srf.srforig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_srf.srfgrup=g_grup
        LET g_srf.srfdate=g_today
        LET g_srf.srf05  =g_today    #MOD-A80032 add
        LET g_srf.srf07  =g_argv1
        LET g_srf.srfplant = g_plant #FUN-980008 add
        LET g_srf.srflegal = g_legal #FUN-980008 add
      IF NOT cl_null(g_argv2) AND (g_argv3 = "insert") THEN
         LET g_srf.srf01 = g_argv2
      END IF
        DISPLAY BY NAME g_srf.srf02,g_srf.srfconf,
                        g_srf.srfuser,g_srf.srfgrup,
                        g_srf.srfdate,g_srf.srf07
        CALL t300_i("a")                #輸入單頭
        IF INT_FLAG THEN
           LET INT_FLAG=0
           INITIALIZE g_srf.* TO NULL
           CALL cl_err('',9001,0)
           ROLLBACK WORK
           EXIT WHILE
        END IF
        IF g_srf.srf01 IS NULL THEN       #KEY不可空白
           CONTINUE WHILE
        END IF
        BEGIN WORK  #No:7837
 #       CALL s_auto_assign_no("asf",g_srf.srf01,g_srf.srf02,"1","srf_file","srf01","","","")        #FUN-AA0059  mark
         IF g_argv1='1' THEN #TQC-AC0255
            CALL s_auto_assign_no("asr",g_srf.srf01,g_srf.srf02,"1","srf_file","srf01","","","")        #FUN-AA0059
              RETURNING li_result,g_srf.srf01
         ELSE #TQC-AC0205
            CALL s_auto_assign_no("asf",g_srf.srf01,g_srf.srf02,"J","srf_file","srf01","","","")  #TQC-AC0255
              RETURNING li_result,g_srf.srf01  #TQC-AC0255
         END IF
            
        IF (NOT li_result) THEN
           CONTINUE WHILE
        END IF
        DISPLAY BY NAME g_srf.srf01
 
        INSERT INTO srf_file VALUES (g_srf.*)
        IF SQLCA.SQLCODE THEN
        #   ROLLBACK WORK  #No:7837         # FUN-B80063 下移兩行
           CALL cl_err('Ins:',SQLCA.SQLCODE,1)
           ROLLBACK WORK                    # FUN-B80063
           CONTINUE WHILE
        ELSE
           COMMIT WORK   #No:7837
           CALL cl_flow_notify(g_srf.srf01,'I')
        END IF
        CALL g_srg.clear()
        LET g_rec_b=0
        LET g_srf_t.* = g_srf.*
        LET g_srf01_t = g_srf.srf01
 
        SELECT srf01 INTO g_srf.srf01
          FROM srf_file
         WHERE srf01 = g_srf.srf01
 
        IF NOT cl_null(g_srf.srf01) THEN
           CALL t300_b()
        END IF
 
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t300_u()
   IF s_shut(0) THEN RETURN END IF
 
   IF g_srf.srf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_srf.* FROM srf_file WHERE srf01 = g_srf.srf01
   IF g_srf.srfconf = 'X' THEN
      CALL cl_err(' ','9024',0)
      RETURN
   END IF
   IF g_srf.srfconf = 'Y' THEN
      CALL cl_err(' ','afa-096',0)
      RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_srf01_t = g_srf.srf01
   LET g_srf_o.* = g_srf.*
   BEGIN WORK
 
   OPEN t300_cl USING g_srf.srf01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_srf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t300_cl ROLLBACK WORK RETURN
   END IF
   CALL t300_show()
   WHILE TRUE
       LET g_srf01_t = g_srf.srf01
       LET g_srf.srfmodu=g_user
       LET g_srf.srfdate=g_today
       CALL t300_i("u")                      #欄位更改
       IF INT_FLAG THEN
           LET INT_FLAG = 0
           LET g_srf.*=g_srf_t.*
           CALL t300_show()
           CALL cl_err('','9001',0)
           EXIT WHILE
       END IF
       IF g_srf.srf01 != g_srf_t.srf01 THEN
          UPDATE srg_file SET srg01=g_srf.srf01 WHERE srg01=g_srf_t.srf01
          IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
             CALL cl_err('upd srg01',SQLCA.SQLCODE,1)
             LET g_srf.*=g_srf_t.*
             CALL t300_show()
             CONTINUE WHILE
          END IF
       END IF
       UPDATE srf_file SET * = g_srf.*
        WHERE srf01 = g_srf01_t
       IF SQLCA.SQLERRD[3] = 0 OR SQLCA.SQLCODE THEN
          CALL cl_err(g_srf.srf01,SQLCA.SQLCODE,0)
          CONTINUE WHILE
       END IF
       EXIT WHILE
   END WHILE
   CLOSE t300_cl
   COMMIT WORK
END FUNCTION
 
#處理INPUT
FUNCTION t300_i(p_cmd)
  DEFINE p_cmd           LIKE type_file.chr1,   #a:輸入 u:更改  #No.FUN-680130 VARCHAR(1)                
         l_flag          LIKE type_file.chr1,   #判斷必要欄位是否有輸入 #No.FUN-680130 VARCHAR(1)               
         l_n1            LIKE type_file.num5,   #No.FUN-680130 SMALLINT 
         l_bdate,l_edate LIKE type_file.dat,    #No.FUN-680130 DATE 
         l_eci06         LIKE eci_file.eci06,
         l_ecg02         LIKE ecg_file.ecg02
  DEFINE li_result       LIKE type_file.num5    #No.FUN-680130 SMALLINT
  DEFINE l_srg16         LIKE srg_file.srg16    #CHI-990050
  DEFINE l_sfb81         LIKE sfb_file.sfb81    #CHI-990050

    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_srf.srforiu,g_srf.srforig,
        g_srf.srf01,g_srf.srf02,g_srf.srf03,g_srf.srf04,g_srf.srf05,g_srf.srfspc,   #,g_srf.srf06  #FUN-680010
        g_srf.srfud01,g_srf.srfud02,g_srf.srfud03,g_srf.srfud04,
        g_srf.srfud05,g_srf.srfud06,g_srf.srfud07,g_srf.srfud08,
        g_srf.srfud09,g_srf.srfud10,g_srf.srfud11,g_srf.srfud12,
        g_srf.srfud13,g_srf.srfud14,g_srf.srfud15 
           WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t300_set_entry(p_cmd)
            CALL t300_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
            CALL cl_set_docno_format("srf01")
 
        AFTER FIELD srf01
            IF (NOT cl_null(g_srf.srf01)) AND (g_srf.srf01!=g_srf_t.srf01 OR g_srf_t.srf01 IS NULL) THEN
               IF g_argv1='1' THEN  #TQC-740154
                  CALL s_check_no("asr",g_srf.srf01,g_srf01_t,"1","srf_file","srf01","")
                    RETURNING li_result,g_srf.srf01
               ELSE
                  CALL s_check_no("asf",g_srf.srf01,g_srf01_t,"J","srf_file","srf01","")
                    RETURNING li_result,g_srf.srf01
               END IF
               DISPLAY BY NAME g_srf.srf01
               IF (NOT li_result) THEN
                  NEXT FIELD srf01
               END IF
            END IF
            LET g_srf_o.srf01 = g_srf.srf01
 
        AFTER FIELD srf02
           IF NOT cl_null(g_srf.srf02) THEN
              IF g_srf.srf02 <= g_sma.sma53 THEN
                 CALL cl_err('','axm-164',0)
                 NEXT FIELD srf02
              END IF
              IF g_argv1 = '2' THEN 
                 DECLARE srg_cur CURSOR FOR
                    SELECT srg16 FROM srg_file WHERE srg01 = g_srf.srf01
                 FOREACH srg_cur INTO l_srg16
                    SELECT sfb81 INTO l_sfb81 FROM sfb_file WHERE sfb01 = l_srg16
                    IF l_sfb81 > g_srf.srf02 THEN
                       CALL cl_err(l_srg16,'axc-210',1)
                       NEXT FIELD srf02
                    END IF
                 END FOREACH
              END IF
           END IF
 
        AFTER FIELD srf03
            IF (NOT cl_null(g_srf.srf03)) AND (g_srf.srf03!=g_srf_t.srf03 OR g_srf_t.srf03 IS NULL) THEN
               CALL t300_srf03(g_srf.srf03)
               IF NOT cl_null(g_errno) THEN
                  LET g_srf.srf03 = g_srf_t.srf03
                  CALL t300_set_srf03(g_srf.srf03) RETURNING l_eci06
                  DISPLAY l_eci06 TO FORMONLY.eci06
                  DISPLAY BY NAME g_srf.srf03
                  CALL cl_err('',g_errno,1)
                  NEXT FIELD srf03
               END IF
               CALL t300_set_srf03(g_srf.srf03) RETURNING l_eci06
               DISPLAY l_eci06 TO FORMONLY.eci06
            ELSE
               DISPLAY '' TO FORMONLY.eci06
            END IF
 
        AFTER FIELD srf04
            IF (NOT cl_null(g_srf.srf04)) AND (g_srf.srf04!=g_srf_t.srf04 OR g_srf_t.srf04 IS NULL) THEN
               LET g_cnt=0
               SELECT COUNT(*) INTO g_cnt FROM ecg_file WHERE ecg01=g_srf.srf04
                                                          AND ecgacti='Y'
               IF g_cnt=0 THEN
                  CALL cl_err('',100,1)
                  LET g_srf.srf04 = g_srf_t.srf04
                  DISPLAY BY NAME g_srf.srf04
                  CALL t300_set_srf04(g_srf.srf04) RETURNING l_ecg02
                  DISPLAY l_ecg02 TO FORMONLY.ecg02
                  NEXT FIELD srf04
               END IF
               CALL t300_set_srf04(g_srf.srf04) RETURNING l_ecg02
               DISPLAY l_ecg02 TO FORMONLY.ecg02
            ELSE
               DISPLAY '' TO FORMONLY.ecg02
            END IF
 
 
 
        AFTER FIELD srfud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srfud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER INPUT
           LET g_srf.srfuser = s_get_data_owner("srf_file") #FUN-C10039
           LET g_srf.srfgrup = s_get_data_group("srf_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT END IF
 
        ON ACTION controlp
            CASE
               WHEN INFIELD(srf01)
                  LET g_t1 = s_get_doc_no(g_srf.srf01)
                  IF g_argv1='1' THEN #TQC-740154
                     CALL q_smy( FALSE,TRUE,g_t1,'ASR','1') RETURNING g_t1  #TQC-670008
                  ELSE
                     CALL q_smy( FALSE,TRUE,g_t1,'ASF','J') RETURNING g_t1  #TQC-670008
                  END IF
                  LET g_srf.srf01= g_t1
                  DISPLAY BY NAME g_srf.srf01
                  NEXT FIELD srf01
               WHEN INFIELD(srf03)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_eci"
                  CALL cl_create_qry() RETURNING g_srf.srf03
                  DISPLAY BY NAME g_srf.srf03
                  NEXT FIELD srf03
               WHEN INFIELD(srf04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecg"
                  CALL cl_create_qry() RETURNING g_srf.srf04
                  DISPLAY g_srf.srf04 TO srf04
               WHEN INFIELD(srf06)
                  CALL cl_init_qry_var()
                 #LET g_qryparam.form = "q_sfp"     #MOD-B40144 mark
                  LET g_qryparam.form = "q_sfp1"    #MOD-B40144 add
                  LET g_qryparam.arg1 = "C"
                  CALL cl_create_qry() RETURNING g_srf.srf06
                  DISPLAY g_srf.srf06 TO srf06
               OTHERWISE
                  EXIT CASE
            END CASE
 
        ON ACTION CONTROLF                  #欄位說明
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
 
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
 
    END INPUT
END FUNCTION
FUNCTION t300_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680130 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("srf01",TRUE)
    END IF
 
END FUNCTION
FUNCTION t300_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1   #No.FUN-680130 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("srf01",FALSE)
    END IF
END FUNCTION
 
FUNCTION t300_set_entry_b()
    CALL cl_set_comp_entry("srg14",TRUE)
END FUNCTION
 
FUNCTION t300_set_no_entry_b()
    CALL cl_set_comp_entry("srg14",FALSE)
END FUNCTION
 
FUNCTION t300_srf03(p_srf03)
  DEFINE p_srf03     LIKE srf_file.srf03,
         l_eciacti   LIKE eci_file.eciacti
 
  LET g_errno = ' '
  SELECT eciacti INTO l_eciacti FROM eci_file WHERE eci01 = p_srf03
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = '100'
       WHEN l_eciacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
END FUNCTION
 
FUNCTION t300_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_srf.* TO NULL               #No.FUN-6A0166
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t300_cs()
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       INITIALIZE g_srf.* TO NULL
       RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_srf.* TO NULL
    ELSE
        OPEN t300_count
        FETCH t300_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t300_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t300_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,   #處理方式  #No.FUN-680130 VARCHAR(1)                
    l_abso          LIKE type_file.num10   #絕對的筆數#No.FUN-680130 INTEGER                
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     t300_cs INTO g_srf.srf01
        WHEN 'P' FETCH PREVIOUS t300_cs INTO g_srf.srf01
        WHEN 'F' FETCH FIRST    t300_cs INTO g_srf.srf01
        WHEN 'L' FETCH LAST     t300_cs INTO g_srf.srf01
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            FETCH ABSOLUTE g_jump t300_cs INTO g_srf.srf01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)
        INITIALIZE g_srf.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT * INTO g_srf.* FROM srf_file WHERE srf01 = g_srf.srf01
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)
        INITIALIZE g_srf.* TO NULL
        RETURN
    END IF
    LET g_data_owner = g_srf.srfuser
    LET g_data_group = g_srf.srfgrup
    LET g_data_plant = g_srf.srfplant #FUN-980030
    CALL t300_show()
END FUNCTION
 
FUNCTION t300_show()
  DEFINE l_eci06 LIKE eci_file.eci06
  DEFINE l_ecg02 LIKE ecg_file.ecg02
    LET g_srf_t.* = g_srf.*                #保存單頭舊值
    DISPLAY BY NAME g_srf.srforiu,g_srf.srforig,
        g_srf.srf01,g_srf.srf07,g_srf.srf02,g_srf.srf03,g_srf.srf04,
        g_srf.srf05,g_srf.srfconf,g_srf.srfspc,g_srf.srf06,g_srf.srfuser, #FUN-680010
        g_srf.srfgrup,g_srf.srfmodu,g_srf.srfdate,
        g_srf.srfud01,g_srf.srfud02,g_srf.srfud03,g_srf.srfud04,
        g_srf.srfud05,g_srf.srfud06,g_srf.srfud07,g_srf.srfud08,
        g_srf.srfud09,g_srf.srfud10,g_srf.srfud11,g_srf.srfud12,
        g_srf.srfud13,g_srf.srfud14,g_srf.srfud15 
 
    CALL t300_set_srf03(g_srf.srf03) RETURNING l_eci06
    CALL t300_set_srf04(g_srf.srf04) RETURNING l_ecg02
    DISPLAY l_eci06 TO FORMONLY.eci06
    DISPLAY l_ecg02 TO FORMONLY.ecg02
    CALL t300_b_fill(g_wc2)
    CALL cl_set_field_pic("","","","","","")
    IF g_srf.srfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_srf.srfconf,"","","",g_chr,"")
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t300_r()
 DEFINE l_chr,l_sure LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 DEFINE    l_cnt         LIKE type_file.num10   #No.MOD-B30043
  
    IF s_shut(0) THEN RETURN END IF
    IF g_srf.srf01 IS NULL THEN
       CALL cl_err('',-400,0) RETURN
    END IF
    SELECT * INTO g_srf.* FROM srf_file WHERE srf01 = g_srf.srf01
    IF g_srf.srfconf = 'X' THEN
       CALL cl_err(' ','9024',0)
       RETURN
    END IF
    IF g_srf.srfconf = 'Y' THEN
       CALL cl_err('','afa-096',0) RETURN
    END IF
    BEGIN WORK
 
    OPEN t300_cl USING g_srf.srf01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_srf.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)
       CLOSE t300_cl ROLLBACK WORK RETURN
    END IF
    CALL t300_show()
    IF cl_delh(20,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "srf01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_srf.srf01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
#No.MOD-B30043 --begin
    LET l_cnt = 0 
    SELECT COUNT(*) INTO l_cnt  FROM ccj_file,srf_file,srg_file
     WHERE ccj01 = g_srf.srf02
       AND srf01 = srg01
       AND srg16 = ccj04
       AND srf01 = g_srf.srf01
       AND ccj04 IN (SELECT sfb01 FROM sfb_file
                      WHERE sfb93='N'
                    )
                   
   IF l_cnt > 0 THEN
      CALL cl_err('','asr-056',1)
      RETURN 
   END IF 
#No.MOD-B30043 --end
       MESSAGE "Delete srf,srg!"
       DELETE FROM srf_file WHERE srf01 = g_srf.srf01
       IF SQLCA.SQLERRD[3]=0 THEN
          CALL cl_err('No srf deleted',SQLCA.SQLCODE,0)
       ELSE
          DELETE FROM sri_file WHERE sri01 = g_srf.srf01  #MOD-8C0260 add
          DELETE FROM srg_file WHERE srg01 = g_srf.srf01
          CLEAR FORM
          CALL g_srg.clear()
          INITIALIZE g_srf.* LIKE srf_file.*
          OPEN t300_count
          #FUN-B50064-add-start--
          IF STATUS THEN
             CLOSE t300_cs
             CLOSE t300_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          FETCH t300_count INTO g_row_count
          #FUN-B50064-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE t300_cs
             CLOSE t300_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50064-add-end-- 
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN t300_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL t300_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL t300_fetch('/')
          END IF
       END IF
    END IF
    CLOSE t300_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t300_b()
DEFINE l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT   #No.FUN-680130 SMALLINT,              
       l_row,l_col     LIKE type_file.num5,   #分段輸入之行,列數   #No.FUN-680130 SMALLINT,	           
       l_n,l_cnt       LIKE type_file.num5,   #檢查重複用          #No.FUN-680130 SMALLINT,              
       l_lock_sw       LIKE type_file.chr1,   #單身鎖住否          #No.FUN-680130 VARCHAR(1),               
       p_cmd           LIKE type_file.chr1,   #處理狀態            #No.FUN-680130 VARCHAR(1),                 
       l_b2            LIKE type_file.chr1000,                     #No.FUN-680130 VARCHAR(30),
#      l_qty	       LIKE ima_file.ima26,   #No.FUN-680130  DECIMAL(15,3)                               
       l_qty	       LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
       l_flag          LIKE type_file.num10,                       #No.FUN-680130 INTEGER 
       l_allow_insert  LIKE type_file.num5,   #可新增否            #No.FUN-680130 SMALLINT                 
       l_allow_delete  LIKE type_file.num5,   #可刪除否            #No.FUN-680130 SMALLINT                 
       l_sfb02         LIKE sfb_file.sfb02,   #FUN-660110 add
       l_sfb39         LIKE sfb_file.sfb39,   #CHI-710057
       l_sfb87         LIKE sfb_file.sfb87,   #CHI-710057  #TQC-8B0053 add,
       l_sfb81         LIKE sfb_file.sfb81,   #CHI-990050 add 
       l_sfb04         LIKE sfb_file.sfb04,   #CHI-880008 add 
       l_ima903        LIKE ima_file.ima903,  #No:MOD-980050 add 
       l_sfb28         LIKE sfb_file.sfb28   
DEFINE l_sfb01         LIKE sfb_file.sfb01    #TQC-970372 
DEFINE l_sfbacti       LIKE sfb_file.sfbacti  #TQC-970372 #MOD-990034 sfb01-->sfbacti   
DEFINE l_case          STRING   #No.FUN-BB0086 

    LET g_action_choice = ""
    IF g_srf.srf01 IS NULL THEN RETURN END IF
    IF g_srf.srfconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
    IF g_srf.srfconf = 'Y' THEN CALL cl_err('','afa-096',0) RETURN END IF
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = "SELECT * ",
                       "  FROM srg_file ",
                       "  WHERE srg01 = ? ",
                       " AND srg02 = ? ",
                        " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_srg.clear() END IF
 
 
      INPUT ARRAY g_srg WITHOUT DEFAULTS FROM s_srg.*
            ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            LET g_srg04_t = NULL   #No.FUN-BB0086
 
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'                   #DEFAULT
            LET l_n  = ARR_COUNT()
            CALL t300_set_entry_b()
	          BEGIN WORK
 
            OPEN t300_cl USING g_srf.srf01
            IF STATUS THEN
               CALL cl_err("OPEN t300_cl:", STATUS, 1)
               CLOSE t300_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t300_cl INTO g_srf.*            #鎖住將被更改或取消的資料
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
               CLOSE t300_cl ROLLBACK WORK RETURN
            END IF
 
            IF g_rec_b>=l_ac THEN
                LET p_cmd='u'
                LET g_srg_t.* = g_srg[l_ac].*  #BACKUP
                LET g_srg04_t = g_srg[l_ac].srg04   #No.FUN-BB0086
                OPEN t300_bcl USING g_srf.srf01,g_srg_t.srg02
                IF STATUS THEN
                   CALL cl_err("OPEN t300_bcl:", STATUS, 1)
                   LET l_lock_sw = "Y"
                ELSE
                  FETCH t300_bcl INTO b_srg.* #FUN-730075
                   IF SQLCA.sqlcode THEN
                       CALL cl_err('lock srg',SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                   ELSE
                       CALL t300_b_move_to() #FUN-730075
                       CALL t300_set_srg03(g_srg[l_ac].srg03) RETURNING g_srg[l_ac].ima02,
                                                                        g_srg[l_ac].ima021
                       LET g_srg[l_ac].gem02c=s_costcenter_desc(g_srg[l_ac].srg930) #FUN-670103
                   END IF
                END IF
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
              ROLLBACK WORK
              CANCEL INSERT
              EXIT INPUT
            END IF
            CALL t300_b_move_back() #FUN-730075
            INSERT INTO srg_file VALUES (b_srg.*)
            IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0  THEN
               CALL cl_err('ins srg',SQLCA.sqlcode,0)
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               COMMIT WORK
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd = 'a'
            INITIALIZE g_srg[l_ac].* TO NULL
            LET g_srg[l_ac].srg05=0
            LET g_srg[l_ac].srg06=0
            LET g_srg[l_ac].srg07=0
            LET g_srg[l_ac].srg13=1                  #FUN-B60124
            LET g_srg[l_ac].srg17=0
            LET g_srg[l_ac].srg18=0
            LET g_srg[l_ac].srg930=t300_get_srg930() #FUN-670103
            LET g_srg[l_ac].gem02c=s_costcenter_desc(g_srg[l_ac].srg930) #FUN-670103
            LET g_srg_t.* = g_srg[l_ac].*             #新輸入資料
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD srg02
 
        BEFORE FIELD srg02                            #desrflt 序號
            IF p_cmd = 'a' OR p_cmd = 'u' THEN
              IF g_srg[l_ac].srg02 IS NULL OR g_srg[l_ac].srg02 = 0 THEN
                  SELECT max(srg02)+1 INTO g_srg[l_ac].srg02
                     FROM srg_file WHERE srg01 = g_srf.srf01
                  IF g_srg[l_ac].srg02 IS NULL THEN
                      LET g_srg[l_ac].srg02 = 1
                  END IF
              END IF
            END IF
 
        AFTER FIELD srg02                        #check 序號是否重複
            IF NOT cl_null(g_srg[l_ac].srg02) THEN
               IF g_srg[l_ac].srg02 != g_srg_t.srg02 OR
                  g_srg_t.srg02 IS NULL THEN
                   SELECT count(*) INTO l_n FROM srg_file
                    WHERE srg01 = g_srf.srf01
                      AND srg02 = g_srg[l_ac].srg02
                   IF l_n > 0 THEN
                       LET g_srg[l_ac].srg02 = g_srg_t.srg02
                       CALL cl_err('',-239,0)
                       NEXT FIELD srg02
                   END IF
               END IF
            END IF
        
        AFTER FIELD srg16   #工單編號
            IF (NOT cl_null(g_srg[l_ac].srg16)) AND 
               (g_argv1='2') AND 
               (g_srg[l_ac].srg16 <> g_srg_t.srg16 OR g_srg_t.srg16 IS NULL) THEN
               LET l_cnt=0
               LET l_sfb04 = NULL     #No:CHI-880008 add
               LET l_sfb28 = NULL     #No:CHI-880008 add
               SELECT sfb01,sfbacti,sfb02,sfb39,sfb87,sfb81,sfb04,sfb28   #CHI-990050 add sfb81 
                INTO l_sfb01,l_sfbacti,l_sfb02,l_sfb39,l_sfb87,l_sfb81,l_sfb04,l_sfb28  #CHI-710057 #TQC-970372 add sfb01,sfbacti   #CHI-990050 add sfb81
                 FROM sfb_file
                WHERE sfb01=g_srg[l_ac].srg16
               IF cl_null(l_sfb01) THEN 
                  CALL cl_err('','aem-041',0)
                  NEXT FIELD srg16
               END IF 
               IF l_sfbacti != 'Y' THEN 
                  CALL cl_err('','aco-172',0)
                  NEXT FIELD srg16
               END IF                
               IF l_sfb02 = '15' THEN
                  CALL cl_err(g_srg[l_ac].srg16,'asr-047',1)   #所輸入之工單型態不可為試產工單,請重新輸入!
                  NEXT FIELD srg16
               END IF
              #MOD-A90174---add---start---
               IF l_sfb02 = '13' THEN
                  CALL cl_err(g_srg[l_ac].srg16,'asr-054',1)   #所輸入之工單型態不可為試產工單,請重新輸入!
                  NEXT FIELD srg16
               END IF
              #MOD-A90174---add---end---
               #IF l_sfb04 = '8' AND l_sfb28='3' THEN  #MOD-D10074
               IF l_sfb04 = '8' AND (l_sfb28='2' OR l_sfb28='3') THEN  #MOD-D10074
                  CALL cl_err(g_srg[l_ac].srg16,'asf-041',1)   #所輸入之工單型態不可為試產工單,請重新輸入!
                  NEXT FIELD srg16
               END IF
               IF l_sfb02 = '7' OR l_sfb02 = '8' THEN
                  CALL cl_err(g_srg[l_ac].srg16,'axc-209',1)
                  NEXT FIELD srg16
               END IF
               IF l_sfb87<>'Y' THEN
                  CALL cl_err('','asf-019',1)
                  NEXT FIELD srg16
               END IF
               IF l_sfb81 > g_srf.srf02 THEN
                  CALL cl_err('','axc-210',1)
                  NEXT FIELD srg16
               END IF
              CASE l_sfb39
                 WHEN "1"
                     SELECT sfb05,sfb94,sfb98 INTO g_srg[l_ac].srg03, #FUN-670103
                                                   g_srg[l_ac].srg15,
                                                   g_srg[l_ac].srg930 #FUN-670103
                                                    FROM sfb_file 
                                                   WHERE sfb01=g_srg[l_ac].srg16
                                                     AND sfb081>0
                                                     AND sfbacti='Y'
                     IF SQLCA.sqlcode THEN
                        CALL cl_err('chk sfb','asr-046',1)
                        LET g_srg[l_ac].srg16=g_srg_t.srg16
                        LET g_srg[l_ac].srg03=g_srg_t.srg03
                        LET g_srg[l_ac].srg15=g_srg_t.srg15
                        LET g_srg[l_ac].srg930=g_srg_t.srg930 #FUN-670103
                        LET g_srg[l_ac].gem02c=g_srg_t.gem02c #FUN-670103
                        DISPLAY BY NAME g_srg[l_ac].srg16,
                                        g_srg[l_ac].srg03,
                                        g_srg[l_ac].srg15,
                                        g_srg[l_ac].srg930, #FUN-670103
                                        g_srg[l_ac].gem02c  #FUN-670103
                        NEXT FIELD srg16
                     ELSE
                        DISPLAY BY NAME g_srg[l_ac].srg03
                        DISPLAY BY NAME g_srg[l_ac].srg15
                        LET g_srg[l_ac].gem02c=s_costcenter_desc(g_srg[l_ac].srg930) #FUN-670103
                        DISPLAY BY NAME g_srg[l_ac].gem02c #FUN-670103
                        NEXT FIELD srg03 #kim : 雖然srg03 IS NoEntry ,But 用此程式碼可以強迫觸發 AFTER FIELD srg03 的程式碼,此行拿掉,便不會觸發 AFTER FIELD srg03
                     END IF
                 WHEN "2"
                    SELECT sfb05,sfb94 INTO g_srg[l_ac].srg03,
                                            g_srg[l_ac].srg15
                                        FROM sfb_file
                                       WHERE sfb01=g_srg[l_ac].srg16
                    DISPLAY BY NAME g_srg[l_ac].srg03
                    DISPLAY BY NAME g_srg[l_ac].srg15
                    NEXT FIELD srg03 #帶出料號的品名規格
               END CASE
            END IF
 
        AFTER FIELD srg03
            IF (NOT cl_null(g_srg[l_ac].srg03)) AND 
               (g_srg[l_ac].srg03 <> g_srg_t.srg03 OR g_srg_t.srg03 IS NULL) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_srg[l_ac].srg03,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_srg[l_ac].srg03= g_srg_t.srg03
                  NEXT FIELD srg03
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               LET g_cnt=0
               SELECT COUNT(*) INTO g_cnt FROM ima_file
                  WHERE ima01 = g_srg[l_ac].srg03 AND imaacti='Y'
                  IF g_cnt = 0 THEN
                     CALL cl_err(g_srg[l_ac].srg03,100,0)
                     LET g_srg[l_ac].srg03 = g_srg_t.srg03
                     DISPLAY BY NAME g_srg[l_ac].srg03
                     LET g_srg[l_ac].ima02 =g_srg_t.ima02
                     LET g_srg[l_ac].ima021=g_srg_t.ima021
                     DISPLAY BY NAME g_srg[l_ac].ima02
                     DISPLAY BY NAME g_srg[l_ac].ima021
                     IF g_argv1='2' THEN
                        NEXT FIELD srg16
                     ELSE
                        NEXT FIELD srg03
                     END IF
                  END IF
               CALL t300_set_srg03(g_srg[l_ac].srg03) RETURNING g_srg[l_ac].ima02,
                                                                g_srg[l_ac].ima021
               DISPLAY BY NAME g_srg[l_ac].ima02
               DISPLAY BY NAME g_srg[l_ac].ima021
               SELECT sre07 INTO g_srg[l_ac].srg05 FROM sre_file
                  WHERE sre03=g_srf.srf03
                    AND sre05=g_srf.srf04
                    AND sre06=g_srf.srf05
                    AND sre04=g_srg[l_ac].srg03
               DISPLAY BY NAME g_srg[l_ac].srg05
               CASE g_argv1
                  WHEN "1"              
                     SELECT ima55,ima24 INTO g_srg[l_ac].srg04,g_srg[l_ac].srg15 FROM ima_file
                        WHERE ima01=g_srg[l_ac].srg03
                     DISPLAY BY NAME g_srg[l_ac].srg15
                     DISPLAY BY NAME g_srg[l_ac].srg04
                  WHEN "2"
                     SELECT ima55 INTO g_srg[l_ac].srg04 FROM ima_file  #工單報工,檢驗否取決於工單FQC否
                        WHERE ima01=g_srg[l_ac].srg03
                     DISPLAY BY NAME g_srg[l_ac].srg04
               END CASE
               LET g_srg[l_ac].srg05=s_digqty(g_srg[l_ac].srg05,g_srg[l_ac].srg04)  #FUN-BB0086 add 
               DISPLAY BY NAME g_srg[l_ac].srg05  #FUN-BB0086 add
               IF g_srg[l_ac].srg13='1' THEN
                 LET g_srg[l_ac].srg14=g_srg[l_ac].srg03
                 CALL t300_set_no_entry_b()
               ELSE
                 LET g_srg[l_ac].srg14=''
                 DISPLAY BY NAME g_srg[l_ac].srg14
                 CALL t300_set_entry_b()
               END IF
           END IF
 
        AFTER FIELD srg04
           LET l_case = ""   #No.FUN-BB0086
           IF NOT cl_null(g_srg[l_ac].srg04) THEN
              LET g_cnt=0
              SELECT count(*) INTO g_cnt FROM gfe_file
                 WHERE gfe01 = g_srg[l_ac].srg04
              IF g_cnt = 0 THEN
                 CALL cl_err(g_srg[l_ac].srg04,100,0)
                 LET g_srg[l_ac].srg04 = g_srg_t.srg04
                 NEXT FIELD srg04
              END IF
              #No.FUN-BB0086--add--begin--
              IF NOT cl_null(g_srg[l_ac].srg05) AND g_srg[l_ac].srg05<>0 THEN  #TQC-C20183 add
                 IF NOT t300_srg05_check() THEN 
                    LET l_case = "srg05"
                 END IF 
              END IF                                                           #TQC-C20183 add
              IF NOT cl_null(g_srg[l_ac].srg06) AND g_srg[l_ac].srg06<>0 THEN  #TQC-C20183 add
                 IF NOT t300_srg06_check() THEN 
                    LET l_case = "srg06"
                 END IF 
              END IF                                                           #TQC-C20183 add
              IF NOT cl_null(g_srg[l_ac].srg07) AND g_srg[l_ac].srg07<>0 THEN  #TQC-C20183 add
                 IF NOT t300_srg07_check() THEN 
                    LET l_case = "srg07"
                 END IF 
              END IF                                                           #TQC-C20183 add
              LET g_srg04_t = g_srg[l_ac].srg04
              CASE l_case 
                 WHEN "srg05" NEXT FIELD srg05
                 WHEN "srg06" NEXT FIELD srg06
                 WHEN "srg07" NEXT FIELD srg07
                 OTHERWISE EXIT CASE 
              END CASE 
              #No.FUN-BB0086--add--end--
           END IF
 
        AFTER FIELD srg05 #良品數
           IF NOT t300_srg05_check() THEN NEXT FIELD srg05 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF (NOT cl_null(g_srg[l_ac].srg05)) AND 
           #   (g_argv1='2') AND
           #   (g_srg[l_ac].srg05 <> g_srg_t.srg05 OR g_srg_t.srg05 IS NULL) THEN
           #    IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07) THEN
           #       NEXT FIELD srg05
           #    END IF
           #END IF
           #No.FUN-BB0086--mark--end--
 
        AFTER FIELD srg06 #不良品數
           IF NOT t300_srg06_check() THEN NEXT FIELD srg06 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF (NOT cl_null(g_srg[l_ac].srg06)) AND 
           #   (g_argv1='2') AND
           #   (g_srg[l_ac].srg06 <> g_srg_t.srg06 OR g_srg_t.srg06 IS NULL) THEN
           #    IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07) THEN
           #       NEXT FIELD srg06
           #    END IF
           #END IF
           #No.FUN-BB0086--mark--end--
 
        AFTER FIELD srg07 #報廢數
           IF NOT t300_srg07_check() THEN NEXT FIELD srg07 END IF   #No.FUN-BB0086
           #No.FUN-BB0086--mark--begin--
           #IF (NOT cl_null(g_srg[l_ac].srg07)) AND 
           #   (g_argv1='2') AND
           #   (g_srg[l_ac].srg07 <> g_srg_t.srg07 OR g_srg_t.srg07 IS NULL) THEN
           #    IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07) THEN
           #       NEXT FIELD srg07
           #    END IF
           #END IF
           #No.FUN-BB0086--mark--end--
 
       AFTER FIELD srg08 #報工開始時間
          IF NOT cl_null(g_srg[l_ac].srg08) THEN
             #CALL t300_chk_time(g_srg[l_ac].srg08)   #MOD-D1019 
             CALL t300_chk_time(g_srg[l_ac].srg08,1)  #MOD-D10197
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_srg[l_ac].srg08,g_errno,1)
                LET g_srg[l_ac].srg08=''
                DISPLAY BY NAME g_srg[l_ac].srg08
                NEXT FIELD srg08
             END IF
          END IF
 
       AFTER FIELD srg09 #報工結束時間
          IF NOT cl_null(g_srg[l_ac].srg09) THEN
             #CALL t300_chk_time(g_srg[l_ac].srg09)   #MOD-D10197
             CALL t300_chk_time(g_srg[l_ac].srg09,2)  #MOD-D10197
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_srg[l_ac].srg09,g_errno,1)
                LET g_srg[l_ac].srg09=''
                DISPLAY BY NAME g_srg[l_ac].srg09
                NEXT FIELD srg09
             END IF
          END IF
          CALL t300_cacl_time(g_srg[l_ac].srg08,g_srg[l_ac].srg09)
             RETURNING g_srg[l_ac].srg10
          #MOD-D10197---begin
          IF g_srg[l_ac].srg10 < 0 THEN 
             CALL cl_err(g_srg[l_ac].srg10,'asf-917',0)
             NEXT FIELD srg09
          END IF 
          #MOD-D10197---end
          LET g_srg[l_ac].srg19 = g_srg[l_ac].srg10   #FUN-910076
          DISPLAY BY NAME g_srg[l_ac].srg10
          DISPLAY BY NAME g_srg[l_ac].srg19           #FUN-910076
          IF NOT cl_null(g_errno) THEN
             LET g_srg[l_ac].srg08=''
             LET g_srg[l_ac].srg09=''
             DISPLAY BY NAME g_srg[l_ac].srg08
             DISPLAY BY NAME g_srg[l_ac].srg09
             CALL cl_err('cal time',g_errno,1)
             NEXT FIELD srg08
          END IF
        AFTER FIELD srg13
           IF g_srg[l_ac].srg13='1' THEN
             LET g_srg[l_ac].srg14=g_srg[l_ac].srg03
             CALL t300_set_no_entry_b()
           ELSE
             LET g_srg[l_ac].srg14=''
             DISPLAY BY NAME g_srg[l_ac].srg14
             CALL t300_set_entry_b()
           END IF
        #MOD-D10197---begin
        AFTER FIELD srg10
           IF g_srg[l_ac].srg10 < 0 THEN
              CALL cl_err('srg10','axc-207',0)
              NEXT FIELD srg10
           END IF 
        AFTER FIELD srg19
           IF g_srg[l_ac].srg19 < 0 THEN
              CALL cl_err('srg10','axc-207',0)
              NEXT FIELD srg19
           END IF 
        #MOD-D10197---end
        AFTER FIELD srg14
           IF (NOT cl_null(g_srg[l_ac].srg14)) THEN
#FUN-AA0059 ---------------------start----------------------------
              IF NOT s_chk_item_no(g_srg[l_ac].srg14,"") THEN
                 CALL cl_err('',g_errno,1)
                 LET g_srg[l_ac].srg14 = g_srg_t.srg14
                 NEXT FIELD srg14
              END IF
#FUN-AA0059 ---------------------end-------------------------------
              CASE g_srg[l_ac].srg13
                 WHEN '1'
                    IF g_srg[l_ac].srg14<>g_srg[l_ac].srg03 THEN
                       CALL cl_err('',"asr-011",1)
                       NEXT FIELD srg14
                    END IF
                 WHEN ''
                    CALL cl_err('',"aap-099",0)
                    NEXT FIELD srg13
                 OTHERWISE
                    IF g_srg[l_ac].srg14=g_srg[l_ac].srg03 THEN
                       CALL cl_err('',"asr-012",1)
                       NEXT FIELD srg14
                    END IF
                    SELECT ima55,ima24 INTO g_srg[l_ac].srg04,g_srg[l_ac].srg15 FROM ima_file
                       WHERE ima01=g_srg[l_ac].srg03
                    DISPLAY BY NAME g_srg[l_ac].srg04
                    DISPLAY BY NAME g_srg[l_ac].srg15
              END CASE
              LET g_cnt=0
              SELECT COUNT(*) INTO g_cnt FROM ima_file
                 WHERE ima01 = g_srg[l_ac].srg14 AND imaacti='Y'
                 IF g_cnt = 0 THEN
                    CALL cl_err(g_srg[l_ac].srg14,100,0)
                    LET g_srg[l_ac].srg14 = g_srg_t.srg14
                    NEXT FIELD srg03
                 END IF
           END IF
        AFTER FIELD srg930 
           IF NOT s_costcenter_chk(g_srg[l_ac].srg930) THEN
              LET g_srg[l_ac].srg930=g_srg_t.srg930
              LET g_srg[l_ac].gem02c=g_srg_t.gem02c
              DISPLAY BY NAME g_srg[l_ac].srg930,g_srg[l_ac].gem02c
              NEXT FIELD srg930
           ELSE
              LET g_srg[l_ac].gem02c=s_costcenter_desc(g_srg[l_ac].srg930)
              DISPLAY BY NAME g_srg[l_ac].gem02c
           END IF
 
        AFTER FIELD srgud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
        AFTER FIELD srgud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_srg_t.srg02 > 0 AND g_srg_t.srg02 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
                DELETE FROM srg_file
                 WHERE srg01 = g_srf.srf01
                   AND srg02 = g_srg_t.srg02
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_srg_t.srg02,SQLCA.sqlcode,0)
                    ROLLBACK WORK
                    CANCEL DELETE
                END IF
                COMMIT WORK
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_srg[l_ac].* = g_srg_t.*
               CLOSE t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_srg[l_ac].srg02,-263,1)
               LET g_srg[l_ac].* = g_srg_t.*
            ELSE
              CALL t300_b_move_back() #FUN-730075
              UPDATE srg_file SET * = b_srg.*
               WHERE srg01=g_srf.srf01 AND srg02=g_srg_t.srg02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
                  CALL cl_err('upd srg',SQLCA.sqlcode,0)
                  LET g_srg[l_ac].* = g_srg_t.*
               ELSE
                  MESSAGE 'UPDATE O.K'
                  COMMIT WORK
               END IF
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac            #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_srg[l_ac].* = g_srg_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_srg.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE t300_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac            #FUN-D40030 add
            CLOSE t300_bcl
            COMMIT WORK
              CALL g_srg.deleteElement(g_rec_b+1)
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(srg02) AND l_ac > 1 THEN
                LET g_srg[l_ac].* = g_srg[l_ac-1].*
                LET g_srg[l_ac].srg02 = NULL
                NEXT FIELD srg02
            END IF
        ON ACTION controlp
           CASE
              WHEN INFIELD(srg16)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_sfb051"  #No.TQC-7C0117
                 CALL cl_create_qry() RETURNING g_srg[l_ac].srg16
                 DISPLAY BY NAME g_srg[l_ac].srg16
                 NEXT FIELD srg16
              WHEN INFIELD(srg03)
#FUN-AA0059---------mod------------str-----------------
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                CALL cl_create_qry() RETURNING g_srg[l_ac].srg03
                 CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                     RETURNING g_srg[l_ac].srg03  
#FUN-AA0059---------mod------------end-----------------
                 DISPLAY BY NAME g_srg[l_ac].srg03
                 NEXT FIELD srg03
              WHEN INFIELD(srg04)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_gfe"
                 CALL cl_create_qry() RETURNING g_srg[l_ac].srg04
                 DISPLAY BY NAME g_srg[l_ac].srg04
                 NEXT FIELD srg04
              WHEN INFIELD(srg11)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_sfp"
                 LET g_qryparam.arg1="A"
                 CALL cl_create_qry() RETURNING g_srg[l_ac].srg11
                 DISPLAY BY NAME g_srg[l_ac].srg11
                 NEXT FIELD srg11
              WHEN INFIELD(srg12)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_qcf1"
                 CALL cl_create_qry() RETURNING g_srg[l_ac].srg12
                 DISPLAY BY NAME g_srg[l_ac].srg12
                 NEXT FIELD srg12
 
              WHEN INFIELD(srg14)
                 IF NOT cl_null(g_srg[l_ac].srg16) AND
                    NOT cl_null(g_srg[l_ac].srg03) THEN
                    SELECT ima903 INTO l_ima903 FROM ima_file 
                                  WHERE ima01 = g_srg[l_ac].srg03
                    IF cl_null(l_ima903) THEN LET l_ima903 = 'N' END IF
                 END IF
                 IF g_sma.sma104 = 'Y' AND l_ima903 = 'Y' 
                    AND g_srg[l_ac].srg13 = '2' THEN 
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_bmm3"
                    LET g_qryparam.arg1 = g_srg[l_ac].srg03
                    CALL cl_create_qry() RETURNING g_srg[l_ac].srg14
                    DISPLAY BY NAME g_srg[l_ac].srg14
                    NEXT FIELD srg14
                 ELSE
#FUN-AA0059---------mod------------str-----------------
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form = "q_ima"
#                   CALL cl_create_qry() RETURNING g_srg[l_ac].srg14
                    CALL q_sel_ima(FALSE, "q_ima","","","","","","","",'' ) 
                      RETURNING g_srg[l_ac].srg14  
#FUN-AA0059---------mod------------end-----------------
                    DISPLAY BY NAME g_srg[l_ac].srg14
                    NEXT FIELD srg14
                 END IF            #No:MOD-980050 add
              WHEN INFIELD(srg930)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_gem4"
                 CALL cl_create_qry() RETURNING g_srg[l_ac].srg930
                 DISPLAY BY NAME g_srg[l_ac].srg930
                 NEXT FIELD srg930
              OTHERWISE
                 EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
 
    LET g_srf.srfmodu = g_user
    LET g_srf.srfdate = g_today
    UPDATE srf_file SET srfmodu = g_srf.srfmodu,srfdate = g_srf.srfdate
       WHERE srf01 = g_srf.srf01
    DISPLAY BY NAME g_srf.srfmodu,g_srf.srfdate
 
    IF g_srf.srfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
    CALL cl_set_field_pic(g_srf.srfconf,"","","",g_chr,"")
 
    CLOSE t300_bcl
    COMMIT WORK
    CALL t300_delHeader()     #CHI-C30002 add
END FUNCTION

#CHI-C30002 -------- add -------- begin
FUNCTION t300_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      CALL s_get_doc_no(g_srf.srf01) RETURNING l_slip
      LET l_sql = " SELECT COUNT(*) FROM srf_file ",
                  "  WHERE srf01 LIKE '",l_slip,"%' ",
                  "    AND srf01 > '",g_srf.srf01,"'"
      PREPARE t300_pb1 FROM l_sql 
      EXECUTE t300_pb1 INTO l_cnt       
      
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() AND l_cnt = 0 THEN
         CALL cl_getmsg('aec-130',g_lang) RETURNING g_msg
         LET l_num = 3
      ELSE
         CALL cl_getmsg('aec-131',g_lang) RETURNING g_msg
         LET l_num = 2
      END IF 
      LET g_action_choice = l_action_choice
      PROMPT g_msg CLIPPED,': ' FOR l_cho
         ON IDLE g_idle_seconds
            CALL cl_on_idle()

         ON ACTION about     
            CALL cl_about()

         ON ACTION help         
            CALL cl_show_help()

         ON ACTION controlg   
            CALL cl_cmdask() 
      END PROMPT
      IF l_cho > l_num THEN LET l_cho = 1 END IF 
      IF l_cho = 2 THEN 
         #CALL t300_x()         #CHI-D20010
         CALL t300_x(1)         #CHI-D20010
      END IF 
      
      IF l_cho = 3 THEN 
         DELETE FROM sri_file WHERE sri01 = g_srf.srf01
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM srf_file WHERE srf01 = g_srf.srf01
         INITIALIZE g_srf.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end
FUNCTION t300_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2           LIKE type_file.chr1000 #No.FUN-680130 VARCHAR(200)
 
    LET g_sql =
        "SELECT srg02,srg16,srg03,'','',srg04,srg15,srg05,srg06,srg07,",
        "srg08,srg09,srg10,srg19,srg11,srg17,srg12,srg18,srg13,srg14,srg930,'', ",  #FUN-910076 add srg19
        "srgud01,srgud02,srgud03,srgud04,srgud05,srgud06,srgud07,srgud08,",
        "srgud09,srgud10,srgud11,srgud12,srgud13,srgud14,srgud15", 
        "  FROM srg_file WHERE srg01  ='",g_srf.srf01,"'",  #單頭
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY srg02"
 
    PREPARE t300_pb FROM g_sql
    DECLARE srg_curs                       #SCROLL CURSOR
        CURSOR FOR t300_pb
 
    CALL g_srg.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH srg_curs INTO g_srg[g_cnt].*   #單身 ARRAY 填充
        IF STATUS THEN
          CALL cl_err('foreach:',STATUS,1)
          EXIT FOREACH
        END IF
        CALL t300_set_srg03(g_srg[g_cnt].srg03) RETURNING g_srg[g_cnt].ima02,
                                                          g_srg[g_cnt].ima021
        LET g_srg[g_cnt].gem02c=s_costcenter_desc(g_srg[g_cnt].srg930) #FUN-670103
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	       EXIT FOREACH
      END IF
    END FOREACH
    CALL g_srg.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-680130 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_srg TO s_srg.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
     ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL t300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY
 
      ON ACTION previous
         CALL t300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY
 
      ON ACTION jump
         CALL t300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL t300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION last
         CALL t300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY
 
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","","")
         IF g_srf.srfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
         CALL cl_set_field_pic(g_srf.srfconf,"","","",g_chr,"")
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #@ON ACTION 轉FQC/入庫單
      ON ACTION trans_store_fqc
         LET g_action_choice="trans_store_fqc"
         EXIT DISPLAY
      #@ON ACTION FQC單維護
      ON ACTION trans_fqc
         LET g_action_choice="trans_fqc"
         EXIT DISPLAY
      #@ON ACTION 入庫單維護
      ON ACTION trans_store
         LET g_action_choice="trans_store"
         EXIT DISPLAY
      #@ON ACTION 領料單產生
      ON ACTION gen_receive
         LET g_action_choice="gen_receive"
         EXIT DISPLAY
      #@ON ACTION 領料單維護
      ON ACTION maintain_receive
         LET g_action_choice="maintain_receive"
         EXIT DISPLAY
      #@ON ACTION 異常/例外工時
      ON ACTION def_wk
         LET g_action_choice="def_wk"
         EXIT DISPLAY
      #@ON ACTION 不良原因
      ON ACTION bad_maintain
         LET g_action_choice="bad_maintain"
         EXIT DISPLAY
      #@ON ACTION 人員報工
      ON ACTION lab_rep
         LET g_action_choice="lab_rep"
         EXIT DISPLAY
#@    ON ACTION 相關文件
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      #@ON ACTION 作廢
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY

      #CHI-D20010--add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010--add---end
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      ON ACTION exporttoexcel   #No.FUN-4B0019
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
    #@ON ACTION 拋轉至SPC
      ON ACTION trans_spc                      #FUN-680010
         LET g_action_choice="trans_spc"
         EXIT DISPLAY
 
    #@ON ACTION 列印
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY

      #DEV-D30045--add--begin
      ON ACTION barcode_gen
         LET g_action_choice="barcode_gen"
         EXIT DISPLAY

      ON ACTION barcode_query
         LET g_action_choice="barcode_query"
         EXIT DISPLAY

      ON ACTION barcode_output
         LET g_action_choice="barcode_output"
         EXIT DISPLAY
      #DEV-D30045--add--end
    
     &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t300_y() 			# when g_srf.srfconf='N' (Turn to 'Y')
DEFINE l_cnt   LIKE type_file.num5        #No.FUN-680130 SMALLINT
DEFINE i       LIKE type_file.num5        #No.FUN-840232
DEFINE l_srg16     LIKE srg_file.srg16        #FUN-C90077
#CHI-CA0048---S---
DEFINE l_sfb04 LIKE sfb_file.sfb04,
       l_sfb28 LIKE sfb_file.sfb28
#CHI-CA0048---E---

#CHI-C30107 --------------- add --------------- begin
   IF g_srf.srfconf='Y' THEN RETURN END IF
   IF g_srf.srfconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM srg_file
    WHERE srg01= g_srf.srf01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 --------------- add --------------- end
   SELECT * INTO g_srf.* FROM srf_file WHERE srf01 = g_srf.srf01
   IF g_srf.srfconf='Y' THEN RETURN END IF
   IF g_srf.srfconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM srg_file
    WHERE srg01= g_srf.srf01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
#FUN-C90077 -------------Begin-----------------
   DECLARE t300_srg16_cur CURSOR FOR
    SELECT DISTINCT(srg16) FROM srg_file,srf_file
     WHERE srg01 = g_srf.srf01
   FOREACH t300_srg16_cur INTO l_srg16
      IF STATUS THEN
         CALL cl_err('foreach:',STATUS,1)
         EXIT FOREACH
      END IF
      IF NOT t300_chk_sfb081(0,l_srg16,FALSE) THEN
         RETURN
      END IF 
      #MOD-D90079 add begin------------------------------
      IF NOT t300_srg05_check2(0,l_srg16,FALSE) THEN
         RETURN 
      END IF
      #MOD-D90079 add end--------------------------------
   END FOREACH 
#FUN-C90077 -------------End-------------------
  #CHI-CA0048---add---S
   FOR i = 1 TO l_cnt  
       LET l_sfb04 = NULL
       LET l_sfb28 = NULL
       SELECT sfb04,sfb28 INTO l_sfb04,l_sfb28
         FROM sfb_file
        WHERE sfb01=g_srg[i].srg16

       #IF l_sfb04 = '8' AND l_sfb28='3' THEN                    #MOD-D10074
       #IF l_sfb04 = '8' AND (l_sfb28='2' AND l_sfb28='3') THEN  #MOD-D10074  #CHI-CA0048 mark
        IF l_sfb04 = '8' AND (l_sfb28='2' OR l_sfb28='3') THEN   #CHI-CA0048
           CALL cl_err(g_srg[i].srg16,'asf-041',1)
           RETURN
       END IF
   END FOR  
  #CHI-CA0048---add---E
   BEGIN WORK
 
    OPEN t300_cl USING g_srf.srf01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_srf.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t300_cl
        ROLLBACK WORK
        RETURN
    END IF
 
   LET g_success = 'Y'
   UPDATE srf_file SET srfconf = 'Y' WHERE srf01 = g_srf.srf01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('upd srfconf',STATUS,1)
      LET g_success = 'N'
   END IF
   FOR i = 1 TO l_cnt
     UPDATE sfb_file SET sfb25 = g_srf.srf02
      WHERE sfb01 = g_srg[i].srg16
        AND sfb39 = '2'
     IF STATUS  THEN
        CALL cl_err('upd sfb25',STATUS,1)
        LET g_success = 'N'
     END IF
   END FOR
   CLOSE t300_cl
   IF (g_success = 'Y') AND (g_argv1='1') THEN
      CALL t300_upd_sre09("+")
   END IF
   IF (g_success = 'Y') AND (g_argv1='2') THEN
      CALL t300_upd_sfb12("+")
   END IF
   IF g_success = 'Y' THEN
      LET g_srf.srfconf='Y'
      COMMIT WORK
      DISPLAY BY NAME g_srf.srfconf
      CALL cl_flow_notify(g_srf.srf01,'Y')
  ELSE
      LET g_srf.srfconf='N'
      ROLLBACK WORK
  END IF
  CALL cl_set_field_pic("","","","","","")
  IF g_srf.srfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
  CALL cl_set_field_pic(g_srf.srfconf,"","","",g_chr,"")

   #DEV-D30045--add--begin
   #自動產生barcode
   IF g_success='Y' AND g_prog = 'asft300' AND g_aza.aza131 = 'Y' THEN
      CALL t300_barcode_gen(g_srf.srf01,'N')
   END IF
   #DEV-D30045--add--end

END FUNCTION
 
FUNCTION t300_z() 			# when g_srf.srfconf='Y' (Turn to 'N')
   DEFINE l_cnt LIKE type_file.num10   #No.FUN-680130 INTEGER
 
   SELECT * INTO g_srf.* FROM srf_file WHERE srf01 = g_srf.srf01
   IF g_srf.srfconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_srf.srfconf='N' THEN RETURN END IF
 
   LET l_cnt=0
   SELECT COUNT(*) INTO l_cnt FROM srg_file
    WHERE srg01=g_srf.srf01
      AND (srg11 IS NOT NULL OR srg12 IS NOT NULL)
   IF l_cnt>0 THEN
      CALL cl_err('undo confirm : ','asr-013',1)
      RETURN
   END IF
   IF NOT cl_null(g_srf.srf06) THEN
      CALL cl_err('','asr-024',1)
      RETURN
   END IF
   IF g_srf.srf02 <= g_sma.sma53 THEN
      CALL cl_err('','asr-051',1)
      RETURN
   END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK
 
    OPEN t300_cl USING g_srf.srf01
    IF STATUS THEN
       CALL cl_err("OPEN t300_cl:", STATUS, 1)
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t300_cl INTO g_srf.*          # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
        CLOSE t300_cl
        ROLLBACK WORK
        RETURN
    END IF
   LET g_success = 'Y'
   UPDATE srf_file SET srfconf = 'N'
      WHERE srf01 = g_srf.srf01
   IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
      CALL cl_err('upd_z srfconf',STATUS,1)
      LET g_success = 'N'
   END IF
   CLOSE t300_cl
   IF (g_success = 'Y') AND (g_argv1='1') THEN
      CALL t300_upd_sre09("-")
   END IF
   IF (g_success = 'Y') AND (g_argv1='2') THEN
      CALL t300_upd_sfb12("-")
   END IF

   #DEV-D30045--add--begin
   #自動作廢barcode
   IF g_success='Y' AND g_prog = 'asft300' AND g_aza.aza131 = 'Y' THEN
      CALL t300_barcode_z(g_srf.srf01)
   END IF
   #DEV-D30045--add--end

   IF g_success = 'Y' THEN
      LET g_srf.srfconf='N'
      COMMIT WORK
      DISPLAY BY NAME g_srf.srfconf
   ELSE
      LET g_srf.srfconf='Y'
      ROLLBACK WORK
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_srf.srfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_srf.srfconf,"","","",g_chr,"")

END FUNCTION
 
FUNCTION t300_upd_sre09(p_opt)
DEFINE p_opt LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1) 
       l_sre09 LIKE sre_file.sre09,
       l_srg RECORD LIKE srg_file.*
 
   DECLARE t300_upd_sre09 CURSOR FOR SELECT * FROM srg_file
                                           WHERE srg01=g_srf.srf01
   FOREACH t300_upd_sre09 INTO l_srg.*
      SELECT sre09 INTO l_sre09 FROM sre_file WHERE sre03=g_srf.srf03  #機台
                                                AND sre04=l_srg.srg03  #料號
                                                AND sre05=g_srf.srf04  #班別
                                                AND sre06=g_srf.srf05  #計畫日
      IF cl_null(l_sre09) THEN
         LET l_sre09=0
      END IF
      IF cl_null(l_srg.srg05) THEN
         LET l_srg.srg05=0
      END IF
      CASE p_opt
         WHEN '+'
            UPDATE sre_file SET sre09=l_sre09 + l_srg.srg05 WHERE sre03=g_srf.srf03  #機台
                                                              AND sre04=l_srg.srg03  #料號
                                                              AND sre05=g_srf.srf04  #班別
                                                              AND sre06=g_srf.srf05  #計畫日
         WHEN '-'
            UPDATE sre_file SET sre09=l_sre09 - l_srg.srg05 WHERE sre03=g_srf.srf03  #機台
                                                              AND sre04=l_srg.srg03  #料號
                                                              AND sre05=g_srf.srf04  #班別
                                                              AND sre06=g_srf.srf05  #計畫日
      END CASE
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(l_srg.srg02,STATUS,1)  #提示無法更新,但不脫離
      END IF
   END FOREACH
END FUNCTION
 
FUNCTION t300_upd_sfb12(p_opt)
DEFINE p_opt LIKE type_file.chr1,
       l_srg RECORD LIKE srg_file.*
 
   DECLARE t300_upd_sfb12 CURSOR FOR SELECT * FROM srg_file
                                             WHERE srg01=g_srf.srf01
   FOREACH t300_upd_sfb12 INTO l_srg.*
      IF SQLCA.sqlcode THEN
         CALL cl_err("upd sfb12",SQLCA.sqlcode,0)    
         RETURN
      END IF
      IF cl_null(l_srg.srg07) THEN LET l_srg.srg07=0 END IF
      CASE p_opt
         WHEN '+'
            UPDATE sfb_file SET sfb12=sfb12 + l_srg.srg07 WHERE sfb01=l_srg.srg16    #工單
         WHEN '-'
            UPDATE sfb_file SET sfb12=sfb12 - l_srg.srg07 WHERE sfb01=l_srg.srg16    #工單
      END CASE
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err(l_srg.srg02,STATUS,1)  #提示無法更新,但不脫離
      END IF
   END FOREACH
END FUNCTION
 
#FUNCTION t300_x()                          #CHI-D20010
FUNCTION t300_x(p_type)                     #CHI-D20010
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   SELECT * INTO g_srf.* FROM srf_file WHERE srf01=g_srf.srf01
   IF g_srf.srf01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   IF g_srf.srfconf = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF
   #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_srf.srfconf='X' THEN RETURN END IF
   ELSE
      IF g_srf.srfconf<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t300_cl USING g_srf.srf01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_srf.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t300_cl ROLLBACK WORK RETURN
   END IF
   #-->作廢轉換
   #IF cl_void(0,0,g_srf.srfconf)   THEN                                #CHI-D20010
    IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
    IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
      LET g_chr=g_srf.srfconf
      #IF g_srf.srfconf ='N' THEN                                       #CHI-D20010
       IF p_type = 1 THEN                                               #CHI-D20010
         LET g_srf.srfconf='X'
      ELSE
         LET g_srf.srfconf='N'
      END IF
 
      UPDATE srf_file SET srfconf = g_srf.srfconf,
                          srfmodu = g_user,
                          srfdate = g_today
       WHERE srf01 = g_srf.srf01
      IF STATUS THEN CALL cl_err('upd srfconf:',STATUS,1) LET g_success='N' END IF
      IF g_success='Y' THEN
         COMMIT WORK
      ELSE
          ROLLBACK WORK
      END IF
     SELECT srfconf INTO g_srf.srfconf
        FROM srf_file
       WHERE srf01 = g_srf.srf01
      DISPLAY BY NAME g_srf.srfconf
   END IF
   CALL cl_set_field_pic("","","","","","")
   IF g_srf.srfconf='X' THEN LET g_chr='Y' ELSE LET g_chr='N' END IF
   CALL cl_set_field_pic(g_srf.srfconf,"","","",g_chr,"")
END FUNCTION
 
FUNCTION t300_set_srg03(p_srg03)
  DEFINE p_srg03 LIKE srg_file.srg03
  DEFINE l_ima02 LIKE ima_file.ima02
  DEFINE l_ima021 LIKE ima_file.ima021
  LET l_ima02=''
  LET l_ima021=''
  SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
     WHERE ima01=p_srg03
  RETURN l_ima02,l_ima021
END FUNCTION
 
FUNCTION t300_set_srf03(p_srf03)
  DEFINE p_srf03 LIKE srf_file.srf03
  DEFINE l_eci06 LIKE eci_file.eci06
  LET l_eci06=''
  SELECT eci06 INTO l_eci06 FROM eci_file
     WHERE eci01=p_srf03
  RETURN l_eci06
END FUNCTION
 
FUNCTION t300_set_srf04(p_srf04)
  DEFINE p_srf04 LIKE srf_file.srf04
  DEFINE l_ecg02 LIKE ecg_file.ecg02
  LET l_ecg02=''
  SELECT ecg02 INTO l_ecg02 FROM ecg_file
     WHERE ecg01=p_srf04
  RETURN l_ecg02
END FUNCTION
 
#FUNCTION t300_chk_time(p_time)  #MOD-D10197
FUNCTION t300_chk_time(p_time,p_type)  #MOD-D10197
  DEFINE p_time     LIKE type_file.chr5    #No.FUN-680130 VARCHAR(05)
  DEFINE p_type     LIKE type_file.num5    #MOD-D10197
  DEFINE l_str      STRING

  LET g_errno=''
  IF p_type = 1 THEN  #MOD-D10197 
#  IF p_time[1,2] < 0 OR p_time[1,2] > 23 THEN LET g_errno='apy-080' END IF    #CHI-B40058
     IF p_time[1,2] < 0 OR p_time[1,2] > 23 THEN LET g_errno='asr-057' END IF     #CHI-B40058
#  IF p_time[4,5] < 0 OR p_time[4,5] > 59 THEN LET g_errno='apy-080' END IF    #CHI-B40058
     IF p_time[4,5] < 0 OR p_time[4,5] > 59 THEN LET g_errno='asr-057' END IF     #CHI-B40058
  #MOD-D10197---begin
  ELSE
     IF p_time[1,2] < 0 OR p_time[1,2] > 24 THEN LET g_errno='asr-057' END IF 
     IF p_time[4,5] < 0 OR p_time[4,5] > 59 THEN LET g_errno='asr-057' END IF
  END IF 
  ##MOD-D10197---end
  LET l_str=p_time
  LET l_str=l_str.trim()
  IF Length(l_str)<5 THEN
    LET g_errno='aem-006'
  END IF
END FUNCTION
 
FUNCTION t300_cacl_time(p_srg08,p_srg09)
  DEFINE p_srg08       LIKE srg_file.srg08
  DEFINE p_srg09       LIKE srg_file.srg09
  DEFINE l_tot         LIKE srg_file.srg10
  DEFINE l_str         STRING
  DEFINE l_hr,l_min    LIKE type_file.num5    #No.FUN-680130 SMALLINT
 
  LET g_errno=''
  LET l_tot=0
  LET l_str=p_srg08
  LET l_str=l_str.trim()
  IF (cl_null(l_str)) OR (l_str=':') THEN
    RETURN l_tot
  END IF
  LET l_str=p_srg09
  LET l_str=l_str.trim()
  IF (cl_null(l_str)) OR (l_str=':') THEN
    RETURN l_tot
  END IF
  LET l_hr=p_srg09[1,2]-p_srg08[1,2]
  IF l_hr<0 THEN
    LET l_hr=l_hr+24
  END IF
  LET l_hr=60*l_hr
 
  LET l_min=p_srg09[4,5]-p_srg08[4,5]
 
  LET l_tot=l_hr+l_min
 
  IF l_tot<0 THEN
    LET g_errno='asr-002'
    LET l_tot=0
  END IF
 
  RETURN l_tot
END FUNCTION
 
FUNCTION t300_w()
DEFINE l_cnt LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE l_str STRING
#TQC-B60090 --------Begin--------------
DEFINE l_cnt1_n     LIKE type_file.num5
DEFINE l_qc_cnt_n   LIKE type_file.num5
DEFINE l_cnt2_n     LIKE type_file.num5
DEFINE l_stockin_n  LIKE type_file.num5
#TQC-B60090 --------End----------------

   SELECT * INTO g_srf.* FROM srf_file WHERE srf01 = g_srf.srf01
   IF g_srf.srfconf = 'X' THEN CALL cl_err(' ','9024',0) RETURN END IF
   IF g_srf.srfconf<>'Y' THEN CALL cl_err(' ','9029',0) RETURN END IF
   SELECT COUNT(*) INTO l_cnt FROM srg_file
      WHERE srg01= g_srf.srf01
   IF l_cnt = 0 THEN
      CALL cl_err('','mfg-009',0)
      RETURN
   END IF

   BEGIN WORK
   OPEN t300_cl USING g_srf.srf01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_srf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
       CLOSE t300_cl
       ROLLBACK WORK
       RETURN
   END IF
   CALL t300_w1()
   CLOSE t300_cl
   IF g_success = 'Y' THEN
      COMMIT WORK
      CALL t300_b_fill(" 1=1")
#TQC-B60090 -----------------------Begin-------------------------
      CALL t730_fqc_count() RETURNING l_cnt1_n,l_qc_cnt_n,l_cnt2_n,l_stockin_n  #重新抓取應產生和已應產的FQC單筆數和入庫單筆數
      IF g_qc_cnt = l_qc_cnt_n AND g_stockin_cnt = l_stockin_n THEN
         CALL cl_err('','axc-034',0)
      ELSE 
#TQC-B60090 -----------------------End----------------------------
         CALL cl_err('','asr-026',0)
      END IF    #TQC-B60090
   ELSE
      ROLLBACK WORK
      CALL cl_err('','9052',0)
   END IF
END FUNCTION
 
FUNCTION t300_w1()
DEFINE l_srg        RECORD LIKE srg_file.*,
       l_sfu        RECORD LIKE sfu_file.*,
       l_ksc        RECORD LIKE ksc_file.*, #FUN-840148
       l_cnt        LIKE type_file.num10,  #No.FUN-680130 INTEGER 
#      l_cnt1       LIKE type_file.num10,   #MOD-A50150 add        #TQC-B60090
#      l_cnt2       LIKE type_file.num10,   #MOD-A50150 add        #TQC-B60090 
       l_gen02      LIKE gen_file.gen02,
       l_qcs091     LIKE qcs_file.qcs091,
       li_result    LIKE type_file.num5,   #No.FUN-680130 SMALLINT 
       l_imd02      LIKE imd_file.imd02,
       l_sfv03      LIKE sfv_file.sfv03
DEFINE l_gaz03      LIKE gaz_file.gaz03
DEFINE l_qc_cnt    LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_qc_prog    LIKE type_file.chr20   #No.FUN-680130 VARCHAR(10)
DEFINE l_err        STRING
DEFINE l_slip       LIKE smy_file.smyslip  #TQC-AC0294
DEFINE l_smy73      LIKE type_file.chr1    #TQC-AC0294
DEFINE l_srg15      LIKE srg_file.srg15    #TQC-B30027 
DEFINE l_srg16      LIKE srg_file.srg16    #TQC-B30027 
DEFINE l_t          LIKE type_file.num5    #TQC-B30027 
DEFINE l_flag       LIKE type_file.chr1    #TQC-B60062
DEFINE l_srg03      LIKE srg_file.srg03    #TQC-C20240
DEFINE l_srg16m     LIKE srg_file.srg16    #TQC-C20240
DEFINE l_srg02      LIKE srg_file.srg02    #lixh1
DEFINE l_msg        STRING        #lixh1
DEFINE l_n          LIKE type_file.num5    #MOD-C30662
DEFINE l_n1         LIKE type_file.num5    #MOD-C30662
DEFINE l_n2         LIKE type_file.num5    #MOD-C30662
#TQC-B60090 ---------------------Begin ---------------------------
# #str MOD-A50150 add
# #若已產生FQC/入庫單後再點選轉FQC/入庫單時應提示訊息且不開啟畫面
#  #應產生FQC的單身筆數
#  LET l_cnt1=0
#  SELECT COUNT(*) INTO l_cnt1 FROM srg_file 
#   WHERE srg01=g_srf.srf01 AND srg15 ='Y'
#  #已產生FQC的單身筆數
#  LET l_qc_cnt=0
#  SELECT COUNT(*) INTO l_qc_cnt FROM srg_file  
#   WHERE srg01 = g_srf.srf01
#     AND srg15 ='Y' 
#     AND srg12 IS NOT NULL
#  #2.檢查是否已產生入庫單
#  #應產生入庫單的單身筆數
#  LET l_cnt2=0
#  SELECT COUNT(*) INTO l_cnt2 FROM srg_file 
#   WHERE srg01=g_srf.srf01
#  #已產生入庫單的單身筆數
#  LET l_cnt=0
#  IF g_argv1='1' THEN #FUN-840148
#    SELECT COUNT(*) INTO l_cnt FROM srg_file
#     WHERE srg01=g_srf.srf01
#       AND ((srg15='N' AND srg05>0 AND srg11 IS NOT NULL) 
#        OR  (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NOT NULL))
#  ELSE
#    SELECT COUNT(*) INTO l_cnt FROM srg_file,sfb_file  #FUN-840148 
#     WHERE srg01=g_srf.srf01
#       AND ((srg15='N' AND srg05>0 AND srg11 IS NOT NULL) 
#        OR  (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NOT NULL))
#       AND sfb01=srg16  #FUN-840148
#       AND sfb02<>'11'  #FUN-840148
#  END IF
#  IF cl_null(l_cnt1)   THEN LET l_cnt1=0   END IF
#  IF cl_null(l_qc_cnt) THEN LET l_qc_cnt=0 END IF
#  IF cl_null(l_cnt2)   THEN LET l_cnt2=0   END IF
#  IF cl_null(l_cnt)    THEN LET l_cnt=0    END IF
#TQC-B60090 --------------------------End----------------------------
   CALL t730_fqc_count() RETURNING g_cnt1,g_qc_cnt,g_cnt2,g_stockin_cnt   #TQC-B60090
   #應該產生FQC的單身都已產生FQC,應該產生入庫單的單身都已產生入庫單,
   #提示訊息且不執行此功能
#  IF l_cnt1 = l_qc_cnt AND l_cnt2 = l_cnt THEN            #TQC-B60090
   IF g_cnt1 = g_qc_cnt AND g_cnt2 = g_stockin_cnt THEN    #TQC-B60090
      CALL cl_err('','asr-053',1)
      LET g_success = 'N'
      RETURN
   END IF
  #end MOD-A50150 add

   OPEN WINDOW t300_w1_w AT 2,2 WITH FORM "asr/42f/asrt300a"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 

   CALL cl_ui_locale("asrt300a")

#MOD-C30662--add--start--
   IF g_argv1 ='2' THEN 
      LET l_n = 0
      LET l_n1 = 0
      LET l_n2 = 0
      CALL cl_set_comp_entry("slip,slip2",TRUE) 
      SELECT COUNT(*) INTO l_n FROM srg_file,sfb_file WHERE srg01 = g_srf.srf01 AND srg16 = sfb01  #TQC-C70008
      SELECT COUNT(*) INTO l_n1 FROM srg_file,sfb_file WHERE srg01 = g_srf.srf01 AND srg16 = sfb01 AND sfb02 = '11' 
      SELECT COUNT(*) INTO l_n2 FROM srg_file,sfb_file WHERE srg01 = g_srf.srf01 AND srg16 = sfb01 AND sfb02 != '11'
      IF l_n = l_n1 THEN 
         CALL cl_set_comp_entry("slip",FALSE)
      END IF 
      IF l_n = l_n2 THEN 
         CALL cl_set_comp_entry("slip2",FALSE)
      END IF 
   END IF
#MOD-C30662  ---add---end
   IF g_argv1='1' THEN
      CALL cl_set_comp_visible("qcf01",FALSE)      
      CALL cl_set_comp_visible("slip2",FALSE)     #FUN-840148 
   END IF
   #FUN-BC0104-add-str--
   SELECT qcz14 INTO g_qcz.qcz14 FROM qcz_file
   IF g_qcz.qcz14 = 'N' THEN
      CALL cl_set_comp_visible("choice3",FALSE)
   END IF
   #FUN-BC0104-add-end--
  #LET tm.choice1= g_sma.sma896   #MOD-A50150 mark
   #還有未產生FQC的單身
  #IF l_cnt1 != l_qc_cnt THEN     #MOD-A50150 add  #TQC-B60090 mark
   IF g_cnt1 != g_qc_cnt THEN     #TQC-B60090 add
      LET tm.choice1='Y'          #MOD-A50150 add
   ELSE                           #MOD-A50150 add
      LET tm.choice1='N'          #MOD-A50150 add
   END IF                         #MOD-A50150 add
   #NO.TQC-A30099--begin
   IF g_argv1='2' THEN
      CALL cl_set_comp_entry("qcf01,dt1,emp",TRUE) 
      LET tm.choice1='N' 
   END IF 
   #NO.TQC-A30099--end  
  #LET tm.choice2='Y'             #MOD-A50150 mark
   #還有未產生入庫單的單身
  #IF l_cnt2 != l_cnt THEN        #MOD-A50150 add  #TQC-B60090 mark
   IF g_cnt2 != g_stockin_cnt THEN       #TQC-B60090 add 
      LET tm.choice2='Y'          #MOD-A50150 add
   ELSE                           #MOD-A50150 add
      LET tm.choice2='N'          #MOD-A50150 add
   END IF                         #MOD-A50150 add
   LET tm.choice3 = 'N'           #FUN-BC0104 add
   LET tm.dt1=g_today
   LET tm.dt2=g_today
   LET tm.emp=g_user
   LET tm.slip=null
   LET tm.slip2=null #FUN-840148
   LET tm.qcf01=null
 
   WHILE TRUE
      INPUT BY NAME tm.choice1,tm.qcf01,tm.dt1,tm.emp,tm.choice2,tm.choice3,           #FUN-BC0104 add choice3
                    tm.slip,tm.slip2,tm.dt2,tm.wh1,tm.wh2,tm.wh3 #FUN-840148
                    WITHOUT DEFAULTS
        #NO.TQC-A30099--begin
        BEFORE INPUT 
           IF g_argv1='2' THEN 
              CALL cl_set_comp_entry("qcf01,dt1,emp",FALSE)
              LET tm.dt1=NULL
              LET tm.emp=NULL
              DISPLAY BY NAME tm.dt1    
              DISPLAY BY NAME tm.emp
           END IF 
        #NO.TQC-A30099--end

        BEFORE FIELD choice1                                  #MOD-A50150 add
           CALL cl_set_comp_required("qcf01",tm.choice1='Y')  #MOD-A50150 add

        ON CHANGE choice1
           IF g_argv1='2' THEN #TQC-680008
              CALL cl_set_comp_required("qcf01",tm.choice1='Y')
           END IF
           #NO.TQC-A30099--begin
           IF tm.choice1='Y' THEN 
              CALL cl_set_comp_entry("qcf01,dt1,emp",TRUE)
              LET tm.dt1=g_today
              LET tm.emp=g_user
              DISPLAY BY NAME tm.dt1    
              DISPLAY BY NAME tm.emp
           ELSE 
              CALL cl_set_comp_entry("qcf01,dt1,emp",FALSE)
              LET tm.dt1=NULL
              LET tm.emp=NULL    
              DISPLAY BY NAME tm.dt1    
              DISPLAY BY NAME tm.emp
           END IF  
           #NO.TQC-A30099--end

        BEFORE FIELD choice2                                           #MOD-A50150 add
           CALL cl_set_comp_required("slip,slip2,dt2",tm.choice2='Y')  #MOD-A50150 add

        ON CHANGE choice2
           CALL cl_set_comp_required("slip,slip2,dt2",tm.choice2='Y') #FUN-840148
           IF tm.choice2 = 'Y' THEN LET tm.choice3 = 'N' END IF     #FUN-BC0104
           CALL cl_set_comp_entry("wh1,wh2,wh3",TRUE)               #FUN-BC0104
           DISPLAY BY NAME tm.choice3                               #FUN-BC0104

        #FUN-BC0104-add-str--
        ON CHANGE choice3
           CALL cl_set_comp_entry("wh1,wh2,wh3",tm.choice3='N')
           IF tm.choice3 = 'Y' THEN LET tm.choice2 = 'N' END IF
           DISPLAY BY NAME tm.choice2  
        #FUN-BC0104-add-end--
      
        AFTER FIELD qcf01
           IF NOT cl_null(tm.qcf01) THEN
              LET g_t1 = s_get_doc_no(tm.qcf01)
              CALL s_check_no("asf",g_t1,"","B","qcf_file","qcf01","")
                    RETURNING li_result,tm.qcf01
              IF (NOT li_result) THEN
                NEXT FIELD qcf01
              END IF
           END IF
        
        AFTER FIELD emp
           IF NOT cl_null(tm.emp) THEN
              LET l_gen02=''
              SELECT gen02 INTO l_gen02 FROM gen_file WHERE gen01=tm.emp
              DISPLAY l_gen02 TO FORMONLY.gen02
              IF SQLCA.sqlcode THEN
                 CALL cl_err('',100,1)
                 NEXT FIELD emp
              END IF
           ELSE
              LET l_gen02=''
              DISPLAY l_gen02 TO FORMONLY.gen02
           END IF
      
        AFTER FIELD slip
           IF NOT cl_null(tm.slip) THEN
              CALL s_check_no("asf",tm.slip,'',"A","sfu_file","sfu01","")
                     RETURNING li_result,tm.slip
              IF (NOT li_result) THEN
                 NEXT FIELD slip
              END IF
              #TQC-AC0294------start------
              LET l_slip = s_get_doc_no(tm.slip)
 
              SELECT smy73 INTO l_smy73 FROM smy_file
               WHERE smyslip = l_slip
              
              IF l_smy73 = 'Y' THEN
              CALL cl_err(tm.slip,'asf-876',0)
              NEXT FIELD slip
              END IF
              #TQC-AC0294-------END--------
           END IF
 
        AFTER FIELD slip2
           IF NOT cl_null(tm.slip2) THEN
              CALL s_check_no("asf",tm.slip2,'',"C","ksc_file","ksc01","")
                     RETURNING li_result,tm.slip2
              IF (NOT li_result) THEN
                 NEXT FIELD slip2
              END IF
           END IF
      
      
        AFTER FIELD wh1
           IF tm.wh1 IS NOT NULL THEN
              SELECT imd02 INTO l_imd02 FROM imd_file WHERE imd01 = tm.wh1
              IF STATUS THEN
                 CALL cl_err('sel imd',STATUS,0)
                 NEXT FIELD wh1
              END IF
              #No.FUN-AA0062  --Begin
              IF NOT s_chk_ware(tm.wh1) THEN
                 NEXT FIELD wh1
              END IF
             #No.FUN-AA0062  --End
           END IF

        #No.TQC-B70054 --Begin
        AFTER INPUT
           IF g_cnt1 > 0 AND tm.choice1 = 'Y' AND tm.choice2 = 'Y' THEN
              #单身有需FQC的工单时,FQC单及入库单无法同时生成,需先审核生成的FQC单后,才可生成入库单!
              CALL cl_err(tm.qcf01,'asr-062',1)
              NEXT FIELD choice1
           END IF
        #No.TQC-B70054 --End
      
        ON ACTION controlp
           CASE
              WHEN INFIELD(qcf01) #單號
                   LET g_t1 = s_get_doc_no(tm.qcf01)
                   CALL q_smy(FALSE,FALSE,g_t1,'ASF','B') RETURNING g_t1  #TQC-670008
                   LET tm.qcf01 = g_t1
                   DISPLAY BY NAME tm.qcf01
                   NEXT FIELD qcf01
                WHEN INFIELD(emp)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_gen"
                   CALL cl_create_qry() RETURNING tm.emp
                   DISPLAY BY NAME tm.emp
                   NEXT FIELD emp
                WHEN INFIELD(slip)
                   LET g_t1 = s_get_doc_no(tm.slip)
                   LET g_sql = " (smy73 <> 'Y' OR smy73 is null)"  #TQC-AC0294 add
                   CALL smy_qry_set_par_where(g_sql)               #TQC-AC0294 add
                   CALL q_smy( FALSE,TRUE,g_t1,'ASF','A') RETURNING g_t1   #TQC-670008
                   LET tm.slip=g_t1
                   DISPLAY BY NAME tm.slip
                   NEXT FIELD slip
                WHEN INFIELD(slip2)
                   LET g_t1 = s_get_doc_no(tm.slip2)
                   CALL q_smy( FALSE,TRUE,g_t1,'ASF','C') RETURNING g_t1   #TQC-670008
                   LET tm.slip2=g_t1
                   DISPLAY BY NAME tm.slip2
                   NEXT FIELD slip2
                WHEN INFIELD(wh1)
#No.FUN-AA0062  --Begin                
#                   CALL cl_init_qry_var()
#                   LET g_qryparam.form ="q_imd"
#                   LET g_qryparam.arg1 = 'SW'        #倉庫類別
#                   CALL cl_create_qry() RETURNING tm.wh1
                   CALL q_imd_1(FALSE,TRUE,tm.wh1,"","","","") RETURNING tm.wh1
#No.FUN-AA0062  --End                   
                   DISPLAY BY NAME tm.wh1
                   NEXT FIELD wh1
               #MOD-C60065 add str------------------------
                WHEN INFIELD(wh2)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_ime"
                   LET g_qryparam.arg1     = tm.wh1
                   LET g_qryparam.arg2     = 'SW'
                   LET g_qryparam.default1 = tm.wh2
                   CALL cl_create_qry() RETURNING tm.wh2
                   DISPLAY BY NAME tm.wh2
                   NEXT FIELD wh2
               #MOD-C60065 add end------------------------
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
      
      END INPUT
      
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_success='N'
         CLOSE WINDOW t300_w1_w
         RETURN
      END IF
#TQC-B30027--begin
      IF tm.choice1 = 'N' AND tm.choice2 = 'Y' THEN   #TQC-B60062
         CALL s_showmsg_init()
         DECLARE t300_srg CURSOR FOR SELECT srg16,srg15 FROM srg_file WHERE srg01=g_srf.srf01
         FOREACH t300_srg INTO l_srg16,l_srg15
            IF l_srg15='Y' THEN 
               SELECT COUNT(*) INTO l_t FROM qcf_file WHERE qcf00='1' AND qcf02=l_srg16 AND qcf14='Y' 
               IF l_t=0 THEN 
                  CALL s_errmsg('srg16',l_srg16,'','asr-055',1) 
               END IF  
            END IF 
         END FOREACH 
         CALL s_showmsg() 
      END IF     #TQC-B60062
#TQC-B30027--end    
      LET g_success = 'Y'     
      
      IF tm.choice1='Y' THEN
         #檢查資料是否可拋轉至 SPC
         IF g_aza.aza64 matches '[Yy]'THEN
            IF g_srf.srfspc matches '[1]' THEN                #判斷是否已拋轉
               CALL cl_err('','aqc-116',0)
               LET g_success = 'N'
               RETURN
            END IF
            
            #若報工單單身已有FQC單號(表示有FQC單)，則取消拋轉至SPC
            IF g_argv1 = '1' THEN    
               LET l_qc_prog = "asrt310"                #設定FQC單的程式代號
            ELSE
               LET l_qc_prog = "aqct410"                #設定FQC單的程式代號
            END IF
            SELECT COUNT(*) INTO l_qc_cnt FROM srg_file 
             WHERE srg01 = g_srf.srf01
               AND srg15 ='Y' 
               AND srg12 IS NOT NULL
            IF l_qc_cnt > 0 THEN  
               CALL cl_get_progname(l_qc_prog,g_lang) RETURNING l_gaz03
               CALL cl_err_msg(g_srf.srf01,'aqc-115', l_gaz03 CLIPPED || "|" || l_qc_prog CLIPPED,'1')
               LET g_success = 'N'
               RETURN
            END IF
         END IF
 
         LET l_flag = 'N'    #TQC-B60062
         DECLARE t300_w2_cur CURSOR FOR SELECT * FROM srg_file
                          WHERE srg01=g_srf.srf01 AND srg15='Y' AND srg05>0
         FOREACH t300_w2_cur INTO l_srg.*
            IF g_success='N' THEN
               EXIT FOREACH
            END IF
            LET l_flag = 'Y'   #TQC-B60062
            LET g_t1 = s_get_doc_no(tm.qcf01) #FUN-840148
            IF (l_srg.srg15='Y') AND cl_null(l_srg.srg12) THEN
               CASE g_argv1
                  WHEN "1"  #ASR
                     CALL t300_w2(l_srg.*)
                  WHEN "2"  #ASF
                    SELECT COUNT(*) INTO l_cnt FROM shm_file  #此工單走run card    
                     WHERE shm012 = l_srg.srg16
                    IF l_cnt > 0  THEN
                       CALL cl_err(l_srg.srg16,"asf-990",1) 
                       LET g_success ='N'
                       EXIT FOREACH
                    END IF 
                     CALL s_auto_assign_no("asf",g_t1,tm.dt1,"B","qcf_file","qcf01","","","")  #FUN-840148
                                 RETURNING li_result,tm.qcf01
                     IF (NOT li_result) THEN
                        CALL cl_err('qcf01',"sub-143",1)  #FUN-680010
                        LET g_success ='N'
                        EXIT FOREACH
                     END IF
                     CALL t300_w4(l_srg.*)
               END CASE
            END IF
         END FOREACH
         #TQC-B60062--add--str--
         IF l_flag = 'N' THEN
            CALL cl_err(g_srf.srf01,"asr-061",1)   
         END IF
         #TQC-B60062--add--end--
      END IF
      
      IF (tm.choice2='Y') AND (g_success='Y') THEN   ##如果QC單有產生失敗
         IF cl_null(tm.wh2) THEN                     ##則入庫單就不操作執行
            LET tm.wh2=' '
         END IF
         IF cl_null(tm.wh3) THEN
            LET tm.wh3=' '
         END IF
         LET l_cnt=0 
       IF g_argv1='1' THEN #FUN-840148
          SELECT COUNT(*) INTO l_cnt FROM srg_file 
          WHERE srg01=g_srf.srf01
           #    ##避免產生有單頭無單身情況
            AND ((srg15='N' AND srg05>0 AND (srg11 IS NULL OR srg11=' ')) 
             OR   (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NULL))
       ELSE
         SELECT COUNT(*) INTO l_cnt FROM srg_file,sfb_file  #FUN-840148 
          WHERE srg01=g_srf.srf01
            AND ((srg15='N' AND srg05>0 AND (srg11 IS NULL OR srg11=' ')) 
             OR  (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NULL ))
            AND sfb01=srg16  #FUN-840148
            AND sfb02<>'11'  #FUN-840148
       END IF
         IF l_cnt>0 THEN  #產生入庫單頭   
            INITIALIZE l_sfu.* TO NULL
            LET g_t1 = s_get_doc_no(tm.slip) #FUN-840148
           #CALL s_auto_assign_no("apm",g_t1,tm.dt2,"A","sfu_file","sfu01","","","") #FUN-840148    #No.TQC-A30099
            CALL s_auto_assign_no("asf",g_t1,tm.dt2,"A","sfu_file","sfu01","","","") #FUN-840148    #No.TQC-A30099
               RETURNING li_result,tm.slip
            IF (NOT li_result) THEN
               LET g_success='N'
               CALL cl_err('sfu01',"sub-143",1)
            END IF
 
            CASE g_argv1
               WHEN "1"
                  LET l_sfu.sfu00='3'   #重覆性生產入庫
               WHEN "2"
                  LET l_sfu.sfu00='1'   #工單完工入庫
            END CASE
            LET l_sfu.sfu01=tm.slip
            LET l_sfu.sfu02=tm.dt2
            LET l_sfu.sfu14=tm.dt2 #FUN-860069
            LET l_sfu.sfu04=g_grup
            LET l_sfu.sfupost='N'
            LET l_sfu.sfuconf='N' #FUN-660137
            LET l_sfu.sfuuser=g_user
            LET l_sfu.sfugrup=g_grup
            LET l_sfu.sfumodu=''
            LET l_sfu.sfudate=g_today
            LET l_sfu.sfuplant = g_plant #FUN-980008 add
            LET l_sfu.sfulegal = g_legal #FUN-980008 add
            LET l_sfu.sfuoriu = g_user      #No.FUN-980030 10/01/04
            LET l_sfu.sfuorig = g_grup      #No.FUN-980030 10/01/04
            #FUN-A80128---add---str--
            LET l_sfu.sfu15   = '0'
            LET l_sfu.sfu16   = g_user
            LET l_sfu.sfumksg = 'N' 
            #FUN-A80128---add---end--
            INSERT INTO sfu_file VALUES (l_sfu.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins sfu',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         END IF
 
       IF g_argv1='2' THEN
          LET l_cnt=0 
         SELECT COUNT(*) INTO l_cnt FROM srg_file,sfb_file
          WHERE srg01=g_srf.srf01
            AND ((srg15='N' AND srg05>0 AND (srg11 IS NULL OR srg11=' ')) 
             OR  (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NULL ))
            AND sfb01=srg16  #FUN-840148
            AND sfb02='11'  #FUN-840148
         IF l_cnt>0 THEN  #產生拆件入庫單頭      
            INITIALIZE l_ksc.* TO NULL
            LET g_t1 = s_get_doc_no(tm.slip2) #FUN-840148
            CALL s_auto_assign_no("asf",g_t1,tm.dt2,"C","ksc_file","ksc01","","","")
               RETURNING li_result,tm.slip2
            IF (NOT li_result) THEN
               LET g_success='N'
               CALL cl_err('ksc01',"sub-143",1)
            END IF
 
            CASE g_argv1
               WHEN "1"
                  LET l_ksc.ksc00='3'   #重覆性生產入庫
               WHEN "2"
                  LET l_ksc.ksc00='1'   #工單完工入庫
            END CASE
            LET l_ksc.ksc01=tm.slip2
            LET l_ksc.ksc02=tm.dt2
            LET l_ksc.ksc14=tm.dt2 #FUN-860069
            LET l_ksc.ksc04=g_grup
            LET l_ksc.kscpost='N'
            LET l_ksc.kscconf='N' #FUN-660137
            LET l_ksc.kscuser=g_user
            LET l_ksc.kscgrup=g_grup
            LET l_ksc.kscmodu=''
            LET l_ksc.kscdate=g_today
            LET l_ksc.kscplant = g_plant #FUN-980008 add
            LET l_ksc.ksclegal = g_legal #FUN-980008 add
            LET l_ksc.kscoriu = g_user      #No.FUN-980030 10/01/04
            LET l_ksc.kscorig = g_grup      #No.FUN-980030 10/01/04
            INSERT INTO ksc_file VALUES (l_ksc.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err('ins ksc',SQLCA.sqlcode,1)
               LET g_success='N'
            END IF
         END IF
       END IF
 
       IF g_argv1='1' THEN  #FUN-840148
         LET l_sfv03=1
         DECLARE t300_w3_cur CURSOR FOR SELECT * FROM srg_file
           WHERE srg01=g_srf.srf01
             AND ((srg15='N' AND srg05>0 AND (srg11 IS NULL OR srg11=' ')) 
              OR (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NULL))
         LET l_ac =0            #No.MOD-830181 add
         FOREACH t300_w3_cur INTO l_srg.*
            IF g_success='N' THEN
               EXIT FOREACH
            END IF
            IF (l_srg.srg15='N') AND cl_null(l_srg.srg11) THEN
               CALL t300_w3(l_srg.*,l_sfv03,l_srg.srg05)
               UPDATE srg_file set srg11=tm.slip
                WHERE srg01=l_srg.srg01
                  AND srg02=l_srg.srg02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err('upd srg11',SQLCA.sqlcode,1)
                  LET g_success='N'
               END IF
               LET l_sfv03=l_sfv03+1
               LET l_ac = l_ac + 1      #No.MOD-830181 add
            END IF
            IF (l_srg.srg15='Y') AND (NOT cl_null(l_srg.srg12)) AND 
                                          cl_null(l_srg.srg11) THEN
               LET l_cnt = 0 
               CASE g_argv1
                  WHEN "1" #ASR
                     SELECT COUNT(*) INTO l_cnt FROM qcs_file 
                      WHERE qcs01=l_srg.srg01
                        AND qcs02=l_srg.srg02
                        AND qcs14='Y'
                        AND (qcs09='1' OR qcs09='3')
                  WHEN "2" #ASF
                     SELECT COUNT(*) INTO l_cnt FROM qcf_file 
                      WHERE qcf01=l_srg.srg12
                        AND qcf14='Y'
                        AND (qcf09='1' OR qcf09='3')
               END CASE
               IF l_cnt>0 THEN     
                  LET l_qcs091=0
                  CASE g_argv1
                     WHEN "1" #ASR
                        SELECT qcs091 INTO l_qcs091 FROM qcs_file 
                         WHERE qcs01=l_srg.srg01
                           AND qcs02=l_srg.srg02
                     WHEN "2" #ASF
                        SELECT COUNT(*) INTO l_cnt FROM shm_file  #此工單走run card   
                          WHERE shm012 = l_srg.srg16
                         IF l_cnt > 0  THEN    
                            CALL cl_err(l_srg.srg16,"asf-990",1) 
                            LET g_success ='N'
                            EXIT FOREACH
                         END IF 
                        SELECT qcf091 INTO l_qcs091 FROM qcf_file 
                         WHERE qcf01=l_srg.srg12
                  END CASE
                  CALL t300_w3(l_srg.*,l_sfv03,l_qcs091)
                  UPDATE srg_file set srg11=tm.slip
                   WHERE srg01=l_srg.srg01
                     AND srg02=l_srg.srg02
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err('upd srg11',SQLCA.sqlcode,1)
                     LET g_success='N'
                  END IF
                  LET l_sfv03=l_sfv03+1
                  LET l_ac = l_ac + 1      #No.MOD-830181 add
               END IF
            END IF
         END FOREACH
         IF l_ac <= 0 THEN 
            DELETE FROM sfu_file WHERE sfu01= tm.slip
         END IF
       ELSE
         LET l_sfv03=1
         DECLARE t300_w31_cur CURSOR FOR SELECT srg_file.* FROM srg_file,sfb_file
           WHERE srg01=g_srf.srf01
             AND ((srg15='N' AND srg05>0 AND (srg11 IS NULL OR srg11=' ')) 
                  OR 
                  (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NULL))
             AND sfb01=srg16
             AND sfb02<>'11'
         FOREACH t300_w31_cur INTO l_srg.*
            IF g_success='N' THEN
               EXIT FOREACH
            END IF
            IF (l_srg.srg15='N') AND cl_null(l_srg.srg11) THEN
               CALL t300_w3(l_srg.*,l_sfv03,l_srg.srg05)
               UPDATE srg_file set srg11=tm.slip
                WHERE srg01=l_srg.srg01
                  AND srg02=l_srg.srg02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err('upd srg11',SQLCA.sqlcode,1)
                  LET g_success='N'
               END IF
               LET l_sfv03=l_sfv03+1
            END IF
            IF (l_srg.srg15='Y') AND (NOT cl_null(l_srg.srg12)) AND 
                                          cl_null(l_srg.srg11) THEN
               LET l_cnt = 0             
               SELECT COUNT(*) INTO l_cnt FROM qcf_file
                WHERE qcf01=l_srg.srg12
                  AND qcf14='Y'
                  AND (qcf09='1' OR qcf09='3')
               IF l_cnt>0 THEN 
                  LET l_qcs091=0
                  SELECT qcf091 INTO l_qcs091 FROM qcf_file 
                   WHERE qcf01=l_srg.srg12
                  CALL t300_w3(l_srg.*,l_sfv03,l_qcs091)
                  UPDATE srg_file set srg11=tm.slip
                   WHERE srg01=l_srg.srg01
                     AND srg02=l_srg.srg02
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err('upd srg11',SQLCA.sqlcode,1)
                     LET g_success='N'
                  END IF
                  LET l_sfv03=l_sfv03+1
               END IF
            END IF
         END FOREACH
         #拆件
         DECLARE t300_w32_cur CURSOR FOR SELECT srg_file.* FROM srg_file,sfb_file
           WHERE srg01=g_srf.srf01
             AND ((srg15='N' AND srg05>0 AND (srg11 IS NULL OR srg11=' ')) 
                  OR (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NULL))
             AND sfb01=srg16
             AND sfb02='11'
         FOREACH t300_w32_cur INTO l_srg.*
            IF g_success='N' THEN
               EXIT FOREACH
            END IF
            IF (l_srg.srg15='N') AND cl_null(l_srg.srg11) THEN
               CALL t300_w31(l_srg.*,l_sfv03,l_srg.srg05)
               UPDATE srg_file set srg11=tm.slip2
                WHERE srg01=l_srg.srg01
                  AND srg02=l_srg.srg02
               IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                  CALL cl_err('upd srg11',SQLCA.sqlcode,1)
                  LET g_success='N'
               END IF
               LET l_sfv03=l_sfv03+1
            END IF
            IF (l_srg.srg15='Y') AND (NOT cl_null(l_srg.srg12)) AND 
                                          cl_null(l_srg.srg11) THEN
               LET l_cnt = 0   
               #ASF
               SELECT COUNT(*) INTO l_cnt FROM qcf_file  
                WHERE qcf01=l_srg.srg12
                  AND qcf14='Y'
                  AND (qcf09='1' OR qcf09='3')
               IF l_cnt>0 THEN 
                  LET l_qcs091=0
                  SELECT qcf091 INTO l_qcs091 FROM qcf_file 
                   WHERE qcf01=l_srg.srg12
                  CALL t300_w31(l_srg.*,l_sfv03,l_qcs091)
                  UPDATE srg_file set srg11=tm.slip2
                   WHERE srg01=l_srg.srg01
                     AND srg02=l_srg.srg02
                  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
                     CALL cl_err('upd srg11',SQLCA.sqlcode,1)
                     LET g_success='N'
                  END IF
                  LET l_sfv03=l_sfv03+1
               END IF
            END IF
         END FOREACH
       END IF
      END IF
      #FUN-BC0104--add-str----
      IF tm.choice3 = 'Y' AND g_success = 'Y' THEN 
      #TQC-C20248 ------------------------Begin--------------------------- 
      #  #TQC-C20240-modify---str--
      #  DECLARE t300_qc_cur CURSOR FOR SELECT srg03,srg16 FROM srg_file,srf_file
      #    WHERE srf01 = srg01 AND srfconf ='Y' AND srg01 = g_srf.srf01
      #  FOREACH t300_qc_cur INTO l_srg03,l_srg16m
      #     LET g_msg = "aqcp107 '2' '",tm.slip,"' '",tm.slip2,"' '",tm.dt2,"' '' '' '",l_srg16m,"' '",l_srg03,"' '' 'Y'"
      #     CALL cl_cmdrun(g_msg)
      #  END FOREACH
         DECLARE t300_qc_cur CURSOR FOR SELECT srg02,srg03,srg16 FROM srg_file,srf_file
           WHERE srf01 = srg01 AND srfconf ='Y' AND srg01 = g_srf.srf01
         FOREACH t300_qc_cur INTO l_srg02,l_srg03,l_srg16m
            LET l_msg = "@",g_srf.srf01,"$",l_srg02 
            LET g_msg = "aqcp107 '2' '",tm.slip,"' '",tm.slip2,"' '",tm.dt2,"' '' '' '",l_srg16m,"' '",l_srg03,"' '",l_msg,"', 'Y'"
            CALL cl_cmdrun_wait(g_msg)
         END FOREACH  
      #TQC-C20248 ------------------------End------------------------------
      #  #TQC-C20240-modify---end--
      END IF
    #TQC-C20428 ------Begin-------
    # #TQC-C20248 -----Begin------
    # IF g_success = 'Y' THEN
    #    CALL t300_show()
    # END IF
    # #TQC-C20248 -----End--------
    #TQC-C20428 ------End--------- 
      #FUN-BC0104--add-end----
      #NO.TQC-A30099--begin
      IF g_argv1='2' THEN
         CALL cl_set_comp_entry("qcf01,dt1,emp",FALSE) 
      END IF 
      #NO.TQC-A30099--end  
      CLOSE WINDOW t300_w1_w
      EXIT WHILE
   END WHILE
END FUNCTION
 
#TQC-B60090 -----------------Begin-------------------
FUNCTION t730_fqc_count()
   DEFINE   l_cnt1     LIKE type_file.num5
   DEFINE   l_qc_cnt   LIKE type_file.num5
   DEFINE   l_cnt2     LIKE type_file.num5
   DEFINE   l_cnt      LIKE type_file.num5
  #若已產生FQC/入庫單後再點選轉FQC/入庫單時應提示訊息且不開啟畫面 
   #應產生FQC的單身筆數 
   LET l_cnt1=0
   SELECT COUNT(*) INTO l_cnt1 FROM srg_file 
    WHERE srg01=g_srf.srf01 AND srg15 ='Y' 
   #已產生FQC的單身筆數 
   LET l_qc_cnt=0
   SELECT COUNT(*) INTO l_qc_cnt FROM srg_file  
    WHERE srg01 = g_srf.srf01
      AND srg15 ='Y' 
      AND srg12 IS NOT NULL 
   #2.檢查是否已產生入庫單 
   #應產生入庫單的單身筆數 
   LET l_cnt2=0
   SELECT COUNT(*) INTO l_cnt2 FROM srg_file 
    WHERE srg01=g_srf.srf01
   #已產生入庫單的單身筆數 
   LET l_cnt=0
   IF g_argv1='1' THEN #FUN-840148
     SELECT COUNT(*) INTO l_cnt FROM srg_file
      WHERE srg01=g_srf.srf01
        AND ((srg15='N' AND srg05>0 AND srg11 IS NOT NULL) 
         OR  (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NOT NULL))
   ELSE
     SELECT COUNT(*) INTO l_cnt FROM srg_file,sfb_file  #FUN-840148
      WHERE srg01=g_srf.srf01
        AND ((srg15='N' AND srg05>0 AND srg11 IS NOT NULL)
         OR  (srg15='Y' AND srg12 IS NOT NULL AND srg11 IS NOT NULL))
        AND sfb01=srg16  #FUN-840148
        AND sfb02<>'11'  #FUN-840148
   END IF
   IF cl_null(l_cnt1)   THEN LET l_cnt1=0   END IF
   IF cl_null(l_qc_cnt) THEN LET l_qc_cnt=0 END IF
   IF cl_null(l_cnt2)   THEN LET l_cnt2=0   END IF
   IF cl_null(l_cnt)    THEN LET l_cnt=0    END IF
   RETURN l_cnt1,l_qc_cnt,l_cnt2,l_cnt
END FUNCTION
#TQC-B60090 -----------------End---------------------
FUNCTION t300_w2(l_srg) #重複性生產報工產生FQC
DEFINE l_srg RECORD    LIKE srg_file.*,
       l_qcs RECORD    LIKE qcs_file.*,
       l_ima102        LIKE ima_file.ima102,
       l_ima100        LIKE ima_file.ima100,
       l_ima906        LIKE ima_file.ima906,
       l_ima907        LIKE ima_file.ima907,
       l_factor        LIKE ima_file.ima31_fac, #No.FUN-680130 DECIMAL(16,8) 
       l_flag          LIKE type_file.num5,     #No.FUN-680130 SMALLINT
       l_ima44         LIKE ima_file.ima44      #FUN-BB0085
 
   INITIALIZE l_qcs.* TO NULL
   SELECT ima102,ima100,ima906,ima907,ima44 INTO l_ima102,l_ima100,l_ima906,l_ima907,l_ima44       #FUN-BB0085 add ima44
                                         FROM ima_file
                                         WHERE ima01=l_srg.srg14
   LET l_qcs.qcs00='7'
   LET l_qcs.qcs01=g_srf.srf01
   LET l_qcs.qcs02=l_srg.srg02
   LET l_qcs.qcs021=l_srg.srg14
   LET l_qcs.qcs04=tm.dt1
   LET l_qcs.qcs041=TIME
   LET l_qcs.qcs05=1
   LET l_qcs.qcs13=tm.emp
   LET l_qcs.qcs14='N'
   LET l_qcs.qcs16='N'
   LET l_qcs.qcs17=l_ima102
   LET l_qcs.qcs21=l_ima100
   LET l_qcs.qcs22=l_srg.srg05
   LET l_qcs.qcs06=t300_defqty(1,0,l_qcs.*)
   LET l_qcs.qcs091=0
   LET l_qcs.qcsprno=0
   LET l_qcs.qcsacti='Y'
   LET l_qcs.qcsuser=g_user
   LET l_qcs.qcsgrup=g_grup
   LET l_qcs.qcsmodu=''
   LET l_qcs.qcsdate=g_today
   LET l_qcs.qcsplant = g_plant #FUN-980008 add
   LET l_qcs.qcslegal = g_legal #FUN-980008 add
   IF g_action_choice = "trans_spc" THEN 
      LET l_qcs.qcsspc = '1'
   ELSE
      LET l_qcs.qcsspc = '0'
   END IF
   CASE
      WHEN l_ima906="1"
            LET l_qcs.qcs30=l_srg.srg04
            LET l_qcs.qcs31=1
            LET l_qcs.qcs32=l_srg.srg05
            LET l_qcs.qcs33=''
            LET l_qcs.qcs34=''
            LET l_qcs.qcs35=''
      WHEN l_ima906 MATCHES '[2,3]'
            LET l_qcs.qcs30=l_srg.srg04
            LET l_qcs.qcs31=1
            LET l_qcs.qcs32=l_srg.srg05
            LET l_qcs.qcs33=l_ima907
            CALL s_umfchk(l_srg.srg14,l_ima907,l_srg.srg04) RETURNING l_flag,l_factor
            IF l_flag=1 THEN
               LET l_factor=1
            END IF
            LET l_qcs.qcs34=l_factor
            LET l_qcs.qcs35=0
   END CASE
   LET l_qcs.qcsoriu = g_user      #No.FUN-980030 10/01/04
   LET l_qcs.qcsorig = g_grup      #No.FUN-980030 10/01/04
   LEt l_qcs.qcs22 = s_digqty(l_qcs.qcs22,l_ima44)    #FUN-BB0085
   INSERT INTO qcs_file VALUES (l_qcs.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins qcs',STATUS,1)
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      IF g_action_choice <> "trans_spc" THEN 
         CALL t300_g_b(l_qcs.*)
      END IF
      UPDATE srg_file set srg12=g_srf.srf01
       WHERE srg01=l_srg.srg01 AND srg02=l_srg.srg02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd srg12',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
   END IF
END FUNCTION
 
FUNCTION t300_w4(l_srg) #工單生產報工產生FQC(aqct410)
DEFINE l_srg       RECORD LIKE srg_file.*,
       l_qcf       RECORD LIKE qcf_file.*,
       l_ima102    LIKE ima_file.ima102,
       l_ima100    LIKE ima_file.ima100,
       l_ima906    LIKE ima_file.ima906,
       l_ima907    LIKE ima_file.ima907,
       l_factor    LIKE ima_file.ima31_fac, #No.FUN-680130 DECIMAL(16,8) 
       l_flag      LIKE type_file.num5,     #No.FUN-680130 SMALLINT
       l_ima55     LIKE ima_file.ima55      #FUN-BB0085
DEFINE l_srg05     LIKE srg_file.srg05      #CHI-C30044
DEFINE l_sfb08     LIKE sfb_file.sfb08      #CHI-C30044
DEFINE l_qcf22     LIKE qcf_file.qcf22      #CHI-C30044
DEFINE l_ima153    LIKE ima_file.ima153     #MOD-D20111
DEFINE l_cnt       LIKE type_file.num5      #MOD-D20111

    INITIALIZE l_qcf.* TO NULL
    SELECT ima102,ima100,ima906,ima907,ima55 INTO l_ima102,l_ima100,l_ima906,l_ima907,l_ima55     #FUN-BB0085 add ima55
      FROM ima_file
     WHERE ima01=l_srg.srg14

   #CHI-C30044---begin
   SELECT SUM(qcf22) INTO l_qcf22 FROM qcf_file WHERE qcf02 = l_srg.srg16 AND qcf14 <> 'X'
  #SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01 = l_srg.srg16         #MOD-D20111  mark
   CALL s_get_ima153(l_srg.srg03) RETURNING l_ima153                         #MOD-D20111
   CALL s_minp(l_srg.srg16,g_sma.sma73,l_ima153,'','','','')                 #MOD-D20111
                   RETURNING l_cnt,l_sfb08                                   #MOD-D20111
   LET l_srg05 = l_srg.srg05
   IF cl_null(l_srg05) THEN
      LET l_srg05 = 0
   END IF 
   IF cl_null(l_qcf22) THEN
      LET l_qcf22 = 0
   END IF 
   IF cl_null(l_sfb08) THEN
      LET l_sfb08 = 0
   END IF 
   IF l_srg05 + l_qcf22 > l_sfb08 THEN
      LET l_srg05 = l_sfb08 - l_qcf22
   END IF 
   #CHI-C30044---end
     
    LET l_qcf.qcf22=0
    LET l_qcf.qcf06=0
    LET l_qcf.qcf00='1'
    LET l_qcf.qcfuser=g_user
    LET l_qcf.qcfgrup=g_grup
    LET l_qcf.qcfdate=g_today
    LET l_qcf.qcfacti='Y'         #資料有效
    LET l_qcf.qcf041=TIME         #資料有效
    LET l_qcf.qcf04=g_today       #資料有效
    LET l_qcf.qcf05=1                 
    LET l_qcf.qcf14='N'
    LET l_qcf.qcf15=''
    LET l_qcf.qcf09='1'           #MOD-A40057 add #1.合格
    LET l_qcf.qcf091=0
    LET l_qcf.qcf13=g_user
    LET l_qcf.qcf18 = '1'
    LET l_qcf.qcf03 = ' '
 
    LET l_qcf.qcfplant = g_plant #FUN-980008 add
    LET l_qcf.qcflegal = g_legal #FUN-980008 add
 
    LET l_qcf.qcf01=tm.qcf01
    LET l_qcf.qcf02=l_srg.srg16
    LET l_qcf.qcf05=1
    LET l_qcf.qcf021=l_srg.srg03
    LET l_qcf.qcf21=l_ima100
    LET l_qcf.qcf17=l_ima102
    #LET l_qcf.qcf22=l_srg.srg05  #CHI-C30044
    LET l_qcf.qcf22=l_srg05       #CHI-C30044
    LET l_qcf.qcf06=t300_t410_defqty(1,0,l_qcf.*)
    IF g_action_choice = "trans_spc" THEN 
       LET l_qcf.qcfspc = '1'
    ELSE
       LET l_qcf.qcfspc = '0'
    END IF
    
   CASE
      WHEN l_ima906="1"
            LET l_qcf.qcf091= l_qcf.qcf22   #MOD-A40057 add
            LET l_qcf.qcf30=l_srg.srg04
            LET l_qcf.qcf31=1
            #LET l_qcf.qcf32=l_srg.srg05  #CHI-C30044
            LET l_qcf.qcf32=l_srg05       #CHI-C30044
            LET l_qcf.qcf33=''
            LET l_qcf.qcf34=''
            LET l_qcf.qcf35=''
      WHEN l_ima906 MATCHES '[2,3]'
            LET l_qcf.qcf30=l_srg.srg04
            LET l_qcf.qcf31=1
            #LET l_qcf.qcf32=l_srg.srg05  #CHI-C30044
            LET l_qcf.qcf32=l_srg05       #CHI-C30044
            LET l_qcf.qcf33=l_ima907
            CALL s_umfchk(l_srg.srg14,l_ima907,l_srg.srg04) RETURNING l_flag,l_factor
            IF l_flag=1 THEN
              LET l_factor=1
            END IF
            LET l_qcf.qcf34=l_factor
            LET l_qcf.qcf091= l_qcf.qcf22
            LET l_qcf.qcf35 = l_qcf.qcf22 / l_factor
            LET l_qcf.qcf36 = l_qcf.qcf30
            LET l_qcf.qcf37 = l_qcf.qcf31
            LET l_qcf.qcf38 = l_qcf.qcf22 / l_qcf.qcf37
            LET l_qcf.qcf39 = l_qcf.qcf33
            LET l_qcf.qcf40 = l_qcf.qcf34
            LET l_qcf.qcf41 = l_qcf.qcf35
   END CASE 
   LET l_qcf.qcforiu = g_user      #No.FUN-980030 10/01/04
   LET l_qcf.qcforig = g_grup      #No.FUN-980030 10/01/04
   #FUN-BB0085-add-str--
   LET l_qcf.qcf06 = s_digqty(l_qcf.qcf06,l_ima55)
   LET l_qcf.qcf091= s_digqty(l_qcf.qcf091,l_ima55)
   LET l_qcf.qcf22 = s_digqty(l_qcf.qcf22,l_ima55)
   LET l_qcf.qcf32 = s_digqty(l_qcf.qcf32,l_qcf.qcf30)
   LET l_qcf.qcf35 = s_digqty(l_qcf.qcf35,l_qcf.qcf33)
   LET l_qcf.qcf38 = s_digqty(l_qcf.qcf38,l_qcf.qcf36)
   LET l_qcf.qcf41 = s_digqty(l_qcf.qcf41,l_qcf.qcf39) 
   #FUN-BB0085-add-end--
   INSERT INTO qcf_file VALUES (l_qcf.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins qcf',STATUS,1)
      LET g_success='N'
   END IF
   IF g_success='Y' THEN
      IF g_action_choice <> "trans_spc" THEN 
         CALL t300_t410_g_b(l_qcf.*)
      END IF
      UPDATE srg_file set srg12=l_qcf.qcf01
                              WHERE srg01=l_srg.srg01
                                AND srg02=l_srg.srg02
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err('upd srg12',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
   END IF  
END FUNCTION
 
FUNCTION t300_defqty(l_def,l_rate,l_qcs)
   DEFINE l_def     LIKE type_file.num5,    #1:單頭入 2.單身入 #No.FUN-680130 SMALLINT   
          l_rate    LIKE qcd_file.qcd04
   DEFINE l_qcs     RECORD LIKE qcs_file.*,
          l_qcb04   LIKE qcb_file.qcb04
   DEFINE l_pmh09   LIKE pmh_file.pmh09,
          l_pmh15   LIKE pmh_file.pmh15,
          l_pmh16   LIKE pmh_file.pmh16,
          l_qca03   LIKE qca_file.qca03,
          l_qca04   LIKE qca_file.qca04,
          l_qca05   LIKE qca_file.qca05,
          l_qca06   LIKE qca_file.qca06
 
   SELECT ima100,ima101,ima102
     INTO l_pmh09,l_pmh15,l_pmh16
     FROM ima_file
    WHERE ima01 = l_qcs.qcs021
   IF STATUS THEN
      LET l_pmh09=''
      LET l_pmh15=''
      LET l_pmh16=''
      RETURN 0
   END IF
 
   IF l_pmh09 IS NULL OR l_pmh09=' ' THEN RETURN 0 END IF
   IF l_pmh15 IS NULL OR l_pmh15=' ' THEN RETURN 0 END IF
   IF l_pmh16 IS NULL OR l_pmh16=' ' THEN RETURN 0 END IF
 
   IF l_pmh15='1' THEN
      IF l_def=1 THEN
         SELECT qca03,qca04,qca05,qca06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qca_file
          WHERE l_qcf.qcf22 BETWEEN qca01 AND qca02        #bugno:7196 #MOD-860102 modify l_qcf22
            AND qca07 = l_qcs.qcs17
 
         IF STATUS AND l_qcs.qcs22 !=1 THEN
            RETURN 0
         END IF
 
      ELSE #單身入
         SELECT qcb04
           INTO l_qcb04
           FROM qca_file,qcb_file
          WHERE (l_qcf.qcf22 BETWEEN qca01 AND qca02)       #bugno:7196  #MOD-860102 modify l_qcf22
            AND qcb02 = l_rate
            AND qca03 = qcb03
            AND qca07 = l_qcs.qcs17
            AND qcb01 = l_qcs.qcs21
         IF NOT cl_null(l_qcb04) THEN
            SELECT UNIQUE qca03,qca04,qca05,qca06  #MOD-860102 add UNIQUE 
              INTO l_qca03,l_qca04,l_qca05,l_qca06
              FROM qca_file
             WHERE qca03 = l_qcb04
               AND qca07 = l_qcs.qcs17
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
         END IF
      END IF
   END IF
 
   IF l_pmh15 = '2' THEN
      IF l_def = 1 THEN
         SELECT qch03,qch04,qch05,qch06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qch_file
          WHERE l_qcf.qcf22 BETWEEN qch01 AND qch02       #bugno:7196  #MOD-860102 modify l_qcf22
            AND qch07 = l_qcs.qcs17
 
         IF STATUS AND l_qcs.qcs22 != 1 THEN
            RETURN 0
         END IF
 
      ELSE #單身入
         SELECT qcb04 INTO l_qcb04
           FROM qch_file,qcb_file
          WHERE (l_qcf.qcf22 BETWEEN qch01 AND qch02)       #bugno:7196  #MOD-860102 modify l_qcf22
            AND qcb02 = l_rate
            AND qch03 = qcb03
            AND qch07 = l_qcs.qcs17
            AND qcb01 = l_qcs.qcs21
         IF NOT cl_null(l_qcb04) THEN
            SELECT UNIQUE qch03,qch04,qch05,qch06        #MOD-860102 add UNIQUE
              INTO l_qca03,l_qca04,l_qca05,l_qca06
              FROM qch_file
             WHERE qch03 = l_qcb04
               AND qch07 = l_qcs.qcs17
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
         END IF
      END IF
   END IF
 
 
   IF l_qcs.qcs22 = 1 THEN
      LET l_qca04 = 1
      LET l_qca05 = 1
      LET l_qca06 = 1
   END IF
 
 
   CASE l_pmh09
      WHEN 'N'
         RETURN l_qca04
      WHEN 'T'
         RETURN l_qca05
      WHEN 'R'
         RETURN l_qca06
      OTHERWISE
         RETURN 0
   END CASE
 
END FUNCTION
 
FUNCTION t300_g_b(l_qcs)
   DEFINE l_qcs     RECORD LIKE qcs_file.*
   DEFINE l_cnt     LIKE type_file.num5    #No.FUN-680130 SMALLINT
   DEFINE l_yn      LIKE type_file.num5    #No.FUN-680130 SMALLINT
   DEFINE l_qcd     RECORD LIKE qcd_file.*
   DEFINE seq       LIKE type_file.num5    #No.FUN-680130 SMALLINT
   DEFINE l_flag    LIKE type_file.chr1    #No.FUN-680130 VARCHAR(01)
   DEFINE l_ecm04   LIKE ecm_file.ecm04    #No.FUN-680130 VARCHAR(06)
   DEFINE l_ac_num,l_re_num  LIKE type_file.num5    #No.FUN-680130 SMALLINT
   DEFINE l_qct11   LIKE qct_file.qct11
 
   LET seq = 1
 
   SELECT COUNT(*) INTO l_cnt FROM qct_file
    WHERE qct01 = l_qcs.qcs01
      AND qct02 = l_qcs.qcs02
      AND qct021 = l_qcs.qcs05
 
   SELECT COUNT(*) INTO l_yn FROM qcd_file
    WHERE qcd01 = l_qcs.qcs021
      AND qcd08 IN ('2','9')             #No.FUN-910079
   IF l_yn > 0 THEN          #--- 料件檢驗項目
      LET l_flag = '2'
   ELSE
      LET l_flag = '3'       #--- 材料類別檢驗項目
   END IF
 
   CASE l_flag
 
      WHEN '2'
         DECLARE qcd_cur CURSOR FOR SELECT * FROM qcd_file
                                     WHERE qcd01 = l_qcs.qcs021
                                       AND qcd08 IN ('2','9')             #No.FUN-910079
                                     ORDER BY qcd02
         FOREACH qcd_cur INTO l_qcd.*
            IF l_qcd.qcd05 = '1' THEN
               #-------- Ac,Re 數量賦予
               CALL s_newaql(l_qcs.qcs021,'',l_qcd.qcd04,l_qcs.qcs22,' ','1')  #TQC-890055 add ' ','1'
                   RETURNING l_ac_num,l_re_num
               CALL t300_defqty(2,l_qcd.qcd04,l_qcs.*) RETURNING l_qct11
            ELSE
               LET l_ac_num = 0
               LET l_re_num = 1
               SELECT qcj05 INTO l_qct11
                 FROM qcj_file
                WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)
                  AND qcj03 = l_qcd.qcd04
                  AND qcj04 = l_qcd.qcd03   #MOD-CA0187 add
               IF STATUS THEN
                  LET l_qct11 = 0
               END IF
            END IF
 
            IF l_qct11 > l_qcs.qcs22 THEN
               LET l_qct11 = l_qcs.qcs22
            END IF
 
            IF cl_null(l_qct11) THEN
               LET l_qct11 = 0
            END IF
 
            INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,
                                  qct06,qct07,qct08,qct09,qct10,qct11,
                                  qct12,qct131,qct132,
                                  qctplant,qctlegal) #FUN-980008 add
                           VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,
                                  l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                                  0,'1',l_ac_num,l_re_num,l_qct11,
                                  l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,
                                  g_plant,g_legal)   #FUN-980008 add
            LET seq = seq + 1
         END FOREACH
      WHEN '3'      #--- 材料類別檢驗項目
         DECLARE qck_cur CURSOR FOR SELECT qck_file.*
                                      FROM qck_file,ima_file
                                     WHERE qck01 = ima109
                                       AND ima01 = l_qcs.qcs021
                                       AND qck08 IN ('2','9')             #No.FUN-910079
                                     ORDER BY qck02
         FOREACH qck_cur INTO l_qcd.*
            IF l_qcd.qcd05 = '1' THEN
               #-------- Ac,Re 數量賦予
               CALL s_newaql(l_qcs.qcs021,'',l_qcd.qcd04,l_qcs.qcs22,' ','1')  #TQC-890055 add ' ','1'
                   RETURNING l_ac_num,l_re_num
               CALL t300_defqty(2,l_qcd.qcd04,l_qcs.*) RETURNING l_qct11
            ELSE
               LET l_ac_num=0 LET l_re_num=1
               SELECT qcj05 INTO l_qct11
                 FROM qcj_file
                WHERE (l_qcs.qcs22 BETWEEN qcj01 AND qcj02)
                  AND qcj03=l_qcd.qcd04
                  AND qcj04=l_qcd.qcd03   #MOD-CA0187 add
               IF STATUS THEN LET l_qct11=0 END IF
            END IF
            IF l_qct11 > l_qcs.qcs22 THEN LET l_qct11=l_qcs.qcs22 END IF
            IF cl_null(l_qct11) THEN LET l_qct11=0 END IF
            INSERT INTO qct_file (qct01,qct02,qct021,qct03,qct04,qct05,
                                  qct06,qct07,qct08,qct09,qct10,qct11,
                                  qct12,qct131,qct132,
                                  qctplant,qctlegal) #FUN-980008 add
                           VALUES(l_qcs.qcs01,l_qcs.qcs02,l_qcs.qcs05,seq,
                                  l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                                  0,'1',l_ac_num,l_re_num,l_qct11,
                                  l_qcd.qcd05,l_qcd.qcd061,l_qcd.qcd062,
                                  g_plant,g_legal) #FUN-980008 add
            LET seq=seq+1
         END FOREACH
   END CASE
 
END FUNCTION
 
FUNCTION t300_w3(l_srg,l_sfv03,l_sfv09)
DEFINE l_srg RECORD    LIKE srg_file.*,
       l_sfv RECORD    LIKE sfv_file.*,
       l_sfv03         LIKE sfv_file.sfv03,
       l_sfv09         LIKE sfv_file.sfv09,
       l_ima906        LIKE ima_file.ima906,
       l_ima907        LIKE ima_file.ima907,
       l_factor        LIKE ima_file.ima31_fac,  #No.FUN-680130 DECIMAL(16,8) 
       l_msg           STRING,                   #No:CHI-980043 add
       l_chr           STRING,                   #No:CHI-980043 add
       l_flag          LIKE type_file.num5       #No.FUN-680130 SMALLINT
DEFINE l_sfvi   RECORD LIKE sfvi_file.*          #FUN-B70074
DEFINE l_sfb30      LIKE sfb_file.sfb30          #CHI-C30124 add工單預計完工入庫倉庫
DEFINE l_sfb31      LIKE sfb_file.sfb31          #CHI-C30124 add工單預計完工入庫儲位
DEFINE l_sfu04      LIKE sfu_file.sfu04          #FUN-CB0087 add
DEFINE l_sfu16      LIKE sfu_file.sfu16          #FUN-CB0087 add
 
   LET l_sfv.sfv01=tm.slip
   LET l_sfv.sfv03=l_sfv03
   LET l_sfv.sfv04=l_srg.srg14
   IF NOT cl_null(tm.wh1) THEN  #CHI-C30124 add
     LET l_sfv.sfv05=tm.wh1
     LET l_sfv.sfv06=tm.wh2
  #CHI-C30124 str add-----
   ELSE
     SELECT sfb30,sfb31 INTO l_sfb30,l_sfb31 FROM sfb_file
      WHERE sfb01 = l_srg.srg16
     IF NOT cl_null(l_sfb30) THEN
        LET  l_sfv.sfv05= l_sfb30

        IF NOT cl_null(l_sfb31) THEN
           LET  l_sfv.sfv06= l_sfb31
        END IF
     ELSE
       SELECT ima35,ima36 INTO l_sfv.sfv05,l_sfv.sfv06 FROM ima_file
        WHERE ima01=l_srg.srg03
     END IF
   END IF
  #CHI-C30124 end add-----
   LET l_sfv.sfv07=tm.wh3
#TQC-C20465 ------Begin-------
   IF cl_null(l_sfv.sfv05) THEN LET l_sfv.sfv05 = ' ' END IF
   IF cl_null(l_sfv.sfv06) THEN LET l_sfv.sfv06 = ' ' END IF
   IF cl_null(l_sfv.sfv07) THEN LET l_sfv.sfv07 = ' ' END IF
#TQC-C20465 ------End---------
   LET l_sfv.sfv08=l_srg.srg04
   LET l_sfv.sfv09=l_sfv09
   LET l_sfv.sfv09=s_digqty(l_sfv.sfv09,l_sfv.sfv08)   #No.FUN-BB0086
   LET l_sfv.sfv930=l_srg.srg930 #FUN-670103
   LET l_sfv.sfvplant = g_plant #FUN-980008 add
   LET l_sfv.sfvlegal = g_legal #FUN-980008 add
  #--------------------No:CHI-980043 add
   LET l_flag = 0
   SELECT COUNT(*) INTO l_flag FROM img_file
    WHERE img01=l_sfv.sfv04 AND img02=l_sfv.sfv05
      AND img03=l_sfv.sfv06 AND img04=l_sfv.sfv07
   IF cl_null(l_flag) OR l_flag = 0 THEN
      IF g_sma.sma892[3,3] = 'Y' THEN
         LET l_chr = cl_getmsg('abx-011',g_lang)
         LET l_msg = l_chr CLIPPED,l_sfv.sfv04 ,"+"
         LET l_chr = cl_getmsg('apm-335',g_lang)
         LET l_msg = l_msg CLIPPED,l_chr CLIPPED,l_sfv.sfv05 
         LET l_chr = cl_getmsg('mfg1401',g_lang)
         LET l_msg = l_msg CLIPPED,",",l_chr CLIPPED
         IF NOT cl_confirm(l_msg) THEN 
            LET l_flag = 1
         END IF
      END IF
      IF l_flag = 0 THEN
         CALL s_add_img(l_sfv.sfv04,l_sfv.sfv05,
                        l_sfv.sfv06,l_sfv.sfv07,
                        l_sfv.sfv01,l_sfv.sfv03,
                        g_today) 
      END IF
   END IF
  #--------------------No:CHI-980043 end
   CASE g_argv1
      WHEN "1" #ASR
         LET l_sfv.sfv11=l_srg.srg03  #(重覆性生產 此欄是 生產料號)
         LET l_sfv.sfv14=l_srg.srg02  #(重覆性生產 此欄是 報工單項次)
         LET l_sfv.sfv16=l_srg.srg13  #(重覆性生產 此欄是 1.主/2.聯/3.副/4.再生產品)
         LET l_sfv.sfv17=g_srf.srf01  #(重覆性生產 此欄是 報工單單號)
      WHEN "2" #ASF
         IF l_srg.srg13='2' THEN #聯產品
            LET l_sfv.sfv16='Y'
         ELSE
            LET l_sfv.sfv16='N'
         END IF
         LET l_sfv.sfv11=l_srg.srg16  #(工單生產 此欄是 工單編號)
         LET l_sfv.sfv14=l_srg.srg02  #(工單生產 此欄是 報工單項次)
         LET l_sfv.sfv17=l_srg.srg12  #(工單生產 此欄是 FQC單號)
         LET l_sfv.sfv20=g_srf.srf01  #(工單生產 此欄是 Run Card/報工單單號)
   END CASE
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
                                     WHERE ima01=l_sfv.sfv04
   CASE
      WHEN l_ima906='1'
         LET l_sfv.sfv30=l_srg.srg04
         LET l_sfv.sfv31=1
         LET l_sfv.sfv32=l_srg.srg05
         LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)   #No.FUN-BB0086
         LET l_sfv.sfv33=''
         LET l_sfv.sfv34=''
         LET l_sfv.sfv35=''
      WHEN l_ima906 MATCHES '[2,3]'
         LET l_sfv.sfv30=l_srg.srg04
         LET l_sfv.sfv31=1
         LET l_sfv.sfv32=l_srg.srg05
         LET l_sfv.sfv32 = s_digqty(l_sfv.sfv32,l_sfv.sfv30)   #No.FUN-BB0086
         LET l_sfv.sfv33=l_ima907
         CALL s_umfchk(l_sfv.sfv04,l_ima907,l_sfv.sfv08) RETURNING l_flag,l_factor
         IF l_flag=1 THEN
           LET l_factor=1
         END IF
         LET l_sfv.sfv34=l_factor
         LET l_sfv.sfv35=0
        #---------------------------No:CHI-980043 add
         #判斷子單位是否存在imgg_file
         IF l_ima906 = '2' THEN 
            LET l_flag = 0
            CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                            l_sfv.sfv06,l_sfv.sfv07,
                            l_sfv.sfv30) RETURNING l_flag
            IF l_flag = 1 THEN
               LET l_chr = cl_getmsg('abx-011',g_lang)
               LET l_msg = l_chr CLIPPED,l_sfv.sfv04 ,"+"
               LET l_chr = cl_getmsg('ams-825',g_lang)
               LET l_msg = l_msg CLIPPED,l_chr CLIPPED,l_sfv.sfv30 
               LET l_chr = cl_getmsg('aim-995',g_lang)
               LET l_msg = l_msg CLIPPED,",",l_chr CLIPPED
               IF g_sma.sma892[3,3] = 'Y' THEN
                  IF NOT cl_confirm(l_msg) THEN LET l_flag = 0 END IF
               END IF
               IF l_flag = 1 THEN
                  CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                                  l_sfv.sfv06,l_sfv.sfv07,
                                  l_sfv.sfv30,l_sfv.sfv31,
                                  l_sfv.sfv01,
                                  l_sfv.sfv03,0) RETURNING l_flag
               END IF
            END IF
         END IF

         #判斷子單位是否存在imgg_file
         LET l_flag = 0
         CALL s_chk_imgg(l_sfv.sfv04,l_sfv.sfv05,
                         l_sfv.sfv06,l_sfv.sfv07,
                         l_sfv.sfv33) RETURNING l_flag
         IF l_flag = 1 THEN
            IF g_sma.sma892[3,3] = 'Y' THEN
               LET l_chr = cl_getmsg('abx-011',g_lang)
               LET l_msg = l_chr CLIPPED,l_sfv.sfv04 ,"+"
               LET l_chr = cl_getmsg('ams-825',g_lang)
               LET l_msg = l_msg CLIPPED,l_chr CLIPPED,l_sfv.sfv33 
               LET l_chr = cl_getmsg('aim-995',g_lang)
               LET l_msg = l_msg CLIPPED,",",l_chr CLIPPED
               IF NOT cl_confirm(l_msg) THEN LET l_flag = 0 END IF
            END IF
            IF l_flag = 1 THEN
               CALL s_add_imgg(l_sfv.sfv04,l_sfv.sfv05,
                               l_sfv.sfv06,l_sfv.sfv07,
                               l_sfv.sfv33,l_sfv.sfv34,
                               l_sfv.sfv01,
                               l_sfv.sfv03,0) RETURNING l_flag
            END IF
         END IF
        #---------------------------No:CHI-980043 end
   END CASE
   #FUN-CB0087---add---str---
   IF g_aza.aza115 = 'Y' THEN
      SELECT sfu04,sfu16 INTO l_sfu04,l_sfu16 FROM sfu_file WHERE sfu01 = l_sfv.sfv01
      CALL s_reason_code(l_sfv.sfv01,l_sfv.sfv11,'',l_sfv.sfv04,l_sfv.sfv05,l_sfu16,l_sfu04) RETURNING l_sfv.sfv44
      IF cl_null(l_sfv.sfv44) THEN
         CALL cl_err('','aim-425',1)
         LET g_success='N'
      END IF
   END IF
   #FUN-CB0087---add---end--
   INSERT INTO sfv_file VALUES (l_sfv.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins sfv',SQLCA.sqlcode,1)
      LET g_success='N'
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfvi.* TO NULL
         LET l_sfvi.sfvi01 = l_sfv.sfv01
         LET l_sfvi.sfvi03 = l_sfv.sfv03
         IF NOT s_ins_sfvi(l_sfvi.*,l_sfv.sfvplant) THEN
            LET g_success = 'N'  
         END IF
      END IF 
#FUN-B70074--add--insert--
   END IF
END FUNCTION
 
FUNCTION t300_w31(l_srg,l_ksd03,l_ksd09)
DEFINE l_srg RECORD    LIKE srg_file.*,
       l_ksd RECORD    LIKE ksd_file.*,
       l_ksd03         LIKE ksd_file.ksd03,
       l_ksd09         LIKE ksd_file.ksd09,
       l_ima906        LIKE ima_file.ima906,
       l_ima907        LIKE ima_file.ima907,
       l_factor        LIKE ima_file.ima31_fac,  #No.FUN-680130 DECIMAL(16,8) 
       l_flag          LIKE type_file.num5       #No.FUN-680130 SMALLINT
 
   LET l_ksd.ksd01=tm.slip2
   LET l_ksd.ksd03=l_ksd03
   LET l_ksd.ksd04=l_srg.srg14
   LET l_ksd.ksd05=tm.wh1
   LET l_ksd.ksd06=tm.wh2
   LET l_ksd.ksd07=tm.wh3
   LET l_ksd.ksd08=l_srg.srg04
   LET l_ksd.ksd09=l_ksd09
   LET l_ksd.ksd09 = s_digqty(l_ksd.ksd09,l_ksd.ksd08)   #FUN-910088--add--
   LET l_ksd.ksd930=l_srg.srg930 #FUN-670103
   LET l_ksd.ksdplant = g_plant #FUN-980008 add
   LET l_ksd.ksdlegal = g_legal #FUN-980008 add
   IF l_srg.srg13='2' THEN #聯產品
      LET l_ksd.ksd16='Y'
   ELSE
      LET l_ksd.ksd16='N'
   END IF
   LET l_ksd.ksd11=l_srg.srg16  #(工單生產 此欄是 工單編號)
   LET l_ksd.ksd14=l_srg.srg02  #(工單生產 此欄是 報工單項次)
   LET l_ksd.ksd17=l_srg.srg12  #(工單生產 此欄是 FQC單號)
   LET l_ksd.ksd20=g_srf.srf01  #(工單生產 此欄是 Run Card/報工單單號)
   SELECT ima906,ima907 INTO l_ima906,l_ima907 FROM ima_file
                                     WHERE ima01=l_ksd.ksd04
   CASE
      WHEN l_ima906='1'
         LET l_ksd.ksd30=l_srg.srg04
         LET l_ksd.ksd31=1
         LET l_ksd.ksd32=l_srg.srg05
         LET l_ksd.ksd33=''
         LET l_ksd.ksd34=''
         LET l_ksd.ksd35=''
      WHEN l_ima906 MATCHES '[2,3]'
         LET l_ksd.ksd30=l_srg.srg04
         LET l_ksd.ksd31=1
         LET l_ksd.ksd32=l_srg.srg05
         LET l_ksd.ksd33=l_ima907
         CALL s_umfchk(l_ksd.ksd04,l_ima907,l_ksd.ksd08) RETURNING l_flag,l_factor
         IF l_flag=1 THEN
           LET l_factor=1
         END IF
         LET l_ksd.ksd34=l_factor
         LET l_ksd.ksd35=0
   END CASE
 
   INSERT INTO ksd_file VALUES (l_ksd.*)
   IF SQLCA.sqlcode THEN
      CALL cl_err('ins ksd',SQLCA.sqlcode,1)
      LET g_success='N'
   END IF
END FUNCTION
 
FUNCTION t300_v()
DEFINE li_result  LIKE type_file.num5,   #No.FUN-680130 SMALLINT 
       l_cnt LIKE type_file.num10,       #No.FUN-680130 INTEGER 
       l_srg RECORD LIKE srg_file.*,
       l_sfp RECORD LIKE sfp_file.*,
       l_sfs RECORD LIKE sfs_file.*,
       l_sfsi RECORD LIKE sfsi_file.*,   #FUN-B70074 
       l_ima136 LIKE ima_file.ima136,
       l_ima137 LIKE ima_file.ima137,
       l_ima63  LIKE ima_file.ima63,
       l_ima906 LIKE ima_file.ima906,
       l_ima907 LIKE ima_file.ima907,
       l_ima908 LIKE ima_file.ima908,
       l_factor LIKE ima_file.ima31_fac, #No.FUN-680130 DECIMAL(16,8) 
       l_ima55    LIKE ima_file.ima55,
       l_sql STRING,
       l_eca03  LIKE eca_file.eca03      #FUN-670103
DEFINE l_bmb RECORD
                bmb03   LIKE bmb_file.bmb03,
                bmb06   LIKE bmb_file.bmb06,
                bmb07   LIKE bmb_file.bmb07,
                bmb08   LIKE bmb_file.bmb08,
                bmb10   LIKE bmb_file.bmb10,
                bmb16   LIKE bmb_file.bmb16
             END RECORD
DEFINE l_slip      LIKE smy_file.smyslip  #No.TQC-AB0307
DEFINE l_smy72     LIKE smy_file.smy72    #No.TQC-AB0307
 
   SELECT * INTO g_srf.* FROM srf_file WHERE srf01 = g_srf.srf01
   IF NOT cl_null(g_srf.srf06) THEN RETURN END IF
   IF g_srf.srfconf<>'Y' THEN CALL cl_err(' ','9029',0) RETURN END IF
 
   INPUT g_srf.srf06 WITHOUT DEFAULTS FROM srf06
      AFTER FIELD srf06
        IF NOT cl_null(g_srf.srf06) THEN
           CALL s_check_no("asf",g_srf.srf06,"","3","srf_file","srf06","")
              RETURNING li_result,g_srf.srf06
           DISPLAY BY NAME g_srf.srf06
           IF (NOT li_result) THEN
              NEXT FIELD srf06
           END IF
           #TQC-AB0307--begin--add------
           CALL s_get_doc_no(g_srf.srf06) RETURNING l_slip
           SELECT smy72 INTO l_smy72 FROM smy_file
            WHERE smyslip=l_slip
           IF cl_null(l_smy72) THEN LET l_smy72 = ' ' END IF
           IF l_smy72 <> '4' THEN 
              CALL cl_err('','asm-145',1) NEXT FIELD srf06 
           END IF
           #TQC-AB0307--end--add-----
           CALL s_auto_assign_no("asf",g_srf.srf06,g_srf.srf02,"","sfp_file","sfp01","","","")
                RETURNING li_result,g_srf.srf06
           IF (NOT li_result) THEN
              NEXT FIELD srf06
           END IF
           DISPLAY BY NAME g_srf.srf06
        END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(srf06)
               LET g_t1 = s_get_doc_no(g_srf.srf06)
               LET g_sql= " (smy73 <> 'Y' OR smy73 is null) AND smy72='4' " #TQC-AB0307
               CALL smy_qry_set_par_where(g_sql)   #TQC-AB0307
               CALL q_smy(FALSE,TRUE,g_t1,'ASF','3') RETURNING g_t1  #TQC-670008
               LET g_srf.srf06=g_t1
               DISPLAY BY NAME g_srf.srf06
               NEXT FIELD srf06
            OTHERWISE EXIT CASE
         END CASE
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
 
    #TQC-AB0307--begin--add---
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_srf.srf06=''
       DISPLAY BY NAME g_srf.srf06
       RETURN
    END IF
    #TQC-AB0307--end--add
   IF cl_null(g_srf.srf06) THEN   #未輸入任何data
      RETURN
   END IF
   IF NOT cl_sure(0,0) THEN
      RETURN
   END IF
 
   LET l_sfp.sfp01 = g_srf.srf06
   LET l_sfp.sfp02 = g_today
   LET l_sfp.sfp03 = g_today
   LET l_sfp.sfp04 = 'N'
   LET l_sfp.sfpconf = 'N' #FUN-660106
   LET l_sfp.sfp05 = 'N'
   LET l_sfp.sfp06 = 'C'
  ##FUN-AB0001--add---str--- 
   LET l_sfp.sfpmksg = g_smy.smyapr #是否簽核
   LET l_sfp.sfp15 = '0'            #簽核狀況 
   LET l_sfp.sfp16 = g_user         #申請人
  ##FUN-AB0001--add---end---
   LET l_sfp.sfpplant = g_plant #FUN-980008 add
   LET l_sfp.sfplegal = g_legal #FUN-980008 add
   SELECT eca03 INTO l_eca03 
     FROM eca_file,eci_file 
    WHERE eci01=g_srf.srf03
      AND eca01=eci03
   IF SQLCA.sqlcode THEN
      LET l_eca03=NULL
   END IF
   LET l_sfp.sfp07 = l_eca03
   LET g_success='Y'
   BEGIN WORK
   LET l_sfp.sfporiu = g_user      #No.FUN-980030 10/01/04
   LET l_sfp.sfporig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO sfp_file VALUES (l_sfp.*)
   IF SQLCA.sqlcode THEN
      LET g_success='N'
   #   ROLLBACK WORK          # FUN-B80063 下移四行
      CALL cl_err('',SQLCA.sqlcode,1)
      LET g_srf.srf06=''
      DISPLAY BY NAME g_srf.srf06
      ROLLBACK WORK          # FUN-B80063
      RETURN
   END IF
 
   LET l_cnt=0
   DECLARE t300_v_cur CURSOR FOR SELECT * FROM srg_file WHERE srg01=g_srf.srf01
   FOREACH t300_v_cur INTO l_srg.*
      IF SQLCA.sqlcode THEN
         LET g_success='N'
         CALL cl_err('',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
 
      LET l_sql = "SELECT bmb03,bmb06,bmb07,bmb08,bmb10,bmb16,",
                  "ima136,ima137,ima55,ima63,ima906,ima907,ima908",
                  " FROM bmb_file,ima_file",
                  " WHERE ima01=bmb03 AND bmb01='",l_srg.srg03,"'",
                  "   AND ima910=bmb29",
                  "   AND (bmb04 <='",g_srf.srf02,"' OR bmb04 IS NULL )",
                  "   AND (bmb05 > '",g_srf.srf02,"' OR bmb05 IS NULL )",
                  "   AND bmb15='Y'"
      PREPARE t300_v_cur1_pre FROM l_sql
      DECLARE t300_v_cur1 CURSOR FOR t300_v_cur1_pre
      FOREACH t300_v_cur1 INTO l_bmb.*,l_ima136,l_ima137,l_ima55,
                                       l_ima63,l_ima906,l_ima907,l_ima908
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         LET l_cnt = l_cnt+1
         LET l_sfs.sfs01 = l_sfp.sfp01
         LET l_sfs.sfs02 = l_cnt
         LET l_sfs.sfs03 = l_srg.srg03
         LET l_sfs.sfs04 = l_bmb.bmb03
         LET l_sfs.sfs05 = (l_srg.srg05+l_srg.srg06+l_srg.srg07)*
                           l_bmb.bmb06/l_bmb.bmb07  #已發料量
         IF g_sma.sma78='1' THEN #1:庫存單位 2:發料單位
            LET l_sfs.sfs06 = l_ima63      #發料單位
         ELSE
            LET l_sfs.sfs06 = l_bmb.bmb10  #發料單位
         END IF
         LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)    #FUN-BB0084
         LET l_sfs.sfs07 = l_ima136     #倉庫
         LET l_sfs.sfs08 = l_ima137     #儲位
         LET l_sfs.sfs09 = ' '          #批號
         LET l_sfs.sfs10 = ' '          #作業序號
         LET l_sfs.sfs26 = NULL         #替代碼
         LET l_sfs.sfs27 = l_sfs.sfs04  #被替代料號   #No.MOD-8B0086 add
         LET l_sfs.sfs28 = NULL         #替代率
         IF g_sma.sma115 = 'Y' THEN
            LET l_sfs.sfs30 = l_sfs.sfs06
            CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs06,l_ima55)
               RETURNING g_errno,l_factor
            LET l_sfs.sfs31 = l_factor
            LET l_sfs.sfs32 = l_sfs.sfs05 / l_factor
            LET l_sfs.sfs32 = s_digqty(l_sfs.sfs32,l_sfs.sfs30)    #FUN-BB0084
            IF l_ima906 = '1' THEN  #不使用雙單位
               LET l_sfs.sfs33 = NULL
               LET l_sfs.sfs34 = NULL
               LET l_sfs.sfs35 = NULL
            ELSE
               LET l_sfs.sfs33 = l_ima907
               CALL s_du_umfchk(l_sfs.sfs04,'','','',l_ima55,l_ima907,l_ima906)
                    RETURNING g_errno,l_factor
               LET l_sfs.sfs34 = l_factor
               LET l_sfs.sfs35 = 0
            END IF
         END IF
         LET l_sfs.sfs930=l_srg.srg930 #FUN-670103
         LET l_sfs.sfsplant = g_plant #FUN-980008 add
         LET l_sfs.sfslegal = g_legal #FUN-980008 add
         LET l_sfs.sfs012 = '' #FUN-A60027 add
         LET l_sfs.sfs013 = 0 #FUN-A60027 add
         LET l_sfs.sfs014 = ' ' #FUN-C70014 add

         #FUN-CB0087---add---str---
         IF g_aza.aza115 = 'Y' THEN
            CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,l_sfp.sfp16,l_sfp.sfp07) RETURNING l_sfs.sfs37
            IF cl_null(l_sfs.sfs37) THEN 
               CALL cl_err('','aim-425',1) 
               LET g_success = 'N'
            END IF
         END IF
         #FUN-CB0087---add---end--          
         INSERT INTO sfs_file VALUES (l_sfs.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
            CALL cl_err('',SQLCA.sqlcode,1)
    #FUN-B70074 ------------Begin-------------
         ELSE
            IF NOT s_industry('std') THEN
               INITIALIZE l_sfsi.* TO NULL
               LET l_sfsi.sfsi01 = l_sfs.sfs01
               LET l_sfsi.sfsi02 = l_sfs.sfs02
               IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
                  LET g_success='N'
               END IF
            END IF             
    #FUN-B70074 ------------End---------------
         END IF
      END FOREACH
   END FOREACH
 
   IF l_cnt=0 THEN #無產生任何單身資料
      CALL cl_err('','mfg3442',1)
      LET g_success='N'
   END IF
 
   IF g_success='Y' THEN
      UPDATE srf_file SET srf06=g_srf.srf06 WHERE srf01=g_srf.srf01
      IF SQLCA.sqlcode THEN
         CALL cl_err('',SQLCA.sqlcode,1)
         LET g_success='N'
      END IF
   END IF
 
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_err('','lib-284',1)
   ELSE
      ROLLBACK WORK
      LET g_srf.srf06=''
   END IF
   DISPLAY BY NAME g_srf.srf06
END FUNCTION
 
#FUNCTION t300_chk_sfb081(p_qty)                 #FUN-C90077 mark
FUNCTION t300_chk_sfb081(p_qty,p_srg16,p_flag)   #FUN-C90077 TQC-C90111 精簡程式
DEFINE l_tot,p_qty     LIKE srg_file.srg05,
       l_sfb081        LIKE sfb_file.sfb081,
       l_str           STRING,
       l_sfb39         LIKE sfb_file.sfb39,     #CHI-710057
       l_sfb           RECORD LIKE sfb_file.*,  #MOD-740195
       l_min_set       LIKE sfb_file.sfb08,     #MOD-740195
       l_cnt           LIKE type_file.num5      #MOD-740195
DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
DEFINE  l_min_set1   LIKE sfb_file.sfb08    #FUN-C90077
DEFINE  l_tot1       LIKE srg_file.srg05    #FUN-C90077 
DEFINE  p_flag       LIKE type_file.num5    #FUN-C90077
DEFINE  p_srg16      LIKE srg_file.srg16    #FUN-C90077 
DEFINE  l_sql        STRING     #FUN-C90077
DEFINE  l_sql2       STRING     #FUN-C90077
   
   IF p_flag THEN  #FUN-C90077
      IF cl_null(g_srg[l_ac].srg02) OR 
         cl_null(g_srg[l_ac].srg16) OR 
         (p_qty=0) THEN
         RETURN TRUE
      END IF   
   END IF    #FUN-C90077
   SELECT sfb39 INTO l_sfb39 FROM sfb_file
                      #     WHERE sfb01=g_srg[l_ac].srg16 #FUN-C90077 mark 
                            WHERE sfb01=p_srg16           #FUN-C90077
   IF l_sfb39='2' THEN #倒扣料不檢查數量
      RETURN TRUE
   END IF
#FUN-C90077 ------------------Mark-Begin-------------------
#  SELECT SUM(srg05+srg06+srg07) INTO l_tot FROM srf_file,srg_file
#                                WHERE srg01=srf01
#                                  AND srfconf<>'X'
#                           #      AND srf01<>g_srf.srf01                  #MOD-7B0141-mark
#                           #      AND srg02<>g_srg[l_ac].srg02            #MOD-7B0141-mark
#                                  AND NOT ( srf01 = g_srf.srf01 AND       #MOD-7B0141-modify
#                                            srg02 = g_srg[l_ac].srg02 )   #MOD-7B0141-modify
#                                  AND srg16=g_srg[l_ac].srg16
#FUN-C90077 ------------------Mark-End--------------------
#FUN-C90077 ------------------Begin-------------------
   LET l_sql = "SELECT SUM(srg05+srg06+srg07) FROM srf_file,srg_file ",
               " WHERE srg01 = srf01",
               "   AND srfconf<>'X'",
               "   AND srg16 ='",p_srg16,"'" 
   IF p_flag THEN
      LET l_sql = l_sql CLIPPED," AND NOT ( srf01 = '",g_srf.srf01,"'",
                                " AND srg02 = '",g_srg[l_ac].srg02,"'",")"
   END IF
   PREPARE t300_num_pre FROM l_sql
   EXECUTE t300_num_pre INTO l_tot1
   LET l_sql2 = l_sql CLIPPED," AND srf02 <= '",g_srf.srf02,"'"
   PREPARE t300_num_pre2 FROM l_sql2
   EXECUTE t300_num_pre2 INTO l_tot
#FUN-C90077 ------------------End---------------------
   IF SQLCA.sqlcode OR (cl_null(l_tot)) THEN
      LET l_tot=0
   END IF
#FUN-C90077 ------------------Begin-------------------
   IF SQLCA.sqlcode OR (cl_null(l_tot1)) THEN
      LET l_tot1=0
   END IF
#FUN-C90077 ------------------End---------------------
   LET l_min_set=0
   SELECT * INTO l_sfb.* FROM sfb_file
                 #      WHERE sfb01=g_srg[l_ac].srg16  #FUN-C90077 mark
                        WHERE sfb01=p_srg16            #FUN-C90077  
   IF l_sfb.sfb39 != '2' THEN
      #工單完工方式為'2' pull 不check min_set
       CALL s_get_ima153(l_sfb.sfb05) RETURNING l_ima153  #FUN-910053  
       #CALL s_minp(l_sfb.sfb01,g_sma.sma73,l_ima153,'')  #FUN-910053
   #   CALL s_minp(l_sfb.sfb01,g_sma.sma73,l_ima153,'','','')  #FUN-A60027   #FUN-C70037 mark
       CALL s_minp(l_sfb.sfb01,g_sma.sma73,l_ima153,'','','',g_srf.srf02)    #FUN-C70037 
                   RETURNING l_cnt,l_min_set
       IF l_cnt !=0  THEN
          CALL cl_err(l_tot+p_qty,'asf-549',1)
          RETURN FALSE
       END IF
 #FUN-C90077 ---------Begin------------
       LET l_cnt = 0
       CALL s_minp(l_sfb.sfb01,g_sma.sma73,l_ima153,'','','','')
                   RETURNING l_cnt,l_min_set1
       IF l_cnt !=0  THEN
          CALL cl_err(l_tot+p_qty,'asf-549',1)
          RETURN FALSE
       END IF
 #FUN-C90077 ---------End--------------
 
       #W/O 總入庫量大於最小套數 --
       IF l_sfb.sfb93='N' THEN
          IF (l_tot+p_qty) > l_min_set THEN
             CALL cl_err(l_sfb.sfb01,'asf-668',1)
             RETURN FALSE
          END IF
       #FUN-C90077 --------Begin------------
          IF (l_tot1+p_qty) > l_min_set1 THEN
             CALL cl_err(l_sfb.sfb01,'asf-668',1)
             RETURN FALSE
          END IF  
       #FUN-C90077 --------End--------------
       END IF
   END IF
   RETURN TRUE
END FUNCTION
 
FUNCTION t300_t410_g_b(l_qcf)
   DEFINE l_qcf    RECORD LIKE qcf_file.*
   DEFINE l_cnt    LIKE type_file.num5              #No.FUN-680130 SMALLINT
   DEFINE l_yn     LIKE type_file.num5              #No.FUN-680130 SMALLINT
   DEFINE l_qcd    RECORD LIKE qcd_file.*
   DEFINE l_qcg11  LIKE qcg_file.qcg11
   DEFINE seq      LIKE type_file.num5              #No.FUN-680130 SMALLINT
   DEFINE l_ac_num,l_re_num  LIKE type_file.num5    #No.FUN-680130 SMALLINT
 
   LET seq=1
 
   SELECT COUNT(*) INTO l_cnt FROM qcg_file
    WHERE qcg01 = l_qcf.qcf01
 
   IF l_cnt = 0 THEN
      #-----------------------------------------------------------
      #bug.3761 02/01/15 QC單身產生時先抓該料件檢驗項目,
      #                  抓不到再抓該料所屬材料類別之檢驗項目
      #-----------------------------------------------------------
      SELECT COUNT(*) INTO l_yn FROM qcd_file
       WHERE qcd01=l_qcf.qcf021
         AND qcd08 IN ('2','9')             #No.FUN-910079
      IF l_yn > 0 THEN  #--- 料件檢驗項目
         DECLARE qcd_cur2 CURSOR FOR SELECT * FROM qcd_file
                                     WHERE qcd01 = l_qcf.qcf021
                                       AND qcd08 IN ('2','9')             #No.FUN-910079
                                     ORDER BY qcd02
 
         FOREACH qcd_cur2 INTO l_qcd.*
            IF l_qcd.qcd05='1' THEN
               #-------- Ac,Re 數量賦予
               CALL s_newaql(l_qcf.qcf021,' ',l_qcd.qcd04,l_qcf.qcf22,' ','1')  #TQC-890055 add ' ','1'
                    RETURNING l_ac_num,l_re_num
               #-----------------------
               CALL t300_t410_defqty(2,l_qcd.qcd04,l_qcf.*)
                    RETURNING l_qcg11
            ELSE
               LET l_ac_num=0 LET l_re_num=1
               SELECT qcj05 INTO l_qcg11
                 FROM qcj_file
                WHERE (l_qcf.qcf22 BETWEEN qcj01 AND qcj02)
                  AND qcj03 = l_qcd.qcd04
                  AND qcj04 = l_qcd.qcd03   #MOD-CA0187 add
               IF STATUS THEN
                  LET l_qcg11 = 0
               END IF
            END IF
 
            IF l_qcg11 > l_qcf.qcf22 THEN
               LET l_qcg11 = l_qcf.qcf22
            END IF
 
            IF cl_null(l_qcg11) THEN
               LET l_qcg11 = 0
            END IF
 
            INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, #No.MOD-470041
                                  qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,
                                  qcgplant,qcglegal) #FUN-980008 add
                 VALUES(l_qcf.qcf01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                        0,'1',l_ac_num,l_re_num,l_qcg11,l_qcd.qcd05,
                        l_qcd.qcd061,l_qcd.qcd062,
                                  g_plant,g_legal) #FUN-980008 add
            LET seq=seq+1
         END FOREACH
      ELSE            #--- 材料類別檢驗項目
         DECLARE qck_cur2 CURSOR FOR SELECT qck_file.*
                                      FROM qck_file,ima_file
                                     WHERE qck01 = ima109
                                       AND ima01 = l_qcf.qcf021
                                       AND qck08 IN ('2','9')             #No.FUN-910079
                                     ORDER BY qck02
 
         FOREACH qck_cur2 INTO l_qcd.*
            IF l_qcd.qcd05='1' THEN
               #-------- Ac,Re 數量賦予
               CALL s_newaql(l_qcf.qcf021,' ',l_qcd.qcd04,l_qcf.qcf22,' ','1')  #TQC-890055 add ' ','1'
                    RETURNING l_ac_num,l_re_num
               #-----------------------
               CALL t300_t410_defqty(2,l_qcd.qcd04,l_qcf.*)
                    RETURNING l_qcg11
            ELSE
               LET l_ac_num=0 LET l_re_num=1
               SELECT qcj05 INTO l_qcg11
                 FROM qcj_file
                WHERE (l_qcf.qcf22 BETWEEN qcj01 AND qcj02)
                  AND qcj03=l_qcd.qcd04
                  AND qcj04=l_qcd.qcd03    #MOD-CA0187 add
               IF STATUS THEN LET l_qcg11=0 END IF
            END IF
 
            IF l_qcg11 > l_qcf.qcf22 THEN
               LET l_qcg11 = l_qcf.qcf22
            END IF
 
            IF cl_null(l_qcg11) THEN
               LET l_qcg11 = 0
            END IF
 
            INSERT INTO qcg_file (qcg01,qcg03,qcg04,qcg05,qcg06,qcg07, #No.MOD-470041
                                  qcg08,qcg09,qcg10,qcg11,qcg12,qcg131,qcg132,
                                  qcgplant,qcglegal) #FUN-980008 add
                 VALUES(l_qcf.qcf01,seq,l_qcd.qcd02,l_qcd.qcd03,l_qcd.qcd04,
                        0,'1',l_ac_num,l_re_num,l_qcg11,l_qcd.qcd05,
                        l_qcd.qcd061,l_qcd.qcd062,
                                  g_plant,g_legal) #FUN-980008 add
 
            LET seq = seq+1
         END FOREACH
      END IF
   END IF
 
END FUNCTION
 
FUNCTION t300_t410_defqty(l_def,l_rate,l_qcf)
   DEFINE l_def     LIKE type_file.num5,    #   1:單頭入 2.單身入 #No.FUN-680130 SMALLINT  
          l_rate    LIKE qcd_file.qcd04,
          l_qcb04   LIKE qcb_file.qcb04
   DEFINE l_pmh09   LIKE pmh_file.pmh09,
          l_pmh15   LIKE pmh_file.pmh15,
          l_pmh16   LIKE pmh_file.pmh16,
          l_qca03   LIKE qca_file.qca03,
          l_qca04   LIKE qca_file.qca04,
          l_qca05   LIKE qca_file.qca05,
          l_qca06   LIKE qca_file.qca06
   DEFINE l_qcf     RECORD LIKE qcf_file.*
 
   SELECT ima100,ima101,ima102
     INTO l_pmh09,l_pmh15,l_pmh16
     FROM ima_file
    WHERE ima01 = l_qcf.qcf021
 
   IF STATUS THEN
      LET l_pmh09 = ''
      LET l_pmh15 = ''
      LET l_pmh16 = ''
      RETURN 0
   END IF
 
   IF l_pmh09 IS NULL OR l_pmh09 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh15 IS NULL OR l_pmh15 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh16 IS NULL OR l_pmh16 = ' ' THEN
      RETURN 0
   END IF
 
   IF l_pmh15 = '1' THEN
      IF l_def = '1' THEN
         SELECT qca03,qca04,qca05,qca06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qca_file
         #WHERE l_qcf22 BETWEEN qca01 AND qca02        #bugno:7196  #MOD-C90077 mark 
          WHERE l_qcf.qcf22 BETWEEN qca01 AND qca02    #MOD-C90077
            AND qca07 = l_qcf.qcf17
         IF STATUS THEN
            RETURN 0
         END IF
      ELSE
         SELECT qcb04 INTO l_qcb04 FROM qcb_file,qca_file
         #WHERE (l_qcf22 BETWEEN qca01 AND qca02)       #bugno:7196  #MOD-C90077 mark
          WHERE (l_qcf.qcf22 BETWEEN qca01 AND qca02)   #MOD-C90077
            AND qcb02 = l_rate
            AND qca03 = qcb03
            AND qca07 = l_qcf.qcf17
            AND qcb01 = l_qcf.qcf21
         IF NOT cl_null(l_qcb04) THEN
            SELECT UNIQUE qca03,qca04,qca05,qca06  #MOD-860102 add UNIQUE 
              INTO l_qca03,l_qca04,l_qca05,l_qca06
              FROM qca_file
             WHERE qca03 = l_qcb04
               AND qca07 = l_qcf.qcf17
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
          END IF
      END IF
   END IF
 
   IF l_pmh15='2' THEN
      IF l_def = '1' THEN
         SELECT qch03,qch04,qch05,qch06
           INTO l_qca03,l_qca04,l_qca05,l_qca06
           FROM qch_file
         #WHERE l_qcf22 BETWEEN qch01 AND qch02       #bugno:7196  #MOD-C90077 mark
          WHERE l_qcf.qcf22 BETWEEN qch01 AND qch02   #MOD-C90077
            AND qch07 = l_qcf.qcf17
         IF STATUS THEN
            RETURN 0
         END IF
      ELSE
         SELECT qcb04 INTO l_qcb04 FROM qcb_file,qch_file
         #WHERE (l_qcf22 BETWEEN qch01 AND qch02)       #bugno:7196  #MOD-C90077 mark
          WHERE (l_qcf.qcf22 BETWEEN qch01 AND qch02)   #MOD-C90077
            AND qcb02 = l_rate
            AND qch03 = qcb03
            AND qch07 = l_qcf.qcf17
            AND qcb01 = l_qcf.qcf21
 
         IF NOT cl_null(l_qcb04) THEN
            SELECT UNIQUE qch03,qch04,qch05,qch06        #MOD-860102 add UNIQUE
              INTO l_qca03,l_qca04,l_qca05,l_qca06
              FROM qch_file
             WHERE qch03 = l_qcb04
               AND qch07 = l_qcf.qcf17
            IF STATUS THEN
               LET l_qca03 = 0
               LET l_qca04 = 0
               LET l_qca05 = 0
               LET l_qca06 = 0
            END IF
          END IF
      END IF
   END IF
 
   CASE l_pmh09
      WHEN 'N'
         RETURN l_qca04
      WHEN 'T'
         RETURN l_qca05
      WHEN 'R'
         RETURN l_qca06
      OTHERWISE
         RETURN 0
   END CASE
 
END FUNCTION
 
FUNCTION t300_t620_k()
DEFINE l_srg11     LIKE srg_file.srg11
DEFINE li_result   LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE l_slip      LIKE smy_file.smyslip  #No.TQC-AB0307
DEFINE l_smy72     LIKE smy_file.smy72    #No.TQC-AB0307
 
    SELECT * INTO g_srf.* FROM srf_file WHERE srf01 = g_srf.srf01
    IF NOT cl_null(g_srf.srf06) THEN RETURN END IF
    IF g_srf.srfconf<>'Y' THEN CALL cl_err(' ','9029',0) RETURN END IF
 
    INPUT g_srf.srf06 WITHOUT DEFAULTS FROM srf06
       AFTER FIELD srf06
         IF NOT cl_null(g_srf.srf06) THEN
           CALL s_check_no("asf",g_srf.srf06,"","3","sfu_file","sfu09","")
           RETURNING li_result,g_srf.srf06
           DISPLAY BY NAME g_srf.srf06
           IF (NOT li_result) THEN
             NEXT FIELD srf06
           END IF
           #TQC-AB0307--begin--add------
           CALL s_get_doc_no(g_srf.srf06) RETURNING l_slip
           SELECT smy72 INTO l_smy72 FROM smy_file
            WHERE smyslip=l_slip
           IF cl_null(l_smy72) THEN LET l_smy72 = ' ' END IF
           IF l_smy72 <> '4' THEN 
              CALL cl_err('','asm-145',1) NEXT FIELD srf06 
           END IF
           #TQC-AB0307--end--add-----
            
           CALL s_auto_assign_no("asf",g_srf.srf06,g_srf.srf02,"","sfp_file","sfp01","","","")
                RETURNING li_result,g_srf.srf06
           IF (NOT li_result) THEN
              NEXT FIELD srf06
           END IF
           DISPLAY BY NAME g_srf.srf06
         END IF
         
       ON ACTION controlp
          CASE WHEN INFIELD(srf06)
                    LET g_t1 = s_get_doc_no(g_srf.srf06)
                    LET g_sql= " (smy73 <> 'Y' OR smy73 is null) AND smy72='4' " #TQC-AB0307
                    CALL smy_qry_set_par_where(g_sql)   #TQC-AB0307
                    CALL q_smy( FALSE, TRUE,g_t1,'ASF','3') RETURNING g_t1  #TQC-670008
                    LET g_srf.srf06=g_t1
                    DISPLAY BY NAME g_srf.srf06
                    NEXT FIELD srf06
               OTHERWISE EXIT CASE
          END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
    #TQC-AB0307--begin--add---
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       LET g_srf.srf06=''
       DISPLAY BY NAME g_srf.srf06
      #ROLLBACK WORK         #TQC-C20239 mark
       RETURN
    END IF
    #TQC-AB0307--end--add
    IF cl_null(g_srf.srf06) THEN   #未輸入任何data
      #ROLLBACK WORK         #TQC-C20239 mark
       RETURN
    END IF
    #TQC-C20239-mark-str--
    #IF g_success = 'N' THEN
    #   ROLLBACK WORK
    #   RETURN
    #END IF
    #TQC-C20239-mark-end--
    IF NOT cl_sure(0,0) THEN
      #ROLLBACK WORK        #TQC-C20239 mark
       RETURN
    END IF
    
    LET g_success = 'Y'
    BEGIN WORK
    LET l_srg11=NULL
    DECLARE t300_t620_k1_c CURSOR FOR 
         SELECT DISTINCT srg11 FROM srg_file
                              WHERE srg01=g_srf.srf01
                                AND srg11 IS NOT NULL
    FOREACH t300_t620_k1_c INTO l_srg11  
       IF g_success='N' THEN
          EXIT FOREACH
       END IF                
       CALL t300_t620_k1(g_srf.srf06,l_srg11)
    END FOREACH
    IF cl_null(l_srg11) THEN
       LET g_success='N'
       CALL cl_err('','asr-045',1)
    END IF
    IF g_success = 'Y' THEN
       UPDATE srf_file SET srf06=g_srf.srf06 WHERE srf01=g_srf.srf01
       COMMIT WORK
       CALL cl_err('','asr-026',0)
    ELSE
       ROLLBACK WORK
       LET g_srf.srf06=NULL
       CALL cl_err('','9052',0)
    END IF
    DISPLAY BY NAME g_srf.srf06
END FUNCTION
 
FUNCTION t300_t620_k1(p_srf06,p_sfu01)
DEFINE li_result   LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE l_sfv    RECORD LIKE sfv_file.*,
       l_sfu    RECORD LIKE sfu_file.*,
       l_sfa    RECORD LIKE sfa_file.*,
       l_sfs    RECORD LIKE sfs_file.*,
       l_sfsi   RECORD LIKE sfsi_file.*,  #FUN-B70074 
       l_qpa    LIKE sfa_file.sfa161,
       l_qty    LIKE sfs_file.sfs05,
       l_sfu09  LIKE sfu_file.sfu09,
       l_flag   LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1) 
       l_name   LIKE type_file.chr20,  #No.FUN-680130 VARCHAR(12) 
       l_sfp    RECORD
             sfp01   LIKE sfp_file.sfp01,
             sfp02   LIKE sfp_file.sfp02,
             sfp03   LIKE sfp_file.sfp03,
             sfp04   LIKE sfp_file.sfp04,
             sfp05   LIKE sfp_file.sfp05,
             sfp06   LIKE sfp_file.sfp06,
             sfp07   LIKE sfp_file.sfp07
                END RECORD,
       l_sfb82  LIKE sfb_file.sfb82,
       l_bdate  LIKE type_file.dat,    #No.FUN-680130 DATE 
       l_edate  LIKE type_file.dat,    #No.FUN-680130 DATE 
       l_day    LIKE type_file.num5,   #No.FUN-680130 SMALLINT 
       l_cnt    LIKE type_file.num5    #No.FUN-680130 SMALLINT
DEFINE l_sfv11 LIKE sfv_file.sfv11
DEFINE l_msg   STRING
DEFINE p_srf06 LIKE srf_file.srf06
DEFINE p_sfu01 LIKE sfu_file.sfu01
DEFINE l_ima25 LIKE ima_file.ima25,
       l_ima55 LIKE ima_file.ima55,
       l_ima906 LIKE ima_file.ima906,
       l_ima907 LIKE ima_file.ima907,
       l_factor LIKE sfv_file.sfv31
       
    SELECT sfu_file.* INTO l_sfu.* FROM sfu_file
                                  WHERE sfu01=p_sfu01
                         
    IF l_sfu.sfu01 IS NULL THEN 
       LET g_success='N'
       RETURN 
    END IF
 
    SELECT sfv_file.* INTO l_sfv.* FROM sfv_file
                                  WHERE sfv01 = l_sfu.sfu01
 
    IF l_sfu.sfuconf = 'X' THEN CALL cl_err('','9024',0) RETURN END IF #FUN-660137
    IF l_sfu.sfupost = 'N' THEN  #未過帳
       LET g_success='N'
       CALL cl_err(l_sfu.sfu09,'asf-666',0)
       RETURN
    END IF
    IF l_sfu.sfu09 IS NOT NULL THEN  #已產生領料單
       LET g_success='N'
       CALL cl_err(l_sfu.sfu09,'asf-826',0)
       RETURN
    END IF
 
#...check單身工單是否有使用消秏性料件 -> 沒有則不可產生領料單
    SELECT COUNT(*) INTO l_cnt FROM sfv_file,sfa_file
     WHERE sfv01 = l_sfu.sfu01
       AND sfv11 = sfa01 AND sfa11 = 'E'
    IF l_cnt = 0 THEN 
       LET g_success='N'
       CALL cl_err('sel sfa','asf-735',0) 
       RETURN  
    END IF
#............................................................
    DROP TABLE tmp
    CREATE TEMP TABLE tmp
    (a         LIKE type_file.chr20, 
     b         LIKE type_file.chr1000,
     c         LIKE type_file.num20_6);
    LET l_sfu09=p_srf06
    LET l_sfu.sfu09=p_srf06
           
    #新增一筆資料
    IF l_sfu09 IS NOT NULL AND l_sfu.sfupost = 'Y' THEN
      #----先檢查領料單身資料是否已經存在------------
       DECLARE count_cur CURSOR FOR
           SELECT COUNT(*) FROM sfs_file
       WHERE sfs01 = l_sfu09
       OPEN count_cur
       FETCH count_cur INTO g_cnt
       IF g_cnt > 0  THEN  #已存在
          LET l_flag ='Y'
       ELSE
          LET l_flag ='N'
       END IF
       #-----------產生領料資料------------------------
 
       DECLARE t620_sfv_cur CURSOR  WITH HOLD FOR
          SELECT *  FROM  sfv_file
           WHERE sfv01 = l_sfu.sfu01
       LET l_cnt = 0
       CALL cl_outnam('asft300') RETURNING l_name
       START REPORT t300_t620_rep TO l_name
 
 
       FOREACH t620_sfv_cur INTO l_sfv.*
         IF STATUS THEN
            CALL cl_err('foreach s:',STATUS,0)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         DECLARE t620_sfs_cur CURSOR WITH HOLD FOR
         SELECT sfa_file.*,sfb82 FROM sfb_file,sfa_file
          WHERE sfb01 = l_sfv.sfv11   #工單單號
            AND sfb01 = sfa01
            AND sfa11 = 'E'
            ORDER BY sfa26
 
        FOREACH t620_sfs_cur INTO l_sfa.*,l_sfb82
            INITIALIZE l_sfs.* TO NULL
            INITIALIZE l_sfp.* TO NULL
 
         #-------發料單頭--------------
          LET l_sfp.sfp01 = l_sfu09
 
#領料單月份已與完工入庫單月份不同時,以完工入庫日期該月的最後一天為領料日
          LET l_sfp.sfp02 = g_today
          IF MONTH(g_today) != MONTH(l_sfu.sfu02) THEN
             IF MONTH(l_sfu.sfu02) = 12 THEN
                LET l_bdate = MDY(MONTH(l_sfu.sfu02),1,YEAR(l_sfu.sfu02))
                LET l_edate = MDY(1,1,YEAR(l_sfu.sfu02)+1)
             ELSE
                LET l_bdate = MDY(MONTH(l_sfu.sfu02),1,YEAR(l_sfu.sfu02))
                LET l_edate = MDY(MONTH(l_sfu.sfu02)+1,1,YEAR(l_sfu.sfu02))
             END IF
             LET l_day = l_edate - l_bdate   #計算最後一天日期
             LET l_sfp.sfp02 = MDY(MONTH(l_sfu.sfu02),l_day,YEAR(l_sfu.sfu02))
          END IF
 
          LET l_sfp.sfp03 = g_today
          LET l_sfp.sfp04 = 'N'
          LET l_sfp.sfp05 = 'N'
          LET l_sfp.sfp06 ='4'
          LET l_sfp.sfp07 = l_sfb82
          OUTPUT TO REPORT t300_t620_rep(l_sfp.*,l_flag)
          SELECT MAX(sfs02) INTO l_cnt FROM sfs_file
           WHERE sfs01 = l_sfu09
          IF l_cnt IS NULL THEN    #項次
             LET l_cnt = 1
          ELSE  LET l_cnt = l_cnt + 1
          END IF
         #-------發料單身--------------
          LET l_sfs.sfs01 = l_sfu09
          LET l_sfs.sfs02 = l_cnt
          LET l_sfs.sfs03 = l_sfa.sfa01
          LET l_sfs.sfs04 = l_sfa.sfa03
          LET l_sfs.sfs05 = l_sfv.sfv09*l_sfa.sfa161 #已發料量
          LET l_sfs.sfs06 = l_sfa.sfa12  #發料單位
          LET l_sfs.sfs07 = l_sfa.sfa30  #倉庫
          LET l_sfs.sfs08 = l_sfa.sfa31  #儲位
          LET l_sfs.sfs09 = ' '          #批號
          LET l_sfs.sfs10 = l_sfa.sfa08  #作業序號
          LET l_sfs.sfs26 = NULL         #替代碼
          LET l_sfs.sfs27 = NULL         #被替代料號
          LET l_sfs.sfs28 = NULL         #替代率
          LET l_sfs.sfs930= l_sfv.sfv930 #FUN-670103
#FUN-C70014 add begin-----------------------------
         LET l_sfs.sfs014 =l_sfv.sfv20  
         IF cl_null(l_sfs.sfs014) THEN 
            LET l_sfs.sfs014 = ' '     
         END IF 
#FUN-C70014 add end-------------------------------
          LET l_sfs.sfsplant = g_plant #FUN-980008 add
          LET l_sfs.sfslegal = g_legal #FUN-980008 add
 
       #  IF l_sfa.sfa26 MATCHES '[SUT]' THEN    #bugno:7111 add 'T'  #FUN-A20037
          IF l_sfa.sfa26 MATCHES '[SUTZ]' THEN    #FUN-A20037
             LET l_sfs.sfs26 = l_sfa.sfa26
             LET l_sfs.sfs27 = l_sfa.sfa27
             LET l_sfs.sfs28 = l_sfa.sfa28
             LET l_sfs.sfs012 = l_sfa.sfa012  #FUN-A60027 add
             LET l_sfs.sfs013 = l_sfa.sfa013  #FUN-A60027 add
             SELECT (sfa161 * sfa28) INTO l_qpa FROM sfa_file
                WHERE sfa01 = l_sfa.sfa01 AND sfa03 = l_sfa.sfa27
                AND sfa012 = l_sfa.sfa012 AND sfa013 = l_sfa.sfa013  #FUN-A60027 add
             LET l_sfs.sfs05 = l_sfv.sfv09*l_qpa
             SELECT SUM(c) INTO l_qty FROM tmp WHERE a = l_sfa.sfa01
                AND b = l_sfa.sfa27
             IF l_sfs.sfs05 < l_qty THEN
                LET l_sfs.sfs05 = 0
             ELSE
                LET l_sfs.sfs05 = l_sfs.sfs05 - l_qty

             END IF
          ELSE                               #No.MOD-8B0086 add
             LET l_sfs.sfs27 = l_sfa.sfa27   #No.MOD-8B0086 add
          END IF
 
        #判斷發料是否大於可發料數(sfa05-sfa06)
          IF l_sfs.sfs05 > (l_sfa.sfa05 - l_sfa.sfa06) THEN
             LET l_sfs.sfs05 = l_sfa.sfa05 - l_sfa.sfa06
          END IF
          LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)   #FUN-BB0084

          IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF
          IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF
          IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
 
          INSERT INTO tmp
            VALUES(l_sfa.sfa01,l_sfa.sfa27,l_sfs.sfs05)
 
          IF g_sma.sma115 = 'Y' THEN
             SELECT ima25,ima55,ima906,ima907
               INTO l_ima25,l_ima55,l_ima906,l_ima907
               FROM ima_file
              WHERE ima01=l_sfs.sfs04
             IF SQLCA.sqlcode THEN
                CALL cl_err('sel ima',SQLCA.sqlcode,1)
                LET g_success = 'N'
             END IF
             IF cl_null(l_ima55) THEN LET l_ima55 = l_ima25 END IF
             LET l_sfs.sfs30=l_sfs.sfs06
             LET l_factor = 1
             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_ima55)
               RETURNING g_cnt,l_factor
             IF g_cnt = 1 THEN
                LET l_factor = 1
             END IF
             LET l_sfs.sfs31=l_factor
             LET l_sfs.sfs32=l_sfs.sfs05
             LET l_sfs.sfs33=l_ima907
             LET l_factor = 1
             CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs33,l_ima55)
               RETURNING g_cnt,l_factor
             IF g_cnt = 1 THEN
                LET l_factor = 1
             END IF
             LET l_sfs.sfs34=l_factor
             LET l_sfs.sfs35=0
             IF l_ima906 = '3' THEN
                LET l_factor = 1
                CALL s_umfchk(l_sfs.sfs04,l_sfs.sfs30,l_sfs.sfs33)
                  RETURNING g_cnt,l_factor
                IF g_cnt = 1 THEN
                   LET l_factor = 1
                END IF
                LET l_sfs.sfs35=l_sfs.sfs32*l_factor
                LET l_sfs.sfs35=s_digqty(l_sfs.sfs35,l_sfs.sfs33)    #FUN-BB0084
             END IF
             IF l_ima906='1' THEN
                LET l_sfs.sfs33=NULL
                LET l_sfs.sfs34=NULL
                LET l_sfs.sfs35=NULL
             END IF
          END IF
 
         IF l_flag ='N' THEN
            LET l_sfs.sfs012 = l_sfa.sfa012 #FUN-A60027 add
            LET l_sfs.sfs013 = l_sfa.sfa012 #FUN-A60027 add
            #FUN-CB0087---add---str---
            IF g_aza.aza115 = 'Y' THEN
               CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,g_user,l_sfp.sfp07) RETURNING l_sfs.sfs37
               IF cl_null(l_sfs.sfs37) THEN 
                  CALL cl_err('','aim-425',1) 
                  LET g_success = 'N'
               END IF
            END IF
            #FUN-CB0087---add---end-- 
            INSERT INTO sfs_file VALUES (l_sfs.*)
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err('ins sfs',STATUS,0)
              LET g_success = 'N'
   #FUN-B70074 ---------------Begin----------------
            ELSE
               IF NOT s_industry('std') THEN
                  INITIALIZE l_sfsi.* TO NULL
                  LET l_sfsi.sfsi01 = l_sfs.sfs01
                  LET l_sfsi.sfsi02 = l_sfs.sfs02
                  IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
                    LET g_success = 'N'
                  END IF
               END IF
   #FUN-B70074 ---------------End------------------ 
            END IF
         ELSE
            UPDATE sfs_file SET * = l_sfs.* WHERE sfs01 = l_sfs.sfs01
            IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
               CALL cl_err('ins sfs',STATUS,0)
               LET g_success = 'N'
            END IF
         END IF
       END FOREACH
     END FOREACH
     FINISH REPORT t300_t620_rep
     IF l_sfu09 IS NOT NULL THEN
        LET l_sfu.sfu09 = l_sfu09
        UPDATE sfu_file SET sfu09 = l_sfu.sfu09
         WHERE sfu01 = l_sfu.sfu01
        IF STATUS THEN
           CALL cl_err('upd sfu',STATUS,1)
           LET g_success = 'N'
        END IF
     END IF
    END IF
 
END FUNCTION
 
REPORT t300_t620_rep(sr,p_flag)
  DEFINE p_flag  LIKE type_file.chr1,   #No.FUN-680130 VARCHAR(1) 
         sr  RECORD
                sfp01 LIKE sfp_file.sfp01,
                sfp02 LIKE sfp_file.sfp02,
                sfp03 LIKE sfp_file.sfp03,
                sfp04 LIKE sfp_file.sfp04,
                sfp05 LIKE sfp_file.sfp05,
                sfp06 LIKE sfp_file.sfp06,
                sfp07 LIKE sfp_file.sfp07
             END RECORD
 
  ORDER BY sr.sfp01
  FORMAT
    AFTER GROUP OF sr.sfp01
      IF p_flag ='Y' THEN
            UPDATE sfp_file SET sfp02= sr.sfp02,
                                sfp04= sr.sfp04,sfp05 = sr.sfp05,
                                sfp06= sr.sfp06,sfp07 = sr.sfp07,
                                sfpmodu=g_user,sfpdate=g_today
               WHERE sfp01 = sr.sfp01
            IF SQLCA.sqlcode THEN LET g_success='N' END IF
      ELSE
 
           INSERT INTO sfp_file(sfp01,sfp02,sfp03,sfp04,sfp05,sfp06,sfp07,sfp09,
                                sfpuser,sfpdate,sfpconf,                          #FUN-660106
                                sfpmksg,sfp15,sfp16,                              #FUN-AB0001 add:sfpmksg,sfp15,sfp16 
                                sfpplant,sfplegal,sfporiu,sfporig) #FUN-980008 add
                         VALUES(sr.sfp01,sr.sfp02,sr.sfp03,sr.sfp04,sr.sfp05,sr.sfp06,sr.sfp07,'N',
                                g_user,g_today,'N',                               #FUN-660106 
                                g_smy.smyapr,'0',g_user,                          #FUN-AB0001 add:sfpmksg,sfp15,sfp16 
                                g_plant,g_legal, g_user, g_grup)                  #FUN-980008 add   #No.FUN-980030 10/01/04  insert columns oriu, orig
 
            IF SQLCA.sqlcode THEN LET g_success='N' END IF
      END IF
 
END REPORT
 
FUNCTION t300_get_srg930()
DEFINE l_eca03 LIKE eca_file.eca03
   SELECT eca03 INTO l_eca03 FROM eca_file,eci_file 
                            WHERE eci01=g_srf.srf03
                              AND eca01=eci03
   IF SQLCA.sqlcode THEN
      LET l_eca03=NULL
   END IF
   RETURN s_costcenter(l_eca03)
END FUNCTION
 
FUNCTION t300_spc()
DEFINE l_i            LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_ac           LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_cnt          LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_qc_cnt       LIKE type_file.num10   #No.FUN-680130 INTEGER
DEFINE l_qcs          DYNAMIC ARRAY OF RECORD LIKE qcs_file.*
DEFINE l_qcf          DYNAMIC ARRAY OF RECORD LIKE qcf_file.*
DEFINE l_qc_prog      LIKE gaz_file.gaz01   #No.FUN-680130 VARCHAR(10)
DEFINE l_sql          STRING
DEFINE l_err          STRING
   
   LET g_success = 'Y'   
 
   #檢查資料是否可拋轉
   IF g_srf.srf01 IS NULL OR g_srf.srf01 = ' ' THEN  #尚未查詢資料
      LET g_success='N'
      RETURN
   END IF
   IF g_srf.srfconf matches '[Nn]' THEN              #判斷是否確認
      CALL cl_err('','mfg3550',0)
      LET g_success='N'
      RETURN
   END IF
   IF g_srf.srfconf matches '[X]' THEN               #判斷是否作廢  
      CALL cl_err('','9024',0)
      LET g_success='N'
      RETURN
   END IF
 
   #需檢驗的資料，選擇性新增資料至FQC單及入庫單 
   BEGIN WORK
   OPEN t300_cl USING g_srf.srf01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO g_srf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_srf.srf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   CALL t300_w1()
   CLOSE t300_cl
   IF g_success <> 'Y' THEN
      ROLLBACK WORK
      CALL cl_err('','9052',0)
   ELSE
      COMMIT WORK
      CALL t300_show()
      #需要 FQC 檢驗的筆數
      SELECT COUNT(*) INTO l_qc_cnt FROM srg_file 
       WHERE srg01 = g_srf.srf01 AND srg15 = 'Y' AND srg05>0
         
      #判斷產生的FQC單筆數是否正確
      LET l_cnt = 0
      IF g_argv1 = '1' THEN
         SELECT COUNT(*) INTO l_cnt FROM qcs_file WHERE qcs01 = g_srf.srf01
      ELSE
         FOR l_ac = 1 TO g_rec_b  
            IF g_srg[l_ac].srg15 = 'Y' THEN
               SELECT COUNT(*) INTO l_i FROM qcf_file 
                WHERE qcf01=g_srg[l_ac].srg12 
               IF l_i > 0 THEN 
                  LET l_cnt = l_cnt + 1
               END IF
            END IF
         END FOR
      END IF
      IF l_cnt <> l_qc_cnt THEN
         CALL t300_fqc_del()
         LET g_success='N'
         RETURN
      END IF
      
      IF g_argv1 = '1' THEN
         LET l_qc_prog = "asrt310"               #設定FQC單的程式代號
         LET l_sql  = "SELECT *  FROM qcs_file WHERE qcs01 = '",g_srf.srf01,"'"
         PREPARE t300_qc_p1 FROM l_sql
         DECLARE t300_qc_c1 CURSOR WITH HOLD FOR t300_qc_p1
         LET l_cnt = 1
         FOREACH t300_qc_c1 INTO l_qcs[l_cnt].*
             LET l_cnt = l_cnt + 1 
         END FOREACH
         CALL l_qcs.deleteElement(l_cnt)
      
         # CALL aws_spccli() 
         #功能: 傳送此單號所有的 QC 單至 SPC 端
         # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
         # 回傳值  : 0 傳送失敗; 1 傳送成功
         IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcs),"insert") THEN
            LET g_srf.srfspc = '1'
         ELSE
            LET g_srf.srfspc = '2'
            CALL t300_fqc_del()
         END IF
      ELSE
         LET l_qc_prog = "aqct410"               #設定FQC單的程式代號
         FOR l_ac = 1 TO g_rec_b  
            IF g_srg[l_ac].srg15 = 'Y' THEN
               LET l_sql  = "SELECT *  FROM qcf_file 
                              WHERE qcf01 = '",g_srg[l_ac].srg12,"'"
               PREPARE t300_qc_p2 FROM l_sql
               DECLARE t300_qc_c2 CURSOR WITH HOLD FOR t300_qc_p2
               LET l_cnt = 1
               FOREACH t300_qc_c2 INTO l_qcf[l_cnt].*
                  LET l_cnt = l_cnt + 1 
               END FOREACH
               CALL l_qcf.deleteElement(l_cnt)
            END IF
         END FOR
         # CALL aws_spccli() 
         #功能: 傳送此單號所有的 QC 單至 SPC 端
         # 傳入參數: (1) QC 程式代號, (2) QC 單頭資料,
         # 回傳值  : 0 傳送失敗; 1 傳送成功
         IF aws_spccli(l_qc_prog,base.TypeInfo.create(l_qcf),"insert") THEN
            LET g_srf.srfspc = '1'
         ELSE
            LET g_srf.srfspc = '2'
            CALL t300_fqc_del()
         END IF
      END IF
      
      UPDATE srf_file set srfspc = g_srf.srfspc WHERE srf01 = g_srf.srf01
      IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","srf_file",g_srf.srf01,"",STATUS,"","upd srfspc",1)
         IF g_srf.srfspc = '1' THEN
            CALL t300_fqc_del()
         END IF
         LET g_success = 'N'
      END IF
      DISPLAY BY NAME g_srf.srfspc
      CALL cl_err('','asr-026',0)
   END IF
  
END FUNCTION 
 
FUNCTION t300_fqc_del()
 
   IF g_argv1 = '1' THEN
      DELETE FROM qcs_file WHERE qcs01 = g_srf.srf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcs_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qcs_file err!",0)
      END IF
   
      DELETE FROM qct_file WHERE qct01 = g_srf.srf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qct_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qct_file err!",0)
      END IF
   
      DELETE FROM qctt_file WHERE qctt01 = g_srf.srf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qctt_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qcstt_file err!",0)
      END IF
   ELSE
      DELETE FROM qcf_file WHERE qcf01 = g_srf.srf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcf_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qcf_file err!",0)
      END IF
   
      DELETE FROM qcg_file WHERE qcg01 = g_srf.srf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcg_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qcg_file err!",0)
      END IF
   
      DELETE FROM qcgg_file WHERE qcgg01 = g_srf.srf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qcgg_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qcsgg_file err!",0)
      END IF
   
      DELETE FROM qde_file WHERE qde01 = g_srf.srf01
      IF SQLCA.sqlcode THEN
         CALL cl_err3("del","qde_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qde_file err!",0)
      END IF
   END IF
 
   DELETE FROM qcu_file WHERE qcu01 = g_srf.srf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","qcu_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qcu_file err!",0)
   END IF
 
   DELETE FROM qcv_file WHERE qcv01 = g_srf.srf01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","qcv_file",g_srf.srf01,"",SQLCA.sqlcode,"","DEL qcv_file err!",0)
   END IF
 
   UPDATE srg_file set srg12 = '' 
    WHERE srg01 = g_srf.srf01 AND srg15 = 'Y'
   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err('upd srg12',SQLCA.sqlcode,1)
   END IF
 
END FUNCTION
 
FUNCTION t300_out()
   
   #獨立憑證的寫法
   DEFINE l_wc STRING
   DEFINE l_name    LIKE type_file.chr20
   DEFINE l_prog   STRING #CHI-6C0001
   DEFINE l_prog1  STRING    #CHI-830023 add
   DEFINE sr RECORD
                srf01    LIKE srf_file.srf01  , #報工單號     
                srf02    LIKE srf_file.srf02  , #報工日期     
                srf03    LIKE srf_file.srf03  , #機台生產線   
                eci06    LIKE eci_file.eci06  , #             
                srf04    LIKE srf_file.srf04  , #班別         
                ecg02    LIKE ecg_file.ecg02  , #             
                srf05    LIKE srf_file.srf05  , #生產日期     
                srf06    LIKE srf_file.srf06  , #領料單號     
                srfconf  LIKE srf_file.srfconf, #確認碼(y/n/x)
                srg01    LIKE srg_file.srg01  , #報工單號     
                srg02    LIKE srg_file.srg02  , #項次         
                srg03    LIKE srg_file.srg03  , #產品編號     
                ima02    LIKE ima_file.ima02  , #             
                ima021   LIKE ima_file.ima021 , #             
                srg04    LIKE srg_file.srg04  , #生產單位     
                srg05    LIKE srg_file.srg05  , #良品數       
                srg06    LIKE srg_file.srg06  , #不良品數     
                srg07    LIKE srg_file.srg07  , #報廢數量     
                srg08    LIKE srg_file.srg08  , #報工時間起   
                srg09    LIKE srg_file.srg09  , #報工時間迄   
                srg10    LIKE srg_file.srg10  , #工時(分)     
                srg11    LIKE srg_file.srg11  , #入庫單號     
                srg12    LIKE srg_file.srg12  , #fqc單號      
                srg15    LIKE srg_file.srg15  , #檢驗否(y/n)  
                srg16    LIKE srg_file.srg16  , #工單編號          
                gfe03    LIKE gfe_file.gfe03    #單位小位數
             END RECORD
   DEFINE g_str STRING   #No.FUN-7C0034
   IF g_srf.srf01 IS NULL THEN
      CALL cl_err('','-400','1')
      RETURN
   END IF
   IF cl_null(g_wc) THEN
      LET l_wc=" srf01='",g_srf.srf01,"'",    #TQC-760063
               " AND srf07='",g_srf.srf07,"'"
   ELSE
      IF cl_confirm('mfg0200') THEN
         LET l_wc=" srf01='",g_srf.srf01,"'",    #TQC-760063
                  " AND srf07='",g_srf.srf07,"'"
      ELSE
         LET l_wc=g_wc CLIPPED
      END IF
   END IF
  
   SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
   SELECT zz17,zz05 INTO g_len,g_zz05 FROM zz_file WHERE zz01 = g_prog  #No.FUN-7C0034
 
 
   LET g_sql="SELECT srf01,srf02,srf03,eci06,srf04,ecg02,srf05,srf06,srfconf,",
                   " srg01,srg02,srg03,ima02,ima021,srg04,srg05,srg06,srg07,",
                   " srg08,srg09,srg10,srg11,srg12,srg15,srg16,gfe03 ",
             "  FROM srf_file LEFT OUTER JOIN eci_file ON srf03=eci01 ",
                            " LEFT OUTER JOIN ecg_file ON srf04=ecg01,",
                   " srg_file LEFT OUTER JOIN ima_file ON srg03=ima01 ",
                            " LEFT OUTER JOIN gfe_file ON srg04=gfe01 ",
             " WHERE srf01=srg01 ",
             "   AND ",l_wc CLIPPED 
   IF cl_null(sr.gfe03) THEN LET sr.gfe03=0 END IF  

   LET l_prog=g_prog
   IF g_zz05 = 'Y' THEN                                                        
      CALL cl_wcchp(g_wc,'srf01,srf02,srf03,srf04,srf05,srfconf,srfspc,
                    srf06,srf07,srfuser,srfgrup,srfmodu,srfdate ')                           
        RETURNING g_str                                                        
   END IF                                                                      
   LET l_prog1 = g_prog      #CHI-830023 add
   LET g_prog  = 'asrt300'   #CHI-830023 add
   LET g_str = g_str,";",g_argv1,";",l_prog1   #CHI-830023 add l_prog1
   CALL cl_prt_cs1('asrt300','asrt300',g_sql,g_str)
   LET g_prog  = l_prog1     #CHI-830023 add
END FUNCTION
 
REPORT t300_rep(sr)
   DEFINE l_last_sw     LIKE type_file.chr1
   DEFINE sr RECORD
                srf01    LIKE srf_file.srf01  , #報工單號     
                srf02    LIKE srf_file.srf02  , #報工日期     
                srf03    LIKE srf_file.srf03  , #機台生產線   
                eci06    LIKE eci_file.eci06  , #             
                srf04    LIKE srf_file.srf04  , #班別         
                ecg02    LIKE ecg_file.ecg02  , #             
                srf05    LIKE srf_file.srf05  , #生產日期     
                srf06    LIKE srf_file.srf06  , #領料單號     
                srfconf  LIKE srf_file.srfconf, #確認碼(y/n/x)
                srg01    LIKE srg_file.srg01  , #報工單號     
                srg02    LIKE srg_file.srg02  , #項次         
                srg03    LIKE srg_file.srg03  , #產品編號     
                ima02    LIKE ima_file.ima02  , #             
                ima021   LIKE ima_file.ima021 , #             
                srg04    LIKE srg_file.srg04  , #生產單位     
                srg05    LIKE srg_file.srg05  , #良品數       
                srg06    LIKE srg_file.srg06  , #不良品數     
                srg07    LIKE srg_file.srg07  , #報廢數量     
                srg08    LIKE srg_file.srg08  , #報工時間起   
                srg09    LIKE srg_file.srg09  , #報工時間迄   
                srg10    LIKE srg_file.srg10  , #工時(分)     
                srg11    LIKE srg_file.srg11  , #入庫單號     
                srg12    LIKE srg_file.srg12  , #fqc單號      
                srg15    LIKE srg_file.srg15  , #檢驗否(y/n)  
                srg16    LIKE srg_file.srg16  , #工單編號      
                gfe03    LIKE gfe_file.gfe03    #單位小位數
             END RECORD
 
  OUTPUT TOP MARGIN g_top_margin 
  LEFT MARGIN g_left_margin 
  BOTTOM MARGIN g_bottom_margin 
  PAGE LENGTH g_page_line
 
  ORDER BY sr.srf01,sr.srg02
  FORMAT
  PAGE HEADER
     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
     LET g_pageno = g_pageno + 1
     LET pageno_total = PAGENO USING '<<<','/pageno'
     PRINT g_head CLIPPED, pageno_total     
     PRINT g_dash
     PRINT g_x[11],sr.srf01 CLIPPED,COLUMN (g_len/2),g_x[12],sr.srf02 CLIPPED
     PRINT g_x[13],sr.srf03 CLIPPED,' ',sr.eci06 CLIPPED,COLUMN (g_len/2),g_x[14],sr.srf04,' ',sr.ecg02 CLIPPED
     PRINT g_x[15],sr.srf05 CLIPPED,COLUMN (g_len/2),g_x[16],sr.srf06 CLIPPED
     PRINT g_x[17],sr.srfconf CLIPPED
     PRINT g_dash2
     PRINTX name=H1 g_x[31],g_x[32],g_x[33],g_x[36],g_x[38],g_x[41],g_x[44] 
     PRINTX name=H2 g_x[46],g_x[47],g_x[34],g_x[37],g_x[39],g_x[42],g_x[45]
     PRINTX name=H3 g_x[48],g_x[49],g_x[35],g_x[50],g_x[40],g_x[43]
     PRINT g_dash1
     LET l_last_sw='n'
 
  BEFORE GROUP OF sr.srf01
     SKIP TO TOP OF PAGE
 
  ON EVERY ROW
     IF cl_null(sr.gfe03) THEN LET sr.gfe03=0 END IF
     PRINTX name=D1
           COLUMN g_c[31],cl_numfor(sr.srg02,31,0),
           COLUMN g_c[32],sr.srg16 CLIPPED,
           COLUMN g_c[33],sr.srg03 CLIPPED,
           COLUMN g_c[36],sr.srg04 CLIPPED,
           COLUMN g_c[38],cl_numfor(sr.srg05,38,sr.gfe03),
           COLUMN g_c[41],sr.srg08 CLIPPED,
           COLUMN g_c[44],sr.srg11 CLIPPED
     PRINTX name=D2
           COLUMN g_c[34],sr.ima02 CLIPPED,
           COLUMN g_c[37],sr.srg15 CLIPPED,
           COLUMN g_c[39],cl_numfor(sr.srg06,39,sr.gfe03),
           COLUMN g_c[42],sr.srg09 CLIPPED,
           COLUMN g_c[45],sr.srg12 CLIPPED
     PRINTX name=D3
           COLUMN g_c[35],sr.ima021 CLIPPED,
           COLUMN g_c[40],cl_numfor(sr.srg07,40,sr.gfe03),
           COLUMN g_c[43],cl_numfor(sr.srg10,43,0)
     PRINT     
 
  ON LAST ROW
     LET l_last_sw = 'y'
 
  PAGE TRAILER
     PRINT g_dash
     IF l_last_sw='n' THEN
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
     ELSE
      PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
     END IF
 
     PRINT
     IF l_last_sw = 'n' THEN
        IF g_memo_pagetrailer THEN
           PRINT g_x[9]
           PRINT g_memo
        ELSE
           PRINT
           PRINT
        END IF
     ELSE
        PRINT g_x[9]
        PRINT g_memo
     END IF
END REPORT
 
FUNCTION t300_b_move_to()
   LET g_srg[l_ac].srg02  = b_srg.srg02 
   LET g_srg[l_ac].srg16  = b_srg.srg16 
   LET g_srg[l_ac].srg03  = b_srg.srg03 
   LET g_srg[l_ac].srg04  = b_srg.srg04 
   LET g_srg[l_ac].srg15  = b_srg.srg15 
   LET g_srg[l_ac].srg05  = b_srg.srg05 
   LET g_srg[l_ac].srg06  = b_srg.srg06 
   LET g_srg[l_ac].srg07  = b_srg.srg07 
   LET g_srg[l_ac].srg08  = b_srg.srg08 
   LET g_srg[l_ac].srg09  = b_srg.srg09 
   LET g_srg[l_ac].srg10  = b_srg.srg10 
   LET g_srg[l_ac].srg19  = b_srg.srg19     #FUN-910076 
   LET g_srg[l_ac].srg11  = b_srg.srg11 
   LET g_srg[l_ac].srg17  = b_srg.srg17 
   LET g_srg[l_ac].srg12  = b_srg.srg12 
   LET g_srg[l_ac].srg18  = b_srg.srg18 
   LET g_srg[l_ac].srg13  = b_srg.srg13 
   LET g_srg[l_ac].srg14  = b_srg.srg14 
   LET g_srg[l_ac].srg930 = b_srg.srg930
   LET g_srg[l_ac].srgud01 = b_srg.srgud01
   LET g_srg[l_ac].srgud02 = b_srg.srgud02
   LET g_srg[l_ac].srgud03 = b_srg.srgud03
   LET g_srg[l_ac].srgud04 = b_srg.srgud04
   LET g_srg[l_ac].srgud05 = b_srg.srgud05
   LET g_srg[l_ac].srgud06 = b_srg.srgud06
   LET g_srg[l_ac].srgud07 = b_srg.srgud07
   LET g_srg[l_ac].srgud08 = b_srg.srgud08
   LET g_srg[l_ac].srgud09 = b_srg.srgud09
   LET g_srg[l_ac].srgud10 = b_srg.srgud10
   LET g_srg[l_ac].srgud11 = b_srg.srgud11
   LET g_srg[l_ac].srgud12 = b_srg.srgud12
   LET g_srg[l_ac].srgud13 = b_srg.srgud13
   LET g_srg[l_ac].srgud14 = b_srg.srgud14
   LET g_srg[l_ac].srgud15 = b_srg.srgud15
END FUNCTION
 
FUNCTION t300_b_move_back()
   #Key 值
   LET b_srg.srg01 = g_srf.srf01
   
   LET b_srg.srg02 = g_srg[l_ac].srg02  
   LET b_srg.srg16 = g_srg[l_ac].srg16  
   LET b_srg.srg03 = g_srg[l_ac].srg03  
   LET b_srg.srg04 = g_srg[l_ac].srg04  
   LET b_srg.srg15 = g_srg[l_ac].srg15  
   LET b_srg.srg05 = g_srg[l_ac].srg05  
   LET b_srg.srg06 = g_srg[l_ac].srg06  
   LET b_srg.srg07 = g_srg[l_ac].srg07  
   LET b_srg.srg08 = g_srg[l_ac].srg08  
   LET b_srg.srg09 = g_srg[l_ac].srg09  
   LET b_srg.srg10 = g_srg[l_ac].srg10  
   LET b_srg.srg19 = g_srg[l_ac].srg19     #FUN-910076  
   LET b_srg.srg11 = g_srg[l_ac].srg11  
   LET b_srg.srg17 = g_srg[l_ac].srg17  
   LET b_srg.srg12 = g_srg[l_ac].srg12  
   LET b_srg.srg18 = g_srg[l_ac].srg18  
   LET b_srg.srg13 = g_srg[l_ac].srg13  
   LET b_srg.srg14 = g_srg[l_ac].srg14  
   LET b_srg.srg930= g_srg[l_ac].srg930
   LET b_srg.srgud01 = g_srg[l_ac].srgud01
   LET b_srg.srgud02 = g_srg[l_ac].srgud02
   LET b_srg.srgud03 = g_srg[l_ac].srgud03
   LET b_srg.srgud04 = g_srg[l_ac].srgud04
   LET b_srg.srgud05 = g_srg[l_ac].srgud05
   LET b_srg.srgud06 = g_srg[l_ac].srgud06
   LET b_srg.srgud07 = g_srg[l_ac].srgud07
   LET b_srg.srgud08 = g_srg[l_ac].srgud08
   LET b_srg.srgud09 = g_srg[l_ac].srgud09
   LET b_srg.srgud10 = g_srg[l_ac].srgud10
   LET b_srg.srgud11 = g_srg[l_ac].srgud11
   LET b_srg.srgud12 = g_srg[l_ac].srgud12
   LET b_srg.srgud13 = g_srg[l_ac].srgud13
   LET b_srg.srgud14 = g_srg[l_ac].srgud14
   LET b_srg.srgud15 = g_srg[l_ac].srgud15
 
   LET b_srg.srgplant = g_plant #FUN-980008 add
   LET b_srg.srglegal = g_legal #FUN-980008 add
END FUNCTION
#No.FUN-9C0073  -----------By chenls 10/01/05

#No.FUN-BB0086--add--begin--
FUNCTION t300_srg05_check()
   IF NOT cl_null(g_srg[l_ac].srg05) AND NOT cl_null(g_srg[l_ac].srg04) THEN
      IF cl_null(g_srg_t.srg05) OR cl_null(g_srg04_t) OR g_srg_t.srg05 != g_srg[l_ac].srg05 OR g_srg04_t != g_srg[l_ac].srg04 THEN
         LET g_srg[l_ac].srg05=s_digqty(g_srg[l_ac].srg05,g_srg[l_ac].srg04)
         DISPLAY BY NAME g_srg[l_ac].srg05
      END IF
   END IF
   
  IF (NOT cl_null(g_srg[l_ac].srg05)) AND 
     (g_argv1='2') AND
     (g_srg[l_ac].srg05 <> g_srg_t.srg05 OR g_srg_t.srg05 IS NULL) THEN
     #IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07) THEN   #FUN-C90077  mark
      IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07,g_srg[l_ac].srg16,TRUE) THEN   #FUN-C90077
         RETURN FALSE 
      END IF
      #MOD-D90079 add begin------------------------------
      IF NOT t300_srg05_check2(g_srg[l_ac].srg05,g_srg[l_ac].srg16,TRUE) THEN
         RETURN FALSE
      END IF 
      #MOD-D90079 add end--------------------------------
  END IF 
  RETURN TRUE 
END FUNCTION

FUNCTION t300_srg06_check()
   IF NOT cl_null(g_srg[l_ac].srg06) AND NOT cl_null(g_srg[l_ac].srg04) THEN
      IF cl_null(g_srg_t.srg06) OR cl_null(g_srg04_t) OR g_srg_t.srg06 != g_srg[l_ac].srg06 OR g_srg04_t != g_srg[l_ac].srg04 THEN
         LET g_srg[l_ac].srg06=s_digqty(g_srg[l_ac].srg06,g_srg[l_ac].srg04)
         DISPLAY BY NAME g_srg[l_ac].srg06
      END IF
   END IF
   
  IF (NOT cl_null(g_srg[l_ac].srg06)) AND 
     (g_argv1='2') AND
     (g_srg[l_ac].srg06 <> g_srg_t.srg06 OR g_srg_t.srg06 IS NULL) THEN
  #   IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07) THEN     #FUN-C90077 mark                 
      IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07,g_srg[l_ac].srg16,TRUE) THEN   #FUN-C90077
         RETURN FALSE 
      END IF
  END IF
  RETURN TRUE 
END FUNCTION

FUNCTION t300_srg07_check()
   IF NOT cl_null(g_srg[l_ac].srg07) AND NOT cl_null(g_srg[l_ac].srg04) THEN
      IF cl_null(g_srg_t.srg07) OR cl_null(g_srg04_t) OR g_srg_t.srg07 != g_srg[l_ac].srg07 OR g_srg04_t != g_srg[l_ac].srg04 THEN
         LET g_srg[l_ac].srg07=s_digqty(g_srg[l_ac].srg07,g_srg[l_ac].srg04)
         DISPLAY BY NAME g_srg[l_ac].srg07
      END IF
   END IF
   
  IF (NOT cl_null(g_srg[l_ac].srg07)) AND 
     (g_argv1='2') AND
     (g_srg[l_ac].srg07 <> g_srg_t.srg07 OR g_srg_t.srg07 IS NULL) THEN
 #    IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07) THEN     #FUN-C90077 mark 
      IF NOT t300_chk_sfb081(g_srg[l_ac].srg05+g_srg[l_ac].srg06+g_srg[l_ac].srg07,g_srg[l_ac].srg16,TRUE) THEN   #FUN-C90077
         RETURN FALSE 
      END IF
  END IF
  RETURN TRUE 
END FUNCTION
#No.FUN-BB0086--add--end--


#DEV-D30045--add--begin
FUNCTION t300_barcode_out()
   DEFINE l_cmd       STRING

   IF g_srf.srf01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

   LET g_msg = ' ibb03="',g_srf.srf01 CLIPPED,'"'
   LET l_cmd = "abar100",
               " '",g_today CLIPPED,"' ''",
               " '",g_lang CLIPPED,"' 'Y' '' '1'",
               " '' '' '' '' ",
               " '",g_msg CLIPPED,"' ",
               " ' ' 'C' '",s_gen_barcode_ibd07(),"'"
   CALL cl_cmdrun_wait(l_cmd)
END FUNCTION

FUNCTION t300_barcode_gen(p_srf01,p_ask)
   DEFINE p_srf01   LIKE srf_file.srf01
   DEFINE p_ask     LIKE type_file.chr1
   DEFINE l_srf     RECORD LIKE srf_file.*

   IF cl_null(p_srf01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF

   SELECT * INTO l_srf.* FROM srf_file WHERE srf01 = p_srf01

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('C',l_srf.srf01,'','') THEN
      RETURN
   END IF

   IF l_srf.srfconf = 'N' THEN
      CALL cl_err('','sfb-999',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF l_srf.srfconf = 'X' THEN
      CALL cl_err('','sfb-998',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk(l_srf.srf01) THEN
      LET g_success = 'N'
      RETURN
   END IF

   IF p_ask = 'Y' THEN   
      IF NOT cl_confirm('azz1276') THEN
         LET g_success='N'
         RETURN
      END IF
   END IF

   LET g_success = 'Y'
   CALL s_showmsg_init()
   BEGIN WORK


   OPEN t300_cl USING l_srf.srf01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t300_cl INTO l_srf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_srf.srf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t300_cl
      ROLLBACK WORK
      RETURN
   END IF

   #DEV-D30043--mark--begin
   #IF NOT s_diy_barcode(l_srf.srf01,'','','C') THEN
   #   LET g_success = 'N'
   #END IF
 
   #IF g_success = 'Y' THEN
   #   CALL s_gen_barcode2('C',l_srf.srf01,'','')
   #END IF
   #DEV-D30043--mark--end

   #DEV-D30043--add--begin
   IF g_success = 'Y' THEN
      CALL s_gen_barcode2('C',l_srf.srf01,'','')
   END IF

   IF g_success = 'Y' THEN
      IF NOT s_diy_barcode(l_srf.srf01,'','','C') THEN
         LET g_success = 'N'
      END IF
   END IF
   #DEV-D30043--add--end

   CALL s_showmsg()
   IF g_success='Y' THEN
      COMMIT WORK
      CALL cl_msgany(0,0,'aba-001')
   ELSE
      ROLLBACK WORK
      #CALL cl_msgany(0,0,'aba-002')    #DEV-D40015--mark
      CALL cl_err('','aba-002',0)       #DEV-D40015--mod
   END IF
END FUNCTION

FUNCTION t300_barcode_z(p_srf01)
   DEFINE p_srf01   LIKE srf_file.srf01
   DEFINE l_srf     RECORD LIKE srf_file.*
   DEFINE l_srg02   LIKE srg_file.srg02
   DEFINE l_srg03   LIKE srg_file.srg03
   DEFINE l_srg05   LIKE srg_file.srg05
   DEFINE l_ima918  LIKE ima_file.ima918
   DEFINE l_ima919  LIKE ima_file.ima919
   DEFINE l_ima920  LIKE ima_file.ima920
   DEFINE l_ima921  LIKE ima_file.ima921
   DEFINE l_ima922  LIKE ima_file.ima922
   DEFINE l_ima923  LIKE ima_file.ima923
   DEFINE l_ima931  LIKE ima_file.ima931
   DEFINE l_ima933  LIKE ima_file.ima933
   DEFINE l_n       LIKE type_file.num5
   DEFINE l_sql     STRING

   IF cl_null(p_srf01) THEN
      CALL cl_err('',-400,0)
      LET g_success = 'N'
      RETURN
   END IF
   SELECT * INTO l_srf.* FROM srf_file WHERE srf01 =p_srf01 

   #檢查是否符合產生時機點
   IF NOT s_gen_barcode_chktype('C',l_srf.srf01,'','') THEN
      LET g_success  = 'Y'       #DEV-D40015 add
      RETURN
   END IF

   IF l_srf.srfconf = 'X' THEN
      CALL cl_err(' ','9024',0)
      LET g_success = 'N'
      RETURN
   END IF

   IF NOT s_tlfb_chk2(l_srf.srf01) THEN
      LET g_success = 'N'
      RETURN
   END IF

  #LET g_success = 'Y'      #DEV-D40015 mark
  #BEGIN WORK               #DEV-D40015 mark

   OPEN t300_cl USING l_srf.srf01
   IF STATUS THEN
      CALL cl_err("OPEN t300_cl:", STATUS, 1)
      LET g_success = 'N'
      CLOSE t300_cl
     #ROLLBACK WORK         #DEV-D40015 mark
      RETURN
   END IF
   FETCH t300_cl INTO l_srf.*          # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(l_srf.srf01,SQLCA.sqlcode,0)     # 資料被他人LOCK
      LET g_success = 'N'
      CLOSE t300_cl
     #ROLLBACK WORK        #DEV-D40015 mark
      RETURN
   END IF

   IF g_success='Y' THEN
      CALL s_barcode_x2('C',l_srf.srf01,'','')
   END IF

   IF g_success='Y' THEN
     #COMMIT WORK           #DEV-D40015 mark   
      CALL cl_msgany(0,0,'aba-178')
   ELSE
     #ROLLBACK WORK         #DEV-D40015 mark
      CALL cl_msgany(0,0,'aba-179')
   END IF
END FUNCTION
#MOD-D90079 add begin----------------------
#对倒扣料工单的良品数量进行检查，不能大于工单生产数量
FUNCTION t300_srg05_check2(p_srg05,p_srg16,p_flag)
DEFINE p_srg05 LIKE srg_file.srg05,
       p_srg16 LIKE srg_file.srg16,
       p_flag  BOOLEAN
DEFINE l_sfb    RECORD LIKE sfb_file.*,
       l_sql    STRING,
       l_tot    LIKE srg_file.srg05,
       l_ima153 LIKE ima_file.ima153
   SELECT * INTO l_sfb.* FROM sfb_file
    WHERE sfb01=p_srg16
   IF l_sfb.sfb39 = '2' THEN
      LET l_sql = "SELECT SUM(srg05) FROM srf_file,srg_file ",
                  " WHERE srg01 = srf01",
                  "   AND srfconf<>'X'",
                  "   AND srg16 ='",p_srg16,"'"
      IF p_flag THEN
         LET l_sql = l_sql CLIPPED," AND NOT ( srf01 = '",g_srf.srf01,"'",
                                   " AND srg02 = '",g_srg[l_ac].srg02,"'",")"
      END IF
      PREPARE t300_sum_srg05_pre FROM l_sql
      EXECUTE t300_sum_srg05_pre INTO l_tot 
      IF SQLCA.sqlcode OR (cl_null(l_tot)) THEN
         LET l_tot = 0
      END IF 
      LET l_tot = l_tot + p_srg05
      CALL s_get_ima153(l_sfb.sfb05) RETURNING l_ima153
      IF cl_null(l_ima153) THEN LET l_ima153 = 0 END IF 
      LET l_sfb.sfb08 = l_sfb.sfb08 * (100+l_ima153)/100
      IF l_tot > l_sfb.sfb08 THEN 
         CALL cl_err(l_tot,'asf1164',1)
         RETURN FALSE
      END IF 
   END IF 
   RETURN TRUE
END FUNCTION 
#MOD-D90079 add end------------------------
#DEV-D30045--add--end

# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axmi121.4gl
# Descriptions...: 產品主檔維護作業
# Date & Author..: 94/12/15 by Nick
# Modify.........: 95/03/20 By Danny
#                  (ima09,ima10,ima11,ima12 原check imz_file,改check azf_file)
# Modify....2.0版: 95/10/19 By Danny 在顯示完單位說明後,應清除
#                                                    換率
#                  當取消時insert azo_file
# Modify.........: 00/01/20:By Carol:i121_m()修正 insert,update,show
#                : 01-04-06 BY ANN CHEN B049 取消刪除的功能
#                                            新增時的Deafult值同aimi100
# Modify.........: No:7694 03/08/07 Carol ima145產品序號為固定長度給default值'N'
# Modify.........: No:7643 03/08/25 By Mandy 新增 aimi100料號時應default ima30=料件建立日期,以便循環盤點機制
# Modify.........: 04/07/19 By Wiky Bugno.MOD-470041 修改INSERT INTO...
# Modify.........: No.MOD-4B0254 04/11/25 By Smapmin 增加ima33(最新售價)欄位
# Modify.........: No.FUN-4C0006 04/12/03 By Carol 單價/金額欄位放大(20),位數改為dec(20,6)
# Modify.........: No.FUN-4C0057 04/12/09 By Carol Q,U,R 加入權限控管處理
# Modify.........: NO.FUN-4C0096 05/01/06 By Carol 修改報表架構轉XML
# Modify.........: No.MOD-550085 05/05/16 By pengu 無法正確顯示附圖
# Modify.........: No.FUN-560119 05/06/20 By saki 料件編號長度限制
# Modify.........: NO.MOD-570255 05/08/03 By Yiting 預測料號應該要存在於料件主檔
# Modify.........: NO.MOD-590155 05/09/13 BY yiting axmi121 可以新增料件，不過預測料件過不去(預設應與料號相同，並檢查存在料號主檔即可)。
# Modify.........: NO.MOD-5C0001 05/12/05 By Nicola 料件有異動資料不可修改庫存單位
# Modify.........: No.TQC-5B0212 05/12/27 By kevin 結束位置調整
# Modify.........: No.MOD-5C0169 06/01/03 By Nicola 產品序號是否為固定長度(ima145),不管欄位值為'Y','N' 或空白,畫面一直呈現勾選狀態
# Modify.........: No.FUN-610045 06/01/13 By Sarah 額外品名增加顯示行序(imc03)
# Modify.........: No.FUN-610046 06/01/18 By Sarah 主要分群碼(ima06)應可自動帶出其它欄位之預設值(ref aimi100)
# Modify.........: No.FUN-610013 06/03/23 By Tracy 加狀態碼
# Modify.........: No.FUN-640010 06/04/08 By Tracy 增加分銷功能 
# Modify.........: No.FUN-640202 06/04/19 By Tracy 畫面調整 
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.TQC-650066 06/05/16 By Claire ima79 mark
# Modify.........: No.FUN-660167 06/06/23 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/21 By bnlent 新增費用科目二欄位
# Modify.........: No.FUN-680137 06/09/05 By flowld 欄位型態定義,改為LIKE
# Modify.........: NO.FUN-680129 06/09/15 by rainy 多單位且為母子單位時，銷售單位=庫存單位且不能修改
# Modify.........: No.FUN-690025 06/10/05 By jamie 改判斷狀況碼ima1010
# Modify.........: No.FUN-6A0020 06/10/16 By jamie 1.FUNCTION i121()_q 一開始應清空g_ima.ima01的值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0094 06/11/01 By yjkhero l_time轉g_time 
# Modify.........: No.TQC-6B0056 06/11/14 By Ray 修正無效資料仍可更改
# Modify.........: No.FUN-6B0055 06/11/15 By Mandy (1):當參數設定使用料件申請作業時,此作業不可新增料件.修改時,也不可更改料件/品名/規格
#                                                  (2):新增料件時,狀況碼為0:開立,有效碼為P:Processing
# Modify.........: No.TQC-720065 07/03/01 By Judy 資料審核仍可修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-730018 07/03/26 By kim 行業別架構
# Modify.........: No.FUN-730057 07/03/28 By hongmei 會計科目加帳套
# Modify.........: No.MOD-740024 07/04/10 By Judy mark#TQC-720065
# Modify.........: No.TQC-740137 07/04/21 By Carrier 打印時加一個有效標志位
# Modify.........: No.TQC-740235 07/04/23 By chenl   復制時，將nmaacti狀態改為p
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-710051 07/06/07 By jamie 將ima21欄位放大至11
# Modify.........: No.MOD-7A0050 07/10/11 By Carol 母子單位不允許修改銷售單位對庫存單位的轉換率
# Modify.........: No.MOD-780061 07/10/17 By pengu INSERT ima_file時ima911欄位未default值
# Modify.........: No.CHI-7B0023/CHI-7B0039 07/11/14 By kim 移除GP5.0行業別功能的所有程式段
# Modify.........: No.FUN-7C0043 07/12/25 By destiny 報表改為p_query輸出 
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-7B0018 08/03/04 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/04 By hellen 將imaicd_file變成icd專用
# Modify.........: No.FUN-840042 08/04/11 By TSD.Wind 自定義欄位功能修改
# Modify.........: No.FUN-840194 08/06/25 By sherry 增加變動前置時間批量（ima061）
# Modify.........: No.FUN-870101 08/08/19 By jamie MES整合
# Modify.........: No.MOD-880165 08/08/21 By Smapmin 修改完主要分群碼後,相關欄位並沒有update
# Modify.........: No.MOD-890031 08/09/03 By Smapmin 新增時,依照分群碼帶出預設值時,並沒有預設ima905
# Modify.........: No.TQC-8A0011 08/10/01 By sherry MES整合
# Modify.........: No.FUN-870100 09/06/09 By lala  add ima154,155
# Modify.........: No.MOD-960172 09/06/19 By Carrier insert ima_file前對ima918/ima919/ima921/ima922做賦值
# Modify.........: No.MOD-960003 09/07/07 By Smapmin 拿掉無效功能
# Modify.........: No.FUN-980010 09/08/21 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980225 09/08/25 By lilingyu mark掉新增時產品編號的開窗功能
# Modify.........: No.TQC-980226 09/08/26 By lilingyu 價格及成本頁簽"基本利潤率 本幣稅前定價 本幣含稅定價"負數無控管
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-9A0058 09/10/13 By lilingyu 銷售單位/庫存單位換算率欄位,異動資料時應控管不可修改
# Modify.........: No.FUN-9B0025 09/12/09 By cockroach PASS NO.
# Modify.........: No.MOD-9C0178 09/12/18 By sabrina 主要分群碼/庫存單位欄位不應可修改 
# Modify.........: No.MOD-9C0199 09/12/19 By Cockroach 非零售業態別不用ima154,ima155
# Modify.........: No:FUN-9C0071 10/01/06 By huangrh 精簡程式
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A50011 10/07/12 By yangfeng 添加aimi100中對子料件的更新
# Modify.........: No:MOD-A70099 10/07/27 By Smapmin 修改單頭時,資料更改者/最近修改日update錯誤
# Modify.........: No.FUN-A60075 10/07/30 By suncx 添加報表打印字段本幣稅前定價、本幣稅後定價、平均售價、最近售價
# Modify.........: No.TQC-A90034 10/09/15 By lilingyu 庫存單位無法錄入
# Modify.........: No:FUN-A80150 10/09/20 By sabrina 在insert into ima_file之前，當ima156/ima158為null時要給"N"值
# Modify.........: No.FUN-A90049 10/09/25 By vealxu 1.只能允許查詢料件性質(ima120)='1' (企業料號')
#                                                   2.程式中如有  INSERT INTO ima_file 時料件性質(ima120)值給'1'(企業料號) 
# Modify.........: No.FUN-A90049 10/09/27 By lixh1  1.產品特性分群頁籤(當業態 azw04 = '2' 經銷時才會出現)調整
#                                                   2.新增/修改狀態下，當 ima01 Key值重複，且為商戶編號( ima120='2') 時，給出錯誤提示
# Modify.........: No.FUN-AA0014 10/10/06 By Nicola 預設ima927
# Modify.........: No.FUN-AB0011 10/11/01 By lixh1  相關BUG修正
# Modify.........: No.TQC-AB0195 10/11/28 By chenying 修改ima1321 費用科目二控管
# Modify.........: No.TQC-AC0059 10/12/07 By houlia 修改ima1004、ima1005、ima1006、ima1007、ima1008、ima1009的報錯信息
# Modify.........: No.MOD-AC0160 10/12/18 By chenying mark 單號FUN-A50011
# Modify.........: No.MOD-AC0197 10/12/18 By vealxu 如果只能從aimi100新增，那請把aimi121新增的功能mark掉
# Modify.........: No:TQC-AC0306 10/12/22 By wangxin 資料確認存檔時，若ima135產品條碼字段值有新增值時，應自動按當前條碼資料與銷售單位自動insert一筆資料到產品條碼檔， 
# Modify.........: No.FUN-B10048 11/01/20 By zhangll AFTER FIELD 科目时开窗自动过滤
# Modify.........: No.TQC-B30035 11/03/03 By zhangll 查詢狀態下開放欄位輸入條件
# Modify.........: No.TQC-B50003 11/05/03 By lixia 產品條碼增加管控
# Modify.........: No:FUN-B40071 11/05/09 by jason 已傳POS否狀態調整
# Modify.........: No.FUN-B50064 11/06/03 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B90103 11/10/11 By xjll   增加服飾頁簽記錄特性 
# Modify.........: No.FUN-B80032 11/10/31 By nanbing ima_file 更新揮寫rtepos           
# Modify.........: No:FUN-BB0086 12/01/16 By tanxc 增加數量欄位小數取位   
# Modify.........: No.FUN-B90049 12/02/01 By nanbing 取消rtapos                                        
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:FUN-C20065 12/02/10 By lixh1 在insert into ima_file之前，當ima159為null時要給'3'
# Modify.........: No.TQC-C20131 12/02/13 By zhuhao 在insert into ima_file之前給ima928賦值
# Modify.........: No.TQC-C20418 12/03/03 By huangrh 設計年份不能大於銷售年份
# Modify.........: No.MOD-C30104 12/03/07 By lixiang 子料件開放ima18可供修改
# Modify.........: No.MOD-C30270 12/03/10 By lixiang 子料件開放ima18可供修改加上azw04 = '2'的條件
# Modify.........: No:FUN-C50036 12/05/21 By yangxf 新增ima160字段，给预设值
# Modify.........: No:FUN-C60021 12/06/15 By qiaozy imaslk11賦值
# Modify.........: No:FUN-D40001 13/04/17 By xumm 调整条码检查逻辑
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_ima                RECORD LIKE ima_file.*,
       g_ima_t              RECORD LIKE ima_file.*,
       g_ima_o              RECORD LIKE ima_file.*,   #MOD-880165
       g_ima01_t            LIKE ima_file.ima01,
       g_sw                 LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
       g_wc,g_sql           STRING,  #No.FUN-580092 HCN
       g_buf                LIKE ima_file.ima01,      # No.FUN-680137 VARCHAR(40),
       g_argv1              LIKE ima_file.ima01
DEFINE p_row,p_col          LIKE type_file.num5        # No.FUN-680137 SMALLINT
DEFINE g_forupd_sql         STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5        # No.FUN-680137 SMALLINT
DEFINE g_cnt                LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE g_i                  LIKE type_file.num5        # No.FUN-680137 SMALLINT   #count/index for any purpose
DEFINE g_msg                LIKE type_file.chr1000     # No.FUN-680137 VARCHAR(72)
DEFINE i                    LIKE type_file.num5        # No.FUN-680137 SMALLINT
DEFINE g_row_count          LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE g_curs_index         LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE g_jump               LIKE type_file.num10       # No.FUN-680137 INTEGER
DEFINE mi_no_ask            LIKE type_file.num5        # No.FUN-680137 SMALLINT
DEFINE l_ac                 LIKE type_file.num5        # No.FUN-680137 SMALLINT   #FUN-610045   #目前處理的ARRAY CNT
DEFINE g_chr                LIKE type_file.chr1        # No.FUN-6B0055
DEFINE g_chr2               LIKE type_file.chr1        # No.FUN-6B0055
DEFINE g_imaslk             RECORD LIKE imaslk_file.*,   # No.FUN-B90103
       g_imaslk_t           RECORD LIKE imaslk_file.*    # No.FUN-B90103
 
DEFINE imaud01 LIKE ima_file.imaud01,
       imaud02 LIKE ima_file.imaud02,
       imaud03 LIKE ima_file.imaud03,
       imaud04 LIKE ima_file.imaud04,
       imaud05 LIKE ima_file.imaud05,
       imaud06 LIKE ima_file.imaud06,
       imaud07 LIKE ima_file.imaud07,
       imaud08 LIKE ima_file.imaud08,
       imaud09 LIKE ima_file.imaud09,
       imaud10 LIKE ima_file.imaud10,
       imaud11 LIKE ima_file.imaud11,
       imaud12 LIKE ima_file.imaud12,
       imaud13 LIKE ima_file.imaud13,
       imaud14 LIKE ima_file.imaud14,
       imaud15 LIKE ima_file.imaud15
 
MAIN
 
   DEFINE p_row,p_col      LIKE type_file.num5    # No.FUN-680137 SMALLINT
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP                      #FUN-A90049    
#      INPUT NO WRAP,                    #FUN-A90049 
#      FIELD ORDER FORM                  #整個畫面會依照p_per所設定的欄位順序(忽略4gl寫的順序)  #FUN-730018  #FUN-A90049 mark
 
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

  #FUN-B90103--start--
   IF s_industry("slk") THEN
      UPDATE zz_file SET zz13='N' WHERE zz01=g_prog
   END IF
  #FUN-B90103--end--
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1 = ARG_VAL(1)
   IF p_row = 0 OR p_row IS NULL THEN           # 螢墓位置
      LET p_row = 2
      LET p_col = 2
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
   INITIALIZE g_ima.* TO NULL
 
   LET g_forupd_sql = "SELECT * FROM ima_file WHERE ima01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i121_cl CURSOR FROM g_forupd_sql
 
   LET p_row = 1 LET p_col = 9
 
   OPEN WINDOW i121_w AT p_row,p_col
     WITH FORM "axm/42f/axmi121"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
  #FUN-B90103--start--
   IF NOT s_industry("slk") THEN
      CALL cl_set_comp_visible("Page1",FALSE)
   END IF
  #FUN-B90103--end--
   CALL cl_set_comp_visible("ima1321",g_aza.aza63 ='Y')   #No.FUN-680034
   IF g_aza.aza50='N' THEN
      CALL cl_set_comp_visible("ima1010,page07",FALSE)      #FUN-9B0025 ADD   
   ELSE
      CALL cl_set_comp_visible("ima1010,page07",TRUE)       #FUN-9B0025 ADD 
   END IF   
   IF g_aza.aza50='Y' OR g_azw.azw04='2' THEN
   	  CALL cl_set_comp_visible("page06",TRUE)
   ELSE
   	  CALL cl_set_comp_visible("page06",FALSE)   
   END IF
   IF g_azw.azw04='2' THEN
      CALL cl_set_comp_visible("ima154,ima155",TRUE)
   ELSE
      CALL cl_set_comp_visible("ima154,ima155",FALSE)   
   END IF

   IF NOT cl_null(g_argv1) THEN
      CALL i121_q()
   END IF
 
   LET g_action_choice=""
 
   CALL i121_menu()
 
   CLOSE WINDOW i121_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818 #NO.FUN-6A0094
 
END MAIN
 
FUNCTION i121_curs()
 
   CLEAR FORM
   IF cl_null(g_argv1) THEN
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
   INITIALIZE g_imaslk.* TO NULL #FUN-B90103
       CONSTRUCT BY NAME g_wc ON
        ima01,ima02,ima021,
        ima08,ima06,ima05,
        ima25,ima31,ima31_fac,ima03,ima04,
        ima1010,         #No.FUN-610013
        imauser,imagrup,imaoriu,imaorig,imamodu,imadate,imaacti,  #Mod No.TQC-B30035 add imaoriu,imaorig
        ima1005,ima1006,ima1004,ima1007,ima1008,ima1009,#No.FUN-640010
        ima130,ima131,ima09,ima10,
        ima11,ima18,ima134,ima154,ima155,ima133,ima132,ima1321,       #No.FUN-680034  #FUN-870100
        ima138,ima148,ima35,ima36,
        ima121,ima122,ima123,ima124,ima125,
        ima126,ima127,ima128,ima98,ima33,      #MOD-4B0254
        ima135,ima141,ima142,ima143,ima144,ima145,
        imaslk05,imaslk06,imaslk07,imaslk08,   #FUN-B90103
        imaslk10,imaslk09,imaslk11,imaslk01,   #FUN-B90103
        imaslk02,imaslk03,imaslk04,            #FUN-B90103
        ima1024,ima1025,ima1026,ima1028,ima1027,   #No.FUN-640010
        ima1019,ima1020,ima1021,ima1023,ima1022,   #No.FUN-640010
        ima1017,ima1018,                           #No.FUN-640010
        imaud01,imaud02,imaud03,imaud04,imaud05,
        imaud06,imaud07,imaud08,imaud09,imaud10,
        imaud11,imaud12,imaud13,imaud14,imaud15
 
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
         ON ACTION controlp
            CASE
               WHEN INFIELD(ima01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_ima"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima01
                    NEXT FIELD ima01
               WHEN INFIELD(ima133)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_ima"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima133
                    NEXT FIELD ima133
 
               WHEN INFIELD(ima25)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima25
                    NEXT FIELD ima25
               WHEN INFIELD(ima31)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_gfe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima31
                    NEXT FIELD ima31
               WHEN INFIELD(ima1004)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="1"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima1004
                    NEXT FIELD ima1004
               WHEN INFIELD(ima1005)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="2"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima1005
                    NEXT FIELD ima1005
               WHEN INFIELD(ima1006)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="3"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima1006
                    NEXT FIELD ima1006
               WHEN INFIELD(ima1007)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="4"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima1007
                    NEXT FIELD ima1007
               WHEN INFIELD(ima1008)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="5"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima1008
                    NEXT FIELD ima1008
               WHEN INFIELD(ima1009)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_tqa"
                    LET g_qryparam.arg1 ="6"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima1009
                    NEXT FIELD ima1009
               WHEN INFIELD(ima132)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_aag"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima132
                    NEXT FIELD ima132
              WHEN INFIELD(ima1321)                                                                                                 
                    CALL cl_init_qry_var()                                                                                          
                    LET g_qryparam.state = "c"                                                                                      
                    LET g_qryparam.form ="q_aag"           
                    CALL cl_create_qry() RETURNING g_qryparam.multiret                                                              
                    DISPLAY g_qryparam.multiret TO ima1321                                                                           
                    NEXT FIELD ima1321  
               WHEN INFIELD(ima134)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_obe"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima134
                    NEXT FIELD ima134
               WHEN INFIELD(ima131)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_oba"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima131
                    NEXT FIELD ima131
               WHEN INFIELD(ima06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_imz"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima06
                    NEXT FIELD ima06
               WHEN INFIELD(ima09)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = 'D'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima09
                    NEXT FIELD ima09
               WHEN INFIELD(ima10)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = 'E'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima10
                    NEXT FIELD ima10
               WHEN INFIELD(ima11)
                    CALL cl_init_qry_var()
                    LET g_qryparam.state = "c"
                    LET g_qryparam.form ="q_azf"
                    LET g_qryparam.arg1 = 'F'
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima11
                    NEXT FIELD ima11
             END CASE
 
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
   ELSE                      
      LET g_wc = "ima01 ='",g_argv1,"'"
   END IF
 
   IF INT_FLAG THEN RETURN END IF
 
 LET g_sql="SELECT ima01 FROM ima_file ", # 組合出 SQL 指令
            #" WHERE ",g_wc CLIPPED, " ORDER BY ima01"                           #FUN-A90049 mark
             " WHERE ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED, " ORDER BY ima01"          #FUN-A90049 add
#FUN-B90103--start--
  IF s_industry('slk') THEN   
    IF g_wc.getindexof('imaslk',1)>0 THEN
       LET g_sql = "SELECT ima_file.ima01 FROM ima_file,imaslk_file ", # 組合出 SQL 指令
                  " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ima01=imaslk00 AND ",g_wc CLIPPED, 
                  " ORDER BY ima01"
    END IF
  END IF
#FUN-B90103--end--
   PREPARE i121_prepare FROM g_sql           # RUNTIME 編譯
   DECLARE i121_cs                         # SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i121_prepare

#  LET g_sql= "SELECT COUNT(*) FROM ima_file WHERE ",g_wc CLIPPED                   #FUN-A90049 mark
   LET g_sql= "SELECT COUNT(*) FROM ima_file WHERE  ( ima120 = '1' OR ima120 = ' ' OR ima120 IS NULL ) AND ",g_wc CLIPPED  #FUN-A90049 add
#FUN-B90103--start--
  IF s_industry('slk') THEN
   IF g_wc.getindexof('imaslk',1)>0 THEN
      LET g_sql= "SELECT COUNT(*) FROM ima_file,imaslk_file",
                 " WHERE ( ima120 IS NULL OR ima120 = ' ' OR ima120 = '1' ) AND ima01=imaslk00 AND ",g_wc CLIPPED  
   END IF
  END IF
#FUN-B90103--end--

   PREPARE i121_precount FROM g_sql
   DECLARE i121_count CURSOR FOR i121_precount
 
END FUNCTION
 
FUNCTION i121_menu()
   MENU ""
      BEFORE MENU
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
     #MOD-AC0197-------------mark start-------------------
     #ON ACTION insert
     #   LET g_action_choice="insert"
     #   IF g_aza.aza60 = 'N' THEN #不使用客戶申請作業時,才可按新增!
     #       IF cl_chk_act_auth() THEN    #cl_prichk('A') THEN
     #            CALL i121_a()
     #       END IF
     #   ELSE
     #       CALL cl_err('','aim-152',1)
     #       #不使用客戶申請作業時,才可按新增!
     #   END IF
     #MOD-AC0197-------------mark end-------------------------
 
      ON ACTION query
         LET g_action_choice="query"
         IF cl_chk_act_auth() THEN
            CALL i121_q()
         END IF
 
      ON ACTION next
         CALL i121_fetch('N')
 
      ON ACTION previous
         CALL i121_fetch('P')
 
      ON ACTION modify
         LET g_action_choice="modify"
         IF cl_chk_act_auth() THEN
            CALL i121_u()
         END IF
 
#@    ON ACTION 額外品名
      ON ACTION extra_p_n
         LET g_action_choice="extra_p_n"
         IF cl_chk_act_auth() THEN
            CALL i121_m()
#FUN-B90103--start
           IF s_industry("slk") THEN
              CALL i121_imc_ins() 
           END IF
#FUN-B90103--end--
         END IF
 
#@    ON ACTION 單位換算 LET g_msg='aooi103 ',g_ima.ima01
      ON ACTION unit_conversion
         LET g_msg='aooi103 ',g_ima.ima01
         CALL cl_cmdrun(g_msg)
 
      ON ACTION output
         LET g_action_choice="output"
         IF cl_chk_act_auth() THEN
            CALL i121_out()
         END IF
 
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         IF cl_chk_act_auth() THEN
            CALL i121_copy()
         END IF
 
      ON ACTION help
          CALL cl_show_help()
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #EXIT MENU
         #圖形顯示
         CALL cl_set_field_pic("","","","","",g_ima.imaacti)
 
      ON ACTION exit
         LET g_action_choice = "exit"
         EXIT MENU
 
      ON ACTION jump
         CALL i121_fetch('/')
 
      ON ACTION first
         CALL i121_fetch('F')
 
      ON ACTION last
         CALL i121_fetch('L')
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document             #相關文件"                        
       LET g_action_choice="related_document"           
          IF cl_chk_act_auth() THEN                     
             IF g_ima.ima01 IS NOT NULL THEN            
                LET g_doc.column1 = "ima01"               
                LET g_doc.value1 = g_ima.ima01            
                CALL cl_doc()                             
             END IF                                        
          END IF                                           
          LET g_action_choice = "exit"
        CONTINUE MENU
 
      -- for Windows close event trapped
      ON ACTION close   #COMMAND KEY(INTERRUPT) #FUN-9B0145  
          LET INT_FLAG=FALSE                 #MOD-570244 mars
          LET g_action_choice = "exit"
          EXIT MENU
 
      &include "qry_string.4gl"
   END MENU
 
   CLOSE i121_cs
 
END FUNCTION
 
FUNCTION ima_default()
 
   LET g_ima.ima07 = 'A'
   LET g_ima.ima08 = 'M'
   LET g_ima.ima108='N'
   LET g_ima.ima14 = 'N'
   LET g_ima.ima15 = 'N'
   LET g_ima.ima16 = 99
   LET g_ima.ima18 = 0
   LET g_ima.ima09 = ' '
   LET g_ima.ima10 = ' '
   LET g_ima.ima11 = ' '
   LET g_ima.ima23 = ' '
   LET g_ima.ima24 = 'N'
  #FUN-A20044,BEGIN
  # LET g_ima.ima26 = 0
  # LET g_ima.ima261 = 0
  # LET g_ima.ima262 = 0
  #FUN-A20044,END
   LET g_ima.ima27 = 0
   LET g_ima.ima271 = 0
   LET g_ima.ima28 = 0
   LET g_ima.ima30= g_today    #No:7643 新增 aimi100料號時應default ima30=料件建立日期,以便循環盤點機制
   LET g_ima.ima31_fac = 1
   LET g_ima.ima32 = 0
   LET g_ima.ima33 = 0      #MOD-4B0254
   LET g_ima.ima37 = '0'
   LET g_ima.ima38 = 0
   LET g_ima.ima40 = 0
   LET g_ima.ima41 = 0
   LET g_ima.ima42 = '0'
   LET g_ima.ima44_fac = 1
   LET g_ima.ima45 = 0
   LET g_ima.ima46 = 0
   LET g_ima.ima47 = 0
   LET g_ima.ima48 = 0
   LET g_ima.ima49 = 0
   LET g_ima.ima491 = 0
   LET g_ima.ima50 = 0
   LET g_ima.ima51 = 1
   LET g_ima.ima52 = 1
   LET g_ima.ima140='N'
   LET g_ima.ima53 = 0
   LET g_ima.ima531 = 0
   LET g_ima.ima55_fac = 1
   LET g_ima.ima56 = 1
   LET g_ima.ima561 = 1  #最少生產數量
   LET g_ima.ima562 = 0  #生產時損耗率
   LET g_ima.ima57 = 0
   LET g_ima.ima58 = 0
   LET g_ima.ima59 = 0
   LET g_ima.ima60 = 0
   LET g_ima.ima61 = 0
   LET g_ima.ima62 = 0
   LET g_ima.ima63_fac = 1
   LET g_ima.ima64 = 0
   LET g_ima.ima641 = 0   #最少發料數量
   LET g_ima.ima65 = 0
   LET g_ima.ima66 = 0
   LET g_ima.ima68 = 0
   LET g_ima.ima69 = 0
   LET g_ima.ima70 = 'N'
   LET g_ima.ima107='N'
   LET g_ima.ima71 = 0
   LET g_ima.ima72 = 0
   LET g_ima.ima75 = ''
   LET g_ima.ima76 = ''
   LET g_ima.ima77 = 0
   LET g_ima.ima78 = 0
   LET g_ima.ima80 = 0
   LET g_ima.ima81 = 0
   LET g_ima.ima82 = 0
   LET g_ima.ima83 = 0
   LET g_ima.ima84 = 0
   LET g_ima.ima85 = 0
   LET g_ima.ima852= 'N'
   LET g_ima.ima853= 'N'
   LET g_ima.ima86_fac = 1
   LET g_ima.ima871 = 0
   LET g_ima.ima873 = 0
   LET g_ima.ima88 = 1
   LET g_ima.ima91 = 0
   LET g_ima.ima92 = 'N'
   LET g_ima.ima93 = "NNNNNNNN"
   LET g_ima.ima94 = ' '
   LET g_ima.ima95 = 0
   LET g_ima.ima96 = 0
   LET g_ima.ima97 = 0
   LET g_ima.ima98 = 0
   LET g_ima.ima33 = 0        #MOD-4B0254
   LET g_ima.ima99 = 0
   LET g_ima.ima100 = 'N'
   LET g_ima.ima101 ='1'
   LET g_ima.ima102 = '1'
   LET g_ima.ima103 = '0'
   LET g_ima.ima104 = '0'
   LET g_ima.ima105 = 'N'
   LET g_ima.ima110 = '1'
   LET g_ima.ima139 = 'N'
   LET g_ima.ima154 = 'N'  #FUN-870100
   LET g_ima.ima155 = 'N'  #FUN-870100
   LET g_ima.ima901 = g_today
   LET g_ima.imauser = g_user
   LET g_ima.imaoriu = g_user #FUN-980030
   LET g_ima.imaorig = g_grup #FUN-980030
   LET g_ima.imadate = g_today
   LET g_ima.imagrup = g_grup
  #新增料件時,狀況碼為0:開立,有效碼為P:Processing
   LET g_ima.imaacti = 'P' 
#產品資料
   LET g_ima.ima130 = '1'
   LET g_ima.ima121 = 0
   LET g_ima.ima122 = 0
   LET g_ima.ima123 = 0
   LET g_ima.ima124 = 0
   LET g_ima.ima125 = 0
   LET g_ima.ima126 = 0
   LET g_ima.ima127 = 0
   LET g_ima.ima128 = 0
   LET g_ima.ima129 = 0
   LET g_ima.ima141 = '0'
   LET g_ima.ima145 = 'N'
   LET g_ima.ima148 = 0   #MOD-4A0101
   LET g_ima.ima1017 = 0                                                                                                            
   LET g_ima.ima1018 = 0       
   LET g_ima.ima1010= '0' #No.FUN-610013     #No.FUN-690025 
 
END FUNCTION
 
#MOD-AC0197-------------mark start----------------------------------
#FUNCTION i121_a()
#  DEFINE l_imaicd   RECORD LIKE imaicd_file.* #No.FUN-7B0018
#
#  MESSAGE ""
#  IF s_shut(0) THEN RETURN END IF
#  CLEAR FORM
#  INITIALIZE g_ima.* TO NULL
#  CALL ima_default()
#  LET g_ima01_t = NULL
#
# #預設值及將數值變數清成零
#  LET g_ima_t.* = g_ima.*   #FUN-870101 add
#  LET g_ima_o.* = g_ima.*   #FUN-870101 add
#  CALL cl_opmsg('a')
#
#  WHILE TRUE
#     CALL i121_i("a")                      # 各欄位輸入
#
#     IF INT_FLAG THEN                         # 若按了DEL鍵
#        INITIALIZE g_ima.* TO NULL
#        LET INT_FLAG = 0
#        CALL cl_err('',9001,0)
#        CLEAR FORM
#        EXIT WHILE
#     END IF
#
#     IF g_ima.ima01 IS NULL THEN                # KEY 不可空白
#        CONTINUE WHILE
#     END IF
#
#     LET g_ima.ima911 = 'N'    #No.MOD-780061 add
#     LET g_ima.ima601 = 1      #No.FUN-840194 
#
#     LET g_ima.ima915 = '0'      
#     LET g_ima.ima916 = ' '      
#     LET g_ima.ima150 = ' '              
#     LET g_ima.ima151 = ' '                   
#     LET g_ima.ima152 = ' '                   
#    IF cl_null(g_ima.ima918) THEN LET g_ima.ima918 = 'N' END IF
#    IF cl_null(g_ima.ima919) THEN LET g_ima.ima919 = 'N' END IF
#    IF cl_null(g_ima.ima921) THEN LET g_ima.ima921 = 'N' END IF
#    IF cl_null(g_ima.ima922) THEN LET g_ima.ima922 = 'N' END IF
#    IF cl_null(g_ima.ima924) THEN LET g_ima.ima924 = 'N' END IF
#    IF cl_null(g_ima.ima926) THEN LET g_ima.ima926 = 'N' END IF
#    LET g_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
#    LET g_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
#    LET g_ima.ima120 = '1'          #No.FUN-A90049 add  
#
##TQC-A90034 --begin--
#    IF cl_null(g_ima.ima022) THEN LET g_ima.ima022  = 0 END IF 
#    IF cl_null(g_ima.ima156) THEN LET g_ima.ima156  = 'N' END IF 
#    IF cl_null(g_ima.ima158) THEN LET g_ima.ima158  = 'N' END IF 
#    IF cl_null(g_ima.ima927) THEN LET g_ima.ima927  = 'N' END IF 
##TQC-A90034 --end--

#    #FUN-A80150---add---start---
#     IF cl_null(g_ima.ima156) THEN 
#        LET g_ima.ima156 = 'N'
#     END IF
#     IF cl_null(g_ima.ima158) THEN 
#        LET g_ima.ima158 = 'N'
#     END IF
#    #FUN-A80150---add---end---
#     INSERT INTO ima_file VALUES(g_ima.*)
#     IF SQLCA.sqlcode THEN
#        CALL cl_err3("ins","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
#        CONTINUE WHILE
#     ELSE
#        IF s_industry('icd') THEN
#           INITIALIZE l_imaicd.* TO NULL
#           LET l_imaicd.imaicd00 = g_ima.ima01
#           IF NOT s_ins_imaicd(l_imaicd.*,'') THEN
#              CONTINUE WHILE
#           END IF
#        END IF
#
#        LET g_ima_t.* = g_ima.*                # 保存上筆資料
#        SELECT ima01 INTO g_ima.ima01 FROM ima_file
#         WHERE ima01 = g_ima.ima01
#     END IF
#     EXIT WHILE
#  END WHILE
#
#END FUNCTION
##MOD-AC0197-------------mark end----------------------------------- 

FUNCTION i121_i(p_cmd)
   DEFINE p_cmd          LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),
          l_flag         LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),
          l_smd          RECORD LIKE smd_file.*,
          l_ima31_fac    LIKE pml_file.pml09,        # No.FUN-680137 DECIMAL(16,8),        #No.FUN-640010  
          l_n            LIKE type_file.num5         # No.FUN-680137 SMALLINT
   DEFINE lc_sma119      LIKE sma_file.sma119,       #No.FUN-560119
          li_len         LIKE type_file.num5,        # No.FUN-680137 SMALLINT,
          l_cnt          LIKE type_file.num5,        # No.FUN-680137 SMALLINT
          li_result      LIKE type_file.num5
   DEFINE l_oba14        LIKE oba_file.oba14         #NO.FUN-870100
   DEFINE l_ima120       LIKE ima_file.ima120        #FUN-A90049
#FUN-C60021---ADD----STR---
   DEFINE l_ima151 LIKE ima_file.ima151
   DEFINE l_ima940 LIKE ima_file.ima940
   DEFINE l_agd03  LIKE agd_file.agd03
   DEFINE l_imaag  LIKE ima_file.imaag
   DEFINE l_imx00  LIKE imx_file.imx00
#FUN-C60021---ADD----END----   
 
   SELECT sma119 INTO lc_sma119 FROM sma_file
   CASE lc_sma119
      WHEN "0"
         LET li_len = 20
      WHEN "1"
         LET li_len = 30
      WHEN "2"
         LET li_len = 40
   END CASE
 
   INPUT BY NAME g_ima.imaoriu,g_ima.imaorig,
        g_ima.ima01,g_ima.ima02,g_ima.ima021,
        g_ima.ima08,
        g_ima.ima06,                                          #FUN-610046
        g_ima.ima05,g_ima.ima25,g_ima.ima31,g_ima.ima31_fac,
        g_ima.ima03, #g_ima.ima04,
        g_ima.ima1005,g_ima.ima1006,g_ima.ima1004,   #No.FUN-640010   #FUN-AB0011 相關欄位調整                                                                             
        g_ima.ima1007,g_ima.ima1008,g_ima.ima1009,   #No.FUN-640010   
        g_ima.ima130,g_ima.ima131,g_ima.ima09,                #FUN-610046
        g_ima.ima10 ,g_ima.ima11 ,
        g_ima.ima18,g_ima.ima134,g_ima.ima154,g_ima.ima155,  #FUN-870100
        g_ima.ima133,g_ima.ima132,g_ima.ima1321,g_ima.ima138,g_ima.ima148, #No.FUN-680034
        g_ima.ima35,g_ima.ima36,
        g_ima.ima121,g_ima.ima122,g_ima.ima123,g_ima.ima124,g_ima.ima125,
        g_ima.ima126,g_ima.ima127,g_ima.ima128,g_ima.ima98,g_ima.ima33,    #MOD-4B0254
        g_ima.ima135,g_ima.ima141,g_ima.ima142,g_ima.ima143,
        g_ima.ima144,
        g_ima.ima145,
        g_imaslk.imaslk05,g_imaslk.imaslk06,g_imaslk.imaslk07,g_imaslk.imaslk08,   #FUN-B90103
        g_imaslk.imaslk10,g_imaslk.imaslk09,g_imaslk.imaslk11,g_imaslk.imaslk01,   #FUN-B90103
        g_imaslk.imaslk02,g_imaslk.imaslk03,g_imaslk.imaslk04,                     #FUN-B90103
        g_ima.ima1024,g_ima.ima1025,g_ima.ima1026,g_ima.ima1028,g_ima.ima1027, #No.FUN-640010                                                    
        g_ima.ima1019,g_ima.ima1020,g_ima.ima1021,g_ima.ima1023,g_ima.ima1022, #No.FUN-640010 
        g_ima.ima1017,g_ima.ima1018,   #No.FUN-640010 
        g_ima.imauser,g_ima.imagrup,g_ima.imamodu,g_ima.imadate,g_ima.imaacti,
        g_ima.imaud01,g_ima.imaud02,g_ima.imaud03,g_ima.imaud04,g_ima.imaud05,
        g_ima.imaud06,g_ima.imaud07,g_ima.imaud08,g_ima.imaud09,g_ima.imaud10,
        g_ima.imaud11,g_ima.imaud12,g_ima.imaud13,g_ima.imaud14,g_ima.imaud15
 
       WITHOUT DEFAULTS
 
       BEFORE INPUT
          LET g_before_input_done = FALSE
          CALL i121_set_entry(p_cmd)
          CALL i121_set_no_entry(p_cmd)
          LET g_before_input_done = TRUE
          CALL cl_chg_comp_att("ima01","WIDTH|GRIDWIDTH|SCROLL",li_len || "|" || li_len || "|0")
          #FUN-B90103--start--
          IF s_industry("slk") THEN
             IF cl_null(g_imaslk.imaslk01) THEN 
                LET g_imaslk.imaslk01='N'
             END IF
             IF cl_null(g_imaslk.imaslk02) THEN
                LET g_imaslk.imaslk02='N'
             END IF
             IF cl_null(g_imaslk.imaslk03) THEN
                LET g_imaslk.imaslk03='N'
             END IF
             IF cl_null(g_imaslk.imaslk04) THEN
                LET g_imaslk.imaslk04='N'
             END IF
             IF cl_null(g_imaslk.imaslk09) THEN
                LET g_imaslk.imaslk09=g_today
             END IF
          END IF
          #FUN-B90103--end--
 
       AFTER FIELD ima01
          IF NOT cl_null(g_ima.ima01) THEN
             IF cl_null(g_ima_t.ima01) OR         # 若輸入或更改且改KEY
               (p_cmd = "u" AND g_ima.ima01 != g_ima_t.ima01) THEN
                SELECT count(*) INTO l_n FROM ima_file
                 WHERE ima01 = g_ima.ima01
                IF l_n > 0 THEN                  # Duplicated
#FUN-A90049 --Begin--
                   SELECT ima120 INTO l_ima120 FROM ima_file
                    WHERE  ima01 = g_ima.ima01
                   IF l_ima120 = '2' THEN
                      CALL cl_err(g_ima.ima01,'axm_608',0)  
                   END IF
#FUN-A90049 --End--                
                 #  CALL cl_err(g_ima.ima01,-239,0)   #FUN-A90049
                   LET g_ima.ima01 = g_ima_t.ima01
                   DISPLAY BY NAME g_ima.ima01
                   NEXT FIELD ima01
                END IF
             END IF
             IF g_ima.ima01[1,4]='MISC' THEN
                LET g_ima.ima130='2'
                DISPLAY BY NAME g_ima.ima130
             END IF
             IF cl_null(g_ima.ima133) THEN
                LET g_ima.ima133=g_ima.ima01
                DISPLAY BY NAME g_ima.ima133
             END IF
          END IF
 
       AFTER FIELD ima08
          IF NOT cl_null(g_ima.ima08) THEN
             IF g_ima.ima08 NOT MATCHES "[CTDAMPXKUVRZS]" THEN
                NEXT FIELD ima08
             END IF
          END IF
 
       AFTER FIELD ima06
          IF NOT cl_null(g_ima.ima06) THEN
             LET g_buf = NULL
             SELECT imz02 INTO g_buf FROM imz_file WHERE imz01=g_ima.ima06
             IF STATUS THEN
                CALL cl_err3("sel","imz_file",g_ima.ima06,"",STATUS,"","sel imz",1)  #No.FUN-660167
                NEXT FIELD ima06
             END IF
             DISPLAY g_buf TO imz02
          END IF
          IF g_ima.ima06 IS NOT NULL AND  g_ima.ima06 != ' '
             THEN  #MOD-490474
             IF (g_ima_t.ima06 IS NULL) OR (g_ima.ima06 != g_ima_o.ima06) THEN   #MOD-880165
                 CALL i121_ima06('Y') #default 預設值
             ELSE
                 CALL i121_ima06('N') #只check 對錯,不詢問
             END IF #No:7062
             IF NOT cl_null(g_errno) THEN
                 CALL cl_err(g_ima.ima06,g_errno,0)
                 LET g_ima.ima06 = g_ima_t.ima06
                 DISPLAY BY NAME g_ima.ima06
                 NEXT FIELD ima06
             END IF
          END IF
          LET g_ima_o.ima06 = g_ima.ima06   #MOD-880165
 
       BEFORE FIELD ima02
          IF g_sma.sma64='Y' AND g_ima.ima02 IS NULL THEN
             CALL s_desinp(6,4,g_ima.ima02) RETURNING g_ima.ima02
          END IF
 
       AFTER FIELD ima126
         IF NOT cl_null(g_ima.ima126) THEN
           IF g_ima.ima126 < 0 THEN
              CALL cl_err('','aim-223',0)
              NEXT FIELD ima126
           END IF 
         END IF 
 
       AFTER FIELD ima127
         IF NOT cl_null(g_ima.ima127) THEN
           IF g_ima.ima127 < 0 THEN
              CALL cl_err('','aim-223',0)
              NEXT FIELD ima127
           END IF 
         END IF 
 
       AFTER FIELD ima128
         IF NOT cl_null(g_ima.ima128) THEN
           IF g_ima.ima128 < 0 THEN
              CALL cl_err('','aim-223',0)
              NEXT FIELD ima128
           END IF 
         END IF 
 
       AFTER FIELD ima25
          IF NOT cl_null(g_ima.ima25) THEN
             LET g_buf = NULL
             SELECT gfe02 INTO g_buf FROM gfe_file
              WHERE gfe01=g_ima.ima25
             IF STATUS THEN
                CALL cl_err3("sel","gfe_file",g_ima.ima25,"",STATUS,"","sel gfe",1)  #No.FUN-660167
                NEXT FIELD ima25
             END IF
 
             MESSAGE g_buf CLIPPED
             IF cl_null(g_ima.ima31) THEN LET g_ima.ima31 = g_ima.ima25 END IF
             IF cl_null(g_ima.ima44) THEN LET g_ima.ima44 = g_ima.ima25 END IF
             IF cl_null(g_ima.ima55) THEN LET g_ima.ima55 = g_ima.ima25 END IF
             IF cl_null(g_ima.ima63) THEN LET g_ima.ima63 = g_ima.ima25 END IF
             IF cl_null(g_ima.ima86) THEN LET g_ima.ima86 = g_ima.ima25 END IF
             DISPLAY BY NAME g_ima.ima31
              
            IF g_sma.sma115 = 'Y' AND g_ima.ima906 ='2' THEN
               LET g_ima.ima31 = g_ima.ima25
               DISPLAY BY NAME g_ima.ima31
            END IF
          END IF
 
       AFTER FIELD ima31_fac
          MESSAGE ''
          IF NOT cl_null(g_ima.ima31_fac) THEN
             IF g_ima.ima31_fac = 0 THEN
                NEXT FIELD ima31_fac
             END IF
 
             LET l_smd.smd01=g_ima.ima01
             LET l_smd.smd02=g_ima.ima31 LET l_smd.smd04=1
             LET l_smd.smd03=g_ima.ima25 LET l_smd.smd06=g_ima.ima31_fac
             LET l_smd.smd06 = s_digqty(l_smd.smd06,l_smd.smd03)   #No.FUN-BB0086
             LET l_smd.smdacti='Y'
 
             IF l_smd.smd02!=l_smd.smd03 THEN
                INSERT INTO smd_file VALUES(l_smd.*)
                IF STATUS THEN
                   UPDATE smd_file SET smd04=l_smd.smd04,
                                       smd06=l_smd.smd06
                    WHERE smd01=g_ima.ima01
                      AND smd02=l_smd.smd02
                      AND smd03=l_smd.smd03
                END IF
             END IF
          END IF
 
       AFTER FIELD ima31
          IF NOT cl_null(g_ima.ima31) THEN
             LET g_buf = NULL
 
             SELECT gfe02 INTO g_buf FROM gfe_file
              WHERE gfe01=g_ima.ima31 AND gfeacti IN ('Y','y')
             IF STATUS THEN
                CALL cl_err3("sel","gfe_file",g_ima.ima31,"",STATUS,"","sel gfe",1)  #No.FUN-660167
                NEXT FIELD ima31
             END IF
 
             MESSAGE g_buf CLIPPED
 
             IF g_ima.ima31 = g_ima.ima25 THEN
                LET g_ima.ima31_fac = 1
             ELSE
                CALL s_umfchk(g_ima.ima01,g_ima.ima31,g_ima.ima25)
                    RETURNING g_sw,g_ima.ima31_fac
                IF g_sw = '1' THEN
                   CALL cl_err(g_ima.ima31,'mfg1206',0)
                   DISPLAY BY NAME  g_ima.ima31
                   DISPLAY BY NAME  g_ima.ima31_fac
                   NEXT FIELD ima31
                END IF
 
                DISPLAY BY NAME g_ima.ima31_fac
             END IF
 
          END IF
 
        AFTER FIELD ima1004
            IF NOT cl_null(g_ima.ima1004) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_ima.ima1004
                  AND tqa03 = '1' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
              #   CALL cl_err('','atm-125',0)     #TQC-AC0059  --mark
                  CALL cl_err('','atm-130',0)     #TQC-AC0059  --modify
                  NEXT FIELD ima1004
               END IF
               CALL i120_ima(g_ima.ima1004,'1')
            END IF
 
        AFTER FIELD ima1005
            IF NOT cl_null(g_ima.ima1005) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_ima.ima1005
                  AND tqa03 = '2' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
                  #   CALL cl_err('','atm-125',0)     #TQC-AC0059  --mark
                  CALL cl_err('','atm-142',0)        #TQC-AC0059  --modify
                  NEXT FIELD ima1005
               END IF
               CALL i120_ima(g_ima.ima1005,'2')
            END IF
 
        AFTER FIELD ima1006
            IF NOT cl_null(g_ima.ima1006) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_ima.ima1006
                  AND tqa03 = '3' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
              #   CALL cl_err('','atm-125',0)     #TQC-AC0059  --mark
                  CALL cl_err('','atm-143',0)                   #TQC-AC0059    modify
                  NEXT FIELD ima1006
               END IF
               CALL i120_ima(g_ima.ima1006,'3')
            END IF
 
        AFTER FIELD ima1007
            IF NOT cl_null(g_ima.ima1007) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_ima.ima1007
                  AND tqa03 = '4' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
              #   CALL cl_err('','atm-125',0)     #TQC-AC0059  --mark
                  CALL cl_err('','atm-144',0)       #TQC-AC0059   --modify
                  NEXT FIELD ima1007
               END IF
               CALL i120_ima(g_ima.ima1007,'4')
            END IF
 
        AFTER FIELD ima1008
            IF NOT cl_null(g_ima.ima1008) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_ima.ima1008
                  AND tqa03 = '5' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
              #   CALL cl_err('','atm-125',0)     #TQC-AC0059  --mark
                  CALL cl_err('','atm-145',0)       #TQC-AC0059   --modify
                  NEXT FIELD ima1008
               END IF
               CALL i120_ima(g_ima.ima1008,'5')
            END IF
 
        AFTER FIELD ima1009
            IF NOT cl_null(g_ima.ima1009) THEN
               SELECT COUNT(*) INTO l_cnt FROM tqa_file
                WHERE tqa01 = g_ima.ima1009
                  AND tqa03 = '6' AND tqaacti = 'Y'
               IF l_cnt = 0 THEN
              #   CALL cl_err('','atm-125',0)     #TQC-AC0059  --mark
                  CALL cl_err('','atm-146',0)      #TQC-AC0059    --modify
                  NEXT FIELD ima1009
               END IF
               CALL i120_ima(g_ima.ima1009,'6')
            END IF                
 
        AFTER FIELD ima1024
           IF NOT cl_null(g_ima.ima1024) THEN
              IF g_ima.ima1024 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1024
              END IF
              IF NOT cl_null(g_ima.ima1025) AND
                 NOT cl_null(g_ima.ima1026) THEN
                 LET g_ima.ima1027 = g_ima.ima1024 *
                                       g_ima.ima1025 * g_ima.ima1026
                 CALL s_umfchk(g_ima.ima01,g_ima.ima31,g_ima.ima25)
                     RETURNING g_sw,l_ima31_fac
                 LET g_ima.ima1022 = g_ima.ima1027/l_ima31_fac
                 DISPLAY g_ima.ima1027 TO ima1027
                 DISPLAY g_ima.ima1022 TO ima1022
              END IF
           END IF
#FUN-B90103--start
        AFTER FIELD imaslk05
           IF g_imaslk.imaslk05<=0 THEN
              CALL cl_err('','axm_664',0)
              NEXT FIELD imaslk05
           END IF
           #TQC-C20418--add--begin---
           IF NOT cl_null(g_imaslk.imaslk06) AND NOT cl_null(g_imaslk.imaslk05) THEN
              IF g_imaslk.imaslk06>g_imaslk.imaslk05 THEN
                 CALL cl_err('','axm_666',0)
                 NEXT FIELD imaslk05
              END IF
           END IF
           #TQC-C20418--add--end---

        AFTER FIELD imaslk06
           IF g_imaslk.imaslk06<=0 THEN
              CALL cl_err('','axm_664',0)
              NEXT FIELD imaslk06
           END IF
           #TQC-C20418--add--begin---
           IF NOT cl_null(g_imaslk.imaslk06) AND NOT cl_null(g_imaslk.imaslk05) THEN
              IF g_imaslk.imaslk06>g_imaslk.imaslk05 THEN
                 CALL cl_err('','axm_666',0)
                 NEXT FIELD imaslk06
              END IF
           END IF
           #TQC-C20418--add--end---

#FUN-B90103--end   
#FUN-C60021------ADD----STR--
        AFTER FIELD imaslk11
           SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=g_ima.ima01
           IF l_ima151='N' AND l_imaag='@CHILD' THEN
              SELECT imx00 INTO l_imx00 FROM imx_file WHERE imx000=g_ima.ima01
              SELECT ima940 INTO l_ima940 FROM ima_file WHERE ima01=l_imx00
              SELECT agd03 INTO l_agd03 FROM agd_file WHERE agd01=l_ima940 AND agd02=g_imaslk.imaslk11
              DISPLAY l_agd03 TO agd03
           END IF
#FUN-C60021------ADD----END---

        AFTER FIELD ima1025
           IF NOT cl_null(g_ima.ima1025) THEN
              IF g_ima.ima1025 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1025
              END IF
              IF NOT cl_null(g_ima.ima1024) AND
                 NOT cl_null(g_ima.ima1026) THEN
                 LET g_ima.ima1027 = g_ima.ima1024 *
                                       g_ima.ima1025 * g_ima.ima1026
                 CALL s_umfchk(g_ima.ima01,g_ima.ima31,g_ima.ima25)
                     RETURNING g_sw,l_ima31_fac
                 LET g_ima.ima1022 = g_ima.ima1027/l_ima31_fac
                 DISPLAY g_ima.ima1027 TO ima1027
                 DISPLAY g_ima.ima1022 TO ima1022
              END IF
           END IF
 
        AFTER FIELD ima1026
           IF NOT cl_null(g_ima.ima1026) THEN
              IF g_ima.ima1026 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1026
              END IF
              IF NOT cl_null(g_ima.ima1024) AND
                 NOT cl_null(g_ima.ima1025) THEN
                 LET g_ima.ima1027 = g_ima.ima1024 *
                                       g_ima.ima1025 * g_ima.ima1026
                 CALL s_umfchk(g_ima.ima01,g_ima.ima31,g_ima.ima25)
                     RETURNING g_sw,l_ima31_fac
                 LET g_ima.ima1022 = g_ima.ima1027/l_ima31_fac
                 DISPLAY g_ima.ima1027 TO ima1027
                 DISPLAY g_ima.ima1022 TO ima1022
              END IF
           END IF
 
        AFTER FIELD ima1028
           IF NOT cl_null(g_ima.ima1028) THEN
              IF g_ima.ima1028<= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1028
              END IF
              LET g_ima.ima1023 = g_ima.ima1028/l_ima31_fac
              DISPLAY g_ima.ima1023 TO ima1023
           END IF
 
        AFTER FIELD ima1027
           IF NOT cl_null(g_ima.ima1027) THEN
              IF g_ima.ima1027 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1027
              END IF
           END IF
 
        AFTER FIELD ima1019
           IF NOT cl_null(g_ima.ima1019) THEN
              IF g_ima.ima1019 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1019
              END IF
              IF NOT cl_null(g_ima.ima1020) AND
                 NOT cl_null(g_ima.ima1021) THEN
                 LET g_ima.ima1022 = g_ima.ima1019 *
                                       g_ima.ima1020 * g_ima.ima1021
                 DISPLAY g_ima.ima1022 TO ima1022
              END IF
           END IF
 
        AFTER FIELD ima1020
           IF NOT cl_null(g_ima.ima1020) THEN
              IF g_ima.ima1020 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1020
              END IF
              IF NOT cl_null(g_ima.ima1019) AND
                 NOT cl_null(g_ima.ima1021) THEN
                 LET g_ima.ima1022 = g_ima.ima1019 *
                                       g_ima.ima1020 * g_ima.ima1021
                 DISPLAY g_ima.ima1022 TO ima1022
              END IF
           END IF
 
        AFTER FIELD ima1021
           IF NOT cl_null(g_ima.ima1021) THEN
              IF g_ima.ima1021 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1021
              END IF
              IF NOT cl_null(g_ima.ima1019) AND
                 NOT cl_null(g_ima.ima1020) THEN
                 LET g_ima.ima1022 = g_ima.ima1019 *
                                       g_ima.ima1020 * g_ima.ima1021
                 DISPLAY g_ima.ima1022 TO ima1022
              END IF
           END IF
 
        AFTER FIELD ima1022
           IF NOT cl_null(g_ima.ima1022) THEN
              IF g_ima.ima1022 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1022
              END IF
           END IF
 
        AFTER FIELD ima1023
           IF NOT cl_null(g_ima.ima1023) THEN
              IF g_ima.ima1023 <= 0 THEN
                 CALL cl_err('','aom-557',0)
                 NEXT FIELD ima1023
              END IF
           END IF
 
       AFTER FIELD ima130
          IF g_ima.ima01[1,4]='MISC' THEN
             LET g_ima.ima130='2'
             DISPLAY BY NAME g_ima.ima130
          END IF
 
          IF NOT cl_null(g_ima.ima130) THEN
             IF g_ima.ima130 NOT MATCHES '[0123]' THEN
                NEXT FIELD ima130
             END IF
          END IF
 
       AFTER FIELD ima134
          IF NOT cl_null(g_ima.ima134) THEN
             LET g_buf = NULL
             SELECT obe02 INTO g_buf FROM obe_file
              WHERE obe01=g_ima.ima134
             IF STATUS THEN
                CALL cl_err3("sel","obe_file",g_ima.ima134,"",STATUS,"","sel obe",1)  #No.FUN-660167
                NEXT FIELD ima134
             END IF
             DISPLAY g_buf TO obe02
          END IF
 
       AFTER FIELD ima131
          IF NOT cl_null(g_ima.ima131) THEN
             LET g_buf = NULL
             SELECT oba02,oba14 INTO g_buf,l_oba14 FROM oba_file
              WHERE oba01=g_ima.ima131
             IF STATUS THEN
                CALL cl_err3("sel","oba_file",g_ima.ima131,"",STATUS,"","sel oba",1)  #No.FUN-660167
                NEXT FIELD ima131
             END IF
             IF l_oba14 IS NULL THEN LET l_oba14 = " " END IF   
             IF l_oba14 <> '0' THEN
                CALL cl_err('sel oba','art-904',0)
                NEXT FIELD ima131
             END IF
 
             MESSAGE g_buf CLIPPED
          END IF
 
       AFTER FIELD ima18
          IF NOT cl_null(g_ima.ima18) THEN
             IF g_ima.ima18 < 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD ima18
             END IF
          END IF
 
       AFTER FIELD ima09
          IF NOT cl_null(g_ima.ima09) THEN
             LET g_buf = NULL
             SELECT azf03 INTO g_buf FROM azf_file
              WHERE azf01=g_ima.ima09 AND azf02='D'#6818
             IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_ima.ima09,"",STATUS,"","sel azf",1)  #No.FUN-660167
                NEXT FIELD ima09
             END IF
             MESSAGE g_buf CLIPPED
          END IF
 
       AFTER FIELD ima10
          IF NOT cl_null(g_ima.ima10) THEN
             LET g_buf = NULL
             SELECT azf03 INTO g_buf FROM azf_file
              WHERE azf01=g_ima.ima10 AND azf02='E'#6818
             IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_ima.ima10,"",STATUS,"","sel azf",1)  #No.FUN-660167
                NEXT FIELD ima10
             END IF
             MESSAGE g_buf CLIPPED
          END IF
 
       AFTER FIELD ima11
          IF NOT cl_null(g_ima.ima11) THEN
             LET g_buf = NULL
             SELECT azf03 INTO g_buf FROM azf_file
              WHERE azf01=g_ima.ima11 AND azf02='F'#6818
             IF STATUS THEN
                CALL cl_err3("sel","azf_file",g_ima.ima11,"",STATUS,"","sel azf",1)  #No.FUN-660167
                NEXT FIELD ima11
             END IF
             MESSAGE g_buf CLIPPED
          END IF
 
       AFTER FIELD ima121,ima122,ima123,ima124
          IF NOT cl_null(g_ima.ima121) THEN
             IF g_ima.ima121< 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD ima121
             END IF
          END IF
 
          IF NOT cl_null(g_ima.ima122) THEN
             IF g_ima.ima122< 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD ima122
             END IF
          END IF
 
          IF NOT cl_null(g_ima.ima123) THEN
             IF g_ima.ima123< 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD ima123
             END IF
          END IF
 
          IF NOT cl_null(g_ima.ima124) THEN
             IF g_ima.ima124< 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD ima124
             END IF
          END IF
 
          LET g_ima.ima125 = g_ima.ima121+ g_ima.ima122+ g_ima.ima123+
                             g_ima.ima124
          DISPLAY BY NAME g_ima.ima125
 
       BEFORE FIELD ima141
          CALL i121_set_entry(p_cmd)
 
       AFTER FIELD ima141
          IF NOT cl_null(g_ima.ima141) THEN
             IF g_ima.ima141 NOT MATCHES '[012]' THEN
                LET g_ima.ima141 = g_ima_t.ima141
                DISPLAY BY NAME g_ima.ima141
                NEXT FIELD ima141
             END IF
             IF g_ima.ima141 = '0' THEN
                LET g_ima.ima142 = NULL
                LET g_ima.ima143 = NULL
                LET g_ima.ima144 = NULL
                LET g_ima.ima145 = "N"   #No:7694
                DISPLAY BY NAME g_ima.ima142,g_ima.ima143,
                                g_ima.ima144,g_ima.ima145
             END IF
             CALL i121_set_no_entry(p_cmd)
          END IF
 
       AFTER FIELD ima145
          IF NOT cl_null(g_ima.ima145) THEN
             IF g_ima.ima145 NOT MATCHES '[YN]' THEN
                LET g_ima.ima145 = g_ima_t.ima145
                DISPLAY BY NAME g_ima.ima145
                NEXT FIELD ima145
             END IF
          END IF
 
       AFTER FIELD ima132
          IF NOT cl_null(g_ima.ima132) THEN
             SELECT COUNT(*) INTO g_cnt FROM aag_file
              WHERE aag01=g_ima.ima132
                AND aag00=g_aza.aza81           #No.FUN-730057
             IF g_cnt=0 THEN
                CALL cl_err('sel aag',100,0)
                #Add No.FUN-B10048
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_aag"
                LET g_qryparam.construct = 'N'
                LET g_qryparam.default1 = g_ima.ima132
                LET g_qryparam.arg1 = g_aza.aza81          #No.FUN-730057
                LET g_qryparam.where = " aag01 LIKE '",g_ima.ima132 CLIPPED,"%'"
                CALL cl_create_qry() RETURNING g_ima.ima132
                DISPLAY BY NAME g_ima.ima132
                #End Add No.FUN-B10048
                NEXT FIELD ima132
             END IF
          END IF
       
       #TQC-AC0306 add ------------------begin-------------------
       AFTER FIELD ima135
          IF NOT cl_null(g_ima.ima135) THEN
             IF p_cmd = 'a' OR (p_cmd = 'u' AND g_ima.ima135 <> g_ima_t.ima135) THEN  #FUN-D40001 Add
             LET l_n = 0
            #SELECT COUNT(*) INTO l_n FROM rta_file WHERE rta05 = g_ima.ima135 AND rta01<>g_ima.ima01                     #FUN-D40001 Mark
             SELECT COUNT(*) INTO l_n FROM rta_file WHERE rta05 = g_ima.ima135 AND rta01<>g_ima.ima01 AND rtaacti = 'Y'   #FUN-D40001 Add
             IF l_n > 0 THEN
                CALL cl_err(g_ima.ima135,'art-016',0)
                NEXT FIELD ima135
             END IF   
             #TQC-B50003--add--str--
             CALL i121_chk_ima135()
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_ima.ima135,g_errno,0)
                NEXT FIELD ima135
             END IF
             #TQC-B50003--add--end--
             END IF     #FUN-D40001 Add
          END IF   
       #TQC-AC0306 add ------------------begin-------------------     
       
       #TQC-AB0195-------add-----------------str--------------------
       AFTER FIELD ima1321
          IF NOT cl_null(g_ima.ima1321) THEN
             SELECT COUNT(*) INTO g_cnt FROM aag_file
              WHERE aag01=g_ima.ima1321
                AND aag00=g_aza.aza82
              IF g_cnt=0 THEN
                 CALL cl_err('sel aag',100,0)
                 #Add No.FUN-B10048
                 CALL cl_init_qry_var()
                 LET g_qryparam.form ="q_aag"
                 LET g_qryparam.construct = 'N'
                 LET g_qryparam.default1 = g_ima.ima1321
                 LET g_qryparam.arg1 = g_aza.aza82          #No.FUN-730057
                 LET g_qryparam.where = " aag01 LIKE '",g_ima.ima1321 CLIPPED,"%'"
                 CALL cl_create_qry() RETURNING g_ima.ima1321
                 DISPLAY BY NAME g_ima.ima1321
                 #End Add No.FUN-B10048
                 NEXT FIELD ima1321
              END IF  
          END IF   
       #TQC-AB0195-------add-----------------end--------------------           
 
       AFTER FIELD ima133
          IF NOT cl_null(g_ima.ima133) THEN
              IF p_cmd = 'a' AND g_ima.ima133 = g_ima.ima01 THEN
                  NEXT FIELD ima132
              ELSE
              #MOD-590155
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM ima_file
                   WHERE ima01 = g_ima.ima133
                  IF l_cnt = 0  THEN
                      CALL cl_err('','axm-297',0)
                      NEXT FIELD ima133
                  END IF
                  LET l_cnt = 0
              END IF  #MOD-590155
          END IF
 
       AFTER FIELD ima148
          IF NOT cl_null(g_ima.ima148) THEN
             IF g_ima.ima148 < 0 THEN
                CALL cl_err('','aom-557',0)
                NEXT FIELD ima148
             END IF
          END IF
 
          AFTER FIELD imaud01
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud02
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud03
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud04
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud05
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud06
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud07
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud08
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud09
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud10
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud11
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud12
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud13
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud14
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
          AFTER FIELD imaud15
             IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
       AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
          LET g_ima.imauser = s_get_data_owner("ima_file") #FUN-C10039
          LET g_ima.imagrup = s_get_data_group("ima_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT  END IF

       ON ACTION controlp
          CASE
             WHEN INFIELD(ima133)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_ima"
                  LET g_qryparam.default1 = g_ima.ima133
                  CALL cl_create_qry() RETURNING g_ima.ima133
                  DISPLAY BY NAME g_ima.ima133
                  NEXT FIELD ima133
             WHEN INFIELD(ima25)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ima.ima25
                  CALL cl_create_qry() RETURNING g_ima.ima25
                  DISPLAY BY NAME g_ima.ima25
                  NEXT FIELD ima25
             WHEN INFIELD(ima31)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_gfe"
                  LET g_qryparam.default1 = g_ima.ima31
                  CALL cl_create_qry() RETURNING g_ima.ima31
                  DISPLAY BY NAME g_ima.ima31
                  NEXT FIELD ima31
             WHEN INFIELD(ima132)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_aag"
                  LET g_qryparam.default1 = g_ima.ima132
                  LET g_qryparam.arg1 = g_aza.aza81          #No.FUN-730057
                  CALL cl_create_qry() RETURNING g_ima.ima132
                  DISPLAY BY NAME g_ima.ima132
                  NEXT FIELD ima132
             WHEN INFIELD(ima1321)                                                                                                   
                  CALL cl_init_qry_var()                                                                                            
                  LET g_qryparam.form ="q_aag"                                                                                      
                  LET g_qryparam.default1 = g_ima.ima1321 
                   LET g_qryparam.arg1 = g_aza.aza82          #No.FUN-730057                                                                           
                  CALL cl_create_qry() RETURNING g_ima.ima1321                                                                       
                  DISPLAY BY NAME g_ima.ima1321                                                                                      
                  NEXT FIELD ima1321
             WHEN INFIELD(ima1004)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="1"
                  LET g_qryparam.default1 = g_ima.ima1004
                  CALL cl_create_qry() RETURNING g_ima.ima1004
                  DISPLAY BY NAME g_ima.ima1004
                  NEXT FIELD ima1004
             WHEN INFIELD(ima1005)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="2"
                  LET g_qryparam.default1 = g_ima.ima1005
                  CALL cl_create_qry() RETURNING g_ima.ima1005
                  DISPLAY BY NAME g_ima.ima1005
                  NEXT FIELD ima1005
             WHEN INFIELD(ima1006)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="3"
                  LET g_qryparam.default1 = g_ima.ima1006
                  CALL cl_create_qry() RETURNING g_ima.ima1006
                  DISPLAY BY NAME g_ima.ima1006
                  NEXT FIELD ima1006
             WHEN INFIELD(ima1007)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="4"
                  LET g_qryparam.default1 = g_ima.ima1007
                  CALL cl_create_qry() RETURNING g_ima.ima1007
                  DISPLAY BY NAME g_ima.ima1007
                  NEXT FIELD ima1007
             WHEN INFIELD(ima1008)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="5"
                  LET g_qryparam.default1 = g_ima.ima1008
                  CALL cl_create_qry() RETURNING g_ima.ima1008
                  DISPLAY BY NAME g_ima.ima1008
                  NEXT FIELD ima1008
             WHEN INFIELD(ima1009)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_tqa"
                  LET g_qryparam.arg1 ="6"
                  LET g_qryparam.default1 = g_ima.ima1009
                  CALL cl_create_qry() RETURNING g_ima.ima1009
                  DISPLAY BY NAME g_ima.ima1009
                  NEXT FIELD ima1009               
 
             WHEN INFIELD(ima134)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_obe"
                  LET g_qryparam.default1 = g_ima.ima134
                  CALL cl_create_qry() RETURNING g_ima.ima134
                  DISPLAY BY NAME g_ima.ima134
                  NEXT FIELD ima134
             WHEN INFIELD(ima131)
                  CALL cl_init_qry_var()
                  IF g_azw.azw04 = '2' THEN 
                     LET g_qryparam.form ="q_oba01"
                  ELSE 
                     LET g_qryparam.form ="q_oba"
                  END IF    
                  LET g_qryparam.default1 = g_ima.ima131
                  CALL cl_create_qry() RETURNING g_ima.ima131
                  DISPLAY BY NAME g_ima.ima131
                  NEXT FIELD ima131
             WHEN INFIELD(ima06)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_imz"
                  LET g_qryparam.default1 = g_ima.ima06
                  CALL cl_create_qry() RETURNING g_ima.ima06
                  DISPLAY BY NAME g_ima.ima06
                  NEXT FIELD ima06
             WHEN INFIELD(ima09)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf"
                  LET g_qryparam.default1 = g_ima.ima09
                  LET g_qryparam.arg1 = 'D'
                  CALL cl_create_qry() RETURNING g_ima.ima09
                  DISPLAY BY NAME g_ima.ima09
                  NEXT FIELD ima09
             WHEN INFIELD(ima10)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf"
                  LET g_qryparam.default1 = g_ima.ima10
                  LET g_qryparam.arg1 = 'E'
                  CALL cl_create_qry() RETURNING g_ima.ima10
                  DISPLAY BY NAME g_ima.ima10
                  NEXT FIELD ima10
             WHEN INFIELD(ima11)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form ="q_azf"
                  LET g_qryparam.default1 = g_ima.ima11
                  LET g_qryparam.arg1 = 'F'
                  CALL cl_create_qry() RETURNING g_ima.ima11
                  DISPLAY BY NAME g_ima.ima11
                  NEXT FIELD ima11
           END CASE
 
        ON ACTION CONTROLZ
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION CONTROLF                        # 欄位說明
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
END FUNCTION
 
FUNCTION i121_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_ima.ima01 TO NULL         #No.FUN-6A0020
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt
 
    CALL i121_curs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
       LET INT_FLAG = 0
       CLEAR FORM
       RETURN
    END IF
 
    OPEN i121_count
    FETCH i121_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt
 
    OPEN i121_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
       INITIALIZE g_ima.* TO NULL
    ELSE
       CALL i121_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
FUNCTION i121_fetch(p_flima)
   DEFINE p_flima         LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
 
   CASE p_flima
      WHEN 'N' FETCH NEXT     i121_cs INTO g_ima.ima01
      WHEN 'P' FETCH PREVIOUS i121_cs INTO g_ima.ima01
      WHEN 'F' FETCH FIRST    i121_cs INTO g_ima.ima01
      WHEN 'L' FETCH LAST     i121_cs INTO g_ima.ima01
      WHEN '/'
         IF (NOT mi_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
 
            PROMPT g_msg CLIPPED || ': ' FOR g_jump   --改g_jump
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
         FETCH ABSOLUTE g_jump i121_cs INTO g_ima.ima01
         LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      INITIALIZE g_ima.* TO NULL  #TQC-6B0105
      LET g_ima.ima01 = NULL      #TQC-6B0105
      RETURN
   ELSE
      CASE p_flima
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump          --改g_jump
      END CASE
 
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
 
   SELECT * INTO g_ima.* FROM ima_file
    WHERE ima01 = g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err3("sel","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
   ELSE
#FUN-B90103--start--
   IF s_industry("slk") THEN
      INITIALIZE g_imaslk.* TO NULL
      SELECT * INTO g_imaslk.* FROM imaslk_file
        WHERE imaslk00 = g_ima.ima01
   END IF
#FUN-B90103--end--
      LET g_data_owner = g_ima.imauser      #FUN-4C0057 add
      LET g_data_group = g_ima.imagrup      #FUN-4C0057 add
      CALL i121_show()                      # 重新顯示
   END IF
 
END FUNCTION
 
FUNCTION i121_show()
   DEFINE l_smd   DYNAMIC ARRAY OF RECORD
                     smd04 LIKE smd_file.smd04,
                     smd02 LIKE smd_file.smd02,
                     smd06 LIKE smd_file.smd06,
                     smd03 LIKE smd_file.smd03
                  END RECORD
   DEFINE l_chr   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)
   DEFINE g_chr   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)      #No.FUN-610013 
   DEFINE g_chr1  LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)      #No.FUN-610013 
   #LET g_ima_t.* = g_ima.*    #MOD-A70099
#FUN-C60021---ADD----STR-----
   DEFINE l_ima151 LIKE ima_file.ima151
   DEFINE l_ima940 LIKE ima_file.ima940
   DEFINE l_agd03  LIKE agd_file.agd03
   DEFINE l_imaag  LIKE ima_file.imaag
   DEFINE l_imx00  LIKE imx_file.imx00
#FUN-C60021---ADD----END-----

   DISPLAY BY NAME g_ima.ima01,g_ima.ima02,g_ima.ima021, g_ima.imaoriu,g_ima.imaorig,
                   g_ima.ima08,g_ima.ima06,
                   g_ima.ima05,g_ima.ima25,g_ima.ima31,g_ima.ima31_fac,
                   g_ima.ima03,g_ima.ima04,
                   g_ima.ima1004,g_ima.ima1005,g_ima.ima1006, #No.FUN-640010                                                                                 
                   g_ima.ima1007,g_ima.ima1008,g_ima.ima1009, #No.FUN-640010       
                   g_ima.ima130,g_ima.ima131,
                   g_ima.ima1010,   #No.FUN-610013
                   g_ima.ima09,g_ima.ima10,g_ima.ima11,
                   g_ima.ima18,g_ima.ima134,g_ima.ima154,g_ima.ima155,g_ima.ima133,g_ima.ima132,g_ima.ima1321,  #No.FUN-680034  #FUN-870100
                   g_ima.ima138,g_ima.ima148,g_ima.ima35,g_ima.ima36,
                   g_ima.ima121,g_ima.ima122,g_ima.ima123,g_ima.ima124,
                   g_ima.ima125,g_ima.ima126,g_ima.ima127,g_ima.ima128,
                   g_ima.ima98,g_ima.ima33,g_ima.ima135,g_ima.ima141,    #MOD-4B0254
                   g_ima.ima142,g_ima.ima143,g_ima.ima144,g_ima.ima145,  #No.MOD-5C0169
                   g_imaslk.imaslk05,g_imaslk.imaslk06,g_imaslk.imaslk07,g_imaslk.imaslk08,   #FUN-B90103
                   g_imaslk.imaslk10,g_imaslk.imaslk09,g_imaslk.imaslk11,g_imaslk.imaslk01,   #FUN-B90103
                   g_imaslk.imaslk02,g_imaslk.imaslk03,g_imaslk.imaslk04,                     #FUN-B90103
                   g_ima.ima1024,g_ima.ima1025,g_ima.ima1026,g_ima.ima1028,#No.FUN-640010                                                                   
                   g_ima.ima1027,g_ima.ima1019,g_ima.ima1020,g_ima.ima1021,#No.FUN-640010                                                                   
                   g_ima.ima1023,g_ima.ima1022,    #No.FUN-640010
                   g_ima.ima1017,g_ima.ima1018,    #No.FUN-640010
                   g_ima.imauser,g_ima.imagrup,g_ima.imamodu,
                   g_ima.imadate,g_ima.imaacti,
                   g_ima.imaud01,g_ima.imaud02,g_ima.imaud03,g_ima.imaud04,
                   g_ima.imaud05,g_ima.imaud06,g_ima.imaud07,g_ima.imaud08,
                   g_ima.imaud09,g_ima.imaud10,g_ima.imaud11,g_ima.imaud12,
                   g_ima.imaud13,g_ima.imaud14,g_ima.imaud15
 
    IF cl_null(g_ima.ima1028) THEN                                                                                                  
       DISPLAY g_ima.ima18 TO ima1028                                                                                               
    END IF                                                                                                                          
    IF cl_null(g_ima.ima1027) THEN                                                                                                  
       DISPLAY g_ima.ima1011 TO ima1027                                                                                             
    END IF                                                                                                                          
                                                                                                                                    
    CALL i120_ima(g_ima.ima1004,'1')                                                                                                
    CALL i120_ima(g_ima.ima1005,'2')                                                                                                
    CALL i120_ima(g_ima.ima1006,'3')                                                                                                
    CALL i120_ima(g_ima.ima1007,'4')                                                                                                
    CALL i120_ima(g_ima.ima1008,'5')                                                                                                
    CALL i120_ima(g_ima.ima1009,'6')                        
 
   LET g_buf = NULL
   #SELECT * INTO g_ima.* FROM ima_file   #MOD-A70099
   # WHERE ima01=g_ima.ima01   #MOD-A70099
   DISPLAY BY NAME g_ima.ima05,g_ima.ima08
 
   LET l_chr=g_ima.ima93[2,2]
   DISPLAY l_chr TO FORMONLY.s
 
#FUN-C60021-----ADD----STR---
   IF s_industry('slk') THEN
      SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=g_ima.ima01
      IF l_ima151='N' AND l_imaag='@CHILD' THEN
         SELECT imx00 INTO l_imx00 FROM imx_file WHERE imx000=g_ima.ima01
         SELECT ima940 INTO l_ima940 FROM ima_file WHERE ima01=l_imx00
         SELECT agd03 INTO l_agd03 FROM agd_file WHERE agd01=l_ima940 AND agd02=g_imaslk.imaslk11
         DISPLAY l_agd03 TO agd03
      END IF
   END IF
#FUN-C60021-----ADD----END---
   SELECT obe02 INTO g_buf FROM obe_file
    WHERE obe01=g_ima.ima134
   DISPLAY g_buf TO obe02
 
   LET g_buf = NULL
   SELECT imz02 INTO g_buf FROM imz_file
    WHERE imz01=g_ima.ima06
   DISPLAY g_buf TO imz02
 
   LET g_buf = NULL
   DECLARE i121_c3 CURSOR FOR
    SELECT smd04,smd02,smd06,smd03 FROM smd_file
     WHERE smd01=g_ima.ima01
 
   CALL l_smd.clear()
 
   LET i=1
   FOREACH i121_c3 INTO l_smd[i].*
      LET i=i+1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
   LET i = i - 1
 
   DISPLAY ARRAY l_smd TO s_smd.* ATTRIBUTE(COUNT=i)
 
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   #圖形顯示
   LET g_doc.column1 = "ima01"
   LET g_doc.value1 = g_ima.ima01
   CALL cl_get_fld_doc("ima04")
 
   CALL i121_show_pic()                      #FUN-6B0055 add
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
END FUNCTION
 
FUNCTION i121_u()
   DEFINE l_n      LIKE type_file.num5    #TQC-AC0306 add
   DEFINE l_imx000 LIKE imx_file.imx000   #FUN-B90103 add
   DEFINE l_sql    STRING                 #FUN-B90103 add
   DEFINE l_ima    RECORD LIKE ima_file.* #FUN-B90103 add
   DEFINE l_imaslk RECORD LIKE imaslk_file.* #FUN-B90103 add
   DEFINE l_ima1   RECORD LIKE ima_file.*            #FUN-B80032
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF

#MOD-C30104--mark--begin--
##FUN-B90103--start--
#  IF s_industry("slk") THEN
#     SELECT COUNT(*) INTO l_n  FROM ima_file WHERE ima01=g_ima.ima01 AND ima151='N' AND imaag='@CHILD'  
#     IF l_n > 0 THEN
#        CALL cl_err('',"axm_665",0)
#        RETURN
#    END IF
#  END IF
##FUN-B90103--end--
#MOD-C30104--mark--end--

   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT * INTO g_ima.* FROM ima_file WHERE ima01=g_ima.ima01
   IF g_ima.imaacti = 'N' THEN
       CALL cl_err('',9027,0)
       RETURN
   END IF
            
   MESSAGE ""
   CALL cl_opmsg('u')
   LET g_ima01_t = g_ima.ima01
 
   BEGIN WORK
 
   OPEN i121_cl USING g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE i121_cl
      RETURN
   END IF
 
   FETCH i121_cl INTO g_ima.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE i121_cl
      RETURN
   END IF
 
   LET g_ima_t.*=g_ima.*
   LET g_ima_o.*=g_ima.*   #MOD-880165
   LET g_ima.imamodu = g_user                #修改者
   LET g_ima.imadate = g_today               #修改日期
   LET l_ima.* = g_ima.*                     #FUN-B90103
   LET l_imaslk.* = g_imaslk.*               #FUN-B90103 
   CALL i121_show()                          # 顯示最新資料
 
   WHILE TRUE
      CALL i121_i("u")                      # 欄位更改
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_ima.*=g_ima_t.*
         CALL i121_show()
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
      #FUN-B80032---------STA-------
       SELECT * INTO l_ima1.*
         FROM ima_file
        WHERE ima01 = g_ima.ima01
        IF l_ima1.ima02 <> g_ima.ima02 OR l_ima1.ima021 <> g_ima.ima021
           OR l_ima1.ima25 <> g_ima.ima25 OR l_ima1.ima45 <> g_ima.ima45
           OR l_ima1.ima131 <> g_ima.ima131 OR l_ima1.ima151 <> g_ima.ima151
           OR l_ima1.ima154 <> g_ima.ima154 OR l_ima1.ima1004 <> g_ima.ima1004 
           OR l_ima1.ima1005 <> g_ima.ima1005 OR l_ima1.ima1006 <> g_ima.ima1006
           OR l_ima1.ima1007 <> g_ima.ima1007 OR l_ima1.ima1008 <> g_ima.ima1008
           OR l_ima1.ima1009 <> g_ima.ima1009 THEN        
           IF g_aza.aza88 = 'Y' THEN
              UPDATE rte_file SET rtepos = '2' WHERE rte03 = g_ima.ima01 AND rtepos = '3'
           END IF
        END IF 
      #FUN-B80032---------END-------  
      LET g_ima.ima93[2,2] = 'Y'
      UPDATE ima_file SET * = g_ima.*  # 更新DB
       WHERE ima01 = g_ima.ima01             # COLAUTH?
      IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","ima_file",g_ima01_t,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
          CONTINUE WHILE
#MOD-AC0160------mark--------str--------------
##No.FUN-A50011 ---begin---
#     ELSE 
#        IF g_ima.ima151 = 'Y' THEN
#           CALL s_upd_ima_subparts(g_ima.ima01)
#        END IF
##No.FUN-A50011  ---end---
#MOD-AC0160------mark--------end--------------
      END IF
##FUN-B90103 --begin--
     IF s_industry("slk") THEN
        SELECT COUNT(*) INTO l_n FROM imaslk_file WHERE imaslk00=g_ima.ima01
           LET g_imaslk.imaslk00=g_ima.ima01
        IF cl_null(l_n) OR l_n=0 THEN    
           INSERT INTO imaslk_file VALUES(g_imaslk.*)
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","imaslk_file",g_imaslk.imaslk00,"",SQLCA.sqlcode,"","",1)
              CONTINUE WHILE
           END IF
        ELSE
           UPDATE imaslk_file SET *=g_imaslk.* WHERE imaslk00=g_ima.ima01
           IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","imaslk_file",g_imaslk.imaslk00,"",SQLCA.sqlcode,"","",1)
              CONTINUE WHILE
           END IF
        END IF

        SELECT * INTO l_ima.*  FROM ima_file WHERE ima01 = g_ima.ima01 
        SELECT * INTO l_imaslk.* FROM imaslk_file WHERE imaslk00= g_ima.ima01   
        LET l_sql=" SELECT imx000 FROM imx_file WHERE imx00='",g_ima.ima01,"'" 
        PREPARE  ima_upd FROM l_sql
        DECLARE ima_slk_upd CURSOR FOR ima_upd

        FOREACH ima_slk_upd INTO l_imx000 
          LET l_ima.ima01 = l_imx000 
          SELECT ima02,ima021,ima1010,ima151,ima940,ima941,imaag,imaacti
            INTO l_ima.ima02,l_ima.ima021,l_ima.ima1010,l_ima.ima151,
                 l_ima.ima940,l_ima.ima941,l_ima.imaag,l_ima.imaacti
            FROM ima_file
           WHERE ima01=l_ima.ima01
          UPDATE ima_file SET *=l_ima.* WHERE ima01=l_imx000

          IF SQLCA.sqlcode THEN
             CALL cl_err3("upd","ima_file",l_imx000,"",SQLCA.sqlcode,"","",1)
             CONTINUE FOREACH 
          END IF
          SELECT COUNT(*) INTO l_n FROM imaslk_file WHERE imaslk00=l_imx000
          LET l_imaslk.imaslk00=l_imx000
          SELECT ima940 INTO l_imaslk.imaslk11 FROM ima_file WHERE ima01=l_imx000   #FUN-C60021--ADD--
          IF cl_null(l_n) OR l_n=0  THEN
             INSERT INTO imaslk_file VALUES(l_imaslk.*)
             IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","imaslk_file",l_imx000,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH 
             END IF
          ELSE
             UPDATE imaslk_file SET *=l_imaslk.* WHERE imaslk00=l_imx000
             IF SQLCA.sqlcode THEN
                CALL cl_err3("upd","imaslk_file",l_imx000,"",SQLCA.sqlcode,"","",1)
                CONTINUE FOREACH
             END IF
          END IF
      END FOREACH
    END IF 
##FUN-B90103 --end--
      #TQC-AC0306 add ------------------begin-------------------
      IF NOT cl_null(g_ima.ima135) THEN
         IF g_ima.ima135 <> g_ima_t.ima135 THEN  #FUN-D40001 Add
         LET l_n = 0
        #SELECT COUNT(*) INTO l_n FROM rta_file WHERE rta05 = g_ima.ima135 AND rta01<>g_ima.ima01                     #FUN-D40001 Mark
         SELECT COUNT(*) INTO l_n FROM rta_file WHERE rta05 = g_ima.ima135 AND rta01<>g_ima.ima01 AND rtaacti = 'Y'   #FUN-D40001 Add
         IF l_n > 0 THEN   
            CALL cl_err(g_ima.ima135,'art-016',0)
            CONTINUE WHILE       
         END IF
         
         LET l_n = 0
         SELECT COUNT(*) INTO l_n FROM rta_file WHERE rta05 = g_ima.ima135 AND rta01=g_ima.ima01
         IF l_n = 0 THEN
            #            INSERT INTO rta_file(rta01,rta02,rta03,rta04,rta05,rtaacti,rtapos)         #FUN-B90049  mark
            INSERT INTO rta_file(rta01,rta02,rta03,rta04,rta05,rtaacti)                 #FUN-B90049  add
            VALUES(g_ima.ima01,(SELECT COUNT(rta02)+1 FROM rta_file WHERE rta01=g_ima.ima01)
#                   ,g_ima.ima31,'1',g_ima.ima135,'Y','1') #'N' #NO.FUN-B40071          #FUN-B90049  mark
                     ,g_ima.ima31,'1',g_ima.ima135,'Y')                                 #FUN-B90049  add
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err(g_ima.ima135,SQLCA.SQLCODE,0)
               CONTINUE WHILE
            END IF
            MESSAGE 'Insert rta_file OK'
         #FUN-D40001-----Add------Str
         ELSE
            UPDATE rta_file SET rtaacti = 'Y' 
             WHERE rta01 = g_ima.ima01
               AND rta05 = g_ima.ima135 
            IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
               CALL cl_err(g_ima.ima135,SQLCA.SQLCODE,0)
               CONTINUE WHILE
            END IF
         #FUN-D40001-----Add------End
         END IF      
         END IF    #FUN-D40001 Add
      END IF
      #TQC-AC0306 add -------------------end--------------------
      DISPLAY 'Y' TO FORMONLY.s
 
      EXIT WHILE
   END WHILE
 
   CLOSE i121_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i121_m()
   DEFINE i,j              LIKE type_file.num5        # No.FUN-680137 SMALLINT
   DEFINE g_imc            DYNAMIC ARRAY OF RECORD
                              imc02     LIKE imc_file.imc02,
                              imc03     LIKE imc_file.imc03,   #FUN-610045
                              imc04     LIKE imc_file.imc04
                           END RECORD,
          l_allow_insert   LIKE type_file.num5,        # No.FUN-680137 SMALLINT,                 #可新增否
          l_allow_delete   LIKE type_file.num5,        # No.FUN-680137 SMALLINT,                 #可刪除否
          g_imc_t          RECORD       #程式變數 (舊值)
                              imc02     LIKE imc_file.imc02,
                              imc03     LIKE imc_file.imc03,
                              imc04     LIKE imc_file.imc04
                           END RECORD,
          l_n              LIKE type_file.num5,        # No.FUN-680137 SMALLINT,                 #檢查重複用
          l_lock_sw        LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(1),                  #單身鎖住否
          l_ac_t           LIKE type_file.num5,        # No.FUN-680137 SMALLINT,                 #未取消的ARRAY CNT
          p_cmd            LIKE type_file.chr1        # No.FUN-680137 VARCHAR(1)                   #處理狀態
 
   IF g_ima.ima01 IS NULL THEN RETURN END IF
#FUN-B90103--start
   IF s_industry("slk") THEN
      SELECT COUNT(*) INTO l_n  FROM ima_file WHERE ima01=g_ima.ima01 AND ima151='N' AND imaag='@CHILD'
      IF l_n > 0 THEN
         CALL cl_err('',"axm_665",0)
         RETURN
      END IF
   END IF
#FUN-B90103--end--
   LET p_row = 8 LET p_col = 11
 
   OPEN WINDOW i121_m_w AT p_row,p_col WITH FORM "axm/42f/axmi121_1"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmi121_1")
 
   DECLARE i121_m_c CURSOR FOR
    SELECT imc02,imc03,imc04 FROM imc_file   #FUN-610045
     WHERE imc01 = g_ima.ima01
     ORDER BY imc02
 
   LET i = 1
   FOREACH i121_m_c INTO g_imc[i].*
      LET i = i + 1
      IF i > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
 
   END FOREACH
   CALL g_imc.deleteElement(i)
 
   LET i = i - 1
 
   LET g_forupd_sql = "SELECT imc02,imc03,imc04 FROM imc_file ",
                      " WHERE imc01 = ? AND imc02 = ? AND imc03 = ? FOR UPDATE"
 
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i121_m_c1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY g_imc WITHOUT DEFAULTS FROM s_imc.*
         ATTRIBUTE(COUNT=i,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
      BEFORE INPUT
          IF i != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
      BEFORE ROW
          LET p_cmd=''
          LET l_ac = ARR_CURR()
          LET l_lock_sw = 'N'            #DEFAULT
          LET l_n  = ARR_COUNT()
          IF i >= l_ac THEN
             LET p_cmd='u'
             LET g_imc_t.* = g_imc[l_ac].*  #BACKUP
 
             BEGIN WORK
             OPEN i121_m_c1 USING g_ima.ima01,g_imc_t.imc02,g_imc_t.imc03
             IF STATUS THEN
                CALL cl_err("OPEN i121_m_c1:", STATUS, 1)
                LET l_lock_sw = "Y"
             ELSE
                DISPLAY g_ima.ima01,g_imc_t.imc02,g_imc_t.imc03
                FETCH i121_m_c1 INTO g_imc[l_ac].*
                IF SQLCA.sqlcode THEN
                   CALL cl_err(g_imc_t.imc03,SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
                END IF
                LET g_imc_t.*=g_imc[l_ac].*
             END IF
             CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
 
       BEFORE INSERT
           LET l_n = ARR_COUNT()
           LET p_cmd='a'
           INITIALIZE g_imc[l_ac].* TO NULL      #900423
           LET g_imc_t.* = g_imc[l_ac].*         #新輸入資料
           CALL cl_show_fld_cont()     #FUN-550037(smin)
           NEXT FIELD imc02
 
       AFTER INSERT
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF
           IF NOT cl_null(g_imc[l_ac].imc02) OR
              NOT cl_null(g_imc[l_ac].imc03) OR
              NOT cl_null(g_imc[l_ac].imc04) THEN
              INSERT INTO imc_file (imc01,imc02,imc03,imc04)
                            VALUES (g_ima.ima01,g_imc[l_ac].imc02,
                                    g_imc[l_ac].imc03,g_imc[l_ac].imc04)
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("ins","imc_file",g_ima.ima01,g_imc[l_ac].imc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                 CANCEL INSERT
              ELSE
                 MESSAGE 'INSERT O.K'
                 COMMIT WORK
                 LET i = i + 1
              END IF
           END IF
 
      AFTER FIELD imc02
         IF NOT cl_null(g_imc[l_ac].imc02) AND cl_null(g_imc[l_ac].imc03) THEN
           SELECT max(imc03)+1 INTO g_imc[l_ac].imc03
             FROM imc_file
            WHERE imc01 = g_ima.ima01
              AND imc02 = g_imc[l_ac].imc02
           IF g_imc[l_ac].imc03 IS NULL THEN
              LET g_imc[l_ac].imc03 = 1
           END IF
         END IF
 
      BEFORE FIELD imc03                        # dgeeault 序號
         IF g_imc[l_ac].imc03 IS NULL OR g_imc[l_ac].imc03 = 0 THEN
            SELECT count(*) INTO g_cnt
              FROM imc_file
             WHERE imc01 = g_ima.ima01
               AND imc02 = g_imc[l_ac].imc02
            IF NOT cl_null(g_imc[l_ac].imc02) THEN
               SELECT max(imc03)+1 INTO g_imc[l_ac].imc03
                 FROM imc_file
                WHERE imc01 = g_ima.ima01
                  AND imc02 = g_imc[l_ac].imc02
               IF g_imc[l_ac].imc03 IS NULL THEN
                  LET g_imc[l_ac].imc03 = 1
               END IF
            END IF
         END IF
 
      AFTER FIELD imc03                        #check 序號是否重複
         IF g_imc[l_ac].imc03 IS NOT NULL AND
            (g_imc[l_ac].imc03 != g_imc_t.imc03 OR g_imc_t.imc03 IS NULL) AND
            NOT cl_null(g_imc[l_ac].imc02) THEN
            SELECT count(*) INTO l_n
              FROM imc_file
             WHERE imc01 = g_ima.ima01
               AND imc02 = g_imc[l_ac].imc02
               AND imc03 = g_imc[l_ac].imc03
            IF l_n > 0 THEN
               CALL cl_err('',-239,0)
               LET g_imc[l_ac].imc03 = g_imc_t.imc03
               NEXT FIELD imc03
            END IF
         END IF
 
      BEFORE DELETE                            #是否取消單身
         IF g_imc_t.imc03 IS NOT NULL THEN
            IF NOT cl_delb(0,0) THEN
               CANCEL DELETE
            END IF
            IF l_lock_sw = "Y" THEN
               CALL cl_err("", -263, 1)
               CANCEL DELETE
            END IF
            DELETE FROM imc_file
             WHERE imc01 = g_ima.ima01
               AND imc02 = g_imc_t.imc02
               AND imc03 = g_imc_t.imc03
            IF SQLCA.sqlcode THEN
                CALL cl_err3("del","imc_file",g_ima.ima01,g_imc_t.imc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
                ROLLBACK WORK
                CANCEL DELETE
            END IF
            LET i = i - 1
            COMMIT WORK
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_imc[l_ac].* = g_imc_t.*
            CLOSE i121_m_c1
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_imc[l_ac].imc03,-263,1)
            LET g_imc[l_ac].* = g_imc_t.*
         ELSE
            UPDATE imc_file SET imc03 = g_imc[l_ac].imc03,
                                imc04 = g_imc[l_ac].imc04
                          WHERE imc01 = g_ima.ima01
                            AND imc02 = g_imc_t.imc02
                            AND imc03 = g_imc_t.imc03
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","imc_file",g_ima.ima01,g_imc_t.imc02,SQLCA.sqlcode,"","",1)  #No.FUN-660167
               LET g_imc[l_ac].* = g_imc_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               COMMIT WORK
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd='u' THEN
               LET g_imc[l_ac].* = g_imc_t.*
            END IF
            CLOSE i121_m_c
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE i121_m_c
         COMMIT WORK

      ON ACTION CONTROLZ
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   END INPUT
 
   CLOSE i121_m_c1
   COMMIT WORK
 
   CLOSE WINDOW i121_m_w
 
END FUNCTION
 
FUNCTION i121_x()
   DEFINE g_chr LIKE ima_file.imaacti
 
   IF s_shut(0) THEN RETURN END IF
 
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i121_cl USING g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i121_cl INTO g_ima.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      CLOSE i121_cl
      RETURN
   END IF
 
   CALL i121_show()
 
   IF cl_exp(0,0,g_ima.imaacti) THEN
      LET g_chr=g_ima.imaacti
      LET g_chr2=g_ima.ima1010   
      CASE g_ima.ima1010
        WHEN '0' #開立
             IF g_ima.imaacti='N' THEN
                LET g_ima.imaacti='P'
             ELSE
                LET g_ima.imaacti='N'
             END IF
        WHEN '1' #確認
             IF g_ima.imaacti='N' THEN
                LET g_ima.imaacti='Y'
             ELSE
                LET g_ima.imaacti='N'
             END IF
      END CASE
      UPDATE ima_file SET imaacti=g_ima.imaacti,
                          imamodu=g_user, 
                          imadate=g_today
       WHERE ima01=g_ima.ima01
      IF SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","ima_file",g_ima.ima01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660167
         LET g_ima.imaacti=g_chr
      END IF
 
      IF g_ima.imaacti='N' THEN 
      END IF
 
      DISPLAY BY NAME g_ima.imaacti
   END IF
 
   CLOSE i121_cl
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i121_r()
   DEFINE l_str  LIKE type_file.chr8  #No.FUN-680137 VARCHAR(8)
   DEFINE l_flag LIKE type_file.chr1  #No.FUN-7B0018     
 
   IF s_shut(0) THEN RETURN END IF
   IF g_ima.ima01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i121_cl USING g_ima.ima01
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i121_cl INTO g_ima.*
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
      CLOSE i121_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i121_show()
 
   IF cl_delete() THEN
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "ima01"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_ima.ima01      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                        #No.FUN-9B0098 10/02/24
      DELETE FROM ima_file WHERE ima01 = g_ima.ima01
      IF s_industry('icd') THEN
         LET l_flag = s_del_imaicd(g_ima.ima01,'')
      END IF
 
      LET l_str=TIME
      INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #No.MOD-470041
                   VALUES('axmi121',g_user,g_today,l_str,g_ima.ima01,'delete',g_plant,g_legal)   #FUN-980010 add plant legal 
 
      CLEAR FORM
 
      OPEN i121_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i121_cs
         CLOSE i121_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i121_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i121_cs
         CLOSE i121_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end--
      DISPLAY g_row_count TO FORMONLY.cnt
 
      OPEN i121_cs
      IF g_curs_index = g_row_count + 1 THEN
         LET g_jump = g_row_count
         CALL i121_fetch('L')
      ELSE
         LET g_jump = g_curs_index
         LET mi_no_ask = TRUE
         CALL i121_fetch('/')
      END IF
   END IF
 
   CLOSE i121_cl
   COMMIT WORK
 
END FUNCTION
FUNCTION i121_out()
    DEFINE l_ima   RECORD
                      ima01   LIKE ima_file.ima01,
                      ima02   LIKE ima_file.ima02,
                      ima021  LIKE ima_file.ima021,
                      ima31   LIKE ima_file.ima31,
                      ima131  LIKE ima_file.ima131,
                      ima06   LIKE ima_file.ima06,
                      ima130  LIKE ima_file.ima130,
                      imaacti LIKE ima_file.imaacti   #No.TQC-740137
                   END RECORD,
           l_i     LIKE type_file.num5,        # No.FUN-680137 SMALLINT,
           l_name  LIKE type_file.chr20,       # No.FUN-680137 VARCHAR(20),                # External(Disk) file name
           l_za05  LIKE ima_file.ima01      # No.FUN-680137 VARCHAR(40)                 #
    DEFINE l_cmd  LIKE type_file.chr1000             #No.FUN-7C0043                                                                 
    IF cl_null(g_wc) AND NOT cl_null(g_ima.ima01) THEN                                                                              
       LET g_wc = " ima01 = '",g_ima.ima01,"' "                                                                                     
    END IF                                                                                                                          
    IF g_wc IS NULL THEN                                                                                                            
       CALL cl_err('','9057',0)                                                                                                     
       RETURN                                                                                                                       
    END IF                                                                                                                          
    LET l_cmd = 'p_query "axmi121" "',g_wc CLIPPED,'"'  # No.FUN-A60075                                                                            
    CALL cl_cmdrun(l_cmd)                                                                                                           
    RETURN   
END FUNCTION
FUNCTION i121_copy()
   DEFINE old_no,new_no    LIKE ima_file.ima01
   DEFINE l_ima            RECORD LIKE ima_file.*
   DEFINE l_imaicd         RECORD LIKE imaicd_file.* #No.FUN-7B0018
 
   LET p_row = 8 LET p_col = 8
 
   OPEN WINDOW i121_cw AT p_row,p_col WITH FORM "axm/42f/axmi121c"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("axmi121c")
 
   LET old_no=g_ima.ima01
 
   INPUT BY NAME old_no,new_no WITHOUT DEFAULTS
 
      AFTER FIELD old_no
         IF NOT cl_null(old_no) THEN
            SELECT * INTO l_ima.* FROM ima_file WHERE ima01=old_no
            IF STATUS THEN
               CALL cl_err3("sel","ima_file",old_no,"",STATUS,"","ima",1)  #No.FUN-660167
               NEXT FIELD old_no
            END IF
         END IF
 
      AFTER FIELD new_no
         IF NOT cl_null(new_no) THEN
            SELECT COUNT(*) INTO i FROM ima_file WHERE ima01=new_no
            IF i > 0 THEN
               CALL cl_err('sel ima:','-239',0)
               NEXT FIELD new_no
            END IF
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
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW i121_cw
      RETURN
   END IF
 
   IF NOT cl_sure(0,0) THEN
      CLOSE WINDOW i121_cw
      RETURN
   END IF
 
   CLOSE WINDOW i121_cw
 
   BEGIN WORK
   LET l_ima.*=g_ima.*
   LET l_ima.ima01=new_no
   LET l_ima.ima05=NULL ##目前使用版本
   LET l_ima.ima18  =0      #單位淨重
  #FUN-A20044,BEGIN
  #LET l_ima.ima26=0
  #LET l_ima.ima261=0
  #LET l_ima.ima262=0
  #FUN-A20044,END
   LET l_ima.ima29=null
   LET l_ima.ima30= g_today    #No:7643 新增 aimi100料號時應default ima30=料件建立日期,以便循環盤點機制
   LET l_ima.ima32=0     #標準售價
   LET l_ima.ima33  =0         #最近售價        #MOD-4B0254
   LET l_ima.ima40  =0         #累計使用數量 期間
   LET l_ima.ima41  =0         #累計使用數量 年度
   LET l_ima.ima47  =0         #採購損耗率
   LET l_ima.ima52  =1         #平均訂購量
   LET l_ima.ima140 ='N'       #phase out
   LET l_ima.ima53  =0         #最近採購單價
   LET l_ima.ima531 =0         #市價
   LET l_ima.ima532 =NULL      #市價最近異動日期
   LET l_ima.ima562 =0         #生產損耗率
   LET l_ima.ima73=null
   LET l_ima.ima74=null
   LET l_ima.ima75  =''        #海關編號
   LET l_ima.ima76  =''        #商品類別
   LET l_ima.ima77  =0         #在途量
   LET l_ima.ima78  =0         #在驗量
   LET l_ima.ima80  =0         #未耗預測量
   LET l_ima.ima81  =0         #確認生產量
   LET l_ima.ima82  =0         #計劃量
   LET l_ima.ima83  =0         #MRP需求量
   LET l_ima.ima84  =0         #OM 銷單備置量
   LET l_ima.ima85  =0         #MFP銷單備置量
   LET l_ima.ima881 =NULL      #期間採購最近採購日期
   LET l_ima.ima91  =0         #平均採購單價
   LET l_ima.ima92  ='N'       #net change status
   LET l_ima.ima93  ='NNNNNNNN'#new parts status
   LET l_ima.ima94  =''        #
   LET l_ima.ima95=0
   LET l_ima.ima96  =0         #A. T. P. 量
   LET l_ima.ima97  =0         #MFG 接單量
   LET l_ima.ima98  =0         #OM 接單量
   LET l_ima.ima33  =0         #最近售價   #MOD-4B0254
   LET l_ima.ima100 ='N'
   LET l_ima.ima101 ='1'
   LET l_ima.ima102 ='1'
   LET l_ima.ima104 =0         #廠商分配起始量
   LET l_ima.ima901 = g_today  #料件建檔日期
   LET l_ima.ima911 = 'N'    #No.MOD-780061 add
   LET l_ima.ima139 = 'N'
   LET l_ima.ima1019=0                                                                                                             
   LET l_ima.ima1020=0                                                                                                             
   LET l_ima.ima1021=0                                                                                                             
   LET l_ima.ima1022=0                                                                                                             
   LET l_ima.ima1023=0                                                                                                             
   LET l_ima.ima1024=0                                                                                                             
   LET l_ima.ima1025=0                                                                                                             
   LET l_ima.ima1026=0                                                                                                             
   LET l_ima.ima1027=0                                                                                                             
   LET l_ima.ima1028=0           
   LET l_ima.ima1010= '0'      #No.FUN-610013    #No.FUN-690025
   LET l_ima.imauser=g_user
   LET l_ima.imagrup=g_grup
   LET l_ima.imadate=g_today
   LET l_ima.imamodu=NULL
   LET l_ima.imaacti='P'       #No.TQC-740235 
   IF l_ima.ima06 IS NULL THEN
      LET l_ima.ima871 =0         #間接物料分攤率
      LET l_ima.ima872 =''        #材料製造費用成本項目
      LET l_ima.ima873 =0         #間接人工分攤率
      LET l_ima.ima874 =''        #人工製造費用成本項目
      LET l_ima.ima88  =0         #期間採購數量
      LET l_ima.ima89  =0         #期間採購使用的期間(月)
      LET l_ima.ima90  =0         #期間採購使用的期間(日)
   END IF
   LET l_ima.ima601 = 1        #No.FUN-840194
 
   IF l_ima.ima35 is null then let l_ima.ima35=' ' end if
   IF l_ima.ima36 is null then let l_ima.ima36=' ' end if
 
   IF cl_null(l_ima.ima918) THEN LET l_ima.ima918 = 'N' END IF
   IF cl_null(l_ima.ima919) THEN LET l_ima.ima919 = 'N' END IF
   IF cl_null(l_ima.ima921) THEN LET l_ima.ima921 = 'N' END IF
   IF cl_null(l_ima.ima922) THEN LET l_ima.ima922 = 'N' END IF
   IF cl_null(l_ima.ima924) THEN LET l_ima.ima924 = 'N' END IF
   IF cl_null(l_ima.ima926) THEN LET l_ima.ima926 = 'N' END IF
   LET l_ima.imaoriu = g_user      #No.FUN-980030 10/01/04
   LET l_ima.imaorig = g_grup      #No.FUN-980030 10/01/04
   LET l_ima.ima120 = '1'          #No.FUN-A90049 add  
  #FUN-A80150---add---start---
   IF cl_null(l_ima.ima156) THEN 
      LET l_ima.ima156 = 'N'
   END IF
   IF cl_null(l_ima.ima158) THEN 
      LET l_ima.ima158 = 'N'
   END IF
  #FUN-A80150---add---end---
   LET l_ima.ima927='N'   #No:FUN-AA0014
#FUN-C20065 ---------Begin---------
   IF cl_null(l_ima.ima159) THEN
      LET l_ima.ima159 = '3'
   END IF
#FUN-C20065 ---------End-----------
   IF cl_null(l_ima.ima928) THEN LET l_ima.ima928 = 'N' END IF      #TQC-C20131  add
   IF cl_null(l_ima.ima160) THEN LET l_ima.ima160 = 'N' END IF      #FUN-C50036  add
   INSERT INTO ima_file VALUES(l_ima.*)
   IF STATUS THEN 
      CALL cl_err3("ins","ima_file",l_ima.ima01,"",STATUS,"","ins ima",1)  #No.FUN-660167
      ROLLBACK WORK 
      RETURN 
   ELSE
      IF s_industry('icd') THEN
         INITIALIZE l_imaicd.* TO NULL
         LET l_imaicd.imaicd00 = l_ima.ima01
         IF NOT s_ins_imaicd(l_imaicd.*,'') THEN
            ROLLBACK WORK
            RETURN
         END IF
      END IF
 
   END IF

##FUN-B90103 --begin--
   IF s_industry('slk') THEN
      DROP TABLE x
      SELECT * FROM imaslk_file WHERE imaslk00=old_no INTO  TEMP x
      IF STATUS THEN
         CALL cl_err3("ins","x",old_no,"",STATUS,"","imaslk- x",1)
         ROLLBACK WORK 
         RETURN  
      END IF

      UPDATE x SET imaslk00=new_no
      INSERT INTO imaslk_file SELECT * FROM x
      IF STATUS THEN
         CALL cl_err3("ins","imaslk_file",new_no,"",STATUS,"","ins imaslk",1)
         ROLLBACK WORK RETURN
      END IF
   END IF
##FUN-B90103 --end-- 
   DROP TABLE x #---------------------------------------- copy smd_file
   SELECT * FROM smd_file WHERE smd01=old_no INTO TEMP x
   IF STATUS THEN 
      CALL cl_err3("ins","x",old_no,"",STATUS,"","smd- x",1)  #No.FUN-660167
      ROLLBACK WORK 
      RETURN 
   END IF
 
   UPDATE x SET smd01=new_no
   INSERT INTO smd_file SELECT * FROM x
   IF STATUS THEN 
      CALL cl_err3("ins","smd_file",new_no,"",STATUS,"","ins smd",1)  #No.FUN-660167
      ROLLBACK WORK 
      RETURN 
   END IF
 
   DROP TABLE x #---------------------------------------- copy smd_file
   SELECT * FROM imc_file WHERE imc01=old_no INTO TEMP x
   IF STATUS THEN 
      CALL cl_err3("ins","x",old_no,"",STATUS,"","imc- x",1)  #No.FUN-660167
      ROLLBACK WORK RETURN 
   END IF
 
   UPDATE x SET imc01=new_no
   INSERT INTO imc_file SELECT * FROM x
   IF STATUS THEN 
      CALL cl_err3("ins","imc_file",new_no,"",STATUS,"","ins imc",1)  #No.FUN-660167
      ROLLBACK WORK RETURN 
   END IF
 
   COMMIT WORK          #---------------------------------------- commit work
   MESSAGE "Copy Ok!"
   SELECT ima_file.* INTO g_ima.* FROM ima_file WHERE ima01=new_no
 
   CALL i121_show()
 
END FUNCTION
 
FUNCTION i121_ima06(p_def) #MOD-490474
 DEFINE p_def        LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01) #MOD-490474
        l_ans        LIKE type_file.chr1,        # No.FUN-680137 VARCHAR(01)
        l_msg        LIKE type_file.chr1000,     # No.FUN-680137 VARCHAR(57)
        l_imz02      LIKE imz_file.imz02,
        l_imzacti    LIKE imz_file.imzacti,
        l_imaacti    LIKE ima_file.imaacti,
        l_imauser    LIKE ima_file.imauser,
        l_imagrup    LIKE ima_file.imagrup,
        l_imamodu    LIKE ima_file.imamodu,
        l_imadate    LIKE ima_file.imadate
 
  LET g_errno = ' '
  LET l_ans=' '
  SELECT imzacti INTO l_imzacti
    FROM imz_file
   WHERE imz01 = g_ima.ima06
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3179'
       WHEN l_imzacti='N' LET g_errno = '9028'
       OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  IF SQLCA.sqlcode =0 AND cl_null(g_errno) AND p_def = 'Y' THEN #MOD-490474
     CALL cl_getmsg('mfg5033',g_lang) RETURNING l_msg
     CALL cl_confirm('mfg5033') RETURNING l_ans
     IF l_ans THEN
        SELECT * INTO g_ima.ima06,l_imz02,g_ima.ima03,g_ima.ima04,
                      g_ima.ima07,g_ima.ima08,g_ima.ima09,g_ima.ima10,
                      g_ima.ima11,g_ima.ima12,g_ima.ima14,g_ima.ima15,
                      g_ima.ima17,g_ima.ima19,g_ima.ima21,
                      g_ima.ima23,g_ima.ima24,g_ima.ima25,g_ima.ima27, #No:7703
                      g_ima.ima28,g_ima.ima31,g_ima.ima31_fac,g_ima.ima34,
                      g_ima.ima35,g_ima.ima36,g_ima.ima37,g_ima.ima38,
                      g_ima.ima39,g_ima.ima42,g_ima.ima43,g_ima.ima44,
                      g_ima.ima44_fac,g_ima.ima45,g_ima.ima46,g_ima.ima47,
                      g_ima.ima48,g_ima.ima49,g_ima.ima491,g_ima.ima50,
                      g_ima.ima51,g_ima.ima52,g_ima.ima54,g_ima.ima55,
                      g_ima.ima55_fac,g_ima.ima56,g_ima.ima561,g_ima.ima562,
                      g_ima.ima571,
                      g_ima.ima59, g_ima.ima60,g_ima.ima61,g_ima.ima62,
                      g_ima.ima63, g_ima.ima63_fac,g_ima.ima64,g_ima.ima641,
                      g_ima.ima65, g_ima.ima66,g_ima.ima67,g_ima.ima68,
                      g_ima.ima69, g_ima.ima70,g_ima.ima71,g_ima.ima86,
                      g_ima.ima86_fac, g_ima.ima87,g_ima.ima871,g_ima.ima872,
                      g_ima.ima873, g_ima.ima874,g_ima.ima88,g_ima.ima89,
                      g_ima.ima90,g_ima.ima94,g_ima.ima99,g_ima.ima100,     #NO:6842養生
                      g_ima.ima101,g_ima.ima102,g_ima.ima103,g_ima.ima105,  #NO:6842養生
                      g_ima.ima106,g_ima.ima107,g_ima.ima108,g_ima.ima109,  #NO:6842養生
                      g_ima.ima110,g_ima.ima130,g_ima.ima131,g_ima.ima132,  #NO:6842養生
                      g_ima.ima133,g_ima.ima134,g_ima.ima154,g_ima.ima155,              #NO:6842養生   NO.FUN-680034   #MOD-890031拿掉g_ima.ima1321  #FUN-870100
                      g_ima.ima147,g_ima.ima148,g_ima.ima903,
                      l_imaacti,l_imauser,l_imagrup,l_imamodu,l_imadate,
                      g_ima.ima906,g_ima.ima907,g_ima.ima908,g_ima.ima909,#FUN-540025
                      g_ima.ima911,g_ima.ima136,g_ima.ima137,g_ima.ima391,
                      g_ima.ima1321,g_ima.ima915,g_ima.ima150,g_ima.ima152,
                      g_ima.imaud01,g_ima.imaud02,g_ima.imaud03,g_ima.imaud04,
                      g_ima.imaud05,g_ima.imaud06,g_ima.imaud07,g_ima.imaud08,
                      g_ima.imaud09,g_ima.imaud10,g_ima.imaud11,g_ima.imaud12,
                      g_ima.imaud13,g_ima.imaud14,g_ima.imaud15
          FROM imz_file
         WHERE imz01 = g_ima.ima06
        IF g_ima.ima99 IS NULL THEN LET g_ima.ima99 = 0 END IF
        IF g_ima.ima133 IS NULL THEN LET g_ima.ima133 = g_ima.ima01 END IF
        IF g_ima.ima01[1,4]='MISC' THEN #NO:6808(養生)
           LET g_ima.ima08='Z'
        END IF
        IF cl_null(g_errno)  AND l_ans ="1"  THEN    #No.MOD-490054
           DISPLAY BY NAME 
               g_ima.ima01,g_ima.ima02,g_ima.ima021,
               g_ima.ima08,g_ima.ima06,
               g_ima.ima05,g_ima.ima25,g_ima.ima31,g_ima.ima31_fac,
               g_ima.ima03,g_ima.ima04,
               g_ima.ima1004,g_ima.ima1005,g_ima.ima1006,                                                                                  
               g_ima.ima1007,g_ima.ima1008,g_ima.ima1009,       
               g_ima.ima130,g_ima.ima131,
               g_ima.ima1010,   
               g_ima.ima09,g_ima.ima10,g_ima.ima11,
               g_ima.ima18,g_ima.ima134,g_ima.ima154,g_ima.ima155,g_ima.ima133,g_ima.ima132,g_ima.ima1321,  #FUN-870100
               g_ima.ima138,g_ima.ima148,g_ima.ima35,g_ima.ima36,
               g_ima.ima121,g_ima.ima122,g_ima.ima123,g_ima.ima124,
               g_ima.ima125,g_ima.ima126,g_ima.ima127,g_ima.ima128,
               g_ima.ima98,g_ima.ima33,g_ima.ima135,g_ima.ima141,   
               g_ima.ima142,g_ima.ima143,g_ima.ima144,g_ima.ima145,
               g_ima.ima1024,g_ima.ima1025,g_ima.ima1026,g_ima.ima1028,                                                                   
               g_ima.ima1027,g_ima.ima1019,g_ima.ima1020,g_ima.ima1021,                                                                   
               g_ima.ima1023,g_ima.ima1022,    
               g_ima.ima1017,g_ima.ima1018,  
               g_ima.imauser,g_ima.imagrup,g_ima.imamodu,
               g_ima.imadate,g_ima.imaacti,
               g_ima.imaud01,g_ima.imaud02,g_ima.imaud03,g_ima.imaud04,
               g_ima.imaud05,g_ima.imaud06,g_ima.imaud07,g_ima.imaud08,
               g_ima.imaud09,g_ima.imaud10,g_ima.imaud11,g_ima.imaud12,
               g_ima.imaud13,g_ima.imaud14,g_ima.imaud15
        END IF
     END IF
  END IF
END FUNCTION
 
FUNCTION i120_ima(p_key1,p_key2)
    DEFINE p_key1   LIKE tqa_file.tqa01
    DEFINE p_key2   LIKE tqa_file.tqa03
    DEFINE l_tqa02  LIKE tqa_file.tqa02
 
    SELECT tqa02 INTO l_tqa02 FROM tqa_file
     WHERE tqa01 = p_key1 AND tqa03 = p_key2
 
    CASE p_key2
         WHEN '1'
           DISPLAY l_tqa02 TO FORMONLY.tqa02b
         WHEN '2'
           DISPLAY l_tqa02 TO FORMONLY.tqa02
         WHEN '3'
           DISPLAY l_tqa02 TO FORMONLY.tqa02a
         WHEN '4'
           DISPLAY l_tqa02 TO FORMONLY.tqa02c
         WHEN '5'
           DISPLAY l_tqa02 TO FORMONLY.tqa02d
         WHEN '6'
           DISPLAY l_tqa02 TO FORMONLY.tqa02e
    END CASE
END FUNCTION
 
FUNCTION i121_set_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(01)
 
   IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ima01,ima05,ima08,ima02,ima021,ima31,ima25",TRUE)   #No.MOD-5C0001       #MOD-9C0178 add
                                                           #TQC-A90034 add ima25
   ELSE
     CALL cl_set_comp_entry("ima31",TRUE)  #TQC-9A0058 
   END IF
 
   IF INFIELD(ima141) OR ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ima142,ima143,ima144,ima145",TRUE)
   END IF
 
END FUNCTION
 
FUNCTION i121_set_no_entry(p_cmd)
   DEFINE p_cmd   LIKE type_file.chr1        # No.FUN-680137 VARCHAR(01)
   DEFINE l_errno LIKE type_file.chr1        # No.FUN-680137 VARCHAR(01)   #No.MOD-5C0001
   DEFINE l_ima151 LIKE ima_file.ima151      #MOD-C30104 add
   DEFINE l_imaag  LIKE ima_file.imaag       #MOD-C30104 add

   IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
      CALL cl_set_comp_entry("ima01,ima05,ima08,ima02,ima021",FALSE)
   END IF
   #當參數設定使用料件申請作業時,修改時不可更改料號/品名/規格
   IF g_aza.aza60 = 'Y' AND p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("ima01,ima02,ima021",FALSE)
   END IF
 
   IF INFIELD(ima141) OR ( NOT g_before_input_done ) THEN
      IF g_ima.ima141 = '0' THEN
         CALL cl_set_comp_entry("ima142,ima143,ima144,ima145",FALSE)
      END IF
   END IF
   IF g_sma.sma115 = 'Y' AND g_ima.ima906='2' THEN  #多單位且為母子單位時，銷售單位=庫存單位且不能修改
     LET g_ima.ima31=g_ima.ima25
     DISPLAY BY NAME g_ima.ima31
     CALL cl_set_comp_entry("ima31,ima31_fac",FALSE) #MOD-7A0050 add ima31_fac
   END IF

#MOD-C30104--add--begin--
   IF s_industry('slk') AND g_azw.azw04 = '2' THEN  #MOD-C30270 add azw04 = '2'
      IF p_cmd = 'u' AND ( NOT g_before_input_done ) THEN
         SELECT ima151,imaag INTO l_ima151,l_imaag FROM ima_file WHERE ima01=g_ima.ima01
         IF l_ima151='N' AND l_imaag='@CHILD' THEN
            CALL cl_set_comp_entry("imaoriu,imaorig,ima02,ima021,ima08,ima06,ima05,ima25,ima31,ima31_fac,
                                    ima03,ima1005,ima1006,ima1004,ima1007,ima1008,ima1009,ima130,ima131,
                                    ima09,ima10,ima11,ima134,ima154,ima155,ima133,ima132,ima1321,ima138,
                                    ima148,ima35,ima36,ima121,ima122,ima123,ima124,ima125,ima126,ima127,
                                    ima128,ima98,ima33,ima135,ima141,ima142,ima143,ima144,ima145,imaslk05,imaslk06,
                                    imaslk07,imaslk08,imaslk10,imaslk09,imaslk11,imaslk01,imaslk02,imaslk03,
                                    imaslk04,ima1024,ima1025,ima1026,ima1028,ima1027,ima1019,ima1020,ima1021,
                                    ima1023,ima1022,ima1017,ima1018,imauser,imagrup,imamodu,imadate,imaacti,
                                    imaud01,imaud02,imaud03,imaud04,imaud05,imaud06,imaud07,imaud08,imaud09,
                                    imaud10,imaud11,imaud12,imaud13,imaud14,imaud15",FALSE)
         END IF
      END IF
   END IF 
#MOD-C30104--add--end-- 
END FUNCTION
 
#show 圖示
FUNCTION i121_show_pic()
     LET g_chr='N'
     IF g_ima.ima1010='1' THEN                                                                                             
         LET g_chr='Y'                                                                                                      
     END IF                                                                                                                
     CALL cl_set_field_pic1(g_chr,""  ,""  ,""  ,""  ,g_ima.imaacti,""    ,"")
                           #確認 ,核准,過帳,結案,作廢,有效         ,申請  ,留置
END FUNCTION
#No:FUN-9C0071--------精簡程式-----

#TQC-B50003--add--str--
FUNCTION i121_chk_ima135()
   DEFINE l_i          LIKE type_file.num5
   DEFINE l_length     LIKE type_file.num5
 
   LET l_length = LENGTH(g_ima.ima135)
   LET g_errno = ' '
 
   IF l_length = 12 OR l_length = 7 THEN
      FOR l_i=1 TO l_length                                                                                                            
         IF g_ima.ima135[l_i] NOT MATCHES "[0-9]" THEN                                                                       
            LET g_errno = 'art-015' 
            RETURN                                                                                                            
         END IF                                                                                                                        
      END FOR
   ELSE
      IF l_length = 13 OR l_length = 8 THEN 
         FOR l_i=1 TO l_length                                                                                                         
            IF g_ima.ima135[l_i] NOT MATCHES "[0-9]" THEN                                                                         
               LET g_errno = 'art-015'  
               RETURN                                                                                              
            END IF                                                                                                                     
         END FOR
         CALL i121_chk_code()
      ELSE
         LET g_errno = 'art-015'   
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION i121_chk_code()
DEFINE l_length      LIKE  type_file.num5,                                                                                          
       l_i           LIKE  type_file.num5,                                                                                          
       l_mod         LIKE  type_file.num5,                                                                                          
       l_num1        LIKE  type_file.num5,                                                                                          
       l_num2        LIKE  type_file.num5,                                                                                          
       l_total       LIKE  type_file.num5,                                                                                          
       l_result      LIKE  type_file.num5,                                                                                          
       l_temp        STRING
 
    LET l_temp = g_ima.ima135
    LET l_temp = l_temp.trim()
    LET g_ima.ima135 = l_temp
    LET l_length = LENGTH(g_ima.ima135)
    LET l_temp = ''
    LET g_errno = ' '
    FOR l_i=1 TO l_length-1
       LET l_temp = l_temp,g_ima.ima135[l_i]
    END FOR
 
    CALL i121_create_code(l_temp) RETURNING l_num1
    LET l_num2 = g_ima.ima135[l_length]
    IF l_num1 != l_num2 THEN
       LET g_errno = 'art-017'
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION i121_create_code(p_code)
DEFINE l_length      LIKE  type_file.num5,
       l_i           LIKE  type_file.num5,
       l_mod         LIKE  type_file.num5,
       l_num1        LIKE  type_file.num5,
       l_num2        LIKE  type_file.num5,
       l_total       LIKE  type_file.num5,
       l_result      LIKE  type_file.num5,
       l_temp        STRING,
       p_code        LIKE  type_file.chr1000
 
    LET l_length = LENGTH(p_code)
    LET l_num1 = 0 
    LET l_num2 = 0 
    FOR l_i=1 TO l_length
       LET l_mod = l_i MOD 2
       IF l_mod = 0 THEN
          LET l_num2 = l_num2 + p_code[l_i]
       ELSE
       	  LET l_num1 = l_num1 + p_code[l_i]
       END IF 
    END FOR 
    
    LET l_total = l_num1 + l_num2*3
    LET l_result = 10 - (l_total MOD 10)
    IF l_result = 10 THEN
       LET l_result = 0
    END IF
    LET l_temp = l_result
    LET l_temp = l_temp.trim()
 
    LET l_result = l_temp
    RETURN l_result
END FUNCTION

#FUN-B90103--start
FUNCTION i121_imc_ins()
 DEFINE l_imx000 LIKE imx_file.imx000   
 DEFINE l_sql    STRING                
 DEFINE l_imc    RECORD LIKE imc_file.* 
 DEFINE l_ima151 LIKE ima_file.ima151

   SELECT ima151 INTO l_ima151  FROM ima_file WHERE ima01=g_ima.ima01 AND ima151='Y'
   LET l_sql="SELECT * FROM imc_file WHERE imc01='",g_ima.ima01,"'"
        PREPARE  imc_ins FROM l_sql
        DECLARE imc_ins_upd CURSOR FOR imc_ins
   IF l_ima151='Y' THEN
     FOREACH imc_ins_upd INTO l_imc.*
        DELETE FROM imc_file WHERE imc01 IN (SELECT imx000 FROM imx_file WHERE imx00=l_imc.imc01)
        IF SQLCA.sqlcode THEN
           CALL cl_err3("del","imc_file",l_imc.imc01,"",SQLCA.sqlcode,"","",1)
           CONTINUE FOREACH
        END IF

        LET l_sql="SELECT imx000 FROM imx_file WHERE imx00='",l_imc.imc01,"'"
             PREPARE  imc_ins1 FROM l_sql
             DECLARE imc_ins1_upd CURSOR FOR imc_ins1
       FOREACH   imc_ins1_upd INTO l_imx000
          LET l_imc.imc01=l_imx000
          INSERT INTO imc_file VALUES(l_imc.*)
         IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","imc_file",l_imc.imc01,"",SQLCA.sqlcode,"","",1)
           CONTINUE FOREACH
         END IF
       END FOREACH
     END FOREACH
   END IF
END FUNCTION
#FUN-B90103--end
#TQC-B50003--add--end--


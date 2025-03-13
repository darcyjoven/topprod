# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: aimi201.4gl
# Descriptions...: 倉儲別資料維護作業
# Date & Author..: 91/10/09 By Nora
# Modify.........: 92/06/18 新增 銷售領料優先順序 (imd15 及 ime11) By Lin
#                           發料/領料優先順序值越小,優先順序越高(By Jeans 說的)
# Modify.........: No.MOD-470041 04/07/20 By Nicola 修改INSERT INTO 語法
# Modify.........: No.MOD-4A0269 04/10/20 By Mandy 1.新增資料時，進入單身前即當出
# Modify.........: No.MOD-4A0269 04/10/20 By Mandy 2.單身set_entry/set_no_entry控管有問題
# Modify.........: No.FUN-4B0002 04/11/02 By Mandy 新增Array轉Excel檔功能
# Modify.........: No.FUN-4C0053 04/12/08 By Mandy Q,U,R 加入權限控管處理
# Modify.........: No.FUN-510017 05/01/13 By Mandy 報表轉XML
# Modify.........: No.MOD-570193 05/08/04 By pengu ime02空白應只可寫入一筆
# Modify.........: No.FUN-580026 05/08/10 By Sarah 在複製裡增加set_entry段
# Modify.........: No.MOD-5A0411 05/11/01 By Sarah 將SLEEP 3改成CALL cl_end(0,0)
# Modify.........: No.TQC-5C0005 05/12/02 By kevin 欄位對齊
# Modify.........: No.TQC-620004 06/04/03 By pengu 當單頭的"MRP考慮否"由"N"變 "Y"時，ima26並沒有去增加mrp庫存數量
# Modify.........: NO.FUN-640266 06/04/26 BY yiting 更改cl_err
# Modify.........: No.MOD-650040 06/05/09 By rainy 取消輸入時的"預設上筆"功能
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-670072 06/07/20 By Sarah 將imd09改成CHECKBOX,新增時預設為Y
# Modify.........: No.FUN-680034 06/08/23 By douzh 增加"存貨科目二","存貨會計科目二"欄位(imd081,ime091)
# Modify.........: No.FUN-690026 06/09/14 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-680046 06/09/27 By jamie 新增action"相關文件"
# Modify.........: No.FUN-680048 06/10/12 By Joe (1)add action(APS相關資料-倉庫;APS相關資料-儲位)
#                                                (2)若與APS整合時,異動資料時,一併異動APS相關資料
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-6B0030 06/11/10 By bnlent  單頭折疊功能修改
# Modify.........: No.TQC-690046 06/12/08 By pengu 修改可用與不可用倉庫更新時，應自動更新img，不再詢問
# Modify.........: NO.TQC-720065 07/03/01 By Judy "發料順序"及"出貨順序"不可小于零
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-720043 07/03/20 By Mandy APS相關調整
# Modify.........: No.FUN-730033 07/03/28 By Carrier 會計科目加帳套
# Modify.........: No.TQC-710110 07/03/29 By Ray "使用方式"為"2"時,存貨會計科目開窗是查找本數據庫的資料,而控管時,卻查找ASMS120與總帳相關聯數據庫中
# Modify.........: No.TQC-740068 07/04/13 By wujie  刪除無單身資料時報錯，但是資料仍然被刪除
# Modify.........: No.TQC-750013 07/05/04 By Mandy 一進入程式,不查詢直接按Action "APS相關資料"時的控管
# Modify.........: No.TQC-790077 07/09/18 By Carrier input時對imd08,imd081加入referece控管
# Modify.........: No.MOD-790105 07/09/26 By Pengu 要delete ime_file時判斷是否已有img_file資料若有則show訊息
# Modify.........: No.FUN-7C0043 07/12/25 By Cockroach 報表改成p_query實現
# Modify.........: NO.FUN-7C0002 08/01/21 BY yiting apsi206.4gl-->apsi305.4gl
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.MOD-850215 08/05/21 By claire 新增時,單身不進直接按確定,不會寫入單身
# Modify.........: No.FUN-870012 08/06/30 by duke set vmf06 to default 0
# Modify.........: No.TQC-880044 08/08/25 BY DUKE UPDATE 時欄位名稱錯誤
# Modify.........: No.FUN-870101 08/09/10 by jamie MES整合
# Modify.........: No.FUN-890085 08/09/18 刪除時需連同vmf_file 資料一併刪除
# Modify.........: No.TQC-8A0052 08/10/17 儲位空白時不呼叫MES
# Modify.........: No.TQC-8B0011 08/11/05 BY duke 呼叫MES前先判斷aza90必須MATCHE [Yy]
# Modify.........: No.FUN-910005 09/01/06 BY DUKE 串接 apsi305時,新增 vmf_file.vmf07 = 0,串接 apsi306時,新增 vmg_file.vmg06 = 0 
# Modify.........: No.FUN-920053 09/02/11 by jan 呼叫s_upd_ime_img.4gl
# Modify.........: No.FUN-930109 09/02/16 by xiaofeizhu 增加action:維護倉管員。單身增加字段:限定倉管員
# Modify.........: No.MOD-950046 09/05/07 By lutingting 成本類別欄位改為edit型態,所以取消default值為'Y'得程序段 
# Modify.........: No.FUN-940083 09/05/12 by zhaijie單身增加字段:VIM特性
# Modify.........: No.TQC-950003 09/05/15 By Cockroach 跨庫SQL一律改為調用s_dbstring() 
# Modify.........: No.CHI-940047 09/06/10 By jan img_file存在時，理應倉儲批資料不可被刪除(不需詢問)
# Modify.........: No.FUN-960141 09/07/24 By dongbg 增加代銷科目欄位
# Modify.........: No.TQC-970385 09/07/30 By sherry 無效的資料不可以刪除    
# Modify.........: No.FUN-980004 09/08/06 By TSD.Ken GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.MOD-980169 09/08/20 By lilingyu ime08不是必輸,維護單身時,若ime08為空,刪除時顯示已經刪掉,但實際并沒有刪除
# Modify.........: No.TQC-980147 09/08/20 By lilingyu imd18,imd19,imdpos三個非NULL字段賦初值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-980020 09/09/17 By douzh GP5.2集團架構調整,sub相關修傳參改
# Modify.........: No.FUN-980025 09/09/27 By dxfwo p_qry 跨資料庫查詢
# Modify.........: No.FUN-9A0068 09/10/29 By destiny 单身不能删除时，显示错误信息
# Modify.........: No.FUN-9C0109 09/12/24 By lutingting 只有當業態為零售時才顯示代銷科目 
# Modify.........: No.FUN-A10001 10/01/09 By dxfwo  VMI 過單專用
# Modify.........: No.FUN-9C0072 10/01/14 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No.FUN-A40023 10/04/09 By vealxu 保留img_file的異動部分
# Modify.........: No.TQC-A50080 10/05/19 By destiny 如果单身无值点维护仓管员程序会荡出
# Modify.........: No.TQC-A50098 10/06/17 By lilingyu 在BEFORE FIELD ime12 和AFTER FIELD ime12條件處有無窮迴圈
# Modify.........: No.FUN-B10049 11/01/24 By destiny 科目查詢自動過濾
# Modify.........: No.TQC-B20124 11/02/21 By destiny 新增时imd22没有预设值
# Modify.........: No.TQC-B20122 11/02/21 By destiny 无资料时不能点限定仓管员  
# Modify.........: No.FUN-B30211 11/04/01 By yangtingting   未加離開前得cl_used(2)
# Modify...........No:FUN-9A0056 11/04/13 By abby MES整合功能加強
# Modify.........: No.FUN-B50062 11/05/24 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80093 11/10/03 By pauline 控管VIM相關欄位											


# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.CHI-C30002 12/05/18 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No:FUN-C30027 12/08/13 By bart 複製後停在新料號畫面
# Modify.........: No:TQC-C80131 12/08/22 By qiull 倉庫欄位查詢時增加開窗
# Modify.........: No:FUN-C80107 12/10/30 By suncx 新增imd23
# Modify.........: No.FUN-CB0052 12/11/15 By imd10欄位增加發票倉選項
# Modify.........: No.FUN-D10143 13/01/28 By suncx 新增imd23相關邏輯
# Modify.........: No.FUN-D30024 13/03/12 By lixh1 imd23改由aimi200新增
# Modify.........: No:FUN-D40030 13/04/07 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:FUN-D40103 13/05/06 By fengrui 庫位添加有效碼
# Modify.........: No:TQC-D50086 13/07/15 By qirl 直接由此處錄入倉庫後，imd20歸屬營運中心為NULL

DATABASE ds
 
GLOBALS "../../config/top.global"
#模組變數(Module Variables)
DEFINE 
    g_imd    RECORD LIKE imd_file.*,         #倉庫別資料檔
    g_imd_t  RECORD LIKE imd_file.*,         #倉庫別資料檔(舊值)
    g_imd_o  RECORD LIKE imd_file.*,         #倉庫別資料檔(舊值)
    g_imd01_t       LIKE imd_file.imd01,     #倉庫別(舊值)
    g_ime           DYNAMIC ARRAY OF RECORD  #倉儲庫存資料主檔
        ime02       LIKE ime_file.ime02,   #存放位置
        ime03       LIKE ime_file.ime03,   #存放位置名稱
        ime04       LIKE ime_file.ime04,   #類別
        ime05       LIKE ime_file.ime05,   #可用否
        ime06       LIKE ime_file.ime06,   #MRP可用否
        ime07       LIKE ime_file.ime07,   #保稅否
        ime12       LIKE ime_file.ime12,   #VIM特性
        ime08       LIKE ime_file.ime08,   #會計科目使用方式
        ime09       LIKE ime_file.ime09,   #倉儲所屬會計科目
        ime091      LIKE ime_file.ime091,  #倉儲所屬會計科目二          #FUN-680034
        ime13       LIKE ime_file.ime13,   #倉儲所屬代銷科目            #FUN-960141
        ime131      LIKE ime_file.ime131,  #倉儲所屬代銷科目二          #FUN-960141
        ime10       LIKE ime_file.ime10,   #發料順序
        ime11       LIKE ime_file.ime11,   #發料順序
        ime17       LIKE ime_file.ime17,   #FUN-930109
        imeacti     LIKE ime_file.imeacti  #有效碼                      #FUN-D40103 add
                    END RECORD,
    g_ime_t         RECORD                 #倉儲庫存資料檔 (舊值)
        ime02       LIKE ime_file.ime02,   #存放位置
        ime03       LIKE ime_file.ime03,   #存放位置名稱
        ime04       LIKE ime_file.ime04,   #類別
        ime05       LIKE ime_file.ime05,   #可用否
        ime06       LIKE ime_file.ime06,   #MRP可用否
        ime07       LIKE ime_file.ime07,   #保稅否
        ime12       LIKE ime_file.ime12,   #VIM特性
        ime08       LIKE ime_file.ime08,   #會計科目使用方式
        ime09       LIKE ime_file.ime09,   #倉儲所屬會計科目
        ime091      LIKE ime_file.ime091,  #倉儲所屬會計科目二          #FUN-680034
        ime13       LIKE ime_file.ime13,   #倉儲所屬代銷科目            #FUN-960141
        ime131      LIKE ime_file.ime131,  #倉儲所屬代銷科目二          #FUN-960141
        ime10       LIKE ime_file.ime10,   #發料順序
        ime11       LIKE ime_file.ime11,   #發料順序
        ime17       LIKE ime_file.ime17,   #FUN-930109
        imeacti     LIKE ime_file.imeacti  #有效碼                      #FUN-D40103 add
                    END RECORD,
    g_wc,g_sql,g_wc2    string,                #No.FUN-580092 HCN
    g_argv1             LIKE imd_file.imd01,   #倉庫別
    g_argv2             LIKE type_file.chr1,   #是否具有新增功能(ASM#41)  #No.FUN-690026 VARCHAR(1)
    g_rec_b             LIKE type_file.num5,   #單身筆數  #No.FUN-690026 SMALLINT
    g_flag              LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
    l_ac                LIKE type_file.num5,   #目前處理的ARRAY CNT  #No.FUN-690026 SMALLINT
    g_yn                LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
    g_mrp_yn            LIKE type_file.chr1,   #No.TQC-620004 add  #No.FUN-690026 VARCHAR(1)
    g_num_args          LIKE type_file.num5    #NUM_ARGS() #BugNo:6598  #No.FUN-690026 SMALLINT
 
DEFINE p_row,p_col         LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_before_input_done LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_forupd_sql        STRING                 #SELECT ... FOR UPDATE SQL
DEFINE g_chr               LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_cnt               LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_i                 LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_msg               LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(72)
DEFINE g_row_count         LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_curs_index        LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE g_jump              LIKE type_file.num10   #No.FUN-690026 INTEGER
DEFINE mi_no_ask           LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_cmd               LIKE type_file.chr1000 #FUN-680048 
DEFINE g_flag1             LIKE type_file.chr1    #FUN-680048 
DEFINE g_azp03             LIKE azp_file.azp03    #No.TQC-710110
DEFINE g_db1               LIKE type_file.chr21   #No.TQC-710110
DEFINE g_bookno1           LIKE aza_file.aza81    #No.FUN-730033
DEFINE g_bookno2           LIKE aza_file.aza82    #No.FUN-730033
DEFINE g_dbsm              LIKE type_file.chr21   #No.FUN-730033
DEFINE g_plantm            LIKE type_file.chr10   #No.FUN-980020
DEFINE g_db_type           LIKE type_file.chr3    #No.FUN-730033
DEFINE g_flag3             LIKE type_file.chr1    #單頭是否為新增資料  #FUN-9A0056 add
 
#主程式開始
MAIN
 
   OPTIONS                                #改變一些系統預設值
       INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
 
 
   #若非多倉儲管理,無法執行本程式
   IF g_sma.sma12 NOT MATCHES '[Yy]' THEN
      OPEN WINDOW i201_w1 AT 16,20 WITH 3 ROWS, 40 COLUMNS
      CALL cl_getmsg('mfg1007',g_lang) RETURNING g_msg
      DISPLAY g_msg AT 2,1
      CALL cl_end(0,0)   #MOD-5A0411
      CLOSE WINDOW i201_w1
      EXIT PROGRAM 
   END IF
   LET g_argv1 = ARG_VAL(1)               #倉庫別
   LET g_argv2 = ARG_VAL(2)
   LET g_num_args = NUM_ARGS()
   IF g_num_args != 0 AND g_sma.sma39 = 'N' THEN 
      CALL cl_err('','mfg1020',3) 
      EXIT PROGRAM 
   END IF
   CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
   LET g_imd01_t = NULL                   #清除鍵值
   INITIALIZE g_imd_t.* TO NULL
   INITIALIZE g_imd.* TO NULL
   LET p_row = 2 LET p_col = 8
 
   OPEN WINDOW i201_w AT p_row,p_col           #顯示畫面
     WITH FORM "aim/42f/aimi201"
      ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   
   CALL cl_ui_init()
   CALL cl_set_comp_visible("imd081,ime091",g_aza.aza63='Y')   #FUN-680034 

   IF g_azw.azw04 = '2' THEN
      IF g_aza.aza63 = 'Y' THEN
         CALL cl_set_comp_visible("imd21,imd211,ime13,ime131",TRUE)
      ELSE
         CALL cl_set_comp_visible("imd21,ime13",TRUE)
         CALL cl_set_comp_visible("imd211,ime131",FALSE)
      END IF
   ELSE
      CALL cl_set_comp_visible("imd21,imd211,ime13,ime131",FALSE)
   END IF
#FUN-D30024 --------Begin----------
#  #FUN-D10143 add begin------------------------
#  IF g_sma.sma894 = 'NNNNNNNN' THEN
#     CALL cl_set_comp_visible('imd23',FALSE)
#  END IF
#  #FUN-D10143 add end -------------------------
#FUN-D30024 --------End------------
# FUN-B80093 add START											
  IF g_sma.sma93="Y" THEN											
     CALL cl_set_comp_visible("ime12", TRUE)											
  ELSE											
     CALL cl_set_comp_visible("ime12", FALSE)											
  END IF											
# FUN-B80093 add END											

   IF g_argv1 != ' ' THEN CALL i201_q() END IF
 
   LET g_forupd_sql = 
          "SELECT * FROM imd_file WHERE imd01 = ? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i201_cl CURSOR FROM g_forupd_sql 
   LET g_flag1 = 'N'  #FUN-680048
   LET g_flag3 = 'N'  #FUN-9A0056 add
   CALL i201_bookno() #No.FUN-730033
   CALL i201_menu()
   CLOSE WINDOW i201_w                 #結束畫面
   CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0074
         RETURNING g_time    #No.FUN-6A0074
END MAIN
 
#QBE 查詢資料
FUNCTION i201_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    IF cl_null(g_argv1) OR g_argv1 IS NULL THEN
       CLEAR FORM                             #清除畫面
       CALL g_ime.clear()
       CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
       CONSTRUCT BY NAME g_wc ON 
                    imd01,imd02,imd06,imd07,imd03,#螢幕上取單頭條件
                    imd10,imd11,imd13,imd12,imd14,imd15,
                  # imd08,imd081,imd21,imd211,imd09,imd23, #FUN-680034--加imd081 #FUN-960141 加imd21,imd211 #FUN-D10143 add imd23
                    imd08,imd081,imd21,imd211,imd09,       #FUN-D30024 mark imd23
                    imduser,imdgrup,imdmodu,imddate,imdacti
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION CONTROLP 
            #TQC-C80131  add   start
            IF INFIELD(imd01) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_imd01"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imd01
            END IF
            #TQC-C80131  add   end
            IF INFIELD(imd08) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aag"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imd08
            END IF
            IF INFIELD(imd081) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form     = "q_aag"                                                                                    
               LET g_qryparam.state    = "c"                                                                                        
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO imd081                                                                                 
            END IF
            IF INFIELD(imd21) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aag"
               LET g_qryparam.state    = "c"
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO imd21
            END IF
            IF INFIELD(imd211) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form     = "q_aag"                                                                                    
               LET g_qryparam.state    = "c"                                                                                        
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                   
               DISPLAY g_qryparam.multiret TO imd211                                                                                 
            END IF
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
	   CALL cl_qbe_list() RETURNING lc_qbe_sn
	   CALL cl_qbe_display_condition(lc_qbe_sn)
 
       END CONSTRUCT
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('imduser', 'imdgrup') #FUN-980030
       
       IF INT_FLAG THEN RETURN END IF
       CALL g_ime.clear()
       CONSTRUCT g_wc2 ON ime02,ime03,imed04,ime05,ime06,  #螢幕上取單身條件
                          ime07,ime12,ime08,ime09,ime091,
                          ime13,ime131,    #FUN-960141
                          ime10,ime11,ime17,imeacti           #FUN-680034--加ime091  #FUN-930109 Add ime17  #FUN-940083 add ime12  #FUN-D40103 imeacti 
          FROM s_ime[1].ime02,s_ime[1].ime03,s_ime[1].ime04,s_ime[1].ime05,
               s_ime[1].ime06,s_ime[1].ime07,s_ime[1].ime12,s_ime[1].ime08,s_ime[1].ime09,  #FUN-940083 add ime12   
               s_ime[1].ime091,
               s_ime[1].ime13,s_ime[1].ime131,  #FUN-960141 add
               s_ime[1].ime10,s_ime[1].ime11,s_ime[1].ime17,s_ime[1].imeacti    #FUN-680034--加ime091  #FUN-930109 Add ime17 #FUN-D40103 imeacti
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
        ON ACTION CONTROLP
           CASE WHEN INFIELD(ime09) #會計科目
             IF g_sma.sma03='Y' THEN
                LET g_db1 = g_sma.sma87
             ELSE
                LET g_db1 = g_plant
             END IF
             SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
              WHERE azp01=g_db1
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_aag1"     #No.TQC-710110
              LET g_qryparam.plant = g_db1       #No.FUN-980025 add   
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO g_ime[1].ime09 
              NEXT FIELD ime09
           END CASE
           CASE WHEN INFIELD(ime091) #會計科目                                                                                       
              IF g_sma.sma03='Y' THEN
                 LET g_db1 = g_sma.sma87
              ELSE
                 LET g_db1 = g_plant
              END IF
              SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
               WHERE azp01=g_db1
               CALL cl_init_qry_var()                                                                                                
               LET g_qryparam.form     = "q_aag1"     #No.TQC-710110
               LET g_qryparam.plant = g_db1       #No.FUN-980025 add   
               LET g_qryparam.state    = "c"                                                                                         
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                    
               DISPLAY g_qryparam.multiret TO g_ime[1].ime091                                                                         
               NEXT FIELD ime091                                                                                                      
            END CASE
           CASE WHEN INFIELD(ime13) #代銷科目
             IF g_sma.sma03='Y' THEN
                LET g_db1 = g_sma.sma87
             ELSE
                LET g_db1 = g_plant
             END IF
             SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
              WHERE azp01=g_db1
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_aag1"    
              LET g_qryparam.plant = g_db1       #No.FUN-980025 add   
              LET g_qryparam.state    = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO g_ime[1].ime13 
              NEXT FIELD ime13
           END CASE
           CASE WHEN INFIELD(ime131) #代銷科目                                                                                       
              IF g_sma.sma03='Y' THEN
                 LET g_db1 = g_sma.sma87
              ELSE
                 LET g_db1 = g_plant
              END IF
              SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
               WHERE azp01=g_db1
               CALL cl_init_qry_var()                                                                                                
               LET g_qryparam.form     = "q_aag1"
               LET g_qryparam.plant = g_db1       #No.FUN-980025 add   
               LET g_qryparam.state    = "c"                                                                                         
               CALL cl_create_qry() RETURNING g_qryparam.multiret                                                                    
               DISPLAY g_qryparam.multiret TO g_ime[1].ime131
               NEXT FIELD ime131 
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
       
        ON ACTION qbe_save
           CALL cl_qbe_save()
 
       END CONSTRUCT
 
       IF INT_FLAG THEN  RETURN END IF
    ELSE
      LET g_wc = " imd01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"
    END IF
 
    IF g_wc2 = " 1=1" THEN			# 若單身未輸入條件
       LET g_sql = "SELECT  imd01 FROM imd_file ",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY imd01"
    ELSE					# 若單身有輸入條件
       LET g_sql = "SELECT UNIQUE imd_file. imd01 ",
                  "  FROM imd_file, ime_file ",
                  " WHERE imd01 = ime01",
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY imd01"
    END IF
    PREPARE i201_prepare FROM g_sql
    IF SQLCA.sqlcode THEN CALL cl_err('prepare:',SQLCA.sqlcode,0) 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
       EXIT PROGRAM END IF
    DECLARE i201_cs                         #SCROLL CURSOR
        SCROLL CURSOR WITH HOLD FOR i201_prepare
    IF g_wc2 = " 1=1" THEN			# 取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM imd_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(distinct imd01)", 
                  " FROM imd_file,ime_file WHERE ",
                  " imd01=ime01 AND ",g_wc CLIPPED,
                  " AND ",g_wc2 CLIPPED 
    END IF
    PREPARE i201_precount FROM g_sql
    DECLARE i201_count CURSOR FOR i201_precount
END FUNCTION
 
FUNCTION i201_menu()
 
   WHILE TRUE
      CALL i201_bp("G")
      CASE g_action_choice
         WHEN "insert" 
            IF cl_chk_act_auth() THEN 
               CALL i201_a()
            END IF
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i201_q()
            END IF
         WHEN "delete" 
            IF cl_chk_act_auth() THEN
               CALL i201_r()
            END IF
         WHEN "modify" 
            IF cl_chk_act_auth() THEN
               CALL i201_u()
            END IF
         WHEN "invalid" 
            IF cl_chk_act_auth() THEN
               CALL i201_x()
               CALL cl_set_field_pic("","","","","",g_imd.imdacti)
            END IF
         WHEN "reproduce" 
            IF cl_chk_act_auth() THEN
               CALL i201_copy()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i201_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            IF cl_chk_act_auth() THEN
               CALL i201_out()
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"     
            CALL cl_cmdask()
         WHEN "exporttoexcel" #FUN-4B0002
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ime),'','')
            END IF
         WHEN "related_document"  #相關文件
            IF cl_chk_act_auth() THEN
               IF g_imd.imd01 IS NOT NULL THEN
                 LET g_doc.column1 = "imd01"
                 LET g_doc.value1 = g_imd.imd01
                 CALL cl_doc()
               END IF
           END IF
 
         WHEN "aps_related_warehouse"  #APS相關資料-倉庫 
            IF cl_chk_act_auth() THEN
                CALL i201_aps_warehouse()
            END IF
         WHEN "aps_related_location"   #APS相關資料-儲位
            IF cl_chk_act_auth() THEN
                CALL i201_aps_location()
            END IF
         
         WHEN "maintenance_administrators"
            IF cl_chk_act_auth() THEN
               #TQC-B20122--begin
               IF cl_null(g_imd.imd01) THEN 
                  CALL cl_err('','-400',0)
                 #RETURN
                  LET g_action_choice=NUll 
               ELSE 
               #TQC-B20122--end
                #No.TQC-A50080
                IF cl_null(g_ime[l_ac].ime02) AND cl_null(g_ime[l_ac].ime17) THEN 
                   CALL cl_err('','aim-008',1)
                   LET g_action_choice = NULL
                #No.TQC-A50080 
                ELSE
                   CALL saimi201(g_imd.imd01,g_ime[l_ac].ime02,g_ime[l_ac].ime17)
                END IF 
               END IF     
            END IF
         
      END CASE
   END WHILE
END FUNCTION
 
 
#Add  輸入
FUNCTION i201_a()
    LET g_flag3 = 'N'  #FUN-9A0056 add
    MESSAGE ""
    IF s_shut(0) THEN RETURN END IF
 
    #若非由MENU進入本程式,則無新增之功能
    IF g_argv2 != ' ' THEN RETURN END IF
    CLEAR FORM                                   # 清螢墓欄位內容
    CALL g_ime.clear()
    INITIALIZE g_imd.* LIKE imd_file.*
    LET g_imd01_t = NULL
    LET g_imd_t.*=g_imd.*
    LET g_imd.imd14 = 0                          #DEFAULT
    LET g_imd.imd15 = 0                          #DEFAULT
    LET g_imd.imd17 = 'N'                        #DEFAULT   #FUN-940083 add
    LET g_imd.imd18 = '0'
    LET g_imd.imd19 = 'N'
    LET g_imd.imdpos = 'N'
    LET g_imd.imd20 = g_plant  #TQC-D50086--add--
    LET g_imd.imd22 ='N'  #TQC-B20124
    LET g_imd.imd23 ='N'  #FUN-D10143
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_imd.imdacti ='Y'                   #有效的資料
        LET g_imd.imd23   = 'N'                  #FUN-C80107 add 
        LET g_imd.imduser = g_user
        LET g_imd.imdoriu = g_user #FUN-980030
        LET g_imd.imdorig = g_grup #FUN-980030
        LET g_imd.imdgrup = g_grup               #使用者所屬群
        LET g_imd.imddate = g_today
        CALL i201_i("a")                      # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
           INITIALIZE g_imd.* TO NULL
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_ime.clear()
            EXIT WHILE
        END IF
        IF g_imd.imd01 IS NULL THEN                # KEY 不可空白
            CONTINUE WHILE
        END IF
        LET g_success = 'Y'                        #FUN-9A0056 add
        BEGIN WORK                                 #FUN-9A0056 add
        INSERT INTO imd_file VALUES(g_imd.*)       # DISK WRITE
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","imd_file",g_imd.imd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            LET g_success = 'N'                        #FUN-9A0056 add
           #CONTINUE WHILE                             #FUN-9A0056 mark
        ELSE                                           #FUN-9A0056 add
            LET g_flag3 = 'Y'                          #FUN-9A0056 add
        END IF
       #FUN-9A0056 add begin --
        IF g_success = 'Y' THEN
          #呼叫MES函式新增倉庫資料
           IF g_aza.aza90 MATCHES "[Yy]" THEN
             CALL i201_mes('insert',g_imd.imd01,1)
           END IF
        END IF

        IF g_success = 'N' THEN
           ROLLBACK WORK
           CONTINUE WHILE
        ELSE
           COMMIT WORK
        END IF
       #FUN-9A0056 add end ----
        SELECT imd01 INTO g_imd.imd01 FROM imd_file
            WHERE imd01 = g_imd.imd01
        LET g_imd01_t = g_imd.imd01        #保留舊值
        LET g_imd_t.* = g_imd.*
        CALL g_ime.clear()
        LET g_rec_b =0
        CALL i201_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION i201_i(p_cmd)
    DEFINE
        l_utime         LIKE type_file.chr1,   #檢查是否第一次更改  #No.FUN-690026 VARCHAR(1)
        l_dir1          LIKE type_file.chr1,   #CURSOR JUMP DIRECTION  #No.FUN-690026 VARCHAR(1)
        l_dir2          LIKE type_file.chr1,   #CURSOR JUMP DIRECTION  #No.FUN-690026 VARCHAR(1)
        l_sw            LIKE type_file.chr1,   #檢查必要欄位是否空白  #No.FUN-690026 VARCHAR(1)
        p_cmd           LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
        l_n             LIKE type_file.num5    #No.FUN-690026 SMALLINT
 
    LET l_utime = 'Y'
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030 
    INPUT BY NAME g_imd.imd01,g_imd.imd02,g_imd.imd06,g_imd.imd07, g_imd.imd03, g_imd.imdoriu,g_imd.imdorig,
                  g_imd.imd10,g_imd.imd11,
                  g_imd.imd13,g_imd.imd12,g_imd.imd14,g_imd.imd15,
               #  g_imd.imd08,g_imd.imd081,g_imd.imd21,g_imd.imd211,g_imd.imd09,g_imd.imd23,g_imd.imduser,g_imd.imdgrup,    #FUN-680034--加imd081   #FUN-960141 加imd21,imd211 #FUN-D10143 add imd23
                  g_imd.imd08,g_imd.imd081,g_imd.imd21,g_imd.imd211,g_imd.imd09,g_imd.imduser,g_imd.imdgrup,                #FUN-D30024 mark imd23
                  g_imd.imdmodu,g_imd.imddate,g_imd.imdacti
                  WITHOUT DEFAULTS 
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL i201_set_entry(p_cmd)
            CALL i201_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
        AFTER FIELD imd01
            IF p_cmd = "a" THEN       # 若輸入KEY值不可重複
                SELECT count(*) INTO l_n FROM imd_file
                    WHERE imd01 = g_imd.imd01
                IF l_n > 0 THEN                  # Duplicated
                    CALL cl_err(g_imd.imd01,-239,0)
                    LET g_imd.imd01 = g_imd01_t
                    DISPLAY BY NAME g_imd.imd01 
                    NEXT FIELD imd01
                END IF
            END IF
        AFTER FIELD imd10  #不可空白
            IF g_imd.imd10 NOT MATCHES '[SsWwIi]' THEN    #FUN-CB0052 add Ii
               NEXT FIELD imd10
            END IF
        #FUN-CB0052---add---str---
        ON CHANGE imd10
           IF NOT cl_null(g_imd.imd10) THEN
              IF g_imd.imd10 MATCHES '[Ii]' THEN
                 LET g_imd.imd11 = 'N'
                 LET g_imd.imd12 = 'N'
              #  LET g_imd.imd23 = 'Y'                               #FUN-D10143 add          #FUN-D30024 mark
              #  DISPLAY BY NAME g_imd.imd11,g_imd.imd12,g_imd.imd23 #FUN-D10143 add imd23    #FUN-D30024 mark
                 DISPLAY BY NAME g_imd.imd11,g_imd.imd12             #FUN-D30024 mark imd23
              #  CALL cl_set_comp_entry("imd11,imd12,imd23",FALSE)   #FUN-D10143 add imd23    #FUN-D30024 mark
                 CALL cl_set_comp_entry("imd11,imd12",FALSE)         #FUN-D30024
              ELSE
              #FUN-D30024 ----------Begin----------
              #  #FUN-D10143 add begin----------------
              #  IF cl_null(g_imd_t.imd23) OR g_imd_t.imd10 MATCHES '[Ii]' THEN 
              #     LET g_imd.imd23 = 'N'
              #  ELSE
              #     LET g_imd.imd23 = g_imd_t.imd23
              #  END IF 
              #  DISPLAY BY NAME g_imd.imd23
              #  #FUN-D10143 add end------------------
              #  CALL cl_set_comp_entry("imd11,imd12,imd23",TRUE)    #FUN-D10143 add imd23
                 CALL cl_set_comp_entry("imd11,imd12",TRUE)
              #FUN-D30024 ----------End------------
              END IF
           END IF
        #FUN-CB0052---add---end-- 

        AFTER FIELD imd11  #不可空白
            IF g_imd.imd11 NOT MATCHES '[YyNn]' THEN
               NEXT FIELD imd11
            END IF
 
            LET l_dir1 = 'U'
 
       AFTER FIELD imd12  #不可空白
            IF g_imd.imd12 NOT MATCHES '[YyNn]' THEN
               NEXT FIELD imd12
            END IF
 
        AFTER FIELD imd13  #不可空白
            IF g_imd.imd13 NOT MATCHES '[YyNn]' THEN
               NEXT FIELD imd13
            END IF
            LET l_dir1 = 'D'
            LET l_dir2='D'

        AFTER FIELD imd14
            IF g_imd.imd14 IS NULL THEN                                         
               LET g_imd.imd14 = 0                                              
               DISPLAY BY NAME g_imd.imd14                                      
            END IF
            IF g_imd.imd14 < 0 THEN
               CALL cl_err('g_imd.imd14','aim1007',0)
               NEXT FIELD imd14
            END IF
 
        AFTER FIELD imd15
            IF g_imd.imd15 IS NULL THEN                                         
               LET g_imd.imd15 = 0                                              
               DISPLAY BY NAME g_imd.imd15                                      
            END IF
            IF g_imd.imd15 < 0 THEN
               CALL cl_err('g_imd.imd15','aim1007',0)
               NEXT FIELD imd15
            END IF
 
        AFTER FIELD imd08
            IF g_imd.imd08 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  IF NOT s_actchk3(g_imd.imd08,g_bookno1) THEN  #No.FUN-730033
                     CALL cl_err(g_imd.imd08,'mfg0018',0)
                     #FUN-B10049--begin
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_imd.imd08  
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_bookno1  
                     LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imd.imd08 CLIPPED,"%' "                               
                     CALL cl_create_qry() RETURNING g_imd.imd08
                     DISPLAY BY NAME g_imd.imd08
                     #FUN-B10049--end                         
                     NEXT FIELD imd08
                  END IF
               END IF
            END IF
 
        AFTER FIELD imd081                                                                                                           
            IF g_imd.imd081 IS NOT NULL THEN                                                                                       
               IF g_sma.sma03='Y' THEN                                                                                                  
                  IF NOT s_actchk3(g_imd.imd081,g_bookno2) THEN    #No.FUN-730033  
                     CALL cl_err(g_imd.imd081,'mfg0018',0)     
                     #FUN-B10049--begin
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form ="q_aag"                                   
                     LET g_qryparam.default1 = g_imd.imd081  
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg1 = g_bookno2  
                     LET g_qryparam.where = " aagacti='Y' AND aag01 LIKE '",g_imd.imd081 CLIPPED,"%' "                               
                     CALL cl_create_qry() RETURNING g_imd.imd081
                     DISPLAY BY NAME g_imd.imd081
                     #FUN-B10049--end                                                                                           
                     NEXT FIELD imd081                                                                                              
                  END IF                                                                                                                
               END IF                                                                                                                   
            END IF
        AFTER FIELD imd21
            IF g_imd.imd21 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  IF NOT s_actchk3(g_imd.imd21,g_bookno1) THEN
                     CALL cl_err(g_imd.imd21,'mfg0018',0)
                     NEXT FIELD imd21
                  END IF
               END IF
            END IF
        AFTER FIELD imd211                                                                                                           
            IF g_imd.imd211 IS NOT NULL THEN                                                                                       
               IF g_sma.sma03='Y' THEN                                                                                                  
                  IF NOT s_actchk3(g_imd.imd211,g_bookno2) THEN    #No.FUN-730033  
                     CALL cl_err(g_imd.imd211,'mfg0018',0)                                                                         
                     NEXT FIELD imd211                                                                                              
                  END IF                                                                                                                
               END IF                                                                                                                   
            END IF
       #FUN-D30024 ---------Begin----------
       ##FUN-D10143 add ---begin---------------------
       #AFTER FIELD imd23
       #   IF g_imd.imd23 NOT MATCHES '[YN]' THEN
       #       NEXT FIELD imd23
       #   END IF
       ##FUN-D10143 add ---end-----------------------
       #FUN-D30024 ---------End------------
 
        AFTER INPUT
           LET g_imd.imduser = s_get_data_owner("imd_file") #FUN-C10039
           LET g_imd.imdgrup = s_get_data_group("imd_file") #FUN-C10039
            IF INT_FLAG THEN EXIT INPUT END IF
            IF g_imd.imd10 IS NULL THEN 
               DISPLAY BY NAME g_imd.imd10 
               LET l_sw = 'Y'
            END IF
            IF g_imd.imd11 IS NULL THEN 
               DISPLAY BY NAME g_imd.imd11 
               LET l_sw = 'Y' 
            END IF
            IF g_imd.imd12 IS NULL THEN
               DISPLAY BY NAME g_imd.imd12 
               LET l_sw = 'Y'
            END IF
            IF g_imd.imd13 IS NULL THEN
               DISPLAY BY NAME g_imd.imd13 
               LET l_sw = 'Y'
            END IF
            IF g_imd.imd14 IS NULL THEN
               DISPLAY BY NAME g_imd.imd14 
               LET l_sw = 'Y'
            END IF
            IF g_imd.imd15 IS NULL THEN
               DISPLAY BY NAME g_imd.imd15 
               LET l_sw = 'Y'
            END IF
            IF l_sw = 'Y' THEN 
               CALL cl_err('','9033',0)
               LET l_sw = 'N'
               NEXT FIELD imd01
            END IF
        
        ON ACTION CONTROLP
            IF INFIELD(imd08) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aag"
               LET g_qryparam.default1 = g_imd.imd08
               LET g_qryparam.arg1 = g_bookno1  #No.FUN-730033
               CALL cl_create_qry() RETURNING g_imd.imd08
               DISPLAY BY NAME g_imd.imd08
            END IF
            IF INFIELD(imd081) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form     = "q_aag"                                                                                    
               LET g_qryparam.default1 = g_imd.imd081                                                                                
               LET g_qryparam.arg1 = g_bookno2  #No.FUN-730033
               CALL cl_create_qry() RETURNING g_imd.imd081                                                                           
               DISPLAY BY NAME g_imd.imd081                                                                                          
            END IF       
            IF INFIELD(imd21) THEN
               CALL cl_init_qry_var()
               LET g_qryparam.form     = "q_aag"
               LET g_qryparam.default1 = g_imd.imd21
               LET g_qryparam.arg1 = g_bookno1
               CALL cl_create_qry() RETURNING g_imd.imd21
               DISPLAY BY NAME g_imd.imd21
            END IF
            IF INFIELD(imd211) THEN                                                                                                  
               CALL cl_init_qry_var()                                                                                               
               LET g_qryparam.form     = "q_aag"                                                                                    
               LET g_qryparam.default1 = g_imd.imd211                                                                                
               LET g_qryparam.arg1 = g_bookno2  
               CALL cl_create_qry() RETURNING g_imd.imd211
               DISPLAY BY NAME g_imd.imd211 
            END IF       
 
        ON ACTION CONTROLR
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
   
 
FUNCTION i201_q()
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    DISPLAY '   ' TO FORMONLY.cnt  
    CALL i201_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
   CALL g_ime.clear()
        RETURN
    END IF
    MESSAGE "Waiting...." 
    OPEN i201_count
    FETCH i201_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN i201_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imd.imd01,SQLCA.sqlcode,0)
        INITIALIZE g_imd.* TO NULL
    ELSE
        CALL i201_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION i201_fetch(p_flag)
    DEFINE
        p_flag          LIKE type_file.chr1,   #No.FUN-690026 VARCHAR(1)
        l_abso          LIKE type_file.num10   #No.FUN-690026 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     i201_cs INTO g_imd.imd01
        WHEN 'P' FETCH PREVIOUS i201_cs INTO g_imd.imd01
        WHEN 'F' FETCH FIRST    i201_cs INTO g_imd.imd01
        WHEN 'L' FETCH LAST     i201_cs INTO g_imd.imd01
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
            FETCH ABSOLUTE g_jump i201_cs INTO g_imd.imd01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_imd.* TO NULL  #TQC-6B0105
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
 
    SELECT * INTO g_imd.* FROM imd_file            # 重讀DB,因TEMP有不被更新特性
       WHERE imd01 = g_imd.imd01
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","imd_file",g_imd.imd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    ELSE
        LET g_data_owner = g_imd.imduser #FUN-4C0053
        LET g_data_group = g_imd.imdgrup #FUN-4C0053
        CALL i201_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION i201_show()
    LET g_imd_t.* = g_imd.*
    DISPLAY BY NAME g_imd.imd01,g_imd.imd02,g_imd.imd03, g_imd.imdoriu,g_imd.imdorig,
                    g_imd.imd06,g_imd.imd07,g_imd.imd08,
                    g_imd.imd081,g_imd.imd21,g_imd.imd211,g_imd.imd09,g_imd.imd10, #FUN-680034--加imd081 #FUN-960141 加imd21,imd211
                    g_imd.imd11, g_imd.imd12,g_imd.imd13,
                 #  g_imd.imd14, g_imd.imd15,g_imd.imd23,   #FUN-D10143 add imd23
                    g_imd.imd14, g_imd.imd15,               #FUN-D30024 mark imd23
                    g_imd.imdacti,g_imd.imduser,g_imd.imdgrup,
                    g_imd.imdmodu,g_imd.imddate
    CALL cl_set_field_pic("","","","","",g_imd.imdacti)
    CALL i201_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION i201_u()
    DEFINE l_par LIKE type_file.chr500       #FUN-9A0056 add
    DEFINE i     LIKE type_file.num5         #FUN-9A0056 add
    IF s_shut(0) THEN RETURN END IF
    #若非由MENU進入本程式,則無更新之功能
    IF g_argv2 != ' ' THEN RETURN END IF
    IF g_imd.imd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_imd.* FROM imd_file WHERE imd01=g_imd.imd01
    IF g_imd.imdacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_imd.imd01,'mfg1000',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    LET g_imd01_t = g_imd.imd01
    LET g_imd_t.* = g_imd.*
    LET g_imd_o.* = g_imd.*
    LET g_success = 'Y'                       #FUN-9A0056 add
    BEGIN WORK
 
    OPEN i201_cl USING g_imd.imd01
    IF STATUS THEN
       CALL cl_err("OPEN i201_cl:", STATUS, 1)
       CLOSE i201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i201_cl INTO g_imd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imd.imd01,SQLCA.sqlcode,0)
        CLOSE i201_cl ROLLBACK WORK RETURN
    END IF
    LET g_imd.imdmodu = g_user                     #修改者
    LET g_imd.imddate = g_today                  #修改日期
    CALL i201_show()                          # 顯示最新資料
    WHILE TRUE
        CALL i201_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_imd.*=g_imd_t.*
            CALL i201_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE imd_file SET imd_file.* = g_imd.*    # 更新DB
            WHERE imd01 = g_imd01_t             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","imd_file",g_imd_t.imd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            ROLLBACK WORK   #FUN-9A0056 add
            CONTINUE WHILE
        END IF
        CALL s_upd_ime_img(g_imd_t.imd01,g_imd.imd01,g_imd.imd10,g_imd_t.imd10,                                
                           g_imd.imd14,g_imd_t.imd14,g_imd.imd15,g_imd_t.imd15,                                
                           g_imd.imd11,g_imd_t.imd11,g_imd.imd12,g_imd_t.imd12,                                
                           g_imd.imd13,g_imd_t.imd13) RETURNING g_success                                            
       IF g_success = 'N' THEN
          LET g_imd.* = g_imd_t.*
          ROLLBACK WORK
          CONTINUE WHILE 
       END IF
 
        # 92/06/18 Lin Modify 當欄位由 'Y' → 'N' 時, 才更新相關欄位
        # 'N'→ 'Y' 時不更新單身相關欄位 ......(By David 說的)
       
        LET g_flag = 'N'
        IF g_imd_t.imd11='Y' AND  g_imd.imd11='N'  THEN  #可用否
           LET g_flag = 'Y' 
           LET g_yn   = 'N'          #當變數為'N'時,代表imd11由'Y'變'N' #BugNo:5310
           LET g_mrp_yn='N'   #No.TQC-620004 add
        ELSE
           IF g_imd_t.imd11='N' AND  g_imd.imd11='Y'
              THEN
              # 將該倉庫中所有儲位恢復為可用
                  LET g_flag = 'Y' 
                  LET g_yn   = 'Y'   #當變數為'Y'時,代表imd11由'N'變'Y'
           END IF
        END IF
        IF g_flag = 'Y' 
           THEN
#           CALL i201_imeupdate()       #FUN-A20044  mark
        END IF
 
        LET g_flag = 'N'
        IF g_imd_t.imd12='Y' AND  g_imd.imd12='N'  THEN  #MRP可用否
           LET g_flag = 'Y'
        ELSE
           IF g_imd_t.imd12='N' AND  g_imd.imd12='Y'  THEN  #MRP可用否
              # 將該倉庫中所有儲位恢復為MRP可用
                 LET g_flag = 'Y'
                 LET g_mrp_yn='Y'   #No.TQC-620004 add
           END IF
        END IF
         IF g_flag = 'Y'             
            THEN                  
            CALL i201_mrpupdate()
         END IF               
       #FUN-9A0056 add str --------
        IF g_aza.aza90 MATCHES "[Yy]" THEN
           CALL i201_mes('update',g_imd.imd01,1)          #呼叫MES異動倉庫

           IF g_flag3 = 'Y' AND g_success = 'Y' THEN
              LET g_flag3 = 'N'

              #遇到TIPTOP操作為copy時,需要儲位依序傳MES建立資料
              FOR i = 1 TO g_ime.getLength()
                 IF g_ime[i].ime02[1,1]<>' ' AND NOT cl_null(g_ime[i].ime02) THEN
                    LET l_par = g_imd.imd01,"{+}",g_ime[i].ime02,"{+}",g_ime[i].ime02

                    CALL i201_mes('insert',l_par,2)       #呼叫MES異動儲位

                    IF g_success = 'N' THEN
                      EXIT FOR
                    END IF
                 END IF
              END FOR
           END IF
        END IF
       #FUN-9A0056 add end -------- 
        CALL i201_show()
        EXIT WHILE
    END WHILE
    CLOSE i201_cl
   #FUN-9A0056 add str ------
    IF g_success = 'N' THEN
      ROLLBACK WORK
      RETURN
    ELSE
      COMMIT WORK
    END IF
   #FUN-9A0056 add end ------

   #COMMIT WORK    #FUN-9A0056 mark
END FUNCTION
 
#No.FUN-A20044 ---mark---start
#FUNCTION i201_imeupdate()
#   DEFINE l_sql1   LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
#          l_sql2   LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
#          l_ime02  LIKE ime_file.ime02,
#          l_ima01  LIKE ima_file.ima01,
#          l_ima262 LIKE ima_file.ima262   
#          
#    #將儲位可用否為'Y' 的改成 'N'
#    LET l_sql1 = " SELECT ime02 ",
#                " FROM ime_file ",
#                " WHERE ime01='",g_imd.imd01,"' ",
#                "   AND ime05 ='",g_imd_t.imd11,"'" #No:5310
#    PREPARE i201_imeup FROM l_sql1      #預備一下
#    DECLARE ime_up CURSOR FOR i201_imeup
#    FOREACH ime_up INTO l_ime02
#        IF SQLCA.sqlcode THEN
#            CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#            EXIT FOREACH
#        END IF
#{&}     IF l_ime02 IS NULL THEN LET l_ime02 = ' ' END IF
#        LET l_sql2 = " SELECT UNIQUE img01 ",
#                     "   FROM img_file ",
#                     "  WHERE img02='",g_imd.imd01,"' ",
#                     "    AND img03='",l_ime02,"' ",
#                     "  ORDER BY img01 "
#        PREPARE i201_imaup FROM l_sql2      #預備一下
#        DECLARE ima_up CURSOR FOR i201_imaup
#        FOREACH ima_up INTO l_ima01
#           IF SQLCA.sqlcode THEN
#               CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
#               EXIT FOREACH
#           END IF
#           SELECT SUM(img10*img21) INTO l_ima262    
#             FROM img_file
#            WHERE img01=l_ima01 AND img02 = g_imd.imd01 
#                  AND img03=l_ime02
#           IF l_ima262 IS NULL THEN LET l_ima262=0 END IF
#           # 更新 [料件主檔] 的庫存可用量 與 庫存不可用量
#           IF l_ima262 IS NOT NULL AND l_ima262 !=0 THEN
#               IF g_yn = 'Y' THEN  #當g_yn='Y'時,代表imd11由'N'變'Y'
#                   UPDATE ima_file
#                      SET ima262=ima262+l_ima262, #  庫存可用數量增加
#                          ima261=ima261-l_ima262  #不可用庫存數量減少
#                    WHERE ima01=l_ima01
#               ELSE
#                                   #當g_yn='N'時,代表imd11由'Y'變'N'
#                   UPDATE ima_file 
#                      SET ima262=ima262-l_ima262, #  庫存可用數量減少
#                          ima261=ima261+l_ima262  #不可用庫存數量增加
#                    WHERE ima01=l_ima01
#               END IF
#           END IF
#        END FOREACH
#    END FOREACH
#    
#END FUNCTION
#No.FUN-A20044 ---mark ----end

 FUNCTION i201_mrpupdate()
    DEFINE l_sql1  LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
           l_sql2  LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(300)
           l_ime02 LIKE ime_file.ime02,
           l_ima01 LIKE ima_file.ima01 
          #l_ima26 LIKE ima_file.ima26                 #No.FUN-A40023 
           
     #將儲位MRP 可用否為'Y' 的改成 'N'
     LET l_sql1 = " SELECT ime02 ",
                 " FROM ime_file ",
                 " WHERE ime01='",g_imd.imd01,"' ",
                 "   AND ime06 ='",g_imd_t.imd12,"'" #No.TQC-620004 add
     PREPARE i201_mrpup FROM l_sql1      #預備一下
     DECLARE mrp_up CURSOR FOR i201_mrpup
     FOREACH mrp_up INTO l_ime02
 {&}     IF l_ime02 IS NULL THEN LET l_ime02 = ' ' END IF
         IF SQLCA.sqlcode THEN
             CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
             EXIT FOREACH
         END IF
         LET l_sql2 = " SELECT UNIQUE img01 ",
                      "   FROM img_file ",
                      "  WHERE img02='",g_imd.imd01,"' ",
                      "    AND img03='",l_ime02,"' ",
                      "  ORDER BY img01 "
         PREPARE i201_imaup2 FROM l_sql2      #預備一下
         DECLARE ima_up2 CURSOR FOR i201_imaup2
         FOREACH ima_up2 INTO l_ima01
            IF SQLCA.sqlcode THEN
                CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
                EXIT FOREACH
            END IF
            UPDATE img_file SET img24=g_imd.imd12
                 WHERE img01=l_ima01 AND img02 = g_imd.imd01 
                       AND img03=l_ime02
#No.FUN-A40023 ---start----mark
#           SELECT SUM(img10*img21) INTO l_ima26                       
#             FROM img_file
#            WHERE img01=l_ima01 AND img02 = g_imd.imd01 
#                  AND img03=l_ime02
#           IF l_ima26 IS NULL THEN LET l_ima26=0 END IF
#           # 更新 [料件主檔] 的 MRP 可用數量
#           IF l_ima26 IS NOT NULL AND l_ima26 !=0 THEN
#              IF g_mrp_yn = 'Y' THEN  #當g_mrp_yn='Y'時,代表imd12由'N'變'Y'
#                 UPDATE ima_file
#                    SET ima26=ima26+l_ima26
#                  WHERE ima01=l_ima01
#               ELSE   #當g_mrp_yn='N'時,代表imd12由'Y'變'N'
#                 UPDATE ima_file
#                    SET ima26=ima26-l_ima26
#                  WHERE ima01=l_ima01
#               END IF
#           END IF
#No.FUN-A40023 ---end---mark
         END FOREACH
     END FOREACH
 END FUNCTION

FUNCTION i201_x()
    DEFINE
        l_buf LIKE ze_file.ze03,     #儲存下游檔案的名稱 #No.FUN-690026 VARCHAR(80)
        l_chr LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
    DEFINE l_par LIKE type_file.chr500       #FUN-9A0056 add
    DEFINE i     LIKE type_file.num5         #FUN-9A0056 add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imd.imd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    BEGIN WORK
 
    OPEN i201_cl USING g_imd.imd01
    IF STATUS THEN
       CALL cl_err("OPEN i201_cl:", STATUS, 1)
       CLOSE i201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i201_cl INTO g_imd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_imd.imd01,SQLCA.sqlcode,0)
        CLOSE i201_cl ROLLBACK WORK RETURN
    END IF
    CALL i201_show()
    #在刪除前先檢查其下游檔案ime_file是否尚在使用中
    LET l_buf = NULL
    SELECT COUNT(*) INTO g_i FROM ime_file WHERE ime01 = g_imd.imd01
    IF g_i > 0 THEN 
       CALL cl_getmsg('mfg1010',g_lang) RETURNING g_msg
       LET l_buf = g_msg
    END IF
    #檢查此筆資料之下游檔案imf_file,img_file是否尚在使用中
    CALL i201_check(l_buf) RETURNING l_buf 
    IF g_chr = 'E' AND g_imd.imdacti='Y' THEN  #表示無法刪除此筆資料
       ERROR l_buf 
       RETURN
    END IF
    IF cl_exp(0,0,g_imd.imdacti) THEN
        LET g_success = 'Y'           #FUN-9A0056 add
        LET g_chr=g_imd.imdacti
        IF g_imd.imdacti='Y' THEN
            LET g_imd.imdacti='N'
        ELSE
            LET g_imd.imdacti='Y'
        END IF
        UPDATE imd_file
            SET imdacti=g_imd.imdacti,
               imdmodu=g_user, imddate=g_today
            WHERE imd01=g_imd.imd01
        IF SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","imd_file",g_imd.imd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            LET g_imd.imdacti=g_chr
            LET g_success = 'N'           #FUN-9A0056 add
        END IF
       #FUN-9A0056 add str ----------------------------
        IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
          #資料由無效變有效:傳送新增MES;資料由無效變有效;傳送刪除MES
           IF g_imd.imdacti='Y' THEN
             CALL i201_mes('insert',g_imd.imd01,1)                  #新增MES倉庫資料

             IF g_success = 'Y' THEN
                FOR i = 1 TO g_ime.getLength()
                   IF g_ime[i].ime02[1,1]<>' ' AND NOT cl_null(g_ime[i].ime02) THEN
                      LET l_par = g_imd.imd01,"{+}",g_ime[i].ime02
                      CALL i201_mes('insert',l_par,2)               #新增MES儲位資料
                      IF g_success = 'N' THEN
                        EXIT FOR
                      END IF
                   END IF
                END FOR
             END IF
           ELSE
              CALL i201_mes('delete',g_imd.imd01,1)         #刪除倉庫資料

              IF g_success = 'Y' THEN
                #刪除儲位資料
                 FOR i = 1 TO g_ime.getLength()
                    IF g_ime[i].ime02[1,1]<>' ' AND NOT cl_null(g_ime[i].ime02) THEN
                       LET l_par = g_imd.imd01,"{+}",g_ime[i].ime02
                       CALL i201_mes('delete',l_par,2)
                       IF g_success = 'N' THEN
                         EXIT FOR
                       END IF
                    END IF
                 END FOR
              END IF
           END IF
        END IF

        IF g_success = 'N' THEN
          ROLLBACK WORK
          RETURN
        ELSE
          DISPLAY BY NAME g_imd.imdacti
        END IF
       #FUN-9A0056 add end ----------------------------------------
       #DISPLAY BY NAME g_imd.imdacti  #FUN-9A0056 mark
    END IF
    CLOSE i201_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION i201_r()
    DEFINE l_chr LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
           l_buf LIKE ze_file.ze03       #儲存下游檔案的名稱 #No.FUN-690026 VARCHAR(80)
    DEFINE l_par LIKE type_file.chr500   #FUN-9A0056 add
    DEFINE i     LIKE type_file.num5     #FUN-9A0056 add
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imd.imd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    IF g_imd.imdacti = 'N' THEN                                                                                                     
       CALL cl_err('','abm-033',0)  
       RETURN                                                                                                                       
    END IF                                                                                                                          
    BEGIN WORK
 
    OPEN i201_cl USING g_imd.imd01
    IF STATUS THEN
       CALL cl_err("OPEN i201_cl:", STATUS, 1)
       CLOSE i201_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH i201_cl INTO g_imd.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_imd.imd01,SQLCA.sqlcode,0)
       CLOSE i201_cl ROLLBACK WORK RETURN
    END IF
    CALL i201_show()
    #檢查此筆資料之下游檔案imf_file,img_file是否尚在使用中
    CALL i201_check(l_buf) RETURNING l_buf 
    IF g_chr = 'E' THEN  #表示無法刪除此筆資料
       ERROR l_buf 
       RETURN
    END IF
    IF cl_delh(15,16) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "imd01"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_imd.imd01      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
       LET g_success = 'Y' #FUN-9A0056 add
       DELETE FROM vmf_file WHERE vmf01 = g_imd.imd01   #FUN-890085
       DELETE FROM imd_file WHERE imd01 = g_imd.imd01
       IF SQLCA.SQLERRD[3]=0 THEN 
          CALL cl_err3("del","imd_file",g_imd.imd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
          LET g_success = 'N'   #FUN-9A0056 add
       ELSE 
          DELETE FROM ime_file WHERE ime01=g_imd.imd01     #No.TQC-740068
          DELETE FROM inc_file WHERE inc01=g_imd.imd01     #No.FUN-930109
      #FUN-9A0056 add str --------
          IF SQLCA.sqlcode THEN
             CALL cl_err3("del","ime_file",g_imd.imd01,"",SQLCA.sqlcode,"","",1)
             LET g_success = 'N'
          END IF
       END IF
      #FUN-9A0056 add end --------
         #IF g_sma.sma901 = 'Y' THEN                        #FUN-9A0056 mark
          IF g_success = 'Y' AND g_sma.sma901 = 'Y' THEN    #FUN-9A0056 add
             DELETE FROM vmg_file WHERE vmg01=g_imd.imd01  #NO.FUN-7C0002
             IF SQLCA.sqlcode THEN 
                CALL cl_err3("del","vmg",g_imd.imd01,"",SQLCA.sqlcode,"","",1)  
               #CLOSE i201_cl                               #FUN-9A0056 mark
               #ROLLBACK WORK                               #FUN-9A0056 mark
               #RETURN                                      #FUN-9A0056 mark
                LET g_success = 'N'                         #FUN-9A0056 add
             END IF
          END IF
      #FUN-9A0056 add str --
       IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
          CALL i201_mes('delete',g_imd.imd01,1)         #刪除MES倉庫資料
       END IF
      #FUN-9A0056 add end --
       IF g_success = 'Y' THEN         #FUN-9A0056 add
          CLEAR FORM
          CALL g_ime.clear()
          OPEN i201_count
          #FUN-B50062-add-start--
          IF STATUS THEN
             CLOSE i201_cs
             CLOSE i201_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          FETCH i201_count INTO g_row_count
          #FUN-B50062-add-start--
          IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
             CLOSE i201_cs
             CLOSE i201_count
             COMMIT WORK
             RETURN
          END IF
          #FUN-B50062-add-end--
          DISPLAY g_row_count TO FORMONLY.cnt
          OPEN i201_cs
          IF g_curs_index = g_row_count + 1 THEN
             LET g_jump = g_row_count
             CALL i201_fetch('L')
          ELSE
             LET g_jump = g_curs_index
             LET mi_no_ask = TRUE
             CALL i201_fetch('/')
          END IF
      #END IF                         #FUN-9A0056 mark
       LET g_msg=TIME
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004
          VALUES ('aimi201',g_user,g_today,g_msg,g_imd.imd01,'delete',g_plant,g_legal) #No.FUN-980004
       INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal) #No.FUN-980004
          VALUES ('aimi201',g_user,g_today,g_msg,g_imd.imd01,'delete',g_plant,g_legal) #No.FUN-980004
       #FUN-9A0056 add str ---
          CLOSE i201_cl
          COMMIT WORK
        ELSE
          CLOSE i201_cl
          ROLLBACK WORK
        END IF
       #FUN-9A0056 add end ---
    END IF
   #CLOSE i201_cl   #FUN-9A0056 mark
   #COMMIT WORK     #FUN-9A0056 mark
END FUNCTION
 
FUNCTION i201_check(l_buf)
    DEFINE l_buf LIKE ze_file.ze03  #No.FUN-690026 VARCHAR(80)
 
    SELECT COUNT(*) INTO g_i FROM imf_file WHERE imf02 = g_imd.imd01
    IF g_i > 0 THEN
       CALL cl_getmsg('mfg1011',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
    END IF
    SELECT COUNT(*) INTO g_i FROM img_file WHERE img02 = g_imd.imd01
    IF g_i > 0 THEN 
       CALL cl_getmsg('mfg1012',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
    END IF
    IF l_buf IS NOT NULL THEN 
       CALL cl_getmsg('mfg1013',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
       LET g_chr = 'E' 
    ELSE
       LET g_chr = ''
    END IF
    RETURN l_buf
END FUNCTION
 
FUNCTION i201_bcheck(l_ime02)
    DEFINE l_ime02  LIKE ime_file.ime02
    DEFINE l_buf    LIKE ze_file.ze03    #No.FUN-690026 VARCHAR(80)
 
    SELECT COUNT(*) INTO g_i FROM imf_file WHERE imf02 = g_imd.imd01
                                            #    AND imf03=g_ime[l_ac].ime02
                                                 AND imf03=l_ime02
    IF g_i > 0 THEN
       CALL cl_getmsg('mfg1011',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
    END IF
    SELECT COUNT(*) INTO g_i FROM img_file WHERE img02 = g_imd.imd01
                                            #AND img03=g_ime[l_ac].ime02
                                             AND img03=l_ime02 #BugNo:6146
    IF g_i > 0 THEN 
       CALL cl_getmsg('mfg1012',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
    END IF
    IF l_buf IS NOT NULL THEN 
       CALL cl_getmsg('mfg1013',g_lang) RETURNING g_msg
       LET l_buf = l_buf CLIPPED,g_msg
       LET g_chr = 'E' 
    ELSE
       LET g_chr = ''
    END IF
    RETURN l_buf
END FUNCTION
 
#單身
FUNCTION i201_b()
DEFINE
    l_buf           LIKE ze_file.ze03,     #儲存尚在使用中之下游檔案之檔名 #No.FUN-690026 VARCHAR(80)
    l_ac_t          LIKE type_file.num5,   #未取消的ARRAY CNT  #No.FUN-690026 SMALLINT
    l_n             LIKE type_file.num5,   #檢查重複用  #No.FUN-690026 SMALLINT
    l_cnt           LIKE type_file.num5,   #No.MOD-790105 add
    l_lock_sw       LIKE type_file.chr1,   #單身鎖住否  #No.FUN-690026 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,   #處理狀態  #No.FUN-690026 VARCHAR(1)
    l_bcur          LIKE type_file.chr1,   #'1':表存放位置有值,'2':則為NULL  #No.FUN-690026 VARCHAR(1)
    l_ime02         LIKE ime_file.ime02,
    l_dir1          LIKE type_file.chr1,   #next field flag    #No.FUN-690026 VARCHAR(1)
    l_dir2          LIKE type_file.chr1,   #next field flag    #No.FUN-690026 VARCHAR(1)
    l_dir3          LIKE type_file.chr1,   #next field flag    #No.FUN-690026 VARCHAR(1)
    l_chr           LIKE type_file.chr1,   #MOD-850215 add     #新增狀態
    l_allow_insert  LIKE type_file.num5,   #可新增否  #No.FUN-690026 SMALLINT
    l_allow_delete  LIKE type_file.num5,   #可刪除否  #No.FUN-690026 SMALLINT
    l_inc03         LIKE inc_file.inc03,   #FUN-930109 
    l_sql           STRING                 #FUN-930109          
DEFINE   lj_n       LIKE type_file.num5    #檢查倉儲是否存在于廠商基本資料檔中  #No.FUN-940083 SMALLINT
DEFINE l_par LIKE type_file.chr500       #FUN-9A0056 add
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_imd.imd01 IS NULL THEN
       RETURN
    END IF
    SELECT * INTO g_imd.* FROM imd_file WHERE imd01=g_imd.imd01
    IF g_imd.imdacti MATCHES'[Nn]' THEN
       CALL cl_err(g_imd.imd01,'mfg1000',0)
       RETURN 
    END IF
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT ime02,ime03,ime04,ime05,ime06,ime07,ime12,ime08,ime09,ime091,ime13,ime131,ime10,ime11,ime17,imeacti ",     #FUN-680034--加ime091 #FUN-930109 Add ime17 #FUN-940083 add ime12 #CHI-940047 #FUN-960141 add ime13,ime131 #FUN-D40103 imeacti
                       "   FROM ime_file ",
                       "   WHERE ime02 = ? ",
                       "    AND ime01 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i201_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET g_forupd_sql = " SELECT ime02,ime03,ime04,ime05,ime06,ime07,ime12,ime08,ime09,ime091,ime13,ime131,ime10,ime11,ime17,imeacti ",     #FUN-680034--加ime091 #FUN-930109 Add ime17 #FUN-940083 add ime12#CHI-940047 #FUN-960141 add ime13,ime131 #FUN-D40103 imeacti
                       "   FROM ime_file ",
                       "   WHERE ime02 IS NULL ",
                       "    AND ime01 = ? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i201_bc1 CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
     LET l_allow_insert = cl_detail_input_auth("insert")
     LET l_allow_delete = cl_detail_input_auth("delete")
 
     INPUT ARRAY g_ime WITHOUT DEFAULTS FROM s_ime.*
           ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                     INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
           IF g_rec_b != 0 THEN
              CALL fgl_set_arr_curr(l_ac)
           END IF
           LET g_before_input_done = FALSE
            CALL i201_set_entry_b('')     #MOD-4A0269
            CALL i201_set_no_entry_b('')  #MOD-4A0269
           LET g_before_input_done = TRUE
 
        BEFORE ROW
           LET p_cmd=''
           LET l_chr=''                     #MOD-850215 add
           LET l_ac = ARR_CURR()
           LET l_lock_sw = 'N'              #DEFAULT
           LET l_n  = ARR_COUNT()
           BEGIN WORK
           OPEN i201_cl USING g_imd.imd01
           IF STATUS THEN
              CALL cl_err("OPEN i201_cl:", STATUS, 1)
              CLOSE i201_cl
              ROLLBACK WORK
              RETURN
           ELSE  
              FETCH i201_cl INTO g_imd.*               # 對DB鎖定
              IF SQLCA.sqlcode THEN
                 CALL cl_err(g_imd.imd01,SQLCA.sqlcode,0)
                 CLOSE i201_cl 
                 ROLLBACK WORK 
                 RETURN
              END IF
           END IF
           IF g_rec_b>=l_ac THEN
              LET p_cmd='u'
              LET g_ime_t.* = g_ime[l_ac].*  #BACKUP
              IF g_ime_t.ime02 IS NOT NULL THEN
                 OPEN i201_bcl USING g_ime_t.ime02,g_imd.imd01
                 IF STATUS THEN
                    CALL cl_err("OPEN i201_bcl:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH i201_bcl INTO g_ime[l_ac].* 
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ime_t.ime02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    ELSE
                       LET g_ime_t.*=g_ime[l_ac].*
                    END IF
                    LET l_bcur = '1'
                 END IF
	      ELSE
                 OPEN i201_bc1 USING g_imd.imd01
                 IF STATUS THEN
                    CALL cl_err("OPEN i201_bc1:", STATUS, 1)
                    LET l_lock_sw = "Y"
                 ELSE
                    FETCH i201_bc1 INTO g_ime[l_ac].* 
                    IF SQLCA.sqlcode THEN
                       CALL cl_err(g_ime_t.ime02,SQLCA.sqlcode,1)
                       LET l_lock_sw = "Y"
                    ELSE
                       LET g_ime_t.*=g_ime[l_ac].*
                    END IF
                    LET l_bcur = '2'
                 END IF
              END IF
               CALL i201_set_entry_b('u')      #MOD-4A0269
               CALL i201_set_no_entry_b('u')   #MOD-4A0269
              CALL cl_show_fld_cont()     #FUN-550037(smin)
           END IF
 
        AFTER INSERT
           DISPLAY "AFTER INSERT"
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              CANCEL INSERT
           END IF

           IF g_ime[l_ac].ime02 IS NULL THEN
              LET g_ime[l_ac].ime02 = ' '
           END IF

           LET g_success ='Y'     #FUN-9A0056 add
           BEGIN WORK             #FUN-9A0056 add
           DISPLAY "DO INSERT"
           LET l_chr='' #MOD-850215 add
#TQC-A50098 --begin--
           IF cl_null(g_ime[l_ac].ime12) THEN 
              LET g_ime[l_ac].ime12 = '0' 
           END IF 
#TQC-A50098 --end--            
            INSERT INTO ime_file(ime01,ime02,ime03,ime04,ime05,ime06,   #No.MOD-470041
                                ime07,ime12,ime08,ime09,ime091,ime13,ime131,ime10,ime11,ime17,imeacti)      #FUN-680034--加ime091 #FUN-930109 Add ime17 #FUN-940083 add ime12
                VALUES(g_imd.imd01,g_ime[l_ac].ime02,g_ime[l_ac].ime03,
                       g_ime[l_ac].ime04,g_ime[l_ac].ime05,g_ime[l_ac].ime06,
                       g_ime[l_ac].ime07,g_ime[l_ac].ime12,g_ime[l_ac].ime08,g_ime[l_ac].ime09,   #FUN-940083 add ime12
                       g_ime[l_ac].ime091,g_ime[l_ac].ime13,g_ime[l_ac].ime131,g_ime[l_ac].ime10,g_ime[l_ac].ime11,g_ime[l_ac].ime17,g_ime[l_ac].imeacti) #FUN-680034--加ime091 #FUN-930109 Add ime17 #FUN-D40103 imeacti
            IF (SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0) THEN # AND   #MOD-570193
              CALL cl_err3("ins","ime_file",g_ime[l_ac].ime02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
             #CANCEL INSERT           #FUN-9A0056 mark
              LET g_success ='N'      #FUN-9A0056 add
           ELSE
               LET l_sql = "SELECT inc03 ",                                                                                         
                           "  FROM inc_file",                                                                                       
                           " WHERE inc01 = '",g_imd.imd01,"'",                                                                      
                           "   AND inc02 = ' '"                                                                                     
               PREPARE inc_prepare2 FROM l_sql                                                                                      
               DECLARE inc_c2  CURSOR FOR inc_prepare2                                                                              
               OPEN inc_c2                                                                                                          
               FETCH inc_c2 INTO l_inc03
               IF SQLCA.sqlcode THEN
                  LET l_inc03 = ' ' 
               END IF 
               IF cl_null(l_inc03) THEN LET l_inc03 = ' ' END IF                                   
               INSERT INTO inc_file(inc01,inc02,inc03)
                   VALUES(g_imd.imd01,g_ime[l_ac].ime02,l_inc03)
               IF (SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0) THEN
                  CALL cl_err3("ins","inc_file",g_imd.imd01,"",SQLCA.sqlcode,"","",1)
                  CANCEL INSERT                 
               END IF
 
            #FUN-9A0056 mark str ---
            #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
            #   #FUN-870101---add---str---
            #   #DISPLAY 'INSERT O.K'
            #   #LET g_rec_b=g_rec_b+1
            #   #DISPLAY g_rec_b TO FORMONLY.cn2
            #   # CALL aws_mescli()
            #   # 傳入參數: (1)程式代號
            #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
            #   #           (3)Key
            #   CASE aws_mescli('aimi201','insert',g_ime[l_ac].ime02)
            #      WHEN 0  #無與 MES 整合
            #           MESSAGE 'INSERT O.K'
            #           LET g_rec_b=g_rec_b+1
            #           DISPLAY g_rec_b TO FORMONLY.cn2
            #      WHEN 1  #呼叫 MES 成功
            #           MESSAGE 'INSERT O.K, INSERT MES O.K'
            #           LET g_rec_b=g_rec_b+1
            #           DISPLAY g_rec_b TO FORMONLY.cn2
            #      WHEN 2  #呼叫 MES 失敗
            #           RETURN FALSE
            #   END CASE
            #   #FUN-870101---add---end---
            #END IF  #TQC-8B0011  ADD
            #FUN-9A0056 mark end -----
           END IF
          #FUN-9A0056 add begin -------
          #新增儲位資料:儲位空白時(or " "),不拋轉MES
           IF g_success ='Y' AND g_aza.aza90 MATCHES "[Yy]" THEN
             IF g_ime[l_ac].ime02[1,1]<>' ' AND NOT cl_null(g_ime[l_ac].ime02) THEN
                LET l_par = g_imd.imd01,"{+}",g_ime[l_ac].ime02,"{+}",g_ime[l_ac].ime02
                CALL i201_mes('insert',l_par,2)
             END IF
           END IF

           LET g_rec_b=g_rec_b+1

           DISPLAY g_rec_b TO FORMONLY.cn2

           IF g_success ='Y' THEN
             COMMIT WORK
           ELSE
             ROLLBACK WORK
             CANCEL INSERT
           END IF
          #FUN-9A0056 add end ---------
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ime[l_ac].* TO NULL      #900423
            LET g_ime[l_ac].ime02 = ' '
            LET g_ime[l_ac].ime12 = '0'           #FUN-940083 add
            LET g_ime[l_ac].ime08 = '0'
            LET g_ime[l_ac].ime04 = g_imd.imd10
            LET g_ime[l_ac].ime05 = g_imd.imd11
            LET g_ime[l_ac].ime06 = g_imd.imd12
            LET g_ime[l_ac].ime07 = g_imd.imd13
            LET g_ime[l_ac].ime10 = g_imd.imd14
            LET g_ime[l_ac].ime11 = g_imd.imd15
            LET g_ime[l_ac].ime17 = 'N'           #FUN-930109 
            LET g_ime[l_ac].imeacti = 'Y'         #FUN-D40103 add
            LET g_ime_t.* = g_ime[l_ac].*         #新輸入資料
             CALL i201_set_entry_b('u')       #MOD-4A0269
             CALL i201_set_no_entry_b('u')    #MOD-4A0269
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD ime02
 
        AFTER FIELD ime02
           IF g_ime[l_ac].ime02 IS NULL THEN 
               LET g_ime[l_ac].ime02 = ' ' 
           END IF
            DISPLAY BY NAME g_ime[l_ac].ime02                                
            IF p_cmd='a' THEN
               LET l_chr='a'                              
            END IF
	       IF (p_cmd = 'u' AND 
                (((g_ime[l_ac].ime02 IS NOT NULL AND g_ime[l_ac].ime02 != ' ')
                  AND (g_ime_t.ime02 IS NULL OR g_ime_t.ime02 = ' '))
              OR ((g_ime[l_ac].ime02 IS NULL OR g_ime[l_ac].ime02 = ' ')
                  AND (g_ime_t.ime02 IS NOT NULL AND g_ime_t.ime02 != ' '))))
              OR (g_ime_t.ime02 != g_ime[l_ac].ime02)  #增加此條件
              OR (p_cmd = 'a') THEN
                IF NOT cl_null(g_ime[l_ac].ime02) THEN
                   SELECT count(*) INTO l_n
                     FROM ime_file
                     WHERE ime01 = g_imd.imd01 AND ime02 = g_ime[l_ac].ime02
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ime[l_ac].ime02 = g_ime_t.ime02
                       NEXT FIELD ime02
		   END IF
                   LET l_buf=''
                   IF p_cmd='u' THEN 
                      LET l_ime02=g_ime_t.ime02 
                   ELSE
                      LET l_ime02=g_ime[l_ac].ime02 
                   END IF
                   CALL i201_bcheck(l_ime02) RETURNING l_buf
                   IF g_chr = 'E' THEN  #表示無法刪除此筆資料
                      ERROR l_buf
                      LET g_ime[l_ac].ime02 = g_ime_t.ime02
                      NEXT FIELD ime02
                   EXIT INPUT
                END IF
              END IF
            END IF
 
        
        AFTER FIELD ime05 
            IF NOT cl_null(g_ime[l_ac].ime05) THEN
                IF g_ime[l_ac].ime05 NOT MATCHES'[YN]' THEN
                   NEXT FIELD ime05
                END IF
            END IF
 
        AFTER FIELD ime06
            IF NOT cl_null(g_ime[l_ac].ime06) THEN
                IF g_ime[l_ac].ime06 NOT MATCHES'[YN]' THEN
                   NEXT FIELD ime06
                END IF
            END IF
 
        AFTER FIELD ime07
            IF NOT cl_null(g_ime[l_ac].ime07) THEN
                IF g_ime[l_ac].ime07 NOT MATCHES'[YN]' THEN
                   NEXT FIELD ime07
                END IF
            END IF
 
         BEFORE FIELD ime12
             IF p_cmd = 'u' THEN  
                LET lj_n = 0
                SELECT COUNT(*) INTO lj_n FROM pmc_file 
                  WHERE pmc915 = g_imd.imd01 AND pmc916 =g_ime[l_ac].ime02          
                IF lj_n = 0 THEN
                   SELECT COUNT(*) INTO lj_n FROM pmc_file 
                     WHERE pmc917 = g_imd.imd01 AND pmc918 =g_ime[l_ac].ime02          
                   IF lj_n >0 THEN
                      CALL cl_set_comp_entry("ime12",FALSE)
                   END IF
                ELSE
                   CALL cl_set_comp_entry("ime12",FALSE)
                END IF
             END IF
 
         AFTER FIELD ime12
           IF NOT cl_null(g_ime[l_ac].ime12) THEN    #TQC-A50098
             IF g_ime[l_ac].ime12 NOT MATCHES '[012]' THEN
                NEXT FIELD ime12
             END IF
  	         IF g_ime[l_ac].ime12 = '1' THEN
                LET lj_n = 0 
                SELECT COUNT(*) INTO lj_n FROM jce_file 
                  WHERE jce02 = g_imd.imd01
                IF lj_n = 0 THEN
                   CALL cl_err('','aim-017',0)
                   NEXT FIELD ime12
                END IF
             END IF
  	         IF g_ime[l_ac].ime12 = '2' THEN
                LET lj_n = 0 
                SELECT COUNT(*) INTO lj_n FROM jce_file 
                  WHERE jce02 = g_imd.imd01
                IF lj_n >0 THEN
                   CALL cl_err('','aim-018',0)
                   NEXT FIELD ime12
                END IF
             END IF
           END IF            #TQC-A50098
           
        BEFORE FIELD ime08
            CALL i201_set_entry_b(p_cmd)
 
        AFTER FIELD ime08
            IF NOT cl_null(g_ime[l_ac].ime06) THEN
                IF g_ime[l_ac].ime08 NOT MATCHES'[012]' THEN
                   NEXT FIELD ime08
                END IF
	        #若會計科目顯示方式不為 2則無須輸入倉儲會計科目 向下flag
            END IF
  	    IF g_ime[l_ac].ime08 != '2' THEN
                LET g_ime[l_ac].ime09 = NULL
                LET g_ime[l_ac].ime091 = NULL                  #FUN-680034
                LET g_ime[l_ac].ime13 = NULL                   #FUN-960141
                LET g_ime[l_ac].ime131= NULL                   #FUN-960141
            END IF
            CALL i201_set_no_entry_b(p_cmd)
 
        AFTER FIELD ime09
            IF int_flag THEN LET int_flag=0 exit input END IF
            IF g_ime[l_ac].ime08='2' AND (g_ime[l_ac].ime09 IS NULL
                                     OR   g_ime[l_ac].ime09=' ')
              THEN  CALL cl_err(g_ime[l_ac].ime09,'mfg9043',0)
                    NEXT FIELD ime09
            END IF
            IF g_ime[l_ac].ime09 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  IF NOT s_actchk3(g_ime[l_ac].ime09,g_bookno1) THEN  #No.FUN-730033
                     CALL cl_err(g_ime[l_ac].ime09,'mfg0018',0)
                     #FUN-B10049--begin
                     IF g_sma.sma03='Y' THEN
                        LET g_db1 = g_sma.sma87
                     ELSE
                        LET g_db1 = g_plant
                     END IF
                     SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
                      WHERE azp01=g_db1
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_aag1"     
                     LET g_qryparam.plant = g_db1         
                     LET g_qryparam.construct = 'N'  
                     LET g_qryparam.default1 = g_ime[l_ac].ime09
                     LET g_qryparam.arg2 = g_bookno1  
                     LET g_qryparam.where = " aag01 LIKE '",g_ime[l_ac].ime09 CLIPPED,"%' "                                                                        
                     CALL cl_create_qry() RETURNING g_ime[l_ac].ime09
                     DISPLAY BY NAME g_ime[l_ac].ime09 
                     #FUN-B10049--end                         
                          NEXT FIELD ime09
                  END IF
               END IF
            END IF
 
        AFTER FIELD ime091                                                                                                           
            IF int_flag THEN LET int_flag=0 exit input END IF                                                                           
            IF g_ime[l_ac].ime08='2' AND (g_ime[l_ac].ime091 IS NULL                                                                     
                                     OR   g_ime[l_ac].ime091=' ')                                                                        
              THEN  CALL cl_err(g_ime[l_ac].ime091,'mfg9043',0)                                                                          
                    NEXT FIELD ime091                                                                                                    
            END IF                                                                                                                      
            IF g_ime[l_ac].ime091 IS NOT NULL THEN                                                                                       
               IF g_sma.sma03='Y' THEN                                                                                                  
                  IF NOT s_actchk3(g_ime[l_ac].ime091,g_bookno2) THEN    #No.FUN-730033  
                     CALL cl_err(g_ime[l_ac].ime091,'mfg0018',0)   
                     #FUN-B10049--begin
                     IF g_sma.sma03='Y' THEN
                        LET g_db1 = g_sma.sma87
                     ELSE
                        LET g_db1 = g_plant
                     END IF
                     SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
                      WHERE azp01=g_db1                     
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form     = "q_aag1"     
                     LET g_qryparam.plant = g_db1  
                     LET g_qryparam.construct = 'N'                                   
                     LET g_qryparam.default1 = g_ime[l_ac].ime091  
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg2 = g_bookno2
                     LET g_qryparam.where = " aag01 LIKE '",g_ime[l_ac].ime091 CLIPPED,"%' "                                                                        
                     CALL cl_create_qry() RETURNING g_ime[l_ac].ime091
                     DISPLAY BY NAME g_ime[l_ac].ime091 
                     #FUN-B10049--end                                                                                             
                          NEXT FIELD ime091                                                                                              
                  END IF                                                                                                                
               END IF                                                                                                                   
            END IF

        AFTER FIELD ime13
            IF int_flag THEN LET int_flag=0 exit input END IF
            IF g_ime[l_ac].ime08='2' AND (g_ime[l_ac].ime13 IS NULL
                                     OR   g_ime[l_ac].ime13=' ')
              THEN  CALL cl_err(g_ime[l_ac].ime13,'mfg9043',0)
                    NEXT FIELD ime13
            END IF
            IF g_ime[l_ac].ime13 IS NOT NULL THEN
               IF g_sma.sma03='Y' THEN
                  IF NOT s_actchk3(g_ime[l_ac].ime13,g_bookno1) THEN 
                     CALL cl_err(g_ime[l_ac].ime13,'mfg0018',0)
                     #FUN-B10049--begin
                     IF g_sma.sma03='Y' THEN
                        LET g_db1 = g_sma.sma87
                     ELSE
                        LET g_db1 = g_plant
                     END IF
                     SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
                      WHERE azp01=g_db1
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_aag1"     
                     LET g_qryparam.plant = g_db1         
                     LET g_qryparam.construct = 'N'  
                     LET g_qryparam.default1 = g_ime[l_ac].ime13
                     LET g_qryparam.arg2 = g_bookno1  
                     LET g_qryparam.where = " aag01 LIKE '",g_ime[l_ac].ime13 CLIPPED,"%' "                                                                        
                     CALL cl_create_qry() RETURNING g_ime[l_ac].ime13
                     DISPLAY BY NAME g_ime[l_ac].ime13 
                     #FUN-B10049--end                     
                          NEXT FIELD ime13
                  END IF
               END IF
            END IF
        AFTER FIELD ime131                                                                                                           
            IF int_flag THEN LET int_flag=0 exit input END IF                                                                           
            IF g_ime[l_ac].ime08='2' AND (g_ime[l_ac].ime131 IS NULL                                                                     
                                     OR   g_ime[l_ac].ime131=' ')                                                                        
              THEN  CALL cl_err(g_ime[l_ac].ime131,'mfg9043',0)                                                                          
                    NEXT FIELD ime131                                                                                                    
            END IF                                                                                                                      
            IF g_ime[l_ac].ime131 IS NOT NULL THEN                                                                                       
               IF g_sma.sma03='Y' THEN                                                                                                  
                  IF NOT s_actchk3(g_ime[l_ac].ime131,g_bookno2) THEN   
                     CALL cl_err(g_ime[l_ac].ime131,'mfg0018',0)              
                     #FUN-B10049--begin
                     IF g_sma.sma03='Y' THEN
                        LET g_db1 = g_sma.sma87
                     ELSE
                        LET g_db1 = g_plant
                     END IF
                     SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
                      WHERE azp01=g_db1                     
                     CALL cl_init_qry_var()                                         
                     LET g_qryparam.form     = "q_aag1"     
                     LET g_qryparam.plant = g_db1           
                     LET g_qryparam.construct = 'N'                          
                     LET g_qryparam.default1 = g_ime[l_ac].ime131  
                     LET g_qryparam.construct = 'N'                
                     LET g_qryparam.arg2 = g_bookno2  
                     LET g_qryparam.where = " aag01 LIKE '",g_ime[l_ac].ime131 CLIPPED,"%' "                                                                        
                     CALL cl_create_qry() RETURNING g_ime[l_ac].ime131
                     DISPLAY BY NAME g_ime[l_ac].ime131 
                     #FUN-B10049--end                                                                                
                          NEXT FIELD ime131                                                                                              
                  END IF                                                                                                                
               END IF                                                                                                                   
            END IF

        AFTER FIELD ime10
            IF g_ime[l_ac].ime10 IS NULL THEN                                   
               LET g_ime[l_ac].ime10 = 0                                        
               DISPLAY BY NAME g_ime[l_ac].ime10                                
            END IF
            IF g_ime[l_ac].ime10 < 0 THEN
               CALL cl_err(g_ime[l_ac].ime10,'aim1007',0)
               NEXT FIELD ime10
            END IF
 
        AFTER FIELD ime11
            IF g_ime[l_ac].ime11 IS NULL THEN                                   
               LET g_ime[l_ac].ime11 = 0                                        
               DISPLAY BY NAME g_ime[l_ac].ime11                                
            END IF 
            IF g_ime[l_ac].ime11 < 0 THEN
               CALL cl_err(g_ime[l_ac].ime11,'aim1007',0)
               NEXT FIELD ime11
            END IF
 
       AFTER FIELD ime17
          IF NOT cl_null(g_ime[l_ac].ime17) THEN
             IF g_ime[l_ac].ime17 NOT MATCHES '[YN]' THEN                 
                NEXT FIELD ime17
             END IF
          END IF

       #FUN-D40103--add--str--
       BEFORE FIELD imeacti
         IF NOT i201_check_imeacti() THEN
            CALL cl_err('','aim-508',0)
            CALL cl_set_comp_entry("imeacti",FALSE) 
            NEXT FIELD ime02   #TQC-D50127 by free
         END IF

       AFTER FIELD imeacti
          IF g_ime[l_ac].imeacti = 'N' THEN 
             LET l_buf = ''
             SELECT COUNT(*) INTO l_cnt FROM imf_file
              WHERE imf02 = g_imd.imd01
                AND imf03 = g_ime[l_ac].ime02
             IF l_cnt> 0 THEN
                CALL cl_getmsg('mfg1011',g_lang) RETURNING g_msg
                LET l_buf = l_buf CLIPPED,g_msg
             END IF
             SELECT COUNT(*) INTO l_cnt FROM img_file 
              WHERE img02 = g_imd.imd01
                AND img03 = g_ime[l_ac].ime02
                AND img10 != 0
             IF l_cnt > 0 THEN
                CALL cl_getmsg('mfg1012',g_lang) RETURNING g_msg
                LET l_buf = l_buf CLIPPED,g_msg
             END IF
             IF l_buf IS NOT NULL THEN
                CALL cl_getmsg('mfg1013',g_lang) RETURNING g_msg 
                LET l_buf = l_buf CLIPPED,g_msg
                LET g_ime[l_ac].imeacti = g_ime_t.imeacti   #TQC-D50127
                DISPLAY BY NAME g_ime[l_ac].imeacti         #TQC-D50127
                CALL cl_err(l_buf,'aic-909',0)   #TQC-D50116 add
                NEXT FIELD imeacti               #TQC-D50116 add
             END IF
             SELECT COUNT(*) INTO l_cnt FROM img_file
              WHERE img02 = g_imd.imd01 AND img03 = g_ime[l_ac].ime02
                AND img10 = 0
             IF l_cnt > 0 THEN
                IF NOT cl_confirm('aim-506') THEN
                #  LET g_ime[l_ac].imeacti = 'Y'               #TQC-D50127 
                   LET g_ime[l_ac].imeacti = g_ime_t.imeacti   #TQC-D50127
                   DISPLAY BY NAME g_ime[l_ac].imeacti 
                   NEXT FIELD imeacti
                END IF
             END IF
          END IF 
       #FUN-D40103--add--end--

        BEFORE DELETE                            #是否取消單身
            IF g_ime_t.ime08 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                LET l_buf = ''
                CALL i201_bcheck(g_ime_t.ime02) RETURNING l_buf
                IF g_chr = 'E' THEN  #表示無法刪除此筆資料 
                   ERROR l_buf
                   CANCEL DELETE                   
                END IF
                IF l_lock_sw = "Y" THEN 
                   CALL cl_err("", -263, 1) 
                   CANCEL DELETE 
                END IF 
                SELECT COUNT(*) INTO l_cnt FROM img_file 
                       WHERE img02 = g_imd.imd01
                         AND img03 = g_ime_t.ime02 
                IF l_cnt > 0 THEN 
                   CALL cl_err('','aim-009',0)  #CHI-940047
                   CANCEL DELETE
                END IF
                LET lj_n = 0
                SELECT COUNT(*) INTO lj_n FROM pmc_file 
                  WHERE pmc915 = g_imd.imd01 AND pmc916 =g_ime_t.ime02          
                IF lj_n = 0 THEN
                   SELECT COUNT(*) INTO lj_n FROM pmc_file 
                     WHERE pmc917 = g_imd.imd01 AND pmc918 =g_ime_t.ime02          
                   IF lj_n >0 THEN
                      CALL cl_err('','apm-935',1)             #No.FUN-9A0068  
                      CANCEL DELETE
                   END IF
                ELSE
                   CALL cl_err('','apm-935',1)                #No.FUN-9A0068  
                   CANCEL DELETE
                END IF
                LET g_success = 'Y'                   #FUN-9A0056 add
                DELETE FROM ime_file
                    WHERE ime01=g_imd.imd01 AND ime02 = g_ime_t.ime02
                IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","ime_file",g_ime_t.ime02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                   #ROLLBACK WORK                           #FUN-9A0056 mark
                   #CANCEL DELETE                           #FUN-9A0056 mark
                    LET g_success = 'N'                     #FUN-9A0056 add

                 #FUN-9A0056 mark str -------
                 #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
                 # #FUN-870101---add---str---
                 #ELSE
                 #  #TQC-8A0052---add--str---
                 #  IF g_ime[l_ac].ime02[1,1]<>' ' AND
                 #   NOT cl_null(g_ime[l_ac].ime02) THEN
                 #   # CALL aws_mescli()
                 #   # 傳入參數: (1)程式代號
                 #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
                 #   #           (3)Key
                 #   CASE aws_mescli('aimi201','delete',g_ime[l_ac].ime02)
                 #      WHEN 0  #無與 MES 整合
                 #           MESSAGE 'DELETE O.K'
                 #           LET g_rec_b=g_rec_b-1
                 #           DISPLAY g_rec_b TO FORMONLY.cn2
                 #           COMMIT WORK
                 #      WHEN 1  #呼叫 MES 成功
                 #           MESSAGE 'DELETE O.K, DELETE MES O.K'
                 #           LET g_rec_b=g_rec_b-1
                 #           DISPLAY g_rec_b TO FORMONLY.cn2
                 #           COMMIT WORK
                 #      WHEN 2  #呼叫 MES 失敗
                 #           ROLLBACK WORK
                 #           CANCEL DELETE
                 #   END CASE
                 #  END IF  #TQC-8A0052---add---end---
                 ##FUN-870101---add---end---
                 #END IF   #TQC-8B0011  ADD
                 #FUN-9A0056 mark str  -------- 
                ELSE                                                      #FUN-930109
                  DELETE FROM inc_file                                    #FUN-930109    
                        WHERE inc01 = g_imd.imd01                         #FUN-930109 
                          AND inc02 = g_ime_t.ime02                       #FUN-930109 
                END IF
               #IF g_sma.sma901 = 'Y' THEN                      #FUN-9A0056 mark
                IF g_sma.sma901 = 'Y' AND g_success = 'Y' THEN  #FUN-9A0056 add
                   DELETE FROM vmg_file   #NO.FUN-7C0002 mod
                       WHERE vmg01=g_imd.imd01 AND vmg02 = g_ime_t.ime02   #NO.FUN-7C0002 
                   IF SQLCA.sqlcode THEN
                       CALL cl_err3("del","vmg_file",g_ime_t.ime02,"",SQLCA.sqlcode,"","",1)    #NO.FUN-7C0002 mod
                      #ROLLBACK WORK                             #FUN-9A0056 mark
                      #CANCEL DELETE                             #FUN-9A0056 mark
                       LET g_success = 'N'                       #FUN-9A0056 add
                   END IF
                END IF 
              #FUN-9A0056 add begin ------------
               IF g_aza.aza90 MATCHES "[Yy]" AND g_success = 'Y' THEN
                  LET l_par = g_imd.imd01,"{+}",g_ime_t.ime02
                  IF g_ime_t.ime02[1,1]<>' ' AND NOT cl_null(g_ime_t.ime02) THEN
                    CALL i201_mes('delete',l_par,2)
                  END IF
               END IF

               IF g_success = 'N' THEN
                  ROLLBACK WORK
                  CANCEL DELETE
               ELSE
                  COMMIT WORK
               END IF

               LET g_rec_b=g_rec_b-1
               DISPLAY g_rec_b TO FORMONLY.cn2
              #FUN-9A0056 add end --------------
      ELSE           
          IF NOT cl_delb(0,0) THEN 
                CANCEL DELETE
           END IF
           IF l_lock_sw = "Y" THEN
              CALL cl_err("", -263, 1) 
              CANCEL DELETE
            END IF
            DELETE FROM ime_file
             WHERE ime01=g_imd.imd01
               AND ime02 = g_ime_t.ime02
            IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","ime_file",g_ime_t.ime02,"",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE               
            END IF
            LET g_rec_b=g_rec_b-1
            DISPLAY g_rec_b TO FORMONLY.cn2
           COMMIT WORK
      END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ime[l_ac].* = g_ime_t.*
               CLOSE i201_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
                CALL cl_err(g_ime[l_ac].ime02,-263,1)
                LET g_ime[l_ac].* = g_ime_t.*
            ELSE
                IF g_ime[l_ac].ime02 IS NULL THEN
                    LET g_ime[l_ac].ime02 = ' '
                END IF
                LET g_success = 'Y'              #FUN-9A0056 add
                IF l_bcur = '1' THEN 
                #TQC-A50098 --begin--
                    IF cl_null(g_ime[l_ac].ime12) THEN 
                       LET g_ime[l_ac].ime12 = '0' 
                    END IF 
               #TQC-A50098 --end--                    
                    UPDATE ime_file SET
                                ime02  = g_ime[l_ac].ime02,
                                ime03  = g_ime[l_ac].ime03,
                                ime05  = g_ime[l_ac].ime05,
                                ime06  = g_ime[l_ac].ime06,
                                ime07  = g_ime[l_ac].ime07,
                                ime12  = g_ime[l_ac].ime12,             #FUN-940083 add
                                ime08  = g_ime[l_ac].ime08,
                                ime09  = g_ime[l_ac].ime09,
                                ime091 = g_ime[l_ac].ime091,            #FUN-680034--加ime091
                                ime13  = g_ime[l_ac].ime13,             #FUN-960141
                                ime131 = g_ime[l_ac].ime131,            #FUN-960141
                                ime10  = g_ime[l_ac].ime10,
                                ime11  = g_ime[l_ac].ime11,
                                ime17  = g_ime[l_ac].ime17,             #FUN-930109 
                                imeacti= g_ime[l_ac].imeacti            #FUN-D40103 add
                     WHERE ime02=g_ime_t.ime02 
                       AND ime01=g_imd.imd01
                    IF g_ime[l_ac].ime02 <> g_ime_t.ime02 AND g_ime_t.ime02 <> ' '  THEN          #FUN-930109
                       UPDATE inc_file SET                                                        #FUN-930109
                                   inc02  = g_ime[l_ac].ime02                                     #FUN-930109
                        WHERE inc02=g_ime_t.ime02                                                 #FUN-930109
                          AND inc01=g_imd.imd01                                                   #FUN-930109
                    END IF                                                                        #FUN-930109  
                ELSE
                #TQC-A50098 --begin--
                    IF cl_null(g_ime[l_ac].ime12) THEN 
                       LET g_ime[l_ac].ime12 = '0' 
                    END IF 
               #TQC-A50098 --end--                 	
                    UPDATE ime_file SET
                                ime02  = g_ime[l_ac].ime02,
                                ime03  = g_ime[l_ac].ime03,
                                ime05  = g_ime[l_ac].ime05,
                                ime06  = g_ime[l_ac].ime06,
                                ime07  = g_ime[l_ac].ime07,
                                ime12  = g_ime[l_ac].ime12,             #FUN-940083 add
                                ime08  = g_ime[l_ac].ime08,
                                ime09  = g_ime[l_ac].ime09,
                                ime091 = g_ime[l_ac].ime091,            #FUN-680034--加ime091 
                                ime13  = g_ime[l_ac].ime13,             #FUN-960141
                                ime131 = g_ime[l_ac].ime131,            #FUN-960141
                                ime10  = g_ime[l_ac].ime10,
                                ime11  = g_ime[l_ac].ime11,
                                ime17  = g_ime[l_ac].ime17              #FUN-930109
                     WHERE ime02 IS NULL 
                       AND ime01 = g_imd.imd01
                    IF g_ime[l_ac].ime02 <> g_ime_t.ime02 AND g_ime_t.ime02 <> ' '  THEN          #FUN-930109
                       UPDATE inc_file SET                                                        #FUN-930109
                                   inc02  = g_ime[l_ac].ime02                                     #FUN-930109
                        WHERE inc02=g_ime_t.ime02                                                 #FUN-930109
                          AND inc01=g_imd.imd01                                                   #FUN-930109
                    END IF                                                                        #FUN-930109                        
                END IF
                IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","ime_file",g_imd.imd01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                   #LET g_ime[l_ac].* = g_ime_t.*   #FUN-9A0056 mark
                    LET g_success = 'N'             #FUN-9A0056 add
                ELSE
                    IF g_sma.sma901 = 'Y' THEN
                       IF g_ime[l_ac].ime02 != g_ime_t.ime02 THEN
                          UPDATE vmg_File SET vmg02 = g_ime[l_ac].ime02   #NO.FUN-7C0002 mod
                           WHERE vmg01 = g_imd.imd01 AND vmg02 = g_ime_t.ime02
                          IF SQLCA.sqlcode THEN
                              CALL cl_err3("upd","vmg_file",g_imd.imd01,  #NO.FUN-7C0002 mod
                                            g_ime_t.ime02,SQLCA.sqlcode,"","",1)  
                             #ROLLBACK WORK                           #FUN-9A0056 mark
                             #LET g_ime[l_ac].* = g_ime_t.*           #FUN-9A0056 mark
                              LET g_success = 'N'                     #FUN-9A0056 add
                          END IF
                       END IF
                    END IF
 
                    #當單身之[可用否],[MRP可用否]及[保稅否]等欄位有更改時,
                    #其下游檔案(img_file)之相關欄位,亦需更新
                    UPDATE img_file SET
                                      img23 = g_ime[l_ac].ime05,
                                      img24 = g_ime[l_ac].ime06,
                                      img25 = g_ime[l_ac].ime07
                            WHERE (g_ime[l_ac].ime05 != g_ime_t.ime05 OR
                                   g_ime[l_ac].ime06 != g_ime_t.ime06 OR
                                   g_ime[l_ac].ime07 != g_ime_t.ime07) AND 
                                   img02 = g_imd.imd01 AND 
                                   img03 = g_ime[l_ac].ime02
                    IF SQLCA.sqlcode THEN
                        CALL cl_err3("upd","img_file",g_imd.imd01,
                                      g_ime[l_ac].ime02,SQLCA.sqlcode,"","",1)  #No.FUN-660156
                       #LET g_ime[l_ac].* = g_ime_t.*      #FUN-9A0056 mark
                        LET g_success = 'N'                #FUN-9A0056 add
                    ELSE
                        #更新[可用量],[不可用量],[mrp可用量],[mrp不可用量]
                        IF g_ime_t.ime05<>g_ime[l_ac].ime05 OR
                           g_ime_t.ime06<>g_ime[l_ac].ime06 THEN
                          #LET g_success='Y'                       #FUN-9A0056 mark
                           CALL i201_bu_imamrp(g_ime[l_ac].ime02)
                          #FUN-9A0056 mark str ---
                          #IF g_success='N' THEN
                          #   ROLLBACK WORK
                          #   LET g_ime[l_ac].* = g_ime_t.*
                          #END IF
                          #FUN-9A0056 mark end ---
                        END IF
                        MESSAGE 'UPDATE O.K'
                       #COMMIT WORK                                #FUN-9A0056 mark
                    END IF
                END IF
               #FUN-9A0056 add begin -----------------------------
                IF g_success = 'Y' AND g_aza.aza90 MATCHES "[Yy]" THEN  #FUN-950072 add
                  IF g_ime[l_ac].ime02[1,1] != ' ' THEN
                     LET l_par = g_imd.imd01,"{+}",g_ime[l_ac].ime02,"{+}",g_ime_t.ime02
                     CALL i201_mes('update',l_par,2)
                  END IF
                END IF

                IF g_success = 'Y' THEN
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                ELSE
                   LET g_ime[l_ac].* = g_ime_t.*
                   ROLLBACK WORK
                   EXIT INPUT
                END IF
               #FUN-9A0056 add end ----------------------------

              #FUN-9A0056 mark str ----
              ##TQC-8A0052---add---str---
              #IF g_ime[l_ac].ime02[1,1] != ' ' AND
              #   NOT cl_null(g_ime[l_ac].ime02) THEN

              #IF g_aza.aza90 MATCHES "[Yy]" THEN   #TQC-8B0011  ADD
              #   #FUN-870101---add---str---
              #   # CALL aws_mescli()
              #   # 傳入參數: (1)程式代號
              #   #           (2)功能選項：insert(新增),update(修改),delete(刪除)
              #   #           (3)Key
              #     CASE aws_mescli('aimi201','update',g_ime[l_ac].ime02)
              #        WHEN 0  #無與 MES 整合
              #             MESSAGE 'UPDATE O.K'
              #        WHEN 1  #呼叫 MES 成功
              #             MESSAGE 'UPDATE O.K, UPDATE MES O.K'
              #        WHEN 2  #呼叫 MES 失敗
              #             ROLLBACK WORK
              #     END CASE
              #   #FUN-870101---add---end---
              #END  IF  #TQC-8B0011  ADD
              #END IF
              ##TQC-8A0052---add---end---
              #FUN-9A0056 mark end -------- 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac       #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd ='u' THEN
                  LET g_ime[l_ac].* = g_ime_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_ime.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--   
               END IF
               CLOSE i201_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac       #FUN-D40030 Add
           #因ime02空白一直無法走after insert,insert段只好放到after row 
           IF l_chr='a' THEN
#TQC-A50098 --begin--
              IF cl_null(g_ime[l_ac].ime12) THEN 
                 LET g_ime[l_ac].ime12 = '0' 
              END IF 
#TQC-A50098 --end--            
              LET l_chr=''                  
              INSERT INTO ime_file(ime01,ime02,ime03,ime04,ime05,ime06,  
                                  ime07,ime12,ime08,ime09,ime091,ime13,ime131,ime10,ime11,ime17,imeacti)    #FUN-680034--加ime091  #FUN-930109 Add ime17 #FUN-940083 add ime12 #FUN-960141 add ime13,ime131  #FUN-D40103 imeacti
                                  #ime07,ime08,ime09,ime091,ime10,ime11,ime17)    #FUN-680034--加ime091  #FUN-930109 Add ime17 #FUN-940083 add ime12
                  VALUES(g_imd.imd01,' ',' ',
                         g_imd.imd10,g_imd.imd11,g_imd.imd12,
                         g_imd.imd13,g_ime[l_ac].ime12,'0','',                         #FUN-940083 add ime12
                         '','','',g_imd.imd14,g_imd.imd15,g_ime[l_ac].ime17,g_ime[l_ac].imeacti)                                  #FUN-930109 Add ime17 #FUN-960141 add '','' #FUN-D40103 imeacti
             IF (SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0) THEN # AND   #MOD-570193
                CALL cl_err3("ins","ime_file",g_ime[l_ac].ime02,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                CLOSE i201_bcl
                ROLLBACK WORK
                EXIT INPUT
             ELSE
               LET l_sql = "SELECT inc03 ",                                                                                             
                           "  FROM inc_file",                                                                               
                           " WHERE inc01 = '",g_imd.imd01,"'",                                                                                     
                           "   AND inc02 = ' '"                                                                
               PREPARE inc_prepare1 FROM l_sql                                                                                               
               DECLARE inc_c1  CURSOR FOR inc_prepare1                                                                                       
               OPEN inc_c1                                                                                                                   
               FETCH inc_c1 INTO l_inc03
               IF SQLCA.sqlcode THEN
                  LET l_inc03 = ' ' 
               END IF                
               IF cl_null(l_inc03) THEN LET l_inc03 = ' ' END IF                                   
               INSERT INTO inc_file(inc01,inc02,inc03)
                   VALUES(g_imd.imd01,g_ime[l_ac].ime02,l_inc03)
               IF (SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0) THEN
                  CALL cl_err3("ins","inc_file",g_imd.imd01,"",SQLCA.sqlcode,"","",1)
                  ROLLBACK WORK
                  EXIT INPUT                 
               ELSE
                DISPLAY 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2  
                CLOSE i201_bcl
                CALL i201_b_fill(" 1=1")
               END IF                                           #FUN-930109
             END IF
           ELSE
            CLOSE i201_bcl
            COMMIT WORK
           END IF #MOD-850215 add
 
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ime02) AND l_ac > 1 THEN
                LET g_ime[l_ac].* = g_ime[l_ac-1].*
                DISPLAY g_ime[l_ac].* TO s_ime[l_ac].*
                NEXT FIELD ime02
            END IF
 
        ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE WHEN INFIELD(ime09) #會計科目
             IF g_sma.sma03='Y' THEN
                LET g_db1 = g_sma.sma87
             ELSE
                LET g_db1 = g_plant
             END IF
             SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
              WHERE azp01=g_db1
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_aag1"     #No.TQC-710110
              LET g_qryparam.plant = g_db1       #No.FUN-980025 add   
              LET g_qryparam.default1 = g_ime[l_ac].ime09
              LET g_qryparam.arg2 = g_bookno1  #No.FUN-730033
              CALL cl_create_qry() RETURNING g_ime[l_ac].ime09
                DISPLAY BY NAME g_ime[l_ac].ime09 
                NEXT FIELD ime09
           END CASE
 
           CASE WHEN INFIELD(ime091) #會計科目二                                                                                       
              IF g_sma.sma03='Y' THEN
                 LET g_db1 = g_sma.sma87
              ELSE
                 LET g_db1 = g_plant
              END IF
              SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
               WHERE azp01=g_db1
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form     = "q_aag1"     #No.TQC-710110
              LET g_qryparam.plant = g_db1       #No.FUN-980025 add   
              LET g_qryparam.arg2 = g_bookno2  #No.FUN-730033
              LET g_qryparam.default1 = g_ime[l_ac].ime091                                                                           
              CALL cl_create_qry() RETURNING g_ime[l_ac].ime091                                                                      
                DISPLAY BY NAME g_ime[l_ac].ime091                                                                                   
                NEXT FIELD ime091                                                                                                    
           END CASE
           CASE WHEN INFIELD(ime13) #代銷科目
             IF g_sma.sma03='Y' THEN
                LET g_db1 = g_sma.sma87
             ELSE
                LET g_db1 = g_plant
             END IF
             SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
              WHERE azp01=g_db1
              CALL cl_init_qry_var()
              LET g_qryparam.form     = "q_aag1" 
              LET g_qryparam.plant = g_db1       #No.FUN-980025 add   
              LET g_qryparam.default1 = g_ime[l_ac].ime13
              LET g_qryparam.arg2 = g_bookno1  
              CALL cl_create_qry() RETURNING g_ime[l_ac].ime13
              DISPLAY BY NAME g_ime[l_ac].ime13
              NEXT FIELD ime13
           END CASE
           CASE WHEN INFIELD(ime131) #代銷科目二                                                                                       
              IF g_sma.sma03='Y' THEN
                 LET g_db1 = g_sma.sma87
              ELSE
                 LET g_db1 = g_plant
              END IF
              SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
               WHERE azp01=g_db1
              CALL cl_init_qry_var()                                                                                                
              LET g_qryparam.form     = "q_aag1" 
              LET g_qryparam.plant = g_db1       #No.FUN-980025 add   
              LET g_qryparam.arg2 = g_bookno2 
              LET g_qryparam.default1 = g_ime[l_ac].ime131
              CALL cl_create_qry() RETURNING g_ime[l_ac].ime131                                                                      
                DISPLAY BY NAME g_ime[l_ac].ime131                                                                                   
                NEXT FIELD ime131                                                                                                    
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
          
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
        
        END INPUT
 
        UPDATE imd_file SET imdmodu=g_user,imddate=g_today
            WHERE imd01=g_imd.imd01
 
    CLOSE i201_bcl
    CLOSE i201_bc1
    COMMIT WORK
    CALL i201_delHeader()     #CHI-C30002 add
END FUNCTION
   
#CHI-C30002 -------- add -------- begin
FUNCTION i201_delHeader()
   IF g_rec_b = 0 THEN
      IF cl_confirm("9042") THEN
        DELETE FROM vmf_file WHERE vmf01 = g_imd.imd01 
        DELETE FROM imd_file WHERE imd01 = g_imd.imd01
         INITIALIZE g_imd.*  TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

FUNCTION i201_delall()
    SELECT COUNT(*) INTO g_cnt FROM ime_file
        WHERE ime01 = g_imd.imd01
    IF g_cnt = 0 THEN 			# 未輸入單身資料, 是否取消單頭資料
       CALL cl_getmsg('9044',g_lang) RETURNING g_msg
       ERROR g_msg CLIPPED
       DELETE FROM vmf_file WHERE vmf01 = g_imd.imd01  #FUN-890085
       DELETE FROM imd_file WHERE imd01 = g_imd.imd01
    END IF
END FUNCTION
FUNCTION i201_bu_imamrp(l_ime02)
   DEFINE l_sql2  LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(200)
          l_ime02 LIKE ime_file.ime02,
          l_ima01 LIKE ima_file.ima01
          
        LET l_sql2 = " SELECT UNIQUE img01 ",
                     "   FROM img_file ",
                     "  WHERE img02='",g_imd.imd01,"' ",
                     "    AND img03='",l_ime02,"' ",
                     "  ORDER BY img01 "
        PREPARE i201_bimaup FROM l_sql2      #預備一下
        DECLARE ima_bup CURSOR FOR i201_bimaup
 
        FOREACH ima_bup INTO l_ima01
           LET g_i=s_udima(l_ima01,'','',0,'',3) #重計
           IF g_i THEN LET g_success='N' EXIT FOREACH END IF
        END FOREACH
        IF SQLCA.sqlcode THEN
           CALL cl_err('FOREACH:',SQLCA.sqlcode,0)
           LET g_success='N'
        END IF
        
END FUNCTION
 
FUNCTION i201_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(200)
 
    CONSTRUCT l_wc ON ime02,ime03,imed04,ime05,ime06,  #螢幕上取單身條件
                      ime07,ime12,ime08,ime09,ime091,ime13,ime131,ime10,ime11,ime17,imeacti            #FUN-680034--加ime091 #FUN-930109 Add ime17 #FUN-940083 add ime12 #FUN-960141 add ime13,ime131  #FUN-D40103 imeacti
       FROM s_ime[1].ime02,s_ime[1].ime03,s_ime[1].ime04,s_ime[1].ime05,
            s_ime[1].ime06,s_ime[1].ime07,s_ime[1].ime12,s_ime[1].ime08,s_ime[1].ime09,     #FUN-940083 add ime12
            s_ime[1].ime091,
            s_ime[1].ime13,s_ime[1].ime131,  #FUN-960141
            s_ime[1].ime10,s_ime[1].ime11,s_ime[1].ime17,s_ime[1].imeacti    #FUN-680034--加ime091 #FUN-930109 Add ime17 #FUN-D40103 imeacti
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
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
    CALL i201_b_fill(l_wc)
END FUNCTION
 
FUNCTION i201_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000 #No.FUN-690026 VARCHAR(400)
 
    LET g_sql =
       "SELECT ime02,ime03,ime04,ime05,ime06,",
       " ime07,ime12,ime08,ime09,ime091,ime13,ime131,ime10,ime11,ime17,imeacti",     #FUN-680034--加ime091  #FUN-930109 Add ime17 #FUN-940083 add ime12 #CHI-940047 mod #FUN-960141 add ime13,ime131 #FUN-D40103 imeacti
       " FROM ime_file",
       " WHERE ime01 = '",g_imd.imd01,"' AND ",p_wc CLIPPED ,
       " ORDER BY ime02"
    PREPARE i201_prepare2 FROM g_sql      #預備一下
    DECLARE ime_cs CURSOR FOR i201_prepare2
    CALL g_ime.clear()
    LET g_cnt = 1
    LET g_rec_b=0
    FOREACH ime_cs INTO g_ime[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_ime.deleteElement(g_cnt)   #取消 Array Element
    LET g_rec_b = g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i201_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_ime TO s_ime.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         IF g_sma.sma901!='Y' THEN
            CALL cl_set_act_visible("aps_related_warehouse",FALSE)
            CALL cl_set_act_visible("aps_related_location",FALSE)
         END IF
         IF g_flag1 = 'Y' THEN
            CALL fgl_set_arr_curr(l_ac)
            LET g_flag1 = 'N'
         END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
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
         CALL i201_fetch('F')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i201_fetch('P')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION jump
         CALL i201_fetch('/')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL i201_fetch('N')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last
         CALL i201_fetch('L')
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
	 ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
         LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_set_field_pic("","","","","",g_imd.imdacti)
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel #FUN-4B0002
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION related_document                #No.FUN-680046  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
            
      ON ACTION aps_related_warehouse
         LET g_action_choice="aps_related_warehouse"
         EXIT DISPLAY
 
      ON ACTION aps_related_location
         LET g_action_choice="aps_related_location"
         LET g_flag1 = 'Y'
         EXIT DISPLAY
 
      ON ACTION maintenance_administrators
         LET g_action_choice="maintenance_administrators"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
     ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
      &include "qry_string.4gl"
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION i201_copy()
DEFINE
    l_newno         LIKE imd_file.imd01,
    l_oldno         LIKE imd_file.imd01
 
    IF s_shut(0) THEN RETURN END IF
    IF g_imd.imd01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    LET g_before_input_done = FALSE   #FUN-580026
    CALL i201_set_entry('a')          #FUN-580026
    LET g_before_input_done = TRUE    #FUN-580026
    CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
    INPUT l_newno FROM imd01
        AFTER FIELD imd01
            IF l_newno IS NULL THEN
                NEXT FIELD imd01
            END IF
            SELECT count(*) INTO g_cnt FROM imd_file
                WHERE imd01 = l_newno
            IF g_cnt > 0 THEN
                CALL cl_err(l_newno,-239,0)
                NEXT FIELD imd01
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
    IF INT_FLAG OR l_newno IS NULL THEN
        LET INT_FLAG = 0
        RETURN
    END IF
    DROP TABLE y
    SELECT * FROM imd_file
        WHERE imd01=g_imd.imd01
        INTO TEMP y
    UPDATE y
        SET y.imd01=l_newno,    #資料鍵值
            y.imduser = g_user,
            y.imdgrup = g_grup,
            y.imddate = g_today,
            y.imdacti = 'Y'
    INSERT INTO imd_file  #複製單頭
        SELECT * FROM y
    IF SQLCA.sqlcode THEN
       CALL cl_err3("ins","imd_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
    END IF
    DROP TABLE x
    SELECT * FROM ime_file
       WHERE ime01 = g_imd.imd01
       INTO TEMP x
    UPDATE x
       SET ime01 = l_newno
    UPDATE x SET ime02=' ' WHERE ime02 is null AND imf01=l_newno
    INSERT INTO ime_file    #複製單身
       SELECT * FROM x
    IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","ime_file",l_newno,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
        LET g_flag3 = 'Y'             #FUN-9A0056 add
    ELSE
        MESSAGE 'ROW(',l_newno,') O.K' 
        LET l_oldno = g_imd.imd01
        SELECT imd_file.* INTO g_imd.* FROM imd_file
               WHERE imd01 =  l_newno
        CALL i201_u()
        CALL i201_show()
        #FUN-C30027---begin
        #LET g_imd.imd01 = l_oldno
        #SELECT imd_file.* INTO g_imd.* FROM imd_file
        #       WHERE imd01 = g_imd.imd01
        #CALL i201_show()
        #FUN-C30027---end
    END IF
    DISPLAY BY NAME g_imd.imd01
END FUNCTION

FUNCTION i201_out()
DEFINE  l_cmd       LIKE type_file.chr1000 #NO.FUN-7C0043                                                                           
                                                                                                                                    
     IF cl_null(g_wc) AND NOT cl_null(g_imd.imd01) THEN                                                                             
         LET g_wc= " imd01='",g_imd.imd01,"'"                                                                                       
     END IF                                                                                                                         
     IF cl_null(g_wc)  THEN                                                                                                         
         CALL cl_err('','9057',0)                                                                                                   
         RETURN                                                                                                                     
     END IF                                                                                                                         
     IF cl_null(g_wc2) THEN                                                                                                         
         LET g_wc2 = " 1=1"                                                                                                         
     END IF                                                                                                                         
     LET l_cmd = 'p_query "aimi201" "',g_bookno1,'" "',g_wc CLIPPED,'" "',g_wc2 CLIPPED,'"'                                         
     CALL cl_cmdrun(l_cmd)                                                                                                          
     RETURN                                                                                                                         
END FUNCTION

#單頭
FUNCTION i201_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("imd01",TRUE)
   END IF
#  CALL cl_set_comp_entry("imd11,imd12,imd23",TRUE)   #FUN-CB0052 #FUN-D10143 add imd23  #FUN-D30024 mark imd23
   CALL cl_set_comp_entry("imd11,imd12",TRUE)         #FUN-D30024 mark imd23
 
END FUNCTION
 
FUNCTION i201_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   IF (NOT g_before_input_done) THEN
       IF p_cmd = 'u' AND g_chkey = 'N' THEN
           CALL cl_set_comp_entry("imd01",FALSE)
       END IF
   END IF
   #FUN-CB0052--add--str--
   IF NOT cl_null(g_imd.imd10) THEN 
      IF g_imd.imd10 MATCHES '[Ii]' THEN 
      #  CALL cl_set_comp_entry("imd11,imd12,imd23",FALSE) #FUN-D10143 add imd23    #FUN-D30024 mark imd23 
         CALL cl_set_comp_entry("imd11,imd12",FALSE)       #FUN-D30024 
      END IF
   END IF
   #FUN-CB0052--add--end--
 
END FUNCTION
 
#單身
FUNCTION i201_set_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF NOT g_before_input_done THEN                      #MOD-4A0269
       CALL cl_set_comp_entry("ime05,ime06,ime07",TRUE)
    END IF
    IF INFIELD(ime08) OR p_cmd = 'u' THEN                 #MOD-4A0269
       CALL cl_set_comp_entry("ime09",TRUE)
       CALL cl_set_comp_entry("ime091",TRUE)              #FUN-680034
       CALL cl_set_comp_entry("ime13",TRUE)               #FUN-960141
       CALL cl_set_comp_entry("ime131",TRUE)              #FUN-960141
    END IF
    IF g_imd.imd17 = 'Y' THEN                             #FUN-930109                  
       CALL cl_set_comp_entry("ime17",TRUE)               #FUN-930109
    END IF                                                #FUN-930109
    IF NOT INFIELD(ime08) THEN                            #TQC-D50127 by free
       CALL cl_set_comp_entry("imeacti",TRUE)             #FUN-D40103
    END IF                                                #TQC-D50127 by free
END FUNCTION
 
FUNCTION i201_set_no_entry_b(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
    IF INFIELD(ime08) OR p_cmd = 'u' THEN #MOD-4A0269
       IF g_ime[l_ac].ime08 != '2' THEN
           CALL cl_set_comp_entry("ime09",FALSE)
           CALL cl_set_comp_entry("ime091",FALSE)         #FUN-680034
           CALL cl_set_comp_entry("ime13",FALSE)               #FUN-960141
           CALL cl_set_comp_entry("ime131",FALSE)              #FUN-960141
       END IF
   END IF
   IF (NOT g_before_input_done) THEN
       IF g_imd.imd11 = 'N' THEN
           CALL cl_set_comp_entry("ime05",FALSE)
       END IF
       IF g_imd.imd12 = 'N' THEN
           CALL cl_set_comp_entry("ime06",FALSE)
       END IF
       IF g_imd.imd13 = 'N' THEN
           CALL cl_set_comp_entry("ime07",FALSE)
       END IF
    END IF
    IF g_imd.imd17 = 'N' THEN                             #FUN-930109                  
       CALL cl_set_comp_entry("ime17",FALSE)              #FUN-930109
    END IF                                                #FUN-930109   
 
END FUNCTION
 
FUNCTION i201_aps_warehouse()     
    DEFINE l_vmf        RECORD LIKE vmf_file.*   #NO.FUN-7C0002 
 
    LET g_action_choice="aps_related_warehouse"                     
 
    IF cl_null(g_imd.imd01) THEN
        CALL cl_err('',-400,1)               #TQC-750013 add
        RETURN                               #TQC-750013 add
    END IF
 
    IF NOT cl_null(g_imd.imd01) THEN   #FUN-720043---mod--
       SELECT vmf01 FROM vmf_file WHERE vmf01 = g_imd.imd01
       IF SQLCA.sqlcode=100 THEN
          LET l_vmf.vmf01 = g_imd.imd01
          LET l_vmf.vmf04 = 0
          LET l_vmf.vmf05 = 0
          LET l_vmf.vmf06 = 0  #FUN-870012 add vmf06
          LET l_vmf.vmf07 = 0  #FUN-910005 ADD
          INSERT INTO vmf_file(vmf01,vmf04,vmf05,vmf06,vmf07)   #FUN-910005 ADD vmf07
                        VALUES(l_vmf.vmf01,l_vmf.vmf04,l_vmf.vmf05,l_vmf.vmf06,l_vmf.vmf07)  #FUN-910005 ADD vmf07
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vmf_file",g_imd.imd01,"",SQLCA.sqlcode,
                          "","",1)  
          END IF
       END IF
       LET g_cmd = "apsi305 '",g_imd.imd01,"'"
       CALL cl_cmdrun(g_cmd)
    END IF
END FUNCTION
 
FUNCTION i201_aps_location()     
    DEFINE l_vmg        RECORD LIKE vmg_file.*   #NO.FUN-7C0002 
 
    LET g_action_choice="aps_related_location"                     
 
    IF cl_null(g_imd.imd01) THEN
        CALL cl_err('',-400,1)               #TQC-750013 add
        RETURN                               #TQC-750013 add
    END IF
    IF cl_null(l_ac) OR l_ac = 0 THEN LET l_ac = 1 END IF  
    IF cl_null(g_ime[l_ac].ime02) THEN
        CALL cl_err('','arm-034',1)
        RETURN 
    END IF
 
    IF NOT cl_null(g_imd.imd01) THEN #FUN-720043---mod---
       SELECT vmg01,vmg02 FROM vmg_file WHERE vmg01 = g_imd.imd01 
                                          AND vmg02 = g_ime[l_ac].ime02
       IF SQLCA.sqlcode=100 THEN
          LET l_vmg.vmg01 = g_imd.imd01
          LET l_vmg.vmg02 = g_ime[l_ac].ime02
          LET l_vmg.vmg05 = 0
          LET l_vmg.vmg06 = 0  #FUN-910005 ADD 
          INSERT INTO vmg_file VALUES(l_vmg.vmg01,l_vmg.vmg02,l_vmg.vmg05,l_vmg.vmg06)  #FUN-910005  ADD vmg06
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","vmg_file",g_imd.imd01,g_ime[l_ac].ime02,
                           SQLCA.sqlcode,"","",1)
          END IF
       END IF
       LET g_cmd = "apsi306 '",g_imd.imd01,"' '",g_ime[l_ac].ime02,"'"
       CALL cl_cmdrun(g_cmd)
    END IF
END FUNCTION
 
FUNCTION i201_bookno()
   IF g_sma.sma03='Y' THEN
      LET g_db1 = g_sma.sma87
   ELSE
      LET g_db1 = g_plant
   END IF
   LET g_plantm = g_db1                    #FUN-980020
   SELECT azp03 INTO g_azp03 FROM azp_file                                                                                        
    WHERE azp01=g_db1
   LET g_db_type=cl_db_get_database_type()
 
   LET g_dbsm = s_dbstring(g_azp03)         #add                                                                                    
   CALL s_get_bookno1(NULL,g_plantm)        #FUN-980020
        RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag =  '1' THEN  #抓不到帳別
      CALL cl_err(g_dbsm,'aoo-081',1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
   END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼 

#FUN-9A0056 -- add i201_mes() for MES
FUNCTION i201_mes(p_key1,p_key2,p_key3)
 DEFINE p_key1   VARCHAR(6)
 DEFINE p_key2   VARCHAR(500)
 DEFINE p_key3   SMALLINT        #p_key3 = 1 呼叫傳送MES倉庫函式 ; p_key3 = 2 呼叫傳送MES儲位函式
 DEFINE l_mesg01 VARCHAR(30)

 CASE p_key1
    WHEN 'insert'  #新增
         LET l_mesg01 = 'INSERT O.K, INSERT MES O.K'
    WHEN 'update'  #修改
         LET l_mesg01 = 'UPDATE O.K, UPDATE MES O.K'
    WHEN 'delete'  #刪除
         LET l_mesg01 = 'DELETE O.K, DELETE MES O.K'
    OTHERWISE
 END CASE

# CALL aws_mescli
# 傳入參數: (1)程式代號
#           (2)功能選項：insert(新增),update(修改),delete(刪除)
#           (3)Key
#
 IF p_key3 = 1 THEN
   CASE aws_mescli('aimi200',p_key1,p_key2)
      WHEN 1  #呼叫 MES 成功
           MESSAGE l_mesg01
           LET g_success = 'Y'
      WHEN 2  #呼叫 MES 失敗
           LET g_success = 'N'
      OTHERWISE  #其他異常
           LET g_success = 'N'
   END CASE
 ELSE
   CASE aws_mescli('aimi201',p_key1,p_key2)
      WHEN 1  #呼叫 MES 成功
           MESSAGE l_mesg01
           LET g_success = 'Y'
      WHEN 2  #呼叫 MES 失敗
           LET g_success = 'N'
      OTHERWISE  #其他異常
           LET g_success = 'N'
   END CASE
 END IF

END FUNCTION
#FUN-9A0056 -- add end ------                 

#FUN-D40103--add--str--
FUNCTION i201_check_imeacti()
   DEFINE l_n       LIKE type_file.num5 
   DEFINE l_errno   STRING

   #check aimi100/aimi101
   SELECT COUNT(*) INTO l_n FROM ima_file  
    WHERE ima35=g_imd.imd01  AND ima36=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF 

   #check aimi104
   SELECT COUNT(*) INTO l_n FROM ima_file
    WHERE ima136=g_imd.imd01  AND ima137=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF
    
   #check aimi110
   SELECT COUNT(*) INTO l_n FROM imz_file
    WHERE imz35=g_imd.imd01  AND imz36=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF

   #check aimi112
   SELECT COUNT(*) INTO l_n FROM imz_file
    WHERE imz136=g_imd.imd01  AND imz137=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF

   #check aimi150/aimi151
   SELECT COUNT(*) INTO l_n FROM imaa_file
    WHERE imaa35=g_imd.imd01  AND imaa36=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF

   #check aimi154
   SELECT COUNT(*) INTO l_n FROM imaa_file
    WHERE imaa136=g_imd.imd01  AND imaa137=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF

   #check aqci107 
   SELECT COUNT(*) INTO l_n FROM qco_file
    WHERE qco07=g_imd.imd01  AND qco08=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF

   #check axmi226 
   SELECT COUNT(*) INTO l_n FROM tuo_file
    WHERE tuo04=g_imd.imd01 AND tuo05=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF


   #check apmi600 
   SELECT COUNT(*) INTO l_n FROM pmc_file
    WHERE (pmc915=g_imd.imd01 AND pmc916=g_ime[l_ac].ime02)
       OR (pmc917=g_imd.imd01 AND pmc918=g_ime[l_ac].ime02)
   IF l_n > 0 THEN RETURN FALSE END IF

   #check aqci106 
   SELECT COUNT(*) INTO l_n FROM qcl_file
    WHERE qcl06=g_imd.imd01 AND qcl07=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF


   #asfi301
   SELECT COUNT(*) INTO l_n FROM sfa_file,sfb_file
    WHERE sfa01=sfb01 AND sfb04<>'8' 
      AND sfa30=g_imd.imd01 AND sfa31=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF

   #apmt540
   SELECT COUNT(*) INTO l_n FROM pmn_file,pmm_file
    WHERE pmn01=pmm01 AND pmm25<>'6' AND pmn16 NOT IN ('6','7','8')
      AND pmn52=g_imd.imd01 AND pmn54=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF

   #apmt110
   SELECT COUNT(*) INTO l_n FROM rva_file,rvb_file
    WHERE rva01=rvb01 
      AND rvb36=g_imd.imd01 AND rvb37=g_ime[l_ac].ime02
   IF l_n > 0 THEN RETURN FALSE END IF

   #apmt420  #沒有倉庫 庫位
   #SELECT COUNT(*) INTO l_n FROM pmk_file,pml_file
   # WHERE pmk01=pml01 AND pmk25<>'6' AND pml16<>'6'
   #IF l_n > 0 THEN RETURN FALSE END IF

   #axmt400
   SELECT COUNT(*) INTO l_n FROM oea_file,oeb_file
    WHERE oea01=oeb01 AND oea49<>'2' 
      AND oeb09=g_imd.imd01 AND oeb091=g_ime[l_ac].ime02
      AND (trim(oeb08) IS NULL OR oeb08=g_plant)
   IF l_n > 0 THEN RETURN FALSE END IF

   #axmt620
   SELECT COUNT(*) INTO l_n FROM oga_file,ogb_file
    WHERE oga01=ogb01 
      AND ogb09=g_imd.imd01 AND ogb091=g_ime[l_ac].ime02
      AND (trim(ogb08) IS NULL OR ogb08=g_plant)
   IF l_n > 0 THEN RETURN FALSE END IF

   RETURN TRUE
END FUNCTION
#FUN-D40103--add--end--

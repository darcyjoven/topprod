# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: axct200.4gl
# Descriptions...: 每日工時維護作業
# Date & Author..: 96/01/17 By Roger
# Modify.........: 98/12/15 By ANN CHEN =>Modify G(t200_g) Function.
# Modify.........: No:9310 04/03/05 By Melody 應該要卡關帳日期
# Modify.........: #No.MOD-490217 04/09/10 by yiting 料號欄位使用like方式
# Modify.........: #No.MOD-4A0228 04/10/20 by Carol 按 action "擷取" 按放棄時按 action "擷取" 按放棄時INT_FLAG的寫法修改
# Modify.........: No.FUN-4B0015 04/11/09 By Pengu 新增Array轉Excel檔功能
# Modify.........: No.MOD-4B0103 04/11/12 By ching 僅依年月,成本中心給 ' '
# Modify.........: No.FUN-4C0061 04/12/08 By pengu Data and Group權限控管
# Modify.........: No.MOD-530541 05/03/26 By Carol 單身輸入時,在工單欄位controlp call q_sfb ,
#                                                  axct200加上" sfb04 IN ('2','3','4','5','6')" 的條件,這造成在本月己完工的工單找不到了,
#                                                  是否只要排除成會結案日在本月以前之工單即可
# Modify.........: No.FUN-550025 05/05/16 By vivien 單據編號格式放大
# Modify.........: No.FUN-570273 05/07/29 By Dido  單身未輸入確認無法跳出視窗
# Modify.........: No.MOD-580264 05/08/25 By Rosa 每日工時維護, 按更改鍵游標會成漏斗狀無法作業
# Modify.........: No.MOD-580322 05/08/31 By wujie  中文資訊修改進 ze_file
# Modify.........: No.MOD-590464 05/10/04 By Sarah t200_menu()段裡的retrieve,在CALL t200_g()前要加權限判斷
# Modify.........: No.MOD-590454 05/10/03 By Sarah 查詢時,單身如給條件值,計算筆數的SQL是不正確的
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel 匯出失效
# Modify.........: No.FUN-5B0113 05/11/22 By Claire 修改單身後單頭的資料更改者及最近修改日應update
# Modify.........: No.FUN-5B0091 05/11/30 By Sarah [擷取]應排除委外系列工單
# Modify.........: No.MOD-5C0031 05/12/09 By kim 輸入工單時應檢查工單不可作廢
# Modify.........: No.FUN-5B0077 05/12/13 By Sarah 擷取時,沒有將真正的tlf19寫入成本中心欄位
# Modify.........: No.MOD-620015 06/02/09 By Claire 工單需已確認
# Modify.........: No.TQC-620018 06/02/22 By Smapmin 單身按CONTROLO時,項次要累加1
# Modify.........: No.MOD-630035 06/03/08 By Claire  l_sql_g 加入 sfb98 
# Modify.........: No.MOD-640086 06/04/08 By Carol l_sql_g GROUP BY 寫錯少了sfb98
# Modify.........: No.MOD-640522 06/04/20 By Claire 輸入工單需已發料
# Modify.........: No.MOD-650015 06/05/05 By rainy 取消輸入時的"預設上筆"功能monster代
# Modify.........: No.FUN-560045 06/05/24 By Sarah 執行"擷取"時,增加警語"本動作將刪除當月工時資料,是否繼續?"
# Modify.........: No.FUN-660127 06/06/23 By Czl cl_err --> cl_err3
# Modify.........: No.FUN-660202 06/07/04 By Sarah 原ACTION"擷取"Rename成"擷取標準工時",AFTER INPUT段檢查是否已存在資料,若存在則秀提示訊息
# Modify.........: No.FUN-680122 06/09/04 By zdyllq 類型轉換  
# Modify.........: No.FUN-640223 06/09/07 By kim 輸入工時時考慮工單是否發料
# Modify.........: No.FUN-660046 06/09/20 By Sarah 將MOD-630035修改的部份Cancel掉
# Modify.........: No.FUN-6A0019 06/10/25 By jamie 1.FUNCTION _q() 一開始應清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.FUN-6A0146 06/10/27 By bnlent l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/10 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-720039 07/03/02 By pengu 查詢若單身下條件時，查出的資料會異常
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740032 07/04/09 By chenl 異動日期小于關帳日期時，不可刪除，審核，取消審核。
# Modify.........: No.TQC-740270 07/04/23 By cheunl 修改委外工單可以報工，報工的日期小于工單開立的日期，生產數量可以為負數
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-780054 07/08/09 By Carol 調整COUNT()筆數SQL
# Modify.........: No.MOD-780150 07/08/20 By kim 產量應能打0：因為該工單雖然還沒有入庫量，但已有工時投入
# Modify.........: No.FUN-7C0101 08/01/07 By shiwuying 成本改善增加ccj071(投入標准機器工時)
# Modify.........: No.FUN-7C0050 08/01/15 By johnray 串查程序代碼添加共用 ACTION 的引用
# Modify.........: No.FUN-840202 08/04/29 By TSD.lucasyeh 自定欄位功能修改
# Modify.........: No.FUN-860001 08/06/12 By Sherry 批序號-盤點
# Modify.........: No.FUN-840181 08/06/12 By Sherry 增加實際工時
# Modify.........: No.MOD-8A0011 08/11/15 By Pengu 調整tlf_curs CURSOR的SQL語法
# Modify.........: No.CHI-8B0017 08/12/22 By jan 改控管為axcs010 符合成會結算年度期別之后的才可作確認和取消確認.
# Modify.........: No.FUN-910072 09/02/02 By jan action '擷取標准工時', 算完后的值應寫入單身 ' 投入標准人工工時' (現況是寫入 '投入工時')
# Modify.........: No.FUN-910076 09/02/03 By jan action '擷取標准工時', 需增加擷取機時
# Modify.........: NO.MOD-940123 09/04/09 BY chenl l_sql_g增加tlf19排序。
# Modify.........: No.FUN-950029 09/05/14 By lutingting 開放狀態頁簽欄位的查詢功能
# Modify.........: No.MOD-860314 09/05/27 By wujie  截取標准工時，走RUN CARD的入庫單相關的tlf資料沒有被抓進來
# Modify.........: No.MOD-960065 09/06/08 By mike 請在判斷ccj06是否大於sfb08時在重新對l_sfb08取值
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-990069 09/09/27 By baofei 修改GP5.2的相關設定
# Modify.........: No.TQC-9A0096 09/10/16 By liuxqa 補上TQC-990001.
# Modify.........: No:MOD-9B0051 09/11/11 By sabrina 擷取標準工時時，應用sfb02判定是否為重工不應用sfb99判定
# Modify.........: No.FUN-9C0073 10/01/13 By chenls 程序精簡
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.FUN-A50075 10/05/24 By lutingting GP5.2 AXC模组table重新分类
# Modify.........: No.MOD-A90174 10/09/28 by sabrina 不可輸入"試產性工單"及"預測工單"
# Modify.........: No.MOD-AA0056 10/10/12 by sabrina 已結案工單不可輸入
# Modify.........: No.MOD-AC0090 10/12/13 by sabrina ccj05應小於0才秀axc-207錯誤訊息
# Modify.........: No:CHI-AC0024 10/12/16 By Summer 日期欄位時控管不可小於會計年度期別(ccz01,ccz02)
# Modify.........: No.FUN-B10030 11/01/19 By vealxu 拿掉"營運中心切換"ACTION
# Modify.........: No.FUN-B50064 11/06/08 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B80007 11/08/02 By jason 工單不可以只限定廠內工單
# Modify.........: No.FUN-B60115 11/09/16 By jason 新增p_query列印
# Modify.........: No.MOD-B90036 12/01/16 By Vampire g_sql 加上 DISTINCT 

# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No:MOD-C20157 12/02/20 By ck2yuan 若單身無資料,則單頭一併刪除
# Modify.........: No.CHI-C30002 12/05/25 By yuhuabao 離開單身時若單身無資料提示是否刪除單頭資料
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.CHI-C20031 12/06/29 By bart 讓USER自行選擇要抓tlf19還是tlf930
# Modify.........: No.CHI-C90021 12/11/30 By Elise 新增實際機時/標準工時/標準機時合計欄位
# Modify.........: No.FUN-C80092 12/12/05 By fengrui 增加寫入日誌功能
# Modify.........: No:CHI-C80041 13/01/03 By bart 1.增加作廢功能 2.刪除單頭
# Modify.........: No:MOD-D10086 13/01/29 By bart 寫入ccj_file之前，先依日期、成本中心、工單找是否有已依在資料，有的話，用update，無的話，n抓該日期+成本中心最大值+1
# Modify.........: No.CHI-B20005 13/02/01 By Alberti 截取標準工時時，成本中心應抓sfb98
# Modify.........: No:CHI-B30092 13/02/01 By Alberti  擷取標準工時時，若工單已存在確認資料則不允許執行
# Modify.........: No:CHI-D20010 13/02/19 By minpp 將作廢功能分成作廢與取消作廢2個action
# Modify.........: No:FUN-D40030 13/04/09 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_cci   RECORD LIKE cci_file.*,
    g_cci_t RECORD LIKE cci_file.*,
    g_cci_o RECORD LIKE cci_file.*,
    g_cci01_t LIKE cci_file.cci01,
    g_cci02_t LIKE cci_file.cci02,   #No.TQC-9A0096 
    b_ccj   RECORD LIKE ccj_file.*,
    g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_sql_tmp           STRING,  #MOD-780054 add
    g_ccj           DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
        ccj03		LIKE ccj_file.ccj03,
        ccj04		LIKE ccj_file.ccj04,
        sfb05 		LIKE sfb_file.sfb05,    #No.MOD-490217
        ccj06		LIKE ccj_file.ccj06,
        ccj05		LIKE ccj_file.ccj05,
        ccj051          LIKE ccj_file.ccj051,  #FUN-840181
        ccj07		LIKE ccj_file.ccj07,    #No.FUN-7C0101  add
        ccj071		LIKE ccj_file.ccj071,   #No.FUN-7C0101  add
        ccj08		LIKE ccj_file.ccj08,
        ccjud01	        LIKE ccj_file.ccjud01,
        ccjud02         LIKE ccj_file.ccjud02,
        ccjud03         LIKE ccj_file.ccjud03,
        ccjud04         LIKE ccj_file.ccjud04,
        ccjud05         LIKE ccj_file.ccjud05,
        ccjud06         LIKE ccj_file.ccjud06,
        ccjud07         LIKE ccj_file.ccjud07,
        ccjud08         LIKE ccj_file.ccjud08,
        ccjud09         LIKE ccj_file.ccjud09,
        ccjud10         LIKE ccj_file.ccjud10,
        ccjud11         LIKE ccj_file.ccjud11,
        ccjud12         LIKE ccj_file.ccjud12,
        ccjud13         LIKE ccj_file.ccjud13,
        ccjud14         LIKE ccj_file.ccjud14,
        ccjud15         LIKE ccj_file.ccjud15
                    END RECORD,
    g_ccj_t         RECORD                      #程式變數 (舊值)
        ccj03		LIKE ccj_file.ccj03,
        ccj04		LIKE ccj_file.ccj04,
        sfb05 		LIKE sfb_file.sfb05,    #No.MOD-490217
        ccj06		LIKE ccj_file.ccj06,
        ccj05		LIKE ccj_file.ccj05,
        ccj051          LIKE ccj_file.ccj051,  #FUN-840181
        ccj07		LIKE ccj_file.ccj07,    #No.FUN-7C0101  add
        ccj071		LIKE ccj_file.ccj071,   #No.FUN-7C0101  add
        ccj08		LIKE ccj_file.ccj08,
        ccjud01	        LIKE ccj_file.ccjud01,
        ccjud02         LIKE ccj_file.ccjud02,
        ccjud03         LIKE ccj_file.ccjud03,
        ccjud04         LIKE ccj_file.ccjud04,
        ccjud05         LIKE ccj_file.ccjud05,
        ccjud06         LIKE ccj_file.ccjud06,
        ccjud07         LIKE ccj_file.ccjud07,
        ccjud08         LIKE ccj_file.ccjud08,
        ccjud09         LIKE ccj_file.ccjud09,
        ccjud10         LIKE ccj_file.ccjud10,
        ccjud11         LIKE ccj_file.ccjud11,
        ccjud12         LIKE ccj_file.ccjud12,
        ccjud13         LIKE ccj_file.ccjud13,
        ccjud14         LIKE ccj_file.ccjud14,
        ccjud15         LIKE ccj_file.ccjud15
                    END RECORD,
    g_buf           LIKE type_file.chr1000,             #        #No.FUN-680122 VARCHAR(78)
    g_rec_b         LIKE type_file.num5,                #單身筆數        #No.FUN-680122 SMALLINT
    l_ac            LIKE type_file.num5                 #目前處理的ARRAY CNT    #No.FUN-680122 SMALLINT
 
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done LIKE type_file.num5      #No.FUN-680122 SMALLINT
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE g_msg           LIKE ze_file.ze03            #No.FUN-680122 VARCHAR(72)
 
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680122 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680122 SMALLINT
DEFINE   g_confirm      LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_approve      LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_post         LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_close        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_void         LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_valid        LIKE type_file.chr1          #No.FUN-680122 VARCHAR(1)
DEFINE   g_cka00        LIKE cka_file.cka00          #No.FUN-C80092

MAIN
DEFINE    p_row,p_col     LIKE type_file.num5       #No.FUN-680122 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXC")) THEN
      EXIT PROGRAM
   END IF
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
   LET p_row = 4 LET p_col = 20
   OPEN WINDOW t200_w AT p_row,p_col WITH FORM "axc/42f/axct200"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL t200()
   CLOSE WINDOW t200_w
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0146
END MAIN
 
FUNCTION t200()
    INITIALIZE g_cci.* TO NULL
    INITIALIZE g_cci_t.* TO NULL
    INITIALIZE g_cci_o.* TO NULL
 
    LET g_forupd_sql = "SELECT * FROM cci_file WHERE cci01 = ? AND cci02 = ? FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_cl CURSOR FROM g_forupd_sql              # LOCK CURSOR
 
    CALL t200_menu()
END FUNCTION
 
FUNCTION t200_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
#CHI-C90021---add---S
   DEFINE l_ccj051 LIKE ccj_file.ccj051
   DEFINE l_ccj07  LIKE ccj_file.ccj07
   DEFINE l_ccj071 LIKE ccj_file.ccj071
#CHI-C90021---add---E

    CLEAR FORM
    CALL g_ccj.clear()
    CALL cl_set_head_visible("","YES")               #No.FUN-6A0092
 
   INITIALIZE g_cci.* TO NULL    #No.FUN-750051
    CONSTRUCT BY NAME g_wc ON
              cci01, cci02, cci03, ccifirm,cci05,
              cciuser,ccigrup,ccimodu,ccidate,                                                                                      
              cciud01,cciud02,cciud03,cciud04,cciud05,
              cciud06,cciud07,cciud08,cciud09,cciud10,
              cciud11,cciud12,cciud13,cciud14,cciud15
 
       BEFORE CONSTRUCT
          CALL cl_qbe_init()
 
       ON ACTION controlp
           CASE
                WHEN INFIELD(cci02) # Dept CODE
                   CALL cl_init_qry_var()
                    IF g_aaz.aaz90 = 'Y' THEN
                       LET g_qryparam.form  = "q_gem4"
                    ELSE
                       LET g_qryparam.form  = "q_gem"
                    END IF
                   LET g_qryparam.state = "c"
                   CALL cl_create_qry() RETURNING g_qryparam.multiret
                   DISPLAY g_qryparam.multiret TO cci02
                OTHERWISE EXIT CASE
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
          CALL cl_qbe_list() RETURNING lc_qbe_sn
          CALL cl_qbe_display_condition(lc_qbe_sn)
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
 
    CONSTRUCT g_wc2 ON ccj03,ccj04,ccj05,ccj051,ccj07,ccj071,ccj08    #No.FUN-7C0101  add ccj07,ccj071  #FUN-840181
                      ,ccjud01,ccjud02,ccjud03,ccjud04,ccjud05
                      ,ccjud06,ccjud07,ccjud08,ccjud09,ccjud10
                      ,ccjud11,ccjud12,ccjud13,ccjud14,ccjud15
            FROM s_ccj[1].ccj03,s_ccj[1].ccj04,s_ccj[1].ccj05,s_ccj[1].ccj051,  #FUN-840181
                 s_ccj[1].ccj07,s_ccj[1].ccj071,s_ccj[1].ccj08  #No.FUN-7C0101  add ccj07,ccj071
                ,s_ccj[1].ccjud01,s_ccj[1].ccjud02,s_ccj[1].ccjud03
                ,s_ccj[1].ccjud04,s_ccj[1].ccjud05,s_ccj[1].ccjud06
                ,s_ccj[1].ccjud07,s_ccj[1].ccjud08,s_ccj[1].ccjud09
                ,s_ccj[1].ccjud10,s_ccj[1].ccjud11,s_ccj[1].ccjud12
                ,s_ccj[1].ccjud13,s_ccj[1].ccjud14,s_ccj[1].ccjud15
 
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
      ON ACTION controlp
           CASE WHEN INFIELD(ccj04)
                CALL cl_init_qry_var()
                LET g_qryparam.form     = "q_sfb"
                LET g_qryparam.state = "c"
                CALL cl_create_qry() RETURNING g_qryparam.multiret
                DISPLAY g_qryparam.multiret TO ccj04
                NEXT FIELD ccj04
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
 
 
		#No.FUN-580031 --start--     HCN
		    ON ACTION qbe_save
		       CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
    END CONSTRUCT
    IF INT_FLAG THEN RETURN END IF
    #資料權限的檢查
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('cciuser', 'ccigrup')
 
    IF g_wc2=' 1=1'
       THEN LET g_sql="SELECT cci01,cci02 FROM cci_file ",
                      " WHERE ",g_wc CLIPPED, " ORDER BY cci01,cci02"
       #ELSE LET g_sql="SELECT cci01,cci02",   #MOD-780054 add unique   #MOD-B90036 mark
       ELSE LET g_sql="SELECT DISTINCT cci01,cci02",    #MOD-B90036 add 
                      "  FROM cci_file,ccj_file ",
                      " WHERE cci01=ccj01 AND cci02=ccj02",
                      "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                      " ORDER BY cci01,cci02"
    END IF
    PREPARE t200_prepare FROM g_sql                # RUNTIME 編譯
    DECLARE t200_cs SCROLL CURSOR WITH HOLD FOR t200_prepare
 
 
    IF g_wc2 = " 1=1" THEN                         # 取合乎條件筆數
       LET g_sql_tmp="SELECT cci01,cci02 FROM cci_file ",
                     " WHERE ",g_wc CLIPPED,
                     " GROUP BY cci01,cci02 ",
                     " INTO TEMP x"
    ELSE
       LET g_sql_tmp="SELECT DISTINCT cci01,cci02 ",
                     "  FROM cci_file,ccj_file ",
                     " WHERE cci01=ccj01 AND cci02=ccj02",
                     "   AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                     "   GROUP BY cci01,cci02 ",
                     " INTO TEMP x"
    END IF
 
    DROP TABLE x
    PREPARE t200_cnt_tmp  FROM g_sql_tmp
    EXECUTE t200_cnt_tmp
    LET g_sql="SELECT COUNT(*) FROM x "
    PREPARE t200_precount FROM g_sql
    DECLARE t200_count CURSOR FOR t200_precount
 
   #CHI-C90021---add---S
    SELECT SUM(ccj051),SUM(ccj07),SUM(ccj071) INTO l_ccj051,l_ccj07,l_ccj071
           FROM ccj_file
          WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
    IF l_ccj051 IS NULL THEN LET l_ccj051 = 0 END IF
    IF l_ccj07 IS NULL THEN LET l_ccj07 = 0 END IF
    IF l_ccj071 IS NULL THEN LET l_ccj071 = 0 END IF
    DISPLAY l_ccj051 TO FORMONLY.cn3
    DISPLAY l_ccj07 TO FORMONLY.cn4
    DISPLAY l_ccj071 TO FORMONLY.cn5
   #CHI-C90021---add---E 

END FUNCTION
 
FUNCTION t200_menu()
DEFINE l_cmd STRING   #FUN-B60115 
   WHILE TRUE
      CALL t200_bp("G")
      CASE g_action_choice
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t200_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t200_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t200_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
               CALL t200_u()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t200_b('0')
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "retrieve"
            IF cl_chk_act_auth() THEN   #MOD-590464
               CALL t200_g()
            END IF   #MOD-590464
         WHEN "confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_firm1()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_cci.ccifirm,"","","","",g_cci.cciacti)
         WHEN "undo_confirm"
            IF cl_chk_act_auth() THEN
               CALL t200_firm2()
            END IF
            #圖形顯示
            CALL cl_set_field_pic(g_cci.ccifirm,"","","","",g_cci.cciacti)
       # WHEN "switch_plant"     #FUN-B10030
       #    CALL t200_d()        #FUN-B10030
         WHEN "exporttoexcel" #FUN-4B0015
            CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_ccj),'','')
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_cci.cci01 IS NOT NULL THEN
                LET g_doc.column1 = "cci01"
                LET g_doc.column2 = "cci02"
                LET g_doc.value1 = g_cci.cci01
                LET g_doc.value2 = g_cci.cci02
                CALL cl_doc()
             END IF 
          END IF
         #FUN-B60115 --START--
         WHEN "output"
              IF cl_chk_act_auth() THEN
                 IF cl_null(g_wc)  THEN LET g_wc  = " 1=1" END IF
                 IF cl_null(g_wc2) THEN LET g_wc2 = " 1=1" END IF
                 LET l_cmd='p_query "axct200" "',g_wc CLIPPED,' AND ',g_wc2 CLIPPED,'"'
                 CALL cl_cmdrun(l_cmd)
              END IF
         #FUN-B60115 --END-- 
         #CHI-C80041---begin
         WHEN "void"
            IF cl_chk_act_auth() THEN
               #CALL t200_v()                       #CHI-D20010
               CALL t200_v(1)                       #CHI-D20010
               IF g_cci.ccifirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cci.ccifirm,"","","",g_void,g_cci.cciacti)
            END IF
         #CHI-C80041---end

         #CHI-D20010---add---str
         WHEN "undo_void"
            IF cl_chk_act_auth() THEN
               CALL t200_v(2)                 
               IF g_cci.ccifirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
               CALL cl_set_field_pic(g_cci.ccifirm,"","","",g_void,g_cci.cciacti)
            END IF   
         #CHI-D20010---add---end
      END CASE
   END WHILE
      CLOSE t200_cs
END FUNCTION
 
FUNCTION t200_a()
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM                                   # 清螢幕欄位內容
    CALL g_ccj.clear()
    INITIALIZE g_cci.* LIKE cci_file.*
    LET g_cci01_t = NULL
    LET g_cci02_t = NULL    #No.TQC-9A0096 
    LET g_cci.cci01 = g_today
    LET g_cci.cci02 = g_grup
    LET g_cci.cci05 = 0
    LET g_cci.ccifirm = 'N'
    CALL cl_opmsg('a')
    CALL s_log_ins(g_prog,'','','','') RETURNING g_cka00  #FUN-C80092 add
    WHILE TRUE
         IF g_ccz.ccz06='1' THEN LET g_cci.cci02=' ' END IF #MOD-4B0103
        LET g_cci.cciacti ='Y'                   # 有效的資料
        LET g_cci.cciuser = g_user
        LET g_cci.ccioriu = g_user #FUN-980030
        LET g_cci.cciorig = g_grup #FUN-980030
        LET g_cci.ccigrup = g_grup               # 使用者所屬群
        LET g_cci.ccidate = g_today
        LET g_cci.cciinpd = g_today
        CALL t200_i("a")                         # 各欄位輸入
        IF INT_FLAG THEN                         # 若按了DEL鍵
            LET INT_FLAG = 0
            CALL cl_err('',9001,0)
            CLEAR FORM
            CALL g_ccj.clear()
            CALL s_log_upd(g_cka00,'N')          #更新日誌  #FUN-C80092
            EXIT WHILE
        END IF
        IF g_cci.cci01 IS NULL THEN              # KEY 不可空白
           CONTINUE WHILE
        END IF
        LET g_cci.ccilegal = g_legal    #FUN-A50075
        INSERT INTO cci_file VALUES(g_cci.*)     # DISK WRITE
        IF SQLCA.sqlcode THEN
           CALL cl_err3("ins","cci_file",g_cci.cci01,g_cci.cci02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
           CONTINUE WHILE
        ELSE
           LET g_cci_t.* = g_cci.*               # 保存上筆資料
           SELECT cci01,cci02 INTO g_cci.cci01,g_cci.cci02 FROM cci_file
                  WHERE cci01 = g_cci.cci01 AND
                        cci02 = g_cci.cci02
        END IF
        LET g_rec_b=0
        CALL t200_b('0')
        CALL s_log_upd(g_cka00,'Y')              #更新日誌  #FUN-C80092
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t200_i(p_cmd)
    DEFINE
        p_cmd           LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(01)
        l_flag          LIKE type_file.chr1,         #判斷必要欄位是否有輸入        #No.FUN-680122 VARCHAR(01)
        l_n             LIKE type_file.num5          #No.FUN-680122 SMALLINT
    CALL cl_set_head_visible("","YES")                  #No.FUN-6A0092
 
    INPUT BY NAME g_cci.ccioriu,g_cci.cciorig,
           g_cci.cci01, g_cci.cci02, g_cci.cci03,
           g_cci.ccifirm,
           g_cci.cciuser,g_cci.ccigrup,g_cci.ccimodu,g_cci.ccidate,
           g_cci.cciud01,g_cci.cciud02,g_cci.cciud03,g_cci.cciud04,
           g_cci.cciud05,g_cci.cciud06,g_cci.cciud07,g_cci.cciud08,
           g_cci.cciud09,g_cci.cciud10,g_cci.cciud11,g_cci.cciud12,
           g_cci.cciud13,g_cci.cciud14,g_cci.cciud15
        WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t200_set_entry(p_cmd)
            CALL t200_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
          CALL cl_set_docno_format("ccj04")
        AFTER FIELD cci01
         IF NOT cl_null(g_cci.cci01) THEN
             IF (p_cmd='a') OR (p_cmd='u' AND g_cci.cci01!=g_cci_t.cci01) THEN #MOD-580263 add
              #CHI-AC0024 mod --start--
              #SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
              #IF g_sma.sma53 IS NOT NULL AND g_cci.cci01 <= g_sma.sma53 THEN
              #   CALL cl_err('','mfg9999',0)
              #   NEXT FIELD cci01
              #END IF
              IF YEAR(g_cci.cci01)*12 +MONTH(g_cci.cci01) < g_ccz.ccz01*12+g_ccz.ccz02 THEN
                 CALL cl_err('','axc-095',0)
                 NEXT FIELD cci01
              END IF
              #CHI-AC0024 mod --end--
            END IF
         END IF
        AFTER FIELD cci02
            IF NOT cl_null(g_cci.cci02) THEN
               IF g_aaz.aaz90='Y' THEN
                  IF NOT s_costcenter_chk(g_cci.cci02) THEN
                     LET g_cci.cci02 = g_cci02_t
                     LET g_msg = NULL
                     DISPLAY BY NAME g_cci.cci02
                     NEXT FIELD cci02
                  ELSE
                     CALL s_costcenter_desc(g_cci.cci02) RETURNING g_msg
                  END IF
               ELSE
                    CALL t200_cci02()
                    IF NOT cl_null(g_errno) THEN
                       LET g_cci.cci02 = g_cci02_t
                       CALL cl_err('',g_errno,0)
                       DISPLAY BY NAME g_cci.cci02
                       LET g_msg = NULL
                       NEXT FIELD cci02
                    END IF
                    SELECT gem02 INTO g_msg FROM gem_file
                      WHERE gem01 = g_cci.cci02
                 END IF
               DISPLAY g_msg TO gem02
               IF (g_cci.cci01 != g_cci01_t) OR (g_cci01_t IS NULL) OR
                  (g_cci.cci02 != g_cci02_t) OR (g_cci02_t IS NULL) THEN
                   SELECT count(*) INTO g_cnt FROM cci_file
                       WHERE cci01 = g_cci.cci01 AND cci02 = g_cci.cci02
                   IF g_cnt > 0 THEN                   # 資料重複
                       CALL cl_err('count>1:',-239,0)
                       LET g_cci.cci01 = g_cci01_t
                       DISPLAY BY NAME g_cci.cci01
                       NEXT FIELD cci01
                   END IF
               END IF
            END IF
 
        AFTER FIELD cciud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD cciud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER INPUT  #判斷必要欄位之值是否有值,若無則反白顯示,並要求重新輸入
           LET g_cci.cciuser = s_get_data_owner("cci_file") #FUN-C10039
           LET g_cci.ccigrup = s_get_data_group("cci_file") #FUN-C10039
            LET l_flag='N'
            IF INT_FLAG THEN EXIT INPUT END IF
            IF l_flag='Y' THEN NEXT FIELD cci01 END IF
        ON KEY(F1) NEXT FIELD cci01
        ON KEY(F2) NEXT FIELD cci06
        ON ACTION controlp
            CASE
                 WHEN INFIELD(cci02) # Dept CODE
                    CALL cl_init_qry_var()
                    IF g_aaz.aaz90='Y' THEN
                       LET g_qryparam.form = "q_gem4"
                    ELSE
                       LET g_qryparam.form = "q_gem"
                    END IF
                    LET g_qryparam.default1 = g_cci.cci02
                    CALL cl_create_qry() RETURNING g_cci.cci02
                    DISPLAY BY NAME g_cci.cci02
                 OTHERWISE EXIT CASE
            END CASE
 
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
 
FUNCTION t200_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
        CALL cl_set_comp_entry("cci01,cci02",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t200_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("cci01,cci02",FALSE)
    END IF
     #MOD-4B0103
    IF g_ccz.ccz06='1' THEN
       CALL cl_set_comp_entry("cci02",FALSE)
    END IF
 
END FUNCTION
 
FUNCTION t200_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    INITIALIZE g_cci.* TO NULL              #No.FUN-6A0019
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt
    CALL t200_cs()                          # 宣告 SCROLL CURSOR
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        CLEAR FORM
         CALL g_ccj.clear()
        RETURN
    END IF
    MESSAGE " SEARCHING ! "
    OPEN t200_cs                        # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cci.cci01,SQLCA.sqlcode,0)
        INITIALIZE g_cci.* TO NULL
    ELSE
        OPEN t200_count
        FETCH t200_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL t200_fetch('F')                # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
END FUNCTION
 
FUNCTION t200_fetch(p_flcci)
    DEFINE
        p_flcci          LIKE type_file.chr1           #No.FUN-680122 VARCHAR(01)
 
    CASE p_flcci
        WHEN 'N' FETCH NEXT     t200_cs INTO g_cci.cci01,g_cci.cci02
        WHEN 'P' FETCH PREVIOUS t200_cs INTO g_cci.cci01,g_cci.cci02
        WHEN 'F' FETCH FIRST    t200_cs INTO g_cci.cci01,g_cci.cci02
        WHEN 'L' FETCH LAST     t200_cs INTO g_cci.cci01,g_cci.cci02
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
            FETCH ABSOLUTE g_jump t200_cs INTO g_cci.cci01,g_cci.cci02
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cci.cci01,SQLCA.sqlcode,0)
        INITIALIZE g_cci.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flcci
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
 
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
 
    SELECT * INTO g_cci.* FROM cci_file       # 重讀DB,因TEMP有不被更新特性
       WHERE cci01 = g_cci.cci01 AND cci02 = g_cci.cci02
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","cci_file",g_cci.cci01,g_cci.cci02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
    ELSE
        LET g_data_owner=g_cci.cciuser           #FUN-4C0061權限控管
        LET g_data_group=g_cci.ccigrup
        CALL t200_show()                      # 重新顯示
    END IF
END FUNCTION
 
FUNCTION t200_show()
    LET g_cci_t.* = g_cci.*
    DISPLAY BY NAME g_cci.ccioriu,g_cci.cciorig,
           g_cci.cci01, g_cci.cci02, g_cci.cci03, g_cci.cci05,
           g_cci.ccifirm,
           g_cci.cciuser,g_cci.ccigrup,g_cci.ccimodu,g_cci.ccidate,
           g_cci.cciud01,g_cci.cciud02,g_cci.cciud03,g_cci.cciud04,
           g_cci.cciud05,g_cci.cciud06,g_cci.cciud07,g_cci.cciud08,
           g_cci.cciud09,g_cci.cciud10,g_cci.cciud11,g_cci.cciud12,
           g_cci.cciud13,g_cci.cciud14,g_cci.cciud15
 
           LET g_msg=NULL
           SELECT gem02 INTO g_msg FROM gem_file WHERE gem01=g_cci.cci02
           DISPLAY g_msg TO gem02
    #圖形顯示
    #CALL cl_set_field_pic(g_cci.ccifirm,"","","","",g_cci.cciacti)  #CHI-C80041
    IF g_cci.ccifirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
    CALL cl_set_field_pic(g_cci.ccifirm,"","","",g_void,g_cci.cciacti)  #CHI-C80041
    CALL t200_b_fill(g_wc2)
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t200_u()
    IF s_shut(0) THEN RETURN END IF
    IF g_cci.cci01 IS NULL THEN
        CALL cl_err('',-400,0)
        RETURN
    END IF
    SELECT * INTO g_cci.* FROM cci_file
     WHERE cci01=g_cci.cci01 AND cci02=g_cci.cci02
    IF g_cci.ccifirm='X' THEN RETURN END IF #CHI-C80041
    IF g_cci.ccifirm='Y'     THEN 
      CALL cl_err('','axm-101',0)      
    RETURN END IF
    IF g_cci.cciacti ='N' THEN    #檢查資料是否為無效
        CALL cl_err(g_cci.cci01,'9027',0)
        RETURN
    END IF
    MESSAGE ""
    CALL cl_opmsg('u')
    BEGIN WORK
 
    OPEN t200_cl USING g_cci.cci01,g_cci.cci02
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_cci.*               # 對DB鎖定
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_cci.cci01,SQLCA.sqlcode,0)
        ROLLBACK WORK
        RETURN
    END IF
    LET g_cci01_t = g_cci.cci01
    LET g_cci02_t = g_cci.cci02   #No.TQC-9A0096
    LET g_cci_o.*=g_cci.*
    LET g_cci.ccimodu=g_user                     #修改者
    LET g_cci.ccidate = g_today                  #修改日期
    CALL t200_show()                          # 顯示最新資料
    WHILE TRUE
        CALL t200_i("u")                      # 欄位更改
        IF INT_FLAG THEN
            LET INT_FLAG = 0
            LET g_cci.*=g_cci_t.*
            CALL t200_show()
            CALL cl_err('',9001,0)
            EXIT WHILE
        END IF
        UPDATE cci_file SET cci_file.* = g_cci.*    # 更新DB
            WHERE cci01 = g_cci_t.cci01 AND cci02 = g_cci_t.cci02             # COLAUTH?
        IF SQLCA.sqlcode THEN
            CALL cl_err3("upd","cci_file",g_cci01_t,g_cci_o.cci02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
            CONTINUE WHILE
        END IF
        EXIT WHILE
    END WHILE
    CLOSE t200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t200_r()
    DEFINE l_chr   LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(01)
           l_cnt   LIKE type_file.num5          #No.FUN-680122 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    IF g_cci.cci01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
    IF g_cci.ccifirm='X' THEN RETURN END IF #CHI-C80041
    IF g_cci.ccifirm='Y' THEN CALL cl_err('','axm-101',0) RETURN END IF
    SELECT count(*) INTO l_cnt FROM ccj_file WHERE ccj03 = g_cci.cci01
    IF l_cnt > 0 THEN
       CALL cl_err(g_cci.cci01,'axc-190',0)
       RETURN
    END IF
    SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    IF g_sma.sma53 IS NOT NULL AND g_cci.cci01 <= g_sma.sma53 THEN
       CALL cl_err('','axr-164',0)
       RETURN
    END IF
    BEGIN WORK
 
    OPEN t200_cl USING g_cci.cci01,g_cci.cci02
    IF STATUS THEN
       CALL cl_err("OPEN t200_cl:", STATUS, 1)
       CLOSE t200_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t200_cl INTO g_cci.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_cci.cci01,SQLCA.sqlcode,0) ROLLBACK WORK RETURN
    END IF
    CALL t200_show()
    IF cl_delh(15,21) THEN
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "cci01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "cci02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_cci.cci01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_cci.cci02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                                            #No.FUN-9B0098 10/02/24
        DELETE FROM cci_file WHERE cci01 = g_cci.cci01 AND cci02 = g_cci.cci02
        IF STATUS THEN 
          CALL cl_err3("del","cci_file",g_cci.cci01,"",STATUS,"","del cci:",1)  #No.FUN-660127
        RETURN END IF
        DELETE FROM ccj_file WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
        IF STATUS THEN 
          CALL cl_err3("del","ccj_file",g_cci.cci01,g_cci.cci02,STATUS,"","del ccj:",1)  #No.FUN-660127
        RETURN END IF
        CLEAR FORM
        CALL g_ccj.clear()
        INITIALIZE g_cci.* TO NULL
        MESSAGE ""
 
        DROP TABLE x
        PREPARE t200_cnt_tmpx  FROM g_sql_tmp
        EXECUTE t200_cnt_tmpx
 
        OPEN t200_count
        #FUN-B50064-add-start--
        IF STATUS THEN
           CLOSE t200_cl
           CLOSE t200_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        FETCH t200_count INTO g_row_count
        #FUN-B50064-add-start--
        IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
           CLOSE t200_cl
           CLOSE t200_count
           COMMIT WORK
           RETURN
        END IF
        #FUN-B50064-add-end-- 
        DISPLAY g_row_count TO FORMONLY.cnt
        OPEN t200_cs
        IF g_curs_index = g_row_count + 1 THEN
           LET g_jump = g_row_count
           CALL t200_fetch('L')
        ELSE
           LET g_jump = g_curs_index
           LET mi_no_ask = TRUE
           CALL t200_fetch('/')
        END IF
    END IF
    CLOSE t200_cl
    COMMIT WORK
END FUNCTION
 
FUNCTION t200_firm1()
 
   IF g_cci.cci01 IS NULL THEN RETURN END IF
#CHI-C30107 ------------ add ------------ begin
   IF g_cci.ccifirm='X' THEN RETURN END IF #CHI-C80041
   IF g_cci.ccifirm='Y' THEN RETURN END IF
   IF NOT cl_confirm('axm-108') THEN RETURN END IF
#CHI-C30107 ------------ add ------------ end
   SELECT * INTO g_cci.* FROM cci_file
    WHERE cci01=g_cci.cci01 AND cci02=g_cci.cci02
   IF g_cci.ccifirm='X' THEN RETURN END IF #CHI-C80041
   IF g_cci.ccifirm='Y' THEN RETURN END IF
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    IF YEAR(g_cci.cci01)*12 +MONTH(g_cci.cci01) < g_ccz.ccz01*12+g_ccz.ccz02 THEN
       CALL cl_err('','axc-002',0)
       RETURN
    END IF
#  IF NOT cl_confirm('axm-108') THEN RETURN END IF #CHI-C30107 mark
   BEGIN WORK
   LET g_success='Y'
 
   OPEN t200_cl USING g_cci.cci01,g_cci.cci02
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_cci.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cci.cci01,SQLCA.sqlcode,0)
      ROLLBACK WORK
      RETURN
   END IF
   LET g_cci.ccifirm ='Y'
   UPDATE cci_file SET ccifirm = 'Y' WHERE cci01 = g_cci.cci01 AND cci02 = g_cci.cci02
   IF g_success='Y'
      THEN COMMIT WORK
      ELSE ROLLBACK WORK LET g_cci.ccifirm ='N'
   END IF
   DISPLAY BY NAME g_cci.ccifirm
END FUNCTION
 
FUNCTION t200_firm2()
   IF g_cci.cci01 IS NULL THEN RETURN END IF
   SELECT * INTO g_cci.* FROM cci_file
    WHERE cci01=g_cci.cci01 AND cci02=g_cci.cci02
   IF g_cci.ccifirm='X' THEN RETURN END IF #CHI-C80041
   IF g_cci.ccifirm='N' THEN RETURN END IF
   SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
    IF YEAR(g_cci.cci01)*12 +MONTH(g_cci.cci01) < g_ccz.ccz01*12+g_ccz.ccz02 THEN
       CALL cl_err('','axc-003',0)
       RETURN
    END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
   BEGIN WORK LET g_success='Y'
 
   OPEN t200_cl USING g_cci.cci01,g_cci.cci02
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_cci.*               # 對DB鎖定
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_cci.cci01,SQLCA.sqlcode,0)
       ROLLBACK WORK
       RETURN
   END IF
   LET g_cci.ccifirm ='N'
   UPDATE cci_file SET ccifirm = 'N' WHERE cci01 = g_cci.cci01 AND cci02 = g_cci.cci02
   IF g_success='Y'
      THEN COMMIT WORK LET g_cci.ccifirm ='N'
      ELSE ROLLBACK WORK LET g_cci.ccifirm ='Y'
   END IF
   DISPLAY BY NAME g_cci.ccifirm
END FUNCTION
 
#FUN-B10030 -------------mark start-----------
#FUNCTION t200_d()
#  DEFINE l_plant,l_dbs	LIKE type_file.chr21          #No.FUN-680122 VARCHAR(21) 
#
#           LET INT_FLAG = 0  ######add for prompt bug
#  PROMPT 'PLANT CODE:' FOR l_plant
#     ON IDLE g_idle_seconds
#        CALL cl_on_idle()
#
#     ON ACTION about         #MOD-4C0121
#        CALL cl_about()      #MOD-4C0121
#
#     ON ACTION help          #MOD-4C0121
#        CALL cl_show_help()  #MOD-4C0121
#
#     ON ACTION controlg      #MOD-4C0121
#        CALL cl_cmdask()     #MOD-4C0121
#
#
#  END PROMPT
#  IF l_plant IS NULL THEN RETURN END IF
#  SELECT azp03 INTO l_dbs FROM azp_file WHERE azp01 = l_plant
#  IF STATUS THEN ERROR 'WRONG database!' RETURN END IF
#  DATABASE l_dbs
#  CALL cl_ins_del_sid(1,l_plant) #FUN-980030    #FUN-990069
#  IF STATUS THEN ERROR 'open database error!' RETURN END IF
#  LET g_plant = l_plant
#  LET g_dbs   = l_dbs
#END FUNCTION
#FUN-B10030 --------------mark end---------------------
 
FUNCTION t200_b(p_mod_seq)
DEFINE
    p_mod_seq       LIKE type_file.chr1,      #No.FUN-680122 VARCHAR(01)  #修改次數 (0表開狀)
    l_ac_t          LIKE type_file.num5,      #未取消的ARRAY CNT        #No.FUN-680122 SMALLINT
    l_n             LIKE type_file.num5,      #檢查重複用        #No.FUN-680122 SMALLINT
    l_yymm          LIKE type_file.num5,      #No.FUN-680122 SMALLINT             #檢查重複用
    l_qty           LIKE type_file.num10,     #No.FUN-680122 INTEGER              #
    l_sfb08,l_sfb09 LIKE type_file.num10,     #No.FUN-680122 INTEGER              #
    l_sfb81         LIKE sfb_file.sfb81,
    l_sfb02         LIKE sfb_file.sfb02,
    l_sfb87         LIKE sfb_file.sfb87,      #MOD-620015
    l_ima58         LIKE ima_file.ima58,      #No.FUN-7C0101
    l_ima912        LIKE ima_file.ima912,     #No.FUN-7C0101
    l_lock_sw       LIKE type_file.chr1,      #單身鎖住否      #No.FUN-680122 VARCHAR(01)
    p_cmd           LIKE type_file.chr1,      #處理狀態        #No.FUN-680122 VARCHAR(01)
    l_sfb38         LIKE sfb_file.sfb38,      #No.FUN-680122 DATE
    l_allow_insert  LIKE type_file.num5,      #可新增否        #No.FUN-680122 SMALLINT
    l_allow_delete  LIKE type_file.num5,      #可刪除否        #No.FUN-680122 SMALLINT
    l_cnt           LIKE type_file.num5       #MOD-5C0031      #No.FUN-680122 SMALLINT
#CHI-C90021---add---S
   DEFINE l_ccj051 LIKE ccj_file.ccj051
   DEFINE l_ccj07  LIKE ccj_file.ccj07
   DEFINE l_ccj071 LIKE ccj_file.ccj071
#CHI-C90021---add---E
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF g_cci.cci01 IS NULL THEN RETURN END IF
    SELECT * INTO g_cci.* FROM cci_file
     WHERE cci01=g_cci.cci01 AND cci02=g_cci.cci02
    IF g_cci.ccifirm='X' THEN RETURN END IF #CHI-C80041
    IF g_cci.ccifirm='Y' THEN 
     CALL cl_err3("sel","cci_file",g_cci.cci01,g_cci.cci02,"axm-101","","",1)  #No.FUN-660127
    RETURN END IF
   #CHI-AC0024 mod --start--
   #SELECT * INTO g_sma.* FROM sma_file WHERE sma00='0'
   #IF g_sma.sma53 IS NOT NULL AND g_cci.cci01 <= g_sma.sma53 THEN
   #   CALL cl_err('','mfg9999',0)
   #   RETURN
   #END IF
    IF YEAR(g_cci.cci01)*12 +MONTH(g_cci.cci01) < g_ccz.ccz01*12+g_ccz.ccz02 THEN
       CALL cl_err('','axc-095',0)
       RETURN
    END IF
   #CHI-AC0024 mod --end--
 
    CALL cl_opmsg('b')
 
    LET g_forupd_sql = " SELECT ccj03,ccj04,'',ccj06,ccj05,ccj051,ccj07,ccj071,ccj08, ",#No.FUN-7C0101  add ccj07,ccj071  #FUN-840181
                       "       ccjud01,ccjud02,ccjud03,ccjud04,ccjud05,",
                       "       ccjud06,ccjud07,ccjud08,ccjud09,ccjud10,",
                       "       ccjud11,ccjud12,ccjud13,ccjud14,ccjud15 ",
                       " FROM ccj_file ",
                       " WHERE ccj01=? AND ccj02=? ",
                       "   AND ccj03=? ",
                       " FOR UPDATE "
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t200_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_ac_t = 0
        LET l_allow_insert = cl_detail_input_auth("insert")
        LET l_allow_delete = cl_detail_input_auth("delete")
 
        INPUT ARRAY g_ccj WITHOUT DEFAULTS FROM s_ccj.*
              ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
        BEFORE ROW
            LET p_cmd=''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            BEGIN WORK
 
            OPEN t200_cl USING g_cci.cci01,g_cci.cci02
            IF STATUS THEN
               CALL cl_err("OPEN t200_cl:", STATUS, 1)
               CLOSE t200_cl
               ROLLBACK WORK
               RETURN
            END IF
            FETCH t200_cl INTO g_cci.*               # 對DB鎖定
            IF SQLCA.sqlcode THEN
               CALL cl_err(g_cci.cci01,SQLCA.sqlcode,0)
               ROLLBACK WORK
               RETURN
            END IF
            IF g_rec_b>=l_ac THEN
               LET g_ccj_t.* = g_ccj[l_ac].*  #BACKUP
               LET p_cmd='u'
 
                OPEN t200_bcl USING g_cci.cci01,g_cci.cci02, g_ccj_t.ccj03
                IF STATUS THEN
                   CALL cl_err("OPEN t200_bcl:", STATUS, 1)
                   CLOSE t200_bcl
                   ROLLBACK WORK
                   RETURN
                END IF
                FETCH t200_bcl INTO g_ccj[l_ac].*
                IF SQLCA.sqlcode THEN
                    CALL cl_err(g_ccj_t.ccj03,SQLCA.sqlcode,1)
                    LET l_lock_sw = "Y"
                END IF
                LET g_ccj[l_ac].sfb05 = g_ccj_t.sfb05
                CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
        AFTER INSERT
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               CANCEL INSERT
               EXIT INPUT
            END IF
            INSERT INTO ccj_file(ccj01,ccj02,ccj03,ccj04,
                                 ccj05,ccj051,ccj06,ccj07,ccj071,ccj08, #No.FUN-7C0101  add ccj07,ccj071  #FUN-840181
                                 ccjud01,ccjud02,ccjud03,
                                 ccjud04,ccjud05,ccjud06,
                                 ccjud07,ccjud08,ccjud09,
                                 ccjud10,ccjud11,ccjud12,
                                 ccjud13,ccjud14,ccjud15,ccjlegal)   #FUN-A50075 add legal
            VALUES(g_cci.cci01,g_cci.cci02,
                   g_ccj[l_ac].ccj03,g_ccj[l_ac].ccj04,
                   g_ccj[l_ac].ccj05,g_ccj[l_ac].ccj051,g_ccj[l_ac].ccj06,  #FUN-840181
                   g_ccj[l_ac].ccj07,g_ccj[l_ac].ccj071,         #No.FUN-7C0101
                   g_ccj[l_ac].ccj08,
                   g_ccj[l_ac].ccjud01, g_ccj[l_ac].ccjud02,
                   g_ccj[l_ac].ccjud03, g_ccj[l_ac].ccjud04,
                   g_ccj[l_ac].ccjud05, g_ccj[l_ac].ccjud06,
                   g_ccj[l_ac].ccjud07, g_ccj[l_ac].ccjud08,
                   g_ccj[l_ac].ccjud09, g_ccj[l_ac].ccjud10,
                   g_ccj[l_ac].ccjud11, g_ccj[l_ac].ccjud12,
                   g_ccj[l_ac].ccjud13, g_ccj[l_ac].ccjud14,
                   g_ccj[l_ac].ccjud15, g_legal)     #FUN-A50075 add legal
                 #單身update

           #CHI-C90021---add---S
            SELECT SUM(ccj051),SUM(ccj07),SUM(ccj071) INTO l_ccj051,l_ccj07,l_ccj071
                   FROM ccj_file
                  WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
            IF l_ccj051 IS NULL THEN LET l_ccj051 = 0 END IF
            IF l_ccj07 IS NULL THEN LET l_ccj07 = 0 END IF
            IF l_ccj071 IS NULL THEN LET l_ccj071 = 0 END IF
           #CHI-C90021---add---E 
            IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","ccj_file",g_cci.cci01,g_cci.cci02,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                CANCEL INSERT
            ELSE
                MESSAGE 'INSERT O.K'
                LET g_rec_b=g_rec_b+1
                DISPLAY g_rec_b TO FORMONLY.cn2
               #CHI-C90021---add---S
                DISPLAY l_ccj051 TO FORMONLY.cn3
                DISPLAY l_ccj07 TO FORMONLY.cn4
                DISPLAY l_ccj071 TO FORMONLY.cn5
               #CHI-C90021---add---E
                COMMIT WORK
                CALL t200_b_tot()
            END IF
 
        BEFORE INSERT
            LET l_n = ARR_COUNT()
            LET p_cmd='a'
            INITIALIZE g_ccj[l_ac].* TO NULL      #900423
            LET g_ccj[l_ac].ccj05 = 0
            LET g_ccj[l_ac].ccj051 = 0
            LET g_ccj[l_ac].ccj06 = 0
            LET g_ccj[l_ac].ccj07 = 0             #No.FUN-7C0101
            LET g_ccj[l_ac].ccj071 = 0            #No.FUN-7C0101
            LET g_ccj_t.* = g_ccj[l_ac].*         #新輸入資料
            CALL cl_show_fld_cont()               #FUN-550037(smin)
            NEXT FIELD ccj03
 
        BEFORE FIELD ccj03                        #default 序號
            IF g_ccj[l_ac].ccj03 IS NULL OR
               g_ccj[l_ac].ccj03 = 0 THEN
                SELECT max(ccj03)+1 INTO g_ccj[l_ac].ccj03
                   FROM ccj_file
                   WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
                IF g_ccj[l_ac].ccj03 IS NULL THEN
                    LET g_ccj[l_ac].ccj03 = 1
                END IF
            END IF
 
        AFTER FIELD ccj03                        #check 序號是否重複
            IF NOT cl_null(g_ccj[l_ac].ccj03) THEN
               IF g_ccj[l_ac].ccj03 != g_ccj_t.ccj03 OR
                  g_ccj_t.ccj03 IS NULL THEN
                   SELECT count(*) INTO l_n
                       FROM ccj_file
                       WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
                         AND ccj03 = g_ccj[l_ac].ccj03
                   IF l_n > 0 THEN
                       CALL cl_err('',-239,0)
                       LET g_ccj[l_ac].ccj03 = g_ccj_t.ccj03
                       NEXT FIELD ccj03
                   END IF
               END IF
            END IF
 
        AFTER FIELD ccj04
            IF NOT cl_null(g_ccj[l_ac].ccj04) THEN
               LET l_cnt=0
               SELECT COUNT(*) INTO l_cnt FROM sfb_file
                 WHERE sfb01=g_ccj[l_ac].ccj04
                   AND sfb87='X'
               IF l_cnt>0 THEN
                 CALL cl_err('','asf-947',1)
                 NEXT FIELD ccj04
               END IF
              #MOD-AA0056---add---start---
               LET l_cnt = 0
               SELECT COUNT(*) INTO l_cnt FROM sfb_file
                WHERE sfb04='8'
                  AND sfb28 IN ('2','3')
                  AND sfb01 = g_ccj[l_ac].ccj04
               IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
               IF l_cnt > 0 THEN
                  CALL cl_err(g_ccj[l_ac].ccj04,'asf-070',1)
                  NEXT FIELD ccj04
               END IF
              #MOD-AA0056---add---end---
               SELECT sfb81 INTO l_sfb81 FROM sfb_file
                 WHERE sfb01=g_ccj[l_ac].ccj04
                 IF l_sfb81 > g_cci.cci01 THEN
                    CALL cl_err('','axc-210',1)
                    NEXT FIELD ccj04
                 END IF
               SELECT sfb02 INTO l_sfb02
                 FROM sfb_file
                WHERE sfb01=g_ccj[l_ac].ccj04
                
                #IF l_sfb02 = '7' OR l_sfb02 = '8' THEN  #FUN-B80007 mark 
                #      CALL cl_err('','axc-209',1)       #FUN-B80007 mark 
                #      NEXT FIELD ccj04                  #FUN-B80007 mark 
                #   END IF                               #FUN-B80007 mark  
                
                #MOD-A90174---add---start---
                 IF l_sfb02 = '13' THEN
                    CALL cl_err('','axc-013',1)
                    NEXT FIELD ccj04
                 END IF
                 IF l_sfb02 = '15' THEN
                    CALL cl_err('','axc-012',1)
                    NEXT FIELD ccj04
                 END IF
                #MOD-A90174---add---end---
               SELECT sfb05,sfb38,sfb08,sfb09,sfb81,sfb87  #MOD-620015 add sfb87
                 INTO g_ccj[l_ac].sfb05,l_sfb38,l_sfb08,l_sfb09,l_sfb81
                     ,l_sfb87  #MOD-620015
                 FROM sfb_file
                WHERE sfb01=g_ccj[l_ac].ccj04
               IF STATUS THEN
                  CALL cl_err3("sel","sfb_file",g_ccj[l_ac].ccj04,"",STATUS,"","sel sfb:",1)  #No.FUN-660127
                  NEXT FIELD ccj04 
               END IF
               IF l_sfb87 != 'Y' THEN
                   CALL cl_err(g_ccj[l_ac].ccj04,'asf-104' , 1)
                   NEXT FIELD ccj04
               END IF
               IF YEAR(g_cci.cci01)*12+MONTH(g_cci.cci01) >
                  YEAR(l_sfb38    )*12+MONTH(l_sfb38    ) THEN
#                 ERROR "該工單上期(",l_sfb38,")已結案, 本期不可再投入工時!"
                  ERROR cl_getmsg('axc-200',g_lang),l_sfb81,cl_getmsg('axc-201',g_lang)
                  NEXT FIELD ccj04
               END IF
               IF YEAR(g_cci.cci01)*12+MONTH(g_cci.cci01) <
                  YEAR(l_sfb81    )*12+MONTH(l_sfb81    ) THEN
#                 ERROR "該工單(",l_sfb81,")未開單, 本期不可投入工時!"
                  ERROR cl_getmsg('axc-202',g_lang),l_sfb81,cl_getmsg('axc-203',g_lang)
                  NEXT FIELD ccj04
               END IF
            END IF
            DISPLAY g_ccj[l_ac].sfb05 TO sfb05
        
        AFTER FIELD ccj05
           #IF g_ccj[l_ac].ccj05 <= '0' THEN   #MOD-AC0090 mark
            IF g_ccj[l_ac].ccj05 < '0' THEN    #MOD-AC0090 add
               CALL cl_err('','axc-207',1)
               NEXT FIELD ccj05
            END IF
            IF (NOT cl_null(g_ccj[l_ac].ccj05)) AND 
               (g_ccj_t.ccj04 IS NULL OR g_ccj_t.ccj04<>g_ccj[l_ac].ccj04) THEN
                SELECT COUNT(*) INTO l_cnt FROM sfe_file
                                          WHERE sfe01=g_ccj[l_ac].ccj04
                IF l_cnt=0 THEN
                    CALL cl_err('','apm-046',1)
                END IF
            END IF
 
        AFTER FIELD ccj051
            IF g_ccj[l_ac].ccj051 < '0' THEN
               CALL cl_err('','axc-207',1)
               NEXT FIELD ccj051
            END IF
 
        BEFORE FIELD ccj06
            IF p_cmd='u' THEN
               LET g_ccj_t.ccj06 = g_ccj[l_ac].ccj06
            END IF
           
        AFTER FIELD ccj06
            IF g_ccj[l_ac].ccj06 < 0  THEN #MOD-780150
               CALL cl_err('','axc-207',1)
               LET g_ccj[l_ac].ccj06 = g_ccj_t.ccj06
               DISPLAY BY NAME g_ccj[l_ac].ccj06
               NEXT FIELD ccj06
            END IF
            SELECT SUM(ccj06) INTO l_qty FROM ccj_file
              WHERE ccj04=g_ccj[l_ac].ccj04
                AND ccj02=g_cci.cci02
                AND (ccj01!=g_cci.cci01 OR ccj03!=g_ccj[l_ac].ccj03)
            IF l_qty IS NULL THEN LET l_qty=0 END IF
            LET l_qty = l_qty + g_ccj[l_ac].ccj06
            SELECT sfb08 INTO l_sfb08                                                                                               
              FROM sfb_file                                                                                                         
             WHERE sfb01=g_ccj[l_ac].ccj04                                                                                          
           IF g_ccz.ccz05='1' AND l_qty > l_sfb08 THEN
               ERROR "ccj06>sfb08!" NEXT FIELD ccj06
            END IF
            
        BEFORE FIELD ccj07
          IF p_cmd='u' THEN
             LET g_ccj_t.ccj07 = g_ccj[l_ac].ccj07
           END IF
           SELECT ima58 INTO l_ima58 FROM ima_file WHERE ima01=g_ccj[l_ac].sfb05
           IF l_ima58 IS NULL THEN LET l_ima58=0 END IF
           LET g_ccj[l_ac].ccj07 = l_ima58 * g_ccj[l_ac].ccj06
           DISPLAY BY NAME g_ccj[l_ac].ccj07
        
        AFTER FIELD ccj07
           IF g_ccj[l_ac].ccj07 < 0  THEN #MOD-780150
               CALL cl_err('','axc-207',1)
               LET g_ccj[l_ac].ccj07 = g_ccj_t.ccj07
               DISPLAY BY NAME g_ccj[l_ac].ccj07
               NEXT FIELD ccj07
            END IF 
        
        BEFORE FIELD ccj071
           IF p_cmd='u' THEN
             LET g_ccj_t.ccj071 = g_ccj[l_ac].ccj071
           END IF
           SELECT ima912 INTO l_ima912 FROM ima_file WHERE ima01=g_ccj[l_ac].sfb05
           IF l_ima912 IS NULL THEN LET l_ima912=0 END IF
           LET g_ccj[l_ac].ccj071 = l_ima912 * g_ccj[l_ac].ccj06
           DISPLAY BY NAME g_ccj[l_ac].ccj071
       
        AFTER FIELD ccj071
           IF g_ccj[l_ac].ccj071 < 0  THEN #MOD-780150
               CALL cl_err('','axc-207',1)
               LET g_ccj[l_ac].ccj071 = g_ccj_t.ccj071
               DISPLAY BY NAME g_ccj[l_ac].ccj071
               NEXT FIELD ccj07
            END IF 
 
        AFTER FIELD ccjud01
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud02
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud03
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud04
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud05
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud06
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud07
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud08
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud09
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud10
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud11
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud12
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud13
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud14
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        AFTER FIELD ccjud15
           IF NOT cl_validate() THEN NEXT FIELD CURRENT END IF
 
        BEFORE DELETE                            #是否取消單身
            IF g_ccj_t.ccj03 > 0 AND g_ccj_t.ccj03 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                     CANCEL DELETE
                END IF
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
{ckp#1}         DELETE FROM ccj_file
                    WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
                      AND ccj03 = g_ccj_t.ccj03
                IF SQLCA.sqlcode THEN
#                   CALL cl_err(g_ccj_t.ccj03,SQLCA.sqlcode,0)      #No.FUN-660127
                    CALL cl_err3("del","ccj_file",g_cci.cci01,g_cci.cci02,SQLCA.SQLCODE,"","",1)  #No.FUN-660127
                   ROLLBACK WORK
                   CANCEL DELETE
                END IF
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2
               #CHI-C90021---add---S
                SELECT SUM(ccj051),SUM(ccj07),SUM(ccj071) INTO l_ccj051,l_ccj07,l_ccj071
                       FROM ccj_file
                      WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
                IF l_ccj051 IS NULL THEN LET l_ccj051 = 0 END IF
                IF l_ccj07 IS NULL THEN LET l_ccj07 = 0 END IF
                IF l_ccj071 IS NULL THEN LET l_ccj071 = 0 END IF
                    DISPLAY l_ccj051 TO FORMONLY.cn3
                    DISPLAY l_ccj07 TO FORMONLY.cn4
                    DISPLAY l_ccj071 TO FORMONLY.cn5
               #CHI-C90021---add---E
                COMMIT WORK
                CALL t200_b_tot()
            END IF
 
        ON ROW CHANGE
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               LET g_ccj[l_ac].* = g_ccj_t.*
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_ccj[l_ac].ccj03,-263,1)
               LET g_ccj[l_ac].* = g_ccj_t.*
            ELSE
               UPDATE ccj_file SET ccj03 = g_ccj[l_ac].ccj03,
                                            ccj04 = g_ccj[l_ac].ccj04,
                                            ccj05 = g_ccj[l_ac].ccj05,
                                            ccj051= g_ccj[l_ac].ccj051,  #FUN-840181
                                            ccj06 = g_ccj[l_ac].ccj06,
                                            ccj07 = g_ccj[l_ac].ccj07,  #No.FUN-7C0101
                                            ccj071 = g_ccj[l_ac].ccj071,#No.FUN-7C0101
                                            ccj08 = g_ccj[l_ac].ccj08,
                                            ccjud01 = g_ccj[l_ac].ccjud01,
                                            ccjud02 = g_ccj[l_ac].ccjud02,
                                            ccjud03 = g_ccj[l_ac].ccjud03,
                                            ccjud04 = g_ccj[l_ac].ccjud04,
                                            ccjud05 = g_ccj[l_ac].ccjud05,
                                            ccjud06 = g_ccj[l_ac].ccjud06,
                                            ccjud07 = g_ccj[l_ac].ccjud07,
                                            ccjud08 = g_ccj[l_ac].ccjud08,
                                            ccjud09 = g_ccj[l_ac].ccjud09,
                                            ccjud10 = g_ccj[l_ac].ccjud10,
                                            ccjud11 = g_ccj[l_ac].ccjud11,
                                            ccjud12 = g_ccj[l_ac].ccjud12,
                                            ccjud13 = g_ccj[l_ac].ccjud13,
                                            ccjud14 = g_ccj[l_ac].ccjud14,
                                            ccjud15 = g_ccj[l_ac].ccjud15
               WHERE ccj01=g_cci.cci01 AND ccj02=g_cci.cci02
                 AND ccj03=g_ccj_t.ccj03
               IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","ccj_file",g_cci.cci01,g_ccj_t.ccj03,SQLCA.sqlcode,"","",1)  #No.FUN-660127
                   LET g_ccj[l_ac].* = g_ccj_t.*
               ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
               END IF
            END IF
                CALL t200_b_tot()
 
        AFTER ROW
            LET l_ac = ARR_CURR()
#           LET l_ac_t = l_ac             #FUN-D40030 mark
#           CALL g_ccj.deleteElement(g_rec_b+1) #MOD-490200 #FUN-D40030 mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd = 'u' THEN
                  LET g_ccj[l_ac].* = g_ccj_t.*
               #FUN-D40030---add---str---
               ELSE
                  CALL g_ccj.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030---add---end---
               END IF
               CLOSE t200_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac             #FUN-D40030 add 
            CALL g_ccj.deleteElement(g_rec_b+1) #FUN-D40030 add
            CLOSE t200_bcl
            COMMIT WORK
 
        ON ACTION controlp
           CASE WHEN INFIELD(ccj04)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form     = "q_sfb"
                   LET g_qryparam.default1 = g_ccj[l_ac].ccj04
                   LET l_yymm = YEAR(g_cci.cci01)*12+MONTH(g_cci.cci01) - 1
                   LET g_qryparam.where = "sfb38 IS NULL OR ",
                                          l_yymm CLIPPED," < YEAR(sfb38)*12+MONTH(sfb38)"
                   CALL cl_create_qry() RETURNING g_ccj[l_ac].ccj04
                   DISPLAY g_ccj[l_ac].ccj04 TO ccj04
                   NEXT FIELD ccj04
           END CASE
 
        ON ACTION CONTROLO                        #沿用所有欄位
            IF INFIELD(ccj03) AND l_ac > 1 THEN
                LET g_ccj[l_ac].* = g_ccj[l_ac-1].*
                LET g_ccj[l_ac].ccj03 = NULL   #TQC-620018
                NEXT FIELD ccj03
            END IF
 
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
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
 
 
        END INPUT
        CALL t200_b_tot()
 
     LET g_cci.ccimodu = g_user
     LET g_cci.ccidate = g_today
     UPDATE cci_file SET ccimodu = g_cci.ccimodu,ccidate = g_cci.ccidate
      WHERE cci01 = g_cci.cci01
        AND cci02 = g_cci.cci02
     IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
        CALL cl_err3("upd","cci_file",g_cci.cci01,g_cci.cci02,SQLCA.SQLCODE,"","upd cci",1)  #No.FUN-660127
     END IF
     DISPLAY BY NAME g_cci.ccimodu,g_cci.ccidate
 
    CLOSE t200_bcl
    COMMIT WORK
#   CALl t200_delall()   #MOD-C20157 add  #CHI-C30002 mark
    CALL t200_delHeader()     #CHI-C30002 add                                                                                                                                  
END FUNCTION                                                                                                                        

#CHI-C30002 -------- add -------- begin
FUNCTION t200_delHeader()
   DEFINE l_action_choice    STRING               #CHI-C80041
   DEFINE l_cho              LIKE type_file.num5  #CHI-C80041
   DEFINE l_num              LIKE type_file.num5  #CHI-C80041
   DEFINE l_slip             LIKE type_file.chr5  #CHI-C80041
   DEFINE l_sql              STRING               #CHI-C80041
   DEFINE l_cnt              LIKE type_file.num5  #CHI-C80041
   
   IF g_rec_b = 0 THEN
      #CHI-C80041---begin
      LET l_action_choice = g_action_choice
      LET g_action_choice = 'delete'
      IF cl_chk_act_auth() THEN
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
         #CALL t200_v()              #CHI-D20010
         CALL t200_v(1)              #CHI-D20010
         IF g_cci.ccifirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF
         CALL cl_set_field_pic(g_cci.ccifirm,"","","",g_void,g_cci.cciacti)
      END IF 
      
      IF l_cho = 3 THEN 
      #CHI-C80041---end
      #IF cl_confirm("9042") THEN  #CHI-C80041
         DELETE FROM  cci_file WHERE cci01 = g_cci.cci01 AND cci02 = g_cci.cci02
         INITIALIZE g_cci.* TO NULL
         CLEAR FORM
      END IF
   END IF
END FUNCTION
#CHI-C30002 -------- add -------- end

#CHI-C30002 -------- mark -------- begin
#MOD-C20157 str add ------
#FUNCTION t200_delall()

#  SELECT COUNT(*) INTO g_cnt FROM ccj_file
#   WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02

#  IF g_cnt = 0 THEN
#     CALL cl_getmsg('9044',g_lang) RETURNING g_msg
#     ERROR g_msg CLIPPED
#     DELETE FROM cci_file WHERE cci01 = g_cci.cci01 AND cci02 = g_cci.cci02
#     CLEAR FORM
#  END IF

#END FUNCTION
#MOD-C20157 end add ------
#CHI-C30002 -------- mark -------- end
                                                                                                                                    
FUNCTION t200_b_tot()
#CHI-C90021---add---S
   DEFINE l_ccj051 LIKE ccj_file.ccj051
   DEFINE l_ccj07  LIKE ccj_file.ccj07
   DEFINE l_ccj071 LIKE ccj_file.ccj071
#CHI-C90021---add---E
   SELECT SUM(ccj05),SUM(ccj051),SUM(ccj07),SUM(ccj071) INTO g_cci.cci05,l_ccj051,l_ccj07,l_ccj071   #CHI-C90021 add ccj051,ccj07,ccj071 
          FROM ccj_file
         WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
   IF g_cci.cci05 IS NULL THEN LET g_cci.cci05 = 0 END IF
   DISPLAY BY NAME g_cci.cci05
  #CHI-C90021---add---S
   IF l_ccj051 IS NULL THEN LET l_ccj051 = 0 END IF
   IF l_ccj07 IS NULL THEN LET l_ccj07 = 0 END IF
   IF l_ccj071 IS NULL THEN LET l_ccj071 = 0 END IF
   DISPLAY l_ccj051 TO FORMONLY.cn3
   DISPLAY l_ccj07 TO FORMONLY.cn4
   DISPLAY l_ccj071 TO FORMONLY.cn5
  #CHI-C90021---add---E
   UPDATE cci_file SET(cci05)=(g_cci.cci05)
          WHERE cci01=g_cci.cci01 AND cci02=g_cci.cci02
END FUNCTION
 
FUNCTION t200_b_askkey()
DEFINE
    l_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
 
    CONSTRUCT g_wc2 ON ccj03,ccj04,ccj05,ccj051,ccj07,ccj071,ccj08    #No.FUN-7C0101  #FUN-840181
                      ,ccjud01,ccjud02,ccjud03,ccjud04,ccjud05
                      ,ccjud06,ccjud07,ccjud08,ccjud09,ccjud10
                      ,ccjud11,ccjud12,ccjud13,ccjud14,ccjud15
            FROM s_ccj[1].ccj03,s_ccj[1].ccj04,s_ccj[1].ccj05,s_ccj[1].ccj051,  #FUN-840181
                 s_ccj[1].ccj07,s_ccj[1].ccj071,s_ccj[1].ccj08 #No.FUN-7C0101
                ,s_ccj[1].ccjud01,s_ccj[1].ccjud02,s_ccj[1].ccjud03
                ,s_ccj[1].ccjud04,s_ccj[1].ccjud05,s_ccj[1].ccjud06
                ,s_ccj[1].ccjud07,s_ccj[1].ccjud08,s_ccj[1].ccjud09
                ,s_ccj[1].ccjud10,s_ccj[1].ccjud11,s_ccj[1].ccjud12
                ,s_ccj[1].ccjud13,s_ccj[1].ccjud14,s_ccj[1].ccjud15
 
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
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL t200_b_fill(l_wc2)
END FUNCTION
 
FUNCTION t200_b_fill(p_wc2)              #BODY FILL UP
DEFINE
    p_wc2           LIKE type_file.chr1000       #No.FUN-680122 VARCHAR(200)
#CHI-C90021---add---S
   DEFINE l_ccj051 LIKE ccj_file.ccj051
   DEFINE l_ccj07  LIKE ccj_file.ccj07
   DEFINE l_ccj071 LIKE ccj_file.ccj071
#CHI-C90021---add---E
 
    LET g_sql =
        "SELECT ccj03,ccj04,sfb05,ccj06,ccj05,ccj051,ccj07,ccj071,ccj08, ", #No.FUN-7C0101  #FUN-840181
        "       ccjud01,ccjud02,ccjud03,ccjud04,ccjud05,",
        "       ccjud06,ccjud07,ccjud08,ccjud09,ccjud10,",
        "       ccjud11,ccjud12,ccjud13,ccjud14,ccjud15 ",
        " FROM ccj_file LEFT OUTER JOIN sfb_file ON ccj04 = sfb_file.sfb01",
        " WHERE ccj01 ='",g_cci.cci01,"' AND ccj02 ='",g_cci.cci02,"'",
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY ccj03"
    PREPARE t200_pb FROM g_sql
    DECLARE ccj_curs CURSOR FOR t200_pb
 
    CALL g_ccj.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH ccj_curs INTO g_ccj[g_cnt].*   #單身 ARRAY 填充
        IF SQLCA.sqlcode THEN
            CALL cl_err('foreach:',SQLCA.sqlcode,1)
            EXIT FOREACH
        END IF
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_ccj.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
    DISPLAY g_rec_b TO FORMONLY.cn2
   #CHI-C90021---add---S
    SELECT SUM(ccj051),SUM(ccj07),SUM(ccj071) INTO l_ccj051,l_ccj07,l_ccj071
           FROM ccj_file
          WHERE ccj01 = g_cci.cci01 AND ccj02 = g_cci.cci02
    IF l_ccj051 IS NULL THEN LET l_ccj051 = 0 END IF
    IF l_ccj07 IS NULL THEN LET l_ccj07 = 0 END IF
    IF l_ccj071 IS NULL THEN LET l_ccj071 = 0 END IF
        DISPLAY l_ccj051 TO FORMONLY.cn3
        DISPLAY l_ccj07 TO FORMONLY.cn4
        DISPLAY l_ccj071 TO FORMONLY.cn5
   #CHI-C90021---add---E
    LET g_cnt = 0
END FUNCTION
 
FUNCTION t200_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
 
 
   IF p_ud <> "G"  OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_ccj TO s_ccj.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
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
         CALL t200_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t200_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t200_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t200_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t200_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION controls                           #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6A0092
 
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
         #圖形顯示
         #CALL cl_set_field_pic(g_cci.ccifirm,"","","","",g_cci.cciacti)  #CHI-C80041
         IF g_cci.ccifirm='X' THEN LET g_void='Y' ELSE LET g_void='N' END IF  #CHI-C80041
         CALL cl_set_field_pic(g_cci.ccifirm,"","","",g_void,g_cci.cciacti)  #CHI-C80041
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #@ON ACTION 擷取
      ON ACTION retrieve
         LET g_action_choice="retrieve"
         EXIT DISPLAY
      #@ON ACTION 確認
      ON ACTION confirm
         LET g_action_choice="confirm"
         EXIT DISPLAY
      #@ON ACTION 取消確認
      ON ACTION undo_confirm
         LET g_action_choice="undo_confirm"
         EXIT DISPLAY
      #CHI-C80041---begin
      ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY
      #CHI-C80041---end 
      #CHI-D20010--add--str
      #@ON ACTION 取消作廢
      ON ACTION undo_void
         LET g_action_choice="undo_void"
         EXIT DISPLAY
      #CHI-D20010--add---end
      #@ON ACTION 工廠切換
    # ON ACTION switch_plant                     #FUN-B10030
    #    LET g_action_choice="switch_plant"      #FUN-B10030
    #    EXIT DISPLAY                            #FUN-B10030
 
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
 
 
      ON ACTION exporttoexcel #FUN-4B0015
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY  #TQC-5B0076
 
      ON ACTION related_document                #No.FUN-6A0019  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY

      #FUN-B60115 --START--
      ON ACTION output 
         LET g_action_choice = 'output'
         EXIT DISPLAY
      #FUN-B60115 --END--   
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
      &include "qry_string.4gl"
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t200_g()
 
  DEFINE n        LIKE type_file.num10       #No.FUN-680122 INTEGER
  DEFINE l_cnt    LIKE type_file.num10       #No.FUN-680122 INTEGER
  DEFINE l_cnt1   LIKE type_file.num10       #No:CHI-B30092  add
  DEFINE l_sql    STRING                     #No:CHI-B30092  add
  DEFINE l_ccj    RECORD LIKE ccj_file.*
  DEFINE l_ccj_t  RECORD LIKE ccj_file.*
  DEFINE l_tm     RECORD
                   wc   LIKE type_file.chr1000  #No.FUN-680122 VARCHAR(300) 
                  END RECORD
  DEFINE l_sql_g  LIKE type_file.chr1000        #No.FUN-680122 VARCHAR(600)
  DEFINE l_sfb98  LIKE sfb_file.sfb98           #CHI-B20005 add
  DEFINE l_tlf06  LIKE tlf_file.tlf06,
         l_tlf19  LIKE tlf_file.tlf19,
         l_tlf026 LIKE tlf_file.tlf026,
         l_ima58  LIKE ima_file.ima58,
         l_ima912 LIKE ima_file.ima912,   #FUN-910076
         l_ima01  LIKE ima_file.ima01,
         l_ccz01  LIKE ccz_file.ccz01,
         l_ccz02  LIKE ccz_file.ccz02,
         l_tlf930 LIKE tlf_file.tlf930,   #CHI-C20031
        # l_qty1,l_qty,l_tqty,l_qty2   LIKE ima_file.ima26,    #No.FUN-680122 DEC(15,3) #FUN-910076 add l_qty2#FUN-A20044
         l_qty1,l_qty,l_tqty,l_qty2   LIKE type_file.num15_3,    #No.FUN-680122 DEC(15,3) #FUN-910076 add l_qty2#FUN-A20044
         x        RECORD
                   yy,mm LIKE type_file.num5           #No.FUN-680122 SMALLINT
                   ,rswo     LIKE type_file.chr1          #FUN-B80007    
                   ,tp   LIKE type_file.chr1           #CHI-C20031                 
                  END RECORD
  DEFINE l_rswo_wc LIKE type_file.chr100       #FUN-B80007   
  DEFINE l_flag   LIKE type_file.chr1,         #No.FUN-680122 VARCHAR(01)
         g_bdate  LIKE type_file.dat,          #No.FUN-680122 DATE
         g_edate  LIKE type_file.dat           #No.FUN-680122 DATE
  DEFINE g_chr    LIKE type_file.chr1          #No.FUN-680122 VARCHAR(01)
  DEFINE l_ccj03  LIKE ccj_file.ccj03          #MOD-D10086
  
  LET g_chr = 'y'
  LET x.yy = YEAR(TODAY)
  LET x.mm = MONTH(TODAY)
  LET x.rswo = 0   #FUN-B80007 
  LET x.tp = '1'   #CHI-C20031
  SELECT ccz01,ccz02 INTO x.yy,x.mm FROM ccz_file
 
  OPEN WINDOW t200_gw AT 06,11 WITH FORM "axc/42f/axct200_g"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_locale("axct200_g")
 
 
    CONSTRUCT BY NAME l_tm.wc ON sfb01,sfb05,sfb81
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
 
    INPUT BY NAME x.rswo,x.tp,x.yy,x.mm WITHOUT DEFAULTS   #FUN-B80007 add x.rswo  #CHI-C20031 add tp
        AFTER FIELD yy
           IF cl_null(x.yy) THEN NEXT FIELD yy END IF
 
        AFTER FIELD mm
           IF cl_null(x.mm) THEN NEXT FIELD mm END IF
           IF x.mm>12 OR x.mm<1 THEN NEXT FIELD mm END IF
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         #MOD-4C0121
           CALL cl_about()      #MOD-4C0121
 
        ON ACTION help          #MOD-4C0121
           CALL cl_show_help()  #MOD-4C0121
 
        ON ACTION controlg      #MOD-4C0121
           CALL cl_cmdask()     #MOD-4C0121
 
        AFTER INPUT
           IF INT_FLAG THEN EXIT INPUT END IF    #MOD-4A0228 modify
 
           IF x.yy*12+x.mm < g_ccz.ccz01*12+g_ccz.ccz02 THEN
              CALL cl_err('','axc-095',1)
              NEXT FIELD yy
           END IF
 
           #檢查是否已存在資料,若存在則秀提示訊息
           CALL s_azm(x.yy,x.mm) RETURNING l_flag,g_bdate, g_edate
           LET l_cnt = 0
           SELECT COUNT(*) INTO l_cnt  FROM cci_file 
            WHERE cci01 BETWEEN g_bdate AND g_edate
     END INPUT
     IF INT_FLAG THEN
        LET INT_FLAG=0
        CLOSE WINDOW t200_gw
        RETURN
     END IF
 
 
    CALL s_azm(x.yy,x.mm) RETURNING l_flag,g_bdate, g_edate
    #----------------No:CHI-B30092 add
   #LET l_cnt1 = 0 
 # 
 #  LET l_sql = "  SELECT COUNT(*) FROM cci_file,ccj_file,sfb_file ",
 #              "   WHERE cci01 = ccj01 AND cci02 = ccj02 AND ccifirm = 'Y' ",
 #              "     AND ccj01 BETWEEN '",g_bdate,"' AND '",g_edate,"'",
 #              "     AND ccj04 = sfb01 AND ", l_tm.wc

  # PREPARE t200_gpre FROM l_sql
  # DECLARE t200_gcur CURSOR FOR t200_gpre

   #OPEN t200_gcur
   #FETCH t200_gcur INTO l_cnt1
   #CLOSE t200_gcur
   #IF cl_null(l_cnt1) THEN LET l_cnt1 = 0 END IF
   #IF l_cnt1 > 0 THEN
      #carrier 20130618  --Begin
      #CALL cl_err('','axc-026',1)
  #    CALL cl_err('','axc-025',1)
      #carrier 20130618  --End  
   #   CLOSE WINDOW t200_gw
   #   RETURN 
   #END IF
  #----------------No:CHI-B30092 end
   IF l_cnt >0 THEN      #FUN-910027
     IF  cl_confirm('axc-525') THEN  #FUN-910027
         DELETE FROM cci_file WHERE cci01 BETWEEN g_bdate AND g_edate
         DELETE FROM ccj_file WHERE ccj01 BETWEEN g_bdate AND g_edate
     ELSE     #FUN-910027
         UPDATE ccj_file SET ccj07=0,ccj071=0 WHERE ccj01 BETWEEN g_bdate AND g_edate   #FUN-910027
     END IF   #FUN-910027
   END IF     #FUN-910027
    MESSAGE " Working ...."

    #FUN-B80007 --START--
    IF x.rswo = 1 THEN
       LET l_rswo_wc = " AND sfb02 IN('1','7','8')" 
    ELSE 
       LET l_rswo_wc ="   AND sfb02='1'" 
    END IF 
    #FUN-B80007 --END--
    
    LET l_sql_g = "SELECT tlf01,ima58,ima912,'B1214' tlf19,tlf62,SUM(tlf10),tlf06,tlf930",   #FUN-5B0077 #FUN-910076 add ima912 #CHI-C20031 add tlf930
                  "  ,sfb98",   #CHI-B20005 add
                  "  FROM tlf_file,ima_file,sfb_file",
                  "  WHERE (tlf06 BETWEEN '",g_bdate,"' AND '", g_edate, "')",
                  "   AND (tlf13='asft6101' OR tlf13='asft6201' OR tlf13 ='asft6231')",               #No.MOD-860314
                  "   AND tlf907<>0 ",
                  "   AND ima01 = tlf01 ",
                  "   AND tlf62 = sfb01 ",
                 #"   AND sfb02='1'",    #MOD-9B0051 add                 #FUN-B80007 mark
                  #"   AND sfb02 != '7' AND sfb02 != '8'",   #FUN-5B0091 #FUN-B80007 mark                                                               
                  "   AND ",l_tm.wc CLIPPED, l_rswo_wc,                  #FUN-B80007  
                  " GROUP BY tlf01,ima58,ima912,tlf62,tlf06,tlf930,sfb98 ",     #FUN-5B0077   #MOD-640086 add sfb98    #No.MOD-8A0011 del sfb98 #FUN-910076 #CHI-C20031 add tlf930 #CHI-B20005 add sfb98
                  
            #" ORDER BY tlf06,sfb98,tlf19"                                             #CHI-B20005 ADD
                  " ORDER BY tlf06,tlf19"            #MOD-630035 add sfb98    #FUN-660046  #No.MOD-940123 add tlf19 #CHI-B20005mark
     DISPLAY l_sql_g
     LET n = 0
     INITIALIZE l_ccj_t.* TO NULL
     PREPARE t200_g_prepare1 FROM l_sql_g
     DECLARE tlf_curs CURSOR FOR t200_g_prepare1
     FOREACH tlf_curs INTO l_ima01,l_ima58,l_ima912,l_tlf19,l_tlf026,l_qty1,l_tlf06,l_tlf930,l_sfb98       #MOD-630035 add l_sfb98   #FUN-660046 #FUN-910076  #CHI-C20031 add tlf930  #CHI-B20005 add l_sfb98
        IF l_tlf026 = 'CLO-1701180118' OR l_tlf026 ='CLO-1701180117' OR l_tlf026='CLO-1701180075' THEN 
           DISPLAY 'XXX'
        END IF
         SELECT ccz06 INTO g_ccz.ccz06 FROM ccz_file
         IF g_ccz.ccz06 != '2' THEN LET l_tlf19 = '' END IF
         IF g_ccz.ccz06 != '2' THEN LET l_tlf930 = '' END IF  #CHI-C20031
         IF l_tlf19 IS NULL THEN LET l_tlf19=' ' END IF
         IF l_tlf930 IS NULL THEN LET l_tlf930=' ' END IF  #CHI-C20031
         IF l_sfb98 IS NULL THEN LET l_sfb98=' ' END IF     #CHI-B20005 add
         LET l_ccj.ccj01=l_tlf06
         
         #carrier 20130618  --Begin
         #IF x.tp = '1' THEN  #CHI-C20031
         #  #LET l_ccj.ccj02=l_tlf19      #MOD-630035    #FUN-660046 mark回復  #CHI-B20005 mark
         #  LET l_ccj.ccj02 = l_sfb98                    #CHI-B20005 add
         ##CHI-C20031---begin
         #ELSE 
         #  #LET l_ccj.ccj02=l_tlf930                     #CHI-B20005   mark
         #   LET l_ccj.ccj02 = l_tlf19                    #CHI-B20005   add
         #END IF 
         IF x.tp = '1' THEN 
            LET l_ccj.ccj02 = l_tlf19
         ELSE 
            LET l_ccj.ccj02 = l_sfb98
         END IF 
         #CHI-C20031---end
         #carrier 20130618  --End  
         IF l_ccj.ccj04 = '305-15010006' THEN
            MESSAGE l_ccj.ccj04
         END IF

         IF l_ccj_t.ccj01 IS NULL OR
            l_ccj.ccj01!=l_ccj_t.ccj01 OR l_ccj.ccj02!=l_ccj_t.ccj02 THEN
            IF l_ccj_t.ccj01 IS NOT NULL THEN
               INSERT INTO cci_file(cci01,cci02,cci05,cciinpd,ccifirm,
                                    cciacti,cciuser,ccigrup,ccioriu,cciorig,ccilegal)   #FUN-A50075 add legal
                             VALUES(l_ccj_t.ccj01,l_ccj_t.ccj02,l_tqty,g_today,'Y','Y',
                                    g_user,g_grup, g_user, g_grup,g_legal)      #No.FUN-980030 10/01/04  insert columns oriu, orig  #FUN-A50075 add legal
            END IF
            LET n = 0
            LET l_tqty = 0
            LET l_ccj_t.ccj01=l_ccj.ccj01
            LET l_ccj_t.ccj02=l_ccj.ccj02
         END IF
         LET n = n+1
         IF l_ima58 IS NULL THEN LET l_ima58=0 END IF
         IF l_ima912 IS NULL THEN LET l_ima912=0 END IF  #FUN-910076
         LET l_qty  = l_qty1
         LET l_qty1 = l_qty * l_ima58
         LET l_qty2 = l_qty * l_ima912    #FUN-910076
         LET l_tqty = l_tqty+l_qty1+l_qty2   #FUN-910072 add +l_qty2
         LET l_ccj.ccj03=n
         LET l_ccj.ccj04=l_tlf026
         LET l_ccj.ccj05=0               #FUN-910072
         LET l_ccj.ccj051=0  #FUN-840181 #FUN-910072
         LET l_ccj.ccj07=l_qty1          #FUN-910072
         LET l_ccj.ccj071=l_qty2         #FUN-910076
         LET l_ccj.ccj06=l_qty
         LET l_ccj.ccjlegal = g_legal    #FUN-A50075 
         #MOD-D10086---begin
         LET l_ccj03 = 0
         SELECT ccj03
           INTO l_ccj03
           FROM ccj_file
          WHERE ccj01 = l_ccj.ccj01
            AND ccj02 = l_ccj.ccj02
            AND ccj04 = l_ccj.ccj04
         IF cl_null(l_ccj03) OR l_ccj03 = 0 THEN
            SELECT MAX(ccj03)
              INTO l_ccj03
              FROM ccj_file
             WHERE ccj01 = l_ccj.ccj01
               AND ccj02 = l_ccj.ccj02
            IF cl_null(l_ccj03) THEN
               LET l_ccj03 = 0
            END IF
            IF l_ccj.ccj03 - l_ccj03 > 1 THEN 
               LET l_ccj03 = l_ccj.ccj03 - 1 
            END IF
            LET n = l_ccj03 +1
         #MOD-D10086---end 
            INSERT INTO ccj_file VALUES(l_ccj.*)
#        IF SQLCA.sqlcode='-239' THEN  #FUN-910072 #CHI-C30115 mark
            IF cl_sql_dup_value(SQLCA.sqlcode) THEN #CHI-C30115 add
               UPDATE ccj_file SET ccj07 = ccj07+l_ccj.ccj07,    #FUN-910072
                                   ccj071 = ccj071+l_ccj.ccj071  #FUN-910072
                WHERE ccj01 = l_ccj.ccj01
                  AND ccj02 = l_ccj.ccj02
                  AND ccj04 = l_ccj.ccj04
            END IF
         #MOD-D10086---begin   
         ELSE 
            UPDATE ccj_file SET ccj07 = ccj07+l_ccj.ccj07,    
                                ccj071 = ccj071+l_ccj.ccj071  
             WHERE ccj01 = l_ccj.ccj01
               AND ccj02 = l_ccj.ccj02
               AND ccj03 = l_ccj03
         END IF 
         #MOD-D10086---end
     END FOREACH
     INSERT INTO cci_file(cci01,cci02,cci05,cciinpd,ccifirm,
                          cciacti,cciuser,ccigrup,ccioriu,cciorig,ccilegal)   #FUN-A50075 add legal
                   VALUES(l_ccj_t.ccj01,l_ccj_t.ccj02,l_tqty,g_today,'Y','Y',
                          g_user,g_grup, g_user, g_grup,g_legal)      #No.FUN-980030 10/01/04  insert columns oriu, orig  #FUN-A50075 add legal
     CLOSE WINDOW t200_gw
END FUNCTION
 
FUNCTION t200_cci02()
DEFINE
    p_cmd           LIKE type_file.chr1,
    l_gemacti       LIKE gem_file.gemacti
 
    LET g_errno = ''
    SELECT gemacti  INTO l_gemacti FROM gem_file
     WHERE gem01 = g_cci.cci02
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg1318'
                                   LET l_gemacti = NULL
         WHEN l_gemacti='N'        LET g_errno = '9028'
         OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/13
#CHI-C80041---begin
#FUNCTION t200_v()                      #CHI-D20010
FUNCTION t200_v(p_type)                 #CHI-D20010
   DEFINE l_chr LIKE type_file.chr1
   DEFINE p_type    LIKE type_file.chr1  #CHI-D20010
   DEFINE l_flag    LIKE type_file.chr1  #CHI-D20010

   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_cci.cci01) OR cl_null(g_cci.cci02) THEN CALL cl_err('',-400,0) RETURN END IF  
    #CHI-D20010---begin
   IF p_type = 1 THEN
      IF g_cci.ccifirm='X' THEN RETURN END IF
   ELSE
      IF g_cci.ccifirm<>'X' THEN RETURN END IF
   END IF
   #CHI-D20010---end
 
   BEGIN WORK
 
   LET g_success='Y'
 
   OPEN t200_cl USING g_cci.cci01,g_cci.cci02
   IF STATUS THEN
      CALL cl_err("OPEN t200_cl:", STATUS, 1)
      CLOSE t200_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t200_cl INTO g_cci.*          #鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_cci.cci01,SQLCA.sqlcode,0)      #資料被他人LOCK
      CLOSE t200_cl ROLLBACK WORK RETURN
   END IF
   #-->確認不可作廢
   IF g_cci.ccifirm = 'Y' THEN CALL cl_err('',9023,0) RETURN END IF 
   #IF cl_void(0,0,g_cci.ccifirm)   THEN                               #CHI-D20010
   IF p_type = 1 THEN LET l_flag = 'N' ELSE LET l_flag = 'X' END IF    #CHI-D20010
   IF cl_void(0,0,l_flag) THEN                                         #CHI-D20010
        LET l_chr=g_cci.ccifirm
       #IF g_cci.ccifirm='N' THEN                                      #CHI-D20010
        IF p_type = 1 THEN                                             #CHI-D20010
            LET g_cci.ccifirm='X' 
        ELSE
            LET g_cci.ccifirm='N'
        END IF
        UPDATE cci_file
            SET ccifirm=g_cci.ccifirm,  
                ccimodu=g_user,
                ccidate=g_today
            WHERE cci01=g_cci.cci01
              AND cci02=g_cci.cci02
        IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
            CALL cl_err3("upd","cci_file",g_cci.cci01,"",SQLCA.sqlcode,"","",1)  
            LET g_cci.ccifirm=l_chr 
        END IF
        DISPLAY BY NAME g_cci.ccifirm
   END IF
 
   CLOSE t200_cl
   COMMIT WORK
   CALL cl_flow_notify(g_cci.cci01,'V')
 
END FUNCTION
#CHI-C80041---end

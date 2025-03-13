# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: asft802.4gl
# Descriptions...: 工單單身變更作業
# Date & Author..: 03/03/20 By Carol   #bugno:6896  for 養生計劃
# Modify.........: No.MOD-490217 04/09/10 by yiting 料號欄位用like方式
# Modify.........: No.MOD-490371 04/09/22 By Yuna Controlp 未加display
# Modify.........: No.MOD-4A0063 04/10/06 By Mandy q_ime 的參數傳的有誤
# Modify.........: No.MOD-4A0213 04/10/14 By Mandy q_imd 的參數傳的有誤
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-5B0271 05/12/07 By Pengu 只輸入"工單單號",直接按確定,系統會詢問是否刪除,
                               #                   若選'否',會造成INSERT成功,但無變更序號
# Modify.........: No.TQC-630013 06/03/03 By Claire 串報表傳參數
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/09/01 By huchenghao 類型轉換
# Modify.........: No.FUN-690022 06/09/20 By jamie 判斷imaacti
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/31 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6B0031 06/11/10 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0002 06/11/15 By johnray 報表修改
# Modify.........: No.FUN-6B0079 06/12/04 By jamie 1.FUNCTION _fetch() 清空key值
#                                                  2.新增action"相關文件"
# Modify.........: No.TQC-690123 06/12/14 By pengu 1.sna08a 預設應為空白字元
#                                                  2.當單身為 1 新增時，變更後已發(sna06a)/欠料(sna07a)不可輸入 
#                                                  3.判斷 sna31a = g_sna[l_ac].sna31b時，應增加檢查sna31a<>'1'時才需檢查 
# Modify.........: No.FUN-710026 07/01/26 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.CHI-790021 07/09/17 By kim 修改-239的寫法
# Modify.........: No.FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-870051 08/07/18 By sherry 增加被替代料(sfa27)為Key值
# Modify.........: No.FUN-8A0086 08/10/17 By bafei  完善FUN-710050的錯誤匯總的修改
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-930172 09/03/17 By chenyu 1.欠料量計算有誤，應該用應發-已發-委外
#                                                   2.t802_sna27(傳入的s27為空，導致后面取不到值
# Modify.........: No.TQC-940121 09/05/08 By mike 畫面中沒有desc1欄位    
# Modify.........: No.TQC-940176 09/05/11 By mike SELECT COUNT(*),snb04 缺少group by子句  
# Modify.........: No.FUN-940083 09/05/14 By mike 原可收量計算(pmn20-pmn50+pmn55)全部改為(pmn20-pmn50+pmn55+pmn58)
# Modify.........: No.MOD-950266 09/06/01 By mike 請在AFTER FIELD sna28a(替代率)判斷替代率是否小於等于0，若小於等于0則不允許        
# Modify.........: No.MOD-970134 09/07/15 By sherry 修正SQL錯誤
# Modify.........: No.TQC-970143 09/07/17 By sherry 查詢時，狀態頁簽無法輸入條件    
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-9A0068 09/10/23 by dxfwo VMI测试结果反馈及相关调整
# Modify.........: No.TQC-9B0016 09/11/04 By liuxqa 标准SQL修改。
# Modify.........: No.FUN-9C0072 10/01/12 By vealxu 精簡程式碼
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A20037 10/04/02 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No.FUN-A60027 10/06/18 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.FUN-A70125 10/07/27 By lilingyu 平行工藝
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No.FUN-AB0044 10/11/11 By zhangll 增加仓库营运中心控管
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-BB0085 11/12/05 By xianghui 增加數量欄位小取位
# Modify.........: No.FUN-910088 11/12/13 By chenjing 增加數量欄位小取位
# Modify.........: No:FUN-C10039 12/02/02 by Hiko 整批修改資料歸屬設定
# Modify.........: No.MOD-C30605 12/03/12 By destiny 变更数量不能少于已发数量
# Modify.........: No.TQC-C50112 12/05/14 By fengrui 未確認的工單不可做工單變更
# Modify.........: No.TQC-C50155 12/05/18 By fengrui 調整最大變更版本值的抓法,修正單身錯誤
# Modify.........: No:FUN-C30085 12/07/05 By nanbing CR改串GR
# Modify.........: No:FUN-D40030 13/04/08 By xumm 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
# Modify.........: No:MOD-D40108 13/04/16 By bart 不控卡 委外工單且一對一型態 的工單

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_snb           RECORD LIKE snb_file.*,       #WO (假單頭)
    g_snb_t         RECORD LIKE snb_file.*,       #WO (舊值)
    g_snb_o         RECORD LIKE snb_file.*,       #WO (舊值)
    g_sfb           RECORD LIKE sfb_file.*,
    g_ima           RECORD LIKE ima_file.*,
    g_bmb           RECORD LIKE bmb_file.*,
    b_sna           RECORD LIKE sna_file.*,
    g_snb01_t       LIKE snb_file.snb01,
    g_snb02_t       LIKE snb_file.snb02,
    g_yy,g_mm       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    g_sna           DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
                    sna10     LIKE sna_file.sna10,
                    desc      LIKE sna_file.sna12b,        #No.FUN-680121 VARCHAR(04)
                    sna04     LIKE sna_file.sna04,
                    sna27b    LIKE sna_file.sna27b,
                    sna03b    LIKE sna_file.sna03b,
                    ima02b    LIKE ima_file.ima02,
                    sna08b    LIKE sna_file.sna08b,
                    sna11b    LIKE sna_file.sna11b,
                    sna12b    LIKE sna_file.sna12b,
                    sna13b    LIKE sna_file.sna13b,
                    sna100b   LIKE sna_file.sna100b,
                    sna26b    LIKE sna_file.sna26b,
                    sna28b    LIKE sna_file.sna28b,
                    sna161b   LIKE sna_file.sna161b,
                    sna05b    LIKE sna_file.sna05b,
                    sna062b   LIKE sna_file.sna062b,
                    sna06b    LIKE sna_file.sna06b,
                    sna07b    LIKE sna_file.sna07b,
                    sna065b   LIKE sna_file.sna065b,
                    sna30b    LIKE sna_file.sna30b,
                    sna31b    LIKE sna_file.sna31b,
                    sna27a    LIKE sna_file.sna27a,
                    sna03a    LIKE sna_file.sna03a,
                    ima02a    LIKE ima_file.ima02,
                    sna08a    LIKE sna_file.sna08a,
                    sna11a    LIKE sna_file.sna11a,
                    sna12a    LIKE sna_file.sna12a,
                    sna13a    LIKE sna_file.sna13a,
                    sna100a   LIKE sna_file.sna100a,
                    sna26a    LIKE sna_file.sna26a,
                    sna28a    LIKE sna_file.sna28a,
                    sna161a   LIKE sna_file.sna161a,
                    sna05a    LIKE sna_file.sna05a,
                    sna062a   LIKE sna_file.sna062a,
                    sna06a    LIKE sna_file.sna06a,
                    sna07a    LIKE sna_file.sna07a,
                    sna065a   LIKE sna_file.sna065a,
                    sna30a    LIKE sna_file.sna30a,
                    sna31a    LIKE sna_file.sna31a,
                    sna50     LIKE sna_file.sna50
                    END RECORD,
    g_sna_t         RECORD    #程式變數舊值
                    sna10     LIKE sna_file.sna10,
                    desc      LIKE sna_file.sna12b,        #No.FUN-680121 VARCHAR(4)
                    sna04     LIKE sna_file.sna04,
                    sna27b    LIKE sna_file.sna27b,
                    sna03b    LIKE sna_file.sna03b,
                    ima02b    LIKE ima_file.ima02,
                    sna08b    LIKE sna_file.sna08b,
                    sna11b    LIKE sna_file.sna11b,
                    sna12b    LIKE sna_file.sna12b,
                    sna13b    LIKE sna_file.sna13b,
                    sna100b   LIKE sna_file.sna100b,
                    sna26b    LIKE sna_file.sna26b,
                    sna28b    LIKE sna_file.sna28b,
                    sna161b   LIKE sna_file.sna161b,
                    sna05b    LIKE sna_file.sna05b,
                    sna062b   LIKE sna_file.sna062b,
                    sna06b    LIKE sna_file.sna06b,
                    sna07b    LIKE sna_file.sna07b,
                    sna065b   LIKE sna_file.sna065b,
                    sna30b    LIKE sna_file.sna30b,
                    sna31b    LIKE sna_file.sna31b,
                    sna27a    LIKE sna_file.sna27a,
                    sna03a    LIKE sna_file.sna03a,
                    ima02a    LIKE ima_file.ima02,
                    sna08a    LIKE sna_file.sna08a,
                    sna11a    LIKE sna_file.sna11a,
                    sna12a    LIKE sna_file.sna12a,
                    sna13a    LIKE sna_file.sna13a,
                    sna100a   LIKE sna_file.sna100a,
                    sna26a    LIKE sna_file.sna26a,
                    sna28a    LIKE sna_file.sna28a,
                    sna161a   LIKE sna_file.sna161a,
                    sna05a    LIKE sna_file.sna05a,
                    sna062a   LIKE sna_file.sna062a,
                    sna06a    LIKE sna_file.sna06a,
                    sna07a    LIKE sna_file.sna07a,
                    sna065a   LIKE sna_file.sna065a,
                    sna30a    LIKE sna_file.sna30a,
                    sna31a    LIKE sna_file.sna31a,
                    sna50     LIKE sna_file.sna50
                    END RECORD,
    g_sfa29         DYNAMIC ARRAY of LIKE sfa_file.sfa29,        #No.FUN-680121 VARCHAR(40)#程式變數(Program Variables)
     g_wc,g_wc2,g_sql    string,  #No.FUN-580092 HCN
    g_argv1             LIKE snb_file.snb01,
    g_argv2             LIKE snb_file.snb02,
    g_delete            LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_cmd               LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(300)
    g_rec_b             LIKE type_file.num5,          #單身筆數        #No.FUN-680121 SMALLINT
    g_t1                LIKE oay_file.oayslip,       #No.FUN-550067              #No.FUN-680121 VARCHAR(5)
    l_ac                LIKE type_file.num5          #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
DEFINE g_forupd_sql STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_before_input_done  LIKE type_file.num5     #No.FUN-680121 SMALLINT
DEFINE g_chr           LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE g_msg           LIKE type_file.chr1000      #No.FUN-680121 #TQC-630013
DEFINE g_row_count    LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_curs_index   LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_jump         LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE g_no_ask       LIKE type_file.num5         #No.FUN-680121 SMALLINT
DEFINE g_confirm       LIKE type_file.chr1         #No.FUN-680121 VARCHAR(1)
DEFINE g_approve       LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_post          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_close         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_void          LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE g_valid         LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
DEFINE l_zemsg   LIKE ze_file.ze03
DEFINE g_sna12a_t      LIKE sna_file.sna12a         #FUN-910088--add--
 
MAIN
    OPTIONS
        INPUT NO WRAP,
        FIELD ORDER FORM
    DEFER INTERRUPT
 
    LET g_argv1     = ARG_VAL(1)
    LET g_argv2     = ARG_VAL(2)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
    LET g_wc2=' 1=1'
 
    LET g_forupd_sql = "SELECT * FROM snb_file WHERE snb01 = ? AND snb02 = ?  FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t802_cl CURSOR FROM g_forupd_sql
 
      CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
    OPEN WINDOW t802_w WITH FORM "asf/42f/asft802"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    LET g_snb.snb04 = '2'
 
    DISPLAY BY NAME g_snb.snb04
 
    SELECT ze03 INTO l_zemsg FROM ze_file
        WHERE ze01 = 'asf-832' AND ze02 = g_lang
 
    DISPLAY l_zemsg CLIPPED TO FORMONLY.desc1
 
    IF NOT cl_null(g_argv1) THEN CALL t802_q() END IF
 
    CALL t802_menu()
 
    CLOSE t802_cl
    CLOSE WINDOW t802_w
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
 
END MAIN
 
#QBE 查詢資料
FUNCTION t802_cs()
DEFINE  lc_qbe_sn       LIKE    gbm_file.gbm01    #No.FUN-580031  HCN
    IF NOT cl_null(g_argv1) THEN
       LET g_wc = "snb01 = '",g_argv1,"' "
       IF NOT cl_null(g_argv2) THEN
          LET g_wc = g_wc CLIPPED," AND snb02 = ",g_argv2 CLIPPED
       END IF
       LET g_wc2= " 1=1"
       DISPLAY BY NAME g_snb.snb04
       DISPLAY BY NAME g_snb.snb01,g_snb.snb02
    ELSE
       CLEAR FORM
       CALL g_sna.clear()
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_snb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME g_wc ON snb01,snb02,snb022,snbconf
                                 ,snbuser,snbgrup,snbmodu,snbdate     #TQC-970143 add 
               BEFORE CONSTRUCT
                  CALL cl_qbe_init()
        ON ACTION controlp
           CASE
             WHEN INFIELD(snb01)    #查詢符合條件的單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sfb02"
                  LET g_qryparam.construct= "Y"
                  LET g_qryparam.arg1     = "234567"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO snb01
                  NEXT FIELD snb01
             OTHERWISE EXIT CASE
           END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
		   CALL cl_qbe_list() RETURNING lc_qbe_sn
		   CALL cl_qbe_display_condition(lc_qbe_sn)
       END CONSTRUCT
 
       IF INT_FLAG THEN  RETURN END IF
 
       LET g_wc = g_wc CLIPPED," AND snb04 = '2' "
 
      CONSTRUCT g_wc2 ON
                 sna04,sna10,
                 sna27a,sna03a,sna08a,sna11a,sna12a,sna13a,
                 sna100a,sna26a,sna28a,sna161a,sna05a,sna062a,
                 sna06a,sna07a,sna30a,sna31a
            FROM s_sna[1].sna04,s_sna[1].sna10,
                 s_sna[1].sna27a,s_sna[1].sna03a,s_sna[1].sna08a,s_sna[1].sna11a,
                 s_sna[1].sna12a,s_sna[1].sna13a,s_sna[1].sna100a,s_sna[1].sna26a,
                 s_sna[1].sna28a,s_sna[1].sna161a,s_sna[1].sna05a,s_sna[1].sna062a,
                 s_sna[1].sna06a,s_sna[1].sna07a,s_sna[1].sna30a,s_sna[1].sna31a
		BEFORE CONSTRUCT
		   CALL cl_qbe_display_condition(lc_qbe_sn)
 
        ON ACTION controlp
           CASE                        #查詢符合條件的料號
             WHEN INFIELD(sna04)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_sfa3"
                  LET g_qryparam.arg2     = g_snb.snb01
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sna03b
                  NEXT FIELD sna04
             WHEN INFIELD(sna27a)
#FUN-AA0059---------mod------------str-----------------             
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.state    = "c"
#                  LET g_qryparam.form     = "q_ima"
#                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                   CALL q_sel_ima(TRUE, "q_ima","","","","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                  DISPLAY g_qryparam.multiret TO sna27a
                  NEXT FIELD sna27a
             WHEN INFIELD(sna08a)
                  CALL q_ecd(TRUE,TRUE,g_sna[1].sna08a) RETURNING g_sna[1].sna08a
                   DISPLAY BY NAME g_sna[1].sna08a   #No.MOD-490371
                  NEXT FIELD sna08a
             WHEN INFIELD(sna12a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.state    = "c"
                  LET g_qryparam.form     = "q_gfe"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO sna12a
                  NEXT FIELD sna12a
             WHEN INFIELD(sna30a)
                 #Mod No.FUN-AB0044
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.state    = "c"
                 #LET g_qryparam.form     = "q_imd"
                 #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_imd_1(TRUE,TRUE,"","",g_plant,"","")  #只能开当前门店的
                       RETURNING g_qryparam.multiret
                 #End Mod No.FUN-AB0044
                  DISPLAY g_qryparam.multiret TO sna30a
                  NEXT FIELD sna30a
             WHEN INFIELD(sna31a)
                 #Mod No.FUN-AB0044
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.state    = "c"
                 #LET g_qryparam.form     = "q_ime"
                 #CALL cl_create_qry() RETURNING g_qryparam.multiret
                  CALL q_ime_1(TRUE,TRUE,"","","",g_plant,"","","")
                       RETURNING g_qryparam.multiret
                 #End Mod No.FUN-AB0044
                  DISPLAY g_qryparam.multiret TO sna31a
                  NEXT FIELD sna31a
             OTHERWISE EXIT CASE
           END CASE
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
                    ON ACTION qbe_save
		       CALL cl_qbe_save()
       END CONSTRUCT
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
    END IF
    LET g_wc = g_wc CLIPPED,cl_get_extra_cond('snbuser', 'snbgrup')
 
 
    IF g_wc2 = " 1=1" THEN                        #若單身未輸入條件
       LET g_sql = "SELECT snb01,snb02 FROM snb_file ",
                   " WHERE ", g_wc CLIPPED,
                   " ORDER BY snb01,snb02"
    ELSE
       LET g_sql = "SELECT UNIQUE snb01,snb02 ",
                   " FROM snb_file,sna_file ",
                   " WHERE snb01 = sna01 ",
                   "  AND  snb02 = sna02 ",
                   "  AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED,
                   " ORDER BY snb01,snb02 "
    END IF
    PREPARE t802_prepare FROM g_sql      #預備一下
    DECLARE t802_b_cs                    #宣告成可捲動的
        SCROLL CURSOR WITH HOLD FOR t802_prepare
 
    IF g_wc2 = " 1=1" THEN               #取合乎條件筆數
        LET g_sql="SELECT COUNT(*) FROM snb_file WHERE ",g_wc CLIPPED
    ELSE
        LET g_sql="SELECT COUNT(DISTINCT snb01) FROM snb_file,sna_file ",
                  " WHERE sna01=snb01 AND sna02=snb02 ",
                  " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED
    END IF
    PREPARE t802_precount FROM g_sql
    DECLARE t802_count CURSOR FOR t802_precount
 
END FUNCTION
 
FUNCTION t802_menu()
 
   WHILE TRUE
      CALL t802_bp("G")
      CASE g_action_choice
 
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL t802_a()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL t802_q()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
               CALL t802_r()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL t802_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "output"
            CALL t802_out()
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         WHEN "rep_sub"
            IF cl_chk_act_auth() THEN
               IF cl_chk_act_auth() THEN
                  CALL t802_sub()
               END IF
            END IF
         WHEN "change_release"
            IF cl_chk_act_auth() THEN
               IF cl_chk_act_auth() THEN
                  CALL t802_g()
               END IF
            END IF
            CASE g_snb.snbconf
                 WHEN 'Y'   LET g_confirm = 'Y'
                            LET g_void = ''
                 WHEN 'N'   LET g_confirm = 'N'
                            LET g_void = ''
                 WHEN 'X'   LET g_confirm = ''
                            LET g_void = 'Y'
              OTHERWISE     LET g_confirm = ''
                            LET g_void = ''
            END CASE
            #圖形顯示
            CALL cl_set_field_pic(g_confirm,"","","",g_void,"")
         WHEN "memo"
            IF g_snb.snbconf !='X' THEN
               CALL t802_memo()
            END IF
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sna),'','')
            END IF
         WHEN "related_document"           #相關文件
          IF cl_chk_act_auth() THEN
             IF g_snb.snb01 IS NOT NULL THEN
                LET g_doc.column1 = "snb01"
                LET g_doc.column2 = "snb02"
                LET g_doc.value1 = g_snb.snb01
                LET g_doc.value2 = g_snb.snb02
                CALL cl_doc()
             END IF 
          END IF
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t802_a()
  DEFINE  i     LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
    IF s_shut(0) THEN RETURN END IF
    MESSAGE ""
    CLEAR FORM
    CALL g_sna.clear()
    CALL g_sfa29.clear()
 
    INITIALIZE g_snb.* LIKE snb_file.*             #DEFAULT 設定
    INITIALIZE g_snb_t.* LIKE snb_file.*           #DEFAULT 設定
    INITIALIZE g_snb_o.* LIKE snb_file.*           #DEFAULT 設定
    LET g_snb.snb01  = ''
    LET g_snb.snb022 = g_today
    LET g_snb.snb04 = '2'
    DISPLAY BY NAME g_snb.snb04
    CALL cl_opmsg('a')
    WHILE TRUE
        LET g_snb.snb04 = '2'
        LET g_snb.snbconf = 'N'                    #發出否
        LET g_snb.snbgrup=g_grup
        LET g_snb.snbdate=g_today
        LET g_snb.snbuser=g_user
        LET g_snb.snboriu = g_user #FUN-980030
        LET g_snb.snborig = g_grup #FUN-980030
        LET g_data_plant = g_plant #FUN-980030
        LET g_snb.snbplant = g_plant #FUN-980008 add
        LET g_snb.snblegal = g_legal #FUN-980008 add
        LET g_snb.snbplant = g_plant #FUN-980008 add
        LET g_snb.snblegal = g_legal #FUN-980008 add
        CALL t802_i("a")                           #輸入單頭
        IF INT_FLAG THEN                           #使用者不玩了
            INITIALIZE g_snb.* TO NULL
            LET INT_FLAG = 0
            EXIT WHILE
        END IF
        INSERT INTO snb_file VALUES(g_snb.*)
        IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","snb_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
            CONTINUE WHILE
        ELSE
            SELECT snb01,snb02 INTO g_snb.snb01,g_snb.snb02 FROM snb_file
             WHERE snb01 = g_snb.snb01
               AND snb02 = g_snb.snb02
        END IF
 
        CALL g_sna.clear()
        CALL g_sfa29.clear()
        INITIALIZE g_sna_t.* TO NULL
        LET g_rec_b = 0
 
        CALL t802_b()                   #輸入單身
        EXIT WHILE
    END WHILE
END FUNCTION
 
FUNCTION t802_i(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #a:輸入 u:更改        #No.FUN-680121 VARCHAR(1)
    l_cmd           LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(70)
    l_snb02         LIKE type_file.num5,          #No.FUN-680121 SMALLINT#變更序號
    l_n             LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_cnt           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_snb01         LIKE snb_file.snb01,
    l_sfb081        LIKE sfb_file.sfb081,
    l_sfb24         LIKE sfb_file.sfb24,
    l_sfb25         LIKE sfb_file.sfb25,
    l_snb04         LIKE snb_file.snb04,
    l_snbconf       LIKE snb_file.snbconf, #發出否
    l_str           LIKE type_file.chr50          #No.FUN-680121 VARCHAR(40)
 
    DISPLAY BY NAME g_snb.snbconf,g_snb.snbuser,g_snb.snbmodu,g_snb.snbdate
    IF g_snb.snbconf='Y' THEN CALL cl_err('','asf-224',1) RETURN END IF
    IF g_snb.snb04='1'   THEN CALL cl_err('','asf-062',1) RETURN END IF
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
    INPUT BY NAME g_snb.snb01,g_snb.snb022 WITHOUT DEFAULTS
 
        BEFORE INPUT
            LET g_before_input_done = FALSE
            CALL t802_set_entry(p_cmd)
            CALL t802_set_no_entry(p_cmd)
            LET g_before_input_done = TRUE
 
         CALL cl_set_docno_format("snb01")
 
        AFTER FIELD snb01                   #WO
            IF NOT cl_null(g_snb.snb01) THEN
               IF p_cmd = 'a' OR
                 (p_cmd = "u" AND (( g_snb.snb01 != g_snb01_t)
                               OR (g_snb.snb01 != g_snb01_t))) THEN
  
                #TQC-C50112--add--str--
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM sfb_file
                   WHERE sfb01 = g_snb.snb01
                     AND sfb87 != 'Y'
                  IF l_cnt > 0 THEN
                     CALL cl_err('','asf-019',1)
                    NEXT FIELD snb01
                  END IF
                 #TQC-C50112--add--end--                    
                 #若為新增時自動帶出變更序號
                 #TQC-C50155--modify--str--
                 #IF p_cmd = 'a' THEN
                 #   SELECT sfb101 INTO g_snb.snb02 FROM sfb_file
                 #   WHERE sfb01 = g_snb.snb01
                 #   IF cl_null(g_snb.snb02) THEN
                 #      LET g_snb.snb02 = 1
                 #   ELSE
                 #      LET g_snb.snb02 = g_snb.snb02 + 1
                 #   END IF
                 #   DISPLAY BY NAME g_snb.snb02
                 #END IF
                  IF cl_null(g_snb_t.snb01) OR (g_snb.snb01 != g_snb_t.snb01) THEN
                     SELECT max(snb02) INTO g_snb.snb02
                       FROM snb_file
                      WHERE snb01 = g_snb.snb01
                     IF cl_null(g_snb.snb02) THEN
                        LET g_snb.snb02 = 1
                     ELSE
                        LET g_snb.snb02 = g_snb.snb02 + 1
                     END IF
                  END IF
                  DISPLAY BY NAME g_snb.snb02
                 #TQC-C50155--modify--end--

#檢查輸入之工單若有尚未做發出確認的工單變更單資料
                  LET l_cnt = 0
                  SELECT COUNT(*),snb04 INTO l_cnt,l_snb04 FROM snb_file
                   WHERE snb01 = g_snb.snb01
                     AND snbconf = 'N'
                  GROUP BY snb04 #TQC-940176   
                  IF l_cnt > 0 THEN
#檢查輸入之工單若有尚未做發出確認的工單[單頭變更]資料
                     IF l_snb04 = '1' THEN
                        CALL cl_err('','asf-075',0)
                     ELSE
#檢查輸入之工單若有尚未做發出確認的工單[單身變更]資料
                        CALL cl_err('','asf-050',0)
                     END IF
                     NEXT FIELD snb01
                  END IF
#MOD-D40108---begin 
##檢查輸入之工單若為其他工單之母工單或此工單之下還有相關的子工單
#                  LET l_cnt = 0
#                  SELECT COUNT(*) INTO l_cnt FROM sfb_file
#                   WHERE sfb86 = g_snb.snb01
#                     AND sfbacti = 'Y'
# 
##開窗詢問『此工單為母子工單，是否確定執行(Y/N)？』
#                  IF l_cnt > 0 THEN
#                     IF NOT cl_confirm('asf-051') THEN
#                        NEXT FIELD snb01
#                     END IF
#                  END IF
# 
##檢查輸入之工單是否已產生[工單製程檔](ecm_file)資料或 sfb24='Y'
#                  LET l_cnt = 0
#                  SELECT sfb24,COUNT(*)
#                    INTO l_sfb24,l_cnt FROM sfb_file,ecm_file
#                   WHERE sfb01 = g_snb.snb01
#                     AND sfbacti = 'Y'
#                     AND ecm01 = sfb01
#                     AND ecm03_par = sfb05
#                     AND ecmacti = 'Y'
#                   GROUP BY sfb24
#                  IF l_cnt > 0 OR l_sfb24 = 'Y' THEN
#                     CALL cl_err('','asf-052',0)
#                     NEXT FIELD snb01
#                  END IF
#MOD-D40108---end 
#檢查輸入之工單若為委外工單/重工委外工單(sfb02='7' OR '8')
#且已有收貨紀錄(rvaconf = 'X'也算)
                  LET l_cnt = 0
                  SELECT COUNT(*) INTO l_cnt FROM sfb_file,rva_file,rvb_file
                   WHERE sfb01 = g_snb.snb01
                     AND sfbacti = 'Y'
                     AND ( sfb02 = '7' OR sfb02 = '8' )
                     AND rvb34 = sfb01
                     AND rvb01 = rva01
                  IF l_cnt > 0 THEN
                     CALL cl_err('','asf-053',0)
                     NEXT FIELD snb01
                  END IF
#MOD-D40108---begin 
##檢查輸入之工單若為委外工單且為 1對1型態 則不可變更
#                  LET l_cnt = 0
#                  SELECT COUNT(*) INTO l_cnt FROM sfb_file
#                   WHERE sfb01 = g_snb.snb01
#                     AND sfb100 = '1'
#                     AND sfbacti = 'Y'
#                     AND ( sfb02 = '7' OR sfb02 = '8' )
#                  IF l_cnt > 0 THEN
#                     CALL cl_err('','asf-076',0)
#                     NEXT FIELD snb01
#                  END IF
#MOD-D40108---end 
                #自動帶出工單資訊
                  CALL t802_snb01(p_cmd)
                  IF NOT cl_null(g_errno) THEN
                     CALL cl_err('',g_errno,0)
                     NEXT FIELD snb01
                  END IF
               END IF
            END IF
 
        BEFORE FIELD snb022
            IF p_cmd = "a" OR                    # 若輸入或更改且改KEY
              (p_cmd = "u" AND (( g_snb.snb01 != g_snb01_t)
               OR (g_snb.snb01 != g_snb01_t))) THEN
                SELECT COUNT(*) INTO l_n FROM snb_file
                 WHERE snb01 = g_snb.snb01
                   AND snb02 = g_snb.snb02
                IF l_cnt > 0 THEN
                   CALL cl_err(g_snb.snb01,'mfg4000',0)
                   LET g_snb.snb01 = g_snb01_t
                   LET g_snb.snb02 = g_snb02_t
                   DISPLAY BY NAME g_snb.snb01
                   DISPLAY BY NAME g_snb.snb02
                   NEXT FIELD snb01
                END IF
 
#工單第一次變更時default 1,之後工單每變更一次序號加 1
                IF p_cmd = 'a' THEN
                   #本欄位預設值為系統日期
                   IF cl_null(g_snb.snb022) THEN
                      LET g_snb.snb022 = g_today
                   END IF
                END IF
            END IF
 
        AFTER FIELD snb022
           IF NOT cl_null(g_snb.snb022) THEN
 
             #日期不可大於單據輸入會計年度/期別
              CALL s_yp(g_snb.snb022) RETURNING g_yy,g_mm
              IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
                 CALL cl_err(g_yy,'mfg6090',0) NEXT FIELD snb022
              END IF
 
             #日期不可小於成本關帳日期sma53
              IF NOT cl_null(g_sma.sma53) AND g_snb.snb022<g_sma.sma53
              THEN
                 CALL cl_err('','mfg9999',0) NEXT FIELD snb022
              END IF
           END IF
 
        AFTER INPUT
           LET g_snb.snbuser = s_get_data_owner("snb_file") #FUN-C10039
           LET g_snb.snbgrup = s_get_data_group("snb_file") #FUN-C10039
           IF INT_FLAG THEN EXIT INPUT  END IF
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
 
        ON ACTION controlp
           CASE
             WHEN INFIELD(snb01)    #查詢符合條件的單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_sfb02"
                  LET g_qryparam.construct= "Y"
                  LET g_qryparam.default1 = g_snb.snb01
                  LET g_qryparam.arg1     = "234567"
                  CALL cl_create_qry() RETURNING g_snb.snb01
                  DISPLAY BY NAME g_snb.snb01
                  NEXT FIELD snb01
             OTHERWISE EXIT CASE
           END CASE
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
 
    END INPUT
 
END FUNCTION
 
 
FUNCTION t802_set_entry(p_cmd)
 DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' AND ( NOT g_before_input_done ) THEN
       CALL cl_set_comp_entry("snb01",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t802_set_no_entry(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND g_chkey = 'N' AND ( NOT g_before_input_done ) THEN
    CALL cl_set_comp_entry("snb01",FALSE)
    END IF
 
END FUNCTION
 
#Query 查詢
FUNCTION t802_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
    CLEAR FORM
   CALL g_sna.clear()
    CALL t802_cs()                    #取得查詢條件
    IF INT_FLAG THEN                  #使用者不玩了
       LET INT_FLAG = 0
       RETURN
    END IF
    OPEN t802_b_cs                    #從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
        INITIALIZE g_snb.snb01 TO NULL
    ELSE
        CALL t802_fetch('F')            #讀出TEMP第一筆並顯示
        OPEN t802_count
        FETCH t802_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
    END IF
END FUNCTION
 
#處理資料的讀取
FUNCTION t802_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數      #No.FUN-680121 INTEGER
 
    MESSAGE ""
    CASE p_flag
        WHEN 'N' FETCH NEXT     t802_b_cs INTO g_snb.snb01,g_snb.snb02
        WHEN 'P' FETCH PREVIOUS t802_b_cs INTO g_snb.snb01,g_snb.snb02
        WHEN 'F' FETCH FIRST    t802_b_cs INTO g_snb.snb01,g_snb.snb02
        WHEN 'L' FETCH LAST     t802_b_cs INTO g_snb.snb01,g_snb.snb02
        WHEN '/'
            IF (NOT g_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                   ON IDLE g_idle_seconds
                      CALL cl_on_idle()
 
                END PROMPT
                IF INT_FLAG THEN LET INT_FLAG = 0 EXIT CASE END IF
            END IF
            FETCH ABSOLUTE g_jump t802_b_cs INTO g_snb.snb01,g_snb.snb02
            LET g_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN                         #有麻煩
        CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)
        INITIALIZE g_snb.snb01 TO NULL            #No.FUN-6B0079 add
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
    SELECT * INTO g_snb.* FROM snb_file
     WHERE snb01 = g_snb.snb01
       AND snb02 = g_snb.snb02
 
    IF SQLCA.sqlcode THEN                         #有麻煩
       CALL cl_err3("sel","snb_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
       INITIALIZE g_snb.* TO NULL
    ELSE
       LET g_data_owner = g_snb.snbuser      #FUN-4C0035
       LET g_data_group = g_snb.snbgrup      #FUN-4C0035
       LET g_data_plant = g_snb.snbplant #FUN-980030
       CALL t802_show()
    END IF
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t802_show()
 
    DISPLAY BY NAME g_snb.snb04
    LET g_snb_t.* = g_snb.*
    DISPLAY BY NAME g_snb.snboriu,g_snb.snborig,
            g_snb.snb01,g_snb.snb02,g_snb.snb022,g_snb.snbconf,
            g_snb.snbuser,g_snb.snbgrup,g_snb.snbmodu,g_snb.snbdate
    CALL t802_snb01('d')
    CALL t802_b_fill(' 1=1')         #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION t802_snb01(p_cmd)
DEFINE
    p_cmd           LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_sfb02_d       LIKE type_file.chr6,          #No.FUN-680121 VARCHAR(6)
    l_sfb04_d       LIKE type_file.chr6,          #No.FUN-680121 VARCHAR(6)
    l_ima02         LIKE ima_file.ima02,
    l_imaacti       LIKE ima_file.imaacti,
    l_sfb    RECORD LIKE sfb_file.*
 
    LET g_errno = ''
    SELECT *  INTO g_sfb.* FROM sfb_file
     WHERE sfb01 = g_snb.snb01
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'asf-312'
                                   LET g_sfb.sfb05 = NULL
                                   LET g_sfb.sfbacti = NULL
         WHEN g_sfb.sfbacti='N'    LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
 
    IF cl_null(g_errno) AND NOT cl_null(g_sfb.sfb05) THEN
       SELECT imaacti INTO l_imaacti FROM ima_file
        WHERE ima01 = g_sfb.sfb05
       CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                      LET l_ima02 = NULL
                                      LET l_imaacti = NULL
            WHEN l_imaacti='N' LET g_errno = '9028'
            WHEN l_imaacti MATCHES '[PH]'       LET g_errno = '9038'
            OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
       END CASE
    END IF
 
    LET l_sfb02_d=t802_sfb02(g_sfb.sfb02)
    IF p_cmd = 'd' OR cl_null(g_errno) THEN
        DISPLAY BY NAME g_snb.snb02
        DISPLAY g_sfb.sfb05  TO FORMONLY.sfb05
        DISPLAY g_sfb.sfb02  TO FORMONLY.sfb02
        DISPLAY g_sfb.sfb08  TO FORMONLY.sfb08
        DISPLAY g_sfb.sfb09  TO FORMONLY.sfb09
        DISPLAY l_sfb02_d    TO FORMONLY.sfb02_d
    END IF
END FUNCTION
 
FUNCTION t802_sfb02(p_sfb02)
    DEFINE p_sfb02	LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_str	LIKE type_file.chr20         #No.FUN-680121 VARCHAR(10)
    DEFINE l_ze01       LIKE ze_file.ze01            #No.FUN-680121 VARCHAR(7)
     CASE WHEN p_sfb02 = 1 LET l_ze01="asf-841"
          WHEN p_sfb02 = 5 LET l_ze01="asf-842"
          WHEN p_sfb02 = 7 LET l_ze01="asf-843"
          WHEN p_sfb02 = 8 LET l_ze01="asf-856"
          WHEN p_sfb02 =11 LET l_ze01="asf-853"
          WHEN p_sfb02 =13 LET l_ze01="asf-844"
          WHEN p_sfb02 =15 LET l_ze01="asf-855"
     END CASE
       SELECT ze03 INTO l_zemsg FROM ze_file
          WHERE ze01 = l_ze01 AND ze02 = g_lang
       LET l_str = l_zemsg CLIPPED
    RETURN l_str
END FUNCTION
 
FUNCTION t802_sfb04(p_sfb04)
    DEFINE p_sfb04	LIKE type_file.num5          #No.FUN-680121 SMALLINT
    DEFINE l_str	LIKE type_file.chr20         #No.FUN-680121 VARCHAR(10)
    DEFINE l_ze01       LIKE ze_file.ze01            #No.FUN-680121 VARCHAR(7)
 
     CASE WHEN p_sfb04 ='1' LET l_ze01="asf-845"
          WHEN p_sfb04 ='2' LET l_ze01="asf-846"
          WHEN p_sfb04 ='3' LET l_ze01="asf-847"
          WHEN p_sfb04 ='4' LET l_ze01="asf-848"
          WHEN p_sfb04 ='5' LET l_ze01="asf-849"
          WHEN p_sfb04 ='6' LET l_ze01="asf-850"
          WHEN p_sfb04 ='7' LET l_ze01="asf-851"
          WHEN p_sfb04 ='8' LET l_ze01="asf-852"
     END CASE
       SELECT ze03 INTO l_zemsg FROM ze_file
          WHERE ze01 = l_ze01 AND ze02 = g_lang
       LET l_str = l_zemsg CLIPPED
    RETURN l_str
END FUNCTION
 
FUNCTION t802_r()
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_snb.snb01) THEN 
       CALL cl_err("",-400,0)                 #No.FUN-6B0079
       RETURN 
    END IF
    #----> 如為'已發出',不可取消
    IF g_snb.snbconf = 'Y' THEN
       CALL cl_err('','asf-242',0)
       RETURN
    END IF
    IF g_snb.snbconf = 'X' THEN
       CALL cl_err('','9024',0)
       RETURN
    END IF
    IF g_snb.snbconf = 'Y' THEN
       CALL cl_err('','asf-220',0)
       RETURN
    END IF
 
    BEGIN WORK
 
    OPEN t802_cl USING g_snb.snb01,g_snb.snb02
    IF STATUS THEN
       CALL cl_err("OPEN t802_cl:", STATUS, 1)
       CLOSE t802_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t802_cl INTO g_snb.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t802_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t802_show()
    IF cl_delh(0,0) THEN                   #確認一下
        INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
        LET g_doc.column1 = "snb01"         #No.FUN-9B0098 10/02/24
        LET g_doc.column2 = "snb02"         #No.FUN-9B0098 10/02/24
        LET g_doc.value1 = g_snb.snb01      #No.FUN-9B0098 10/02/24
        LET g_doc.value2 = g_snb.snb02      #No.FUN-9B0098 10/02/24
        CALL cl_del_doc()                #No.FUN-9B0098 10/02/24
         DELETE FROM snb_file WHERE snb01 = g_snb.snb01
                              AND snb02 = g_snb.snb02
         DELETE FROM sna_file WHERE sna01 = g_snb.snb01
                              AND sna02 = g_snb.snb02
         DELETE FROM snc_file WHERE snc01 = g_snb.snb01
                              AND snc02 = g_snb.snb02
         INITIALIZE g_snb.* TO NULL
         CLEAR FORM
         CALL g_sna.clear()
         CALL g_sna.clear()
         CALL g_sfa29.clear()
         INSERT INTO azo_file(azo01,azo02,azo03,azo04,azo05,azo06,azoplant,azolegal)  #FUN-980008 add
         VALUES ('asft802',g_user,g_today,g_msg,g_snb.snb01,'delete',g_plant,g_legal) #FUN-980008 add
         OPEN t802_count
         #FUN-B50064-add-start--
         IF STATUS THEN
            CLOSE t802_cl  
            CLOSE t802_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         FETCH t802_count INTO g_row_count
         #FUN-B50064-add-start--
         IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
            CLOSE t802_cl  
            CLOSE t802_count
            COMMIT WORK
            RETURN
         END IF
         #FUN-B50064-add-end-- 
         DISPLAY g_row_count TO FORMONLY.cnt
         OPEN t802_b_cs
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL t802_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET g_no_ask = TRUE
            CALL t802_fetch('/')
         END IF
    END IF
    COMMIT WORK
    LET g_snb.snb04 = '2'
    DISPLAY BY NAME g_snb.snb04
END FUNCTION
 
#單身
FUNCTION t802_b()
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_lock_sw       LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    p_cmd           LIKE type_file.chr1,                #處理狀態          #No.FUN-680121 VARCHAR(1)
    l_i             LIKE type_file.num5,                #No.FUN-680121 SMALLINT
    l_ratio         LIKE sna_file.sna05b,
    l_code          LIKE type_file.num5,                #No.FUN-680121 SMALLINT
    l_sfa16         LIKE sfa_file.sfa16,
    l_sna04         LIKE sna_file.sna04,
    l_sna06a        LIKE sna_file.sna06a,
    l_sna07a        LIKE sna_file.sna07a,
    l_sna062a       LIKE sna_file.sna062a,
    l_sna161a       LIKE sna_file.sna161a,
    l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
    l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
DEFINE  l_case      STRING                              #FUN-910088--add--
 
    LET g_action_choice = ""
    IF s_shut(0) THEN RETURN END IF
    IF cl_null(g_snb.snb01) THEN RETURN END IF
    IF g_snb.snb04='1' THEN CALL cl_err('','asf-062',1) RETURN END IF
    IF g_snb.snbconf ='X' THEN    #檢查資料是否為無效
       CALL cl_err(g_snb.snb01,'aom-000',0) RETURN
    END IF
    IF g_snb.snbconf = 'Y' THEN
       CALL cl_err('','asf-061',0) RETURN
    END IF
 
    CALL cl_opmsg('b')
 
 
    LET g_forupd_sql = "SELECT * FROM sna_file",
                       " WHERE sna01 = ? AND sna02 = ? AND sna04 = ? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE t802_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
    LET l_allow_insert = cl_detail_input_auth("insert")
    LET l_allow_delete = cl_detail_input_auth("delete")
 
    IF g_rec_b=0 THEN CALL g_sna.clear() END IF
 
    INPUT ARRAY g_sna WITHOUT DEFAULTS FROM s_sna.*
 
          ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
        BEFORE ROW
            LET p_cmd = ''
            LET l_ac = ARR_CURR()
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_n  = ARR_COUNT()
            CALL t802_set_no_required()    #TQC-C50155 add
            CALL t802_set_required()       #TQC-C50155 add
 
            BEGIN WORK
 
            OPEN t802_cl USING g_snb.snb01,g_snb.snb02
            IF STATUS THEN
               CALL cl_err("OPEN t802_cl:", STATUS, 1)
               CLOSE t802_cl
               ROLLBACK WORK
               RETURN
            ELSE
               FETCH t802_cl INTO g_snb.*     #鎖住將被更改或取消的資料
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0) # 資料被他人LOCK
                  CLOSE t802_cl
                  ROLLBACK WORK
                  RETURN
               END IF
            END IF
 
            IF g_rec_b >= l_ac THEN
               LET p_cmd='u'
               LET g_sna_t.* = g_sna[l_ac].*  #BACKUP
               LET g_sna12a_t = NULL          #FUN-910088--add--
               OPEN t802_bcl USING g_snb.snb01,g_snb.snb02,g_sna_t.sna04
               IF STATUS THEN
                  CALL cl_err("OPEN t802_bcl:", STATUS, 1)
                  LET l_lock_sw = "Y"
               ELSE
                  FETCH t802_bcl INTO b_sna.*
                  IF SQLCA.sqlcode THEN
                     CALL cl_err(g_sna_t.sna04,SQLCA.sqlcode,1)
                     LET l_lock_sw = "Y"
                  ELSE
                     CALL t802_move_tmp()
                     LET g_sna[l_ac].ima02b = t802_sna03(p_cmd,g_sna[l_ac].sna03b)
                     LET g_sna[l_ac].ima02a = t802_sna03(p_cmd,g_sna[l_ac].sna03a)
                  END IF
               END IF
               CALL cl_show_fld_cont()     #FUN-550037(smin)
            END IF
 
 
        BEFORE INSERT
            LET p_cmd = 'a'
            LET l_n = ARR_COUNT()
            INITIALIZE g_sna[l_ac].* TO NULL      #900423
            LET g_sna[l_ac].sna08a = ' '          #No.TQC-690123 add
            LET g_sna_t.* = g_sna[l_ac].*         #新輸入資料
            LET g_sna12a_t = g_sna[l_ac].sna12a   #FUN-910088--add--
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sna10
 
        AFTER INSERT
            IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              INITIALIZE g_sna[l_ac].* TO NULL  #重要欄位空白,無效
              DISPLAY g_sna[l_ac].* TO s_sna.*
              CALL g_sna.deleteElement(g_rec_b+1)
              ROLLBACK WORK
              EXIT INPUT
            END IF
 
            #TQC-C50155--mark--str--
            #IF cl_null(g_sna[l_ac].sna26a) AND g_sna[l_ac].sna10 = '1' THEN
            #  NEXT FIELD sna26a            
            #END IF
            #IF cl_null(g_sna[l_ac].sna28a) AND g_sna[l_ac].sna10 = '1' THEN
            #  NEXT FIELD sna28a          
            #END IF
            #IF g_sna[l_ac].sna10 = '1' AND cl_null(g_sna[l_ac].sna05a) THEN
            #  NEXT FIELD sna05a           
            #END IF
            #TQC-C50155--mark--end--
 
            CALL t802_tmp_move()
            #TQC-C50155--add--str--
            LET b_sna.snaplant = g_plant 
            LET b_sna.snalegal = g_legal 
            #TQC-C50155--add--end--
 
            INSERT INTO sna_file VALUES(b_sna.*)
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","sna_file",b_sna.sna01,b_sna.sna02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
               ROLLBACK WORK
               CANCEL INSERT
            ELSE
               MESSAGE 'INSERT O.K'
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
 
              #同組的SET替代料是否一併變更(Y/N)?
               IF g_sna[l_ac].sna26b ='T' AND
                  g_sna[l_ac].sna05a > 0  THEN
                  IF cl_confirm('asf-074') THEN
                     LET l_ratio = g_sna[l_ac].sna05a/g_sna[l_ac].sna05b
                     IF cl_null(l_ratio) THEN
                        LET l_ratio = 1
                     END IF
                     LET l_ac_t = l_ac
                     CALL t802_b_subset(l_ratio,g_sfa29[l_ac],g_sna[l_ac].sna03b)
                     IF g_success = 'Y' THEN
                        COMMIT WORK
                        CALL cl_cmmsg(1)
                        CALL t802_b_fill(' 1=1')
                     ELSE
                        ROLLBACK WORK
                        CALL cl_rbmsg(1)
                     END IF
                  END IF
               END IF
            END IF
 
 
        BEFORE FIELD sna10
           CALL t802_set_entry_b(p_cmd)
           CALL t802_set_no_required()    #TQC-C50155 add
           
 
        AFTER FIELD sna10
           IF g_sna[l_ac].sna10 NOT MATCHES '[12]' THEN
              NEXT FIELD sna10
           END IF
           LET g_sna[l_ac].desc = t802_sna10(g_sna[l_ac].sna10)
           CALL t802_set_no_entry_b(p_cmd)
           CALL t802_set_required()       #TQC-C50155 add
 
        BEFORE FIELD sna04
 
            IF p_cmd = 'a' AND cl_null(g_sna[l_ac].sna04) THEN
               SELECT MAX(sna04)+1 INTO g_sna[l_ac].sna04 FROM sna_file
                WHERE sna01=g_snb.snb01
                  AND sna02=g_snb.snb02
               IF cl_null(g_sna[l_ac].sna04) THEN
                  LET g_sna[l_ac].sna04 = 1
               END IF
            END IF
 
        AFTER FIELD sna04
            IF NOT cl_null(g_sna[l_ac].sna04)  THEN   # 重要欄位不可空白
               #-->是否有重複輸入項次
               IF p_cmd = "a" OR                     # 若輸入或更改且改KEY
                 (p_cmd = "u" AND g_sna[l_ac].sna04 != g_sna_t.sna04) THEN
                   SELECT COUNT(*) INTO l_n FROM sna_file
                    WHERE sna01 = g_snb.snb01
                      AND sna02 = g_snb.snb02
                      AND sna04 = g_sna[l_ac].sna04
                   IF l_n > 0 THEN                   # Duplicated
                       CALL cl_err(g_sna[l_ac].sna04,-239,0)
                       LET g_sna[l_ac].sna04 = g_sna_t.sna04
                       NEXT FIELD sna04
                   END IF
               END IF
               IF g_sna[l_ac].sna10 = '1' AND p_cmd = 'a' THEN   #新增
                  LET g_sna[l_ac].sna27b = NULL
                  LET g_sna[l_ac].sna03b = NULL
                  LET g_sna[l_ac].sna08b = NULL
                  LET g_sna[l_ac].sna11b = NULL
                  LET g_sna[l_ac].sna12b = NULL
                  LET g_sna[l_ac].sna13b = NULL
                  LET g_sna[l_ac].sna100b= NULL
                  LET g_sna[l_ac].sna26b = NULL   
                  LET g_sna[l_ac].sna28b = NULL   
                  LET g_sna[l_ac].sna161b= NULL
                  LET g_sna[l_ac].sna05b = 0
                  LET g_sna[l_ac].sna062b= 0
                  LET g_sna[l_ac].sna06b = 0
                  LET g_sna[l_ac].sna07b = 0
                  LET g_sna[l_ac].sna065b= 0
                  LET g_sna[l_ac].sna05a = 0
                  LET g_sna[l_ac].sna06a = 0
                  LET g_sna[l_ac].sna062a= 0
                  LET g_sna[l_ac].sna065a= 0
                  LET g_sna[l_ac].sna07a = 0
                  LET g_sna[l_ac].sna08a = ''
                  LET g_sna[l_ac].sna11a = 'N'
                  LET g_sna[l_ac].sna100a= 0
                  LET g_sna[l_ac].sna28a = 1
               END IF
               IF g_sna[l_ac].sna10 = '2' THEN  #修改
                  #檢查是否已將舊資料帶出
                  IF cl_null(g_sna[l_ac].sna03b) OR
                     g_sna[l_ac].sna08b IS NULL  OR
                     cl_null(g_sna[l_ac].sna12b) THEN
                     CALL cl_err('','asf1029',0)        #TQC-C50155 add
                     NEXT FIELD sna04
                  ELSE
                     #檢查欲修改的資料是否重覆
                     IF g_sna_t.sna04 IS NULL THEN
                        LET l_sna04 = g_sna[l_ac].sna04
                     ELSE
                        LET l_sna04 = g_sna_t.sna04
                     END IF
                     SELECT count(*) INTO l_n FROM sna_file
                      WHERE sna01 =g_snb.snb01
                        AND sna02 = g_snb.snb02
                        AND sna03b=g_sna[l_ac].sna03b
                        AND sna08b=g_sna[l_ac].sna08b
                        AND sna12b=g_sna[l_ac].sna12b
                        AND sna04 != l_sna04
                     IF l_n > 0 THEN
                        CALL cl_err('',-239,1) NEXT FIELD sna04
                     END IF
                   END IF
               END IF
            END IF
 
       AFTER FIELD sna27a
            IF NOT cl_null(g_sna[l_ac].sna27a) THEN
#FUN-AA0059 ---------------------start----------------------------
               IF NOT s_chk_item_no(g_sna[l_ac].sna27a,"") THEN
                  CALL cl_err('',g_errno,1)
                  LET g_sna[l_ac].sna27a= g_sna_t.sna27a
                  NEXT FIELD sna27a
               END IF
#FUN-AA0059 ---------------------end-------------------------------
               LET g_sna[l_ac].ima02a = t802_sna03(p_cmd,g_sna[l_ac].sna27a)
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err('sel ima',g_errno,0) NEXT FIELD sna27a
               END IF
 
               IF g_ima.ima70='Y' THEN
                  LET g_sna[l_ac].sna11a ='E'
                  DISPLAY BY NAME g_sna[l_ac].sna11a
               END IF
 
               INITIALIZE g_bmb.* TO NULL
 
               DECLARE t802_bmb_c CURSOR FOR
                SELECT * INTO g_bmb.* FROM bmb_file,sfb_file
                 WHERE bmb01=g_sfb.sfb05      #MOD-970134 add
                   AND bmb03=g_sna[l_ac].sna27a
                   AND (bmb04<=g_sfb.sfb071 OR bmb04 IS NULL)
                   AND (g_sfb.sfb071<bmb05 OR bmb05 IS NULL)
 
               FOREACH t802_bmb_c INTO g_bmb.*
                 IF STATUS THEN
                    CALL cl_err('for bmb:',STATUS,1)   
                    EXIT FOREACH
                 END IF
                 EXIT FOREACH		# 僅讀取第一筆
               END FOREACH
 
              #檢查是否存在BOM中
               LET g_errno = ''
               IF cl_null(g_bmb.bmb03) AND g_sfb.sfb02 NOT MATCHES '[58]' THEN
                  IF g_sfb.sfb02=15 THEN
                     CALL s_ebomchk(g_sfb.sfb05,g_sna[l_ac].sna27a,g_sfb.sfb07)
                          RETURNING g_bmb.*,g_errno
                  ELSE
                     CALL i301_bom_check(g_sfb.sfb05,g_sna[l_ac].sna27a,
                                         g_sfb.sfb071)
                          RETURNING g_bmb.*,g_errno
                  END IF
               END IF
 
               IF NOT cl_null(g_errno) THEN
                  IF g_sma.sma887[1]='Y' THEN
                     CALL cl_err('',g_errno,0) NEXT FIELD sna27a
                  END IF
                  IF g_sma.sma887[1]='W' THEN
                     CALL cl_err('',g_errno,0)
                  END IF
               END IF
               LET l_n=0
               IF NOT cl_null(g_sfb.sfb22) THEN
                  SELECT COUNT(*) INTO l_n FROM oeo_file
                    WHERE oeo01=g_sfb.sfb22 AND oeo03=g_sfb.sfb221
                      AND oeo04=g_sna[l_ac].sna27a
                      AND oeo08='1' #no.7168
               END IF
               IF g_sfb.sfb02<>5 AND g_sfb.sfb02<>7 AND
                  cl_null(g_bmb.bmb01) AND l_n=0 THEN
                  IF g_sma.sma887[1]='Y' THEN
                     CALL cl_err('sel bmb:','mfg2631',0) NEXT FIELD sna27a
                  END IF
                  IF g_sma.sma887[1]='W' THEN
                     IF NOT cl_confirm('mfg2632') THEN NEXT FIELD sna27a END IF
                  END IF
               END IF
               IF cl_null(g_sna[l_ac].sna26a) AND NOT cl_null(g_bmb.bmb16) THEN
                  LET g_sna[l_ac].sna26a = g_bmb.bmb16
                  LET l_sfa16            = g_bmb.bmb06/g_bmb.bmb07*
                                           (1+g_bmb.bmb08/100)
                  LET g_sna[l_ac].sna161a= l_sfa16
                  LET g_sna[l_ac].sna12a = g_bmb.bmb10
                  LET g_sna[l_ac].sna13a = g_bmb.bmb10_fac
                  DISPLAY BY NAME g_sna[l_ac].sna26a
                  DISPLAY BY NAME g_sna[l_ac].sna161a
                  DISPLAY BY NAME g_sna[l_ac].sna12a
                  DISPLAY BY NAME g_sna[l_ac].sna13a
               END IF
               IF cl_null(g_sna[l_ac].sna12a) THEN
                  LET g_sna[l_ac].sna12a = g_ima.ima63
                  LET g_sna[l_ac].sna13a = g_ima.ima63_fac
                  DISPLAY BY NAME g_sna[l_ac].sna12a
                  DISPLAY BY NAME g_sna[l_ac].sna12a
               END IF
               IF g_sna[l_ac].sna10='1' THEN
                  LET g_sna[l_ac].sna03a = g_sna[l_ac].sna27a
                  DISPLAY BY NAME g_sna[l_ac].sna03a
               END IF
          #FUN-910088--add--start--
               LET l_case = NULL
               IF NOT cl_null(g_sna[l_ac].sna05a) AND g_sna[l_ac].sna05a != 0 THEN
                  CASE t802_sna05a_check() 
                     WHEN "sna05a"
                        LET l_case = "sna05a"
                     WHEN "sna30a"
                        LET l_case ="sna30a"
                     OTHERWISE EXIT CASE
                  END CASE 
               END IF
               IF NOT cl_null(g_sna[l_ac].sna065a) AND g_sna[l_ac].sna065a != 0 THEN
                  IF NOT t802_sna065a_check() THEN
                     LET l_case = "sna065a"
                  END IF
               END IF
               CALL t802_sna06a_check() 
               LET g_sna12a_t = g_sna[l_ac].sna12a
               CASE l_case
                  WHEN "sna05a"
                     NEXT FIELD sna05a
                  WHEN "sna30a"
                     NEXT FIELD sna30a
                  WHEN "sna065a"
                     NEXT FIELD sna065a
                  OTHERWISE
                     EXIT CASE
               END CASE
          #FUN-910088--add--end--
            END IF
 
        AFTER FIELD sna08a
            IF NOT cl_null(g_sna[l_ac].sna08a) THEN
               SELECT COUNT(*) INTO g_cnt FROM ecd_file
                WHERE ecd01=g_sna[l_ac].sna08a
               IF g_cnt=0 THEN
                  CALL cl_err('sel ecd_file',100,0)
                  NEXT FIELD sna08a
               END IF
            ELSE
               IF g_sna[l_ac].sna08a IS NULL THEN
                  LET g_sna[l_ac].sna08a=' '
               END IF
            END IF
 
        AFTER FIELD sna11a
 
            IF NOT cl_null(g_sna[l_ac].sna11a) THEN
               IF g_sna[l_ac].sna11a NOT MATCHES '[NEVUR]' THEN
                  NEXT FIELD sna11a
               END IF
               IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN    #No.TQC-690123 add
                  IF g_sna[l_ac].sna11a = g_sna[l_ac].sna11b THEN
                     LET  g_sna[l_ac].sna11a=null
                     CALL cl_err('','axm-327',0)
                     NEXT FIELD sna11a
                  END IF
               END IF         #No.TQC-690123 add
            END IF
 
        #--->單位需存在於單位檔中
        AFTER FIELD sna12a
            #採購單位,須存在
             IF NOT cl_null(g_sna[l_ac].sna12a) THEN
                CALL t802_unit(g_sna[l_ac].sna12a)   #是否存在於單位檔中
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_sna[l_ac].sna12a,g_errno,0)
                   LET g_sna[l_ac].sna12a = g_sna_t.sna12a
                   DISPLAY BY NAME g_sna[l_ac].sna12a
                   NEXT FIELD sna12a
                END IF
                #檢查單身資料是否重覆
                SELECT count(*) INTO l_n FROM sna_file
                 WHERE sna01=g_snb.snb01        AND sna03a=g_sna[l_ac].sna03a
                   AND sna08=g_sna[l_ac].sna08a AND sna12a=g_sna[l_ac].sna12a
                   AND sna04 !=g_sna[l_ac].sna04 AND sna02 =g_snb.snb02
                IF l_n > 0 THEN
                   CALL cl_err('',-239,1) NEXT FIELD sna04
                END IF
                #檢查資料是否在工單中已重覆
                IF g_sna_t.sna27a IS NULL
                   OR g_sna_t.sna27a != g_sna[l_ac].sna27a THEN
                   SELECT count(*) INTO l_n FROM sfa_file
                    WHERE sfa01=g_snb.snb01        AND sfa03=g_sna[l_ac].sna03a
                      AND sfa08=g_sna[l_ac].sna08a AND sfa12=g_sna[l_ac].sna12a
                      AND sfa27=g_sna[l_ac].sna27a #No.FUN-870051 
                   IF l_n > 0 THEN
                       CALL cl_err('','asf-200',1) NEXT FIELD sna04
                   END IF
                END IF
                CALL s_umfchk(g_sna[l_ac].sna03a,g_sna[l_ac].sna12a,
                              g_ima.ima25)
                              RETURNING l_n,g_sna[l_ac].sna13a
                DISPLAY BY NAME g_sna[l_ac].sna13a
                IF l_n = 1 THEN
                   CALL cl_err('','mfg3075',0) NEXT FIELD sna12a
                END IF
                IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN    #No.TQC-690123 add
                   IF g_sna[l_ac].sna12a = g_sna[l_ac].sna12b THEN
                      LET  g_sna[l_ac].sna12a=null
                      CALL cl_err('','axm-327',0)
                      NEXT FIELD sna12a
                   END IF
                END IF      #No.TQC-690123  add
          #FUN-910088--add--start--
                LET l_case = NULL
                IF NOT cl_null(g_sna[l_ac].sna05a) AND g_sna[l_ac].sna05a != 0 THEN
                   CASE t802_sna05a_check() 
                      WHEN "sna05a"
                         LET l_case = "sna05a"
                      WHEN "sna30a"
                         LET l_case = "sna30a"
                      OTHERWISE EXIT CASE
                   END CASE
                END IF
                IF NOT cl_null(g_sna[l_ac].sna065a) AND g_sna[l_ac].sna065a != 0 THEN
                   IF NOT t802_sna065a_check() THEN
                      LET l_case = "sna065a"
                   END IF
                END IF
                CALL t802_sna06a_check() 
                LET g_sna12a_t = g_sna[l_ac].sna12a
                CASE l_case
                   WHEN "sna05a"
                      NEXT FIELD sna05a
                   WHEN "sna30a"
                      NEXT FIELD sna30a
                   WHEN "sna065a"
                      NEXT FIELD sna065a
                   OTHERWISE
                      EXIT CASE
                END CASE
          #FUN-910088--add--end--
             END IF
 
        BEFORE FIELD sna26a
            CALL t802_set_entry_b(p_cmd)
 
        AFTER FIELD sna26a
             IF NOT cl_null(g_sna[l_ac].sna26a) THEN
               IF NOT cl_null (g_sna[l_ac].sna26a) THEN
                  IF g_sna[l_ac].sna26a NOT MATCHES '[0125]' THEN
                     NEXT FIELD sna26a
                  END IF
               END IF
               IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN    #No.TQC-690123 add
                  IF g_sna[l_ac].sna26a = g_sna[l_ac].sna26b THEN
                     LET  g_sna[l_ac].sna26a=null
                     CALL cl_err('','axm-327',0)
                     NEXT FIELD sna26a
                  END IF
               END IF      #No.TQC-690123  add
            END IF
            CALL t802_set_no_entry_b(p_cmd)
 
        AFTER FIELD sna28a
            IF NOT cl_null(g_sna[l_ac].sna28a) THEN
               IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN    #No.TQC-690123 add
                  IF g_sna[l_ac].sna28a = g_sna[l_ac].sna28b THEN
                     LET  g_sna[l_ac].sna28a=null
                     CALL cl_err('','axm-327',0)
                     NEXT FIELD sna28a
                  END IF
                  IF g_sna[l_ac].sna28a <=0 THEN                                                                                    
                     LET g_sna[l_ac].sna28a=null                                                                                    
                     CALL cl_err('','afa-949',0)                                                                                    
                     NEXT FIELD sna28a                                                                                              
                  END IF                                                                                                            
               END IF      #No.TQC-690123  add
            END IF
 
        AFTER FIELD sna05a
        #FUN-910088--add-start--
           CASE t802_sna05a_check()                     
              WHEN "sna05a"
                 NEXT FIELD sna05a
              WHEN "sna30a"
                 NEXT FIELD sna30a
              OTHERWISE EXIT CASE
           END CASE
       #FUN-910088--add--end--
       #FUN-910088--mark--start--
       #    IF NOT cl_null(g_sna[l_ac].sna05a) THEN
       #       IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN    #No.TQC-690123 add
       #          IF g_sna[l_ac].sna05b=g_sna[l_ac].sna05a THEN
       #             CALL cl_err('','asf-054',0)
       #             NEXT FIELD sna05a
       #          END IF
       #       END IF      #No.TQC-690123  add
       #       IF g_sna[l_ac].sna05a<0 AND g_sfb.sfb02 NOT MATCHES '[58]' THEN
       #          CALL cl_err('','asf-678',0)
       #          NEXT FIELD sna05a
       #       END IF
       #       CALL t802_sna05a()
       #       IF NOT cl_null(g_errno) THEN
       #          CALL cl_err('',g_errno,0)
       #          LET g_sna[l_ac].sna05a=g_sna_t.sna05a
       #          DISPLAY g_sna[l_ac].sna05a TO s_sna[l_ac].sna05a
       #          NEXT FIELD sna05a
       #       END IF
       #       IF g_sna_t.sna05a IS NULL
       #          OR g_sna[l_ac].sna05a!=g_sna_t.sna05a THEN
       #          IF g_sna[l_ac].sna26a NOT MATCHES '[SU]' THEN
       #             LET g_sna[l_ac].sna161a=g_sna[l_ac].sna05a/g_sfb.sfb08
       #          END IF
       #          IF NOT cl_null(g_sna[l_ac].sna05b) THEN
       #             CALL t802_cal_qty(g_sna[l_ac].sna05b,g_sna[l_ac].sna05a,
       #                               g_sna[l_ac].sna06b,g_sna[l_ac].sna062b,
       #                               g_sna[l_ac].sna07b,g_sna[l_ac].sna065b)   #No.MOD-930172 add
       #                              #g_sna[l_ac].sna07b)                       #No.MOD-930172 mark
       #                RETURNING l_sna06a,l_sna062a,
       #                          l_sna07a,l_sna161a
       #             IF cl_null(g_errno) THEN
       #                LET g_sna[l_ac].sna06a  = l_sna06a
       #                LET g_sna[l_ac].sna07a  = l_sna07a
       #                LET g_sna[l_ac].sna062a = l_sna062a
       #                LET g_sna[l_ac].sna161a = l_sna161a
       #             ELSE
       #                CALL cl_err('',g_errno,0)
       #                NEXT FIELD sna05a
       #             END IF
       #          END IF
       #       END IF
       #   ELSE
       #       LET g_sna[l_ac].sna06a  = ''
       #       LET g_sna[l_ac].sna07a  = ''
       #       LET g_sna[l_ac].sna062a = ''
       #       LET g_sna[l_ac].sna161a = ''
       #    END IF
       #    IF g_sna[l_ac].sna10 MATCHES  '[23]' THEN
       #       NEXT FIELD sna30a
       #    END IF
       #    DISPLAY BY NAME g_sna[l_ac].sna06a
       #    DISPLAY BY NAME g_sna[l_ac].sna07a
       #    DISPLAY BY NAME g_sna[l_ac].sna062a
       #    DISPLAY BY NAME g_sna[l_ac].sna161a
       #FUN-910088--mark--end--
 
    #FUN-910088--add--start--
        AFTER FIELD sna06a
           CALL t802_sna06a_check() 
    #FUN-910088--add--end--       

        AFTER FIELD sna30a
           IF NOT cl_null(g_sna[l_ac].sna30a) THEN
              SELECT * FROM imd_file
               WHERE imd01=g_sna[l_ac].sna30a
                  AND imdacti = 'Y' #MOD-4B0169
              IF STATUS THEN
                 CALL cl_err3("sel","imd_file",g_sna[l_ac].sna30a,"","mfg1100","","imd:",1)  #No.FUN-660128
                  NEXT FIELD sna30a  
              END IF
 #------>check-1
                 IF NOT s_imfchk1(g_sna[l_ac].sna27a,g_sna[l_ac].sna30a)
                    THEN CALL cl_err(g_sna[l_ac].sna30a,'mfg9036',0)
                         NEXT FIELD sna30a
                 END IF
 #------>check-2
                 CALL s_stkchk(g_sna[l_ac].sna30a,'A') RETURNING l_code
                 IF NOT l_code THEN
                     CALL cl_err(g_sna[l_ac].sna30a,'mfg1100',0)
                     NEXT FIELD sna30a
                 END IF
              #Add No.FUN-AB0044
              IF NOT s_chk_ware(g_sna[l_ac].sna30a) THEN  #检查仓库是否属于当前门店
                 NEXT FIELD sna30a
              END IF
              #End Add No.FUN-AB0044
           END IF
           IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN    #No.TQC-690123 add
              IF g_sna[l_ac].sna30a = g_sna[l_ac].sna30b THEN
                 LET  g_sna[l_ac].sna30a=null
                 CALL cl_err('','axm-327',0)
                 NEXT FIELD sna30a
              END IF
           END IF      #No.TQC-690123  add 
 
        AFTER FIELD sna31a
           IF g_sna[l_ac].sna10 MATCHES  '[23]' THEN
              IF g_sfb.sfb02 MATCHES '[78]' THEN
                 NEXT FIELD sna065a
              ELSE
                 NEXT FIELD sna50
              END IF
           END IF
 
           IF NOT cl_null(g_sna[l_ac].sna31a) THEN
              IF NOT s_imfchk(g_sna[l_ac].sna27a,g_sna[l_ac].sna30a,
                              g_sna[l_ac].sna31a) THEN
                 CALL cl_err(g_sna[l_ac].sna31a,'mfg6095',0)
                 NEXT FIELD sna31a
              END IF
           END IF
 
           IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN    #No.TQC-690123 add
              IF g_sna[l_ac].sna31a = g_sna[l_ac].sna31b THEN
                 LET  g_sna[l_ac].sna31a=null
                 CALL cl_err('','axm-327',0)
                 NEXT FIELD sna31a
              END IF
           END IF      #No.TQC-690123  add
 
        AFTER FIELD sna065a
           IF NOT t802_sna065a_check() THEN NEXT FIELD sna065a END IF   #FUN-910088--add--
        #FUN-910088--mark--start--
        #  IF g_sna[l_ac].sna10 MATCHES  '[23]' THEN
        #     NEXT FIELD sna50
        #  END IF
        #  IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN    #No.TQC-690123 add
        #     IF g_sna[l_ac].sna065a = g_sna[l_ac].sna065b THEN
        #        LET  g_sna[l_ac].sna065a=null
        #        CALL cl_err('','axm-327',0)
        #        NEXT FIELD sna065a
        #     END IF
        #  END IF      #No.TQC-690123  add
        #FUN-910088--mark--end--
 
        AFTER FIELD sna50

        BEFORE DELETE                            #是否取消單身
            IF g_sna_t.sna04 > 0 AND
               g_sna_t.sna04 IS NOT NULL THEN
                IF NOT cl_delb(0,0) THEN
                   CANCEL DELETE
                END IF
 
                IF l_lock_sw = "Y" THEN
                   CALL cl_err("", -263, 1)
                   CANCEL DELETE
                END IF
 
                DELETE FROM sna_file
                 WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
                   AND sna04 = g_sna_t.sna04
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","sna_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
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
               LET g_sna[l_ac].* = g_sna_t.*
               CLOSE t802_bcl
               ROLLBACK WORK
               EXIT INPUT
            END IF
 
            IF l_lock_sw = 'Y' THEN
               CALL cl_err(g_sna[l_ac].sna10,-263,1)
               LET g_sna[l_ac].* = g_sna_t.*
            ELSE
                #TQC-C50155--mark--str--
                #IF cl_null (g_sna[l_ac].sna26a) AND g_sna[l_ac].sna10 = '1' THEN
                #   NEXT FIELD sna26a
                #END IF
                #IF cl_null(g_sna[l_ac].sna28a) AND g_sna[l_ac].sna10 = '1' THEN
                #  NEXT FIELD sna28a
                #END IF
                #IF g_sna[l_ac].sna10 = '1' AND cl_null(g_sna[l_ac].sna05a) THEN
                #   NEXT FIELD sna05a
                #END IF
                #TQC-C50155--mark--end--
 
                CALL t802_tmp_move()
 
                UPDATE sna_file SET * = b_sna.*
                 WHERE sna01 = g_snb.snb01
                   AND sna02 = g_snb.snb02
                   AND sna04 = g_sna_t.sna04
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd","sna_file",g_snb.snb01,g_snb.snb02,SQLCA.sqlcode,"","",1)  #No.FUN-660128
                   LET g_sna[l_ac].* = g_sna_t.*
                   ROLLBACK WORK
                ELSE
                   MESSAGE 'UPDATE O.K'
                   COMMIT WORK
                END IF
 
            END IF
 
        AFTER ROW
            LET l_ac = ARR_CURR()
           #LET l_ac_t = l_ac     #FUN-D40030 Mark
            IF INT_FLAG THEN
               CALL cl_err('',9001,0)
               LET INT_FLAG = 0
               IF p_cmd='u' THEN
                  LET g_sna[l_ac].* = g_sna_t.*
               #FUN-D40030--add--str--
               ELSE
                  CALL g_sna.deleteElement(l_ac)
                  IF g_rec_b != 0 THEN
                     LET g_action_choice = "detail"
                     LET l_ac = l_ac_t
                  END IF
               #FUN-D40030--add--end--
               END IF
               CLOSE t802_bcl
               ROLLBACK WORK
              #CALL g_sna.deleteElement(g_rec_b+1) #TQC-C50155   #FUN-D40030 Mark
               EXIT INPUT
            END IF
            LET l_ac_t = l_ac     #FUN-D40030 Add
            CLOSE t802_bcl
            COMMIT WORK
            #CALL g_sna.deleteElement(g_rec_b+1) #TQC-C50155
 
        ON ACTION controlp
           CASE                        #查詢符合條件的料號
             WHEN INFIELD(sna04)
                  IF p_cmd = 'a' AND g_sna[l_ac].sna10 = '2' THEN
                     CALL cl_init_qry_var()
                     LET g_qryparam.form     = "q_sfa4"   #No.MOD-930172 add
                     LET g_qryparam.arg1     = g_snb.snb01
                     CALL cl_create_qry()
                     RETURNING g_sna[l_ac].sna27b,        #No.MOD-930172 add
                               g_sna[l_ac].sna08b,        #No.MOD-930172 add
                               g_sna[l_ac].sna03b,
                               g_sna[l_ac].sna12b
                     IF g_sna[l_ac].sna08b IS NULL THEN
                       LET g_sna[l_ac].sna08b = ' '
                     END IF
                     CALL t802_sna27(g_sna[l_ac].sna03b,g_sna[l_ac].sna08b,
                                     g_sna[l_ac].sna12b,g_sna[l_ac].sna27b) #No.FUN-870051
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err('',g_errno,1)
                     END IF
                     NEXT FIELD sna04
                  END IF
             WHEN INFIELD(sna27a)
#FUN-AA0059---------mod------------str-----------------             
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form     = "q_ima"
#                  LET g_qryparam.default1 = g_sna[l_ac].sna27a
#                  CALL cl_create_qry() RETURNING g_sna[l_ac].sna27a
                  CALL q_sel_ima(FALSE, "q_ima","",g_sna[l_ac].sna27a,"","","","","",'' ) 
                       RETURNING  g_sna[l_ac].sna27a
#FUN-AA0059---------mod------------end-----------------
                  LET g_sna[l_ac].ima02a = t802_sna03('d',g_sna[l_ac].sna27a)
                  NEXT FIELD sna27a
             WHEN INFIELD(sna08a)
                  CALL q_ecd( FALSE, TRUE,g_sna[l_ac].sna08a) RETURNING g_sna[l_ac].sna08a
                  NEXT FIELD sna08a
             WHEN INFIELD(sna12a)
                  CALL cl_init_qry_var()
                  LET g_qryparam.form     = "q_gfe"
                  LET g_qryparam.default1 = g_sna[l_ac].sna12a
                  CALL cl_create_qry() RETURNING g_sna[l_ac].sna12a
                  NEXT FIELD sna12a
             WHEN INFIELD(sna30a)
                 #Mod No.FUN-AB0044
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_imd"
                 #LET g_qryparam.default1 = g_sna[l_ac].sna30a
                 #LET g_qryparam.arg1     = 'SW'        #倉庫類別 #MOD-4A0213
                 #CALL cl_create_qry() RETURNING g_sna[l_ac].sna30a
                  CALL q_imd_1(FALSE,TRUE,g_sna[l_ac].sna30a,"",g_plant,"","")  #只能开当前门店的
                       RETURNING g_sna[l_ac].sna30a
                 #End Mod No.FUN-AB0044
                  NEXT FIELD sna30a
             WHEN INFIELD(sna31a)
                 #Mod No.FUN-AB0044
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_ime"
                 #LET g_qryparam.default1 = g_sna[l_ac].sna31a
                 #LET g_qryparam.arg1     = g_sna[l_ac].sna30a#倉庫編號 #MOD-4A0063
                 #LET g_qryparam.arg2     = 'SW'              #倉庫類別 #MOD-4A0063
                 #CALL cl_create_qry() RETURNING g_sna[l_ac].sna31a
                  CALL q_ime_1(FALSE,TRUE,g_sna[l_ac].sna31a,g_sna[l_ac].sna30a,"",g_plant,"","","")
                       RETURNING g_sna[l_ac].sna31a
                 #End Mod No.FUN-AB0044
                  NEXT FIELD sna31a
             OTHERWISE EXIT CASE
           END CASE

        ON ACTION CONTROLN
            CALL t802_b_askkey()
            EXIT INPUT
 
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
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
    END INPUT
    UPDATE snb_file SET snbmodu=g_user,snbdate=g_today
     WHERE snb01=g_snb.snb01
 
    CLOSE t802_bcl
    COMMIT WORK
 
    CALL t802_delall()
 
    CALL t802_sub_chk(g_snb.snb01)
 
    CALL t802_b_fill(' 1=1')
END FUNCTION
 
FUNCTION t802_delall() 			# 未輸入單身資料, 是否取消單頭資料
    SELECT COUNT(*) INTO g_cnt FROM sna_file
        WHERE sna01 = g_snb.snb01
          AND sna02 = g_snb.snb02
    IF g_cnt = 0 THEN
       IF cl_confirm('asf-059') THEN
          DELETE FROM snb_file WHERE snb01 = g_snb.snb01 AND snb02 = g_snb.snb02
          DELETE FROM sna_file WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
          DELETE FROM snc_file WHERE snc01 = g_snb.snb01 AND snc02 = g_snb.snb02
          CLEAR FORM
   CALL g_sna.clear()
          CALL g_sna.clear()
          CALL g_sfa29.clear()
       END IF
    END IF
END FUNCTION
 
FUNCTION t802_b_subset(p_ratio,p_sfa29,p_sfa03)   #同組的SET替代料是否一併變更(Y/N)
  DEFINE
         p_ratio   LIKE sna_file.sna05b,
         p_sfa29   LIKE sfa_file.sfa29,
         p_sfa03   LIKE sfa_file.sfa03,
         l_sfa     RECORD LIKE sfa_file.*,
         l_sna     RECORD LIKE sna_file.*,
         l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
         l_sql     LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(1000)
 
  LET l_sql= "SELECT sfa_file.* FROM sfa_file,bob_file",
             " WHERE sfa01 = '",g_snb.snb01 CLIPPED,"' ",
	     "   AND sfa29 = '",p_sfa29 CLIPPED,"' ",
	     "   AND sfa03 != '",p_sfa03 CLIPPED,"' ",
	     "   AND sfa26 = 'T' ",
             "   AND sfa29 = bob01 ",
             "   AND sfa03 = bob04 ",
             "   AND sfa08 = bob05 ",
             "   AND sfa12 = bob06 "
  PREPARE t802_b_subset_pre1 FROM l_sql    #預備一下
  IF SQLCA.sqlcode THEN
     CALL cl_err('t802_b_subset_pre1',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
  DECLARE t802_b_subset_cs CURSOR FOR t802_b_subset_pre1
  IF SQLCA.sqlcode THEN
     CALL cl_err('t802_b_subset_cs',SQLCA.sqlcode,1)
     LET g_success = 'N'
     RETURN
  END IF
 
 #取得目前最大項次
  SELECT MAX(sna04) INTO l_cnt FROM sna_file
   WHERE sna01 = g_snb.snb01
     AND sna02 = g_snb.snb02
  IF cl_null(l_cnt) THEN LET l_cnt = 0 END IF
 
  LET g_success = 'Y'
 
  FOREACH t802_b_subset_cs INTO l_sfa.*
     IF SQLCA.sqlcode THEN
        CALL cl_err('t802_b_subset_cs foreach',SQLCA.sqlcode,1)
        LET g_success = 'N'
        EXIT FOREACH
     END IF
     LET l_cnt = l_cnt + 1
     INITIALIZE l_sna.* TO NULL
     LET l_sna.sna01  = g_snb.snb01
     LET l_sna.sna02  = g_snb.snb02
     LET l_sna.sna022 = g_snb.snb022
     LET l_sna.sna04  = l_cnt
     LET l_sna.sna10  = '2'
     LET l_sna.sna27b = l_sfa.sfa27
     LET l_sna.sna27b = l_sfa.sfa27
     LET l_sna.sna03b = l_sfa.sfa03
     LET l_sna.sna08b = l_sfa.sfa08
     LET l_sna.sna11b = l_sfa.sfa11
     LET l_sna.sna12b = l_sfa.sfa12
     LET l_sna.sna13b = l_sfa.sfa13
     LET l_sna.sna100b= l_sfa.sfa100
     LET l_sna.sna26b = l_sfa.sfa26
     LET l_sna.sna28b = l_sfa.sfa28
     LET l_sna.sna161b= l_sfa.sfa161
     LET l_sna.sna05b = l_sfa.sfa05
     LET l_sna.sna062b= l_sfa.sfa062
     LET l_sna.sna06b = l_sfa.sfa06
     LET l_sna.sna07b = l_sfa.sfa07
     LET l_sna.sna065b= l_sfa.sfa065
     LET l_sna.sna30b = l_sfa.sfa30
     LET l_sna.sna31b = l_sfa.sfa31
     LET l_sna.sna05a = l_sfa.sfa05 * p_ratio
     LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)    #FUN-910088--add--
     IF cl_null(l_sna.sna05a) THEN CONTINUE FOREACH END IF
     CALL t802_cal_qty(l_sna.sna05b,l_sna.sna05a,
                       l_sna.sna06b,l_sna.sna062b,l_sna.sna07b,l_sna.sna065b)   #No.MOD-930172 add
             RETURNING l_sna.sna06a,l_sna.sna062a,
                       l_sna.sna07a,l_sna.sna161a
 
     #FUN-910088--add--start--
     LET l_sna.sna06a = s_digqty(l_sna.sna06a,l_sna.sna12b)
     LET l_sna.sna062a = s_digqty(l_sna.sna062a,l_sna.sna12b)
     LET l_sna.sna07a = s_digqty(l_sna.sna07a,l_sna.sna12b)
     #FUN-910088--add--end-- 
     LET l_sna.snaplant = g_plant #FUN-980008 add
     LET l_sna.snalegal = g_legal #FUN-980008 add
 
     INSERT INTO sna_file VALUES (l_sna.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","sna_file",l_sna.sna01,l_sna.sna02,SQLCA.sqlcode,"","t802_b_subset_ins",1)  #No.FUN-660128
        LET g_success = 'N'
        EXIT FOREACH
     END IF
  END FOREACH
 
 
END FUNCTION
 
FUNCTION t802_sna05a()
   DEFINE l_ima64       LIKE ima_file.ima64,
          l_ima641      LIKE ima_file.ima641,
          l_gfe03       LIKE gfe_file.gfe03
 
   LET g_errno = ' '
   SELECT ima64,ima641 INTO l_ima64,l_ima641 FROM ima_file
    WHERE ima01=g_sna[l_ac].sna27a
   IF STATUS THEN LET l_ima64 = 0 LET l_ima641 = 0 END IF
   #check最少發料數量
   IF l_ima641 <>  0 AND g_sna[l_ac].sna05a < l_ima641 THEN
      LET g_errno = 'asf-100'
   END IF
   IF l_ima64 <> 0 AND (g_sna[l_ac].sna05a MOD l_ima64) > 0 THEN
      LET g_errno = 'asf-101'
   END IF
   #-->考慮單位小數取位
   SELECT gfe03 INTO l_gfe03 FROM gfe_file WHERE gfe01 = g_sna[l_ac].sna12a
   IF SQLCA.sqlcode OR cl_null(l_gfe03) THEN LET l_gfe03 = 0 END IF
   CALL cl_digcut(g_sna[l_ac].sna05a,l_gfe03) RETURNING g_sna[l_ac].sna05a
   DISPLAY BY NAME g_sna[l_ac].sna05a
END FUNCTION
 
FUNCTION t802_move_tmp()
    LET g_sna[l_ac].sna04  =   b_sna.sna04
    LET g_sna[l_ac].sna10  =   b_sna.sna10
    LET g_sna[l_ac].sna27b =   b_sna.sna27b
    LET g_sna[l_ac].sna03b =   b_sna.sna03b
    LET g_sna[l_ac].sna08b =   b_sna.sna08b
    LET g_sna[l_ac].sna11b =   b_sna.sna11b
    LET g_sna[l_ac].sna12b =   b_sna.sna12b
    LET g_sna[l_ac].sna13b =   b_sna.sna13b
    LET g_sna[l_ac].sna100b=   b_sna.sna100b
    LET g_sna[l_ac].sna26b =   b_sna.sna26b
    LET g_sna[l_ac].sna28b =   b_sna.sna28b
    LET g_sna[l_ac].sna161b=   b_sna.sna161b
    LET g_sna[l_ac].sna05b =   b_sna.sna05b
    LET g_sna[l_ac].sna062b=   b_sna.sna062b
    LET g_sna[l_ac].sna06b =   b_sna.sna06b
    LET g_sna[l_ac].sna07b =   b_sna.sna07b
    LET g_sna[l_ac].sna065b=   b_sna.sna065b
    LET g_sna[l_ac].sna30b =   b_sna.sna30b
    LET g_sna[l_ac].sna31b =   b_sna.sna31b
    LET g_sna[l_ac].sna27a =   b_sna.sna27a
    LET g_sna[l_ac].sna03a =   b_sna.sna03a
    LET g_sna[l_ac].sna08a =   b_sna.sna08a
    LET g_sna[l_ac].sna11a =   b_sna.sna11a
    LET g_sna[l_ac].sna12a =   b_sna.sna12a
    LET g_sna[l_ac].sna13a =   b_sna.sna13a
    LET g_sna[l_ac].sna100a=   b_sna.sna100a
    LET g_sna[l_ac].sna26a =   b_sna.sna26a
    LET g_sna[l_ac].sna28a =   b_sna.sna28a
    LET g_sna[l_ac].sna161a=   b_sna.sna161a
    LET g_sna[l_ac].sna05a =   b_sna.sna05a
    LET g_sna[l_ac].sna062a=   b_sna.sna062a
    LET g_sna[l_ac].sna06a =   b_sna.sna06a
    LET g_sna[l_ac].sna07a =   b_sna.sna07a
    LET g_sna[l_ac].sna065a=   b_sna.sna065a
    LET g_sna[l_ac].sna30a =   b_sna.sna30a
    LET g_sna[l_ac].sna31a =   b_sna.sna31a
    LET g_sna[l_ac].sna50  =   b_sna.sna50
END FUNCTION
 
FUNCTION t802_tmp_move()
    LET b_sna.sna01    = g_snb.snb01
    LET b_sna.sna02    = g_snb.snb02
    LET b_sna.sna022   = g_snb.snb022
    LET b_sna.sna04    = g_sna[l_ac].sna04
    LET b_sna.sna10    = g_sna[l_ac].sna10
    LET b_sna.sna27b   = g_sna[l_ac].sna27b
    LET b_sna.sna03b   = g_sna[l_ac].sna03b
    LET b_sna.sna08b   = g_sna[l_ac].sna08b
    LET b_sna.sna11b   = g_sna[l_ac].sna11b
    LET b_sna.sna12b   = g_sna[l_ac].sna12b
    LET b_sna.sna13b   = g_sna[l_ac].sna13b
    LET b_sna.sna100b  = g_sna[l_ac].sna100b
    LET b_sna.sna26b   = g_sna[l_ac].sna26b
    LET b_sna.sna28b   = g_sna[l_ac].sna28b
    LET b_sna.sna161b  = g_sna[l_ac].sna161b
    LET b_sna.sna05b   = g_sna[l_ac].sna05b
    LET b_sna.sna062b  = g_sna[l_ac].sna062b
    LET b_sna.sna06b   = g_sna[l_ac].sna06b
    LET b_sna.sna07b   = g_sna[l_ac].sna07b
    LET b_sna.sna065b  = g_sna[l_ac].sna065b
    LET b_sna.sna30b   = g_sna[l_ac].sna30b
    LET b_sna.sna31b   = g_sna[l_ac].sna31b
    LET b_sna.sna27a   = g_sna[l_ac].sna27a
    LET b_sna.sna03a   = g_sna[l_ac].sna03a
    LET b_sna.sna08a   = g_sna[l_ac].sna08a
    LET b_sna.sna11a   = g_sna[l_ac].sna11a
    LET b_sna.sna12a   = g_sna[l_ac].sna12a
    LET b_sna.sna13a   = g_sna[l_ac].sna13a
    LET b_sna.sna100a  = g_sna[l_ac].sna100a
    LET b_sna.sna26a   = g_sna[l_ac].sna26a
    LET b_sna.sna28a   = g_sna[l_ac].sna28a
    LET b_sna.sna161a  = g_sna[l_ac].sna161a
    LET b_sna.sna05a   = g_sna[l_ac].sna05a
    LET b_sna.sna062a  = g_sna[l_ac].sna062a
    LET b_sna.sna06a   = g_sna[l_ac].sna06a
    LET b_sna.sna07a   = g_sna[l_ac].sna07a
    LET b_sna.sna065a  = g_sna[l_ac].sna065a
    LET b_sna.sna30a   = g_sna[l_ac].sna30a
    LET b_sna.sna31a   = g_sna[l_ac].sna31a
    LET b_sna.sna50    = g_sna[l_ac].sna50
END FUNCTION
 
FUNCTION t802_sna03(p_cmd,p_no)
    DEFINE l_ima02   LIKE ima_file.ima02,
           l_ima021  LIKE ima_file.ima021,
           l_ima39   LIKE ima_file.ima39,
           l_ima140  LIKE ima_file.ima140,
           l_imaacti LIKE ima_file.imaacti,
           p_no      LIKE ima_file.ima01,
           p_cmd     LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
  LET g_errno = ''
  SELECT * INTO g_ima.* FROM ima_file
         WHERE ima01 = p_no
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno     = 'mfg0002'
                                 LET g_ima.ima02 = NULL
                                 LET g_ima.imaacti=NULL
       WHEN g_ima.imaacti = 'N'  LET g_errno = '9028'
       WHEN g_ima.imaacti MATCHES '[PH]'       LET g_errno = '9038'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
  RETURN g_ima.ima02
END FUNCTION
 
FUNCTION t802_sna10(p_no)
  DEFINE p_no     LIKE sna_file.sna10
  DEFINE l_desc   LIKE type_file.chr20       #No.FUN-680121 VARCHAR(8)
  DEFINE l_ze01   LIKE ze_file.ze01          #No.FUN-680121 VARCHAR(7)
  CASE p_no
       WHEN '1'    LET l_ze01='asf-834'
       WHEN '2'    LET l_ze01='asf-835'
       WHEN '3'    LET l_ze01='asf-836'
       WHEN '4'    LET l_ze01='asf-831'
       SELECT ze03 INTO l_zemsg FROM ze_file
          WHERE ze01 = l_ze01 AND ze02 = g_lang
       LET l_desc = l_zemsg CLIPPED
  END CASE
  RETURN l_desc
END FUNCTION
 
FUNCTION t802_sna27(p_sfa03,p_sfa08,p_sfa12,p_sfa27) #No.FUN-870051 add p_sfa27
  DEFINE l_sfa     RECORD LIKE sfa_file.*,
         p_sfa03   LIKE sfa_file.sfa03,
         p_sfa08   LIKE sfa_file.sfa08,
         p_sfa12   LIKE sfa_file.sfa12,
         p_sfa27   LIKE sfa_file.sfa27  #No.FUN-870051
 
  IF cl_null(p_sfa03) THEN RETURN END IF
  LET g_errno = ''
  SELECT * INTO l_sfa.* FROM sfa_file
   WHERE sfa01 = g_snb.snb01
     AND sfa03 = p_sfa03
     AND sfa08 = p_sfa08
     AND sfa12 = p_sfa12
     AND sfa27 = p_sfa27   #No.FUN-870051
 
  CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg0002'
                                 INITIALIZE l_sfa.* TO NULL
       WHEN l_sfa.sfaacti='N'    LET g_errno = '9028'
       WHEN l_sfa.sfaacti='X'    LET g_errno = '9024'
       OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
  END CASE
 
  IF cl_null(g_errno) THEN
        LET g_sfa29[l_ac]      = l_sfa.sfa29
        LET g_sna[l_ac].sna27b = l_sfa.sfa27
        LET g_sna[l_ac].sna03b = l_sfa.sfa03
        LET g_sna[l_ac].sna08b = l_sfa.sfa08
        LET g_sna[l_ac].sna11b = l_sfa.sfa11
        LET g_sna[l_ac].sna12b = l_sfa.sfa12
        LET g_sna[l_ac].sna13b = l_sfa.sfa13
        LET g_sna[l_ac].sna100b= l_sfa.sfa100
        LET g_sna[l_ac].sna26b = l_sfa.sfa26
        LET g_sna[l_ac].sna28b = l_sfa.sfa28
        LET g_sna[l_ac].sna161b= l_sfa.sfa161
        LET g_sna[l_ac].sna05b = l_sfa.sfa05
        LET g_sna[l_ac].sna062b= l_sfa.sfa062
        LET g_sna[l_ac].sna06b = l_sfa.sfa06
        LET g_sna[l_ac].sna07b = l_sfa.sfa07
        LET g_sna[l_ac].sna065b= l_sfa.sfa065
        LET g_sna[l_ac].sna30b = l_sfa.sfa30
        LET g_sna[l_ac].sna31b = l_sfa.sfa31
  END IF
END FUNCTION
 
#--->單位檔
FUNCTION t802_unit(p_key)
  DEFINE p_key      LIKE gfe_file.gfe01,
         l_gfeacti  LIKE gfe_file.gfeacti
 
  LET g_errno = ' '
  SELECT gfeacti INTO l_gfeacti FROM gfe_file
                WHERE gfe01 = p_key
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3098'
                          LET l_gfeacti = NULL
        WHEN l_gfeacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
END FUNCTION
 
FUNCTION t802_b_askkey()
DEFINE
    l_wc            LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
 
       CONSTRUCT l_wc ON      #螢幕上取條件
                 sna04,sna10,
                 sna27a,sna03a,sna08a,sna11a,sna12a,sna13a,
                 sna100a,sna26a,sna28a,sna161a,sna05a,sna062a,
                 sna06a,sna07a,sna065a,sna30a,sna31a,sna50
       FROM s_sna[1].sna04,s_sna[1].sna10,
            s_sna[1].sna27a,s_sna[1].sna03a,s_sna[1].sna08a,s_sna[1].sna11a,
            s_sna[1].sna12a,s_sna[1].sna13a,s_sna[1].sna100a,s_sna[1].sna26a,
            s_sna[1].sna28a,s_sna[1].sna161a,s_sna[1].sna05a,s_sna[1].sna062a,
            s_sna[1].sna06a,s_sna[1].sna07a,s_sna[1].sna065a,s_sna[1].sna30a,
            s_sna[1].sna31a,s_sna[1].sna50
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE CONSTRUCT
 
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
       END CONSTRUCT
 
       IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
       CALL t802_b_fill(l_wc)
END FUNCTION
 
FUNCTION t802_b_fill(p_wc)              #BODY FILL UP
DEFINE
    p_wc            LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
 
    LET g_sql =
        "SELECT sna10,'',sna04,",
        "       sna27b,sna03b,'',sna08b,sna11b,sna12b,sna13b,",
        "       sna100b,sna26b,sna28b,sna161b,sna05b,sna062b,",
        "       sna06b,sna07b,sna065b,sna30b,sna31b,",
        "       sna27a,sna03a,'',sna08a,sna11a,sna12a,sna13a,",
        "       sna100a,sna26a,sna28a,sna161a,sna05a,sna062a,",
        "       sna06a,sna07a,sna065a,sna30a,sna31a,",
        "       sna50",
        "  FROM sna_file ",
        " WHERE sna01 = '",g_snb.snb01, "'",
        "   AND sna02 = ",g_snb.snb02," AND ",p_wc CLIPPED
    PREPARE t802_prepare2 FROM g_sql    #預備一下
    DECLARE t802_sna_cs CURSOR FOR t802_prepare2
 
    CALL g_sna.clear()
 
    LET g_rec_b = 0
    LET g_cnt = 1
 
    FOREACH t802_sna_cs INTO g_sna[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_sna[g_cnt].ima02b = t802_sna03('d',g_sna[g_cnt].sna03b)
      LET g_sna[g_cnt].ima02a = t802_sna03('d',g_sna[g_cnt].sna03a)
      LET g_sna[g_cnt].desc   = t802_sna10(g_sna[g_cnt].sna10)
      LET g_cnt = g_cnt + 1
 
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
 
    END FOREACH
    CALL g_sna.deleteElement(g_cnt)
    LET g_rec_b=g_cnt-1
 
    DISPLAY g_rec_b TO FORMONLY.cn2
    LET g_cnt = 0
 
END FUNCTION
 
FUNCTION t802_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sna TO s_sna.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
         IF NOT cl_null(g_argv1) THEN
            CALL cl_set_act_visible("insert,modify,change_release,delete,detail,rep_sub",FALSE)
         END IF
 
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
      ON ACTION first
         CALL t802_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL t802_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL t802_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION next
         CALL t802_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION last
         CALL t802_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
#@    ON ACTION 取替代
      ON ACTION rep_sub
         LET g_action_choice="rep_sub"
         EXIT DISPLAY
#@    ON ACTION 變更發出
      ON ACTION change_release
         LET g_action_choice="change_release"
         EXIT DISPLAY
#@    ON ACTION 備註
      ON ACTION memo
         LET g_action_choice="memo"
         EXIT DISPLAY
 
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
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
 
      ON ACTION related_document                #No.FUN-6B0079  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
FUNCTION t802_out()
  DEFINE l_sw       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_prog     LIKE zaa_file.zaa01,          #No.FUN-680121 VARCHAR(10) # TQC-6A0079
         l_wc       LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(200)
         l_cmd,g_buf LIKE type_file.chr1000,      #No.FUN-680121 VARCHAR(400)
         l_i,l_j    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
	 l_prtway   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
         l_lang     LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)
 
     IF NOT cl_null(g_snb.snb01) THEN
        CALL cl_prtmsg(16,11,'asf-223',g_lang) RETURNING l_sw
        IF l_sw THEN
           LET l_wc = " snb01 = "," '",g_snb.snb01,"' ",
                      " AND snb02 = "," '",g_snb.snb02,"' "
           LET g_buf=l_wc
           LET l_j=length(g_buf)
           FOR l_i=1 TO l_j
             IF g_buf[l_i,l_i+1]='"' THEN
                LET g_buf[l_i,l_i+1]="'"
             END IF
           END FOR
           LET l_wc = g_buf
           #LET l_prog='asfr801 ' #FUN-C30085 mark
           LET l_prog='asfg801 ' #FUN-C30085 add
           LET l_wc=' snb01= "',g_snb.snb01,'" AND snb02=',g_snb.snb02,' '  
	   LET l_cmd = l_prog ,
                         "'",g_today,"'",
                         " '",g_user,"'",
                         " '",g_lang,"'",
                         " 'Y' ",
                         " ' ' ",
                         " '1'",
                         " '",l_wc,"'",
                         " 'N' ",
                         " '3'"
            CALL cl_cmdrun(l_cmd)
         END IF
     END IF
END FUNCTION
 
FUNCTION t802_g()
DEFINE
   i          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
   l_msg      LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(80)
   l_sfa06    LIKE sfa_file.sfa06,
   l_sna10    LIKE sna_file.sna10,
   l_sfa      RECORD LIKE sfa_file.*
 
   IF s_shut(0) THEN RETURN END IF
   IF cl_null(g_snb.snb01) THEN CALL cl_err('',-400,0)   RETURN END IF
 
   BEGIN WORK
 
    OPEN t802_cl USING g_snb.snb01,g_snb.snb02
    IF STATUS THEN
       CALL cl_err("OPEN t802_cl:", STATUS, 1)
       CLOSE t802_cl
       ROLLBACK WORK
       RETURN
    END IF
    FETCH t802_cl INTO g_snb.*               # 鎖住將被更改或取消的資料
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)          #資料被他人LOCK
       CLOSE t802_cl
       ROLLBACK WORK
       RETURN
    END IF
    CALL t802_show()
 
   #發出否snbconf='N'，才可執行
    IF g_snb.snbconf = 'X' THEN
       CALL cl_err('','9024',0)
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
 
    IF g_snb.snbconf = 'Y'  THEN
       CALL cl_err('','asf-061',0)
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
 
   #需檢查變更日期不可大於會計年度/期別，和小於系統關帳日期
    IF NOT cl_null(g_sma.sma53) AND g_snb.snb022 <= g_sma.sma53 THEN
       CALL cl_err('','mfg9999',0)
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
    CALL s_yp(g_snb.snb022) RETURNING g_yy,g_mm
    IF (g_yy*12+g_mm) > (g_sma.sma51*12+g_sma.sma52) THEN
       CALL cl_err(g_yy,'mfg6090',0)
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
 
    SELECT * INTO g_sfb.* FROM sfb_file WHERE sfb01 = g_snb.snb01
    IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","sfb_file",g_snb.snb01,"",SQLCA.sqlcode,"","g_sel_sfb",1)  #No.FUN-660128
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
    IF g_sfb.sfb87 != 'Y' THEN CALL cl_err(g_sfb.sfb01,'9029',0) RETURN END IF
    IF g_sfb.sfb04 = '8'  THEN CALL cl_err(g_sfb.sfb01,'asf-070',0) RETURN END IF

    IF g_success = 'N' THEN
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
 
    CALL t802_sub_chk(g_snb.snb01)
    IF g_success = 'N' THEN
       CALL cl_err(l_msg,g_errno,1)
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
 
    IF NOT cl_sure(15,22) THEN
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
 
    LET g_success = 'Y'
 
    CALL t802_g1()
 
    IF g_success = 'N' THEN
       ROLLBACK WORK
       CLOSE t802_cl
       RETURN
    END IF
 
   #UPDATE snb_file 確認碼為='Y'.............................
    UPDATE snb_file SET snbconf = 'Y'
     WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
    IF SQLCA.sqlcode THEN
       CALL cl_err3("upd","snb_file",g_snb01_t,"",SQLCA.sqlcode,"","up snb_file",1)  #No.FUN-660128
       LET g_success = 'N'
    END IF
 
   #UPDATE sfb_file變更序號(sfb101)..........................
    UPDATE sfb_file SET sfb101 = g_snb.snb02
     WHERE sfb01 = g_snb.snb01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_err3("upd","sfb_file",g_snb01_t,"",SQLCA.sqlcode,"","up sfb_file",1)  #No.FUN-660128
       LET g_success = 'N'
    END IF
    IF g_success = 'Y' THEN
       CALL cl_cmmsg(1)
       COMMIT WORK
    ELSE
       CALL cl_rbmsg(1)
       ROLLBACK WORK
    END IF
    SELECT snbconf INTO g_snb.snbconf FROM snb_file
     WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
    DISPLAY BY NAME g_snb.snbconf
 
    CLOSE t802_cl
 
END FUNCTION
 
FUNCTION t802_g1()
  DEFINE l_sfa    RECORD LIKE sfa_file.*
  DEFINE i        LIKE type_file.num5          #No.FUN-680121 SMALLINT
  DEFINE l_sfai   RECORD LIKE sfai_file.*      #No.FUN-7B0018
  DEFINE b_sfai   RECORD LIKE sfai_file.*      #No.FUN-7B0018
 
    FOR i = 1 TO g_sna.getLength()
     #FUN-910088--add--start--
       IF NOT cl_null(g_sna[i].sna12a) AND cl_null(g_sna[i].sna05a) THEN
          LET g_sna[i].sna05a = s_digqty(g_sna[i].sna05b,g_sna[i].sna12a)
       END IF
       IF NOT cl_null(g_sna[i].sna12a) AND cl_null(g_sna[i].sna062a) THEN
           LET g_sna[i].sna062a = s_digqty(g_sna[i].sna062b,g_sna[i].sna12a)
       END IF
       IF NOT cl_null(g_sna[i].sna12a) AND cl_null(g_sna[i].sna065a) THEN
           LET g_sna[i].sna065a = s_digqty(g_sna[i].sna065b,g_sna[i].sna12a)
       END IF
       IF NOT cl_null(g_sna[i].sna12a) AND cl_null(g_sna[i].sna06a) THEN
           LET g_sna[i].sna06a = s_digqty(g_sna[i].sna06b,g_sna[i].sna12a)
       END IF
       IF NOT cl_null(g_sna[i].sna12a) AND cl_null(g_sna[i].sna07a) THEN
           LET g_sna[i].sna07a = s_digqty(g_sna[i].sna07b,g_sna[i].sna12a)
       END IF
     #FUN-910088--add--end-- 
       IF cl_null(g_sna[i].sna04) THEN EXIT FOR END IF
      #1.新增.............................................
       IF g_sna[i].sna10 = '1' THEN
          CALL t802_g1_buf(i) RETURNING l_sfa.*
          INSERT INTO sfa_file VALUES (l_sfa.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","sfa_file",l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,"","ins_sfa_1",1)  #No.FUN-660128
             LET g_success = 'N'
          ELSE
             IF NOT s_industry('std') THEN
                INITIALIZE l_sfai.* TO NULL
                LET l_sfai.sfai01 = l_sfa.sfa01
                LET l_sfai.sfai03 = l_sfa.sfa03
                LET l_sfai.sfai08 = l_sfa.sfa08
                LET l_sfai.sfai12 = l_sfa.sfa12
                LET l_sfai.sfai27 = l_sfa.sfa27    #No.FUN-870051
                LET l_sfai.sfai012 = l_sfa.sfa012  #No.FUN-A60027
                LET l_sfai.sfai013 = l_sfa.sfa013  #No.FUN-A60027
                IF NOT s_ins_sfai(l_sfai.*,'') THEN
                   LET g_success = 'N'
                END IF
             END IF
          END IF
       ELSE
      #2.修改/3.取替代....................................
          SELECT * INTO l_sfa.* FROM sfa_file
           WHERE sfa01 = g_snb.snb01
             AND sfa03 = g_sna[i].sna03b
             AND sfa08 = g_sna[i].sna08b
             AND sfa12 = g_sna[i].sna12b
             AND sfa27 = g_sna[i].sna27b    #No.FUN-870051
          IF SQLCA.sqlcode THEN
            #取替代料不存在需新增.........................
             IF g_sna[i].sna26a MATCHES '[34SU]' THEN
                CALL t802_g1_buf(i) RETURNING l_sfa.*
                INSERT INTO sfa_file VALUES (l_sfa.*)
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("ins","sfa_file",l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,"","ins_sfa_2",1)  #No.FUN-660128
                   LET g_success = 'N'
                ELSE
                   IF NOT s_industry('std') THEN
                      INITIALIZE b_sfai.* TO NULL
                      LET b_sfai.sfai01 = l_sfa.sfa01
                      LET b_sfai.sfai03 = l_sfa.sfa03
                      LET b_sfai.sfai08 = l_sfa.sfa08
                      LET b_sfai.sfai12 = l_sfa.sfa12
                      LET b_sfai.sfai27 = l_sfa.sfa27        #No.FUN-870051
                      LET b_sfai.sfai012 = l_sfa.sfa012      #No.FUN-A60027
                      LET b_sfai.sfai013 = l_sfa.sfa013      #No.FUN-A60027
                      IF NOT s_ins_sfai(l_sfai.*,'') THEN
                         LET g_success = 'N'
                      END IF
                   END IF
                END IF
             END IF
          ELSE
             IF NOT cl_null(g_sna[i].sna05a) THEN
                LET l_sfa.sfa05  = g_sna[i].sna05a
             END IF
             IF NOT cl_null(g_sna[i].sna06a) THEN
                LET l_sfa.sfa06  = g_sna[i].sna06a
             END IF
             IF NOT cl_null(g_sna[i].sna062a) THEN
                LET l_sfa.sfa062 = g_sna[i].sna062a
             END IF
             IF NOT cl_null(g_sna[i].sna065a) THEN
                LET l_sfa.sfa065 = g_sna[i].sna065a
             END IF
             IF NOT cl_null(g_sna[i].sna07a) THEN
                LET l_sfa.sfa07  = g_sna[i].sna07a
             END IF
             IF NOT cl_null(g_sna[i].sna08a) THEN
                LET l_sfa.sfa08  = g_sna[i].sna08a
             END IF
             IF NOT cl_null(g_sna[i].sna11a) THEN
                LET l_sfa.sfa11  = g_sna[i].sna11a
             END IF
             IF NOT cl_null(g_sna[i].sna12a) THEN
                LET l_sfa.sfa12  = g_sna[i].sna12a
             END IF
             IF NOT cl_null(g_sna[i].sna13a) THEN
                LET l_sfa.sfa13  = g_sna[i].sna13a
             END IF
             IF NOT cl_null(g_sna[i].sna27a) THEN
                LET l_sfa.sfa27  = g_sna[i].sna27a
             END IF
             IF NOT cl_null(g_sna[i].sna161a) THEN
                LET l_sfa.sfa161 = g_sna[i].sna161a
             END IF
             IF NOT cl_null(g_sna[i].sna26a) THEN
                LET l_sfa.sfa26  = g_sna[i].sna26a
             END IF
             IF NOT cl_null(g_sna[i].sna28a) THEN
                LET l_sfa.sfa28  = g_sna[i].sna28a
             END IF
             IF NOT cl_null(g_sna[i].sna30a) THEN
                LET l_sfa.sfa30  = g_sna[i].sna30a
             END IF
             IF NOT cl_null(g_sna[i].sna31a) THEN
                LET l_sfa.sfa31  = g_sna[i].sna31a
             END IF
             IF NOT cl_null(g_sna[i].sna100a) THEN
                LET l_sfa.sfa100 = g_sna[i].sna100a
             END IF
             UPDATE sfa_file SET * = l_sfa.*
              WHERE sfa01 = l_sfa.sfa01
                AND sfa03 = l_sfa.sfa03
                AND sfa08 = l_sfa.sfa08
                AND sfa12 = l_sfa.sfa12
                AND sfa27 = l_sfa.sfa27  #No.FUN-870051
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","sfa_file",l_sfa.sfa01,l_sfa.sfa03,SQLCA.sqlcode,"","upd_sfa",1)  #No.FUN-660128
                 LET g_success = 'N'
              END IF
          END IF
       END IF
    END FOR
 
END FUNCTION
 
FUNCTION t802_g1_buf(p_i)
  DEFINE  p_i      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sfa    RECORD LIKE sfa_file.*
 
  INITIALIZE l_sfa.* TO NULL
 
  LET l_sfa.sfa01  = g_snb.snb01
  LET l_sfa.sfa02  = g_snb.snb02
  LET l_sfa.sfa03  = g_sna[p_i].sna03a
  LET l_sfa.sfa05  = g_sna[p_i].sna05a
  LET l_sfa.sfa06  = g_sna[p_i].sna06a
  LET l_sfa.sfa061 = 0
  LET l_sfa.sfa062 = g_sna[p_i].sna062a
  LET l_sfa.sfa063 = 0
  LET l_sfa.sfa064 = 0
  LET l_sfa.sfa065 = g_sna[p_i].sna065a
  LET l_sfa.sfa066 = 0
  LET l_sfa.sfa07  = g_sna[p_i].sna07a
  LET l_sfa.sfa08  = g_sna[p_i].sna08a
  LET l_sfa.sfa11  = g_sna[p_i].sna11a
  LET l_sfa.sfa12  = g_sna[p_i].sna12a
  LET l_sfa.sfa13  = g_sna[p_i].sna13a
  LET l_sfa.sfa27  = g_sna[p_i].sna27a
 
  SELECT (bmb06/bmb07)*(1+bmb08/100) INTO l_sfa.sfa16 FROM bmb_file
   WHERE bmb01=g_sfb.sfb05
     AND bmb03=l_sfa.sfa27
     AND (bmb04<=g_sfb.sfb071 OR bmb04 IS NULL)
     AND (g_sfb.sfb071<bmb05 OR bmb05 IS NULL)
  IF cl_null(l_sfa.sfa16) THEN LET l_sfa.sfa16 = 1 END IF
  LET l_sfa.sfa04  = g_sfb.sfb08 * l_sfa.sfa16
  LET l_sfa.sfa04  = s_digqty(l_sfa.sfa04,l_sfa.sfa12)   #FUN-BB0085 
 
  LET l_sfa.sfa161 = g_sna[p_i].sna161a
  LET l_sfa.sfa25  = 0
  LET l_sfa.sfa26  = g_sna[p_i].sna26a
  LET l_sfa.sfa28  = g_sna[p_i].sna28a
  LET l_sfa.sfa29  = g_sfa29[p_i]
  LET l_sfa.sfa30  = g_sna[p_i].sna30a
  LET l_sfa.sfa31  = g_sna[p_i].sna31a
  LET l_sfa.sfa100 = g_sna[p_i].sna100a
  LET l_sfa.sfaacti= 'Y'
 
  IF cl_null(l_sfa.sfa05)  THEN LET l_sfa.sfa05  = 0 END IF
  IF cl_null(l_sfa.sfa06)  THEN LET l_sfa.sfa06  = 0 END IF
  IF cl_null(l_sfa.sfa061) THEN LET l_sfa.sfa061 = 0 END IF
  IF cl_null(l_sfa.sfa062) THEN LET l_sfa.sfa062 = 0 END IF
  IF cl_null(l_sfa.sfa063) THEN LET l_sfa.sfa063 = 0 END IF
  IF cl_null(l_sfa.sfa064) THEN LET l_sfa.sfa064 = 0 END IF
  IF cl_null(l_sfa.sfa065) THEN LET l_sfa.sfa065 = 0 END IF
  IF cl_null(l_sfa.sfa28)  THEN LET l_sfa.sfa28 = 1  END IF

#FUN-A70125 --begin--
  IF cl_null(l_sfa.sfa012) THEN LET l_sfa.sfa012 = ' '  END IF
  IF cl_null(l_sfa.sfa013) THEN LET l_sfa.sfa013 = 0  END IF
#FUN-A70125 --end--
 
  LET l_sfa.sfaplant = g_plant #FUN-980008 add
  LET l_sfa.sfalegal = g_legal #FUN-980008 add
 
  RETURN l_sfa.*
 
END FUNCTION
 
FUNCTION t802_z()
   IF s_shut(0) THEN RETURN END IF
   #未確認OR已發出
   SELECT * INTO g_snb.* FROM snb_file
    WHERE snb01=g_snb.snb01
      AND snb02=g_snb.snb02
   IF g_snb.snbconf = 'N' OR g_snb.snbconf = 'Y' THEN  RETURN END IF
   IF g_snb.snbconf = 'X'    THEN CALL cl_err('','9024',0) RETURN END IF
   IF cl_null(g_snb.snb01) THEN CALL cl_err('',-400,0)   RETURN END IF
   IF NOT cl_confirm('axm-109') THEN RETURN END IF
 
   BEGIN WORK
 
   LET g_success = 'Y'
 
   OPEN t802_cl USING g_snb.snb01,g_snb.snb02
   IF STATUS THEN
      CALL cl_err("OPEN t802_cl:", STATUS, 1)
      CLOSE t802_cl
      ROLLBACK WORK
      RETURN
   END IF
   FETCH t802_cl INTO g_snb.*                        # 鎖住將被更改或取消的資料
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_snb.snb01,SQLCA.sqlcode,0)      # 資料被他人LOCK
      CLOSE t802_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   UPDATE snb_file SET snbconf = 'N'
    WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
   IF SQLCA.sqlcode THEN
      CALL cl_err3("upd","snb_file",g_snb01_t,g_snb02_t,SQLCA.sqlcode,"","up snb_file",1)  #No.FUN-660128
      LET g_success = 'N'
   END IF
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
   SELECT snbconf INTO g_snb.snbconf FROM snb_file
    WHERE snb01 = g_snb.snb01 AND snb02=g_snb.snb02
   DISPLAY BY NAME g_snb.snbconf
END FUNCTION
 
FUNCTION t802_memo()
   DEFINE p1		LIKE snb_file.snb01
   DEFINE p2		LIKE snb_file.snb02
   DEFINE i,j,n         LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_rec_b       LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE l_snc         DYNAMIC ARRAY OF RECORD
                        snc05        LIKE snc_file.snc05,
                        snc06        LIKE snc_file.snc06
                        END RECORD
   DEFINE l_allow_insert  LIKE type_file.num5                 #可新增否        #No.FUN-680121 SMALLINT
   DEFINE l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
 
   IF cl_null(g_snb.snb01) THEN RETURN END IF
 
   OPEN WINDOW asf_w_m AT 05,02 WITH FORM "asf/42f/asft801m"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asft801m")
 
 
   DECLARE asf_memo CURSOR FOR
           SELECT snc05,snc06 FROM snc_file
            WHERE snc01 = g_snb.snb01
              AND snc02 = g_snb.snb02
            ORDER BY snc05
 
   CALL l_snc.clear()
 
   LET i = 1
   LET l_rec_b = 0
 
   FOREACH asf_memo INTO l_snc[i].snc05,l_snc[i].snc06
      IF STATUS THEN CALL cl_err('foreach snc',STATUS,0) EXIT FOREACH END IF
      LET i = i + 1
   END FOREACH
 
   LET l_rec_b = i - 1
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   INPUT ARRAY l_snc WITHOUT DEFAULTS FROM s_snc.*
         ATTRIBUTE(COUNT=l_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
 
     BEFORE INPUT
         CALL fgl_set_arr_curr(l_ac)
 
     BEFORE ROW
        LET i=ARR_CURR()
 
     AFTER DELETE
        LET n=ARR_COUNT()
        INITIALIZE l_snc[n+1].* TO NULL
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   CLOSE WINDOW asf_w_m
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      RETURN
   END IF
 
   DELETE FROM snc_file
    WHERE snc01 = g_snb.snb01
      AND snc02 = g_snb.snb02
   FOR i = 1 TO l_snc.getLength()
       IF cl_null(l_snc[i].snc06) THEN CONTINUE FOR END IF
       INSERT INTO snc_file (snc01,snc02,snc03,snc08,snc12,snc05,snc06,sncplant,snclegal) #FUN-980008 add
                      VALUES(g_snb.snb01,g_snb.snb02,'','','',
                             l_snc[i].snc05,l_snc[i].snc06,g_plant,g_legal)               #FUN-980008 add
       IF STATUS THEN 
           CALL cl_err3("ins","snc_file",g_snb.snb01,g_snb.snb02,STATUS,"","ins snc",1)   #No.FUN-660128
       END IF
   END FOR
 
END FUNCTION
 
FUNCTION t802_sub()
 
   CALL t802_s()               #一般替代
   CALL t802_b_fill('1=1')
 
END FUNCTION
 
FUNCTION t802_s()
   DEFINE old_part              LIKE ima_file.ima01   #No.MOD-490217
   DEFINE old_sfa08             LIKE sfa_file.sfa08
   DEFINE old_sfa26		LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   DEFINE old_sfa12		LIKE sfa_file.sfa12
   DEFINE old_sfa13		LIKE sfa_file.sfa13
   DEFINE old_sfa27		LIKE sfa_file.sfa27          #No.FUN-870051 
   DEFINE i,j	         	LIKE type_file.num5          #No.FUN-680121 SMALLINT
   DEFINE old_qty,left_qty	LIKE type_file.num10         #No.FUN-680121 INTEGER
   DEFINE l_sql                 LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(2000)
   DEFINE l_sna RECORD LIKE sna_file.*
   DEFINE l_sfa RECORD LIKE sfa_file.*
   DEFINE l_bmd05,l_bmd06	LIKE type_file.dat           #No.FUN-680121 DATE
   DEFINE pri                   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
   DEFINE n_sna28a              LIKE sna_file.sna28a
   DEFINE n_sna05a              LIKE sna_file.sna05a
   DEFINE x_sna161              LIKE sna_file.sna161a
   DEFINE l_ima25               LIKE ima_file.ima25
   DEFINE l_ima70               LIKE ima_file.ima70
   DEFINE l_tot	                LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3) 
   DEFINE l_qty51               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE l_qty52               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE l_qty53               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE l_qty54               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE l_qty55               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE l_qty56               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE l_qty61               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE l_qty62               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE l_qty63               LIKE sfa_file.sfa05          #No.FUN-680121 DECIMAL(13,3)
   DEFINE new DYNAMIC ARRAY OF RECORD
           new_part		LIKE ima_file.ima01,  #No.MOD-490217
          new_rate		LIKE sna_file.sna28b,         #No.FUN-680121 DECIMAL(6,3)
          new_yes 		LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          new_qty 		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty3		LIKE type_file.num10,         #No.FUN-680121 INTEGER
#         ima262                LIKE ima_file.ima262,
          avl_stk     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          new_qty4		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty5		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty6		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty7		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty8		LIKE type_file.num10          #No.FUN-680121 INTEGER
          END RECORD
   DEFINE sr RECORD
           new_part		LIKE ima_file.ima01, #No.MOD-490217
          new_rate		LIKE sna_file.sna28b,         #No.FUN-680121 DECIMAL(6,3)
          new_yes 		LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          new_qty 		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty3		LIKE type_file.num10,         #No.FUN-680121 INTEGER
#         ima262                LIKE ima_file.ima262,
          avl_stk     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          new_qty4		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty5		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty6		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty7		LIKE type_file.num10,         #No.FUN-680121 INTEGER
          new_qty8		LIKE type_file.num10          #No.FUN-680121 INTEGER
          END RECORD,
          l_i,l_n               LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044  
 
   OPEN WINDOW t802_sw AT 2,2
        WITH FORM "asf/42f/asft802s"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asft802s")
 
   LET old_sfa08 = ' '
 
   WHILE TRUE
      INPUT BY NAME old_part,old_sfa08 WITHOUT DEFAULTS
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE INPUT
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
      END INPUT
      IF INT_FLAG THEN
         LET INT_FLAG=0
         CLOSE WINDOW t802_sw
         EXIT WHILE
      END IF
      IF old_part IS NULL THEN
         CLOSE WINDOW t802_sw
         EXIT WHILE
      END IF
 
 
      INITIALIZE l_sna.* TO NULL
      INITIALIZE l_sfa.* TO NULL
      SELECT * INTO l_sna.* FROM sna_file
       WHERE sna01 = g_sfb.sfb01 AND sna02 = g_snb.snb02
         AND sna03a= old_part    AND sna08a= old_sfa08
      IF STATUS THEN
         SELECT * INTO l_sna.* FROM sna_file
          WHERE sna01 = g_sfb.sfb01 AND sna02 = g_snb.snb02
            AND sna03b= old_part    AND sna08b= old_sfa08
         IF STATUS THEN
            SELECT * INTO l_sfa.* FROM sfa_file
             WHERE sfa01 = g_sfb.sfb01
               AND sfa03 = old_part AND sfa08 = old_sfa08
            IF STATUS THEN
               CALL cl_err3("sel","sfa_file",g_sfb.sfb01,old_part,STATUS,"","sel sfa/sna",1)  #No.FUN-660128
                 CONTINUE WHILE   
            END IF
         END IF
      END IF
 
      IF NOT cl_null(l_sna.sna10) AND l_sna.sna10 MATCHES '[123]' THEN
         IF NOT cl_null(l_sna.sna03a) THEN
            LET l_sfa.sfa03 = l_sna.sna03a
         ELSE
            LET l_sfa.sfa03 = l_sna.sna03b
         END IF
         IF NOT cl_null(l_sna.sna05a) THEN
            LET l_sfa.sfa05 = l_sna.sna05a
         ELSE
            LET l_sfa.sfa05 = l_sna.sna05b
         END IF
         IF NOT cl_null(l_sna.sna06a) THEN
            LET l_sfa.sfa06 = l_sna.sna06a
         ELSE
            LET l_sfa.sfa06 = l_sna.sna06b
         END IF
         IF NOT cl_null(l_sna.sna26a) THEN
            LET l_sfa.sfa26 = l_sna.sna26a
         ELSE
            LET l_sfa.sfa26 = l_sna.sna26b
         END IF
         IF NOT cl_null(l_sna.sna08a) THEN
            LET l_sfa.sfa08 = l_sna.sna08a
         ELSE
            LET l_sfa.sfa08 = l_sna.sna08b
         END IF
         IF NOT cl_null(l_sna.sna12a) THEN
            LET l_sfa.sfa12 = l_sna.sna12a
         ELSE
            LET l_sfa.sfa12 = l_sna.sna12b
         END IF
         IF NOT cl_null(l_sna.sna13a) THEN
            LET l_sfa.sfa13 = l_sna.sna13a
         ELSE
            LET l_sfa.sfa13 = l_sna.sna13b
         END IF
         IF NOT cl_null(l_sna.sna161a) THEN
            LET l_sfa.sfa161 = l_sna.sna161a
         ELSE
            LET l_sfa.sfa161 = l_sna.sna161b
         END IF
         IF cl_null(l_sfa.sfa29) THEN LET l_sfa.sfa29 = g_sfb.sfb05 END IF
      END IF
      LET l_sfa.sfa27 = l_sfa.sfa03
      LET left_qty = l_sfa.sfa05
      LET old_qty = l_sfa.sfa05 - l_sfa.sfa06
    # 此應發量為 生產數量  * QPA
      DISPLAY BY NAME l_sfa.sfa26,old_qty,l_sfa.sfa12
      IF l_sfa.sfa26 NOT MATCHES '[123478]' THEN           #FUN-A20037 add '7,8'
         CALL cl_err('','mfg6201',0) CONTINUE WHILE
      END IF
      IF old_qty <=0 THEN CALL cl_err('','mfg6181',0) CONTINUE WHILE END IF
      LET old_sfa12=l_sfa.sfa12
      LET old_sfa13=l_sfa.sfa13
      LET old_sfa26=l_sfa.sfa26
      LET old_sfa27=l_sfa.sfa27   #No.FUN-870051
 
      CALL new.clear()
 
      LET l_tot = 0
      LET i = 1
 
     ##############################程式邏輯說明###############################
     ##一、取替資料的來源有: 1.工單變更單身檔(sna_file)                     ##
     ##                      2.工單備料檔    (sfa_file)                     ##
     ##                      3.取替代檔      (bmd_file)                     ##
     ##二、取替代資料不可重覆抓取，資料以(sna_file)為主，若無抓(sfa_file)   ##
     ##    ，若(sfa_file)抓取(bmd_file)，因此優先順序為1->2->3              ##
     #########################################################################
 
      CALL create_sub_temp()
 
      LET l_sql=
#      "SELECT '1',sna03a,sna28a,'N',0,0,ima262,sna05a,0,0,0,0 ", #NO.FUN-A20044
       "SELECT '1',sna03a,sna28a,'N',0,0,0,sna05a,0,0,0,0 ",      #NO.FUN-A20044
         "FROM sna_file LEFT OUTER JOIN ima_file ON sna03a = ima01 ",    #No.TQC-9B0016 mod
        "WHERE sna01 = '",g_snb.snb01 CLIPPED,
        "' AND sna02 =  ",g_snb.snb02 CLIPPED,
        "  AND sna27a= '",old_part CLIPPED,
        "' AND sna08a= '",l_sfa.sfa08 CLIPPED,
        "' AND sna12a= '",l_sfa.sfa12 CLIPPED,
        "  AND sna26a IN ('S','U') ",
        " UNION ",
#      "SELECT '2',sna03b,sna28b,'N',0,0,ima262,sna05b,0,0,0,0 ", #NO.FUN-A20044 
       "SELECT '2',sna03b,sna28b,'N',0,0,0,sna05b,0,0,0,0 ",      #NO.FUN-A20044 
         "FROM sna_file LEFT OUTER JOIN ima_file ON sna03b = ima01 ",    #NO.TQC-9B0016 mod
        "WHERE sna01 = '",g_snb.snb01 CLIPPED,
        "' AND sna02 = ",g_snb.snb02 CLIPPED,
        "  AND sna27b= '",old_part CLIPPED,
        "' AND sna08b= '",l_sfa.sfa08 CLIPPED,
        "' AND sna12b= '",l_sfa.sfa12 CLIPPED,
        "  AND (sna26a IN ('S','U') OR ",
        " ((sna26a IS NULL OR sna26a = ' ') AND sna26b IN ('S','U'))) ",
        " UNION ",
#      "SELECT '3',sfa03,sfa28,'N',0,0,ima262,sfa05,0,0,0,0 ",    #NO.FUN-A20044  
       "SELECT '3',sfa03,sfa28,'N',0,0,0,sfa05,0,0,0,0 ",    #NO.FUN-A20044 
         "FROM sfa_file LEFT OUTER JOIN ima_file ON sfa03 = ima01  ",     #No.TQC-9B0016 mod
        "WHERE sfa01 = '",g_snb.snb01 CLIPPED,
        "' AND sfa27 = '",old_part CLIPPED,
        "' AND sfa08 = '",l_sfa.sfa08 CLIPPED,
        "' AND sfa12 = '",l_sfa.sfa12 CLIPPED,
        "  AND sfa26 IN ('S','U','Z') ",   #FUN-A20037 add Z
        "  ORDER BY 1,2 "
 
      PREPARE t802_sub_pre FROM l_sql
      IF SQLCA.sqlcode THEN
         CALL cl_err('t802_sub_pre',STATUS,1)
         CONTINUE WHILE
      END IF
      DECLARE t802_sub_cs CURSOR FOR t802_sub_pre
      IF SQLCA.sqlcode THEN
         CALL cl_err('t802_sub_cs',STATUS,1)
         CONTINUE WHILE
      END IF
 
      FOREACH t802_sub_cs INTO pri,sr.*
           IF STATUS THEN
              CALL cl_err('foreach',STATUS,0) CONTINUE WHILE
           END IF
           SELECT COUNT(*) INTO g_cnt FROM sub_temp
            WHERE new_part = sr.new_part
           IF g_cnt > 0 THEN  #資料已重覆
              CONTINUE FOREACH
           END IF
           #修改時替代率與替代數量有可能已經變更過了
           #因此要以新的資料為主
           IF pri='2' THEN
              SELECT sna28a,sna05a INTO n_sna28a,n_sna05a FROM sna_file
               WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
                 AND sna03b = sr.new_part
                 AND sna08b= l_sfa.sfa08 AND sna12b = l_sfa.sfa12
                 AND (sna26a IN ('S','U') OR
                     ((sna26a IS NULL OR sna26a = ' ')
                            AND sna26b IN ('S','U')))
              IF NOT cl_null(n_sna28a) THEN LET sr.new_rate = n_sna28a END IF
              IF NOT cl_null(n_sna05a) THEN LET sr.new_qty4 = n_sna05a END IF
           END IF
           IF sr.new_rate = 0 THEN LET sr.new_rate = 1 END IF
           LET l_tot = l_tot + sr.new_qty4 / sr.new_rate  #計算己替代總合
           INSERT INTO sub_temp VALUES (sr.*)
           LET new[i].* = sr.*
           LET i = i + 1
      END FOREACH
 
      #其它取替代資料也一併帶出
      DECLARE t802_sc CURSOR FOR
#        SELECT bmd04,bmd07,'N',0,0,ima262,0,0,0,0,0,bmd03,bmd05,bmd06  #NO.FUN-A20044
         SELECT bmd04,bmd07,'N',0,0,0,0,0,0,0,0,bmd03,bmd05,bmd06       #NO.FUN-A20044
           FROM bmd_file,OUTER ima_file
          WHERE bmd01 = old_part
            AND (bmd08= l_sfa.sfa29 OR bmd08='ALL')
            AND bmd04=ima01
            AND bmdacti = 'Y'                                           #CHI-910021
      FOREACH t802_sc INTO sr.*,j,l_bmd05,l_bmd06
         IF STATUS THEN CALL cl_err('foreach',STATUS,0) CONTINUE WHILE END IF
         CALL s_getstock(sr.new_part,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
         LET sr.avl_stk = l_n3  
         SELECT COUNT(*) INTO g_cnt FROM sub_temp
          WHERE new_part = sr.new_part
         IF g_cnt > 0 THEN CONTINUE FOREACH END IF  #資料已重覆
         IF l_bmd05     > g_sfb.sfb071 THEN CONTINUE FOREACH END IF
         IF g_sfb.sfb071>=l_bmd06      THEN CONTINUE FOREACH END IF
         IF sr.new_rate = 0 THEN LET sr.new_rate = 1 END IF
         INSERT INTO sub_temp VALUES (sr.*)
         LET new[i].* = sr.*
         LET i = i + 1
      END FOREACH
 
      IF i = 0 THEN CALL cl_err('','mfg6201',0) CONTINUE WHILE END IF
 
      LET l_i=i-1
 
      DISPLAY l_i   TO FORMONLY.rec
      DISPLAY BY NAME l_tot
 
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY new WITHOUT DEFAULTS FROM s_new.*
            ATTRIBUTE(COUNT=l_i,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
         AFTER FIELD new_qty
            LET i = ARR_CURR()
            IF new[i].new_qty < 0 THEN
               IF (new[i].new_qty*(-1)) > new[i].new_qty4 THEN
                  LET new[i].new_qty=0 NEXT FIELD new_qty
               END IF
            END IF
            IF new[i].new_yes = 'N' THEN LET new[i].new_qty = 0 END IF
            LET new[i].new_qty3 = new[i].new_qty / new[i].new_rate
 
          #---->在途量(供給)**********************************************
            #---->請購量
            SELECT SUM((pml20-pml21)*pml09) INTO l_qty51
              FROM pmk_file,pml_file
             WHERE pml04  = new[i].new_part
               AND pml01  = pmk01
               AND pml20  > pml21
               AND pml16  <='2'
               AND pml011 !='SUB'
               AND pmk18  != 'X'
            IF l_qty51 IS NULL THEN LET l_qty51=0 END IF
 
            #---->採購量
            SELECT SUM((pmn20-pmn50+pmn55+pmn58)*pmn09) INTO l_qty52 #FUN-940083 
              FROM pmn_file, pmm_file
             WHERE pmn04  = new[i].new_part
               AND pmn01  = pmm01
               AND pmn20  > pmn50-pmn55-pmn58 #No.FUN-9A0068   
               AND pmn16  <='2'
               AND pmn011 !='SUB'
               AND pmm18  != 'X'
            IF l_qty52 IS NULL THEN LET l_qty52=0 END IF
 
            #---->工單在製量
            SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
              INTO l_qty53
              FROM sfb_file,ima_file
             WHERE sfb05 = ima01
               AND sfb05 = new[i].new_part
               AND sfb04 < '8'
               AND sfb02 <>'7'
               AND sfb08 > (sfb09+sfb11+sfb12)
               AND sfb87 !='X'
            IF l_qty53 IS NULL THEN LET l_qty53=0 END IF
 
            #---->委外在製量
            SELECT SUM((sfb08-sfb09-sfb10-sfb11-sfb12)*ima55_fac)
              INTO l_qty55
              FROM sfb_file,ima_file
             WHERE sfb05 =  ima01
               AND sfb05 =  new[i].new_part
               AND sfb04 <  '8'
               AND sfb02 =  '7'
               AND sfb08 >  (sfb09+sfb10+sfb11+sfb12)
               AND sfb87 != 'X'
            IF l_qty55 IS NULL THEN LET l_qty55=0 END IF
 
            #---->IQC在驗量
            SELECT SUM((rvb07-rvb29-rvb30)*pmn09) INTO l_qty54
              FROM rvb_file, rva_file, pmn_file
             WHERE rvb05 = new[i].new_part
               AND rvb01 = rva01
               AND rvb04 = pmn01
               AND rvb03 = pmn02
               AND rvb07 > (rvb29+rvb30)
               AND rvaconf='Y'
            IF l_qty54 IS NULL THEN LET l_qty54=0 END IF
 
            #---->FQC 在驗量
            SELECT SUM(sfb11) INTO l_qty56
              FROM sfb_file
             WHERE sfb05 =  new[i].new_part
               AND sfb02 <> '7'
               AND sfb87 != 'X'
               AND sfb04 <  '8'
            IF l_qty56 IS NULL THEN LET l_qty56=0 END IF
 
            LET new[i].new_qty5=l_qty51+l_qty52+l_qty53+l_qty54+l_qty55+l_qty56
 
          #---->在途量(需求)*********************************************
            #---->受訂量
            SELECT SUM((oeb12-oeb24)*oeb05_fac) INTO l_qty61
              FROM oeb_file, oea_file
             WHERE oeb04   = new[i].new_part
               AND oeb01   = oea01
               AND oea00   <>'0'
               AND oeb70   = 'N'
               AND oeb12   > oeb24
               AND oeaconf != 'X'
            IF l_qty61 IS NULL THEN LET l_qty61=0 END IF
 
            #---->工單備料量 & 工單缺料量
            SELECT SUM((sfa05-sfa06-sfa07)*sfa13),SUM(sfa07*sfa13)
              INTO l_qty62,l_qty63
              FROM sfb_file,sfa_file
             WHERE sfa03 = new[i].new_part
               AND sfb01 = sfa01
               AND sfb04 !='8'
               AND sfb87 !='X'
               AND ((sfa05 > (sfa06+sfa07)) OR (sfa07 > 0))
            IF l_qty62 IS NULL THEN LET l_qty62=0 END IF
            IF l_qty63 IS NULL THEN LET l_qty63=0 END IF
            LET new[i].new_qty6 = l_qty61+l_qty62+l_qty63
 
            #---->出貨備置量(alocated)
            SELECT SUM(oeb905*oeb05_fac) INTO new[i].new_qty7 #no.7182
              FROM oeb_file, oea_file, occ_file
             WHERE oeb04 = new[i].new_part
               AND oeb01 = oea01
               AND oea00 <> '0'
               AND oeb19 = 'Y'
               AND oeb70 = 'N'
               AND oeb12 > oeb24
               AND oea03 = occ01
            IF new[i].new_qty7 IS NULL THEN LET new[i].new_qty7=0 END IF
            CALL s_getstock(new[i].new_part,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044 
            LET new[i].avl_stk = l_n3                                   #NO.FUN-A20044
            #---->可用量
            LET new[i].new_qty8
#               =new[i].ima262 + new[i].new_qty5 - new[i].new_qty6      #NO.FUN-A20044
                =new[i].avl_stk + new[i].new_qty5 - new[i].new_qty6     #NO.FUN-A20044
            DISPLAY new[i].new_qty5 TO s_new[j].new_qty5
            DISPLAY new[i].new_qty6 TO s_new[j].new_qty6
            DISPLAY new[i].new_qty7 TO s_new[j].new_qty7
            DISPLAY new[i].new_qty8 TO s_new[j].new_qty8
            LET l_tot = 0
   ###折和量累加
            FOR i = 1 TO new.getLength()
               IF new[i].new_part IS NOT NULL AND
                  new[i].new_yes = "Y" OR new[i].new_qty4 > 0 THEN
                  LET l_tot = l_tot + new[i].new_qty3
                                    + ( new[i].new_qty4 / new[i].new_rate )
               END IF
            END FOR
            DISPLAY BY NAME l_tot
 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG=0
               EXIT INPUT
            END IF
 
            LET g_success = 'Y'
 
            BEGIN WORK
 
            LET l_tot = 0
            CALL s_showmsg_init()   #No.FUN-8A0086
            FOR i = 1 TO new.getLength()
               IF g_success='N' THEN                                                                                                          
                  LET g_totsuccess='N'                                                                                                       
                  LET g_success="Y"                                                                                                          
               END IF                    
 
               IF new[i].new_part IS NOT NULL AND
                  new[i].new_yes = "Y" OR new[i].new_qty4 > 0 THEN
                  LET l_tot = l_tot + new[i].new_qty3
                                    +  ( new[i].new_qty4 / new[i].new_rate )
                  INITIALIZE l_sna.* TO NULL
                  INITIALIZE l_sfa.* TO NULL
                  #判斷是否原來有資料
                  SELECT * INTO l_sna.* FROM sna_file
                   WHERE sna01 = g_snb.snb01     AND sna02 = g_snb.snb02
                     AND sna03a= new[i].new_part AND sna08a= old_sfa08
                     AND sna12a= old_sfa12
                  IF STATUS THEN
                     SELECT * INTO l_sna.* FROM sna_file
                      WHERE sna01 = g_snb.snb01     AND sna02 = g_snb.snb02
                        AND sna03b= new[i].new_part AND sna08b= old_sfa08
                        AND sna12b= old_sfa12
                     IF STATUS THEN
                        SELECT * INTO l_sfa.* FROM sfa_file
                         WHERE sfa01 = g_snb.snb01
                           AND sfa03 = new[i].new_part AND sfa08 = old_sfa08
                           AND sfa12 = old_sfa12
                           AND sfa27 = old_sfa27    #No.FUN-870051 
                     END IF
                  END IF
 
                  IF old_sfa26 MATCHES '[13]' THEN
                     LET l_sna.sna26a= 'U'
                  ELSE
#FUN-A20037 add begin--
                     IF old_sfa26 MATCHES '[78]' THEN
                        LET l_sna.sna26a = 'Z'
                     ELSE
#FUN-A20037 add end--
                        LET l_sna.sna26a= 'S'
                     END IF                        #FUN-A20037 add
                  END IF
                  IF NOT cl_null(l_sna.sna04) THEN  #表原來有資料(sna_file)
                     LET l_sna.sna05a  = new[i].new_qty + new[i].new_qty4
                     LET l_sna.sna28a  = new[i].new_rate
                     IF NOT cl_null(l_sna.sna05b) THEN
                        CALL t802_cal_qty(l_sna.sna05b,l_sna.sna05a,
                                          l_sna.sna06b,l_sna.sna062b,
                                          l_sna.sna07b,l_sna.sna065b)   #No.MOD-930172 add
                             RETURNING l_sna.sna06a,l_sna.sna062a,
                                       l_sna.sna07a,l_sna.sna161a
                        LET l_sna.sna161a = 0
                     END IF
                  ELSE
                     LET l_sna.sna01 = g_snb.snb01
                     LET l_sna.sna02 = g_snb.snb02
                     LET l_sna.sna022= g_snb.snb022
                     LET l_sna.sna10 = '3'   #取替代-自動產生
                     SELECT MAX(sna04)+1 INTO l_sna.sna04 FROM sna_file
                      WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
                     IF cl_null(l_sna.sna04) THEN LET l_sna.sna04 = 1 END IF
                     IF NOT cl_null(l_sfa.sfa03) THEN #表原來有(sfa_file)
                        LET l_sna.sna03b  = l_sfa.sfa03
                        LET l_sna.sna05b  = l_sfa.sfa05
                        LET l_sna.sna06b  = l_sfa.sfa06
                        LET l_sna.sna06b  = l_sfa.sfa06
                        LET l_sna.sna062b = l_sfa.sfa062
                        LET l_sna.sna065b = l_sfa.sfa065
                        LET l_sna.sna07b  = l_sfa.sfa07
                        LET l_sna.sna08b  = l_sfa.sfa08
                        LET l_sna.sna100b = l_sfa.sfa100
                        LET l_sna.sna11b  = l_sfa.sfa11
                        LET l_sna.sna12b  = l_sfa.sfa12
                        LET l_sna.sna13b  = l_sfa.sfa13
                        LET l_sna.sna161b = l_sfa.sfa161
                        LET l_sna.sna26b  = l_sfa.sfa26
                        LET l_sna.sna27b  = l_sfa.sfa27
                        LET l_sna.sna28b  = l_sfa.sfa28
                        LET l_sna.sna30b  = l_sfa.sfa30
                        LET l_sna.sna31b  = l_sfa.sfa31
                        LET l_sna.sna05a  = new[i].new_qty + new[i].new_qty4
                        LET l_sna.sna28a  = new[i].new_rate
                        CALL t802_cal_qty(l_sna.sna05b,l_sna.sna05a,
                                          l_sna.sna06b,l_sna.sna062b,
                                          l_sna.sna07b,l_sna.sna065b)   #No.MOD-930172 add
                             RETURNING l_sna.sna06a,l_sna.sna062a,
                                       l_sna.sna07a,l_sna.sna161a
                        LET l_sna.sna161a = 0
                     ELSE                             #表為新增資料
                        LET l_sna.sna03b  = NULL
                        LET l_sna.sna05b  = NULL
                        LET l_sna.sna06b  = NULL
                        LET l_sna.sna06b  = NULL
                        LET l_sna.sna062b = NULL
                        LET l_sna.sna065b = NULL
                        LET l_sna.sna07b  = NULL
                        LET l_sna.sna08b  = NULL
                        LET l_sna.sna100b = NULL
                        LET l_sna.sna11b  = NULL
                        LET l_sna.sna12b  = NULL
                        LET l_sna.sna13b  = NULL
                        LET l_sna.sna161b = NULL
                        LET l_sna.sna26b  = NULL
                        LET l_sna.sna27b  = NULL
                        LET l_sna.sna28b  = NULL
                        LET l_sna.sna30b  = NULL
                        LET l_sna.sna31b  = NULL
                        LET l_sna.sna03a  = new[i].new_part
                        LET l_sna.sna05a  = new[i].new_qty + new[i].new_qty4
                        LET l_sna.sna06a  = 0
                        LET l_sna.sna062a = 0
                        LET l_sna.sna065a = 0
                        LET l_sna.sna07a  = 0
                        LET l_sna.sna08a  = old_sfa08
                        LET l_sna.sna100a = 0
                        SELECT ima70,ima25 INTO l_ima70,l_ima25 FROM ima_file
                         WHERE ima01 = l_sna.sna03a
                        IF l_ima70 = 'Y' THEN
                           LET l_sna.sna11a = 'E'
                        ELSE
                           LET l_sna.sna11a = 'N'
                        END IF
                        LET l_sna.sna12a  = old_sfa12
                        LET l_sna.sna13a  = old_sfa13
                        LET l_sna.sna161a = 0
                        LET l_sna.sna27a  = old_part
                        LET l_sna.sna28a  = new[i].new_rate
                     END IF
                  END IF
               #FUN-910088--add--start--
                  LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12a)
                  LET l_sna.sna06a = s_digqty(l_sna.sna06a,l_sna.sna12a)
                  LET l_sna.sna062a = s_digqty(l_sna.sna062a,l_sna.sna12a)
                  LET l_sna.sna07a = s_digqty(l_sna.sna07a,l_sna.sna12a)
               #FUN-910088--add--end-- 
                  #若變更前與變更後資料相同，將變更後資料清空
                  IF l_sna.sna26a = l_sna.sna26b THEN
                     LET l_sna.sna26a = ''
                  END IF
                  IF l_sna.sna28a = l_sna.sna28b THEN
                     LET l_sna.sna28a = ''
                  END IF
 
                  LET l_sna.snaplant = g_plant #FUN-980008 add
                  LET l_sna.snalegal = g_legal #FUN-980008 add
 
                  INSERT INTO sna_file VALUES (l_sna.*)
                  IF SQLCA.SQLCODE THEN
                     IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-790021
                        UPDATE sna_file SET * = l_sna.*
                         WHERE sna01 = g_snb.snb01
                           AND sna02 = g_snb.snb02
                           AND sna04 = l_sna.sna04
                         IF SQLCA.SQLCODE THEN
                            LET g_showmsg=g_snb.snb01,"/",g_snb.snb02,"/",l_sna.sna04                        #NO.FUN-710026
                            CALL s_errmsg('sna01,sna02,sna04',g_showmsg,'update sfa',STATUS,1)               #NO.FUN-710026
                            LET g_success ='N' 
                            CONTINUE FOR                                                                     #NO.FUN-710026
                         END IF
                     ELSE
                       LET g_showmsg=g_snb.snb01,"/",g_snb.snb02,"/",l_sna.sna04                             #NO.FUN-710026
                       CALL s_errmsg('sna01,sna02,sna04',g_showmsg,'update sfa',STATUS,1)                    #NO.FUN-710026
                       LET g_success ='N' 
                       CONTINUE FOR                                                                          #NO.FUN-710026   
                    END IF
                  END IF
               END IF
            END FOR
           IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
              END IF 
 
            DISPLAY BY NAME l_tot
            IF g_success = 'Y' THEN
               IF l_tot > old_qty
                  THEN CALL s_errmsg('','','','mfg6202',1)  LET g_success = 'N'          #NO.FUN-710026
               ELSE
                  IF l_tot != 0 THEN
                     #修改被取替代的料號的替代碼、替代數量
                     LET left_qty = old_qty  - l_tot  #用應發數去減
                     IF old_sfa26='1' THEN LET old_sfa26='3' END IF
                     IF old_sfa26='2' THEN LET old_sfa26='4' END IF
                     IF old_sfa26='7' THEN LET old_sfa26='8' END IF   #FUN-A20037 add
                     INITIALIZE l_sna.* TO NULL
                     INITIALIZE l_sfa.* TO NULL
                     SELECT * INTO l_sna.* FROM sna_file
                      WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
                        AND sna03a= old_part    AND sna08a= old_sfa08
                     IF STATUS = 100 THEN
                        SELECT * INTO l_sna.* FROM sna_file
                         WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
                           AND sna03b= old_part    AND sna08b= old_sfa08
                     END IF
                     IF NOT cl_null(l_sna.sna04) THEN
                        LET l_sna.sna05a = left_qty
                        LET l_sna.sna26a = old_sfa26
                        IF l_sna.sna10 = '3' THEN
                           CALL t802_cal_qty(l_sna.sna05b,l_sna.sna05a,
                                             l_sna.sna06b,l_sna.sna062b,
                                             l_sna.sna07b,l_sna.sna065b)  #No.MOD-930172 add
                                RETURNING l_sna.sna06a,l_sna.sna062a,
                                          l_sna.sna07a,x_sna161
                        END IF
                    #FUN-910088--add--start--
                        LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12a)
                        LET l_sna.sna06a = s_digqty(l_sna.sna06a,l_sna.sna12a)
                        LET l_sna.sna062a = s_digqty(l_sna.sna062a,l_sna.sna12a)
                        LET l_sna.sna07a = s_digqty(l_sna.sna07a,l_sna.sna12a)
                    #FUN-910088--add--end-- 
                        IF l_sna.sna26a = l_sna.sna26b THEN
                           LET l_sna.sna26a = ''
                        END IF
                        UPDATE sna_file SET sna_file.* = l_sna.*
                         WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
                           AND sna04 = l_sna.sna04
                         IF STATUS THEN
                          LET g_showmsg=g_snb.snb01,"/",g_snb.snb02,"/",l_sna.sna04                 #NO.FUN-710026  
                          CALL s_errmsg('sna01,sna02,sna04',g_showmsg,'upd sfa',STATUS,1)           #NO.FUN-710026
                           LET g_success ='N'
                        END IF
                     ELSE
                        SELECT * INTO l_sfa.* FROM sfa_file
                         WHERE sfa01 = g_snb.snb01
                           AND sfa03 = old_part
                           AND sfa08 = old_sfa08
                        IF STATUS THEN
                           LET  g_showmsg=g_snb.snb01,"/",old_part,"/",old_sfa08                       #NO.FUN-710026
                           CALL s_errmsg('sfa01,sfa03,sfa08',g_showmsg,'sel sfa:',STATUS,1)            #NO.FUN-710026 
                           LET g_success = 'N'
                        ELSE
                          LET l_sna.sna01   = g_snb.snb01
                          LET l_sna.sna02   = g_snb.snb02
                          LET l_sna.sna022  = g_snb.snb022
                          SELECT MAX(sna04)+1 INTO l_sna.sna04
                            FROM sna_file
                           WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
                          IF cl_null(l_sna.sna04) THEN
                             LET l_sna.sna04 = 1
                          END IF
                          LET l_sna.sna10   = '3'  #修改
                          LET l_sna.sna03b  = l_sfa.sfa03
                          LET l_sna.sna05b  = l_sfa.sfa05
                          LET l_sna.sna06b  = l_sfa.sfa06
                          LET l_sna.sna06b  = l_sfa.sfa06
                          LET l_sna.sna062b = l_sfa.sfa062
                          LET l_sna.sna065b = l_sfa.sfa065
                          LET l_sna.sna07b  = l_sfa.sfa07
                          LET l_sna.sna08b  = l_sfa.sfa08
                          LET l_sna.sna100b = l_sfa.sfa100
                          LET l_sna.sna11b  = l_sfa.sfa11
                          LET l_sna.sna12b  = l_sfa.sfa12
                          LET l_sna.sna13b  = l_sfa.sfa13
                          LET l_sna.sna161b = l_sfa.sfa161
                          LET l_sna.sna26b  = l_sfa.sfa26
                          LET l_sna.sna27b  = l_sfa.sfa27
                          LET l_sna.sna28b  = l_sfa.sfa28
                          LET l_sna.sna30b  = l_sfa.sfa30
                          LET l_sna.sna31b  = l_sfa.sfa31
                          LET l_sna.sna05a = left_qty
                          LET l_sna.sna26a = old_sfa26
                          LET l_sna.sna161a= ''
                          CALL t802_cal_qty(l_sna.sna05b,l_sna.sna05a,
                                            l_sna.sna06b,l_sna.sna062b,
                                            l_sna.sna07b,l_sna.sna065b)   #No.MOD-930172 add
                             RETURNING l_sna.sna06a,l_sna.sna062a,
                                       l_sna.sna07a,x_sna161
                        #FUN-910088--add--start--
                          LET l_sna.sna05a = s_digqty(l_sna.sna05a,l_sna.sna12b)
                          LET l_sna.sna06a = s_digqty(l_sna.sna06a,l_sna.sna12b)
                          LET l_sna.sna062a = s_digqty(l_sna.sna062a,l_sna.sna12b)
                          LET l_sna.sna07a = s_digqty(l_sna.sna07a,l_sna.sna12b)
                        #FUN-910088--add--end-- 
                          IF l_sna.sna26a = l_sna.sna26b THEN
                             LET l_sna.sna26a = ''
                          END IF   
                          LET l_sna.snaplant = g_plant #FUN-980008 add
                          LET l_sna.snalegal = g_legal #FUN-980008 add
                          INSERT INTO sna_file VALUES (l_sna.*)
                          IF STATUS THEN
                             LET g_showmsg=g_snb.snb01,"/",g_snb.snb02                                      #NO.FUN-710026
                             CALL s_errmsg( 'sna01,sna02',g_showmsg,'ins sna:',STATUS,1)                    #NO.FUN-710026
                             LET g_success = 'N'
                          END IF
                        END IF
                     END IF
                  END IF
               END IF
            END IF
            CALL t802_short(old_part,old_sfa08)      # 計算欠料量
            CALL t802_re_order()                     #項次重排
            CALL s_showmsg()                         #NO.FUN-710026 
            IF g_success = 'Y' THEN
               COMMIT WORK
               CALL cl_cmmsg(1)
            ELSE
               ROLLBACK WORK
               CALL cl_rbmsg(1)
               NEXT FIELD new_yes
            END IF
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      END INPUT
      CLEAR FORM
   CALL g_sna.clear()
      CALL new.clear()
 
   END WHILE
 
END FUNCTION
 
FUNCTION t802_short(p_part,p_sfa08)  # 計算欠料量
 DEFINE p_part      LIKE sfa_file.sfa03,
        p_sfa08     LIKE sfa_file.sfa08
 DEFINE l_sna       RECORD LIKE sna_file.*
 DEFINE x_sna       RECORD LIKE sna_file.*
 DEFINE l_qty       LIKE sfa_file.sfa05        #No.FUN-680121 DEC(15,3)
 DEFINE short_qty   LIKE sfa_file.sfa05        #No.FUN-680121 DEC(15,3)
 DEFINE l_short_qty LIKE sfa_file.sfa05        #No.FUN-680121 DEC(15,3)
 DEFINE chk         LIKE type_file.chr1        #No.FUN-680121 VARCHAR(1)
 DEFINE l_sna06     LIKE sna_file.sna06a
 DEFINE t_sna06a    LIKE sna_file.sna06a
 DEFINE l_sna161    LIKE sna_file.sna161a
 DEFINE l_sna03     LIKE sna_file.sna03a
 DEFINE l_sna04     LIKE sna_file.sna04
 
   SELECT * INTO l_sna.*
     FROM sna_file
    WHERE sna01 = g_snb.snb01
      AND sna02 = g_snb.snb02
      AND sna03a= p_part
      AND sna08a= p_sfa08
   IF SQLCA.sqlcode OR STATUS THEN
      SELECT * INTO l_sna.*            #資料有可能是修改
        FROM sna_file
       WHERE sna01 = g_snb.snb01
         AND sna02 = g_snb.snb02
         AND sna03b= p_part
         AND sna08b= p_sfa08
      IF SQLCA.sqlcode OR STATUS THEN
         LET g_showmsg=g_snb.snb01,"/",g_snb.snb02,"/",p_part,"/",p_sfa08                    #NO.FUN-710026
         CALL s_errmsg('sna01,sna02,sna03b,sna08b',g_showmsg,'_short',SQLCA.sqlcode,1)       #NO.FUN-710026  
         LET g_success = 'N'
         RETURN                  
      END IF
   END IF
 
   #此組合的已發料量
   LET l_qty = 0
   LET short_qty = 0
   DECLARE short_cs CURSOR FOR
    SELECT '1',sna06a,sna04 FROM sna_file
     WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
       AND sna27a= p_part  AND sna08a= p_sfa08
     UNION
    SELECT '2',sna06b,sna04 FROM sna_file
     WHERE sna01 =g_snb.snb01 AND sna02 = g_snb.snb02
       AND sna27b = p_part AND sna08b = p_sfa08
       AND (sna27a IS NULL OR sna27a = ' ')
   FOREACH short_cs INTO chk,l_sna06,l_sna04
       IF chk='2' THEN
          select sna06a INTO t_sna06a from sna_file
           where sna01 = g_snb.snb01 and sna02 = g_snb.snb02
             and sna04 = l_sna04
          if not cl_null(t_sna06a) then let l_sna06 = t_sna06a end if
       END IF
       LET l_qty = l_qty + l_sna06
   END FOREACH
 
   IF NOT cl_null(l_sna.sna161a) THEN
      LET l_sna161 = l_sna.sna161a
   ELSE
      LET l_sna161 = l_sna.sna161b
   END IF
   IF NOT cl_null(l_sna.sna03a) THEN
      LET l_sna03 = l_sna.sna03a
   ELSE
      LET l_sna03 = l_sna.sna03b
   END IF
 
   LET short_qty = g_sfb.sfb081 * l_sna161 - l_qty
 
   #先將此組合欠料量清為零
   UPDATE sna_file
      SET sna07a= 0
    WHERE sna01 = g_snb.snb01
      AND sna02 = g_snb.snb02
      AND (sna27a= l_sna03 OR
          ((sna27a IS NULL OR sna27a=' ') AND sna27b=l_sna03))
 
   DECLARE upd_sfa07_curs1 CURSOR FOR
    SELECT * FROM sna_file
     WHERE sna01 = g_snb.snb01
       AND sna02 = g_snb.snb02
       AND (sna27a= l_sna03 OR
           ((sna27a IS NULL OR sna27a=' ') AND sna27b=l_sna03))
       AND sna05a <> sna05a
       AND sna05a > 0
     ORDER BY sna03a,sna03b
 
   IF cl_null(short_qty) THEN LET short_qty = 0 END IF
   FOREACH upd_sfa07_curs1 INTO x_sna.*
      IF short_qty = 0 THEN EXIT FOREACH END IF
      IF short_qty > x_sna.sna05a THEN
         LET l_short_qty = x_sna.sna05a - x_sna.sna06a
         LET short_qty = short_qty - x_sna.sna05a
      ELSE
         LET l_short_qty = short_qty
         LET short_qty   = 0
      END IF
      IF NOT cl_null(x_sna.sna03a) THEN  #表新增
         UPDATE sna_file
            SET sna07a= l_short_qty
          WHERE sna01 = g_snb.snb01
            AND sna02 = g_snb.snb02
            AND sna03a= x_sna.sna03a
            AND sna08a= x_sna.sna08a
            AND sna12a= x_sna.sna12a
      ELSE                               #修改
         UPDATE sna_file                 #FUN-BB0085 原程式是UPDATE sfa_file 
            SET sna07a= l_short_qty
          WHERE sna01 = g_snb.snb01
            AND sna02 = g_snb.snb02
            AND sna03b= x_sfa.sfa03b
            AND sna08b= x_sfa.sfa08b
            AND sna12b= x_sfa.sfa12b
      END IF
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         LET g_showmsg=g_snb.snb01,"/",g_snb.snb02                                                #NO.FUN-710026
         CALL s_errmsg('sna01,sna02',g_showmsg,'upd sna07a',SQLCA.sqlcode,1)                      #NO.FUN-710026 
         LET g_success = 'N'
      END IF
   END FOREACH
END FUNCTION
 
#項次重排
#重排的優先序  1.取替代為同一組的排在一起  2.變異方式一樣的排在一起
FUNCTION t802_re_order()
 DEFINE l_sna04  LIKE sna_file.sna04
 DEFINE l_sna27b LIKE sna_file.sna27a
 DEFINE l_sna    RECORD LIKE sna_file.*
 DEFINE i        LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   DROP TABLE x;
   SELECT * FROM sna_file
    WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
     INTO TEMP x
 
   DECLARE sna27_cs CURSOR FOR
    SELECT sna04,sna27b FROM x
     WHERE (sna27a IS NULL OR sna27a = ' ')
 
   FOREACH sna27_cs INTO l_sna04,l_sna27b
      UPDATE x SET sna27a = l_sna27b               #方便後面排序用
       WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
         AND sna04 = l_sna04
   END FOREACH
 
   DELETE FROM sna_file
    WHERE sna01 = g_snb.snb01 AND sna02 = g_snb.snb02
 
   LET i = 1
   DECLARE order_cs CURSOR FOR
    SELECT * FROM x ORDER BY sna27a,sna26b
 
   FOREACH order_cs INTO l_sna.*
        IF cl_null(l_sna.sna03a) THEN LET l_sna.sna27a = '' END IF
        LET l_sna.sna04 = i
        INSERT INTO sna_file VALUES (l_sna.*)
        IF STATUS OR SQLCA.SQLCODE THEN
           CALL s_errmsg('sna01,sna02,sna04','','order fail:',STATUS,1)                      #NO.FUN-710026
           LET g_success ='N' EXIT FOREACH
        END IF
        LET i = i + 1
  END FOREACH
 
END FUNCTION
 
#計算變更後已發、欠料、超領、QPA的量
FUNCTION t802_cal_qty(old_sfa05, new_sfa05,old_sfa06,old_sfa062,old_sfa07,old_sfa065)    #No.MOD-930172 add
  DEFINE old_sfa05  LIKE sfa_file.sfa05   #變更前應發
  DEFINE new_sfa05  LIKE sfa_file.sfa05   #變更後應發
  DEFINE old_sfa06  LIKE sfa_file.sfa06   #變更前已發
  DEFINE new_sfa06  LIKE sfa_file.sfa06   #變更後已發
  DEFINE old_sfa062 LIKE sfa_file.sfa062  #變更前超領
  DEFINE new_sfa062 LIKE sfa_file.sfa062  #變更後超領
  DEFINE old_sfa07  LIKE sfa_file.sfa07   #變更前欠料
  DEFINE new_sfa07  LIKE sfa_file.sfa07   #變更後欠料
  DEFINE new_qpa    LIKE sfa_file.sfa161  #QPA
  DEFINE old_qpa    LIKE sfa_file.sfa161  #QPA
  DEFINE save_sfa06 LIKE sfa_file.sfa06   #QPA變更後已發需求量
  DEFINE l_sfa06    LIKE sfa_file.sfa06   #變更數量(old應發-new已發)
  DEFINE old_sfa065 LIKE sfa_file.sfa065  #委外代買數量    #No.MOD-930172 add
 
  LET g_errno = ''
  LET new_sfa06 =0
  LET new_sfa062=0
  LET new_sfa07 =0
 
  #計算出新的QPA  = 變更後應發 / 生產套數
  LET new_qpa   = new_sfa05 / g_sfb.sfb08
  #計算出新的QPA已發量 = 已發套數 * 新的QPA
  LET save_sfa06= g_sfb.sfb081 * new_qpa
 
 #應發數量小於已發數量，是否將多出的已發數量歸"超領量" ? .............
  IF new_sfa05 < old_sfa06 THEN
     #MOD-C30605--begin--mark
#     IF NOT cl_confirm('asf-204') THEN
#        LET g_errno = 'asf-071'
#        RETURN old_sfa06,old_sfa062,old_sfa07,old_qpa
#     END IF
     LET g_errno = 'asf-071'
     RETURN old_sfa06,old_sfa062,old_sfa07,old_qpa
     #MOD-C30605--end
  END IF
 #new應發數量 < old 已發數量--> 表示變更後多的應轉為超領 .............
  IF new_sfa05 < old_sfa06 THEN
     LET l_sfa06 = old_sfa06 - new_sfa05
     LET new_sfa06 = new_sfa05
     LET new_sfa062 = old_sfa062 + l_sfa06  #超領數量
     LET new_sfa07  = old_sfa07
  ELSE
    #計算實際已發量=已發量+超領量
     LET l_sfa06 = old_sfa06 + old_sfa062
 
    #實際已發量 >= QPA變更後配合已發套數的新需求量
    #表示有超領 or 已發量夠了......
 
     IF l_sfa06 >= save_sfa06 THEN
        IF l_sfa06 = save_sfa06 THEN
           LET new_sfa06  = save_sfa06
           LET new_sfa062 = 0
        ELSE
           LET new_sfa06  = save_sfa06
           LET new_sfa062 = l_sfa06 - save_sfa06  #多的部份轉超領量
        END IF
 
        LET new_sfa07 = new_sfa05 - new_sfa06 - old_sfa065      #No.MOD-930172 add
     ELSE
    #欠料計算.................................
        LET new_sfa06 = old_sfa06
        LET new_sfa07 = new_sfa05 - new_sfa06 - old_sfa065      #No.MOD-930172 add
 
        LET new_sfa062= old_sfa062
     END IF
  END IF
  RETURN new_sfa06,new_sfa062,new_sfa07,new_qpa
 
END FUNCTION
 
FUNCTION create_sub_temp()
 
DROP TABLE sub_temp;
CREATE TEMP TABLE sub_temp(
  new_part              LIKE type_file.chr1000,
  new_rate		LIKE sfa_file.sfa05,
  new_yes 		LIKE type_file.chr1,  
  new_qty 		LIKE type_file.num10, 
  new_qty3		LIKE type_file.num10, 
# ima262                LIKE ima_file.ima262,
  avl_stk     LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
  new_qty4		LIKE type_file.num10, 
  new_qty5		LIKE type_file.num10, 
  new_qty6		LIKE type_file.num10, 
  new_qty7		LIKE type_file.num10, 
  new_qty8		LIKE type_file.num10);
END FUNCTION
 
FUNCTION t802_sub_chk(p_wo)
   DEFINE p_wo          LIKE oea_file.oea01        #No.FUN-680121 VARCHAR(16)#No.FUN-550067
   DEFINE l_sfb08	LIKE sfb_file.sfb08        #No.FUN-680121 DEC(15,3)
   DEFINE l_bomqty	LIKE sfb_file.sfb08        #No.FUN-680121 DEC(15,3)
   DEFINE l_aloqty	LIKE sfb_file.sfb08        #No.FUN-680121 DEC(15,3)
   DEFINE l_difqty	LIKE sfb_file.sfb08        #No.FUN-680121 DEC(15,3) 
   DEFINE chk           LIKE type_file.chr1        #No.FUN-680121 VARCHAR(1)
   DEFINE l_ze_sna27    LIKE ze_file.ze03
   DEFINE l_ze_bomqty   LIKE ze_file.ze03
   DEFINE l_ze_aloqty   LIKE ze_file.ze03
   DEFINE l_ze_difqty   LIKE ze_file.ze03
   DEFINE l_sna161      LIKE sna_file.sna161a
   DEFINE l_sna27       LIKE sna_file.sna27a
   DEFINE l_sna12       LIKE sna_file.sna12a
   DEFINE l_sna08       LIKE sna_file.sna08a
   DEFINE l_sna05       LIKE sna_file.sna05a
   DEFINE l_sna04       LIKE sna_file.sna04
   DEFINE l_sna28       LIKE sna_file.sna28a
   DEFINE t_sna05a      LIKE sna_file.sna05a
   DEFINE t_sna28a      LIKE sna_file.sna28a
   DEFINE l_sna		RECORD LIKE sna_file.*
 
   SELECT sfb08 INTO l_sfb08 FROM sfb_file WHERE sfb01=p_wo
   DECLARE t802_sub_chk_c CURSOR FOR
      SELECT * FROM sna_file
       WHERE sna01=g_snb.snb01  AND sna02 = g_snb.snb02
         AND (sna26a IN ('3','4','T') OR
              ((sna26a IS NULL OR sna26a = ' ') AND sna26b IN ('3','4','T')))
 
   FOREACH t802_sub_chk_c INTO l_sna.*
       LET l_aloqty = 0
       IF NOT cl_null(l_sna.sna27a) THEN
          LET l_sna27 = l_sna.sna27a
       ELSE
          LET l_sna27 = l_sna.sna27b
       END IF
       IF NOT cl_null(l_sna.sna08a) THEN
          LET l_sna08 = l_sna.sna08a
       ELSE
          LET l_sna08 = l_sna.sna08b
       END IF
       IF NOT cl_null(l_sna.sna12a) THEN
          LET l_sna12 = l_sna.sna12a
       ELSE
          LET l_sna12 = l_sna.sna12b
       END IF
       DECLARE t802_sub_chk2_c CURSOR FOR
          SELECT '1',sna05a,sna28a,sna04 FROM sna_file
           WHERE sna01 = g_snb.snb01   AND sna02 = g_snb.snb02
             AND sna27a= l_sna27       AND sna08a= l_sna08
             AND sna12a= l_sna12
           UNION
          SELECT '2',sna05b,sna28b,sna04 FROM sna_file
           WHERE sna01 = g_snb.snb01   AND sna02 = g_snb.snb02
             AND sna27b= l_sna27       AND sna08b= l_sna08
             AND sna12b= l_sna12
        FOREACH t802_sub_chk2_c INTO chk,l_sna05,l_sna28,l_sna04
           IF chk='2' THEN
              SELECT sna05a,sna28a INTO t_sna05a,t_sna28a FROM sna_file
               WHERE sna01 = g_snb.snb01  AND sna02  = g_snb.snb02
                 AND sna04 = l_sna04
              IF NOT cl_null(t_sna05a) THEN LET l_sna05 = t_sna05a END IF
              IF NOT cl_null(t_sna28a) THEN LET l_sna28 = t_sna28a END IF
           END IF
           LET l_aloqty = l_aloqty + (l_sna05/l_sna28)
        END FOREACH
        IF l_aloqty IS NULL THEN LET l_aloqty = 0 END IF
        IF NOT cl_null(l_sna.sna161a) THEN
           LET l_sna161 = l_sna.sna161a
        ELSE
           LET l_sna161 = l_sna.sna161b
        END IF
        LET l_bomqty=l_sfb08*l_sna161
        LET l_difqty=l_bomqty-l_aloqty
        IF NOT cl_null(l_sna.sna27a) THEN
           LET l_sna27 = l_sna.sna27a
        ELSE
           LET l_sna27 =l_sna.sna27b
        END IF
        IF l_aloqty<>l_bomqty THEN
           SELECT ze03 INTO l_ze_sna27 FROM ze_file
             WHERE ze01 = 'asf-847' AND ze02 = g_lang
           SELECT ze03 INTO l_ze_bomqty FROM ze_file
             WHERE ze01 = 'asf-848' AND ze02 = g_lang
           SELECT ze03 INTO l_ze_aloqty FROM ze_file
             WHERE ze01 = 'asf-849' AND ze02 = g_lang
           SELECT ze03 INTO l_ze_difqty FROM ze_file
             WHERE ze01 = 'asf-850' AND ze02 = g_lang
           PROMPT l_ze_sna27 CLIPPED,l_sna27,
                  l_ze_bomqty CLIPPED,l_bomqty,
                  l_ze_aloqty CLIPPED,l_aloqty,
                  l_ze_difqty CLIPPED,l_difqty,
                  ":" FOR CHAR g_chr
        END IF
   END FOREACH
END FUNCTION
 
FUNCTION t802_set_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'a' OR
       INFIELD(sna10) OR
       INFIELD(sna26a) THEN
       CALL cl_set_comp_entry("sna10,sna26a",TRUE)
    END IF
 
    IF INFIELD(sna10) THEN
       CALL cl_set_comp_entry("sna04a,sna27a,sfb03a,sfb08a,sfb11a,sfb12a,sfb13a",TRUE)
       CALL cl_set_comp_entry("sna100a,sfb26a,sfb28a,sfb161a,sfb05a,sfb062a",TRUE)
       CALL cl_set_comp_entry("sna06a,sfb07a,sfb065a,sfb30a,sfb31a",TRUE)
       CALL cl_set_comp_entry("sna28a,sna03a,sna161a",TRUE)
    END IF
 
END FUNCTION
 
FUNCTION t802_set_no_entry_b(p_cmd)
  DEFINE p_cmd   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_cmd = 'u' AND INFIELD(sna10) THEN
       CALL cl_set_comp_entry("sna10",FALSE)
    END IF
 
    IF INFIELD(sna26a) THEN
       IF g_sna[l_ac].sna26b MATCHES '[SUT]' THEN
         CALL cl_set_comp_entry("sna26a",FALSE)
       END IF
    END IF
 
    IF INFIELD(sna10) THEN
       IF g_sna[l_ac].sna10 NOT MATCHES '[123]' THEN
          CALL cl_set_comp_entry("sna04a,sna27a,sfb03a,sfb08a,sfb11a,sfb12a,sfb13a",FALSE)
          CALL cl_set_comp_entry("sna100a,sfb26a,sfb28a,sfb161a,sfb05a,sfb062a",FALSE)
          CALL cl_set_comp_entry("sna06a,sfb07a,sfb065a,sfb30a,sfb31a",FALSE)
          CALL cl_set_comp_entry("sna28a,sna03a,sna161a",FALSE)
       END IF
       IF g_sna[l_ac].sna10 MATCHES '[23]' THEN
          CALL cl_set_comp_entry("sna12a",FALSE)
       END IF
       IF g_sna[l_ac].sna10 MATCHES '[1]' THEN
          CALL cl_set_comp_entry("sna06a,sfb07a",FALSE)
       END IF
    END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼

#FUN-910088--add--start--
FUNCTION t802_sna05a_check()
   DEFINE l_sna06a   LIKE sna_file.sna06a,
          l_sna062a  LIKE sna_file.sna062a,
          l_sna07a   LIKE sna_file.sna07a,
          l_sna161a  LIKE sna_file.sna161a
   IF NOT cl_null(g_sna[l_ac].sna05a) THEN
      IF NOT cl_null(g_sna[l_ac].sna12a) THEN
         LET g_sna[l_ac].sna05a = s_digqty(g_sna[l_ac].sna05a,g_sna[l_ac].sna12a)
      ELSE
          LET g_sna[l_ac].sna05a = s_digqty(g_sna[l_ac].sna05a,g_sna[l_ac].sna12b)
      END IF
      DISPLAY BY NAME g_sna[l_ac].sna05a
   END IF
   IF NOT cl_null(g_sna[l_ac].sna05a) THEN
      IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN                      
         IF g_sna[l_ac].sna05b=g_sna[l_ac].sna05a THEN
            CALL cl_err('','asf-054',0)
            RETURN "sna05"        
         END IF
      END IF                                   
      IF g_sna[l_ac].sna05a<0 AND g_sfb.sfb02 NOT MATCHES '[58]' THEN
         CALL cl_err('','asf-678',0)
         RETURN "sna05a"       
      END IF
      CALL t802_sna05a()
      IF NOT cl_null(g_errno) THEN
         CALL cl_err('',g_errno,0)
         LET g_sna[l_ac].sna05a=g_sna_t.sna05a
         DISPLAY g_sna[l_ac].sna05a TO s_sna[l_ac].sna05a
         RETURN "sna05a"  
      END IF
      IF g_sna_t.sna05a IS NULL
         OR g_sna[l_ac].sna05a!=g_sna_t.sna05a THEN
         IF g_sna[l_ac].sna26a NOT MATCHES '[SU]' THEN
            LET g_sna[l_ac].sna161a=g_sna[l_ac].sna05a/g_sfb.sfb08
         END IF
         IF NOT cl_null(g_sna[l_ac].sna05b) THEN
            CALL t802_cal_qty(g_sna[l_ac].sna05b,g_sna[l_ac].sna05a,
                              g_sna[l_ac].sna06b,g_sna[l_ac].sna062b,
                              g_sna[l_ac].sna07b,g_sna[l_ac].sna065b)                             
                                                                                                  
               RETURNING l_sna06a,l_sna062a,
                         l_sna07a,l_sna161a
            IF cl_null(g_errno) THEN
               LET g_sna[l_ac].sna06a  = l_sna06a
               LET g_sna[l_ac].sna07a  = l_sna07a
               LET g_sna[l_ac].sna062a = l_sna062a
               LET g_sna[l_ac].sna161a = l_sna161a
               IF NOT cl_null(g_sna[l_ac].sna12a) THEN
                  LET g_sna[l_ac].sna06a = s_digqty(g_sna[l_ac].sna06a,g_sna[l_ac].sna12a)
                  LET g_sna[l_ac].sna07a =s_digqty(g_sna[l_ac].sna07a,g_sna[l_ac].sna12a)
                  LET g_sna[l_ac].sna062a = s_digqty(g_sna[l_ac].sna062a,g_sna[l_ac].sna12a)
               ELSE
                  LET g_sna[l_ac].sna06a = s_digqty(g_sna[l_ac].sna06a,g_sna[l_ac].sna12b)
                  LET g_sna[l_ac].sna07a =s_digqty(g_sna[l_ac].sna07a,g_sna[l_ac].sna12b)
                  LET g_sna[l_ac].sna062a = s_digqty(g_sna[l_ac].sna062a,g_sna[l_ac].sna12b)
               END IF
            ELSE
               CALL cl_err('',g_errno,0)
               RETURN "sna05a"  
            END IF
         END IF
      END IF
   ELSE
      LET g_sna[l_ac].sna06a  = ''
      LET g_sna[l_ac].sna07a  = ''
      LET g_sna[l_ac].sna062a = ''
      LET g_sna[l_ac].sna161a = ''
   END IF
   IF g_sna[l_ac].sna10 MATCHES  '[23]' THEN
      RETURN "sna30a"  
   END IF
   DISPLAY BY NAME g_sna[l_ac].sna06a
   DISPLAY BY NAME g_sna[l_ac].sna07a
   DISPLAY BY NAME g_sna[l_ac].sna062a
   DISPLAY BY NAME g_sna[l_ac].sna161a
   RETURN ""  
END FUNCTION

FUNCTION t802_sna065a_check()
   IF NOT cl_null(g_sna[l_ac].sna065a) THEN
      IF NOT cl_null(g_sna[l_ac].sna12a) THEN
         LET g_sna[l_ac].sna065a = s_digqty(g_sna[l_ac].sna065a,g_sna[l_ac].sna12a)
      ELSE
         LET g_sna[l_ac].sna065a = s_digqty(g_sna[l_ac].sna065a,g_sna[l_ac].sna12b)
      END IF
      DISPLAY BY NAME g_sna[l_ac].sna065a
   END IF
   IF g_sna[l_ac].sna10 MATCHES  '[23]' THEN
      RETURN FALSE    
   END IF
   IF g_sna[l_ac].sna10 NOT MATCHES '[1]' THEN                        
      IF g_sna[l_ac].sna065a = g_sna[l_ac].sna065b THEN
         LET  g_sna[l_ac].sna065a=null
         CALL cl_err('','axm-327',0)
         RETURN FALSE      
      END IF
   END IF                                  
   RETURN TRUE
END FUNCTION

FUNCTION t802_sna06a_check()
   IF NOT cl_null(g_sna[l_ac].sna06a) THEN
      IF NOT cl_null(g_sna[l_ac].sna12a) THEN
         LET g_sna[l_ac].sna06a = s_digqty(g_sna[l_ac].sna06a,g_sna[l_ac].sna12a)
      ELSE
         LET g_sna[l_ac].sna06a = s_digqty(g_sna[l_ac].sna06a,g_sna[l_ac].sna12b)
      END IF
      DISPLAY BY NAME g_sna[l_ac].sna06a
   END IF
END FUNCTION
#FUN-910088--add--end--

#TQC-C50155--add--str--
FUNCTION t802_set_no_required()
   CALL cl_set_comp_required("sna05a,sna26a,sna28a",FALSE)
END FUNCTION

FUNCTION t802_set_required()
   IF g_sna[l_ac].sna10 = '1' THEN
      CALL cl_set_comp_required("sna05a,sna26a,sna28a",TRUE)
   END IF
END FUNCTION
#TQC-C50155--add--end--

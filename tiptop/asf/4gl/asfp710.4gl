# Prog. Version..: '5.30.06-13.03.15(00010)'     #
#
# Pattern name...: asfp710.4gl
# Descriptions...: 製程委外RunCard轉採購單作業
# Date & Author..: 99/05/21 By Sophia
# Modify.........: 01/09/04 By Carol:NO.3452 單身增加一欄位:預計交貨日
# Modify.........: No.FUN-4B0059 04/11/25 By Mandy 匯率加開窗功能
# Modify.........: No.FUN-4C0025 04/12/06 By Mandy 單價金額位數改為dec(20,6) 或DEFINE 用LIKE方式
# Modify.........: No.MOD-520117 05/03/04 By ching fix temp fields order
# Modify.........: No.FUN-550109 05/05/26 By Danny 採購含稅單價
# Modify.........: No.FUN-550067 05/05/31 By Trisy 單據編號加大
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify.........: No.FUN-580133 05/08/25 By Carrier 多單位內容修改
# Modify.........: No.MOD-580285 05/09/05 By Claire 單身fill之前沒有對變量清空
# Modify.........: No.FUN-610018 06/01/11 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.MOD-670003 06/07/03 By day b_fill()所用的sql變量加大
# Modify.........: No.TQC-670008 06/07/05 By rainy 權限修正
# Modify.........: No.MOD-670021 06/07/05 By cl 修正含稅方式抓取不到單價及含稅單價
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-670099 06/08/28 By Nicola 價格管理修改
# Modify.........: No.FUN-690024 06/09/21 By jamie 判斷pmcacti
# Modify.........: No.FUN-690025 06/09/21 By jamie 改判斷狀況碼pmc05
# Modify.........: No.FUN-690047 06/09/28 By Sarah pmm45,pmn38預設為'N'
# Modify.........: No.CHI-6A0004 06/10/27 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.CHI-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.CHI-680014 06/12/04 By rainy INSERT INTO pmn_file時，要處理pmn88/pmn88t
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-750166 07/05/24 By kim 拋轉成功的委外採購單單身的本工藝序號和下工藝序號的值有誤
# Modify.........: No.TQC-770004 07/07/03 By mike 幫組按鈕灰色
# Modify.........: No.TQC-790002 07/09/03 By Sarah Primary Key：複合key在INSERT INTO table前需增加判斷，如果是NULL就給值blank(字串型態) or 0(數值型態)
# Modify.........: No.MOD-730044 07/09/19 By claire 需考慮採購單位與料件採購資料的採購單位換算
# Modify.........: No.MOD-7A0151 07/10/25 By Pengu 調整subqty的計算公式
# Modify.........: NO.MOD-7B0090 07/11/09 BY claire 轉委外採購單時要計算超/短交率(pmn13)
# Modify.........: No.MOD-7C0029 07/12/05 By Pengu 程式RUN到219行會整個當掉
# Modify.........: No.FUN-7B0018 08/02/29 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830087 08/03/24 By ve007 s_defprice 增加一個參數
# Modify.........: No.MOD-8A0122 08/10/14 By claire sgm45未放大
# Modify.........: No.FUN-8A0086 08/10/21 By baofei 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-8B0273 08/12/04 By chenyu 采購單單頭單價含稅時，未稅單價=未稅金額/計價數量
# Modify.........: No.FUN-930148 09/03/26 By ve007 采購取價和定價
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980008 09/08/26 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No.TQC-9B0203 09/11/25 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:TQC-9B0214 09/11/25 By Sunyanchun  s_defprice --> s_defprice_new
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造
#                                                   成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.TQC-A50121 10/05/21 By destiny 单头 run card 工艺序 2字段可开窗查询
# Modify.........: No.TQC-A50119 10/05/21 By destiny 因为pmm41 没有赋值，导致抛转采购单步成功 
# Modify.........: No.FUN-A60076 10/07/01 BY vealxu 製造功能優化-平行製程
# Modify.........: No.FUN-A60095 10/07/06 By jan 平行工艺 增加key05,key06,sgm012,ecu014
# Modify.........: No.FUN-A90057 10/09/23 By kim GP5.25號機管理
# Modify.........: No.TQC-AC0257 10/12/22 By suncx s_defprice_new.4gl返回值新增兩個參數
# Modify.........: No.TQC-AC0374 10/12/29 By liweie 從ecu_file撈取資料時，制程料號改用s_schdat_sel_ima571()撈取
# Modify.........: No.FUN-B10056 11/02/15 By vealxu 修改制程段號的管控
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:FUN-B30177 11/05/19 By lixiang INSERT INTO pmn_file時，如果pmn58為null則給'0'
# Modify.........: No:CHI-B70039 11/08/04 By joHung 金額 = 計價數量 x 單價
# Modify.........: No.FUN-BB0084 11/11/24 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-C10002 12/02/02 By bart 作業編號pmn78帶預設值
# Modify.........: No:TQC-C90002 12/09/03 By qiull 控管預計交貨日不可小於採購日
# Modify.........: No:MOD-D30070 13/03/08 By bart 依SMA904傳給 s_curr3
# Modify.........: 160512 16/05/12 By guanyao 委外采购单增加工序号和RunCrde号

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_rec_b         LIKE type_file.num5,          #單身筆數        #No.FUN-680121 SMALLINT
    g_exit          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_add_po        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#判斷是否為新增之採購單
    tm              RECORD
         wc         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(200)
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
         tc_pmm01   STRING,    #add by guanyao160614
         tc_pmm07   LIKE tc_pmm_file.tc_pmm07,    #add by guanyao160614
         key01      LIKE sgm_file.sgm01,          #NO.FUN-9B0016
         key02      LIKE sgm_file.sgm03,
         key05      LIKE sgm_file.sgm04,   #FUN-A60095
         key06      LIKE sgm_file.sgm012,  #FUN-A60095 
         pmm01      LIKE pmm_file.pmm01,
         pmm04      LIKE pmm_file.pmm04,
         pmm12      LIKE pmm_file.pmm12,
         pmm22      LIKE pmm_file.pmm22,
         pmm42      LIKE pmm_file.pmm42
                    END RECORD,
    g_pmn           DYNAMIC ARRAY OF RECORD
         sgm01      LIKE sgm_file.sgm01,
         sgm02      LIKE sgm_file.sgm02,
         sgm45      LIKE sgm_file.sgm45,
         sgm012     LIKE sgm_file.sgm012,    #FUN-A60095
         ecu014     LIKE ecu_file.ecu014,    #FUN-A60095
         sgm03      LIKE sgm_file.sgm03,
         sgm03_par  LIKE sgm_file.sgm03_par,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
#        subqty     LIKE ima_file.ima26,        #No.FUN-680121 DEC(12,3)
         subqty     LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
         pmm09      LIKE pmm_file.pmm09,
         pmc03      LIKE pmc_file.pmc03,
         pmn20      LIKE pmn_file.pmn20,
         pmn33      LIKE pmn_file.pmn33,
         pmn31      LIKE pmn_file.pmn31,
         pmn31t     LIKE pmn_file.pmn31t,        #含稅單價   No.FUN-550109
         pmc47      LIKE pmc_file.pmc47,         #稅別       No.FUN-550109
         gec04      LIKE gec_file.gec04          #稅率       No.FUN-550109
         ,tc_pmm01  LIKE tc_pmm_file.tc_pmm01     #add by guanyao160722
         ,tc_pmmud10  LIKE tc_pmm_file.tc_pmmud10 #add by guanyao160722
                    END RECORD,
    g_pmn_t         RECORD
         sgm01      LIKE sgm_file.sgm01,
         sgm02      LIKE sgm_file.sgm02,
         sgm45      LIKE sgm_file.sgm45,
         sgm012     LIKE sgm_file.sgm012,    #FUN-A60095
         ecu014     LIKE ecu_file.ecu014,    #FUN-A60095
         sgm03      LIKE sgm_file.sgm03,
         sgm03_par  LIKE sgm_file.sgm03_par,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
#        subqty     LIKE ima_file.ima26,        #No.FUN-680121 DEC(12,3)
         subqty     LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044 
         pmm09      LIKE pmm_file.pmm09,
         pmc03      LIKE pmc_file.pmc03,
         pmn20      LIKE pmn_file.pmn20,
         pmn33      LIKE pmn_file.pmn33,
         pmn31      LIKE pmn_file.pmn31,
         pmn31t     LIKE pmn_file.pmn31t,        #含稅單價   No.FUN-550109
         pmc47      LIKE pmc_file.pmc47,         #稅別       No.FUN-550109
         gec04      LIKE gec_file.gec04          #稅率       No.FUN-550109
         ,tc_pmm01  LIKE tc_pmm_file.tc_pmm01     #add by guanyao160722
         ,tc_pmmud10  LIKE tc_pmm_file.tc_pmmud10 #add by guanyao160722
                    END RECORD,
    g_tmp           RECORD
         sgm01      LIKE sgm_file.sgm01,
         sgm02      LIKE sgm_file.sgm02,
         sgm45      LIKE sgm_file.sgm45,
         sgm012     LIKE sgm_file.sgm012,    #FUN-A60095
         ecu014     LIKE ecu_file.ecu014,    #FUN-A60095
         sgm03      LIKE sgm_file.sgm03,
         sgm03_par  LIKE sgm_file.sgm03_par,
         ima02      LIKE ima_file.ima02,
         ima021     LIKE ima_file.ima021,
#        subqty     LIKE ima_file.ima26,        #No.FUN-680121 VARCHAR(12,3)
         subqty     LIKE type_file.num15_3,     ###GP5.2  #NO.FUN-A20044
         pmm09      LIKE pmm_file.pmm09,
         pmc03      LIKE pmc_file.pmc03,
         pmn20      LIKE pmn_file.pmn20,
         pmn33      LIKE pmn_file.pmn33,
         pmn31      LIKE pmn_file.pmn31,
         pmn31t     LIKE pmn_file.pmn31t,        #含稅單價   No.FUN-550109
         pmc47      LIKE pmc_file.pmc47,         #稅別       No.FUN-550109
         gec04      LIKE gec_file.gec04          #稅率       No.FUN-550109
         ,tc_pmm01  LIKE tc_pmm_file.tc_pmm01     #add by guanyao160722
         ,tc_pmmud10  LIKE tc_pmm_file.tc_pmmud10 #add by guanyao160722
                    END RECORD,
    l_exit,g_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#目前處理的ARRAY CNT
    l_smyslip       LIKE oay_file.oayslip,        #No.FUN-680121 VARCHAR(5)#No.FUN-550067
    l_smyapr        LIKE type_file.chr1,          #No.FUN-680121
    l_flag          LIKE type_file.chr1,                #        #No.FUN-680121 VARCHAR(1)
    l_flag1         LIKE type_file.chr1,                #        #No.FUN-680121 VARCHAR(1)
    l_sql           LIKE type_file.chr1000,             #        #No.FUN-680121 VARCHAR(300)
    l_pmm25         LIKE pmm_file.pmm25,   #
    l_sfb82         LIKE sfb_file.sfb82,   #
    l_pmmacti       LIKE pmm_file.pmmacti, #
    l_pmn           RECORD LIKE pmn_file.*,
    l_pmm           RECORD LIKE pmm_file.*,
    g_pmc03         LIKE pmc_file.pmc03,   #
    g_gec07         LIKE gec_file.gec07,   #No.FUN-550109
    g_tot           LIKE pmm_file.pmm40,   #
    g_tott          LIKE pmm_file.pmm40t,  #FUN-610018
    g_start,g_end   LIKE oea_file.oea01,   #No.FUN-680121 VARCHAR(16)#No.FUN-550067
#   l_k1            LIKE ima_file.ima26,   #No.FUN-680121 DEC(11,3)
    l_k1            LIKE type_file.num15_3,###GP5.2  #NO.FUN-A20044
    l_ac,l_k        LIKE type_file.num5,          #目前處理的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_nn            LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_sl            LIKE type_file.num5           #No.FUN-680121 #目前處理的SCREEN LINE SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   i               LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE   g_pmc17         LIKE pmc_file.pmc17     #No.FUN-930148
DEFINE   g_pmc49         LIKE pmc_file.pmc49     #No.FUN-930148
DEFINE   g_argv1         STRING                  #FUN-A60095
DEFINE   g_pmn73         LIKE pmn_file.pmn73,    #TQC-AC0257 add
         g_pmn74         LIKE pmn_file.pmn74     #TQC-AC0257 add
 
MAIN
    DEFINE p_row,p_col     LIKE type_file.num5        #No.FUN-680121 SMALLINT
 
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   LET g_argv1 = ARG_VAL(1)   #FUN-A60095
   LET g_argv1 = cl_replace_str(g_argv1, "\\\"", "'") #FUN-A60095

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
     CALL cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
        RETURNING g_time                 #No.FUN-6A0090   
 
   LET p_row = 2 LET p_col = 20
   OPEN WINDOW p710_w AT p_row,p_col WITH FORM "asf/42f/asfp710"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_set_comp_visible("key06,sgm012,ecu014",g_sma.sma541='Y')  #FUN-A60095
   CALL cl_set_comp_visible("pmn31,pmn31t,tc_pmm01_1,tc_pmmud10",FALSE)

   CALL cl_opmsg('b')
   CALL p710_cre_tmp()
   CALL p710()
   CLOSE WINDOW p710_w
     CALL cl_used(g_prog,g_time,2)   #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
        RETURNING g_time             #No.FUN-6A0090 
END MAIN
 
FUNCTION p710()
   DEFINE   l_sql   LIKE type_file.chr1000           #No.FUN-680121 VARCHAR(200)
   DEFINE   li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
   DEFINE   l_l         LIKE type_file.num5          #No.MOD-7C0029 add
   DEFINE   l_shm01     LIKE shm_file.shm01          #No.TQC-A50121 add
   DEFINE   l_sgm03     LIKE sgm_file.sgm03          #No.TQC-A50121 add
   DEFINE   l_x         LIKE type_file.num5          #add by guanyao160614
   DEFINE   l_pmc03_1   LIKE pmc_file.pmc03       #add by guanyao160614
   CALL g_pmn.clear()
 
   LET l_exit   = 'n'
 
   WHILE TRUE
      LET g_exit = 'N'
      LET INT_FLAG=0      #MOD-580285 給初值
      DELETE FROM asfp710_tmp
      IF NOT cl_null(g_argv1) THEN   #FUN-A60095
         LET tm.wc = g_argv1         #FUN-A60095 
      ELSE                           #FUN-A60095 
        #str------add by guanyao160614
        DIALOG ATTRIBUTES(UNBUFFERED)
        INPUT BY NAME tm.tc_pmm07
           AFTER FIELD tc_pmm07  
              IF NOT cl_null(tm.tc_pmm07) THEN 
                 SELECT COUNT(*) INTO l_x FROM pmc_file WHERE pmc01 = tm.tc_pmm07
                 IF cl_null(l_x) OR l_x = 0 THEN 
                    CALL cl_err('','cpm-026',0)
                    NEXT FIELD tc_pmm07
                 END IF
                 LET l_pmc03_1 = ''
                 SELECT pmc01 INTO l_pmc03_1 FROM pmc_file WHERE pmc01=  tm.tc_pmm07
                 DISPLAY l_pmc03_1 TO pmc03_1
              END IF 

        END INPUT   
        CONSTRUCT BY NAME tm.tc_pmm01 ON tc_pmm01  
           BEFORE CONSTRUCT
              CALL cl_qbe_init()

        END CONSTRUCT 

           ON ACTION CONTROLP
              CASE
                 WHEN INFIELD(tc_pmm07) #查詢幣別檔
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_pmc1"
                    LET g_qryparam.default1 = tm.tc_pmm07
                    CALL cl_create_qry() RETURNING tm.tc_pmm07
                    DISPLAY tm.tc_pmm01 TO FORMONLY.tc_pmm07
                    NEXT FIELD tc_pmm07
                 WHEN INFIELD (tc_pmm01)               #作业编号
                    CALL cl_init_qry_var()
                    IF cl_null(tm.tc_pmm07) THEN 
                       LET g_qryparam.form = "cq_tc_pmm01"
                    ELSE 
                       LET g_qryparam.form = "cq_tc_pmm1"
                       LET g_qryparam.arg1 = tm.tc_pmm07
                    END IF 
                    LET g_qryparam.state    = "c"  
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO FORMONLY.tc_pmm01
                    NEXT FIELD tc_pmm01
                 OTHERWISE EXIT CASE
              END CASE
 
              ON ACTION CONTROLR
                 CALL cl_show_req_fields()
 
              ON ACTION CONTROLG
                 CALL cl_cmdask()
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DIALOG

              ON ACTION ACCEPT
                 EXIT DIALOG
       
              ON ACTION EXIT
                 LET INT_FLAG = TRUE
                 EXIT DIALOG 
                 
              ON ACTION CANCEL
                 LET INT_FLAG = TRUE
                 EXIT DIALOG 
        END DIALOG  
        IF cl_null(tm.tc_pmm01) AND cl_null(tm.tc_pmm07) THEN 
        #end------add by guanyao160614
        CONSTRUCT BY NAME tm.wc ON key01,key05,key06,key02  #FUN-A60095 
           ON ACTION locale
              CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE CONSTRUCT
           ON ACTION exit                            #加離開功能
              LET INT_FLAG = 1
              EXIT CONSTRUCT
           ON ACTION help                             #No.TQC-770004
              LET g_action_choice="help"             #No.TQC-770004  
              CALL cl_show_help()                    #No.TQC-770004  
              CONTINUE CONSTRUCT                     #No.TQC-770004  
           #No.TQC-A50121--begin 
           ON ACTION controlg
              CALL cl_cmdask()
           ON ACTION controlp
              CASE
              WHEN INFIELD(key01)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_shm3"
                   CALL cl_create_qry() RETURNING l_shm01            
                   DISPLAY l_shm01 TO FORMONLY.key01
                   NEXT FIELD key01 
               WHEN INFIELD(key02)
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = "q_sgm5"
                   LET g_qryparam.arg1 =l_shm01 
                   CALL cl_create_qry() RETURNING l_sgm03 
                   DISPLAY l_sgm03 TO FORMONLY.key02
                   NEXT FIELD key02 
               #FUN-A60095--begin--add-----------
               WHEN INFIELD (key05)               #作业编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.form = "q_ecd3"
                  LET g_qryparam.state    = "c"  
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO FORMONLY.key05
                  NEXT FIELD key05
               WHEN INFIELD (key06)               #工艺段号
                  CALL cl_init_qry_var()
                # LET g_qryparam.form = "q_ecu012_1"          #FUN-B10056 mark
                  LET g_qryparam.form = "q_sgm012_1"          #FUN-B10056 
                  LET g_qryparam.state    = "c" 
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO FORMONLY.key06
                  NEXT FIELD key06
               #FUN-A60095--end--add----------- 
                   OTHERWISE EXIT CASE
               END CASE
             #No.TQC-A50121--end 
       END CONSTRUCT
       END IF   #add by guanyao160614
      END IF   #FUN-A60095
      LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p710_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      LET l_sql = tm.wc
      LET l_l=length(l_sql)     #No.MOD-7C0029 add
      FOR i = 1 TO l_l    #No.MOD-7C0029 modify  #將畫面的sql欄位資料改變
         IF i+4 <= l_l THEN          #No.MOD-7C0029 add
            IF l_sql[i,i+4]='key01' THEN
               LET tm.wc[i,i+4]='sgm01'
            END IF
            IF l_sql[i,i+4]='key02' THEN
               LET tm.wc[i,i+4]='sgm03'
            END IF
            #No.FUN-A60095  --Begin
            IF l_sql[i,i+4]='key05' THEN
               LET tm.wc[i,i+4]='sgm04'
            END IF
            IF l_sql[i,i+4]='key06' THEN
               LET tm.wc[i,i+4]='sgmxx'
            END IF
            #No.FUN-A60095  --End
         END IF                 #No.MOD-7C0029 add
      END FOR
      CALL cl_replace_str(tm.wc,"sgmxx","sgm012") RETURNING tm.wc  #FUN-A60095
      CALL p710_b_fill()
 
      #FUN-A60095--begin--add-----------
      IF NOT cl_null(g_argv1) AND g_exit = 'Y' THEN
         EXIT WHILE
      END IF
      #FUN-A60095--end--add-------------

      IF g_exit='Y' THEN
         CONTINUE WHILE
      END IF
      LET tm.pmm12=g_user
      #LET tm.pmm42=NULL  #mark by guanyao160801
      LET tm.pmm42=1      #add by guanyao160801
      LET tm.pmm01=NULL
      #LET tm.pmm22=NULL    #mark by guanyao160801
      LET tm.pmm22 = 'RMB'  #add by guanyao160801
      LET tm.pmm04=g_today
      DISPLAY tm.pmm04 TO FORMONLY.pmm04
      DISPLAY tm.pmm01 TO FORMONLY.pmm01
      DISPLAY tm.pmm22 TO FORMONLY.pmm22
      DISPLAY tm.pmm12 TO FORMONLY.pmm12
      DISPLAY tm.pmm42 TO FORMONLY.pmm42
 
      INPUT BY NAME tm.pmm01,tm.pmm04,tm.pmm12,tm.pmm22,tm.pmm42 WITHOUT DEFAULTS
 
         AFTER FIELD pmm01                      #採購單號
            IF cl_null(tm.pmm01) THEN
               NEXT FIELD pmm01
            END IF
            LET l_smyslip = tm.pmm01[1,g_doc_len]
            CALL s_check_no("apm",l_smyslip,"","2","","","")
            RETURNING li_result,tm.pmm01
            LET tm.pmm01 = s_get_doc_no(tm.pmm01)
            DISPLAY BY NAME tm.pmm01
            IF (NOT li_result) THEN
               NEXT FIELD pmm01
            END IF
 
            SELECT smyapr INTO l_smyapr FROM smy_file
             WHERE smyslip = l_smyslip
            LET g_cnt=0
 
         AFTER FIELD pmm04                      #採購日期
            IF cl_null(tm.pmm04) THEN
               NEXT FIELD pmm04
            END IF
 
         AFTER FIELD pmm22                      #採購幣別
            IF cl_null(tm.pmm22) THEN
               NEXT FIELD pmm22
            ELSE
               CALL p710_pmm22()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pmm22,g_errno,0)
                  NEXT FIELD pmm22
               END IF
               #CALL s_curr3(tm.pmm22,tm.pmm04,'S') RETURNING tm.pmm42  #MOD-D30070
               CALL s_curr3(tm.pmm22,tm.pmm04,g_sma.sma904) RETURNING tm.pmm42  #MOD-D30070
               DISPLAY tm.pmm42 TO FORMONLY.pmm42
            END IF
 
         AFTER FIELD pmm12                      #採購人員
            IF cl_null(tm.pmm12) THEN
               NEXT FIELD pmm12
            ELSE
               CALL p710_pmm12()
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(tm.pmm12,g_errno,0)
                  NEXT FIELD pmm12
               END IF
            END IF
 
         AFTER FIELD pmm42
            IF cl_null(tm.pmm42)  THEN
               NEXT FIELD pmm42
            END IF
            IF tm.pmm42 <=0 THEN
               NEXT FIELD pmm42
            END IF
 
         AFTER INPUT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               LET l_exit   = 'y'
               EXIT INPUT
            END IF
            IF cl_null(tm.pmm01) THEN
               NEXT FIELD pmm01
            END IF
            IF cl_null(tm.pmm04) THEN
               NEXT FIELD pmm04
            END IF
            IF cl_null(tm.pmm22) THEN
               NEXT FIELD pmm22
            END IF
            IF cl_null(tm.pmm12) THEN
               NEXT FIELD pmm12
            END IF
            IF cl_null(tm.pmm42) THEN
               NEXT FIELD pmm42
            END IF
 
         ON ACTION qry_po #採購單號
                  CALL q_pmm2(FALSE,TRUE,tm.pmm01,'01') RETURNING tm.pmm01
                  DISPLAY tm.pmm01 TO FORMONLY.pmm01
                  NEXT FIELD pmm01
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(pmm01) #採購單號
               LET l_smyslip = s_get_doc_no(tm.pmm01)     #No.FUN-550067
               CALL q_smy(FALSE,FALSE,l_smyslip,'APM','2') RETURNING l_smyslip  #TQC-670008
               LET tm.pmm01=l_smyslip       #No.FUN-550067
               DISPLAY tm.pmm01 TO FORMONLY.pmm01
               NEXT FIELD pmm01
            WHEN INFIELD(pmm22) #查詢幣別檔
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_azi"
               LET g_qryparam.default1 = tm.pmm22
               CALL cl_create_qry() RETURNING tm.pmm22
               DISPLAY tm.pmm22 TO FORMONLY.pmm22
               NEXT FIELD pmm22
            WHEN INFIELD(pmm42)
               CALL s_rate(tm.pmm22,tm.pmm42) RETURNING tm.pmm42
               DISPLAY tm.pmm42 TO FORMONLY.pmm42
               NEXT FIELD pmm42
            WHEN INFIELD(pmm12) #採購員
               CALL cl_init_qry_var()
               LET g_qryparam.form = "q_gen"
               LET g_qryparam.default1 = tm.pmm12
               CALL cl_create_qry() RETURNING tm.pmm12
               DISPLAY BY NAME tm.pmm12
               CALL p710_pmm12()
               NEXT FIELD pmm12
         OTHERWISE EXIT CASE
         END CASE
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
      END INPUT
      IF l_exit = 'n' THEN
         CALL p710_b()                   #修改單身資料
      ELSE
         EXIT WHILE
      END IF
   END WHILE
 
END FUNCTION
 
FUNCTION p710_b_fill()                 #單身填充
  DEFINE l_sql      STRING,  #No.MOD-670003
         l_sgm321   LIKE sgm_file.sgm321,
         l_sgm322   LIKE sgm_file.sgm322,
         l_sgm54    LIKE sgm_file.sgm54,      # check in 否
#        l_wip      LIKE ima_file.ima26,        #No.FUN-680121 DEC(12,3)
#        l_qty      LIKE ima_file.ima26         #No.FUN-680121 DEC(12,3)
         l_wip      LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044
         l_qty      LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
  DEFINE l_sfb06    LIKE sfb_file.sfb06       #FUN-A60095
  DEFINE l_flag     LIKE type_file.num5       #FUN-A60095
  DEFINE l_sfb05    LIKE sfb_file.sfb05       #TQC-AC0374  add
  DEFINE l_flag2    LIKE type_file.num5       #TQC-AC0374  add
  DEFINE l_sum      LIKE pmn_file.pmn20       #add by guanyao160909
  DEFINE l_pmn20    LIKE pmn_file.pmn20

    
    IF cl_null(tm.tc_pmm01) AND cl_null(tm.tc_pmm07) THEN #add by guanyao160614
       LET l_sql = " SELECT sgm01,sgm02,sgm45,sgm012,'',sgm03,sgm03_par,ima02,ima021,0,'','',0,'',0,",  #FUN-A60095
                   "        0,'',0,tc_pmm01,tc_pmmud10,sgm321,sgm54,sgm322,sfb06 ",    #No.FUN-550109  FUN-610018  #add tc_pmm01,tc_pmmud10 by guanyao160722
                   " FROM sgm_file,sfb_file,OUTER ima_file",
                   " WHERE  sgm_file.sgm03_par = ima_file.ima01 ",
                  #"   AND sgm52='Y'",  #FUN-A60095
                   " AND sgm02 = sfb01 AND sfb04 !='8' AND sfb87 = 'Y' ",
                   "   AND ",tm.wc CLIPPED,
                   " ORDER BY sgm01,sgm012,sgm03 "  #FUN-A60095
#str----add by guanyao160614
    ELSE 
       LET l_sql = " SELECT sgm01,sgm02,sgm45,sgm012,'',sgm03,sgm03_par,ima02,ima021,0,'','',tc_pmm09,'',0,", 
                   "        0,'',0,tc_pmm01,tc_pmmud10,sgm321,sgm54,sgm322,sfb06 ",      #add tc_pmm01,tc_pmmud10 by guanyao160722
                   " FROM tc_pmm_file,sfb_file,sgm_file ",
                   "  LEFT JOIN ima_file ON  sgm_file.sgm03_par = ima_file.ima01 ",
                   " WHERE tc_pmm03 = sgm01 AND tc_pmm08 = sgm03",
                   " AND sgm02 = sfb01 AND sfb04 !='8' AND sfb87 = 'Y' ",
                   " AND tc_pmm11 = 'Y'",   #add by guanyao160722
                   --" AND tc_pmmud06 is null", #add by guanyao160722
                   "   AND ",tm.tc_pmm01 CLIPPED
                   
        #str------mark by guanyao160810
        #IF NOT cl_null(tm.tc_pmm07) THEN   
        #   LET l_sql = l_sql CLIPPED," AND tc_pmm07 = '",tm.tc_pmm07,"'"
        #END IF 
        #end------mark by guanyao160810
        LET l_sql = l_sql CLIPPED," ORDER BY sgm01,sgm012,sgm03 "
    END IF 
#end----add by guanyao160614
    PREPARE p710_prepare FROM l_sql
    MESSAGE " SEARCHING! "
    CALL ui.Interface.refresh()
    CALL g_pmn.clear()          #MOD-580285
    DECLARE p710_cur CURSOR FOR p710_prepare
    LET g_cnt = 1
    LET l_sum = 0  #add by guanyao160909
    FOREACH p710_cur INTO g_pmn[g_cnt].*,l_sgm321,l_sgm54,l_sgm322,l_sfb06  #FUN-A60095
       IF SQLCA.sqlcode != 0 THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       
       CALL s_schdat_sel_ima571(g_pmn[g_cnt].sgm02) RETURNING l_flag2,l_sfb05     #TQC-AC0374  add

       #str-----add by guanyao160810
       IF NOT cl_null(tm.tc_pmm07) THEN 
          LET g_pmn[g_cnt].pmm09 = tm.tc_pmm07
          SELECT pmc03 INTO g_pmn[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_pmn[g_cnt].pmm09
       END IF 
       LET g_pmn[g_cnt].pmn33 = g_today+1
       #end-----add by guanyao160810
       
      #FUN-B10056 -----mod start-------- 
      ##FUN-A60095--begin--add---------------
      #SELECT ecu014 INTO g_pmn[g_cnt].ecu014 FROM ecu_file
      ## WHERE ecu01 = g_pmn[g_cnt].sgm03_par                #TQC-AC0374 mark
      #  WHERE ecu01 = l_sfb05                               #TQC-AC0374
      #   AND ecu02 = l_sfb06
      #   AND ecu012= g_pmn[g_cnt].sgm012
      ##FUN-A60095--end--add-----------------
       CALL s_runcard_sgm014(g_pmn[g_cnt].sgm01,g_pmn[g_cnt].sgm012) RETURNING g_pmn[g_cnt].ecu014 
      #FUN-B10056 ----mod end-----------

      #FUN-A60095--begin--mark---------------
      #IF cl_null(l_sgm321) THEN LET l_sgm321 = 0 END IF
      #IF cl_null(l_sgm322) THEN LET l_sgm322 = 0 END IF
      #SELECT SUM(pmn20) INTO l_qty FROM pmn_file,pmm_file
      # WHERE pmn18 = g_pmn[g_cnt].sgm01
      #   AND pmn04 = g_pmn[g_cnt].sgm03_par
      #   AND pmn01 = pmm01
      #   AND pmm18 = 'N'    #未確認
      #IF cl_null(l_qty) THEN LET l_qty = 0 END IF
      #IF l_sgm54 = 'N' THEN    #RunCard不作check-in
      #   SELECT sgm301+sgm302+sgm303+sgm304-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)*sgm59
      #     INTO l_wip
      #     FROM sgm_file
      #    WHERE sgm01 = g_pmn[g_cnt].sgm01
      #      AND sgm03 = g_pmn[g_cnt].sgm03
      #ELSE
      #   SELECT sgm291-(sgm311+sgm312+sgm313+sgm314+sgm316+sgm317)*sgm59
      #     INTO l_wip
      #     FROM sgm_file
      #    WHERE sgm01 = g_pmn[g_cnt].sgm01
      #      AND sgm03 = g_pmn[g_cnt].sgm03
      #END IF
      #IF cl_null(l_wip) THEN LET l_wip = 0 END IF
      #LET g_pmn[g_cnt].subqty = l_wip - l_sgm321 - l_qty
      #FUN-A60095--end--mark-------------------

      #FUN-A60095--begin--add------------------
       CALL s_subcontract_sgm_qty(g_pmn[g_cnt].sgm01,g_pmn[g_cnt].sgm012,g_pmn[g_cnt].sgm03)
            RETURNING l_flag,l_wip
       IF l_flag = FALSE THEN
          INITIALIZE g_pmn[g_cnt].* TO NULL
          CONTINUE FOREACH
       END IF
       LET g_pmn[g_cnt].subqty = l_wip
      #FUN-A60095--end--add--------------------

       #str----mark by guanyao160722
       #IF g_pmn[g_cnt].subqty <= 0 THEN
       #   INITIALIZE g_pmn[g_cnt].* TO NULL
       #   CONTINUE FOREACH
       #END IF
       #end----mark by guanyao160722
       #str----add by guanyao160909

      IF NOT cl_null(g_pmn[g_cnt].tc_pmm01) THEN 
         SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file,pmm_file WHERE pmm01=pmn01
         AND pmmud06=g_pmn[g_cnt].tc_pmm01 AND pmn18=g_pmn[g_cnt].sgm01
         AND pmn32=g_pmn[g_cnt].sgm03
      END IF
      IF cl_null(l_pmn20) THEN LET l_pmn20 = 0 END IF
      LET g_pmn[g_cnt].pmn20 = g_pmn[g_cnt].pmn20 - l_pmn20
      IF g_pmn[g_cnt].pmn20 < 0 THEN LET g_pmn[g_cnt].pmn20 = 0 END IF
      IF cl_null(g_pmn[g_cnt].pmn20) THEN LET g_pmn[g_cnt].pmn20 = 0 END IF
  
       LET l_sum = l_sum +g_pmn[g_cnt].pmn20
       #end----add by guanyao160909
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_pmn.deleteElement(g_cnt)
    IF g_cnt= 1 THEN CALL cl_err('',9057,0) LET g_exit = 'Y' END IF
    LET g_rec_b = g_cnt - 1
    LET g_cnt = 0
    DISPLAY l_sum TO tot_sum  #add by guanyao160909
END FUNCTION
 
FUNCTION p710_bp(p_ud)               #show資料
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    CALL SET_COUNT(g_rec_b)   #告訴I.單身筆數
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_pmn TO s_pmn.* ATTRIBUTE(COUNT=g_rec_b)
        BEFORE ROW
            LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
       ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON ACTION accept
          LET g_action_choice="detail"
          LET l_ac = ARR_CURR()
          EXIT DISPLAY
 
       ON ACTION exit
          LET g_action_choice="exit"
          EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
 
FUNCTION p710_b()                          #單身
DEFINE
    l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680121 SMALLINT
    l_n             LIKE type_file.num5,                #檢查重複用        #No.FUN-680121 SMALLINT
    l_modify_flag   LIKE type_file.chr1,                 #單身更改否        #No.FUN-680121 VARCHAR(1)
    l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否        #No.FUN-680121 VARCHAR(1)
    l_exit_sw       LIKE type_file.chr1,                 #No.FUN-680121 VARCHAR(1)#Esc結束INPUT ARRAY 否
    p_cmd           LIKE type_file.chr1,                 #處理狀態        #No.FUN-680121 VARCHAR(1)
    l_insert        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#可新增否
    l_update        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#可更改否 (含取消)
    l_jump          LIKE type_file.num5,          #No.FUN-680121 SMALLINT#判斷是否跳過AFTER ROW的處理
    l_flag          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_date          LIKE type_file.dat,           #No.FUN-680121 DATE
    l_ima07  LIKE ima_file.ima07,
    l_pmn41  LIKE pmn_file.pmn41,
    l_sgm321 LIKE sgm_file.sgm321,
#   l_wip    LIKE ima_file.ima26,         #No.FUN-680121 DEC(12,3)
#   l_qty    LIKE ima_file.ima26,         #No.FUN-680121 DEC(12,3)
    l_wip    LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
    l_qty    LIKE type_file.num15_3,      ###GP5.2  #NO.FUN-A20044
    l_over          LIKE alh_file.alh33,        #No.FUN-680121 DEC(13,3)
    l_total         LIKE alh_file.alh33,        #No.FUN-680121 DEC(13,3)
    l_sgm04         LIKE sgm_file.sgm04 #NO:7178
DEFINE l_msg        STRING    #FUN-A60095
 
    LET l_insert='N'
    LET l_update='N'
 
    CALL cl_opmsg('b')
 
    LET l_ac_t = 0
    LET l_ac = 1         #No.FUN-550109
    WHILE TRUE
        LET l_exit_sw = "y"                #正常結束,除非 ^N
        INPUT ARRAY g_pmn WITHOUT DEFAULTS FROM s_pmn.*
             ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                       INSERT ROW=FALSE,
                       DELETE ROW=FALSE,
                       APPEND ROW=FALSE)
 
        BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
            CALL p710_set_entry_b()
            CALL p710_set_no_entry_b()
        
        
        BEFORE ROW
            LET l_ac = ARR_CURR()
            LET g_pmn_t.* = g_pmn[l_ac].*  #BACKUP
            IF l_ac < l_ac_t THEN
                let l_jump = 1
                NEXT FIELD ima02           #跳下一ROW
            ELSE
                LET l_ac_t = 0
                let l_jump = 0
            END IF
            LET l_modify_flag = 'N'        #DEFAULT
            LET l_lock_sw = 'N'            #DEFAULT
            LET l_sl = SCR_LINE()
            LET l_n  = ARR_COUNT()
            IF l_ac <= l_n then                   #DISPLAY NEWEST
                DISPLAY g_pmn[l_ac].* TO s_pmn[l_sl].*
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
            NEXT FIELD sgm01
 
        BEFORE FIELD pmn33
            IF l_ac > 1 AND g_pmn[l_ac].sgm01 IS NULL THEN
               LET l_exit_sw = 'n'
               EXIT INPUT
            END IF
            IF cl_null(g_pmn[l_ac].pmn33) THEN
               LET g_pmn[l_ac].pmn33 = g_today
               DISPLAY g_pmn[l_ac].pmn33 TO s_pmn[l_sl].pmn33
            END IF
 
         AFTER FIELD pmn33       #預計交貨日期
            IF NOT cl_null(g_pmn[l_ac].pmn33) THEN
               CALL s_wkday(g_pmn[l_ac].pmn33) RETURNING l_flag,l_date
               IF cl_null(l_date) THEN
                  NEXT FIELD pmn33
               ELSE
                  LET g_pmn[l_ac].pmn33 = l_date
                  IF g_pmn[l_ac].pmn33 < tm.pmm04 THEN                         #TQC-C90002
                     CALL cl_err('','asf-486',0)                               #TQC-C90002
                     NEXT FIELD pmn33                                          #TQC-C90002
                  ELSE                                                         #TQC-C90002
                     DISPLAY g_pmn[l_ac].pmn33 TO s_pmn[l_sl].pmn33
                  END IF                                                       #TQC-C90002
               END IF                                                          
            END IF
 
        BEFORE FIELD pmm09
            CALL p710_set_entry_b()
 
        AFTER FIELD pmm09
            IF cl_null(g_pmn[l_ac].pmm09) THEN
               NEXT FIELD pmm09
            END IF
            SELECT pmc17,pmc49
            INTO g_pmc17,g_pmc49
               FROM pmc_file
            WHERE pmc01=g_pmn[l_ac].pmm09
            CALL p710_pmm09()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(g_pmn[l_ac].pmm09,g_errno,0)
               NEXT FIELD pmm09
            END IF
            CALL p710_set_no_entry_b()     #No.FUN-550109
 
        AFTER FIELD pmn20
            IF cl_null(g_pmn[l_ac].pmn20) THEN
               NEXT FIELD pmn20
            END IF
            SELECT sgm58 INTO l_pmn.pmn86 FROM sgm_file  #FUN-A60011
             WHERE sgm01=g_pmn[l_ac].sgm01 AND sgm03=g_pmn[l_ac].sgm03
               AND sgm012=g_pmn[l_ac].sgm012  #FUN-A60095
            LET g_pmn[l_ac].pmn20 = s_digqty(g_pmn[l_ac].pmn20,l_pmn.pmn86)  #FUN-BB0084
            DISPLAY BY NAME g_pmn[l_ac].pmn20                                #FUN-BB0084 
          #str----mark by guanyao160722
          #  IF g_pmn[l_ac].pmn20 > g_pmn[l_ac].subqty THEN
          #     CALL cl_err(g_pmn[l_ac].pmn20,'asf-722',0)
          #     NEXT FIELD pmn20
          #  END IF
          #end----mark by guanyao160722
            IF g_pmn[l_ac].pmn20 <= 0 THEN
               NEXT FIELD pmn20
            END IF
#str-----mark by guanyao160722
       # BEFORE FIELD pmn31
       #     IF g_pmn[l_ac].pmn31=0 AND g_pmn[l_ac].pmn20>0 THEN
       #        SELECT sgm04 INTO l_sgm04
       #          FROM sgm_file
       #         WHERE sgm01 = g_pmn[l_ac].sgm01
       #           AND sgm03 = g_pmn[l_ac].sgm03
       #           AND sgm012= g_pmn[l_ac].sgm012   #FUN-A60095
       #        CALL s_defprice_new(g_pmn[l_ac].sgm03_par,g_pmn[l_ac].pmm09,tm.pmm22,tm.pmm04,
       #                            g_pmn[l_ac].pmn20,l_sgm04,g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,
       #                            '2',l_pmn.pmn86,'',g_pmc49,g_pmc17,g_plant)
       #          RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
       #                    g_pmn73,g_pmn74   #TQC-AC0257 add
       #        LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)  #No.CHI-6A0004
       #        LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)  #No.CHI-6A0004
       #        DISPLAY g_pmn[l_ac].pmn31 TO s_pmn[l_sl].pmn31
       #        DISPLAY g_pmn[l_ac].pmn31t TO s_pmn[l_sl].pmn31t
       #     END IF
 
       # AFTER FIELD pmn31                     #單價
       #     IF cl_null(g_pmn[l_ac].pmn31) AND g_pmn[l_ac].pmn20>0 THEN

       # LET g_pmn[l_ac].pmn31=0
       #     END IF
       #     IF NOT cl_null(g_pmn[l_ac].pmn31) THEN
       #        LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)  #No.CHI-6A0004
       #        LET g_pmn[l_ac].pmn31t =
       #            g_pmn[l_ac].pmn31 * ( 1 + g_pmn[l_ac].gec04 /100)
       #        LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)  #No.CHI-6A0004
       #     END IF
        
       # BEFORE FIELD pmn31t                                                                                                         
       #   IF g_gec07='Y' THEN                                                                                                       
       #     IF g_pmn[l_ac].pmn31=0 AND g_pmn[l_ac].pmn20>0 THEN                                                                     
       #        SELECT sgm04 INTO l_sgm04                                                                                            
       #          FROM sgm_file                                                                                                      
       #         WHERE sgm01 = g_pmn[l_ac].sgm01                                                                                     
       #           AND sgm03 = g_pmn[l_ac].sgm03                                                                                     
       #           AND sgm012 = g_pmn[l_ac].sgm012  #FUN-A60095
       #         
       #         CALL s_defprice_new(g_pmn[l_ac].sgm03_par,g_pmn[l_ac].pmm09,tm.pmm22, tm.pmm04,g_pmn[l_ac].pmn20,l_sgm04,g_pmn[l_ac].pmc47,g_pmn[l_ac].gec04,'2',l_pmn.pmn86,'',g_pmc49,g_pmc17,g_plant) 
       #           RETURNING g_pmn[l_ac].pmn31,g_pmn[l_ac].pmn31t,
       #                     g_pmn73,g_pmn74   #TQC-AC0257 add  
       #        LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)    #No.CHI-6A0004                                                      
       #        LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)  #No.CHI-6A0004                                                     
       #        DISPLAY g_pmn[l_ac].pmn31 TO s_pmn[l_sl].pmn31                                                                       
       #        DISPLAY g_pmn[l_ac].pmn31t TO s_pmn[l_sl].pmn31t                                                                     
       #     END IF                                                                                                                  
       #   END IF   
     
 
       # AFTER FIELD pmn31t   #含稅單價
       #     IF NOT cl_null(g_pmn[l_ac].pmn31t) THEN
       #        LET g_pmn[l_ac].pmn31t = cl_digcut(g_pmn[l_ac].pmn31t,t_azi03)  #No.CHI-6A0004
       #        LET g_pmn[l_ac].pmn31 =                                                                                              
       #            g_pmn[l_ac].pmn31t / ( 1 + g_pmn[l_ac].gec04 / 100)
       #        LET g_pmn[l_ac].pmn31 = cl_digcut(g_pmn[l_ac].pmn31,t_azi03)   #No.CHI-6A0004
       #     END IF
#end-----mark by guanyao160722  
 
        BEFORE DELETE                            #是否取消單身
            IF g_pmn_t.sgm01 IS NOT NULL THEN
               LET g_rec_b=g_rec_b-1
            END IF
 
        AFTER DELETE
          LET l_n = ARR_COUNT()
          INITIALIZE g_pmn[l_n+1].* TO NULL
          LET l_jump = 1
 
        AFTER ROW
            IF NOT l_jump THEN
                DISPLAY g_pmn[l_ac].* TO s_pmn[l_sl].*
                IF INT_FLAG THEN                 #900423
                    IF p_cmd='u' THEN
                       LET g_pmn[l_ac].* = g_pmn_t.*
                    END IF
                    DISPLAY g_pmn[l_ac].* TO s_pmn[l_sl].*
                    EXIT INPUT
                END IF
            END IF
 
       ON ACTION CONTROLN
            LET l_exit_sw = "n"
            EXIT INPUT
        ON ACTION help                             #No.TQC-770004                                                                  
            LET g_action_choice="help"             #No.TQC-770004                                                                   
            CALL cl_show_help()                    #No.TQC-770004                                                                   
            CONTINUE INPUT                     #No.TQC-770004       
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmm09) #廠商編號
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmc"
                 LET g_qryparam.default1 = g_pmn[l_ac].pmm09
                 CALL cl_create_qry() RETURNING g_pmn[l_ac].pmm09
                 DISPLAY g_pmn[l_ac].pmm09 TO s_pmn[l_sl].pmm09
                 NEXT FIELD pmm09
              OTHERWISE EXIT CASE
           END CASE
 
        ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name #Add on 040913
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) #Add on 040913
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
        END INPUT
 
        IF l_exit = 'y' THEN RETURN END IF
        LET l_flag='N'
        FOR i=1 TO g_rec_b             #判斷單身是否有輸入
            IF g_pmn[i].sgm01 IS NOT NULL AND g_pmn[i].pmn20>0 THEN
               LET l_flag='Y'
               EXIT FOR
            END IF
        END FOR
        FOR i = 1 TO g_rec_b
            IF g_pmn[i].sgm01 IS NOT NULL AND  g_pmn[i].pmn20 > 0 THEN
               INSERT INTO asfp710_tmp VALUES (g_pmn[i].*)
            END IF
        END FOR
        IF l_flag='Y' THEN        #確認
           IF cl_sure(0,0) THEN
              LET g_success='Y'
              BEGIN WORK
               LET g_start = NULL  #FUN-A60095
               LET g_end   = NULL  #FUN-A60095
               CALL p710_process()   #產生單身
               CALL s_showmsg()           #NO.FUN-710026
              #MESSAGE 'No.  ',g_start,' To  ',g_end   #FUN-A60095
              #CALL ui.Interface.refresh()             #FUN-A60095
               IF g_success = 'Y' THEN
                  COMMIT WORK
                  #FUN-A60095--begin--add------------------
                  CALL cl_getmsg('asf-720',g_lang) RETURNING l_msg
                  LET l_msg = l_msg CLIPPED,'No. ',g_start,' To ',g_end
                  CALL cl_msgany(0,0,l_msg)
                  #FUN-A60095--end--add---------------------
                  CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
               ELSE
                  ROLLBACK WORK
                  CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
               END IF
               CLEAR FORM
               CALL g_pmn.clear()
               IF l_flag THEN
                  CONTINUE WHILE
               ELSE
                  EXIT WHILE
               END IF
           END IF
        END IF
        EXIT WHILE
    END WHILE
 
END FUNCTION
 
#-------------#
# 產生採購單  #
#-------------#
FUNCTION p710_process()
  DEFINE l_pmm09     LIKE pmm_file.pmm09,
         l_cnt       LIKE type_file.num5,         #No.FUN-680121 SMALLINT
         l_nn        LIKE type_file.num5          #No.FUN-680121 SMALLINT
  DEFINE l_pmni      RECORD LIKE pmni_file.*      #No.FUN-7B0018
  DEFINE li_result   LIKE type_file.num5          #No.FUN-550067        #No.FUN-680121 SMALLINT
  DEFINE l_pmh12     LIKE pmh_file.pmh12   #add by guanyao160722
  DEFINE l_pmh19     LIKE pmh_file.pmh19   #add by guanyao160722 
  DEFINE l_tc_pmm06  LIKE tc_pmm_file.tc_pmm06#add by guanyao160722
  DEFINE l_pmj09     LIKE pmj_file.pmj09    #add by guanyao160908
  DEFINE l_pmj07     LIKE pmj_file.pmj07    #add by guanyao160908
  DEFINE l_pmj07t    LIKE pmj_file.pmj07t   #add by guanyao160908
  DEFINE l_tc_pmj09     LIKE tc_pmj_file.tc_pmj09    #add by huanglf161013
  DEFINE l_tc_pmj07     LIKE tc_pmj_file.tc_pmj07    #add by huanglf161013
  DEFINE l_tc_pmj07t    LIKE tc_pmj_file.tc_pmj07t   #add by huanglf161013
  DEFINE l_num       LIKE type_file.num5    #add by huanglf161013
  DEFINE l_sgm04     LIKE sgm_file.sgm04    #add by huanglf161013
  define l_sgm11     like sgm_file.sgm11    #darcy:2022/11/07 add
  LET l_pmm09 = ' '
  LET l_cnt = 1
  LET l_nn = 0
  INITIALIZE g_tmp.* TO NULL
  DECLARE p710_ins_pmm CURSOR FOR
   SELECT * FROM asfp710_tmp
    ORDER BY pmm09      #廠商編號
  CALL s_showmsg_init()    #NO.FUN-710026
  FOREACH p710_ins_pmm INTO g_tmp.*
    IF STATUS THEN 
       LET g_success = 'N'  #No.FUN-8A0086
       CALL s_errmsg('','','foreach tmp',STATUS,0)    #NO.FUN-710026 
        EXIT FOREACH END IF
        IF g_success='N' THEN                                                                                                          
           LET g_totsuccess='N'                                                                                                       
           LET g_success="Y"                                                                                                          
        END IF                    
 
    IF l_cnt = 1 THEN
       LET tm.pmm01=tm.pmm01[1,g_doc_len],'       '  #add by guanyao160723
       SELECT COUNT(*) INTO g_cnt FROM asfp710_tmp
        WHERE pmm09 = g_tmp.pmm09
       IF cl_null(g_cnt) THEN LET g_cnt = 0 END IF
       INITIALIZE l_pmm.* TO NULL
       CALL s_auto_assign_no("apm",tm.pmm01,tm.pmm04,"","pmm_file","pmm01","","","" )
         RETURNING li_result,tm.pmm01
       IF (NOT li_result) THEN
         # RETURN l_pmm.*
         RETURN 
       END IF
       #FUN-A90057(S)
       CALL p710sub_pmm(tm.pmm01,tm.pmm04,g_tmp.pmm09,tm.pmm12,tm.pmm42) RETURNING l_pmm.*            #產生採購單頭資料(新增)
       #FUN-A90057(E)
       LET g_start = tm.pmm01
       LET l_pmm.pmmud06=g_tmp.tc_pmm01 #add by donghy
       INSERT INTO pmm_file VALUES (l_pmm.*)
       IF STATUS OR SQLCA.sqlerrd[3]=0 THEN
          CALL s_errmsg('pmm01',l_pmm.pmm01,'ins pmm',STATUS,0)                #NO.FUN-710026
          LET g_success = 'N'
          CONTINUE FOREACH                                                       #NO.FUN-710026
       END IF
       LET l_nn = 0
    ELSE
       IF l_pmm09 != g_tmp.pmm09 THEN
          LET tm.pmm01=tm.pmm01[1,g_doc_len],'       '
          INITIALIZE l_pmm.* TO NULL
          CALL s_auto_assign_no("apm",tm.pmm01,tm.pmm04,"","pmm_file","pmm01","","","" )
            RETURNING li_result,tm.pmm01
          IF (NOT li_result) THEN
             #RETURN l_pmm.*
             RETURN 
          END IF          
          #FUN-A90057(S)
          CALL p710sub_pmm(tm.pmm01,tm.pmm04,g_tmp.pmm09,tm.pmm12,tm.pmm42) RETURNING l_pmm.*            #產生採購單頭資料(新增)
          #FUN-A90057(E)
          IF cl_null(g_start) THEN LET g_start = tm.pmm01 END IF
          LET l_pmm.pmmud06=g_tmp.tc_pmm01 #add by donghy
          INSERT INTO pmm_file VALUES (l_pmm.*)
          IF SQLCA.sqlcode THEN
             CALL cl_err3("ins","pmm_file",l_pmm.pmm01,"",SQLCA.sqlcode,"","ins pmm",1)    #No.FUN-660128 #NO.FUN-710026
             CALL s_errmsg('pmm01',l_pmm.pmm01,'ins pmm',SQLCA.sqlcode,1)                #NO.FUN-710026
             LET g_success='N'                                                             #NO.FUN-710026     
             CONTINUE FOREACH                                                              #NO.FUN-710026    
          END IF
          LET l_nn = 0
       END IF
     END IF
     LET l_nn=l_nn+1
     #FUN-A90057(S)
     INITIALIZE l_pmn.* TO NULL
     #darcy:2022/11/07 addd s--
     let l_sgm11 = ''
     select sgm11 into l_sgm11 from sgm_file where sgm01 = g_tmp.sgm01 and sgm03 = g_tmp.sgm03

     #darcy:2022/11/07 addd e--

     #str-----add by guanyao160722
     LET l_tc_pmm06 = ''
     SELECT tc_pmm06 INTO l_tc_pmm06 
      FROM tc_pmm_file WHERE tc_pmm01 = g_tmp.tc_pmm01 AND tc_pmmud10 = g_tmp.tc_pmmud10
     #SELECT pmh12,pmh19 INTO l_pmh12,l_pmh19 FROM pmh_file 
     # WHERE pmh01= g_tmp.sgm03_par
     #   AND pmh02 = g_tmp.pmm09
     #   AND pmh13 = tm.pmm22
     #   AND pmh21 = l_tc_pmm06
     #   AND pmh22 = '2'
     #str-----add by guanyao160908
     LET l_pmj09 = ''
     LET l_pmj07 = 0
     LET l_pmj07t =0
     SELECT MAX(pmj09) INTO l_pmj09 FROM pmj_file,pmi_file 
      WHERE pmj03 = g_tmp.sgm03_par 
        AND pmi01 = pmj01
        AND pmi03 = g_tmp.pmm09
        AND pmj10 = l_tc_pmm06
        and pmj11 = l_sgm11  #darcy:2022/11/07 add
        AND pmj12 = '2'
     SELECT pmj07,pmj07t INTO l_pmj07,l_pmj07t FROM pmj_file,pmi_file
      WHERE pmj03 = g_tmp.sgm03_par 
        AND pmi01 = pmj01
        AND pmiconf ='Y'   #add  核价单必须审核
        AND pmi03 = g_tmp.pmm09
        AND pmj10 = l_tc_pmm06
        and pmj11 = l_sgm11  #darcy:2022/11/07 add
        AND pmj09 = l_pmj09
        AND pmj12 = '2'
     IF cl_null(l_pmj07) THEN 
        LET l_pmj07 = 0 
     END IF 
     IF cl_null(l_pmj07t) THEN 
        LET l_pmj07t = 0
     END IF 
#str----add by huanglf161101
    LET l_num = 0
    SELECT DISTINCT sgm04 INTO l_sgm04 FROM sgm_file WHERE sgm45 = g_tmp.sgm45
    SELECT COUNT(*) INTO l_num FROM tc_ecm_file 
    WHERE tc_ecm00 =g_tmp.sgm02 AND tc_ecm01 = g_tmp.sgm03_par AND tc_ecm02 = l_sgm04
    IF l_num > 0 THEN    
         LET l_tc_pmj09 = ''
         LET l_tc_pmj07 = 0
         LET l_tc_pmj07t =0
         SELECT MAX(tc_pmj09) INTO l_tc_pmj09 FROM tc_pmj_file,tc_pmi_file 
          WHERE tc_pmj03 = g_tmp.sgm03_par 
            AND tc_pmi01 = tc_pmj01
            AND tc_pmi03 = g_tmp.pmm09
            AND tc_pmj10 = l_tc_pmm06
            and tc_pmj11 = l_sgm11  #darcy:2022/11/07 add
            AND tc_pmj12 = '2'
            AND tc_pmiconf = 'Y'
         SELECT tc_pmj07,tc_pmj07t INTO l_tc_pmj07,l_tc_pmj07t FROM tc_pmj_file,tc_pmi_file
          WHERE tc_pmj03 = g_tmp.sgm03_par 
            AND tc_pmi01 = tc_pmj01
            AND tc_pmi03 = g_tmp.pmm09
            AND tc_pmj10 = l_tc_pmm06
            and tc_pmj11 = l_sgm11  #darcy:2022/11/07 add
            AND tc_pmj09 = l_tc_pmj09
            AND tc_pmj12 = '2'
            AND tc_pmiconf = 'Y'
     END IF 
     IF cl_null(l_tc_pmj07) THEN 
            LET l_tc_pmj07 = 0 
     END IF 
     IF cl_null(l_tc_pmj07t) THEN 
            LET l_tc_pmj07t = 0
     END IF 
#str-----end by huanglf161101
#str-----add by huanglf161101
 IF l_tc_pmj07 = 0 OR l_tc_pmj07t = 0 THEN 
     IF l_pmj07 = 0 OR l_pmj07t = 0 THEN
     #end-----add by guanyao160908
     #IF cl_null(l_pmh12) OR cl_null(l_pmh19) THEN 
            CALL s_errmsg('pmm01',g_tmp.sgm01,g_tmp.sgm03,'csf-039',1)                #NO.FUN-710026
            LET g_success='N'                                                             #NO.FUN-710026     
            CONTINUE FOREACH
      END IF 
 ELSE 
             LET l_pmj07= l_tc_pmj07
             LET l_pmj07t = l_tc_pmj07t 
END IF 
#str----end by huanglf161101

#str-----add by huanglf161013
    --LET l_num = 0
    --SELECT DISTINCT sgm04 INTO l_sgm04 FROM sgm_file WHERE sgm45 = g_tmp.sgm45
    --SELECT COUNT(*) INTO l_num FROM tc_ecm_file 
    --WHERE tc_ecm00 =g_tmp.sgm02 AND tc_ecm01 = g_tmp.sgm03_par AND tc_ecm02 = l_sgm04
    --IF l_num > 0 THEN    
         --LET l_tc_pmj09 = ''
         --LET l_tc_pmj07 = 0
         --LET l_tc_pmj07t =0
         --SELECT MAX(tc_pmj09) INTO l_tc_pmj09 FROM tc_pmj_file,tc_pmi_file 
          --WHERE tc_pmj03 = g_tmp.sgm03_par 
            --AND tc_pmi01 = tc_pmj01
            --AND tc_pmi03 = g_tmp.pmm09
            --AND tc_pmj10 = l_tc_pmm06
            --AND tc_pmj12 = '2'
            --AND tc_pmiconf = 'Y'
         --SELECT tc_pmj07,tc_pmj07t INTO l_tc_pmj07,l_tc_pmj07t FROM tc_pmj_file,tc_pmi_file
          --WHERE tc_pmj03 = g_tmp.sgm03_par 
            --AND tc_pmi01 = tc_pmj01
            --AND tc_pmi03 = g_tmp.pmm09
            --AND tc_pmj10 = l_tc_pmm06
            --AND tc_pmj09 = l_tc_pmj09
            --AND tc_pmj12 = '2'
            --AND tc_pmiconf = 'Y'
         --IF cl_null(l_tc_pmj07) THEN 
            --LET l_tc_pmj07 = 0 
         --END IF 
         --IF cl_null(l_tc_pmj07t) THEN 
            --LET l_tc_pmj07t = 0
         --END IF 
         --IF l_tc_pmj07 = 0 OR l_tc_pmj07 = 0 THEN  
            --CALL s_errmsg('pmm01',g_tmp.sgm01,g_tmp.sgm03,'csf-039',1)                #NO.FUN-710026
            --LET g_success='N'                                                             #NO.FUN-710026     
            --CONTINUE FOREACH 
         --END IF 
     --LET g_tmp.pmn31 = l_tc_pmj07
     --LET g_tmp.pmn31t = l_tc_pmj07t
   #ELSE 
#str-----end by huanglf161013
     LET g_tmp.pmn31 = l_pmj07
     LET g_tmp.pmn31t = l_pmj07t
  # END IF 
     #LET g_tmp.pmn31 = l_pmh12
     #LET g_tmp.pmn31t= l_pmh19
     #end-----add by guanyao160722
     CALL p710sub_pmn(tm.pmm01,l_nn,g_tmp.sgm03_par,g_tmp.sgm012,g_tmp.sgm01,
                      g_tmp.sgm03,g_tmp.sgm02,g_tmp.pmn20,g_tmp.pmn31,
                      g_tmp.pmn31t,g_tmp.pmn33,l_pmm.pmm13,l_pmm.pmm22) 
          RETURNING l_pmn.*
     #FUN-A90057(E)

     IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF    #No.FUN-B30177
     #str----add by guanyao160908
     LET l_pmn.pmn18 =g_tmp.sgm01
     LET l_pmn.pmn41 =g_tmp.sgm02
     LET l_pmn.pmn32 =g_tmp.sgm03
     LET l_pmn.pmn012 = ' '
     LET l_pmn.pmn43 = g_tmp.sgm03
     #end----add by guanyao160908
     CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                     l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
     #LET l_pmn.pmnud02= g_tmp.sgm03   #add by guanyao160512 
     LET l_pmn.pmnud03 = 'N'          #add by guanyao160512 
     #LET l_pmn.pmnud04= g_tmp.sgm01   #add by guanyao160512   
     #str-----add by guanyao160722
     UPDATE tc_pmm_file SET tc_pmmud06 = l_pmn.pmn01,
                            tc_pmmud11 = l_pmn.pmn02
                      WHERE tc_pmm01 =g_tmp.tc_pmm01
                        AND tc_pmmud10 =g_tmp.tc_pmmud10
     IF SQLCA.sqlcode THEN
        CALL cl_err3("upd","tc_pmm_file",g_tmp.tc_pmm01,g_tmp.tc_pmmud10,SQLCA.sqlcode,"","upd tc_pmm_file",1)    #No.FUN-660128 #NO.FUN-710026
        CALL s_errmsg('tc_pmm01',g_tmp.tc_pmm01,'upd tc_pmm_file',SQLCA.sqlcode,1)                         #NO.FUN-710026
        LET g_success='N'                                                                      #NO.FUN-710026
        CONTINUE FOREACH                                                                       #NO.FUN-710026
     END IF
     #end-----add by guanyao160722
     INSERT INTO pmn_file VALUES (l_pmn.*)
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","pmn_file",l_pmn.pmn01,l_pmn.pmn02,SQLCA.sqlcode,"","ins pmn",1)    #No.FUN-660128 #NO.FUN-710026
        CALL s_errmsg('pmm01',l_pmm.pmm01,'ins pmn',SQLCA.sqlcode,1)                         #NO.FUN-710026
        LET g_success='N'                                                                      #NO.FUN-710026
        CONTINUE FOREACH                                                                       #NO.FUN-710026
     END IF
     #FUN-A60095--begin--add-------------
     CALL p710_pmm40()     #update 採購單頭的總金額
     IF g_success = 'N' THEN CONTINUE FOREACH END IF
     #FUN-A60095--end--add---------------
     IF NOT s_industry('std') THEN
        INITIALIZE l_pmni.* TO NULL
        LET l_pmni.pmni01 = l_pmn.pmn01
        LET l_pmni.pmni02 = l_pmn.pmn02
        IF NOT s_ins_pmni(l_pmni.*,'') THEN
           LET g_success='N'                                                                      #NO.FUN-710026
           CONTINUE FOREACH                                                                       #NO.FUN-710026
        END IF
     END IF
     LET l_cnt = l_cnt + 1
     LET l_pmm09 = g_tmp.pmm09
   END FOREACH
   IF g_totsuccess="N" THEN                                                                                                         
      LET g_success="N"                                                                                                             
   END IF 
 
  #FUN-A60095--begin--mark----------
  #LET g_end = tm.pmm01
  #IF g_start IS NOT NULL THEN
  #   SELECT SUM(pmn20*pmn31),SUM(pmn20*pmn31t)
  #     INTO g_tot,g_tott
  #     FROM pmn_file
  #    WHERE pmn01 BETWEEN g_start AND g_end
  #   LET g_tot = cl_digcut(g_tot,t_azi04)  #No.CHI-6A0004
  #   LET g_tott= cl_digcut(g_tott,t_azi04)   #No.CHI-6A0004
  #   UPDATE pmm_file SET pmm40 = g_tot,
  #                       pmm40t= g_tott
  #    WHERE pmm01 BETWEEN g_start AND g_end
  #   IF SQLCA.sqlcode THEN
  #      CALL s_errmsg('','','upd pmm40',SQLCA.sqlcode,1)                             #NO.FUN-710026  
  #      LET g_success='N'                                                            #NO.FUN-710026  
  #   END IF
  #END IF
  #FUN-A60095--end--mark------------- 
END FUNCTION
 
FUNCTION  p710_pmm40()     #update 採購單頭的總金額
 
#  SELECT SUM(pmn20*pmn31),SUM(pmn20*pmn31t)   #CHI-B70039 mark
   SELECT SUM(pmn87*pmn31),SUM(pmn87*pmn31t)   #CHI-B70039
     INTO g_tot,g_tott
     FROM pmn_file
    WHERE pmn01 = tm.pmm01
   LET g_tot = cl_digcut(g_tot,t_azi04)   #No.CHI-6A0004
   LET g_tott= cl_digcut(g_tott,t_azi04)  #No.CHI-6A0004
   UPDATE pmm_file SET pmm40 = g_tot,
                       pmm40t= g_tott
    WHERE pmm01 = tm.pmm01
   IF SQLCA.sqlcode THEN
      LET g_success='N'
      CALL s_errmsg('pmm01',tm.pmm01,'upd pmm40',SQLCA.sqlcode,1)   #FUN-A60095
      RETURN
   END IF
END FUNCTION
 

FUNCTION p710_pmm09()   #供應商check
   DEFINE l_pmcacti   LIKE pmc_file.pmcacti,
          l_pmc05     LIKE pmc_file.pmc05,
          l_pmc22     LIKE pmc_file.pmc22
 
   LET g_errno=' '
   SELECT pmcacti,pmc05,pmc03,pmc22,pmc47
     INTO l_pmcacti,l_pmc05,g_pmc03,l_pmc22,g_pmn[l_ac].pmc47
     FROM pmc_file
    WHERE pmc01=g_pmn[l_ac].pmm09
   CASE WHEN SQLCA.sqlcode=100  LET g_errno='mfg3014'
                                LET g_pmc03=NULL
        WHEN l_pmcacti='N'      LET g_errno='9028'
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        WHEN l_pmc05='0'        LET g_errno='aap-032'
                                LET g_pmc03=NULL
        WHEN l_pmc05='3'        LET g_errno='aap-033'
                                LET g_pmc03=NULL
   END CASE
   LET g_pmn[l_ac].pmc03 = g_pmc03
   DISPLAY g_pmn[l_ac].pmc03 TO s_pmn[l_sl].pmc03
 
   SELECT gec04,gec07 INTO g_pmn[l_ac].gec04,g_gec07
     FROM gec_file WHERE gec01 = g_pmn[l_ac].pmc47
   IF cl_null(g_gec07) THEN LET g_gec07 = 'N' END IF
 
END FUNCTION
 
FUNCTION p710_pmm22()  #幣別
   DEFINE l_aziacti LIKE azi_file.aziacti
 
   LET g_errno = " "
   SELECT azi03,aziacti INTO t_azi03,l_aziacti FROM azi_file   #No.FUN-550109   #No.CHI-6A0004
    WHERE azi01 = tm.pmm22
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3008'
                                  LET l_aziacti = NULL
        WHEN l_aziacti='N' LET g_errno = '9028'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION
 
FUNCTION p710_pmm12()  #人員
  DEFINE l_gen02     LIKE gen_file.gen02,
         l_genacti   LIKE gen_file.genacti
 
    LET g_errno = ' '
    SELECT gen02,genacti INTO l_gen02,l_genacti
      FROM gen_file WHERE gen01 = tm.pmm12
 
    CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'aap-038'
                            LET l_gen02 = NULL
         WHEN l_genacti='N' LET g_errno = '9028'
         OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
    END CASE
    IF cl_null(g_errno)  THEN
       DISPLAY l_gen02  TO FORMONLY.gen02
    END IF
END FUNCTION
 
FUNCTION p710_cre_tmp()
 
    DROP TABLE asfp710_tmp;
    CREATE TEMP TABLE asfp710_tmp(
       sgm01        LIKE sgm_file.sgm01,
       sgm02        LIKE sgm_file.sgm02,
       sgm45        LIKE sgm_file.sgm45,
       sgm012       LIKE sgm_file.sgm012, #FUN-A60095
       ecu014       LIKE ecu_file.ecu014, #FUN-A60095
       sgm03        LIKE sgm_file.sgm03,
       sgm03_par    LIKE sgm_file.sgm03_par,
       ima02        LIKE ima_file.ima02,
       ima021       LIKE ima_file.ima021,
#      subqty       LIKE ima_file.ima26,
       subqty       LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
       pmm09        LIKE pmm_file.pmm09,
       pmc03        LIKE pmc_file.pmc03,
       pmn20        LIKE pmn_file.pmn20,
       pmn33        LIKE pmn_file.pmn33,
       pmn31        LIKE pmn_file.pmn31,
       pmn31t       LIKE pmn_file.pmn31t,
       pmc47        LIKE pmc_file.pmc47,
       gec04        LIKE nmz_file.nmz57,
       tc_pmm01     LIKE tc_pmm_file.tc_pmm01,
       tc_pmmud10   LIKE tc_pmm_file.tc_pmmud10)
 
END FUNCTION
 
FUNCTION p710_set_entry_b()
 
   CALL cl_set_comp_entry("pmn31,pmn31t",TRUE)
 
END FUNCTION
 
FUNCTION p710_set_no_entry_b()
 
   IF g_gec07 = 'N' THEN     #No.FUN-560102
      CALL cl_set_comp_entry("pmn31t",FALSE)
   ELSE
      CALL cl_set_comp_entry("pmn31",FALSE)
   END IF
 
END FUNCTION
#No.FUN-9C0072 精簡程式碼


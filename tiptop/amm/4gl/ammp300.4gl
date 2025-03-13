# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: ammp300.4gl
# Descriptions...: 完工結轉
# Date & Author..: 00/12/18 By plum,chien
# Modify.........: No.MOD-461010 04/07/23 Kammy
# Modify.........: No.MOD-480018 04/08/03 Wiky mmp300 結轉動作時 ,針對採購入庫
#                                              /委外工單入庫 在數量的時候會過不去
# Modify.........: No.MOD-480319 04/08/16 Kammy mmb07不論是'S''M''P'pmn65皆應=1
# Modify.........: NO.MOD-490217 04/09/10 by yiting 料號欄位放大
# Modify.........: NO.MOD-460966 Kammy 結轉工單的狀態碼為空的
# Modify.........: No.MOD-4A0014 Kammy 結轉工單時，發料與入庫資料不參考模具設定
# Modify.........: NO.MOD-4A0038 Mandy double-click,無法維護單身
# Modify.........: No.MOD-4A0042 Kammy 結轉完後，單身立刻重 show
# Modify.........: No.MOD-4B0195 04/11/18 By Mandy UPDATE pmn31後,須重新計算pmm40欄位
# Modify.........: No.MOD-530688 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-550054 05/05/17 By yoyo單據編號格式放大
# Modify.........: No.MOD-580322 05/08/30 By wujie  中文資訊修改進 ze_file
# Modify.........: No.TQC-610003 06/01/17 By Nicola INSERT INTO sfb_file 時,特性代碼欄位(sfb95)應抓取該工單單頭生產料件在料件主檔(ima_file)設定的'主特性代碼'欄位(ima910)
# Modify.........: No.TQC-640132 06/04/17 By Nicola pml33,pml34計算方式修改
# Modify.........: No.FUN-660094 06/06/12 By CZH cl_err-->cl_err3
# Modify.........: No.FUN-660106 06/06/16 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660079 06/06/20 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.MOD-660135 06/06/30 By cl   含稅單價pmm40t補充修改
# Modify.........: No.FUN-670061 06/07/17 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680006 06/08/03 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680100 06/08/28 By huchenghao 類型轉換
# Modify.........: No.FUN-690024 06/09/18 By jamie 判斷pmcacti
# Modify.........: No.FUN-6A0076 06/10/26 By hongmei l_time轉g_time
# Modify.........: No.CHI-6A0004 06/10/24 By yjkhero g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: NO.CHI-6A0016 06/10/27 BY yiting pml190/pml191/pml192預設
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........: No.FUN-6B0030 06/11/17 By Carrier 新增單頭折疊功能
# Modfiy.........: No.CHI-690043 06/11/22 By Sarah pmn_file增加pmn90(取出單價),INSERT INTO pmn_file前要增加LET pmn90=pmn31
# Modfiy.........: No.CHI-680014 06/12/04 By rainy INSERT INTO pmn_file時，要處理pmn88/pmn88t
# Modfiy.........: No.TQC-6C0179 06/12/27 By Ray CONSTRUCT順序及抓資料條件問題
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.........: No.FUN-7B0014 08/01/29 By bnlent 行業別規範修改,拆table需修改 
# Modify.........: No.FUN-7B0018 08/02/17 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-840142 08/04/21 By kim GP5.1顧問測試修改
# Modify.........: No.FUN-860069 08/06/18 By Sherry 增加輸入日期(sfu14)
# Modify.........: No.FUN-870163 08/07/31 By sherry 預設申請數量=原異動數量
# Modify.........: No.MOD-8B0086 08/11/07 By chenyu 沒有取替代時，讓sfs27=sfa27
# Modify.........: No.FUN-940008 09/05/06 By hongmei GP5.2發料改善
# Modify.........: No.TQC-940016 09/05/11 By destiny 刪去程序中沒有使用的cn3 
# Modify.........: No.FUN-960130 09/08/13 By Sunyanchun 零售業的必要欄位賦值
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.TQC-990132 09/10/13 By lilingyu "需求零件單"增加開窗功能
# Modify.........: No:FUN-9B0023 09/11/04 By baofei寫入請購單身時，也要一併寫入"電子採購否(pml92)"='N'
# Modify.........: No.FUN-9B0016 09/10/31 By sunyanchun post no
# Modify.........: No.TQC-9B0203 09/11/24 By douzh pmn58為NULL時賦初始值0
# Modify.........: No:MOD-A10057 10/01/13 By Smapmin sfq04/sfq05是key值,故要給default值
# Modify.........: No.FUN-9C0073 10/01/14 By chenls 程序精簡
# Modify.........: NO:MOD-A10152 10/01/27 By Smapmin 產生發料單時,要default資料所有者等欄位
# Modify.........: No.FUN-A20044 10/04/06 By vealxu ima26x 調整
# Modify.........: No.FUN-9C0076 10/04/06 By Lilan EF整合新增欄位(rva32,rva33,rvamksg)給予預設值
# Modify.........: No.TQC-A50087 10/05/20 By liuxqa sfb104 赋初值.
# Modify.........: No.FUN-A60027 10/06/07 By vealxu 製造功能優化-平行制程（批量修改） 
# Modify.........: No.TQC-A70004 10/07/01 By yinhy INSERT INTO pmn_file時，如果pmn012為空給' ' 
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No:MOD-B10007 11/01/03 By sabrina 將sfb02='7'改成sfb02='8'
# Modify.........: No:MOD-B10008 11/01/03 By sabrina (1)sfb94應依工單單別抓取smy57_2做為default值
#                                                    (2)sfb44 default g_user
#                                                    (3)sfb93 default 'N' 
# Modify.........: No:CHI-B10001 11/03/08 By sabrina 寫入工單時，應將開發執行單號記錄在母工單號(sfb86)
#                                                    需求單號與項次記錄在備註(sfb96) 
# Modify.........: No.FUN-A80128 11/03/09 By Mandy 因asft620 新增EasyFlow整合功能影響INSERT INTO sfu_file
# Modify.........: No:FUN-AB0001 11/04/25 By Lilan 因asfi510 新增EasyFlow整合功能影響INSERT INTO sfp_file
# Modify.........: No.FUN-B20095 11/07/01 By lixh1 新增sfq012(製程段號)
# Modify.........: No.FUN-B70015 11/07/08 By yangxf 經營方式默認給值'1'經銷
# Modify.........: No.FUN-B70074 11/07/25 By lixh1  增加行業別TABLE(sfsi_file)的處理(inbi_file/sfvi_file By fengrui)
# Modify.........: No:CHI-B70039 11/08/17 By johung 金額 = 計價數量 x 單價
# Modify.........: No:CHI-B80004 11/10/10 By Vampire 在有簽核欄位時都要重新抓取smy_file的smyapr欄位做寫入
# Modify.........: No:FUN-910088 11/11/22 By chenjing 增加數量欄位小數取位
# Modify.........: No.FUN-BB0085 11/11/28 By xianghui 增加數量欄位小數取位
# Modify.........: No.FUN-BB0084 11/12/13 By lixh1 增加數量欄位小數取位(sfs_file)
# Modify.........: No:FUN-BB0086 11/12/20 By tanxc 增加數量欄位小數取位
# Modify.........: No:FUN-C10002 12/02/01 By bart 作業編號pmn78帶預設值
# Modify.........: No:FUN-C70014 12/07/16 By suncx 新增sfq014,sfs014
# Modify.........: No.FUN-CB0087 12/12/20 By fengrui 倉庫單據理由碼改善 ,xujing inb_file

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE   g_mma              RECORD LIKE mma_file.*,
         g_mma_t            RECORD LIKE mma_file.*,
         g_mma_o            RECORD LIKE mma_file.*,
         g_mmb              DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                            mmb02     LIKE mmb_file.mmb02,
                            mmbacti   LIKE mmb_file.mmbacti,
                            mmb05     LIKE mmb_file.mmb05,
                            mmb07     LIKE mmb_file.mmb07,
                            mmb08     LIKE mmb_file.mmb08,
                            desc1     LIKE gem_file.gem02,    #No.FUN-680100 VARCHAR(10)#廠商,部門
                            mmb16     LIKE mmb_file.mmb16,
                            mmb17     LIKE mmb_file.mmb17,
                            mmb18     LIKE mmb_file.mmb18,
                            mmb19     LIKE mmb_file.mmb19,
                            mmb20     LIKE mmb_file.mmb20,
                            mmb14     LIKE mmb_file.mmb14,
                            mmb141    LIKE mmb_file.mmb141,
                            mmb06     LIKE mmb_file.mmb06
                            END RECORD,
         g_mmb_t            RECORD
                            mmb02     LIKE mmb_file.mmb02,
                            mmbacti   LIKE mmb_file.mmbacti,
                            mmb05     LIKE mmb_file.mmb05,
                            mmb07     LIKE mmb_file.mmb07,
                            mmb08     LIKE mmb_file.mmb08,
                            desc1     LIKE gem_file.gem02,    #No.FUN-680100 VARCHAR(10)#廠商,部門
                            mmb16     LIKE mmb_file.mmb16,
                            mmb17     LIKE mmb_file.mmb17,
                            mmb18     LIKE mmb_file.mmb18,
                            mmb19     LIKE mmb_file.mmb19,
                            mmb20     LIKE mmb_file.mmb20,
                            mmb14     LIKE mmb_file.mmb14,
                            mmb141    LIKE mmb_file.mmb141,
                            mmb06     LIKE mmb_file.mmb06
                            END RECORD,
         g_img              RECORD LIKE img_file.*,
          g_wc,g_wc2,g_sql   STRING,  #No.FUN-580092 HCN        #No.FUN-680100
         g_t1                LIKE oay_file.oayslip,              #No.FUN-550054        #No.FUN-680100 VARCHAR(5)
 
         l_ac               LIKE type_file.num5,          #No.FUN-680100 SMALLINT
         g_rec_b            LIKE type_file.num5,          #單身筆數        #No.FUN-680100 SMALLINT
         l_cmd              LIKE type_file.chr50,         #No.FUN-680100 VARCHAR(50)
         g_flag             LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
         issue_type         LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
         short_data         LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
         b_part,e_part      LIKE type_file.chr20,         #No.FUN-680100 VARCHAR(20)
         part_type          LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
         noqty              LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)#庫存不足時,是否產生    = l_mmb141
        #qty_alo            LIKE ima_file.ima26,          #No.FUN-680100 DEC(15,3)   #FUN-A20044
         qty_alo            LIKE type_file.num15_3,       #No.FUN-A20044  
         ware_no, loc_no, lot_no LIKE aag_file.aag01,     #No.FUN-680100 VARCHAR(24)
         g_no               LIKE oea_file.oea01,          #No.FUN-680100 VARCHAR(16)#No.FUN-550054
         g_con              LIKE type_file.num5,          #No.FUN-680100 SMALLINT
         g_argv1            LIKE mma_file.mma01,
         g_pmk01            LIKE pmk_file.pmk01,
         g_pmm01            LIKE pmm_file.pmm01,
         g_rva01            LIKE rva_file.rva01,
         g_rvu01            LIKE rvu_file.rvu01,
         g_sfb01            LIKE sfb_file.sfb01,
         g_ina01            LIKE ina_file.ina01,
         g_sfp01            LIKE sfp_file.sfp01,
         g_sfu01            LIKE sfu_file.sfu01,
         g_pmk              RECORD LIKE pmk_file.*,
         g_pml              RECORD LIKE pml_file.*,
         g_pmm              RECORD LIKE pmm_file.*,
         g_pmn              RECORD LIKE pmn_file.*,
         g_rva              RECORD LIKE rva_file.*,
         g_rvb              RECORD LIKE rvb_file.*,
         g_sfb              RECORD LIKE sfb_file.*,
         g_sfa              RECORD LIKE sfa_file.*,
         g_ina              RECORD LIKE ina_file.*,
         g_sfp              RECORD LIKE sfp_file.*,
         g_mml              RECORD LIKE mml_file.*
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680100 INTEGER
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose        #No.FUN-680100 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000      #No.FUN-680100 VARCHAR(72)
DEFINE   g_forupd_sql    STRING                      #No.FUN-680100
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680100 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
MAIN
   DEFINE   p_row,p_col   LIKE type_file.num5          #No.FUN-680100 SMALLINT
   OPTIONS                               #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   IF (NOT cl_user()) THEN
     EXIT PROGRAM
    END IF
 
    WHENEVER ERROR CALL cl_err_msg_log
 
    IF (NOT cl_setup("AMM")) THEN
      EXIT PROGRAM
    END IF
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
   OPEN WINDOW p300_w AT p_row,p_col WITH FORM "amm/42f/ammp300"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   LET g_forupd_sql = "SELECT * FROM mma_file WHERE mma01 = ? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p300_cl CURSOR FROM g_forupd_sql
 
   LET g_argv1 = ARG_VAL(1) #FUN-840142
   IF NOT cl_null(g_argv1) THEN CALL p300_q() END IF
 
   CALL p300_menu()
   CLOSE WINDOW p300_w                 #結束畫面
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0076
END MAIN
 
FUNCTION p300_cs()
 
   CLEAR FORM                             #清除畫面
   CALL g_mmb.clear()
   CALL cl_set_head_visible("","YES")   #No.FUN-6B0030
   IF cl_null(g_argv1) THEN
   INITIALIZE g_mma.* TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON                     # 螢幕上取單頭條件
       mma01,mma02,mma021,mma03,mma05,
       mma07,mma09,mma10,mma14,
       mma15,mma20,mma17,mmaacti
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
    ON ACTION controlp
      CASE
        WHEN INFIELD(mma01)
              CALL cl_init_qry_var()
              LET g_qryparam.state = 'c'
              LET g_qryparam.form ="q_mma01"  
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO mma01
              NEXT FIELD mma01
       END CASE       
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
      CONSTRUCT g_wc2 ON mmb02,mmbacti,mmb05,mmb07,mmb08,
                         mmb16,mmb17,mmb18,mmb19,mmb20,mmb14,mmb141,mmb06
              FROM s_mmb[1].mmb02,s_mmb[1].mmbacti,
                   s_mmb[1].mmb05, s_mmb[1].mmb07,
                   s_mmb[1].mmb08, s_mmb[1].mmb16, s_mmb[1].mmb17,
                   s_mmb[1].mmb18, s_mmb[1].mmb19, s_mmb[1].mmb20,
                   s_mmb[1].mmb14, s_mmb[1].mmb141,s_mmb[1].mmb06
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END CONSTRUCT
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = "mma01 = '",g_argv1,"'"
      LET g_wc2 = " 1=1"                        # 若單身未輸入條件
   END IF
   #資料權限的檢查
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond('mmauser', 'mmagrup')
 
   IF g_wc2 = " 1=1" THEN                      # 若單身未輸入條件
      LET g_sql = "SELECT  mma01 FROM mma_file",
                  " WHERE ", g_wc CLIPPED,
                  " ORDER BY mma01"
   ELSE                                       # 若單身有輸入條件
      LET g_sql = "SELECT DISTINCT mma_file. mma01 ",
                  "  FROM mma_file, mmb_file",
                  " WHERE mma01 = mmb01",
                  "   AND mmbacti = 'Y' ",     #No.TQC-6C0179
                   "   AND mmb14   = 'N' ",     #No.TQC-6C0179         
                  "   AND ", g_wc CLIPPED, " AND ",g_wc2 CLIPPED,
                  " ORDER BY mma01"
   END IF
 
   PREPARE p300_prepare FROM g_sql
   DECLARE p300_cs                         #SCROLL CURSOR
      SCROLL CURSOR WITH HOLD FOR p300_prepare
 
   IF g_wc2 = " 1=1" THEN                      # 取合乎條件筆數
      LET g_sql="SELECT COUNT(*) FROM mma_file WHERE ",g_wc CLIPPED
   ELSE
      LET g_sql="SELECT COUNT(DISTINCT mma01) FROM mma_file,mmb_file WHERE ",
                "mmb01=mma01 AND mmbacti = 'Y' AND mmb14 = 'N'",     #No.TQC-6C0179
                " AND ",g_wc CLIPPED," AND ",g_wc2 CLIPPED     #No.TQC-6C0179
   END IF
   PREPARE p300_precount FROM g_sql
   DECLARE p300_count CURSOR FOR p300_precount
END FUNCTION
 
#中文的MENU
FUNCTION p300_menu()
   CALL ary_mml_cur()    #宣告額外領料檔
   WHILE TRUE
      CALL p300_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL p300_q()
            END IF
         WHEN "next"
            CALL p300_fetch('N')
         WHEN "previous"
            CALL p300_fetch('P')
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL p300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "undo_trans"
            IF cl_chk_act_auth() THEN
               CALL p300_d()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "jump"
            CALL p300_fetch('/')
         WHEN "controlg"
            CALL cl_cmdask()
      END CASE
   END WHILE
END FUNCTION
 
 
FUNCTION ary_mml_cur()
   DEFINE   l_sql   STRING        #No.FUN-680100
 
   LET l_sql=" SELECT * FROM mml_file ",
             " WHERE mml01 = ? " ,
             "   AND mml02 = ? " ,
             " ORDER BY mml021 "
   PREPARE mml_pre FROM l_sql
   DECLARE mml_cur CURSOR FOR mml_pre
 
END FUNCTION
 
FUNCTION p300_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
   CALL cl_opmsg('q')
   MESSAGE ""
   DISPLAY '   ' TO FORMONLY.cnt
   CALL p300_cs()
   IF INT_FLAG THEN LET INT_FLAG = 0 INITIALIZE g_mma.* TO NULL RETURN END IF
   MESSAGE " SEARCHING ! "
   OPEN p300_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_mma.* TO NULL
   ELSE
      OPEN p300_count
      FETCH p300_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt
      CALL p300_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
   MESSAGE ""
END FUNCTION
 
FUNCTION p300_fetch(p_flag)
   DEFINE   p_flag   LIKE type_file.chr1,                 #處理方式        #No.FUN-680100 VARCHAR(1)
            l_abso   LIKE type_file.num10                 #絕對的筆數      #No.FUN-680100 INTEGER
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     p300_cs INTO g_mma.mma01
      WHEN 'P' FETCH PREVIOUS p300_cs INTO g_mma.mma01
      WHEN 'F' FETCH FIRST    p300_cs INTO g_mma.mma01
      WHEN 'L' FETCH LAST     p300_cs INTO g_mma.mma01
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
          FETCH ABSOLUTE g_jump p300_cs INTO g_mma.mma01
          LET mi_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_mma.* TO NULL  #TQC-6B0105
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
   SELECT * INTO g_mma.* FROM mma_file WHERE mma01 = g_mma.mma01
   IF SQLCA.sqlcode THEN
       CALL cl_err3("sel","mma_file",g_mma.mma01,"",SQLCA.SQLCODE,"","",1)       #NO.FUN-660094
      INITIALIZE g_mma.* TO NULL
      RETURN
   END IF
   CALL p300_show()
END FUNCTION
 
FUNCTION p300_show()
 
   LET g_mma_t.* = g_mma.*                #保存單頭舊值
   DISPLAY BY NAME
       g_mma.mma01,g_mma.mma02,g_mma.mma021,g_mma.mma03,g_mma.mma05,
       g_mma.mma07,g_mma.mma09,g_mma.mma10,g_mma.mma14,
       g_mma.mma15,g_mma.mma20,g_mma.mma17,g_mma.mmaacti
   CALL p300_mma20()
   CALL p300_b_fill(g_wc2)
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION p300_mma20()
   DEFINE   l_desc   LIKE gsb_file.gsb05      #No.FUN-680100 VARCHAR(04)
 
   CASE g_mma.mma20
      WHEN '1'  LET l_desc='治具'
      WHEN '2'  LET l_desc='塑模'
      WHEN '3'  LET l_desc='沖模'
      WHEN '4'  LET l_desc='其他'
      OTHERWISE LET l_desc=' '
   END CASE
   DISPLAY l_desc TO FORMONLY.desc
END FUNCTION
 
FUNCTION p300_b()
   DEFINE   l_mmb            RECORD LIKE mmb_file.*
   DEFINE   l_mmb14          LIKE mmb_file.mmb14
   DEFINE   l_ac_t           LIKE type_file.num5,                #未取消的ARRAY CNT        #No.FUN-680100 SMALLINT
            l_n,l_cnt        LIKE type_file.num5,                #檢查重複用        #No.FUN-680100 SMALLINT
            l_lock_sw        LIKE type_file.chr1,                #單身鎖住否        #No.FUN-680100 VARCHAR(1)
            p_cmd            LIKE type_file.chr1,                #處理狀態          #No.FUN-680100 VARCHAR(1)
            l_possible       LIKE type_file.num5,                #No.FUN-680100 SMALLINT#用來設定判斷重複的可能性
            l_cmd            LIKE type_file.chr1000,             #No.FUN-680100 VARCHAR(30)
            l_allow_insert   LIKE type_file.chr1,                #No.FUN-680100 VARCHAR(1)
            l_allow_delete   LIKE type_file.chr1                 #No.FUN-680100 VARCHAR(1)
 
   LET g_action_choice = ""
 
   IF g_mma.mma01 IS NULL THEN RETURN END IF
   IF g_mma.mma17 = 'N' THEN CALL cl_err('',9029,0) RETURN END IF
   IF g_mma.mmaacti = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
 
   SELECT COUNT(*) INTO g_cnt FROM mmb_file
    WHERE mmb01=g_mma.mma01 AND mmbacti='Y'
   IF g_cnt =0 THEN
      CALL cl_err(g_mma.mma01,9024,0) RETURN
   END IF
   #若單身全都已結轉,就不進入單身
   SELECT COUNT(*) INTO g_cnt FROM mmb_file
    WHERE mmb01=g_mma.mma01
   IF g_cnt !=0 THEN
      SELECT COUNT(*) INTO g_cnt FROM mmb_file
       WHERE mmb01=g_mma.mma01 AND mmb14 !='Y'
      IF g_cnt =0 THEN
         CALL cl_err(g_mma.mma01,'amm-009',0) RETURN
      END IF
   ELSE
      CALL cl_err(g_mma.mma01,'arm-034',0) RETURN
   END IF
 
   LET l_allow_insert = cl_detail_input_auth('insert')
   LET l_allow_delete = cl_detail_input_auth('delete')
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT mmb02,mmbacti,mmb05,mmb07,mmb08,'',mmb16,",
                      "       mmb17,mmb18,mmb19,mmb20,mmb14,mmb141,''",
                      "  FROM mmb_file",
                      " WHERE mmb01 = ? AND mmb02 = ?",
                      "   FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE p300_bcl CURSOR FROM g_forupd_sql
 
   INPUT ARRAY g_mmb WITHOUT DEFAULTS FROM s_mmb.*
         ATTRIBUTE (COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                    INSERT ROW = FALSE,DELETE ROW=FALSE,APPEND ROW= FALSE)
 
      BEFORE INPUT
          IF g_rec_b != 0 THEN
             CALL fgl_set_arr_curr(l_ac)
          END IF
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'                   #DEFAULT
         LET l_n  = ARR_COUNT()
         BEGIN WORK
         OPEN p300_cl USING g_mma.mma01
         IF STATUS THEN
            CALL cl_err("OPEN p300_cl:", STATUS, 1)
            CLOSE p300_cl
            ROLLBACK WORK
            RETURN
         END IF
         FETCH p300_cl INTO g_mma.*  # 鎖住將被更改或取消的資料
         IF SQLCA.sqlcode THEN
            CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)     # 資料被他人LOCK
            CLOSE p300_cl
            ROLLBACK WORK
            RETURN
         END IF
         IF g_rec_b >= l_ac THEN
            LET p_cmd='u'
            LET g_mmb_t.* = g_mmb[l_ac].*  #BACKUP
            OPEN p300_bcl USING g_mma.mma01,g_mmb_t.mmb02     #表示更改狀態
            IF STATUS THEN
               CALL cl_err("OPEN p300_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH p300_bcl INTO g_mmb[l_ac].*
               IF SQLCA.sqlcode THEN
                   CALL cl_err('lock mmb',SQLCA.sqlcode,1)
                   LET l_lock_sw = "Y"
               END IF
               CALL p300_mmb08()
            END IF
            CALL cl_show_fld_cont()     #FUN-550037(smin)
          END IF
          NEXT FIELD mmb16
 
      BEFORE FIELD mmb16
         IF NOT cl_null(g_mmb[l_ac].mmb02) THEN
            IF g_mmb_t.mmb14='Y' AND NOT cl_null(g_mmb[l_ac].mmb141) THEN
               CALL cl_err(g_mmb[l_ac].mmb14,'amm-009',0)
               NEXT FIELD mmbacti
            END IF
            SELECT * INTO l_mmb.* FROM mmb_file
             WHERE mmb01 = g_mma.mma01
               AND mmb02 = g_mmb[l_ac].mmb02
            IF cl_null(g_mmb[l_ac].mmb16) OR g_mmb[l_ac].mmb16 =0 THEN
               LET g_mmb[l_ac].mmb16 =l_mmb.mmb10
            END IF
            IF cl_null(g_mmb[l_ac].mmb17) OR g_mmb[l_ac].mmb17 =0 THEN
               LET g_mmb[l_ac].mmb17 =l_mmb.mmb11
            END IF
            IF cl_null(g_mmb[l_ac].mmb18) OR g_mmb[l_ac].mmb18 =0 THEN
               LET g_mmb[l_ac].mmb18 =l_mmb.mmb09
            END IF
            LET g_mmb[l_ac].mmb20 = g_today
            DISPLAY g_mmb[l_ac].mmb14, g_mmb[l_ac].mmb16,
                    g_mmb[l_ac].mmb17, g_mmb[l_ac].mmb18,g_mmb[l_ac].mmb20
                 TO mmb14, mmb16,
                    mmb17, mmb18,mmb20
         END IF
 
      AFTER FIELD mmb16
         IF NOT cl_null(g_mmb[l_ac].mmb16) THEN
            IF g_mmb[l_ac].mmb16 <0 THEN
               NEXT FIELD mmb16
            END IF
         END IF
 
#>>>  讀mmm08工時資料
      BEFORE FIELD mmb17
         SELECT mmm08 INTO g_mmb[l_ac].mmb17 FROM mmm_file
          WHERE mmm01=g_mma.mma01 AND mmm02=g_mmb[l_ac].mmb02
         DISPLAY BY NAME g_mmb[l_ac].mmb17
      AFTER FIELD mmb17
         IF g_mmb[l_ac].mmb17 <0 THEN
            NEXT FIELD mmb17
         END IF
 
      AFTER FIELD mmb18
         IF g_mmb[l_ac].mmb18 <0 THEN
            NEXT FIELD mmb18
         END IF
 
      BEFORE FIELD mmb14
        IF NOT cl_null(g_mmb[l_ac].mmb141) THEN
           CALL cl_err(g_mmb[l_ac].mmb14,'amm-013',0)
           NEXT FIELD mmbacti
        END IF
 
      AFTER FIELD mmb14
         IF NOT cl_null(g_mmb[l_ac].mmb14) THEN
#>> 自製轉出前需已打額外領料/工時維護
            LET g_cnt=0
            IF g_mmb[l_ac].mmb07='M' THEN
               SELECT count(*) INTO g_cnt FROM mmm_file
                WHERE mmm01=g_mma.mma01 AND mmm02=g_mmb[l_ac].mmb02
               IF g_cnt=0 THEN
                  CALL cl_err('','amm-108','1')
                  NEXT FIELD mmb16
               END IF
            END IF
         #若結轉項次非第一個加工項次,且第一加工項次尚未結轉,不允許結轉
            IF g_mma.mma18 !=g_mmb[l_ac].mmb02 AND g_mmb[l_ac].mmb14='Y' THEN
               SELECT mmb14 INTO l_mmb14 FROM mmb_file
                WHERE mmb01=g_mma.mma01 AND mmb02=g_mma.mma18 AND mmbacti='Y'
               IF l_mmb14 !='Y' THEN
                  CALL cl_err(g_mma.mma18,'amm-016',0)
                  LET g_mmb[l_ac].mmb14='N'
                  NEXT FIELD mmb14
               ELSE
               #若第一個加工項次已結轉,且但mmb02的前一項次尚未結轉,不允許結轉
                  SELECT MIN(mmb02) INTO g_cnt FROM mmb_file
                   WHERE mmb01  =g_mma.mma01 AND mmbacti='Y' AND mmb14='N'
                     AND mmb02 !=g_mma.mma18
                  IF g_cnt < g_mmb[l_ac].mmb02 THEN
                     CALL cl_err(g_mma.mma18,'amm-017',0)
                     LET g_mmb[l_ac].mmb14='N'
                     NEXT FIELD mmb14
                  END IF
               END IF
            END IF
        END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN                 #新增程式段
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_mmb[l_ac].* = g_mmb_t.*
            CLOSE p300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF g_mmb[l_ac].mmb02 > 0 THEN
            IF g_mmb[l_ac].mmb16<0 THEN
               CALL cl_err(g_mma.mma01,'aap-022',0)
               NEXT FIELD mmb16
            END IF
            IF g_mmb[l_ac].mmb17<0 THEN
               CALL cl_err(g_mma.mma01,'aap-022',0)
               NEXT FIELD mmb17
            END IF
            IF g_mmb[l_ac].mmb18<0 THEN
               CALL cl_err(g_mma.mma01,'aap-022',0)
               NEXT FIELD mmb18
            END IF
         END IF
 
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_mmb[l_ac].mmb02,-263,1)
            LET g_mmb[l_ac].* = g_mmb_t.*
         ELSE
            IF g_mmb[l_ac].mmb02 > 0 AND cl_null(g_mmb[l_ac].mmb141) THEN
               #update 單價,工時,數量
               LET g_no=NULL LET g_success='Y'
               UPDATE mmb_file SET
                      mmb16=g_mmb[l_ac].mmb16,
                      mmb17=g_mmb[l_ac].mmb17,
                      mmb18=g_mmb[l_ac].mmb18,
                      mmb20=g_mmb[l_ac].mmb20
                WHERE mmb01=g_mma.mma01 AND mmb02=g_mmb[l_ac].mmb02
               IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                   CALL cl_err3("upd","mmb_file",g_mma.mma01,g_mmb[l_ac].mmb02,SQLCA.SQLCODE,"","upd mmb",1)       #NO.FUN-660094
               END IF
               IF g_success='Y' THEN
                  CALL cl_cmmsg(3)
                  COMMIT WORK
               ELSE
                  CALL cl_rbmsg(3)
                  ROLLBACK WORK
                  LET g_mmb[l_ac].* = g_mmb_t.*
               END IF
             #若確定要結轉程序者
               IF g_mmb[l_ac].mmb14='Y' AND cl_null(g_mmb[l_ac].mmb141) AND
                  g_success='Y' THEN
                  IF cl_confirm('amm-015') THEN
                     CALL p300_mmb14()
                     IF cl_null(g_no) THEN
                        UPDATE mmb_file SET mmb141='', mmb14 = 'N'
                         WHERE mmb01=g_mma.mma01 AND mmb02=g_mmb[l_ac].mmb02
                     ELSE
                        UPDATE mmb_file SET mmb141=g_no, mmb14 = 'Y'
                         WHERE mmb01=g_mma.mma01 AND mmb02=g_mmb[l_ac].mmb02
                        UPDATE mmm_file SET mmm06 = 'Y'
                         WHERE mmm01=g_mma.mma01 AND mmm02=g_mmb[l_ac].mmb02
                     END IF
                  ELSE
                     NEXT FIELD mmb14
                  END IF
               ELSE
                  UPDATE mmb_file SET mmb141='', mmb14 = 'N'
                   WHERE mmb01=g_mma.mma01 AND mmb02=g_mmb[l_ac].mmb02
               END IF
               SELECT mmb141,mmb14 INTO g_mmb[l_ac].mmb141,g_mmb[l_ac].mmb14
                 FROM mmb_file
                WHERE mmb01=g_mma.mma01 AND mmb02=g_mmb[l_ac].mmb02
               LET g_rec_b=g_rec_b+1
               DISPLAY g_rec_b TO FORMONLY.cn2
               SELECT COUNT(*) INTO g_cnt FROM mmb_file
                WHERE mmb01 = g_mma.mma01
                  AND (mmbacti = 'X' OR mmb14 = 'Y')
               IF g_cnt > 0 THEN
                   IF cl_confirm('amm-106') THEN #BUG-490334 #No.MOD-4A0042
                     UPDATE mma_file SET mma04='Y'
                      WHERE mma01=g_mma.mma01
                  END IF
                   CALL p300_b_fill(' 1=1')                  #No.MOD-4A0042
               END IF
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
 
         IF INT_FLAG THEN                 #900423
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_mmb[l_ac].* = g_mmb_t.*
            END IF
            CLOSE p300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CLOSE p300_bcl
         COMMIT WORK
 
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
 
 
      ON ACTION controls                                                                                                             
         CALL cl_set_head_visible("","AUTO")                                                                                        
 
   END INPUT
END FUNCTION
 
FUNCTION p300_upd_mmg()
   UPDATE mmg_file SET
          mmg17=(SELECT COUNT(*) FROM mma_file,mmb_file
                  WHERE mma01=g_mma.mma01 AND mma01=mmb01
                    AND mmaacti='Y' AND mmbacti='Y' AND mmb14='Y') /
                (SELECT COUNT(*) FROM mma_file,mmb_file
                  WHERE mma01=g_mma.mma01 AND mma01=mmb01
                    AND mmaacti='Y' AND mmbacti='Y' ) *100,
          mmg18=mmg18+g_mmb[l_ac].mmb16*g_mmb[l_ac].mmb18,
          mmg19=mmg19+g_mmb[l_ac].mmb17*g_mmb[l_ac].mmb18,
  mmg191=mmg191+(g_mmb[l_ac].mmb17*g_mmb[l_ac].mmb18*g_mmb[l_ac].mmb19)/60
    WHERE mmg01=g_mma.mma02 AND mmg02=g_mma.mma021
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("upd","mmg_file",g_mma.mma02,g_mma.mma021,SQLCA.SQLCODE,"","up mmg:",1)       #NO.FUN-660094
     LET g_success='N'
  END IF
 
END FUNCTION
 
FUNCTION p300_mmb14()
 
  IF g_mmb[l_ac].mmb07='M' THEN CALL p300_mmb14_M() END IF
  IF g_mmb[l_ac].mmb07='P' THEN CALL p300_mmb14_P() END IF
  IF g_mmb[l_ac].mmb07='S' THEN CALL p300_mmb14_S() END IF
 
END FUNCTION
 
FUNCTION p300_mmb14_M()
DEFINE l_sfb87     LIKE sfb_file.sfb87
DEFINE l_inapost   LIKE ina_file.inapost
DEFINE l_sfp04     LIKE sfp_file.sfp04
DEFINE l_sfupost   LIKE sfu_file.sfupost
 
    LET g_success='Y'
    LET g_no = ''
--- Step 1:結轉工單
       IF g_mmd.mmd01 = 'N' THEN LET g_success = 'N' RETURN END IF
       LET g_sfb01 = NULL
       BEGIN WORK
       CALL p300_ins_sfab('M')
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "asfi301 '",g_sfb01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT sfb87 INTO l_sfb87 FROM sfb_file
           WHERE sfb01 = g_sfb01
          IF STATUS THEN
              CALL cl_err3("sel","sfb_file",g_sfb01,"","amm-030","","",1)       #NO.FUN-660094
             RETURN
          ELSE
             IF l_sfb87 !='Y' THEN
                CALL cl_err(g_sfb01,'amm-030',1)
                RETURN
             ELSE
                LET g_no = g_sfb01
                CALL cl_err(g_sfb01,'amm-031',1)
             END IF
          END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_sfb01,'amm-030',1)
          RETURN
       END IF
 
--- Step 2:結轉雜收單
    SELECT * INTO g_sfb.*  FROM sfb_file WHERE sfb01 = g_sfb01
    IF g_sfb.sfb87='Y' AND g_mmd.mmd02='Y' THEN
       LET g_success='Y'
       LET g_ina01 = NULL
       BEGIN WORK
       CALL p300_ins_inab()
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "aimt302 '",g_ina01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT inapost INTO l_inapost FROM ina_file
           WHERE ina01 = g_ina01
           IF STATUS THEN
               CALL cl_err3("sel","ina_file",g_ina01,"","amm-041","","",1)       #NO.FUN-660094
           ELSE
             IF l_inapost !='Y' THEN
                CALL cl_err(g_ina01,'amm-041',1)
             ELSE
                CALL cl_err(g_ina01,'amm-032',1)
             END IF
          END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_ina01,'amm-041',1)
       END IF
    ELSE
       CALL cl_err(g_sfb01,'amm-041',1)
    END IF
 
--- Step 3:結轉領料單
    IF g_sfb.sfb87='Y' AND g_mmd.mmd03='Y' THEN
       LET g_success='Y'
       LET g_sfp01 = NULL
       BEGIN WORK
       CALL p300_ins_sfpq('M')
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "asfi511 '",g_sfp01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT sfp04 INTO l_sfp04 FROM sfp_file
           WHERE sfp01 = g_sfp01
          IF STATUS THEN
              CALL cl_err3("sel","sfp_file",g_sfp01,"","amm-030","","",1)       #NO.FUN-660094
             RETURN
          ELSE
             IF l_sfp04 !='Y' THEN
                CALL cl_err(g_sfp01,'amm-030',1)
                RETURN
             ELSE
                CALL cl_err(g_sfp01,'amm-033',1)
             END IF
          END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_sfp01,'amm-030',1)
          RETURN
       END IF
    ELSE
       CALL cl_err(g_ina01,'amm-030',1)
       RETURN
    END IF
 
--- Step 4:結轉入庫單
    SELECT * INTO g_sfp.* FROM sfp_file WHERE sfp01 = g_sfp01
    IF g_sfp.sfp04='Y' AND g_mmd.mmd04='Y' THEN
       LET g_success='Y'
       LET g_sfu01 = NULL
       BEGIN WORK
       CALL p300_ins_sfuv()
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "asft620 '",g_sfu01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT sfupost INTO l_sfupost FROM sfu_file
           WHERE sfu01 = g_sfu01
          IF STATUS THEN
              CALL cl_err3("sel","sfu_file",g_sfu01,"","amm-030","","",1)       #NO.FUN-660094
             RETURN
          ELSE
             IF l_sfupost !='Y' THEN
                CALL cl_err(g_sfu01,'amm-030',1)
                RETURN
             ELSE
                CALL cl_err(g_sfu01,'amm-034',1)
             END IF
          END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_sfu01,'amm-030',1)
          RETURN
       END IF
    ELSE
       CALL cl_err(g_sfp01,'amm-030',1)
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION p300_mmb14_P()
DEFINE l_pmk18       LIKE pmk_file.pmk18
DEFINE l_pmm25       LIKE pmm_file.pmm25
DEFINE l_rvaconf     LIKE rva_file.rvaconf
DEFINE l_rvuconf     LIKE rvu_file.rvuconf
 
 
    LET g_success='Y'
    LET g_no = ''
--- Step 1:結轉請購單
    IF g_mmd.mmd05 = 'N' THEN LET g_success = 'N' RETURN END IF
    LET g_pmk01 = NULL
    BEGIN WORK
    CALL p300_ins_pmkl()
    IF g_success='Y' THEN
       COMMIT WORK
       LET l_cmd = "apmt420 '",g_pmk01,"' "
      #DISPLAY g_pmk01   #CHI-A70049 mark
       CALL cl_cmdrun_wait(l_cmd CLIPPED)
       SELECT pmk18 INTO l_pmk18 FROM pmk_file
        WHERE pmk01 = g_pmk01
       IF STATUS THEN
           CALL cl_err3("sel","pmk_file",g_pmk01,"","amm-024","","",1)       #NO.FUN-660094
          RETURN
       ELSE
          IF l_pmk18 !='Y' THEN
             CALL cl_err(g_pmk01,'amm-024',1)
             RETURN
          ELSE
             LET g_no = g_pmk01
             CALL cl_err(g_pmk01,'amm-025',1)
          END IF
       END IF
    ELSE
       ROLLBACK WORK
       CALL cl_err(g_pmk01,'amm-024',1)
       RETURN
    END IF
 
--- Step 2:結轉採購單
    SELECT * INTO g_pmk.*  FROM pmk_file WHERE pmk01 = g_pmk01
    IF g_pmk.pmk25='1' AND g_pmk.pmk18='Y' AND g_mmd.mmd06='Y' THEN
       LET g_success='Y'
       LET g_pmm01 = NULL
       BEGIN WORK
       CALL p300_ins_pmmn()
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "apmt540 '",g_pmm01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT pmm25 INTO l_pmm25 FROM pmm_file
           WHERE pmm01=g_pmm01 AND pmm18 !='X'
          IF STATUS THEN
              CALL cl_err3("sel","pmm_file",g_pmm01,"","amm-024","","",1)       #NO.FUN-660094
             RETURN
          ELSE
             IF l_pmm25 !='2' THEN
                CALL cl_err(g_pmm01,'amm-024',1)
                RETURN
             ELSE
                CALL cl_err(g_pmm01,'amm-026',1)
             END IF
          END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_pmm01,'amm-024',1)
          RETURN
       END IF
    ELSE
       CALL cl_err(g_pmk01,'amm-024',1)
       RETURN
    END IF
 
--- Step 3:結轉收貨單+結轉驗收單
    SELECT * INTO g_pmm.*  FROM pmm_file WHERE pmm01 = g_pmm01
    IF g_pmm.pmm25='2' AND g_pmm.pmm18='Y' AND g_mmd.mmd07='Y' THEN
       LET g_success='Y'
       LET g_rva01 = NULL
       BEGIN WORK
       CALL p300_ins_rvab('P')
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "apmt110 '",g_rva01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT rvaconf INTO l_rvaconf FROM rva_file
           WHERE rva01 = g_rva01
          IF STATUS THEN
              CALL cl_err3("sel","rva_file",g_rva01,"","amm-024","","",1)       #NO.FUN-660094
             RETURN
          ELSE
             IF l_rvaconf !='Y' THEN
                CALL cl_err(g_rva01,'amm-024',1)
                RETURN
             ELSE
               SELECT rvu01,rvuconf INTO g_rvu01,l_rvuconf FROM rvu_file
                WHERE rvu02 = g_rva01
               IF STATUS OR l_rvuconf != 'Y' THEN
                   CALL cl_err3("sel","rvu",g_rvu01,"","amm-024","","",1)       #NO.FUN-660094
                  RETURN
               ELSE
                  CALL cl_err(g_rva01,'amm-027',1)
               END IF
             END IF
          END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_rva01,'amm-024',1)
          RETURN
       END IF
    ELSE
       CALL cl_err(g_pmm01,'amm-024',1)
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION p300_mmb14_S()
DEFINE l_sfb87     LIKE sfb_file.sfb87
DEFINE l_pmm18     LIKE pmm_file.pmm18
DEFINE l_pmm25     LIKE pmm_file.pmm25
DEFINE l_pmm43     LIKE pmm_file.pmm43
DEFINE l_rvaconf   LIKE rva_file.rvaconf
DEFINE l_rvuconf   LIKE rvu_file.rvuconf
DEFINE l_sfp04     LIKE sfp_file.sfp04
 
    LET g_success='Y'
    LET g_no = ''
--- Step 1:結轉委外工單+委外採購
       IF g_mmd.mmd09 = 'N' THEN LET g_success = 'N' RETURN END IF
       LET g_sfb01 = NULL
       BEGIN WORK
       CALL p300_ins_sfab('S')
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "asfi301 '",g_sfb01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT sfb87 INTO l_sfb87 FROM sfb_file
           WHERE sfb01 = g_sfb01
           IF STATUS THEN
               CALL cl_err3("sel","sfb_file",g_sfb01,"","amm-035","","",1)       #NO.FUN-660094
              RETURN
           ELSE
              IF l_sfb87 !='Y' THEN
                 CALL cl_err(g_sfb01,'amm-035',1)
                 RETURN
              ELSE
                 LET g_no = g_sfb01
                 SELECT pmm01,pmm18,pmm25,pmm43
                   INTO g_pmm01,l_pmm18,l_pmm25,l_pmm43 FROM pmm_file
                  WHERE pmm01 = g_sfb01
                 IF STATUS OR l_pmm18 !='Y' OR l_pmm25 !='2' THEN
                     CALL cl_err3("sel","pmm_file",g_sfb01,"","amm-035","","",1)       #NO.FUN-660094
                    RETURN
                 ELSE
                    UPDATE pmn_file SET pmn31 = g_mmb[l_ac].mmb16,
                           pmn31t = g_mmb[l_ac].mmb16*(1.0+l_pmm43/100.0)
                     WHERE pmn01 = g_sfb01
                       AND pmn02 = 1
                    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
                        CALL cl_err3("upd","pmn_file",g_sfb01,"",SQLCA.SQLCODE,"","upd pmn",1)       #NO.FUN-660094
                        CALL cl_err3("upd","pmn_file",g_sfb01,"","amm-035","","",1)       #NO.FUN-660094
                       RETURN
                    ELSE
                        #UPDATE pmn31後,須重新計算pmm40
                       CALL p300_update_pmm40() RETURNING g_i
                       IF g_i THEN
                           RETURN
                       END IF
                       CALL cl_err(g_sfb01,'amm-036',1)
                    END IF
                 END IF
              END IF
           END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_sfb01,'amm-035',1)
          RETURN
       END IF
 
--- Step 2:結轉領料單
    SELECT * INTO g_pmm.* FROM pmm_file WHERE pmm01 = g_pmm01
    IF g_pmm.pmm18 !='Y' OR g_pmm.pmm25 !='2' OR g_mmd.mmd12='Y' THEN
       LET g_success='Y'
       LET g_sfp01 = NULL
       BEGIN WORK
       CALL p300_ins_sfpq('S')
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "asfi511 '",g_sfp01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT sfp04 INTO l_sfp04 FROM sfp_file
           WHERE sfp01 = g_sfp01
          IF STATUS THEN
              CALL cl_err3("sel","sfp_file",g_sfp01,"","amm-035","","",1)       #NO.FUN-660094
             RETURN
          ELSE
             IF l_sfp04 !='Y' THEN
                CALL cl_err(g_sfp01,'amm-035',1)
                RETURN
             ELSE
                CALL cl_err(g_sfp01,'amm-037',1)
             END IF
          END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_sfp01,'amm-035',1)
          RETURN
       END IF
    ELSE
       CALL cl_err(g_sfb01,'amm-035',1)
       RETURN
    END IF
 
--- Step 3:結轉收貨單+入庫單
    SELECT * INTO g_sfp.*  FROM sfp_file WHERE sfp01 = g_sfp01
    IF g_sfp.sfp04='Y' AND g_mmd.mmd13='Y' THEN
       LET g_success='Y'
       LET g_rva01 = NULL
       BEGIN WORK
       CALL p300_ins_rvab('S')
       IF g_success='Y' THEN
          COMMIT WORK
          LET l_cmd = "apmt200 '",g_rva01,"' "
          CALL cl_cmdrun_wait(l_cmd CLIPPED)
          SELECT rvaconf INTO l_rvaconf FROM rva_file
           WHERE rva01 = g_rva01
          IF STATUS THEN
              CALL cl_err3("sel","rva_file",g_rva01,"","amm-035","","",1)       #NO.FUN-660094
             RETURN
          ELSE
             IF l_rvaconf !='Y' THEN
                CALL cl_err(g_rva01,'amm-035',1)
                RETURN
             ELSE
               SELECT rvu01,rvuconf INTO g_rvu01,l_rvuconf FROM rvu_file
                WHERE rvu02 = g_rva01
               IF STATUS OR l_rvuconf != 'Y' THEN
                   CALL cl_err3("sel","rvu_file",g_rvu01,"","amm-035","","",1)       #NO.FUN-660094
                  RETURN
               ELSE
                  CALL cl_err(g_rva01,'amm-038',1)
               END IF
             END IF
          END IF
       ELSE
          ROLLBACK WORK
          CALL cl_err(g_rva01,'amm-035',1)
          RETURN
       END IF
    ELSE
       CALL cl_err(g_sfp01,'amm-035',1)
       RETURN
    END IF
 
END FUNCTION
 
FUNCTION p300_ins_sfab(p_cmd)  #M,S
  DEFINE p_cmd     LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
  DEFINE l_sfb     RECORD LIKE sfb_file.*
  DEFINE li_result LIKE type_file.num5          #No.FUN-680100 SMALLINT
  DEFINE l_smykind LIKE smy_file.smykind
  DEFINE l_sfbi    RECORD LIKE sfbi_file.*      #No.FUN-7B0018
  DEFINE l_smy57   LIKE smy_file.smy57          #MOD-B10008 add
  DEFINE l_smy57_2 STRING                       #MOD-B10008 add
 
  INITIALIZE l_sfb.* TO NULL
  IF p_cmd = 'S' THEN
     IF cl_null(g_mmd.mmd09) THEN
        LET g_success='N'
        CALL cl_err(g_mmd.mmd09,'amm-019',1)
        RETURN
     END IF
     IF cl_null(g_mmd.mmd091) THEN
        LET g_success='N'
        CALL cl_err(g_mmd.mmd091,'amm-019',1)
        RETURN
     END IF
     LET l_sfb.sfb01=g_mmd.mmd091
  ELSE
     IF cl_null(g_mmd.mmd01) THEN
        LET g_success='N'
        CALL cl_err(g_mmd.mmd01,'amm-019',1)
        RETURN
     END IF
     IF cl_null(g_mmd.mmd011) THEN
        LET g_success='N'
        CALL cl_err(g_mmd.mmd011,'amm-019',1)
        RETURN
     END IF
     LET l_sfb.sfb01=g_mmd.mmd011
  END IF
 
  IF g_smy.smyauno !='Y' THEN
     LET g_success='N'
     CALL cl_err(l_sfb.sfb01,'amm-018',1)
     RETURN
  END IF
 
   SELECT smykind,smy57 INTO l_smykind,l_smy57 FROM smy_file      #MOD-B10008 add smy57,l_smy57
    WHERE smyslip = l_sfb.sfb01
   CALL s_auto_assign_no("asf",l_sfb.sfb01,g_today,l_smykind,"","","","","")
   RETURNING li_result,l_sfb.sfb01
   IF (NOT li_result) THEN
       RETURN
   END IF
  LET g_sfb01 = l_sfb.sfb01
  IF g_mmb[l_ac].mmb07='M' THEN
     LET l_sfb.sfb02 =5
  ELSE  #S
    #LET l_sfb.sfb02 =7               #MOD-B10007 mark       
     LET l_sfb.sfb02 =8               #MOD-B10007 add 
  END IF
   LET l_sfb.sfb04 = '1' #No.MOD-460966
  LET l_sfb.sfb05 =g_mma.mma05
  LET l_sfb.sfb071=g_today
  LET l_sfb.sfb08 =g_mmb[l_ac].mmb18
  LET l_sfb.sfb081=0
  LET l_sfb.sfb09 =0
  LET l_sfb.sfb10 =0
  LET l_sfb.sfb11 =0
  LET l_sfb.sfb111=0
  LET l_sfb.sfb12 =0
  LET l_sfb.sfb121=0
  LET l_sfb.sfb122=NULL
  LET l_sfb.sfb13 =g_today
  LET l_sfb.sfb14 =NULL
  LET l_sfb.sfb15 =g_today
  LET l_sfb.sfb23 ='Y'
  LET l_sfb.sfb24 ='N'
  LET l_sfb.sfb251=g_today
  LET l_sfb.sfb29 ='Y'
  LET l_sfb.sfb30 =g_mma.mma21
  LET l_sfb.sfb31 =g_mma.mma211
  LET l_sfb.sfb39 ='1'
  LET l_sfb.sfb41 ='N'
  LET l_sfb.sfb81 =g_today
  LET l_sfb.sfb82 =g_mmb[l_ac].mmb08
  LET l_sfb.sfb87 ='N'
  LET l_sfb.sfb98 =s_costcenter(g_grup) #FUN-680006
  LET l_sfb.sfb99 ='N'
  SELECT ima910 INTO l_sfb.sfb95
    FROM ima_file
   WHERE ima01 = l_sfb.sfb05
  IF cl_null(l_sfb.sfb95) THEN
     LET l_sfb.sfb95 = ' '
  END IF
  LET l_sfb.sfb86 = g_mma.mma02      #CHI-B10001 add
  LET l_sfb.sfb96 = g_mma.mma01,",",g_mmb[l_ac].mmb02      #CHI-B10001 add
  LET l_sfb.sfbacti='Y'
  LET l_sfb.sfbuser=g_user
  LET l_sfb.sfbgrup=g_grup
  LET l_sfb.sfbmodu=NULL
  LET l_sfb.sfbdate=g_today
  LET l_sfb.sfb1002='N' #保稅核銷否 #FUN-6B0044
  LET l_sfb.sfbplant = g_plant #FUN-980004 add
  LET l_sfb.sfblegal = g_legal #FUN-980004 add
  LET l_sfb.sfboriu = g_user      #No.FUN-980030 10/01/04
  LET l_sfb.sfborig = g_grup      #No.FUN-980030 10/01/04
  LET l_sfb.sfb104 = 'N'          #NO.TQC-A50087 add
 #MOD-B10008---add---start---
  LET l_sfb.sfb44 = g_user         
  LET l_sfb.sfb93 = 'N'            
  LET l_smy57_2=l_smy57
  LET l_smy57_2 = l_smy57_2.subString(2,2)
  LET l_sfb.sfb94 = l_smy57_2 
 #MOD-B10008---add---end---
  INSERT INTO sfb_file VALUES(l_sfb.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     CALL cl_err3("ins","sfb_file","l_sfb.sfb01","",SQLCA.SQLCODE,"","ins sfb",1)       #NO.FUN-660094
     LET g_success='N'
     RETURN
  END IF
  IF NOT s_industry('std') THEN
     INITIALIZE l_sfbi.* TO NULL
     LET l_sfbi.sfbi01 = l_sfb.sfb01
     IF NOT s_ins_sfbi(l_sfbi.*,'') THEN
        LET g_success = 'N'
        RETURN
     END IF
  END IF
  #委外+重工
  CALL p300_ins_sfa(l_sfb.sfb02,l_sfb.sfb05,l_sfb.sfb08,g_mma.mma21,
                    g_mma.mma211)
       RETURNING g_cnt
  IF g_cnt = 0 THEN
     CALL cl_err('ins sfa',SQLCA.SQLCODE,1)
     LET g_success='N'
     RETURN
  END IF
  FOREACH mml_cur USING g_mma.mma01,g_mmb[l_ac].mmb02 INTO g_mml.*
     CALL p300_ins_sfa(l_sfb.sfb02,g_mml.mml04,g_mml.mml05,
                      g_mml.mml07,g_mml.mml08)
       RETURNING g_cnt
     IF g_cnt = 0 THEN
        CALL cl_err('ins sfa',SQLCA.SQLCODE,1)
        LET g_success='N'
        RETURN
     END IF
  END FOREACH
 
END FUNCTION
 
FUNCTION p300_ins_sfa(p_wotype,p_part,p_woq,p_sfa30,p_sfa31)
DEFINE
    p_wotype   LIKE type_file.num5,        #No.FUN-680100 SMALLINT
     p_part    LIKE ima_file.ima01,        #NO.MOD-490217
    p_woq      LIKE bnj_file.bnj02,        #No.FUN-680100 DECIMAL(11,3)#數量
    p_sfa30    LIKE sfa_file.sfa30,
    p_sfa31    LIKE sfa_file.sfa31,
    l_sfa      RECORD LIKE sfa_file.*,
    l_ima      RECORD LIKE ima_file.*
DEFINE l_sfai  RECORD LIKE sfai_file.*     #No.FUN-7B0018
 
    SELECT * INTO l_ima.* FROM ima_file
     WHERE ima01 = p_part AND imaacti='Y'
 
    IF SQLCA.sqlcode THEN RETURN 0 END IF
    INITIALIZE l_sfa.* TO NULL
    LET p_woq        = s_digqty(p_woq,l_ima.ima55)     #FUN-BB0085
    LET l_sfa.sfa01  = g_sfb01
    LET l_sfa.sfa02  = p_wotype
    LET l_sfa.sfa03  = p_part
    LET l_sfa.sfa04  = p_woq
    LET l_sfa.sfa05  = p_woq
    LET l_sfa.sfa06  = 0
    LET l_sfa.sfa061 = 0
    LET l_sfa.sfa062 = 0
    LET l_sfa.sfa063 = 0
    LET l_sfa.sfa064 = 0
    LET l_sfa.sfa065 = 0
    LET l_sfa.sfa066 = 0
    LET l_sfa.sfa08  = ' '
    LET l_sfa.sfa09  = 0
    LET l_sfa.sfa11  = 'N'
    LET l_sfa.sfa12  = l_ima.ima55
    LET l_sfa.sfa13  = l_ima.ima55_fac
    LET l_sfa.sfa14  = l_ima.ima86
    LET l_sfa.sfa15  = l_ima.ima86_fac
    LET l_sfa.sfa16  = p_woq / g_mmb[l_ac].mmb18
    LET l_sfa.sfa161 = l_sfa.sfa16
    LET l_sfa.sfa25  = p_woq
    LET l_sfa.sfa26  = '0'
    LET l_sfa.sfa27  = p_part
    LET l_sfa.sfa28  = 1
    LET l_sfa.sfa29  = p_part
    LET l_sfa.sfa30  = p_sfa30
    LET l_sfa.sfa31  = p_sfa31
    LET l_sfa.sfa100 = 0
    LET l_sfa.sfaacti ='Y'
    LET l_sfa.sfaplant = g_plant #FUN-980004 add
    LET l_sfa.sfalegal = g_legal #FUN-980004 add
    LET l_sfa.sfa012 = ' '  #FUN-A60027
    LET l_sfa.sfa013 = 0    #FUN-A60027 
    INSERT INTO sfa_file VALUES(l_sfa.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
       CALL cl_err3("ins","sfa_file",l_sfa.sfa01,l_sfa.sfa03,SQLCA.SQLCODE,"","ins sfa",1)       #NO.FUN-660094
       RETURN 0
    ELSE
       IF NOT s_industry('std') THEN
          INITIALIZE l_sfai.* TO NULL
          LET l_sfai.sfai01 = l_sfa.sfa01
          LET l_sfai.sfai03 = l_sfa.sfa03
          LET l_sfai.sfai08 = l_sfa.sfa08
          LET l_sfai.sfai12 = l_sfa.sfa12
          LET l_sfai.sfai012 = l_sfa.sfa012        #FUN-A60027
          LET l_sfai.sfai013 = l_sfa.sfa013        #FUN-A60027
          IF NOT s_ins_sfai(l_sfai.*,'') THEN
             RETURN 0
          END IF
       END IF
    END IF
    RETURN 1
 
END FUNCTION
 
 
FUNCTION p300_ins_inab()
DEFINE l_ina   RECORD LIKE ina_file.*
DEFINE l_inb   RECORD LIKE inb_file.*
DEFINE g_img09 LIKE img_file.img09
DEFINE l_smykind LIKE smy_file.smykind
DEFINE li_result LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE l_inbi       RECORD LIKE inbi_file.*   #FUN-B70074 add 
DEFINE l_ina04   LIKE ina_file.ina04          #FUN-CB0087 xj
DEFINE l_ina10   LIKE ina_file.ina10          #FUN-CB0087 xj
DEFINE l_ina11   LIKE ina_file.ina11          #FUN-CB0087 xj

  INITIALIZE l_ina.* TO NULL
  IF cl_null(g_mmd.mmd02) THEN
     LET g_success='N'
     CALL cl_err(g_mmd.mmd01,'amm-019',1)
     RETURN
  END IF
  IF cl_null(g_mmd.mmd021) THEN
     LET g_success='N'
     CALL cl_err(g_mmd.mmd01,'amm-019',1)
     RETURN
  END IF
  LET l_ina.ina01=g_mmd.mmd021
  IF g_smy.smyauno !='Y' THEN
     LET g_success='N'
     CALL cl_err(l_ina.ina01,'amm-018',1)
     RETURN
  END IF
   SELECT smykind INTO l_smykind FROM smy_file
    WHERE smyslip = l_ina.ina01
   CALL s_auto_assign_no("aim",l_ina.ina01,g_today,l_smykind,"","","","","")
   RETURNING li_result,l_ina.ina01
   IF (NOT li_result) THEN
       RETURN
   END IF
  LET g_ina01 = l_ina.ina01
  LET l_ina.ina00='3'
  LET l_ina.ina02=g_today
  LET l_ina.ina03=g_today
  LET l_ina.ina04 =g_mma.mma15
  LET l_ina.inapost="N"
  LET l_ina.inaconf="N" #FUN-660079
  LET l_ina.inauser=g_user
  LET l_ina.inagrup=g_grup
  LET l_ina.inadate=g_today
  LET l_ina.ina12 = 'N'       #NO.FUN-960130   #NO.FUN-9B0016
  LET l_ina.inapos = 'N'       #NO.FUN-960130
  LET l_ina.inaplant = g_plant #FUN-980004 add
  LET l_ina.inalegal = g_legal #FUN-980004 add
  LET l_ina.inaoriu = g_user      #No.FUN-980030 10/01/04
  LET l_ina.inaorig = g_grup      #No.FUN-980030 10/01/04
  INSERT INTO ina_file VALUES(l_ina.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","ina_file",l_ina.ina01,"",SQLCA.SQLCODE,"","ins ina",1)       #NO.FUN-660094
     LET g_success='N'
     RETURN
  END IF
  LET l_inb.inb01 = g_ina01
  LET l_inb.inb03 = 1
  LET l_inb.inb04 = g_mma.mma05
  LET l_inb.inb05 = g_mma.mma21
  LET l_inb.inb06 = g_mma.mma211
  LET l_inb.inb07 = ' '
  LET l_inb.inb08 = g_mma.mma10
  SELECT img09 INTO g_img09 FROM img_file
   WHERE img01 = l_inb.inb04 AND img02=l_inb.inb05
     AND img03 = l_inb.inb06 AND img04=l_inb.inb07
  IF l_inb.inb08=g_img09 THEN
     LET l_inb.inb08_fac =  1
  ELSE
     CALL s_umfchk(l_inb.inb04,l_inb.inb08,g_img09)
            RETURNING g_cnt,l_inb.inb08_fac
     IF g_cnt = 1 THEN
        LET l_inb.inb08_fac =  1
     END IF
  END IF
  LET l_inb.inb09 = g_mmb[l_ac].mmb18
  LET l_inb.inb09 = s_digqty(l_inb.inb09,l_inb.inb08)    #FUN-BB0085
  LET l_inb.inb11 = g_sfb01
  LET l_inb.inb15 = g_mmd.mmd022
  LET l_inb.inb930=s_costcenter(l_inb.inb04)  #FUN-680006
  LET l_inb.inb16 = g_mmb[l_ac].mmb18 #No.FUN-870163
  LET l_inb.inb16 = s_digqty(l_inb.inb16,l_inb.inb08)    #FUN-BB0085
  LET l_inb.inbplant = g_plant #FUN-980004 add
  LET l_inb.inblegal = g_legal #FUN-980004 add
  #FUN-CB0087--xj-add---str---
  IF g_aza.aza115 = 'Y' THEN
     SELECT ina10,ina11 INTO l_ina10,l_ina11 FROM ina_file WHERE ina01 = l_inb.inb01 
     CALL s_reason_code(l_inb.inb01,l_ina10,'',l_inb.inb04,l_inb.inb05,l_ina.ina04,l_ina11) RETURNING l_inb.inb15
     IF cl_null(l_inb.inb15) THEN
        CALL cl_err('','aim-425',1)
        LET g_success='N'
        RETURN 
     END IF
  END IF
  #FUN-CB0087--xj-add---end--
  INSERT INTO inb_file VALUES(l_inb.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
     CALL cl_err('ins inb',SQLCA.SQLCODE,1)
     LET g_success='N'
     RETURN
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_inbi.* TO NULL
         LET l_inbi.inbi01 = l_inb.inb01
         LET l_inbi.inbi03 = l_inb.inb03
         IF NOT s_ins_inbi(l_inbi.*,l_inb.inbplant ) THEN
            LET g_success='N'
            RETURN
         END IF
      END IF
#FUN-B70074--add--insert--
  END IF
 
END FUNCTION
 
FUNCTION p300_ins_sfpq(p_cmd)   #M,S
DEFINE  l_sfp        RECORD LIKE sfp_file.*
DEFINE  l_sfq        RECORD LIKE sfq_file.*
DEFINE  l_sfs        RECORD LIKE sfs_file.*
DEFINE  g_sfs04      LIKE sfs_file.sfs04
DEFINE  l_sql        STRING        #No.FUN-680100
DEFINE  p_cmd        LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
DEFINE  l_smykind    LIKE smy_file.smykind
DEFINE  l_smyapr     LIKE smy_file.smyapr         #CHI-B80004 add
DEFINE  li_result    LIKE type_file.num5          #No.FUN-680100 SMALLINT
 
  INITIALIZE l_sfp.* TO NULL
  INITIALIZE l_sfq.* TO NULL
  IF p_cmd = 'S' THEN
     IF cl_null(g_mmd.mmd12) THEN
        LET g_success='N'
        CALL cl_err(g_mmd.mmd12,'amm-019',1)
        RETURN
     END IF
     IF cl_null(g_mmd.mmd121) THEN
        LET g_success='N'
        CALL cl_err(g_mmd.mmd121,'amm-019',1)
        RETURN
     END IF
     LET l_sfp.sfp01=g_mmd.mmd121
  ELSE
     IF cl_null(g_mmd.mmd03) THEN
        LET g_success='N'
        CALL cl_err(g_mmd.mmd03,'amm-019',1)
        RETURN
     END IF
     IF cl_null(g_mmd.mmd031) THEN
        LET g_success='N'
        CALL cl_err(g_mmd.mmd031,'amm-019',1)
        RETURN
     END IF
     LET l_sfp.sfp01=g_mmd.mmd031
  END IF
  IF g_smy.smyauno !='Y' THEN
     LET g_success='N'
     CALL cl_err(l_sfp.sfp01,'amm-018',1)
     RETURN
  END IF
   #SELECT smykind INTO l_smykind FROM smy_file                      #CHI-B80004 mark
   SELECT smykind,smyapr INTO l_smykind,l_smyapr FROM smy_file       #CHI-B80004 add
    WHERE smyslip = l_sfp.sfp01
   CALL s_auto_assign_no("asf",l_sfp.sfp01,g_today,l_smykind,"","","","","")
   RETURNING li_result,l_sfp.sfp01
   IF (NOT li_result) THEN
       RETURN
   END IF
  LET g_sfp01 = l_sfp.sfp01
  LET l_sfp.sfp02 = g_today
  LET l_sfp.sfp03 = l_sfp.sfp02
  LET l_sfp.sfp04 ='N'
  LET l_sfp.sfpconf ='N' #FUN-660106
  LET l_sfp.sfp05 ='N'
  LET l_sfp.sfp06 ='1'
  LET l_sfp.sfp07 = g_mma.mma15
  LET l_sfp.sfpplant = g_plant       #FUN-980004 add
  LET l_sfp.sfplegal = g_legal       #FUN-980004 add
  LET l_sfp.sfporiu = g_user         #No.FUN-980030 10/01/04
  LET l_sfp.sfporig = g_grup         #No.FUN-980030 10/01/04
  #FUN-AB0001--add---str---
  #LET l_sfp.sfpmksg = g_smy.smyapr   #是否簽核            #CHI-B80004 mark
  LET l_sfp.sfpmksg = l_smyapr       #是否簽核             #CHI-B80004 add
  LET l_sfp.sfp15 = '0'              #簽核狀況
  LET l_sfp.sfp16 = g_user           #申請人
  #FUN-AB0001--add---end---
  LET l_sfp.sfpuser = g_user         #MOD-A10152
  LET l_sfp.sfpgrup = g_grup         #MOD-A10152
  LET l_sfp.sfpdate = g_today        #MOD-A10152
  INSERT INTO sfp_file VALUES(l_sfp.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","sfp_file",l_sfp.sfp01,"",SQLCA.SQLCODE,"","ins sfp",1)       #NO.FUN-660094
     LET g_success='N'
     RETURN
  END IF
  LET l_sfq.sfq01 =l_sfp.sfp01
  LET l_sfq.sfq02 =g_sfb01
  LET l_sfq.sfq03 =g_mmb[l_ac].mmb18
  LET l_sfq.sfqplant = g_plant #FUN-980004 add
  LET l_sfq.sfqlegal = g_legal #FUN-980004 add
  LET l_sfq.sfq04 =' '   #MOD-A10057
  LET l_sfq.sfq05 =g_today   #MOD-A10057
  LET l_sfq.sfq012 = ' '     #FUN-B20095  
  LET l_sfq.sfq014 = ' '     #FUN-C70014
  INSERT INTO sfq_file VALUES(l_sfq.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","sfq_file",l_sfq.sfq01,l_sfq.sfq02,SQLCA.SQLCODE,"","ins sfq",1)       #NO.FUN-660094
     LET g_success='N'
     RETURN
  END IF
 
  LET l_sql = "SELECT sfa03 FROM sfa_file",
              " WHERE sfa01='",g_sfb01,"'",
              "   AND sfa05>sfa06",
              "   AND (sfa11<>'E' OR sfa11 IS NULL)",
              "   AND (sfa05-sfa065)>0"    #應發-委外代買量>0
  LET l_sql = l_sql CLIPPED," ORDER BY sfa27,sfa03"
 
  PREPARE p300_sfa_pre FROM l_sql
  DECLARE p300_sfa_cs CURSOR FOR p300_sfa_pre
 
  LET g_con = 0
  FOREACH p300_sfa_cs INTO g_sfs04
     LET g_con = g_con + 1
     SELECT mml09 INTO g_mml.mml09 FROM mml_file
      WHERE mml01= g_mma.mma01 AND  mml04 = g_sfs04
     CALL p300_ins_sfs(g_con,g_sfs04,g_mml.mml09) RETURNING g_cnt
     IF g_cnt = 0 THEN
         CALL cl_err3("sel","mml_file",g_mma.mma01,g_sfs04,SQLCA.SQLCODE,"","ins sfs",1)       #NO.FUN-660094
        LET g_success='N'
        RETURN
     END IF
   END FOREACH
 
 
END FUNCTION
 
FUNCTION p300_ins_sfs(p_sfs)
DEFINE l_sfs        RECORD LIKE sfs_file.*
DEFINE p_sfs        RECORD
                    sfs02  LIKE sfs_file.sfs02,
                    sfs04  LIKE sfs_file.sfs04,
                    sfs09  LIKE sfs_file.sfs09
                    END RECORD,
       l_sfb98      LIKE sfb_file.sfb98 #FUN-680006
DEFINE l_sfsi       RECORD LIKE sfsi_file.*      #FUN-B70074
DEFINE l_sfp07      LIKE sfp_file.sfp07          #FUN-CB0087 製造部門
DEFINE l_sfp16      LIKE sfp_file.sfp16          #FUN-CB0087 申請人
 
  INITIALIZE l_sfs.* TO NULL
  LET l_sfs.sfs01 = g_sfp01
  LET l_sfs.sfs02 = p_sfs.sfs02
  LET l_sfs.sfs03 = g_sfb01
  LET l_sfs.sfs04 = p_sfs.sfs04
  SELECT * INTO g_sfa.* FROM sfa_file
   WHERE sfa01 = g_sfb01
     AND sfa03 = p_sfs.sfs04
  IF STATUS THEN
      CALL cl_err3("sel","sfa_file",g_sfb01,p_sfs.sfs04,SQLCA.SQLCODE,"","ins sfs",1)       #NO.FUN-660094
     LET g_success='N'
     RETURN 0
  END IF
  CALL p300_chk_ima64(p_sfs.sfs04, g_sfa.sfa05) RETURNING l_sfs.sfs05
  LET l_sfs.sfs06 = g_sfa.sfa12
  LET l_sfs.sfs05 = s_digqty(l_sfs.sfs05,l_sfs.sfs06)     #FUN-BB0084
  LET l_sfs.sfs07 = g_sfa.sfa30
  LET l_sfs.sfs08 = g_sfa.sfa31
  LET l_sfs.sfs09 = p_sfs.sfs09
  LET l_sfs.sfs10 = g_sfa.sfa08
  LET l_sfs.sfs26 = NULL
  LET l_sfs.sfs27 = l_sfs.sfs04   #No.MOD-8B0086 add
  LET l_sfs.sfs28 = NULL
  IF l_sfs.sfs07 IS NULL THEN LET l_sfs.sfs07 = ' ' END IF
  IF l_sfs.sfs08 IS NULL THEN LET l_sfs.sfs08 = ' ' END IF
  IF l_sfs.sfs09 IS NULL THEN LET l_sfs.sfs09 = ' ' END IF
  IF g_aaz.aaz90='Y' THEN
     SELECT sfb98 INTO l_sfb98 FROM sfb_file
                              WHERE sfb01=l_sfs.sfs03
     LET l_sfs.sfs930=l_sfb98
  END IF
  LET l_sfs.sfsplant = g_plant #FUN-980004 add
  LET l_sfs.sfslegal = g_legal #FUN-980004 add
  LET l_sfs.sfs012 = ' '       #FUN-A60027 add 
  LET l_sfs.sfs013  = 0        #FUN-A60027 add
  LET l_sfs.sfs014 = ' '       #FUN-C70014 add
  #FUN-CB0087---add---str---
  IF g_aza.aza115 = 'Y' THEN
     SELECT sfp07,sfp16 INTO l_sfp07,l_sfp16 FROM sfp_file WHERE sfp01 = g_sfp01 
     CALL s_reason_code(l_sfs.sfs01,l_sfs.sfs03,'',l_sfs.sfs04,l_sfs.sfs07,l_sfp16,l_sfp07) RETURNING l_sfs.sfs37
     IF cl_null(l_sfs.sfs37) THEN
        CALL cl_err('','aim-425',1)
        RETURN 0
     END IF
  END IF
  #FUN-CB0087---add---end--
  INSERT INTO sfs_file VALUES(l_sfs.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","sfs_file",l_sfs.sfs01,l_sfs.sfs02,SQLCA.SQLCODE,"","ins sfs",1)       #NO.FUN-660094
     RETURN 0
#FUN-B70074 ----------------Begin-----------------
  ELSE
     IF NOT s_industry('std') THEN
        INITIALIZE l_sfsi.* TO NULL
        LET l_sfsi.sfsi01 = l_sfs.sfs01
        LET l_sfsi.sfsi02 = l_sfs.sfs02
        IF NOT s_ins_sfsi(l_sfsi.*,l_sfs.sfsplant) THEN
          RETURN 0
        END IF
     END IF
#FUN-B70074 ----------------End-------------------
  END IF
  RETURN 1
END FUNCTION
 
FUNCTION p300_chk_ima64(p_part, p_qty)
  DEFINE p_part		LIKE ima_file.ima01
  DEFINE p_qty		LIKE bnj_file.bnj02          #No.FUN-680100 DECIMAL(11,3)#數量
  DEFINE l_ima108	LIKE ima_file.ima108
  DEFINE l_ima64	LIKE ima_file.ima64
  DEFINE l_ima641	LIKE ima_file.ima641
  DEFINE i		LIKE type_file.num10         #No.FUN-680100 INTEGER
 
  SELECT ima108,ima64,ima641 INTO l_ima108,l_ima64,l_ima641
         FROM ima_file WHERE ima01=p_part
  IF STATUS THEN RETURN p_qty END IF
  IF l_ima108='Y' THEN RETURN p_qty END IF
  IF l_ima641 != 0 AND p_qty<l_ima641 THEN
     LET p_qty=l_ima641
  END IF
  IF l_ima64<>0 THEN
     LET i=p_qty / l_ima64 + 0.999999
     LET p_qty= i * l_ima64
  END IF
  RETURN p_qty
 
END FUNCTION
 
FUNCTION p300_ins_sfuv()    #M
DEFINE l_sfu   RECORD LIKE sfu_file.*
DEFINE l_sfv   RECORD LIKE sfv_file.*
DEFINE  l_smykind    LIKE smy_file.smykind
DEFINE l_smyapr      LIKE smy_file.smyapr         #CHI-B80004 add
DEFINE  li_result    LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE l_sfb98 LIKE sfb_file.sfb98 #FUN-680006
DEFINE l_sfvi  RECORD LIKE sfvi_file.*          #FUN-B70074
 
  INITIALIZE l_sfu.* TO NULL
 
  IF cl_null(g_mmd.mmd04) THEN
     LET g_success='N'
     CALL cl_err(g_mmd.mmd04,'amm-019',1)
     RETURN
  END IF
  IF cl_null(g_mmd.mmd041) THEN
     LET g_success='N'
     CALL cl_err(g_mmd.mmd04,'amm-019',1)
     RETURN
  END IF
  LET l_sfu.sfu01=g_mmd.mmd041
  IF g_smy.smyauno !='Y' THEN
     LET g_success='N'
     CALL cl_err(l_sfu.sfu01,'amm-018',1)
     RETURN
  END IF
   #SELECT smykind INTO l_smykind FROM smy_file                           #CHI-B80004 mark
   SELECT smykind,smyapr INTO l_smykind,l_smyapr FROM smy_file            #CHI-B80004 add
    WHERE smyslip = l_sfu.sfu01
   CALL s_auto_assign_no("asf",l_sfu.sfu01,g_today,l_smykind,"","","","","")
   RETURNING li_result,l_sfu.sfu01
   IF (NOT li_result) THEN
       RETURN
   END IF
  LET g_sfu01 = l_sfu.sfu01
  LET l_sfu.sfu00   = '1'
  LET l_sfu.sfu02   = g_today
  LET l_sfu.sfu14   = g_today #FUN-860069
  LET l_sfu.sfu04   = g_mma.mma15
  LET l_sfu.sfupost = "N"
  LET l_sfu.sfuconf = "N" #FUN-660137
  LET l_sfu.sfuuser = g_user
  LET l_sfu.sfugrup = g_grup
  LET l_sfu.sfudate = g_today
  LET l_sfu.sfuplant = g_plant #FUN-980004 add
  LET l_sfu.sfulegal = g_legal #FUN-980004 add
  LET l_sfu.sfuoriu = g_user      #No.FUN-980030 10/01/04
  LET l_sfu.sfuorig = g_grup      #No.FUN-980030 10/01/04
  #FUN-A80128---add---str--
  LET l_sfu.sfu15   = '0'
  LET l_sfu.sfu16   = g_user
  #LET l_sfu.sfumksg = 'N'        #CHI-B80004 mark
  #FUN-A80128---add---end--
  LET l_sfu.sfumksg = l_smyapr    #CHI-B80004 add 
  INSERT INTO sfu_file VALUES(l_sfu.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","sfu_file",l_sfu.sfu01,"",SQLCA.SQLCODE,"","ins sfu",1)       #NO.FUN-660094
     LET g_success='N'
     RETURN
  END IF
  INITIALIZE l_sfv.* TO NULL
  LET l_sfv.sfv01 = g_sfu01
  LET l_sfv.sfv03 = 1
  LET l_sfv.sfv04 = g_mma.mma05
 
   LET l_sfv.sfv05 = g_mma.mma21    #No.MOD-4A0014
   LET l_sfv.sfv06 = g_mma.mma211   #No.MOD-4A0014
  LET l_sfv.sfv07 = ' '
  LET l_sfv.sfv08 = g_mma.mma10
  LET l_sfv.sfv09 = g_sfa.sfa05
  LET l_sfv.sfv09 = s_digqty(l_sfv.sfv09,l_sfv.sfv08)   #No.FUN-BB0086
  LET l_sfv.sfv11 = g_sfb01
  IF g_aaz.aaz90='Y' THEN
     SELECT sfb98 INTO l_sfb98 FROM sfb_file
                              WHERE sfb01=l_sfv.sfv11
     LET l_sfv.sfv930=l_sfb98
  END IF
  LET l_sfv.sfvplant = g_plant #FUN-980004 add
  LET l_sfv.sfvlegal = g_legal #FUN-980004 add
  #FUN-CB0087---add---str---
  IF g_aza.aza115 = 'Y' THEN
     CALL s_reason_code(l_sfv.sfv01,l_sfv.sfv11,'',l_sfv.sfv04,l_sfv.sfv05,l_sfu.sfu16,l_sfu.sfu04) RETURNING l_sfv.sfv44 
     IF cl_null(l_sfv.sfv44) THEN
        CALL cl_err('','aim-425',1)
        RETURN
     END IF
  END IF
  #FUN-CB0087---add---end--
  INSERT INTO sfv_file VALUES(l_sfv.*)
  IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","sfv_file",l_sfv.sfv01,l_sfv.sfv03,SQLCA.SQLCODE,"","ins sfv",1)       #NO.FUN-660094
     RETURN
#FUN-B70074--add--insert--
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfvi.* TO NULL
         LET l_sfvi.sfvi01 = l_sfv.sfv01
         LET l_sfvi.sfvi03 = l_sfv.sfv03
         IF NOT s_ins_sfvi(l_sfvi.*,l_sfv.sfvplant) THEN
            RETURN
         END IF
      END IF
#FUN-B70074--add--insert--
  END IF
END FUNCTION
 
FUNCTION p300_ins_pmkl()        #P
   DEFINE l_pmk     RECORD LIKE pmk_file.*
   DEFINE l_pml     RECORD LIKE pml_file.*
   DEFINE l_smykind LIKE smy_file.smykind
   DEFINE l_smyapr  LIKE smy_file.smyapr    #CHI-B80004 add
   DEFINE li_result LIKE type_file.num5     #No.FUN-680100 SMALLINT
   DEFINE l_ima491  LIKE ima_file.ima491    #No.TQC-640132
   DEFINE l_ima49   LIKE ima_file.ima49     #No.TQC-640132
   DEFINE l_pmli    RECORD LIKE pmli_file.* #No.FUN-7B0018
 
   INITIALIZE l_pmk.* TO NULL
   INITIALIZE l_pml.* TO NULL
   IF cl_null(g_mmd.mmd05) THEN
      LET g_success='N'
      CALL cl_err(g_mmd.mmd05,'amm-019',1)
      RETURN
   END IF
   IF cl_null(g_mmd.mmd051) THEN
      LET g_success='N'
      CALL cl_err(g_mmd.mmd05,'amm-019',1)
      RETURN
   END IF
   LET l_pmk.pmk01=g_mmd.mmd051
   IF g_smy.smyauno !='Y' THEN
      LET g_success='N'
      CALL cl_err(l_pmk.pmk01,'amm-018',1)
      RETURN
   END IF
    #SELECT smykind INTO l_smykind FROM smy_file                        #CHI-B80004 mark
    SELECT smykind,smyapr INTO l_smykind,l_smyapr FROM smy_file         #CHI-B80004 add
     WHERE smyslip = l_pmk.pmk01
    CALL s_auto_assign_no("apm",l_pmk.pmk01,g_today,l_smykind,"","","","","")
    RETURNING li_result,l_pmk.pmk01
    IF (NOT li_result) THEN
        RETURN
    END IF
   LET g_pmk01 = l_pmk.pmk01
   SELECT pmc15,pmc16,pmc17,pmc47,pmc22,pmc49
     INTO l_pmk.pmk10,l_pmk.pmk11,l_pmk.pmk20,
          l_pmk.pmk21,l_pmk.pmk22,l_pmk.pmk41
     FROM pmc_file WHERE pmc01=l_pmk.pmk09
   LET l_pmk.pmk04=g_today
   SELECT azn02,azn04 INTO l_pmk.pmk31,l_pmk.pmk32
    FROM azn_file
    WHERE azn01 = l_pmk.pmk04
   IF cl_null(l_pmk.pmk31) THEN LET l_pmk.pmk31=YEAR(l_pmk.pmk04) END IF
   IF cl_null(l_pmk.pmk32) THEN LET l_pmk.pmk32=MONTH(l_pmk.pmk04) END IF
   IF cl_null(l_pmk.pmk22) THEN LET l_pmk.pmk22=g_aza.aza17        END IF
   IF g_aza.aza17 = l_pmk.pmk22 THEN   #本幣
       LET l_pmk.pmk42 = 1
   ELSE
       CALL s_curr3(l_pmk.pmk22,l_pmk.pmk04,'S')
            RETURNING l_pmk.pmk42
   END IF
   IF cl_null(l_pmk.pmk42) THEN LET l_pmk.pmk42=1 END IF
   SELECT gec04 INTO l_pmk.pmk43 FROM gec_file
    WHERE gec01=l_pmk.pmk21 AND gec011='1'
   IF cl_null(l_pmk.pmk43) THEN LET l_pmk.pmk43=0 END IF
   LET l_pmk.pmk02='REG'
   LET l_pmk.pmk03=0
   LET l_pmk.pmk09 =g_mmb[l_ac].mmb08
   LET l_pmk.pmk12=g_user
   LET l_pmk.pmk13=g_grup
   LET l_pmk.pmk18  ="N"
   LET l_pmk.pmk25  ="0"
   LET l_pmk.pmk30  ="N"
   LET l_pmk.pmk45  ="Y"
   LET l_pmk.pmkprsw="Y"
   LET l_pmk.pmkprno=0
   LET l_pmk.pmkacti="Y"
   #LET l_pmk.pmkmksg="N"            #CHI-B80004 mark
   LET l_pmk.pmkmksg=l_smyapr        #CHI-B80004 add
   LET l_pmk.pmkuser=g_user
   LET l_pmk.pmkgrup=g_grup
   LET l_pmk.pmkdate=g_today
   LET l_pmk.pmk46='1'     #NO.FUN-960130
   LET l_pmk.pmkplant = g_plant #FUN-980004 add
   LET l_pmk.pmklegal = g_legal #FUN-980004 add
   LET l_pmk.pmkoriu = g_user      #No.FUN-980030 10/01/04
   LET l_pmk.pmkorig = g_grup      #No.FUN-980030 10/01/04
   INSERT INTO pmk_file VALUES(l_pmk.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("ins","pmk_file",l_pmk.pmk01,"",SQLCA.SQLCODE,"","ins pmk",1)       #NO.FUN-660094
      LET g_success='N'
      RETURN
   END IF
  
   LET l_pml.pml01 =l_pmk.pmk01
   LET l_pml.pml011='REG'
   LET l_pml.pml02 =1
   LET l_pml.pml04 =g_mma.mma05
   SELECT ima02,ima25,ima25,ima39,ima49,ima491,   #No.TQC-640132
          ima913,ima914                           #NO.CHI-6A0016
     INTO l_pml.pml041,l_pml.pml07,l_pml.pml08,l_pml.pml40,l_ima49,l_ima491,  #No.TQC-640132
          l_pml.pml190,l_pml.pml191               #NO.CHI-6A0016
     FROM ima_file
    WHERE ima01=l_pml.pml04
   LET l_pml.pml06=g_mma.mma01,'+',g_mmb[l_ac].mmb02 USING '#####&'
   LET l_pml.pml09=1
   LET l_pml.pml10='N'
   LET l_pml.pml11='N'
   LET l_pml.pml13=99.99
   LET l_pml.pml14=g_sma.sma886[1,1]     #No.MOD-480018
   LET l_pml.pml15='Y'
   LET l_pml.pml16='0'
   LET l_pml.pml20 =g_mmb[l_ac].mmb18
   LET l_pml.pml20 = s_digqty(l_pml.pml20,l_pml.pml07)   #FUN-910088--add--
   LET l_pml.pml21=0
   LET l_pml.pml23='Y'
   LET l_pml.pml30=0
   LET l_pml.pml31=0
   LET l_pml.pml32=0
   LET l_pml.pml35=g_today
   CALL s_aday(l_pml.pml35,-1,l_ima491) RETURNING l_pml.pml34
   CALL s_aday(l_pml.pml34,-1,l_ima49) RETURNING l_pml.pml33
   LET l_pml.pml38='Y'
   LET l_pml.pml42='0'
   LET l_pml.pml44=0
   LET l_pml.pml930=s_costcenter(g_mma.mma15)  #FUN-670061
   LET l_pml.pml192 = 'N'       #CHI-6A0016
   LET l_pml.pml49 = ' '    #NO.FUN-960130
   LET l_pml.pml50 = '1'    #NO.FUN-960130
   LET l_pml.pml54 = ' '    #NO.FUN-960130
   LET l_pml.pml56 = ' '    #NO.FUN-960130
   LET l_pml.pmlplant = g_plant #FUN-980004 add
   LET l_pml.pmllegal = g_legal #FUN-980004 add
   LET l_pml.pml91 = ' '  #FUN-980004 add
   LET l_pml.pml92 = 'N'  #FUN-9B0023 
   INSERT INTO pml_file VALUES(l_pml.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("ins","pml_file",l_pml.pml01,l_pml.pml02,SQLCA.SQLCODE,"","ins pml",1)       #NO.FUN-660094
      LET g_success='N'
      RETURN
   END IF
 
   IF NOT s_industry('std') THEN
      INITIALIZE l_pmli.* TO NULL
      LET l_pmli.pmli01 = l_pml.pml01
      LET l_pmli.pmli02 = l_pml.pml02
      IF NOT s_ins_pmli(l_pmli.*,'') THEN
         LET g_success='N'
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p300_ins_pmmn()   #P
DEFINE l_pmm  RECORD LIKE pmm_file.*
DEFINE l_pmn  RECORD LIKE pmn_file.*
DEFINE l_sum  LIKE pml_file.pml21
DEFINE l_smykind     LIKE smy_file.smykind
DEFINE l_smyapr      LIKE smy_file.smyapr   #CHI-B80004 add
DEFINE li_result     LIKE type_file.num5    #No.FUN-680100 SMALLINT
DEFINE l_pmni RECORD LIKE pmni_file.*       #No.FUN-830132
 
    INITIALIZE l_pmm.* TO NULL
    INITIALIZE l_pmn.* TO NULL
    IF cl_null(g_mmd.mmd06) THEN
       LET g_success='N'
       CALL cl_err(g_mmd.mmd06,'amm-019',1)
       RETURN
    END IF
    IF cl_null(g_mmd.mmd061) THEN
       LET g_success='N'
       CALL cl_err(g_mmd.mmd06,'amm-019',1)
       RETURN
    END IF
    LET l_pmm.pmm01=g_mmd.mmd061
    IF g_smy.smyauno !='Y' THEN
       LET g_success='N'
       CALL cl_err(l_pmm.pmm01,'amm-018',1)
       RETURN
    END IF
   #SELECT smykind INTO l_smykind FROM smy_file                           #CHI-B80004 mark
   SELECT smykind,smyapr INTO l_smykind,l_smyapr FROM smy_file            #CHI-B80004 add
    WHERE smyslip = l_pmm.pmm01
   CALL s_auto_assign_no("apm",l_pmm.pmm01,g_today,l_smykind,"","","","","")
   RETURNING li_result,l_pmm.pmm01
   IF (NOT li_result) THEN
       RETURN
   END IF
    LET g_pmm01 = l_pmm.pmm01
    IF g_mmb[l_ac].mmb07='P' THEN
       LET l_pmm.pmm02=g_pmk.pmk02     #單據性質
    ELSE        #S
       LET l_pmm.pmm02='SUB'           #單據性質
    END IF
    LET l_pmm.pmm03=" "               #更動序號
    LET l_pmm.pmm04=g_pmk.pmk04       #採購日期
    LET l_pmm.pmm05=''                #專案號碼-> no use
    LET l_pmm.pmm06=g_pmk.pmk06       #預算號碼
    LET l_pmm.pmm07=g_pmk.pmk07       #單據分類
    LET l_pmm.pmm08=g_pmk.pmk08       #PBI批號
    LET l_pmm.pmm09=g_pmk.pmk09       #供應廠商
    LET l_pmm.pmm10=g_pmk.pmk10       #送貨地址
    LET l_pmm.pmm11=g_pmk.pmk11       #帳單地址
    LET l_pmm.pmm12=g_pmk.pmk12       #採購員
    LET l_pmm.pmm13=g_pmk.pmk13       #採購部門
    LET l_pmm.pmm14=g_pmk.pmk14       #收貨部門
    LET l_pmm.pmm15=g_pmk.pmk15       #確認人
    LET l_pmm.pmm16=g_pmk.pmk16       #運送方式
    LET l_pmm.pmm17=g_pmk.pmk17       #代理商
    LET l_pmm.pmm18="N"
    LET l_pmm.pmm20=g_pmk.pmk20       #付款方式
    LET l_pmm.pmm21=g_pmk.pmk21       #稅別
    LET l_pmm.pmm22=g_pmk.pmk22       #幣別
    #LET l_pmm.pmmmksg=g_pmk.pmkmksg  #是否簽核     #CHI-B80004 mark
    LET l_pmm.pmmmksg=l_smyapr        #是否簽核     #CHI-B80004 add
    LET l_pmm.pmm25='0'                 #狀況碼
    LET l_pmm.pmm26=NULL              #理由碼
    LET l_pmm.pmm27=g_today           #狀況異動日期
    LET l_pmm.pmm28=g_pmk.pmk28       #會計分類
    LET l_pmm.pmm29=g_pmk.pmk29       #會計科目
    LET l_pmm.pmm30=g_pmk.pmk30       #驗收單列印否
    IF cl_null(l_pmm.pmm31) THEN
       LET l_pmm.pmm31=g_pmk.pmk31    #會計年度
    END IF
    IF cl_null(l_pmm.pmm32) THEN
       LET l_pmm.pmm32=g_pmk.pmk32    #會計期間
    END IF
    LET l_pmm.pmm40                   #總金額
       = g_mmb[l_ac].mmb18 * g_mmb[l_ac].mmb16
    LET l_pmm.pmm40t=0                #總含稅金額  NO.MOD-660135
    LET l_pmm.pmm401=0                #代買總金額
    LET l_pmm.pmm41=g_pmk.pmk41       #價格條件
    LET l_pmm.pmm42=g_pmk.pmk42       #匯率
    LET l_pmm.pmm43=g_pmk.pmk43       #稅率
    LET l_pmm.pmm44='0'               #稅處理
    LET l_pmm.pmm45=g_pmk.pmk45       #可用/不可用
    LET l_pmm.pmm46=0                 #預付比率
    LET l_pmm.pmm47=0                 #預付金額
    LET l_pmm.pmm48=0                 #已結帳金額
    LET l_pmm.pmm49='N'               #預付發票否
    LET l_pmm.pmmprsw=g_pmk.pmkprsw   #列印抑制
    LET l_pmm.pmmprno=0               #已列印次數
    LET l_pmm.pmmprdt=NULL            #最後列印日期
    LET l_pmm.pmmsseq = 0             #已簽順序
    LET l_pmm.pmmsmax = 0             #應簽順序
    LET l_pmm.pmmacti='Y'             #資料有效碼
    LET l_pmm.pmmuser=g_pmk.pmkuser   #資料所有者
    LET l_pmm.pmmgrup=g_pmk.pmkgrup   #資料所有部門
    LET l_pmm.pmmmodu=' '             #資料修改者
    LET l_pmm.pmmdate=' '             #最近修改日期
#   LET l_pmm.pmm51 = ' '             #NO.FUN-960130    #FUN-B70015 mark
    LET l_pmm.pmm51 = '1'             #FUN-B70015
    LET l_pmm.pmmpos = ' '            #NO.FUN-960130
    LET l_pmm.pmmplant = g_plant #FUN-980004 add
    LET l_pmm.pmmlegal = g_legal #FUN-980004 add
    LET l_pmm.pmmoriu = g_user      #No.FUN-980030 10/01/04
    LET l_pmm.pmmorig = g_grup      #No.FUN-980030 10/01/04
    INSERT INTO pmm_file VALUES(l_pmm.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("ins","pmm_file",l_pmm.pmm01,"",SQLCA.SQLCODE,"","ins pmm",1)       #NO.FUN-660094
       LET g_success='N'
       RETURN
    END IF
 
   #---產生採購單身資料
   SELECT * INTO g_pml.* FROM pml_file WHERE pml01 = g_pmk01
   LET  l_pmn.pmn01 =l_pmm.pmm01         #採購單號
   LET  l_pmn.pmn011=g_pml.pml011        #採購性質
   LET  l_pmn.pmn02=g_pml.pml02          #序號
   LET  l_pmn.pmn03=g_pml.pml03          #詢價單號
   LET  l_pmn.pmn04=g_pml.pml04          #料號
   LET  l_pmn.pmn041=g_pml.pml041        #品名
   LET  l_pmn.pmn05=g_pml.pml05          #APS單號
   LET  l_pmn.pmn06=g_pml.pml06          #廠商料號
   LET  l_pmn.pmn07=g_pml.pml07          #採購單位
   LET  l_pmn.pmn121= 1                  #請採購轉換因子
   LET  l_pmn.pmn08=g_pml.pml08          #庫存單位
   LET  l_pmn.pmn09=1
   LET  l_pmn.pmn11=g_pml.pml11          #凍結碼
   LET  l_pmn.pmn13=g_pml.pml13          #超短交限率
   LET  l_pmn.pmn14=g_pml.pml14          #部份交貨否
   LET  l_pmn.pmn15=g_pml.pml15          #提前交貨否
   LET  l_pmn.pmn16='0'
   LET  l_pmn.pmn20=g_pml.pml20          #數量
   LET  l_pmn.pmn23=' '                  #送貨地址
   LET  l_pmn.pmn24=g_pmk.pmk01          #請購單號
   LET  l_pmn.pmn25=g_pml.pml02          #序號
   LET  l_pmn.pmn30=g_pml.pml30          #標準價格
   LET  l_pmn.pmn31=g_mmb[l_ac].mmb16    #單價 (未稅)  BugNo.7259
   LET  l_pmn.pmn31t=l_pmn.pmn31*(1.0+l_pmm.pmm43/100.0)    #單價 BugNo.7259
   LET  l_pmn.pmn34=g_pml.pml34
   LET  l_pmn.pmn33=l_pmn.pmn34          #原始交貨日
   LET  l_pmn.pmn35=l_pmn.pmn34          #到庫日
   LET  l_pmn.pmn36=NULL                  #最近確認交貨日期
   LET  l_pmn.pmn37=NULL                  #最後一次到廠日期
   LET  l_pmn.pmn38=g_pml.pml38          #可用/不可用
   LET  l_pmn.pmn40=g_pml.pml40          #會計科目
   LET  l_pmn.pmn41=g_pml.pml41          #工單號碼
   LET  l_pmn.pmn42=g_pml.pml42          #替代碼
   LET  l_pmn.pmn43=g_pml.pml43          #作業序號
   LET  l_pmn.pmn431=g_pml.pml431        #下一站作業序號
   LET  l_pmn.pmn44 =l_pmn.pmn31 * l_pmm.pmm42  #本幣單價
   LET  l_pmn.pmn45=NULL                 #NO:7190
   LET  l_pmn.pmn50=0                     #交貨量
   LET  l_pmn.pmn51=0                     #在驗量
   LET  l_pmn.pmn53=0                     #入庫量
   LET  l_pmn.pmn52=g_mma.mma21           #倉庫
   LET  l_pmn.pmn54=g_mma.mma211          #儲位
   LET  l_pmn.pmn55=0                     #驗退量
   LET  l_pmn.pmn56=' '                   #批號
   LET  l_pmn.pmn57=0                     #超短交量
   LET  l_pmn.pmn58=0                     #無交期性採購單已轉量
   LET  l_pmn.pmn59=' '                   #退貨單號
   LET  l_pmn.pmn60=' '                   #項次
   LET  l_pmn.pmn61=l_pmn.pmn04           #被替代料號
   LET  l_pmn.pmn62=1                     #替代率
   LET  l_pmn.pmn63='N'                   #急料否
   LET  l_pmn.pmn66=g_pml.pml66
   LET  l_pmn.pmn67=g_pml.pml67
   LET  l_pmn.pmn64='N'
   LET  l_pmn.pmn90=g_pml.pml31   #CHI-690043 add
      LET l_pmn.pmn65='1'                 #一般/代買
   IF NOT (cl_null(l_pmn.pmn24) AND cl_null(l_pmn.pmn25)) THEN
      LET l_pmn.pmn930=g_pml.pml930
   ELSE
      LET l_pmn.pmn930=s_costcenter(l_pmm.pmm13)
   END IF
   LET l_pmn.pmn87 = g_pml.pml87
   SELECT azi04 INTO t_azi03,t_azi04 FROM azi_file     #No.
    WHERE azi01 = l_pmm.pmm22  AND aziacti= 'Y'  #原幣
 
   LET l_pmn.pmn88 = cl_digcut( l_pmn.pmn31  * l_pmn.pmn87 ,t_azi04)
   LET l_pmn.pmn88t= cl_digcut( l_pmn.pmn31t * l_pmn.pmn87 ,t_azi04)
 
   IF cl_null(l_pmn.pmn01) THEN LET l_pmn.pmn01 = ' ' END IF
   IF cl_null(l_pmn.pmn02) THEN LET l_pmn.pmn02 = 0 END IF
   LET l_pmn.pmn73 = ' '                #NO.FUN-960130
   LET l_pmn.pmnplant = g_plant #FUN-980004 add
   LET l_pmn.pmnlegal = g_legal #FUN-980004 add
   IF cl_null(l_pmn.pmn58) THEN LET l_pmn.pmn58 = 0 END IF #TQC-9B0203
   IF cl_null(l_pmn.pmn012) THEN LET l_pmn.pmn012 = ' ' END IF #TQC-A70004
   CALL s_schdat_pmn78(l_pmn.pmn41,l_pmn.pmn012,l_pmn.pmn43,l_pmn.pmn18,   #FUN-C10002
                                   l_pmn.pmn32) RETURNING l_pmn.pmn78      #FUN-C10002
   INSERT INTO pmn_file VALUES(l_pmn.*)
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      CALL cl_err3("ins","pmn_file",l_pmn.pmn01,l_pmn.pmn02,SQLCA.SQLCODE,"","ins pmn",1)       #NO.FUN-660094
      LET g_success='N'
      RETURN
   ELSE
      IF NOT s_industry('std') THEN
         INITIALIZE l_pmni.* TO NULL
         LET l_pmni.pmni01 = l_pmn.pmn01
         LET l_pmni.pmni02 = l_pmn.pmn02
         IF NOT s_ins_pmni(l_pmni.*,'') THEN
            LET g_success='N'
            RETURN
         END IF
      END IF
   END IF
 
   LET l_sum=0
   SELECT SUM(pmn20/pmn62*pmn121) INTO l_sum FROM pmn_file
    WHERE pmn24 = g_pmk.pmk01 AND pmn25 = g_pml.pml02
      AND pmn16 <>'9'
   LET l_sum = s_digqty(l_sum,g_pml.pml07)   #FUN-910088--add--
   UPDATE pml_file SET pml16='2',pml21=l_sum
    WHERE pml01 = g_pmk.pmk01 AND pml02 = g_pml.pml02
   IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
      LET g_success='N'
       CALL cl_err3("upd","pml_file",g_pmk.pmk01,g_pml.pml02,SQLCA.SQLCODE,"","upd pml",1)       #NO.FUN-660094
      LET g_success='N'
      RETURN
   END IF
 
END FUNCTION
 
FUNCTION p300_ins_rvab(p_cmd)   #P,S
  DEFINE  p_cmd        LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
  DEFINE  l_rva        RECORD LIKE rva_file.*
  DEFINE  l_smykind    LIKE smy_file.smykind
  DEFINE  li_result    LIKE type_file.num5          #No.FUN-680100 SMALLINT
  DEFINE  l_smyapr     LIKE smy_file.smyapr         #FUN-9C0076 add

    INITIALIZE l_rva.* TO NULL
    IF p_cmd = 'S' THEN
       IF cl_null(g_mmd.mmd13) THEN
          LET g_success='N'
          CALL cl_err(g_mmd.mmd13,'amm-019',1)
          RETURN
       END IF
       IF cl_null(g_mmd.mmd131) THEN
          LET g_success='N'
          CALL cl_err(g_mmd.mmd131,'amm-019',1)
          RETURN
       END IF
       LET l_rva.rva01=g_mmd.mmd131
    ELSE
       IF cl_null(g_mmd.mmd07) THEN
          LET g_success='N'
          CALL cl_err(g_mmd.mmd07,'amm-019',1)
          RETURN
       END IF
       IF cl_null(g_mmd.mmd071) THEN
          LET g_success='N'
          CALL cl_err(g_mmd.mmd07,'amm-019',1)
          RETURN
       END IF
       LET l_rva.rva01=g_mmd.mmd071
    END IF
    IF g_smy.smyauno !='Y' THEN
       LET g_success='N'
       CALL cl_err(l_rva.rva01,'amm-018',1)
       RETURN
    END IF

   #FUN-9C0076 add str ---
    SELECT smyapr INTO l_smyapr FROM smy_file
     WHERE smysys='apm' AND smykind='3' AND smyslip=l_rva.rva01

    LET l_rva.rvamksg = l_smyapr    #是否簽核
   #FUN-9C0076 add end ---

    SELECT smykind INTO l_smykind FROM smy_file
     WHERE smyslip = l_rva.rva01
    CALL s_auto_assign_no("apm",l_rva.rva01,g_today,l_smykind,"","","","","")
    RETURNING li_result,l_rva.rva01
    IF (NOT li_result) THEN
       RETURN
    END IF

    LET g_rva01 = l_rva.rva01
    LET l_rva.rva02  =g_pmm.pmm01
    LET l_rva.rva04  ="N"
    LET l_rva.rva05  =g_mmb[l_ac].mmb08
    LET l_rva.rva06  =g_today
    LET l_rva.rva10  =g_pmm.pmm02
    LET l_rva.rvaprsw='N'
    LET l_rva.rva23  = NULL #no.7143
    LET l_rva.rvaconf='N'
    LET l_rva.rvaprno=0
    LET l_rva.rvaacti='Y'
    LET l_rva.rvauser=g_user
    LET l_rva.rvagrup=g_grup
    LET l_rva.rvadate=g_today
    LET l_rva.rva29= ' '            #NO.FUN-960130
    LET l_rva.rvaplant = g_plant    #FUN-980004 add
    LET l_rva.rvalegal = g_legal    #FUN-980004 add
    LET l_rva.rvaoriu = g_user      #No.FUN-980030 10/01/04
    LET l_rva.rvaorig = g_grup      #No.FUN-980030 10/01/04
    LET l_rva.rva32 = '0'           #簽核狀況  #FUN-9C0076 add
    LET l_rva.rva33 = g_pmm.pmm12   #申請人    #FUN-9C0076 add

    INSERT INTO rva_file VALUES(l_rva.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("ins","rva_file",l_rva.rva01,"",SQLCA.SQLCODE,"","ins rva",1)       #NO.FUN-660094
       LET g_success='N'
       RETURN
    END IF
    CALL p300_ins_rvb(p_cmd,1) RETURNING g_cnt
    IF g_cnt = 0 THEN
       CALL cl_err('ins rvb',SQLCA.SQLCODE,1)
       LET g_success='N'
       RETURN
    END IF
    IF p_cmd = 'S' THEN
       LET g_con = 1
       FOREACH mml_cur USING g_mma.mma01,g_mmb[l_ac].mmb02 INTO g_mml.*
         LET g_con = g_con + 1
         CALL p300_ins_rvb(p_cmd,g_con) RETURNING g_cnt
         IF g_cnt = 0 THEN
            CALL cl_err('ins rvb',SQLCA.SQLCODE,1)
            LET g_success='N'
            RETURN
         END IF
       END FOREACH
    END IF
 
END FUNCTION
 
FUNCTION p300_ins_rvb(p_cmd,p_rvb02)   #P,S
DEFINE l_rvb      RECORD LIKE rvb_file.*
DEFINE l_ima491   LIKE ima_file.ima491
DEFINE p_cmd      LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
DEFINE p_rvb02    LIKE rvb_file.rvb02
DEFINE l_rvbi     RECORD LIKE rvbi_file.*      #No.FUN-7B0018
 
    INITIALIZE l_rvb.* TO NULL
    SELECT * INTO g_pmn.* FROM pmn_file
     WHERE pmn01 = g_pmm01
       AND pmn02 = p_rvb02
    LET l_rvb.rvb01 = g_rva01
    LET l_rvb.rvb02 = p_rvb02
    LET l_rvb.rvb03 = g_pmn.pmn02
    LET l_rvb.rvb04 = g_pmm.pmm01
    LET l_rvb.rvb05 = g_pmn.pmn04           #料號
    LET l_rvb.rvb36 = g_pmn.pmn52           #倉庫
    LET l_rvb.rvb37 = g_pmn.pmn54           #儲位
    LET l_rvb.rvb06 = 0
    LET l_rvb.rvb07 = g_pmn.pmn20
    LET l_rvb.rvb08 = l_rvb.rvb07
    LET l_rvb.rvb09 = 0
    LET l_rvb.rvb10 = g_pmn.pmn31
    LET l_rvb.rvb11 = 0
    SELECT ima491 INTO l_ima491 FROM ima_file
     WHERE ima01 = l_rvb.rvb05
    IF cl_null(l_ima491) THEN LET l_ima491 = 0 END IF
    IF l_ima491 > 0 THEN
       CALL s_getdate(g_today,l_ima491) RETURNING l_rvb.rvb12
    ELSE
       IF cl_null(l_rvb.rvb12) THEN LET l_rvb.rvb12 = g_today  END IF
    END IF
    LET l_rvb.rvb15 = 0
    LET l_rvb.rvb16 = 0
    LET l_rvb.rvb17 = NULL
    LET l_rvb.rvb18 = '10'
    LET l_rvb.rvb19 = '1'
    LET l_rvb.rvb20 = NULL
    LET l_rvb.rvb21 = NULL
    LET l_rvb.rvb22 = NULL
    LET l_rvb.rvb25 = NULL
    LET l_rvb.rvb26 = NULL
    LET l_rvb.rvb27 = 0
    LET l_rvb.rvb28 = 0
    LET l_rvb.rvb29 = 0
    LET l_rvb.rvb30 = 0
    LET l_rvb.rvb31 = l_rvb.rvb07
    LET l_rvb.rvb32 = ' '
    LET l_rvb.rvb33 = l_rvb.rvb07
    IF p_cmd = 'S' THEN
       LET l_rvb.rvb34 = g_sfb01
    ELSE
       LET l_rvb.rvb34 = NULL
    END IF
    LET l_rvb.rvb35 = 'N'
    IF l_rvb.rvb36 IS NULL THEN LET l_rvb.rvb36=' ' END IF
    IF l_rvb.rvb37 IS NULL THEN LET l_rvb.rvb37=' ' END IF
    IF l_rvb.rvb38 IS NULL THEN LET l_rvb.rvb38=' ' END IF
    LET l_rvb.rvb39 = 'N'   #免驗
    LET l_rvb.rvb40 = NULL
    LET l_rvb.rvb41 = NULL
    IF g_aaz.aaz90='Y' THEN
       LET l_rvb.rvb930=NULL
       SELECT pmn930 INTO l_rvb.rvb930 FROM pmn_file
                                      WHERE pmn01=l_rvb.rvb04
                                        AND pmn02=l_rvb.rvb03                                        
    END IF
    LET l_rvb.rvb42 = ' '   #NO.FUN-960130
    LET l_rvb.rvbplant = g_plant #FUN-980004 add
    LET l_rvb.rvblegal = g_legal #FUN-980004 add
    INSERT INTO rvb_file VALUES(l_rvb.*)
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
       CALL cl_err3("ins","rvb_file",l_rvb.rvb01,l_rvb.rvb02,SQLCA.SQLCODE,"","ins rvb",1)       #NO.FUN-660094
       RETURN 0
    ELSE
       IF NOT s_industry('std') THEN
          INITIALIZE l_rvbi.* TO NULL
          LET l_rvbi.rvbi01 = l_rvb.rvb01
          LET l_rvbi.rvbi02 = l_rvb.rvb02
          IF NOT s_ins_rvbi(l_rvbi.*,'') THEN
             RETURN 0
          END IF
       END IF
    END IF
    RETURN 1
 
END FUNCTION
 
FUNCTION p300_mmb08()
   DEFINE p_cmd       LIKE type_file.chr1,          #No.FUN-680100 VARCHAR(1)
          l_pmc03     LIKE gem_file.gem02,          #No.FUN-680100 VARCHAR(10)
          l_pmcacti   LIKE type_file.chr1           #No.FUN-680100 VARCHAR(1)
 
   LET g_errno = ' '
   IF g_mmb[l_ac].mmb07 ='M' THEN
      SELECT gem02,gemacti INTO l_pmc03,l_pmcacti FROM gem_file
       WHERE gem01=g_mmb[l_ac].mmb08
   ELSE
     SELECT pmc03,pmcacti INTO l_pmc03,l_pmcacti FROM pmc_file
      WHERE pmc01=g_mmb[l_ac].mmb08
   END IF
 
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg3097'
                                  LET l_pmc03 = NULL
        WHEN l_pmcacti='N' LET g_errno = '9028' LET l_pmc03 = NULL
        WHEN l_pmcacti MATCHES '[PH]'       LET g_errno = '9038'
        OTHERWISE          LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
   LET g_mmb[l_ac].desc1=l_pmc03
END FUNCTION
 
FUNCTION p300_b_askkey()
DEFINE l_wc2         LIKE type_file.chr1000         #No.FUN-680100 VARCHAR(300)
   CONSTRUCT l_wc2 ON mmb02,mmb05,mmb06,mmb07,mmb08,
                      mmb16,mmb17,mmb18,mmb20,mmb20,mmb14,mmb141,mmbacti
            FROM s_mmb[1].mmb02,
                 s_mmb[1].mmb05, s_mmb[1].mmb06, s_mmb[1].mmb07,
                 s_mmb[1].mmb08, s_mmb[1].mmb16, s_mmb[1].mmb17,
                 s_mmb[1].mmb18, s_mmb[1].mmb19, s_mmb[1].mmb20,
                 s_mmb[1].mmb14, s_mmb[1].mmb141,s_mmb[1].mmbacti
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
   END CONSTRUCT
 
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    CALL p300_b_fill(l_wc2)
END FUNCTION
 
FUNCTION p300_b_fill(p_wc2)              #BODY FILL UP
DEFINE p_wc2          LIKE type_file.chr1000      #No.FUN-680100 VARCHAR(300)
 
    LET g_sql =
        "SELECT mmb02,mmbacti,mmb05,mmb07,mmb08,'',",
        "       mmb16,mmb17,mmb18,mmb19,mmb20,mmb14,mmb141,mmb06 ",
        " FROM mmb_file ",
        " WHERE mmb01 ='",g_mma.mma01,"'",  #單頭
        "   AND mmbacti = 'Y' ",
         "   AND mmb14   = 'N' ",            #No.MOD-461010
        "   AND ",p_wc2 CLIPPED,                     #單身
        " ORDER BY 1"
 
    PREPARE p300_pb FROM g_sql
    DECLARE mmb_curs                       #SCROLL CURSOR
        CURSOR FOR p300_pb
 
    CALL g_mmb.clear()
    LET g_rec_b = 0
    LET g_cnt = 1
    FOREACH mmb_curs INTO g_mmb[g_cnt].*   #單身 ARRAY 填充
       LET g_rec_b = g_rec_b + 1
       IF STATUS THEN CALL cl_err('foreach:',STATUS,1) EXIT FOREACH END IF
       IF g_mmb[g_cnt].mmb07 ='M' THEN
          SELECT gem02 INTO g_mmb[g_cnt].desc1 FROM gem_file
           WHERE gem01=g_mmb[g_cnt].mmb08
       ELSE
          SELECT pmc03 INTO g_mmb[g_cnt].desc1 FROM pmc_file
           WHERE pmc01=g_mmb[g_cnt].mmb08
       END IF
       LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_mmb.deleteElement(g_cnt)
    LET g_rec_b=g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2
END FUNCTION
 
 
FUNCTION p300_d()
DEFINE l_item   LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE l_cnt    LIKE type_file.num5          #No.FUN-680100 SMALLINT
DEFINE l_mmb07  LIKE mmb_file.mmb07
DEFINE l_mmb141 LIKE mmb_file.mmb141
 
    IF s_shut(0) THEN RETURN END IF
    SELECT * INTO g_mma.* FROM mma_file WHERE mma01 = g_mma.mma01
    IF g_mma.mma01 IS NULL THEN RETURN END IF
    IF g_mma.mma17 = 'N' THEN CALL cl_err('',9029,0) RETURN END IF
    IF g_mma.mmaacti = 'X' THEN CALL cl_err('',9024,0) RETURN END IF
    SELECT COUNT(*) INTO g_cnt FROM mmb_file
     WHERE mmb01 = g_mma.mma01
    IF g_cnt = 0 THEN RETURN END IF
    BEGIN WORK
    OPEN p300_cl USING g_mma.mma01
    FETCH p300_cl INTO g_mma.*
    IF SQLCA.sqlcode THEN
       CALL cl_err(g_mma.mma01,SQLCA.sqlcode,0)
       CLOSE p300_cl ROLLBACK WORK RETURN
    END IF
    OPEN WINDOW cl_del_w AT 17,10 WITH 3 ROWS, 60 COLUMNS
 
    WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
      PROMPT "  ● 請輸入要刪除第幾項次的資料 : " FOR l_item
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      END PROMPT
      IF INT_FLAG THEN LET INT_FLAG = 0 LET l_item = 0 END IF
      IF l_item <= 0 THEN
         LET l_item = 0 EXIT WHILE
      END IF
      SELECT mmb07,mmb141 INTO l_mmb07,l_mmb141 FROM mmb_file
       WHERE mmb01 = g_mma.mma01
         AND mmb02 = l_item
         AND mmb14 = 'Y'
      IF STATUS THEN
          CALL cl_err3("sel","mmb_file",g_mma.mma01,l_item,"amm-039","","",1)       #NO.FUN-660094
      ELSE
         EXIT WHILE
      END IF
   END WHILE
   CLOSE WINDOW cl_del_w
   IF l_item <= 0 THEN RETURN END IF
   IF l_mmb07 = 'P' THEN
      SELECT COUNT(*) INTO l_cnt FROM pmk_file
       WHERE pmk01 = l_mmb141
   ELSE
      SELECT COUNT(*) INTO l_cnt FROM sfb_file
       WHERE sfb01 = l_mmb141
   END IF
   IF l_cnt > 0 THEN
      CALL cl_err(l_item,'amm-040',0)
      ROLLBACK WORK
      RETURN
   ELSE
      UPDATE mmb_file SET mmb14 = 'N',
                          mmb141 = ''
      WHERE mmb01 = g_mma.mma01
        AND mmb02 = l_item
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3]=0 THEN
         ROLLBACK WORK
         CALL cl_rbmsg(4)
      ELSE
         COMMIT WORK
         CALL cl_cmmsg(4)
         CALL p300_b_fill(g_wc2)
      END IF
   END IF
 
END FUNCTION
 
FUNCTION p300_2()
   UPDATE mma_file SET mma04='Y' WHERE mma01=g_mma.mma01
   IF NOT STATUS THEN
      LET g_mma.mma04='Y'
   END IF
END FUNCTION
 
FUNCTION p300_bp(p_ud)
    DEFINE p_ud            LIKE type_file.chr1          #No.FUN-680100 VARCHAR(1)
 
    IF p_ud <> "G" OR g_action_choice = "detail" THEN
        RETURN
    END IF
 
    LET g_action_choice = " "
 
    CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_mmb TO s_mmb.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting( g_curs_index, g_row_count )
       BEFORE ROW
           LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
       ON ACTION controls                                                                                                             
          CALL cl_set_head_visible("","AUTO")                                                                                        
 
       ON ACTION query
          LET g_action_choice="query"
          EXIT DISPLAY
       ON ACTION first
         CALL p300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
       ON ACTION previous
         CALL p300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
       ON ACTION jump
         CALL p300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
       ON ACTION next
         CALL p300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
       ON ACTION last
         CALL p300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
       ON ACTION detail
          LET g_action_choice="detail"
          EXIT DISPLAY
       ON ACTION undo_trans
          LET g_action_choice="undo_trans"
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
 
       ON ACTION accept
          LET g_action_choice="detail"
          LET l_ac = ARR_CURR()
          EXIT DISPLAY
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
 
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION p300_update_pmm40()
    DEFINE l_tot_pmm40   LIKE pmm_file.pmm40
    DEFINE l_tot_pmm40t  LIKE pmm_file.pmm40t   #No.MOD-660135
    DEFINE l_pmm22       LIKE pmm_file.pmm22
 
#   SELECT SUM(pmn31 * pmn20) ,SUM(pmn20*pmn31t) INTO l_tot_pmm40,l_tot_pmm40t   #No.MOD-660135   #CHI-B70039 mark
    SELECT SUM(pmn31 * pmn87) ,SUM(pmn87*pmn31t) INTO l_tot_pmm40,l_tot_pmm40t   #CHI-B70039
      FROM pmn_file
     WHERE pmn01 = g_sfb01
    IF SQLCA.sqlcode OR l_tot_pmm40 IS NULL THEN
        LET l_tot_pmm40 = 0
        LET l_tot_pmm40t= 0     #NO.MOD-660135
    END IF
 
    SELECT pmm22 INTO l_pmm22
      FROM pmm_file
     WHERE pmm01 = g_sfb01
 
    SELECT azi04 INTO t_azi04  #NO.CHI-6A0004
      FROM azi_file
     WHERE azi01=l_pmm22
       AND aziacti ='Y'
    CALL cl_digcut(l_tot_pmm40,t_azi04) RETURNING l_tot_pmm40    #NO.CHI-6A0004      
    CALL cl_digcut(l_tot_pmm40t,t_azi04) RETURNING l_tot_pmm40t  #No.MOD-660135 #NO.CHI-6A0004
 
    UPDATE pmm_file
       SET pmm40 = l_tot_pmm40,  #總金額
           pmm40t= l_tot_pmm40t  #No.MOD-660135
     WHERE pmm01 = g_sfb01
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3]=0 THEN
        CALL cl_err3("upd","pmm_file",g_sfb01,"",SQLCA.SQLCODE,"","upd pmm40,pmm40t",1)       #NO.FUN-660094  #No.MOD-660135
       CALL cl_err(g_pmm01,'amm-035',1)
       RETURN 1
    END IF
    RETURN 0
END FUNCTION
#No.FUN-9C0073 -----------------By chenls 10/01/14

# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: asfr203.4gl
# Descriptions...: 工單合併料表列印
# Modify.........: 97/08/12 By Roger
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-580014 05/08/16 By yoyo 憑証類報表原則修改
# Modify.........: NO.TQC-5B0125 05/11/14 BY yiting 數量移位
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/11/1 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-6A0090 06/11/06 By douzh l_time轉g_time
# Modify.........: No.TQC-770019 07/07/09 By pengu 無法透過工具列，進行語言別切換
# Modify.........: No.MOD-780064 07/12/17 By pengu 1.條件選項作業編號與倉管員有輸入資料但都沒有作篩選
#                                                  2.應依倉管員排序沒打勾時，報表中的倉管員沒印出來
# Modify.........: No.MOD-810138 08/01/17 By Smapmin 修改變數定義
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-7C0080 08/03/25 By Sunyanchun 報表輸出改為CR
# Modify.........: No.FUN-830132 08/03/27 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-860326 08/06/30 By claire 料號合併有問題
# Modify.........: No.MOD-8A0214 08/10/23 By claire 排除結案工單 
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-940418 09/05/21 By Pengu 1.PBI單號只印出12碼
#                                                  2.勾選印QVL，在bml_file中建二筆資料，則第一筆資料重複印二次
#                                                  3.有設替代料勾選替代料全部印出結果沒印出
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-930064 09/11/05 By jan 1.新增欄位'自動產生調撥單否'
#                                                       2.若勾選自動產生調撥單,則將此料表所有工單之ima108 = 'Y'得備料,新增到一筆調撥單
# Modify.........: No.TQC-9C0179 09/12/29 By tsai_yen EXECUTE裡不可有擷取字串的中括號[]
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:TQC-A50156 10/05/26 By Carrier MOD-9C0406 追单
# Modify.........: No.FUN-A60027 10/06/10 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.MOD-B30028 11/03/04 By zhangll 修正插入sfci_file,系统异常当出问题
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No:MOD-B60003 11/06/01 By sabrina 抓替代料的料號時應串sfa29
# Modify.........: No:CHI-B50006 11/06/03 By Vampire ss1,ss2,ss3 重新 LIKE sfb08,sfb01,sfb05
# Modify.........: No:TQC-B60064 11/06/14 By jan 1.補上LET l_sfd.sfdconf = 'N' 2.修正SQL錯誤
# Modify.........: No:MOD-B50238 11/07/17 By Summer l_qty變數沒有給任何值
# Modify.........: No.FUN-B70074 11/07/22 By xianghui 添加行業別表的新增於刪除
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No.FUN-B60135 11/08/12 By xianghui PBI No.提供開窗=>提供開"單別"和"單據編碼"的功能
# Modify.........: No.TQC-B90087 11/09/13 By lilingyu   錄入一筆PBI後,系統出現錯誤提示:-268違反唯一的限制...
# Modify.........: No.TQC-B90095 11/09/14 By lilingyu 打印出來的報表,發料套數和發料數量都不對  	
# Modify.........: No:MOD-C60013 12/06/04 By ck2yuan 判斷不可是已存在sfd_file單身的非本張PBI單的工單號碼,並回寫到工單sfb85
# Modify.........: No.CHI-C60023 12/08/20 By bart 新增欄位-資料類別
# Modify.........: No.FUN-CB0102 12/11/22 By bart 修改CHI-C60023
# Modify.........: No:MOD-CB0170 13/01/07 By Elise 取消TQC-B90095的修改,PBI修改
# Modify.........: No:MOD-D20132 13/02/25 By bart 勾選[列印廠牌資料]，印二行重複的資料(QVL:001,002,)且002後面多一個逗號
# Modify.........: No:MOD-D20165 13/03/04 By Alberti 修改l_avl_stk 僅給定 0  
# Modify.........: No:MOD-D30119 13/03/12 By bart 工單不可重覆輸入
# Modify.........: No:FUN-D10127 13/03/15 By Alberti 增加sfduser,sfdgrup,sfdmodu,sfddate,sfdacti

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE g_sfc01  LIKE sfc_file.sfc01                         #No.FUN-550067
DEFINE g_no	ARRAY[100] OF LIKE sfd_file.sfd03           #No.FUN-680121 VARCHAR(16)#No.FUN-550067
DEFINE g_part	ARRAY[100] OF LIKE sfb_file.sfb05           #No.FUN-680121 VARCHAR(40)#No.FUN-550067
DEFINE g_sfa08  LIKE sfa_file.sfa08                         #No.MOD-780064 add
DEFINE g_ima23  LIKE ima_file.ima23                         #No.MOD-780064 add
DEFINE g_t1     LIKE oay_file.oayslip                       #No.FUN-550067        #No.FUN-680121 VARCHAR(5)
DEFINE s1,s2,s3 LIKE ima_file.ima34                         #No.FUN-680121 VARCHAR(9)
DEFINE ss	ARRAY[100] OF LIKE type_file.chr1000        #No.FUN-680121 #No.FUN-550067
#DEFINE ss1      ARRAY[120] OF LIKE type_file.chr1000        #No.FUN-680121 #NO.TQC-5B0125
#DEFINE ss2      ARRAY[120] OF LIKE type_file.chr1000        # No.FUN-7C0080 add
#DEFINE ss3      ARRAY[120] OF LIKE type_file.chr1000        # No.FUN-7C0080 add
DEFINE ss1      ARRAY[120] OF LIKE sfb_file.sfb08           # No.CHI-B50006 add
DEFINE ss2      ARRAY[120] OF LIKE sfb_file.sfb01           # No.CHI-B50006 add
DEFINE ss3      ARRAY[120] OF LIKE sfb_file.sfb05           # No.CHI-B50006 add 
DEFINE g_rec_b	LIKE type_file.num10                 #No.FUN-680121 INTEGER
DEFINE tm  RECORD                                    # Print condition RECORD
		order_sw LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)
		QVL_flag LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)
                sub_flag LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)   #No.MOD-940418 add
		trans    LIKE type_file.chr1,        #No.FUN-930064 VARCHAR(1)   
                imm01    LIKE imm_file.imm01,        #No.FUN-930064 
		more     LIKE type_file.chr1         #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
 
DEFINE   g_cnt           LIKE type_file.num10        #No.FUN-680121 INTEGER
DEFINE   g_wc2           STRING                      #No.MOD-780064 add
DEFINE   l_wc            STRING                      #No.FUN-7C0080
DEFINE   g_i             LIKE type_file.num5         #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_sql           STRING                      #No.FUN-7C0080  add
DEFINE  l_table1         STRING                      #No.FUN-7C0080  add
DEFINE  l_table          STRING                      #No.FUN-7C0080  add
DEFINE  g_str            STRING                      #No.FUN-7C0080  add
DEFINE  l_table2         STRING                      #No.FUN-7C0080  add
DEFINE  l_table3         STRING                      #No.FUN-7C0080  add
DEFINE  g_success        LIKE type_file.chr1         #No.FUN-7C0080  add
DEFINE  g_imm            RECORD LIKE imm_file.*      #No.FUN-930064  add
DEFINE  g_imn            RECORD LIKE imn_file.*      #No.FUN-930064  add
DEFINE  g_msg            LIKE type_file.chr1000      #No.FUN-930064  add
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123
   LET g_sql = "order1.type_file.chr1,",
               "order2.ima_file.ima23,",
               "ima23.ima_file.ima23,",                                         
               "sfa03.sfa_file.sfa03,",                                         
               "ima02.ima_file.ima02,",                                         
               "sfa05.sfa_file.sfa05,",                                         
#              "ima262.ima_file.ima262,",        #NO.FUN-A20044 
               "avl_stk.type_file.num15_3,",     #NO.FUN-A20044
              #No:CHI-B50006 ---- modify --- start ---
               "ss2_1.sfb_file.sfb01,",
               "ss3_1.sfb_file.sfb05,",
               "ss1_1.sfb_file.sfb08,",
               "ss2_2.sfb_file.sfb01,",
               "ss3_2.sfb_file.sfb05,",
               "ss1_2.sfb_file.sfb08"
              #"ss2_1.type_file.chr1000,",
              #"ss3_1.type_file.chr1000,",
              #"ss1_1.type_file.chr1000,",
              #"ss2_2.type_file.chr1000,",
              #"ss3_2.type_file.chr1000,",
              #"ss1_2.type_file.chr1000"
              #No:CHI-B50006 ---- modify ---  end  ---
                                         
   LET l_table = cl_prt_temptable('asf203',g_sql) CLIPPED
   IF  l_table = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "order1.type_file.chr1,",
              #No:CHI-B50006 ---- modify --- start ---
               "ss2.sfb_file.sfb01,",
               "ss3.sfb_file.sfb05,",
               "ss1.sfb_file.sfb08"
              #"ss2.type_file.chr1000,",
              #"ss3.type_file.chr1000,",
              #"ss1.type_file.chr1000"
              #No:CHI-B50006 ---- modify ---  end  ---

   LET l_table1 = cl_prt_temptable('asf203_1',g_sql) CLIPPED
   IF  l_table1 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "sfa03.sfa_file.sfa03,",
               "bml04.type_file.chr1000"                
   LET l_table2 = cl_prt_temptable('asf203_2',g_sql) CLIPPED
   IF  l_table2 = -1 THEN EXIT PROGRAM END IF
   
   LET g_sql = "sfa03.sfa_file.sfa03,",
               "temp2.type_file.chr1000,",
               "ima02.ima_file.ima02,",
               "temp3.type_file.chr1000"
          
   LET l_table3 = cl_prt_temptable('asf203_3',g_sql) CLIPPED
   IF  l_table3 = -1 THEN EXIT PROGRAM END IF
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_rep_user = ARG_VAL(7)
   LET g_rep_clas = ARG_VAL(8)
   LET g_template = ARG_VAL(9)
   LET g_rpt_name = ARG_VAL(10)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL r203_tm(0,0)                       # If background job sw is off
   ELSE
       CALL r203()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r203_tm(p_row,p_col)
DEFINE   li_result   LIKE type_file.num5              #No.FUN-550067        #No.FUN-680121 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sfc		RECORD LIKE sfc_file.*,
          l_sfd		RECORD LIKE sfd_file.*,
          l_cmd   	  LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
          l_exit_sw       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,          #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5           #可刪除否        #No.FUN-680121 SMALLINT
   DEFINE l_sfci          RECORD LIKE sfci_file.*       #NO.FUN-7B0018
   DEFINE l_cnt           LIKE type_file.num5           #No.MOD-B30028
   DEFINE l_cnt1          LIKE type_file.num5           #MOD-C60013 add
   DEFINE l_cnt2          LIKE type_file.num5           #MOD-C60013 add
   DEFINE i               LIKE type_file.num5           #MOD-C60013 add
   DEFINE l_flag          LIKE type_file.chr1           #MOD-C60013 add
   DEFINE l_j             LIKE type_file.num5           #MOD-D30119
 
   IF p_row = 0 THEN LET p_row = 3 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 3 LET p_col = 20
   ELSE LET p_row = 3 LET p_col = 10
   END IF
   OPEN WINDOW r203_w AT p_row,p_col
        WITH FORM "asf/42f/asfr203"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.order_sw= 'Y'
   LET tm.QVL_flag= 'N'
   LET tm.sub_flag= '1'    #No.MOD-940418 add 
   LET tm.trans = 'N'                 #No.FUN-930064 add
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   INPUT BY NAME g_sfc01 WITHOUT DEFAULTS
     ON ACTION locale
          CALL cl_dynamic_locale()                  #No.TQC-770019 add
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         LET g_action_choice = "locale"
 
 
      AFTER FIELD g_sfc01
         IF not cl_null(g_sfc01) AND cl_null(g_sfc01[g_no_sp,g_no_ep]) THEN
            CALL s_get_doc_no(g_sfc01) RETURNING g_t1
            CALL s_check_no("asf",g_t1,"","8","","","")
                 RETURNING li_result,g_t1
            IF (NOT li_result) THEN
               NEXT FIELD g_sfc01
            END IF
         END IF
	 FOR g_cnt=1 TO 100 LET g_no[g_cnt]=NULL END FOR
         IF g_sfc01[g_no_sp,g_no_ep] <> ' ' THEN
            SELECT sfc01 FROM sfc_file WHERE sfc01=g_sfc01
            
	    DECLARE r203_sfd_c CURSOR FOR
	       SELECT * FROM sfd_file WHERE sfd01=g_sfc01 ORDER BY 1
	    LET g_cnt=1
	    FOREACH r203_sfd_c INTO l_sfd.*
	       IF l_sfd.sfd03 IS NULL THEN CONTINUE FOREACH END IF
               FOR g_i=1 TO 100
                  IF g_no[g_i]=l_sfd.sfd03 THEN CONTINUE FOREACH END IF
               END FOR
	       LET g_no[g_cnt]=l_sfd.sfd03
	       LET g_cnt=g_cnt+1
	       IF g_cnt>100 THEN EXIt FOREACH END IF
	    END FOREACH
	    LET g_rec_b=g_cnt-1
         END IF
 
      ON ACTION controlp
         CASE
            WHEN INFIELD(g_sfc01)
               CALL q_smy(FALSE,FALSE,g_t1,'ASF','8') RETURNING g_t1 
               LET g_sfc01 = g_t1
               DISPLAY BY NAME g_sfc01
         END CASE

      #FUN-B60135-add-str--
      ON ACTION pbi_no
         CASE
             WHEN INFIELD(g_sfc01)
                CALL cl_init_qry_var()
                LET g_qryparam.form ="q_sfc02"
                LET g_qryparam.default1 = g_sfc01
                CALL cl_create_qry() RETURNING g_sfc01
                DISPLAY g_sfc01 TO g_sfc001
                NEXT FIELD g_sfc01
         END CASE
      #FUN-B60135-add-end--


      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW r203_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
 
   WHILE TRUE
      LET l_exit_sw='y'
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_no WITHOUT DEFAULTS FROM s_no.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)

       #MOD-CB0170---add---S
        AFTER FIELD sfb01
           LET l_cnt1=ARR_COUNT()
           FOR i=1 to l_cnt1
              IF NOT cl_null(g_no[i]) THEN
                 LET l_cnt2 = 0
                 SELECT COUNT(*) INTO l_cnt2 FROM sfb_file
                  WHERE sfb01=g_no[i]
                    AND sfbacti='Y'
                    AND sfb04 IN ('2','3')
                    AND sfb87 = 'Y'
                 IF l_cnt2=0 THEN
                    CALL cl_err(g_no[i],'asf-608',1)
                    NEXT FIELD sfb01
                 END IF
                 #MOD-D30119---begin
                 FOR l_j = 1 TO l_cnt1
                    IF g_no[i] = g_no[l_j] AND i <> l_j THEN
                       CALL cl_err(g_no[i],'asf-409',1)
                       NEXT FIELD sfb01
                    END IF 
                 END FOR 
                 #MOD-D30119---end
              END IF
           END FOR
       #MOD-CB0170---add---E

       #MOD-C60013 str add-----
        AFTER INPUT
          IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              INITIALIZE g_no TO NULL
              CLEAR FORM
              EXIT INPUT
          END IF

          LET l_cnt1=ARR_COUNT()
          LET l_flag='N'
          CALL s_showmsg_init()
          FOR i=1 to l_cnt1
             #新增狀態時,WO的PBI必需為空;
              IF NOT cl_null(g_sfc01) AND cl_null(g_sfc01[g_no_sp,g_no_ep]) THEN  #MOD-CB0170 add
                 LET l_cnt2 = 0
                #SELECT COUNT(*) INTO l_cnt2 FROM sfd_file WHERE sfd03= g_no[i]   #MOD-CB0170 mark
                 SELECT COUNT(*) INTO l_cnt2 FROM sfb_file       #MOD-CB0170 add
                  WHERE sfb01 = g_no[i] AND sfb85 != ''          #MOD-CB0170 add
                 IF l_cnt2 >0 THEN
                    CALL s_errmsg('sfb01',g_no[i],'','asf-276',1)
                    LET l_flag = 'Y'
                 END IF
             #MOD-CB0170 add---S
             #若非新增,WO的PBI必需與g_sfc01相同
              ELSE
                 IF NOT cl_null(g_sfc01) THEN
             #MOD-CB0170 add---E
                    #CHI-C60023---begin
                    LET l_cnt2 = 0
                    SELECT count(*) INTO l_cnt2 FROM sfb_file
                     WHERE sfb01=g_no[i]
                       AND sfbacti='Y'
                       AND sfb04 IN ('2','3')  #FUN-CB0102
                       AND sfb87 = 'Y'  #FUN-CB0102
                       #AND sfb87 = 'N'  #FUN-CB0102
                       AND sfb85 = g_sfc01    #MOD-CB0170 add
                    IF l_cnt2 = 0 THEN
                       CALL s_errmsg('sfb01',g_no[i],'','asf-608',1)
                       LET l_flag = 'Y' 
                    END IF 
                    #CHI-C60023---end
                 END IF   #MOD-CB0170 add
              END IF      #MOD-CB0170 add
          END FOR
          CALL s_showmsg()
          IF l_flag = 'Y' THEN CONTINUE INPUT END IF
       #MOD-C60013 end add----- 

        ON ACTION gen_detail
           CALL r203_gen()
           LET l_exit_sw='n' EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      END INPUT
      LET g_rec_b=ARR_COUNT()
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW r203_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      IF l_exit_sw='y' THEN EXIT WHILE END IF
   END WHILE
 
   LET g_success = 'Y'      #No.FUN-7C0080
   BEGIN WORK      #No:7829
   IF not cl_null(g_sfc01) AND cl_null(g_sfc01[g_no_sp,g_no_ep]) THEN
      CALL s_auto_assign_no("asf",g_sfc01,TODAY,"8","","","","","")
         RETURNING li_result,g_sfc01
      IF (NOT li_result) THEN
         CALL cl_err('','mfg-059',1)    #No:7829
         LET g_success='N'    #NO.FUN-7C0080 add
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_sfc01
   END IF

#TQC-B90087 --begin--
   LET l_cnt = 0
   SELECT COUNT(*) INTO l_cnt FROM sfc_file
    WHERE sfc01 = g_sfc01
#TQC-B90087 --end--

   IF NOT cl_null(g_sfc01) AND l_cnt = 0 THEN    #TQC-B90087 add l_cnt
      LET l_sfc.sfc01=g_sfc01
      LET l_sfc.sfcacti='Y'
      LET l_sfc.sfcuser=g_user
      LET l_sfc.sfcgrup=g_grup
      LET l_sfc.sfcdate=TODAY
      LET l_sfc.sfcoriu = g_user      #No.FUN-980030 10/01/04
      LET l_sfc.sfcorig = g_grup      #No.FUN-980030 10/01/04
     #LET l_sfd.sfd09='2'  #CHI-C60023  #FUN-CB0102
      LET l_sfd.sfd09='1'  #FUN-CB0102
      INSERT INTO sfc_file VALUES(l_sfc.*)
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","sfc_file",l_sfc.sfc01,"",SQLCA.sqlcode,"","",0)    #No.FUN-660128
         LET g_success = 'N'     #NO.FUN-7C0080 add
      END IF
      IF NOT s_industry('std') THEN
         INITIALIZE l_sfci.* TO NULL
         LET l_sfci.sfci01 = l_sfc.sfc01
         #Add No.MOD-B30028
         SELECT COUNT(*) INTO l_cnt FROM sfci_file
          WHERE sfci01 = l_sfci.sfci01
         IF l_cnt = 0 THEN
         #End Add No.MOD-B30028
            IF NOT s_ins_sfci(l_sfci.*,'') THEN
               LET g_success = 'N'  #No.FUN-830132 add
            END IF
         END IF #Add No.MOD-B30028
      END IF
      DELETE FROM sfd_file WHERE sfd01=g_sfc01
      FOR g_cnt=1 TO g_rec_b
         LET l_sfd.sfd01=g_sfc01
         LET l_sfd.sfd02=g_cnt
         LET l_sfd.sfd03=g_no[g_cnt]
         LET l_sfd.sfdconf='N' #TQC-B60064
         LET  l_sfd.sfduser = g_user        #FUN-D10127
         LET  l_sfd.sfdgrup = g_grup        #FUN-D10127
         LET  l_sfd.sfddate = g_today       #FUN-D10127
         LET  l_sfd.sfdacti ='Y'            #FUN-D10127
         LET  l_sfd.sfdoriu = g_user        #FUN-D10127
         LET  l_sfd.sfdorig = g_grup        #FUN-D10127
         INSERT INTO sfd_file VALUES(l_sfd.*)
         UPDATE sfb_file SET sfb85=l_sfd.sfd01 WHERE sfb01=l_sfd.sfd03    #MOD-C60013 add
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","sfd_file",l_sfd.sfd01,l_sfd.sfd02,SQLCA.sqlcode,"","",0)    #No.FUN-660128
         LET g_success = 'N'     #NO.FUN-7C0080 add
            EXIT FOR
         END IF
      END FOR
   END IF
   IF g_success= 'N' THEN
      ROLLBACK WORK
   ELSE
      COMMIT WORK
   END IF
   CONSTRUCT BY NAME g_wc2 ON sfa08,ima23
   
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
   
   END CONSTRUCT
   IF cl_null(g_wc2) THEN LET g_wc2 = '1=1' END IF
 
   INPUT BY NAME tm.order_sw,tm.QVL_flag,tm.sub_flag,tm.trans,tm.imm01,       #No.MOD-940418 add    #FUN-930064
                 tm.more WITHOUT DEFAULTS
     #--------------No:TQC-A50156 add                                           
      BEFORE INPUT                                                              
         CALL r203_set_entry()                                                  
         CALL r203_set_no_entry()                                               
     #--------------No:TQC-A50156 end 
      AFTER FIELD sub_flag
         IF tm.sub_flag NOT MATCHES '[123]' THEN
            NEXT FIELD sub_flag
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES '[YN]' THEN
            NEXT FIELD more
         END IF
         IF tm.more = 'Y'
            THEN CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
     ON CHANGE trans   #No:TQC-A50156 modify 
        IF tm.trans NOT MATCHES'[YNyn]' THEN
           NEXT FIELD trans
       #--------------No:TQC-A50156 add                                         
        ELSE                                                                    
           IF tm.trans MATCHES'[Nn]' THEN LET tm.imm01 = NULL END IF            
           CALL r203_set_entry()                                                
           CALL r203_set_no_entry()                                             
           DISPLAY BY NAME tm.imm01                                             
       #--------------No:TQC-A50156 end
        END IF 
     AFTER FIELD imm01
        IF NOT cl_null(tm.imm01) THEN
           CALL s_check_no("aim",tm.imm01,"","4","imm_file","imm01","")  
               RETURNING li_result,tm.imm01
           IF (NOT li_result) THEN                                                                                              
              NEXT FIELD imm01                                                                                                  
           END IF 
        END IF  
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON ACTION controlp
        CASE WHEN INFIELD(imm01)
                  LET g_t1 = s_get_doc_no(tm.imm01)
                  CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1 
                  LET tm.imm01 = g_t1
                  DISPLAY BY NAME tm.imm01
                  NEXT FIELD imm01
        END CASE 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW r203_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr203'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr203','9031',1)
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.order_sw CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
         CALL cl_cmdat('asfr203',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r203_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r203()
   ERROR ""
END WHILE
   CLOSE WINDOW r203_w
END FUNCTION
 
#-------------------No:TQC-A50156 add                                           
 FUNCTION r203_set_entry()                                                      
    CALL cl_set_comp_entry("imm01",TRUE)                                        
 END FUNCTION                                                                   
                                                                                
 FUNCTION r203_set_no_entry()                                                   
    IF tm.trans NOT MATCHES '[Yy]' THEN                                         
       CALL cl_set_comp_entry("imm01",FALSE)                                    
    END IF                                                                      
 END FUNCTION                                                                   
#-------------------No:TQC-A50156 end 

FUNCTION r203_gen()
   DEFINE l_sql         STRING         #MOD-810138
   DEFINE l_sfb01       LIKE sfb_file.sfb01        #No.FUN-550067
   DEFINE i,j		LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   OPEN WINDOW r203_gen_w AT 10,25
        WITH FORM "asf/42f/asfr203a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("asfr203a")
   CONSTRUCT BY NAME l_wc ON sfb01,sfb81,sfb05,sfb82
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
   END CONSTRUCT
 
   CLOSE WINDOW r203_gen_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   LET l_sql="SELECT sfb01 FROM sfb_file WHERE ",l_wc CLIPPED,
             "   AND sfb04 <> '8' ",   #MOD-8A0214 
             #"   AND sfb08>sfb081 AND sfb87!='X' "   #CHI-C60023
             #"   AND sfb08>sfb081 AND sfb87 = 'N' ",  #CHI-C60023 #FUN-CB0102
             #"   AND sfbacti = 'Y' "  #CHI-C60023 #FUN-CB0102
             "   AND sfb08>sfb081 AND sfb87 = 'Y' ",  #FUN-CB0102
             "   AND sfbacti = 'Y' AND sfb04 IN ('2','3') "  #FUN-CB0102
             
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
 
   PREPARE r203_gen_p FROM l_sql
   DECLARE r203_gen_c CURSOR FOR r203_gen_p
   FOREACH r203_gen_c INTO l_sfb01
      FOR i=1 TO 100
         IF g_no[i]=l_sfb01 THEN CONTINUE FOREACH END IF
      END FOR
      FOR i=1 TO 100
         IF g_no[i] IS NULL THEN LET g_no[i]=l_sfb01 CONTINUE FOREACH END IF
      END FOR
   END FOREACH
   FOR i=100 TO 1 STEP -1 IF g_no[i] IS NOT NULL THEN EXIT FOR END IF END FOR
   LET g_rec_b=i
   CALL SET_COUNT(g_rec_b)
END FUNCTION
 
FUNCTION r203()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sfc01   LIKE type_file.chr30,         #No.MOD-940418 add
          l_sql     STRING,    #MOD-810138
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_cnt     LIKE type_file.num5,          #No.MOD-780064 add
          l_sfb	    RECORD LIKE sfb_file.*,
          l_temp1   LIKE type_file.chr1000,       #No.FUN-7C0080 add 
          l_temp2   LIKE type_file.chr1000,       #No.FUN-7C0080 add
          l_temp3   LIKE type_file.chr1000,       #No.FUN-7C0080 add
          l_bmd08	LIKE bmd_file.bmd08,                  #No.FUN-7C0080 add
          l_ima02	LIKE ima_file.ima02,                  #No.FUN-7C0080 add
#         l_qty,l_ima262	LIKE ima_file.ima26,          #No.FUN-7C0080 add
          l_qty,l_avl_stk LIKE type_file.num15_3, ###GP5.2  #NO.FUN-A20044
          l_bmd02		LIKE bmd_file.bmd02,          #No.FUN-7C0080 add
          l_bmd04		LIKE bmd_file.bmd04,          #No.FUN-7C0080 add
          l_bmd07		LIKE bmd_file.bmd07,          #No.FUN-7C0080 add
          l_bml		RECORD LIKE bml_file.*,               #No.FUN-7C0080 add
          sr            RECORD order1   LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                               ima23	LIKE ima_file.ima23,
                               sfa03	LIKE sfa_file.sfa03,
                               sfa26	LIKE sfa_file.sfa26,
                               ima02	LIKE ima_file.ima02,
                               sfa12	LIKE sfa_file.sfa12,
                               sfa05	LIKE sfa_file.sfa05,
                               order2   LIKE ima_file.ima23    #No.MOD-780064 add
                        END RECORD
    DEFINE l_ima108     LIKE ima_file.ima108
    DEFINE l_ima35      LIKE ima_file.ima35
    DEFINE l_ima36      LIKE ima_file.ima36
    DEFINE l_sfa30      LIKE sfa_file.sfa30
    DEFINE l_sfa31      LIKE sfa_file.sfa31
    DEFINE l_sfa29      LIKE sfa_file.sfa29      #MOD-B60003 add
    DEFINE li_result    LIKE type_file.num5
    DEFINE l_ima23      LIKE ima_file.ima23   #TQC-9C0179
    DEFINE l_n1         LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
    DEFINE l_n2         LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
    DEFINE l_n3         LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
    DEFINE l_imni       RECORD LIKE imni_file.*  #FUN-B70074
 
    BEGIN WORK      
    LET g_success = 'Y'
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,                                                                 
               " VALUES(?, ?, ?, ?)"                                                                                                         
     PREPARE insert_prep1 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep1:',status,1)                                                                                        
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
        EXIT PROGRAM                                                                                                                 
     END IF
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                 
                 " VALUES(?, ?)"                                                                                             
     PREPARE insert_prep2 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep2:',status,1)
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD                                                                                        
        EXIT PROGRAM                                                                                                                 
     END IF 
     
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,                                                                 
                 " VALUES(?, ?, ?, ?)"                                                                                             
     PREPARE insert_prep3 FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep3:',status,1)     
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD                                                                                   
        EXIT PROGRAM                                                                                                                 
     END IF
 
     LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                 
                 " VALUES(?,?,?,?,?, ?,?,?,?,?,?,?,?)"                                                                                             
     PREPARE insert_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('insert_prep:',status,1)                                      
        CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD                                                  
        EXIT PROGRAM                                                                                                                 
     END IF
     CALL cl_del_data(l_table)
     CALL cl_del_data(l_table1)
     CALL cl_del_data(l_table2)
     CALL cl_del_data(l_table3)
     #MOD-D20132---begin
     LET g_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,                                                                 
                 " WHERE sfa03 = ? AND bml04 = ? " 
     PREPARE tmp_chk_prep FROM g_sql                                                                                                  
     IF STATUS THEN                                                                                                                   
        CALL cl_err('tmp_chk_prep:',status,1)   
        CALL cl_used(g_prog,g_time,2) RETURNING g_time         
        EXIT PROGRAM                                                                                                                 
     END IF 
     #MOD-D20132---end
      LET l_chr = 'N'   #No:TQC-A50156 add 
      FOR g_cnt=1 TO g_rec_b
         IF g_no[g_cnt] IS NULL THEN CONTINUE FOR END IF
         IF g_cnt=1 THEN
           #LET s1="工單編號:" LET s2="成品編號:" LET s3="發料套數:"
            LET s1=g_x[13]
            LET s2=g_x[14]
            LET s3=g_x[15]
         ELSE  
            LET s1='         ' LET s2='         ' LET s3='         '
         END IF
         SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=g_no[g_cnt]
	 LET g_part[g_cnt]=l_sfb.sfb05
         LET ss[g_cnt]= s1,g_no[g_cnt],10 SPACES,
                        s2,l_sfb.sfb05,1 SPACES,
                        s3

         LET ss1[g_cnt]=l_sfb.sfb08-l_sfb.sfb081   #TQC-B90095  #MOD-CB0170 remark
        #LET ss1[g_cnt]=l_sfb.sfb081               #TQC-B90095  #MOD-CB0170 mark
         LET ss2[g_cnt] = g_no[g_cnt]
         LET ss3[g_cnt] = l_sfb.sfb05
         IF ss[g_cnt] IS NOT NULL THEN  
            EXECUTE insert_prep1 USING ' ',ss2[g_cnt],ss3[g_cnt],ss1[g_cnt] 
         END IF  
      END FOR
     FOR g_cnt=1 TO 100
         LET l_sql = " SELECT ' ',ima23,sfa03,sfa26,ima02, ",
                    #" sfa12,sfa05-sfa06,' ',sfa30,sfa31 ",      #FUN-930064 add  #FUN-A60027
                     " sfa12,SUM(sfa05-sfa06),' ',sfa30,sfa31,sfa29 ",  #FUN-A60027  #MOD-B60003 add sfa29   #TQC-B90095  #MOD-CB0170 remark
                    #" sfa12,SUM(sfa06),' ',sfa30,sfa31,sfa29 ",        #TQC-B90095  #MOD-CB0170 mark
                     "   FROM sfa_file,ima_file ",
                     "  WHERE sfa01='",g_no[g_cnt],"' AND sfa03=ima01 ",
                     "    AND sfa05>sfa06 ",                           #TQC-B90095   #MOD-CB0170 remark
                     "    AND ",g_wc2 CLIPPED,    #FUN-A60027
                     "  GROUP BY ima23,sfa03,sfa26,ima02,sfa12,sfa30,sfa31,sfa29 "    #FUN-A60027 #TQC-B60064
 
         PREPARE r203_p1 FROM l_sql
         DECLARE r203_sfa_c CURSOR FOR r203_p1
         FOREACH r203_sfa_c INTO sr.*,l_sfa30,l_sfa31,l_sfa29        #FUN-930064  #MOD-B60003 add l_sfa29
            IF tm.order_sw='Y' THEN 
               LET sr.order2=sr.ima23
            END IF  
 
            IF tm.QVL_flag='Y' THEN
               DECLARE r203_QVL_c CURSOR FOR
                  SELECT * FROM bml_file
                       WHERE bml01 = sr.sfa03
                       ORDER BY bml03
               LET l_cnt = 1     #No.MOD-940418 add
               LET l_temp1 = NULL
               FOREACH r203_QVL_c INTO l_bml.*
                    FOR g_i=1 TO 100
                      #IF l_bml.bml02='ALL' OR l_bml.bml02=g_part[g_i] THEN         #MOD-B60003 mark
                       IF l_bml.bml02='ALL' OR l_bml.bml02=l_sfa29 THEN             #MOD-B60003 add
                          EXIT FOR
                       END IF
                    END FOR
                    IF g_i=100 THEN CONTINUE FOREACH END IF
                    #IF l_cnt=1 THEN LET l_temp1 = l_temp1,'       QVL:' END IF   #No.MOD-940418 add  #MOD-D20132
                    #LET l_temp1= l_temp1 CLIPPED,l_bml.bml04,','  #MOD-D20132
                    #MOD-D20132---begin
                    IF l_cnt=1 THEN
                       LET l_temp1 = l_temp1,'       QVL:',l_bml.bml04
                    ELSE
                       LET l_temp1= l_temp1 CLIPPED,',',l_bml.bml04
                    END IF
                    #MOD-D20132---end
                    LET l_cnt = l_cnt+1
                    IF (l_cnt MOD 8) = 0 THEN
                       EXECUTE tmp_chk_prep USING sr.sfa03,l_temp1 INTO l_cnt  #MOD-D20132
                       IF l_cnt = 0 THEN   #MOD-D20132
                          EXECUTE insert_prep2 USING sr.sfa03,l_temp1
                       END IF  #MOD-D20132   
                       LET l_temp1 = NULL
                       LET l_cnt = 1
                    END IF
               END FOREACH
                   IF (l_cnt MOD 8) != 0 THEN
                       EXECUTE tmp_chk_prep USING sr.sfa03,l_temp1 INTO l_cnt  #MOD-D20132
                       IF l_cnt = 0 THEN   #MOD-D20132
                          EXECUTE insert_prep2 USING sr.sfa03,l_temp1
                       END IF  #MOD-D20132 
                   END IF
            END IF
 
 #           LET l_ima262=NULL
 #          SELECT ima262 INTO l_ima262 FROM ima_file WHERE ima01=sr.sfa03
            LET l_avl_stk = NULL
            CALL s_getstock(sr.sfa03,g_plant) RETURNING  l_n1,l_n2,l_n3     #NO.FUN-A20044
            LET l_avl_stk = l_n3                                            #NO.FUN-A20044               

           #MOD-B50238---add---start---
            LET l_qty = 0
            SELECT SUM(sfa05) INTO l_qty FROM sfa_file
             WHERE sfa01=g_no[g_cnt]
               AND sfa05 > sfa06 
               AND sfa03=sr.sfa03 
           #MOD-B50238---add---end---

            IF sr.sfa26 MATCHES '[123478]' AND      #FUN-A20037 add '7,8'
#             (tm.sub_flag='2' OR (tm.sub_flag='3' AND l_qty>l_ima262)) THEN   #No.MOD-940418 add
              (tm.sub_flag='2' OR (tm.sub_flag='3' AND l_qty>l_avl_stk)) THEN  #NO.FUN-A20044  
               DECLARE r203_SUB_c CURSOR FOR
#                 SELECT bmd02,bmd04,bmd07,bmd08, ima02,ima262 FROM bmd_file, ima_file  #NO.FUN-A20044 
                  SELECT bmd02,bmd04,bmd07,bmd08, ima02,0 FROM bmd_file, ima_file       #NO.FUN-A20044    
                     WHERE bmd01 = sr.sfa03 AND bmd04=ima01
                       AND bmdacti = 'Y'                                           #CHI-910021
#                    GROUP BY bmd02,bmd04,bmd07,bmd08,ima02,ima262                 #NO.FUN-A20044   
                     GROUP BY bmd02,bmd04,bmd07,bmd08,ima02                        #NO.FUN-A20044  
                     ORDER BY bmd04
               LET l_cnt=0
               FOREACH r203_SUB_c INTO l_bmd02,l_bmd04,l_bmd07,l_bmd08,
#                                l_ima02,l_ima262              #NO.FUN-A20044 
                                 l_ima02,l_avl_stk             #NO.FUN-A20044 
                  LET l_avl_stk = l_n3                           #MOD-D20165                
#                 IF l_ima262<=0 THEN CONTINUE FOREACH END IF  #NO.FUN-A20044 
                  IF l_avl_stk<=0 THEN CONTINUE FOREACH END IF #NO.FUN-A20044 
                  FOR g_i=1 TO 100
                     #IF l_bmd08='ALL' OR l_bmd08=g_part[g_i] THEN         #MOD-B60003 mark
                      IF l_bmd08='ALL' OR l_bmd08=l_sfa29 THEN             #MOD-B60003 add
                         EXIT FOR
                      END IF
                  END FOR
                  IF g_i>=100 THEN CONTINUE FOREACH END IF
                  LET l_cnt=l_cnt+1
                  LET l_temp2 = NULL
                  LET l_temp3 = NULL
                  IF l_bmd02=1 THEN LET l_temp2 = l_temp2,"       U:"; END IF
                  IF l_bmd02=2 THEN LET l_temp2 = l_temp2,"       S:"; END IF
                  LET l_temp2 = l_temp2,l_bmd04
#                 LET l_temp3 = l_ima262,' (',l_bmd08 CLIPPED,')'                  
                  LET l_temp3 = l_avl_stk,' (',l_bmd08 CLIPPED,')'
                  EXECUTE insert_prep3 USING sr.sfa03,l_temp2,l_ima02,l_temp3
               END FOREACH
            END IF
            LET l_ima23 = sr.ima23[1,6]   #TQC-9C0179
            EXECUTE insert_prep USING sr.order1,sr.order2,
#                   l_ima23,sr.sfa03,sr.ima02,sr.sfa05,l_ima262,        #TQC-9C0179
                    l_ima23,sr.sfa03,sr.ima02,sr.sfa05,l_avl_stk,  
                    ss2[1],ss3[1],ss1[1],ss2[2],ss3[2],ss1[2]
            IF tm.trans = 'Y' THEN   #自動產生調撥單 
               LET l_ima108 = NULL
               INITIALIZE g_imn.* TO NULL
               SELECT ima108 INTO l_ima108  FROM ima_file WHERE ima01 = sr.sfa03
               IF l_ima108 = 'Y' THEN
               #####產生調撥單單身
                  CALL s_auto_assign_no("aim",tm.imm01,g_today,"","imm_file","imm01",
                            "","","")
                       RETURNING li_result,g_imm.imm01  
                  IF (NOT li_result) THEN
                     CALL cl_err3("","imn_file","","","abm-621","","",1)   
                     LET g_success= 'N'
                     ROLLBACK WORK 
                  END IF
                  LET g_imn.imn01 = g_imm.imm01 
                  IF cl_null(l_sfa30) AND cl_null(l_sfa31) THEN
                     SELECT ima35,ima36 INTO l_ima35,l_ima36 FROM ima_file
                      WHERE ima01 = sr.sfa03
                     LET g_imn.imn15 = l_ima35
                     LET g_imn.imn16 = l_ima36
                  ELSE
                     LET g_imn.imn15 = l_sfa30
                     LET g_imn.imn16 = l_sfa31
                  END IF
                  SELECT MAX(imn02) INTO g_imn.imn02 FROM imn_file WHERE imn01 = g_imn.imn01  #No.TQC-A50156
                  IF cl_null(g_imn.imn02) THEN
                     LET g_imn.imn02 = 0
                  END IF 
                  LET g_imn.imn02 = g_imn.imn02+1
                  LET g_imn.imn03 = sr.sfa03
                  LET g_imn.imn04 = ' '
                  LET g_imn.imn05 = ' '
                  LET g_imn.imn06 = ' ' 
                  LET g_imn.imn10 = sr.sfa05
                  LET g_imn.imn20 = sr.sfa12
                  LET g_imn.imn22 = g_imn.imn10
                  SELECT sfb98 INTO g_imn.imn9302 FROM sfb_file
                   WHERE sfb01 = g_no[g_cnt]
                  SELECT ima24 INTO g_imn.imn29 FROM ima_file
                   WHERE ima01 = sr.sfa03
                  INSERT INTO imn_file VALUES(g_imn.*)
                  IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
                     LET g_success = 'N'
                     CALL cl_err3("ins","imn_file",g_imn.imn01,"",SQLCA.sqlcode,"","",0)
                     CONTINUE FOREACH
                  ELSE                  #No:TQC-A50156 add                              
                  #FUN-B70074-add-str--
                  IF NOT s_industry('std') THEN 
                     INITIALIZE l_imni.* TO NULL
                     LET l_imni.imni01 = g_imn.imn01
                     LET l_imni.imni02 = g_imn.imn02
                     IF NOT s_ins_imni(l_imni.*,g_imn.imnplant) THEN 
                        LET g_success = 'N'
                        CONTINUE FOREACH
                     END IF 
                  END IF
                  #FUN-B70074-add-end--
                     LET l_chr = 'Y'    #No:TQC-A50156 add
                  END IF 
               END IF 
            END IF  
         END FOREACH
     END FOR
     IF tm.trans = 'Y' AND l_chr = 'Y' THEN  #No:TQC-A50156 modify
        LET g_imm.imm02 = g_today
        LET g_imm.immconf = 'N'
        LET g_imm.imm03 = 'N'
        LET g_imm.imm10 = '1'
        LET g_imm.immoriu = g_user      #No.FUN-980030 10/01/04
        LET g_imm.immorig = g_grup      #No.FUN-980030 10/01/04
        #FUN-A60034--add---str---
        #FUN-A70104--add---str---
        LET g_imm.immmksg = g_smy.smyapr #是否簽核
        LET g_imm.imm15 = '0'            #簽核狀況
        LET g_imm.imm16 = g_user         #申請人
        #FUN-A70104--add---end---
        #FUN-A60034--add---end---
        INSERT INTO imm_file VALUES(g_imm.*)
        IF SQLCA.SQLCODE OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_success = 'N'
           CALL cl_err3("ins","immfile",g_imm.imm01,"",SQLCA.sqlcode,"","",0)  
        END IF 
     END IF 
 
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 "SELECT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01=g_prog            
     IF g_zz05='Y' THEN
         CALL cl_wcchp(l_wc,'sfb01,sfb81,sfb05,sfb82')                          
              RETURNING l_wc
     ELSE
        LET l_wc=""
     END IF
     LET l_sfc01 = "PBI:",g_sfc01 CLIPPED
     LET g_str=l_wc,";",l_sfc01,";",tm.order_sw
     LET l_sfc01 = ''
     LET g_sfc01 = ''
     CALL cl_prt_cs3('asfr203','asfr203',g_sql,g_str)
     IF g_success = 'Y' THEN                                                                                                        
        COMMIT WORK                                                                                                                 
        IF tm.trans MATCHES'[Yy]' AND l_chr = 'Y' THEN   #No:TQC-A50156 add 
           LET g_msg="aimt324 '",g_imm.imm01,"'"                                                                                       
           CALL cl_cmdrun_wait(g_msg)                                                                                                  
        END IF   #No:TQC-A50156 add
     ELSE                                                                                                                           
        ROLLBACK WORK                                                                                                               
     END IF
END FUNCTION
#No.FUN-9C0072 精簡程式碼

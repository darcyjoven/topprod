# Prog. Version..: '5.30.08-13.07.05(00000)'     #
#
# Pattern name...: asfg201.4gl
# Descriptions...: 工單料表列印
# Modify.........: 97/08/12 By Roger
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: No.MOD-4A0238 04/10/18 By Smapmin 放寬ima02
# Modify.........: No.MOD-4C0102 04/12/16 By ching  l_exit_sw錯誤
# Modify.........: NO.FUN-510040 05/02/03 By Echo 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.FUN-550124 05/05/30 By echo 新增報表備註
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-580242 05/09/12 By Nicola PAGE LENGTH g_line 改為g_page_line
# Modify.........: NO.FUN-5B0015 05/11/01 BY yiting 將料號/品名/規格 欄位設成[1,xx] 將 [1,xx]清除後加CLIPPED
# Modify.........: No.TQC-5B0143 05/11/23 By Rosayu 1.自行輸入工單後按確定無法跳離會被卡住
#                                                   2.自動產生只會產生一筆工單資料,asfr203會產生多筆工單資料
# Modify.........: No.TQC-630105 06/03/14 By Joe 單身筆數限制
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: No.FUN-710082 07/01/30 By day 報表輸出至Crystal Reports功能
# Modify.........: No.TQC-730088 07/03/26 By Nicole 增加CR參數
# Modify.........: No.TQC-730022 07/03/27 By rainy 背景傳條件
# Modify.........: No.FUN-750060 07/05/15 By Sarah Input無法輸入條件(工單單號以下欄位)
# Modify.........: No.MOD-780063 07/12/17 By pengu 1.條件選項作業編號與倉管員有輸入資料但都沒有作篩選
#                                                  2.應依倉管員排序沒打勾時，報表中的倉管員沒印出來
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60027 10/06/10 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.MOD-B30028 11/03/04 By zhangll 修正插入sfci_file,系统异常当出问题
# Modify.........: No:MOD-B50060 11/05/09 By sabrina g201()時要判斷g_wc2是否為null
# Modify.........: No:TQC-B60064 11/06/14 By jan 補LET l_sfd.sfdconf = 'N'
# Modify.........: No:TQC-B70168 11/07/21 By guoch 将4gl中的名称与rpt中的名称对应
# Modify.........: No.FUN-B60135 11/08/12 By xianghui PBI No.提供開窗=>提供開"單別"和"單據編碼"的功能 
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.TQC-C60146 12/06/19 By fengrui 判斷不可是已存在sfd_file單身的非本張PBI單的工單號碼,並回寫到工單sfb85
# Modify.........: No.TQC-C80084 12/08/14 By chenjing 修改工單料表列印後臺報錯信息
# Modify.........: No.CHI-C60023 12/08/20 By bart 新增欄位-資料類別
# Modify.........: No.MOD-C90245 12/10/12 By Elise 修改AFTER FIELD sfd03中CHI-C60023修改的sql條件
# Modify.........: No:MOD-CB0170 13/01/07 By Elise PBI修改
# Modify.........: No:FUN-D10127 13/03/15 By Alberti 增加sfduser,sfdgrup,sfdmodu,sfddate,sfdacti
# Modify.........: No:TQC-D70080 13/07/23 By yangtt CR轉GRW

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE g_sfc01	LIKE sfc_file.sfc01                      #No.FUN-550067
DEFINE g_no	ARRAY[100] OF LIKE sfd_file.sfd03        #No.FUN-680121 VARCHAR(16)#No.FUN-550067
DEFINE g_part	ARRAY[100] OF LIKE sfb_file.sfb05        #No.FUN-680121 VARCHAR(40)#No.FUN-550067
DEFINE g_sfa08  LIKE sfa_file.sfa08           #No.MOD-780063 add
DEFINE g_ima23  LIKE ima_file.ima23           #No.MOD-780063 add
DEFINE g_t1	LIKE oay_file.oayslip                    #No.FUN-550067        #No.FUN-680121 VARCHAR(5)
DEFINE g_rec_b	LIKE type_file.num10                     #No.FUN-680121 INTEGER
DEFINE tm       RECORD           # Print condition RECORD
                #wc              STRING,                       #TQC-730022 add   #FUN-750060 mark
                #------No.MOD-780063 mark
                #b_seq		LIKE sfa_file.sfa08,          #No.FUN-680121 VARCHAR(6)
                #e_seq		LIKE sfa_file.sfa08,          #No.FUN-680121 VARCHAR(6)
                #b_keeper	LIKE ima_file.ima23,          #No.FUN-680121 VARCHAR(6)
                #e_keeper	LIKE ima_file.ima23,          #No.FUN-680121 VARCHAR(6)
                #------No.MOD-780063 end
                 order_sw	LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                 QVL_flag	LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                 SUB_flag	LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                 more     	LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
                END RECORD
DEFINE g_wc     STRING                       #FUN-750060 add
DEFINE g_cnt    LIKE type_file.num10         #No.FUN-680121 INTEGER
#DEFINE g_dash   VARCHAR(400)   #Dash line
DEFINE g_i      LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
#No.FUN-710082--begin
DEFINE g_wc2    STRING               #No.MOD-780063 add
DEFINE g_sql    STRING                                                       
DEFINE l_table  STRING                                                       
DEFINE l_str    STRING   
DEFINE l_flag   LIKE type_file.num5   
#No.FUN-710082--end  
 
###GENGRE###START
TYPE sr1_t RECORD
    sfa01 LIKE sfa_file.sfa01,
    ima23 LIKE ima_file.ima23,
    sfa03 LIKE sfa_file.sfa03,
    sfa26 LIKE sfa_file.sfa26,
    ima02 LIKE ima_file.ima02,
    ima021 LIKE ima_file.ima021,
    sfa12 LIKE sfa_file.sfa12,
    sfa05 LIKE sfa_file.sfa05,
    sfb05 LIKE sfb_file.sfb05,
    sfb08 LIKE sfb_file.sfb08,
    sfb081 LIKE sfb_file.sfb081,
    ima02a LIKE ima_file.ima02,
    ima021a LIKE ima_file.ima021,
    ima262 LIKE type_file.num15_3,
    bml04 LIKE bml_file.bml04,
    bmd04 LIKE bmd_file.bmd04,
    ima262a LIKE type_file.num15_3,
    l_qty LIKE type_file.num15_3,
    l_qvl LIKE type_file.chr1000,
    bmd02 LIKE bmd_file.bmd02
END RECORD
###GENGRE###END

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
   #CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690123 #FUN-BB0047 mark
 
   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
  #TQC-730022 begin
   LET g_wc     = ARG_VAL(7)    #FUN-750060 tm.wc->g_wc
   #No.FUN-570264 --start--
   #LET g_rep_user = ARG_VAL(7)
   #LET g_rep_clas = ARG_VAL(8)
   #LET g_template = ARG_VAL(9)
   #No.FUN-570264 ---end---
   LET g_rep_user = ARG_VAL(8)
   LET g_rep_clas = ARG_VAL(9)
   LET g_template = ARG_VAL(10)
   LET g_rpt_name = ARG_VAL(11)  #No.FUN-7C0078
  #TQC-730022 end
   LET g_wc=cl_replace_str(g_wc,'\\\"','"')#RETURNING g_wc 
 
   #No.FUN-710082--begin
   LET g_sql ="sfa01.sfa_file.sfa01,",
              "ima23.ima_file.ima23,",
              "sfa03.sfa_file.sfa03,",
              "sfa26.sfa_file.sfa26,",
              "ima02.ima_file.ima02,",
 
              "ima021.ima_file.ima021,",
              "sfa12.sfa_file.sfa12,",
              "sfa05.sfa_file.sfa05,",
              "sfb05.sfb_file.sfb05,",
              "sfb08.sfb_file.sfb08,",
 
              "sfb081.sfb_file.sfb081,",
              "ima02a.ima_file.ima02,",
              "ima021a.ima_file.ima021,",
#             "ima262.ima_file.ima262,",        #NO.FUN-A20044
           #   "avl_stk.type_file.num15_3,",     #NO.FUN-A20044  #TQC-B70168 mark
              "ima262.type_file.num15_3,",      #TQC-B70168
              "bml04.bml_file.bml04,",
          
              "bmd04.bmd_file.bmd04,",
#             "ima262a.ima_file.ima262,",       #NO.FUN-A20044
     #         "avl_stka.type_file.num15_3,",    #NO.FUN-A20044  #TQC-B70168 mark
              "ima262a.type_file.num15_3,",     #TQC-B70168
#             "l_qty.ima_file.ima262,",         #NO.FUN-A20044
              "l_qty.type_file.num15_3,",       #NO.FUN-A20044   
              "l_qvl.type_file.chr1000,",
              "bmd02.bmd_file.bmd02"
 
   LET l_table = cl_prt_temptable('asfg201',g_sql) CLIPPED
   IF l_table = -1 THEN EXIT PROGRAM END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ",
               "        ?,?,?,?,?) "
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err("insert_prep:",STATUS,1) EXIT PROGRAM
   END IF
   #No.FUN-710082--end  
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL g201_tm()                       # If background job sw is off
   ELSE
       CALL g201_gen1()  #TQC-730022
       CALL g201()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION g201_tm()
DEFINE   li_result   LIKE type_file.num5              #No.FUN-550067        #No.FUN-680121 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5,          #No.FUN-680121 SMALLINT
          l_sfc		RECORD LIKE sfc_file.*,
          l_sfd		RECORD LIKE sfd_file.*,
          l_cmd		LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(400)
          l_exit_sw	LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5                 #可刪除否        #No.FUN-680121 SMALLINT
   DEFINE l_sfci        RECORD LIKE sfci_file.*  #NO.FUN-7B0018
   DEFINE l_flag        LIKE type_file.chr1      #NO.FUN-7B0018
   DEFINE l_cnt         LIKE type_file.num5      #No.MOD-B30028
   DEFINE l_cnt1        LIKE type_file.num5      #TQC-C60146 add
   DEFINE l_cnt2        LIKE type_file.num5      #TQC-C60146 add
   DEFINE i             LIKE type_file.num5      #TQC-C60146 add
   DEFINE l_flag1       LIKE type_file.chr1      #TQC-C60146 add
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW g201_w AT p_row,p_col WITH FORM "asf/42f/asfg201"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.order_sw= 'Y'
   LET tm.QVL_flag= 'Y'
   LET tm.SUB_flag= '2'
   LET tm.more = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
   WHILE TRUE
 
     INPUT BY NAME g_sfc01 WITHOUT DEFAULTS
 
#No.FUN-550067-begin
      AFTER FIELD g_sfc01
         IF not cl_null(g_sfc01) AND cl_null(g_sfc01[g_no_sp,g_no_ep]) THEN
            CALL s_get_doc_no(g_sfc01) RETURNING g_t1
            CALL s_check_no("asf",g_t1,"","8","","","")
                 RETURNING li_result,g_t1
            IF (NOT li_result) THEN
               NEXT FIELD g_sfc01
            END IF
#          IF not cl_null(g_sfc01) AND cl_null(g_sfc01[5,10]) THEN
#             LET g_t1=g_sfc01[1,3]
#             CALL s_mfgslip(g_t1,'asf','8')
#             IF NOT cl_null(g_errno) THEN
#                CALL cl_err(g_t1,g_errno,0) NEXT FIELD g_sfc01
#             END IF
           END IF
 
           FOR g_i=1 TO 100
              LET g_no[g_i]=NULL
           END FOR
 
           IF g_sfc01[g_no_sp,g_no_ep] <> ' ' THEN
#          IF g_sfc01[5,10] <> ' ' THEN
              SELECT sfc01 FROM sfc_file WHERE sfc01=g_sfc01
              DECLARE g201_sfd_c CURSOR FOR
                SELECT * FROM sfd_file WHERE sfd01=g_sfc01 ORDER BY 1
              LET g_cnt=1
              FOREACH g201_sfd_c INTO l_sfd.*
                IF l_sfd.sfd03 IS NULL THEN CONTINUE FOREACH END IF
                FOR g_i=1 TO 100
                   IF g_no[g_i]=l_sfd.sfd03 THEN CONTINUE FOREACH END IF
                END FOR
                LET g_no[g_cnt]=l_sfd.sfd03
                LET g_cnt=g_cnt+1
                #IF g_cnt>100 THEN EXIt FOREACH END IF
                # TQC-630105----------start add by Joe
                IF g_cnt > g_max_rec THEN
                   CALL cl_err( '', 9035, 0 )
                   EXIT FOREACH
                   END IF
                # TQC-630105----------end add by Joe
              END FOREACH
 
              LET g_rec_b=g_cnt-1
           END IF
#No.FUN-550067-end
 
        #FUN-B60135-add-str--
        ON ACTION controlp
           CASE
              WHEN INFIELD(g_sfc01)
              CALL q_smy(FALSE,FALSE,g_sfc01,'ASF','8') RETURNING g_sfc01
              LET g_sfc01=g_sfc01
              DISPLAY BY NAME g_sfc01
           END CASE

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
 
        ON ACTION locale
           LET g_action_choice = "locale"
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           EXIT INPUT
 
        ON ACTION exit
           LET INT_FLAG = 1
           EXIT INPUT
     END INPUT
 
     IF g_action_choice = "locale" THEN
        LET g_action_choice = ""
        CALL cl_dynamic_locale()
        CONTINUE WHILE
     END IF
 
     IF INT_FLAG THEN
        LET INT_FLAG=0
        EXIT WHILE
     END IF
 
     WHILE TRUE
        LET l_exit_sw='y' #TQC-5B0143 add
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
                 END IF
              END FOR
          #MOD-CB0170---add---E 

           #TQC-C60146--add--str--
           AFTER INPUT
              IF INT_FLAG THEN
                 CALL cl_err('',9001,0)
                 INITIALIZE g_no TO NULL
                 CLEAR FORM
                 EXIT INPUT
              END IF

              LET l_cnt1=ARR_COUNT()
              LET l_flag1='N'
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
                       LET l_flag1 = 'Y'
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
                         #AND sfb04='2'           #MOD-C90245 mark
                          AND sfb04 IN ('2','3')  #MOD-C90245 
                          AND sfb87 = 'Y'
                          AND sfb85 = g_sfc01    #MOD-CB0170 add
                       IF l_cnt2 = 0 THEN
                         CALL s_errmsg('sfb01',g_no[i],'','asf-608',1) 
                         LET l_flag1 = 'Y'
                       END IF 
                       #CHI-C60023---end
                    END IF   #MOD-CB0170 add
                 END IF      #MOD-CB0170 add
              END FOR
              CALL s_showmsg()
              IF l_flag1 = 'Y' THEN CONTINUE INPUT END IF
           #TQC-C60146--add--end--

           ON ACTION gen_detail
              CALL g201_gen()
               #LET l_exit_sw='y' EXIT INPUT  #MOD-4C0102 #TQC-5B0143 mark
               LET l_exit_sw='n' EXIT INPUT  #TQC-5B0143 Add
 
           ON IDLE g_idle_seconds
              CALL cl_on_idle()
              CONTINUE INPUT
 
           ON ACTION exit
              LET INT_FLAG = 1
              EXIT INPUT
 
        END INPUT
 
        LET g_rec_b=ARR_COUNT()
 
        IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW g201_w 
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
           EXIT PROGRAM 
        END IF
        IF l_exit_sw='y' THEN EXIT WHILE END IF
     END WHILE
 
      #MOD-4C0102
     DISPLAY ARRAY g_no  TO s_no.* ATTRIBUTE(COUNT=g_rec_b)
       BEFORE DISPLAY
          EXIT DISPLAY
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
     END DISPLAY
     #--
 
 
#No.FUN-550067-begin
     IF not cl_null(g_sfc01) AND cl_null(g_sfc01[g_no_sp,g_no_ep]) THEN
#    IF not cl_null(g_sfc01) AND cl_null(g_sfc01[5,10]) THEN
        BEGIN WORK      #No:7829
        CALL s_auto_assign_no("asf",g_sfc01,TODAY,"8","","","","","")
           RETURNING li_result,g_sfc01
        IF (NOT li_result) THEN
           CALL cl_err('','mfg-059',1)
           ROLLBACK WORK
           CONTINUE WHILE
        END IF
#       CALL s_smyauno(g_sfc01,TODAY) RETURNING g_i,g_sfc01
#       IF g_i THEN
#          CALL cl_err('','mfg-059',1)    #No:7829
#          ROLLBACK WORK                  #No:7829
#          CONTINUE WHILE
#       END IF    #有問題
#No.FUN-550067-end
        DISPLAY BY NAME g_sfc01
        COMMIT WORK     #No:7829
     END IF
     IF NOT cl_null(g_sfc01) THEN
        LET l_sfc.sfc01=g_sfc01
        LET l_sfc.sfcacti='Y'
        LET l_sfc.sfcuser=g_user
        LET l_sfc.sfcgrup=g_grup
        LET l_sfc.sfcdate=TODAY
        LET l_sfc.sfcoriu = g_user      #No.FUN-980030 10/01/04
        LET l_sfc.sfcorig = g_grup      #No.FUN-980030 10/01/04
        INSERT INTO sfc_file VALUES(l_sfc.*)
        #NO.FUN-7B0018 08/01/31 add --begin
        IF NOT s_industry('std') THEN
           INITIALIZE l_sfci.* TO NULL
           LET l_sfci.sfci01 = l_sfc.sfc01
          #Mod No.MOD-B30028
          #LET l_flag = s_ins_sfci(l_sfci.*,'')
           SELECT COUNT(*) INTO l_cnt FROM sfci_file
            WHERE sfci01 = l_sfci.sfci01
           IF l_cnt = 0 THEN
              LET l_flag = s_ins_sfci(l_sfci.*,'')
           END IF
          #End Mod No.MOD-B30028
        END IF
        #NO.FUN-7B0018 08/01/31 add --end
        DELETE FROM sfd_file WHERE sfd01=g_sfc01
        FOR g_cnt=1 TO g_rec_b
           LET l_sfd.sfd01=g_sfc01
           LET l_sfd.sfd02=g_cnt
           LET l_sfd.sfd03=g_no[g_cnt]
           LET l_sfd.sfdconf='N' #TQC-B60064
           LET l_sfd.sfd09='1'  #CHI-C60023
           LET  l_sfd.sfduser = g_user        #FUN-D10127
           LET  l_sfd.sfdgrup = g_grup        #FUN-D10127
           LET  l_sfd.sfddate = g_today       #FUN-D10127
           LET  l_sfd.sfdacti ='Y'            #FUN-D10127
           LET  l_sfd.sfdoriu = g_user        #FUN-D10127
           LET  l_sfd.sfdorig = g_grup        #FUN-D10127
           INSERT INTO sfd_file VALUES(l_sfd.*)
           UPDATE sfb_file SET sfb85=l_sfd.sfd01 WHERE sfb01=l_sfd.sfd03  #TQC-C60146 add
        END FOR
     END IF
 
    #---------------No.MOD-780063 add
     CONSTRUCT BY NAME g_wc2 ON sfa08,ima23
     
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
     
     END CONSTRUCT
     IF cl_null(g_wc2) THEN LET g_wc2 = '1=1' END IF
    #---------------No.MOD-780063 end
 
    #------------No.MOD-780063 modify
    #INPUT BY NAME tm.* WITHOUT DEFAULTS
     INPUT BY NAME tm.order_sw,tm.QVL_flag,tm.SUB_flag,
                   tm.more WITHOUT DEFAULTS
    #------------No.MOD-780063 end
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
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
        ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
            ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT
     END INPUT
     IF INT_FLAG THEN
        LET INT_FLAG = 0 CLOSE WINDOW g201_w 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
           
     END IF
    #----------------No.MOD-780063 mark
    #IF tm.b_seq IS NULL THEN LET tm.b_seq = ' ' END IF
    #IF tm.e_seq IS NULL THEN LET tm.e_seq = 'z' END IF
    #IF tm.b_keeper IS NULL THEN LET tm.b_keeper = ' ' END IF
    #IF tm.e_keeper IS NULL THEN LET tm.e_keeper = 'z' END IF
    #----------------No.MOD-780063 end
     IF g_bgjob = 'Y' THEN
        SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
               WHERE zz01='asfg201'
        IF SQLCA.sqlcode OR l_cmd IS NULL THEN
           CALL cl_err('asfg201','9031',1)
        ELSE
           LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                           " '",g_pdate CLIPPED,"'",
                           " '",g_towhom CLIPPED,"'",
                           #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                           " '",g_bgjob CLIPPED,"'",
                           " '",g_prtway CLIPPED,"'",
                           " '",g_copies CLIPPED,"'",
                           " '",tm.order_sw CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
           CALL cl_cmdat('asfg201',g_time,l_cmd)    # Execute cmd at later time
        END IF
        CLOSE WINDOW g201_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
        EXIT PROGRAM
     END IF
     CALL cl_wait()
     CALL g201()
     ERROR ""
END WHILE
   CLOSE WINDOW g201_w
END FUNCTION
 
#TQC-730022 begin
FUNCTION g201_gen1()
  #DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1100) #No.TQC-C80084 mark
   DEFINE l_sql         STRING                       #No.TQC-C80084 add  
   DEFINE l_sfb01	LIKE sfb_file.sfb01          #No.FUN-550067
   DEFINE i,j		LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   LET l_sql="SELECT sfb01 FROM sfb_file WHERE ",g_wc CLIPPED,   #FUN-750060 tm.wc->g_wc
             "   AND sfb08>sfb081 AND sfb87!='X' "
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET l_sql= l_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET l_sql= l_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_sql= l_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030
 
 
   PREPARE g201_gen_p2 FROM l_sql
   DECLARE g201_gen_c2 CURSOR FOR g201_gen_p2
   FOREACH g201_gen_c2 INTO l_sfb01
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
#TQC-730022 end
 
FUNCTION g201_gen()
   DEFINE l_wc          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(800)
   DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1100)
   DEFINE l_sfb01	LIKE sfb_file.sfb01          #No.FUN-550067
   DEFINE i,j		LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   OPEN WINDOW g201_gen_w AT 10,25
        WITH FORM "asf/42f/asfr203a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asfr203a")
 
   CONSTRUCT BY NAME l_wc ON sfb01,sfb81,sfb05,sfb82
 
       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE CONSTRUCT
 
   END CONSTRUCT
 
   CLOSE WINDOW g201_gen_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   LET l_sql="SELECT sfb01 FROM sfb_file WHERE ",l_wc CLIPPED,
             #"   AND sfb08>sfb081 AND sfb87!='X' ",  #CHI-C60023
             "   AND sfb08>sfb081 AND sfb87 = 'Y' ",  #CHI-C60023
            #"   AND sfbacti = 'Y' AND sfb04 = '2' "  #CHI-C60023  #MOD-C90245 mark
             "   AND sfbacti = 'Y' AND sfb04 IN ('2','3') "        #MOD-C90245
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET l_sql= l_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET l_sql= l_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET l_sql= l_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    #End:FUN-980030
 
 
   PREPARE g201_gen_p FROM l_sql
   DECLARE g201_gen_c CURSOR FOR g201_gen_p
   FOREACH g201_gen_c INTO l_sfb01
      FOR i=1 TO 100
         IF g_no[i]=l_sfb01 THEN CONTINUE FOREACH END IF
      END FOR
      FOR i=1 TO 100
         IF g_no[i] IS NULL THEN LET g_no[i]=l_sfb01 CONTINUE FOREACH END IF
      END FOR
   END FOREACH
   FOR i=100 TO 1 STEP -1 IF g_no[i] IS NOT NULL THEN EXIT FOR END IF END FOR
   LET g_rec_b=i
   CALL SET_COUNT(g_rec_b) #TQC-5B0143 add
END FUNCTION
 
FUNCTION g201()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
          l_cnt     LIKe type_file.num5,          #No.MOD-780063 add
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(1000) #TQC-C80084
          l_sql     STRING,                       #TQC-C80084
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_sfb	    RECORD LIKE sfb_file.*,
#         l_order    ARRAY[5] OF LIKE apm_file.apm08,        #No.FUN-680121 VARCHAR(10) # TQC-6A0079
          sr            RECORD sfa01	LIKE sfa_file.sfa01,
                               ima23	LIKE ima_file.ima23,
                               sfa03	LIKE sfa_file.sfa03,
                               sfa26	LIKE sfa_file.sfa26,
                               ima02	LIKE ima_file.ima02,
                               ima021	LIKE ima_file.ima021,
                               sfa12	LIKE sfa_file.sfa12,
                               sfa05	LIKE sfa_file.sfa05,
                               #No.FUN-710082--begin
                               sfb05	LIKE sfb_file.sfb05, 
                               sfb08	LIKE sfb_file.sfb08, 
                               sfb081	LIKE sfb_file.sfb081 
                               #No.FUN-710082--end
                        END RECORD
#No.FUN-710082--begin
DEFINE    l_ima02	LIKE ima_file.ima02,
          l_ima021	LIKE ima_file.ima021,
#         l_qty2,l_qty	LIKE ima_file.ima26,  
#         l_ima262	LIKE ima_file.ima262,  
#         l_ima262a	LIKE ima_file.ima262,   
          l_qty2,l_qty	LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          l_avl_stk     LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          l_avl_stka    LIKE type_file.num15_3,    ###GP5.2  #NO.FUN-A20044
          l_qvl		LIKE type_file.chr1000,       
          l_bml		RECORD LIKE bml_file.*,
          l_bmd		RECORD LIKE bmd_file.*
#No.FUN-710082--end  
   DEFINE   l_n1        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n2        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
   DEFINE   l_n3        LIKE type_file.num15_3 ###GP5.2  #NO.FUN-A20044
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
 
     DROP TABLE g201_tmp
    #No.FUN-680121-BEGIN
      CREATE TEMP TABLE g201_tmp(
              partno LIKE type_file.chr1000,
              qty    LIKE type_file.num15_3)       #NO.FUN-A20044
     #No.FUN-680121-END
     #No.FUN-710082--begin
     CALL cl_del_data(l_table) 
#    CALL cl_outnam('asfg201') RETURNING l_name
#    START REPORT g201_rep TO l_name
    #-----------No.MOD-780063 modify
     IF cl_null(g_wc2) THEN LET g_wc2 = '1=1' END IF      #MOD-B50060 add
     FOR l_cnt=1 TO 100
        #DECLARE g201_sfa_c CURSOR FOR
        #         SELECT sfa01,ima23,sfa03,sfa26,ima02,ima021,sfa12,sfa05-sfa06
        #           FROM sfa_file, sfb_file, ima_file
        #          WHERE sfa01=g_no[g_cnt] AND sfa03=ima01
        #            AND sfa05>sfa06 AND sfa01=sfb01 AND sfb87!='X'
        #           #AND sfa08 BETWEEN b_seq AND e_seq
        #           #AND ima23 BETWEEN b_keeper AND e_keeper
         LET l_sql = "SELECT sfa01,ima23,sfa03,sfa26,ima02,ima021, ",
                    #"sfa12,sfa05-sfa06,sfb05,sfb08,sfb081 ",         #FUN-A60027
                     "sfa12,SUM(sfa05-sfa06),sfb05,sfb08,sfb081 ",    #FUN-A60027
                     "FROM sfa_file, sfb_file, ima_file ",
                     "WHERE sfa01='",g_no[l_cnt],"' AND sfa03=ima01 ", 
                     "AND sfa05>sfa06 AND sfa01=sfb01 AND sfb87!='X' ",
                     "AND ",g_wc2 CLIPPED,
                     "GROUP BY sfa01,ima23,sfa03,sfa26,ima02,ima021,sfa12,sfb05,sfb08,sfb081 "      #FUN-A60027
 
         IF tm.order_sw = 'N' THEN
            LET l_sql = l_sql," ORDER BY sfa01,sfa03"
         ELSE
            LET l_sql = l_sql," ORDER BY sfa01,ima23,sfa03"
         END IF 
 
         PREPARE g201_p1 FROM l_sql
         DECLARE g201_sfa_c CURSOR FOR g201_p1
     #-----------No.MOD-780063 end
         FOREACH g201_sfa_c INTO sr.*
           #IF tm.order_sw='N' THEN LET sr.ima23=' ' END IF  #No.MOD-780063 mark
 
            SELECT SUM(sfa05) INTO l_qty
              FROM sfa_file
             WHERE sfa01=sr.sfa01 
               AND sfa03=sr.sfa03
             GROUP BY sfa03
        
#           LET l_ima262=NULL                                               #NO.FUN-A20044
#           SELECT ima262 INTO l_ima262 FROM ima_file WHERE ima01=sr.sfa03  #NO.FUN-A20044
            LET l_avl_stk = NULL
            CALL s_getstock(sr.sfa03,g_plant) RETURNING  l_n1,l_n2,l_n3     #NO.FUN-A20044
            LET l_avl_stk = l_n3                                            #NO.FUN-A20044 
              
            #--------------------------------- 扣除前面已出現部份
            LET l_qty2=0
            SELECT qty INTO l_qty2 FROM g201_tmp WHERE partno=sr.sfa03
#           LET l_ima262=l_ima262-l_qty2                                    #NO.FUN-A20044
            LET l_avl_stk = l_avl_stk - l_qty2                              #NO.FUN-A20044
            UPDATE g201_tmp SET qty=qty+l_qty WHERE partno=sr.sfa03
            IF SQLCA.SQLERRD[3]=0 THEN
               INSERT INTO g201_tmp VALUES(sr.sfa03, l_qty)
            END IF
 
            IF tm.QVL_flag='Y' THEN
               DECLARE g201_QVL_c CURSOR FOR
                  SELECT * FROM bml_file
                         WHERE bml01 = sr.sfa03
                           AND (bml02='ALL' OR bml02=sr.sfb05)
                         ORDER BY bml03
                  LET l_qvl = ""
               FOREACH g201_QVL_c INTO l_bml.*
                  LET l_qvl = "    QVL:"
                  LET l_qvl = l_qvl CLIPPED,l_bml.bml04 CLIPPED,','
               END FOREACH
            END IF
 
            IF sr.sfa26 MATCHES '[123478]' AND       #FUN-A20037 add '7,8' 
#             (tm.SUB_flag='2' OR (tm.SUB_flag='3' AND l_qty>l_ima262)) THEN   #NO.FUN-A20044
              (tm.SUB_flag='2' OR (tm.SUB_flag='3' AND l_qty>l_avl_stk)) THEN  #NO.FUN-A20044
               DECLARE g201_SUB_c CURSOR FOR
#                 SELECT bmd_file.*, ima02,ima021,ima262 FROM bmd_file, ima_file  #NO.FUN-A20044
                  SELECT bmd_file.*, ima02,ima021,0 FROM bmd_file, ima_file    #NO.FUN-A20044
                         WHERE bmd01 = sr.sfa03 AND bmd04=ima01
                           AND (bmd08='ALL' OR bmd08=sr.sfb05)
                           AND bmdacti = 'Y'                                           #CHI-910021
                         ORDER BY bmd03
               LET l_flag=0
#              FOREACH g201_SUB_c INTO l_bmd.*, l_ima02,l_ima021, l_ima262a     #NO.FUN-A20044
               FOREACH g201_SUB_c INTO l_bmd.*, l_ima02,l_ima021, l_avl_stka    #NO.FUN-A20044
                   LET l_flag=1
#                  IF l_ima262<=0 THEN CONTINUE FOREACH END IF   #NO.FUN-A20044
                   IF l_avl_stk<=0 THEN CONTINUE FOREACH END IF  #NO.FUN-A20044
 
                     EXECUTE insert_prep USING sr.sfa01,sr.ima23,sr.sfa03,sr.sfa26,sr.ima02,
                                               sr.ima021,sr.sfa12,sr.sfa05,sr.sfb05,sr.sfb08,
#                                              sr.sfb081,l_ima02,l_ima021,l_ima262,l_bml.bml04,
#                                              l_bmd.bmd04,l_ima262a,l_qty,l_qvl,l_bmd.bmd02
                                               sr.sfb081,l_ima02,l_ima021,l_avl_stk,l_bml.bml04,
                                               l_bmd.bmd04,l_avl_stka,l_qty,l_qvl,l_bmd.bmd02
 
                     LET l_bmd.bmd02=NULL
                     LET l_bmd.bmd04=NULL
                     LET l_ima02=''
                     LET l_ima021=''
#                    LET l_ima262a=''   #NO.FUN-A20044
                     LET l_avl_stk=''   #NO.FUN-A20044
 
               END FOREACH
               IF l_flag=0 AND cl_null(l_bmd.bmd02) THEN
                     EXECUTE insert_prep USING sr.sfa01,sr.ima23,sr.sfa03,sr.sfa26,sr.ima02,
                                               sr.ima021,sr.sfa12,sr.sfa05,sr.sfb05,sr.sfb08,
#                                              sr.sfb081,l_ima02,l_ima021,l_ima262,l_bml.bml04,
#                                              l_bmd.bmd04,l_ima262a,l_qty,l_qvl,l_bmd.bmd02
                                               sr.sfb081,l_ima02,l_ima021,l_avl_stk,l_bml.bml04,
                                               l_bmd.bmd04,l_avl_stka,l_qty,l_qvl,l_bmd.bmd02
                     LET l_bmd.bmd02=NULL
                     LET l_bmd.bmd04=NULL
                     LET l_ima02=''
                     LET l_ima021=''
               END IF
            ELSE
                     EXECUTE insert_prep USING sr.sfa01,sr.ima23,sr.sfa03,sr.sfa26,sr.ima02,
                                               sr.ima021,sr.sfa12,sr.sfa05,sr.sfb05,sr.sfb08,
#                                              sr.sfb081,l_ima02,l_ima021,l_ima262,l_bml.bml04,
#                                              l_bmd.bmd04,l_ima262a,l_qty,l_qvl,l_bmd.bmd02
                                               sr.sfb081,l_ima02,l_ima021,l_avl_stk,l_bml.bml04,
                                               l_bmd.bmd04,l_avl_stka,l_qty,l_qvl,l_bmd.bmd02
 
                     LET l_bmd.bmd02=NULL
                     LET l_bmd.bmd04=NULL
                     LET l_ima02=''
                     LET l_ima021=''
#                    LET l_ima262a=''
                     LET l_avl_stka=''
            END IF
#           OUTPUT TO REPORT g201_rep(sr.*)
         END FOREACH
     END FOR
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog
###GENGRE###     LET l_str = ''
 
   # LET l_sql = "SELECT * FROM ",l_table CLIPPED   #TQC-730088
   # CALL cl_prt_cs3('asfg201',l_sql,l_str) 
###GENGRE###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED  
###GENGRE###     CALL cl_prt_cs3('asfg201','asfg201',l_sql,l_str) 
    CALL asfg201_grdata()    ###GENGRE###
#    FINISH REPORT g201_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
     #No.FUN-710082--end  
END FUNCTION
 
#No.FUN-710082--begin
#REPORT g201_rep(sr)
#  DEFINE l_last_sw	LIKE type_file.chr1,        #No.FUN-680121 VARCHAR(1)
#         l_sfb		RECORD LIKE sfb_file.*,
#         l_ima02	LIKE ima_file.ima02,
#         l_ima021	LIKE ima_file.ima021,
#         l_qty2,l_qty	LIKE ima_file.ima26,        #No.FUN-680121 DEC(15,3)
#         l_ima262	LIKE ima_file.ima262,       #No.FUN-680121 DEC(15,3)
#         l_bml		RECORD LIKE bml_file.*,
#         l_bmd		RECORD LIKE bmd_file.*,
#         sr            RECORD sfa01	LIKE sfa_file.sfa01,
#                              ima23	LIKE ima_file.ima23,
#                              sfa03	LIKE sfa_file.sfa03,
#                              sfa26	LIKE sfa_file.sfa26,
#                              ima02	LIKE ima_file.ima02,
#                              ima021	LIKE ima_file.ima021,
#                              sfa12	LIKE sfa_file.sfa12,
#                              sfa05	LIKE sfa_file.sfa05
#         		END RECORD
 
# OUTPUT TOP MARGIN 0 LEFT MARGIN g_left_margin BOTTOM MARGIN 6
#        PAGE LENGTH g_page_line   #No.MOD-580242
 
# ORDER BY sr.sfa01,sr.ima23, sr.sfa03
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
#     LET g_pageno = g_pageno + 1
#     #FUN-550124
#     LET pageno_total = PAGENO USING '<<<',"/pageno" #TQC-5B0143 unmark
#     PRINT g_head CLIPPED, pageno_total  #TQC-5B0143 unmark
#     #PRINT g_head CLIPPED, g_pageno USING '<<<' #TQC-5B0143 mark
#     #END FUN-550124
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
#     PRINT ' '
#     PRINT g_dash[1,g_len]
#     SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=sr.sfa01
#     PRINT g_x[10] clipped,sr.sfa01,'  ',
#           g_x[11] clipped,l_sfb.sfb05,'  ',
#           g_x[12] clipped,(l_sfb.sfb08-l_sfb.sfb081) USING '-------&'
#     PRINT
#     PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],g_x[36]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  BEFORE GROUP OF sr.sfa01
#     SKIP TO TOP OF PAGE
#  AFTER GROUP OF sr.sfa03
#     LET l_qty=GROUP SUM(sr.sfa05)
#     LET l_ima262=NULL
#     SELECT ima262 INTO l_ima262 FROM ima_file WHERE ima01=sr.sfa03
#     #--------------------------------- 扣除前面已出現部份
#     LET l_qty2=0
#     SELECT qty INTO l_qty2 FROM g201_tmp WHERE partno=sr.sfa03
#     LET l_ima262=l_ima262-l_qty2
#     #IF l_ima262<0 THEN LET l_ima262=0 END IF
#     UPDATE g201_tmp SET qty=qty+l_qty WHERE partno=sr.sfa03
#     IF SQLCA.SQLERRD[3]=0 THEN
#        INSERT INTO g201_tmp VALUES(sr.sfa03, l_qty)
#     END IF
#     #---------------------------------
#     PRINT COLUMN g_c[31],sr.ima23[1,6],' ',
#           #COLUMN g_c[32],sr.sfa03 CLIPPED,' ', #NO.FUN-5B0015
#           COLUMN g_c[32],sr.sfa03[1,20],' ',
#            COLUMN g_c[33],sr.ima02 CLIPPED,  #MOD-4A0238
#           COLUMN g_c[34],sr.ima021 CLIPPED,
#           COLUMN g_c[35],l_qty USING '---,---,--&',
#           COLUMN g_c[36],l_ima262 USING '---,---,--&'
#     IF tm.QVL_flag='Y' THEN
#        DECLARE g201_QVL_c CURSOR FOR
#           SELECT * FROM bml_file
#                  WHERE bml01 = sr.sfa03
#                    AND (bml02='ALL' OR bml02=l_sfb.sfb05)
#                  ORDER BY bml03
#        LET g_cnt=0
#        FOREACH g201_QVL_c INTO l_bml.*
#           IF g_cnt=0 THEN PRINT "     QVL:"; END IF
#           IF g_cnt=8 THEN PRINT PRINT "     QVL:"; END IF
#           PRINT l_bml.bml04 CLIPPED,',';
#           LET g_cnt=g_cnt+1
#        END FOREACH
#        IF g_cnt>0 THEN PRINT END IF
#     END IF
#     IF sr.sfa26 MATCHES '[1234]' AND
#       (tm.SUB_flag='2' OR (tm.SUB_flag='3' AND l_qty>l_ima262)) THEN
#        DECLARE g201_SUB_c CURSOR FOR
#           SELECT bmd_file.*, ima02,ima021,ima262 FROM bmd_file, ima_file
#                  WHERE bmd01 = sr.sfa03 AND bmd04=ima01
#                    AND (bmd08='ALL' OR bmd08=l_sfb.sfb05)
#                  ORDER BY bmd03
#        LET g_cnt=0
#        FOREACH g201_SUB_c INTO l_bmd.*, l_ima02,l_ima021, l_ima262
#           IF l_ima262<=0 THEN CONTINUE FOREACH END IF
#           IF l_bmd.bmd02=1 THEN PRINT "      U: "; END IF
#           IF l_bmd.bmd02=2 THEN PRINT "      S: "; END IF
#           PRINT COLUMN g_c[32],l_bmd.bmd04[1,18],
#                 COLUMN g_c[33],l_ima02,
#                 COLUMN g_c[34],l_ima021,
#                 #l_bmd.bmd07 USING '----&.&&&',
#                 COLUMN g_c[36],l_ima262 USING '---,---,--&'
#           LET g_cnt=g_cnt+1
#        END FOREACH
#     END IF
 
#  AFTER GROUP OF sr.sfa01
#     #LET g_pageno=0  #TQC-5B0143 mark
#     LET l_last_sw='y'
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
 
#  PAGE TRAILER
#     PRINT g_dash[1,g_len]
#     IF l_last_sw = 'n'
#        THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
#        ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
#     END IF
## FUN-550124
#     PRINT
#     IF l_last_sw = 'n' THEN
#        IF g_memo_pagetrailer THEN
#            PRINT g_x[13]
#            PRINT g_memo
#        ELSE
#            PRINT
#            PRINT
#        END IF
#     ELSE
#            PRINT g_x[13]
#            PRINT g_memo
#     END IF
## END FUN-550124
 
#END REPORT
#No.FUN-710082--end  


###GENGRE###START
FUNCTION asfg201_grdata()
    DEFINE l_sql    STRING
    DEFINE handler  om.SaxDocumentHandler
    DEFINE sr1      sr1_t
    DEFINE l_cnt    LIKE type_file.num10
    DEFINE l_msg    STRING

    LET l_cnt = cl_gre_rowcnt(l_table)
    IF l_cnt <= 0 THEN RETURN END IF

    WHILE TRUE
        CALL cl_gre_init_pageheader()            
        LET handler = cl_gre_outnam("asfg201")
        IF handler IS NOT NULL THEN
            START REPORT asfg201_rep TO XML HANDLER handler
            LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                        " ORDER BY sfa01,sfa03,bmd02"     #TQC-D70080
          
            DECLARE asfg201_datacur1 CURSOR FROM l_sql
            FOREACH asfg201_datacur1 INTO sr1.*
                OUTPUT TO REPORT asfg201_rep(sr1.*)
            END FOREACH
            FINISH REPORT asfg201_rep
        END IF
        IF INT_FLAG = TRUE THEN
            LET INT_FLAG = FALSE
            EXIT WHILE
        END IF
    END WHILE
    CALL cl_gre_close_report()
END FUNCTION

REPORT asfg201_rep(sr1)
    DEFINE sr1 sr1_t
    DEFINE l_lineno LIKE type_file.num5
    DEFINE l_sfb08_sfb081 LIKE sfb_file.sfb08   #TQC-D70080
    DEFINE l_display LIKE type_file.chr1        #TQC-D70080
    DEFINE l_bmd02   LIKE type_file.chr10       #TQC-D70080

    
    ORDER EXTERNAL BY sr1.sfa01,sr1.sfa03,sr1.bmd02
    
    FORMAT
        FIRST PAGE HEADER
            PRINTX g_grPageHeader.*    
            PRINTX g_user,g_pdate,g_prog,g_company,g_ptime,g_user_name
            PRINTX tm.*
              
        BEFORE GROUP OF sr1.sfa01
            LET l_lineno = 0
            #TQC-D70080----add--str- 
            LET l_sfb08_sfb081 = sr1.sfb08 - sr1.sfb081
            PRINTX l_sfb08_sfb081
            #TQC-D70080----add--end-
        BEFORE GROUP OF sr1.sfa03
        BEFORE GROUP OF sr1.bmd02

        
        ON EVERY ROW
            LET l_lineno = l_lineno + 1
            PRINTX l_lineno

            PRINTX sr1.*

        AFTER GROUP OF sr1.sfa01
        AFTER GROUP OF sr1.sfa03
        AFTER GROUP OF sr1.bmd02
            #TQC-D70080----add--str-
            IF sr1.bmd04 IS NULL THEN
               LET l_display = 'N'
            ELSE
               LET l_display = 'Y'
            END IF
            PRINTX l_display

            CASE sr1.bmd02
               WHEN '1' LET l_bmd02 = "U:"
               WHEN '2' LET l_bmd02 = "S:"
            END CASE
            PRINTX l_bmd02
            #TQC-D70080----add--end-

        
        ON LAST ROW

END REPORT
###GENGRE###END

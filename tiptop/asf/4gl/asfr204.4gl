# Prog. Version..: '5.30.06-13.04.17(00010)'     #
#
# Pattern name...: asfr204.4gl
# Descriptions...: 工單調撥發料料表列印
# Modify.........: 97/09/12 By Roger
# Modify.........: No:7829 03/08/18 Carol 單據程式中呼叫單據自動編號時,
#                                         應該是要包覆在 BEGIN WORK 中(transaction)
#                                         才會達到lock 的功能
# Modify.........: NO.FUN-550067 05/05/31 By day   單據編號加大
# Modify.........: No.FUN-550114 05/06/01 By echo 新增報表備註
# Modify.........: No.FUN-560084 05/06/84 By Carrier 雙單位內容修改
# Modify.........: NO.TQC-5B0125 05/11/23 BY yiting 料號/品名無放大
# Modify.........: No.FUN-660029 06/06/13 By kim GP3.1 增加確認碼欄位與處理
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: NO.FUN-670066 06/07/25 By bnlent voucher型報表轉template1 
# Modify.........: NO.FUN-680006 06/08/04 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680121 06/08/30 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
 
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6A0090 06/10/30 By dxfwo 欄位類型修改(修改apm_file.apm08)
# Modify.........: NO.TQC-6A0048 06/12/14 By Mandy imn20 空白,導致無法扣存扣帳
# Modify.........: NO.TQC-760056 07/06/20 By rainy SMT料(發料前調撥)執行後未產生對應的調撥單
# Modify.........: No.TQC-770019 07/07/09 By pengu 無法透過工具列，進行語言別切換
# Modify.........: No.FUN-7B0018 08/01/31 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.FUN-7C0081 08/01/24 By zhaijie報表輸出改為CR
# Modify.........: No.MOD-840400 08/04/22 By lilingyu 無法啟動報表
# Modify.........: No.MOD-850308 08/05/29 By claire (1) 考慮倉管員沒有給條件,空白時的判斷
#                                                   (2) 調撥單號取號的判斷調整
# Modify.........: No.MOD-860280 08/06/24 By claire 可用庫存量算錯
# Modify.........: No.MOD-870324 08/07/30 By claire 料號及生產數量相同的不同工單只會於報表單身備料出現一筆
# Modify.........: No.CHI-910021 09/02/01 By xiaofeizhu 有select bmd_file或select pmh_file的部份，全部加入有效無效碼="Y"的判斷
# Modify.........: No.MOD-940312 09/04/23 By Smapmin 抓取庫存量時,要用SUM(img10*img21)
# Modify.........: No.FUN-980008 09/08/14 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9C0072 10/01/11 By vealxu 精簡程式碼
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No:TQC-A50156 10/05/26 By Carrier MOD-9A0126 追单
# Modify.........: No.FUN-AB0049 10/11/11 By zhangll 倉庫營運中心權限修改
# Modify.........: No.MOD-B30028 11/03/04 By zhangll 修正插入sfci_file,系统异常当出问题
# Modify.........: No.FUN-A60034 11/03/08 By Mandy 因aimt324 新增EasyFlow整合功能影響INSERT INTO imm_file
# Modify.........: No:FUN-A70104 11/03/08 By Mandy [EF簽核] aimt324影響程式簽核欄位default
# Modify.........: No:TQC-B60064 11/06/14 By jan 1.補上LET l_sfd.sfdconf = 'N'
# Modify.........: No.FUN-B70074 11/07/22 By xianghui 添加行業別表的新增於刪除
# Modify.........: No:FUN-B80086 11/08/09 By Lujh 模組程序撰寫規範修正
# Modify.........: No:FUN-BB0084 11/12/05 By lixh1 增加數量欄位小數取位
# Modify.........: No:TQC-C60154 12/06/19 By lixh1 增加PBI欄位開窗
# Modify.........: No.TQC-C60146 12/06/19 By fengrui 判斷不可是已存在sfd_file單身的非本張PBI單的工單號碼,並回寫到工單sfb85
# Modify.........: No.CHI-C60023 12/08/20 By bart 新增欄位-資料類別
# Modify.........: No:MOD-CB0170 13/01/07 By Elise PBI修改
# Modify.........: No:FUN-D10127 13/03/15 By Alberti 增加sfduser,sfdgrup,sfdmodu,sfddate,sfdacti
# Modify.........: No:MOD-D30172 13/03/20 By bart 未設定倉管人員也要產生報表

DATABASE ds
GLOBALS "../../config/top.global"
 
DEFINE g_sfc01	LIKE sfc_file.sfc01                      #No.FUN-550067
DEFINE g_no	ARRAY[120] OF LIKE sfd_file.sfd03        #No.FUN-680121 VARCHAR(16)#No.FUN-550067
DEFINE g_part	ARRAY[120] OF LIKE sfb_file.sfb05        #No.FUN-680121 VARCHAR(40)#No.FUN-550067
DEFINE g_t1	LIKE oay_file.oayslip                    #No.FUN-550067 #No.FUN-680121 VARCHAR(5)
DEFINE s1,s2,s3	LIKE ima_file.ima34                      #No.FUN-680121 VARCHAR(9)
DEFINE ss	ARRAY[120] OF LIKE type_file.chr1000     #No.FUN-680121 VARCHAR(100)#No.FUN-550067
DEFINE ss1	ARRAY[120] OF LIKE type_file.chr1000     #No.FUN-680121 VARCHAR(80)#No.FUN-550067
DEFINE ss2	ARRAY[120] OF LIKE type_file.chr1000     #NO.FUN-7C0081
DEFINE g_rec_b	LIKE type_file.num10                     #No.FUN-680121 INTEGER
DEFINE tm  RECORD                         # Print condition RECORD
		from_w,to_w	LIKE imd_file.imd01,     #No.FUN-680121 VARCHAR(10)
		from_l,to_l	LIKE imd_file.imd01,     #No.FUN-680121 VARCHAR(10)
		tr_no		LIKE imm_file.imm01,     #No.FUN-550067
		tr_date		LIKE type_file.dat,      #No.FUN-680121 DATE
		b_seq		LIKE sfa_file.sfa08,     #No.FUN-680121 VARCHAR(6)
		e_seq		LIKE sfa_file.sfa08,     #No.FUN-680121 VARCHAR(6)
		b_keeper	LIKE ima_file.ima23,     #No.FUN-680121 VARCHAR(6)
		e_keeper	LIKE ima_file.ima23,     #No.FUN-680121 VARCHAR(6)
		order_sw	LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
		QVL_flag	LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
		SUB_flag	LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                a               LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
		more     	LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)# Input more condition(Y/N)
              END RECORD
DEFINE   g_ima906    LIKE ima_file.ima906
DEFINE   g_ima907    LIKE ima_file.ima907
DEFINE   g_cnt1      LIKE type_file.num5              #No.FUN-680121 SMALLINT
DEFINE   g_factor    LIKE img_file.img21
DEFINE   g_img09     LIKE img_file.img09
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680121 INTEGER
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(72)
   DEFINE   l_table      STRING                  
   DEFINE   l_table1     STRING                  
   DEFINE   l_table2     STRING
   DEFINE   l_table3     STRING               
   DEFINE   g_sql        STRING                   
   DEFINE   g_str        STRING                   
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
               "ima23.ima_file.ima23,",
               "sfa03.sfa_file.sfa03,",
               "sfa26.sfa_file.sfa26,",
               "ima02.ima_file.ima02,",
               "ima108.ima_file.ima108,",
               "ima63.ima_file.ima63,",
               "ima64.ima_file.ima64,",
               "ima641.ima_file.ima641,",
               "sfa12.sfa_file.sfa12,",
               "sfa05.sfa_file.sfa05,",
               "to_qty.ima_file.ima64,",
               "from_qty.ima_file.ima64,",
#              "l_qty.ima_file.ima262,",    #NO.FUN-A20044
               "l_qty.type_file.num15_3,",  #NO.FUN-A20044 
               "ss_1.type_file.chr1000,",
               "ss_2.type_file.chr1000,",
               "ss2_1.type_file.chr1000,",
               "ss2_2.type_file.chr1000,",
               "ss1_1.type_file.chr1000,",
               "ss1_2.type_file.chr1000"
   LET l_table = cl_prt_temptable('asfr204',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF 
   LET g_sql = "bml01.bml_file.bml01,",
               "bml03.bml_file.bml03,",
               "bml04.bml_file.bml04"
   LET l_table1 = cl_prt_temptable('asfr2041',g_sql) CLIPPED
   IF l_table1=-1 THEN EXIT PROGRAM END IF 
   LET g_sql = "bmd01.bmd_file.bmd01,",
               "bmd02.bmd_file.bmd02,",
               "bmd04.bmd_file.bmd04,",
               "bmd07.bmd_file.bmd07,",
               "bmd08.bmd_file.bmd08,",
               "ima01.ima_file.ima01,",
               "ima02.ima_file.ima02,",
#              "ima262.ima_file.ima262"         #NO.FUN-A20044
               "avl_stk.type_file.num15_3"      #NO.FUN-A20044
   LET l_table2 = cl_prt_temptable('asfr2042',g_sql) CLIPPED
   IF l_table2 =-1 THEN EXIT PROGRAM END IF 
   LET g_sql = "order1.type_file.chr1,",
               "ss_gcnt.type_file.chr1000,",
               "ss2_gcnt.type_file.chr1000,",
               "ss1_gcnt.type_file.chr1000"
   LET l_table3 = cl_prt_temptable('asfr2043',g_sql) CLIPPED
   IF l_table3=-1 THEN EXIT PROGRAM END IF  
 
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET g_rpt_name = ARG_VAL(7)  #No.FUN-7C0078
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN
       CALL r204_tm(0,0)                       # If background job sw is off
   ELSE
       CALL r204()                      # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION r204_tm(p_row,p_col)
DEFINE   li_result   LIKE type_file.num5         #No.FUN-550067        #No.FUN-680121 SMALLINT
   DEFINE p_row,p_col   LIKE type_file.num5,     #No.FUN-680121 SMALLINT
          l_sfc		RECORD LIKE sfc_file.*,
          l_sfd		RECORD LIKE sfd_file.*,
          l_imd02       LIKE imd_file.imd02,
          l_cmd		LIKE type_file.chr1000,  #No.FUN-680121 VARCHAR(400)
          l_exit_sw	LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,   #可新增否        #No.FUN-680121 SMALLINT
          l_allow_delete  LIKE type_file.num5    #可刪除否        #No.FUN-680121 SMALLINT
   DEFINE l_sfci        RECORD LIKE sfci_file.*  #NO.FUN-7B0018
   DEFINE l_flag        LIKE type_file.chr1      #NO.FUN-7B0018
   DEFINE l_cnt         LIKE type_file.num5      #No.MOD-B30028
   DEFINE l_cnt1        LIKE type_file.num5      #TQC-C60146 add
   DEFINE l_cnt2        LIKE type_file.num5      #TQC-C60146 add
   DEFINE i             LIKE type_file.num5      #TQC-C60146 add
   DEFINE l_flag1       LIKE type_file.chr1      #TQC-C60146 add
 
   IF p_row = 0 THEN LET p_row = 2 LET p_col = 10 END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 2 LET p_col =20
   ELSE LET p_row = 2 LET p_col = 10
   END IF
   OPEN WINDOW r204_w AT p_row,p_col
        WITH FORM "asf/42f/asfr204"
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
   LET tm.SUB_flag= '1'
   LET tm.tr_date= TODAY
   LET tm.a    = 'N'
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
	 FOR g_cnt=1 TO 120 LET g_no[g_cnt]=NULL END FOR
         IF g_sfc01[g_no_sp,g_no_ep] <> ' ' THEN
            SELECT sfc01 FROM sfc_file WHERE sfc01=g_sfc01
	    DECLARE r204_sfd_c CURSOR FOR
	       SELECT * FROM sfd_file WHERE sfd01=g_sfc01 ORDER BY 1
	    LET g_cnt=1
	    FOREACH r204_sfd_c INTO l_sfd.*
	       IF l_sfd.sfd03 IS NULL THEN CONTINUE FOREACH END IF
               FOR g_i=1 TO 120
                  IF g_no[g_i]=l_sfd.sfd03 THEN CONTINUE FOREACH END IF
               END FOR
	       LET g_no[g_cnt]=l_sfd.sfd03
	       LET g_cnt=g_cnt+1
	       IF g_cnt>120 THEN EXIt FOREACH END IF
	    END FOREACH
	    LET g_rec_b=g_cnt-1
         END IF

#TQC-C60154 ---------------Begin----------------
        ON ACTION controlp
           CASE
              WHEN INFIELD(g_sfc01)
              CALL q_smy(FALSE,FALSE,g_sfc01,'ASF','8') RETURNING g_sfc01
              LET g_sfc01=g_sfc01
              DISPLAY BY NAME g_sfc01
           END CASE
#TQC-C60154 ---------------End------------------
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
   END INPUT
   IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW r204_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM 
   END IF
 
   WHILE TRUE
      LET l_exit_sw='y'
      LET l_allow_insert = cl_detail_input_auth("insert")
      LET l_allow_delete = cl_detail_input_auth("delete")
 
      INPUT ARRAY g_no WITHOUT DEFAULTS FROM s_no.*
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
              INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete)

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
                      WHERE sfb01 = g_no[i] AND sfb85 !=''           #MOD-CB0170 add
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
                          #AND sfb04='2'           #MOD-CB0170 mark
                           AND sfb04 IN ('2','3')  #MOD-CB0170  
                           AND sfb87 = 'Y'
                           AND sfb85 = g_sfc01     #MOD-CB0170 add
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
           CALL r204_gen()
           LET l_exit_sw='n' EXIT INPUT
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
      END INPUT
      LET g_rec_b=ARR_COUNT()
      IF INT_FLAG THEN LET INT_FLAG=0 CLOSE WINDOW r204_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM 
      END IF
      IF l_exit_sw='y' THEN EXIT WHILE END IF
   END WHILE
 
   BEGIN WORK        #No:7829
   IF not cl_null(g_sfc01) AND cl_null(g_sfc01[g_no_sp,g_no_ep]) THEN
      CALL s_auto_assign_no("asf",g_sfc01,TODAY,"8","","","","","")
         RETURNING li_result,g_sfc01
      IF (NOT li_result) THEN
         ROLLBACK WORK
         CONTINUE WHILE
      END IF
      DISPLAY BY NAME g_sfc01
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
      DELETE FROM sfd_file WHERE sfd01=g_sfc01
      FOR g_cnt=1 TO g_rec_b
         LET l_sfd.sfd01=g_sfc01
         LET l_sfd.sfd02=g_cnt
         LET l_sfd.sfd03=g_no[g_cnt]
         LET l_sfd.sfdconf='N' #TQC-B60064
         LET l_sfd.sfd09='1'  #CHI-C60023
         LET l_sfd.sfduser = g_user        #FUN-D10127
         LET l_sfd.sfdgrup = g_grup        #FUN-D10127
         LET  l_sfd.sfddate = g_today       #FUN-D10127
         LET  l_sfd.sfdacti ='Y'            #FUN-D10127
         LET  l_sfd.sfdoriu = g_user        #FUN-D10127
         LET  l_sfd.sfdorig = g_grup        #FUN-D10127
         INSERT INTO sfd_file VALUES(l_sfd.*)
         UPDATE sfb_file SET sfb85=l_sfd.sfd01 WHERE sfb01=l_sfd.sfd03  #TQC-C60146 add
      END FOR
   END IF
   COMMIT WORK       #No:7829
 
   INPUT BY NAME tm.* WITHOUT DEFAULTS
      AFTER FIELD from_w
         IF tm.from_w IS NULL THEN NEXT FIELD from_w END IF
         IF tm.from_w IS NOT NULL THEN
            SELECT imd02 INTO l_imd02 FROM imd_file  WHERE imd01 = tm.from_w
            IF STATUS THEN
               CALL cl_err3("sel","imd_file",tm.from_w,"",STATUS,"","sel imd",0)    #No.FUN-660128
                 NEXT FIELD from_w  
            END IF
            #Add No.FUN-AB0049
            IF NOT s_chk_ware(tm.from_w) THEN  #检查仓库是否属于当前门店
               NEXT FIELD from_w
            END IF
            #End Add No.FUN-AB0049
         END IF
      AFTER FIELD to_w
         IF tm.to_w IS NULL THEN NEXT FIELD to_w END IF
         IF tm.to_w IS NOT NULL THEN
            SELECT imd02 INTO l_imd02 FROM imd_file  WHERE imd01 = tm.to_w
            IF STATUS THEN
               CALL cl_err3("sel","imd_file",tm.to_w,"",STATUS,"","sel imd",0)    #No.FUN-660128
                 NEXT FIELD to_w                  
            END IF
            #Add No.FUN-AB0049
            IF NOT s_chk_ware(tm.to_w) THEN  #检查仓库是否属于当前门店
               NEXT FIELD to_w
            END IF
            #End Add No.FUN-AB0049
         END IF
 
      AFTER FIELD from_l
         IF tm.from_l IS NULL THEN LET tm.from_l = ' ' END IF
 
      AFTER FIELD to_l
         IF tm.to_l IS NULL THEN LET tm.to_l = ' ' END IF
 
      AFTER FIELD tr_no
         IF tm.tr_no IS NOT NULL THEN
            CALL s_get_doc_no(tm.tr_no) RETURNING g_t1
            CALL s_check_no("aim",tm.tr_no,"","4","","","") RETURNING li_result,tm.tr_no
            IF (NOT li_result) THEN
               CALL cl_err(g_t1,g_errno,0)
               NEXT FIELD tr_no
            END IF
         END IF
 
      AFTER FIELD a
         IF cl_null(tm.a) OR tm.a NOT MATCHES '[YN]' THEN
            NEXT FIELD a
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
         ON ACTION controlp
          CASE WHEN INFIELD(tr_no) #查詢單据
                 LET  g_t1=s_get_doc_no(tm.tr_no) 
                 CALL q_smy(FALSE,FALSE,g_t1,'AIM','4') RETURNING g_t1  
                 LET  tm.tr_no=g_t1                     
                 DISPLAY BY NAME tm.tr_no
                 NEXT FIELD tr_no
               WHEN INFIELD(from_w) 
                #Mod No.FUN-AB0049
                #CALL cl_init_qry_var()
                #LET g_qryparam.form     = "q_imd"
                #LET g_qryparam.default1 = tm.from_w
                #LET g_qryparam.arg1     = 'SW'        #倉庫類別 
                #CALL cl_create_qry() RETURNING tm.from_w
                 CALL q_imd_1(FALSE,TRUE,tm.from_w,"",g_plant,"","")  #只能开当前门店的
                      RETURNING tm.from_w
                #End Mod No.FUN-AB0049
                 DISPLAY BY NAME tm.from_w
                 NEXT FIELD from_w
               WHEN INFIELD(from_l) 
                 #Mod No.FUN-AB0049
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_ime"
                 #LET g_qryparam.default1 = tm.from_l
                 #LET g_qryparam.arg1     = tm.from_w  #倉庫編號 
                 #LET g_qryparam.arg2     = 'SW'        #倉庫類別 
                 #CALL cl_create_qry() RETURNING tm.from_l
                  CALL q_ime_1(FALSE,TRUE,tm.from_l,tm.from_w,"",g_plant,"","","")
                       RETURNING tm.from_l
                 #End Mod No.FUN-AB0049
                  DISPLAY BY NAME tm.from_l
                  NEXT FIELD from_l 
               WHEN INFIELD(to_w) 
                 #Mod No.FUN-AB0049
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_imd"
                 #LET g_qryparam.default1 = tm.to_w
                 #LET g_qryparam.arg1     = 'SW'        #倉庫類別 
                 #CALL cl_create_qry() RETURNING tm.to_w
                 CALL q_imd_1(FALSE,TRUE,tm.to_w,"",g_plant,"","")  #只能开当前门店的
                      RETURNING tm.to_w
                 #End Mod No.FUN-AB0049
                  DISPLAY BY NAME tm.to_w
                  NEXT FIELD to_w
               WHEN INFIELD(to_l)
                 #Mod No.FUN-AB0049
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form     = "q_ime"
                 #LET g_qryparam.default1 = tm.to_l
                 #LET g_qryparam.arg1     = tm.to_w  #倉庫編號 
                 #LET g_qryparam.arg2     = 'SW'        #倉庫類別 
                 #CALL cl_create_qry() RETURNING tm.to_l
                  CALL q_ime_1(FALSE,TRUE,tm.to_l,tm.to_w,"",g_plant,"","","")
                       RETURNING tm.to_l
                 #End Mod No.FUN-AB0049
                  DISPLAY BY NAME tm.to_l
                  NEXT FIELD to_l 
             END CASE
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
      LET INT_FLAG = 0 CLOSE WINDOW r204_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
         
   END IF
   IF tm.b_seq IS NULL THEN LET tm.b_seq = ' ' END IF
   IF tm.e_seq IS NULL THEN LET tm.e_seq = 'z' END IF
   IF tm.b_keeper IS NULL THEN LET tm.b_keeper = ' ' END IF
   IF tm.e_keeper IS NULL THEN LET tm.e_keeper = 'z' END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfr204'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfr204','9031',1)  
      ELSE
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.order_sw CLIPPED,"'"
         CALL cl_cmdat('asfr204',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW r204_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL r204()
   ERROR ""
END WHILE
   CLOSE WINDOW r204_w
END FUNCTION
 
FUNCTION r204_gen()
   DEFINE l_sql         LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(1000)
   DEFINE l_wc          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(600)
   DEFINE l_sfb01	LIKE sfb_file.sfb01          #No.FUN-550067
   DEFINE i,j		LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
   OPEN WINDOW r204_gen_w AT 10,25
        WITH FORM "asf/42f/asfr203a"
    ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asfr203a")
 
   CONSTRUCT BY NAME l_wc ON sfb01,sfb81,sfb05,sfb82
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE CONSTRUCT
 
   END CONSTRUCT
 
   CLOSE WINDOW r204_gen_w
   IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
   LET l_sql="SELECT sfb01 FROM sfb_file WHERE ",l_wc CLIPPED,
             #"   AND sfb08>sfb081 AND sfb87!='X' "   #CHI-C60023
             "   AND sfb08>sfb081 AND sfb87 = 'Y' ",  #CHI-C60023
             "   AND sfbacti = 'Y' AND sfb04 = '2' "  #CHI-C60023
 
    LET l_sql = l_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
 
   PREPARE r204_gen_p FROM l_sql
   DECLARE r204_gen_c CURSOR FOR r204_gen_p
   FOREACH r204_gen_c INTO l_sfb01
      FOR i=1 TO 120
         IF g_no[i]=l_sfb01 THEN CONTINUE FOREACH END IF
      END FOR
      FOR i=1 TO 120
         IF g_no[i] IS NULL THEN LET g_no[i]=l_sfb01 CONTINUE FOREACH END IF
      END FOR
   END FOREACH
   FOR i=120 TO 1 STEP -1 IF g_no[i] IS NOT NULL THEN EXIT FOR END IF END FOR
   LET g_rec_b=i
   CALL SET_COUNT(g_rec_b)
END FUNCTION
 
FUNCTION r204()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
          l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680121 VARCHAR(600)
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_sfb	    RECORD LIKE sfb_file.*,
          l_cnt     LIKE type_file.num5,                    #No.FUN-680121 SMALLINT
          sr            RECORD order1	LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
                               ima23	LIKE ima_file.ima23,
                               sfa03	LIKE sfa_file.sfa03,
                               sfa26	LIKE sfa_file.sfa26,
                               ima02	LIKE ima_file.ima02,
                               ima108   LIKE ima_file.ima108,
                               ima63	LIKE ima_file.ima63, #TQC-6A0048 add
                               ima64	LIKE ima_file.ima64,
                               ima641	LIKE ima_file.ima641,
                               sfa12	LIKE sfa_file.sfa12,
                               sfa05	LIKE sfa_file.sfa05
                        END RECORD
DEFINE  li_result       LIKE type_file.num5
DEFINE  to_qty,from_qty	LIKE ima_file.ima64                
DEFINE  l_bml		RECORD LIKE bml_file.*                      
DEFINE  l_imm		RECORD LIKE imm_file.*
DEFINE  l_imn		RECORD LIKE imn_file.*
DEFINE  l_ima01	LIKE ima_file.ima01
DEFINE  l_ima02	LIKE ima_file.ima02
DEFINE  l_bmd01	LIKE bmd_file.bmd01
DEFINE  l_bmd02	LIKE bmd_file.bmd02
DEFINE  l_bmd04	LIKE bmd_file.bmd04
DEFINE  l_bmd07	LIKE bmd_file.bmd07
DEFINE  l_bmd08	LIKE bmd_file.bmd08
#DEFINE  l_ima262	LIKE ima_file.ima262 
DEFINE  l_avl_stk LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044 
#DEFINE  l_qty   	LIKE ima_file.ima262     
DEFINE  l_qty     LIKE type_file.num15_3    ###GP5.2  #NO.FUN-A20044
DEFINE  k		LIKE type_file.num10
DEFINE  l_count         LIKE type_file.num10        #MOD-840400  
DEFINE  l_count1        LIKE type_file.num10        #MOD-840400  
DEFINE  l_keeper        LIKE ima_file.ima23         #MOD-850308 add
DEFINE  l_n1            LIKE type_file.num15_3      ###GP5.2  #NO.FUN-A20044
DEFINE  l_n2            LIKE type_file.num15_3      ###GP5.2  #NO.FUN-A20044
DEFINE  l_n3            LIKE type_file.num15_3      ###GP5.2  #NO.FUN-A20044 
DEFINE  l_imni  RECORD  LIKE imni_file.*            #FUN-B70074
 
   CALL cl_del_data(l_table)
   CALL cl_del_data(l_table1)
   CALL cl_del_data(l_table2)
   CALL cl_del_data(l_table3)
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                  
               " VALUES(?,?,?,?,?, ?,?,?,?,?,",
               "        ?,?,?,?,?, ?,?,?,?,?)"                                                                                  
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM                                                                             
   END IF 
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table1 CLIPPED,
               " VALUES(?,?,?)"
   PREPARE insert_prep1 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep1:',status,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table2 CLIPPED,
               " VALUES(?,?,?,?,?, ?,?,?)" 
   PREPARE insert_prep2 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep2:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF   
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table3 CLIPPED,
               " VALUES(?,?,?,?)"
   PREPARE insert_prep3 FROM g_sql
   IF STATUS THEN 
      CALL cl_err('insert_prep3:',status,1)
      CALL cl_used(g_prog,g_time,2) RETURNING g_time           #FUN-B80086   ADD
      EXIT PROGRAM
   END IF 
   SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = 'asfr204'                     
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang
      FOR g_cnt=1 TO g_rec_b
         IF g_no[g_cnt] IS NULL THEN CONTINUE FOR END IF
         SELECT * INTO l_sfb.* FROM sfb_file WHERE sfb01=g_no[g_cnt]
	 LET g_part[g_cnt]=l_sfb.sfb05
      LET ss[g_cnt]= g_no[g_cnt],8 SPACES
      LET ss2[g_cnt]= l_sfb.sfb05,1 SPACES
                       
         LET ss1[g_cnt]=(l_sfb.sfb08-l_sfb.sfb081) USING '-------&'
      END FOR
     BEGIN WORK
     LET g_success='Y'
     LET g_pageno=1                                        #MOD-850308 add
      IF cl_null(tm.b_keeper) THEN
         SELECT MIN(ima23) INTO tm.b_keeper FROM ima_file 
          WHERE ima23 <> ' '
         LET l_keeper = ' '
      ELSE 
         LET l_keeper = tm.b_keeper
      END IF
     FOR l_cnt=1 TO 120
         IF g_no[l_cnt] IS NULL THEN CONTINUE FOR END IF
         DECLARE r204_sfa_c CURSOR FOR
                  SELECT ' ',ima23,sfa03,sfa26,ima02,ima108,ima63,ima64,ima641, #增ima23 #TQC-6A0048 add ima63
                         sfa12,SUM(sfa05-sfa06)
                    FROM sfa_file, sfb_file, ima_file
                   WHERE sfa01=g_no[l_cnt] AND sfa03=ima01
                     AND sfa05>sfa06 AND sfb01=sfa01 AND sfb87!='X'
                     AND sfa08 BETWEEN tm.b_seq AND tm.e_seq
                     AND ((ima23 BETWEEN tm.b_keeper AND tm.e_keeper) OR ima23=l_keeper OR ima23 IS NULL )   #MOD-850308  #MOD-D30172
                  GROUP BY ima23,sfa03,sfa26,ima02,ima108,ima63,ima64,ima641,sfa12
                  ORDER BY ima23,sfa03
            IF NOT cl_null(tm.tr_no) AND g_pageno=1 THEN
               INITIALIZE l_imm.* TO NULL
               LET g_pageno = 0          #MOD-850308 add
               IF tm.tr_no[g_no_sp,g_no_ep] IS NOT NULL AND tm.tr_no[g_no_sp,g_no_ep]<>' ' THEN
                  CALL s_get_doc_no(tm.tr_no) RETURNING tm.tr_no
               END IF
               CALL s_auto_assign_no("aim",tm.tr_no,tm.tr_date,"","","","","","")
                  RETURNING li_result,tm.tr_no
               IF (NOT li_result) THEN
                  LET g_success = 'N'
               END IF
               DISPLAY BY NAME tm.tr_no
               LET l_imm.imm01=tm.tr_no
               LET l_imm.imm02=tm.tr_date
               LET l_imm.imm03='N'
               LET l_imm.imm04='N'
               LET l_imm.immconf='Y' 
               LET l_imm.imm07=0
               LET l_imm.imm10='1'
               LET l_imm.immacti='Y'
               LET l_imm.immuser=g_user
               LET l_imm.immgrup=g_grup
               LET l_imm.immplant = g_plant #FUN-980008 add
               LET l_imm.immlegal = g_legal #FUN-980008 add
 
               INITIALIZE l_imn.* TO NULL
               LET l_imn.imn02=0
               LET l_imm.imm14=g_grup 
               LET l_imm.immoriu = g_user      #No.FUN-980030 10/01/04
               LET l_imm.immorig = g_grup      #No.FUN-980030 10/01/04
               #FUN-A60034--add---str---
               #FUN-A70104--add---str---
               LET l_imm.immmksg = 'N'          #是否簽核
               LET l_imm.imm15 = '0'            #簽核狀況
               LET l_imm.imm16 = g_user         #申請人
               #FUN-A70104--add---end---
               #FUN-A60034--add---end---
               INSERT INTO imm_file VALUES(l_imm.*)
               IF STATUS THEN
                  CALL cl_err3("ins","imm_file",l_imm.imm01,"",STATUS,"","ins imm:",1)    
                  LET g_success='N'
               END IF
            END IF
         FOREACH r204_sfa_c INTO sr.*
            IF tm.order_sw='N' THEN LET sr.ima23=' ' END IF
            IF tm.a = 'N' OR sr.ima108 = 'Y' THEN
            FOR g_cnt=3 TO 100
               IF ss[g_cnt] IS NULL THEN EXIT FOR END IF
               EXECUTE insert_prep3 USING sr.order1,ss[g_cnt],ss2[g_cnt],ss1[g_cnt]
            END FOR
       
            LET from_qty = 0 #MOD-860280 add
            LET to_qty   = 0 #MOD-860280 add
            LET l_qty=sr.sfa05
            SELECT SUM(img10*img21) INTO to_qty FROM img_file   #MOD-940312
             WHERE img01=sr.sfa03 AND img02=tm.from_w
               AND img03=tm.from_l
            IF to_qty IS NULL THEN LET to_qty=0 END IF
            IF to_qty >= l_qty THEN         #若WIP庫存不足才發料
               IF sr.ima64 != 0 THEN        #發料倍數
                  LET k = (l_qty / sr.ima64) + 0.999
                  LET l_qty = sr.ima64 * k
               END IF
               IF l_qty < sr.ima641 THEN       #最小發料量
                  LET l_qty = sr.ima641
               END IF
               IF to_qty IS NULL THEN LET to_qty=0 END IF
                  IF tm.tr_no IS NOT NULL THEN
                    SELECT count(*) INTO l_count FROM imn_file
                     WHERE imn01 = tm.tr_no
                       AND imn02 = l_imn.imn02 + 1
                    SELECT MAX(imn02) INTO l_count1 FROM imn_file
                     WHERE imn01 = tm.tr_no
                    IF l_count > 0 THEN 
                       LET l_imn.imn01 = tm.tr_no
                       LET l_imn.imn02 = l_count1+1
                    ELSE
                       LET l_imn.imn01=tm.tr_no
                       LET l_imn.imn02=l_imn.imn02+1
                    END IF                      #MOD-840400        
                  LET l_imn.imn03=sr.sfa03
                  LET l_imn.imn04=tm.from_w
                  LET l_imn.imn05=tm.from_l
                  LET l_imn.imn06=' '
                  LET l_imn.imn09=NULL
                  #SELECT ima25 INTO l_imn.imn09 FROM ima_file WHERE ima01=sr.sfa03  #MOD-D30172
                  SELECT ima25,ima24 INTO l_imn.imn09,l_imn.imn29 FROM ima_file WHERE ima01=sr.sfa03  #MOD-D30172
                  LET l_imn.imn10=l_qty        #NO.FUN-7C0081
                  LET l_imn.imn10=s_digqty(l_imn.imn10,l_imn.imn09)   #FUN-BB0084 
                  LET l_imn.imn15=tm.to_w
                  LET l_imn.imn16=tm.to_l
                  LET l_imn.imn17=' '
                  LET l_imn.imn20=sr.ima63    
                  LET l_imn.imn21=1
                  LET l_imn.imn22=l_imn.imn10*l_imn.imn21
                  LET l_imn.imn22=s_digqty(l_imn.imn22,l_imn.imn20)    #FUN-BB0084
                  IF g_sma.sma115 = 'Y' THEN
                     SELECT ima906,ima907 INTO g_ima906,g_ima907 FROM ima_file
                      WHERE ima01=l_imn.imn03
                     IF SQLCA.sqlcode =100 THEN
                        IF l_imn.imn03 MATCHES 'MISC*' THEN
                           SELECT ima906,ima907 INTO g_ima906,g_ima907
                             FROM ima_file WHERE ima01='MISC'
                        END IF
                     END IF
                     LET g_img09 = NULL
                     SELECT img09 INTO g_img09 FROM img_file
                      WHERE img01=l_imn.imn03  AND img02=l_imn.imn04
                        AND img03=l_imn.imn05  AND img04=l_imn.imn06
                     IF cl_null(g_img09) THEN LET g_img09=l_imn.imn09 END IF
                     LET l_imn.imn30 = l_imn.imn09
                     LET g_factor = 1
                     CALL s_umfchk(l_imn.imn03,l_imn.imn30,g_img09)
                        RETURNING g_cnt1,g_factor
                     IF g_cnt1 = 1 THEN
                        LET g_factor = 1
                     END IF
                     LET l_imn.imn31 = g_factor
                     LET l_imn.imn32 = l_imn.imn10
                     LET l_imn.imn33 = g_ima907
                     LET g_factor = 1
                     CALL s_umfchk(l_imn.imn03,l_imn.imn33,g_img09)
                        RETURNING g_cnt1,g_factor
                     IF g_cnt1 = 1 THEN
                        LET g_factor = 1
                     END IF
                     LET l_imn.imn34 = g_factor
                     LET l_imn.imn35 = 0
                     IF g_ima906 = '3' THEN
                        LET g_factor = 1
                        CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn33)
                           RETURNING g_cnt1,g_factor
                        IF g_cnt1 = 1 THEN
                           LET g_factor = 1
                        END IF
                        LET l_imn.imn35=l_imn.imn32*g_factor
                        LET l_imn.imn35=s_digqty(l_imn.imn35,l_imn.imn33)     #FUN-BB0084
                     END IF
                     #---------------------目的---------------------
                     LET g_img09 = NULL
                     SELECT img09 INTO g_img09 FROM img_file
                      WHERE img01=l_imn.imn03  AND img02=l_imn.imn15
                        AND img03=l_imn.imn16  AND img04=l_imn.imn17
                     IF cl_null(g_img09) THEN LET g_img09=l_imn.imn09 END IF
                     LET l_imn.imn40 = l_imn.imn09
                     LET g_factor = 1
                     CALL s_umfchk(l_imn.imn03,l_imn.imn40,g_img09)
                        RETURNING g_cnt1,g_factor
                     IF g_cnt1 = 1 THEN
                        LET g_factor = 1
                     END IF
                     LET l_imn.imn41 = g_factor
                     LET l_imn.imn42 = l_imn.imn22
                     LET l_imn.imn42 = s_digqty(l_imn.imn42,l_imn.imn40)  #FUN-BB0084
                     LET l_imn.imn43 = g_ima907
                     LET g_factor = 1
                     CALL s_umfchk(l_imn.imn03,l_imn.imn43,g_img09)
                        RETURNING g_cnt1,g_factor
                     IF g_cnt1 = 1 THEN
                        LET g_factor = 1
                     END IF
                     LET l_imn.imn44 = g_factor
                     LET l_imn.imn45 = 0
                     IF g_ima906 = '3' THEN
                        LET g_factor = 1
                        CALL s_umfchk(l_imn.imn03,l_imn.imn40,l_imn.imn43)
                           RETURNING g_cnt1,g_factor
                        IF g_cnt1 = 1 THEN
                           LET g_factor = 1
                        END IF
                        LET l_imn.imn45=l_imn.imn42*g_factor
                        LET l_imn.imn45=s_digqty(l_imn.imn45,l_imn.imn43)   #FUN-BB0084 
                     END IF
                     #---------------轉換率-------------------
                     LET g_factor = 1
                     CALL s_umfchk(l_imn.imn03,l_imn.imn30,l_imn.imn40)
                        RETURNING g_cnt1,g_factor
                     IF g_cnt1 = 1 THEN
                        LET g_factor = 1
                     END IF
                     LET l_imn.imn51=g_factor
                     LET g_factor = 1
                     CALL s_umfchk(l_imn.imn03,l_imn.imn33,l_imn.imn43)
                        RETURNING g_cnt1,g_factor
                     IF g_cnt1 = 1 THEN
                        LET g_factor = 1
                     END IF
                     LET l_imn.imn52=g_factor
                  END IF
                  LET l_imn.imn9301=s_costcenter(l_imm.imm14) #FUN-680006
                  LET l_imn.imn9302=l_imn.imn9301  #FUN-680006
                  LET l_imn.imnplant = g_plant #FUN-980008 add
                  LET l_imn.imnlegal = g_legal #FUN-980008 add
                  INSERT INTO imn_file VALUES(l_imn.*)
                  IF STATUS THEN 
                     CALL cl_err3("ins","imn_file",l_imn.imn01,l_imn.imn02,STATUS,"","ins imn:",1)    #No.FUN-660128
                     LET g_success='N'   #No.FUN-660128             
                  #FUN-B70074-add-str--
                  ELSE
                     IF NOT s_industry('std') THEN 
                        INITIALIZE l_imni.* TO NULL
                        LET l_imni.imni01 = l_imn.imn01
                        LET l_imni.imni02 = l_imn.imn02
                        IF NOT s_ins_imni(l_imni.*,l_imn.imnplant) THEN 
                           LET g_success = 'N'
                        END IF
                     END IF
                  #FUN-B70074-add-end--
                  END IF
               END IF
               SELECT SUM(img10*img21) INTO from_qty FROM img_file   #MOD-940312
                WHERE img01=sr.sfa03 AND img02=tm.from_w
                  AND img03=tm.from_l
               IF tm.QVL_flag='Y' THEN
                  DECLARE r204_QVL_c CURSOR FOR
                     SELECT * FROM bml_file WHERE bml01 = sr.sfa03 ORDER BY bml03
                  FOREACH r204_QVL_c INTO l_bml.*
                     FOR g_i=1 TO 100
                        IF l_bml.bml02='ALL' OR l_bml.bml02=g_part[g_i] THEN
                           EXIT FOR
                        END IF
                     END FOR
                     IF g_i=100 THEN CONTINUE FOREACH END IF
                     EXECUTE insert_prep1 USING l_bml.bml01,l_bml.bml03,l_bml.bml04
                  END FOREACH
               END IF
               IF sr.sfa26 MATCHES '[123478]' AND  #FUN-A20037 add '7,8'
                  (tm.SUB_flag='2' OR (tm.SUB_flag='3' AND l_qty>from_qty)) THEN
                  DECLARE r204_SUB_c CURSOR FOR
#                    SELECT bmd01,bmd02,bmd04,bmd07,bmd08,ima01,ima02,ima262 FROM bmd_file, ima_file  #NO.FUN-A20044
                     SELECT bmd01,bmd02,bmd04,bmd07,bmd08,ima01,ima02,0 FROM bmd_file, ima_file       #NO.FUN-A20044 
                      WHERE bmd01 = sr.sfa03 AND bmd04=ima01
                        AND bmdacti = 'Y'                                           #CHI-910021
                      GROUP BY bmd02,bmd04,bmd07,bmd08
                      ORDER BY bmd04
                  FOREACH r204_SUB_c INTO l_bmd01,l_bmd02,l_bmd04,l_bmd07,l_bmd08,
#                                         l_ima01,l_ima02,l_ima262    #NO.FUN-A20044
                                          l_ima01,l_ima02,l_avl_stk   #NO.FUN-A20044
#                    IF l_ima262<=0 THEN CONTINUE FOREACH END IF      #NO.FUN-A20044
                     CALL s_getstock(l_bmd04,g_plant) RETURNING  l_n1,l_n2,l_n3  ###GP5.2  #NO.FUN-A20044
                     LET l_avl_stk = l_n3                             #NO.FUN-A20044
                     IF l_avl_stk<=0 THEN CONTINUE FOREACH END IF     #NO.FUN-A20044
                     FOR g_i=1 TO 100
                        IF l_bmd08='ALL' OR l_bmd08=g_part[g_i] THEN
                           EXIT FOR
                        END IF
                     END FOR
                     IF g_i>=100 THEN CONTINUE FOREACH END IF
                     EXECUTE insert_prep2 USING 
                        l_bmd01,l_bmd02,l_bmd04,l_bmd07,l_bmd08,
#                       l_ima01,l_ima02,l_ima262                      #NO.FUN-A20044  
                        l_ima01,l_ima02,l_avl_stk                     #NO.FUN-A20044  
                  END FOREACH
               END IF
               EXECUTE insert_prep USING 
                  sr.order1,sr.ima23,sr.sfa03,sr.sfa26,sr.ima02,sr.ima108,sr.ima63,
                  sr.ima64,sr.ima641,sr.sfa12,sr.sfa05,to_qty,from_qty,l_qty,
                  ss[1],ss[2],ss2[1],ss2[2],ss1[1],ss1[2]
            ELSE                                               #NO.FUN-7C0081
              #-------------------No:TQC-A50156 add                             
               SELECT SUM(img10*img21) INTO from_qty FROM img_file              
                WHERE img01=sr.sfa03 AND img02=tm.from_w                        
                  AND img03=tm.from_l                                           
              #-------------------No:TQC-A50156 end  
               EXECUTE insert_prep USING 
                  sr.order1,sr.ima23,sr.sfa03,sr.sfa26,sr.ima02,sr.ima108,sr.ima63,
                  sr.ima64,sr.ima641,sr.sfa12,sr.sfa05,to_qty,from_qty,l_qty,
                  ss[1],ss[2],ss2[1],ss2[2],ss1[1],ss1[2]
            END IF
            END IF
         END FOREACH
     END FOR
     LET g_sql = " SELECT  * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,"|",         #MOD-870324
                 " SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table1 CLIPPED,"|",
                 " SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table2 CLIPPED,"|",
                 " SELECT DISTINCT * FROM ",g_cr_db_str CLIPPED,l_table3 CLIPPED
     LET g_str ='tm.order_sw',";",tm.tr_no,";",tm.from_w,";",tm.to_w,";",tm.from_l,";",
                 tm.to_l,";",g_sfc01,";",tm.SUB_flag
     CALL cl_prt_cs3('asfr204','asfr204',g_sql,g_str)
     IF g_success='Y' THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
     IF tm.tr_no IS NOT NULL AND g_success='Y' THEN
        LET g_msg="aimt324 '",tm.tr_no,"'"
        CALL cl_cmdrun_wait(g_msg)  #FUN-660216 add
     END IF
END FUNCTION
#NO.FUN-9C0072 精簡程式碼

# Prog. Version..: '5.30.07-13.05.16(00001)'     #
#
# Pattern name...: asfx540.4gl
# Descriptions...: 工單用料備料用量差異表
# Date & Author..: 91/12/14 By Keith
# Modify.........: No.FUN-4B0043 04/11/15 By Nicola 加入開窗功能
# Modify.........: NO.FUN-510029 05/01/13 By Carol 修改報表架構轉XML,數量type '###.--' 改為 '---.--' 顯示
# Modify.........: No.TQC-5B0111 05/11/12 By Carol 單頭品名規格欄位放大,位置調整
# Modify.........: No.MOD-590036 05/12/15 By pengu  abmi600的工單開立展開選項若選了3.展開
                                     #              但報表會擷取不到下階料件資料
# Modify.........: No.TQC-610080 06/03/03 By Claire 接收的外部參數定義完整, 並與呼叫背景執行(p_cron)所需 mapping 的參數條件一致
# Modify.........: No.FUN-680121 06/08/31 By huchenghao 類型轉換
# Modify.........: No.FUN-690123 06/10/16 By czl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.MOD-6A0125 06/10/27 By eric757 因發料asfi501  已將sfe06異動別改為1,2,3,4 需調整 asfx540,asfr550 倒扣料程式段
# Modify.........: No.FUN-6A0090 06/11/07 By douzh l_time轉g_time
# Modify.........: No.TQC-710016 07/01/08 By ray "接下頁"和"結束"位置有誤
# Modify.........: No.FUN-750098 07/06/23 By hongmei Crystal Report修改
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20037 10/03/16 By lilingyu 替代碼sfa26加上"7,8,Z"的條件
# Modify.........: No.FUN-A60027 10/06/12 By vealxu 製造功能優化-平行制程（批量修改） 
# Modify.........: No.FUN-BB0047 11/12/30 By fengrui  調整時間函數問題
# Modify.........: No.CHI-C60014 12/07/12 By Elise 傳入BOM單位對備料單位的轉換率給報表
# Modify.........: No.FUN-CB0001 12/11/08 By yangtt CR轉XtraGrid

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                #Print condition RECORD
#             wc      VARCHAR(600),    #Where condition    #TQC-630166
              wc      STRING,       #Where condition    #TQC-630166
              a       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#是否只列印已完工工單
              b       LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)#是否只列印有差異料件
              more    LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1)#是否輸入其它特殊列印條件?
              END RECORD
DEFINE   g_i             LIKE type_file.num5     #count/index for any purpose        #No.FUN-680121 SMALLINT
DEFINE   g_str           STRING       #No.FUN-750098                                                                                
DEFINE   l_table         STRING       #No.FUN-750098                                                                                
DEFINE   g_sql           STRING       #No.FUN-750098
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
#No.FUN-750098-------Begin                                                                                                       
   LET g_sql = "sfb01.sfb_file.sfb01,",
               "sfa03.sfa_file.sfa03,",
               "ima02.ima_file.ima02,",
               "ima021.ima_file.ima021,",
               "sfb08.sfb_file.sfb08,",
               "sfa16.sfa_file.sfa16,",
               "exhaust.sfa_file.sfa04,",
               "sfa05.sfa_file.sfa05,",
               "sfa06.sfa_file.sfa06,",
               "sfb04.sfb_file.sfb04,",
               "sfb02.sfb_file.sfb02,",
               "sfb13.sfb_file.sfb13,",
               "sfb15.sfb_file.sfb15,",
               "sfb36.sfb_file.sfb36,",
               "sfb05.sfb_file.sfb05,",
               "ima55.ima_file.ima55,",
               "l_ima02.ima_file.ima02,",
               "l_ima021.ima_file.ima021,",
               "sfb39.sfb_file.sfb39,",
               "sfa012.sfa_file.sfa012,",    #FUN-A60027
               "sfa013.sfa_file.sfa013,",    #FUN-A60027
               "l_factor.bmb_file.bmb10_fac,",#CHI-C60014
               #FUN-CB0001---yangtt--str---
               "sfb02_1.type_file.chr100,",
               "sfb04_1.type_file.chr100,",
               "l_sfb39.type_file.chr100,",
               "b_amt.sfb_file.sfb08,",
               "l_rate.bgh_file.bgh08,",
               "w_amt.sfa_file.sfa05,",
               "l_amt1.sfa_file.sfa04,",
               "l_num1.type_file.num5,",
               "l_num2.type_file.num5"
               #FUN-CB0001---yangtt--end---
    
   LET l_table = cl_prt_temptable('asfx540',g_sql) CLIPPED                                                                          
   IF l_table = -1 THEN EXIT PROGRAM END IF                                                                                         
   LET g_sql = "INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,                                                                            
               " VALUES(?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,",
               "        ?, ?, ?, ?, ?,  ?, ?, ?, ?, ?,?) "   #FUN-A60027 add 2?  #CHI-C60014 add ?  #FUN-CB0001 add 9?
                                                                             
   PREPARE insert_prep FROM g_sql                                                                                                   
   IF STATUS THEN                                                                                                                   
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM                                                                             
   END IF                                                                                                                           
#No.FUN-750098---------End  
 
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #FUN-BB0047 add
   LET g_pdate = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc = ARG_VAL(7)
  #LET tm.more  = ARG_VAL(8)  #TQC-610080 以下順序調整
   LET tm.a     = ARG_VAL(8)
   LET tm.b     = ARG_VAL(9)
   #No.FUN-570264 --start--
   LET g_rep_user = ARG_VAL(10)
   LET g_rep_clas = ARG_VAL(11)
   LET g_template = ARG_VAL(12)
   LET g_rpt_name = ARG_VAL(13)  #No.FUN-7C0078
   #No.FUN-570264 ---end---
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL asfx540_tm(0,0)        # Input print condition
      ELSE CALL asfx540()            # Read data and create out-file
   END IF
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
END MAIN
 
FUNCTION asfx540_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   #No.FUN-580031
   DEFINE p_row,p_col    LIKE type_file.num5,         #No.FUN-680121 SMALLINT
          l_cmd          LIKE type_file.chr1000       #No.FUN-680121 VARCHAR(400)
 
   IF p_row = 0 THEN
      LET p_row = 4 LET p_col = 10
   END IF
   IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
      LET p_row = 5 LET p_col = 20
   ELSE LET p_row = 4 LET p_col = 10
   END IF
   OPEN WINDOW asfx540_w AT p_row,p_col
        WITH FORM "asf/42f/asfx540"
################################################################################
# START genero shell script ADD
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET tm.a       = 'Y'
   LET tm.b       = 'Y'
   LET tm.more    = 'N'
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
WHILE TRUE
   CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb85
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP    #FUN-4B0043
           IF INFIELD(sfb05) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ima"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb05
              NEXT FIELD sfb05
           END IF
           #FUN-CB0001-----add---str--
           IF INFIELD(sfb01) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_sfb"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb01
              NEXT FIELD sfb01
           END IF
           IF INFIELD(sfb85) THEN
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_sfb85_1"
              LET g_qryparam.state = "c"
              CALL cl_create_qry() RETURNING g_qryparam.multiret
              DISPLAY g_qryparam.multiret TO sfb85
              NEXT FIELD sfb85
           END IF
           #FUN-CB0001-----add---end--
#No.FUN-750098-------Begin
        ON ACTION CONTROLG
              CALL cl_cmdask()    
#No.FUN-750098-------End
        ON ACTION locale
             #CALL cl_dynamic_locale()
              CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
              LET g_action_choice = "locale"
              EXIT CONSTRUCT
 
   ON IDLE g_idle_seconds
      CALL cl_on_idle()
      CONTINUE CONSTRUCT
      ON ACTION help          #FUN-CB0001
         CALL cl_show_help()  #GUN-CB0001
 
           ON ACTION exit
           LET INT_FLAG = 1
           EXIT CONSTRUCT
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
END CONSTRUCT
       IF g_action_choice = "locale" THEN
          LET g_action_choice = ""
          CALL cl_dynamic_locale()
          CONTINUE WHILE
       END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfx540_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF tm.wc=" 1=1 " THEN
      CALL cl_err(' ','9046',0)
      CONTINUE WHILE
   END IF
   DISPLAY BY NAME tm.a,tm.b,tm.more      # Condition
   INPUT BY NAME tm.a,tm.b,tm.more WITHOUT DEFAULTS
         #No.FUN-580031 --start--
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
      AFTER FIELD a
         IF tm.a NOT MATCHES "[YN]" OR cl_null(tm.a)
            THEN NEXT FIELD a
         END IF
      AFTER FIELD b
         IF tm.b NOT MATCHES "[YN]" OR cl_null(tm.b)
            THEN NEXT FIELD b
         END IF
      AFTER FIELD more
         IF tm.more NOT MATCHES "[YN]" OR cl_null(tm.more)
            THEN NEXT FIELD more
         END IF
         IF tm.more = "Y" THEN
                 CALL cl_repcon(0,0,g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies)
                      RETURNING g_pdate,g_towhom,g_rlang,
                                g_bgjob,g_time,g_prtway,g_copies
         END IF
################################################################################
# START genero shell script ADD
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
# END genero shell script ADD
################################################################################
      ON ACTION CONTROLG
             CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
          ON ACTION exit
          LET INT_FLAG = 1
          EXIT INPUT
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      CLOSE WINDOW asfx540_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   IF g_bgjob = 'Y' THEN
      SELECT zz08 INTO l_cmd FROM zz_file    #get exec cmd (fglgo xxxx)
             WHERE zz01='asfx540'
      IF SQLCA.sqlcode OR l_cmd IS NULL THEN
         CALL cl_err('asfx540','9031',1)
      ELSE
         LET tm.wc=cl_replace_str(tm.wc, "'", "\"")
         LET l_cmd = l_cmd CLIPPED,        #(at time fglgo xxxx p1 p2 p3)
                         " '",g_pdate CLIPPED,"'",
                         " '",g_towhom CLIPPED,"'",
                         #" '",g_lang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_rlang CLIPPED,"'", #No.FUN-7C0078
                         " '",g_bgjob CLIPPED,"'",
                         " '",g_prtway CLIPPED,"'",
                         " '",g_copies CLIPPED,"'",
                         " '",tm.wc CLIPPED,"'",
                         #" '",tm.more CLIPPED,"'",             #TQC-610080
                         " '",tm.a CLIPPED,"'",
                         " '",tm.b CLIPPED,"'",
                         " '",g_rep_user CLIPPED,"'",           #No.FUN-570264
                         " '",g_rep_clas CLIPPED,"'",           #No.FUN-570264
                         " '",g_template CLIPPED,"'",           #No.FUN-570264
                         " '",g_rpt_name CLIPPED,"'"            #No.FUN-7C0078
 
         CALL cl_cmdat('asfx540',g_time,l_cmd)    # Execute cmd at later time
      END IF
      CLOSE WINDOW asfx540_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
      EXIT PROGRAM
   END IF
   CALL cl_wait()
   CALL asfx540()
   ERROR ""
END WHILE
CLOSE WINDOW asfx540_w
END FUNCTION
 
FUNCTION asfx540()
   DEFINE l_name    LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)# External(Disk) file name
#       l_time          LIKE type_file.chr8        #No.FUN-6A0090
#         l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT  #TQC-630166         #No.FUN-680121 VARCHAR(1200)
          l_sql     STRING,                       # RDSQL STATEMENT  #TQC-630166
          l_chr     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(40)
          l_order   ARRAY[5] OF LIKE ima_file.ima34,        #No.FUN-680121 VARCHAR(10)
          exhaust   LIKE sfa_file.sfa04,          #No.FUN-680121 DECIMAL(12,3)
          l_amt     LIKE sfa_file.sfa04,          #No.FUN-680121 DECIMAL(12,3)
          l_sfa05   LIKE sfa_file.sfa05,         #No.MOD-590036 add
          l_sfa06   LIKE sfa_file.sfa06,         #No.MOD-590036 add
          l_sfa28   LIKE sfa_file.sfa28,         #No.MOD-590036 add
          l_ima02   LIKE ima_file.ima02,         #NO.FUN-750098
          l_ima021  LIKE ima_file.ima021,        #No.FUN-750098`
          sr        RECORD
                       sfb01 LIKE sfb_file.sfb01,
                       sfb04 LIKE sfb_file.sfb04,
                       sfb02 LIKE sfb_file.sfb02,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb39 LIKE sfb_file.sfb39,
                       sfb36 LIKE sfb_file.sfb36,
                       sfb05 LIKE sfb_file.sfb05,
                       ima55 LIKE ima_file.ima55,
                       sfb08 LIKE sfb_file.sfb08,
                     # bmb03 LIKE bmb_file.bmb03,    #No.MOD-590036 mark
                     # bmb06 LIKE bmb_file.bmb06,    #No.MOD-590036 mark
                     # bmb07 LIKE bmb_file.bmb07,    #No.MOD-590036 mark
                     # bmb08 LIKE bmb_file.bmb08,    #No.MOD-590036 mark
                       ima02 LIKE ima_file.ima02,
                       ima021 LIKE ima_file.ima021,
                       sfa05 LIKE sfa_file.sfa05,
                       sfa16 LIKE sfa_file.sfa16,
                       sfa06 LIKE sfa_file.sfa06,
                       sfa03 LIKE sfa_file.sfa03,   #No.MOD-590036 add
                       sfa08 LIKE sfa_file.sfa08,   #No.MOD-590036 add
                       sfa26 LIKE sfa_file.sfa26,   #No.MOD-590036 add
                       sfa012 LIKE sfa_file.sfa012, #No.FUN-A60027
                       sfa013 LIKE sfa_file.sfa013, #No.FUN-A60027
                       l_sfa12  LIKE sfa_file.sfa12,  #CHI-C60014 
                       l_sfa27  LIKE sfa_file.sfa27,  #CHI-C60014
                       l_bmb10  LIKE bmb_file.bmb10,  #CHI-C60014   
                       sfb02_1 LIKE type_file.chr100, #FUN-CB0001
                       sfb04_1 LIKE type_file.chr100  #FUN-CB0001

                    END RECORD 
   DEFINE  l_factor LIKE bmb_file.bmb10_fac,  #CHI-C60014
           l_flag   LIKE type_file.num5       #CHI-C60014 
   #FUN-CB0001---yangtt--str---
   DEFINE  b_amt    LIKE sfb_file.sfb08,
           l_rate   LIKE bgh_file.bgh08,     #損耗率
           w_amt    LIKE sfa_file.sfa05,
           l_amt1   LIKE sfa_file.sfa04,
           l_sfb39  LIKE type_file.chr100,
           l_num1   LIKE type_file.num5,
           l_num2   LIKE type_file.num5
   #FUN-CB0001---yangtt--end---

     CALL cl_del_data(l_table)   #No.FUN-750098
     SELECT zo02 INTO g_company FROM zo_file
               WHERE zo01 = g_rlang
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zz01 = g_prog    #No.FUN-750098 
     LET l_sql = "SELECT sfe06,sfe16 FROM sfe_file ",
                 #"WHERE sfe01 = ? AND sfe07 = ? "                #No.MOD-590036 mark
                 "WHERE sfe01 = ? AND sfe07 = ? AND sfe14 = ? AND sfe012 = ? AND sfe013 = ? "   #No.MOD-590036 add   #FUN-A60027 add sfe012,sfe013
     PREPARE asfx540_pre1 FROM l_sql
     IF STATUS THEN CALL cl_err('',STATUS,0) RETURN END IF
     DECLARE asfx540_cur1 CURSOR FOR asfx540_pre1
     IF STATUS THEN CALL cl_err('',STATUS,0) RETURN END IF
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND sfbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
     #End:FUN-980030
 
 
     #是否只列印已完工工單
     IF tm.a = 'Y' THEN
         LET tm.wc = tm.wc CLIPPED," AND sfb04 ='7' " CLIPPED
     END IF
#----------------No.MOD-590036 begin
     LET l_sql = "SELECT sfb01,sfb04,sfb02,sfb13,sfb15,sfb39, ",
                 " sfb36,sfb05,ima55,sfb08,ima02,ima021,sfa05, ",
                 " sfa16,sfa06,sfa03,sfa08,sfa26,sfa012,sfa013 ",   #FUN-A60027 add sfa012,sfa013
                 " FROM sfb_file,sfa_file,OUTER ima_file ",
                 " WHERE sfa01 = sfb01 AND  sfb_file.sfb05 = ima_file.ima01 ",
                 " AND sfa26 NOT  IN ('6','S','U','Z') ", #FUN-A20037 add 'Z'
                 " AND sfb87 != 'X' ",
                 " AND ",tm.wc CLIPPED, " ORDER BY sfb01,sfa03 "
 
#    LET l_sql = "SELECT sfb01, sfb04, sfb02, sfb13, sfb15, sfb39, ",
#                " sfb36, sfb05, ima55, sfb08, bmb03, bmb06, bmb07, ",
#                " bmb08, ima02,ima021, sfa05,sfa16,sfa06 ",
#                " FROM sfb_file,sfa_file,bmb_file,OUTER ima_file ",
#                " WHERE bmb01 = sfb05 AND bmb03 = sfa03 ",
#                " AND bmb01 = ima01",
#                " AND sfa01 = sfb01",
#                " AND sfb071 >= bmb04 ",  #生效日期
#                " AND (sfb071 < bmb05 ",  #失效日期 BugNo:4409
#                "  OR  bmb05 IS NULL ) ",
#                " AND sfb87!='X' ",
#                " AND ",tm.wc CLIPPED, " ORDER BY sfb01,bmb03"
#----------------No.MOD-590036 end
 
     PREPARE asfx540_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690123
         EXIT PROGRAM
     END IF
     DECLARE asfx540_curs1 CURSOR FOR asfx540_prepare1
#No.FUN-750098----Begin
    #CALL cl_outnam('asfx540') RETURNING l_name    
    #START REPORT asfx540_rep TO l_name
     LET g_pageno = 0
     FOREACH asfx540_curs1 INTO sr.*
#No.FUN-750098 ----End 
       IF SQLCA.sqlcode != 0  THEN
           CALL cl_err('foreach:',SQLCA.sqlcode,1)
           EXIT FOREACH
       END IF
       IF cl_null(sr.sfb08) THEN LET sr.sfb08 = 0 END IF
       IF cl_null(sr.sfa06) THEN LET sr.sfa06 = 0 END IF
       #IF cl_null(sr.bmb08) THEN LET sr.bmb08 = 0 END IF  #No.MOD-590036 mark
 
       #CALL x540_amt(sr.sfb01,sr.bmb03,sr.sfb39) RETURNING exhaust #No.MOD-590036 mark
       CALL x540_amt(sr.sfb01,sr.sfa03,sr.sfb39,sr.sfa26,sr.sfa08,sr.sfa012,sr.sfa013) RETURNING exhaust  #No.MOD-590036 add   #FUN-A60027 add sfa012,sfa013
       #差異量計算
       #LET l_amt= exhaust+(sr.sfa05-sr.sfa06)-(sr.sfb08*sr.bmb06/sr.bmb07)  #No.MOD-590036 mark
   #---No.MOD-590036 add 若有取替代時將取替代料件之未耗量算在被替換皆料件上
       IF sr.sfa26 MATCHES '[348]' THEN      #FUN-A20037 add '8'
          LET l_sql=" SELECT sfa05,sfa06,sfa28 ",
          " FROM sfa_file WHERE sfa01 =? ",
          " AND sfa27 = ? ",
          " AND (sfa26 = 'U' OR sfa26 = 'S' OR sfa26 = 'Z') ", #FUN-A20037 add 'Z'
          " AND sfa012 = ? AND sfa013 = ? "     #FUN-A60027 
 
          PREPARE asfx540_pre3 FROM l_sql
          IF STATUS THEN CALL cl_err('',STATUS,0) RETURN END IF
          DECLARE asfx540_cur3 CURSOR FOR asfx540_pre3
          IF STATUS THEN CALL cl_err('',STATUS,0) RETURN END IF
          FOREACH asfx540_cur3 USING sr.sfb01,sr.sfa03,sr.sfa012,sr.sfa013      #FUN-A60027 add sfa012,sfa013
          INTO l_sfa05,l_sfa06,l_sfa28
 
             IF STATUS THEN
                LET l_sfa28 = 0
                LET l_sfa05 = 0
                LET l_sfa06 = 0
             END IF
             LET sr.sfa05 = sr.sfa05 + (l_sfa05 / l_sfa28)
             LET sr.sfa06 = sr.sfa06 + (l_sfa06 / l_sfa28)
          END FOREACH
       END IF
       LET l_amt= exhaust+(sr.sfa05-sr.sfa06)-(sr.sfb08*sr.sfa16)
   #----No.MOD-590036 end
 
       IF tm.b = 'Y' AND l_amt=0 THEN CONTINUE FOREACH END IF
 
 
#No.FUN-750098----Begin
       LET l_ima02 = ''
       LET l_ima021= ''
       SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
        WHERE ima01 = sr.sfb05
       SELECT ima02 INTO sr.ima02,sr.ima021 FROM ima_file
        WHERE ima01 = sr.sfa03
#      OUTPUT TO REPORT asfx540_rep(sr.*,exhaust)
    #CHI-C60014---S---
     LET sr.l_sfa12 = ''
     LET sr.l_sfa27 = ''
     SELECT sfa12,sfa27 INTO sr.l_sfa12,sr.l_sfa27
       FROM sfa_file
      WHERE sfa01 = sr.sfb01
     LET sr.l_bmb10 = ''
     SELECT bmb10 INTO sr.l_bmb10
       FROM bmb_file
      WHERE bmb01 = sr.sfb05
     CALL s_umfchk(sr.l_sfa27,sr.l_bmb10,sr.l_sfa12)
          RETURNING l_flag,l_factor
     IF l_flag THEN
        LET l_factor = 1
     END IF
    #CHI-C60014---E---

    #FUN-CB0001-----add---str---
    IF sr.sfb39 = "1"  THEN
         LET l_sfb39 = sr.sfb39,'/PUSH'
      ELSE
         IF sr.sfb39 = "2" THEN
            LET l_sfb39 = sr.sfb39,'/PULL'
         ELSE
            LET l_sfb39 = sr.sfb39
         END IF
      END IF
     LET l_amt1 = exhaust + (sr.sfa05 - sr.sfa06) - (sr.sfb08 * sr.sfa16 * l_factor)
     LET b_amt = sr.sfb08 * sr.sfa16 * l_factor
     LET w_amt = sr.sfa05 - sr.sfa06
     IF b_amt = 0 THEN
        LET l_rate = 0
     ELSE
        LET l_rate = l_amt1 / b_amt * 100
     END IF
     LET l_num1 = 3
     LET l_num2 = 2
       CASE sr.sfb02
          WHEN '1' LET sr.sfb02_1 = sr.sfb02,' ',cl_getmsg('asf-841',g_lang)
          WHEN '5' LET sr.sfb02_1 = sr.sfb02,' ',cl_getmsg('asf-842',g_lang)
          WHEN '7' LET sr.sfb02_1 = sr.sfb02,' ',cl_getmsg('asf-843',g_lang)
          WHEN '8' LET sr.sfb02_1 = sr.sfb02,' ',cl_getmsg('asf-856',g_lang)
          WHEN '11' LET sr.sfb02_1 = sr.sfb02,' ',cl_getmsg('asf-853',g_lang)
          WHEN '13' LET sr.sfb02_1 = sr.sfb02,' ',cl_getmsg('asf-843',g_lang)
          WHEN '15' LET sr.sfb02_1 = sr.sfb02,' ',cl_getmsg('asf-855',g_lang)
       END CASE
       CASE sr.sfb04
          WHEN '1' LET sr.sfb04_1 = sr.sfb04,' ',cl_getmsg('asf-845',g_lang)
          WHEN '2' LET sr.sfb04_1 = sr.sfb04,' ',cl_getmsg('asf-846',g_lang)
          WHEN '3' LET sr.sfb04_1 = sr.sfb04,' ',cl_getmsg('asf-847',g_lang)
          WHEN '4' LET sr.sfb04_1 = sr.sfb04,' ',cl_getmsg('asf-848',g_lang)
          WHEN '5' LET sr.sfb04_1 = sr.sfb04,' ',cl_getmsg('asf-849',g_lang)
          WHEN '6' LET sr.sfb04_1 = sr.sfb04,' ',cl_getmsg('asf-850',g_lang)
          WHEN '7' LET sr.sfb04_1 = sr.sfb04,' ',cl_getmsg('asf-851',g_lang)
          WHEN '8' LET sr.sfb04_1 = sr.sfb04,' ',cl_getmsg('asf-852',g_lang)
       END CASE

    #FUN-CB0001-----add---end---

     EXECUTE insert_prep USING
             sr.sfb01,sr.sfa03,sr.ima02,sr.ima021,sr.sfb08,sr.sfa16,
             exhaust,sr.sfa05,sr.sfa06,sr.sfb04,sr.sfb02,sr.sfb13,
             sr.sfb15,sr.sfb36,sr.sfb05,sr.ima55,l_ima02,l_ima021,sr.sfb39,sr.sfa012,sr.sfa013,  #FUN-A60027 add sfa012,sfa013
             l_factor,  #CHI-C60014
             sr.sfb02_1,sr.sfb04_1,l_sfb39,b_amt,l_rate,w_amt,l_amt1,l_num1,l_num2    ##FUN-CB0001 add
     END FOREACH
 
#    FINISH REPORT asfx540_rep
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)
###XtraGrid###     LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED                                                               
     #是否列印選擇條件                                                                                                              
     IF g_zz05 = 'Y' THEN                                                                                                           
        CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb85,sfb04') RETURNING tm.wc                                                        
###XtraGrid###        LET g_str = tm.wc                                                                                                           
     END IF
    #CALL cl_prt_cs3('asfx540','asfx540',l_sql,g_str)   #FUN-A60027
    #FUN-A60027 ----------------start----------------------
    IF g_sma.sma541 = 'Y' THEN
###XtraGrid###       CALL cl_prt_cs3('asfx540','asfx540_1',l_sql,g_str)
       LET g_xgrid.table = l_table    ###XtraGrid###
       #FUN-CB0001-----add---str---
       IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb85,sfb04') RETURNING tm.wc
       END IF
       LET g_xgrid.template = 'asfx540_1'
      #LET g_xgrid.order_field = 'sfb01'
       LET g_xgrid.skippage_field = 'sfb01'
       LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
       #FUN-CB0001-----add---end---
       CALL cl_xg_view()    ###XtraGrid###
    ELSE
###XtraGrid###       CALL cl_prt_cs3('asfx540','asfx540',l_sql,g_str)
       LET g_xgrid.table = l_table    ###XtraGrid###
       #FUN-CB0001-----add---str---
       IF g_zz05 = 'Y' THEN
        CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb85,sfb04') RETURNING tm.wc
       END IF
       LET g_xgrid.template = 'asfx540'
      #LET g_xgrid.order_field = 'sfb01'
       LET g_xgrid.skippage_field = 'sfb01'
       LET g_xgrid.condition = cl_getmsg('lib-160',g_lang),tm.wc
       #FUN-CB0001-----add---end---
       CALL cl_xg_view()    ###XtraGrid###
    END IF 
    #FUN-A60027 -----------------end----------------------- 
#No.FUN-750098----End
END FUNCTION
#No.FUN-750098----Begin
{
REPORT asfx540_rep(sr,exhaust)
   DEFINE l_last_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
          exhaust      LIKE sfa_file.sfa04,          #No.FUN-680121 DECIMAL(12,3)
          l_amt        LIKE sfa_file.sfa04,          #No.FUN-680121 DECIMAL(12,3)
          l_sfe06      LIKE sfe_file.sfe06,
          l_sfe16      LIKE sfe_file.sfe16,
          l_ima02      LIKE ima_file.ima02,
          l_ima021     LIKE ima_file.ima021,
          sr           RECORD
                       sfb01 LIKE sfb_file.sfb01,
                       sfb04 LIKE sfb_file.sfb04,
                       sfb02 LIKE sfb_file.sfb02,
                       sfb13 LIKE sfb_file.sfb13,
                       sfb15 LIKE sfb_file.sfb15,
                       sfb39 LIKE sfb_file.sfb39,
                       sfb36 LIKE sfb_file.sfb36,
                       sfb05 LIKE sfb_file.sfb05,
                       ima55 LIKE ima_file.ima55,
                       sfb08 LIKE sfb_file.sfb08,
                      #bmb03 LIKE bmb_file.bmb03,   #No.MOD-590036 mark
                      #bmb06 LIKE bmb_file.bmb06,   #No.MOD-590036 mark
                      #bmb07 LIKE bmb_file.bmb07,   #No.MOD-590036 mark
                      #bmb08 LIKE bmb_file.bmb08,   #No.MOD-590036 mark
                       ima02 LIKE ima_file.ima02,
                       ima021 LIKE ima_file.ima021,
                       sfa05 LIKE sfa_file.sfa05,
                       sfa16 LIKE sfa_file.sfa16,
                       sfa06 LIKE sfa_file.sfa06,
                       sfa03 LIKE sfa_file.sfa03, #No.MOD-590036 add
                       sfa08 LIKE sfa_file.sfa08, #No.MOD-590036 add
                       sfa26 LIKE sfa_file.sfa26  #No.MOD-590036 add
                       END RECORD
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER BY sr.sfb01
  FORMAT
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1,g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<','/pageno'
      PRINT g_head CLIPPED, pageno_total
      PRINT ''
 
      PRINT COLUMN 01,g_x[09] CLIPPED,' ',sr.sfb01,
            COLUMN 45,g_x[10] CLIPPED,' ',sr.sfb04,
            COLUMN 60,g_x[11] CLIPPED,' ',sr.sfb02;
 
      IF sr.sfb39 = "1"  THEN
         PRINT COLUMN 80,g_x[12] CLIPPED,' ',sr.sfb39,'/PUSH'
      ELSE
         IF sr.sfb39 = "2" THEN
            PRINT COLUMN 80,g_x[12] CLIPPED,' ',sr.sfb39,'/PULL'
         ELSE
            PRINT COLUMN 80,g_x[12] CLIPPED,' ',sr.sfb39
         END IF
      END IF
 
      LET l_ima02 = ''
      LET l_ima021= ''
      SELECT ima02,ima021 INTO l_ima02,l_ima021 FROM ima_file
       WHERE ima01 = sr.sfb05
 
      PRINT COLUMN 01,g_x[13] CLIPPED,' ',sr.sfb13,
            COLUMN 45,g_x[14] CLIPPED,' ',sr.sfb15,
            COLUMN 80,g_x[15] CLIPPED,' ',sr.sfb36
      PRINT COLUMN 01,g_x[16] CLIPPED,' ',sr.sfb05,
            COLUMN 45,g_x[20] CLIPPED,' ',sr.ima55,
            COLUMN 80,g_x[19] CLIPPED,' ',sr.sfb08
#TQC-5B0111 &051112
   #  PRINT COLUMN 01,g_x[17] CLIPPED,' ',l_ima02,
   #        COLUMN 45,g_x[18] CLIPPED,' ',l_ima021
      PRINT COLUMN 01,g_x[17] CLIPPED,' ',l_ima02 CLIPPED
      PRINT COLUMN 01,g_x[18] CLIPPED,' ',l_ima021 CLIPPED
#TQC-5B0111 &051112 -end
 
      PRINT g_dash
      PRINT g_x[31],
            g_x[32],
            g_x[33],
            g_x[34],
            g_x[35],
            g_x[36],
            g_x[37],
            g_x[38]
      PRINT g_dash1
      LET l_last_sw = 'n'
 
   BEFORE GROUP OF sr.sfb01
     IF  (PAGENO > 1 OR LINENO > 9)
        THEN SKIP TO TOP OF PAGE
     END IF
 
   ON EVERY ROW
     #SELECT ima02 INTO sr.ima02,sr.ima021 FROM ima_file WHERE ima01 = sr.bmb03  #No.MOD-590036 mark
     SELECT ima02 INTO sr.ima02,sr.ima021 FROM ima_file
        WHERE ima01 = sr.sfa03  #No.MOD-590036 add
 
     #PRINT COLUMN g_c[31],sr.bmb03,   #No.MOD-590036 mark
     PRINT COLUMN g_c[31],sr.sfa03,    #No.MOD-590036 add
           COLUMN g_c[32],sr.ima02,
           COLUMN g_c[33],sr.ima021,
           #COLUMN g_c[34],sr.sfb08*sr.bmb06/sr.bmb07 USING '########.###',    #No.MOD-590036 mark
           COLUMN g_c[34],sr.sfb08*sr.sfa16 USING '########.###',              #No.MOD-590036 add
     #耗料量+未耗料量=實際用量
     #(實際用量-標準用量)/標準用量=損耗率
           COLUMN g_c[35],(exhaust+(sr.sfa05-sr.sfa06)-
                         #(sr.sfb08*sr.bmb06/sr.bmb07))                       #No.MOD-590036 mark
                         #/(sr.sfb08*sr.bmb06/sr.bmb07)*100 USING '----.##',  #No.MOD-590036 mark
                         (sr.sfb08*sr.sfa16))                              #No.MOD-590036 add
                          /(sr.sfb08*sr.sfa16)*100 USING '------.##',      #No.MOD-590036 add
           COLUMN g_c[36],exhaust USING '-----------.###',
     #應發數量-已發數量=未耗量
           COLUMN g_c[37],(sr.sfa05-sr.sfa06) USING '-----------.###',
           COLUMN g_c[38],exhaust+(sr.sfa05-sr.sfa06)-
                         # (sr.sfb08*sr.bmb06/sr.bmb07)  #No.MOD-590036 mark
                          (sr.sfb08*sr.sfa16)            #No.MOD-590036 add
                          USING '-----------.###'
 
   ON LAST ROW
      IF g_zz05 = 'Y' THEN     # (80)-70,140,210,280   /   (132)-120,240,300
         CALL cl_wcchp(tm.wc,'sfb01,sfb05,sfb85')   #TQC-630166
              RETURNING tm.wc
         PRINT g_dash
 
#TQC-630166-start
         CALL cl_prt_pos_wc(tm.wc) 
#        IF tm.wc[001,070] > ' ' THEN            # for 80
#             PRINT g_x[8] CLIPPED,tm.wc[001,070] CLIPPED END IF
#        IF tm.wc[071,140] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[071,140] CLIPPED END IF
#        IF tm.wc[141,210] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[141,210] CLIPPED END IF
#        IF tm.wc[211,280] > ' ' THEN
#             PRINT COLUMN 10,     tm.wc[211,280] CLIPPED END IF
#TQC-630166-end
      END IF
      PRINT g_dash
#     PRINT g_x[4] CLIPPED, COLUMN g_c[38], g_x[7] CLIPPED     #No.TQC-710016
      PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED     #No.TQC-710016
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      IF l_last_sw = 'n' THEN
         PRINT g_dash
#        PRINT g_x[4] CLIPPED, COLUMN g_c[38], g_x[6] CLIPPED     #No.TQC-710016
         PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED     #No.TQC-710016
      ELSE
         SKIP 2 LINE
      END IF
END REPORT
}
#No.FUN-750098----End
 
#FUNCTION x540_amt(p_sfb01,p_bmb03,p_sfb39)                   #No.MOD-590036 mark
FUNCTION x540_amt(p_sfb01,p_sfa03,p_sfb39,p_sfa26,p_sfa08,p_sfa012,p_sfa013)    #No.MOD-590036 add  #FUN-A60027 add sfa012,sfa013
 DEFINE  exhaust      LIKE sfa_file.sfa04,        #No.FUN-680121 DECIMAL(12,3)
         exhaust1     LIKE sfa_file.sfa04,        #No.FUN-680121 DECIMAL(12,3)#No.MOD-590036 add
         p_sfb01      LIKE sfb_file.sfb01,
         #p_bmb03      LIKE bmb_file.bmb03,  #No.MOD-590036 mark
         p_sfa03      LIKE sfa_file.sfa03,   #No.MOD-590036 add
         p_sfa26      LIKE sfa_file.sfa26,   #No.MOD-590036 add
         l_sfa03      LIKE sfa_file.sfa03,   #No.MOD-590036 add
         l_sfa28      LIKE sfa_file.sfa28,   #No.MOD-590036 add
         p_sfa08      LIKE sfa_file.sfa08,   #No.MOD-590036 add
         p_sfb39      LIKE sfb_file.sfb39,
         l_sfe06      LIKE sfe_file.sfe06,
         l_sfe16      LIKE sfe_file.sfe16
 DEFINE  p_sfa012     LIKE sfa_file.sfa012,   #FUN-A60027
         p_sfa013     LIKE sfa_file.sfa013    #FUN-A60027 
 
 LET exhaust = 0
 #FOREACH asfx540_cur1 USING p_sfb01,p_bmb03 INTO l_sfe06,l_sfe16  #No.MOD-590036 mark
 FOREACH asfx540_cur1 USING p_sfb01,p_sfa03,p_sfa08,p_sfa012,p_sfa013 INTO l_sfe06,l_sfe16 #No.MOD-590036 add   #FUN-A60027 add sfa012,sfa013
    IF STATUS THEN LET exhaust = 0  RETURN exhaust  END IF
    IF cl_null(l_sfe16) THEN LET l_sfe16 = 0 END IF
    IF p_sfb39 = "1" THEN
       IF l_sfe06 MATCHES '[1235]' THEN
          LET exhaust = exhaust + l_sfe16
       END IF
       IF l_sfe06 = "4" THEN
          LET exhaust = exhaust - l_sfe16
       END IF
    END IF
    IF p_sfb39 = "2" THEN
       #-------No.MOD-6A0125 modify
       #IF l_sfe06 MATCHES '[6780]' THEN
       IF l_sfe06 MATCHES '[123]' THEN
          LET exhaust = exhaust + l_sfe16
       END IF
       #IF l_sfe06 = "9" THEN
       IF l_sfe06 = "4" THEN
       #-------No.MOD-6A0125 end
          LET exhaust = exhaust - l_sfe16
       END IF
    END IF
 END FOREACH
#-----No.MOD-590036 add 若為替代料件時將耗用量算在被替代料件上
 IF p_sfa26 MATCHES '[348]' THEN  #FUN-A20037 add '8'
    SELECT sfa03,sfa08,sfa26,sfa28 INTO l_sfa03,p_sfa08,p_sfa26,l_sfa28
       FROM sfa_file WHERE sfa01 = p_sfb01 AND sfa27=p_sfa03
       AND (sfa26 = 'U' OR sfa26 = 'S' OR sfa26 = 'Z')   #FUN-A20037 add 'Z'
       AND sfa012 = p_sfa012 AND sfa013 = p_sfa013       #FUN-A60027 add 
    IF STATUS THEN LET l_sfa28 = 0 RETURN exhaust  END IF
    CALL x540_amt(p_sfb01,l_sfa03,p_sfb39,p_sfa26,p_sfa08,p_sfa012,p_sfa013) RETURNING exhaust1   #FUN-A60027 add sfa012,sfa013
    IF cl_null(exhaust1) THEN LET exhaust1 = 0 END IF
    LET exhaust = exhaust + (exhaust1 / l_sfa28)
 END IF
#----No.MOD-590036 end
 
 RETURN exhaust
 
END FUNCTION


###XtraGrid###START
###XtraGrid###START
###XtraGrid###END
###XtraGrid###END

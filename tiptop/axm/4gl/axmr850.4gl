# Prog. Version..: '5.30.06-13.03.19(00006)'     #
#
# Pattern name...: axmr850.4gl
# Descriptions...: 三角貿易在途存貨稽核報表
# DATE & Aurther.: 07/01/11 FUN-710019 by yiting
# Modify	 : 07/12/08 TQC-7C0027 by LILID rva06放到QBE條件中
# Modify.........: NO.MOD-7B0226 07/11/28 BY Yiting 代採時抓不到資料
# Modify.........: No.FUN-850018 07/05/07 By ChenMoyan 老報表轉CR
# Modify.........: No.FUN-870144 08/07/29 By baofei   報表轉CR追到31區 
# Modify.........: No.FUN-910082 09/02/02 By ve007 wc,sql 定義為STRING
# Modify.........: No.FUN-940102 09/04/27 BY destiny 檢查使用者的資料庫使用權限
# Modify.........: No.MOD-980163 09/08/19 By Dido 增加 distinct 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: NO.FUN-A10056 10/01/13 By lutingting 跨DB寫法修改 
# Modify.........: No.CHI-A10003 10/04/15 By Summer 將l_table的變數定義成STRING
# Modify.........: No.FUN-B80089 11/08/09 By minpp程序撰寫規範修改
# Modify.........: No.MOD-CA0150 13/02/01 By Elise 移除無任何註記的#，才不會造成報表錯誤。

DATABASE ds
 
GLOBALS "../../config/top.global"
 
   DEFINE tm  RECORD                           # Print condition RECORD
              wc      LIKE type_file.chr1000,  # FUN-710019
              pmm01   LIKE pmm_file.pmm01,
              oea01   LIKE oea_file.oea01,
              #rva06   LIKE rva_file.rva06,#TQC-7C0027
              poz00   LIKE poz_file.poz00,
              plant   LIKE azp_file.azp01
              END RECORD
 
DEFINE   i               LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_i             LIKE type_file.num5          #count/index for any purpose        #No.FUN-680137 SMALLINT
DEFINE   g_msg           LIKE type_file.chr1000       #No.FUN-680137  VARCHAR(72)
DEFINE   g_poy           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                         poy02  LIKE poy_file.poy02,
                         poy04  LIKE poy_file.poy04,
                         poy05  LIKE poy_file.poy05,
                         azp03  LIKE azp_file.azp03
                         END RECORD
DEFINE   g_arr           DYNAMIC ARRAY OF RECORD   #程式變數(Program Variables)
                         oea904   LIKE oea_file.oea904,
                         oea99    LIKE oea_file.oea99,
                         oea01    LIKE oea_file.oea01,
                         pmm01    LIKE pmm_file.pmm01,
                         rva99    LIKE rva_file.rva99,
                         pmn31    LIKE pmn_file.pmn31,
                         pmn88    LIKE pmn_file.pmn88
                         END RECORD
DEFINE g_poz00      LIKE poz_file.poz00    #NO.MOD-7B0226
DEFINE g_str        LIKE type_file.chr1000       
DEFINE g_sql     STRING       #NO.FUN-910082              
DEFINE l_table      STRING    #No.CHI-A10003 mod LIKE type_file.chr1000-->STRING


MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                # Supress DEL key function

   LET g_pdate  = ARG_VAL(1)        # Get arguments from command line
   LET g_towhom = ARG_VAL(2)
   LET g_rlang  = ARG_VAL(3)
   LET g_bgjob  = ARG_VAL(4)
   LET g_prtway = ARG_VAL(5)
   LET g_copies = ARG_VAL(6)
   LET tm.wc    = ARG_VAL(7)
   #LET tm.poz00 = ARG_VAL(8)
   LET tm.plant = ARG_VAL(8)
   LET g_rep_user = ARG_VAL(09)
   LET g_rep_clas = ARG_VAL(10)
   LET g_template = ARG_VAL(11)
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF

   LET g_sql="azp01.azp_file.azp01,",
             "rva01.rva_file.rva01,",
             "rva05.rva_file.rva05,",
             "rvb02.rvb_file.rvb02,",
             "rvb03.rvb_file.rvb03,",
             "rvb04.rvb_file.rvb04,",
             "rvb05.rvb_file.rvb05,",
             "rvb07.rvb_file.rvb07,",
             "rvb30.rvb_file.rvb30,",
             "rva99.rva_file.rva99,",
             "pmc03.pmc_file.pmc03,",
             "ima02.ima_file.ima02,",
             "poy04.poy_file.poy04,",
             "poy06.poy_file.poy06,",
             "pmn31.pmn_file.pmn31,",
             "pmn88.pmn_file.pmn88,",
             "pmm22.pmm_file.pmm22,",
             "pmm09.pmm_file.pmm09"
   LET l_table=cl_prt_temptable('axmr850',g_sql) CLIPPED
   IF l_table=-1 THEN EXIT PROGRAM END IF
   LET g_sql="INSERT INTO ",g_cr_db_str CLIPPED,l_table CLIPPED,
             " VALUES(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?)"
   PREPARE insert_prep FROM g_sql
   IF STATUS THEN
      CALL cl_err('insert_prep:',status,1) EXIT PROGRAM
   END IF

   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690126

   DROP TABLE r850_tmp
   CREATE TEMP TABLE r850_tmp(
      azp01 LIKE azp_file.azp01,
      rva01 LIKE rva_file.rva01,
      rva05 LIKE rva_file.rva05,
      rvb02 LIKE rvb_file.rvb02,
      rvb03 LIKE rvb_file.rvb03,
      rvb04 LIKE rvb_file.rvb04,
      rvb05 LIKE rvb_file.rvb05,
      rvb07 LIKE rvb_file.rvb07,
      rvb30 LIKE rvb_file.rvb30,
      rva99 LIKE rva_file.rva99,
      pmc03   LIKE pmc_file.pmc03,
      ima02   LIKE ima_file.ima02,
      poy04   LIKE poy_file.poy04,
      poy05   LIKE poy_file.poy05,
      pmn31   LIKE pmn_file.pmn31,
      pmn88   LIKE pmn_file.pmn88,
      pmm22   LIKE pmm_file.pmm22,
      pmm09   LIKE pmm_file.pmm09);
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N'        # If background job sw is off
      THEN CALL axmr850_tm(0,0)                # Input print condition
      ELSE CALL axmr850()                      # Read data and create out-file
   END IF
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
END MAIN
 
FUNCTION axmr850_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01  
   DEFINE p_row,p_col    LIKE type_file.num5,       
          l_cmd        LIKE type_file.chr1000,     
          l_cnt        LIKE type_file.num5
   DEFINE l_poz00      LIKE poz_file.poz00
   DEFINE l_pmm01      LIKE pmm_file.pmm01   #no.MOD-7B0226
   DEFINE l_oea01      LIKE oea_file.oea01   #no.MOD-7B0226 
   DEFINE l_oea_cnt    LIKE type_file.num10  #no.MOD-7B0226
   DEFINE l_pmm_cnt    LIKE type_file.num10  #no.MOD-7B0226
 
   LET p_row = 5 LET p_col = 17
 
   OPEN WINDOW axmr850_w AT p_row,p_col WITH FORM "axm/42f/axmr850"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
   INITIALIZE tm.* TO NULL            # Default condition
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1'
 
WHILE TRUE
 
   #CONSTRUCT BY NAME tm.wc ON poz00,oea01,pmm01
   CONSTRUCT BY NAME tm.wc ON poz00,oea01,pmm01,rva06
 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
      AFTER FIELD poz00
         CALL GET_FLDBUF(poz00) RETURNING g_poz00  #MOD-7B0226
         #CALL r850_set_entry(g_poz00)       #NO.MOD-7B0226 mark
         #CALL r850_set_no_entry(g_poz00)    #NO.MOD-7B0226 mark
         
      #----NO.MOD-7B0226 start------
      AFTER FIELD oea01
         CALL GET_FLDBUF(oea01) RETURNING l_oea01
         IF g_poz00 = '1' AND cl_null(l_oea01) THEN 
             NEXT FIELD oea01 
         END IF
 
      AFTER FIELD pmm01
         CALL GET_FLDBUF(pmm01) RETURNING l_pmm01
         IF g_poz00 = '2' AND cl_null(l_pmm01) THEN 
             NEXT FIELD pmm01 
         END IF
      #----no.MOD-7B0226 end---------
 
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(pmm01)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_pmm01"
                 LET g_qryparam.form ="q_pmm_c"    #NO.MOD-7B0226
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm01
                 NEXT FIELD pmm01
              WHEN INFIELD(oea01)
                 CALL cl_init_qry_var()
                 #LET g_qryparam.form ="q_oea01_c"
                 LET g_qryparam.form ="q_oea_c"    #NO.MOD-7B0226
                 LET g_qryparam.state = "c"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO oea01
                 NEXT FIELD oea01
           END CASE
 
      ON ACTION locale
          #CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          LET g_action_choice = "locale"
          EXIT CONSTRUCT
 
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
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
      LET INT_FLAG = 0 CLOSE WINDOW axmr850_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
         
   END IF
   IF tm.wc = ' 1=1' THEN
      CALL cl_err('','9046',0) CONTINUE WHILE
   END IF
 
   #INPUT BY NAME tm.rva06,tm.plant WITHOUT DEFAULTS
   INPUT BY NAME tm.plant WITHOUT DEFAULTS#TQC-7C0027
 
      AFTER FIELD plant
         LET tm.plant = UPSHIFT(tm.plant)
         DISPLAY tm.plant TO FORMONLY.plant
         IF tm.plant <> 'ALL' THEN 
             SELECT COUNT(*) INTO l_cnt
               FROM azp_file
              WHERE azp01 = tm.plant
             IF l_cnt = 0 THEN
                 NEXT FIELD plant
             END IF
            #No.FUN-940102--begin   
            IF NOT cl_null(tm.plant) THEN 
               IF NOT s_chk_demo(g_user,tm.plant) THEN  
                  NEXT FIELD plant 
               END IF
            END IF               
            #No.FUN-940102--end 
         END IF
         #NO.MOD-7B0226 start---
         IF cl_null(tm.plant) THEN 
             NEXT FIELD plant
         END IF
         #NO.MOD-7B0226 end-----
         
      #No.FUN-580031 --start--
      BEFORE INPUT
          CALL cl_qbe_display_condition(lc_qbe_sn)
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
      ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
      ON ACTION exit
         LET INT_FLAG = 1
         EXIT INPUT
 
      #No.FUN-580031 --start--
      ON ACTION qbe_save
         CALL cl_qbe_save()
      #No.FUN-580031 ---end---
 
      ON ACTION CONTROLP
           CASE
              WHEN INFIELD(plant)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form ="q_azp"               #No.FUN-940102
                 LET g_qryparam.form = "q_zxy"               #No.FUN-940102
                 LET g_qryparam.arg1 = g_user                #No.FUN-940102
                 LET g_qryparam.default1 = tm.plant
                 CALL cl_create_qry() RETURNING tm.plant
                 DISPLAY tm.plant TO plant
                 NEXT FIELD plant
           END CASE
 
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW axmr850_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
      EXIT PROGRAM
   END IF
   CALL axmr850()
   ERROR ""
END WHILE
   CLOSE WINDOW axmr850_w
END FUNCTION
 
#NO.MOD-7B0226 mark-------
#FUNCTION r850_set_entry(p_poz00)
#DEFINE p_poz00   LIKE poz_file.poz00
#    CALL cl_set_comp_entry("oea01,pmm01",TRUE)
#END FUNCTION
#
#FUNCTION r850_set_no_entry(p_poz00)
#DEFINE p_poz00   LIKE poz_file.poz00
#    IF p_poz00 = '1' THEN
#        CALL cl_set_comp_entry("pmm01",FALSE)
#    ELSE
#        CALL cl_set_comp_entry("oea01",FALSE)
#    END IF
#END FUNCTION
#NO.MOD-7B0226 mark----
 
FUNCTION axmr850()
   DEFINE l_name    LIKE type_file.chr20,         # External(Disk) file name        #No.FUN-680137 VARCHAR(20)
          #l_sql     LIKE type_file.chr1000,       # RDSQL STATEMENT        #No.FUN-680137 VARCHAR(1000)
          l_sql     STRING,                       #no.MOD-7B0226
          l_chr     LIKE type_file.chr1,          #No.FUN-680137 VARCHAR(1)
          l_za05    LIKE type_file.chr1000,       #No.FUN-680137 VARCHAR(40)
          l_p_dbs   LIKE type_file.chr20,    # No.FUN-680137 VARCHAR(21)
          sr        RECORD
                    azp01   LIKE azp_file.azp01,    #NO.MOD-7B0226
                    rva01   LIKE rva_file.rva01,
                    rva05   LIKE rva_file.rva05,
                    rvb02   LIKE rvb_file.rvb02,
                    rvb03   LIKE rvb_file.rvb03,
                    rvb04   LIKE rvb_file.rvb04,
                    rvb05   LIKE rvb_file.rvb05,
                    rvb07   LIKE rvb_file.rvb07,
                    rvb30   LIKE rvb_file.rvb30,
                    rva99   LIKE rva_file.rva99,
                    pmc03   LIKE pmc_file.pmc03,
                    ima02   LIKE ima_file.ima02,
                    poy04   LIKE poy_file.poy04,
                    poy05   LIKE poy_file.poy05,
                    pmn31   LIKE pmn_file.pmn31,
                    pmn88   LIKE pmn_file.pmn88,
                    pmm22   LIKE pmm_file.pmm22,   #NO.MOD-7B0226
                    pmm09   LIKE pmm_file.pmm09    #NO.MOD-7B0226
          END RECORD
     DEFINE k,j,i,l_ac   LIKE type_file.num5,
          l_pmm01        LIKE pmm_file.pmm01,
          l_pmm22        LIKE pmm_file.pmm22,
          l_poy02        LIKE poy_file.poy02,
          l_poy04        LIKE poy_file.poy04,
          l_poy05        LIKE poy_file.poy05,
          l_azp03        LIKE azp_file.azp03
     DEFINE l_pmm99      LIKE pmm_file.pmm99    #NO.MOD-7B0226
     DEFINE l_oea99      LIKE oea_file.oea99    #no.MOD-7B0226
     DEFINE l_poy01      LIKE poy_file.poy01    #NO.MOD-7B0226
     DEFINE l_oea904     LIKE oea_file.oea904   #NO.MOD-7B0226
     DEFINE l_pmm904     LIKE pmm_file.pmm904   #no.MOD-7B0226
     DEFINE l_pmc03      LIKE pmc_file.pmc03    #NO.MOD-7B0226
     DEFINE l_pmm09      LIKE pmm_file.pmm09    #NO.MOD-7B0226
 
     CALL cl_wait()
     CALL cl_del_data(l_table)                     #No.FUN-850018
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_rlang 
     SELECT zz05 INTO g_zz05 FROM zz_file WHERE zo01 = 'axmr850' #No.FUN-850018
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm.wc = tm.wc clipped," AND ogauser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm.wc = tm.wc clipped," AND ogagrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm.wc = tm.wc clipped," AND ogagrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond('ogauser', 'ogagrup')
     #End:FUN-980030
     #--------------------NO.MOD-7B0226 start--------------------------
     IF g_poz00 = '1' THEN     #多角銷售流程
        #LET l_sql = "SELECT oea99,oea904 ",			#MOD-980163 mark
         LET l_sql = "SELECT DISTINCT oea99,oea904 ",		#MOD-980163
                     "  FROM oea_file,pmm_file,poz_file,rva_file,rvb_file",
                     " WHERE oea904 = poz01",
                     "   AND poz00 = '1'",    #銷售流程
                     "   AND poz19 = 'Y'",    #設立中斷否
                     "   AND poz011 = '2'",   #逆拋
                     "   AND poz18 IS NOT NULL ",    
                     "   AND oea905 = 'Y'",   #多角拋轉否
                     "   AND oea906 = 'Y'",   #多角來源訂單否
                     "   AND oea901 = 'Y'",   #多角否
                     "   AND oea99 = pmm99 ", #多角流程序號
                     "   AND rva01 = rvb01",
                     "   AND pmm01 = rvb04 ", #採購單號
                     "   AND ",tm.wc
         PREPARE r850_p1 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
            EXIT PROGRAM
         END IF
         DECLARE r850_curs1 CURSOR FOR r850_p1
#        CALL cl_outnam('axmr850') RETURNING l_name #No.FUN-850018
#        START REPORT axmr850_rep TO l_name         #No.FUN-850018 
         FOREACH r850_curs1 INTO l_oea99,l_oea904   #多角流程序號
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                EXIT PROGRAM
             END IF
             #apmi000單身設定營運中心
             LET l_sql = "SELECT poy01,poy04 FROM poy_file ",
                         " WHERE poy01 = '",l_oea904,"'",
                         " ORDER BY poy02"
             PREPARE r850_poy_p FROM l_sql
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                EXIT PROGRAM
             END IF
             DECLARE r850_poy_c CURSOR FOR r850_poy_p
             FOREACH r850_poy_c INTO l_poy01,l_poy04   #多角流程
                 #--依據流程設定的營運中心，抓採購單及收貨單資料 
                 SELECT azp03 INTO l_azp03 FROM azp_file
                  WHERE azp01 = l_poy04

                 LET l_azp03 = s_dbstring(l_azp03 CLIPPED)
                 #----多角採購單-----
                 LET l_sql = " SELECT pmm01,pmm22,pmc03,pmm09 ",
                            #FUN-A10056--mod--str--
                            #"   FROM ",l_azp03 CLIPPED,"pmm_file,",
                            #"        ",l_azp03 CLIPPED,"pmc_file ",
                             "   FROM ",cl_get_target_table(l_poy04,'pmm_file'),",",
                                        cl_get_target_table(l_poy04,'pmc_file'),
                            #FUN-A10056--mod--end
                             "  WHERE pmm99 = '",l_oea99,"'",
                             "    AND pmc01 = pmm09 "          #供應商 
                 CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql     #FUN-A10056
                 PREPARE axmr850_pmm_p FROM l_sql
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                    EXIT PROGRAM
                 END IF
                 DECLARE axmr850_pmm_c CURSOR FOR axmr850_pmm_p
                 OPEN axmr850_pmm_c
                 LET l_pmc03 = NULL
                 LET l_pmm22 = NULL
                 LET l_pmm09 = NULL
                 FETCH axmr850_pmm_c INTO l_pmm01,l_pmm22,l_pmc03,l_pmm09    #多角採購單號
                 #----多角收貨單------
                 LET l_sql = " SELECT ' ',rva01,rva05,rvb02,rvb03,rvb04,rvb05,rvb07,rvb30,rva99 ",
                            #FUN-A10056--mod--str--
                            #"   FROM ",l_azp03 CLIPPED,"rva_file, ",
                            #"        ",l_azp03 CLIPPED,"rvb_file ",
                             "   FROM ",cl_get_target_table(l_poy04,'rva_file'),",",
                                        cl_get_target_table(l_poy04,'rvb_file'),
                            #FUN-A10056--mod--end
                             "  WHERE rva01 = rvb01 ",
                             "    AND rva02 = '",l_pmm01,"'",   
                             "    AND (rvb30 IS NULL OR rvb30 = 0) " 
                 CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql     #FUN-A10056
                 PREPARE axmr850_p2 FROM l_sql
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                    EXIT PROGRAM
                 END IF
                 DECLARE axmr850_curs2 CURSOR FOR axmr850_p2
 
                 OPEN axmr850_curs2
                 INITIALIZE sr.* TO NULL
                 FETCH axmr850_curs2 INTO sr.*
 
                 IF cl_null(sr.rva01) THEN CONTINUE FOREACH END IF
                 LET sr.pmm22 = l_pmm22
                 LET sr.pmc03 = l_pmc03
                 LET sr.azp01 = l_poy04    
                 LET sr.pmm09 = l_pmm09
                 LET l_sql = " SELECT pmn31,pmn88,ima02",
                            #FUN-A10056--mod--str--
                            #"   FROM ",l_azp03 CLIPPED,"pmn_file, ",
                            #"        ",l_azp03 CLIPPED,"ima_file ",
                             "   FROM ",cl_get_target_table(l_poy04,'pmn_file'),",",
                                        cl_get_target_table(l_poy04,'ima_file'),
                            #FUN-A10056--mod--end
                             "  WHERE pmn01 = '",sr.rvb04,"'",   #採購單號
                             "    AND pmn02 = '",sr.rvb03,"'",
                             "    AND ima01 = '",sr.rvb05,"'"   
                 CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql     #FUN-A10056 
                 PREPARE axmr850_pmn_p2 FROM l_sql
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                    EXIT PROGRAM
                 END IF
                 DECLARE axmr850_pmn_c2 CURSOR FOR axmr850_pmn_p2
 
                 OPEN axmr850_pmn_c2
                 FETCH axmr850_pmn_c2 INTO sr.pmn31,sr.pmn88,sr.ima02
                 INSERT INTO r850_tmp VALUES (sr.*)
             END FOREACH
         END FOREACH
     ELSE                       #多角代採流程
        #LET l_sql = "SELECT pmm99,pmm904 FROM pmm_file,poz_file,rva_file,rvb_file",			#MOD-980163 mark
         LET l_sql = "SELECT DISTINCT pmm99,pmm904 FROM pmm_file,poz_file,rva_file,rvb_file",		#MOD-980163
                     " WHERE pmm904 = poz01",
                     "   AND poz00 = '2'",    #代採流程
                     "   AND poz19 = 'Y'",    #設立中斷否
                     "   AND poz011 = '2'",   #逆拋
                     "   AND poz18 IS NOT NULL ",    
                     "   AND pmm905 = 'Y'",   #多角拋轉否
                     "   AND pmm906 = 'Y'",   #多角來源採購單否
                     "   AND pmm901 = 'Y'",    #多角否
                     "   AND rva01 = rvb01",
                     "   AND rvb04 = pmm01",
                     "   AND ",tm.wc
 
         PREPARE r850_p2 FROM l_sql
         IF SQLCA.sqlcode != 0 THEN
            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
            EXIT PROGRAM
         END IF
         DECLARE r850_curs2 CURSOR FOR r850_p2
#        CALL cl_outnam('axmr850') RETURNING l_name #No.FUN-850018
#        START REPORT axmr850_rep TO l_name         #No.FUN-850018 
         FOREACH r850_curs2 INTO l_pmm99,l_pmm904   #採購單號/多角流程序號
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                EXIT PROGRAM
             END IF
             #apmi000單身設定營運中心
             LET l_sql = "SELECT poy01,poy04 FROM poy_file ",
                         " WHERE poy01 = '",l_pmm904,"'",
                         " ORDER BY poy02"
             PREPARE r850_poy_p1 FROM l_sql
             IF SQLCA.sqlcode != 0 THEN
                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                EXIT PROGRAM
             END IF
             DECLARE r850_poy_c1 CURSOR FOR r850_poy_p1
             FOREACH r850_poy_c1 INTO l_poy01,l_poy04   #多角流程代碼/營運中心
                 #--依據流程設定的營運中心，抓採購單及收貨單資料 
                 SELECT azp03 INTO l_azp03 FROM azp_file
                  WHERE azp01 = l_poy04

                 LET l_azp03 = s_dbstring(l_azp03 CLIPPED)
                 #----多角採購單-----
                 LET l_sql = " SELECT pmm01,pmm22,pmc03,pmm09 ",
                            #FUN-A10056--mod--str--
                            #"   FROM ",l_azp03 CLIPPED,"pmm_file,",
                            #"        ",l_azp03 CLIPPED,"pmc_file ",
                             "   FROM ",cl_get_target_table(l_poy04,'pmm_file'),",",
                                        cl_get_target_table(l_poy04,'pmc_file'),
                            #FUN-A10056--mod--end
                             "  WHERE pmm99 = '",l_pmm99,"'",
                             "    AND pmc01 = pmm09 "          #供應商 
                 CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql     #FUN-A10056
                 PREPARE axmr850_pmm_p1 FROM l_sql
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                    EXIT PROGRAM
                 END IF
                 DECLARE axmr850_pmm_c1 CURSOR FOR axmr850_pmm_p1
                 OPEN axmr850_pmm_c1
                 LET l_pmc03 = NULL
                 LET l_pmm22 = NULL
                 LET l_pmm09 = NULL
                 FETCH axmr850_pmm_c1 INTO l_pmm01,l_pmm22,l_pmc03,l_pmm09    #多角採購單號
                 #----多角收貨單------
                 LET l_sql = " SELECT ' ',rva01,rva05,rvb02,rvb03,rvb04,rvb05,rvb07,rvb30,rva99 ",
                            #FUN-A10056--mod--str--
                            #"   FROM ",l_azp03 CLIPPED,"rva_file,",
                            #"        ",l_azp03 CLIPPED,"rvb_file",
                             "   FROM ",cl_get_target_table(l_poy04,'rva_file'),",",
                                        cl_get_target_table(l_poy04,'rvb_file'),
                            #FUN-A10056--mod--end
                             "  WHERE rva01 = rvb01 ",
                             "    AND rva02 = '",l_pmm01,"'",   
                             "    AND (rvb30 IS NULL OR rvb30 = 0) " 
                 CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql     #FUN-A10056
                 PREPARE axmr850_p3 FROM l_sql
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                    EXIT PROGRAM
                 END IF
                 DECLARE axmr850_curs3 CURSOR FOR axmr850_p3
 
                 OPEN axmr850_curs3
                 INITIALIZE sr.* TO NULL
                 FETCH axmr850_curs3 INTO sr.*
 
                 IF cl_null(sr.rva01) THEN CONTINUE FOREACH END IF  #MOD-CA0150 remove #
                 LET sr.pmm22 = l_pmm22
                 LET sr.pmc03 = l_pmc03
                 LET sr.azp01 = l_poy04  
                 LET sr.pmm09 = l_pmm09
                 LET l_sql = " SELECT pmn31,pmn88,ima02",
                            #FUN-A10056--mod--str--
                            #"   FROM ",l_azp03 CLIPPED,"pmn_file, ",
                            #"        ",l_azp03 CLIPPED,"ima_file ",
                             "   FROM ",cl_get_target_table(l_poy04,'pmn_file'),",",
                                        cl_get_target_table(l_poy04,'ima_file'),
                            #FUN-A10056--mod--end
                             "  WHERE pmn01 = '",sr.rvb04,"'",   #採購單號
                             "    AND pmn02 = '",sr.rvb03,"'",
                             "    AND ima01 = '",sr.rvb05,"'"   
                 CALL cl_parse_qry_sql(l_sql,l_poy04) RETURNING l_sql     #FUN-A10056 
                 PREPARE axmr850_pmn_p1 FROM l_sql
                 IF SQLCA.sqlcode != 0 THEN
                    CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                    CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
                    EXIT PROGRAM
                 END IF
                 DECLARE axmr850_pmn_c1 CURSOR FOR axmr850_pmn_p1
 
                 OPEN axmr850_pmn_c1
                 FETCH axmr850_pmn_c1 INTO sr.pmn31,sr.pmn88,sr.ima02
                 INSERT INTO r850_tmp VALUES (sr.*)
             END FOREACH
         END FOREACH
     END IF
     #---依選擇的營運中心列印資料-----
     IF tm.plant = 'ALL' THEN 
         LET l_sql = " SELECT * FROM r850_tmp "
     ELSE
         LET l_sql = " SELECT * FROM r850_tmp ",
                     "  WHERE azp01 = '",tm.plant,"'"
     END IF
     PREPARE r850_tmp_p FROM l_sql
     IF SQLCA.sqlcode != 0 THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
        EXIT PROGRAM
     END IF
     DECLARE r850_tmp_c CURSOR FOR r850_tmp_p
     FOREACH r850_tmp_c INTO sr.*
#No.FUN-850018 --Begin
#        OUTPUT TO REPORT axmr850_rep(sr.*) 
         EXECUTE insert_prep USING sr.*
#No.FUN-850018 --End
     END FOREACH
     DELETE FROM r850_tmp
     #-----NO.MOD-7B0226 end----------------------------------------
#No.FUN-850018 --Begin
     LET g_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED
     IF g_zz05='Y' THEN 
          CALL cl_wcchp(tm.wc,'poz00,oea01,pmm01,pva06')
                 RETURNING tm.wc
     ELSE 
          LET tm.wc=""
     END IF
     LET g_str = tm.wc
     CALL cl_prt_cs3('axmr850','axmr850',g_sql,g_str)
#No.FUN-850018 --End
     #-----NO.MOD-7B0226 mark----------------------------------------
#     LET l_sql = "SELECT oea904,oea99,oea01,pmm01,rva99 ",
#                 " FROM oea_file,pmm_file,poz_file,rva_file ",
#                 " WHERE oea99 = pmm99 ",
#                 "   AND rva02 = pmm01 ",
#                 "   AND oea904 = poz01 ",
#                 #"   AND poz00 = '",tm.poz00,"'",
#                 "   AND ",tm.wc
#     PREPARE r850_p1 FROM l_sql
#     IF SQLCA.sqlcode != 0 THEN
#        CALL cl_err('prepare:',SQLCA.sqlcode,1)
         CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD 
#        EXIT PROGRAM
#     END IF
#     DECLARE r850_curs1 CURSOR FOR r850_p1
#     CALL cl_outnam('axmr850') RETURNING l_name
#     START REPORT axmr850_rep TO l_name
#     LET l_ac = 1
#     FOREACH r850_curs1 INTO g_arr[l_ac].oea904,
#                             g_arr[l_ac].oea99,
#                             g_arr[l_ac].oea01,
#                             g_arr[l_ac].pmm01,
#                             g_arr[l_ac].rva99
#         IF SQLCA.sqlcode != 0 THEN
#            CALL cl_err('prepare:',SQLCA.sqlcode,1) 
             CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
#            EXIT PROGRAM
#         END IF
#         LET l_ac = l_ac + 1
#     END FOREACH
#     CALL g_poy.deleteElement(l_ac)
#     LET k = g_arr.getLength()       
#     FOR j = 1 TO (k-1) 
#         IF tm.plant = 'ALL' THEN
#             #--先取出設定的資料庫有哪些--
#             LET l_sql = "SELECT UNIQUE poy02,poy04,poy05,''",
#                         "  FROM poy_file ",
#                         " WHERE poy01 = '",g_arr[j].oea904,"'",
#                         " ORDER BY poy02"
#             PREPARE r850_poy FROM l_sql
#             IF SQLCA.sqlcode != 0 THEN
#                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
#                EXIT PROGRAM
#             END IF
#             LET i = 1
#             DECLARE r850_poy_c CURSOR FOR r850_poy
#             FOREACH r850_poy_c INTO l_poy02,l_poy04,l_poy05
#                 SELECT azp03 INTO l_azp03 FROM azp_file
#                  WHERE azp01 = l_poy04
#                 IF DB_GET_DATABASE_TYPE() = 'IFX' THEN
#                    LET l_azp03 = l_azp03 CLIPPED,':'
#                 ELSE
#                    LET l_azp03 = l_azp03 CLIPPED,'.'
#                 END IF
#                 #--依據流程設定的資料庫，抓出收貨單資料 
#                 LET l_sql = " SELECT rva01,rva05,rvb02,rvb03,rvb04,rvb05,rvb07,rvb30,rva99 ",
#                             "   FROM ",l_azp03 CLIPPED,"rva_file,",
#                             "        ",l_azp03 CLIPPED,"rvb_file",
#                             "  WHERE rva01 = rvb01 ",
#                             "    AND rva99 = '",g_arr[j].rva99,"'",
#                             "    AND (rvb30 IS NULL OR rvb30 = 0) " 
#                 PREPARE axmr850_p2 FROM l_sql
#                 IF SQLCA.sqlcode != 0 THEN
#                    CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                     CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
#                    EXIT PROGRAM
#                 END IF
#                 DECLARE axmr850_curs2 SCROLL CURSOR FOR axmr850_p2
#                 FOREACH axmr850_curs2 INTO sr.*
#                    IF SQLCA.sqlcode != 0 THEN
#                       CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                       CONTINUE FOREACH
#                    END IF
#                    LET sr.poy04= l_poy04
#                    LET sr.poy05= l_poy05
#                    SELECT pmn31,pmn88 
#                      INTO sr.pmn31,sr.pmn88
#                      FROM pmn_file
#                     WHERE pmn01 = sr.rvb04
#                       AND pmn02 = sr.rvb03
#                    SELECT pmc03 INTO sr.pmc03 
#                      FROM pmc_file
#                     WHERE pmc01 = sr.rva05
#                    SELECT ima02 INTO sr.ima02
#                      FROM ima_file
#                     WHERE ima01 = sr.rvb05
#                    OUTPUT TO REPORT axmr850_rep(sr.*)
#                END FOREACH
#             END FOREACH
#         ELSE
#             SELECT azp03 INTO l_azp03 FROM azp_file
#              WHERE azp01 = tm.plant
#             IF DB_GET_DATABASE_TYPE() = 'IFX' THEN
#                LET l_azp03 = l_azp03 CLIPPED,':'
#             ELSE
#                LET l_azp03 = l_azp03 CLIPPED,'.'
#             END IF
#             #--依據流程設定的資料庫，抓出收貨單資料 
#             LET l_sql = " SELECT rva01,rva05,rvb02,rvb03,rvb04,rvb05,rvb07,rvb30,rva99 ",
#                         "   FROM ",l_azp03 CLIPPED,"rva_file,",
#                         "        ",l_azp03 CLIPPED,"rvb_file",
#                         "  WHERE rva01 = rvb01 ",
#                         "    AND rva99 = '",g_arr[j].rva99,"'",
#                         "    AND (rvb30 IS NULL OR rvb30 = 0) " 
#             PREPARE axmr850_p3 FROM l_sql
#             IF SQLCA.sqlcode != 0 THEN
#                CALL cl_err('prepare:',SQLCA.sqlcode,1) 
                 CALL cl_used(g_prog,g_time,2) RETURNING g_time  #FUN-B80089    ADD
#                EXIT PROGRAM
#             END IF
#             DECLARE axmr850_curs3 SCROLL CURSOR FOR axmr850_p3
#             FOREACH axmr850_curs3 INTO sr.*  
#                IF SQLCA.sqlcode != 0 THEN
#                   CALL cl_err('foreach:',SQLCA.sqlcode,1)
#                   CONTINUE FOREACH
#                END IF
#                LET sr.poy04= l_poy04
#                LET sr.poy05= l_poy05
#                SELECT pmn31,pmn88 
#                  INTO sr.pmn31,sr.pmn88
#                  FROM pmn_file
#                 WHERE pmn01 = sr.rvb04
#                   AND pmn02 = sr.rvb03
#                SELECT pmc03 INTO sr.pmc03 
#                  FROM pmc_file
#                 WHERE pmc01 = sr.rva05
#                SELECT ima02 INTO sr.ima02
#                  FROM ima_file
#                 WHERE ima01 = sr.rvb05
#                OUTPUT TO REPORT axmr850_rep(sr.*)
#             END FOREACH
#         END IF
#     END FOR
     #-----NO.MOD-7B0226 mark----------------------------------------
#    FINISH REPORT axmr850_rep                      #No.FUN-850018 
#    CALL cl_prt(l_name,g_prtway,g_copies,g_len)    ##No.FUN-850018 
END FUNCTION
 
#No.FUN-850018 --Begin
#REPORT axmr850_rep(sr)
#  DEFINE  p_mode    LIKE type_file.chr1     # No.FUN-680137 VARCHAR(1)
#  DEFINE l_last_sw  LIKE type_file.chr1,     # No.FUN-680137 VARCHAR(1)
#         sr        RECORD
#                   azp01   LIKE azp_file.azp01,    #NO.MOD-7B0226
#                   rva01   LIKE rva_file.rva01,
#                   rva05   LIKE rva_file.rva05,
#                   rvb02   LIKE rvb_file.rvb02,
#                   rvb03   LIKE rvb_file.rvb03,
#                   rvb04   LIKE rvb_file.rvb04,
#                   rvb05   LIKE rvb_file.rvb05,
#                   rvb07   LIKE rvb_file.rvb07,
#                   rvb30   LIKE rvb_file.rvb30,
#                   rva99   LIKE rva_file.rva99,
#                   pmc03   LIKE pmc_file.pmc03,
#                   ima02   LIKE ima_file.ima02,
#                   poy04   LIKE poy_file.poy04,
#                   poy05   LIKE poy_file.poy05,
#                   pmn31   LIKE pmn_file.pmn31,
#                   pmn88   LIKE pmn_file.pmn88,
#                   pmm22   LIKE pmm_file.pmm22,   #NO.MOD-7B0226
#                   pmm09   LIKE pmm_file.pmm09    #NO.MOD-7B0226
#         END RECORD
# DEFINE  l_unqty   LIKE rvb_file.rvb07
 
# OUTPUT TOP MARGIN g_top_margin
#        LEFT MARGIN g_left_margin
#        BOTTOM MARGIN g_bottom_margin
#        PAGE LENGTH g_page_line
# #ORDER BY sr.poy04,sr.rva99
# ORDER BY sr.azp01,sr.rva99   #NO.MOD-7B0226
 
# FORMAT
#  PAGE HEADER
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1, g_company CLIPPED
#     PRINT
#     LET g_pageno = g_pageno + 1
#     LET pageno_total = PAGENO USING '<<<'
#     PRINT g_head CLIPPED,pageno_total
#     PRINT COLUMN ((g_len-FGL_WIDTH(g_x[11])-6)/2)+1
#     PRINT g_dash[1,g_len]
#     PRINT g_x[11],g_x[12],g_x[13],g_x[14],g_x[15],g_x[16],
#           g_x[17],g_x[18],g_x[19],g_x[20],g_x[21],g_x[22]
#     PRINT g_dash1
#     LET l_last_sw = 'n'
 
#  #NO.MOD-7B0226 start---
#  #BEFORE GROUP OF sr.poy04
#  #   PRINT COLUMN g_c[11],sr.poy04;
#  BEFORE GROUP OF sr.azp01
#     PRINT COLUMN g_c[11],sr.azp01;
#  #NO.MOD-7B0226 end------
 
#  ON EVERY ROW
#     LET l_last_sw = 'y'
#     LET l_unqty = sr.rvb07 - sr.rvb30 
#     #PRINT COLUMN g_c[12],sr.rva05 CLIPPED,
#     PRINT COLUMN g_c[12],sr.pmm09 CLIPPED,   #NO.MOD-7B0226
#           COLUMN g_c[13],sr.pmc03 CLIPPED,
#           COLUMN g_c[14],sr.rva99 CLIPPED,
#           COLUMN g_c[15],sr.rva01 CLIPPED,
#           COLUMN g_c[16],sr.rvb02 CLIPPED,
#           COLUMN g_c[17],sr.rvb05 CLIPPED,
#           COLUMN g_c[18],sr.ima02 CLIPPED,
#           COLUMN g_c[19],l_unqty CLIPPED,
#           #COLUMN g_c[20],sr.poy05 CLIPPED,
#           COLUMN g_c[20],sr.pmm22 CLIPPED,    #NO.MOD-7B0226
#           COLUMN g_c[20],sr.pmn31 USING '###,###,###,###,###,##&.#&' CLIPPED,
#           COLUMN g_c[21],sr.pmn88 USING '###,###,###,###,###,##&.#&'
 
#  ON LAST ROW
#     LET l_last_sw = 'y'
#     PRINT g_dash[1,g_len]
#     PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[7] CLIPPED  
 
#  PAGE TRAILER
#     IF l_last_sw = 'n' THEN
#        PRINT g_dash[1,g_len]
#        PRINT g_x[4] CLIPPED, COLUMN g_len-9, g_x[6] CLIPPED
#     ELSE
#        SKIP 2 LINE
#     END IF
 
#END REPORT
#No.FUN-850018 --End 
#No.FUN-870144
